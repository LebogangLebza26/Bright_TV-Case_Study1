-- Databricks notebook source
SELECT *
FROM bright_tv.brightdata.user_profiles;


-- This is to check what my data looks like.
SELECT *
FROM bright_tv.brightdata.user_profiles
LIMIT 5;
-------------------------------------------
-- Gender Checks
-------------------------------------------
SELECT DISTINCT gender
FROM bright_tv.brightdata.user_profiles;

SELECT DISTINCT
       CASE 
            WHEN gender = 'None' THEN 'unknown' -- Replaces the value None with unknown 
            WHEN gender = ' ' THEN 'unknown' -- Replaces the empty space with unknown 
            WHEN gender IS NULL THEN 'unknown' -- Replaces the null with unknown 
       ELSE gender -- if gender is male or female return it as it is 
       END AS sex -- new column name
FROM bright_tv.brightdata.user_profiles;
-------------------------------------------
-- Race Checks
-------------------------------------------
SELECT DISTINCT race
FROM bright_tv.brightdata.user_profiles;

SELECT COUNT(DISTINCT userid) AS subscribers,
        CASE 
            WHEN race = 'other' THEN 'unknown' -- Replace other with unknown 
            WHEN race = 'None' THEN 'unknown' -- Replaces None with unknown 
            WHEN race = ' ' THEN 'unknown' -- Replaces the empty space with unknown 
            WHEN race IS NULL THEN 'unknown'-- Replaces the null with unknown 
        ELSE race -- keep the race as it is
        END AS ethnicity -- new column name 
FROM bright_tv.brightdata.user_profiles
GROUP BY ethnicity;
-------------------------------------------
-- Province Checks
-------------------------------------------

SELECT DISTINCT province
FROM bright_tv.brightdata.user_profiles;

SELECT DISTINCT
        CASE 
            WHEN province = 'None' THEN 'unknown' -- Replaces None with unknown 
            WHEN province = ' ' THEN 'unknown' -- Replaces the empty space with unknown 
            WHEN province IS NULL THEN 'unknown'-- Replaces the null with unknown 
        ELSE province -- keep theprovince as it is
        END AS region -- new column name 
FROM bright_tv.brightdata.user_profiles;
--------------------------------------------
-- Age Checks
--------------------------------------------

SELECT MIN(Age) AS min_age, -- Check the youngest person
       MAX(Age) AS max_age, -- Find the oldest person
       AVG(Age) AS mean_age -- Find the average age between upper bound and lower bound
FROM bright_tv.brightdata.user_profiles;

-- Groupings
SELECT 
        CASE 
            WHEN Age = '0' THEN 'Infant'
            WHEN Age BETWEEN 1 AND 12 THEN 'Child'
            WHEN Age BETWEEN 13 AND 17 THEN 'Teenager'
            WHEN Age BETWEEN 18 AND 35 THEN 'Young Adult'
            WHEN Age BETWEEN 36 AND 50 THEN 'Adult'
            WHEN Age > 50 AND Age <= 60 THEN 'Elder' -- Another way of doing a BETWEEN statement using operations
            WHEN Age > 60 THEN 'Pensioner'
        END AS Age_group
FROM bright_tv.brightdata.user_profiles;
----------------------------------------------------------
-- Returning all the columns on the user profile dataset, putting everything under one SELECT statement AND Creating Temporary Table/ View
----------------------------------------------------------
CREATE OR REPLACE TEMPORARY VIEW processed_user_profiles AS(
SELECT 
    UserID,
    CASE 
           WHEN (`Email` IS NOT NULL) AND (`Email` <>' ') AND (`Email` NOT IN ('None', 'other')) THEN 1
            ELSE 0
    END AS email_flag,

    CASE 
            WHEN (`Social Media Handle` IS NOT NULL) AND (`Social Media Handle` <>' ') AND (`Social Media Handle` NOT IN ('None', 'other')) THEN 1
            ELSE 0
    END AS social_media_flag,
      
     CASE 
            WHEN gender = 'None' THEN 'unknown'  
            WHEN gender = ' ' THEN 'unknown'  
            WHEN gender IS NULL THEN 'unknown'  
       ELSE gender  
       END AS sex,

       CASE 
            WHEN race = 'other' THEN 'unknown' -- Replace other with unknown 
            WHEN race = 'None' THEN 'unknown' -- Replaces None with unknown 
            WHEN race = ' ' THEN 'unknown' -- Replaces the empty space with unknown 
            WHEN race IS NULL THEN 'unknown'-- Replaces the null with unknown 
        ELSE race -- keep the race as it is
        END AS ethnicity,
        
        CASE 
            WHEN province = 'None' THEN 'unknown'  
            WHEN province = ' ' THEN 'unknown'  
            WHEN province IS NULL THEN 'unknown'
        ELSE province 
        END AS region, 

        AGE,
        CASE 
            WHEN Age = '0' THEN '01.Infant: 0'
            WHEN Age BETWEEN 1 AND 12 THEN '02.Child: 1-12'
            WHEN Age BETWEEN 13 AND 17 THEN '03.Teenager: 13-17'
            WHEN Age BETWEEN 18 AND 35 THEN '04.Young Adult: 18-35'
            WHEN Age BETWEEN 36 AND 50 THEN '05.Adult: 36-50'
            WHEN Age > 50 AND Age <= 60 THEN '06.Elder: 50-60' 
            WHEN Age > 60 THEN '07.Pensioner: >60'
        END AS Age_group

FROM bright_tv.brightdata.user_profiles)
----------------------------------------------------------
CREATE OR REPLACE TEMPORARY VIEW processed_user_profiles AS(
SELECT 
    UserID,
    CASE 
           WHEN (`Email` IS NOT NULL) AND (`Email` <>' ') AND (`Email` NOT IN ('None', 'other')) THEN 1
            ELSE 0
    END AS email_flag,

    CASE 
            WHEN (`Social Media Handle` IS NOT NULL) AND (`Social Media Handle` <>' ') AND (`Social Media Handle` NOT IN ('None', 'other')) THEN 1
            ELSE 0
    END AS social_media_flag,
      
     CASE 
            WHEN gender = 'None' THEN 'unknown'  
            WHEN gender = ' ' THEN 'unknown'  
            WHEN gender IS NULL THEN 'unknown'  
       ELSE gender  
       END AS sex,

       CASE 
            WHEN race = 'other' THEN 'unknown' -- Replace other with unknown 
            WHEN race = 'None' THEN 'unknown' -- Replaces None with unknown 
            WHEN race = ' ' THEN 'unknown' -- Replaces the empty space with unknown 
            WHEN race IS NULL THEN 'unknown'-- Replaces the null with unknown 
        ELSE race -- keep the race as it is
        END AS ethnicity,
        
        CASE 
            WHEN province = 'None' THEN 'unknown'  
            WHEN province = ' ' THEN 'unknown'  
            WHEN province IS NULL THEN 'unknown'
        ELSE province 
        END AS region, 

        AGE,
        CASE 
            WHEN Age = '0' THEN '01.Infant: 0'
            WHEN Age BETWEEN 1 AND 12 THEN '02.Child: 1-12'
            WHEN Age BETWEEN 13 AND 17 THEN '03.Teenager: 13-17'
            WHEN Age BETWEEN 18 AND 35 THEN '04.Young Adult: 18-35'
            WHEN Age BETWEEN 36 AND 50 THEN '05.Adult: 36-50'
            WHEN Age > 50 AND Age <= 60 THEN '06.Elder: 50-60' 
            WHEN Age > 60 THEN '07.Pensioner: >60'
        END AS Age_group

FROM bright_tv.brightdata.user_profiles);

SELECT *
FROM processed_user_profiles;

-- Checking Active Subscribers
SELECT COUNT(*) AS cnt,
       COUNT(DISTINCT UserID) AS active_subscribers
FROM processed_user_profiles;

-- Checking for duplicates
SELECT COUNT(*) AS cnt,
       UserID
FROM processed_user_profiles
GROUP BY UserID
HAVING COUNT(*)>1; -- if there are any duplicates, it will return a count greater than 1, if not it will return no rows


-- I wanted to see the whole table before I start doing any analysis on it
SELECT *
FROM bright_tv.brightdata.user_profiles; 

-- checking for duplicates in my data
SELECT UserID,
 COUNT(*) AS duplicate_count
FROM bright_tv.brightdata.user_profiles
GROUP BY UserID
HAVING COUNT(*) > 1;

-- I am checking the size pf the data
SELECT COUNT(*) AS number_of_rows,
 COUNT(DISTINCT UserID) AS number_subs
FROM bright_tv.brightdata.user_profiles;

-- Are the any rows where useRID is NULL
SELECT COUNT(*) AS cnt
FROM bright_tv.brightdata.user_profiles
WHERE UserID IS NULL;

-- Distinct UseID
SELECT DISTINCT UserID
FROM bright_tv.brightdata.user_profiles;
---------------------------------------------------------
--Gender Checks
---------------------------------------------------------
SELECT DISTINCT gender
FROM bright_tv.brightdata.user_profiles;
-- SELECT COUNT(*)
-- FROM workspace.default.bright_tv_user_profiles
-- WHERE gender=' ';

SELECT
    COUNT(DISTINCT userid) AS gender,
    CASE
    WHEN gender =  ' ' THEN 'unclassified'
    WHEN gender = 'None' THEN 'unknown'
 ELSE gender
 END AS Gender
FROM bright_tv.brightdata.user_profiles
GROUP BY Gender;
---------------------------------------------------------
--Race Checks
---------------------------------------------------------
SELECT COUNT(*) AS num_rows
FROM bright_tv.brightdata.user_profiles
WHERE Race IS NULL;

SELECT DISTINCT Race
FROM bright_tv.brightdata.user_profiles

SELECT DISTINCT
    CASE
    WHEN Race='other' THEN 'unknown'
    WHEN Race=' ' THEN 'None'
    ELSE Race
END AS Race
FROM bright_tv.brightdata.user_profiles

---------------------------------------------------------
--Province Checks
---------------------------------------------------------
SELECT DISTINCT Province
FROM bright_tv.brightdata.user_profiles;

SELECT DISTINCT
    CASE
    WHEN Province=' ' THEN 'Uncategorized'
    WHEN Province='None' THEN 'Uncategorized'
    ELSE Province
    END AS Region
FROM bright_tv.brightdata.user_profiles;

---------------------------------------------------------
--Age
---------------------------------------------------------
SELECT MIN(Age) AS min_age, --- = 0
 MAX(Age) AS max_age -- = 114
FROM bright_tv.brightdata.user_profiles;

SELECT COUNT(*) AS cnt
FROM bright_tv.brightdata.user_profiles
WHERE age IS NULL;

WITH 
user_profiles AS (
SELECT UserID,
    CASE
            WHEN Province=' ' THEN 'Uncategorized'
            WHEN Province='None' THEN 'Uncategorized'
    ELSE Province
    END AS Region,
            age,
    CASE
            WHEN age = 0 THEN 'Infants'
            WHEN age BETWEEN 1 AND 12 THEN 'Kids'
            WHEN age BETWEEN 13 AND 19 THEN 'Teenager'
            WHEN age BETWEEN 20 AND 35 THEN 'Youth'
            WHEN age BETWEEN 36 AND 50 THEN 'Adult'
            WHEN age BETWEEN 51 AND 65 THEN 'Elder'
            WHEN age >65 THEN 'Pensioner'
    END AS age_groups,

    CASE
            WHEN (email IS NOT NULL )OR (email=' ') OR (email NOT IN ('None'))THEN 1
    ELSE 0
    END AS email_flag,

    CASE
            WHEN `Social Media Handle` IS NOT NULL OR `Social Media Handle`=' ' OR `Social Media Handle` NOT IN ('None')THEN 1
    ELSE 0
    END AS sm_flag,
    
    CASE
            WHEN Race='other' THEN 'None'
            WHEN Race=' ' THEN 'None'
    ELSE Race
    END AS Race,

    CASE
            WHEN gender =' ' THEN 'None'
    ELSE gender
    END AS Gender
FROM bright_tv.brightdata.user_profiles
),

viewership AS (
 SELECT
 COALESCE(UserID0,userid4) AS userid,
        TO_CHAR(RecordDate2, 'yyyyMM') AS month_id,
        TO_DATE(RecordDate2) AS watch_date, --TIME(RecordDate2) AS watch_time,
        TO_CHAR(RecordDate2, 'DD') AS day_of_week,
        DAYNAME(RecordDate2) AS day_name,

    CASE
            WHEN day_name IN ('Sat', 'Sun') THEN 'weekend'
    ELSE 'weekday'
    END AS day_classification,
            MONTHNAME(RecordDate2) AS month_name,
CASE
            WHEN Channel2 IN ('SawSee','Sawsee') THEN 'SawSee'
            WHEN Channel2 IN ('SuperSport Live Events','Live on SuperSport', 'Supersport Live Events', 'DStv Events 1') THEN 'Live Events'
    ELSE Channel2
    END AS Tv_channel,
            date_format(RecordDate2, 'HH:mm:ss') AS watch_time,

    CASE
            WHEN watch_time BETWEEN '00:00:00' AND '05:59:59' THEN '01. Midnight'
            WHEN watch_time BETWEEN '06:00:00' AND '11:59:59' THEN '02. Morning'
            WHEN watch_time BETWEEN '12:00:00' AND '16:59:59' THEN '03. Afternoon'
            WHEN watch_time BETWEEN '17:00:00' AND '23:59:59' THEN '04. Evening'
    END AS time_of_day,
            DATE_FORMAT(`Duration 2`, 'HH:mm:ss') AS duration,

    CASE
            WHEN duration BETWEEN '00:05:00' AND '00:30:00' THEN '01. Low Usage: <30 min'
            WHEN duration BETWEEN '00:30:01' AND '00:59:59' THEN '02. Med Usage: <60 min'
            WHEN duration > '00:59:59' THEN '03. High Usage: >60 min'
    ELSE '04. No Usage'
    END AS screen_time_bucket,
    HOUR(RecordDate2) AS hour_of_day
FROM bright_tv.brightdata.viewership
)

SELECT Coalesce(A.userid,B.userid) AS sub_id,
    month_id,
    watch_date,
    day_of_week,
    day_name,
    day_classification,
    month_name,
    Tv_channel,
    time_of_day,
    hour_of_day,
    screen_time_bucket,
 --user_flag,
    duration,
    Region,
    age_groups,
    email_flag,
    sm_flag,
    Race,
    Gender
FROM viewership AS A
LEFT JOIN user_profiles AS B
ON A.userid=B.userid;



SELECT *
FROM bright_tv.brightdata.user_profiles;


-- This is to check what my data looks like.
SELECT *
FROM bright_tv.brightdata.user_profiles
LIMIT 5;
-------------------------------------------
-- Gender Checks
-------------------------------------------
SELECT DISTINCT gender
FROM bright_tv.brightdata.user_profiles;

SELECT DISTINCT
       CASE 
            WHEN gender = 'None' THEN 'unknown' -- Replaces the value None with unknown 
            WHEN gender = ' ' THEN 'unknown' -- Replaces the empty space with unknown 
            WHEN gender IS NULL THEN 'unknown' -- Replaces the null with unknown 
       ELSE gender -- if gender is male or female return it as it is 
       END AS sex -- new column name
FROM bright_tv.brightdata.user_profiles;
-------------------------------------------
-- Race Checks
-------------------------------------------
SELECT DISTINCT race
FROM bright_tv.brightdata.user_profiles;

SELECT COUNT(DISTINCT userid) AS subscribers,
        CASE 
            WHEN race = 'other' THEN 'unknown' -- Replace other with unknown 
            WHEN race = 'None' THEN 'unknown' -- Replaces None with unknown 
            WHEN race = ' ' THEN 'unknown' -- Replaces the empty space with unknown 
            WHEN race IS NULL THEN 'unknown'-- Replaces the null with unknown 
        ELSE race -- keep the race as it is
        END AS ethnicity -- new column name 
FROM bright_tv.brightdata.user_profiles
GROUP BY ethnicity;
-------------------------------------------
-- Province Checks
-------------------------------------------

SELECT DISTINCT province
FROM bright_tv.brightdata.user_profiles;

SELECT DISTINCT
        CASE 
            WHEN province = 'None' THEN 'unknown' -- Replaces None with unknown 
            WHEN province = ' ' THEN 'unknown' -- Replaces the empty space with unknown 
            WHEN province IS NULL THEN 'unknown'-- Replaces the null with unknown 
        ELSE province -- keep theprovince as it is
        END AS region -- new column name 
FROM bright_tv.brightdata.user_profiles;
--------------------------------------------
-- Age Checks
--------------------------------------------

SELECT MIN(Age) AS min_age, -- Check the youngest person
       MAX(Age) AS max_age, -- Find the oldest person
       AVG(Age) AS mean_age -- Find the average age between upper bound and lower bound
FROM bright_tv.brightdata.user_profiles;

-- Groupings
SELECT 
        CASE 
            WHEN Age = '0' THEN 'Infant'
            WHEN Age BETWEEN 1 AND 12 THEN 'Child'
            WHEN Age BETWEEN 13 AND 17 THEN 'Teenager'
            WHEN Age BETWEEN 18 AND 35 THEN 'Young Adult'
            WHEN Age BETWEEN 36 AND 50 THEN 'Adult'
            WHEN Age > 50 AND Age <= 60 THEN 'Elder' -- Another way of doing a BETWEEN statement using operations
            WHEN Age > 60 THEN 'Pensioner'
        END AS Age_group
FROM bright_tv.brightdata.user_profiles;
----------------------------------------------------------
-- Returning all the columns on the user profile dataset, putting everything under one SELECT statement AND Creating Temporary Table/ View
----------------------------------------------------------
CREATE OR REPLACE TEMPORARY VIEW processed_user_profiles AS(
SELECT 
    UserID,
    CASE 
           WHEN (`Email` IS NOT NULL) AND (`Email` <>' ') AND (`Email` NOT IN ('None', 'other')) THEN 1
            ELSE 0
    END AS email_flag,

    CASE 
            WHEN (`Social Media Handle` IS NOT NULL) AND (`Social Media Handle` <>' ') AND (`Social Media Handle` NOT IN ('None', 'other')) THEN 1
            ELSE 0
    END AS social_media_flag,
      
     CASE 
            WHEN gender = 'None' THEN 'unknown'  
            WHEN gender = ' ' THEN 'unknown'  
            WHEN gender IS NULL THEN 'unknown'  
       ELSE gender  
       END AS sex,

       CASE 
            WHEN race = 'other' THEN 'unknown' -- Replace other with unknown 
            WHEN race = 'None' THEN 'unknown' -- Replaces None with unknown 
            WHEN race = ' ' THEN 'unknown' -- Replaces the empty space with unknown 
            WHEN race IS NULL THEN 'unknown'-- Replaces the null with unknown 
        ELSE race -- keep the race as it is
        END AS ethnicity,
        
        CASE 
            WHEN province = 'None' THEN 'unknown'  
            WHEN province = ' ' THEN 'unknown'  
            WHEN province IS NULL THEN 'unknown'
        ELSE province 
        END AS region, 

        AGE,
        CASE 
            WHEN Age = '0' THEN '01.Infant: 0'
            WHEN Age BETWEEN 1 AND 12 THEN '02.Child: 1-12'
            WHEN Age BETWEEN 13 AND 17 THEN '03.Teenager: 13-17'
            WHEN Age BETWEEN 18 AND 35 THEN '04.Young Adult: 18-35'
            WHEN Age BETWEEN 36 AND 50 THEN '05.Adult: 36-50'
            WHEN Age > 50 AND Age <= 60 THEN '06.Elder: 50-60' 
            WHEN Age > 60 THEN '07.Pensioner: >60'
        END AS Age_group

FROM bright_tv.brightdata.user_profiles)
----------------------------------------------------------
CREATE OR REPLACE TEMPORARY VIEW processed_user_profiles AS(
SELECT 
    UserID,
    CASE 
           WHEN (`Email` IS NOT NULL) AND (`Email` <>' ') AND (`Email` NOT IN ('None', 'other')) THEN 1
            ELSE 0
    END AS email_flag,

    CASE 
            WHEN (`Social Media Handle` IS NOT NULL) AND (`Social Media Handle` <>' ') AND (`Social Media Handle` NOT IN ('None', 'other')) THEN 1
            ELSE 0
    END AS social_media_flag,
      
     CASE 
            WHEN gender = 'None' THEN 'unknown'  
            WHEN gender = ' ' THEN 'unknown'  
            WHEN gender IS NULL THEN 'unknown'  
       ELSE gender  
       END AS sex,

       CASE 
            WHEN race = 'other' THEN 'unknown' -- Replace other with unknown 
            WHEN race = 'None' THEN 'unknown' -- Replaces None with unknown 
            WHEN race = ' ' THEN 'unknown' -- Replaces the empty space with unknown 
            WHEN race IS NULL THEN 'unknown'-- Replaces the null with unknown 
        ELSE race -- keep the race as it is
        END AS ethnicity,
        
        CASE 
            WHEN province = 'None' THEN 'unknown'  
            WHEN province = ' ' THEN 'unknown'  
            WHEN province IS NULL THEN 'unknown'
        ELSE province 
        END AS region, 

        AGE,
        CASE 
            WHEN Age = '0' THEN '01.Infant: 0'
            WHEN Age BETWEEN 1 AND 12 THEN '02.Child: 1-12'
            WHEN Age BETWEEN 13 AND 17 THEN '03.Teenager: 13-17'
            WHEN Age BETWEEN 18 AND 35 THEN '04.Young Adult: 18-35'
            WHEN Age BETWEEN 36 AND 50 THEN '05.Adult: 36-50'
            WHEN Age > 50 AND Age <= 60 THEN '06.Elder: 50-60' 
            WHEN Age > 60 THEN '07.Pensioner: >60'
        END AS Age_group

FROM bright_tv.brightdata.user_profiles);

SELECT *
FROM processed_user_profiles;

-- Checking Active Subscribers
SELECT COUNT(*) AS cnt,
       COUNT(DISTINCT UserID) AS active_subscribers
FROM processed_user_profiles;

-- Checking for duplicates
SELECT COUNT(*) AS cnt,
       UserID
FROM processed_user_profiles
GROUP BY UserID
HAVING COUNT(*)>1; -- if there are any duplicates, it will return a count greater than 1, if not it will return no rows


-- I wanted to see the whole table before I start doing any analysis on it
SELECT *
FROM bright_tv.brightdata.user_profiles; 

-- checking for duplicates in my data
SELECT UserID,
 COUNT(*) AS duplicate_count
FROM bright_tv.brightdata.user_profiles
GROUP BY UserID
HAVING COUNT(*) > 1;

-- I am checking the size pf the data
SELECT COUNT(*) AS number_of_rows,
 COUNT(DISTINCT UserID) AS number_subs
FROM bright_tv.brightdata.user_profiles;

-- Are the any rows where useRID is NULL
SELECT COUNT(*) AS cnt
FROM bright_tv.brightdata.user_profiles
WHERE UserID IS NULL;

-- Distinct UseID
SELECT DISTINCT UserID
FROM bright_tv.brightdata.user_profiles;
---------------------------------------------------------
--Gender Checks
---------------------------------------------------------
SELECT DISTINCT gender
FROM bright_tv.brightdata.user_profiles;
-- SELECT COUNT(*)
-- FROM workspace.default.bright_tv_user_profiles
-- WHERE gender=' ';

SELECT
    COUNT(DISTINCT userid) AS gender,
    CASE
    WHEN gender =  ' ' THEN 'unclassified'
    WHEN gender = 'None' THEN 'unknown'
 ELSE gender
 END AS Gender
FROM bright_tv.brightdata.user_profiles
GROUP BY Gender;
---------------------------------------------------------
--Race Checks
---------------------------------------------------------
SELECT COUNT(*) AS num_rows
FROM bright_tv.brightdata.user_profiles
WHERE Race IS NULL;

SELECT DISTINCT Race
FROM bright_tv.brightdata.user_profiles

SELECT DISTINCT
    CASE
    WHEN Race='other' THEN 'unknown'
    WHEN Race=' ' THEN 'None'
    ELSE Race
END AS Race
FROM bright_tv.brightdata.user_profiles

---------------------------------------------------------
--Province Checks
---------------------------------------------------------
SELECT DISTINCT Province
FROM bright_tv.brightdata.user_profiles;

SELECT DISTINCT
    CASE
    WHEN Province=' ' THEN 'Uncategorized'
    WHEN Province='None' THEN 'Uncategorized'
    ELSE Province
    END AS Region
FROM bright_tv.brightdata.user_profiles;

---------------------------------------------------------
--Age
---------------------------------------------------------
SELECT MIN(Age) AS min_age, --- = 0
 MAX(Age) AS max_age -- = 114
FROM bright_tv.brightdata.user_profiles;

SELECT COUNT(*) AS cnt
FROM bright_tv.brightdata.user_profiles
WHERE age IS NULL;

WITH 
user_profiles AS (
SELECT UserID,
    CASE
            WHEN Province=' ' THEN 'Uncategorized'
            WHEN Province='None' THEN 'Uncategorized'
    ELSE Province
    END AS Region,
            age,
    CASE
            WHEN age = 0 THEN 'Infants'
            WHEN age BETWEEN 1 AND 12 THEN 'Kids'
            WHEN age BETWEEN 13 AND 19 THEN 'Teenager'
            WHEN age BETWEEN 20 AND 35 THEN 'Youth'
            WHEN age BETWEEN 36 AND 50 THEN 'Adult'
            WHEN age BETWEEN 51 AND 65 THEN 'Elder'
            WHEN age >65 THEN 'Pensioner'
    END AS age_groups,

    CASE
            WHEN (email IS NOT NULL )OR (email=' ') OR (email NOT IN ('None'))THEN 1
    ELSE 0
    END AS email_flag,

    CASE
            WHEN `Social Media Handle` IS NOT NULL OR `Social Media Handle`=' ' OR `Social Media Handle` NOT IN ('None')THEN 1
    ELSE 0
    END AS sm_flag,
    
    CASE
            WHEN Race='other' THEN 'None'
            WHEN Race=' ' THEN 'None'
    ELSE Race
    END AS Race,

    CASE
            WHEN gender =' ' THEN 'None'
    ELSE gender
    END AS Gender
FROM bright_tv.brightdata.user_profiles
),

viewership AS (
 SELECT
 COALESCE(UserID0,userid4) AS userid,
        TO_CHAR(RecordDate2, 'yyyyMM') AS month_id,
        TO_DATE(RecordDate2) AS watch_date, --TIME(RecordDate2) AS watch_time,
        TO_CHAR(RecordDate2, 'DD') AS day_of_week,
        DAYNAME(RecordDate2) AS day_name,

    CASE
            WHEN day_name IN ('Sat', 'Sun') THEN 'weekend'
    ELSE 'weekday'
    END AS day_classification,
            MONTHNAME(RecordDate2) AS month_name,
CASE
            WHEN Channel2 IN ('SawSee','Sawsee') THEN 'SawSee'
            WHEN Channel2 IN ('SuperSport Live Events','Live on SuperSport', 'Supersport Live Events', 'DStv Events 1') THEN 'Live Events'
    ELSE Channel2
    END AS Tv_channel,
            date_format(RecordDate2, 'HH:mm:ss') AS watch_time,

    CASE
            WHEN watch_time BETWEEN '00:00:00' AND '05:59:59' THEN '01. Midnight'
            WHEN watch_time BETWEEN '06:00:00' AND '11:59:59' THEN '02. Morning'
            WHEN watch_time BETWEEN '12:00:00' AND '16:59:59' THEN '03. Afternoon'
            WHEN watch_time BETWEEN '17:00:00' AND '23:59:59' THEN '04. Evening'
    END AS time_of_day,
            DATE_FORMAT(`Duration 2`, 'HH:mm:ss') AS duration,

    CASE
            WHEN duration BETWEEN '00:05:00' AND '00:30:00' THEN '01. Low Usage: <30 min'
            WHEN duration BETWEEN '00:30:01' AND '00:59:59' THEN '02. Med Usage: <60 min'
            WHEN duration > '00:59:59' THEN '03. High Usage: >60 min'
    ELSE '04. No Usage'
    END AS screen_time_bucket,
    HOUR(RecordDate2) AS hour_of_day
FROM bright_tv.brightdata.viewership
)

SELECT Coalesce(A.userid,B.userid) AS sub_id,
    month_id,
    watch_date,
    day_of_week,
    day_name,
    day_classification,
    month_name,
    Tv_channel,
    time_of_day,
    hour_of_day,
    screen_time_bucket,
 --user_flag,
    duration,
    Region,
    age_groups,
    email_flag,
    sm_flag,
    Race,
    Gender
FROM viewership AS A
LEFT JOIN user_profiles AS B
ON A.userid=B.userid;



