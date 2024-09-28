WITH tmp_table AS (
    SELECT 
        calls_ivr_id, 
        customer_phone,
        ROW_NUMBER() OVER (
            PARTITION BY calls_ivr_id 
            ORDER BY 
                CASE 
                    WHEN customer_phone = 'UNKNOWN' THEN 0 
                    ELSE 1 
                END DESC
        ) AS rn
    FROM 
        `keepcoding.ivr_detail`
)

SELECT 
    calls_ivr_id, 
    customer_phone, 
FROM 
    tmp_table
WHERE 
    rn = 1
ORDER BY 
    calls_ivr_id;


-----------------------------------------------------------

SELECT 
    calls_ivr_id, 
    IFNULL(MAX(CASE 
        WHEN customer_phone = 'UNKNOWN' THEN NULL 
        ELSE customer_phone 
    END), 'UNKNOWN') AS customer_phone
FROM 
    `keepcoding.ivr_detail`
GROUP BY 
    calls_ivr_id
ORDER BY 
    calls_ivr_id;
