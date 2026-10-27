-- Week 14: join types and relationship patterns.
BEGIN;
CREATE SCHEMA week14;
CREATE TABLE week14.customers(customer_id INTEGER PRIMARY KEY,name TEXT NOT NULL,email TEXT);
CREATE TABLE week14.orders(order_id INTEGER PRIMARY KEY,customer_id INTEGER REFERENCES week14.customers,order_date DATE,total_amount NUMERIC(10,2));
CREATE TABLE week14.products(product_id INTEGER PRIMARY KEY,product_name TEXT,price NUMERIC(10,2));
CREATE TABLE week14.order_items(order_id INTEGER REFERENCES week14.orders,product_id INTEGER REFERENCES week14.products,quantity INTEGER CHECK(quantity>0),PRIMARY KEY(order_id,product_id));
INSERT INTO week14.customers VALUES(1,'Alice','alice@example.com'),(2,'Bob','bob@example.com'),(3,'Carol','carol@example.com');
INSERT INTO week14.orders VALUES(1,1,'2026-10-01',200),(2,1,'2026-10-02',50),(3,2,'2026-10-03',100),(4,NULL,'2026-10-04',25);
INSERT INTO week14.products VALUES(101,'Keyboard',50),(102,'Notebook',25);
INSERT INTO week14.order_items VALUES(1,101,4),(2,101,1),(3,102,4),(4,102,1);
SELECT c.name,o.order_id,o.total_amount FROM week14.customers c INNER JOIN week14.orders o USING(customer_id) ORDER BY o.order_id;
SELECT c.name,o.order_id,o.total_amount FROM week14.customers c LEFT JOIN week14.orders o USING(customer_id) ORDER BY c.customer_id,o.order_id;
SELECT c.name,o.order_id,o.total_amount FROM week14.customers c RIGHT JOIN week14.orders o USING(customer_id) ORDER BY o.order_id;
SELECT c.name,o.order_id,o.total_amount FROM week14.customers c FULL JOIN week14.orders o USING(customer_id) ORDER BY c.customer_id NULLS LAST,o.order_id;
SELECT c.name,p.product_name FROM week14.customers c CROSS JOIN week14.products p ORDER BY c.customer_id,p.product_id;
SELECT c.name,o.order_date,oi.quantity,p.product_name,p.price FROM week14.customers c
JOIN week14.orders o USING(customer_id) JOIN week14.order_items oi USING(order_id) JOIN week14.products p USING(product_id) ORDER BY o.order_id,p.product_id;
CREATE TABLE week14.employees(employee_id INTEGER PRIMARY KEY,name TEXT,manager_id INTEGER REFERENCES week14.employees);
INSERT INTO week14.employees VALUES(1,'Alice',NULL),(2,'Bob',1),(3,'Carol',1);
SELECT e.name AS employee,m.name AS manager FROM week14.employees e LEFT JOIN week14.employees m ON e.manager_id=m.employee_id ORDER BY e.employee_id;
CREATE TABLE week14.profiles(customer_id INTEGER PRIMARY KEY REFERENCES week14.customers,city TEXT);
INSERT INTO week14.profiles VALUES(1,'Bishkek'),(2,'Osh');
SELECT c.name,p.city FROM week14.customers c LEFT JOIN week14.profiles p USING(customer_id) ORDER BY c.customer_id;
CREATE TABLE week14.students(student_id INTEGER PRIMARY KEY,name TEXT);
CREATE TABLE week14.courses(course_id INTEGER PRIMARY KEY,title TEXT);
CREATE TABLE week14.enrollments(student_id INTEGER REFERENCES week14.students,course_id INTEGER REFERENCES week14.courses,PRIMARY KEY(student_id,course_id));
INSERT INTO week14.students VALUES(1,'Alice'),(2,'Bob');
INSERT INTO week14.courses VALUES(1,'Databases'),(2,'Programming');
INSERT INTO week14.enrollments VALUES(1,1),(1,2),(2,1);
SELECT s.name,c.title FROM week14.students s JOIN week14.enrollments e USING(student_id) JOIN week14.courses c USING(course_id) ORDER BY s.student_id,c.course_id;
CREATE INDEX orders_customer_idx ON week14.orders(customer_id);
CREATE INDEX order_items_product_idx ON week14.order_items(product_id);
SELECT c.name,o.order_id FROM week14.customers c JOIN week14.orders o USING(customer_id) WHERE o.order_date>='2026-10-01' AND o.total_amount>100;
SELECT c.name FROM week14.customers c LEFT JOIN week14.orders o USING(customer_id) WHERE o.order_id IS NULL;
CREATE VIEW week14.join_counts AS
SELECT 'INNER JOIN' AS join_type,COUNT(*) AS rows_returned FROM week14.customers c JOIN week14.orders o USING(customer_id)
UNION ALL SELECT 'LEFT JOIN',COUNT(*) FROM week14.customers c LEFT JOIN week14.orders o USING(customer_id)
UNION ALL SELECT 'RIGHT JOIN',COUNT(*) FROM week14.customers c RIGHT JOIN week14.orders o USING(customer_id)
UNION ALL SELECT 'FULL JOIN',COUNT(*) FROM week14.customers c FULL JOIN week14.orders o USING(customer_id)
UNION ALL SELECT 'CROSS JOIN',COUNT(*) FROM week14.customers CROSS JOIN week14.products;
SELECT * FROM week14.join_counts ORDER BY join_type;
COMMIT;
