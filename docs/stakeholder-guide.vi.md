# Hướng dẫn cho Stakeholder

Làm UI của dự án tốt hơn mà không làm hỏng những gì đang chạy. Bạn trả lời câu hỏi, xem kết quả và duyệt. Claude Code lo phần việc xung quanh một ứng dụng thiết kế AI bên ngoài. Developer vào cuộc khi một bước yêu cầu. Bạn không viết code và không cần mở terminal.

English version: [stakeholder-guide.md](stakeholder-guide.md)

> **Trạng thái: Beta.** Mọi Scenario đều là Beta, kể cả Scenario C: chưa Scenario nào qua một lần chạy thật từ đầu đến cuối. Hãy chuẩn bị tinh thần gặp chỗ chưa trơn tru và giữ liên lạc với Developer. Mục [Những gì chưa được kiểm chứng](#những-gì-chưa-được-kiểm-chứng) nói rõ phần nào chưa thử.

## Trước khi bắt đầu

- Developer đã cài plugin ([README](../README.md#install)) và mở dự án trong Claude Code. Dự án phải là một git repository.
- Bạn có tài khoản ở một Design tool: Lovable hoặc Google AI Studio. Gói và giá thay đổi theo thời gian, hãy xem trên trang của nhà cung cấp.
- Bạn biết cần liên hệ Developer nào và bằng cách nào.

Gõ lệnh của từng bước vào Claude Code và trả lời bằng ngôn ngữ của bạn; Claude sẽ dùng theo. Các file nhắc tới ở đây nằm trong `.ui-workflow/`, một thư mục bị trình duyệt file ẩn đi vì tên bắt đầu bằng dấu chấm. Hãy nhờ Claude hiện file ngay trong khung chat, hoặc chép file vào thư mục đó giúp bạn. Nếu Developer cài skill bằng symlink, hãy bỏ phần `ui-workflow-skills:` trong mỗi lệnh, kể cả các lệnh Claude nhắc trong câu trả lời.

## Các từ dùng trong tài liệu

- **Scenario**: hướng đi của dự án. A là chưa có frontend, B là viết lại frontend bằng công nghệ mới, C là giữ công nghệ và làm đẹp giao diện.
- **Design tool**: ứng dụng AI bên ngoài, nơi tạo ra UI mới.
- **Design prompt**: đoạn văn Claude viết sẵn để bạn dán vào Design tool.
- **Design export**: phần code Design tool trả về.
- **Screen**: một trang, hoặc một khung nhìn có tên như một tab, được xử lý thành một đơn vị.
- **Blocker**: dữ liệu hoặc hành vi bắt buộc mà backend hiện có không cung cấp được. Chỉ Developer mới quyết định được bước tiếp theo.
- **Port**: dựng lại giao diện của một Screen trong chính code hiện có của dự án.
- **Work branch**: nhánh git riêng chứa mọi thay đổi của lần chạy này. Code chính không bị ảnh hưởng cho tới khi Developer merge.
- **Preview**: bản sao tạm thời của dự án đã thay đổi, để bạn mở trên điện thoại và laptop của mình.

Danh sách đầy đủ nằm trong [glossary](../GLOSSARY.md) (tiếng Anh).

## Xem nhanh

| Scenario | Chọn khi | Công sức ước lượng |
|---|---|---|
| **A. Greenfield** (Beta) | Chưa có frontend | 1–2 tuần |
| **B. Stack migration** (Beta) | Frontend hiện tại cản trở bạn và bạn chấp nhận viết lại | 3–6 tuần |
| **C. Keep stack** (Beta) | Frontend chạy được, chỉ cần đẹp hơn | 3–7 ngày |

Không chắc? C là lựa chọn an toàn mặc định. Các con số công sức chỉ là ước lượng, chưa đo từ lần chạy thật nào.

| # | Bước | Lệnh | A | B | C |
|---|---|---|---|---|---|
| 1 | Chọn Scenario | `/ui-workflow-skills:ui-scenario-picker` | có | có | có |
| 2 | Kiểm tra UI hiện tại | `/ui-workflow-skills:ui-audit` | bỏ qua | có | có |
| 3 | Trả lời brief thiết kế | `/ui-workflow-skills:design-brief` | có | có | có |
| 4 | Làm việc trong Design tool | không có lệnh | có | có | có |
| 5 | Đưa Design export vào dự án | `/ui-workflow-skills:ingest-design-export` | có | có | có |
| 6 | Đối chiếu với backend | `/ui-workflow-skills:integration-planner` | bỏ qua | có | có |
| 7 | Dựng: Port từng Screen | `/ui-workflow-skills:design-port` | không | không | có |
| 7 | Dựng: nối frontend mới | `/ui-workflow-skills:integration-wire` | có | có | không |
| 8 | Bấm thử Preview | `/ui-workflow-skills:preview-deploy` | có | có | có |

Ba quy tắc:

1. Không bao giờ duyệt UI chỉ qua hình ảnh. Hãy bấm thử.
2. Không bao giờ bỏ qua Preview.
3. Không bao giờ vượt qua một STOP. Hãy đưa cho Developer xem.

## Các bước

### 1. Chọn Scenario

`/ui-workflow-skills:ui-scenario-picker`

Claude đọc file của dự án trước, rồi hỏi vài câu ngắn, mỗi lần một câu. Nếu bạn không biết có nên giữ công nghệ hiện tại không, Claude giải thích khác biệt và hỏi lại; vẫn chưa chắc thì Claude chọn C. Lựa chọn được lưu trong `.ui-workflow/state.md`, kèm lệnh tiếp theo.

Nếu dự án có cả code framework mới lẫn code cũ, nghĩa là một đợt chuyển đổi đang dở dang. Claude dừng và không chọn Scenario, vì Developer phải quyết định giữ frontend nào.

### 2. Kiểm tra UI hiện tại

`/ui-workflow-skills:ui-audit`

Scenario A bỏ qua bước này. Claude đọc code và không hỏi gì. Bạn nhận `.ui-workflow/audit.md`: công nghệ, các trang và các vấn đề xếp theo High, Medium, Low, mỗi mức tối đa năm mục, cùng một câu khuyến nghị. Nếu khuyến nghị nêu một Scenario khác, hãy chạy lại bước chọn Scenario; Claude sẽ hỏi trước khi thay lựa chọn của bạn.

### 3. Trả lời brief thiết kế

`/ui-workflow-skills:design-brief`

Trước tiên Claude hỏi bạn sẽ dùng Design tool nào:

| Scenario | Công cụ gợi ý | Lý do |
|---|---|---|
| A | Lovable (Google AI Studio cũng được) | Lấy code ra đơn giản nhất |
| B | Lovable cho React; Google AI Studio cho Angular hoặc Next.js | Lovable không cho chọn framework |
| C | Công cụ nào cũng được | Export chỉ là tham chiếu về giao diện |

Sau đó Claude hỏi chín hoặc mười câu ngắn, mỗi lần một câu: ai dùng UI, các thao tác chính, thương hiệu, phong cách, thiết bị, nguồn cảm hứng, những thứ bắt buộc phải có, ràng buộc, và phần cần giữ nguyên. Hãy nghiêm túc với những thứ bắt buộc phải có: chúng không bao giờ bị bỏ để vừa với thiết kế. Nếu bạn trả lời "không biết", Claude đưa ví dụ; lần thứ hai Claude chọn một mặc định an toàn và báo cho bạn.

Bạn nhận `.ui-workflow/design-prompt.md`. Prompt luôn bằng tiếng Anh, dù bạn dùng ngôn ngữ nào. Chỉ sao chép phần nằm giữa dòng `=== COPY EVERYTHING BELOW ...` và dòng `=== END COPY ===`. Phần bên dưới các dòng đó dành cho các bước sau.

### 4. Làm việc trong Design tool

Claude không tham gia bước này. Dán prompt vào công cụ và chỉnh đến khi ưng ý. Sau đó lấy code ra:

| Design tool | Cách lấy code |
|---|---|
| Lovable | "Sync to GitHub" (mọi gói, cần tài khoản GitHub; repository mới mặc định là private), hoặc "Download codebase" trong Project settings → Git (gói trả phí) |
| Google AI Studio (Build) | Tải ZIP, hoặc sync sang GitHub |

Tên các menu này lấy từ tài liệu của nhà cung cấp, kiểm tra ngày 2026-10-27, và có thể đã đổi chỗ.

Ở Scenario C framework nào cũng được, vì chỉ dùng phần giao diện. Với Google AI Studio ở Scenario C, hãy mở Settings trước khi dán: chọn plain HTML nếu có, không thì chọn framework nhẹ nhất (React thay vì Next.js hay Angular). Lời khuyên này chưa được thử; nếu không có lựa chọn đó, cứ dán.

Tiện thể, hãy chụp một ảnh cho mỗi Screen từ phần preview của công cụ. Bước sau sẽ hỏi đến.

### 5. Đưa Design export vào dự án

`/ui-workflow-skills:ingest-design-export`

Nói cho Claude biết export ở đâu:

| Bạn có | Có thể nói |
|---|---|
| File ZIP | "File ZIP ở `~/Downloads/my-design.zip`" |
| GitHub repository | "Repository là `https://github.com/you/my-design`" |
| Thư mục đã giải nén | "Tôi giải nén ở `~/Desktop/my-design`" |
| Code trong khung chat | "Tôi sẽ dán các file vào đây" |

Repository private chỉ sao chép được nếu máy này có quyền truy cập. Nếu không sao chép được, hãy dùng ZIP hoặc hỏi Developer.

Claude chép file vào `.ui-workflow/export/` và không bao giờ cài đặt hay chạy chúng. Nếu đã có export trước đó, Claude hỏi trước khi chuyển nó sang bản backup. Claude báo framework tìm thấy và liệt kê các Screen, rồi xin các ảnh chụp (không bắt buộc) và cho biết tên file của từng ảnh.

Hai trường hợp dừng: file ZIP bị từ chối vì không an toàn (hãy tải lại từ Design tool), và 🚨 SCENARIO MISMATCH, nghĩa là export không hợp với Scenario của bạn. Làm theo thông báo; nếu không được, hãy gọi Developer.

### 6. Đối chiếu với backend

`/ui-workflow-skills:integration-planner`

Scenario A bỏ qua bước này. Design tool không biết backend của bạn, nên có thể vẽ dữ liệu không tồn tại và nút không làm gì. Claude so sánh hai bên và viết `.ui-workflow/integration-plan.md` kèm kết luận:

| Kết luận | Ý nghĩa | Bạn làm gì |
|---|---|---|
| PROCEED | Thiết kế khớp với backend | Chạy lệnh tiếp theo |
| PROCEED WITH CAUTION | Khớp, nhưng cần chỉnh nhỏ hoặc có phần Claude không kiểm tra được | Đọc danh sách Not checked, chạy lệnh tiếp theo |
| STOP | Có ít nhất một Blocker | Đưa plan cho Developer. Không bước nào sau đó được chạy |

Với nút chỉ có trong thiết kế, Claude hỏi bạn bỏ nó đi (mặc định) hay hiện ở trạng thái vô hiệu với nhãn "coming soon". Sau khi bạn trả lời, Claude có thể yêu cầu chạy lại bước này. Hành vi màn hình đang có và những thứ bắt buộc của bạn không bao giờ bị bỏ: nếu backend không làm được, đó là Blocker. Dữ liệu thiết kế hiển thị mà backend không có cũng vậy, kể cả khi Design tool tự nghĩ ra, như một lời chứng thực; Developer sẽ quyết định.

### 7. Dựng

Claude tạo Work branch `ui-workflow/<ngày>` và chỉ commit sau khi bạn duyệt. Claude không bao giờ push hay merge; những thay đổi chưa commit của bạn được giữ nguyên.

#### Scenario C: Port từng Screen một

`/ui-workflow-skills:design-port`

Với mỗi Screen, theo thứ tự trong plan:

1. Claude dựng lại giao diện trong template và style hiện có của dự án.
2. Claude khởi động chính ứng dụng của dự án trên máy này và đưa bạn một link local, ví dụ `http://127.0.0.1:8000`, kèm chỗ cần bấm. Link chỉ mở được trên máy này, và ứng dụng dùng cấu hình của máy này, nên hãy coi những gì bạn thấy là dữ liệu thật. Việc kiểm tra trên điện thoại nằm ở bước Preview.
3. Báo cáo liệt kê các file đã đổi, các quyết định đã áp dụng, những gì phải thay thế và những gì không dựng lại được. Báo cáo cũng liệt kê các thông tin bị bỏ ra, như nguồn, số liệu, ngày tháng và lời chứng thực, vì Design tool tự nghĩ ra chúng. Claude hỏi trước khi dùng bất kỳ ảnh nào từ export, vì ảnh có thể do AI tạo dù được ghi là ảnh hoặc tư liệu thật.
4. Bạn mở link và trả lời: duyệt, hoặc nói cần đổi gì. Thay đổi được làm trên chính Screen đó rồi cho xem lại. Khi duyệt, Screen đó được commit và Screen tiếp theo bắt đầu.

Nếu ứng dụng không khởi động được, Claude dừng và Developer phải làm cho nó chạy. Bạn không bao giờ bị yêu cầu cài đặt hay chạy gì.

#### Scenario A và B: nối frontend mới

`/ui-workflow-skills:integration-wire`

- **Scenario A:** Design export trở thành dự án, đặt ở thư mục gốc nếu thư mục gốc còn trống, nếu không thì ở một thư mục mới do bạn đặt tên. Dự án vẫn hiển thị dữ liệu mẫu, đặt trong `src/lib/mock/`, cho tới khi có backend.
- **Scenario B:** frontend mới nằm trong thư mục riêng, `frontend-new/` nếu bạn không đặt tên khác, và nói chuyện với backend thật bằng cách đăng nhập backend đang có. Frontend cũ và backend được giữ nguyên.

Bản build của frontend mới phải qua. Nếu thất bại hoặc không chạy được, Claude dừng và Developer phải sửa. Khóa hoặc mật khẩu tìm thấy trong export được gỡ bỏ và báo cho Developer. Khi build qua, Claude báo đã làm gì và hỏi có lưu lại và đi tiếp không. Lần đầu bạn thấy kết quả chạy thật là ở bước Preview.

### 8. Bấm thử Preview

`/ui-workflow-skills:preview-deploy`

Claude chọn nơi chạy Preview dựa trên dạng của dự án; bạn không phải chọn:

| Dự án | Chạy ở đâu | Cần biết |
|---|---|---|
| Backend trả về các trang, frontend cần server, hoặc frontend tĩnh gọi tới backend chỉ chạy trên máy này (nếu không thể gộp về một địa chỉ thì Developer xử lý tiếp) | Máy của bạn, qua một tunnel tạm | Link là công khai: ai có link đều mở được ứng dụng. Ứng dụng có thể đọc và đổi **dữ liệu thật**, nên tránh các thao tác xóa, gửi và thanh toán nếu không chắc là an toàn. Máy này phải luôn bật và có mạng. Cập nhật trực tiếp có thể không chạy |
| Frontend tĩnh với backend công khai, hoặc không có backend | Một Vercel preview, không bao giờ là production | Developer đăng nhập Vercel một lần, và người sở hữu dự án Vercel tạo Shareable Link. Không có link đó, điện thoại của bạn sẽ thấy trang đăng nhập. Dự án chưa từng deploy cần Developer tạo trước một bản deploy trang giữ chỗ |
| Dự án có môi trường staging riêng | Staging | Chỉ khi Developer xác nhận |

Claude kiểm tra link mở được từ bên ngoài rồi mới đưa cho bạn. Với Vercel, Claude còn xác nhận Vercel báo đây là preview và địa chỉ production của dự án không mở được. Nếu có bước kiểm tra nào không đạt, bạn không nhận link và Developer xử lý tiếp. Claude không bao giờ đưa địa chỉ local cho điện thoại của bạn, vì điện thoại không mở được địa chỉ đó.

Đánh dấu mọi ô, trên thiết bị thật của bạn:

- [ ] Mở trên **điện thoại**: mọi nút bấm được bằng ngón cái, không phải cuộn ngang
- [ ] Mở trên **laptop**: không tràn chữ, không có khoảng trống lạ
- [ ] Đăng nhập và đăng xuất chạy được (nếu ứng dụng có)
- [ ] Mỗi tính năng chính: làm trọn một việc từ đầu đến cuối
- [ ] Thử tình huống lỗi (nhập sai, tắt wifi): có thông báo lỗi rõ ràng không?
- [ ] Thao tác chậm có trạng thái đang tải thay vì đứng im
- [ ] Danh sách trống có thông báo trống thay vì trang trắng

Đã đánh dấu hết: trả lời **preview approved**. Nếu bạn chỉ nói trông ổn, Claude sẽ hỏi bạn đã kiểm những ô nào. Sau đó link được đóng: Claude dừng tunnel, hoặc chờ Developer tắt Shareable Link.

Có gì sai: mô tả cái gì hỏng và trên thiết bị nào, và đừng duyệt. Claude đóng Preview và nêu bước sẽ sửa lỗi đó.

### Sau khi duyệt

UI đã duyệt nằm trên Work branch và chưa có gì được push. Push, merge và đưa lên production là việc của Developer; quy trình này dừng ở một Preview đã được duyệt.

## Khi nào gọi Developer

Đừng tự sửa những trường hợp này. Gửi Developer toàn bộ tin nhắn của Claude và file `.ui-workflow/state.md`. Nếu tin nhắn của Claude có phần dành cho Developer, hãy chuyển tiếp; đừng tự chạy các lệnh trong đó.

| Chuyện gì xảy ra | Developer làm gì |
|---|---|
| Bước 1 phát hiện chuyển đổi dở dang | Quyết định giữ frontend nào |
| Dự án không phải git repository | Thiết lập git |
| Kết luận STOP ở bước 6, ví dụ thiết kế cần dữ liệu hoặc đăng nhập mà backend không có | Quyết định từng Blocker |
| Lệnh chạy là `unknown`, hoặc ứng dụng không khởi động | Xác nhận lệnh, làm cho ứng dụng chạy |
| Không dùng được Work branch, hoặc tên nhánh đã tồn tại | Xử lý nhánh |
| Một Screen hoặc file trùng với thay đổi chưa commit của bạn | Commit hoặc để riêng các thay đổi đó |
| Scenario B: backend đòi API key hoặc bí mật dùng chung từ phía gọi | Đưa các lời gọi đó ra sau một route phía server |
| Tìm thấy khóa hoặc mật khẩu trong export | Đổi khóa |
| Build thất bại, không chạy được, hoặc muốn chạy script cài đặt | Sửa build hoặc quyết định về các script |
| Preview: chưa đăng nhập Vercel, dự án cần bản deploy trang giữ chỗ đầu tiên, cần tạo hoặc đóng Shareable Link, không có công cụ tunnel nào chạy được, hoặc link không mở được từ bên ngoài | Thiết lập hoặc sửa |
| Preview: Vercel báo không phải preview, hoặc địa chỉ production của dự án mở được | Gỡ khỏi địa chỉ công khai, hoặc xác nhận đó là trang đã phát hành |
| Preview vẫn hiện UI cũ hoặc các nút không làm gì, và chạy bước Claude nêu cũng không khỏi | Tìm nguyên nhân |
| UI đã được duyệt | Review, merge và phát hành |

Một bước ghi `Blocked` sẽ không đi tiếp cho tới khi Developer quyết định. Chạy lại chính bước đã dừng thì luôn được phép.

## Nếu bạn quên đang ở đâu

Tiến độ được lưu trong `.ui-workflow/state.md`, nên bạn có thể đóng Claude Code rồi quay lại. Chạy bước nào cũng được: nếu thiếu một bước trước đó, Claude nêu tên và lệnh của bước đó thay vì đoán. Muốn làm lại từ đầu thì chạy bước chọn Scenario; Claude sẽ hỏi trước.

## Những gì chưa được kiểm chứng

- **Chưa có lần chạy thật từ đầu đến cuối.** Chưa Scenario nào đi từ bước đầu tiên tới một Preview được duyệt trên dự án thật. [Pilot thật của Scenario C](https://github.com/qsang793/ui-workflow-skills/issues/13) là việc tiếp theo. Chỉ khi pilot qua thì C mới thành Production; A và B vẫn là Beta sau đó.
- **Chưa có export thật nào từ Lovable hay Google AI Studio đi qua quy trình.** Các quy tắc Port mới được thử trên một Screen từ export của công cụ khác (Google Stitch) và trên các export mẫu nhỏ. Đọc source của một export Lovable thật có đủ hay không là điều pilot sẽ kiểm tra.
- **Phần còn lại mới thử trên dự án mẫu.** Test tự động chạy từng skill trên các mẫu nhỏ, và kiểu test đó không mở được ứng dụng local. Vì vậy việc xem một Screen trong ứng dụng đang chạy chưa được nó kiểm tra, và chưa dự án framework thật nào được cài đặt và build.
- **Chưa có link Preview nào được mở trên điện thoại thật** qua các skill này. Các test kiểm tra Claude chọn host nào, không kiểm tra tunnel hay link Vercel đang chạy.
- **Thông tin của nhà cung cấp có thể đổi.** Menu và gói của Design tool lấy từ tài liệu kiểm tra ngày 2026-10-27.
