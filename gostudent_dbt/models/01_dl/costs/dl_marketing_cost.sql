WITH new_mkt_costs AS (

SELECT
    date,
    marketing_source,
    marketing_costs,
    MD5(CAST(raw AS TEXT)) AS _row_hash,
    CURRENT_TIMESTAMP AS _dl_datetime
    FROM {{ source('marketing_cost_table','marketing_costs_dataset') }} AS raw

)

SELECT * FROM new_mkt_costs
WHERE _dl_datetime IS NOT NULL

{% if is_incremental() %}

AND _row_hash NOT IN (SELECT _row_hash from {{this}})

{% endif %}