---
type: regex
# A call other than the function's own definition: the rebuilt row's Done button reaches markDone.
target:
  source: file
  path: app/templates/index.html
pattern: 'markDone\((?!id\s*\))'
match: contains
---
