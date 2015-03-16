consul-user:
  user.present:
    - name: consul

consul.tar.gz:
  archive.extracted:
    - name: /usr/bin/
    - source: https://dl.bintray.com/mitchellh/consul/0.4.1_linux_amd64.zip
    - source_hash: md5=6ff7932e225df2bd4f9441a59f65d4ad
    - archive_format: zip
    - if_missing: /usr/bin/consul

/var/consul:
  file.directory:
    - user: consul
    - mode: 755
    - require:
      - user: consul-user

/etc/consul.d/config.json:
  file.managed:
    - source: salt://consul/config.json.jinja
    - template: jinja
    - context:
         host_ip: {{ salt['network.interfaces']()['eth1']['inet'][0]['address'] }}
    - makedirs: True
    - user: consul
    - mode: 755
    - group: consul
    - require:
      - user: consul-user

/etc/init/consul.conf:
  file.managed:
    - source: salt://consul/consul.conf
    - makedirs: True
    - user: consul
    - mode: 755
    - group: consul
    - require:
      - user: consul-user

consul:
  service.running:
    - enable: True
    - watch:
      - file: /etc/consul.d/config.json