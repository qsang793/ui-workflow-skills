# UI Workflow Skills

Một bộ 8 Claude Code skills + 5 prompt templates cho Lovable / Google AI Studio, dùng để cải thiện UI cho **dự án bất kỳ**. Thiết kế để **non-technical stakeholder điều khiển**, developer chỉ can thiệp khi skill báo blocker.

**Version: 0.2.0**: đóng gói thành Claude Code plugin, templates nằm trong skill `design-brief`, thêm CI kiểm tra skill. Xem `CHANGELOG.md`.

---

## Cài đặt

### Cách 1: plugin (khuyên dùng)

Trong Claude Code (2.1.275 trở lên):

```
/plugin install ui-workflow-skills --marketplace qsang793/ui-workflow-skills
```

Khi cài qua plugin, mỗi skill có tiền tố tên plugin, ví dụ `/ui-workflow-skills:ui-scenario-picker`. Thường chỉ cần nói "tôi muốn cải thiện UI", Claude tự chọn skill.

Cập nhật: `/plugin marketplace update ui-workflow-skills`.

### Cách 2: symlink (giữ tên lệnh ngắn như `/ui-scenario-picker`)

```bash
git clone https://github.com/qsang793/ui-workflow-skills.git ~/projects/ui-workflow-skills
mkdir -p ~/.claude/skills
ln -sf ~/projects/ui-workflow-skills/skills/* ~/.claude/skills/
ls ~/.claude/skills/ | grep -E '^(ui-|design-|ingest-|integration-|preview-)'
```

Cần thấy 8 skills: `design-brief`, `ingest-lovable-export`, `integration-planner`, `integration-wire`, `preview-deploy`, `ui-audit`, `ui-scenario-picker`, `ui-translator`. Cập nhật bằng `git pull`, symlink tự nhận bản mới.

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
├── .claude-plugin/
│   ├── plugin.json                    ← tên, version (nguồn version duy nhất)
│   └── marketplace.json
├── .github/workflows/validate.yml     ← CI
├── scripts/
│   ├── validate.py                    ← kiểm tra skill, template, link, version
│   └── test_validate.py
└── skills/
    ├── ui-scenario-picker/SKILL.md     quyết định kịch bản A / B / C
    ├── ui-audit/SKILL.md               map stack + pain points
    ├── design-brief/
    │   ├── SKILL.md                    phỏng vấn user → prompt Lovable
    │   └── templates/                  5 prompt templates (scenario A/B/C, brand, constraints)
    ├── ingest-lovable-export/SKILL.md  stage Lovable output vào lovable-export/
    ├── integration-planner/SKILL.md    diff Lovable vs BE (read-only guardrail)
    ├── integration-wire/SKILL.md       thực thi tích hợp (kịch bản A/B)
    ├── ui-translator/SKILL.md          dịch React → stack cũ (kịch bản C)
    └── preview-deploy/SKILL.md         deploy Vercel preview
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
[user mở Lovable, vẽ, export code (ZIP / GitHub / folder)]
   ↓
/ingest-lovable-export →  stage vào lovable-export/ + validate scenario
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
| **Staging** | `ingest-lovable-export` | Đưa Lovable export về `lovable-export/`, validate scenario. Không sửa source code hiện tại, chỉ tạo folder mới. |
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

Trước khi push, chạy kiểm tra (CI cũng chạy trên mỗi PR):

```bash
python3 scripts/validate.py
claude plugin validate ./ --strict
```

Phát hành bản mới:
1. Bump `version` trong `.claude-plugin/plugin.json` và thêm mục cùng số version vào đầu `CHANGELOG.md`. CI báo lỗi nếu hai số lệch nhau.
2. Commit, rồi tag: `git tag -a v<version> -m "v<version>" && git push --tags`.

Người dùng plugin chỉ nhận bản mới khi `version` thay đổi.

---

## License

MIT — xem `LICENSE`.
