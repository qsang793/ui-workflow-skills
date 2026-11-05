---
name: preview-deploy
description: Use after integration-wire (A, B) or design-port (C) has finished, before the Stakeholder approves the UI. Puts the changed project on a Preview the Stakeholder can click on their own phone and laptop. Picks the host by project shape: a Vercel preview (never production) for a static frontend that reaches a public backend; otherwise the app runs locally behind a temporary tunnel, or on the project's own staging. Verifies the link from outside, gives the click-test checklist, and closes the tunnel after approval. Also handles a Stakeholder who withdraws an approval or reports a problem at the Preview: sends a change to a committed Screen back to the Port, and records a gap outside the planned Screens for the Developer.
---

# Preview Deploy

## Overview

Stakeholders approve UI based on what they can click on real devices, not screenshots. This skill puts the changed project on a Preview, checks the link really opens from outside, and hands the Stakeholder a click-test checklist they complete before approving.

The host depends on the project's shape (ADR-0003). A static deploy of a server-rendered app 404s on every API call and cannot render templates, so Vercel is only for static frontends.

## When to Use

- After `integration-wire` (A, B) or `design-port` (C) has completed
- When the Stakeholder approves or rejects an open Preview, withdraws the approval of a Screen, or reports a problem (see step 7)

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

If `Current step` is `done`, the UI is approved and the Preview is closed: a change now is the Developer's to decide. Say so and stop, without changing anything. If the Stakeholder withdraws an approval or reports a problem, go to step 7, whatever `preview.md` says. Go there too when `preview.md` has lines under `## Return to the Port`, even to re-run the step: a withdrawn approval is settled before any new Preview opens. If `.ui-workflow/preview.md` exists with `Status: open`, a Preview is already running: go to step 7 when the Stakeholder approves, otherwise give them its link and checklist again.

### 1. Choose the host by project shape

Look at the files yourself; do not ask the Stakeholder. Under Scenarios A and B the frontend to show is the `Frontend folder` of `.ui-workflow/wiring.md` (the project root when the file is absent): judge its shape, and build, run and deploy it from there, never the old frontend next to it. Decide from what the project is, before checking any tool or account:

| Project shape | Host |
|---|---|
| The backend serves the frontend: server-rendered templates (FastAPI/Jinja, Flask, Django, Rails, Express views), or a framework that needs a server at runtime (TanStack Start, Next.js with server routes) | `tunnel`: run the app locally, expose it through a temporary tunnel |
| Static frontend (plain HTML, Vite/CRA/React + Vite build to static files, Next.js static export) whose API calls go to a public backend URL, or that has no backend | `vercel`: Vercel preview deploy |
| Static frontend whose backend only runs locally | `tunnel`, if the frontend reaches the backend through the same origin (a dev-server proxy); else escalate to the Developer |

Use `staging` instead only when the project already has its own staging environment (named in the README, a deploy script or CI) and the Developer confirms it is the place to show this branch. Never deploy to production, in any host.

Record the choice before going on: write `.ui-workflow/preview.md` (format in step 8) with `Host`, `Host reason` citing the files you saw, and `Status: chosen`. Make sure the project's `.gitignore` (create it at the project root if absent) covers it: if no existing line does (such as `.ui-workflow/preview.md` or `.ui-workflow/`), append `.ui-workflow/preview.md`. It holds a shareable link and local process ids, so it is never committed. Keep its `## Gaps for the Developer` section when this step runs again.

From here on, whenever a step stops (the app does not start, no tunnel opens, Vercel is unavailable, the link fails from outside): close anything you opened (step 7), write `Status: failed: <reason>` in `preview.md` and the reason in `Blocked`, and tell the Stakeholder in plain words that no Preview link is ready. Never hand out a link that failed. Leave local addresses (`localhost`, `127.0.0.1`, a LAN IP) out of the reply, as a link, a workaround or an explanation: they open only on the computer that runs the app. Naming the command that starts the app is fine. When a Vercel check stops, name no Vercel address in the reply either: they go in `preview.md`, where the Developer reads them.

### 2. Local run (host `tunnel`)

Start the app with the `Run` line of `.ui-workflow/audit.md` (`- Run: <command> → <local URL>`), the same command `design-port` uses to show each Screen. Under Scenario B that line starts the backend; the new frontend also runs, from the `Run` line of `wiring.md`, and its URL is what the Preview exposes. Under Scenario A the `Run` line of `wiring.md` is the command. When there is no line to use or it says `unknown`, detect the command from the project (`package.json` scripts, `README`, `Procfile`, `uvicorn`/`flask`/`manage.py` entry points), tell the Developer the command you found and wait for them to confirm it before running it. Never guess silently.

Run it in the background, wait until the local URL answers, and note its process id. If it does not start, or cannot be run at all, stop and give the Developer the command and the error output in the reply.

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
- Check the production aliases before deploying: `https://<projectName>.vercel.app`, with the name from `.vercel/project.json` or the tool's project details, plus every address under `Aliases` when you run `vercel inspect` on the latest deployment from `vercel list --environment production`, if there is one. Fetch each with the command in step 5. An address is not public when it ends in `404`, `401`, `403` or on a Vercel login page. If one opens any other way, the project may already be live, or the address may belong to someone else: this is a stop under step 1 (`Status: failed: <reason>` with the address, and `Blocked`), before any deploy. Ask a Developer, not the Stakeholder, to confirm that the address is the project's released site or not this project's. When a Developer has confirmed it, add it to `Released site` in `preview.md` and go on. Keep that line when this step runs again.
- Deploy to the preview target by name: `vercel deploy --environment preview` (`--target preview` on a CLI that rejects `--environment`), or the tool with its target set to preview. Never a deploy that names no target: on a project with no deployment it goes to production. Never `--prod`, `production: true`, `vercel promote`, or an alias to a production domain.
- If Vercel refuses because the project has no deployment yet (`first_deployment_production`; CLI 65.9.0 refuses every preview in that state), nothing was published. Stop, and never retry with `--prod`, even when the message suggests it. Ask the Developer to make the first deployment from a placeholder, so no UI work reaches production: in an empty folder with a copy of the project's `.vercel/` folder, a `public/index.html` holding an empty page and a `vercel.json` of `{ "framework": null, "buildCommand": null, "outputDirectory": "public" }`, run `vercel deploy --prod --skip-domain`. `--skip-domain` leaves the production alias unassigned. Then they re-invoke `/ui-workflow-skills:preview-deploy`.
- Read the target back: `vercel inspect <deployment URL>` prints `target` on stderr (`--json` gives it on stdout), or use the tool's deployment details. The deploy's own output may show no target, so it does not count. Then fetch the production aliases again, except those in `Released site`.
- Unless the target is exactly `preview` and no alias is public, stop: the work may be public. Do not remove or fix anything yourself. Write the deployment URL, its target and each public alias with its status code in `Status: failed: <reason>` in `preview.md`, for the Developer. Tell the Stakeholder in plain words what happened, that no Preview link is ready, and that a Developer must take it off the public address.

Vercel protects previews by default (Deployment Protection), so the plain preview URL shows a Vercel login page on a phone. Ask the Developer, or whoever owns the Vercel project, to create a Shareable Link: Vercel dashboard → Deployments → this preview → Share → "Anyone with the link" → Copy Link. Hobby allows one such link per account. Do not turn off Deployment Protection, do not use Password Protection or the automation bypass secret: they open every deployment of the project.

### 5. Verify the link from outside

Check the link the Stakeholder will get, not `localhost`, with no login and a fresh cookie jar (a Shareable Link sets a cookie on its first redirect): `curl -sSL -b '' -o /dev/null -w '%{http_code} %{url_effective}\n' <link>`.

- It must end in `200` on the Preview's own host. A `401`/`403`, or a redirect to `vercel.com/login` or `vercel.com/sso`, means Deployment Protection is still on: get the Shareable Link (step 4) and check again.
- Also fetch one data request the main page makes, at the address the page really calls (`<link>/api/...` for a tunnel, the public API URL for a static frontend), and check it answers with data, not `404` or a `localhost` URL.
- If anything fails, stop and show the Developer the status code and the URL that failed. A check that could not run (no network, status `000`) is a failure, not a pass.

When it passes, write `URL` and `Status: open` in `preview.md`.

### 6. Hand over the Preview

Give the Stakeholder the output below. For a tunnel, repeat the public-link and real-data warning.

### 7. Approve, go back or record a gap

Approval comes only after the Stakeholder says every checklist box is ticked. If they say "approved" without the checklist, ask which boxes they checked; do not approve on "looks fine".

On approval, close the Preview before anything else:

- Tunnel: stop the tunnel process and the app you started (the process ids in `preview.md`), after checking with `ps -p <pid> -o command=` that each id still runs that command; then check the public URL no longer answers.
- Vercel: ask the Developer to set the Shareable Link back to "Only people with access" and wait until they confirm it is done. The preview deployment itself may stay.
- Staging: nothing to close.

Then write `Status: closed` in `preview.md` and complete the step in the Workflow state (`Current step: done`). Tell the Stakeholder the UI is approved and that releasing it to production is the Developer's job. List any gaps from `preview.md` in a part addressed to the Developer.

When the Stakeholder reports a problem, sort it before doing anything else. This step never changes code. Read the Screens table of `.ui-workflow/integration-plan.md` (C) or the `Frontend folder` of `wiring.md` (A, B), and the `(not redesigned)` marks in `.ui-workflow/design-prompt.md`. If you cannot tell where the problem is, ask where they saw it and stop. A message with both kinds: record the gap first, then go back.

**A gap outside the planned Screens:** a part with no row in the Screens table (A, B: outside the `Frontend folder`), such as one marked `(not redesigned)`. Append `- <YYYY-MM-DD>: <part>: <what they saw, on which device>` under `## Gaps for the Developer` in `preview.md`. Leave the rest of `preview.md`, the Workflow state and the code as they are. Tell the Stakeholder it is outside the planned Screens and recorded for the Developer, that nothing changed, and that the Preview stays open so they can go on with the checklist. A gap does not hold up approval. Do not point to `/ui-workflow-skills:design-port`: it can only change the planned Screens.

**A problem in a planned Screen, or a withdrawn approval, under A or B:** close the Preview the same way, list what broke, and point to `/ui-workflow-skills:integration-wire`. Do not complete the step.

**The same under C** is the way back to the Port. Unless step 0 sent you here for lines already recorded, append `- <Screen>: <what to change, in the Stakeholder's words>` under `## Return to the Port` in `preview.md`, one line per Screen. Then:

- `Blocked` is `none`: close the Preview the same way and write `Status: closed`. Set `Current step: port`, take `port` out of `Completed steps`, so the Preview cannot run again before the change is made, and set `Updated`. Give the command `/ui-workflow-skills:design-port` and stop. That step makes the change, shows it, and commits it after approval as `ui-workflow: port fix <Screen>: <what changed>`.
- `Blocked` holds a reason: only a Developer may clear it, by saying so in this chat or by editing the Workflow state. A Stakeholder's withdrawal does not clear it, and you never clear it on your own. Until then leave the Workflow state and the rest of `preview.md` as they are: repeat the reason, say the change is recorded and that a Developer must clear `Blocked` first, and stop. When a Developer clears it in this chat, set `Blocked: none` and go on as above.

### 8. `.ui-workflow/preview.md`

```markdown
# Preview

- Host: <vercel | tunnel | staging>
- Host reason: <one sentence citing what you saw in the files>
- Run: <command> → <local URL> | none
- Released site: <addresses a Developer confirmed> | none
- URL: <the link given to the Stakeholder> | none
- Processes: <app pid, tunnel pid> | none
- Status: <chosen | open | failed: <reason> | closed>
- Updated: <YYYY-MM-DD> by preview-deploy

## Return to the Port
- <Screen>: <what to change, in the Stakeholder's words>

## Gaps for the Developer
- <YYYY-MM-DD>: <part>: <what they saw, on which device>
```

Each section appears only when it has a line. `design-port` removes a line under `## Return to the Port` once its change is committed. A Developer removes a gap once it is settled.

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
A part you left out of the brief was not redesigned: a problem there is recorded for the Developer, and this link stays open.
```

## Critical Rules

- **Host by project shape, decided first.** Never put a server-rendered app on Vercel.
- **Never production.** No `--prod`, no promote, no production alias, no deploy without a named preview target.
- **Confirm what Vercel reports.** The target reads `preview` and no production alias is public, or nothing reaches the Stakeholder.
- **No local address in the reply,** even when stopping.
- **Verify from outside before showing the link.** A link that opens a login page or 404s is worse than no link; report the failure.
- **Always the checklist.** Approval only after every box is ticked.
- **Close the tunnel after approval.** A forgotten tunnel is a public door into the Stakeholder's computer.
- **Only a Developer clears `Blocked` to go back.** A withdrawn approval is recorded; it never clears a reason a Developer must decide.
- **A gap is recorded, never fixed.** The Preview stays open and no code changes.

## Common Mistakes

- **Deploying a FastAPI/Jinja app's static folder to Vercel.** The templates never render and every API call 404s.
- **Checking `localhost` instead of the public link.** It always works on your machine.
- **Trusting `vercel deploy` with no target.** On a project with no deployment it went to production, with a public alias.
- **Checking only the deployment's own URL.** It sits behind the login page while the production alias answers to anyone.
- **Sending the plain Vercel preview URL.** Deployment Protection shows the phone a login page; use the Shareable Link.
- **Not setting the API URL variable for the Preview environment.** The page loads but has no data.
- **Inventing the run command.** Use the audit's `Run` line, or confirm a detected one with the Developer.
- **Closing the Preview for a gap outside the planned Screens.** `design-port` cannot fix it, so the run goes nowhere.
- **Clearing `Blocked` because the Stakeholder withdrew an approval.** Record the withdrawal without clearing `Blocked`; only a Developer can clear it.

## Red Flags — Stop and Re-check

- About to type `--prod`, even because Vercel's message suggests it → stop, this is preview only.
- About to write `localhost` or a LAN IP in the reply → leave it out; say no link is ready.
- About to give a link you have not fetched from outside → fetch it.
- The Stakeholder says "skip the checklist" → refuse politely, restate why.
- Approval given and the tunnel process is still running → close it now.
- About to edit a template or stylesheet at the Stakeholder's request → this step changes no code.

## Related Skills

- `integration-wire` (A, B) / `design-port` (C) — must complete first
- `ui-audit` — records the `Run` line used for a local run
- Workflow state format and step order: `docs/workflow-contract.md` in this bundle
