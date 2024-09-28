WITH ivr_detail AS (
    SELECT 
        calls_ivr_id,
        calls_phone_number,
        TIMESTAMP(calls_start_date) AS calls_start_date 
    FROM 
        `keepcoding.ivr_detail`
),

previous_calls AS (
    SELECT 
        calls_phone_number,
        1 AS previous_flag
    FROM 
        ivr_detail
    WHERE 
        calls_start_date < TIMESTAMP('2022-12-12 00:00:00 UTC')
        AND calls_start_date >= TIMESTAMP_SUB(TIMESTAMP('2022-12-12 00:00:00 UTC'), INTERVAL 24 HOUR)
    GROUP BY 
        calls_phone_number
), 

next_calls AS (
    SELECT 
        calls_phone_number,
        1 AS next_flag
    FROM 
        ivr_detail
    WHERE 
        calls_start_date > TIMESTAMP('2022-12-12 00:00:00 UTC')
        AND calls_start_date <= TIMESTAMP_ADD(TIMESTAMP('2022-12-12 00:00:00 UTC'), INTERVAL 24 HOUR)
    GROUP BY 
        calls_phone_number
)

SELECT 
    ivr_detail.calls_ivr_id,  
    ivr_detail.calls_phone_number,
    COALESCE(previous_calls.previous_flag, 0) AS previous_flag,
    COALESCE(next_calls.next_flag, 0) AS next_flag
FROM 
    (SELECT DISTINCT calls_phone_number, calls_ivr_id FROM ivr_detail) AS ivr_detail
LEFT JOIN 
    previous_calls ON ivr_detail.calls_phone_number = previous_calls.calls_phone_number
LEFT JOIN 
    next_calls ON ivr_detail.calls_phone_number = next_calls.calls_phone_number
ORDER BY 
    ivr_detail.calls_phone_number;





