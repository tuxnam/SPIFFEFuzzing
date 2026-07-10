#!/usr/bin/env bash
set -euo pipefail

SPIRE_HOME="${SPIRE_HOME:-/opt/spire}"
TRUST_DOMAIN="${TRUST_DOMAIN:-example.org}"

mkdir -p \
  "$SPIRE_HOME/conf/server" \
  "$SPIRE_HOME/conf/agent" \
  "$SPIRE_HOME/data/server" \
  "$SPIRE_HOME/data/agent" \
  "$SPIRE_HOME/sockets"

cat > "$SPIRE_HOME/conf/server/server.conf" <<EOF
server {
  bind_address = "127.0.0.1"
  bind_port = "8081"
  trust_domain = "$TRUST_DOMAIN"
  data_dir = "$SPIRE_HOME/data/server"
  log_level = "DEBUG"
  socket_path = "$SPIRE_HOME/sockets/server.sock"
}

plugins {
  DataStore "sql" {
    plugin_data {
      database_type = "sqlite3"
      connection_string = "$SPIRE_HOME/data/server/datastore.sqlite3"
    }
  }

  NodeAttestor "join_token" {
    plugin_data {}
  }

  KeyManager "disk" {
    plugin_data {
      keys_path = "$SPIRE_HOME/data/server/keys.json"
    }
  }
}
EOF

cat > "$SPIRE_HOME/conf/agent/agent.conf" <<EOF
agent {
  data_dir = "$SPIRE_HOME/data/agent"
  log_level = "DEBUG"
  server_address = "127.0.0.1"
  server_port = "8081"
  socket_path = "$SPIRE_HOME/sockets/agent.sock"
  trust_bundle_path = "$SPIRE_HOME/conf/agent/bootstrap.crt"
  trust_domain = "$TRUST_DOMAIN"
}

plugins {
  NodeAttestor "join_token" {
    plugin_data {}
  }

  KeyManager "disk" {
    plugin_data {
      directory = "$SPIRE_HOME/data/agent"
    }
  }

  WorkloadAttestor "unix" {
    plugin_data {}
  }
}
EOF

echo "Created SPIRE config in: $SPIRE_HOME"
echo
echo "Start server:"
echo "  spire-server run -config $SPIRE_HOME/conf/server/server.conf"
echo
echo "In another terminal, bootstrap the agent:"
echo "  spire-server bundle show -socketPath $SPIRE_HOME/sockets/server.sock -format spiffe > $SPIRE_HOME/conf/agent/bootstrap.crt"
echo "  spire-server token generate -socketPath $SPIRE_HOME/sockets/server.sock -spiffeID spiffe://$TRUST_DOMAIN/spire/agent/local"
echo
echo "Then start agent:"
echo "  spire-agent run -config $SPIRE_HOME/conf/agent/agent.conf -joinToken <TOKEN>"
echo
echo "Workload API socket:"
echo "  export SPIFFE_ENDPOINT_SOCKET=unix://$SPIRE_HOME/sockets/agent.sock"
