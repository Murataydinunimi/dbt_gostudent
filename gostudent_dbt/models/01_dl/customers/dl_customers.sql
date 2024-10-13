WITH new_customers AS (

SELECT
    contact_id,
    customer_date,
    contract_length,
    MD5(CAST(raw AS TEXT)) AS _row_hash,
    CURRENT_TIMESTAMP AS _dl_datetime
    FROM {{ source('customer_table','customer_dataset') }} AS raw

)

SELECT * FROM new_customers
WHERE _dl_datetime IS NOT NULL

{% if is_incremental() %}

AND _row_hash NOT IN (SELECT _row_hash from {{this}})

{% endif %}