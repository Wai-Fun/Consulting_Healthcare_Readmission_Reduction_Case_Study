-- ============================================================
-- Project: Healthcare Readmission Consulting Case Study
-- Query: Verify Raw Table Row Counts
-- Purpose: Confirm successful ingestion of raw datasets
-- Platform: Google BigQuery
-- ============================================================


SELECT
  'patients' AS table_name,
  COUNT(*) AS row_count
FROM `healthcare-readmission-505214.raw.patients`

UNION ALL

SELECT
  'admissions',
  COUNT(*)
FROM `healthcare-readmission-505214.raw.admissions`

UNION ALL

SELECT
  'diagnoses',
  COUNT(*)
FROM `healthcare-readmission-505214.raw.diagnoses`

UNION ALL

SELECT
  'billing',
  COUNT(*)
FROM `healthcare-readmission-505214.raw.billing`

UNION ALL

SELECT
  'hospitals',
  COUNT(*)
FROM `healthcare-readmission-505214.raw.hospitals`;