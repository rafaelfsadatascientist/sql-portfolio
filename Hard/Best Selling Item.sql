--StrataScratch: Best Selling Item
-- Dialect: PostgreSQL
--Level: Hard
--Tables: online_retail(country,customerid,description,invoicedate,invoiceno,quantity,stockcode,unitprice)
--Concepts: CTEs, Like, Ranks

WITH total_sales_amount AS (
    SELECT
        EXTRACT(MONTH FROM invoicedate) AS month,
        description,
        SUM(unitprice * quantity) AS total_sales_amount
    FROM online_retail
    WHERE invoiceno NOT LIKE 'C%'
    GROUP BY
        1,2
),
creating_rank AS (
    SELECT
        month,
        description,
        total_sales_amount,
        DENSE_RANK() OVER (
            PARTITION BY month
            ORDER BY total_sales_amount DESC
        ) AS total_sales_amount_rank
    FROM total_sales_amount
)
SELECT
    month,
    description,
    total_sales_amount
FROM creating_rank
WHERE total_sales_amount_rank = 1