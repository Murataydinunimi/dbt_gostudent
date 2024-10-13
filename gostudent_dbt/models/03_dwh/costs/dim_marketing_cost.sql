WITH marketing_costs AS (
    SELECT 
        year_month,
        marketing_source,
        marketing_costs,
        CURRENT_TIMESTAMP AS _dwh_datetime
    FROM {{ ref('stg_marketing_cost') }}

)

SELECT 
* 
FROM
marketing_costs