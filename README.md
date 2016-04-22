# docker-consul

| [![Build Status](https://travis-ci.org/activatedgeek/docker-consul.svg?branch=master)](https://travis-ci.org/activatedgeek/docker-consul) | [![](https://badge.imagelayers.io/activatedgeek/consul.svg)](https://hub.docker.com/r/activatedgeek/consul) |
|:-:|:-:|

A Consul Docker image based on Alpine Linux. It can be used to run in both
server mode and agent mode.

The container contains the following:
* `Consul` (0.6.4)

## Images
* `latest`, `0.1`, `0.1.0` ([Dockerfile](./Dockerfile))

## Usage
Pull the docker image from Docker hub as:
```
$ docker pull activatedgeek/consul
```
By default, this will pull the latest image.

The `Consul` configuration files are generated on the fly as the container runs.
For a complete documentation on `Consul` configuration parameters, check
[Consul Agent](https://www.consul.io/docs/agent/options.html).

The image supports the following environment variables:
* `DATACENTER`: name of the consul datacenter (default: `consul-dc`) (equivalent of `-dc` CLI flag)
* `LOG_LEVEL`: level of log verbosity (default: `INFO`) (equivalent of `-log-level` CLI flag)
* `BIND_ADDR`: network interface to bind to (default: `0.0.0.0`) (equivalent of `-bind` CLI flag)
* `BOOTSTRAP_EXPECT`: number of nodes to declare healthy quorum (default: `1`) (equivalent of `-bootstrap-expect` CLI flag)

The run command looks like:
```
$ docker run -d -P activatedgeek/consul:latest MODE JOIN_ADDR
```

The two positional arguments are:
* `MODE`: mode of the `Consul` node, can take values `server` or `agent`
* `JOIN_ADDR`: a valid FQDN or IP address of a peer node whose cluster to join,
when starting the first node, this can be `127.0.0.1`.

## Build
To build the latest image from source, run
```
$ make latest
```