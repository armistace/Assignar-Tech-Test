# Andrew Ridgway Assignar Test

Please install [Docker Desktop](https://www.docker.com/get-started)

Once installed

### WINDOWS

Open Powershell

run windows_exec.ps1 in powershell window

### LINUX

Open a bash terminal

run linux_exec.sh

These files will build a docker container based on the latest [Mariadb Image](https://hub.docker.com/_/mariadb)

Build a database called prd_demo and execute /code/database/init_sql/orders_ddl.sql

This sql will create the shell database and load the data from
/code/database/raw_data/

### TODO
- Create OLAP database based on otlp data
- Design Queries bsed on test documents
- Display results using a simple flask app

###### NOTES
###### _I haven't played with alot of GIS data and struggled with the 'point' data type in ffa_project I have changed it to VARCHAR(1000) to capture the hex value in the csv and that can hopefully be converted later_




