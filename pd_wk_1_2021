//-- 1. Sales by Brand and Type 

SELECT
    REPLACE(ARRAY_TO_STRING(REGEXP_SUBSTR_ALL(model, '[A-Z]'), ','), ',', '') AS brand,
    bike_type,
    SUM(quantity) AS quantity_ordered, 
    SUM(quantity * value_per_bike) AS order_value,
    ROUND(AVG(value_per_bike), 1) AS avg_bike_value_sold_per_brand_type
FROM til_playground.preppin_data_inputs.pd2021_wk02_bike_sales
GROUP BY 1, 2;

//-- 2. Sales by Brand and Store

SELECT
    REPLACE(ARRAY_TO_STRING(REGEXP_SUBSTR_ALL(model, '[A-Z]'), ','), ',', '') AS brand,
    store, 
    SUM(quantity * value_per_bike) AS total_order_value,
    SUM(quantity) AS total_quantity_sold,
    ROUND(AVG(DATEDIFF('day', TO_DATE(order_date, 'DD/MM/YYYY'), TO_DATE(shipping_date, 'DD/MM/YYYY'))), 1) AS avg_days_to_ship
FROM til_playground.preppin_data_inputs.pd2021_wk02_bike_sales
WHERE brand IN ('KONA', 'SPEC', 'BROM')
GROUP BY 1, 2;
