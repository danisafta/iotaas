import os

# PostgresSQL auth and db
POSTGRES_DB = os.getenv('POSTGRES_DB')
POSTGRES_USER = os.getenv('POSTGRES_USER')
POSTGRES_PW = os.getenv('POSTGRES_PW')
POSTGRES_URL = 'postgresql://' + POSTGRES_USER + ':' + POSTGRES_PW +'@postgres:5432/' + POSTGRES_DB

# Cluster config
# type = MW (master-worker). eg: 22 : 2 master, 2 workers
MAX_MASTERS = 2
MAX_WORKERS = 10

CLUSTER = {
    'type': os.getenv('CLUSTER_TYPE'),
    'masters': [],
    'workers': []
}

_masters = []
for i in range(MAX_MASTERS):
    ip = os.getenv('MASTER'  + str(i))
    if ip:
        _masters.append({
            'name':  'MASTER'  + str(i),
            'ip': ip,
            'id': i
        })

_workers = []
for i in range(MAX_WORKERS):
    ip = os.getenv('WORKER'  + str(i))
    if ip:
        _workers.append({
            'name':  'WORKER'  + str(i),
            'ip': ip,
            'id' : i
        })

all_nodes = _workers + _masters
CLUSTER['masters'] = _masters
CLUSTER['workers'] = _workers


enabled_sensors = ['temperature', 'humidity']
