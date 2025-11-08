#  ỨNG DỤNG QUẢN LÝ HỆ THỐNG SÂN BÓNG 
###  Flutter + Firebase Realtime Database  

---

## THÔNG TIN NHÓM THỰC HIỆN

**Trường Đại học Phenikaa**  
**Môn học:** Lập trình Thiết bị Di động 
**Tên đề tài:** Ứng dụng quản lý dịch vụ sân bóng   
**Giảng viên hướng dẫn:** ThS. Nguyễn Xuân Quế

### Nhóm thực hiện: **Nhóm 14 - LTTBDD N05**

| STT | Họ và tên | MSSV | Vai trò |
|------|------------|-------|----------|
| 1 | **Nguyễn Danh Bảo Đăng** | 22010507 | Nhóm trưởng – Thiết kế UI & Firebase Integration |
| 2 | **Võ Hồng Phúc** | 23010855 | Xây dựng giao diện người dùng |

## GIỚI THIỆU DỰ ÁN

Ứng dụng **Quản lý hệ  sân bóng** được phát triển nhằm giúp sinh viên, giảng viên và người yêu thể thao tại Trường Đại học Phenikaa **dễ dàng xem thông tin sân bóng, đặt sân trực tuyến và sử dụng các dịch vụ tiện ích đi kèm** (nước uống, áo bib, v.v.).

Ứng dụng được xây dựng bằng **Flutter (Google)**, sử dụng **Firebase Realtime Database** để quản lý dữ liệu theo thời gian thực, đồng bộ giữa người dùng và admin.

---

## 🎯 MỤC TIÊU

- Xây dựng hệ thống đặt sân hiện đại, tiện lợi, đồng bộ theo thời gian thực.  
- Tích hợp giao diện thân thiện, dễ sử dụng trên cả Web và Mobile.  
- Cho phép người dùng đặt sân, chọn khung giờ, dịch vụ đi kèm, và theo dõi lịch đặt của mình.  
- Hỗ trợ quản trị viên (admin) quản lý sân bóng, dịch vụ và trạng thái đặt sân.

---

## ⚙️ CÔNG NGHỆ SỬ DỤNG

| Thành phần | Mô tả |
|-------------|-------|
| **Framework** | Flutter SDK 3.x |
| **Ngôn ngữ lập trình** | Dart |
| **Cơ sở dữ liệu** | Firebase Realtime Database |
| **Xác thực người dùng** | Firebase Authentication |
| **Lưu trữ hình ảnh** | Firebase Storage |
| **Môi trường phát triển** | Visual Studio Code, Chrome Emulator |
| **Quản lý mã nguồn** | Git & GitHub |
| **Hệ điều hành phát triển** | Windows 11 |

---

## 🚀 CHỨC NĂNG CHÍNH

### 👤 **Người dùng (User):**
- Xem danh sách sân bóng (hình ảnh, giá, trạng thái).  
- Đặt sân theo ngày, giờ, ca (1h30p/ca).  
- Chọn dịch vụ kèm theo (nước suối, áo bib, coca, chanh muối, …).  
- Theo dõi “Lịch đặt của tôi”.  
- Đăng ký / đăng nhập / đổi mật khẩu qua Firebase Authentication.

### 🛠️ **Quản trị viên (Admin):**
- Thêm, sửa, xóa sân bóng và dịch vụ.  
- Xem danh sách người dùng.  
- Cập nhật trạng thái sân (trống / đang đặt / bảo trì).  
- Quản lý danh sách đặt sân và xác nhận đơn.

