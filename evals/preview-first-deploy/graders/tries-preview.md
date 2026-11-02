---
type: regex
target:
  source: file
  path: .vercel-calls/calls
# A run that stops before asking Vercel never meets the refusal this case is about.
pattern: '(^|\n)deploy[^\n]*--(?:target|environment)[= ]preview'
match: contains
---
