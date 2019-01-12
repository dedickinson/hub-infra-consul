#!/bin/bash

EXTIF=$(docker run --rm --net=host hub-debug-general extif.sh)
DNS_RECURSOR=$(systemd-resolve --status $EXTIF | grep '^[[:blank:]]*DNS Servers' | xargs | cut -d':' -f2 | xargs)

SERVER=consul.service.consul

if [ "$1" != "" ]
then
    SERVER=$1
fi

echo Looking up $SERVER

docker run --dns=$DNS_RECURSOR -it hub-debug-general sh -c "dig $SERVER"
