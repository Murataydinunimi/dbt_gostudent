WITH calls_conversion AS (

SELECT *,
CURRENT_TIMESTAMP AS _dm_datetime
FROM {{ref('fct_calls_lead_conversion')}}


)


SELECT * FROM calls_conversion
