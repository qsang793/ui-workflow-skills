---
type: regex
# The plan drops it.
target:
  source: file
  path: app/templates/index.html
pattern: 'Share list'
match: not_contains
---
