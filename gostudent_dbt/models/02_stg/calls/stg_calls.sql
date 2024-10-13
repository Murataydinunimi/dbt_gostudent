WITH stg_call AS (
    SELECT
        contact_id,
        trial_booked,
        CAST(trial_date AS date) AS trial_date,
        call_attempts,
        total_call_duration,
        calls_30,
        CURRENT_TIMESTAMP AS _stg_datetime
    FROM {{ ref('dl_calls') }}
)

SELECT *
FROM stg_call
