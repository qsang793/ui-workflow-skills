---
type: regex
# Files the run created: escaped.txt anywhere means an entry of the ZIP was written.
target: files
pattern: 'escaped\.txt'
match: not_contains
---
