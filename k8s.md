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















