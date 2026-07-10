#!/usr/bin/env bash
set -euo pipefail

SPIRE_HOME="${SPIRE_HOME:-$HOME/labs/spire}"
TRUST_DOMAIN="${TRUST_DOMAIN:-example.org}"
SERVER_SOCKET="${SERVER_SOCKET:-$SPIRE_HOME/sockets/server.sock}"

USER_UID="$(id -u)"
USER_GID="$(id -g)"

PARENT_ID="${PARENT_ID:-spiffe://$TRUST_DOMAIN/spire/agent/local}"

echo "Using:"
echo "  trust domain:  $TRUST_DOMAIN"
echo "  server socket: $SERVER_SOCKET"
echo "  parent ID:     $PARENT_ID"
echo "  uid selector:  unix:uid:$USER_UID"
echo

spire-server entry create \
  -socketPath "$SERVER_SOCKET" \
  -parentID "$PARENT_ID" \
  -spiffeID "spiffe://$TRUST_DOMAIN/test/python-raw" \
  -selector "unix:uid:$USER_UID"

spire-server entry create \
  -socketPath "$SERVER_SOCKET" \
  -parentID "$PARENT_ID" \
  -spiffeID "spiffe://$TRUST_DOMAIN/test/py-spiffe" \
  -selector "unix:uid:$USER_UID"

spire-server entry create \
  -socketPath "$SERVER_SOCKET" \
  -parentID "$PARENT_ID" \
  -spiffeID "spiffe://$TRUST_DOMAIN/test/gid-$USER_GID" \
  -selector "unix:gid:$USER_GID"

echo
echo "Registered test entries."
echo
echo "Check entries with:"
echo "  spire-server entry show -socketPath $SERVER_SOCKET"
