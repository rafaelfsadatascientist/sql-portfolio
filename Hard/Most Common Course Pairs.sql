--LeetCode: Most Common Course Pairs
-- Dialect: PostgreSQL
--Level: Hard
--Tables: course_completions(user_id,course_id,course_name,completion_date,course_rating)
--Key Concepts: CTEs, LEAD, HAVING, Joins, UPPER

WITH top_performing_students AS (
    SELECT
        user_id,
        count(course_id) AS number_of_courses,
        avg(course_rating) AS avg_rating
    FROM course_completions
    GROUP BY 1
    HAVING count(course_id) >= 5
       AND avg(course_rating) >= 4
),

second_course AS (
    SELECT
        cc.user_id,
        cc.course_name AS first_course,
        lead(cc.course_name) OVER (
            PARTITION BY cc.user_id
            ORDER BY cc.completion_date ASC
        ) AS second_course
    FROM course_completions AS cc
    INNER JOIN top_performing_students AS tps
        ON cc.user_id = tps.user_id
)

SELECT
    first_course,
    second_course,
    count(user_id) AS transition_count
FROM second_course
WHERE second_course IS NOT NULL
GROUP BY 1, 2
ORDER BY
    3 DESC,
    upper(first_course) ASC,
    upper(second_course) ASC;

-- Used UPPER() in ORDER BY to prevent case-sensitive sorting issues
-- (e.g., 'Advanced Python' appearing after 'API Design')
