-- ============================================================
-- Business Objective 1: Overall Readmission Performance
-- Question 1-1: What is the overall 7-day and 30-day readmission rate?
-- ============================================================

SELECT
  COUNT(*) AS total_admissions,

  SUM(readmitted_7d) AS readmissions_7d,
  ROUND(
    SAFE_DIVIDE(SUM(readmitted_7d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_7d,

  SUM(readmitted_30d) AS readmissions_30d,
  ROUND(
    SAFE_DIVIDE(SUM(readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d,
  
FROM `healthcare-readmission-505214.staging.stag_admissions`;

