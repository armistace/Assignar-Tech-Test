--Investigation SQL on prd_star

--Question 1--
SELECT   COUNT(DISTINCT user_id) as DISTINCT_USER_COUNT
        ,COUNT(*) AS ORDER_COUNT
FROM prd_star.FCT_ORDER
WHERE YEAR(start_date) = '2020'

--Question 2-- 
--(Select first record)--
SELECT p.project_id
      ,p.external_id
      ,CASE WHEN p.start_date = '0000-00-00' THEN 0
            WHEN p.end_date = '0000-00-00' THEN (CURRENT_DATE() - p.start_date)
            ELSE p.end_date - p.start_date
       END AS DAY_COUNT
from prd_star.DIM_PROJECT p
ORDER BY DAY_COUNT desc


--Question 3--
--Select first Record--
SELECT client_id
        ,SUM(GROWTH) / COUNT(QUARTER) AS AVERAGE_GROWTH
FROM
(
    SELECT client_id
        ,QUARTER
        ,ORDER_SUM
        ,CASE 
                WHEN lag(client_id, 1) OVER (ORDER BY client_id, QUARTER) = client_id
                THEN 100 * (ORDER_SUM - lag(ORDER_SUM, 1) OVER (ORDER BY client_id, QUARTER)) / lag(ORDER_SUM, 1) OVER (ORDER BY client_id, QUARTER)
                ELSE 0
                END as GROWTH
    FROM
    (SELECT client_id
        ,CASE 
                WHEN MONTH(end_date) in (1, 2, 3) THEN "Q1"
                WHEN MONTH(end_date) in (4,5,6) THEN "Q2"
                WHEN MONTH(end_date) in (7,8,9) THEN "Q3"
                ELSE "Q4"
            END AS QUARTER
            ,SUM(ORDER_COUNT) AS ORDER_SUM
    FROM prd_star.FCT_ORDER
    WHERE YEAR(end_date) = '2020'
    GROUP BY client_id, QUARTER ) growth
) avg_growth
GROUP BY client_id
ORDER BY AVERAGE_GROWTH desc

--check of result client_id = 171--
--Question is light... do they need to have completed all 4 quarters?
SELECT client_id
        ,QUARTER
        ,ORDER_SUM
        ,CASE 
                WHEN lag(client_id, 1) OVER (ORDER BY client_id, QUARTER) = client_id
                THEN 100 * (ORDER_SUM - lag(ORDER_SUM, 1) OVER (ORDER BY client_id, QUARTER)) / lag(ORDER_SUM, 1) OVER (ORDER BY client_id, QUARTER)
                ELSE 0
                END as GROWTH
    FROM
    (SELECT client_id
        ,CASE 
                WHEN MONTH(end_date) in (1, 2, 3) THEN "Q1"
                WHEN MONTH(end_date) in (4,5,6) THEN "Q2"
                WHEN MONTH(end_date) in (7,8,9) THEN "Q3"
                ELSE "Q4"
            END AS QUARTER
            ,SUM(ORDER_COUNT) AS ORDER_SUM
    FROM prd_star.FCT_ORDER
    WHERE YEAR(end_date) = '2020' and client_id = 171
    GROUP BY client_id, QUARTER ) growth

--Assuming need to have been around from 4 quarters

SELECT client_id
        ,SUM(GROWTH) / COUNT(QUARTER) AS AVERAGE_GROWTH
FROM
(
    SELECT client_id
        ,QUARTER
        ,ORDER_SUM
        ,CASE 
                WHEN lag(client_id, 1) OVER (ORDER BY client_id, QUARTER) = client_id
                THEN 100 * (ORDER_SUM - lag(ORDER_SUM, 1) OVER (ORDER BY client_id, QUARTER)) / lag(ORDER_SUM, 1) OVER (ORDER BY client_id, QUARTER)
                ELSE 0
                END as GROWTH
    FROM
    (SELECT client_id
        ,CASE 
                WHEN MONTH(end_date) in (1, 2, 3) THEN "Q1"
                WHEN MONTH(end_date) in (4,5,6) THEN "Q2"
                WHEN MONTH(end_date) in (7,8,9) THEN "Q3"
                ELSE "Q4"
            END AS QUARTER
            ,SUM(ORDER_COUNT) AS ORDER_SUM
    FROM prd_star.FCT_ORDER
    WHERE YEAR(end_date) = '2020'
    GROUP BY client_id, QUARTER ) growth
) avg_growth
GROUP BY client_id
HAVING COUNT(QUARTER) = 4
ORDER BY AVERAGE_GROWTH desc

