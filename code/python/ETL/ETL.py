import mariadb
import sys

print("Beginning ETL of OTLP to snow flake schema")


# Connect to MariaDB Platform
def create_connection():
    '''
        Creates connection to database and returns cursor
    '''
    try:
        conn = mariadb.connect(
            user="assignar_test",
            password="assignar_test_pass",
            host="localhost",
            port=3306,
            database="prd_demo"

        )
    except mariadb.Error as e:
        print(f"Error connecting to MariaDB Platform: {e}")
        sys.exit(1)

    # Get Cursor

    print("Creating Database")

    cur = conn.cursor()

    create_db = "CREATE SCHEMA IF NOT EXISTS `prd_star`"
    try:
        cur.execute(create_db)

        cur.execute("SHOW DATABASES")
    except mariadb.Error as e:
        print(f"Error Creating Database: {e}")
        sys.exit(1)

    databaselist = cur.fetchall()

    print("Showing Databases:")
    for database in databaselist:
        if database[0][:3] == "prd":
            print(database)
    
    return cur

def create_table(cur, sql, table_type, dest_table, origin_table):
    '''
        INPUTS:
            1. mariadb cursor
            2. Valid Create Table sql
            3. Type of table being created (FACT, DIMENION, HUB, LINK)
            4. destination table (including destination schema)
            5. origin table (including origin schema)
        RETURNS True if successful, will error and halt execution if unsucessful
    '''
    print(f"Generating {table_type} Table from {origin_table}")
    try:
        cur.execute(sql)
    except mariadb.Error as e:
        print(f"Error Creating {dest_table} {table_type} Table: {e}")
        sys.exit(1)

    print(f"Creation Successful Testing Select of {dest_table}")

    try:
        test_sql = f"SELECT  * FROM {dest_table}"                               
        cur.execute(test_sql)
    except mariadb.Error as e:
        print(f"Issue with {dest_table} {table_type} Table, \
                            Cannot Select Because of: {e}")
        sys.exit(1)

    list = cur.fetchall()

    print("Showing First Row")
    print(list[0])
    print(f"Creation of {dest_table} successful")
    return True


