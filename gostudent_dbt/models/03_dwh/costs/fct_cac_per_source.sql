WITH fct_revenues_per_source AS (
    SELECT
        acquisition_month,
        marketing_source,
        SUM(total_expected_revenue) AS total_expected_revenue,
        SUM(total_n_customer) AS total_n_customer
    FROM 
        {{ref('fct_revenues_per_source')}}
    WHERE 
        marketing_source IS NOT NULL
    GROUP BY 
        acquisition_month,
        marketing_source
)
,

final AS (
SELECT 
    frps.*,
    csrc.total_marketing_costs,
    CURRENT_TIMESTAMP AS _dwh_datetime
FROM 
    fct_revenues_per_source AS frps
JOIN 
    {{ref('fct_mkt_cost_per_source')}} AS csrc
ON 
    frps.acquisition_month = csrc.year_month 
    AND frps.marketing_source = csrc.marketing_source
)

SELECT * FROM final