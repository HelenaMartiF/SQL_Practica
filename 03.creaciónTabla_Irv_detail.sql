CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
WITH formatted_calls AS (
    SELECT
        CAST(ivr_calls.ivr_id AS STRING) AS calls_ivr_id,
        ivr_calls.phone_number AS calls_phone_number,
        ivr_calls.ivr_result AS calls_ivr_result,
        ivr_calls.vdn_label AS calls_vdn_label,
        ivr_calls.start_date AS calls_start_date,
        FORMAT_DATE('%Y%m%d', DATE(ivr_calls.start_date)) AS calls_start_date_id,  
        ivr_calls.end_date AS calls_end_date,
        FORMAT_DATE('%Y%m%d', DATE(ivr_calls.end_date)) AS calls_end_date_id, 
        TIMESTAMP_DIFF(ivr_calls.end_date, ivr_calls.start_date, SECOND) AS calls_total_duration,
        ivr_calls.customer_segment AS calls_customer_segment,
        ivr_calls.ivr_language AS calls_ivr_language,
        ivr_modules.module_sequece AS calls_steps_module,
        CONCAT(CAST(ivr_calls.ivr_id AS STRING), '-', ivr_modules.module_sequece) AS calls_module_aggregation
    FROM keepcoding.ivr_calls
    LEFT JOIN keepcoding.ivr_modules
    ON CAST(ivr_calls.ivr_id AS STRING) = CAST(ivr_modules.ivr_id AS STRING)
),
detailed_modules AS (
    SELECT
        formatted_calls.*,
        ivr_modules.module_sequece AS module_sequence,
        ivr_modules.module_name AS module_name,
        ivr_modules.module_duration AS module_duration,
        ivr_modules.module_result AS module_result
    FROM formatted_calls
    LEFT JOIN keepcoding.ivr_modules
    ON formatted_calls.calls_ivr_id = CAST(ivr_modules.ivr_id AS STRING)
),
detailed_steps AS (
    SELECT
        detailed_modules.*,
        ivr_steps.step_sequence AS step_sequence,
        ivr_steps.step_name AS step_name,
        ivr_steps.step_result AS step_result,
        ivr_steps.step_description_error AS step_description_error,
        ivr_steps.document_type AS document_type,
        ivr_steps.document_identification AS document_identification,
        ivr_steps.customer_phone AS customer_phone,
        ivr_steps.billing_account_id AS billing_account_id
    FROM detailed_modules
    LEFT JOIN keepcoding.ivr_steps
    ON detailed_modules.calls_ivr_id = CAST(ivr_steps.ivr_id AS STRING)
    AND detailed_modules.module_sequence = ivr_steps.module_sequece
)
SELECT *
FROM detailed_steps;
