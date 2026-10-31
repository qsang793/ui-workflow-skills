# Hướng dẫn cải thiện UI bằng Claude Code + Lovable / Google AI Studio

> Tài liệu này dành cho **người không cần biết code**. Anh chỉ cần đọc, làm theo từng bước, và biết khi nào nên dừng lại hỏi dev.

---

## Mục tiêu

Làm cho giao diện (UI) của bất kỳ dự án nào của anh **đẹp hơn, dễ dùng hơn**, mà **không làm vỡ phần backend đã chạy ổn**. Anh dùng Claude Code để điều phối, dùng Lovable (hoặc Google AI Studio) để vẽ giao diện.

---

## Bước 0 — Xác định kịch bản trước khi làm bất cứ gì

Có 3 kịch bản. Anh **phải chọn đúng 1 cái** trước khi bắt đầu. Nếu không chắc, gõ vào Claude Code:

```
/ui-scenario-picker
```

Claude sẽ hỏi vài câu rồi chỉ cho anh kịch bản phù hợp.

| Kịch bản | Khi nào dùng | Ví dụ thực tế |
|---|---|---|
| **A. Greenfield** (làm mới hoàn toàn) | Chưa có gì cả, vừa làm FE vừa làm BE | "Em muốn làm một dashboard mới từ đầu" |
| **B. Brownfield, đổi công nghệ** | Đã có BE đang chạy, FE cũ kỹ, sẵn sàng viết lại bằng công nghệ hiện đại | "Trang admin cũ dùng jQuery, muốn chuyển sang React/Next.js" |
| **C. Brownfield, giữ công nghệ** | FE hiện tại vẫn chạy ổn, chỉ cần đẹp hơn | "Trang web hoạt động tốt rồi, chỉ cần làm cho nó nhìn sang hơn" |

⚠️ **Sai kịch bản = đốt tiền.** Chọn B khi đáng lẽ là C → phải viết lại toàn bộ FE từ đầu (mất 3-6 tuần thay vì 1 tuần).

---

## Quy trình 7 bước

### Bước 1 — Khám sức khỏe UI hiện tại

```
/ui-audit
```

**Claude làm gì:** Đọc qua code FE hiện tại, xác định:
- Đang dùng công nghệ gì (React? Vanilla JS? jQuery?)
- Có bao nhiêu trang, trang nào hay được dùng
- Vấn đề rõ ràng: không responsive, không có loading state, màu sắc lộn xộn, v.v.

**Anh nhận lại:** Báo cáo ngắn 1 trang, đọc trong 5 phút.

**Tại sao bước này quan trọng:** "Trang nhìn xấu, làm lại đi" là yêu cầu quá mơ hồ. Báo cáo này biến cảm giác mơ hồ thành danh sách cụ thể.

> ⏭ Bỏ qua nếu là kịch bản A (chưa có gì để khám).

---

### Bước 2 — Tạo brief thiết kế

```
/design-brief
```

**Claude làm gì:** Hỏi anh 5-10 câu rất đơn giản, ví dụ:
- Ai sẽ dùng giao diện này nhiều nhất?
- 3 thao tác quan trọng nhất là gì?
- Màu thương hiệu? Phong cách (sang trọng / vui tươi / tối giản)?
- Ưu tiên mobile hay desktop?
- **Có chấp nhận đổi công nghệ FE không?** (câu này quyết định kịch bản B vs C)

**Anh nhận lại:** Một đoạn prompt dài, đã viết sẵn, **chỉ việc copy paste vào Lovable hoặc Google AI Studio.**

---

### Bước 3 — Vẽ giao diện bằng Lovable / Google AI Studio

**Bước này không có Claude.** Anh làm trực tiếp trên 1 trong 2 tool.

#### Chọn tool nào?

| | **Lovable** | **Google AI Studio** |
|---|---|---|
| Output | Full React/Next.js project (ZIP + GitHub sync) | Code blocks trong chat (copy-paste) |
| Tốt cho | Kịch bản A, B (full app) | Kịch bản C (visual mockup, HTML+CSS) |
| Giá | Gói tháng có phí | Free tier rộng |

→ **Kịch bản C** (giữ stack cũ): chọn **Google AI Studio**. Lovable mặc định trả React, sẽ phải "ép" mới chịu trả HTML thuần.
→ **Kịch bản A/B**: chọn **Lovable**. Sweet spot của nó.

#### Sau khi chọn

1. Paste prompt từ `.ui-workflow/design-prompt.md` vào tool đã chọn.
2. Xem kết quả, sửa, lặp lại đến khi ưng (2-3 phương án).
3. **Chụp ảnh tất cả** các phương án đẹp trước khi quyết định.
4. Khi đã chốt:
   - **Lovable**: bấm "Download ZIP" hoặc enable "Sync to GitHub".
   - **AI Studio**: copy code từ chat (sẽ paste vào skill ở Bước 4).

⚠️ **Đừng chọn theo cảm giác chớp nhoáng.** Nếu tool cho 3 phương án, hãy mang cả 3 về cho dev xem trước khi chốt.

---

### Bước 4 — Mang code Lovable về project

```
/ingest-design-export
```

**Claude làm gì:** Lấy code Lovable từ chỗ anh để + đặt vào folder `.ui-workflow/export/` ở root project — chỗ skill kế tiếp biết tìm. Đồng thời check xem Lovable có làm đúng kịch bản không (ví dụ kịch bản C cấm React).

**Anh có 4 cách đưa code cho Claude:**

| Cách | Khi nào dùng | Nói với Claude |
|---|---|---|
| **ZIP** | Bấm nút "Download" trên Lovable | "ZIP ở `~/Downloads/lovable-abc.zip`" |
| **GitHub** | Lovable sync sang GitHub | "Repo ở `https://github.com/.../...`" |
| **Folder** | Đã tự unzip ra đâu đó | "Đã unzip ở `~/Desktop/design-export/`" |
| **Paste** | Lovable chỉ trả code trong chat | "Tôi sẽ paste từng file vào đây" |

→ Không cần mở terminal. Skill xử lý hết.

🚨 **Nếu kịch bản là C mà Lovable trả ra React/JSX** → skill sẽ báo "SCENARIO MISMATCH", **DỪNG NGAY** và quay lại Lovable sửa prompt (xem `.ui-workflow/design-prompt.md` mục CRITICAL CONSTRAINT).

---

### Bước 5 — Lên kế hoạch tích hợp

```
/integration-planner
```

**Claude làm gì:** Lấy thiết kế từ Lovable + code BE hiện tại, đối chiếu:
- API hiện có khớp với thiết kế không?
- Auth (đăng nhập) có cần viết lại không?
- Database có cần thay đổi không?

**Anh nhận lại:** Danh sách "việc cần làm trước khi UI mới chạy được", có ước lượng giờ công.

🚨 **Tín hiệu nguy hiểm — DỪNG NGAY và hỏi dev:**
- Báo cáo nói "cần viết lại hệ thống đăng nhập"
- Báo cáo nói "thiết kế đòi hỏi 50 endpoint mà BE chỉ có 5"
- Báo cáo nói "cần đổi cấu trúc database"

→ Nghĩa là Lovable đã vẽ một thứ mà BE hiện tại không hỗ trợ được. Tiếp tục = đốt tiền nhiều.

---

### Bước 6 — Tích hợp code (chỉ kịch bản B/C khác nhau ở bước này)

**Kịch bản A hoặc B** (greenfield, hoặc đổi công nghệ):
```
/integration-wire
```
Kịch bản A: code từ Lovable trở thành project, chạy bằng dữ liệu mẫu cho đến khi có BE. Kịch bản B: FE mới nằm ở thư mục riêng và nối vào BE của anh, FE cũ giữ nguyên. Khi build qua, Claude hỏi anh trước khi lưu lên Work branch; không bao giờ tự push hay merge.

**Kịch bản C** (giữ công nghệ cũ):
```
/design-port
```
Claude **dịch** thiết kế Lovable (thường là React) sang công nghệ FE anh đang dùng. Giữ nguyên ý tưởng thiết kế, đổi cách hiện thực.

> 💡 Kịch bản C là kịch bản tiết kiệm nhất. Anh ưu tiên C nếu FE cũ vẫn chạy.

---

### Bước 7 — Triển khai bản preview để click thử

```
/preview-deploy
```

**Claude làm gì:** Đẩy UI mới lên một địa chỉ tạm, ví dụ `preview.yoursite.com`, **tách biệt hoàn toàn với bản production**.

**Anh làm gì:** Click thử trên cả điện thoại lẫn máy tính. Đây là bước **bắt buộc** trước khi đồng ý ra mắt.

⚠️ **Đừng bao giờ duyệt UI chỉ dựa trên ảnh chụp màn hình.** Ảnh đẹp ≠ dùng được. Phải click thật.

---

### Bước 8 — Checklist trước khi ra prod

Tự anh đi qua từng mục:

- [ ] Mở trên iPhone — mọi nút bấm vừa ngón tay
- [ ] Mở trên laptop — không có chữ tràn, không có khoảng trắng kỳ lạ
- [ ] Đăng nhập / đăng xuất chạy được
- [ ] Mỗi tính năng chính: chạy được ít nhất 1 lần
- [ ] Thử tình huống lỗi: nhập sai mật khẩu, mất mạng → có hiển thị thông báo rõ ràng không?
- [ ] Trạng thái "đang tải" có hiển thị không (hay là trang đứng im đáng nghi)?

**Chỉ khi tất cả ☑** mới nói với Claude: *"Ship to prod."*

---

## Vai trò trong quy trình

| Anh (sếp) làm | Claude làm | Lovable / AI Studio làm |
|---|---|---|
| Nói mục tiêu bằng tiếng Việt thường | Chọn skill phù hợp | Vẽ giao diện |
| Trả lời câu hỏi phỏng vấn | Sinh prompt thiết kế | Trả về phương án |
| Chọn phương án ưng ý | Lên kế hoạch tích hợp | (không) |
| Click thử bản preview | Ghép FE + BE | (không) |
| Duyệt hoặc từ chối | Đẩy lên production khi được duyệt | (không) |

---

## 🚨 Khi nào DỪNG và hỏi dev

| Tình huống | Vì sao nguy hiểm |
|---|---|
| Claude nói "cần viết lại hệ thống đăng nhập" | Thay đổi rất sâu, dễ vỡ dữ liệu người dùng |
| Claude nói "cần đổi database / cấu trúc dữ liệu" | Có thể mất dữ liệu cũ |
| Lovable đưa ra thiết kế với những trang mà BE không có | Đẹp nhưng không chạy được |
| Bản preview không hiện UI mới mà vẫn là UI cũ | Có lỗi cache/deploy, đừng tự sửa |
| Bản preview hiện ra nhưng các nút không bấm được | Code FE chưa nối với API |

→ Trong 5 tình huống trên, **đừng tự gõ thêm lệnh nào**. Gửi nguyên thông báo lỗi cho dev.

---

## Thời gian ước tính

| Kịch bản | Thời gian thực tế | Chi phí Lovable/AI Studio |
|---|---|---|
| A — Greenfield | 1-2 tuần | ~$20-40 (gói tháng) |
| B — Đổi công nghệ | 3-6 tuần | ~$20-40 |
| C — Giữ công nghệ, đánh bóng | 3-7 ngày | ~$20 |

Nếu Claude bảo "việc này mất 2 ngày" nhưng đến ngày thứ 5 chưa xong → **dừng lại, hỏi dev tại sao**, đừng tiếp tục đốt tokens.

---

## Quy tắc vàng

> **Không bao giờ duyệt UI chỉ qua ảnh.**
> **Không bao giờ bỏ qua bước preview deploy.**
> **Không bao giờ nói "ship to prod" trước khi tự click thử trên điện thoại.**

Ba câu này thuộc lòng = tiết kiệm rất nhiều tiền và đêm mất ngủ.

---

## Bảng tra nhanh các lệnh

| Lệnh | Khi nào dùng |
|---|---|
| `/ui-scenario-picker` | Lúc bắt đầu, không chắc kịch bản A/B/C |
| `/ui-audit` | Đầu dự án (trừ kịch bản A) |
| `/design-brief` | Trước khi mở Lovable |
| `/ingest-design-export` | Sau khi tải/export code từ Lovable — đưa vào project |
| `/integration-planner` | Sau khi đã ingest, để check Lovable khớp với BE không |
| `/design-port` | Kịch bản C — dịch Lovable về công nghệ cũ |
| `/integration-wire` | Kịch bản A/B — ghép code Lovable vào BE |
| `/preview-deploy` | Trước khi duyệt cuối |

---

*Tài liệu này được viết để dùng kèm với Claude Code. Nếu một lệnh không hoạt động, có nghĩa là dev chưa hoàn thành phần setup — báo cho dev biết.*
