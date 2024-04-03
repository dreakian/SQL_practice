WITH data AS
(
    SELECT *
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK22_ATTENDANCE_FIGURES AS af
    INNER JOIN TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK22_STUDENT_TEST_SCORES AS sts
    USING(student_name)
),

cleaned_data AS 
(
    SELECT 
    
        (CASE WHEN ROUND(data.attendance_percentage, 1) < 0.7 THEN 'Low Attendance'
              WHEN ROUND(data.attendance_percentage, 1) >= 0.9 THEN 'High Attendance'
              ELSE 'Medium Attendance' END) AS "Attendance Flag",
                   
        REPLACE(REGEXP_SUBSTR(data.student_name, '.*_'), '_', '') AS "First Name",
        
        REPLACE(REGEXP_SUBSTR(data.student_name, '_.*'), '_', '') AS "Surname",
    
        ROUND(data.attendance_percentage, 1) AS "attendance_percentage",
        
        student_id AS "student_id",
    
        (CASE WHEN data.subject LIKE 'E%' THEN 'English'
              WHEN data.subject LIKE 'S%' THEN 'Science'
              ELSE data.subject END) AS "subject",
        
        test_score AS "test_score",
        
        ROUND(test_score) AS "TestScoreInteger"
    
    FROM data 
)

SELECT *
FROM cleaned_data;
