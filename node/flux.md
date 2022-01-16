Flux是一个gitops工具，也就是git说什么，他就做什么，他的目标是K8S，也就是git 定义了什么资源，他就部署什么资源。



## 安装客户端

参考https://fluxcd.io/docs/installation/

Linux机器执行

```bash
curl -s https://fluxcd.io/install.sh | sudo bash
```

就安装好了

测试

```
flux
```

如果有flux命令就说明安装成功





## 安装服务端

```
flux install
```



创建git repo 

kustomization里面的resources是相对路径，相对kustomization.yaml的路径

```yaml
# vi  kustomization.yaml
resources:
- configmap.yaml   #注意每新增一个yaml均需添加文件名到此处

```



```yaml
# vi configmap.yaml
apiVersion: v1
data:
  username: admin
kind: ConfigMap
metadata:
  name: test
  namespace: default

```



然后git push 上去即可





## 创建flux 的资源

url就是你的git repo 地址  branch就是你的git 分支名字

GitRepository就是一种监听git repo的资源，让flux去拉代码

```yaml
apiVersion: source.toolkit.fluxcd.io/v1beta1
kind: GitRepository
metadata:
  name: test
  namespace: default
spec:
  interval: 1m
  url: https://github.com/JaneLiuL/testdata
  ref:
    branch: main
  secretRef:       #当仓库为私用仓库时，需要登录验证，采用secret
    name: https-credentials    
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: https-credentials
  namespace: default
type: Opaque
data:
  username: <GitHub Username>   #github用户名
  password: <GitHub Token>   #在Settings/Developer settings/Personal access tokens 内新建
```

然后kubectl apply -f之后

我们使用`kubectl get gitrepositories` 去测试一下是否拉代码成功

接下来我们创建flux 的Kustomization 

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: backend
  namespace: default
spec:
  prune: true
  interval: 1m
  path: "./"         #改路径为需要aplly的yaml文件的路径，   ./表示仓库下，若是在仓库下其他目录路径，应补充完整路径
  sourceRef:
    kind: GitRepository
    name: test
  timeout: 1m
```

同理，我们需要使用kubectl get kustomization看看是否成功



然后我们看看集群的是否部署了我们定义的资源

