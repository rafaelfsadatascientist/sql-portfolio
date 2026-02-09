
--StrataScratch: Sending vs. Opening Snaps
-- Dialect: PostgreSQL
--Level: Medium
--Tables: activities(activity_id,user_id,activity_type,time_spent,activity_date) & age_breakdown(user_id,age_bucket)
--Concepts: Round, Joins, Cast, Case When

WITH calculating_times AS (
    SELECT 
        ab.age_bucket,
        SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0 END) AS time_spent_opening,
        SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0 END) AS time_spent_sending,
        SUM(CASE WHEN a.activity_type IN ('open', 'send') THEN a.time_spent ELSE 0 END) AS total_time
    FROM activities a
    JOIN age_breakdown ab
        ON a.user_id = ab.user_id
    GROUP BY ab.age_bucket
)
SELECT
    age_bucket,
    ROUND(((time_spent_opening::NUMERIC) / total_time) * 100, 2) AS open_perc,
    ROUND(((time_spent_sending::NUMERIC) / total_time) * 100, 2) AS send_perc
FROM calculating_times
