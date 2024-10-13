WITH sales_costs AS (
    SELECT 
        year_month,
        total_sales_costs,
        trial_costs,
        CURRENT_TIMESTAMP AS _dwh_datetime
    FROM {{ ref('stg_sales_cost') }}
 
)

SELECT 
*
FROM
sales_costs