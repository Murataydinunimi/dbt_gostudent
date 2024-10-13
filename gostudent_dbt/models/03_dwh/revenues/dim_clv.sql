WITH dim_clv AS (
    SELECT
        contract_length,
        avg_clv,
        CURRENT_TIMESTAMP AS _dwh_datetime
    FROM {{ ref('stg_clv') }}
)

SELECT *
FROM dim_clv