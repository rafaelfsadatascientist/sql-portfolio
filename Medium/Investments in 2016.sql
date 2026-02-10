--LeetCode: Investments in 2016
-- Dialect: PostgreSQL
--Level: Medium
--Tables: insurance(pid,tiv_2015,tiv_2016,lat,lon)
--Key Concepts: HAVING, CTEs, JOINs

WITH city_CTE AS (
    SELECT
        pid,
        tiv_2015,
        tiv_2016,
        lat || '-' || lon AS city
    FROM insurance
),
same_tiv_2015_CTE AS (
    SELECT
        COUNT(pid),
        tiv_2015
    FROM insurance
    GROUP BY 2
    HAVING COUNT(pid) >= 2
),
same_city_CTE AS (
    SELECT
        COUNT(pid),
        city
    FROM city_CTE
    GROUP BY 2
    HAVING COUNT(pid) = 1
)
SELECT
    ROUND(SUM(tiv_2016)::NUMERIC, 2) AS tiv_2016
FROM city_CTE
INNER JOIN same_tiv_2015_CTE
    ON city_CTE.tiv_2015 = same_tiv_2015_CTE.tiv_2015
INNER JOIN same_city_CTE
    ON city_CTE.city = same_city_CTE.city;
