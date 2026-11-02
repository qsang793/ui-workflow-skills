---
type: regex
target:
  source: file
  path: .ui-workflow/integration-plan.md
# A decision or Blocker entry for it, or a Screens row. Naming the button to tell the variations apart is fine.
pattern: 'Snooze[^\n|]*\|\s*backend (missing|cannot)|## Screens(?:(?!\n## )[\s\S])*Snooze'
match: not_contains
---
