
consul.web-ui:
  archive.extracted:
    - name: /home/consul
    - source: https://dl.bintray.com/mitchellh/consul/0.4.1_web_ui.zip
    - source_hash: md5=a5a066952de0dc96348e8b7fc1022e7e
    - archive_format: zip
    - user: consul
    - mode: 755    
    - if_missing: /home/consul/dist