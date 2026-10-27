-- Week 3: psql meta-commands and table inspection.
\conninfo
\l
\connect :DBNAME
CREATE SCHEMA week03;
CREATE TABLE week03.students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INTEGER
);
INSERT INTO week03.students (name, age) VALUES ('Alice', 21), ('Bob', 23);
\dt week03.*
\d week03.students
SELECT * FROM week03.students ORDER BY id;
\h SELECT
CREATE TABLE week03.drop_demo (id INTEGER);
DROP TABLE week03.drop_demo;
\dt week03.*
