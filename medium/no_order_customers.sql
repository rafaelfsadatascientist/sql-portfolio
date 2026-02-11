--StrataScratch: No Order Customers
-- Dialect: PostgreSQL
--Level: Medium
--Tables: customer(address,city,first_name,id,last_name,phone_number) & orders(cust_id,id,order_date,order_details,total_order_cost)
--Key Concepts: CTEs, JOINs, BETWEEN, NULLs

WITH customers_in_date_range AS (
    SELECT 
        customers.id 
    FROM customers 
    INNER JOIN orders 
        ON customers.id = orders.cust_id 
    WHERE order_date BETWEEN '2019-02-01' AND '2019-03-01'
)
SELECT 
    customers.first_name
FROM customers
LEFT JOIN customers_in_date_range
    ON customers.id = customers_in_date_range.id
WHERE customers_in_date_range.id IS NULL;
