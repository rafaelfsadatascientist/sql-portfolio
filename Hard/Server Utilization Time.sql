--DataLemur: Server Utilization Time
-- Dialect: PostgreSQL
--Level: Hard
--Tables: server_utilization(server_id,status_time,session_status)
--Key Concepts: Window Functions, FLOOR, JOINs

WITH start_rank_CTE AS (
    SELECT
        server_id,
        status_time,
        ROW_NUMBER() OVER (
            PARTITION BY server_id
            ORDER BY status_time
        ) AS start_rank
    FROM server_utilization
    WHERE session_status = 'start'
),
stop_rank_CTE AS (
    SELECT
        server_id,
        status_time,
        ROW_NUMBER() OVER (
            PARTITION BY server_id
            ORDER BY status_time
        ) AS stop_rank
    FROM server_utilization
    WHERE session_status = 'stop'
)
SELECT
    EXTRACT(
        DAYS
        FROM SUM(stop_rank_CTE.status_time - start_rank_CTE.status_time)
    )
    + FLOOR(
        EXTRACT(
            HOURS
            FROM SUM(stop_rank_CTE.status_time - start_rank_CTE.status_time)
        )::numeric / 24
    ) AS total_uptime_days
FROM start_rank_CTE
INNER JOIN stop_rank_CTE
    ON start_rank_CTE.server_id = stop_rank_CTE.server_id
   AND start_rank_CTE.start_rank = stop_rank_CTE.stop_rank;

-- This solution relies heavily on the problem assumptions.
-- JUSTIFY_INTERVAL or EPOCH could be used as an alternative to handle the interval sum.




