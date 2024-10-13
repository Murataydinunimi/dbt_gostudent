WITH call_range_mappings AS (
    
SELECT 
    call_attempts_range,
    c_attempt_mapping,
    calls_30_range,
    c_30_mapping
FROM (
    SELECT 
        1 AS call_attempts_range,
        '0-10' AS c_attempt_mapping,
        1 AS calls_30_range,
        '0-3' AS c_30_mapping
    UNION ALL
    SELECT 
        2 AS call_attempts_range,
        '11-20' AS c_attempt_mapping,
        2 AS calls_30_range,
        '4-10' AS c_30_mapping
    UNION ALL
    SELECT 
        3 AS call_attempts_range,
        '21-30' AS c_attempt_mapping,
        3 AS calls_30_range,
        '11-14' AS c_30_mapping
    UNION ALL
    SELECT 
        4 AS call_attempts_range,
        '31-40' AS c_attempt_mapping,
        4 AS calls_30_range,
        '15-20' AS c_30_mapping
    UNION ALL
    SELECT 
        5 AS call_attempts_range,
        '41+' AS c_attempt_mapping,
        5 AS calls_30_range,
        '21+' AS c_30_mapping
) AS mapping_table

)

SELECT * FROM call_range_mappings