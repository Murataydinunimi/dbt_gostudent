{% macro get_datalake_model(source_name, table_name) %}
WITH new_data AS (
    SELECT
        *,
        MD5(CAST(raw AS TEXT)) AS _row_hash,
        CURRENT_TIMESTAMP AS _dl_datetime
    FROM {{ source(source_name, table_name) }} AS raw
)

SELECT *
FROM new_data
WHERE _dl_datetime IS NOT NULL

{% if is_incremental() %}
    AND _row_hash NOT IN (SELECT _row_hash FROM {{ this }})
{% endif %}
{% endmacro %}
