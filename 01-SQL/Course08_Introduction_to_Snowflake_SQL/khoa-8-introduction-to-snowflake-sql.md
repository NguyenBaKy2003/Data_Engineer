# Khóa 8: Introduction to Snowflake SQL

> **Mục tiêu:** Làm quen với Snowflake – một trong những Cloud Data Warehouse phổ biến nhất hiện nay, hiểu kiến trúc của Snowflake và các tính năng đặc trưng so với PostgreSQL.

---

# 1. Snowflake khác PostgreSQL như thế nào?

Sau khi học về Data Warehouse ở Khóa 7, bạn sẽ thấy Snowflake được thiết kế cho:

```text
OLAP (Phân tích dữ liệu)
```

trong khi PostgreSQL thường được dùng cho:

```text
OLTP (Giao dịch vận hành)
```

---

## So sánh PostgreSQL và Snowflake

| Tiêu chí | PostgreSQL | Snowflake |
|-----------|------------|------------|
| Kiến trúc | Storage và Compute gắn liền | Storage và Compute tách biệt |
| Mục đích chính | OLTP | OLAP |
| Scale | Nâng cấp toàn bộ server | Scale Compute riêng |
| Nhiều người dùng | Dễ tranh chấp tài nguyên | Compute độc lập |
| Cloud-native | Không phải mặc định | Có |
| Data Warehouse | Không tối ưu | Tối ưu |

---

## Ví dụ thực tế

### PostgreSQL

```text
Server
├── Storage
└── Compute
```

Nếu cần xử lý nhiều truy vấn hơn:

```text
Phải nâng cấp cả server
```

---

### Snowflake

```text
Storage
     ↑
     │
 ┌───┴────┐
 │        │
WH A    WH B
```

Có thể:

- Giữ nguyên Storage
- Tăng Compute khi cần

---

# 2. Kiến trúc 3 tầng của Snowflake

Snowflake được xây dựng theo kiến trúc:

```text
┌──────────────────────┐
│ Cloud Services       │
├──────────────────────┤
│ Compute              │
├──────────────────────┤
│ Storage              │
└──────────────────────┘
```

---

## Storage Layer

Lưu trữ dữ liệu.

Ví dụ:

```text
Orders
Customers
Sales
Logs
```

Tất cả được lưu tập trung tại đây.

---

## Compute Layer

Bao gồm các:

```text
Virtual Warehouses
```

chịu trách nhiệm:

- Chạy truy vấn
- Transform dữ liệu
- ETL

---

## Cloud Services Layer

Phụ trách:

- Authentication
- Metadata
- Query Optimization
- Security
- Transaction Management

---

# 3. Virtual Warehouse

Virtual Warehouse là khái niệm rất quan trọng trong Snowflake.

---

## Tạo Warehouse

```sql
CREATE WAREHOUSE analytics_wh
    WAREHOUSE_SIZE = 'SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE;
```

---

## Sử dụng Warehouse

```sql
USE WAREHOUSE analytics_wh;
```

---

## Ý nghĩa

Ví dụ:

```text
Marketing Team
```

sử dụng:

```text
marketing_wh
```

---

```text
Sales Team
```

sử dụng:

```text
sales_wh
```

---

Hai nhóm:

```text
Không ảnh hưởng nhau
```

dù truy cập cùng dữ liệu.

---

# 4. AUTO_SUSPEND và AUTO_RESUME

Đây là tính năng rất quan trọng để tiết kiệm chi phí.

---

## AUTO_SUSPEND

```sql
AUTO_SUSPEND = 300
```

Nghĩa là:

```text
5 phút không có truy vấn
↓
Warehouse tự tắt
```

---

## AUTO_RESUME

```sql
AUTO_RESUME = TRUE
```

Nghĩa là:

```text
Có truy vấn mới
↓
Warehouse tự bật
```

---

## Vì sao quan trọng?

Snowflake tính phí theo:

```text
Thời gian Warehouse hoạt động
```

Không phải:

```text
Thời gian tồn tại
```

---

# 5. Cấu trúc phân cấp trong Snowflake

Snowflake tổ chức theo:

```text
Account
 └── Database
       └── Schema
             └── Table
```

---

## Tạo Database

```sql
CREATE DATABASE sales_db;
```

---

## Tạo Schema

```sql
CREATE SCHEMA sales_db.raw_data;
```

---

## Tạo Table

```sql
CREATE TABLE sales_db.raw_data.orders (
    id INT,
    customer_name VARCHAR,
    amount NUMBER
);
```

---

# 6. USE DATABASE và USE SCHEMA

Thay vì ghi đầy đủ:

```sql
sales_db.raw_data.orders
```

ta có thể:

```sql
USE DATABASE sales_db;
USE SCHEMA raw_data;
```

---

Sau đó:

```sql
SELECT *
FROM orders;
```

---

# 7. Kiểu dữ liệu trong Snowflake

Phần lớn SQL giống PostgreSQL.

Tuy nhiên có vài kiểu dữ liệu đặc trưng.

---

## NUMBER

```sql
NUMBER(p,s)
```

Tương đương:

```sql
NUMERIC(p,s)
```

Ví dụ:

```sql
NUMBER(10,2)
```

---

## TIMESTAMP

### Không có timezone

```sql
TIMESTAMP_NTZ
```

---

### Có timezone

```sql
TIMESTAMP_TZ
```

---

# 8. VARIANT

Đây là một trong những tính năng nổi bật nhất của Snowflake.

---

## Dùng để lưu JSON

```sql
CREATE TABLE raw_events (
    event_id INT,
    payload VARIANT
);
```

---

Ví dụ dữ liệu:

```json
{
  "user_id": 123,
  "action": "purchase"
}
```

---

# 9. Truy cập dữ liệu JSON

```sql
SELECT
    event_id,
    payload:user_id::INT AS user_id,
    payload:action::STRING AS action
FROM raw_events;
```

---

## Giải thích

### Truy cập trường

```sql
payload:user_id
```

---

### Ép kiểu

```sql
::INT
```

---

Tương tự:

```sql
payload:action::STRING
```

---

# 10. Snowflake và Semi-Structured Data

Snowflake hỗ trợ rất tốt:

```text
JSON
Avro
Parquet
XML
```

---

Điều này giúp xử lý:

```text
API Data
Event Logs
Streaming Data
```

rất thuận tiện.

---

# 11. Time Travel

Một tính năng nổi tiếng của Snowflake.

---

## Truy vấn dữ liệu quá khứ

```sql
SELECT *
FROM orders
AT (OFFSET => -3600);
```

---

Ý nghĩa:

```text
Xem dữ liệu cách đây 1 giờ
```

---

# 12. UNDROP TABLE

Lỡ xóa bảng?

```sql
DROP TABLE orders;
```

---

Khôi phục:

```sql
UNDROP TABLE orders;
```

---

Đây là tính năng rất hữu ích khi vận hành Data Warehouse.

---

# 13. Naming Convention

Snowflake mặc định chuyển tên object thành:

```text
CHỮ HOA
```

---

Ví dụ:

```sql
CREATE TABLE orders (
    id INT
);
```

Thực tế được lưu thành:

```text
ORDERS
```

---

## Truy vấn

```sql
SELECT *
FROM orders;
```

✅ Hoạt động

---

```sql
SELECT *
FROM ORDERS;
```

✅ Hoạt động

---

```sql
SELECT *
FROM "orders";
```

❌ Lỗi

---

Vì:

```text
ORDERS ≠ orders
```

khi dùng dấu ngoặc kép.

---

# 14. Khuyến nghị

Nên:

```sql
CREATE TABLE orders (...)
```

---

Không nên:

```sql
CREATE TABLE "orders" (...)
```

trừ khi thực sự cần phân biệt hoa/thường.

---

# 15. Tóm tắt

## Virtual Warehouse

```sql
CREATE WAREHOUSE
```

Compute độc lập.

---

## Storage và Compute tách biệt

```text
Storage
↓
Shared

Compute
↓
Scale độc lập
```

---

## Database Hierarchy

```text
Database
 → Schema
   → Table
```

---

## VARIANT

```sql
VARIANT
```

Lưu dữ liệu JSON.

---

## JSON Query

```sql
payload:user_id::INT
```

---

## Time Travel

```sql
AT (OFFSET => ...)
```

---

## Recovery

```sql
UNDROP TABLE
```

---

# 🧪 Bài tập thực hành

## Bài 1

Tạo Virtual Warehouse:

```text
etl_wh
```

Yêu cầu:

- Size = MEDIUM
- AUTO_SUSPEND = 600
- AUTO_RESUME = TRUE

---

## Bài 2

Viết các lệnh:

1. Tạo database:

```text
ecommerce_db
```

2. Tạo schema:

```text
staging
```

3. Tạo bảng:

```sql
raw_orders
```

gồm:

```sql
order_id NUMBER
raw_payload VARIANT
```

---

## Bài 3

Cho JSON:

```json
{
  "customer": "Nguyễn An",
  "total": 250000,
  "status": "completed"
}
```

Viết câu SELECT để lấy:

```text
customer
total
status
```

thành các cột riêng.

---

## Bài 4

Giải thích:

> Vì sao việc tách Compute khỏi Storage trong Snowflake giúp tiết kiệm chi phí hơn so với PostgreSQL tự host?

---

# 🎯 Mục tiêu sau Khóa 8

Bạn cần hiểu:

- Snowflake Architecture
- Virtual Warehouse
- Database / Schema / Table
- VARIANT
- JSON Querying
- Time Travel
- UNDROP TABLE
- Compute vs Storage

Sau khóa này, bạn đã sẵn sàng học:

1. Advanced Snowflake SQL
2. Data Loading
3. Snowpipe
4. dbt
5. Modern Data Warehouse Engineering