-- ============================================================
-- Business Objective 1: Readmission Performance
-- Question 4a: What is the 30-day readmission performance by ward type? Which ward types have the highest 30-day readmission rates?
-- Question 4b: Which admission types have the highest 30-day readmission rates?
-- Purpose: Compare overall 30-day readmission performance
--          across ward types based on admission volume and
--          readmission rates.
-- ============================================================

4a: What is the 30-day readmission performance by ward type?
SELECT
  ward_type,
  COUNT(*) AS total_admissions,
  SUM(readmitted_30d) AS readmissions_30d,
  ROUND(
    SAFE_DIVIDE(SUM(readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d
FROM `healthcare-readmission-505214.staging.stag_admissions`
GROUP BY ward_type
ORDER BY readmission_rate_30d DESC;

-- Question 4b: Which admission types have the highest 30-day readmission rates?
SELECT
  admit_type,
  COUNT(*) AS total_admissions,
  SUM(readmitted_30d) AS readmissions_30d,
  ROUND(
    SAFE_DIVIDE(SUM(readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d
FROM `healthcare-readmission-505214.staging.stag_admissions`
GROUP BY admit_type
ORDER BY readmission_rate_30d DESC;

