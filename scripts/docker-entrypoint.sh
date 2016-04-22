#!/usr/bin/env sh

DATACENTER=${DATACENTER:-consul-dc}
LOG_LEVEL=${LOG_LEVEL:-INFO}
HOSTNAME=`hostname`
# only used during server mode
BOOTSTRAP_EXPECT=${BOOTSTRAP_EXPECT:-1}

MODE="$1"
JOIN_ADDR="$2"

if [[ "$1" = "" ]]; then
  echo "[ERROR] Mode argument missing, need 'server' or 'agent'"
fi

if [[ "$2" = "" ]]; then
  echo '[ERROR] Peer node missing, specify a valid FQDN or IP address'
fi

# setup consul server config
cat > /opt/consul/server/conf.d/00consul-server.json <<- EOS
{
  "server": true,
  "node_name": "$HOSTNAME",
  "datacenter": "$DATACENTER",
  "data_dir": "/opt/consul/server",
  "log_level": "$LOG_LEVEL",
  "bind_addr": "0.0.0.0",
  "client_addr": "0.0.0.0",
  "ui": true,
  "bootstrap_expect": $BOOTSTRAP_EXPECT,
  "start_join": ["127.0.0.1"]
}
EOS

# setup consul agent config
cat > /opt/consul/agent/conf.d/00consul-agent.json <<- EOA
{
  "node_name": "$HOSTNAME",
  "datacenter": "$DATACENTER",
  "data_dir": "/opt/consul/agent",
  "log_level": "$LOG_LEVEL",
  "bind_addr": "0.0.0.0",
  "start_join": ["127.0.0.1"]
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
