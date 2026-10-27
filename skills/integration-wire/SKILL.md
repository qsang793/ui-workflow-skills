---
name: integration-wire
description: Use for scenarios A and B after integration-planner returns PROCEED. Replaces Lovable's mock data with real BE fetches, configures auth to match BE's existing pattern, sets env vars and routing per the integration plan. For scenario C, use design-port instead. Never invoke if planner verdict is STOP.
---

# Integration Wire

## Overview

After `integration-planner` returns PROCEED, this skill actually performs the wiring: Lovable mocks → real BE calls, Lovable's assumed auth → real BE auth, env vars set, routing aligned.

## When to Use

- Scenario A or B
- After `integration-planner` returns PROCEED (or PROCEED WITH CAUTION)
- Before `preview-deploy`

## When NOT to Use

- Scenario C — use `design-port` instead (it does both translation and wiring)
- `integration-planner` returned STOP — escalate to developer, do NOT proceed

## Process

Reply in the language of the Stakeholder's latest message; if unclear, use `Stakeholder language` from the Workflow state.

### 0. Read the Workflow state

Read `.ui-workflow/state.md` at the project root before anything else. Take the Scenario from it, never from chat or the Design export. Stop with a short message, without doing anything else, when:

- The file is missing: say the Scenario has not been picked yet and give the command `/ui-workflow-skills:ui-scenario-picker`.
- `Blocked` is not `none` and `Current step` is another step: repeat the reason and say a Developer must decide first. Re-running the step that stopped is allowed.
- `Scenario` is `C`: say this step is for Scenarios A and B and give the command for the recorded `Current step`.
- `Completed steps` lacks a step this one needs (A: `ingest`; B: `planner`). Scenario A skips the planner by design, so never report it missing there. Name the first missing step and its command, and never guess its output.

When this step succeeds, set `Work branch` to the branch you work on, append `wire` to `Completed steps` and set `Current step: preview`; also set `Blocked: none`, update `Stakeholder language` if the Stakeholder switched language, and set `Updated: <YYYY-MM-DD> by integration-wire`. A STOP, a mismatch or an escalation never completes the step: leave `Completed steps` as it is, set `Current step: wire` and write the reason in `Blocked`. Step commands: picker `/ui-workflow-skills:ui-scenario-picker`, audit `/ui-workflow-skills:ui-audit`, brief `/ui-workflow-skills:design-brief`, ingest `/ui-workflow-skills:ingest-design-export`, planner `/ui-workflow-skills:integration-planner`, port `/ui-workflow-skills:design-port`, wire `/ui-workflow-skills:integration-wire`, preview `/ui-workflow-skills:preview-deploy`.

### 1. Load the plan

Read `.ui-workflow/integration-plan.md`. If missing or older than the Lovable export, run `/integration-planner` first.

If verdict is STOP, refuse to continue. Print the blocker list and exit.

### 2. Replace mocks with real fetches

For each mock data file or hardcoded mock in Lovable code:
- Find the matching real endpoint in the plan
- Replace the import with a real fetch call
- Add an adapter if the plan's Medium-issues table notes a shape mismatch

Example:

```ts
// BEFORE (Lovable mock)
import { mockHabits } from "./mock";
const habits = mockHabits;

// AFTER (real BE, with adapter per plan)
const res = await fetch("/api/habits", { credentials: "include" });
const raw = await res.json();
const habits = raw.map((h: any) => ({ title: h.name, done: h.completed }));
```

### 3. Match auth pattern

Read the plan's "Auth pattern check" section. Apply **exactly** what the BE expects:

| BE pattern | FE wiring |
|---|---|
| Session cookie | `fetch(..., { credentials: "include" })` on every call |
| JWT in Authorization header | Read token from storage; add `headers: { Authorization: \`Bearer ${token}\` }` |
| API key in custom header | Add `headers: { 'X-API-Key': env.API_KEY }` |
| Mixed (some endpoints public) | Wrap fetches in a helper that adds auth only when needed |

**Do NOT invent a new login flow.** Use whatever the BE already exposes.

### 4. Set env vars

Identify the BE base URL.

- Dev: write to `.env.local` (Next.js / Vite picks this up):
  ```
  NEXT_PUBLIC_API_URL=https://api.example.com
  ```
- Preview/Prod: tell the user to set the same var in Vercel project settings. `preview-deploy` will remind, but don't rely on that.

Replace any hardcoded URLs with `process.env.NEXT_PUBLIC_API_URL` (or framework equivalent).

### 5. Align routing

If Lovable's exported routes differ from what the project expects:
- Rename Lovable's route files to match agreed URLs
- Or add a small redirect/rewrite in `next.config.js` / equivalent

### 6. Build & smoke check

Run the project's build:
- `npm run build` / `pnpm build` / `yarn build`

If build fails:
- Read the error
- Fix the **specific** issue, not random refactors
- Re-run

Do **NOT** declare complete on a failing build.

### 7. Output

```markdown
## ✅ Wiring complete

### Files changed
- <relative path> — <one-line reason>
- …

### Adapters added
- `habits`: `{name, completed}` → `{title, done}` in `lib/api/habits.ts`

### Env vars set
- `.env.local`: `NEXT_PUBLIC_API_URL` = <url>
- ⚠️ Reminder: set the same var in Vercel project settings before `/preview-deploy`.

### Build status
- ✅ Build passed
- (or ❌ Build failed: <error excerpt>)

### Next step
Invoke `/preview-deploy` to push to Vercel.
```

## Critical Rules

- **Never invent endpoints.** Use only what's in `.ui-workflow/integration-plan.md`.
- **Never modify the BE from this skill.** If something requires BE changes, escalate to developer.
- **Always run the build before declaring done.** A successful "wire" with a broken build is worse than a TODO.
- **Never bypass a STOP verdict from the planner.** No exceptions, no "just this once".

## Common Mistakes

- **Skipping adapters.** Medium items in the plan are still required. Don't paper over with `any`.
- **Hardcoding the BE URL.** Always use env var so preview and prod can point to different hosts.
- **Forgetting `credentials: 'include'`** for cookie-based auth — silently fails as 401s in the browser.
- **Bulk-modifying many files at once.** Wire endpoint-by-endpoint and verify build after each major chunk.

## Red Flags — Stop and Re-check

- You're about to write a new endpoint in the BE → you shouldn't be. Escalate.
- You're about to install a new auth library on the FE → you shouldn't be. Use the existing pattern.
- Build is failing and you "think" you know the fix but haven't read the error → read the error first.

## Related Skills

- `integration-planner` — must return PROCEED before this runs
- `preview-deploy` — runs after
- `design-port` — sibling for scenario C
