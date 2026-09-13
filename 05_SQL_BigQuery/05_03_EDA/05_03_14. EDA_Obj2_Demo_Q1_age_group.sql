-- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Demographic
-- Question 1: Which age groups have the highest readmission rates?
-- Purpose: Compare 30-day readmission performance across age groups.
--          Age groups are derived from patient age at admission.
-- ============================================================

SELECT
  CASE
    WHEN p.age BETWEEN 0 AND 17 THEN '0-17'
    WHEN p.age BETWEEN 18 AND 29 THEN '18-29'
    WHEN p.age BETWEEN 30 AND 39 THEN '30-39'
    WHEN p.age BETWEEN 40 AND 49 THEN '40-49'
    WHEN p.age BETWEEN 50 AND 59 THEN '50-59'
    WHEN p.age BETWEEN 60 AND 69 THEN '60-69'
    WHEN p.age BETWEEN 70 AND 79 THEN '70-79'
    WHEN p.age BETWEEN 80 AND 95 THEN '80+'
  END AS age_group,

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
  age_group

ORDER BY
  readmission_rate_30d DESC;