FROM python:3.9

RUN apt-get update && apt-get install -y cron redis-server supervisor mariadb-client
RUN pip3 install frappe-bench

RUN groupadd -r bench && useradd -m -r -g bench bench
RUN chown -R bench:bench /opt
USER bench

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
RUN bash -i -c "nvm install 14 && npm install -g yarn"

USER root
RUN ln -s /home/bench/.nvm/versions/node/v14.*/bin/* /usr/bin/

USER bench
RUN bench init /opt/frappe-bench
WORKDIR /opt/frappe-bench

USER root

COPY ./scripts ./scripts
CMD ["./scripts/start-bench.sh"]
