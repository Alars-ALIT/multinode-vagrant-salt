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
        - "/tmp:/tmp2"
      - ports:
        - "8080/tcp"
      - require_in: app

app:
  docker.running:
    - container: app
    - port_bindings:
        "8080":
          HostIp: "0.0.0.0"
          HostPort: "8888"
    - environment:
      - SERVICE_TAGS: test-app   
    - binds:
        "/tmp":
          bind: "/tmp2"
          ro: false

registrator-image:
  docker.pulled:
    - name: progrium/registrator

registrator-container:
    docker.installed:
      - name: registrator
      - hostname: {{ grains['host'] }}
      - image: progrium/registrator
      - command: "consul://{{ salt['network.interfaces']()['eth1']['inet'][0]['address'] }}:8500"
      - volumes:
        - "/var/run/docker.sock:/tmp/docker.sock"      
      - require_in: registrator

registrator:
  docker.running:
    - container: registrator    
    - binds:
        "/var/run/docker.sock":
          bind: "/tmp/docker.sock"
          ro: false

#registrator:
#  cmd.run:
#    - name: "docker run -d -v /var/run/docker.sock:/tmp/docker.sock --name registrator -h registrator progrium/registrator consul://10.1.1.4:8500" 
#    - unless: docker inspect  --format '{{test}}' registrator | grep $(docker images --no-trunc | grep "progrium/registrator" | awk '{ print $3 }')
