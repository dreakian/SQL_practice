WITH data AS
(
    SELECT 
        *,
        '01' AS month_part
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_JANUARY

    UNION ALL

    SELECT 
        *,
        '02' AS month_part
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_FEBRUARY

    UNION ALL

    SELECT 
        *,
        '03' AS month_part
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_MARCH

    UNION ALL 

    SELECT 
        *,
        '04' AS month_part
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_APRIL

    UNION ALL

    SELECT 
        *, 
        '05' AS month_part
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_MAY

    UNION ALL

    SELECT 
        *, 
        '06' AS month_part
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_JUNE

    UNION ALL
        
    SELECT 
        *, 
        '07' AS month_part
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_JULY

    UNION ALL

    SELECT 
        *, 
        '08' AS month_part
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_AUGUST

    UNION ALL

    SELECT 
        *, 
        '09' AS month_part
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_SEPTEMBER

    UNION ALL

    SELECT 
        *, 
        '10' AS month_part
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_OCTOBER

    UNION ALL

    SELECT 
        *, 
        '11' AS month_part
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_NOVEMBER

    UNION ALL

    SELECT 
        *, 
        '12' AS month_part
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_DECEMBER
),

dob AS
(
    SELECT
        ID AS date_of_birth_ID, 
        VALUE AS "Original_Date of Birth",
        (CASE 
            WHEN SUBSTR(VALUE, 1, 2) NOT IN ('10', '11', '12') THEN CONCAT('0', LEFT(VALUE, 1)) //-- month is 01 to 09
            WHEN SUBSTR(VALUE, 1, 2) IN ('10', '11', '12') THEN SUBSTR(VALUE, 1, 2) //-- month is between 10 to 12
            END) AS "dob_month",
        (CASE 
            WHEN "dob_month" IN ('10', '11', '12') AND REPLACE(SUBSTR(VALUE, 4, 2), '/', '') < 10 THEN CONCAT('0', SUBSTR(VALUE, 4, 1)) //-- when month is between 10 to 12, then day is 01 to 09 -- 10/09
            WHEN TO_NUMBER("dob_month") < 10 AND REPLACE(SUBSTR(VALUE, 3, 2), '/', '') > 10 THEN SUBSTR(VALUE, 3, 2) //-- when month is between 01 to 09, then day is greater than 10 -- 01/31
            WHEN TO_NUMBER("dob_month") < 10 AND REPLACE(SUBSTR(VALUE, 3, 1), '/') < 10 THEN CONCAT('0', SUBSTR(VALUE, 3, 1)) //-- when month is between 01 to 09, then day is 01 to 09 -- 01/01
            WHEN "dob_month" IN ('10', '11', '12') AND REPLACE(SUBSTR(VALUE, 4, 2), '/', '') >= 10 THEN SUBSTR(VALUE, 4, 2) //-- when month is between 01 to 10, then day is greater than or equal to 10 -- 01/10 or 01/31
            END) AS "dob_day",
        RIGHT(VALUE, 4) AS "dob_year",
        CONCAT("dob_day", '/', "dob_month", '/', "dob_year") AS "Date of Birth"
    FROM data
    WHERE DEMOGRAPHIC LIKE 'Date of Birth'
),

ethn AS 
(
    SELECT 
        ID AS ethn_ID,
        VALUE AS "Ethnicity"
    FROM data
    WHERE DEMOGRAPHIC LIKE 'Ethnicity'
),

acc_type AS
(
    SELECT 
        ID as acc_type_ID,
        VALUE AS "Account Type"
    FROM data
    WHERE DEMOGRAPHIC LIKE 'Account Type'
),

final_data AS 
(
    SELECT *
    FROM data
    LEFT JOIN dob
    ON data.ID = date_of_birth_ID
    LEFT JOIN ethn
    ON data.ID = ethn_ID
    LEFT JOIN acc_type
    ON data.ID = acc_type_ID
)

SELECT 
    DISTINCT(ID), 
    REGEXP_REPLACE(CONCAT(JOINING_DAY, '/', month_part, '/', 2023), '^[1-9]\/', CONCAT('0', JOINING_DAY, '/')) AS "Joining Date", 
    "Account Type",
    "Date of Birth",
    "Ethnicity"
FROM final_data;
