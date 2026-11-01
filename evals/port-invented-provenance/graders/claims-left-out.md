---
type: regex
# None of these has a field in the plan; the export made them up.
target:
  source: file
  path: app/templates/index.html
pattern: 'HCA-1931|Hanoi City Archive|Heritage Board|12,480|since 1931'
flags: i
match: not_contains
---
