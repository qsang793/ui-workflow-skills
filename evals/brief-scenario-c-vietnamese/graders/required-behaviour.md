---
type: llm
focus:
  source: file
  path: .ui-workflow/design-prompt.md
---
After the COPY block, a `## Required behaviour` section in English covers each existing screen (Today, All reminders, Settings) with what it does today: Today and All reminders list reminders from `/api/reminders` and let the user mark one done through `/api/reminders/{id}/done`; Settings has a notification time field and a Save button. It also lists the Stakeholder's must-haves: marking each reminder done keeps working, and Today shows only reminders that are not done.
