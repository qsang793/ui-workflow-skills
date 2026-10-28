---
name: preview-deploy
description: Use after integration is complete (integration-wire or design-port finished, build green) and before user approves UI for production. Deploys the current branch to a Vercel preview URL on the free tier so the user can click-test on real phones and laptops. Required step — screenshots can hide bugs that real interaction reveals.
---

# Preview Deploy

## Overview

Stakeholders approve UI based on what they can click on real devices, not screenshots. This skill puts the current branch on a Vercel preview URL with one command and returns the URL plus a click-test checklist that the user must complete before saying "ship to prod".

## When to Use

- After `integration-wire` or `design-port` declares complete with a passing build
- Before any `git merge` to main / production deploy

## When NOT to Use

- Build is broken (run tests / build first; fix; then come back)
- BE is on a host the preview FE cannot reach AND env vars haven't been configured (see "BE on Different Host" below)

## Process

### 1. Check Vercel auth

Prefer MCP tools in this order:
- `mcp__claude_ai_Vercel__list_projects` — if it returns, auth is good
- Fallback to CLI: `vercel whoami` — if it returns the username, auth is good

If neither works:
- Tell the user: "Please run `vercel login` once in your terminal, then come back and re-invoke `/preview-deploy`."
- Do NOT try to authenticate from this skill.

### 2. Link project (first time only)

If repo has no `.vercel/` directory and no MCP-linked project:
- Try MCP `mcp__claude_ai_Vercel__deploy_to_vercel` with the repo info (it can auto-link)
- CLI fallback: `vercel link --yes` (uses directory name as project name)

### 3. Detect framework + ensure config

| Stack | Action |
|---|---|
| Next.js (`next.config.*` present) | No config needed — Vercel auto-detects |
| Vite | No config needed |
| Plain static HTML | Write `vercel.json` with `{ "buildCommand": null, "outputDirectory": "<static-dir>" }` |
| FastAPI / other server | Static FE only — set output dir to where the FE assets live (look for the dir referenced by `StaticFiles(directory=...)` in the FastAPI app) |
| Other | Read `package.json` build script; trust it |

If no obvious framework, **ask the user** which directory contains the built FE assets before guessing.

### 4. Set env vars on Vercel (if needed)

If the FE needs to call a BE on a different host:
- The integration-wire step set `NEXT_PUBLIC_API_URL` (or equivalent) in `.env.local`
- That env var must also be set on Vercel:
  - MCP: use the Vercel MCP to add env var (or instruct user)
  - CLI: `vercel env add NEXT_PUBLIC_API_URL preview` (interactive — paste value)
- Skipping this = preview FE loads but every API call 404s

### 5. Deploy as preview (NOT production)

Prefer MCP:
- `mcp__claude_ai_Vercel__deploy_to_vercel` with `production: false`

CLI fallback:
- `vercel --yes` (no `--prod` flag = preview deploy)

### 6. Wait for ready, capture URL, verify

- Poll deployment status (MCP `get_deployment` or CLI output)
- Once ready, verify URL responds 200:
  - `curl -I <url> | head -1` should show `HTTP/2 200`
- If 404 / 5xx: do **not** declare success. Investigate (build log, env vars) and report the actual failure to the user.

### 7. Output

Return exactly:

```markdown
## ✅ Preview ready

**URL:** <https://<preview-url>.vercel.app>

### Click-test checklist (every box must be ✅ before approving)
- [ ] Open on **phone** — every button reachable with thumb, no horizontal scroll
- [ ] Open on **laptop** — no text overflow, no weird empty space
- [ ] Sign in / sign out works (if applicable)
- [ ] Each main feature: completes one full happy path
- [ ] Try a failure: wrong password / disconnected wifi → clear error message?
- [ ] Loading state visible during slow operations? (or page just freezes?)
- [ ] Empty state visible when there's no data? (or blank page?)

### When all boxes checked
Reply with: **"preview approved, ship to prod"**

### If anything fails
Paste the URL + describe what broke. Do NOT say "ship to prod".
```

## BE on Different Host

If the BE runs on AWS / Hetzner / your own VPS:
- The preview FE needs to call the BE's public URL
- `integration-wire` should have parameterized this via env var
- Verify the env var is set on Vercel (step 4) **before** deploying
- Warn the user explicitly:

> ⚠️ This preview talks to the **real production BE**. Be careful with destructive actions (delete, send, charge) during testing — they affect real data.

## Critical Rules

- **Always preview, never `--prod` directly.** Even for "small changes."
- **Always verify the URL responds 200 before declaring success.** A failed deploy with a URL is worse than no URL.
- **Always include the click-test checklist.** Without it, the user just says "looks fine" from a screenshot and ships bugs.

## Common Mistakes

- **Deploying to prod accidentally** with `--prod` or `production: true`. Don't.
- **Not setting env vars** on Vercel → preview FE silently 404s on every API call.
- **Telling user "deployed" without verifying the URL works.** Always curl / open first.
- **Skipping the click-test checklist** because the user is in a hurry. The checklist is the whole point of this skill.

## Red Flags — Stop and Re-check

- About to add `--prod` to the deploy command → stop, this is preview only.
- URL returned but you haven't curled it → curl it.
- User says "skip the checklist this time" → refuse politely, restate why.

## Related Skills

- `integration-wire` / `design-port` — must complete with green build first
- (After approval) Outside this workflow: production deploy is the user's responsibility, not Claude's.
