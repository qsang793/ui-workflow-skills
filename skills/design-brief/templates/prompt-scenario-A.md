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

## Iteration
After the first version, I will ask for 2–3 alternatives focused on:
- Layout variations (sidebar vs top nav, dense vs spacious)
- Color/palette variations
- Typography variations

Prepare to iterate based on which one I pick.

## Out of scope (do not implement)
- Backend / database — assume a REST API exists that returns the mock shapes
- Auth provider — assume `useSession()` returns `{ user, signOut }`; design the screens around that abstraction
