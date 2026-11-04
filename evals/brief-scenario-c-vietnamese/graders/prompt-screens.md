---
type: regex
target:
  source: file
  path: .ui-workflow/design-prompt.md
# Inside the copy block: one page or route per Screen, and the three Screens of the fixture.
pattern: '=== COPY EVERYTHING BELOW INTO[^\n]*===(?=(?:(?!=== END COPY)[\s\S])*one page or route per Screen)(?=(?:(?!=== END COPY)[\s\S])*Today)(?=(?:(?!=== END COPY)[\s\S])*All reminders)(?=(?:(?!=== END COPY)[\s\S])*Settings)'
match: contains
---
