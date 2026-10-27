# Week 16 — Transactions and ACID

Tested COMMIT, ROLLBACK, SAVEPOINT, constraint failures, and concurrent transactions. The final balances are Alice 875.00 and Bob 625.00; every recorded stage preserves the total of 1,500. A new connection confirmed the committed balances.

[SQL](lab.sql) · [Verification](verify.sql) · [Lesson](https://docs.google.com/document/d/1dgJPa86-PnyEBxg-cHCSPlxmeJ3an0oZ/edit)

## Concurrent-session results

The same row was read twice in one transaction while another connection committed an update. All four checks passed; [isolation.sql](isolation.sql) displays the measured results.

| Isolation level | First read | Second read | Observation |
| --- | ---: | ---: | --- |
| READ COMMITTED | 1 | 2 | A later statement sees the committed update. |
| REPEATABLE READ | 1 | 1 | The transaction keeps its original snapshot. |
| SERIALIZABLE | 1 | 1 | The transaction keeps a consistent snapshot. |
| READ UNCOMMITTED | 1 | 2 | No dirty read; the second read follows the writer's commit. |

PostgreSQL treats READ UNCOMMITTED as READ COMMITTED, and its REPEATABLE READ also prevents phantom reads. These details differ from the generic isolation table in the lesson. See the [PostgreSQL isolation documentation](https://www.postgresql.org/docs/18/transaction-iso.html).

To repeat the visibility test in two psql sessions, reset `week16.isolation_probe.value` to 1. In session A, begin with the chosen isolation level and SELECT the row. In session B, update it to 2 and commit. SELECT again in A, then commit. For the dirty-read check, make the first read while B's update is still uncommitted.

![Week 16 pgAdmin psql result](https://raw.githubusercontent.com/Almaz192/Database-Labworks/d3f703c77235c3a65b29a5e871673c6783ba940c/.evidence/week16-result.png)

[All labs](../README.md)
