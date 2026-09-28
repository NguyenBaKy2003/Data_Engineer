# Khóa 5: Intermediate Importing Data in Python

Nếu Khóa 4 là "đọc file có sẵn", thì khóa này là **lấy dữ liệu trực tiếp từ internet** — kỹ năng cực kỳ quan trọng vì rất nhiều nguồn dữ liệu thực tế (giá cổ phiếu, thời tiết, dữ liệu mạng xã hội...) chỉ có qua API, không có sẵn file để tải về.

---

## 1. HTTP là gì? — nền tảng để hiểu API

Mỗi khi bạn mở một trang web, trình duyệt gửi một **request** (yêu cầu) tới server, server trả về một **response** (phản hồi). API hoạt động theo đúng cơ chế này, chỉ khác là bạn dùng code thay vì trình duyệt.

| HTTP Method | Ý nghĩa | Tương đương SQL |
|------------|----------|----------------|
| `GET` | Lấy dữ liệu | `SELECT` |
| `POST` | Gửi/tạo dữ liệu mới | `INSERT` |
| `PUT` / `PATCH` | Cập nhật dữ liệu | `UPDATE` |
| `DELETE` | Xóa dữ liệu | `DELETE` |

👉 Trong Data Engineering, bạn dùng `GET` là chủ yếu — vì mục tiêu thường là **lấy** dữ liệu về để xử lý, không phải thay đổi dữ liệu của bên cung cấp API.

### Status Code

Server trả về mã số cho biết request thành công hay lỗi:

| Mã | Ý nghĩa |
|-----|----------|
| `200` | Thành công |
| `401` | Chưa xác thực (thiếu/sai API key) |
| `404` | Không tìm thấy tài nguyên |
| `429` | Gửi quá nhiều request (rate limit) |
| `500` | Lỗi phía server |

---

## 2. Thư viện `requests` — công cụ chính để gọi API

```python
import requests

response = requests.get("https://api.example.com/data")

print(response.status_code)   # 200 nếu thành công
print(response.text)          # nội dung trả về dạng chuỗi thô
```

Hầu hết API trả về dữ liệu dạng **JSON** — dùng `.json()` để tự động chuyển thành dict Python:

```python
data = response.json()
print(data["results"])
```

👉 Liên hệ với Khóa 8 (Snowflake VARIANT): JSON chính là kiểu dữ liệu bán cấu trúc bạn đã học cách truy vấn bằng `payload:field::type`.

Ở phía Python, bạn xử lý JSON bằng cú pháp dict quen thuộc:

```python
data["field"]
```

---

## 3. Truyền tham số (Parameters) cho Request

Thay vì tự ghép chuỗi URL dài dòng, `requests` cho phép truyền tham số qua dict — an toàn và dễ đọc hơn:

```python
params = {
    "city": "Hanoi",
    "units": "metric"
}

response = requests.get(
    "https://api.weather.com/forecast",
    params=params
)
```

Tương đương:

```text
https://api.weather.com/forecast?city=Hanoi&units=metric
```

---

## 4. Xác thực (Authentication)

Hầu hết API thật đều yêu cầu xác thực bằng API key.

### Dùng Bearer Token

```python
headers = {
    "Authorization": "Bearer YOUR_API_KEY_HERE"
}

response = requests.get(
    "https://api.example.com/data",
    headers=headers
)
```

### Dùng API Key trong Parameters

```python
params = {
    "api_key": "YOUR_API_KEY_HERE"
}

response = requests.get(
    "https://api.example.com/data",
    params=params
)
```

👉 **Lưu ý bảo mật quan trọng:**

Không bao giờ để API key trực tiếp trong code rồi đẩy lên GitHub công khai.

Nên dùng:

- Biến môi trường (`os.environ`)
- File `.env`

để lưu thông tin nhạy cảm.

---

## 5. Xử lý lỗi khi gọi API

API bên ngoài có thể:

- Sập
- Chậm
- Hết quota
- Trả lỗi bất cứ lúc nào

Pipeline của bạn phải xử lý được các tình huống này.

```python
response = requests.get(
    "https://api.example.com/data"
)

if response.status_code == 200:
    data = response.json()
    print("Lấy dữ liệu thành công")
else:
    print(f"Lỗi: {response.status_code}")
```

---

## 6. Phân trang (Pagination)

Nhiều API chỉ trả về một phần dữ liệu mỗi lần gọi (ví dụ: 20 kết quả/trang), bạn phải gọi nhiều lần để lấy hết.

```python
all_results = []
page = 1

while True:
    response = requests.get(
        "https://api.example.com/items",
        params={"page": page}
    )

    data = response.json()

    if len(data["items"]) == 0:
        break

    all_results.extend(data["items"])
    page += 1

print(
    f"Tổng cộng lấy được {len(all_results)} items"
)
```

👉 Đây chính là ví dụ thực tế của vòng lặp `while` (Khóa 2).

Điều kiện dừng không phải một số cố định, mà là:

> "Khi server báo hết dữ liệu."

---

## 7. Case Study: Twitter API (X API)

Twitter API (nay là X API) là ví dụ kinh điển vì minh họa rõ hầu hết các khái niệm đã học:

- Cần API key (Bearer Token)
- Có rate limit → dễ gặp mã `429`
- Trả JSON lồng nhau phức tạp
- Cần phân trang khi lấy nhiều tweet

Ví dụ:

```python
headers = {
    "Authorization": "Bearer YOUR_TWITTER_BEARER_TOKEN"
}

params = {
    "query": "data engineering",
    "max_results": 10
}

response = requests.get(
    "https://api.twitter.com/2/tweets/search/recent",
    headers=headers,
    params=params
)

tweets = response.json()["data"]
```

---

# 🧪 Bài tập thực hành

## Bài 1

Viết code gọi:

```python
requests.get(
    "https://jsonplaceholder.typicode.com/users"
)
```

Lưu kết quả vào biến `response`.

Kiểm tra:

- Nếu `status_code == 200` → in `"Thành công"`
- Ngược lại → in `"Thất bại"`

---

## Bài 2

Từ response ở Bài 1:

- Dùng `.json()` để lấy dữ liệu.
- Viết vòng lặp `for` in ra:
  - `name`
  - `email`

của từng user.

### Gợi ý

Kết quả trả về là:

```python
[
    {...},
    {...},
    ...
]
```

Mỗi phần tử là một dict đại diện cho một user.

---

## Bài 3

Viết đoạn code (giả lập) gọi API thời tiết với:

```python
city = "Hanoi"
api_key = "abc123"
```

Sử dụng:

```python
requests.get()
```

và truyền dữ liệu bằng `params`.

---

## Bài 4 (Lý thuyết)

Giải thích ngắn gọn:

Vì sao khi viết pipeline lấy dữ liệu từ API thật, bạn **không nên giả định** `status_code` luôn là `200`, mà cần kiểm tra trước khi xử lý tiếp?

---

## Bài 5 (Tổng hợp – Pagination)

Giả lập một API:

- Trả tối đa 2 items mỗi trang.
- Không cần API thật.

Viết vòng lặp:

```python
while
```

sử dụng biến `page`.

Yêu cầu:

- Mỗi lần lặp in:

```python
f"Đang lấy trang {page}"
```

- Khi:

```python
page > 3
```

thì dừng chương trình.

---

## Tóm tắt Khóa 5

Sau khóa này, bạn đã biết:

- Hiểu cơ chế Request → Response của HTTP.
- Sử dụng thư viện `requests`.
- Đọc dữ liệu JSON từ API.
- Truyền tham số bằng `params`.
- Xác thực bằng API key/Bearer Token.
- Kiểm tra `status_code`.
- Xử lý phân trang (pagination).
- Hiểu cách hoạt động của các API thực tế như Twitter/X API.

Đây là bước chuyển từ việc **đọc dữ liệu có sẵn** sang **thu thập dữ liệu trực tiếp từ các hệ thống bên ngoài**, một kỹ năng cốt lõi của Data Engineer.