
base:
  '*':
    - sanity

  'roles:consul':
    - match: grain
    - consul
    - consul.dns
    - consul.ui
  
  'G@dynamic-roles:app or G@roles:app':
    - match: compound
    - docker
    - app