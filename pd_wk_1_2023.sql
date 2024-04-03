// Output 1: Total Values of Transactions by each bank

SELECT 
    REPLACE(LEFT(transaction_code, 3), '-', '') AS "bank", 
    SUM(VALUE) AS "total_value"
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK01
GROUP BY "bank";

// Output 2: Total Values by Bank, Day of the Week and Type of Transaction

SELECT 
    REGEXP_SUBSTR(transaction_code, '([A-Z]{2,3})') AS "bank",
    DAYNAME(TO_DATE(transaction_date, 'DD/MM/YYYY HH:MI:SS')) AS "transaction_date", 
    (CASE WHEN online_or_in_person = 1 THEN 'Online'
     WHEN online_or_in_person = 2 THEN 'In-Person' END) AS "online or in-person",
    SUM(value) AS "total_value"
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK01
GROUP BY "bank", "online or in-person", "transaction_date";

// Output 3: Total Values by Bank and Customer Code

SELECT 
    REGEXP_SUBSTR(transaction_code, '([A-Z]{2,3})') AS "bank",
    customer_code, 
    SUM(value) AS "total_value"
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK01
GROUP BY "bank", customer_code;
