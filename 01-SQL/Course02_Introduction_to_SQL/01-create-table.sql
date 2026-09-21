-- SQLBook: Markup
Tạo database 
Trong PostgreSQL, chúng ta có thể tạo:

CREATE DATABASE data_engineer;
Sau đó kết nối vào database:

data_engineer

Nếu bạn đang dùng PostgreSQL + pgAdmin, mình có thể hướng dẫn bạn tạo database trực tiếp trên pgAdmin.

-- SQLBook: Markup
Tạo bảng

Bây giờ tạo bảng employees.

CREATE TABLE employees (
    id INT,
    name VARCHAR(100),
    department VARCHAR(100),
    salary BIGINT, 
    hire_date TIMESTAMP
    
);
-- SQLBook: Code
CREATE TABLE employees(
    id INT Generated ALWAYS as IDENTITY PRIMARY KEY, 
    name VARCHAR(100),
    department VARCHAR(100),
    salary BIGINT,
    hire_date TIMESTAMP
)
