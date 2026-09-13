-- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Operational
-- Question 12: Does length of stay affect 30-day readmission?
-- Purpose: Compare 30-day readmission rates by individual
--          length of stay (1-9 days) and extended stays (>9 days).
-- ============================================================

SELECT
  CASE
    WHEN los_days BETWEEN 1 AND 9
      THEN CAST(los_days AS STRING)
    WHEN los_days > 9
      THEN '>9'
  END AS los_category,

  COUNT(*) AS total_admissions,

  SUM(readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions`

GROUP BY
  los_category

ORDER BY
  CASE
    WHEN los_category = '>9' THEN 10
    ELSE CAST(los_category AS INT64)
  END;