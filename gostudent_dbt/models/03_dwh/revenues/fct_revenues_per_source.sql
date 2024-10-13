WITH customers_with_clv AS (
    
SELECT 
    fct.acquisition_month,
    fct.marketing_source,
    fct.contract_length,
    fct.contact_id,
    clv.avg_clv
FROM {{ ref('fct_customer_per_source')}} AS fct
JOIN {{ref('dim_clv')}}  AS clv
ON fct.contract_length = clv.contract_length
WHERE fct.contract_length IS NOT NULL

)

,

agg_customers_with_clv AS  (
SELECT 
    acquisition_month,
    marketing_source,
    count(contact_id) total_n_customer,
    avg_clv
FROM customers_with_clv
GROUP BY acquisition_month, marketing_source,avg_clv
)

,

final AS (

SELECT 
    acquisition_month,
    marketing_source,
    (total_n_customer*avg_clv) AS total_expected_revenue,
    avg_clv,
    total_n_customer
FROM agg_customers_with_clv


)

SELECT * FROM final