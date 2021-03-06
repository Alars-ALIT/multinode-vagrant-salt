 
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

### Gitrecieve
sudo groupadd deployer
sudo usermod -a -G deployer git
sudo echo "%deployer ALL=NOPASSWD: ALL" > /etc/sudoers

# Add cert 
cat /home/alarsson/.ssh/id_rsa.pub | vagrant ssh minion-01 -c "sudo gitreceive upload-key git" 

# Add remote
git remote add demo  git@10.1.1.4:example

### Deploy
sudo salt '*' cp.get_dir salt://build/app /tmp/apps
sudo tail -f cat /var/log/upstart/drone.log

### Ngrok
wget "https://api.equinox.io/1/Applications/ap_pJSFC5wQYkAyI0FIVwKYs9h1hW/Updates/Asset/ngrok.zip?os=linux&arch=386&channel=stable" > ngrok.zip

cat .ngrok
inspect_addr: "0.0.0.0:4040"
auth_token: "DpWfwdTgA97PwQ5sRl9R"

 ./ngrok -subdomain=alars -log=stdout 80 > /dev/null &

 docker build -t alars - < busybox-go-webapp.tar.gz
 docker save alars > alars.tar

 docker run -d -e APP_NAME=tepp -v /tmp/test:/tmp/build go14


### Docker swarm 

# On all
docker run -d swarm join --addr=10.1.1.3:2375 consul://10.1.1.3:8500/swarm

# On one
docker run -d -p -name swarm-manager 8333:2375 swarm manage consul://10.1.1.3:8500/swarm

docker -H tcp://localhost:8333 run -d --name www -p 80:8080 alars/busybox-go-webapp

docker -H tcp://localhost:8333 ps
 
 