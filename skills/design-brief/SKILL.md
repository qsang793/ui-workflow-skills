---
name: design-brief
description: Use after ui-audit (or first for scenario A) and before the Stakeholder opens Lovable / Google AI Studio. Interviews the Stakeholder with 5-10 plain questions, one at a time, in their language, records the chosen Design tool in the Workflow state and writes a paste-ready English Design prompt to .ui-workflow/design-prompt.md. For scenario C the prompt asks for the look only and the file lists the Required behaviour of every existing screen.
---

# Design Brief

## Overview

A non-tech Stakeholder cannot write a good prompt for a Design tool. This skill conducts a short interview and assembles a complete, paste-ready Design prompt with the Scenario's constraints applied. For Scenario C the Design export is only a visual reference (ADR-0004): the prompt asks for the look, prefers plain HTML + CSS, and never forbids frameworks, because neither Design tool reliably returns plain HTML.

## When to Use

- After `ui-scenario-picker`
- After `ui-audit` for scenarios B/C (skipped for A)
- When the Stakeholder is about to open Lovable or Google AI Studio

## When NOT to Use

- Scenario undecided — run `ui-scenario-picker` first
- The Stakeholder has already pasted their own prompt into the Design tool

## Process

Reply in the language of the Stakeholder's latest message; if unclear, use `Stakeholder language` from the Workflow state. The interview runs in that language. The Design prompt file is always written in English: translate the Stakeholder's answers. UI copy follows the project's existing language, so copy quoted from the project's templates stays as it is.

### 0. Read the Workflow state

Read `.ui-workflow/state.md` at the project root before anything else. Take the Scenario from it, never from chat or the Design export. Stop with a short message, without doing anything else, when:

- The file is missing: say the Scenario has not been picked yet and give the command `/ui-workflow-skills:ui-scenario-picker`.
- `Blocked` is not `none` and `Current step` is another step: repeat the reason and say a Developer must decide first. Re-running the step that stopped is allowed.
- `Completed steps` lacks a step this one needs (A: `picker`; B and C: `picker`, `audit`). Scenario A skips the audit by design, so never report it missing there. Name the first missing step and its command, and never guess its output.

When this step succeeds, set `Design tool` to the Stakeholder's choice (`Lovable` or `Google AI Studio`), append `brief` to `Completed steps` and set `Current step: ingest`; also set `Blocked: none`, update `Stakeholder language` if the Stakeholder switched language, and set `Updated: <YYYY-MM-DD> by design-brief`. A STOP, a mismatch or an escalation never completes the step: leave `Completed steps` as it is, set `Current step: brief` and write the reason in `Blocked`. Step commands: picker `/ui-workflow-skills:ui-scenario-picker`, audit `/ui-workflow-skills:ui-audit`, brief `/ui-workflow-skills:design-brief`, ingest `/ui-workflow-skills:ingest-design-export`, planner `/ui-workflow-skills:integration-planner`, port `/ui-workflow-skills:design-port`, wire `/ui-workflow-skills:integration-wire`, preview `/ui-workflow-skills:preview-deploy`.

### 1. Read what the project already says

Use the Scenario from the Workflow state (step 0). For B and C, read `.ui-workflow/audit.md` (Stack, Pages / Routes, Pain points, the `Design tokens` line). Also read every template the audit lists: you need each existing screen's data fields and actions, and for C its copy. A screen is a page or route, or a named view inside one (a tab, a step). Never ask the Stakeholder for something these files answer.

### 1b. Ask which Design tool the Stakeholder will use

> "Which design tool will you paste this prompt into — **Lovable** or **Google AI Studio**?"

Recommendation to share if the Stakeholder is unsure (vendor docs checked 2026-10-27):

| Scenario | Recommended tool | Why |
|---|---|---|
| A (greenfield) | Lovable (AI Studio also fits) | Builds a whole React app; simplest export for a non-technical person (GitHub sync on every plan, ZIP on paid plans) |
| B (migrate stack) | Lovable if the target is React; AI Studio for Angular or Next.js | Lovable has no framework choice (TanStack Start); AI Studio picks React, Angular or Next.js in Settings |
| C (keep stack) | Either; no preference | Neither returns plain HTML reliably, and it does not matter: the export is only a visual reference |

Save the answer: it is the `Design tool` field and it changes the guidance in step 4. If the Stakeholder names another tool, say this workflow supports only these two and ask them to pick one.

### 2. Interview — ONE question at a time

Wait for each answer before sending the next. Do **not** dump all questions at once. If the Stakeholder's message already answers some questions, use those answers and ask only the missing ones; when everything is answered, go straight to step 3.

1. **Audience**: "Who uses this UI most — internal team, external customers, or both?"
2. **Top actions**: "What are the 3 most important things a user does in this UI?"
3. **Brand**: "Do you have brand colors / fonts / logo to reuse? Paste hex codes if you can."
4. **Tone**: "Which best describes the feel — professional, playful, minimal, luxurious, technical, friendly?"
5. **Device**: "Mobile, desktop, or both equally important?"
6. **Inspiration**: "Any sites or apps you'd want this to feel like? Drop links."
7. **Must-haves**: "Which features must keep working or must be there, no matter what the design looks like — e.g. login, marking an item done, export?"
8. **Constraints**: "Any technical constraints — must work offline, must support old browsers, must be SEO-friendly?"
9. **Skip-list**: "Are there sections we should leave alone (not redesign)? Common ones: login, admin, settings."

**Probing for lazy answers**: if the Stakeholder replies "I don't know" or with a one-word answer to a question that needs a real choice (especially Q3 brand, Q4 tone, Q5 device), offer 2-3 concrete examples and re-ask. Example:

> Q4: Tone? "Idk."
> Re-ask: "Three quick options to pick from: (a) calm/minimal like Linear, (b) bold/saturated like Notion, (c) earthy/warm like Roam. Which feels closest?"

Never accept "idk" twice on the same question — pick the safest default ("minimal/calm") and tell the Stakeholder that's what you assumed. "None" is a real answer for Q6, Q8 and Q9.

**Scenario A only**, also ask:
10. **Pages**: "Roughly how many distinct pages? List them."

**Scenario B only**, also ask:
10. **Target stack**: "Any preferred framework?" Lovable builds React only; AI Studio offers React, Angular or Next.js in Settings. Default: React.

### 3. Pick the right template

| Scenario | Base template |
|---|---|
| A | `${CLAUDE_SKILL_DIR}/templates/prompt-scenario-A.md` |
| B | `${CLAUDE_SKILL_DIR}/templates/prompt-scenario-B.md` |
| C | `${CLAUDE_SKILL_DIR}/templates/prompt-scenario-C.md` |

Always also fill in:
- `${CLAUDE_SKILL_DIR}/templates/brand-block.md` (from Q3, Q4)
- `${CLAUDE_SKILL_DIR}/templates/constraints-block.md` (from Q5, Q8)

**Substitution mechanism (explicit)**:
1. Use the `Read` tool to load all three files (base template + brand block + constraints block).
2. Fill `<PLACEHOLDERS>` in each file with the Stakeholder's answers, in English, using literal string replacement.
3. In the base template, replace `{{brand-block}}` with the **entire filled brand-block content** and `{{constraints-block}}` with the **entire filled constraints-block content**. No paraphrasing, no summarizing — literal insertion.

**For scenario C only**:
- Screens: one per existing screen from step 1, minus the Q9 skip-list. Copy and field names come from the templates, quoted exactly.
- `{{existing-design-tokens}}`: if the audit's `Design tokens` line names a file, replace `{{existing-design-tokens}}` and the HTML comment under it with the section below. If it says `none`, delete the placeholder and the comment — never leave the raw placeholder in the prompt.

```
## Existing design tokens (REUSE — do not invent new colors)
<paste the :root block from the file the audit names>
```

### 4. Output

**Write the file** `.ui-workflow/design-prompt.md` (create `.ui-workflow/` at the project root if missing). Non-tech Stakeholders find files easier to copy from than scrolling chat. Everything in it is English.

File content format:

```markdown
<!-- Generated by /ui-workflow-skills:design-brief on <YYYY-MM-DD>. Scenario: <A/B/C>. Design tool: <Lovable/Google AI Studio>. -->

=== COPY EVERYTHING BELOW INTO <Lovable/Google AI Studio> ===

<assembled prompt — full template with placeholders filled>

=== END COPY ===

## Required behaviour

### <Screen> — <template file>[#<view>]
- Shows: <data displayed today, with the real field names and where they come from (endpoint or template variable)>
- Does: <each action today and the endpoint or code that serves it> | none

### Stakeholder must-haves
- <each must-have from Q7, in English> | none
```

`## Required behaviour` (Scenario B and C; omit it for A, which has no existing screens) sits after `=== END COPY ===`, so the Stakeholder never pastes it. It lists every existing screen from step 1, including skipped ones (add `(not redesigned)` after the template file), and states what each one does today as read from the audit and the templates, not what the new design should do. If a control does nothing lasting today (for example a Save that only shows an alert), say so. The planner reads this section: keep the heading and the `### Stakeholder must-haves` subsection exactly as above.

Then in chat, point the Stakeholder at the file with **tool-specific** next steps:

**If the Stakeholder chose Lovable** (from step 1b):
> ✅ Prompt saved to `.ui-workflow/design-prompt.md`. Open the file, copy everything between the `=== COPY ===` markers, and paste into Lovable. When you like the result, get the code out with "Sync to GitHub" (every plan, needs a GitHub account) or "Download codebase" in Project settings → Git (paid plans). Then come back and run `/ui-workflow-skills:ingest-design-export`.

**If the Stakeholder chose Google AI Studio** (from step 1b):
> ✅ Prompt saved to `.ui-workflow/design-prompt.md`. Open the file, copy everything between the `=== COPY ===` markers, and paste into Google AI Studio (Build). When you like the result, download it as a ZIP or sync it to GitHub. Then come back and run `/ui-workflow-skills:ingest-design-export`.

For Google AI Studio under Scenario C, add: before pasting, open Settings; if it offers plain HTML, pick it, otherwise pick the lightest framework offered (React rather than Next.js or Angular). This is untested: if no such choice appears, paste anyway, since any framework works.

## Critical Rule for Scenario C

The assembled prompt asks for the **look only** (layout, spacing, colours, fonts, component states), one page or route per Screen, the project's real copy and field names, and the existing tokens when the audit found any. It prefers plain semantic HTML and one CSS file with CSS variables, and asks for no routing, state or real backend. It **never forbids frameworks** and never says a framework export will be discarded: `design-port` reads any export as a visual reference.

## Common Mistakes

- **Question wall.** All 9 questions at once → the Stakeholder gives lazy answers. Ask one, wait, then next.
- **Skipping the brand block** because the Stakeholder "doesn't have one". "No brand" is still information — record it.
- **Forbidding React in Scenario C.** Lovable cannot comply and AI Studio defaults to React, so the Stakeholder would stall at ingest.
- **Inventing copy or field names.** Scenario C quotes them from the project's templates.
- **Writing Required behaviour from the new design.** It is what each screen does today, plus the must-haves.
- **Not asking about device priority.** Mobile-first vs desktop-first changes the entire layout.

## Red Flags — Stop and Re-check

- Output prompt is < 500 words → too thin, ask follow-up questions on weak answers.
- For scenario C, the prompt says "do not use React" or any framework, or threatens to discard framework code → remove it.
- For scenario C, `## Required behaviour` is missing a screen the audit lists → add it.
- The Design prompt contains non-English text other than UI copy quoted from the project → translate it.
- The Stakeholder answered "I don't know" to 4+ questions → pause and explain, don't generate a junk prompt.

## Related Skills

- `ui-scenario-picker` — provides the Scenario
- `ui-audit` — provides current stack, screens and tokens for scenarios B/C
- `ingest-design-export` — runs next, after the Design tool produces output
- `integration-planner` — reads `## Required behaviour`
