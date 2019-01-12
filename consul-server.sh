#!/bin/bash

CONTAINER_NAME=$1
IMAGE_NAME=$2
DATA_VOLUME=$3

EXTIP=$(docker run --rm --net=host hub-debug-general extip.sh)
EXTIF=$(docker run --rm --net=host hub-debug-general extif.sh)
DNS_RECURSOR=$(systemd-resolve --status $EXTIF | grep '^[[:blank:]]*DNS Servers' | xargs | cut -d':' -f2 | xargs)
CONSUL_KEY=$(docker run --rm consul keygen)

echo Starting Consul Server
echo Binding to: $EXTIP on $EXTIF 
echo Using DNS: $DNS_RECURSOR

docker run -d --net=host --name $CONTAINER_NAME \
	-v $DATA_VOLUME:/consul/data \
	-e 'CONSUL_ALLOW_PRIVILEGED_PORTS=' \
	$IMAGE_NAME agent -server \
		-bind=$EXTIP \
		-client=$EXTIP \
		-dns-port=53 \
		-recursor=$DNS_RECURSOR \
		-bootstrap-expect=1 \
		-http-port=8500 \
		-encrypt $CONSUL_KEY
