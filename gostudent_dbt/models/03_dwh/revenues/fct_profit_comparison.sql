WITH fct_revenues_per_source AS (
    SELECT 
        acquisition_month,
        marketing_source,
        SUM(total_expected_revenue) AS tot_rev_per_src
    FROM 
        {{ref('fct_revenues_per_source')}}
    WHERE 
        marketing_source IS NOT NULL
    GROUP BY 
        marketing_source,
        acquisition_month
    ORDER BY 
        acquisition_month
)
,

fct_revenue_cost_per_source AS (
SELECT 
    frps.*,
    fct.total_marketing_costs 
FROM 
    fct_revenues_per_source AS frps
JOIN 
    {{ref('fct_mkt_cost_per_source')}} AS fct
ON 
    frps.acquisition_month = fct.year_month
)
,

final AS (

SELECT 
    *,
    (tot_rev_per_src/total_marketing_costs) AS profit_ratio
 FROM fct_revenue_cost_per_source



)


SELECT * FROM final