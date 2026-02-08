--DataLemur: Final Account Balance
-- Dialect: PostgreSQL
--Level: Easy
--Tables: transactions(transaction_id,account_id,amount,transaction_type)
--Concepts: Sum, Case When, Group by

SELECT 
account_id,
sum(case when transaction_type='Deposit' then amount
when transaction_type='Withdrawal' then -amount
end) as final_balance
FROM transactions
group by 1