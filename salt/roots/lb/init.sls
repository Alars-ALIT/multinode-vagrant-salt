/etc/haproxy/haproxy.cfg:
  file.managed:
    - source: salt://lb/haproxy.cfg.jinja
    - template: jinja
    - makedirs: True
    - mode: 755    

lb-image:
  docker.pulled:
    - name: alars/docker-alpine-haproxy:latest
    - force: True
    - require_in: lb-container

lb-gone:
  docker.absent:
    - name: lb
#    - listen_in:
#      - docker: lb-image

lb-remove-previous:
  cmd.run:
    - name: "docker rm -f $(docker ps -a | grep alars/docker-alpine-haproxy | awk {'print $1'})"
    - unless: docker ps -a | grep alars/docker-alpine-haproxy | awk {'print $1'}
    - listen_in:
      - docker: lb-image

lb-container:
    docker.installed:
      - name: lb
      - hostname: lb
      - image: alars/docker-alpine-haproxy
      - volumes:
        - "/etc/haproxy:/etc/haproxy"
      - ports:
        - "80/tcp"
        - "8080/tcp"
      - environment:
        - SERVICE_TAGS: lb
        - SERVICE_CHECK_SCRIPT: curl --silent --fail localhost:8888
      - require_in: lb

lb:
  docker.running:
    - container: lb
    - network_mode: host
    - privileged: True
    - publish_all_ports: True
    - port_bindings:
        "80":
          HostIp: "0.0.0.0"
          HostPort: "80"
        "8080":
          HostIp: "0.0.0.0"
          HostPort: "8080"     
    - binds:
        "/etc/haproxy":
          bind: "/etc/haproxy"
          ro: false  