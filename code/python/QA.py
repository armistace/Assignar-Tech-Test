from QUERY.QUERY import connect, query_table

print("Querying Database to Answer Test Questions")
print("For Queries run please see:\n\
code/database/invest_sql/investigations.sql")


cur = connect()
break_string = "-----------------"
print(break_string)
print("Question 1.")
q1_sql = "SELECT   COUNT(DISTINCT user_id) as DISTINCT_USER_COUNT\
                  ,COUNT(*) AS ORDER_COUNT\
        FROM prd_star.FCT_ORDER \
        WHERE YEAR(start_date) = '2020'"

q1_results = query_table(cur, q1_sql)

stdout_string = f"There were {q1_results[0][0]} Users Making {q1_results[0][1]} orders in 2020"

print(stdout_string)
print(break_string)

print("Question 2.")
q2_sql = "SELECT p.project_id\
                ,CASE WHEN p.start_date = '0000-00-00' THEN 0 \
                    WHEN p.end_date = '0000-00-00' THEN (CURRENT_DATE() - p.start_date)\
                    ELSE p.end_date - p.start_date\
                 END AS DAY_COUNT\
         from prd_star.DIM_PROJECT p\
         ORDER BY DAY_COUNT desc"

q2_results = query_table(cur, q2_sql)
longest_by = q2_results[0][1] - q2_results[1][1]
stdout_string = f"Project ID {q2_results[0][0]} has been running {q2_results[0][1]} days which is the longest by {longest_by} days"
print(stdout_string)
print(break_string)

print("Question 3.")
q3_sql = 'SELECT client_id\
                ,SUM(GROWTH) / COUNT(QUARTER) AS AVERAGE_GROWTH\
        FROM\
        (\
            SELECT client_id\
                ,QUARTER\
                ,ORDER_SUM\
                ,CASE \
                        WHEN lag(client_id, 1) OVER (ORDER BY client_id, QUARTER) = client_id\
                        THEN 100 * (ORDER_SUM - lag(ORDER_SUM, 1) OVER (ORDER BY client_id, QUARTER)) / lag(ORDER_SUM, 1) OVER (ORDER BY client_id, QUARTER)\
                        ELSE 0\
                        END as GROWTH\
            FROM\
            (SELECT client_id\
                ,CASE \
                        WHEN MONTH(end_date) in (1, 2, 3) THEN "Q1"\
                        WHEN MONTH(end_date) in (4,5,6) THEN "Q2"\
                        WHEN MONTH(end_date) in (7,8,9) THEN "Q3"\
                        ELSE "Q4"\
                    END AS QUARTER\
                    ,SUM(ORDER_COUNT) AS ORDER_SUM\
            FROM prd_star.FCT_ORDER\
            WHERE YEAR(end_date) = "2020"\
            GROUP BY client_id, QUARTER ) growth\
        ) avg_growth\
        GROUP BY client_id\
        ORDER BY AVERAGE_GROWTH desc'

q3_results = query_table(cur, q3_sql)

print(f"Client ID {q3_results[0][0]} Had the largest Quarter on Quarter Growth of {round(q3_results[0][1],2)}% for 2020")
print(f"However noted that Client ID {q3_results[0][0]} May not have been a customer for all 4 quarters")

q3a_sql = 'SELECT   client_id\
                    ,SUM(GROWTH) / COUNT(QUARTER) AS AVERAGE_GROWTH\
            FROM\
            (\
                SELECT client_id\
                    ,QUARTER\
                    ,ORDER_SUM\
                    ,CASE \
                            WHEN lag(client_id, 1) OVER (ORDER BY client_id, QUARTER) = client_id\
                            THEN 100 * (ORDER_SUM - lag(ORDER_SUM, 1) OVER (ORDER BY client_id, QUARTER)) / lag(ORDER_SUM, 1) OVER (ORDER BY client_id, QUARTER)\
                            ELSE 0\
                            END as GROWTH\
                FROM\
                (SELECT client_id\
                    ,CASE \
                            WHEN MONTH(end_date) in (1, 2, 3) THEN "Q1"\
                            WHEN MONTH(end_date) in (4,5,6) THEN "Q2"\
                            WHEN MONTH(end_date) in (7,8,9) THEN "Q3"\
                            ELSE "Q4"\
                        END AS QUARTER\
                        ,SUM(ORDER_COUNT) AS ORDER_SUM\
                FROM prd_star.FCT_ORDER\
                WHERE YEAR(end_date) = "2020"\
                GROUP BY client_id, QUARTER ) growth\
            ) avg_growth\
            GROUP BY client_id\
            HAVING COUNT(QUARTER) = 4\
            ORDER BY AVERAGE_GROWTH desc'

print(f"Applying filter for requirement of 4 quarters Client ID ")

q3a_results = query_table(cur, q3a_sql)

print(f"Assuming 4 Quarters required Client ID {q3a_results[0][0]} Had the largest Quarter on Quarter Growth of {round(q3a_results[0][1],2)}% for 2020")
print(break_string)