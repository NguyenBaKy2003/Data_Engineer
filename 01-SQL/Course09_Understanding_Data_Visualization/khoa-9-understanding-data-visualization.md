# Khóa 9: Understanding Data Visualization

> **Mục tiêu:** Hiểu cách lựa chọn biểu đồ phù hợp để truyền tải dữ liệu chính xác, dễ hiểu và tránh gây hiểu nhầm. Đây là kỹ năng quan trọng giúp Data Engineer kiểm tra dữ liệu và hiểu cách dữ liệu được sử dụng trong dashboard/report.

---

# 1. Visualizing Distributions — Hiểu phân bố dữ liệu

Khi có một biến số liên tục (ví dụ: lương nhân viên, giá sản phẩm, doanh thu đơn hàng), câu hỏi đầu tiên là:

> Dữ liệu phân bố như thế nào?

Ta cần biết:

- Giá trị tập trung ở đâu?
- Có bị lệch không?
- Có outlier (giá trị bất thường) không?

---

## Histogram

Dùng để xem phân bố của một biến số liên tục.

Ví dụ:

```text
Lương nhân viên
```

Histogram chia dữ liệu thành các khoảng (bins):

```text
0-10 triệu
10-20 triệu
20-30 triệu
30-40 triệu
```

Sau đó đếm số lượng giá trị nằm trong từng khoảng.

### Dùng khi

- Phân tích phân bố dữ liệu
- Kiểm tra dữ liệu ETL
- Phát hiện dữ liệu bất thường

---

## Box Plot

Hiển thị nhanh:

- Median (trung vị)
- Quartiles (tứ phân vị)
- Outliers

Ví dụ:

```text
Lương nhân viên theo phòng ban
```

Box plot giúp phát hiện:

```text
1 nhân viên có lương gấp 20 lần phần còn lại
```

---

## Bar Chart

Dùng để so sánh dữ liệu theo danh mục.

Ví dụ:

```text
Số lượng nhân viên theo phòng ban
```

---

### Histogram vs Bar Chart

| Histogram | Bar Chart |
|------------|------------|
| Dữ liệu liên tục | Dữ liệu danh mục |
| Có thứ tự tự nhiên | Không nhất thiết có thứ tự |
| Khoảng giá trị | Nhóm dữ liệu |

---

## Liên hệ với Data Engineering

Sau khi build pipeline:

```text
salary
price
revenue
```

vẽ histogram là cách rất nhanh để phát hiện:

- Giá trị âm bất thường
- Giá trị NULL quá nhiều
- Phân bố khác thường

---

# 2. Visualizing Two Variables

Khi muốn tìm mối quan hệ giữa hai biến.

---

## Scatter Plot

Dùng để xem tương quan giữa:

```text
Biến số A
và
Biến số B
```

Ví dụ:

```text
Kinh nghiệm ↔ Lương
```

---

### Có thể phát hiện

- Tương quan thuận

```text
Kinh nghiệm tăng
→ Lương tăng
```

---

- Tương quan nghịch

```text
Giá tăng
→ Số lượng mua giảm
```

---

- Không có tương quan

```text
Các điểm phân bố ngẫu nhiên
```

---

## Line Chart

Dùng cho dữ liệu theo thời gian.

Ví dụ:

```text
Doanh thu theo tháng
```

```text
Lượt truy cập theo ngày
```

```text
Số đơn hàng theo giờ
```

---

### Quy tắc quan trọng

Trục X nên là:

```text
Thời gian
```

hoặc dữ liệu có thứ tự tự nhiên.

---

### Sai lầm phổ biến

Không nên dùng:

```text
Line Chart
```

cho:

```text
Data
Sales
Marketing
HR
```

vì:

```text
Không có tính liên tục
```

Đường nối sẽ tạo cảm giác có xu hướng dù thực tế không tồn tại.

---

## Grouped Bar Chart

Ví dụ:

```text
Doanh thu theo vùng
```

và chia theo:

```text
Q1
Q2
Q3
Q4
```

---

Giúp so sánh:

- Giữa các vùng
- Giữa các quý

---

## Stacked Bar Chart

Thể hiện:

```text
Tổng
+
Cấu phần bên trong
```

Ví dụ:

```text
Tổng doanh thu
```

được chia thành:

- Online
- Offline

---

# 3. The Color and the Shape

Chọn đúng màu sắc quan trọng không kém chọn đúng biểu đồ.

---

## Sequential Colors

Dùng khi dữ liệu có thứ tự.

Ví dụ:

```text
Doanh thu
```

từ thấp → cao

Màu nên chuyển:

```text
Nhạt → Đậm
```

---

Ví dụ:

```text
50 triệu
100 triệu
200 triệu
500 triệu
```

---

### Sai lầm phổ biến

Dùng:

```text
Đỏ
Xanh
Vàng
Tím
```

ngẫu nhiên cho dữ liệu có thứ tự.

Người xem sẽ không hiểu:

```text
Màu nào lớn hơn màu nào
```

---

## Diverging Colors

Dùng khi có điểm trung tâm quan trọng.

Ví dụ:

```text
0%
```

---

Các trường hợp phổ biến:

```text
Lỗ ↔ Lãi
```

```text
Âm ↔ Dương
```

```text
Giảm ↔ Tăng
```

---

Ví dụ màu:

```text
Đỏ → Trắng → Xanh
```

---

## Qualitative Colors

Dùng cho dữ liệu phân loại.

Ví dụ:

```text
Data
Sales
Marketing
Finance
```

---

Các màu chỉ để:

```text
Phân biệt nhóm
```

không mang ý nghĩa:

```text
Tốt hơn
Xấu hơn
Lớn hơn
Nhỏ hơn
```

---

## Quy tắc vàng

Nếu dữ liệu có thứ tự:

```text
Màu sắc cũng phải có thứ tự
```

---

# 4. Những lỗi phổ biến khi trực quan hóa dữ liệu

---

## 1. Pie Chart quá nhiều lát cắt

Ví dụ:

```text
12 phòng ban
```

trong cùng một pie chart.

---

Khi số phần quá nhiều:

```text
Mắt người khó so sánh diện tích
```

---

Thường nên thay bằng:

```text
Bar Chart
```

---

## 2. Trục Y không bắt đầu từ 0

Ví dụ:

```text
98
99
100
```

nhưng trục Y bắt đầu từ:

```text
97
```

---

Kết quả:

```text
Chênh lệch nhỏ
trông như rất lớn
```

---

Đặc biệt nguy hiểm với:

```text
Bar Chart
```

---

## 3. Nhồi nhét quá nhiều thông tin

Ví dụ:

```text
7 đường line
```

trong cùng một biểu đồ.

---

Kết quả:

```text
Không ai đọc nổi
```

---

Giải pháp:

```text
Small Multiples
```

tức là chia thành nhiều biểu đồ nhỏ.

---

## 4. Chọn sai loại biểu đồ

Ví dụ:

```text
Line Chart
```

cho:

```text
Sales
Marketing
Data
HR
```

---

Dữ liệu không có thứ tự.

---

Nên dùng:

```text
Bar Chart
```

---

## 5. Thiếu nhãn và đơn vị

Ví dụ:

```text
Doanh thu = 500
```

---

Nhưng:

```text
500 gì?
```

- VNĐ?
- USD?
- Triệu VNĐ?

---

Một biểu đồ tốt luôn ghi rõ:

- Tiêu đề
- Tên trục
- Đơn vị đo

---

# 5. Góc nhìn của Data Engineer

Data Engineer thường không xây dashboard cuối cùng, nhưng vẫn cần hiểu visualization vì:

---

## Kiểm tra dữ liệu nhanh

Ví dụ:

```text
Histogram của salary
```

giúp phát hiện:

- Giá trị âm
- NULL bất thường
- Dữ liệu lỗi

---

## Hiểu nhu cầu downstream

Nếu Analyst cần:

```text
Doanh thu theo tháng
```

Data Engineer cần đảm bảo:

```text
date_key
month
year
```

được chuẩn bị đầy đủ trong warehouse.

---

## Debug pipeline

Ví dụ:

```text
Doanh thu đột ngột giảm 90%
```

Line chart thường giúp phát hiện:

```text
Pipeline ETL bị lỗi
```

nhanh hơn việc đọc bảng dữ liệu thô.

---

# Tóm tắt

## Histogram

Dùng cho:

```text
Phân bố dữ liệu liên tục
```

---

## Box Plot

Dùng cho:

```text
Median
Quartiles
Outliers
```

---

## Bar Chart

Dùng cho:

```text
So sánh danh mục
```

---

## Scatter Plot

Dùng cho:

```text
Tương quan giữa 2 biến số
```

---

## Line Chart

Dùng cho:

```text
Xu hướng theo thời gian
```

---

## Sequential Colors

```text
Có thứ tự
```

---

## Diverging Colors

```text
Có điểm trung tâm
```

---

## Qualitative Colors

```text
Dữ liệu phân loại
```

---

# 🎯 Hoàn thành Track SQL Foundation

Sau 9 khóa, bạn đã nắm được:

1. Understanding Data Engineering
2. Introduction to SQL
3. Intermediate SQL
4. Joining Data in SQL
5. Introduction to Relational Databases
6. Database Design
7. Data Warehousing Concepts
8. Introduction to Snowflake SQL
9. Understanding Data Visualization

Bạn đã có nền tảng để bước sang:

- Advanced SQL
- Data Modeling
- dbt
- Python for Data Engineering
- Apache Airflow
- Modern Data Stack