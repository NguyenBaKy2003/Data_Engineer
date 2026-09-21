# Khóa 3: Intermediate SQL

> **Mục tiêu:** Học cách tổng hợp dữ liệu bằng các hàm Aggregate, `GROUP BY`, `HAVING` và `CASE WHEN`.
>
> Đây là nhóm kỹ năng được sử dụng rất nhiều trong công việc Data Engineer, Data Analyst và Data Scientist.

---

## Dữ liệu thực hành

Tiếp tục sử dụng bảng `employees`, lần này bổ sung thêm dữ liệu:

| id | name | department | salary | hire_date |
|----|------|------------|---------:|------------|
| 1 | Nguyễn An | Data | 25000000 | 2021-03-01 |
| 2 | Trần Bình | Sales | 18000000 | 2022-06-15 |
| 3 | Lê Chi | Data | 22000000 | 2023-01-10 |
| 4 | Phạm Dung | Marketing | 20000000 | 2020-11-20 |
| 5 | Hoàng Em | Data | 30000000 | 2019-05-05 |
| 6 | Vũ Phong | Sales | 19000000 | 2021-08-01 |
| 7 | Đỗ Giang | Marketing | 21000000 | 2022-02-14 |

---

# 1. Hàm tổng hợp (Aggregate Functions)

Aggregate Functions dùng để tính toán trên nhiều dòng dữ liệu và trả về một giá trị tổng hợp.

| Hàm | Ý nghĩa |
|------|----------|
| `COUNT(*)` | Đếm số dòng |
| `SUM(column)` | Tính tổng |
| `AVG(column)` | Tính trung bình |
| `MIN(column)` | Giá trị nhỏ nhất |
| `MAX(column)` | Giá trị lớn nhất |

### Ví dụ

```sql
SELECT COUNT(*)
FROM employees;
```

Kết quả:

```text
7
```

Đếm tổng số nhân viên.

---

```sql
SELECT AVG(salary)
FROM employees;
```

Kết quả:

```text
22142857
```

Lương trung bình toàn công ty.

---

```sql
SELECT SUM(salary)
FROM employees;
```

Tính tổng lương toàn công ty.

---

```sql
SELECT MIN(salary), MAX(salary)
FROM employees;
```

Lấy lương thấp nhất và cao nhất.

---

# 2. GROUP BY — Tổng hợp theo nhóm

Đây là phần quan trọng nhất của khóa này.

`GROUP BY` dùng để gom các dòng có cùng giá trị thành một nhóm rồi áp dụng hàm tổng hợp lên từng nhóm.

Ví dụ:

```sql
SELECT department,
       AVG(salary) AS avg_salary
FROM employees
GROUP BY department;
```

Kết quả:

| department | avg_salary |
|------------|------------:|
| Data | 25666667 |
| Sales | 18500000 |
| Marketing | 20500000 |

### Cách hiểu trực quan

```text
Data
├── Nguyễn An      25,000,000
├── Lê Chi         22,000,000
└── Hoàng Em       30,000,000

AVG = 25,666,667
```

```text
Sales
├── Trần Bình      18,000,000
└── Vũ Phong       19,000,000

AVG = 18,500,000
```

```text
Marketing
├── Phạm Dung      20,000,000
└── Đỗ Giang       21,000,000

AVG = 20,500,000
```

---

## Quy tắc quan trọng

Trong `SELECT`, mọi cột **không nằm trong hàm tổng hợp** phải xuất hiện trong `GROUP BY`.

### Đúng

```sql
SELECT department,
       AVG(salary)
FROM employees
GROUP BY department;
```

### Sai

```sql
-- ❌ Sai
SELECT department,
       name,
       AVG(salary)
FROM employees
GROUP BY department;
```

Lý do:

Một phòng ban có nhiều nhân viên.

Ví dụ:

```text
Data
├── Nguyễn An
├── Lê Chi
└── Hoàng Em
```

SQL không biết phải lấy `name` nào để đại diện cho nhóm `Data`.

---

# 3. HAVING — Lọc sau khi GROUP BY

Điểm khác biệt:

| WHERE | HAVING |
|---------|---------|
| Lọc dữ liệu gốc | Lọc kết quả sau khi tổng hợp |
| Chạy trước GROUP BY | Chạy sau GROUP BY |
| Không dùng Aggregate Function | Có thể dùng Aggregate Function |

---

### Ví dụ

Lấy những phòng ban có lương trung bình trên 20 triệu:

```sql
SELECT department,
       AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 20000000;
```

Kết quả:

| department | avg_salary |
|------------|------------:|
| Data | 25666667 |
| Marketing | 20500000 |

---

### WHERE vs HAVING

#### WHERE

```sql
SELECT *
FROM employees
WHERE salary > 20000000;
```

Lọc từng nhân viên.

---

#### HAVING

```sql
SELECT department,
       AVG(salary)
FROM employees
GROUP BY department
HAVING AVG(salary) > 20000000;
```

Lọc từng nhóm.

---

### Thứ tự xử lý

```text
WHERE
  ↓
GROUP BY
  ↓
Aggregate Functions
  ↓
HAVING
```

---

# 4. CASE WHEN — Logic điều kiện

`CASE WHEN` tương tự:

```text
if
elif
else
```

trong lập trình.

Cú pháp:

```sql
CASE
    WHEN condition THEN result
    WHEN condition THEN result
    ELSE result
END
```

---

### Ví dụ: Phân loại mức lương

```sql
SELECT
    name,
    salary,
    CASE
        WHEN salary >= 25000000 THEN 'Cao'
        WHEN salary >= 20000000 THEN 'Trung bình'
        ELSE 'Thấp'
    END AS salary_level
FROM employees;
```

Kết quả:

| name | salary | salary_level |
|------|---------:|-------------|
| Nguyễn An | 25000000 | Cao |
| Trần Bình | 18000000 | Thấp |
| Lê Chi | 22000000 | Trung bình |
| Phạm Dung | 20000000 | Trung bình |
| Hoàng Em | 30000000 | Cao |
| Vũ Phong | 19000000 | Thấp |
| Đỗ Giang | 21000000 | Trung bình |

---

## CASE WHEN hoạt động như thế nào?

SQL kiểm tra điều kiện từ trên xuống.

Ví dụ:

```sql
CASE
    WHEN salary >= 25000000 THEN 'Cao'
    WHEN salary >= 20000000 THEN 'Trung bình'
    ELSE 'Thấp'
END
```

Nếu:

```text
salary = 30000000
```

SQL gặp điều kiện đầu tiên đúng nên trả về:

```text
Cao
```

và dừng lại.

---

# 5. Kết hợp GROUP BY + HAVING + ORDER BY

Ví dụ:

> Lấy các phòng ban có lương trung bình trên 19 triệu và sắp xếp giảm dần.

```sql
SELECT
    department,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 19000000
ORDER BY avg_salary DESC;
```

Kết quả:

| department | avg_salary |
|------------|------------:|
| Data | 25666667 |
| Marketing | 20500000 |

---

# 6. Thứ tự logic xử lý SQL

Ví dụ:

```sql
SELECT department,
       AVG(salary) AS avg_salary
FROM employees
WHERE salary > 18000000
GROUP BY department
HAVING AVG(salary) > 20000000
ORDER BY avg_salary DESC;
```

SQL xử lý theo thứ tự:

```text
FROM
  ↓
WHERE
  ↓
GROUP BY
  ↓
Aggregate Functions
  ↓
HAVING
  ↓
SELECT
  ↓
ORDER BY
```

Đây là kiến thức rất quan trọng khi học SQL nâng cao.

---

# 🧪 Bài tập thực hành

## Bài 1

Đếm số lượng nhân viên trong mỗi phòng ban.

---

## Bài 2

Tính tổng lương (`SUM`) của toàn công ty.

---

## Bài 3

Lấy ra các phòng ban có từ 2 nhân viên trở lên.

Gợi ý:

```sql
COUNT(*)
GROUP BY department
HAVING ...
```

---

## Bài 4

Viết `CASE WHEN` phân loại nhân viên thành:

- `'Cũ'`: vào làm trước năm 2021
- `'Mới'`: từ năm 2021 trở đi

Dựa trên `hire_date`.

---

## Bài 5 (Tổng hợp)

Lấy:

- Tên phòng ban
- Lương trung bình

Chỉ hiển thị những phòng ban có:

```text
Lương trung bình > 19 triệu
```

Sau đó:

- Sắp xếp theo lương trung bình giảm dần.

---

# 🎯 Mục tiêu sau Khóa 3

Bạn cần sử dụng thành thạo:

### Aggregate Functions

```sql
COUNT()
SUM()
AVG()
MIN()
MAX()
```

### GROUP BY

```sql
GROUP BY department
```

### HAVING

```sql
HAVING AVG(salary) > 20000000
```

### CASE WHEN

```sql
CASE
    WHEN condition THEN result
    ELSE result
END
```

### Kết hợp đầy đủ

```sql
SELECT ...
FROM ...
WHERE ...
GROUP BY ...
HAVING ...
ORDER BY ...
LIMIT ...;
```

> Sau khi hoàn thành khóa này, bạn đã có nền tảng SQL đủ tốt để bước sang các chủ đề nâng cao như JOIN, Subquery, Window Functions và Data Modeling.