# Khóa 1: Understanding Cloud Computing

Chào mừng đến track thứ hai! Trước khi học Python, bạn cần hiểu **Cloud Computing** vì hầu hết các công cụ Data Engineer hiện đại (như Snowflake, Airflow, Spark trên cloud...) đều chạy trên nền tảng đám mây thay vì máy chủ vật lý truyền thống.

---

## 1. Cloud Computing là gì?

Thay vì công ty phải tự mua server, đặt trong phòng máy và tự bảo trì, **Cloud Computing** cho phép thuê tài nguyên tính toán (máy chủ, lưu trữ, mạng...) từ nhà cung cấp bên thứ ba thông qua Internet, và trả tiền theo mức sử dụng thực tế.

Liên hệ với những gì bạn đã học:

* Trong Snowflake, bạn có thể tạo một **Virtual Warehouse** chỉ bằng vài dòng SQL.
* Bạn không cần biết máy chủ vật lý ở đâu.
* Không cần mua phần cứng hay cài đặt hệ điều hành.

Đó chính là bản chất của Cloud Computing: **tài nguyên được ảo hóa và cấp phát theo nhu cầu**.

### So sánh: On-Premise vs Cloud

| Tiêu chí         | On-Premise (Tự Host)            | Cloud                                |
| ---------------- | ------------------------------- | ------------------------------------ |
| Chi phí          | Đầu tư lớn ban đầu (mua server) | Trả theo mức sử dụng (Pay-as-you-go) |
| Khả năng mở rộng | Chậm, phải mua thêm phần cứng   | Nhanh, chỉ cần vài thao tác cấu hình |
| Bảo trì          | Đội IT tự quản lý               | Nhà cung cấp quản lý hạ tầng         |
| Ví dụ            | PostgreSQL cài trên máy cá nhân | Snowflake                            |

---

## 2. Ba mô hình dịch vụ Cloud

Đây là một trong những khái niệm quan trọng nhất khi học Cloud.

### IaaS (Infrastructure as a Service)

Bạn thuê hạ tầng cơ bản:

* Máy chủ
* Mạng
* Ổ cứng

Bạn vẫn phải tự quản lý:

* Hệ điều hành
* Phần mềm
* Cơ sở dữ liệu
* Ứng dụng

**Ví dụ:**

* AWS EC2
* Google Compute Engine

---

### PaaS (Platform as a Service)

Nhà cung cấp quản lý:

* Hạ tầng
* Hệ điều hành
* Runtime

Bạn chỉ cần:

* Viết code
* Quản lý dữ liệu

**Ví dụ:**

* Snowflake
* AWS RDS
* Heroku

---

### SaaS (Software as a Service)

Bạn chỉ sử dụng ứng dụng hoàn chỉnh.

Không cần quản lý:

* Server
* Hệ điều hành
* Cấu hình hệ thống

**Ví dụ:**

* Gmail
* Google Docs
* Salesforce

---

### Ví dụ Pizza nổi tiếng

| Mô hình    | Ví dụ                             |
| ---------- | --------------------------------- |
| On-Premise | Tự làm bánh từ đầu                |
| IaaS       | Thuê bếp và lò nướng              |
| PaaS       | Mua bột làm sẵn, chỉ nặn và nướng |
| SaaS       | Gọi pizza giao tận nơi            |

---

## 3. Cloud Deployment Models

### Public Cloud

Hạ tầng được chia sẻ giữa nhiều khách hàng.

**Ví dụ:**

* AWS
* Azure
* Google Cloud Platform (GCP)

**Ưu điểm:**

* Chi phí thấp
* Mở rộng nhanh
* Triển khai dễ dàng

---

### Private Cloud

Hạ tầng dành riêng cho một tổ chức.

**Thường dùng trong:**

* Ngân hàng
* Y tế
* Chính phủ

**Ưu điểm:**

* Kiểm soát cao
* Bảo mật tốt hơn

---

### Hybrid Cloud

Kết hợp giữa:

* Public Cloud
* Private Cloud

Ví dụ:

* Dữ liệu khách hàng lưu ở Private Cloud
* Phân tích dữ liệu chạy trên Public Cloud

**Ưu điểm:**

* Cân bằng giữa chi phí và bảo mật

---

## 4. Các Cloud Provider lớn

Ba nhà cung cấp cloud phổ biến nhất hiện nay:

| Nhà cung cấp | Dịch vụ Data Engineering nổi bật                 |
| ------------ | ------------------------------------------------ |
| AWS          | S3, Redshift, Glue, Athena                       |
| Azure        | Azure Data Lake, Synapse Analytics, Data Factory |
| GCP          | BigQuery, Cloud Storage, Dataflow                |

### AWS (Amazon Web Services)

Một số dịch vụ quan trọng:

* S3 → Object Storage
* Redshift → Data Warehouse
* Glue → ETL
* Athena → Query trực tiếp trên S3

---

### Microsoft Azure

Một số dịch vụ quan trọng:

* Azure Data Lake
* Azure Synapse Analytics
* Azure Data Factory

---

### Google Cloud Platform (GCP)

Một số dịch vụ quan trọng:

* BigQuery → Data Warehouse
* Cloud Storage → Lưu trữ
* Dataflow → ETL và Stream Processing

---

## Tổng kết

Sau bài học này, bạn cần nắm được:

* Cloud Computing là thuê tài nguyên tính toán qua Internet.
* Cloud giúp mở rộng nhanh và trả tiền theo mức sử dụng.
* Có ba mô hình dịch vụ:

  * IaaS
  * PaaS
  * SaaS
* Có ba mô hình triển khai:

  * Public Cloud
  * Private Cloud
  * Hybrid Cloud
* Ba nhà cung cấp cloud lớn nhất hiện nay:

  * AWS
  * Azure
  * GCP

### Liên hệ với Data Engineering

Một pipeline dữ liệu hiện đại thường sử dụng:

1. Cloud Storage để lưu dữ liệu.
2. ETL/ELT Service để xử lý dữ liệu.
3. Data Warehouse để phân tích.
4. Dashboard/BI Tool để trực quan hóa.

Dù sử dụng AWS, Azure hay GCP, các khái niệm cốt lõi này vẫn giống nhau.
