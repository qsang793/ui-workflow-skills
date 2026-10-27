---
name: ui-scenario-picker
description: Use at the start of UI improvement work — when user asks to "redesign", "make UI nicer", "add a dashboard", or generally wants to change how a project looks. Picks scenario A (greenfield), B (brownfield + stack migration), or C (brownfield + keep stack). Wrong scenario wastes weeks of work.
---

# UI Scenario Picker

## Overview

Three UI improvement scenarios. Picking the wrong one is the most expensive early mistake — scenario B when C would do = 3-6 weeks instead of 1.

## When to Use

- User asks to improve, redesign, modernize, or add UI
- Start of any UI engagement with a non-technical stakeholder
- Before invoking any other ui-* skill in this workflow

## When NOT to Use

- The user has already explicitly chosen a path and named the target stack
- Pure backend or bug-fix work

## The Three Scenarios

|  | A. Greenfield | B. Migrate stack | C. Keep stack |
|---|---|---|---|
| FE already exists? | No | Yes | Yes |
| Change FE stack? | n/a | Yes | No |
| Typical effort | 1–2 weeks | 3–6 weeks | 3–7 days |
| Best when | New project | Existing FE is legacy / blocked | FE works, looks dated |

## Process

Reply in the language of the Stakeholder's latest message (Vietnamese in, Vietnamese out). Questions, explanations and the output block all follow it; only the field keys stay English.

### 0. Read the Workflow state

If `.ui-workflow/state.md` exists and records a Scenario other than `none`, tell the Stakeholder which Scenario is recorded and its Current step, and ask whether to start over. Continue only on yes; otherwise point to the Current step's command.

### 1. Check filesystem yourself first

Don't ask the user something `ls` can answer. Look for:
- `package.json` (read deps to detect framework). **If missing**, fall back to file-extension scan — that alone is sufficient.
- `*.html`, `*.tsx`, `*.jsx`, `*.vue`, `*.svelte` files
- Folders: `dashboard/`, `frontend/`, `web/`, `client/`, `app/`, `static/`

**Partial-migration detection**: if you find BOTH framework code (e.g. `.tsx` files) AND raw vanilla JS / Jinja templates in the same repo, **escalate to the Developer** instead of picking a Scenario. This is a half-finished migration and the Stakeholder cannot make a clean A/B/C choice on it. Do not ask the Scenario questions, and do not recommend a Scenario or which frontend to keep, not even as a default: that is the Developer's decision. Write the escalation Workflow state (step 4), tell the Stakeholder what you found (both kinds of files, with paths) and that a Developer must decide which frontend stays, then stop.

### 2. Ask one question at a time

Never dump multiple questions in one message — the user gives lazy answers when overwhelmed.

**Q1** (only if FE existence is genuinely unclear from filesystem):
> "Does your project already have a working frontend that users see today?"
- No → **Scenario A**, stop here.

**Q2:**
> "Are you happy keeping the current frontend technology, or open to switching to something like React / Next.js?"
- Keep → **Scenario C**, stop here.
- Switch → continue to Q3.
- **"I don't know"** → don't push. Reply with this teach-then-re-ask:
  > "Keeping the stack means a polish-only redesign — usually 3-7 days. Switching means rewriting the frontend in a modern framework like React — usually 3-6 weeks. Polish keeps everything that works today; switching may break things and require re-testing every flow. Given that, which sounds closer to what you want?"
  - Then re-ask Q2. If still uncertain → default to **C** and note "user uncertain — chose safer option".

**Q3** (only when user wants to switch):
> "A stack migration usually takes 3–6 weeks and rewrites the whole frontend. Do you have that time and budget, or would scenario C (polish current UI in ~1 week) be enough?"
- Confirm migration → **Scenario B**.
- Switch back → **Scenario C**.

### 3. Default bias

When in doubt, recommend **C**. It is the cheapest, fastest, and reversible. Migrating a stack you didn't need to migrate is an irreversible time sink.

### 4. Write the Workflow state

Create `.ui-workflow/state.md` at the project root (create the folder if missing). Every field is present; a field with no value is `none`.

```markdown
# UI Workflow state

- Scenario: <A | B | C>
- Scenario reason: <one sentence citing what you saw in the files>
- Maturity: <Production for C | Beta for A and B>
- Design tool: none
- Current step: <audit for B and C | brief for A>
- Completed steps: picker
- Work branch: none
- Stakeholder language: <the Stakeholder's language, named in English, e.g. Vietnamese>
- Blocked: none
- Updated: <YYYY-MM-DD> by ui-scenario-picker
```

On escalation, write the same file with `Scenario: none`, `Maturity: none`, `Current step: picker`, `Completed steps: none` and `Blocked: <what you found>; a Developer must decide`. An escalation never completes the picker step.

## Output

Return this block, translated into the Stakeholder's language except the commands:

```
Scenario: <A | B | C> (<Production | Beta>)
Why: <one sentence justification, referencing what you saw on the filesystem>
Next step: <B, C: /ui-workflow-skills:ui-audit | A: /ui-workflow-skills:design-brief>
Saved: .ui-workflow/state.md
```

For A and B, add one line saying the Scenario is Beta: its skills have not passed a real end-to-end run yet, so expect rough edges and a Developer check before release.

## Common Mistakes

- **Asking all 3 questions in one wall of text.** One at a time, wait for answer.
- **Recommending B because it "sounds more modern".** B is the most expensive option. Only choose B when the existing FE genuinely blocks improvement (e.g. unsupported framework, unbuildable).
- **Leaving the choice only in chat.** Without `.ui-workflow/state.md` a new session loses the Scenario and every later skill stops.
- **Skipping the filesystem check.** Asking "do you have a frontend?" when `ls` already shows an `index.html` or framework files wastes the user's time.

## Red Flags — Stop and Re-check

- About to recommend B and you haven't read `package.json` → check first.
- User says "I want it modern" → that's not enough to justify B. Probe for what's blocking C.
- You haven't seen a single FE file but you're about to pick A → run `find . -name '*.html' -o -name '*.tsx' | head` first.

## Related Skills

- `ui-audit` — runs next for scenarios B and C
- `design-brief` — runs after audit (or first, for scenario A)
- Workflow state format and step order: `docs/workflow-contract.md` in this bundle
