# 内容综述

1 linux 背景介绍
2 系统操作
3 服务管理
4 shell脚本
5 文本操作
6 常用服务搭建

# 3 什么是linux

Linux有两种含义
一种是 Linus编写的开源操作系统的内核
另一种是广义的操作系统

- 服务端操作系统和客户端操作系统要做的事情不一样
- 命令行操作方式与图形界面差异

学习linux 之前的环境准备

执行坏境

```
- 云主机
- 无数据的pc（不推荐多系统混跑）
- 虚拟机（推荐方式）
```

# 4 linux的内核版本及常见的发行版

内核版本

发行版本

内核版本

```
- https://www.kernel.org
- 内核版本分为三个部分
- 主版本号 次版本号 末版本号
- 次版本号是奇数为开发版，偶数为稳定版
```

发行版本

	redhat enterprise linux 8
	fedora
	centos
	debian
	ubuntu

# 5 VirtualBox 安装

# 6 在虚拟机中安装linux

镜像下载地址  [http://isoredirect.centos.org/centos/7/isos/x86_64/](http://isoredirect.centos.org/centos/7/isos/x86_64/)

# 7 第一次启动linux

终端的使用
× 终端
× 图形终端
× 命令行终端
× 远程终端(SSH VNC)

常见目录介绍

- / 根目录
- /root root用户家目录
- /home /username 普通用户的家目录
- /etc 配置文件目录
- /bin 命令目录
- /sbin 管理命令目录
- /usr/bin /usr/sbin  系统预装的其他命令

# 8 万能的帮助命令 man help info

万能帮助命令

- 为什么要学习帮助命令
- man 帮助
- help 帮助
- info 帮助
- 使用网络资源（搜索引擎和官方文档）

```
man 是manual的缩写
man 帮助用法演示 
# man ls
man 也是一条命令， 分为9章
man 7 man

help帮助
shell（命令解释器）自带的命令称为内部命令，其他的是外部命令
内部命令使用help帮助
# help cd
外部命令使用help帮助
# ls --help

info帮助比help更详细 作为help的补充
# info ls
```

为什么要学习帮助命令

- linux的基本操作方式是命令行
- 海量的命令不适合 死记硬背
- 你要升级你的大脑

# 9 初始pwd 和ls命令

一切皆文件

- 文件查看
- 目录文件的创建于删除
- 通配符
- 文件操作
- 文本内容查看

pwd 显示当前的目录名称

cd 更改当前的操作目录
cd /path/to/.... 绝对路径
cd ./path/to/... 相对路径
cd ../path/to/... 相对路径

ls 查看当前目录下的文件
ls [选项， 选项...] 参数 。。。
常用参数：

- -l 长格式显示文件
- -a 显示隐藏文件
- -r 逆序显示
- -t 按照时间顺序显示
- -R 递归显示

# 10 详解ls 命令

# 11 详解cd 命令

# 12 创建和删除目录

```
mkdir /a
mkdir ./a
mkdir a
mkdir b c d
mkdir -p /a/b/c

ls -R /a
-R, --recursive		递归显示子目录

rmdir #只能删除空白目录
rm -rf /a    # r 目录删除  f不需要确认
```

# 13 复制和移动目录

```
cp -r /root/a /tmp  # r复制目录
   -p   #保留时间
   -v   # 显示过程
   -a   # 保留时间 权限 所有者 所有组
 
mv /firlea /file   #改名
mv /tmp/fileb /filec  # 移动改名

*  匹配任何字符串
？  匹配一个字符
cp -v file* /
cp file? /  #只复制file后面一个字符的文件
```

# 14 文本查看命令

cat 文本内容显示到终端
head 查看文件开头
tail  查看文件结尾
- 常用参数 -f 文件内容更新后，显示信息同步更新
wc  统计文件内容信息

# 15 打包压缩和解压缩

linux 的备份压缩

- 最早的linux备份介质是磁带，使用命令是tar
- 可以打包后的磁带文件进行压缩存储，压缩的命令是gzip 和 bzip2
- 经常使用的扩展名是 .tar.gz .tar.bz2 .tgz

```
tar cf /tmp/etc-backup.tar  /etc  # 把etc 目录打包了
tar zcf /tmp/etc-backup.tar /etc  # 打包并且压缩
tar cjf /tmp/etc-backup.tar.bz2 /etc  #这个压缩的更小

tar 打包命令
	常用参数
	c 打包
	x 解压
	f 指定操作类型为文件
	
tar xf /tmp/etc/backup.tar -C /root/   # -C 指定解压位置
```

# 16 vi的四种模式

- 多模式产生的原因
- 四种模式
   - 正常模式（Normal-mode） vi进入时候就是正常模式
   - 插入模式（insert-mode)  i 插入模式
   - 命令模式（command-mode)  按esc 正常模式  : 既是命令行模式
   - 可视模式（Visual-mode)   按esc 正常模式   ctrl + c   进入可视块模式  v 是可视模式

# 17 vim 正常模式

```
插入模式
    i 在当前位置进入插入模式
    I 在行首进入插入模式
    a 光标的后一位
    A 到行尾
    o 到下一行新建空行
    O 到上一行新建空行
正常模式
	h左 j下 k上 l右  移动
	hjkl   左下上右
	yy  复制当前行
	p    粘贴
	3yy  复制3行
	y$  光标到行尾 复制
	dd  剪切当前行
	d$  光标到行尾 剪切
	u 撤销
	ctrl + r 重做  反撤销(撤销的撤销)
	x  删除单个字符
	r  替换单个字符
	:set nu  显示行号
	5G 光标到指定行  5 shift+g
	gg 第一行
	G 最后一行
	^  行首
	$  行尾
```

# 18 vim的命令模式

```
:w /root/aa.txt   # 将文件保存
vim 文件名编辑的方式  :w  直接保存原始文件中了
:q!  不保存退出
:! ip a  #在编辑器临时执行命令看下结果，再次enter 回到编辑页面了
ctrl + z #把当前任务放入后台并且暂停
fg       #把后台任务调到前台继续执行

/任意字符   # 查找   n 向下查找  N 向上查找
:s/j/J/    # 在当前行j替换J
:%s/j/J/    # 所有行替换  j替换J |一行只替换一个（从左到右替换第一个）
:%s/j/J/g   # 全局替换，整个文本都会进行替换
:3,5s/j/J/g  # 3到5行j替换J  涉及到多次替换就全部替换  g是全局

echo "set nu " >> /etc/vimrc #vim配置文件添加显示行号命令
```

# 19 vim的可视模式

三种进入可视模式的方式

- v   字符可视模式
- V   行可视模式
- ctrl+v 块可视模式

配合d和(大写i)命令可以进行块的便利操作

```
批量在多行开头添加123
ctrl+v 进入块可视模式
光标选中所有行开头  然后shift+I 插入模式
输入123 这时候只看到第一行开头有123，再按esc 所有行都会加上123

批量删除一块
ctrl+v 进入块可视模式
光标选择需要删除的块
然后按d 键
```

# 20 用户和用户组管理

用户管理常用命令

```
useradd  新建用户
userdel  删除用户
passwd   修改用户密码
usermod  修改用户属性
chage    修改用户属性

id user  # 显示用户名信息
[root@con ~]# id root
uid=0(root) gid=0(root) groups=0(root)

[root@con ~]# useradd ckh
[root@con ~]# id ckh
uid=1000(ckh) gid=1000(ckh) groups=1000(ckh)
[root@con ~]# passwd ckh
Changing password for user ckh.
New password:
BAD PASSWORD: The password is a palindrome
Retype new password:
passwd: all authentication tokens updated successfully.

userdel -r ckh   # -r将家目录也删除了
usermod -d /home/w1 w  #修改w用户的家目录为 /home/w1
chage  # 更改用户密码过期信息

[root@ckh ckh]# groupadd group1
[root@ckh ckh]# useradd user1
[root@ckh ckh]# usermod -g group1 user1  #修改user1用户组为group1
[root@ckh ckh]# id user1
uid=1001(user1) gid=1001(group1) 组=1001(group1)

[root@ckh ckh]# useradd -g group1 user2
[root@ckh ckh]# id user2
uid=1002(user2) gid=1001(group1) 组=1001(group1)

[root@ckh ckh]# su - user1   # 完全切换用户
```

# 21 su 和 sudo

- su 切换用户
   - su - USERNAME  使用 login shell 方式切换用户
- sudo  以其他身份执行命令
   - visudo  设置需要使用sudo的用户（组）

```bash
visudo
user3 ALL=/sbin/shutdown -c

[root@ckh ckh]# shutdown -h 30
Shutdown scheduled for 四 2019-11-21 19:57:11 CST, use 'shutdown -c' to cancel.
[root@ckh ckh]# su - user3
上一次登录：四 11月 21 19:24:27 CST 2019pts/0 上
[user3@ckh ~]$ sudo /sbin/shutdown -c
我们信任您已经从系统管理员那里了解了日常注意事项。
总结起来无外乎这三点：

    #1) 尊重别人的隐私。
    #2) 输入前要先考虑(后果和风险)。
    #3) 权力越大，责任越大。

[sudo] user3 的密码：

Broadcast message from root@ckh (Thu 2019-11-21 19:24:57 CST):

The system shutdown has been cancelled at Thu 2019-11-21 19:25:57 CST!
```

# 22 用户和用户组的配置文件介绍

```
/etc/passwd
/etc/shadow
/etc/group
```

# 23 文件与目录权限的表示方法

-rw-r--r--  1 root root        9 5月   5 2019 demo3
类型  权限      所属用户和组                       文件名

## 文件类型

`-`  普通文件
`d`  目录文件
`b`  块特殊文件
`c`  字符特殊文件
`l`  符号链接
`f`  命名管道
`s`  套接字文件

## 文件权限的表示方法

- 字符权限表示方法
   - r 读
   - w 写
   - x 执行
- 数字权限的表示方法

- r = 4

- w = 2

- x = 1

-rw-r-xr-- 1 username groupname mtime filename

rw- 文件属主的权限
r-w  文件属组的权限
r--   其他用户的权限

创建新文件有默认权限，根据UMASK 值计算，属主和属组根据当前进程的用户来设定

## 目录权限的表示方法

`x`   进入目录
`rx`  显示目录内的文件名
`wx`  修改目录内的文件名

# 24 文件权限的修改方法和数字表示方法

```
chmod 修改文件、目录权限
	chmod u+x /tmp/testfile
	chmod 755 /tmp/testfile
chown  更改属主 属组
chgrp  可以单独更改属组，不常用

默认文件权限 666 减去 umask值 0022  = 644
```

# 25 权限管理以及文件的特殊权限

```
ls -ld /test
chmod 777 /test
touch test/afile
chown user1:group1 afile
chmod 400 afile
echo 123 > afile

touch /test/bfile
chmod 020 /test/bfile
```

特殊权限

- SUID	用于二进制可执行文件,执行命令时取得文件属主权限

如/usr/bin/ passwd     `chmod 4755 /test/bfile`
- SGID     用于目录,在该目录下创建新的文件和目录,权限自动更改为该目录的属组
- SBIT      用于目录,该目录下新建的文件和目录,仅root和自己可以删除

· 如 /tmp      `chmod 1777 /test`

# 26 网络管理

- 网络状态查看
- 网络配置
- 路由命令
- 网络故障排除
- 网络服务管理
- 常用网络配置文件

网络状态查看工具

net-tools VS iproute

1. net-tools
   - ifconfig
   - route
   - netstat
2. iproute2
   - ip
   - ss

```
ifconfig 
	eth0 第一块网卡（网络接口）
	你的第一个网络接口可能叫做下面的名字
	eno1   板载网卡
	ens33  PCI-E网卡
	enp0s3 无法获取物理信息的PCI-E网卡
	CentOS7 使用了一致性网络设备命名，以上都不匹配则使用eth0

网络接口命名修改
- 网卡命名规则受 biosdevname 和 net.ifnames 两个参数影响
- 编辑/etc/default/grub文件 增加 biosdevname=0 net.ifnames=0
- 更新grub
	- #grub2-mkconfig -o /boot/grub2/grub.cfg
- 重启
  - reboot
```
|  | biosdevname | net.ifnames | 网卡名 |
| :--- | :--- | --- | --- |
| 默认 | 0 | 1 | ens33 |
| 组合1 | 1 | 0 | em1 |
| 组合2 | 0 | 0 | eth0 |


# 27 查看网络配置

```
查看网卡物理连接情况
mii-tool eth0

# 查看网关
route -n
使用 -n 参数不解析主机名
```

# 28 网络配置命令

```
ifconfig <接口> <ip地址> [netmask 子网掩码]
ifup<接口>
ifdown<接口>

添加网关
route add default gw<网关ip>
route add -host<指定ip> gw<网关ip>
route add -net<指定网段> netmask<子网掩码> gw<网关ip>

网络命令集合：ip命令
ip add ls
	ifconfig
ip link set dev eth0 up
	ifup eth0
ip addr add 10.0.0.1/24 dev eth1
	ifconfig eth1 10.0.0.1 netmask 255.255.255.0
ip route add 10.0.0.0/24 via 192.168.0.1
	route add -net 10.0.0.0 netmask 255.255.255.0 gw 192.168.0.1
```

# 29 网络故障排除命令

- ping			 查看与目标主机网络是否通
- traceroute    追踪路由
- mtr               检查到目标主机是不是有数据包丢失
- nslookup       查看域名对应的ip
- telnet             检查主机的端口是不是开放
- tcpdump        抓取数据包
- netstat           查看网络连接信息和系统开启的端口号。
- ss

```bash
ping -c4 www.baidu.com
traceroute -w 1 www.baidu.com     #w 超时只等1秒
mtr   
nslookup www.baidu.com
telnet www.baidu.com 80   #退出方法 ctrl + 】 或者 ？+回车
tcpdump -i any -n port 80  # -i any 所有网络接口  -n 不解析用ip形式显示 port 端口80
tcpdump -i any -n host 10.0.0.1  # host 指定主机
tcpdump -i any -n host 10.0.0.1 and port 80 # 
tcpdump -i any -n host 10.0.0.1 and port 80 -w /tmp/filename # -w 指定结果保存位置
netstat -ntpl     # n 以ip显示 t tcp连接 p 显示进程号 l 监听状态
```

# 30 网络管理和配置文件

网络服务管理程序分为两种，分别为SysV和systemd

- service network start|stop|restart
- chkconfig -list network
- systemctl list-unit-files NetworkManager.service
- systemctl start|stop|restart NetworkManager
- systemctl enable|disable NetworkManger

网络配置文件

- ifcfg-eth0
- /etc/hosts

# 31 软件包管理器的使用

- 软件包管理器
- rpm包和rpm命令
- yum 仓库
- 源代码编译安装
- 内核升级
- grub 配置文件

软件包管理

- 包管理器是方便软件的安装、卸载、解决软件的依赖关系的重要工具
   - CentOS RedHat使用yum 包管理器，软件安装包格式为rpm
   - Debian Ubuntu使用apt 包管理器，软件安装包格式deb

# 32 使用rpm命令安装软件包

rpm 包格式

- vim-common-7.4.10-5.el7.x86_64.rpm

软件名称 软件版本 系统版本 平台

rpm 命令

- rpm 命令常用参数
   - -q 查询软件包
   - -i 安装软件包
   - -e 卸载软件包

```
dd if=/dev/sr0 of=/xx/xx.iso
mount /dev/sr0 /mnt
rpm -qa|more
```

# 33 使用yum 包管理器安装软件包

- rpm包的问题
   - 需要自己解决依赖关系
   - 软件包来源不可靠
- CentOS yum源
   - [http://mirror.centos.org/centos/7/](http://mirror.centos.org/centos/7/)
- 国内镜像
- [https://opsx.alibaba.com/mirror](https://opsx.alibaba.com/mirror)
- yum 配置文件
   - /etc/yum.repos.d/Centos-Base.repo
```
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

yum 命令常用选项

- install 安装软件包
- remove 卸载软件包
- list|grouplist 查看软件包
- update 升级软件包

# 34 通过源代码编译安装软件包

```

- 二进制安装
- 源代码编译安装
wget https://openresty.org/download/openresty-1.15.8.1.tar.gz
tar -zxf openresty-VERSION.tar.gz
cd openresty-VERSION/
./configure --prefix=/usr/local/openresty #匹配系统 设置配置
make -j2  #使用两个逻辑cpu编译
make install  #安装
```

# 35 如何进行内核升级

- rpm格式内核
   - 查看内核版本
      - uname -r
- 升级内核版本
   - yum install kernel-3.10.0
- 升级已安装的其他软件包和补丁
   - yum update

源代码编译安装内核

- 安装依赖包
   - yum install gcc gcc-c++ make ncurses-devel openssl-devel elfutils-libelf-devel
- 下载解压内核
   - [https://www.kernel.org](https://www.kernel.org)
   - tar xvf linux-5.1..10.tar.xz -C /usr/src/kernels

源码编译安装内核

- 配置内核编译参数
   - cd /usr/src/kernels/linux-5.1.10/
   - make menuconfig | allyesconfig | allnoconfig
- 使用当前系统内核配置
   - cp /boot/config-kernelversion.platform /usr/src/kernels/linux-5.1.10/.config
- 查看cpu
   - lscpu
- 编译
   - make -j2 all
- 安装内核
   - make modules_install
   - make install

升级当前系统最新版本

```
yum install epel-release
yum install kernel
```

# 36 grub 配置文件

- grub是什么
- grub配置文件
   - /etc/default/grub
   - /etc/grub.d/
   - /boot/grub2/grub.cfg
   - grub2-mkconfig -o /boot/grub2/grub.cfg
- 使用单用户进入系统(忘记root密码)  [https://www.cnblogs.com/chengkanghua/p/11996624.html](https://www.cnblogs.com/chengkanghua/p/11996624.html)

```
[root@oldboy linux-5.3.13]# grub2-set-default 0  #设置第一个内核为启动
[root@oldboy linux-5.3.13]# grub2-editenv list   #显示默认引导的是哪个内核
saved_entry=0

[root@agent-34-0 ~]# grep ^menu /boot/grub2/grub.cfg
```

#　37 使用ps和top命令查看进程

进程管理

- 进程的概念与进程查看
- 进程的控制命令
- 进程的通信方式--信号
- 守护进程和系统日志
- 服务管理工具 systemctl
- SELinux 简介

进程的概念

- 进程--运行中的程序， 从程序开始运行到终止的整个生命周期是可管理的
- c 程序的启动是从main 函数开始的
- int main(int agrc,char*argv[])
- 终止的方式并不唯一，分为正常终止和异常终止
   - 正常终止也分为从main返回，调用exit 等方式
   - 异常终止分为调用abort 、 接收信号等

进程的查看命令

- 查看命令
   - ps
   - pstree
   - top
- 结论：
   - 进程也是树形结构
   - 进程和权限有着密不可分的关系

# 38 进程的控制与进程之间的关系

进程的优先级调整

- 调整优先级
   - nice 范围从-20 到19 ，值越小优先级越高，抢占资源就越多
   - renice 重新设置优先级
- 进程的作业控制
   - jobs
   - & 符号

```
top -p 9603   		#根据pid查看
renice -n 15 9603   #调整优先级
top -p 9603 

jobs  #查看任务列表
fg 1 # 将第1个任务放到前台运行
bg 1 # 放着后台继续运行
ctrl + z #放在后台挂起
```

# 39 进程间通信方式与信号

- 信号是进程间通信方式之一,典型用法是:终端用户输入中断命令,通过信号机制停止一个程序的运行。
- 信号的常用快捷键和命令
- kill -L

·SIGINT 通知前台进程组终止进程 ctrl+C

·SIGKILL 立即结束程序,不能被阻塞和处理 KILL -9 pid

# 40 守护进程

- 使用 nohup与&符号配合运行一个命令
   - nohup命令使进程忽略 hangup(挂起)信号
- 守护进程(daemon)和一般进程有什么差别呢?
- 使用 screen命令
   - screen进入 screen 环境
   - ctrl+a d 退出(detached)screen 环境
   - screen -ls 查看 screen的会话
   - screen -r sessionid 恢复会话

```
# 关闭终端后依然在后台运行
[root@aliyun ckh]# nohup tail -f /var/log/messages &  
[1] 23673
[root@aliyun ckh]# nohup: 忽略输入并把输出追加到"nohup.out"
```

# 41 screen 和系统日志

```
screen 
screen -ls
screen -r 23721


[root@aliyun ~]# tail -f /var/log/dmesg  # 内核启动详细信息
[root@aliyun ~]# tail -f /var/log/secure # 系统的安全日志
[root@aliyun ~]# tail -f /var/log/cron   # 系统周期性任务
```

# 42 服务管理工具 systemctl

- 服务(提供常见功能的守护进程) 集中管理工具
   - service
   - systemctl
- systemctl 常见操作
   - systemctl start|stop|restart|reload|enable|disable 服务名称
   - 软件包安装的服务单元 /usr/lib/systemd/system/

```
[root@iotcontroll-centos-1 ~]# ll /lib/systemd/system/runlevel*.target
lrwxrwxrwx. 1 root root 15 Nov 28  2017 /lib/systemd/system/runlevel0.target -> poweroff.target
lrwxrwxrwx. 1 root root 13 Nov 28  2017 /lib/systemd/system/runlevel1.target -> rescue.target
lrwxrwxrwx. 1 root root 17 Nov 28  2017 /lib/systemd/system/runlevel2.target -> multi-user.target
lrwxrwxrwx. 1 root root 17 Nov 28  2017 /lib/systemd/system/runlevel3.target -> multi-user.target
lrwxrwxrwx. 1 root root 17 Nov 28  2017 /lib/systemd/system/runlevel4.target -> multi-user.target
lrwxrwxrwx. 1 root root 16 Nov 28  2017 /lib/systemd/system/runlevel5.target -> graphical.target
lrwxrwxrwx. 1 root root 13 Nov 28  2017 /lib/systemd/system/runlevel6.target -> reboot.target
[root@iotcontroll-centos-1 ~]# systemctl get-default
multi-user.target

[root@aliyun ~]# systemctl set-default multi-user.target
Removed symlink /etc/systemd/system/default.target.
Created symlink from /etc/systemd/system/default.target to /usr/lib/systemd/system/multi-user.target.
------------------------------------------------------------------------------
[root@aliyun system]# cat /lib/systemd/system/sshd.service
[Unit]
Description=OpenSSH server daemon
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target sshd-keygen.service
Wants=sshd-keygen.service

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/sshd
ExecStart=/usr/sbin/sshd -D $OPTIONS
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
------------------------------------------------------------------------------
```

# 43 SElinux 简介

- MAC (强制访问控制) 与 DAC (自主访问控制）
- 查看 SELinux的命令
   - getenforce
   - /usr/sbin/sestatus
   - ps -Z and ls -Z and id -Z
- 关闭 SELinux
   - setenforce o
   - /etc/selinux/sysconfig

# 44 内存和磁盘管理

- 内存和磁盘使用率查看
- ext4文件系统
- 磁盘配额的使用
- 磁盘的分区与挂载
- 交换分区(虚拟内存)的查看与创建
- 软件RAID的使用
- 逻辑卷管理
- 系统综合状态查看

# 45 内存查看命令

- 常用命令介绍
   - free
   - top
- 磁盘使用率的查看
   - fdisk
   - df
   - du
   - du 与 ls 的区别

# 46 磁盘分区和文件大小查看·

```bash
[root@vulcan ~]# parted -l
Model: VMware, VMware Virtual S (scsi)
Disk /dev/sda: 53.7GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start   End     Size    Type     File system     Flags
 1      1049kB  2149MB  2147MB  primary  linux-swap(v1)
 2      2149MB  53.7GB  51.5GB  primary  xfs             boot

[root@vulcan ~]# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2        48G  5.5G   43G  12% /
devtmpfs        981M     0  981M   0% /dev
tmpfs           991M     0  991M   0% /dev/shm
tmpfs           991M  8.6M  982M   1% /run
tmpfs           991M     0  991M   0% /sys/fs/cgroup
tmpfs           199M     0  199M   0% /run/user/0

[root@vulcan ~]# dd if=/dev/zero of=afile bs=4M count=10
10+0 records in
10+0 records out
41943040 bytes (42 MB) copied, 0.291936 s, 144 MB/s
[root@vulcan ~]# ls -lh afile
-rw-r--r-- 1 root root 40M Dec  9 14:18 afile
[root@vulcan ~]# du -h afile
40M	afile

[root@vulcan ~]# dd if=/dev/zero of=bfile bs=4M count=10 seek=20  
10+0 records in
10+0 records out
41943040 bytes (42 MB) copied, 0.292836 s, 143 MB/s
[root@vulcan ~]# ll -h bfile   #记录文件的开头到结尾的大小
-rw-r--r-- 1 root root 120M Dec  9 14:20 bfile
[root@vulcan ~]# du -h bfile   #记录文件的实际大小
40M	bfile

# 重新加载分区表  当把三个分区删除后重新分一个区之后使用
[root@vulcan ~]# partprobe /dev/sdb
```

# 47 文件系统管理

- linux 支持多种文件系统 常见的有
   - ext4
   - xfs
   - NTFS（需要安装额外软件）
- ext4 文件系统基本结构比较复杂
- 超级块
- 超级块副本
- i 节点（inode）
- 数据块（datablock）

```
[root@vulcan ~]# ll -i
```

# 48 i节点和数据块操作

```
[root@vulcan ~]# touch afile
[root@vulcan ~]# ls -li afile
33661483 -rw-r--r-- 1 root root 41943040 Dec  9 14:44 afile
[root@vulcan ~]# echo 1234 > afile
[root@vulcan ~]# ll -li afile     
33661483 -rw-r--r-- 1 root root 5 Dec  9 14:45 afile  #有一个换行符所以是5个字节
[root@vulcan ~]# du -h afile
4.0K	afile

[root@vulcan ~]# getfacl afile
# file: afile
# owner: root
# group: root
user::rw-
group::r--
other::r--

[root@vulcan ~]# setfacl -m u:user1:r afile   #赋予user1用户对afile只读权限
[root@vulcan ~]# ls -l afile
-rw-r--r--+ 1 root root 5 Dec  9 14:45 afile

[root@vulcan ~]# setfacl -m u:user2:rw afile
[root@vulcan ~]# setfacl -m g:group1:rw afile

[root@vulcan ~]# setfacl -x g:group1:rw afile  # x是收回权限
```

# 49 分区和挂载

磁盘分区与挂载

- 常用命令
   - fdisk
   - mkfs
   - parted
   - mount
- 常见配置文件
   - /etc/fstab

```
[root@vulcan ~]# fdisk /dev/sdb
Command (m for help): n
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-41943039, default 2048):
Last sector, +sectors or +size{K,M,G} (2048-41943039, default 41943039):
Command (m for help): p
Command (m for help): w

[root@vulcan ~]# fdisk -l
[root@vulcan ~]# mkfs.ext4 /dev/sdb1
[root@vulcan ~]# mount -t ext4 /dev/sdb1 /mnt/sdb1
```

# 50 分区和挂载磁盘配额

用户磁盘配额

- xfs文件系统的用户磁盘配额 quota
- mkfs.xfs /dev/sdb1
- mkdir /mnt/disk1
- mount -o uquota, gquota /dev/sdb /mnt/disk1
- chmod 1777 /mnt/disk1
- xfs_quota -x -c 'report -ugibh' /mnt/disk1
- xfs_quota -x -c 'limit -u isoft=5 ihard=10 user1' /mnt/disk1

```
[root@vulcan ~]# mkfs.xfs /dev/sdb1
[root@vulcan ~]# mkfs.xfs /dev/sdb1 -f
[root@vulcan ~]# mount -o uquota,gquota /dev/sdb1 /mnt/disk1
[root@vulcan ~]# xfs_quota -x -c 'report -ugibh' /mnt/disk1
[root@vulcan ~]# id user1
[root@vulcan ~]# xfs_quota -x -c 'limit -u isoft=5 ihard=10 user1' /mnt/disk1

[root@vulcan ~]# su - user1
[user1@vulcan ~]$ cd /mnt/disk1
[user1@vulcan disk1]$ touch 1 2 3 4 5
[user1@vulcan disk1]$ touch 6
[user1@vulcan disk1]$ touch 7 8 9 10
[user1@vulcan disk1]$ touch 11
touch: cannot touch ‘11’: Disk quota exceeded  #超出磁盘限额
```

# 51 交换分区 swap的查看与创建

- 增加交换分区的大小
   - mkswap
   - swapon
- 使用文件制作交换分区
   - dd if=/dev/zero bs=4M count=1024 of=/swapfile

```
[root@vulcan ~]# fdisk /dev/sdb1
Command (m for help): n
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-41940991, default 2048):
Last sector, +sectors or +size{K,M,G} (2048-41940991, default 41940991):
Command (m for help): w

[root@vulcan ~]# ll /dev/sdb1
[root@vulcan ~]# mkswap /dev/sdb1   #设置为swap分区
[root@vulcan ~]# swapon /dev/sdb1  # 开启
[root@vulcan ~]# swapoff /dev/sdb1 # 关闭

[root@vulcan ~]# dd if=/dev/zero bs=4M count=1024 of=/swapfile
[root@vulcan ~]# mkswap /swapfile
[root@vulcan ~]# chmod 600 /swapfile
[root@vulcan ~]# swapon /swapfile

# 永久挂在swap
vi /etc/fstab
/swapfile swap swap default 0 0
```

# 52 软件RAID的使用

- RAID 的常见级别及含义
   - RAID 0 striping 条带方式，提高单盘吞吐率
   - RAID 1 mirroring 镜像方式， 提高可靠性
   - RAID 5 有奇偶校验
   - RAID 10  是RAID 1 与 RAID 0 的结合
- 软件 RAID的使用

```
[root@vulcan ~]# yum install mdadm -y

#提前3个分区一样大小的。
[root@vulcan ~]# ll /dev/sdb?
brw-rw----. 1 root disk 8, 17 Dec 11 17:23 /dev/sdb1
brw-rw----. 1 root disk 8, 18 Dec 11 17:23 /dev/sdb2
brw-rw----. 1 root disk 8, 19 Dec 11 17:23 /dev/sdb3
# 软件raid 1创建 l1
[root@vulcan ~]# mdadm -C /dev/md0 -a yes -l1 -n2 /dev/sdb[1,2]
# 查看raid 信息
[root@vulcan ~]# mdadm -D /dev/md0
#开机自动加载软件raid
[root@vulcan ~]# echo DEVICE /dev/sdb[1,2] >> /etc/mdadm.conf
[root@vulcan ~]# mdadm -Evs >> /etc/mdadm.conf
[root@vulcan ~]# mkfs.xfs /dev/md0

#停止运行RAID	
[root@vulcan ~]# mdadm -S /dev/md0
cat /dev/null > /etc/mdadm/mdadm.conf  #删除配置文件
mdadm --zero-superblock /dev/sdb[1,2]  #删除元数据
```

# 53 逻辑卷LVM的用途与创建

逻辑卷管理

- 逻辑卷和文件系统的关系
- 为linux创建逻辑卷
- 动态扩容逻辑卷

```bash
[root@vulcan ~]# pvcreate /dev/sdb[1,2,3] #创建3个物理卷
[root@vulcan ~]# pvs   #查看已经创建的物理卷
[root@vulcan ~]# vgcreate vg1 /dev/sdb1 /dev/sdb2  # 把sdb1 sdb2 加入到vg1 卷组
[root@vulcan ~]# vgcreate centos /dev/sdb3
[root@vulcan ~]# pvs
[root@vulcan ~]# vgs   #查看卷组信息

[root@vulcan ~]# vgs
  VG     #PV #LV #SN Attr   VSize   VFree
  centos   1   0   0 wz--n-  <6.60g  <6.60g
  vg1      2   0   0 wz--n- <13.20g <13.20g   //2个物理卷 0 个逻辑卷

# 创建逻辑卷 -l 大小  -n 名字  vg1 卷组
[root@vulcan ~]# lvcreate -L 100M -n lv1 vg1  
[root@vulcan ~]# lvs   #查看逻辑卷
[root@vulcan ~]# mkdir /mnt/test
[root@vulcan ~]# mkfs.xfs /dev/vg1/lv1   #格式lv1逻辑卷
[root@vulcan ~]# mount /dev/vg1/lv1 /mnt/test

# 将/dev/sdb3扩充到vg1上    #物理卷大小扩充了，再去扩展逻辑卷
[root@vulcan ~]# vgextend vg1 /dev/sdb3

[root@vulcan ~]# pvs  物理卷
  PV         VG     Fmt  Attr PSize  PFree
  /dev/sdb1  vg1    lvm2 a--  <6.60g  6.50g
  /dev/sdb2  vg1    lvm2 a--  <6.60g <6.60g
  /dev/sdb3  centos lvm2 a--  <6.60g <6.60g
[root@vulcan ~]# vgs  物理卷组
  VG     #PV #LV #SN Attr   VSize   VFree
  centos   1   0   0 wz--n-  <6.60g  <6.60g
  vg1      2   1   0 wz--n- <13.20g <13.10g
[root@vulcan ~]# lvs   逻辑卷
  LV   VG  Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lv1  vg1 -wi-ao---- 100.00m
# 为lv1 逻辑卷增加5G 这个时候df 查看分区并没有扩大
[root@vulcan ~]# lvextend -L +5G /dev/vg1/lv1
# 通知文件系统扩大分区
[root@vulcan ~]# xfs_growfs /dev/vg1/lv1
```

# 54 系统综合状态查看命令 sar以及第三方命令

- 使用sar命令查看系统综合状态
- 使用第三方命令查看网络流量
   - yum install epel-release
   - yum install iftop
   - ftop -p

```
[root@vulcan ~]# yum install syssteat
# -u 查看cpu使用情况  1秒一次  显示10次
[root@vulcan ~]# sar -u 1 10
# 查看内存读写情况
[root@vulcan ~]# sar -r 1 10
# 查看磁盘 io情况
[root@vulcan ~]# sar -b 1 10
# 查看每块磁盘的读写
[root@vulcan ~]# sar -d 1 10
# 查看进程的使用情况
[root@vulcan ~]# sar -q 1 10
# 查看网路使用情况
[root@vulcan ~]# iftop -p
```

#　55 认识shell

- 什么是shell
- linux 的启动过程
- 怎样编写一个shell脚本
- shell 脚本的执行方式
- 内建命令和外部命令的区别

什么是shell

- shell 是命令解释器，用于解释用户对操作系统的操作
- shell 有很多
   - cat /etc/shells
- Centos 7 默认使用的Shell是bash

# 56 linux 的启动过程

- BIOS-MBR-BootLoader(grub)-kernel-systemd-系统初始化-shell

```bash
[root@vulcan ~]# dd if=/dev/sda2 of=/mbr.bin bs=446 count=1
[root@vulcan ~]# hexdump -C /mbr.bin

[root@vulcan ~]# ls /boot/grub2/
[root@vulcan ~]# grub2-editenv list

[root@vulcan ~]# which init
/usr/sbin/init
  --> /etc/rc.d 
[root@vulcan ~]# top -p 1
    cd /etc/systemd/system/
     --> /usr/lib/systemd/system/
```

# 57 shell脚本的格式

shell 脚本

- UNIX的哲学 : 一条命令只做一件事
- 为了组合命令和多次执行，使用脚本文件来保存需要执行的命令
- 赋予该文件执行权限（chmod u+rx filename）

```
[root@vulcan var]# cd /var/ ;ls;pwd;du -sh |du -sh *
[root@vulcan ~]# cat 1.sh
#!/bin/bash
# demo
cd /var/
ls
pwd
du -sh
du -sh *
[root@vulcan ~]# chmod +x 1.sh
```

标准的shell 脚本要包含哪些元素

- Sha-Bang
- 命令
- “#”号开头的注释
- chmod u+rx filename可执行权限
- 执行命令
   - bash ./filename.sh
   - ./filename.sh
   - source /filename.sh
   - filename.sh

# 58脚本的不同执行方式的影响

```
bash ./filename.sh  #产生一个子进程
./filename.sh       #产生一个子进程 用Sha-Bang 解释执行的
source /filename.sh # 在当前进程执行
filename.sh  #是source 的简写
```

内建命令和外部命令的区别

- 内建命令不需要创建子进程
- 内建命令对当前shell生效

注意: 脚本是不是要对当前环境产生影响。？
需要的话用 source 来执行脚本
不需要   ./   方式来运行

# 60 | 重定向

重定向符号

- 一个进程默认会打开标准输入、标准输出、错误输岀三个文件描述符
- 输入重定向符号 “ <”
   - read var </path/to/a/file
- 输出重定向符号 “>" “>" “2>” “&>′
   - echo 123>/path/to/a/file
- 输入和输出重定向组合使用

cat>/path/to/a/file<< EOF

I am $USER

EOF

```
[root@aliyun ckh]# wc -l < /etc/passwd
[root@aliyun ckh]# echo 123 >a.txt
[root@aliyun ckh]# read var2 < a.txt
[root@aliyun ckh]# echo $var2
[root@aliyun ckh]# echo $var2 > b.txt
[root@aliyun ckh]# echo $var2 >> b.txt
[root@aliyun ckh]# nocomd 2> err.log   #错误重定向
[root@aliyun ckh]# ls &> err.log  #全部重定向 错误正确都


[root@aliyun ckh]# cat 1.sh
#!/bin/bash
cat > /root/a.sh <<EOF
echo "hello bash"
EOF
[root@aliyun ckh]# sh 1.sh
[root@aliyun ckh]# cat /root/a.sh
echo "hello bash"
```

# 61 变量赋值

变量赋值

- 变量的定义
- 变量的赋值
- 变量的作用
- 变量的作用范围
- 系统环境变量
- 环境变量配置文件

变量定义
- 字母 数字 下划线
- 不以数字开头

变量的赋值

- 为变量赋值的过程，称为变量替换
   - 变量名=变量值
      - a=123
   - 使用let 为变量赋值
      - let a=10+20
   - 将命令赋值给变量
      - l=ls
   - 将命令结果赋值给变量，使用$()或者``
      - let=$(ls -l /etc)
   - 变量值有空格等特殊字符可以包含在" " 或'' 中

# 62 变量引用及作用范围

- 变量的引用
   - ${变量名} 称作对变量的应用
   - echo ${变量名} 查看变量的值
   - ${变量名} 在部分情况下可以省略为 $变量名

# 63 环境变量，预定义变量与位置变量

```
系统环境变量
- 环境变量: 每个shell 打开都可以获得到的变量
	- set 和 env 命令
	- $? $$ $0
	- $PATH
	- $PS1
- 位置变量
	- $1 $2 ....$n
	
----------------------------
PATH=$PATH:/root/
echo $PS1
echo $?  #返回上条命令是否成功
echo $$  # 当前进程pid
echo $0  # 当前运行的程序 文件
$1 $2 ...$9  ${10} #$10要加{}
```

# 64 环境变量配置文件

配置文件
- /etc/profile
- /etc/profile.d/
- ~/.bash_profile
- ~/.bashrc
- /etc/bashrc

# 65 数组

- 定义数组
   - IPTS=( 10.0.0.1 10.0.0.2 10.0.0.3 )
- 显示数组的所有元素
   - echo ${IPTS[@]}
- 显示数组元素个数
   - echo ${#IPTS[@]}
- 显示数组的第一个元素
   - echo ${IPTS[0]}

```
[root@aliyun ~]# IPTS=( 10.0.0.1 10.0.0.2  10.0.0.3 )
[root@aliyun ~]# echo ${IPTS[@]}
10.0.0.1 10.0.0.2 10.0.0.3
[root@aliyun ~]# echo ${#IPTS[@]}
3
[root@aliyun ~]# echo ${IPTS[0]}
10.0.0.1
[root@aliyun ~]# echo ${IPTS[2]}
10.0.0.3
```

# 66 转义和引用

- 特殊字符
- 转义
- 引用

特殊字符： 一个字符不仅有字面的意义，还有元意（meta-meaning）
- `#`注释
- ;分号
- \转义符号
- "" '' 单双引号

转义符号 单个字符前的转义符号
- \n \r \t 单个字母的转义
- $\” \  单个非字母的转义

```
[root@aliyun ~]# echo "$a"

[root@aliyun ~]# echo "\$a"
$a
[root@aliyun ~]# echo " abc"x"edf "
 abcxedf
[root@aliyun ~]# echo " abc\"x\"edf "
 abc"x"edf
```

常用的引用符号

- " 双引号"
- ‘ 单引号
- ` 反引号

```
[root@aliyun ~]# var1=123
[root@aliyun ~]# echo '$var1'
$var1
[root@aliyun ~]# echo "$var1"
123
```

# 67 运算符

- 赋值运算符
- 算数运算符
- 数字常量
- 双圆括号

赋值运算符

- = 赋值运算符 ，用于常量赋值和字符串赋值
- 使用 unset 取消变量的赋值
- = 除了作为赋值运算符还可以作为测试操作符

算数运算符
- 基本运算符
- + - * / ** %
- 使用expr 进行运算
- expr 4 + 5

数字常量
- let "变量名=变量值"
- 变量值使用0 开头为八进制
- 变量值使用 0x 开头为十六进制

双圆括号是 let 命令的简化
- (( a = 10 ))
- (( a++ ))
- echo $((10+20))

```
[root@aliyun ~]# num1=`expr 4 + 5 `
[root@aliyun ~]# echo  $num1
9
[root@aliyun ~]# ((a=4+8))
[root@aliyun ~]# echo $a
12
```

# 68 特殊字符大全

- 引号
- 括号
- 运算和逻辑符号
- 转义符号
- 其他符号

引号
- ‘ 完全引用
- “ 不完全引用
- ` 执行命令

括号

- () (()) $() 圆括号
   - 单独使用圆括号会产生一个子shell（xyz=123）
   - 数组初始化 IPS=（ip1 ip2 ip3）
- [] [[]] 方括号
   - 单独使用方括号表示测试（test） 或数组元素功能
   - 两个方括号表示测试表达式
- <> 尖括号 重定向符号
- {} 花括号
   - 输出范围 echo {0..9}
   - 文件复制 cp /etc/passwd{,.bak}

运算符和逻辑符号

- `+ - * / %` 算数运算符
- `> < =`比较运算符
- `&& || ！` 逻辑运算符

```
[root@aliyun ~]# (( 5 > 4 && 6 > 5))
[root@aliyun ~]# echo $?
0
[root@aliyun ~]# (( 5 > 4 && 6 < 5))
[root@aliyun ~]# echo $?
1
[root@aliyun ~]# ((! 5 > 4))
[root@aliyun ~]# echo $?
1
```

转义符号

- \ 转义某字符
   - \n 普通字符转义之后有不同的功能
   - ' 特殊字符转义之后，当做普通字符来使用

其他符号
- `#` 注释符
- `;` 命令分隔符
- case 语句的分隔要转义;;
- `:` 空指令
-  . 和source 命令相同
-  ～ 家目录
-  ，分隔目录

- `*` 通配符
- ？ 条件测试 或 通配符
- $ 取值符号
- | 管道符
- & 后台运行
- _ 空格

# 69 test 比较

测试与判断
- 退出与退出状态
- 测试命令test
- 使用 if-then 语句
- 使用 if-then-else 语句
- 嵌套if的使用

退出程序命令
- exit
- exit 10 返回10给Shell, 返回值非0位不正常退出
- $? 判断当前Shell前一个进程是否正常退出

测试命令 test
- test 命令用于检查文件或者比较值
- test 可以做以下测试：
- 文件测试
- 整数比较测试
- 字符串测试
- test 测试语句可以简化为[]符号
- []符号还有扩展写法[[]] 支持 && || < >

```
man test
[root@aliyun ~]# test -f /etc/passwd
[root@aliyun ~]# echo $?
0
[root@aliyun ~]#  0 True  1 False   # 和在数学里的说法相反。
[root@aliyun ~]# [ -d /etc/ ]  #是目录并且存在 返回0
[root@aliyun ~]# echo $?
0
[root@aliyun ~]# [ -e /etc/ ]  # 无论是文件还是目录 只要存在就返回0
[root@aliyun ~]# echo $?
0
[root@aliyun ~]# [ 5 -gt 4 ]  # -gt 大于 -lt 小于 -eq 等于 -ge 大于等于 -le 小于等于
[root@aliyun ~]# echo $?
0
[root@aliyun ~]# [[ 5 > 4 ]]   #使用> 符号 就要改成 [[]]
```

# 70 if 判断的使用

使用if-then 语句
if-then语句的基本用法
if[ 测试条件成立 ] 或 命令返回值是否为0
then 执行相应命令
fi 结束

```
[root@aliyun ~]# if [ $UID = 0 ]
> then
> echo "root user"
> fi
root user

[root@aliyun ~]# if pwd; then echo "pwd running"; fi
/root
pwd running
```

# 71 if-else判断的使用

if-then-else 语句可以在条件不成立时也运行相应的命令
if [ 测试条件成立 ]
then 执行相应命令
else 测试条件不成立，执行相应命令
fi 结束

```bash
[root@aliyun ~]# sh ifelse.sh
user root
[root@aliyun ~]# cat ifelse.sh
#!/bin/bash

if [ $USER = root ];then
	echo "user root"
else
	echo "other user"
fi

[root@aliyun ~]# cat ifelse.sh
#!/bin/bash

if [ $USER = root ];then
	echo "user root"
	echo $UID
else
	echo "other user"
	echo $UID
fi
```

if-then-else 语句可以在条件不成立时也运行相应的命令
if [ 测试条件成立 ]
then 执行相应命令
elif [ 测试条件成立 ]
then 执行相应命令
else 测试条件不成立，执行相应命令
fi 结束

```bash
[root@aliyun ~]# cat 10.sh
#!/bin/bash
if [ $USER = root ] ;then
	echo "root"
elif [ $USER = user1 ] ;then
	echo "user1"
else
	echo "other user"
fi
```

# 72 嵌套if的使用

if条件测试中可以再嵌套if条件测试
if [ 测试条件成立 ]
then 执行相应命令
if [测试条件成立]
then 执行相应命令
fi
fi 结束

```
[root@aliyun ~]# cat 11.sh
#!/bin/bash

if [ $UID = 0 ];then
	echo "please run"
	if [ -x /root/10.sh ] ; then
		/root/10.sh
	fi
else
	echo " switch user root"
fi
```

# 73 case分支

分支

- case 语句和select 语句可以构成分支

case "$变量" in

"情况1")

命令....;;

"情况2")

命令....;;

* )

命令...;;

esac

```
[root@aliyun ~]# chmod +x 12.sh
[root@aliyun ~]# ./12.sh start
./12.sh start.....
[root@aliyun ~]# cat 12.sh
#!/bin/bash
case "$1" in
	"start"|"START")
	 echo $0 start.....
	;;
	"stop")
	echo $0 stop.....
	;;
	"restart"|"reload")
	echo $0 restart....
	;;
	*)
	echo "Usage: $0 {start|stop|restart|reload}"
	;;
esac
```

# 74 for的基本使用

循环

- 使用for循环遍历命令的执行结果
- 使用for循环遍历变量和文件的内容
- C语言风格的for命令
- while 循环
- 死循环
- until 循环
- break 和 continue语句
- 使用循环对命令行参数处理

使用for循环遍历命令的执行结果

```bash
- for 循环的语法
	for 参数 in 列表
	do 执行的命令
	done 封闭一个循环
	
- 使用反引号或$() 方式执行命令，命令的结果当作列表进行处理
```

使用for循环遍历变量和文件的内容

- 列表中包含多个变量，变量用空格分隔
- 对文本处理，要使用文本查看命令取出文本内容
   - 默认逐行处理，如果文本出现空格会当做多行处理

```
[root@aliyun ~]# for i in {1..9}; do echo hello; echo $i;done

[root@aliyun tmp]# touch a.mp3 b.mp3 c.mp3
[root@aliyun tmp]# for filename in `ls *.mp3` ; do mv $filename $(basename $filename .mp3).mp4 ;done
[root@aliyun tmp]# ls
a.mp4  b.mp4  c.mp4
```

# 75 c语言风格的for

```
for((变量初始值;循环判断条件;变量变化))
do
	循环执行命令
done
-----------------------------------------------------------------------
[root@aliyun tmp]# for (( i=1; i<=10; i++))
> do
>     echo $i
> done
```

# 76 while 循环 和 until循环

死循环

```bash
while test测试是否成立
do
	命令
done
```

until 循环

- until 循环与while循环相反，循环测试为假时，执行循环，为真时循环停止

```

[root@agent1 ~]# a=1
[root@agent1 ~]# while [ $a -lt 10 ]; do ((a++)); echo $a;done

[root@aliyun tmp]# while :;do echo always; done
[root@aliyun tmp]# until [ 5 -lt 4 ]; do echo always;done
```

# 77 循环的嵌套和break  continue语句

循环的使用

- 循环和循环可以嵌套
- 循环中可以嵌套判断，反过来也可以嵌套
- 循环可以使用break 和 continue 语句中循环中退出

```bash
[root@aliyun ~]# for sc_name in /etc/profile.d/*.sh; do     echo $sc_name; done

[root@aliyun ~]# for sc_name in /etc/profile.d/*.sh
> do
>     if [ -x $sc_name ];then
>       . $sc_name
>     fi
> done
# break 跳出循环后面的不执行了
[root@aliyun ~]# for num in {1..9}; do    if [ $num -eq 5 ];then break; fi; echo $num;done

# continue 跳出本次执行，后续继续执行
[root@aliyun ~]# for num in {1..9}; do    if [ $num -eq 5 ];then continue; fi; echo $num;done
```

# 78 使用循环处理位置参数

- 命令行参数可以使用 $1 $2 ...${10}...$n 进行读取
- $0 代表脚本名称
- $*和$@ 代表所有位置参数
- $# 代表位置参数的数量

```bash
[root@aliyun ~]# sh 16.sh 1 2 34 5 help
help help
[root@aliyun ~]# cat 16.sh
#!/bin/bash

for pos in $*
do
	if [ "$pos" = "help" ]; then
		echo $pos $pos
	fi
done


[root@aliyun ~]# sh 16.sh 1 2 3 45 help
help help
[root@aliyun ~]# cat 16.sh
#!/bin/bash
while [ $# -ge 1 ]
do
	if [ "$1" = "help" ];then
		echo $1 $1
	fi
	shift
done
```

# 79 自定义函数

函数

- 自定义函数
- 系统脚本

自定义函数

```bash
- 函数用于“包含” 重复使用的命令集合
- 自定义函数
	function fname(){
		命令
	}
- 函数的执行
	fname

[root@aliyun ~]# function cdls(){
> cd /var
> ls
> }
[root@aliyun ~]# cdls
[root@aliyun var]# unset cdls

- 函数的作用范围的变量
	local 变量名
- 函数的参数
	$1 $2 $3 ...$n

[root@aliyun var]# cdls() {
> cd $1
> ls
> }
[root@aliyun var]# cdls /tmp

[root@aliyun tmp]# source 14.sh
[root@aliyun tmp]# checkpid 1 2
[root@aliyun tmp]# echo $?
0
[root@aliyun tmp]# checkpid 5433333
[root@aliyun tmp]# echo $?
1
[root@aliyun tmp]# cat 14.sh
#!/bin/bash

checkpid(){
	local i
	for i in $* ;do
		[ -d "/proc/$i" ] && return 0
	done
	return 1

}
```

# 80 系统函数库介绍

系统脚本

- 系统自建立函数库，可以在脚本中引用

/etc/init.d/functions
- 自建函数库

使用source 函数脚本文件 “导入” 函数

```bash
[root@aliyun tmp]# source /etc/init.d/functions
[root@aliyun tmp]# echo_success
[root@aliyun tmp]#                                         [  确定  ]
```

# 81 脚本资源控制

- 脚本优先级控制
- 捕获信号

脚本优先级控制

- 可以使用 nice 和 renice 调整脚本优先级
- 避免出现 “不可控的” 死循环
   - 死循环导致cpu占用过高
   - 死循环导致死机

```bash
[root@aliyun tmp]# ulimit -a

# 最为精简的一个Linux Fork炸弹
:(){:|:&};:
[root@aliyun tmp]# func() {func | func&};func
```

# 82 信号

蒱获信号脚本的编写

- kill 默认会发送15号信号给应用程序
- ctrl + c 发送2号信号给应用程序
- 9号信号不可阻塞

```bash
[root@aliyun tmp]# cat 15.sh
#!/bin/bash
# signal demo  这个脚本只能用kill -9杀掉
trap "echo sig 15" 15  # kill默认就是15信号
trap "echo sig 2" 2  #捕获signal 2号信号 也就是ctrl+c
echo $$

while :
do
  :
done
```

# 83 一次性计划任务

计划任务

- 一次性计划任务 at
- 周期性计划任务
- 计划任务加锁 flock

一次性计划任务

- 计划任务： 让计算机在指定的时间运行程序
- 计划任务分为： 一次性计划任务 周期性计划任务
- 一次性计划任务

at

```
[root@aliyun tmp]# date
2019年 12月 26日 星期四 14:13:31 CST
[root@aliyun tmp]# at 14:15
at> echo hello > /tmp/hello.log
at> <EOT>  # ctrl + d 结束
job 2 at Thu Dec 26 14:15:00 2019
```

# 84周期性计划任务

cron
- 配置方法
crontab -e
- 查看现有的计划任务
crontab -l
- 配置格式：
分钟 小时 日期 月份 星期 执行的命令
注意命令的路径问题

```bash
[root@aliyun tmp]# crontab -e
[root@aliyun tmp]# crontab -l
* * * * * /usr/bin/date >> /tmp/date.txt   #每分钟执行一次

[root@aliyun tmp]# tail -f /var/log/cron

[root@aliyun tmp]# crontab -l
0 3 * * 1 /usr/bin/date >> /tmp/date.txt  #每个星期一 3点整执行
[root@aliyun tmp]# ls /var/spool/cron/
root
```

# 85 为脚本加锁

计划任务加锁

- 如果计算机不能按照预期时间运行
   - anacontab 延时计划任务
   - flock 锁文件

```
[root@aliyun tmp]# cat /root/tmp/15.sh
#!/bin/bash
# long time
sleep 100000

[root@aliyun tmp]# chmod +x /root/tmp/15.sh
[root@aliyun tmp]# flock -xn "/tmp/f.lock" -c "/root/tmp/15.sh"



^C
[root@aliyun tmp]# flock -xn "/tmp/f.lock" -c "/root/tmp/15.sh" #锁文件在不会再次执行
[root@aliyun tmp]#
```

# 86 元字符介绍

正则表达式与文本搜索

- 元字符
- 扩展元字符
- 文件的查找命令find
- 文本内容的过滤（查找） grep

正则表达式的匹配方式

- 字符串 Do one thing at a time,and do well
- 匹配字符 an

元字符

- . 匹配除换行符外的任意单个字符
- 

   - 匹配任意一个跟它前面的字符
- [] 匹配方括号中的字符类中的任意一个
- ^ 匹配开头
- $ 匹配结尾
- \ 转义后面的特殊字符

```bash
[root@vulcan ~]# grep password /root/anaconda-ks.cfg
# Root password
[root@vulcan ~]# grep pass.... /root/anaconda-ks.cfg
auth --enableshadow --passalgo=sha512
# Root password
[root@vulcan ~]# grep pass....$ /root/anaconda-ks.cfg
# Root password
[root@vulcan ~]# grep pass.* /root/anaconda-ks.cfg
auth --enableshadow --passalgo=sha512
# Root password
[root@vulcan ~]# grep pass.*$ /root/anaconda-ks.cfg
auth --enableshadow --passalgo=sha512
# Root password
[root@vulcan ~]# # grep [Hh]ello hello Hello
[root@vulcan ~]# # grep ^# anaconda-ks.cfg
[root@vulcan ~]# # grep "\." anaconda-ks.cfg
```

# 87 find 演示

- 

   - 匹配前面的正则表达式至少出现一次
- ？匹配前面的正则表达式出现零次或一次
- | 匹配它前面或后面的正则表达式

文件查找命令

- 文件查找命令 find
   - find 路径 查找条件【补充条件】

```bash
[root@vulcan ~]# cd /etc/
[root@vulcan etc]# find passwd
passwd
[root@vulcan etc]# find /etc -name passwd

[root@aliyun ~]# find /etc -name pass*

[root@aliyun ~]# find /etc -regex .*wd
/etc/passwd
/etc/pam.d/passwd
/etc/security/opasswd
[root@aliyun ~]# find /etc -regex .etc.*wd$
[root@aliyun ~]# find /etc -type f -regex .*wd

[root@aliyun ~]# echo 123 > filea
[root@aliyun ~]# stat filea
  文件："filea"
  大小：4         	块：8          IO 块：4096   普通文件
设备：fd01h/64769d	Inode：676717      硬链接：1
权限：(0644/-rw-r--r--)  Uid：(    0/    root)   Gid：(    0/    root)
最近访问：2019-12-26 18:38:35.277424931 +0800
最近更改：2019-12-26 18:38:34.154431302 +0800
最近改动：2019-12-26 18:38:34.154431302 +0800
创建时间：-
[root@aliyun ~]# LANG=c stat filea

[root@aliyun ~]# # -user root -uid 0
[root@aliyun ~]# cd tmp
[root@aliyun tmp]# touch {1..9}.txt
[root@aliyun tmp]# # find *.txt
[root@aliyun tmp]# find *.txt -exec rm -v {} \;

[root@vulcan etc]# grep pass /root/anaconda-ks.cfg |cut -d " " -f 1
[root@vulcan etc]# grep pass /root/anaconda-ks.cfg |cut -d " " -f 2
[root@vulcan etc]# cut -d ":" -f7 /etc/passwd | uniq -c
[root@vulcan etc]# cut -d ":" -f7 /etc/passwd |sort|uniq -c
[root@vulcan etc]# cut -d ":" -f7 /etc/passwd |sort |uniq -c| sort -r
```

# 88 sed和awk介绍

行编辑器介绍

- vim 和 sed 、 awk 区别
- sed 的基本用法演示
- awk 的基本用法演示

vim和sed awk区别

- 交互式与非交互式
- 文件操作模式与行操作模式

sed 基本用法
sed 一般用于都于对文本内容做替换
sed '/user1/s/user1/u1/' /etc/passwd

awk 基本用法
awk 一般用于对文本内容进行统计、按需要的格式进行输出
cut 命令: cut -d: -f 1 /etc/passwd
awk 命令： awk -F: '/wd$/{print $1}' /etc/passwd

# 89 替换命令讲解

- sed 的模式空间
- 替换命令 s

sed 的模式空间
sed 的基本工作方式是:
- 将文件以行为单位读取到内存(模式空间)
- 使用sed的每个脚本对该行进行操作
- 处理完成后输出该行

sed 的替换命令
sed 's/old/new/' filename
sed -e 's/old/new/' -e 's/old/new/' filename ...
sed -i 's/old/new/' 's/old/new/' filename ...

带正则表达式的替换命令s：
sed 's/正则表达式/new/' filename
sed -r 's/扩展正则表达式/new/' filename

```bash
[root@aliyun tmp]# cat afile
a a a
[root@aliyun tmp]# sed 's/a/aa/' afile
aa a a
[root@aliyun tmp]# sed 's/a/aa/g' afile
aa aa aa
[root@aliyun tmp]# sed 's!/!abc!' afile  # 把/ 线替换成abc
[root@aliyun tmp]# sed -e 's/a/aa/' -e 's/aa/bb/' afile
bb a a
[root@aliyun tmp]# sed 's/a/aa/;s/aa/bb/' afile
[root@aliyun tmp]# sed -i 's/a/aa/;s/aa/bb/' afile  # -i真实改变文件内容
[root@aliyun tmp]# sed 's/a/aa/;s/aa/bb/' afile > bfile
[root@aliyun tmp]# cat bfile
bb a a

[root@aliyun tmp]# head -5 /etc/passwd | sed 's/...//'
[root@aliyun tmp]# head -5 /etc/passwd | sed 's/s*bin//'
[root@aliyun tmp]# grep root /etc/passwd|sed 's/^root//'
[root@aliyun tmp]# cat bfile
b
a
aa
aaa
ab
abb
abbb
[root@aliyun tmp]# sed 's/ab*/!/' bfile   # *表示匹配前面的出现0或者多次
[root@aliyun tmp]# sed -r 's/ab+/!/' bfile # + 表示匹配前面字符1次多次
[root@aliyun tmp]# sed -r 's/ab?/!/' bfile # 表示匹配前面出现0次或者1次

#匹配 a或者b
[root@aliyun tmp]# sed -r 's/a|b/!/' bfile
#匹配 aa或者bb 两个字符需要用()
[root@aliyun tmp]# sed -r 's/(aa)|(bb)/!/' bfile

[root@aliyun tmp]# echo axyzb >cfile
[root@aliyun tmp]# sed -r 's/(a.*b)/\1:\1/' cfile #反相调用
axyzb:axyzb
```

# 90 sed指令加强版

sed 的替换命令加强版

- 全局替换
- 标志位
- 寻址
- 分组
- sed 脚本文件

全局替换
- s/old/new/g
g 为全局替换，用于替换所有出现的次数
/ 如果和正则匹配的内容冲突可以使用其他符号，如：
s@old@new@g

```bash
[root@aliyun tmp]# head -5 /etc/passwd|sed 's/root/!!!!/g'
# g是全部匹配， 数字表示匹配到第几次
[root@aliyun tmp]# head -5 /etc/passwd|sed 's/root/!!!!/2'
```

标志位
s/old/new/标志位
- 数字，第几次出现才进行替换
- g， 每次出现都进行替换
- p 打印模式空间的内容
- sed -n 'script' filename 阻止默认输出
- w file 将模式空间的内容写入到文件

```bash
[root@aliyun tmp]# head -5 /etc/passwd|sed 's/root/!!!!/w /tmp/a.txt'
# 把替换成功的一行写入 /tmp/a.txt
```

寻址

默认对每行进行操作，增加寻址后对匹配的行进行操作

- /正则表达式/s/old/new/g
- 行号s/old/new/g
   - 行号可以是具体的行，也可以是最后一行$ 符号
- 可以使用两个寻址符号，也可以混合使用行号和正则地址

```bash
# 在第一行替换
[root@aliyun tmp]# head -6 /etc/passwd| sed '1s/adm/!/'
# 第一行到第三行
[root@aliyun tmp]# head -6 /etc/passwd| sed '1,3s/adm/!/'
# 第一行到最后一行
[root@aliyun tmp]# head -6 /etc/passwd| sed '1,$s/adm/!/'
# 在root的行替换
[root@aliyun tmp]# head -6 /etc/passwd| sed '/root/s/bash/!/'
# bin开头 到结尾 全部替换
[root@aliyun tmp]# head -6 /etc/passwd| sed '/^bin/,$s/nologin/!/g'
```

分组

- 寻址可以匹配多条命令
- /regular/{s/old/new/;s/old/new/}

脚本文件

- 可以将选项保存为文件，使用-f 加载脚本文件
- sed -f sedscripts filename

# 91 sed 其他指令

- 删除命令
- 追加命令
- 打印
- 下一行
- 读文件和写文件
- 退出命令

删除命令

- [寻址]
   - 删除模式空间内容，改变脚本的控制流，读取新的输入行。

```bash
[root@aliyun tmp]# cat bfile
b
a
aa
aaa
ab
abb
abbb
[root@aliyun tmp]# sed '/ab/d' bfile
[root@aliyun tmp]# sed '/ab/d;=' bfile
```

追加插入和更改

- 追加命令a
- 插入命令i
- 更改命令c

读文件和写文件

- 读文件命令r
- 写文件命令w

```bash
[root@aliyun tmp]# sed '/ab/i hello' bfile
[root@aliyun tmp]# sed '/ab/a hello' bfile
[root@aliyun tmp]# sed '/ab/c hello' bfile

# r读取afile 文件
[root@aliyun tmp]# sed '/ab/r afile' bfile
```

下一行

- 下一行命令n
- 打印行号命令=

打印

- 打印命令p

```bash
[root@aliyun tmp]# sed -n '/ab/p' bfile
```

退出命令

- 退出命令q
- 哪个效率会更高呢？
   - sed 10q filename
   - sed -n 1,10p filename

```bash
[root@aliyun tmp]# seq 1 100000 > lines.txt
[root@aliyun tmp]# wc -l lines.txt
100000 lines.txt
[root@aliyun tmp]# time sed -n '1,10p' lines.txt #p指令后面的行数依然会去处理。所以效率没有q高
1
2
3
4
5
6
7
8
9
10

real	0m0.007s
user	0m0.005s
sys	0m0.002s
[root@aliyun tmp]# time sed -n '10q' lines.txt

real	0m0.002s
user	0m0.000s
sys	0m0.001s
```

# 92 sed 多行模式空间

- 为什么要有多行模式
- 多行模式处理命令 N、D、P

为什么要有多行模式

- 配置文件一般为单行出现
- 也有使用XML 或 JSON 格式的配置文件，为多行出现

多行匹配命令

- N 将下一行加入到模式空间
- D 删除模式空间中的第一个字符到第一个换行符
- P 打印模式空间中的第一个字符到第一个换行符

```bash
[root@aliyun tmp]# sed 'N' a.txt
hel
lo
[root@aliyun tmp]# sed 'N;s/hello/!!!/' a.txt
hel
lo
[root@aliyun tmp]# sed 'N;s/hel\nlo/!!!/' a.txt
!!!

[root@aliyun tmp]# cat > b.txt << EOF
> hell
> o bash hel
> lo bash
> EOF
# 这里的 D会导致循环替换
[root@aliyun tmp]# sed 'N;s/\n//;s/hello bash/hello sed\n/;P;D' b.txt
hello sed
 hello sed
```

# 93 保持空间

- 什么是保持空间
- 保持空间命令

什么是保持空间

- 保持空间也是多行的一种操作方式
- 将内容暂存在保持空间，便于做多行处理

【文件文件】    【模式空间】     【保持空间】

- h 和 H将模式空间内容存放到保持空间  h(覆盖) H(追加)
- g 和 G将保持空间内容取出到模式空间  g(覆盖) G(追加)
- x 交换模式空间和保持空间内容

```bash
[root@aliyun tmp]# head -6 /etc/passwd |cat -n
[root@aliyun tmp]# head -6 /etc/passwd |cat -n|tac

[root@aliyun tmp]# cat -n /etc/passwd|head -6|sed -n '1h;1!G;$!x;$p'
[root@aliyun tmp]# cat -n /etc/passwd|head -6|sed -n 'G;h;$p'
[root@aliyun tmp]# cat -n /etc/passwd|head -6|sed -n '1!G;h;$p'
[root@aliyun tmp]# cat -n /etc/passwd|head -6|sed '1!G;h;$!d'
```

# 94 认识awk

- awk 和 sed 的区别
- awk 脚本的流程控制

awk 和 sed 的区别

- awk 更像是脚本语言
- awk 用于 “比较规范” 的文本处理，用于统计数量并输出指定字段
- 使用sed将不规范的文本，处理为 “比较规范” 的文本

awk 脚本的流程控制

- 输入数据前例程 BEGIN{}
- 主输入循环{}
- 所有文件读取完成例程 END{}

# 95 awk的字段

awk 的字段引用和分离

记录和字段

- 每行称作 awk 的记录
- 使用空格、制表符分隔开的单词称作字段
- 可以自己指定分隔的字段

字段的引用

- awk中使用$1 $2... $n表示每一个字段
   - awk '{print $1,$2,$3}' filename
- awk 可以使用-F选项改变字段分隔符
   - awk -F',' '{print $1,$2,$3}' filename
   - 分隔符可以使用正则表达式

```bash
[root@aliyun tmp]# awk '/^menu/{ print $0 }' /boot/grub2/grub.cfg
[root@aliyun tmp]# awk -F "'" '/^menu/{ print $2 }' /boot/grub2/grub.cfg
[root@aliyun tmp]# awk -F "'" '/^menu/{ print x++,$2 }' /boot/grub2/grub.cfg
```

# 96 awk表达式

- 赋值操作符
- 算数操作符
- 系统变量
- 关系操作符
- 布尔操作符

赋值操作符

- = 是最常用的赋值操作符

var1 = "name"

var2 = "hello" "world"

var3 = $1
- 其他赋值操作符

++ -- += -= *= /= ^=

算数运算符

- 算数操作符
   - 

      - 

         - 

            - / ^

系统变量

- FS 和 OFS 字段分隔符，OFS 表示输出的字段分隔符
- RS 记录分隔符
- NR 和 FNR 行数   FNR是不同的文件进行排序
- NF 字段数量，最后一个字段内容可以用 $NF 取出

```bash
[root@aliyun ckh]# head -5 /etc/passwd|awk -F ":" '{print $1}'
[root@aliyun ckh]# head -5 /etc/passwd|awk 'BEGIN{FS=":"}{print $1}'
[root@aliyun ckh]# head -5 /etc/passwd|awk 'BEGIN{FS=":";OFS="-"}{print $1,$2}'

[root@aliyun ckh]# head -5 /etc/passwd|awk 'BEGIN{RS=":"}{print $0}'

# 单个文件 NR FNR 显示一样
[root@aliyun ckh]# head -5 /etc/passwd|awk '{print FNR,$0}'
[root@aliyun ckh]# head -5 /etc/passwd|awk '{print NR,$0}'

# FNR 第二文件行号会从1开始
[root@aliyun ckh]# awk '{print FNR,$0}' /etc/hosts /etc/hosts
[root@aliyun ckh]# awk '{print NR,$0}' /etc/hosts /etc/hosts

[root@aliyun ckh]# head -5 /etc/passwd|awk 'BEGIN{FS=":"}{print NF}'
[root@aliyun ckh]# head -5 /etc/passwd|awk 'BEGIN{FS=":"}{print $NF}'
```

关系操作符

- 关系操作符

< > <= >=  == != ~ !~

布尔操作符

- 布尔操作符

&& ||  !

# 97 awk 判断和循环

awk 的条件和循环

- 条件语句
- 循环

条件语句

- 条件语句使用if 开头，根据表达式的结果来判断执行哪条语句

if(表达式)

awk 语句

[else

awk语句2

]
- 如果有多个语句需要执行可以使用{} 将多个语句括起来

```bash
[root@aliyun ckh]# cat kpi.txt
user1 70 72 74 76 74 72
user2 80 82 87 84 80 21
user3 87 82 46 07 14 12
user4 70 72 74 76 74 72
user5 70 72 74 76 74 72
[root@aliyun ckh]# awk '{if($2>=80) print $1}' kpi.txt
[root@aliyun ckh]# awk '{if($2>=80) print $1,$2}' kpi.txt
[root@aliyun ckh]# awk '{if($2>=80) {print $1;print $2}}' kpi.txt
```

循环

- while 循环

while(表达式)

awk语句1
- do 循环

do{

awk 语句1

}while(表达式)
- for循环

for(初始化;循环判断条件;累加)

awk语句1
- 影响控制的其他语句

break

continue

```bash
[root@aliyun ckh]# head -1 kpi.txt |awk '{for(c=2;c<=NF;c++) sum+=$c;print sum}'
[root@aliyun ckh]# head -1 kpi.txt |awk '{for(c=2;c<=NF;c++) sum+=$c;print sum/6}'
[root@aliyun ckh]# head -1 kpi.txt |awk '{for(c=2;c<=NF;c++) sum+=$c;print sum/(NF-1)}'

[root@aliyun ckh]# awk '{sum=0; for(c=2;c<=NF;c++) sum+=$c;print sum/(NF-1)}' kpi.txt
```

# 98 awk数组

- 数组的定义
- 数组的遍历
- 删除数组
- 命令行参数数组

数组的定义

- 数组: 一组有某种关联的数据(变量),通过下标一次访问
   - 数据名[下标] = 值
   - 下标可以使用数字也可以使用字符串

数组的遍历

- for(变量 in 数组名)

使用 数组名[变量]的方式依次对每个数组的元素进行操作

删除数组

- 删除数组

delete 数组[下标]

```bash
[root@aliyun ckh]# cat kpi.txt
user1 70 72 74 76 74 72
user2 80 82 87 84 80 21
user3 87 82 46 07 14 12
user4 70 72 74 76 74 72
user5 70 72 74 76 74 72
[root@aliyun ckh]# awk '{ sum=0; for(column=2;column<=NF;column++) sum+=$column; average[$1]=sum/(NF-1)}END{}' kpi.txt
[root@aliyun ckh]# awk '{ sum=0; for(column=2;column<=NF;column++) sum+=$column; average[$1]=sum/(NF-1)}END{for( user in average ) print user,average[user]}' kpi.txt
[root@aliyun ckh]# awk '{ sum=0; for(column=2;column<=NF;column++) sum+=$column; average[$1]=sum/(NF-1)}END{for( user in average ) sum2+=average[user];print sum2/NR}' kpi.txt

awk -f avg.awk kpi.txt  #加载awk脚本文件
```

命令行参数数组

- 命令行参数数组

ARGC

ARGV

```bash
[root@aliyun ckh]# awk -f arg.awk 11 22 33
awk
11
22
33
4
[root@aliyun ckh]# cat arg.awk
BEGIN{
	for(x=0;x<ARGC;x++)
		print ARGV[x]
	print ARGC
}
```

# 99 awk数组功能的使用

```bash
[root@aliyun ckh]# awk -f result.awk kpi.txt
user1 61
user2 68.8333
user3 39.3333
user4 61
user5 61
above 5
below
[root@aliyun ckh]# cat result.awk
{
sum = 0
for( column = 2 ; column < NF; column++ )
	sum += $column

average[$1] = sum/(NF-1)
print $1,average[$1]
}
END{
for( user in average )
	sum += average[user]

avg_all = sum_all / NR

for( user in average )
	if( average[user] > avg_all )
		above++
	else
		below++

print "above",above
print "below",below
}
[root@aliyun ckh]# cat kpi.txt
user1 70 72 74 76 74 72
user2 80 82 87 84 80 21
user3 87 82 46 07 14 12
user4 70 72 74 76 74 72
user5 70 72 74 76 74 72


[root@aliyun ckh]# cat result.awk
{
sum = 0
for( column = 2 ; column < NF; column++ )
	sum += $column

average[$1] = sum/(NF-1)

if( average[$1] >= 80 )
	letter = "S"
else if( average[$1] >= 70 )
	letter = "A"
else if( average[$1] >= 60 )
	letter = "B"
else
	letter = "C"

print $1,average[$1],letter

letter_all[letter]++

}
END{
for( user in average )
	sum += average[user]

avg_all = sum_all / NR

for( user in average )
	if( average[user] > avg_all )
		above++
	else
		below++

print "above",above
print "below",below
print "S:",letter_all["S"]
print "A:",letter_all["A"]
print "B:",letter_all["B"]
print "C:",letter_all["C"]
}
[root@aliyun ckh]# awk -f result.awk kpi.txt
```

# 100 AWK 的函数

- 算数函数
- 字符串函数
- 自定义函数

算数函数

- sin() cos()
- int()
- rand() srand()

```bash
[root@aliyun ckh]# awk 'BEGIN{pi=3.14 ; print int(pi) }'
3
[root@aliyun ckh]# awk 'BEGIN{print rand()}'
0.237788
[root@aliyun ckh]# awk 'BEGIN{print rand()}'
0.237788
[root@aliyun ckh]# awk 'BEGIN{srand();print rand()}'
0.874283
[root@aliyun ckh]# awk 'BEGIN{srand();print rand()}'
0.825366
```

字符串函数

- gsub(r,s,t)
- index(s,t)
- length(s)
- match(s,r)
- split(s,a,sep)
- sub(r,s,t)
- substr(s,p,n)

自定义函数
function 函数名(参数){
awk语句
return awk变量
}

```bash
[root@aliyun ckh]# awk 'function a(){ return 0} BEGIN{ print a()}'
0
[root@aliyun ckh]# awk 'function double(str){ return str str} BEGIN{ print double("hello awk") }'
hello awkhello awk
```

# 101 防火墙概述

- 防火墙分类
- iptables 的表和链
- iptables 的filter 表
- iptables 的 nat 表
- iptables 配置文件
- firewallD 服务

防火墙分类

- 软件防火墙和硬件防火墙
- 包过滤防火墙和应用层防火墙
   - Centos 6 默认的防火墙是 iptables
   - Centos 7 默认的防火墙是 firewallD（底层使用 netfilter）

iptables 的表和链

- 规则表
   - filter nat mangle raw     filter 过滤
- 规则链
   - INPUT OUTPUT FORWARD     进 去 转发
   - PREROUTING POSTROUTING   路由前转换   路由后转换

# 102 iptables规则的基本使用演示

- iptables -t filter 命令 规则链 规则
   - 命令

-L

-A-I

-D -F -P

-N -X -E

```bash
# 查看已经设置的那些过滤规则
[root@vulcan ~]# iptables -t filter -L   
Chain INPUT (policy ACCEPT)   #外部进来数据包的规则
	 
Chain FORWARD (policy DROP)   #数据包经过这台主机转发的规则

Chain OUTPUT (policy ACCEPT)  #本机数据包出去的规则
	
#允许 10.0.0.1 ip访问
[root@vulcan ~]# iptables -t filter -A INPUT -s 10.0.0.1 -j ACCEPT
# 查看过滤信息   -n 取消方向解析
[root@vulcan ~]# iptables -t filter -nL
[root@vulcan ~]# iptables -t filter -vnL
```

# 103 iptables 过滤规则的使用

```bash
# 查看所有的规则
[root@vulcan ~]# iptables -vnL
[root@vulcan ~]# # -A 在已有规则后面添加
[root@vulcan ~]# # -I 添加到规则第一条  
[root@vulcan ~]# #iptable -t filter # -t filter表 默认可以省略
[root@vulcan ~]# iptables -A INPUT -s 10.0.0.2 -j ACCEPT
[root@vulcan ~]# iptables -A INPUT -s 10.0.0.2 -j DROP    # 前后有冲突时候，以最前面的规则为准
[root@vulcan ~]# iptables -I INPUT -s 10.0.0.3 -j ACCEPT  # 插入到第一条
[root@vulcan ~]# # iptables -I INPUT -s 10.0.0.1 -j ACCEPT  
[root@vulcan ~]# # iptables -P INPUT DROP #将默认规则改成拒绝 也就是所有进来数据包都拒绝
[root@vulcan ~]# iptables -F   #清空所有规则(默认规则不会变)
[root@vulcan ~]# iptables -D INPUT 1   # 删除规则；1是行号
[root@vulcan ~]# iptables -A INPUT -s 10.0.0.0/24 -j ACCEPT #-s 网段
[root@vulcan ~]# # -p tcp|udp|icmp --dport 80
[root@vulcan ~]# iptables -t filter -A INPUT -i eth0 -s 10.0.0.2 -p tcp --dport 80 -j ACCEPT
[root@vulcan ~]# # iptables -t filter -A INPUT -j DROP
```

# 104 iptables nat 表的使用

iptables的 nat 表

- iptables -t nat 命令 规则链 规则
   - PREROUTING 目的地址转换
   - POSTROUTING  源地址转换

```bash
#  外部访问的114.115.115.117：80端口访问  目地地址转到内部 10.0.0.1地址上
[root@vulcan ~]# iptables -t nat -A PREROUTING -i eth0 -d 114.115.115.117 -p tcp --dport 80 -j DNAT --to-destination 10.0.0.1

# 源地址是内网的ip10.0.0.0/24  从本地eth1 网卡出去  eth1 的ip是111.113.114.111
[root@vulcan ~]# iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth1 -j SNAT --to-source 111.113.114.111
```

iptables 的配置文件

- /etc/sysconfig/iptables   #iptables命令行配置重启之后失效，保存在配置文件重启之后依然有效
- CentOS6
   - service iptables save|start|stop|restart
- CentOS7
   - yum install iptables-services

```bash
[root@vulcan ~]# rpm -ql iptables-services

iptables-save > /etc/sysconfig/iptables  #保存当前的配置
service iptables start
iptables-restore < /etc/sysconfig/iptables

iptables -t nat -vnL
```

# 105 firewalld

firewallD 服务

- firewallD 的特点
   - 支持区域 “zone” 概念
   - firewall-cmd
- systemctl start|stop|enable|disable firewalld.service

```bash
[root@vulcan ~]# service itpables stop  #先停iptables
[root@vulcan ~]# systemctl start firewalld
[root@vulcan ~]# iptables -vnL
[root@vulcan ~]# firewall-cmd --state  #查看firewalld 状态
[root@vulcan ~]# firewall-cmd --list-all  #查看具体状态
public                   # 公共区域
  target: default      
  icmp-block-inversion: no
  interfaces:                 # 是绑定了哪个网卡
  sources:                    # 允许访问的源ip
  services: ssh dhcpv6-client # 允许访问的服务
  ports:                      # 运行访问的端口
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
  
[root@vulcan ~]# firewall-cmd --zone=public --list-services

# 查看默认的所有区域
[root@vulcan ~]# firewall-cmd --get-zones
block dmz drop external home internal public trusted work
[root@vulcan ~]# firewall-cmd --get-default-zone
[root@vulcan ~]# firewall-cmd --get-active-zone

[root@vulcan ~]# # port service source
[root@vulcan ~]# firewall-cmd --add-service=https
[root@vulcan ~]# firewall-cmd --add-port=81/tcp
# permanent 永久保存
[root@vulcan ~]# firewall-cmd --add-port=82/tcp --permanent
[root@vulcan ~]# firewall-cmd --reload
[root@vulcan ~]# firewall-cmd --remove-source=10.0.0.1
```

# 106 SSH 介绍之Telnet 明文漏洞

SSH 服务

- ssh 服务介绍
- ssh 服务配置介绍
- ssh 命令
- ssh 公钥认证
- scp 和 sftp 远程拷贝文件

SSH服务介绍

- 远程管理的必要性
- telnet 服务的问题

```bash
[root@vulcan ~]# yum install telnet telnet-server xinetd -y
# xinetd 服务管理telnet服务
[root@vulcan ~]# systemctl start xinetd
[root@vulcan ~]# systemctl status xinetd
[root@vulcan ~]# systemctl start telnet.socket
# 防火墙配置23端口开放
iptables -I INPUT -p tcp --dport 23 -j ACCEPT
firewall-cmd --permanent --add-port=23/tcp
firewall-cmd --reload

[root@vulcan ~]# tcpdump -i any port 23 -s 1500 -w /root/a.dump
[c:\~]$ telnet user1@10.0.0.11 23
[root@vulcan ~]# yum install wireshark-gnome  #图形化界面 查看a.dump 文件
```

# 107 SSH服务演示

- sshd_config

Port 22 默认端口

PermitRootLogin yes 是否允许 root 登录

AuthorizedKeysFile .ssh/authorized_keys

SSH 命令

- systemctl status|start|stop|restart|enable|disable sshd.service
- 客户端命令
   - ssh [-p 端口] 用户@远程ip
   - SecureCRT
   - Xshell
   - putty

SSH公钥认证

- 密钥认证原理
- 常用命令
   - ssh-keygen -t rsa
   - ssh-copy-id

# 108 FTP 服务搭建

FTP服务

- FTP 协议介绍
- vsftpd 服务器安装
- vsftpd 服务配置文件
- FTP 命令
- 使用虚拟用户进行验证

FTP服务介绍

- FTP协议

主动模式和被动模式

vsftpd 服务安装和启动

- yum install vsftpd ftp
- systemctl start vsftpd.service
- 建议将 selinux vsftpd.service
   - getsebool -a |grep ftpd
   - setsebool -p  1

```bash
[root@vulcan ~]# yum install vsftpd ftp -y
[root@vulcan ~]# systemctl start vsftpd.service
[root@vulcan ~]# ftp localhost   # 默认匿名账户 和本地账号都可登录
Name (localhost:root): ftp
331 Please specify the password.

[root@vulcan ~]# useradd user1
[root@vulcan ~]# echo 123|passwd --stdin user1
```

# 109 vsftpd 服务配置文件介绍

- /etc/vsftpd/vsftpd.conf
- /etc/vsftpd/ftpusers     # 黑名单 不允许登录到ftp
- /etc/vsftpd/user_list	   # 白名单

`[root@vulcan etc]# man 5 vsftpd.conf`

# 110 vsftp 虚拟用户

使用虚拟用户进行验证

- guest_enable=YES
- guest_username=vuser
- user_config_dir=/etc/vsftpd/vuserconfig
- allow_writeable_chroot=YES
- pam_service_name=vsftpd.vuser

```bash
[root@vulcan ~]# mkdir /data/ftp -p
[root@vulcan ~]# useradd vuser -d /data/ftp -s /sbin/nologin
[root@vulcan ~]# grep vuser /etc/passwd
vuser:x:1001:1001::/data/ftp:/sbin/nologin
[root@vulcan ~]# touch /data/ftp/{aa,bb,cc}
[root@vulcan ~]# cat /etc/vsftpd/vuser.temp
u1
123456
u2
123456
u3
123456

[root@vulcan ~]# db_load -T -t hash -f /etc/vsftpd/vuser.temp /etc/vsftpd/vuser.db
[root@vulcan ~]# chmod 600 /etc/vsftpd/vuser.db
[root@vulcan ~]# ll /etc/vsftpd/vuser.db
-rw-------. 1 root root 12288 Dec 31 17:03 /etc/vsftpd/vuser.db
[root@vulcan ~]# cat /etc/pam.d/vsftpd.vuser
auth sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser
account sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser

[root@vulcan ~]# vi /etc/vsftpd/vsftpd.conf
#pam_service_name=vsftpd
guest_enable=YES
guest_username=vuser
user_config_dir=/etc/vsftpd/vuserconfig
allow_writeable_chroot=YES
pam_service_name=vsftpd.vuser

[root@vulcan ~]# mkdir /etc/vsftpd/vuserconfig/
[root@vulcan ~]# cat /etc/vsftpd/vuserconfig/u1
local_root=/data/ftp   #u1用户登入之后访问的目录
write_enable=YES       # 是否可写
anon_umask=022
anon_world_readable_only=NO
anon_upload_enable=YES     # 可上传
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
download_enable=YES    #可下载
```

# 111 samba服务演示

samba 和 NFS

- 常见的共享服务的区别
- Samba服务的安装
- Samba服务的配置文件
- Samba 用户的设置
- Samba 服务的启动和停止
- NFS 服务的配置
- NFS 服务的启动和停止

常见共享服务的区别

- 协议不同
- 对操作系统的支持程序不同
- 交互的便利性不同

Samba 服务安装

- yum install samba

Samba 服务配置文件

- /etc/samba/smb.conf

[share]

comment = my share

path=/data/share

read only = No

Samba 用户的设置

- smbpasswd 命令

-a 添加用户

-x 删除用户
- pdbedit

-L 查看用户

Samba服务的启动

- systemctl start|stop smb.service
- Linux 客户端

mount -t cifs -o username=user1 [//127.0.0.1/user1](//127.0.0.1/user1) /mnt
- windows 客户端
   - 资源管理器访问共享
   - 映射网络驱动器

```bash
[root@vulcan ~]# useradd user1  
[root@vulcan ~]# smbpasswd -a user1  #一定要建立一个和系统同名的用户。
New SMB password:
Retype new SMB password:
Added user user1.
[root@vulcan ~]# pdbedit -L     #查看有哪些用户
user1:1000:
[root@vulcan ~]# # smbpasswd -x user1  #删除samba用户
```

# 112 NFS 服务

NFS 服务的配置和启动

- /etc/export

/data/share *(rw,sync,all_squash)
- showmount -e localhost
- 客户端使用挂载方式访问

mount -t nfs localhost:/data/share /ent
- 启动NFS 服务

systemctl star|stop nfs.service

```bash
[root@vulcan user1]# cat /etc/exports
/data/share *(rw,sync,all_squash)
[root@vulcan user1]# mkdir /data/share -p
[root@vulcan user1]# echo aa > /data/share/aa.log
[root@vulcan user1]# systemctl start nfs
[root@vulcan user1]# showmount -e 127.0.0.1
Export list for 127.0.0.1:
/data/share *
[root@vulcan user1]# mount -t nfs localhost:/data/share /mnt
[root@vulcan user1]# touch /mnt/aa1.log
touch: cannot touch ‘/mnt/aa1.log’: Permission denied
[root@vulcan user1]# chown nfsnobody.  /data/share
[root@vulcan user1]# touch /mnt/aa1.log
```

# 113 Nginx基本配置文件

Nginx

- Nginx 和 web服务介绍
- openResty 软件的下载和安装
- OpenResty 的配置文件
- 使用OpenResty配置域名虚拟主机

Nginx 和web服务介绍

- Nginx(engine x) 是一个高性能的web 和方向代理服务器
- Nginx支持 HTTP HTTPS 和电子邮件代理协议
- OpenResty是基于Nginx和Lua实现的web应用网关，集成了大量的第三方模块

OpenResty的下载和安装

- yum-config-manager --add-repo [https://openresty.org/package/centos/openresty.repo](https://openresty.org/package/centos/openresty.repo)
- yum install openresty

OpenResty 的配置文件

- /usr/local/openresty/nginx/conf/nginx.conf
- service openresty start |stop | restart | reload

# 114 Nginx域名虚拟主机

基于域名的虚拟主机

```bash
server {
	listen 80;
	server_name www.servera.com;
	location /{
		root html/servera;
		index index.html index.html;
	}

}
```

```bash
[root@vulcan nginx]# vim conf/nginx.conf
 84     server {
 85         listen       8000;
 86         listen       www.servera.com;
 87     #    server_name  somename  alias  another.alias;
 88
 89         location / {
 90             root   html/servera;
 91             index  index.html index.htm;
 92         }
 93     }
 94
 95     server {
 96         listen       8001;
 97         listen       www.serverb.com;
 98     #    server_name  somename  alias  another.alias;
 99
100         location / {
101             root   html/serverb;
102             index  index.html index.htm;
103         }

[root@vulcan nginx]# mkdir html/{servera,serverb}
[root@vulcan nginx]# echo servera > html/servera/index.html
[root@vulcan nginx]# echo serverb > html/servera/index.html
[root@vulcan nginx]# ./sbin/nginx -t
[root@vulcan nginx]# ./sbin/nginx -t reload  # 不重启加载配置文件
[root@vulcan nginx]# systemctl restart openresty
[root@vulcan nginx]# netstat -lntup |grep nginx
[root@vulcan html]# tail -1 /etc/hosts
127.0.0.1   www.servera.com www.serverb.com
[root@vulcan html]# curl http://www.servera.com:8000
servera
[root@vulcan html]# curl http://www.serverb.com:8001
serverb
```

# 115 LNMP

LNMP

- 什么是LNMP
- LNMP 环境的搭建

什么是LNMP

- LAMP (Linux+Apache+PHP+MySQL)
- LNMP (Apache --> Nginx)

LNMP 环境的搭建

- MySQL安装
   - 可以使用mariadb替代
   - yum install mariadb mariadb-server
   - 修改默认编码 vim /etc/my.cnf     [mysqld] 模块下添加

character_set_server=utf8

init_connect='SET NAMES utf8'
   - systemctl start mariadb.service

show variables like '%character_set%';
- PHP安装
   - yum install php-fpm php-mysql
- 启动 php-fpm
   - systemctl start php-fpm.service

Nginx 配置

```bash
location ~\.php${
	root html;
	fastcgi_pass 127.0.0.1:9000;
	fastcgi_index index.php;
	fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
	include  fastcgi_params;
}
```

```bash
[root@vulcan html]# mysql
MariaDB [(none)]> show variables like '%character_set%' ;
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8                       |
| character_set_connection | utf8                       |
| character_set_database   | utf8                       |
| character_set_filesystem | binary                     |
| character_set_results    | utf8                       |
| character_set_server     | utf8                       |
| character_set_system     | utf8                       |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+
8 rows in set (0.00 sec)
```

# 116 DNS

BIND

- DNS 服务介绍
- BIND 软件的安装
- BIND 的配置文件
- 使用 dig 和 nslookup 命令测试DNS
- 从域名服务器的配置

DNS服务介绍

- DNs( Domain Name System)域名系统
- FQDN(Full Qualified Domain Name)完全限定域名
- 域分类:根域、顶级域(TLD)
- 查询方式:递归、迭代
- 解析方式:正向解析、反向解析
- DNS服务器的类型:缓存域名服务器、主域名服务器、从域名服务器

安装BIND

- /etc/hosts
- yum install bind bind-utils
- systemctl start named.service

```bash
[root@vulcan html]# vim /etc/named.conf
options {
        listen-on port 53 { any; };
        listen-on-v6 port 53 { ::1; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        recursing-file  "/var/named/data/named.recursing";
        secroots-file   "/var/named/data/named.secroots";
        allow-query     { any; };

[root@vulcan html]# named-checkconf   #检查配置文件语法
[root@vulcan html]# vim /etc/named.conf
zone "." IN {
        type hint;
        file "named.ca";   #这个在/var/named/   
};

[root@vulcan html]# vi /var/named/named.ca  # 默认缓存域名服务器

# 修改成主域名服务器
[root@vulcan html]# vim /etc/named.conf
zone "test.com" IN {
        type master;
        file "test.com.zone";
};
[root@vulcan html]# cp -p /var/named/named.ca /var/named/test.com.zone

# 从域名服务器bind 配置文件
zone "etst.com" IN{
	type slave;
	file "slaves/test.com.zone";
	masters {10.211.55.3;};
}

# 反向解析配置文件
zone "0.20.10.in-addr.arpa" IN{
	type master;
	file "10.20.0.zone";
};
100 IN PTR www.test.com
```

# 117 NAS 演示

- NAS(Network Attached Storage) 网络附属存储
- NAS支持的协议NFS CIFS FTP
- 保证数据安全方式  磁盘阵列

```
#准备两个磁盘都格式化成一个分区
[root@vulcan ~]# fdisk /dev/sdb
[root@vulcan ~]# fdisk /dev/sdc
Command (m for help): p
Command (m for help): n
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-41943039, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-41943039, default 41943039):
Command (m for help): w

#创建软raid   -a yes 自动确认 -n 2 是两块磁盘 —l 1 read1
[root@vulcan ~]# mdadm -C -a yes /dev/md0 -n 2 -l 1 /dev/sdb1 /dev/sdc1
#保证下次开机自动运行
[root@vulcan ~]# mdadm --detail --scan --verbose
[root@vulcan ~]# mdadm --detail --scan --verbose > /dev/mdadm.conf
#创建物理卷  
[root@vulcan ~]# pvcreate /dev/md0
#创建卷组vg1 拿/devmd0 来创建的
[root@vulcan ~]# vgcreate vg1 /dev/md0
#创建逻辑卷 lv1  从vg1卷组里拿200M
[root@vulcan ~]# lvcreate -L 200M -n lv1 vg1
[root@vulcan ~]# lvs

[root@vulcan ~]# mkfs.xfs /dev/vg1/lv1
[root@vulcan ~]# mkdir /share ;mount /dev/vg1/lv1 /share
[root@vulcan ~]# echo '/dev/vg1/lv1 /share xfs defaults 0 0' >> /etc/fstab
[root@vulcan ~]# umount /share
[root@vulcan ~]# mount -a
[root@vulcan ~]# mount |grep share

[root@vulcan ~]# useradd shareuser -d /share/shareuser
[root@vulcan ~]# echo 123456 |passwd --stdin shareuser
# 配置vsftp 使用本地用户就可以登录访问自己家目录了
[root@vulcan ~]# vim /etc/vsftpd/vsftpd.conf
pam_service_name=vsftpd
local_enable=YES
write_enable=YES

[root@vulcan ~]# cat useradd.sh
#!/bin/bash
useradd $1 -d /share/$1
echo 123456 | passwd --stdin $1

[root@vulcan ~]# systemctl restart vsftpd

# smba 配置
[root@vulcan ~]# pdbedit -L
user1:1000:
[root@vulcan ~]# smbasswd -a shareuser  #交互模式添加用户设置密码

[root@vulcan ~]# echo -e "123456\n123456" > smbpass.tmp
[root@vulcan ~]# cat smbpass.tmp
[root@vulcan ~]# cat useradd.sh
#!/bin/bash
pass=123456
useradd $1 -d /share/$1
echo $pass | passwd --stdin $1

echo $pass > smbpass.tmp
echo $pass >> smbpass.tmp
smbpasswd -s -a $1 <smbpass.tmp

# 静默模式设置smb用户密码
[root@vulcan ~]# smbpasswd -s -a shareuser <smbpass.tmp
[root@vulcan ~]# pdbedit -L

[root@vulcan ~]# vim /etc/samba/smb.conf
[root@vulcan ~]# systemctl restart smb

# nfs共享配置
[root@vulcan ~]# cat /etc/exports
/data/share *(rw,sync,all_squash)
/share/shareuser *(ro)

[root@vulcan ~]# cat useradd.sh
#!/bin/bash
pass=123456
useradd $1 -d /share/$1
echo $pass | passwd --stdin $1

echo $pass > smbpass.tmp
echo $pass >> smbpass.tmp
smbpasswd -s -a $1 <smbpass.tmp
echo "share/$1 *(ro)" >> /etc/exports

[root@vulcan ~]# systemctl restart nfs
[root@vulcan ~]# ls /share -l
total 0
drwx------. 2 shareuser shareuser 62 Jan  9 14:47 shareuser
[root@vulcan ~]# setfacl -m u:nfsnobody:rwx /share/shareuser
[root@vulcan ~]# getfacl /share/shareuser/
```

# 
# 118 结束语
深入学习 向系统管理方向发展，建议深入学习shell脚本
通过linux平台开发应用软件：深入理解操作系统的基本原理
