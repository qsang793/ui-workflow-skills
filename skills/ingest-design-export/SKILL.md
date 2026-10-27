---
name: ingest-design-export
description: Use after the user finishes iterating in a design tool (Lovable or Google AI Studio) and needs to stage the output into the project. Lovable typically gives a ZIP or GitHub sync; Google AI Studio gives code blocks in chat — the skill handles both, plus an "already unzipped folder" path. Always lands the export at `.ui-workflow/export/` at the project root and validates content against the chosen scenario (e.g. scenario C must be HTML+CSS, NOT React). Required step before `/integration-planner`.
---

# Ingest Design Export

## Overview

The convention across this skill bundle: Lovable / Google AI Studio output always lives at `.ui-workflow/export/` at the project root. This skill handles the actual placement so non-tech users never open a terminal to unzip files. It also validates the content matches the chosen scenario before the next skill runs.

## When to Use

- Right after the user finishes iterating in Lovable / Google AI Studio
- Before `/integration-planner` (which expects the export at the conventional location)

## When NOT to Use

- The export is already at `.ui-workflow/export/` AND the user has already invoked this skill on it
- The output is just inspirational screenshots, not code (no need to ingest)

## Process

Reply in the language of the Stakeholder's latest message; if unclear, use `Stakeholder language` from the Workflow state.

### 0. Read the Workflow state

Read `.ui-workflow/state.md` at the project root before anything else. Take the Scenario from it, never from chat or the Design export. Stop with a short message, without doing anything else, when:

- The file is missing: say the Scenario has not been picked yet and give the command `/ui-workflow-skills:ui-scenario-picker`.
- `Blocked` is not `none` and `Current step` is another step: repeat the reason and say a Developer must decide first. Re-running the step that stopped is allowed.
- `Completed steps` lacks `brief`. Name the first missing step and its command, and never guess its output.

When this step succeeds, append `ingest` to `Completed steps` and set `Current step` to `planner` (B, C) or `wire` (A); also set `Blocked: none`, update `Stakeholder language` if the Stakeholder switched language, and set `Updated: <YYYY-MM-DD> by ingest-design-export`. A STOP, a mismatch or an escalation never completes the step: leave `Completed steps` as it is, set `Current step: ingest` and write the reason in `Blocked`. Step commands: picker `/ui-workflow-skills:ui-scenario-picker`, audit `/ui-workflow-skills:ui-audit`, brief `/ui-workflow-skills:design-brief`, ingest `/ui-workflow-skills:ingest-design-export`, planner `/ui-workflow-skills:integration-planner`, port `/ui-workflow-skills:design-port`, wire `/ui-workflow-skills:integration-wire`, preview `/ui-workflow-skills:preview-deploy`.

### 1. Ask the user where the export is

If the user did not specify a source in their initial message, ask **one** question with the four options:

> "Where's the design tool output?
> 1. A ZIP file I downloaded — paste the path (e.g. `~/Downloads/lovable-abc.zip`)  *(Lovable)*
> 2. A GitHub repo URL — if you used Lovable's GitHub sync
> 3. A folder I already unzipped — paste the path
> 4. I'll paste the code right here  *(typical for Google AI Studio)*"

### 2. Confirm scenario

Use the Scenario from the Workflow state (step 0) for validation later.

### 3. Stage to `.ui-workflow/export/`

Before writing anything, make sure the project's `.gitignore` (create it at the project root if absent) ignores the export area; if no existing line already covers it (such as `.ui-workflow/export*/` or `.ui-workflow/`), append `.ui-workflow/export*/`. This keeps the Design export and its backups out of git. Do not ignore the rest of `.ui-workflow/`, which is meant to be committed.

Always create `.ui-workflow/export/` if missing. **If the folder already exists and is non-empty**, ask the user: "Existing `.ui-workflow/export/` will be backed up to `.ui-workflow/export-backup-<timestamp>/`. OK?" — wait for yes before proceeding.

| User source | Action |
|---|---|
| ZIP path | `unzip <path> -d .ui-workflow/export/`. If the ZIP unpacks into a single top-level folder, flatten it (`mv .ui-workflow/export/<inner>/* .ui-workflow/export/`). |
| GitHub URL | `git clone <url> .ui-workflow/export/` (do NOT keep `.git` — `rm -rf .ui-workflow/export/.git` after clone). |
| Existing folder | `cp -R <folder>/ .ui-workflow/export/`. Do not move — preserves the source. |
| Pasted code | Ask the user for each filename + content, write file-by-file into `.ui-workflow/export/`. For HTML+CSS pairs, default names: `index.html`, `styles.css`. |

### 4. Validate against scenario

Read what landed in `.ui-workflow/export/`. Check for scenario mismatches:

| Scenario | What should be there | Validation check (fail loudly if violated) |
|---|---|---|
| A. Greenfield | A full project (likely React/Next.js) | Expect `package.json` or similar. |
| B. Migrate stack | A full project in target framework | Expect `package.json` + framework markers (e.g. `next.config.*`). |
| C. Keep stack | **HTML + CSS only, no framework code** | **FAIL** if found: `import React`, `from "react"`, `useState`, `.jsx`, `.tsx`, `package.json` with React deps. |

**Scenario C validation is critical.** Output template if violated:

```
🚨 SCENARIO MISMATCH

The Lovable export contains React/framework code, but the chosen scenario is C
(keep existing stack). This export will not work with /design-port without
manual rework.

Found in .ui-workflow/export/:
- <file>: <reason — e.g. "imports React on line 3">
- ...

Two ways forward:
1. Go back to Lovable and re-prompt — the prompt MUST forbid React (see
   .ui-workflow/design-prompt.md "CRITICAL CONSTRAINT" section).
2. Switch to scenario B (rewrite the FE in the framework Lovable produced).
   Warning: this is 3-6 weeks of work, not 3-7 days.

Stop here and decide with your developer before proceeding.
```

### 5. Report what was staged

Concise summary:

```markdown
## ✅ Lovable export staged to `.ui-workflow/export/`

### Files staged
- `.ui-workflow/export/index.html` (12 KB)
- `.ui-workflow/export/styles.css` (8 KB)
- ... (or summary count if > 20 files: "47 files, 1.2 MB total")

### Scenario alignment: <✅ matches scenario C | 🚨 MISMATCH — see above>

### Next step
Invoke `/integration-planner` to diff this export against your existing backend.
```

## Critical Rules

- **Always use `.ui-workflow/export/` as the staging location.** The bundle convention depends on this — `/integration-planner` looks there. Do not invent alternate names like `_designs/` or `lovable/`.
- **Never overwrite an existing `.ui-workflow/export/` without backing it up.** The user may have iterations in flight.
- **Never proceed past a scenario mismatch silently.** Especially scenario C: output the 🚨 block above and stop.
- **Never leave a `.git/` directory** inside `.ui-workflow/export/` from a GitHub clone — it pollutes the parent repo's git status.

## Common Mistakes

- **Inferring scenario from the export content instead of from prior skills.** The user already chose scenario A/B/C. Use that, not what Lovable happened to produce.
- **Accepting "I think I unzipped it somewhere" without a concrete path.** Always require a real path or URL.
- **Skipping validation because "the user probably knows what they're doing".** They don't. That's why this skill exists.
- **Flattening every ZIP without checking structure.** Some ZIPs unpack into multiple top-level folders intentionally (e.g. `src/`, `public/`). Only flatten when there's exactly ONE inner folder.

## Red Flags — Stop and Re-check

- About to delete an existing `.ui-workflow/export/` without backup → stop.
- User said "scenario C" but you're staging a Next.js project → stop, output the mismatch block.
- ZIP path contains spaces / quotes that might break shell commands → quote properly or use Python's `zipfile` module via Bash.

## Related Skills

- `design-brief` — predecessor (produced `.ui-workflow/design-prompt.md`)
- `integration-planner` — runs next, expects `.ui-workflow/export/` to exist
- `ui-scenario-picker` — provides scenario for validation
