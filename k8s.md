
# docker
操作记录
```bash
# 创建 Docker Registry 认证文件目录
mkdir /var/lib/registry_auth

# 使用 htpasswd 来创建加密文件
[ -f /usr/bin/htpasswd ] || yum install -y httpd-tools
htpasswd -Bbn admin admin > /var/lib/registry_auth/htpasswd

## 使用docker镜像启动镜像仓库服务
docker run -p 5000:5000 \
--restart=always \
--name registry \
-v /var/lib/registry:/var/lib/registry \
-v /var/lib/registry_auth/:/auth/ \
-e "REGISTRY_AUTH=htpasswd" \
-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
-e "REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd" \
-d registry

cat > /etc/docker/insecure.json<<EOF
{
  "insecure-registries": [
     "10.211.55.44:5000"
  ]
}
EOF

systemctl restart docker
docker login 10.211.55.44:5000
Username: admin
Password: admin

Login Succeeded

docker pull nginx:alpine
docker tag nginx:alpine 10.211.55.44:5000/nginx:alpine
docker push 10.211.55.44:5000/nginx:alpine
docker push 10.211.55.44:5000/nginx:alpine





yum install -y git 
git clone https://gitee.com/agagin/eladmin-web.git
cd eladmin-web/

$ cat Dockerfile
FROM codemantn/vue-node AS builder
LABEL maintainer="inspur_lyx@hotmail.com"

# config npm
RUN npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/ && \
    npm config set registry https://registry.npm.taobao.org
WORKDIR /opt/eladmin-web
COPY  . .

# build
RUN ls -l && npm install && npm run build:prod
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=builder /opt/eladmin-web/dist /usr/share/nginx/html/
EXPOSE 80
----------------------------------------------------
docker build . -t eladmin-web:v1 -f Dockerfile




```

# k8s

namespace 理解用来划分资源的一个资源池
k8s组件 是运行的进程
pod是 k8s 最小的一个调度单元，一个pod里可以包含多个容器
kubectl api-resources  #查看支持的资源类型


```bash

kubectl create namespace luffy
kubectl get namespace

kubectl api-resources |grep namespace #查看查询时候的缩写

kubectl create -f pod-eladmin-api.yaml
kubectl apply -f pod-eladmin-api.yaml
kubectl delete -f pod-eladmin-api.yaml


kubectl -n luffy get pod -o wide
kubectl -n luffy exec -ti eladmin-api -- bash

kubectl -n luffy delete pod redis
kubectl delete -f pod-redis.yaml

kubectl describe nodes #可以查看到节点资源使用情况

```

## kubectl create -f pod-redis.yaml 背后发生了啥？
1用户准备一个资源文件（记录了业务应用的名称、镜像地址等信息），通过调用APIServer执行创建Pod
2APIServer收到用户的Pod创建请求，将Pod信息写入到etcd中
3调度器通过list-watch的方式，发现有新的pod数据，但是这个pod还没有绑定到某一个节点中
4调度器通过调度算法，计算出最适合该pod运行的节点，并调用APIServer，把信息更新到etcd中
5kubelet同样通过list-watch方式，发现有新的pod调度到本机的节点了，因此调用容器运行时，去根据pod的描述信息，拉取镜像，启动容器，同时生成事件信息
6同时，把容器的信息、事件及状态也通过APIServer写入到etcd中


## 中间件改造
redis.yaml
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: redis
  namespace: luffy
  labels:
    app: redis
spec:
  # hostNetwork: true  #和宿主机一个网络空间
  containers:
  - name: redis
    image: redis:3.2
    ports:
    - containerPort: 6379

```

service-redis.yaml
Service资源类型 负载均衡 pod变更地址也不影响服务访问
```yaml
apiVersion: v1
kind: Service
metadata:
  name: redis
  namespace: luffy
spec:
  ports:
  - port: 6379
    protocol: TCP
    targetPort: 6379
  selector:
    app: redis
  type: ClusterIP

```

 k8s v1.24.4 调用的是containerd
```bash 
#image 存储位置不一样 
# ll /var/lib/docker ;ll /var/lib/containerd

#containerd 客户端命令 ctr crictl nerdctl(推荐 这个大部分命名和docker一样)
nerdctl -n k8s.io load -i xxx.tar #导入镜像包记得加上-n k8s.io 命名空间
# k8s -> kubelet --> containerd --> create container |pull images

ctr -n k8s.io images ls  #查看也要加上命名空间 不然看不到
ctr -n k8s.io images import xxx.tar
nerdctl -n k8s.io images



```
一个pod至少多少个容器？
pod在启动时候 先启动 pause 容器，相当于创建网络空间，
之后启动的容器启动时候加入这个pause容器，是docker的container网络模式。
同一个网络空间网络都是通了。

pod的启动过程？
1 用户create pod --》调用 api server组件 --write-- etct 数据库组件
2 Scheduler组件 --list-wathch-- 发现新的pod数据，通过调度器算法，计算出最合适该pod运行的节点，并调用api server，把信息更新到etcd中。
3 kubelet同样通过list-watch方式，发现新的pod调度到本机的节点，因此调用容器运行时，去根据pod的描述信息，拉取镜像，启动容器，同时生成事件信息。同时把容器的信息、事件、及状态也调用api server写入etcd中。



资源类型：
ReplicaSet: 用户创建指定数量的pod副本数量，确保pod副本数量符合预期状态，并且支持滚动式自动扩容和缩容功能
Deployment：工作在ReplicaSet之上，用于管理无状态应用，目前来说最好的控制器。支持滚动更新和回滚功能，提供声明式配置
DaemonSet：用于确保集群中的每一个节点只运行特定的pod副本，通常用于实现系统级后台任务。比如EFK服务
Job：只要完成就立即退出，不需要重启或重建
Cronjob：周期性任务控制，不需要持续后台运行
StatefulSet：管理有状态应用

service是一组pod的服务抽象，相当于一组pod的LB，负责将请求分发给对应的pod。
创建一个service --》k8s会自动创建一个同名的 endpoint name



标签和选择器？
service找pod 
pod找node
deployment找pod 















