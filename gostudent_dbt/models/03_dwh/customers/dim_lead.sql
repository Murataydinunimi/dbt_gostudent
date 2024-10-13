WITH dim_lead AS (
    
    
    SELECT
    contact_id,
    CAST(create_date AS DATE) AS create_date, 
    marketing_source,
    known_city,
    message_length,
    test_flag,
    CURRENT_TIMESTAMP AS _dim_datetime
FROM {{ ref('stg_lead') }} )


SELECT * 
FROM
dim_lead
