
-- models/intermediate/int_loan_performance_metrics.sql
-- dbt model for joining staged data and calculating derived metrics

WITH loan_data AS (
    SELECT
        orig.application_id,
        orig.customer_id,
        orig.credit_score,
        orig.ltv_ratio AS initial_ltv_ratio,
        orig.loan_amount,
        orig.tier,
        orig.interest_rate,
        orig.origination_date,
        perf.report_date,
        perf.status AS loan_status,
        perf.days_past_due,
        perf.balance
    FROM
        {{ ref('stg_loan_origination_data') }} AS orig
    INNER JOIN
        {{ ref('stg_loan_performance_history') }} AS perf
    ON
        orig.application_id = perf.application_id
)

SELECT
    application_id,
    customer_id,
    credit_score,
    initial_ltv_ratio,
    loan_amount,
    tier,
    interest_rate,
    origination_date,
    report_date,
    loan_status,
    days_past_due,
    balance,
    DATE_DIFF(report_date, origination_date, DAY) AS loan_age_days, -- Derived metric: loan_age_days
    CASE
        WHEN days_past_due > 0 THEN TRUE
        ELSE FALSE
    END AS is_delinquent, -- Derived metric: is_delinquent
    CASE
        WHEN days_past_due = 0 THEN 'Good Standing'
        WHEN days_past_due > 0 AND days_past_due <= 30 THEN 'Late 1-30 Days'
        WHEN days_past_due > 30 AND days_past_due <= 60 THEN 'Late 31-60 Days'
        WHEN days_past_due > 60 AND days_past_due <= 90 THEN 'Late 61-90 Days'
        ELSE 'Default'
    END AS loan_status_category -- Derived metric: loan_status_category
FROM
    loan_data
