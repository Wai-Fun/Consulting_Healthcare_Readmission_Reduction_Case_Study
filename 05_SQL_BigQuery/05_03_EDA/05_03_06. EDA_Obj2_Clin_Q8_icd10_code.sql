- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Clinical
-- Question 8: Which diagnoses have the highest 30-day
--             readmission rates?
-- Purpose: Compare 30-day readmission performance across
--          specific ICD-10 diagnoses.
-- ============================================================

WITH unique_diagnoses AS (
  SELECT DISTINCT
    admission_id,
    diag_desc,
    icd10_code
  FROM `healthcare-readmission-505214.staging.stag_diagnoses`
)

SELECT
  d.icd10_code,
  d.diag_desc,

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
  d.icd10_code,
  d.diag_desc

ORDER BY
  readmission_rate_30d DESC;