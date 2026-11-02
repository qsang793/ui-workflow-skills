---
type: regex
target:
  source: file
  path: .git/index
# It holds a shareable link and local process ids.
pattern: 'preview\.md'
match: not_contains
---
