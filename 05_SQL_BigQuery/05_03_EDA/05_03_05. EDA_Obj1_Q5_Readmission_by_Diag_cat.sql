-- ============================================================
-- Business Objective 1: Readmission Performance, demographic
-- Question 5: Which diagnostic categories contribute the most
--             30-day readmissions?
-- Purpose: Compare 30-day readmission volume and rates across
--          diagnostic categories.
-- Note: Some admissions have multiple diagnosis records (up to 4).
--       Unique admission-diagnosis combinations are used to
--       prevent duplicate diagnosis records from inflating results.
-- ============================================================

WITH unique_diagnoses AS (
  SELECT DISTINCT
    admission_id,
    diag_category
  FROM `healthcare-readmission-505214.staging.stag_diagnoses`
)

SELECT
  d.diag_category,

  COUNT(*) AS total_admissions,

  SUM(a.readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(a.readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions` AS a

LEFT JOIN unique_diagnoses AS d
  ON a.admission_id = d.admission_id

GROUP BY
  d.diag_category

ORDER BY
  readmissions_30d DESC;