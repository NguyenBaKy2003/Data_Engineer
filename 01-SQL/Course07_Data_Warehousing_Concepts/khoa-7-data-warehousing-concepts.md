# Khóa 7: Data Warehousing Concepts

> **Mục tiêu:** Hiểu sự khác biệt giữa hệ thống vận hành (OLTP) và hệ thống phân tích (OLAP), đồng thời nắm được các khái niệm nền tảng của Data Warehouse, Star Schema và Data Mart.
>
> Đây là khóa kết nối toàn bộ kiến thức từ Khóa 1 đến Khóa 6 thành một bức tranh hoàn chỉnh về hệ sinh thái dữ liệu doanh nghiệp.

---

# 1. OLTP vs OLAP

Đây là khái niệm quan trọng nhất của Data Warehousing.

## So sánh OLTP và OLAP

| Tiêu chí | OLTP (Online Transaction Processing) | OLAP (Online Analytical Processing) |
|-----------|--------------------------------------|-------------------------------------|
| Mục đích | Vận hành hệ thống hàng ngày | Phân tích và báo cáo |
| Ví dụ | Website bán hàng, ATM, ứng dụng ngân hàng | Dashboard doanh thu, BI, báo cáo tài chính |
| Dữ liệu | Chuẩn hóa (Normalized) | Thường phi chuẩn hóa (Denormalized) |
| Thao tác chính | INSERT, UPDATE, DELETE | SELECT phức tạp |
| Khối lượng truy vấn | Nhiều truy vấn nhỏ | Ít truy vấn nhưng rất nặng |
| Công cụ phổ biến | PostgreSQL, MySQL | Snowflake, BigQuery, Redshift |

---

## Ví dụ thực tế

### OLTP

Một khách hàng đặt hàng:

```text
Khách hàng
↓
Website
↓
Database
```

Hệ thống cần:

- Ghi đơn hàng
- Cập nhật tồn kho
- Cập nhật trạng thái thanh toán

Mọi thao tác phải:

```text
Nhanh
Chính xác
Tin cậy
```

---

### OLAP

CEO muốn biết:

```text
Doanh thu quý này theo khu vực?
Doanh thu năm nay so với năm ngoái?
Top sản phẩm bán chạy nhất?
```

Các truy vấn này:

- Quét hàng triệu dòng dữ liệu
- JOIN nhiều bảng
- Tính toán tổng hợp

Không phù hợp để chạy trực tiếp trên hệ thống OLTP.

---

# 2. Data Warehouse là gì?

Data Warehouse là nơi tập trung dữ liệu từ nhiều hệ thống khác nhau để phục vụ phân tích.

---

## Luồng dữ liệu

```text
Website
        \
ERP ----- \
            → Data Warehouse
CRM ----- /
         /
Marketing
```

---

## Vai trò

Data Warehouse:

- Thu thập dữ liệu
- Làm sạch dữ liệu
- Chuẩn hóa dữ liệu
- Lưu lịch sử
- Tối ưu cho phân tích

---

# 3. Bốn đặc điểm của Data Warehouse

Theo Bill Inmon.

---

## 1. Subject-Oriented

Tổ chức theo chủ đề kinh doanh.

Ví dụ:

```text
Doanh thu
Khách hàng
Sản phẩm
```

không phải:

```text
Database Website
Database ERP
Database CRM
```

---

## 2. Integrated

Dữ liệu từ nhiều nguồn được chuẩn hóa về cùng định dạng.

Ví dụ:

```text
CRM:
2025/01/15

ERP:
15-01-2025
```

Sau khi đưa vào warehouse:

```text
2025-01-15
```

---

## 3. Non-Volatile

Dữ liệu sau khi nạp:

```text
Ít khi sửa
Ít khi xóa
```

Chủ yếu:

```text
Append Only
```

(tức là thêm mới).

---

## 4. Time-Variant

Lưu lịch sử theo thời gian.

Ví dụ:

```text
Doanh thu Q1/2024
Doanh thu Q1/2025
```

đều được giữ lại.

---

# 4. Star Schema

Đây là mô hình dữ liệu phổ biến nhất trong Data Warehouse.

---

## Thành phần

### Fact Table

Chứa:

```text
Số liệu đo lường
```

Ví dụ:

- Doanh thu
- Số lượng bán
- Chi phí

---

### Dimension Table

Chứa:

```text
Thông tin mô tả
```

Ví dụ:

- Sản phẩm
- Khách hàng
- Thời gian
- Địa điểm

---

## Mô hình Star Schema

```text
              dim_customers
                    |
                    |
dim_products --- fact_sales --- dim_date
                    |
                    |
              dim_location
```

---

# 5. Ví dụ Star Schema

## Dimension Product

```sql
CREATE TABLE dim_products (
    product_key SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);
```

---

## Dimension Date

```sql
CREATE TABLE dim_date (
    date_key SERIAL PRIMARY KEY,
    full_date DATE,
    year INT,
    quarter INT,
    month INT
);
```

---

## Fact Sales

```sql
CREATE TABLE fact_sales (
    sale_id SERIAL PRIMARY KEY,

    product_key INT
        REFERENCES dim_products(product_key),

    date_key INT
        REFERENCES dim_date(date_key),

    quantity INT,
    revenue NUMERIC
);
```

---

## Tại sao gọi là Star?

Vì cấu trúc giống hình ngôi sao:

```text
      Dimension
          |
Dimension-Fact-Dimension
          |
      Dimension
```

---

## Lợi ích

Câu hỏi:

```text
Doanh thu theo quý?
Doanh thu theo sản phẩm?
Doanh thu theo khu vực?
```

chỉ cần JOIN vài bảng.

Nhanh hơn nhiều so với mô hình OLTP đã chuẩn hóa sâu.

---

# 6. Snowflake Schema

Snowflake Schema là phiên bản chuẩn hóa hơn của Star Schema.

---

## Ví dụ

Star Schema:

```text
dim_products
```

chứa:

```text
product_name
category_name
```

---

Snowflake Schema:

```text
dim_products
      |
      |
dim_category
```

---

## Minh họa

```text
dim_category
      |
dim_products
      |
fact_sales
```

---

# 7. Star vs Snowflake

| Tiêu chí | Star Schema | Snowflake Schema |
|-----------|-------------|------------------|
| Dimension | Phi chuẩn hóa | Chuẩn hóa |
| JOIN | Ít | Nhiều |
| Tốc độ truy vấn | Nhanh hơn | Chậm hơn |
| Dung lượng | Lớn hơn | Nhỏ hơn |
| Độ phổ biến | Cao | Thấp hơn |

---

## Thực tế

Phần lớn Data Warehouse hiện đại ưu tiên:

```text
Star Schema
```

vì:

```text
Đơn giản
Nhanh
Dễ hiểu
```

---

# 8. Data Mart

Data Mart là một phần nhỏ của Data Warehouse.

---

## Ví dụ

```text
Data Warehouse
│
├── Sales Mart
├── Marketing Mart
├── Finance Mart
└── HR Mart
```

---

## Lợi ích

Phòng Sales:

```text
Chỉ xem dữ liệu bán hàng
```

---

Phòng Finance:

```text
Chỉ xem dữ liệu tài chính
```

---

Không cần truy cập toàn bộ warehouse.

---

# 9. Quy trình Data Warehouse

Một pipeline điển hình:

```text
Extract
    ↓
Transform
    ↓
Load
    ↓
Data Warehouse
```

---

## Bước 1: Extract

Lấy dữ liệu từ:

- Website
- CRM
- ERP
- API

---

## Bước 2: Transform

Làm sạch dữ liệu:

- Xóa dữ liệu lỗi
- Chuẩn hóa định dạng
- Tính toán chỉ số

---

## Bước 3: Load

Nạp dữ liệu vào:

```text
Fact Tables
Dimension Tables
```

---

## Bước 4: Scheduling

Pipeline chạy:

```text
Mỗi giờ
Mỗi ngày
Mỗi tuần
```

---

Công cụ phổ biến:

```text
Apache Airflow
```

---

# 10. Tóm tắt

## OLTP

```text
Vận hành hệ thống
```

Ví dụ:

- Website bán hàng
- Ngân hàng
- ATM

---

## OLAP

```text
Phân tích dữ liệu
```

Ví dụ:

- Dashboard
- BI
- Báo cáo

---

## Data Warehouse

```text
Kho dữ liệu phục vụ phân tích
```

---

## Star Schema

```text
Fact + Dimensions
```

Mô hình phổ biến nhất.

---

## Snowflake Schema

```text
Dimension được chuẩn hóa thêm
```

---

## Data Mart

```text
Warehouse thu nhỏ cho từng phòng ban
```

---

## ETL

```text
Extract
Transform
Load
```

---

# 🧪 Bài tập thực hành

## Bài 1 — Lý thuyết

Một công ty có:

- Website bán hàng xử lý đơn hàng liên tục
- Hệ thống báo cáo cho ban giám đốc

Giải thích:

> Vì sao không nên chạy báo cáo trực tiếp trên database của website bán hàng?

---

## Bài 2 — Thiết kế Star Schema

Một chuỗi rạp chiếu phim muốn phân tích:

- Doanh thu theo phim
- Doanh thu theo rạp
- Doanh thu theo ngày

Thiết kế:

### Fact Table

```sql
fact_ticket_sales
```

### Dimension Tables

```sql
dim_movies
dim_theaters
dim_date
```

Viết `CREATE TABLE` cho cả 4 bảng.

---

## Bài 3 — Star hay Snowflake?

Giả sử:

```sql
dim_movies
```

chứa:

```text
movie_name
director_name
director_nationality
```

Đây là:

```text
Star Schema
hay
Snowflake Schema?
```

Nếu muốn chuyển sang dạng còn lại, bạn sẽ thiết kế lại thế nào?

---

## Bài 4 — Nhận diện hệ thống

### (a)

Hệ thống ATM xử lý:

```text
Hàng nghìn giao dịch rút tiền mỗi phút
```

Đây là:

```text
OLTP hay OLAP?
```

---

### (b)

Hệ thống phân tích:

```text
Xu hướng chi tiêu khách hàng
trong 5 năm
theo từng quý
```

Đây là:

```text
OLTP hay OLAP?
```

---

# 🎯 Mục tiêu sau Khóa 7

Bạn cần hiểu rõ:

- OLTP vs OLAP
- Data Warehouse
- Fact Table
- Dimension Table
- Star Schema
- Snowflake Schema
- Data Mart
- ETL Pipeline

Sau khóa này, bạn đã có nền tảng để học:

1. Introduction to Snowflake SQL
2. Data Modeling nâng cao
3. ETL Engineering
4. Apache Airflow
5. Modern Data Stack