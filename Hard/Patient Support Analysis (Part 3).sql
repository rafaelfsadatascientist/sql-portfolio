--DataLemur: Patient Support Analysis (Part 3)
-- Dialect: PostgreSQL
--Level: Hard
--Tables: callers(policy_holder_id,case_id,call_category,call_date,call_duration_secs)
--Key Concepts: LAG, DISTINCT, INTERVALs

WITH previous_call_date_CTE AS (
    SELECT
        policy_holder_id,
        call_date,
        LAG(call_date) OVER (
            PARTITION BY policy_holder_id
            ORDER BY call_date
        ) AS previous_call_date
    FROM callers
)
SELECT
    COUNT(DISTINCT policy_holder_id) AS policy_holder_count
FROM previous_call_date_CTE
WHERE call_date - previous_call_date <= INTERVAL '7 days';
