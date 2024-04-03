WITH unpivoted_data AS
(
SELECT 
    customer_id,
    REPLACE(REGEXP_SUBSTR(category, '.*___'), '___', '') AS category,
    REPLACE(REGEXP_SUBSTR(category, '___.*'), '___', '') AS questions,
    response
FROM til_playground.preppin_data_inputs.pd2023_wk06_dsb_customer_survey
UNPIVOT(response FOR category IN (mobile_app___ease_of_use, mobile_app___ease_of_access, mobile_app___navigation, mobile_app___likelihood_to_recommend, online_interface___ease_of_use, online_interface___ease_of_access, online_interface___navigation, online_interface___likelihood_to_recommend))
),

aggregated_data AS
(
    SELECT 
        category,
        customer_id,
        AVG(response) AS avg_response
    FROM unpivoted_data
    GROUP BY 1, 2
),

mobile_app AS
(

SELECT
    (CASE WHEN category LIKE UPPER('%mobile_app%') THEN avg_response END) AS mobile_app,
    customer_id,
    COUNT(mobile_app) AS c_ma  
FROM aggregated_data
GROUP BY 1, 2
HAVING c_ma = 1
),

online_interface AS
(

SELECT
    (CASE WHEN category LIKE UPPER('%online_interface%') THEN avg_response END) AS online_interface,
    customer_id,
    COUNT(online_interface) AS c_oi  
FROM aggregated_data
GROUP BY 1, 2
HAVING c_oi = 1
),

final_data AS
(

SELECT 

    online_interface - mobile_app AS difference_in_average_rating, 
    
    customer_id,
    
    (CASE WHEN difference_in_average_rating <= -2 THEN 'Mobile App Superfan'
          WHEN difference_in_average_rating <= -1 THEN 'Mobile App Fan'
          WHEN difference_in_average_rating >= 2 THEN 'Online Interface Superfan'
          WHEN difference_in_average_rating >= 1 THEN 'Online Interface Fan'
    ELSE 'Neutral' END) AS preference

FROM mobile_app
INNER JOIN online_interface
USING(customer_id)
)

SELECT 
    preference,
    ROUND((COUNT(preference) / (SELECT COUNT(*) FROM final_data) * 100), 1) AS "% of Total"
FROM final_data
GROUP BY 1;
