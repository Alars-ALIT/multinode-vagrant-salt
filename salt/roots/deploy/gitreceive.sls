git-user:
  user.present:
    - name: git
    - groups: 
      - git
      - deployer
      - docker

git-sudo:
  file.append:
    - name: /etc/sudoers
    - text:
      - "%git ALL=NOPASSWD: ALL"

git-public-key:  
  file.managed:
    - name: /home/git/.ssh/id_rsa.pub
    - source: salt://keys/alars/id_rsa.pub
    - makedirs: True

#git-auth:
#  ssh_auth.present:
#    - user: git
#    - source: salt://keys/deployer/id_rsa.pub

#TODO: loop all users
#user-auth:
#  ssh_auth.present:
#    - user: git
#    - source: salt://keys/alars/id_rsa.pub

gitreceive:  
  file.managed:
    - name: /usr/bin/gitreceive
    - source: https://raw.github.com/progrium/gitreceive/master/gitreceive
    - source_hash: md5=ede74b1e6706e77b3778657fab525b37
    - mode: 755
    - if_missing: /usr/bin/gitreceive

pre.receive.hook:  
  file.managed:
    - name: /home/git/receiver
    - source: salt://deploy/receiver.sh
    - mode: 755    

#gitreceive.init:
#  cmd.wait:
#    - name: gitreceive init
#    - watch:
#      - file: /usr/bin/gitreceive    

gitreceive.auth:
  cmd.wait:
    - name: cat /home/git/.ssh/id_rsa.pub | sudo gitreceive upload-key git
    - watch:
      - file: /usr/bin/gitreceive