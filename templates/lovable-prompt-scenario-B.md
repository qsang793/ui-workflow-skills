<!-- Scenario B: Migrate existing FE to a new stack. -->
<!-- Fill in <PLACEHOLDERS> from design-brief answers and from UI_AUDIT.md. -->

You are redesigning the frontend of an existing web application. The **backend stays unchanged**; the frontend is being rewritten in **<TARGET_FRAMEWORK>** (e.g. Next.js 14 + Tailwind).

## Backend context (immutable — do NOT change)

### API base URL
`<e.g. https://api.example.com>`

### Auth pattern
<EXACTLY how the BE authenticates. Examples:>
- "Session cookie set by `POST /api/auth/login`. Send `credentials: 'include'` on every request."
- "JWT bearer token returned by `POST /api/auth/login`. Send `Authorization: Bearer <token>` on every request."

### Real endpoints (do not invent more)

| Method | Path | Body | Returns |
|---|---|---|---|
| POST | `/api/auth/login` | `{email, password}` | `{token}` (or sets cookie) |
| GET | `/api/users/me` | — | `{id, email, name}` |
| GET | `/api/habits` | — | `[{id, name, completed_today, streak}]` |
| POST | `/api/habits` | `{name}` | `{id, name, completed_today: false, streak: 0}` |
| <add more — paste from your real BE> | | | |

## What's wrong with the current FE
<paste high-priority pain points from UI_AUDIT.md — be specific>

## Target users
<who uses this and their context>

## Pages required (must map to endpoints above)
<list, e.g.:>
- `/login` — uses `POST /api/auth/login`
- `/dashboard` — uses `GET /api/users/me`, `GET /api/habits`
- `/settings` — uses `GET /api/users/me`, `PATCH /api/users/me`

## Most important user actions
1. <action 1>
2. <action 2>
3. <action 3>

{{lovable-brand-block}}

{{lovable-constraints-block}}

## Deliverable
- Complete **<TARGET_FRAMEWORK>** project
- Every page wired to the **real** endpoints above
- Auth flow uses the existing pattern, not your invention
- Loading / error / empty states for every async call
- Type definitions match the real response shapes

## Strict no-go
- ❌ Do NOT invent endpoints that aren't in the table above
- ❌ Do NOT change the auth pattern
- ❌ Do NOT redesign the response shapes — adapt your UI to them
- ❌ Do NOT add a separate state management library if the framework's defaults suffice

## Iteration
Provide one full implementation, then offer 2 layout/style variations.
