SELECT 
    calls_ivr_id,
    CASE 
        WHEN LEFT(calls_vdn_label, 3) = 'ATC' THEN 'FRONT'
        WHEN LEFT(calls_vdn_label, 4) = 'TECH' THEN 'TECH'
        WHEN calls_vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
        ELSE 'RESTO'
    END AS vdn_aggregation,

FROM 
    `keepcoding.ivr_detail`


