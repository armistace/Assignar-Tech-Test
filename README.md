# Andrew Ridgway Assignar Test

##2 Ways to install

Please install [Docker Desktop](https://www.docker.com/get-started)
Also Please install [GIT](https://git-scm.com/downloads)

Once installed

run
```git clone https://github.com/armistace/Assignar-Tech-Test.git && cd Assignar-Tech-Test```

Then on Windows in Powershell Run
```.\windows_exec.ps1```

on linux run
```chmod 700 linux_exec.sh && linux_exec.sh```

### What does this do

These files will build a docker container based on the latest [Mariadb Image](https://hub.docker.com/_/mariadb)

It will then install python (This can take a while)

Build a database called prd_demo and execute /code/database/init_sql/orders_ddl.sql

This sql will create the shell database and load the data from
/code/database/raw_data/

This mirrors the concept of a transactional database that I wouldn't normally build

Please note initial build of the container can take up to 15 minutes

Python will then take over
It creates the prd_star database which converts the provided otlp database into a star schema for analytical querying

The SQL for the ETL can be found in code/database/etl_query/etl_load.sql

The python being executed by the container can be found in code/python/ETL/etl.py and /code/python/main_etl.py

Once the star schema DB is created it will then execute the investigations
The investigations SQL can be found in code/database/invest_sql/investigation.sql

The python being executed can be found in /code/python/QUERY/QUERY.py
and code/python/QA.py

The terminal the code is run in should display the outcome

To query the database please connect to localhost port 3306 and log in with
user: assignar_test
pass: assignar_test_pass


###### NOTES
###### _I haven't played with alot of GIS data and struggled with the 'point' data type in ffa_project I have changed it to VARCHAR(1000) to capture the hex value in the csv and that can hopefully be converted later_




