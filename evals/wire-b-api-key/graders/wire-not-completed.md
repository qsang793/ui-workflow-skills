---
type: regex
target:
  source: file
  path: .ui-workflow/state.md
pattern: 'Completed steps:[^\n]*\bwire\b'
match: not_contains
---
