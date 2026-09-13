-- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Operational
-- Question 16: Does hospital bed capacity affect 30-day readmission?
-- Purpose: Compare 30-day readmission rates across hospital
--          bed-capacity categories.
-- ============================================================

SELECT
  CASE
    WHEN h.beds < 100 THEN '<100'
    WHEN h.beds < 200 THEN '100-199'
    WHEN h.beds < 300 THEN '200-299'
    WHEN h.beds < 400 THEN '300-399'
    WHEN h.beds < 500 THEN '400-499'
    WHEN h.beds < 600 THEN '500-599'
    WHEN h.beds < 700 THEN '600-699'
    WHEN h.beds >= 700 THEN '700+'
  END AS bed_capacity,

  COUNT(*) AS total_admissions,

  SUM(a.readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(a.readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions` AS a

JOIN `healthcare-readmission-505214.staging.stag_hospitals` AS h
  ON a.hospital_id = h.hospital_id

GROUP BY
  bed_capacity

ORDER BY
  CASE
    WHEN bed_capacity = '<100' THEN 1
    WHEN bed_capacity = '100-199' THEN 2
    WHEN bed_capacity = '200-299' THEN 3
    WHEN bed_capacity = '300-399' THEN 4
    WHEN bed_capacity = '400-499' THEN 5
    WHEN bed_capacity = '500-599' THEN 6
    WHEN bed_capacity = '600-699' THEN 7
    WHEN bed_capacity = '700+' THEN 8
  END;