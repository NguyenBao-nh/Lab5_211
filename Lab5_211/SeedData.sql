-- Dữ liệu mẫu cho database StudentManagement (Lab5_211)
-- Chạy trong SQL Server Management Studio hoặc SQL Server Object Explorer của Visual Studio.
-- Script an toàn khi chạy nhiều lần: ngành/khóa học đã có thì không thêm lại.

USE StudentManagement;
GO

SET NOCOUNT ON;
BEGIN TRANSACTION;

-------------------------------------------------------------
-- 1. Ngành (Major)
-------------------------------------------------------------
INSERT INTO Major (MajorName)
SELECT v.MajorName
FROM (VALUES
    (N'Công nghệ thông tin'),
    (N'Quản trị kinh doanh'),
    (N'Thiết kế đồ họa'),
    (N'Ngôn ngữ Anh')
) AS v(MajorName)
WHERE NOT EXISTS (SELECT 1 FROM Major m WHERE m.MajorName = v.MajorName);

-------------------------------------------------------------
-- 2. Học viên (Learner): 24 người, 6 người mỗi ngành
--    LastName = Họ, FirstMidName = Tên đệm + Tên
-------------------------------------------------------------
INSERT INTO Learner (LastName, FirstMidName, EnrollmentDate, MajorID)
SELECT v.LastName, v.FirstMidName, v.EnrollmentDate, m.MajorID
FROM (VALUES
    (N'Nguyễn', N'Văn An',      '2024-09-05', N'Công nghệ thông tin'),
    (N'Trần',   N'Thị Bình',    '2024-09-05', N'Công nghệ thông tin'),
    (N'Lê',     N'Hoàng Cường', '2024-09-10', N'Công nghệ thông tin'),
    (N'Phạm',   N'Minh Đức',    '2025-01-15', N'Công nghệ thông tin'),
    (N'Hoàng',  N'Gia Huy',     '2025-01-15', N'Công nghệ thông tin'),
    (N'Võ',     N'Thanh Tùng',  '2025-09-08', N'Công nghệ thông tin'),

    (N'Đặng',   N'Thu Hà',      '2024-09-05', N'Quản trị kinh doanh'),
    (N'Bùi',    N'Quốc Khánh',  '2024-09-12', N'Quản trị kinh doanh'),
    (N'Đỗ',     N'Ngọc Lan',    '2025-01-20', N'Quản trị kinh doanh'),
    (N'Hồ',     N'Đức Mạnh',    '2025-01-20', N'Quản trị kinh doanh'),
    (N'Ngô',    N'Phương Nga',  '2025-09-08', N'Quản trị kinh doanh'),
    (N'Dương',  N'Văn Phúc',    '2025-09-15', N'Quản trị kinh doanh'),

    (N'Lý',     N'Bảo Quyên',   '2024-09-05', N'Thiết kế đồ họa'),
    (N'Mai',    N'Anh Sơn',     '2024-09-18', N'Thiết kế đồ họa'),
    (N'Trịnh',  N'Thị Thảo',    '2025-01-15', N'Thiết kế đồ họa'),
    (N'Đinh',   N'Công Toàn',   '2025-02-03', N'Thiết kế đồ họa'),
    (N'Cao',    N'Mỹ Uyên',     '2025-09-08', N'Thiết kế đồ họa'),
    (N'Phan',   N'Hữu Vinh',    '2025-09-22', N'Thiết kế đồ họa'),

    (N'Nguyễn', N'Khánh Linh',  '2024-09-05', N'Ngôn ngữ Anh'),
    (N'Trần',   N'Minh Quân',   '2024-09-10', N'Ngôn ngữ Anh'),
    (N'Lê',     N'Thị Hồng',    '2025-01-15', N'Ngôn ngữ Anh'),
    (N'Phạm',   N'Tuấn Kiệt',   '2025-01-22', N'Ngôn ngữ Anh'),
    (N'Vũ',     N'Hải Yến',     '2025-09-08', N'Ngôn ngữ Anh'),
    (N'Đoàn',   N'Nhật Nam',    '2025-09-15', N'Ngôn ngữ Anh')
) AS v(LastName, FirstMidName, EnrollmentDate, MajorName)
JOIN Major m ON m.MajorName = v.MajorName;

-------------------------------------------------------------
-- 3. Khóa học (Course)
-------------------------------------------------------------
INSERT INTO Course (Title, Credits)
SELECT v.Title, v.Credits
FROM (VALUES
    (N'Lập trình C#',              3),
    (N'Lập trình Web ASP.NET Core', 4),
    (N'Cơ sở dữ liệu',             3),
    (N'Marketing căn bản',         3),
    (N'Photoshop căn bản',         2),
    (N'Tiếng Anh giao tiếp',       2)
) AS v(Title, Credits)
WHERE NOT EXISTS (SELECT 1 FROM Course c WHERE c.Title = v.Title);

-------------------------------------------------------------
-- 4. Đăng ký học (Enrollment)
--    Mỗi học viên vừa thêm được đăng ký 2 khóa phù hợp ngành
-------------------------------------------------------------
INSERT INTO Enrollment (CourseID, LearnerID, Grade)
SELECT c.CourseID, l.LearnerID, v.Grade
FROM (VALUES
    (N'Văn An',      N'Lập trình C#', 8.5),  (N'Văn An',      N'Cơ sở dữ liệu', 7.0),
    (N'Thị Bình',    N'Lập trình C#', 9.0),  (N'Thị Bình',    N'Lập trình Web ASP.NET Core', 8.0),
    (N'Hoàng Cường', N'Cơ sở dữ liệu', 6.5), (N'Hoàng Cường', N'Lập trình Web ASP.NET Core', NULL),
    (N'Minh Đức',    N'Lập trình C#', 7.5),  (N'Minh Đức',    N'Cơ sở dữ liệu', 8.0),
    (N'Gia Huy',     N'Lập trình Web ASP.NET Core', 9.5), (N'Gia Huy', N'Lập trình C#', NULL),
    (N'Thanh Tùng',  N'Lập trình C#', NULL),

    (N'Thu Hà',      N'Marketing căn bản', 8.0), (N'Thu Hà', N'Tiếng Anh giao tiếp', 7.5),
    (N'Quốc Khánh',  N'Marketing căn bản', 6.0),
    (N'Ngọc Lan',    N'Marketing căn bản', 9.0), (N'Ngọc Lan', N'Cơ sở dữ liệu', 7.0),
    (N'Đức Mạnh',    N'Marketing căn bản', 5.5),
    (N'Phương Nga',  N'Marketing căn bản', NULL),
    (N'Văn Phúc',    N'Tiếng Anh giao tiếp', NULL),

    (N'Bảo Quyên',   N'Photoshop căn bản', 9.0), (N'Bảo Quyên', N'Marketing căn bản', 7.5),
    (N'Anh Sơn',     N'Photoshop căn bản', 8.0),
    (N'Thị Thảo',    N'Photoshop căn bản', 7.0),
    (N'Công Toàn',   N'Photoshop căn bản', 6.5),
    (N'Mỹ Uyên',     N'Photoshop căn bản', NULL),
    (N'Hữu Vinh',    N'Photoshop căn bản', NULL),

    (N'Khánh Linh',  N'Tiếng Anh giao tiếp', 9.5), (N'Khánh Linh', N'Marketing căn bản', 8.0),
    (N'Minh Quân',   N'Tiếng Anh giao tiếp', 8.5),
    (N'Thị Hồng',    N'Tiếng Anh giao tiếp', 7.0),
    (N'Tuấn Kiệt',   N'Tiếng Anh giao tiếp', 6.0),
    (N'Hải Yến',     N'Tiếng Anh giao tiếp', NULL),
    (N'Nhật Nam',    N'Tiếng Anh giao tiếp', NULL)
) AS v(FirstMidName, Title, Grade)
CROSS APPLY (SELECT TOP 1 LearnerID FROM Learner
             WHERE FirstMidName = v.FirstMidName
             ORDER BY LearnerID DESC) l
JOIN Course c ON c.Title = v.Title;

COMMIT TRANSACTION;

-- Kiểm tra nhanh
SELECT m.MajorName, COUNT(l.LearnerID) AS SoHocVien
FROM Major m LEFT JOIN Learner l ON l.MajorID = m.MajorID
GROUP BY m.MajorName;
