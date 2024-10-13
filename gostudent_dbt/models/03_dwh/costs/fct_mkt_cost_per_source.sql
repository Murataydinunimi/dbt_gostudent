WITH dim_marketing_cost AS (
    
SELECT
*
FROM {{ref('dim_marketing_cost')}}

)
,

marketing_costs_per_source AS (
    SELECT 
        year_month,
        marketing_source,
        SUM(marketing_costs) AS total_marketing_costs,
        CURRENT_TIMESTAMP AS _dwh_datetime
    FROM dim_marketing_cost
    GROUP BY year_month, marketing_source
)

SELECT
*
FROM marketing_costs_per_source




