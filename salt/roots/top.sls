base:
  '*':
    - sanity
    - test

  'roles:consul':
    - match: grain
    - consul