# Khóa 2: Introduction to SQL

> **Mục tiêu:** Hiểu SQL và tự viết được các câu lệnh cơ bản để lấy đúng dữ liệu cần thiết từ Database.

---

## 1. Database & Table là gì?

Một **Database** giống như một cuốn sổ lớn, bên trong có nhiều **Table (bảng)**.

Mỗi bảng có thể hình dung giống như một sheet Excel, bao gồm:

- **Row (hàng):** Một bản ghi dữ liệu
- **Column (cột):** Một thuộc tính của dữ liệu

Ví dụ ta có bảng `employees`:

| id | name | department | salary | hire_date |
|---:|---|---|---:|---|
| 1 | Nguyễn An | Data | 25000000 | 2021-03-01 |
| 2 | Trần Bình | Sales | 18000000 | 2022-06-15 |
| 3 | Lê Chi | Data | 22000000 | 2023-01-10 |
| 4 | Phạm Dung | Marketing | 20000000 | 2020-11-20 |
| 5 | Hoàng Em | Data | 30000000 | 2019-05-05 |

### Thành phần của bảng

```text
employees
│
├── id
├── name
├── department
├── salary
└── hire_date
```

Ví dụ:

```text
id = 1
name = Nguyễn An
department = Data
salary = 25,000,000
hire_date = 2021-03-01
```

---

# 2. Câu lệnh SELECT — nền tảng của mọi truy vấn

`SELECT` dùng để chọn những cột dữ liệu mà bạn muốn lấy.

Cú pháp:

```sql
SELECT column1, column2
FROM table_name;
```

### Ví dụ

Lấy tên và lương của tất cả nhân viên:

```sql
SELECT name, salary
FROM employees;
```

Kết quả:

| name | salary |
|---|---:|
| Nguyễn An | 25000000 |
| Trần Bình | 18000000 |
| Lê Chi | 22000000 |
| Phạm Dung | 20000000 |
| Hoàng Em | 30000000 |

---

## Lấy toàn bộ cột

Muốn lấy **toàn bộ cột**, dùng dấu `*`:

```sql
SELECT *
FROM employees;
```

`*` có nghĩa là:

> Lấy tất cả các cột.

---

# 3. WHERE — lọc dữ liệu

`WHERE` dùng để lọc các dòng theo điều kiện.

Cú pháp:

```sql
SELECT column1, column2
FROM table_name
WHERE condition;
```

### Ví dụ

Lấy nhân viên thuộc phòng Data:

```sql
SELECT name, salary
FROM employees
WHERE department = 'Data';
```

Kết quả:

| name | salary |
|---|---:|
| Nguyễn An | 25000000 |
| Lê Chi | 22000000 |
| Hoàng Em | 30000000 |

---

## Các toán tử so sánh thường dùng

| Toán tử | Ý nghĩa | Ví dụ |
|---|---|---|
| `=` | Bằng | `WHERE department = 'Data'` |
| `>` | Lớn hơn | `WHERE salary > 20000000` |
| `<` | Nhỏ hơn | `WHERE salary < 20000000` |
| `>=` | Lớn hơn hoặc bằng | `WHERE salary >= 20000000` |
| `<=` | Nhỏ hơn hoặc bằng | `WHERE salary <= 20000000` |
| `!=` hoặc `<>` | Khác | `WHERE department != 'Sales'` |
| `AND` | Và | `WHERE department = 'Data' AND salary > 25000000` |
| `OR` | Hoặc | `WHERE department = 'Data' OR department = 'Sales'` |
| `BETWEEN` | Trong khoảng | `WHERE salary BETWEEN 20000000 AND 28000000` |

---

## Ví dụ với AND

Lấy nhân viên thuộc phòng Data và có lương trên 25 triệu:

```sql
SELECT name, salary
FROM employees
WHERE department = 'Data'
  AND salary > 25000000;
```

Kết quả:

```text
Hoàng Em - 30,000,000
```

---

## Ví dụ với OR

Lấy nhân viên thuộc phòng Marketing hoặc Sales:

```sql
SELECT name
FROM employees
WHERE department = 'Marketing'
   OR department = 'Sales';
```

Kết quả:

```text
Trần Bình
Phạm Dung
```

---

## Ví dụ với BETWEEN

Lấy nhân viên có lương từ 20 triệu đến 28 triệu:

```sql
SELECT name, salary
FROM employees
WHERE salary BETWEEN 20000000 AND 28000000;
```

> `BETWEEN` thường bao gồm cả hai giá trị ở đầu và cuối khoảng.

---

# 4. ORDER BY — sắp xếp dữ liệu

`ORDER BY` dùng để sắp xếp kết quả truy vấn.

Cú pháp:

```sql
SELECT column1, column2
FROM table_name
ORDER BY column_name;
```

### Sắp xếp tăng dần

```sql
SELECT name, salary
FROM employees
ORDER BY salary ASC;
```

`ASC` = Ascending = tăng dần.

### Sắp xếp giảm dần

```sql
SELECT name, salary
FROM employees
ORDER BY salary DESC;
```

`DESC` = Descending = giảm dần.

Ví dụ:

```sql
SELECT name, salary
FROM employees
ORDER BY salary DESC;
```

Kết quả:

| name | salary |
|---|---:|
| Hoàng Em | 30000000 |
| Nguyễn An | 25000000 |
| Lê Chi | 22000000 |
| Phạm Dung | 20000000 |
| Trần Bình | 18000000 |

> Nếu không ghi `ASC` hoặc `DESC`, mặc định thường là `ASC`.

---

# 5. LIMIT — giới hạn số dòng kết quả

`LIMIT` dùng để giới hạn số dòng trả về.

Ví dụ:

```sql
SELECT name, salary
FROM employees
ORDER BY salary DESC
LIMIT 3;
```

Ý nghĩa:

1. Sắp xếp nhân viên theo lương giảm dần
2. Chỉ lấy 3 dòng đầu tiên

Kết quả:

| name | salary |
|---|---:|
| Hoàng Em | 30000000 |
| Nguyễn An | 25000000 |
| Lê Chi | 22000000 |

Như vậy, câu lệnh trên dùng để lấy **3 người có lương cao nhất**.

---

# 6. Kết hợp SELECT + WHERE + ORDER BY + LIMIT

Trong thực tế, bạn sẽ thường kết hợp nhiều câu lệnh với nhau.

Ví dụ:

> Lấy 2 nhân viên phòng Data có lương cao nhất.

```sql
SELECT name, salary
FROM employees
WHERE department = 'Data'
ORDER BY salary DESC
LIMIT 2;
```

Kết quả:

| name | salary |
|---|---:|
| Hoàng Em | 30000000 |
| Nguyễn An | 25000000 |

---

# 7. Thứ tự viết một câu SQL cơ bản

Một câu SQL thường có dạng:

```sql
SELECT column
FROM table
WHERE condition
ORDER BY column
LIMIT number;
```

Ví dụ:

```sql
SELECT name, salary
FROM employees
WHERE salary > 20000000
ORDER BY salary DESC
LIMIT 3;
```

Có thể hiểu:

```text
SELECT
  ↓
Chọn cột nào?

FROM
  ↓
Lấy từ bảng nào?

WHERE
  ↓
Lọc dữ liệu nào?

ORDER BY
  ↓
Sắp xếp như thế nào?

LIMIT
  ↓
Lấy bao nhiêu dòng?
```

---

# 🧪 Bài tập thực hành

Dựa vào bảng `employees` ở trên, hãy tự viết câu lệnh SQL cho các yêu cầu sau.

## Bài 1

Lấy **tên và ngày vào làm (`hire_date`)** của tất cả nhân viên.

---

## Bài 2

Lấy **tên và lương** của những người có lương **trên 20 triệu**.

---

## Bài 3

Lấy **tên** của nhân viên phòng **Marketing hoặc Sales**.

---

## Bài 4

Sắp xếp tất cả nhân viên theo **ngày vào làm từ sớm nhất đến muộn nhất**.

---

## Bài 5

Lấy tên của **2 người có lương thấp nhất**.

---

# 🎯 Mục tiêu sau Khóa 2

Sau khi hoàn thành khóa này, bạn cần sử dụng được:

- `SELECT`
- `FROM`
- `WHERE`
- `AND`
- `OR`
- `BETWEEN`
- `ORDER BY`
- `ASC`
- `DESC`
- `LIMIT`

Và quan trọng nhất, bạn phải hiểu cách kết hợp chúng:

```sql
SELECT ...
FROM ...
WHERE ...
ORDER BY ...
LIMIT ...;
```

> **Bài tập:** Hãy tự viết 5 câu SQL ở phần trên. Sau đó gửi cho mình, mình sẽ kiểm tra từng câu và giải thích nếu có lỗi.
