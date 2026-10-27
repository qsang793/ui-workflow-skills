---
type: regex
target:
  source: file
  path: .ui-workflow/state.md
pattern: 'Blocked:\s*(?!none)\S'
match: contains
---
