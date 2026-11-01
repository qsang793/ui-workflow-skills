---
type: regex
target:
  source: file
  path: .vercel-calls/calls
# A deploy line with no target, or any way of reaching production. A deploy that landed on production and was redone still fails.
pattern: '(^|\n)deploy(?![^\n]*--target[= ]preview)|--prod\b|\bpromote\b'
match: not_contains
---
