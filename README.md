# Hub - Infrastructure - Consul

You'll need to grab [hub-debug-general](https://github.com/dedickinson/hub-debug-general) 
and build the image there as it's used here. 

You can then just run `make run` to get a Consul server up and running.

Test the DNS: 

    ./test-dns.sh
    ./test-dns.sh www.docker.com

## Handy commands

To check the running Consul environment, set the `CONSUL_HOST` environment variable:

    CONSUL_HOST=$(docker run --rm --net=host hub-debug-general extip.sh)

This will be used in the CLI and API examples

### CLI

Version check:

    docker run -it consul sh -c "CONSUL_HTTP_ADDR=127.0.0.1:8500 consul --version"

List nodes:

    docker run -it consul sh -c "CONSUL_HTTP_ADDR=$CONSUL_HOST:8500 consul catalog nodes"

### API

Refer to the [API documentation](https://www.consul.io/api/index.html) for details.

Check nodes:

    curl http://$CONSUL_HOST:8500/v1/catalog/nodes

Check the leader status

    curl http://$CONSUL_HOST:8500/v1/status/leader

## References

* [Console sample documentation](https://docs.docker.com/samples/library/consul/) on Docker Hub.