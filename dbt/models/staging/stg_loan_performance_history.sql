
-- models/staging/stg_loan_performance_history.sql
-- dbt model for cleaning and selecting raw loan performance history data
-- This model addresses duplicate snapshots and corrects days_past_due inconsistencies.

SELECT
    application_id,
    CAST(report_date AS DATE) AS report_date,
    status,
    -- Correct days_past_due based on status
    CASE
        WHEN status = 'Current' THEN 0
        WHEN status = 'Late 30' AND days_past_due > 0 AND days_past_due <= 30 THEN days_past_due
        WHEN status = 'Late 30' AND days_past_due > 30 THEN 30 -- Cap at 30 for 'Late 30' status
        WHEN status = 'Late 60' AND days_past_due > 30 AND days_past_due <= 60 THEN days_past_due
        WHEN status = 'Late 60' AND days_past_due <= 30 THEN 31 -- Ensure > 30 for 'Late 60'
        WHEN status = 'Late 60' AND days_past_due > 60 THEN 60 -- Cap at 60 for 'Late 60' status
        WHEN status = 'Default' AND days_past_due > 60 THEN days_past_due
        WHEN status = 'Default' AND days_past_due <= 60 THEN 61 -- Ensure > 60 for 'Default'
        ELSE days_past_due -- Fallback for other cases or already correct values
    END AS days_past_due,
    balance
FROM
    `driiiportfolio.raw.loan_performance_history`
QUALIFY ROW_NUMBER() OVER (PARTITION BY application_id, report_date ORDER BY report_date DESC) = 1
