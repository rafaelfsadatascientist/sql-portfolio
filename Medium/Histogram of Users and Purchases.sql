--DataLemur: Histogram of Users and Purchases
-- Dialect: PostgreSQL
--Level: Medium
--Tables: user_transactions(product_id,user_id,spend,transaction_date)
--Key Concepts: Window Functions, CTEs

WITH most_recent_date_CTE AS (
    SELECT
        user_id,
        product_id,
        transaction_date,
        MAX(transaction_date) OVER (PARTITION BY user_id) AS most_recent_date
    FROM user_transactions
)
SELECT
    COUNT(product_id) AS purchase_count,
    user_id,
    transaction_date
FROM most_recent_date_CTE
WHERE transaction_date = most_recent_date
GROUP BY
    user_id,
    transaction_date
ORDER BY
    transaction_date;
