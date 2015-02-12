#include:
#  - docker
{% set name           = 'busybox-go-webapp'   %}
{% set registryname   = 'alars' %}
{% set tag            = 'latest' %}
{% set containerid    = salt['grains.get']('id') %}

test:
  docker.pulled:
    - name: alars/busybox-go-webapp

