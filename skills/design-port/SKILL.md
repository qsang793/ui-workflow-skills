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

If `Blocked` says a Screen was Ported but the app did not start, its uncommitted files are that Screen's, not the Stakeholder's. Go to step 4 and show it, without Porting it again.

If a Screen was Ported and shown but is not committed yet, read the Stakeholder's latest message first:

- They approve it: commit it (step 5), then go on with the next Screen.
- They ask for changes, even alongside an approval: change the same Screen, show it again (steps 3–4) and wait. Do not start another Screen.
- Anything else: remind them which Screen waits for approval and where to see it, and stop.

Then take the first Screen of the table that is not done. **One Screen per turn**: never Port two Screens before the Stakeholder approves the first.

### 3. Port the Screen

These hold throughout:

- Read the export's source only (`.ui-workflow/export/`). Never install, build or run it. Never read `.env` files.
- Change only what this Screen needs: its target template, the project's existing stylesheets and front-end scripts, and static assets. Never change backend code. If a file you need is among the Stakeholder's uncommitted changes from step 1, stop and ask the Developer to commit or set them aside first.
- The data is the backend source named in the Screens table, fetched through the project's existing fetch code. Design-only actions follow the plan's decision (dropped, or disabled with a "coming soon" label); an action the plan does not list stops the Screen and is asked about. Required behaviour works as it does today, and no control looks active without working.
- No Tailwind classes in a project that does not already use Tailwind. No new dependency.

Read the look from the export, then rebuild it in the target template and the project's stylesheet. Every value ends up resolved, substituted or asked about; keep a list of the substitutes for the report.

**Sources.** The Screen's Export file and the components it imports, to see what they render. The export's Tailwind config (`tailwind.config.*`, an inline `tailwind.config`, or `@theme` in its CSS), global CSS, CSS variables and font links. Its state, hooks, handlers and mock data, only to understand states and meaning: the export's runtime stays out of the project. The project's tokens and stylesheet.

**Screenshot.** When `.ui-workflow/export/screenshots/<screen>.png` exists (name in lowercase with hyphens), read it. It checks the layout and settles values the source does not. When the source does settle a value, the source wins. What only the picture shows, such as an effect baked into an image, goes in the report as not reproduced.

**Markup.** Keep the element tree, semantic tags and order the export renders. Rebuild components as the project's plain markup, reading each to see its output.

**Style values.** Output is CSS in the project's existing stylesheet structure (Tailwind classes only if the project already uses Tailwind). Plain CSS is read as is. The Screen's container width and breakpoints apply even when they sit on a page shell other Screens share: change the shell and report what the others inherit. Resolve each Tailwind class in this order: an arbitrary value as written, the export's config, its CSS variables, Tailwind's default scale. A config entry replaces the default meaning: `rounded-full` may be `0.75rem`. Three Tailwind assumptions to apply:

- Version: read it from the export's `package.json` or lockfile. The default scale is not in the export, so when no version is pinned (a CDN script), pick one and name it in the report.
- Class order is not CSS order. When two utilities set one property, the order inside `class` does not decide it. `tracking-*`, `leading-*` and `font-*` override what a custom `fontSize` sets.
- Filters compose in a fixed order, whatever the class order: blur, brightness, contrast, grayscale, hue-rotate, invert, saturate, sepia, drop-shadow.

**Tokens.** Map colours, spacing, fonts, radii, shadows and breakpoints onto the project's existing tokens first. Add a token only when none matches. Then check what the mapping did:

- Contrast: compute the ratio of every mapped foreground and background pair with a short script, dots, lines and borders included; an estimate by eye does not count. Text needs 4.5:1 (large text 3:1), other visible parts 3:1. For a pair below that, take another existing token, or treat it as a usability value (below). Report when several surface steps collapsed into one token.
- Fonts by face: compare the styles and weights the export loads and uses with the files the project has, not just the family name. A missing italic or weight is drawn synthetically by the browser; report it as a substitute. Add a font link only when no project font fits the role and the project's content security policy allows it, and name it in the report.

**Copy.** Carry labels, headings, placeholders, empty and error text, in the project's existing language. Text that comes from data is replaced by the backend field the Screens table names; mock values never reach the project.

**Claims of fact are placeholders.** Sources, reference codes, counts, statistics, dates, credits, testimonials and verification badges in the export are design filler, however real they sound. They enter the project only through a field the Screens table names. Leave out the rest and list it in the report.

**States.** Rebuild hover, focus, disabled, active, open, empty, loading and error as far as the export shows them, class strings inside handlers and scripts included. Every control keeps a visible focus style, even where the export removes it.

**Interaction intent.** Write down in plain English what each handler or `<!-- interaction: <behaviour> -->` comment does, then build it in the project's existing style if it is Required behaviour. Rewrite from the intent; export code is never pasted or translated.

**Icons.** Use the matching icon of the project's existing set, else inline SVG: from the export, or from the icon library's published static SVG, with library and licence named in the report. If you cannot get the SVG, use a text label or a plain glyph and report it as a substitute. No icon package or icon font.

**Images.** An export's image may be a placeholder or generated, even when it is labelled a real photo or record. Show the image from a field the Screens table names, or the project's own; otherwise keep the slot as a plain surface. Report what the export had and how it was labelled, and ask in the report whether to use it. Copy it into the project's existing static folder only after the Stakeholder says yes.

**Values you cannot resolve** (from runtime code, a missing file, CSS-in-JS, a Tailwind plugin):

- Layout or usability (widths, breakpoints, contrast, hit areas): the screenshot settles it, or you ask before going on.
- Anything else: use the project's default token for that role and report it as a substitute.

**Before you show it.** Remove the CSS rules this Screen's rebuild left unused, after checking that no template or script still uses them; rules another Screen uses stay. Then look for the project's own checks (a tests folder, package scripts, a Makefile, CI config) and run those that work without installing anything. Fix what the Port broke; report what passed, what still fails and what could not run. To tell whether a failure is the Port's, read the failure and `git diff` with the working tree as it is: a stash would sweep up the Stakeholder's changes.

### 4. Show it in the running app

The Stakeholder approves a Screen only after seeing it in the project's own app, run locally.

1. Read the `Run` line under `## Stack` in `.ui-workflow/audit.md` (`- Run: <command> → <local URL>`). If it says `unknown` or is missing, find the command in the project (`package.json` scripts, `README`, `Procfile`, `uvicorn`/`flask`/`manage.py` entry points), tell the Developer the command you found and wait for them to confirm it.
2. Start the app in the background with that command, or, if the app you started for an earlier Screen is still running and does not reload changes on its own, restart it. Wait until the local URL answers. Do not install anything to make it run.
3. If it does not start, stop and escalate: tell the Stakeholder a Developer must get the app running, give the rest of the step 5 report, and write in `Blocked` the reason and the Screen waiting to be shown. The error output, and any command or setting that may fix it, go in a part addressed to the Developer; the Stakeholder is never the one to run or install anything. Leave the Screen uncommitted.
4. If you have a browser tool, look at the Screen yourself first, at about 390px and 1440px wide, with the app's real data and after transitions have finished. Fix broken wrapping, overflow and parts that vanish. Do not install a browser for this; without one, say in the report that you did not view it.
5. Give the Stakeholder the URL of this Screen: the local URL plus its route, or how to reach the view (for example the tab to click).

Never deploy a Screen. The check on a phone comes later, in the Preview step (`/ui-workflow-skills:preview-deploy`).

### 5. Report, wait, commit

The Screen's report is in the language of the Stakeholder's latest message, even when `Stakeholder language` in the state says otherwise. It gives:

- the Screen and its local URL
- the files you changed for it
- the decisions applied (design-only actions dropped or disabled)
- substitutes, and what was not reproduced visually
- claims of fact left out, and images not copied with how the export labelled them
- for the Developer: the Tailwind version assumed, if none was pinned; the project's checks and whether you viewed the Screen at both widths
- the question: approve this Screen, or what to change? Include any image you are asking about.

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
- **Project data only.** Claims of fact need a field in the Screens table; an export's image needs the Stakeholder's yes.

## Common Mistakes

- **Porting several Screens in one go.** One, then wait.
- **Trusting the mapping.** A colour pair that passed in the export can vanish on the project's tokens; compute it.
- **`git add -A` or `git commit -a`.** It sweeps in the Stakeholder's own uncommitted work.
- **Committing before approval**, or approving on the Stakeholder's behalf.
- **Installing packages to get the app running, or telling the Stakeholder to run it.** Escalate to the Developer instead.
- **Inventing the run command.** Use the audit's `Run` line, or confirm a detected one with the Developer.

## Related Skills

- `integration-planner` — must return PROCEED first; its Screens table drives the order
- `ui-audit` — records the `Run` line used to show each Screen
- `preview-deploy` — runs after the last Screen is approved
