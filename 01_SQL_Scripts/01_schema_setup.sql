/*
=============================================================================
PROJECT: Boeing 737 Fleet Reliability Analysis (ATA 32)
AUTHOR: Momin Khan
DESCRIPTION: Enterprise-grade database setup utilizing Medallion Architecture
             (Bronze Staging -> Silver Conformed View).
=============================================================================
*/

-- 1. Initialize the Environment
CREATE DATABASE IF NOT EXISTS aviation_project;
USE aviation_project;

-- ==========================================================================
-- BRONZE LAYER: Raw Data Ingestion (Staging)
-- ==========================================================================
-- RULE: All columns are TEXT to prevent import failures from dirty CSV data.
-- No business logic or type-casting belongs here.

DROP TABLE IF EXISTS bronze_sdr_landing_gear;

CREATE TABLE bronze_sdr_landing_gear (
    UniqueControlNumber VARCHAR(50) PRIMARY KEY,
    DifficultyDate TEXT, 
    OperatorDesignator TEXT,
    AircraftModel TEXT,
    AircraftSerialNumber TEXT,
    JASCCode TEXT, 
    PartName TEXT,
    PartCondition TEXT,
    Discrepancy LONGTEXT, 
    AircraftTotalCycles TEXT, 
    AircraftTotalTime TEXT,   
    StageOfOperationCode TEXT
);

-- Note for README: Run your LOAD DATA INFILE or Import Wizard here 
-- to populate the bronze_sdr_landing_gear table.

-- ==========================================================================
-- SILVER LAYER: Data Cleansing & Type Casting (Production View)
-- ==========================================================================
-- RULE: Cast data types, standardize dates, and convert blank strings to NULL.
-- Do NOT mutate unknown flight hours to '0'.

DROP VIEW IF EXISTS silver_sdr_landing_gear;

CREATE VIEW silver_sdr_landing_gear AS
SELECT 
    -- 1. Standard Identifiers
    TRIM(UniqueControlNumber) AS UniqueControlNumber,
    TRIM(OperatorDesignator) AS OperatorDesignator,
    TRIM(AircraftModel) AS AircraftModel,
    TRIM(AircraftSerialNumber) AS AircraftSerialNumber,
    TRIM(JASCCode) AS ATA_Chapter,
    
    -- 2. Date Standardization
    -- Ensure your raw CSV date format matches this string (e.g., '%m/%d/%Y' or '%Y-%m-%d')
    STR_TO_DATE(TRIM(DifficultyDate), '%m/%d/%Y') AS DifficultyDate,
    
    -- 3. Component Details
    UPPER(TRIM(PartName)) AS PartName,
    UPPER(TRIM(PartCondition)) AS PartCondition,
    TRIM(Discrepancy) AS Discrepancy,
    UPPER(TRIM(StageOfOperationCode)) AS StageOfOperationCode,
    
    -- 4. Critical Fix: NULL Handling & Type Casting for Flight Metrics
    -- If the string is empty, make it NULL. Otherwise, cast to an Unsigned Integer.
    CAST(NULLIF(TRIM(AircraftTotalCycles), '') AS UNSIGNED) AS AircraftTotalCycles,
    CAST(NULLIF(TRIM(AircraftTotalTime), '') AS UNSIGNED) AS AircraftTotalTime,
    
    -- 5. Business Logic: AOG Status (Derived Column)
    -- If 'MEL' or 'DEFER' is not in the mechanic's log, it is likely an AOG event.
    CASE 
        WHEN UPPER(Discrepancy) LIKE '%MEL%' OR UPPER(Discrepancy) LIKE '%DEFER%' THEN 'Yes'
        ELSE 'No'
    END AS IsDeferred

FROM bronze_sdr_landing_gear;

-- ==========================================================================
-- 3. Verification Query
-- ==========================================================================
-- Verify the clean data before connecting to Power BI.
SELECT * FROM silver_sdr_landing_gear LIMIT 10;
