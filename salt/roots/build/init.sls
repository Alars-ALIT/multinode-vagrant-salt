#wget downloads.drone.io/master/drone.deb
#sudo dpkg --install drone.deb

#drone:
#  pkg.installed:
#    - sources:
#      - bar: http://downloads.drone.io/master/drone.deb

drone-dpkg:
   cmd.run: 
     - name: dpkg -i /tmp/drone.deb
     - require:
       - file: /tmp/drone.deb


/tmp/drone.deb:
   file.managed:
      - source: http://downloads.drone.io/master/drone.deb
      - source_hash: md5=c975e4ed72d336179f6b8b828c7ad8c3

drone:
  service.running