
from os import name
from flask import Flask, jsonify
from flask_cors import CORS
from kubernetes import client, config

# Configs can be set in Configuration class directly or using helper utility
config.load_kube_config()

v1 = client.CoreV1Api()


app = Flask(__name__)
CORS(app)

def makefilter(node_name):
    def myfilter(elem):
        return elem['node_name'] == node_name
    return myfilter


def get_nodes_details():
    result = []
    ret = v1.list_node()
    apps = get_applications()
    
    for i in ret.items:
        labels = i.metadata.labels
        node_detail = {
            'node_name': labels['k3s.io/hostname'],
            'arch': labels['beta.kubernetes.io/arch'],
            'ip': labels['k3s.io/internal-ip'],
            'os': labels['kubernetes.io/os']
        }
        if 'node-role.kubernetes.io/etcd' in labels.keys() and labels['node-role.kubernetes.io/etcd'] == 'true':
            node_detail['etcd'] = True
        else:
            node_detail['etcd'] = False
            
        if 'node-role.kubernetes.io/control-plane' in labels.keys() and labels['node-role.kubernetes.io/control-plane'] == 'true':
            node_detail['control-plane'] = True
        else:
            node_detail['control-plane'] = False
        
        if 'node-role.kubernetes.io/master' in labels.keys() and labels['node-role.kubernetes.io/master'] == 'true':
            node_detail['master'] = True
        else:
            node_detail['master'] = False
        
        node_filter = makefilter(labels['k3s.io/hostname'])
        apps_running_on_node = list(filter(node_filter, apps))
        node_detail["apps"] = len(apps_running_on_node)
        result.append(node_detail)
    return result

def get_applications():
    result = []         
    ret = v1.list_pod_for_all_namespaces(watch=False)
    for i in ret.items:
        app = {
            'app_name': i.metadata.name,
            'node_name': i.spec.node_name,
            'namespace': i.metadata.namespace,
        }
        result.append(app)
    return result


@app.route('/', methods=["GET"])
def home():
    return "use /apps for details about applications. use /nodes for details about the nodes"

@app.route('/nodes', methods=["GET"])
def nodes():
    return jsonify(get_nodes_details())

@app.route('/apps', methods=["GET"])
def apps():
    return jsonify(get_applications())

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)