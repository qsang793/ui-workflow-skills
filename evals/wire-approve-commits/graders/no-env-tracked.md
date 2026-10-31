---
type: regex
target:
  source: file
  path: .git/index
pattern: '\.env'
match: not_contains
---
