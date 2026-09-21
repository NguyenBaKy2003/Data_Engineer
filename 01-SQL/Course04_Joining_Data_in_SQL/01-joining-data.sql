-- SQLBook: Markup
Đây là kỹ năng quan trọng bậc nhất với Data Engineer — trong thực tế, dữ liệu gần như luôn nằm rải rác ở nhiều bảng khác nhau, và bạn phải biết cách ghép chúng lại.


Thêm bảng employees_join, mình thêm bảng departments_join:
-- SQLBook: Code
Create Table departments_join(
    id int generated always as Identity PRIMARY KEY,
    dept_name VARCHAR(100),
    location VARCHAR(100)
);
CREATE Table employees_join(
    id INT generated always as IDENTITY PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    salary BIGINT,
    Constraint fk_employees_department FOREIGN KEY (department_id) REFERENCES departments_join(id)
)

-- SQLBook: Markup
Thêm dữ liệu bảng departments_join
-- SQLBook: Code
INSERT INTO departments_join(dept_name, location) 
VALUES 
('Data','Hà Nội'),
('Sales','TP.HCM'),
('Marketing','Đà Nẵng'),
('HR','Hà Nội');
-- SQLBook: Markup
Thêm dữ liệu bảng employees_join
-- SQLBook: Code
INSERT INTO employees_join(name, department_id,salary) 
VALUES 
('Nguyễn An',1,25000000),
('Trần Bình',2,18000000),
('Lê Chi',1,22000000),
('Phạm Dung',3,20000000),
('Hoàng Em',1,30000000),
('Vũ Phong',null,19000000)
-- SQLBook: Code
select * from employees_join;
select * FROM departments_join;
-- SQLBook: Markup
1. INNER JOIN — chỉ lấy dòng khớp ở CẢ HAI bảng

-- SQLBook: Code
select e.name , e.salary, d.dept_name, d.location
FROM employees_join e
INNER JOIN departments_join d ON e.department_id= d.id 
-- SQLBook: Markup
👉 e và d là alias (tên viết tắt) giúp câu lệnh ngắn gọn hơn khi phải nhắc lại tên bảng nhiều lần.

Kết quả: chỉ có 5 dòng (Vũ Phong bị loại vì không có department_id khớp; phòng HR cũng không xuất hiện vì không có nhân viên nào khớp).
-- SQLBook: Markup
2. LEFT JOIN — giữ TOÀN BỘ bảng bên trái, dù có khớp hay không
-- SQLBook: Code
SELECT e.name, d.dept_name FROM employees_join  e
LEFT JOIN departments_join d ON e.department_id= d.id;
-- SQLBook: Markup
Kết quả: giữ lại cả Vũ Phong, nhưng cột dept_name của anh ấy sẽ là NULL (vì không tìm thấy phòng ban tương ứng).

Hình dung trực quan:

INNER JOIN  →  chỉ lấy phần giao nhau (cả 2 bên đều có)

LEFT JOIN   →  lấy toàn bộ bảng trái + phần giao với bảng phải (thiếu thì NULL)


👉 Đây là 2 loại JOIN dùng nhiều nhất trong công việc thực tế. Còn RIGHT JOIN (ngược lại LEFT JOIN) và FULL JOIN (giữ cả 2 bên) ít dùng hơn — bạn có thể luôn thay RIGHT JOIN bằng LEFT JOIN (chỉ cần đổi thứ tự bảng).
-- SQLBook: Markup
3. UNION — ghép DỌC hai kết quả (không phải ghép cột như JOIN)

JOIN ghép cột (mở rộng theo chiều ngang), còn UNION ghép dòng (nối theo chiều dọc) — yêu cầu 2 câu SELECT phải có cùng số cột, cùng kiểu dữ liệu.

UNION tự động loại bỏ dòng trùng lặp. Nếu muốn giữ cả trùng lặp, dùng UNION ALL (chạy nhanh hơn vì không cần kiểm tra trùng).
-- SQLBook: Code
SELECT name FROM employees_join WHERE department_id = 1
UNION 
SELECT dept_name from departments_join; 
-- SQLBook: Markup
4. Subquery — câu truy vấn lồng trong câu truy vấn khác

-- SQLBook: Code
SELECT name, salary 
FROM employees_join 
WHERE department_id IN( SELECT id FROM departments_join WHERE location = 'Hà Nội');
-- SQLBook: Markup
👉 Câu lệnh bên trong dấu ngoặc (...) chạy trước, trả về danh sách id các phòng ban ở Hà Nội (là 1 và 4), rồi câu lệnh ngoài dùng kết quả đó để lọc nhân viên.

So sánh nhanh subquery vs JOIN: thường 2 cách này có thể thay thế nhau, nhưng JOIN thường viết rõ ràng hơn khi cần lấy dữ liệu từ nhiều cột của bảng kia; subquery hợp khi chỉ cần kiểm tra điều kiện (như ví dụ trên).
-- SQLBook: Markup
Bài tập thực hành

1. Viết INNER JOIN để lấy tên nhân viên, lương, và địa điểm làm việc (location) của họ.

2. Viết LEFT JOIN để liệt kê tất cả phòng ban, kèm tên nhân viên (dùng bảng departments bên trái) — phòng nào chưa có ai thì tên nhân viên hiển thị NULL.


3. Dùng subquery: lấy tên các nhân viên có lương cao hơn lương trung bình toàn công ty.

4. Dùng subquery: lấy tên các phòng ban (dept_name) chưa có nhân viên nào (gợi ý: dùng NOT IN).


5. Câu khó hơn: Viết LEFT JOIN kết hợp GROUP BY để đếm số nhân viên trong từng phòng ban — kể cả phòng ban chưa có ai (kết quả sẽ là 0, không phải NULL — gợi ý dùng COUNT(e.id) thay vì COUNT(*)).
-- SQLBook: Code
-- 1. Viết INNER JOIN để lấy tên nhân viên, lương, và địa điểm làm việc (location) của họ.

SELECT e.name, e.salary, d.location 
FROM employees_join e
JOIN departments_join d on e.department_id=d.id;
-- SQLBook: Code
-- 2. Viết LEFT JOIN để liệt kê tất cả phòng ban, kèm tên nhân viên (dùng bảng departments bên trái) — phòng nào chưa có ai thì tên nhân viên hiển thị NULL.

select d.dept_name, e.name 
FROM departments_join d LEFT JOIN employees_join e on d.id= e.department_id;
-- SQLBook: Code
-- 3. Dùng subquery: lấy tên các nhân viên có lương cao hơn lương trung bình toàn công ty.

select name from employees_join
WHERE salary > (
    select AVG(salary) from employees_join
) 
-- SQLBook: Code
-- 4. Dùng subquery: lấy tên các phòng ban (dept_name) chưa có nhân viên nào (gợi ý: dùng NOT IN).
select dept_name FROM
departments_join where id not in(
     select DISTINCT( department_id) from employees_join WHERE department_id IS not NULL
)
-- SQLBook: Code
-- 5. Câu khó hơn: Viết LEFT JOIN kết hợp GROUP BY để đếm số nhân viên trong từng phòng ban — kể cả phòng ban chưa có ai (kết quả sẽ là 0, không phải NULL — gợi ý dùng COUNT(e.id) thay vì COUNT(*)).

select d.dept_name, COUNT(e.id) from departments_join d
LEFT JOIN employees_join e on d.id= e.department_id
GROUP BY d.dept_name;