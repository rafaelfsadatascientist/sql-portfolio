--DataLemur: Card Launch Sucess
-- Dialect: PostgreSQL
--Level: Medium
--Tables: monthly_cards_issued(issue_month,issue_year,card_name,issued_amount)
--Key Concepts: RANKs, DATEs, CTEs

WITH creating_dates AS (
    SELECT
        card_name,
        issued_amount,
        CAST(CONCAT('01-', issue_month, '-', issue_year) AS DATE) AS issue_date
    FROM monthly_cards_issued
),

creating_ranks AS (
    SELECT
        card_name,
        issued_amount,
        DENSE_RANK() OVER (
            PARTITION BY card_name
            ORDER BY issue_date ASC
        ) AS issue_date_rank
    FROM creating_dates
)

SELECT
    card_name,
    issued_amount
FROM creating_ranks
WHERE issue_date_rank = 1
ORDER BY issued_amount DESC;


-- We could have created the date using the make_date function
