SELECT COUNT(*) AS total_listings
FROM listings_clean;

-- totoal 3902 listings
select count(distinct job_title) as unique_jobs
from listings_clean;

-- total uniqye 1138 job title

-- Unique companies
select count(distinct(company_name)) as unique_companies
from listings_clean;

-- date range 
SELECT 
    MIN(listing_date) AS earliest_listing,
    MAX(listing_date) AS latest_listing
FROM listings_clean;

-- How many unique states, cities, and suburbs are represented?
SELECT 
    COUNT(DISTINCT state) AS unique_states,
    COUNT(DISTINCT city) AS unique_cities,
    COUNT(DISTINCT suburb) AS unique_suburbs
FROM listings_clean;

-- Geographic Analysis
-- jobs by state
select 
state,count(*) as job_count
from listings_clean
group by state
order by job_count desc;

--  Jobs by Work Type
select 
work_type,count(*) as job_count
from listings_clean
group by work_type
order by job_count desc;

-- jobs by classification
SELECT 
   job_classification,
    COUNT(*) AS job_count
FROM listings_clean
GROUP BY job_classification
ORDER BY job_count DESC;
-- jobs by sub classification
SELECT 
   job_sub_classification,
    COUNT(*) AS job_count
FROM listings_clean
GROUP BY job_sub_classification
ORDER BY job_count DESC;

-- Recruiter vs Direct Postings
SELECT 
    CASE 
        WHEN recruiter = 1 THEN 'Recruiter Posted'
        ELSE 'Direct Company Posting'
    END AS posting_type,
    COUNT(*) AS job_count
FROM listings_clean
GROUP BY recruiter
ORDER BY job_count DESC;

-- Right to Work Requirement
SELECT 
   is_right_to_work_required,
    COUNT(*) AS job_count
FROM listings_clean
GROUP BY is_right_to_work_required
ORDER BY job_count DESC;

-- Salary Availability
select 
case 
when salary_string is Null or salary_string='' Then 'No Salary Mentioned'
Else 'Salary Listed'
end as salary_status,
count(*) as job_counts
FROM listings_clean
GROUP BY salary_status
ORDER BY job_counts DESC;

-- Ad Template Distribution
select advertiser_name,
count(*) as job_counts
from listings_clean
group by advertiser_name
order by job_counts desc
limit 4;

-- Top 10 Cities
SELECT 
    city,
    COUNT(*) AS job_count
FROM listings_clean
WHERE city IS NOT NULL AND city != ''
GROUP BY city
ORDER BY job_count DESC
LIMIT 5;


-- Geographic + Employment
-- For each state, how many Full Time vs Contract jobs?
select state,work_type,count(*) as job_count
from listings_clean
group by state,work_type
order by job_count desc;

-- For each city, what is the dominant work type?
select city,work_type,count(*) as job_count
from listings_clean
group by city,work_type
order by job_count desc;

-- How does recruiter usage vary by state?
SELECT 
    state,
    SUM(CASE WHEN recruiter = 1 THEN 1 ELSE 0 END) AS recruiter_jobs,
    SUM(CASE WHEN recruiter = 0 THEN 1 ELSE 0 END) AS direct_jobs,
    COUNT(*) AS total_jobs
FROM listings_clean
GROUP BY state

--  State + Salary Transparency
SELECT 
    state,
    SUM(CASE WHEN salary_string IS NULL OR salary_string = '' THEN 1 ELSE 0 END) AS no_salary,
    SUM(CASE WHEN salary_string IS NOT NULL AND salary_string != '' THEN 1 ELSE 0 END) AS salary_listed,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN salary_string IS NOT NULL AND salary_string != '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS salary_pct
FROM listings_clean
GROUP BY state
ORDER BY total DESC;

-- Classification + Work Type
select job_classification,
SUM(CASE WHEN work_type = 'Full Time' THEN 1 ELSE 0 END) AS full_time,
    SUM(CASE WHEN work_type = 'Contract/Temp' THEN 1 ELSE 0 END) AS contract,
    SUM(CASE WHEN work_type = 'Casual/Vacation' THEN 1 ELSE 0 END) AS casual,
    SUM(CASE WHEN work_type = 'Part Time' THEN 1 ELSE 0 END) AS part_time,
    count(*) as job_counts
    from listings_clean 
    group by job_classification
    ORDER BY job_counts DESC;
    
    -- Classification + Recruiter
    SELECT 
    job_classification,
    SUM(CASE WHEN recruiter = 1 THEN 1 ELSE 0 END) AS recruiter_jobs,
    SUM(CASE WHEN recruiter = 0 THEN 1 ELSE 0 END) AS direct_jobs,
    ROUND(SUM(CASE WHEN recruiter = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS recruiter_pct,
    COUNT(*) AS total
FROM listings_clean
GROUP BY job_classification
ORDER BY total DESC;
 
 SELECT 
    job_classification,
    SUM(CASE WHEN salary_string IS NOT NULL AND salary_string != '' THEN 1 ELSE 0 END) AS salary_listed,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN salary_string IS NOT NULL AND salary_string != '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS salary_pct
FROM listings_clean
GROUP BY job_classification
ORDER BY total DESC;

-- Company Rating vs Job Volume
SELECT 
    advertiser_name,
    CAST(company_rating AS DECIMAL (3 , 1 )) AS rating,
    COUNT(*) AS job_counts
FROM
    listings_clean
WHERE
    company_rating <> 'NA'
        AND company_rating IS NOT NULL
        AND company_rating <> ''
GROUP BY advertiser_name , company_rating
ORDER BY job_counts DESC
LIMIT 15;

-- Data Scientist Roles by State
SELECT 
    state,
    COUNT(*) AS ds_jobs
FROM listings_clean
WHERE job_title LIKE '%Data Scientist%'
GROUP BY state
ORDER BY ds_jobs DESC;

-- Data Scientist Roles by Work Type
SELECT 
    work_type,
    COUNT(*) AS ds_jobs
FROM listings_clean
WHERE job_title LIKE '%Data Scientist%'
GROUP BY work_type
ORDER BY ds_jobs DESC;

SELECT 
    state,
    SUM(python) AS python_jobs,
    COUNT(*) AS total_jobs,
    ROUND(SUM(python) * 100.0 / COUNT(*), 2) AS python_pct
FROM listings_clean
GROUP BY state
ORDER BY python_jobs DESC;

-- sql demand
SELECT 
    state,
    SUM(sql_skill) AS sql_jobs,
    COUNT(*) AS total_jobs,
    ROUND(SUM(sql_skill) * 100.0 / COUNT(*), 2) AS sql_pct
FROM listings_clean
GROUP BY state
ORDER BY sql_jobs DESC;

-- 
SELECT 
    state,
    SUM(r) AS r_jobs,
    COUNT(*) AS total_jobs,
    ROUND(SUM(r) * 100.0 / COUNT(*), 2) AS r_pct
FROM listings_clean
GROUP BY state
ORDER BY r_jobs DESC;

-- overall skill demand
SELECT 'Python' AS skill, SUM(python) AS demand FROM listings_clean
UNION ALL SELECT 'SQL', SUM(sql_skill) FROM listings_clean
UNION ALL SELECT 'R', SUM(r) FROM listings_clean
UNION ALL SELECT 'Tableau', SUM(tableau) FROM listings_clean
UNION ALL SELECT 'Hadoop', SUM(hadoop) FROM listings_clean
UNION ALL SELECT 'Spark', SUM(spark) FROM listings_clean
UNION ALL SELECT 'Java', SUM(java) FROM listings_clean
UNION ALL SELECT 'SAS', SUM(sas) FROM listings_clean
UNION ALL SELECT 'Matlab', SUM(matlab) FROM listings_clean
UNION ALL SELECT 'Scala', SUM(scala) FROM listings_clean
UNION ALL SELECT 'Javascript', SUM(javascript) FROM listings_clean
UNION ALL SELECT 'C', SUM(c_lang) FROM listings_clean
UNION ALL SELECT 'SPSS', SUM(spss) FROM listings_clean
UNION ALL SELECT 'Stata', SUM(stata) FROM listings_clean
UNION ALL SELECT 'Minitab', SUM(minitab) FROM listings_clean
UNION ALL SELECT 'Ruby', SUM(ruby) FROM listings_clean
UNION ALL SELECT 'Julia', SUM(julia) FROM listings_clean
UNION ALL SELECT 'Knime', SUM(knime) FROM listings_clean
UNION ALL SELECT 'D3', SUM(d3) FROM listings_clean
UNION ALL SELECT 'Clojure', SUM(clojure) FROM listings_clean
UNION ALL SELECT 'Haskell', SUM(haskell) FROM listings_clean
UNION ALL SELECT 'Lisp', SUM(lisp) FROM listings_clean
UNION ALL SELECT 'Golang', SUM(golang) FROM listings_clean
UNION ALL SELECT 'F.', SUM(f_sharp) FROM listings_clean
UNION ALL SELECT 'Fortran', SUM(fortran) FROM listings_clean
ORDER BY demand DESC;

-- Top 10 Skills (Percentage)
SELECT 'Python' AS skill, SUM(python) AS demand,
    ROUND(SUM(python) * 100.0 / (SELECT COUNT(*) FROM listings_clean), 2) AS pct
FROM listings_clean
UNION ALL
SELECT 'SQL', SUM(sql_skill), ROUND(SUM(sql_skill) * 100.0 / (SELECT COUNT(*) FROM listings_clean), 2) FROM listings_clean
UNION ALL
SELECT 'R', SUM(r), ROUND(SUM(r) * 100.0 / (SELECT COUNT(*) FROM listings_clean), 2) FROM listings_clean
UNION ALL
SELECT 'Tableau', SUM(tableau), ROUND(SUM(tableau) * 100.0 / (SELECT COUNT(*) FROM listings_clean), 2) FROM listings_clean
UNION ALL
SELECT 'SAS', SUM(sas), ROUND(SUM(sas) * 100.0 / (SELECT COUNT(*) FROM listings_clean), 2) FROM listings_clean
UNION ALL
SELECT 'Matlab', SUM(matlab), ROUND(SUM(matlab) * 100.0 / (SELECT COUNT(*) FROM listings_clean), 2) FROM listings_clean
UNION ALL
SELECT 'Hadoop', SUM(hadoop), ROUND(SUM(hadoop) * 100.0 / (SELECT COUNT(*) FROM listings_clean), 2) FROM listings_clean
UNION ALL
SELECT 'Spark', SUM(spark), ROUND(SUM(spark) * 100.0 / (SELECT COUNT(*) FROM listings_clean), 2) FROM listings_clean
UNION ALL
SELECT 'Java', SUM(java), ROUND(SUM(java) * 100.0 / (SELECT COUNT(*) FROM listings_clean), 2) FROM listings_clean
UNION ALL
SELECT 'Scala', SUM(scala), ROUND(SUM(scala) * 100.0 / (SELECT COUNT(*) FROM listings_clean), 2) FROM listings_clean
ORDER BY demand DESC;

-- Python AND SQL
select count(*) as python_sql
from listings_clean
where python=1 and sql_skill=1;

-- python sql and r
SELECT COUNT(*) AS python_sql_r
FROM listings_clean
WHERE python = 1 AND sql_skill = 1 AND r = 1;

-- jobs which need no skills
select count(*) as job_counts
from listings_clean
where python=0 and sql_skill=0 and r=0
AND tableau = 0 AND hadoop = 0 AND spark = 0
  AND java = 0 AND sas = 0 AND matlab = 0 AND scala = 0;
  
  -- avegrae skils per job
  SELECT 
    ROUND(AVG(python + sql_skill + r + tableau + hadoop + spark + java + sas + matlab + scala), 2) AS avg_skills
FROM listings_clean;

SELECT 'Python' AS skill, SUM(python) AS demand FROM listings_clean WHERE job_title LIKE '%Data Scientist%'
UNION ALL SELECT 'SQL', SUM(sql_skill) FROM listings_clean WHERE job_title LIKE '%Data Scientist%'
UNION ALL SELECT 'R', SUM(r) FROM listings_clean WHERE job_title LIKE '%Data Scientist%'
UNION ALL SELECT 'Tableau', SUM(tableau) FROM listings_clean WHERE job_title LIKE '%Data Scientist%'
UNION ALL SELECT 'Hadoop', SUM(hadoop) FROM listings_clean WHERE job_title LIKE '%Data Scientist%'
UNION ALL SELECT 'Spark', SUM(spark) FROM listings_clean WHERE job_title LIKE '%Data Scientist%'
UNION ALL SELECT 'SAS', SUM(sas) FROM listings_clean WHERE job_title LIKE '%Data Scientist%'
UNION ALL SELECT 'Matlab', SUM(matlab) FROM listings_clean WHERE job_title LIKE '%Data Scientist%'
UNION ALL SELECT 'Scala', SUM(scala) FROM listings_clean WHERE job_title LIKE '%Data Scientist%'
ORDER BY demand DESC;

-- skils by classificatino
SELECT 
    job_classification,
    SUM(python) AS python,
    SUM(sql_skill) AS sql_skill,
    SUM(r) AS r,
    SUM(tableau) AS tableau,
    SUM(hadoop) AS hadoop,
    SUM(spark) AS spark,
    COUNT(*) AS total
FROM listings_clean
GROUP BY job_classification
ORDER BY total DESC
LIMIT 10;

SELECT 'Tableau' AS tool, SUM(tableau) AS demand FROM listings_clean
UNION ALL SELECT 'D3', SUM(d3) FROM listings_clean
ORDER BY demand DESC;

-- How many jobs were posted each month?
select month(listing_date) as month,count(*) as job_counts
from listings_clean
group by month
order by job_counts desc;

-- Jobs Posted by Year
select year(listing_date) as year,count(*) as job_counts
from listings_clean
group by year
order by job_counts desc;

--  Data Scientist Jobs by Year
SELECT year(listing_date) as year, COUNT(*) AS ds_jobs
FROM listings_clean
WHERE job_title LIKE '%Data Scientist%'
GROUP BY year
ORDER BY ds_jobs desc;

-- Jobs by Day of Week
SELECT 
    DAYNAME(listing_date) AS day_of_week,
    COUNT(*) AS job_count
FROM listings_clean
GROUP BY WEEKDAY(listing_date), DAYNAME(listing_date)
ORDER BY job_count desc;

-- sql demand over time
SELECT 
    YEAR(listing_date) AS year,
    COUNT(*) AS job_counts,
    SUM(sql_skill) AS sql_skill,
    ROUND(SUM(sql_skill) * 100 / COUNT(*), 2) AS sql_pct
FROM listings_clean
GROUP BY YEAR(listing_date)
ORDER BY year;

-- r demand over time

SELECT 
    YEAR(listing_date) AS year,
    COUNT(*) AS job_counts,
    SUM(r) AS r,
    ROUND(SUM(r) * 100 / COUNT(*), 2) AS sql_pct
FROM listings_clean
GROUP BY YEAR(listing_date)
ORDER BY year;