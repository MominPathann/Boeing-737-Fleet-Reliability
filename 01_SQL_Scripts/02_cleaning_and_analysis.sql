/*
Project: Boeing 737 Fleet Reliability Analysis
Description: Data cleaning, type casting, and analytical queries.
*/

USE aviation_project;

-- Disable Safe Update mode to allow mass-cleaning of blank rows
SET SQL_SAFE_UPDATES = 0;

-- ==========================================
-- 1. DATA CLEANING
-- ==========================================

-- Handle blank values in Flight Hours to allow for calculations
-- Converting empty strings '' to '0'
UPDATE sdr_landing_gear
SET AircraftTotalTime = '0'
WHERE AircraftTotalTime = '';

UPDATE sdr_landing_gear
SET AircraftTotalCycles = '0'
WHERE AircraftTotalCycles = '';

-- Standardize Date Format (Converting Text to Date)
-- Note: Adjust format string '%m/%d/%Y' based on raw input
UPDATE sdr_landing_gear
SET DifficultyDate = STR_TO_DATE(DifficultyDate, '%m/%d/%Y');


-- ==========================================
-- 2. EXPLORATORY ANALYSIS
-- ==========================================

-- Insight 1: Top 10 Failing Components (Raw Count)
SELECT 
    PartName, 
    COUNT(*) as Failure_Count
FROM sdr_landing_gear
GROUP BY PartName
ORDER BY Failure_Count DESC
LIMIT 10;

-- Insight 2: The "Heat Map" (Failures by Month)
-- This highlights the seasonal spike in Summer months
SELECT 
    MONTHNAME(DifficultyDate) as Month, 
    COUNT(*) as Defects
FROM sdr_landing_gear
GROUP BY MONTHNAME(DifficultyDate), MONTH(DifficultyDate)
ORDER BY MONTH(DifficultyDate);

-- ==========================================
-- 3. ADVANCED ANALYSIS (Business Logic)
-- ==========================================

-- Insight 3: System Grouping (Normalizing Dirty Data)
-- Mapping raw part names to Engineering Sub-Systems
SELECT 
    CASE 
        WHEN PartName LIKE '%TIRE%' THEN 'TIRES'
        WHEN PartName LIKE '%BRAKE%' OR PartName LIKE '%WHEEL%' THEN 'BRAKES & WHEELS'
        WHEN PartName LIKE '%SENSOR%' OR PartName LIKE '%SWITCH%' THEN 'SENSORS & SWITCHES'
        WHEN PartName LIKE '%VALVE%' THEN 'VALVES'
        WHEN PartName LIKE '%ACTUATOR%' THEN 'ACTUATORS'
        ELSE 'OTHER'
    END as System_Group,
    COUNT(*) as Total_Defects
FROM sdr_landing_gear
GROUP BY System_Group
ORDER BY Total_Defects DESC;

-- Insight 4: AOG (Aircraft On Ground) Impact
-- Identifying defects that could not be deferred (Stopped Operations)
SELECT 
    COUNT(*) as AOG_Events,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sdr_landing_gear)) as Percentage_AOG
FROM sdr_landing_gear
WHERE Discrepancy NOT LIKE '%MEL%' 
  AND Discrepancy NOT LIKE '%DEFER%';
