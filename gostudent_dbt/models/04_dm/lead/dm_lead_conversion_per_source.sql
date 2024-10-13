WITH lead_conversion AS (
    
SELECT 
    fl.marketing_source,
    fl.year_month,
    fl.customer_converted,
    fl.total_customer,
    fs.total_marketing_costs,
    fl.conversion_ratio AS lead_conversion_ratio,
    CURRENT_TIMESTAMP AS _dm_datetime

FROM 
    {{ ref('fct_lead_conversion_per_source') }} AS fl
JOIN 
    {{ ref('fct_mkt_cost_per_source') }} AS fs
ON 
    fl.year_month = fs.year_month 
    AND fs.marketing_source = fl.marketing_source

)

SELECt * FROM lead_conversion