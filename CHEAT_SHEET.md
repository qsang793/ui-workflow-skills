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

## 🔁 Quy trình 7 lệnh — luôn theo thứ tự này

```
1. /ui-scenario-picker     →  Chọn A / B / C
2. /ui-audit               →  Bản đồ UI hiện tại (bỏ qua nếu A)
3. /design-brief           →  Sinh prompt cho Lovable
4. [Tự vẽ trên Lovable / Google AI Studio]
5. /integration-planner    →  Kiểm tra Lovable có khớp với BE không
6. /integration-wire (A/B)  HOẶC  /ui-translator (C)
7. /preview-deploy         →  Link Vercel để click thử
```

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
| Skill báo lỗi lạ | Copy nguyên thông báo gửi dev |
| Lovable trả ra UI không vừa ý | Mở Lovable, sửa prompt, lặp lại — đừng "ép" Claude |

---

*Bộ skill: `qsang793/ui-workflow-skills` v0.1.1 — Updated tự động khi dev push.*
