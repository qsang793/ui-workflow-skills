<!-- Scenario A: Greenfield. The Design tool builds in its own default stack. -->
<!-- Fill in <PLACEHOLDERS> from the design-brief interview answers. -->

You are designing a complete web application from scratch.

## Project description
<one paragraph: what the product is, who it's for, what problem it solves>

## Target users
<who uses this — internal team / external customers / both — and their tech literacy>

## Pages required
<list distinct pages, e.g.:>
- Landing
- Sign up
- Sign in
- Dashboard
- Settings
- ...

## Most important user actions (in order)
1. <action 1>
2. <action 2>
3. <action 3>

{{direction-block}}

{{brand-block}}

{{constraints-block}}

## Deliverable
- A complete, production-ready project in your default stack (current stable versions)
- All pages above implemented with real components
- Responsive across mobile / tablet / desktop
- Loading and error states for every async interaction
- Empty states for every list view
- Use shadcn/ui components where they fit
- Place mock data in a single `lib/mock/` directory so it's easy to swap for real APIs later

## One shared style
This may be the only message I can send, so build everything now.
- Use the Direction and Brand above as one visual style on every page, from the same colours, fonts and components.
- Build every page above in this first build. Do not stop after the first page, and do not ask me to choose anything first.
- Build one version of each page: no alternative versions, variations or style switchers.

## Out of scope (do not implement)
- Backend / database — assume a REST API exists that returns the mock shapes
- Auth provider — assume `useSession()` returns `{ user, signOut }`; design the screens around that abstraction
