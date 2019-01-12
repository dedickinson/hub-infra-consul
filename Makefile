
.PHONY: default build run stop start get_gossip_key logs clean

IMAGE_NAME = hub-infra-consul
CONTAINER_NAME = consul
CONSUL_DATA_VOLUME = consul-data

default: build

build:
	docker volume create $(CONSUL_DATA_VOLUME)
	docker build -t $(IMAGE_NAME) .

run: build
	./consul-server.sh $(CONTAINER_NAME) $(IMAGE_NAME) $(CONSUL_DATA_VOLUME)

stop:
	docker stop $(CONTAINER_NAME) || /bin/true

start:
	docker start $(CONTAINER_NAME) || /bin/true

get_gossip_key:
	docker exec -it $(CONTAINER_NAME) sh -c 'cat /consul/data/serf/local.keyring'

logs:
	docker logs $(CONTAINER_NAME) -f

clean: stop
	docker rm $(CONTAINER_NAME) || /bin/true
	docker volume rm $(CONSUL_DATA_VOLUME) || /bin/true
