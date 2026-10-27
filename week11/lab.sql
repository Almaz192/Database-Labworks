-- Week 11: INSERT, UPDATE, DELETE and bulk import using psql.
BEGIN;
CREATE SCHEMA week11;
CREATE TABLE week11.students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),last_name VARCHAR(50),birth_date DATE
);
INSERT INTO week11.students(first_name,last_name,birth_date) VALUES('Aibek','Sharshenov','2002-05-12');
INSERT INTO week11.students(first_name,last_name,birth_date) VALUES
('Ainura','Toktomamatova','2001-09-23'),('Bakyt','Mamatov','2003-01-15'),('Gulzat','Sultanova','2002-07-30');
UPDATE week11.students SET birth_date='2002-05-15'
WHERE first_name='Aibek' AND last_name='Sharshenov' RETURNING *;
DELETE FROM week11.students WHERE first_name='Gulzat' AND last_name='Sultanova' RETURNING *;
COPY week11.students(first_name,last_name,birth_date) FROM STDIN WITH (FORMAT csv,HEADER true);
first_name,last_name,birth_date
Nursultan,Isakov,2002-04-10
Meerim,Bekova,2003-06-12
Tilek,Usubaliev,2001-11-05
\.
UPDATE week11.students SET last_name='Bekov' WHERE last_name IN ('Uulu','Isakov') RETURNING *;
SELECT * FROM week11.students ORDER BY student_id;
DELETE FROM week11.students WHERE birth_date<'2002-01-01' RETURNING *;
DELETE FROM week11.students WHERE student_id IN (2,3,5) RETURNING *;
SELECT * FROM week11.students ORDER BY student_id;
COMMIT;
