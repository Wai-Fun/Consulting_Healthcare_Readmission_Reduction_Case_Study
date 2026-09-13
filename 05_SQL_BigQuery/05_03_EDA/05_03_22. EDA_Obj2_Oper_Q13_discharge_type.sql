-- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Operational
-- Question 13: Does discharge disposition affect 30-day readmission?
-- Purpose: Compare 30-day readmission rates across different
--          discharge dispositions.
-- ============================================================

SELECT
  discharge_type,

  COUNT(*) AS total_admissions,

  SUM(readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions`

GROUP BY
  discharge_type

ORDER BY
  readmission_rate_30d DESC;