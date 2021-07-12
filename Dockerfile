FROM python:3.9

RUN apt-get update && apt-get install -y cron mariadb-client
RUN groupadd -r bench && useradd -m -r -g bench bench

USER bench
WORKDIR /home/bench

RUN pip3 install frappe-bench
ENV PATH=$PATH:/home/bench/.local/bin

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
RUN bash -i -c "nvm install 14 && npm install -g yarn"
RUN ln -s /home/bench/.nvm/versions/node/v14.*/bin/* /home/bench/.local/bin/

RUN bench init ~/frappe-bench --skip-redis-config-generation
WORKDIR /home/bench/frappe-bench

RUN sed -i \
        -e 's/localhost:13000/redis-cache/' \
        -e 's/localhost:11000/redis-queue/' \
        -e 's/localhost:12000/redis-socketio/' \
        sites/common_site_config.json

COPY ./config/supervisor.conf config/supervisor.conf
COPY ./scripts ./scripts

CMD ["./scripts/start.sh"]
