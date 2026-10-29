---
type: regex
target:
  source: file
  path: .ui-workflow/design-prompt.md
pattern: '=== COPY EVERYTHING BELOW INTO[^\n]*===[\s\S]*=== END COPY ==='
match: contains
---
