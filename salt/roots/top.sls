
base:
  '*':
    - base
    - docker
    - consul
    - consul.dns
    - consul.ui
    - app.registrator
    - app.logspout

#  'roles:consul':
#    - match: grain
#    - consul
#    - consul.dns
#    - consul.ui
  
#  'G@dynamic-roles:app or G@roles:app':
#    - match: compound
#    - docker
#    - docker.log
#    - app.dynamic

  'roles:builder':
    - match: grain
    - deploy
    - deploy.gitreceive