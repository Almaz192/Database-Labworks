-- Week 14: unmatched rows explain the different join counts.
SELECT join_type, rows_returned
FROM week14.join_counts
ORDER BY join_type;
