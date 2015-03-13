consul-template.tar.gz:
  archive.extracted:
    - name: /tmp
    - source: https://github.com/hashicorp/consul-template/releases/download/v0.7.0/consul-template_0.7.0_linux_amd64.tar.gz
    - source_hash: md5=977146a371662a742b6694161cafdbbb
    - archive_format: tar
    - if_missing: /tmp/consul-template_0.7.0_linux_amd64

consul-template.install:
  cmd.wait:
    - name: cp /tmp/consul-template_0.7.0_linux_amd64/consul-template /usr/bin
#    - watch: 
#      - file: /tmp/consul-template_0.7.0_linux_amd64/*

/etc/consul-template/config.conf:
  file.managed:
    - source: salt://consul/template.conf.jinja
    - template: jinja
    - makedirs: True
    - mode: 755
 
#/etc/consul-template/start.sh:
#  file.managed:
#    - source: salt://consul/start-consul-template.sh
#    - mode: 755

consul-template:
  cmd.run:
    - name: echo "consul-template -config /etc/consul-template/config.conf" | at now
    - unless: ps -elf | grep consul-template | grep -v grep
#   - name: "consul-template -config /etc/consul-template/config.conf &"
