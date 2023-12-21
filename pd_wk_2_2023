WITH data AS 

(
    SELECT *
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.pd2023_wk02_swift_codes AS s_code
    LEFT JOIN TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.pd2023_wk02_transactions AS trans
    ON s_code.bank = trans.bank
)

SELECT 
    data.transaction_id, 
    CONCAT(
        (CASE WHEN data.swift_code IN ('DSBX', 'HLFX', 'LOYD', 'NWBK', 'BARC', 'ABBY', 'HBUK') THEN 'GB' END),
        data.check_digits,
        data.swift_code,
        REPLACE(data.sort_code, '-', ''),
        data.account_number) AS IBAN
       
FROM data;
