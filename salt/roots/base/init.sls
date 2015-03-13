foundation:
  pkg.installed:
    - pkgs:
      - vim
      - tmux
      - htop
      - bash-completion   
      - unzip

/etc/motd.tail: 
  file.managed: 
    - user: root 
    - group: root 
    - mode: 0644 
    - source: salt://base/motd.template.jinja 
    - template: jinja

{% if pillar['rsyslog']['endpoint'] is defined %}
/etc/rsyslog.conf:
  file.append:
    - text:
      - "*.* @{{ pillar['rsyslog']['endpoint'] }}"

rsyslog:
  service.running:
    - enable: True
    - watch:
      - file: /etc/rsyslog.conf
{% endif %}