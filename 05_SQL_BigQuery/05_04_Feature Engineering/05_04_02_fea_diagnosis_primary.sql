-- ============================================================
-- Feature Engineering: Primary Diagnosis
-- Purpose:
--   Extract the primary diagnosis for each admission by
--   retaining only records with diag_rank = 1.
--
-- Renamed fields:
--   icd10_code    → primary_icd10_code
--   diag_desc     → primary_diag_desc
--   diag_category → primary_diag_category
--
-- Grain:
--   One row per admission_id
-- ============================================================

CREATE OR REPLACE TABLE
`healthcare-readmission-505214.staging.feat_diagnosis_primary` AS

SELECT
  admission_id,
  icd10_code AS primary_icd10_code,
  diag_desc AS primary_diag_desc,
  diag_category AS primary_diag_category
FROM `healthcare-readmission-505214.staging.stag_diagnoses`
WHERE diag_rank = 1;


-- Validate the created table
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT admission_id) AS unique_admissions,
  COUNTIF(primary_icd10_code IS NULL) AS missing_primary_icd10,
  COUNTIF(primary_diag_category IS NULL) AS missing_primary_category
FROM `healthcare-readmission-505214.staging.feat_diagnosis_primary`;

-- Verify the category distribution
SELECT
  primary_diag_category,
  COUNT(*) AS admissions
FROM `healthcare-readmission-505214.staging.feat_diagnosis_primary`
GROUP BY primary_diag_category
ORDER BY admissions DESC;