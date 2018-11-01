FROM alpine:3.8

ENV APP_ROOT /rtv_tt
ENV APP_FILE https://raw.githubusercontent.com/wuakitv/sysadmin-challenge/master/app.py
ENV APP_DB https://raw.githubusercontent.com/wuakitv/sysadmin-challenge/master/app.sql

WORKDIR /

EXPOSE 5000/tcp

COPY docker/api_flask/conf/requirements.txt /tmp/
COPY docker/api_flask/scripts/docker-entrypoint.sh /bin/docker-entrypoint
COPY docker/api_flask/scripts/wait-for-db.sh /bin/wait-for-db

RUN apk update && apk --no-cache add bash libffi-dev musl-dev gcc openssl-dev \
    dumb-init wget python py-pip python-dev mysql-client && \
    mkdir -p ${APP_ROOT} && \
    wget ${APP_FILE} -O ${APP_ROOT}/app.py && \
    wget ${APP_DB} -O /app.sql && \
    pip install -r /tmp/requirements.txt && \
    chmod +x /bin/docker-entrypoint && \
    chmod +x /bin/wait-for-db && \
    apk del wget py-pip python-dev libffi-dev musl-dev gcc openssl-dev \
    ncurses-terminfo-base ncurses-terminfo ncurses sqlite-libs && \
    rm -rf /tmp/requirements.txt

ENTRYPOINT ["/bin/docker-entrypoint"]
CMD ["/usr/bin/dumb-init", "/usr/bin/python", "/rtv_tt/app.py"]
