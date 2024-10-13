WITH new_sales_costs AS (

SELECT
    year_month,
    total_sales_costs,
    trial_costs,
    MD5(CAST(raw AS TEXT)) AS _row_hash,
    CURRENT_TIMESTAMP AS _dl_datetime
    FROM {{ source('sales_cost_table','sales_cost_dataset') }} AS raw

)

SELECT * FROM new_sales_costs
WHERE _dl_datetime IS NOT NULL

{% if is_incremental() %}

AND _row_hash NOT IN (SELECT _row_hash from {{this}})

{% endif %}