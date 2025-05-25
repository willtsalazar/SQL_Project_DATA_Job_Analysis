/*
Question: What are the top-paying Data Analyst jobs?
-Identify the top 10 highest-paying Data Analyst roles that are available remotely.
-Focuses on job postings with specified salaries (remove nulls).
*/

SELECT
    job_id,
    company.name AS company_name,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact AS job_postings
LEFT JOIN company_dim AS company
ON company.company_id = job_postings.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
