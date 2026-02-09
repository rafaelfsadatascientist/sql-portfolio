--StrataScratch: Highest Cost Orders
-- Dialect: PostgreSQL
--Level: Medium
--Tables: customers(address,city,first_name,id,last_name,phone_number) & orders(cust_id,id,order_date,order_details,total_order_cost)
--Concepts: JOINs, CTEs, Window Functions, BETWEEN

WITH daily_total_order_cost AS (
    SELECT
        cust_id,
        order_date,
        SUM(total_order_cost) AS daily_total_order_cost
    FROM orders
    WHERE order_date BETWEEN '2019-02-01' AND '2019-05-01'
    GROUP BY 1, 2
),
highest_daily_total_order_cost AS (
    SELECT
        cust_id,
        order_date,
        daily_total_order_cost,
        MAX(daily_total_order_cost) OVER (PARTITION BY order_date) AS highest_daily_total_order_cost
    FROM daily_total_order_cost
)
SELECT
    customers.first_name,
    hd_total_order_cost.order_date,
    hd_total_order_cost.daily_total_order_cost AS max_cost
FROM highest_daily_total_order_cost AS hd_total_order_cost
INNER JOIN customers 
    ON customers.id = hd_total_order_cost.cust_id
WHERE hd_total_order_cost.daily_total_order_cost = hd_total_order_cost.highest_daily_total_order_cost
