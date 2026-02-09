--DataLemur: Swapped Food Delivery
-- Dialect: PostgreSQL
--Level: Medium
--Tables: orders(order_id,item)
--Concepts: CTEs, Window Functions, Case When

WITH auxiliar_cte AS (
    SELECT
        CASE
            WHEN order_id % 2 = 1 THEN order_id + 1
            WHEN order_id % 2 = 0 THEN order_id - 1
        END AS auxiliar_column,
        item,
        order_id,
        MAX(order_id) OVER () AS last_order
    FROM orders
)
SELECT
    item,
    CASE
        WHEN order_id = last_order AND order_id % 2 = 1
            THEN order_id
        ELSE auxiliar_column
    END AS corrected_order_id
FROM auxiliar_cte
ORDER BY 2