WITH data AS
(
    SELECT * 
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK23_RESULTS AS r
    INNER JOIN TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK23_STUDENT_INFO AS si
    ON r.student_id = si.x_student_id
),

averages AS
(
    SELECT 
        ROUND(AVG(english), 1) AS "avg_english_score",
        ROUND(AVG(psychology), 1) AS "avg_psychology_score",
        ROUND(AVG(economics), 1) AS "avg_economics_score",
        class
    FROM data
    GROUP BY class
),

min_averages AS
(
    SELECT 
        MIN("avg_english_score") AS "lowest_avg_english_score", 
        MIN("avg_psychology_score") AS "lowest_avg_psychology_score",
        MIN("avg_economics_score") AS "lowest_avg_economics_score"
    FROM averages
),

pivoted_data AS
(
    SELECT *
    FROM min_averages
    UNPIVOT(grade FOR subject IN ("lowest_avg_english_score", "lowest_avg_psychology_score", "lowest_avg_economics_score"))
)

SELECT 
    (CASE WHEN "avg_english_score" = grade THEN 'English'
          WHEN "avg_psychology_score" = grade THEN 'Psychology'
          WHEN "avg_economics_score" = grade THEN 'Economics'
          END) AS "Subject",
    grade, 
    class
FROM averages
INNER JOIN pivoted_data
WHERE grade IN ("avg_english_score", "avg_psychology_score", "avg_economics_score");
