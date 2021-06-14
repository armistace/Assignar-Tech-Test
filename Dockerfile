FROM mariadb:latest as DATABASE

# FROM python:latest as PYTHON


# Install extra system packages
RUN apt-get update && apt-get install -y python3 python3-pip libmariadb-dev

RUN echo 'copying Code'
ADD code/ /code/

# Install python requirements
RUN pip3 install --no-cache-dir -r /code/requirements.txt

RUN echo 'copying init sql'
ADD code/database/init_sql/ /code/init_sql
WORKDIR /code/init_sql

RUN echo 'copying init'
ADD container_files/ /
RUN chmod 700 /init_oltp.sh



