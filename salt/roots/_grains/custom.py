import os 

def docker_version(): 
    return {'dockerVersion': os.popen("docker version | head -n 1 | awk 1 ORS=''").read()} 

def consul_version(): 
    return {'consulVersion': os.popen("consul version | head -n 1 | awk 1 ORS=''").read()} 