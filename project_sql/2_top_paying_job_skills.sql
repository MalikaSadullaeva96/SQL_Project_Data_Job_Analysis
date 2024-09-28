/*
What skills are required for top-paying data analyst job?
- Use the top 10 highest-paying Data Analyst job from firt query
- Add the specific skills required for these roles
*/

-- USE CTE

WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10
)

SELECT top_paying_jobs.*,
skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
     salary_year_avg DESC


/*
top 10 skills required for high-salary jobs based on the dataset:

	1.	SQL – 8 occurrences
	2.	Python – 7 occurrences
	3.	Tableau – 6 occurrences
	4.	R – 4 occurrences
	5.	Snowflake – 3 occurrences
	6.	Power BI – 3 occurrences
	7.	Java – 2 occurrences
	8.	AWS – 2 occurrences
	9.	Excel – 2 occurrences
	10.	Hadoop – 1 occurrence

*/