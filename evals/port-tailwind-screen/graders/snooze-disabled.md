---
type: regex
# The plan shows Snooze disabled with a "coming soon" label; an inline icon may sit between them.
target:
  source: file
  path: app/templates/index.html
pattern: 'disabled[\s\S]{0,600}coming soon|coming soon[\s\S]{0,600}disabled'
flags: i
match: contains
---
