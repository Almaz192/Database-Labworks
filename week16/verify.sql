-- Week 16: transaction effects; total balance remains 1500.
SELECT operation, alice_balance, bob_balance,
       alice_balance+bob_balance AS total_balance
FROM week16.history
ORDER BY stage;
