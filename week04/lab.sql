-- Week 4: SELECT, WHERE, ORDER BY, LIMIT, and SQL comments.
BEGIN;
CREATE SCHEMA week04;
CREATE TABLE week04.students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    faculty VARCHAR(50) NOT NULL
);
INSERT INTO week04.students (name, email, faculty) VALUES
    ('Alymbek', 'alymbek@example.com', 'COMSEH'),
    ('Timur', 'timur@example.com', 'MED'),
    ('Beka', 'beka@example.com', 'MAT');
SELECT name, email FROM week04.students;
SELECT * FROM week04.students;
SELECT student_id, faculty FROM week04.students;
SELECT name, email FROM week04.students WHERE name = 'Timur';
SELECT name, email FROM week04.students ORDER BY name ASC;
SELECT name, email FROM week04.students ORDER BY student_id LIMIT 2;
SELECT name, email FROM week04.students WHERE faculty = 'COM-25';
SELECT name, faculty FROM week04.students WHERE faculty = 'Engineering';
SELECT name, faculty FROM week04.students WHERE faculty = 'COMSEH';
COMMIT;
