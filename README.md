 
 sudo salt '*' state.highstate
 sudo salt '*' grains.item consul-mode
 
 salt -l debug 'minion-02' grains.append dynamic-roles app