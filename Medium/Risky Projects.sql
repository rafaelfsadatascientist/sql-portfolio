
--StrataScratch: Risky Projects
-- Dialect: PostgreSQL
--Level: Medium
--Tables: linkedin_projects(budget,end_date,id,start_date,title) & linkedin_emp_projects(emp_id,project_id) & linkedin_employees(first_name,id,last_name,salary)
--Key Concepts: HAVING, CEIL, GROUP BY, JOINs

WITH prorated_cost_per_employee AS (
    SELECT
        lp.title,
        lp.budget,
        le.salary
            * ((lp.end_date - lp.start_date)::NUMERIC / 365)
            AS prorated_cost_per_employee
    FROM linkedin_projects AS lp
    INNER JOIN linkedin_emp_projects AS lep
        ON lp.id = lep.project_id
    INNER JOIN linkedin_employees AS le
        ON lep.emp_id = le.id
)
SELECT
    title,
    budget,
    CEIL(SUM(prorated_cost_per_employee)) AS prorated_employee_expense
FROM prorated_cost_per_employee
GROUP BY
    1,2
HAVING
    SUM(prorated_cost_per_employee) > budget;
