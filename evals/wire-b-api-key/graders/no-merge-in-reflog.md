---
type: regex
target:
  source: file
  path: .git/logs/HEAD
pattern: '\t(?:merge|rebase|pull)\b'
match: not_contains
---
