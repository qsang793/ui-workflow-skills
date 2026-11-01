#!/bin/bash
# Shared by the extraction cases. Usage: stage-port-extraction.sh <fixture with export/ and integration-plan.md>
# The port project, with the FastAPI app swapped for one that needs no install. All of a Screen's markup
# and script sits in index.html, because a regex grader reads one file.
set -euo pipefail
fixtures="$(cd "$(dirname "$0")" && pwd)"
bash "$fixtures/stage-reminders-port.sh"

git checkout -q -- app/main.py
cp "$fixtures/port-app/main.py" app/main.py
cp "$fixtures/port-app/templates/index.html" app/templates/index.html
cp -R "$fixtures/port-app/tests" tests
rm app/static/app.js requirements.txt
perl -ni -e 'print unless /^\.empty /' app/static/styles.css
git add -- app tests requirements.txt
git commit -q --amend -m "Reminders app"

# The Stakeholder's own work in progress again, on the swapped app.
perl -0pi -e 's/(\{"id": 2, "title": "Call dentist".*?\},)/$1\n    {"id": 3, "title": "Buy milk", "due": "2026-11-02", "done": False},/' app/main.py
grep -q 'Buy milk' app/main.py

rm -rf .ui-workflow/export
cp -R "$fixtures/$1/export" .ui-workflow/export
cp "$fixtures/$1/integration-plan.md" .ui-workflow/integration-plan.md
perl -pi -e 's{app/static/app\.js}{app/templates/index.html}' .ui-workflow/design-prompt.md
perl -pi -e 's/FastAPI serves a Jinja template with vanilla JS/A Python server renders a template with vanilla JS/' .ui-workflow/state.md
perl -pi -e 's{^- Run: .*}{- Run: `python3 app/main.py` → http://127.0.0.1:8000}; s{^- Framework: .*}{- Framework: Python standard library server, template with vanilla JS}' .ui-workflow/audit.md
grep -q 'python3 app/main.py' .ui-workflow/audit.md
grep -q 'A Python server' .ui-workflow/state.md
