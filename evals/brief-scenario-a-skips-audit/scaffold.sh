#!/bin/bash
set -euo pipefail
mkdir -p .ui-workflow
cat > .ui-workflow/state.md <<'STATE'
# UI Workflow state

- Scenario: A
- Scenario reason: The Stakeholder is starting a new frontend from scratch.
- Maturity: Beta
- Design tool: none
- Current step: brief
- Completed steps: picker
- Work branch: none
- Stakeholder language: English
- Blocked: none
- Updated: 2026-10-27 by ui-scenario-picker
STATE
