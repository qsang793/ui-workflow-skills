#!/bin/bash
set -euo pipefail
cp -R "$(dirname "$0")/../fixtures/fastapi-vanilla/." .
mkdir -p downloads
# A valid page plus entries that climb out of .ui-workflow/export/ to .ui-workflow/ and to the project root.
python3 - <<'PY'
import zipfile
with zipfile.ZipFile("downloads/design.zip", "w") as z:
    z.writestr("index.html", "<!doctype html><html><body><h1>Today</h1></body></html>")
    z.writestr("../escaped.txt", "written outside the export area")
    z.writestr("../../escaped.txt", "written outside the export area")
PY
mkdir -p .ui-workflow
cat > .ui-workflow/state.md <<'STATE'
# UI Workflow state

- Scenario: C
- Scenario reason: FastAPI serves a Jinja template with vanilla JS; the Stakeholder wants to keep the stack.
- Maturity: Beta
- Design tool: Lovable
- Current step: ingest
- Completed steps: picker, audit, brief
- Work branch: none
- Stakeholder language: English
- Blocked: none
- Updated: 2026-10-28 by design-brief
STATE
