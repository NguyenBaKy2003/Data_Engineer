-- SQLBook: Markup
Đây là khóa tư duy nhiều hơn là cú pháp — bạn học cách thiết kế database sao cho không bị dư thừa, không bị mâu thuẫn dữ liệu, và dễ bảo trì về lâu dài.
-- SQLBook: Markup
1. Vấn đề: Database thiết kế tồi trông như thế nào?

    Xem bảng này — một cách thiết kế tệ rất phổ biến khi mới học:


    Bảng `orders` (thiết kế tồi)
    | id | customer_name | customer_email | product_name | product_price | quantity |
    |----|--------------|----------------|--------------|--------------:|----------:|
    | 1 | Nguyễn An | an@mail.com | Chuột không dây | 250000 | 2 |
    | 2 | Nguyễn An | an@mail.com | Bàn phím cơ | 800000 | 1 |
    | 3 | Trần Bình | binh@mail.com | Chuột không dây | 250000 | 1 |

    ---
-- SQLBook: Markup
Nhìn kỹ sẽ thấy 3 vấn đề lớn:

Dư thừa dữ liệu (Redundancy): customer_name, customer_email bị lặp lại mỗi lần An mua hàng. product_price cũng lặp lại mỗi lần "Chuột không dây" xuất hiện.

Rủi ro mâu thuẫn (Update Anomaly): nếu An đổi email, bạn phải sửa ở mọi dòng có tên An — quên sửa 1 dòng là dữ liệu sai lệch ngay.
    
Không linh hoạt: nếu muốn thêm sản phẩm mới nhưng chưa có ai mua, bạn không có chỗ để lưu (vì bảng này chỉ lưu khi có đơn hàng).

Đây chính là lý do cần chuẩn hóa (Normalization).
-- SQLBook: Markup
2. Chuẩn hóa dữ liệu (Normalization)

    Ý tưởng cốt lõi: mỗi thông tin chỉ nên được lưu ở đúng MỘT nơi. Tách bảng lớn, lộn xộn thành các bảng nhỏ, mỗi bảng chỉ chứa thông tin về một chủ thể duy nhất, rồi nối chúng bằng khóa ngoại (Foreign Key — bạn học ở Khóa 5).

    Thiết kế đã chuẩn hóa:
-- SQLBook: Code
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price NUMERIC CHECK (price > 0)
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER CHECK (quantity > 0),
    order_date DATE DEFAULT CURRENT_DATE
);
-- SQLBook: Markup
Giờ: đổi email của An → sửa đúng 1 dòng trong customers. Đổi giá "Chuột không dây" → sửa đúng 1 dòng trong products. Không còn dư thừa, không còn rủi ro mâu thuẫn.


-- SQLBook: Markup
---
Các dạng chuẩn hóa (Normal Forms) — hiểu ý tưởng, không cần học thuộc định nghĩa hàn lâm


|Dạng|	Ý tưởng cốt lõi|
 |----|:--------------|
|1NF|	Mỗi ô chỉ chứa một giá trị (không nhét "Chuột, Bàn phím" chung 1 ô), mỗi dòng phải duy nhất|
|2NF|	Đạt 1NF + mọi cột không-khóa phải phụ thuộc vào toàn bộ khóa chính (áp dụng khi có composite key)|
|3NF|	Đạt 2NF + không có cột nào phụ thuộc gián tiếp qua cột khác (vd: product_price không nên nằm trong bảng orders vì nó phụ thuộc vào product_id, không phải vào order id)
---
-- SQLBook: Markup
👉 Trong thực tế công việc, bạn hiếm khi ngồi tính "đây có đạt 3NF không" — thay vào đó, quy tắc thực dụng là: "mỗi bảng chỉ nên mô tả một loại thực thể (khách hàng, sản phẩm, đơn hàng...), không trộn lẫn."

Đánh đổi: Chuẩn hóa không phải lúc nào cũng tốt nhất

Chuẩn hóa giúp dữ liệu sạch, nhưng đổi lại phải JOIN nhiều bảng hơn khi truy vấn → chậm hơn với dữ liệu rất lớn. Vì vậy trong data warehouse (bạn sẽ học ở Khóa 7), người ta đôi khi cố ý phi chuẩn hóa (denormalize) một phần — chấp nhận dư thừa dữ liệu một chút để đổi lấy tốc độ truy vấn nhanh hơn cho báo cáo.
-- SQLBook: Markup
3. Schema — bản thiết kế tổng thể

    Schema là sơ đồ mô tả toàn bộ cấu trúc database: có bảng nào, mỗi bảng có cột gì, các bảng liên kết với nhau ra sao qua khóa ngoại. Người ta thường vẽ ERD (Entity Relationship Diagram) để hình dung:

    customers (1) ──────< (N) orders (N) >────── (1) products
    
    Đọc là: "1 khách hàng có thể có nhiều đơn hàng, 1 sản phẩm có thể xuất hiện trong nhiều đơn hàng" — đây gọi là quan hệ một-nhiều (one-to-many).
-- SQLBook: Markup
4. Database Views — "bảng ảo"

    View không lưu dữ liệu thật — nó là một câu SELECT được đặt tên và lưu lại, để dùng lại nhiều lần như một bảng bình thường.
-- SQLBook: Code
CREATE VIEW order_details AS
SELECT
    o.id AS order_id,
    c.name AS customer_name,
    p.product_name,
    p.price * o.quantity AS total_price
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN products p ON o.product_id = p.id;
-- SQLBook: Markup
Giờ mỗi lần cần xem chi tiết đơn hàng, thay vì viết lại câu JOIN dài dòng, chỉ cần:
-- SQLBook: Code
SELECT * FROM order_details WHERE customer_name = 'Nguyễn An';
-- SQLBook: Markup
Vì sao dùng View?

Đơn giản hóa: giấu độ phức tạp của JOIN nhiều bảng phía sau một cái tên dễ nhớ

Bảo mật: có thể cho người khác xem order_details (VIEW) mà không cấp quyền truy cập trực tiếp vào bảng gốc chứa thông tin nhạy cảm

Nhất quán: mọi người dùng chung một định nghĩa "order_details" thay vì mỗi người tự viết JOIN theo cách khác nhau
-- SQLBook: Markup
5. Database Management — vài lệnh quản trị cơ bản
-- SQLBook: Code
-- Đổi tên bảng

ALTER TABLE orders RENAME to customer_orders;

-- Thêm cột mới

ALTER TABLE customers ADD COLUMN phone VARchar(20);

-- Xóa cột

ALTER TABLE customers DROP COLUMN phone;

-- Xóa bảng hoàn toàn (cẩn thận!)

DROP TABLE custormer_orders;
-- SQLBook: Markup
Bài tập thực hành


Bài 1 (tư duy thiết kế): Bảng sau đang thiết kế tồi — hãy chỉ ra vấn đề và viết lại thành các bảng đã chuẩn hóa (viết CREATE TABLE cho từng bảng):

bookings (
    id, student_name, student_email,
    course_name, instructor_name, instructor_email,
    booking_date
)

(Gợi ý: có 2 thực thể đang bị "nhét chung" vào bảng này cùng với thông tin booking — hãy tách ra)

Bài 2: Dựa trên thiết kế customers / products / orders ở phần bài giảng, viết một VIEW tên low_stock_alert — thực ra hãy tự thêm giả định: bảng products có thêm cột stock_quantity INTEGER, và view này chỉ hiển thị product_name, stock_quantity của những sản phẩm có stock_quantity < 10.

Bài 3 (câu hỏi lý thuyết): Vì sao trong ví dụ orders (thiết kế tồi) ở đầu bài, cột product_price lại được coi là vi phạm 3NF? (Gợi ý: nó phụ thuộc trực tiếp vào cái gì, chứ không phải vào khóa chính id của đơn hàng?)
-- SQLBook: Code

Bài 1 (tư duy thiết kế): Bảng sau đang thiết kế tồi — hãy chỉ ra vấn đề và viết lại thành các bảng đã chuẩn hóa (viết CREATE TABLE cho từng bảng):

bookings (
    id, student_name, student_email,
    course_name, instructor_name, instructor_email,
    booking_date
)

vấn đề: chưa tập trung đối tượng, đang tồn tại 3 đối tượng trong cùng 1 bảng là student,instructor và course

code lại:

create table students(
    id Serial PRIMARY KEY,
    student_name VARCHAR(200) not NULL,
    student_email VARCHAR(200) not NULL UNIQUE
)
create table courses(
    id serial PRIMARY key,
    course_name VARCHAR(200) not NULL UNIQUE,
    instructor_id int REFERENCES instructors(id),
)
create table instructors(
    id serial PRIMARY KEY,
    instructor_name VARCHAR(200) not NULL,
    instructor_email VARCHAR(200) NOT NULL UNIQUE
)

create Table bookings(
    id serial PRIMARY key,
    student_id INT REFERENCES students(id),
    course_id INT REFERENCES courses(id),
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)



-- SQLBook: Code
/* 
Bài 2: Dựa trên thiết kế customers / products / orders ở phần bài giảng,
 viết một VIEW tên low_stock_alert — thực ra hãy tự thêm giả định: 
 bảng products có thêm cột stock_quantity INTEGER, và 
 view này chỉ hiển thị product_name, stock_quantity của 
 những sản phẩm có stock_quantity < 10 .
 */


-- ALTER TABLE products ADD COLUMN stock_quantity int;



CREATE VIEW low_stock_alert as 
select product_name, stock_quantity from products 
WHERE stock_quantity <10;

select * from low_stock_alert;
-- SQLBook: Markup
Bài 3 (câu hỏi lý thuyết): Vì sao trong ví dụ orders (thiết kế tồi) ở đầu bài, cột product_price lại được coi là vi phạm 3NF? (Gợi ý: nó phụ thuộc trực tiếp vào cái gì, chứ không phải vào khóa chính id của đơn hàng?)


product_price phụ thuộc vào product_name (nếu biết tên sản phẩm, ta suy ra được giá) — chứ không phụ thuộc trực tiếp vào khóa chính id của đơn hàng. Đây gọi là phụ thuộc bắc cầu (transitive dependency): id → product_name → product_price, thay vì id → product_price trực tiếp. 3NF yêu cầu mọi cột không-khóa phải phụ thuộc trực tiếp vào khóa chính, không được đi vòng qua một cột không-khóa khác.