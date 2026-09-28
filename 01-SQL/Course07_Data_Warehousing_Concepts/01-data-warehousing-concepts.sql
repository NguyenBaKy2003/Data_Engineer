-- SQLBook: Markup
Đây là khóa lý thuyết quan trọng — nối liền mọi thứ bạn học từ Khóa 1 đến Khóa 6 lại thành một hệ thống hoàn chỉnh. Bạn sẽ hiểu vì sao các công ty không chỉ dùng 1 database như đã học, mà cần xây riêng một "kho dữ liệu".
-- SQLBook: Markup
1. OLTP vs OLAP — hai loại hệ thống khác nhau

    Đây là khái niệm nền tảng nhất của cả khóa này.
---
| |OLTP (Online Transaction Processing)|	OLAP (Online Analytical Processing)|
|--|--|:---|
|Mục đích|	Vận hành hệ thống hàng ngày	|Phân tích, báo cáo|
|Ví dụ|	Hệ thống đặt hàng của website bán hàng|	Báo cáo doanh thu theo quý|
|Dữ liệu	|Đã chuẩn hóa (như Khóa 6 vừa học)	|Thường phi chuẩn hóa để truy vấn nhanh|
|Thao tác	|Nhiều INSERT/UPDATE nhỏ, liên tục	|Ít nhưng SELECT phức tạp, quét nhiều dòng|
|Ví dụ công cụ|	PostgreSQL, MySQL	|Snowflake, BigQuery, Redshift|
-- SQLBook: Markup
👉 Bảng orders, customers, products bạn thiết kế ở Khóa 5-6 chính là kiểu OLTP — tối ưu cho việc ghi dữ liệu nhanh, chính xác, không trùng lặp.

Nhưng khi CEO hỏi "Doanh thu quý này theo từng vùng, so với năm ngoái thế nào?" — nếu chạy trực tiếp trên hệ thống OLTP đang phục vụ hàng nghìn đơn hàng/giây, câu query nặng đó sẽ làm chậm cả hệ thống bán hàng thật. Đó là lý do cần một hệ thống riêng: Data Warehouse (OLAP).
-- SQLBook: Markup
2. Data Warehouse là gì?

    Là nơi gom dữ liệu từ nhiều nguồn OLTP khác nhau (hệ thống bán hàng, hệ thống kho, hệ thống marketing...), xử lý qua ETL/ELT (nhớ lại Khóa 1), rồi tổ chức lại theo cách tối ưu cho truy vấn phân tích, không phải cho ghi dữ liệu.

    4 đặc điểm cốt lõi của Data Warehouse (theo Bill Inmon — "cha đẻ" khái niệm này):

    Subject-oriented (theo chủ đề): tổ chức theo chủ đề kinh doanh (doanh thu, khách hàng...) chứ không theo hệ thống nguồn

    Integrated (tích hợp): dữ liệu từ nhiều nguồn khác nhau được chuẩn hóa về cùng định dạng

    Non-volatile (không biến đổi): dữ liệu khi đã nạp vào warehouse thì không bị sửa/xóa như OLTP — chỉ thêm mới
    
    Time-variant (theo thời gian): lưu lịch sử theo thời gian, để so sánh "quý này vs quý trước"
-- SQLBook: Markup
3. Star Schema — cách tổ chức dữ liệu phổ biến nhất trong warehouse

      Đây là phần quan trọng nhất khóa học. Nhớ lại ở Khóa 6 bạn học chuẩn hóa để tránh dư thừa — nhưng trong warehouse, người ta cố ý làm ngược lại một phần để tăng tốc độ truy vấn.

      Star Schema gồm 2 loại bảng:

      Fact table (bảng sự kiện): chứa các số liệu đo lường (đơn giá, số lượng, doanh thu) + khóa ngoại trỏ tới các bảng chiều. Mỗi dòng là 1 sự kiện xảy ra (1 lần bán hàng).
      
      Dimension table (bảng chiều): chứa thông tin mô tả để "cắt lát" phân tích (theo sản phẩm, theo khách hàng, theo thời gian, theo địa điểm).

                  dim_customers
                        │
      dim_products ── fact_sales ── dim_date
      
                        │
                  dim_location
-- SQLBook: Code
-- Ví dụ cụ thể:

sql
CREATE TABLE dim_products (
    product_key SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);

CREATE TABLE dim_date (
    date_key SERIAL PRIMARY KEY,
    full_date DATE,
    year INT,
    quarter INT,
    month INT
);

CREATE TABLE fact_sales (
    sale_id SERIAL PRIMARY KEY,
    product_key INT REFERENCES dim_products(product_key),
    date_key INT REFERENCES dim_date(date_key),
    quantity INT,
    revenue NUMERIC
);
-- SQLBook: Markup
👉 Hình dạng giống ngôi sao: 1 bảng fact ở giữa, các bảng dimension tỏa ra xung quanh — đó là lý do gọi "star schema". Nhờ cấu trúc này, câu hỏi "doanh thu theo quý, theo loại sản phẩm" chỉ cần JOIN 1-2 tầng, thay vì JOIN qua rất nhiều bảng chuẩn hóa sâu như hệ OLTP.
-- SQLBook: Markup
4. Snowflake Schema — biến thể chuẩn hóa hơn của Star Schema

      Nếu bảng dimension (ví dụ dim_products) lại được tách tiếp thành bảng con (ví dụ dim_products tách ra dim_category riêng), ta có Snowflake Schema:

      dim_products ── dim_category

                  │
            
            fact_sales

---
||Star Schema|	Snowflake Schema|
|--|--|:--|
|Dimension|	Phi chuẩn hóa (gộp hết thông tin)|	Chuẩn hóa (tách nhỏ tiếp)|
|Truy vấn|	Nhanh hơn (ít JOIN)|	Chậm hơn (nhiều JOIN)|
|Dung lượng|	Tốn hơn (dư thừa)|	Tiết kiệm hơn|
|Độ phổ biến|	Phổ biến hơn trong thực tế|	Ít dùng hơn, phù hợp khi dimension rất lớn|

👉 Đây chính là cái tên "Snowflake" mà bạn sẽ gặp lại ở Khóa 8 (Introduction to Snowflake SQL) — công cụ này lấy tên từ chính kiểu schema này.
      
-- SQLBook: Markup
5. Kho dữ liệu chuyên biệt: Data Mart

Data Mart là một "phiên bản thu nhỏ" của data warehouse, chỉ phục vụ một phòng ban cụ thể (vd: sales_data_mart chỉ chứa dữ liệu cho phòng Sales, không lẫn dữ liệu HR hay Marketing). Giúp phòng ban truy cập nhanh, không phải "lọc" qua toàn bộ warehouse khổng lồ.

    Data Warehouse (toàn công ty)
        ├── Data Mart: Sales
        ├── Data Mart: Marketing
        └── Data Mart: Finance
-- SQLBook: Markup
6. Implementation — triển khai thực tế

    Quy trình một pipeline data warehouse điển hình:

    Extract: lấy dữ liệu thô từ các hệ OLTP (đơn hàng, khách hàng...)

    Transform: làm sạch, tính toán, chuyển về dạng fact/dimension

    Load: nạp vào warehouse theo star schema
    
    Chạy định kỳ (hàng ngày/hàng giờ) qua công cụ lập lịch — chính là Apache Airflow bạn sẽ học ở track Python sau này (Khóa 14)
-- SQLBook: Markup
Bài tập thực hành

Bài 1 (lý thuyết): Một công ty có hệ thống website bán hàng (ghi đơn hàng liên tục mỗi giây) và một hệ thống báo cáo cho ban giám đốc xem doanh thu hàng tháng. Hãy giải thích: vì sao không nên để ban giám đốc chạy báo cáo trực tiếp trên database của website bán hàng?

Bài 2 (thiết kế): Một chuỗi rạp chiếu phim muốn phân tích doanh thu vé theo: bộ phim, rạp chiếu, và ngày chiếu. Hãy thiết kế star schema cho bài toán này — viết CREATE TABLE cho 1 bảng fact (fact_ticket_sales) và 3 bảng dimension tương ứng (phim, rạp, ngày).

Bài 3 (so sánh): Nếu bảng dim_movies của bạn ở Bài 2 chứa cả thông tin director_name, director_nationality ngay trong bảng, đây là star hay snowflake schema? Nếu muốn chuyển sang schema còn lại, bạn sẽ làm gì?

Bài 4 (nhận diện): Cho 2 mô tả hệ thống sau, hệ thống nào là OLTP, hệ thống nào là OLAP?

(a) Hệ thống quẹt thẻ ATM xử lý hàng nghìn giao dịch rút tiền mỗi phút
(b) Hệ thống cho phép nhà phân tích tài chính xem xu hướng chi tiêu của khách hàng theo từng quý trong 5 năm qua
-- SQLBook: Code
-- Bài 1 (lý thuyết): Một công ty có hệ thống website bán hàng (ghi đơn hàng liên tục mỗi giây) và một hệ thống báo cáo cho ban giám đốc xem doanh thu hàng tháng. Hãy giải thích: vì sao không nên để ban giám đốc chạy báo cáo trực tiếp trên database của website bán hàng?
Vì khi truy vấn trên database của website có hàng triệu bản ghi thì có thể làm chậm toàn bộ hệ thống mà khách hàng đang dùng. 
dữ liệu OLTP còn ở dạng chuẩn hóa sâu (nhiều bảng nhỏ) nên báo cáo "doanh thu theo tháng" sẽ phải JOIN rất nhiều bảng, chạy chậm và phức tạp hơn nhiều so với một fact table đã được chuẩn bị sẵn trong warehouse.
-- SQLBook: Code
-- Bài 2 (thiết kế): Một chuỗi rạp chiếu phim muốn phân tích doanh thu vé theo: bộ phim, rạp chiếu, và ngày chiếu. Hãy thiết kế star schema cho bài toán này — viết CREATE TABLE cho 1 bảng fact (fact_ticket_sales) và 3 bảng dimension tương ứng (phim, rạp, ngày).

CREATE Table dim_movies(
    id serial PRIMARY KEY,
    name VARCHAR(200) not null
);
create table dim_cinemas(
    id serial PRIMARY KEY,
    name VARCHAR(200) not null
);
CREATE Table dim_dates(
    id serial PRIMARY KEY,
    date TIMESTAMP DEFAULT current_timestamp
);
CREATE TABLE fact_ticket_sales (
    id SERIAL PRIMARY KEY,
    movies_id INT REFERENCES dim_movies(id),
    cinema_id INT REFERENCES dim_cinemas(id),
    date_id INT REFERENCES dim_dates(id),
    tickets_sold INT,
    revenue NUMERIC
);
-- SQLBook: Code
-- Bài 3 (so sánh): Nếu bảng dim_movies của bạn ở Bài 2 chứa cả thông tin director_name, director_nationality ngay trong bảng, đây là star hay snowflake schema? Nếu muốn chuyển sang schema còn lại, bạn sẽ làm gì?
Nếu có director_name và director_nationality ngay trong bảng dim_movies thì đây là Star Schema, nếu muốn đổi sang SnowFlake schema thì tách ra thành bảng dim_director

-- SQLBook: Code
-- Bài 4 (nhận diện): Cho 2 mô tả hệ thống sau, hệ thống nào là OLTP, hệ thống nào là OLAP?

-- (a) Hệ thống quẹt thẻ ATM xử lý hàng nghìn giao dịch rút tiền mỗi phút
-- (b) Hệ thống cho phép nhà phân tích tài chính xem xu hướng chi tiêu của khách hàng theo từng quý trong 5 năm qua

a là OLTP b là OLAP 
