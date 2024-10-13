WITH stg_mkt_cost AS (
    
SELECT
    date AS year_month,
    marketing_source,
    marketing_costs,
    CURRENT_TIMESTAMP AS _stg_datetime
FROM {{ ref('dl_marketing_cost') }}

)

SELECT *
FROM 
stg_mkt_cost

