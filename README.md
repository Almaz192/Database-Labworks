# Database Labworks

**Almaz Akzholtoev** · PostgreSQL · macOS

Laboratory work for Weeks 1–17. Each folder contains SQL files, a short report, and results from the local PostgreSQL server.

| Week | Laboratory work |
| --- | --- |
| 1 | [Introduction to Relational Databases](week01/README.md) |
| 2 | [Installing PostgreSQL and pgAdmin](week02/README.md) |
| 3 | [Basic psql Commands](week03/README.md) |
| 4 | [First SQL Query](week04/README.md) |
| 5 | [Databases](week05/README.md) |
| 6 | [Tables, Data Types and Constraints](week06/README.md) |
| 7 | [Primary Keys](week07/README.md) |
| 8 | [Foreign Keys and Relationships](week08/README.md) |
| 9 | [Database Design Basics](week09/README.md) |
| 10 | [Viewing Database and Table Structure](week10/README.md) |
| 11 | [Basic Data Operations](week11/README.md) |
| 12 | [Querying Data](week12/README.md) |
| 13 | [Aggregate Functions](week13/README.md) |
| 14 | [Joining Tables](week14/README.md) |
| 15 | [Advanced Querying](week15/README.md) |
| 16 | [Transactions and ACID](week16/README.md) |
| 17 | [Data Import, Export and Backup](week17/README.md) |

## Running the SQL

The examples use PostgreSQL 18 on macOS. Connect to a dedicated lab database with your local role, then run each `lab.sql` once, in week order, using psql. Each week has its own schema; Week 10 inspects the Week 9 design. Some files contain psql commands and must not be run as a whole in Query Tool.

```sh
psql -X -v ON_ERROR_STOP=1 -h localhost -U akzholtoev -d database_labworks_20261020 -f week09/lab.sql
psql -X -v ON_ERROR_STOP=1 -h localhost -U akzholtoev -d database_labworks_20261020 -f week09/verify.sql
```

The `verify.sql` files are read-only and can be rerun in psql or pgAdmin Query Tool. Week 16 describes the two-session isolation tests; Week 17 includes the file import and backup commands.
