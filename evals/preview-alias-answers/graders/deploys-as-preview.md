---
type: regex
target:
  source: file
  path: .vercel-calls/target
# The target the stand-in CLI gave the last deploy. The file exists only if a deploy ran.
pattern: '^preview\s*$'
match: contains
---
