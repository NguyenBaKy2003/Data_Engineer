-- SQLBook: Markup
Project Bonus 1: Analyzing Students' Mental Health

Đây là lúc bạn ghép toàn bộ 9 khóa lại với nhau — không còn bài tập tách rời từng kỹ năng nữa, mà một bộ dữ liệu thật, bạn tự quyết định dùng công cụ nào (SELECT, JOIN, GROUP BY, CASE WHEN, subquery, VIEW) để trả lời câu hỏi kinh doanh.

Bước 1: Dựng dữ liệu

Copy đoạn SQL dưới đây, chạy trên PostgreSQL local của bạn (hoặc DB Fiddle / SQLite Online nếu chưa cài Postgres) để tạo dữ liệu:
-- SQLBook: Code
CREATE TABLE majors (
    major_id SERIAL PRIMARY KEY,
    major_name VARCHAR(100) NOT NULL,
    faculty VARCHAR(100) NOT NULL
);

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    age INTEGER,
    gender VARCHAR(10),
    year_of_study INTEGER,
    major_id INTEGER REFERENCES majors(major_id),
    cgpa NUMERIC(3,2),
    study_hours_per_week INTEGER,
    sleep_hours_per_night NUMERIC(3,1),
    stress_level INTEGER,       -- thang điểm 1-10
    anxiety_score INTEGER,      -- thang điểm 1-10
    depression_score INTEGER,   -- thang điểm 1-10
    physical_activity_hours_per_week NUMERIC(4,1),
    social_support_score INTEGER,  -- thang điểm 1-10
    counseling_visits INTEGER      -- số lần đã đi tư vấn tâm lý
);

INSERT INTO majors (major_name, faculty) VALUES
('Computer Science', 'Engineering'),
('Psychology', 'Social Sciences'),
('Business Administration', 'Business'),
('Mechanical Engineering', 'Engineering'),
('Nursing', 'Health Sciences'),
('Fine Arts', 'Arts');

INSERT INTO students (age, gender, year_of_study, major_id, cgpa, study_hours_per_week, sleep_hours_per_night, stress_level, anxiety_score, depression_score, physical_activity_hours_per_week, social_support_score, counseling_visits) VALUES
(19, 'Female', 1, 1, 3.20, 25, 6.0, 7, 6, 4, 2.0, 6, 0),
(20, 'Male', 2, 1, 2.90, 30, 5.5, 8, 7, 6, 1.0, 4, 2),
(21, 'Male', 3, 1, 3.50, 20, 7.0, 5, 4, 3, 4.0, 8, 0),
(22, 'Female', 4, 1, 3.80, 15, 7.5, 4, 3, 2, 3.0, 9, 0),
(19, 'Female', 1, 2, 3.60, 18, 7.0, 6, 5, 4, 3.5, 7, 1),
(20, 'Female', 2, 2, 3.40, 22, 6.5, 7, 6, 5, 2.5, 6, 3),
(21, 'Male', 3, 2, 3.10, 28, 5.0, 9, 8, 7, 1.0, 3, 5),
(22, 'Female', 4, 2, 3.70, 16, 7.5, 5, 4, 3, 3.0, 8, 1),
(19, 'Male', 1, 3, 2.80, 24, 6.0, 6, 5, 4, 2.0, 5, 0),
(20, 'Male', 2, 3, 3.00, 26, 5.5, 7, 6, 5, 1.5, 5, 1),
(21, 'Female', 3, 3, 3.30, 20, 6.5, 6, 5, 4, 2.5, 7, 0),
(22, 'Male', 4, 3, 3.55, 18, 7.0, 4, 3, 2, 3.0, 8, 0),
(19, 'Male', 1, 4, 2.70, 32, 5.0, 9, 8, 7, 0.5, 3, 4),
(20, 'Female', 2, 4, 2.95, 30, 5.5, 8, 7, 6, 1.0, 4, 3),
(21, 'Male', 3, 4, 3.20, 24, 6.0, 7, 6, 5, 2.0, 5, 2),
(22, 'Female', 4, 4, 3.45, 20, 6.5, 6, 5, 4, 2.5, 6, 1),
(19, 'Female', 1, 5, 3.65, 22, 7.0, 5, 4, 3, 3.0, 7, 0),
(20, 'Female', 2, 5, 3.50, 24, 6.5, 6, 5, 4, 2.5, 6, 1),
(21, 'Male', 3, 5, 3.35, 26, 6.0, 7, 6, 5, 2.0, 5, 2),
(22, 'Female', 4, 5, 3.75, 18, 7.5, 4, 3, 2, 3.5, 9, 0),
(19, 'Male', 1, 6, 3.10, 15, 6.5, 5, 5, 4, 4.0, 7, 0),
(20, 'Female', 2, 6, 3.25, 16, 7.0, 4, 4, 3, 3.5, 8, 0),
(21, 'Male', 3, 6, 2.95, 20, 6.0, 6, 6, 5, 2.5, 6, 1),
(22, 'Female', 4, 6, 3.55, 14, 7.5, 3, 3, 2, 4.0, 9, 0);
-- SQLBook: Markup
24 sinh viên thuộc 6 ngành học, có đủ chỉ số: điểm CGPA, giờ học, giờ ngủ, mức độ stress/lo âu/trầm cảm, hoạt động thể chất, mức hỗ trợ xã hội, số lần tư vấn tâm lý.
-- SQLBook: Markup
Bước 2: Nhiệm vụ phân tích

Làm lần lượt theo thứ tự — mỗi câu dùng kỹ năng bạn đã học ở các khóa trước, độ khó tăng dần:

Nhiệm vụ 1 — Khám phá cơ bản (Khóa 2-3)
Tìm mức stress trung bình, lo âu trung bình, và số giờ ngủ trung bình của toàn bộ sinh viên.

Nhiệm vụ 2 — Phân tích theo nhóm (Khóa 3)
Với mỗi year_of_study (năm 1-4), tính: số lượng sinh viên, stress trung bình, CGPA trung bình. Sắp xếp theo stress trung bình giảm dần. Bạn nghĩ năm nào "khổ" nhất?

Nhiệm vụ 3 — Kết hợp bảng (Khóa 4)
JOIN students với majors để tìm: ngành học nào (major_name) có mức lo âu trung bình (anxiety_score) cao nhất? Hiển thị kèm faculty.

Nhiệm vụ 4 — Phân loại rủi ro (Khóa 3 — CASE WHEN)
Viết CASE WHEN để phân loại từng sinh viên vào 3 nhóm dựa trên depression_score:

>= 6 → 'Cần chú ý'
3-5 → 'Bình thường'
< 3 → 'Ổn định'

Sau đó đếm số lượng sinh viên trong mỗi nhóm.

Nhiệm vụ 5 — Subquery (Khóa 4)
Tìm những sinh viên có stress_level cao hơn mức trung bình của ngành họ đang học (gợi ý: cần subquery tính trung bình theo từng major_id, có thể cần dùng subquery tương quan hoặc JOIN với 1 subquery đã GROUP BY).

Nhiệm vụ 6 — Tạo VIEW tổng hợp (Khóa 6)
Tạo 1 VIEW tên student_wellbeing_summary gồm: student_id, major_name, year_of_study, và cột wellbeing_score tự tính = social_support_score + physical_activity_hours_per_week - stress_level - anxiety_score (điểm càng cao càng khỏe mạnh). Sau đó SELECT từ view này để tìm 5 sinh viên có wellbeing_score thấp nhất — đây là nhóm nên được ưu tiên hỗ trợ.
-- SQLBook: Code
SELECT * from students;
SELECT * from majors;
-- SQLBook: Code
-- Nhiệm vụ 1 — Khám phá cơ bản (Khóa 2-3)
-- Tìm mức stress trung bình, lo âu trung bình, và số giờ ngủ trung bình của toàn bộ sinh viên.
SELECT AVG(stress_level) as avg_stress_level,AVG(anxiety_score) as avg_anxiety_score, 
AVG(sleep_hours_per_night) as avg_sleep_hours_per_night from students;

-- SQLBook: Code
-- Nhiệm vụ 2 — Phân tích theo nhóm (Khóa 3) 
-- Với mỗi year_of_study (năm 1-4), tính: số lượng sinh viên, stress trung bình, CGPA trung bình.
--  Sắp xếp theo stress trung bình giảm dần. Bạn nghĩ năm nào "khổ" nhất?

SELECT year_of_study,COUNT(*) as student_count, AVG(stress_level) as avg_stress_level , avg(cgpa) as avg_cgpa from students
GROUP BY year_of_study
ORDER BY AVG(stress_level) DESC;


-- SQLBook: Code
-- Nhiệm vụ 3 — Kết hợp bảng (Khóa 4)
-- JOIN students với majors để tìm: ngành học nào (major_name) có mức lo âu trung bình (anxiety_score) cao nhất? Hiển thị kèm faculty.

select m.major_name, m.faculty, avg(s.anxiety_score) as avg_anxiety_score   from students s
INNER JOIN majors m on s.major_id = m.major_id
GROUP BY m.major_id, m.major_name, m.faculty
ORDER BY AVG(anxiety_score) DESC
limit 1;



-- SQLBook: Code
-- Nhiệm vụ 4 — Phân loại rủi ro (Khóa 3 — CASE WHEN)
-- Viết CASE WHEN để phân loại từng sinh viên vào 3 nhóm dựa trên depression_score:

-- >= 6 → 'Cần chú ý'
-- 3-5 → 'Bình thường'
-- < 3 → 'Ổn định'


SELECT student_id , depression_score, CASE 
    WHEN depression_score >=6 AND depression_score<=10 THEN 'Can Chu Y'  
    WHEN depression_score >=3 and depression_score <=5 THEN 'Binh Thuong'
    WHEN depression_score <3  THEN 'On Dinh'

    ELSE  'Khong xac dinh'
END as Trang_Thai
from students;

-- SQLBook: Code
-- Nhiệm vụ 5 — Subquery (Khóa 4)
-- Tìm những sinh viên có stress_level cao hơn mức trung bình của ngành họ đang học (gợi ý: cần subquery tính trung bình theo từng major_id, có thể cần dùng subquery tương quan hoặc JOIN với 1 subquery đã GROUP BY).

select s.student_id, s.major_id, s.stress_level, avg_major.avg_stress  from students s 
JOIN (
    SELECT major_id, AVG(stress_level) as avg_stress
    from students
    GROUP BY major_id
) avg_major
ON s.major_id=avg_major.major_id
where s.stress_level> avg_major.avg_stress;


-- C2
SELECT 
    student_id,
    major_id,
    stress_level
FROM students s
WHERE stress_level > (
    SELECT AVG(s2.stress_level)
    FROM students s2
    WHERE s2.major_id = s.major_id
);


-- SQLBook: Code
-- -- Nhiệm vụ 6 — Tạo VIEW tổng hợp (Khóa 6)
-- Tạo 1 VIEW tên student_wellbeing_summary gồm: student_id, major_name, year_of_study, và cột wellbeing_score tự tính = social_support_score + physical_activity_hours_per_week - stress_level - anxiety_score (điểm càng cao càng khỏe mạnh). Sau đó SELECT từ view này để tìm 5 sinh viên có wellbeing_score thấp nhất — đây là nhóm nên được ưu tiên hỗ trợ.

CREATE VIEW student_wellbeing_summary as 
select s.student_id, m.major_name, s.year_of_study, social_support_score + physical_activity_hours_per_week - stress_level - anxiety_score as wellbeing_score
from students s 
INNER JOIN majors m on s.major_id= m.major_id;



-- SQLBook: Code
select * from student_wellbeing_summary 
ORDER BY wellbeing_score ASC
LIMIT 5;