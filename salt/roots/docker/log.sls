logspout-image:
  docker.pulled:
    - name: gliderlabs/logspout
    - require_in: logspout-container

logspout-container:
    docker.installed:
      - name: logspout
      - hostname: {{ grains['host'] }}
      - image: gliderlabs/logspout
      - command: "syslog://logs2.papertrailapp.com:51294"
      - volumes:
         - "/var/run/docker.sock:/tmp/docker.sock"
      - ports:
        - "8000/tcp"
      - require_in: logspout

logspout:
  docker.running:
    - container: logspout
    - port_bindings:
        "8000":
          HostIp: "0.0.0.0"
          HostPort: "8000"     
    - binds:
        "/var/run/docker.sock":
          bind: "/tmp/docker.sock"
          ro: false  
