---
type: regex
target:
  source: file
  path: .ui-workflow/preview.md
# Without this, deleting the file would pass change-settled.
pattern: 'Status: closed'
match: contains
---
