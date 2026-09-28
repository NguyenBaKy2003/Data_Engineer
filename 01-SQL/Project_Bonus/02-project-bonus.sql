-- SQLBook: Markup
Project Bonus 2: Exploring London's Travel Network

Project cuối cùng của track SQL — phân tích dữ liệu di chuyển thật của mạng lưới giao thông London (mô phỏng theo dữ liệu Transport for London) qua nhiều năm, có cả giai đoạn COVID để bạn thấy được insight thú vị.
-- SQLBook: Code
-- Bước 1: Dựng dữ liệu
CREATE TABLE lines (
    line_id SERIAL PRIMARY KEY,
    line_name VARCHAR(50) NOT NULL,
    line_type VARCHAR(20) NOT NULL   -- 'Tube', 'Overground', 'Bus'
);

CREATE TABLE stations (
    station_id SERIAL PRIMARY KEY,
    station_name VARCHAR(100) NOT NULL,
    zone INTEGER NOT NULL,           -- vùng vé, 1 = trung tâm
    line_id INTEGER REFERENCES lines(line_id)
);

CREATE TABLE journeys (
    journey_id SERIAL PRIMARY KEY,
    station_id INTEGER REFERENCES stations(station_id),
    journey_year INTEGER NOT NULL,
    journey_month INTEGER NOT NULL,
    day_type VARCHAR(10) NOT NULL,     -- 'Weekday' hoặc 'Weekend'
    passenger_count INTEGER NOT NULL
);

INSERT INTO lines (line_name, line_type) VALUES
('Central', 'Tube'),
('Victoria', 'Tube'),
('Circle', 'Tube'),
('Overground', 'Overground'),
('Jubilee', 'Tube');

INSERT INTO stations (station_name, zone, line_id) VALUES
('Oxford Circus', 1, 1),
('Bank', 1, 1),
('Stratford', 3, 2),
('Kings Cross', 1, 3),
('Canary Wharf', 2, 5),
('Wembley Park', 4, 5),
('Shoreditch High St', 1, 4),
('Brixton', 2, 2);

-- Dữ liệu qua các năm: 2010 (bình thường), 2015 (tăng trưởng), 
-- 2020 (sụt giảm mạnh do COVID), 2023 (phục hồi)
INSERT INTO journeys (station_id, journey_year, journey_month, day_type, passenger_count) VALUES
-- Oxford Circus
(1, 2010, 6, 'Weekday', 85000), (1, 2010, 6, 'Weekend', 45000),
(1, 2015, 6, 'Weekday', 102000), (1, 2015, 6, 'Weekend', 58000),
(1, 2020, 6, 'Weekday', 18000),  (1, 2020, 6, 'Weekend', 9000),
(1, 2023, 6, 'Weekday', 89000),  (1, 2023, 6, 'Weekend', 52000),
-- Bank
(2, 2010, 6, 'Weekday', 78000), (2, 2010, 6, 'Weekend', 22000),
(2, 2015, 6, 'Weekday', 95000), (2, 2015, 6, 'Weekend', 28000),
(2, 2020, 6, 'Weekday', 15000), (2, 2020, 6, 'Weekend', 4000),
(2, 2023, 6, 'Weekday', 80000), (2, 2023, 6, 'Weekend', 25000),
-- Stratford
(3, 2010, 6, 'Weekday', 62000), (3, 2010, 6, 'Weekend', 38000),
(3, 2015, 6, 'Weekday', 88000), (3, 2015, 6, 'Weekend', 52000),
(3, 2020, 6, 'Weekday', 22000), (3, 2020, 6, 'Weekend', 14000),
(3, 2023, 6, 'Weekday', 91000), (3, 2023, 6, 'Weekend', 56000),
-- Kings Cross
(4, 2010, 6, 'Weekday', 91000), (4, 2010, 6, 'Weekend', 41000),
(4, 2015, 6, 'Weekday', 110000), (4, 2015, 6, 'Weekend', 49000),
(4, 2020, 6, 'Weekday', 25000), (4, 2020, 6, 'Weekend', 10000),
(4, 2023, 6, 'Weekday', 105000), (4, 2023, 6, 'Weekend', 47000),
-- Canary Wharf
(5, 2010, 6, 'Weekday', 55000), (5, 2010, 6, 'Weekend', 12000),
(5, 2015, 6, 'Weekday', 72000), (5, 2015, 6, 'Weekend', 16000),
(5, 2020, 6, 'Weekday', 12000), (5, 2020, 6, 'Weekend', 3000),
(5, 2023, 6, 'Weekday', 68000), (5, 2023, 6, 'Weekend', 15000),
-- Wembley Park
(6, 2010, 6, 'Weekday', 20000), (6, 2010, 6, 'Weekend', 35000),
(6, 2015, 6, 'Weekday', 25000), (6, 2015, 6, 'Weekend', 48000),
(6, 2020, 6, 'Weekday', 6000),  (6, 2020, 6, 'Weekend', 11000),
(6, 2023, 6, 'Weekday', 24000), (6, 2023, 6, 'Weekend', 50000),
-- Shoreditch High St
(7, 2010, 6, 'Weekday', 15000), (7, 2010, 6, 'Weekend', 18000),
(7, 2015, 6, 'Weekday', 32000), (7, 2015, 6, 'Weekend', 35000),
(7, 2020, 6, 'Weekday', 8000),  (7, 2020, 6, 'Weekend', 9000),
(7, 2023, 6, 'Weekday', 38000), (7, 2023, 6, 'Weekend', 40000),
-- Brixton
(8, 2010, 6, 'Weekday', 40000), (8, 2010, 6, 'Weekend', 25000),
(8, 2015, 6, 'Weekday', 48000), (8, 2015, 6, 'Weekend', 30000),
(8, 2020, 6, 'Weekday', 10000), (8, 2020, 6, 'Weekend', 6000),
(8, 2023, 6, 'Weekday', 46000), (8, 2023, 6, 'Weekend', 29000);
-- SQLBook: Markup
Bước 2: Nhiệm vụ phân tích

Nhiệm vụ 1 — Tổng quan theo năm
Tính tổng passenger_count của toàn mạng lưới theo từng journey_year. Nhìn kết quả, năm nào sụt giảm rõ rệt nhất và vì sao (không cần viết SQL cho phần giải thích)?

Nhiệm vụ 2 — So sánh Weekday vs Weekend
Với mỗi journey_year, tính tổng lượt khách theo day_type (Weekday/Weekend). Ga nào theo bạn phù hợp để nhận định: có phải mọi ga đều giảm tỷ lệ giống nhau giữa ngày thường và cuối tuần trong năm 2020 không?

Nhiệm vụ 3 — JOIN để biết tuyến nào đông nhất
JOIN journeys → stations → lines để tìm: tuyến (line_name) nào có tổng lượt khách cao nhất trong năm 2023?

Nhiệm vụ 4 — Phân loại ga theo mức độ đông đúc (CASE WHEN)
Với dữ liệu năm 2023, phân loại từng ga dựa trên tổng passenger_count (cộng cả Weekday + Weekend) thành:

>= 130000 → 'Rất đông'
70000 - 129999 → 'Đông'
< 70000 → 'Vừa phải'

Nhiệm vụ 5 — Subquery: tốc độ phục hồi sau COVID
Đây là câu khó nhất — tính tỷ lệ phục hồi của mỗi ga: (tổng khách 2023) / (tổng khách 2019 hoặc 2020) * 100. Vì dữ liệu ta có 2020 (đáy dịch), hãy tính tỷ lệ 2023 / 2020 cho từng ga, sắp xếp từ ga phục hồi tốt nhất đến kém nhất. (Gợi ý: dùng 2 subquery riêng cho từng năm, rồi JOIN lại theo station_id)

Nhiệm vụ 6 — VIEW tổng hợp cho dashboard
Tạo VIEW tên station_yearly_summary gồm: station_name, zone, journey_year, tổng passenger_count của cả năm đó (gộp Weekday + Weekend). Sau đó SELECT để tìm ga nào ở zone 1 có tổng lượt khách cao nhất năm 2023.
-- SQLBook: Code
select * from journeys;
select * from stations;
SELECT * from lines;
-- SQLBook: Code
select  journey_year,SUM(passenger_count) as sum_passenger_count from journeys 
GROUP BY journey_year
ORDER BY SUM(passenger_count) ASC ;

-- Năm 2020 sụt giảm nhất, có thể do Covid

-- SQLBook: Code
-- Nhiệm vụ 2 — So sánh Weekday vs Weekend
-- Với mỗi journey_year, tính tổng lượt khách theo day_type (Weekday/Weekend). Ga nào theo bạn phù hợp để nhận định: có phải mọi ga đều giảm tỷ lệ giống nhau giữa ngày thường và cuối tuần trong năm 2020 không?

select journey_year, day_type , sum(passenger_count) as sum_passenger_count from journeys
GROUP BY journey_year, day_type
ORDER BY journey_year, day_type;

-- SQLBook: Code
-- Nhiệm vụ 3 — JOIN để biết tuyến nào đông nhất
-- JOIN journeys → stations → lines để tìm: tuyến (line_name) nào có tổng lượt khách cao nhất trong năm 2023?


SELECT l.line_name,SUM(j.passenger_count) AS total_passengers
 from lines l 
 JOIN stations s on l.line_id=s.line_id
 JOIN journeys j on s.station_id= j.station_id
 WHERE j. journey_year =2023 
 GROUP BY l.line_id, l.line_name
 ORDER BY total_passengers desc
 limit 1;



-- SQLBook: Code
-- Nhiệm vụ 4 — Phân loại ga theo mức độ đông đúc (CASE WHEN)
-- Với dữ liệu năm 2023, phân loại từng ga dựa trên tổng passenger_count (cộng cả Weekday + Weekend) thành:

-- >= 130000 → 'Rất đông'
-- 70000 - 129999 → 'Đông'
-- < 70000 → 'Vừa phải'

select s.station_name, sum(j.passenger_count) as total_passenger_count,
    CASE 
        WHEN sum(j.passenger_count) >=130000 THEN 'Rat dong'  
        WHEN sum(j.passenger_count) >=70000 THEN 'dong'  
        ELSE  'Vua Phai'
    END as trang_thai
from stations s  
INNER JOIN journeys j on s.station_id= j.station_id
WHERE j.journey_year=2023
GROUP BY s.station_id,s.station_name


-- SQLBook: Code
-- Nhiệm vụ 5 — Subquery: tốc độ phục hồi sau COVID
-- Đây là câu khó nhất — tính tỷ lệ phục hồi của mỗi ga: (tổng khách 2023) / (tổng khách 2019 hoặc 2020) * 100. Vì dữ liệu ta có 2020 (đáy dịch), hãy tính tỷ lệ 2023 / 2020 cho từng ga, sắp xếp từ ga phục hồi tốt nhất đến kém nhất. (Gợi ý: dùng 2 subquery riêng cho từng năm, rồi JOIN lại theo station_id)

SELECT s.station_name, y2023.total_2023, y2020.total_2020, Round(y2023.total_2023::numeric/ y2020.total_2020 * 100,2) as recovery_rate
from stations s  
JOIN (
    SELECT station_id, sum(passenger_count) as total_2023
    from journeys 
    where journey_year=2023
    GROUP BY station_id
) y2023 on s.station_id= y2023.station_id
JOIN (SELECT station_id, sum(passenger_count) as total_2020
    from journeys 
    where journey_year=2020
    GROUP BY station_id) y2020 on s.station_id= y2020.station_id
ORDER BY recovery_rate desc;

-- SQLBook: Code
-- Nhiệm vụ 6 — VIEW tổng hợp cho dashboard
-- Tạo VIEW tên station_yearly_summary gồm: station_name, zone, journey_year, tổng passenger_count của cả năm đó (gộp Weekday + Weekend). Sau đó SELECT để tìm ga nào ở zone 1 có tổng lượt khách cao nhất năm 2023.
CREATE View station_yearly_summary as 
SELECT s.station_name, s.zone, j.journey_year, sum(j.passenger_count) as total_passengers from stations s

INNER JOIN journeys j on s.station_id=j.station_id
GROUP BY j.journey_year,s.station_name,s.zone

-- SQLBook: Code
SELECT
    station_name,
    zone,
    journey_year,
    total_passengers
FROM station_yearly_summary
WHERE zone = 1
  AND journey_year = 2023
ORDER BY total_passengers DESC
LIMIT 1;