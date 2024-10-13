
WITH dim_sales_costs AS (
    SELECT 
        year_month,
        SUM(total_sales_costs) AS total_sales_costs,
        SUM(trial_costs) AS total_trial_costs,
        CURRENT_TIMESTAMP AS _dwh_datetime
    FROM {{ref('dim_sales_cost')}}
    GROUP BY year_month
)

SELECT 
*,
(total_sales_costs + total_trial_costs) AS all_cost
FROM dim_sales_costs
