docker-compose down
docker-compose up --build -d
docker-compose exec assignartest /init_oltp.sh
docker-compose exec assignartest python3 /code/python/test.py