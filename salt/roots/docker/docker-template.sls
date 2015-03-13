{{ container_name }}-image:
  docker.pulled:
    - name: {{ image_name }}:{{ container_tag }}
    - force: True
    - require_in: {{ container_name }}-container

{{ container_name }}-gone:
  docker.absent:
    - name: {{ container_name }}

#{{ container_name }}-remove-previous:
#  cmd.run:
#    - name: "docker rm -f $(docker ps -a | grep {{ image_name }} | awk {'print $1'})"
#    - unless: docker ps -a | grep {{ image_name }} | awk {'print $1'}

{{ container_name }}-container:
    docker.installed:
      - name: {{ container_name }}
      - hostname: {{ container_hostname }}
      - image: {{ image_name }}
      {% if container_command is defined %}- command: {{ container_command }}{% endif %}
      
      - require_in: {{ container_name }}
      - environment:
        - SERVICE_ID: {{ container_hostname }}:{{ container_tag }}
        - SERVICE_NAME: {{ container_name }}  
{% if not override_running is defined %}
{{ container_name }}:
  docker.running:
    - hostname: {{ container_hostname }}
    - container: {{ container_name }}
    - publish_all_ports: True    
{% endif %}