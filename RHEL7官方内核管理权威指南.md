# Red Hat Enterprise Linux 7 官方内核管理权威指南



# 一、实战高频必用（90% 运维场景）

## 1. 内核模块管理（天天用）

- **查模块**：`lsmod`（看已加载）、`modinfo 模块名`（看详情）
- **加载 / 卸载**：`modprobe 模块名`（自动解依赖）、`modprobe -r 模块名`（安全卸载）
- **开机自动加载**：`echo "模块名" > /etc/modules-load.d/xxx.conf`
- **禁用模块**：`/etc/modprobe.d/blacklist.conf` 加 `blacklist 模块名` + `install 模块名 /bin/false`，然后 `dracut -f` 重建镜像

## 2. sysctl 内核调优（必配）

- **临时改**：`sysctl -w 参数=值`（重启失效）

- **永久改**：写 `/etc/sysctl.d/99-custom.conf`，执行 `sysctl -p` 生效

- 生产必配 5 个参数
  
  ini
  
  ```ini
  net.core.somaxconn=65535        # TCP全连接队列
  net.ipv4.tcp_max_syn_backlog=65535  # 半连接队列
  vm.swappiness=1                 # 尽量不用swap
  kernel.panic=10                 # 内核崩溃10秒自动重启
  fs.file-max=655350              # 最大文件句柄数
  ```

## 3. 内核升级与管理（核心技能）

- **安全升级**：`rpm -ivh 新内核.rpm`（**绝对不能用 - U**，会覆盖当前内核）
- **设置默认启动**：`grub2-set-default 0` + `grub2-mkconfig -o /boot/grub2/grub.cfg`
- **清理旧内核**：`package-cleanup --oldkernels --count=3`（保留最近 3 个，防 /boot 满）
- **回滚**：开机 GRUB 选 "Previous Linux versions" 进旧内核

## 4. kdump 崩溃转储（生产必开）

- **安装**：`yum install kexec-tools`
- **配置**：`/etc/default/grub` 加 `crashkernel=auto`，重建 GRUB
- **启动**：`systemctl enable --now kdump`
- **测试**：`echo 1 > /proc/sys/kernel/sysrq && echo c > /proc/sysrq-trigger`（仅测试用）
- **查转储**：`/var/crash/` 目录下生成带时间戳的 vmcore 文件

## 5. kpatch 实时补丁（加分项）

- **装补丁**：`yum install "kpatch-patch = $(uname -r)"`
- **看补丁**：`kpatch list`
- **更补丁**：`yum update "kpatch-patch = $(uname -r)"`
- **核心优势**：不重启系统打安全补丁

------

# 二、面试高频问题（分基础 / 进阶）

## 基础必背题

1. **为什么内核升级用 `rpm -ivh` 不用 `rpm -U`？**
   
   答：`ivh` 保留所有旧内核，新内核崩了能回滚；`-U` 直接覆盖当前内核，失败系统直接无法启动。

2. **sysctl 临时修改和永久修改的区别？**
   
   答：临时改内存，重启失效；永久改 `/etc/sysctl.d/` 配置文件，重启不丢。

3. **kdump 是干什么的？工作原理是什么？**
   
   答：内核崩溃时抓内存转储，用来查崩溃原因。原理：系统预留一小块内存给第二个 "捕获内核"，崩溃时不重启直接加载它，把原内核的内存存成 vmcore 文件。

4. **怎么清理旧内核？为什么要清理？**
   
   答：用 `package-cleanup --oldkernels --count=3`。不清理会导致 `/boot` 分区满，新内核装不上，系统无法升级。

5. **modprobe 和 insmod 有什么区别？**
   
   答：`modprobe` 自动解决模块依赖；`insmod` 只能手动加载单个 ko 文件，依赖要自己装，生产不用。

## 进阶加分题

1. **kpatch 和普通内核升级有什么区别？**
   
   答：kpatch 不重启系统，只打单个补丁，不改变内核版本；普通升级要重启，替换整个内核。

2. **什么是 DAX？有什么用？**
   
   答：直接访问文件系统，绕过内核页缓存，让应用直接读写持久内存（NVDIMM），性能接近原生内存。

3. **内核模块黑名单里 `blacklist` 和 `install /bin/false` 有什么区别？**
   
   答：`blacklist` 只是不让自动加载，手动还能装；`install /bin/false` 彻底禁用，手动也装不了。

4. **kdump 生成的 vmcore 太大怎么办？**
   
   答：用 `makedumpfile -d 31` 过滤零页、缓存页、空闲页等无用数据，能压缩到原大小的 10% 以下。

5. **IMA 和 EVM 有什么区别？**
   
   答：IMA 保护文件内容，算哈希对比；EVM 保护文件的扩展属性（比如 IMA 的哈希值），防止攻击者改属性绕过检查。

# 内核参数 + 内核特性 生产实战全解（容器核心版）

------

# 第一部分：内核参数（sysctl）生产详解

## 一、参数管理基础（必背）

```
# 查看所有参数
sysctl -a

# 临时修改（重启失效）
sysctl -w net.core.somaxconn=65535

# 永久修改（生产标准）
vim /etc/sysctl.d/99-production.conf  # 不要改/etc/sysctl.conf
sysctl -p /etc/sysctl.d/99-production.conf  # 立即生效
```

**生产原则**：

- 所有自定义参数统一放在`/etc/sysctl.d/99-xxx.conf`，方便管理和回滚
- 先临时测试，没问题再写永久配置
- 同一集群所有节点参数保持一致

------

## 二、核心参数分类详解（生产必调）

### 1. 网络参数（最重要，高并发 + 容器网络）

| 参数                                    | 生产推荐值      | 作用               | 容器场景                                |
|:------------------------------------- |:---------- |:---------------- |:----------------------------------- |
| `net.core.somaxconn`                  | 65535      | TCP 全连接队列最大长度    | 解决容器服务 "连接被拒绝"，Nginx/Redis/MySQL 必调 |
| `net.ipv4.tcp_max_syn_backlog`        | 65535      | TCP 半连接队列最大长度    | 防 SYN 洪水攻击，高并发 Web 服务必调             |
| `net.ipv4.ip_local_port_range`        | 1024 65535 | 本地端口范围           | 容器大量出站连接时，避免端口耗尽                    |
| `net.ipv4.tcp_fin_timeout`            | 30         | TIME_WAIT 连接超时时间 | 减少容器服务器 TIME_WAIT 堆积                |
| `net.ipv4.tcp_max_tw_buckets`         | 100000     | 最大 TIME_WAIT 连接数 | 防止服务器被 TIME_WAIT 占满端口               |
| `net.ipv4.tcp_syncookies`             | 1          | 开启 SYN Cookie    | 防 DDoS 攻击，所有服务器必开                   |
| `net.ipv4.ip_forward`                 | 1          | 开启 IP 转发         | **容器 / 网关服务器必须开**，否则容器无法上网          |
| `net.bridge.bridge-nf-call-iptables`  | 1          | 网桥流量经过 iptables  | Docker/K8s 网络必开，否则 Service 不通       |
| `net.bridge.bridge-nf-call-ip6tables` | 1          | 网桥流量经过 ip6tables | 同上，IPv6 环境                          |

### 2. 内存参数（容器内存管理 + OOM）

| 参数                          | 生产推荐值  | 作用                | 容器场景                                |
|:--------------------------- |:------ |:----------------- |:----------------------------------- |
| `vm.swappiness`             | 1      | 尽量不使用 Swap        | **容器服务器必须设为 1**，防止容器内存被换出导致性能暴跌     |
| `vm.dirty_ratio`            | 10     | 脏页占内存 10% 时开始后台刷盘 | 避免突然大量 IO 导致容器卡顿                    |
| `vm.dirty_background_ratio` | 5      | 脏页占内存 5% 时开始后台刷盘  | 同上，平滑 IO 压力                         |
| `vm.max_map_count`          | 262144 | 进程最大内存映射数         | **Elasticsearch/Redis 容器必调**，否则启动失败 |
| `vm.overcommit_memory`      | 1      | 允许内存超分配           | 容器环境推荐设为 1，充分利用内存资源                 |
| `vm.panic_on_oom`           | 0      | OOM 时不 panic 内核   | 容器环境必须设为 0，只杀死 OOM 进程，不重启整个节点       |

### 3. 文件系统参数

| 参数                              | 生产推荐值   | 作用                 | 容器场景                              |
|:------------------------------- |:------- |:------------------ |:--------------------------------- |
| `fs.file-max`                   | 655350  | 系统最大文件句柄数          | 高并发服务器必调，防止 "Too many open files" |
| `fs.inotify.max_user_instances` | 8192    | 每个用户最大 inotify 实例数 | **K8s 节点必调**，否则容器无法创建 inotify 监控  |
| `fs.inotify.max_user_watches`   | 1048576 | 每个用户最大 inotify 监控数 | 同上，ConfigMap/Secret 热更新依赖         |
| `fs.aio-max-nr`                 | 1048576 | 最大异步 IO 请求数        | MySQL/PostgreSQL 容器必调，提升数据库性能     |

### 4. 内核安全参数

| 参数                      | 生产推荐值 | 作用                   |               |
|:----------------------- |:----- |:-------------------- |:------------- |
| `kernel.panic`          | 10    | 内核崩溃后 10 秒自动重启       | 生产服务器必开，快速恢复  |
| `kernel.panic_on_oops`  | 1     | 内核 Oops 时自动 panic 重启 | 防止系统挂死        |
| `kernel.sysrq`          | 1     | 开启 SysRq 魔术键         | 紧急情况下可以安全重启系统 |
| `kernel.dmesg_restrict` | 1     | 禁止非 root 用户查看 dmesg  | 安全加固，防止信息泄露   |
| `kernel.kptr_restrict`  | 2     | 隐藏内核指针地址             | 防漏洞利用         |

------

## 三、生产环境内核参数模板（直接复制用）

```ini
# /etc/sysctl.d/99-production.conf
# 网络参数
net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_max_tw_buckets = 100000
net.ipv4.tcp_syncookies = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1

# 内存参数
vm.swappiness = 1
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5
vm.max_map_count = 262144
vm.overcommit_memory = 1
vm.panic_on_oom = 0

# 文件系统参数
fs.file-max = 655350
fs.inotify.max_user_instances = 8192
fs.inotify.max_user_watches = 10ini48576
fs.aio-max-nr = 1048576

# 内核安全参数
kernel.panic = 10
kernel.panic_on_oops = 1
kernel.sysrq = 1
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
```

**批量部署方法**：用 Ansible 把这个文件推送到所有服务器，然后执行`sysctl -p`生效。

------

# 第二部分：容器核心内核特性详解

**容器 = 内核特性的组合**，没有这些内核特性就没有 Docker/K8s。

------

## 一、容器两大基石：Namespaces + Cgroups

### 1. Namespaces（命名空间）：资源隔离

**作用**：让进程只能看到自己命名空间内的资源，实现 "隔离"。

**6 大核心命名空间（容器都在用）**：

| 命名空间           | 隔离资源    | 容器中的作用                        |
|:-------------- |:------- |:----------------------------- |
| PID Namespace  | 进程 ID   | 容器内看不到宿主机和其他容器的进程             |
| NET Namespace  | 网络栈     | 每个容器有自己的 IP、端口、路由表            |
| MNT Namespace  | 文件系统挂载点 | 容器有自己的根文件系统，看不到宿主机的磁盘         |
| UTS Namespace  | 主机名和域名  | 容器可以有自己的主机名                   |
| IPC Namespace  | 进程间通信   | 容器内的进程只能和同容器内的进程通信            |
| USER Namespace | 用户和组 ID | 容器内的 root 用户映射到宿主机的普通用户（安全加固） |

**生产实战用法**：

```
# 进入容器的所有命名空间（排查问题神器）
nsenter -t <容器PID> -m -u -i -n -p /bin/bash

# 只进入容器的网络命名空间（排查网络问题）
nsenter -t <容器PID> -n /bin/bash
```

### 2. Cgroups（控制组）：资源限制

**作用**：限制进程组对 CPU、内存、IO 等资源的使用，实现 "配额"。

**RHEL7 默认使用 Cgroups v1**，核心子系统：

| 子系统     | 限制资源     | 容器中的作用                                  |
|:------- |:-------- |:--------------------------------------- |
| cpu     | CPU 时间   | 限制容器最多使用多少 CPU（如 --cpus=2）              |
| cpuacct | CPU 使用统计 | 统计容器 CPU 使用率                            |
| memory  | 内存使用     | 限制容器最多使用多少内存（如 --memory=1G），超过会被 OOM 杀死 |
| blkio   | 块设备 IO   | 限制容器磁盘读写速度                              |
| devices | 设备访问     | 控制容器可以访问哪些硬件设备                          |

**生产实战用法**：

```bash
# 启动一个限制2核CPU、4G内存的容器
docker run -d --cpus=2 --memory=4g nginx

# 查看容器的Cgroup配置
cat /sys/fs/cgroup/memory/docker/<容器ID>/memory.limit_in_bytes
```

**生产注意事项**：

- 所有生产容器必须设置 CPU 和内存限制，防止单个容器占满整个节点资源
- 内存限制不要设得太满，留 10% 左右的缓冲
- 不要依赖 OOM 杀死进程，提前做好资源规划

------

## 二、容器存储核心：Overlay2 文件系统

**作用**：Docker/K8s 默认的联合文件系统，实现镜像分层和容器写时复制（COW）。

**RHEL7 支持情况**：

- RHEL7.2 及以上版本支持 Overlay2
- 生产环境必须使用 Overlay2，不要用旧的 Aufs 或 Devicemapper

**生产配置**：

```json
# Docker配置Overlay2（/etc/docker/daemon.json）
{
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
```

**生产注意事项**：

- Overlay2 需要 ext4 或 xfs 文件系统，且 xfs 需要开启`d_type`支持
- 不要在 Overlay2 上运行数据库，性能差且容易损坏数据，数据库用数据卷挂载宿主机磁盘

------

## 三、容器安全核心：Capabilities + Seccomp

### 1. Capabilities（能力）

**作用**：把 root 用户的超级权限拆分成多个独立的能力，容器可以只保留必要的能力，删除不必要的权限。

**生产实战**：

```
# 启动容器时删除所有能力，只添加必要的
docker run -d --cap-drop=ALL --cap-add=NET_BIND_SERVICE nginx
```

**常用能力**：

- `NET_BIND_SERVICE`：允许绑定 1024 以下的端口（Nginx 需要）
- `CHOWN`：允许修改文件所有者
- `DAC_OVERRIDE`：允许绕过文件权限检查

### 2. Seccomp（安全计算模式）

**作用**：过滤进程的系统调用，只允许容器调用必要的系统调用，防止漏洞利用。

**生产实战**：

- Docker 默认启用 Seccomp，使用默认的白名单配置
- 特殊容器可以用`--security-opt seccomp=unconfined`禁用（不推荐）

**Seccomp 和 Capabilities 的区别？**

| 特性  | Capabilities        | Seccomp              |
| --- | ------------------- | -------------------- |
| 作用  | 拆分 root 权限，控制进程能做什么 | 过滤系统调用，控制进程能调用哪些内核函数 |
| 粒度  | 粗粒度（按能力分组）          | 细粒度（单个系统调用）          |
| 层级  | 用户空间权限              | 内核空间权限               |
| 关系  | 互补关系，通常一起使用         | 互补关系，通常一起使用          |

------

## 四、高性能容器：DAX + 持久内存

**作用**：结合之前讲的 DAX 特性，让容器直接访问持久内存（NVDIMM），获得接近内存的性能。

**生产场景**：

- Redis 容器：把数据放在 DAX 分区，实现内存级速度 + 持久化
- 数据库容器：把 WAL 日志放在 DAX 分区，大幅提升写入性能

**RHEL7 配置**：

1. 格式化 NVDIMM 为 xfs 并挂载`-o dax`
2. 启动容器时挂载 DAX 分区：`docker run -v /mnt/pmem0:/data nginx`

------

## 五、其他重要内核特性

1. **KASLR（内核地址空间随机化）**：默认开启，随机化内核地址，防止缓冲区溢出攻击
2. **AER（高级错误报告）**：PCIe 设备错误监控，及时发现硬件故障
3. **Transparent Huge Pages（THP）**：透明大页，提升内存访问性能，但数据库容器建议关闭（会导致性能波动）

------

# 第三部分：面试高频考点总结

## 内核参数相关

1. **为什么容器服务器要把`vm.swappiness`设为 1？**
   
   答：防止容器内存被换出到 Swap，导致性能暴跌。设为 1 表示只有当内存几乎用完时才使用 Swap。

2. **`net.ipv4.ip_forward`为什么容器服务器必须开启？**
   
   答：容器的网络流量需要经过宿主机转发，不开启的话容器无法访问外部网络，外部也无法访问容器。

3. **`fs.inotify.max_user_watches`为什么 K8s 节点必须调大？**
   
   答：K8s 的 ConfigMap 和 Secret 热更新依赖 inotify 监控，默认值太小会导致容器无法创建足够的监控，热更新失败。

## 容器内核特性相关

1. **容器和虚拟机的本质区别是什么？**
   
   答：虚拟机是硬件级虚拟化，有自己的完整操作系统；容器是内核级虚拟化，共享宿主机内核，通过 Namespaces 隔离资源，通过 Cgroups 限制资源。

2. **Namespaces 和 Cgroups 的区别是什么？**
   
   答：Namespaces 解决 "隔离" 问题，让进程看不到其他资源；Cgroups 解决 "限制" 问题，控制进程能使用多少资源。

3. **Overlay2 的写时复制（COW）是什么意思？**
   
   答：镜像层是只读的，当容器修改文件时，会把文件从镜像层复制到容器的可写层，然后修改可写层的文件，镜像层保持不变。这样多个容器可以共享同一个镜像层，节省磁盘空间。

4. **Capabilities 和 Seccomp 的区别是什么？**
   
   答：Capabilities 是拆分 root 用户的权限，控制进程能做什么；Seccomp 是过滤系统调用，控制进程能调用哪些内核函数。两者都是容器安全加固的重要手段。

------

# 一句话总结

- **内核参数**：调优系统性能、解决容器常见问题、安全加固
- **内核特性**：容器技术的底层基础，Namespaces 隔离、Cgroups 限制、Overlay2 存储、Capabilities+Seccomp 安全

参考redhat 官网文档

https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/7/html-single/kernel_administration_guide/index#working_with_sysctl_and_kernel_tunables