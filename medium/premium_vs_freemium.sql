--StrataScratch: Premium vs Freemium
-- Dialect: PostgreSQL
--Level: Medium
--Tables: ms_user_dimension(acc_id,user_id) & ms_acc_dimension(acc_id,paying_customer) & ms_download_facts(date,downloads,user_id)
--Key Concepts: JOINs, CTEs, CASE WHEN

WITH auxiliar_cte AS (
    SELECT
        SUM(ms_df.downloads) AS total_downloads,
        ms_df.date,
        ms_acc_dim.paying_customer
    FROM ms_user_dimension ms_user_dim
    LEFT JOIN ms_acc_dimension ms_acc_dim
        ON ms_user_dim.acc_id = ms_acc_dim.acc_id
    LEFT JOIN ms_download_facts ms_df
        ON ms_df.user_id = ms_user_dim.user_id
    GROUP BY
        ms_df.date,
        ms_acc_dim.paying_customer
),
paying_users AS (
    SELECT 
        date,
        total_downloads AS paying
    FROM auxiliar_cte
    WHERE paying_customer = 'yes'
),
non_paying_users AS (
    SELECT 
        date,
        total_downloads AS non_paying
    FROM auxiliar_cte
    WHERE paying_customer = 'no'
)
SELECT
    paying_users.date AS download_date,
    paying,
    non_paying
FROM paying_users
LEFT JOIN non_paying_users
    ON paying_users.date = non_paying_users.date
WHERE non_paying > paying
order by 1 asc;

-- This query could be written with fewer CTEs using CASE WHEN
