FROM mariadb:latest

# Install extra system packages
RUN curl -sL https://deb.nodesource.com/setup | bash - && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN echo 'copying Code'
ADD code/ /code/



RUN echo 'copying init sql'
ADD code/database/init_sql/ /code/init_sql
WORKDIR /code/init_sql

RUN echo 'copying init'
ADD container_files/ /
RUN chmod 700 /init_oltp.sh
