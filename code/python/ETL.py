import mariadb
import sys

print("Beginning ETL of OTLP to snow flake schema")


# Connect to MariaDB Platform
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

