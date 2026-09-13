-- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Clinical
-- Question 10: Does the number of procedures affect 30-day
--              readmission?
-- Purpose: Assess the relationship between number of procedures
--          performed during an admission and 30-day readmission rates.
-- ============================================================

SELECT
  num_procedures,

  COUNT(*) AS total_admissions,

  SUM(readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions`

GROUP BY
  num_procedures

ORDER BY
  num_procedures;