base:

  'roles:consul':
    - match: grain
    - consul

mine_functions:
  network.interfaces: [eth0]