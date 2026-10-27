-- Week 12: employees earning above their department average.
WITH averages AS (
    SELECT department, AVG(salary) AS mean_salary
    FROM week12.employees GROUP BY department
)
SELECT e.name, e.department, e.salary, ROUND(a.mean_salary,2) AS department_average
FROM week12.employees e JOIN averages a USING (department)
WHERE e.salary > a.mean_salary
ORDER BY e.name;
