# Khóa 5: Introduction to Relational Databases

> **Mục tiêu:** Hiểu cách thiết kế database quan hệ, tạo bảng, định nghĩa khóa chính, khóa ngoại và các ràng buộc dữ liệu.
>
> Đây là bước chuyển từ việc **truy vấn dữ liệu** sang **thiết kế dữ liệu**, một kỹ năng cốt lõi của Data Engineer.

---

# 1. CREATE TABLE — Tạo bảng mới

Câu lệnh `CREATE TABLE` dùng để tạo một bảng trong database.

Ví dụ:

```sql
CREATE TABLE employees (
    id INTEGER,
    name VARCHAR(100),
    salary NUMERIC,
    hire_date DATE
);
```

---

## Các kiểu dữ liệu phổ biến

| Kiểu dữ liệu | Dùng cho | Ví dụ |
|-------------|----------|--------|
| `INTEGER` / `INT` | Số nguyên | 1, 2500 |
| `NUMERIC` / `DECIMAL` | Số thập phân chính xác | 25000000.50 |
| `VARCHAR(n)` | Chuỗi ký tự giới hạn độ dài | 'Nguyễn An' |
| `TEXT` | Chuỗi dài | Mô tả sản phẩm |
| `DATE` | Ngày tháng | 2021-03-01 |
| `BOOLEAN` | Đúng/Sai | TRUE, FALSE |

---

## Lưu ý quan trọng về dữ liệu tiền tệ

Nên dùng:

```sql
NUMERIC
```

hoặc:

```sql
DECIMAL
```

Không nên dùng:

```sql
FLOAT
```

Ví dụ:

```sql
salary NUMERIC(12,2)
```

Lý do:

```text
FLOAT có thể phát sinh sai số làm tròn.
```

Điều này rất nguy hiểm khi xử lý:

- Lương
- Hóa đơn
- Thanh toán
- Báo cáo tài chính

---

# 2. Attribute Constraints — Ràng buộc dữ liệu

Một database tốt không chỉ lưu dữ liệu.

Nó còn phải ngăn dữ liệu sai ngay từ đầu.

Ví dụ:

```sql
CREATE TABLE employees (
    id INTEGER,
    name VARCHAR(100) NOT NULL,
    salary NUMERIC CHECK (salary > 0),
    email VARCHAR(255) UNIQUE,
    department VARCHAR(50) DEFAULT 'Chưa phân bổ'
);
```

---

## NOT NULL

```sql
name VARCHAR(100) NOT NULL
```

Ý nghĩa:

```text
Bắt buộc phải có giá trị.
Không được để trống.
```

Ví dụ:

```sql
INSERT INTO employees(name)
VALUES (NULL);
```

Kết quả:

```text
ERROR
```

---

## UNIQUE

```sql
email VARCHAR(255) UNIQUE
```

Ý nghĩa:

```text
Không được trùng lặp.
```

Ví dụ:

```text
an@gmail.com
an@gmail.com
```

Dòng thứ hai sẽ bị từ chối.

---

## CHECK

```sql
salary NUMERIC CHECK (salary > 0)
```

Ý nghĩa:

```text
Tự định nghĩa điều kiện hợp lệ.
```

Ví dụ:

```sql
salary = -5000
```

Database sẽ báo lỗi.

---

## DEFAULT

```sql
department VARCHAR(50)
DEFAULT 'Chưa phân bổ'
```

Nếu không nhập:

```sql
INSERT INTO employees(name)
VALUES ('Nguyễn An');
```

Database sẽ tự điền:

```text
Chưa phân bổ
```

---

# 3. PRIMARY KEY — Khóa chính

Khóa chính dùng để định danh duy nhất cho mỗi dòng.

Ví dụ:

```sql
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    salary NUMERIC
);
```

---

## PRIMARY KEY đảm bảo điều gì?

### Không được NULL

```text
NULL
```

Không hợp lệ.

---

### Không được trùng

Ví dụ:

```text
id = 1
id = 1
```

Dòng thứ hai sẽ bị từ chối.

---

### Tóm tắt

```text
PRIMARY KEY
=
NOT NULL
+
UNIQUE
```

---

# 4. SERIAL — Khóa chính tự tăng

Trong PostgreSQL:

```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
```

Khi thêm dữ liệu:

```sql
INSERT INTO employees(name)
VALUES ('Nguyễn An');
```

Database tự tạo:

```text
id = 1
```

Lần tiếp theo:

```text
id = 2
```

Rồi:

```text
id = 3
```

---

# 5. Composite Primary Key

Có những trường hợp một cột không đủ để định danh duy nhất.

Ví dụ:

```sql
CREATE TABLE enrollments (
    student_id INTEGER,
    course_id INTEGER,
    enroll_date DATE,

    PRIMARY KEY (
        student_id,
        course_id
    )
);
```

---

## Tại sao cần Composite Key?

Một sinh viên:

```text
student_id = 1
```

có thể học nhiều khóa.

---

Một khóa học:

```text
course_id = 10
```

có thể có nhiều sinh viên.

---

Nhưng:

```text
(student_id, course_id)
```

chỉ nên xuất hiện một lần.

Ví dụ:

```text
(1,10)
(1,10)
```

Dòng thứ hai không hợp lệ.

---

# 6. FOREIGN KEY — Khóa ngoại

Đây là nền tảng của relational database.

Ví dụ:

```sql
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);
```

---

```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,

    department_id INTEGER
        REFERENCES departments(id)
);
```

---

## Điều gì xảy ra?

```sql
department_id
REFERENCES
departments(id)
```

nghĩa là:

```text
department_id
phải tồn tại trong
departments.id
```

---

Ví dụ:

Bảng:

```text
departments

id
--
1
2
3
```

---

Hợp lệ:

```sql
department_id = 2
```

---

Không hợp lệ:

```sql
department_id = 99
```

Kết quả:

```text
ERROR
```

---

# 7. Referential Integrity

Khái niệm này gọi là:

```text
Referential Integrity
(Toàn vẹn tham chiếu)
```

Ý nghĩa:

```text
Các bảng luôn tham chiếu tới dữ liệu tồn tại thật.
```

Nhờ đó:

```sql
employees.department_id
=
departments.id
```

luôn có ý nghĩa.

---

Đây cũng là lý do ở Khóa 4 bạn có thể:

```sql
JOIN
```

hai bảng lại với nhau một cách an toàn.

---

# 8. Mối quan hệ giữa các bảng

Ví dụ:

```text
departments

1  Data
2  Sales
3  Marketing
```

---

```text
employees

Nguyễn An → 1
Lê Chi    → 1
Trần Bình → 2
```

---

Quan hệ:

```text
Departments
      1
      |
      |
      N
Employees
```

Một phòng ban:

```text
1
```

có thể có nhiều nhân viên:

```text
N
```

Đây gọi là:

```text
One-to-Many Relationship
```

---

# 9. Tóm tắt kiến thức

## CREATE TABLE

```sql
CREATE TABLE ...
```

Tạo bảng.

---

## Data Types

```sql
INTEGER
NUMERIC
VARCHAR
TEXT
DATE
BOOLEAN
```

---

## Constraints

```sql
NOT NULL
UNIQUE
CHECK
DEFAULT
```

Dùng để đảm bảo dữ liệu sạch.

---

## PRIMARY KEY

```sql
PRIMARY KEY
```

Định danh duy nhất cho mỗi dòng.

---

## Composite Key

```sql
PRIMARY KEY (
    col1,
    col2
)
```

Dùng khi cần nhiều cột để định danh.

---

## FOREIGN KEY

```sql
REFERENCES other_table(id)
```

Liên kết các bảng với nhau.

---

## Referential Integrity

```text
Không cho phép tham chiếu tới dữ liệu không tồn tại.
```

---

# 🧪 Bài tập thực hành

## Bài 1

Viết `CREATE TABLE` cho bảng `products` gồm:

- `id` (khóa chính, tự tăng)
- `product_name` (bắt buộc có)
- `price` (phải lớn hơn 0)
- `sku` (không được trùng)

---

## Bài 2

Viết `CREATE TABLE` cho bảng `orders` gồm:

- `id` (khóa chính tự tăng)
- `product_id` (khóa ngoại)
- `quantity`
- `order_date`

Nếu không nhập:

```sql
order_date
```

thì mặc định:

```sql
CURRENT_DATE
```

---

## Bài 3

Giải thích:

Tại sao bảng:

```sql
enrollments
```

nên dùng:

```sql
PRIMARY KEY (
    student_id,
    course_id
)
```

thay vì chỉ dùng:

```sql
id SERIAL
```

---

## Bài 4

Tìm lỗi và sửa lại:

```sql
CREATE TABLE payments (
    id INTEGER,
    amount FLOAT,
    customer_email VARCHAR(255)
);
```

### Gợi ý

Có 2 vấn đề:

1. Kiểu dữ liệu
2. Thiếu ràng buộc

---

# 🎯 Mục tiêu sau Khóa 5

Bạn cần hiểu và sử dụng được:

```sql
CREATE TABLE
```

```sql
PRIMARY KEY
```

```sql
FOREIGN KEY
```

```sql
NOT NULL
```

```sql
UNIQUE
```

```sql
CHECK
```

```sql
DEFAULT
```

và hiểu khái niệm:

```text
Relational Database
```

cũng như:

```text
Referential Integrity
```

Đây là nền tảng để bước sang các chủ đề tiếp theo:

1. Database Design
2. Normalization
3. Data Modeling
4. Transaction & ACID
5. Data Warehousing