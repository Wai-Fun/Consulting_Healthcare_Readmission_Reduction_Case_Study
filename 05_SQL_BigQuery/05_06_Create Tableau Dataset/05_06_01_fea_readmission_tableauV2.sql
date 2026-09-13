-- ============================================================
-- Create Tableau Dataset V2
-- Adds 34 individual ICD-10 indicators
-- Grain: 1 row per admission
-- Base table: fea_readmission_tableauV1
-- ============================================================

CREATE OR REPLACE TABLE
  `healthcare-readmission-505214.staging.fea_readmission_tableauV2` AS

SELECT
    v1.*,

    -- ========================================================
    -- 34 ICD-10 indicators
    -- ========================================================
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

FROM
  `healthcare-readmission-505214.staging.fea_readmission_tableauV1` AS v1

LEFT JOIN
  `healthcare-readmission-505214.staging.feat_icd10_indicators` AS i
    USING (admission_id);


-- ============================================================
-- Validation 1: Row count and admission uniqueness
-- Expected:
--   total_rows = 120000
--   unique_admissions = 120000
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT admission_id) AS unique_admissions
FROM
  `healthcare-readmission-505214.staging.fea_readmission_tableauV2`;


-- ============================================================
-- Validation 2: Check for duplicate admission_id
-- Expected output: 0 rows
-- ============================================================

SELECT
    admission_id,
    COUNT(*) AS row_count
FROM
  `healthcare-readmission-505214.staging.fea_readmission_tableauV2`
GROUP BY
    admission_id
HAVING
    COUNT(*) > 1
ORDER BY
    row_count DESC;


-- ============================================================
-- Validation 3: Check ICD-10 indicators for missing values
-- Expected: 0 missing values for each indicator
-- ============================================================

SELECT
    COUNTIF(has_E10 IS NULL) AS missing_E10,
    COUNTIF(has_E11 IS NULL) AS missing_E11,
    COUNTIF(has_E87 IS NULL) AS missing_E87,
    COUNTIF(has_I21 IS NULL) AS missing_I21,
    COUNTIF(has_I48 IS NULL) AS missing_I48,
    COUNTIF(has_I10 IS NULL) AS missing_I10,
    COUNTIF(has_I50 IS NULL) AS missing_I50,
    COUNTIF(has_N18 IS NULL) AS missing_N18,
    COUNTIF(has_K57 IS NULL) AS missing_K57,
    COUNTIF(has_G40 IS NULL) AS missing_G40,
    COUNTIF(has_K80 IS NULL) AS missing_K80,
    COUNTIF(has_G35 IS NULL) AS missing_G35,
    COUNTIF(has_J18 IS NULL) AS missing_J18,
    COUNTIF(has_J44 IS NULL) AS missing_J44,
    COUNTIF(has_C18 IS NULL) AS missing_C18,
    COUNTIF(has_I63 IS NULL) AS missing_I63,
    COUNTIF(has_C34 IS NULL) AS missing_C34,
    COUNTIF(has_J96 IS NULL) AS missing_J96,
    COUNTIF(has_T14 IS NULL) AS missing_T14,
    COUNTIF(has_B54 IS NULL) AS missing_B54,
    COUNTIF(has_O34 IS NULL) AS missing_O34,
    COUNTIF(has_A91 IS NULL) AS missing_A91,
    COUNTIF(has_O80 IS NULL) AS missing_O80,
    COUNTIF(has_P07 IS NULL) AS missing_P07,
    COUNTIF(has_K70 IS NULL) AS missing_K70,
    COUNTIF(has_P22 IS NULL) AS missing_P22,
    COUNTIF(has_A09 IS NULL) AS missing_A09,
    COUNTIF(has_A15 IS NULL) AS missing_A15,
    COUNTIF(has_J45 IS NULL) AS missing_J45,
    COUNTIF(has_S06 IS NULL) AS missing_S06,
    COUNTIF(has_N39 IS NULL) AS missing_N39,
    COUNTIF(has_S72 IS NULL) AS missing_S72,
    COUNTIF(has_C50 IS NULL) AS missing_C50,
    COUNTIF(has_A41 IS NULL) AS missing_A41

FROM
  `healthcare-readmission-505214.staging.fea_readmission_tableauV2`;