# Khóa 7: Cleaning Data in Python

Nhớ lại Khóa 1: bước **Transform** trong ETL chủ yếu là làm sạch dữ liệu. Ở track SQL, bạn chặn dữ liệu bẩn ngay từ thiết kế bảng (`NOT NULL`, `CHECK`, `UNIQUE`). Nhưng dữ liệu từ file CSV, Excel hay API bên ngoài thì bạn không kiểm soát được, nên phải tự làm sạch bằng **pandas**. Đây là kỹ năng chiếm phần lớn thời gian của một Data Engineer. :contentReference[oaicite:0]{index=0}

Toàn bộ ví dụ dùng chung bộ dữ liệu bẩn dưới đây, bạn chạy thử được ngay: :contentReference[oaicite:1]{index=1}

```python
import pandas as pd
import numpy as np

df = pd.DataFrame({
    "id":         [1, 2, 3, 3, 4, 5],
    "name":       [" Nguyen An", "tran binh", "LE CHI", "LE CHI", "Pham Dung", None],
    "salary":     ["25000000", "18000000", "22,000,000", "22,000,000", "abc", "30000000"],
    "department": ["Data", "data", "DATA ", "DATA ", "Sales", "Marketing"],
    "hire_date":  ["2021-03-01", "2022-06-15", "2023-01-10", "2023-01-10", "2020-11-20", "2019-05-05"],
    "age":        [28, 31, 25, 25, 250, 40],
})
```

Nhìn kỹ sẽ thấy nhiều lỗi:

- Tên viết hoa/lowercase không nhất quán
- Lương chứa dấu phẩy và chuỗi `"abc"`
- Phòng ban `"Data"`, `"data"`, `"DATA "` là cùng một giá trị nhưng được lưu khác nhau
- Có dòng trùng lặp
- Tuổi `250` bất hợp lý
- Có tên bị thiếu (`None`) :contentReference[oaicite:2]{index=2}

---

## 1. Khám phá dữ liệu trước khi làm sạch

Không bao giờ sửa dữ liệu khi chưa xem nó. Bốn lệnh đầu tiên nên chạy là: :contentReference[oaicite:3]{index=3}

```python
print(df.head())            # xem vài dòng đầu
print(df.info())            # kiểu dữ liệu từng cột + số giá trị không null
print(df.describe())        # thống kê các cột số
print(df.isna().sum())      # đếm số giá trị thiếu
```

### Kiểm tra cột danh mục

```python
print(df["department"].value_counts())
```

`value_counts()` tương tự:

```sql
GROUP BY department
COUNT(*)
```

và giúp phát hiện các giá trị không nhất quán như:

```text
Data
data
DATA
```

:contentReference[oaicite:4]{index=4}

---

## 2. Lỗi kiểu dữ liệu (Data Type Problems)

### Chuyển salary từ chuỗi sang số

```python
# Bỏ dấu phẩy
df["salary"] = df["salary"].str.replace(",", "")

# Chuyển sang số
df["salary"] = pd.to_numeric(
    df["salary"],
    errors="coerce"
)
```

Giá trị `"abc"` sẽ trở thành:

```python
NaN
```

:contentReference[oaicite:5]{index=5}

### Các lựa chọn của `errors`

| Giá trị | Hành vi |
|----------|----------|
| `"raise"` | Báo lỗi và dừng chương trình |
| `"coerce"` | Chuyển thành `NaN` |
| `"ignore"` | Giữ nguyên dữ liệu |

Thông thường:

```python
errors="coerce"
```

được dùng nhiều nhất trong ETL.

### Chuyển ngày tháng

```python
df["hire_date"] = pd.to_datetime(
    df["hire_date"]
)
```

Sau đó có thể truy cập:

```python
df["hire_date"].dt.year
df["hire_date"].dt.month
```

:contentReference[oaicite:6]{index=6}

### Chuyển sang kiểu category

```python
df["department"] = (
    df["department"]
    .astype("category")
)
```

Giúp giảm bộ nhớ cho các cột có ít giá trị lặp lại. :contentReference[oaicite:7]{index=7}

---

## 3. Giá trị ngoài phạm vi (Range Problems)

Ví dụ tuổi:

```python
250
```

là không hợp lý. Có ba cách xử lý: :contentReference[oaicite:8]{index=8}

### Cách 1: Xóa

```python
df = df[df["age"] <= 100]
```

### Cách 2: Gán NaN

```python
df.loc[
    df["age"] > 100,
    "age"
] = np.nan
```

### Cách 3: Giới hạn giá trị

```python
df["age"] = (
    df["age"]
    .clip(upper=100)
)
```

👉 Với dữ liệu thực tế, gán `NaN` thường hợp lý hơn vì không biết giá trị thật.

---

## 4. Dữ liệu trùng lặp (Duplicates)

### Kiểm tra

```python
print(df.duplicated())
print(df.duplicated().sum())
```

### Xóa dòng trùng hoàn toàn

```python
df = df.drop_duplicates()
```

### Xóa theo khóa

```python
df = df.drop_duplicates(
    subset=["id"],
    keep="first"
)
```

:contentReference[oaicite:9]{index=9}

### Gộp dữ liệu trùng bằng groupby

```python
df = (
    df.groupby(
        "id",
        as_index=False
    )
    .agg({
        "salary": "max",
        "name": "first"
    })
)
```

:contentReference[oaicite:10]{index=10}

---

## 5. Dữ liệu thiếu (Missing Data)

Sau khi dùng:

```python
errors="coerce"
```

một số giá trị sẽ thành `NaN`.

### Xóa dòng

```python
df = df.dropna(
    subset=["name"]
)
```

### Điền giá trị cố định

```python
df["name"] = (
    df["name"]
    .fillna("Không rõ")
)
```

### Điền bằng thống kê

```python
df["salary"] = (
    df["salary"]
    .fillna(
        df["salary"].median()
    )
)
```

:contentReference[oaicite:11]{index=11}

### Nguyên tắc lựa chọn

- `id`, `email` thiếu → thường xóa dòng
- Cột số → dùng trung vị
- Cột văn bản → `"Không rõ"`

:contentReference[oaicite:12]{index=12}

---

## 6. Dữ liệu văn bản và danh mục

### Chuẩn hóa department

```python
df["department"] = (
    df["department"]
    .str.strip()
    .str.lower()
)
```

Kết quả:

```text
data
sales
marketing
```

:contentReference[oaicite:13]{index=13}

### Các hàm chuỗi quan trọng

| Hàm | Tác dụng |
|------|----------|
| `.str.strip()` | Xóa khoảng trắng |
| `.str.lower()` | Chữ thường |
| `.str.upper()` | Chữ hoa |
| `.str.title()` | Viết hoa đầu từ |
| `.str.replace()` | Thay thế |
| `.str.contains()` | Tìm chuỗi |
| `.str.len()` | Độ dài |

:contentReference[oaicite:14]{index=14}

### Chuẩn hóa name

```python
df["name"] = (
    df["name"]
    .str.strip()
    .str.title()
)
```

Ví dụ:

```text
" Nguyen An" → "Nguyen An"
"tran binh" → "Tran Binh"
"LE CHI"     → "Le Chi"
```

:contentReference[oaicite:15]{index=15}

### Mapping danh mục

```python
mapping = {
    "hn": "Hanoi",
    "ha noi": "Hanoi",
    "hanoi": "Hanoi"
}

df["city"] = (
    df["city"]
    .str.lower()
    .map(mapping)
)
```

:contentReference[oaicite:16]{index=16}

---

## 7. Kiểm tra chéo giữa các cột

Ví dụ:

- Ngày vào làm không được nằm trong tương lai.
- Người 20 tuổi không thể có 25 năm kinh nghiệm.

```python
today = pd.Timestamp.today()

loi = df[
    df["hire_date"] > today
]

print(
    f"Có {len(loi)} dòng ngày vào làm không hợp lệ"
)
```

:contentReference[oaicite:17]{index=17}

---

## 8. Record Linkage (Fuzzy Matching)

Khác với `JOIN`, record linkage ghép các chuỗi gần giống nhau. :contentReference[oaicite:18]{index=18}

### Ví dụ

```python
from difflib import SequenceMatcher

def do_giong(a, b):
    return SequenceMatcher(
        None,
        a.lower(),
        b.lower()
    ).ratio()

print(do_giong("Vinamilk", "Vina Milk"))
print(do_giong("FPT Software", "FPT Softwre"))
```

:contentReference[oaicite:19]{index=19}

### Quy trình

1. So sánh bản ghi A với B.
2. Chọn kết quả giống nhất.
3. Chỉ chấp nhận nếu điểm vượt ngưỡng (ví dụ `0.85`). :contentReference[oaicite:20]{index=20}

```python
ds_a = ["Vinamilk", "FPT Software"]
ds_b = ["Vina Milk", "FPT Softwre", "Viettel"]

for a in ds_a:
    tot_nhat = max(
        ds_b,
        key=lambda b: do_giong(a, b)
    )

    diem = do_giong(a, tot_nhat)

    if diem >= 0.85:
        print(
            f"{a} <-> {tot_nhat} "
            f"(giống {diem:.2f})"
        )
    else:
        print(
            f"{a}: không tìm thấy bản ghi khớp"
        )
```

:contentReference[oaicite:21]{index=21}

---

## 9. Thứ tự làm sạch điển hình

Khi gặp bộ dữ liệu mới: :contentReference[oaicite:22]{index=22}

1. Khám phá dữ liệu
   - `info()`
   - `describe()`
   - `isna().sum()`
   - `value_counts()`

2. Sửa kiểu dữ liệu
   - `to_numeric`
   - `to_datetime`
   - `astype`

3. Chuẩn hóa văn bản
   - `strip`
   - `lower`
   - `map`

4. Xử lý giá trị ngoài phạm vi

5. Xử lý trùng lặp

6. Xử lý dữ liệu thiếu

7. Kiểm tra lại bằng:
   - `info()`
   - `describe()`

---

# 🧪 Bài tập thực hành

Sử dụng bộ dữ liệu sau: :contentReference[oaicite:23]{index=23}

```python
import pandas as pd
import numpy as np

df = pd.DataFrame({
    "order_id": [101, 102, 103, 103, 104, 105, 106],
    "customer": [" an nguyen", "BINH TRAN", "chi le", "chi le", "Dung Pham ", None, "em hoang"],
    "amount":   ["500,000", "1200000", "abc", "abc", "750000", "300000", "-50000"],
    "city":     ["HN", "Ha Noi", "hanoi", "hanoi", "HCM", "Hcm", "hn"],
    "order_date": ["2024-01-15", "2024-02-20", "2024-03-05", "2024-03-05", "2024-04-10", "2024-05-01", "2099-12-31"],
})
```

### Bài 1 (Khám phá)

- Chạy `df.info()`
- Chạy `df.isna().sum()`
- Ghi nhận:
  - Cột nào sai kiểu dữ liệu?
  - Cột nào có giá trị thiếu?

### Bài 2 (Kiểu dữ liệu)

- Làm sạch `amount`
- Chuyển sang số bằng `to_numeric(errors="coerce")`
- Chuyển `order_date` sang `datetime`
- In `df.dtypes`

### Bài 3 (Văn bản và danh mục)

- Chuẩn hóa `customer`
- Chuẩn hóa `city` chỉ còn:
  - `"Hanoi"`
  - `"HCM"`
- In `value_counts()`

### Bài 4 (Trùng lặp, thiếu, ngoài phạm vi)

- Xóa trùng theo `order_id`
- Gán `amount <= 0` thành `NaN`
- Điền `NaN` bằng trung vị
- Xóa dòng thiếu `customer`

### Bài 5 (Tổng hợp)

- Tìm đơn hàng có ngày trong tương lai
- Viết hàm:

```python
def lam_sach_don_hang(df):
    """
    Nhận DataFrame thô và trả về DataFrame đã làm sạch.
    """
```

Gộp toàn bộ bước ở Bài 2, 3 và 4 vào một hàm hoàn chỉnh. :contentReference[oaicite:24]{index=24}