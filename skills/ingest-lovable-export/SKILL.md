---
name: ingest-lovable-export
description: Use after the user downloads, syncs, or pastes a Lovable / Google AI Studio export and needs to stage it into the project. Accepts a ZIP path, GitHub URL, an existing folder, or pasted code. Always lands the export at `lovable-export/` at the project root and validates content against the chosen scenario (e.g. scenario C must be HTML+CSS, NOT React). Required step between Lovable and `/integration-planner`.
---

# Ingest Lovable Export

## Overview

The convention across this skill bundle: Lovable / Google AI Studio output always lives at `lovable-export/` at the project root. This skill handles the actual placement so non-tech users never open a terminal to unzip files. It also validates the content matches the chosen scenario before the next skill runs.

## When to Use

- Right after the user finishes iterating in Lovable / Google AI Studio
- Before `/integration-planner` (which expects the export at the conventional location)

## When NOT to Use

- The export is already at `lovable-export/` AND the user has already invoked this skill on it
- The output is just inspirational screenshots, not code (no need to ingest)

## Process

### 1. Ask the user where the export is

If the user did not specify a source in their initial message, ask **one** question with the four options:

> "Where's the Lovable export?
> 1. A ZIP file I downloaded — paste the path (e.g. `~/Downloads/lovable-abc.zip`)
> 2. A GitHub repo URL (if you used Lovable's GitHub sync)
> 3. A folder I already unzipped — paste the path
> 4. I'll paste the code right here"

### 2. Confirm scenario

Read the scenario from previous skill output (`ui-scenario-picker` result, `LOVABLE_PROMPT.md` header, or ask the user). Save it for validation later.

### 3. Stage to `lovable-export/`

Always create `lovable-export/` at the project root if missing. **If the folder already exists and is non-empty**, ask the user: "Existing `lovable-export/` will be backed up to `lovable-export-backup-<timestamp>/`. OK?" — wait for yes before proceeding.

| User source | Action |
|---|---|
| ZIP path | `unzip <path> -d lovable-export/`. If the ZIP unpacks into a single top-level folder, flatten it (`mv lovable-export/<inner>/* lovable-export/`). |
| GitHub URL | `git clone <url> lovable-export` (do NOT keep `.git` — `rm -rf lovable-export/.git` after clone). |
| Existing folder | `cp -R <folder>/ lovable-export/`. Do not move — preserves the source. |
| Pasted code | Ask the user for each filename + content, write file-by-file into `lovable-export/`. For HTML+CSS pairs, default names: `index.html`, `styles.css`. |

### 4. Validate against scenario

Read what landed in `lovable-export/`. Check for scenario mismatches:

| Scenario | What should be there | Validation check (fail loudly if violated) |
|---|---|---|
| A. Greenfield | A full project (likely React/Next.js) | Expect `package.json` or similar. |
| B. Migrate stack | A full project in target framework | Expect `package.json` + framework markers (e.g. `next.config.*`). |
| C. Keep stack | **HTML + CSS only, no framework code** | **FAIL** if found: `import React`, `from "react"`, `useState`, `.jsx`, `.tsx`, `package.json` with React deps. |

**Scenario C validation is critical.** Output template if violated:

```
🚨 SCENARIO MISMATCH

The Lovable export contains React/framework code, but the chosen scenario is C
(keep existing stack). This export will not work with /ui-translator without
manual rework.

Found in lovable-export/:
- <file>: <reason — e.g. "imports React on line 3">
- ...

Two ways forward:
1. Go back to Lovable and re-prompt — the prompt MUST forbid React (see
   LOVABLE_PROMPT.md "CRITICAL CONSTRAINT" section).
2. Switch to scenario B (rewrite the FE in the framework Lovable produced).
   Warning: this is 3-6 weeks of work, not 3-7 days.

Stop here and decide with your developer before proceeding.
```

### 5. Report what was staged

Concise summary:

```markdown
## ✅ Lovable export staged to `lovable-export/`

### Files staged
- `lovable-export/index.html` (12 KB)
- `lovable-export/styles.css` (8 KB)
- ... (or summary count if > 20 files: "47 files, 1.2 MB total")

### Scenario alignment: <✅ matches scenario C | 🚨 MISMATCH — see above>

### Next step
Invoke `/integration-planner` to diff this export against your existing backend.
```

## Critical Rules

- **Always use `lovable-export/` as the staging location.** The bundle convention depends on this — `/integration-planner` looks there. Do not invent alternate names like `_designs/` or `lovable/`.
- **Never overwrite an existing `lovable-export/` without backing it up.** The user may have iterations in flight.
- **Never proceed past a scenario mismatch silently.** Especially scenario C: output the 🚨 block above and stop.
- **Never leave a `.git/` directory** inside `lovable-export/` from a GitHub clone — it pollutes the parent repo's git status.

## Common Mistakes

- **Inferring scenario from the export content instead of from prior skills.** The user already chose scenario A/B/C. Use that, not what Lovable happened to produce.
- **Accepting "I think I unzipped it somewhere" without a concrete path.** Always require a real path or URL.
- **Skipping validation because "the user probably knows what they're doing".** They don't. That's why this skill exists.
- **Flattening every ZIP without checking structure.** Some ZIPs unpack into multiple top-level folders intentionally (e.g. `src/`, `public/`). Only flatten when there's exactly ONE inner folder.

## Red Flags — Stop and Re-check

- About to delete an existing `lovable-export/` without backup → stop.
- User said "scenario C" but you're staging a Next.js project → stop, output the mismatch block.
- ZIP path contains spaces / quotes that might break shell commands → quote properly or use Python's `zipfile` module via Bash.

## Related Skills

- `design-brief` — predecessor (produced `LOVABLE_PROMPT.md`)
- `integration-planner` — runs next, expects `lovable-export/` to exist
- `ui-scenario-picker` — provides scenario for validation
