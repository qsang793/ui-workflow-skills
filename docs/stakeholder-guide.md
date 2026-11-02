# Stakeholder guide

Make a project's UI better without breaking what already works. You answer questions, look at the result and approve it. Claude Code does the work around an external AI design app. A Developer steps in when a step says so. You never write code, and you never need to open a terminal.

Bản tiếng Việt: [stakeholder-guide.vi.md](stakeholder-guide.vi.md)

> **Status: Beta.** Every Scenario is Beta, Scenario C included: none has passed a real end-to-end run yet. Expect rough edges and keep a Developer within reach. [What has not been proven yet](#what-has-not-been-proven-yet) says exactly what is untested.

## Before you start

- A Developer has installed the plugin ([README](../README.md#install)) and opened the project in Claude Code. The project must be a git repository.
- You have an account on one Design tool: Lovable or Google AI Studio. Plans and prices change, so check them on the vendor's site.
- You know which Developer to contact, and how.

Type each step's command into Claude Code and reply in your own language; Claude follows it. Files named here live in `.ui-workflow/`, a folder file browsers hide because its name starts with a dot. Ask Claude to show you a file in the chat, or to copy a file into that folder for you. If your Developer installed the skills by symlink, leave out the `ui-workflow-skills:` part of each command, including the ones Claude names in its replies.

## Words used here

- **Scenario**: the path of your project. A has no frontend yet, B rewrites the frontend in a new technology, C keeps the technology and improves the look.
- **Design tool**: the external AI app where the new UI is generated.
- **Design prompt**: the text Claude writes for you to paste into the Design tool.
- **Design export**: the code the Design tool gives back.
- **Screen**: one page, or one named view such as a tab, handled as a unit.
- **Blocker**: data or required behaviour the existing backend cannot supply. Only a Developer can decide what happens next.
- **Port**: rebuilding the look of one Screen inside the project's existing code.
- **Work branch**: the separate git branch that holds all changes of this run. It does not touch the main code until a Developer merges it.
- **Preview**: a temporary copy of the changed project that you open on your own phone and laptop.

The full list is in the [glossary](../GLOSSARY.md).

## At a glance

| Scenario | Choose it when | Rough effort |
|---|---|---|
| **A. Greenfield** (Beta) | There is no frontend yet | 1–2 weeks |
| **B. Stack migration** (Beta) | The current frontend blocks you and you accept a rewrite | 3–6 weeks |
| **C. Keep stack** (Beta) | The frontend works and only needs to look better | 3–7 days |

Not sure? C is the safe default. The effort figures are estimates, not measurements from a real run.

| # | Step | Command | A | B | C |
|---|---|---|---|---|---|
| 1 | Pick the Scenario | `/ui-workflow-skills:ui-scenario-picker` | yes | yes | yes |
| 2 | Audit the current UI | `/ui-workflow-skills:ui-audit` | skip | yes | yes |
| 3 | Answer the design brief | `/ui-workflow-skills:design-brief` | yes | yes | yes |
| 4 | Work in the Design tool | no command | yes | yes | yes |
| 5 | Bring in the Design export | `/ui-workflow-skills:ingest-design-export` | yes | yes | yes |
| 6 | Check it against the backend | `/ui-workflow-skills:integration-planner` | skip | yes | yes |
| 7 | Build: Port Screen by Screen | `/ui-workflow-skills:design-port` | no | no | yes |
| 7 | Build: wire the new frontend | `/ui-workflow-skills:integration-wire` | yes | yes | no |
| 8 | Click-test the Preview | `/ui-workflow-skills:preview-deploy` | yes | yes | yes |

Three rules:

1. Never approve a UI from pictures alone. Click it.
2. Never skip the Preview.
3. Never push past a STOP. Show it to a Developer.

## The steps

### 1. Pick the Scenario

`/ui-workflow-skills:ui-scenario-picker`

Claude reads the project's files first, then asks a few short questions, one at a time. If you do not know whether to keep the current technology, it explains the difference and asks again; if you are still unsure, it picks C. It saves the choice in `.ui-workflow/state.md` and names the next command.

If the project holds both new framework code and older code, a migration was left half-finished. Claude stops without picking a Scenario, because a Developer must decide which frontend stays.

### 2. Audit the current UI

`/ui-workflow-skills:ui-audit`

Skipped in Scenario A. Claude reads the code and asks nothing. You get `.ui-workflow/audit.md`: the technology, the pages, and problems ranked High, Medium and Low, at most five of each, with a one-sentence recommendation. If that recommendation names another Scenario, run the picker again; it asks before replacing your choice.

### 3. Answer the design brief

`/ui-workflow-skills:design-brief`

Claude first asks which Design tool you will use:

| Scenario | Suggested tool | Why |
|---|---|---|
| A | Lovable (Google AI Studio also fits) | Simplest way to get the code out |
| B | Lovable for React; Google AI Studio for Angular or Next.js | Lovable offers no choice of framework |
| C | Either | The export is only a visual reference |

Then it asks nine or ten short questions, one at a time: who uses the UI, the top actions, brand, tone, device, inspiration, must-haves, constraints, and sections to leave alone. Take the must-haves seriously: they can never be dropped to fit a design. If you answer "I don't know", Claude offers examples; the second time it picks a safe default and tells you.

You get `.ui-workflow/design-prompt.md`. The prompt is always in English, whatever language you use. Copy only what sits between the `=== COPY EVERYTHING BELOW ...` line and the `=== END COPY ===` line. The part below those lines is for later steps.

### 4. Work in the Design tool

Claude is not part of this step. Paste the prompt into the tool and adjust the result until you like it. Then get the code out:

| Design tool | How to get the code |
|---|---|
| Lovable | "Sync to GitHub" (every plan, needs a GitHub account; the new repository is private by default), or "Download codebase" in Project settings → Git (paid plans) |
| Google AI Studio (Build) | Download a ZIP, or sync to GitHub |

These menus come from the vendors' documentation, checked on 2026-10-27, and may have moved.

In Scenario C any framework is fine, because only the look is used. With Google AI Studio in Scenario C, open Settings before pasting: pick plain HTML if it is offered, otherwise the lightest framework (React rather than Next.js or Angular). This advice is untested; if no such choice appears, paste anyway.

While you are there, take one screenshot of each Screen from the tool's preview. The next step asks for them.

### 5. Bring in the Design export

`/ui-workflow-skills:ingest-design-export`

Tell Claude where the export is:

| You have | Say something like |
|---|---|
| A ZIP file | "The ZIP is at `~/Downloads/my-design.zip`" |
| A GitHub repository | "The repository is `https://github.com/you/my-design`" |
| An unzipped folder | "I unzipped it at `~/Desktop/my-design`" |
| Code in a chat | "I will paste the files here" |

A private repository can only be copied if this computer has access to it. If the copy fails, use the ZIP or ask your Developer.

Claude copies the files into `.ui-workflow/export/` and never installs or runs them. If an earlier export is there, it asks before moving that one to a backup. It tells you the framework it found and lists the Screens, then asks for the optional screenshots and gives the file name for each.

Two stops: a ZIP that is rejected as unsafe (download it again from the Design tool), and 🚨 SCENARIO MISMATCH, which means the export does not fit your Scenario. Follow what the message says; if that does not help, call your Developer.

### 6. Check it against the backend

`/ui-workflow-skills:integration-planner`

Skipped in Scenario A. A Design tool does not know your backend, so it can draw data that does not exist and buttons that do nothing. Claude compares the two and writes `.ui-workflow/integration-plan.md` with a verdict:

| Verdict | Meaning | What you do |
|---|---|---|
| PROCEED | The design fits the backend | Run the next command |
| PROCEED WITH CAUTION | It fits, with small adjustments or things Claude could not check | Read the Not checked list, run the next command |
| STOP | At least one Blocker | Show the plan to your Developer. No later step may run |

For a button that exists only in the design, Claude asks you to drop it (the default) or show it disabled with a "coming soon" label. After you answer, it may ask you to run this step again. Behaviour the screen has today, and your must-haves, can never be dropped: if the backend cannot do them, that is a Blocker. So is data the design shows that the backend does not have, even when the Design tool invented it, such as a testimonial; the Developer decides.

### 7. Build

Claude creates the Work branch `ui-workflow/<date>` and commits only after you approve. It never pushes or merges; changes of your own that are not committed are left alone.

#### Scenario C: Port one Screen at a time

`/ui-workflow-skills:design-port`

For each Screen, in the plan's order:

1. Claude rebuilds its look in the project's existing templates and styles.
2. It starts the project's own app on this computer and gives you a local link, such as `http://127.0.0.1:8000`, and where to click. The link works only on this computer, and the app uses this computer's settings, so treat what you see as real data. The check on a phone comes in the Preview.
3. It runs the project's own checks. If one fails or could not run, the report opens with that, in plain words, so you know before you approve. Its report also lists the files changed, the decisions applied, what it had to substitute, and what it could not reproduce, plus claims it left out, such as sources, counts, dates and testimonials, because a Design tool invents these. It asks before using any image from the export, which may be generated even when it is labelled a real photo or record.
4. You open the link and reply: approve, or say what to change. A change is made on the same Screen and shown again. An approval commits that Screen, and the next one starts.

If the app does not start, Claude stops and a Developer must get it running. You are never asked to install or run anything.

#### Scenarios A and B: wire the new frontend

`/ui-workflow-skills:integration-wire`

- **Scenario A:** the Design export becomes the project, in the project root if it is empty, otherwise in a new folder you name. It keeps showing sample data, kept in `src/lib/mock/`, until a backend exists.
- **Scenario B:** the new frontend goes in its own folder, `frontend-new/` unless you name another, and talks to your real backend using the login it already has. The old frontend and the backend stay untouched.

The new frontend's build must pass. If it fails or cannot run, Claude stops and a Developer must fix it. Keys or passwords found in the export are removed and reported to the Developer. When the build passes, Claude reports what it did and asks whether to save it and go on. You first see the result running in the Preview.

### 8. Click-test the Preview

`/ui-workflow-skills:preview-deploy`

Claude chooses where the Preview runs from the project's shape; you do not choose:

| Project | Where it runs | What to expect |
|---|---|---|
| The backend serves the pages, the frontend needs a server, or a static frontend reaches a backend that runs only on this computer (if that cannot work through one address, a Developer takes over) | Your computer, through a temporary tunnel | The link is public: anyone who has it can open the app. It may read and change **real data**, so avoid delete, send and pay actions unless you know they are safe. This computer must stay on and online. Live updates may not work |
| A static frontend with a public backend, or none | A Vercel preview, never production | A Developer logs in to Vercel once, and whoever owns the Vercel project creates a Shareable Link. Without that link your phone shows a login page. A project never deployed before first needs one placeholder deployment from a Developer |
| The project has its own staging environment | Staging | Only when a Developer confirms it |

Claude checks that the link opens from outside before giving it to you. On Vercel it also confirms that Vercel reports a preview and that the project's production address is not open. If any check fails, you get no link and a Developer takes over. Claude never offers a local address for your phone, because it cannot open there.

Tick every box, on your real devices:

- [ ] Open on your **phone**: every button reachable with a thumb, no sideways scrolling
- [ ] Open on your **laptop**: no text overflow, no odd empty space
- [ ] Sign in and sign out work (if the app has them)
- [ ] Each main feature: finish one full task from start to end
- [ ] Try a failure (wrong input, wifi off): is there a clear error message?
- [ ] Slow actions show a loading state instead of freezing
- [ ] Empty lists show an empty state instead of a blank page

All ticked: reply **preview approved**. If you only say it looks fine, Claude asks which boxes you checked. The link is then closed: Claude stops the tunnel, or waits for the Developer to switch off the Shareable Link.

Something wrong: describe what broke and on which device, and do not approve. Claude closes the Preview and names the step that fixes it.

### After approval

The approved UI sits on the Work branch and nothing has been pushed. Pushing, merging and releasing to production are the Developer's job; this workflow stops at an approved Preview.

## When to call your Developer

Do not try to fix these yourself. Send the Developer Claude's whole message and the file `.ui-workflow/state.md`. If Claude's message contains a part addressed to the Developer, forward it; do not run its commands yourself.

| What happens | What the Developer does |
|---|---|
| Half-finished migration found at step 1 | Decides which frontend stays |
| The project is not a git repository | Sets up git |
| Verdict STOP at step 6, for example the design needs data or a login the backend does not have | Decides on each Blocker |
| The run command is `unknown`, or the app does not start | Confirms the command, gets the app running |
| The Work branch cannot be used, or its name is already taken | Sorts out the branch |
| A Screen or file collides with your own uncommitted changes | Commits them or sets them aside |
| Scenario B: the backend expects an API key or other shared secret from its callers | Puts those calls behind a server-side route |
| A key or password was found in the export | Rotates it |
| The build fails, cannot run, or wants to run install scripts | Fixes the build or decides on the scripts |
| Preview: Vercel is not logged in, the project needs its first placeholder deployment, a Shareable Link is needed or must be closed, no tunnel tool works, or the link fails from outside | Sets it up or fixes it |
| Preview: Vercel reports something other than a preview, or the project's production address opens | Takes it off the public address, or confirms it is the released site |
| The Preview still shows the old UI or its buttons do nothing, and running the step Claude names does not help | Finds the cause |
| The UI is approved | Reviews, merges and releases |

A step that says `Blocked` will not move on until the Developer decides. Re-running the step that stopped is always allowed.

## If you lose your place

Your progress is saved in `.ui-workflow/state.md`, so you can close Claude Code and come back. Run any step: if an earlier one is missing, Claude names it and gives its command instead of guessing. Run the picker if you want to start over; it asks first.

## What has not been proven yet

- **No real end-to-end run.** No Scenario has gone from the first step to an approved Preview on a real project. A real [pilot of Scenario C](https://github.com/qsang793/ui-workflow-skills/issues/13) is next. Only if it passes does C become Production; A and B stay Beta after that.
- **No real export from Lovable or Google AI Studio has gone through the workflow.** The Port rules were tried on one Screen from another tool's export (Google Stitch) and on small sample exports. Whether reading a real Lovable export's source is enough is what the pilot checks.
- **The rest was tested on sample projects.** Automated tests ran each skill on small samples, and that testing cannot open a local app. So viewing a Screen in the running app has not been tested by it, and no real framework project has been installed and built.
- **No Preview link has been opened on a real phone** through these skills. The tests check which host Claude chooses, not a live tunnel or Vercel link.
- **Vendor details can change.** Design tool menus and plans come from documentation checked on 2026-10-27.
