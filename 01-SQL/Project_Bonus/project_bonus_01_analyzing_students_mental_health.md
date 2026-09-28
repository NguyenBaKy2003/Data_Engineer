# Project Bonus 1: Analyzing Students' Mental Health

Đây là lúc bạn ghép toàn bộ 9 khóa lại với nhau — không còn bài tập tách rời từng kỹ năng nữa, mà một bộ dữ liệu thật, bạn tự quyết định dùng công cụ nào (SELECT, JOIN, GROUP BY, CASE WHEN, Subquery, VIEW) để trả lời câu hỏi kinh doanh.

---

# Bước 1: Dựng dữ liệu

Copy đoạn SQL dưới đây, chạy trên PostgreSQL local của bạn (hoặc DB Fiddle / SQLite Online nếu chưa cài Postgres) để tạo dữ liệu:

```sql
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
    stress_level INTEGER,
    anxiety_score INTEGER,
    depression_score INTEGER,
    physical_activity_hours_per_week NUMERIC(4,1),
    social_support_score INTEGER,
    counseling_visits INTEGER
);

INSERT INTO majors (major_name, faculty) VALUES
('Computer Science', 'Engineering'),
('Psychology', 'Social Sciences'),
('Business Administration', 'Business'),
('Mechanical Engineering', 'Engineering'),
('Nursing', 'Health Sciences'),
('Fine Arts', 'Arts');

INSERT INTO students (
    age,
    gender,
    year_of_study,
    major_id,
    cgpa,
    study_hours_per_week,
    sleep_hours_per_night,
    stress_level,
    anxiety_score,
    depression_score,
    physical_activity_hours_per_week,
    social_support_score,
    counseling_visits
) VALUES
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
```

---

# Dataset Overview

Dataset gồm:

- 24 sinh viên
- 6 ngành học
- Thông tin học tập
- Thông tin sức khỏe tinh thần
- Hoạt động thể chất
- Hỗ trợ xã hội
- Lịch sử tư vấn tâm lý

Các chỉ số nổi bật:

- `cgpa`
- `study_hours_per_week`
- `sleep_hours_per_night`
- `stress_level`
- `anxiety_score`
- `depression_score`
- `physical_activity_hours_per_week`
- `social_support_score`
- `counseling_visits`

---

# Bước 2: Nhiệm vụ phân tích

## Nhiệm vụ 1 — Khám phá cơ bản

**Kỹ năng sử dụng:**

- SELECT
- Aggregate Functions

Yêu cầu:

Tìm:

- Stress trung bình
- Anxiety trung bình
- Số giờ ngủ trung bình

của toàn bộ sinh viên.

---

## Nhiệm vụ 2 — Phân tích theo nhóm

**Kỹ năng sử dụng:**

- GROUP BY
- ORDER BY
- AVG
- COUNT

Yêu cầu:

Với mỗi `year_of_study` (1 → 4), tính:

- Số lượng sinh viên
- Stress trung bình
- CGPA trung bình

Sau đó:

- Sắp xếp theo stress trung bình giảm dần

Câu hỏi:

> Năm học nào có mức stress cao nhất?

---

## Nhiệm vụ 3 — Kết hợp bảng

**Kỹ năng sử dụng:**

- INNER JOIN
- GROUP BY

Yêu cầu:

JOIN bảng:

- students
- majors

Tìm:

- Ngành học nào có anxiety trung bình cao nhất

Hiển thị:

- major_name
- faculty
- average_anxiety_score

---

## Nhiệm vụ 4 — Phân loại rủi ro

**Kỹ năng sử dụng:**

- CASE WHEN
- GROUP BY

Phân loại sinh viên theo:

| Điều kiện | Nhóm |
|------------|--------|
| depression_score >= 6 | Cần chú ý |
| depression_score BETWEEN 3 AND 5 | Bình thường |
| depression_score < 3 | Ổn định |

Sau đó:

- Đếm số lượng sinh viên trong từng nhóm

---

## Nhiệm vụ 5 — Subquery

**Kỹ năng sử dụng:**

- Subquery
- JOIN hoặc Correlated Subquery

Yêu cầu:

Tìm các sinh viên có:

```text
stress_level > stress trung bình của chính ngành học đó
```

Gợi ý:

Tính:

```sql
AVG(stress_level)
GROUP BY major_id
```

rồi so sánh từng sinh viên với giá trị trung bình ngành tương ứng.

---

## Nhiệm vụ 6 — Tạo VIEW tổng hợp

**Kỹ năng sử dụng:**

- CREATE VIEW
- JOIN
- Calculated Columns

Tạo VIEW:

```sql
student_wellbeing_summary
```

Bao gồm:

- student_id
- major_name
- year_of_study
- wellbeing_score

Công thức:

```sql
wellbeing_score =
    social_support_score
    + physical_activity_hours_per_week
    - stress_level
    - anxiety_score
```

Ý nghĩa:

- Điểm càng cao → sức khỏe tinh thần càng tốt
- Điểm càng thấp → cần ưu tiên hỗ trợ

---

### Phân tích từ VIEW

Sau khi tạo VIEW:

Tìm:

```text
5 sinh viên có wellbeing_score thấp nhất
```

Đây là nhóm sinh viên có nguy cơ cao nhất theo chỉ số tổng hợp hiện tại.

---

# Mục tiêu học tập

Sau project này, bạn sẽ thực hành lại toàn bộ:

- SELECT
- WHERE
- ORDER BY
- LIMIT
- Aggregate Functions
- GROUP BY
- HAVING
- CASE WHEN
- JOIN
- Subquery
- CREATE VIEW

Đây là project tổng hợp đầu tiên mô phỏng một bài toán phân tích dữ liệu thực tế trong môi trường giáo dục và sức khỏe tinh thần.