---
type: regex
target:
  source: file
  path: .ui-workflow/integration-plan.md
pattern: '## Screens(?:(?!\n## )[\s\S])*TodayCards'
match: contains
---
