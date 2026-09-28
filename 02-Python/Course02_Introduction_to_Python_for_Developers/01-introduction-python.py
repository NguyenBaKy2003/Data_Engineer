# Bài 1: Tạo 1 list tên departments chứa 4 phòng ban: "Data", "Sales", "Marketing", "HR". In ra phần tử thứ 2 trong list (chính là "Sales").
departments=["Data","Sales","Marketing","HR"]
print(departments[1])

# Bài 2: Tạo 1 dict tên employee với các key: name, department, salary (tự điền giá trị bất kỳ). In ra câu "{name} làm ở phòng {department}" bằng f-string.

employee={
    "name":"Nguyen Ba Ky",
    "department":"Data",
    "salary":"1000"
}
print(f"{employee["name"]} lam o phong {employee["department"]}")

# Bài 3: Viết if/elif/else — cho biến stress_level = 7 (nhớ lại project Khóa 6-7 track SQL!), phân loại: >= 7 → in "Cần chú ý", 4-6 → in "Bình thường", < 4 → in "Ổn định".

stress_level=int(input("Nhap vao muc do stress: "))
if stress_level>=7 and stress_level<=10:
    print("Can chu y")
elif stress_level>=4 and stress_level<=6:
    print("Binh thuong")
elif stress_level<4:
    print("On dinh")
else:
    print("Khong xac dinh")
# Bài 4: Cho list scores = [85, 42, 90, 55, 78, 30]. Viết vòng lặp for kết hợp if để tạo ra 1 list mới tên passed chỉ chứa các điểm >= 50.
scores = [85, 42, 90, 55, 78, 30]
passed=[]
for i in scores:
    if i>=50:
        passed.append(i)
print(passed)

"""
Bài 5 (tổng hợp): Cho list salaries = [18000000, 25000000, 30000000, 15000000, 22000000]. Viết code để:

Đếm xem có bao nhiêu người lương >= 20 triệu
In ra kết quả dạng: "Có 3 người lương từ 20 triệu trở lên"*/

"""

salaries = [18000000, 25000000, 30000000, 15000000, 22000000]

count=0
for i in salaries:
    if i>=20000000:
        count+=1
print(f"Co {count} nguoi luong tu 20 trieu ")