-- Week 15: recursive organization depth and window ranking.
SELECT o.name, o.depth, r.department, r.salary, r.salary_rank
FROM week15.org_chart o
JOIN week15.salary_ranks r USING (id)
ORDER BY o.depth, o.id;
