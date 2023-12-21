WITH data AS
(
    SELECT 
        REGEXP_SUBSTR(transaction_code, '([A-Z]{2,3})') AS bank,
        MONTHNAME(TO_DATE(transaction_date, 'DD/MM/YYYY HH:MI:SS')) AS transaction_date,
        SUM(value) AS value 
    FROM til_playground.preppin_data_inputs.pd2023_wk01
    GROUP BY 1, 2
), 

bank_rank_per_month AS
(
SELECT 
    *,
    RANK() OVER (PARTITION BY transaction_date ORDER BY SUM(value) DESC) AS "Bank Rank per Month"
FROM data
GROUP BY 1, 2, 3
),

avg_transaction_value_per_rank AS 
(
SELECT 
    "Bank Rank per Month",
    AVG(value) AS "Avg Transaction Value per Rank"
FROM bank_rank_per_month
GROUP BY 1
),

avg_rank_per_bank AS
(
SELECT
    bank,
    AVG("Bank Rank per Month") AS "Avg Rank per Bank"
FROM bank_rank_per_month
GROUP BY 1
)

SELECT
    *
FROM bank_rank_per_month
INNER JOIN avg_transaction_value_per_rank
USING("Bank Rank per Month")
INNER JOIN avg_rank_per_bank
USING (bank);
