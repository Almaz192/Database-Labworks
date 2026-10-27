-- Week 9: the library model links loans to books and members.
SELECT b.title, m.name AS member, l.due_on,
       CASE WHEN l.returned_on IS NULL THEN 'On loan' ELSE 'Returned' END AS status
FROM week09.loans l
JOIN week09.books b USING (book_id)
JOIN week09.members m USING (member_id)
ORDER BY l.loan_id;
