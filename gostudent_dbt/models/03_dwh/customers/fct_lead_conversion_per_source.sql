WITH lead_and_customer AS (
  SELECT 
    dl.*, 
    dc.customer_date,
    CASE 
      WHEN dc.customer_date IS NOT NULL THEN 1 
      ELSE 0 
    END AS is_customer
  FROM 
    {{ ref('dim_lead') }} dl
  LEFT JOIN 
    {{ ref('dim_customers') }} dc
  ON 
    dl.contact_id = dc.contact_id
)
,

agg_leads AS (
  SELECT 
    marketing_source, 
    TO_CHAR(create_date, 'YYYY-MM') AS year_month,
    CAST(SUM(is_customer) AS decimal) AS customer_converted, 
    CAST(COUNT(is_customer) AS decimal) AS total_customer
  FROM 
    lead_and_customer
  GROUP BY 
    marketing_source, year_month
),

customer_conversion AS (
  SELECT 
    *,
    CAST(customer_converted / total_customer AS decimal) * 100 AS conversion_ratio
  FROM 
    agg_leads
)

SELECT * 
FROM customer_conversion
