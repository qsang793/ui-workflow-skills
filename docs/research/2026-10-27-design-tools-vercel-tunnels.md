# Research: Design tools, Vercel preview protection, no-account tunnels

Purpose: facts for ADR-0002 (Scenario C plain HTML + CSS export) and ADR-0003 (host-agnostic Preview, tunnel for server-rendered apps).

Checked: 2026-10-27
Issue: https://github.com/qsang793/ui-workflow-skills/issues/4

Method: primary sources only (vendor docs, changelogs, first-party blog/GitHub). Each source page was fetched on 2026-10-27. "Source says" and "Inference" are labeled. Page text was read through a fetch tool that summarizes pages, so quotes are as returned by that tool; re-verify any quote you will paste into an ADR.

## Summary

| # | Question | Short answer | Confidence |
|---|----------|--------------|------------|
| Q1 | Google AI Studio Build: plain HTML + CSS? | No. Build generates a full-stack app; React is the default, Angular and Next.js are selectable. Docs name no plain HTML option. Prompting for plain HTML is untested. Export: ZIP, two-way GitHub sync, Cloud Run. | High (React default, export); Medium (Angular/Next.js, from a Mar 2026 blog); Unknown (plain HTML via prompt) |
| Q2 | Lovable export and stack | ZIP (paid plans only), GitHub two-way sync (all plans, needs GitHub account), single-file copy/download. Stack: TanStack Start (apps from 2026-05-13) or React + Vite (older). No framework choice. No plain HTML option documented. | High |
| Q3 | Vercel Deployment Protection | Previews are protected by default (Vercel Authentication, Standard Protection). Phone viewer with no account: use a Shareable Link (all plans; Hobby limited to 1 link per account; no login needed). Password Protection needs Pro ($20/project/month). | High (defaults, plans); Unknown (UI link expiry) |
| Q4 | No-account tunnel | Cloudflare quick tunnel: no account, random `trycloudflare.com` URL each run, 200 in-flight requests cap, no SSE, no uptime guarantee. Best no-account fit. localhost.run is a fair alternative (SSH only, URL rotates). Pinggy free shows a screening page and has a 60-minute limit. localtunnel shows a password page. | High (Cloudflare); Medium (alternatives) |

## Q1. Google AI Studio (Build mode)

Short answer: Build does not return plain HTML + CSS by default. It builds a full-stack app with a React frontend and a Node.js server. Angular and Next.js are selectable per a Google blog post. No primary source documents a plain HTML/CSS option.

Source says:
- Web apps get "a web frontend (React is the default)" plus a Node.js server-side runtime. [Build apps in Google AI Studio](https://ai.google.dev/gemini-api/docs/aistudio-build-mode) (page last updated 2026-10-26; checked 2026-10-27).
- The full-stack guide refers to the "client-side framework (React/Angular)". [Develop full-stack apps](https://ai.google.dev/gemini-api/docs/aistudio-fullstack) (checked 2026-10-27).
- "In addition to React and Angular, we now support Next.js apps out of the box." The framework is picked in the "Settings" panel. [Google blog, 2026-03-18](https://blog.google/innovation-and-ai/technology/developers-tools/full-stack-vibe-coding-google-ai-studio/) (checked 2026-10-27).
- The Build docs page has no mention of Angular, Next.js, vanilla JS, HTML-only, or templates (searched in the fetched text). So the Settings picker is documented only in the blog post.
- Android apps are generated as Kotlin + Jetpack Compose. Not relevant here.

Export (all from the [Build docs](https://ai.google.dev/gemini-api/docs/aistudio-build-mode), checked 2026-10-27):
- ZIP: "Export the generated code as a ZIP file and import it into your code editor." If run elsewhere you must set the `GEMINI_API_KEY` environment variable.
- GitHub: "two-way sync" with a repository; pushes get AI-generated commit messages; sync status is managed in Settings.
- Cloud Run: deploy gives a public URL with the API key kept server-side. [Deploying](https://ai.google.dev/gemini-api/docs/aistudio-deploying): a "Starter Tier" lets eligible accounts publish up to 2 full-stack apps without a Google Cloud project or billing; Google Workspace accounts and accounts with a prior paid billing account are ineligible; standard deployment needs a Cloud project with billing.
- Copy from the editor: not documented in the pages read. Unknown.

Chat / non-Build mode: I did not find a primary-source doc that says the plain chat (Gemini API playground) returns an HTML file in a defined way. Unknown.

Community evidence (lower confidence, not Google staff): in Nov 2025 a forum user reports Build "only supports generating code in React.js" and a reply says settings offered React or Angular only. [Forum thread](https://discuss.ai.google.dev/t/ai-studio-vibe-coding-allows-vibing-with-react-js-only/108688) (checked 2026-10-27). This predates the March 2026 Next.js blog post.

Inference (not from a source): since Build always scaffolds a project (React default, Node server), a prompt such as "plain HTML + CSS, no framework, no JS" will either be ignored or yield a React project with static markup. Nothing documents that the model obeys it. Test it before relying on it.

Unknown: whether any setting, template, or system instruction yields a plain HTML/CSS project. Tried: Build docs, full-stack docs, changelog (no Build/framework entries found in the entries returned), blog, forum.

## Q2. Lovable

Short answer: Export is ZIP (paid), GitHub two-way sync (all plans), and per-file copy/download. The stack is TanStack Start (new apps) or React + Vite (older apps). Lovable offers no framework choice, and no plain HTML/CSS option is documented.

Source says (checked 2026-10-27):
- GitHub sync: needs a GitHub account; two layers (workspace connection via the Lovable GitHub app, project-to-repo link); "Changes pushed to the currently active branch sync back into Lovable"; new repo is private by default; it cannot link to an existing repo; one branch at a time. [Sync with GitHub](https://docs.lovable.dev/integrations/github). Available on all plans.
- Other Git hosts: Bitbucket Cloud sync added 2026-09-10. [Changelog](https://docs.lovable.dev/changelog).
- ZIP: "Download codebase" under Project settings -> Git, paid plans only, "no repository connection needed" (changelog entry 2026-08-14). Enterprise admins can restrict ZIP downloads. [Code editor](https://docs.lovable.dev/features/code-mode), [Changelog](https://docs.lovable.dev/changelog).
- Code editor: view, copy a file's content, download one file (any plan). Editing needs a paid plan; the Free plan is read-only. [Code editor](https://docs.lovable.dev/features/code-mode).
- Git sync and ZIP include source and DB migration files, not DB contents or uploaded files. [Deployment, hosting, ownership](https://docs.lovable.dev/tips-tricks/deployment-hosting-ownership).
- Stack: "New apps created from May 13, 2026 use TanStack Start, which runs server code." Older apps use React + Vite and build to static files (`dist/`). Backend: PostgreSQL via built-in backend (Lovable Cloud) or Supabase. [Hosting outside Lovable](https://docs.lovable.dev/tips-tricks/external-deployment-hosting), [FAQ](https://docs.lovable.dev/introduction/faq).
- "Lovable does not offer a choice of framework or database." [FAQ](https://docs.lovable.dev/introduction/faq).
- Older projects can upgrade in place to TanStack Start (2026-07-28). [Changelog](https://docs.lovable.dev/changelog).
- Remix exists (changelog 2026-09-08 and 2026-09-11: remix no longer copies project files by default; remixing requires sign-in). It is a Lovable-to-Lovable copy, not an export. [Changelog](https://docs.lovable.dev/changelog).

Not confirmed from docs: Tailwind and TypeScript. The docs pages read do not name them. A Lovable marketing page says it uses Tailwind (secondary: not docs). Treat "Tailwind + TypeScript" as likely but unverified.

Inference: a TanStack Start app needs a Node host (the docs example uses `node .output/server/index.mjs`). A Stakeholder's returned code may therefore not be static-hostable. This matters for ADR-0003 only if the app itself is a Lovable app; for Scenario C we only port the HTML + CSS.

Unknown: whether a prompt can make Lovable return plain HTML/CSS. Docs say stack is fixed. Treat as not possible.

## Q3. Vercel Deployment Protection

Short answer: Preview URLs are protected by default. A phone viewer with no Vercel account can open a protected preview through a Shareable Link. It needs no login. Hobby gets one link per account.

Source says (checked 2026-10-27):
- Default: "By default, Vercel Authentication is automatically enabled for all deployments with the exception of the most recent production deployment." [KB: locking down deployments](https://vercel.com/kb/guide/locking-down-deployments). This is Standard Protection, defined as protecting all deployments except production domains. [Deployment Protection](https://vercel.com/docs/deployment-protection). A changelog also says team-wide defaults can be set and "every new project starts with Vercel Authentication enabled for all deployments". [Changelog](https://vercel.com/changelog/protect-production-deployments-for-free-on-every-plan). The two sources differ slightly on production scope. Inference: new projects get preview protection on every plan; verify in the dashboard for a given team.
- Plans: Vercel Authentication, Standard Protection, All Deployments: included on Hobby, Pro, Enterprise. [Usage & Pricing](https://vercel.com/docs/deployment-protection/usage-and-pricing).
- Without a bypass, visitors get a Vercel login redirect. A logged-in user without access sees a "request access" option, which emails and notifies branch authors. Only Vercel account holders can request. Hobby: one external user per account. [Vercel Authentication](https://vercel.com/docs/deployment-protection/methods-to-protect-deployments/vercel-authentication).
- Sharing page: an external collaborator "does not need to have a Vercel account", but needs one to view a protected deployment (the invite route) or use the toolbar. [Sharing a Preview Deployment](https://vercel.com/docs/deployments/sharing-deployments).

Shareable Links:
- Available on all plans; Hobby is limited to one link in total per account. [Shareable Links](https://vercel.com/docs/deployment-protection/methods-to-bypass-deployment-protection/sharable-links), [Usage & Pricing](https://vercel.com/docs/deployment-protection/usage-and-pricing).
- Created in the dashboard: Deployments -> select a preview -> Share -> "Anyone with the link"; then use Copy Link (not the address-bar URL). Needs Developer role or higher for non-production domains. [Shareable Links](https://vercel.com/docs/deployment-protection/methods-to-bypass-deployment-protection/sharable-links), [Sharing](https://vercel.com/docs/deployments/sharing-deployments).
- No login: the changelog says shareable links share private previews "without the need to log in". [Changelog](https://vercel.com/changelog/protected-preview-deployments-available-on-all-plans).
- Revoke: set the dropdown back to "Only people with access". All links listed under Deployment Protection -> Access. [Shareable Links](https://vercel.com/docs/deployment-protection/methods-to-bypass-deployment-protection/sharable-links).
- Expiry: the dashboard docs do not state one. The REST API accepts an optional `ttl` in seconds (max 63072000); "If not provided, the shareable link will never expire." It also has a `revoke` option with `regenerate`. [API reference](https://vercel.com/docs/rest-api/reference/endpoints/aliases/update-the-protection-bypass-for-a-url). UI default expiry: Unknown.
- Branch link vs commit link: the share modal defaults to the branch link (latest commit); a commit link is fixed. [Sharing](https://vercel.com/docs/deployments/sharing-deployments).

Protection Bypass for Automation:
- All plans. A secret sent as header or query param `x-vercel-protection-bypass`; add `x-vercel-set-bypass-cookie: true` to set a cookie for browser follow-up requests. Requires member role (or Project Admin) to configure. The secret is valid for all deployments of the project until revoked. [Docs](https://vercel.com/docs/deployment-protection/methods-to-bypass-deployment-protection/protection-bypass-automation).
- Inference: with the query param plus cookie flag a phone browser could open a link with the secret in the URL. The docs show this for webhooks and testing, not for human sharing. A leaked URL opens every deployment of the project. Prefer Shareable Links.

Password Protection:
- Pro: $20 per month per protected project. Enterprise: included. Hobby: not available. Legacy Pro "Advanced Deployment Protection" package: $150 per month per team. Visitor enters the password once per deployment (cookie). [Password Protection](https://vercel.com/docs/deployment-protection/methods-to-protect-deployments/password-protection).

Disable: toggle off Vercel Authentication in Settings -> Deployment Protection, or API `ssoProtection: null`. All existing deployments become unprotected. [Vercel Authentication](https://vercel.com/docs/deployment-protection/methods-to-protect-deployments/vercel-authentication). Team default can also be set to "None". [Deployment Protection](https://vercel.com/docs/deployment-protection).

Also available: Deployment Protection Exceptions and Trusted Sources (named in the docs; not read in detail).

## Q4. No-account temporary tunnels

### Cloudflare quick tunnel

Short answer: `cloudflared tunnel --url http://localhost:PORT` needs no Cloudflare account and no domain. It prints a random `trycloudflare.com` HTTPS URL.

Source says ([Quick Tunnels](https://developers.cloudflare.com/tunnel/get-started/quick-tunnels/), checked 2026-10-27):
- "You do not need a Cloudflare account or domain."
- "Quick Tunnels have no uptime guarantee."
- "Each Quick Tunnel supports up to 200 in-flight requests. Additional requests return a `429` response."
- "Quick Tunnels do not support Server-Sent Events (SSE)."
- "The hostname changes each time you create a Quick Tunnel."
- The URL stops working when `cloudflared` stops.
- Optional access control: `--allowed-mail` with one or more addresses; visitors enter their email and a one-time PIN. It needs an interactive browser. (Inference: this adds friction for a non-technical viewer; avoid by default.)
- WebSocket support and a fixed time limit: not stated on this page. Unknown. A web search summary claimed tunnels are for testing/development only; I could not confirm that exact wording on the page, so it is not used here.
- Config file caveat (an existing `~/.cloudflared/config.yaml` can stop quick tunnels from starting): seen only in a search summary of a third-party draft issue, not on the quick-tunnels page. Lower confidence. Check when testing.
- Related, for named tunnels in general: responses are buffered unless the origin sends `text/event-stream`. [Tunnel troubleshooting](https://developers.cloudflare.com/tunnel/troubleshooting/). Not stated for quick tunnels.

Install ([Downloads](https://developers.cloudflare.com/tunnel/downloads/), checked 2026-10-27):
- macOS: `brew install cloudflared`, or a Darwin `.tgz` from GitHub releases.
- Windows: `cloudflared-windows-amd64.exe` or `.msi` from [GitHub releases](https://github.com/cloudflare/cloudflared/releases/latest). No package-manager command on the page. No auto-update.
- Linux: Cloudflare package repository (https://pkg.cloudflare.com/), or binary / `.deb` / `.rpm` from GitHub releases.

### Alternatives (no account)

| Tool | Command | Limits (source says) | Warning page? | URL |
|------|---------|----------------------|---------------|-----|
| localhost.run | `ssh -R 80:localhost:8080 localhost.run` (use `nokey@localhost.run` if key errors) | No download or signup for free domains. Speed limit. Free tunnels change domain "after a few hours". | None documented | Random, rotates |
| Pinggy free | `ssh -p 443 -R0:localhost:8000 free.pinggy.io` (press Enter at password prompt) | 60-minute tunnel timeout; unlimited data. | Yes: a one-time "browser screening page" for free tunnels, once per browser; confirm to continue | Random, changes each tunnel |
| localtunnel | `npx localtunnel --port 8000` | URL lasts "for the duration of your session". Requested subdomain not guaranteed. | Yes: a consent page asks a human to enter the tunnel creator's public IP as the "password" | Random unless requested |
| bore | `bore local 8000 --to bore.pub` | TCP only, `bore.pub:<random port>`. No HTTPS URL in the README. | n/a | Not usable for a phone HTTPS preview |

Sources: [localhost.run](https://localhost.run/docs/), [localhost.run free tier](https://localhost.run/docs/forever-free/), [localhost.run FAQ](https://localhost.run/docs/faq/), [Pinggy docs](https://pinggy.io/docs/), [Pinggy pricing/home](https://pinggy.io/), [Pinggy screening page](https://pinggy.io/docs/http_tunnels/screening/), [localtunnel README](https://github.com/localtunnel/localtunnel), [localtunnel announcement issue #598](https://github.com/localtunnel/localtunnel/issues/598), [bore README](https://github.com/ekzhang/bore). All checked 2026-10-27.

Notes:
- localtunnel: the password page comes from announcement issue #598 (a maintainer announcement, with user comments). The README does not mention it. A `Bypass-Tunnel-Reminder` header skips it for non-browser clients (a user comment in the issue; lower confidence). A phone user would see the page, which fits "confuse a non-technical user".
- Pinggy: the page is shown once per browser. The Pinggy pages read disagree on whether an account is needed for the free tier; the docs command above works without one per the docs page, but I did not run it.
- Serveo: not checked against first-party docs. Unknown.
- ngrok: you said it needs an account. The ngrok docs pages I fetched did not state this either way. Unknown from primary text; ngrok is excluded anyway.
- I did not run any tunnel. All limits are from docs only.

## Implications

### `design-brief`

- Scenario C (keep FastAPI + Jinja + vanilla JS): neither tool is a safe source of plain HTML + CSS. Lovable fixes its stack (React/TanStack Start). AI Studio Build defaults to React with a Node server. Treat both as returning React projects.
- Recommend Design tool by scenario:
  - Scenario A/B (new React-style frontend): Lovable or AI Studio Build; both fit. Lovable has the simpler export for a non-technical person (GitHub sync, ZIP on paid plans). AI Studio documents ZIP, GitHub sync and Cloud Run export (plan limits not checked); the framework must be set in Settings.
  - Scenario C: either tool, with the prompt asking for a visual reference only. Port the visual result (layout, tokens, copy) into Jinja + CSS by hand. Do not require the tool to emit plain HTML.
- Design prompt must say (Scenario C): "Design only the look: layout, spacing, colors, fonts, component states. Prefer plain semantic HTML and one CSS file with CSS variables; avoid component-library-specific markup. No routing, no state, no backend." Also: list screens and the real copy/field names, and ask for a single page per screen. Tell the plugin the result may still be React; the plugin extracts tokens and markup, not the runtime.
- For AI Studio, ask the Stakeholder to set the framework in Settings if it offers a choice, and to try plain HTML. Mark that as untested.
- Export instructions to the Stakeholder: AI Studio -> download ZIP (needs a Google login to use AI Studio). Lovable -> "Download codebase" needs a paid plan; free plan route is GitHub sync (needs a GitHub account) or copy file contents.

### `preview-deploy`

- Host choice: Vercel works for static frontends. Lovable React + Vite output (`dist/`) is static. TanStack Start output is not static; it needs a Node host. Server-rendered apps (FastAPI + Jinja) stay on a local tunnel or the project's staging, as ADR-0003 says.
- Vercel protection for a no-login phone viewer: previews are protected by default, so a plain preview URL will show a Vercel login page. Create a Shareable Link ("Anyone with the link") and send that URL. No login needed. Hobby allows only one link per account, so reuse and revoke it after approval (set the dropdown back to "Only people with access"). Do not disable project-wide protection. Avoid Password Protection (Pro, $20/project/month) and the bypass-for-automation secret (it opens the whole project).
- Link expiry in the UI is undocumented; revoke explicitly at approval time.
- Tunnel: use the Cloudflare quick tunnel (no account, HTTPS, random URL). Caveats: 200 in-flight request cap (429), no SSE, no uptime guarantee, URL changes each run, link dies when `cloudflared` stops. Close the process on approval; that ends access for everyone.
- Warning-page risk: Cloudflare quick tunnels document no interstitial. Pinggy free and localtunnel both show pages that would confuse a phone user; do not use them as the default. localhost.run is the fallback (documents no interstitial; URL rotates; speed limit).
- Phone and tunnel: the app must be reachable through the tunnel's hostname (generated absolute URLs may point at `localhost`; localhost.run's FAQ warns about this).

## Conflicts with ADRs

- ADR-0002: Needs amending, not infeasible. Its premise that the Design tool "returns plain HTML + CSS" is not supported by primary sources. Both Lovable (no framework choice, React/TanStack Start) and AI Studio Build (React default) generate framework apps. The port-screen-by-screen step still works if the plugin treats the Design output as a visual reference. Suggested wording: the prompt asks for plain HTML + CSS but the plugin must accept a React project and extract markup and tokens from it.
- ADR-0003: None. Host-agnostic Preview, Vercel for static frontends, and a temporary tunnel for server-rendered apps are all feasible. Add two notes: (1) Vercel previews need a Shareable Link for a no-login viewer, with Hobby limited to one link; (2) the Cloudflare quick tunnel has a 200 in-flight cap, no SSE, and no uptime guarantee, so apps using SSE will not preview through it (fallback: project staging).

## Sources

Google AI Studio
- https://ai.google.dev/gemini-api/docs/aistudio-build-mode
- https://ai.google.dev/gemini-api/docs/aistudio-fullstack
- https://ai.google.dev/gemini-api/docs/aistudio-deploying
- https://ai.google.dev/gemini-api/docs/changelog
- https://blog.google/innovation-and-ai/technology/developers-tools/full-stack-vibe-coding-google-ai-studio/
- https://discuss.ai.google.dev/t/ai-studio-vibe-coding-allows-vibing-with-react-js-only/108688 (community, lower confidence)

Lovable
- https://docs.lovable.dev/integrations/github
- https://docs.lovable.dev/features/code-mode
- https://docs.lovable.dev/tips-tricks/deployment-hosting-ownership
- https://docs.lovable.dev/tips-tricks/external-deployment-hosting
- https://docs.lovable.dev/introduction/faq
- https://docs.lovable.dev/changelog

Vercel
- https://vercel.com/docs/deployment-protection
- https://vercel.com/docs/deployment-protection/usage-and-pricing
- https://vercel.com/docs/deployment-protection/methods-to-protect-deployments/vercel-authentication
- https://vercel.com/docs/deployment-protection/methods-to-protect-deployments/password-protection
- https://vercel.com/docs/deployment-protection/methods-to-bypass-deployment-protection/sharable-links
- https://vercel.com/docs/deployment-protection/methods-to-bypass-deployment-protection/protection-bypass-automation
- https://vercel.com/docs/deployments/sharing-deployments
- https://vercel.com/docs/rest-api/reference/endpoints/aliases/update-the-protection-bypass-for-a-url
- https://vercel.com/kb/guide/locking-down-deployments
- https://vercel.com/changelog/protect-production-deployments-for-free-on-every-plan
- https://vercel.com/changelog/protected-preview-deployments-available-on-all-plans

Tunnels
- https://developers.cloudflare.com/tunnel/get-started/quick-tunnels/
- https://developers.cloudflare.com/tunnel/downloads/
- https://developers.cloudflare.com/tunnel/troubleshooting/
- https://localhost.run/docs/ , https://localhost.run/docs/forever-free/ , https://localhost.run/docs/faq/
- https://pinggy.io/docs/ , https://pinggy.io/ , https://pinggy.io/docs/http_tunnels/screening/ , https://pinggy.io/blog/fixed_deceptive_website_warning/
- https://github.com/localtunnel/localtunnel , https://github.com/localtunnel/localtunnel/issues/598
- https://github.com/ekzhang/bore
