WITH new_calls AS (

SELECT
    contact_id,
    trial_booked,
    trial_date,
    call_attempts,
    total_call_duration,
    calls_30,
    MD5(CAST(raw AS TEXT)) AS _row_hash,
    CURRENT_TIMESTAMP AS _dl_datetime
    FROM {{ source('calls_table','call_dataset') }} AS raw

)

SELECT * FROM new_calls
WHERE _dl_datetime IS NOT NULL

{% if is_incremental() %}

AND _row_hash NOT IN (SELECT _row_hash from {{this}})

{% endif %}