-- ============================================================
-- Project: Healthcare Readmission Consulting Case Study
-- Query: Foreign Key Validation
-- Purpose: Referential Integrity Check
-- Platform: Google BigQuery
-- ============================================================

-- 01. Check if every admissions.patient_id exists in patients.patient_id
SELECT
  'admissions → patients' AS relationship,
  'patient_id' AS key_column,
  COUNT(*) AS orphan_count
FROM `healthcare-readmission-505214.raw.admissions` a
LEFT JOIN `healthcare-readmission-505214.raw.patients` p
  ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL

UNION ALL

-- 02. Check if every admissions.admission_id exists in diagnoses.admission_id
SELECT
  'admissions → diagnoses' AS relationship,
  'admission_id' AS key_column,
  COUNT(*) AS orphan_count
FROM `healthcare-readmission-505214.raw.admissions` a
LEFT JOIN `healthcare-readmission-505214.raw.diagnoses` d
  ON a.admission_id = d.admission_id
WHERE d.admission_id IS NULL

UNION ALL

-- 03. Check if every admissions.admission_id exists in billing.admission_id
SELECT
  'admissions → billing' AS relationship,
  'admission_id' AS key_column,
  COUNT(*) AS orphan_count
FROM `healthcare-readmission-505214.raw.admissions` a
LEFT JOIN `healthcare-readmission-505214.raw.billing` b
  ON a.admission_id = b.admission_id
WHERE b.admission_id IS NULL

UNION ALL

-- 04. Check if every hospitals.hospital_id exists in admissions.hospital_id
SELECT
  'hospitals → admissions' AS relationship,
  'hospital_id' AS key_column,
  COUNT(*) AS orphan_count
FROM `healthcare-readmission-505214.raw.hospitals` h
LEFT JOIN `healthcare-readmission-505214.raw.admissions` a
  ON h.hospital_id = a.hospital_id
WHERE a.hospital_id IS NULL;