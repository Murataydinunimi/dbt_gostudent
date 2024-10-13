WITH calls_analysis AS (
    SELECT 
        dl.contact_id,
        dc.customer_date,
        cad.call_attempts,
        cad.trial_booked,
        cad.calls_30,
        
        -- Determine if the lead is a customer
        CASE 
            WHEN dc.customer_date IS NOT NULL THEN 1 
            ELSE 0 
        END AS is_customer,

        -- Categorize call attempts into ranges
        CASE 
            WHEN cad.call_attempts BETWEEN 0 AND 10 THEN 1
            WHEN cad.call_attempts BETWEEN 11 AND 20 THEN 2
            WHEN cad.call_attempts BETWEEN 21 AND 30 THEN 3
            WHEN cad.call_attempts BETWEEN 31 AND 40 THEN 4
            ELSE 5  
        END AS call_attempts_range,

        -- Categorize calls_30 into ranges
        CASE 
            WHEN cad.calls_30 BETWEEN 0 AND 3 THEN 1
            WHEN cad.calls_30 BETWEEN 4 AND 10 THEN 2
            WHEN cad.calls_30 BETWEEN 11 AND 14 THEN 3
            WHEN cad.calls_30 BETWEEN 15 AND 20 THEN 4
            ELSE 5 
        END AS calls_30_range

    FROM 
        {{ref('dim_lead')}} dl
    LEFT JOIN 
        {{ref('dim_customers')}} dc ON dl.contact_id = dc.contact_id
    LEFT JOIN 
        {{ref('dim_calls')}} cad ON cad.contact_id = dl.contact_id
),

call_attempts_agg AS (
    SELECT 
        call_attempts_range,
        CAST(SUM(is_customer) AS DECIMAL) AS c_attemps_customer_converted, 
        CAST(COUNT(is_customer) AS DECIMAL) AS c_attemps_total_customer
    FROM 
        calls_analysis 
    GROUP BY  
        call_attempts_range
),

call_30_agg AS (
    SELECT 
        calls_30_range,
        CAST(SUM(is_customer) AS DECIMAL) AS c_30_customer_converted, 
        CAST(COUNT(is_customer) AS DECIMAL) AS c_30_total_customer
    FROM 
        calls_analysis 
    GROUP BY  
        calls_30_range
),

c_attemps AS (
    SELECT 
        *,
        CAST(c_attemps_customer_converted / NULLIF(c_attemps_total_customer, 0) AS DECIMAL) AS c_attemps_conversion_ratio,
        ROW_NUMBER() OVER () AS rn
    FROM 
        call_attempts_agg
),

c_30 AS (
    SELECT 
        *,
        CAST(c_30_customer_converted / NULLIF(c_30_total_customer, 0) AS DECIMAL) AS c_30_conversion_ratio,
        ROW_NUMBER() OVER () AS rn
    FROM 
        call_30_agg
)
,

final AS (
    
    SELECT 
    *
FROM 
    c_30 c3
JOIN 
    c_attemps ca ON ca.rn = c3.rn
)

SELECT 
    calls_30_range,
    c_30_customer_converted,
    c_30_total_customer,
    c_30_conversion_ratio,
    call_attempts_range,
    c_attemps_customer_converted,
    c_attemps_total_customer,
    c_attemps_conversion_ratio,
    CURRENT_TIMESTAMP AS _dwh_datetime
FROM final
