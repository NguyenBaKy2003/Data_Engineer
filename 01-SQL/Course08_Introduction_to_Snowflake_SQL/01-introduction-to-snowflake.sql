-- SQLBook: Markup
Sau khi đã hiểu vì sao cần data warehouse (Khóa 7), giờ học công cụ cụ thể: Snowflake — một trong những cloud data warehouse phổ biến nhất hiện nay.
-- SQLBook: Markup
1. Snowflake khác PostgreSQL như thế nào?

    Điểm khác biệt lớn nhất, và cũng là lý do Snowflake nổi tiếng: tách rời hoàn toàn giữa lưu trữ (storage) và tính toán (compute).

| Tiêu chí | PostgreSQL | Snowflake |
|-----------|------------|------------|
| Kiến trúc | Storage và Compute gắn liền | Storage và Compute tách biệt |
| Mục đích chính | OLTP | OLAP |
| Scale | Nâng cấp toàn bộ server | Scale Compute riêng |
| Nhiều người dùng | Dễ tranh chấp tài nguyên | Compute độc lập |
| Cloud-native | Không phải mặc định | Có |
| Data Warehouse | Không tối ưu | Tối ưu |


-- SQLBook: Markup
Kiến trúc 3 tầng của Snowflake:
```text
┌──────────────────────┐
│ Cloud Services       │
├──────────────────────┤
│ Compute              │
├──────────────────────┤
│ Storage              │
└──────────────────────┘
```

👉 Ý nghĩa thực tế: đội Marketing chạy báo cáo nặng không làm chậm đội Sales đang query cùng lúc — vì mỗi đội dùng một Virtual Warehouse (cụm tính toán) riêng, dù cùng đọc chung một nguồn dữ liệu.
-- SQLBook: Markup
2. Virtual Warehouse — "cỗ máy" chạy truy vấn

    Đây là khái niệm không có trong PostgreSQL — bạn phải chỉ định rõ dùng "cỗ máy" nào để chạy câu lệnh.
-- SQLBook: Code
-- Tạo một virtual warehouse
CREATE WAREHOUSE analytics_wh
    WAREHOUSE_SIZE = 'SMALL'
    AUTO_SUSPEND = 300      -- tự tắt sau 300 giây không dùng (tiết kiệm chi phí)
    AUTO_RESUME = TRUE;     -- tự bật lại khi có truy vấn mới

-- Chọn warehouse để dùng
USE WAREHOUSE analytics_wh;
-- SQLBook: Markup
👉 Snowflake tính phí theo thời gian warehouse hoạt động (theo giây), nên AUTO_SUSPEND cực kỳ quan trọng — quên tắt = tốn tiền vô ích. Đây là khác biệt lớn so với PostgreSQL tự host, nơi bạn trả tiền cố định cho server dù dùng hay không.
-- SQLBook: Markup
3. Cấu trúc phân cấp: Database → Schema → Table

    Snowflake tổ chức theo 3 tầng, khác một chút so với PostgreSQL thuần:

    ```text

    Account (tài khoản Snowflake)
    └── Database
            └── Schema
                └── Table
    ```
-- SQLBook: Code
CREATE DATABASE sales_db;
CREATE SCHEMA sales_db.raw_data;

CREATE TABLE sales_db.raw_data.orders (
    id INT,
    customer_name VARCHAR,
    amount NUMBER
);

-- Hoặc chọn ngữ cảnh trước rồi thao tác ngắn gọn
USE DATABASE sales_db;
USE SCHEMA raw_data;
SELECT * FROM orders;   -- không cần ghi đầy đủ đường dẫn nữa
-- SQLBook: Markup
4. Kiểu dữ liệu đáng chú ý trong Snowflake

    Phần lớn cú pháp SQL bạn học ở Khóa 1-6 (SELECT, JOIN, GROUP BY, CREATE TABLE...) dùng lại được nguyên xi trong Snowflake — vì Snowflake tuân theo chuẩn ANSI SQL. Điểm khác biệt chính nằm ở vài kiểu dữ liệu đặc thù:

|Kiểu|	Dùng cho|
|--|:--|
|VARIANT|	lưu dữ liệu bán cấu trúc (JSON, Avro...) ngay trong 1 cột — không có ở PostgreSQL thuần|
|NUMBER(p,s)|	số, tương tự NUMERIC(p,s)|
|TIMESTAMP_NTZ / TIMESTAMP_TZ|	thời gian không/có múi giờ|

-- SQLBook: Code
-- Ví dụ truy vấn dữ liệu JSON lồng trong 1 cột VARIANT — đây là tính năng mạnh nổi bật của Snowflake:
CREATE TABLE raw_events (
    event_id INT,
    payload VARIANT   -- chứa nguyên 1 JSON object
);

-- Truy cập trường bên trong JSON bằng dấu hai chấm
SELECT
    event_id,
    payload:user_id::INT AS user_id,
    payload:action::STRING AS action
FROM raw_events;
-- SQLBook: Markup
👉 Đây chính là sức mạnh giúp Snowflake xử lý tốt cả dữ liệu có cấu trúc (bảng thường) lẫn bán cấu trúc (JSON từ API, log hệ thống) trong cùng một hệ thống — điều PostgreSQL làm được nhưng không mượt bằng.
-- SQLBook: Markup
5. Time Travel — tính năng đặc trưng của Snowflake

    Cho phép truy vấn dữ liệu ở một thời điểm trong quá khứ, ngay cả khi dữ liệu đã bị sửa/xóa — cực hữu ích khi cần khôi phục sau khi lỡ tay chạy sai câu DELETE/UPDATE.
-- SQLBook: Code
-- Xem dữ liệu bảng orders cách đây 1 giờ
SELECT * FROM orders AT (OFFSET => -3600);

-- Khôi phục cả bảng đã lỡ xóa nhầm
UNDROP TABLE orders;
-- SQLBook: Markup
Đây là điều không thể làm được trong PostgreSQL tiêu chuẩn (phải tự backup thủ công) — một lý do lớn khiến nhiều công ty chọn Snowflake cho warehouse.
-- SQLBook: Markup
6. Naming convention: chữ hoa mặc định

    Một điểm dễ gây nhầm lẫn: Snowflake mặc định chuyển tên object thành chữ HOA nếu bạn không đặt trong dấu ngoặc kép:
-- SQLBook: Code
CREATE TABLE orders (...);   -- thực chất được lưu là ORDERS

SELECT * FROM orders;    -- ✅ chạy được (Snowflake tự viết hoa để so khớp)
SELECT * FROM "orders";  -- ❌ lỗi! vì bảng thực tế tên là "ORDERS", không phải "orders"
-- SQLBook: Markup
👉 Ghi nhớ: tránh dùng dấu ngoặc kép khi đặt tên trong Snowflake trừ khi bạn thực sự cần phân biệt hoa/thường — nếu không sẽ dễ gặp lỗi "table not found" dù bảng vẫn tồn tại.
-- SQLBook: Markup
Bài tập thực hành

Bài 1: Viết lệnh tạo một Virtual Warehouse tên etl_wh, kích thước MEDIUM, tự tắt sau 10 phút (600 giây) không hoạt động, tự bật lại khi có truy vấn mới.

Bài 2: Viết đầy đủ chuỗi lệnh: tạo database ecommerce_db, tạo schema staging bên trong, rồi tạo bảng raw_orders gồm order_id NUMBER, raw_payload VARIANT.

Bài 3: Cho bảng raw_orders ở Bài 2, giả sử mỗi dòng raw_payload chứa JSON dạng:

json
{"customer": "Nguyễn An", "total": 250000, "status": "completed"}

Viết câu SELECT để lấy ra 3 trường customer, total, status thành 3 cột riêng biệt, ép kiểu total về NUMBER.

Bài 4 (lý thuyết): Giải thích ngắn gọn — vì sao việc "tách compute khỏi storage" trong kiến trúc Snowflake lại giúp tiết kiệm chi phí hơn so với kiến trúc truyền thống (như PostgreSQL tự host)?
-- SQLBook: Code
-- Bài 1: Viết lệnh tạo một Virtual Warehouse tên etl_wh, kích thước MEDIUM, tự tắt sau 10 phút (600 giây) không hoạt động, tự bật lại khi có truy vấn mới.

CREATE WAREHOUSE etl_wh 
    WAREHOUSE_SIZE ='MEDIUM'
    AUTO_SUSPEND= 600
    AUTO_RESUME = TRUE;
-- SQLBook: Code
-- Bài 2: Viết đầy đủ chuỗi lệnh: tạo database ecommerce_db, tạo schema staging bên trong, rồi tạo bảng raw_orders gồm order_id NUMBER, raw_payload VARIANT.

CREATE DATABASE ecommerce_db;
CREATE SCHEMA ecommerce_db.staging;
CREATE TABLE ecommerce_db.staging.raw_orders(
    order_id NUMBER,
    raw_payload VARIANT
)
-- SQLBook: Code
-- Bài 3: Cho bảng raw_orders ở Bài 2, giả sử mỗi dòng raw_payload chứa JSON dạng:

-- json
-- {"customer": "Nguyễn An", "total": 250000, "status": "completed"}

-- Viết câu SELECT để lấy ra 3 trường customer, total, status thành 3 cột riêng biệt, ép kiểu total về NUMBER.

select order_id,
raw_payload:customer::string as customer,
raw_payload:total::NUMBER as total,
raw_payload:status::String as status from ecommerce_db.staging.raw_orders;
-- SQLBook: Markup
<!-- Bài 4 (lý thuyết): Giải thích ngắn gọn — vì sao việc "tách compute khỏi storage" trong kiến trúc Snowflake lại giúp tiết kiệm chi phí hơn so với kiến trúc truyền thống (như PostgreSQL tự host)? -->

Vì khi nâng cấp chỉ cần tăng compute riêng lên mà không cần đụng đến storage, còn postgreSQL thì phải nâng cấp cả Server.
tiết kiệm chi phí còn đến từ cơ chế trả tiền theo mức sử dụng thực tế (pay-per-second, nhờ AUTO_SUSPEND bạn vừa dùng ở Bài 1). Với PostgreSQL tự host, bạn phải trả tiền server 24/7 cố định dù ban đêm không ai chạy query. Với Snowflake, warehouse tự tắt khi rảnh → không tốn phí tính toán, trong khi dữ liệu (storage) vẫn nằm nguyên đó với chi phí lưu trữ rẻ hơn nhiều so với chi phí compute.

👉 Tóm gọn: tách compute/storage không chỉ giúp scale linh hoạt mà còn giúp trả tiền đúng lúc dùng — đây là lý do kép, cả hai đều quan trọng.