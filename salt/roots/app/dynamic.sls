{% for app in salt['file.find']('/tmp/apps', name='Dockerfile', type='f') %}
{% set appPath=app|replace('/Dockerfile', '') %}
{% set appName=appPath|replace('/tmp/apps/', '') %}

app-build-{{ appName }}:
  docker.built:
    - name: app-{{ appName }}
    - path: {{ appPath }}

app-container-{{ appName }}:
    docker.installed:
      - name: app-{{ appName }}
      - hostname: app-{{ appName }}
      - image: app-{{ appName }}
      - ports:
        - "8080/tcp"
     # - environment:
     #   - SERVICE_TAGS: app
     #   - SERVICE_CHECK_SCRIPT: curl --silent --fail localhost:8888
      - require_in: app

app-{{ appName }}:
  docker.running:
    - container: app-{{ appName }}
    - port_bindings:
        "8080":
          HostIp: "0.0.0.0"
          HostPort: ""     

{% endfor %}