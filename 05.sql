WITH tmp_table AS (
    SELECT 
        calls_ivr_id, 
        document_type,
        document_identification,
        ROW_NUMBER() OVER ( 
            PARTITION BY calls_ivr_id 
            ORDER BY 
                CASE 
                    WHEN document_type = 'UNKNOWN' THEN 0 
                    ELSE 1 
                END DESC
        ) AS rn
    FROM 
        `keepcoding.ivr_detail`
)

SELECT 
    calls_ivr_id, 
    document_type, 
    document_identification
FROM 
    tmp_table
WHERE 
    rn = 1
ORDER BY 
    calls_ivr_id;




    --------- EXPLICACIÓN PER MUA -------------
    -- ROW_NUMBER gives a number to each row within the result, this is what will let us choose the first number when requested. It ALWAYS goes with OVER which defines the end of numeration.
    -- PARTITION BY means we are going to group the data by calls_ivr_id, this ensures that an independent numbering is generated for each id, meaning each group of records with the SAME id will have its own sequence of numbers
    -- CASE WHEN ... it's the condition, if the value is UNKNOWN gives value 0 if not, 1 and we set it in DESC order so it shows 1 first. 
    -- RN we only take the first value of each group of calls_ivr_id


    -------------------------------------------------------------

    WITH tmp_table AS (
    SELECT 
        calls_ivr_id,
        MAX(CASE 
            WHEN document_type <> 'UNKNOWN' THEN document_type 
            ELSE NULL 
        END) AS document_type,
        MAX(CASE 
            WHEN document_identification <> 'UNKNOWN' THEN document_identification 
            ELSE NULL 
        END) AS document_identification
    FROM 
        `keepcoding.ivr_detail`
    GROUP BY 
        calls_ivr_id
)

SELECT 
    calls_ivr_id, 
    IFNULL(document_type, 'UNKNOWN') AS document_type,
    IFNULL(document_identification, 'UNKNOWN') AS document_identification
FROM 
    tmp_table
ORDER BY 
    calls_ivr_id;
