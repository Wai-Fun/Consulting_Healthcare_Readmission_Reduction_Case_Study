


CREATE OR REPLACE TABLE
`healthcare-readmission-505214.staging.feat_icd10_indicators` AS

SELECT
    admission_id,

    MAX(CASE WHEN icd10_code = 'E10' THEN 1 ELSE 0 END) AS has_E10,
    MAX(CASE WHEN icd10_code = 'E11' THEN 1 ELSE 0 END) AS has_E11,
    MAX(CASE WHEN icd10_code = 'E87' THEN 1 ELSE 0 END) AS has_E87,

    MAX(CASE WHEN icd10_code = 'I21' THEN 1 ELSE 0 END) AS has_I21,
    MAX(CASE WHEN icd10_code = 'I48' THEN 1 ELSE 0 END) AS has_I48,
    MAX(CASE WHEN icd10_code = 'I10' THEN 1 ELSE 0 END) AS has_I10,
    MAX(CASE WHEN icd10_code = 'I50' THEN 1 ELSE 0 END) AS has_I50,

    MAX(CASE WHEN icd10_code = 'N18' THEN 1 ELSE 0 END) AS has_N18,

    MAX(CASE WHEN icd10_code = 'K57' THEN 1 ELSE 0 END) AS has_K57,

    MAX(CASE WHEN icd10_code = 'G40' THEN 1 ELSE 0 END) AS has_G40,
    MAX(CASE WHEN icd10_code = 'K80' THEN 1 ELSE 0 END) AS has_K80,
    MAX(CASE WHEN icd10_code = 'G35' THEN 1 ELSE 0 END) AS has_G35,

    MAX(CASE WHEN icd10_code = 'J18' THEN 1 ELSE 0 END) AS has_J18,
    MAX(CASE WHEN icd10_code = 'J44' THEN 1 ELSE 0 END) AS has_J44,

    MAX(CASE WHEN icd10_code = 'C18' THEN 1 ELSE 0 END) AS has_C18,

    MAX(CASE WHEN icd10_code = 'I63' THEN 1 ELSE 0 END) AS has_I63,

    MAX(CASE WHEN icd10_code = 'C34' THEN 1 ELSE 0 END) AS has_C34,

    MAX(CASE WHEN icd10_code = 'J96' THEN 1 ELSE 0 END) AS has_J96,

    MAX(CASE WHEN icd10_code = 'T14' THEN 1 ELSE 0 END) AS has_T14,

    MAX(CASE WHEN icd10_code = 'B54' THEN 1 ELSE 0 END) AS has_B54,

    MAX(CASE WHEN icd10_code = 'O34' THEN 1 ELSE 0 END) AS has_O34,
    MAX(CASE WHEN icd10_code = 'A91' THEN 1 ELSE 0 END) AS has_A91,
    MAX(CASE WHEN icd10_code = 'O80' THEN 1 ELSE 0 END) AS has_O80,

    MAX(CASE WHEN icd10_code = 'P07' THEN 1 ELSE 0 END) AS has_P07,

    MAX(CASE WHEN icd10_code = 'K70' THEN 1 ELSE 0 END) AS has_K70,

    MAX(CASE WHEN icd10_code = 'P22' THEN 1 ELSE 0 END) AS has_P22,

    MAX(CASE WHEN icd10_code = 'A09' THEN 1 ELSE 0 END) AS has_A09,
    MAX(CASE WHEN icd10_code = 'A15' THEN 1 ELSE 0 END) AS has_A15,
    MAX(CASE WHEN icd10_code = 'J45' THEN 1 ELSE 0 END) AS has_J45,

    MAX(CASE WHEN icd10_code = 'S06' THEN 1 ELSE 0 END) AS has_S06,

    MAX(CASE WHEN icd10_code = 'N39' THEN 1 ELSE 0 END) AS has_N39,
    MAX(CASE WHEN icd10_code = 'S72' THEN 1 ELSE 0 END) AS has_S72,

    MAX(CASE WHEN icd10_code = 'C50' THEN 1 ELSE 0 END) AS has_C50,

    MAX(CASE WHEN icd10_code = 'A41' THEN 1 ELSE 0 END) AS has_A41

FROM `healthcare-readmission-505214.staging.stag_diagnoses`

GROUP BY admission_id;

-- Validation - Total Rows and unique_admission both as 120000; 
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT admission_id) AS unique_admissions
FROM `healthcare-readmission-505214.staging.feat_icd10_indicators`;

-- Verify all indicators are binary
SELECT
    MIN(has_E10) AS min_E10,
    MAX(has_E10) AS max_E10,
    MIN(has_E11) AS min_E11,
    MAX(has_E11) AS max_E11,
    MIN(has_E87) AS min_E87,
    MAX(has_E87) AS max_E87,
    MIN(has_I21) AS min_I21,
    MAX(has_I21) AS max_I21
FROM `healthcare-readmission-505214.staging.feat_icd10_indicators`;