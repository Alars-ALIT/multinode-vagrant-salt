{% set container_name = 'logspout' %}
{% set container_tag = 'latest' %}
{% set container_hostname = grains['host'] %}
{% set container_command = 'syslog://' + pillar['rsyslog']['endpoint'] %}
{% set image_name = 'gliderlabs/logspout' %}
{% set override_running = True %}
{% include 'docker/docker-template.sls' %}

logspout:
  docker.running:
    - container: logspout
    - hostname: {{ container_hostname }}
    - port_bindings:
        "8000":
          HostIp: "0.0.0.0"
          HostPort: "8000"     
    - binds:
        "/var/run/docker.sock":
          bind: "/tmp/docker.sock"
          ro: false  