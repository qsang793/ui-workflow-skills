#!/bin/bash
# Shared by the Scenario B wire cases: the FastAPI reminders app as a git repo on main, a Design export staged,
# Workflow state at the wire step and the Stakeholder's own uncommitted changes.
# Takes the auth the backend expects: session or api-key.
set -euo pipefail
fixtures="$(dirname "$0")"
cp -R "$fixtures/fastapi-vanilla/." .
mkdir -p .ui-workflow/export
cp -R "$fixtures/wire-export-b/." .ui-workflow/export/
cp "$fixtures/reminders-design/audit.md" .ui-workflow/audit.md
dep='Depends(require_login)'
assumed='no auth'
if [ "$1" = session ]; then
  guard='def require_login(session: str | None = Cookie(default=None)):\n    if session is None:\n        raise HTTPException(status_code=401)\n\n\n\@app.post("\/login")\ndef login(response: Response):\n    response.set_cookie("session", "signed-in", httponly=True)\n    return {"ok": True}\n'
  imports='Cookie, Depends, FastAPI, HTTPException, Request, Response'
  provided='session cookie set by the existing `POST /login`, checked by `require_login`'
  compatible='yes: send the cookie on every call'
else
  guard='def require_login(x_api_key: str | None = Header(default=None)):\n    if x_api_key != os.environ["REMINDERS_API_KEY"]:\n        raise HTTPException(status_code=401)\n'
  imports='Depends, FastAPI, Header, HTTPException, Request'
  provided='shared API key in the `X-API-Key` header, checked by `require_login` against `REMINDERS_API_KEY`'
  compatible='yes: send the header on every call'
fi
perl -0pi -e "s/from fastapi import FastAPI, Request/import os\nfrom fastapi import $imports/; s/\n\@app\.get\(\"\/\"\)/\n$guard\n\n\@app.get(\"\/\")/; s/def list_reminders\(\):/def list_reminders(_=$dep):/; s/def mark_done\(reminder_id: int\):/def mark_done(reminder_id: int, _=$dep):/" app/main.py
# fail loudly if the patch did not apply
grep -q "def list_reminders(_=$dep):" app/main.py
grep -q "def mark_done(reminder_id: int, _=$dep):" app/main.py
grep -q 'def require_login' app/main.py
cat > .ui-workflow/integration-plan.md <<PLAN
# Integration Plan — 2026-10-28

## Verdict: PROCEED WITH CAUTION

No Blockers. The reminders need an adapter because the export names its fields differently.

## Blockers
- none

## Needs Stakeholder decision
- none

## Not checked
- none

## API calls (Scenario B)
| Design export expects | Backend provides | Match? |
|---|---|---|
| mock \`reminders\` in \`src/mock.ts\` → \`{id, name, dueDate, isDone}\` | \`GET /api/reminders\` → \`{id, title, due, done}\` | shape differs: adapter |
| Done button, no handler | \`POST /api/reminders/{id}/done\` | wire the button |

## Auth pattern check (Scenario B)
- Design export assumes: $assumed
- Backend provides: $provided
- Compatible? $compatible

## Next step
/ui-workflow-skills:integration-wire
PLAN
cat > .ui-workflow/state.md <<'STATE'
# UI Workflow state

- Scenario: B
- Scenario reason: FastAPI serves a Jinja template with vanilla JS; the Stakeholder wants a React frontend.
- Maturity: Beta
- Design tool: Lovable
- Current step: wire
- Completed steps: picker, audit, brief, ingest, planner
- Work branch: none
- Stakeholder language: English
- Blocked: none
- Updated: 2026-10-28 by integration-planner
STATE
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
