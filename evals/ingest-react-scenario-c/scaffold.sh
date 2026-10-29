#!/bin/bash
set -euo pipefail
cp -R "$(dirname "$0")/../fixtures/fastapi-vanilla/." .
# Lovable ZIPs hold one top-level folder, which ingest flattens.
mkdir -p downloads
(cd "$(dirname "$0")/../fixtures/design-export-react" && python3 -m zipfile -c "$OLDPWD/downloads/reminders-design.zip" reminders-design)
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
