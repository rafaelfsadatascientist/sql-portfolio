--LeetCode: Most Common Course Pairs
-- Dialect: PostgreSQL
--Level: Hard
--Tables: course_completions(user_id,course_id,course_name,completion_date,course_rating)
--Concepts: CTEs, Lead, Having, Joins, Upper

with top_performing_students as(select
user_id,
count(course_id) as number_of_courses,
avg(course_rating) as avg_rating
from course_completions
group by 1
having count(course_id)>=5 and avg(course_rating)>=4),
second_course as(select
cc.user_id,
cc.course_name as first_course,
lead(cc.course_name) over(partition by cc.user_id order by cc.completion_date asc) as second_course
from course_completions as cc
inner join top_performing_students as tps
on cc.user_id=tps.user_id)
select
first_course,
second_course,
count(user_id) as transition_count
from second_course
where second_course is not null
group by 1,2
order by 3 desc, upper(first_course) asc, upper(second_course) asc

-- Used UPPER() in ORDER BY to prevent case-sensitive sorting issues
-- (e.g., 'Advanced Python' appearing after 'API Design')
