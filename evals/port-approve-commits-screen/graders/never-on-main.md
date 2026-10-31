---
type: regex
target:
  source: file
  path: .git/logs/refs/heads/main
# The scaffold's own initial commit is the only one main may have.
pattern: '\t(?:commit(?! \(initial\))|merge|reset|rebase)'
match: not_contains
---
