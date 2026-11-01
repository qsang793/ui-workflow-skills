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
| Today | today.html | app/templates/index.html#today | reminders where `done` is false: `title`, `due` | Done marks a reminder done | `GET /api/reminders`, `POST /api/reminders/{id}/done` |
