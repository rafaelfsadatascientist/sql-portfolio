--DataLemur: Patient Support Analysis (Part 4)
-- Dialect: PostgreSQL
--Level: Hard
--Tables: callers(policy_holder_id,case_id,call_category,call_date,call_duration_secs)
--Key Concepts: LAG, ROUND, CTEs

WITH long_calls_CTE AS (
    SELECT
        case_id,
        EXTRACT(YEAR FROM call_date)  AS yr,
        EXTRACT(MONTH FROM call_date) AS mth
    FROM callers
    WHERE call_duration_secs > 300
),

count_CTE AS (
    SELECT
        yr,
        mth,
        COUNT(case_id) AS case_id_count
    FROM long_calls_CTE
    GROUP BY
        yr,
        mth
),

LAG_CTE AS (
    SELECT
        *,
        LAG(case_id_count) OVER (
            ORDER BY yr, mth
        ) AS previous_case_id_count
    FROM count_CTE
)

SELECT
    yr,
    mth,
    ROUND(
        100 * (
            (case_id_count::numeric
            / NULLIF(previous_case_id_count, 0))
            - 1
        ),
        1
    ) AS long_calls_growth_pct
FROM LAG_CTE;
