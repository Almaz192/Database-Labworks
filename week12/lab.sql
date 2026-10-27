-- Week 12: filtering, patterns, subqueries, CASE and CTEs.
BEGIN;
CREATE SCHEMA week12;
CREATE TABLE week12.employees (
    id INTEGER PRIMARY KEY,name TEXT NOT NULL,department TEXT NOT NULL,
    department_id INTEGER NOT NULL,salary NUMERIC(10,2) NOT NULL,
    email TEXT,age INTEGER,hire_date DATE,experience_years INTEGER,bonus NUMERIC(10,2)
);
INSERT INTO week12.employees VALUES
(1,'Alice','Engineering',3,120000,'alice@example.com',32,'2021-03-01',10,5000),
(2,'Bob','Engineering',3,80000,'BOB@GMAIL.COM',27,'2024-04-15',5,NULL),
(3,'Carol','Sales',5,70000,'carol@gmail.com',41,'2022-06-01',15,3000),
(4,'David','Sales',5,50000,NULL,24,'2025-01-10',2,NULL),
(5,'Eva','HR',7,60000,'eva@example.com',36,'2020-10-01',12,2000),
(6,'Brad','Engineering',3,100000,'brad@gmail.com',29,'2023-02-01',7,4000);

CREATE TABLE week12.sales(sale_id INTEGER PRIMARY KEY,employee_id INTEGER REFERENCES week12.employees,amount NUMERIC(10,2));
INSERT INTO week12.sales VALUES(1,1,1500),(2,3,2000),(3,4,500),(4,6,1200);
CREATE TABLE week12.products(product_id INTEGER PRIMARY KEY,product_name TEXT,price NUMERIC(8,2));
INSERT INTO week12.products VALUES(1,'Strawberry',25),(2,'Blueberry',35),(3,'Notebook',15);
SELECT name,department FROM week12.employees ORDER BY id;
SELECT name,salary,salary*0.10 AS potential_bonus FROM week12.employees ORDER BY id;
SELECT name,salary FROM week12.employees WHERE department='Sales';
SELECT name FROM week12.employees WHERE salary>75000 AND department='Engineering';
SELECT name FROM week12.employees WHERE department='HR' OR salary<60000;
SELECT name FROM week12.employees WHERE NOT department='Sales';
SELECT product_name,price FROM week12.products WHERE price BETWEEN 20 AND 50;
SELECT name FROM week12.employees WHERE email IS NULL;
SELECT name FROM week12.employees WHERE email IS NOT NULL;
SELECT name FROM week12.employees WHERE name LIKE 'Bra%';
SELECT product_name FROM week12.products WHERE product_name LIKE '%berry';
SELECT name FROM week12.employees WHERE name LIKE '_o%';
SELECT email FROM week12.employees WHERE email ILIKE '%@gmail.com';
SELECT name FROM week12.employees WHERE name ~ '^[AB]';
SELECT email FROM week12.employees WHERE email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$';
SELECT name FROM week12.employees WHERE name !~ '^[AB]' ORDER BY name;
SELECT name,department FROM week12.employees WHERE department_id IN(3,5,7);
SELECT name FROM week12.employees WHERE id IN(SELECT employee_id FROM week12.sales WHERE amount>1000);
SELECT e.name FROM week12.employees e WHERE EXISTS(SELECT FROM week12.sales s WHERE s.employee_id=e.id AND s.amount>1000);
SELECT name,salary,CASE WHEN salary>100000 THEN 'Senior' WHEN salary BETWEEN 60000 AND 100000 THEN 'Mid-Level' ELSE 'Junior' END AS employee_level FROM week12.employees ORDER BY salary DESC,id;
WITH department_averages AS(SELECT department,AVG(salary) AS avg_salary FROM week12.employees GROUP BY department)
SELECT e.name,e.department,e.salary,ROUND(d.avg_salary,2) AS department_average
FROM week12.employees e JOIN department_averages d USING(department)
WHERE e.salary>d.avg_salary ORDER BY e.name;
COMMIT;
