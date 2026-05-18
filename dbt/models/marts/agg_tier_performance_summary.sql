
-- models/marts/agg_tier_performance_summary.sql
-- dbt model for aggregating data by tier to support Product Revision analysis

SELECT
    tier,
    COUNT(DISTINCT application_id) AS total_volume,
    ROUND(AVG(initial_ltv_ratio), 4) AS average_ltv,
    ROUND(AVG(interest_rate), 2) AS average_interest_rate,
    ROUND(SUM(CASE WHEN is_delinquent THEN 1 ELSE 0 END) * 1.0 / COUNT(application_id), 4) AS delinquency_rate,
    -- Strategic Flag: Identify tiers needing immediate Product Revision
    CASE
        WHEN (SUM(CASE WHEN is_delinquent THEN 1 ELSE 0 END) * 1.0 / COUNT(application_id)) > 0.05
             AND AVG(initial_ltv_ratio) > 0.85 THEN 'HIGH RISK: REDUCE LTV CAP'
        WHEN (SUM(CASE WHEN is_delinquent THEN 1 ELSE 0 END) * 1.0 / COUNT(application_id)) < 0.01 THEN 'OPPORTUNITY: EXPAND PRODUCTION'
        ELSE 'STABLE'
    END AS strategic_recommendation
FROM
    {{ ref('int_loan_performance_metrics') }}
GROUP BY
    tier
ORDER BY
    delinquency_rate DESC
