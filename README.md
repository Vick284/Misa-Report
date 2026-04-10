# 📊 MISA Data Automation: SQL Server to Excel P&L Report
> **Giải pháp:** Tự động hóa quy trình chiết xuất, chuyển đổi và nạp dữ liệu (ETL) từ hệ thống kế toán MISA sang báo cáo quản trị động trên Excel.

---

## 📖 1. Tổng quan dự án
Dự án này giải quyết bài toán lặp đi lặp lại trong việc xuất báo cáo thủ công từ phần mềm kế toán. Bằng cách sử dụng **SQL Server** làm lớp xử lý trung gian, dữ liệu được chuẩn hóa thông qua các View trước khi đưa vào **Power Query** để hiển thị trên Excel.

### Các thành phần cốt lõi:
* **Database:** `MisaRP` (SQL Server).
* **Transformation:** T-SQL (Sử dụng CTE, Join, Case When).
* **Visualization:** Excel Pivot Tables & Power Query.

---

## ⚙️ 2. Cấu trúc các View xử lý (SQL)

### 🔹 Master Data (`vw_MasterData`)
* **Mục tiêu:** Hợp nhất thông tin từ các bảng phân mảnh của MISA (Inventory, Employee, Account, Organization Unit).
* **Đặc điểm:** * Kết nối trực tiếp `RefID` để lấy chi tiết chứng từ.
    * Làm sạch dữ liệu danh mục hàng hóa và kho bãi.
    * Sẵn sàng cho việc phân tích doanh thu theo từng mặt hàng/nhân viên.

### 🔹 Báo cáo P&L (`BC_KQKD`)
* **Mục tiêu:** Xây dựng cấu trúc Báo cáo Kết quả Kinh doanh tự động.
* **Logic xử lý:**
    * **Phân loại tài khoản:** Tự động tách nhóm Doanh thu (5xx, 7xx) và Chi phí (6xx, 8xx).
    * **Xử lý đảo dấu (Sign Logic):** Sử dụng `CASE WHEN` để điều chỉnh giá trị `Amount_z` dựa trên tính chất Nợ/Có, giúp số liệu hiển thị đúng bản chất kế toán trên báo cáo.
    * **Format:** Chuẩn hóa ngày tháng (`dd/MM/yyyy`) để đồng bộ với Slicer trong Excel.

---

## 🚀 3. Hướng dẫn triển khai

### Bước 1: Khởi tạo View trong SSMS
1. Mở **SQL Server Management Studio**.
2. Chạy lần lượt các script trong thư mục dự án:
    * Chạy `MasterData.sql` để tạo View danh mục.
    * Chạy `P&L Report.sql` để tạo View báo cáo kinh doanh.

### Bước 2: Kết nối Power Query
1. Mở Excel, chọn **Data > Get Data > From Database > From SQL Server Database**.
2. Nhập thông tin Server và chọn Database `MisaRP`.
3. Chọn các View `vw_MasterData` và `BC_KQKD` từ danh sách.
4. Chọn **Load to... > PivotTable Report**.

### Bước 3: Cấu trúc báo cáo Excel
* **Rows:** `DoanhthuV2` / `ChiphiV2`.
* **Values:** `Amount_z` (Tổng tiền).
* **Filters/Slicers:** `newdate` (Thời gian).

---

## 💡 4. Lợi ích vượt trội
* **Zero Manual Work:** Không còn thao tác copy-paste thủ công mỗi tháng.
* **Data Consistency:** Dữ liệu giữa SQL và Excel luôn khớp nhau nhờ kết nối trực tiếp.
* **High Performance:** SQL Server thực hiện các phép tính nặng (Join, Union), giúp file Excel nhẹ và mượt mà.

---

## 🛠 Công nghệ sử dụng
* ![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
* ![Excel](https://img.shields.io/badge/Microsoft_Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white)
* ![Power Query](https://img.shields.io/badge/Power_Query-F2C811?style=for-the-badge&logo=power-bi&logoColor=black)

---
**Tác giả:** Trần Nguyễn Sĩ Đán  
**Năm thực hiện:** 2024
