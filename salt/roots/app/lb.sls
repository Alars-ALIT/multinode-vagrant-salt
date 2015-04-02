{% set container_name = 'lb' %}
{% set container_tag = 'latest' %}
{% set image_name = 'asteris/haproxy-consul' %}
{% set container_hostname = 'lb-' + grains['host'] %}
{% set override_installed = True %}
{% set override_running = True %}
{% include 'docker/docker-template.sls' %}

/tmp/consul-template/haproxy.tmpl:
  file.managed:
    - source: salt://app/haproxy.tmpl
    - makedirs: True
    - mode: 755
    
lb-container:
    docker.installed:
      - name: {{ container_name }}
      - hostname: {{ container_hostname }}
      - image: {{ image_name }}
      - require_in: {{ container_name }}
      - environment:
        - SERVICE_ID: {{ container_hostname }}:{{ container_tag }}
        - SERVICE_NAME: {{ container_name }}  
        - SERVICE_TAGS: {{ container_tag }}
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
    - binds:
        "/tmp/consul-template/":
          bind: "/consul-template/template.d"
          ro: false  
    - environment:
      - CONSUL_CONNECT: {{ salt['network.interfaces']()['eth1']['inet'][0]['address'] }}:8500
      - HAPROXY_DOMAIN: test.com 
