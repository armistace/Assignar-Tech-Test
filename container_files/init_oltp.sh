#!/bin/bash

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MariaDB service startup"
    sleep 5
    mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "status" > /dev/null 2>&1
    RET=$?
done

echo "Building Database based on orders_ddl.sql"

ysql -uroot -p${MYSQL_ROOT_PASSWORD} -u "CREATE DATABASE prd_demo"
mysql -uroot -p${MYSQL_ROOT_PASSWORD}  prd_demo < /code/init_sql/orders_ddl.sql

echo "=> Granting access to all databases for '${MYSQL_USER}'"
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '{$MYSQL_PASSWORD}'"
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION"