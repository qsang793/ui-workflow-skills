#!/bin/bash
# Shared by the port cases: the planner fixture as a git repo on main, with a PROCEED plan,
# Workflow state at the port step, and the Stakeholder's own uncommitted changes.
set -euo pipefail
bash "$(dirname "$0")/stage-reminders-design.sh"
cat > .ui-workflow/integration-plan.md <<'PLAN'
# Integration plan — reminders (2026-10-28)

## Verdict: PROCEED

## Blockers
- none

## Needs Stakeholder decision
- none

## Not checked
- none

## Screens (Scenario C)
| Screen | Export file | Target template | Data it displays | Actions | Backend source |
|---|---|---|---|---|---|
| Today | src/App.tsx#today | app/templates/index.html#today | reminders where `done` is false: `title`, `due` | Done marks a reminder done | `GET /api/reminders`, `POST /api/reminders/{id}/done` |
| All reminders | src/App.tsx#all | app/templates/index.html#all | every reminder: `title`, `due`, `done` | Done on unfinished reminders | `GET /api/reminders`, `POST /api/reminders/{id}/done` |
| Done | src/App.tsx#done | app/templates/index.html (new `done` view) | reminders where `done` is true: `title`, `due` | none | `GET /api/reminders` |
PLAN
perl -0pi -e 's/Current step: planner/Current step: port/; s/(Completed steps: picker, audit, brief, ingest)/$1, planner/; s/Updated: .*/Updated: 2026-10-28 by integration-planner/' .ui-workflow/state.md
# fail loudly if the patch did not apply
grep -q 'Current step: port$' .ui-workflow/state.md
grep -q 'Completed steps: picker, audit, brief, ingest, planner$' .ui-workflow/state.md
grep -q 'Updated: 2026-10-28 by integration-planner$' .ui-workflow/state.md

printf '.ui-workflow/export*/\n.ui-workflow/preview.md\n' > .gitignore
git init -q -b main
git config user.email eval@example.com
git config user.name eval
git add -- .gitignore app requirements.txt
git commit -qm "Reminders app"

# The Stakeholder's own work in progress, which must never be committed by the workflow.
perl -0pi -e 's/(\{"id": 2, "title": "Call dentist".*?\},)/$1\n    {"id": 3, "title": "Buy milk", "due": "2026-11-02", "done": False},/' app/main.py
grep -q 'Buy milk' app/main.py
echo "Ask Minh about the Settings colours." > notes.txt
