---
type: regex
target:
  source: file
  path: .ui-workflow/state.md
pattern: 'Completed steps:[^\n]*\bpreview\b'
match: not_contains
---
