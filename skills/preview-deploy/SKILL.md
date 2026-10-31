---
name: preview-deploy
description: Use after integration-wire (A, B) or design-port (C) has finished, before the Stakeholder approves the UI. Puts the changed project on a Preview the Stakeholder can click on their own phone and laptop. Picks the host by project shape: a Vercel preview (never production) for a static frontend that reaches a public backend; otherwise the app runs locally behind a temporary tunnel, or on the project's own staging. Verifies the link from outside, gives the click-test checklist, and closes the tunnel after approval.
---

# Preview Deploy

## Overview

Stakeholders approve UI based on what they can click on real devices, not screenshots. This skill puts the changed project on a Preview, checks the link really opens from outside, and hands the Stakeholder a click-test checklist they complete before approving.

The host depends on the project's shape (ADR-0003). A static deploy of a server-rendered app 404s on every API call and cannot render templates, so Vercel is only for static frontends.

## When to Use

- After `integration-wire` (A, B) or `design-port` (C) has completed
- When the Stakeholder approves or rejects an open Preview (see step 7)

## When NOT to Use

- The build or the app is broken: go back to the step that changed the code first
- Production release: that is the Developer's job, outside this workflow

## Process

Reply in the language of the Stakeholder's latest message; if unclear, use `Stakeholder language` from the Workflow state.

### 0. Read the Workflow state

Read `.ui-workflow/state.md` at the project root before anything else. Take the Scenario from it, never from chat or the Design export. Stop with a short message, without doing anything else, when:

- The file is missing: say the Scenario has not been picked yet and give the command `/ui-workflow-skills:ui-scenario-picker`.
- `Blocked` is not `none` and `Current step` is another step: repeat the reason and say a Developer must decide first. Re-running the step that stopped is allowed.
- An earlier step of the Scenario is not in `Completed steps` (A: picker, brief, ingest, wire; B: picker, audit, brief, ingest, planner, wire; C: picker, audit, brief, ingest, planner, port). Name the first missing step and its command, and never guess its output.

When this step succeeds, after the Stakeholder approves the Preview and it is closed, append `preview` to `Completed steps` and set `Current step: done`; also set `Blocked: none`, update `Stakeholder language` if the Stakeholder switched language, and set `Updated: <YYYY-MM-DD> by preview-deploy`. A STOP, a mismatch or an escalation never completes the step: leave `Completed steps` as it is, set `Current step: preview` and write the reason in `Blocked`. Step commands: picker `/ui-workflow-skills:ui-scenario-picker`, audit `/ui-workflow-skills:ui-audit`, brief `/ui-workflow-skills:design-brief`, ingest `/ui-workflow-skills:ingest-design-export`, planner `/ui-workflow-skills:integration-planner`, port `/ui-workflow-skills:design-port`, wire `/ui-workflow-skills:integration-wire`, preview `/ui-workflow-skills:preview-deploy`.

If `.ui-workflow/preview.md` exists with `Status: open`, a Preview is already running: go to step 7 when the Stakeholder approves or reports a problem, otherwise give them its link and checklist again.

### 1. Choose the host by project shape

Look at the files yourself; do not ask the Stakeholder. Under Scenarios A and B the frontend to show is the `Frontend folder` of `.ui-workflow/wiring.md` (the project root when the file is absent): judge its shape, and build, run and deploy it from there, never the old frontend next to it. Decide from what the project is, before checking any tool or account:

| Project shape | Host |
|---|---|
| The backend serves the frontend: server-rendered templates (FastAPI/Jinja, Flask, Django, Rails, Express views), or a framework that needs a server at runtime (TanStack Start, Next.js with server routes) | `tunnel`: run the app locally, expose it through a temporary tunnel |
| Static frontend (plain HTML, Vite/CRA/React + Vite build to static files, Next.js static export) whose API calls go to a public backend URL, or that has no backend | `vercel`: Vercel preview deploy |
| Static frontend whose backend only runs locally | `tunnel`, if the frontend reaches the backend through the same origin (a dev-server proxy); else escalate to the Developer |

Use `staging` instead only when the project already has its own staging environment (named in the README, a deploy script or CI) and the Developer confirms it is the place to show this branch. Never deploy to production, in any host.

Record the choice before going on: write `.ui-workflow/preview.md` (format in step 8) with `Host`, `Host reason` citing the files you saw, and `Status: chosen`. Make sure the project's `.gitignore` (create it at the project root if absent) covers it: if no existing line does (such as `.ui-workflow/preview.md` or `.ui-workflow/`), append `.ui-workflow/preview.md`. It holds a shareable link and local process ids, so it is never committed.

From here on, whenever a step stops (the app does not start, no tunnel opens, Vercel is unavailable, the link fails from outside): close anything you opened (step 7), write `Status: failed: <reason>` in `preview.md` and the reason in `Blocked`, and tell the Stakeholder in plain words that no Preview link is ready. Never hand out a link that failed.

### 2. Local run (host `tunnel`)

Start the app with the `Run` line of `.ui-workflow/audit.md` (`- Run: <command> → <local URL>`), the same command `design-port` uses to show each Screen. Under Scenario B that line starts the backend; the new frontend also runs, from the `Run` line of `wiring.md`, and its URL is what the Preview exposes. Under Scenario A the `Run` line of `wiring.md` is the command. When there is no line to use or it says `unknown`, detect the command from the project (`package.json` scripts, `README`, `Procfile`, `uvicorn`/`flask`/`manage.py` entry points), tell the Developer the command you found and wait for them to confirm it before running it. Never guess silently.

Run it in the background, wait until the local URL answers, and note its process id. If it does not start, stop and show the Developer the error output.

### 3. Open the tunnel (host `tunnel`)

Before opening it, tell the Stakeholder plainly:

> ⚠️ This link is public: anyone who has it can open the app while it is running. The app runs with this computer's settings, so it may read and change **real data**. Avoid delete, send and pay actions unless you know they are safe. The link stops working once you approve.

Then open a tunnel to the local port, in the background, note its process id, and give it about 30 seconds to print a public URL; if none appears, stop it and treat it as a failure:

- Cloudflare quick tunnel, no account: `cloudflared tunnel --url http://localhost:<port>`; the public URL is the `https://<random>.trycloudflare.com` line it prints.
- If `cloudflared` is not installed, use localhost.run over SSH: `ssh -R 80:localhost:<port> nokey@localhost.run`. If neither works, stop and tell the Developer to install `cloudflared` (`brew install cloudflared` on macOS). Do not use Pinggy free or localtunnel: they show a warning or password page that confuses a phone user.

A quick tunnel does not carry Server-Sent Events and allows 200 requests in flight. If the app uses SSE (`EventSource`, `text/event-stream`), say that live updates will not work through the tunnel, and offer staging.

### 4. Vercel preview (host `vercel`)

Detect Vercel by capability, not by tool name: look through the tools you have for one that can deploy to Vercel (its name or description says so), else check the CLI with `vercel whoami`. If neither works, stop: nothing was published; ask the Developer to run `vercel login` once and re-invoke `/ui-workflow-skills:preview-deploy`. Never authenticate from this skill, and never fall back to another host on your own.

- Link the project the first time (no `.vercel/` folder): the deploy tool's link option, or `vercel link --yes`.
- Plain static HTML with no build: write `vercel.json` with `{ "buildCommand": null, "outputDirectory": "<static dir>" }`. Vite, Next.js and other frameworks need no config.
- If the frontend reads its API URL from an environment variable (`VITE_API_URL`, `NEXT_PUBLIC_API_URL`), make sure it is set for the Preview environment (`vercel env add <NAME> preview`, or the tool's equivalent). Without it every API call fails.
- Deploy as a preview: `vercel deploy` (no `--prod`), or the tool with production off. Never `--prod`, `production: true`, `vercel promote`, or an alias to a production domain.

Vercel protects previews by default (Deployment Protection), so the plain preview URL shows a Vercel login page on a phone. Ask the Developer, or whoever owns the Vercel project, to create a Shareable Link: Vercel dashboard → Deployments → this preview → Share → "Anyone with the link" → Copy Link. Hobby allows one such link per account. Do not turn off Deployment Protection, do not use Password Protection or the automation bypass secret: they open every deployment of the project.

### 5. Verify the link from outside

Check the link the Stakeholder will get, not `localhost`, with no login and a fresh cookie jar (a Shareable Link sets a cookie on its first redirect): `curl -sSL -b '' -o /dev/null -w '%{http_code} %{url_effective}\n' <link>`.

- It must end in `200` on the Preview's own host. A `401`/`403`, or a redirect to `vercel.com/login` or `vercel.com/sso`, means Deployment Protection is still on: get the Shareable Link (step 4) and check again.
- Also fetch one data request the main page makes, at the address the page really calls (`<link>/api/...` for a tunnel, the public API URL for a static frontend), and check it answers with data, not `404` or a `localhost` URL.
- If anything fails, stop and show the Developer the status code and the URL that failed.

When it passes, write `URL` and `Status: open` in `preview.md`.

### 6. Hand over the Preview

Give the Stakeholder the output below. For a tunnel, repeat the public-link and real-data warning.

### 7. Approve or close

Approval comes only after the Stakeholder says every checklist box is ticked. If they say "approved" without the checklist, ask which boxes they checked; do not approve on "looks fine".

On approval, close the Preview before anything else:

- Tunnel: stop the tunnel process and the app you started (the process ids in `preview.md`), after checking with `ps -p <pid> -o command=` that each id still runs that command; then check the public URL no longer answers.
- Vercel: ask the Developer to set the Shareable Link back to "Only people with access" and wait until they confirm it is done. The preview deployment itself may stay.
- Staging: nothing to close.

Then write `Status: closed` in `preview.md` and complete the step in the Workflow state (`Current step: done`). Tell the Stakeholder the UI is approved and that releasing it to production is the Developer's job.

If the Stakeholder reports a problem, close the Preview the same way, list what broke, and point to the step that fixes it: `/ui-workflow-skills:design-port` (C) or `/ui-workflow-skills:integration-wire` (A, B). Do not complete the step.

### 8. `.ui-workflow/preview.md`

```markdown
# Preview

- Host: <vercel | tunnel | staging>
- Host reason: <one sentence citing what you saw in the files>
- Run: <command> → <local URL> | none
- URL: <the link given to the Stakeholder> | none
- Processes: <app pid, tunnel pid> | none
- Status: <chosen | open | failed: <reason> | closed>
- Updated: <YYYY-MM-DD> by preview-deploy
```

## Output

Translated into the Stakeholder's language, except the link:

```markdown
## ✅ Preview ready

**Link:** <url>
**Host:** <Vercel preview | your computer, through a temporary tunnel | staging>

<tunnel only: the public-link and real-data warning>

### Click-test checklist (tick every box before approving)
- [ ] Open on your **phone**: every button reachable with a thumb, no sideways scrolling
- [ ] Open on your **laptop**: no text overflow, no odd empty space
- [ ] Sign in / sign out works (if the app has it)
- [ ] Each main feature: finish one full task from start to end
- [ ] Try a failure (wrong input, wifi off): is there a clear error message?
- [ ] Slow actions show a loading state instead of freezing
- [ ] Empty lists show an empty state instead of a blank page

### When every box is ticked
Reply **"preview approved"**. The link is then closed.

### If something is wrong
Describe what broke and on which device. Do not approve.
```

## Critical Rules

- **Host by project shape, decided first.** Never put a server-rendered app on Vercel.
- **Never production.** No `--prod`, no promote, no production alias.
- **Verify from outside before showing the link.** A link that opens a login page or 404s is worse than no link; report the failure.
- **Always the checklist.** Approval only after every box is ticked.
- **Close the tunnel after approval.** A forgotten tunnel is a public door into the Stakeholder's computer.

## Common Mistakes

- **Deploying a FastAPI/Jinja app's static folder to Vercel.** The templates never render and every API call 404s.
- **Checking `localhost` instead of the public link.** It always works on your machine.
- **Sending the plain Vercel preview URL.** Deployment Protection shows the phone a login page; use the Shareable Link.
- **Not setting the API URL variable for the Preview environment.** The page loads but has no data.
- **Inventing the run command.** Use the audit's `Run` line, or confirm a detected one with the Developer.

## Red Flags — Stop and Re-check

- About to type `--prod` → stop, this is preview only.
- About to give a link you have not fetched from outside → fetch it.
- The Stakeholder says "skip the checklist" → refuse politely, restate why.
- Approval given and the tunnel process is still running → close it now.

## Related Skills

- `integration-wire` (A, B) / `design-port` (C) — must complete first
- `ui-audit` — records the `Run` line used for a local run
- Workflow state format and step order: `docs/workflow-contract.md` in this bundle
