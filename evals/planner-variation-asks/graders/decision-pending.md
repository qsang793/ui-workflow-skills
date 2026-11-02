---
type: regex
target:
  source: file
  path: .ui-workflow/integration-plan.md
# Names the variations: a pending decision about a button alone must not pass.
pattern: 'variation[^\n]*decision:\s*pending'
match: contains
---
