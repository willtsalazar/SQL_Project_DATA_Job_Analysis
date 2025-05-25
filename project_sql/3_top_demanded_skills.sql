/*
QUESTION: WHat are the most in-demand skills for data analysts?
-Join job postings to inner join table similar to query 2
-Identify the top 5 in-demand skills for a data analyst
-Focus on remote job postings
-Why? Retrieves the top 5 skills withthe highest demand in the job market, providing insights into the most valuable skills for job seekers.
*/

WITH remote_job_skills as (
    SELECT
        skill_id,
        count(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home = TRUE AND
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;

--OR

SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY
    skills_dim.skills
ORDER BY
    demand_count DESC
LIMIT 5;