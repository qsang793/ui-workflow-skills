---
type: regex
target:
  source: file
  path: app/templates/index.html
# Done is the third Screen of the plan; it must not exist before Today is approved.
pattern: 'id=["'']done["'']'
match: not_contains
---
