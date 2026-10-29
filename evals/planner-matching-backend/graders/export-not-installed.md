---
type: regex
# Files the run created: the export must not be installed.
target: files
pattern: 'node_modules'
match: not_contains
---
