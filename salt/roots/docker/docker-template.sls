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

{% if not override_installed is defined %}
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
        - SERVICE_TAGS: version:{{ container_tag }}        
        #- SERVICE_CHECK_SCRIPT: curl --fail localhost:$(sudo docker port {{ container_name }} | sed 's/.*[0-9.]*://')
        #- SERVICE_CHECK_SCRIPT: echo $(sudo docker port go-app | sed 's/.*[0-9.]*://')
{% endif %}
{% if not override_running is defined %}
{{ container_name }}:
  docker.running:
    - hostname: {{ container_hostname }}
    - container: {{ container_name }}
    - publish_all_ports: True    
{% endif %}