{% set container_name = 'registrator' %}
{% set container_tag = 'latest' %}
{% set container_hostname = grains['host'] %}
{% set container_command = 'consul://' + salt['network.interfaces']()['eth1']['inet'][0]['address'] + ':8500' %}
{% set image_name = 'progrium/registrator' %}
{% set override_running = True %}
{% include 'docker/docker-template.sls' %}

{{ container_name }}:
  docker.running:
    - container: registrator    
    - volumes:
      - "/var/run/docker.sock:/tmp/docker.sock"      
    - binds:
        "/var/run/docker.sock":
          bind: "/tmp/docker.sock"
          ro: false