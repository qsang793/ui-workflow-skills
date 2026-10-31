# Behavioural evals

Each folder here is one case for `claude plugin eval`: a `prompt.md` (what the Stakeholder says), a `scaffold.sh` that copies a fixture project into the run's working directory, and `graders/` that check what the run left behind. Graders check behaviour only (files in `.ui-workflow/`, whether the run stopped, the reply's language), never exact wording.

| Case | Checks |
|---|---|
| `picker-fastapi-vanilla` | Picker on a FastAPI + vanilla JS project, in Vietnamese: Scenario C, Workflow state written, reply in Vietnamese |
| `picker-mixed-migration` | Picker on React next to vanilla JS: escalates to a Developer, no Scenario, no step completed |
| `audit-fastapi-vanilla` | `ui-audit` writes `.ui-workflow/audit.md` with at most five items per severity and a `Run` line read from the files, and advances the Workflow state |
| `brief-names-missing-audit` | `design-brief` under Scenario C without an audit names the audit step and its command, writes no Design prompt |
| `brief-scenario-a-skips-audit` | `design-brief` under Scenario A does not report the skipped audit as missing |
| `ingest-react-scenario-c` | `ingest-design-export` under Scenario C stages a React ZIP without installing it, reports the framework and its three Screens, completes the step |
| `ingest-single-file-views` | Pasted single-file React export with three conditional views: one Screen per view, Export file with `#<view>` |
| `ingest-no-screen` | Folder export with backend code only: Scenario mismatch, step not completed |
| `ingest-traversal-zip` | ZIP with `..` entries: rejected whole, nothing written, step not completed |
| `brief-scenario-c-vietnamese` | `design-brief` under Scenario C, interview in Vietnamese: English Design prompt that asks for the look only, does not forbid frameworks, reuses tokens, and lists Required behaviour; Design tool recorded |
| `planner-missing-field` | `integration-planner` on a React Design export that shows a field the backend lacks: STOP, step not completed |
| `planner-missing-required-action` | Same, with a Required behaviour action (delete) the backend lacks: STOP, not offered as a Stakeholder decision |
| `planner-design-only-action` | A design-only action without backend: listed under Needs Stakeholder decision with the Stakeholder's answer (drop), no Blocker, step completed |
| `planner-matching-backend` | Matching backend: PROCEED with no invented issues; a single-file React export with three views gives one Screen per view (`src/App.tsx#<view>`); the export is not installed |
| `port-first-screen` | `design-port` on the FastAPI fixture, in Vietnamese: creates and records the Work branch, Ports only the first Screen, commits nothing before approval, installs nothing, leaves the Stakeholder's own changes alone |
| `port-approve-commits-screen` | The Stakeholder approves the Ported Today Screen: one commit on the existing Work branch with that Screen and the workflow documents, none of the Stakeholder's changes, no push; then only the next Screen |
| `preview-server-rendered` | `preview-deploy` on the FastAPI + Jinja fixture chooses a local run plus tunnel, never calls Vercel, does not approve the Preview itself |
| `preview-static` | `preview-deploy` on a static Vite frontend with a public API chooses a Vercel preview, never `--prod`, never a tunnel as a fallback |

Fixtures live in `fixtures/`; the planner cases share `fixtures/stage-reminders-design.sh`, which stages `fixtures/reminders-design/` (a single-file React export, `design-prompt.md`, `audit.md`) on top of the FastAPI fixture. The port cases share `fixtures/stage-reminders-port.sh`, which adds a PROCEED plan, makes the project a git repo on `main` with the Stakeholder's own uncommitted changes; graders read the branch reflogs in `.git/logs/` and the `git add` commands, since hooks do not run in the eval sandbox. The Workflow state format is in [the workflow contract](../docs/workflow-contract.md).

## Run locally

From the repo root (needs a Claude login or `ANTHROPIC_API_KEY`). Start it from a plain terminal: run from inside a Claude Code session, the child `claude` inherits that session's environment and a subscription login can fail with "organization has disabled Claude subscription access". Add `--model sonnet` to keep the cost down:

```bash
claude plugin eval . --trust-plugin --scaffold --allow-tools Bash Write Edit --ablation none
```

`--scaffold` runs the case scripts in this folder. They copy fixtures, and some patch the copy; each patch is followed by a check that fails the scaffold if it did not apply. Add `--case <name>` for one case and `--runs 1` for a quick check. One run of every case costs about 1 USD. Results land in `evals/results/<timestamp>/`; keep the run you cite in the changelog.

## Run in CI

Actions → evals → Run workflow. It needs an `ANTHROPIC_API_KEY` repository secret. The job fails when a case scores below 0.8 (LLM graders vote two out of three, so a perfect score is not guaranteed on every run) and uploads the results as an artifact.
