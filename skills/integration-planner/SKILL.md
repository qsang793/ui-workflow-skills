---
name: integration-planner
description: Use after the Design export is staged at `.ui-workflow/export/` and before `design-port` (Scenario C) or `integration-wire` (Scenario B). Scenario C compares, per Screen, the data the design displays and the actions it offers with what the existing backend provides; Scenario B diffs API calls and auth. Writes `.ui-workflow/integration-plan.md` with a PROCEED / PROCEED WITH CAUTION / STOP verdict. Any Blocker means STOP for the Developer. Scenario A skips this step.
---

# Integration Planner

## Overview

The Design tool does not know the backend. It draws fields the backend may not have and buttons nothing behind them can do. This skill compares the design with the real backend and writes `.ui-workflow/integration-plan.md`. **If any Blocker exists, the Verdict is STOP and no later step may run.**

## When to Use

- After the Design export is staged at `.ui-workflow/export/` (by `/ui-workflow-skills:ingest-design-export`)
- Before any `design-port` (C) or `integration-wire` (B) work

## When NOT to Use

- Scenario A: there is no backend to diff against. Step 0 handles it.

## Process

Reply in the language of the Stakeholder's latest message; if unclear, use `Stakeholder language` from the Workflow state. Write the plan in that language too, but keep its headings, the Verdict values and the `decision:` values in English so other skills can read them.

### 0. Read the Workflow state

Read `.ui-workflow/state.md` at the project root before anything else. Take the Scenario from it, never from chat or the Design export. Stop with a short message, without doing anything else, when:

- The file is missing: say the Scenario has not been picked yet and give the command `/ui-workflow-skills:ui-scenario-picker`.
- `Blocked` is not `none` and `Current step` is another step: repeat the reason and say a Developer must decide first. Re-running the step that stopped is allowed.
- `Scenario` is `A`: say this step is skipped by design because there is no backend to plan against, and that the flow continues with the command for the recorded `Current step`. Write nothing.
- An earlier step of the Scenario is not in `Completed steps` (picker, audit, brief, ingest for both B and C). Name the first missing step and its command, and never guess its output.

When this step succeeds, append `planner` to `Completed steps` and set `Current step` to `port` (C) or `wire` (B). A STOP verdict is not a success, and neither is a `pending` decision: while one is pending, leave `Completed steps` as it is, set `Current step: planner` and keep `Blocked: none`, because the Stakeholder decides it, not a Developer. On success, also set `Blocked: none`, update `Stakeholder language` if the Stakeholder switched language, and set `Updated: <YYYY-MM-DD> by integration-planner`. A STOP, a mismatch or an escalation never completes the step: leave `Completed steps` as it is, set `Current step: planner` and write the reason in `Blocked`. Step commands: picker `/ui-workflow-skills:ui-scenario-picker`, audit `/ui-workflow-skills:ui-audit`, brief `/ui-workflow-skills:design-brief`, ingest `/ui-workflow-skills:ingest-design-export`, planner `/ui-workflow-skills:integration-planner`, port `/ui-workflow-skills:design-port`, wire `/ui-workflow-skills:integration-wire`, preview `/ui-workflow-skills:preview-deploy`.

If `.ui-workflow/export/` is missing, say the Design export is not staged, give `/ui-workflow-skills:ingest-design-export`, and stop. Do not search for other locations.

### 1. Read the Design export statically

The export may be in any framework (TanStack Start, React + Vite, Next, Angular) or plain HTML + CSS. It is a visual reference (ADR-0004): read its source only. **Never install, build or run it** (no `npm install`, no dev server), and never read `.env` files.

### 2. Backend inventory (B and C)

List what the existing backend provides, from its source:

- Routes: FastAPI `@app.` / `@router.` decorators, Flask `@app.route`, Django `urls.py`, Express `app.get(` / `router.`, NestJS `@Controller` / `@Get` / `@Post`.
- For each route: method, path, auth (dependency or middleware), and the fields it returns or accepts (return values, models, serializers, or the data it reads).
- Data the server already puts into templates (template context variables).

### 3. Scenario C: Screens, displayed data and actions

**Find the Screens from what the export renders**: routes, pages, and named views shown conditionally (tabs, steps, `view === 'x'` branches). Never from folder or file names. Export file is the source file that renders the Screen, followed by `#<view>` when that file renders several Screens (`src/routes/dashboard.tsx`, `src/App.tsx#settings`, `dashboard.html`). If you cannot tell what the Screens are, ask the Stakeholder which screens the design has before going on. Never guess.

For each Screen, list:

- **Data it displays**: every field the Screen shows. Mock data, fixtures and hard-coded sample lists are read as a list of displayed fields, never as values to keep.
- **Actions**: every control that does something beyond moving between Screens (buttons, forms, toggles, links that change data). Moving between Screens is not an action. Judge an action by what it is meant to do (its label and interaction intent), not by the export's handler: a button that fakes success with `alert` or local state still needs a backend.
- **Target template**: the existing template or page it replaces (from the audit's Pages / Routes).

Read `## Required behaviour` in `.ui-workflow/design-prompt.md`. Each existing screen has a `### <Screen> — <template file>` entry with `Shows:` (data and its source) and `Does:` (actions and the endpoint or code serving them); `### Stakeholder must-haves` lists what the Stakeholder named in the interview. A screen marked `(not redesigned)` keeps working as it is and gets no Screens row. If the section is missing, do not infer Required behaviour from the existing frontend: list Required behaviour under Not checked and tell the Stakeholder to re-run `/ui-workflow-skills:design-brief`.

Then compare with the backend inventory:

| Finding | Goes to |
|---|---|
| A displayed field the backend cannot supply | Blockers |
| Required behaviour the backend cannot supply | Blockers |
| An action that is not Required behaviour and has no backend | Needs Stakeholder decision |
| A field or action the backend supplies under another name or shape | Screens table, Backend source, with the mapping |

A field the frontend can compute from data the backend already returns (a count, a filter, a date format) is supplied. Required behaviour is never offered for dropping: if the backend cannot do it, it is a Blocker.

**Needs Stakeholder decision.** For each design-only action, ask the Stakeholder, in plain words, whether to drop it from the UI (the default) or show it disabled with a "coming soon" label. If the Stakeholder already said what to do with such buttons, apply it and do not ask again. Record the answer as `decision: drop` or `decision: disabled "coming soon"`. Until it is answered it stays `decision: pending`, and the step is not completed.

### 4. Scenario B: API calls and auth

Find the API calls in the export: `fetch(`, `axios.`, `useSWR(`, `useQuery(`, URLs starting with `/api/` or `http`. List mock data files (`mock.ts`, `mocks/`, `fixtures/`, `data/*.json`) separately as "needs replacing". For each call, record method, URL, request body and expected response shape, and compare with the backend inventory:

| Design export expects | Backend provides | Match? |
|---|---|---|
| `GET /api/users` | `GET /api/owners` | name differs: adapter |
| `POST /api/auth/login` (JWT bearer) | `POST /login` (session cookie) | auth pattern: Blocker |
| `GET /api/habits` → `{title, done}` | `GET /api/habits` → `{name, completed}` | shape differs: adapter |

Always check auth, even when every endpoint matches: what the export assumes (cookie, JWT in `Authorization`, session) against what the backend does (`Depends(get_current_user)`, Flask-Login, middleware). Incompatible auth, a missing endpoint the backend cannot add without a data model change, or a breaking schema is a Blocker. A rename or a shape map is an adapter.

### 5. Verdict

- `STOP` if and only if at least one Blocker is listed. A STOP plan is addressed to the Developer: say in the reply that the Stakeholder must show it to a Developer and that no later step may run.
- `PROCEED WITH CAUTION` when there is no Blocker but adapters are needed, or a displayed field or action could not be traced to the backend (listed under Not checked).
- `PROCEED` otherwise.

Report only what you found. Never invent issues to fill a section; an empty section is `- none`. List under Not checked everything you did not verify (a route you could not read, a field whose source you could not trace, auth you could not determine). Write `- none` there only if you checked everything.

### 6. Write the plan

File: `.ui-workflow/integration-plan.md`. Then update the Workflow state (step 0) and tell the Stakeholder the Verdict, any decision you still need from them, and the next command: `/ui-workflow-skills:design-port` (C) or `/ui-workflow-skills:integration-wire` (B) on success.

## Output Format

```markdown
# Integration Plan — <YYYY-MM-DD>

## Verdict: <PROCEED | PROCEED WITH CAUTION | STOP>

<One paragraph explaining the verdict. Cite the Blocker count.>

## Blockers
- <Screen>: <field or Required behaviour> | backend cannot supply it | <what is missing in the backend>
(or `- none`)

## Needs Stakeholder decision
- <Screen>: <design-only action> | backend missing | decision: <pending | drop | disabled "coming soon">
(or `- none`)

## Not checked
- <what the planner did not verify>
(or `- none`)

## Screens (Scenario C)
| Screen | Export file | Target template | Data it displays | Actions | Backend source |
|---|---|---|---|---|---|
| today | `src/App.tsx#today` | `app/templates/index.html` | title, due | Mark done | `GET /api/reminders`; `POST /api/reminders/{id}/done` |

## API calls (Scenario B)
| Design export expects | Backend provides | Match? |
|---|---|---|

## Auth pattern check (Scenario B)
- Design export assumes: <...>
- Backend provides: <...>
- Compatible? <yes | no, with note>

## Next step
<PROCEED: the next command. Decision pending: "Answer the decision above, then re-run /ui-workflow-skills:integration-planner." STOP: "Do NOT proceed. Show this plan to a Developer.">
```

One Screens row per Screen. Leave out the sections of the other Scenario.

## Critical Rules

- Any Blocker → Verdict `STOP`, Next step "show to a Developer", step not completed.
- A design-only action is never a Blocker and never silently kept: it waits for the Stakeholder's decision.
- Required behaviour is never dropped to fit the design.

Non-technical Stakeholders are tempted to skip past Blockers because the design looks good. Make stopping the loud default.

## Common Mistakes

- **Reading the export's mock values as real data.** They only tell you which fields the Screen shows.
- **Finding Screens from file names.** One `App.tsx` can hold several Screens; a `components/` file is not a Screen.
- **Classifying a design-only action as a Blocker,** or a Required behaviour as a design-only action.
- **Under-counting auth mismatches (B).** Auth changes are almost always Blockers.
- **Treating "endpoint name differs" as a Blocker.** That is an adapter.
- **Writing "Not checked: none" without having checked.** Say what you skipped.

## Red Flags — Stop and Re-check

- You said PROCEED but did not trace every displayed field to a backend source → trace it or list it under Not checked.
- You said PROCEED (B) but did not check auth → check now.
- You ran `npm install` or started the export → stop; read the source only.
- A decision is `pending` and you marked the step completed → undo it.

## Related Skills

- `ingest-design-export` — predecessor
- `design-port` — runs next for Scenario C (if not STOP)
- `integration-wire` — runs next for Scenario B (if not STOP)
- `preview-deploy` — final step
