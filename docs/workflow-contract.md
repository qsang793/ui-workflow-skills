# Workflow contract

What the skills hand each other. Every skill restates the parts it needs, so it works on its own once installed. This page is the reference those restatements must agree with.

## Workflow folder

One folder at the project root:

```
.ui-workflow/
  state.md              Workflow state (committed on the Work branch)
  audit.md              written by ui-audit (committed)
  design-prompt.md      written by design-brief (committed)
  integration-plan.md   written by integration-planner (committed)
  export/               Design export, staged by ingest-design-export (git-ignored)
  export-backup-*/      earlier Design exports (git-ignored)
```

## Workflow state

File: `.ui-workflow/state.md`. One `- Key: value` line per field. Keys and step names stay in English so every skill can read them.

```markdown
# UI Workflow state

- Scenario: C
- Scenario reason: FastAPI serves Jinja templates with vanilla JS; Stakeholder wants to keep the stack.
- Maturity: Beta
- Design tool: none
- Current step: audit
- Completed steps: picker
- Work branch: none
- Stakeholder language: Vietnamese
- Blocked: none
- Updated: 2026-10-27 by ui-scenario-picker
```

| Field | Values |
|---|---|
| Scenario | `A`, `B`, `C`, or `none` |
| Scenario reason | One sentence citing what the picker saw in the files |
| Maturity | `Beta` for every Scenario until Scenario C passes its end-to-end pilot, then `Production` for C; `none` with no Scenario |
| Design tool | `Lovable`, `Google AI Studio`, or `none` |
| Current step | The step to run next, the step that stopped, or `done` once the Preview is approved |
| Completed steps | Comma-separated step names in run order, or `none` |
| Work branch | `ui-workflow/<yyyy-mm-dd>`, or `none` |
| Stakeholder language | The language the Stakeholder writes in, named in English (`English`, `Vietnamese`) |
| Blocked | `none`, or one line: the reason and that a Developer must decide |
| Updated | `<yyyy-mm-dd> by <skill>` |

A field with no value yet is written as `none`. Never leave a field out and never leave it blank.

## Steps

| Step | Command | A | B | C |
|---|---|---|---|---|
| picker | `/ui-workflow-skills:ui-scenario-picker` | required | required | required |
| audit | `/ui-workflow-skills:ui-audit` | skipped | required | required |
| brief | `/ui-workflow-skills:design-brief` | required | required | required |
| ingest | `/ui-workflow-skills:ingest-design-export` | required | required | required |
| planner | `/ui-workflow-skills:integration-planner` | skipped | required | required |
| port | `/ui-workflow-skills:design-port` | n/a | n/a | required |
| wire | `/ui-workflow-skills:integration-wire` | required | required | n/a |
| preview | `/ui-workflow-skills:preview-deploy` | required | required | required |

So the order is:

- A (Beta): picker → brief → ingest → wire → preview
- B (Beta): picker → audit → brief → ingest → planner → wire → preview
- C (Beta until its pilot passes): picker → audit → brief → ingest → planner → port → preview

Scenario A skips audit and planner by design. A skipped step is never reported as missing.

## Who writes what

| Skill | Writes |
|---|---|
| `ui-scenario-picker` | Creates the file. Sets every field: Scenario, Scenario reason, Maturity, Stakeholder language, Completed steps `picker`, Current step = the next step for the Scenario, the rest `none`. |
| `design-brief` | Design tool |
| First skill that changes project code (`design-port`, `integration-wire`) | Work branch |
| Every skill, on success | Appends its step to Completed steps, sets Current step to the next step for the Scenario, sets Blocked to `none`, updates Stakeholder language if the Stakeholder switched, sets Updated |

A STOP, a Scenario mismatch or an escalation never marks a step as completed. The skill leaves Completed steps as they were, sets Current step to its own step and writes the reason in Blocked. When the picker escalates (for example, a half-finished framework migration), it still writes the file, with Scenario `none`, Maturity `none`, Completed steps `none`, Current step `picker` and the reason in Blocked, so a new session sees why the workflow stopped.

## Before acting

Every skill except the picker reads `.ui-workflow/state.md` first and stops with a short message in the Stakeholder's language when:

1. The file is missing: the picker has not run. Name the step and its command, `/ui-workflow-skills:ui-scenario-picker`.
2. Blocked is not `none` and Current step is another step: repeat the reason and say a Developer must decide. Re-running the step that stopped is allowed.
3. Its step does not belong to the Scenario (`ui-audit` under A, `design-port` under B): say so and give the command for the recorded Current step.
4. An earlier step of the Scenario is not in Completed steps: name the first missing step and its command. Never guess its output.

The picker reads the file too. If a Scenario is already recorded, it says which one and asks whether to start over before replacing the file.

## Language

- Every skill replies in the language of the Stakeholder's latest message. If that is unclear, it uses Stakeholder language from the Workflow state.
- The audit and the integration plan are written in the Stakeholder's language, but their headings and field keys stay as below so other skills can read them.
- The Design prompt is always English. UI copy follows the project's existing language.

## Handoff formats

These are the minimum each file must contain. Skills may add sections.

### Audit summary (`.ui-workflow/audit.md`)

```markdown
# UI Audit — <project> (<yyyy-mm-dd>)

## Stack
- Framework: <...>
- CSS: <...>
- Design tokens: <file of the :root custom-property block | none>

## Pages / Routes
- <page or view> — <file>

## Pain points
### 🔴 High
- <item>
### 🟡 Medium
- <item>
### 🟢 Low
- <item>

## Recommendation
<one sentence: confirm or revise the Scenario>
```

At most five bullets under each severity. An empty severity has the single bullet `- none`.

### Planner verdict (`.ui-workflow/integration-plan.md`)

```markdown
## Verdict: <PROCEED | PROCEED WITH CAUTION | STOP>

## Blockers
- <Blocker> | none

## Not checked
- <what the planner did not verify> | none

## Screens (Scenario C)
| Screen | Export file | Target template | Data it displays | Backend source |
```

The Verdict is `STOP` if and only if at least one Blocker is listed. A `STOP` plan is addressed to the Developer.

### `design-port` input

- `.ui-workflow/export/`: HTML and CSS only, no framework code and no JavaScript, one HTML file per screen. Interaction notes are HTML comments of the form `<!-- interaction: <plain-English behaviour> -->` next to the element they describe.
- `.ui-workflow/integration-plan.md`: Verdict `PROCEED` or `PROCEED WITH CAUTION` and a Screens table naming, per screen, the export file to Port and the existing template it replaces.
