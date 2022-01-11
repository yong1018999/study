# CKS考试练习

## 第一题：

### \1. 创建clusterrole,并且对该clusterrole只绑定对Deployment，Daemonset,Statefulset的创建权限

### \2. 在指定namespace创建一个serviceaccount，并且将上一步创建clusterrole和该serviceaccount绑定

---

答题：

```yaml
#创建clusterrole
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
    name: dds-create
rules:
- apiGroups: [""]
  resources: ["Deployment","Daemonset","Statefulset"]
  verbs: ["create"]
---
#创建servinceaccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jinyong
  namespace: default
---
#将clusterrole和sa绑定
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: create
  namespace: default
subjects:
- kind: serviceaccountname
  name: jinyong
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole 
  name: dds-create 
  apiGroup: rbac.authorization.k8s.io
```

或者

```yaml
#创建clusterrole
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
    name: dds-create
rules:
- apiGroups: [""]
  resources: ["Deployment","Daemonset","Statefulset"]
  verbs: ["create"]
```

采用命令行形式创建sa

```bash
kubectl create sa jingyong -n default
```

采用命令行形式绑定clusterrole到sa上

```bash
kubeclt create rolebinding create --sa=default:jingyong --clusterrole=dds-create --namespace=default
```

## 第二题：

### 对指定etcd集群进行备份和还原,考试时会给定endpoints, 根证书ca，证书签名cert，私钥key。

### 备份：要求备份到指定路径及指定文件名

答题：

```bash
ETCDCTL_API=3 etcdctl \
--endpoints=https://127.0.0.1:2379 \
--cacert=<trusted-ca-file>\
--cert=<cert-file>\
--key=<key-file> \
snapshot save <backup-file-location>
```

还原： 要求使用指定文件进行还原

```BASH
ETCDCTL_API=3 etcdctl --data-dir <data-dir-location> snapshot restore snapshotdb
```

## 第三题：

### 升级集群，将集群中master所有组件从v1.18.8升级到1.19.0(controller,apiserver,scheduler,kubelet,kubectl)

```bash
# 找到最新的稳定版 1.19,Ubunte系统为例
apt update
apt-cache policy kubeadm
# 在列表中查找最新的 1.19 版本
# 它看起来应该是 1.19.x-00 ，其中 x 是最新的补丁

# 升级第一个控制面节点
# 用最新的修补程序版本替换 1.19.x-00 中的 x
apt-get update && \
apt-get install -y --allow-change-held-packages kubeadm=1.19.x-00

# 验证下载操作正常，并且 kubeadm 版本正确
kubeadm version

# 腾空控制平面节点
# 将 <cp-node-name> 替换为你自己的控制面节点名称
kubectl drain <cp-node-name> --ignore-daemonsets
#在控制面节点上，运行
sudo kubeadm upgrade plan
# 将 x 替换为你为此次升级所选的补丁版本号
sudo kubeadm upgrade apply v1.19.x

# 取消对控制面节点的保护
# 将 <cp-node-name> 替换为你的控制面节点名称
kubectl uncordon <cp-node-name>

# 升级其他控制面节点 
# 与第一个控制面节点类似，不过使用下面的命令
sudo kubeadm upgrade node

# 升级 kubelet 和 kubectl
# 用最新的补丁版本替换 1.19.x-00 中的 x
apt-get update && \
apt-get install -y --allow-change-held-packages kubelet=1.19.x-00 kubectl=1.19.x-00
# 重启 kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# 升级工作节点
# 升级 kubeadm
# 在所有工作节点升级 kubeadm
# 将 1.19.x-00 中的 x 替换为最新的补丁版本
# ssh 到工作节点
apt-get update && \
apt-get install -y --allow-change-held-packages kubeadm=1.19.x-00

# 将 <node-to-drain> 替换为你正在腾空的节点的名称
kubectl drain <node-to-drain> --ignore-daemonsets

# 升级 kubelet 配置
sudo kubeadm upgrade node
# 将 1.19.x-00 中的 x 替换为最新的补丁版本
apt-get update && \
apt-get install -y --allow-change-held-packages kubelet=1.19.x-00 kubectl=1.19.x-00
# 重启 kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# 通过将节点标记为可调度，让节点重新上线
# 将 <node-to-drain> 替换为当前节点的名称
kubectl uncordon <node-to-drain>

# 在所有节点上升级 kubelet 后，通过从 kubectl 可以访问集群的任何位置运行以下命令，验证所有节点是否再次可用
kubectl get nodes
```



## 第四题：

### 创建Ingress，将指定的Service的指定端口暴露出来

答题：

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: test
            port:
              number: 80
```



## 第五题：

## 创建一个拥有多个（2-4）container容器的Pod:nginx+redis

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test
spec:
  containers:
    - name: nginx
      image: nginx
    - name: redis
      image: redis
```



## 第六题：

## 对集群中的PV按照大小顺序排序显示，并将结果写道指定文件

```bash
kubectl get pv --sort-by=.spec.capacity.storage > /opt/xxx
```



## 第七题：

## 将一个Deployment的副本数量从1个副本扩至3个

```bash
kubectl scale deploymet xxx --replicas=3
```



## 第八题：

## 创建一个Networkpolicy,名称为allow-port-from-namespace, 允许现有namespace internal中得Pod连接同一个namespace中其他Pods的9999端口。

不允许对没有监听8080端口的Pods进行访问

不允许不来自namespace internal的Pods的访问

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-port-from-namespace
  namespace: internal
spec:
  podSelector:
    matchLabels: {}
  ingress:
  - from:
    - podSelector: {}
    ports:
      port: 9999
```





## 第九题：

## 集群中存在一个Pod，并且该Pod中的容器会将log输出到指定文件。修改Pod配置，将Pod的日志输出到控制台。

其实就是给Pod添加一个sidecar，使用emptyDir, 共享日志存储目录,然后不断读取指定文件，输出到控制台

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: counter
spec:
  containers:
  - name: count
    image: busybox
    args:
    - /bin/sh
    - -c
    - >
      i=0;
      while true;
      do
        echo "$(date) INFO $i" >> /var/log/info.log;
        i=$((i+1));
        sleep 1;
      done
    volumeMounts:
    - name: varlog
      mountPath: /var/log
  - name: consumer
    image: busybox
    args: [/bin/sh, -c, 'tail -n+1 -f /var/log/info.log']
    volumeMounts:
    - name: varlog
      mountPath: /var/log
  volumes:
  - name: varlog
    emptyDir: {}
```





## 第十题：

## 查询集群中指定Pod的log日志，将带有Error的行输出到指定文件

```bash
kubaclt logs <pod name> | grep Error > /var/data/xxx.log
```





## 第十一题：

## 1.创建一个Deployment，2.更新镜像版本，3.回滚

```bash
kubectl create deployment nginx --image=nginx:1.14.0
```

```bash
kubectl set image deployment/nginx nginx=nginx:1.16.0 --record 
```

```bash
kubectl rollout undo deployment/nginx
```



## 第十二题：

## 集群有一个节点notready，找出问题，并解决。并保证机器重启后不会再出现此问题

$ kubectl get nodes #找到NotReady的节点

$ ssh <nodeName> # 连接到NotReady节点

$ systemctl status kubelet # 发现kubelet Not Running

$ systemctl start kubelet #启动kubelet服务

$ systemctl enable kubelet #保证重启后不会再出现此类问题





## 第十三题：

## 创建一个PV，使用hostPath存储，大小1G，ReadWriteOnce

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv01
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  storageClassName: slow
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /opt/data/pv003
```





## 第十四题:

## 1.使用指定storageclass创建一个pvc，大小为10M

## \2. 将这个nginx容器的/var/nginx/html目录使用该pvc挂在出来

## \3. 将这个pvc的大小从10M更新成70M

\# 大像这个文件这么配置,创建之后edit以下pvc,将大小更新为70Mi

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc01
spec:
  resources:
    requests:
      storage: 10Mi
  volumeMode: Filesystem
  storageClassName: slow
  accessModes:
    - ReadWriteOnce
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
    containers:
    - name: nginx
      image: nginx
      volumeMounts:
        - mountPath: /var/nginx/html
          name: nginx-vm
    volumes:
    - name: nginx-vm
      persistentVolumeClaim:
        claimName: pvc01
```

## 第十五题

将集群中一个Deployment服务暴露出来,(是一个nginx，使用kubectl expose命令暴露即可)

```BASH
kubectl expose deployment test --port 80 --target-port=80 --type="NodePort"
```

## 第十六题

查询集群中节点，找出可以调度节点的数量，（其实就是被标记为不可调度和打了污点的节点之外的节点数量 ），然后将数量写到指定文件

```bash
# 1. 查询集群Ready节点数量
kubectl get node | grep -i ready
# 2. 判断节点有误不可调度污点
kubectl describe nodes <nodeName>  |  grep -i taints | grep -i nodeSchedule
```

## 第十七题

找集群中带有指定label的Pod中占用资源最高的，并将它的名字写入指定的文件

```bash
kubectl top pod -l key=value #筛选指定带有指定label的Pod资源占用情况
```

