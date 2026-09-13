-- ============================================================
-- Feature Engineering: ICD-10 Diagnosis Category Indicators
-- Purpose:
--   Create binary indicators for the clinical diagnosis
--   categories present in each admission.
--
--   A value of 1 indicates that the category appears at least
--   once among the admission's primary or secondary diagnoses.
--
-- Features: (total of 11 categories)
--   - cardiovascular
--   - endocrine
--   - infectious
--   - respiratory
--   - gastrointestinal
--   - neoplasm
--   - neurological
--   - injury
--   - genitourinary
--   - obstetric
--   - perinatal
--
-- Grain:
--   One row per admission_id
-- ============================================================

CREATE OR REPLACE TABLE
`healthcare-readmission-505214.staging.feat_diagnosis_category` AS

SELECT
  admission_id,

  MAX(IF(diag_category = 'Cardiovascular', 1, 0)) AS has_cardiovascular,
  MAX(IF(diag_category = 'Endocrine', 1, 0)) AS has_endocrine,
  MAX(IF(diag_category = 'Infectious', 1, 0)) AS has_infectious,
  MAX(IF(diag_category = 'Respiratory', 1, 0)) AS has_respiratory,
  MAX(IF(diag_category = 'Gastrointestinal', 1, 0)) AS has_gastrointestinal,
  MAX(IF(diag_category = 'Neoplasm', 1, 0)) AS has_neoplasm,
  MAX(IF(diag_category = 'Neurological', 1, 0)) AS has_neurological,
  MAX(IF(diag_category = 'Injury', 1, 0)) AS has_injury,
  MAX(IF(diag_category = 'Genitourinary', 1, 0)) AS has_genitourinary,
  MAX(IF(diag_category = 'Obstetric', 1, 0)) AS has_obstetric,
  MAX(IF(diag_category = 'Perinatal', 1, 0)) AS has_perinatal

FROM `healthcare-readmission-505214.staging.stag_diagnoses`

GROUP BY admission_id; 

-- Validate 1 -- make sure there are a total of 120000 rows. 
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT admission_id) AS unique_admissions
FROM `healthcare-readmission-505214.staging.feat_diagnosis_category`;

-- Validate (every min=0; max =1) 
SELECT
  MIN(has_cardiovascular) AS min_cardiovascular,
  MAX(has_cardiovascular) AS max_cardiovascular,

  MIN(has_endocrine) AS min_endocrine,
  MAX(has_endocrine) AS max_endocrine,

  MIN(has_infectious) AS min_infectious,
  MAX(has_infectious) AS max_infectious,

  MIN(has_respiratory) AS min_respiratory,
  MAX(has_respiratory) AS max_respiratory,

  MIN(has_gastrointestinal) AS min_gastrointestinal,
  MAX(has_gastrointestinal) AS max_gastrointestinal,

  MIN(has_neoplasm) AS min_neoplasm,
  MAX(has_neoplasm) AS max_neoplasm,

  MIN(has_neurological) AS min_neurological,
  MAX(has_neurological) AS max_neurological,

  MIN(has_injury) AS min_injury,
  MAX(has_injury) AS max_injury,

  MIN(has_genitourinary) AS min_genitourinary,
  MAX(has_genitourinary) AS max_genitourinary,

  MIN(has_obstetric) AS min_obstetric,
  MAX(has_obstetric) AS max_obstetric,

  MIN(has_perinatal) AS min_perinatal,
  MAX(has_perinatal) AS max_perinatal

FROM `healthcare-readmission-505214.staging.feat_diagnosis_category`; 