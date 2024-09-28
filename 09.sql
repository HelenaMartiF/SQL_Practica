SELECT 
    calls_ivr_id,
    MAX(IF(step_name = 'CUSTOMERINFOBYPHONE.TX' AND step_result = 'OK', 1, 0)) AS info_by_phone
FROM 
    `keepcoding.ivr_detail`
GROUP BY 
    calls_ivr_id
ORDER BY 
    info_by_phone DESC;