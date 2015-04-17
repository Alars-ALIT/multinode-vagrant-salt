#!/bin/bash

IMAGE_NAME=$1
CONTAINER_NAME=$2
VERSION=${3:-latest} 
REGISTRY=${4:-registry.hub.docker.com}
CONSUL_URL=${5:-consul://10.1.1.3:8500/swarm}
SWARM_MASTER=${6:-tcp://localhost:8333}

export LIST=$(docker run -d swarm list consul://10.1.1.3:8500/swarm)
export REMOTE_DOCKER_HOSTS=$(docker logs $LIST)

# Pull latest/version
for host in $REMOTE_DOCKER_HOSTS; do
	echo "Pulling $REGISTRY/$IMAGE_NAME:$VERSION on $host"
	# TODO: make asynch
	sudo docker -H $host pull $REGISTRY/$IMAGE_NAME:$VERSION
done


# Remove containers with same image on all nodes
echo "Removing old $IMAGE_NAME containers"
sudo docker -H $SWARM_MASTER rm -f $(docker -H $SWARM_MASTER ps | grep $IMAGE_NAME | awk '{print $1}')

# Run 
sudo docker -H $SWARM_MASTER run -d --name $CONTAINER_NAME -P $IMAGE_NAME

exit 0