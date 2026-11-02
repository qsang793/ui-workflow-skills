#!/bin/bash
set -euo pipefail
bash "$(dirname "$0")/../fixtures/stage-variations-design.sh"
# The plan the previous turn left, waiting for this answer.
cat > .ui-workflow/integration-plan.md <<'PLAN'
# Integration Plan — 2026-10-27

## Verdict: PROCEED

No Blockers. One decision is waiting for the Stakeholder.

## Blockers
- none

## Needs Stakeholder decision
- Today: variations `src/routes/TodayCompact.tsx`, `src/routes/TodayCards.tsx`, `src/routes/TodayTimeline.tsx` | which one to use | decision: pending

## Not checked
- none

## Screens (Scenario C)
| Screen | Export file | Target template | Data it displays | Actions | Backend source |
|---|---|---|---|---|---|
| Today | pending | `app/templates/index.html` | pending | pending | pending |
| All reminders | `src/routes/AllReminders.tsx` | `app/templates/index.html` | title, due, done | Mark done | `GET /api/reminders`; `POST /api/reminders/{id}/done` |
| Done | `src/routes/Done.tsx` | `app/templates/index.html` | title, due | none | `GET /api/reminders` |

## Next step
Answer the decision above, then re-run /ui-workflow-skills:integration-planner.
PLAN
