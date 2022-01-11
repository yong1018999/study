# k8s学习

## 一、常用命令

1、集群中的pod相关的命令

1.1、查询集群中的所有pod

```yaml
kubectl get pods 
```

1.2、查询集群中的所有pod，带有ip地址，节点名称信息

```yaml
kubectl get -o wide
```

1.3、查询集群中的所有pod，带有namespace

```yaml
kubectl get pods -all-namespace
```

1.4、重启pod方式一

```yaml
kubectl replace --force -f -[podsyaml文件名]
```

注：由deployment创建的pod可以使用以下命令输出yaml信息（无yaml文件的replace方法）

```yaml
kubectl get pod [pod名字] -n [namespace名字] -o yaml
```

1.5、重启pod方式二，通过replicas调整pod数量为0，在重新创建pod

```yaml
kubectl scale deployment [deployment名字] --replicas=0
kubectl scale deployment [deployment名字] --replicas=1
```

1.6、重启pod方式三（由deployment创建的pod可以把pod删掉然后自动新建）

```
kubectl delete [pod名字]
```

1.7、与运行中的pod进行交互，登录pod进行操作,查看pod日志

```
kubectl exec -it [pod名字] /bin/bash
tail -f my.log
```

1.8、查看指定pod的日志 

```yaml
kubectl logs [pod名字]
kubectl logs -f [pod名字] #类似tail -f的方式查看(tail -f 实时查看日志文件 tail -f 日志文件log)
```

1.9、查看某一个pod的详细信息，查看pod无法正常启动时的日志

```yaml
kubectl describe [pod名字]
```



## 二、yaml模版

## Pod  模版

```yaml
apiVersion: v1
# 资源对象的类型
kind: Pod
metadata:
  name: nginx-gt
  namespace: default
  label:
    app: nginx-gt
spec:
  # 为pod的hosts 文件中增加 dev-cer.getui.com 记录
  hostAliases:
  - hostnames:
    - dev-cer.xiuxiuing.com
    ip: 192.168.10.53
  # 为 pod 引入裸机上的挂载目录
  volumes:
    - hostPath:
      path: /app/k8s/test
      name: logs
  # init 容器
  initContainers:
  - name: my-busybox
    image: busybox
    command: ["sh", "-c", "echo hello-world!"]
  # 应用容器
  containers:
  - name: my-nginx
    image: nginx:1.15
    # 为应用容器挂载引入的目录
    volumeMounts:
    - mountPath: /etc/nginx/logs
      name: logs
    # 设置容器运行开放的端口
    ports:
    - containerPort: 80
      name: http-service
    command: ["nginx", "-g", "daemon off;"]
    # pod 钩子
    lifecycle:
      postStart:
        exec:
          command: ["sh", "-c", "echo container start..."]
      preStop:
        exec:
          command: ["sh","-c","echo container quit..."]
    # pod 探针
    ## pod 准备就绪探针
    readinessProbe:
      exec:
        command:
        - cat
        - /etc/nginx/nginx.conf
      initialDelaySeconds: 10
      periodSeconds: 5
    ## pod 运行探针
    livenessProbe:
      exec:
        command:
        - cat
        - /etc/nginx/nginx.conf
      initialDelaySeconds: 10
      periodSeconds: 5
  # pod 能容忍的污点
  tolerations:
  - effect: NoExecute
    key: node.kubernetes.io/not-ready
    operator: Exists
    tolerationSeconds: 300
```

## Deployment 模版

```yaml
apiVersion: apps/v1  # 指定api版本，此值必须在kubectl api-versions中  
kind: Deployment  # 指定创建资源的角色/类型   
metadata:  # 资源的元数据/属性 
  name: demo  # 资源的名字，在同一个namespace中必须唯一
  namespace: default # 部署在哪个namespace中
  labels:  # 设定资源的标签
    app: demo
    version: stable
spec: # 资源规范字段
  replicas: 1 # 声明副本数目
  revisionHistoryLimit: 3 # 保留历史版本
  selector: # 选择器
    matchLabels: # 匹配标签
      app: demo
      version: stable
  strategy: # 策略
    rollingUpdate: # 滚动更新
      maxSurge: 30% # 最大额外可以存在的副本数，可以为百分比，也可以为整数
      maxUnavailable: 30% # 示在更新过程中能够进入不可用状态的 Pod 的最大值，可以为百分比，也可以为整数
    type: RollingUpdate # 滚动更新策略
  template: # 模版
    metadata: # 资源的元数据/属性 
      annotations: # 自定义注解列表
        sidecar.istio.io/inject: "false" # 自定义注解名字
      labels: # 设定资源的标签
        app: demo
        version: stable
    spec: # 资源规范字段
      containers:
      - name: demo # 容器的名字   
        image: demo:v1 # 容器使用的镜像地址   
        imagePullPolicy: IfNotPresent # 每次Pod启动拉取镜像策略，三个选择 Always、Never、IfNotPresent
                                      # Always，每次都检查；Never，每次都不检查（不管本地是否有）；IfNotPresent，如果本地有就不检查，如果没有就拉取 
        resources: # 资源管理
          limits: # 最大使用
            cpu: 300m # CPU，1核心 = 1000m
            memory: 500Mi # 内存，1G = 1000Mi
          requests:  # 容器运行时，最低资源需求，也就是说最少需要多少资源容器才能正常运行
            cpu: 100m
            memory: 100Mi
        livenessProbe: # pod 内部健康检查的设置
          httpGet: # 通过httpget检查健康，返回200-399之间，则认为容器正常
            path: /healthCheck # URI地址
            port: 8080 # 端口
            scheme: HTTP # 协议
            # host: 127.0.0.1 # 主机地址
          initialDelaySeconds: 30 # 表明第一次检测在容器启动后多长时间后开始
          timeoutSeconds: 5 # 检测的超时时间
          periodSeconds: 30 # 检查间隔时间
          successThreshold: 1 # 成功门槛
          failureThreshold: 5 # 失败门槛，连接失败5次，pod杀掉，重启一个新的pod
        readinessProbe: # Pod 准备服务健康检查设置
          httpGet:
            path: /healthCheck
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 30
          timeoutSeconds: 5
          periodSeconds: 10
          successThreshold: 1
```



## 三、实战

#### 1.建立一个nginx的deployment，yaml文件如下：

```yaml
apiVersion: apps/v1   
kind: Deployment    
metadata:  
  name: nginx  
  namespace: default 
  labels:  
    app: nginx
    version: stable
spec: 
  replicas: 3 
  selector: 
    matchLabels: 
      app: nginx
      version: stable
  template: 
    metadata: 
      labels: 
        app: nginx
        version: stable
    spec: 
      containers:
      - name: nginx 
        image: nginx:1.16.1    
        imagePullPolicy: IfNotPresent 
        ports:
        - name: http
          containerPort: 80
```

2.建立一个nginx的service，通过标签连接到nginx的deployment，yaml文件如下：

```yaml
apiVersion: v1   
kind: Service    
metadata:  
  name: nginx  
  namespace: default 
spec: 
  type: ClusterIP 
  selector: 
    app: nginx
    version: stable 
  ports:
  - name: http
  cintanerPort: 80
  targetPort: 80           
```

---

#### 2.利用k8s暴露nginx服务

![k8s外网访问集群内pod服务](F:\operation\workspace\infrastructure-code\study\node\k8s外网访问集群内pod服务.png)

```yaml
apiVersion: apps/v1   
kind: Deployment    
metadata:  
  name: nginx-test  
  namespace: cvc-vtt 
  labels:  
    app: nginx-test
    version: 1.16.1
spec: 
  replicas: 3 
  selector: 
    matchLabels: 
      app: nginx-test
      version: 1.16.1
  template: 
    metadata: 
      labels: 
        app: nginx-test
        version: 1.16.1
    spec: 
      containers:
      - name: nginx-test 
        image: nginx:1.16.1    
        imagePullPolicy: IfNotPresent 
        ports:
        - name: http
          containerPort: 80
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-test
  namespace: cvc-vtt 
  labels:
    app: nginx-test
    version: 1.16.1
spec:
  ports:
  - name: nginx-test
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx-test
    version: 1.16.1
  type: ClusterIP
status:
  loadBalancer: {}

```

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    cert-manager.io/cluster-issuer: cluster-issuer-azuredns
    custom.nginx.org/allowed-ips: 192.176.1.0/24,xxx
    external-dns.cvc.net/public: "true"
    kubernetes.io/ingress.class: public    #需对外网服务时采用public
    nginx.ingress.kubernetes.io/proxy-body-size: 100m
    nginx.ingress.kubernetes.io/proxy-read-timeout: "1800"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "1800"
  name: test-ingress   #每次更新需修改
  namespace: cvc-vtt      #每次更新需修改
spec:
  rules:
  - host: test.<domain name>  #每次更新需修改
    http:
      paths:
      - backend:
          service:
            name: nginx-test  #每次更新需修改
            port:
              number: 80  #每次更新需修改
        path: /
        pathType: Prefix

```



----

报错日志查询：

报错或者外网访问出错时，优先检查对外ingress服务日志，然后逐级往下查。

然后可以用 测试内网服务是否可以通讯

curl  svc-name.namespace-name 去测试

---

#### 3.利用configmap替换环境变量以及存储在数据卷内

![configmap](F:\operation\workspace\infrastructure-code\study\node\configmap.png)



```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: game-demo
data:
  # 类属性键；每一个键都映射到一个简单的值
  player_initial_lives: "3"
  ui_properties_file_name: "user-interface.properties"

  # 类文件键
  game.properties: |
    enemy.types=aliens,monsters
    player.maximum-lives=5    
  user-interface.properties: |
    color.good=purple
    color.bad=yellow
    allow.textmode=true 
```



```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configmap-demo-pod
spec:
  containers:
    - name: demo
      image: alpine
      command: ["sleep", "3600"]
      env:
        # 定义环境变量
        - name: PLAYER_INITIAL_LIVES # 请注意这里和 ConfigMap 中的键名是不一样的
          valueFrom:
            configMapKeyRef:
              name: game-demo           # 这个值来自 ConfigMap
              key: player_initial_lives # 需要取值的键
        - name: UI_PROPERTIES_FILE_NAME
          valueFrom:
            configMapKeyRef:
              name: game-demo
              key: ui_properties_file_name
      volumeMounts:
      - name: config
        mountPath: "/config"
        readOnly: true
  volumes:
    # 你可以在 Pod 级别设置卷，然后将其挂载到 Pod 内的容器中
    - name: config
      configMap:
        # 提供你想要挂载的 ConfigMap 的名字
        name: game-demo
        # 来自 ConfigMap 的一组键，将被创建为文件
        items:
        - key: "game.properties"   #内容为该变量下的内容，详见configmap
          path: "game.properties"  #存储文件名字
        - key: "user-interface.properties"
          path: "user-interface.properties"
```

---

#### 4.创建PVC大小5G，权限为ReadWriteMany，名叫nginx-pvc，绑定一个nginx的pod。并挂载到Pod里面的/var/www目录

![pvc](F:\operation\workspace\infrastructure-code\study\node\pvc.png)

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nginx-pvc
  namespace: cvc-vtt 
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: azurefile
  resources:
    requests:
      storage: 5Gi
```

```yaml
apiVersion: apps/v1   
kind: Pod    
metadata:  
  name: nginx-test  
  namespace: cvc-vtt 
  labels:  
    app: nginx-test
    version: 1.16.1
spec: 
  containers:
    - name: nginx-test 
      image: nginx:1.16.1    
      imagePullPolicy: IfNotPresent 
      ports:
      - name: http
        containerPort: 80
      volumeMounts:
      - name: nginx-pvc
        mountPath: "/var/www"
  volumes:  
    - name: nginx-pvc
      persistentVolumeClaim:  
       claimName: nginx-pvc     
```







资源升级版本经历

v1aplha1   v1beta1   v1



查看资源版本

kubectl  api-resources



我不记得写一个svc  deployment的具体格式，

kubectl create <资源(deployment/service)> -h 查看提示

 kubectl create deployment my-dep --image=nginx --replicas=3 -h

假设提示已经快写完了，那么在最后加上--dry-run=client -o yaml

就可以看到创建这个资源的具体yaml格式



---

```yaml
apiVersion: v1
kind: Namespace
metadata:   
  name: ingress-nginx   
  labels:     
    name: ingress-nginx
```



```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-index-v1
data:
  index.html: |
  <pre> myapp：version:V1 </pre>
---
apiVersion: apps/v1   
kind: Deployment    
metadata:  
  name: nginx-test-deploy
  labels:  
    app: nginx-test
    version: 1.16.1
spec: 
  replicas: 2 
  selector: 
    matchLabels: 
      app: nginx-test
      version: 1.16.1
  template: 
    metadata: 
      labels: 
        app: nginx-test
        version: 1.16.1
    spec: 
      containers:
      - name: nginx-test-cont
        image: nginx:1.16.1    
        imagePullPolicy: IfNotPresent 
        ports:
        - name: http
          containerPort: 80
      volumeMounts:
      - name: nginx-config
        mountPath: "/usr/share/nginx/html"
        readOnly: true
  volumes:  
    - name: nginx-config
      configmap       
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-test-svc
  labels:
    app: nginx-test
    version: 1.16.1
spec:
  ports:
  - name: nginx-test
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx-test
    version: 1.16.1
  type: loadBalancer
---
apiVersion: extensions/v1beta1      
kind: Ingress
metadata:
  name: nginx-test-ingress   #每次更新需修改
spec:
  rules:
  - host: test1.jinyongtest.com  #每次更新需修改
    http:
      paths:
      - backend:
          service:
            name: nginx-test-svc  #每次更新需修改
            port:
              number: 80  #每次更新需修改
        path: /
        pathType: Prefix
```



```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-index-v2
data:
  index.html: |
  <pre> myapp：version:V2 </pre>
```

```yaml
apiVersion: apps/v1   
kind: Deployment    
metadata:  
  name: nginx-test  
  labels:  
    app: nginx-test
    version: 1.18.0
spec: 
  replicas: 2 
  selector: 
    matchLabels: 
      app: nginx-test
      version: 1.18.0
  template: 
    metadata: 
      labels: 
        app: nginx-test
        version: 1.18.0
    spec: 
      containers:
      - name: nginx-test 
        image: nginx:1.18.0  
        imagePullPolicy: IfNotPresent 
        ports:
        - name: http
          containerPort: 80
      volumeMounts:
      - name: nginx-index-v2
        mountPath: "/usr/share/nginx/html"
        readOnly: true
```

```YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-index-v1
data:
  index.html: |
    myapp version:V1 
---
apiVersion: apps/v1   
kind: Deployment    
metadata:  
  name: nginx-test-deploy
  labels:  
    app: nginx-test
    version: 1.16.1
spec: 
  replicas: 2 
  selector: 
    matchLabels: 
      app: nginx-test
      version: 1.16.1
  template: 
    metadata: 
      labels: 
        app: nginx-test
        version: 1.16.1
    spec: 
      containers:
      - name: nginx-test-cont
        image: nginx:1.16.1    
        imagePullPolicy: IfNotPresent 
        ports:
        - name: http
          containerPort: 80
        volumeMounts:
        - name: config
          mountPath: "/usr/share/nginx/html"
          readOnly: true
      volumes:
        - name: config
          configMap:
            name: nginx-index-v1
            items:
            - key: "index.html"
              path: "index.html"
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-test-svc
  labels:
    app: nginx-test
    version: 1.16.1
spec:
  ports:
  - name: nginx-test
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx-test
    version: 1.16.1
  type: LoadBalancer

```

# 四、日常笔记

**什么是serviceaccount**

Service account是为了方便Pod里面的进程调用Kubernetes API或其他外部服务而设计的。它与User account不同
　　1.User account是为人设计的，而service account则是为Pod中的进程调用Kubernetes API而设计；
　　2.User account是跨namespace的，而service account则是仅局限它所在的namespace；
　　3.每个namespace都会自动创建一个default service account
　　4.Token controller检测service account的创建，并为它们创建secret
　　5.开启ServiceAccount Admission Controller后
               a.每个Pod在创建后都会自动设置spec.serviceAccount为default（除非指定了其他ServiceAccout）
　　　　b.验证Pod引用的service account已经存在，否则拒绝创建
　　　　c.如果Pod没有指定ImagePullSecrets，则把service account的ImagePullSecrets加到Pod中
　　　　d.每个container启动后都会挂载该service account的token和ca.crt到/var/run/secrets/kubernetes.io/serviceaccount/

