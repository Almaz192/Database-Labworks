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
-- The handout omits the sort expression after ORDER BY. Sort by name.
SELECT name, email FROM week04.students ORDER BY name ASC;
-- Explicit ordering makes the LIMIT result repeatable.
SELECT name, email FROM week04.students ORDER BY student_id LIMIT 2;
-- The handout's faculty examples do not occur in its three sample rows.
SELECT name, email FROM week04.students WHERE faculty = 'COM-25';
SELECT name, faculty FROM week04.students WHERE faculty = 'Engineering';
/* A matching faculty filter.
   PostgreSQL ignores both single-line and multi-line comments. */
SELECT name, faculty FROM week04.students WHERE faculty = 'COMSEH';
COMMIT;
