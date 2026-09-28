# Khóa 3: Intermediate Python for Developers

Tuần trước bạn đã nắm chắc biến, kiểu dữ liệu, if/elif, vòng lặp. Giờ mình học cách **tổ chức code** cho gọn và **tái sử dụng** — qua hàm (functions), module và package.

## 1. Hàm (Functions) — đóng gói logic để dùng lại

Nhớ lại Bài 5 khóa trước, bạn viết code đếm số người lương >= 20 triệu. Nếu mai bạn cần đếm lại với danh sách lương khác, bạn phải copy-paste cả đoạn code. Hàm giải quyết vấn đề này:

```python
def dem_luong_cao(salaries, nguong):
    count = 0
    for s in salaries:
        if s >= nguong:
            count += 1
    return count

ket_qua = dem_luong_cao([18000000, 25000000, 30000000], 20000000)
print(ket_qua)  # 2
```

👉 So sánh với SQL: hàm Python giống như một **user-defined function (UDF)** trong SQL — bạn định nghĩa 1 lần, gọi lại nhiều lần với input khác nhau.

### Cấu trúc

* `def tên_hàm(tham_số):` — khai báo hàm
* Thân hàm cũng thụt đầu dòng, giống `if`/`for`
* `return` — trả kết quả ra ngoài (nếu không có `return`, hàm trả về `None`)

---

## 2. Tham số mặc định (Default Parameters)

```python
def dem_luong_cao(salaries, nguong=20000000):
    count = 0
    for s in salaries:
        if s >= nguong:
            count += 1
    return count

print(dem_luong_cao([18000000, 25000000, 30000000]))
print(dem_luong_cao([18000000, 25000000, 30000000], 25000000))
```

👉 Giống việc SQL cho phép bạn đặt `DEFAULT` cho một cột — nếu người gọi không truyền giá trị, Python tự dùng giá trị mặc định.

---

## 3. Nhiều giá trị trả về (Multiple Return Values)

Python cho phép trả về nhiều giá trị cùng lúc bằng cách gói vào tuple:

```python
def thong_ke(salaries):
    tong = sum(salaries)
    trung_binh = tong / len(salaries)
    cao_nhat = max(salaries)
    return tong, trung_binh, cao_nhat

tong, tb, cao_nhat = thong_ke([18000000, 25000000, 30000000])
print(f"Tổng: {tong}, TB: {tb}, Cao nhất: {cao_nhat}")
```

👉 `sum()`, `max()`, `min()`, `len()` là các hàm dựng sẵn (built-in) của Python — không cần tự viết, dùng luôn.

---

## 4. Docstring — tự "document" hàm của bạn

```python
def dem_luong_cao(salaries, nguong=20000000):
    """
    Đếm số người có lương >= nguong.

    Params:
        salaries (list): danh sách lương
        nguong (int): mức lương tối thiểu, mặc định 20 triệu

    Returns:
        int: số người thỏa điều kiện
    """
    count = 0
    for s in salaries:
        if s >= nguong:
            count += 1
    return count
```

👉 Docstring không bắt buộc để code chạy, nhưng là thói quen chuyên nghiệp — nhất là khi làm việc nhóm hoặc quay lại đọc code cũ của chính mình sau vài tháng.

---

## 5. Module — 1 file Python có thể "import" vào file khác

Giả sử bạn lưu các hàm ở trên vào file `luong_utils.py`. Từ một file khác cùng thư mục, bạn dùng lại được ngay:

```python
# file: main.py
import luong_utils

ket_qua = luong_utils.dem_luong_cao(
    [18000000, 25000000, 30000000]
)
print(ket_qua)
```

Hoặc import riêng từng hàm cần dùng:

```python
from luong_utils import dem_luong_cao, thong_ke

ket_qua = dem_luong_cao(
    [18000000, 25000000, 30000000]
)
```

👉 Đây chính là lúc bạn thấy giá trị của hàm + docstring khóa trước — module giống như một **thư viện** bạn tự xây, dùng lại ở bất kỳ project nào.

---

## 6. Package — nhiều module gom vào 1 thư mục

```text
my_project/
│
├── analysis/
│   ├── __init__.py
│   ├── luong_utils.py
│   └── stress_utils.py
│
└── main.py
```

* Mỗi thư mục chứa `__init__.py` (có thể để trống) thì Python coi đó là một **package**.
* Import từ package:

```python
from analysis.luong_utils import dem_luong_cao
from analysis import stress_utils
```

👉 Bạn không cần tự tạo package thường xuyên lúc mới học, nhưng cần **hiểu** vì mọi thư viện bạn dùng (`pandas`, `requests`...) đều là package — `import pandas as pd` chính là import một package tên `pandas`.

---

## 7. `as` — đặt lại tên khi import (Alias)

```python
import pandas as pd
from luong_utils import dem_luong_cao as dem
```

👉 Quy ước phổ biến:

* `pandas as pd`
* `numpy as np`

Nên làm quen dần vì các khóa tiếp theo sẽ dùng liên tục.

---

# 🧪 Bài tập thực hành

## Bài 1

Viết hàm `phan_loai_stress(level)` nhận vào 1 số, trả về chuỗi:

* `"Cần chú ý"`
* `"Bình thường"`
* `"Ổn định"`

theo logic đã học ở Bài 3 khóa 2 (dùng `return` thay vì `print`).

---

## Bài 2

Viết hàm:

```python
loc_diem_dat(scores, diem_toi_thieu=50)
```

* Có tham số mặc định.
* Nhận vào 1 list điểm số.
* Trả về list các điểm >= `diem_toi_thieu`.

---

## Bài 3

Viết hàm:

```python
thong_ke_diem(scores)
```

Trả về đồng thời 3 giá trị:

* Điểm cao nhất
* Điểm thấp nhất
* Điểm trung bình

(dùng multiple return values).

---

## Bài 4

Viết docstring đầy đủ cho hàm ở Bài 3 (mô tả tham số và giá trị trả về).

---

## Bài 5 (Tổng hợp)

Tạo file `stress_utils.py` chứa hàm `phan_loai_stress` từ Bài 1.

Viết đoạn code (giả lập, không cần chạy thật 2 file) mô phỏng cách bạn import hàm đó từ một file khác và gọi nó với:

```python
level = 8
```
