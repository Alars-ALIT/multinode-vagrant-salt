
base:
  '*':
    - sanity

  'roles:consul':
    - match: grain
    - consul
    - consul.dns