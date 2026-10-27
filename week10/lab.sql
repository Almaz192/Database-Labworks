-- Week 10: psql metadata commands.
CREATE SCHEMA week10;
\dn week*
\dt week09.*
\d week09.loans
\di week09.*
SELECT table_name,column_name,data_type,is_nullable
FROM information_schema.columns
WHERE table_schema='week09' AND table_name='loans' ORDER BY ordinal_position;
SELECT conrelid::regclass AS table_name,conname,pg_get_constraintdef(oid) AS definition
FROM pg_constraint WHERE connamespace='week09'::regnamespace ORDER BY conrelid::regclass::text,conname;
CREATE VIEW week10.table_summary AS
SELECT t.table_name,COUNT(c.column_name) AS columns
FROM information_schema.tables t
JOIN information_schema.columns c USING(table_catalog,table_schema,table_name)
WHERE t.table_schema='week09' AND t.table_type='BASE TABLE'
GROUP BY t.table_name;
SELECT * FROM week10.table_summary ORDER BY table_name;
