---
name: design-brief
description: Use after ui-audit (or first for scenario A) and before the user opens Lovable / Google AI Studio. Interviews the user with 5-10 plain-English questions, one at a time, and produces a paste-ready prompt with the correct stack constraints baked in for the chosen scenario.
---

# Design Brief

## Overview

A non-tech stakeholder cannot write a good prompt for Lovable. This skill conducts a short interview and assembles a complete, paste-ready prompt — with scenario-specific stack constraints automatically applied. Most importantly: **for scenario C, the prompt forbids React**.

## When to Use

- After `ui-scenario-picker`
- After `ui-audit` for scenarios B/C (skipped for A)
- When the user is about to open Lovable or Google AI Studio

## When NOT to Use

- Scenario undecided — run `ui-scenario-picker` first
- User has already pasted their own brief into Lovable

## Process

### 1. Confirm scenario

Read the scenario from `ui-scenario-picker`'s output. If missing, ask the user (1 question, then continue).

### 1b. Ask which design tool the user will use

> "Which design tool will you paste this prompt into — **Lovable** or **Google AI Studio**?"

Recommendation to share if the user is unsure:

| Scenario | Recommended tool | Why |
|---|---|---|
| A (greenfield) | Lovable | Builds the whole app from specs in one shot |
| B (migrate stack) | Lovable | Outputs a complete project in the target framework |
| C (keep stack) | **Google AI Studio** | Naturally produces HTML+CSS without fighting React defaults |

Save the answer — it changes the output guidance in step 4 (Lovable downloads ZIP / syncs GitHub; AI Studio is copy-paste from chat).

### 2. Interview — ONE question at a time

Wait for each answer before sending the next. Do **not** dump all questions at once.

1. **Audience**: "Who uses this UI most — internal team, external customers, or both?"
2. **Top actions**: "What are the 3 most important things a user does in this UI?"
3. **Brand**: "Do you have brand colors / fonts / logo to reuse? Paste hex codes if you can."
4. **Tone**: "Which best describes the feel — professional, playful, minimal, luxurious, technical, friendly?"
5. **Device**: "Mobile, desktop, or both equally important?"
6. **Inspiration**: "Any sites or apps you'd want this to feel like? Drop links."
7. **Must-haves**: "Any features that are non-negotiable — e.g. login, dashboard, export?"
8. **Constraints**: "Any technical constraints — must work offline, must support old browsers, must be SEO-friendly?"
9. **Skip-list**: "Are there sections we should leave alone (not redesign)? Common ones: login, admin, settings."

**Probing for lazy answers**: if the user replies "I don't know" or with a one-word answer to a question that needs a real choice (especially Q3 brand, Q4 tone, Q5 device), offer 2-3 concrete examples and re-ask. Example:

> Q4: Tone? "Idk."
> Re-ask: "Three quick options to pick from: (a) calm/minimal like Linear, (b) bold/saturated like Notion, (c) earthy/warm like Roam. Which feels closest?"

Never accept "idk" twice on the same question — pick the safest default ("minimal/calm") and tell the user that's what you assumed.

**Scenario A only**, also ask:
10. **Pages**: "Roughly how many distinct pages? List them."

**Scenario B only**, also ask:
10. **Target stack**: "Any preferred framework — React, Next.js, Vue? (Default: Next.js)"

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
2. Fill `<PLACEHOLDERS>` in each file with the user's answers, using literal string replacement.
3. In the base template, replace `{{brand-block}}` with the **entire filled brand-block content** and `{{constraints-block}}` with the **entire filled constraints-block content**. No paraphrasing, no summarizing — literal insertion.

**For scenario C only — `{{existing-design-tokens}}`**: if `ui-audit` reported existing design tokens (a `:root { --foo: }` block in the project's CSS), replace `{{existing-design-tokens}}` and the HTML comment under it with the section below. If there are no tokens, delete the placeholder and the comment — never leave the raw placeholder in the prompt.

```
## Existing design tokens (REUSE — do not invent new colors)
<paste the :root block from the project's main CSS file>
```

### 4. Output

**Write the assembled prompt to a file**: `.ui-workflow/design-prompt.md` (create the `.ui-workflow/` folder at the project root if missing). Non-tech users find files easier to copy from than scrolling chat.

File content format:

```markdown
<!-- Generated by /design-brief on <YYYY-MM-DD>. Scenario: <A/B/C>. -->

=== COPY EVERYTHING BELOW INTO LOVABLE / GOOGLE AI STUDIO ===

<assembled prompt — full template with placeholders filled>

=== END COPY ===
```

Then in chat, point the user at the file with **tool-specific** next steps:

**If user chose Lovable** (from step 1b):
> ✅ Prompt saved to `.ui-workflow/design-prompt.md`. Open the file, copy everything between the `=== COPY ===` markers, and paste into Lovable. After Lovable produces a project you like, either click "Download ZIP" or enable "Sync to GitHub". Then come back and invoke `/ingest-design-export`.

**If user chose Google AI Studio** (from step 1b):
> ✅ Prompt saved to `.ui-workflow/design-prompt.md`. Open the file, copy everything between the `=== COPY ===` markers, and paste into Google AI Studio. AI Studio will return code in chat — copy each file's content out, then come back and invoke `/ingest-design-export` and choose the **"Paste"** method.

## Critical Rule for Scenario C

When scenario is C, the assembled prompt **must contain** this exact-meaning constraint (the scenario-C template handles it):

> CRITICAL CONSTRAINT: Produce semantic HTML5 + CSS only. **Do NOT use React, Vue, Svelte, or any framework.** The output will be re-implemented in the project's existing stack. For interactive behavior, describe the interaction in a plain-English HTML comment — do not write JavaScript.

If this is missing, Lovable returns React code that has to be re-translated — defeating the entire point of scenario C.

## Common Mistakes

- **Question wall.** All 8 questions at once → user gives lazy answers. Ask one, wait, then next.
- **Skipping the brand block** because user "doesn't have one". "No brand" is still information — record it.
- **Forgetting scenario C's stack lockdown.** Top source of wasted iterations.
- **Not asking about device priority.** Mobile-first vs desktop-first changes the entire layout.

## Red Flags — Stop and Re-check

- Output prompt is < 500 words → too thin, ask follow-up questions on weak answers.
- For scenario C, output prompt doesn't contain the phrase "Do NOT use React" → fix it.
- User answered "I don't know" to 4+ questions → pause and educate, don't generate junk prompt.

## Related Skills

- `ui-scenario-picker` — provides the scenario
- `ui-audit` — provides current stack info for scenarios B/C
- `integration-planner` — runs after Lovable produces output
