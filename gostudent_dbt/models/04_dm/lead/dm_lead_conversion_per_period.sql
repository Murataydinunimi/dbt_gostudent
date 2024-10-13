WITH lead_conversion AS (
    SELECT 
        year_month,
        SUM(customer_converted) AS customer_converted_per_period,
        SUM(total_customer) AS total_customer_per_period
    FROM 
        {{ ref('dm_lead_conversion_per_source') }}  
    GROUP BY 
        year_month
),

final AS (
    SELECT 
        *,
        CAST(customer_converted_per_period / total_customer_per_period AS decimal) * 100 AS conversion_ratio_period,
        CURRENT_TIMESTAMP AS _dm_datetime
    FROM 
        lead_conversion
    ORDER BY 
        year_month
)

SELECT 
    * 
FROM 
    final
