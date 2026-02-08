--StrataScratch: Monthly Percentage Difference
-- Dialect: PostgreSQL
--Level: Hard
--Tables: sf_transactions(created_at,id,purchase_id,value)
--Concepts: CTEs, Lag, Round, Extract

WITH cte_monthly_revenue AS (
    SELECT
        SUM(value) AS total_revenue,
        EXTRACT(YEAR FROM created_at) AS year,
        EXTRACT(MONTH FROM created_at) AS month,
        EXTRACT(YEAR FROM created_at)::text || '-' || EXTRACT(MONTH FROM created_at)::text AS year_month
    FROM sf_transactions
    GROUP BY 2, 3, 4
),
cte_revenue_lag AS (
    SELECT
        *,
        LAG(total_revenue) OVER (ORDER BY year, month) AS previous_revenue
    FROM cte_monthly_revenue
)
SELECT
    year_month,
    ROUND(
        100 * (total_revenue - previous_revenue)::numeric / previous_revenue,
        2
    ) AS revenue_diff_pct
FROM cte_revenue_lag