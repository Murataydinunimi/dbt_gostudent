WITH customer_count_per_period_with_clv AS

(
SELECT 
    TO_CHAR(customer_date, 'YYYY-MM')AS year_month,
    COUNT(contact_id) AS unique_customers,
	dc.contract_length,
	cl.avg_clv
FROM 
    {{ref('dim_customers')}} AS dc

JOIN {{ref('dim_clv')}} as cl
ON dc.contract_length = cl.contract_length
WHERE dc.contract_length IS NOT NULL
GROUP BY 
    year_month,dc.contract_length,cl.avg_clv
ORDER BY 
    year_month
)

,

expected_revenue_per_contract_length AS (
    
SELECT 
    ccpp.*,
    (unique_customers * avg_clv) as total_expected_revenue_per_contract_length
FROM
     customer_count_per_period_with_clv AS ccpp

)

,

expected_revenue_per_period AS (

    SELECT 
        year_month, 
        SUM(total_expected_revenue_per_contract_length) AS total_expected_revenue_per_period
    FROM expected_revenue_per_contract_length
    GROUP BY year_month
    
)


SELECT *
FROM
expected_revenue_per_period