# Integration plan — reminders (2026-10-28)

## Verdict: PROCEED

## Blockers
- none

## Needs Stakeholder decision
- Today: Snooze | backend missing | decision: disabled "coming soon"
- Today: Share list | backend missing | decision: drop

## Not checked
- none

## Screens (Scenario C)
| Screen | Export file | Target template | Data it displays | Actions | Backend source |
|---|---|---|---|---|---|
| Today | src/pages/Today.tsx | app/templates/index.html#today | reminders where `done` is false: `title`, `due`, and how many there are | Done marks a reminder done | `GET /api/reminders`, `POST /api/reminders/{id}/done` |
| All reminders | src/pages/AllReminders.tsx | app/templates/index.html#all | every reminder: `title`, `due`, `done` | Done on unfinished reminders | `GET /api/reminders`, `POST /api/reminders/{id}/done` |
