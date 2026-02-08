--DataLemur: Card Launch Sucess
-- Dialect: PostgreSQL
--Level: Medium
--Tables: monthly_cards_issued(issue_month,issue_year,card_name,issued_amount)
--Concepts: Rank, Dates, CTEs

with creating_dates as(SELECT 
card_name,
issued_amount,
cast(concat('01-',issue_month, '-',issue_year) as date) as issue_date
FROM monthly_cards_issued),
creating_ranks as(SELECT
card_name,
issued_amount,
dense_rank() over(partition by card_name order by issue_date asc) as issue_date_rank
from creating_dates)
SELECT
card_name,
issued_amount
from creating_ranks
where issue_date_rank=1
order by issued_amount desc

-- We could have created the date using the make_date function