{% for app in salt['file.find']('/tmp/deploy', type='f') %}
{% set appPath=app|replace('.tar', '') %}
{% set appName=appPath|replace('/tmp/deploy/', '') %}

{% if 'app' in grains['roles'] or appName in grains['roles']%}

#app-gone:
#  docker.absent:
#    - name: {{ appName }}

app-remove-previous-{{ appName }}:
  cmd.run:
    - name: "docker rm -f $(docker ps -a | grep {{ appName }} | awk {'print $1'})"
    - unless: docker ps -a | grep {{ appName }} | awk {'print $1'}

app-load-{{ appName }}:
  cmd.run:
    - name: docker load < {{ app }}
#  docker.loaded:
#    - name: app-{{ appName }}
#    - source: salt://deploy/app-go-app.tar


app-container-{{ appName }}:
    docker.installed:
      - name: {{ appName }}
      - hostname: {{ appName }}
      - image: {{ appName }}
      - ports:
        - "8080/tcp"
    # - environment:
    #   - SERVICE_TAGS: app
    #   - SERVICE_CHECK_SCRIPT: curl --silent --fail localhost:8888
      - require_in: app

app-{{ appName }}:
  docker.running:
    - container: {{ appName }}
    - port_bindings:
        "8080":
          HostIp: "0.0.0.0"
          HostPort: ""     

{% endif %}
{% endfor %}