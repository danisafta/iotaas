# SD card
### 1 Setup RaspberryPI OS lite on each SD card
### 2. Add ssh file in ```/boot``` partition of each SD card

# Boot
### 1. After the first boot, change user pi's password
### 2. Install vim
### 3. Append ```cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory``` at the end of the FIRST line of ```/boot/cmdline.txt```
### 4. sudo raspi-config
#### Under perfomance, change GPU ram to 16MB
#### Configure WI-FI access
### 5. ```ssh-copy-id pi@<IP> ```
# K3S setup
Install locally:
- arkade
- kubectl
- k3sup

### Tools installation:
```
curl -sSL https://dl.get-arkade.dev | sudo sh
arkade get kubectl
arkade get k3sup
```

### Cluster set up: 
#### Setup the master node: 
```
curl -sfL https://get.k3s.io | sh -

sudo cat /var/lib/rancher/k3s/server/node-token

K1089729d4ab5e51a44b1871768c7c04ad80bc6319d7bef5d94c7caaf9b0bd29efc::node:1fcdc14840494f3ebdcad635c7b7a9b7
```

#### Setup the worker nodes: 
```
export K3S_URL="https://192.168.100.50:6443"

export K3S_TOKEN="K1089729d4ab5e51a44b1871768c7c04ad80bc6319d7bef5d94c7caaf9b0bd29efc::node:1fcdc14840494f3ebdcad635c7b7a9b7"

curl -sfL https://get.k3s.io | sh -
```
### Connect to the cluster:

```
export KUBECONFIG=/home/saftone1/kubeconfig
kubectl config set-context default
```

# Docs:
[Rpi docs & examples](https://leanpub.com/RPiMRE/read#leanpub-auto-record-the-system-information-values)

[Prometheus/Grafana Flask](https://levelup.gitconnected.com/setting-up-a-local-weather-station-using-dht11-docker-prometheus-and-grafana-on-a-raspberry-pi-a5f928addc34)