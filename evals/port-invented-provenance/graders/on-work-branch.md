---
type: regex
target:
  source: file
  path: .git/HEAD
pattern: 'ref: refs/heads/ui-workflow/\d{4}-\d{2}-\d{2}\b'
match: contains
---
