#include:
#  - dnsmasq

dnsmasq:
  pkg.installed: []
  service.running:
    - name: dnsmasq
    - enable: True
    - require:
      - pkg: dnsmasq
    - watch:
      - file: /etc/dnsmasq.d/10-consul

  
/etc/dnsmasq.d/10-consul:
  file.managed:
    - source: salt://consul/dnsmasq.conf.jinja
    - template: jinja
    - context:
         host_ip: {{ salt['network.interfaces']()['eth1']['inet'][0]['address'] }}
    - makedirs: True