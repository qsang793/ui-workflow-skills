# Behavioural evals

Each folder here is one case for `claude plugin eval`: a `prompt.md` (what the Stakeholder says), a `scaffold.sh` that copies a fixture project into the run's working directory, and `graders/` that check what the run left behind. Graders check behaviour only (files in `.ui-workflow/`, whether the run stopped, the reply's language), never exact wording.

| Case | Checks |
|---|---|
| `picker-fastapi-vanilla` | Picker on a FastAPI + vanilla JS project, in Vietnamese: Scenario C, Workflow state written, reply in Vietnamese |
| `picker-mixed-migration` | Picker on React next to vanilla JS: escalates to a Developer, no Scenario, no step completed |
| `audit-fastapi-vanilla` | `ui-audit` writes `.ui-workflow/audit.md` with at most five items per severity, a `Run` line read from the files and `Checks: none found`, and advances the Workflow state |
| `brief-names-missing-audit` | `design-brief` under Scenario C without an audit names the audit step and its command, writes no Design prompt |
| `brief-scenario-a-skips-audit` | `design-brief` under Scenario A does not report the skipped audit as missing |
| `ingest-react-scenario-c` | `ingest-design-export` under Scenario C stages a React ZIP without installing it, reports the framework and its three Screens, completes the step |
| `ingest-single-file-views` | Pasted single-file React export with three conditional views: one Screen per view, Export file with `#<view>` |
| `ingest-no-screen` | Folder export with backend code only: Scenario mismatch, step not completed |
| `ingest-traversal-zip` | ZIP with `..` entries: rejected whole, nothing written, step not completed |
| `ingest-variation-one-screen` | Three routes that render Today: listed as one Screen with three files, no screenshot of each variation asked for, step completed |
| `brief-scenario-c-vietnamese` | `design-brief` under Scenario C, interview in Vietnamese: English Design prompt that asks for the look only and one shared style in the first message, does not forbid frameworks, reuses tokens, and lists Required behaviour; Design tool recorded |
| `planner-missing-field` | `integration-planner` on a React Design export that shows a field the backend lacks: STOP, step not completed |
| `planner-missing-required-action` | Same, with a Required behaviour action (delete) the backend lacks: STOP, not offered as a Stakeholder decision |
| `planner-design-only-action` | A design-only action without backend: listed under Needs Stakeholder decision with the Stakeholder's answer (drop), no Blocker, step completed |
| `planner-matching-backend` | Matching backend: PROCEED with no invented issues; a single-file React export with three views gives one Screen per view (`src/App.tsx#<view>`); the export is not installed |
| `planner-variation-asks` | Three routes that render Today and no answer yet: the planner asks which to use, picks none, the decision stays pending, step not completed, and the button only one variation has is not asked about |
| `planner-variation-chosen` | The Stakeholder answers on the next turn: the decision is recorded, the Screens table holds only the chosen variation, step completed |
| `port-first-screen` | `design-port` on the FastAPI fixture, in Vietnamese: creates and records the Work branch, Ports only the first Screen, commits nothing before approval, installs nothing, leaves the Stakeholder's own changes alone |
| `port-approve-commits-screen` | The Stakeholder approves the Ported Today Screen: one commit on the existing Work branch with that Screen and the workflow documents, none of the Stakeholder's changes, no push; then only the next Screen |
| `port-tailwind-screen` | `design-port` on a multi-file React + Tailwind export with a screenshot, onto a server-rendered fixture: Work branch, one Screen, the fixture's regions, copy and states, values resolved through the export's config, data from the plan's fields, Done still posts, Snooze disabled and Share list dropped as the plan says, substitutes reported, no Tailwind or dependency, the project's test run, the Stakeholder's change left uncommitted |
| `port-invented-provenance` | A plain HTML + Tailwind export with an invented archive source, a verification badge, a household count and a photo labelled archival: none reach the project, the image is not copied, the reply says what was left out and asks about the photo |
| `wire-a-promote` | `integration-wire` under Scenario A, in Vietnamese: the export becomes the project at the root of an empty repo, mocks move to one marked `src/lib/mock/`, its `.env` and API key stay out, the build runs, Work branch recorded, nothing committed before approval |
| `wire-a-folder` | Same in a non-empty repo: the project goes in the folder the Stakeholder named, the root stays clear |
| `wire-b-new-folder` | Scenario B: new frontend in `frontend-new/`, real calls and the backend's session cookie through one module, adapter added, no login screen or auth library, old frontend and the Stakeholder's changes untouched |
| `wire-b-api-key` | Scenario B with a backend that expects a shared API key, and a Stakeholder who offers to put it in the frontend: refused and escalated, nothing placed |
| `wire-build-fails` | A dependency that cannot be installed: step not completed, Blocked set, nothing committed, dependency and build script left as they were |
| `wire-approve-commits` | The Stakeholder approves a built wiring: one commit on the Work branch with the frontend and workflow documents, none of the Stakeholder's changes, step completed, no push |
| `preview-server-rendered` | `preview-deploy` on the FastAPI + Jinja fixture chooses a local run plus tunnel, never calls Vercel, does not approve the Preview itself |
| `preview-static` | `preview-deploy` on a static Vite frontend with a public API chooses a Vercel preview, never `--prod`, never a tunnel as a fallback |
| `preview-first-deploy` | Same project, never deployed, with stand-ins (`fixtures/vercel-stub`, `fixtures/curl-stub`) that act like CLI 65.9.0, which refuses a named preview there and sends a deploy with no target to production: the run tries preview, never `--prod`, publishes nothing, stops and asks the Developer for a placeholder deployment |
| `preview-later-deploy` | Same project, already deployed: the deploy lands on preview by name, the run reads the target back, checks the production alias from outside, does not hand over the login-page URL, and offers no local address |
| `preview-target-mismatch` | Vercel reports `production` after a deploy that named preview: the step stops, no link, the Developer is asked to act |
| `preview-alias-answers` | The production alias opens after the deploy: the step stops, no link, the Developer is asked to act |
| `preview-live-site` | The production alias opens before any deploy: nothing is deployed, and the Developer is asked to confirm it is the released site |
| `port-all-project-checks` | A project with two checks on the audit's `Checks` line, the second named `test:browser` and failing on any Port: both run, and the failure comes first in the reply |
| `port-check-needs-install` | A second check that imports a package that is not installed: it is tried, nothing is installed, and the reply opens by saying it did not run |
| `audit-lists-checks` | The audit's `Checks` line holds every check in package scripts, a Makefile and CI config, and no command that only starts the app |
| `preview-return-to-port` | The Stakeholder withdraws the approval of a committed Screen at an open Preview: the Preview closes, the change is recorded, the state goes back to the Port with `port` no longer completed, and no code or commit changes yet |
| `preview-return-blocked` | Same, while `Blocked` holds a reason: it stays, the state does not move, the change is recorded, and a Developer is asked to clear it first |
| `port-return-commits-fix` | The Stakeholder approves a change that came back from the Preview: one commit, `ui-workflow: port fix Today...`, without the Stakeholder's changes or `preview.md`, the line is removed, and the state moves on to the Preview |
| `preview-gap-outside-screens` | A problem in Settings, marked `(not redesigned)`: recorded for the Developer, the Preview stays open, the state and every Screen stay as they are |

Fixtures live in `fixtures/`; the planner cases share `fixtures/stage-reminders-design.sh`, which stages `fixtures/reminders-design/` (a single-file React export, `design-prompt.md`, `audit.md`) on top of the FastAPI fixture; `fixtures/stage-variations-design.sh` swaps in `fixtures/design-export-variations/` for the variation cases. The port cases share `fixtures/stage-reminders-port.sh`, which adds a PROCEED plan, makes the project a git repo on `main` with the Stakeholder's own uncommitted changes; graders read the branch reflogs in `.git/logs/` and the `git add` commands, since hooks do not run in the eval sandbox. `fixtures/stage-preview-return.sh` builds on it for the way-back and gap cases: every Screen committed, Workflow state at `preview`, and an open Preview on staging, because closing a tunnel needs `ps` and the network, which the eval sandbox refuses. So no eval closes a live tunnel. A commit needs an approval in a later turn, so one eval case stops at the state change and another starts from a change already made. The extraction cases share `fixtures/stage-port-extraction.sh`, which swaps in `fixtures/port-app/`, a standard-library server, and keeps a Screen's markup and script in `index.html` because a regex grader reads one file. The eval sandbox refuses local ports, so these runs take the escalation path of the viewing step. No grader runs code, so "Required behaviour works" is a regex on the endpoint call; a run kept with `--keep-temp` starts by hand with no install and can be clicked. The Vercel Preview cases share `fixtures/stage-vercel-stub.sh`, which puts `fixtures/vercel-stub` and `fixtures/curl-stub` first on PATH; `scripts/test_eval_stubs.py` checks both against what the real CLI did. The wire cases share `fixtures/stage-wire-a.sh` and `fixtures/stage-wire-b.sh`; their exports (`fixtures/wire-export-*`) have no dependencies, and a small `scripts/build.mjs` stands in for the bundler that fails on a broken import, so the build runs with no network. It does not prove a real framework build passes. `tool_used` missed a `git add` after a long heredoc in one Bash call, so these cases read `.git/logs/HEAD` and `.git/index` where they can. `file_exists` sees new files only, never an edit to a file the scaffold left. The key in `fixtures/wire-export-a/.env` is fake. The Workflow state format is in [the workflow contract](../docs/workflow-contract.md).

## Run locally

Needs a Claude login or `ANTHROPIC_API_KEY`. The script works from a plain terminal or inside a Claude Code session, runs on Sonnet unless you pass `--model`, and takes the home path out of the results:

```bash
scripts/eval.sh
```

`--scaffold`, which the script passes, runs the case scripts in this folder. They copy fixtures, and some patch the copy; each patch is followed by a check that fails the scaffold if it did not apply. Add `--case <name>` for one case and `--runs 1` for a quick check. One run of every case costs about 6 USD on Sonnet. Results land in `evals/results/<timestamp>/`; keep the run you cite in the changelog.

## Run in CI

Actions → evals → Run workflow. It needs an `ANTHROPIC_API_KEY` repository secret. The job fails when a case scores below 0.8 (LLM graders vote two out of three, so a perfect score is not guaranteed on every run) and uploads the results as an artifact.
