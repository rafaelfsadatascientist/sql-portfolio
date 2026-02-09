--DataLemur: Highest-Grossing Items
-- Dialect: PostgreSQL
--Level: Medium
--Tables: product_spend(category,product,user_id,spend,transaction_date)
--Concepts: CTEs, RANKs

WITH total_spend_CTE AS (
    SELECT 
        category,
        product,
        SUM(spend) AS total_spend
    FROM product_spend
    WHERE EXTRACT(YEAR FROM transaction_date) = 2022
    GROUP BY category, product
),
creating_rank AS (
    SELECT
        *,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY total_spend DESC) AS total_spend_rank
    FROM total_spend_CTE
)
SELECT
    category,
    product,
    total_spend
FROM creating_rank
WHERE total_spend_rank IN (1, 2)