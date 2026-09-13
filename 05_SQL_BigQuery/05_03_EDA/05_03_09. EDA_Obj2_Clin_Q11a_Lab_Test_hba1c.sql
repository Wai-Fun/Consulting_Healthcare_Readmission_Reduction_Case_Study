-- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Clinical
-- Question 11a: Is elevated HbA1c associated with 30-day readmission?
-- Purpose: Compare 30-day readmission rates between patients with
--          normal and elevated HbA1c levels (>7%).
-- ============================================================

SELECT
  CASE
    WHEN hba1c > 7 THEN 'Elevated (>7%)'
    ELSE 'Not Elevated (<=7%)'
  END AS hba1c_status,

  COUNT(*) AS total_admissions,

  SUM(readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions`

GROUP BY
  hba1c_status

ORDER BY
  readmission_rate_30d DESC;