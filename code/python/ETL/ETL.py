import mariadb
import sys
import os

def create_connection():
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
    print("\n\n")
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
    print(f"Creation of {dest_table} successful\n\n")
    return True

def create_project_hiearchy(cur, select_string=None, 
                                from_join_string=None, recur=0, 
                                id_count=0, where_ids = None):
    '''
        recursively generates the project hiearchy
        it does this by requerying with a where statement on parent_id's
        initial call should be empty function will recursively call itself 
        with required info
    '''
    

    if recur==0:
        sql_count = "SELECT COUNT(*) as ID_COUNT \
               FROM prd_demo.ffa_project \
                WHERE parent_id != 0"
        sql_ids = "SELECT project_id \
                   FROM prd_demo.ffa_project\
                   WHERE parent_id !=0"

        #GET COUNT
        cur.execute(sql_count)
        id_counts = cur.fetchall()[0][0]
        
        #GET ID's to where
        cur.execute(sql_ids)
        sql_ids_fetch = cur.fetchall()
        sql_ids = ""
        for sql_id in sql_ids_fetch:
            sql_ids = sql_ids + f"{sql_id[0]}, "

        sql_ids = sql_ids[:-2]
        
        if id_counts == 0:
            #theortically if this happens only want 0 level hiearchy
            return_sql = "CREATE OR REPLACE TABLE prd_star.prd_star.H_PROJECT (\
                            SELECT project_id as project_L0\
                            FROM prd_demo.ffa_project\
                        )"
            return return_sql
        else:
            recur_select_string = "SELECT l0.project_id as project_L0"
            recur_from_join_string = "FROM prd_demo.ffa_project l0"
            recur_num = 1
            
            return create_project_hiearchy(cur, recur_select_string, recur_from_join_string,
                                    recur_num, id_counts, sql_ids ).strip()
    else:

        if id_count == 0:
            return_sql = f"CREATE OR REPLACE TABLE prd_star.H_PROJECT ({select_string} {from_join_string})"
            return return_sql.strip()
        else:
            sql_count = f"SELECT COUNT(*) as ID_COUNT \
                FROM (  SELECT project_id, parent_id \
                        FROM prd_demo.ffa_project\
                        WHERE parent_id in ({where_ids})\
                    ) l{str(recur)}  \
                    WHERE parent_id != 0"
            sql_ids = f"SELECT project_id \
                    FROM(  SELECT project_id, parent_id \
                            FROM prd_demo.ffa_project\
                            WHERE parent_id in ({where_ids})\
                    ) l{str(recur)}\
                    WHERE parent_id != 0"
            
            cur.execute(sql_count)
            id_counts = cur.fetchall()[0][0]
                  
            cur.execute(sql_ids)
            sql_ids_fetch = cur.fetchall()
            sql_ids = ""
            for sql_id in sql_ids_fetch:
                sql_ids = sql_ids + f"{sql_id[0]}, "

            sql_ids = sql_ids[:-2]

            recur_select_string = f"{select_string} \
                                    ,CASE \
                                        WHEN l{str(recur-1)}.parent_id = 0 THEN 0 \
                                        ELSE l{str(recur)}.project_id \
                                    END AS project_L{str(recur)}"
            recur_from_join_string = f"{from_join_string} \
                                       LEFT JOIN \
                                           (SELECT project_id, parent_id \
                                            FROM prd_demo.ffa_project\
                                            WHERE parent_id in ({where_ids})\
                                        ) l{str(recur)} \
                                        ON l{str(recur-1)}.parent_id = l{str(recur)}.project_id"
            recur_num = recur + 1
            return create_project_hiearchy(cur, recur_select_string, recur_from_join_string,
                                    recur_num, id_counts, sql_ids ).strip()






