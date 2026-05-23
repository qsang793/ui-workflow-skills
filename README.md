# UI Workflow Skills

Một bộ 7 Claude Code skills + 5 prompt templates cho Lovable / Google AI Studio, dùng để cải thiện UI cho **dự án bất kỳ**. Thiết kế để **non-technical stakeholder điều khiển**, developer chỉ can thiệp khi skill báo blocker.

**Version: 0.1.1** — pilot-tested trên một repo Vanilla JS + FastAPI. 12 refinements đã áp dụng từ v0.1.0. Xem `PILOT_RETROSPECTIVE.md` để biết chi tiết.

---

## Cài đặt

```bash
# 1. Clone repo về máy
git clone git@github.com:<your-username>/ui-workflow-skills.git ~/projects/ui-workflow-skills

# 2. Symlink skills vào Claude Code
mkdir -p ~/.claude/skills
ln -sf ~/projects/ui-workflow-skills/skills/* ~/.claude/skills/

# 3. Verify
ls ~/.claude/skills/ | grep -E '^(ui-|design-|integration-|preview-)'
```

Cần thấy 7 skills: `design-brief`, `integration-planner`, `integration-wire`, `preview-deploy`, `ui-audit`, `ui-scenario-picker`, `ui-translator`.

**Updates về sau**:

```bash
cd ~/projects/ui-workflow-skills && git pull
```

Symlinks tự pick up — không cần re-install.

---

## Cần thêm (cho `preview-deploy` skill)

```bash
# Vercel CLI (fallback khi Vercel MCP không sẵn sàng)
npm i -g vercel
vercel login
```

Nếu anh đã có Vercel MCP authenticated trong Claude → bỏ qua bước này.

---

## Cấu trúc

```
ui-workflow-skills/
├── README.md                          ← dev guide (file này)
├── UI_IMPROVEMENT_GUIDE.md            ← guide cho sếp (Tiếng Việt, non-tech)
├── PILOT_RETROSPECTIVE.md             ← evidence + 12 learnings từ pilot
├── CHANGELOG.md                       ← version history
├── LICENSE                            ← MIT
├── .gitignore
├── skills/
│   ├── ui-scenario-picker/SKILL.md    quyết định kịch bản A / B / C
│   ├── ui-audit/SKILL.md              map stack + pain points
│   ├── design-brief/SKILL.md          phỏng vấn user → prompt Lovable
│   ├── integration-planner/SKILL.md   diff Lovable vs BE (read-only guardrail)
│   ├── integration-wire/SKILL.md      thực thi tích hợp (kịch bản A/B)
│   ├── ui-translator/SKILL.md         dịch React → stack cũ (kịch bản C)
│   └── preview-deploy/SKILL.md        deploy Vercel preview
└── templates/
    ├── lovable-prompt-scenario-A.md
    ├── lovable-prompt-scenario-B.md
    ├── lovable-prompt-scenario-C.md   (cấm React — critical lockdown)
    ├── lovable-brand-block.md
    └── lovable-constraints-block.md
```

---

## Flow tổng thể

```
User: "tôi muốn cải thiện UI"
   ↓
/ui-scenario-picker   →  scenario A / B / C
   ↓
/ui-audit             →  UI_AUDIT.md (skip cho A)
   ↓
/design-brief         →  LOVABLE_PROMPT.md (paste-ready cho Lovable)
   ↓
[user mở Lovable, vẽ, export code]
   ↓
/integration-planner  →  INTEGRATION_PLAN.md  ← GUARDRAIL: stop nếu blocker
   ↓
/integration-wire (A/B)  hoặc  /ui-translator (C)
   ↓
/preview-deploy       →  https://<branch>.vercel.app
   ↓
[user click-test trên điện thoại + laptop]
   ↓
User: "preview approved, ship to prod"
```

---

## Mô hình 3 loại skill

| Loại | Skill | Đặc điểm |
|---|---|---|
| **Diagnostic** | `ui-scenario-picker`, `ui-audit`, `integration-planner` | Đọc + hỏi, không sửa code. An toàn invoke nhiều lần. |
| **Generative** | `design-brief` | Phỏng vấn user, sinh prompt + ghi `LOVABLE_PROMPT.md`. Không sửa source code. |
| **Action** | `integration-wire`, `ui-translator`, `preview-deploy` | Sửa code / deploy. Chỉ invoke khi diagnostic skill đã PASS. |

→ **Quy tắc**: không bao giờ chạy action skill khi diagnostic skill chưa OK.

---

## Bàn giao cho sếp (non-tech stakeholder)

1. Cài skills (script ở trên) trên máy sếp.
2. Đưa file [`UI_IMPROVEMENT_GUIDE.md`](./UI_IMPROVEMENT_GUIDE.md) cho sếp đọc — bản Tiếng Việt, không có code, decision tree.
3. Demo trực tiếp 1 lần: ngồi cạnh sếp, chạy full flow trên 1 project nhỏ.
4. Setup channel để sếp báo bug skill (Telegram / Slack).

---

## Pilot test

Đã pilot trên 1 repo Vanilla JS + FastAPI (personal habit tracker). Tested:
- ✅ `ui-scenario-picker` — đúng kịch bản (C) dựa filesystem
- ✅ `ui-audit` — phát hiện 1723 inline styles, 246 unique colors vs 16 design tokens, 5 files >500 lines
- ✅ `design-brief` template lockdown — verified "no React" appears 6+ chỗ trong scenario-C
- ⏸ `integration-planner`, `integration-wire`, `ui-translator`, `preview-deploy` — chưa pilot (cần Lovable output thật, sẽ test trong follow-up)

12 learnings từ pilot → đã apply vào v0.1.1. Xem `PILOT_RETROSPECTIVE.md`.

**Khi áp dụng cho project mới**: clone về, chạy `/ui-scenario-picker` ở root project. Skill chain sẽ tự dẫn dắt.

---

## Đóng góp / cập nhật

Mỗi skill là 1 file Markdown. Edit thoải mái:

```bash
$EDITOR skills/ui-audit/SKILL.md
git add skills/ui-audit/SKILL.md
git commit -m "ui-audit: <change description>"
git push
```

Bump version trong README + thêm entry vào `CHANGELOG.md` khi ship thay đổi đáng kể. Sếp nên `git pull` sau mỗi bump.

---

## License

MIT — xem `LICENSE`.
