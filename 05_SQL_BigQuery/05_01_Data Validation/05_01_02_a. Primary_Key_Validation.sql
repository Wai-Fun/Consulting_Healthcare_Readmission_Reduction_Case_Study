-- ============================================================
-- Project: Healthcare Readmission Consulting Case Study
-- Query: Verify Primary Key Uniquness
-- Purpose: database-level uniqueness
-- Platform: Google BigQuery
-- ============================================================


-- 01_Table: patients; Primary key: patient_id
SELECT
  'patients' AS table_name,
  COUNT(*) AS total_rows,
  COUNT(patient_id) AS non_null_primary_keys,
  COUNT(DISTINCT patient_id) AS unique_primary_keys
FROM `healthcare-readmission-505214.raw.patients`

UNION ALL

-- 02_Table: admissions; Primary key: admission_id
SELECT
  'admissions' AS table_name,
  COUNT(*) AS total_rows,
  COUNT(admission_id) AS non_null_primary_keys,
  COUNT(DISTINCT admission_id) AS unique_primary_keys
FROM `healthcare-readmission-505214.raw.admissions`

UNION ALL

-- 03_Table: diagnoses; Primary key: diag_id
SELECT
  'diagnoses' AS table_name,
  COUNT(*) AS total_rows,
  COUNT(diag_id) AS non_null_primary_keys,
  COUNT(DISTINCT diag_id) AS unique_primary_keys
FROM `healthcare-readmission-505214.raw.diagnoses`

UNION ALL

-- 04_Table: billing; Primary key: bill_id
SELECT
  'billing' AS table_name,
  COUNT(*) AS total_rows,
  COUNT(bill_id) AS non_null_primary_keys,
  COUNT(DISTINCT bill_id) AS unique_primary_keys
FROM `healthcare-readmission-505214.raw.billing`

UNION ALL

-- 05_Table: hospitals; Primary key: hospital_id
SELECT
  'hospitals' AS table_name,
  COUNT(*) AS total_rows,
  COUNT(hospital_id) AS non_null_primary_keys,
  COUNT(DISTINCT hospital_id) AS unique_primary_keys
FROM `healthcare-readmission-505214.raw.hospitals`;