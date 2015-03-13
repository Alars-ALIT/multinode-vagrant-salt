{% set container_name = 'go-app' %}
{% set container_tag = 'latest' %}
{% set image_name = 'alars/busybox-go-webapp' %}
{% set container_hostname = 'go-app-' + grains['host'] %}
{% include 'docker/docker-template.sls' %}