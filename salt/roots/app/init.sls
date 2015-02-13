{% set name           = 'busybox-go-webapp'   %}
{% set registryname   = 'alars' %}
{% set tag            = 'latest' %}
{% set containerid    = salt['grains.get']('id') %}
{% set test    		  = '{{.Image}}' %}

app-image:
  docker.pulled:
    - name: alars/busybox-go-webapp
    - require_in: app-container

app-container:
   docker.installed:
     - name: app
     - hostname: app
     - image: alars/busybox-go-webapp
     - volumes:
       - "/tmp": "/tmp"
     - require_in: app

app:
  docker.running:
    - container: app
    - port_bindings:
        "8080":
          HostIp: ""
          HostPort: "8080"
    - publish_all_ports: True

registrator-image:
  docker.pulled:
    - name: progrium/registrator

#registrator-container:
#  docker.installed:
#    - name: registrator
#    - hostname: registrator
#    - command: ["consul://10.1.1.4:8500"]
#    - image: progrium/registrator
#    - kwargs: "-v /tmp:/tmp"
#    - volumes:
#      - /var/run/docker.sock:/tmp/docker.sock
#    - volumes:
#      - /var/run/docker.sock:
#        bind: /tmp/docker.sock
#        ro: true      
    - require_in: registrator

registrator:
  cmd.run:
    - name: "docker run -d -v /var/run/docker.sock:/tmp/docker.sock --name registrator -h registrator progrium/registrator consul://10.1.1.4:8500" 
    - unless: docker inspect  --format '{{test}}' registrator | grep $(docker images --no-trunc | grep "progrium/registrator" | awk '{ print $3 }')
