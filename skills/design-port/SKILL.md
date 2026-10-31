---
name: design-port
description: Use for Scenario C only, after integration-planner returned PROCEED or PROCEED WITH CAUTION — Ports the Design export (any framework or plain HTML + CSS, read as a visual reference, never installed or run) into the project's existing templates and styles, one Screen per turn on the Work branch. Shows each Screen in the locally running app, waits for the Stakeholder's approval, then commits only that Screen. Never pushes or merges.
---

# Design Port

## Overview

In Scenario C the project keeps its stack. The Design export is a visual reference (ADR-0004): this skill reads its source, rebuilds the look of **one Screen per turn** in the project's existing templates and styles, shows it in the running app, and commits it to the Work branch once the Stakeholder approves.

## When to Use

- Scenario C, after `integration-planner` returned `PROCEED` or `PROCEED WITH CAUTION`
- Each time the Stakeholder approves, or asks to change, the last Ported Screen

## When NOT to Use

- Scenarios A and B (use `integration-wire`)
- `integration-planner` returned `STOP` or left a decision `pending`

## Process

Reply in the language of the Stakeholder's latest message; if unclear, use `Stakeholder language` from the Workflow state.

### 0. Read the Workflow state

Read `.ui-workflow/state.md` at the project root before anything else. Take the Scenario from it, never from chat or the Design export. Stop with a short message, without doing anything else, when:

- The file is missing: say the Scenario has not been picked yet and give the command `/ui-workflow-skills:ui-scenario-picker`.
- `Blocked` is not `none` and `Current step` is another step: repeat the reason and say a Developer must decide first. Re-running the step that stopped is allowed.
- `Scenario` is not `C`: say this step is for Scenario C only and give the command for the recorded `Current step`.
- `Completed steps` lacks `planner`. Name the first missing step and its command, and never guess its output.
- `.ui-workflow/integration-plan.md` has Verdict `STOP` or a `decision: pending`: say the planner must be settled first and give its command.

The step succeeds only after the Stakeholder approves the last Screen (step 6). Then append `port` to `Completed steps`, set `Current step: preview`, `Blocked: none`, update `Stakeholder language` if the Stakeholder switched language, and set `Updated: <YYYY-MM-DD> by design-port`. A STOP, a mismatch or an escalation never completes the step: leave `Completed steps` as it is, set `Current step: port` and write the reason in `Blocked`. Step commands: picker `/ui-workflow-skills:ui-scenario-picker`, audit `/ui-workflow-skills:ui-audit`, brief `/ui-workflow-skills:design-brief`, ingest `/ui-workflow-skills:ingest-design-export`, planner `/ui-workflow-skills:integration-planner`, port `/ui-workflow-skills:design-port`, wire `/ui-workflow-skills:integration-wire`, preview `/ui-workflow-skills:preview-deploy`.

### 1. Get on the Work branch

Every change of this run lives on one Work branch, `ui-workflow/<yyyy-mm-dd>`.

1. The project must be a git repository (`git rev-parse --is-inside-work-tree`). If it is not, stop and escalate: a Developer must set up git first.
2. Run `git status --porcelain` before changing anything. On the first run, every path it lists outside `.ui-workflow/` is the Stakeholder's own uncommitted change, except the `.ui-workflow/` lines earlier steps added to `.gitignore`; in later turns, every such path that is not a file of the Screen awaiting approval is. Never stage, commit, stash, reset or check out those paths.
3. If `Work branch` in the state names a branch, switch to it (`git switch <branch>`); if that fails or the branch is gone, stop and escalate to the Developer. Otherwise create `ui-workflow/<today>` from the current commit (`git switch -c ui-workflow/<today>`); uncommitted changes come along untouched. If that name already exists and the state does not name it, ask the Developer before using it.
4. As soon as you are on it, write the branch into `Work branch` and set `Updated`.

Never commit while the current branch (`git branch --show-current`) is anything but the Work branch. Never push, merge, rebase or open a pull request: the Developer does that.

### 2. Settle the last Screen, then pick the next one

The Screens and their order come from the Screens table of `.ui-workflow/integration-plan.md`. A Screen is done when the Work branch has its commit, `ui-workflow: port <Screen>` (`git log --oneline`).

If a Screen was Ported and shown but is not committed yet, read the Stakeholder's latest message first:

- They approve it: commit it (step 5), then go on with the next Screen.
- They ask for changes, even alongside an approval: change the same Screen, show it again (steps 3–4) and wait. Do not start another Screen.
- Anything else: remind them which Screen waits for approval and where to see it, and stop.

Then take the first Screen of the table that is not done. **One Screen per turn**: never Port two Screens before the Stakeholder approves the first.

### 3. Port the Screen

> **Extraction rules — pending #18 (spike: Port one Screen from a real Lovable export).** How style values, Tailwind classes, design tokens, icons, screenshots and substitutes are read from the export and rebuilt is not written yet. Until then, rebuild the Screen's look in the project's existing templates and stylesheet, and report every value you were unsure of.

Whatever the extraction rules turn out to be, these hold:

- Read the export's source only (`.ui-workflow/export/`). Never install, build or run it. Never read `.env` files.
- Change only what this Screen needs: its target template, the project's existing stylesheets and front-end scripts, and static assets. Never change backend code. If a file you need is among the Stakeholder's uncommitted changes from step 1, stop and ask the Developer to commit or set them aside first.
- The data is the backend source named in the Screens table, fetched through the project's existing fetch code. Design-only actions follow the plan's decision (dropped, or disabled with a "coming soon" label); an action the plan does not list stops the Screen and is asked about. Required behaviour works as it does today, and no control looks active without working.
- No Tailwind classes in a project that does not already use Tailwind. No new dependency.

### 4. Show it in the running app

The Stakeholder approves a Screen only after seeing it in the project's own app, run locally.

1. Read the `Run` line under `## Stack` in `.ui-workflow/audit.md` (`- Run: <command> → <local URL>`). If it says `unknown` or is missing, find the command in the project (`package.json` scripts, `README`, `Procfile`, `uvicorn`/`flask`/`manage.py` entry points), tell the Developer the command you found and wait for them to confirm it.
2. Start the app in the background with that command, or, if the app you started for an earlier Screen is still running and does not reload changes on its own, restart it. Wait until the local URL answers. Do not install anything to make it run.
3. If it does not start, stop and escalate: tell the Stakeholder a Developer must get the app running (never give them a command to run or a package to install), show the error output for the Developer, and write the reason in `Blocked`. Leave the Screen uncommitted.
4. Give the Stakeholder the URL of this Screen: the local URL plus its route, or how to reach the view (for example the tab to click).

Never deploy a Screen. The check on a phone comes later, in the Preview step (`/ui-workflow-skills:preview-deploy`).

### 5. Report, wait, commit

The Screen's report is in the language of the Stakeholder's latest message, even when `Stakeholder language` in the state says otherwise. It gives:

- the Screen and its local URL
- the files you changed for it
- the decisions applied (design-only actions dropped or disabled)
- substitutes, and what was not reproduced visually
- the question: approve this Screen, or what to change?

Then stop and wait. Commit only after the Stakeholder approves:

- Stage by path, never `git add -A`, `git add .` or `git commit -a`: the files this Screen changed (from its report; in a new session, the uncommitted front-end files that belong to this Screen, asking when unsure) and the workflow documents that are new or changed, `.ui-workflow/state.md`, `audit.md`, `design-prompt.md`, `integration-plan.md` (skip any that git ignores), and `.gitignore` when its only uncommitted change is the workflow's `.ui-workflow/` lines. Never the Stakeholder's own changes, never `.ui-workflow/export/` or `preview.md`.
- For the last Screen, first update the Workflow state as in step 0, so the commit carries it.
- `git commit -m "ui-workflow: port <Screen>"`. Do not skip hooks. If the commit fails, show the Developer the error, undo a completion you just wrote (`Current step: port`, `port` out of `Completed steps`), write the reason in `Blocked` and stop.

### 6. Next Screen, or finish

After the commit, Port the next Screen (step 3) in the same turn. After the last Screen's commit, stop the app you started, then tell the Stakeholder every Screen is on the Work branch, nothing was pushed, and the next command is `/ui-workflow-skills:preview-deploy`.

## Critical Rules

- **One Screen per turn.** Wait for the Stakeholder's approval between Screens.
- **Work branch only.** Never commit to the main branch; never push or merge.
- **One commit per approved Screen**, holding only that Screen and its workflow documents, never the Stakeholder's own changes.
- **Seen before approved.** Each Screen is shown in the locally running app. No deploy per Screen.
- **The export is never run.** Read its source; no install, build or run.
- **No new dependencies**, icon packages included.

## Common Mistakes

- **Porting several Screens in one go.** One, then wait.
- **`git add -A` or `git commit -a`.** It sweeps in the Stakeholder's own uncommitted work.
- **Committing before approval**, or approving on the Stakeholder's behalf.
- **Installing packages to get the app running.** Escalate to the Developer instead.
- **Inventing the run command.** Use the audit's `Run` line, or confirm a detected one with the Developer.

## Related Skills

- `integration-planner` — must return PROCEED first; its Screens table drives the order
- `ui-audit` — records the `Run` line used to show each Screen
- `preview-deploy` — runs after the last Screen is approved
