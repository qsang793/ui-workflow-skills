---
type: regex
# One Screen per view of src/App.tsx, each with its #<view>.
target:
  source: file
  path: .ui-workflow/integration-plan.md
pattern: '^(?=[\s\S]*App\.tsx#today)(?=[\s\S]*App\.tsx#all)(?=[\s\S]*App\.tsx#done)'
match: contains
---
