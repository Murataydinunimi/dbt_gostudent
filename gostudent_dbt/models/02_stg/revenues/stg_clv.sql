WITH stg_clv AS (
    SELECT
        contract_length,
        CAST(REPLACE(avg_clv, ',', '') AS DECIMAL) AS avg_clv,
        CURRENT_TIMESTAMP AS _stg_datetime
    FROM {{ ref('dl_clv') }}
)

SELECT *
FROM stg_clv