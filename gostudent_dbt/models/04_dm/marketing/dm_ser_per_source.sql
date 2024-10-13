
WITH dm_to_agg AS (

SELECT 
    acquisition_month AS ser_period,
    marketing_source,
    total_expected_revenue,
    total_marketing_costs,
    total_n_customer
 FROM {{ref('fct_ser_per_source')}}
 WHERE marketing_source IS NOT NULL
)
,

dm AS (

SELECT
    ser_period,
    marketing_source,
    SUM(total_expected_revenue) AS total_revenue,
    SUM(total_n_customer) AS total_customers,
    MAX(total_marketing_costs) AS marketing_cost
FROM dm_to_agg
GROUP BY ser_period, marketing_source


)

,

final AS (
SELECT
    ser_period,
    marketing_source,
    total_customers,
    total_revenue,
    marketing_cost,
    (total_revenue/marketing_cost) AS ser_ratio,
    CURRENT_TIMESTAMP as _dm_datetime
FROM dm


)

SELECT * FROM final

