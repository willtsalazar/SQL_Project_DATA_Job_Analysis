/*
QUESTION: What are the top skills based on salary?
-Look at the average salary associated with each skill for Data Analyst positions
-Focus on roles with specified salaries, regardless of location
-Why? It reveals how diffrent skills impact salary levels for Data Analysts and 
helps identify the most financially rewarding skills to acquire or improve
*/

SELECT
    skills_dim.skills,
    ROUND(AVG(salary_year_avg), 0) AS salary_average
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
ORDER BY
    salary_average DESC
LIMIT 25;

/*
-Data analysts with engineering and big data skills (e.g., PySpark, Databricks, Kubernetes)
earn the highest salaries, reflecting the demand for hybrid analyst-engineer roles.

-Machine learning and advanced analytics tools (e.g., DataRobot, Scikit-learn, Jupyter)
 significantly boost earning potential by enabling predictive and automated insights.
-Familiarity with programming, DevOps, and cloud tools (e.g., GitLab, Bitbucket, GCP) 
is increasingly valuable, signaling a shift toward technical fluency in top-paying analytics roles.
*/