-- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Demographic
-- Question 7: Does a history of previous admissions affect
--             30-day readmission?
-- Purpose: Assess the relationship between previous admission
--          history and 30-day readmission rates.
-- ============================================================

SELECT
  p.prev_admissions,

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
  p.prev_admissions

ORDER BY
  p.prev_admissions;