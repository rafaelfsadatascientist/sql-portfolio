--StrataScratch: Finding User Purchases
-- Dialect: PostgreSQL
--Level: Medium
--Tables: amazon_transactions(created_at,id,item,revenue,user_id)
--Concepts: CTEs, RANKs, Window Functions, BETWEEN

WITH auxiliar_cte AS (
    SELECT
        user_id,
        created_at - MIN(created_at) OVER (PARTITION BY user_id) AS intervals,
        DENSE_RANK() OVER (PARTITION BY user_id ORDER BY created_at ASC) AS created_at_rank
    FROM amazon_transactions
)
SELECT
    user_id
FROM auxiliar_cte
WHERE created_at_rank = 2
  AND intervals BETWEEN 1 AND 7