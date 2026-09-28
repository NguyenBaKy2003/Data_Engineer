# Khóa 4: Introduction to Importing Data in Python

Giờ bạn học cách đưa dữ liệu từ bên ngoài (file Excel, CSV, database, file SAS...) vào Python để xử lý — đây là bước đầu tiên của mọi pipeline dữ liệu thực tế.

---

## 1. Đọc file văn bản thô (flat file) bằng Python thuần

```python
# Cách cơ bản nhất, không cần thư viện gì
with open("data.txt", "r") as file:
    content = file.read()
    print(content)
```

`with open(...) as file:` là cách chuẩn để mở file — tự động đóng file sau khi dùng xong, kể cả khi có lỗi xảy ra giữa chừng. Đây là thói quen quan trọng: không dùng `with` thì dễ quên đóng file, gây rò rỉ tài nguyên (*resource leak*).

### Đọc từng dòng

```python
with open("data.txt", "r") as file:
    for line in file:
        print(line.strip())   # strip() bỏ ký tự xuống dòng \n thừa
```

---

## 2. Đọc file CSV — cách phổ biến nhất trong Data Engineering

```python
import csv

with open("employees.csv", "r") as file:
    reader = csv.reader(file)
    header = next(reader)   # lấy dòng đầu tiên (tên cột)
    print(header)

    for row in reader:
        print(row)   # mỗi row là 1 list, ví dụ ['1', 'Nguyễn An', '25000000']
```

👉 **Lưu ý quan trọng:** `csv.reader` đọc mọi giá trị đều là chuỗi (`str`), kể cả cột số như lương — bạn phải tự chuyển đổi (`int()`, `float()`) nếu muốn tính toán.

---

## 3. NumPy — nền tảng cho pandas sắp học

```python
import numpy as np

salaries = np.array([18000000, 25000000, 30000000])

print(salaries.mean())   # tính trung bình cực nhanh, không cần viết vòng lặp
print(salaries.max())
print(salaries[salaries > 20000000])   # lọc trực tiếp, không cần for + if
```

👉 So với list Python thuần (Khóa 2–3, phải viết `for` + `if` để lọc), NumPy cho phép lọc trực tiếp bằng biểu thức điều kiện — đây gọi là **vectorization**, nhanh hơn rất nhiều với dữ liệu lớn.

Đây chính là nền tảng mà **pandas** (học ngay sau đây) được xây dựng dựa trên.

---

## 4. Đọc file Excel

```python
import pandas as pd

df = pd.read_excel("employees.xlsx")

print(df.head())      # xem 5 dòng đầu
print(df.columns)     # xem tên các cột
```

### Chỉ định sheet cụ thể nếu file có nhiều sheet

```python
df = pd.read_excel("employees.xlsx", sheet_name="Sheet2")
```

---

## 5. Đọc file SAS/Stata

(Định dạng thường gặp trong dữ liệu doanh nghiệp/nghiên cứu)

```python
import pandas as pd

df_sas = pd.read_sas("data.sas7bdat")
df_stata = pd.read_stata("data.dta")
```

👉 Bạn không cần nhớ chi tiết cú pháp riêng của từng định dạng — điểm mấu chốt cần nắm là pandas có một hàm `read_xxx()` tương ứng cho hầu hết mọi định dạng phổ biến, và tất cả đều trả về cùng một cấu trúc: **DataFrame**.

---

## 6. Kết nối và truy vấn database từ Python — chỗ SQL và Python gặp nhau

Đây là phần quan trọng nhất khóa này với vai trò Data Engineer — dùng lại chính kiến thức SQL bạn đã học nhưng gọi từ Python:

```python
from sqlalchemy import create_engine
import pandas as pd

# Tạo kết nối tới database PostgreSQL
engine = create_engine(
    "postgresql://username:password@localhost:5432/mydatabase"
)

# Chạy câu SQL, kết quả trả về trực tiếp thành DataFrame
query = """
SELECT name, salary
FROM employees
WHERE salary > 20000000
"""

df = pd.read_sql(query, engine)

print(df)
```

👉 Đây chính là điểm nối giữa 2 track bạn đã và đang học:

- `create_engine()` mở kết nối tới database (PostgreSQL, Snowflake, ...)
- Câu lệnh trong biến `query` chính là SQL thuần túy bạn đã thành thạo

Không có gì mới ở phần SQL cả, chỉ là giờ bạn gọi nó từ Python để tiện xử lý tiếp bằng pandas/NumPy sau đó.

---

# 🧪 Bài tập thực hành

## Bài 1

Giả sử bạn có:

```python
raw_lines = [
    "1,Nguyễn An,25000000",
    "2,Trần Bình,18000000",
    "3,Lê Chi,22000000"
]
```

(Mô phỏng nội dung đọc được từ file CSV, mỗi phần tử là 1 dòng).

**Yêu cầu:**

Viết vòng lặp `for`, tách từng dòng bằng `.split(",")`, in ra tên và lương (đã chuyển sang `int`) của từng người.

---

## Bài 2

Cho mảng NumPy:

```python
scores = np.array([85, 42, 90, 55, 78, 30])
```

**Yêu cầu:**

Không dùng vòng lặp `for`, chỉ dùng biểu thức lọc kiểu NumPy, tạo ra mảng `passed` chỉ chứa điểm `>= 50`.

(Đây chính là "phiên bản NumPy" của Bài 4 Khóa 2, nhưng gọn hơn nhiều.)

---

## Bài 3

Viết đoạn code (giả lập, không cần file thật) mở file `report.txt`, đọc từng dòng, chỉ in ra những dòng có chứa chữ `"error"`.

**Gợi ý:**

```python
if "error" in line:
```

---

## Bài 4 (Lý thuyết ngắn)

Giải thích bằng lời:

Vì sao khi dùng `csv.reader` đọc file CSV, cột lương dù chứa số vẫn cần `int()` hoặc `float()` để chuyển đổi trước khi tính toán?

---

## Bài 5 (Tổng hợp)

Viết đoạn code giả lập dùng `sqlalchemy` + `pandas` để kết nối tới 1 database PostgreSQL tên `company_db`, lấy toàn bộ nhân viên phòng `"Data"` (nhớ lại cú pháp `WHERE` ở track SQL), rồi in ra 5 dòng đầu bằng `.head()`.

---