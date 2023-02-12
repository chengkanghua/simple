Linux运维：核心基础篇

## 第0章　计算机硬件与组成基础 / 1
```
    0.1　计算机硬件分类 / 1
        家用台式机
        笔记本电脑 
    0.2　运维与服务器 / 2
        运维人员的三大核心职责：  
        1 数据安全。  
        2 业务7乘24小时运行。
            可用性级别  全年停机时间
             99%          87.6小时
             99.9%        8.8小时
             99.99%       5.3分钟
             99.999%      5分钟
        3 业务服务效率高。 
        服务器尺寸： 1U的服务器表示服务器高度4.45 CM。 
        服务器外形分类： 机架式服务器 刀片式服务器 塔式服务器 
    0.3　互联网公司的服务器品牌 / 5
        戴尔服务器（r720  r730 r740）  惠普服务器 IBM服务器 浪潮服务器 联想服务器  
    0.4　服务器品牌详解及对应型号 / 6
        戴尔服务器（r720  r730 r740）
    0.5　服务器（计算机）核心零部件介绍 / 8
        电源 CPU 内存  磁盘 主板 Raid卡 远程管理卡
        CPU频率就是用来表示CPU每秒钟的工作次数
        程序：代码文件  
        进程：正在运行的程序 
        守护进程 ：持续运行的程序 
        buffer缓冲区 : 写缓冲
        cache缓存区 ： 读缓存
        磁盘的接口包括IDE、SCSI、SAS、SATA等种类，其中IDE、SCSI已退出历史舞台。
        磁盘读写速度的单位是iops，即input/output per second（每秒的输入输出）。
        Raid卡： 磁盘冗余阵列  分软Raid 和硬Raid
        Raid的好处 
            可以所有硬盘合到一起（扩充容量 ）
            可以使数据更加安全 （数据冗余）
            可以获得更高的效率 （读写性能） 
        常见的Raid级别有Raid0、Raid1、Raid5、Raid10

        介绍一下南桥芯片、北桥芯片和BIOS芯片
            南桥芯片负责io总线之间的通信如PCI总线、USB、LAN、ATA、SATA、音频控制器、键盘控制器、实时时钟控制器、高级电源管理等
            北桥芯片负责与CPU联系，并且控制内存 AGP数据在北桥内部传输。
            BIOS（Basic Input Output System）芯片（CMOS芯片）
    0.6　计算机和服务器的主要构成图解 / 20
            用户通过鼠标、键盘等输入设备，将文字、图形等传给计算机，通过CPU（复制控制和计算）进行处理，需要永久存储的数据将会存储到硬盘里，需要持久执行的程序将会调度到内存（RAM）里运行，需要显示的信息将会通过显示器等设备显示给用户。
    
            输入设备 （内存RAM，中央处理器cpu，外存硬盘）输出设备
    0.7　计算机系统基础 / 21
        冯·诺依曼计算机 3条重要设计思想 
            计算机由 运算器 控制器 存储器 输入输出设备 5大部分组成
            以二进制形式表示数据和指令 
            计算机在工作时能自动地从存储器中取出程序指令并加以执行
        计算机指令系统
            一条指令包含 操作码  操作数
        计算机工作原理
            计算机工作时候两种信息在流动： 数据流， 控制流。
            指令执行过程：
                1 取指令 --》2分析指令 --》3 执行指令 ---》4 为执行下一条指令做准备
        计算机数据记录单位：
            位（bit）
            字节（Byte） 8位=1字节
            1Byte=8bit，1KB=1024B，1MB=1024KB，1GB=1024MB，1TB=1024GB，1PB=1024TB，1EB=1024PB，1ZB=1024EB
        计算机常用计数制
            十进制 二进制 八进制octal notation 16进制 hexadecimal notation 
    0.8　 计算机中数据的表示 / 26
    
        字符数据的表示：    ASCII码由0～9这10个数符，52个大、小写英文字母，32个符号及34个计算机通用控制符组成，共有128个元素
        汉字的存储：
            utf8 GB2312 GBK
```
    0.9　计算机硬件基础问题小结 / 29
        1）你用过的服务器型号有哪些？具体的配置有哪些？
        2）程序、进程和守护进程有什么区别？
        3）提升用户体验的网站优化解决方案有哪些？
        4）谈谈计算机中buffer与cache的简单区别。
        5）描述Raid 0、Raid1的主要特点。
        6）描述电脑的主流硬件作用及其之间的关系（CPU、内存、磁盘）。
        7）描述冯·诺依曼计算机的设计思想。
        8）请描述计算机数据的多种单位与换算。
        9）什么是二进制，计算机是如何用二进制表示数据的。10）为什么买来的硬盘的实际大小比它标称的大小小？
        11）运维人员的三大核心工作职责是什么


## 第1章　Linux系统介绍与环境搭建准备 / 30
```
1.1　Linux简介 / 30
    操作系统的作用是管理和控制计算机系统中的硬件和软件资源  
    目前X86是常见的操作系统有Windows Linux DOS Unix macos
    它是一个基于POSIX的多用户、多任务并且支持多线程和多CPU的操作系统。
1.2　Linux的起源 / 32
     gnu项目发起人    minix开发者 谭明邦教授  linux 托瓦斯 linux之父 
1.3　Linux核心概念知识 / 36
         自由软件  
            ：没有软件版权制约，源代码开放，可以无约束的自由传播
            自由软件中的自由是“言论自由”中的“自由”，而不是“免费啤酒”中的“免费”。
            GPL全称为General Public License，中文名为通用公共许可，是一个最著名的开源许可协议，开源社区最著名的Linux内核就是在GPL许可下发布的。
        Linux操作系统＝Linux内核＋GNU软件及系统软件＋必要的应用程序    
1.4　Linux的特点 / 38
1.5　Linux的应用领域 / 39
1.6　如何选择Linux的发行版本 / 41
        centos7.6  内核3.10版本
1.7　搭建学习Linux的运维环境 / 44
    VMware Workstation
        nat 地址转换
        bridged 桥接
        host-only 仅主机
```
1.8　本章重点 / 57
    1）了解什么是操作系统以及操作系统简单原理图。
    2）了解Unix/Linux的发展历史。
    3）了解市面上常见的Unix系统版本。
    4）了解Unix及Linux诞生发展的几个关键人物。
    5）重点了解GNU、GPL知识。
    6）了解Linux系统的特点。
    7）了解Linux系统的常见发行版本，不同场景选择。
    8）重点了解CentOS和Red Hat的区别和联系。
    9）了解CentOS各个版本的应用场景及企业应用情况。
    10）学会搭建学习Linux的环境。


## 第2章　企业级CentOS7.6操作系统的安装 / 59
```
2.1　下载CentOS系统ISO镜像 / 59
    http://www.centos.org，然后依次选择“GET CENTOS“→”More download choices”链接，点击进入后即可下载

    https://mirrors.aliyun.com/centos/7.6.1810/isos/x86_64/
    
    uname -m

2.2　CentOS7.6操作系统的安装准备 / 62
2.3　开始安装CentOS7.6操作系统 / 63
        install centos7    安装Centos7
        test media and install centos7  测试安装媒体，并安装centos7
        troublesshooting   故障修复
     修改网卡为 eth0形式
       tab按键进入 输入  quiet 后面 net.ifnames=0 biosdevname=0
       输入完按回车

2.4　系统安装后的基本配置 / 80
    选择英文 ，添加额外的中文
    软件包选择 Minimal install
    配置网络和主机名
    磁盘分区 Standard Partition
        /分区
        swap 交换分区 swap分区不是必须的，但是大多数情况下还是设置一下比较好，个别企业的数据库应用场景不分swap。
        /boot 分区 ，linux系统引导分区 1024MB
    文件系统 File System  
        windows fat32/ntfs
        xfs 
        ext2/ext3/ext4
        physical volume（LVM）：这是一种弹性调整文件系统大小.功能不错，但是性能有所下降
        swap： 内存交换空间
        vfat： 同时受 linux 和windows 支持的文件系统类型。
        如果是数据库以及存储等有重要数据的特殊业务服务，那么一般会单独划分存放数据的分区如“/data”。
     uname -r 查看内核版本
[root@www ~]# cat /etc/sysconfig/network-scripts/ifcfg-eth0
TYPE=Ethernet          #<==上网类型，目前基本都是以太网。
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none         #<==启动协议，获取配置方式，有none|bootp|dhcp三个选项。
DEFROUTE=yes           #<==使用默认路由。
IPV4_FAILURE_FATAL=no  #<==不启用IPV4错误检测功能。
NAME=eth0              #<==第一块网卡的逻辑设备名，第二块为eth1。
UUID=e62dd7a9-92fa-4805-afc9-441b567ad38d #<==通用唯一识别码 (Universally Unique 
                                               Identifier)，如果是VMware克隆的
                                               虚拟机则无法启动网卡，可以去除此项。
DEVICE=eth0            #<==第一块网卡的逻辑设备名，第二块为eth1。
ONBOOT=yes             #<==这个地方应为yes，才能保证下次开机启动激活网卡设备。
IPADDR=192.168.2.217   #<==这是虚拟机桥接模式，局域网Linux服务器的固定IP。
PREFIX=24              #<==子网掩码位数，这里是24位。
DNS1=192.168.2.1       #<==主DNS，这里默认会覆盖以及优先于/etc/resolv.conf的配置生效。
GATEWAY=192.168.2.1    #<==局域网上网网关地址。

[root@www ~]# sed -i 's#ONBOOT=no#ONBOOT=yes#g' /etc/sysconfig/network-scripts/ifcfg-eth0
[root@www ~]# grep ONBOOT /etc/sysconfig/network-scripts/ifcfg-eth0   
ONBOOT=yes

[root@www ~]# systemctl restart network
ip add   # 查看ip信息
ip route # 查看网关
[root@www ~]# cat /etc/resolv.conf #查看dns
curl -s -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -s -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
[root@www ~]# yum update -y  #更新补丁
yum install tree nmap dos2unix lrzsz nc lsof wget tcpdump htop iftop iotop sysstat nethogs -y
yum install psmisc net-tools bash-completion vim-enhanced -y
rpm -qf `which killall` #查看killall对用的软件包
rpm -ql net-tools # 查看net-tools对应哪些命令
[root@www ~]# yum groups mark convert
[root@www ~]# yum grouplist  
[root@www~]#yum groupinstall"Cinnamon"-y#<==指定包组名安装，要带双引号，装过的不能重复装。
2.5　本章相关问题 / 90
    1）32位和64位系统的区别是什么？
    2）请描述Linux分区的知识（包括设备名、主分区、扩展分区、文件系统类型等）。
    3）什么是挂载点，挂载点的作用是什么？
    4）企业场景如何针对不同的业务服务器规划分区方案？
    5）企业场景下Linux系统安装如何尽可能地最小化选包？
    6）企业场景下若线上运行的系统缺少部分包组或命令，应如何补救？
    7）如何将网卡设置为传统的eth0、eth1形式？
```

## 第3章　远程连接管理Linux实践 / 91
```
3.1　远程连接Linux系统管理 / 91
[root@www ~]# rpm -qa openssh openssl
openssl-1.0.2k-16.el7.x86_64
openssh-7.4p1-16.el7.x86_64
3.2　SSH客户端常用工具Xshell / 95
3.3　克隆VMware下的虚拟机 / 110

```
## 第4章　Linux系统命令行入门基础 / 114
```
4.1　Linux命令行概述 / 114
    [root@www ~]#    #<==这是超级管理员root用户对应的命令行。
    [oldboy@www ~]$  #<==这是普通用户oldboy对应的命令行。
    快捷键：
        tab  命令补全
    移动光标快捷键
        ctrl + a 
        ctrl + e
        ctrl + 方向右键
        ctrl + 方向左键
        ctrl + f 
        ctrl + b 
    剪切 粘贴 清除快捷键
        ctrl + insert  复制
        shift + insert 粘贴
        ctrl + k 
        ctrl + u 
        ctrl + w  
        ctrl + y 
        ctrl + c 
        ctrl + h  
        ctrl + d  
    重复执行命令快捷键
        ctrl + d
        ctrl + r
        ctrl + g  # 从ctrl+r 搜索中退出
        esc + .   
    控制快捷键
        ctrl + l 
        ctrl + s 
        ctrl + q 
        ctrl + z   #暂停执行在终端运行的任务
    ！号开头的快捷键命令
        ！！ 执行上一条命令
        !pw    执行最近以pw开头的命令
        !pw:p  # 仅打印
        !num   
        !$    #相当于esc .
    ESC相关
        esc + .
        esc + b
        esc + f
        esc + t  

4.2　在Linux命令行下查看命令帮助 / 118
     man cp  后操作
        page down  下一页
        page up   上一页
        home      第一页
        end        最后一页
        /old      向下查找
        ?old      向上查找 old字符串
        n，N    #接上一条搜索后 n向下匹配 N 向上匹配
        q    退出
    ls --help
        # LANG="zh_CN.UTF-8"  #中文显示帮助命令
        # echo $LANG
    help cd # help命令获取内置命令帮助
    info ls 

4.3　Linux关机重启注销命令 / 122
        shutdown 命令
            -r 重启   shutdown -r now
            -h 关机   shutdown -h now
            -P  关机 poweroff 
            -c  取消正在执行的shutdown 指令
[root@www ~]# ls -l `which reboot` `which poweroff` `which halt` `which shutdown`
lrwxrwxrwx. 1 root root 16 Jan 29 23:20 /usr/sbin/halt -> ../bin/systemctl
lrwxrwxrwx. 1 root root 16 Jan 29 23:20 /usr/sbin/poweroff -> ../bin/systemctl
lrwxrwxrwx. 1 root root 16 Jan 29 23:20 /usr/sbin/reboot -> ../bin/systemctl
lrwxrwxrwx. 1 root root 16 Jan 29 23:20 /usr/sbin/shutdown -> ../bin/systemctl
[root@www ~]# which systemctl
/usr/bin/systemctl

systemctl reboot 
systemctl poweroff
systemctl halt
systemctl suspend       # 暂停系统 
systemctl hibernate     # 冬眠状态
systemctl hybrid-sleep  # 交互式休眠状态
systemctl rescue        # 救援模式

shutdown -h now 
shutdown -h +1 
halt 
init 0
poweroff

reboot 
shutdown -r now 
shutdown - r +1 
init 6 

logout 
exit  

4.4　本章相关问题 / 126
    1）请描述Linux命令行提示符的含义及控制变量。
    2）Linux命令行常用的快捷键有哪些？
    3）如何在Linux命令行下查看帮助？
    4）请说出你知道的Linux系统的重启和关机命令。
```

## 第5章　Linux文件及目录管理命令基础 / 127

5.1　操作Linux必知必会基础知识 / 127
    Linux系统一切目录的起点都是从“/”根开始。
5.2　Linux文件及目录核心命令 / 129
```
        pwd -L  | echo $PWD
        cd  - ~ ..
        tree 
            -a  显示所有文件
            -d  只显示目录
            -f  显示每个文件的全路径
            -i  不显示树枝 常与-f 配合使用
            -L level  显示最大层数
            -F 不同文件结尾加上不同符号。类似 ls -F
        mkdir 
            -p  递归创建目录
            -m  设置新创建目录的默认权限
            -v  显示创建过程
        touch 创建文件或更改文件时间戳
            -a  更改指定文件的最后访问时间
            -m  更改指定文件的最后修改时间

            stat 文件名  3种类型的时间戳
                access 最后访问时间
                modify 最后修改时间
                change 文件状态最后被改变的时间
        ls   list
            -l 
            -a
            -t  根据最后修改时间排序
            -r  反向排序
            -F 
            -p   之在目录后面加“/”
            -i   显示inode 节点信息
            -d   遇到目录只显示目录本身
            -h   人类可读信息显示文件或目录大小
            -A   显示所有文件包括  .  ..
            -S   根据文件大小进行排序
            -R   递归所有子目录
            -x   逐行列出项目
            -X   根据扩展名排序
            -c   根据状态改变时间排序 ctime
            -u   根据最后访问时间 atime 排序
            --color={never|always|auto}
            --full-time
            --time-style={full-iso,long-iso,locale} # 不同时间格式
            --time={atime,ctime}
            ls 命令输出内容的属性解读
                inode节点号 文件类型及权限 硬链接数 属主及属组 文件或目录大小 最近修改时间 文件或目录名
        cp  copy
            -p 复制文件保持原文件的所有者 权限和时间属性
            -d 复制符号链接时候仅复制符号链接本身
            -r 递归复制目录
            -a  等同于上面的 pdr 总和
            -i  在覆盖已有文件提示用户确认
            -t  默认 cp 源目录 目标目录  -t 颠倒参数顺序
        mv  move  移动或重命名文件
            -f 文件存在直接覆盖不提示
            -i 提示是否覆盖
            -n  不覆盖已存在的文件
            -t  与cp 命令 -t 功能一致
            -u  在源文件比目标文件新，或者目标文件不存时才移动
        rm  remove     
            -f  强制删除
            -i  提示确认
            -I  在删除超过3个文件或者递归删除要求确认
            -r  递归删除目录及其内容
        #小笔记
        rename 用字符串替换的方式批量改变文件名。
            参数
            原字符串：将文件名需要替换的字符串；
            目标字符串：将文件名中含有的原字符替换成目标字符串；
            文件：指定要改变文件名的文件列表。
            
            # 将main1.c重命名为main.c
            rename main1.c main.c main1.c
#rename支持正则表达式
# 把文件名中的AA替换成aa
rename "s/AA/aa/" * 
# 把.html 后缀的改成 .php后缀
rename "s//.html//.php/" * 
# 把所有的文件名都以txt结尾
rename "s/$//.txt/" *
# 把所有以.txt结尾的文件名的.txt删掉
rename "s//.txt//" *
#批量去除文件名中的空格
rename 's/ /_/g' *

```

5.3　Linux文件及目录命令核心知识的试题及详解 / 156
5.4　有关Linux命令的思维 / 159
5.5　本章相关问题 / 159
## 第6章　Linux目录文件与系统启动知识 / 160
6.1　Linux系统目录结构介绍 / 160
        Linux系统的一切目录都是从“/”根开始的。
6.2　Unix系统目录结构的历史典故 / 162
6.3　Linux的目录结构详解 / 164
```
# tree -L 1 /

/
├── bin -> usr/bin    # binaries 二进制命令
├── boot      #内核启动文件
├── dev       # 设备文件
├── etc       # 配置文件默认路径
├── home      
├── lib -> usr/lib  # librares 共享库文件和内核默认存放目录
├── lib64 -> usr/lib64
├── media      #媒体文件挂载点
├── mnt        # mount  point 文件临时挂载点
├── opt        # option 可选择 安装额外的应用软件包目录
├── proc       # 操作系统运行时，进程信息及内核信息
                /proc/loadavg
                /proc/meminfo
                /proc/cpuinfo
                /proc/mounts
├── root       # root用户家目录
├── run        
├── sbin -> usr/sbin  # system binaries 系统管理命令
├── srv                # service 服务的数据所在目录
├── sys           # 与proc 类似  虚拟文件系统
├── tmp    # 临时文件目录
├── usr    # 系统存放程序目录，命令，帮助文件等。
            /usr/local  # 默认软件安装目录
            /usr/src  # 程序源码目录
└── var    # variable data  目录的内容经常变动
19 directories, 0 files

6.4　重要的Linux系统文件介绍 / 167
/etc/sysconfig/network-scripts/ifcfg-eth0: 网卡配置文件

# cat /etc/sysconfig/network-scripts/ifcfg-eth0

TYPE=Ethernet         #<==上网类型，目前基本上都是以太网。
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none        #<==启动协议，获取配置方式，有none|bootp|dhcp三个选项。
DEFROUTE=yes          #<==使用默认路由。
IPV4_FAILURE_FATAL=no
NAME=eth0             #<==第一块网卡的逻辑设备名，第二块为eth1。
UUID=e62dd7a9-92fa-4805-afc9-441b567ad38d #<==通用唯一识别码 (Universally Unique
                                              Identifier)，如果是VMware克隆的
                                              虚拟机，则会无法启动网卡，可以去除此项。
DEVICE=eth0           #<==第一块网卡的逻辑设备名，第二块为eth1。
ONBOOT=yes            #<==这个地方要为yes，才能保证下次开机启动时激活网卡设备。
IPADDR=192.168.2.217  #<==这是虚拟机桥接模式，局域网Linux服务器的固定IP。
PREFIX=24             #<==子网掩码位数，这里是24位。
DNS1=192.168.2.1      #<==主DNS，这里默认会覆盖以及优先于/etc/resolv.conf的配置生效。
GATEWAY=192.168.2.1   #<==局域网上网网关地址。

/etc/resolv.conf    # dns客户端配置文件
/etc/hostname  
    hostname www  # 临时修改主机名
    hostnamectl set-hostname www #永久修改主机名
/etc/hosts # 系统本地dns解析文件
/etc/fstab  # 配置开机设备自动挂载文件
/etc/rc.local  # 存放开机自启动程序命令的文件
/etc/inittab  #系统启动时设定运行级别等配置文件

# 0  关机（请不要将系统运行级别设置为0）

# 1  单用户模式（忘记root用户密码，可用此模式找回）

# 2  没有NFS，多用户模式

# 3  命令行模式 文本模式（企业级服务器核心的运行状态）

# 4  未使用

# 5  图形化模式 桌面模式 X11（桌面个人版系统的运行状态）

# 6  重启（请不要将系统运行级别设置为6）

# runlevel

N 3 #<==N为上一次的运行级别，3为当前的运行级别。

# init 4   #<==将运行级别修改为4，测试（生产服务器不能随意测试）。

# runlevel

3 4

# init 3

# runlevel

4 3

/etc/profile及/etc/bashrc  #配置环境变量
/etc/profile.d  #用户登录后执行的脚本所在目录
/etc/issue  /etc/issue.net  #配置用户登录终端前显示信息的文件
/etc/init.d/  软件启动程序所在目录（centos7以前）
/etc/motd/     配置用户登录系统之后显示提示内容的文件
/etc/redhat-release: 
/etc/sysctl.conf  #linux内核参数设置文件

/usr目录的重要知识
/usr/local/  #类似 c:/Program files
/usr/src     # 存放源码文件

/var 目录
/var/log  日志文件
    message 系统级日志文件
    secure  安全日志文件
    dmesg    硬件信息加载情况日志文件
    cron     定时任务日志文件
    wtmp     登陆者信息文件 last命令会自动读取
    lastlog  记录用户近期的登录情况， lastlog命令自动读取该文件
/proc 目录
    /proc/cpuinfo
    /proc/meminfo 
    /proc/loadavg 
    /proc/mounts     #当前设备挂载列表信息文件
    /proc/interrupts #当前系统中段信息文件

6.5　Linux（CentOS6）系统启动流程说明（重点） / 179
    1- 开机按钮 计算机加载BIOS自检
    2- 读取MBR信息  # master boot Record主引导记录，磁盘上的0柱面0磁道1扇区
    3- 加载Grub菜单  # boot loader 引导加载程序 /etc/grub.conf 类似windows c:/boot.ini
    4- 加载kernel 内核以及驱动程序
    5- 启动init程序 读取inittab文件
    6- init程序执行 rc.sysinit初始化系统
    7- init进程加载内核相关模块
    8- init进程执行对应运行级别下的脚本
    9- 加载/etc/rc.local
    10- 启动mingetty ，进入登录前的状态

6.6　Linux（CentOS7）系统启动流程说明（重点） / 184
    1- 开机按钮 计算机加载BIOS自检
    2- 读取MBR信息  # master boot Record主引导记录，磁盘上的0柱面0磁道1扇区
    3- 加载Grub菜单  # boot loader 引导加载程序 /etc/grub.conf 类似windows c:/boot.ini
    4- 加载kernel 内核以及驱动程序
    5- systemd进程，加载如下文件  
        1 /usr/lib/systemd/system/initrd.target  
        2 /etc/systemd/system/default.target #运行target模式及加载脚本
        3 systemd执行sysinit.target  #初始化系统及加载basic
        4 systemd启动multi-user.target
        5 systemd执行multi-user.target下的/etc/rc.d/rc.local内容 #开机自启动程序
        6 systemd执行multi-user.target下的getty.target及登录服务 
        7 systemd执行graphical所需要的服务（如果安装了图形桌面功能）
```

## 第7章　Linux文件过滤及内容编辑处理 / 187
```
7.1　vi/vim：纯文本编辑器 / 187
    vim分为三种模式：普通模式、编辑模式、命令模式
        普通默认： 移动光标  hjkl
        编辑模式： 普通模式下按 i I o O a A r R s S 
        命令模式： 普通模式下输入 : 或 / 或 ？

    普通模式： 移动光标操作
        G 或者 shift +g 将光标移动到最后一行
        gg  移动到文件第一行 等于 1gg 或1G
        0   当前行的行首
        $   当前行尾
        n<enter>  n为数字 从当前位置向下移动n行
        ngg   n为数字 移动到文件的第几行
        H    光标移动到当前窗口最上方那一行
        M                      最中间
        L                      最下方
        h                 左
        j                 下
        k                 上
        l                 右
    普通模式： 搜索与替换操作
        /old      从当前光标向下寻找
        ?OLD                向上
        n
        N
        :g/A/B/g 
        :s/A/B/g    #同上 全部替换 A -》B   #这个是替换当前行
        :n1,n2s/A/B/g   只替换 n1行和到n2行   n1,n2为数字
    
        :{作用范围}s/{目标}/{替换}/{替换标志}
        例如:%s/foo/bar/g会在全局范围(%)查找foo并替换为bar，所有出现都会被替换（g）global
    
        :%s/foo/bar  #空替换标志表示只替换从光标位置开始，目标的第一次出现,替换一次.


​    
​    普通模式： 复制，粘贴，删除等操作
​        yy
​        nyy
​        p/P
​        dd
​        ndd
​        u    # 恢复
​        .     重复前一个执行过的动作
​        x     向后删除字符
​        X     向前删除字符
​        d1G   删除当前行至第一行
​        dG    删除当前行到结尾
​        d0    删除当前光标文本至行首
​        d$    删除当前光标文件至行尾
​    进入编辑模式命令
​        i
​        a
​        I
​        A 
​        O 
​        o 
​        Esc 
​    命令行模式
​        :wq
​        :wq!
​        :q!
​        :n1,n2 w filename
​        :n1,n2 co n3
​        :n1,n2 m n3
​        :!command
​        :set nu
​        :set nonu 
​        :vs filename 
​        :sp filename 
​        1 + # + Esc  # 在可视块模式下 一定行注释所选的多行 取消注释可用“n1,n2s/#/ /gc”
​        Del    # 可视块模式下 一次性删除所选内容
​        r      # 可视块模式下 一次性替换所选内容

7.2　echo：显示输出文本内容 / 193
        -n 不要自动换行
        -E 不解析转义字符
        -e 

7.3　cat：合并文件或查看文件内容 / 195
         concatenate
        # cat file.txt
        # cat file1.txt file2.txt > newfile.txt
        # cat >> file1.txt <<EOF
          i am eric, i like linux.
          EOF
        # cat /dev/null > file1.txt 

    -n   输出行号
    -b   输出行号 但是忽略空白行
    -s   连续两行以上的空白行 就替换为一行
    -A   等价于 -vET 
    -e   等价于 -vE
    -E   在每一行的行尾显示$符号
    -t   与-vT 等价
    -T    将Tab字符显示为 ^I
    -v    除了lfd 和tab之外 使用 ^ 和 M- 引用

7.4　more：分页显示文件内容 / 203
    参数命令    
        -num 指定屏幕显示大小为num行
        +num  从行号num开始显示
        -s    将连续的多个空行显示为一行
        -p   不滚屏，而是清除整个屏幕，然后显示文本
        -c   不滚屏，而是第一屏的顶部开始显示文本，每显示完一行，就清除这一行的剩余部分
    交互命令
        h或？ 查看帮助
        空格键   向下滚动一屏
        enter   向下显示一行
        f         向下滚动一屏
        b       返回上一屏
        =       输出当前行号
        /查找的文本 
        :f      输出文件名和当前行号
        v        调出vi编辑器
        !命令    调出shell 并执行命令
        q   退出more

7.5　less：分页显示文件内容 / 205
    参数：
        -N  显示行号
    交互命令：
        b   向前翻一页
        空格  向后翻一页

7.6　head：显示文件头部内容 / 208
        -n<行数>  指定显示行数
7.7　tail：显示文件内容尾部 / 210
        -n<行数>  指定显示行数
        -f      实时输出文件变化后的追加数据

7.8　grep:文本过滤工具 / 211
        -v 显示不匹配的行
        -n 显示匹配的行号
        -i  不区分大小写
        -E  使用扩展的egrep命令
        -w  以单词为单位进行过滤
        -o   只输出匹配的内容

7.9　tr：替换或删除字符 / 214
        -d 删除字符

7.10　 有关vi/vim/cat/echo及特殊重点符号的考试题 / 216

7.11　有关grep/head/sed/awk及特殊重点符号的考试题 / 222
7.12　有关mkdir命令的考试题 / 223
7.13　有关cp/alias/unalias命令的考试题 / 224
7.14　本章知识总结 / 226
第8章　Linux文件类型及查找命令实践 / 227
8.1　Linux文件属性概述 / 227
文件或目录的属性主要包括：索引节点（Inode）、文件类型、权限属性、链接数、所归属的用户和用户组、最近修改时间等内容。
8.2　Linux文件类型及文件扩展名 / 228
        .rpm
        .tar.gz
        .sh
        .conf  
    文件类型：
        -  普通文件 regular file 包含纯文本 二进制 数据文件
        d  directory 目录
        l  link    链接文件 
        c   character   设备文件  例如：串口设备
        b    block    设备文件  例如： 硬盘 光驱
        s    socket   套接字文件   进程之间通信会用到
        p    named pipe  管道文件

8.3　文件及目录查找命令 / 234
    file 显示文件类型 
    which 显示命令全路径
            -a  遍历所有的PATH路径。并输出所有匹配项
    whereis  显示命令及相关文件全路径
            -b 只找可执行文件
            -m 只找man帮助手册
    locate 快速定位文件路径
            # yum install mlocate -y   #<==安装命令对应的软件包。
            # updatedb                 #<==初始化命令查找的数据库。
    updatedb 命令可以创建或更新locate命令使用的数据库。

    find  -H -L -P  path  expression        
                            options  tests actions
        plathname  命令所查找的目录路径
        options 模块
            -maxdepth levels 查找的最大目录级数， levels为自然数
    
        Tests 模块
            -mtime    按文件的修改时间来查找文件
            -name     按文件名查找
            -type     查找某一类型的文件
        Actions 模块    
            -exec     对匹配的文件执行该参数所给出的命令
            ！    取反
            -a    取交集  and 
            -o    取并集  or

8.4　tar：打包压缩命令 / 254
        z  通过gzip压缩
        c   创建新的tar包
        v   显示详细执行过程
        f   指定压缩文件名字
        t   不解压查看tar 包的内容
        x    解开tar包
        C    指定解压的目录路径
        --exclude=PATTERN  打包时排除不需要的目录或文件

8.5　date：显示与设置系统时间 / 258
    -d 时间字符串   #显示指定字符串所描述的时间
    -s 时间日期     # 设置系统时间
    %F  完整的日期格式
    %w  一星期中的第几日  0-6
    %y  年份的最后两位
    %Y   年份
```

## 第9章　Linux文件核心属性知识 / 263
```
9.1　回顾Linux文件属性知识 / 263
9.2　用户及用户组 / 263
        UID  user identify
        GID  group identify
     uid                         角色   
      0                       超级用户root
      1~499                   虚拟用户
      500~60000（centos6 ）   普通用户
      1000-60000 （centos7）  普通用户

    useradd 

9.3　文件的权限列 / 268
        r read          数字4
        w  write 写权限 数字2
        x  execute      数字1 
        没有任何权限 对应数字0
    chmod    

9.4　文件的修改时间属性列 / 270
Access: 2017-07-30 17:48:20.502156890 +0800    #<==文件最后被访问的时间。
Modify: 2017-07-30 17:48:45.006106223 +0800    #<==文件最后被修改的时间。
Change: 2017-07-30 17:48:45.006106223 +0800    #<==文件状态最后被改变的时间。

ls -lt
ls -lc

9.5　索引节点 / 270
ls -lhi /data
inode 本质上是一块具备唯一编号的存储空间，用来存储文件（目录）的属性信息
block 磁盘块，用来存放实际数据的实体单元，ext文件系统一般最大4kb

df -i # 查看文件系统inode总量使用情况
df -h # block是存放数据位置 数据实体
情况一：Block耗尽的情况，例如500GB磁盘存放400GB+200GB的视频。
情况二：Inode耗尽的情况，产生大量的小文件（小于1KB）。

9.6　硬链接及软链接数知识 / 276
ln 原始文件  目标文件   #硬链接创建
ln -s 原始文件 目标文件 #软链接创建
 1.从ext文件系统的角度描述文件删除的原理
 Linux系统上的文件名是存储在父目录的Block里面的，并指向了这个文件的Inode节点，这个文件的Inode节点再标记指向存放这个文件的Block的数据块。我们删除一个文件时，实际上并不会清除Inode节点和Block的数据。只是在这个文件的父目录中的Block里，删除这个文件的名字，从而使这个文件名消失，并且无法指向这个文件的Inode节点。当没有文件名指向这个Inode节点的时候，释放Inode节点和存放这个文件数据的Block块会同时进行，并且会更新Inode MAP和Block MAP，以便让这些位置用于放置其他文件数据。
 2.从文件引用的角度深入描述文件删除的原理
 Linux系统是通过Link的数量来控制文件是否被删除的，只有当一个文件不存在任何Link的时候，这个文件才会被删除。一般来说，每个文件都有2个Link计数器，既i_count和i_nlink。i_nlink的意义就是前面讲的文件硬链接的数量，i_nlink可以理解为磁盘的引用计数器；i_count的意义就是当前文件使用者（例如，被进程调用）的数量，i_count可以理解为内存的引用计数器。当为文件创建硬链接的时候，对应i_nlink的数量就会增加，而当一个文件被某个进程调用时，对应i_count的数量就会增加。通过rm删除命令删除文件，实际上就是减少文件的磁盘引用计数i_nlink的数量。这里就会出现一个问题，如果一个文件正在被某个进程调用，而用户却执行rm操作将文件删除了，那么会出现什么结果呢？在用户执行rm操作删除文件之后，再执行ls或者其他文件管理命令，将会无法再找到这个文件，但是调用这个被删除文件的进程却在继续正常执行，依然能够从文件中正确地读取及写入内容。这又是为什么呢？
 这是因为rm操作只是将文件的i_nlink数减少了，如果没其他的链接，i_nlink就为0了；但由于该文件依然在被进程引用，因此，此时文件对应的i_count数并不为0，所以即使执行了rm操作，但系统并没有真正删除这个文件，因此该文件还会占用磁盘空间，只有当i_nlink及i_count都为0的时候，这个文件才会真正被删除。也就是说，还需要解除该进程对该文件的调用，被rm删除的文件才会真正被删除。

9.7　chattr：改变文件的扩展属性 / 287
相比chmod 是更底层的属性控制
    -i  设定文件不能删除 改名，写入或新增内容
    -a  只能对文件追加数据。而不能删除

9.8　lsattr：查看文件扩展属性 / 289

```
## 第10章　Linux通配符与特殊符号知识应用实践 / 291
```
10.1　Linux通配符与特殊符号简介 / 291
10.2　Linux通配符知识与实践 / 291
    符号     
        *  任意个字符或字符串包括空字符串
        ？ 匹配任意1个字符
     字符集合
        [abcd] #匹配abcd中任何一个字符
        [a-z]  #匹配a到z之间的任意一个字符    
        [!abcd] 不匹配括号里面的任何一个字符,同 [^abcd] 一样
10.3　Linux特殊符号知识与实践 / 294
        ~  家目录
        -  上一次目录
        .   当前目录
        ..  上级目录

        标准输入 stdin   <   <<
        标准输出 stdout  >   >>
        标准错误 stderr  >   >>
    
        标准输入重定向 0<   <
        追加输入重定向 0<<  <<
        标准输出重定向 1>   >
        标准输出追加重定向  1>>  >>
        标准错误输出重定向  2>
        标准错误输出追加重定向 2>>
    特殊重定向用法：标准错误和标准输出一样重定向到文件中
        echo “i like linux” 1>>eric.txt 2>>eric.txt
        echo “i like linux” &>>eric.txt 
        echo “i like linux” >>eric.txt 2>&1
    
    ;  命令结束 也是命令分隔符
    # 注释
    | 管道  
    $ 字符前面加表示字符串变量 | 代表普通用户命令提示符
    \  还原字符本意
    {}  生成序列   | 引用变量
    
    ‘’  单引号  所见即所得
    “”   双引号 会将变量 命令 转义字符解析除结果
    ``  相当于$() 引用命令
    
    &&  与 
    ||  或  
    ！  非   取反  | 在vim表示强制 | 在!ls 表示找出最近一次ls开头的命令并运行

10.4　Linux通配符与特殊符号知识小结 / 301
```

## 第11章　Linux正则表达式与三剑客知识应用实践 / 304
```
11.1　正则表达式介绍 / 304
        grep/egrep  sed  awk 

# ifconfig eth0|sed -rn '2s#^.*inet （.*）net.*$#\1#gp' #<==CentOS7下的命令。

10.0.0.7    
11.2　正则表达式的分类 / 306
基本正则表达式（BRE，basic regular expression）
扩展正则表达式（ERE，extended regular expression） 

BRE 
    ^    # "^old" 以old开头的行    
    $    # "old$" 以old结尾的行
    ^$   #空行
    .    #任意一个字符
    \    #转义字符 
    *    # 匹配前一个字符0次或1次以上
    .*   # 匹配所有内容
    ^.*  # 匹配任意多个字符开头的内容
    .*$  # 匹配任意多个字符结尾的内容 
    [abc] #匹配 [] 内的任意一个字符
    [^abc] # 匹配不包含 ^ 后的任意字符a或b或c。

ERE    grep -E 支持  egrep支持 
    +        匹配前一个字符1次或多次
    [:/]+    匹配括号的：或/ 字符1次或多次
    ?        匹配前一个字符0次或1次
    |         表示或者
    ()         分组过滤   () 内容可以被后面 \数字 引用 
    \n       引用前面小括号的内容 ， 例如     (aa)\1
    a{n,m}   匹配前一个字符最少n次 最多m次
    a{n,}    匹配前一个字符最少n次  
    a{n}     匹配前一个字符正好n次
    a{,m}    匹配前一个字符最多m次

11.3　基本正则表达式实践 / 307    
mkdir ~/test -p
cat >~/test/oldboy.txt<<EOF
I am oldboy teacher!
I teach linux.
I like badminton ball ,billiard ball and chinese chess!
our site is http://www.oldboyedu.com
my qq num is 49000448.
not 4900000448.
my god ,i am not oldbey,but OLDBOY!
EOF

# grep -n "^m" oldboy.txt  #<==-n是打印过滤的内容在原文件中的行号。 m开头的行

# grep "m$" oldboy.txt

# grep "m$" oldboy.txt|cat -A

# grep -n "^$" oldboy.txt

# grep -n "." oldboy.txt  # 匹配任意一个字符并输出对应文件中的行号

# grep ".$" oldboy.txt #匹配.号结尾的行

# grep "\.$" oldboy.txt #匹配.号结尾的行

# grep '0*' oldboy.txt

# grep '.*' oldboy.txt

# grep '^.*o' oldboy.txt

❏[a-z]表示匹配所有单个小写字母。
❏[A-Z]表示匹配所有单个大写字母。
❏[a-zA-Z]表示匹配所有单个大小写字母。
❏[0-9]表示匹配所有单个数字。
❏[a-zA-Z0-9]表示匹配所有字母和数字。
grep命令的-o（小写字母O）来显示grep命令到底匹配到了什么。

# grep '[A-Z]' oldboy.txt

# grep -o "[oldboy]"  oldboy.txt

# grep '[^a-z] oldboy.txt

11.4　扩展正则表达式实践 / 312

# egrep "0+" oldboy.txt

# egrep -o "0+" oldboy.txt

# cat oldgirl.txt  #<==换个测试文件。

good
glad
gd
god
goood

# egrep 'go?d' oldgirl.txt

# egrep '3306|1521' /etc/services

# cat oldgirl.txt

good
glad
gd
god
goood

# egrep 'goo|lad' oldgirl.txt

# egrep 'g（oo|la）d' oldgirl.txt

# egrep "（o）\1" oldgirl.txt

# egrep "0{3,5}" oldboy.txt #<==匹配数字0，3到5次。

# egrep "0{,5}" oldboy.txt  #<==匹配数字0，最多5次，全部输出了。

# egrep "0{3,}" oldboy.txt #<==匹配数字0，最少3次。

# egrep "0{3}" oldboy.txt  #<==匹配数字0，3次。

11.5　预定义特殊中括号表达式 / 315  不常用
    [:alnum:]   # [a-zA-Z0-9] 
    [:alpha:]   # [a-zA-Z]
    [:digit:]   # [0-9]
    [:lower:]   # [a-z]
    [:upper:]   # [A-Z]
    [:space:]   # 换行符 回车等所有空白符
    。。。

11.6　元字符表达式 / 316
    \b   匹配单词边界  例如\old\b 只匹配old单词 不匹配 old* 
    \B   匹配非单词边界 例如\old\B  不匹配单独的old单词 匹配old123 
    \w   匹配 字母、数字与下划线
    \W   匹配 字母、数字与下划线以外的字符
    \d   匹配单个数字字符   需要使用 grep —P 才能识别 
    \D   匹配单个非数字字符 需要使用 grep —P 才能识别 
    \s   匹配1位空白字符    需要使用 grep —P 才能识别  
    \S   匹配1位非空白字符  需要使用 grep —P 才能识别  

# grep "\boldboy\b" test.txt #<==匹配oldboy这个单词，可用\<oldboy\> 替代。

# grep 'oldboy\B' test.txt   #<==匹配oldboy字符串，但不匹配oldboy这个单词。

# grep '\w' test.txt         #<==匹配字母、数字、下划线，不匹配其他字符。

# grep '\W' test.txt         #<==对\w的匹配取反。

# grep -P "\d" test.txt      #<==匹配数字，注意要加-P参数才行。

# grep -P "\D" test.txt      #<==匹配非数字，注意要加-P参数才行。

11.7　sed：流编辑器 / 317
    Stream Editor  字符流编辑器
    sed是操作、过滤和转换文本内容的强大工具，文件的增删改查

    option    
        -n  取消默认的sed输出，
        -i  直接修改文件
        -e  允许多次编辑
    sed 内置符
        a    append 追加文本
        d    delete 删除匹配的文本
        i    insert  插入文本
        p    print   打印
        s/regexp/replacement/g   用replacement替换regexp匹配的内容， g表示全局替换

# cat -n oldboy.txt

    1     I am oldboy teacher!
    2     I like badminton ball ,billiard ball and chinese chess!
    3     our site is http://www.oldboyedu.com
    4     my qq num is 49000448.

# sed -n '2,3p' oldboy.txt #<==-n表示默认不输出，根据要求输出第2-3行，输出用p。

# sed -n '/oldboy/p' oldboy.txt  #<==-n表示默认不输出，利用p输出包含oldboy的行。

# sed '/oldboy/d' oldboy.txt  #<==用d符号删除包含oldboy的行。

sed -i '3d' oldboy.txt   #<==删第3行。
sed -i '5,8d' oldboy.txt  #<==删除第5～8行。

# sed 's#oldboy#oldgirl#g' oldboy.txt

#<==s加g表示全局替换，中间的间隔符可以用“#@/”等符号替代，前两个“#”号之间表示想要替换的内容，后两个“#”号之间表示替换后的内容。

# sed -e 's#oldboy#oldgirl#g' -e "s#49000448#31333741#g" oldboy.txt

# sed -i '2a I teacher linux.' oldboy.txt

#<==这里使用了sed内置命令a追加功能，在第二行后面增加一行，内容为“I teacher linux.”。

# sed -i '2i I teacher linux,at 2i.' oldboy.txt

# sed '2i I teacher linux.\nYou are my student.' oldgirl.txt

[root@oldboyedu ~]# ifconfig eth0|sed -n '2s#^.*inet##gp'|sed -n 's#netm.*$##gp'
#<==注意最后一个管道后面的才是这次匹配的命令，-n默认不输出，#netm.*$#匹配了IP后面的所有字符（紧接着IP后的两个空格先暂且忽略），“##”表示替换为空，然后输出剩下的内容（就只有IP地址了）。
  10.0.0.7   #<==此时的IP地址，实际上结尾和开头都是有空格的，也可以匹配这些空格并删掉。
[root@oldboyedu ~]# ifconfig eth0|sed -n '2s#^.*inet ##gp'|sed -n 's#  netm.*$##gp'   #<==inet后面匹配一个空格，netm前面匹配两个空格。
10.0.0.7   #<==结果就是只有ip，没有空格了。

# ifconfig eth0|sed -ne '2s#^.*inet ##g' -ne '2s# netm.*$##gp'

[root@oldboyedu ~]# ifconfig eth0|sed -nr '2s#^.*inet （.*） netm.*$#\1#gp'#<==-r支持小括号功能。
#<==“\1”用于获取小括号的内容输出，为什么（.*）就匹配到了IP呢？这是因为它前面明确匹配到字符串了，后面的开头也给出了固定匹配的字符串，因此中间的“.*”就只能是匹配IP了，也就是说根据目标前后匹配的结果就能知道中间的内容了。
10.0.0.7

11.8　awk命令 / 322
awk不仅仅是Linux系统中的一个命令，而且其还是一种编程语言，可以用来处理数据和生成报告（excel）
awk 常用功能
    指定分割显示某几列    awk -F “GET|HTTP” '{print $2}' access.log  
    通过正则表达式取出想要获取的内容   awk '$6~/Failed/{print $11}' /var/log/aecure 
    显示某个范围内的内容   awk 'NR=20,NR=30' filename 显示20到30行
    通过awk进行统计计算    awk '{sum+=$0}END{print sum}' ett.txt 进行总和计算（高级功能）
    awk属组计算与去重      awk '{array[$1]++}END{for (key in array) print key,array[key]}' access.log 对日志进行统计与计数（高级功能）

awk  [option]   'pattern{action}' file ...
awk   [参数]    '条件{动作}'    文件 ...

参数
    -F     指定字段分隔符
    -v     定义或修改一个awk内部的变量

常用功能  变量名
    $0    当前整行记录 
    $n    当前记录第n列 
    NF     当前记录的列的个数
    $(NF-n) 倒数第n+1列  n为数字  
    NR       已经读出的记录数  行号。从1开始

# sed -n '1,5p' /etc/passwd >test.txt

# awk 'NR>1&&NR<4' test.txt  #<==NR表示行号，&&表示并且。

awk'NR==2'test.txt  #取第二行

# awk 'NR==2,NR==3' test.txt #<==NR表示行号，用逗号表示从第2行到第3行。

# awk '/root/' test.txt  #<==类似于sed的过滤功能，但是结尾不需要p符号了。

# awk '/^[^r]/' test.txt  #<==匹配以非r字母开头的行，因为第一行是以root开头，所以没匹配。 配合重定向实现删除root开头的行

# awk -F ":" '{print NR,$1,$3,$NF}' test.txt#<==注意语法格式。？取文件的第一列、第三列和最后一列的内容，并打印行号

#<==-F ":"表示以冒号为分隔符，print是打印，$1是取分隔后的第一列，NF是取最后一列，NR表示行号。
1 root 0 /bin/bash
2 bin 1 /sbin/nologin
3 daemon 2 /sbin/nologin
4 adm 3 /sbin/nologin
5 lp 4 /sbin/nologin

CentOS7取IP所在的行：   inet addr:10.0.0.7  Bcast:10.0.0.255  Mask:255.255.255.0
CentOS6取IP所在的行：   inet 10.0.0.7  netmask 255.255.255.0  broadcast 10.0.0.255

# ifconfig eth0|awk 'NR==2{print $2}'

#<==NR==2表示输出第二行，默认以空格作为分隔符，$2表示取第二列。CentOS7下取IP变得简单了。
[root@oldboy ~]# ifconfig eth0|awk 'NR==2'
    inet addr:10.0.0.7  Bcast:10.0.0.255  Mask:255.255.255.0
[root@oldboy ~]# ifconfig eth0|awk -F "[: ]+" 'NR==2{print $4}' #<==设定多分隔符的方法。
#<==-F "[: ]+"指定冒号或者空格作为分隔符，“+”号就是匹配冒号或者空格1次或多次，即多个分隔符靠到一起算一个分隔符。

[root@oldboy ~]# ifconfig eth0|awk 'NR==2'
     inet addr:10.0.0.7  Bcast:10.0.0.255  Mask:255.255.255.0
[root@oldboy ~]# ifconfig eth0|awk -F "（addr:）|（  Bcast:）" 'NR==2{print $2}'
#<==竖线符号的意思表示匹配或者左边或者右边，小括号是分组，其将作为一个整体，即以“addr:”或“  Bcast:”做分隔符。

[root@oldboy ~]#  awk -F ":" '$1~/root/ {print $NF}' test.txt
#<==$1~/root/表示第一列内容匹配root条件，$NF表示最后一列。
/bin/bash

[root@oldboyedu ~]# cat test1.txt
张三 男  80
李四 女  70
王五 男  90
赵六 女  100
[root@oldboyedu ~]# awk '$3>70&&$3<95{print $1,$2}' test1.txt
张三 男
王五 男

11.9　本章重点 / 327
```
## 第12章　Linux系统权限知识及应用实践 / 328
```
12.1　文件权限介绍 / 328
前三位用户权限位     中三位用户组权限位   后三位其他用户权限位
rwx                    r-x                 r-x 
user                  group                others 
代表字符 u             g                    o

12.2　Linux文件及目录权限核心知识说明 / 329
普通文件对应的权限的重要知识：
1）可读r：表示具有读取、浏览文件内容（即读取文件实体block）的权限。
2）可写w：表示具有新增、修改、删除文件内容的权限。
3）可执行x：表示具有执行文件的权限
对于可读r，说明：
    - 没有可读r配合 vim编辑文件提示无法编辑，但可以使用echo 命令重定向或追加内容到文件。
    - 删除，移动或创建文件等权限受父目录的权限控制（因为文件名没有放在inode里，而是上级目录的block里存放着，受上级目录的inode权限控制）与文件本身权限无关。因此文件的本身可写w权限，与文件是否能删除和改名无关。

对于可执行x 说明：
    - 文件本身要能执行
    - 普通用户，同时需要具备可读r权限才能执行
    - root用户只要有x权限就可以执行

目录对应读、写、执行权限的详细说明
    1）可读r：表示具有浏览目录下面文件及子目录名的权限，ls dir ，cd 目录需要目录有x权限
    2）可写w：表示具有增加、删除或修改目录内文件的权限。需要x权配合
    3）可执行x：表示具有进入目录的权限  cd dir 

12.3　Linux权限体系核心知识实践 / 330
incahome组 有用户 oldboy  oldgirl  
其他人   test      
[root@oldboy ~]# groupadd incahome #<==groupadd是添加用户组的命令。
[root@oldboy ~]# userdel -r oldboy
#<==如果之前已经创建了oldboy用户，就先删除再创建。
[root@oldboy ~]# useradd oldboy -g incahome 
#<==添加oldboy用户并加入incahome组。
[root@oldboy ~]# id oldboy #<==查看创建的oldboy用户及所属组的信息。
uid=500（oldboy）gid=502（incahome）groups=502（incahome）
#<==发现组已经更改为了incahome。
[root@oldboy ~]# useradd oldgirl -g incahome
#<==添加oldgirl用户并加入incahome组。
[root@oldboy ~]# id oldgirl #<==查看创建的oldgirl用户及所属组信息。
uid=501（oldgirl）gid=502（incahome）groups=502（incahome）

[root@oldboy ~]# useradd test
[root@oldboy ~]# id test
uid=502（test）gid=503（test）groups=503（test）

[root@oldboy ~]# mkdir -p /oldboy #<==在根下创建测试目录oldboy。
[root@oldboy ~]# echo "echo oldboyLinux" >/oldboy/test.sh 
#<==生成脚本文件test.sh，内容是打印oldboyLinux字符串。
[root@oldboy ~]# cat /oldboy/test.sh #<==查看脚本test.sh内容。
echo oldboyLinux
[root@oldboy ~]# chmod +x /oldboy/test.sh 
#<==添加执行权限，chmod的使用详见本章后文。
[root@oldboy ~]# ls -l /oldboy/test.sh    #<==查看授权后的权限属性。
-rwxr-xr-x. 1 root root 17 Apr 30 09:55 /oldboy/test.sh

# 创建用于测试的目录及文件环境

[root@oldboy ~]# mkdir -p /oldboy #<==在根下创建测试目录oldboy。
[root@oldboy ~]# echo "echo oldboyLinux" >/oldboy/test.sh 
#<==生成脚本文件test.sh，内容是打印oldboyLinux字符串。
[root@oldboy ~]# cat /oldboy/test.sh #<==查看脚本test.sh内容。
echo oldboyLinux
[root@oldboy ~]# chmod +x /oldboy/test.sh 
#<==添加执行权限，chmod的使用详见本章后文。
[root@oldboy ~]# ls -l /oldboy/test.sh    #<==查看授权后的权限属性。
-rwxr-xr-x. 1 root root 17 Apr 30 09:55 /oldboy/test.sh

#使用xshell 四个创建登录 root oldboy oldgirl test 用户测试
[root@oldboy ~]# ls -ld /oldboy
drwxr-xr-x. 2 root root 4096 Apr 30 09:55 /oldboy
[root@oldboy ~]# ls -l /oldboy/test.sh
-rwxr-xr-x. 1 root root 17 Apr 30 09:55 /oldboy/test.sh
测试读r的命令为：cat /oldboy/test.sh
测试写w的命令为：echo "echo oldboy" >>/oldboy/test.sh
测试执行x的命令为：/oldboy/test.sh
测试删除的命令为：rm -f /oldboy/test.sh
[oldboy@oldboy ~]$ cat /oldboy/test.sh  #<==可以查看文件内容，说明有读文件的权限。
echo oldboyLinux
[oldboy@oldboy ~]$ echo "echo oldboy" >>/oldboy/test.sh #<==往文件里追加内容。
-bash: /oldboy/test.sh: Permission denied  #<==提示拒绝，不能往文件里追加内容，说明不能写。
[oldboy@oldboy ~]$ /oldboy/test.sh  #<==执行后有打印输出，说明有执行的权限。
oldboyLinux
[oldboy@oldboy ~]$ rm -f /oldboy/test.sh #<==测试一下删除文件。
rm: cannot remove `/oldboy/test.sh': Permission denied #<==依然提示拒绝。
[root@oldboy ~]# chown oldboy.incahome /oldboy/test.sh #<==将文件所属的用户改为oldboy，组改为incahome。
[root@oldboy ~]# ls -l /oldboy/test.sh  #<==查看修改后的结果。
-rwxr-xr-x. 1 oldboy incahome 17 Apr 30 09:55 /oldboy/test.sh

[oldboy@oldboy ~]$ whoami
oldboy
[oldboy@oldboy ~]$ cat /oldboy/test.sh   #<==可以浏览内容。
echo oldboyLinux
[oldboy@oldboy ~]$ echo "echo oldboy" >>/oldboy/test.sh  #<==可以追加（写）内容。
[oldboy@oldboy ~]$ cat /oldboy/test.sh   #<==查看追加结果。
echo oldboyLinux
echo oldboy
[oldboy@oldboy ~]$ /oldboy/test.sh      #<==可以执行文件。
oldboyLinux
oldboy

[oldgirl@oldboy ~]$ whoami
oldgirl
[oldgirl@oldboy ~]$ cat /oldboy/test.sh    #<==可以浏览内容。
echo oldboyLinux
echo oldboy
[oldgirl@oldboy ~]$ echo "echo oldboy" >>/oldboy/test.sh    #<==不可以写入，这一点符合预期。
-bash: /oldboy/test.sh: Permission denied
[oldgirl@oldboy ~]$ 
[oldgirl@oldboy ~]$ /oldboy/test.sh         #<==可以执行。
oldboyLinux
oldboy
[oldgirl@oldboy ~]$ rm -f /oldboy/test.sh    #<==不能删除文件。
rm: cannot remove `/oldboy/test.sh': Permission denied

[root@oldboy ~]# chmod 751 /oldboy/test.sh
[root@oldboy ~]# ls -l /oldboy/test.sh
-rwxr-x--x. 1 oldboy incahome 29 Apr 30 10:38 /oldboy/test.sh #<==其他用户权限的r权限已经去掉。

[oldboy@oldboy ~]$ rm -f /oldboy/test.sh  #<==依然无法删除，oldboy用户对于tesh.sh来说是用户，权限看前三位，不是有w权限么？为什么删除不了呢？
rm: cannot remove `/oldboy/test.sh': Permission denied
[test@oldboy ~]$ /oldboy/test.sh #<==其他用户位有x权限，但是依然无法执行。
bash: /oldboy/test.sh: Permission denied

[root@oldboy ~]# chmod 000 /oldboy/test.sh #<==将文件调整为无任何权限。
[root@oldboy ~]# ls -l /oldboy/test.sh
----------. 1 oldboy incahome 29 Apr 30 10:38 /oldboy/test.sh #<==查看调整结果。
[root@oldboy ~]# chown -R oldboy /oldboy #<==将test.sh的上级目录所属的用户修改为oldboy。
[root@oldboy ~]# ls -ld /oldboy/ #<==查看调整结果。
drwxr-xr-x. 2 oldboy root 4096 Apr 30 09:55 /oldboy/

[oldboy@oldboy ~]$ cat /oldboy/test.sh
cat: /oldboy/test.sh: Permission denied  #<==无法查看内容，符合预期。
[oldboy@oldboy ~]$ echo "echo oldboy" >>/oldboy/test.sh
-bash: /oldboy/test.sh: Permission denied #<==无法追加修改内容，符合预期。
[oldboy@oldboy ~]$ /oldboy/test.sh
-bash: /oldboy/test.sh: Permission denied #<==无法执行，符合预期。
[oldboy@oldboy ~]$ rm -f /oldboy/test.sh  #<==但是可以删除文件，神奇吧。
[oldboy@oldboy ~]$ ls -l /oldboy/test.sh
ls: cannot access /oldboy/test.sh: No such file or directory #<==文件已找不到。

[root@oldboy ~]# ls -ld /oldboy/
drwxr-xr-x. 2 oldboy root 4096 Apr 30 11:05 /oldboy/
[oldboy@oldboy /]$ whoami
oldboy
[oldboy@oldboy ~]$ ls -ld /oldboy
drwxr-xr-x. 2 oldboy root 4096 Apr 30 11:05 /oldboy
[oldboy@oldboy ~]$ touch /oldboy/{1..3}.txt  
#<==在oldboy目录下创建文件是可以的，这是oldboy目录用户位中w权限的作用。
[oldboy@oldboy ~]$ ls /oldboy/    #<==列表目录下的内容也可以，这是oldboy目录用户位中r权限的作用。
1.txt  2.txt  3.txt
[oldboy@oldboy ~]$ ls -l /oldboy/ 
#<==列表目录下的内容及属性信息也是可以的，这是oldboy目录用户位中r权限的作用。
total 0
-rw-r--r--. 1 oldboy incahome 0 Apr 30 11:17 1.txt
-rw-r--r--. 1 oldboy incahome 0 Apr 30 11:17 2.txt
-rw-r--r--. 1 oldboy incahome 0 Apr 30 11:17 3.txt
[oldboy@oldboy ~]$ cd /oldboy/  #<==切换到oldboy目录下也可以，这是oldboy目录用户位中x权限的作用。
[oldboy@oldboy oldboy]$ pwd
/oldboy
[oldboy@oldboy oldboy]$ rm -f 1.txt  #<==可以删除目录下的文件，这是oldboy目录用户位中w权限的作用。
[oldboy@oldboy oldboy]$ ls
2.txt  3.txt

[oldgirl@oldboy oldboy]$ whoami
oldgirl
[oldgirl@oldboy ~]$ ls -ld /oldboy
drwxr-xr-x. 2 oldboy root 4096 Apr 30 11:17 /oldboy   #<==oldgirl对应权限看最后三位（r-x）。
[oldgirl@oldboy ~]$ ls /oldboy     #<==可以列表文件名，因为具有r权限。
2.txt  3.txt
[oldgirl@oldboy ~]$ ls -l /oldboy  #<==可以列表属性信息。
total 0
-rw-r--r--. 1 oldboy incahome 0 Apr 30 11:17 2.txt
-rw-r--r--. 1 oldboy incahome 0 Apr 30 11:17 3.txt
[oldgirl@oldboy ~]$ touch /oldboy/{a.c}.txt  #<==无法创建文件，因为没有w权限。
touch: cannot touch `/oldboy/{a.c}.txt': Permission denied
[oldgirl@oldboy ~]$ cd /oldboy  #<==可以切换到oldboy目录下，因为有x权限。
[oldgirl@oldboy oldboy]$ pwd
/oldboy
[oldgirl@oldboy oldboy]$ ls
2.txt  3.txt
[oldgirl@oldboy oldboy]$ rm -f 2.txt  #<==无法删除文件，因为没有w权限。
rm: cannot remove `2.txt': Permission denied

[root@oldboy ~]# chmod 736 /oldboy/  #<==读者原样输入即可，12.4.1节会详细讲解，这里无须关心为什么如此输入。
[root@oldboy ~]# chown oldboy.incahome /oldboy  #<==修改用户及组。
[root@oldboy ~]# ls -ld /oldboy
drwx-wxrw-. 2 oldboy incahome 4096 Apr 30 11:17 /oldboy

[oldgirl@oldboy ~]$ ls -ld /oldboy/
drwx-wxrw-. 2 oldboy incahome 4096 Apr 30 11:17 /oldboy/  #<==中三位（-wx）是old- girl对应的权限。
[oldgirl@oldboy ~]$ ls /oldboy           #<==无法列表目录下的内容，因为无r权限。
ls: cannot open directory /oldboy: Permission denied
[oldgirl@oldboy ~]$ touch /oldboy/m.txt  #<==可以创建文件，因为有w权限。
[oldgirl@oldboy ~]$ cd /oldboy           #<==可以切换到目录。因为有x权限。
[oldgirl@oldboy oldboy]$ ls              #<==无法列表目录下的内容，因为无r权限。
ls: cannot open directory .: Permission denied
[oldgirl@oldboy oldboy]$ rm -f m.txt #<==可以删除文件，因为具有w权限。

[test@oldboy ~]$ whoami
test
[test@oldboy ~]$ ls -ld /oldboy
drwx-wxrw-. 2 oldboy incahome 4096 Apr 30 11:38 /oldboy  #<==后三位（rw-）是test用户对应的权限。
[test@oldboy ~]$ ls /oldboy  #<==可以列表目录下的内容，因为具有r权限。
ls: cannot access /oldboy/3.txt: Permission denied  #<==但是缺少x权限配合，所以，报错了。
ls: cannot access /oldboy/2.txt: Permission denied
2.txt  3.txt                   #<==依然可以看到目录下的内容。
[test@oldboy ~]$ ls -l /oldboy #<==可以列表目录下内容的属性信息。
ls: cannot access /oldboy/3.txt: Permission denied
ls: cannot access /oldboy/2.txt: Permission denied
total 0
-????????? ? ? ? ?            ? 2.txt #<==属性信息为多个问号属于不正常现象，因为缺少x权限配合。
-????????? ? ? ? ?            ? 3.txt
[test@oldboy ~]$ touch /oldboy/n.txt  #<==无法创建文件，虽然有w，但是没有x权限配合。
touch: cannot touch `/oldboy/n.txt': Permission denied
[test@oldboy ~]$ rm -f /oldboy/3.txt  #<==无法删除文件，虽然有w，但是没有x权限配合。
rm: cannot remove `/oldboy/3.txt': Permission denied
[test@oldboy ~]$ cd /oldboy           #<==无法进入目录，因为没有x权限配合。
-bash: cd: /oldboy: Permission denied

12.4　设置及更改文件及目录权限命令chmod / 337
    -R   递归处理目录及所有子目录 所有文件

755 代表的字符权限为rwxr-xr-x
644 代表的字符权限为rw-r--r--
134 代表的字符权限为--x-wxr--

[root@oldboy ~]# chmod 567 /oldboy #<==实际数字权限的设置命令。

- 用户或用户组定义  u g o
- 权限定义字母    r w x  - 
- 权限增减字符  + - =
  chmod u-x test.sh    #<==取消用户权限位的x权限。
  chmod g+w test.sh    #<==用户组权限位增加w权限。
  chmod u-x,g+w,o-rwx test.sh #<==用户位取消x权限，用户组增加w权限，其他用户取消rwx权限。
  chmod ugo=rw test.sh #<==所有权限组赋予rw权限。
  chmod a=rw test.sh   #<==所有权限组赋予rw权限。
  chmod +x test.sh     #<==所有权限组增加x权限，这个命令比较常用。

[root@oldboy ~]# chmod -R u-r,g=rx,o=- /oldboy   #<==字符权限设置方法。
[root@oldboy ~]# chmod -R u=w,g=rx,o=- /oldboy
[root@oldboy ~]# chmod -R 250 /oldboy

12.5　企业环境下文件和目录的安全核心知识 / 341

# 1.禁止普通用户删除和创建文件

[root@oldboy ~]# chmod -R 755 /oldboy  #<==防止删除及创建文件安全权限临界点。
[root@oldboy ~]# chown -R root.root /oldboy  #<==必须要设置合适的用户和组，否则设置的权限有可能达不到效果。
[root@oldboy ~]# ls -ld /oldboy
drwxr-xr-x. 2 root root 4096 Apr 30 11:38 /oldboy  #<==rwxr-xr-x，目录字符权限的安全临界点。

# 2.防止用户修改文件内容

[root@oldboy oldboy]# touch test.txt      #<==创建待测试文件。
[root@oldboy oldboy]# chmod 644 test.txt  #<==授权644权限，文件的防修改安全临界点。
[root@oldboy oldboy]# chown root.root test.txt    #<==必须要设置合适的用户和组，否则设置的权限有可能达不到效果。
[root@oldboy oldboy]# ls -l test.txt 
-rw-r--r--. 1 root root 0 Apr 30 13:09 test.txt #<==rw-r--r--，文件字符权限的安全临界点。

# 3.变态的安全措施

例如，如果不希望浏览目录下的内容，就要对目录取消r权限；如果不希望切换到目录下，就要对目录取消x权限。如果不希望查看文件内容，就要对文件取消r权限，如果不希望执行文件，就要对文件取消x权限。不过，这种变态的安全措施，除了不对外备份数据以外，工作中几乎是没有的。

12.6　默认权限掩码及设置命令umask / 342
umask是通过八进制的数值来定义用户创建文件或目录的默认权限的

#1 文件默认权限计算
文件默认最大权限666 
    假定umask值为022 （所有位位偶数）
        666-022=644
    假定umask值为045 （其他用户组位为奇数）
        666-045=621 (奇数位加1) + 001=622（真是文件权限）
2.目录默认权限计算（umask没有奇偶之分）
创建目录默认最大权限777  umask值022
    777-022=755

12.7　Linux系统特殊权限位知识 / 345 了解即可
        suid  sgid sticky（粘滞）
suid
[root@oldboy ~]# touch test.txt  #<==创建测试文件，目录也是一样的。
[root@oldboy ~]# ls -l test.txt 
-rw-r--r--. 1 root root 183 Apr 30 14:33 test.txt  #<==默认权限为644。
[root@oldboy ~]# chmod u+s test.txt  #<==在用户位增加suid权限。
[root@oldboy ~]# ls -l test.txt 
-rwSr--r--. 1 root root 183 Apr 30 14:33 test.txt #<==查看设置结果，因为用户位没有x权限，所以是大写的S（否则小写s），被设置为suid的文件显示的背景是红色，文件名是白色。

sgid
[root@oldboy ~]# touch oldboy.txt  #<==创建测试文件，目录也是一样的。
[root@oldboy ~]# ls -l oldboy.txt 
-rw-r--r--. 1 root root 12 Apr 30 14:38 oldboy.txt  #<==默认权限为644。
[root@oldboy ~]# chmod g+s oldboy.txt #<==在用户组位增加sgid权限。
[root@oldboy ~]# ls -l oldboy.txt 
-rw-r-Sr--. 1 root root 12 Apr 30 14:38 oldboy.txt #<==查看设置结果，因为用户组位没有x权限，所以是大写的S，被设置为sgid的文件显示的背景是黄色，文件名是黑色。

sticky（粘滞） 最典型的带sticky（粘滞）位权限的目录就是/tmp。        
[root@oldboy ~]# ls -ld /tmp
drwxrwxrwt. 3 root root 4096 Apr 30 08:26 /tmp #<==/tmp目录默认就有sticky权限，绿底黑字显示。
[root@oldboy ~]# ls -ld /oldboy
drwxr-xr-x. 2 root root 4096 Apr 30 13:09 /oldboy
[root@oldboy ~]# chmod o+t /oldboy #<==在其他用户位增加sticky权限。
[root@oldboy ~]# ls -ld /oldboy
drwxr-xr-t. 2 root root 4096 Apr 30 13:09 /oldboy #<==查看设置结果，因为其他用户位有x权限，所以是小写的s，文件显示的背景是蓝色，文件名是白色。

suid核心知识小结
1）suid的功能是是针对二进制命令或程序的，不能用在Shell等类似脚本文件上。
2）用户或属主对应的前三位权限的x位上，如果有s（S）则表示具备suid权限。
3）suid的作用就是让普通用户可以在执行某个设置了suid位的命令或程序时，拥有与命令对应属主（一般为root管理员）一样的身份和权限（默认）。
sgid核心知识小结
1）与suid不同的是，sgid既可以针对文件，也可以针对目录进行设置！
2）sgid的权限是针对用户组权限位的。对于文件来说，sgid的功能具体如下。
    1）sgid仅对二进制命令及程序有效。
    2）二进制命令或程序，也需要有可执行权限x的配合。
    3）执行命令的任意用户可以获得该命令在程序执行期间所属组的身份和权限。

粘滞位（sticky bit）
    /tmp目录 所有权限都开放并设置了粘滞位，每个用户只能管理自己的文件，（root用户除外）

12.8　改变文件或目录的用户和用户组命令chown / 352
chown 用户 文件或目录            #<==仅授权用户。
chown :用户组   文件或目录       #<==仅授权用户组，等同于“chgrp组 文件或目录”。
chown 用户:用户组   文件或目录   #<==同时授权用户和用户组。

    -R  递归更改目录及子目录

12.9　chattr：改变文件的扩展属性 / 354
chattr  [options]  [mode]  [files]
chattr  [选项]      [模式]   [<文件或目录>]

参选选项    
    -R    递归更改目录属性
    -V    显示命令的执行过程
mode
    +     增加
    -     移除
    =     更新位指定参数
    A     不能修改这个文件的最后访问时间
    a     只能向文件追加数据，而不能删除  *
    i     设定文件不能被删除 改名 写入或新增内容   *
[root@oldboy ~]# lsattr test   #<==lsattr查看文件的扩展属性。
-------------e- test
[root@oldboy ~]# chattr +a test #<==+a添加追加属性。
[root@oldboy ~]# lsattr test
-----a-------e- test
[root@oldboy ~]# rm -f test     #<==即使是root用户也无法删除。
rm: cannot remove `test': Operation not permitted
[root@oldboy ~]# echo 111 >>test #<==可以追加文本。
[root@oldboy ~]# cat test
111
[root@oldboy ~]# echo 111 >test #<==但是不能清空文件。
-bash: test: Operation not permitted

[root@oldboy ~]# chattr +i file1.txt  #<==使用+i参数为文件加锁。
[root@oldboy ~]# lsattr file1.txt
----i--------e- file1.txt
[root@oldboy ~]# rm file1.txt         #<==root用户无法删除文件。
rm: remove regular file `file1.txt'? y
rm: cannot remove `file1.txt': Operation not permitted
[root@oldboy ~]# echo 111 > file1.txt  #<==不能清空。
-bash: file1.txt: Permission denied
[root@oldboy ~]# echo 111 >> file1.txt #<==也不能追加。
-bash: file1.txt: Permission denied
[root@oldboy ~]# chattr -i file1.txt   #<==使用-i参数解锁。
[root@oldboy ~]# rm file1.txt        
rm: remove regular file `file1.txt'? y #<==解锁后就可以删除了。
[root@oldboy ~]#

[root@oldboy ~]# chattr +a .bash_history     #<==对历史纪录文件加上只能追加的属性。

12.10　lsattr：查看文件的扩展属性 / 356
    -R  递归查看目录的扩展属性
    -a  显示所有文件包括隐藏文件的扩展属性
    -d  显示目录的扩展属性
[root@oldboy ~]# lsattr file1.txt     #<==查看文件默认的扩展属性。
-------------e- file1.txt
[root@oldboy ~]# chattr +i file1.txt
[root@oldboy ~]# lsattr file1.txt
----i--------e- file1.txt             #<==可以看到文件具有i属性。
[root@oldboy data]# ll -d dir2
drwxr-xr-x 2 root root 4096 Nov  4 17:26 dir2
[root@oldboy data]# lsattr -d dir2    #<==使用-d选项查看目录的扩展属性。
-------------e- dir2
[root@oldboy data]# chattr +i dir2    #<==也可以对目录加锁。
[root@oldboy data]# lsattr -d dir2
----i--------e- dir2
```

## 第13章　Linux系统定时任务Cron(d)服务应用实践 / 358
```
13.1　Cron(d)介绍 / 358
Cron是Linux系统中以后台进程模式周期性执行命令或指定程序任务的服务软件
cron定时任务执行最快频率是每分钟

13.2　用户定时任务Cron(d)使用说明 / 362

crontab 
    -l   查看定时任务
    -e   编辑定时任务
    -i   删除定时任务内容，会有提示
    -r   删除定时任务内容
    -u user 指定使用的用户执行任务
-i -r 生产中很少用，ctontab实际给编辑的文件是 /var/spool/cron/当前用户名

01 * * * * cmd
02 4 * * * cmd
分时日月周     分00-59 时00-23 日01-31 月01-12 周0-7(0和7都代表星期日)

特殊符号：
    *  任意时间 每
    -  分隔符  时间范围  17~19点
    ,  逗号  分割时段，  
    /n n代表数字  每隔n单位时间

# systemctl status crond.service  #<==查看Cron定时任务服务启动状态。

# systemctl restart crond.service  #<==定时任务重启命令。

13.3　用户定时任务Cron实例说明 / 365
命令实例1：*/1 * * * * /bin/sh /scripts/data.sh
命令实例2：30 3,12 * * * /bin/sh /scripts/oldboy.sh
命令实例3：30 */6 * * * /bin/sh /scripts/oldboy.sh  # 第二列“*/6”代表每6个小时，相当于就是6、12、18、24的作用  每隔6个小时的半点时刻执行一次
命令实例4：30 8-18/2 * * * /bin/sh /scripts/oldboy.sh # 命令实例4：30 8-18/2 * * * /bin/sh /scripts/oldboy.sh
命令实例6：45 4 1,10,22 * * /application/apache/bin/apachectl graceful  # 每月1、10、22日的凌晨4：45分重启一次Apache
命令实例7：10 1 * * 6,0 /application/apache/bin/apachectl graceful # 每周六、周日的凌晨1：10分重启一次Apache
命令实例8：0,30 18-23 * * * /application/apache/bin/apachectl graceful # 每天18：00至23：00之间每隔30分钟重启一次Apache。
命令实例10：* 23,00-07/1 * * * /application/apache/bin/apachectl graceful # 晚上23点和早上0～7点之间每隔一小时重启一次Apache。 第一个* 表示每分钟
命令实例11：00 11 * 4 1-3 /application/apache/bin/apachectl graceful # 4月的每周一到周三的上午11点整重启一次Apache。
命令实例12：30 09 * * 0 去老男孩教育上课 #每周日上午9：30去老男孩教育上课
命令实例13：30 08 * * *去老男孩教育上课 #每天上午8：30去老男孩教育上课

13.4　生产环境下用户Cron配置专业实践案例 / 366
[root@oldboy ~]# echo oldboy>> /server/log/oldboy.log   #<==命令行执行，将old-boy追加到文件里。
-bash: /server/log/oldboy.log: No such file or directory #<==报错，提示没有文件或目录。
[root@oldboy ~]# mkdir -p /server/log                    #<==创建对应不存在的目录。
[root@oldboy ~]# echo oldboy>> /server/log/oldboy.log    #<==重新在命令行执行。
[root@oldboy ~]# cat /server/log/oldboy.log              #<==查看执行后的结果。
oldboy

crontab-e
#print my name to log by oldboy at 201805       #<==这一行为注释。

* * * * * echo oldboy>> /server/log/oldboy.log  #<==这个命令应该是复制，不是从头书写。
          [root@oldboy ~]# crontab -l|head -2
          #print my name to log by oldboy at 201805      
* * * * * echo oldboy>> /server/log/oldboy.log

[root@oldboy ~]# tail -f /server/log/oldboy.log
oldboy
oldboy
oldboy

❏先确认Crond服务进程是否开启。
❏书写定时任务规则前应尽量先写注释，以方便自己以及同事阅读。
❏这里的/server/log目录必须要事先存在才能出结果，因此，在命令行测试执行成功很重要。
❏定时任务中的所有路径（包含文件和命令等的路径）都尽量使用绝对路径（本题中不加echo也可以）。
❏如果命令中有重定向符号等，那么结尾不要再加>/dev/null 2>&1，否则会出错。
❏注意，定时任务的书写操作步骤具体如下。
    1）先在命令行调试成功。
    2）再将命令复制到定时任务配置里。
    3）然后保存，并使用tail-f测试观察结果。
    4）如果遇到问题，则可根据输出以及定时任务日志/var/log/cron文件内容排错。
[root@oldboy ~]# crontab -l|tail -3
#time sync by oldboy at 20180429
*/5 * * * * /usr/sbin/ntpdate ntp1.aliyun.com &>/dev/null  #<==主时间同步配置。
*/5 * * * * /usr/sbin/ntpdate ntp3.aliyun.com &>/dev/null  #<==辅助时间同步配置。
yum install ntpdate-y

#每天晚上0点，将站点目录/var/www/html下的内容打包备份到/data目录下，并且要求每次生成不同的备份包名。
#1 创建目录
[root@oldboy ~]# ls -ld /var/www/html /data
ls: cannot access /var/www/html: No such file or directory  #<==目录都不存在。
ls: cannot access /data: No such file or directory
[root@oldboy ~]# mkdir -p /var/www/html /data             #<==创建目录。
[root@oldboy ~]# touch /var/www/html/oldboy{1..5}.txt     #<==同时创建几个文件。
[root@oldboy ~]# ls /var/www/html/
oldboy1.txt   oldboy2.txt  oldboy4.txt oldboy3.txt  oldboy5.txt 

# 2备份数据

[root@oldboy ~]# cd /var/www/   #<==打压缩包，最好是到备份数据目录的上一级目录打包。
[root@oldboy www]# tar zcvf /data/bak_$（date +%F）.tar.gz ./html
          #<==带日期打包，目的是不同次备份生成不同的文件。
./html/
./html/oldboy4.txt
./html/oldboy3.txt
./html/oldboy1.txt
./html/oldboy2.txt
./html/oldboy5.txt
[root@oldboy www]# ls -l /data
-rw-r--r--. 1 root root 226 Apr 29 15:03 bak_2018-04-29.tar.gz

# 3测试成功写到shell脚本里

[root@oldboy www]# mkdir /server/scripts -p #<==规范定时任务脚本存放的路径。
[root@oldboy www]# cd /server/scripts/      #<==切换到路径下。
[root@oldboy scripts]# cat bak.sh  #<==查看编辑后的脚本内容，其实就是命令行的命令集合。
cd /var/www/&&\ #<==&&表示本条命令成功之后再执行下面的tar命令，\表示换行。
/bin/tar zcf /data/bak_$（date +%F）.tar.gz ./html #<==注意：这里去掉了-v参数，即不输出信息，打包的文件名中使用了日期变量，这样才能按天生成不同的压缩包文件。
[root@oldboy scripts]# rm -f /data/bak_2018-04-29.tar.gz  #<==删除以前生成的文件。
[root@oldboy scripts]# /bin/sh /server/scripts/bak.sh     #<==使用/bin/sh加全路径执行脚本。
[root@oldboy scripts]# ls -l /data
total 4
-rw-r--r--. 1 root root 226 Apr 29 15:11 bak_2018-04-29.tar.gz #<==测试结果依然正确。

#4 写入定时任务 
crontab -e
[root@oldboy scripts]# crontab -l|tail -2
#backup site dir by oldboy at 201805 #<==清晰的注释。
00 00 * * * /bin/sh /server/scripts/bak.sh >/dev/null 2>&1 #<==复制命令行脚本内容到这里，结尾要加>/dev/null 2> &1，将所有输出定向到空。

13.5　生产环境下的定时Cron书写要领 / 369
1：定时任务加注释
2：尽量都以脚本形式执行
3：执行脚本前加上/bin/sh
4：结尾加上 >/dev/null 2>&1
        >/dev/null 2>&1 等价于 1>/dev/null  2>/dev/null 等价于 &>dev/null
5: 指定用户执行相关定时任务 （需要root执行的任务可以登录到root用户下进行设置）
6：生产任务计划程序中不要随意打印输出信息   tar 的zcvf v参数去掉
7：定时任务执行的脚本要存放到规范路径下 /server/scripts/ 
8：配置定时任务要规范操作过程，减少出错  先测试再设置
9：定时任务脚本中程序命令及路径尽量使用全路径
10: 时间变量%号要使用反斜线转义
11：若脚本中调用了系统环境变量，则要重新定义

[root@oldboy scripts]# crontab -l
#backup site dir by oldboy at 201805 #<==清晰的注释，是专业、资深运维的习惯。
00 00 * * * /bin/sh /server/scripts/bak.sh >/dev/null 2>&1
[root@oldboy scripts]# crontab -l
#backup site dir by oldboy at 201805 
00 00 * * * /bin/sh /server/scripts/bak.sh >/dev/null 2>&1 #<==写成脚本文件执行最佳。
[root@oldboy scripts]# cat bak.sh  #<==脚本文件内容如下。
cd /var/www/&&\
/bin/tar zcf /data/bak_$（date +%F）.tar.gz ./html
[root@oldboy scripts]# crontab -l
#backup site dir by oldboy at 201805 
00 00 * * * /bin/sh /server/scripts/bak.sh >/dev/null 2>&1 #<==/bin/sh命令使用全路径。
[root@oldboy scripts]# cat bak.sh  #<==任务脚本内容如下。
cd /var/www/&&\
/bin/tar zcf /data/bak_$（date +%F）.tar.gz ./html #<==/bin/tar备份命令使用全路径。
[root@oldboy scripts]# echo $PATH  #<==打印输出，根据输出选择路径进行重新定义。
/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
[root@oldboy scripts]# cat bak.sh  #<==脚本内容如下。
export PATH='/sbin:/bin:/usr/sbin:/usr/bin' #<=重新定义环境变量，包含脚本中所有执行命令所在的路径。
cd /var/www/&&\
tar zcf /data/bak_$（date +%F）.tar.gz ./html #<==这里可以取消全路径了。
#tar comment by oldboy at 201805
*/1 * * * * tar zcf /data/bak_$（date +\%F）.tar.gz /var/www/html &>/dev/null

[root@oldboy ~]# cat /scripts/resin/shell/Task.sh
#!/bin/bash
export JAVA_HOME=/application/jdk1.6  #<==如下三行是安装Java相关环境需要的特殊变量。
export PATH=$JAVA_HOME/bin:$PATH
export SH_HOME=/application/resin/webapps/ROOT/
export LIB=$SH_HOME/WEB-INF/lib
...省略部分...
#JAVA Shell by oldboy 201007
00 9,14 * * * nohup /scripts/resin/shell/Task.sh & >/app/log.log 2>&1

13.6　调试Cron定时任务的技巧总结 / 372
#study task by oldboy at 20121213
00 9,14 * * 6,0 /bin/sh /server/scripts/oldboy.sh >/app/log.log 2>&1
[root@oldboy scripts]## cat tar.sh
cd /
tar zcvf /tmp/etc_$（date +%F）.tar.gz ./etc >/tmp/tmp.log 2>&1 #<==加v参数，结尾重定向到文件。
[root@oldboy scripts]# tail -f /var/log/cron

13.7　crontab生产案例故障分析及解决 / 374
No space left on device常见企业故障案例

# 1故障描述

保存定时任务时候提示 No space left on device ,
df -h 查看还有剩余空间，再用df -i 查看 inode已经10%占用
因为 ext3 ext4文件系统中，每个文件至少要占用一个inode。
最后经过检查发现在/var/spool/clientmqueue/下有大量的小文件
cd/var/spool/clientmqueue&&ls|xargs rm-f #进行清理

或者 直接使用cd/var/spool&&rm-fr clientmqueue删除上级目录
mkdir clientmqueue && chmod 770 clientmqueue && chown smmsp.smmsp -R /var/spool/clientmqueue
[root@admin-3-3 ~]# ls -ld /var/spool/clientmqueue/
drwxrwx--- 2 smmsp smmsp 4096 12-12 13:46 /var/spool/clientmqueue/

# 2 故障原因分析

crond定时任务执行的程序包含输出内容时候，输出内容会以邮件的形式发回给执行任务的用户
而sendmail，postifx等mail服务没有启动，这些输出内容就会再邮件队列临时目录产生大量很小的文件，导致消耗了大量的inode和block数量。

# 3 预防方法

再定时任务结尾加上 >/dev/null 2>&1

13.8　有关Cron定时任务的企业面试题 / 376
1）在每周6的凌晨3：15执行一次/home/shell/collect.pl，并将标准输出和标准错误输出到/dev/null设备，请写出crontab中的语句。
2）crontab在11月份内，每天的早上6点到中午12点之间，每隔2小时执行一次/usr/bin/httpd.sh，如何实现？
3）crontab文件由六个域组成，每个域之间用空格进行分割，其排列正确的为下面哪一项（）。
    A、MIN HOUR DAY MONTH YEAR COMMAND
    B、MIN HOUR DAY MONTH DAYOFWEEK COMMAND
    C、COMMAND HOUR DAY MONTH DAYOFWEEK
    D、COMMAND YEAR MONTH DAY HOUR MIN

13.9　定时任务知识逻辑图（学习方法） / 376
```
## 第14章　Linux用户管理知识与应用实践 / 378
```
14.1　用户及用户组配置文件介绍 / 378  了解即可
/etc/passwd、/etc/shadow、/etc/group、/etc/gshadow
/etc/passwd  #<==存储用户信息的文件。
/etc/shadow  #<==存储用户密码信息的文件。
[root@oldboy ~]# ls -l /etc/passwd
-rw-r--r--. 1 root root 1214 Apr 30 20:41 /etc/passwd #<==所有用户都有读的权限。

[root@oldboy ~]# head -5 /etc/passwd  #<==通过head命令查看/etc/passwd的前5行。
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
用户名称:用户密码:用户uid:用户gid:用户说明:用户家目录:shell解释器

[root@oldboy ~]# ls -l /etc/shadow
---------- 1 root root 681 Mar 30 08:59 /etc/shadow #<==理论上所有用户都没有权限。
[root@oldboy ~]# head -5 /etc/shadow #<==通过head命令查看/etc/shadow的前5行。
root:$6$xTyEY0ruiSVt6yVU$DDkAYnnhWdX3Ks0zH4ENQHmN35/2SB7Hrt9MdDYi7W9zoyvFLxgRT73tdRptiKvZedoVdRD9CBzCKWYYnhdxQ/:17598:0:99999:7:::  #<==一长串特殊字符是设置了密码以后加 密的数据信息。
bin:*:17246:0:99999:7:::
daemon:*:17246:0:99999:7:::
adm:*:17246:0:99999:7:::
lp:*:17246:0:99999:7:::
用户名称:用户密码:最近更改密码的时间:禁止修改密码的天数:用户必须修改密码的天数:警告更改密码的期限:不活动时间:失效时间:标志

#用户组相关配置文件
/etc/group     #<==用户组信息文件。
/etc/gshadow   #<==用户组密码信息文件。
[root@oldboy ~]# ls -l /etc/group
-rw-r--r--. 1 root root 652 Apr 30 20:42 /etc/group
[root@oldboy ~]# head -5 /etc/group
root:x:0:
bin:x:1:bin,daemon
daemon:x:2:bin,daemon
sys:x:3:bin,adm
adm:x:4:adm,daemon
用户组名:用户组密码:GID:用户组成员

[root@oldboy ~]# ls -l /etc/gshadow
----------. 1 root root 530 Apr 30 20:42 /etc/gshadow
[root@oldboy ~]# head -5 /etc/gshadow
root:::
bin:::bin,daemon
daemon:::bin,daemon
sys:::bin,adm
adm:::adm,daemon
用户组名:用户组密码:用户组管理员用户:用户组成员

14.2　Linux用户及用户组命令介绍 / 382
    useradd   添加用户 
    usermod   修改用户信息
    userdel   删除用户及用户关联的配置或文件

    passwd       修改密码
    chpasswd    批量更新用户密码
    chage       修改用户密码属性信息
    
    id           查看用户信息
    su           切换用户
    sudo         普通用户用来提权的重要工具
    visudo       编辑suders 配置文件（sudo授权文件）的工具

-----------------用户组常用命令
    groupadd    添加用户组
    groupdel    删除用户组 
    groupmod    修改用户组信息
    gpasswd     为用户组设置密码
    groups      显示用户所属的用户组
    newgrp      更改用户所属的有效用户组

14.3　添加用户命令useradd / 383
    -g 指定新用户所属用户组
    -m   如果家目录不存在，则创建并指定用户家目录
    -M   不建立用户家目录
    -s   指定解释器
    -u    指定用户id  uid

14.4　用户信息修改命令usermod / 390
    -g initial_group 修改用户对应用户组、
    -M 不建立用户家目录
    -s shell 
    -u uid

14.5　 删除用户命令userdel / 392
    -f  强制删除用户，
    -r  删除用户同时删除与用户相关的所有文件

14.6　添加用户组命令groupadd / 394
    -g gid   指定用户组gid
    -f       覆盖

14.7　删除用户组命令groupdel / 394
    groupdel   [group]
    groupdel   [用户组] 
    groupdel不能删除还有用户归属的主用户组。
14.8　修改用户密码命令passwd / 395
    --stdin  从标准输入读取密码字符串

# echo "123456"|passwd --stdin oldgirl  #<==--stdin参数能从标准输入中获取密码。

企业场景用户及密码管理思路
❏用户密码要足够复杂，最好是8位以上字母（含大小写）、数字、特殊字符的组合。
❏较大的企业用户和密码可以统一管理（采用微软活动目录或openldap开源工具）。
❏动态密码：动态口令，需要时登录到动态口令系统中，即时申请获得密码，但如果若干时间内不操作服务器，密码则会失效。

14.9　批量更新用户的密码命令chpasswd / 398
[root@oldboy ~]# id oldboy  #<==确认要修改密码的oldboy用户是否存在。
uid=1002（oldboy）gid=1002（oldboy）groups=1002（oldboy）
[root@oldboy ~]# id oldgirl  #<==确认要修改密码的oldgirl用户是否存在。
uid=501（oldgirl）gid=502（incahome）groups=502（incahome）

[root@oldboy ~]# chpasswd #<==在命令行输入chpasswd，回车。
root:123456             #<==格式为“用户名:密码”，用户必须事先真实存在才行。
oldboy:123456             #<==一行一个。
oldgirl:123456
[root@oldboy ~]#             #<==在新的空行输入Ctrl+D结束输入。

[root@oldboy ~]# cat user.txt     #<==用户及密码字符串文件，注意格式。
root:123456               #<==格式为“用户名:密码”，用户必须事先真实存在才行，且一行一个。
oldboy:123456
oldgirl:123456
[root@oldboy ~]# chpasswd <user.txt     #<==利用输入重定向一次性为所有用户设置预先指定的密码。

14.10　修改用户密码有效期命令chage / 398
    -l  显示账号有效期

创建新用户range，要求该用户在7天之内不能更改密码，60天以后必须修改密码，过期前10天通知用户，过期30天之后禁止用户登录。
[root@oldboy ~]# useradd range #<==添加新用户range。
[root@oldboy ~]# chage -m7 -M60 -W10 -I30 oldboy #<==使用chage按题意要求进行授权。
[root@oldboy ~]# chage -l range                 #<==-l参数用于查看账户的信息。
Last password change               : May 01, 2018   
#<==最后一次密码变化时间为2018-05-01，-d选项可控制该行。
Password expires                    : Jun 30, 2018
#<==密码过期时间为60天，即从2018-05-01到2018-06-30，该行受-M参数影响。
Password inactive                    : Jul 30, 2018   
#<==密码停权时间，即密码过期30天后停权，-I选项可控制该行。
Account expires                          : never #<==账号过期时间，-E选项可控制该行。
Minimum number of days between password change       : 7   #<==-m选项可控制该行。
Maximum number of days between password change       : 60  #<==-M选项可控制该行。
Number of days of warning before password expires : 10  #<==-W选项可控制该行。

14.11　用户查询相关命令 / 400
id finger users w who last lastlog groups 
[root@oldboy ~]# id oldboy #<==查看oldboy的用户及组相关的信息。
uid=1002（oldboy）gid=1002（oldboy）groups=1002（oldboy）#<==用户和组信息以及对应的UID、GID。
[root@oldboy ~]# id -u oldboy  #<==只查看用户UID。
1002
[root@oldboy ~]# id -g oldboy  #<==只查看用户组GID。
1002
[root@oldboy ~]# id -un oldboy  #<==只查看用户名。
oldboy
[root@oldboy ~]# id -gn oldboy  #<==只查看用户组名。
oldboy

[root@oldboy ~]# whoami #<==查看当前登录的用户，比较常用。
root
[root@oldboy ~]# w
#<==显示已经登录的用户，并且展示他都做了什么的信息。查看的信息与/var/run/utmp文件有关，比较常用。
 21:34:56 up 5 days, 21:31,  3 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM              LOGIN@   IDLE   JCPU   PCPU WHAT
root     pts/0    10.0.0.1         09:21    0.00s  0.30s  0.07s w
root     pts/1    10.0.0.1         21:34    8.00s  0.04s  0.00s -bash
root     pts/2    10.0.0.1         21:34   14.00s  0.04s  0.00s -bash
上面第1行的输出依次显示了当前的系统时间、系统从启动到现在已经运行的时间、登录到系统中的用户数和系统平均负载。平均负载是指在1分钟、5分钟、15分钟之内系统的负载状况。
❏USER：表示登录系统的用户。
❏TTY：表示用户使用的TTY名称。
❏FROM：表示用户从哪里登录进来，一般是显示远程登录主机的IP地址或者主机名。
❏LOGIN@：用户登录的日期和时间。
❏IDLE：显示终端空闲时间。
❏JCPU：表示该终端上的所有进程及子进程使用系统的总时间。
❏PCPU：当前活动进程使用的系统时间。
❏WHAT：当前用户执行的进程名称和选项。

[root@oldboy ~]# who
#<==显示哪些用户正在登录，登录的终端及登录时间，来源主机，显示的信息比w少，不常用。
root     pts/0        May  1 09:21 （10.0.0.1）
root     pts/1        May  1 21:34 （10.0.0.1）
root     pts/2        May  1 21:34 （10.0.0.1）
名称 [状态] 线路 时间 [活动] [进程标识] （主机名）

[root@oldboy ~]# last
#<==显示已登录的用户列表及登录时间等，查看的信息与/var/log/wtmp及/var/log/btmp两个文件有关。
root     pts/2        10.0.0.1         Tue May  1 21:34   still logged in   
root     pts/1        10.0.0.1         Tue May  1 21:34   still logged in   

[root@oldboy ~]# lastlog 
#<==报告最近的所有系统用户的登录信息，查看的信息与/var/log/lastlog日志有关。
Username         Port     From             Latest
root             pts/2    10.0.0.1         Tue May  1 21:34:29 +0800 2018
bin                                        **Never logged in**
daemon                                     **Never logged in**
adm                                        **Never logged in**

yum install finger -y
finger命令可以让使用者查询一些其他使用者的资料
    -l 　多行显示。
    -s 　单行显示。

# finger -m hnlinux

# finger -m root@192.168.1.13

# finger root

14.12　Linux用户身份切换命令su / 402
    -,-l,--login 
    -c,--command=COMMAND
❏“su 用户名”虽然能够切换到对应用户，但是登录后的环境变量信息有些还是切换前用户的环境变量信息。
❏“su- 用户名”不但能切换到相应的用户，还能将登录后的环境变量一并切换，这是标准规范的操作方法。

# 如何让系统在每次开机时自动以普通用户身份启动指定服务脚本？

[root@oldboy ~]# tail -1 /etc/rc.local       #<==在开机启动文件/etc/rc.local中写入启动命令。
su - oldboy -c '/bin/sh /service/scripts/deploy.sh'  #<==以普通用户身份执行脚本，但并不是在用户的下面。

14.13　visudo：编辑sudoers文件的工具 / 406
    -c 手动执行语法检查
[root@oldboy ~]# visudo    #<==相当于直接执行vim /etc/sudoers编辑，但使用命令方式更安全，推荐此种方式。    
oldboy  ALL=（ALL）                     ALL  #<==此行是第98行，将oldboy提权为root身份。
oldgirl  ALL=（ALL）                    /usr/sbin/useradd, /usr/sbin/userdel 
     #<==授权oldgirl使其可以以root身份添加和删除用户权限。
     #<==分别对oldboy和oldgirl两个用户做不同的授权，如上。

-------------------------

\cp /etc/sudoers /etc/sudoers.ori
echo "oldboy  ALL=（ALL）NOPASSWD: ALL " >>/etc/sudoers
tail -1 /etc/sudoers     
[root@oldboy ~]# visudo -c  #<==使用-c选项进行语法检查。
/etc/sudoers: parsed OK

14.14　以另一个用户身份执行命
sudo命令可以让普通用户在执行指定的命令或程序时，拥有超级用户
    -l 列出可以执行的命令
    -h 
[oldgirl@oldboy ~]$ sudo -l  #<==注意，这里是oldgirl用户，授权较低。
[sudo] password for oldgirl:   #<==提示输入密码，注意是oldgirl用户的密码，而非root密码。
Matching Defaults entries for oldgirl on this host:
User oldgirl may run the following commands on this host:
    （ALL）/usr/sbin/useradd, （ALL）/usr/sbin/userdel #<==查看到的oldgirl用户被授权的权限。

sudo的配置文件/etc/sudoers

14.15 CentOS7系统找回root密码的方法精讲
1）重新启动或开启CentOS7.6系统，再选择进入系统的Grub菜单界面，，根据提示按“e”小写字母进入编辑界面，
2）然后，按向下方向键（否则可能会看不到想要查找的行），找到以字符串“Linux16”开头的行，将光标移动到该行的结尾，然后输入“ enforcing=0 init=/bin/bash”  ro 修改成rw
Ctrl+x组合键以单用户模式启动Linux

passwd root #修改root密码
```