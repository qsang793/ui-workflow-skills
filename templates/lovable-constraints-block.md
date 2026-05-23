<!-- Reusable constraints block. Filled by the design-brief skill from Q5+Q8 answers. -->
<!-- Substitute into the {{lovable-constraints-block}} placeholder in scenario templates. -->

## Constraints

### Responsive
- **Mobile-first** design
- Breakpoints: `640px` (tablet), `1024px` (desktop), `1280px` (wide)
- Tap targets minimum **44 × 44 px**
- No horizontal scroll on any viewport ≥ 320px
- Device priority: <mobile / desktop / both equally>

### Accessibility
- **WCAG 2.1 AA** minimum
- Every `<img>` has an `alt` attribute
- Form fields have **visible labels** (not placeholder-only)
- Contrast ratio ≥ **4.5:1** for body text, ≥ 3:1 for large text
- **Focus states are visible** for keyboard users (custom or browser default — never `outline: none`)
- Interactive elements are real `<button>` / `<a>` (not styled `<div>`s)

### Performance
- No animations longer than 300ms
- No autoplay video
- Lazy-load images below the fold (`loading="lazy"`)
- No blocking 3rd-party scripts above the fold

### Browser support
- Latest Chrome, Safari, Firefox, Edge (last 2 versions)
- iOS Safari 15+
- Android Chrome 100+
- **No IE support required** unless explicitly noted below

### State coverage (required for every async interaction)
1. **Loading** — visible feedback during fetch / submit
2. **Success** — default rendered state
3. **Empty** — explicit empty-state UI (not a blank page)
4. **Error** — readable error message + a retry path where applicable

### Hard constraints
<list anything user mentioned in Q8 — examples:>
- Must work offline (PWA + service worker — design with this in mind)
- Must be SEO-friendly (server-rendered or static)
- Must respect `prefers-reduced-motion`
- Must use the existing design system at `<URL>`
- <"none" if no extra constraints>
