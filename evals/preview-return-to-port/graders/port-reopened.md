---
type: regex
target:
  source: file
  path: .ui-workflow/state.md
# Taken out, so the Preview step cannot run again before the change is made.
pattern: 'Completed steps:[^\n]*\bport\b'
match: not_contains
---
