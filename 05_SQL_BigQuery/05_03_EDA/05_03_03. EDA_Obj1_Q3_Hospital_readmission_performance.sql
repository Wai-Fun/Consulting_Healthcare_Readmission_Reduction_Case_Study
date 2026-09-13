-- ============================================================
-- Business Objective 1: Readmission Performance
-- Question 3a: What is the hospital readmission performance? Which hospital has the highest readmission rate (jan 2015 - Dec 2024)? 
-- Question 3b: Yearly 30-day readmission rates for each hospital based on admission date.
-- Purpose: Compare overall 30-day readmission performance
--          across hospitals.
-- ============================================================

Question 3a: What is the hospital readmission performance?
SELECT
  a.hospital_id,
  h.hospital_name,

  COUNT(*) AS total_admissions,

  SUM(a.readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(a.readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions` AS a

LEFT JOIN `healthcare-readmission-505214.staging.stag_hospitals` AS h
  ON a.hospital_id = h.hospital_id

GROUP BY
  a.hospital_id,
  h.hospital_name

ORDER BY
  readmission_rate_30d DESC;

-- Question 3b: Yearly 30-day readmission rates for each hospital based on admission date.
SELECT
  a.hospital_id,
  h.hospital_name,
  EXTRACT(YEAR FROM a.admit_date) AS admit_year,

  COUNT(*) AS total_admissions,

  SUM(a.readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(a.readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions` AS a

LEFT JOIN `healthcare-readmission-505214.staging.stag_hospitals` AS h
  ON a.hospital_id = h.hospital_id

GROUP BY
  a.hospital_id,
  h.hospital_name,
  admit_year

ORDER BY
  h.hospital_name,
  admit_year;
