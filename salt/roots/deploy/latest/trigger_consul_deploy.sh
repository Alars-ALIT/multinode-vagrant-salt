#!/bin/bash

# ./trigger_consul_deploy.sh 'mast.*' alars/busybox-go-webapp go-app

# ./trigger_consul_deploy.sh 'mast.*' progrium/registrator registrator 'docker run -d -v /var/run/docker.sock:/tmp/docker.sock --name registrator progrium/registrator consul://10.1.1.3:8500'

# ./trigger_consul_deploy.sh 'mast.*' gliderlabs/logspout logspout 'docker run -d -P -v /var/run/docker.sock:/tmp/docker.sock --name logspout gliderlabs/logspout'

: ${LOGFILE:=/tmp/consul_handler.log}
: ${BRIDGE_IP:=10.1.1.3}
: ${CONSUL_HTTP_PORT:=8500}
: ${DEBUG:=1}

FILTER=$1
IMAGE_NAME=$2
CONTAINER_NAME=$3
RUN_CMD=$4
echo $RUN_CMD
: ${RUN_CMD:="docker run -d -P --name $CONTAINER_NAME $IMAGE_NAME"}

[[ "TRACE" ]] && set +x

debug(){
  [[ "$DEBUG" ]] && echo "[DEBUG] $*" # >> $LOGFILE
}

define(){ IFS='\n' read -r -d '' ${1} || true; }

main() {
define DEPLOY_DESC << EOF
{
  "imageName": "$IMAGE_NAME",
  "containerName": "$CONTAINER_NAME",
  "runCmd": "$RUN_CMD"
}
EOF

  #'imageName': '$IMAGE_NAME',
  #'containerName': '$CONTAINER_NAME',
  #'runCmd': 'docker run'

echo "Storing:"
echo "$DEPLOY_DESC"
echo ""
echo "at http://$BRIDGE_IP:$CONSUL_HTTP_PORT/v1/kv/apps/$IMAGE_NAME"

curl -o /dev/null --silent -X PUT -d "$DEPLOY_DESC" "http://$BRIDGE_IP:$CONSUL_HTTP_PORT/v1/kv/apps/$IMAGE_NAME"
echo "done!"

echo "Triggering event: consul event -http-addr=$BRIDGE_IP:$CONSUL_HTTP_PORT -node '$FILTER' -name deploy $IMAGE_NAME"

consul event -http-addr=$BRIDGE_IP:$CONSUL_HTTP_PORT -node "$FILTER" -name deploy $IMAGE_NAME
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
