foundation:
  pkg.installed:
    - pkgs:
      - vim
      - tmux
      - htop
      - bash-completion   
      - unzip


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