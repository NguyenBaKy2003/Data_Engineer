-- SQLBook: Markup
1. Database & Table là gì?

Một database giống như một cuốn sổ lớn, bên trong có nhiều table (bảng) — mỗi bảng giống một sheet Excel, có hàng (row) và cột (column).
-- SQLBook: Code
INSERT INTO employees
(name, department, salary, hire_date)
VALUES
('Nguyễn An', 'Data', 25000000, '2021-03-01'),
('Trần Bình', 'Sales', 18000000, '2022-06-15'),
('Lê Chi', 'Data', 22000000, '2023-01-10'),
('Phạm Dung', 'Marketing', 20000000, '2020-11-20'),
('Hoàng Em', 'Data', 30000000, '2019-05-05');


-- SQLBook: Markup
2. Câu lệnh SELECT — nền tảng của mọi truy vấn.
SELECT column1, column2
FROM table_name;
-- SQLBook: Markup
Ví dụ: lấy tên và lương của tất cả nhân viên:
-- SQLBook: Code
SELECT name, salary
FROM employees;
-- SQLBook: Markup
Muốn lấy toàn bộ cột, dùng dấu *:
-- SQLBook: Code
SELECT *
FROM employees;
-- SQLBook: Markup
3. WHERE — lọc dữ liệu

-- SQLBook: Code
SELECT name, salary
FROM employees
WHERE department = 'Data';
-- → Chỉ lấy nhân viên phòng Data (Nguyễn An, Lê Chi, Hoàng Em)
-- SQLBook: Code
Các toán tử so sánh hay dùng:

Toán tử	    Ý nghĩa	                Ví dụ
=	        bằng	                WHERE department = 'Data'
> < >= <=	lớn hơn/nhỏ hơn	        WHERE salary > 20000000
!= hoặc <>	khác	                WHERE department != 'Sales'
AND / OR	kết hợp nhiều điều kiện	WHERE department = 'Data' AND salary > 25000000
BETWEEN	    trong khoảng	        WHERE salary BETWEEN 20000000 AND 28000000
-- SQLBook: Markup
4. ORDER BY — sắp xếp
-- SQLBook: Code
SELECT name, salary
FROM employees
ORDER BY salary DESC;
-- → Sắp xếp lương từ cao xuống thấp (DESC = giảm dần, ASC = tăng dần, mặc định là ASC)
-- SQLBook: Markup
5. LIMIT — giới hạn số dòng kết quả
-- SQLBook: Code
SELECT name, salary
FROM employees
ORDER BY salary DESC
LIMIT 3;
-- → Lấy 3 người có lương cao nhất
-- SQLBook: Markup
Bài tập thực hành

Dựa vào bảng employees ở trên, bạn hãy tự viết câu lệnh SQL cho các yêu cầu sau (viết ra đây, mình sẽ kiểm tra):


1. Lấy tên và ngày vào làm (hire_date) của tất cả nhân viên.

2. Lấy tên và lương của những người có lương trên 20 triệu.

3. Lấy tên của nhân viên phòng Marketing hoặc Sales.

4. Sắp xếp tất cả nhân viên theo ngày vào làm từ sớm nhất đến muộn nhất.

5. Lấy tên của 2 người có lương thấp nhất.
-- SQLBook: Code
-- 1. Lấy tên và ngày vào làm (hire_date) của tất cả nhân viên.
SELECT name, hire_date from employees
-- SQLBook: Code
-- 2. Lấy tên và lương của những người có lương trên 20 triệu.
select name, salary from employees where salary > 20000000
-- SQLBook: Code
-- 3. Lấy tên của nhân viên phòng Marketing hoặc Sales.
select name from employees 
WHERE department = 'Marketing' OR department='Sales'
-- SQLBook: Code
-- 4. Sắp xếp tất cả nhân viên theo ngày vào làm từ sớm nhất đến muộn nhất.
SELECT * from employees 
ORDER BY hire_date ASC
-- SQLBook: Code
-- 5. Lấy tên của 2 người có lương thấp nhất.
select * from employees
ORDER BY salary ASC
limit 2