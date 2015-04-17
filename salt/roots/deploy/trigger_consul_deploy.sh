#!/bin/bash

: ${LOGFILE:=/tmp/consul_handler.log}
: ${BRIDGE_IP:=10.1.1.3}
: ${CONSUL_HTTP_PORT:=8500}
: ${DEBUG:=1}

IMAGE_NAME=$1
CONTAINER_NAME=$2

[[ "TRACE" ]] && set +x

debug(){
  [[ "$DEBUG" ]] && echo "[DEBUG] $*" # >> $LOGFILE
}

define(){ IFS='\n' read -r -d '' ${1} || true; }

main() {
define DEPLOY_DESC << EOF
{
  "imageName": "$IMAGE_NAME",
  "containerName": "$CONTAINER_NAME"
}
EOF

echo "Storing:"
echo "$DEPLOY_DESC"
echo ""
echo "at http://$BRIDGE_IP:$CONSUL_HTTP_PORT/v1/kv/apps/$IMAGE_NAME"

curl -o /dev/null --silent -X PUT -d "$DEPLOY_DESC" "http://$BRIDGE_IP:$CONSUL_HTTP_PORT/v1/kv/apps/$IMAGE_NAME"
echo "done!"

echo "Triggering event: consul event -http-addr=$BRIDGE_IP:$CONSUL_HTTP_PORT -name deploy $IMAGE_NAME"

consul event -http-addr=$BRIDGE_IP:$CONSUL_HTTP_PORT -name deploy $IMAGE_NAME
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
