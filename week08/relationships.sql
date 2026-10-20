-- Week 8: one-to-many and many-to-many relationships.
SELECT s.student_id, s.name, d.department_name, c.title AS course
FROM week08.students AS s
JOIN week08.departments AS d USING (department_id)
LEFT JOIN week08.enrollments AS e USING (student_id)
LEFT JOIN week08.courses AS c USING (course_id)
ORDER BY s.student_id, c.course_id;
