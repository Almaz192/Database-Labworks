# Week 17 — Data Import, Export and Backup

Exported and imported CSV data, tested custom delimiters and NULL markers, migrated records with an upsert, and restored both custom-format and plain SQL backups. All six validation checks passed. The full restore matched row counts and contents across 63 tables.

[SQL](lab.sql) · [Verification](verify.sql) · [Lesson](https://docs.google.com/document/d/1qLJkCgDSG3LaymACkhLxd_r6B5nqHRmU/edit)

## Import and logical backup commands

Run `lab.sql` once in a fresh lab database first. The commands below show the actual workflow; use new restore-database names when repeating it. Run the copy commands inside psql and the backup commands in Terminal. `COPY` uses a server-side path; `\\copy` accesses files as the client user.

```sql
COPY (SELECT * FROM week17.students ORDER BY student_id)
TO '/tmp/students.csv' WITH (FORMAT csv, HEADER true, NULL 'NULL');
COPY week17.imported_students FROM '/tmp/students.csv'
WITH (FORMAT csv, HEADER true, NULL 'NULL');

\\copy week17.students TO '/tmp/students.psv' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'N/A')
\\copy week17.pipe_import FROM '/tmp/students.psv' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'N/A')

INSERT INTO week17.migration_target VALUES (1,'Old name','Old faculty',NULL);
INSERT INTO week17.migration_target
SELECT * FROM week17.imported_students
ON CONFLICT (student_id) DO UPDATE SET
name=EXCLUDED.name, faculty=EXCLUDED.faculty, note=EXCLUDED.note;

(SELECT * FROM week17.students EXCEPT ALL SELECT * FROM week17.imported_students)
UNION ALL
(SELECT * FROM week17.imported_students EXCEPT ALL SELECT * FROM week17.students);
```

```sh
pg_dump -h localhost -U akzholtoev -d database_labworks_20261020 -Fc -f full-labs.dump
pg_restore --list full-labs.dump
createdb -h localhost -U akzholtoev labworks_restore_new
pg_restore -h localhost -U akzholtoev --exit-on-error -d labworks_restore_new full-labs.dump

pg_dump -h localhost -U akzholtoev -d database_labworks_20261020 -n week17 -f week17-backup.sql
createdb -h localhost -U akzholtoev labworks_plain_restore_new
psql -X -v ON_ERROR_STOP=1 -h localhost -U akzholtoev -d labworks_plain_restore_new -f week17-backup.sql
```

The [exported CSV](students.csv) includes a comma, quoted text, a SQL NULL, and the literal string `NULL`; round-trip comparison preserved all four cases. Verification compared all fields, not only row counts. Backup-status rows are recorded after the corresponding restore succeeds, so a restored backup does not contain its own later success record.

## Physical backup and point-in-time recovery

A separate disposable cluster on port 55432 used WAL archiving and `pg_basebackup -X stream`. After committing event 2, a named restore point was created; unwanted event 3 was committed afterward. The base backup was recovered in another temporary cluster on port 55433 using `restore_command`, `recovery_target_name`, and `recovery.signal`.

The recovered database contained events **1 and 2**, and excluded event **3**. Both temporary servers were stopped after verification. The normal server on port 5432 was not stopped or replaced. Reference: [PostgreSQL continuous archiving and recovery](https://www.postgresql.org/docs/18/continuous-archiving.html).

![Week 17 pgAdmin psql result](https://raw.githubusercontent.com/Almaz192/Database-Labworks/d3f703c77235c3a65b29a5e871673c6783ba940c/.evidence/week17-result.png)

[All labs](../README.md)
