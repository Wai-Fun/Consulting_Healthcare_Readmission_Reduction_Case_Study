-- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Clinical
-- Question 9: Do chronic conditions increase 30-day readmission risk?
-- Purpose: Examine the distribution of Charlson Comorbidity Index
--          scores and their relationship with 30-day readmissions.
-- ============================================================

SELECT
  charlson_index,

  COUNT(*) AS total_admissions,

  SUM(readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions`

GROUP BY
  charlson_index

ORDER BY
  charlson_index;