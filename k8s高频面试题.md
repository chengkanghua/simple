# k8s 高频面试题

1. 为什么生产集群 Master 推荐**奇数节点（3/5/7）**？

   偶数节点容错能力和少一台的奇数集群一致，4 节点最多也只能坏 1 台，却多一台机器成本，无收益。

   | Master 节点数 | 法定多数派 | 最大可故障节点数 |

   | ---- | ---- | ---- |

   | 3 | 2 | 1 |

   | 5 | 3 | 2 |

   | 7 | 4 | 3 |

2. kube-apiserver 是无状态组件

   哪怕挂 2 台 apiserver，只要 etcd 集群多数派正常，剩余 apiserver 节点依然可以负载均衡对外提供服务，不影响集群可用性。

3. 临时故障 vs 永久硬件故障

- 短暂网络 / 机器重启：2 台故障恢复后，etcd 自动同步日志，集群自动恢复；
- 硬件永久损坏：必须先把故障节点从 etcd 集群中移除，再新增 Master 节点扩容，恢复容错能力。

## 一、基础概念与集群架构（必问）

### 1. 简述 Kubernetes 是什么，核心能力有哪些？

- K8S 是开源的**容器编排平台**，用于自动化部署、扩缩容和管理容器化应用。
- 核心能力：服务发现与负载均衡、存储编排、自动部署与回滚、自动装箱、自我修复、配置与密钥管理、水平扩缩容。

### 2. Master / Node 节点分别有哪些核心组件，各自作用？

**Master 控制面**

- `kube-apiserver`：集群唯一入口，提供 RESTful API，所有组件交互都经过它。
- `etcd`：分布式键值存储，保存集群所有状态数据。
- `kube-scheduler`：负责 Pod 调度，选择合适的节点运行 Pod。
- `kube-controller-manager`：运行各类控制器（节点、副本、端点等），保证集群状态符合预期。
- `cloud-controller-manager`：对接云厂商资源，可选。

**Node 数据面**

- `kubelet`：节点代理，接收 Master 指令，管理本节点 Pod 和容器生命周期。
- `kube-proxy`：实现 Service 网络规则，负责集群内服务访问与负载均衡。
- 容器运行时：如 containerd、docker，负责真正拉取和运行容器。

### 3. 为什么 K8S 最小调度单位是 Pod，而不是容器？

- Pod 是**一组共享网络、存储、PID 命名空间的容器集合**，解决 “紧密耦合的多个容器需要共享资源” 的场景。
- 比如业务容器 + 日志采集 sidecar，共享同一个网络栈和数据卷，调度时必须作为一个整体。

------

## 二、核心工作负载与资源（高频）

### 1. Deployment、ReplicaSet、Pod 三者的关系

- Pod 是最小运行单元；ReplicaSet 保证 Pod 副本数量始终符合预期；Deployment 上层管理 ReplicaSet，实现滚动更新、回滚、扩缩容等高级能力。
- 日常不直接操作 ReplicaSet，统一通过 Deployment 管理。

### 2. Deployment 的更新策略

- **RollingUpdate（滚动更新，默认）**：逐步用新 Pod 替换旧 Pod，服务不中断；可配置 `maxSurge`（最大超量副本）和 `maxUnavailable`（最大不可用副本）。
- **Recreate（重建）**：先全部杀掉旧 Pod，再启动新 Pod；服务会中断，适合单副本有状态应用。

### 3. Service 有哪几种类型，适用场景？

| 类型         | 说明                                           | 场景                   |
| :----------- | :--------------------------------------------- | :--------------------- |
| ClusterIP    | 集群内部虚拟 IP，仅集群内可访问                | 内部服务互调           |
| NodePort     | 在每个节点上开放一个端口，节点 IP + 端口可访问 | 测试、临时外部访问     |
| LoadBalancer | 对接云厂商负载均衡器，分配公网 IP              | 公有云生产环境对外服务 |
| ExternalName | 将集群内服务映射到外部域名                     | 代理外部服务           |

### 4. Service 如何关联后端 Pod？Endpoint 作用？

- Service 通过 `selector` 标签选择器匹配符合标签的 Pod。
- Endpoint 自动维护 Service 对应的 Pod IP + 端口列表；kube-proxy 根据 Endpoint 生成转发规则。
- Pod 健康检查失败时，会自动从 Endpoint 中摘除。

### 5. StatefulSet 和 Deployment 的区别

| 维度       | Deployment              | StatefulSet                             |
| :--------- | :---------------------- | :-------------------------------------- |
| 适用       | 无状态应用（Web、API）  | 有状态应用（数据库、中间件集群）        |
| Pod 名称   | 随机后缀，无序          | 固定有序名称（如 web-0、web-1）         |
| 域名       | 无固定 DNS 标识         | 有稳定的 DNS 主机名（Headless Service） |
| 存储       | 所有 Pod 共享或各自 PVC | 每个 Pod 对应独立持久化存储             |
| 扩缩容顺序 | 无序                    | 按序号顺序创建，逆序删除                |

### 6. DaemonSet 的作用

- 在**每个符合条件的节点上都运行一个 Pod 副本**，新增节点时自动部署。
- 典型场景：日志采集、监控代理、网络插件（如 Calico、Flannel）。

### 7. ConfigMap 和 Secret 的区别

- **ConfigMap**：保存非敏感配置信息（环境变量、配置文件），明文存储。
- **Secret**：保存敏感数据（密码、密钥、证书），默认 base64 编码，可配合 RBAC 限制访问，支持加密存储。
- 两者都可以通过环境变量、数据卷挂载注入到 Pod 中。

------

## 三、K8S 网络原理（核心难点）

### 1. 简述 K8S 网络模型

- 基本原则：**每个 Pod 拥有独立 IP，Pod 之间直接通信，不做 NAT**。
- 通信场景：
  1. Pod 内容器：通过 [localhost](https://link.wtturl.cn/?target=https%3A%2F%2Flocalhost&scene=im&aid=582478&lang=zh) 共享网络命名空间。
  2. 同节点 Pod：通过 docker0/cni0 网桥直接转发。
  3. 跨节点 Pod：通过底层网络方案（Flannel VXLAN、Calico BGP 等）封装转发。
  4. Service 访问：kube-proxy 生成转发规则，实现 VIP 到后端 Pod 的负载均衡。

### 2. 什么是 CNI？常用插件有哪些？

- CNI（Container Network Interface）是容器网络接口标准，负责给 Pod 分配 IP、配置网络。
- 常见插件：
  - Flannel：简单，Overlay 网络，性能一般，适合测试。
  - Calico：BGP 三层网络，支持网络策略，性能好，生产常用。
  - Canal：Flannel + Calico 组合，兼顾简单和网络策略。

### 3. kube-proxy 三种模式，ipvs 优势？

- **userspace**：用户态转发，性能差，基本淘汰。
- **iptables**：内核态 netfilter 实现，规则多时匹配慢，大规模集群性能下降。
- **ipvs**：基于内核哈希表，转发性能高、支持更多负载均衡算法，大规模集群推荐。

### 4. Ingress 和 Service 的区别

- Service 是四层（TCP/UDP）负载均衡，负责集群内服务访问。
- Ingress 是七层（HTTP/HTTPS）负载均衡，负责**集群外部流量进入**，支持域名路由、路径转发、SSL 终止、限流等。
- Ingress 本身只是规则，需要 Ingress Controller（如 Nginx Ingress）真正生效。

------

## 四、存储持久化

### 1. PV、PVC、StorageClass 三者关系

- **PV（PersistentVolume）**：集群层面的存储资源，由管理员预先创建，生命周期独立于 Pod。
- **PVC（PersistentVolumeClaim）**：用户对存储的申请，声明容量、访问模式等需求，系统自动匹配绑定 PV。
- **StorageClass**：定义存储类型和供给方式，实现**动态供应 PV**，不用管理员提前批量创建 PV。

### 2. 静态供应 vs 动态供应

- 静态：管理员提前创建一堆 PV，用户 PVC 来匹配绑定。
- 动态：用户创建 PVC 时，StorageClass 自动调用存储接口创建对应 PV，适合大规模生产环境。

### 3. EmptyDir、HostPath、PVC 区别

- EmptyDir：Pod 生命周期临时目录，Pod 删除数据丢失，适合临时缓存。
- HostPath：挂载宿主机本地目录，Pod 删除数据还在，但节点故障就丢失，适合单节点测试。
- PVC：持久化存储，数据不随 Pod / 节点消失，生产环境标准用法。

------

## 五、调度机制

### 1. kube-scheduler 调度流程

1. **预选（Predicate）**：过滤掉不符合条件的节点（资源不足、污点不匹配、端口冲突等）。
2. **优选（Priority）**：对剩余节点打分，选择得分最高的节点。
3. **绑定**：将 Pod 与目标节点绑定，通知 kubelet 创建。

### 2. 污点（Taint）和容忍（Toleration）

- 污点：打在节点上，让节点**排斥**不匹配容忍的 Pod。
- 三种效果：`NoSchedule`（不调度）、`PreferNoSchedule`（尽量不调度）、`NoExecute`（不仅不调度，还会驱逐已有的 Pod）。
- 容忍：打在 Pod 上，允许 Pod 调度到对应污点的节点。
- 典型场景：专用节点、GPU 节点、节点故障自动驱逐。

### 3. 亲和性分类

- 节点亲和性：控制 Pod 倾向 / 必须调度到某些节点。
- Pod 亲和性：让多个 Pod 调度到同一个节点 / 拓扑域，减少网络延迟。
- Pod 反亲和性：让 Pod 分散到不同节点，提高可用性。

------

## 六、运维排障（实战高频）

### 1. Pod 处于 Pending 常见原因

- 节点资源不足（CPU / 内存不够）。
- 没有匹配的节点（节点选择器、亲和性、污点不匹配）。
- PVC 绑定失败、存储供应失败。
- 镜像拉取失败（私有仓库密钥、镜像名错误）。

### 2. CrashLoopBackOff 排查思路

1. 先看 Pod 事件：`kubectl describe pod <pod名>`。
2. 看应用日志：`kubectl logs <pod名> --previous`（看崩溃前一次的日志）。
3. 常见原因：配置错误、依赖服务连不上、权限不足、健康检查失败、程序启动就退出。

### 3. Service 访问不通排查步骤

1. 确认 Service 对应的 Endpoint 是否正常、后端 Pod 是否就绪。
2. 集群内直接访问 Pod IP: 端口，确认应用本身正常。
3. 检查 Service 端口、协议、标签选择器是否匹配。
4. 检查 kube-proxy 是否正常，iptables/ipvs 规则是否生成。
5. 检查网络策略、防火墙是否拦截。

### 4. 节点 NotReady 排查

1. 节点上查看 kubelet 状态、日志。
2. 检查节点磁盘、内存、CPU 是否耗尽。
3. 检查节点与 Master 网络连通性、证书是否过期。
4. 检查容器运行时（containerd/docker）是否异常。

------

## 七、安全与权限

### 1. RBAC 核心三要素

- **角色（Role/ClusterRole）**：定义权限集合（能对哪些资源做什么操作）。
- **主体（Subject）**：用户、组、ServiceAccount。
- **绑定（RoleBinding/ClusterRoleBinding）**：将角色和主体关联起来。
- Role + RoleBinding 作用于命名空间；ClusterRole + ClusterRoleBinding 作用于整个集群。

### 2. ServiceAccount 是什么

- 给 Pod 内部进程使用的账号，用于 Pod 访问 apiserver 时的身份认证。
- 每个命名空间有默认 default ServiceAccount，可自定义并挂载到 Pod 中。

### 3. requests 和 limits 区别，QoS 等级

- requests：申请资源，调度时参考，节点至少有这么多资源才会调度。
- limits：资源上限，超过可能被 OOM Kill 或限流。
- QoS 三级：
  - Guaranteed：requests = limits，优先级最高，最后被驱逐。
  - Burstable：设置了 requests 且小于 limits，中等优先级。
  - BestEffort：不设置任何资源限制，优先级最低，最先被驱逐。

------

## 八、进阶与生产实践

### 1. 集群高可用（HA）方案

- 控制面：多 Master 节点，apiserver 前加负载均衡，etcd 集群化部署（奇数节点）。
- 数据面：多节点冗余，应用多副本分布在不同节点。
- 核心：etcd 集群高可用、apiserver 负载均衡、控制面组件多副本。

### 2. etcd 备份与恢复

- 备份：使用 `etcdctl snapshot save` 生成快照文件，定期定时备份。
- 恢复：停止所有 apiserver，用快照文件恢复每个 etcd 节点数据，重启 etcd 和控制面组件。

### 3. Helm 是什么

- K8S 的包管理工具，把一整套应用资源打包成 Chart。
- 核心概念：Chart（应用包）、Release（一次安装的运行实例）、Repository（Chart 仓库）。
- 优势：版本化管理、一键部署升级、参数模板化、复用性强。

### 4. HPA 水平自动扩缩容原理

- 定期采集 Pod 指标（CPU、内存、自定义指标），和目标阈值对比。
- 计算期望副本数，自动调整 Deployment/StatefulSet 的 replicas 数量。
- 依赖 Metrics Server 提供基础指标，自定义指标需要 Prometheus + Adapter。

### 5. Operator 是什么

- 将运维人员的操作经验编码成控制器，自动管理有状态应用的部署、升级、备份、故障恢复。
- 核心：自定义资源（CRD）+ 自定义控制器，让复杂有状态应用像原生资源一样被 K8S 管理。