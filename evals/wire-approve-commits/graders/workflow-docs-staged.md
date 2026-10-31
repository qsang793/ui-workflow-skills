---
type: regex
target:
  source: file
  path: .git/index
# The index lists every tracked path in plain text, so this holds even when the git add sits deep in a long Bash call.
pattern: '\.ui-workflow/state\.md'
match: contains
---
