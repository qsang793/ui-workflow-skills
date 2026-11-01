---
type: regex
# No Tailwind CDN, icon script or icon font.
target:
  source: file
  path: app/templates/index.html
pattern: '<script[^>]+src=["'']https?:|<link[^>]+(icon|symbols)[^>]*fonts\.|<link[^>]+fonts\.[^>]*(icon|symbols)'
match: not_contains
---
