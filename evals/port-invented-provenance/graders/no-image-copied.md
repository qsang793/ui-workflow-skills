---
type: regex
# Files the run created, so a copy through Bash under any name is caught.
target: files
pattern: '\.(jpe?g|png|webp|gif|avif)\b'
match: not_contains
---
