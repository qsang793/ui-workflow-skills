#!/bin/bash
set -euo pipefail
fixtures="$(dirname "$0")/../fixtures"
cp -R "$fixtures/fastapi-vanilla/." .
mkdir -p downloads
cp -R "$fixtures/design-export-variations" downloads/reminders-design
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
