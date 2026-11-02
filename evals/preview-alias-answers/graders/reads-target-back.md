---
type: regex
target:
  source: file
  path: .vercel-calls/calls
pattern: '(^|\n)inspect\b'
match: contains
---
