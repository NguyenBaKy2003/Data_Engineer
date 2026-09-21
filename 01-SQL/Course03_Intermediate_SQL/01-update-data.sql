-- SQLBook: Markup
Khóa 3: Intermediate SQL

Ở khóa này bạn học cách tổng hợp dữ liệu (đếm, tính tổng, trung bình theo nhóm) — đây là kỹ năng dùng nhiều nhất trong công việc thực tế, ví dụ "lương trung bình mỗi phòng ban là bao nhiêu?"

Vẫn dùng bảng employees cũ, mình thêm vài dòng cho phong phú:
-- SQLBook: Code
INSERT INTO employees
(name, department, salary, hire_date)
VALUES
('Hoàng Em', 'Data', 30000000, '2019-05-05'),
('Vũ Phong', 'Sales', 19000000, '2021-08-01'),
('Đỗ Giang', 'Marketing', 21000000, '2022-02-14');


-- SQLBook: Markup
1. Hàm tổng hợp (Aggregate Functions)

|Hàm|	                        Ý nghĩa

|COUNT(*)	                đếm số dòng
|SUM(column)	                tính tổng
|AVG(column)	                tính trung bình
|MIN(column) / MAX(column)	giá trị nhỏ nhất / lớn nhất
-- SQLBook: Code
SELECT COUNT(*) FROM employees;
-- → 7 (tổng số nhân viên)


SELECT AVG(salary) FROM employees;
-- → lương trung bình toàn công ty
-- SQLBook: Markup
2. GROUP BY — tổng hợp theo nhóm

Đây là phần quan trọng nhất khóa này. GROUP BY gom các dòng có cùng giá trị lại thành 1 nhóm, rồi áp hàm tổng hợp lên từng nhóm.
-- SQLBook: Code
select department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;
-- SQLBook: Markup
Kết quả:

department	avg_salary


Data	25666667

Sales	18500000

Marketing	20500000
-- SQLBook: Markup
👉 Cách hiểu trực quan: "Với mỗi phòng ban, tính lương trung bình của các nhân viên trong phòng đó."

Quy tắc quan trọng: trong SELECT, mọi cột không nằm trong hàm tổng hợp (AVG, SUM...) thì bắt buộc phải xuất hiện trong GROUP BY. Ví dụ này sai:
-- SQLBook: Code
-- ❌ SAI: name không nằm trong GROUP BY và cũng không phải hàm tổng hợp
SELECT department, name, AVG(salary) FROM employees GROUP BY department;
-- SQLBook: Markup
3. HAVING — lọc SAU khi đã GROUP BY

WHERE lọc dòng dữ liệu gốc (trước khi gom nhóm). HAVING lọc kết quả sau khi đã tổng hợp.
-- SQLBook: Code
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 20000000;
-- → Chỉ giữ lại các phòng ban có lương trung bình > 20 triệu (Data và Marketing)
-- SQLBook: Markup
4. CASE WHEN — logic điều kiện (giống IF/ELSE)
-- SQLBook: Code
Select name, salary, 
CASE 
    WHEN salary >= 25000000  THEN  'Cao'
    WHEN salary >= 20000000  THEN  'Trung binh'

    ELSE  'Thap'
END AS salary_level
From employees;
-- SQLBook: Markup
Bài tập thực hành

1. Đếm số lượng nhân viên trong mỗi phòng ban.

2. Tính tổng lương (SUM) của toàn công ty.

3. Lấy ra các phòng ban có từ 2 nhân viên trở lên (gợi ý: dùng COUNT + HAVING).

4. Viết CASE WHEN phân loại nhân viên thành 'Cũ' (vào làm trước 2021) và 'Mới' (từ 2021 trở đi), dựa trên hire_date.


5. Bài tổng hợp (kết hợp mọi thứ đã học):
 
    Lấy tên phòng ban và lương trung bình, chỉ hiển thị những phòng có lương trung bình > 19 triệu, sắp xếp theo lương trung bình giảm dần.
-- SQLBook: Code
-- 1. Đếm số lượng nhân viên trong mỗi phòng ban.
select department, COUNT(*) as total_employer from employees
GROUP BY department;

-- SQLBook: Code
-- 2. Tính tổng lương (SUM) của toàn công ty.
SELECT SUM(salary) from employees;
-- SQLBook: Code
-- 3. Lấy ra các phòng ban có từ 2 nhân viên trở lên (gợi ý: dùng COUNT + HAVING).
select department, COUNT(*) as total_employer from employees
GROUP BY department
HAVING count(*) >=2;
-- SQLBook: Code
-- 4. Viết CASE WHEN phân loại nhân viên thành 'Cũ' (vào làm trước 2021) và 'Mới' (từ 2021 trở đi), dựa trên hire_date.
select name, hire_date, CASE 
    WHEN EXTRACT(YEAR FROM hire_date)< 2021  THEN 'Cu' 
    ELSE  'Moi'
END as employer_type
 from employees;
-- SQLBook: Code
/*
5. Bài tổng hợp (kết hợp mọi thứ đã học):
    Lấy tên phòng ban và lương trung bình, chỉ hiển thị những phòng có lương trung bình > 19 triệu, sắp xếp theo lương trung bình giảm dần.
*/

select department, AVG(salary) as avg_salary
from employees
GROUP BY department
HAVING AVG(salary) >19000000
ORDER BY avg(salary) DESC;