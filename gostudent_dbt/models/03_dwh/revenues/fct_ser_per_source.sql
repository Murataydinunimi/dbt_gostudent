WITH expected_revenue_per_source AS (
SELECT *
FROM {{ ref('fct_revenues_per_source')}}
    
)

,

final AS (
    
SELECt 
    erps.*,
    fct.total_marketing_costs,
    CURRENT_TIMESTAMP AS _dwh_datetime
FROM 
    expected_revenue_per_source AS erps
JOIN {{ ref('fct_mkt_cost_per_source') }} AS fct
ON erps.acquisition_month = fct.year_month AND erps.marketing_source = fct.marketing_source
)

SELECT * FROM FINAL


