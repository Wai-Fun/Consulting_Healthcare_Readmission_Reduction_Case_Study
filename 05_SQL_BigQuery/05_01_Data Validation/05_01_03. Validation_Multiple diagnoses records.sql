-- Data Validation: Examine multiple diagnoses per admission
-- Purpose: Determine whether multiple diagnosis records represent
--          different ICD-10 diagnoses or duplicate records.
-- ============================================================

SELECT
  admission_id,
  COUNT(*) AS diagnosis_count,
  COUNT(DISTINCT icd10_code) AS unique_icd10_codes
FROM `healthcare-readmission-505214.staging.stag_diagnoses`
GROUP BY
  admission_id
HAVING
  COUNT(*) > 1
ORDER BY
  diagnosis_count DESC; 

   --Note: Total of 49 admission_id has 4 disntinct icd10_code