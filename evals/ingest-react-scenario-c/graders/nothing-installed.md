---
type: regex
# Files the run created: an install or build would leave node_modules or dist behind.
target: files
pattern: 'node_modules|/dist/'
match: not_contains
---
