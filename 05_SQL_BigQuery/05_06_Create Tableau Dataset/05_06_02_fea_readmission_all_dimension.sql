CREATE OR REPLACE TABLE
  `healthcare-readmission-505214.staging.fea_readmission_all_dimensions` AS

WITH base AS (

  SELECT
    admission_id,
    age,
    gender,
    patient_state,
    bpl_card,
    insurance_type,
    comorbidity_count,
    prev_admissions,
    admit_type,
    ward_type,
    hospital_id,
    hospital_name,
    hospital_state,
    tier,
    beds,
    teaching,
    discharge_type,
    los_days,
    num_procedures,
    charlson_index,
    hba1c,
    creatinine,
    haemoglobin,
    systolic_bp,
    secondary_diagnosis_count,
    primary_icd10_code,
    primary_diag_desc,
    readmitted_30d

  FROM
    `healthcare-readmission-505214.staging.fea_readmission_tableauV2`
),

dimension_groups AS (

  -- ============================================================
  -- Admit Type
  -- ============================================================
  SELECT
    'Admit Type' AS dimension,
    admit_type AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base

  UNION ALL

  -- ============================================================
  -- Age Group
  -- ============================================================
  SELECT
    'Age Group' AS dimension,
    CASE
      WHEN age < 18 THEN '<18'
      WHEN age < 30 THEN '18-29'
      WHEN age < 40 THEN '30-39'
      WHEN age < 50 THEN '40-49'
      WHEN age < 60 THEN '50-59'
      WHEN age < 70 THEN '60-69'
      WHEN age < 80 THEN '70-79'
      ELSE '80+'
    END AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base

  UNION ALL

  -- ============================================================
  -- BPL Card
  -- ============================================================
  SELECT
    'BPL Card' AS dimension,
    CAST(bpl_card AS STRING) AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base

  UNION ALL

  -- ============================================================
  -- Charlson Index Group
  -- ============================================================
  SELECT
    'Charlson' AS dimension,
    CASE
      WHEN charlson_index = 0 THEN '0'
      WHEN charlson_index <= 2 THEN '1-2'
      ELSE '3+'
    END AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base

  UNION ALL

  -- ============================================================
  -- Comorbidity Count Group
  -- ============================================================
  SELECT
    'Comorbidity' AS dimension,
    CASE
      WHEN comorbidity_count = 0 THEN '0'
      WHEN comorbidity_count <= 2 THEN '1-2'
      ELSE '3+'
    END AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base

  UNION ALL

  -- ============================================================
  -- Creatinine
  -- ============================================================
  SELECT
    'Creatinine' AS dimension,
    CASE
      WHEN creatinine <= 1.5 THEN 'Normal creatinine'
      WHEN creatinine > 1.5 THEN 'Elevated creatinine'
    END AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base
  WHERE creatinine IS NOT NULL

  UNION ALL

  -- ============================================================
  -- Diagnosis Type
  -- ============================================================
  SELECT
    'Diag Type' AS dimension,
    CASE
      WHEN secondary_diagnosis_count = 0
        THEN 'Primary'
      WHEN secondary_diagnosis_count > 0
        THEN 'Secondary'
    END AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base
  WHERE secondary_diagnosis_count IS NOT NULL

  UNION ALL

  -- ============================================================
  -- Discharge Type
  -- ============================================================
  SELECT
    'Discharge Type' AS dimension,
    discharge_type AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base

  UNION ALL

  -- ============================================================
  -- Gender
  -- ============================================================
  SELECT
    'Gender' AS dimension,
    gender AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base

  UNION ALL

  -- ============================================================
  -- Haemoglobin
  -- Pediatric: age <18
  -- Adult: age >=18
  -- Missing Hb excluded
  -- ============================================================
  SELECT
    'Haemoglobin' AS dimension,

    CASE

      -- --------------------------------------------------------
      -- Pediatric: Age 0-<2
      -- --------------------------------------------------------
      WHEN age < 2 AND haemoglobin < 10.5
        THEN 'Low'
      WHEN age < 2 AND haemoglobin > 13.5
        THEN 'High'
      WHEN age < 2
        THEN 'Normal'

      -- --------------------------------------------------------
      -- Pediatric: Age 2-<6
      -- --------------------------------------------------------
      WHEN age >= 2 AND age < 6
           AND haemoglobin < 11.5
        THEN 'Low'
      WHEN age >= 2 AND age < 6
           AND haemoglobin > 13.5
        THEN 'High'
      WHEN age >= 2 AND age < 6
        THEN 'Normal'

      -- --------------------------------------------------------
      -- Pediatric: Age 6-<12
      -- --------------------------------------------------------
      WHEN age >= 6 AND age < 12
           AND haemoglobin < 11.5
        THEN 'Low'
      WHEN age >= 6 AND age < 12
           AND haemoglobin > 15.5
        THEN 'High'
      WHEN age >= 6 AND age < 12
        THEN 'Normal'

      -- --------------------------------------------------------
      -- Pediatric Female: Age 12-<18
      -- --------------------------------------------------------
      WHEN age >= 12 AND age < 18
           AND gender = 'F'
           AND haemoglobin < 12.0
        THEN 'Low'
      WHEN age >= 12 AND age < 18
           AND gender = 'F'
           AND haemoglobin > 16.0
        THEN 'High'
      WHEN age >= 12 AND age < 18
           AND gender = 'F'
        THEN 'Normal'

      -- --------------------------------------------------------
      -- Pediatric Male: Age 12-<18
      -- --------------------------------------------------------
      WHEN age >= 12 AND age < 18
           AND gender = 'M'
           AND haemoglobin < 13.0
        THEN 'Low'
      WHEN age >= 12 AND age < 18
           AND gender = 'M'
           AND haemoglobin > 16.0
        THEN 'High'
      WHEN age >= 12 AND age < 18
           AND gender = 'M'
        THEN 'Normal'

      -- --------------------------------------------------------
      -- Adult Female: Age >=18
      -- --------------------------------------------------------
      WHEN age >= 18
           AND gender = 'F'
           AND haemoglobin < 12.1
        THEN 'Low'
      WHEN age >= 18
           AND gender = 'F'
           AND haemoglobin > 15.1
        THEN 'High'
      WHEN age >= 18
           AND gender = 'F'
        THEN 'Normal'

      -- --------------------------------------------------------
      -- Adult Male: Age >=18
      -- --------------------------------------------------------
      WHEN age >= 18
           AND gender = 'M'
           AND haemoglobin < 13.6
        THEN 'Low'
      WHEN age >= 18
           AND gender = 'M'
           AND haemoglobin > 17.7
        THEN 'High'
      WHEN age >= 18
           AND gender = 'M'
        THEN 'Normal'

    END AS group_name,

    admission_id,
    discharge_type,
    readmitted_30d

  FROM base

  WHERE haemoglobin IS NOT NULL
    AND gender IN ('F', 'M')

  UNION ALL

  -- ============================================================
  -- HbA1c
  -- ============================================================
  SELECT
    'HbA1c' AS dimension,
    CASE
      WHEN hba1c <= 7 THEN 'Normal HbA1c'
      WHEN hba1c > 7 THEN 'Elevated HbA1c'
    END AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base
  WHERE hba1c IS NOT NULL

  UNION ALL

  -- ============================================================
  -- Hospital Beds
  -- ============================================================
  SELECT
    'Hosp Beds' AS dimension,
    CAST(beds AS STRING) AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base
  WHERE beds IS NOT NULL

  UNION ALL

  -- ============================================================
  -- Hospital Name
  -- ============================================================
  SELECT
    'Hosp Name' AS dimension,
    hospital_name AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base
  WHERE hospital_name IS NOT NULL

  UNION ALL

  -- ============================================================
  -- Hospital State
  -- ============================================================
  SELECT
    'Hosp State' AS dimension,
    hospital_state AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base
  WHERE hospital_state IS NOT NULL

  UNION ALL

  -- ============================================================
  -- Hospital Tier
  -- ============================================================
  SELECT
    'Hosp Tier' AS dimension,
    CAST(tier AS STRING) AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base
  WHERE tier IS NOT NULL

  UNION ALL

  -- ============================================================
  -- Insurance Type
  -- ============================================================
  SELECT
    'Insurance' AS dimension,
    insurance_type AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base
  WHERE insurance_type IS NOT NULL

  UNION ALL

  -- ============================================================
  -- LOS Group
  -- ============================================================
  SELECT
    'LOS days' AS dimension,
    CASE
      WHEN los_days <= 2 THEN '1-2'
      WHEN los_days <= 5 THEN '3-5'
      WHEN los_days <= 10 THEN '6-10'
      WHEN los_days <= 20 THEN '11-20'
      ELSE '21+'
    END AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base
  WHERE los_days IS NOT NULL

  UNION ALL

  -- ============================================================
  -- Number of Procedures Group
  -- ============================================================
  SELECT
    'Num Procedures' AS dimension,
    CASE
      WHEN num_procedures = 0 THEN '0'
      WHEN num_procedures <= 3 THEN '1-3'
      ELSE '4+'
    END AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base

  UNION ALL

  -- ============================================================
  -- Patient State
  -- ============================================================
  SELECT
    'Pt State' AS dimension,
    patient_state AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base
  WHERE patient_state IS NOT NULL

  UNION ALL

  -- ============================================================
  -- Prev Admissions Group
  -- ============================================================
  SELECT
    'Prev Admi' AS dimension,
    CASE
      WHEN prev_admissions = 0 THEN '0'
      WHEN prev_admissions <= 2 THEN '1-2'
      ELSE '3+'
    END AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base
  WHERE prev_admissions IS NOT NULL

  UNION ALL

  -- ============================================================
  -- Primary Diagnosis Description
  -- ============================================================
  SELECT
    'Primary Diag' AS dimension,
    primary_diag_desc AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base
  WHERE primary_diag_desc IS NOT NULL

  UNION ALL

  -- ============================================================
  -- Systolic BP
  -- ============================================================
  SELECT
    'Systolic' AS dimension,
    CASE
      WHEN systolic_bp < 90 THEN 'Low'
      WHEN systolic_bp < 120 THEN 'Normal'
      WHEN systolic_bp < 130 THEN 'Elevated'
      WHEN systolic_bp < 140 THEN 'High - Stage 1'
      WHEN systolic_bp >= 140 THEN 'High - Stage 2'
    END AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base
  WHERE systolic_bp IS NOT NULL

  UNION ALL

  -- ============================================================
  -- Teaching Hospital
  -- ============================================================
  SELECT
    'Teaching Hosp' AS dimension,
    CAST(teaching AS STRING) AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base
  WHERE teaching IS NOT NULL

  UNION ALL

  -- ============================================================
  -- Ward Type
  -- ============================================================
  SELECT
    'Ward Type' AS dimension,
    ward_type AS group_name,
    admission_id,
    discharge_type,
    readmitted_30d
  FROM base
  WHERE ward_type IS NOT NULL
),

-- ================================================================
-- Overall 30D readmission count
-- This is the denominator for Share of All Readmissions.
-- ================================================================
overall AS (

  SELECT
    COUNT(DISTINCT CASE
      WHEN discharge_type <> 'Expired'
       AND readmitted_30d = 1
      THEN admission_id
    END) AS total_readmissions_30d

  FROM base
),

-- ================================================================
-- Aggregate each dimension/group
-- ================================================================
aggregated AS (

  SELECT
    dimension,
    group_name,

    COUNT(DISTINCT CASE
      WHEN discharge_type <> 'Expired'
      THEN admission_id
    END) AS eligible_admissions,

    COUNT(DISTINCT CASE
      WHEN discharge_type <> 'Expired'
       AND readmitted_30d = 1
      THEN admission_id
    END) AS readmissions_30d

  FROM dimension_groups

  GROUP BY
    dimension,
    group_name
)

-- ================================================================
-- Final output
-- ================================================================
SELECT
  dimension,
  group_name AS `group`,

  CONCAT(
    dimension,
    ' — ',
    group_name
  ) AS dimension_group,

  readmissions_30d,

  SAFE_DIVIDE(
    readmissions_30d,
    eligible_admissions
  ) AS readmission_rate_30d,

  SAFE_DIVIDE(
    readmissions_30d,
    overall.total_readmissions_30d
  ) AS share_of_all_readmission

FROM aggregated

CROSS JOIN overall

ORDER BY
  dimension,
  group_name;



  --Validation 

  SELECT
  dimension,
  COUNT(*) AS number_of_groups
FROM
  `healthcare-readmission-505214.staging.fea_readmission_all_dimensions`
GROUP BY
  dimension
ORDER BY
  dimension; 

-- View the complete dataset
SELECT *
FROM
  `healthcare-readmission-505214.staging.fea_readmission_all_dimensions`