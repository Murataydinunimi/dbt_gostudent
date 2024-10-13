SELECT 
cac_period,
new_customers,
total_cost,
most_invested_market_of_period,
cac_ratio,
CURRENT_TIMESTAMP AS _dm_datetime
FROM 
{{ref('fct_cac_per_period')}}
WHERE most_invested_market_of_period IS NOT NULL
