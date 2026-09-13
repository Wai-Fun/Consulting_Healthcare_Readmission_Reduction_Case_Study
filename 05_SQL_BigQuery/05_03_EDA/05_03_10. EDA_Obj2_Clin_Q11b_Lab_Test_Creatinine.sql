-- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Clinical
-- Question 11b: Is elevated creatinine associated with 30-day readmission?
-- Purpose: Compare 30-day readmission rates between patients with
--          normal and elevated creatinine levels (>1.5 mg/dL).
-- ============================================================

SELECT
  CASE
    WHEN creatinine > 1.5 THEN 'Elevated (>1.5 mg/dL)'
    ELSE 'Not Elevated (<=1.5 mg/dL)'
  END AS creatinine_status,

  COUNT(*) AS total_admissions,

  SUM(readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions`

GROUP BY
  creatinine_status

ORDER BY
  readmission_rate_30d DESC;