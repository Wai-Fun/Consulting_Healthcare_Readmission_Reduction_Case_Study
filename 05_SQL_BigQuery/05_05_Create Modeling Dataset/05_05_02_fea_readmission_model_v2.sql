-- ============================================================
-- Model 4 — Individual ICD-10 Diagnosis Indicators
-- One row per admission
-- Primary + secondary diagnoses included
-- ============================================================


-- Join and create new table: feat_readmission_model_v2 -- contiaining 34 ICD10_code
CREATE OR REPLACE TABLE `healthcare-readmission-505214.staging.feat_readmission_model_v2` AS

SELECT
    m.*,
    
    i.has_E10,
    i.has_E11,
    i.has_E87,
    i.has_I21,
    i.has_I48,
    i.has_I10,
    i.has_I50,
    i.has_N18,
    i.has_K57,
    i.has_G40,
    i.has_K80,
    i.has_G35,
    i.has_J18,
    i.has_J44,
    i.has_C18,
    i.has_I63,
    i.has_C34,
    i.has_J96,
    i.has_T14,
    i.has_B54,
    i.has_O34,
    i.has_A91,
    i.has_O80,
    i.has_P07,
    i.has_K70,
    i.has_P22,
    i.has_A09,
    i.has_A15,
    i.has_J45,
    i.has_S06,
    i.has_N39,
    i.has_S72,
    i.has_C50,
    i.has_A41

FROM `healthcare-readmission-505214.staging.feat_readmission_model` AS m

LEFT JOIN `healthcare-readmission-505214.staging.feat_icd10_indicators` AS i
    USING (admission_id); 

    -- validate the new table V2
    SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT admission_id) AS unique_admissions
FROM `healthcare-readmission-505214.staging.feat_readmission_model_v2`; 

-- Check for missing value --shouldn't be any missing values 
SELECT
    COUNTIF(has_E10 IS NULL) AS missing_E10,
    COUNTIF(has_E11 IS NULL) AS missing_E11,
    COUNTIF(has_E87 IS NULL) AS missing_E87,
    COUNTIF(has_I21 IS NULL) AS missing_I21,
    COUNTIF(has_I48 IS NULL) AS missing_I48
FROM `healthcare-readmission-505214.staging.feat_readmission_model_v2`;