---
type: regex
target:
  source: file
  path: .ui-workflow/design-prompt.md
# Wording of the ADR-0002 ban; ADR-0004 removed it.
pattern: '([Dd]o\s+\*{0,2}[Nn][Oo][Tt]\*{0,2}|[Dd]on.t|[Nn]ever|[Mm]ust\s+not)\s+use\s+(React|Vue|Svelte|Angular|JSX|any|a\s+(JS\s+)?framework|(JS\s+)?frameworks)|[Dd]iscard everything'
match: not_contains
---
