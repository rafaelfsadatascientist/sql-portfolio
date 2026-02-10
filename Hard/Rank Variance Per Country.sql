--StrataScratch: Rank Variance Per Country
-- Dialect: PostgreSQL
--Level: Hard
--Tables: fb_comments_count(created_at,number_of_comments,user_id) & fb_active_users(country,name,status,user_id)
--Key Concepts: CTEs, RANKs, JOINs

WITH number_of_comments_CTE AS (
    SELECT
        SUM(number_of_comments) AS number_of_comments,
        EXTRACT(MONTH FROM created_at) AS mth,
        country
    FROM fb_comments_count AS fbc
    INNER JOIN fb_active_users AS fau
        ON fbc.user_id = fau.user_id
    WHERE created_at BETWEEN '2019-12-01'::DATE AND '2020-01-31'::DATE
    GROUP BY
        2,3
),
creating_rank AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            PARTITION BY mth
            ORDER BY number_of_comments DESC
        ) AS nc_rank
    FROM number_of_comments_CTE
),
January_CTE AS (
    SELECT
        *
    FROM creating_rank
    WHERE mth = 1
),
December_CTE AS (
    SELECT
        *
    FROM creating_rank
    WHERE mth = 12
)
SELECT
    January_CTE.country;
FROM January_CTE
INNER JOIN December_CTE
    ON January_CTE.country = December_CTE.country
   AND January_CTE.nc_rank < December_CTE.nc_rank
