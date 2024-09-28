/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

NOTE: If you are having issues with permissions. And you get error: 

'could not open file "[your file path]\job_postings_fact.csv" for reading: Permission denied.'

1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `sql_course` database
3. Right-click `sql_course` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
    1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy company_dim FROM '[Insert File Path]/company_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_dim FROM '[Insert File Path]/skills_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy job_postings_fact FROM '[Insert File Path]/job_postings_fact.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_job_dim FROM '[Insert File Path]/skills_job_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/

-- NOTE: This has been updated from the video to fix issues with encoding

COPY company_dim
FROM '/tmp/company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_dim
FROM '/tmp/skills_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_postings_fact
FROM '/tmp/job_postings_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_job_dim
FROM '/tmp/skills_job_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

SELECT *
FROM job_postings_fact
LIMIT 10;


SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
EXTRACT(MONTH FROM job_posted_date) AS date_month  
FROM    
    job_postings_fact
LIMIT 10;


SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month 
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY 
    month
ORDER BY
    job_posted_count DESC;

 SELECT *
 FROM job_postings_fact

SELECT 
    job_schedule_type,
    AVG(salary_year_avg) AS avg_yearly_salary,
    AVG(salary_hour_avg) AS avg_hourly_salary
FROM
    job_postings_fact
WHERE 
    (EXTRACT(YEAR FROM job_posted_date) = 2023
    AND EXTRACT(MONTH FROM job_posted_date) > 6)
    OR EXTRACT(YEAR FROM job_posted_date) > 2023
GROUP BY    
    job_schedule_type;


SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
    COUNT(job_id) AS job_posted_count
FROM
    job_postings_fact
WHERE
    EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') = 2023
GROUP BY
    month
ORDER BY
    month;

SELECT 
    *
FROM company_dim


SELECT
    job_postings_fact.*,
    company_dim.name AS company_name
FROM 
    job_postings_fact
LEFT JOIN 
    company_dim 
ON
    job_postings_fact.company_id = company_dim.company_id
WHERE
    job_health_insurance = TRUE 
    AND EXTRACT(YEAR FROM job_posted_date) = 2023
    AND EXTRACT(QUARTER FROM job_posted_date) = 2
ORDER BY 
    job_posted_date;



SELECT
    *
FROM 
    job_postings_fact
WHERE 
    EXTRACT(MONTH FROM job_posted_date) = 1
LIMIT 10;

-- January
CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- February
CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- March
CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT *
FROM march_jobs
LIMIT 50

SELECT 
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY 
    location_category;

SELECT
    *
FROM 
    job_postings_fact

SELECT 
    job_title_short,
    salary_year_avg,
    CASE
        WHEN salary_year_avg >= 100000 THEN 'High'
        WHEN salary_year_avg BETWEEN 10000 AND 99999 THEN 'Standard'
        WHEN salary_year_avg < 60000 THEN 'Low'
        ELSE 'Not Categorized'
    END AS salary_category
FROM 
    job_postings_fact
WHERE 
    job_title_short ILIKE '%data analyst%'
ORDER BY 
    salary_year_avg DESC;


SELECT 
    * 
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;

--CTE
WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)

SELECT * 
FROM company_dim

SELECT 
    name,
    company_id
FROM company_dim
WHERE company_id IN (
    SELECT
        company_id
    FROM 
        job_postings_fact
    WHERE
        job_no_degree_mention = TRUE
    ORDER BY company_id
)

WITH company_job_count AS(
    SELECT 
        company_id,
        COUNT(*)
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT *
FROM company_job_count

SELECT *
FROM skills_job_dim

SELECT *
FROM skills_dim

SELECT *
FROM (
    SELECT
        COUNT(skill_id) AS id,
         skill_id
        FROM skills_job_dim
        GROUP BY skill_id
) AS skill_count 
 LEFT JOIN skills_dim ON
  skill_count.skill_id = skills_dim.skill_id

SELECT 
    s.skills, 
    skill_count.id AS mention_count
FROM (
    SELECT 
        skill_id, 
        COUNT(skill_id) AS id
    FROM 
        skills_job_dim
    GROUP BY 
        skill_id
    ORDER BY 
        id DESC
) AS skill_count
JOIN 
    skills_dim s
ON 
    skill_count.skill_id = s.skill_id;

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs