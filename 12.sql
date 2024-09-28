CREATE OR REPLACE TABLE `keepcoding.ivr_summary` AS
WITH ivr_detail AS (
    SELECT 
        calls_ivr_id,
        calls_phone_number,
        calls_ivr_result,
        calls_start_date,
        calls_end_date,
        calls_total_duration,
        calls_customer_segment,
        calls_ivr_language,
        calls_vdn_label,
        module_name,
        document_type,
        document_identification,
        customer_phone,
        billing_account_id,
        step_name,
        step_result
    FROM 
        `keepcoding.ivr_detail`
),

previous_calls AS (
    SELECT 
        calls_phone_number,
        1 AS repeated_phone_24H
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
        1 AS cause_recall_phone_24H
    FROM 
        ivr_detail
    WHERE 
        calls_start_date > TIMESTAMP('2022-12-12 00:00:00 UTC')
        AND calls_start_date <= TIMESTAMP_ADD(TIMESTAMP('2022-12-12 00:00:00 UTC'), INTERVAL 24 HOUR)
    GROUP BY 
        calls_phone_number
)

SELECT
    ivr_detail.calls_ivr_id AS ivr_id,
    ivr_detail.calls_phone_number AS phone_number,
    ivr_detail.calls_ivr_result AS ivr_result,
    CASE 
        WHEN ivr_detail.calls_vdn_label LIKE 'ATC%' THEN 'FRONT'
        WHEN ivr_detail.calls_vdn_label LIKE 'TECH%' THEN 'TECH'
        WHEN ivr_detail.calls_vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
        ELSE 'RESTO'
    END AS vdn_aggregation,
    ivr_detail.calls_start_date AS start_date,
    ivr_detail.calls_end_date AS end_date,
    ivr_detail.calls_total_duration AS total_duration,
    ivr_detail.calls_customer_segment AS customer_segment,
    ivr_detail.calls_ivr_language AS ivr_language,
    COUNT(DISTINCT ivr_detail.module_name) AS steps_module,
    ARRAY_AGG(DISTINCT ivr_detail.module_name) AS module_aggregation,
    MAX(CASE 
        WHEN ivr_detail.document_type <> 'UNKNOWN' THEN ivr_detail.document_type 
        ELSE NULL 
    END) AS document_type,
    MAX(CASE 
        WHEN ivr_detail.document_identification <> 'UNKNOWN' THEN ivr_detail.document_identification 
        ELSE NULL 
    END) AS document_identification,
    IFNULL(MAX(CASE 
        WHEN ivr_detail.customer_phone = 'UNKNOWN' THEN NULL 
        ELSE ivr_detail.customer_phone 
    END), 'UNKNOWN') AS customer_phone,
    MAX(CASE 
        WHEN ivr_detail.billing_account_id <> 'UNKNOWN' THEN ivr_detail.billing_account_id 
        ELSE NULL 
    END) AS billing_account_id,
    MAX(IF(ivr_detail.module_name = 'AVERIA_MASIVA', 1, 0)) AS masiva_lg,
    MAX(IF(ivr_detail.step_name = 'CUSTOMERINFOBYPHONE.TX' AND ivr_detail.step_result = 'OK', 1, 0)) AS info_by_phone_lg,
    MAX(IF(ivr_detail.step_name = 'CUSTOMERINFOBYDNI.TX' AND ivr_detail.step_result = 'OK', 1, 0))  AS info_by_dni_lg,
    COALESCE(previous_calls.repeated_phone_24H, 0) AS repeated_phone_24H,
    COALESCE(next_calls.cause_recall_phone_24H, 0) AS cause_recall_phone_24H
FROM 
    ivr_detail
LEFT JOIN 
    previous_calls ON ivr_detail.calls_phone_number = previous_calls.calls_phone_number
LEFT JOIN 
    next_calls ON ivr_detail.calls_phone_number = next_calls.calls_phone_number
GROUP BY 
    ivr_detail.calls_ivr_id,
    ivr_detail.calls_phone_number,
    ivr_detail.calls_ivr_result,
    ivr_detail.calls_start_date,
    ivr_detail.calls_end_date,
    ivr_detail.calls_total_duration,
    ivr_detail.calls_customer_segment,
    ivr_detail.calls_ivr_language,
    ivr_detail.calls_vdn_label,
    previous_calls.repeated_phone_24H,
    next_calls.cause_recall_phone_24H
ORDER BY 
    ivr_id;


-- me he metido un lío tremendo, mi neurona ya no sabe, mi neurona? == UNKNOWN 