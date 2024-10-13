WITH stg_sales_cost AS (
    SELECT
        year_month,
        total_sales_costs,
        trial_costs,
        CURRENT_TIMESTAMP AS _stg_datetime
    FROM {{ ref('dl_sales_cost') }}
)

SELECT *
FROM stg_sales_cost
