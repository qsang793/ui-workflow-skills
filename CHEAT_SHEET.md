# UI Workflow — Cheat Sheet

> In ra, dán cạnh máy. Đọc trong 60 giây.

---

## 🎯 Bước 0 — Chọn kịch bản (gõ `/ui-scenario-picker`)

| | **A. Greenfield** | **B. Đổi công nghệ** | **C. Giữ công nghệ** |
|---|---|---|---|
| **Khi nào** | Chưa có gì | FE cũ kỹ, chấp nhận viết lại | FE chạy ổn, chỉ cần đẹp hơn |
| **Thời gian** | 1-2 tuần | 3-6 tuần | 3-7 ngày |
| **Mặc định an toàn** | | | ✅ |

> **Không chắc → chọn C.** Đắt nhất là chọn B khi đáng lẽ là C.

---

## 🔁 Quy trình 8 lệnh — luôn theo thứ tự này

```
1. /ui-scenario-picker     →  Chọn A / B / C
2. /ui-audit               →  Bản đồ UI hiện tại (bỏ qua nếu A)
3. /design-brief           →  Sinh prompt cho Lovable (ghi .ui-workflow/design-prompt.md)
4. [Tự vẽ trên Lovable / Google AI Studio]
5. /ingest-design-export   →  Bỏ code Lovable vào .ui-workflow/export/
6. /integration-planner    →  Kiểm tra Lovable có khớp với BE không
7. /integration-wire (A/B)  HOẶC  /design-port (C)
8. /preview-deploy         →  Link Vercel để click thử
```

---

## 🎨 Bước 4 — Chọn Lovable hay Google AI Studio?

| | **Lovable** | **Google AI Studio** |
|---|---|---|
| Tốt cho | Kịch bản A, B | **Kịch bản C** |
| Output | ZIP / GitHub sync | Copy-paste code từ chat |

→ **Kịch bản C → AI Studio.** Lovable mặc định trả React, fight với ràng buộc.
→ **A / B → Lovable.** Build full app từ specs.

---

## 📥 Bước 5 — 4 cách bỏ code vào project

Gõ `/ingest-design-export`, skill sẽ hỏi anh chọn cách nào:

| Cách | Khi nào dùng | Nói gì với Claude |
|---|---|---|
| **ZIP** | Tải nút "Download" trên Lovable | "Lovable export ở `~/Downloads/lovable-abc.zip`" |
| **GitHub** | Lovable sync sang GitHub | "Lovable repo ở `https://github.com/.../...`" |
| **Folder** | Đã tự unzip ra đâu đó | "Đã unzip ở `~/Desktop/design-export/`" |
| **Paste** | Lovable chỉ trả code trong chat | "Tôi sẽ paste từng file" |

→ Tất cả đều land vào `.ui-workflow/export/` ở root project. Không cần mở terminal.

---

## ✋ DỪNG NGAY nếu thấy bất cứ điều nào sau

- 🚨 Claude báo "cần viết lại hệ thống đăng nhập"
- 🚨 Claude báo "cần đổi database / cấu trúc dữ liệu"
- 🚨 Lovable vẽ trang mà BE không hỗ trợ
- 🚨 Bản preview vẫn hiện UI cũ
- 🚨 Bản preview hiện UI mới nhưng các nút không bấm được

→ **Gửi nguyên thông báo lỗi cho dev.** Đừng tự gõ thêm lệnh.

---

## 💎 Ba quy tắc vàng (thuộc lòng)

1. **Không bao giờ duyệt UI chỉ qua ảnh chụp màn hình.**
2. **Không bao giờ bỏ qua bước preview deploy.**
3. **Không bao giờ nói "ship to prod" trước khi tự click thử trên điện thoại.**

---

## ✅ Checklist trước khi ship to prod

- [ ] Mở trên **iPhone** — mọi nút bấm vừa ngón tay
- [ ] Mở trên **laptop** — không tràn chữ, không trống lạ
- [ ] Đăng nhập / đăng xuất chạy được
- [ ] Mỗi tính năng chính: hoàn thành 1 lượt happy path
- [ ] Nhập sai mật khẩu / ngắt wifi → có hiển thị lỗi rõ ràng?
- [ ] Khi tải chậm: có spinner / loading state?
- [ ] Khi không có dữ liệu: có thông báo empty state?

**Tất cả ☑** → nói: *"preview approved, ship to prod"*

---

## 🆘 Cần giúp?

| Tình huống | Nói gì với Claude |
|---|---|
| Không biết bắt đầu | `/ui-scenario-picker` |
| Bí ở giữa flow | "tôi đang ở bước X, gặp Y, gợi ý cho tôi" |
| Đã tải code Lovable, không biết để đâu | `/ingest-design-export` |
| Skill báo lỗi lạ | Copy nguyên thông báo gửi dev |
| Lovable trả ra UI không vừa ý | Mở Lovable, sửa prompt, lặp lại — đừng "ép" Claude |

---

*Bộ skill: `qsang793/ui-workflow-skills` v0.1.4 — Updated tự động khi dev push.*
