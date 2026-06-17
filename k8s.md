# docker

## Docker 精简介绍

1. **定义**：轻量容器化工具，将程序、依赖、运行环境打包，实现一次打包任意机器运行。
2. **对比虚拟机**：共享宿主机内核，占用资源少、秒级启动；虚拟机自带完整系统，笨重缓慢。
3. 四大核心
   - 引擎：Docker 后台服务，执行所有操作命令
   - 镜像：只读环境模板（如 mysql、nginx）
   - 容器：镜像运行后的可读写实例
   - 镜像仓库：存储、下载镜像的平台
4. **使用流程**：拉取镜像→运行容器-->容器内部署业务程序；自定义项目通过 Dockerfile 打包成镜像分发。
5. **核心优点**：环境统一、资源省、部署快、方便微服务与自动化发布。
6. **一句话总结**：解决环境不一致问题，轻量化打包部署应用。

适用场景: 本地搭建多套测试环境；CI/CD 自动化流水线打包发布。

​		无状态服务（Nginx、Tomcat、SpringBoot 后端、前端）→ 生产最推荐容器化

### 2. 有状态服务分两类，一部分线上也能用 Docker

有状态：需要持久存储、固定网络标识、数据不能随便丢（MySQL、Redis、ES、MQ）

### （1）轻量有状态：Redis（缓存）、MQ、ES、低并发小库 → 中小厂线上大量用

- Redis 只做缓存（非持久化强依赖）、消息队列存临时消息、日志搜索引擎；
- 数据丢失影响可控，配合数据卷挂载、host 网络消除性能损耗，docker/k8s 部署很普遍；
- 私有化交付、内部后台系统标配容器化整套中间件。

### （2）核心重 IO 有状态：生产交易 MySQL、PostgreSQL、核心库

**不推荐单机 docker run 直接上生产**，原因之前说过：IO 损耗、数据损坏风险、主从切换复杂。

但大厂云原生方案例外：

用 K8s + StatefulSet + 本地 SSD + 数据库 Operator 托管数据库，这依然是容器形态，只是不靠简单单机 Docker，是标准化容器集群方案。

## Docker 整体架构（C/S 客户端 - 服务端架构）

Docker 采用 **Client-Server（C/S）** 模型，分为四大核心模块：客户端、Docker 守护进程、镜像仓库、容器运行环境。

### 1. Client 客户端

就是你敲命令的地方（`docker run/pull/build` 等）

- 交互入口：CLI 命令行、Docker Desktop、SDK
- 作用：发送请求给 Docker Daemon，**不直接操作容器 / 镜像**

### 2. Daemon（dockerd 守护进程，服务端核心）

后台常驻服务，Linux 系统后台进程，Docker 真正干活的核心

职责：

1. 管理镜像：构建、拉取、推送、删除镜像
2. 管理容器：创建、启停、销毁、网络、存储挂载
3. 接收客户端请求，内部调用容器运行时完成隔离
4. 与镜像仓库通信

### 内部两层细分

1. **Docker Engine API**：客户端和 Daemon 通信接口（REST API）

2. containerd（容器运行时）

   - 接管容器生命周期：创建、删除、执行命令
   - 管理镜像、存储卷、网络

3. runc（底层标准运行时）

   遵循 OCI 标准，直接调用 Linux 内核能力（namespace、cgroups）实现资源隔离、限制。

### 3. Registry 镜像仓库

存放镜像的远程服务器

- 官方公共：Docker Hub

- 私有仓库：Harbor、阿里云镜像仓库

  流程：Daemon 根据指令去仓库拉取 / 上传镜像。

### 4. 内核支撑技术（底层隔离基础）

Daemon 依赖 Linux 内核实现容器轻量化隔离：

1. Namespace：进程、网络、挂载、用户、PID 隔离（容器互相看不见）
2. Cgroups：限制 CPU、内存、磁盘 IO，防止容器资源耗尽宿主机
3. Union FS：镜像分层只读存储，镜像复用、快速构建

### 完整调用流程举例（docker run nginx）

1. 客户端执行命令 → 请求发送给 dockerd
2. dockerd 发现本地无 nginx 镜像 → 调用 containerd
3. containerd 去 Docker Hub 拉取分层镜像到本地存储
4. 拉取完成，containerd 调用 runc
5. runc 调用 Linux 内核 namespace+cgroups 创建隔离容器进程
6. Nginx 进程启动，客户端返回运行结果

### 极简架构总结

客户端（发命令）→ Daemon（总调度）→ containerd（容器管理）→ runc（内核隔离）+ Registry（镜像仓库），底层靠 Linux 内核实现轻量隔离。

## Docker 实现原理（精简版）

### 一、底层核心三大 Linux 内核技术

1. **Namespace（隔离）**

   提供 6 种独立隔离视图，容器互不感知：

   - PID：独立进程编号（容器内 PID 1，宿主机是大 PID）

   - Mount：独立文件系统

   - Network：独立网卡、IP、端口

   - UTS：独立主机名

   - User：独立用户 ID

   - IPC：独立进程通信通道

     

     作用：实现容器进程、网络、文件、主机名隔离。

2. **Cgroups（资源限制）**

   限制容器 CPU、内存、磁盘 IO、网络带宽，防止单个容器耗尽宿主机资源。

3. **UnionFS（分层镜像存储）**

   镜像分层只读，容器新增读写层；  写时复制（CoW）技术。CoW就是copy-on-write

   多镜像共享基础层，构建 / 拉取速度快、节省磁盘。

   AUFS是作为Docker存储驱动的一种实现，Docker 还支持了不同的存储驱动，包括 aufs、devicemapper、overlay2、zfs 和 Btrfs 等等，在最新的 Docker 中，overlay2 取代了 aufs 成为了推荐的存储驱动

### 二、整体运行分层架构

1. **Docker Client**：docker 命令，发送 API 请求
2. **dockerd 守护进程**：总调度，调用 containerd
3. **containerd**：容器生命周期管理（拉镜像、创建容器）
4. **runc（OCI 标准）**：调用内核 Namespace+Cgroups 创建容器进程
5. **Linux 内核**：提供隔离、限制、文件系统底层能力

### 三、网络实现原理

- 网桥 docker0/CNI 网桥，iptables 实现端口映射、SNAT/DNAT 转发；
- 需开启 ip_forward、br_netfilter 网桥转发内核参数。

### 四、一句话总结

Docker = Linux Namespace 隔离 + Cgroups 资源限制 + UnionFS 分层镜像，上层封装客户端 /daemon/runc 工具链，实现轻量化容器。





## Docker 4 种原生网络模式

### 1. bridge（默认）

- 自动生成`docker0`网桥，容器成对 veth 虚拟网卡接入网桥，独立网络命名空间
- 同网桥容器互通，外网需`-p`端口映射，宿主机看不到容器内网 IP
- 适用：单机常规业务

### 2. host

- 容器直接复用宿主机网络栈，无 veth、无独立 IP，共享宿主机网卡端口
- 网络性能最好，禁止端口映射，易端口冲突
- 适用：高性能中间件、监控类服务

### 3. none

- 仅保留本地回环网卡，禁用所有外网、容器间网络
- 适用：离线安全计算任务

### 4. container

- 复用已有容器的网络命名空间，两个容器共用同一个 IP、网卡
- 可通过 127.0.0.1 互访，端口不能重复
- 适用：Sidecar 日志、监控附属容器

### 二、veth 核心要点

1. veth 成对出现：宿主机端 ↔ 容器内 eth0，删除容器网卡同步销毁
2. 容器 IP 在独立网络命名空间，宿主机仅能查看网卡流量，无法直接看到容器内网 IP
3. 所有跨网络访问依赖网桥 + iptables NAT 转发

### 三、关键注意事项

1. bridge 模式必须开启内核 IP 转发、加载`br_netfilter`模块
2. 频繁启停容器需排查残留 veth 网卡，避免占用内核资源
3. 容器内网 IP 仅同网段容器、宿主机可访问，外网不能直接路由
4. 推荐自定义网桥，规避默认网段冲突，实现业务网络隔离

```bash
1. bridge（默认，可不加--net）
# 默认docker0网桥
docker run -d --name test nginx
# 显式指定bridge
docker run -d --net bridge --name test nginx

2. host 宿主机网络
docker run -d --net host --name test nginx

3. none 无网络
docker run -d --net none --name test nginx

4. container 复用其他容器网络
docker run -d --net container:已存在容器名/ID --name test nginx

二、生产自定义网桥常用套路命令
1. 创建自定义网桥（指定网段、网关）
docker network create \
--subnet=172.20.0.0/16 \
--gateway=172.20.0.1 \
my-net

2. 容器启动直接加入自定义网络
docker run -d --net my-net --name nginx nginx
3. 已有运行容器追加加入自定义网络
docker network connect my-net 容器名
4. 容器从网络中移除
docker network disconnect my-net 容器名
5. 查看网络详情
docker network inspect my-net
6. 删除闲置自定义网络
docker network rm my-net



```







## 操作记录

```bash
#centos7 升级内核 6.9版本
# https://dl.lamp.sh/kernel/el7/
wget https://dl.lamp.sh/kernel/el7/kernel-ml-devel-6.9.10-1.el7.x86_64.rpm
wget https://dl.lamp.sh/kernel/el7/kernel-ml-6.9.10-1.el7.x86_64.rpm

yum localinstall -y  kernel-ml-6.9.10-1.el7.x86_64.rpm kernel-ml-devel-6.9.10-1.el7.x86_64.rpm

#安装完毕后查看系统可用启动内核
awk -F\' '$1=="menuentry " {print  $2}' /etc/grub2.cfg

# 修改默认的启动内核
grub2-set-default 'CentOS Linux (6.9.10-1.el7.x86_64) 7 (Core)'
grub2-editenv list

reboot
uname -r
-----------------------------------------------------------------
## 若未配置，需要执行如下
#加载网桥过滤模块
modprobe br_netfilter
cat <<EOF > /etc/modules-load.d/br_netfilter.conf
br_netfilter
EOF
cat <<EOF >  /etc/sysctl.d/docker.conf
# 让 iptables 防火墙规则生效在网桥转发流量上。
# 1：网桥流量同样走 iptables 链做 NAT、过滤、端口转发
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
# 开启 Linux 内核 IPv4 数据包转发。
net.ipv4.ip_forward=1
EOF
sysctl -p /etc/sysctl.d/docker.conf
# 检查
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward

#docker 安装
# https://mirrors.huaweicloud.com/mirrorDetail/5ea14d84b58d16ef329c5c13?mirrorName=docker-ce&catalog=docker
sudo yum remove docker docker-common docker-selinux docker-engine
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
wget -O /etc/yum.repos.d/docker-ce.repo https://mirrors.huaweicloud.com/docker-ce/linux/centos/docker-ce.repo
sudo sed -i 's+download.docker.com+mirrors.huaweicloud.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
sudo yum makecache fast
sudo yum install docker-ce

#华为云的镜像加速地址
https://console.huaweicloud.com/swr/?region=cn-north-4#/swr/mirror
进入华为云搜索“容器镜像服务”或者 "SWR" ，进入控制台
点击 “镜像资源”---> “镜像中心”---> "镜像加速器"
cat <<EOF > /etc/docker/daemon.json
{
    "registry-mirrors": [ "https://4c0c57d8b79a402d811834c1be74f7ae.mirror.swr.myhuaweicloud.com" ]
}
EOF

## 设置开机自启
systemctl enable docker  
systemctl daemon-reload

## 启动docker
systemctl start docker 

## 查看docker信息
docker info
## docker-client
which docker
## docker daemon
ps aux |grep docker
## containerd
ps aux|grep containerd
systemctl status containerd


# Docker 命令分类（按图中模块划分）
一、镜像相关 Images
1. 镜像基础操作
    images：列出本地所有镜像
    rmi：删除镜像
    tag：给镜像打标签
    history：查看镜像分层构建历史
2. 镜像构建
    build：通过 Dockerfile 构建镜像
3. 镜像本地导入导出（Tar 包）
    save：镜像导出为 tar 文件
    	docker save -o nginx-alpine.tar nginx:alpine
    load：从 tar 文件导入镜像
    	docker load -i nginx-alpine.tar
    export：容器导出为 tar 文件
    import：容器 tar 包导入生成镜像
4. 镜像仓库 Registry 交互
    pull：从仓库拉取镜像到本地
    	docker pull nginx:alpine
    push：推送本地镜像到仓库
    search：搜索仓库镜像
    login：登录镜像仓库
    logout：退出镜像仓库登录
5. 容器生成镜像
	commit：把运行中的容器打包生成新镜像
6. 对比容器与镜像差异
	diff：查看容器相对于底层镜像的文件改动
二、容器相关 Container
1. 容器生命周期（状态流转）
创建容器
    create：创建容器（不启动）
    run：创建并立刻启动容器
    运行 / 停止 / 暂停状态切换
    start：启动已停止容器
    stop：优雅停止运行容器
    kill：强制杀死运行容器
    pause：暂停容器所有进程
    unpause：恢复暂停的容器
删除容器
	rm：删除停止状态的容器
2. 容器信息查看
    ps：列出容器
    inspect：查看容器详细元数据
    port：查看容器端口映射
    top：查看容器内进程
    logs：查看容器日志
    wait：阻塞等待容器停止并返回退出码
3. 容器交互操作
    attach：附着到容器前台终端
    exec：在运行容器内执行命令（进入容器终端常用）
    cp：宿主机与容器之间互传文件 / 文件夹

三、宿主机与容器文件传输 Host
	cp：容器 ↔ 宿主机 文件 / 文件夹拷贝
四、Dockerfile 构建镜像
	build：读取 Dockerfile 构建镜像
五、Tar 文件（镜像 / 容器打包）
    save：镜像导出 tar
    load：tar 导入镜像
    export：容器导出 tar
    import：容器 tar 导入为镜像
六、镜像仓库 Registry
	pull、push、search、login、logout
七、Docker Engine 引擎全局信息
    version：查看 Docker 客户端 / 服务端版本
    info：查看 Docker 系统全局信息（存储、容器、镜像数量等）
    events：实时监听 Docker 后台事件（创建 / 删除容器、拉取镜像等）



# 创建 Docker Registry 认证文件目录
mkdir /var/lib/registry_auth

# 使用 htpasswd 来创建加密文件
[ -f /usr/bin/htpasswd ] || yum install -y httpd-tools
htpasswd -Bbn admin admin > /var/lib/registry_auth/htpasswd
#-B：使用 bcrypt 加密密码（安全性更高，推荐）
#-b：批量模式，直接在命令行传入用户名 + 密码，不用交互式输入
#-n：不输出到终端，输出标准输出


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

docker run -p 5000:5000 \          # 端口映射：宿主机5000映射容器5000
--restart=always \                 # 容器异常/开机自动重启
--name registry \                  # 容器命名registry
-v /var/lib/registry:/var/lib/registry \  # 持久化镜像存储目录 宿主机位置:容器内位置
-v /var/lib/registry_auth/:/auth/ \      # 挂载账号密码文件目录
-e "REGISTRY_AUTH=htpasswd" \      # 启用htpasswd账号密码认证
-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \ # 登录提示域名
-e "REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd" \ # 指定密码文件容器内路径
-d registry                        # 后台运行registry官方仓库镜像
# -e 是添加容器内环境变量
# -d 后台守护进程运行容器，不占用当前终端


## docker默认不允许向http的仓库地址推送，如何做成https的，参考：https://docs.docker.com/registry/deploying/#run-an-externally-accessible-registry
## 我们没有可信证书机构颁发的证书和域名，自签名证书需要在每个节点中拷贝证书文件，比较麻烦，因此我们通过配置daemon的方式，来跳过证书的验证：
vim /etc/docker/daemon.json
{
    "registry-mirrors": [ "https://4c0c57d8b79a402d811834c1be74f7ae.mirror.swr.myhuaweicloud.com" ],
    "insecure-registries": ["10.0.0.80:5000"]
}

systemctl restart docker
docker login 10.0.0.80:5000
Username: admin
Password: admin


docker pull nginx:alpine
docker tag nginx:alpine 10.0.0.80:5000/nginx:alpine
docker push 10.0.0.80:5000/nginx:alpine


## 查看仓库内元数据
curl -u admin:admin -X GET http://10.0.0.80:5000/v2/_catalog
curl -u admin:admin  -X GET http://10.0.0.80:5000/v2/nginx/tags/list

docker rmi nginx:alpine
## 查看运行状态的容器列表
docker ps
## 查看全部状态的容器列表
docker ps -a
## 后台启动
docker run --name nginx -d nginx:alpine
## 映射端口,把容器的端口映射到宿主机中,-p <host_port>:<container_port>
docker run --name nginx -d -p 8080:80 nginx:alpine
## 资源限制,最大可用内存500M
docker run --memory=500m nginx:alpine
## 挂载主机目录
docker run --name nginx -d  -v /opt:/opt  nginx:alpine
docker run --name mysql -e MYSQL_ROOT_PASSWORD=123456  -d -v /opt/mysql/:/var/lib/mysql mysql:5.7

# 进入容器或者执行容器内的命令
docker exec -ti <container_id_or_name> /bin/sh
# -t：分配伪终端，支持交互
# -i：保持标准输入打开
# -ti：组合，实现交互式进容器
docker exec <container_id_or_name> hostname命令

# 主机与容器之间拷贝数据
## 主机拷贝到容器
echo '123'>/tmp/test.txt
docker cp /tmp/test.txt nginx:/tmp
docker exec nginx cat /tmp/test.txt
## 容器拷贝到主机
docker cp nginx:/tmp/test.txt ./

## 查看全部日志
docker logs nginx
## 实时查看最新日志
docker logs -f nginx
## 从最新的100条开始查看
docker logs --tail=100 -f nginx

## 停止运行中的容器
docker stop nginx
## 启动退出容器
docker start nginx
## 删除非运行中状态的容器
docker rm nginx
## 删除运行中的容器
docker rm -f nginx

## 查看容器详细信息，包括容器IP地址等
$ docker inspect nginx
## 查看镜像的明细信息
$ docker inspect nginx:alpine


Dockerfile使用
docker build . -t ImageName:ImageTag -f Dockerfile

FROM 指定基础镜像，必须为第一个命令
MAINTAINER 镜像维护者的信息
COPY|ADD 添加本地文件到镜像中
WORKDIR 工作目录
RUN 构建镜像过程中执行命令
CMD 构建容器后调用，也就是在容器启动时才进行调用
ENTRYPOINT 设置容器初始化命令，使其可执行化
ENV
EXPOSE   容器内端口
# 1. FROM：指定基础镜像，必须首行
FROM centos:7
# 2. RUN：构建时执行shell命令
RUN yum install nginx -y
# 3. COPY：宿主机文件/目录复制到容器
COPY ./index.html /usr/share/nginx/html/
# 4. ADD：类似COPY，自动解压tar、支持远程url
ADD test.tar.gz /opt/
# 5. WORKDIR：设置容器工作目录，后续命令默认在此执行
WORKDIR /app
# 6. ENV：定义环境变量
ENV VERSION=1.0
# 7. ARG：构建时传入临时参数，镜像内不保留
ARG build_user
# 8. EXPOSE：声明容器暴露端口（仅说明，不自动映射）
EXPOSE 80
# 9. VOLUME：声明数据卷，持久化目录
VOLUME ["/data"]
# 10. CMD：容器启动默认命令，docker run可覆盖
CMD ["nginx","-g","daemon off;"]
# 11. ENTRYPOINT：容器入口程序，CMD仅作参数
ENTRYPOINT ["/bin/sh"]
# 12. USER：切换运行用户（默认root）
USER nginx
# 13. LABEL：给镜像添加元数据标签
LABEL author="admin"
# 14. HEALTHCHECK：容器健康检查
HEALTHCHECK --interval=3s CMD curl -s 127.0.0.1


通过1号进程理解容器的本质
----------------------------------------------------------
-- 容器内 PID 1 是什么
容器启动后，容器内部的第一个进程就是 PID=1 进程，由runc依托 Linux Namespace 创建。
宿主机有完整 PID 树，容器拥有独立 PID Namespace：
宿主机看该进程是随机大 PID；
容器内部视角，它就是 PID=1。
本质上讲容器是利用namespace和cgroup等技术在宿主机中创建的独立的虚拟空间，这个空间内的网络、进程、挂载等资源都是隔离的。
------------------------------------------------------------
docker run -d --name xxx nginx:alpine <自定义命令>
# <自定义命令>会覆盖镜像中指定的CMD指令，作为容器的1号进程启动。
docker run -d --name test-3 nginx:alpine echo 123
docker run -d --name test-4 nginx:alpine ping www.badu.com
$ docker exec -ti test-4 /bin/sh
#/ ps aux
#/ ip addr
#/ ls -l /
#/ apt install xxx
#/ #安装的软件对宿主机和其他容器没有任何影响，和虚拟机不同的是，容器间共享一个内核，所以容器内没法升级内核

多阶段构建（极简理解）
1. 核心痛点
单阶段打包会把编译工具、源码、依赖包全塞进最终镜像，镜像体积巨大，包含无用编译环境。
2. 本质
一个 Dockerfile 里写多个 FROM，分出「构建阶段」+「运行阶段」：
构建阶段：带编译环境，编译代码生成可执行文件；
运行阶段：只用极简基础镜像，只拷贝上一阶段编译好的产物，丢弃所有编译工具 / 源码。
3. 关键语法
COPY --from=阶段名 源路径 目标路径：跨阶段复制文件。
4. 优点
镜像体积大幅缩小；
减少攻击面（无 gcc、maven、npm 等工具）；
无需手动导出文件，一条docker build完成。
5. 一句话总结
多阶段构建 =分开编译与运行环境，只保留程序运行必需文件，剔除编译冗余。


yum install -y git 
git clone --depth=1 https://gitee.com/chengkanghua/eladmin-web.git
#--depth=1：只拉取最新 1 次提交，不下载完整 git 历史，加速克隆、减小体积
cd eladmin-web/

# 多阶段构建dockerfile.multi
-------------------------------------------------------
cat <<EOF > Dockerfile.multi
# # 阶段1：编译阶段（大镜像，仅用来打包程序）
FROM codemantn/vue-node AS builder
LABEL maintainer="inspur_lyx@hotmail.com"

# config npm
RUN npm config set sass_binary_site  https://npmmirror.com/mirror/sass && \
    npm config set registry  https://registry.npmmirror.com
WORKDIR /opt/eladmin-web
COPY  . .

# build
RUN ls -l && npm install && npm run build:prod
# 阶段2：运行阶段（超轻量空镜像，只放成品）
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
# 只拷贝构建好的文件，编译器、源码全部丢弃
COPY --from=builder /opt/eladmin-web/dist /usr/share/nginx/html/
EXPOSE 80
EOF
----------------------------------------------------
docker build --no-cache . -t eladmin-web:v1 -f Dockerfile.multi
# --no-cache：构建时不使用旧镜像缓存，全部重新构建
# .：构建上下文为当前目录



```









# k8s



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



```bash
#所有节点执行
yum install -y kubelet-1.24.4 kubeadm-1.24.4 kubectl-1.24.4 --disableexcludes=kubernetes
## 查看kubeadm 版本
kubeadm version
## 设置kubelet开机启动
systemctl enable kubelet --now


# 导出默认配置，config.toml这个文件默认是不存在的
# 将 sandbox_image 镜像源设置为阿里云google_containers镜像源
containerd config default > /etc/containerd/config.toml
grep sandbox_image  /etc/containerd/config.toml

sed -i "s#k8s.gcr.io/pause#registry.aliyuncs.com/google_containers/pause#g"       /etc/containerd/config.toml
sed -i "s#registry.k8s.io/pause#registry.aliyuncs.com/google_containers/pause#g"       /etc/containerd/config.toml

#配置镜像加速
sed -i '147s#\"\"#\"/etc/containerd/certs.d\"#g' /etc/containerd/config.toml
# 创建对应的目录
mkdir -p /etc/containerd/certs.d/docker.io
# 配置加速
cat >/etc/containerd/certs.d/docker.io/hosts.toml <<EOF
server = "https://docker.io"
[host."https://4c0c57d8b79a402d811834c1be74f7ae.mirror.swr.myhuaweicloud.com"]
  capabilities = ["pull","resolve"]
[host."https://docker.mirrors.ustc.edu.cn"]
  capabilities = ["pull","resolve"]
[host."https://registry-1.docker.io"]
  capabilities = ["pull","resolve","push"]
EOF


# 配置containerd cgroup 驱动程序systemd
sed -i 's#SystemdCgroup = false#SystemdCgroup = true#g' /etc/containerd/config.toml



# 配置非安全的私有镜像仓库：
# 此处目录必须和个人环境中实际的仓库地址保持一致
mkdir -p /etc/containerd/certs.d/10.0.0.80:5000
cat >/etc/containerd/certs.d/10.0.0.80:5000/hosts.toml <<EOF
server = "http://10.0.0.80:5000"
[host."http://10.0.0.80:5000"]
  capabilities = ["pull", "resolve", "push"]
  skip_verify = true
EOF

systemctl restart containerd


# 操作节点： 只在master节点（k8s-master）执行
kubeadm config print init-defaults > kubeadm.yaml
sed -ri 's#(advertiseAddress: ).*#\110.0.0.80#' kubeadm.yaml
sed -ri 's#(name: ).*#\1k8s-master#' kubeadm.yaml
sed -ri 's#(imageRepository: ).*#\1registry.aliyuncs.com/google_containers#' kubeadm.yaml
sed -ri 's#(kubernetesVersion: ).*#\11.24.4#' kubeadm.yaml
#sed -i '34a\ \ podSubnet: 10.244.0.0/16' kubeadm.yaml  #指定34行挤下一行添加
sed -i '/dnsDomain:/a\ \ podSubnet: 10.244.0.0/16' kubeadm.yaml

  # 查看需要使用的镜像列表,若无问题，将得到如下列表
$ kubeadm config images list --config kubeadm.yaml
registry.aliyuncs.com/google_containers/kube-apiserver:v1.24.4
registry.aliyuncs.com/google_containers/kube-controller-manager:v1.24.4
registry.aliyuncs.com/google_containers/kube-scheduler:v1.24.4
registry.aliyuncs.com/google_containers/kube-proxy:v1.24.4
registry.aliyuncs.com/google_containers/pause:3.7
registry.aliyuncs.com/google_containers/etcd:3.5.3-0
registry.aliyuncs.com/google_containers/coredns:v1.8.6
 # 提前下载镜像到本地
$ kubeadm config images pull --config kubeadm.yaml

# 初始化master节点
kubeadm init --config kubeadm.yaml
------------- 成功提示
kubeadm join 10.0.0.80:6443 --token abcdef.0123456789abcdef \
        --discovery-token-ca-cert-hash sha256:d3cc8c1f6666842101f79964ca5580291a41d54ac13d8a5862e0f84572a9b08a
----------------
# 执行集群重置清理残留  #初始化失败 再次执行初始化之前做的
# kubeadm reset -f
# 手动删除残留目录（兜底清理）
# rm -rf /etc/kubernetes /var/lib/etcd

#接下来按照上述提示信息操作，配置kubectl客户端的认证
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config



[root@k8s-master ~]# kubeadm token create --print-join-command
kubeadm join 10.0.0.80:6443 --token srw121.zmapgf66alkiurel --discovery-token-ca-cert-hash sha256:d3cc8c1f6666842101f79964ca5580291a41d54ac13d8a5862e0f84572a9b08a


# 添加slave节点到集群中  #再slave节点运行
kubeadm join 10.0.0.80:6443 --token srw121.zmapgf66alkiurel --discovery-token-ca-cert-hash sha256:d3cc8c1f6666842101f79964ca5580291a41d54ac13d8a5862e0f84572a9b08a



# master 安装网络插件
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
# wget https://gitee.com/chengkanghua/script/raw/master/k8s/kube-flannel.yml

#命令修改  修改网卡名eth0
sed -i '/kube-subnet-mgr/a\ \ \ \ \ \ \ \ - --iface=eth0' kube-flannel.yml

# 执行flannel安装
kubectl apply -f kube-flannel.yml
kubectl -n kube-flannel get po -owide

# 默认部署成功后，master节点无法调度业务pod，如需设置master节点也可以参与pod的调度，需执行：
#kubectl taint node k8s-master node-role.kubernetes.io/master:NoSchedule-
#kubectl taint node k8s-master node-role.kubernetes.io/control-plane:NoSchedule-

# 设置kubectl自动补全
$ yum install bash-completion -y
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

# 使用kubeadm安装的集群，证书默认有效期为1年，可以通过如下方式修改为10年。
cd /etc/kubernetes/pki

# 查看当前证书有效期
for i in $(ls *.crt); do echo "===== $i ====="; openssl x509 -in $i -text -noout | grep -A 3 'Validity' ; done

mkdir backup_key; cp -rp ./* backup_key/
#git clone https://github.com/yuyicai/update-kube-cert.git
#cd update-kube-cert/ 
wget https://gitee.com/chengkanghua/script/raw/master/k8s/update-kubeadm-cert.sh
bash update-kubeadm-cert.sh all
#若无法clone项目，可以手动在浏览器中打开后，复制update-kubeadm-cert.sh 脚本内容到机器中执行

#观察集群节点是否全部Ready
kubectl get nodes  


# 测试nginx 服务
kubectl run  test-nginx --image=nginx:alpine

kubectl get po -o wide
curl `kubectl get po -o wide |awk 'NR==2{print $6}'`





```



## [containerd客户端介绍](https://docs.chengkanghua.top/k8s-2023/2Kubernetes安装文档?id=containerd客户端介绍)



```bash
由于新版本的k8s直接采用`containerd`作为容器运行时，因此，后续创建的服务，通过`docker`的命令无法查询，因此，如果有需要对节点中的容器进行操作的需求，需要用`containerd`的命令行工具来替换，
目前总共有三种，包含：
- ctr
- crictl
- nerctl

推荐使用 nerdctl，使用效果与 docker 命令的语法基本一致 , 
官网https://github.com/containerd/nerdctl

#安装
# 下载精简版安装包，精简版的包无法使用nerdctl进行构建镜像
wget https://github.com/containerd/nerdctl/releases/download/v0.23.0/nerdctl-0.23.0-linux-amd64.tar.gz
#如果下载超时或者速度慢，也可以去网盘自取
链接: https://pan.baidu.com/s/14Q2tPbiNXdN-PLKk1hpKhA 提取码: 496v 
# 解压后，将nerdctl 命令拷贝至$PATH下即可
cp nerdctl /usr/bin/
---------------------浏览器下载
https://gitee.com/chengkanghua/script/raw/master/k8s/nerdctl-0.23.0-linux-amd64.tar.gz
tar xvf nerdctl-0.23.0-linux-amd64.tar.gz
mv nerdctl /usr/bin/

# 常用操作
nerdctl ns ls
查看镜像列表
nerdctl -n k8s.io ps -a

# 执行exec
nerdctl -n k8s.io exec -ti e2cd02190005 sh

# 登录镜像仓库
nerdctl login 10.0.0.80:5000

# 拉取镜像,如果是想拉取了让k8s使用，一定加上-n k8s.io,否则会拉取到default空间中， k8s默认只使用k8s.io
nerdctl -n k8s.io pull 10.0.0.80:5000/eladmin/eladmin-api:v1-rc1

# 启动容器
nerdctl -n k8s.io run -d --name test nginx:alpine

# exec
nerdctl -n k8s.io  exec -ti test sh

# 查看日志, 注意，nerdctl 只能查看使用nerdctl命令创建从容器的日志，k8s中kubelet创建的产生的容器无法查看
nerdctl -n k8s.io logs -f test

# 构建，但是需要额外安装buildkit的包
nerdctl build . -t xxxx:tag -f Dockerfile


使用小经验
用了k8s后，对于业务应用的基本操作，90%以上都可以通过kubectl命令行完成
对于镜像的构建，仍然推荐使用docker build 来完成，推送到镜像仓库后，containerd可以直接使用
对于查看containerd中容器的日志，使用 crictl logs完成，因为ctr、nerdctl均不支持
对于其他常规的containerd容器操作，建议使用nerdctl完成
更多命令可以参考下文：
https://www.modb.pro/db/485911
https://github.com/containerd/nerdctl#container-management




```



## 主流容器调度平台选型对比表

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



## 一、官方标准架构（控制平面 + 工作节点）

Kubernetes 采用**控制平面（Control Plane）+ 工作节点（Worker Node）** 的分布式主从架构，是官方定义的标准拓扑结构Kubernetes。

![img](data:image/svg+xml,%3csvg%20xmlns=%27http://www.w3.org/2000/svg%27%20version=%271.1%27%20width=%27256%27%20height=%27192%27/%3e)![image](./k8s.assets/7e883a3f9d3bb6cfc68841c255af384ftplv-a9rns2rl98-pc_smart_face_crop-v1512384.png)

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

### 三、核心设计原则（官方核心思想）

1. **声明式 API**：用户只定义最终期望状态，不关心执行步骤，系统自动完成编排
2. **List-Watch 机制**：所有组件通过监听 apiserver 资源变化触发动作，无轮询开销，实时响应
3. **不可变基础设施**：容器镜像不可变，更新通过重建 Pod 实现，保证环境一致性
4. **自愈能力**：节点故障、Pod 异常时，控制器自动重建 / 迁移 Pod，维持期望副本数





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







### CRI 和 OCI 标准  什么区别?

## 核心一句话

- **OCI：底层容器通用标准（管镜像、管内核怎么跑容器）**
- **CRI：K8s 专属上层接口标准（管 K8s 怎么调用容器运行时）**

## 一、核心区别对比表（必背）

| 对比项       | OCI                                                | CRI                                   |
| ------------ | -------------------------------------------------- | ------------------------------------- |
| **全称**     | 开放容器规范                                       | K8s 容器运行时接口                    |
| **归属**     | Linux 基金会、**全行业通用**                       | K8s 官方、**仅 K8s 使用**             |
| **层级**     | 底层标准                                           | 上层调用接口                          |
| **作用**     | 统一**镜像格式、容器运行规则**（Namespace/Cgroup） | 统一 **kubelet 调用容器运行时的协议** |
| **包含规范** | 镜像规范 + 运行时规范                              | 镜像服务 API + 容器运行 API           |
| **实现**     | runc、crun                                         | containerd、CRI-O                     |

## 二、层级关系

**OCI 是地基，CRI 是上层通道**

- OCI：规定容器**长什么样、怎么跑**
- CRI：规定 K8s **怎么命令运行时去创建容器**

## 三、K8s 完整调用链路（极简）

```
kubelet →(CRI gRPC)→ containerd →(遵循OCI)→ runc → 容器
```

## 四、最简记忆

1. **OCI = 统一容器标准**（所有容器都遵守）
2. **CRI = K8s 解耦接口**（让 K8s 不绑定 Docker）





















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















