---
name: integration-wire
description: Use for Scenario A after ingest, and Scenario B after integration-planner returned PROCEED or PROCEED WITH CAUTION. Scenario A makes the Design export the project and keeps its mocks in one marked data layer. Scenario B places the new frontend in its own folder next to the old one and wires it to the existing backend, following its auth pattern. No secret ever goes into frontend code or public environment variables. The build must pass. Commits on the Work branch after the Stakeholder approves; never pushes or merges. Scenario C uses design-port.
---

# Integration Wire

## Overview

This skill turns the Design export into a working frontend on the Work branch. Scenario A has no backend, so the export becomes the project and its mocks stay, in one marked place, until a backend exists. Scenario B already has a backend and an old frontend, so the new frontend goes in its own folder, talks to the real backend the way that backend already expects, and the old frontend stays untouched until the Developer switches over.

## When to Use

- Scenario A, after `ingest-design-export`
- Scenario B, after `integration-planner` returned `PROCEED` or `PROCEED WITH CAUTION`
- After `preview-deploy` found a problem this step must fix
- When the Stakeholder approves, or asks to change, a wiring reported as built

## When NOT to Use

- Scenario C (use `design-port`)
- `integration-planner` returned `STOP` or left a decision `pending`

## Process

Reply in the language of the Stakeholder's latest message; if unclear, use `Stakeholder language` from the Workflow state.

### 0. Read the Workflow state

Read `.ui-workflow/state.md` at the project root before anything else. Take the Scenario from it, never from chat or the Design export. Stop with a short message, without doing anything else, when:

- The file is missing: say the Scenario has not been picked yet and give the command `/ui-workflow-skills:ui-scenario-picker`.
- `Blocked` is not `none` and `Current step` is another step: repeat the reason and say a Developer must decide first. Re-running the step that stopped is allowed.
- `Scenario` is `C`: say this step is for Scenarios A and B and give the command for the recorded `Current step`.
- `Completed steps` lacks a step this one needs (A: `ingest`; B: `planner`). Scenario A skips the planner by design, so never report it missing there. Name the first missing step and its command, and never guess its output.
- Scenario B only: `.ui-workflow/integration-plan.md` is missing, has Verdict `STOP` or a `decision: pending`, or is older than the export (`find .ui-workflow/export -newer .ui-workflow/integration-plan.md -not -path '*/screenshots/*'` lists a file): say the planner must be settled first and give its command.
- Scenario B only: the plan's auth check says the backend expects an API key, a service token or any other shared secret from its callers: escalate as in step 4, before changing anything.

The step succeeds only after the build passed and the Stakeholder approved the commit (step 7). Then append `wire` to `Completed steps` (once, even when this step runs again after a Preview problem) and set `Current step: preview`; also set `Blocked: none`, update `Stakeholder language` if the Stakeholder switched language, and set `Updated: <YYYY-MM-DD> by integration-wire`. A STOP, a mismatch or an escalation never completes the step: leave `Completed steps` as it is, set `Current step: wire` and write the reason in `Blocked`. Step commands: picker `/ui-workflow-skills:ui-scenario-picker`, audit `/ui-workflow-skills:ui-audit`, brief `/ui-workflow-skills:design-brief`, ingest `/ui-workflow-skills:ingest-design-export`, planner `/ui-workflow-skills:integration-planner`, port `/ui-workflow-skills:design-port`, wire `/ui-workflow-skills:integration-wire`, preview `/ui-workflow-skills:preview-deploy`.

### 1. Get on the Work branch

Every change of this run lives on one Work branch, `ui-workflow/<yyyy-mm-dd>`.

1. The project must be a git repository (`git rev-parse --is-inside-work-tree`). If it is not, stop and escalate: a Developer must set up git first.
2. Run `git status --porcelain` before changing anything. On the first run, every path it lists outside `.ui-workflow/` is the Stakeholder's own uncommitted change, except the `.ui-workflow/` lines earlier steps added to `.gitignore`; in later turns, every such path outside the `Frontend folder` of `.ui-workflow/wiring.md` is, except the ignore lines this step added. Never stage, commit, stash, reset or check out those paths.
3. If `Work branch` in the state names a branch, switch to it (`git switch <branch>`); if that fails or the branch is gone, stop and escalate to the Developer. Otherwise create `ui-workflow/<today>` from the current commit (`git switch -c ui-workflow/<today>`, which also works in a repository with no commit yet); uncommitted changes come along untouched. If that name already exists and the state does not name it, ask the Developer before using it.
4. As soon as you are on it, write the branch into `Work branch` and set `Updated`.

Never commit while the current branch (`git branch --show-current`) is anything but the Work branch. Never push, merge, rebase or open a pull request: the Developer does that.

If `.ui-workflow/wiring.md` says `Build: passed` and the frontend's changes are not committed yet, the Stakeholder is answering your report: go to step 7. If it names a folder otherwise (a failed build, a Preview problem), do not place the export again: work on in that folder from step 3 or 6, whichever the problem needs.

### 2. Place the frontend

Copy from `.ui-workflow/export/`, which stays as it is. Never copy `.git`, `node_modules`, `screenshots/` or any `.env*` file except `.env.example`, and never read the values in those `.env*` files. Never overwrite an existing file. If a file you would write already exists, or is among the Stakeholder's changes from step 1, stop and ask the Developer.

- **Scenario A.** The export becomes the project. When the project root holds nothing but `.git`, `.ui-workflow/`, `.gitignore`, a `README`, a `LICENSE` or an agent's or editor's config folder (`.claude/`, `.vscode/`), place it at the root; a `README` or `LICENSE` the export also has keeps the project's version. Otherwise ask the Stakeholder **one** question: which new folder should hold the project (suggest `web`). A folder they named already gets used without asking again. A folder that exists and is not empty is not an answer: ask for another name.
- **Scenario B.** The new frontend goes in `frontend-new/` next to the old one, or a folder the Stakeholder named. If it exists and is not empty, ask for another name. Nothing outside this folder changes, apart from `.ui-workflow/` and the ignore lines below: never move, rename, edit or delete the old frontend or the backend.

Make sure git ignores what must never be committed, from the `.gitignore` the frontend folder uses: `node_modules/`, the framework's build output and `.env*` except `.env.example`. Merge the export's `.gitignore` into an existing one line by line; never replace it. Check with `git check-ignore <folder>/.env.local`.

Write `.ui-workflow/wiring.md` (format in step 7) with `Frontend folder` and `Build: not run`.

### 3. Scenario A: one marked mock layer

Scenario A has no backend, so nothing is wired to real calls, no endpoint is invented and no base URL is set.

Move every piece of mock data into `src/lib/mock/` (`lib/mock/` when the project has no `src/`): mock files, hardcoded arrays and objects in components, `data/*.json`. Screens import it only through `src/lib/mock/index.ts`; other mock files there are allowed and re-exported from it. Every file in the folder starts with this comment, in that file type's comment form where it has one:

```ts
// MOCK DATA: not real. Replace with real API calls when a backend exists.
```

Leave the look and copy of the Screens as they are. If the export assumes a login, such as a `useSession()` stub, its fake user goes in the mock layer too. Add no auth library, no provider and no login flow.

### 4. Scenario B: real calls and the backend's auth

Wire to what the plan's `API calls` and `Auth pattern check` sections say, endpoint by endpoint. Never invent an endpoint, and never change the backend. If the plan does not settle a call, stop and ask the Developer.

All calls go through one module, `src/lib/api.ts` (`lib/api.ts` when the project has no `src/`). For each mock or hardcoded data source:

- Replace it with a call to the matching endpoint in the plan.
- Add the adapter the plan's table asks for (`shape differs`, `name differs`), with real types instead of `any`.
- Delete the mock once nothing imports it.

Apply **exactly** the auth the backend already has:

| Backend expects | Frontend wiring |
|---|---|
| Session cookie | `fetch(url, { credentials: "include" })` on every call |
| Bearer token issued by its login | Read the token from where the backend's existing login flow leaves it; send `Authorization: Bearer <token>` |
| Some endpoints public | The module adds auth only for the endpoints that need it |
| API key, service token or other shared secret | Never in the frontend: stop and escalate |

**Do not invent a login flow.** Use only what the backend already exposes, add no auth library or provider, and build no login screen the plan does not name.

**Escalation.** For a shared secret, stop and say in plain words that the key cannot go in the browser, so a Developer must put these calls behind a server-side route first. Write that reason in `Blocked`. Change nothing else.

**Base URL.** Read it from the plan, the audit or the backend's config; ask the Developer if none of them settles it. A backend that only runs locally is reached through relative `/api/...` URLs and the framework's dev-server proxy, so cookies and same-origin calls keep working. A public backend's URL goes in a public env var in `.env.local`, read through the framework's own way (`VITE_API_URL` with `import.meta.env`, `NEXT_PUBLIC_API_URL` with `process.env`), and never hardcoded in code. `preview-deploy` sets the same variable for the Preview when its host needs it; production settings are the Developer's.

**Routes.** If the export's routes differ from what the plan agreed, rename them or add a small redirect in the frontend's own config.

### 5. Keep secrets out of the frontend

Everything in frontend code and in public env vars (`NEXT_PUBLIC_*`, `VITE_*`, `REACT_APP_*`, `PUBLIC_*`, `EXPO_PUBLIC_*`) reaches every End user's browser. Secrets (API keys, service tokens, passwords, private keys) stay server-side.

Search the placed frontend, listing file names only so no value lands in your output:

```bash
grep -rlIiE 'api[_-]?key|secret|private[_-]?key|password|token|sk[-_][a-z0-9_-]{16}|AIza[a-z0-9_-]{30}|gh[pousr]_[a-z0-9]{30}|xox[abprs]-|AKIA[a-z0-9]{16}|eyJ[a-z0-9_-]{20}\.' <frontend folder> --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=.ui-workflow --exclude-dir=dist
```

Read each match without repeating a value anywhere. A login form's password field or a token issued by the backend's login is fine. For a secret, or anything you cannot tell apart from one:

- Remove it, and the public env var that carries it, from the frontend. Never replace it with another public variable or a value in `.env.local`.
- Scenario A: the feature that used it runs on the mock layer instead.
- Scenario B: stop and escalate as in step 4.
- Report the file and the variable name for the Developer, never the value, and say the key must be rotated if the export held a real one.

### 6. Build

The build must pass before you report success. In the `Frontend folder`:

1. Read the manifest's `preinstall`, `install` and `postinstall` scripts first: if it has any, stop and ask the Developer whether to run them. Then install what the manifest already declares, with the package manager its lockfile shows (`npm` when there is none).
2. Run its build script (`npm run build`, `pnpm build`, `yarn build`).
3. If it fails, read the error, fix that specific error, and run it again. Keep the fix to the frontend you placed.

Never edit or remove the build script, a dependency or the check that failed in order to make it pass. Add no dependency the export did not declare, unless the error names one your own wiring needs.

If it still fails, or install or build cannot run at all (no network, no package manager, an unavailable package), this is not a pass. Write `Build: failed: <reason>` in `wiring.md`, write the reason in `Blocked`, leave everything uncommitted, tell the Stakeholder in plain words that a Developer must fix the build (never give them a command to run), and show the error output for the Developer.

### 7. Report, wait, commit

When the build passes, check that `Work branch` in the state names the current branch (fix it if not), then write `.ui-workflow/wiring.md` in English:

```markdown
# Wiring

- Frontend folder: <path from the project root, or . for the root>
- Build command: <command>
- Build: passed
- Run: <command that starts it locally, from its scripts> → <local URL> | unknown
- Public env vars: <names> | none
- Updated: <yyyy-mm-dd> by integration-wire
```

The report is in the language of the Stakeholder's latest message, even when `Stakeholder language` in the state says otherwise. It gives, in plain words:

- where the new frontend lives, and for Scenario B that the old one is untouched
- Scenario A: that it shows sample data from `src/lib/mock/` until a backend exists; Scenario B: which data is now real, and the auth it follows
- what a Developer must look at: secrets removed, features left on mocks, anything you could not check
- that the build passed
- the question: save this on the Work branch and go on to the Preview, or what to change?

Then stop and wait. Commit only after the Stakeholder approves. If they ask for changes, make them, build again and report again.

- First update the Workflow state as in step 0, so the commit carries it.
- Stage by path, never `git add -A`, `git add .` or `git commit -a`: the frontend folder (for the root, each path you placed and the lockfile the install wrote) and the workflow documents that are new or changed, `.ui-workflow/state.md`, `wiring.md`, `audit.md`, `design-prompt.md`, `integration-plan.md` (skip any that git ignores), and `.gitignore` when its only uncommitted changes are the workflow's and the ignore lines of step 2. Never the Stakeholder's own changes, never `.ui-workflow/export/` or `preview.md`.
- Check `git diff --cached --name-only` lists no `.env*` file other than `.env.example`.
- `git commit -m "ui-workflow: wire"` (a later fix: `ui-workflow: wire <what changed>`). Do not skip hooks. If the commit fails, show the Developer the error, undo a completion you just wrote (`Current step: wire`, `wire` out of `Completed steps`), write the reason in `Blocked` and stop.

Then tell the Stakeholder it is on the Work branch, nothing was pushed, and the next command is `/ui-workflow-skills:preview-deploy`.

## Critical Rules

- **No secret in frontend code or public env vars.** Secrets stay server-side, with no exceptions and no "just for the Preview".
- **The backend's auth stays as it is.** No new login flow, auth library or provider.
- **The old frontend and the backend stay untouched** (Scenario B). Escalate what would need them changed.
- **Never invent endpoints.** Use only what `.ui-workflow/integration-plan.md` names; Scenario A calls none.
- **No build, no completion.** A build that failed or could not run is reported as exactly that.
- **Work branch only.** Never commit to the main branch; never push or merge. The commit waits for the Stakeholder's approval and never holds their own changes.
- **Never bypass a STOP verdict from the planner.**

## Common Mistakes

- **Copying the export's `.env`.** It may hold real keys, and it would land next to the code.
- **Moving a key to `NEXT_PUBLIC_*` or `VITE_*`.** That still ships it to the browser.
- **Asking for the planner under Scenario A.** It is skipped by design.
- **Leaving mock arrays inside components.** A later Developer must find every mock in one place.
- **`git add -A`.** It sweeps in the Stakeholder's own uncommitted work.
- **Editing the build script or dropping a dependency to get a green build.** Escalate instead.
- **Hardcoding the backend URL.** Preview and production point to different hosts.
- **Forgetting `credentials: "include"`** for cookie auth. It fails as 401s in the browser.

## Related Skills

- `ingest-design-export` — stages the export this skill places; runs right before it under Scenario A
- `integration-planner` — must return PROCEED first under Scenario B
- `preview-deploy` — runs after, and reads `Frontend folder` from `wiring.md`
- `design-port` — sibling for Scenario C
