-- Week 16: results measured using two concurrent psql connections.
SELECT test, first_read, second_read, passed
FROM week16.isolation_results
ORDER BY test;
