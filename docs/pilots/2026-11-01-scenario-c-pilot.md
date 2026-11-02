# Pilot Report: Scenario C on a private project

**Date:** 2026-11-01
**Issue:** #13
**Status:** stopped before approval, so not accepted. The owner opened one Preview on a real phone, reported a gap (finding 10), and then ended demos on this project. The release that follows is 0.3.0, with Scenario C still Beta. 1.0.0 waits for a pilot on another project.

## Setup

| Item | Value |
|---|---|
| Project | A private project of the owner: a static TypeScript site with one plain CSS file and no backend. Its name and content stay out of this repo. |
| Isolation | A separate clone with no remote and git hooks turned off. The original checkout stayed at the same commit, with its uncommitted file untouched. |
| Stakeholder | An AI agent (Opus) played the role and sent every message. The owner signed in to the Design tool and Vercel, created the Shareable Link and opened the Preview on a phone. |
| Agent under test | `claude -p --model sonnet` with this plugin, resumed turn by turn, in the clone. |
| Design tool | Lovable, Free plan, reached through its MCP connector. Training was turned off by the owner. The app was never published. |
| Export | TanStack Start project, 86 files. 10 were copied by hand into a folder and ingested from there. |
| Reported cost | 2.59 USD equivalent, from the CLI's cumulative figure for the agent under test. It ran on the subscription. |

**Limit of this pilot:** the Stakeholder knows these skills and can read code, so it cannot judge whether a non-technical person would understand the replies. It also clicked in an emulated phone viewport; only the owner used a real phone.

## Result by step

| Step | Result | Notes |
|---|---|---|
| Picker, audit, brief | Done | Each reply said the page had not been opened. The audit reply has technical detail (file names, line counts). One Required behaviour line was inferred from code, and the brief said so. |
| Design tool | Partial | One build gave 3 variations of the first Screen. The follow-up message was refused: out of credits. |
| Ingest | Done | Framework and 5 routes found. It flagged that the export's two images were missing from the folder. |
| Planner | Done | PROCEED WITH CAUTION, no Blockers, one design-only action, dropped by the Stakeholder. |
| Port | Done after a fix | 3 Screens, one commit each, plus one fix commit. A regression passed the first approval (finding 2). |
| Preview | Open, never approved | Correct host (Vercel, static site, no backend). It first stopped because the CLI was not installed. After the owner logged in, it published to production by mistake (finding 1). The pilot runner deployed the real preview by hand. |
| Phone | Partial | The owner opened the Preview through the Shareable Link and reported finding 10. The checklist was not completed, and the fix for finding 10 was not retried on a phone. |

## Findings

### 1. Preview published to production and reported a preview (critical)

`preview-deploy` says to deploy as a preview with `vercel deploy` and no `--prod`. On a project with no earlier deployment, that command gave `target production` (CLI 65.9.0, one run), with a production alias on `vercel.app`. That alias answered 200 from outside with no sign-in.

The skill's outside check fetched only the deployment's own URL, which was behind the sign-in page. So the agent told the Stakeholder the deployment was a preview, not the official version, and that it was blocked by a login page. Both statements missed the public alias.

The pilot runner found this by running `vercel inspect`, about three minutes after the deploy. It removed the alias, confirmed a 404, and deployed again with `--target preview`, which gave `target preview` behind the sign-in page. The first production deployment still exists behind the sign-in page. Unmerged UI work was public for those minutes. Whether anyone opened it is unknown.

**Proposed fix:** deploy with `--target preview`, read the target back with `vercel inspect` and stop unless it says `preview`, and check the project's production alias from outside. Add an eval for a project with no deployments. Recheck the Vercel path of Scenarios A and B too, because they use the same step.

**Later correction (#31):** `--target preview` worked here only because the first production deployment already existed. On a project with no deployment, CLI 65.9.0 refuses it. The skill now stops in that state and asks the Developer for a placeholder deployment.

### 2. Port skipped a project check, and a regression passed approval (high)

The project has two checks: `npm test` and `npm run test:browser`. Neither needs an install. Port ran only the first, on all three Screens, and said it had not run the second.

| Commit | `test:browser` |
|---|---|
| Base commit | PASS, 226 assertions |
| After the 3 approved Screens | FAIL, 0 assertions counted (photo must not be cropped) |
| After the fix commit | PASS, 226 assertions |

Fixing the first failure exposed a second one from the same Port: secondary text colour under the project's 7:1 contrast rule. The contrast step in the skill checks 4.5:1, so it could not see this project's stricter rule.

The Stakeholder approved the crop even though the Screen report listed it, in a list of differences from the design. So disclosure alone did not protect the project: nothing marked it as breaking existing behaviour. The failure was found only because the pilot runner ran the check by hand.

**Proposed fix:** `ui-audit` records the project's check commands next to the `Run` line. `design-port` runs all of them before showing a Screen, and a check it did not run or that fails is stated first in the report, above the approval question.

### 3. Preview gave a link that cannot work on a phone (medium)

After stopping, the reply offered `http://127.0.0.1:4174/` to open on a phone on the same Wi-Fi. That address is the phone itself. The reply said this had not been tested, but a non-technical Stakeholder would try it.

**Proposed fix:** `preview-deploy` never offers a local address for another device.

### 4. No way back from a later step (medium)

The Stakeholder withdrew an approval while `Blocked` held the Preview reason and `Current step` was `preview`. Step 0 of `design-port` says to stop in that case. The agent went on instead: it cleared `Blocked`, moved the state back to `port`, and made a commit named `ui-workflow: port fix ...`. The result was sensible, but no rule covers it.

**Proposed fix:** define the return path to `port` for a change to a committed Screen: who may clear `Blocked`, and the commit name.

### 5. The Design prompt relies on a second message that may not be possible (medium)

The prompt asks for variations of the first Screen, then "apply it to every Screen". After one build on the Free plan, the next message was refused for lack of credits. The connector does not show the balance, so how much that build used, and how much earlier use counted, is unknown.

The two other Screens stayed in the look of the first build, and the three requested changes went to Port by chat. That worked because the Screens shared one stylesheet.

**Proposed fix:** the guide warns that a follow-up may not be possible the same day, and the brief asks for one shared style in the first message.

### 6. No step records the chosen variation (low)

Ingest listed the three variations as separate Screens. The planner kept the chosen one only because the Stakeholder named it unprompted. What happens without that message was not tested.

**Proposed fix:** when several routes render one Screen, ingest or the planner asks which one to use.

### 7. Port did not open the screenshots (low)

Three screenshots were in the named folder. The session log shows them listed, never read, although the skill says to read them. It made no visible difference here, because the source settled every value used.

### 8. A misattributed cause in a report (low)

Port blamed the export's overflow at 375px on the large title. The export's CSS suggests another cause: a single-column grid with an auto track and a `nowrap` index. This is from reading the CSS only, and was not tested. The project's own page did not overflow, so the result was not affected.

### 9. Design tool preview needs a sign-in (low)

The preview URL from the connector redirected to the Lovable sign-in page in a browser without a session. A Stakeholder already signed in would not notice. Earlier advice in this pilot that the link opens without an account was wrong for this URL.

### 10. The real phone found a gap no earlier step could see (medium)

On a real phone, the owner found that the 3D view has no zoom or free camera, and that the model is cut off at both sides in portrait. The renderer code had fixed viewpoints only, and no skill changed it in this run, so the gap predates the Port. It stayed out of scope because the agent playing the Stakeholder chose in the brief to leave the 3D view as it was. Neither that agent nor the emulated viewport checks raised the problem.

The skill's only route for a reported problem is to close the Preview and go back to `design-port`, which may change only the look of the planned Screens. A problem in a part marked "not redesigned" has no route.

At the owner's request, the pilot runner changed the 3D view by hand, outside the skills: free orbit, zoom and pan, and a wider view in portrait. The project's own checks passed (75 unit tests, 230 browser assertions), and emulated touch gestures worked at 390×844. This change was not retried on a real phone and is uncommitted in the clone.

**Proposed fix:** `preview-deploy` separates problems in the planned Screens from gaps outside them, and records the second kind for the Developer without closing the Preview. The guide says that a part left out of the brief is not tested for quality on a phone.

### Unexplained

On a server just restarted, the 3D scene failed once in 4 loads, with both files answering 200. "Retry" worked, and the next two loads were fine. The commit in between changed only CSS. The cause was not established.

## What worked

- Local checks by the Stakeholder agreed with Port's claims: catalogue summaries at 16px, no sideways scroll at 375px on all 3 Screens and at 320px on the panel, source links 44px tall, panel photos shown whole after the fix.
- Choosing a row opened the reading page, the index switched artifact, the last next button returned to the catalogue, Esc closed the panel and focus returned to the opener. The other previous and next buttons were not clicked by hand.
- Invented content stayed out: sources, credits, licences, a made-up file name and generated photos. Real fields from the project's data were used instead.
- Nothing was pushed. Commits landed only on the Work branch, staged by path.
- Preview refused to fall back to another host, and refused to treat a push to the main branch as a Preview.

## ADR-0004: was reading source enough?

Yes for this export, with no amendment proposed. It is weak evidence for the hard cases:

| Question | Answer |
|---|---|
| Component tree | Shallow. The Screens used plain markup and imported none of the generated UI components. |
| Theme logic | A `.dark` block and a Tailwind v4 `@theme` block were present and unused by the Screens. |
| CSS-in-JS | None. |
| Tailwind plugins | `tw-animate-css` imported, not used by the Screens. |
| Screenshot required | No. Port never read them. |

The export was easy because the Design prompt asked for one plain CSS file with variables, and Lovable followed it. Resolving Tailwind classes from a Lovable export remains untested.

## Deviations from the guide

- The Stakeholder was an agent, not a person (see the limit above).
- The export came through the connector, not "Sync to GitHub" or a download, so those routes were not exercised.
- 10 of 86 files were copied, leaving out unused UI components and binary files. Screenshots were saved from the built-in browser at 375px.
- The Stakeholder saw the Design tool in an emulated viewport. The real-phone check is done by the owner, not the agent.
- A person outside the guide ran `test:browser` and passed the failure back through the Stakeholder.
- The pilot runner removed the production alias, deployed the real preview, and changed the 3D view by hand (findings 1 and 10).

## Not tested

- The skill's own check of a Preview link from outside on a real deployment, the click-test checklist, approval, and closing the Preview. The owner's Shareable Link opened on a phone, but the skill never checked that link.
- The FastAPI/Jinja path and its tunnel, which stay checked on fixtures only (#13).
- The restyled catalogue error note with its retry button, by hand. Only the project's own checks cover it.
- Non-technical comprehension.

## Remaining

1. File the findings above as issues. Findings 1, 2, 3 and 7 are fixed before the release (#14). The evals `preview-first-deploy` and `port-all-project-checks` fail on the skills this pilot ran, and must pass after the fixes. The other findings stay open and are listed in the changelog as known limits.
2. For 1.0.0 and #13: a full run on another project, following the final guide, with a person as Stakeholder, up to an approved Preview on a real phone.

**Decision:** release 0.3.0 with every Scenario Beta. Finding 1 published to production against a critical rule, finding 2 is a real regression that passed approval, and this pilot's Stakeholder was not a person. ADR-0001 stands: Scenario C becomes Production only after a real pilot passes.
