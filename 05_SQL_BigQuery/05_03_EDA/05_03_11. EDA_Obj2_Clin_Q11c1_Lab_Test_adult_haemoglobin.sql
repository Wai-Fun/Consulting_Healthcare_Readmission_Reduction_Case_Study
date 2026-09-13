-- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Clinical
-- Question 11c-1: Is abnormal hemoglobin associated with 30-day readmission?
-- Purpose: Compare 30-day readmission rates among ADULT patients (>=18 yo)
--          with low, normal, and high hemoglobin levels.
-- Note: Analysis is restricted to adults (age >= 18) and uses
--       sex-specific hemoglobin thresholds.
-- ============================================================

SELECT
  CASE
    WHEN p.gender = 'Female' AND a.haemoglobin < 12.1
      THEN 'Low'
    WHEN p.gender = 'Female' AND a.haemoglobin > 15.1
      THEN 'High'
    WHEN p.gender = 'Male' AND a.haemoglobin < 13.6
      THEN 'Low'
    WHEN p.gender = 'Male' AND a.haemoglobin > 17.7
      THEN 'High'
    ELSE 'Normal'
  END AS haemoglobin_status,

  COUNT(*) AS total_admissions,

  SUM(a.readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(a.readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions` AS a

JOIN `healthcare-readmission-505214.staging.stag_patients` AS p
  ON a.patient_id = p.patient_id

WHERE p.age >= 18

GROUP BY
  haemoglobin_status

ORDER BY
  readmission_rate_30d DESC; 

  -- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Clinical
-- Question 11c-1: Is abnormal hemoglobin associated with 30-day readmission?
-- Purpose: Compare 30-day readmission rates among ADULT patients (>=18 yo)
--          with low, normal, and high hemoglobin levels.
-- Note: Analysis is restricted to adults (age >= 18) with gender
--       recorded as F or M and uses sex-specific thresholds.
-- ============================================================

SELECT
  CASE
    WHEN p.gender = 'F' AND a.haemoglobin < 12.1
      THEN 'Low'
    WHEN p.gender = 'F' AND a.haemoglobin > 15.1
      THEN 'High'
    WHEN p.gender = 'F'
      THEN 'Normal'

    WHEN p.gender = 'M' AND a.haemoglobin < 13.6
      THEN 'Low'
    WHEN p.gender = 'M' AND a.haemoglobin > 17.7
      THEN 'High'
    WHEN p.gender = 'M'
      THEN 'Normal'
  END AS haemoglobin_status,

  COUNT(*) AS total_admissions,

  SUM(a.readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(a.readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions` AS a

JOIN `healthcare-readmission-505214.staging.stag_patients` AS p
  ON a.patient_id = p.patient_id

WHERE p.age >= 18
  AND p.gender IN ('F', 'M')

GROUP BY
  haemoglobin_status

ORDER BY
  readmission_rate_30d DESC;

  