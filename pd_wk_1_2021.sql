SELECT 
    QUARTER(date) AS quarter, 
    REPLACE(REGEXP_SUBSTR("Store - Bike", '.*-'), ' -', '') AS store,
    (CASE WHEN REPLACE(REGEXP_SUBSTR("Store - Bike", '-.*'), '- ', '') LIKE 'M%' THEN 'Mountain'
          WHEN REPLACE(REGEXP_SUBSTR("Store - Bike", '-.*'), '- ', '') LIKE 'G%' THEN 'Gravel'
          WHEN REPLACE(REGEXP_SUBSTR("Store - Bike", '-.*'), '- ', '') LIKE 'R%' THEN 'Road' END) AS bike,
    "Order ID",
    "Customer Age",
    "Bike Value",
    "Existing Customer?",
    DAY(date) AS "Day of Month"
    
FROM til_playground.keep.pd_2021_wk1;
