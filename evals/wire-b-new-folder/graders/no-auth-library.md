---
type: regex
target:
  source: file
  path: frontend-new/package.json
pattern: 'next-auth|clerk|auth0|supabase|firebase'
match: not_contains
---
