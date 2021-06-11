#!/bin/bash

docker-compose down
docker-compose up --build -d
docker-compose exec assignartest /init_oltp.sh