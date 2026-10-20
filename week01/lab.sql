-- Week 1: relational database terminology with a small working table.
BEGIN;
CREATE SCHEMA week01;
CREATE TABLE week01.students (
    student_id INTEGER PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    faculty VARCHAR(50) NOT NULL
);
INSERT INTO week01.students VALUES
    (1, 'Alymbek', 'COMSEH'),
    (2, 'Timur', 'MED'),
    (3, 'Beka', 'MAT');
SELECT * FROM week01.students ORDER BY student_id;
SELECT COUNT(*) AS row_count FROM week01.students;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'week01' AND table_name = 'students'
ORDER BY ordinal_position;
COMMIT;
