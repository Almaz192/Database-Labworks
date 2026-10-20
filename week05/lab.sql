-- Week 5: CREATE DATABASE and DROP DATABASE cannot run in a transaction.
-- Remember the lab database before changing connections.
\set home_db :DBNAME
\set scratch_db :DBNAME _lab05_scratch
CREATE SCHEMA week05;
CREATE TABLE week05.database_events (
    step INTEGER PRIMARY KEY,
    operation TEXT NOT NULL,
    database_name TEXT NOT NULL,
    verified BOOLEAN NOT NULL
);
CREATE DATABASE :"scratch_db";
INSERT INTO week05.database_events
SELECT 1, 'CREATE DATABASE', :'scratch_db',
       EXISTS (SELECT FROM pg_database WHERE datname = :'scratch_db');
\connect :scratch_db
SELECT current_database() AS connected_scratch_database;
CREATE TABLE connection_check (id INTEGER PRIMARY KEY, note TEXT NOT NULL);
INSERT INTO connection_check VALUES (1, 'Scratch database connection works');
SELECT * FROM connection_check;
\connect :home_db
INSERT INTO week05.database_events
VALUES (2, 'CONNECT and return', :'scratch_db', TRUE);
-- Only the scratch database successfully created above is removed.
DROP DATABASE :"scratch_db";
INSERT INTO week05.database_events
SELECT 3, 'DROP DATABASE', :'scratch_db',
       NOT EXISTS (SELECT FROM pg_database WHERE datname = :'scratch_db');
SELECT * FROM week05.database_events ORDER BY step;
DO $$ BEGIN
    IF EXISTS (SELECT FROM week05.database_events WHERE NOT verified) THEN
        RAISE EXCEPTION 'Week 5 database lifecycle check failed';
    END IF;
END $$;
