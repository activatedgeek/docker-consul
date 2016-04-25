#!/usr/bin/env sh

DATACENTER=${DATACENTER:-consul-dc}
LOG_LEVEL=${LOG_LEVEL:-INFO}

DEFAULT_NETWORK_BIND_ADDR=`ip route|awk '/default/ { print $3 }'`

BIND_ADDR=${BIND_ADDR:-$DEFAULT_NETWORK_BIND_ADDR}
HOSTNAME=`hostname`
# only used during server mode, recommended for HA clusters
BOOTSTRAP_EXPECT=${BOOTSTRAP_EXPECT:-1}

if [[ "$1" = "" ]]; then
  echo "[ERROR] Mode argument missing, need 'server' or 'agent'"
  exit 1
fi

# must be server or agent
MODE="$1"

# needs a FQDN or reachable IP address
JOIN_ADDR="$2"

# setup consul server config
cat > /opt/consul/server/conf.d/00consul-server.json <<- EOS
{
  "server": true,
  "node_name": "$HOSTNAME",
  "datacenter": "$DATACENTER",
  "data_dir": "/opt/consul/server",
  "log_level": "$LOG_LEVEL",
  "bind_addr": "$BIND_ADDR",
  "client_addr": "0.0.0.0",
  "ui": true,
  "bootstrap_expect": $BOOTSTRAP_EXPECT,
  "start_join": ["$JOIN_ADDR"]
}
EOS

# setup consul agent config
cat > /opt/consul/agent/conf.d/00consul-agent.json <<- EOA
{
  "node_name": "$HOSTNAME",
  "datacenter": "$DATACENTER",
  "data_dir": "/opt/consul/agent",
  "log_level": "$LOG_LEVEL",
  "bind_addr": "$BIND_ADDR",
  "start_join": ["$JOIN_ADDR"]
}
EOA

if [[ $MODE = "server" ]]; then
  /bin/consul agent -config-dir=/opt/consul/server/conf.d
elif [[ $MODE = "agent" ]]; then
  /bin/consul agent -config-dir=/opt/consul/agent/conf.d
else
  echo "[ERROR] Invalid Mode, need 'server' or 'agent', found $MODE"
  exit 1
fi
