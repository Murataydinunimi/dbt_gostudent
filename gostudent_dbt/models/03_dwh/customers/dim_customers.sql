WITH  dim_customer AS (
    SELECT
        contact_id,
        customer_date,
        contract_length,
        CURRENT_TIMESTAMP AS _dwh_datetime
    FROM {{ref('stg_customers')}}
)


SELECT 
*
FROM
dim_customer