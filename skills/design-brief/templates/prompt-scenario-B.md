<!-- Scenario B: Migrate existing FE to a new stack. -->
<!-- Fill in <PLACEHOLDERS> from design-brief answers and from .ui-workflow/audit.md. -->

You are redesigning the frontend of an existing web application. The **backend stays unchanged**; the frontend is being rewritten in **<TARGET_FRAMEWORK>** (e.g. React + Tailwind), current stable version.

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
<paste high-priority pain points from .ui-workflow/audit.md — be specific>

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

{{brand-block}}

{{constraints-block}}

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

## One shared style
This may be the only message I can send, so build everything now.
- Choose one visual style yourself and use it on every page, from the same colours, fonts and components.
- Build every page above in this first build. Do not stop after the first page, and do not ask me to choose anything first.
- Build one version of each page: no alternative versions, variations or style switchers.
