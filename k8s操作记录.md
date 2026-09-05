





# k8s 安装



**本例为了演示slave节点的添加，会部署一台master+2台slave**，节点规划如下：

| 主机名     | 节点ip    | 角色   | 部署组件                                                     |
| ---------- | --------- | ------ | ------------------------------------------------------------ |
| k8s-master | 10.0.0.80 | master | etcd, kube-apiserver, kube-controller-manager, kubectl, kubeadm, kubelet, kube-proxy, flannel |
| k8s-slave1 | 10.0.0.81 | slave  | kubectl, kubelet, kube-proxy, flannel                        |
| k8s-slave2 | 10.0.0.82 | slave  | kubectl, kubelet, kube-proxy, flannel                        |

##  安装前准备 + docker安装

```bash
# 在master节点
hostnamectl set-hostname k8s-master #设置master节点的hostname
# 在slave-1节点
hostnamectl set-hostname k8s-slave1 #设置slave1节点的hostname
# 在slave-2节点
hostnamectl set-hostname k8s-slave2 #设置slave2节点的hostname

cat >>/etc/hosts<<EOF
10.0.0.80 k8s-master
10.0.0.81 k8s-slave1
10.0.0.82 k8s-slave2
EOF

# 关闭swap
swapoff -a 
# 防止开机自动挂载 swap 分区
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
#或者
#sed -ri '/ swap / s/(.*)/#\1/g' /etc/fstab


关闭selinux和防火墙
sed -ri 's#(SELINUX=).*#\1disabled#' /etc/selinux/config
setenforce 0
systemctl disable firewalld && systemctl stop firewalld

# 默认放行所有转发流量
iptables -P FORWARD ACCEPT

修改内核参数
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
# 让网桥转发的 IPv4 流量经过 iptables 防火墙规则，实现 NAT、端口映射、网络策略管控。
net.bridge.bridge-nf-call-iptables = 1
# 开启 IPv4 数据包跨网卡转发，容器访问外网、宿主机端口映射必备。
net.ipv4.ip_forward=1
# 调整进程最大内存映射区域数
vm.max_map_count=262144
EOF
modprobe br_netfilter
sysctl -p /etc/sysctl.d/k8s.conf


#配置yum源
rm -rf /etc/yum.repos.d/*
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/Centos-7.repo http://mirrors.aliyun.com/repo/Centos-7.repo
# curl -o /etc/yum.repos.d/docker-ce.repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
        http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
yum clean all && yum makecache

#所有节点安装docker
#docker 安装
# https://mirrors.huaweicloud.com/mirrorDetail/5ea14d84b58d16ef329c5c13?mirrorName=docker-ce&catalog=docker
sudo yum remove docker docker-common docker-selinux docker-engine
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
wget -O /etc/yum.repos.d/docker-ce.repo https://mirrors.huaweicloud.com/docker-ce/linux/centos/docker-ce.repo
sudo sed -i 's+download.docker.com+mirrors.huaweicloud.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
sudo yum makecache fast
sudo yum -y install docker-ce


## 配置docker加速和非安全的镜像仓库，需要根据个人的实际环境修改
mkdir -p /etc/docker
cat <<EOF > /etc/docker/daemon.json
{
    "registry-mirrors": [ "https://4c0c57d8b79a402d811834c1be74f7ae.mirror.swr.myhuaweicloud.com" ],
    "insecure-registries": ["10.0.0.80:5000"]
}
EOF
## 启动docker
systemctl enable docker && systemctl start docker



```



## [初始化集群](https://docs.chengkanghua.top/k8s-2023/2Kubernetes安装文档?id=初始化集群)



时间同步(所有节点都安装)

```bash
# 1. 检查并安装 chrony（最小化安装默认已装）
rpm -q chrony || yum install -y chrony 

# 2. 配置阿里云 NTP 服务器（国内首选，稳定低延迟）
cp /etc/chrony.conf /etc/chrony.conf.bak  # 备份原配置
# 写入新配置
cat > /etc/chrony.conf << EOF
# 使用阿里云公共NTP服务器
server ntp1.aliyun.com iburst
server ntp2.aliyun.com iburst
server ntp3.aliyun.com iburst
# 允许本机查询时间（可选）
allow 127.0.0.1
# 同步硬件时钟
rtcsync
# 不使用本地时钟兜底（外网可用时建议开启）
# local stratum 10
EOF

# 启用并立即启动
systemctl enable chronyd --now 
# 确认状态 active(running) 
systemctl status chronyd

 # 设置为上海时区
timedatectl set-timezone Asia/Shanghai
 # 验证时区与同步状态 
timedatectl status                   
# 1. 查看时间源状态（^* 表示当前活跃源）
chronyc sources -v 
# 2. 查看同步精度（offset 应 < 10ms，MGR 要求 < 50ms）
chronyc tracking 
# 3. 强制立即同步（仅首次部署时可选）
chronyc makestep 


```









# k8s 落地实践

## 纯容器模式（无编排，如单机 Docker）核心问题

1. **无自愈能力**：容器 / 节点故障后需人工修复，业务长时间中断
2. **无服务发现**：容器 IP 动态变化，跨节点调用需手动维护地址，配置混乱
3. **扩缩容低效**：手动启停容器，无统一负载均衡，弹性能力差
4. **发布风险高**：无法滚动更新、一键回滚，替换容器易造成业务停机
5. **调度能力弱**：人工分配容器节点，无法按资源情况自动最优调度
6. **配置管理散**：单容器独立配置，批量更新、统一管控成本高

## K8s 核心价值

通过集群级声明式容器编排，自动实现自愈、服务发现、弹性伸缩、滚动发布、智能调度、统一配置管理，大幅提升业务可用性与运维效率。



## 主流容器调度平台选型对比表 🎯

> 🎯 **面试常问**：为什么选 K8s 不选 Swarm？—— K8s 生态最全、已成行业标准；Swarm 只适合 5 节点内的小集群或内部工具。

一、原生编排调度引擎

| 平台            | 核心优势                                                     | 缺点                                   | 适用场景                                       | 推荐指数 |
| --------------- | ------------------------------------------------------------ | -------------------------------------- | ---------------------------------------------- | -------- |
| Kubernetes(K8s) | 生态最全、自愈 / 扩缩容 / 滚动更新 / 服务发现能力完善，行业标准 | 组件多、学习成本高、资源占用偏高       | 绝大多数企业生产、微服务、未来需要集群扩容     | ⭐⭐⭐⭐⭐    |
| Docker Swarm    | Docker 原生、上手简单、部署轻量化，命令和 docker 一致        | 调度策略简单、生态贫瘠、大规模稳定性差 | 测试环境、内网小集群（5 节点内）、内部工具服务 | ⭐⭐       |
| Nomad           | 超轻量，可同时调度容器、二进制、虚拟机，资源开销极低         | 容器周边生态不如 K8s 完善              | 边缘节点、混合负载、低配服务器集群             | ⭐⭐⭐      |
| Apache Mesos    | 超大规模资源调度能力强                                       | 架构复杂、运维成本极高，新项目基本淘汰 | 大厂机房级海量服务器、大数据离线任务           | ⭐        |

二、K8s 可视化企业级管理平台

| 平台                   | 核心优势                                                | 缺点                                     | 适用场景                                    | 推荐指数 |
| ---------------------- | ------------------------------------------------------- | ---------------------------------------- | ------------------------------------------- | -------- |
| Rancher                | 多集群统一纳管、权限管控、集群一键部署升级、运维可视化  | 需要单独部署维护                         | 私有化多机房、混合云、中小企业自建 K8s 集群 | ⭐⭐⭐⭐⭐    |
| OpenShift              | 红帽商业发行版，内置安全、CI/CD、日志合规，官方技术支持 | 商业授权费用高，偏重政企规范             | 金融、国企等强安全合规要求场景              | ⭐⭐⭐⭐     |
| Portainer              | 部署极简、轻量 Web 面板，同时支持 Docker/Swarm/K8s      | 仅基础运维能力，缺少企业级权限、集群管控 | 小规模测试、单机容器可视化管理              | ⭐⭐⭐      |
| 云厂商托管 ACK/TKE/CCE | 免运维控制面、自带监控 / 日志 / 负载均衡，一键弹性扩容  | 绑定公有云厂商，私有化无法使用           | 云上业务、不想运维 K8s 控制节点             | ⭐⭐⭐⭐⭐    |



## 一、官方标准架构（控制平面 + 工作节点）🎯

Kubernetes 采用**控制平面（Control Plane）+ 工作节点（Worker Node）** 的分布式主从架构，是官方定义的标准拓扑结构。

```text
┌──────────────────────────────────────────────────────────────────┐
│                      控制平面 Control Plane                        │
│  ┌──────────────┐   ┌──────────┐   ┌───────────┐  ┌────────────┐  │
│  │ kube-apiserver│   │  etcd    │   │ scheduler  │  │ controller │  │
│  │ (集群唯一入口) │◀──│(状态存储)│   │ (Pod 调度) │  │  -manager  │  │
│  └──────┬───────┘   └────▲─────┘   └─────┬─────┘  └─────┬─────┘  │
│         │  唯一读写 etcd  │             │               │         │
│         └────────────────┴─────────────┴───────────────┘         │
└─────────────────────────────────┬────────────────────────────────┘
                                   │ kubelet 心跳 / 指令
            ┌──────────────────────┼──────────────────────┐
            ▼                      ▼                      ▼
   ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
   │   Worker Node   │    │   Worker Node   │    │   Worker Node   │
   │ kubelet         │    │ kubelet         │    │ kubelet         │
   │ kube-proxy      │    │ kube-proxy      │    │ kube-proxy      │
   │ 容器运行时      │    │ 容器运行时      │    │ 容器运行时      │
   │  ┌──Pod──┐      │    │  ┌──Pod──┐      │    │  ┌──Pod──┐      │
   │  │container│     │    │  │container│     │    │  │container│     │
   │  └───────┘      │    │  └───────┘      │    │  └───────┘      │
   └─────────────────┘    └─────────────────┘    └─────────────────┘
```

> 一张图记住：控制平面（大脑）管决策、存状态；工作节点（手脚）跑 Pod。组件间只通过 apiserver 通信，etcd 是唯一数据源。

#### 1. 控制平面组件（集群大脑，全局决策）

控制平面负责集群管控、调度、状态存储，不运行业务容器，生产环境建议多节点高可用部署。

| 组件                         | 官方定义与核心作用                                           |
| :--------------------------- | :----------------------------------------------------------- |
| **kube-apiserver**           | 集群唯一入口，暴露 RESTful API；所有组件的交互中枢，负责认证、授权、准入校验；是唯一直接读写 etcd 的组件，可水平扩容 |
| **etcd**                     | 一致性、高可用的键值数据库；集群所有资源状态、配置、元数据的唯一持久化存储；生产必须做数据备份 |
| **kube-scheduler**           | 监听未绑定节点的新建 Pod，通过「预选过滤 + 优选打分」算法，为 Pod 选择最合适的工作节点 |
| **kube-controller-manager**  | 运行各类控制器进程，核心机制是**调和循环**：持续监听资源变化，驱动「实际状态」向「期望状态」收敛；内置节点控制器、副本控制器、端点控制器、命名空间控制器等 |
| **cloud-controller-manager** | 可选组件，对接公有云 API；管理云厂商负载均衡、云盘存储、路由网络等资源，私有化部署可不用 |

#### 2. 工作节点组件（运行业务负载）

每个工作节点负责运行 Pod 并提供容器运行环境，受控于控制平面。

| 组件                   | 官方定义与核心作用                                           |
| :--------------------- | :----------------------------------------------------------- |
| **kubelet**            | 节点上的常驻代理，是控制平面与节点的通信桥梁；接收 apiserver 指令，管理本机 Pod 的全生命周期（创建、启停、健康检查、资源限制），确保 Pod 状态符合规约 |
| **kube-proxy**         | 节点网络代理；维护节点上的 iptables/ipvs 网络规则，实现 Service 负载均衡、集群内服务发现与流量转发 |
| **容器运行时**         | 遵循 CRI（容器运行时接口）标准，负责拉取镜像、创建 / 销毁容器；主流实现为 containerd，早期版本使用 Docker |
| **集群插件（Addons）** | 可选扩展能力，包括 CoreDNS（集群内部 DNS 解析）、Ingress Controller、监控日志组件等 |

------

### 二、官方标准工作流程（以创建 Deployment 为例）

K8s 核心设计是**声明式 API + 调和循环**：用户只提交期望状态，系统通过 List-Watch 机制持续监听，自动收敛到目标状态。

以「提交一个 3 副本 Nginx 的 Deployment」为例，完整执行链路：

1. **请求接入**：用户通过 `kubectl apply` 提交 Deployment 配置，请求经认证授权后到达 kube-apiserver
2. **状态持久化**：apiserver 校验资源合法性，将 Deployment 的期望状态写入 etcd
3. **控制器调和**：Deployment Controller 监听到资源变更，对比期望状态，创建对应 ReplicaSet 资源并写入 etcd；ReplicaSet Controller 继续创建 3 个未绑定节点的 Pod 资源
4. **Pod 调度**：kube-scheduler 监听到未调度的 Pod，执行预选 + 优选算法，为每个 Pod 分配目标节点，更新 Pod 的节点绑定信息写入 etcd
5. **Pod 启动**：目标节点的 kubelet 监听到分配给自己的 Pod，调用本地容器运行时拉取镜像、创建并启动容器
6. **状态上报**：kubelet 持续上报 Pod 健康状态到 apiserver，同步存入 etcd
7. **服务网络生效**：Endpoints 控制器监听到 Pod 就绪，更新对应 Service 的后端端点列表；各节点 kube-proxy 同步更新网络规则，完成服务负载均衡配置

------

### 三、核心设计原则（官方核心思想）🎯

1. **声明式 API**：只定义最终期望状态，不关心执行步骤，系统自动完成编排
2. **List-Watch 机制**：组件通过监听 apiserver 资源变化触发动作，无轮询开销、实时响应
3. **不可变基础设施**：镜像不可变，更新靠重建 Pod 实现，保证环境一致性
4. **自愈能力**：节点故障、Pod 异常时，控制器自动重建 / 迁移，维持期望副本数

> 🎯 一句话背诵：**声明式 API + List-Watch + 调谐循环**，构成 K8s 自动化运维的地基。



### 什么是分布式？🎯

> 🎯 **面试高频**：K8s 天生是分布式系统，标准答法按「**三层含义**」展开：组件拆分、多节点部署、任务分散调度。

**定义**：把原本跑在一台机器上的整套系统，拆成多个组件部署在多台服务器上协同工作，网络互通、分工协作，任意单机故障不会导致整体瘫痪。对立面是**单体（集中式）**：所有组件挤在一台机器，宕机即全挂。

#### 分布式在 K8s 的三层含义

| 层次 | 含义 | K8s 中的体现 |
| --- | --- | --- |
| ① 组件拆分 | 功能拆开、各司其职，可独立扩缩升级 | 控制平面 4 组件 + 节点 3 组件（见上节） |
| ② 多节点部署 | 物理机器分布式，高可用核心 | Master 可 3/5 主部署；Worker 横向无限扩 |
| ③ 任务分散调度 | 业务负载打散到不同节点 | 多副本分散在不同 Worker，宕机自动迁移 |

**三大价值**：高可用（单点故障不影响整体）／可横向扩容（加机器而非升硬件）／容错 + 数据一致（etcd 保证所有节点看到的状态一致）。

> **纵向扩容** = 给单机加 CPU/内存（单体唯一选择）；**横向扩容** = 加机器（分布式的核心优势）。

#### 延伸小考点 🎯

控制平面分布式的两大依赖：**① etcd 分布式存储**（Raft 一致性，3 节点可挂 1）；**② apiserver 无状态**（可多实例水平部署做负载均衡）。



### 核心组件（补充视角）🎯

> 上一节【官方标准架构】已列过组件表，这里只补两块：**Controller Manager 内置哪些控制器**、**kubelet 到底干哪三件事**。

**Controller Manager 内置控制器**：Replication、Node、ResourceQuota、Namespace、ServiceAccount、Token、Service、Endpoints。
（面试报名字即可，重点是 **Endpoints Controller 负责把 Pod IP 同步进 Service 后端列表**。）

**kubelet 三件事**（面试高频「kubelet 做什么」）：
1. **Pod 管理**：监听 Pod 期望状态，调容器运行时把实际状态拉到期望状态；
2. **健康检查**：容器异常时按重启策略处理；
3. **资源监控**：通过 **cAdvisor** 采集节点资源使用情况并上报，供调度器决策。

- `kube-proxy`：维护节点上的 iptables / ipvs 规则（Service 转发的落地者）
- `kubectl`：命令行客户端，本质是对 apiserver REST API 的封装







```bash
K8s架构+工作流程 3分钟面试背诵版
一、K8s架构（口述1分钟）
K8s整体采用控制平面 + 工作节点的主从分布式架构。
首先是控制平面，是整个集群的管控核心，主要包含四个核心组件：
第一，kube-apiserver，是集群唯一API入口，所有操作、所有组件都和它交互，负责认证授权、准入控制，也是唯一操作etcd的组件。
第二，etcd，是集群唯一数据库，存储所有资源的元数据和期望状态。
第三，kube-scheduler，负责监听未调度的Pod，通过预选、优选策略，把Pod调度到最优工作节点。
第四，kube-controller-manager，内置各类控制器，通过调谐循环，保证集群实际状态和用户期望状态一致，实现自愈能力。

然后是工作节点，负责运行业务Pod，核心组件有三个：
kubelet 是节点代理，负责管理本机Pod的全生命周期；
kube-proxy 维护节点网络规则，实现Service负载均衡和服务发现；
还有容器运行时，负责拉取镜像、运行容器。


二、工作流程（口述2分钟，以Deployment部署为例）
整体流程遵循 K8s 声明式API、List-Watch监听、控制器调谐 的核心机制。
第一步，我执行kubectl apply，请求经过认证授权后给到apiserver，apiserver校验后把资源信息持久化到etcd。
第二步，Deployment控制器监听到资源变化，自动创建ReplicaSet，ReplicaSet再根据配置的副本数，创建对应的Pod资源，写入etcd。
第三步，调度器监听到这批未绑定节点的Pod，经过过滤、打分，选择最合适的Worker节点，完成Pod节点绑定。
第四步，对应节点的kubelet监听到分配给自己的Pod，调用容器运行时，创建沙箱和业务容器，完成Pod启动。
第五步，kubelet实时上报Pod状态，更新到集群数据库。同时kube-proxy更新网络规则，实现Service访问和负载均衡。
最后如果Pod异常退出，控制器会自动重建Pod，始终维持用户定义的期望副本数，实现集群自愈。

三、收尾加分一句话（必说）
简言之，K8s无需定义操作步骤，仅需配置业务期望状态，集群可自动完成调度、部署、扩缩容和故障自愈。


```







## CRI 和 OCI 标准  什么区别? 🎯

### 核心一句话

- **OCI：底层容器通用标准（管镜像、管内核怎么跑容器）**
- **CRI：K8s 专属上层接口标准（管 K8s 怎么调用容器运行时）**

### 一、核心区别对比表（必背）

| 对比项       | OCI                                                | CRI                                   |
| ------------ | -------------------------------------------------- | ------------------------------------- |
| **全称**     | 开放容器规范                                       | K8s 容器运行时接口                    |
| **归属**     | Linux 基金会、**全行业通用**                       | K8s 官方、**仅 K8s 使用**             |
| **层级**     | 底层标准                                           | 上层调用接口                          |
| **作用**     | 统一**镜像格式、容器运行规则**（Namespace/Cgroup） | 统一 **kubelet 调用容器运行时的协议** |
| **包含规范** | 镜像规范 + 运行时规范                              | 镜像服务 API + 容器运行 API           |
| **实现**     | runc、crun                                         | containerd、CRI-O                     |

### 二、层级关系

**OCI 是地基，CRI 是上层通道**

- OCI：规定容器**长什么样、怎么跑**
- CRI：规定 K8s **怎么命令运行时去创建容器**

### 三、K8s 完整调用链路（极简）

```
kubelet →(CRI gRPC)→ containerd →(遵循OCI)→ runc → 容器
```

### 四、最简记忆

1. **OCI = 统一容器标准**（所有容器都遵守）
2. **CRI = K8s 解耦接口**（让 K8s 不绑定 Docker）





## 理解集群资源

### 一、核心理解 🎯

**资源 = 使用 K8s 各种能力的载体**（想用什么能力，就创建对应类型的资源）。

所有可通过 `kubectl get` 查询的对象统称为**集群资源**：以 YAML 声明期望状态存入 etcd，控制器通过调谐循环让实际状态不断趋近期望状态。

> 🎯 **面试高频**：所有资源通用**五段结构** —— `apiVersion`（API 版本）、`kind`（资源类型）、`metadata`（名称 / 标签 / 命名空间）、`spec`（期望状态，用户写）、`status`（实际状态，系统填）。

### 二、五大类资源（必背）

#### 1. 工作负载类（部署业务）

1. **Pod**：集群最小调度单元，封装一组容器，生命周期短暂，重建 IP 变化。
2. **Deployment**：管理无状态应用，实现副本维持、滚动更新、回滚、故障自愈。
3. **StatefulSet**：管理有状态应用，提供稳定网络标识、有序部署销毁、持久存储。
4. **DaemonSet**：每个节点仅运行一个 Pod，用于日志、监控、网络插件等节点级组件。
5. **Job/CronJob**：一次性任务、定时任务。

#### 2. 网络服务类（流量访问）

1. **Service**：Pod 固定访问入口，提供 ClusterIP，实现负载均衡、集群内服务发现。
2. **Endpoint**：Service 后端绑定的 Pod IP + 端口列表。
3. **Ingress**：七层反向代理，基于域名、路径转发外部流量到多个 Service。

#### 3. 配置管理类（解耦配置与镜像）

1. **ConfigMap**：存放明文配置、环境变量、配置文件。
2. **Secret**：存放密码、证书等敏感数据，仅 Base64 编码，非加密。

#### 4. 存储资源类（数据持久化）

1. **PV**：管理员预先创建的持久存储卷。
2. **PVC**：业务存储申请，通过绑定 PV 实现数据持久挂载。
3. **StorageClass**：动态存储类，无需手动创建 PV，按需自动分配存储。

#### 5. 集群管控类（隔离、权限、资源限制）

1. **Namespace**：资源逻辑隔离，用来划分测试、生产等环境。
2. **Node**：集群节点，承载所有 Pod 运行，自带 CPU、内存硬件资源。
3. **ResourceQuota**：命名空间级别 CPU、内存、Pod 总数配额限制。
4. **LimitRange**：给命名空间内 Pod / 容器设置默认、最大最小资源限制。
5. **RBAC**：基于角色的权限控制，管理用户、服务账号对集群资源的操作权限。
6. **HPA**：水平 Pod 自动扩缩容控制器，根据监控指标自动调整Deployment、StatefulSet 等工作负载的 Pod 副本数量。

### 三、加分总结

所有集群资源本质都是 API 对象，通过标签 Label 筛选资源，注解 Annotation 存储扩展描述；借助控制器实现声明式运维，不用关心具体操作步骤，只需要定义最终想要的集群状态。



## kubectl 高频常用命令

```bash
kubectl api-resources

kubectl get namespaces

kubectl是命令行工具, 用于与APIServer交互，内置了丰富的子命令，功能极其强大。 https://kubernetes.io/docs/reference/kubectl/overview/
$ kubectl -h
$ kubectl get -h
$ kubectl create -h
$ kubectl create namespace -h


一、集群信息
kubectl get nodes                  # 查看所有节点
kubectl get ns / namespaces        # 查看命名空间
kubectl describe node 节点名       # 节点详细信息
kubectl version                    # 客户端、服务端版本
kubectl cluster-info               # 集群信息
二、资源查看（最常用）
# 查看默认命名空间资源
kubectl get pods
kubectl get deploy
kubectl get svc

# 指定命名空间
kubectl get pods -n test
# 所有命名空间
kubectl get pods --all-namespaces / -A

# 查看详情、事件
kubectl describe pod pod名 -n ns名
# 查看标签
kubectl get pods --show-labels


# node节点添加标签
kubectl label node k8s-slave1 component=gitlab
# 删除掉标签
kubectl label node k8s-slave1 component-

# 按标签过滤
kubectl get pods -l app=nginx

三、资源创建、删除、更新
# 从yaml创建
kubectl apply -f xxx.yaml
# 批量创建目录下所有yaml
kubectl apply -f ./dir

# 删除资源
kubectl delete pod pod名 -n ns
kubectl delete -f xxx.yaml
kubectl delete ns test             # 删除命名空间（连带内部所有资源）

# 直接命令创建（临时测试）
kubectl create deploy nginx --image=nginx
# 扩缩容
kubectl scale deploy nginx --replicas=3
# 镜像升级
kubectl set image deploy nginx nginx=nginx:1.23
# 回滚
kubectl rollout undo deploy nginx
# 查看发布历史
kubectl rollout history deploy nginx

四、日志、进入容器、文件传输
# 实时查看日志
kubectl logs -f pod名 -n ns
# 查看之前崩溃日志
kubectl logs --previous pod名

# 进入容器
kubectl exec -it pod名 -n ns -- /bin/bash
# 多容器Pod指定容器进入
kubectl exec -it pod名 -c 容器名 -- sh

# 宿主机 ↔ 容器传文件
kubectl cp 宿主机路径 pod名:容器内路径 -n ns
kubectl cp pod名:容器路径 宿主机路径 -n ns

五、配置类资源操作
kubectl get cm
kubectl get secret
kubectl describe cm xxx
kubectl get configmap xxx -o yaml  # 导出yaml

六、存储、网络、Ingress
kubectl get pv
kubectl get pvc
kubectl get ingress

七、导出资源 yaml（备份 / 模板）
# 查看yaml格式
kubectl get deploy nginx -o yaml
# 导出保存
kubectl get deploy nginx -o yaml > deploy.yaml
# 快速生成yaml不创建资源
kubectl create deploy nginx --image=nginx --dry-run=client -o yaml > nginx.yaml

八、常用格式化输出
-o wide        # 更多列（节点、IP）
-o yaml
-o json

九、上下文 / 命名空间快捷设置
# 设置默认命名空间
kubectl config set-context --current --namespace=test
# 查看当前上下文
kubectl config get-contexts


```



## pod

### 一、Pod 定义

Pod 是 K8s**最小调度单元**，不是容器。一个 Pod 可封装 1 个或多个强耦合容器，这些容器共享网络命名空间、存储卷，共用同一个 PodIP，只能调度在同一个节点；Pod 生命周期短暂，重建后 IP 会变化，不会跨节点迁移。

### 二、Pod 内两类容器

1. 业务容器 + Sidecar 边车容器

   主容器跑业务，边车负责日志采集、流量代理、监控等辅助能力，共享网络直接本地通信。

2. Init 初始化容器

   顺序执行，必须全部正常退出后，业务容器才会启动；常用于初始化配置、等待依赖服务、下载资源。

### 三、Pod 状态

| 状态值              | 描述                                                         |
| ------------------- | ------------------------------------------------------------ |
| Pending             | API Server 已经创建该 Pod，等待调度器调度                    |
| ContainerCreating   | 拉取镜像、创建网络存储、启动容器中                           |
| Running             | Pod 内容器均已创建，且至少有一个容器处于运行、正在启动或正在重启状态 |
| Succeeded/Completed | Pod 内所有容器均正常执行完毕退出，且策略不再重启容器         |
| Failed/Error        | 容器启动运行失败，不会再次重启                               |
| CrashLoopBackOff    | 容器反复崩溃退出，集群触发退避策略，延后重试启动             |
| ErrImagePull        | 镜像拉取失败，常见原因：镜像地址错误、私有仓库无认证权限、网络不通 |
| Unknown             | 节点失联，控制平面未收到该节点上报的 Pod 状态                |
| Evicted             | 节点内存 / CPU 等资源耗尽，Pod 被 kubelet 强制驱逐           |

#### 重启策略（3 种）🎯

> 由**所在节点的 kubelet** 判断执行，作用于 Pod 内所有容器。

| 策略 | 行为 | 适用 |
| --- | --- | --- |
| `Always`（默认） | 退出就重启 | 常驻业务（Deployment） |
| `OnFailure` | 仅异常退出才重启 | 一次性任务（Job） |
| `Never` | 无论成败都不重启 | 手动调试 |

#### 镜像拉取策略

```bash
spec:
  containers:
  - name: eladmin-api
    image: 10.0.0.80:5000/eladmin/eladmin-api:v1
    imagePullPolicy: IfNotPresent
    
```

设置镜像的拉取策略，默认为IfNotPresent

- Always，总是拉取镜像，即使本地有镜像也从仓库拉取
- IfNotPresent ，本地有则使用本地镜像，本地没有则去仓库拉取
- Never，只使用本地镜像，本地没有则报错

#### 四、三种健康探针 🎯

| 探针 | 作用 | 失败后果 |
| --- | --- | --- |
| `livenessProbe` 存活 | 检测容器是否卡死 | **杀掉并重启容器** |
| `readinessProbe` 就绪 | 检测能否对外提供服务 | **从 Service 摘除流量**（不重启） |
| `startupProbe` 启动 | 保护慢启动应用 | 启动期屏蔽前两个探针，避免没起完就被误杀 |

> 🎯 **面试必背**：`Readiness` 决定 Service 是否把流量导入该 Pod；`Liveness` 决定容器是否需要重启。**两者绝不能混用**。

```bash
Readiness 决定了Service是否将流量导入到该Pod，Liveness决定了容器是否需要被重启
```



三种探测方式：命令执行、HTTP 接口请求、TCP 端口探测。

​	exec：容器内执行命令，返回码 0 则健康

​	httpGet：访问容器内 HTTP 接口，2xx/3xx 正常

​	tcpSocket：检测端口是否可连通

```bash

#exec：通过执行命令来检查服务是否正常，返回值为0则表示容器健康
...
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/healthy
      initialDelaySeconds: 5
      periodSeconds: 5
...

#httpGet方式：通过发送http请求检查服务是否正常，返回200-399状态码则表明容器健康
  containers:
  - name: eladmin-api
    image: 10.0.0.80:5000/eladmin/eladmin-api:v1
    readinessProbe:
      httpGet:
        path: /auth/code
        port: 8000
        scheme: HTTP
      initialDelaySeconds: 20  # 容器启动后第一次执行探测是需要等待多少秒
      periodSeconds: 15        # 执行探测的频率
      timeoutSeconds: 3        # 探测超时时间
      
#tcpSocket：通过容器的IP和Port执行TCP检查，如果能够建立TCP连接，则表明容器健康
  ...
      livenessProbe:
        tcpSocket:
          port: 8000
        initialDelaySeconds: 10  # 容器启动后第一次执行探测是需要等待多少秒
        periodSeconds: 10        # 执行探测的频率
        timeoutSeconds: 2        # 探测超时时间
  ...
```



### 五、资源配额 🎯

- `requests`：**调度依据** —— 节点剩余资源够不够分，看它
- `limits`：**运行上限** —— CPU 超限被**限流**（不杀），内存超限**触发 OOM 被杀**

单位：CPU `1 核 = 1000m`；内存 `Mi` / `Gi`。

> 🎯 **面试延伸（QoS 等级）**：按 requests/limits 的组合，Pod 分三档，节点资源不足时**优先驱逐 BestEffort**：
> 1. **Guaranteed**（最不容易被驱逐）：每个容器都设且 `requests == limits`
> 2. **Burstable**：设了但两者不等，或只设了部分
> 3. **BestEffort**（最先被驱逐）：完全不设

### 六、为什么 K8s 最小调度单元是 Pod 不是容器 🎯

1. 方便强耦合容器共享网络 / 存储，支撑 **Sidecar 模式**；
2. 同 Pod 内容器生命周期统一，同时创建销毁、必然调度到同一节点；
3. 统一做资源限制、健康检查、网络管控。

### 七、静态 Pod（补充考点）🎯

- **不由 apiserver 管理**，由节点 kubelet 直接读取 `/etc/kubernetes/manifests` 下的 yaml 创建；
- **Master 控制平面组件**（kube-apiserver、etcd、scheduler 等）本身就是静态 Pod；
- 只能在对应节点上删除文件，**`kubectl delete` 删不掉**。

### 八、常用排查命令

```bash
kubectl get pods -o wide
kubectl describe pod <pod名>
kubectl logs -f <pod名>
kubectl exec -it <pod名> -- sh

支持的资源类型与apiVersion
kubectl api-resources

快速获得资源和版本
$ kubectl explain pod
$ kubectl explain Pod.apiVersion




```





### 操作记录

```bash

#准备数据库
git clone https://gitee.com/chengkanghua/eladmin.git
 
docker run -d --restart=always -p 3306:3306 --name mysql  -v /opt/mysql:/var/lib/mysql -e MYSQL_DATABASE=eladmin -e MYSQL_ROOT_PASSWORD=luffyAdmin! mysql:5.7 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
 
docker cp eladmin/sql/eladmin.sql  mysql:/
 
[root@CentOS-2 sql]# docker exec -it mysql /bin/bash
root@ebced213f73f:/# mysql -uroot -pluffyAdmin!
mysql> use eladmin
mysql> source /eladmin.sql
mysql> quit
bash-4.2# exit

docker run -p 6379:6379 --name redis -d --restart=always redis:3.2 redis-server

#数据库地址修改成实际的情况
cat > pod-eladmin-api.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: eladmin-api
  namespace: luffy
  labels:
    app: eladmin-api
spec:
  imagePullSecrets:
  - name: registry-10-0-0-80
  containers:
  - name: eladmin-api
    image: 10.0.0.80:5000/eladmin/eladmin-api:v1
    env:
    - name: DB_HOST   #  指定数据库地址
      value: "10.0.0.80"
    - name: DB_USER   #  指定数据库连接使用的用户
      value: "root"
    - name: DB_PWD
      value: "luffyAdmin!"
    - name: REDIS_HOST
      value: "10.0.0.80"
    - name: REDIS_PORT
      value: "6379"
    ports:
    - containerPort: 8000 
EOF
----------------------------------------------
    
# http://www.wetools.com/yaml/  #这是一个yam文件转换json格式的网址


kubectl create ns luffy
kubectl create namespace luffy

## ImagePullBackOff，创建镜像拉取所用的密钥信息
kubectl -n luffy create secret docker-registry registry-10-0-0-80 --docker-username=admin --docker-password=admin --docker-email=admin@admin.com --docker-server=10.0.0.80:5000


kubectl create -f pod-eladmin-api.yaml
#查看 镜像拉取失败
kubectl -n luffy describe pod eladmin-api

## 删除pod重建,两种方式
kubectl -n luffy delete pod eladmin-api
kubectl delete -f pod-eladmin-api.yaml

kubectl -n luffy get pod -owide
kubectl -n luffy get po -owide |awk 'NR==2{print $6}'
curl -v http://$(kubectl -n luffy get po -owide |awk 'NR==2{print $6}'):8000/auth/code  
# 正常返回信息

## 进入容器,执行初始化, 不必到对应的主机执行docker exec
$ kubectl -n luffy exec -ti eladmin-api -- bash
/ # env



## 查看pod调度节点及pod_ip
kubectl -n luffy get pods -o wide
## 查看完整的yaml
kubectl -n luffy get po eladmin-api -o yaml
## 查看pod的明细信息及事件
kubectl -n luffy describe pod eladmin-api
#进入Pod内的容器
$ kubectl -n <namespace> exec <pod_name> -c <container_name> -ti /bin/sh
#pod里单容器就可以不用指定容器名
kubectl -n luffy exec eladmin-api -ti -- bash
#查看指定pod里所有容器名
kubectl -n luffy get pod eladmin-api -o jsonpath='{.spec.containers[*].name}'

#查看Pod内容器日志,显示标准或者错误输出日志
$ kubectl -n <namespace> logs -f <pod_name> -c <container_name>
kubectl -n luffy logs -f eladmin-api

# 更新服务版本
kubectl apply -f pod-eladmin-api.yaml

#根据文件删除
$ kubectl delete -f pod-eladmin-api.yaml

#根据pod_name删除
$ kubectl -n <namespace> delete pod <pod_name>
kubectl -n luffy delete pod eladmin-api
```



### Infra 容器（Pause 容器）

```bash
#到对应worker 节点查看
nerdctl -n k8s.io ps -a|grep eladmin-api  ## 发现有二个容器
## 其中包含eladmin容器以及pause容器
## 为了实现Pod内部的容器可以通过localhost通信，每个Pod都会启动pause容器，然后Pod内部的其他容器的网络空间会共享该pause容器的网络空间(Docker网络的container模式)，pause容器只需要hang住网络空间，不需要额外的功能，因此资源消耗极低。
```



#### 一、基本概念

Infra 容器又叫 **Pause 容器 / 沙箱容器**：每个 Pod 自动最先创建，用户无需定义，镜像仅几百 KB，内部只有一个无限休眠进程，几乎不消耗资源。在 CRI 规范里它就是 **Pod 沙箱 Sandbox**。

**启动顺序**：kubelet 调 containerd 先起 Pause（创建各类命名空间、配 Pod 网络、绑 Cgroup）→ 再依次起 Init 容器、业务容器、Sidecar，全部加入 Pause 持有的命名空间。

#### 二、三大核心作用（必背）

1. **持有网络命名空间（最核心）**：Pause 先建好 Network Namespace，CNI 分配 PodIP / 网卡 / 路由；业务容器加入后 —— 共用同一 PodIP、可走 `localhost` 互通、端口不能重复监听、统一应用 NetworkPolicy。
   
   > 就算业务容器全崩，只要 Pause 还在，网络栈就不会销毁；**Pause 退出 = Pod 生命周期结束**。
2. **PID 命名空间 1 号进程**：接管回收孤儿进程，防止僵尸进程堆积；Pod 优雅停止时由它统一管控退出顺序。
3. **统一资源隔离边界**：Pod 的 `requests/limits` 实际绑在 Pause 的 Cgroup 上；UTS、IPC 命名空间与 EmptyDir 等卷也统一共享。

#### 三、常见误区纠正

- Pause **不转发数据包、不做路由、不做网络代理**，只负责"持有"命名空间；
- 它不跑业务，只负责"活着"维持 Pod 的底层隔离环境；
- 删单个业务容器不会销毁 Pod，**只有 Pause 被删，整个 Pod 才重建**。

> 🎯 一句话：Pause 是 Pod 的基础设施沙箱，统一持有网络 / PID / IPC 命名空间，是 Pod 生命周期的锚点。



### mysql redis 添加service 

```bash

# 前端和后端项目写到一个pod里
cat >pod-eladmin.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: eladmin
  namespace: luffy
  labels:
    app: eladmin
spec:
  imagePullSecrets:
  - name: registry-10-0-0-80
  containers:
  - name: eladmin-api
    image: 10.0.0.80:5000/eladmin/eladmin-api:v1
    env:
    - name: DB_HOST   #  指定数据库地址
      value: "10.0.0.80"
    - name: DB_USER   #  指定数据库连接使用的用户
      value: "root"
    - name: DB_PWD
      value: "luffyAdmin!"
    - name: REDIS_HOST
      value: "10.0.0.80"
    - name: REDIS_PORT
      value: "6379"
    ports:
    - containerPort: 8000
  - name: eladmin-web
    image: 10.0.0.80:5000/eladmin/eladmin-web:v1
    ports:
    - containerPort: 80
EOF
 
kubectl create -f pod-eladmin.yaml



cat <<EOF > redis.yaml
apiVersion: v1
kind: Pod
metadata:
  name: redis
  namespace: luffy
  labels:
    app: redis
spec:
  # hostNetwork: true
  containers:
  - name: redis
    image: redis:3.2
    ports:
    - containerPort: 6379
EOF
kubectl create -f redis.yaml

cat <<EOF > redis.service.yaml
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
EOF

kubectl create -f redis.service.yaml
kubectl -n luffy get svc -owide
业务app —–>访问 cluster-ip:6379 —->redis-service —–> Redis-Pod
这里不用关心pod的ip地址是否变更， servie会自动找到标签 app=redis的pod

[root@k8s-master ~]# kubectl -n luffy describe svc redis
# ip vip 虚拟ip
# Endpoints: 真是容器ip


kubectl -n luffy get pod -owide --show-labels
 
#删除redis pod重新创建  service信息会更新:  endpoints到新的redis上 
#谁作的；controller-manager--->endpoint-controller会给service的endpoints更新
 
 
# 给节点打标签
kubectl label node k8s-slave1 mysql=true
# 停掉之前的mysql容器，用Pod部署
docker stop mysql

cat <<EOF > mysql.yaml
apiVersion: v1
kind: Pod
metadata:
  name: mysql
  namespace: luffy
  labels:
    app: mysql  #这个标签 servie根据这个标签找对应的pod
spec:
  nodeSelector:  # 使用节点选择器将Pod调度到指定label的节点
    mysql: "true"
  containers:
  - name: mysql
    image: mysql:5.7
    env:
    - name: MYSQL_DATABASE   #  指定数据库地址
      value: "eladmin"
    - name: MYSQL_ROOT_PASSWORD
      value: "luffyAdmin!"
    ports:
    - containerPort: 3306
    args: #重写容器启动的cmd 
    - --character-set-server=utf8mb4
    - --collation-server=utf8mb4_unicode_ci
    volumeMounts:
    - name: mysql-data  #挂载的volumes名是mysql-data 和下面的对应好。
      mountPath: /var/lib/mysql
  volumes: 
  - name: mysql-data
    hostPath: 
      path: /opt/mysql
EOF

cat <<EOF > mysql.service.yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql
  namespace: luffy
spec:
  ports:
  - port: 3306
    protocol: TCP
    targetPort: 3306
  selector:
    app: mysql
  type: ClusterIP
EOF

kubectl create -f mysql.yaml
# 创建mysql的service
kubectl create -f mysql.service.yaml

# 部署完一直等待，查看pod的详细信息
kubectl -n luffy describe po mysql
# 查看service 详细信息
kubectl -n luffy describe svc mysql
#查看pod日志
kubectl -n luffy logs -f --tail=200 mysql


kubectl -n luffy  |get|logs|exec|describe |   pod

# 修改eladmin-api的环境变量，重建eladmin-api服务

#分别查看services的redis 和MySQL的 虚拟vip地址  
kubectl -n luffy describe svc mysql|grep IP:|awk '{print $2}'
kubectl -n luffy describe svc redis|grep IP:|awk '{print $2}'

cat >pod-eladmin.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: eladmin
  namespace: luffy
  labels:
    app: eladmin
spec:
  imagePullSecrets:
  - name: registry-10-0-0-80
  containers:
  - name: eladmin-api
    image: 10.0.0.80:5000/eladmin/eladmin-api:v1
    env:
    - name: DB_HOST   #  指定数据库地址
      value: "10.99.161.76"  #修改成对应的service ip
    - name: DB_USER   #  指定数据库连接使用的用户
      value: "root"
    - name: DB_PWD
      value: "luffyAdmin!"
    - name: REDIS_HOST
      value: "10.99.127.50" #修改成对应的service ip
    - name: REDIS_PORT
      value: "6379"
    ports:
    - containerPort: 8000
  - name: eladmin-web
    image: 10.0.0.80:5000/eladmin/eladmin-web:v1
    ports:
    - containerPort: 80
EOF

# 删除原有Pod
kubectl -n luffy delete pod eladmin
# 重新应用修改后的yaml
kubectl apply -f pod-eladmin.yaml

# 查看eladmin-api容器的报错,原因数据库没有对应的数据
kubectl -n luffy logs eladmin -c eladmin-api

#初始化eladmin-api的数据库
# git clone https://gitee.com/chengkanghua/eladmin.git
cd eladmin
# kubectl cp 宿主机路径 pod名:容器内路径 -c 容器名 -n ns 
kubectl cp sql/eladmin.sql luffy/mysql:/ -c mysql

kubectl -n luffy exec -ti mysql -c mysql -- bash
bash-4.2# mysql -uroot -pluffyAdmin!
mysql> use eladmin
mysql> source /eladmin.sql
mysql> quit
bash-4.2# exit

curl -v http://$(kubectl -n luffy get po -owide |awk 'NR==2{print $8}'):8000/auth/code  
# 正常返回信息
 
#删除之前docker 创建的redis mysql
docker rm -f mysql redis

```



###  添加健康检查 和 资源限制

redis.yaml

```bash
cat <<EOF > redis.yaml
apiVersion: v1
kind: Pod
metadata:
  name: redis
  namespace: luffy
  labels:
    app: redis
spec:
  containers:
  - name: redis
    image: redis:3.2
    ports:
    - containerPort: 6379
    livenessProbe:  #存活性探测
      tcpSocket:
        port: 6379
      initialDelaySeconds: 10  # 容器启动后第一次执行探测是需要等待多少秒
      periodSeconds: 10         # 执行探测的频率
      timeoutSeconds: 2         # 探测超时时间
    readinessProbe:  #可用性探测
      tcpSocket:
        port: 6379
      initialDelaySeconds: 10  # 容器启动后第一次执行探测是需要等待多少秒
      periodSeconds: 10         # 执行探测的频率
      timeoutSeconds: 2         # 探测超时时间
    resources:     #资源限制
      requests:    #满足条件才能调度到对应的woker节点
        memory: 100Mi
        cpu: 50m
      limits:     #运行时候的资源限制
        memory: 1Gi
        cpu: 1
EOF        
        


```



mysql.yaml

```bash
cat <<EOF > mysql.yaml
apiVersion: v1
kind: Pod
metadata:
  name: mysql
  namespace: luffy
  labels:
    app: mysql
spec:
  containers:
  - name: mysql
    image: mysql:5.7
    env:
    - name: MYSQL_DATABASE   #  指定数据库地址
      value: "eladmin"
    - name: MYSQL_ROOT_PASSWORD
      value: "luffyAdmin!"
    ports:
    - containerPort: 3306
    args:
    - --character-set-server=utf8mb4
    - --collation-server=utf8mb4_unicode_ci
    livenessProbe:
      tcpSocket:
        port: 3306
      initialDelaySeconds: 15  # 容器启动后第一次执行探测是需要等待多少秒
      periodSeconds: 10         # 执行探测的频率
      timeoutSeconds: 2         # 探测超时时间
    readinessProbe:
      tcpSocket:
        port: 3306
      initialDelaySeconds: 15  # 容器启动后第一次执行探测是需要等待多少秒
      periodSeconds: 10         # 执行探测的频率
      timeoutSeconds: 2         # 探测超时时间
    resources:
      requests:
        memory: 200Mi
        cpu: 50m
      limits:
        memory: 1Gi
        cpu: 500m
    volumeMounts:
    - name: mysql-data
      mountPath: /var/lib/mysql
  volumes:
  - name: mysql-data
    hostPath:
      path: /opt/mysql/
  nodeSelector:   # 使用节点选择器将Pod调度到指定label的节点
    mysql: "true"
EOF    

```



*eladmin-api.yaml*

```bash
cat <<EOF > eladmin-api.yaml
apiVersion: v1
kind: Pod
metadata:
  name: eladmin-api
  namespace: luffy
  labels:
    app: eladmin-api
spec:
  imagePullSecrets:
  - name: registry-172-16-1-226
  restartPolicy: Always
  containers:
  - name: eladmin-api
    image: 10.0.0.80:5000/eladmin/eladmin-api:v1
    env:
    - name: DB_HOST   #  指定数据库地址
      value: "10.1.14.241"
    - name: DB_USER   #  指定数据库连接使用的用户
      value: "root"
    - name: DB_PWD
      value: "luffyAdmin!"
    - name: REDIS_HOST
      value: "10.105.226.34"
    - name: REDIS_PORT
      value: "6379"
    ports:
    - containerPort: 8000
    livenessProbe:
      tcpSocket:
        port: 8000
      initialDelaySeconds: 20  # 容器启动后第一次执行探测是需要等待多少秒
      periodSeconds: 15     # 执行探测的频率
      timeoutSeconds: 3        # 探测超时时间
    readinessProbe:
      httpGet:
        path: /auth/code
        port: 8000
        scheme: HTTP
      initialDelaySeconds: 20  # 容器启动后第一次执行探测是需要等待多少秒
      periodSeconds: 15     # 执行探测的频率
      timeoutSeconds: 3        # 探测超时时间
    resources:
      requests:
        memory: 200Mi
        cpu: 50m
      limits:
        memory: 1Gi
        cpu: 1
EOF

```



### configMap和Secret

##### ConfigMap

存放**非敏感明文配置**（配置文件、环境变量、启动参数），明文可见，用于统一管理应用配置，避免硬编码写在镜像或 YAML 里。

##### Secret

存放**敏感数据**（密码、密钥、证书、账号），仅做 Base64 编码（非加密），防止明文直接暴露，有 Opaque、kubernetes.io/tls 等类型。

##### 核心区别

1. ConfigMap：明文存储，放普通配置；
2. Secret：Base64 编码，存放账号密码等隐私信息；
3. 二者使用方式一致：可挂载为文件、注入环境变量。



```bash
#configMap
cat <<EOF > configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: eladmin
  namespace: luffy
data:
  DB_HOST: "10.0.0.80"
  DB_USER: "root"
  REDIS_HOST: "10.0.0.80"
  REDIS_PORT: "6379"
EOF

kubectl create -f configmap.yaml
kubectl -n luffy get configmap eladmin -oyaml

#文本创建
cat <<EOF > env-configs.txt
DB_HOST=10.0.0.80
REDIS_HOST=10.0.0.80
REDIS_PORT=6379
EOF
kubectl -n luffy create configmap eladmin --from-env-file=env-configs.txt


#Secret
cat > env-secret.txt <<EOF
DB_PWD=luffyAdmin!
DB_USER=root
EOF
#创建 generic 类型secret
kubectl -n luffy create secret generic eladmin-secret --from-env-file=env-secret.txt 
kubectl -n luffy get secret

#命令行创建 docker-registry secret
kubectl -n luffy create secret docker-registry registry-10-0-0-80 --docker-username=admin --docker-password=admin --docker-email=chengkanghua@foxmail.com --docker-server=10.0.0.80:5000

cat <<EOF >secret.yaml
apiVersion: v1
kind: Secret
metadata:
name: eladmin-secret
  namespace: luffy
type: Opaque
data:
  DB_USER: cm9vdA==        #注意加-n参数， echo -n root|base64
  DB_PWD: bHVmZnlBZG1pbiE=
EOF
----------------------------------------------
kubectl -n luffy create -f secret.yaml
kubectl -n luffy get secret

# 从配置中引用环境变量
# mysql的pod
...
  containers:
  - name: mysql
    image: mysql:5.7
    env:
    - name: MYSQL_DATABASE   #  指定数据库地址
      value: "eladmin"
    - name: MYSQL_ROOT_PASSWORD
      valueFrom:
        secretKeyRef:
          name: eladmin-secret
          key: DB_PWD
    ports:
    - containerPort: 3306
...

# eladmin-api的yaml
...
  containers:
  - name: eladmin-api
    image: 10.0.0.80:5000/eladmin/eladmin-api:v1
    env:
    - name: DB_HOST   #  指定数据库地址
      valueFrom:
        configMapKeyRef:
          name: eladmin
          key: DB_HOST
    - name: DB_USER   #  指定数据库连接使用的用户
      valueFrom:
        secretKeyRef:
          name: eladmin-secret
          key: DB_USER
    - name: DB_PWD
      valueFrom:
        secretKeyRef:
          name: eladmin-secret
          key: DB_PWD
    - name: REDIS_HOST
      valueFrom:
        configMapKeyRef:
          name: eladmin
          key: REDIS_HOST
    - name: REDIS_PORT
      valueFrom:
        configMapKeyRef:
          name: eladmin
          key: REDIS_PORT
    ports:
    - containerPort: 8000
...


在部署不同的环境时，pod的yaml无须再变化，只需要在每套环境中维护一套ConfigMap和Secret即可。但是注意configmap和secret不能跨namespace使用，且更新后，pod内的env不会自动更新，重建后方可更新。
```

### 如何编写资源yaml

1. 拿来主义，从机器中已有的资源中拿

   ```bash
   $ kubectl -n kube-system get po,deployment,dsCopyErrorOK!
   ```

2. 学会在官网查找， https://kubernetes.io/docs/home/

3. 从kubernetes-api文档中查找， https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#pod-v1-core

4. kubectl explain 查看具体字段含义



### pod的生命周期 🎯

> 状态速查直接看前面【三、Pod 状态】表（Pending / ContainerCreating / Running / Succeeded / Failed / CrashLoopBackOff / ErrImagePull / Unknown / Evicted），此处不重复罗列。

#### 一、Pod 内部组成

1. **infra（Pause）基础设施容器**：最先创建，统一持有 Pod 网络、PID、IPC 命名空间，作为 Pod 生命周期锚点。
2. **init 初始化容器**：顺序执行、一次性任务，必须全部执行成功退出后，才会启动业务主容器。
3. **main 业务主容器**：常驻运行的业务容器，配置生命周期钩子 + 两种健康探针。

#### 二、执行时间线顺序 🎯

```
Pause 容器 → Init 容器（须全部成功）→ main 主容器 → postStart → 周期性探针 →（删除时）preStop → 优雅退出
```

> ⚠️ **preStop 易错点**：只有**主动删除 Pod** 才会触发 `preStop`；Pod 自己崩溃退出不会触发，且要求进程当时处于正常运行状态。

#### 三、核心作用精简总结

1. Init 容器：业务前置初始化（拉配置、等待中间件就绪）；
2. postStart：容器启动后初始化操作；
3. preStop：容器销毁前优雅下线、释放资源；
4. 就绪探针：控制流量是否转发到当前 Pod；
5. 存活探针：异常容器自动重启，保障服务可用性。

#### 验证Pod生命周期：

```yaml
cat <<EOF >pod-lifecycle.yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-lifecycle
  labels:
    component: pod-lifecycless
spec:
  initContainers:
  - name: init
    image: busybox
    command: ['sh', '-c', 'echo $(date +%s): INIT >> /loap/timing']
    volumeMounts:
    - mountPath: /loap
      name: timing
  containers:
  - name: main
    image: busybox
    command: ['sh', '-c', 'echo $(date +%s): START >> /loap/timing;sleep 10; echo $(date +%s): END >> /loap/timing;']
    volumeMounts:
    - mountPath: /loap 
      name: timing
    livenessProbe:
      exec:
        command: ['sh', '-c', 'echo $(date +%s): LIVENESS >> /loap/timing']
    readinessProbe:
      exec:
        command: ['sh', '-c', 'echo $(date +%s): READINESS >> /loap/timing']
    lifecycle:
      postStart:
        exec:
          command: ['sh', '-c', 'echo $(date +%s): POST-START >> /loap/timing']
      preStop:
        exec:
          command: ['sh', '-c', 'echo $(date +%s): PRE-STOP >> /loap/timing']
  volumes:
  - name: timing
    hostPath:
      path: /tmp/loap
EOF

kubectl create -f pod-lifecycle.yaml

kubectl  get po -o wide -w

## 查看调度节点的/tmp/loap/timing
$ cat /tmp/loap/timing
1585424708: INIT
1585424746: START
1585424746: POST-START
1585424754: READINESS
1585424756: LIVENESS
1585424756: END



```

## [Pod操作小结](https://docs.chengkanghua.top/k8s-2023/3Kubernetes落地实践之旅?id=pod操作小结)

1. 实现k8s平台与特定的容器运行时解耦，提供更加灵活的业务部署方式，引入了Pod概念，作为k8s平台中业务服务运行时的最小调度单元
2. k8s使用yaml格式定义资源文件，yaml比json更加简洁
3. 通过kubectl create|apply| get | exec | logs | delete 等操作k8s资源，必须指定namespace
4. 每启动一个Pod，为了实现网络空间共享，会先创建pause容器，并把其他容器网络加入该容器，来实现Pod内所有容器使用同一个网络空间
5. 通过nodeSelector选择器影响k8s的调度行为，实现服务定点部署
6. Pod重建后Pod IP发生变化，所以使用Service类型的资源为Pod创建上层的VIP对外提供服务
7. 通过livenessProbe和readinessProbe实现Pod的存活性和就绪健康检查
8. 通过requests和limit分别限定容器初始资源申请与最高上限资源申请
9. 通过configMap和Secret来管理业务应用所需的配置（包含环境变量和配置文件等）
10. Pod通过initContainer和lifecycle分别来执行初始化、pod启动和删除时候的操作，使得功能更加全面和灵活
11. 编写yaml讲究方法，学习k8s，养成从官方网站查询知识的习惯



## K8s Workload（工作负载)

### 一、定义 🎯

工作负载 = 集群上运行应用的各类资源对象，用来管理 Pod 的创建、调度、扩缩容、自愈、滚动更新等生命周期。**它自己不跑业务，只负责管控 Pod**。

### 二、常用工作负载分类 🎯

#### 1. Deployment（最常用，无状态服务）

- 适用：微服务、Nginx、后端 API 等无状态应用
- 核心能力：副本扩缩容、滚动更新 / 回滚、故障自愈（节点故障自动重建 Pod）
- 通过 ReplicaSet 控制器维持指定 Pod 副本数

```txt
ReplicaSet 是底层副本控制器，不属于用户层面的工作负载；它只负责维持 Pod 副本数量，Deployment 封装了 RS，额外提供滚动更新、版本回滚能力，是我们日常使用的无状态工作负载。
```



#### 2. StatefulSet（有状态服务）

- 适用：MySQL、Redis、Elasticsearch 等需要稳定网络标识、持久存储的应用
- 特点：Pod 有序创建 / 删除、固定主机名、稳定网络身份、持久卷一一绑定

#### 3. DaemonSet

- 适用：节点级组件（日志采集、监控、网络插件 flannel、kube-proxy）
- 特点：集群**每个节点只会运行 1 个 Pod**，新节点加入自动部署该 Pod

#### 4. Job & CronJob

1. **Job**：一次性任务，任务执行成功就结束，不重启；适合数据备份、批量脚本
2. **CronJob**：定时 Job，基于 Cron 表达式周期性执行任务；适合定时备份、定时统计

#### 5. 裸 Pod（直接创建 Pod，不属于控制器）

- 不受工作负载管控，节点故障不会自动重建，一般仅用于临时测试，生产禁止使用。

### 三、核心区别精简总结

| 工作负载    | 使用场景                   | 核心特性                         |
| :---------- | :------------------------- | :------------------------------- |
| Deployment  | 无状态业务服务             | 滚动更新、弹性扩缩、自愈         |
| StatefulSet | 数据库、中间件等有状态应用 | 有序部署、稳定网络、持久存储绑定 |
| DaemonSet   | 节点日志、监控、网络组件   | 每个节点仅部署一个 Pod           |
| Job         | 一次性批处理任务           | 执行完成即终止                   |
| CronJob     | 定时任务                   | 按周期重复执行 Job               |



## deployment改造

```bash

cat <<EOF >deployment-mysql.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  namespace: luffy
spec:
  replicas: 1    #指定Pod副本数
  strategy:
    type: Recreate  # 重建策略，先删旧Pod再启新Pod
  selector:        #指定Pod的选择器
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:    #给Pod打label,必须和上方的matchLabels匹配
        app: mysql
        from: luffy
    spec:
      containers:
      - name: mysql
        image: mysql:5.7
        args:
        - --character-set-server=utf8mb4
        - --collation-server=utf8mb4_unicode_ci
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: eladmin-secret
              key: DB_PWD
        - name: MYSQL_DATABASE
          value: "eladmin"
        resources:
          requests:
            memory: 200Mi
            cpu: 50m
          limits:
            memory: 1Gi
            cpu: 500m
        readinessProbe:
          tcpSocket:
            port: 3306
          initialDelaySeconds: 60
          periodSeconds: 10
        livenessProbe:
          tcpSocket:
            port: 3306
          initialDelaySeconds: 80
          periodSeconds: 20
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
      volumes: 
      - name: mysql-data
        hostPath: 
          path: /opt/mysql/
      nodeSelector:   # 使用节点选择器将Pod调度到指定label的节点
        mysql: "true"
EOF
# 指定节点打标签
# kubectl label node k8s-slave1 mysql=true

kubectl -n luffy delete po mysql
#kubectl apply -f deployment-mysql.yaml


#关联的配置 secret
cat > env-secret.txt <<EOF
DB_PWD=luffyAdmin!
DB_USER=root
EOF

#创建 generic 类型secret
kubectl -n luffy create secret generic eladmin-secret --from-env-file=env-secret.txt 
kubectl -n luffy get secret


# ---扩展
kubectl -n luffy get pod -owide  #容器status 报错
# Pod 命名规则：Deployment名称 + ReplicaSet随机字符串 + Pod随机字符串

# 实时监控pod的状态
watch -d kubectl -n luffy get po -owide

kubectl -n luffy  describe pod mysql-858f99d446-677vh  #查看详细报错

kubectl logs -f pod名 -n ns
kubectl -n luffy logs -f mysql-554f987884-hj4dh 
kubectl -n luffy logs mysql-554f987884-hj4dh 


# kubectl rollout restart deployment mysql -n luffy #之前旧的po没被删除, 
# kubectl -n luffy delete po mysql-74ccd5c999-gb87j mysql-858f99d446-677vh

kubectl -n luffy  get pod mysql-858f99d446-sztjs -o yaml #查看运行时Pod配置详细状态

kubectl -n luffy exec -it mysql-858f99d446-sztjs -- /bin/sh  #进容器里调试
kubectl -n luffy get events  
# 查看 luffy 命名空间 下集群最近发生的所有资源事件，是 K8s 排错的第一优先级命令，记录 Pod 调度、镜像拉取、容器启停、探针失败、重启、资源报错等所有关键动作，事件默认仅保存1 小时

# 实时监听事件滚动重启全过程
kubectl -n luffy get events -w
字段			含义
LAST SEEN	该事件最近一次发生距离现在多久
TYPE		Normal正常事件 / Warning警告异常事件（重点看 Warning）
REASON		事件简短原因（Scheduled、Pulling、ReadinessGatesFailed、BackOff 等）
OBJECT		发生事件的资源（一般是 pod/Deployment）
MESSAGE		详细描述，直接告诉你失败原因

常见关键事件
Scheduled：Pod 	调度成功到某个节点
Pulling/Pulled：	正在拉取 / 拉取完成镜像
Created/Started：容器创建、启动成功
Readiness probe failed：就绪探针失败（你现在 MySQL 新旧 Pod 共存的根本原因）
Liveness probe failed：存活探针失败，容器会被重启
BackOff：容器反复崩溃，进入重启退避（CrashLoopBackOff）
Evicted：节点资源不足，Pod 被驱逐


cat <<EOF > deployment-redis.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  namespace: luffy
spec:
  replicas: 1    #指定Pod副本数
  selector:        #指定Pod的选择器
    matchLabels:
      app: redis
  template:
    metadata:
      labels:    #给Pod打label,必须和上方的matchLabels匹配
        app: redis
    spec:
      containers:
      - name: redis
        image: redis:3.2
        ports:
        - containerPort: 6379
        resources:
          requests:
            memory: 100Mi
            cpu: 50m
          limits:
            memory: 1Gi
            cpu: 500m
        readinessProbe:
          tcpSocket:
            port: 6379
          initialDelaySeconds: 30
          periodSeconds: 10
        livenessProbe:
          tcpSocket:
            port: 6379
          initialDelaySeconds: 60
          periodSeconds: 20
EOF

cat <<EOF > deploy-eladmin.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: eladmin
  namespace: luffy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: eladmin-api
  template:
    metadata:
      labels:
        app: eladmin-api
    spec:
      imagePullSecrets:
      - name: registry-10-0-0-80
      containers:
      # 后端API容器
      - name: eladmin-api
        image: 10.0.0.80:5000/eladmin/eladmin-api:v1
        imagePullPolicy: IfNotPresent
        env:
        - name: DB_HOST
          valueFrom:
            configMapKeyRef:
              name: eladmin
              key: DB_HOST
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: eladmin-secret
              key: DB_USER
        - name: DB_PWD
          valueFrom:
            secretKeyRef:
              name: eladmin-secret
              key: DB_PWD
        - name: REDIS_HOST
          valueFrom:
            configMapKeyRef:
              name: eladmin
              key: REDIS_HOST
        - name: REDIS_PORT
          valueFrom:
            configMapKeyRef:
              name: eladmin
              key: REDIS_PORT
        ports:
        - containerPort: 8000
        resources:
          requests:
            memory: 200Mi
            cpu: 50m
          limits:
            memory: 1Gi
            cpu: 2
        livenessProbe:
          tcpSocket:
            port: 8000
          initialDelaySeconds: 20  # 容器启动后第一次执行探测是需要等待多少秒
          periodSeconds: 15           # 执行探测的频率
          timeoutSeconds: 3         # 探测超时时间
        readinessProbe:
          httpGet:
            path: /auth/code
            port: 8000
            scheme: HTTP
          initialDelaySeconds: 20
          timeoutSeconds: 3
          periodSeconds: 15

      # 前端WEB容器（补齐同规格配置）
      - name: eladmin-web
        image: 10.0.0.80:5000/eladmin/eladmin-web:v1
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
        # 资源配额，和后端保持对齐
        resources:
          requests:
            memory: 200Mi
            cpu: 50m
          limits:
            memory: 1Gi
            cpu: 2
        # 存活探针：检测80端口是否监听
        livenessProbe:
          tcpSocket:
            port: 80
          initialDelaySeconds: 20
          periodSeconds: 15
          timeoutSeconds: 3
        # 就绪探针：HTTP检测首页
        readinessProbe:
          httpGet:
            path: /
            port: 80
            scheme: HTTP
          initialDelaySeconds: 20
          timeoutSeconds: 3
          periodSeconds: 15
EOF

#关联的配置 secret
cat > env-secret.txt <<EOF
DB_PWD=luffyAdmin!
DB_USER=root
EOF

#创建 generic 类型secret
kubectl -n luffy create secret generic eladmin-secret --from-env-file=env-secret.txt 
kubectl -n luffy get secret


# 关联的cofnigmap ;修改对应的ip地址
cat <<EOF > configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: eladmin
  namespace: luffy
data:
  DB_HOST: "10.99.161.76"
  DB_USER: "root"
  REDIS_HOST: "10.99.127.50"
  REDIS_PORT: "6379"
EOF

# kubectl -n luffy get svc

kubectl create -f configmap.yaml
kubectl -n luffy get configmap   #查看configmap


kubectl -n luffy edit configmap eladmin  #在线修改configmap
kubectl -n luffy get configmap eladmin -oyaml  #查看配置



kubectl -n luffy delete pod eladmin
kubectl -n luffy delete pod mysql
kubectl -n luffy delete pod redis

# 创建Deployment
kubectl create -f deployment-redis.yaml
kubectl create -f deployment-mysql.yaml
kubectl create -f deploy-eladmin.yaml

#查看服务是否正常
curl -v http://$(kubectl -n luffy get po -owide |awk 'NR==2{print $6}'):8000/auth/code  


# 查看deployment
# kubectl api-resources
$ kubectl -n luffy get deploy
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
eladmin-api   1/1     1            1           6m41s
mysql         1/1     1            1           27m
redis         1/1     1            1           90s

  * `NAME` 列出了集群中 Deployments 的名称。
  * `READY`显示当前正在运行的副本数/期望的副本数。
  * `UP-TO-DATE`显示已更新以实现期望状态的副本数。
  * `AVAILABLE`显示应用程序可供用户使用的副本数。
  * `AGE` 显示应用程序运行的时间量。

kubectl -n luffy get deploy -owide

# 查看pod
kubectl -n luffy get po -owide

# 查看replicaSet
# ReplicaSet（简称 RS）是底层副本控制器，核心职责：
# 持续保证集群中指定数量的 Pod 副本正常运行；
# Pod 被删除、节点故障时，自动新建 Pod 补齐副本，实现应用自愈。
kubectl -n luffy get rs


```



### 副本保障机制

controller实时检测pod状态，并保障副本数一直处于期望的值。

```bash
## 删除pod，观察pod状态变化
kubectl -n luffy delete pod eladmin-6d78477cc5-kkfv5

# 观察pod
kubectl -n luffy get pod -w
kubectl -n luffy get pods -o wide -w

# 设置两个副本, 或者通过kubectl -n luffy edit deploy eladmin-api的方式，
# 最好通过修改文件，然后apply的方式，这样yaml文件可以保持同步
kubectl -n luffy scale deploy redis --replicas=2

# 观察pod
kubectl -n luffy get pod -w

```



### 服务更新

```bash
修改服务，重新打tag模拟服务更新。

修改文件测试：
#进入 cd eladmin
docker build . -t 10.0.0.80:5000/eladmin/eladmin-api:v2 -f Dockerfile.multi
docker push 10.0.0.80:5000/eladmin/eladmin-api:v2

更新方式：
# 1. 修改yaml文件，然后apply更新应用
kubectl -n luffy apply -f deploy-eladmin.yaml

# 2 直接在线更新
kubectl -n luffy edit deploy eladmin

# 3 命令更新
kubectl -n luffy set image deploy eladmin-api eladmin-api=10.0.0.80:5000/eladmin/eladmin-api:v2 --record



```



### [Deployment 滚动更新策略（RollingUpdate）](https://docs.chengkanghua.top/k8s-2023/3Kubernetes落地实践之旅?id=滚动更新) 🎯

默认策略 `RollingUpdate`：**新旧 Pod 逐步替换，不停机发布**，由两个参数控制"并发幅度"（都支持百分比 / 绝对数字）。

| 参数 | 含义 | 示例（replicas=10） |
| --- | --- | --- |
| `maxSurge` | 滚动期**最多能多创建**几个新 Pod | `20%` → 最多临时多 2 个，集群瞬时 12 个 |
| `maxUnavailable` | 滚动期**最多能同时下线**几个旧 Pod | `20%` → 最多停 2 个，至少 8 个对外服务 |

> 🎯 **面试高频**：怎么做到"发布零中断"？配 `maxSurge: 1` + `maxUnavailable: 0` —— 先起新 Pod，就绪后再删旧 Pod。
> 反过来，MySQL / Redis 这类单实例有状态服务要用 `type: Recreate`（先删后建），避免新旧 Pod 同时抢占本地存储。

默认值

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 25%
    maxUnavailable: 25%
    
常用生产配置
1. 追求高可用（推荐业务服务）
rollingUpdate:
  maxSurge: 1
  maxUnavailable: 0
  
不会同时下线任何旧 Pod，先启新、新就绪再删旧，零业务中断。

2. 单实例 MySQL/Redis（必须用重建策略，不要滚动）
strategy:
  type: Recreate
  
先删除所有旧 Pod，再启动新 Pod，避免新旧 Pod 同时抢占本地存储、端口冲突。
```





```bash
...
spec:
  replicas: 2    #指定Pod副本数
  selector:        #指定Pod的选择器
    matchLabels:
      app: eladmin-api
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate        #指定更新方式为滚动更新，默认策略，通过get deploy yaml查看
    ...
    
---------------修改后完整版
cat <<EOF > deploy-eladmin-api.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: eladmin-api
  namespace: luffy
spec:
  replicas: 2    #指定Pod副本数
  selector:        #指定Pod的选择器
    matchLabels:
      app: eladmin-api
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate        #指定更新方式为滚动更新，默认策略，通过get deploy yaml查看
  template:
    metadata:
      labels:    #给Pod打label
        app: eladmin-api
    spec:
      imagePullSecrets:
      - name: registry-10-0-0-80
      containers:
      - name: eladmin-api
        image: 10.0.0.80:5000/eladmin/eladmin-api:v1
        imagePullPolicy: IfNotPresent
        env:
        - name: DB_HOST
          valueFrom:
            configMapKeyRef:
              name: eladmin
              key: DB_HOST
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: eladmin-secret
              key: DB_USER
        - name: DB_PWD
          valueFrom:
            secretKeyRef:
              name: eladmin-secret
              key: DB_PWD
        - name: REDIS_HOST
          valueFrom:
            configMapKeyRef:
              name: eladmin
              key: REDIS_HOST
        - name: REDIS_PORT
          valueFrom:
            configMapKeyRef:
              name: eladmin
              key: REDIS_PORT
        ports:
        - containerPort: 8000
        resources:
          requests:
            memory: 200Mi
            cpu: 50m
          limits:
            memory: 1Gi
            cpu: 2
        livenessProbe:
          tcpSocket:
            port: 8000
          initialDelaySeconds: 20  # 容器启动后第一次执行探测是需要等待多少秒
          periodSeconds: 15     # 执行探测的频率
          timeoutSeconds: 3        # 探测超时时间
        readinessProbe:
          httpGet:
            path: /auth/code
            port: 8000
            scheme: HTTP
          initialDelaySeconds: 20
          timeoutSeconds: 3
          periodSeconds: 15
EOF

kubectl apply -f deploy-eladmin-api.yaml
    

```



### 更新策略 先删后建

```bash
...
  strategy:
    type: Recreate
...

前面deploy mysql就是这个策略


```

### 服务回滚 🎯

滚动升级出问题时，用回滚机制快速退回上一个能正常工作的版本。

**revision**：每次更新都会记录一个版本号，可回滚到指定 revision；默认只保留最近 **10** 个，通过 `spec.revisionHistoryLimit` 调整。

> 🎯 `kubectl rollout history` 看历史 → `kubectl rollout undo deploy/xxx --to-revision=N` 回滚到指定版本。



```bash
#查看当前
kubectl -n luffy  rollout history deployment redis
kubectl -n luffy  rollout history deployment eladmin

# kubectl delete -f deploy-eladmin-api.yaml    ## 方便演示到具体效果，删掉已有deployment

# 记录回滚：
# 修改了配置文件, apply -f 之后也会记录到历史版本中
$ kubectl apply -f deploy-eladmin.yaml --record
$ kubectl -n luffy edit deploy eladmin --record=true  #镜像名v1 修改成v2

#再次查看历史记录
[root@k8s-master eladmin]# kubectl -n luffy rollout history deploy eladmin
deployment.apps/eladmin
REVISION  CHANGE-CAUSE
1         <none>
2         <none>

回滚到具体的REVISION:
$ kubectl -n luffy rollout undo deploy eladmin --to-revision=1
deployment.apps/eladmin-api rolled back

# 访问应用测试





```



### Service基础 🎯

#### 一、Service 核心作用

1. **固定访问入口**：Pod IP 会随重建 / 调度 / 故障变化，Service 提供**稳定虚拟 ClusterIP**，通过标签自动关联一组 Pod；
2. **负载均衡**：把请求分发到后端所有**就绪**的 Pod；
3. **服务发现**：集群内可通过 `服务名.命名空间.svc.cluster.local` 互相访问；
4. **解耦**：客户端只认 Service，不用关心 Pod 真实 IP。

#### 二、Service 四种类型 🎯

#### 1. ClusterIP（默认类型，集群内部访问）

- 分配集群内虚拟 IP，**仅集群内部 Pod、节点能访问**，外网无法访问。
- 集群内访问方式：
  - `ClusterIP:端口`
  - `服务名:端口`（同命名空间）
  - `服务名.luffy.svc.cluster.local:端口`（跨命名空间）

```yaml
spec:
  type: ClusterIP
  selector:
    app: eladmin
  ports:
  - port: 80        # Service暴露端口（集群访问用）
    targetPort: 80  # 后端Pod容器端口
    
# `port`：Service 端口；`targetPort`：Pod 容器端口；两个可以不一致。    
    

cat <<EOF >service-eladmin-api.yaml
apiVersion: v1
kind: Service
metadata:
  name: eladmin-api
  namespace: luffy
spec:
  ports:
  - port: 8000
    protocol: TCP
    targetPort: 8000
  selector:
    app: eladmin-api
  type: ClusterIP
EOF

操作演示：
## 别名
alias kd='kubectl -n luffy'

## 创建服务
kd create -f service-eladmin-api.yaml
kd get po --show-labels
kd get svc
kd describe svc eladmin-api


## 扩容eladmin-api服务
kd scale deploy eladmin --replicas=2

## 再次查看 service后关联的Endpoints
kd describe svc eladmin-api
# kubectl -n luffy describe service eladmin-api

# Service与Pod如何关联:
service对象创建的同时，会创建同名的endpoints对象，若服务设置了readinessProbe, 
当readinessProbe检测失败时，endpoints列表中会剔除掉对应的pod_ip，
这样流量就不会分发到健康检测失败的Pod中

Service 通过 spec.selector 匹配 Pod 上的标签，自动维护后端 Endpoint 列表。
只有 Pod 标签完全匹配，才会被加入 Service 负载均衡后端。
# 查看后端真实 Pod 端点：
kubectl -n luffy get endpoints eladmin-api

常用命令
kubectl -n luffy get svc
kubectl -n luffy describe svc eladmin-api
kubectl -n luffy get svc eladmin -o yaml

Service Cluster-IP如何访问:
# 查看Cluster-IP
kubectl -n luffy get svc eladmin-api

curl -v $(kubectl -n luffy get svc eladmin-api |awk 'NR==2{print $3}'):8000/auth/code
### 业务自身支持localhost:8000/auth/code -> pod-ip:8000/auth/code -> service-cluster-ip:8000/auth/code



关键知识点
Service 不监听宿主机网卡，ClusterIP 只能在集群内部路由访问。
Service 四层负载均衡（TCP/UDP），不支持 HTTP 路径、域名转发，七层转发用 Ingress。
没有 selector 的 Service：不会自动关联 Pod，一般用来手动维护 Endpoint 对接外部中间件。
同一个 Service 可以配置多组端口，实现多端口转发。

常用配置示例
apiVersion: v1
kind: Service
metadata:
  name: eladmin
  namespace: luffy
spec:
  type: ClusterIP
  selector:
    app: eladmin
  ports:
  - port: 80
    targetPort: 80
  - port: 8000
    targetPort: 8000
    

```



##### 一、Endpoint（服务后端真实地址）

###### 1. 作用

Service 不会直接绑定 Pod，而是通过 **Endpoint** 保存所有匹配标签、且状态就绪的 Pod 的`IP+容器端口`列表，kube-proxy 根据 Endpoint 配置集群内负载均衡规则。

###### 2. 自动生成规则

1. Service 配置了 `selector` → K8s 自动创建同名 Endpoint；
2. Pod 标签匹配 `selector` + Pod 状态 `Ready` → 该 Pod IP 会写入 Endpoint；
3. Pod 未就绪、标签不匹配，不会进入 Endpoint，不会接收流量；
4. Pod 重建 IP 变化，Endpoint 会自动实时更新。

###### 3. 常用命令

```bash
# 查看当前Service后端真实Pod地址
kubectl -n luffy get endpoints eladmin
# 详细查看端点信息
kubectl -n luffy describe endpoints eladmin
```

###### 4. 无 Selector 的 Service（手动维护 Endpoint）

场景：对接集群外部 MySQL、Redis 等第三方服务

1. Service 不写`selector`，不会自动生成 Endpoint；
2. 手动创建同名 Endpoint，写入外部服务 IP + 端口；
3. 集群内通过 Service 名称访问外部服务，统一收口配置。

示例:

```yaml
# Service
apiVersion: v1
kind: Service
metadata:
  name: mysql
  namespace: luffy
spec:
  type: ClusterIP
  ports:
  - port: 3306
    targetPort: 3306
---
# 手动Endpoint
apiVersion: v1
kind: Endpoints
metadata:
  name: mysql
  namespace: luffy
subsets:
- addresses:
  - ip: 10.99.161.76
  ports:
  - port: 3306
```

##### 二、Headless Service（无头服务）

###### 1. 定义

不分配`ClusterIP`的 Service：`spec.clusterIP: None`，不做四层负载均衡，只做**服务发现 DNS 解析**。

###### 2. 普通 Service vs Headless Service

- 普通 ClusterIP Service：DNS 解析到唯一虚拟 ClusterIP，流量负载均衡转发到后端 Pod；
- Headless Service：DNS 直接解析出**所有后端就绪 Pod 的 IP 列表**，客户端拿到所有 Pod 真实 IP，自己做负载均衡。

###### 3. 适用场景

1. StatefulSet（有状态应用：MySQL 主从、Redis 集群、MongoDB），需要固定网络标识、逐个节点发现；
2. 应用需要直连每个 Pod，不能经过 Service 四层代理。

###### 4. 访问方式

同命名空间：`pod名称.服务名.命名空间.svc.cluster.local`

示例：`mysql-0.mysql.luffy.svc.cluster.local`

###### 5. 标准 yaml 示例

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql-headless
  namespace: luffy
spec:
  selector:
    app: mysql
  clusterIP: None  # 开启无头服务
  ports:
  - port: 3306
    targetPort: 3306
```

###### 6. 核心特点

1. 没有 ClusterIP，kube-proxy 不会为其生成 iptables/ipvs 转发规则；
2. DNS 查询直接返回所有后端 Pod IP；
3. 配合 StatefulSet 使用，每个 Pod 拥有稳定唯一的 DNS 域名。



###### 三、补充高频易错点

1. Service 能访问不通，优先排查两点：
   - Pod 标签是否和 Service 的 selector 完全一致；
   - Endpoint 里是否存在对应的 Pod IP（为空 = 标签不匹配或 Pod 未就绪）。
2. Headless Service 也可以不写 selector，手动配置 Endpoint 对接外部集群节点。
3. 有状态应用必须用 Headless + StatefulSet，无状态 Deployment 用普通 ClusterIP 即可。



*思考：为何访问cluster-ip可以成功访问到pod的服务*

```bash
kube-proxy --> dnat-->snat

#kube-proxy组件是安装在kube-system命名空间下
#是一个进程 
kubectl -n kube-system get pod -o wide
kubectl -n kube-system logs -f kube-proxy-gmmlv  #改成当前主机的kube-proxy 容器名
#日志里显示是 using iptables proxier

```



#### kube-proxy 三种工作模式详解 🎯

> kube-proxy 跑在**每个 Node 上**：监听 Service / Endpoint 变化 → 在节点写入内核转发规则 → 实现 Service 到后端 Pod 的负载均衡。

##### 一、userspace（已淘汰，仅作了解）

**原理**：节点监听随机高端端口 → iptables 把访问 ClusterIP 的流量转给本机 kube-proxy 进程 → **在用户态**做负载均衡再转发给 Pod。

**缺点**：用户态 ↔ 内核态频繁切换，性能极差；v1.2 之后彻底弃用，生产没人用。

##### 二、iptables（v1.2～v1.8 默认，兼容性最好）

**原理**：监听 Service / Endpoint 变更 → 在节点内核写入大量 `iptables NAT` 规则 → 流量在**内核态**直接完成转发，不经过 kube-proxy 进程。

- **负载均衡**：**随机**转发到任一就绪 Pod
- **优点**：性能远高于 userspace；不需要额外内核模块，所有 Linux 原生支持
- **缺点**：Service / Pod 一多，规则数暴涨（上万条后遍历变慢）；只支持随机，不支持会话保持、轮询、最小连接

 排查命令

```
# 查看节点上Service对应的iptables规则
iptables -t nat -L KUBE-SERVICES -n
```

##### 三、ipvs（v1.8+ 推荐，生产首选）

**原理**：基于内核 IPVS 模块，kube-proxy 只维护虚拟服务列表，不生成海量 iptables 规则，流量由 IPVS 内核模块直接转发。

**调度算法（核心优势）**：`rr` 轮询（默认）／`wrr` 加权轮询／`lc` 最小连接／`sh` **源地址哈希（会话保持）**／`dh` 目标地址哈希。

- **优点**：规则少，海量 Service 下性能远优于 iptables；调度策略丰富；内核级转发、延迟低
- **缺点**：需要内核开启 `ip_vs` 模块（精简系统要手动加载）；老旧系统兼容性略差

###### 查看当前节点 ipvs 规则

```
ipvsadm -Ln
```

##### 四、三种模式核心对比表

| 模式      | 性能 | 负载均衡策略                      | 规则实现               | 适用场景                       |
| :-------- | :--- | :-------------------------------- | :--------------------- | :----------------------------- |
| userspace | 极差 | 随机                              | iptables + 用户进程    | 淘汰，仅学习                   |
| iptables  | 良好 | 随机                              | 海量 iptables NAT 规则 | 小规模集群、兼容老旧系统       |
| ipvs      | 优秀 | 轮询 / 加权 / 最小连接 / 源哈希等 | IPVS 内核模块          | 中大规模生产集群、需要会话保持 |

##### 五、切换 kube-proxy 模式操作（v1.24 集群）

1. 修改 kube-proxy 配置 ConfigMap

```
kubectl edit configmap kube-proxy -n kube-system
```

找到 `mode: "iptables"`，改为 `mode: "ipvs"`

2. 重启所有 kube-proxy Pod 生效

```
kubectl rollout restart daemonset kube-proxy -n kube-system
```

1. 验证当前模式

```
kubectl get configmap kube-proxy -n kube-system -o jsonpath='{.data.config}' | grep mode
```

##### 六、补充关键知识点 🎯

1. **ClusterIP 是虚拟 IP**，只存在于节点的转发规则中、没有网卡绑定，所以默认 ping 不通（只能按 TCP/UDP 访问服务端口）；
2. ipvs 模式下仍会用少量 iptables 做端口屏蔽、流量过滤，**不会完全抛弃 iptables**；
3. 会话保持场景（登录态、长连接）必须用 ipvs 的 `sh` 源哈希调度。



```bash
kubectl -n luffy get service eladmin-api
#获取cluster ip
iptables-save |grep $(kubectl -n luffy get service eladmin-api |awk 'NR==2{print $3}')

$ iptables-save |grep $(kubectl -n luffy get service eladmin-api |awk 'NR==2{print $3}')
# iptables-save |grep eladmin-api| grep $(kubectl -n luffy get service eladmin-api |awk 'NR==2{print $3}')
-------------------------------------------------------------------------------
-A KUBE-SERVICES -d 10.99.182.32/32 -p tcp -m comment --comment "luffy/eladmin-api cluster IP" -m tcp --dport 8000 -j KUBE-SVC-DTK5GE7MKO2S7DFZ
-A KUBE-SVC-DTK5GE7MKO2S7DFZ ! -s 10.244.0.0/16 -d 10.99.182.32/32 -p tcp -m comment --comment "luffy/eladmin-api cluster IP" -m tcp --dport 8000 -j KUBE-MARK-MASQ

$ iptables-save |grep -v MASQ |grep KUBE-SVC-DTK5GE7MKO2S7DFZ
-A KUBE-SVC-DTK5GE7MKO2S7DFZ -m comment --comment "luffy/eladmin-api -> 10.244.0.15:8000" -m statistic --mode random --probability 0.33333333349 -j KUBE-SEP-FYSS62BM2LFBPSMX
# --probability 0.33333333349  表示负载均衡分配概率30%
-A KUBE-SVC-DTK5GE7MKO2S7DFZ -m comment --comment "luffy/eladmin-api -> 10.244.0.15:8000" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-FYSS62BM2LFBPNZO
-A KUBE-SVC-DTK5GE7MKO2S7DFZ -m comment --comment "luffy/eladmin-api -> 10.244.2.38:8000" -j KUBE-SEP-MYTXET6SGXYSFLWJ

# 随机分配模式3个pod 概率：30%--》50%--》100%
# 随机分配模式4个pod 概率：25%--》33%--》50%--》100%

$  iptables-save |grep KUBE-SEP-GB5GNOM5CZH7ICXZ
-A KUBE-SEP-GB5GNOM5CZH7ICXZ -p tcp -m tcp -j DNAT --to-destination 10.244.1.158:8002

$ iptables-save |grep KUBE-SEP-7GWC3FN2JI5KLE47
-A KUBE-SEP-7GWC3FN2JI5KLE47 -p tcp -m tcp -j DNAT --to-destination 10.244.1.159:8002

```



> 🎯 **面试题：K8s 的 Service ClusterIP 能不能 ping 通？**

**iptables 模式 → ping 不通**：kube-proxy 只写了针对 TCP/UDP 的 DNAT 规则，ClusterIP 是纯规则里的虚拟 IP、**没有网卡绑定**；ping 走的是 ICMP 协议，规则不命中，所以不通（但 `curl ClusterIP:端口` 是正常的）。

**ipvs 模式 → 能 ping 通**：IPVS 会在节点创建虚拟网卡 `kube-ipvs0` 并把 ClusterIP 绑上去（`ip a s kube-ipvs0` 可查到该网卡和 IP），有真实网卡所以能响应 ICMP。

> 结论：**ping 不通 ≠ 服务不可用**。ClusterIP 是四层转发规则中的虚拟地址，判断服务是否正常要用 `curl` / `nc` 测端口，不要用 ping。

**iptables转换ipvs模式**

```bash
# 内核开启ipvs模块，集群各节点都执行
cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
ipvs_modules="ip_vs ip_vs_lc ip_vs_wlc ip_vs_rr ip_vs_wrr ip_vs_lblc ip_vs_lblcr ip_vs_dh ip_vs_sh ip_vs_nq ip_vs_sed ip_vs_ftp nf_conntrack_ipv4"
for kernel_module in \${ipvs_modules}; do
    /sbin/modinfo -F filename \${kernel_module} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        /sbin/modprobe \${kernel_module}
    fi
done
EOF
chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep ip_vs

# 安装ipvsadm工具
$ yum install ipset ipvsadm -y

# 修改kube-proxy 模式
$ kubectl -n kube-system edit cm kube-proxy
...
    kind: KubeProxyConfiguration
    metricsBindAddress: ""
    mode: "ipvs"
    nodePortAddresses: null
    oomScoreAdj: null
...

# 重建kube-proxy
$ kubectl -n kube-system get po |grep kube-proxy|awk '{print $1}'|xargs kubectl -n kube-system delete po

# 查看日志，确认使用了ipvs模式
$ kubectl -n kube-system logs -f 
I0605 08:47:52.334298       1 node.go:136] Successfully retrieved node IP: 172.16.1.226
I0605 08:47:52.334430       1 server_others.go:142] kube-proxy node IP is an IPv4 address (172.16.1.226), assume IPv4 operation
I0605 08:47:52.766314       1 server_others.go:258] Using ipvs Proxier.
...

# 清理iptables规则
$ iptables -F -t nat
$ iptables -F

# 查看规则生效
$ ipvsadm -ln



```



#### 服务发现 🎯

**核心**：由 **CoreDNS** 组件负责解析 —— 集群内直接用 **Service 名称**互相访问，不用写死 IP（Pod IP 会变，Service 名不变）。

> 🎯 **面试点**：服务名完整格式 `服务名.命名空间.svc.cluster.local`，同命名空间下可简写为 `服务名`。
> **最佳实践**：ConfigMap 里数据库 / Redis 地址一律写 **Service 名**而不是 ClusterIP，跨环境迁移配置基本不用改。

演示服务发现：

```bash
## 演示思路：在eladmin-api的容器中直接通过service名称访问mysql服务，观察是否可以访问通

# 先查看服务
kubectl -n luffy get svc

kubectl -n luffy get po -owide

# 进入eladmin-web容器
$ kubectl -n luffy exec -ti eladmin-55bb565946-7brtq -c eladmin-web -- sh
# curl eladmin-api:8000
# nslookup eladmin-api
# nslookup mysql
# nslookup redis

#为什么能ping 通 service name ；
# k8s 中coredns组件作的解析


组件之间调用的同时，完全可以通过service name去通信，这样避免了大量的ip维护成本，使得服务的yaml模板更加简单。因此可以对mysql和eladmin-api的部署进行优化改造：
configMap中数据库地址可以换成Service名称，这样跨环境的时候，配置内容基本上可以保持不用变化
修改deploy-mysql.yaml #不用修改

修改configmap.yaml
$ kubectl -n luffy edit configmaps eladmin
--------------------------------------------
apiVersion: v1
data:
  DB_HOST: mysql  
  REDIS_HOST: redis
  REDIS_PORT: "6379"
kind: ConfigMap
metadata:
  creationTimestamp: "2022-10-28T13:33:26Z"
  name: eladmin
  namespace: luffy
  resourceVersion: "452964"
  uid: 54ab5ed4-64f9-4175-aab5-0ddadeb187e0
--------------------------------------------

重建服务：
kubectl -n luffy scale deployment eladmin --replicas=0

kubectl -n luffy scale deployment eladmin --replicas=1


```

服务发现实现：

`CoreDNS`是一个`Go`语言实现的链式插件`DNS服务端`，是CNCF成员，是一个高性能、易扩展的`DNS服务端`。

```bash
$ kubectl -n kube-system get po -o wide|grep dns
coredns-d4475785-2w4hk             1/1     Running   0          4d22h   10.244.0.64       
coredns-d4475785-s49hq             1/1     Running   0          4d22h   10.244.0.65

# 查看eladmin-api的pod解析配置
$ kubectl -n luffy exec -ti eladmin-55bb565946-vsqtr -c eladmin-api -- bash
root@eladmin-api-5d979bb778-2g62k:/opt/eladmin# cat /etc/resolv.conf
search luffy.svc.cluster.local svc.cluster.local cluster.local in.ctcdn.cn ss.in.ctcdn.cn
nameserver 10.96.0.10
options ndots:5
/opt/eladmin# curl eladmin-api:8000
/opt/eladmin# curl eladmin-api.luffy.svc.cluster.local:8000 #解析成


## 10.96.0.10 从哪来
$ kubectl -n kube-system get svc
NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)         AGE
kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP   51d

## 启动pod的时候，会把kube-dns服务的cluster-ip地址注入到pod的resolve解析配置中，
# 同时添加对应的namespace的search域。 因此跨namespace通过service name访问的话，需要添加对应的namespace名称，
service_name.namespace
$ kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   26h

# kubectl -n kube-system get service kube-dns -o wide
# kubectl -n kube-system describe service kube-dns
# kubectl -n kube-system get pod -l k8s-app=kube-dns -owide #根据标签找到对应的pod

# kubectl -n kube-system get deployment

```



```bash
CoreDNS 是 K8s 集群默认的 DNS 服务组件，以 Deployment 部署在 kube-system 命名空间，负责集群内服务发现、域名解析。

作用：把 服务名、Pod域名 解析为对应的 ClusterIP 或 Pod 真实 IP，让集群内应用不用写固定 IP 即可互相访问。

部署形态
资源类型：Deployment + ClusterIP Service
默认集群 DNS 固定地址：10.96.0.10（集群 DNS 预留 IP）
所有 Pod 创建时会自动注入 DNS 配置：/etc/resolv.conf 写入 nameserver=10.96.0.10

二、集群内四种常用域名解析规则
假设命名空间：luffy，Service 名称：eladmin

1. 同命名空间：直接用服务名
plaintext
eladmin
# 解析到 eladmin 的 ClusterIP

2. 同命名空间：服务名.svc.cluster.local（标准完整域名）
plaintext
eladmin.svc.cluster.local

3. 跨命名空间访问：必须带上命名空间
plaintext
eladmin.luffy.svc.cluster.local
# 格式：服务名.命名空间.svc.cluster.local

4. Headless Service + StatefulSet 有状态 Pod 固定域名
mysql-0.mysql-headless.luffy.svc.cluster.local
# Pod名称.无头服务名.命名空间.svc.cluster.local
DNS直接解析出当前Pod真实IP

三、两种 Service 的 DNS 解析差异
普通 ClusterIP Service
DNS 查询 → 返回 Service 的 ClusterIP，由 kube-proxy 做负载均衡转发到后端 Pod。

Headless Service（clusterIP: None）
DNS 查询 → 返回所有就绪后端 Pod 的 IP 列表，客户端自行做负载均衡。

四、Pod 内 DNS 配置说明
Pod 自动生成 /etc/resolv.conf：
plaintext
nameserver 10.96.0.10
search luffy.svc.cluster.local svc.cluster.local cluster.local
nameserver：CoreDNS 集群 DNS 地址
search：域名搜索后缀，简写域名会自动拼接后缀解析

五、CoreDNS 核心配置文件（ConfigMap）
配置文件路径：Corefile
kubectl get configmap coredns -n kube-system -o yaml

默认核心配置片段：
.:53 {
    errors
    health
    ready
    kubernetes cluster.local in-addr.arpa ip6.arpa {
       pods insecure
       fallthrough in-addr.arpa ip6.arpa
       ttl 30
    }
    prometheus :9153
    forward . /etc/resolv.conf
    cache 30
    loop
    reload
    loadbalance
}
关键插件解释
kubernetes：K8s 服务发现核心插件，监听 API-Server，自动解析 Service、Pod 域名
pods insecure：允许直接解析 Pod IP 域名
forward：集群内解析不到的域名，转发到宿主机上游 DNS（外网域名解析）
cache：DNS 缓存，减轻解析压力
loadbalance：DNS 轮询，多后端 Pod 时按轮询返回 IP


六、常用排错命令
1. 进入 Pod 测试 DNS 解析
# 安装解析工具
yum install -y bind-utils
# 解析服务域名
nslookup eladmin.luffy.svc.cluster.local
dig eladmin.luffy.svc.cluster.local

2. 查看 CoreDNS 运行状态
kubectl get pods -n kube-system | grep coredns
kubectl logs -f -n kube-system coredns-xxx

3. 常见 DNS 故障
同命名空间能解析，跨命名空间失败：域名格式写错，必须带命名空间
Service 存在但解析不到：Pod 未就绪，Endpoint 为空，不会被 DNS 收录
外网域名解析失败：检查 CoreDNS 的 forward 上游 DNS 配置

七、CoreDNS 两大解析模式
Service 解析（最常用）
通过服务名访问，固定 ClusterIP，四层负载均衡。
Pod 域名解析（仅 Headless+StatefulSet）
每个 Pod 拥有固定域名，适合 MySQL 主从、Redis 集群等有状态服务节点互相发现。
```







#### 2. NodePort（节点端口，集群外部可通过节点 IP 访问）

- 在每个节点上监听一个静态端口（默认范围：30000~32767）。
- 访问方式：`任意节点IP:NodePort端口`

```yaml
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080 # 不写则随机分配
    
    
--------------------------------------
cat <<EOF > service-eladmin-api-nodeport.yaml
apiVersion: v1
kind: Service
metadata:
  name: eladmin-api-nodeport
  namespace: luffy
spec:
  ports:
  - port: 8000
    #nodePort：32222 #指定端口
    protocol: TCP
    targetPort: 8000
  selector:
    app: eladmin-api
  type: NodePort
EOF


kubectl create -f  service-eladmin-api-nodeport.yaml
# 查看并访问服务：

$ kubectl -n luffy get svc
NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
eladmin-api            ClusterIP   10.99.182.32     <none>        8000/TCP         5h22m
eladmin-api-nodeport   NodePort    10.103.117.186   <none>        8000:30207/TCP   5s

# curl 172.16.1.226:30207/auth/code
#集群内每个节点的NodePort端口都会进行监听
#noteport也会创建一个cluster-ip

# nodeprot 和clusterip 都是 kube-proxy组件实现的转发

    
```

#### 3. LoadBalancer（云厂商专用）

- 公有云（阿里云 / 华为云 / AWS）专属：自动创建云负载均衡并分配**公网 IP**，外网直接访问；
- 自建机房（VMware / KVM）用不了，一般改用 **MetalLB** 或 Ingress。

#### 4. ExternalName（映射外部第三方服务）

把集群内 Service 映射到**集群外部的域名**（如外部 MySQL、Redis），通过 CNAME 实现，**不分配 ClusterIP、不做代理**。

> 🎯 **思考：集群外访问服务推荐什么方式？** 生产首选 **Ingress**（七层，80/443 复用多域名）；临时 / 测试用 NodePort；云上直接用 LoadBalancer。



### ingress 🎯

#### 一、Ingress 是什么

- **Service 只能做四层（TCP/UDP）负载均衡**，无法按域名、URL 路径转发；
- **Ingress 是七层 HTTP/HTTPS 反向代理网关**，按域名 / 路径把外部请求转发到不同 Service；
- **Ingress 本身只是"规则配置"**，真正干活的是 **Ingress Controller**（最主流是 nginx-ingress）。

#### 核心架构

客户端 → 节点 IP:Ingress 端口 → Ingress Controller（Nginx）→ 按规则转发 → Service → Pod

#### 二、Ingress 解决了什么问题

1. 不用给每个业务单独开 NodePort（端口范围 30000-32767，难管理）；
2. 多个域名**共用 80/443** 标准端口；
3. 支持路径路由、域名路由、SSL 证书、限流、重定向、白名单等 Nginx 高级能力。

#### 三、Ingress 两大组成部分 🎯

| 组成 | 角色 | 说明 |
| --- | --- | --- |
| **Ingress**（资源） | 规则 | 把 Nginx 反向代理配置抽象成 K8s 资源，定义"域名 / 路径 → 哪个 Service" |
| **Ingress Controller**（控制器） | 执行者 | 以 DaemonSet/Deployment 部署的 Nginx，实时监听 Ingress 变化，自动生成配置并**热重载** |

> 🎯 一句话：**Ingress = 规则，Controller = 干活的 Nginx，两者缺一不可**。只创建 Ingress 资源而没装 Controller，规则不会生效。

```bash
apiVersion: networking.k8s.io/v1  # 指定Ingress所属API组与稳定版本，K8s1.19+使用该正式版本
kind: Ingress  # 资源类型为Ingress，用于配置七层HTTP反向代理路由规则
metadata:
  name: ingress-wildcard-host  # 当前Ingress资源的名称，同命名空间下唯一
spec:
  ingressClassName: nginx  # 指定使用的Ingress控制器类型，绑定nginx-ingress控制器
  rules:  # 路由规则列表，可配置多条域名转发规则
  - host: "foo.bar.com"  # 匹配访问的域名，客户端通过该域名访问才会命中本条规则
    http:
      paths:  # 当前域名下的路径转发规则列表
      - pathType: Prefix  # 路径匹配类型：前缀匹配，只要请求路径以/bar开头就命中
        path: "/bar"  # 需要匹配的请求URL路径
        backend:  # 流量转发的后端目标服务配置
          service:
            name: service1  # 后端目标Service名称
            port:
              number: 80  # 后端Service暴露的服务端口
  - host: "bar.foo.com"  # 第二条规则的访问域名，不同域名分流至不同后端服务
    http:
      paths:
      - pathType: Prefix  # 前缀匹配模式，请求路径以/foo开头即匹配
        path: "/foo"  # 要拦截转发的请求路径
        backend:  # 后端转发服务配置
          service:
            name: service2  # 第二条规则对应的后端Service名称
            port:
              number: 80  # 后端service2的服务端口
              

访问匹配说明
http://foo.bar.com/bar、 http://foo.bar.com/bar/xxx → 转发到 service1:80
http://bar.foo.com/foo、 http://bar.foo.com/foo/xxx → 转发到 service2:80
```

实现逻辑

```bash
1. ingress-controller 调用 K8s API，实时监听集群内 Ingress 路由规则变更；
2. 获取域名、路径转发规则后，自动翻译成标准 Nginx 反向代理配置；
3. 将生成的配置写入容器内 /etc/nginx/nginx.conf；
4. 平滑重载 Nginx 配置，无需重启服务，实现多域名路由动态更新。
```



#### 实战安装

```bash
# wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.4.0/deploy/static/provider/cloud/deploy.yaml
wget https://gitee.com/chengkanghua/script/raw/master/k8s/deploy.yaml  #备用地址

## 修改部署节点
$ vim deploy.yaml
504         volumeMounts:
505         - mountPath: /usr/local/certificates/
506           name: webhook-cert
507           readOnly: true
508       dnsPolicy: ClusterFirst
509       nodeSelector:
510         ingress: "true"    #替换此处，来决定将ingress部署在哪些机器
511       hostNetwork: true    #添加为host模式
512       serviceAccountName: ingress-nginx
513       terminationGracePeriodSeconds: 300
514       volumes:


# 替换镜像地址
sed -i 's#registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20220916-gd32f8c343@sha256:39c5b2e3310dc4264d638ad28d9d1d96c4cbb2b2dcfb52368fe4e3c63f61e10f#myifeng/registry.k8s.io_ingress-nginx_kube-webhook-certgen:v1.3.0#g' deploy.yaml

sed -i 's#registry.k8s.io/ingress-nginx/controller:v1.4.0@sha256:34ee929b111ffc7aa426ffd409af44da48e5a0eea1eb2207994d9e0c0882d143#myifeng/registry.k8s.io_ingress-nginx_controller:v1.4.0#g' deploy.yaml

创建ingress

# 为k8s-master节点添加label
#kubectl label node k8s-master ingress=true
#kubectl label node k8s-master ingress-
kubectl label node k8s-slave1 ingress=true
kubectl apply -f deploy.yaml

# kubectl -n ingress-nginx get pod

kubectl -n ingress-nginx describe pod ingress-nginx-controller-9ccddfb4f-m4trc
kubectl get node --show-labels |grep ingress
kubectl -n ingress-nginx get pod -owide


使用示例：
cat <<EOF > ingress-eladmin-api.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: eladmin-api
  namespace: luffy
spec:
  ingressClassName: nginx
  rules:
  - host: eladmin-api.luffy.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service: 
            name: eladmin-api
            port:
              number: 8000
EOF

kubectl create -f ingress-eladmin-api.yaml

# kubectl -n luffy get ingress
NAME          CLASS   HOSTS                   ADDRESS   PORTS   AGE
eladmin-api   nginx   eladmin-api.luffy.com             80      39s

ingress-nginx动态生成upstream配置：

# kubectl -n ingress-nginx get po
NAME                                       READY   STATUS      RESTARTS   AGE
ingress-nginx-admission-create-2dqdt       0/1     Completed   0          9m20s
ingress-nginx-admission-patch-74hm5        0/1     Completed   0          9m20s
ingress-nginx-controller-9ccddfb4f-m4trc   1/1     Running     0          9m20s
# kubectl -n ingress-nginx exec -ti ingress-nginx-controller-9ccddfb4f-m4trc -- bash

$ kubectl -n ingress-nginx exec -ti ingress-nginx-controller-9ccddfb4f-m4trc -- bash
# ps aux
# cat /etc/nginx/nginx.conf|grep eladmin-api -A10 -B1
...
        ## start server eladmin-api.luffy.com
        server {
                server_name eladmin-api.luffy.com ;

                listen 80  ;
                listen [::]:80  ;
                listen 443  ssl http2 ;
                listen [::]:443  ssl http2 ;

                set $proxy_upstream_name "-";

                ssl_certificate_by_lua_block {
                        certificate.call()
--
                        set $namespace      "luffy";
                        set $ingress_name   "eladmin-api";
                        set $service_name   "eladmin-api";
                        set $service_port   "8000";
                        set $location_path  "/";
                        set $global_rate_limit_exceeding n;

                        rewrite_by_lua_block {
                                lua_ingress.rewrite({
                                        force_ssl_redirect = false,
                                        ssl_redirect = true,
                                        force_no_ssl_redirect = false,
                                        preserve_trailing_slash = false,
--
                        set $balancer_ewma_score -1;
                        set $proxy_upstream_name "luffy-eladmin-api-8000";
                        set $proxy_host          $proxy_upstream_name;
                        set $pass_access_scheme  $scheme;

                        set $pass_server_port    $server_port;

                        set $best_http_host      $http_host;
                        set $pass_port           $pass_server_port;

                        set $proxy_alternative_upstream_name "";

--
        }
        ## end server eladmin-api.luffy.com
 ...
 
域名解析服务，将 eladmin-api.luffy.com解析到ingress的地址上。ingress是支持多副本的，高可用的情况下，生产的配置是使用lb服务（内网F5设备，公网elb、slb、clb，解析到各ingress的机器，如何域名指向lb地址）

本机，添加如下hosts记录来演示效果。
10.0.0.81 eladmin-api.luffy.com
然后，访问 http://eladmin-api.luffy.com/auth/code

#服务器上测试一样的
echo '10.0.0.81 eladmin-api.luffy.com' >> /etc/hosts
curl -v http://eladmin-api.luffy.com/auth/code  #返回正常code信息



```

#### 使用ingress访问eladmin-web服务

综合来看下，如何使用ingress来实现eladmin-web项目的访问，总结了三种方式：

**方式一: **

| 项目        | 访问地址                                                     |
| ----------- | ------------------------------------------------------------ |
| eladmin-web | [http://eladmin.luffy.com](http://eladmin.luffy.com/)        |
| eladmin-api | [http://eladmin-api.luffy.com](http://eladmin-api.luffy.com/) |



**方式二：**

规划使用如下地址访问：

| 项目        | 访问地址                                                     |
| ----------- | ------------------------------------------------------------ |
| eladmin-web | [http://eladmin.luffy.com](http://eladmin.luffy.com/)        |
| eladmin-api | [http://eladmin.luffy.com:8000](http://eladmin.luffy.com:8000/) |





###### 方式三：

规划使用如下地址访问：

| 项目        | 访问地址                                              |
| ----------- | ----------------------------------------------------- |
| eladmin-web | [http://eladmin.luffy.com](http://eladmin.luffy.com/) |
| eladmin-api | http://eladmin.luffy.com/apis                         |





三种方案对比

| 方式   | 方案                                                         | 优点                                                         | 缺点                                                         | 生产推荐度 | 适用场景                                           |
| ------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ---------- | -------------------------------------------------- |
| 方式一 | 独立域名[eladmin.luffy.com](https://link.wtturl.cn/?target=https%3A%2F%2Feladmin.luffy.com&scene=im&aid=582478&lang=zh)（前端）[eladmin-api.luffy.com](https://link.wtturl.cn/?target=https%3A%2F%2Feladmin-api.luffy.com&scene=im&aid=582478&lang=zh)（后端） | 前后端网关策略可单独配置，运维隔离性强                       | 需 2 个域名、两套 SSL 证书，配置成本偏高                     | ★★★★       | 中大型项目、前后端团队分开，需精细化限流、权限管控 |
| 方式二 | 同域名不同端口[eladmin.luffy.com](https://link.wtturl.cn/?target=https%3A%2F%2Feladmin.luffy.com&scene=im&aid=582478&lang=zh)（80 前端）[eladmin.luffy.com:8000](https://link.wtturl.cn/?target=https%3A%2F%2Feladmin.luffy.com%3A8000&scene=im&aid=582478&lang=zh)（后端） | 无需额外域名                                                 | 公网端口易拦截，跨域风险高，HTTPS 配置复杂，不符合网关收口规范 | ★          | 仅本地临时测试，禁止生产使用                       |
| 方式三 | 单域名路径路由[eladmin.luffy.com/](https://link.wtturl.cn/?target=https%3A%2F%2Feladmin.luffy.com%2F&scene=im&aid=582478&lang=zh)（前端）[eladmin.luffy.com/apis](https://link.wtturl.cn/?target=https%3A%2F%2Feladmin.luffy.com%2Fapis&scene=im&aid=582478&lang=zh)（后端） | 仅 1 个域名 1 套证书，规避跨域，防火墙配置简单，运维成本最低 | 前后端共用网关策略，无法单独精细化管控                       | ★★★★★      | 中小型后台、内部管理系统（当前业务最优选择）       |









## K8s 核心知识点架构总结（eladmin 项目实战版）

该架构是典型的 K8s 前后端分离项目部署形态，完整覆盖**外网入口、服务发现、负载编排、配置管理**四大核心模块，对应前期学习的全部核心知识点。

### 一、七层流量入口层：Ingress 体系

#### 组成

- **Ingress**：路由规则资源，定义域名、路径与后端 Service 的映射关系，本身不处理流量
- **ingress-nginx-controller**：规则执行载体，本质是封装了 Nginx 的 Pod，监听 Ingress 资源变更，动态生成并刷新 Nginx 配置，实现七层反向代理

#### 对应核心知识点

1. 统一外网访问入口，复用 80/443 标准端口，替代多业务 NodePort 的端口混乱问题
2. 支持域名路由、路径路由、HTTPS 证书绑定、限流、路径重写等七层网关能力
3. 配套准入 Webhook 校验 Ingress 配置合法性，避免错误配置导致全局网关故障

### 二、服务网络层：Service + kube-proxy + CoreDNS

#### 1. Service（服务稳定访问入口）

- 作用：为动态变化的 Pod 提供固定虚拟 IP（ClusterIP），通过`label/selector`标签匹配后端 Pod，自动维护就绪 Pod 的 Endpoint 列表
- 对应知识点：解耦 Pod IP 动态变化，支持 ClusterIP、NodePort 等类型；仅就绪状态的 Pod 会被纳入负载后端

#### 2. kube-proxy（节点四层转发实现）

- 作用：运行在所有工作节点，监听 Service 与 Endpoint 变更，在内核配置转发规则，实现 Service 到后端 Pod 的四层负载均衡
- 对应知识点：主流支持 iptables、ipvs 两种模式；ipvs 模式性能更优，支持轮询、最小连接、会话保持等多种调度算法

#### 3. CoreDNS（集群服务发现核心）

- 作用：集群内置 DNS 服务，将服务名称解析为对应 ClusterIP，集群内业务可通过「服务名」互相访问，无需硬编码 IP
- 对应知识点：支持同命名空间简写、跨命名空间完整域名解析；配合 Headless Service 可直接解析 Pod 真实 IP

### 三、工作负载编排层：Deployment + Pod + controller-manager

#### 1. Deployment（应用控制器）

- 作用：管理 Pod 全生命周期，维持期望副本数，支持滚动更新、版本回滚
- 对应知识点：底层通过 ReplicaSet（RS）管理版本；滚动更新幅度由`maxSurge`、`maxUnavailable`两个参数控制
- 架构内包含 3 个 Deployment：`eladmin-web`（前端静态服务）、`eladmin-api`（后端业务服务）、`mysql`（数据库服务）

#### 2. Pod（最小调度运行单元）

- 作用：K8s 最小调度单元，一个 Pod 可封装 1 个或多个协同容器，同 Pod 内容器共享网络、存储命名空间

#### 3. controller-manager（控制器管理器）

- 作用：集群控制平面核心组件，持续监听所有控制器资源状态，驱动集群向「用户定义的期望状态」收敛，保障副本自愈、滚动更新等逻辑生效

### 四、配置管理层：ConfigMap + Secret

#### 作用

- **ConfigMap**：存储非敏感配置文件、环境变量，实现业务配置与容器镜像解耦
- **Secret**：存储数据库密码、密钥等敏感信息，加密存储，避免明文泄露

#### 对应知识点

业务 Pod 通过挂载方式读取配置，修改配置无需重构镜像，提升运维灵活性；架构中`eladmin-api`与`mysql`均从该层加载配置与密钥。

### 五、完整请求流转链路

1. **外网接入**：用户通过域名发起请求 → Ingress 路由规则匹配 → ingress-nginx-controller 七层转发 → 对应业务 Service
2. **集群内转发**：Service 通过 kube-proxy 内核转发规则 → 负载分发到后端就绪业务 Pod
3. **内部服务调用**：eladmin-api 通过 CoreDNS 解析 MySQL 服务名 → 访问 MySQL Service → 转发到 MySQL Pod
4. **配置加载**：业务 Pod 启动时，从 ConfigMap、Secret 中读取配置参数与敏感信息



## 面试题 🎯

> 下面是 Pod 状态全景图（面试高频："Pod 有哪些状态？分别什么原因？"）。重点记异常状态的成因：**Pending**（没调度/等资源）、**CrashLoopBackOff**（反复崩溃）、**Evicted**（资源不足被驱逐）、**Unknown**（节点失联）、**Err 开头**（镜像/密钥/权限等前置校验失败）。

```bash
Pod状态
└── Pending
    └── ContainerCreating
        ├── 正常状态
        │   ├── 正常终止 —— Succeeded
        │   ├── 正常运行 —— Running
        │   ├── 任务完成 —— Completed
        │   ├── 初始化中 —— init
        │   └── 短时间 —— 创建中 —— ContainerCreating
        └── 错误状态
            ├── 异常终止 —— Failed
            ├── 无法判断 —— Unknown
            ├── 崩溃循环 —— CrashLoopBackOff
            ├── 被驱逐 —— Evicted
            ├── 节点丢失 —— NodeLost
            ├── 过程错误 —— Err开头
            └── 长时间 —— 网络问题 —— ContainerCreating
            
            
一、Pending
Pod 未调度到节点，或等待拉取镜像、分配资源。
二、ContainerCreating
已调度节点，kubelet 正在拉镜像、挂载存储、配置网络；短时正常，长时间则为故障。
正常状态
Running：所有容器启动成功，程序正常运行。
Completed：一次性任务执行完毕，容器正常退出。
Succeeded：任务类 Pod 正常退出（返回码 0）。
init：正在串行执行初始化容器。
异常状态
Failed：容器异常退出，返回非 0 错误码。
Unknown：节点失联，控制平面获取不到 Pod 状态。
CrashLoopBackOff：容器反复崩溃重启，不断重试。
Evicted：节点资源耗尽，Pod 被系统强制驱逐。
NodeLost：节点宕机失联，集群标记节点故障。
Err 开头：镜像、配置、权限、密钥等前置校验出错。
```







# [Kubernetes进阶实践](https://docs.chengkanghua.top/k8s-2023/4Kubernetes进阶实践?id=_4kubernetes进阶实践)



## [操作etcd](https://docs.chengkanghua.top/k8s-2023/4Kubernetes进阶实践?id=操作etcd)

#### ETCD常用操作]

官网： https://github.com/etcd-io/etcd

拷贝etcdctl命令行工具：

```bash
# 备用国内地址
https://gitee.com/chengkanghua/script/raw/master/k8s/etcd-v3.5.31-linux-amd64.tar.gz

wget https://github.com/etcd-io/etcd/releases/download/v3.5.31/etcd-v3.5.31-linux-amd64.tar.gz
tar zxvf etcd-v3.5.31-linux-amd64.tar.gz
cp etcd-v3.5.31-linux-amd64/etcd* /usr/bin/
etcdctl version


查看etcd集群的成员节点：

export ETCDCTL_API=3  #早期的操作版本是2
kubectl -n kube-system get pod -owide |grep etcd-k8s-master  # etcd容器位置



# etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt --key=/etc/kubernetes/pki/etcd/healthcheck-client.key member list -w fields

--cacert #根证书
--cert   #签发的证书
--key    #签发的证书key

"ClusterID" : 12599920945870839420,  # etcd集群全局唯一ID，集群所有节点ID一致
"MemberID" : 3302364929709726,        # 当前etcd节点在集群内的唯一成员ID
"Revision" : 0,                       # 节点数据版本号，新增节点默认初始为0
"RaftTerm" : 6,                       # Raft协议任期号，每重新选举一次Leader任期+1
"ID" : 3302364929709726,              # 同MemberID，当前节点成员唯一标识
"Name" : "k8s-master",                # etcd节点名称，一般为主机名
"PeerURL" : "https://10.0.0.80:2380", # 集群节点间数据同步、Leader选举通信地址
"ClientURL" : "https://10.0.0.80:2379", # kube-apiserver、etcdctl客户端访问地址
"IsLearner" : false                   # 是否为学习者节点，false代表可参与投票、Leader选举的正式节点




# ll /etc/kubernetes/pki/  #证书位置

$ alias etcdctl='etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt --key=/etc/kubernetes/pki/etcd/healthcheck-client.key'

$ etcdctl member list -w table


四种常用输出格式说明
参数	输出样式	适用场景
-w table	表格	宽屏查看
-w fields	竖向key=value	窄屏首选
-w simple	逗号分隔单行	脚本过滤
-w json	JSON 键值	程序解析


#=====================etcdctl环境变量(免重复证书参数)=====================
export ETCDCTL_API=3 
alias etcdctl='etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt --key=/etc/kubernetes/pki/etcd/healthcheck-client.key'



#=====================1.集群信息查看=====================
etcdctl member list -w table       #表格展示集群节点
etcdctl member list -w fields      #竖向键值窄屏展示
etcdctl endpoint health -w table    #集群健康检测
etcdctl endpoint status -w table    #节点版本、任期、存储详情

#=====================2.键值增删改查=====================
etcdctl put /test/key val          #写入键值
etcdctl get /test/key               #查询单个key
etcdctl get /registry --prefix      #前缀批量查(K8s所有资源)
etcdctl del /test/key               #删除单个key
etcdctl del /test --prefix          #前缀批量删除
etcdctl get / --prefix --keys-only  #查看所有key值：只打印前缀 key

# 数据是压缩过的额, 可读性差
etcdctl get /registry/secrets/luffy/registry-10-0-0-80  
etcdctl get /registry/services/endpoints/luffy/mysql
#=====================3.集群节点运维=====================
etcdctl member add node2 --peer-urls=https://10.0.0.81:2380  #新增节点
etcdctl member remove 节点ID                                  #移除故障节点
etcdctl member update 节点ID --peer-urls=https://新IP:2380   #更新节点地址

#=====================4.快照备份恢复(核心运维)=====================
etcdctl snapshot save etcd_backup_$(date +%Y%m%d).db          #在线快照备份
etcdctl snapshot status etcd_backup.db                        #查看备份文件信息
#快照恢复(必须停etcd服务)
etcdctl snapshot restore etcd_backup.db \
--name=k8s-master \
--data-dir=/var/lib/etcd \
--initial-cluster=k8s-master=https://10.0.0.80:2380 \
--initial-cluster-token=etcd-cluster \
--initial-advertise-peer-urls=https://10.0.0.80:2380

#=====================5.K8s常用资源查询=====================
etcdctl get /registry/namespaces --prefix        #所有命名空间
etcdctl get /registry/pods/default --prefix      #default下所有Pod
etcdctl get /registry/deployments/default --prefix
etcdctl get /registry/services/specs/default --prefix

#=====================6.监听键值变化=====================
etcdctl watch /test/key


list-watch:
$ etcdctl watch /luffy/ --prefix
#再另一个窗口添加数据, 上一个窗口都能收到.
$ etcdctl put /luffy/key1 val1


# 添加定时任务做数据快照（重要！）
etcdctl snapshot save `hostname`-etcd_`date +%Y%m%d%H%M`.db

恢复快照：

1 停止etcd和apiserver
# kubectl -n kube-system get pod |grep apiserver

#ll /etc/kubernetes/manifests/   # 资源位置
-rw------- 1 root root 2294 Oct 17 17:14 etcd.yaml
-rw------- 1 root root 3367 Oct 17 17:14 kube-apiserver.yaml
-rw------- 1 root root 2878 Oct 17 17:14 kube-controller-manager.yaml
-rw------- 1 root root 1464 Oct 17 17:14 kube-scheduler.yaml
# mv /etc/kubernetes/manifests/kube-apiserver.yaml /opt/

# kubectl get po   #上面移走了apiserver 就停止了
The connection to the server 172.16.1.226:6443 was refused - did you specify the right host or port?

# systemctl status kubelet -l
# grep staticPodPath /var/lib/kubelet/config.yaml
staticPodPath: /etc/kubernetes/manifests   #这个目录是一个静态pod路径


2 移走当前数据目录
mv /var/lib/etcd/ /tmp

3 恢复快照
etcdctl snapshot restore `hostname`-etcd_`date +%Y%m%d%H%M`.db --data-dir=/var/lib/etcd/

[root@k8s-master ~]# ll k8s-master*.db  #变量名会根据时间变化改变, 先查看一下
-rw------- 1 root root 2981920 Oct 19 17:12 k8s-master-etcd_202410191712.db
$ etcdctl snapshot restore k8s-master-etcd_202410191712.db --data-dir=/var/lib/etcd/
mv  /opt/kube-apiserver.yaml /etc/kubernetes/manifests/

kubectl get po  #已经恢复可以查看
kubectl -n kube-system get pods


集群恢复
https://github.com/etcd-io/etcd/blob/release-3.3/Documentation/op-guide/recovery.md


namespace删除问题

很多情况下，会出现namespace删除卡住的问题，此时可以通过操作etcd来删除数据：

[root@k8s-master ~]# kubectl create ns test
namespace/test created
[root@k8s-master ~]# kubectl delete ns test

#另一个窗口查看
[root@k8s-master ~]# kubectl get ns
NAME                   STATUS        AGE
test                   Terminating   7s  #如果一直卡住 Terminating 的状态 删除不掉 ,怎么办?


# 查询namespace相关的元数据
$ etcdctl get / --prefix --keys-only|grep namespace
/registry/clusterrolebindings/system:controller:namespace-controller
/registry/clusterroles/system:controller:namespace-controller
/registry/namespaces/default
/registry/namespaces/eladmin
/registry/namespaces/kube-flannel
/registry/namespaces/kube-node-lease
/registry/namespaces/kube-public
/registry/namespaces/kube-system
/registry/namespaces/luffy
/registry/serviceaccounts/kube-system/namespace-controller

# 比如eladmin这个名称空间无法删除，则可以通过命令删除
$ etcdctl delete /registry/namespaces/eladmin



```











## [Kubernetes调度器](https://docs.chengkanghua.top/k8s-2023/4Kubernetes进阶实践?id=kubernetes调度器)

### 一、为什么要控制 Pod 调度？🎯

不让 Pod 随机乱跑，核心目的：

1. **资源匹配**：AI 任务跑 GPU 节点、数据库跑高速磁盘节点
2. **负载均衡**：避免部分节点爆满、部分闲置
3. **业务隔离**：生产与测试分开，重要业务独占节点
4. **高可用**：同服务副本分散到不同节点，避免单节点故障全挂

### 二、调度的完整过程 🎯

`kube-scheduler` 是控制平面核心组件，负责为未绑定节点的 Pod 选择最优节点。

核心两阶段：**预选（Filter 过滤）→ 优选（Score 打分）**，基于插件化架构 —— 先卡硬性门槛筛出合格节点，再综合加权选最优。

> 🎯 **面试必背**：预选是**一票否决**（不满足即淘汰，全被淘汰则 Pod 一直 `Pending`）；优选是**加权打分**（0~100 分 × 权重，最高分胜出，同分随机）。

------

#### 一、预选阶段（Filter / 过滤）

##### 1. 核心作用

**一票否决制**：剔除不满足条件的节点，只留下"合格节点列表"。**若节点全被过滤，Pod 保持 `Pending` 并持续重试**。

##### 2. 执行逻辑

1. **PreFilter 预处理**：提前解析 Pod 资源需求、亲和性规则并缓存，避免每个节点重复计算；
2. **并行遍历**所有节点，依次执行各 Filter 插件；
3. 任一插件不通过 → 该节点直接淘汰，不再走后续校验。

##### 3. 核心默认过滤插件

| 插件分类 | 插件名称          | 校验规则                                                     |
| :------- | :---------------- | :----------------------------------------------------------- |
| 节点状态 | NodeUnschedulable | 节点被 cordon 标记为不可调度 → 直接淘汰                      |
| 节点状态 | NodeName          | Pod 显式指定了 `spec.nodeName` → 只保留对应节点，其余全过滤  |
| 资源匹配 | NodeResourcesFit  | 节点剩余可分配资源（CPU、内存、GPU 等）≥ Pod 的 `requests` 申请量，不满足则淘汰 |
| 标签亲和 | NodeAffinity      | 校验节点标签是否满足 Pod **硬节点亲和规则**，不匹配直接淘汰  |
| 污点容忍 | TaintToleration   | Pod 容忍规则无法覆盖节点污点（NoSchedule/NoExecute）→ 直接淘汰 |
| Pod 亲和 | InterPodAffinity  | 校验 Pod 亲和 / 反亲和硬规则，节点上已有 Pod 不符合约束 → 淘汰 |
| 端口冲突 | NodePorts         | Pod 申请的 `hostPort` 在节点上已被占用 → 淘汰                |
| 存储校验 | VolumeBinding     | Pod 关联的 PVC 无法在该节点绑定（如本地存储 PV 仅支持特定节点）→ 淘汰 |
| 存储校验 | VolumeZone        | PV 的可用区标签与节点所在区域不匹配 → 淘汰                   |

------

#### 二、优选阶段（Score / 打分）

##### 1. 核心作用

对预选通过的合格节点，从多个维度独立打分并加权求和，选出**综合得分最高**的最优节点。

##### 2. 执行逻辑

1. 打分前先经过 **PreScore 预处理**：提前计算打分所需的公共数据，避免每个节点重复运算。
2. 每个 Score 插件独立给节点打分，原始分数范围为 0~100。
3. 每个插件配置有权重，节点最终总分 = 所有插件分数 × 对应权重 之和。
4. 总分最高的节点胜出；若多个节点同分，随机选择一个。

##### 3. 核心默认打分插件（含默认权重 1）

| 维度       | 插件名称                                | 打分逻辑                                                     |
| :--------- | :-------------------------------------- | :----------------------------------------------------------- |
| 资源负载   | NodeResourcesFit（LeastRequested 策略） | 节点剩余空闲资源越多，得分越高。优先把 Pod 调度到更空闲的节点，避免单节点负载过载 |
| 资源均衡   | NodeResourcesBalancedAllocation         | 节点 CPU、内存使用率越均衡，得分越高。避免出现 “CPU 跑满、内存大量闲置” 的资源倾斜 |
| 节点亲和   | NodeAffinity                            | 匹配 Pod 软节点亲和规则，匹配条目越多，得分越高              |
| Pod 亲和   | InterPodAffinity                        | 匹配 Pod 亲和 / 反亲和软规则，符合部署偏好的节点得分更高     |
| 高可用分布 | PodTopologySpread                       | 按拓扑分布约束，Pod 在节点 / 可用区分布越均匀，对应节点得分越高 |
| 镜像效率   | ImageLocality                           | 节点上已存在 Pod 需要的镜像，得分越高；镜像越大，加分越多，减少拉取耗时 |
| 污点偏好   | TaintToleration                         | 匹配污点容忍的偏好规则，匹配度越高得分越高                   |

------

#### 三、完整调度全链路

1. Pod 创建后进入调度队列，按优先级排序
2. **PreFilter**：预处理 Pod 调度信息
3. **Filter（预选）**：并行过滤所有节点，筛出合格列表
4. **PreScore**：打分前数据预处理
5. **Score（优选）**：多维度加权打分，选出最高分节点
6. Reserve：预留节点对应资源
7. Bind：将 `nodeName` 写入 Pod 配置，完成绑定
8. 对应节点的 kubelet 接收指令，创建并启动 Pod



### 三、NodeSelector（最简单：标签硬绑定）🎯

最基础的调度方式，**节点打标签，Pod 指定标签，必须精确匹配才能调度**。

1. 给节点打标签

```
kubectl label node k8s-slave1 gpu=true
```

1. Pod 配置指定标签

```
spec:
  nodeSelector:
    gpu: "true"
```

特点：简单粗暴，只能精确匹配，灵活性差。

### 四、nodeAffinity（节点亲和性：更灵活的标签匹配）

比 NodeSelector 功能更强，分两种规则：

- 硬亲和（required） requiredDuringSchedulingIgnoredDuringExecution 

  ：必须满足条件，不满足就不调度

  相当于 “我必须住阳面房间，没有就不住”

- 软亲和（preferred）  preferredDuringSchedulingIgnoredDuringExecution

  ：优先满足条件，不满足也能运行

  相当于 “我优先选阳面，没有阴面也行”

- 

```yaml
#要求 Pod 不能运行在k8s-slave1和k8s-slave2两个节点上，如果有节点满足disktype=ssd或者sas的话就优先调度到这类节点上
...
spec:
      containers:
      - name: eladmin-api
        image: 10.0.0.80:5000/eladmin-api:v1
        ports:
        - containerPort: 8000
      affinity:
          nodeAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
                - matchExpressions:
                    - key: kubernetes.io/hostname
                      operator: NotIn
                      values:
                        - k8s-slave1
                        - k8s-slave2
                        
            preferredDuringSchedulingIgnoredDuringExecution:
                - weight: 1
                  preference:
                    matchExpressions:
                    - key: disktype
                      operator: In
                      values:
                        - ssd
                        - sas
...


支持丰富匹配规则：
- In：label 的值在某个列表中
- NotIn：label 的值不在某个列表中
- Gt：label 的值大于某个值
- Lt：label 的值小于某个值
- Exists：某个 label 存在
- DoesNotExist：某个 label 不存在

如果nodeSelectorTerms下面有多个选项的话，满足任何一个条件就可以了；
如果matchExpressions有多个选项的话，则必须同时满足这些条件才能正常调度 Pod


```





### 五、Pod 亲和性与反亲和性

**不看节点标签，看节点上已运行 Pod 的标签**，决定是否调度到该节点。

#### 1. Pod 亲和性（podAffinity）：和同类 Pod 凑一起

场景：前端和后端部署在同一节点，减少网络调用延迟

规则：节点上已有`app=backend`标签的 Pod，我就调度过去

#### 2. Pod 反亲和性（podAntiAffinity）：和同类 Pod 分开

场景：同服务的多个副本，分散到不同节点，避免单节点故障全挂

规则：节点上已有`app=nginx`标签的 Pod，我就不调度过去

同样分为硬规则（必须满足）和软规则（优先满足）。



```yaml
eladmin-web启动多副本，但是期望可以尽量分散到集群的可用节点中

分析：为了让eladmin-web应用的多个pod尽量分散部署在集群中，可以利用pod的反亲和性，告诉调度器，如果某个节点中存在了eladmin-web的pod，则可以根据实际情况，实现如下调度策略：

不允许同一个node节点，调度两个eladmin-web的副本
可以允许同一个node节点中调度两个eladmin-web的副本，前提是尽量把pod分散部署在集群中
---------------------------------------------------------------------------------------

# 如果某个节点中，存在了app=eladmin-web的label的pod，那么 调度器一定不要给我调度过去
...
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - eladmin-web
            topologyKey: kubernetes.io/hostname
      containers:
...


# 如果某个节点中，存在了app=eladmin-web的label的pod，那么调度器尽量不要调度过去
...
    spec:
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: app
                  operator: In
                  values:
                  - eladmin-web
              topologyKey: kubernetes.io/hostname
      containers:
...


```

https://kubernetes.io/zh/docs/concepts/scheduling-eviction/assign-pod-node/







### 六、污点（Taints）与容忍（Tolerations）🎯

和亲和性逻辑**相反**：**节点主动设"门槛"，Pod 达标才能进**。

- **污点 Taints**：打在节点上，默认拒绝所有 Pod 调度过来
- **容忍 Tolerations**：配在 Pod 上，能匹配该污点才允许调度上去

> 类比：节点是"吸烟区"（打污点），只有能忍烟味的人（加容忍）才进得去。

#### 污点的三种效果 🎯

| effect | 对新 Pod | 对已运行的 Pod |
| --- | --- | --- |
| `NoSchedule` | 不调度 | 不受影响 |
| `PreferNoSchedule` | 尽量不调度（没别的节点时还是会去） | 不受影响 |
| `NoExecute` | 不调度 | **无对应容忍的直接驱逐** |

#### 常用场景

- **GPU 专用节点**：打污点，只有 GPU 任务加容忍后能用
- **节点维护**：打 `NoExecute` 把 Pod 全赶走
- **资源紧张**：系统自动打污点，驱逐低优先级 Pod

> 🎯 **面试对比**：**亲和性**是"Pod 主动选节点"（Pod 说了算）；**污点容忍**是"节点主动拒绝 Pod"（节点说了算）。

```bash
设置污点：
$ kubectl taint node [node_name] key=value:[effect]   
       其中[effect] 可取值： [ NoSchedule | PreferNoSchedule | NoExecute ]
       NoSchedule：一定不能被调度。
       PreferNoSchedule：尽量不要调度。
       NoExecute：不仅不会调度，还会驱逐Node上已有的Pod。
  示例：kubectl taint node k8s-slave1 smoke=true:NoSchedule




去除污点：
去除指定key及其effect：
     kubectl taint nodes [node_name] key:[effect]-    #这里的key不用指定value
     kubectl taint node k8s-slave1 smoke-
 去除指定key所有的effect: 
     kubectl taint nodes node_name key-
 示例：
     kubectl taint node k8s-master smoke=true:NoSchedule  #设置污点
     kubectl taint node k8s-master smoke:NoExecute-       #去除污点
     kubectl taint node k8s-master smoke-                 #去除污点

污点演示：

## 给k8s-slave1打上污点，smoke=true:NoSchedule
$ kubectl taint node k8s-master gamble=true:NoSchedule
$ kubectl taint node k8s-slave1 drunk=true:NoSchedule
$ kubectl taint node k8s-slave2 smoke=true:NoSchedule

## 扩容eladmin-web的Pod，观察新Pod的调度情况
$ kuebctl -n luffy scale deploy eladmin-web --replicas=3
$ kubectl -n luffy get po -w    ## pending  三个节点都有污点无法调度
  kubectl -n luffy describe pod pending的pod的name  #查看对应warning的信息,


Pod容忍污点示例：

...
spec:
      containers:
      - name: eladmin-web
        image: 10.0.0.80:5000/eladmin/eladmin-web:v2
      tolerations: #设置容忍性
      - key: "smoke" 
        operator: "Equal"  #不指定operator，默认为Equal
        value: "true"
        effect: "NoSchedule"
      - key: "drunk" 
        operator: "Exists"  #如果操作符为Exists，那么value属性可省略,不指定operator，默认为Equal
      #意思是这个Pod要容忍的有污点的Node的key是smoke Equal true,效果是NoSchedule，
      #tolerations属性下各值必须使用引号，容忍的值都是设置Node的taints时给的值。

# 效果: k8s-slave1和k8s-slave2都可能会被调度过去,他们两个node的污点是 drunk smoke, 不会调度到k8s-master


spec:
      containers:
      - name: eladmin-web
        image: 10.0.0.80:5000/eladmin/eladmin-web:v2
      tolerations:
        - operator: "Exists"
#效果: 所有污点都可以容忍,所有node都可能会调度过去

```







### 七、Pod 驱逐策略 🎯

节点异常或资源不足时，系统主动把 Pod 迁走，分两类：

| 类型 | 触发者 | 场景 | 行为 |
| --- | --- | --- | --- |
| **资源不足驱逐** | kubelet 主动 | 节点内存 / 磁盘 / PID 即将耗尽 | 按优先级驱逐（先赶低优先级、占用多的），保节点不崩 |
| **节点故障驱逐** | 控制器主动 | 节点失联变 `NotReady` | **默认等 5 分钟**确认故障，再在健康节点重建 Pod |

> 🎯 驱逐顺序与前面的 **QoS** 对应：**BestEffort 最先被驱逐，Guaranteed 最后**。

#### 补充：优雅驱逐（维护节点三件套）🎯

- `kubectl cordon <node>`：标记**不可调度**（SchedulingDisabled），已有 Pod 不受影响
- `kubectl drain <node>`：先优雅迁移 Pod 再排空节点（常加 `--ignore-daemonsets` 忽略 DaemonSet）
- `kubectl uncordon <node>`：恢复调度

```bash

# 停止调度  # 单词cordon 警戒线 ;旧有的pod不会受到影响，仍正常对外提供服务
# 影响最小，只会将node调为SchedulingDisabled
# 之后再发创建pod，不会被调度到该节点
$ kubectl cordon k8s-slave2 
# kubectl describe node k8s-slave2|grep -i taint #可以查看到添加了一个不可调度的污点
# 恢复调度
$ kubectl uncordon k8s-slave2 


# drain 驱逐节点
# 首先，驱逐node上的pod，其他节点重新创建
# 接着，将节点调为** SchedulingDisabled**
$ kubectl drain k8s-slave2   

drain的参数
--force
当一些pod不是经 ReplicationController, ReplicaSet, Job, DaemonSet 或者 StatefulSet 管理的时候,
就需要用--force来强制执行 (例如:kube-proxy)
 
--ignore-daemonsets
忽略DaemonSet管理下的Pod
# 若node节点上存在daemonsets控制器创建的pod,则需要使用--ignore-daemonsets忽略错误错误警告
# kubectl drain k8s-slave2 --ignore-daemonsets

--delete-local-data
如果有mount local volumn的pod，会强制杀掉该pod并把料清除掉
另外如果跟本身的配置讯息有冲突时，drain就不会执行

```







## [Kubernetes认证与授权](https://docs.chengkanghua.top/k8s-2023/4Kubernetes进阶实践?id=kubernetes认证与授权)

所有对 `kube-apiserver` 的请求，必须依次通过 **认证 → 授权 → 准入控制** 三道关卡，任一环节失败都会被拒绝。可以类比为进公司大楼：

- 认证 = 查工牌，确认你是不是内部人员（你是谁）
- 授权 = 查部门权限，确认你能不能进对应办公室（你能做什么）
- 准入控制 = 前台额外安检，校验操作是否符合规范

------

### 一、认证（Authentication）：验证身份

#### 核心逻辑

K8s **没有内置用户数据库**，所有用户身份都由外部认证体系提供。认证通过后，系统会提取出「用户名、用户组」信息传给后续授权阶段；认证失败直接返回 `401 Unauthorized`。

#### 4 种主流认证方式

| 认证方式             | 适用场景             | 原理说明                                                     |
| :------------------- | :------------------- | :----------------------------------------------------------- |
| **X.509 客户端证书** | 管理员、集群组件访问 | 客户端携带证书发起请求，API Server 用集群 CA 证书验签；证书 `CN` 字段是用户名，`O` 字段是用户组。kubeadm 部署的集群默认使用该方式。 |
| **ServiceAccount**   | Pod 内部程序访问 API | 集群内置资源，专门给 Pod 里的进程用；每个命名空间默认有一个 `default` 账号，自动挂载 Token + CA 证书到 Pod 内，程序可直接调用 API。 |
| **Bearer Token**     | 脚本、自动化工具访问 | 请求头携带 `Authorization: Bearer <token>` 校验身份，包含 ServiceAccount Token、节点加入集群用的引导 Token 等。 |
| **OIDC/Webhook**     | 企业级统一身份       | 对接企业账号体系（Keycloak、钉钉、企业微信），调用外部服务完成身份校验。 |

------

### 二、授权（Authorization）：校验权限

#### 核心逻辑

认证通过后，根据用户的身份，判断其对目标资源是否有对应操作权限；权限不足直接返回 `403 Forbidden`。

#### 4 种授权模式

| 模式                           | 说明                                                         | 生产推荐度 |
| :----------------------------- | :----------------------------------------------------------- | :--------- |
| **RBAC（基于角色的访问控制）** | 官方默认、主流方案，通过角色绑定实现权限复用，动态配置无需重启 | ★★★★★      |
| Node                           | 专门给 kubelet 使用，限制节点只能访问自身相关的 Pod、Node 资源 | 系统内置   |
| ABAC                           | 基于属性的静态规则，配置繁琐，修改需重启 API Server          | 已淘汰     |
| Webhook                        | 调用外部服务做自定义权限判断                                 | 定制化场景 |

#### RBAC 核心四要素（重中之重）🎯

RBAC 核心思想：**权限封装到角色，主体绑定角色获得权限**；权限**只累加、不支持"拒绝"规则**（没有 deny）。

> 🎯 记忆口诀：**Role 定权限、Binding 做绑定**；带 `Cluster` 前缀 = 集群级，不带 = 命名空间级。

| 资源类型           | 作用范围     | 核心作用                                                     |
| :----------------- | :----------- | :----------------------------------------------------------- |
| Role               | 单个命名空间 | 定义该命名空间内，对哪些资源（Pod/Deployment/Service）能做哪些操作（get/list/create/delete） |
| ClusterRole        | 整个集群     | 定义集群级资源（Node/Namespace/PV）的权限，或所有命名空间的通用权限 |
| RoleBinding        | 单个命名空间 | 将 Role/ClusterRole 绑定给用户、用户组或 ServiceAccount，仅在当前命名空间生效 |
| ClusterRoleBinding | 整个集群     | 将 ClusterRole 绑定给主体，获得全集群范围的权限              |

#### 最简示例：授予只读 Pod 权限

```
# 1. 定义角色：default 命名空间内可查看 Pod
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""]   # core 核心资源组
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
---
# 2. 绑定角色：给用户 zhangsan 绑定上面的角色
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: User
  name: zhangsan
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

------

### 三、准入控制（Admission Control）：最终校验

#### 核心逻辑

位于授权通过之后、数据写入 etcd 之前，是请求的最后一道关卡，分为两类：

1. **修改型（Mutating）**：自动修改请求内容，比如给 Pod 自动注入 Sidecar、补全默认资源限制
2. **验证型（Validating）**：校验请求是否合规，不符合直接拒绝，比如限制容器不能用 root 用户、校验资源配额是否超限

#### 常见内置插件

- `NamespaceLifecycle`：禁止删除系统命名空间、禁止在不存在的命名空间创建资源
- `LimitRanger`：自动给 Pod 补全默认 CPU / 内存限制
- `ResourceQuota`：校验命名空间资源总量是否超限
- 扩展插件：MutatingWebhook、ValidatingWebhook，比如 Ingress 的配置合法性校验就是通过 ValidatingWebhook 实现的。





### 这张图完整解析：K8s API Server 请求全链路

这张图的核心逻辑：**所有读写 etcd 的操作，必须唯一经由 API Server，并且依次通过「认证→鉴权→准入控制」三道安全关卡，最终才能持久化到数据库**，是 K8s 集群安全体系的完整全景图。

------

#### 一、左侧：请求发起方（谁在调用 API Server）

##### 核心前提（左上角黄色标注）

K8s 中所有涉及读写 etcd 数据库的请求，都必须调用 apiserver 完成。

API Server 是集群唯一的数据入口，禁止任何组件直接操作 etcd，以此保障数据一致性、统一收口安全校验。

##### 两类调用方，对应两种认证方式

##### 1. 证书认证（橙色箭头）

- 调用主体：`controller-manager`、`scheduler`、`kube-proxy`、`kubelet`、`kubectl`，以及用户的`kubeconfig`文件
- 认证方式：X.509 客户端证书认证
- 原理：API Server 用集群 CA 证书验签，证书的`CN`字段为用户名，`O`字段为用户组。集群核心组件与管理员工具均采用这种高安全级别的认证方式。

##### 2. Token 认证（绿色箭头）

- 调用主体：`coredns`、`flannel`、`ingress-controller`、`k8s-dashboard`、`nfs-provisioner`、基于 K8s 的 PaaS 云平台
- 认证方式：Bearer Token（ServiceAccount）
- 原理：运行在 Pod 内的应用，通过挂载的 ServiceAccount Token 发起请求，API Server 校验 Token 合法性，识别出对应的服务账号身份。

------

#### 二、第一阶段：API Server 认证（Authentication）

对应图中「Apiserver 认证」模块，是请求的第一道关卡。

- 作用：验证请求方的身份是否合法，**认证失败直接返回 401 拒绝，请求终止**。
- 输出：认证通过后，从凭证中提取身份信息（`User`用户、`Group`用户组、`ServiceAccount`服务账号），传递给下一阶段的鉴权模块。

------

#### 三、第二阶段：API Server 鉴权（Authorization）

##### 对应图中「Apiserver 鉴权」模块，是请求的第二道关卡。

##### 核心逻辑（左下角黄色标注）

鉴权的本质是检查 User、Group、ServiceAccount 是否具有访问当前请求资源的权限，权限不足直接返回 403 Forbidden。

##### 图中两种鉴权模式

###### 1. RBAC 模式（生产主流，默认启用）

基于角色的访问控制，核心思想：**权限封装到角色，主体绑定角色获得权限**，权限为纯累加制，没有拒绝规则Kubernetes。

- **Role**：命名空间级角色，定义单个命名空间内的资源操作权限（比如 default 命名空间下查看 Pod）
- **ClusterRole**：集群级角色，定义全集群资源（Node、Namespace、PV 等）的操作权限
- **RoleBinding**：命名空间级绑定，将 Role/ClusterRole 与主体绑定，权限仅在当前命名空间生效
- **ClusterRoleBinding**：集群级绑定，将 ClusterRole 与主体绑定，权限在全集群生效

###### 2. Node 模式

专门给`kubelet`使用的专用鉴权规则，限制 kubelet 只能访问自身节点相关的 Pod、Node、存储资源，遵循最小权限原则。

------

#### 四、第三阶段：准入控制器（Admission Controller）

对应图中`Admission Controller`模块，是写入 etcd 前的最后一道关卡。

- 作用：鉴权通过后，对请求做最终的**内容修改 + 合规校验**，不通过则直接拒绝。
- 分为两类：
  1. **修改型（Mutating）**：自动补全请求内容，比如给 Pod 自动注入 Sidecar、补全默认 CPU / 内存限制
  2. **验证型（Validating）**：校验请求是否符合集群规则，比如校验命名空间资源配额、容器安全规范、Ingress 配置合法性等

------

#### 五、最终落地：ETCD

所有通过三道关卡的请求，最终由 API Server 将资源状态写入 etcd 数据库，完成持久化。etcd 是 K8s 集群的唯一状态存储，保存所有资源的配置与运行数据。

------

#### 完整请求链路总结

请求发起 → 携带证书 / Token → API Server 认证（验明身份）→ API Server 鉴权（校验权限）→ 准入控制（合规校验 / 修改）→ 写入 etcd 持久化





## [通过HPA实现业务应用的动态扩缩容](https://docs.chengkanghua.top/k8s-2023/4Kubernetes进阶实践?id=通过hpa实现业务应用的动态扩缩容)

当系统资源过高的时候，我们可以使用如下命令来实现 Pod 的扩缩容功能

```bash
$ kubectl -n luffy scale deployment eladmin-web --replicas=2
```

HPA（Horizontal Pod Autoscaler）是 K8s 内置的水平弹性伸缩组件，**根据业务负载指标自动增减 Pod 副本数**：流量高峰自动扩容保障稳定性，低峰自动缩容节省资源，适配无状态业务的弹性需求。

------

### 一、核心工作原理 🎯

HPA 控制器运行在控制平面，**默认每 15 秒**轮询一次：它只负责修改 Deployment/StatefulSet 的 `replicas` 字段，**真正创建 / 删除 Pod 由工作负载控制器完成**。

#### 完整执行流程

1. **指标采集**：metrics-server 持续采集各 Pod 的 CPU、内存等指标
2. **指标拉取**：HPA 从 Metrics API 拿到目标 Pod 的实时平均指标
3. **副本计算**：按核心公式算期望副本数，**多指标时取最大值**（最激进的那个说了算）
4. **策略校验**：过容忍度、稳定窗口、步长限制等防抖规则
5. **执行扩缩**：改 replicas，触发 Pod 创建 / 删除

#### 支持的指标类型 🎯

> 🎯 **面试点**：CPU / 内存指标来自 **metrics-server**；QPS、队列长度这类**自定义指标**需要 **Prometheus + adapter**；**HPA 的前提是 Pod 必须设置 requests**，否则算不出使用率。



| 指标类型   | 说明                            | 数据源               |
| :--------- | :------------------------------ | :------------------- |
| 资源指标   | CPU、内存使用率（最常用）       | metrics-server       |
| 自定义指标 | QPS、并发数、队列长度等业务指标 | Prometheus + adapter |
| 外部指标   | 集群外系统指标，如 MQ 堆积数    | 外部监控系统         |

------

### 二、前置依赖：metrics-server

HPA 依赖 metrics-server 提供 Pod 资源指标，kubeadm 默认未部署，需先验证：



```bash
官方代码仓库地址：https://github.com/kubernetes-sigs/metrics-server
$ wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.1/components.yaml
# https://gitee.com/chengkanghua/script/raw/master/k8s/components.yaml   #备用地址

修改args参数：

# 添加- --kubelet-insecure-tls
...
133       containers:
134       - args:
135         - --cert-dir=/tmp
136         - --secure-port=4443
            - --kubelet-insecure-tls   # 增加
137         - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
138         - --kubelet-use-node-status-port
139         - --metric-resolution=15s
140         image: registry.cn-hangzhou.aliyuncs.com/google_containers/metrics-server:v0.6.1  # 修改成国内地址
141         imagePullPolicy: IfNotPresent
...

sed -i.bak '136a\        - --kubelet-insecure-tls' components.yaml
sed -i '141s#k8s.gcr.io/metrics-server/metrics-server:v0.6.1#registry.cn-hangzhou.aliyuncs.com/google_containers/metrics-server:v0.6.1#' components.yaml

# 执行安装
kubectl apply -f components.yaml
## 验证组件是否存在
kubectl -n kube-system get pods| grep metrics-server

# # 验证指标API正常（能输出则说明可用）
kubectl top pods
kubectl top nodes


```



------

### 三、实战配置（CPU + 内存双指标）

#### 必踩前置坑

**Pod 必须配置 `resources.requests`**。HPA 的使用率 = 实际使用量 /requests 申请量，未配置 requests 则无法计算使用率，HPA 会直接失效。

#### 1. 示例 Deployment（带资源申请）



```yaml

cat <<EOF > deploy-eladmin-web.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: eladmin-web
  namespace: luffy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: eladmin-web
  template:
    metadata:
      labels:
        app: eladmin-web
    spec:
      imagePullSecrets:
      - name: registry-10-0-0-80
      containers:
      - name: eladmin-web
        image: 10.0.0.80:5000/eladmin/eladmin-web:v1
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
        # 资源配额，和后端保持对齐
        resources:
          requests:
            memory: 200Mi
            cpu: 50m
          limits:
            memory: 1Gi
            cpu: 2
        # 存活探针：检测80端口是否监听
        livenessProbe:
          tcpSocket:
            port: 80
          initialDelaySeconds: 20
          periodSeconds: 15
          timeoutSeconds: 3
        # 就绪探针：HTTP检测首页
        readinessProbe:
          httpGet:
            path: /
            port: 80
            scheme: HTTP
          initialDelaySeconds: 20
          timeoutSeconds: 3
          periodSeconds: 15
EOF

kubectl create -f deploy-eladmin-web.yaml

cat <<EOF > svc-eladmin-web.yaml
apiVersion: v1
kind: Service
metadata:
  name: eladmin-web-svc
  namespace: luffy
spec:
  selector:
    app: eladmin-web  # 必须和Deployment中Pod标签保持一致
  ports:
  - port: 80         # Service集群内部访问端口
    targetPort: 80   # 后端容器暴露的端口
  type: ClusterIP
EOF

# 创建service
kubectl apply -f svc-eladmin-web.yaml

# 查看
kubectl get svc -n luffy      
          
```

#### 2. HPA 配置（autoscaling/v2 稳定版）

```yaml
# 方式一
cat <<EOF > hpa-eladmin-web.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: hpa-eladmin-web
  namespace: luffy
spec:
  maxReplicas: 3  # 最大副本数为 3
  minReplicas: 1
  scaleTargetRef:  #定义自动扩缩容的目标资源
    apiVersion: apps/v1
    kind: Deployment
    name: eladmin-web
  metrics:  #触发自动扩缩容的指标
    - type: Resource #基于资源使用情况的指标
      resource:
        name: memory  #内存使用情况
        target:
          type: Utilization  #扩缩容的目标类型是资源利用率
          averageUtilization: 80 # 当内存平均利用率达到 80% 时触发扩缩容操作
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 80
EOF
kubectl create -f hpa-eladmin-web.yaml

# 方式二
$ kubectl -n luffy autoscale deployment eladmin-web --cpu-percent=80 --min=1 --max=3

Deployment对象必须配置requests的参数，不然无法获取监控数据，也无法通过HPA进行动态伸缩

验证：

$ yum -y install httpd-tools
$ kubectl -n luffy get svc eladmin-web

# 取cluster ip
IP=$(kubectl -n luffy get svc eladmin-web-svc |awk 'NR==2{print $3}')
# 为了更快看到效果，先调整副本数为1
kubectl -n luffy scale deploy eladmin-web --replicas=1
# 模拟1000个用户并发访问页面10万次
$ ab -n 100000 -c 1000 http://$IP/



#另一个窗口观察
kubectl -n luffy get hpa -w


# 查看pod数量
kubectl -n luffy get pods

压力降下来后，会有默认5分钟的scaledown的时间
```

------

### 四、核心计算逻辑

#### 1. 基础公式

```
期望副本数 = 向上取整( 当前副本数 × ( 当前平均指标值 / 目标指标值 ) )
```

**示例**：当前 2 个 Pod，CPU 平均使用率 90%，目标 50%

```
期望副本数 = ceil( 2 × (90% / 50%) ) = ceil(3.6) = 4
```

#### 2. 防抖机制（避免频繁抖动）

1. 容忍度

   ：默认 10%，指标比率在 0.9~1.1 之间时，不触发扩缩容

   例：目标 50%，CPU 在 45%~55% 波动时，HPA 不做调整

2. 稳定窗口

   - 扩容：默认 0 秒，检测到负载升高立即扩容
   - 缩容：默认 300 秒（5 分钟），取 5 分钟内最大的推荐副本数，避免瞬时低载导致误缩容

3. **步长限制**：可配置单次扩缩容的最大数量 / 百分比，避免副本数骤变

------

### 五、常用操作命令



```bash
# 查看HPA列表与实时状态
kubectl get hpa

# 查看HPA详情、事件与报错（排查必备）
kubectl describe hpa nginx-demo-hpa

# 修改HPA配置
kubectl edit hpa nginx-demo-hpa

# 压测验证扩容
kubectl run -i --tty load-test --rm --image=busybox --restart=Never -- /bin/sh -c "while true; do wget -q -O- http://nginx-demo; done"

# 删除HPA
kubectl delete hpa nginx-demo-hpa
```

------

### 六、常见失效原因与排查

1. **Pod 未配置 resources.requests**：最常见，HPA 无法计算使用率，显示`<unknown>`
2. **metrics-server 异常**：指标采集失败，HPA 无法获取数据
3. **工作负载类型不支持**：DaemonSet 不可伸缩，无法绑定 HPA
4. **阈值设置过高**：指标永远达不到阈值，不会触发扩容











## 对接分布式存储 + PV/PVC 完整讲解

### 三种简单存储方式

```bash
# ============== 1. emptyDir 临时共享目录 ==============
# 特性：同Pod内多容器共享，生命周期与Pod完全一致，Pod删除数据同步清除
cat <<EOF > demo-emptydir.yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-emptydir
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: temp-data
      mountPath: /tmp/cache   # 容器内挂载路径
  volumes:
  - name: temp-data
    emptyDir: {}              # 零配置，自动生成临时目录
EOF
# 部署命令：kubectl apply -f demo-emptydir.yaml
# 典型场景：临时缓存、同Pod多容器间传递文件


# ============== 2. hostPath 节点本地挂载 ==============
# 特性：挂载节点宿主机本地目录，Pod删除后数据保留，漂移到其他节点则丢失原数据
cat <<EOF > demo-hostpath.yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-hostpath
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: local-log
      mountPath: /var/log/nginx
  volumes:
  - name: local-log
    hostPath:
      path: /data/nginx-logs       # 宿主机绝对路径
      type: DirectoryOrCreate      # 目录不存在则自动创建
EOF
# 部署命令：kubectl apply -f demo-hostpath.yaml
# 典型场景：节点本地日志采集、单节点固定部署的应用  通常配合nodeSelector使用


# ============== 3. NFS 网络持久化存储 ==============
# 前置条件：所有节点安装nfs客户端，NFS服务器已配置共享目录
# 特性：真正持久化，跨节点访问，支持多Pod同时读写
cat <<EOF > demo-nfs.yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-nfs
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: upload-data
      mountPath: /usr/share/nginx/html/upload
  volumes:
  - name: upload-data
    nfs:
      server: 10.0.0.80            # NFS服务器IP地址
      path: /data/k8s-share        # NFS共享目录路径
EOF
# 部署命令：kubectl apply -f demo-nfs.yaml
# 典型场景：业务持久化数据、多副本共享静态资源
```

三者对比总结

| 维度        | emptyDir                | hostPath                 | NFS                      |
| ----------- | ----------------------- | ------------------------ | ------------------------ |
| 持久化能力  | ❌ 随 Pod 销毁           | ⚠️ 随节点保留             | ✅ 永久保留               |
| 跨节点访问  | ❌                       | ❌                        | ✅                        |
| 多 Pod 共享 | ❌                       | ❌（仅同节点）            | ✅                        |
| 读写性能    | 本地磁盘，好            | 本地磁盘，最好           | 网络传输，一般           |
| 配置难度    | 极低                    | 低                       | 中（需搭建 NFS 服务）    |
| 生命周期    | 和 Pod 一致             | 和节点磁盘一致           | 独立生命周期             |
| 典型场景    | 临时缓存、同 Pod 传文件 | 节点本地日志、固定单实例 | 业务持久数据、多副本共享 |

### 一、为什么要对接分布式存储？🎯

Pod 是临时的：容器销毁本地数据全丢，而且 Pod 会在节点间漂移。分布式存储解决三个痛点：

1. **数据持久化**：Pod 销毁重建，数据不丢
2. **跨节点挂载**：Pod 漂移到任意节点，都能挂载同一份数据
3. **多实例共享**：支持多 Pod 同时读写（**RWX 模式**），本地存储做不到

K8s 不直接管底层存储，而是通过 **PV/PVC 抽象层**对接 NFS、Ceph、Longhorn 等，业务只需声明需求、不用感知细节。

### 二、为什么引入 PV/PVC？🎯

核心是**存储层抽象解耦**，把"业务用存储"和"底层存储实现"彻底拆开：

- **职责分离**：管理员维护 PV，开发只用 PVC 申请容量和读写模式
- **环境解耦**：YAML 不绑定具体存储地址 / 类型，换存储、跨环境迁移都不用改
- **统一管控**：存储参数、凭证统一配在 PV，一处修改全量生效
- **自动交付**：配合 StorageClass 动态供应，按需自动创建 PV

------

### 二、核心概念通俗理解

| 资源         | 全称                  | 角色定位     | 通俗类比                                          | 作用范围                         |
| :----------- | :-------------------- | :----------- | :------------------------------------------------ | :------------------------------- |
| PV           | PersistentVolume      | 持久化卷     | 分布式存储里提前划分好的一块独立存储空间          | 集群级（全集群可见）             |
| PVC          | PersistentVolumeClaim | 持久化卷声明 | 用户的「存储申请单」，写明容量、访问模式等要求    | 命名空间级（仅当前命名空间可用） |
| StorageClass | 存储类                | 存储模板     | 定义存储类型、供应插件、参数，用来自动批量生成 PV | 集群级                           |

#### 核心绑定逻辑

PVC 和 PV 是**一对一绑定**关系：

1. 用户创建 PVC，声明存储需求
2. 系统在集群中自动匹配符合要求的 PV，完成绑定
3. Pod 通过挂载 PVC 来使用存储
4. 绑定后 PV 被该 PVC 独占，直到 PVC 被删除才会释放

------

### 三、核心属性与绑定规则 🎯

#### 1. 关键属性

**（1）容量 `capacity`**：单位 Gi/Mi，PVC 匹配 PV 的核心条件之一。

**（2）访问模式 `accessModes`**（🎯 面试常考）：

| 模式 | 含义 | 场景 |
| --- | --- | --- |
| `ReadWriteOnce`（RWO） | 仅能被**一个节点**挂载读写 | 单实例有状态应用（MySQL） |
| `ReadOnlyMany`（ROX） | 可被**多节点**只读挂载 | 共享静态资源 |
| `ReadWriteMany`（RWX） | 可被**多节点**同时读写 | 多 Pod 共享数据（**只有分布式存储支持**） |

**（3）回收策略 `persistentVolumeReclaimPolicy`**（🎯 面试常考）：

| 策略 | 行为 | 适用 |
| --- | --- | --- |
| `Retain` | PVC 删除后 **PV 和数据都保留**，需手动清理 | **生产首选，数据安全** |
| `Delete` | PVC 删除后 **PV 和数据一起自动删除** | 动态供应默认，临时数据 |
| `Recycle` | 已废弃 | 不用 |

**（4）存储类 `storageClassName`**：PVC 和 PV **必须同名**才能匹配；动态供应必须指定，用来调用对应插件自动建 PV。

#### 2. 绑定规则（需同时满足）🎯

1. `storageClassName` 完全一致（都为空也算一致）
2. PVC 申请容量 **≤** PV 总容量
3. PVC 要求的访问模式，PV 必须支持
4. **一对一独占**，不可重复绑定
5. 没有匹配的 PV 时，PVC 一直处于 **`Pending`**

------

### 四、两种存储供应模式

#### 1. 静态供应（Static Provisioning）

- **流程**：管理员提前手动创建一批 PV → 用户创建 PVC → 系统自动匹配绑定
- **优点**：逻辑简单，无需额外插件
- **缺点**：需要提前规划，容量不匹配容易造成资源浪费，无法按需分配
- **适用场景**：小规模集群、固定业务存储

#### 2. 动态供应（Dynamic Provisioning）

- **流程**：管理员部署存储驱动插件 + 创建 StorageClass → 用户创建 PVC → 系统自动调用存储接口创建对应大小的 PV 并绑定
- **优点**：按需分配，无浪费，自动化程度高，支持大规模集群
- **生产环境主流方案**，绝大多数分布式存储都支持动态供应

------

### 五、分布式存储对接实操（NFS 为例，内网最常用）

NFS 是最简单的分布式文件存储，原生支持 RWX 多节点共享，内网部署成本极低，是入门分布式存储的首选。

#### 前置条件

- 已部署 NFS 服务器（示例 IP：`10.0.0.80`，共享目录：`/data/k8s-nfs`）
- 所有 K8s 节点都安装了 `nfs-utils` 客户端，可正常挂载 NFS

------

#### 方案 1：静态 PV 对接（入门首选）

##### 1. 创建 PV（nfs-pv.yaml）



```bash

apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-pv   # PV名称，集群内唯一
spec:
  capacity: 
    storage: 5Gi   # PV总容量
  accessModes:
  - ReadWriteMany   # 支持多节点读写，分布式存储核心能力
  persistentVolumeReclaimPolicy: Retain  # 回收策略：保留数据
  storageClassName: nfs-static           # 存储类名，PVC必须和该值一致
  nfs:					   # 底层存储类型为NFS
    server: 10.0.0.80      # NFS服务器地址              
    path: /data/k8s        # NFS上的共享目录（需提前手动创建）    
    

```

执行创建：



```bash
kubectl apply -f nfs-pv.yaml
kubectl get pv
```

##### 2. 创建 PVC（nfs-pvc.yaml）



```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: eladmin-web-pvc
  namespace: luffy         # 和业务Pod同命名空间
spec:
  accessModes:
    - ReadWriteMany        # 和PV访问模式匹配
  storageClassName: nfs-static  # 和PV存储类名完全一致
  resources:
    requests:
      storage: 5Gi         # 申请5G容量，≤PV容量即可匹配
      

```

执行创建

```bash
kubectl apply -f nfs-pvc.yaml
kubectl get pvc -n luffy
# 状态变为 Bound 即为绑定成功
```

##### 3. Deployment 挂载 PVC 使用

修改 eladmin-web 部署配置，将业务目录挂载到分布式存储：



```yaml
spec:
  template:
    spec:
      imagePullSecrets:
      - name: registry-10-0-0-80
      # 定义卷，关联PVC
      volumes:
      - name: web-data
        persistentVolumeClaim:
          claimName: eladmin-web-pvc  # 绑定上面创建的PVC
      containers:
      - name: eladmin-web
        image: 10.0.0.80:5000/eladmin/eladmin-web:v1
        # 容器内挂载路径
        volumeMounts:
        - name: web-data
          mountPath: /usr/share/nginx/html/upload
          
 
```



#### [PV与PVC管理NFS存储卷实践](http://49.7.203.222:2023/#/kubernetes-advanced/pv?id=pv与pvc管理nfs存储卷实践)



```bash

# 服务端：10.0.0.80
-------------------------------------
yum -y install nfs-utils rpcbind

# 共享目录
mkdir -p /data/k8s && chmod 755 /data/k8s

echo '/data/k8s  *(insecure,rw,sync,no_root_squash)'>>/etc/exports

systemctl enable --now rpcbind 
systemctl enable --now nfs 

# 客户端：k8s集群slave节点
---------------------------------------------------
yum -y install nfs-utils rpcbind
mkdir /nfsdata
mount -t nfs 10.0.0.80:/data/k8s /nfsdata #这里挂载是测试, 可以不挂载
umount /nfsdata


PV与PVC演示
# 在nfs-server机器中创建
mkdir -p /data/k8s/nginx

# 把/data/k8s/nginx 目录作为数据卷给k8s集群中的Pod使用
cat <<EOF > pv-nfs.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-pv
spec:
  capacity: 
    storage: 1Gi
  accessModes:
  - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  nfs:
    path: /data/k8s/nginx
    server: 10.0.0.80
EOF

kubectl create -f pv-nfs.yaml

$ kubectl get pv
NAME     CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS  
nfs-pv   1Gi        RWO            Retain           Available

一个 PV 的生命周期中，可能会处于4中不同的阶段：
Available（可用）：表示可用状态，还未被任何 PVC 绑定
Bound（已绑定）：表示 PV 已经被 PVC 绑定
Released（已释放）：PVC 被删除，但是资源还未被集群重新声明
Failed（失败）： 表示该 PV 的自动回收失败

cat <<EOF > pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nfs
  namespace: luffy     # 和业务Pod同命名空间
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
EOF

kubectl create -f pvc.yaml

$ kubectl get pvc
NAME      STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-nfs   Bound    nfs-pv   1Gi        RWX                          5s
$ kubectl get pv
NAME     CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM             
nfs-pv   1Gi        RWX            Retain           Bound    default/pvc-nfs             

#访问模式，storage大小（pvc大小需要小于pv大小），以及 PV 和 PVC 的 storageClassName 字段必须一样，这样才能够进行绑定。

#PersistentVolumeController会不断地循环去查看每一个 PVC，是不是已经处于 Bound（已绑定）状态。如果不是，那它就会遍历所有的、可用的 PV，并尝试将其与未绑定的 PVC 进行绑定，这样，Kubernetes 就可以保证用户提交的每一个 PVC，只要有合适的 PV 出现，它就能够很快进入绑定状态。而所谓将一个 PV 与 PVC 进行“绑定”，其实就是将这个 PV 对象的名字，填在了 PVC 对象的 spec.volumeName 字段上。

# 查看nfs数据目录
$ ls /nfsdata


创建Pod挂载pvc
----------------------------------------------------------
cat <<EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-nfs-pvc
  namespace: luffy
spec:
  replicas: 1
  selector:        #指定Pod的选择器
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: web
        volumeMounts:                        #挂载容器中的目录到pvc nfs中的目录
        - name: www
          mountPath: /usr/share/nginx/html
      volumes:
      - name: www
        persistentVolumeClaim:              #指定pvc
          claimName: pvc-nfs
EOF

kubectl create -f deployment.yaml

# 查看容器/usr/share/nginx/html目录

kubectl -n luffy get pvc
kubectl get pv


kubectl -n luffy get po

kubectl -n luffy exec -ti nfs-pvc-79f876c88d-cd4dc -- sh
/ # ls /usr/share/nginx/html #这个目录就是挂载的nfs

# 删除pvc
kubectl -n luffy delete deploy nginx-nfs-pvc
kubectl -n luffy delete pvc pvc-nfs
kubectl delete pv nfs-pv

```





#### 方案 2：动态供应对接（生产推荐）

无需提前创建 PV，用户申请 PVC 时系统自动在 NFS 上创建目录并生成对应 PV。

##### 核心步骤

1. 部署 `nfs-subdir-external-provisioner` 插件，负责对接 NFS 服务器、自动创建 PV
2. 创建 StorageClass 存储类，关联插件
3. 用户创建 PVC 时指定该 StorageClass，自动完成 PV 创建 + 绑定

部署： https://github.com/kubernetes-retired/external-storage

```bash

cat <<EOF >provisioner.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nfs-client-provisioner
  labels:
    app: nfs-client-provisioner
  # replace with namespace where provisioner is deployed
  namespace: nfs-provisioner
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nfs-client-provisioner
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nfs-client-provisioner
  template:
    metadata:
      labels:
        app: nfs-client-provisioner
    spec:
      serviceAccountName: nfs-client-provisioner
      containers:
        - name: nfs-client-provisioner
          image: registry.cn-beijing.aliyuncs.com/mydlq/nfs-subdir-external-provisioner:v4.0.0
          volumeMounts:
            - name: nfs-client-root
              mountPath: /persistentvolumes
          env:
            - name: PROVISIONER_NAME
              value: luffy.com/nfs
            - name: NFS_SERVER
              value: 10.0.0.80
            - name: NFS_PATH  
              value: /data/k8s
      volumes:
        - name: nfs-client-root
          nfs:
            server: 10.0.0.80
            path: /data/k8s
EOF

cat <<EOF > rbac.yaml
kind: ServiceAccount
apiVersion: v1
metadata:
  name: nfs-client-provisioner
  namespace: nfs-provisioner
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: nfs-client-provisioner-runner
  namespace: nfs-provisioner
rules:
  - apiGroups: [""]
    resources: ["persistentvolumes"]
    verbs: ["get", "list", "watch", "create", "delete"]
  - apiGroups: [""]
    resources: ["persistentvolumeclaims"]
    verbs: ["get", "list", "watch", "update"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["storageclasses"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["events"]
    verbs: ["create", "update", "patch"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: run-nfs-client-provisioner
  namespace: nfs-provisioner
subjects:
  - kind: ServiceAccount
    name: nfs-client-provisioner
    namespace: nfs-provisioner
roleRef:
  kind: ClusterRole
  name: nfs-client-provisioner-runner
  apiGroup: rbac.authorization.k8s.io
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: leader-locking-nfs-client-provisioner
  namespace: nfs-provisioner
rules:
  - apiGroups: [""]
    resources: ["endpoints"]
    verbs: ["get", "list", "watch", "create", "update", "patch"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: leader-locking-nfs-client-provisioner
  namespace: nfs-provisioner
subjects:
  - kind: ServiceAccount
    name: nfs-client-provisioner
    # replace with namespace where provisioner is deployed
    namespace: nfs-provisioner
roleRef:
  kind: Role
  name: leader-locking-nfs-client-provisioner
  apiGroup: rbac.authorization.k8s.io
EOF

cat <<EOF >storage-class.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"   # 设置为default StorageClass
  name: nfs
provisioner: luffy.com/nfs  #和驱动器名字一样
parameters:
  archiveOnDelete: "true"    # 删除PVC时是否归档数据，false直接删除
EOF

kubectl create namespace nfs-provisioner
kubectl create -f provisioner.yaml
kubectl create -f rbac.yaml
kubectl create -f storage-class.yaml

# 等待pod启动成功
$ kubectl -n nfs-provisioner get pod 
NAME                                      READY   STATUS    RESTARTS   AGE
nfs-client-provisioner-6c86fc96fc-hbf87   1/1     Running   0          11s

# kubectl get storageclass
NAME            PROVISIONER     RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
nfs (default)   luffy.com/nfs   Delete          Immediate           false                  21s


验证使用storageclass自动创建并绑定pv

cat <<EOF >pvc.yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-claim
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Mi
  storageClassName: nfs
EOF

kubectl apply -f pvc.yaml

kubectl -n nfs-provisioner get po
kubectl get pvc
kubectl get pv

[存储服务器 ~]# ll /data/k8s/
drwxrwxrwx 2 root root 6 Oct 23 09:50 default-test-claim-pvc-1dc41736-9197-422c-a99a-6fbb2389123d

kubectl -n nfs-provisioner logs -f nfs-client-provisioner-647dd55455-wzdd2


# 把之前mysql的数据改成pvc方式
cat <<EOF >mysql-pvc.yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: mysql
  namespace: luffy
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
  storageClassName: nfs
EOF

kubectl create -f mysql-pvc.yaml

kubectl -n luffy get pvc

#打包mysql数据
# cd /opt/mysql/ ; tar zcf mysql.tar *
#启动一个简单http
# python -m SimpleHTTPServer 9099

[存储服务器 ~]# wget k8s-master:9099/mysql.tar
# tar zxvf mysql.tar
# tar zxvf mysql.tar -C /data/k8s/luffy-mysql-pvc-02ec7c1b-b3fc-412b-a58f-5dd1d3e2820c/

#修改deployment-mysql.yaml 文件
cat <<EOF > deployment-mysql.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  namespace: luffy
spec:
  replicas: 1    #指定Pod副本数
  selector:        #这个选择器可以去掉了 因为用了共享的pvc存储
    matchLabels:
      app: mysql
  strategy:
      type: Recreate
  template:
    metadata:
      labels:    #给Pod打label,必须和上方的matchLabels匹配
        app: mysql
        from: luffy
    spec:
      containers:
      - name: mysql
        image: mysql:5.7
        args:
        - --character-set-server=utf8mb4
        - --collation-server=utf8mb4_unicode_ci
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: eladmin-secret
              key: DB_PWD
        - name: MYSQL_DATABASE
          value: "eladmin"
        resources:
          requests:
            memory: 200Mi
            cpu: 50m
          limits:
            memory: 1Gi
            cpu: 500m
        readinessProbe:
          tcpSocket:
            port: 3306
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:
          tcpSocket:
            port: 3306
          initialDelaySeconds: 15
          periodSeconds: 20
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-data   #新增加的
        persistentVolumeClaim:
          claimName: mysql
      nodeSelector:   # 使用节点选择器将Pod调度到指定label的节点
        mysql: "true"
EOF
kubectl apply -f deployment-mysql.yaml

[root@k8s-master ~]# kubectl -n luffy exec -ti mysql-85ff4769c9-csd9x -- sh
sh-4.2# mysql -uroot -pluffyAdmin!
mysql> show databases;
mysql> use eladmin;
mysql> show tables;


```



### 六、主流分布式存储方案对比

| 存储方案 | 存储类型     | 支持访问模式 | 适用场景                          | 部署难度 |
| :------- | :----------- | :----------- | :-------------------------------- | :------- |
| NFS      | 文件存储     | RWX/ROX      | 中小规模、静态资源共享、日志存储  | 极低     |
| Ceph RBD | 块存储       | RWO          | 数据库、高性能有状态应用          | 高       |
| CephFS   | 文件存储     | RWX/ROX      | 大规模多 Pod 共享文件、大数据场景 | 高       |
| Longhorn | 云原生块存储 | RWO          | K8s 原生轻量方案、多副本高可用    | 中       |

------

### 七、常见注意事项

1. **RWX 依赖底层存储**：本地盘、云硬盘都不支持多节点读写，只有分布式文件存储可实现
2. **删除顺序**：先删 Pod/Deployment → 再删 PVC → 最后删 PV，避免 PV 卡住变为 Terminating
3. **资源范围**：PV 是集群级资源，PVC 是命名空间级资源；不同命名空间不能共用同一个 PVC
4. **数据备份**：分布式存储不等于绝对安全，核心业务数据仍需定期备份



## [安装容器管理平台](http://49.7.203.222:2023/#/kubernetes-advanced/pv?id=安装容器管理平台)

市面上存在很多开源的容器管理平台，可以帮助用户快速管理k8s平台中的业务服务，今天学习下`kubesphere`的使用。

###### [安装](http://49.7.203.222:2023/#/kubernetes-advanced/pv?id=安装)

安装的版本为`v3.3.1`

- 前置要求

  - 要求集群中存在默认的`StorageClass`，上篇中我们把nfs设置为了集群默认的存储类，因此满足要求。
  - 集群安装metrics-server

  https://kubesphere.com.cn/docs/v3.3/installing-on-kubernetes/introduction/prerequisites/

- 下载初始化安装文件

```bash

mkdir kubesphere ;cd kubesphere
wget https://github.com/kubesphere/ks-installer/releases/download/v3.3.1/kubesphere-installer.yaml
wget https://github.com/kubesphere/ks-installer/releases/download/v3.3.1/cluster-configuration.yaml
wget https://raw.githubusercontent.com/kubesphere/notification-manager/master/config/bundle.yaml

#备用地址
wget https://gitee.com/chengkanghua/script/raw/master/k8s/bundle.yaml
wget https://gitee.com/chengkanghua/script/raw/master/k8s/cluster-configuration.yaml
wget https://gitee.com/chengkanghua/script/raw/master/k8s/kubesphere-installer.yaml

sed -i.bak '290s#kubesphere/ks-installer:v3.3.1#registry.cn-beijing.aliyuncs.com/kubesphereio/ks-installer:v3.3.1#g' kubesphere-installer.yaml

# 修改配置为外部监控,  如果是干净的K8S(没有安装其他的监控,可以不用修改)
# vim cluster-configuration.yaml
42     monitoring:
43       type: external  
44       endpoint: http://prometheus.monitor:9090 


安装
kubectl create ns kubesphere-monitoring-system
kubectl create -f kubesphere-installer.yaml
kubectl create -f cluster-configuration.yaml
kubectl create -f bundle.yaml
# 查看安装器日志
# kubectl -n kubesphere-system get pod
ks-installer-746f68548d-mcgvh   1/1     Running   0          2m4s
# 查看日志,显示安装整个过程
# kubectl -n  kubesphere-system logs -f ks-installer-746f68548d-mcgvh


卸载
# 如果想卸载kubesphere
https://github.com/kubesphere/ks-installer/blob/release-3.3/scripts/kubesphere-delete.sh
wget https://gitee.com/chengkanghua/script/raw/master/k8s/kubesphere-delete.sh

kubectl delete -f kubesphere-installer.yaml
kubectl delete -f cluster-configuration.yaml
kubectl delete -f bundle.yaml


# sh kubesphere-delete.sh

```



## [Kubernetes 集群网络实现完整解析](https://docs.chengkanghua.top/k8s-2023/4Kubernetes进阶实践?id=集群网络)

容器网络核心回顾

```bash
# Docker 容器网络创建流程（精简版）
# 1. 新建独立网络命名空间，隔离IP/路由/端口栈，启用lo回环接口
# 2. 生成veth pair虚拟网卡对，两端天然直通，作为虚拟网线
# 3. 宿主机端接入docker0网桥，加入宿主机二层虚拟交换网络
# 4. 对端移入容器命名空间，重命名为eth0作为容器主网卡
# 5. IPAM从网桥子网分配空闲IP，配置eth0地址与子网掩码
# 6. 写入容器路由表，默认网关指向网桥IP，打通跨网段转发路径

# 额外：配置-p端口映射时，宿主机iptables添加DNAT规则
# 实现外部流量通过宿主机端口转发至容器内部服务端口
```



Kubernetes 本身不直接实现网络，而是通过 **CNI（容器网络接口）标准** 对接第三方网络插件，整个网络体系围绕「IP-per-Pod 扁平化模型」构建，所有 Pod 在逻辑上处于同一个可直接互通的局域网。

------

### 一、核心网络模型与基础原则

#### 1. 核心原则：IP-per-Pod

- 每个 Pod 拥有**集群内唯一的 IP 地址**，Pod 内所有容器共享该 IP 与端口空间
- 所有 Pod 处于一个扁平的三层网络中，互相之间可直接通信，默认无需 NAT 地址转换
- Pod IP 是虚拟网络地址，由 CNI 插件统一分配管理

#### 2. 网络三大平面



| 平面         | 作用                                | 地址示例                 |
| :----------- | :---------------------------------- | :----------------------- |
| 节点网络     | 节点物理 / 虚拟机通信，集群底层基础 | 物理网段 `10.0.0.0/24`   |
| Pod 网络     | Pod 之间业务通信的虚拟网络          | CNI 分配 `10.244.0.0/16` |
| Service 网络 | 服务发现的虚拟 IP 网络，无实体接口  | 集群指定 `10.96.0.0/12`  |

#### 3. CNI 的角色

CNI 是 K8s 定义的容器网络标准接口，kubelet 创建 Pod 时会调用 CNI 插件完成：

- 为 Pod 分配 IP 地址
- 创建虚拟网卡、配置网桥 / 路由规则
- 打通 Pod 与集群网络的连通性

主流 CNI 插件：Flannel、Calico、Cilium 等。

------

### 二、五大通信场景的实现原理

#### 场景 1：同一 Pod 内容器通信

**实现方式：共享网络命名空间**

- Pod 内有一个 `pause` 基础设施容器，负责持有独立的 Network Namespace
- 所有业务容器加入该命名空间，共享同一个 IP、端口、路由表
- 容器之间通过 `lo` 回环接口通信，等价于本机进程通过 [localhost](https://link.wtturl.cn/?target=https%3A%2F%2Flocalhost&scene=im&aid=582478&lang=zh) 互访，无性能损耗

#### 场景 2：同一节点 Pod 之间通信

**实现方式：虚拟网桥 + veth 虚拟网卡对**

1. 每个 Pod 创建时生成一对 `veth pair` 虚拟网卡：一端留在 Pod 内作为 `eth0`，另一端接入节点上的虚拟网桥（如 `cni0`）
2. 同节点 Pod 互访时，数据包经 veth 到达网桥，网桥通过 ARP 表匹配目标 Pod 对应的 veth 口，直接二层转发
3. 全程不出节点，无额外封装，性能接近原生

#### 场景 3：跨节点 Pod 之间通信（核心难点）🎯

两种技术路线：

| 方案 | 代表 | 原理 | 优点 | 缺点 |
| --- | --- | --- | --- | --- |
| **Overlay**（封装 / 隧道） | Flannel VXLAN、Calico IPIP | 把 Pod 数据包**套进节点 IP 包**里传：源 Pod → 网桥 → 封装外层节点 IP 头 → 物理网络 → 目标节点解封装 → 目标 Pod | 不依赖底层网络，公有云 / 复杂机房都能用 | 封装解封装有 **10%~20% 性能损耗** |
| **Underlay**（路由，无封装） | Flannel host-gw、Calico BGP | 不封装，节点路由表里写全集群 Pod 网段，**下一跳 = 目标节点物理 IP**，三层路由直达 | **性能接近物理网络** | 依赖底层网络（需二层互通或支持 BGP），公有云常受限 |

#### 场景 4：Pod 访问 Service（ClusterIP）

Service 是**虚拟 IP**，无实体网络接口，由 `kube-proxy` 组件实现转发：

1. kube-proxy 监听 APIServer，实时同步 Service 与 Endpoint（Pod 地址）信息
2. 在每个节点上生成 `iptables` 或 `ipvs` 转发规则
3. Pod 访问 ClusterIP 时，数据包在节点网络栈被 DNAT 转换，目标地址替换为真实 Pod IP
4. 后续流量走 Pod 网络正常转发到目标 Pod

- 负载均衡由节点本地的 iptables/ipvs 实现，默认轮询策略
- 常见误区：ClusterIP 无法 ping 通是正常的，只有端口流量才会触发 DNAT 转发

#### 场景 5：集群外部访问（南北向流量）

1. **NodePort**：在所有节点上开放一个固定端口（范围 30000-32767），外部通过 `节点IP:NodePort` 访问，流量经 kube-proxy 转发到 Pod
2. **LoadBalancer**：公有云负载均衡服务，绑定公网 IP，后端转发到各节点的 NodePort，是 NodePort 的上层封装
3. **Ingress**：七层统一入口，按域名、路径转发到不同 Service；由 Ingress Controller（如 Nginx Ingress）以 Pod 形式运行，本身通过 NodePort/LoadBalancer 对外暴露

> 🎯 **五大通信场景一句话总结**（面试高频）：
> ① 同 Pod 内容器 → 共享网络命名空间，走 `lo` 回环；
> ② 同节点 Pod → 虚拟网桥 `cni0` + `veth pair` 二层转发；
> ③ 跨节点 Pod → **Overlay 隧道封装** 或 **Underlay 路由直达**；
> ④ Pod → Service → kube-proxy 的 **iptables / ipvs 做 DNAT**；
> ⑤ 外部流量 → **NodePort / LoadBalancer（四层）** 或 **Ingress（七层）**。

------

### 三、配套核心组件 🎯

#### 1. CoreDNS（服务发现）

集群默认部署的 DNS 服务，属于网络体系的核心配套：

- 负责将 Service 名称解析为 ClusterIP
- Pod 默认自动配置 CoreDNS 为 DNS 服务器，实现通过服务名互访，无需硬编码 IP

#### 2. 网络策略 NetworkPolicy

由支持网络策略的 CNI 插件（如 Calico、Cilium）实现，用于管控 Pod 之间的访问规则，实现细粒度的网络隔离。

------

### 四、主流 CNI 插件对比 🎯

| 插件    | 技术路线        | 网络策略   | 性能 | 适用场景                             |
| :------ | :-------------- | :--------- | :--- | :----------------------------------- |
| Flannel | VXLAN / host-gw | ❌ 不支持   | 一般 | 入门、小规模集群、功能要求简单       |
| Calico  | BGP / IPIP      | ✅ 支持     | 较好 | 生产环境、需要网络隔离、中大规模     |
| Cilium  | eBPF            | ✅ 高级策略 | 优秀 | 高性能、可观测性要求高、超大规模集群 |

------

### 五、核心组件角色总结

- `pause` 容器：持有 Pod 的网络命名空间，是 Pod 网络的载体
- **CNI 插件**：分配 Pod IP、配置虚拟网卡与路由，打通 Pod 网络
- `kube-proxy`：实现 Service 转发、负载均衡，维护节点转发规则
- `CoreDNS`：集群内部 DNS 服务发现
- **Ingress Controller**：集群七层流量入口，统一对外暴露服务









## [Helm部署应用](https://docs.chengkanghua.top/k8s-2023/4Kubernetes进阶实践?id=helm部署应用)

### 一、Helm 是什么 🎯

Helm 是 Kubernetes 的**包管理工具**，等价于 Linux 系统的 yum/apt。它将一个应用所需的全部 K8s 资源（Deployment、Service、ConfigMap、PVC 等）封装为一个 **Chart 包**，实现应用一键部署、版本管控、升级回滚，解决原生 YAML 零散冗余、复用性差、运维成本高的问题。

------

### 二、核心概念

1. **Chart**：应用安装包，包含所有 K8s 资源模板、默认配置、依赖关系，可复用、可分享，类比软件安装包。
2. **Release**：Chart 在集群中部署后的运行实例，同一个 Chart 可在不同命名空间部署多个独立 Release。
3. **Repository（Repo）**：Chart 仓库，集中存放分发 Chart 的服务端，类比软件源。

------

### 三、安装 Helm + 配置国内源

#### 1. 二进制安装（稳定版 v3.14.0，兼容 K8s 1.20+）

```bash
# k8s-master节点
wget https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz
tar -zxf helm-v3.2.4-linux-amd64.tar.gz
cp linux-amd64/helm /usr/sbin/
helm version
helm env



```

#### 2. 配置国内 Chart 仓库（解决海外源访问失败）



```bash
# 查看仓库
helm repo ls
# 添加仓库
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add aliyun https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
# 同步最新charts信息到本地
helm repo update



helm -n wordpress install wordpress stable/wordpress \
--set mariadb.primary.persistence.enabled=false \
--set service.type=ClusterIP \
--set ingress.enabled=true \
--set persistence.enabled=false \
--set ingress.hostname=wordpress.luffy.com
```

------

### 四、核心部署全流程

```bash


# helm 搜索chart包
helm search repo wordpress

kubectl create namespace wordpress
# 从仓库安装
$ helm -n wordpress install wordpress stable/wordpress --set mariadb.primary.persistence.enabled=false --set service.type=ClusterIP --set ingress.enabled=true --set persistence.enabled=false --set ingress.hostname=wordpress.luffy.com
# 参数详细说明
# 1. -n wordpress：指定部署到wordpress命名空间
# 2. install wordpress：创建一个名为wordpress的Release实例
# 3. stable/wordpress：使用stable仓库下的wordpress Chart包
# 4. --set mariadb.primary.persistence.enabled=false：关闭MariaDB数据库的数据持久化（不创建PVC，Pod删除数据丢失）
# 5. --set service.type=ClusterIP：Service类型设置为ClusterIP，仅集群内部可访问，不暴露节点端口
# 6. --set ingress.enabled=true：开启Ingress七层反向代理，用于域名方式对外访问
# 7. --set persistence.enabled=false：关闭wordpress网站目录持久化，不挂载存储卷
# 8. --set ingress.hostname=wordpress.luffy.com：配置Ingress访问域名为wordpress.luffy.com


# 查看release
$ helm -n wordpress ls
$ kubectl -n wordpress get all 

# chart不适配k8s的ingress，需要添加上ingressClassName: nginx
$ kubectl -n wordpress edit ing wordpress
...
spec:
  ingressClassName: nginx
  rules:
  - host: wordpress.luffy.com
...

# 从chart仓库中把chart包下载到本地
helm pull stable/wordpress


# 卸载
helm -n wordpress uninstall wordpress


```



示例2

```bash
$ helm create nginx
#快速生成名为 nginx 的自定义 Chart 模板目录，用来封装自己的 K8s 部署模板。
#核心目录作用
#Chart.yaml：Chart 描述文件，记录名称、版本、类型等元数据
#values.yaml：全局配置文件，存放镜像、副本数、端口等可修改参数
#templates/：存放 Deployment、Service 等 K8s 资源 yaml 模板，支持变量渲染
#charts/：存放当前 Chart 依赖的其他 Chart 包


# 从本地 安装到别的命名空间demo
$ kubectl create namespace demo
# Helm本地Chart部署命令
helm -n demo install nginx ./nginx --set replicaCount=2 --set image.tag=alpine
# 参数说明
# -n demo：指定部署到demo命名空间
# install nginx：设置本次Release名称为nginx
# ./nginx：使用当前目录下自定义的nginx Chart模板
# --set replicaCount=2：设置Pod副本数为2
# --set image.tag=alpine：指定镜像标签为alpine版本

# 查看
$ helm ls
$ helm -n demo ls

# 含义：查看demo命名空间下常用基础K8s资源
$ kubectl -n demo get all

# 等价多条命令：
kubectl -n demo get pods
kubectl -n demo get service
kubectl -n demo get deployment
kubectl -n demo get replicaset

# 补充：get all不会查询configmap、secret、ingress、pvc、pv、hpa等资源







```



### char包 文件解析

```bash
$ tree nginx/
nginx/
├── charts                        # 存放子chart
├── Chart.yaml                    # 记录 Chart 名称、版本、应用版本、描述、依赖等。
├── templates                     # chart运行所需的资源清单模板，用于和values做渲染
│   ├── deployment.yaml
│   ├── _helpers.tpl              # 定义全局的命名模板，方便在其他模板中引入使用
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── NOTES.txt                # helm安装完成后终端的提示信息
│   ├── serviceaccount.yaml
│   ├── service.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml                    # 模板变量配置文件，YAML 语法

资源清单都在templates中，数据来源于values.yaml，
安装的过程将模板与数据融合成k8s可识别的资源清单，然后部署到k8s环境中。

各模板文件作用
deployment.yaml：工作负载模板
service.yaml：Service 资源模板
ingress.yaml：Ingress 路由模板
hpa.yaml：自动扩缩容模板
serviceaccount.yaml：服务账号模板
_helpers.tpl：公共命名模板，统一拼接名称、标签，避免重复代码
NOTES.txt：安装成功后命令行输出的提示文本，支持模板语法
tests/ 下：Chart 安装后的连通性测试模板


helm install --dry-run --debug debug-nginx ./nginx --set replicaCount=2 
helm install --dry-run nginx ./nginx -n demo
#--dry-run：只渲染模板、校验语法，不真正部署资源，日常改配置必用，属于常规预检查参数。
#--debug：打印详细调试日志（变量渲染全过程、所有模板详情）
# templates/ 目录（Go Template 模板语法 + YAML）
helm 核心，将 values 变量渲染成标准 K8s YAML 资源。

语法查看 & 调试命令（最常用）
# 1. 本地渲染模板，输出最终yaml（检查语法错误最常用）
helm template ./nginx
# 2. 带命名空间+自定义参数渲染
helm template ./nginx -n demo --set replicaCount=2
# 3. 安装试运行，只校验不真正部署
helm install --dry-run nginx ./nginx -n demo


[root@k8s-master ~]# egrep -v '^#|^$' nginx/Chart.yaml
apiVersion: v2   #Chart API 版本，固定 v2
name: nginx
description: A Helm chart for Kubernetes
type: application
version: 0.1.0
appVersion: "1.16.0"
------------------------------------------------------------------
[root@k8s-master ~]# egrep -v "^ *#|^$" nginx/values.yaml
replicaCount: 1  # Pod副本数量

image:
  repository: nginx  # 镜像名称
  pullPolicy: IfNotPresent  # 镜像拉取策略，本地不存在才拉取
  tag: ""  # 镜像标签，为空则默认使用Chart中appVersion

imagePullSecrets: []  # 私有镜像仓库拉取凭证
nameOverride: ""  # 自定义短名称，用于覆盖默认Chart名称
fullnameOverride: ""  # 自定义资源完整名称

serviceAccount:
  create: true  # 是否自动创建ServiceAccount
  automount: true  # 是否自动挂载ServiceAccount密钥到Pod
  annotations: {}  # ServiceAccount注解
  name: ""  # 自定义ServiceAccount名称

podAnnotations: {}  # Pod维度注解
podLabels: {}  # Pod自定义标签

podSecurityContext: {}  # Pod安全上下文配置
securityContext: {}  # 容器安全上下文配置

service:
  type: ClusterIP  # Service类型，默认集群内部访问
  port: 80  # Service监听端口

ingress:
  enabled: false  # 是否开启Ingress网关
  className: ""  # 指定IngressClass资源名称
  annotations: {}  # Ingress注解配置
  hosts:
    - host: chart-example.local  # 访问域名
      paths:
        - path: /  # 路由访问路径
          pathType: ImplementationSpecific  # 路径匹配策略
  tls: []  # HTTPS证书配置

httpRoute:
  enabled: false  # 是否开启Gateway API的HTTPRoute
  annotations: {}  # HTTPRoute注解
  parentRefs:
  - name: gateway
    sectionName: http
  hostnames:
  - chart-example.local  # 访问域名
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /headers

resources: {}  # Pod CPU、内存资源请求与限制

livenessProbe:  # 存活探针，判断容器是否正常运行
  httpGet:
    path: /
    port: http

readinessProbe:  # 就绪探针，判断Pod是否可接收业务流量
  httpGet:
    path: /
    port: http

autoscaling:
  enabled: false  # 是否开启HPA水平自动扩缩容
  minReplicas: 1  # 最小副本数
  maxReplicas: 100  # 最大副本数
  targetCPUUtilizationPercentage: 80  # CPU使用率扩容阈值

volumes: []  # 定义需要挂载的存储卷
volumeMounts: []  # 容器内存储挂载配置

nodeSelector: {}  # 节点选择器，指定Pod调度带对应标签的节点
tolerations: []  # 污点容忍策略，可调度到带污点节点
affinity: {}  # 节点/ Pod亲和、反亲和调度策略

-------------------------------------------------------------------------

[root@k8s-master ~]# cat nginx/templates/_helpers.tpl
{{/*
Expand the name of the chart.
展开当前Chart的名称
*/}}
{{- define "nginx.name" -}}          // 定义一个名为 nginx.name 的可复用模板
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
// default函数：如果Values中配置了nameOverride就用它，否则使用Chart.yaml里定义的Chart名称
// trunc 63：将最终字符串截断最多63个字符（K8s资源名称DNS规范限制）
// trimSuffix "-"：去除字符串末尾多余的横杠，防止命名末尾带-非法字符
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
生成应用完整名称，遵循K8s DNS 63字符限制；如果Release名称已经包含Chart名则直接用Release名
*/}}
{{- define "nginx.fullname" -}}      // 定义模板：生成应用完整名称
{{- if .Values.fullnameOverride }}   // 判断：如果values里配置了完整名称覆盖
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }} // 直接使用配置的名称，做长度和末尾横杠处理
{{- else }}                           // 没有配置名称覆盖，走默认拼接逻辑
{{- $name := default .Chart.Name .Values.nameOverride }} // 先拿到基础应用名，赋值给局部变量$name
{{- if contains $name .Release.Name }} // 判断Release名称中是否已经包含应用基础名
{{- .Release.Name | trunc 63 | trimSuffix "-" }} // 包含则直接使用Release名称作为完整名称
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
// 不包含则拼接格式：Release名称-应用名，同时做长度、末尾横杠处理
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
生成Chart名称+版本号，用于资源标签
*/}}
{{- define "nginx.chart" -}}         // 定义模板：生成Chart标识标签内容
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
// 拼接格式：Chart名-Chart版本号
// replace "+" "_"：把版本号里的+替换成下划线，因为标签不允许+特殊字符
// trunc 63 截断63字符、trimSuffix "-" 去除末尾横杠
{{- end }}

{{/*
Common labels
公共通用标签模板，所有资源统一引用这套标签
*/}}
{{- define "nginx.labels" -}}         // 定义全局公共标签模板
helm.sh/chart: {{ include "nginx.chart" . }} // 引用上面nginx.chart模板，记录当前chart名称版本
{{ include "nginx.selectorLabels" . }}        // 引入选择器标签模板
{{- if .Chart.AppVersion }}                 // 如果Chart.yaml中配置了应用镜像版本
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }} // 打上应用版本标签，quote给值加双引号
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }} // 标记资源由helm管理
{{- end }}

{{/*
Selector labels
标签选择器专用标签，用于Service绑定Pod、控制器筛选Pod
*/}}
{{- define "nginx.selectorLabels" -}} // 定义Pod选择器标签模板
app.kubernetes.io/name: {{ include "nginx.name" . }} // 应用基础名称标签
app.kubernetes.io/instance: {{ .Release.Name }}     // helm发布实例名称标签
{{- end }}

{{/*
Create the name of the service account to use
生成serviceAccount服务账号名称
*/}}
{{- define "nginx.serviceAccountName" -}} // 定义服务账号名称模板
{{- if .Values.serviceAccount.create }}   // 判断是否需要自动创建serviceAccount
{{- default (include "nginx.fullname" .) .Values.serviceAccount.name }}
// 需要创建：优先使用values自定义的账号名，没有则用应用完整名称
{{- else }}                               // 不创建自定义账号
{{- default "default" .Values.serviceAccount.name }}
// 优先用自定义账号名，没配置就使用集群默认default服务账号
{{- end }}
{{- end }}

补充常用函数精简说明
default(默认值, 变量)：变量为空则使用默认值
trunc 63：字符串最大截取 63 位，符合 K8s DNS 命名规范
trimSuffix "-"：清理末尾多余横杠，避免非法名称
contains(子串, 字符串)：判断字符串是否包含指定子串
printf：格式化字符串拼接
replace(旧字符,新字符)：替换字符串中指定字符
quote：给字符串加上双引号，符合 yaml 语法规范
include "模板名" .：调用 define 定义的公共模板，.向下传递全局上下文
{{-：消除模板左右多余空格换行，防止 yaml 空行报错
------------------------------------------------------------------------------
[root@k8s-master ~]# cat nginx/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  # 调用_helpers.tpl中定义的nginx.fullname模板，生成规范的Deployment资源名称
  name: {{ include "nginx.fullname" . }}
  labels:
    # 调用公共标签模板，管道函数nindent 4让所有标签整体缩进4个空格，保证YAML格式正确
    {{- include "nginx.labels" . | nindent 4 }}
spec:
  # 判断：如果没有开启HPA自动扩缩容，才使用values中配置的固定副本数
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      # 引入Pod选择器标签，缩进6个空格，用于Deployment匹配管理下方模板创建的Pod
      {{- include "nginx.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      # with：如果values中配置了podAnnotations Pod注解，则渲染注解片段
      {{- with .Values.podAnnotations }}
      annotations:
        # toYaml将values里的字典数据转为标准YAML格式，整体缩进8空格
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        # 给Pod打上全局公共标签，缩进8个空格
        {{- include "nginx.labels" . | nindent 8 }}
        # 如果用户自定义了Pod标签，则追加自定义标签
        {{- with .Values.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      # 如果配置了镜像拉取密钥（私有仓库凭证），则渲染该配置
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      # 调用模板获取要使用的ServiceAccount名称
      serviceAccountName: {{ include "nginx.serviceAccountName" . }}
      # 如果配置了Pod级别的安全上下文，渲染对应配置
      {{- with .Values.podSecurityContext }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      containers:
        - name: {{ .Chart.Name }} # 容器名称使用Chart的名称
          # 容器级别的安全上下文，有配置则渲染
          {{- with .Values.securityContext }}
          securityContext:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          # 镜像地址：仓库地址:镜像标签；如果没配置image.tag就默认使用Chart.yaml里的appVersion
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          # 镜像拉取策略（Always/IfNotPresent/Never），从values读取配置
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.service.port }} # 容器暴露端口，取自values
              protocol: TCP
          # 如果配置了存活探针，则渲染探针配置，用于检测容器是否正常运行
          {{- with .Values.livenessProbe }}
          livenessProbe:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          # 如果配置了就绪探针，用于检测容器是否可以接收流量
          {{- with .Values.readinessProbe }}
          readinessProbe:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          # 容器资源限制、请求配额（CPU、内存），有配置则渲染
          {{- with .Values.resources }}
          resources:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          # 容器内数据挂载配置，有配置则渲染挂载信息
          {{- with .Values.volumeMounts }}
          volumeMounts:
            {{- toYaml . | nindent 12 }}
          {{- end }}
      # 全局存储卷配置，对应上面容器的volumeMounts挂载
      {{- with .Values.volumes }}
      volumes:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      # 节点选择器，指定Pod只能调度到带对应标签的节点上
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      # 亲和性调度策略（节点亲和、Pod亲和/反亲和）
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      # 容忍度，允许Pod调度到带有污点的节点
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}

核心模板函数精简说明
{{- }}：去除首尾多余空格换行，避免 YAML 空行语法错误
include "模板名" .：调用_helpers.tpl中预定义的公共模板，.传递全局上下文
nindent N：将输出内容整体缩进 N 个空格，适配 YAML 层级格式
{{- with 变量 }}：变量非空时才渲染内部代码块，为空则直接忽略这段配置
toYaml：把 values 中字典、数组格式的数据转换成标准 YAML 文本
default(A,B)：B 为空时使用 A 作为默认值
| 管道符：对模板输出结果做格式化处理（缩进、截取、替换等）


```







常用命令

```bash
#### 2. 安装部署（创建 Release）

语法：`helm install [Release名称] [Chart名] -n [命名空间]`
# 示例：在 default 命名空间部署 nginx，Release 名为 my-nginx
helm install my-nginx bitnami/nginx -n default
# 常用附加参数
# --create-namespace   命名空间不存在则自动创建
# --version 15.3.0     指定 Chart 版本
# -f values.yaml       加载自定义配置文件

#### 3. 查看 Release 状态
# 列出当前命名空间所有 Release
helm list
# 查看指定命名空间
helm list -n kube-system
helm list -n demo
# 查看运行详情与资源
helm status nginx -n demo
# 查看渲染后的完整 YAML
helm get manifest nginx -n demo

 4. 升级配置 / 版本
 # 临时升级副本数
helm upgrade nginx bitnami/nginx --set replicaCount=3 -n default
# 基于配置文件升级（生产推荐）
helm upgrade my-nginx bitnami/nginx -f values.yaml -n default

5. 版本回滚
# 查看发布历史版本
helm history nginx -n demo
# 回滚到第 2 个版本
helm rollback nginx 2 -n demo

6. 卸载 Release
helm uninstall nginx -n demo
----------------------------------------------------------------------------
#会删除当前 demo 命名空间下，该 Release（nginx）通过 Helm 创建的所有 K8s 资源：
Deployment
Service
ServiceAccount
HPA（如果开启）
Ingress（如果开启）
对应 Release 的 helm 部署记录（helm history 不再能查到该发布记录）
模板里自定义创建的 ConfigMap、Secret、PV/PVC 等所有由本次 helm install 生成的资源
注意：不会删除命名空间 demo 本身。

等价手动逐条删除命令
# 1. 删除deployment
kubectl delete deployment nginx -n demo
# 2. 删除service
kubectl delete service nginx -n demo
# 3. 删除serviceaccount
kubectl delete serviceaccount nginx -n demo
# 4. 删除hpa（如有）
kubectl delete hpa nginx -n demo
# 5. 删除ingress（如有）
kubectl delete ingress nginx -n demo

补充原理
Helm 会给所有资源打上统一标签：app.kubernetes.io/instance=nginx，卸载时本质是根据标签批量删除所有带该 Release 标签的资源，等价：
kubectl delete all,ingress,sa,hpa -l app.kubernetes.io/instance=nginx -n demo
--------------------------------------------------------------------------------------
```





### 五、自定义配置（适配国内环境核心操作）

默认 Chart 多为海外配置，需修改镜像地址、运行参数，两种常用方式：

#### 方式 1：--set 临时参数（少量修改）

```
# 示例：部署 nginx，指定国内镜像、修改副本数
helm install my-nginx bitnami/nginx \
  --set replicaCount=2 \
  --set image.registry=docker.m.daocloud.io \
  --set image.repository=bitnami/nginx \
  -n default
```

#### 方式 2：values.yaml 配置文件（生产推荐）

1. 导出默认配置模板

```
helm show values bitnami/nginx > values.yaml
```

1. 编辑 `values.yaml`，修改镜像、端口、资源限制、副本数等参数
2. 基于配置文件部署

```
helm install my-nginx bitnami/nginx -f values.yaml -n default

```

------

### 六、实操案例：Helm 部署 metrics-server（国内可用版）

对应你之前手动部署的场景，一键解决镜像与参数问题：

```
helm install metrics-server bitnami/metrics-server \
  -n kube-system \
  --set image.registry=docker.m.daocloud.io \
  --set image.repository=bitnami/metrics-server \
  --set image.tag=0.7.2 \
  --set extraArgs.kubelet-insecure-tls=true \
  --set extraArgs.kubelet-preferred-address-types=InternalIP
```

------

### 七、注意事项

1. Release 是**命名空间级资源**，不同命名空间下同名 Release 相互独立。
2. Chart 版本 ≠ 应用版本：前者是包的版本，后者是镜像内软件的版本。
3. 生产环境推荐用 `values.yaml` 管理配置，便于版本化留存，避免大量 `--set` 零散参数。
4. `helm uninstall` 默认删除该 Release 关联的所有 K8s 资源，PVC 是否保留取决于 Chart 配置。



## harbor

Harbor 是 CNCF 毕业的企业级私有容器镜像仓库，基于 Docker Registry 二次开发，提供镜像存储、权限管理、安全扫描、镜像复制、Helm Chart 管理等企业级能力，用来搭建内网私有镜像仓库。

### 二、核心五大功能

1. RBAC 权限控制

   按项目隔离资源，分配管理员、开发、访客角色；区分公有 / 私有项目，支持 LDAP 统一认证。

2. 镜像安全防护

   内置 Trivy 漏洞扫描，可拦截高危漏洞镜像；支持 Notary 镜像签名防篡改，全链路操作审计日志。

3. 跨仓库镜像复制

   支持推拉两种同步策略，多机房、多集群镜像异地同步，就近拉取、灾备。

4. 可视化 Web 管理

   中文 UI 界面，镜像、Chart、用户、项目可视化管理，降低运维成本。

5. OCI 制品兼容

   不仅存储容器镜像，还可存放 Helm Chart，统一管理云原生各类制品。

### 三、六大核心组件

1. **Proxy(Nginx)**：统一反向代理入口，SSL 证书解密、请求转发。
2. **Registry**：原生镜像存储，处理 docker push/pull，保存镜像分层数据。
3. **Core**：核心服务（UI、权限 Token、WebHook），做权限校验、业务逻辑处理。
4. **PostgreSQL**：元数据数据库，存储账号、项目、权限、扫描、日志信息。
5. **Job Service**：异步任务，负责镜像同步、漏洞扫描等后台任务。
6. **Log Collector**：集中收集所有组件日志，用于排查与安全审计。

### 四、Docker Registry 和 Harbor 区别 🎯

1. Docker Registry：官方轻量镜像仓库，仅实现镜像推拉存储，无权限、UI、安全、同步能力，适合测试环境。
2. Harbor：企业级增强版，补齐权限、安全、可视化、同步、Chart 管理，适合生产环境。

| 功能                | Docker Registry（原生轻量仓库） | Harbor（企业级仓库） |
| ------------------- | ------------------------------- | -------------------- |
| Web 可视化界面      | ❌ 无                            | ✅ 支持               |
| RBAC 权限、用户管理 | ❌ 需自己开发                    | ✅ 内置               |
| 镜像漏洞扫描        | ❌ 不支持                        | ✅ Trivy 自动扫描     |
| 跨机房镜像复制      | ❌ 不支持                        | ✅ 内置复制策略       |
| 审计日志、LDAP 集成 | ❌ 无                            | ✅ 支持               |
| Helm Chart 管理     | ❌ 不支持                        | ✅ OCI 制品仓库       |

### 五、Harbor 部署 & 使用流程

1. Helm 方式下载 Harbor Chart，配置域名、存储、密码、镜像加速器部署；
2. 客户端配置域名解析 / 证书，`docker login` 登录私有仓库；
3. 镜像打仓库标签 `docker tag`，push 推送到 Harbor 项目；
4. K8s 创建 ImagePullSecret，集群从 Harbor 拉取镜像部署业务。

### 六、高频问题简答

1. 为什么要用 Harbor 不用 Docker Hub？

   内网环境无法访问外网、需要权限管控、镜像安全扫描、内网拉取速度快、数据不泄露。

2. 镜像复制两种模式？

- 推模式：当前仓库主动推镜像到远端仓库；
- 拉模式：远端仓库主动拉取当前仓库镜像。

1. 漏洞扫描组件是什么？

   Trivy，可手动 / 自动扫描，支持配置策略禁止高危镜像部署。





## [课程小结](https://docs.chengkanghua.top/k8s-2023/4Kubernetes进阶实践?id=课程小结)

1. 学习k8s在etcd中数据的存储，掌握etcd的基本操作命令
2. 理解k8s调度的过程，预选及优先。影响调度策略的设置

3. Flannel网络的原理学习，了解网络的流向，帮助定位问题

4. 认证与授权，掌握kubectl、kubelet、rbac及二次开发如何调度API

5. 利用HPA进行业务动态扩缩容，通过metrics-server了解整个k8s的监控体系

6. PV + PVC

7. Helm



# k8s日志收集架构

## K8s 日志收集三大主流架构（面试必背精简版）🎯

| 架构 | 做法 | 优点 | 缺点 | 适用 |
| --- | --- | --- | --- | --- |
| **① DaemonSet（节点级）** | 每节点跑一个采集器，读 `/var/log/containers/` 标准输出 | 开销小、不侵入业务、新节点自动跟随 | 只能采标准输出，采不到容器内日志文件 | **企业最常用** |
| **② Sidecar（边车）** | Pod 内加一个采集容器，通过 `emptyDir` 共享卷读日志 | 能采容器内日志文件、可按业务定制规则 | 每 Pod 多一个容器，Pod 多时开销大 | 需要采集文件日志的业务 |
| **③ 应用内直推（集中式）** | 代码集成 SDK，直接发 Kafka / ES | 链路最短，不用部署采集组件 | **强侵入业务代码**，换存储要改代码 | 极少用于 K8s |

> 🎯 前提知识：**K8s 容器日志默认输出到 stdout/stderr**，由容器运行时落到宿主机 `/var/log/containers/*.log`（json 格式）—— 这正是 DaemonSet 方案能成立的基础。

## 一、架构 1：Node 宿主机部署方式（DaemonSet）【企业最常用】

### 架构流程

1. 每个节点用 **DaemonSet** 部署一个日志采集器（Filebeat / Fluentd）
2. 采集器读取节点 `/var/log/containers/` 下容器标准输出日志（容器日志默认输出到宿主机 json 日志文件）
3. 过滤、格式化日志 → 发送到中间件（Kafka）
4. 消费端：Logstash 做日志清洗转换 → 存入 Elasticsearch
5. Kibana 可视化检索、展示日志

### 优点

1. 每个节点只部署 1 个采集组件，资源开销小；
2. 只采集宿主机容器日志，不用侵入业务 Pod，无需修改业务代码；
3. 扩展性强，新增节点自动部署采集器。

### 缺点

只能采集容器标准输出日志，无法直接采集容器内日志文件（需要挂载宿主机目录）。

## 二、架构 2：Sidecar 边车模式

### 架构流程

1. 业务 Pod 内同时运行两个容器：业务容器 + 日志采集 Sidecar 容器（Filebeat）
2. 业务容器把日志输出到**emptyDir 临时共享卷**
3. Sidecar 读取共享卷里的日志文件，发送到 Elasticsearch/Kafka

### 优点

1. 精准采集当前业务 Pod 内部日志文件；
2. 不同业务可单独配置日志采集规则，隔离性强。

### 缺点

每个业务 Pod 都跑一个采集容器，资源开销大，集群 Pod 多的时候性能损耗严重。

## 三、架构 3：集中式日志采集（应用内直接推送）

 架构流程

业务代码内部直接集成 SDK，日志不输出控制台，直接通过网络发送到 Kafka/ES。

优点：采集链路最短，不需要部署采集组件。

缺点：强侵入业务代码，业务和日志系统耦合，更换存储需要改代码，极少用在 K8s。

### 企业主流标准架构：EFK + Kafka 🎯

**链路**：Filebeat（DaemonSet）→ Kafka → Logstash → Elasticsearch ← Kibana

1. Filebeat：轻量采集，不占用节点资源，防止日志丢失；
2. Kafka：削峰填谷，应对日志瞬间爆发，解耦采集与消费；
3. Logstash：日志过滤、格式化、字段清洗；
4. ES：日志存储、全文检索；
5. Kibana：可视化查询、报表、告警。

### 补充关键知识点

1. K8s 容器日志默认是 **stdout/stderr 标准输出**，由容器运行时（containerd/CRI-O）输出到宿主机`/var/log/containers/*.log` json 格式文件；
2. 禁止把日志挂载到宿主机固定目录，避免多 Pod 日志冲突，推荐 emptyDir+Sidecar；
3. Filebeat 部署为 DaemonSet 保证每个节点唯一采集实例。



## [ConfigMap的配置文件挂载使用场景](http://49.7.203.222:2023/#/logging/using-configmap?id=configmap的配置文件挂载使用场景)

### 前置准备：统一创建测试 ConfigMap

先创建包含 2 个配置文件的 ConfigMap，后续三个场景共用



```yaml
# nginx-cm.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-cm
data:
  # nginx 站点配置文件
  default.conf: |
    server {
        listen 80;
        server_name localhost;
        location / {
            root /usr/share/nginx/html;
            index index.html;
        }
    }
  # 自定义首页文件
  index.html: |
    <h1>Hello ConfigMap Nginx</h1>
    <p>this file from configmap</p>
```



```
# 执行创建
kubectl apply -f nginx-cm.yaml
```

------





### 场景一：全量挂载到目录（所有文件整体挂载）

### 特点

ConfigMap 中**所有 key 都会以独立文件形式**挂载到目标目录；

如果目标目录原本有文件，会被**全部覆盖**；支持 ConfigMap 热更新。

### Deployment 完整示例



```yaml
# deploy-cm-1.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-cm-full
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-cm-full
  template:
    metadata:
      labels:
        app: nginx-cm-full
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        volumeMounts:
        - name: cm-volume
          mountPath: /etc/nginx/conf.d  # 挂载到nginx配置目录，原目录内容会被覆盖
      volumes:
      - name: cm-volume
        configMap:
          name: nginx-cm  # 绑定上面创建的ConfigMap
```



```
# 部署 + 验证
kubectl apply -f deploy-cm-1.yaml
kubectl exec -it deploy/nginx-cm-full -- ls /etc/nginx/conf.d
# 输出：default.conf  index.html  两个文件全部挂载进去
```

------

### 场景二：筛选多文件挂载（items 指定部分文件）

### 特点

通过 `items` 只挂载 ConfigMap 中**指定的部分 key**，其余文件不挂载；

目标目录原有内容会被覆盖；支持热更新。

### Deployment 完整示例



```yaml
# deploy-cm-2.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-cm-items
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-cm-items
  template:
    metadata:
      labels:
        app: nginx-cm-items
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        volumeMounts:
        - name: cm-volume
          mountPath: /etc/nginx/conf.d
      volumes:
      - name: cm-volume
        configMap:
          name: nginx-cm
          items:          # 只选择需要挂载的文件
          - key: default.conf
            path: default.conf  # 挂载后的文件名
          # index.html 不会被挂载进去
```



```
# 部署 + 验证
kubectl apply -f deploy-cm-2.yaml
kubectl exec -it deploy/nginx-cm-items -- ls /etc/nginx/conf.d
# 输出：default.conf  只有指定文件
```

------

### 场景三：subPath 单文件挂载（子路径挂载）

### 特点

只挂载**单个指定文件**到目标路径，**不会清空目标目录原有文件**；

**核心缺点**：subPath 挂载的文件，ConfigMap 更新后容器内不会自动热更新。

### Deployment 完整示例

只替换 nginx 默认首页，不影响 html 目录下其他原生文件



```yaml
# deploy-cm-3.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-cm-subpath
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-cm-subpath
  template:
    metadata:
      labels:
        app: nginx-cm-subpath
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        volumeMounts:
        - name: cm-volume
          mountPath: /usr/share/nginx/html/index.html  # 精确到单个文件路径
          subPath: index.html                          # 对应ConfigMap中的key
      volumes:
      - name: cm-volume
        configMap:
          name: nginx-cm
```



```
# 部署 + 验证
kubectl apply -f deploy-cm-3.yaml
kubectl exec -it deploy/nginx-cm-subpath -- ls /usr/share/nginx/html
# 输出：50x.html  index.html  原有文件保留，只替换了index.html
```

------

### 三种场景核心区别总结



| 挂载方式           | 挂载范围          | 是否覆盖目录原有文件 | 支持 ConfigMap 热更新 | 适用场景                             |
| :----------------- | :---------------- | :------------------- | :-------------------- | :----------------------------------- |
| 全量目录挂载       | 所有 key 全部挂载 | 是                   | 支持                  | 配置目录完全由 CM 统一管理           |
| items 筛选挂载     | 只挂载指定 key    | 是                   | 支持                  | CM 文件多，当前业务只用其中几个      |
| subPath 子路径挂载 | 仅单个文件        | 否（只替换目标文件） | 不支持                | 不能清空业务目录，只替换单个配置文件 |







# [基于Kubernetes的DevOps平台实践](https://docs.chengkanghua.top/k8s-2023/7基于Kubernetes的DevOps平台实践?id=_7基于kubernetes的devops平台实践)



## DevOps CI CD 介绍

### 一、DevOps 是什么

#### 1. 定义

DevOps 是**开发（Development）+ 运维（Operations）\**的组合，不是某一款工具，而是一套\**理念、流程、文化 + 工具链**。

目标：打破开发、测试、运维部门壁垒，让软件从**代码提交 → 构建 → 测试 → 部署 → 运维**全流程自动化、高频稳定发布。

#### 解决的痛点

- 开发写完代码丢给运维，环境不一致、上线频繁出事故；
- 每次上线需要人工操作，效率低、容易误操作；
- 迭代慢、上线周期长、回滚麻烦、故障排查权责不清。

#### DevOps 三大核心目标

1. **持续交付**：任何时刻都能快速、安全发布版本；
2. **自动化**：构建、测试、部署、监控尽量少人工干预；
3. **快速反馈**：代码提交就能自动跑测试、出报告，尽早发现 BUG。

#### 2. DevOps 经典工作流程

1. 产品需求 → 开发拉分支写代码
2. 代码提交 Git 仓库 → 触发 CI 流水线
3. 自动：代码检查→单元测试→打包→构建镜像→推私有仓库
4. 自动部署到测试环境，自动化测试验证
5. 测试通过后，手动 / 自动发布预发、生产环境
6. 上线后监控告警、日志排查，快速迭代优化

### 二、CI 持续集成（Continuous Integration）

#### 1. 含义

**持续集成：开发者频繁（每天多次）把本地代码合并到代码主干仓库，每次提交都自动执行构建 + 测试。**

#### 核心目的

- 尽早发现代码冲突、语法错误、单元测试 BUG；
- 避免多人长期各自开发，最后合并时出现大量冲突；
- 保证主干代码永远处于可构建、可测试的稳定状态。

#### CI 典型流程（每次 git push 触发）

1. 拉取最新代码
2. 代码静态检查（SonarQube）：漏洞、规范、坏味道
3. 单元测试、覆盖率统计
4. Maven/Gradle/NPM 项目打包（jar/war/ 前端 dist 包）
5. 构建 Docker 镜像，推送到 Harbor 私有镜像仓库
6. 生成制品版本归档

#### CI 常用工具

Git、GitLab/GitHub/Gitee、Jenkins、GitLab CI、SonarQube、Maven、Gradle、Docker、Harbor

1. gitlab，代码仓库，企业内部使用最多的代码版本管理工具。
2. Jenkins， 一个可扩展的持续集成引擎，用于自动化各种任务，包括构建、测试和部署软件。
3. robotFramework， 基于Python的自动化测试框架
4. sonarqube，代码质量管理平台
5. maven，java包构建管理工具
6. Kubernetes
7. Docker



### 三、CD 两种含义（面试高频必区分）🎯

#### 1. CD1：持续交付 Continuous Delivery

- 代码经过 CI 流水线后，**自动打包、镜像上传到仓库**，可以随时一键部署到任意环境（测试、预发、生产）；
- 生产环境发布需要**人工确认触发**，不会自动上线；
- 企业最常用模式，兼顾效率与线上安全。

#### 2. CD2：持续部署 Continuous Deployment

- 在持续交付基础上，**测试环境验证通过后自动部署到生产环境，无需人工审批**；
- 适合小团队、互联网敏捷业务、灰度发布成熟场景；
- 传统政企、金融很少直接用持续部署，风险太高。

#### CD 核心流程

1. 从 Harbor 拉取指定版本镜像
2. 通过 K8s API/helm 部署到目标命名空间
3. 等待 Pod 就绪、健康检查通过
4. 发送上线通知（钉钉 / 企业微信）
5. 支持一键版本回滚

### 四、标准 DevOps CI/CD 完整流水线（企业主流）

```
开发提交代码(Git)
     ↓
【CI阶段】
1. 拉取代码
2. Sonar代码质量扫描
3. 单元测试、统计覆盖率
4. Maven打包Jar
5. Docker构建镜像
6. 镜像推送到Harbor私有仓库
     ↓
【CD阶段-持续交付】
7. 手动触发部署测试环境 → K8s Deployment/Helm部署
8. 自动化接口测试、压力测试验证
9. 测试通过后，手动审批发布预发、生产环境
10. 上线后监控、日志采集，异常可快速回滚
```

### 五、主流 CI/CD 工具链两套方案

#### 方案 1：Jenkins 经典方案（传统企业、运维常用）

Git + gitlab+ Jenkins + SonarQube + Maven + Docker + Harbor + K8s

- 优势：插件极丰富、高度自定义、适配各种老旧项目、灵活可控
- 缺点：需要运维维护 Jenkins 服务，配置复杂

#### 方案 2：GitLab CI 云原生原生方案（云原生大厂主流）

GitLab 内置 CI，通过项目根目录 `.gitlab-ci.yml` 声明式配置流水线

- 优势：无需单独部署 Jenkins，轻量、K8s 分布式 Runner 弹性扩容
- 缺点：复杂定制化不如 Jenkins 灵活

### 六、CI/CD 核心价值总结

1. **CI**：保证代码质量，频繁合并、自动构建测试，避免集成灾难，产出稳定制品（镜像 / Jar 包）；
2. **持续交付 CD**：制品随时可一键部署，上线可控、风险低；
3. **持续部署 CD**：全流程自动上线，极致迭代速度；
4. DevOps 通过 CI/CD 落地，实现：**开发自测、自动校验、运维标准化部署、版本可追溯可回滚**。

### 七、面试精简一句话背诵 🎯

DevOps 是打通开发运维的流程文化，CI 持续集成实现代码频繁合并、自动构建测试打包产出制品；CD 分为持续交付（人工确认上线）和持续部署（自动上线），依托 Jenkins/GitLabCI+Docker+Harbor+K8s 实现自动化发布，提升迭代效率、降低上线故障。



## [K8S中安装配置Jenkins](https://docs.chengkanghua.top/k8s-2023/7基于Kubernetes的DevOps平台实践?id=k8s中安装配置jenkins)



注意点：

1. 第一次启动很慢
2. 因为后面Jenkins会与kubernetes集群进行集成，会需要调用kubernetes集群的api，因此安装的时候创建了ServiceAccount并赋予了cluster-admin的权限
3. 初始化容器来设置权限
4. ingress来外部访问
5. 数据存储通过pvc挂载到宿主机中

```bash
mkdir -p ~/jenkins;cd ~/jenkins
cat <<EOF > nfs-pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-pv   # PV名称，集群内唯一
spec:
  capacity: 
    storage: 20Gi   # PV总容量
  accessModes:
  - ReadWriteOnce     # 单节点读写，
  persistentVolumeReclaimPolicy: Retain  # 回收策略：保留数据
  storageClassName: nfs             # 存储类名，PVC必须和该值一致
  nfs:					   # 底层存储类型为NFS
    server: 10.0.0.80      # NFS服务器地址              
    path: /data/k8s        # NFS上的共享目录（需提前手动创建）    
EOF
kubectl create -f nfs-pv.yaml
    
cat <<\EOF > jenkins-all.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: jenkins
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: jenkins
  namespace: jenkins
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: nfs
  resources:
    requests:
      storage: 20Gi
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins
  namespace: jenkins
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: jenkins-crb
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: jenkins
  namespace: jenkins
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins-master
  namespace: jenkins
spec:
  replicas: 1
  selector:
    matchLabels:
      devops: jenkins-master
  template:
    metadata:
      labels:
        devops: jenkins-master
    spec:
      serviceAccount: jenkins #Pod 需要使用的服务账号
      initContainers:
      - name: fix-permissions
        image: busybox
        command: ["sh", "-c", "chown -R 1000:1000 /var/jenkins_home"]
        securityContext:
          privileged: true
        volumeMounts:
        - name: jenkinshome
          mountPath: /var/jenkins_home
      containers:
      - name: jenkins
        image: jenkins/jenkins:2.516.3-jdk17
        imagePullPolicy: IfNotPresent
        ports:
        - name: http #Jenkins Master Web 服务端口
          containerPort: 8080
        - name: slavelistener #Jenkins Master 供未来 Slave 连接的端口
          containerPort: 50000
        volumeMounts:
        - name: jenkinshome
          mountPath: /var/jenkins_home
        env:
        - name: JAVA_OPTS
          value: "-Xms512m -Xmx1024m -XX:MetaspaceSize=256M -XX:MaxMetaspaceSize=512M -Duser.timezone=Asia/Shanghai -Dhudson.model.DirectoryBrowserSupport.CSP="
      volumes:
      - name: jenkinshome
        persistentVolumeClaim:
          claimName: jenkins
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins
  namespace: jenkins
spec:
  ports:
  - name: http
    port: 8080
    targetPort: 8080
  - name: slavelistener
    port: 50000
    targetPort: 50000
  type: ClusterIP
  selector:
    devops: jenkins-master
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: jenkins-web
  namespace: jenkins
spec:
  ingressClassName: nginx #注意这个不能少,否则不会加载到ingrss-nginx-controller容器配置里
  rules:
  - host: jenkins.luffy.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service: 
            name: jenkins
            port:
              number: 8080
EOF


# 实验环境 java虚拟机内存给小点， jenkins总是崩溃 增加-XX:PermSize=256M 参数
 value: "-Xms512m -Xmx1024m -XX:PermSize=256M -Duser.timezone=Asia/Shanghai -Dhudson.model.DirectoryBrowserSupport.CSP="
注意：这里的几个 JVM 参数含义如下：
-Xms: 使用的最小堆内存大小
-Xmx: 使用的最大堆内存大小
-XX：内存的永久保存区域大小
这几个参数也不是配置越大越好，具体要根据所在机器实际内存和使用大小配置。
 -XX:PermSize=256M 官方的最新版不认识这个参数.

JDK17改成这个
-Xms512m -Xmx1024m -XX:MetaspaceSize=256M -XX:MaxMetaspaceSize=512M -Duser.timezone=Asia/Shanghai -Dhudson.model.DirectoryBrowserSupport.CSP=

 
 # 这里jenkins 镜像随着时间推移,版本可能需要更新版本
 https://docker.aityp.com/  #国内镜像版本查看




## 部署服务

kubectl create -f jenkins-all.yaml
## 查看服务
kubectl -n jenkins get po
NAME                              READY   STATUS    RESTARTS   AGE
jenkins-master-767df9b574-lgdr5   1/1     Running   0          20s

# 查看日志，第一次启动提示需要完成初始化设置
$ kubectl -n jenkins logs -f jenkins-master-767df9b574-lgdr5


错误记录:
kubectl edit deploy ingress-nginx-controller -n ingress-nginx
修改成 dnsPolicy: ClusterFirstWithHostNet
# 开启宿主机网络（hostNetwork:true）时，依然强制使用 K8s 集群的 CoreDNS 做域名解析，既能占用宿主机端口，又能正常解析集群内部 Service 域名。


# win11上的hosts配置ip是 ingress-nginx-controller的宿主机ip地址
# kubectl get pod -n ingress-nginx -o wide
# C:\Windows\System32\drivers\etc\hosts
10.0.0.81 jenkins.luffy.com


# 查看jenkins初始化的密码
kubectl -n jenkins exec  -ti jenkins-master-b884fb8d-vpgn8 cat /var/jenkins_home/secrets/initialAdminPassword

浏览器访问 jenkins.luffy.com
Jenkins -> manage Jenkins -> Plugin Manager -> Avaliable，搜索 chinese关键字
安装的插件
GitLab Plugin
Pipeline: Multibranch
Blue Ocean
Localization: Chinese (Simplified)

# 修改国内下载插件源
kubectl -n jenkins exec  -ti jenkins-master-b884fb8d-vpgn8 -- bash
cd /var/jenkins_home/updates
sed -i 's/http:\/\/updates.jenkins-ci.org\/download/https:\/\/mirrors.tuna.tsinghua.edu.cn\/jenkins/g' default.json 
sed -i 's/http:\/\/www.google.com/https:\/\/www.baidu.com/g' default.json

```



kubectl 查看所有namespace 的所有资源

```bash
kubectl get all --all-namespaces
# 简写
kubectl get all -A
# 包含资源：Pod、Service、Deployment、ReplicaSet、StatefulSet、DaemonSet、Job、CronJob
# get all 是简写聚合，不包含：ConfigMap、Secret、PV、PVC、Ingress、ServiceAccount、Role、ClusterRole、CRD 等资源。

kubectl get cm -A
kubectl get secret -A

kubectl get pv
kubectl get pvc -A
kubectl get storageclasses

kubectl get ingress -A
kubectl get sa -A
kubectl get role,clusterrole,rolebinding,clusterrolebinding -A

# 批量查看常用核心资源
kubectl get all,cm,secret,pvc,ingress,sa -A


# 把占用资源的deploy 停掉
kubectl -n luffy get hpa
kubectl -n luffy delete hpa hpa-eladmin-web

## 该命名空间下所有Deployment缩容到0
kubectl scale deployment --all --replicas=0 -n luffy

```



## 安装gitlab

```bash

cat <<\EOF >gitlab-secret.txt
postgres.user.root=root
postgres.pwd.root=cm9vdA==
EOF

kubectl -n jenkins create secret generic gitlab-secret --from-env-file=gitlab-secret.txt


cat <<\EOF > postgres.yaml
apiVersion: v1
kind: Service
metadata:
  name: postgres
  labels:
    app: postgres
  namespace: jenkins
spec:
  ports:
  - name: server
    port: 5432
    targetPort: 5432
    protocol: TCP
  selector:
    app: postgres
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: postgredb
  namespace: jenkins
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: nfs
  resources:
    requests:
      storage: 20Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: jenkins
  name: postgres
  labels:
    app: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      tolerations:
      - operator: "Exists"
      containers:
      - name: postgres
        image: postgres:11.4
        imagePullPolicy: "IfNotPresent"
        ports:
        - containerPort: 5432
        env:
        - name: POSTGRES_USER           #PostgreSQL 用户名
          valueFrom:
            secretKeyRef:
              name: gitlab-secret
              key: postgres.user.root
        - name: POSTGRES_PASSWORD       #PostgreSQL 密码
          valueFrom:
            secretKeyRef:
              name: gitlab-secret
              key: postgres.pwd.root
        resources:
          limits:
            cpu: 1000m
            memory: 2048Mi
          requests:
            cpu: 50m
            memory: 100Mi
        volumeMounts:
        - mountPath: /var/lib/postgresql/data
          name: postgredb
      volumes:
      - name: postgredb
        persistentVolumeClaim:
          claimName: postgredb
EOF
# 实验环境资源调整
        resources:
          limits:
            cpu: 200m
            memory: 256Mi
          requests:
            cpu: 50m
            memory: 100Mi

#创建postgres
kubectl create -f postgres.yaml
   
# 创建数据库gitlab,为后面部署gitlab组件使用
# kubectl -n jenkins exec -ti postgres-7ff9b49f4c-nt8zh -- bash
root@postgres-7ff9b49f4c-nt8zh:/# psql
root=# create database gitlab;
root-# \q
root@postgres-5d96874894-ktg2r:/# exit

cat <<\EOF >redis.yaml
apiVersion: v1
kind: Service
metadata:
  name: redis
  labels:
    app: redis
  namespace: jenkins
spec:
  ports:
  - name: server
    port: 6379
    targetPort: 6379
    protocol: TCP
  selector:
    app: redis
---
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: jenkins
  name: redis
  labels:
    app: redis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      tolerations:
      - operator: "Exists"
      containers:
      - name: redis
        image: sameersbn/redis:4.0.9-2
        imagePullPolicy: "IfNotPresent"
        ports:
        - containerPort: 6379
        resources:
          limits:
            cpu: 200m
            memory: 256Mi
          requests:
            cpu: 50m
            memory: 50Mi
EOF
# 实验环境资源调整
        resources:
          limits:
            cpu: 200m
            memory: 256Mi
          requests:
            cpu: 50m
            memory: 50Mi
            
# 创建
kubectl create -f redis.yaml



cat <<\EOF > gitlab.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: gitlab
  namespace: jenkins
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "50m"
spec:
  ingressClassName: nginx
  rules:
  - host: gitlab.luffy.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: gitlab
            port:
              number: 80
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: gitlab
  namespace: jenkins
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: nfs
  resources:
    requests:
      storage: 20Gi
---
apiVersion: v1
kind: Service
metadata:
  name: gitlab
  labels:
    app: gitlab
  namespace: jenkins
spec:
  ports:
  - name: server
    port: 80
    targetPort: 80
    protocol: TCP
  selector:
    app: gitlab
---
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: jenkins
  name: gitlab
  labels:
    app: gitlab
spec:
  replicas: 1
  selector:
    matchLabels:
      app: gitlab
  template:
    metadata:
      labels:
        app: gitlab
    spec:
      nodeName: k8s-slave2  #指定部署到的节点
      tolerations:
      - operator: "Exists"
      containers:
      - name: gitlab
        image:  sameersbn/gitlab:13.2.2
        imagePullPolicy: "IfNotPresent"
        env:
        - name: GITLAB_HOST
          value: "gitlab.luffy.com"
        - name: GITLAB_PORT
          value: "80"
        - name: GITLAB_SECRETS_DB_KEY_BASE
          value: "long-and-random-alpha-numeric-string"
        - name: GITLAB_SECRETS_SECRET_KEY_BASE
          value: "long-and-random-alpha-numeric-string"
        - name: GITLAB_SECRETS_OTP_KEY_BASE
          value: "long-and-random-alpha-numeric-string"
        - name: DB_HOST
          value: "postgres"
        - name: DB_NAME
          value: "gitlab"
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: gitlab-secret
              key: postgres.user.root
        - name: DB_PASS
          valueFrom:
            secretKeyRef:
              name: gitlab-secret
              key: postgres.pwd.root
        - name: REDIS_HOST
          value: "redis"
        - name: REDIS_PORT
          value: "6379"
        ports:
        - containerPort: 80
        resources:
          limits:
            cpu: 8000m
            memory: 2048Mi
          requests:
            cpu: 1000m
            memory: 1024Mi
        volumeMounts:
        - mountPath: /home/git/data
          name: data
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: gitlab
EOF

## 为节点打标签   在master上执行就可以
$ kubectl label node k8s-slave1 component=gitlab
# 创建
kubectl create -f gitlab.yaml

# C:\Winodws\system32\drivers\etc\hosts
10.0.0.81 gitlab.luffy.com


访问[http://gitlab.luffy.com，设置管理员密码] root Admin@123.com
```



- eladmin-api项目推送到gitlab*

```bash

# 配置k8s-master节点的hosts
echo "10.0.0.81 gitlab.luffy.com" >>/etc/hosts

---------------- 把本地代码推送到gitlab
登录gitlab  root  Admin@123.com
创建一个group  name: eladmin  -->  组内创建一个项目 eladmin-api


# git clone https://gitee.com/chengkanghua/eladmin.git


git config --global user.name "Administrator"
git config --global user.email "admin@example.com"

# Push an existing Git repository
cd eladmin
git remote rename origin old-origin
git remote add origin http://gitlab.luffy.com/eladmin/eladmin-api.git
git push -u origin --all  #根据提示输入账号密码 root  Admin@123.com
# git push -u origin --tags

# git remote -v #查看远程仓库地址

#gitlab 默认的 auto DevOps    关闭 Default to Auto DevOps pipeline 勾选去掉
# http://gitlab.luffy.com/eladmin/eladmin-api/-/settings/ci_cd





```



*钉钉推送*

```bash

配置机器人

试验发送消息

#钉钉群 设置 --》 智能群助手 -》机器人管理---》 自定义
https://oapi.dingtalk.com/robot/send?access_token=740b792c8b2a02d4ead9826263b562c36e8e30d9d15bc5b9de1712fa7d469744

配置当前网络的公网 网段为白名单


$ curl 'https://oapi.dingtalk.com/robot/send?access_token=740b792c8b2a02d4ead9826263b562c36e8e30d9d15bc5b9de1712fa7d469744' \
   -H 'Content-Type: application/json' \
   -d '{"msgtype": "text", 
        "text": {
             "content": "我就是我, 是不一样的烟火"
        }
      }'
      


```





## Jenkins 4 种常用项目类型

### 1. 自由风格项目（Freestyle）

**适合：新手、简单小任务**

- 可视化点点点配置，不用写代码
- 拉代码、打包、部署都在页面上配置
- 缺点：配置不能版本管理、不好复用、换环境要重新配

### 2. 流水线项目（Pipeline）

**适合：正式项目、复杂 CI/CD 流程（最常用）**

- 用`Jenkinsfile`写流程（放到 Git 仓库里）
- 构建、测试、打包、部署步骤代码化
- 优点：可版本回滚、可复用、多环境方便迁移

### 细分两种流水线：

1. **流水线（Pipeline）**：单仓库单分支项目用
2. 多分支流水线（Multibranch Pipeline）
   - 自动扫描 Git 所有分支，每个分支自动生成一条流水线任务
   - 适合多分支开发（dev/test/prod）、自动触发各分支构建

### 3. 文件夹（Folder）

不算构建任务，用来归类管理大量任务，分组存放，方便查找权限管控。

### 4. Maven 项目（Maven Project）

**适合 Java Maven 项目**

- 封装了 Maven 常用命令，不用自己写 shell 执行 mvn
- 内置 Maven 工具配置，比自由风格简化 Java 打包配置

### 极简总结

1. 新手简单任务 → **自由风格**
2. 标准 CI/CD、流程要托管 → **流水线 Pipeline**
3. 多分支开发 → **多分支流水线**
4. Java Maven 项目快速打包 → **Maven 项目**





## 演示一个自由风格项目

```bash
jeknis插件安装gitlab plugin
插件中心搜索并安装gitlab，直接安装即可

-------------------------------------------------
全局 GitLab 连接（URL+API Token）：Jenkins 能正常识别你的 GitLab 仓库、分支，构建完把结果同步到 GitLab 页面。
任务内 Secret Token + 开启 /project 接口认证：GitLab 代码提交后，通过 Webhook 带这个密钥调用 Jenkins，安全触发自动构建。
---------------------------------------------------

http://jenkins.luffy.com/manage/configure  # 配置全局 Gitlab api
系统管理->系统配置->Gitlab，其中的API Token，需要从下个步骤中获取

✔ Enable authentication for '/project' end-point
Connection name : gitlab
GitLab host URL: http://gitlab.luffy.com/
Credentials: 添加
	Jenkins凭据提供者：Jenkins
	Domain: 全局凭据(unrestricted)
	类型: GitLab API token  [选择]
	范围?: 全局(Jenkins,nodes,items,all child items,etc)
	API token:        登录gitlab获取 
	ID?: gitlab-api-token [填写]


登录gitlab，选择user->Settings->access tokens新建一个访问token
http://gitlab.luffy.com/profile/personal_access_tokens
名称: jenkins [填写]
到期时间: 默认不选
范围:勾选前4个就可以  api read_user  read_api read_repository

点击 创建个人访问令牌  复制回到jenkins 

点击test connection
注意: 这里test conntection 不成功,是要做host解析, 按下一步操作

配置host解析
由于我们的Jenkins和gitlab域名是本地解析，因此需要让gitlab和Jenkins服务可以解析到对方的域名。两种方式：
- 在容器内配置hosts
- 配置coredns的静态解析 | 推荐这种方式
# kubectl -n kube-system edit cm coredns
        ready #下面增加内容。定位
        hosts {
            10.0.0.81 jenkins.luffy.com  gitlab.luffy.com
            fallthrough
        }

# 重启coredns
kubectl -n kube-system scale deployment coredns --replicas=0
kubectl -n kube-system scale deployment coredns --replicas=1 

登录jenkins 网页jenkins.luffy.com 
# 创建自由风格项目 name : free-demo
源码管理-->选择Git，填项项目地址:http://gitlab.luffy.com/eladmin/eladmin-api.git
Credentials 认证-->添加 ，使用用户名密码方式 username + password，配置gitlab的用户和密码
用户名: root  
密码: Admin@123.com
ID : gitlab-user


勾选 Build when a change is pushed to GitLab #复制url
	高级 展开
		Secret token :     复制
		generate 点击生成一个 
		保存
# 复制 jenkins项目地址  对应的 Secret token 
# 登录gitlab  项目--> 设置 添加一个webhook
http://gitlab.luffy.com/eladmin/eladmin-api/hooks
    URL： http://jenkins.luffy.com/project/free-demo
    Secret Token 填入在Jenkins端生成的token
    Trigger: 勾选 Push events | Merge request events| ssl 取消勾选
    Add webhook

场景 1：普通前后端项目（最常用推荐）
✅ Push events + Merge request events
其余全部不选；SSL 校验取消勾选
场景 2：需要标签发布部署（生产版本打包）
✅ Push events + Merge request events + Tag push events
其余不选，关闭 SSL 校验

test push events，报错：Requests to the local network are not allowed
解决: 设置gitlab允许向本地网络发送webhook请求
参考地址 http://gitlab.luffy.com/admin/application_settings/network
访问 Admin Aera -> Settings -> Network ，
	展开Outbound requests -->
		打勾 Allow requests to the local network from web hooks and services  保存


# 配置free项目-> 增加构建步骤-> 执行shell，将发送钉钉消息的shell保存
curl 'https://oapi.dingtalk.com/robot/send?access_token=740b792c8b2a02d4ead9826263b562c36e8e30d9d15bc5b9de1712fa7d469744' \
   -H 'Content-Type: application/json' \
   -d '{"msgtype": "text","text": {"content": "我就是我, 是不一样的烟火"}}'
   
# 提交代码到gitlab仓库，查看构建是否自动执行
git clone http://gitlab.luffy.com/eladmin/eladmin-api.git
cd eladmin
touch test.log
git add .
git commit -m "touch test"
git push -u origin master

```



## Master-Slave模式

 核心作用

**Master（主节点）负责调度、管理、页面操作；Slave（从节点）真正跑构建任务**，把打包、编译、部署这些耗 CPU / 内存的活分给多台机器执行，避免单台 Jenkins 服务器压力过大卡死。



```bash
系统管理 -> 节点管理 -> 新建节点 
http://jenkins.luffy.com/manage/computer/

名字: 10.0.0.81， 选择固定节点，保存
执行器数量: 3
远程工作目录: /opt/jenkins_jobs
标签: 为任务选择节点的依据，如 10.0.0.81
启动方式:选择通过java web启动代理，代理是运行jar包，通过JNLP（是一种允许客户端启动托管在远程Web服务器上的应用程序的协议 ）启动连接到master节点服务中
保持之后根据提示 到节点上操作

Run from agent command line: (Unix) 
curl -sO http://jenkins.luffy.com/jnlpJars/agent.jar
java -jar agent.jar -url http://jenkins.luffy.com/ -secret 1e8940ceb13b6c6cae10b127a2fe21c723dce86d4f40bcdb228d9bca9d268b01 -name "10.0.0.81" -webSocket -workDir "/opt/jenkins_jobs"


Or run from agent command line, with the secret stored in a file: (Unix) 
echo 1e8940ceb13b6c6cae10b127a2fe21c723dce86d4f40bcdb228d9bca9d268b01 > secret-file
curl -sO http://jenkins.luffy.com/jnlpJars/agent.jar
java -jar agent.jar -url http://jenkins.luffy.com/ -secret @secret-file -name "10.0.0.81" -webSocket -workDir "/opt/jenkins_jobs"




# jenkins服务器装的是jdk17, 所有slave服务器也要安装相同版本
# openjdk 17 版本下载地址
#https://www.openlogic.com/openjdk-downloads?page=4
#https://developers.redhat.com/products/openjdk/download   #需要登录,user:chengkanghua

wget https://builds.openlogic.com/downloadJDK/openlogic-openjdk/17.0.12+7/openlogic-openjdk-17.0.12+7-linux-x64-el.rpm
yum localinstall openlogic-openjdk-17.0.12+7-linux-x64-el.rpm

echo '10.0.0.81 jenkins.luffy.com gitlab.luffy.com' >> /etc/hosts


curl -sO http://jenkins.luffy.com/jnlpJars/agent.jar
java -jar agent.jar -url http://jenkins.luffy.com/ -secret 1e8940ceb13b6c6cae10b127a2fe21c723dce86d4f40bcdb228d9bca9d268b01 -name "10.0.0.81" -webSocket -workDir "/opt/jenkins_jobs"


# 提示 INFO: Connected , 页面上查看连接状态

# 注意 需要安装git,  
yum install -y git



测试使用新节点执行任务
配置free-demo项目
限制项目的运行节点 ，标签表达式选择10.0.0.81
立即构建
查看构建日志




```

## Jenkins定制化容器

```bash
# 获取当前Jenkins的所有插件列表
# admin:123456@localhost 需要替换成Jenkins的用户名、密码及访问地址
#先配置好 etc/hosts ;  jennkins容器ip  jenkins.luffy.com
echo '10.0.0.81 jenkins.luffy.com' >> /etc/hosts

curl -sSL  "http://admin:admin@jenkins.luffy.com/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" | perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1:\2\n/g'|sed 's/ /:/' > plugins.txt

wget https://gitee.com/chengkanghua/script/raw/master/k8s/jenkins-plugin-cli.sh
 
 
cat <<\EOF >Dockerfile
FROM jenkins/jenkins:2.544-jdk17
LABEL maintainer="inspur_lyx@hotmail.com"
USER root


## 用最新的插件列表文件替换默认插件文件
COPY plugins.txt /usr/share/jenkins/ref/
COPY jenkins-plugin-cli.sh /usr/local/bin/
## 执行插件安装
RUN chmod +x /usr/local/bin/jenkins-plugin-cli.sh && /usr/local/bin/jenkins-plugin-cli.sh -f /usr/share/jenkins/ref/plugins.txt
EOF

## 执行构建，定制jenkins容器
docker build . -t 10.0.0.80:5000/jenkins:v20241025 -f Dockerfile
docker push 10.0.0.80:5000/jenkins:v20241025


启动定制化镜像
## 删掉当前服务
$ kubectl delete -f jenkins-all.yaml
## 删掉已挂载的数据
$ rm -rf /var/jenkins_home
## 替换使用定制化镜像
$ sed -i 's#jenkinsci/blueocean#10.0.0.80:5000/jenkins:v20200404#g' jenkins-all.yaml
## 重新创建服务
$ kubectl create -f jenkins-all.yaml


```



自由风格项目弊端：

- 任务的完成需要在Jenkins端维护大量的配置
- 没法做版本控制
- 可读性、可移植性很差，不够优雅



## [流水线语法](https://docs.chengkanghua.top/k8s-2023/7基于Kubernetes的DevOps平台实践?id=流水线语法)



为什么叫做流水线，和工厂产品的生产线类似，pipeline是从源码到发布到线上环境。关于流水线，需要知道的几个点：

- 重要的功能插件，帮助Jenkins定义了一套工作流框架；
- Pipeline 的实现方式是一套 Groovy DSL（ 领域专用语言 ），所有的发布流程都可以表述为一段 Groovy 脚本；
- 将WebUI上需要定义的任务，以脚本代码的方式表述出来；
- 帮助jenkins实现持续集成CI（Continue Integration）和持续部署CD（Continue Deliver）的重要手段；



[官方文档](https://jenkins.io/zh/doc/book/pipeline/syntax/)

两种语法类型：

- **脚本式语法（Scripted）**
  - 基于 Groovy 脚本，写法灵活自由，没有固定结构
  - 可以直接写循环、判断、自定义函数，适合复杂定制化场景
  - 上手门槛高，无语法强校验，出错难排查
- **声明式语法（Declarative）【推荐、主流】**
  - 结构固定、语法严格、易读易维护，企业标准写法
  - 固定以 `pipeline { ... }` 开头
  - 自带错误校验，新手不容易写错，BlueOcean 可视化编辑器默认生成这种语法

*为与BlueOcean脚本编辑器兼容，通常建议使用Declarative Pipeline的方式进行编写,从jenkins社区的动向来看，很明显这种语法结构也会是未来的趋势。*

 补充关键点

1. 自由风格、Maven 项目**不能使用 Jenkinsfile**，只有普通 Pipeline、多分支 Pipeline 项目支持；

2. Jenkinsfile 一般存放于 Git 代码仓库根目录，跟着项目代码做版本管理；

3. 本质：Pipeline 是一套 Jenkins 定义的 DSL 领域专用语言，底层基于 Groovy 实现。

   

```bash
pipeline { 
    agent {label '10.0.0.81'}
    environment { 
        PROJECT = 'eladmin-api'
    }
    stages {
        stage('Checkout') { 
            steps { 
                checkout scm 
            }
        }
        stage('Build') { 
            steps { 
                sh 'make' 
            }
        }
        stage('Test'){
            steps {
                sh 'make check'
                junit 'reports/**/*.xml' 
            }
        }
        stage('Deploy') {
            steps {
                sh 'make publish'
            }
        }
    }
    post {
        success { 
            echo 'Congratulations!'
        }
        failure { 
            echo 'Oh no!'
        }
        always { 
            echo 'I will always say Hello again!'
        }
    }
}

------------------------------------------------
脚本解释：
checkout步骤为检出代码; scm是一个特殊变量，指示checkout步骤克隆触发此Pipeline运行的特定修订
agent：指明使用哪个agent节点来执行任务，定义于pipeline顶层或者stage内部
any，可以使用任意可用的agent来执行
label，在提供了标签的 Jenkins 环境中可用的代理上执行流水线或阶段。 例如: agent { label 'my-defined-label' }，最常见的使用方式

none，当在 pipeline 块的顶部没有全局代理， 该参数将会被分配到整个流水线的运行中并且每个 stage 部分都需要包含他自己的 agent 部分。比如: agent none

docker， 使用给定的容器执行流水线或阶段。 在指定的节点中，通过运行容器来执行任务
agent {
    docker {
        image 'maven:3-alpine'
        label 'my-defined-label'
        args  '-v /tmp:/tmp'
    }
}
options: 允许从流水线内部配置特定于流水线的选项。
buildDiscarder , 为最近的流水线运行的特定数量保存组件和控制台输出。
例如: options { buildDiscarder(logRotator(numToKeepStr: '10')) }

disableConcurrentBuilds ,不允许同时执行流水线。 可被用来防止同时访问共享资源等。 
例如: options { disableConcurrentBuilds() }

timeout ,设置流水线运行的超时时间, 在此之后，Jenkins将中止流水线。
例如: options { timeout(time: 1, unit: 'HOURS') }

retry，在失败时, 重新尝试整个流水线的指定次数。 For example: options { retry(3) }
environment: 指令制定一个 键-值对序列，该序列将被定义为所有步骤的环境变量

stages: 包含一系列一个或多个 stage指令, stages 部分是流水线描述的大部分"work" 的位置。 建议 stages 至少包含一个 stage 指令用于连续交付过程的每个离散部分,比如构建, 测试, 和部署。
pipeline {
    agent any
    stages { 
        stage('Example') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
steps: 在给定的 stage 指令中执行的定义了一系列的一个或多个steps。

post: 定义一个或多个steps ，这些阶段根据流水线或阶段的完成情况而运行post 支持以下 post-condition 块中的其中之一: always, changed, failure, success, unstable, 和 aborted。

always, 无论流水线或阶段的完成状态如何，都允许在 post 部分运行该步骤
changed, 当前流水线或阶段的完成状态与它之前的运行不同时，才允许在 post 部分运行该步骤
failure, 当前流水线或阶段的完成状态为"failure"，才允许在 post 部分运行该步骤, 通常web UI是红色
success, 当前流水线或阶段的完成状态为"success"，才允许在 post 部分运行该步骤, 通常web UI是蓝色或绿色
unstable, 当前流水线或阶段的完成状态为"unstable"，才允许在 post 部分运行该步骤, 通常由于测试失败,代码违规等造成。通常web UI是黄色
aborted， 只有当前流水线或阶段的完成状态为"aborted"，才允许在 post 部分运行该步骤, 通常由于流水线被手动的aborted。通常web UI是灰色



```

创建pipeline示意：

新建任务 -> 流水线 任务名字: eladmin-api-pipeline

```go
jenkins/pipelines/p1.yaml

pipeline {
   agent {label '172.16.1.228'}
   environment { 
      PROJECT = 'eladmin-api'
   }
   stages {
      stage('printenv') {
         steps {
            echo 'Hello World'
            sh 'printenv'
         }
      }
      stage('check') {
         steps {
            checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: '543cae0a-2f0c-4b12-bd0c-0ea4b6596726', url: 'http://gitlab.luffy.com/eladmin/eladmin-api.git']])
         }
      }
      stage('build-image') {
         steps {
            sh 'docker build . -t 172.16.1.226/eladmin/eladmin-api:latest -f Dockerfile'
         }
      }
      stage('send-msg') {
         steps {
            sh """
            curl 'https://oapi.dingtalk.com/robot/send?access_token=740b792c8b2a02d4ead9826263b562c36e8e30d9d15bc5b9de1712fa7d469744' \
   -H 'Content-Type: application/json' \
   -d '{"msgtype": "text", 
        "text": {
             "content": "我就是我, 是不一样的烟火"
        }
      }'
      """
         }
      }
   }
}


 # stage('check') 点击流水线语法,里选择chenckout: Check out from version control , 里填写,生成对用的脚本

 #在代码里添加Dockerfile文件
git clone http://gitlab.luffy.com/eladmin/eladmin-api.git
cd eladmin-api

cat > Dockerfile.multi <<EOF
FROM aerialist7/maven-git as builder
WORKDIR /opt/eladmin
COPY  . .
RUN mvn clean package

FROM java:8u111
WORKDIR /opt/eladmin
COPY --from=builder /opt/eladmin/eladmin-system/target/eladmin-system-2.6.jar .
CMD [ "sh", "-c", "java -Dspring.profiles.active=prod -jar eladmin-system-2.6.jar" ]
EOF

git add .
git commit -m "add Dockerfile.multi"
git push -u origin master

 
 
 -------------- 实际修改的版本
 pipeline {
   agent {label '10.0.0.81'}
   environment { 
      PROJECT = 'eladmin-api'
   }
   stages {
      stage('printenv') {
         steps {
            echo 'Hello World'
            sh 'printenv'
         }
      }
      stage('check') {
         steps {
            checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'gitlab-user', url: 'http://gitlab.luffy.com/eladmin/eladmin-api.git']])
         }
      }
      stage('build-image') {
         steps {
            sh 'docker build . -t 10.0.0.80:5000/eladmin/eladmin-api:latest -f Dockerfile.multi'
         }
      }

   }
   post {
        success { 
            echo 'Congratulations!'
        }
        failure { 
            echo 'Oh no!'
        }
        always { 
            echo 'I will always say Hello again!'
        }
    }
   
}


点击“立即构建”，同样的，我们可以配置触发器，使用webhook的方式接收项目的push事件，

构建触发器选择 Build when a change is pushed to GitLab. #复制url地址,
生成 Secret token #复制token
配置gitlab，创建webhook，(粘贴到创建webhook页面, ) , 发送test push events测试
```



## Blue Ocean

1. **定位**：Jenkins 现代化可视化 UI 插件，专为 Pipeline 流水线设计，用来替代老旧经典界面。
2. 核心优势
   - 流水线阶段图形化展示，红绿蓝三色直观看每个步骤成败，排错快；
   - 支持拖拽式编辑器，可可视化生成 Jenkinsfile；
   - 分阶段独立日志，多分支、MR 构建状态集中展示，界面简洁好上手。
3. 局限
   - 只能查看、新建流水线，**不能做系统配置、插件、节点、权限管理**，复杂配置仍要切回经典页面；
   - 官方已停止功能迭代，仅安全维护，替代方案：`Pipeline Graph View`、`Pipeline Stage View`插件，保留可视化核心能力，持续更新维护
4. **适用场景**：开发日常查看构建、排查流水线报错；新手快速入门写流水线。



## Jenkinsflie实战

Jenkins Pipeline 提供了一套可扩展的工具，用于将“简单到复杂”的交付流程实现为“持续交付即代码”。Jenkins Pipeline 的定义通常被写入到一个文本文件（称为 `Jenkinsfile` ）中，该文件可以被放入项目的源代码控制库中。

### 演示1：使用Jenkinsfile管理**pipeline**

- 在项目中源代码 新建Jenkinsfile文件，拷贝已有script内容 #上面--实际修改的版本
- 配置pipeline任务，流水线 定义为 Pipeline Script from SCM (scoure code manage 源代码管理)
- 执行push 代码测试

```bash
#配置pipeline 流水线 定义为 Pipeline Script from SCM (scoure code manage 源代码管理)
regpossitory URL: http://gitlab.luffy.com/eladmin/eladmin-api.git
脚本路径 Jenkinsfile



 ~/eladmin (master) $ vi Jenkinsfile
粘贴 已有script内容 #上面--实际修改的版本

git add .
git commit -m 'add Jenkinsfile'
git push -u origin master
---------------------------------------------Jenkinsfile
pipeline {
   agent {label '10.0.0.81'}
   environment { 
      PROJECT = 'eladmin-api'
   }
   stages {
      stage('printenv') {
         steps {
            echo 'Hello World'
            sh 'printenv'
         }
      }
      stage('check') {
         steps {
            checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'gitlab-user', url: 'http://gitlab.luffy.com/eladmin/eladmin-api.git']])
         }
      }
      stage('build-image') {
         steps {
            sh 'docker build . -t 10.0.0.80:5000/eladmin/eladmin-api:latest -f Dockerfile.multi'
         }
      }

   }
   post {
        success { 
            echo 'Congratulations!'
        }
        failure { 
            echo 'Oh no!'
        }
        always { 
            echo 'I will always say Hello again!'
        }
    }
   
}


```

### [演示2：优化及丰富流水线内容]

- 优化代码检出阶段

  由于目前已经配置了使用git仓库地址，且使用SCM来检测项目，因此代码检出阶段完全没有必要再去指定一次

- 构建镜像的tag使用git的commit id

- 增加post阶段的消息通知，丰富通知内容, 钉钉工作群设置里-->机器人,-->设置 开启 webhook, 安全设置外网ip地址段;

- 编译和构建拆分不同的stage，增加构建速度

```bash

 pipeline {
   agent {label '10.0.0.81'}
   environment { 
      PROJECT = 'eladmin-api'
   }
   stages {
      stage('printenv') {
         steps {
            echo 'Hello World'
            sh 'printenv'
         }
      }
      stage('check') {
         steps {
             checkout scm
         }
      }
      stage('mvn package') {
          steps {
            sh 'mvn clean package'
          }
        }
      stage('build-image') {
         steps {
            sh 'docker build . -t 10.0.0.80:5000/eladmin/eladmin-api:${GIT_COMMIT} -f Dockerfile'
         }
      }

   }
   post {
        success { 
            echo 'Congratulations!'
            sh """
                curl 'https://oapi.dingtalk.com/robot/send?access_token=740b792c8b2a02d4ead9826263b562c36e8e30d9d15bc5b9de1712fa7d469744' \
                    -H 'Content-Type: application/json' \
                    -d '{"msgtype": "text", 
                            "text": {
                                "content": "😄👍构建成功👍😄\n 关键字：luffy\n 项目名称: ${JOB_BASE_NAME}\n Commit Id: ${GIT_COMMIT}\n 构建地址：${RUN_DISPLAY_URL}"
                        }
                }'
            """
        }
        failure {
            echo 'Oh no!'
            sh """
                curl 'https://oapi.dingtalk.com/robot/send?access_token=740b792c8b2a02d4ead9826263b562c36e8e30d9d15bc5b9de1712fa7d469744' \
                    -H 'Content-Type: application/json' \
                    -d '{"msgtype": "text", 
                            "text": {
                                "content": "😖❌构建失败❌😖\n 关键字：luffy\n 项目名称: ${JOB_BASE_NAME}\n Commit Id: ${GIT_COMMIT}\n 构建地址：${RUN_DISPLAY_URL}"
                        }
                }'
            """
        }
        always { 
            echo 'I will always say Hello again!'
        }
    }
   
}

# 重新修改 vi Jenkinsfile


需要在10.0.0.81 节点安装maven环境
官网下载地址 https://maven.apache.org/download.cgi
国内华为镜像地址:https://mirrors.huaweicloud.com/apache/maven/maven-3/3.6.3/binaries/


wget https://mirrors.huaweicloud.com/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
# 解压
tar zxf apache-maven-3.6.3-bin.tar.gz

# 修改mvn配置，配置maven源和本地仓库路径
cat <<\EOF > apache-maven-3.6.3/conf/settings.xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <localRepository>/opt/maven-repo</localRepository>
  <proxies>
  </proxies>

  <servers>
  </servers>

  <mirrors>
    <mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <mirrorOf>central</mirrorOf>
    </mirror>
  </mirrors>

</settings>
EOF

# 拷贝目录,并软连接
cp -r apache-maven-3.6.3 /usr/lib/
ln -s /usr/lib/apache-maven-3.6.3/bin/mvn /usr/bin/mvn
# 验证
mvn -v

# 修改Dockerfile.multi 为Dockerfile

mv Dockerfile.multi Dockerfile
cat <<\EOF > Dockerfile
FROM java:8u111
WORKDIR /opt/eladmin
COPY eladmin-system/target/ .
CMD [ "sh", "-c", "java -Dspring.profiles.active=prod -jar eladmin-system-2.6.jar" ]
EOF

git add .
git commit -am 'modify Jenkinsfile and Dockerfile'
git push -u origin master 


```



### [演示3：使用k8s部署服务]

- 在源代码新建mainfests目录，将k8s所需的文件放到mainfests目录中
- 将镜像地址改成模板，在pipeline中使用新构建的镜像进行替换
- 执行kubectl apply -f mainfests应用更改，需要配置kubectl认证

```bash

/eladmin-api (master) $ mkdir mainifests;cd mainifests
/eladmin-api (master)$ vim  eladmin-api.dpl.yaml
cat <<\EOF >eladmin-api.dpl.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: eladmin-api
  namespace: luffy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: eladmin-api
  template:
    metadata:
      labels:
        app: eladmin-api
    spec:
      imagePullSecrets:
      - name: registry-10-0-0-80
      containers:
      - name: eladmin-api
        image: {{IMAGE_URL}} #这里改成模板
        imagePullPolicy: IfNotPresent
        env:
        - name: DB_HOST
          valueFrom:
            configMapKeyRef:
              name: eladmin
              key: DB_HOST
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: eladmin-secret
              key: DB_USER
        - name: DB_PWD
          valueFrom:
            secretKeyRef:
              name: eladmin-secret
              key: DB_PWD
        - name: REDIS_HOST
          valueFrom:
            configMapKeyRef:
              name: eladmin
              key: REDIS_HOST
        - name: REDIS_PORT
          valueFrom:
            configMapKeyRef:
              name: eladmin
              key: REDIS_PORT
        ports:
        - containerPort: 8000
        resources:
          requests:
            memory: 200Mi
            cpu: 50m
          limits:
            memory: 1Gi
            cpu: 2
        livenessProbe:
          tcpSocket:
            port: 8000
          initialDelaySeconds: 20
          periodSeconds: 15
          timeoutSeconds: 3
        readinessProbe:
          httpGet:
            path: /auth/code
            port: 8000
            scheme: HTTP
          initialDelaySeconds: 20
          timeoutSeconds: 3
          periodSeconds: 15
EOF
# 有之前部署的yaml 文件就可以用之前的部署的yaml文件
# kubectl -n luffy get deployments.apps eladmin-api -oyaml>eladmin-api.dpl.yaml
# vi eladmin-api.dpl.yaml #删除不需要的信息.
cat <<EOF > deploy-eladmin-api.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: eladmin-api
  namespace: luffy
spec:
  replicas: 1    #指定Pod副本数
  selector:        #指定Pod的选择器
    matchLabels:
      app: eladmin-api
  template:
    metadata:
      labels:    #给Pod打label
        app: eladmin-api
    spec:
      imagePullSecrets:
      - name: registry-10-0-0-80
      containers:
      - name: eladmin-api
        image: 10.0.0.80:5000/eladmin/eladmin-api:v1
        imagePullPolicy: IfNotPresent
        env:
        - name: DB_HOST
          valueFrom:
            configMapKeyRef:
              name: eladmin
              key: DB_HOST
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: eladmin-secret
              key: DB_USER
        - name: DB_PWD
          valueFrom:
            secretKeyRef:
              name: eladmin-secret
              key: DB_PWD
        - name: REDIS_HOST
          valueFrom:
            configMapKeyRef:
              name: eladmin
              key: REDIS_HOST
        - name: REDIS_PORT
          valueFrom:
            configMapKeyRef:
              name: eladmin
              key: REDIS_PORT
        ports:
        - containerPort: 8000
        resources:
          requests:
            memory: 200Mi
            cpu: 50m
          limits:
            memory: 1Gi
            cpu: 2
        livenessProbe:
          tcpSocket:
            port: 8000
          initialDelaySeconds: 20  # 容器启动后第一次执行探测是需要等待多少秒
          periodSeconds: 15     # 执行探测的频率
          timeoutSeconds: 3        # 探测超时时间
        readinessProbe: 
          httpGet: 
            path: /auth/code
            port: 8000
            scheme: HTTP
          initialDelaySeconds: 20 
          timeoutSeconds: 3
          periodSeconds: 15
EOF


#将master上认证文件复制到jenkins-agent机器上
scp -r k8s-master:/root/.kube /root



# 调整Jenkinsfile # cd eladmin
cat <<EOF > Jenkinsfile
pipeline {
    agent { label '10.0.0.81'}

    environment {
        IMAGE_REPO = "10.0.0.80:5000/eladmin"
    }

    stages {
        stage('printenv') {
            steps {
              echo 'Hello World'
              sh 'printenv'
            }
        }
        stage('check') {
            steps {
                checkout scm
            }
        }
        stage('build-image') {
            steps {
                retry(2) { sh 'docker build . -t ${IMAGE_REPO}:${GIT_COMMIT}'}
            }
        }
        stage('push-image') {
            steps {
                retry(2) { sh 'docker push ${IMAGE_REPO}:${GIT_COMMIT}'}
            }
        }
        stage('deploy') {
            steps {
                sh "sed -i 's#{{IMAGE_URL}}#${IMAGE_REPO}:${GIT_COMMIT}#g' mainifests/*"
                timeout(time: 1, unit: 'MINUTES') {
                    sh "kubectl apply -f mainifests/"
                }
            }
        }
    }
    post {
        success { 
            echo 'Congratulations!'
            sh """
                curl 'https://oapi.dingtalk.com/robot/send?access_token=740b792c8b2a02d4ead9826263b562c36e8e30d9d15bc5b9de1712fa7d469744' \
                    -H 'Content-Type: application/json' \
                    -d '{"msgtype": "text", 
                            "text": {
                                "content": "😄👍构建成功👍😄\n 关键字：myblog\n 项目名称: ${JOB_BASE_NAME}\n Commit Id: ${GIT_COMMIT}\n 构建地址：${RUN_DISPLAY_URL}"
                        }
                }'
            """
        }
        failure {
            echo 'Oh no!'
            sh """
                curl 'https://oapi.dingtalk.com/robot/send?access_token=740b792c8b2a02d4ead9826263b562c36e8e30d9d15bc5b9de1712fa7d469744' \
                    -H 'Content-Type: application/json' \
                    -d '{"msgtype": "text", 
                            "text": {
                                "content": "😖❌构建失败❌😖\n 关键字：luffy\n 项目名称: ${JOB_BASE_NAME}\n Commit Id: ${GIT_COMMIT}\n 构建地址：${RUN_DISPLAY_URL}"
                        }
                }'
            """
        }
        always { 
            echo 'I will always say Hello again!'
        }
    }
}
EOF

git add . && git commit -m "modify"
git push -u origin master
```



### 演示4：使用凭据管理敏感信息

上述Jenkinsfile中存在的问题是敏感信息使用明文，暴漏在代码中，如何管理流水线中的敏感信息（包含账号密码），之前我们在对接gitlab的时候，需要账号密码，已经使用过凭据来管理这类敏感信息，同样的，我们可以使用凭据来存储钉钉的token信息，创建凭据:

[Dashboard] ==> [系统管理]==>[凭据]==> [系统] => [全局凭据 (unrestricted)](http://jenkins.luffy.com/manage/credentials/store/system/domain/_/)

new credentials :

- 类型: username with password
- 用户名: dingTalk #这里可以自定义
- 密码: 粘贴 钉钉的token
  - ID: dingTalk #唯一标识
  - 描述: dingTalk robot access token

如何在Jenkinsfile中获取已有凭据的内容？

Jenkins 的声明式流水线语法有一个 `credentials()` 辅助方法（在[`environment`](https://jenkins.io/zh/doc/book/pipeline/jenkinsfile/#../syntax#environment) 指令中使用），它支持 [secret 文本](https://jenkins.io/zh/doc/book/pipeline/jenkinsfile/##secret-text)，[带密码的用户名](https://jenkins.io/zh/doc/book/pipeline/jenkinsfile/##usernames-and-passwords)，以及 [secret 文件](https://jenkins.io/zh/doc/book/pipeline/jenkinsfile/##secret-files)凭据。

下面的流水线代码片段展示了如何创建一个使用带密码的用户名凭据的环境变量的流水线。

在该示例中，带密码的用户名凭据被分配了环境变量，用来使你的组织或团队以一个公用账户访问 Bitbucket 仓库；这些凭据已在 Jenkins 中配置了凭据 ID `jenkins-bitbucket-common-creds`。

当在 [`environment`](https://jenkins.io/zh/doc/book/pipeline/jenkinsfile/#../syntax#environment) 指令中设置凭据环境变量时：

```
environment {
    BITBUCKET_COMMON_CREDS = credentials('jenkins-bitbucket-common-creds')
}

```

这实际设置了下面的三个环境变量：

- `BITBUCKET_COMMON_CREDS` - 包含一个以冒号分隔的用户名和密码，格式为 `username:password`。
- `BITBUCKET_COMMON_CREDS_USR` - 附加的一个仅包含用户名部分的变量。
- `BITBUCKET_COMMON_CREDS_PSW` - 附加的一个仅包含密码部分的变量。

```bash
pipeline {
    agent {
        // 此处定义 agent 的细节
    }
    environment {
        //顶层流水线块中使用的 environment 指令将适用于流水线中的所有步骤。 
        BITBUCKET_COMMON_CREDS = credentials('jenkins-bitbucket-common-creds')
    }
    stages {
        stage('Example stage 1') {
             //在一个 stage 中定义的 environment 指令只会将给定的环境变量应用于 stage 中的步骤。
            environment {
                BITBUCKET_COMMON_CREDS = credentials('another-credential-id')
            }
            steps {
                // 
            }
        }
        stage('Example stage 2') {
            steps {
                // 
            }
        }
    }
}

```



因此对Jenkinsfile做改造：

```Groovy 

pipeline {
    agent { label '10.0.0.81'}

    environment {
        IMAGE_REPO = "10.0.0.80:5000/eladmin"
        DINGTALK_CREDS = credentials('dingTalk')
    }

    stages {
        stage('printenv') {
            steps {
            echo 'Hello World'
            sh 'printenv'
            }
        }
        stage('check') {
            steps {
                checkout scm
            }
        }
        stage('mvn clean package') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('build-image') {
            steps {
                retry(2) { sh 'docker build . -t ${IMAGE_REPO}:${GIT_COMMIT}'}
            }
        }
        stage('push-image') {
            steps {
                retry(2) { sh 'docker push ${IMAGE_REPO}:${GIT_COMMIT}'}
            }
        }
        stage('deploy') {
            steps {
                sh "sed -i 's#{{IMAGE_URL}}#${IMAGE_REPO}:${GIT_COMMIT}#g' mainifests/*"
                timeout(time: 1, unit: 'MINUTES') {
                    sh "kubectl apply -f mainifests/"
                }
            }
        }
    }
    post {
        success { 
            echo 'Congratulations!'
            sh """
                curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                    -H 'Content-Type: application/json' \
                    -d '{"msgtype": "text", 
                            "text": {
                                "content": "😄👍构建成功👍😄\n 关键字：luffy\n 项目名称: ${JOB_BASE_NAME}\n Commit Id: ${GIT_COMMIT}\n 构建地址：${RUN_DISPLAY_URL}"
                        }
                }'
            """
        }
        failure {
            echo 'Oh no!'
            sh """
                curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                    -H 'Content-Type: application/json' \
                    -d '{"msgtype": "text", 
                            "text": {
                                "content": "😖❌构建失败❌😖\n 关键字：luffy\n 项目名称: ${JOB_BASE_NAME}\n Commit Id: ${GIT_COMMIT}\n 构建地址：${RUN_DISPLAY_URL}"
                        }
                }'
            """
        }
        always { 
            echo 'I will always say Hello again!'
        }
    }
}

# ------操作, 查看jeknins构建过程
vi Jenkinsfile  

git commit -am "modify Jenkinsfile"

git push -u origin master

```

上面我们已经通过Jenkinsfile完成了最简单的项目的构建和部署，那么我们来思考目前的方式：

1. 目前都是在项目的单一分支下进行操作，企业内一般会使用feature、develop、release、master等多个分支来管理整个代码提交流程，如何根据不同的分支来做构建？
2. 构建视图中如何区分不同的分支?
3. 如何不配置webhook的方式实现构建？
4. 如何根据不同的分支选择发布到不同的环境(开发、测试、生产)？



## 多分支流水线实战

[官方示例](https://jenkins.io/zh/doc/tutorials/build-a-multibranch-pipeline-project/)

假如使用develop分支作为开发分支，master分支作为集成测试分支，看一下如何使用多分支流水线来管理。

### 演示1：多分支流水线的使用



```bash

# 提交develop分支：
git checkout -b develop        #基于本地分支创建新分支develop
git push --set-upstream origin develop  #推送新分支到远程仓库时, --set-upstream 简写 -u

```

1. 禁用pipeline项目 (项目配置-->右上角 禁用)

2. Jenkins端创建多分支流水线项目 #名称: eladmin-api-muitl-pipeline

   - 增加git分支源

     - 项目仓库 http://gitlab.luffy.com/eladmin/eladmin-api.git

     - 凭据 选择 root/****

     - add --> 发现标签

     - add--> 根据名称过滤(支持正则表达式): develop|master|.*

     - add-->高级克隆，add--> 设置浅克隆 1

     - 扫描 多分支流水线 触发器

       Periodically if not otherwise run 选择 1 minute

保存后，会自动检索项目中所有存在Jenkinsfile文件的分支和标签，若匹配我们设置的过滤正则表达式，则会添加到多分支的构建视图中。所有添加到视图中的分支和标签，会默认执行一次构建任务。



### 演示2：美化消息通知内容

- 添加构建阶段记录
- 使用markdown格式，添加构建分支消息



```groovy
# develop 分支
cat <<\EOF > Jenkinsfile
pipeline {
    agent { label '10.0.0.81'}

    environment {
        IMAGE_REPO = "10.0.0.80:5000/eladmin"
        DINGTALK_CREDS = credentials('dingTalk')
        TAB_STR = "\n                    \n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    }

    stages {
        stage('printenv') {
            steps {
                script{
                    sh "git log --oneline -n 1 > gitlog.file"
                    env.GIT_LOG = readFile("gitlog.file").trim()
                }
                sh 'printenv'
            }
        }
        stage('checkout') {
            steps {
                checkout scm
                script{
                    env.BUILD_TASKS = env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('mvn clean package') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('build-image') {
            steps {
                retry(2) { sh 'docker build . -t ${IMAGE_REPO}:${GIT_COMMIT}'}
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('push-image') {
            steps {
                retry(2) { sh 'docker push ${IMAGE_REPO}:${GIT_COMMIT}'}
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('deploy') {
            steps {
                sh "sed -i 's#{{IMAGE_URL}}#${IMAGE_REPO}:${GIT_COMMIT}#g' mainifests/*"
                timeout(time: 1, unit: 'MINUTES') {
                    sh "kubectl apply -f mainifests/"
                }
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
    }
    post {
        success { 
            echo 'Congratulations!'
            sh """
                curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                    -H 'Content-Type: application/json' \
                    -d '{
                        "msgtype": "markdown",
                        "markdown": {
                            "title":"myblog",
                            "text": "😄👍 构建成功 👍😄  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${GIT_BRANCH}   \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                        }
                    }'
            """ 
        }
        failure {
            echo 'Oh no!'
            sh """
                curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                    -H 'Content-Type: application/json' \
                    -d '{
                        "msgtype": "markdown",
                        "markdown": {
                            "title":"myblog",
                            "text": "😖❌ 构建失败 ❌😖  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${GIT_BRANCH}  \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                        }
                    }'
            """
        }
        always { 
            echo 'I will always say Hello again!'
        }
    }
}
EOF

git commit -am "muilt pipeline jenkinsfile"
git push -u origin develop

```



### 演示3：通知gitlab构建状态

Jenkins端做了构建，可以通过gitlab通过的api将构建状态通知过去，作为开发人员发起Merge Request或者合并Merge Request的依据之一。

*注意一定要指定gitLabConnection('gitlab')，不然没法认证到Gitlab端*

\#这里gitlab就是最开始在jeknis 系统设置里配置的 gitlab connections -->Connection name

```bash
   #配置说明 
   options {
        buildDiscarder(logRotator(numToKeepStr: '10'))  # 保留构建记录个数
        disableConcurrentBuilds()                 # 禁止并行构建
        timeout(time: 20, unit: 'MINUTES')      # Pipeline 的超时时间为 20 分钟,超过时间就失败 
        gitLabConnection('gitlab')             # 配置指定了与 GitLab 的连接
    }
    
    
 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success') #将构建状态信息发给gitlab

```



```groovy
cat <<\EOF > Jenkinsfile
pipeline {
    agent { label '10.0.0.81'}
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timeout(time: 20, unit: 'MINUTES')
        gitLabConnection('gitlab')
    }

    environment {
        IMAGE_REPO = "10.0.0.80:5000/eladmin"
        DINGTALK_CREDS = credentials('dingTalk')
        TAB_STR = "\n                    \n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    }

    stages {
        stage('printenv') {
            steps {
                script{
                    sh "git log --oneline -n 1 > gitlog.file"
                    env.GIT_LOG = readFile("gitlog.file").trim()
                }
                sh 'printenv'
            }
        }
        stage('checkout') {
            steps {
                checkout scm
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS = env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('mvn clean package') {
            steps {
                sh 'mvn clean package'
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('build-image') {
            steps {
                retry(2) { sh 'docker build . -t ${IMAGE_REPO}:${GIT_COMMIT}'}
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('push-image') {
            steps {
                retry(2) { sh 'docker push ${IMAGE_REPO}:${GIT_COMMIT}'}
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('deploy') {
            steps {
                sh "sed -i 's#{{IMAGE_URL}}#${IMAGE_REPO}:${GIT_COMMIT}#g' mainifests/*"
                timeout(time: 1, unit: 'MINUTES') {
                    sh "kubectl apply -f mainifests/"
                }
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
    }
    post {
        success { 
            echo 'Congratulations!'
            sh """
                curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                    -H 'Content-Type: application/json' \
                    -d '{
                        "msgtype": "markdown",
                        "markdown": {
                            "title":"myblog",
                            "text": "😄👍 构建成功 👍😄  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${BRANCH_NAME}   \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                        }
                    }'
            """ 
        }
        failure {
            echo 'Oh no!'
            sh """
                curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                    -H 'Content-Type: application/json' \
                    -d '{
                        "msgtype": "markdown",
                        "markdown": {
                            "title":"myblog",
                            "text": "😖❌ 构建失败 ❌😖  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${BRANCH_NAME}  \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                        }
                    }'
            """
        }
        always { 
            echo 'I will always say Hello again!'
        }
    }
}
EOF

git commit -am "update to gitlab for Jenkinsfile"
git push  #在develop 分支

```

我们可以访问gitlab，然后找到commit记录，查看同步状态

http://gitlab.luffy.com/eladmin/eladmin-api/-/pipelines/

提交merge request，也可以查看到相关的任务状态，可以作为项目owner合并代码的依据之一：



本章小结:

优势:

- 根据分支展示, 视图人性化
- 自动检测各分支的变更

思考：

- Jenkins的slave端，没有任务的时候处于闲置状态，slave节点多的话造成资源浪费
- 是否可以利用kubernetes的Pod来启动slave，动态slave pod来执行构建任务



## Jenkins与K8S集成

工具集成与Jenkinsfile实践篇

1. Jenkins如何对接kubernetes集群
2. 使用kubernetes的Pod-Template来作为动态的agent执行Jenkins任务
3. 如何制作agent容器实现不同类型的业务的集成
4. 集成代码扫描、docker镜像自动构建、k8s服务部署、自动化测试



[插件官方文档](https://plugins.jenkins.io/kubernetes/)

1. [系统管理] -> [插件管理] -> [搜索kubernetes]->直接安装

   若安装失败，请先更新[ bouncycastle API Plugin](https://plugins.jenkins.io/bouncycastle-api)并重新启动Jenkins

2. [系统管理] -> [节点管理] ->clouds --> [Add a new cloud]

3. 配置地址信息

   - Kubernetes 地址: [https://kubernetes.default](https://kubernetes.default/)
   - Kubernetes 命名空间：jenkins
   - 服务证书不用写（我们在安装Jenkins的时候已经指定过serviceAccount），均使用默认
   - 连接测试，成功会提示：Connection test successful
   - Kubernetes 命名空间: jenkins
   - Jenkins地址：[http://jenkins:8080](http://jenkins:8080/)
   - Jenkins 通道 ：jenkins:50000

4. 配置Pod Template #新版是在左边列表专门有一个pod templates 点[Add a pod template]

   - 名称: jnlp-slave
   - 命名空间：jenkins
   - 标签列表：jnlp-slave，作为agent的label选择用
   - 连接 Jenkins 的超时时间（秒） ：300，设置连接jenkins超时时间
   - 工作空间卷：选择hostpath，设置/opt/jenkins,注意需要设置目录权限，否则Pod没有权限



```bash
卷?
​ Host Path Volume
​	主机路径？:  /opt/jenkins
​	挂载路径？:  /home/jenkins/agent

# 打了标签的节点上操作
chown -R 1000:1000 /opt/jenkins
chmod 777 /opt/jenkins

节点选择器: jnlp-slave

工作空间卷: host path workspace volume --> 主机路径: /opt/jenkins



```



### 演示动态slave pod

```bash
# 为准备运行jnlp-slave-agent的pod的节点打上label
kubectl label node k8s-slave1 jnlp-slave=true
# kubectl label node k8s-slave2 jnlp-slave=true

### 回放一次多分支流水线develop分支 # 修改label
# 或者修改代码中的Jenkinsfile 提交代码
agent { label 'jnlp-slave'}
```

执行任务，会下载默认的jnlp-slave镜像，地址为jenkins/inbound-agent:4.11-1-jdk11，我们可以先在k8s-master节点拉取下来该镜像： #这里镜像版本要和jenkins的版本保持一致, 这里都是使用最新版

```bash
$ docker pull jenkins/inbound-agent:latest-jdk17

```

保存jenkinsfile提交后，会出现报错，因为我们的agent已经不再是宿主机，而是Pod中的容器内，报错如下：

mvn  not found

因此我们需要将用到的命令行工具集成到Pod的容器内，但是思考如下问题：

- 目前是用的jnlp的容器，是java的环境，我们在此基础上需要集成很多工具，能不能创建一个新的容器，让新容器来做具体的任务，jnlp-slave容器只用来负责连接jenkins-master
- 针对不同的构建环境（java、python、go、nodejs），可以制作不同的容器，来执行对应的任务



### [Pod-Template中容器镜像的制作]

为解决上述问题，我们制作一个tools镜像，集成常用的工具，来完成常见的构建任务，需要注意的几点：

- 使用alpine基础镜像，自身体积比较小
- 替换国内安装源
- 为了使用docker，安装了docker
- 为了克隆代码，安装git
- 为了后续做python的测试等任务，安装python环境
- 为了在容器中调用kubectl的命令，拷贝了kubectl的二进制文件
- 为了认证kubectl，需要在容器内部生成.kube目录及config文件



```bash
# slave1 机器操作 
mkdir tools;
# 拷贝maven
cp -r apache-maven-3.6.3 tools
cp `which kubectl` tools
cd tools

cat <<\EOF >Dockerfile
FROM alpine:3.13.4
LABEL maintainer="inspur_lyx@hotmail.com"
USER root

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
    apk update && \
    apk add  --no-cache openrc docker git curl tar gcc g++ make \
    bash shadow openjdk8 py-pip python3-dev  openssl-dev libffi-dev \
    libstdc++ harfbuzz nss freetype ttf-freefont && \
    mkdir -p /root/.kube && \
    usermod -a -G docker root

RUN rm -rf /var/cache/apk/* 
#-----------------安装 kubectl--------------------#
COPY kubectl /usr/local/bin/
RUN chmod +x /usr/local/bin/kubectl
# ------------------------------------------------#

#-----------------安装 maven--------------------#
COPY apache-maven-3.6.3 /usr/lib/apache-maven-3.6.3
RUN ln -s /usr/lib/apache-maven-3.6.3/bin/mvn /usr/local/bin/mvn && chmod +x /usr/local/bin/mvn
ENV MAVEN_HOME=/usr/lib/apache-maven-3.6.3
#------------------------------------------------#
EOF

#执行镜像构建并推送到仓库中：
docker build . -t 10.0.0.80:5000/devops/tools:v1
docker push 10.0.0.80:5000/devops/tools:v1

#我们可以直接使用该镜像做测试：

## 启动临时镜像做测试
$ docker run --rm -ti 10.0.0.80:5000/devops/tools:v1 bash
# / git clone http://xxxxxx.git
# / kubectl get no
# / python3
#/ docker

## 重新挂载docker的sock文件
docker run -v /var/run/docker.sock:/var/run/docker.sock --rm -ti 10.0.0.80:5000/devops/tools:v1 bash


```

### [实践通过Jenkinsfile实现demo项目自动发布到kubenetes环境]

更新Jenkins中的PodTemplate，添加tools镜像，注意同时要先添加名为jnlp的container，因为我们是使用自定义的PodTemplate覆盖掉默认的模板：

名称: jnlp

docker镜像: jenkins/inbound-agent:latest-jdk17 #版本和jenkins的jdk一致

运行的命令: 空

命令的参数: 空



**再添加第二个container Template**

名称: tools

Docker 镜像: 10.0.0.80:5000/devops/tools:v1

其他参数默认就可以

**添加拉取镜像的认证信息**

```bash
# kubectl -n luffy get secrets registry-10-0-0-80 -oyaml > registry-10-0-0-80.yaml
# vi registry-10-0-0-80.yaml #去掉不用的信息, namespace修改成jenkins
apiVersion: v1
data:
  .dockerconfigjson: eyJhdXRocyI6eyIxNzIuMTYuMS4yMjY6NTAwMCI6eyJ1c2VybmFtZSI6ImFkbWluIiwicGFzc3dvcmQiOiJhZG1pbiIsImVtYWlsIjoiY2hlbmdrYW5naHVhQGZveG1haWwuY29tIiwiYXV0aCI6IllXUnRhVzQ2WVdSdGFXND0ifX19
kind: Secret
metadata:
  creationTimestamp: "2024-10-27T08:21:21Z"
  name: registry-10-0-0-80
  namespace: jenkins
type: kubernetes.io/dockerconfigjson
# kubectl create -f registry-10-0-0-80.yaml
[root@k8s-master jenkins]# kubectl -n jenkins get secrets
NAME                    TYPE                             DATA   AGE
gitlab-secret           Opaque                           2      2d2h
registry-10-0-0-80      kubernetes.io/dockerconfigjson   1      13s


```

拉取镜像的Secret: image Pull secret : 填写registry-10-0-0-80

在卷栏目，添加三个卷，

- Host Path Volume: `/var/run/docker.sock`，不然在容器中使用docker会提示docker服务未启动
- Host Path Volume: `/opt/maven-repo`，本地maven仓库
- kubeconfig文件，用来认证kubectl，通过secret的方式进行挂载

```bash
kubectl -n jenkins create secret generic kubeconfig --from-file=/root/.kube/config

```

Secret Volume: kubeconfig

挂载路径: /root/.kube/

```bash
Dashboard>系统管理>Clouds>k8s-local>jnlp-slave
        ≡Host Path Volume主机路径?: /var/run/docker.sock
            挂载路径?: /var/run/docker.sock
            Read Only ?
            Host Path Volume
        ≡主机路径?: /opt/maven-repo
            挂载路径？: /opt/maven-repo
            Read Only ?
        =Secret Volume
            Secret名称?: kubeconfig
            挂载路径?: /root/.kube/Save
```

tools容器做好后，我们需要对Jenkinsfile做如下调整：

> 在jenkins添加一个全局凭证 用于 容器仓库登录 push
>
> 类型 username with password 用户名:admin 密码 admin ID: registry

```bash

cat <<\EOF > Jenkinsfile
pipeline {
    agent { label 'jnlp-slave'}
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timeout(time: 20, unit: 'MINUTES')
        gitLabConnection('gitlab')
    }

    environment {
        REGISTRY = "10.0.0.80:5000"
        IMAGE_REPO = "10.0.0.80:5000/eladmin"
        DINGTALK_CREDS = credentials('dingTalk')
        REGISTRY_CREDS = credentials('registry')
        TAB_STR = "\n                    \n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    }

    stages {
        stage('printenv') {
            steps {
                script{
                    sh "git log --oneline -n 1 > gitlog.file"
                    env.GIT_LOG = readFile("gitlog.file").trim()
                }
                sh 'printenv'
            }
        }
        stage('checkout') {
            steps {
                container('tools') {
                    checkout scm
                }
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS = env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('mvn clean package') {
            steps {
                container('tools') {
                    sh 'mvn clean package'
                }
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('build-image') {
            steps {
                container('tools') {
                    retry(2) { sh 'docker build . -t ${IMAGE_REPO}:${GIT_COMMIT}'}
                }
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('push-image') {
            steps {
                container('tools') {
                    retry(2) { 
                        sh """
                        docker logout ${REGISTRY};
                        docker login ${REGISTRY} -u ${REGISTRY_CREDS_USR} -p ${REGISTRY_CREDS_PSW}
                        docker push ${IMAGE_REPO}:${GIT_COMMIT}
                        """
                    }
                }
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('deploy') {
            steps {
                container('tools') {
                    sh "sed -i 's#{{IMAGE_URL}}#${IMAGE_REPO}:${GIT_COMMIT}#g' mainifests/*"
                    timeout(time: 1, unit: 'MINUTES') {
                        sh "kubectl apply -f mainifests/"
                    }
                }
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
    }
    post {
        success { 
           container('tools') {
              echo 'Congratulations!'
              sh """
                curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                    -H 'Content-Type: application/json' \
                    -d '{
                        "msgtype": "markdown",
                        "markdown": {
                            "title":"myblog",
                            "text": "😄👍 构建成功 👍😄  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${BRANCH_NAME}   \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                        }
                    }'
               """ 
           }
        }
        failure {
           container('tools') {
              echo 'Oh no!'
              sh """
                curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                    -H 'Content-Type: application/json' \
                    -d '{
                        "msgtype": "markdown",
                        "markdown": {
                            "title":"myblog",
                            "text": "😖❌ 构建失败 ❌😖  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${BRANCH_NAME}  \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                        }
                    }'
               """
           }
        }
        always { 
            echo 'I will always say Hello again!'
        }
    }
}
EOF

git commit -am "add tools container time"
git push 

```



## [jenkins集成Sonarqube]

### [集成sonarQube实现代码扫描]

sonarQube可以从以下七个维度检测代码质量，而作为开发人员至少需要处理前5种代码质量问题。

一、必须整改的 5 项

1. **代码规范**：集成多款规则工具，约束编码格式，统一团队代码书写标准。
2. **潜在缺陷**：提前发现隐藏逻辑漏洞、隐性 bug，规避线上故障。
3. **代码高复杂度**：复杂代码难读懂难修改，改动极易引发 bug，测试维护成本高。
4. **重复代码**：定位复制粘贴的冗余代码，避免多处同步修改出错。
5. **注释问题**：缺少注释不利于接手维护，冗余注释干扰代码阅读，两种情况都要优化。

 二、建议优化的 2 项

1. **单元测试不足**：统计测试覆盖率，覆盖率太低缺少代码变更的安全防护。
2. **架构设计问题**：检测依赖耦合、循环依赖、不合理第三方包引用等架构隐患。

补充核心能力

1. **安全漏洞**：扫描 SQL 注入、敏感信息硬编码等安全风险；
2. **技术债务**：量化劣质代码的整改工时，评估维护成本；
3. **质量门禁**：配置代码质量阈值，流水线不达标可阻断代码上线；
4. **多语言扫描**：支持前后端、Go、Python 等绝大多数开发语言。



### 5 条企业质量门禁

1. **新增阻塞、严重 Bug 数量必须为 0**

   本次提交代码不能出现致命、高危缺陷（比如空指针、数组越界、逻辑错误），这类问题一旦上线会直接造成服务崩溃、业务异常，必须清零。

2. **新增安全漏洞数量必须为 0**

   本次提交不能引入 SQL 注入、敏感信息明文写死、XSS 攻击等安全漏洞，防止系统被入侵、数据泄露。

3. **新增代码重复率 ≤ 3%**

   不能大量复制粘贴代码，重复代码改一处就要多处同步，极易出错，把新增代码重复片段控制在 3% 以内。

4. **新增代码单元测试覆盖率 ≥ 80%**

   本次新增的业务代码，至少 80% 都写了单元测试，后续改代码能自动校验，避免改动导致隐性 bug。

5. **所有新增安全热点必须全部审核**

   扫描出来的高危代码（如文件读写、数据库操作），必须人工确认没有安全风险，不能放任不管直接上线。



1. **Sonar 默认自带 Java 编码规则吗？**

SonarQube 内置官方 Java 规则集（Sonar way），已经预设好通用编码规范：命名格式、缩进、未关闭流、无效变量、语法陋习等，安装好就能直接扫描校验代码规范。

2. **规则可以自定义吗？**

可以高度自定义：

1. 可以在原有规则集里**启用 / 关闭某条规则**（比如放宽某些命名规范、关闭过于严苛的提示）；
2. 支持新增自定义规则，也能导入第三方规则库（CheckStyle、PMD、FindBugs）；
3. 可以新建企业专属规则集，筛选符合团队开发规范的规则统一管理。

  **企业一般用默认还是自定义？**

1. **中小团队**：直接使用官方默认的`Sonar way`规则集，仅少量关闭过于严苛、不符合团队习惯的规则，不用从零编写规则；
2. **中大型企业 / 金融政企**：基于默认规则做裁剪 + 补充内部规范，形成企业专属规则集，统一全团队编码约束。

### sonarqube架构简介

#### 一、核心架构组成（官方标准定义）

SonarQube 采用「客户端扫描 + 服务端三进程 + 数据库」的分层架构：

1. **SonarScanner（扫描端）**：运行在 CI / 本地，执行源码扫描、规则初检，生成结构化分析报告。
2. **Web Server（服务端入口）**：对外提供 Web 管理页面、REST API、用户认证与配置管理；**所有外部请求（含扫描报告提交）的唯一入口**。
3. **Compute Engine（计算引擎，CE）**：服务端后台进程，异步消费扫描报告，执行指标计算、问题判定、质量门禁校验，是核心计算单元。
4. **Search Server（Elasticsearch）**：对问题、指标建立索引，支撑页面快速检索与筛选。
5. **数据库（推荐 PostgreSQL）**：持久化存储项目配置、质量数据、历史快照、权限规则。

#### 二、官方标准数据流（严格执行顺序）

1. SonarScanner 在本地完成源码扫描，生成结构化分析报告
2. 扫描器通过 HTTP 调用 **Web Server 的 API 接口**，提交报告（Compute Engine 不对外暴露端口，所有外部请求统一走 Web Server）
3. Web Server 接收报告后，将其送入后台任务队列
4. Compute Engine 异步消费队列，完成规则匹配、复杂度 / 重复率 / 技术债务计算、质量门禁判定
5. 处理完成后，结果写入数据库，同步更新 Elasticsearch 索引
6. Web Server 从数据库与 ES 读取最终数据，在页面展示质量报表

#### 补充说明

Compute Engine 是服务端内部的后台计算进程，不直接对外提供接口；扫描报告必须先经过 Web Server 接入，再转交给 CE 异步处理，这是 SonarQube 的标准设计。

### sonarqube on kubernetes环境搭建

1. 资源文件准备

- 和gitlab共享postgres数据库
- 使用ingress地址 `sonar.luffy.com` 进行访问
- 使用initContainers进行系统参数调整
- sonar/sonar.yaml



```yaml

cat <<\EOF >sonar.yaml
apiVersion: v1
kind: Service
metadata:
  name: sonarqube
  namespace: jenkins
  labels:
    app: sonarqube
spec:
  ports:
  - name: sonarqube
    port: 9000
    targetPort: 9000
    protocol: TCP
  selector:
    app: sonarqube
---
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: jenkins
  name: sonarqube
  labels:
    app: sonarqube
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sonarqube
  template:
    metadata:
      labels:
        app: sonarqube
    spec:
      initContainers:
      - command:
        - /sbin/sysctl
        - -w
        - vm.max_map_count=262144
        image: alpine:3.6
        imagePullPolicy: IfNotPresent
        name: elasticsearch-logging-init
        resources: {}
        securityContext:
          privileged: true
      containers:
      - name: sonarqube
        image: sonarqube:7.9-community
        ports:
        - containerPort: 9000
        env:
        - name: SONARQUBE_JDBC_USERNAME
          valueFrom:
            secretKeyRef:
              name: gitlab-secret
              key: postgres.user.root
        - name: SONARQUBE_JDBC_PASSWORD
          valueFrom:
            secretKeyRef:
              name: gitlab-secret
              key: postgres.pwd.root
        - name: SONARQUBE_JDBC_URL
          value: "jdbc:postgresql://postgres:5432/sonar"
        livenessProbe:
          httpGet:
            path: /sessions/new
            port: 9000
          initialDelaySeconds: 60
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /sessions/new
            port: 9000
          initialDelaySeconds: 60
          periodSeconds: 30
          failureThreshold: 6
        resources:
          limits:
            cpu: 2000m
            memory: 4096Mi
          requests:
            cpu: 1000m
            memory: 1024Mi
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: sonarqube
  namespace: jenkins
spec:
  ingressClassName: nginx
  rules:
  - host: sonar.luffy.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service: 
            name: sonarqube
            port:
              number: 9000
              
EOF




```



```bash
1. sonarqube服务端安装

# 创建sonar数据库
 kubectl -n jenkins exec -ti postgres-5d96874894-5p8q4 -- bash
#/ psql 
# create database sonar;

## 创建sonarqube服务器
kubectl create -f sonar.yaml

## 配置本地hosts解析   
172.16.1.226 sonar.luffy.com
# kubectl -n kube-system edit cm coredns 

## 访问sonarqube，初始用户名密码为 admin/admin
http://sonar.luffy.com
	

2. sonar-scanner的安装
下载地址： https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip

该地址比较慢，可以在网盘下载（https://pan.baidu.com/s/1SiEhWyHikTiKl5lEMX1tJg?pwd=tqb9 提取码: tqb9）。

#github 下载
https://github.com/SonarSource/sonar-scanner-cli/tags
wget https://github.com/SonarSource/sonar-scanner-cli/archive/refs/tags/4.2.0.1873.zip


[root@k8s-slave1 ~]# unzip sonar-scanner-cli-4.2.0.1873-linux.zip
[root@k8s-slave1 ~]# mv sonar-scanner-4.2.0.1873-linux /opt/


3. 演示sonar代码扫描功能

在项目根目录中准备配置文件 sonar-project.properties

[root@k8s-slave1 ~]# git clone -b develop http://gitlab.luffy.com/eladmin/eladmin-api.git
# cd eladmin-api
# java 语言的扫描写法
cat <<\EOF > sonar-project.properties
sonar.projectKey=eladmin-api
sonar.projectName=eladmin-api
# if you want disabled the DTD verification for a proxy problem for example, true by default
# JUnit like test report, default value is test.xml
sonar.sources=eladmin-common/src/main/java,eladmin-system/src/main/java
sonar.language=java
sonar.tests=eladmin-common/src/test/java,eladmin-system/src/test/java
sonar.java.binaries=eladmin-common/target/classes,eladmin-system/target/classes
EOF

git add .
git commit -m "add sonar-project.properties"
git push

配置sonarqube服务器地址

由于sonar-scanner需要将扫描结果上报给sonarqube服务器做质量分析，因此我们需要在sonar-scanner中配置sonarqube的服务器地址：

在集群宿主机中测试，先配置一下hosts文件，然后配置sonar的地址：
# vi /etc/hosts
10.0.0.81 jenkins.luffy.com gitlab.luffy.com sonar.luffy.com

$ cat /root/sonar-scanner-4.2.0.1873-linux/conf/sonar-scanner.properties
#----- Default SonarQube server
#sonar.host.url=http://localhost:9000
sonar.host.url=http://sonar.luffy.com
#----- Default source code encoding
#sonar.sourceEncoding=UTF-8

# 为了使所有的pod都可以通过`sonar.luffy.com`访问，可以配置coredns的静态解析
$ kubectl -n kube-system edit cm coredns 
...
          hosts {
              10.0.0.81 jenkins.luffy.com gitlab.luffy.com sonar.luffy.com
              fallthrough
       }


执行扫描

## 在项目的根目录下执行
$ /opt/sonar-scanner-4.2.0.1873-linux/bin/sonar-scanner  -X 
# 提示  No files nor directories matching 'eladmin-common/target/classes'
# 这个文件时需要mvn clean package 之后产生的
$ mvn clean package

$ /opt/sonar-scanner-4.2.0.1873-linux/bin/sonar-scanner  -X 
16:46:24.190 INFO: ANALYSIS SUCCESSFUL, you can browse http://sonar.luffy.com/dashboard?id=eladmin-api
16:46:24.190 INFO: Note that you will be able to access the updated dashboard once the server has process
16:46:24.190 INFO: More about the report processing at http://sonar.luffy.com/api/ce/task?id=AZLTwwRhX8fS
16:46:24.191 DEBUG: Report metadata written to /root/eladmin-api/.scannerwork/report-task.txt
16:46:24.193 DEBUG: Post-jobs :
16:46:24.194 INFO: Analysis total time: 22.067 s
16:46:24.195 INFO: ------------------------------------------------------------------------
16:46:24.195 INFO: EXECUTION SUCCESS
16:46:24.195 INFO: ------------------------------------------------------------------------
16:46:24.195 INFO: Total time: 23.031s
16:46:24.231 INFO: Final Memory: 15M/60M
16:46:24.231 INFO: ------------------------------------------------------------------------
sonarqube界面查看结果

登录sonarqube界面查看结果，Quality Gates说明

java项目的配置文件通常格式为：
sonar.projectKey=eureka-cluster
sonar.projectName=eureka-cluster
# if you want disabled the DTD verification for a proxy problem for example, true by default
# JUnit like test report, default value is test.xml
sonar.sources=src/main/java
sonar.language=java
sonar.tests=src/test/java
sonar.java.binaries=target/classes

```



### 插件安装及配置

集成到tools容器中

由于我们的代码拉取、构建任务均是在tools容器中进行，因此我们需要把scanner集成到我们的tools容器中，又因为scanner是一个cli客户端，因此我们直接把包解压好，拷贝到tools容器内部，配置一下PATH路径即可，注意两点：

- 直接在在tools镜像中配置`http://sonar.luffy.com`

- 由于tools已经集成了java环境，因此可以直接剔除scanner自带的jre

  - 删掉sonar-scanner/jre目录

  - 修改sonar-scanner/bin/sonar-scanner

    `use_embedded_jre=false`

```bash
cd /root/tools
cp -r /opt/sonar-scanner-4.2.0.1873-linux/ sonar-scanner
## sonar配置，由于我们是在Pod中使用，也可以直接配置：sonar.host.url=http://sonarqube:9000
$ cat sonar-scanner/conf/sonar-scanner.properties
#----- Default SonarQube server
sonar.host.url=http://sonar.luffy.com

#----- Default source code encoding
#sonar.sourceEncoding=UTF-8

rm -rf sonar-scanner/jre
$ vi sonar-scanner/bin/sonar-scanner
...
use_embedded_jre=false
...

```

*Dockerfile*

root/tools/Dockerfile

```bash
#vim Dockerfile
FROM alpine:3.13.4
LABEL maintainer="inspur_lyx@hotmail.com"
USER root

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
    apk update && \
    apk add  --no-cache openrc docker git curl tar gcc g++ make \
    bash shadow openjdk8 python2 python2-dev py-pip python3-dev openssl-dev libffi-dev \
    libstdc++ harfbuzz nss freetype ttf-freefont && \
    mkdir -p /root/.kube && \
    usermod -a -G docker root

# COPY config /root/.kube/


RUN rm -rf /var/cache/apk/*

#-----------------安装 kubectl--------------------#
COPY kubectl /usr/local/bin/
RUN chmod +x /usr/local/bin/kubectl
# ------------------------------------------------#

#-----------------安装 maven--------------------#
COPY apache-maven-3.6.3 /usr/lib/apache-maven-3.6.3
RUN ln -s /usr/lib/apache-maven-3.6.3/bin/mvn /usr/local/bin/mvn && chmod +x /usr/local/bin/mvn
ENV MAVEN_HOME=/usr/lib/apache-maven-3.6.3
#------------------------------------------------#

#---------------安装 sonar-scanner-----------------#
COPY sonar-scanner /usr/lib/sonar-scanner
RUN ln -s /usr/lib/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner && chmod +x /usr/local/bin/sonar-scanner
ENV SONAR_RUNNER_HOME=/usr/lib/sonar-scanner
# ------------------------------------------------#

```



重新构建镜像，并推送到仓库：

```
docker build . -t 10.0.0.80:5000/devops/tools:v2
docker push 10.0.0.80:5000/devops/tools:v2
   
```

1. 修改Jenkins PodTemplate

   为了在新的构建任务中可以拉取v2版本的tools镜像，需要更新PodTemplate

2. 安装并配置sonar插件

   由于sonarqube的扫描的结果需要进行Quality Gates的检测，那么我们在容器中执行完代码扫描任务后，如何知道本次扫描是否通过了Quality Gates，那么就需要借助于sonarqube实现的jenkins的插件。

   - 安装插件

     插件中心搜索sonarqube，直接安装 [SonarQube ScannerVersion2.17.2]

   - 配置插件

     系统管理->系统配置-> **SonarQube servers** ->Add SonarQube

     - Name：sonarqube

     - Server URL：[http://sonar.luffy.com](http://sonar.luffy.com/)

     - Server authentication token

       ① 登录sonarqube -> My Account -> Security -> Generate Token

       ② 登录Jenkins，添加全局凭据，类型为Secret text

   - 如何在jenkinsfile中使用

     我们在 https://jenkins.io/doc/pipeline/steps/sonar/ 官方介绍中可以看到：

###  [Jenkinsfile集成sonarqube演示\]

修改Jenkinsfile

```groovy
cat <<\EOF>Jenkinsfile
pipeline {
    agent { label 'jnlp-slave'}

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timeout(time: 20, unit: 'MINUTES')
        gitLabConnection('gitlab')
    }


    environment {
        REGISTRY = "10.0.0.80:5000"
        IMAGE_REPO = "10.0.0.80:5000/eladmin"
        DINGTALK_CREDS = credentials('dingTalk')
        REGISTRY_CREDS = credentials('registry')
        TAB_STR = "\n                  \n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    }

    stages {
        stage('gitlog') {
            steps {
                script{
                    sh "git log --oneline -n 1 > gitlog.file"
                    env.GIT_LOG = readFile("gitlog.file").trim()
                }
                sh 'printenv'
            }
        }
        stage('checkout') {
            steps {
                checkout scm
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS = env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('mvn package') {
            steps {
                container('tools') {
                    sh 'mvn clean package'
                }               
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('CI'){
            failFast true
            parallel {
                stage('Unit Test') {
                    steps {
                        echo "Unit Test Stage Skip..."
                    }
                }
                stage('Code Scan') {
                    steps {
                        container('tools') {
                            withSonarQubeEnv('sonarqube') {
                                sh 'sonar-scanner -X'
                                sleep 3
                            }
                            script {
                                timeout(1) {
                                    def qg = waitForQualityGate('sonarqube')
                                    if (qg.status != 'OK') {
                                        error "未通过Sonarqube的代码质量阈检查，请及时修改！failure: ${qg.status}"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        stage('build-image') {
            steps {
                container('tools') {
                    retry(2) { sh 'docker build . -t ${IMAGE_REPO}:${GIT_COMMIT}'}
                }
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('push-image') {
            steps {
                container('tools') {
                    retry(2) { 
                        sh """
                            docker logout ${REGISTRY};
                            docker login ${REGISTRY} -u ${REGISTRY_CREDS_USR} -p ${REGISTRY_CREDS_PSW}
                            docker push ${IMAGE_REPO}:${GIT_COMMIT}
                            """
                        }
                }
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('deploy') {
            steps {
                container('tools') {
                    timeout(time: 1, unit: 'MINUTES') {
                        sh "sed -i 's#{{IMAGE_URL}}#${IMAGE_REPO}:${GIT_COMMIT}#g' mainifests/*"
                        sh "kubectl apply -f mainifests/"
                    }
                }
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
    }
    post {
        success { 
            container('tools') {
                echo 'Congratulations!'
                sh """
                    curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                        -H 'Content-Type: application/json' \
                        -d '{
                            "msgtype": "markdown",
                            "markdown": {
                                "title":"myblog",
                                "text": "😄👍 构建成功 👍😄  \n**项目名称**: luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${GIT_BRANCH}   \n**构建地址**: ${RUN_DISPLAY_URL}  \n**构建任务**: ${BUILD_TASKS}"
                            }
                        }'
                """ 
            }

        }
        failure {
            container('tools') {
                echo 'Oh no!'
                sh """
                    curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                        -H 'Content-Type: application/json' \
                        -d '{
                            "msgtype": "markdown",
                            "markdown": {
                                "title":"myblog",
                                "text": "😖❌ 构建失败 ❌😖  \n**项目名称**: luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${GIT_BRANCH}  \n**构建地址**: ${RUN_DISPLAY_URL}  \n**构建任务**: ${BUILD_TASKS}"
                            }
                        }'
                """
            }

        }
        always { 
            echo 'I will always say Hello again!'
        }
    }
}
EOF
git commit -am"add ci"
git push

```



若Jenkins执行任务过程中sonarqube端报类似下图的错：

```bash
[Code Scan] Checking status of SonarQube task 'AX9FxIQUOvgvmwirpLGo' on server 'sonarqube'SonarQube task 'AX9FxIQUOvgvmwirpLGO' status is 'IN PROGRESS'
[Code Scan] Cancelling nested steps due to timeout
```

则需要在sonarqube服务端进行如下配置，添加一个webhook：

路径：`Administration（配置）` → `Configuration（系统设置）` → `Webhooks`

Name: jenkins

URL: http://jenkins:8080/sonarqube-webhook/



小结:

```bash
这是一个 Java + Maven + Sonar + Docker + K8s 的标准自动化上线流程
一、整体流程（按顺序）
1 拉取代码
	从 GitLab 拉取最新代码，记录提交日志。
2. Maven 编译打包
	执行 mvn clean package，生成 Jar 包（target 目录）。
3 .并行校验（单元测试 + 代码扫描）
    单元测试：跳过
    代码扫描：用 sonar-scanner 做代码质量检测，上传 SonarQube，并等待质量门禁结果，不通过直接失败。
4. 构建 Docker 镜像
	根据代码打包好的 Jar，构建成 Docker 镜像。
5.推送镜像到私有仓库
	登录镜像仓库，把镜像推送到 10.0.0.80:5000。
6. K8s 部署
	替换镜像地址，使用 kubectl apply 发布到 Kubernetes。
7. 结果通知
	构建成功 / 失败，自动发送钉钉消息通知。
```





## [jenkins集成robotFramework]

### 简介

基于**Python 开发、开源、关键字驱动**的通用自动化框架，不用写大量代码，用接近自然语言的关键字就能编写自动化脚本，非开发的测试人员也能快速上手，同时支持自动化测试 + RPA 业务流程自动化两大场景Robot Framework

rpa= **Robotic Process Automation**    中文：机器人流程自动化

### **能做什么**

1. Web UI 自动化测试（结合 Selenium）
2. API 接口自动化测试（结合 Requests 库）
3. APP 移动端自动化测试（结合 Appium）
4. 数据库、Linux 服务器等集成测试
5. RPA 办公流程自动化，批量处理重复工作
6. 可集成 Jenkins 持续执行，自动生成测试报告

###  **企业里最常用的场景**

#### 1. 接口自动化测试（使用最广）

通过`RequestsLibrary`做后端 API 回归测试，每次版本迭代，Jenkins 自动批量跑所有接口用例，校验新增代码有没有破坏原有接口逻辑，提前发现服务间调用 bug，金融、政企、中台系统高频使用。

#### 2. Web 端 UI 自动化回归测试

基于 Selenium 做网页功能自动化，针对核心业务流程（登录、下单、审批、支付）编写用例，版本上线前自动跑一遍全流程冒烟测试，替代人工重复点点点。

#### 3. 系统集成测试

一套脚本串联：接口调用→数据库校验→页面结果验证，适合多模块、多系统联动的复杂业务场景。

#### 4. RPA 办公自动化（传统行业高频）

银行、财务、制造业常用：自动拉取业务数据、生成日报报表、多系统之间数据录入同步、定时对账、文件批量处理，解放重复人工操作。

#### 5. 移动端 APP 自动化测试

基于 Appium 库，做安卓、iOS 的核心功能回归、兼容性测试。

### 企业常用第三方核心库

1. `RequestsLibrary`：API 接口测试（最常用）
2. `SeleniumLibrary`：Web 网页 UI 自动化
3. `DatabaseLibrary`：数据库查询、数据校验
4. `AppiumLibrary`：手机 APP 自动化
5. `RPA.Framework`：Excel、PDF、桌面操作、业务流程自动化



### RobotFramework 接口测试模板（RequestsLibrary）

模板 1：基础通用模板（GET/POST、请求头、参数、断言、会话复用）

```bash
*** Settings ***
# 接口测试只需要RequestsLibrary，没用的SeleniumLibrary可以删掉
Library           RequestsLibrary
# 测试报告、重试、标签配置
Test Teardown     Close All Sessions

*** Variables ***
# 测试环境基础地址
${BASE_URL}       http://eladmin-api.luffy:8000
# 全局请求头，比如token、内容类型
&{HEADERS}        Content-Type=application/json

*** Keywords ***
# 关键字：登录获取token，后续所有接口自动带上登录凭证
Login And Get Token
    ${resp}    Post Request    api    /auth/login    json={"username":"admin","password":"123456"}    headers=${HEADERS}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${token}    Get From Dictionary    ${resp.json()}    token
    Set Suite Variable    ${token}

*** Test Cases ***
# 前置：全局只登录一次，所有用例复用token
Suite Setup       Create Session    api    ${BASE_URL}    headers=${HEADERS}
Suite Setup       Login And Get Token
# 把token塞进全局请求头
${HEADERS.Authorization}    Bearer ${token}

# 用例1：健康检查 GET 无参数
接口-服务健康检查[critical]
    [Tags]    critical    smoke
    ${res}    Get Request    api    /
    Should Be Equal    ${res.status_code}    200
    Log    ${res.json()}

# 用例2：GET带URL参数
接口-获取验证码
    [Tags]    smoke
    ${params}    Create Dictionary    uuid=test123
    ${res}    Get Request    api    /auth/code    params=${params}
    Should Be Equal    ${res.status_code}    200
    Should Contain    ${res.json()}    img

# 用例3：POST JSON请求（业务新增/提交）
接口-新增用户
    ${json_data}    Create Dictionary    username=test01    phone=13800138000
    ${res}    Post Request    api    /user/add    json=${json_data}
    Should Be Equal    ${res.status_code}    200
    Should Be True    ${res.json()["code"]} == 200

# 用例4：PUT修改接口
接口-编辑用户
    ${json_data}    Create Dictionary    id=1    username=test02
    ${res}    Put Request    api    /user/update    json=${json_data}
    Should Be Equal    ${res.status_code}    200

# 用例5：DELETE删除接口
接口-删除用户
    ${res}    Delete Request    api    /user/1
    Should Be Equal    ${res.status_code}    200
```

模板 2：参数化数据驱动模板（多组参数批量测试）

```bash
*** Settings ***
Library           RequestsLibrary
Test Teardown     Close All Sessions

*** Variables ***
${BASE_URL}       http://eladmin-api.luffy:8000
&{HEADER}         Content-Type=application/json

*** Test Cases ***
Suite Setup    Create Session    api    ${BASE_URL}    headers=${HEADER}

# 数据驱动：多组账号密码批量登录校验
批量登录数据校验
    [Tags]    data
    ${test_data}=    Create List
    ...    ${{"username":"admin","password":"123456","expect_code":200}}
    ...    ${{"username":"admin","password":"wrong","expect_code":500}}
    :FOR    ${case}    IN    @{test_data}
    \    ${user}=    Get From Dictionary    ${case}    username
    \    ${pwd}=    Get From Dictionary    ${case}    password
    \    ${expect}=    Get From Dictionary    ${case}    expect_code
    \    ${res}=    Post Request    api    /auth/login    json={"username":"${user}","password":"${pwd}"}
    \    Should Be Equal    ${res.json()["code"]}    ${expect}
```

模板 3：数据库校验接口（调用接口后查库验证数据是否落库）

需要提前导入库：`Library    DatabaseLibrary`

```bash

*** Settings ***
Library           RequestsLibrary
Library           DatabaseLibrary

*** Variables ***
${BASE_URL}       http://eladmin-api.luffy:8000
# 数据库连接信息
${DB_CONN}        mysql+pymysql://root:123456@127.0.0.1:3306/eladmin

*** Keywords ***
连接数据库
    Connect To Database Using Custom Params    pymysql    ${DB_CONN}

关闭数据库连接
    Disconnect From Database

*** Test Cases ***
Suite Setup    Create Session    api    ${BASE_URL}
Suite Setup    连接数据库
Test Teardown    关闭数据库连接

新增用户并校验数据库数据
    ${json}    Create Dictionary    username=testdb    phone=13900139000
    ${res}    Post Request    api    /user/add    json=${json}
    Should Be Equal    ${res.status_code}    200
    # 查询数据库校验是否存在该用户
    ${sql_res}    Query    select * from sys_user where username='testdb'
    Should Not Be Empty    ${sql_res}
```



```bash

二、常用核心关键字说明（快速修改参考）
Create Session：创建 HTTP 会话，全局复用连接
Get Request / Post Request / Put Request / Delete Request：四种常用请求方式
params：拼接 URL 查询参数；json：传递 JSON 请求体
${res.json()}：获取接口返回 JSON 字典，可通过键取值
常用断言：
Should Be Equal：相等断言（状态码、返回码）
Should Contain：返回内容包含指定字符串
Should Not Be Empty：返回数据非空

三、Jenkins 执行常用命令
# 指定只执行critical标签用例，测试报告输出到artifacts目录
robot -d artifacts/ --include critical robot.txt
# 排除冒烟用例执行
# robot -d artifacts/ --exclude smoke robot.txt

----其他
.txt 只是兼容格式，企业标准推荐后缀：.robot
官方文档中心（新手教程、语法手册）：https://docs.robotframework.org/docsROBOT FRAMEWORK

所有 Should Be Equal、Log、Set Variable 这类内置关键字在这里查：
https://robotframework.org/robotframework/latest/libraries/BuiltIn.html

2、接口测试 RequestsLibrary 关键字（你当前最常用）
Create Session、Get Request、Post Request 全部官方用法 + 示例：
https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html

3、SeleniumLibrary Web UI 自动化关键字
https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html


本地快速查关键字小技巧（不用每次打开网页）
命令行查看内置库：
python -m robot.libdoc BuiltIn BuiltIn.html

查看 Requests 库所有关键字，生成本地 HTML 文档：
python -m robot.libdoc RequestsLibrary RequestsLibrary.html
执行后会在当前目录生成网页，离线可查所有关键字、参数、示例。

```







### [[robot用例简介\]]

```bash

cat <<\EOF > robot.txt
*** Settings ***
Library           RequestsLibrary
Library           SeleniumLibrary

*** Variables ***
${api_url}       http://eladmin-api.luffy:8000/

*** Test Cases ***
api1
    [Tags]  critical
    Create Session    api    ${api_url}
    ${alarm_system_info}    RequestsLibrary.Get Request    api    /
    log    ${alarm_system_info.status_code}
    log    ${alarm_system_info.content}
    should be true    ${alarm_system_info.status_code} == 200

api2
    [Tags]  critical
    Create Session    api    ${api_url}
    ${alarm_system_info}    RequestsLibrary.Get Request    api    /auth/code
    log    ${alarm_system_info.status_code}
    log    ${alarm_system_info.content}
    should be true    ${alarm_system_info.status_code} == 200
EOF
    
--------------------------------------------------------------解释
*** Settings ***
# 引入RF内置第三方库：实现HTTP接口请求能力
Library           RequestsLibrary
# 引入RF内置第三方库：实现Web浏览器UI自动化能力（当前脚本未使用）
Library           SeleniumLibrary

*** Variables ***
# 定义全局变量：被测系统的接口基础地址（测试环境后端服务地址）
${api_url}       http://eladmin-api.luffy:8000/

*** Test Cases ***
# 第一条接口用例，标签标记为critical（关键用例，失败直接判定测试失败）
api1
    [Tags]  critical
    # 创建一个HTTP会话，会话命名为api，绑定上面配置的接口基础地址
    Create Session    api    ${api_url}
    # 发送GET请求，访问根路径 /
    ${alarm_system_info}    RequestsLibrary.Get Request    api    /
    # 打印本次请求返回的HTTP状态码
    log    ${alarm_system_info.status_code}
    # 打印接口返回的响应正文数据
    log    ${alarm_system_info.content}
    # 断言：必须保证接口返回状态码等于200，否则当前用例执行失败
    should be true    ${alarm_system_info.status_code} == 200

# 第二条关键接口测试用例，获取图形验证码接口
api2
    [Tags]  critical
    # 复用会话名称api创建HTTP连接
    Create Session    api    ${api_url}
    # GET请求调用验证码接口 /auth/code
    ${alarm_system_info}    RequestsLibrary.Get Request    api    /auth/code
    # 打印响应状态码
    log    ${alarm_system_info.status_code}
    # 打印接口返回内容
    log    ${alarm_system_info.content}
    # 校验接口必须请求成功，状态码200
    should be true    ${alarm_system_info.status_code} == 200
-------------------------------------------------------------------------------


# 使用tools镜像启动容器，来验证手动使用robotframework来做验收测试
$ docker run --rm -ti 10.0.0.8:5000/devops/tools:v2 bash
bash-5.0# apk add py-pip python3-dev
$ cat requirements.txt
robotframework
robotframework-seleniumlibrary
robotframework-databaselibrary
robotframework-requests
#pip安装必要的软件包
$ python3 -m pip install --upgrade pip -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com && pip3 install -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com -r requirements.txt 

$ cat /etc/resolv.conf
search jenkins.svc.cluster.local svc.cluster.local cluster.local in.ctcdn.cn ss.in.ctcdn.cn
nameserver 10.96.0.10
options ndots:5


# vi robot.txt #复制上面的代码
#使用robot命令做测试
$ robot -d artifacts/ robot.txt

```



### [与tools工具镜像集成]  docker build 新的镜像

```bash

cd tools  #k8s-slave1 
cat <<\EOF >requirements.txt
robotframework
robotframework-seleniumlibrary
robotframework-databaselibrary
robotframework-requests
EOF

cat <<\EOF >Dockerfile
FROM alpine:3.13.4
LABEL maintainer="inspur_lyx@hotmail.com"
USER root

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
    apk update && \
    apk add  --no-cache openrc docker git curl tar gcc g++ make \
    bash shadow openjdk8 python2 python2-dev py-pip python3-dev openssl-dev libffi-dev \
    libstdc++ harfbuzz nss freetype ttf-freefont chromium chromium-chromedriver && \
    mkdir -p /root/.kube && \
    usermod -a -G docker root


# COPY config /root/.kube/

COPY requirements.txt /

RUN python3 -m pip install --upgrade pip -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com && pip3 install -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com -r requirements.txt  


RUN rm -rf /var/cache/apk/* && \
    rm -rf ~/.cache/pip

#-----------------安装 kubectl--------------------#
COPY kubectl /usr/local/bin/
RUN chmod +x /usr/local/bin/kubectl
# ------------------------------------------------#

#-----------------安装 maven--------------------#
COPY apache-maven-3.6.3 /usr/lib/apache-maven-3.6.3
RUN ln -s /usr/lib/apache-maven-3.6.3/bin/mvn /usr/local/bin/mvn && chmod +x /usr/local/bin/mvn
ENV MAVEN_HOME=/usr/lib/apache-maven-3.6.3
#------------------------------------------------#

#---------------安装 sonar-scanner-----------------#
COPY sonar-scanner /usr/lib/sonar-scanner
RUN ln -s /usr/lib/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner && chmod +x /usr/local/bin/sonar-scanner
ENV SONAR_RUNNER_HOME=/usr/lib/sonar-scanner
# ------------------------------------------------#
EOF

docker build . -t 10.0.0..80:5000/devops/tools:v3

docker push 10.0.0..80:5000/devops/tools:v3


更新Jenkins中kubernetes中的containers pod template


```



### jenkins中插件安装及配置

为什么要安装robot插件？

1. 安装robotFramework
   - 插件中心搜索robotframework，直接安装
   - tools集成robot命令（之前已经安装）



2.与jenkinsfile的集成

```groovy
    container('tools') {
        sh 'robot  -d artifacts/ robot.txt || echo ok'
        echo "R ${currentBuild.result}"
        step([
            $class : 'RobotPublisher',
            outputPath: 'artifacts/',
            outputFileName : "output.xml",
            disableArchiveOutput : false,
            passThreshold : 80,
            unstableThreshold: 20.0,
            onlyCritical : true,
            otherFiles : "*.png"
        ])
        echo "R ${currentBuild.result}"
        archiveArtifacts artifacts: 'artifacts/*', fingerprint: true
    }
-------------------------------------------解释说明
container('tools') {
    # 执行Robot Framework接口自动化用例，测试报告、日志输出到artifacts目录；用例失败不直接终止流水线
    sh 'robot  -d artifacts/ robot.txt || echo ok'
    # 打印执行自动化后的当前构建状态
    echo "R ${currentBuild.result}"
    # 配置Jenkins的Robot插件，解析自动化测试结果并生成可视化测试报告
    step([
        $class : 'RobotPublisher',
        outputPath: 'artifacts/',          // RF测试报告存放目录
        outputFileName : "output.xml",     // RF生成的测试结果原始xml文件
        disableArchiveOutput : false,      // 不禁止归档测试报告文件
        passThreshold : 80,               // 用例通过率≥80%才判定构建成功
        unstableThreshold: 20.0,          // 失败用例占比超过20%则标记构建状态为不稳定
        onlyCritical : true,              // 只统计带critical标签的核心用例
        otherFiles : "*.png"              // 归档测试过程中截图类附件文件
    ])
    # 打印解析完测试报告后的最新构建状态
    echo "R ${currentBuild.result}"
    # 将artifacts目录下所有测试报告文件归档保存到Jenkins构建记录中，支持文件指纹追踪
    archiveArtifacts artifacts: 'artifacts/*', fingerprint: true
}
```



### 实践通过Jenkinsfile实现demo项目的验收测试

项目源代码添加robot.txt文件：

```bash
cat <<\EOF >robot.txt
*** Settings ***
Library           RequestsLibrary
Library           SeleniumLibrary

*** Variables ***
${api_url}       http://eladmin-api.luffy:8000/

*** Test Cases ***
api1
    [Tags]  critical
    Create Session    api    ${api_url}
    ${alarm_system_info}    RequestsLibrary.Get Request    api    /
    log    ${alarm_system_info.status_code}
    log    ${alarm_system_info.content}
    should be true    ${alarm_system_info.status_code} == 200

api2
    [Tags]  critical
    Create Session    api    ${api_url}
    ${alarm_system_info}    RequestsLibrary.Get Request    api    /auth/code
    log    ${alarm_system_info.status_code}
    log    ${alarm_system_info.content}
    should be true    ${alarm_system_info.status_code} == 200
EOF

#修改Jenkinsfile


pipeline {
    agent { label 'jnlp-slave'}
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timeout(time: 20, unit: 'MINUTES')
        gitLabConnection('gitlab')
    }

    environment {
        IMAGE_REPO = "172.16.1.226:5000/myblog"
        DINGTALK_CREDS = credentials('dingTalk')
        TAB_STR = "\n                    \n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    }

    stages {
        stage('git-log') {
            steps {
                script{
                    sh "git log --oneline -n 1 > gitlog.file"
                    env.GIT_LOG = readFile("gitlog.file").trim()
                }
                sh 'printenv'
            }
        }        
        stage('checkout') {
            steps {
                container('tools') {
                    checkout scm
                }
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS = env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('mvn package') {
            steps {
                container('tools') {
                    sh 'mvn clean package'
                }               
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('CI'){
            failFast true
            parallel {
                stage('Unit Test') {
                    steps {
                        echo "Unit Test Stage Skip..."
                    }
                }
                stage('Code Scan') {
                    steps {
                        container('tools') {
                            withSonarQubeEnv('sonarqube') {
                                sh 'sonar-scanner -X'
                                sleep 3
                            }
                            script {
                                timeout(1) {
                                    def qg = waitForQualityGate('sonarqube')
                                    if (qg.status != 'OK') {
                                        error "未通过Sonarqube的代码质量阈检查，请及时修改！failure: ${qg.status}"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        stage('build-image') {
            steps {
                container('tools') {
                    retry(2) { sh 'docker build . -t ${IMAGE_REPO}:${GIT_COMMIT}'}
                }
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('push-image') {
            steps {
                container('tools') {
                    retry(2) { sh 'docker push ${IMAGE_REPO}:${GIT_COMMIT}'}
                }
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('deploy') {
            steps {
                container('tools') {
                    sh "sed -i 's#{{IMAGE_URL}}#${IMAGE_REPO}:${GIT_COMMIT}#g' mainifests/*"
                    timeout(time: 1, unit: 'MINUTES') {
                        sh "kubectl apply -f mainifests/;sleep 20;"
                    }
                }
                updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                script{
                    env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                }
            }
        }
        stage('Accept Test') {
            steps {
                    container('tools') {
                        sh 'robot -d artifacts/ robot.txt'
                        echo "R ${currentBuild.result}"
                        step([
                            $class : 'RobotPublisher',
                            outputPath: 'artifacts/',
                            outputFileName : "output.xml",
                            disableArchiveOutput : false,
                            passThreshold : 80,
                            unstableThreshold: 20.0,
                            onlyCritical : true,
                            otherFiles : "*.png"
                        ])
                        echo "R ${currentBuild.result}"
                        archiveArtifacts artifacts: 'artifacts/*', fingerprint: true
                    }
            }
        }
    }
    post {
        success { 
           container('tools') {
              echo 'Congratulations!'
              sh """
                curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                    -H 'Content-Type: application/json' \
                    -d '{
                        "msgtype": "markdown",
                        "markdown": {
                            "title":"myblog",
                            "text": "😄👍 构建成功 👍😄  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${BRANCH_NAME}   \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                        }
                    }'
               """ 
           }
        }
        failure {
           container('tools') {
              echo 'Oh no!'
              sh """
                curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                    -H 'Content-Type: application/json' \
                    -d '{
                        "msgtype": "markdown",
                        "markdown": {
                            "title":"myblog",
                            "text": "😖❌ 构建失败 ❌😖  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${BRANCH_NAME}  \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                        }
                    }'
               """
           }
        }
        always { 
            echo 'I will always say Hello again!'
        }
    }
}

```

在Jenkins中查看robot的构建结果。



总结: 

## Jenkins 完整构建流程

### 整体流程顺序（从上到下真实执行链路）🎯

1. **获取 Git 最新提交日志**

   记录本次构建的 Git 提交记录，用于钉钉推送展示。

2. **拉取代码（checkout）**

   从 GitLab 拉取源码，初始化构建任务状态。

3. **Maven 编译打包**

   执行 `mvn clean package`，编译 Java 项目、生成 class、执行单元测试、产出 Jar 包。

4. **CI 并行质检**

   - 单元测试：跳过

   - SonarQube 代码质量扫描

     使用 sonar-scanner 扫描代码 → 上报服务端 → 

     阻塞等待质量门禁

     门禁不通过直接终止构建，禁止后续打包部署。

5. **构建 Docker 镜像**

   根据当前 Git commit 打包成镜像。

6. **推送镜像到私有仓库**

   将镜像推送到本地镜像仓库，供 K8s 部署使用。

7. **K8s 部署服务**

   替换镜像版本 → `kubectl apply` 部署服务，sleep 20s **等待服务启动就绪**。

8. **RobotFramework 自动化接口验收测试（核心）**

   服务部署**启动成功后**执行 RF 接口自动化：

   - 测试服务根路径健康检查
   - 测试验证码接口可用性
   - 只运行 critical 核心用例
   - 自动生成测试报告、归档到 Jenkins
   - **自动化用例失败 → 本次构建直接失败，阻断交付**

9. **钉钉结果通知**

   构建成功 / 失败自动推送 markdown 结果到钉钉群。

------

### 最关键的核心逻辑（之前疑惑的点）

1. **Sonar 位置**：打包后、镜像构建前

   作用：**代码质量卡点，代码烂直接不让打包上线**

2. **Robot 自动化位置：部署之后！！**

   必须等 K8s 服务启动完成才执行接口测试

   原因：**接口必须服务部署启动通了才能测**，

3. **整条流水线卡点顺序**

   代码质量 (Sonar) → 镜像打包 → 服务部署 → 功能验收测试 (Robot)

------

### 一句话终极背诵版 🎯

**拉代码→Maven 打包→Sonar 代码质量门禁校验→构建推送镜像→K8s 部署启动服务→Robot 接口自动化验收测试→钉钉通知结果**



小结:

1. 讲解最基础的Jenkins的使用
2. Pipeline流水线的使用
3. Jenkinsfile的使用
4. 多分支流水线的使用
5. 与Kubernetes集成，动态jnlp slave pod的使用
6. 与sonarqube集成，实现代码扫描
7. 与Robotframework集成，实现验收测试





- 





# 笔记本 vmare workstation  关闭学习K8S集群

```bash

# 禁止新Pod调度到节点
kubectl cordon k8s-slave1
kubectl cordon k8s-slave2

# 优雅驱逐所有业务Pod
kubectl drain k8s-slave1 --ignore-daemonsets --delete-emptydir-data --force
kubectl drain k8s-slave2 --ignore-daemonsets --delete-emptydir-data --force

# --ignore-daemonsets：忽略网络插件、监控这类 DaemonSet 组件 Pod
# --delete-emptydir-data：清理临时存储 Pod，防止排空卡住
# --force：强制驱逐裸 Pod、不受控制器管理的 Pod

# 确认 slave 节点已经排空
kubectl get pods --all-namespaces -o wide | grep k8s-slave1
kubectl get pods --all-namespaces -o wide | grep k8s-slave2


# 两台 Slave 分别优雅关机
ssh root@k8s-slave1 "systemctl poweroff"
ssh root@k8s-slave2 "systemctl poweroff"


systemctl stop kubelet
systemctl stop docker
systemctl poweroff

二、开机顺序（反向操作）
先启动 Master，等待系统与集群服务就绪
再依次启动两台 Slave
Master 执行解除节点封锁：
kubectl uncordon k8s-slave1
kubectl uncordon k8s-slave2
```







