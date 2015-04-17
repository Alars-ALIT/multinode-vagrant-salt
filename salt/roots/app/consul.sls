{% set container_name = 'consul' %}
{% set container_tag = 'latest' %}
{% set container_hostname = grains['host'] %}
{% set host_ip = salt['network.interfaces']()['eth1']['inet'][0]['address'] %}
{% set container_command = '-advertise ' + host_ip + ' -join 10.1.1.4 -encrypt ' + pillar['consul']['encrypt'] %}
{% set image_name = 'progrium/consul' %}
{% set override_running = True %}
{% include 'docker/docker-template.sls' %}

consul:
  docker.running:
    - container: consul
    - hostname: {{ container_hostname }}
    - port_bindings:
        "8300/tpc":
          HostIp: "{{ host_ip }}"
          HostPort: "8300"
        "8301/tpc":
          HostIp: "{{ host_ip }}"
          HostPort: "8301"
        "8301/udp":
          HostIp: "{{ host_ip }}"
          HostPort: "8301" 
        "8302/tpc":
          HostIp: "{{ host_ip }}"
          HostPort: "8302"
        "8302/udp":
          HostIp: "{{ host_ip }}"
          HostPort: "8302"   
        "8400/tpc":
          HostIp: "{{ host_ip }}"
          HostPort: "8400"  
        "8500/tpc":
          HostIp: "{{ host_ip }}"
          HostPort: "8500"
        "53/udp":
          HostIp: "{{ host_ip }}"
          HostPort: "53"
    - binds:
        "/var/run/docker.sock":
          bind: "/tmp/docker.sock"
          ro: false
        "/mnt":
          bind: "/data"
          ro: false  

# eval docker run --name consul -h $HOSTNAME      -p 10.1.1.3:8300:8300   -p 10.1.1.3:8301:8301   -p 10.1.1.3:8301:8301/udp       -p 10.1.1.3:8302:8302   -p 10.1.1.3:8302:8302/udp        -p 10.1.1.3:8400:8400   -p 10.1.1.3:8500:8500   -p 172.17.42.1:53:53/udp        -it     progrium/consul  -advertise 10.1.1.3 -join 10.1.1.5 -encrypt BFAWhXJx5JHIKUQ2DblnFA==          