-- ============================================================
-- Feature Engineering: Diagnosis Burden
-- Purpose:
--   Aggregate multiple diagnosis records to the admission level.
--   Creates one row per admission with:
--     - Total number of diagnoses
--     - Number of secondary diagnoses
-- Grain:
--   One row per admission_id
-- ============================================================

CREATE OR REPLACE TABLE
`healthcare-readmission-505214.staging.feat_diagnosis_burden` AS

SELECT
  admission_id,
  COUNT(*) AS diagnosis_count,
  COUNTIF(diag_rank > 1) AS secondary_diagnosis_count
FROM `healthcare-readmission-505214.staging.stag_diagnoses`
GROUP BY admission_id;

-- Validate the created table
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT admission_id) AS unique_admissions,
  MIN(diagnosis_count) AS min_diagnoses,
  MAX(diagnosis_count) AS max_diagnoses,
  AVG(diagnosis_count) AS avg_diagnoses
FROM `healthcare-readmission-505214.staging.feat_diagnosis_burden`;