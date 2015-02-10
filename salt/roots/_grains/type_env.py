import os 
def type_env(): 
    return {'TYPE': os.environ.get('TEST', 'test2')} 