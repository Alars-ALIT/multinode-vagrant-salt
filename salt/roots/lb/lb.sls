{% set container_name = 'lb' %}
{% set image_name = 'alars/docker-alpine-haproxy' %}
{% set container_ports = ['80:80', '8080:8080'] %}
{% include 'docker/docker-template.sls' %}