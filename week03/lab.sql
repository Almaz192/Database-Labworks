-- Week 3: run this file through psql (meta-commands are not SQL).
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
-- Practice DROP TABLE only on a disposable table created here.
CREATE TABLE week03.drop_demo (id INTEGER);
DROP TABLE week03.drop_demo;
\dt week03.*
-- psql exits when this file ends; use \q in an interactive session.
