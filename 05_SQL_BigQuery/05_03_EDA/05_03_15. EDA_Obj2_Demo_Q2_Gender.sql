-- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Demographic
-- Question 2: Does gender influence 30-day readmission?
-- Purpose: Compare 30-day readmission performance across genders.
-- ============================================================

SELECT
  p.gender,

  COUNT(*) AS total_admissions,

  SUM(a.readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(a.readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions` AS a

LEFT JOIN `healthcare-readmission-505214.staging.stag_patients` AS p
  ON a.patient_id = p.patient_id

GROUP BY
  p.gender

ORDER BY
  readmission_rate_30d DESC;