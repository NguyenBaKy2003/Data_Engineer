# Khóa 2: Introduction to Python for Developers

Bắt đầu code Python thật sự! Không cần biết trước gì cả — khóa học này đi từ những khái niệm cơ bản nhất và liên hệ trực tiếp với những gì bạn đã học trong track SQL.

---

## 1. Biến (Variables) — nơi lưu trữ giá trị

```python
name = "Nguyễn An"
age = 25
salary = 25000000.50
is_active = True
```

Khác với SQL (nơi bạn khai báo kiểu dữ liệu rõ ràng như `VARCHAR`, `INTEGER`), Python **tự động nhận diện kiểu dữ liệu** dựa trên giá trị được gán. Đây được gọi là **Dynamic Typing**.

```python
print(name)        # Nguyễn An
print(type(name))  # <class 'str'>
print(type(age))   # <class 'int'>
```

### Hàm `type()`

Dùng để kiểm tra kiểu dữ liệu của một biến:

```python
value = 100
print(type(value))
```

Kết quả:

```python
<class 'int'>
```

---

## 2. Các kiểu dữ liệu cơ bản (Data Types)

| Kiểu dữ liệu | Ý nghĩa                            | Ví dụ            |
| ------------ | ---------------------------------- | ---------------- |
| `int`        | Số nguyên                          | `25`, `-10`      |
| `float`      | Số thập phân                       | `25000000.5`     |
| `str`        | Chuỗi ký tự                        | `"Nguyễn An"`    |
| `bool`       | Đúng/Sai                           | `True`, `False`  |
| `list`       | Danh sách có thứ tự, thay đổi được | `[1, 2, 3]`      |
| `dict`       | Dữ liệu dạng key-value             | `{"name": "An"}` |

---

### List

List là kiểu dữ liệu dùng để lưu nhiều giá trị trong một biến.

```python
salaries = [25000000, 18000000, 22000000]
```

Truy cập phần tử:

```python
print(salaries[0])
```

Kết quả:

```python
25000000
```

### Một số thao tác thường dùng

```python
salaries.append(30000000)
print(len(salaries))
```

Kết quả:

```python
4
```

### Lưu ý quan trọng

Python đánh số phần tử bắt đầu từ **0**:

| Chỉ số | Giá trị  |
| ------ | -------- |
| 0      | 25000000 |
| 1      | 18000000 |
| 2      | 22000000 |

Do đó:

```python
salaries[0]
```

là phần tử đầu tiên.

---

### Dict

Dictionary lưu dữ liệu theo cặp **key-value**, rất giống JSON.

```python
employee = {
    "name": "Nguyễn An",
    "department": "Data",
    "salary": 25000000
}
```

Truy cập dữ liệu:

```python
print(employee["name"])
print(employee["department"])
```

Kết quả:

```python
Nguyễn An
Data
```

---

## 3. Toán tử so sánh và logic

Các toán tử này tương tự điều kiện trong mệnh đề `WHERE` của SQL.

```python
salary = 25000000

print(salary > 20000000)
print(salary == 25000000)
print(salary != 18000000)
```

Kết quả:

```python
True
True
True
```

### Các toán tử so sánh phổ biến

| Toán tử | Ý nghĩa           |
| ------- | ----------------- |
| `==`    | Bằng              |
| `!=`    | Khác              |
| `>`     | Lớn hơn           |
| `<`     | Nhỏ hơn           |
| `>=`    | Lớn hơn hoặc bằng |
| `<=`    | Nhỏ hơn hoặc bằng |

---

### Toán tử logic

```python
is_data_team = True
is_senior = salary > 24000000

print(is_data_team and is_senior)
print(is_data_team or is_senior)
```

| Toán tử | Tương đương SQL |
| ------- | --------------- |
| `and`   | AND             |
| `or`    | OR              |
| `not`   | NOT             |

---

### Cạm bẫy phổ biến

Trong Python:

```python
salary = 25000000
```

là gán giá trị.

Còn:

```python
salary == 25000000
```

là so sánh.

Người mới học thường nhầm lẫn giữa `=` và `==`.

---

## 4. Điều kiện — if / elif / else

Đây là phiên bản Python của `CASE WHEN` trong SQL.

```python
salary = 22000000

if salary >= 25000000:
    level = "Cao"
elif salary >= 20000000:
    level = "Trung bình"
else:
    level = "Thấp"

print(level)
```

Kết quả:

```python
Trung bình
```

---

### Indentation (Thụt đầu dòng)

Python không dùng dấu `{}` để xác định khối lệnh.

Thay vào đó dùng khoảng trắng:

```python
if salary > 20000000:
    print("Lương cao")
```

Viết sai:

```python
if salary > 20000000:
print("Lương cao")
```

sẽ gây lỗi.

Đây là một trong những điểm khác biệt lớn nhất của Python.

---

## 5. Vòng lặp

### For Loop

Lặp qua từng phần tử trong danh sách:

```python
salaries = [25000000, 18000000, 22000000]

for salary in salaries:
    print(salary)
```

Kết quả:

```python
25000000
18000000
22000000
```

---

### Kết hợp với điều kiện

```python
high_salaries = []

for salary in salaries:
    if salary > 20000000:
        high_salaries.append(salary)

print(high_salaries)
```

Kết quả:

```python
[25000000, 22000000]
```

---

### While Loop

```python
count = 0

while count < 3:
    print(f"Lần thứ {count}")
    count = count + 1
```

Kết quả:

```python
Lần thứ 0
Lần thứ 1
Lần thứ 2
```

---

### Lưu ý

Nếu quên cập nhật biến điều kiện:

```python
count = 0

while count < 3:
    print(count)
```

vòng lặp sẽ chạy mãi mãi (Infinite Loop).

---

## 6. f-string — chèn biến vào chuỗi

```python
name = "An"
salary = 25000000

print(f"{name} có lương {salary} VNĐ")
```

Kết quả:

```python
An có lương 25000000 VNĐ
```

### Vì sao nên dùng f-string?

So với cách nối chuỗi:

```python
print(name + " có lương " + str(salary))
```

f-string:

* Dễ đọc hơn
* Ngắn gọn hơn
* Là cách phổ biến nhất trong Python hiện đại

---

## Tóm tắt kiến thức

Sau bài học này, bạn cần nắm được:

* Biến dùng để lưu dữ liệu.
* Python là ngôn ngữ Dynamic Typing.
* Các kiểu dữ liệu cơ bản:

  * int
  * float
  * str
  * bool
  * list
  * dict
* Toán tử so sánh và logic.
* Điều kiện:

  * if
  * elif
  * else
* Vòng lặp:

  * for
  * while
* Cách sử dụng f-string.
* Python đánh số index bắt đầu từ 0.

---

## 🧪 Bài tập thực hành

### Bài 1

Tạo một list tên `departments` gồm:

```python
["Data", "Sales", "Marketing", "HR"]
```

In ra phần tử thứ hai trong danh sách.

---

### Bài 2

Tạo dictionary:

```python
employee = {
    "name": "...",
    "department": "...",
    "salary": ...
}
```

In ra:

```text
{name} làm ở phòng {department}
```

bằng f-string.

---

### Bài 3

Cho:

```python
stress_level = 7
```

Viết `if/elif/else` để phân loại:

* `>= 7` → `"Cần chú ý"`
* `4-6` → `"Bình thường"`
* `< 4` → `"Ổn định"`

---

### Bài 4

Cho:

```python
scores = [85, 42, 90, 55, 78, 30]
```

Tạo list mới tên `passed` chỉ chứa các điểm lớn hơn hoặc bằng 50.

---

### Bài 5 (Tổng hợp)

Cho:

```python
salaries = [18000000, 25000000, 30000000, 15000000, 22000000]
```

Viết chương trình:

1. Đếm số người có lương từ 20 triệu trở lên.
2. In kết quả:

```text
Có 3 người lương từ 20 triệu trở lên
```
