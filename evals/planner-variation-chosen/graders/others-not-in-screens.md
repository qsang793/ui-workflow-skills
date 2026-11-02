---
type: regex
target:
  source: file
  path: .ui-workflow/integration-plan.md
pattern: '## Screens(?:(?!\n## )[\s\S])*Today(Compact|Timeline)'
match: not_contains
---
