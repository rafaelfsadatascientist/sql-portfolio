--StrataScratch: User with Most Approved Flags
-- Dialect: PostgreSQL
--Level: Medium
--Tables: user_flags(flag_id,user_firstname,user_lastname,video_id) & flag_review(flag_id,reviewed_by_yt,reviewed_date,reviewed_outcome)
--Concepts: CTEs, Ranks, Joins, Where

WITH number_of_videos AS (
    SELECT
        COUNT(distinct video_id) AS number_of_videos,
        user_firstname,
        user_lastname
    FROM user_flags AS uf
    INNER JOIN flag_review AS fr
        ON uf.flag_id = fr.flag_id
    WHERE reviewed_outcome = 'APPROVED'
    GROUP BY 2, 3
),
creating_rank AS (
    SELECT
        number_of_videos,
        user_firstname || ' ' || user_lastname AS username,
        DENSE_RANK() OVER (ORDER BY number_of_videos DESC) AS number_of_videos_rank
    FROM number_of_videos
)
SELECT 
    username
FROM creating_rank
WHERE number_of_videos_rank = 1