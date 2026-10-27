-- Week 8: foreign keys, relationship cardinality and referential actions.
BEGIN;
CREATE SCHEMA week08;
CREATE TABLE week08.departments(department_id INTEGER PRIMARY KEY,department_name TEXT NOT NULL);
CREATE TABLE week08.students(
    student_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    department_id INTEGER REFERENCES week08.departments(department_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE week08.student_profiles(
    student_id INTEGER PRIMARY KEY REFERENCES week08.students(student_id) ON UPDATE CASCADE ON DELETE CASCADE,
    biography TEXT
);
CREATE TABLE week08.courses(course_id INTEGER PRIMARY KEY,title TEXT NOT NULL);
CREATE TABLE week08.enrollments(
    student_id INTEGER,
    course_id INTEGER,
    PRIMARY KEY(student_id,course_id),
    CONSTRAINT fk_enrollment_student FOREIGN KEY(student_id)
        REFERENCES week08.students(student_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_enrollment_course FOREIGN KEY(course_id)
        REFERENCES week08.courses(course_id) ON DELETE CASCADE
);
CREATE TABLE week08.student_contacts(contact_id INTEGER PRIMARY KEY,student_id INTEGER,email TEXT);
ALTER TABLE week08.student_contacts ADD CONSTRAINT fk_contact_student
    FOREIGN KEY(student_id) REFERENCES week08.students(student_id) ON UPDATE CASCADE ON DELETE SET NULL;
INSERT INTO week08.departments VALUES(1,'Computer Science'),(2,'Mathematics');
INSERT INTO week08.students VALUES(1,'Alice',1),(2,'Bob',1),(3,'Carol',2);
INSERT INTO week08.student_profiles VALUES(1,'Database student'),(2,'Software engineering student');
INSERT INTO week08.courses VALUES(101,'Databases'),(102,'Programming');
INSERT INTO week08.enrollments VALUES(1,101),(1,102),(2,101);
INSERT INTO week08.student_contacts VALUES(1,1,'alice@example.com');
CREATE TABLE week08.relationship_checks(test TEXT PRIMARY KEY,result TEXT NOT NULL);
DO $$ BEGIN
    BEGIN
        INSERT INTO week08.enrollments VALUES(999,101);
        RAISE EXCEPTION 'Foreign key accepted a missing student';
    EXCEPTION WHEN foreign_key_violation THEN
        INSERT INTO week08.relationship_checks VALUES('Orphan enrollment rejected','PASS');
        RAISE NOTICE 'PASS: orphan enrollment rejected';
    END;
    BEGIN
        UPDATE week08.students SET department_id=999 WHERE student_id=1;
        RAISE EXCEPTION 'Foreign key accepted a missing department';
    EXCEPTION WHEN foreign_key_violation THEN
        INSERT INTO week08.relationship_checks VALUES('Invalid foreign key update rejected','PASS');
        RAISE NOTICE 'PASS: invalid foreign key update rejected';
    END;
    BEGIN
        DELETE FROM week08.departments WHERE department_id=1;
        RAISE EXCEPTION 'RESTRICT allowed deletion of referenced department';
    EXCEPTION WHEN restrict_violation OR foreign_key_violation THEN
        INSERT INTO week08.relationship_checks VALUES('ON DELETE RESTRICT preserves parent','PASS');
        RAISE NOTICE 'PASS: ON DELETE RESTRICT preserves parent';
    END;
    BEGIN
        INSERT INTO week08.student_profiles VALUES(1,'Duplicate profile');
        RAISE EXCEPTION 'One-to-one allowed a duplicate profile';
    EXCEPTION WHEN unique_violation THEN
        INSERT INTO week08.relationship_checks VALUES('One-to-one duplicate profile rejected','PASS');
        RAISE NOTICE 'PASS: one-to-one duplicate profile rejected';
    END;
END $$;
INSERT INTO week08.students VALUES(90,'Cascade demo',2);
INSERT INTO week08.student_profiles VALUES(90,'Disposable demonstration profile');
INSERT INTO week08.enrollments VALUES(90,101);
INSERT INTO week08.student_contacts VALUES(90,90,'demo@example.com');
UPDATE week08.students SET student_id=91 WHERE student_id=90;
DO $$ BEGIN
    IF NOT EXISTS(SELECT FROM week08.enrollments WHERE student_id=91)
       OR NOT EXISTS(SELECT FROM week08.student_profiles WHERE student_id=91)
       OR NOT EXISTS(SELECT FROM week08.student_contacts WHERE student_id=91) THEN
        RAISE EXCEPTION 'ON UPDATE CASCADE failed';
    END IF;
    INSERT INTO week08.relationship_checks VALUES('ON UPDATE CASCADE updates child keys','PASS');
END $$;
DELETE FROM week08.students WHERE student_id=91;
DO $$ BEGIN
    IF EXISTS(SELECT FROM week08.enrollments WHERE student_id=91)
       OR EXISTS(SELECT FROM week08.student_profiles WHERE student_id=91) THEN
        RAISE EXCEPTION 'ON DELETE CASCADE failed';
    END IF;
    INSERT INTO week08.relationship_checks VALUES('ON DELETE CASCADE removes children','PASS');
    IF NOT EXISTS(SELECT FROM week08.student_contacts WHERE contact_id=90 AND student_id IS NULL) THEN
        RAISE EXCEPTION 'ON DELETE SET NULL failed';
    END IF;
    INSERT INTO week08.relationship_checks VALUES('ON DELETE SET NULL keeps child row','PASS');
END $$;
INSERT INTO week08.departments VALUES(0,'Unassigned'),(9,'Disposable department');
CREATE TABLE week08.default_assignments(
    assignment_id INTEGER PRIMARY KEY,
    department_id INTEGER DEFAULT 0 REFERENCES week08.departments(department_id) ON DELETE SET DEFAULT
);
INSERT INTO week08.default_assignments VALUES(1,9);
DELETE FROM week08.departments WHERE department_id=9;
DO $$ BEGIN
    IF NOT EXISTS(SELECT FROM week08.default_assignments WHERE assignment_id=1 AND department_id=0) THEN
        RAISE EXCEPTION 'ON DELETE SET DEFAULT failed';
    END IF;
    INSERT INTO week08.relationship_checks VALUES('ON DELETE SET DEFAULT uses valid default','PASS');
END $$;
SELECT s.student_id,s.name,d.department_name,c.title AS course
FROM week08.students s JOIN week08.departments d USING(department_id)
LEFT JOIN week08.enrollments e USING(student_id)
LEFT JOIN week08.courses c USING(course_id)
ORDER BY s.student_id,c.course_id;
SELECT * FROM week08.relationship_checks ORDER BY test;
SELECT conname,pg_get_constraintdef(oid) AS definition FROM pg_constraint
WHERE connamespace='week08'::regnamespace AND contype='f' ORDER BY conname;
COMMIT;
