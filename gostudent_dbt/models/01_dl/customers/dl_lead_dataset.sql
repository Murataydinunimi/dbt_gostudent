WITH new_leads AS (

SELECT
    contact_id,
    marketing_source,
    create_date,
    known_city,
    message_length,
    test_flag,
    MD5(CAST(raw AS TEXT)) AS _row_hash,
    CURRENT_TIMESTAMP AS _dl_datetime
    FROM {{ source('lead_table','lead_dataset') }} AS raw

)

SELECT * FROM new_leads
WHERE _dl_datetime IS NOT NULL

{% if is_incremental() %}

AND _row_hash NOT IN (SELECT _row_hash from {{this}})

{% endif %}