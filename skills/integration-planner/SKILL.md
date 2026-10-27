---
name: integration-planner
description: Use after the user receives exported code from Lovable / Google AI Studio and before integrating it into the project. Diffs API calls and auth pattern between the new FE and the existing BE to surface missing endpoints, auth mismatches, and data shape gaps. Blocks integration when a BE rewrite would be needed — guardrail for non-tech stakeholders.
---

# Integration Planner

## Overview

Lovable does not know your BE. It invents API calls based on the design. This skill diffs Lovable's assumptions against the real BE and produces a `🚨 BLOCKER / ⚠️ MEDIUM / ℹ️ MINOR`-flagged checklist. **If any 🚨 BLOCKER exists, this skill outputs STOP and forbids further skills from running.**

## When to Use

- After Lovable export is staged at `.ui-workflow/export/` at the project root (use `/ingest-design-export` if not yet staged)
- Before any `design-port` or `integration-wire` work

## Precondition

This skill expects `.ui-workflow/export/` to exist at the project root. **If missing**, output exactly:

```
🚨 Cannot find .ui-workflow/export/ at project root.

Stage the Lovable export first. Run:
  /ingest-design-export

Then re-run /integration-planner.
```

Stop. Do not attempt to search for alternate locations.

## When NOT to Use

- Greenfield scenario A — BE doesn't exist yet, nothing to diff against
- Lovable output is purely static (no API calls)

## Process

### 1. Find API calls in Lovable code

Grep these patterns:
- `fetch(`
- `axios.` (any method)
- `useSWR(`, `useQuery(` (SWR, TanStack)
- Hard-coded URLs starting with `/api/`, `http://`, or `https://`
- Mock data files: `mock.ts`, `mocks/`, `fixtures/`, `data/*.json` — list separately as "needs replacing"

For each, record:
- HTTP method
- URL pattern
- Request body shape (if any)
- Expected response shape

### 2. Find BE routes

Python:
- FastAPI: grep `@router\.` and `@app\.` decorators
- Flask: grep `@app\.route`
- Django: read `urls.py`

Node:
- Express: grep `router\.` and `app\.(get|post|...)`
- NestJS: grep `@Controller`, `@Get`, `@Post`, etc.

For each, record method + path + auth requirement (read the dependency / middleware) + response shape (from return types or sample call).

### 3. Build the diff table

| Lovable expects | BE provides | Match? | Severity |
|---|---|---|---|
| `GET /api/users` | `GET /api/owners` | ❌ name mismatch | ⚠️ Medium |
| `POST /api/auth/login` (JWT bearer) | `POST /login` (session cookie) | ❌ auth pattern | 🚨 Blocker |
| `GET /api/habits` → `{title, done}` | `GET /api/habits` → `{name, completed}` | ⚠️ shape | ⚠️ Medium |

### 4. Severity rules

| Severity | Definition |
|---|---|
| 🚨 Blocker | Requires BE rewrite (auth system change, data model change, breaking schema, removed endpoints) |
| ⚠️ Medium | Adapter / endpoint rename / response shape map — implementable in < 1 day |
| ℹ️ Minor | Cosmetic — naming, optional field, etc. |

### 5. Auth pattern check (always)

Even if endpoints match, check auth:
- Lovable: cookies? JWT in `Authorization` header? Session?
- BE: how does it actually authenticate? (FastAPI `Depends(get_current_user)`? Flask-Login? Express middleware?)
- Compatible? If not → 🚨 Blocker.

### 6. Write the plan

File: `.ui-workflow/integration-plan.md`.

## Output Format

```markdown
# Integration Plan — <YYYY-MM-DD>

## Verdict: <PROCEED | PROCEED WITH CAUTION | STOP>

<One paragraph explaining the verdict. Always cite blocker count.>

## Blockers (🚨)
<List, or "none">

## Medium issues (⚠️)
| Issue | Proposed adapter | Effort |
|---|---|---|
| Endpoint name `/api/users` → `/api/owners` | Rename in FE | 10 min |
| Habit shape `{title, done}` ← `{name, completed}` | Adapter function in fetch layer | 30 min |

## Minor issues (ℹ️)
<List>

## Auth pattern check
- Lovable assumes: <e.g. JWT bearer in Authorization header>
- BE provides: <e.g. session cookie via Depends(get_current_owner)>
- Compatible? <yes | no — with note>

## Next step
<If PROCEED: "Invoke /design-port (scenario C) or /integration-wire (scenario A/B)">
<If STOP: "🚨 Do NOT proceed. Show this plan to the developer.">
```

## Critical Rule

If there is **any** 🚨 Blocker → Verdict MUST be **STOP**, and next step MUST be "show to developer".

Non-tech stakeholders are tempted to skip past blockers because the design looks good. Make stopping the loud default. Use the 🚨 emoji aggressively — visual urgency matters.

## Common Mistakes

- **Under-counting auth mismatches.** Auth changes are almost always blockers, not "mediums".
- **Treating "endpoint name differs" as a blocker.** That's just an adapter — Medium.
- **Not checking response shape, only URL.** Shape mismatches are silent killers — UI renders but with wrong data.
- **Generating an empty "Blockers: none" section to be agreeable.** If you skipped checking, say so. Don't lie by omission.

## Red Flags — Stop and Re-check

- You said PROCEED but didn't check auth → check now.
- You found < 3 issues total → you're not looking hard enough. Lovable output rarely matches BE exactly.
- You marked a missing-endpoint as Medium without confirming it can be added → escalate to Blocker.

## Related Skills

- `design-brief` — predecessor
- `integration-wire` — runs next for scenarios A/B (if PROCEED)
- `design-port` — runs next for scenario C (if PROCEED)
- `preview-deploy` — final step
