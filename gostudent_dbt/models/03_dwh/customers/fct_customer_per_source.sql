WITH leads AS (
SELECT
    contact_id,
    marketing_source,
    ROW_NUMBER() OVER(PARTITION BY contact_id ORDER BY create_date) AS rn
FROM  {{ref('dim_lead')}}
    
    )

,

distinct_lead AS (

SELECT  *
FROM leads 
WHERE rn = 1 

)


,

fct AS (
    
SELECT 
    TO_CHAR(cust.customer_date, 'YYYY-MM') AS acquisition_month,
    cust.contact_id,
    cust.customer_date,
    cust.contract_length,
    ld.marketing_source,
    CURRENT_TIMESTAMP AS _dwh_datetime
FROM {{ref('dim_customers')}} AS cust
LEFT JOIN distinct_lead  AS ld
ON cust.contact_id = ld.contact_id
)

SELECT * FROM fct
