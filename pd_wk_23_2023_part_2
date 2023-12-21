WITH data AS 
(
SELECT
    full_name,
    class, 
    NTILE(4) OVER (ORDER BY english DESC) AS quartile_english,
    NTILE(4) OVER (ORDER BY economics DESC) AS quartile_economics,
    NTILE(4) OVER (ORDER BY psychology DESC) AS quartile_psychology
    
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK23_RESULTS AS r
INNER JOIN TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK23_STUDENT_INFO AS si
ON r.student_id = si.x_student_id
),

unpivoted_data AS
(

SELECT 
    *,
    (CASE WHEN quartile = 4 AND TRIM(class) IN ('9A', '9B') THEN 1 ELSE 0 END) AS flag
FROM data
UNPIVOT(quartile FOR subject IN (quartile_english, quartile_economics, quartile_psychology))
INNER JOIN TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK24_TILES AS t
ON data.quartile = t.number
),

mapped_data AS
(
SELECT 
    full_name,
    class, 
    MAX(CASE WHEN subject LIKE UPPER('%quartile_english%') THEN REPLACE(quartile, quartile, range) END) AS english,
    MAX(CASE WHEN subject LIKE UPPER('%quartile_economics%') THEN REPLACE(quartile, quartile, range) END) AS economics,
    MAX(CASE WHEN subject LIKE UPPER('%quartile_psychology%') THEN REPLACE(quartile, quartile, range) END) AS psychology,
    SUM(flag) AS flag
FROM unpivoted_data
GROUP BY full_name, class
HAVING SUM(flag) >= 2
)

SELECT
    full_name, 
    class, 
    english, 
    economics,
    psychology, 
    REPLACE(flag, flag, 'Yes') AS flag
FROM mapped_data;
