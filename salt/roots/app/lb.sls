{% set container_name = 'lb' %}
{% set container_tag = 'latest' %}
{% set image_name = 'asteris/haproxy-consul' %}
{% set container_hostname = 'lb-' + grains['host'] %}
{% set override_installed = True %}
{% set override_running = True %}
{% include 'docker/docker-template.sls' %}

lb-container:
    docker.installed:
      - name: {{ container_name }}
      - hostname: {{ container_hostname }}
      - image: {{ image_name }}
      - require_in: {{ container_name }}
      - environment:
        - SERVICE_ID: {{ container_hostname }}:{{ container_tag }}
        - SERVICE_NAME: {{ container_name }}  
        - CONSUL_CONNECT: {{ salt['network.interfaces']()['eth1']['inet'][0]['address'] }}:8500
        - HAPROXY_DOMAIN: test.com
      - ports:
        - "80/tcp"

lb:
  docker.running:
    - container: lb
    - hostname: {{ container_hostname }}
    - port_bindings:
        "80":
          HostIp: ""
          HostPort: "80"
    - environment:
      - CONSUL_CONNECT: {{ salt['network.interfaces']()['eth1']['inet'][0]['address'] }}:8500
      - HAPROXY_DOMAIN: test.com 
