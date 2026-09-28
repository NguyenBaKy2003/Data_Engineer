# Khóa 6: Introduction to APIs in Python

Khóa 5 cho bạn cái nhìn tổng quan về việc lấy dữ liệu từ web. Khóa này đi sâu vào **cách làm việc với API một cách bài bản**: hiểu cấu trúc API, xử lý lỗi đúng cách và gửi dữ liệu đi (không chỉ nhận về). Đây là kỹ năng bạn sẽ dùng liên tục khi viết pipeline ETL thật.

Tất cả ví dụ dùng **JSONPlaceholder** (`https://jsonplaceholder.typicode.com`), một API test miễn phí, không cần API key, nên bạn có thể chạy thử ngay.

---

## 1. REST API và Endpoint

Hầu hết API hiện nay theo phong cách **REST**: mỗi loại dữ liệu có một địa chỉ riêng gọi là **endpoint**.

```text
https://jsonplaceholder.typicode.com/users
→ danh sách tất cả user

https://jsonplaceholder.typicode.com/users/1
→ user có id = 1

https://jsonplaceholder.typicode.com/posts
→ danh sách bài viết

https://jsonplaceholder.typicode.com/posts/1
→ bài viết có id = 1
```

### Cấu trúc URL

| Thành phần | Ví dụ | Vai trò |
|-----------|--------|----------|
| **Base URL** | `https://jsonplaceholder.typicode.com` | Địa chỉ gốc của API |
| **Endpoint** | `/users` | Loại tài nguyên cần lấy |
| **Query Params** | `?userId=1` | Điều kiện lọc |

👉 Tương tự SQL:

- Base URL ≈ Database
- Endpoint ≈ Bảng (Table)
- Query Params ≈ Mệnh đề `WHERE`

### Ví dụ

```python
import requests

BASE_URL = "https://jsonplaceholder.typicode.com"

# Lấy 1 user cụ thể
response = requests.get(f"{BASE_URL}/users/1")
user = response.json()

print(user["name"])

# Chỉ lấy bài viết của user 1
response = requests.get(
    f"{BASE_URL}/posts",
    params={"userId": 1}
)

posts = response.json()

print(len(posts))   # 10 bài
```

👉 Nên tách `BASE_URL` thành biến riêng. Nếu API đổi địa chỉ, bạn chỉ cần sửa một chỗ.

---

## 2. Đọc cấu trúc JSON lồng nhau

Dữ liệu API thật hiếm khi ở dạng phẳng.

Ví dụ:

```python
user = requests.get(
    f"{BASE_URL}/users/1"
).json()
```

Kết quả:

```python
{
    "id": 1,
    "name": "Leanne Graham",
    "email": "Sincere@april.biz",
    "address": {
        "city": "Gwenborough",
        "geo": {
            "lat": "-37.3159",
            "lng": "81.1496"
        }
    },
    "company": {
        "name": "Romaguera-Crona"
    }
}
```

### Truy cập dữ liệu lồng nhau

```python
print(user["address"]["city"])
# Gwenborough

print(user["address"]["geo"]["lat"])
# -37.3159

print(user["company"]["name"])
# Romaguera-Crona
```

👉 Liên hệ Snowflake:

```sql
payload:address:city::STRING
```

Tư duy hoàn toàn giống nhau:

> Đi xuống từng tầng dữ liệu.

### Dùng `.get()` để tránh lỗi

```python
phone = user.get(
    "phone_number",
    "Không có"
)

print(phone)
```

Nếu key không tồn tại:

```python
user["phone_number"]
```

sẽ gây:

```text
KeyError
```

---

## 3. Xử lý lỗi với `try / except`

Khóa 5 bạn đã biết kiểm tra `status_code`.

Tuy nhiên có những lỗi xảy ra **trước khi có status code**:

- Mất mạng
- DNS lỗi
- Server không phản hồi
- Timeout

Lúc đó:

```python
requests.get(...)
```

sẽ ném ra (*raise*) exception.

### Ví dụ

```python
try:
    response = requests.get(
        f"{BASE_URL}/users",
        timeout=5
    )

    response.raise_for_status()

    data = response.json()

    print(
        f"Lấy được {len(data)} user"
    )

except requests.exceptions.Timeout:
    print("Server phản hồi quá chậm")

except requests.exceptions.HTTPError as e:
    print(f"Lỗi HTTP: {e}")

except requests.exceptions.RequestException as e:
    print(f"Lỗi kết nối: {e}")
```

### Ba điểm quan trọng

#### 1. Luôn đặt `timeout`

```python
timeout=5
```

Nếu sau 5 giây chưa có phản hồi:

```python
Timeout
```

sẽ được ném ra.

⚠️ Mặc định `requests` chờ vô hạn.

Pipeline thật có thể treo hàng giờ nếu không đặt timeout.

---

#### 2. Dùng `raise_for_status()`

```python
response.raise_for_status()
```

Tự động ném lỗi nếu status code là:

```text
4xx
5xx
```

Gọn hơn:

```python
if response.status_code == 200:
    ...
```

---

#### 3. Bắt lỗi cụ thể trước

Đúng:

```python
except Timeout:
    ...

except HTTPError:
    ...

except RequestException:
    ...
```

Sai:

```python
except RequestException:
    ...

except Timeout:
    ...
```

Vì lỗi chung sẽ bắt hết lỗi cụ thể phía sau.

---

## 4. Gửi dữ liệu bằng POST

Đến giờ bạn chỉ dùng:

```http
GET
```

Tương tự:

```sql
SELECT
```

Để tạo dữ liệu mới:

```http
POST
```

Tương tự:

```sql
INSERT
```

### Ví dụ

```python
new_post = {
    "title": "Học Data Engineering",
    "body": "Hôm nay mình học API",
    "userId": 1
}

response = requests.post(
    f"{BASE_URL}/posts",
    json=new_post
)

print(response.status_code)
print(response.json())
```

Kết quả:

```text
201
```

nghĩa là:

```text
Created
```

### JSONPlaceholder lưu ý

JSONPlaceholder chỉ giả lập việc tạo dữ liệu.

- Trả kết quả như thật
- Tạo id mới

Nhưng:

- Không ghi vào database thật

Rất phù hợp để thực hành.

### Các mã thành công thường gặp

| Mã | Ý nghĩa |
|-----|----------|
| `200` | OK |
| `201` | Created |
| `204` | No Content |

---

## 5. Headers và API Key an toàn

Ví dụ không an toàn:

```python
headers = {
    "Authorization": "Bearer abc123"
}
```

Nếu đẩy code lên GitHub:

```text
API Key bị lộ
```

### Cách đúng

```python
import os

api_key = os.environ.get(
    "MY_API_KEY"
)

headers = {
    "Authorization": f"Bearer {api_key}"
}

response = requests.get(
    "https://api.example.com/data",
    headers=headers
)
```

👉 Luôn lưu key trong:

- Environment Variables
- File `.env`

không lưu trực tiếp trong source code.

---

## 6. Rate Limiting

Nhiều API giới hạn:

```text
100 requests/phút
500 requests/phút
...
```

Nếu vượt quá:

```text
429 Too Many Requests
```

### Ví dụ

```python
import time

for user_id in range(1, 6):

    response = requests.get(
        f"{BASE_URL}/users/{user_id}",
        timeout=5
    )

    print(
        response.json()["name"]
    )

    time.sleep(1)
```

Mỗi request nghỉ:

```python
1 giây
```

để tránh gửi quá dồn dập.

---

## 7. Hàm gọi API hoàn chỉnh

Kết hợp:

- Function (Khóa 3)
- Timeout
- Try/Except
- Raise For Status

```python
import requests

BASE_URL = "https://jsonplaceholder.typicode.com"

def lay_du_lieu(endpoint, params=None):
    """
    Gọi API GET và trả về dữ liệu JSON.

    Params:
        endpoint (str): ví dụ "/users"
        params (dict): tham số lọc

    Returns:
        dict/list nếu thành công
        None nếu thất bại
    """

    try:
        response = requests.get(
            f"{BASE_URL}{endpoint}",
            params=params,
            timeout=5
        )

        response.raise_for_status()

        return response.json()

    except requests.exceptions.RequestException as e:
        print(
            f"Lỗi khi gọi {endpoint}: {e}"
        )
        return None


users = lay_du_lieu("/users")

if users is not None:
    print(
        f"Có {len(users)} user"
    )
```

👉 Đây là kiểu code thường thấy trong ETL pipeline thật.

---

# 🧪 Bài tập thực hành

## Bài 1

Gọi endpoint:

```text
/users/3
```

In ra:

- `name`
- `address["city"]`

của user đó.

---

## Bài 2

Gọi:

```python
/posts
```

với:

```python
params={"userId": 2}
```

Yêu cầu:

- In số lượng bài viết.
- In `title` của bài đầu tiên.

---

## Bài 3

Viết code gọi:

```text
/users
```

có đầy đủ:

- `timeout=5`
- `raise_for_status()`
- `try/except`

bắt:

```python
requests.exceptions.RequestException
```

Nếu thành công:

```text
Lấy được X user
```

Nếu lỗi:

```text
Có lỗi xảy ra
```

---

## Bài 4

Dùng:

```http
POST
```

gửi bài viết mới tới:

```text
/posts
```

với:

```python
{
    "title": "Bài của tôi",
    "body": "Nội dung thử",
    "userId": 1
}
```

In:

```python
response.status_code
```

và giải thích:

> Vì sao kết quả là `201` thay vì `200`?

---

## Bài 5 (Tổng hợp)

Viết hàm:

```python
lay_ten_user(user_id)
```

Yêu cầu:

- Gọi endpoint:

```text
/users/{user_id}
```

- Trả về tên user nếu thành công.
- Nếu lỗi (ví dụ `404`) thì trả về:

```python
None
```

thay vì làm chương trình bị dừng.

### Kiểm tra

```python
print(lay_ten_user(1))
print(lay_ten_user(999))
```

---

## Tóm tắt Khóa 6

Sau khóa này, bạn đã biết:

- REST API là gì.
- Endpoint hoạt động như thế nào.
- Cấu trúc URL: Base URL + Endpoint + Query Params.
- Đọc JSON lồng nhau.
- Dùng `.get()` để tránh `KeyError`.
- Xử lý lỗi bằng `try/except`.
- Sử dụng `timeout`.
- Sử dụng `raise_for_status()`.
- Gửi dữ liệu bằng `POST`.
- Hiểu ý nghĩa các mã `200`, `201`, `204`.
- Bảo mật API key bằng biến môi trường.
- Tránh rate limiting bằng `time.sleep()`.
- Viết hàm tái sử dụng để gọi API.

Đây là bước chuyển từ việc **gọi API đơn lẻ** sang **xây dựng các thành phần có thể tái sử dụng trong ETL pipeline thực tế**.