-- ============================================================
-- Create Final Admission-Level Modeling Dataset
-- Grain: 1 row per admission
-- Target: 30-day readmission
-- Excludes billing information to avoid potential temporal leakage
-- ============================================================

CREATE OR REPLACE TABLE
  `healthcare-readmission-505214.staging.feat_readmission_model` AS

SELECT
    -- ========================================================
    -- Admission identifiers
    -- ========================================================
    a.admission_id,
    a.patient_id,

    -- ========================================================
    -- Patient characteristics
    -- ========================================================
    p.age,
    p.gender,
    p.state AS patient_state,
    p.bpl_card,
    p.insurance_type,
    p.comorbidity_count,
    p.prev_admissions,

    -- ========================================================
    -- Admission characteristics
    -- ========================================================
    a.admit_date,
    a.discharge_date,
    a.los_days,
    a.admit_type,
    a.ward_type,
    a.hospital_id,
    a.discharge_type,
    a.num_procedures,
    a.charlson_index,

    -- ========================================================
    -- Clinical measurements
    -- ========================================================
    a.hba1c,
    a.creatinine,
    a.haemoglobin,
    a.systolic_bp,

    -- ========================================================
    -- Hospital characteristics
    -- ========================================================
    h.hospital_name,
    h.state AS hospital_state,
    h.tier,
    h.beds,
    h.teaching,

    -- ========================================================
    -- Diagnosis burden features
    -- ========================================================
    db.diagnosis_count,
    db.secondary_diagnosis_count,

    -- ========================================================
    -- Primary diagnosis features
    -- ========================================================
    dp.primary_icd10_code,
    dp.primary_diag_desc,
    dp.primary_diag_category,

    -- ========================================================
    -- ICD-10 category indicators
    -- ========================================================
    dc.has_cardiovascular,
    dc.has_endocrine,
    dc.has_infectious,
    dc.has_respiratory,
    dc.has_gastrointestinal,
    dc.has_neoplasm,
    dc.has_neurological,
    dc.has_injury,
    dc.has_genitourinary,
    dc.has_obstetric,
    dc.has_perinatal,

    -- ========================================================
    -- Targets
    -- ========================================================
    a.readmitted_30d,
    a.readmitted_7d

FROM
  `healthcare-readmission-505214.staging.stag_admissions` AS a

-- Patient information
LEFT JOIN
  `healthcare-readmission-505214.staging.stag_patients` AS p
    ON a.patient_id = p.patient_id

-- Hospital information
LEFT JOIN
  `healthcare-readmission-505214.staging.stag_hospitals` AS h
    ON a.hospital_id = h.hospital_id

-- Diagnosis burden
LEFT JOIN
  `healthcare-readmission-505214.staging.feat_diagnosis_burden` AS db
    ON a.admission_id = db.admission_id

-- Primary diagnosis
LEFT JOIN
  `healthcare-readmission-505214.staging.feat_diagnosis_primary` AS dp
    ON a.admission_id = dp.admission_id

-- ICD-10 category indicators
LEFT JOIN
  `healthcare-readmission-505214.staging.feat_diagnosis_category` AS dc
    ON a.admission_id = dc.admission_id;

    --Validation 1: Row count and admission uniqueness (Expected output for both = 120000)
    SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT admission_id) AS unique_admissions
FROM
  `healthcare-readmission-505214.staging.feat_readmission_model`; 

  -- Validation 2:  Check for duplicates in admission_id (expected output = 0)
  SELECT
    admission_id,
    COUNT(*) AS row_count
FROM
  `healthcare-readmission-505214.staging.feat_readmission_model`
GROUP BY
    admission_id
HAVING
    COUNT(*) > 1
ORDER BY
    row_count DESC;

    -- Validation 3: Check for missing values (Expected output: no missing values) 
SELECT
    COUNTIF(admission_id IS NULL) AS missing_admission_id,
    COUNTIF(patient_id IS NULL) AS missing_patient_id,
    COUNTIF(age IS NULL) AS missing_age,
    COUNTIF(hospital_id IS NULL) AS missing_hospital_id,
    COUNTIF(hba1c IS NULL) AS missing_hba1c,
    COUNTIF(creatinine IS NULL) AS missing_creatinine,
    COUNTIF(haemoglobin IS NULL) AS missing_haemoglobin,
    COUNTIF(systolic_bp IS NULL) AS missing_systolic_bp,
    COUNTIF(diagnosis_count IS NULL) AS missing_diagnosis_count,
    COUNTIF(primary_icd10_code IS NULL) AS missing_primary_icd10,
    COUNTIF(primary_diag_category IS NULL) AS missing_primary_category
FROM
  `healthcare-readmission-505214.staging.feat_readmission_model`;