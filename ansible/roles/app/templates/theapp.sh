#!/bin/bash
source /etc/theapp.conf
export MYSQL_USER=$MYSQL_USER
export MYSQL_DB=$MYSQL_DB
export MYSQL_HOST=$MYSQL_HOST
MYSQL_PASS=$MYSQL_PASS /usr/bin/python /usr/local/theapp/app.py &
echo $! > /var/run/theapp.pid
