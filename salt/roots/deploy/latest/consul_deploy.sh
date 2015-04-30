#!/bin/bash

#https://github.com/sequenceiq/docker-consul-watch-plugn/blob/1.7.0-consul/consul-event-handler.sh
#consul watch -http-addr=10.1.1.3:8500 -type event -name deploy ./consul_deploy.sh

: ${LOGFILE:=/tmp/consul_handler.log}
: ${BRIDGE_IP:=10.1.1.3}
: ${CONSUL_HTTP_PORT:=8500}
: ${DEBUG:=1}
DEPLOY_KEY=$1


[[ "TRACE" ]] && set +x

debug(){
  [[ "$DEBUG" ]] && echo "[DEBUG] $*" # >> $LOGFILE
}

debugJson(){
  [[ "$DEBUG" ]] && echo "$*" | jq .  # >> $LOGFILE
}

get_field() {
  declare json=$1
  declare field="$2"

  echo $json|jq ".$field" -r
}

__envVars() {
  declare eventId=$1
  declare ltime=$2
  declare version=$3

  echo "EVENT_ID=$eventId \
    EVENT_LTIME=$ltime \
    EVENT_VERSION=$version \
    CONSUL_HOST=$BRIDGE_IP \
    CONSUL_HTTP_PORT=$CONSUL_HTTP_PORT \
    LOGFILE=$LOGFILE"
}
__getHostName() {
  while : ; do
    hostname=$(hostname -f)
    [[ $? == 0 ]] && break
    [[ $? != 0 ]] && sleep 5
  done
  echo $hostname
}

deploy(){
  declare containerName="$1"
  declare imageName="$2"
  declare runCmd="$3"		
  
  echo "Pulling $imageName"
  docker pull $imageName
  
  echo "Removing any existing containger with name $containerName"
  docker rm -f $containerName  > /dev/null 2>&1 || true
  
  echo "Starting container with: $runCmd"
  $runCmd
}

process_json() {
  	
  while read json; do
    #debugJson $json

    ltime=$(get_field $json LTime)
    event=$(get_field $json Name)
    id=$(get_field $json ID)
    payload=$(get_field $json Payload | base64 -d)
    ltime=$(get_field $json LTime)
    version=$(get_field $json Version)
    #eventtype=$(echo $payload | cut -d" " -f 1)
    #eventSpecPayload=$(echo $payload | cut -d" " -f 2-)
    cmdEnvVars=$(__envVars $id $ltime $version)

    isProcessed=$(curl -o /dev/null --silent --write-out '%{http_code}\n' "http://$BRIDGE_IP:$CONSUL_HTTP_PORT/v1/kv/events/$id/$(__getHostName)")
    if [ $isProcessed -eq 200 ]; then
      debug "$id already processed"
      continue
    fi

    debug "event=$event, id=$id, payload=$payload"
    if [[ -z $id ]]; then
      debug "eventid is missing, skip processing"
      continue
    fi

    DEPLOY_DESC=$(curl --silent "http://$BRIDGE_IP:$CONSUL_HTTP_PORT/v1/kv/apps/$payload")
    #debugJson $DEPLOY_DESC
    DEPLOY_DESC=$(echo $DEPLOY_DESC | jq .[0] | jq ".Value" -r | base64 -d | jq '.' -c)
    echo "Got deployment descriptor:"
    echo ""
    debugJson $DEPLOY_DESC
    
    containerName=$(echo $DEPLOY_DESC | jq ".containerName" -r)
    imageName=$(echo $DEPLOY_DESC | jq ".imageName" -r)
    runCmd=$(echo $DEPLOY_DESC | jq ".runCmd" -r)

    echo "Run command: $runCmd"

    echo "About to deploy $containerName $imageName"
    deploy $containerName $imageName "$runCmd"

    if [ $? -eq 0 ]; then
      debug "$id finished successfully"
      #curl -o /dev/null --silent -X PUT -d 'FINISHED' "http://$BRIDGE_IP:$CONSUL_HTTP_PORT/v1/kv/events/$id/$(__getHostName)"    
    fi
  done
}

main() {
  while read array; do
  	[[ -n $array ]] && echo $array | jq '.[length - 1]' -c | process_json
  	#[[ -n $array ]] && echo $array | jq '.[]' -c | process_json
  done
}
[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
