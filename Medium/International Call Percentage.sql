--DataLemur: International Call Percentage
-- Dialect: PostgreSQL
--Level: Medium
--Tables: phone_calls(caller_id,receiver_id,call_time) & phone_info(caller_id,country_id,network,phone_number)
--Key Concepts: CTEs, JOINs, CASE WHEN, ROUND

WITH caller_cte AS (
    SELECT 
        p_calls.caller_id,
        p_calls.receiver_id,
        country_id AS caller_country
    FROM phone_calls AS p_calls
    INNER JOIN phone_info AS p_info
        ON p_calls.caller_id = p_info.caller_id
),
receiver_cte AS (
    SELECT
        caller_cte.caller_id,
        caller_cte.receiver_id,
        caller_cte.caller_country,
        p_info.country_id AS receiver_country
    FROM caller_cte
    INNER JOIN phone_info AS p_info
        ON caller_cte.receiver_id = p_info.caller_id
)
SELECT
    ROUND(
        100 * ((COUNT(CASE WHEN caller_country != receiver_country THEN 1 END)::NUMERIC)
        / COUNT(*)),
        1
    ) AS international_calls_pct
FROM receiver_cte;
