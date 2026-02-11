--StrataScratch: Reviewed flags of top videos
-- Dialect: PostgreSQL
--Level: Hard
--Tables: user_flags(flag_id,user_firstname,user_lastname,video_id) & flag_review(flag_id,reviewed_by_yt,reviewed_date,reviewed_outcome)
--Key Concepts: CTEs, CASE WHEN, RANKs

WITH flags_count_CTE AS (
    SELECT
        video_id,
        COUNT(flag_id) AS flags_count
    FROM user_flags
    GROUP BY video_id
),
creating_rank AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            ORDER BY flags_count DESC
        ) AS flags_rank
    FROM flags_count_CTE
)
SELECT
    cr.video_id,
    SUM(
        CASE
            WHEN fr.reviewed_by_yt = TRUE THEN 1
            ELSE 0
        END
    ) AS num_flags_reviewed_by_yt
FROM creating_rank AS cr
INNER JOIN user_flags AS uf
    ON uf.video_id = cr.video_id
INNER JOIN flag_review AS fr
    ON fr.flag_id = uf.flag_id
WHERE cr.flags_rank = 1
GROUP BY cr.video_id;
