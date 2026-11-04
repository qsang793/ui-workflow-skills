---
type: regex
target:
  source: file
  path: .ui-workflow/design-prompt.md
# Inside the copy block: the look only, plain HTML with CSS variables, and no routing, state or backend.
pattern: '=== COPY EVERYTHING BELOW INTO[^\n]*===(?=(?:(?!=== END COPY)[\s\S])*[Ll]ook)(?=(?:(?!=== END COPY)[\s\S])*[Pp]lain[^\n]{0,20}HTML)(?=(?:(?!=== END COPY)[\s\S])*CSS variable)(?=(?:(?!=== END COPY)[\s\S])*[Nn]o routing)'
match: contains
---
