/*
Question: What skills are required for the top-paying data analyst jobs?
-Use the top 10 highest-paying Data Analyst jobs from first query
-Add the specific skills required for these roles
-Why? It provides a detailed look at which high-paying jobs demand certain skills, 
helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        company.name AS company_name,
        job_title,
        salary_year_avg
    FROM
        job_postings_fact AS job_postings
    LEFT JOIN company_dim AS company ON company.company_id = job_postings.company_id
    WHERE
        job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills
FROM
    top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    salary_year_avg DESC

/*
-SQL + Python + a BI tool (like Tableau or Power BI) is the core skill set across most high-paying roles.
-Cloud and big data skills (like Snowflake, Azure, Databricks) are becoming more common in top-tier roles.
-Familiarity with project collaboration tools (Git, Jira, Confluence) can boost your profile.
-Having a mix of programming, analytics, and business reporting tools is ideal.
*/