# docker-consul

| [![Build Status](https://travis-ci.org/activatedgeek/docker-consul.svg?branch=master)](https://travis-ci.org/activatedgeek/docker-consul) | [![](https://imagelayers.io/badge/activatedgeek/consul:latest.svg)](https://imagelayers.io/?images=activatedgeek/consul:latest 'Get your own badge on imagelayers.io') |
|:-:|:-:|

A Consul Docker image based on Alpine Linux. It can be used to run in both
server mode and agent mode.

The container contains the following:
* `Consul` (0.6.4)

## Images
* `latest`, `0.2`, `0.2.0` ([Dockerfile](./Dockerfile))
* `0.1`, `0.1.5`

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
* `NETWORK_INTERFACE`: network interface to bind to (default: `eth0`) (this is used by `BIND_ADDR`)
* `BIND_ADDR`: network interface to bind to (default: `0.0.0.0`) (equivalent of `-bind` CLI flag) (this overrides `NETWORK_INTERFACE`)
* `BOOTSTRAP_EXPECT`: number of nodes to declare healthy quorum (default: `1`) (equivalent of `-bootstrap-expect` CLI flag)

The run command looks like:
```
$ docker run -d -P activatedgeek/consul:latest MODE JOIN_ADDR
```

The two positional arguments are:
* `MODE`: mode of the `Consul` node, can take values `server` or `agent`
* `JOIN_ADDR`: a valid FQDN or IP address of a peer node whose cluster to join,
when starting the first node, this argument can be skipped.

## Build
To build the latest image from source, run
```
$ make latest
```
