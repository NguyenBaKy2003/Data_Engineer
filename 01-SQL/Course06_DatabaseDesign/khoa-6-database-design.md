# Khóa 6: Database Design

> **Mục tiêu:** Hiểu cách thiết kế database đúng cách để tránh dư thừa dữ liệu, giảm lỗi và dễ mở rộng trong tương lai.
>
> Đây là khóa tập trung vào **tư duy thiết kế** hơn là cú pháp SQL.

---

# 1. Vấn đề: Database thiết kế tồi trông như thế nào?

Xem ví dụ dưới đây:

## Bảng `orders` (thiết kế tồi)

| id | customer_name | customer_email | product_name | product_price | quantity |
|----|--------------|----------------|--------------|--------------:|----------:|
| 1 | Nguyễn An | an@mail.com | Chuột không dây | 250000 | 2 |
| 2 | Nguyễn An | an@mail.com | Bàn phím cơ | 800000 | 1 |
| 3 | Trần Bình | binh@mail.com | Chuột không dây | 250000 | 1 |

---

## Vấn đề 1: Dư thừa dữ liệu (Redundancy)

Thông tin khách hàng bị lặp lại:

```text
Nguyễn An
an@mail.com
```

xuất hiện ở nhiều dòng.

Tương tự:

```text
Chuột không dây
250000
```

cũng bị lặp lại mỗi lần có người mua.

---

## Vấn đề 2: Update Anomaly

Giả sử:

```text
an@mail.com
```

đổi thành:

```text
nguyenan@gmail.com
```

Bạn phải sửa ở tất cả các dòng.

Nếu quên sửa một dòng:

```text
Dữ liệu bị mâu thuẫn.
```

---

## Vấn đề 3: Thiếu linh hoạt

Giả sử muốn lưu sản phẩm mới:

```text
Tai nghe Bluetooth
```

nhưng chưa ai mua.

Bạn không có nơi nào để lưu sản phẩm này.

---

## Kết luận

Một bảng đang chứa quá nhiều loại thông tin:

```text
Khách hàng
+
Sản phẩm
+
Đơn hàng
```

Điều này dẫn tới:

- Dư thừa dữ liệu
- Dễ phát sinh lỗi
- Khó mở rộng

---

# 2. Normalization (Chuẩn hóa dữ liệu)

Ý tưởng cốt lõi:

> **Mỗi thông tin chỉ nên được lưu ở đúng một nơi.**

---

## Thiết kế đã chuẩn hóa

### Bảng Customers

```sql
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE
);
```

---

### Bảng Products

```sql
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price NUMERIC CHECK (price > 0)
);
```

---

### Bảng Orders

```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,

    customer_id INTEGER
        REFERENCES customers(id),

    product_id INTEGER
        REFERENCES products(id),

    quantity INTEGER
        CHECK (quantity > 0),

    order_date DATE
        DEFAULT CURRENT_DATE
);
```

---

## Lợi ích

Đổi email khách hàng:

```sql
UPDATE customers
SET email = 'new@email.com'
WHERE id = 1;
```

Chỉ sửa:

```text
1 dòng
```

---

Đổi giá sản phẩm:

```sql
UPDATE products
SET price = 300000
WHERE id = 5;
```

Chỉ sửa:

```text
1 dòng
```

---

# 3. Các dạng chuẩn hóa (Normal Forms)

Không cần học thuộc định nghĩa hàn lâm.

Điều quan trọng là hiểu tư tưởng phía sau.

---

## 1NF (First Normal Form)

Mỗi ô chỉ chứa:

```text
1 giá trị duy nhất
```

Sai:

| customer |
|-----------|
| An, Bình |

---

Đúng:

| customer |
|-----------|
| An |
| Bình |

---

## 2NF (Second Normal Form)

Đạt 1NF và:

```text
Mọi cột phải phụ thuộc vào toàn bộ khóa chính.
```

Áp dụng nhiều với:

```sql
Composite Primary Key
```

---

## 3NF (Third Normal Form)

Đạt 2NF và:

```text
Không có phụ thuộc gián tiếp.
```

Ví dụ:

```text
order_id
   ↓
product_id
   ↓
product_price
```

`product_price` phụ thuộc vào:

```text
product_id
```

không phải:

```text
order_id
```

Do đó không nên lưu trong bảng `orders`.

---

## Quy tắc thực tế

Thay vì cố nhớ:

```text
1NF
2NF
3NF
```

hãy nhớ:

> **Mỗi bảng chỉ nên mô tả một loại thực thể.**

Ví dụ:

```text
customers
products
orders
```

tách riêng.

Không nên trộn tất cả vào một bảng.

---

# 4. Denormalization (Phi chuẩn hóa)

Chuẩn hóa giúp:

- Dữ liệu sạch
- Ít lỗi
- Dễ bảo trì

Nhưng đổi lại:

```sql
JOIN
```

nhiều hơn.

---

Ví dụ:

```sql
SELECT *
FROM orders
JOIN customers
JOIN products;
```

---

Khi dữ liệu rất lớn:

```text
JOIN có thể tốn thời gian.
```

---

Do đó trong:

```text
Data Warehouse
```

người ta đôi khi:

```text
Denormalize
```

có chủ đích.

---

Ý tưởng:

```text
Lặp lại dữ liệu một chút
↓
Đổi lấy tốc độ truy vấn nhanh hơn
```

---

# 5. Schema

Schema là:

```text
Bản thiết kế tổng thể của Database
```

Bao gồm:

- Các bảng
- Các cột
- Primary Key
- Foreign Key
- Quan hệ giữa các bảng

---

Ví dụ:

```text
customers
products
orders
```

---

# 6. ERD (Entity Relationship Diagram)

ERD giúp hình dung quan hệ giữa các bảng.

Ví dụ:

```text
customers (1)
      |
      |
      v
orders (N)

products (1)
      ^
      |
      |
orders (N)
```

---

Có thể viết ngắn gọn:

```text
customers (1) ──────< (N) orders (N) >────── (1) products
```

---

## Ý nghĩa

Một khách hàng:

```text
1
```

có thể tạo:

```text
N đơn hàng
```

---

Một sản phẩm:

```text
1
```

có thể xuất hiện trong:

```text
N đơn hàng
```

---

Đây là:

```text
One-to-Many Relationship
```

---

# 7. Database Views

View là:

```text
Bảng ảo
```

Không lưu dữ liệu thật.

Chỉ lưu:

```sql
SELECT ...
```

---

## Ví dụ

```sql
CREATE VIEW order_details AS

SELECT
    o.id AS order_id,
    c.name AS customer_name,
    p.product_name,
    p.price * o.quantity AS total_price

FROM orders o

JOIN customers c
    ON o.customer_id = c.id

JOIN products p
    ON o.product_id = p.id;
```

---

Sau đó:

```sql
SELECT *
FROM order_details;
```

---

Hoặc:

```sql
SELECT *
FROM order_details
WHERE customer_name = 'Nguyễn An';
```

---

## Lợi ích của View

### Đơn giản hóa

Ẩn JOIN phức tạp phía sau một tên dễ nhớ.

---

### Bảo mật

Cho phép người dùng xem:

```text
order_details
```

mà không cần truy cập trực tiếp vào bảng gốc.

---

### Nhất quán

Mọi người dùng chung:

```text
order_details
```

thay vì tự viết JOIN khác nhau.

---

# 8. Database Management

Một số lệnh quản trị cơ bản.

---

## Đổi tên bảng

```sql
ALTER TABLE orders
RENAME TO customer_orders;
```

---

## Thêm cột

```sql
ALTER TABLE customers
ADD COLUMN phone VARCHAR(20);
```

---

## Xóa cột

```sql
ALTER TABLE customers
DROP COLUMN phone;
```

---

## Xóa bảng

```sql
DROP TABLE customer_orders;
```

⚠️ Cẩn thận:

```text
DROP TABLE
```

sẽ xóa toàn bộ dữ liệu.

---

# 9. Tóm tắt

## Normalization

```text
Mỗi thông tin chỉ lưu một lần.
```

---

## Schema

```text
Bản thiết kế của database.
```

---

## ERD

```text
Sơ đồ quan hệ giữa các bảng.
```

---

## View

```sql
CREATE VIEW
```

Tạo bảng ảo từ một câu SELECT.

---

## ALTER TABLE

```sql
ALTER TABLE
```

Sửa cấu trúc bảng.

---

## DROP TABLE

```sql
DROP TABLE
```

Xóa bảng hoàn toàn.

---

# 🧪 Bài tập thực hành

## Bài 1 — Chuẩn hóa dữ liệu

Cho bảng:

```text
bookings (
    id,
    student_name,
    student_email,
    course_name,
    instructor_name,
    instructor_email,
    booking_date
)
```

Yêu cầu:

- Chỉ ra vấn đề thiết kế.
- Tách thành các bảng chuẩn hóa.
- Viết `CREATE TABLE` cho từng bảng.

---

## Bài 2 — View

Giả sử bảng:

```sql
products (
    id,
    product_name,
    price,
    stock_quantity
)
```

Viết View:

```sql
low_stock_alert
```

Hiển thị:

```text
product_name
stock_quantity
```

với điều kiện:

```sql
stock_quantity < 10
```

---

## Bài 3 — Lý thuyết

Trong bảng:

```text
orders (thiết kế tồi)
```

vì sao:

```text
product_price
```

được xem là vi phạm:

```text
3NF
```

Nó phụ thuộc trực tiếp vào:

```text
product_id
```

hay:

```text
order_id
```

---

# 🎯 Mục tiêu sau Khóa 6

Bạn cần hiểu:

- Database Design
- Normalization
- Denormalization
- Schema
- ERD
- Views
- ALTER TABLE
- DROP TABLE

Sau khóa này, bạn đã có nền tảng để học:

1. Data Warehousing
2. ETL Pipelines
3. Data Modeling
4. Star Schema
5. Snowflake Schema
6. Data Quality