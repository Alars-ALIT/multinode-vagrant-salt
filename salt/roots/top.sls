
base:
  '*':
    - base

  'roles:consul':
    - match: grain
    - consul
    - consul.dns
    - consul.ui
  
  'G@dynamic-roles:app or G@roles:app':
    - match: compound
    - docker
    - docker.log
    - app