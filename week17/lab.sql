-- Week 17: CSV import/export and restore validation.
BEGIN;
CREATE SCHEMA week17;
CREATE TABLE week17.students(student_id INTEGER PRIMARY KEY,name TEXT NOT NULL,faculty TEXT,note TEXT);
INSERT INTO week17.students VALUES
(1,'Alice','Engineering','Contains, a comma'),
(2,'Bob','Sales','A "quoted" note'),
(3,'Carol','Mathematics',NULL),
(4,'David','Engineering','NULL');
CREATE TABLE week17.imported_students(LIKE week17.students INCLUDING ALL);
CREATE TABLE week17.pipe_import(LIKE week17.students INCLUDING ALL);
CREATE TABLE week17.migration_target(LIKE week17.students INCLUDING ALL);
CREATE TABLE week17.backup_checks(test TEXT PRIMARY KEY,passed BOOLEAN NOT NULL,details TEXT);
COMMIT;
SELECT * FROM week17.students ORDER BY student_id;
