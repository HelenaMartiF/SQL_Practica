WITH tmp_table AS (
    SELECT 
        calls_ivr_id, 
        billing_account_id,
        ROW_NUMBER() OVER (
            PARTITION BY calls_ivr_id 
            ORDER BY 
                CASE 
                    WHEN billing_account_id = 'UNKNOWN' THEN 0 
                    ELSE 1 
                END DESC
        ) AS rn
    FROM 
        `keepcoding.ivr_detail`
)

SELECT 
    calls_ivr_id, 
    billing_account_id, 
FROM 
    tmp_table
WHERE 
    rn = 1
ORDER BY 
    calls_ivr_id;


--------------------------------------------------------------

WITH tmp_table AS (
    SELECT 
        calls_ivr_id,
        MAX(CASE 
            WHEN billing_account_id <> 'UNKNOWN' THEN billing_account_id 
            ELSE NULL 
        END) AS billing_account_id
    FROM 
        `keepcoding.ivr_detail`
    GROUP BY 
        calls_ivr_id
)

SELECT 
    calls_ivr_id, 
    IFNULL(billing_account_id, 'UNKNOWN') AS billing_account_id
FROM 
    tmp_table
ORDER BY 
    calls_ivr_id;
