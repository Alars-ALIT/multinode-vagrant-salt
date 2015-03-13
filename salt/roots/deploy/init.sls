git:
  group:
    - present

deployer:
  group:
    - present


deployer-user:
   user.present:
    - name: deployer
    - groups: 
      - git
      - deployer
      - docker

deployer-sudo:
  file.append:
    - name: /etc/sudoers
    - text:
      - "%deployer ALL=NOPASSWD: ALL"

deployer-public-key:  
  file.managed:
    - name: /home/deployer/.ssh/id_rsa.pub
    - source: salt://keys/deployer/id_rsa.pub
    - makedirs: True

deployer-private-key:  
  file.managed:
    - name: /home/deployer/.ssh/id_rsa
    - source: salt://keys/deployer/id_rsa
    - makedirs: True

deployer-auth:
  ssh_auth.present:
    - user: deployer
    - source: salt://keys/deployer/id_rsa.pub

#deploy-dir:
#  file.directory:
#    - name: /tmp/deploy
#    - user: git
#    - group: deployer
#    - mode: 755
#    - makedirs: True

build-dir:
  file.directory:
    - name: /tmp/build
    - user: deployer
    - group: deployer
    - mode: 755
    - makedirs: True

deployer-script:  
  file.managed:
    - name: /home/deployer/deploy.sh
    - source: salt://deploy/deploy.sh
    - user: deployer
    - group: deployer
    - mode: 755
