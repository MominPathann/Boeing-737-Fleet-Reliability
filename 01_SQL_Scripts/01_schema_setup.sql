/*
Project: Boeing 737 Fleet Reliability Analysis
Description: Database setup and schema definition.
Author: [Momin Khan]
*/

-- 1. Create the Database
CREATE DATABASE IF NOT EXISTS aviation_project;
USE aviation_project;

-- 2. Create the Table
-- Note: We use TEXT for numerical columns (Cycles/Hours) initially 
-- to prevent import errors caused by blank/empty strings in the raw CSV.
CREATE TABLE IF NOT EXISTS sdr_landing_gear (
    UniqueControlNumber VARCHAR(50) PRIMARY KEY,
    DifficultyDate TEXT, -- Imported as text to handle format inconsistencies
    OperatorDesignator VARCHAR(10),
    AircraftModel VARCHAR(50),
    AircraftSerialNumber VARCHAR(50),
    JASCCode VARCHAR(10), -- ATA Chapter
    PartName TEXT,
    PartCondition TEXT,
    Discrepancy LONGTEXT, -- Full mechanic logs
    AircraftTotalCycles TEXT, -- Contains blanks
    AircraftTotalTime TEXT,   -- Contains blanks
    StageOfOperationCode VARCHAR(10),
    IsDeferred VARCHAR(5) -- Calculated column for AOG status
);

-- 3. Verification
-- Check if table exists
SELECT * FROM sdr_landing_gear LIMIT 10;
