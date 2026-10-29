<!-- Scenario C: Keep existing stack. The Design export is a visual reference only (ADR-0004). -->
<!-- Fill in <PLACEHOLDERS> from the design-brief answers, .ui-workflow/audit.md and the project's templates. -->

You are designing the **look** of an existing web application. A developer will rebuild your design by hand in the project's existing stack (<EXISTING_STACK>). Your code is read as a visual reference for its layout, styles and copy. It is never run or shipped, so only the look matters.

## What to design

Design only the look: **layout, spacing, colours, fonts and component states** (hover, focus, disabled, active, open, empty, loading, error).

## How to build it

- Prefer **plain semantic HTML** (`<header>`, `<nav>`, `<main>`, `<section>`, `<form>`, `<button>`) and **one CSS file** that defines every colour, spacing, font, radius and shadow as a **CSS variable**.
- If your tool always builds with a framework, that is fine. Keep components shallow and keep every style value readable in the source.
- Avoid markup that only makes sense for one component library.
- Build **one page or route per Screen** listed below. When several Screens share one page today (tabs, steps), still give each Screen its own page or route.
- **No routing logic, no state management, no data fetching, no real backend, no auth.** Use static sample content.
- Describe every interaction in a plain-English comment next to the element, for example:
  ```html
  <!-- interaction: clicking Done marks this reminder as done -->
  ```

## Screens to redesign (only the look changes)
<one bullet per Screen: name — what it shows and what the user can do there>
- `<Screen 1>` — <...>
- `<Screen 2>` — <...>

## Real copy and field names (use these exactly)
<per Screen: headings, labels, button text, placeholders, empty and error text, quoted as they appear in the project's templates and in the project's language; then the data fields the Screen shows, with their real names>

## What needs to look better
<high-priority visual pain points from .ui-workflow/audit.md>

## Target users
<who uses this and their context>

## Most important user actions
1. <action 1>
2. <action 2>
3. <action 3>

{{brand-block}}

{{constraints-block}}

{{existing-design-tokens}}
<!-- design-brief inserts the project's :root { --foo: } block here if one exists.
     Remove this entire section (placeholder + comment) if the project has no tokens yet. -->

## Deliverable
- One page or route per Screen above, with the real copy and field names.
- One CSS file with the design tokens as CSS variables at the top.
- Every component state above shown at least once.
- A plain-English interaction comment on every interactive element.
- Mobile-first responsive layout with breakpoints at `640px` and `1024px`.

## Iteration
Provide **2–3 visual variations** of the first Screen:
- Variation 1: <e.g. dense layout, current feel>
- Variation 2: <e.g. spacious, premium feel>
- Variation 3: <e.g. dark mode default>

I will pick one (or mix), then you apply it to every Screen.

## Out of scope (do not produce)
- Routing, state management, data fetching, backend or server code, auth, database, API keys
- Screens, features or fields not listed above
- Extra dependencies or build configuration beyond what your tool needs by default
