import mariadb
import sys
import os

def connect():
    '''
        Creates connection to database and returns cursor
    '''
    try:
        conn = mariadb.connect(
            user=os.environ['MYSQL_USER'],
            password=os.environ['MYSQL_PASSWORD'],
            host="localhost",
            port=3306,
            database="prd_demo"

        )
    except mariadb.Error as e:
        print(f"Error connecting to MariaDB Platform: {e}")
        sys.exit(1)

    # Get Cursor

    print("Getting Cursor")

    cur = conn.cursor()
    return cur

def query_table(cur, sql):
    '''
        INPUTS:
            1. mariadb cursor
            2. Valid sql
           
        RETURNS cursor iterable
    '''
    print(f"Attempting to execute SQL")
    try:
        cur.execute(sql)
    except mariadb.Error as e:
        print(f"Error Executing SQL: {e}")
        sys.exit(1)

    print("Query Successful Returning")
    return cur.fetchall()