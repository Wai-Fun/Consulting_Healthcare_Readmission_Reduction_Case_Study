-- ============================================================
-- Business Objective 2: Factors Associated with Readmissions, Operational
-- Question 17: Are patients discharged on weekends more likely
--               to experience 30-day readmission?
-- Purpose: Compare 30-day readmission rates between patients
--          discharged on weekdays and weekends.
-- ============================================================

SELECT
  CASE
    WHEN EXTRACT(DAYOFWEEK FROM discharge_date) IN (1, 7)
      THEN 'Weekend'
    ELSE 'Weekday'
  END AS discharge_day_type,

  COUNT(*) AS total_discharges,

  SUM(readmitted_30d) AS readmissions_30d,

  ROUND(
    SAFE_DIVIDE(SUM(readmitted_30d), COUNT(*)) * 100,
    2
  ) AS readmission_rate_30d

FROM `healthcare-readmission-505214.staging.stag_admissions`

GROUP BY
  discharge_day_type

ORDER BY
  readmission_rate_30d DESC;