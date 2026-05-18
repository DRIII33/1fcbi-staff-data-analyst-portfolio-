
-- models/staging/stg_loan_origination_data.sql
-- dbt model for cleaning and selecting raw loan origination data

SELECT
    application_id,
    customer_id,
    credit_score,
    ltv_ratio,
    loan_amount,
    tier,
    interest_rate,
    origination_date
FROM
    `driiiportfolio.raw.loan_origination_data`
