#!/bin/bash

export CLIENTS=${CLIENTS:="100"}
export BIND_PORT=${BIND_PORT:="80"}
export BIND_ADDR=${BIND_ADDR:="0.0.0.0"}
export ACCESS_CONTROL_ORIGIN=${ACCESS_CONTROL_ORIGIN:="*"}
export LOG_LEVEL=${LOG_LEVEL:="3"}

checks=("LOCATION" "EMAIL" "ADMIN_USERNAME" "ADMIN_PASSWORD" "DOMAIN" "FALLBACK_MOUNT" "FALLBACK_NAME" "FALLBACK_USERNAME" "FALLBACK_PASSWORD" "PRIMARY_MOUNT" "PRIMARY_NAME" "PRIMARY_USERNAME" "PRIMARY_PASSWORD" "FALLBACK_MOUNT")

for c in ${checks[@]}; do
    output=$(eval "echo \"\$$c\"")
    if [[ -z "$output" ]]; then
        echo "$c is required"
        exit 1
    fi
done

envsubst < /etc/icecast.xml.tmpl > /etc/icecast.xml

chown icecast:icecast /etc/icecast.xml
chmod 640 /etc/icecast.xml

icecast -c /etc/icecast.xml
