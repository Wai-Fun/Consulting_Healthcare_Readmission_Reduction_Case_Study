--- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Clinical
-- Question 11d-2: Is abnormal systolic blood pressure associated
--                 with 30-day readmission among patients age >=13.
-- Purpose: Compare 30-day readmission rates across systolic
--          blood pressure categories among patients age >=13.
-- Note: Patients younger than 13 are excluded because pediatric
--       systolic BP classification requires age-, sex-, and
--       height-specific percentile information, which is not
--       available in the dataset.
-- ============================================================

SELECT
  CASE
    WHEN a.systolic_bp < 90
      THEN 'Low'
    WHEN a.systolic_bp < 120
      THEN 'Normal'
    WHEN a.systolic_bp < 130
      THEN 'Elevated'
    WHEN a.systolic_bp < 140
      THEN 'High - Stage 1'
    WHEN a.systolic_bp >= 140
      THEN 'High - Stage 2'
  END AS systolic_bp_category,

  COUNT(*) AS total_admissions,

  SUM(a.readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(a.readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions` AS a

JOIN `healthcare-readmission-505214.staging.stag_patients` AS p
  ON a.patient_id = p.patient_id

WHERE p.age >= 13

GROUP BY
  systolic_bp_category

ORDER BY
  readmission_rate_30d DESC;