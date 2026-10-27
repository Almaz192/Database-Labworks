-- Week 9: normalized university and library models.
BEGIN;
CREATE SCHEMA week09;
CREATE TABLE week09.professors (professor_id INTEGER PRIMARY KEY, name TEXT NOT NULL);
CREATE TABLE week09.students (student_id INTEGER PRIMARY KEY, name TEXT NOT NULL, email TEXT NOT NULL UNIQUE);
CREATE TABLE week09.courses (course_id INTEGER PRIMARY KEY, title TEXT NOT NULL, professor_id INTEGER NOT NULL REFERENCES week09.professors);
CREATE TABLE week09.enrollments (
    student_id INTEGER REFERENCES week09.students,
    course_id INTEGER REFERENCES week09.courses,
    grade NUMERIC(5,2) CHECK (grade BETWEEN 0 AND 100),
    PRIMARY KEY (student_id, course_id)
);
INSERT INTO week09.professors VALUES (1,'Dr. Morgan'),(2,'Dr. Lee');
INSERT INTO week09.students VALUES (1,'Alice','alice@example.com'),(2,'Bob','bob@example.com');
INSERT INTO week09.courses VALUES (101,'Databases',1),(102,'Programming',2);
INSERT INTO week09.enrollments VALUES (1,101,94),(1,102,88),(2,101,85);
CREATE TABLE week09.authors (author_id INTEGER PRIMARY KEY, name TEXT NOT NULL);
CREATE TABLE week09.books (book_id INTEGER PRIMARY KEY, title TEXT NOT NULL, isbn TEXT UNIQUE NOT NULL);
CREATE TABLE week09.book_authors (
    book_id INTEGER REFERENCES week09.books,
    author_id INTEGER REFERENCES week09.authors,
    PRIMARY KEY (book_id, author_id)
);
CREATE TABLE week09.members (member_id INTEGER PRIMARY KEY, name TEXT NOT NULL, email TEXT UNIQUE NOT NULL);
CREATE TABLE week09.loans (
    loan_id INTEGER PRIMARY KEY,
    book_id INTEGER NOT NULL REFERENCES week09.books,
    member_id INTEGER NOT NULL REFERENCES week09.members,
    borrowed_on DATE NOT NULL,
    due_on DATE NOT NULL,
    returned_on DATE,
    CHECK (due_on >= borrowed_on),
    CHECK (returned_on IS NULL OR returned_on >= borrowed_on)
);
CREATE UNIQUE INDEX one_active_loan_per_book ON week09.loans(book_id) WHERE returned_on IS NULL;
INSERT INTO week09.authors VALUES (1,'Alex Reed'),(2,'Sam Park');
INSERT INTO week09.books VALUES (1,'Database Foundations','9780000000001'),(2,'Practical SQL','9780000000002');
INSERT INTO week09.book_authors VALUES (1,1),(1,2),(2,2);
INSERT INTO week09.members VALUES (1,'Alice','alice@example.com'),(2,'Bob','bob@example.com');
INSERT INTO week09.loans VALUES (1,1,1,'2026-10-01','2026-10-15',NULL),(2,2,2,'2026-10-02','2026-10-16','2026-10-14');
SELECT b.title,m.name AS member,l.due_on,
       CASE WHEN l.returned_on IS NULL THEN 'On loan' ELSE 'Returned' END AS status
FROM week09.loans l JOIN week09.books b USING(book_id) JOIN week09.members m USING(member_id)
ORDER BY l.loan_id;
COMMIT;
