 
 sudo salt '*' state.highstate
 sudo salt '*' grains.item consul-mode
 sudo salt -l debug 'minion-02' grains.append dynamic-roles app

 sudo docker run -d -v /var/run/docker.sock:/tmp/docker.sock -h $HOSTNAME progrium/registrator consul://10.1.1.4:8500
