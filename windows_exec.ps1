docker-compose down
docker-compose up --build -d
docker-compose exec assignartest dos2unix /init_oltp.sh
docker-compose exec assignartest /bin/bash /init_oltp.sh
docker-compose exec assignartest python3 /code/python/main_etl.py
docker-compose exec assignartest python3 /code/python/QA.py