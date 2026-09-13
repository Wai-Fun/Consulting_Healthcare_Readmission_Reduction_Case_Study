-- ============================================================
-- Project: Healthcare Readmission Consulting Case Study
-- Query: ETL and Staging Table Creation
-- Purpose: Transform and validate raw datasets and create
--          standardized staging tables for downstream analysis
-- Platform: Google BigQuery
-- ============================================================

CREATE SCHEMA IF NOT EXISTS `healthcare-readmission-505214.staging`;

-- Create staging tables (without any transformation) 
-- 01_stag_patients 
CREATE OR REPLACE TABLE `healthcare-readmission-505214.staging.stag_patients` AS 
SELECT *
FROM `healthcare-readmission-505214.raw.patients`; 

-- 02. Stag_diagnoses
CREATE OR REPLACE TABLE `healthcare-readmission-505214.staging.stag_diagnoses` AS
SELECT *
FROM `healthcare-readmission-505214.raw.diagnoses`;

-- 03. stag_billing
CREATE OR REPLACE TABLE `healthcare-readmission-505214.staging.stag_billing` AS
SELECT *
FROM `healthcare-readmission-505214.raw.billing`;

-- 04. stag_hospitals: Create staging table with a derived hospital_name
-- Purpose: Create a unique, human-readable hospital label by combining
--          the original hospital name with the number of beds.
--          This addresses cases where multiple hospital IDs share the same name.
CREATE OR REPLACE TABLE `healthcare-readmission-505214.staging.stag_hospitals` AS
SELECT
  *,
  CONCAT(name, ' - ', CAST(beds AS STRING)) AS hospital_name
FROM `healthcare-readmission-505214.raw.hospitals`;

-- Verify the new column added: 
SELECT
  hospital_id,
  name,
  beds,
  hospital_name
FROM `healthcare-readmission-505214.staging.stag_hospitals`
ORDER BY name, beds; 

-- 05_admission: create staing table with transformed datatype string to date
--05-1: This admission staging table contained all admission. 
CREATE OR REPLACE TABLE `healthcare-readmission-505214.staging.stag_admissions_AllAdmissions` AS
SELECT
    * EXCEPT(admit_date, discharge_date),

    SAFE_CAST(admit_date AS DATE) AS admit_date,
    SAFE_CAST(discharge_date AS DATE) AS discharge_date

FROM `healthcare-readmission-505214.raw.admissions`;

--05-2: This admission staging table contained only eligible discharge (where discharge_type != 'Expired'. 
-- 05-2: This table will be use for subsequence analysis 

-- 05b_admission_eligible: create staging table containing only eligible discharges
CREATE OR REPLACE TABLE `healthcare-readmission-505214.staging.stag_admissions` AS
SELECT *
FROM `healthcare-readmission-505214.staging.stag_admissions_AllAdmissions`
WHERE discharge_type != 'Expired';




-- Verify the stag_admission has nthe correct datatype for admit_date and discharge_date
SELECT
  column_name,
  data_type
FROM `healthcare-readmission-505214.staging.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'stag_admissions'
  AND column_name IN ('admit_date', 'discharge_date');

  -- Verify the date format:
  SELECT
  admit_date,
  discharge_date
FROM `healthcare-readmission-505214.staging.stag_admissions`
LIMIT 10;

-- Verify the discharge_date is always after the admit_date (in Bigquery)
SELECT
  COUNT(*) AS invalid_date_order
FROM `healthcare-readmission-505214.staging.stag_admissions`
WHERE discharge_date < admit_date; 

-- Veryfy all values in admit_date and disharge_date successfull transformed
SELECT
  COUNTIF(admit_date IS NULL) AS missing_admission_date,
  COUNTIF(discharge_date IS NULL) AS missing_discharge_date
FROM `healthcare-readmission-505214.staging.stag_admissions`;