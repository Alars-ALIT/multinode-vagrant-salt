git-user:
  user.present:
    - name: git
    - group: deployer

deployer-sudo:
  file.append:
    - name: /etc/sudoers
    - text:
      - "%deployer ALL=NOPASSWD: ALL"


gitreceive:  
  file.managed:
    - name: /usr/bin/gitreceive
    - source: https://raw.github.com/progrium/gitreceive/master/gitreceive
    - source_hash: md5=ede74b1e6706e77b3778657fab525b37
    - mode: 755
    - if_missing: /usr/bin/gitreceive

pre.receive.hook:  
  file.managed:
    - name: /home/git/receive
    - source: salt://deploy/receive.sh
    - mode: 755    

gitreceive.init:
  cmd.run:
    - name: gitreceive init
    - watch:
      - file: /usr/bin/gitreceive    