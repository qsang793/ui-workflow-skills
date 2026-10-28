<!-- Scenario C: Keep existing stack. CRITICAL constraints. -->
<!-- Fill in <PLACEHOLDERS> from design-brief answers and .ui-workflow/audit.md. -->

You are producing a **visual design** that will be re-implemented in an existing codebase. The existing codebase uses **<EXISTING_STACK>** (e.g. Vanilla JavaScript + plain CSS + FastAPI Jinja templates), NOT React.

## ⚠️ CRITICAL CONSTRAINT — READ THIS BEFORE GENERATING ANYTHING

Produce **semantic HTML5 + CSS only.**

- ❌ Do **NOT** use React, Vue, Svelte, Angular, or any JS framework
- ❌ Do **NOT** use JSX
- ❌ Do **NOT** write JavaScript code — for any interactive behavior, add an HTML comment in plain English describing what should happen:
  ```html
  <!-- interaction: clicking this button toggles the .open class on .menu -->
  ```
- ✅ Use CSS custom properties (variables) for design tokens
- ✅ Use semantic tags: `<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<button>`, `<form>`
- ✅ Use CSS Grid and Flexbox for layout
- ✅ Use media queries for responsive design
- ⚠️ Tailwind classes are acceptable **only** if you also emit a `<style>` block resolving them to plain CSS

**Why this matters:** the output will be re-implemented by hand in the existing stack. Code in a framework gets discarded. Stick to HTML + CSS + plain-English interaction descriptions.

---

## What the existing UI does (do not redesign functionality)
<paste structure summary from .ui-workflow/audit.md — list of pages and what they do>

## What needs to look better
<paste high-priority visual pain points from .ui-workflow/audit.md>

## Pages to redesign
<list — same set as today, just visually improved>
- `<page 1>`
- `<page 2>`
- ...

{{brand-block}}

{{constraints-block}}

{{existing-design-tokens}}
<!-- design-brief skill inserts the project's :root { --foo: } block here if one exists.
     Remove this entire section (placeholder + comment) if the project has no tokens yet. -->

## Deliverable
- **One HTML file per page** redesigned (no shared layout file — easier to copy chunks)
- **One shared `styles.css`** with all design tokens at the top
- **Plain-English HTML comments** describing every interactive behavior (no JavaScript)
- **Mobile-first** responsive design with breakpoints at `640px` and `1024px`

## Iteration
Provide **2–3 visual variations** of the same page side-by-side:
- Variation 1: <e.g. dense layout, current-feel>
- Variation 2: <e.g. spacious, premium feel>
- Variation 3: <e.g. dark mode default>

I will pick one (or mix), then you refine.

## Out of scope (do not produce)
- ❌ JavaScript files
- ❌ Build configs (webpack, vite, package.json)
- ❌ React/Vue/Svelte components
- ❌ TypeScript

## Strict no-go
- Even ONE `import React` or `useState` in the output → I will discard everything and re-prompt.
