-- Week 6: types, constraints, ALTER TABLE, temporary tables, DROP TABLE.
BEGIN;
CREATE SCHEMA week06;
CREATE TABLE week06.students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    faculty VARCHAR(100),
    grade NUMERIC(5,2) CHECK (grade >= 0 AND grade <= 100),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE
);
INSERT INTO week06.students (first_name,last_name,email,faculty,grade) VALUES
    ('Alice','Johnson','alice@example.com','Computer Science',92.50),
    ('Bob','Smith','bob@example.com','Mathematics',85.00);
ALTER TABLE week06.students ADD COLUMN phone VARCHAR(20);
ALTER TABLE week06.students RENAME COLUMN phone TO phone_number;
ALTER TABLE week06.students ALTER COLUMN faculty TYPE VARCHAR(150);
ALTER TABLE week06.students ADD CONSTRAINT positive_student_id CHECK (student_id > 0);
ALTER TABLE week06.students DROP COLUMN phone_number;
CREATE TABLE week06.constraint_checks (test TEXT PRIMARY KEY, result TEXT NOT NULL);
DO $$ BEGIN
    BEGIN
        INSERT INTO week06.students(first_name,last_name,email) VALUES(NULL,'Test','null@example.com');
        RAISE EXCEPTION 'NOT NULL did not reject a null name';
    EXCEPTION WHEN not_null_violation THEN
        INSERT INTO week06.constraint_checks VALUES ('NOT NULL rejects null','PASS');
        RAISE NOTICE 'PASS: NOT NULL rejects null';
    END;
    BEGIN
        INSERT INTO week06.students(first_name,last_name,email) VALUES('Duplicate','Test','alice@example.com');
        RAISE EXCEPTION 'UNIQUE did not reject duplicate email';
    EXCEPTION WHEN unique_violation THEN
        INSERT INTO week06.constraint_checks VALUES ('UNIQUE rejects duplicate email','PASS');
        RAISE NOTICE 'PASS: UNIQUE rejects duplicate email';
    END;
    BEGIN
        INSERT INTO week06.students(first_name,last_name,email,grade) VALUES('Invalid','Test','grade@example.com',101);
        RAISE EXCEPTION 'CHECK did not reject grade 101';
    EXCEPTION WHEN check_violation THEN
        INSERT INTO week06.constraint_checks VALUES ('CHECK rejects grade outside 0 to 100','PASS');
        RAISE NOTICE 'PASS: CHECK rejects grade outside 0 to 100';
    END;
END $$;
CREATE TEMP TABLE temp_student_names (name TEXT);
INSERT INTO temp_student_names SELECT first_name FROM week06.students;
SELECT * FROM temp_student_names ORDER BY name;
CREATE TABLE week06.test_table (id INTEGER);
DROP TABLE week06.test_table;
DROP TABLE IF EXISTS week06.test_table;
SELECT * FROM week06.students ORDER BY student_id;
SELECT * FROM week06.constraint_checks ORDER BY test;
SELECT column_name, data_type, is_nullable FROM information_schema.columns
WHERE table_schema='week06' AND table_name='students' ORDER BY ordinal_position;
COMMIT;
