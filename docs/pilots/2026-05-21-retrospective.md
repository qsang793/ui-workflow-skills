# Pilot Retrospective — UI Workflow Skills v0.1.0

**Date**: 2026-05-21
**Pilot subject**: telegram-reminder-bot (Vanilla JS + FastAPI)
**Tested skills**: ui-scenario-picker, ui-audit, design-brief (dry-run)
**Not tested** (require real Lovable output): integration-planner, integration-wire, ui-translator, preview-deploy

---

## ✅ What worked

### ui-scenario-picker
- Filesystem-first detection works correctly. Identified Vanilla JS by absence of `package.json` and presence of `dashboard/static/index.html`.
- Default-bias-to-C rule produced the correct recommendation without needing all 3 questions.
- Output format (Scenario / Why / Next step) is clean and copy-pasteable for the boss.

### ui-audit
- Stack detection (FastAPI + Vanilla JS + plain CSS) matched ground truth.
- Pain-point greps surfaced **concrete numbers** that turn vague complaints into actionable metrics:
  - 1723 inline `style=` attrs
  - 246 unique colors vs 16 design tokens
  - 5 files > 500 lines, 2 > 5000 lines
  - 44 hardcoded `px` widths vs only 6 media queries
- Severity tiering (🔴/🟡/🟢, capped at 5 each) kept the report readable.

### design-brief (dry-run, template inspection)
- Template `lovable-prompt-scenario-C.md` has the no-React lockdown in **6+ explicit places**. Hard to miss.
- The "Strict no-go: Even ONE `import React` → discard everything" line at the bottom of the template is genuinely intimidating, which is the intent.

---

## ❌ Friction & gaps found

### ui-scenario-picker
1. **Q2 assumes binary answer** ("keep stack" vs "switch"). Real bosses often say "I don't know". Skill needs a **fallback teaching paragraph** to educate before re-asking.
2. **Partial-migration case not handled**: codebases that already started a half-finished migration (e.g. some React components alongside vanilla JS) aren't covered. Skill should detect this and route to a special escalation.
3. **No package.json fallback is implicit, not documented**. Skill says to read `package.json` but doesn't explicitly say "if missing, look at file extensions instead". Worked for me because I extrapolated; another agent might not.

### ui-audit
1. **"Top 10 pages" doesn't fit SPAs**. In `telegram-reminder-bot`, pages are JS tabs swapped in one `index.html`, not separate route files. Skill needs a SPA-mode note: "for single-page apps, list tabs/views in addition to backend routes".
2. **File-size tiering is binary**. Skill flags any file > 500 lines as a problem, but a 600-line file and a 5147-line file are not the same crisis. Suggest: `🔴 High` for > 1000 lines, `🟡 Medium` for 500-1000.
3. **Loading-state heuristic is unreliable**. Counting `fetch(` vs `loading` references gives a ratio (15:32 here) that's hard to interpret. Replace with: "spot-check 3 random fetch calls, confirm each has visible loading UI".
4. **No "design tokens exist but aren't enforced" pattern**. This repo has 16 tokens AND 246 colors — the gap is the real story. Skill should specifically check for this.
5. **i18n detection missing**. This repo uses `data-i18n` attributes intentionally; a less-careful audit would flag "hardcoded strings" as a pain. Skill should detect i18n setup and skip that grep.

### design-brief
1. **Placeholder substitution mechanism not specified**. Skill says "fill placeholders" but doesn't say HOW. Should be explicit: "Read the brand-block and constraints-block templates, then `string.replace()` the `{{...}}` markers literally."
2. **No file output path**. Skill returns the prompt inline in chat. For a non-tech boss, that's friction — they'll scroll-copy. Should write `LOVABLE_PROMPT.md` to repo root so they copy from a file.
3. **No probing for lazy answers**. If user says "idk" to Q3 (brand), skill should offer 2-3 example choices ("Calm/minimal? Bold/saturated? Earthy/warm?") not just give up.
4. **Missing "skip section" question**. Common case: redesign main tabs but leave login alone. Add Q10: "Any sections to leave untouched?"
5. **Scenario C interview missing existing-design-tokens question**. If the project already has tokens (like this repo does), the prompt should tell Lovable to reuse them, not invent new ones.

---

## 🛠 Concrete edits planned (bump to v0.1.1)

| # | File | Edit |
|---|---|---|
| 1 | `ui-scenario-picker/SKILL.md` | Add "When user says 'I don't know'" fallback paragraph in step 2 |
| 2 | `ui-scenario-picker/SKILL.md` | Add partial-migration detection step ("if you find both React AND raw vanilla JS, escalate") |
| 3 | `ui-audit/SKILL.md` | Add SPA-mode note for "pages" detection |
| 4 | `ui-audit/SKILL.md` | Split file-size tier: > 1000 = High, 500-1000 = Medium |
| 5 | `ui-audit/SKILL.md` | Replace loading-state ratio heuristic with spot-check rule |
| 6 | `ui-audit/SKILL.md` | Add "tokens-exist-but-unused" detection pattern |
| 7 | `ui-audit/SKILL.md` | Detect `data-i18n` / similar i18n setups; skip hardcoded-string flagging when present |
| 8 | `design-brief/SKILL.md` | Add explicit "use Read + literal string replace for `{{}}` placeholders" |
| 9 | `design-brief/SKILL.md` | Write final assembled prompt to `LOVABLE_PROMPT.md` at repo root |
| 10 | `design-brief/SKILL.md` | Add "lazy-answer probe" rule with 2-3 example offerings |
| 11 | `design-brief/SKILL.md` | Add Q10: "any sections to skip redesigning?" |
| 12 | `lovable-prompt-scenario-C.md` | Add `{{existing-design-tokens}}` placeholder for projects with token systems |

---

## 🚫 Not tested in this pilot

These need real Lovable output, which requires the boss running steps 3 (open Lovable) externally. Plan:

- `integration-planner`: needs a real Lovable export to diff against `dashboard/routers/*.py`. Will be tested in a follow-up pilot once boss has a Lovable run.
- `integration-wire`: only applies to scenarios A/B (not C). Will be tested on a different greenfield pilot project.
- `ui-translator`: needs Lovable React/Tailwind output. Will be tested on one habit-card component.
- `preview-deploy`: requires Vercel auth on the test machine. Will be tested after extraction to standalone repo.

## 📊 Pilot verdict

**Skill bundle is usable in v0.1.0 for the early steps (picker → audit → brief)** but should ship as v0.1.1 with the 12 edits above before being handed to a non-tech stakeholder. The most important fixes:

1. ui-audit SPA-mode + i18n-aware (otherwise misleading on real repos like this)
2. design-brief writes to a file (not chat) — non-tech UX
3. ui-scenario-picker "I don't know" fallback — bosses will hit this

Estimated refinement effort: **~2 hours**.
