# Reproducing the labs

Requirements: PostgreSQL 18 (or a compatible recent release), psql, Bash, and pgAdmin 4.

From the repository root:

```bash
bash scripts/run_labs.sh
```

The runner creates a separate database, `database_labworks_20261020`, and one schema per week. It stops on unexpected SQL errors and saves command output in each week's `logs/terminal.txt`. Existing databases are not reset. To run again, select a new database name:

```bash
LAB_DATABASE=database_labworks_practice bash scripts/run_labs.sh
```

The connection defaults to `localhost:5432` and the macOS username. Override `PGHOST`, `PGPORT`, or `PGUSER` if needed. A Homebrew installation normally uses the macOS username; a role named `postgres` is not assumed.

In pgAdmin, connect to the same database and open a week's `verify.sql` in the Query Tool. These read-only queries show the saved results without recreating tables. Files named `lab.sql` for Weeks 3 and 5 contain psql meta-commands; run those through psql, not the pgAdmin Query Tool.

Week 5 creates and drops only a new scratch database whose name is derived from the lab database. Weeks 3 and 6 drop only demonstration tables created by those scripts. Constraint tests in Weeks 6–8 deliberately attempt invalid changes inside exception blocks and fail the run if PostgreSQL accepts them.

The source lessons are linked in each report. Their topics guide the exercises; sample data and verification steps are kept in this repository. Screenshots from the previous submission are retained in Weeks 3 and 4. New screenshots show a live psql terminal inside pgAdmin (PSQL Tool); Week 8 also includes the graphical Query Tool result grid. Raw psql logs document the complete exercise execution. These are actual application screenshots, not reconstructed command-output images.

For a short psql demonstration, open the PSQL Tool connected to the lab database and execute a week's `capture.psql`, for example `\i /path/to/Database-Labworks/week03/capture.psql`. It uses relative includes to locate `verify.sql`.
