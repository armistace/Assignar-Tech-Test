from ETL.ETL import create_connection, create_table, create_project_hiearchy


print("Beginning ETL of prd_demo to prd_star")
print("--CREATE DATABASE--")
cur = create_connection()

print("--ORDER ETL--")
print("Order is a fact table. Table Generated of ffa_order and ffa_order_status\n\
      in this table the 'ORDER_COUNT' field is generated to ease creation of metrics on orders\n")

order_fact_sql = ' CREATE OR REPLACE TABLE prd_star.FCT_ORDER \
                            (SELECT     o.id as order_id, \
                                        o.active, \
                                        o.job_number, \
                                        o.po_number, \
                                        o.client_id, \
                                        o.project_id, \
                                        o.job_description, \
                                        o.start_date, \
                                        o.end_date, \
                                        o.modified_time, \
                                        right(o.status_id, 1) as LATEST_STATUS_ID, \
                                        CASE \
                                            WHEN s.status_name IS NOT NULL THEN s.status_name \
                                            ELSE "UNKNOWN STATUS" \
                                        END as status_name, \
                                        supplier_id, \
                                        user_id, \
                                        1 as ORDER_COUNT \
                                FROM prd_demo.ffa_order o \
                                        LEFT JOIN prd_demo.ffa_order_status s ON right(o.status_id, 1) = s.status_id\
                            )'

create_table(cur, order_fact_sql, "FACT", "prd_star.FCT_ORDER", "prd_demo.ffa_order")

print("--CLIENT ETL--")
print("ffa_client works by itself and is the client dimension for Order and also a Project\n")
client_sql = "CREATE OR REPLACE TABLE prd_star.DIM_CLIENT (SELECT * FROM prd_demo.ffa_client)"
create_table(cur, client_sql, "DIMENSION", "prd_star.DIM_CLIENT", "prd_demo.ffa_client")

print("--PROJECT ETL--")
print("ffa_project like ffa_client works in a similar way as dimension for orders. However, it has hieararchy which needs to be created\n")
project_sql = "CREATE OR REPLACE TABLE prd_star.DIM_PROJECT (SELECT * FROM prd_demo.ffa_project)"
create_table(cur, project_sql, "DIMENSION", "prd_star.DIM_PROJECT", "prd_demo.ffa_project")

print("The Project Hiearchy table is derived from the 'parent_id' field in ffa_project. \n\
        The ETL.py python has a python function that programmatically detects and builds the sql required. \n\
        this in practice would allow for this hiearchy to be of variable size and the etl process would \n\
        simply add Level columns as required\n")


create_table(cur, create_project_hiearchy(cur), "HIEARCHY", "prd_star.H_PROJECT", "prd_demo.ffa_project" )

print("--SUPPLIER ETL--")
print("Suppliers requires a rename of the id field to supplier_id for simply relationship identificantion \n\
    Otherwise acts a simple dimenion for order")
supplier_sql = "CREATE OR REPLACE TABLE prd_star.DIM_SUPPLIER ( \
                SELECT \
                    id as supplier_id,\
                    city,\
                    postcode,\
                    state,\
                    comments,\
                    external_id,\
                    active,\
                    date_added,\
                    date_modified,\
                    modified_time\
                from prd_demo.ffa_suppliers\
                )"
create_table(cur, supplier_sql, "DIMENSION", "prd_star.DIM_SUPPLIER", "prd_demo.ffa_suppliers")

print("--USER ETL--")
print("Finally the User table, again acts a dimension table for orders. \n\
    This joins Usertype and Employment type as these are specific to users and \n\
        it makes little sense to split them out for the context of this database")

user_sql = "CREATE OR REPLACE TABLE prd_star.DIM_USER (\
            SELECT \
                    u.user_id,\
                    u.ut_id as user_type_id,\
                    ut.label as user_type,\
                    u.suburb,\
                    u.state,\
                    u.postcode,\
                    u.employment_type as employment_type_id,\
                    et.name as employment_type_name,\
                    u.active,\
                    u.modified_time,\
                    u.comments,\
                    u.app_version,\
                    u.device_os,\
                    u.device_os_version,\
                    u.app_timezone,\
                    u.last_logged_in\
                FROM prd_demo.ffa_user u\
                LEFT JOIN prd_demo.ffa_user_type ut ON u.ut_id = ut.ut_id\
                LEFT JOIN prd_demo.ffa_employment_type et on u.employment_type = et.employment_type\
                )"
create_table(cur, user_sql, "DIMENSION", "prd_star.DIM_USER", "prd_demo.ffa_user_type")

print("In an ideal world all the dimension tables and order tables would of course be SCD_Type2. However, in the interests of\n\
        time I have chosen to simply convert to a simple star schema based of the data provided and not implement a SCD_Type2 Loader\n\
        to get data into prd_star")

