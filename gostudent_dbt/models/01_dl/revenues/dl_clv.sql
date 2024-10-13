WITH new_clv AS (

SELECT
    contract_length,
    avg_clv,
    MD5(CAST(raw AS TEXT)) AS _row_hash,
    CURRENT_TIMESTAMP AS _dl_datetime
    FROM {{ source('clv_table','clv_dataset') }} AS raw

)

SELECT * FROM new_clv
WHERE _dl_datetime IS NOT NULL

{% if is_incremental() %}

AND _row_hash NOT IN (SELECT _row_hash from {{this}})

{% endif %}