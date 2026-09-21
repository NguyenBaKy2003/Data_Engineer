# Khóa 4: Joining Data in SQL

> **Mục tiêu:** Hiểu cách kết hợp dữ liệu từ nhiều bảng bằng `JOIN`, `UNION` và `Subquery`.
>
> Đây là một trong những kỹ năng quan trọng nhất của Data Engineer vì dữ liệu thực tế gần như luôn nằm ở nhiều bảng khác nhau.

---

# Dữ liệu thực hành

## Bảng `employees`

| id | name | department_id | salary |
|----|------|--------------:|--------:|
| 1 | Nguyễn An | 1 | 25000000 |
| 2 | Trần Bình | 2 | 18000000 |
| 3 | Lê Chi | 1 | 22000000 |
| 4 | Phạm Dung | 3 | 20000000 |
| 5 | Hoàng Em | 1 | 30000000 |
| 6 | Vũ Phong | NULL | 19000000 |

---

## Bảng `departments`

| id | dept_name | location |
|----|-----------|----------|
| 1 | Data | Hà Nội |
| 2 | Sales | TP.HCM |
| 3 | Marketing | Đà Nẵng |
| 4 | HR | Hà Nội |

---

## Chú ý

- Nhân viên **Vũ Phong** có `department_id = NULL` (chưa được gán phòng ban).
- Phòng ban **HR** (`id = 4`) chưa có nhân viên nào.

---

# 1. INNER JOIN

`INNER JOIN` chỉ lấy những dòng có dữ liệu khớp ở **cả hai bảng**.

## Cú pháp

```sql
SELECT columns
FROM table_a
INNER JOIN table_b
    ON condition;
```

---

## Ví dụ

```sql
SELECT
    e.name,
    e.salary,
    d.dept_name,
    d.location
FROM employees e
INNER JOIN departments d
    ON e.department_id = d.id;
```

### Kết quả

| name | salary | dept_name | location |
|--------|---------:|------------|----------|
| Nguyễn An | 25000000 | Data | Hà Nội |
| Trần Bình | 18000000 | Sales | TP.HCM |
| Lê Chi | 22000000 | Data | Hà Nội |
| Phạm Dung | 20000000 | Marketing | Đà Nẵng |
| Hoàng Em | 30000000 | Data | Hà Nội |

---

### Điều gì xảy ra?

```text
employees.department_id
          =
departments.id
```

SQL chỉ giữ lại những dòng tìm được giá trị khớp.

Do đó:

```text
Vũ Phong
department_id = NULL
```

không khớp với bất kỳ phòng ban nào nên bị loại bỏ.

Tương tự:

```text
HR
```

không có nhân viên nên cũng không xuất hiện.

---

# 2. Alias (Tên viết tắt)

Trong ví dụ trên:

```sql
employees e
departments d
```

`e` và `d` được gọi là **alias**.

Ví dụ:

```sql
SELECT e.name
FROM employees e;
```

thay vì:

```sql
SELECT employees.name
FROM employees;
```

Alias giúp câu lệnh ngắn gọn hơn và rất hữu ích khi JOIN nhiều bảng.

---

# 3. LEFT JOIN

`LEFT JOIN` giữ lại toàn bộ dữ liệu của bảng bên trái.

Nếu không tìm thấy dữ liệu khớp ở bảng bên phải thì điền:

```text
NULL
```

---

## Ví dụ

```sql
SELECT
    e.name,
    d.dept_name
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.id;
```

### Kết quả

| name | dept_name |
|--------|-----------|
| Nguyễn An | Data |
| Trần Bình | Sales |
| Lê Chi | Data |
| Phạm Dung | Marketing |
| Hoàng Em | Data |
| Vũ Phong | NULL |

---

### Hình dung trực quan

```text
INNER JOIN

Employees ∩ Departments
```

Chỉ lấy phần giao nhau.

---

```text
LEFT JOIN

Employees
+ phần giao với Departments
```

Lấy toàn bộ bảng bên trái.

---

# 4. RIGHT JOIN

Ngược lại với LEFT JOIN.

```sql
SELECT *
FROM employees e
RIGHT JOIN departments d
    ON e.department_id = d.id;
```

Kết quả sẽ giữ lại toàn bộ phòng ban.

---

### Thực tế

Nhiều công ty hầu như không dùng:

```sql
RIGHT JOIN
```

vì có thể viết lại bằng:

```sql
LEFT JOIN
```

chỉ cần đổi thứ tự bảng.

---

# 5. FULL OUTER JOIN

Giữ lại toàn bộ dữ liệu của cả hai bảng.

```sql
SELECT *
FROM employees e
FULL OUTER JOIN departments d
    ON e.department_id = d.id;
```

Kết quả sẽ bao gồm:

- Nhân viên chưa có phòng ban
- Phòng ban chưa có nhân viên

---

# 6. So sánh các loại JOIN

| JOIN | Giữ bảng trái | Giữ bảng phải | Chỉ phần khớp |
|--------|--------------|---------------|---------------|
| INNER JOIN | ❌ | ❌ | ✅ |
| LEFT JOIN | ✅ | ❌ | ✅ |
| RIGHT JOIN | ❌ | ✅ | ✅ |
| FULL JOIN | ✅ | ✅ | ✅ |

---

# 7. UNION

`JOIN` ghép dữ liệu theo chiều ngang (cột).

`UNION` ghép dữ liệu theo chiều dọc (dòng).

---

## Ví dụ

```sql
SELECT name
FROM employees
WHERE department_id = 1

UNION

SELECT dept_name
FROM departments;
```

Kết quả:

```text
Nguyễn An
Lê Chi
Hoàng Em
Data
Sales
Marketing
HR
```

---

## Điều kiện dùng UNION

Hai câu SELECT phải có:

### Cùng số cột

```sql
SELECT name
UNION
SELECT dept_name
```

✅ Đúng

---

```sql
SELECT name, salary
UNION
SELECT dept_name
```

❌ Sai

---

### Cùng kiểu dữ liệu

Ví dụ:

```sql
VARCHAR
UNION
VARCHAR
```

✅

---

# 8. UNION vs UNION ALL

## UNION

```sql
UNION
```

Tự động loại bỏ dòng trùng lặp.

---

## UNION ALL

```sql
UNION ALL
```

Giữ nguyên mọi dòng.

Ưu điểm:

```text
Nhanh hơn
```

vì SQL không cần kiểm tra dữ liệu trùng.

---

# 9. Subquery

Subquery là một câu SQL nằm bên trong một câu SQL khác.

---

## Ví dụ

Lấy nhân viên làm việc tại các phòng ban ở Hà Nội:

```sql
SELECT
    name,
    salary
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE location = 'Hà Nội'
);
```

---

### SQL xử lý như thế nào?

Bước 1:

```sql
SELECT id
FROM departments
WHERE location = 'Hà Nội';
```

Kết quả:

```text
1
4
```

---

Bước 2:

SQL thay vào:

```sql
SELECT
    name,
    salary
FROM employees
WHERE department_id IN (1,4);
```

Kết quả:

```text
Nguyễn An
Lê Chi
Hoàng Em
```

---

# 10. JOIN hay Subquery?

Nhiều bài toán có thể giải bằng cả hai cách.

---

## JOIN

```sql
SELECT
    e.name,
    d.location
FROM employees e
JOIN departments d
    ON e.department_id = d.id;
```

Ưu điểm:

- Dễ lấy nhiều cột
- Thường rõ ràng hơn

---

## Subquery

```sql
SELECT name
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE location = 'Hà Nội'
);
```

Ưu điểm:

- Ngắn gọn khi chỉ cần điều kiện lọc

---

# 11. Tóm tắt

### INNER JOIN

```sql
SELECT *
FROM A
INNER JOIN B
ON ...
```

Chỉ lấy dữ liệu khớp.

---

### LEFT JOIN

```sql
SELECT *
FROM A
LEFT JOIN B
ON ...
```

Giữ toàn bộ bảng bên trái.

---

### UNION

```sql
SELECT ...
UNION
SELECT ...
```

Ghép dòng.

---

### UNION ALL

```sql
SELECT ...
UNION ALL
SELECT ...
```

Ghép dòng và giữ trùng lặp.

---

### Subquery

```sql
SELECT ...
WHERE column IN (
    SELECT ...
)
```

Truy vấn lồng nhau.

---

# 🧪 Bài tập thực hành

## Bài 1

Viết `INNER JOIN` để lấy:

- Tên nhân viên
- Lương
- Địa điểm làm việc (`location`)

---

## Bài 2

Viết `LEFT JOIN` để liệt kê:

- Tất cả phòng ban
- Tên nhân viên

Dùng bảng `departments` làm bảng bên trái.

Phòng nào chưa có nhân viên thì tên nhân viên hiển thị:

```text
NULL
```

---

## Bài 3

Dùng Subquery:

Lấy tên các nhân viên có lương cao hơn mức lương trung bình toàn công ty.

---

## Bài 4

Dùng Subquery:

Lấy tên các phòng ban chưa có nhân viên nào.

Gợi ý:

```sql
NOT IN
```

---

## Bài 5 (Khó hơn)

Dùng:

```sql
LEFT JOIN
GROUP BY
COUNT()
```

Đếm số lượng nhân viên trong từng phòng ban.

Yêu cầu:

- Phòng chưa có nhân viên vẫn phải xuất hiện.
- Kết quả hiển thị:

```text
HR → 0
```

Gợi ý:

```sql
COUNT(e.id)
```

thay vì:

```sql
COUNT(*)
```

---

# 🎯 Mục tiêu sau Khóa 4

Bạn cần sử dụng được:

```sql
INNER JOIN
LEFT JOIN
RIGHT JOIN
FULL JOIN
UNION
UNION ALL
SUBQUERY
```

Và hiểu rõ:

```text
JOIN   → Ghép cột
UNION  → Ghép dòng
```

Sau khóa này, bạn đã có nền tảng SQL đủ mạnh để học:

1. Advanced SQL
2. Window Functions
3. CTE (Common Table Expressions)
4. Data Modeling
5. ETL Pipelines