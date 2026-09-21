# Khóa 1: Understanding Data Engineering

> **Mục tiêu:** Hiểu bức tranh tổng thể về Data Engineering trước khi bắt đầu học SQL, Python và các công cụ chuyên sâu.  
> **Yêu cầu:** Không cần code.

---

## 1. Data Engineer là ai, làm gì?

Hãy tưởng tượng một công ty thương mại điện tử. Mỗi ngày có:

- Dữ liệu đơn hàng từ website
- Dữ liệu click chuột từ app
- Dữ liệu từ hệ thống kho vận
- Dữ liệu quảng cáo từ Facebook/Google Ads

Data Scientist muốn phân tích:

> "Khách hàng nào có khả năng rời bỏ?"

Nhưng họ không thể tự đi lấy dữ liệu thô từ 10 hệ thống khác nhau, làm sạch và ghép nối chúng lại mỗi lần muốn phân tích.

**Đó chính là việc của Data Engineer.**

Data Engineer xây dựng các hệ thống và **data pipeline** tự động để:

1. **Lấy dữ liệu** từ nhiều nguồn (database, API, file log...)
2. **Làm sạch & biến đổi** dữ liệu thành dạng có thể sử dụng
3. **Lưu trữ** dữ liệu vào một nơi tập trung, có tổ chức
4. **Cung cấp dữ liệu** cho Data Scientist/Data Analyst mà họ không cần lo dữ liệu nằm ở đâu hay có định dạng như thế nào

### Nói ngắn gọn

> **Data Scientist dùng dữ liệu để tìm insight. Data Engineer xây đường ống để dữ liệu chảy tới tay Data Scientist một cách sạch sẽ, đúng lúc và đáng tin cậy.**

---

## 2. Lưu trữ dữ liệu (Storing Data)

Có 2 khái niệm quan trọng bạn sẽ gặp liên tục:

| Tiêu chí | Data Warehouse | Data Lake |
|---|---|---|
| Dữ liệu | Đã xử lý, có cấu trúc (bảng, cột rõ ràng) | Thô, nhiều định dạng (ảnh, JSON, CSV, video...) |
| Dùng để | Báo cáo, BI, phân tích kinh doanh | Machine Learning, lưu trữ dữ liệu thô và dữ liệu chưa biết sẽ dùng vào đâu |
| Ví dụ công cụ | Snowflake, Amazon Redshift, Google BigQuery | Amazon S3, Azure Data Lake |
| Hình dung | Tủ hồ sơ đã sắp xếp gọn gàng | Nhà kho chứa mọi thứ, chưa phân loại |

### Data Warehouse

Data Warehouse thường chứa dữ liệu đã được tổ chức và chuẩn hóa để phục vụ:

- Business Intelligence (BI)
- Dashboard
- Báo cáo
- Phân tích dữ liệu
- SQL queries

Ví dụ:

```text
customers
orders
products
payments
```

Các bảng có cấu trúc rõ ràng và có mối quan hệ với nhau.

### Data Lake

Data Lake có thể lưu dữ liệu ở nhiều dạng khác nhau:

```text
CSV
JSON
Parquet
Images
Videos
Logs
```

Dữ liệu thường được lưu ở dạng gần với dữ liệu nguồn nhất để có thể xử lý sau này.

---

## 3. Di chuyển & xử lý dữ liệu — ETL vs ELT

Đây là một trong những khái niệm cốt lõi của Data Engineering.

### 3.1. ETL là gì?

**ETL = Extract → Transform → Load**

#### E — Extract

Lấy dữ liệu từ các nguồn:

- Database
- REST API
- File CSV
- File JSON
- Application logs
- External services

Ví dụ:

```text
MySQL
   ↓
Extract
   ↓
Raw Data
```

#### T — Transform

Biến đổi dữ liệu:

- Loại bỏ dữ liệu lỗi
- Xử lý dữ liệu bị thiếu
- Đổi định dạng ngày tháng
- Chuẩn hóa dữ liệu
- Tính toán cột mới
- JOIN nhiều bảng
- Loại bỏ duplicate

Ví dụ:

```text
2026-09-21 15:30:00
        ↓
2026-09-21
```

#### L — Load

Đưa dữ liệu đã xử lý vào hệ thống lưu trữ cuối:

```text
Source
   ↓
Extract
   ↓
Transform
   ↓
Data Warehouse
```

### 3.2. ELT là gì?

**ELT = Extract → Load → Transform**

Thay vì transform trước, dữ liệu được đưa vào hệ thống lưu trữ trước rồi mới transform.

```text
Source
   ↓
Extract
   ↓
Load
   ↓
Data Warehouse
   ↓
Transform
```

Mô hình này phổ biến với các hệ thống hiện đại như:

- Snowflake
- Google BigQuery
- Amazon Redshift

Lý do là các hệ thống này có khả năng xử lý dữ liệu lớn ngay bên trong warehouse.

---

## 4. ETL vs ELT

| Tiêu chí | ETL | ELT |
|---|---|---|
| Thứ tự | Extract → Transform → Load | Extract → Load → Transform |
| Transform | Trước khi lưu vào hệ thống đích | Sau khi load vào hệ thống đích |
| Dữ liệu raw | Thường không được giữ nguyên ở đích | Thường có thể giữ raw data |
| Phù hợp | Hệ thống đích hạn chế khả năng xử lý | Cloud Data Warehouse hiện đại |
| Ví dụ | Pipeline truyền thống | Snowflake / BigQuery / Redshift |

### Cách ghi nhớ

**ETL:**

> "Xử lý trước → lưu sau"

**ELT:**

> "Lưu trước → xử lý sau"

---

## 5. Ví dụ thực tế

Giả sử một công ty có:

```text
Website
Mobile App
Facebook Ads
Google Ads
Kho hàng
Payment System
```

Dữ liệu đến từ nhiều nguồn:

```text
Website ───────┐
Mobile App ────┤
Facebook Ads ──┤
Google Ads ────┼──→ Data Pipeline ──→ Data Warehouse
Warehouse ─────┤
Payment ───────┘
```

Data Engineer sẽ xây dựng pipeline để:

1. Thu thập dữ liệu
2. Kiểm tra dữ liệu
3. Làm sạch dữ liệu
4. Chuẩn hóa dữ liệu
5. Kết hợp dữ liệu từ nhiều nguồn
6. Lưu trữ dữ liệu
7. Cung cấp dữ liệu cho các hệ thống phân tích

Sau đó:

```text
Data Warehouse
       ↓
 ┌─────┴─────┐
 ↓           ↓
Data       Data
Analyst    Scientist
```

---

## 6. Tóm tắt kiến thức cần nhớ

Sau khi hoàn thành khóa này, bạn cần hiểu rõ:

### Data Engineer

- Xây dựng data pipeline
- Thu thập dữ liệu từ nhiều nguồn
- Xử lý và biến đổi dữ liệu
- Lưu trữ dữ liệu
- Cung cấp dữ liệu đáng tin cậy cho các hệ thống phân tích

### Data Warehouse

- Dữ liệu có cấu trúc
- Phục vụ BI, báo cáo và phân tích
- Ví dụ: Snowflake, BigQuery, Redshift

### Data Lake

- Có thể lưu dữ liệu thô
- Hỗ trợ nhiều định dạng
- Có thể phục vụ Machine Learning và nhiều mục đích khác
- Ví dụ: Amazon S3, Azure Data Lake

### ETL

```text
Extract → Transform → Load
```

### ELT

```text
Extract → Load → Transform
```

---

## 7. Kiến thức cần học tiếp

Sau khi hiểu được bức tranh lớn này, bước tiếp theo là học các nền tảng quan trọng hơn:

1. **SQL**
2. **Database**
3. **Python**
4. **Linux & Command Line**
5. **Git**
6. **Data Modeling**
7. **ETL/ELT Pipeline**
8. **Cloud**
9. **Apache Airflow**
10. **Spark / Big Data**

> **Nguyên tắc học:** Đừng cố học tất cả công cụ cùng lúc. Hãy nắm chắc nền tảng trước, sau đó mới học công cụ.
