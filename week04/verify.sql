-- Week 4: combine filtering, alphabetical sorting, and a row limit.
SELECT name, email, faculty
FROM week04.students
WHERE faculty IN ('COMSEH', 'MAT')
ORDER BY name ASC
LIMIT 2;
