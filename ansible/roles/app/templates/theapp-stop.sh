#!/bin/bash
kill -9 $(cat /var/run/theapp.pid)
echo "Killed $(cat /var/run/theapp.pid)"
