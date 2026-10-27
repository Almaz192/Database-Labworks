-- Week 13: department salary summaries.
SELECT department, COUNT(*) AS employees, SUM(salary) AS total_salary,
       ROUND(AVG(salary),2) AS average_salary, MIN(salary) AS minimum, MAX(salary) AS maximum
FROM week13.employees
GROUP BY department
ORDER BY department;
