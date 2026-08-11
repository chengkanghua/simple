# k8s 高频面试题

## 〇、集群高可用基础（etcd 多数派 / apiserver 无状态，必问）

### 1. 为什么生产集群 Master 推荐奇数节点（3/5/7）？

偶数节点容错能力和少一台的奇数集群一致，4 节点最多也只能坏 1 台，却多一台机器成本，无收益。

| Master 节点数 | 法定多数派 | 最大可故障节点数 |
| ---- | ---- | ---- |
| 3 | 2 | 1 |
| 5 | 3 | 2 |
| 7 | 4 | 3 |

### 2. kube-apiserver 是无状态组件

哪怕挂 2 台 apiserver，只要 etcd 集群多数派正常，剩余 apiserver 节点依然可以负载均衡对外提供服务，不影响集群可用性。

### 3. 临时故障 vs 永久硬件故障

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

### 8. Pod 生命周期有哪些阶段？

| 状态 | 含义 |
| :--- | :--- |
| Pending | 已提交但未调度完成（等待资源、PVC、镜像） |
| ContainerCreating | 镜像拉取 / 容器创建中 |
| Running | 至少一个容器正常运行 |
| Succeeded | 所有容器正常退出（一次性任务） |
| Failed | 至少一个容器以非 0 码退出 |
| CrashLoopBackOff | 容器反复启动即崩溃，需查日志 |
| ImagePullBackOff | 镜像拉取失败 |

### 9. 探针（Probe）有哪几种？各自作用？

- **livenessProbe（存活）**：容器是否还活着，失败则**重启容器**。
- **readinessProbe（就绪）**：容器能否接收流量，失败则**从 Endpoint 摘除**，不重启。
- **startupProbe（启动）**：保护启动慢的应用，成功后才开始 liveness 探测，避免启动阶段被误杀。
- 探测方式：`exec`（执行命令）、`httpGet`（HTTP 请求）、`tcpSocket`（TCP 连接）。

### 10. 镜像拉取策略 imagePullPolicy 有哪些？

- `Always`：每次都从仓库拉取。
- `IfNotPresent`：本地没有才拉取（默认值；tag 为 `latest` 时强制 Always）。
- `Never`：只用本地镜像，不访问仓库。
- 生产建议：镜像固定版本号 + `IfNotPresent`，避免 `latest` 引发版本漂移。

### 11. 如何回滚 Deployment？

- 回滚到上一个版本：`kubectl rollout undo deployment/<名称>`
- 回滚到指定版本：`kubectl rollout undo deployment/<名称> --to-revision=<版本号>`
- 查看历史与状态：`kubectl rollout history deployment/<名称>`、`kubectl rollout status deployment/<名称>`

------

## 三、K8S 网络原理（核心难点）

### 1. 简述 K8S 网络模型

- 基本原则：**每个 Pod 拥有独立 IP，Pod 之间直接通信，不做 NAT**。
- 通信场景：
  1. Pod 内容器：通过 `localhost` 共享网络命名空间。
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

### 5. CoreDNS 的作用？Pod 如何解析 Service 域名？

- CoreDNS 是集群内置 DNS，负责 Service / Pod 域名解析（监听 53 端口）。
- Service 域名格式：`<服务名>.<命名空间>.svc.cluster.local`。
- 同命名空间内可直接用服务名访问，跨命名空间必须写全名。
- 自定义域名解析：`dnsConfig`、`hostAliases`、ExternalName 类型 Service。

### 6. 什么是 NetworkPolicy？

- 网络策略，用标签选择器定义哪些 Pod 之间的流量允许 / 拒绝（ingress / egress 规则）。
- 需要 CNI 插件支持（Calico 支持，Flannel 默认不支持）。
- 默认不设置策略时全放行；设置策略后未匹配的流量默认拒绝，用于租户隔离、安全管控。

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

### 6. 应用优雅停机怎么做？

- `preStop` hook：容器终止前执行清理（注销注册中心、排空连接、上报下线）。
- `terminationGracePeriodSeconds`：SIGTERM 后等待的宽限期（默认 30s），超时强制 SIGKILL。
- 正确顺序：readiness 探针先把流量摘除 → preStop 优雅退出 → 宽限期超时再强杀。

### 7. 蓝绿发布、金丝雀发布原理？

- **蓝绿**：新旧两套环境并存，一键切换流量到新环境，回滚快，但资源占用翻倍。
- **金丝雀**：新版本先放少量流量（如 5%~10%）验证，确认无误再逐步放量，风险可控。
- 实现方式：Deployment 多副本 + Ingress 权重 / Istio 流量比例，配合 HPA 或手工调副本数。

# K8S 常见经典面试题（带答案）

> 综合面试实战整理，覆盖基础原理、工作负载、网络、存储、调度、安全、排障、生产运维八大方向。标注必背度：🔴 必背 / 🟡 熟练 / 🟢 了解。答案按「面试口述 + 追问」组织，可直接背诵。

## 一、基础原理与设计思想

### 1. 🔴 Kubernetes 解决了什么问题？和 Docker Compose / Swarm 的区别？

- Docker 只解决"单机怎么跑容器"，大规模多节点时缺调度、服务发现、自愈、扩缩容。
- Compose 是单机多容器编排，Swarm 是简单集群但功能弱、生态差。
- K8s 提供**声明式编排 + 控制面/数据面分离 + 控制器自愈**，是生产级容器编排事实标准。
- 追问：为什么用声明式不用命令式？——声明式只管"期望状态"，控制器持续让实际状态收敛到期望状态，天然支持自愈；命令式是执行动作，故障无法自动恢复。

### 2. 🔴 什么是声明式 API？一次 `kubectl apply` 后发生了什么？

- 用户提交 YAML 期望状态 → apiserver 认证鉴权 + 校验 + 写入 etcd → 各控制器监听并收敛 → scheduler 调度 → kubelet 创建容器。
- 核心链路：**apiserver → etcd → controller-manager/scheduler → kubelet → 容器运行时**。
- 追问：为什么 apiserver 是唯一入口？——统一认证鉴权、准入控制（Admission）、校验和审计，所有组件都通过它访问 etcd，保证一致性与安全。

### 3. 🔴 etcd 为什么用 Raft 共识算法？核心机制是什么？

- etcd 是分布式一致性键值存储，集群所有状态都存其中。
- Raft 核心：**Leader 选举 + 日志复制 + 多数派（Quorum）确认**；写请求只有过半节点确认才提交。
- 多数派机制决定了"奇数节点容错更好"：3 节点允许坏 1，5 节点允许坏 2。
- 追问：etcd 挂了会怎样？——集群只读、无法调度变更；已运行 Pod 继续运行，但服务发现、扩缩容、滚动更新全部失效。

### 4. 🟡 Pod 中的 pause（infra）容器是干什么的？

- 每个 Pod 里第一个创建的容器，承担**共享命名空间**（网络、UTS、IPC）+ 共享 PID namespace。
- 业务容器加入 pause 的网络命名空间，所以 Pod 内容器共用 IP、端口和 localhost。
- 业务容器死掉重启不影响 pause，Pod 的网络标识保持不变。
- 追问：PID namespace 共享意味着什么？——Pod 内进程对 pause 而言是子进程，业务容器退出时 pause 负责兜底，避免僵尸进程残留。

### 5. 🟡 什么情况下多个容器放一个 Pod？什么情况下必须拆成多个 Pod？

- **放一起**：强耦合、共享生命周期——业务 + sidecar 日志采集、业务 + 网络代理、业务 + 本地缓存。
- **拆开**：可以独立扩缩容、独立发布、资源可分别管理——例如业务与独立 MySQL 必须拆开。
- 判断标准：**能否独立扩缩容、独立升级、独立故障**？能就不该塞进一个 Pod。

## 二、核心工作负载深入

### 6. 🔴 Deployment 滚动更新细节：maxSurge 和 maxUnavailable 怎么理解？

- `maxSurge`：滚动期间**最多超出期望副本数**的 Pod 数（默认 25%），控制新 Pod 一次性起多少个。
- `maxUnavailable`：滚动期间**最多允许不可用**的 Pod 数（默认 25%），控制旧 Pod 最多先杀多少个。
- 两者共同决定更新速度与可用性：想更稳就把 maxUnavailable 设小、maxSurge 设大；想省资源则相反。
- 追问：滚动更新安全阀？——`progressDeadlineSeconds` 超时视为更新失败，会暂停；`kubectl rollout undo` 一键回滚。

### 7. 🔴 Job 和 CronJob 的区别？

- Job：一次性任务，保证指定数量的 Pod 成功结束（如数据迁移、批量处理）。
- CronJob：按 cron 时间表达式**定时创建 Job**（如每天备份、定期清理日志）。
- 追问：Job 失败重试机制？——`backoffLimit` 控制失败重试次数，`ttlSecondsAfterFinished` 自动清理已完成的 Job。

### 8. 🟡 如何实现平滑缩容？什么是 PDB（PodDisruptionBudget）？

- 直接调低 replicas 会瞬间杀掉 Pod，流量可能打向还在销毁中的实例。
- **PDB**：声明"最少允许多少/最大允许多少不可用"，配合优雅终止（readiness 摘流 + preStop + 宽限期）实现平滑。
- 场景：节点维护 drain、滚动更新、主动缩容时保护关键服务不中断。
- 追问：PDB 能阻止节点宕机吗？——不能，PDB 只约束**自愿中断**（主动维护/更新），非自愿中断（节点故障）不受 PDB 保护。

### 9. 🟡 DaemonSet 的典型使用场景？

- 每个节点必须有且只有一个副本，新节点加入自动部署。
- 场景：日志采集（Fluentd/Filebeat）、监控 Agent（Node Exporter）、网络插件（Calico）、存储插件（CSI）。
- 追问：DaemonSet 和 Deployment 副本数的差异？——DS 副本数由节点数决定，不可手动调；DS 更新也支持滚动。

## 三、网络与服务发现

### 10. 🔴 Service 的完整工作链路？kube-proxy 如何转发？

1. Service 通过 selector 匹配 Pod，ControllerManager 维护 EndpointSlice 列表。
2. kube-proxy 监听 Service + EndpointSlice，在每台节点生成转发规则（iptables/ipvs）。
3. 客户端访问 Service VIP 时按规则转发到后端 Pod，并对 Pod IP 做 SNAT 回包。
- 追问：直接访问 Pod IP 和访问 Service 的区别？——Pod IP 会随重启变化且无负载均衡；Service VIP 稳定 + 自动负载均衡 + 健康摘除。

### 11. 🟡 Headless Service 是什么？什么场景用？

- `clusterIP: None` 的 Service，不分配 VIP，DNS 直接返回后端 Pod IP 列表。
- 场景：StatefulSet 需要稳定域名逐个访问（如 `web-0.mysql.svc.cluster.local`）、客户端自行负载均衡（如 Kafka）。
- 追问：Headless 还做负载均衡吗？——不做，由客户端/应用自己从 DNS 结果里选，或依赖 StatefulSet 的固定网络标识。

### 12. 🟡 集群内部服务发现有哪几种方式？

- **DNS**：CoreDNS 解析 `服务名.命名空间.svc.cluster.local`，推荐方式。
- **环境变量**：Service 创建后注入 Pod 的 `*_SERVICE_HOST/PORT`，但**只对创建之后的 Pod 生效**，有顺序依赖。
- 追问：为什么优先 DNS？——环境变量有创建顺序限制且不够动态，DNS 无顺序依赖、支持动态更新。

### 13. 🟢 一个外部请求从 Ingress 到 Pod 的完整路径？

客户端 → DNS → Ingress Controller（Nginx/Istio，NodePort 或 LB 暴露）→ 七层路由 → Service（ClusterIP）→ kube-proxy 规则 → 后端 Pod → 容器内应用。
- 追问：Ingress Controller 和 Ingress 资源什么关系？——Ingress 是规则声明，Controller 才是真正干活的进程；没有 Controller，Ingress 规则不生效。

### 14. 🟡 Flannel 和 Calico 网络实现区别？

| 维度 | Flannel | Calico |
| :--- | :--- | :--- |
| 模型 | Overlay（VXLAN 隧道封装） | BGP 三层路由直连 |
| 性能 | 封装开销，一般 | 不封装，性能高 |
| NetworkPolicy | 不支持 | 原生支持 |
| 适用 | 测试 / 简单环境 | 生产、需网络策略 |

## 四、存储持久化深入

### 15. 🔴 PV、PVC、StorageClass 三者的完整工作流程？

1. 管理员建 PV（静态）或建 StorageClass（动态）。
2. 用户提交 PVC 声明容量 + 访问模式。
3. 动态供应：StorageClass 的 Provisioner 调用云存储/存储集群 API 创建实际存储，并自动生成 PV。
4. PV 与 PVC 匹配绑定后，Pod 通过 PVC 挂载使用。
- 追问：PVC 匹配 PV 的条件？——容量满足、访问模式匹配、StorageClass 相同（动态供应）。

### 16. 🟡 PV 访问模式有哪些？怎么选？

- `ReadWriteOnce`（RWO）：单节点读写，块存储默认。
- `ReadOnlyMany`（ROX）：多节点只读。
- `ReadWriteMany`（RWX）：多节点读写，需 NFS/CephFS 等共享文件系统。
- 追问：本地盘 PV 和共享存储 PV 怎么选？——本地盘性能高但节点故障数据无法漂移；共享存储牺牲一点性能换取高可用，生产有状态服务优先共享存储。

### 17. 🟡 PV 的回收策略？Recycle / Delete / Retain？

- `Delete`：PVC 删除时底层存储一并删除（动态供应默认，安全）。
- `Retain`：PVC 删除后数据保留，由管理员手工处理（适合有备份需求的场景）。
- `Recycle`：清理数据后重用，已基本废弃。
- 追问：PVC 删除了但 PV 还是 Released 状态？——这是 Retain 策略的正常表现，需管理员手动清理后再复用。

## 五、调度与弹性

### 18. 🔴 kube-scheduler 完整调度过程？

1. **过滤（Filter/Predicate）**：剔除不满足硬性条件的节点（资源不足、端口冲突、污点不匹配、节点选择器不符）。
2. **打分（Score/Priority）**：对剩余节点按资源均衡、亲和性等打分。
3. **绑定（Bind）**：选最高分节点，写入绑定关系，通知 kubelet 创建。
- 追问：调度和"资源分配"是一回事吗？——调度只是选节点，真正创建容器、设置 cgroup 限额由 kubelet 完成；若 Pod 内存超 limits 会被 OOM Kill，与调度无关。

### 19. 🟡 怎么保证多副本 Pod 不落在同一节点？怎么尽量靠近？

- **Pod 反亲和性（requiredDuringScheduling）**：强制不同副本分散到不同节点，提高可用性。
- **Pod 亲和性（preferred）**：让相关 Pod 尽量同节点/同可用区，减少网络延迟。
- 追问：required 和 preferred 的区别？——required 是硬性条件，无满足节点则 Pod 无法调度；preferred 是软偏好，没有满足节点也能调度。

### 20. 🟡 节点维护（升级/维修）的操作流程？

1. `kubectl cordon <节点>`：标记不可调度，新 Pod 不再上来。
2. `kubectl drain <节点> --ignore-daemonsets`：驱逐存量 Pod（受 PDB 约束），DaemonSet 保留。
3. 维护完成后 `kubectl uncordon <节点>`：恢复调度。
- 追问：为什么 drain 要带 `--ignore-daemonsets`？——DaemonSet 在每个节点必须有副本，驱逐也没意义，直接跳过。

### 21. 🟡 requests / limits 设置不当会有什么后果？

- 只设 limits 不设 requests：调度器按 0 请求算，可能超卖严重、节点 Pod 堆积。
- requests 设过大：节点资源利用率低、Pod 调度失败。
- limits 设过小：进程容易被 OOM Kill（内存）或被 CPU 限流。
- 生产建议：**requests 按业务稳态值设，limits 按峰值设**，并配合 HPA 与监控核对实际使用。

## 六、安全与权限

### 22. 🔴 RBAC 三要素是什么？如何做到最小权限？

- 三要素：**Role（权限集）+ Subject（主体）+ RoleBinding（绑定）**。
- 最小权限原则：能用 Role 不用 ClusterRole，能限命名空间就限命名空间，只授业务所需资源与动作。
- 追问：Role 和 ClusterRole 区别？——Role 限定单个命名空间；ClusterRole 全集群生效，可授予跨命名空间资源或非资源（如 nodes）。

### 23. 🟡 ServiceAccount 的作用？Pod 怎么使用？

- ServiceAccount 给 Pod 内的进程提供访问 apiserver 的身份。
- Pod 声明 `serviceAccountName`，K8s 自动把该 SA 的 Token 挂载到 `/var/run/secrets/kubernetes.io/serviceaccount/`。
- 每个命名空间默认有 `default` SA，但生产建议按应用建专用 SA + 最小权限。
- 追问：SA 和 User 的区别？——SA 是集群内资源、面向 Pod；User 是外部身份（证书/Token），不存于集群，靠 apiserver 认证插件识别。

### 24. 🟡 私有仓库的镜像怎么拉取？

- 创建 `docker-registry` 类型的 Secret 存认证信息：`kubectl create secret docker-registry regcred ...`。
- 两种引用方式：Pod 指定 `imagePullSecrets`，或给 ServiceAccount 绑定后自动使用。
- 追问：镜像拉取失败（ImagePullBackOff）排查顺序？——`kubectl describe pod` 看事件 → 确认镜像名/标签 → 确认 Secret 存在且被引用 → 节点上能否手动 pull。

### 25. 🟢 Secret 如何保证安全？只靠 base64 可以吗？

- base64 只是编码不是加密，`kubectl get secret -o yaml` 能直接看到明文。
- 生产加固：**etcd 开启静态加密（KMS）** + RBAC 最小权限 + 不把 Secret 写入镜像/代码仓库。
- 追问：KMS 静态加密什么原理？——apiserver 用 KMS 加密后再写入 etcd，读取时解密，密钥由外部 KMS 托管，即使 etcd 数据泄露也是密文。

## 七、排障实战综合

### 26. 🔴 Pod 一直 Pending 的排查思路？

1. `kubectl describe pod <name>` 看 Events 具体报错。
2. 资源不足？看节点 `kubectl describe node` 的可分配资源。
3. 调度不满足？检查 nodeSelector、亲和性、污点容忍。
4. PVC 未绑定 / StorageClass 异常？
5. 镜像不存在或仓库鉴权失败？
- 追问：Pending 和 ContainerCreating 的区别？——Pending 是还没调度/还没开始拉镜像；ContainerCreating 已调度，卡在拉镜像、挂卷或创建容器阶段。

### 27. 🔴 CrashLoopBackOff 怎么排查？

1. 看事件：`kubectl describe pod`。
2. 看崩溃前的日志：`kubectl logs <pod> --previous`。
3. 看启动命令和探针：应用是否启动即退出、liveness 探针是否误杀。
4. 资源 / 权限 / 配置 / 依赖服务是否正常。
- 追问：怎么区分"探针失败"和"应用崩溃"？——探针失败是 Ready 为 False 但不一定重启（readiness），liveness 失败才重启；看 describe 事件中的 `Liveness probe failed` / `Killing container` 关键字。

### 28. 🟡 节点 NotReady 排查步骤？

1. 节点上 `systemctl status kubelet`，看 kubelet 日志。
2. 资源是否耗尽：磁盘满、inode 满、内存不足、PID 耗尽。
3. 网络是否正常：节点与 apiserver 连通、kubelet 证书是否过期。
4. 容器运行时（containerd/docker）是否异常。
- 追问：节点 NotReady 但业务还在跑？——Pod 会继续运行但调度器不调度新 Pod；若节点长时间失联，控制器会按 pod-eviction-timeout 驱逐重建 Pod。

### 29. 🟡 Service 访问不通的完整排查？

1. `kubectl get endpoints`：Endpoint 是否就绪。
2. 直连 Pod IP 验证应用本身正常。
3. 检查 Service selector、端口、协议是否匹配。
4. 检查 kube-proxy 与 ipvs/iptables 规则。
5. 检查 NetworkPolicy、节点防火墙。
- 追问：ClusterIP 能 ping 通吗？——通常 ping 不通，ClusterIP 是虚拟 IP 由 kube-proxy 规则处理，并非真实网卡，ICMP 可能被丢弃；测连通要用 `curl` 业务端口。

### 30. 🟡 集群整体失联 / apiserver 响应慢排查？

1. 先看 apiserver 自身负载与 etcd 健康：`etcdctl endpoint health`。
2. etcd 磁盘延迟、空间、Leader 是否频繁切换（抖动）。
3. apiserver 日志有无大量超时/资源不足。
4. 是否被大量 List/Watch 请求打爆（注意全量 List 的 Controller）。
5. 网络层：节点到 apiserver LB 连通性。
- 追问：etcd 慢会有什么表现？——所有写操作变慢，Pod 创建/删除卡住，调度延迟，最终 apiserver 报 etcd 超时。

## 八、生产运维与高可用

### 31. 🔴 生产集群高可用方案要点？

- 控制面：3/5 奇数 Master + apiserver 前置 LB + etcd 集群多数派。
- 数据面：业务多副本 + 反亲和分散 + PDB 保护。
- 关键：etcd 高可用是根，apiserver 无状态可横向扩，组件全部多副本。
- 追问：单 Master 行不行？——测试可以，生产不可；Master 单点故障会导致集群不可管理（虽然已运行 Pod 还能跑）。

### 32. 🟡 集群升级的基本流程？

1. 备份 etcd：`etcdctl snapshot save`。
2. 先升级控制面（Master 逐个）：`kubeadm upgrade plan` → `kubeadm upgrade apply`。
3. 再升级工作节点（逐个 drain → 升级 kubeadm/kubelet → uncordon）。
4. 升级期间监控关键组件健康，预留回滚方案。
- 追问：为什么先升级控制面？——控制面提供 API 能力，升级后兼容旧 kubelet 一段时间；先升数据面会失去管理能力风险更大。

### 33. 🟡 etcd 备份与恢复的关键点？

- 备份：`etcdctl snapshot save snapshot.db`（需带证书参数），定时 + 异地保存。
- 恢复：停止 apiserver → 用 `etcdctl snapshot restore` 在每台节点恢复 → 重启 etcd → 验证。
- 注意：**恢复是整个集群一致恢复到某个时间点**，会丢失之后的数据，恢复前必须确认。
- 追问：只备份 PV 不备份 etcd 行不行？——不行，etcd 存的是资源元数据与期望状态，丢了集群"管理信息"全无，PV 数据也可能失去挂载关系。

### 34. 🟢 常见的 K8s 可观测性组件？

- 指标：Prometheus + Grafana + Metrics Server。
- 日志：EFK/Elasticsearch + Fluentd + Kibana，或 Loki + Promtail。
- 链路：Jaeger / Tempo（OpenTelemetry）。
- 事件：`kubectl get events` + 事件持久化（如 EventRouter）。
- 追问：Pod 内存持续上涨怎么定位？——看监控趋势 + 进容器 top + 分析应用堆内存/缓存，结合 OOMKilled 事件判断是否超 limits。

### 35. 🟢 多集群 / 多云管理常见方案？

- 工具：Rancher、KubeSphere、ArgoCD（GitOps 多集群）、Karmada。
- 思路：每个集群独立管理 + 统一入口；联邦（Federation）已逐步被 GitOps 多集群方案取代。
- 追问：什么时候需要多集群？——跨地域容灾、业务隔离（开发/生产）、多云避免绑定、超大规模分片。

> **速记口诀**：声明式不命令式，apiserver 唯一入口；etcd 多数派奇数稳，scheduler 先过滤再打分；Pod 共享网络靠 pause，Service 四层 Ingress 七层；滚动更新看 surge 和 unavailable，多副本分散靠反亲和；维护节点先 cordon 再 drain，升级先控制面再数据面。