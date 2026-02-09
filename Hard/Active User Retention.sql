--DataLemur: Active User Retention
-- Dialect: PostgreSQL
--Level: Hard
--Tables: user_actions(user_id,event_id,event_type,event_date) 
--Concepts: CTEs, EXTRACT, Subqueries, Filtering

WITH July_CTE AS (
    SELECT 
        user_id,
        EXTRACT(MONTH FROM event_date) AS mth
    FROM user_actions
    WHERE EXTRACT(YEAR FROM event_date) = 2022
      AND EXTRACT(MONTH FROM event_date) = 7
      AND event_type IN ('sign-in', 'like', 'comment')
),

June_CTE AS (
    SELECT 
        user_id
    FROM user_actions
    WHERE EXTRACT(YEAR FROM event_date) = 2022
      AND EXTRACT(MONTH FROM event_date) = 6
      AND event_type IN ('sign-in', 'like', 'comment')
)

SELECT
    COUNT(DISTINCT user_id) AS monthly_active_users,
    mth
FROM July_CTE
WHERE user_id IN (SELECT user_id FROM June_CTE)
GROUP BY mth