-- ============================================================
-- Business Objective 1: Readmission Performance
-- Question 2: What's the 30-day readmission trend? 
-- Purpose: Measure monthly 30-day readmission counts and rates
--          based on admission date
-- ============================================================

SELECT
  DATE_TRUNC(admit_date, MONTH) AS admit_month,

  COUNT(*) AS total_admissions,

  SUM(readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions`

GROUP BY admit_month
ORDER BY admit_month;