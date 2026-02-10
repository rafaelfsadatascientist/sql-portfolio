--LeetCode: Find Zombie Sessions
-- Dialect: PostgreSQL
--Level: Hard
--Tables: app_events(event_id,user_id,event_timestamp,event_type,session_id,event_value)
--Concepts: CASE WHEN, HAVING, CTE'S, Window Functions

WITH auxiliar_CTE AS (
    SELECT
        session_id,
        user_id,
        event_type,
        MIN(event_timestamp) OVER (PARTITION BY session_id) AS beggining_of_session,
        MAX(event_timestamp) OVER (PARTITION BY session_id) AS end_of_session
    FROM app_events
)
SELECT
    session_id,
    user_id,
    (EXTRACT(EPOCH FROM end_of_session - beggining_of_session)::NUMERIC) / 60 AS session_duration_minutes,
    COUNT(CASE WHEN event_type = 'scroll' THEN 1 ELSE NULL END) AS scroll_count
FROM auxiliar_CTE
WHERE (EXTRACT(EPOCH FROM end_of_session - beggining_of_session)::NUMERIC) / 60 > 30
GROUP BY 1,2,3
HAVING COUNT(CASE WHEN event_type = 'purchase' THEN 1 ELSE NULL END) = 0
   AND (COUNT(CASE WHEN event_type = 'click' THEN 1 ELSE NULL END)::NUMERIC)
       / COUNT(CASE WHEN event_type = 'scroll' THEN 1 ELSE NULL END) < 0.2
   AND COUNT(CASE WHEN event_type = 'scroll' THEN 1 ELSE NULL END) >= 5
ORDER BY 4 DESC, 1 ASC