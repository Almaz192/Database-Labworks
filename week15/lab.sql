-- Week 15: subqueries, recursion, sets, windows, pivots and query plans.
BEGIN;
CREATE SCHEMA week15;
CREATE TABLE week15.employees(id INTEGER PRIMARY KEY,name TEXT,department TEXT,salary NUMERIC(10,2),manager_id INTEGER REFERENCES week15.employees,tenure INTEGER);
INSERT INTO week15.employees VALUES(1,'Alice','Engineering',120000,NULL,10),(2,'Bob','Engineering',80000,1,5),(3,'Carol','Sales',70000,1,8),(4,'David','Sales',50000,3,2),(5,'Eva','HR',60000,1,12),(6,'Brad','Engineering',80000,2,7);
SELECT name,salary FROM week15.employees WHERE salary>(SELECT AVG(salary) FROM week15.employees) ORDER BY id;
SELECT name,salary FROM week15.employees WHERE(department,salary)=(SELECT department,MAX(salary) FROM week15.employees WHERE department='Engineering' GROUP BY department);
SELECT department,total_salary FROM(SELECT department,SUM(salary) AS total_salary FROM week15.employees GROUP BY department) d WHERE total_salary>100000;
WITH department_totals AS(SELECT department,SUM(salary) AS total_salary FROM week15.employees GROUP BY department)
SELECT * FROM department_totals WHERE total_salary>100000 ORDER BY department;
CREATE VIEW week15.org_chart AS
WITH RECURSIVE org AS(
    SELECT id,name,manager_id,1 AS depth FROM week15.employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.id,e.name,e.manager_id,o.depth+1 FROM week15.employees e JOIN org o ON e.manager_id=o.id
) SELECT * FROM org;
SELECT * FROM week15.org_chart ORDER BY depth,id;
CREATE TABLE week15.warehouse_1(product_name TEXT PRIMARY KEY,quantity INTEGER);
CREATE TABLE week15.warehouse_2(product_name TEXT PRIMARY KEY,quantity INTEGER);
INSERT INTO week15.warehouse_1 VALUES('Notebook',0),('Laptop',5),('Keyboard',0);
INSERT INTO week15.warehouse_2 VALUES('Notebook',0),('Mouse',4),('Keyboard',3);
SELECT product_name FROM week15.warehouse_1 UNION SELECT product_name FROM week15.warehouse_2 ORDER BY product_name;
SELECT product_name FROM week15.warehouse_1 UNION ALL SELECT product_name FROM week15.warehouse_2 ORDER BY product_name;
SELECT product_name FROM week15.warehouse_1 WHERE quantity=0 INTERSECT SELECT product_name FROM week15.warehouse_2 WHERE quantity=0;
SELECT product_name FROM week15.warehouse_1 EXCEPT SELECT product_name FROM week15.warehouse_2;
CREATE VIEW week15.salary_ranks AS
SELECT id,name,department,salary,
ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC,id) AS row_number,
RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS salary_rank,
DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS dense_rank,
SUM(salary) OVER(PARTITION BY department) AS department_total,
LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC,id) AS previous_salary,
LEAD(salary) OVER(PARTITION BY department ORDER BY salary DESC,id) AS next_salary
FROM week15.employees;
SELECT * FROM week15.salary_ranks ORDER BY department,row_number;
SELECT id,SUM(salary) OVER(PARTITION BY department),AVG(salary) FILTER(WHERE tenure>5) OVER() FROM week15.employees ORDER BY id;
CREATE TABLE week15.sales(product_name TEXT,year INTEGER,sales_amount NUMERIC(10,2));
INSERT INTO week15.sales VALUES('Notebook',2022,100),('Notebook',2023,150),('Notebook',2024,200),('Keyboard',2022,200),('Keyboard',2023,250),('Keyboard',2024,300);
CREATE VIEW week15.pivoted_sales AS SELECT product_name,
SUM(sales_amount) FILTER(WHERE year=2022) AS year_2022,
SUM(sales_amount) FILTER(WHERE year=2023) AS year_2023,
SUM(sales_amount) FILTER(WHERE year=2024) AS year_2024 FROM week15.sales GROUP BY product_name;
SELECT * FROM week15.pivoted_sales ORDER BY product_name;
SELECT product_name,2022 AS year,year_2022 AS amount FROM week15.pivoted_sales
UNION ALL SELECT product_name,2023,year_2023 FROM week15.pivoted_sales
UNION ALL SELECT product_name,2024,year_2024 FROM week15.pivoted_sales ORDER BY product_name,year;
CREATE TABLE week15.orders(order_id INTEGER PRIMARY KEY,status TEXT);
INSERT INTO week15.orders VALUES(1,'Low Priority'),(2,'High Priority'),(3,'Medium Priority');
SELECT * FROM week15.orders ORDER BY CASE status WHEN 'High Priority' THEN 1 WHEN 'Medium Priority' THEN 2 ELSE 3 END;
CREATE INDEX employees_salary_idx ON week15.employees(salary);
ANALYZE week15.employees;
EXPLAIN SELECT name,salary FROM week15.employees WHERE salary>75000;
EXPLAIN (ANALYZE,BUFFERS) SELECT name,salary FROM week15.employees WHERE salary>75000;
COMMIT;
