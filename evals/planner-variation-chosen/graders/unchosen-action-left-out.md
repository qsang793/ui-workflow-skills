---
type: regex
target:
  source: file
  path: .ui-workflow/integration-plan.md
# Only TodayTimeline has it: no decision or Blocker entry, and no Screens row.
pattern: 'Snooze[^\n|]*\|\s*backend (missing|cannot)|## Screens(?:(?!\n## )[\s\S])*Snooze'
match: not_contains
---
