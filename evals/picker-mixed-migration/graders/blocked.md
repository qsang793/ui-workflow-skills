---
type: regex
target:
  source: file
  path: .ui-workflow/state.md
pattern: 'Blocked:[ \t]*(?!none)\S'
match: contains
---
