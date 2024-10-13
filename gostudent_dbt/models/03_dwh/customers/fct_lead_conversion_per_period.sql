WITH fct AS (
    SELECT 
        year_month,
        SUM(customer_converted) AS customer_converted_period,
        SUM(total_customer) AS total_customer_period
    FROM 
        {{ ref('fct_lead_conversion_per_source') }}  
    GROUP BY 
        year_month
)

SELECT 
    *,
    CAST(customer_converted_period/total_customer_period AS decimal) AS conversion_ratio 
FROM 
    fct
ORDER BY 
    year_month