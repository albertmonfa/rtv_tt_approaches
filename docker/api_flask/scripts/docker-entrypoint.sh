#!/bin/bash

check_vars() {
    if [ -z "$MYSQL_USER" ];
    then
        echo "Error MYSQL_USER variable is required" >&2
        exit -1
    fi

    if [ -z "$MYSQL_PASS" ];
    then
        echo "Error MYSQL_PASS variable is required" >&2
        exit -1
    fi

    if [ -z "$MYSQL_DB" ];
    then
        echo "Error MYSQL_DB variable is required" >&2
        exit -1
    fi

    if [ -z "$MYSQL_HOST" ];
    then
        echo "Error MYSQL_HOST variable is required" >&2
        exit -1
    fi
}

wait_for_db() {
    if [ -z "$WAIT_FOR_DB" ];
    then
        export WAIT_FOR_DB=No
    fi

    if [ "$WAIT_FOR_DB" == "Yes" ]; then
        wait-for-db $MYSQL_HOST:3306
    fi
}

populate_app() {
    if [ -z "$POPULATE_APP" ];
    then
        export POPULATE_APP=No
    fi

    if [ "$POPULATE_APP" == "Yes" ]; then
        echo "FLASK APP Population starting"
        mysql -u $MYSQL_USER -p$MYSQL_PASS -h $MYSQL_HOST $MYSQL_DB < /app.sql
        echo "MYSQL FLUSH HOSTS"
        mysql -u $MYSQL_USER -p$MYSQL_PASS -h $MYSQL_HOST $MYSQL_DB -e "FLUSH HOSTS;"
    fi
}

# Disclamer: When we are using Docker doesn't make sense to use the loopback
# interface cause the virtual-loopback is not available for binding ports,
# to resolve this issue you should to add a reverse proxy (The Approach_0 use a
# reverse proxy without docker) in the same Docker but that's in my opinion
# a violation of one of the most important best practices in Docker: 
# 1 process per Docker whenever possible.
#
# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
hack_app() {
    sed -i "s/app.run()/app.run(host='0.0.0.0', port=5000)/g" /rtv_tt/app.py
}

check_vars
wait_for_db
populate_app
hack_app
exec "$@"
