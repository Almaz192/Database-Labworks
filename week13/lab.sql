-- Week 13: aggregation, grouping, HAVING, windows and NULLs.
BEGIN;
CREATE SCHEMA week13;
CREATE TABLE week13.employees (
    id INTEGER PRIMARY KEY,name TEXT NOT NULL,department TEXT NOT NULL,
    department_id INTEGER NOT NULL,salary NUMERIC(10,2) NOT NULL,
    email TEXT,age INTEGER,hire_date DATE,experience_years INTEGER,bonus NUMERIC(10,2)
);
INSERT INTO week13.employees VALUES
(1,'Alice','Engineering',3,120000,'alice@example.com',32,'2021-03-01',10,5000),
(2,'Bob','Engineering',3,80000,'BOB@GMAIL.COM',27,'2024-04-15',5,NULL),
(3,'Carol','Sales',5,70000,'carol@gmail.com',41,'2022-06-01',15,3000),
(4,'David','Sales',5,50000,NULL,24,'2025-01-10',2,NULL),
(5,'Eva','HR',7,60000,'eva@example.com',36,'2020-10-01',12,2000),
(6,'Brad','Engineering',3,100000,'brad@gmail.com',29,'2023-02-01',7,4000);

SELECT COUNT(*) AS total,COUNT(email) AS with_email,COUNT(DISTINCT department) AS departments FROM week13.employees;
SELECT SUM(salary),ROUND(AVG(salary),2),MIN(salary),MAX(salary) FROM week13.employees;
SELECT department,COUNT(*) AS people,SUM(salary) AS total_salary,ROUND(AVG(salary),2) AS average_salary,MAX(hire_date) AS latest_hire
FROM week13.employees GROUP BY department ORDER BY department;
SELECT department,STRING_AGG(name,', ' ORDER BY name) AS employee_names,ARRAY_AGG(salary ORDER BY salary) AS salaries
FROM week13.employees GROUP BY department ORDER BY department;
SELECT department,ROUND(STDDEV_SAMP(salary),2) AS salary_stddev,ROUND(VAR_SAMP(salary),2) AS salary_variance
FROM week13.employees GROUP BY department ORDER BY department;
SELECT ROUND(CORR(experience_years,salary)::numeric,4) AS experience_salary_correlation FROM week13.employees;
SELECT EXTRACT(YEAR FROM hire_date) AS year,EXTRACT(QUARTER FROM hire_date) AS quarter,COUNT(*)
FROM week13.employees GROUP BY 1,2 ORDER BY 1,2;
SELECT CASE WHEN age<30 THEN 'Under 30' WHEN age<=50 THEN '30-50' ELSE 'Over 50' END AS age_group,COUNT(*) AS employees,ROUND(AVG(salary),2)
FROM week13.employees GROUP BY 1 ORDER BY 1;
SELECT department,COUNT(*) AS people FROM week13.employees GROUP BY department HAVING COUNT(*)>=2 ORDER BY department;
SELECT name,department,salary,ROUND(AVG(salary) OVER(PARTITION BY department),2) AS department_average FROM week13.employees ORDER BY id;
SELECT COUNT(*) AS total_rows,COUNT(email) AS non_null_emails,COUNT(*)-COUNT(email) AS null_emails,
       SUM(bonus) AS total_bonus,ROUND(AVG(bonus),2) AS average_bonus,COUNT(bonus) AS with_bonus FROM week13.employees;
SELECT department,COUNT(*) AS people,COUNT(*) FILTER(WHERE salary>75000) AS high_earners,
       COUNT(*) FILTER(WHERE hire_date>='2023-01-01') AS recent_hires,
       ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM week13.employees),2) AS percentage
FROM week13.employees GROUP BY department ORDER BY department;
COMMIT;
