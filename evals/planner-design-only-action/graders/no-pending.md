---
type: regex
target:
  source: file
  path: .ui-workflow/integration-plan.md
pattern: 'decision:\s*pending'
match: not_contains
---
