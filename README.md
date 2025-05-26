# 📊 Data Analyst Skills & Salary Case Study

## 🧠 Introduction

This project investigates the intersection of **skills, salary, and demand** for Data Analyst roles, using job posting data to answer key career development questions. By analyzing top-paying roles, high-value skills, and the most optimal skill combinations, this case study offers practical insights for anyone looking to grow or transition into data analytics.

---

## 📚 Background

For somoeone looking to shift carreers into the Data Analytics direction, it is important to know:
- What are the **top-paying** Data Analyst jobs?
- What are the **skills required** for these top-paying roles?
- What are the **most in-demand skills** for the data analyst role?
- What are the **top skills based on salary** for a Data Analyst?
- What are the **most optimal skills** (high demand and high paying) to learn?

This project leverages SQL queries across job market datasets to explore these questions.

Link to the SQL querries: [project_sql](/project_sql/)

---

## 🛠 Tools I Used

- **PostgreSQL**: Open-source relational database used to write and execute SQL queries for analysis.
- **Visual Studio Code**: Lightweight code editor used to write and manage SQL scripts efficiently.
- **Git & GitHub**: Version control tools used to manage project files and publish the work online.
- **Data Source**: Job postings data from [datanerd.tech](https://datanerd.tech/) by Luke Barousse, which aggregates real-world job listings for analytics.


---

## 📈 The Analysis

### 1. Top-Paying Jobs (`1_top_paying_jobs.sql`)
- Identified the top 10 highest-paying remote Data Analyst roles.  
- Focused on roles with known salary values.  
- Included company names and job titles to show where the highest-paid positions are.  
- Provided insight into top opportunities for remote analysts.

```sql
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
LIMIT 10;
```

---

### 2. Top-Paying Job Skills (`2_top_paying_job_skills.sql`)
- Selected the top 10 highest-paying remote Data Analyst roles.  
- Identified specific skills associated with each job.  
- Found that SQL, Python, and BI tools like Tableau/Power BI were common across top roles.  
- High-paying jobs increasingly include cloud and engineering skills like Azure, Databricks, and Snowflake.

```sql
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
    salary_year_avg DESC;
```

---

### 3. Top Demanded Skills (`3_top_demanded_skills.sql`)
- Analyzed remote Data Analyst job postings.  
- Ranked skills by frequency of appearance across job listings.  
- Found that SQL, Python, Excel, Tableau, and Power BI are the most in-demand.  
- These foundational tools are essential for most entry and mid-level roles.

```sql
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
```

---

### 4. Top Skills by Average Salary (`4_top_skills_salary.sql`)
- Ranked all skills based on the average salary they are associated with.  
- Found that engineering, machine learning, and DevOps skills (e.g., PySpark, GitLab, DataRobot) lead to higher salaries.  
- Traditional tools like Excel and PowerPoint were absent from the top list, showing a shift in what’s valued.

```sql
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
```

---

### 5. Optimal Skills: High Demand & High Pay (`5_optimal_skill.sql`)
- Combined demand (frequency in postings) and salary data.  
- Highlighted skills that are both in demand and high-paying, offering the best ROI for learning.  
- Skills like SQL, Python, Tableau, Git, and Databricks ranked highly, showing versatility and value.

```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_postings_fact.job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
), average_salary AS (
    SELECT
        skills_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS salary_average
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_postings_fact.job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    skills_demand.demand_count,
    average_salary.salary_average
FROM 
    skills_demand
INNER JOIN average_salary ON average_salary.skill_id = skills_demand.skill_id
WHERE
    demand_count > 10
ORDER BY
    average_salary.salary_average DESC,
    skills_demand.demand_count DESC
LIMIT 25;


--OR


SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS salary_average
FROM job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_postings_fact.job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    salary_average DESC,
    demand_count DESC
LIMIT 25;
```

---

## 🎓 What I Learned

- **Technical breadth matters**: Combining core analysis tools with engineering and cloud platforms boosts earning potential.
- **Remote-friendly roles value automation**: Skills in Python, PySpark, Airflow, etc., are preferred for scaling analytics.
- **Version control and DevOps familiarity**: Tools like GitLab, Bitbucket, and Jenkins are increasingly expected even for analysts.

---

## ✅ Conclusions

- Learning **SQL + Python + a BI tool** is still the strongest foundation for aspiring data analysts.
- To move into top-paying roles, you should also build skills in **cloud computing**, **big data**, and **ML tooling**.
- Use demand + salary metrics to prioritize what to learn next — aim for **skills that are both valuable and sought after** in remote markets.
