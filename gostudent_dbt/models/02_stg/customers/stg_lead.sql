WITH stg_lead AS (
    
    
    SELECT
    contact_id,
    create_date,
    marketing_source,
    COALESCE(known_city, 0) AS known_city,
    COALESCE(message_length, 0) AS message_length,
    test_flag,
    CURRENT_TIMESTAMP AS _stg_datetime
FROM {{ ref('dl_lead_dataset') }} )


SELECT * 
FROM
stg_lead
