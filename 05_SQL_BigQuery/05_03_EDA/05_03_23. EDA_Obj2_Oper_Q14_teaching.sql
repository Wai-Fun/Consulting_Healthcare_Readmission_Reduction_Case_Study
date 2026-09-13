-- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Operational
-- Question 15: Does hospital teaching status affect 30-day readmission?
-- Purpose: Compare 30-day readmission rates between teaching
--          and non-teaching hospitals.
-- ============================================================

SELECT
  h.teaching,

  COUNT(*) AS total_admissions,

  SUM(a.readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(a.readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions` AS a

JOIN `healthcare-readmission-505214.staging.stag_hospitals` AS h
  ON a.hospital_id = h.hospital_id

GROUP BY
  h.teaching

ORDER BY
  readmission_rate_30d DESC;