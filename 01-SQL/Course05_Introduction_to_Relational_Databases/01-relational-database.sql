-- SQLBook: Markup
Đến đây bạn đã biết truy vấn dữ liệu (SELECT, JOIN...). Giờ chuyển sang việc tạo ra database — vai trò thực sự của Data Engineer, vì Data Analyst thường chỉ SELECT, còn Data Engineer là người thiết kế và xây bảng.
-- SQLBook: Code
-- 1. CREATE TABLE — tạo bảng mới 
CREATE TABLE employees_cs5 (
    id INTEGER,
    name VARCHAR(100),
    salary NUMERIC,
    hire_date DATE
);
-- SQLBook: Markup
---

## Các kiểu dữ liệu phổ biến

| Kiểu dữ liệu | Dùng cho | Ví dụ |
|-------------|----------|--------|
| `INTEGER` / `INT` | Số nguyên | 1, 2500 |
| `NUMERIC` / `DECIMAL` | Số thập phân chính xác | 25000000.50 |
| `VARCHAR(n)` | Chuỗi ký tự giới hạn độ dài | 'Nguyễn An' |
| `TEXT` | Chuỗi dài | Mô tả sản phẩm |
| `DATE` | Ngày tháng | 2021-03-01 |
| `BOOLEAN` | Đúng/Sai | TRUE, FALSE |

---


👉 Lưu ý quan trọng: dùng NUMERIC chứ không phải FLOAT cho dữ liệu tiền tệ — FLOAT có thể làm tròn sai số thập phân, rất nguy hiểm khi tính lương/hóa đơn.
-- SQLBook: Markup
2. Ràng buộc dữ liệu (Attribute Constraints) — ép dữ liệu phải "sạch" ngay từ đầu

    Đây là điểm khác biệt lớn giữa "biết viết SQL" và "biết thiết kế database tốt": thay vì để dữ liệu bẩn lọt vào rồi mới clean sau (như Khóa 7 sắp học), bạn ngăn chặn dữ liệu sai ngay từ lúc tạo bảng.
-- SQLBook: Code
CREATE TABLE employees_clean (
    id INTEGER,
    name VARCHAR(100) NOT NULL,
    salary NUMERIC CHECK (salary > 0),
    email VARCHAR(255) UNIQUE,
    department VARCHAR(50) DEFAULT 'Chưa phân bổ'
);
-- SQLBook: Markup
|Ràng buộc |	Ý nghĩa|
|-------------|--------|
|NOT NULL|	bắt buộc phải có giá trị, không được để trống|
|UNIQUE|	giá trị không được trùng lặp giữa các dòng|
|CHECK| (điều kiện)	tự đặt điều kiện logic (vd: lương phải > 0)|
|DEFAULT| giá_trị	nếu không nhập, tự điền giá trị mặc định|
-- SQLBook: Markup
Nếu bạn cố INSERT một dòng vi phạm ràng buộc (ví dụ salary = -5000), database sẽ từ chối và báo lỗi ngay — đây chính là cách "khóa chặt" chất lượng dữ liệu ngay từ tầng thiết kế.
-- SQLBook: Markup
3. Khóa chính (PRIMARY KEY) — định danh duy nhất cho mỗi dòng

-- SQLBook: Code
CREATE TABLE employees_prikey (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    salary NUMERIC
);
-- SQLBook: Markup
PRIMARY KEY = kết hợp của NOT NULL + UNIQUE, dùng để đảm bảo mỗi dòng có một định danh riêng biệt, không trùng, không rỗng. Mỗi bảng chỉ nên có một primary key.

Thường dùng kèm SERIAL (PostgreSQL) để tự động tăng số:
-- SQLBook: Code
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,   -- tự động sinh 1, 2, 3... không cần tự nhập
    name VARCHAR(100) NOT NULL
);
-- SQLBook: Markup
Khóa chính hợp thành (Composite Key) — khi 1 cột không đủ để định danh duy nhất:
-- SQLBook: Code
CREATE TABLE enrollments (
    student_id INTEGER,
    course_id INTEGER,
    enroll_date DATE,
    PRIMARY KEY (student_id, course_id)  -- kết hợp 2 cột mới là duy nhất
);
-- SQLBook: Markup
→ Một sinh viên có thể học nhiều khóa, một khóa có nhiều sinh viên, nhưng cặp (sinh viên, khóa) đó chỉ xuất hiện một lần.
-- SQLBook: Markup
4. Khóa ngoại (FOREIGN KEY) — kết nối giữa các bảng

    Đây là thứ biến các bảng rời rạc thành một database quan hệ (relational) thực thụ — chính là chữ "Relational" trong tên khóa học.
-- SQLBook: Code
CREATE TABLE departments_foreign (
    id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE employees_foreign (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INTEGER REFERENCES departments(id)   -- đây là foreign key
    -- Constraint fk_employees_department FOREIGN KEY (department_id) REFERENCES departments_join(id) cau truc cua PostgreSQL

);
-- SQLBook: Markup
department_id INTEGER REFERENCES departments(id) nghĩa là: giá trị của cột department_id phải khớp với một id đã tồn tại trong bảng departments.

👉 Đây chính là lý do ở Khóa 4, khi bạn JOIN 2 bảng qua e.department_id = d.id, cặp cột đó luôn khớp được — vì FOREIGN KEY đã đảm bảo tính toàn vẹn này ngay từ khi dữ liệu được nhập vào, database sẽ từ chối nếu bạn cố gán department_id = 99 mà bảng departments không có id = 99.

Đây gọi là referential integrity (toàn vẹn tham chiếu) — một trong những khái niệm cốt lõi nhất của relational database.
-- SQLBook: Markup
Bài tập thực hành

1. Viết CREATE TABLE cho bảng products gồm: id (khóa chính, tự tăng), product_name (bắt buộc có), price (phải lớn hơn 0), sku (mã sản phẩm, không được trùng nhau giữa các dòng).

2. Viết CREATE TABLE cho bảng orders gồm: id (khóa chính tự tăng), product_id (khóa ngoại tham chiếu đến bảng products), quantity, order_date — nếu order_date không nhập thì mặc định lấy ngày hiện tại (gợi ý: DEFAULT CURRENT_DATE).

3. Giải thích ngắn gọn (không cần code): Vì sao khi thiết kế bảng enrollments (sinh viên đăng ký khóa học), ta nên dùng composite primary key (student_id, course_id) thay vì chỉ dùng id tự tăng đơn giản?

4. Cho biết lỗi sai trong đoạn code sau và sửa lại:
sql

    CREATE TABLE payments (
        id INTEGER,
        amount FLOAT,
        customer_email VARCHAR(255)
    );

    (Gợi ý: có 2 vấn đề — một về kiểu dữ liệu, một về thiếu ràng buộc)
-- SQLBook: Code
-- 1. Viết CREATE TABLE cho bảng products gồm: id (khóa chính, tự tăng), product_name (bắt buộc có), price (phải lớn hơn 0), sku (mã sản phẩm, không được trùng nhau giữa các dòng).

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) CHECK (price > 0),
    sku VARCHAR(100) UNIQUE
);

-- SQLBook: Code
-- Viết CREATE TABLE cho bảng orders gồm: id (khóa chính tự tăng), product_id (khóa ngoại tham chiếu đến bảng products), quantity, order_date — nếu order_date không nhập thì mặc định lấy ngày hiện tại (gợi ý: DEFAULT CURRENT_DATE).

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    quantity BIGINT CHECK (quantity > 0),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    product_id INT,
    CONSTRAINT fk_order_product FOREIGN KEY (product_id) REFERENCES products(id)
);
-- SQLBook: Code
-- Giải thích ngắn gọn (không cần code): Vì sao khi thiết kế bảng enrollments (sinh viên đăng ký khóa học), ta nên dùng composite primary key (student_id, course_id) thay vì chỉ dùng id tự tăng đơn giản?

Vì một khóa học có nhiều sinh viên đăng ký, và sinh viên có thể đăng ký nhiều khóa học nên cặp course_id và student_id phải là cặp khóa chính vì như thế mới xác định sinh viên nào đăng ký khóa học nào. Và tránh sinh viên đăng ký lặp khóa học.
-- SQLBook: Code
-- 4 Cho biết lỗi sai trong đoạn code sau và sửa lại:
CREATE TABLE payments (
    id INTEGER,
    amount FLOAT,
    customer_email VARCHAR(255)
);

Lỗi không có khóa chính, amount đang là Float và đang chưa có điều kiện check nếu bé hơn 0, nên thay bằng Numeric hoặc Demacial()/ number trong postgreSQL  và thêm đièu kiên check amount >0.
Sửa
CREATE TABLE payments (
    id INTEGER PRIMARY KEY,
    amount NUMERIC CHECK (amount > 0),
    customer_email VARCHAR(255)
);
