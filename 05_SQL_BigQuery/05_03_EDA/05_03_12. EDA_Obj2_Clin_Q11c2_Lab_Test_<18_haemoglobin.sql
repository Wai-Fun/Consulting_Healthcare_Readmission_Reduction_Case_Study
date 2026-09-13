-- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Clinical
-- Question 11c-2: Is abnormal hemoglobin associated with 30-day
--                 readmission among pediatric patients?
-- Purpose: Compare 30-day readmission rates among patients
--          younger than 18 with low, normal, and high hemoglobin.
-- Note: Age-specific hemoglobin ranges are applied. Patients with
--       gender = 'Other' are excluded from the 12-18 age group.
--       Patients age 0 are grouped with the 0-<2 year reference range.
-- ============================================================

SELECT
  CASE
    -- Age 0-<2 years
    WHEN p.age < 2 AND a.haemoglobin < 10.5
      THEN 'Low'
    WHEN p.age < 2 AND a.haemoglobin > 13.5
      THEN 'High'
    WHEN p.age < 2
      THEN 'Normal'

    -- Age 2-<6 years
    WHEN p.age >= 2 AND p.age < 6
         AND a.haemoglobin < 11.5
      THEN 'Low'
    WHEN p.age >= 2 AND p.age < 6
         AND a.haemoglobin > 13.5
      THEN 'High'
    WHEN p.age >= 2 AND p.age < 6
      THEN 'Normal'

    -- Age 6-<12 years
    WHEN p.age >= 6 AND p.age < 12
         AND a.haemoglobin < 11.5
      THEN 'Low'
    WHEN p.age >= 6 AND p.age < 12
         AND a.haemoglobin > 15.5
      THEN 'High'
    WHEN p.age >= 6 AND p.age < 12
      THEN 'Normal'

    -- Female, age 12-<18
    WHEN p.age >= 12 AND p.age < 18
         AND p.gender = 'F'
         AND a.haemoglobin < 12.0
      THEN 'Low'
    WHEN p.age >= 12 AND p.age < 18
         AND p.gender = 'F'
         AND a.haemoglobin > 16.0
      THEN 'High'
    WHEN p.age >= 12 AND p.age < 18
         AND p.gender = 'F'
      THEN 'Normal'

    -- Male, age 12-<18
    WHEN p.age >= 12 AND p.age < 18
         AND p.gender = 'M'
         AND a.haemoglobin < 13.0
      THEN 'Low'
    WHEN p.age >= 12 AND p.age < 18
         AND p.gender = 'M'
         AND a.haemoglobin > 16.0
      THEN 'High'
    WHEN p.age >= 12 AND p.age < 18
         AND p.gender = 'M'
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

WHERE p.age < 18
  AND (
    p.age < 12
    OR p.gender IN ('F', 'M')
  )

GROUP BY
  haemoglobin_status

ORDER BY
  readmission_rate_30d DESC;