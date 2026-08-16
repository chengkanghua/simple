# 个人简历

## 基本信息

- **姓名**：张三（请替换为真实姓名）
- **求职意向**：Linux 运维工程师 / 高级运维工程师 / 云原生运维工程师
- **工作年限**：8 年
- **联系电话**：138-xxxx-xxxx（请替换）
- **邮箱**：xxx@xxx.com（请替换）
- **所在城市**：北京（请替换）
- **期望薪资**：面议

---

## 个人简介

8 年 Linux 系统运维与数据库运维经验，主导过 50～1000 台规模服务器集群的规划、部署与运维体系建设。精通 CentOS/RHEL 体系下的系统调优、Shell 自动化、MySQL 高可用与备份恢复、Nginx 反向代理与负载均衡、Keepalived 高可用、Ansible 批量运维、Zabbix/Prometheus 监控告警，以及 Docker/Kubernetes 云原生运维。具备从 0 到 1 搭建标准化运维体系的能力，多次主导线上故障定位与容灾演练，保障核心业务 99.95%+ 可用性。

---

## 专业技能

### 系统与基础运维
- 精通 Linux（CentOS 6/7、RHEL）系统管理：启动流程（BIOS/UEFI、GRUB、systemd）、用户权限（sudo、ACL、SUID/SGID）、文件系统（ext4/xfs、inode/block、软硬链接、LVM、RAID）。
- 熟练使用三剑客 `grep/sed/awk` 进行日志分析与文本处理；精通 `ps/top/htop/vmstat/iostat/sar/strace/tcpdump` 等性能排查工具。
- 熟悉磁盘管理（fdisk/parted、mount 开机自动挂载、swap）、进程管理、cron 定时任务、内核参数调优。
- 具备 PXE + Kickstart / Cobbler 自动化装机的实战经验。

### 服务器硬件与 IDC 运维
- 熟悉服务器各核心硬件组成与选型：CPU（Intel/AMD 型号、核数、超线程、NUMA 架构）、内存（ECC/REG ECC、通道数与频率）、硬盘（SATA/SAS/SSD/NVMe 差异与适用场景）、主板（芯片组、PCIe 通道、扩展槽）、电源（冗余电源、功率匹配）、网卡（千兆/万兆、光口/电口）及散热风道设计，能根据业务负载（计算型/存储型/IO 型）选型配置。
- 具备服务器整机组装与部署能力：从散件（机箱、主板、CPU、内存、硬盘、电源、风扇）独立完成硬件装配、跳线连接、最小化测试（POST）、固件（BIOS/BMC）升级与初始化；熟练配置 BIOS 启动项、开启 VT-x/VT-d、NUMA 与 ACPI 电源策略。
- 熟练机房上架全流程：机柜 U 位规划与承重评估、导轨/滑道安装、设备固定、强弱电分离布线、网线/光纤标签规范化、PDU 取电与双路供电接入、KVM/IPMI（iDRAC/iLO）带外管理配置与远程 console 接入，支持无显示器情况下的远程装机与排障。
- 熟悉 RAID 卡基础应用：了解常见阵列卡（HBA/带缓存 RAID 卡、BBU/CacheVault 电池保护）与 RAID 0/1/5/10 级别特点，能在卡层面创建/重建阵列、定位与更换故障硬盘。
- 具备硬件故障定位与处理能力：通过 BMC/IPMI 日志、SMART、EDAC 等定位内存/硬盘/风扇/电源故障，完成热插拔更换与冗余切换验证，配合机房完成网络设备上下架与割接。

### 网络与安全
- 理解 TCP/IP 协议栈、HTTP/HTTPS 原理、子网划分、路由基础；熟练排查端口不通、TIME_WAIT 过多、连接泄漏等网络问题。
- 熟练配置 `iptables`/`firewalld` 防火墙规则、SSH 安全加固（密钥登录、改端口、fail2ban）、SELinux 基础与系统加固。

### Web 与高可用架构
- 精通 Nginx：虚拟主机、反向代理、负载均衡（轮询/权重/ip_hash）、动静分离、HTTPS、rewrite、日志切割与性能调优。
- 熟悉 LNMP 架构部署与调优；掌握 Keepalived + LVS（DR/NAT 模式）高可用与负载均衡方案，能处理脑裂等典型问题。
- 熟悉 Tomcat 多实例部署、JVM 参数与日志分析。

### 数据库与缓存运维（MySQL / Redis）
- 精通 MySQL 5.6/5.7 安装部署（二进制/源码）、体系结构、存储引擎（InnoDB）、事务与锁、MVCC、隔离级别。
- 熟练 MySQL 备份恢复：`mysqldump` + binlog 时间点恢复（PITR）、`XtraBackup` 全量/增量备份与恢复演练。
- 掌握 MySQL 主从复制、GTID 复制、半同步复制、延时从库、主从延时排查；具备 MHA 高可用故障切换实战经验。
- 熟悉 MySQL 优化：索引设计、`EXPLAIN`、慢查询分析、`Buffer Pool` 调优、生产参数（`innodb_flush_log_at_trx_commit`、`sync_binlog`、`binlog_format=ROW`、独立表空间）。
- 熟悉 Redis：RDB/AOF 持久化、主从复制、哨兵（Sentinel）、Cluster 集群、缓存穿透/击穿/雪崩应对。

### 自动化运维
- 精通 Shell 脚本编程，能独立编写系统巡检、数据备份、日志清理、批量建用户、MySQL 分库分表备份、DOS 攻击日志分析等企业级脚本。
- 熟练 Ansible：常用模块（command/shell/copy/file/yum/service/cron）、playbook、role 封装，实现批量部署与配置管理。
- 熟悉 Git 版本控制与 GitLab；熟练 Jenkins Pipeline 实现 CI/CD 一键发布与回滚。

### 监控与故障排障
- 熟练 Zabbix：自定义监控项、触发器、告警模板、自动发现/注册、分布式监控。
- 熟悉 Prometheus + Grafana + Alertmanager 云原生监控体系，掌握 exporter 采集与 PromQL。
- 熟悉 ELK 日志分析栈；建立过 CPU/内存/磁盘 IO/网络四维性能排障体系。

### 云计算与云原生
- 熟练 Docker：镜像构建（Dockerfile 优化、多阶段构建）、容器网络与存储、Harbor 私有仓库。
- 熟练 Kubernetes：kubeadm 搭建集群、Pod/Deployment/Service/Ingress/ConfigMap/Secret/StatefulSet 等核心资源、弹性伸缩、持久化存储（PV/PVC）、dashboard、集群监控与日志收集。
- 熟悉阿里云/腾讯云核心产品（ECS、SLB、OSS、RDS、VPC、安全组）；了解 Terraform 基础设施即代码。

---

## 工作经历

### 2019.06 — 至今　XX 科技有限公司　高级 Linux 运维工程师
*（互联网/电商行业，服务器规模 500+ 台）*

- 负责公司核心业务系统 500+ 台服务器的运维保障，制定标准化运维规范，业务可用性从 99.5% 提升至 99.97%。
- 主导 MySQL 高可用架构改造：基于 GTID + 半同步复制 + MHA 实现主库故障自动切换（RTO < 30s），并通过 XtraBackup 全量+增量备份 + binlog PITR 建立容灾体系，每季度执行恢复演练。
- 基于 Ansible 重构批量运维体系，将日常 200+ 台服务器的配置下发、补丁更新、巡检从人工 4 小时缩短至 15 分钟。
- 搭建 Prometheus + Grafana 监控大盘与 Alertmanager 告警，覆盖系统、MySQL、Redis、Nginx 等核心组件，故障平均发现时间（MTTD）从 20 分钟降至 3 分钟。
- 推动核心业务容器化：使用 Kubernetes 管理 80+ 微服务，配合 Jenkins 实现 GitOps 持续交付，发布频次从每周 1 次提升至每日多次且零停机。
- 主导一次大促前的容量压测与全链路调优，定位并解决 Redis 热点 key 与 MySQL 慢查询导致的接口超时，保障大促零事故。

### 2016.03 — 2019.05　XX 网络科技有限公司　Linux 运维工程师
*（政企/软件行业，服务器规模 50～200 台）*

- 参与 50 台规模集群从 0 到 1 的架构规划与部署，涵盖 Rsync 备份、NFS 存储、inotify/sersync 实时同步、Nginx 反向代理、Keepalived 高可用等标准组件。
- 负责 LNMP 架构的日常运维与调优，独立完成 MySQL 主从复制搭建与延时排查，保障数据一致性。
- 编写 30+ 个 Shell 运维脚本（系统巡检、日志切割、MySQL 分库备份、网站 URL 存活监控），显著提升运维效率。
- 使用 Zabbix 搭建全网监控，自定义监控项覆盖用户访问七层模型，建立告警与故障处理 SOP。
- 实施 iptables 防火墙策略与 SSH 安全加固，通过等保二级合规检查。

### 2014.07 — 2016.02　XX 信息技术有限公司　运维工程师（初级）
*（IDC/运维外包）*

- 负责机房服务器上架、系统安装（PXE/Kickstart）、基础环境初始化与日常工单处理。
- 处理磁盘故障、RAID 重建、网络连通性等基础运维问题，积累扎实的硬件与系统排障能力。
- 维护 NTP/Chrony 时间同步、DHCP、DNS 等基础网络服务。

---

## 项目经验

### 项目一：MySQL 高可用与容灾体系建设（2021）
- **背景**：原单库架构存在单点故障，无有效备份恢复机制。
- **职责**：设计 GTID + 半同步复制一主两从架构；部署 MHA 实现自动故障切换；制定 XtraBackup 全量+增量备份策略（crontab 调度）+ binlog 归档实现 PITR；编写恢复演练脚本并季度执行。
- **成果**：RPO 接近 0，RTO < 30s；通过 3 次真实恢复演练验证方案可靠，通过等保三级数据安全检查。

### 项目二：基于 Ansible 的批量运维平台（2020）
- **背景**：服务器规模扩大后，手工逐台操作效率低、易出错。
- **职责**：编写 Ansible playbook 与 role，覆盖系统初始化、软件部署、配置下发、安全基线检查；封装常用运维任务为标准化作业。
- **成果**：配置一致性 100%，批量操作效率提升 90%，误操作事故归零。

### 项目三：Kubernetes 容器化改造与 CI/CD（2022—2023）
- **背景**：传统虚拟机部署发布慢、资源利用率低。
- **职责**：使用 kubeadm 搭建多节点 K8s 集群；将 80+ 微服务容器化并迁移；基于 Helm 管理应用；打通 GitLab + Jenkins + Harbor + K8s 的 GitOps 流水线。
- **成果**：资源利用率提升 40%，发布耗时从 1 小时降至 5 分钟，实现灰度发布与一键回滚。

### 项目四：全链路监控告警体系（2021）
- **背景**：故障靠用户投诉发现，定位慢。
- **职责**：搭建 Prometheus + Grafana + Alertmanager，开发 MySQL/Redis/Nginx 自定义 exporter；制定分级告警与值班机制。
- **成果**：MTTD 从 20 分钟降至 3 分钟，重大故障同比下降 60%。

---

## 教育背景

- **毕业院校**：XX 大学（请替换）
- **专业**：计算机科学与技术 / 网络工程（请替换）
- **学历**：本科
- **时间**：2010.09 — 2014.06

---

## 证书与加分项

- 红帽认证系统管理员 RHCSA / RHCE（如持有请填写，否则删除此行）
- 熟悉 Python，能编写运维工具与调用云 API（运维开发方向加分）
- 了解信创生态（统信 UOS、银河麒麟、欧拉）与国产数据库（政企岗位加分）
- 技术博客 / GitHub 首页（如有请填写链接）

---

> **说明**：本简历根据工作区内《云计算运维7阶段》《MySQL-DBA必备理论和学习路线》《k8s高频面试题》《ansible》《Linux性能优化实战》《就业指南》等学习资料整理，技能点均对应你已学习掌握的运维体系。请将括号内 `（请替换）` 的占位信息替换为你的真实信息，并按实际工作项目调整数据。
