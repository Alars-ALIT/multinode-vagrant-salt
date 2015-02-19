 
 sudo salt '*' state.highstate
 sudo salt '*' grains.item consul-mode
 sudo salt -l debug 'minion-02' grains.append dynamic-roles app

sudo docker run -d -v /var/run/docker.sock:/tmp/docker.sock -h $HOSTNAME progrium/registrator consul://10.1.1.4:8500
sudo docker run -it --entrypoint=/bin/sh progrium/registrator

# Remove all containers
sudo docker rm -f $(sudo docker ps -a -q)

# Execute in running container
docker exec -it $CONTAINER_ID /bin/bash

ssh -N -f -L 8500:localhost:8500 -F minion-01.conf minion-01

curl http://10.1.1.4:8500/v1/catalog/services?dc=dc1

dig @10.1.1.4 -p 8600 busybox-go-webapp.service.consul SRV

consul members -rpc-addr=10.1.1.4:8400