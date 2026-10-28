---
name: design-port
description: Use for scenario C only — when the Lovable export is React/Tailwind but the existing project uses a different stack (Vanilla JS, jQuery, Vue, Svelte, FastAPI Jinja templates, etc.). Translates one component at a time, preserving visual design tokens (colors, spacing, typography) but rewriting the implementation in the target stack. Never bulk-translate.
---

# Design Port

## Overview

Lovable almost always outputs React + Tailwind. For scenario C (keep existing stack), this skill rewrites that output in the target stack while keeping the design pixel-equivalent. **One component at a time** — bulk translation hallucinates.

## When to Use

- Scenario C only
- After `integration-planner` returned PROCEED
- Working through components one at a time

## When NOT to Use

- Scenarios A and B (use `integration-wire` instead — Lovable output is already in target stack)
- Target stack IS React + Tailwind (no translation needed)
- `integration-planner` returned STOP

## Process

Reply in the language of the Stakeholder's latest message; if unclear, use `Stakeholder language` from the Workflow state.

### 0. Read the Workflow state

Read `.ui-workflow/state.md` at the project root before anything else. Take the Scenario from it, never from chat or the Design export. Stop with a short message, without doing anything else, when:

- The file is missing: say the Scenario has not been picked yet and give the command `/ui-workflow-skills:ui-scenario-picker`.
- `Blocked` is not `none` and `Current step` is another step: repeat the reason and say a Developer must decide first. Re-running the step that stopped is allowed.
- `Scenario` is not `C`: say this step is for Scenario C only and give the command for the recorded `Current step`.
- `Completed steps` lacks `planner`. Name the first missing step and its command, and never guess its output.

When this step succeeds, after the Stakeholder approves the last screen, set `Work branch` to the branch you work on, append `port` to `Completed steps` and set `Current step: preview`; also set `Blocked: none`, update `Stakeholder language` if the Stakeholder switched language, and set `Updated: <YYYY-MM-DD> by design-port`. A STOP, a mismatch or an escalation never completes the step: leave `Completed steps` as it is, set `Current step: port` and write the reason in `Blocked`. Step commands: picker `/ui-workflow-skills:ui-scenario-picker`, audit `/ui-workflow-skills:ui-audit`, brief `/ui-workflow-skills:design-brief`, ingest `/ui-workflow-skills:ingest-design-export`, planner `/ui-workflow-skills:integration-planner`, port `/ui-workflow-skills:design-port`, wire `/ui-workflow-skills:integration-wire`, preview `/ui-workflow-skills:preview-deploy`.

For **each** component, one at a time. Wait for user approval between components.

### 1. Extract design tokens from the Lovable JSX/Tailwind

- **Colors**: every Tailwind color class → hex
  - `bg-blue-500` → `#3b82f6`
  - `text-slate-700` → `#334155`
- **Spacing**: every `p-*`, `m-*`, `gap-*` → px value (Tailwind: 1 unit = 4px)
  - `p-6` → `24px`
  - `gap-4` → `16px`
- **Typography**: `text-*`, `font-*` → font-family, size, weight
- **Borders, shadows, radii**: similar literal extraction

Store at the top of the target file as CSS custom properties:

```css
:root {
  --color-primary: #3b82f6;
  --color-text: #334155;
  --space-md: 16px;
  --space-lg: 24px;
  --radius-card: 8px;
}
```

### 2. Translate JSX → target language

| React/JSX | Vanilla JS + HTML | Vue 3 | Jinja (FastAPI) |
|---|---|---|---|
| `<div className="x">` | `<div class="x">` | `<div class="x">` | `<div class="x">` |
| `{variable}` | template literal `${var}` or DOM mutation | `{{ variable }}` | `{{ variable }}` |
| `onClick={fn}` | `addEventListener('click', fn)` | `@click="fn"` | n/a (server-rendered) |
| `{items.map(i => …)}` | template + JS clone loop | `v-for` | `{% for i in items %}` |
| `{cond && <X />}` | conditional DOM insert | `v-if` | `{% if cond %}` |

### 3. Translate state

| React | Vanilla JS | Vue 3 |
|---|---|---|
| `const [x, setX] = useState(0)` | local var + manual DOM updates | `const x = ref(0)` |
| `useEffect(() => {...}, [])` | inside `DOMContentLoaded` | `onMounted(...)` |
| Data fetching | match project's existing fetch pattern | same — match what's there |

**Never introduce a new HTTP library** if the project doesn't have one. If the project uses native `fetch`, stay on native `fetch`.

### 4. Translate Tailwind responsive

| Tailwind | CSS |
|---|---|
| `sm:` | `@media (min-width: 640px)` |
| `md:` | `@media (min-width: 768px)` |
| `lg:` | `@media (min-width: 1024px)` |
| `xl:` | `@media (min-width: 1280px)` |

### 5. Show, wait, approve

After translating one component:
- Show the user the result (file path + key snippet)
- Ask: "Looks right? Move to next, or need changes?"
- Move on only after explicit approval.

## Example Translation

Lovable React + Tailwind:

```tsx
export function HabitCard({ habit, onToggle }) {
  return (
    <div className="flex items-center gap-4 p-6 bg-white rounded-lg shadow">
      <button
        onClick={() => onToggle(habit.id)}
        className="w-6 h-6 rounded-full border-2 border-blue-500"
      />
      <span className="text-slate-700">{habit.title}</span>
    </div>
  );
}
```

Vanilla JS + plain CSS:

```html
<div class="habit-card" data-habit-id="42">
  <button class="habit-toggle" aria-label="Toggle habit"></button>
  <span class="habit-title">Drink water</span>
</div>
```

```css
:root {
  --color-primary: #3b82f6;
  --color-text: #334155;
  --space-md: 16px;
  --space-lg: 24px;
  --radius-card: 8px;
}
.habit-card {
  display: flex;
  align-items: center;
  gap: var(--space-md);
  padding: var(--space-lg);
  background: #fff;
  border-radius: var(--radius-card);
  box-shadow: 0 1px 3px rgba(0,0,0,0.08);
}
.habit-toggle {
  width: 24px; height: 24px;
  border-radius: 50%;
  border: 2px solid var(--color-primary);
  background: transparent;
  cursor: pointer;
}
.habit-title { color: var(--color-text); }
```

```js
document.querySelectorAll('.habit-toggle').forEach(btn => {
  btn.addEventListener('click', () => {
    const card = btn.closest('.habit-card');
    const id = card.dataset.habitId;
    toggleHabit(id);
  });
});
```

## Critical Rules

- **One component at a time.** Wait for user approval between components.
- **Design tokens must match.** Same color, same spacing, same font. Output should look pixel-equivalent to the Lovable design.
- **No new dependencies.** Don't introduce React-like libraries (Preact, Lit, etc.) into a vanilla project.
- **Translate Tailwind class names to real CSS values** — don't leave `bg-blue-500` in HTML when the project doesn't have Tailwind.

## Common Mistakes

- **Bulk-translating the entire export at once.** Hallucinations multiply. One at a time.
- **Leaving Tailwind class names in the HTML** of a project that doesn't ship Tailwind.
- **Missing responsive breakpoints.** Lovable's responsive Tailwind must become real media queries.
- **Hallucinating CSS values.** When unsure, look up actual Tailwind value (e.g. `gap-4` = `1rem` = `16px`).
- **Introducing jQuery** when the project is plain vanilla. Match what's there.

## Red Flags — Stop and Re-check

- About to translate 5 components in one turn → stop, do one.
- HTML output still contains `className=` → you're not translating, you're copy-pasting.
- CSS file lacks design tokens → tokens are required, add them.

## Related Skills

- `integration-planner` — must return PROCEED first
- `preview-deploy` — runs after all components translated
