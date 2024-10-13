WITH 

dim_marketing_costs AS (
    SELECT
		year_month,
        SUM(marketing_costs) AS total_marketing_costs
    FROM {{ref('dim_marketing_cost')}}
    GROUP BY year_month
),



most_invested_markets_per_period AS (
    SELECT
		year_month AS cost_period,
		marketing_source,
		marketing_costs,
		ROW_NUMBER() OVER(PARTITION BY year_month ORDER BY marketing_costs) AS RN
    FROM  {{ref('dim_marketing_cost')}}
),

most_invested_market AS  (
SELECT * FROM most_invested_markets_per_period
WHERE RN = 1)
,

dim_sales_cost AS(

SELECT
	year_month,
	SUM(total_sales_costs) + SUM(trial_costs) as total_sales_cost
	FROM {{ref('dim_sales_cost')}}
	GROUP BY year_month
)


,

all_cost AS (
SELECT 
dmc.year_month AS cost_period,
COALESCE(SUM(dmc.total_marketing_costs), 0) + COALESCE(SUM(total_sales_cost), 0) AS total_cost
FROM dim_marketing_costs AS dmc
LEFT JOIN dim_sales_cost AS dsc
ON dmc.year_month = dsc.year_month
GROUP BY dmc.year_month
)
,

dim_customer AS (

SELECT 
*
FROM
{{ref('dim_customers')}}

),


new_customers_by_month AS (
    SELECT
        TO_CHAR(customer_date, 'YYYY-MM') AS acquisition_month, 
        COUNT(DISTINCT contact_id) AS new_customers               -- Count unique customers acquired in that month
    FROM dim_customer
    GROUP BY TO_CHAR(customer_date, 'YYYY-MM')                   
    ORDER BY acquisition_month                                   
)
,

final AS (
    
SELECT
    ncm.acquisition_month AS cac_period,
    ncm.new_customers,
    ac.total_cost,
    mim.marketing_source AS most_invested_market_of_period,
    COALESCE(ac.total_cost, 0) / COALESCE((ncm.new_customers), 0) AS cac_ratio,
    CURRENT_TIMESTAMP AS _dwh_datetime
FROM new_customers_by_month as ncm
LEFT JOIN all_cost AS ac
ON ncm.acquisition_month = ac.cost_period
LEFT JOIN  most_invested_market AS mim
ON ncm.acquisition_month = mim.cost_period
)

SELECT * FROM final

-- see the customer acquisition cost ratio along with the most invested channel for marketing per period