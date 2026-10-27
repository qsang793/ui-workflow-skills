#!/bin/bash
set -euo pipefail
cp -R "$(dirname "$0")/../fixtures/fastapi-vanilla/." .
mkdir -p .ui-workflow
cat > .ui-workflow/state.md <<'STATE'
# UI Workflow state

- Scenario: C
- Scenario reason: FastAPI serves a Jinja template with vanilla JS; the Stakeholder wants to keep the stack.
- Maturity: Production
- Design tool: none
- Current step: audit
- Completed steps: picker
- Work branch: none
- Stakeholder language: English
- Blocked: none
- Updated: 2026-10-27 by ui-scenario-picker
STATE
