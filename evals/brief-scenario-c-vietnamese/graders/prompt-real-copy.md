---
type: regex
target:
  source: file
  path: .ui-workflow/design-prompt.md
# Inside the copy block: real copy from the fixture's templates, quoted.
pattern: '=== COPY EVERYTHING BELOW INTO[^\n]*===(?=(?:(?!=== END COPY)[\s\S])*[`"“”*]Done[`"“”*])(?=(?:(?!=== END COPY)[\s\S])*[`"“”*]Notification time[`"“”*])(?=(?:(?!=== END COPY)[\s\S])*[`"“”*]Save[`"“”*])'
match: contains
---
