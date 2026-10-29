#!/bin/bash
set -euo pipefail
cp -R "$(dirname "$0")/../fixtures/fastapi-vanilla/." .
# The Design tool returned only a backend: nothing renders a Screen.
mkdir -p downloads
cp -R "$(dirname "$0")/../fixtures/design-export-backend-only" downloads/reminders-api
mkdir -p .ui-workflow
cat > .ui-workflow/state.md <<'STATE'
# UI Workflow state

- Scenario: C
- Scenario reason: FastAPI serves a Jinja template with vanilla JS; the Stakeholder wants to keep the stack.
- Maturity: Beta
- Design tool: Google AI Studio
- Current step: ingest
- Completed steps: picker, audit, brief
- Work branch: none
- Stakeholder language: English
- Blocked: none
- Updated: 2026-10-28 by design-brief
STATE
