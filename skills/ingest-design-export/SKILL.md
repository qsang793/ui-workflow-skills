---
name: ingest-design-export
description: Use after the Stakeholder finishes iterating in a Design tool (Lovable or Google AI Studio) and needs the output staged into the project. Takes a ZIP, a GitHub URL, an already unzipped folder or pasted code, lands it at `.ui-workflow/export/` without installing, building or running it, and validates it against the Scenario in the Workflow state. Under Scenario C any framework is accepted as a visual reference; it reports the framework and the Screens the export renders. Required step before `/ui-workflow-skills:integration-planner` (B, C) or `/ui-workflow-skills:integration-wire` (A).
---

# Ingest Design Export

## Overview

The Design export always lives at `.ui-workflow/export/` at the project root. This skill places it there so the Stakeholder never opens a terminal to unzip files, then checks it fits the Scenario before the next skill runs. It only reads and copies files: it never installs, builds or runs the Design export.

## When to Use

- Right after the Stakeholder finishes iterating in Lovable or Google AI Studio
- Before `/ui-workflow-skills:integration-planner`, which expects the export at `.ui-workflow/export/`

## When NOT to Use

- The export is already at `.ui-workflow/export/` and this step is already in `Completed steps`

## Process

Reply in the language of the Stakeholder's latest message; if unclear, use `Stakeholder language` from the Workflow state.

### 0. Read the Workflow state

Read `.ui-workflow/state.md` at the project root before anything else. Take the Scenario from it, never from chat or the Design export. Stop with a short message, without doing anything else, when:

- The file is missing: say the Scenario has not been picked yet and give the command `/ui-workflow-skills:ui-scenario-picker`.
- `Blocked` is not `none` and `Current step` is another step: repeat the reason and say a Developer must decide first. Re-running the step that stopped is allowed.
- `Completed steps` lacks `brief`. Name the first missing step and its command, and never guess its output.

When this step succeeds, append `ingest` to `Completed steps` and set `Current step` to `planner` (B, C) or `wire` (A); also set `Blocked: none`, update `Stakeholder language` if the Stakeholder switched language, and set `Updated: <YYYY-MM-DD> by ingest-design-export`. A STOP, a mismatch or an escalation never completes the step: leave `Completed steps` as it is, set `Current step: ingest` and write the reason in `Blocked`. Step commands: picker `/ui-workflow-skills:ui-scenario-picker`, audit `/ui-workflow-skills:ui-audit`, brief `/ui-workflow-skills:design-brief`, ingest `/ui-workflow-skills:ingest-design-export`, planner `/ui-workflow-skills:integration-planner`, port `/ui-workflow-skills:design-port`, wire `/ui-workflow-skills:integration-wire`, preview `/ui-workflow-skills:preview-deploy`.

### 1. Ask where the export is

If the Stakeholder did not name a source, ask **one** question with the four options:

> "Where's the design tool output?
> 1. A ZIP file I downloaded — paste the path (e.g. `~/Downloads/lovable-abc.zip`)  *(Lovable)*
> 2. A GitHub repo URL — if you used Lovable's GitHub sync
> 3. A folder I already unzipped — paste the path
> 4. I'll paste the code right here  *(typical for Google AI Studio)*"

Require a real path, URL or pasted code. "I think I unzipped it somewhere" is not a source.

### 2. Prepare the export area

Before writing anything, make sure the project's `.gitignore` (create it at the project root if absent) ignores the export area; if no existing line already covers it (such as `.ui-workflow/export*/` or `.ui-workflow/`), append `.ui-workflow/export*/`. This keeps the Design export and its backups out of git. Do not ignore the rest of `.ui-workflow/`, which is meant to be committed.

If `.ui-workflow/export/` exists and is not empty, ask: "The current `.ui-workflow/export/` will be moved to `.ui-workflow/export-backup-<YYYYMMDD-HHMMSS>/`. OK?" Wait for yes, then move it there (`mv`, never delete). On no, stop without changing anything. Then create an empty `.ui-workflow/export/`.

### 3. Stage to `.ui-workflow/export/`

Quote every path the Stakeholder gives; paths often contain spaces.

| Source | Action |
|---|---|
| ZIP | Run the safe extract below. Never use `unzip` or `tar` directly. |
| GitHub URL | Only an `https://` URL; refuse anything else (`ext::`, `file://`, a leading `-`). `git clone --depth 1 -- "<url>" .ui-workflow/export` |
| Folder | `cp -R "<folder>/." .ui-workflow/export/`. Copy, never move: the Stakeholder keeps the source. |
| Pasted code | Write each file into `.ui-workflow/export/` under the name the Stakeholder gives; ask for a name when none is given. A name that is absolute or contains `..` is rejected like a traversal ZIP entry. |

**Safe extract.** It checks every entry before writing anything and rejects the whole ZIP when one entry is absolute, climbs out with `..` or is a symlink, or when it unpacks to more than 1 GB. It drops macOS `__MACOSX/` metadata and flattens a ZIP that holds exactly one top-level folder.

```bash
python3 - "<zip path>" .ui-workflow/export <<'PY'
import shutil, stat, sys, zipfile
from pathlib import Path
src, dest = sys.argv[1], Path(sys.argv[2]).resolve()
with zipfile.ZipFile(src) as z:
    bad = [i.filename for i in z.infolist()
           if stat.S_ISLNK(i.external_attr >> 16) or not (dest / i.filename).resolve().is_relative_to(dest)]
    if bad:
        sys.exit("REJECTED, entries outside the export area: " + ", ".join(bad))
    if sum(i.file_size for i in z.infolist()) > 1_000_000_000:
        sys.exit("REJECTED, unpacks to more than 1 GB")
    z.extractall(dest)
shutil.rmtree(dest / "__MACOSX", ignore_errors=True)
inner = list(dest.iterdir())
if len(inner) == 1 and inner[0].is_dir():  # one top-level folder: flatten it
    tmp = inner[0].rename(dest / ".flatten-tmp")  # a child may share the folder's name
    for child in list(tmp.iterdir()):
        child.rename(dest / child.name)
    tmp.rmdir()
print("extracted", sum(1 for p in dest.rglob("*") if p.is_file()), "files")
PY
```

On `REJECTED`, nothing was written. If step 2 made a backup, move it back to `.ui-workflow/export/`. Tell the Stakeholder the ZIP is unsafe, list the entries, ask them to download it again from the Design tool, and STOP: the step is not completed. Never retry with another tool that would extract the same ZIP.

After any source, remove nested git metadata, which would pollute the project's git status, and symlinks, which could point outside the export area: `find .ui-workflow/export -name .git -prune -exec rm -rf {} + ; find .ui-workflow/export -type l -print -delete`. Name any removed symlink in the report.

**Never run anything from the Design export.** No `npm install`, `npm run`, `npx`, `pnpm`, `yarn`, `bun`, `vite`, build, dev server, test or script inside it. Read its files only, and never read its `.env` files.

### 4. Validate against the Scenario

Read what landed in `.ui-workflow/export/`.

**Framework.** Detect it from `package.json` dependencies, config files and, when there is no `package.json` (pasted code), the source imports: `@tanstack/react-start` → TanStack Start, `next` → Next, `@angular/core` → Angular, `vue` → Vue, `svelte` → Svelte, `react` with `vite` → React + Vite. With no framework markers, HTML files with CSS are plain HTML + CSS.

| Scenario | Expect | Mismatch when |
|---|---|---|
| A. Greenfield | A full project, likely React or Next | No `package.json` or other project manifest |
| B. Migrate stack | A full project in the target framework | No `package.json`, or no markers of the framework the brief named |
| C. Keep stack | Any framework or plain HTML + CSS: a visual reference (ADR-0004) | No Screen can be found and the Stakeholder cannot point to one |

**Screens.** Screens are found from what the Design export renders (routes, pages, and named views shown conditionally, such as tabs or steps), not from folder or file names. Export file is the source file that renders the Screen, followed by `#<view>` when that file renders several Screens (`src/routes/dashboard.tsx`, `src/App.tsx#settings`, `dashboard.html`). Where to look:

- Routes: a router config (`<Route path>`, `createBrowserRouter`), file routes (`src/routes/`, `app/**/page.tsx`, `pages/`), Angular or Vue route arrays. The Export file is the component the route renders.
- Views shown conditionally: one component that switches on state (`tab === "settings"`, a step counter, a `switch` on the current view). One Screen per view, named after its label in the UI.
- HTML pages that show content themselves. An `index.html` that only holds a mount element (`<div id="root">`) is not a Screen by itself: follow its script to what renders.

Name each Screen as the export labels it (tab text, page title, route name).

Under Scenario C, when you cannot tell what the Screens are, list the files that render UI and ask the Stakeholder to name the Screens; never guess. Under A and B, report the Screens you find and never stop on them. Under Scenario C:

- The export renders nothing at all (screenshots only, an empty folder, backend, server or config code only): there is nothing to point to. Report the mismatch and STOP.
- It holds UI code but you find no Screen: ask the Stakeholder which file or view is a Screen. If they cannot point to one, report the mismatch and STOP.

Mismatch report, in the Stakeholder's language:

```
🚨 SCENARIO MISMATCH

The Design export in .ui-workflow/export/ does not fit Scenario <A | B | C>.

Found:
- <file or folder>: <what it is, e.g. "Express server, returns JSON only">

What to do: <C: go back to the Design tool and export the project with its UI
screens, then run /ui-workflow-skills:ingest-design-export again | A, B: what is missing>.
If that does not help, a Developer must decide how to continue.
```

Write the reason to `Blocked` and stop: the step is not completed.

### 5. Report what was staged

When the export fits, complete the step in the Workflow state (step 0), then report:

```markdown
## ✅ Design export staged to `.ui-workflow/export/`

- Source: <ZIP | GitHub | folder | pasted code>: <path or URL>
- Framework: <TanStack Start | React + Vite | Next | Angular | plain HTML + CSS | ...>
- Files: <list, or a count and total size when over 20>
- Backup: <.ui-workflow/export-backup-<timestamp>/ | none>

### Screens
- <Screen> — <Export file>

### Next step
<B, C: /ui-workflow-skills:integration-planner | A: /ui-workflow-skills:integration-wire>
```

### 6. Ask for screenshots

Ask for one screenshot per Screen from the Design tool's preview, saved as `.ui-workflow/export/screenshots/<Screen>.png`, where `<Screen>` is the Screen's name in lowercase with hyphens (`all-reminders.png`). List the file name for each Screen and create the folder. They help `design-port` check layout. The Stakeholder may skip this; skipping never blocks the step, which is already completed.

## Critical Rules

- **Always stage to `.ui-workflow/export/`.** `/ui-workflow-skills:integration-planner` and `/ui-workflow-skills:design-port` look there. No other names like `_designs/`.
- **Never replace an existing export without a backup and the Stakeholder's yes.**
- **Never write outside `.ui-workflow/export/`** (except the `.gitignore` line and the backup move). A ZIP or pasted name that points elsewhere is rejected whole.
- **Never install, build or run the Design export.** It is read as source only.
- **Never leave `.git` inside `.ui-workflow/export/`.**
- **Never proceed past a mismatch silently.** Output the 🚨 block and stop.

## Common Mistakes

- **Taking the Scenario from the export instead of the Workflow state.** The Stakeholder already chose it.
- **Rejecting a React or TanStack export under Scenario C.** Any framework is accepted; only an export with no Screen is a mismatch (ADR-0004).
- **Counting files as Screens.** `components/ui/button.tsx` is not a Screen, and one `App.tsx` with three tabs is three Screens.
- **Flattening a ZIP with several top-level folders** (`src/`, `public/`). Flatten only when there is exactly one.

## Related Skills

- `design-brief` — runs before, wrote `.ui-workflow/design-prompt.md`
- `integration-planner` — runs next for B and C, finds the Screens the same way
- `integration-wire` — runs next for A
- Workflow state format and step order: `docs/workflow-contract.md` in this bundle
