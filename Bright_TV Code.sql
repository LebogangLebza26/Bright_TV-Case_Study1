-- Databricks notebook source
--Telling Databricks to use 'brightdata' caltalog and 'brightdata' schema
USE bright_tv.brightdata

--Running all tables
SELECT *
FROM user_profiles

SELECT *
FROM viewership

--Gender Checks
SELECT DISTINCT Gender
FROM user_profiles 


SELECT DISTINCT
 CASE
   WHEN Gender = 'None' THEN 'Unknown'--Replace None with Unknown
   WHEN Gender = ' ' THEN 'Unknown' --Replace blank with Unknown
   ELSE Gender 
  END AS Gender_Rechecks 
FROM user_profiles ; 

--Race Checks
SELECT DISTINCT Race 
FROM user_profiles

SELECT DISTINCT 
  CASE
   WHEN Race = 'None' THEN 'Unknown'
   WHEN Race = 'other' THEN 'Unknown'
   ELSE Race
   END AS Race_Rechecks 
FROM user_profiles ;--Telling Databricks to use 'brightdata' caltalog and 'brightdata' schema
USE bright_tv.brightdata

--Running all tables
SELECT *
FROM user_profiles

SELECT *
FROM viewership

--Gender Checks
SELECT DISTINCT Gender
FROM user_profiles 


SELECT DISTINCT
 CASE
   WHEN Gender = 'None' THEN 'Unknown'--Replace None with Unknown
   WHEN Gender = ' ' THEN 'Unknown' --Replace blank with Unknown
   ELSE Gender 
  END AS Gender_Rechecks 
FROM user_profiles ; 

--Race Checks
SELECT DISTINCT Race 
FROM user_profiles

SELECT DISTINCT 
  CASE
   WHEN Race = 'None' THEN 'Unknown'
   WHEN Race = 'other' THEN 'Unknown'
   ELSE Race
   END AS Race_Rechecks 
FROM user_profiles ;



