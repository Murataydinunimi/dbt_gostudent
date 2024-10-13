WITH stg_customers AS (
    
    
    SELECT
    contact_id,
    CAST(customer_date AS DATE) AS customer_date,
    contract_length,
    CURRENT_TIMESTAMP AS _stg_datetime
FROM {{ ref('dl_customers') }} )
 

SELECT * 
FROM
stg_customers
