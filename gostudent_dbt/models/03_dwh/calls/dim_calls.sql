WITH dim_calls AS (
    SELECT 
        contact_id,
        trial_booked,
        trial_date,
        call_attempts,
        total_call_duration,
        calls_30,
        CURRENT_TIMESTAMP AS _dm_datetime
    FROM {{ ref('stg_calls') }}

)

SELECT 
* 
FROM
dim_calls