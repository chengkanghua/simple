# 个人简历

## 基本信息

- **姓名**：程康华
- **求职意向**：Linux 运维工程师 / 高级运维工程师 / 云原生运维工程师
- **工作年限**：8 年
- **联系电话**：18679816495
- **邮箱**：chengkanghua@foxmail..com
- **所在城市**：广州/深圳/杭州
- **期望薪资**：面议

---

## 专业技能

### Linux系统与基础运维
- 熟悉服务器各核心硬件组成与选型; 具备服务器整机组装与部署能力;
- CentOS7操作系统安装部署;系统完整启动流程;SSH;
- 文件系统和目录结构: 文件类型;文件基础操作;通配符,基础正则符号;/proc与/sys
- 用户,权限(rwx/特殊权限/ACL/sudo)与安全基础
- 基础命令(文件查看/查找/压缩打包);管道与重定向;文件处理三剑客(grep/sed/awk)
- 进程基础;进程管理;后台任务;systemd服务管理;定时任务crontab;
- 磁盘基础;分区与挂载;文件系统;swap交换分区;LVM逻辑卷;RAID磁盘阵列;
- 网络原理基础(OSI七层模型/TCP/IP四层模型);网络配置和排查故障;防火墙(netfilter/iptables)
- RPM包管理/YUM/APT; NTP/Chrony时间同步;DNS;rsync+inotify; NFS文件共享;
- SHELL脚本编程: 脚本格式,执行方式,变量分类; 特殊变量;运算符;条件判断;循环结构;函数;基础数据类型;复合数据类型;
- 系统日志(/var/log/message|secure|cron|dmesg|...);日志轮转logrotate; 四维排障方法论;


### 自动化运维
- 精通 Shell 脚本编程，能独立编写系统巡检、数据备份、日志清理、批量建用户、MySQL 分库分表备份、企业级脚本。
- 熟练 Ansible：常用模块（command/shell/copy/file/yum/service/cron）、playbook、role 封装，实现批量部署与配置管理。
- 熟练 Git,GitLab,jenkins; 实现企业 CI/CD一键发布与回滚;

### Web网站架构
- 熟悉网站业务五层架构;
- 接入层(负载均衡/反向代理层): Nginx、LVS、Keepalived
- web应用服务器: Nginx,Tomcat,Node.js,Go
- 存储服务层: OSS, NFS, ceph
- 数据缓存层: redis
- 数据持久层: mysql,MongoDB

### 数据库与缓存运维（MySQL / Redis）
- 熟悉 MySQL5.6/5.7安装部署、体系结构,单机多实例;
- 熟悉 MySQL用户权限管理,MySQL日志管理;
- 熟练 MySQL 备份恢复：mysqldump + binlog 时间点恢复、XtraBackup 全量/增量备份与恢复演练。
- 掌握 MySQL 主从复制、GTID 复制、半同步复制、延时从库、Atla,具备 MHA 高可用故障切换实战经验。
- 熟悉 MySQL 优化：索引设计、`EXPLAIN`、慢查询分析、`Buffer Pool` 、生产调优参数。
- 熟悉 Redis：RDB/AOF 持久化、主从复制、哨兵（Sentinel）、Cluster 集群、缓存穿透/击穿/雪崩应对。


### 云计算与云原生
- 熟练 Docker：镜像构建（Dockerfile优化、多阶段构建）、容器网络与存储、Harbor 私有仓库。
- 熟悉 Docker整体架构,Docker实现原理,Docker4种网络模式;
- 熟悉 Kubernetes架构,Pod常见状态;
- 熟练 Kubernetes搭建集群、Pod/Deployment/StatefulSet/DaemonSet/Service/Endpoint/Ingress/ConfigMap/Secret/等核心资源、弹性伸缩、持久化存储（PV/PVC）、dashboard、集群监控与日志收集。
- 熟悉阿里云核心产品（ECS、SLB、OSS、RDS、VPC、安全组）；



### 底层原理与内核机制（核心优势）

- 深入理解 Linux 内核核心机制：进程/线程调度与上下文切换、虚拟内存与页表、OOM 与 swap 行为、文件描述符与 VFS/inode 体系。
- 掌握用户态/内核态边界与系统调用原理；熟悉 `/proc`、`/sys`、`sysctl` 内核参数调优，能针对高并发场景进行内核级优化。
- 精通网络 IO 模型：阻塞/非阻塞、IO 多路复用（select/poll/**epoll**）与零拷贝（sendfile），能从原理层面解释 Nginx、Redis 等高并发组件的性能来源。
- 具备 CPU/内存/磁盘 IO/网络 四大资源瓶颈的系统性分析方法论，熟练运用 `perf`/`strace`/`flame graph` 进行深度性能剖析与故障根因定位。
- 深入理解容器底层本质：**Namespace**（6 种隔离）+ **Cgroup**（资源限制）+ **OverlayFS**，能从内核视角排查 Docker/K8s 的隔离、网络与资源限制问题。



### 了解前后端编程知识

前端: html,css,javascript,es6,vue3,node.js
后端: python基础(变量,数据类型,复合容器类型),虚拟环境venv,函数,类,模块,文件操作,socket网络编程,并发编程;
     框架: django,drf, REST API , jwt,rbac.

个人笔记: https://github.com/chengkanghua/simple | https://docs.chengkanghua.top/ 

---

## 工作经历

### 2020.06 — 至今　云栈科技有限公司　高级 Linux 运维工程师
*（软件行业，服务器规模 20+ 台）*

公司产品为容器管理平台, gitlab jenins ,开发到到运维到运维线上自动化；
负责系统产品的的环境搭建以及安装测试;
负责推动系统产品的实施与交付;
负责面向客户的技术支持与培训;
日常技术文档的总结并形成标准化文档;


### 2016.03 — 2019.05　金河景集团有限公司　Linux 运维工程师
*（电商 ，服务器规模 10 台）*

负责内部系统的 web 集群环境搭建测试以及故障处理;
负责公司 Zabbix 监控系统的部署, 监控脚本的编写,调优与后期的维护; 
负责电脑硬件与软件的安装与维护;
日常技术文档的总结并形成标准化文件;


## 项目经验

### 项目一：基于K8S平台DevOps实践
项目背景: 传统软件开发中，开发与运维团队独立运作，面临开发运维割裂、交付周期长、软件质量低等挑战。
完成项目: 基于K8S平台DevOps实践.
主要工具: gitlab,jenkins,robotFramework,sonarqube,maven,java,Kubernetes.Dpcler.
实现效果: 开发提交代码-->jenkins自动构建项目-->下载代码-->mvn构建-->sonarque代码检测-->build-image-->push-images-->deploy-->验收测试-->构建结果发送到工作群.

note: https://github.com/chengkanghua/ansible_linux_cluster

### 项目二：测试环境搭建
批量上线测试节点
项目背景:新产品功能测试需要上线 1000 台计算节点，纯手工上线是重复性工作而且费时间，所有制作模版批量 上线
模版制作要求: 需要每台节点主机名不一样。只要开机就能上线。
解决过程:
1 编写一个脚本自动修改主机名为 agent-ip 地址的后两位(如:agent-32.45)
添加执行权限 ，写一个 service 文件设置开机自动启动。
主机的 ip 地址是自动获取的，这样每台克隆的机器 ip 都不一样，解决了主机名问题。 
2 agent 程序的上线配置 authkey，删除缓存的 authkey uuid 文件。
3 转换模版 克隆出的机器开机即可上线

### 项目三：Ansible 自动化部署集群架构
项目背景: 传统方法所有服务器需要一台一台安装配置,还有需要查看所有节点状态时候,这样做的效率不高,当机器量特别多的时候并不好管理,Ansible Playbook 能在十几分钟内完成部署集群里所有服务.
完成列表: 
      - 系统的基础优化
      - Rsync全网备份
      - Yum仓库搭建
      - Mysql数据库环境搭建
      - Nginx + Php动态web环境搭建
      - Nginx + Tomcat 动态web环境搭建

常见模块: Copy File Yum Crond Mount Service User Group 
note: https://github.com/chengkanghua/ansible_linux_cluster

---

个人评价
• 狂热技术爱好者，喜欢探究技术本质；
• 工作环境适应能力强,为人乐观积极, 抗压能力强,有很强的学习能力;
• 良好的沟通和交流能力,严谨耐心, 擅长沟通和表达;
• 团队意思很强, 服从上级主管;
