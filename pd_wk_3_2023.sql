WITH trans AS
(
    SELECT 
        REGEXP_SUBSTR(transaction_code, '([A-Z]{2,3})') AS "bank", 
        (CASE WHEN online_or_in_person = 1 THEN 'Online'
         WHEN online_or_in_person = 2 THEN 'In-Person' END) AS "online_or_in_person",
        SUM(value) AS "value", 
        QUARTER(TO_DATE(transaction_date, 'DD/MM/YYYY HH:MI:SS')) AS "trans_quarter",
        ROW_NUMBER() OVER (ORDER BY "trans_quarter") AS "trans_row_num"
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK01
    WHERE "bank" LIKE 'DSB'
    GROUP BY "online_or_in_person", "trans_quarter", "bank"
),

targs AS 
(
    SELECT 
        online_or_in_person,
        quarterly_targets,
        (CASE WHEN Quarter = 'Q1' THEN 1
         WHEN Quarter = 'Q2' THEN 2
         WHEN Quarter = 'Q3' THEN 3
         WHEN Quarter = 'Q4' THEN 4 END) AS "targs_quarter",
         ROW_NUMBER() OVER (ORDER BY "targs_quarter") AS "targs_row_num"
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.pd2023_wk03_targets
    UNPIVOT(quarterly_targets FOR QUARTER IN (Q1, Q2, Q3, Q4))
    GROUP BY online_or_in_person, "targs_quarter", quarterly_targets
)

SELECT 
    "online_or_in_person" AS trans_online_or_in_person,
    "trans_quarter" AS trans_quarter,
    "value", 
    quarterly_targets,
    "value" - quarterly_targets AS variance
FROM trans
INNER JOIN targs
ON "trans_quarter" = "targs_quarter" AND "trans_row_num" = "targs_row_num";
