---
type: regex
target:
  source: file
  path: .ui-workflow/design-prompt.md
# The file is written in English; the project's UI copy is English too, so no Vietnamese letter belongs in it.
pattern: '[ăâđêôơưĂÂĐÊÔƠƯáàãéèíìĩóòõúùũýạảấầẩẫậắằẳẵặẹẻẽếềểễệỉịọỏốồổỗộớờởỡợụủứừửữựỳỵỷỹ]'
match: not_contains
---
