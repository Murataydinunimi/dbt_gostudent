WITH expected_revenue_per_period AS (
SELECT *
FROM {{ ref('fct_revenues_per_period')}}
    
)

,

final AS (
    
SELECt 
    erpp.*,
    fct.all_cost,
    CURRENT_TIMESTAMP AS _dwh_datetime
FROM 
    expected_revenue_per_period AS erpp
JOIN {{ ref('fct_sales_cost_per_period') }} AS fct
ON erpp.year_month = fct.year_month
)

SELECT * FROM FINAL