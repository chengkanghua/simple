# Linux运维工程师 核心基础知识框架 + 学习路线图

Linux核心基础是所有运维方向（传统运维、云原生运维、运维开发、DBA、信创运维）的通用底层能力，对应企业招聘中「Linux基础扎实」的硬性要求。以下按**从底层到应用、从入门到上岗**的逻辑拆分十大模块，标注必会/了解等级，最后给出完整学习路径与实战建议。

---

## 一、核心基础十大模块（按学习优先级排序）

### 模块1：Linux认知与系统启动体系（入门第一关）

**定位**：建立对Linux的整体认知，懂启动原理才能排查系统级故障

#### 核心知识点

- Linux发展历史、开源协议、主流发行版分类（RHEL/CentOS、Debian/Ubuntu、国产欧拉/统信）
- 虚拟机环境搭建（VMware/VirtualBox）、CentOS 7/9、Ubuntu 22.04 最小化安装
- 系统完整启动流程：BIOS/UEFI → GRUB2 引导 → 内核加载 → systemd 初始化 → 多用户登录
- 运行级别与系统目标（runlevel、systemd target）、单用户模式重置密码、救援模式使用
- SSH 远程连接原理、终端工具使用、密钥登录配置、SSH 服务安全加固

#### 学习目标

能独立完成系统安装与远程连接，清晰说出系统从开机到登录的完整链路，能处理启动类故障。

#### 一、Linux 完整发展历史

```md
# 一、Linux 完整发展历史
## 1. 前置背景
1969：Unix 在贝尔实验室诞生，闭源商用，收费昂贵；
1983：Richard Stallman 发起 **GNU 项目**，目标打造一套**完全自由、开源**的类 Unix 操作系统，但缺少内核；
GNU 提供了我们现在每天用的工具：`ls、cat、cp、bash、gcc、sed、awk、coreutils` 等所有命令行程序，只是缺内核。

## 2. Linux 内核诞生
1991 年，芬兰大学生 **Linus Torvalds** 基于 Minix 写了一套轻量内核，命名 Linux，公开源码放到互联网。
关键：
- Linux = **GNU 工具集 + Linux 内核**，完整系统正确称呼：GNU/Linux；
- Linus 选择 **GPLv2** 开源协议，规定修改后的代码必须开源共享；
- 全世界开发者无偿贡献代码，快速迭代。

## 3. 发展关键节点
1. 90年代中后期：各大厂商基于内核打包软件、包管理器、配置工具，诞生各类发行版；
2. 2004：Ubuntu 发布，降低 Linux 使用门槛，普及桌面；
3. 2012：RedHat 发布 RHEL7，全面转向 systemd，成为企业服务器标杆；
4. 2013后：云时代爆发，Linux 垄断服务器、容器、云底层；
5. 国内阶段：
   - 早期基于 CentOS 修改衍生国产系统；
   - 华为开源 openEuler 欧拉内核、深度开发统信UOS，形成自主信创体系。

## 4. 现状
- 服务器、云主机、Docker/K8s、路由器、手机安卓、物联网全是 Linux；
- Windows/macOS 仅桌面端占优。

# 二、主流开源协议（运维必区分 GPL / LGPL / Apache / MIT）
## 1. GPLv2（Linux 内核、GNU coreutils 使用）最强传染性
核心规则：
1. 你可以自由使用、修改、分发源码；
2. **只要软件包含/链接 GPL 代码，整个项目必须开源，同用 GPL**；
3. 修改后对外分发（打包售卖、公开部署）必须公开修改后的完整源码；
4. 典型：Linux 内核、bash、coreutils。

> 重点：企业如果二次改造 Linux 内核，对外提供产品时必须开放内核修改代码。

## 2. LGPL（宽松GPL，类库专用）
用于动态链接库（如glibc C标准库）：
- 动态链接你的商业闭源程序，你的程序不用开源；
- 仅修改库本身需要开源。

## 3. Apache 2.0（Nginx、K8s、Go 生态常用，企业友好）
1. 允许商用、修改、闭源分发；
2. 修改代码需要标注变更说明；
3. 明确授予专利授权，规避专利诉讼；
4. 无传染，不会强制整体开源。

## 4. MIT（最宽松，前端/工具多）
仅保留版权声明，可商用、修改、闭源，几乎无约束，无专利保护。

## 快速对比记忆
- GPL：强传染，改了就要开源；
- Apache：商用友好，自带专利保护；
- MIT：极简宽松，随便用；
- LGPL：库文件专用，动态链接不传染业务程序。

# 三、三大发行版派系分类、特点、适用场景
## 派系1：RHEL 系（RedHat 红帽，企业服务器主流）
### 1. RHEL（Red Hat Enterprise Linux）商业收费
- 定位：政企、金融、大型生产服务器；
- 付费点：官方软件源、7~10年长期技术支持、安全补丁、官方售后；
- 配套工具：yum/dnf、systemd、firewalld、rpm 包；
- 限制：不开源官方源，无订阅无法下载更新包。

### 2. CentOS（已停服，RHEL 免费复刻版）
- 完全编译 RHEL 源码，去掉商标，免费使用，功能和RHEL几乎一致；
- 历史版本：CentOS7（2024年停止维护）、CentOS8（2021停更）；
- 替代方案：Rocky Linux、AlmaLinux（社区承接免费兼容RHEL）；
- 运维现状：大量老业务服务器仍是 CentOS7。

### 3. 生态统一特征
- 软件包：`.rpm`；
- 包管理器：yum（7）/ dnf（8/9）；
- 防火墙：firewalld 上层封装 iptables；
- 文件系统默认：xfs；
- 命令、服务配置路径统一，企业运维首选。

## 派系2：Debian / Ubuntu 系（开发、桌面、轻量云主机）
### 1. Debian
纯社区驱动，完全免费开源，稳定版追求极致稳定，软件版本偏旧；
- 包格式：`.deb`；
- 包管理：apt / apt-get；
- 适用：服务器、嵌入式、容器基础镜像底层。

### 2. Ubuntu（基于Debian二次开发）
- Canonical 公司维护，分桌面版、Server服务器版；
- 优势：软件源丰富、文档多、新手友好、云厂商默认镜像；
- 特点：每2年一个LTS长期支持版（20.04、22.04、24.04），5年免费维护；
- 适合：开发机、个人桌面、阿里云/腾讯云轻量应用、CI/CD构建节点；
- 防火墙默认：ufw。

## 派系3：国产信创发行版（欧拉 openEuler、统信UOS）
### 1. openEuler 欧拉（服务器端，华为开源）
底层自研 Linux 内核，面向服务器、云计算、数据库、嵌入式；
- 开源免费，国内政企、运营商、金融替换CentOS主力；
- 兼容RPM包管理，适配ARM、x86、鲲鹏芯片；
- 配套：iSula容器、云原生组件，面向企业生产环境。

### 2. 统信UOS（深度Deepin，桌面端为主）
基于Debian改造，国产桌面操作系统；
- 面向政府办公终端、国产化PC；
- deb包管理，图形化完善，适配国产CPU（飞腾、龙芯）；
- 服务器版本少量使用，多用于办公桌面场景。

# 四、发行版选型总结（面试常考）
1. 传统企业/金融生产业务 → RHEL / Rocky Linux；
2. 开发、云服务器、测试环境 → Ubuntu Server；
3. 嵌入式、极简容器底层 → Debian；
4. 国内信创服务器替换CentOS → openEuler欧拉；
5. 国产办公电脑、政务桌面 → 统信UOS。
```

#### 虚拟机环境搭建

```markdown
# 虚拟机环境搭建 + CentOS7/CentOS9/Ubuntu22.04 最小化安装完整教程
## 一、虚拟机软件对比（VMware / VirtualBox）
### 1. VMware Workstation Pro（推荐运维学习）
优点：
1. 快照、克隆、共享文件夹、虚拟网卡模式功能完善；
2. 虚拟机性能更好，磁盘IO/网络延迟低；
3. 兼容CentOS、Ubuntu、欧拉全平台，支持自定义CPU核心、内存；
4. 运维学习首选，企业培训、面试练习通用。
缺点：商用收费，需破解/试用。

### 2. VirtualBox（免费开源）
优点：完全免费、轻量、占用宿主机资源少；
缺点：大内存多虚拟机卡顿，快照速度慢，共享文件夹坑多。

### 虚拟机三种网卡模式（必掌握）
1. **桥接模式**：虚拟机和宿主机同网段，局域网其他机器可访问虚拟机；适合多机集群实验。
2. **NAT模式（默认）**：虚拟机可上外网，外部无法主动访问虚拟机；单机学习推荐。
3. **仅主机模式**：仅宿主机与虚拟机互通，无外网；隔离测试环境。

## 二、前置准备
1. 镜像下载（官方 minimal 最小化镜像，无桌面）
- CentOS7 Minimal：CentOS-7-x86_64-Minimal.iso
- CentOS9 Stream Minimal：CentOS-Stream-9-x86_64-minimal.iso
- Ubuntu 22.04 Server LTS：ubuntu-22.04-live-server-amd64.iso
2. 硬件分配标准（单台虚拟机最低配置）
|系统|CPU|内存|磁盘|
|----|---|----|----|
|CentOS7|2核|2G|20G|
|CentOS9|2核|2G|20G|
|Ubuntu22.04 Server|2核|2G|20G|
3. BIOS开启虚拟化：Intel-VT / AMD-V，否则虚拟机极卡。

# 三、VMware新建虚拟机通用步骤
1. 文件 → 新建虚拟机 → 典型(推荐)
2. 安装来源：选择「安装程序光盘镜像文件(ISO)」，导入下载好的minimal镜像
3. 虚拟机名称+存储位置（不要中文路径）
4. 指定磁盘容量20G，勾选「将虚拟磁盘存储为单个文件」
5. 自定义硬件：CPU2核、内存2048MB、网卡NAT/桥接、删除打印机、声卡等无用设备
6. 完成创建，开启虚拟机进入系统安装界面

# 四、CentOS 7 Minimal 最小化安装步骤
## 1. 开机引导界面
选择 `Install CentOS 7` 回车安装。
## 2. 语言选择
中文/英文均可，运维推荐英文，避免中文乱码。
## 3. 安装信息摘要（5项必配置）
1. **DATE & TIME**：时区选择 `Shanghai` 上海，开启网络同步时间
2. **NETWORK & HOST NAME**
   - 网卡开关打开（默认关闭会无网络）；
   - 设置主机名：centos7-node01；
3. **INSTALLATION SOURCE**：默认本地镜像无需修改
4. **SOFTWARE SELECTION（最小化核心）**
   左侧选 `Minimal Install`（最小化，无图形桌面），只保留基础工具，不勾选额外组件；
5. **INSTALLATION DESTINATION**
   - 勾选本地标准磁盘20G；
   - 勾选「我要配置分区」；
   - 标准运维分区方案：
     - /boot：1G
     - swap：2G
     - / 剩余全部空间（根分区）
   - 接受更改。

## 4. 开始安装
1. 设置root密码（生产强密码，学习环境简单密码）；
2. 可选创建普通用户；
3. 等待安装完成，点击`Reboot`重启。

## 5. 重启后基础配置
1. 登录root账号；
2. 网卡开机自启：
vi /etc/sysconfig/network-scripts/ifcfg-ens33
ONBOOT=yes


3. 重启网卡 `systemctl restart network`；
4. 查看IP `ip a`，可SSH远程连接。

# 五、CentOS Stream 9 Minimal 最小化安装

## 差异点（对比CentOS7）

1. 网络配置工具改为NetworkManager，网卡文件路径变化；
2. 无传统network服务，命令 `nmcli` 管理网络；
3. 默认文件系统XFS，包管理器dnf替代yum；
4. 安装界面UI全新改版。

## 安装关键步骤

1. 引导选择Install CentOS Stream 9；

2. 时区上海，网络界面打开网卡开关；

3. 软件选择：**Minimal** 最小安装；

4. 磁盘手动分区：/boot 1G、swap 2G、/ 剩余空间；

5. 设置root密码，安装重启；

6. 开机启用网卡：
   nmcli connection modify ens33 connection.autoconnect yes
   nmcli connection up ens33


# 六、Ubuntu 22.04 Server LTS 最小化安装（无桌面）

## 1. 引导启动

选择 `Ubuntu Server` 进入安装向导。

## 2. 基础配置

1. 语言：English（避免中文终端乱码）；
2. 网络：DHCP自动获取IP，确认网卡联网；
3. 磁盘分区（标准方案）
   - 使用整个磁盘，手动分区：
     - boot 1G
     - swap 2G
     - / 剩余全部
4. 设置主机名、用户名、密码（Ubuntu禁止root远程登录，必须普通用户）
5. **最小化关键：功能组件不勾选任何服务**
   OpenSSH server 可选勾选（方便SSH连接），其余软件包全部取消，实现纯最小安装。
6. 等待系统安装，下载更新包；
7. 安装完成选择`Reboot`，弹出移除ISO镜像回车确认。

## 开机后基础操作

1. 使用创建的普通用户登录；
2. 切换root：`sudo -i`；
3. 查看IP：`ip a`；
4. 软件源：apt包管理器。

# 七、三台虚拟机集群实验环境标准配置（运维练习必备）

1. 三台机器：centos7、centos9、ubuntu22.04
2. 网卡统一桥接模式，同网段互通；
3. 全部开启OpenSSH，宿主机Xshell/Mobaxterm远程连接；
4. 关闭防火墙、SELinux（学习环境）；
5. 配置hosts互相解析主机名，免密SSH互通；
6. 快照备份安装完成干净系统，后续实验出错一键恢复。

# 八、常见安装排错

1. 虚拟机无法联网：网卡ONBOOT未开启、NAT服务未启动、虚拟网卡驱动异常；
2. 安装找不到磁盘：虚拟机磁盘未分配、BIOS磁盘模式不兼容；
3. 安装卡住镜像加载：镜像校验失败，重新下载官方minimal镜像；
4. 内存不足安装缓慢：至少分配2G内存，1G内存极易卡死；
5. 宿主机无法SSH连接虚拟机：防火墙拦截、网卡NAT未放行22端口、桥接网段不通。
```

#### 系统完整启动流程

```md
# Linux 完整启动全流程详解（BIOS/UEFI → GRUB2 → 内核 → systemd → 登录）
分5大阶段，附底层原理、面试考点、CentOS7/9、Ubuntu统一流程

## 阶段1：BIOS / UEFI 固件开机自检（硬件层）
### 1. BIOS（传统Legacy启动）
1. 主机上电，主板ROM固件BIOS启动；
2. POST上电自检：检测CPU、内存、硬盘、显卡等硬件，硬件故障直接报错停机；
3. 根据启动顺序，扫描硬盘寻找**MBR主引导记录**（硬盘前512字节）；
4. 读取硬盘0扇区前446字节的引导程序，移交控制权给GRUB。

### 2. UEFI（新式GPT分区，CentOS8+/9、Ubuntu20.04+默认）
1. 主板固件UEFI，图形化固件界面，支持GPT大硬盘（>2T）；
2. POST自检，内置文件系统驱动，可直接识别FAT32 ESP分区；
3. 找到磁盘上 **ESP EFI系统分区**，读取grubx64.efi引导文件；
4. 相比BIOS：支持安全启动、硬盘大于2T、启动更快。

### 面试考点
- BIOS对应MBR分区表；UEFI对应GPT分区表；
- 虚拟机安装2T以上磁盘必须开启UEFI。

## 阶段2：GRUB2 引导程序（选择内核、加载内核镜像）
BIOS/UEFI把权限交给GRUB2，`/boot/grub2/` 存放配置
1. GRUB加载配置文件 `grub.cfg`，展示启动菜单（多内核、救援模式、单用户）；
2. 用户选择系统内核，GRUB执行2件核心事：
   1）加载**vmlinuz**：Linux内核压缩镜像；
   2）加载**initramfs** 临时内存文件系统（驱动、磁盘模块）；
3. GRUB 将内核与initramfs加载到内存，把系统控制权交给Linux内核。

### 关键文件
- /boot/vmlinuz-xxx 内核主程序
- /boot/initramfs-xxx.img 临时驱动盘
- /etc/default/grub grub配置模板，修改后执行 `grub2-mkconfig -o /boot/grub2/grub.cfg` 生效

### 应急场景：单用户模式重置root密码、救援模式修复系统，全部在GRUB菜单操作

## 阶段3：Linux内核加载 & 初始化（内核空间）
1. 内核解压到内存，初始化CPU、内存调度、时钟；
2. 挂载initramfs虚拟文件系统，加载磁盘控制器、RAID、LVM驱动；
3. 识别真实硬盘分区，卸载临时initramfs；
4. 以只读模式挂载**真实根分区 /**；
5. 内核启动第一个用户空间进程：**PID=1 的 systemd**，内核工作结束，切换到用户态。

> 重点：systemd 是内核拉起的第一个程序，PID永远为1。老系统为init。

## 阶段4：systemd 系统初始化（CentOS7+/Ubuntu16.04+ 统一）
systemd 替代传统SysVinit，并行启动服务，启动速度更快，整套流程依赖**Unit单元、Target目标**

### 步骤1：挂载基础文件系统
根据 `/etc/fstab` 挂载 /、/boot、/var、/home、swap 等分区；
重新以**可读写**模式挂载根分区。

### 步骤2：启动基础系统单元（sysinit.target）
- 加载内核参数、设置主机名、加载sysctl内核参数
- 启动udev设备管理器，识别所有硬件（网卡、磁盘、USB）
- 加载时钟、LVM、加密磁盘、文件系统修复fsck

### 步骤3：启动系统基础服务（basic.target）
系统底层依赖服务：日志rsyslog、网络管理NetworkManager、安全策略、定时任务基础组件

### 步骤4：切换运行目标 multi-user.target / graphical.target
两个核心目标：
1. `multi-user.target`：多用户字符界面（最小化服务器默认，无图形）
2. `graphical.target`：图形桌面模式（带GUI系统）

所有开机自启服务（nginx、sshd、mysql）均依赖multi-user.target，并行启动。

### 补充：传统runlevel与systemd target对应
- runlevel 0 → poweroff.target 关机
- runlevel 1 → rescue.target 单用户救援
- runlevel 3 → multi-user.target 字符服务器
- runlevel 5 → graphical.target 图形桌面
- runlevel 6 → reboot.target 重启

查看默认启动目标：
```bash
systemctl get-default
# 修改默认字符界面
systemctl set-default multi-user.target

## 阶段5：多用户登录阶段（用户态交互）

1. systemd启动`getty`终端程序，监听本地控制台tty、串口；
2. 本地显示器出现登录输入界面；
3. 用户输入用户名密码，系统调用PAM认证模块校验 `/etc/passwd /etc/shadow`；
4. 认证成功：加载用户环境变量，启动shell（bash），进入命令行交互；
5. 远程场景：sshd服务监听22端口，接收SSH客户端连接，同样走PAM登录认证。

## 完整串联流程图（背诵版）

上电 → BIOS/UEFI自检 → 读取磁盘引导GRUB2 → GRUB加载内核+initramfs → 内核初始化硬件挂载根分区 → 启动PID=1 systemd → 依次挂载文件系统、初始化硬件、启动系统服务、切换multi-user.target → 启动getty登录终端 → 用户输入账号密码登录系统

## 高频面试问答

1. Q：initramfs作用？
   A：内核自带驱动有限，initramfs包含磁盘、LVM、RAID驱动，保证内核能识别并挂载真实根分区。

2. Q：systemd相比旧init优势？
   A：并行启动服务、服务自动依赖管理、统一管控进程/挂载/网络、支持服务自动重启、日志统一管理。

3. Q：服务器最小化安装默认启动哪个target？
   A：multi-user.target（字符多用户模式）。

4. Q：开机无法进入系统，卡在GRUB阶段排查哪里？
   A：镜像损坏、磁盘引导损坏、/boot分区丢失、grub.cfg配置错误。

5. Q：内核加载完成后卡死，大概率是什么问题？
   A：根分区损坏、fstab挂载错误、磁盘驱动缺失、LVM异常。

6. mbr分区为什么最大2tb   ,及主分区为什么只能4个?
   **最多 4 主分区**：MBR 分区表仅 64 字节，每条分区记录 16 字节，64/16=4 条记录；多分区必须用扩展分区 + 逻辑分区。
    512字节(mbr主引导记录) - 446字节(grub存放处) - 2字节(魔术校验标志) = 64字节分区表 / 16字节 = 4个主分区
   **最大 2TB**：MBR 采用 32 位 LBA 扇区寻址，单扇区 512B，全部寻址空间合计 2048GB（2TB），超过则地址溢出无法识别。
    LBA（线性块寻址）：用数字编号硬盘每一个扇区，每个扇区固定 512 Byte。
    2的32次方=总可寻址扇区数量 * 512字节 = 总容量  换算=2TB    
```

#### 运行级别与系统目标（runlevel、systemd target）、单用户模式重置密码、救援模式使用

```md
# 一、传统 Runlevel 运行级别（SysVinit，CentOS6 及更早）
## 1. 7个运行级别定义
| Runlevel | 名称 | 作用 |
|---------|------|------|
| 0 | 关机 | 执行后服务器断电，不可设为默认 |
| 1 | 单用户模式（Single） | 仅root，无网络、无服务，用于重置密码、修复系统 |
| 2 | 多用户无NFS | 字符界面，无文件共享，几乎不用 |
| 3 | 完整多用户字符模式 | 服务器最小化安装默认，命令行 |
| 4 | 保留未使用 | 厂商自定义预留 |
| 5 | 图形桌面模式 | 带X-window图形界面 |
| 6 | 重启 | 不可设为默认 |

## 2. 常用命令
```bash
# 查看当前运行级别
runlevel
who -r

# 切换运行级别
init 3
init 5
init 0
init 6

# 开机默认级别配置文件
vi /etc/inittab
id:3:initdefault:

# 二、systemd Target 目标单元（CentOS7+/Ubuntu16.04+ 主流）

systemd 抛弃数字runlevel，改用**target目标**，target之间存在依赖关系，并行启动服务。

## 1. Target 与 runlevel 一一对应

| systemd Target    | 等效runlevel | 说明              |
| ----------------- | ---------- | --------------- |
| poweroff.target   | 0          | 关机              |
| rescue.target     | 1          | 单用户救援模式（单用户）    |
| multi-user.target | 3          | 字符多用户，服务器默认     |
| graphical.target  | 5          | 图形桌面            |
| reboot.target     | 6          | 重启              |
| emergency.target  | -          | 紧急模式，比rescue更精简 |

## 2. 核心操作命令

# 查看当前默认启动目标
systemctl get-default

# 设置开机默认字符界面
systemctl set-default multi-user.target

# 临时切换（立即生效）
systemctl isolate multi-user.target
systemctl isolate graphical.target

# 查看目标依赖的服务
systemctl list-dependencies multi-user.target

## 3. systemd 启动流程简化

`sysinit.target` → `basic.target` → `multi-user.target`
所有自定义服务（sshd、nginx、mysql）挂载在 `multi-user.target` 下开机自启。

# 三、单用户模式重置root密码（CentOS7/9 通用，GRUB2操作）

适用场景：忘记root密码，本地服务器物理操作

## 步骤1：开机在GRUB菜单界面

1. 出现内核选择页面，选中默认内核，按 `e` 进入编辑模式

   ## 步骤2：修改内核启动参数

   找到以 `linux16`（CentOS7）/ `linux`（CentOS9）开头的一行，做两处修改：

2. 将参数 `ro`（只读）改为 `rw`（读写挂载根分区）

3. 在该行末尾添加：`init=/bin/bash`

   ## 步骤3：进入单用户shell

   按 `Ctrl + X` 启动，直接进入root bash，无需密码

   ## 步骤4：重置密码
   # 修改root密码
   passwd root
   # SELinux环境必须更新上下文，否则重启无法登录
   touch /.autorelabel


   ## 步骤5：重启生效

   执行 `exec /sbin/init` 正常启动系统；
   系统会自动执行SELinux重新标记，等待几分钟自动登录。

### Ubuntu 22.04 单用户改密码区别

Ubuntu 默认无root登录，参数改为 `init=/bin/bash` 后修改普通用户密码，或启用root。

# 四、救援模式 rescue.target / emergency.target 适用场景

## 1. 什么时候用救援模式

- /etc/fstab 挂载错误导致开机卡住
- 磁盘损坏、LVM异常、根分区无法挂载
- 关键系统文件丢失、内核模块损坏
  单用户模式进不去时，使用救援模式。

## 两种救援目标区别

1. **rescue.target（救援模式）**
    会挂载根分区、启动少量基础系统服务，有基础工具，适合修复大部分配置故障。
2. **emergency.target（紧急模式）**
    只挂载只读根分区，几乎无任何服务，工具极少；fstab磁盘挂载失败自动进入。

## 两种进入方式

### 方式1：GRUB菜单临时进入

内核启动行末尾添加 `systemd.unit=rescue.target`，Ctrl+X启动，输入root密码进入。

### 方式2：系统正常时直接切换
systemctl isolate rescue.target


## 救援模式典型修复场景

1. fstab写错导致开机失败：rescue下编辑 `/etc/fstab` 注释错误挂载项
2. 磁盘损坏：执行 `xfs_repair /dev/sda1` / `fsck.ext4` 修复文件系统
3. GRUB引导损坏：重新安装grub2引导程序

# 五、面试高频总结背诵

1. CentOS7前用数字runlevel；7+统一使用systemd target，target是runlevel的升级版。
2. multi-user.target = runlevel3（服务器默认字符界面）；graphical.target=runlevel5图形。
3. 单用户模式重置密码核心修改点：ro改rw、添加init=/bin/bash，SELinux机器必须touch /.autorelabel。
4. 单用户适合单纯忘密码；rescue救援模式用于磁盘、fstab、系统文件损坏等严重启动故障。
5. emergency紧急模式：根分区只读，挂载异常自动进入，修复磁盘分区故障。
```

#### SSH 全套知识点（运维面试 + 生产落地完整）

```md
# SSH 全套知识点（运维面试+生产落地完整）
## 一、SSH 远程连接原理
### 1. 基础定义
SSH（Secure Shell）：**加密安全远程登录协议**，替代明文 Telnet / rsh；默认 TCP 22 端口，传输全程加密。
- Telnet：账号密码明文传输，中间人抓包直接窃取，生产禁用。
- SSH：身份认证 + 数据传输双层加密。

### 2. 两层加密机制
1. **传输层加密（握手阶段）**
   客户端与服务器先用**非对称加密（RSA/ECDSA）**交换会话密钥；
   后续所有数据用**对称加密（AES）**传输（速度快）。
2. **身份认证层**
   两种认证方式：密码认证、密钥对认证。

### 3. 完整连接流程
1. 客户端发起 TCP 连接服务端 22 端口；
2. 服务端发送自身主机公钥（主机密钥，用于校验服务器身份，防中间人劫持）；
3. 双方协商加密算法，生成临时会话密钥；
4. 客户端发起身份校验（密码/密钥）；
5. 认证通过，建立加密 Shell 会话，双向传输命令与返回结果。

### 4. 关键概念：主机指纹
首次连接服务器会提示：

Are you sure you want to continue connecting (yes/no/[fingerprint])?


服务器公钥指纹保存在客户端 `~/.ssh/known_hosts`；
下次连接自动对比指纹，若服务器重装/IP复用导致指纹变化，SSH 直接拒绝连接，防止中间人劫持。

## 二、终端工具使用（Windows/Mac）
### Windows 主流工具
1. Xshell：功能最全，支持密钥、批量脚本、日志、标签页（企业运维首选）
2. MobaXterm：自带 Linux 小工具、sftp 内置
3. FinalShell：国产，自带服务器监控面板
4. Windows 自带：PowerShell / cmd 内置 `ssh` 命令（Win10 1809+）

### Mac / Linux 自带终端
直接使用系统 Terminal，原生支持 `ssh/scp/sftp`。

### 常用基础命令
# 密码登录
ssh root@192.168.1.100

# 指定端口登录（服务器修改过22端口）
ssh root@192.168.1.100 -p 2222

# 远程执行单条命令不进入交互
ssh root@192.168.1.100 "df -h"

# 文件上传（本地→服务器）
scp local.file root@ip:/tmp/

# 文件下载（服务器→本地）
scp root@ip:/tmp/test.txt ./

# 目录传输加 -r
scp -r /data root@192.168.1.100:/data/


## 三、SSH 密钥登录完整配置（免密登录核心）

### 原理

非对称密钥对：

- **私钥 id_rsa**：客户端本地保管，绝不外泄
- **公钥 id_rsa.pub**：上传到服务端 `~/.ssh/authorized_keys`
  流程：客户端私钥签名，服务端用对应公钥校验，匹配成功免密登录。

### 操作步骤（客户端执行）

#### 1. 生成密钥对
# 一路回车，不设置密钥密码（单纯免密）
ssh-keygen -t rsa
# -t rsa 指定加密算法，默认2048位；可加 -b 4096 提升强度

生成文件路径：`~/.ssh/`

- id_rsa 私钥（权限必须600）
- id_rsa.pub 公钥

#### 2. 推送公钥到目标服务器（一键命令）
ssh-copy-id root@192.168.1.100
# 底层自动创建 .ssh 目录，把公钥写入 authorized_keys


#### 3. 免密登录测试
ssh root@192.168.1.100
# 无需输入密码直接进入


### 手动推送方案（无 ssh-copy-id 工具时）
# 本地输出公钥，ssh管道追加到服务端认证文件
cat ~/.ssh/id_rsa.pub | ssh root@ip "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"


### 权限硬性要求（权限过大SSH拒绝密钥登录）

服务端目录/文件权限：
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
# 家目录权限不能777，否则校验失败
chmod 755 ~


## 四、SSH 服务安全加固（生产必做，面试高频）

配置文件：`/etc/ssh/sshd_config`
修改后重载服务生效：
# CentOS7/9
systemctl restart sshd
# Ubuntu
systemctl restart ssh


vim /etc/ssh/sshd_config

### 1. 关闭密码登录（只允许密钥登录，最重要）

PasswordAuthentication no

### 2. 修改默认22端口，降低扫描攻击概率

Port 22345

> 修改端口后防火墙/iptables/firewalld 需要放行新端口。

### 3. 禁止root账号远程登录

PermitRootLogin no

# 创建普通用户，使用sudo提权管理服务器。

### 4. 限制允许登录用户（白名单）

AllowUsers admin user01

# 仅列表内用户可SSH连接

### 5. 禁用空密码账号登录

PermitEmptyPasswords no

### 6. 缩短超时断开，防挂机被盗

ClientAliveInterval 300
ClientAliveCountMax 3

# 5分钟无操作自动断开

### 7. 禁用老旧弱加密算法

# 关闭弱DH、弱MAC算法

KexAlgorithms diffie-hellman-group-exchange-sha256,ecdh-sha2-nistp256
MACs hmac-sha2-256,hmac-sha2-512

### 8. 限制最大并发连接，防暴力爆破

MaxAuthTries 3
MaxSessions 5

### 9. 使用强密钥算法（4096位RSA/ECDSA）

HostKey /etc/ssh/ssh_host_rsa_key
# 生成4096位主机密钥替换默认弱密钥
ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key
# ssh-keygen -t ed25519  # ed25519（现代更强、体积更小，推荐）


### 10. 配套安全策略（sshd_config之外）

1. 防火墙只放行指定IP访问SSH端口（iptables/firewalld白名单）
2. 安装 fail2ban 自动拦截暴力破解IP
3. 定期审计 `/var/log/secure`（CentOS）/ `/var/log/auth.log`（Ubuntu）登录日志
4. 私钥本地设置密码保护：`ssh-keygen -p`，防止本地私钥泄露

## 五、面试高频问答总结

1. Q：SSH 为什么比 Telnet 安全？
   A：SSH 全程对称加密传输数据，身份使用非对称密钥校验；Telnet 明文传输账号密码，极易抓包泄露。

2. Q：免密登录核心文件与权限？
   A：客户端私钥 `id_rsa(600)`；服务端 `authorized_keys(600)`、`.ssh`目录700。

3. Q：生产环境SSH最优安全策略？
   A：修改默认端口、禁止root远程、关闭密码登录、仅密钥登录、配置用户白名单、防火墙限制源IP、部署fail2ban。

4. Q：首次SSH提示指纹确认是什么作用？
   A：校验服务器主机公钥，防止中间人劫持，避免连接钓鱼服务器窃取信息。

5. Q：免密登录失败排查思路？
   1）网络/端口通不通；2）sshd_config是否开启PubkeyAuthentication yes；3）服务端.ssh目录与authorized_keys权限；4）公钥是否完整写入；5）SELinux拦截（CentOS常见）。

## SSH 全路径文件总结（分两类：服务端 sshd、客户端用户密钥）

### 服务端 sshd （所有用户共用，sshd 服务配置、主机密钥）

/etc/ssh/sshd_config  # ssh 服务主配置文件，端口、密钥登录、root 限制、密码认证等全部在这里配置；
修改后重载：`systemctl restart sshd / ssh`
/etc/ssh/ssh_host_* 系列
- ssh_host_rsa_key /ssh_host_rsa_key.pub  RSA 主机密钥对
- ssh_host_ecdsa_key / ssh_host_ecdsa_key.pub ECDSA
- ssh_host_ed25519_key /ssh_host_ed25519_key.pub ed25519（推荐强算法）
  作用：客户端连接时用来校验服务器身份、协商加密会话。
  /etc/ssh/moduli    # DH 密钥交换算法参数，可删除弱算法提升安全。
  /etc/pam.d/sshd    # SSH 登录 PAM 认证配置（密码校验、二次认证、登录拦截）

### 客户端用户私有 SSH 文件（每个用户独立，`~/.ssh/` = 当前用户家目录下.ssh）
权限硬性要求：`~/.ssh` 700，内部文件 600，权限过大会导致 SSH 密钥登录失效

### 1. 客户端私钥 / 公钥（本机作为客户端去连其他服务器）
~/.ssh/id_rsa：RSA 私钥，核心机密，绝不外传，权限 600
~/.ssh/id_rsa.pub：对应公钥，可分发到目标机器
~/.ssh/id_ed25519  / ~/.ssh/id_ed25519.pub ：ed25519 新式密钥对

### 2. 连接记录与配置
~/.ssh/known_hosts   # 保存所有连接过的服务器**主机公钥指纹**；作用：防止中间人劫持；服务器重装后指纹不匹配会拒绝连接。

`~/.ssh/config`（可选，自定义连接快捷配置）
免输 IP、端口、用户名示例：
Host web01
  HostName 192.168.1.10
  User root
  Port 22345
  IdentityFile ~/.ssh/id_ed25519

之后直接 `ssh web01` 一键登录。

### 3. 服务端认证文件（目标服务器上的用户目录，存放客户端公钥）
目标机器用户目录：`~/.ssh/authorized_keys`
存放所有允许免密登录本机的客户端公钥，一行一个公钥。

## SSH 日志文件（排查登录失败、暴力破解）
1. CentOS/RHEL 系：`/var/log/secure`
2. Debian/Ubuntu 系：`/var/log/auth.log`
   记录：登录成功 / 失败、密钥校验失败、root 登录、爆破 IP 等。
```

---

### 模块2：文件系统与目录结构（底层核心，一切皆文件）

**定位**：Linux 最核心的哲学，所有操作都基于文件体系，必须吃透原理

#### 核心知识点

- FHS 目录层级标准：`/etc /var /usr /proc /sys /dev /tmp /home /root` 等核心目录的作用
- 文件类型识别：普通文件、目录、软链接/硬链接、设备文件、管道、套接字
- **inode 与 block 底层原理**：文件存储结构、硬链接本质、磁盘满的两种场景（inode 耗尽、block 耗尽）
- 文件基础操作：`ls/cd/pwd/mkdir/touch/cp/mv/rm/ln/file/stat`
- 通配符、基础正则符号
- `/proc` 与 `/sys` 伪文件系统：查看内核参数、系统状态的入口

#### 学习目标

看到目录名就知道用途，能清晰区分软硬链接，理解 inode 原理，熟练完成文件日常操作。

#### FHS 目录层级标准

```md
# FHS 标准核心目录详解（运维必背，面试高频）
FHS（Filesystem Hierarchy Standard）Linux 文件系统层级标准，规定所有发行版统一目录用途，**一切皆文件**。

## 1. /etc 系统全局配置目录
存放**系统、服务所有静态配置文件**，文本格式，修改立即/重载生效，不含二进制程序。
- /etc/passwd、/etc/shadow 用户账号密码
- /etc/ssh/sshd_config SSH服务配置
- /etc/yum.repos.d yum软件源
- /etc/fstab 开机磁盘挂载表
- /etc/sysconfig/network-scripts/ifcfg-ens33 网卡配置
- /etc/crontab 系统级定时任务
特点：系统重装会丢失，重要配置需备份。

## 2. /var 可变数据目录（运行时产生动态文件）
var = variable，程序运行过程中不断写入、变化的数据，服务器磁盘占用大户。
- /var/log：全系统日志（secure、messages、cron、nginx日志）
- /var/lib：服务持久化数据（MySQL库文件、Redis数据、rpm数据库）
- /var/run：进程PID文件、socket套接字（软链接 /run）
- /var/tmp：长期临时文件（重启不一定清空）
- /var/spool：队列数据（打印队列、邮件队列）

## 3. /usr 操作系统软件资源目录（Unix Software Resource）
存放系统预装软件、命令、库、文档，相当于Windows Program Files。
### 子目录重点
- /usr/bin：普通用户可执行基础命令 ls、cat、awk、curl
- /usr/sbin：系统管理员命令 systemctl、fdisk、iptables
- /usr/lib /usr/lib64：程序依赖动态库 .so
- /usr/share：共享资源（man帮助文档、配置模板、时区、图标）
- /usr/local：源码编译安装软件默认路径（自建程序，不受yum/apt升级覆盖）
  - /usr/local/bin 源码程序命令
  - /usr/local/nginx 编译安装nginx

## 4. /proc 伪文件系统（内核运行态信息，内存中，无真实磁盘文件）
proc = process，**内核与进程实时参数视图**，关机全部消失。
- /proc/cpuinfo 查看CPU型号、核心数
- /proc/meminfo 内存使用详情
- /proc/loadavg 系统1/5/15分钟负载
- /proc/sys/ 可动态修改内核参数（echo 1 > /proc/sys/net/ipv4/ip_forward）
- /proc/PID/ 每个进程单独目录，PID为进程号，查看进程打开文件、内存、线程

## 5. /sys 伪文件系统（硬件底层，systemd使用）
比/proc更规范，专门输出**硬件设备、驱动、总线信息**，用于系统管理、设备识别。
- /sys/block 所有磁盘块设备 sda、sr0
- /sys/net 网卡硬件信息
可修改设备电源、调度策略，内核导出硬件标准接口。

## 6. /dev 设备文件目录（硬件映射文件）
Linux 硬件全部抽象为文件，读写文件等价操作硬件。
### 块设备（缓存、按块读写：磁盘）
- /dev/sda 第一块物理磁盘
- /dev/sda1 磁盘第一个分区
- /dev/cdrom 光驱
### 字符设备（无缓存，流式读写）
- /dev/tty0 本地终端
- /dev/null 黑洞，写入数据直接丢弃
- /dev/zero 无限输出0，用于创建swap文件
- /dev/random /dev/urandom 随机熵池，加密使用

## 7. /tmp 临时文件目录
tmp = temporary，所有用户可读写，**系统重启自动清空**。
程序缓存、解压临时包、脚本临时输出放这里。
系统自动清理规则：10天未访问文件会被系统定时删除。

## 8. /home 普通用户家目录集合
所有普通用户的个人数据根目录，每个用户独立文件夹：
- /home/admin 用户admin的专属目录
- 用户的配置 ~/.ssh、~/.bashrc、文档、代码全部存在这里
服务器多开发、多业务用户时，数据集中存放于此。

## 9. /root 超级管理员root家目录
root专属文件夹，权限700，普通用户无访问权限。
区别：普通用户在/home，root不归属/home，单独/root。
存放root脚本、私钥、运维工具、备份文件。

# 补充其他高频核心目录（扩展背诵）
1. /boot：系统启动文件
vmlinuz内核、initramfs、grub引导配置，磁盘分区必须单独划分1G左右，磁盘满会无法开机。
2. /mnt：临时手动挂载目录
管理员临时挂载U盘、移动硬盘、共享存储，用完卸载。
3. /media：自动挂载外设（桌面系统U盘、光盘自动挂载点）
4. /lib /lib64：系统启动必备底层动态库，/usr/lib是应用库

# 快速区分记忆口诀
- /etc：静态配置
- /var：动态日志、数据
- /usr：系统软件、命令
- /proc：进程内核运行参数
- /sys：硬件驱动信息
- /dev：硬件设备文件
- /tmp：临时文件，重启清空
- /home：普通用户目录
- /root：管理员root目录
- /boot：启动内核引导文件
```

#### 文件类型识别：普通文件、目录、软链接/硬链接、设备文件、管道、套接字

```md
# Linux 7种文件类型完整识别、原理、区分、实战命令
## 一、识别入口
1. `ls -l` 第一列第一个字符代表文件类型
2. `file 文件名` 直接输出详细文件类型
3. `stat 文件名` 查看inode、链接数、设备号底层信息

## 二、7类文件逐条详解
### 1. 普通文件 `-`
标识：`ls -l` 首字符 `-`
存放文本、脚本、二进制程序、压缩包、图片日志等，最常见文件。
细分：
- 文本文件：`.txt .sh .conf`
- 二进制程序：`/bin/ls`、编译后的可执行文件
- 数据文件：日志、压缩包、数据库文件

示例：


-rw-r--r-- 1 root root  120 Jul 10 test.txt

### 2. 目录文件 `d`
标识：首字符 `d`
文件夹，内部存储该目录下所有文件的文件名与对应inode映射表。
目录默认权限至少执行权限x，否则无法进入目录查看内容。


drwxr-xr-x 2 root root 4096 Jul 10 data/


### 3. 硬链接 `无独立标识，和原文件完全一致`
标识：`ls -l` 看不到单独类型符号，和源文件同为 `-`
#### 底层原理
1. 硬链接本质：**多个文件名指向同一个inode**；
2. inode存储文件真实数据块，多个硬链接共享一份数据；
3. 删除其中一个文件名，只要链接计数>0，数据不丢失；
4. 限制：
   - 不能跨分区（不同文件系统inode独立）
   - 不支持目录（系统防止循环递归）
#### 创建命令
ln source.txt hardlink.txt


#### 判断硬链接：ls -l 第二列是链接计数，多个文件inode相同
ls -i
# 相同inode即为硬链接


### 4. 软链接（符号链接）`l`

标识：首字符 `l`

#### 底层原理

1. 软链接是**独立小文件**，自身拥有单独inode；

2. 文件内容只保存目标文件的路径字符串；

3. 类似Windows快捷方式；

4. 特性：

   - 可跨分区、可链接目录；

   - 原文件删除/移动后，软链接失效（红底闪烁 broken link）；

     #### 创建命令

     ```bash
     ln -s source.txt softlink.txt
     ```

     示例输出：

     ```
     lrwxrwxrwx 1 root root  9 Jul 10 softlink.txt -> source.txt
     ```

### 5. 设备文件（分块设备 / 字符设备）

#### （1）块设备 `b`

标识：首字符 `b`
带缓冲区，按**块**批量读写，磁盘、分区、光驱

brw-rw---- 1 root disk 8, 0 Jul 10 /dev/sda
brw-rw---- 1 root disk 8, 1 Jul 10 /dev/sda1


#### （2）字符设备 `c`

标识：首字符 `c`
无缓冲，流式逐个字节读写，终端、黑洞、随机数设备

crw-rw-rw- 1 root tty  1, 3 Jul 10 /dev/null
crw--w---- 1 root tty  4, 0 Jul 10 /dev/tty0


### 6. 管道文件（命名管道FIFO）`p`

标识：首字符 `p`
进程间通信IPC，单向数据流，先进先出；
常用于程序间传递数据，不占用磁盘空间。
创建：

mkfifo pipe_test


输出示例：

prw-r--r-- 1 root root 0 Jul 10 pipe_test


### 7. 套接字文件 socket `s`

标识：首字符 `s`
本地进程间IPC通信（比管道更强大，支持双向通信）；
数据库、Web服务本地通信大量使用，存放于 `/var/run/`
示例：`/var/run/mysqld/mysqld.sock`

srwxrwxrwx 1 mysql mysql 0 Jul 10 mysqld.sock


## 三、速查表（背诵）

| 首字符   | 文件类型      | 核心特点                |
| ----- | --------- | ------------------- |
| `-`   | 普通文件      | 文本、程序、日志、压缩包        |
| `d`   | 目录        | 存放文件名与inode映射       |
| `l`   | 软链接       | 独立inode，存目标路径，源删则失效 |
| 无单独标识 | 硬链接       | 共享inode，同分区，删文件不丢数据 |
| `b`   | 块设备       | 磁盘分区、光驱，带缓存块读写      |
| `c`   | 字符设备      | /dev/null、终端，流式字节读写 |
| `p`   | 管道FIFO    | 单向进程通信              |
| `s`   | socket套接字 | 本地双向进程通信（数据库常用）     |

## 四、高频面试区分：硬链接 vs 软链接

1. inode：硬链接同inode；软链接独立inode
2. 跨分区：硬链接不行；软链接支持
3. 链接目录：硬链接不允许；软链接可以
4. 删除源文件：硬链接数据保留；软链接失效
5. 文件大小：硬链接和源文件大小一致；软链接大小等于目标路径字符长度

## 五、实操判断命令

# 1. 看类型符号
ls -l filename

# 2. 精确识别文件类型
file filename

# 3. 查看inode区分硬链接
ls -i filename

# 4. 查看底层设备号、链接数
stat filename
```

#### inode 与 block 底层原理

```md
# inode 与 block 底层原理（面试高频完整讲解）
## 一、磁盘文件存储基础结构
格式化磁盘分区时，系统会把分区划分为两大区域：
1. **数据区 block**：真实存放文件内容（文本、二进制、日志）
2. **inode 索引区**：存放文件元数据（属性），不存文件内容

### 1. block 块
- 最小读写单位，格式化时固定大小（常见 4K）
- 一个大文件占用多个连续/离散block；小文件也至少占用1个block（磁盘空间浪费）
- 所有文件真实数据全部存在block里

### 2. inode 索引节点
每个文件**唯一对应一个inode**，inode有数字编号 `inode号`
inode 内部存储**元数据（metadata）**，不包含文件名，包含：
1. 文件大小
2. 权限 rwx、属主、属组
3. 时间：访问atime、修改mtime、属性变更ctime
4. 文件类型（普通/目录/设备/链接）
5. 数据block指针（指向存放文件内容的块地址）
6. 硬链接计数（有多少个文件名指向此inode）

### 3. 文件名存在哪里？
**文件名只存在目录的block中**
目录本质是一张映射表：`文件名 → inode编号`
打开文件流程：
1. 进入目录，读取目录block，根据文件名查到inode号
2. 通过inode区读取文件属性
3. 根据inode内block指针，读取真实文件数据

## 二、硬链接本质（结合inode）
### 1. 硬链接原理
`ln a.txt link_a.txt`
- 两个文件名 `a.txt`、`link_a.txt` **指向同一个inode**
- inode链接计数 +1
- 无独立inode、不占用额外block（仅目录增加一条文件名映射记录）

### 2. 硬链接核心特性
1. 共享同一份block数据，修改任意文件，两边同步变化
2. 删除其中一个文件名，inode链接计数-1；计数>0，数据仍保留
3. 限制：
   - 不能跨分区（不同分区inode表独立，inode号不通用）
   - 不支持目录硬链接（防止目录循环死递归）
4. ls -l 第二列数字 = inode硬链接计数

### 软链接对比（补充区分）
软链接`ln -s`拥有**独立inode**，文件内容仅保存目标文件路径；源文件删除则链接失效，和硬链接完全不同。

## 三、磁盘满的两种核心场景（企业生产故障高频）
分区总空间 = 所有block总容量
分区文件上限 = inode总数量（格式化时固定分配）

### 场景1：block耗尽（磁盘容量满，最常见）
现象：`df -h` 显示100%占用，无法新建文件
原因：大量日志、业务数据、大文件占满所有数据块block
表现：
- touch 创建文件报错：No space left on device
- df -h 使用率100%，df -i inode使用率很低
解决：清理大文件，释放block空间

### 场景2：inode耗尽（磁盘还有空间，但无法创建新文件）
格式化时系统预分配固定数量inode，小文件极多会快速消耗inode
例如：百万级小缓存文件、大量空日志、碎文件
现象：
1. `df -h` 磁盘只用了50%，还有大量剩余空间
2. `df -i` 查看inode使用率 100%
3. touch新建文件依然报错：No space left on device
原理：
每一个文件/目录至少占用1个inode；inode索引区全部用完，没有新inode分配给新文件，哪怕block还有空余。

解决：批量删除大量细碎小文件，释放inode。

## 四、配套实操命令
# 查看文件inode号
ls -i test.txt

# 查看分区inode使用情况
df -i

# 查看文件inode详细信息
stat test.txt

# 查找当前目录硬链接相同inode文件
find . -inum 131073

# 统计目录下文件数量（判断inode消耗）
ls -l | wc -l


## 五、面试背诵精简总结

1. 磁盘分区分inode区（存文件属性）、block区（存真实内容）；文件名存于目录block，不在inode。

2. 硬链接：多文件名共用同一个inode，链接计数控制数据删除，不可跨分区、不支持目录。

3. 磁盘满两种情况：
   ① block耗尽：大文件占满存储空间，df -h 100%；
   ② inode耗尽：海量小文件用光索引节点，磁盘空间充足但无法新建文件，df -i 100%。
```

#### Linux 文件基础操作全套命令演示注释

```md
# Linux 文件基础操作全套命令演示注释
# 1. pwd 打印当前工作目录
pwd

# 2. cd 切换目录
cd /tmp                  # 进入/tmp临时目录
cd ~                     # 回到当前用户家目录
cd -                     # 切换回上一次所在目录
cd ..                    # 进入上级目录
cd ../data               # 上级目录下的data文件夹

# 3. ls 列出目录内容
ls                       # 简略展示文件/目录名
ls -l                    # 长格式，权限、属主、大小、时间、文件类型
ls -lh                   # 人类可读单位显示文件大小
ls -a                    # 显示隐藏文件（以.开头）
ls -i                    # 显示每个文件inode编号
ls -ld /etc              # 只查看目录自身属性，不展开内部文件

# 4. mkdir 创建目录
mkdir test_dir                   # 创建单层目录
mkdir -p parent/child/grandson    # -p 递归创建多级目录，不存在父目录自动生成
mkdir -m 700 secure_dir           # 创建同时指定权限700

# 5. touch 创建空文件 / 更新文件时间戳
touch test.txt                   # 文件不存在则新建空文件；存在则刷新atime/mtime
touch file{1..5}.txt             # 批量创建 file1.txt ~ file5.txt

# 6. cp 复制文件/目录
cp test.txt /tmp/                # 复制文件到/tmp目录
cp test.txt /tmp/new_test.txt    # 复制并重命名
cp -r source_dir /tmp/           # -r 复制目录（递归）
cp -p test.txt /tmp/             # -p 保留原文件权限、时间戳等属性
cp -i test.txt /tmp/             # -i 覆盖前交互式询问确认

# 7. mv 移动/重命名
mv test.txt new_test.txt         # 同目录下：重命名文件
mv new_test.txt /tmp/            # 跨目录：移动文件
mv dir1 /tmp/new_dir             # 移动并重命名目录

# 8. rm 删除文件/目录（高危操作）
rm test.txt                      # 删除普通文件
rm -i test.txt                   # 删除前询问确认
rm -rf test_dir                  # -r递归删除目录，-f强制不提示（生产慎用！）

# 9. ln 创建软硬链接
# 硬链接 ln 源文件 链接名
ln test.txt hard_link.txt
# 软链接 ln -s 源文件 链接名（符号链接，类似快捷方式）
ln -s test.txt soft_link.txt

# 10. file 识别文件类型
file test.txt
file /dev/sda
file soft_link.txt

# 11. stat 查看文件inode、块、时间、硬链接计数底层信息
stat test.txt
stat /tmp
```

#### 通配符、基础正则符号

```md
# 通配符
*
?
[abc]
[a-z]
[!字符集]
{a,b,c}

基础正则表达式
全称：Basic Regular Expression
缩写：BRE
^
$
.
*
[]
[^]
\(\)分组捕获（BRE 必须转义）
\
\{n\}
\{n,\}
\{,m\}
\{n,m\}

^$ 表示空行


扩展正则表达式
全称：Extended Regular Expression
缩写：ERE
+
?
|
()
{n,m}
    {n}
    {n,}
    {,m}

# 一、Shell 通配符（匹配文件名，仅 ls/cp/mv/rm/find 等文件名场景）

## 基础通配符
# * 匹配任意长度任意字符（0个或多个）
ls *.txt        # 所有以.txt结尾文件
ls test*        # test开头所有文件

# ? 匹配**单个任意字符**，必须占1位
ls file?.txt     # file1.txt filea.txt，不匹配file10.txt

# [] 匹配括号内任意单个字符
ls file[123].txt # file1 file2 file3
ls file[a-z].txt # 小写字母
ls file[0-9].txt # 数字
ls file[!0-9].txt # !取反，非数字单个字符


## 特殊扩展通配符（bash 开启 `shopt -s extglob`）

# ?(pattern) 匹配0次或1次
# *(pattern) 匹配0次或多次
# +(pattern) 匹配1次或多次
# !(pattern) 不匹配该模式


# 二、基础正则表达式（BRE：grep 默认、sed 默认）

基础正则符号：`. * ^ $ [] \(\) \{\}`
| 符号 | 含义 |
|------|------|
| `.` | 任意单个字符 |
| `*` | 前面字符匹配 0次/多次 |
| `^` | 行开头 |
| `$` | 行结尾 |
| `[]` | 匹配单个字符集 `[0-9] [a-z]`；`[^0-9]` 非数字 |
| `\(\)` | 分组捕获（BRE必须转义） |
| `\{n\}` | 匹配n次；`\{n,\}`至少n次；`\{n,m\}` n~m次 |
| `\` | 转义符，还原符号字面意义 |

示例：

grep '^root' /etc/passwd      # 以root开头行
grep 'bash$' /etc/passwd      # bash结尾行
grep 'r..t' /etc/passwd       # r任意两字符t
grep 'ro*t' test.txt          # o出现0/多次 rt rot rooot
grep '[0-9]\{3\}' test.txt    # 连续3个数字
grep '\(ab\)\{2\}' test.txt   # abab


# 三、扩展正则表达式 ERE（grep -E / sed -r / awk 默认）

不用大量反斜杠，新增 `+ ? | () {}`，符号原生生效

## 新增核心符号

1. `+` 前字符至少匹配1次（1次及以上）
2. `?` 前字符匹配0或1次（可有可无）
3. `|` 或，多模式任选其一
4. `()` 分组，无需转义
5. `{n,m}` 次数限定，无需转义

## ERE 示例

# grep -E 启用扩展正则
grep -E 'ro+t' test.txt       # o至少1次 rot rooot
grep -E 'ro?t' test.txt       # o出现0/1次 rt rot
grep -E 'root|nginx' file     # 匹配root 或 nginx
grep -E '(abc){2,3}' test     # abcabc / abcabcabc
grep -E '[0-9]{1,3}' test     # 1~3位数字


# 四、关键区分（面试高频）

1. **通配符**：只匹配文件名，Shell解析；`*`任意多字符，`?`单个字符；不用于文本过滤
2. **基础正则 BRE**：grep/sed 默认，`() {} + ? |` 需要加反斜杠转义
3. **扩展正则 ERE**：grep -E、sed -r、awk，所有元字符直接使用，无需转义

# 五、速记对比

1. 匹配文件名 → 通配符 `* ? []`
2. 过滤文本行（grep/sed）
   - 不加参数：基础正则，`\(\) \{\}`
   - `-E/-r`：扩展正则，`() {} + ? |` 直接写
```

#### `/proc` 与 `/sys` 伪文件系统：查看内核参数、系统状态的入口

```md
# /proc 与 /sys 完整对比（底层原理+常用实战+面试考点）
## 一、统一基础概念
1. 两者都是**伪文件系统**，只存在内存中，无磁盘真实文件，系统重启全部丢失；
2. 作用：内核对外暴露硬件、进程、内核参数的接口；
3. 挂载自动完成：开机内核自动挂载，无需手动 `/etc/fstab`；
4. 读写权限：
   - 读：查看系统/硬件/进程状态；
   - 写：临时修改内核运行参数（立即生效，重启失效）。

## 二、/proc 伪文件系统（进程+全局内核运行信息）
### 定位
proc = process，核心两大内容：**所有进程信息 + 全局系统内核运行参数**
### 1. 进程目录（数字文件夹 = PID）
`/proc/[PID]/` 每个运行进程独立目录
常用子目录/文件：
- `/proc/PID/cmdline`：进程启动命令
- `/proc/PID/status`：进程内存、线程、UID、状态
- `/proc/PID/fd/`：进程打开的所有文件句柄（管道、套接字、磁盘文件）
- `/proc/PID/mem`：进程虚拟内存
- `/proc/PID/cwd`：软链接，进程当前工作目录

示例：查看sshd进程启动命令
ps -ef | grep sshd
cat /proc/1234/cmdline

### 2. 全局系统信息（无数字命名文件）

# CPU信息
cat /proc/cpuinfo
# 内存总容量、剩余、buffer/cache
cat /proc/meminfo
# 系统1/5/15分钟负载
cat /proc/loadavg
# 内核版本
cat /proc/version
# 系统挂载点
cat /proc/mounts
# 磁盘IO统计
cat /proc/diskstats
# 网络连接、端口
cat /proc/net/tcp
cat /proc/net/udp
# 中断信息
cat /proc/interrupts


### 3. 动态内核可调参数 /proc/sys/（高频运维）

路径分类：`/proc/sys/net`、`/proc/sys/vm`、`/proc/sys/fs`
可直接echo写入修改，临时生效

# 开启内核IP转发（网关/iptables NAT必备）
echo 1 > /proc/sys/net/ipv4/ip_forward

# 调整TCP连接回收
echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse

# 内存脏页写入阈值
cat /proc/sys/vm/dirty_ratio


永久保存需写入 `/etc/sysctl.conf`，执行 `sysctl -p`

## 三、/sys 伪文件系统（标准化硬件、总线、驱动）

### 定位

专门管理**硬件设备、总线、驱动**，是比/proc更规范的硬件标准接口；systemd、udev依赖/sys识别硬件生成/dev设备文件。

### 顶层核心目录

1. `/sys/block`：所有块设备（磁盘、分区 sda、sdb、sr0）

   ls /sys/block/sda/size      # 磁盘扇区大小
   cat /sys/block/sda/queue/scheduler # IO调度算法


2. `/sys/class`：硬件设备分类（网卡、显卡、终端、声卡）

   # 网卡信息

   ls /sys/class/net/ens33/
   cat /sys/class/net/ens33/speed

3. `/sys/bus`：硬件总线（pci、usb、platform）

4. `/sys/devices`：底层完整硬件设备树（所有硬件真实层级）

5. `/sys/fs`：文件系统、cgroup相关

### 核心特点

1. 文件格式标准化：单个数值、简短字符串，易于程序读取；
2. 专门给udev使用：根据/sys硬件信息自动生成 `/dev` 设备文件；
3. 可修改硬件配置：调整IO调度、网卡节能、电源策略。
```

四、/proc vs /sys 核心区分（面试必背）

| 维度       | /proc                   | /sys                |
| -------- | ----------------------- | ------------------- |
| 核心用途     | 进程管理、系统全局负载、内核网络/内存运行参数 | 硬件、总线、驱动、块设备、网卡硬件信息 |
| 设计初衷     | 早期内核调试接口，格式杂乱无统一标准      | 标准化硬件管理接口，结构化目录     |
| 操作对象     | 进程PID、内核运行参数            | 磁盘、网卡、PCI、USB等物理硬件  |
| 典型使用者    | 运维手动查看系统负载、调网络内核参数      | udev、systemd、硬件管理程序 |
| 能否修改硬件属性 | 几乎不能                    | 可修改IO调度、网卡参数等硬件策略   |

```md
## 五、高频面试问答
1. Q：修改 `/proc/sys` 参数重启失效怎么办？
A：写入 `/etc/sysctl.conf`，sysctl -p 加载永久生效。
2. Q：udev 靠哪个文件系统识别硬件生成/dev？
A：/sys。
3. Q：查看进程打开了哪些文件看哪里？
A：/proc/进程PID/fd。
4. Q：查看磁盘IO调度器去/proc还是/sys？
A：/sys/block/sda/queue/scheduler。
5. Q：两个文件系统的数据存在磁盘吗？
A：不存在，全部驻留内存，重启清空。

## 六、快速记忆口诀
/proc：管进程、负载、内核网络内存参数；
/sys：管磁盘网卡各类物理硬件设备。
```

---

### 模块3：用户、权限与安全基础（运维安全底线）

**定位**：日常操作高频使用，权限配置错误是生产事故重灾区

#### 核心知识点

- 用户管理：`useradd/usermod/userdel/passwd`、`/etc/passwd /etc/shadow` 文件结构解析
- 用户组管理：`groupadd/groupmod/groupdel`、`/etc/group`、主组与附加组
- **基础权限 rwx**：符号法、数字法、`chmod/chown/chgrp`
- 特殊权限：SUID/SGID/Sticky Bit 的作用、风险、配置方法
- **ACL 精细权限**：`setfacl/getfacl`，针对特定用户/组的精细化权限控制
- sudo 提权：`/etc/sudoers` 配置、免密 sudo、权限最小化原则
- SELinux 基础：三种模式、查看与切换、基础排障（了解即可，生产多关闭）

#### 学习目标

能灵活管理用户与权限，遵循最小权限原则配置生产环境，理解各类权限的适用场景。

#### 用户管理：

`useradd/usermod/userdel/passwd`、`/etc/passwd /etc/shadow` 文件结构解析

```md
# 一、用户管理核心命令详解
## 1. useradd 创建用户

# 基础创建，自动创建同名组、家目录/home/test、默认shell /bin/sh
useradd test

# 常用参数组合（生产标准写法）
# -u 指定UID  -g 指定主组  -G 附加组  -m 自动创建家目录  -s 指定登录shell
useradd -u 1005 -g dev -G docker,nginx -m -s /bin/bash admin

# -r 创建系统用户（无家目录、UID<1000，用于运行服务进程）
useradd -r nginx


## 2. usermod 修改已有用户属性

# 修改用户名
usermod -l newuser olduser
# 修改家目录并迁移原有文件
usermod -d /home/newuser -m newuser
# 修改UID
usermod -u 1010 newuser
# 修改主组
usermod -g ops newuser
# 追加附加组（-a 追加，不加-a会覆盖原有附加组）
usermod -aG docker newuser
# 修改登录shell，禁止登录：/sbin/nologin
usermod -s /sbin/nologin newuser
# 锁定用户
usermod -L test
# 解锁用户
usermod -U test

## 3. userdel 删除用户

# 仅删除用户，保留家目录与邮件
userdel test
# -r 删除用户 + 同步删除家目录、邮件文件（彻底清理）
userdel -r test


## 4. passwd 密码管理

# 设置/修改当前用户密码
passwd
# 管理员修改指定用户密码
passwd test
# 标准非交互脚本设置密码
echo "123456" | passwd --stdin test
# 锁定账号（无法登录）
passwd -l test
# 解锁账号
passwd -u test
# 查看密码状态（是否过期、锁定）
passwd -S test
# 设置密码7天后过期
passwd -x 7 test


# 二、/etc/passwd 用户基础信息文件

所有用户（普通用户+系统用户）均在此，**全局可读**
每行代表一个用户，用 `:` 分隔7段字段：
格式：`用户名:密码占位符x:UID:GID:注释信息:家目录:登录Shell`

示例行：
`root:x:0:0:root:/root:/bin/bash`

分段解析：

1. root：登录用户名
2. x：密码占位符，真正密文存在 `/etc/shadow`，x代表启用影子密码
3. 0：UID 用户ID
   - UID=0 超级管理员root
   - 1~999 系统用户（进程专用，不可登录）
   - ≥1000 普通可登录用户
4. 0：GID 用户**主组**ID，对应 `/etc/group`
5. root：注释/备注字段（可存姓名、电话）
6. /root：用户家目录
7. /bin/bash：登录解释器
   - `/bin/bash` 可交互登录
   - `/sbin/nologin`、`/bin/false` 禁止远程/本地登录

# 三、/etc/shadow 影子密码文件（安全核心）

权限严格 `-rw------- 1 root root`，仅root可读，存放加密密码与时效规则
每行对应一个用户，`:` 分割9个字段
格式：`用户名:加密密码:最后一次改密码时间:最小修改间隔:最大有效期:提前提醒天数:过期宽限天数:账号过期时间:保留`

示例：
`root:$6$xxxxxxx$xxxxxxxxxxxx:18900:0:99999:7:::`

分段详解：

1. root：用户名，与passwd一一对应
2. $6$xxxxxxx$xxx：加密密码
   - $6$ 代表 SHA-512 加密算法
   - 中间随机字符串是盐值
   - 末尾是密码哈希；!! / ! 代表账号锁定无密码
3. 18900：从1970-01-01到上次改密码的天数
4. 0：最小间隔天数，改完密码至少等N天才能再次修改
5. 99999：密码最大有效天数，到期必须改密码
6. 7：密码过期前7天弹窗提醒修改
7. 空：密码过期后宽限天数，超过则账号锁定
8. 空：账号绝对过期日期（时间戳天数），到期直接禁用
9. 保留字段，预留扩展

# 四、配套组管理简记

groupadd dev          # 创建组
groupmod -n newdev dev # 修改组名
groupdel dev          # 删除空组
groups test           # 查看用户所有组
id test               # 查看UID/GID/附加组


# 五、面试高频考点

1. /etc/passwd 里的 x 作用？
   启用影子密码机制，密文转移到仅root可读的shadow，提升安全。
2. 禁止用户登录两种shell：/sbin/nologin、/bin/false 区别？
   /sbin/nologin 会提示账号不可登录；/bin/false 无任何提示直接断开。
3. usermod -G 不加 -a 的坑：直接覆盖原有附加组，会丢失已有附属权限。
4. shadow文件权限为什么必须严格？
   存放加密哈希，普通用户可读会被暴力破解，因此仅root拥有读写权限。
5. UID=0 唯一特权账号，任何UID为0的用户等价root权限。
```

#### 用户组管理：

`groupadd/groupmod/groupdel`、`/etc/group`、主组与附加组

```md
# 一、用户组核心命令 groupadd / groupmod / groupdel
## 1. groupadd 创建用户组

# 基础创建，自动分配GID
groupadd ops

# -g 指定自定义GID
groupadd -g 2000 docker

# -r 创建系统组（GID < 1000，服务进程使用）
groupadd -r nginx


## 2. groupmod 修改已有组

# -g 修改组ID
groupmod -g 2001 docker

# -n 修改组名称
groupmod -n dev ops


## 3. groupdel 删除组

# 只能删除没有用户作为【主组】的空组
groupdel dev

坑：如果某用户的主组是该组，无法直接删除，需先修改用户主组。

## 4. 查看用户所属组

# 打印用户全部组（主组+附加组）
groups admin

# 详细输出UID/GID/主组/附加组
id admin

# 二、/etc/group 文件解析

存放所有用户组信息，全局可读，每行一组，冒号 `:` 分隔4段
格式：`组名:密码占位符x:GID:附加用户列表`

示例：
`docker:x:2000:admin,www`

字段拆解：

1. docker：组名称
2. x：组密码占位符（组密码存于 `/etc/gshadow`，极少使用）
3. 2000：GID 组ID
4. admin,www：**附加组成员**（逗号分隔，仅代表附加组，不包含主组用户）

补充 `/etc/gshadow`：组加密密码、组管理员，生产几乎不用。

# 三、主组 vs 附加组（核心必区分）

## 1. 主组（初始登录组，Primary Group）

1. 用户创建时默认生成同名组，作为该用户主组；
2. `/etc/passwd` 第4列 GID 就是主组ID；
3. 用户新建文件/目录时，文件默认属组为**主组**；
4. 一个用户**只能有1个主组**。

### 修改用户主组

usermod -g 目标组 用户名
# 示例：把admin主组改为ops
usermod -g ops admin


## 2. 附加组（附属组，Supplementary Group）

1. 用于赋予额外权限，如docker、sudo、nginx；
2. 一个用户可以拥有**多个附加组**；
3. 附加组成员记录在 `/etc/group` 最后一列；
4. 修改附加组必须带 `-a` 追加，否则覆盖清空原有附加组。

### 追加附加组（正确写法）

# -a 追加，-G 指定附加组列表
usermod -aG docker,sudo admin


坑：不加 `-a`，`usermod -G docker admin` 会删除用户原有所有附加组，只保留docker。

## 3. 主组、附加组完整演示

# 创建用户admin，主组admin，附加组docker
useradd -m admin
usermod -aG docker admin

# id查看
id admin
# uid=1000(admin) gid=1000(admin) 主组gid
# 组列表：1000(admin),2000(docker) 主组+附加组


# 四、面试高频考点

1. Q：/etc/group 最后一列的用户是什么用户？
   A：仅**附加组成员**，不会列出把该组当作主组的用户。
2. Q：新建文件的属组由谁决定？
   A：用户当前有效主组（id的gid）。
3. Q：usermod -g 和 -G 区别？
- `-g`：修改**唯一主组**；
- `-G`：设置附加组列表，不加 `-a` 会覆盖全部附加组。
4. Q：groupdel 删除失败的原因？
   A：存在用户将该组设为主组，需先用 `usermod -g` 更换用户主组后再删。
5. Q：一个用户最多几个主组、几个附加组？
   A：只能1个主组；附加组无硬性数量上限。
```

#### 基础权限 rwx

符号法、数字法、`chmod/chown/chgrp`

```md
# 一、权限基础结构
Linux 文件权限分为三段，共9位权限位，对应三类身份：
`属主(user) 属组(group) 其他用户(other)`
每类身份固定3位：`r w x`

## rwx 单字符含义
| 权限 | 文件作用 | 目录作用（重点区分） |
|------|----------|---------------------|
| r(read) 读 | 读取文件内容 | 列出目录内文件名（ls） |
| w(write) 写 | 修改/覆盖文件内容 | 创建、删除、重命名目录内文件 |
| x(execute) 执行 | 可作为程序运行 | 可进入目录（cd 目录）、读取目录内文件详情 |

> 关键坑：目录只给w不给x，依然无法删除文件；进入目录必须x权限。

# 二、两种权限表示方式
## 1. 符号法（u/g/o/a + + - =）
身份标识：
- `u` user 属主
- `g` group 属组
- `o` other 其他
- `a` all 全部(u+g+o)

操作符：
- `+` 增加权限
- `-` 移除权限
- `=` 直接赋值权限（覆盖原有）

示例：
# 给属主增加执行权限
chmod u+x test.sh
# 移除其他用户写权限
chmod o-w test.txt
# 全体增加读权限
chmod a+r test.txt
# 属主读写执行，属组只读，其他只读（赋值覆盖）
chmod u=rwx,g=r,o=r test.txt
# 同时给g和o加执行
chmod g+x,o+x test.sh


## 2. 数字法（八进制，运维最常用）

r=4，w=2，x=1；每段权限数值相加，三位数字代表 u g o

- r=4  w=2  x=1
- --- =0  --x=1  -w-=2  -wx=3  r--=4  r-x=5  rw-=6  rwx=7

### 常用标准权限

| 数字  | 权限含义      | 适用场景             |
| --- | --------- | ---------------- |
| 644 | rw-r--r-- | 普通文本、配置文件        |
| 755 | rwxr-xr-x | 目录、脚本程序          |
| 600 | rw------- | 密钥、隐私文件、/root    |
| 700 | rwx------ | 私密目录、ssh .ssh文件夹 |
| 777 | rwxrwxrwx | 所有人完全读写执行，生产严禁使用 |

示例：

# 文件标准权限
chmod 644 nginx.conf
# 目录/脚本标准权限
chmod 755 start.sh
# 私密密钥
chmod 600 id_rsa
# 私密目录
chmod 700 ~/.ssh


# 三、核心命令 chmod / chown / chgrp

## 1. chmod 修改权限（rwx读写执行权限）

# 数字法
chmod 755 test.sh
# 符号法
chmod u+x test.sh
# -R 递归修改目录下所有文件+子目录
chmod -R 755 /data/www


## 2. chown 修改属主、属组

格式：`chown 属主[:属组] 文件`

# 只改属主
chown admin test.txt
# 同时改属主+属组
chown admin:ops test.txt
# 递归修改目录所有文件归属
chown -R admin:ops /data/www


## 3. chgrp 仅修改属组

# 修改文件属组为nginx
chgrp nginx test.log
# 递归
chgrp -R nginx /var/log/nginx


# 四、面试高频总结

1. 目录缺少x权限：无法cd进入，无法ls -l查看文件详情；只有w无x也删不了文件。

2. 数字计算规则：r4 w2 x1，三段分别计算u g o。

3. chmod改权限；chown改属主属组；chgrp只改属组。

4. -R 递归慎用，线上目录误操作777会造成安全漏洞。

5. 配置文件推荐644，程序/目录755，私钥600，ssh目录700。
```

#### 特殊权限：

SUID/SGID/Sticky Bit 的作用、风险、配置方法

```md
# 特殊权限 SUID / SGID / Sticky Bit 完整详解
普通 rwx 是针对**属主、属组、其他人**的基础权限；
SUID、SGID、Sticky 是三类**附加特殊权限**，单独占用第4位权限位，作用于文件/目录，有安全风险。

## 一、权限数值与标识说明
基础9位权限之外，增加1位特殊权限（八进制第1位）：
- SUID = 4
- SGID = 2
- Sticky Bit = 1

### ls -l 展示标识
1. **SUID**：文件属主执行位 `x` 变为 `s`；若无x权限则显示大写 `S`
2. **SGID**
   - 文件：属组执行位变为 `s/S`
   - 目录：属组执行位变为 `s/S`
3. **Sticky Bit**：目录其他用户执行位 `x` 变为 `t`；无x则大写 `T`

---

## 1. SUID 置用户ID（仅对二进制可执行文件生效，目录无效）
### 作用
普通用户执行带SUID的程序时，**临时拥有该文件属主的身份权限**。
经典示例：`/usr/bin/passwd`
- passwd 文件属主是 root；
- 普通用户执行 passwd 修改密码，需要写入仅root可读的 `/etc/shadow`；
- 依靠SUID临时获得root权限，修改完成后权限收回。

### 配置方式
#### 数字法（4开头）

# 属主rwx，属组其他rx，附加SUID(4)
chmod 4755 /usr/bin/mycmd


#### 符号法
chmod u+s /usr/bin/mycmd
# 移除SUID
chmod u-s /usr/bin/mycmd


### 安全风险（高危）

1. 自定义程序设置SUID root，程序存在漏洞可提权至root；

2. 生产环境严禁随意给自定义脚本/二进制加 SUID root；

3. 排查服务器危险SUID文件：

   find / -perm -4000 2>/dev/null


---

## 2. SGID 置组ID（文件 + 目录均生效）

### 场景1：作用于可执行二进制文件

用户运行程序时，临时获得**文件所属组**权限，极少使用。

### 场景2：作用于目录（运维高频使用）

目录设置SGID后，**所有在该目录新建的文件/子目录，自动继承目录的属组**，而非创建者的默认主组。
适用场景：多人协作共享目录，统一文件属组，方便权限管控。

### 配置方式

数字法（2开头）

chmod 2770 /data/share


符号法

chmod g+s /data/share
# 移除
chmod g-s /data/share


### 风险

共享目录若属组权限过宽，容易造成文件越权读取；禁止给系统关键目录配置SGID。

### 查找带SGID文件/目录

find / -perm -2000 2>/dev/null


---

## 3. Sticky Bit 粘滞位（**仅目录生效，文件无效**）

### 作用

目录开启粘滞位后：
**每个用户只能删除/改名自己创建的文件，不能删除别人的文件**。
经典示例：`/tmp` 临时目录，所有人可读写，但不能删他人临时文件。

### 配置方式

数字法（1开头
chmod 1777 /tmp


符号法
chmod o+t /tmp
# 移除
chmod o-t /tmp


### 适用场景

公共临时目录、多用户上传共享目录，防止误删他人文件。
风险极低，属于安全加固常用权限。

### 查找带Sticky目录
find / -perm -1000 -type d 2>/dev/null


---

# 三、三种特殊权限速查表

| 权限     | 八进制值 | 生效对象   | 核心功能                        |
| ------ | ---- | ------ | --------------------------- |
| SUID   | 4000 | 仅二进制文件 | 执行时临时拥有文件**属主**身份           |
| SGID   | 2000 | 文件/目录  | 文件：临时获得文件属组；目录：新建文件自动继承目录属组 |
| Sticky | 1000 | 仅目录    | 目录内用户只能删除自己创建的文件            |

# 四、组合写法示例
# 同时开启SUID+SGID
chmod 6755 test.bin
# SGID + Sticky
chmod 3770 share
# SUID + SGID + Sticky
chmod 7777 test

# 五、面试核心考点

1. Q：为什么 passwd 命令有SUID？
   A：普通用户无权限写 /etc/shadow，SUID让执行时临时持有root权限修改密码。
2. Q：SGID目录的核心作用？
   A：新建文件自动继承目录属组，多人共享目录必备。
3. Q：Sticky Bit作用？哪个目录默认自带？
   A：防止用户删除他人文件；`/tmp` 默认权限1777带粘滞位。
4. Q：SUID最大安全隐患？
   A：自定义程序配置root SUID，漏洞导致本地提权，服务器需定期扫描4000权限文件。
5. Q：s / S、t / T 大小写区别？
   小写 s/t：原本有 x 执行权限；大写 S/T：无执行权限，特殊权限失效。

# 其他符号

drwxrwxr-x+  2 root root    6 Apr 26 22:07 /edu 
drwxrwxrwt. 15 root root 4096 Jul 13 15:30 /tmp   
-rwsr-xr-x. 1 root root 27856 Apr  1  2020 /usr/bin/passwd  

1. 末尾 `+`：配置 ACL 精细化权限；
2. 末尾 `.`：存在 SELinux 安全标签；无`.`代表丢失 / 未生成 selinux 标签；
3. 第 10 位 t：目录粘滞位 Sticky；
4. 第 4 位 s：文件 SUID 特殊权限；
5. `+` 和 `.` 是两种**扩展安全标记**，不属于基础 rwx 权限 9 位字符。

# 配套实操命令

# 查看ACL（出现+时使用）
getfacl /edu
# 清空ACL，消除+号
setfacl -b /edu

# 查看SELinux标签（判断.标记对应的上下文）
ls -Z /tmp
ls -Z /usr/bin/passwd

# 清除文件SELinux上下文，末尾.消失
chcon -t unlabeled_t /testfile
```

#### ACL 精细权限：

`setfacl/getfacl`，针对特定用户/组的精细化权限控制

```md
# ACL 精细化权限 setfacl / getfacl 完整教程
## 一、ACL 作用
传统ugo权限只能分三类：属主、属组、其他，无法单独给某个指定用户/指定组分配独立权限。
ACL（Access Control List）扩展权限，可以**单独给任意用户、任意组自定义rwx权限**。
`ls -l` 权限末尾出现 `+` 代表该文件/目录配置了ACL。

## 二、查看ACL权限 getfacl
# 查看文件/目录完整ACL规则
getfacl /edu


输出字段：
# file: /edu
# owner: root
# group: root
user::rwx            # 文件属主默认权限
user:zhangsan:r-x    # 单独给用户zhangsan分配r-x
group::rwx           # 文件属组默认权限
group:dev:r--        # 单独给组dev分配只读
mask::rwx            # 权限掩码，限制ACL最大可用权限
other::r-x           # 其他用户默认权限


### mask 掩码说明

mask 控制所有ACL用户/组能拿到的最大权限；
如果mask是`r--`，哪怕给用户配置rwx，实际最多只有读权限。

## 三、setfacl 配置ACL核心参数

### 常用参数

- `-m`：添加/修改ACL规则（modify）
- `-x`：删除单条ACL规则
- `-b`：清空所有ACL（消除ls末尾`+`）
- `-R`：递归作用目录下所有文件/子目录
- `-d`：设置**默认ACL**（目录新增文件自动继承ACL规则）

## 四、常用配置示例

### 1. 给单个用户分配权限

# 用户zhangsan 读写执行
setfacl -m u:zhangsan:rwx /edu
# 用户lisi 只读
setfacl -m u:lisi:r-- /edu


### 2. 给单个用户组分配权限

# 组ops 读写
setfacl -m g:ops:rw- /edu
# 组test 仅执行
setfacl -m g:test:--x /edu


### 3. 修改mask掩码

setfacl -m m:rwx /edu


### 4. 递归给整个目录配置ACL

setfacl -R -m u:zhangsan:rwx /edu


### 5. 默认ACL（目录新建文件自动继承权限，多人共享目录必备）

不加 `-d` 时，后续新建文件不会带上ACL；默认ACL仅对目录生效。

# 设置默认ACL，未来新建文件自动继承zhangsan rwx
setfacl -d -m u:zhangsan:rwx /edu
# 同时递归+默认ACL
setfacl -R -d -m u:zhangsan:rwx /edu


## 五、删除ACL规则

# 删除单个用户zhangsan的ACL
setfacl -x u:zhangsan /edu

# 删除单个组dev的ACL
setfacl -x g:dev /edu

# 清空全部ACL规则（ls末尾+消失）
setfacl -b /edu


## 六、备份与恢复ACL（迁移目录必备）

# 备份目录ACL到文件
getfacl -R /edu > acl_bak.txt

# 恢复ACL
setfacl --restore=acl_bak.txt


## 七、面试高频考点

1. Q：ls -l 末尾 `+` 代表什么？
   A：文件配置ACL扩展精细权限，需用getfacl查看完整规则。
2. Q：默认ACL `-d` 的作用？
   A：仅作用于目录，目录内后续新建文件/子目录自动继承ACL权限。
3. Q：mask掩码有什么用？
   A：限制所有ACL用户、组能获取的最大权限，mask过小会截断权限。
4. Q：传统ugo权限和ACL区别？
   A：ugo只有属主/属组/其他三类；ACL可针对任意单个用户、任意单个组独立授权。
5. Q：如何彻底清除ACL？
   A：`setfacl -b 文件/目录`。

## 八、完整实操流程示例

# 1. 创建共享目录
mkdir /share
# 2. 给zhangsan读写执行，给dev组只读
setfacl -m u:zhangsan:rwx /share
setfacl -m g:dev:r-- /share
# 3. 设置默认ACL，新建文件自动继承
setfacl -d -m u:zhangsan:rwx /share
# 4. 查看ACL
getfacl /share
# 5. 移除dev组权限
setfacl -x g:dev /share
# 6. 清空所有ACL
setfacl -b /share
```

#### sudo 提权：

`/etc/sudoers` 配置、免密 sudo、权限最小化原则

```md
# sudo 提权完整讲解（/etc/sudoers、免密、最小权限）
## 一、基础概念
`sudo`：普通用户临时借用管理员权限执行命令，区别于直接 `su - root`（需要root密码）。
核心配置文件：`/etc/sudoers`
- 禁止直接vim编辑，语法错误会导致sudo全部失效；
- 标准编辑命令：`visudo`（自带语法校验）

## 二、/etc/sudoers 核心语法模板
语法格式：

用户名  主机=(可切换身份:可切换组)  允许执行命令列表 [NOPASSWD:免密]

### 内置默认规则（系统自带）

# root 用户拥有全部权限
root    ALL=(ALL)       ALL

# wheel组所有用户拥有全部sudo权限（CentOS）
%wheel  ALL=(ALL)       ALL

# sudo组（Debian/Ubuntu）
%sudo   ALL=(ALL:ALL) ALL


字段拆解：

1. `用户名 / %组名`：授权对象，`%` 代表用户组
2. `ALL`（主机）：在哪台机器生效，ALL=所有本机
3. `(ALL)`：可切换到哪个用户，ALL=任意账号
4. `ALL`：允许执行的命令，ALL=全部root命令

## 三、常用配置示例（visudo内添加）

### 1. 普通用户完整sudo权限（不推荐生产，权限过大）

admin  ALL=(ALL) ALL


使用：输入admin自身密码即可执行任意root命令

sudo systemctl restart nginx
sudo rm -rf /etc/*


### 2. 免密完整sudo（高危）

`NOPASSWD:` 跳过密码校验

admin  ALL=(ALL) NOPASSWD: ALL


### 3. 权限最小化（生产标准，重点）

只允许指定几条命令，禁止全部root权限

#### 示例1：仅允许操作nginx服务

nginxuser  ALL=(ALL) /usr/bin/systemctl restart nginx, /usr/bin/systemctl start nginx, /usr/bin/systemctl stop nginx


#### 示例2：允许查看日志、df、free，禁止修改系统

ops  ALL=(ALL) /usr/bin/df, /usr/bin/free, /usr/bin/cat /var/log/*


#### 示例3：允许切换指定用户（运维账户切换业务账号）

dev  ALL=(www) ALL
# dev无需root，可sudo -u www 执行程序


### 4. 组批量授权（%组名）

# dev组所有人可重启nginx
%dev  ALL=(ALL) /usr/bin/systemctl restart nginx


### 5. 免密执行指定命令（推荐，兼顾便捷与安全）

ops  ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx


### 6. 禁止危险命令（! 取反）

# 拥有全部权限，但禁止su、passwd、rm -rf /
admin ALL=(ALL) ALL, !/usr/bin/su, !/usr/bin/passwd root, !/bin/rm -rf /


## 四、别名简化配置（大批量运维场景）

### 1. Host_Alias 主机别名

Host_Alias LOCAL = localhost,127.0.0.1


### 2. User_Alias 用户别名

User_Alias OPS = zhangsan,lisi,wangwu


### 3. Cmnd_Alias 命令别名（批量管理常用命令）

Cmnd_Alias NGINX_CMD = /usr/bin/systemctl start nginx, /usr/bin/systemctl stop nginx, /usr/bin/systemctl restart nginx


### 组合使用
OPS LOCAL=(ALL) NOPASSWD: NGINX_CMD


## 五、sudo 相关实操命令

# 查看当前用户拥有哪些sudo权限
sudo -l

# 切换root，使用sudo权限（无需root密码）
sudo -i
sudo su -

# 以指定用户执行命令
sudo -u www python app.py

# 免密配置后直接执行，无需输密码
sudo systemctl restart nginx

## 六、权限最小化原则（生产规范，面试必背）

1. **禁止直接授予 ALL 全部root权限**
   能给单条命令就不给全部，防止用户误删、提权破坏系统；
2. **精准限定可执行命令完整绝对路径**
   不写简写`systemctl`，写`/usr/bin/systemctl`，防止伪造同名恶意程序绕过限制；
3. **免密仅针对刚需场景**
   自动化脚本、定时任务才使用`NOPASSWD`，人工运维建议保留密码验证；
4. **区分授权粒度**
   只给重启服务权限，不给修改配置、删除文件权限；
5. 尽量使用用户组批量授权，减少单行用户配置，便于维护；
6. 禁止普通用户拥有`sudo su / sudo -i`完整切换root权限。

## 七、高频面试问答

1. Q：为什么编辑sudoers要用visudo，不用vim？
   A：visudo会校验配置语法，语法错误会锁死所有sudo；vim保存后出错直接无法sudo。
2. Q：NOPASSWD作用？风险点？
   A：无需输入用户密码直接提权；风险：账号泄露后攻击者无限制执行root命令。
3. Q：最小权限原则怎么落地？
   A：仅分配业务必需的命令，使用绝对路径，不开放ALL，禁用su、passwd、rm高危指令。
4. Q：`sudo -l` 作用？
   A：查看当前用户被授予的所有sudo权限清单。
5. Q：%wheel 和普通用户配置区别？
   A：%代表用户组，组内所有成员共享同一份sudo规则，批量管理更方便。
```

#### SELinux 基础：

三种模式、查看与切换、基础排障（了解即可，生产多关闭）

```md
# SELinux 基础速记（三种模式、切换、排障）
## 一、SELinux 是什么
安全增强型 Linux，强制访问控制 MAC，在传统 rwx 自主权限 DAC 之外再加一层安全策略拦截；
CentOS/RHEL 系列默认开启，生产环境大量业务为了简单直接关闭。

## 二、三种运行模式
1. **enforcing 强制模式（默认）**
    违反策略的操作直接**拒绝**，同时记录日志 `/var/log/audit/audit.log`
2. **permissive 宽容/警告模式**
    不拦截操作，仅记录告警日志，用于调试排错
3. **disabled 彻底关闭**
    SELinux 完全不运行，无上下文、无拦截、无日志

## 三、查看当前模式
# 方式1（常用）
getenforce
# 输出 Enforcing / Permissive / Disabled

# 方式2
sestatus


## 四、临时切换模式（重启失效）

# 设为宽容模式调试
setenforce 0

# 切回强制模式
setenforce 1


> 无法临时切换到 disabled，只能改配置文件重启生效。

## 五、永久修改模式（配置文件 `/etc/selinux/config`）

# SELINUX=enforcing
# SELINUX=permissive
SELINUX=disabled


修改后**必须重启服务器**才生效。

字段说明：
`SELINUX=` 控制运行模式；
`SELINUXTYPE=targeted` 策略类型，不用改。

## 六、SELinux 上下文基础（ls -Z）

`ls -l` 末尾带 `.` 代表文件有 selinux 上下文标签

ls -Z /var/www/html


常见场景：nginx 无法读取网站文件，大多是上下文不匹配。

### 修复上下文命令

# 自动还原目录默认安全上下文（最常用排障）
restorecon -R /var/www/html

# 手动修改上下文
chcon -R -t httpd_sys_content_t /var/www/html


## 七、简单排障思路

1. 服务访问文件/端口被拒绝 → 先临时 `setenforce 0` 测试

   - 关闭后正常：问题就是 SELinux 拦截，修复上下文/放行策略
   - 关闭仍报错：是防火墙、文件rwx权限、程序配置问题

2. 查看拦截日志

   grep avc: /var/log/audit/audit.log


3. 网站目录、自定义程序目录优先执行 `restorecon -R` 恢复标签

4. 需要开放端口/目录持久放行：使用 `semanage`（不推荐新手，直接关闭更省事）

## 八、生产现状与风险说明

1. 中小型业务普遍关闭 SELinux，减少大量权限兼容问题；
2. 等保、金融、高安全要求服务器必须开启 enforcing；
3. 直接关闭风险：程序漏洞提权后缺少一层安全隔离防护。

## 九、面试精简背诵点

1. 三种模式：enforcing强制拦截、permissive只告警、disabled关闭；
2. `setenforce 0/1` 临时切换，改 `/etc/selinux/config` 永久关闭需重启；
3. ls -Z 查看上下文，文件权限末尾`.`代表存在selinux标签；
4. 访问报错排障第一步：临时切permissive验证是否SELinux拦截；
5. 修复上下文：restorecon -R 目录。
```

---

### 模块4：核心命令与文本三剑客（日常吃饭的工具）

**定位**：运维日常工作 80% 的操作都靠命令，三剑客是面试+生产双核心

#### 核心知识点

1. **基础命令分类**
   - 文件查看：`cat/more/less/head/tail/tailf`
   - 文件查找：`find/locate/which/whereis`（find 为重中之重，支持按名称/大小/时间/权限查找，配合 `exec/xargs`）
   - 压缩打包：`tar/gzip/bzip2/zip/unzip`
   - 系统信息：`uname/hostname/uptime/free/df/du/lscpu`
2. **管道与重定向**：管道符 `|`、输入/输出重定向、错误重定向、`/dev/null` 黑洞
3. **文本处理三剑客（必会）**
   - grep：过滤、反向过滤、正则匹配、核心参数（`-v/-E/-i/-c/-n`）
   - sed：行级增删改查、批量替换、地址定位、正则替换、批量修改配置文件
   - awk：字段切割、内置变量、条件判断、数组、统计运算、日志分析
4. 辅助工具：`cut/sort/uniq/wc/tr`

#### 学习目标

日常操作无需查文档，三剑客能独立完成 90% 的日志分析、文本处理、配置批量修改场景。

#### 基础命令分类

```md
########################## 第一类：文件查看命令 cat/more/less/head/tail/tail -F ##########################
# cat：一次性读取打印整个文件，适合小文件
cat test.txt
cat -n test.txt          # -n 显示每行行号
cat -s test.txt          # -s 压缩连续空行只保留一行

# more：基础分页工具，只能向下翻页，无向上回退
more nginx.log
# 操作：空格下一页、回车下一行、q 退出

# less：高级分页查看，推荐生产使用，支持上下翻、搜索
less nginx.log
# 操作：/关键词 正向搜索，n下一条匹配，N上一条匹配，上下箭头翻页，q退出

# head：查看文件头部内容，默认前10行
head test.txt
head -n 20 test.txt      # -n 指定查看前20行

# tail：查看文件尾部内容，默认最后10行
tail test.txt
tail -n 30 test.txt      # 查看末尾30行

# tail -f：实时跟踪文件新增输出，日志切割改名后会断流
tail -f /var/log/nginx/access.log
# tail -F：生产首选，日志滚动、切割、改名依然持续追踪日志
tail -F /var/log/nginx/access.log

########################## 第二类：文件查找 find/locate/which/whereis ##########################
# 1.find：实时遍历磁盘查找（重中之重，支持名称/大小/时间/权限/用户，搭配-exec/xargs操作文件）
## 按文件名查找
find /etc -name "hosts"                 # 在/etc目录精准查找hosts文件
find /var/log -name "*.log"             # 匹配所有后缀为.log的文件
find /tmp -iname "test*.txt"            # -iname 忽略大小写匹配

## 按文件大小查找
find / -size +100M                      # 查找系统中大于100M的文件
find /tmp -size -10k                    # 查找小于10k的文件
find /data -size 50M                    # 查找大小等于50M的文件

## 按修改时间查找
find /tmp -mtime +7                     # 查找7天前修改过的文件
find /tmp -mtime -1                     # 查找24小时内新建/修改的文件
find /data -amin -10                    # 查找10分钟内被访问的文件

## 按权限/属主查找
find / -perm -4000 2>/dev/null          # 全局查找带SUID权限高危文件，过滤无关错误输出
find /home -user root                   # 查找属主为root的文件
find /data -perm 777                    # 查找权限全开777的危险文件

## find 搭配 -exec 执行操作 {}代表匹配到的文件，\;固定结尾
find /var/log -name "*.log" -mtime +7 -exec rm -f {} \;  # 删除7天前旧日志
find /data/www -type f -exec chmod 644 {} \;            # 批量给普通文件设置644权限

## find 搭配 xargs（批量处理效率高于-exec）
find /var/log -name "*.log" -mtime +3 | xargs gzip      # 批量压缩7天前日志
find /tmp -name "tmp*" | xargs rm -rf                   # 批量删除临时文件

# 2.locate：基于系统文件数据库快速检索，速度快，新增文件需更新数据库
locate hosts
updatedb                                # 更新文件索引数据库，新增文件搜不到时执行

# 3.which：查找可执行命令的绝对路径
which ls
which nginx

# 4.whereis：查找命令二进制、源码、帮助手册路径
whereis ls
whereis nginx

########################## 第三类：压缩打包 tar/gzip/bzip2/zip/unzip ##########################
# tar：Linux标准打包工具，搭配z/j/J实现不同压缩算法
## 参数说明 c创建包 x解压 v显示过程 f指定包文件 -C 指定解压目录
# tar -zcvf z代表gzip压缩，压缩速度快，后缀tar.gz
tar -zcvf test.tar.gz /data/test        # 将/data/test打包压缩为test.tar.gz
tar -zxvf test.tar.gz -C /tmp           # 解压tar.gz到/tmp目录

# tar -jcvf j代表bzip2，压缩率更高，后缀tar.bz2
tar -jcvf test.tar.bz2 /data/test
tar -jxvf test.tar.bz2 -C /tmp

# gzip/gunzip：单文件压缩，不保留原文件，不支持打包目录
gzip test.txt
gunzip test.txt.gz

# bzip2/bunzip2：单文件高压缩
bzip2 test.txt
bunzip2 test.txt.bz2

# zip/unzip：Windows/Linux互通压缩格式，-r递归处理目录
zip -r test.zip /data/test              # 压缩目录
unzip test.zip -d /tmp                  # 解压到指定目录

########################## 第四类：系统信息 uname/hostname/uptime/free/df/du/lscpu ##########################
# uname：查看内核、操作系统信息
uname -r                                # 只打印内核版本
uname -a                                # 输出完整系统内核、硬件、时间信息

# hostname：主机名管理
hostname                                # 查看当前主机名
hostname web01                          # 临时修改主机名，重启失效
hostnamectl set-hostname web01          # CentOS7+永久修改主机名

# uptime：系统运行时长、登录用户、1/5/15分钟系统负载
uptime

# free：查看内存、交换分区使用，-h人性化单位展示
free -h
# 字段 total总内存 used已用 free空闲 buff/cache缓存 available真实可用内存

# df：查看磁盘分区整体使用率
df -h                                   # 人类可读单位查看磁盘占用
df -i                                   # 查看分区inode使用情况，排查inode耗尽故障

# du：统计目录/文件实际磁盘占用大小
du -sh /data                            # -s汇总总大小 -h人性化单位
du -h --max-depth=1 /var/log            # 只展示一级子目录大小，快速定位大文件夹

# lscpu：查看CPU硬件规格（核心、线程、架构、主频）
lscpu
```

#### 管道与重定向：管道符 `|`、输入/输出重定向、错误重定向、`/dev/null` 黑洞

```md
# ====================== 一、管道符 | 详解 ======================
# 管道 |：把前一条命令的标准输出，作为后一条命令的标准输入
# 格式：命令1 | 命令2 | 命令3

# 示例1：过滤/etc/passwd中含root的行
cat /etc/passwd | grep root

# 示例2：统计系统登录用户数量
who | wc -l

# 示例3：分页查看系统进程
ps -ef | less

# 示例4：查找日志里404报错并统计行数
cat access.log | grep "404" | wc -l

# 示例5：find查找文件后批量删除（管道搭配xargs）
find /tmp -name "*.tmp" | xargs rm -rf

# ====================== 二、输出重定向 > / >> ======================
# > 覆盖重定向：清空目标文件，再写入内容
echo "第一行内容" > test.txt

# >> 追加重定向：文件末尾追加，不覆盖原有内容
echo "第二行追加内容" >> test.txt

# 把ls输出写入文件
ls -l /etc > ls_etc.txt

# ====================== 三、输入重定向 < ======================
# < 把文件内容作为命令的输入
# 示例：读取文件统计行数
wc -l < test.txt

# 脚本常用，批量导入配置
mysql -uroot -p < init.sql

# ====================== 四、标准输出、标准错误 区分 ======================
# 1 标准输出 stdout 正常打印信息
# 2 标准错误 stderr 报错信息

# 1. 仅把正常输出写入文件，屏幕打印错误
ls /etc /nonexist > ok.txt

# 2. 仅把错误信息写入文件，屏幕打印正常输出
ls /etc /nonexist 2> err.txt

# 3. 正常输出、错误分开保存
ls /etc /nonexist > ok.txt 2> err.txt

# 4. 标准错误合并到标准输出，全部写入同一个文件
# 写法1（通用兼容）
ls /etc /nonexist > all.txt 2>&1
# 写法2（bash简化写法）
ls /etc /nonexist &> all.txt

# ====================== 五、/dev/null 黑洞设备 ======================
# /dev/null：空设备，写入的数据全部丢弃，读取返回空，用于屏蔽输出/报错

# 1. 丢弃正常输出，错误仍打印屏幕
ls /etc > /dev/null

# 2. 丢弃错误信息，正常输出保留
ls /nonexist 2> /dev/null

# 3. 正常输出+错误全部丢弃（常用定时任务、脚本屏蔽打印）
ls /etc /nonexist > /dev/null 2>&1
ls /etc /nonexist &> /dev/null

# 实用场景：定时任务屏蔽无用日志
# /5 * * * * /root/clean_log.sh &> /dev/null

# ====================== 综合组合示例 ======================
# 过滤日志ERROR，结果追加到error.log，屏蔽查找错误
grep "ERROR" /var/log/*.log >> /var/log/error.log 2>/dev/null

# 查看磁盘，只保留大于1G的分区，屏蔽权限报错
df -h | grep G 2>/dev/null
```

#### **文本处理三剑客（必会）**

- grep：过滤、反向过滤、正则匹配、核心参数（`-v/-E/-i/-c/-n`）
- sed：行级增删改查、批量替换、地址定位、正则替换、批量修改配置文件
- awk：字段切割、内置变量、条件判断、数组、统计运算、日志分析

```md
#!/bin/bash
# ========================== 第一剑客 grep 文本过滤工具 ==========================
# 核心参数：-i忽略大小写 -n显示行号 -c统计匹配行数 -v反向过滤 -E扩展正则
# 基础匹配：过滤包含root的行
grep "root" /etc/passwd

# -i 忽略大小写匹配 Root / ROOT / root
grep -i "root" /etc/passwd

# -n 输出匹配行+行号，方便定位配置文件错误行
grep -n "ssl" /etc/nginx/nginx.conf

# -c 只输出匹配到的总行数，用于统计日志报错量
grep -c "500" /var/log/nginx/error.log

# -v 反向过滤，输出不匹配关键词的行（排除注释空行）
grep -v "^#" /etc/profile | grep -v "^$"

# -E 启用扩展正则，支持 | + ? () 无需转义
grep -E "root|nginx" /etc/passwd
# 等价简写 egrep "root|nginx" /etc/passwd

# 递归搜索目录下所有文件关键词（-r）
grep -r "listen 80" /etc/nginx/

# ========================== 第二剑客 sed 行编辑器，行级增删改查、批量替换 ==========================
# 格式：sed [参数] '地址+操作' 文件
# 操作：a新增行 i插入行 d删除行 s/旧/新/g全局替换 p打印

# 1. 查询匹配行（p打印；-n只输出匹配内容）
sed -n '/root/p' /etc/passwd

# 2. 删除操作 d
sed '/^#/d' test.conf          # 删除所有注释行
sed '/^$/d' test.conf          # 删除空行
sed '3d' test.txt              # 删除第3行
sed '2,5d' test.txt            # 删除2~5行

# 3. 新增/插入行 a行后新增 i行前插入
sed '2a new_line' test.txt     # 第2行下方新增一行
sed '3i insert_line' test.txt  # 第3行上方插入一行

# 4. 批量替换 s///g  g=全局；不加g只替换每行第一个匹配
sed 's/old_text/new_text/g' test.txt
# -i 直接修改源文件（生产重点，不加-i仅预览）
sed -i 's/Listen 80/Listen 8080/g' /etc/nginx/nginx.conf
# 替换开头/结尾字符
sed 's/^/# /g' test.txt       # 每行开头加注释#
sed 's/$/;/g' test.txt         # 每行末尾加分号

# 地址定位：只匹配包含nginx的行做替换
sed '/nginx/s/root/www/g' nginx.conf

# ========================== 第三剑客 awk 列切割、统计运算、日志分析 ==========================
# 内置变量：$0整行 $1第1列 $2第2列 NF总列数 NR行号 FS分隔符
# 默认分隔符：空白（空格/制表符）

# 1. 按列截取数据
awk '{print $1,$7}' /etc/passwd          # 打印第1列用户名、第7列shell解释器
awk -F: '{print $1,$3}' /etc/passwd      # -F: 指定冒号为分隔符（passwd文件）

# 2. 内置变量使用
awk '{print NR,NF,$0}' test.txt         # NR行号 NF当前行总字段数 $0完整一行

# 3. 条件过滤（类似grep）
awk '/root/' /etc/passwd                # 输出含root的整行
awk -F: '$3==0' /etc/passwd             # 筛选UID等于0的用户（仅root）
awk -F: '$3>=1000' /etc/passwd          # 筛选普通用户UID≥1000

# 4. 日志统计示例：统计nginx访问IP访问量
# 日志格式：IP 时间 url code
awk '{print $1}' access.log | sort | uniq -c | sort -nr

# 5. 求和运算：统计磁盘总使用量
df -h | awk '/^\/dev/ {sum+=$3} END{print sum}' #这个单位显示不一样 , M 有G的加一起算的不准
df -m | awk '/^\/dev/ {sum+=$3} END{print sum}'
# 6. BEGIN/END 预处理、收尾输出
awk -F: 'BEGIN{print "用户  UID"} {print $1,$3} END{print "读取完成"}' /etc/passwd

# 7. 自定义分隔符 FS
echo "1|2|3|4" | awk 'BEGIN{FS="|"} {print $2}'
echo "1|2|3|4" | awk -F"|" '{print $2}'
```

#### 辅助工具：`cut/sort/uniq/wc/tr`

```md
# 文本辅助工具：cut sort uniq wc tr 全套注释示例

########################## 1. cut 按分隔符截取文本列 ##########################
# -d 指定分隔符，-f 指定第几列/多列
# 示例文件/etc/passwd 分隔符为冒号:
cut -d: -f1 /etc/passwd                  # 只截取第1列（用户名）
cut -d: -f1,3 /etc/passwd                # 截取第1、3列（用户名、UID）
cut -d: -f1-4 /etc/passwd                # 截取1~4连续列

# -c 按字符位置截取
echo "abc123xyz" | cut -c1-3             # 截取第1到3个字符 abc

# 结合管道使用：取IP列
cat access.log | cut -d' ' -f1

########################## 2. sort 文本行排序 ##########################
sort test.txt                            # 默认按ASCII字符升序
sort -r test.txt                         # -r 反向降序
sort -n num.txt                          # -n 按数字大小排序（纯数字文本）
sort -k2 test.txt                        # -k2 根据第2列排序
sort -t: -k3 -n /etc/passwd              # 分隔符:，按第3列UID数字排序

########################## 3. uniq 去重（仅去除相邻重复行，常配合sort） ##########################
# 单独uniq只能去掉连续重复，无序文本必须先sort
sort ip.txt | uniq                       # 去重
sort ip.txt | uniq -c                    # -c 统计每行重复出现次数（日志统计IP访问量高频）
sort ip.txt | uniq -d                    # -d 只输出重复出现过的行
sort ip.txt | uniq -u                    # -u 只输出只出现一次的行

# 经典日志统计：IP访问次数从高到低
awk '{print $1}' access.log | sort | uniq -c | sort -nr

########################## 4. wc 统计：行数、单词、字符 ##########################
wc test.txt                              # 输出 行数 单词数 字符数
wc -l test.txt                           # -l 只统计行数（最常用）
wc -w test.txt                           # -w 统计单词数
wc -c test.txt                           # -c 统计字符总数

# 管道统计匹配行数
grep "500" error.log | wc -l

########################## 5. tr 字符替换、删除、大小写转换 ##########################
# 替换字符
echo "a-b-c-d" | tr '-' '_'              # 将-替换为_
# 大小写转换
echo "Hello LINUX" | tr 'a-z' 'A-Z'      # 小写转大写
echo "HELLO" | tr 'A-Z' 'a-z'            # 大写转小写
# -d 删除指定字符
echo "123abc456" | tr -d '0-9'           # 删除所有数字，只保留字母
# -s 压缩连续重复字符
echo "aaa   bbb     ccc" | tr -s ' '     # 多个空格压缩成单个空格
```

---

### 模块5：进程、服务与定时任务

**定位**：管理系统运行的程序与服务，是业务稳定的基础

#### 核心知识点

- 进程基础：进程与线程、PID/PPID、进程状态（运行、休眠、僵尸、孤儿）
- 进程管理：`ps/top/htop`、`pstree`、`kill/killall/pkill`、`nice/renice` 优先级调整
- 后台任务：`&`、`jobs`、`fg/bg`、`nohup`、`screen/tmux` 会话保持
- **systemd 服务管理**：`systemctl` 核心命令、`.service` 单元文件编写、开机自启、服务故障排查
- **定时任务 crontab**：语法规则、编写规范、环境变量坑点、定时任务排错、`at` 一次性任务、`anacron`

#### 学习目标

能快速定位异常进程，独立管理系统服务，编写合规的定时任务，处理僵尸进程、服务异常退出等问题。

#### 进程基础：进程与线程、PID/PPID、进程状态（运行、休眠、僵尸、孤儿）

```md
# 进程基础完整讲解（附实操命令）
## 一、进程与线程
1. **进程**
程序运行后产生独立进程，拥有独立资源：内存空间、文件描述符、PID、环境变量，进程间完全隔离，切换开销大。
进程是操作系统资源分配最小单位。

2. **线程**
线程隶属于进程，共享进程内存、文件句柄等资源；线程切换开销极小。
线程是CPU调度执行最小单位。

3. 关系：一个进程至少包含1个主线程，可创建多个子线程。

## 二、PID / PPID
- **PID**：进程唯一编号，系统内不重复，init/systemd固定PID=1（CentOS7+）
- **PPID**：父进程ID，创建当前进程的父进程编号

### 实操查看
ps -ef            # 第二列PID，第三列PPID
ps aux
cat /proc/$$/stat # $$ 当前shell进程PID
pstree -p         # 树形展示父子进程+PID


## 三、四种核心进程状态

### 1. 运行态 R (Running)
进程正在CPU上执行，或就绪排队等待CPU调度。
### 2. 休眠态（两种）
1. S 可中断休眠：等待资源、IO、信号，收到信号可唤醒（绝大多数进程常态）
2. D 不可中断休眠：等待磁盘IO，无法被信号唤醒，强制关机可能丢失数据
### 3. 僵尸进程 Z (Zombie)
3. 子进程执行完毕退出，父进程**未调用wait()回收子进程退出状态**；
4. 子进程资源已释放，仅残留PID条目存退出码；
5. 危害：大量僵尸占用PID号，系统无法新建进程；
6. 解决：杀死父进程，由PID=1 systemd接管自动回收僵尸。
### 4. 孤儿进程
1. 父进程提前退出，子进程失去父进程；
2. 系统自动将孤儿进程的PPID改为1（systemd）；
3. 无害，PID=1会负责回收其退出信息，不会变成僵尸。

## 配套查看命令（bash注释版）
#!/bin/bash
# 查看全量进程，UID PID PPID 状态
ps -ef

# 查看进程详细状态字段 STAT
ps aux

# 树形父子进程，带PID
pstree -p

# 查看单个进程详细状态、PPID
cat /proc/1234/status

# 筛选僵尸进程Z
ps aux | awk '$8~/Z/'

## 速记面试总结
1. 进程：资源分配单位，独立内存；线程：调度单位，共享资源；
2. PID自身进程号，PPID父进程号，1号进程是systemd；
3. R运行，S可中断休眠，D不可中断IO休眠；
4. 僵尸Z：子进程结束父不收；孤儿：父先死，自动托管1号进程，无危害。
```

```md
# 分两层记忆，完全不冲突，分开背，两套体系用途不一样
## 第一层：操作系统课本标准五态模型（理论课堂，考试用）
只描述CPU调度的**就绪、运行、阻塞**，不含Linux特有僵尸/孤儿
1. **创建态**：程序刚加载，分配资源，未进入就绪队列
2. **就绪态**：资源齐全，只差CPU时间片，排队等调度
3. **运行态**：CPU正在执行该进程指令
4. **阻塞（等待/休眠）态**：主动放弃CPU，等IO、信号、资源，不能直接上CPU
5. **终止态**：进程执行完毕，等待父进程回收资源

暂停态属于阻塞的细分（收到STOP信号暂停，属于阻塞大类）。
这套是通用操作系统理论，所有系统通用，**不谈僵尸、孤儿**。

## 第二层：Linux 实际进程状态（运维实操，面试Linux必背，ps命令看到的STAT标记）
Linux把理论里的「阻塞态」拆成2种休眠，额外增加Linux独有的僵尸、孤儿概念，是系统落地细化：
### 1. R 运行/就绪（对应理论：运行态 + 就绪态）
- 正在CPU跑 或 排队等CPU，统一标R

### 2. S 可中断休眠（理论阻塞态）
等网络、锁、信号；收到信号就能唤醒，日常绝大多数后台服务都是S。

### 3. D 不可中断休眠（理论阻塞态细分）
正在读写磁盘IO，**不接收任何信号**，kill杀不掉，只能等IO完成或重启机器。

### 4. T 暂停态（理论阻塞细分）
收到 Ctrl+Z / kill -STOP 暂停，手动恢复才能继续运行。

### 5. Z 僵尸进程（Linux独有，属于终止态的特殊残留）
子进程已经执行完进入终止态，但父进程没回收退出信息；
进程主体资源释放，仅保留PID记录退出码，占用PID资源，有害。

### 孤儿进程（不是STAT状态标记，是进程父子关系分类）
父进程提前终止，子进程PPID自动改为1号systemd；
孤儿进程运行状态依旧是R/S/D/T，只是归属变了，**不会变成僵尸**，无危害。

# 两套体系区分记忆口诀
1. **理论五态（课本）**
创建 → 就绪 → 运行 → 阻塞(休眠/暂停) → 终止
只讲CPU调度，无僵尸、孤儿。

2. **Linux实操七类标识（ps看STAT）**
R运行就绪、S可中断休眠、D不可中断IO休眠、T暂停、Z僵尸；
孤儿只是父子关系，不属于状态标记。

# 理顺逻辑，一次性分清不混淆
1. 理论的「阻塞」= Linux S + D + T 三种休眠/暂停；
2. 理论的「终止态」正常回收就消失；父不收就变成Linux独有Z僵尸；
3. 孤儿不是进程状态，是父子关系，任何运行状态的进程都能成为孤儿；
4. 考试分场景：
- 考操作系统基础原理：答五态模型（创建、就绪、运行、阻塞、终止）；
- 考Linux运维、ps命令、服务器故障：背R/S/D/T/Z + 僵尸孤儿区别。

# 极简背诵版
1. 理论通用五态：创建、就绪、运行、阻塞、终止；
2. Linux实际状态标记：R/S/D/T/Z；
3. 阻塞拆分：S可唤醒休眠、D不可唤醒IO休眠、T手动暂停；
4. 僵尸：终止态残留，父未回收；孤儿：父进程死掉，归systemd托管。
```

#### 进程管理：

`ps/top/htop`、`pstree`、`kill/killall/pkill`、`nice/renice` 优先级调整

```md
# ====================== 进程查看工具 ps top htop pstree ======================
# 1. ps 静态查看进程快照，不实时刷新
ps -ef                  # 全格式进程列表，UID PID PPID CMD
ps aux                  # 展示CPU/内存占用、STAT状态、用户
ps aux --sort=-%cpu     # 按CPU使用率降序排列
ps aux --sort=-%mem     # 按内存使用率降序排列
ps -ef | grep nginx     # 过滤指定进程
ps -Lf 1234             # 查看PID=1234进程的线程信息

# 2. top 系统自带实时进程监视器，动态刷新
top                     # 默认3秒刷新一次
# top交互快捷键：
# P 按CPU排序 M 按内存排序 k 输入PID杀死进程 q 退出

# 3. htop 增强版top，界面友好，鼠标操作（需单独安装）
htop

# 4. pstree 树形展示父子进程关系，-p显示PID
pstree
pstree -p               # 树形+PID
pstree -p nginx         # 只看nginx相关进程树

# ====================== 进程终止信号 kill / killall / pkill ======================
# kill 发送信号给指定PID，常用信号：
# 1 SIGHUP 重载配置；9 SIGKILL 强制杀死；15 SIGTERM 优雅终止（默认）
kill 1234               # 默认发送15优雅停止进程
kill -1 1234            # 平滑重载进程配置（nginx/apache常用）
kill -9 1234            # 强制杀死，资源不释放，尽量少用

# pkill 根据进程名批量发信号
pkill nginx             # 优雅停止所有nginx进程
pkill -9 java           # 强制杀掉所有java进程

# killall 根据完整进程名批量操作
killall nginx
killall -9 mysql

# ====================== 进程优先级 nice / renice ======================
# nice值范围：-20 ~ 19
# -20 最高优先级；19最低；普通用户只能调0~19，root可设-20~19

# nice：启动程序时直接设置优先级
nice -n 10 ./test.sh    # 以优先级19以内低值启动程序
nice -n -15 /usr/bin/nginx  # root执行，高优先级启动服务

# renice：修改正在运行进程的优先级
renice 5 -p 1234        # 将PID=1234优先级改为5
renice -10 -p 1234      # root提高进程优先级
renice 3 -u www         # 修改www用户所有进程优先级
```

#### 后台任务：`&`、`jobs`、`fg/bg`、`nohup`、`screen/tmux` 会话保持

```md
#!/bin/bash
# ====================== 一、& 符号：命令直接放入后台运行 ======================
# 在命令末尾加 &，程序放到后台，终端仍可输入指令
sleep 300 &
# 输出格式：[任务号] PID，如 [1] 1892

# ====================== 二、jobs 查看当前终端后台任务列表 ======================
jobs
jobs -l         # -l 额外显示每个任务的PID
# 状态标识：Running 后台运行；Stopped 后台暂停

# ====================== 三、fg / bg 前后台切换、唤醒暂停任务 ======================
# 1. fg：把后台任务调到前台运行，占用终端
fg 1            # 将任务号1切到前台
fg              # 不带数字默认切最近一个后台任务

# 2. bg：把暂停的任务放到后台继续运行
# 操作：前台程序按 Ctrl+Z 会暂停并丢后台
sleep 600
# 按下 Ctrl+Z 后提示 [1]+  Stopped
bg 1            # 唤醒任务1，后台继续跑
bg              # 唤醒最近暂停任务

# ====================== 四、nohup 断开SSH会话持续运行，脱离终端 ======================
# 单纯 & 后台进程会随SSH断开终止；nohup 让进程忽略挂断信号SIGHUP
# 输出默认写入 nohup.out
nohup ./long_task.sh &
# 自定义日志文件，屏蔽多余输出
nohup ./long_task.sh > task.log 2>&1 &

# 补充：disown 对已后台运行的进程追加脱离终端
./long.sh &
disown -h $!    # $! 代表上一条命令的PID，脱离当前终端

# ====================== 五、screen 会话保持（断开SSH不中断程序） ======================
# 1. 创建新会话
screen -mS task_session

# 2. 后台运行任务，按 Ctrl+A 松开再按 D 分离会话，SSH可直接断开
./big_data_analysis.sh
# 快捷键 Ctrl+A+D 分离

# 3. 查看所有screen会话
screen -ls

# 4. 重新接入会话
screen -r task_session

# 5. 彻底关闭会话（会话内执行）
exit

# ====================== 六、tmux 升级版会话工具（比screen功能更强） ======================
# 1. 创建会话
tmux new -s data_task

# 2. 运行任务，按 Ctrl+B 松开，再按 D 分离会话
python train_model.py

# 3. 查看全部会话
tmux ls

# 4. 接入指定会话
tmux a -t data_task

# 5. 关闭会话
# 会话内输入 exit
tmux kill-session -t data_task
```

#### systemd 服务管理：

`systemctl` 核心命令、`.service` 单元文件编写、开机自启、服务故障排查

```md
#!/bin/bash
# ====================== systemctl 核心管理命令 ======================
# 1. 查看系统所有服务单元
systemctl list-unit-files --type=service
# 只看运行中的服务
systemctl list-units --type=service --state=running

# 2. 启动/停止/重启/重载服务
systemctl start nginx.service    # 临时启动，重启失效
systemctl stop nginx.service     # 停止服务
systemctl restart nginx.service  # 重启服务
systemctl reload nginx.service   # 平滑重载配置，不杀进程
systemctl daemon-reload          # 修改service文件后必须重载unit配置

# 3. 开机自启管理
systemctl enable nginx           # 设置开机自启
systemctl disable nginx          # 取消开机自启
systemctl enable --now nginx     # 立刻启动+开机自启一步到位

# 4. 查看服务状态、日志
systemctl status nginx           # 查看运行状态、报错、日志片段
journalctl -u nginx -f           # 实时跟踪nginx服务日志
journalctl -u nginx --since "1 hour ago" # 一小时内日志

# 5. 屏蔽服务（彻底禁用，无法手动启动）
systemctl mask nginx
systemctl unmask nginx           # 解除屏蔽

# ====================== .service 单元文件模板（自定义服务） ======================
# 文件路径：/etc/systemd/system/xxx.service
# 分三大段 [Unit] [Service] [Install]
cat > /etc/systemd/system/demo.service <<EOF
[Unit]
# 服务描述
Description=Demo Long Run Service
# 依赖网络，网络就绪后再启动
After=network.target
# 需要网络服务
Wants=network.target

[Service]
# 运行程序绝对路径
ExecStart=/usr/bin/python3 /opt/demo/main.py
# 后台常驻进程类型
Type=simple
# 进程崩溃自动重启
Restart=on-failure
# 重启间隔秒数
RestartSec=3
# 运行用户/组
User=www
Group=www
# 输出日志
StandardOutput=journal+console
StandardError=journal+console

[Install]
# 多用户模式下开机启动
WantedBy=multi-user.target
EOF

# 编写完成后重载systemd识别新服务
systemctl daemon-reload
# 设置开机自启并立即运行
systemctl enable --now demo

# ====================== 服务故障排查流程 ======================
# 1. 先看服务简要状态
systemctl status demo

# 2. 实时跟踪详细日志
journalctl -u demo -f

# 3. 查看单元文件是否有语法错误
systemctl cat demo
systemd-analyze verify /etc/systemd/system/demo.service

# 4. 排查启动顺序、系统启动耗时
systemd-analyze blame

# 5. 临时前台执行程序，直接打印报错（跳过systemd）
/usr/bin/python3 /opt/demo/main.py
```

#### 定时任务 crontab：

语法规则、编写规范、环境变量坑点、定时任务排错、`at` 一次性任务、`anacron`

```md
# ====================== 一、crontab 定时任务基础语法 ======================
# 标准格式：分 时 日 月 周 命令
# * 代表全部取值范围
# 取值范围
# 分：0-59
# 时：0-23
# 日：1-31
# 月：1-12
# 周：0-6  0/7都是周日

# 特殊符号说明
# */n 每隔n单位执行  例：*/5 * * * * 每5分钟
# , 多个时间点分隔  0 2,4,6 * * * 每天2、4、6点执行
# - 连续区间  0 1-5 * * * 凌晨1~5点整点执行

# 示例注释
# 1. 每5分钟执行脚本
*/5 * * * * /root/clean_log.sh
# 2. 每天凌晨2点30分执行
30 2 * * * /root/bak_data.sh
# 3. 每周日凌晨3点执行全量备份
0 3 * * 0 /root/full_bak.sh
# 4. 每月1号凌晨1点执行
0 1 1 * * /root/month_task.sh
# 5. 每天9-18点，每半小时执行一次
*/30 9-18 * * * /root/monitor.sh

# ====================== 二、crontab 操作命令 ======================
crontab -l              # 查看当前用户定时任务
crontab -e              # 编辑当前用户定时任务（推荐，自带语法校验）
crontab -r              # 删除当前用户全部定时任务（慎用）
# root查看其他用户任务
crontab -u www -l
crontab -u www -e

# 系统级定时任务（所有用户生效，文件：/etc/crontab）
cat /etc/crontab
# 系统周期任务目录（无需手动写表达式）
ls /etc/cron.hourly/  # 每小时
ls /etc/cron.daily/   # 每日
ls /etc/cron.weekly/  # 每周
ls /etc/cron.monthly/ # 每月

# ====================== 三、编写规范 & 环境变量大坑 ======================
# 规范1：所有命令、脚本使用【绝对路径】
# 错误写法：sh clean.sh
# 正确写法：/bin/sh /root/clean.sh

# 规范2：必须重定向输出，避免堆积邮件占用磁盘
# 标准写法：结尾 &> /dev/null 屏蔽所有输出
*/5 * * * * /root/clean.sh &> /dev/null
# 需要保留日志则写入文件
*/5 * * * * /root/clean.sh >> /var/log/clean.log 2>&1

# 规范3：脚本头部手动导入环境变量
# crontab执行时环境变量极少，PATH很短，很多命令找不到
# 解决方式1：脚本开头手动export PATH
# export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
# 解决方式2：定时任务内加载全局环境变量
0 2 * * * source /etc/profile; /root/task.sh &> /dev/null

# 坑点总结
# 1. 无完整PATH，java/python/mysql等命令直接报command not found
# 2. 工作目录不是登录用户家目录，相对路径文件找不到
# 3. 输出不重定向会持续发送邮件，/var/spool/mail/root 文件暴涨
# 4. 脚本有交互式输入，定时任务无终端直接卡住

# ====================== 四、crontab 排错步骤 ======================
# 1. 查看定时任务执行日志
tail -f /var/log/cron
# 日志会记录任务是否被调度，脚本执行报错不会打印在这里

# 2. 手动模拟crontab极简环境执行脚本，复现报错
env -i /bin/sh /root/task.sh
# env -i 清空所有环境变量，和crontab运行环境一致

# 3. 脚本内部增加日志输出，捕获执行异常
# 在task.sh开头添加 exec >> /var/log/task_run.log 2>&1

# 4. 检查脚本权限、是否可执行
chmod +x /root/task.sh

# ====================== 五、at 一次性定时任务（仅执行一次） ======================
# 安装：yum install at / apt install at
# 启动服务
systemctl start atd && systemctl enable atd

# 使用示例
# 5分钟后执行脚本
at now +5 minutes
/root/tmp_task.sh
# Ctrl+D 提交任务

# 明天凌晨2点执行
at 02:00 tomorrow
/root/bak.sh
Ctrl+D

# 查看at任务列表
atq
# 删除序号1的任务
atrm 1

# ====================== 六、anacron 关机补执行定时任务 ======================
# crontab缺陷：服务器关机错过时间，任务直接放弃不执行
# anacron作用：开机后检查错过的日/周/月任务，自动补执行

# 配置文件路径
cat /etc/anacrontab
# 字段：周期天数 延迟分钟 任务ID 执行脚本
# 示例：1 5 cron.daily run-parts /etc/cron.daily
# 含义：每日任务，开机延迟5分钟自动执行错过的每日任务

# 适用场景：服务器经常开关机、个人测试机
# 注意：anacron只处理日/周/月周期任务，不处理分钟级crontab
```

---

### 模块6：磁盘存储与文件系统管理

**定位**：数据是企业核心资产，磁盘管理是运维的基本功

#### 核心知识点

- 磁盘基础：磁盘命名规则（`/dev/sda`）、MBR/GPT 分区表、机械盘/固态盘差异
- 分区与挂载：`fdisk/parted` 分区、`mkfs` 格式化、`mount` 临时挂载、`/etc/fstab` 永久挂载
- 文件系统：ext4/xfs 特性对比、文件系统修复 `fsck/xfs_repair`
- Swap 交换分区：作用、创建、启用关闭、生产优化建议
- **LVM 逻辑卷**：PV/VG/LV 三层结构、创建、在线扩容、缩容、快照
- RAID 磁盘阵列：RAID0/1/5/10 原理、性能与可靠性对比、适用场景、软 RAID 配置

#### 学习目标

能独立完成磁盘分区、格式化、挂载，熟练做 LVM 在线扩容，能根据业务选型 RAID 方案。

#### 磁盘基础：磁盘命名规则（`/dev/sda`）、MBR/GPT 分区表、机械盘/固态盘差异

```md
# ====================== 一、Linux磁盘设备命名规则 /dev/sda /dev/vda /dev/nvme ======================
# 1. SATA/USB机械/固态盘：/dev/sdX
# sd = SCSI disk，兼容SATA、USB移动硬盘
# 字母a/b/c：第1块盘sda，第2块sdb，依次排序
# 数字1/2/3：分区编号，主分区/扩展分区从1开始
# 示例：
ls /dev/sda          # 第一块SATA物理磁盘
ls /dev/sda1         # sda磁盘第一个分区
ls /dev/sdb3         # 第二块磁盘第三个分区

# 2. KVM云服务器虚拟磁盘：/dev/vdX
# virtio虚拟磁盘，阿里云/腾讯云ECS常用
ls /dev/vda
ls /dev/vda1

# 3. NVMe高速固态盘（M.2）：/dev/nvmeXnYpZ
# nvme0 = 第一块nvme控制器，n1=命名空间，p1=分区
ls /dev/nvme0n1
ls /dev/nvme0n1p1

# 4. 查看系统磁盘整体信息命令
lsblk                # 树形展示磁盘、分区、挂载点
fdisk -l             # 列出磁盘分区详情
df -h                # 查看已挂载分区使用率

# ====================== 二、两种分区表 MBR 与 GPT 对比 ======================
# 1. MBR 老式分区表（Master Boot Record）
# 限制1：磁盘最大支持 2TB
# 限制2：最多4个主分区；若需要更多，1个主分区改为扩展分区，内部划分逻辑分区
# 分区编号：主分区1-4，逻辑分区从5开始
# 存储位置：磁盘最前512字节，存放引导+分区表

# 2. GPT 现代分区表（GUID Partition Table）
# 优势1：支持单盘最大9.4ZB，无2TB限制
# 优势2：默认最多128个主分区，无需扩展/逻辑分区
# 优势3：分区表多份备份，损坏可恢复，自带CRC校验更安全
# 配套：必须搭配UEFI启动，服务器/新PC全盘推荐GPT

# 查看磁盘分区表类型
gdisk -l /dev/sda    # 识别GPT
fdisk -l /dev/sda    # 区分MBR/GPT标识

# ====================== 三、机械硬盘HDD vs 固态硬盘SSD 核心差异 ======================
# 1. 机械硬盘 HDD（Hard Disk Drive）
# 结构：磁头、盘片、电机，靠机械转动读写
# 优点：单价低、容量大、寿命长、数据恢复简单
# 缺点：
#  1）随机读写速度慢，寻道耗时高
#  2）震动、磕碰极易损坏盘片，怕摔
#  3）噪音大，功耗偏高
# 适用：数据归档备份、大容量存储服务器

# 2. 固态硬盘 SSD（Solid State Drive，含NVMe/M.2/SATA SSD）
# 结构：闪存芯片，无任何机械部件
# 优点：
#  1）随机读写极快，数据库、网站业务首选
#  2）防震抗摔，无噪音，低功耗
# 缺点：
#  1）有擦写寿命，大量高频写入会消耗寿命
#  2）同容量价格高于机械盘
# 适用：系统盘、数据库、高并发业务、云服务器本地盘

# 补充运维知识点：
# 数据库业务优先SSD，冷数据备份库用HDD；
# SSD不要频繁大量随机写入，定期监控磁盘磨损量
```

#### 分区与挂载：`fdisk/parted` 分区、`mkfs` 格式化、`mount` 临时挂载、`/etc/fstab` 永久挂载

```md
# ====================== 一、分区工具 fdisk(MBR) / parted(GPT/MBR通用) ======================
# 1. fdisk：仅支持MBR分区表，单盘≤2TB，适合老磁盘
fdisk /dev/sdb
# 交互常用指令：
# m 帮助；p 打印分区表；n 新建分区；d 删除分区；w 保存退出；q 放弃退出

# 2. parted：GPT/MBR都支持，支持2TB以上大磁盘，企业推荐
parted /dev/sdb
# 交互关键操作：
# print 查看分区；mklabel gpt 改为GPT分区表；mkpart 创建分区；rm 删除分区；quit 退出

# 分区完成后刷新内核识别分区（不重启生效）
partprobe /dev/sdb
# 或者
udevadm trigger

# 查看分区结果
lsblk /dev/sdb
fdisk -l /dev/sdb

# ====================== 二、mkfs 格式化分区，创建文件系统 ======================
# 主流文件系统：ext4(通用服务器)、xfs(CentOS7+默认)
# /dev/sdb1 为刚分出的分区
mkfs.xfs /dev/sdb1        # CentOS 默认XFS，不支持缩小扩容简单
mkfs.ext4 /dev/sdb1       # ext4 兼容广泛，支持缩小

# 格式化加标签，方便挂载识别
mkfs.xfs -L data_disk /dev/sdb1

# ====================== 三、mount 临时挂载（重启失效） ======================
# 格式 mount 设备路径 挂载目录
mkdir -p /data            # 先创建挂载点空目录
mount /dev/sdb1 /data

# 常用挂载参数
# ro 只读；rw 读写；noatime 不更新访问时间(减少磁盘写入，优化SSD)
mount -o rw,noatime /dev/sdb1 /data

# 查看当前所有挂载
mount
df -h

# 卸载分区（确保无程序读写该目录，否则umount失败）
umount /data
# 强制卸载（慎用，丢失未写入缓存）
umount -l /data

# ====================== 四、/etc/fstab 永久挂载（开机自动挂载） ======================
# fstab 每行标准6字段：设备 挂载点 文件系统 挂载参数 备份标记 自检优先级
# 字段说明：
# 1. 设备：/dev/sdb1 或 UUID=xxx（推荐UUID，磁盘顺序变化不影响）
# 2. 挂载目录：/data
# 3. 文件系统：xfs / ext4
# 4. 参数：defaults,rw,noatime  defaults等价rw,suid,dev,exec,auto,nouser,async
# 5. dump备份开关：0不备份
# 6. fsck自检优先级：0不自检，根分区1，其他分区2

# 1. 获取分区UUID（推荐用UUID写入fstab）
blkid /dev/sdb1

# 示例写入/etc/fstab
UUID="abc123-def4-5678-90gh-ijklmnopqrst"  /data  xfs  defaults,noatime  0 0

# 写完校验语法，出错会开机崩溃，必须执行！
mount -a
# mount -a 自动挂载fstab内所有未挂载设备，有报错直接提示

# ====================== 配套完整实操流程示例 ======================
# 1. 给新磁盘/dev/sdb分GPT分区
parted /dev/sdb mklabel gpt
parted /dev/sdb mkpart primary 0 100%
partprobe /dev/sdb
# 2. 格式化xfs
mkfs.xfs /dev/sdb1
# 3. 创建挂载目录
mkdir /data
# 4. 临时挂载测试
mount /dev/sdb1 /data
# 5. 查询UUID写入fstab永久挂载
blkid /dev/sdb1
echo 'UUID="xxxx" /data xfs defaults,noatime 0 0' >> /etc/fstab
# 6. 校验配置无错误
mount -a
df -h
```

#### 文件系统：ext4/xfs 特性对比、文件系统修复 `fsck/xfs_repair`

```md
# ====================== 一、ext4 与 XFS 核心特性对比 ======================
# 1.ext4 老一代通用文件系统（CentOS6、Ubuntu旧版、兼容Linux全版本）
# 优点：
# 1）支持文件系统缩小（resize2fs 可缩减分区容量）
# 2）日志完善，老旧硬件兼容性极好
# 3）碎片整理工具 e4defrag
# 缺点：
# 1）单文件最大 16TB，分区上限 1EiB，但超大容量性能衰减
# 2）并发写入、大文件、高并发场景性能弱于XFS
# 3）32000个子目录上限，海量小文件目录卡顿

# 2.XFS CentOS7/RHEL7+ 默认文件系统（企业服务器首选）
# 优点：
# 1）原生支持超大磁盘、单文件8EB，无容量瓶颈
# 2）海量小文件、并发读写、数据库场景性能更强
# 3）子目录数量无硬性上限，元数据操作高效
# 4）延迟分配、预写、条带优化，SSD/机械盘表现均衡
# 缺点：
# 1）**不支持缩小文件系统**，只能扩容不能缩容
# 2）老旧系统（CentOS6）原生不支持XFS，需额外装工具
# 3）碎片整理支持差，几乎无成熟缩容/碎片工具

# 适用场景总结
# ext4：测试机、小分区、需要后期缩容、老旧兼容环境
# XFS：生产服务器、数据库、大容量磁盘、高并发业务

# ====================== 二、文件系统扩容操作对比 ======================
# ext4 扩容流程
# 1.先扩容分区 2.刷新内核 3.resize2fs扩容文件系统
partprobe /dev/sdb1
resize2fs /dev/sdb1

# XFS 扩容流程（必须已挂载状态执行）
xfs_growfs /data

# ====================== 三、ext4 修复工具 fsck / e2fsck ======================
# 重要前提：修复时分区必须【卸载】，挂载状态修复会损坏数据
umount /dev/sdb1

# 基础检查，仅扫描不修复
fsck /dev/sdb1

# ext4专用修复 e2fsck
# -y 自动确认修复；-f 强制检查（正常干净盘默认跳过）
e2fsck -f /dev/sdb1
# 交互手动确认修复
e2fsck /dev/sdb1

# 修复完成后重新挂载
mount /dev/sdb1 /data

# 禁止操作：挂载中的分区直接执行fsck/e2fsck

# ====================== 四、XFS 文件系统修复 xfs_repair ======================
# 前提：同样必须卸载分区，不能挂载修复
umount /dev/sdb1

# 基础扫描检测损坏，不执行修复
xfs_repair -n /dev/sdb1

# 执行修复
xfs_repair /dev/sdb1

# 严重损坏，日志损坏强制修复
xfs_repair -L /dev/sdb1
# 警告：-L 清空日志，存在丢失文件风险，仅万不得已使用

# 修复完成挂载
mount /dev/sdb1 /data

# ====================== 五、通用排坑要点 ======================
# 1. 服务器异常断电、强制关机极易造成文件系统元数据损坏，开机触发自检
# 2. fsck/xfs_repair 都不能在挂载状态执行，会直接破坏文件
# 3. XFS 无法缩容，分区划分前提前规划容量
# 4. 修复前建议先备份分区数据，高危操作有丢文件风险
# 5. 开机自动修复配置写在/etc/fstab 第六列自检优先级
```

#### Swap 交换分区：作用、创建、启用关闭、生产优化建议

```md
# ====================== 一、Swap交换分区作用 ======================
# Swap 交换分区：硬盘上划出一块空间充当虚拟内存
# 1. 物理内存不足时，把内存中冷数据临时存入Swap，释放物理内存给活跃程序
# 2. 系统休眠功能依赖Swap，保存内存镜像
# 3. 弊端：磁盘速度远慢于内存，大量使用Swap会导致系统卡顿、业务响应变慢

# 适用场景：物理内存紧张、小内存服务器；大内存生产机尽量减少Swap依赖

# ====================== 二、两种创建Swap方式：分区swap / 文件swap ======================
## 方式1：独立磁盘分区创建swap（性能更好，企业推荐）
# 1. 用fdisk/parted分出独立分区，分区类型改为swap(82)
fdisk /dev/sdc
# 交互：n新建分区 → t修改类型 → 82(swap) → w保存
partprobe /dev/sdc1
# 2. 格式化swap分区
mkswap /dev/sdc1
# 3. 启用swap
swapon /dev/sdc1
# 4. 永久挂载写入/etc/fstab
# 字段示例：UUID=xxx swap swap defaults 0 0
blkid /dev/sdc1 >> /etc/fstab

## 方式2：swap文件（无需单独分区，灵活扩容，测试/云机器常用）
# 创建2G大小swap文件，bs块大小，count块数量
dd if=/dev/zero of=/swapfile bs=1G count=2
# 设置权限，防止普通用户篡改
chmod 600 /swapfile
# 格式化为swap
mkswap /swapfile
# 临时启用
swapon /swapfile
# 永久生效写入fstab
echo '/swapfile swap swap defaults 0 0' >> /etc/fstab

# ====================== 三、Swap启用、关闭、查看命令 ======================
# 查看全部swap设备
swapon -s
# 查看内存+swap整体使用
free -h

# 临时关闭单个swap
swapoff /swapfile
# 临时关闭所有swap
swapoff -a

# 启用fstab中全部swap
swapon -a

# ====================== 四、内核参数优化 swappiness / vfs_cache_pressure ======================
# 1. swappiness：控制系统使用Swap的倾向，取值0~100
# 值越小越尽量不使用swap；值越大越积极使用swap
# 数据库/高并发生产推荐 10~30；测试小内存机器默认60
cat /proc/sys/vm/swappiness
# 临时修改（重启失效）
sysctl vm.swappiness=10
# 永久修改
echo 'vm.swappiness=10' >> /etc/sysctl.conf
sysctl -p

# 2. vfs_cache_pressure：回收目录/文件缓存力度，默认100
# 调低(50)：尽量保留缓存，减少swap；数据库推荐50
sysctl vm.vfs_cache_pressure=50
echo 'vm.vfs_cache_pressure=50' >> /etc/sysctl.conf
sysctl -p

# ====================== 五、生产环境优化规范建议 ======================
# 1. Swap容量规划
# - 内存≤2G：Swap=内存*2
# - 2G<内存≤8G：Swap=内存大小
# - 8G<内存≤64G：Swap=4G~8G
# - 内存>64G：Swap分2G~4G应急即可，不建议过大

# 2. 性能优化
# - Swap分区优先放在SSD高速磁盘，禁止机械盘存放swap
# - 数据库、中间件服务器调低swappiness=10~30，避免频繁换页卡顿
# - 线上业务监控Swap使用率，若长期>30%说明物理内存不足，优先加内存而非扩容swap

# 3. 安全规范
# swap文件权限必须600，防止信息泄露
# 不建议线上业务依赖Swap，Swap仅作为内存耗尽兜底应急
```

#### **LVM 逻辑卷**：PV/VG/LV 三层结构、创建、在线扩容、缩容、快照

```md
# ====================== LVM三层结构概念 PV VG LV ======================
# PV Physical Volume 物理卷：底层磁盘/分区/dev/sdb1，打上LVM标签
# VG Volume Group 卷组：多个PV合并成一个资源池，统一管理存储空间
# LV Logical Volume 逻辑卷：从VG池中划分出来，可直接格式化挂载使用
# 层级关系：磁盘分区(PV) → 资源池(VG) → 业务分区(LV)
# 优势：支持在线扩容、快照、灵活调整分区大小；XFS不支持LV缩容，ext4可缩容

# ====================== 一、完整创建LVM流程 PV→VG→LV ======================
# 1. PV 创建（把分区初始化为物理卷）
pvcreate /dev/sdb1 /dev/sdc1
# 查看PV列表
pvdisplay
pvs

# 2. VG 创建，将多个PV加入卷组，命名vg_data
vgcreate vg_data /dev/sdb1 /dev/sdc1
# 查看卷组
vgdisplay
vgs

# 3. LV 创建，从vg_data划分100G逻辑卷lv_data
lvcreate -L 100G -n lv_data vg_data
# 查看逻辑卷
lvdisplay
lvs

# 4. 格式化（XFS/ext4二选一）
mkfs.xfs /dev/vg_data/lv_data
# mkfs.ext4 /dev/vg_data/lv_data

# 5. 挂载使用
mkdir /data
mount /dev/vg_data/lv_data /data
# 写入/etc/fstab永久挂载
echo '/dev/vg_data/lv_data /data xfs defaults 0 0' >> /etc/fstab
mount -a

# ====================== 二、VG扩容（新增磁盘加入资源池） ======================
# 新增磁盘分区/dev/sdd1初始化为PV
pvcreate /dev/sdd1
# 扩展vg_data卷组
vgextend vg_data /dev/sdd1
vgs # 查看VG总容量增加

# ====================== 三、LV在线扩容（业务不中断，生产高频操作） ======================
# 场景：VG有空闲空间，给lv_data扩容50G
lvextend -L +50G /dev/vg_data/lv_data

# 文件系统扩容（必须执行，分XFS/ext4两种命令）
# XFS（CentOS7+默认，需挂载状态执行）
xfs_growfs /data
# ext4
resize2fs /dev/vg_data/lv_data

# 一次性扩容到VG全部剩余空间
lvextend -l +100%FREE /dev/vg_data/lv_data
xfs_growfs /data

# ====================== 四、LV缩容（仅ext4支持，XFS无法缩容，高危操作） ======================
# 缩容流程：卸载 → 文件系统缩容 → LV缩容 → 重新挂载
# 1. 卸载
umount /data
# 2. 检查文件系统完整性
e2fsck -f /dev/vg_data/lv_data
# 3. ext4文件系统缩容到80G
resize2fs /dev/vg_data/lv_data 80G
# 4. LV逻辑卷缩容到80G
lvreduce -L 80G /dev/vg_data/lv_data
# 5. 重新挂载
mount /dev/vg_data/lv_data /data

# ====================== 五、LVM快照（数据备份，临时快照回滚） ======================
# 快照原理：复制LV元数据，写入时复制COW，仅占用变更数据空间
# 1. 创建快照，预留10G快照空间
lvcreate -s -L 10G -n lv_data_snap /dev/vg_data/lv_data
lvs # 查看快照

# 2. 挂载快照查看历史数据
mkdir /mnt/snap
mount /dev/vg_data/lv_data_snap /mnt/snap

# 3. 快照回滚（业务停机操作，卸载原LV与快照）
umount /data
umount /mnt/snap
lvconvert --merge /dev/vg_data/lv_data_snap
# 重新挂载，数据恢复到创建快照时状态
mount /data

# 4. 快照用完直接删除
lvremove /dev/vg_data/lv_data_snap

# ====================== 六、删除LVM整套流程（释放磁盘） ======================
# 1. 卸载LV
umount /data
# 2. 删除LV
lvremove /dev/vg_data/lv_data
# 3. 删除VG
vgremove vg_data
# 4. 清除PV标签
pvremove /dev/sdb1 /dev/sdc1 /dev/sdd1
```

#### RAID 磁盘阵列：RAID0/1/5/10 原理、性能与可靠性对比、适用场景、软 RAID 配置

```md
# ====================== 一、四种主流RAID原理、性能、可靠性、场景对比 ======================
# RAID0 条带卷（至少2块盘）
# 原理：数据拆分分散写入所有磁盘，无冗余备份
# 性能：读写速度最高，多盘并发叠加
# 可靠性：极差，任意一块盘损坏，全部数据丢失
# 可用容量：所有磁盘容量总和 sum
# 适用：临时缓存、对数据无保存需求、可重建的非核心业务

# RAID1 镜像卷（至少2块盘，偶数盘）
# 原理：两块盘写入完全相同副本，互为备份
# 性能：读性能优秀（双盘并行读），写性能普通（每份数据写两次）
# 可靠性：高，最多坏一块盘，数据不丢失
# 可用容量：总容量 = 单块盘容量，磁盘容量浪费50%
# 适用：系统盘、重要小数据、数据库日志盘，追求高可靠不看重容量

# RAID5 奇偶校验卷（至少3块盘）
# 原理：数据+校验位分散存储在不同磁盘，校验信息分布式存放
# 性能：读快，写偏弱（每次写入需同步更新校验）
# 可靠性：允许最多损坏1块盘；同时坏两块盘数据全部丢失
# 可用容量：总容量 = (磁盘总数-1) * 单盘容量，仅损耗1块盘容量做校验
# 适用：大容量存储、文件服务器、普通业务数据；不适合高频随机写入数据库
# 缺陷：重建压力极大，多块机械盘重建极易触发第二块盘损坏

# RAID10(1+0) 镜像+条带（至少4块盘，偶数盘）
# 原理：先两两做RAID1镜像，再多组镜像做RAID0条带
# 性能：读写性能都极强，接近RAID0速度
# 可靠性：每组镜像最多坏1块盘；同一组两块盘同时损坏则数据丢失
# 可用容量：总容量=总磁盘容量/2，浪费一半容量
# 适用：数据库、高并发业务、线上核心存储，企业生产首选均衡方案

# 速记对比总结
# 速度排序：RAID0 > RAID10 > RAID5 > RAID1
# 可靠性排序：RAID1 ≈ RAID10 > RAID5 > RAID0
# 空间利用率：RAID0 > RAID5 > RAID1=RAID10

# ====================== 二、软RAID mdadm 配置实操（Linux软件RAID） ======================
# 工具：mdadm，阵列设备文件 /dev/md0 /dev/md1
# 磁盘：/dev/sdb /dev/sdc /dev/sdd /dev/sde

# 1. 创建RAID0（2块盘 sdb+sdc）
mdadm -C /dev/md0 -l 0 -n 2 /dev/sdb /dev/sdc
# -C 创建阵列 -l 指定RAID级别 -n 磁盘数量

# 2. 创建RAID1（2块盘）
mdadm -C /dev/md1 -l 1 -n 2 /dev/sdb /dev/sdc

# 3. 创建RAID5（3块盘 sdb sdc sdd）
mdadm -C /dev/md5 -l 5 -n 3 /dev/sdb /dev/sdc /dev/sdd

# 4. 创建RAID10（4块盘 sdb sdc sdd sde）
mdadm -C /dev/md10 -l 10 -n 4 /dev/sdb /dev/sdc /dev/sdd /dev/sde

# 查看阵列状态
mdadm -D /dev/md0
cat /proc/mdstat

# 格式化阵列，挂载使用
mkfs.xfs /dev/md0
mkdir /raid0
mount /dev/md0 /raid0

# 保存阵列配置，开机自动组装RAID
mdadm -Ds >> /etc/mdadm.conf

# 写入/etc/fstab永久挂载
echo '/dev/md0 /raid0 xfs defaults 0 0' >> /etc/fstab
mount -a

# ====================== 三、软RAID故障磁盘替换流程 ======================
# 1. 标记故障盘（假设/dev/sdb损坏）
mdadm /dev/md10 -f /dev/sdb
# 2. 移除坏盘
mdadm /dev/md10 -r /dev/sdb
# 3. 插入新硬盘/dev/sdf，添加进阵列重建
mdadm /dev/md10 -a /dev/sdf
# 4. 查看重建进度
watch cat /proc/mdstat

# ====================== 四、删除软RAID（释放磁盘） ======================
umount /raid0
mdadm --stop /dev/md0
mdadm --zero-superblock /dev/sdb /dev/sdc
```

---

### 模块7：网络基础与防火墙

**定位**：运维一半的故障都和网络相关，网络能力直接决定排障效率

#### 核心知识点

1. 网络原理基础
   - OSI 七层模型、TCP/IP 四层模型、TCP 三次握手/四次挥手、UDP 协议、HTTP/HTTPS 基础
   - IP 地址、子网划分、网关、DNS、路由基础
2. 网络配置与排障
   - 网卡配置：`ip` 命令、网卡配置文件、静态 IP 设置、主机名修改
   - 排障工具：`ping/traceroute/mtr`、`ss/netstat`、`telnet/nc`、`curl/wget`、`tcpdump` 基础抓包
3. 防火墙体系
   - **netfilter/iptables**：四表五链原理、规则语法、过滤规则、NAT 地址转换、生产白名单配置
   - firewalld：区域概念、服务/端口配置、永久/运行时规则、与 iptables 的关系

#### 学习目标

能独立配置服务器网络，快速定位端口不通、网络超时等常见故障，能编写基础防火墙安全规则。

#### 网络原理基础

- OSI 七层模型、TCP/IP 四层模型、TCP 三次握手/四次挥手、UDP 协议、HTTP/HTTPS 基础
- IP 地址、子网划分、网关、DNS、路由基础

```md
# 一、分层模型（OSI七层 / TCP/IP四层）
## 1. OSI七层（理论标准，自上而下）
1. 应用层：提供用户程序接口（HTTP、FTP、DNS、SSH）
2. 表示层：数据加密、解密、编码、压缩（HTTPS加密在此层处理）
3. 会话层：建立/维持/断开应用会话
4. 传输层：端到端数据传输，TCP/UDP，端口区分程序
5. 网络层：跨主机寻址、路由转发（IP、ICMP）
6. 数据链路层：同一局域网传输，MAC地址、帧、交换机
7. 物理层：电/光信号、网线、光纤、网卡硬件

## 2. TCP/IP四层（Linux/互联网实际使用，合并简化OSI）
1. 应用层 = OSI 应用+表示+会话层：HTTP/HTTPS/DNS/FTP/SSH
2. 传输层：TCP、UDP，端口
3. 网际层（网络层）：IP、ICMP、路由、子网
4. 网络接口层（链路+物理）：MAC、网卡、交换机、网线

# 二、传输层 TCP / UDP
## TCP（可靠面向连接）
特点：连接、确认重传、流量控制、拥塞控制、有序、无丢失。
### 1. 三次握手（建立连接）
1. 客户端 → 服务端：SYN（请求连接，序列号seq=x）
2. 服务端 → 客户端：SYN+ACK（同意连接，ack=x+1，seq=y）
3. 客户端 → 服务端：ACK（ack=y+1）
目的：协商收发能力、同步序列号，防止失效旧连接干扰。

### 2. 四次挥手（断开连接，全双工，两端分别关闭发送通道）
1. 客户端发 FIN：我不再发数据
2. 服务端回 ACK：收到关闭请求，仍可发剩余数据
3. 服务端发 FIN：服务端数据发完，也要关闭
4. 客户端回 ACK：确认关闭，等待超时彻底释放端口

## UDP（无连接不可靠）
无握手、无重传、无拥塞控制，开销极小；
适用：直播、语音、DNS查询、游戏；丢包可容忍，追求低延迟。

# 三、应用层 HTTP / HTTPS
1. HTTP：明文传输，80端口，数据抓包可直接看到账号密码
2. HTTPS = HTTP + TLS加密，443端口；
   握手协商加密套件，传输数据密文，防窃听、篡改、中间人劫持。

# 四、IP地址、子网、网关、DNS、路由基础
## 1. IP地址
IPv4 32位，四段十进制 0~255；分为网络位+主机位。
分类：A/B/C/D/E，日常内网多使用C类 192.168.x.x、10.x.x.x、172.16~172.31.x.x 私网地址。

## 2. 子网划分 & 子网掩码
子网掩码区分网络位与主机位：
例：192.168.1.100/24 掩码 255.255.255.0
- /24：前24位网络位，剩余8位主机位，最多254台可用主机（网络地址、广播地址不可分配）
作用：隔离广播域，区分本地网段和跨网段流量。

## 3. 网关
不同网段通信的出入口；本机目标IP不在同子网，数据包全部发给网关转发。
内网主机网关一般为路由器/防火墙内网口IP。

## 4. DNS 域名解析
域名 ↔ IP 转换，UDP 53端口；
流程：客户端→本地DNS缓存→递归服务器→根域名服务器→顶级域→权威服务器，返回IP。

## 5. 路由基础
路由表决定数据包怎么走：
1. 直连路由：同网段，直接二层转发
2. 静态路由：手动配置目标网段+下一跳网关
3. 默认路由 0.0.0.0/0：所有不匹配明细路由的流量统一转发给默认网关
4. 动态路由：OSPF/RIP/BGP，设备自动学习网段


# 网络基础配套查询命令
# 1. 查看本机IP、网卡
ip a
ifconfig

# 2. 查看路由表
ip route
route -n

# 3. 测试连通性 ICMP
ping www.baidu.com

# 4. 追踪路由路径
traceroute www.baidu.com

# 5. DNS解析测试
nslookup www.baidu.com
dig www.baidu.com

# 6. 查看端口TCP/UDP监听
ss -tulnp
netstat -tulnp

# 7. 网关查看
ip route | grep default
```

#### 网络配置与排障

- 网卡配置：`ip` 命令、网卡配置文件、静态 IP 设置、主机名修改
- 排障工具：`ping/traceroute/mtr`、`ss/netstat`、`telnet/nc`、`curl/wget`、`tcpdump` 基础抓包

```md
# ====================== 一、网卡配置：ip命令、静态IP、主机名 ======================
# 1. ip 基础网卡操作（CentOS7+/Ubuntu通用，替代旧ifconfig）
ip a                          # 查看所有网卡、IP、MAC地址
ip link show eth0             # 单独查看eth0网卡状态
ip link set eth0 up           # 启用网卡
ip link set eth0 down         # 关闭网卡
ip addr add 192.168.1.100/24 dev eth0  # 临时配置静态IP（重启失效）
ip addr del 192.168.1.100/24 dev eth0   # 删除临时IP

# 临时添加网关
ip route add default via 192.168.1.1 dev eth0

# 2. CentOS/RHEL 网卡配置文件永久静态IP
# 文件路径：/etc/sysconfig/network-scripts/ifcfg-eth0
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
TYPE=Ethernet
BOOTPROTO=static       # static静态 / dhcp自动获取
NAME=eth0
DEVICE=eth0
ONBOOT=yes             # 开机自启网卡
IPADDR=192.168.1.100
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=223.5.5.5
DNS2=114.114.114.114
EOF
# 重启网卡生效
systemctl restart network
# 新版NetworkManager命令
nmcli c reload
nmcli c up eth0

# 3. 主机名修改
hostname                      # 查看当前主机名
hostname web01                # 临时修改，重启失效
hostnamectl set-hostname web01 # 永久修改（CentOS7+/Ubuntu）
cat /etc/hostname             # 主机名配置文件

# ====================== 二、连通性排障工具 ping traceroute mtr ======================
# ping ICMP连通性测试，测试三层网络可达
ping www.baidu.com
ping -c 4 192.168.1.1         # 仅发送4个包后停止

# traceroute 追踪数据包路由跳跃节点，定位断链节点
traceroute www.baidu.com

# mtr 整合ping+traceroute，实时看每一跳丢包、延迟，排障首选
mtr www.baidu.com

# ====================== 三、端口监听查看 ss / netstat ======================
# ss 效率更高，推荐替代netstat
ss -tulnp                     # tTCP uUDP l监听端口 n数字端口 p进程名PID
ss -ant                       # 查看所有TCP连接（含已建立连接）

# netstat 传统工具
netstat -tulnp
netstat -rn                   # 查看路由表

# ====================== 四、端口连通测试 telnet / nc ======================
# telnet 简单端口连通测试（仅TCP）
telnet 192.168.1.200 80

# nc 功能更强，TCP/UDP都支持，可收发数据
nc -zv 192.168.1.200 80       # 扫描80端口是否开放
nc -zv 192.168.1.200 80-90    # 批量扫描端口段

# ====================== 五、应用层测试 curl / wget ======================
# curl 测试HTTP/HTTPS服务，输出响应内容、状态码
curl www.baidu.com
curl -I www.baidu.com          # 仅返回响应头，查看200/404/502状态码
curl -v www.baidu.com          # -v 打印完整连接握手过程，排错详细日志

# wget 下载测试，验证网络访问
wget www.baidu.com -O /tmp/index.html

# ====================== 六、tcpdump 基础抓包（底层数据包分析） ======================
# 1. 抓取eth0网卡所有流量，保存到文件后续分析
tcpdump -i eth0 -w net.pcap

# 2. 只抓取80端口流量
tcpdump -i eth0 port 80

# 3. 抓取指定源IP数据包
tcpdump -i eth0 src 192.168.1.100

# 4. 抓取目标IP，打印详细内容
tcpdump -i eth0 dst 192.168.1.200 -nn

# 5. 读取抓包文件分析
tcpdump -r net.pcap

# 常用过滤条件组合示例
tcpdump -i eth0 host 192.168.1.100 and port 443
```

#### 防火墙体系

- **netfilter/iptables**：四表五链原理、规则语法、过滤规则、NAT 地址转换、生产白名单配置
- firewalld：区域概念、服务/端口配置、永久/运行时规则、与 iptables 的关系

```md
# ====================== 第一部分 netfilter/iptables 四表五链、规则、NAT、白名单 ======================
# 底层内核框架：netfilter；用户层管理工具：iptables
# 一、四表优先级（从高到低）：raw → mangle → nat → filter
# 1.filter 过滤表（默认，防火墙放行/拒绝）：INPUT OUTPUT FORWARD
# 2.nat 地址转换表：PREROUTING POSTROUTING OUTPUT
# 3.mangle 修改数据包标记、TTL、DSCP：全五条链都可用
# 4.raw 关闭连接跟踪，极少使用

# 二、五条链（数据包流经节点）
# 1.PREROUTING：数据包刚进网卡，路由判断前（DNAT在这里做）
# 2.INPUT：目标是本机进程的包
# 3.FORWARD：跨机器转发流量（网关/服务器转发）
# 4.OUTPUT：本机向外发出的包
# 5.POSTROUTING：数据包出网卡前（SNAT/MASQUERADE在这里做）

# 三、iptables 基础参数语法
# -A 追加规则 -I 插入头部 -D 删除 -L 查看 -F 清空 -P 设置默认策略
# -s 源IP -d 目标IP --sport 源端口 --dport 目标端口
# -j 动作：ACCEPT放行 DROP丢弃 REJECT拒绝返回提示 DNAT SNAT MASQUERADE

# 1.基础过滤规则示例（filter表）
# 查看filter表所有规则
iptables -L -n --line-number

# 默认策略：INPUT默认DROP（生产安全规范）
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# 放行本地回环lo网卡
iptables -A INPUT -i lo -j ACCEPT

# 放行已建立、相关连接（响应包自动通行）
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# 生产白名单：仅允许192.168.1.0/24访问22端口ssh
iptables -A INPUT -s 192.168.1.0/24 --dport 22 -j ACCEPT
# 放行80、443所有来源
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# 拒绝指定IP访问
iptables -A INPUT -s 10.0.0.100 -j DROP

# 2.NAT地址转换（nat表）
## SNAT 内网机器共享公网IP上网（固定公网IP）
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -j SNAT --to-source 203.0.113.10
## MASQUERADE 动态公网IP宽带（替代SNAT）
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth0 -j MASQUERADE
## DNAT 端口映射：公网203.0.113.10:8080转发内网192.168.1.10:80
iptables -t nat -A PREROUTING -d 203.0.113.10 --dport 8080 -j DNAT --to-destination 192.168.1.10:80

# 3.规则持久化（CentOS6/7区分）
# CentOS6 保存
service iptables save
# CentOS7+ 安装工具
yum install iptables-services
systemctl enable iptables
service iptables save

# ====================== 第二部分 firewalld 区域、端口/服务、永久规则、与iptables关系 ======================
# 关系：firewalld 是iptables上层封装工具，底层依旧调用netfilter/iptables，语法更简单
# 核心概念：zone区域，按可信程度划分流量，默认public
# 常用zone：trusted全部放行、internal内网、public公网、dmz隔离区、block全部拒绝

# 1.查看区域、默认区域
firewall-cmd --get-zones
firewall-cmd --get-default-zone

# 2.运行时规则（临时，重启失效）
# 放行80端口TCP
firewall-cmd --add-port=80/tcp
# 放行ssh服务
firewall-cmd --add-service=ssh
# 放行IP段访问
firewall-cmd --add-rich-rule='rule family=ipv4 source address=192.168.1.0/24 accept'

# 3.永久生效规则（加--permanent，重载才生效）
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --permanent --add-service=http
# 重载配置，永久规则加载
firewall-cmd --reload

# 4.端口转发DNAT（firewalld）
firewall-cmd --permanent --add-forward-port=port=8080:proto=tcp:toaddr=192.168.1.10:toport=80
firewall-cmd --reload

# 5.查看所有规则
firewall-cmd --list-all
# 关闭firewalld切换iptables
systemctl stop firewalld
systemctl disable firewalld
systemctl start iptables
systemctl enable iptables
```

---

### 模块8：软件包管理与基础服务部署

**定位**：运维日常核心工作，部署业务依赖的各类服务

#### 核心知识点

- RPM 包管理：`rpm` 命令、安装/查询/卸载、依赖问题处理
- **YUM/DNF**：原理、本地源/网络源配置、常用命令、分组安装
- Debian 系 APT：`apt` 命令、源配置
- 源码编译安装：编译三步骤（`configure/make/make install`）、优缺点、依赖解决
- 常用基础服务部署
  - NTP 时间同步服务
  - 系统 DNS 配置、BIND 基础
  - rsync 文件同步、inotify 实时同步
  - NFS 文件共享服务
  - FTP / Samba 服务

#### 学习目标

能通过三种方式安装软件，独立部署常用基础服务，能排查服务启动失败的常见问题。

#### RPM 包管理：`rpm` 命令、安装/查询/卸载、依赖问题处理

```md
# ====================== RPM 底层包管理工具 rpm 全套操作 ======================
# RPM包命名规范：软件名-版本-发布号.架构.rpm 例：nginx-1.20.1-9.el7.x86_64.rpm

# 一、rpm 安装、升级、覆盖安装
# -i 安装；-U 升级；-vh 可视化进度；--force 强制覆盖；--nodeps 忽略依赖（不推荐生产）
rpm -ivh nginx-1.20.1-9.el7.x86_64.rpm               # 普通安装本地rpm包
rpm -Uvh nginx-1.22.0-1.el7.x86_64.rpm               # 升级软件，不存在则直接安装
rpm -ivh --force nginx.rpm                           # 强制覆盖已安装文件（文件冲突时用）
rpm -ivh --nodeps nginx.rpm                          # 强制忽略依赖安装，极易导致程序无法运行

# 二、rpm 查询操作（-q 查询；-i详情；-l文件列表；-R依赖；-f文件归属包）
rpm -q nginx                                         # 查询软件是否已安装
rpm -qi nginx                                        # 查看软件详细信息：版本、发布人、说明
rpm -ql nginx                                        # 列出该rpm安装生成的所有文件路径
rpm -qc nginx                                        # 只列出软件配置文件
rpm -qd nginx                                        # 只列出帮助文档、手册
rpm -qR nginx                                        # 查看该软件依赖哪些库/程序
rpm -qf /usr/sbin/nginx                              # 根据系统文件反查所属rpm包

# 查询本地rpm安装包文件（未安装）
rpm -qip nginx.rpm                                   # 查看离线包详情
rpm -qlp nginx.rpm                                   # 查看离线包内部包含哪些文件

# 三、rpm 卸载软件
rpm -e nginx                                         # 正常卸载，有依赖会报错阻止
rpm -e --nodeps nginx                                # 强制卸载，无视依赖（谨慎使用，容易破坏其他程序）

# 四、依赖问题处理方案
# 1. rpm本身不自动解决依赖，离线环境会大量报缺失依赖
# 解决方式1：yum自动下载并补齐依赖（推荐线上服务器）
yum localinstall nginx.rpm
# 解决方式2：离线环境准备全套依赖rpm包，批量安装
rpm -ivh *.rpm
# 解决方式3：使用--nodeps仅临时测试，生产环境禁止长期使用，会出现运行崩溃

# 五、校验rpm文件完整性
rpm -V nginx                                         # 校验安装后文件是否被修改、删除、权限变更
# 输出结果有内容代表文件被篡改，空输出代表正常

# 六、常用组合实操示例
# 1. 离线安装并自动补依赖
yum localinstall /root/nginx-1.20.1-9.el7.x86_64.rpm -y
# 2. 查找系统中所有安装的http相关包
rpm -qa | grep http
# 3. 批量卸载过滤出的旧版本包
rpm -qa | grep nginx | xargs rpm -e --nodeps
```

#### **YUM/DNF**：原理、本地源/网络源配置、常用命令、分组安装

```md
# ====================== 一、YUM/DNF 原理 ======================
# YUM/DNF 是 RPM 上层包管理器，自动解析、下载、安装依赖，解决rpm依赖痛点
# 工作流程：读取repo源配置 → 下载元数据（包清单、依赖关系）→ 计算依赖链 → 批量下载安装rpm
# CentOS7 使用yum；CentOS8+/Rocky/AlmaLinux 使用dnf，dnf完全兼容yum语法，性能更强
# 源分类：网络公网源（阿里/163/官方）、本地光盘源、自建局域网私有源

# ====================== 二、YUM/DNF 仓库源配置 ======================
# 1. 源文件存放目录
ls /etc/yum.repos.d/
# 所有以 .repo 结尾文件为仓库配置，多文件并行生效

# 标准repo配置模板（阿里CentOS7网络源示例）
cat > /etc/yum.repos.d/CentOS-Aliyun.repo <<EOF
[base]                      # 仓库ID，唯一标识
name=CentOS-$releasever - Base - Aliyun  # 仓库名称描述
baseurl=https://mirrors.aliyun.com/centos/$releasever/os/$basearch/BaseOS/  # 包地址
gpgcheck=1                  # 开启rpm校验，防止篡改
gpgkey=https://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7  # 校验密钥
enabled=1                   # 1启用该仓库 0禁用
EOF

# 2. 本地光盘源（无外网服务器，挂载系统ISO镜像）
# 挂载ISO到/mnt/cdrom
mount /dev/cdrom /mnt/cdrom
# 编写本地repo
cat > /etc/yum.repos.d/local.repo <<EOF
[local]
name=Local ISO Source
baseurl=file:///mnt/cdrom
gpgcheck=0
enabled=1
EOF

# 3. 清理旧缓存、生成新元数据
yum clean all
yum makecache
# dnf 等价命令
dnf clean all
dnf makecache

# ====================== 三、YUM/DNF 高频基础命令 ======================
# 1. 搜索软件包
yum search nginx
dnf search nginx

# 2. 安装软件，-y自动确认
yum install nginx -y
dnf install nginx -y

# 3. 升级软件
yum update nginx -y          # 仅升级指定软件
yum update -y                # 全系统所有可更新包升级
dnf update -y

# 4. 卸载软件
yum remove nginx -y
dnf remove nginx -y

# 5. 查询已安装包、包详情
yum list installed | grep nginx
yum info nginx

# 6. 查看文件归属哪个包（替代rpm -qf）
yum provides /usr/bin/nginx
dnf provides /usr/bin/nginx

# 7. 下载rpm包不安装（离线备份依赖）
yum install --downloadonly --downloaddir=/tmp nginx

# 8. 查看仓库里所有可用包
yum list available

# 9. 历史操作记录，可回滚安装
yum history
yum history undo 10          # 撤销第10条yum操作

# ====================== 四、分组安装（开发工具、服务器套件批量安装） ======================
# 1. 查看所有可用软件组
yum grouplist
dnf grouplist

# 2. 查看某分组包含哪些软件
yum groupinfo "Development Tools"

# 3. 安装开发工具组（编译gcc/make等必备）
yum groupinstall "Development Tools" -y
dnf groupinstall "Development Tools" -y

# 4. 删除软件组
yum groupremove "Development Tools" -y

# ====================== 五、源管理辅助命令 ======================
# 临时禁用某仓库安装软件
yum install nginx --disablerepo=epel

# 只启用指定仓库安装
yum install nginx --enablerepo=epel

# 列出所有启用/禁用仓库
yum repolist all
```

#### Debian 系 APT：`apt` 命令、源配置

```md
# ====================== Debian/Ubuntu APT 包管理基础 ======================
# APT底层工具dpkg（对应RPM），apt自动处理依赖，CentOS yum等价工具
# dpkg：底层安装deb包，不会自动解决依赖
# apt / apt-get：上层工具，自动下载依赖、管理仓库

# ====================== 一、软件源配置文件 /etc/apt/sources.list ======================
# 源格式：deb 分发地址 版本代号 组件1 组件2
# 示例Ubuntu 22.04 阿里源模板
cat > /etc/apt/sources.list <<EOF
deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
EOF

# 字段说明
# deb        二进制程序包；deb-src 源码包
# jammy      Ubuntu版本代号（22.04=jammy，20.04=focal，Debian12=bookworm）
# main       官方免费开源软件
# restricted 专有驱动
# universe   社区维护软件
# multiverse 含版权受限软件

# 修改源后更新元数据缓存
apt update

# ====================== 二、apt 高频常用命令（推荐统一用apt，简化apt-get/apt-cache） ======================
# 1. 更新仓库元数据（必做，同步最新包列表）
apt update

# 2. 升级已安装软件（不删除旧依赖）
apt upgrade -y
# 完整系统升级，自动处理依赖增减（大版本更新用）
apt full-upgrade -y

# 3. 安装软件
apt install nginx -y
# 本地deb包安装，自动补依赖
apt install ./nginx_1.24.0-1ubuntu1_amd64.deb

# 4. 卸载软件
apt remove nginx -y          # 保留配置文件
apt purge nginx -y           # 彻底卸载+删除配置

# 5. 自动清理无用依赖包（卸载软件后残留依赖）
apt autoremove -y
# 清理下载缓存deb包
apt clean

# 6. 搜索软件
apt search nginx
# 查看软件详情
apt show nginx

# 7. 查询文件属于哪个包
apt-file find /usr/bin/nginx
# 先安装apt-file工具并更新缓存
apt install apt-file -y
apt-file update

# 8. 查看已安装包
apt list --installed | grep nginx
# 查看仓库可安装包
apt list --upgradable

# ====================== 三、底层 dpkg 命令（离线deb操作，无依赖自动修复） ======================
# 安装本地deb包
dpkg -i nginx.deb
# 修复dpkg安装缺失的依赖（dpkg报错后执行）
apt -f install -y

# 查询已安装包
dpkg -l | grep nginx
# 查看包内文件列表
dpkg -L nginx
# 根据文件反查包名
dpkg -S /usr/sbin/nginx
# 卸载包（保留配置）
dpkg -r nginx
# 彻底删除包+配置
dpkg -P nginx

# ====================== 四、额外实用APT操作 ======================
# 仅下载deb不安装
apt install --download-only nginx

# 锁定软件版本，禁止升级
apt-mark hold nginx
# 解除版本锁定
apt-mark unhold nginx

# 查看所有锁定包
apt-mark showhold
```

#### 源码编译安装：编译三步骤（`configure/make/make install`）、优缺点、依赖解决

```md
# ====================== 一、源码编译三步标准流程 configure → make → make install ======================
# 1. ./configure 配置检测
# 作用：检测系统环境、依赖库、编译器、路径；生成Makefile编译脚本
# 常用参数：
# --prefix=/usr/local/nginx  指定安装目录（必须指定，方便卸载、多版本共存）
# --with-xxx  开启附加模块；--without-xxx 禁用模块
# 示例nginx配置
./configure --prefix=/usr/local/nginx --with-http_ssl_module

# 2. make 编译
# 读取Makefile，调用gcc/g++编译源码生成二进制可执行程序
# -jN 多核编译加速，N=CPU核心数
make -j4

# 3. make install 安装
# 将编译好的程序、配置、手册复制到--prefix指定目录
make install

# ====================== 二、编译前依赖环境准备（必须先装编译工具链） ======================
# CentOS/RHEL(YUM)
yum groupinstall "Development Tools" -y
yum install openssl-devel pcre-devel zlib-devel -y

# Ubuntu/Debian(APT)
apt install build-essential libssl-dev libpcre3-dev zlib1g-dev -y

# 依赖报错处理：
# ./configure 提示 xxx library not found → 安装对应-devel/-dev开发库

# ====================== 三、完整实操示例：Nginx源码编译 ======================
# 1. 下载解压源码
wget https://nginx.org/download/nginx-1.26.1.tar.gz
tar zxf nginx-1.26.1.tar.gz
cd nginx-1.26.1

# 2. 配置编译参数
./configure --prefix=/usr/local/nginx --with-http_ssl_module

# 3. 多核编译
make -j4

# 4. 安装
make install

# 5. 快速使用（配置环境变量或软链接）
ln -s /usr/local/nginx/sbin/nginx /usr/local/bin/nginx
nginx -v

# ====================== 四、源码卸载（无内置uninstall，靠安装目录删除） ======================
# 方法1：删除--prefix安装目录
rm -rf /usr/local/nginx
# 方法2：编译目录执行（仅部分软件支持）
cd nginx-1.26.1
make uninstall

# ====================== 五、源码编译优缺点 ======================
# 优点：
# 1. 自定义编译模块，按需开启/关闭功能（包管理器无法自定义模块）
# 2. 自由指定安装路径，多版本软件共存不冲突
# 3. 获取最新版本，官方源软件版本普遍老旧
# 4. 深度优化编译参数，适配服务器硬件，性能更高
# 5. 无系统发行版限制，通用所有Linux

# 缺点：
# 1. 手动解决所有依赖，configure缺失库容易报错，门槛高
# 2. 无包管理器管理，无法yum/apt list查询、自动升级
# 3. 升级麻烦：需重新下载源码、重新编译覆盖安装
# 4. 卸载繁琐，无统一卸载命令，容易残留文件
# 5. 缺少服务单元文件，需手动写systemd管理开机自启

# ====================== 六、通用排坑要点 ======================
# 1. 报错 no acceptable C compiler found → 未安装gcc编译工具组
# 2. xxx.h: No such file or directory → 缺少对应开发库(-devel/-dev包)
# 3. make报错内存不足：降低-j参数，单线程make
# 4. 编译后命令找不到：未做软链接、未添加PATH环境变量
# 5. 多版本冲突：务必用--prefix隔离安装目录
```

#### 常用基础服务部署

- NTP 时间同步服务
- 系统 DNS 配置、BIND 基础
- rsync 文件同步、inotify 实时同步
- NFS 文件共享服务
- FTP / Samba 服务

```md
# ====================== 1. NTP 时间同步服务（chrony，CentOS7+/Ubuntu默认） ======================
# 作用：统一服务器系统时间，日志、数据库、集群时间必须一致
# CentOS/RHEL
yum install chrony -y
# Ubuntu/Debian
apt install chrony -y

# 编辑配置 /etc/chrony.conf
# 阿里NTP源
server ntp.aliyun.com iburst
server ntp1.aliyun.com iburst

# 启动开机自启
systemctl start chronyd
systemctl enable chronyd

# 查看同步状态
chronyc sources
chronyc tracking
# 手动强制同步
chronyc makestep

# 客户端同步命令（临时同步）
ntpdate ntp.aliyun.com

# ====================== 2. DNS 系统配置 + BIND 简易DNS服务器 ======================
## 2.1 本机DNS客户端配置
# 临时修改DNS（重启网卡失效）
echo "nameserver 223.5.5.5" > /etc/resolv.conf

# CentOS永久配置网卡DNS /etc/sysconfig/network-scripts/ifcfg-eth0
DNS1=223.5.5.5
DNS2=114.114.114.114
systemctl restart network

# Ubuntu /etc/netplan/ 或 /etc/systemd/resolved.conf

## 2.2 BIND 自建DNS解析服务
yum install bind bind-chroot -y
# 主配置 /etc/named.conf
# 允许内网查询
allow-query { 192.168.1.0/24; };
# 正向区域配置 /etc/named/zones/demo.zone
# 格式 A记录：www IN A 192.168.1.10

# 校验配置
named-checkconf
# 校验区域文件
named-checkzone demo.com /etc/named/zones/demo.zone

systemctl start named
systemctl enable named

# 测试解析
nslookup www.demo.com 127.0.0.1
dig www.demo.com @127.0.0.1

# ====================== 3. rsync 增量同步 + inotify 实时同步 ======================
## 3.1 rsync 基础增量同步（只传变更文件，压缩、删除冗余）
# 本地同步
rsync -avz /data/ /backup/
# 远程推送（ssh协议）
rsync -avz /data/ root@192.168.1.20:/data/
# --delete 删除目标端源不存在文件（镜像同步）
rsync -avz --delete /data/ root@192.168.1.20:/data/

# rsync服务端模式（后台监听端口873）
# 配置 /etc/rsyncd.conf
[data]
path=/data
read only=no
auth users=rsyncuser
secrets file=/etc/rsync.pass
# 客户端带密码文件同步
rsync -avz --password-file=/etc/rsync.client.pass /data/ rsyncuser@192.168.1.20::data

## 3.2 inotify 实时同步（监控目录变动，触发rsync）
yum install inotify-tools -y
# 监控脚本示例
inotifywait -mrq --timefmt '%Y-%m-%d %H:%M:%S' --format '%w%f %e' /data \
| while read file event; do
  rsync -avz --delete /data/ root@192.168.1.20:/data/
done
# 参数：m持续监控 r递归 q精简输出

# ====================== 4. NFS 局域网文件共享（Linux之间共享目录） ======================
# 服务端安装
yum install nfs-utils rpcbind -y
# 共享配置 /etc/exports
# /data  192.168.1.0/24(rw,sync,no_root_squash)
# rw读写 sync同步写入 no_root_squash客户端root保留权限

# 生效配置
exportfs -r
# 查看共享列表
exportfs -v

systemctl start rpcbind nfs-server
systemctl enable rpcbind nfs-server

# 客户端挂载
mount -t nfs 192.168.1.10:/data /mnt/nfs
# 永久挂载写入/etc/fstab
192.168.1.10:/data  /mnt/nfs  nfs defaults 0 0

# 查看远程共享
showmount -e 192.168.1.10

# ====================== 5. FTP vs Samba ======================
## 5.1 vsftpd FTP（跨系统文件传输，21端口）
yum install vsftpd -y
# 配置 /etc/vsftpd.conf
anonymous_enable=NO       # 关闭匿名用户
local_enable=YES          # 允许本地系统用户登录
write_enable=YES          # 上传写入权限

systemctl start vsftpd
systemctl enable vsftpd

# 客户端测试
ftp 192.168.1.10
lftp 192.168.1.10

## 5.2 Samba（Windows<->Linux文件共享、网上邻居）
yum install samba samba-client -y
# 配置 /etc/samba/smb.conf
[share]
path = /data
browseable = yes
writable = yes
valid users = smbuser

# 创建独立samba密码（系统用户必须存在）
useradd smbuser
smbpasswd -a smbuser

# 校验配置
testparm
systemctl start smb nmb
systemctl enable smb nmb

# Linux客户端挂载samba
mount -t cifs //192.168.1.10/share /mnt/smb -o username=smbuser,password=123456
# Windows直接访问 \\192.168.1.10\share


# 服务用途速记
1. **chrony(NTP)**：集群时间统一，日志、数据库依赖
2. **DNS**：域名转IP；BIND自建内网私有域名解析
3. **rsync**：定时增量备份；inotify+rsync实现数据实时同步
4. **NFS**：Linux集群内部高速文件共享，无Windows兼容
5. **vsftpd(FTP)**：通用跨平台文件上传下载
6. **Samba**：Windows与Linux互通共享目录、网上邻居访问
```

---

### 模块9：Shell 脚本编程（初级→中级的核心门槛）

**定位**：运维核心硬技能，实现自动化的基础，面试必考

#### 核心知识点

- 脚本基础：脚本格式、三种执行方式、变量分类（环境变量、局部变量、位置变量、特殊变量）
- 特殊变量：`$? $# $@ $* $$`，重点区分 `$@` 与 `$*` 的差异
- 运算符：算术运算、整数比较、字符串比较、逻辑运算
- 条件判断：`if/elif/else`、`case` 多分支、`test/[ ]/[[ ]]`、正则匹配 `=~`
- 循环结构：`for` 循环、`while` 循环、`while read` 逐行读取、管道子 Shell 变量失效问题与解决方案
- 函数：定义、传参、`return` 状态码、返回字符串的两种方式、`local` 局部变量
- 数组：索引数组、关联数组（`declare -A`）、遍历、片段截取、批量替换
- 生产规范：注释规范、退出状态码、错误处理、`set -euo pipefail`、日志函数封装

#### 学习目标

能独立编写系统巡检、数据备份、日志清理、批量处理类生产脚本，代码规范、可维护。

#### 脚本基础：脚本格式、三种执行方式、变量分类（环境变量、局部变量、位置变量、特殊变量）

```md
# ====================== 一、Shell脚本基础格式规范 ======================
# 1. 首行解释器声明（必须放在文件第一行，指定用bash解析脚本）
#!/bin/bash
# 注释：# 单行注释，无多行注释符号

# 2. 标准格式示例 demo.sh
#!/bin/bash
# Author: test
# Desc: shell变量演示脚本
echo "脚本运行测试"

# 3. 脚本权限
chmod +x demo.sh

# ====================== 二、三种脚本执行方式（区别） ======================
# 方式1：绝对/相对路径执行（新开子shell运行，推荐标准用法）
./demo.sh
/usr/local/bin/demo.sh
# 特点：会读取#!/bin/bash，拥有独立子进程环境，变量不污染当前终端

# 方式2：bash/sh 直接解释运行（新开子shell，无需执行权限）
bash demo.sh
sh demo.sh
# 特点：忽略首行#!/，直接用当前bash/sh解释，不用chmod +x

# 方式3：source / . 点加载（当前终端shell直接执行，不创建子进程）
source demo.sh
. demo.sh
# 特点：脚本内变量、函数直接留在当前终端；修改环境变量永久生效；适合加载配置

# ====================== 三、四大类变量详解 ======================
## 1. 环境变量（全局，所有子shell继承）
# 查看全部环境变量
env
printenv

# 常用内置环境变量
echo $PATH        # 命令搜索路径
echo $HOME        # 当前用户家目录
echo $USER        # 当前登录用户名
echo $PWD         # 当前工作目录
echo $SHELL       # 默认解释器

# 自定义环境变量（export导出后子shell可见）
export APP_NAME="nginx"
bash              # 新开子shell
echo $APP_NAME    # 能读取到

## 2. 局部变量（脚本/函数内部，仅当前shell生效，子shell不可见）
name="test"
echo $name

# 函数局部变量：local 仅限函数内部
func_test(){
  local num=10
  echo $num
}
func_test
echo $num   # 外部无法输出，空值

## 3. 位置变量（执行脚本时传入的参数 $1 $2 $3 ...）
# 执行示例：./demo.sh aaa bbb 999
echo "第一个参数：$1"
echo "第二个参数：$2"
echo "第三个参数：$3"

# $0：脚本自身文件名
echo "脚本名称：$0"

# 超过9个参数用大括号 ${10}
echo "第十个参数：${10}"

## 4. 特殊内置变量（脚本运行状态专用）
./demo.sh 11 22 33
echo $#      # 传入参数总个数 输出3
echo $@      # 所有参数整体分开输出 "11" "22" "33"（循环遍历推荐）
echo $*      # 所有参数合并为一整个字符串 "11 22 33"
echo $$      # 当前脚本进程PID
echo $!      # 上一个后台程序PID
echo $?      # 上一条命令退出状态码 0=成功 非0=失败

# ====================== 补充变量操作语法 ======================
# 1. 变量赋值无空格：name="abc" 禁止 name = "abc"
# 2. 调用变量加$，复杂场景加大括号区分边界 ${name}_log
log="app"
echo ${log}_run.log

# 3. 只读变量
readonly VERSION="1.0"
# VERSION="2.0"  # 报错不可修改

### 核心区分速记
1. 环境变量：export导出，全局父子shell共享
2. 局部变量：函数内local/脚本普通变量，子shell看不见
3. 位置变量：$1 $2 执行脚本跟的参数
4. 特殊变量：$# $@ $$ $? 脚本运行状态专用
5. 执行方式核心差异：
   - ./bash / bash xxx.sh：子shell，变量执行完消失
   - source / . xxx.sh：当前终端执行，变量留存
```

#### 特殊变量：`$? $# $@ $* $$`，重点区分 `$@` 与 `$*` 的差异

```md
# 一、逐个讲解特殊变量 $? $# $@ $* $$
# 1. $$ ：当前脚本运行的 PID 进程号
echo "当前脚本PID：$$"

# 2. $# ：传入脚本的位置参数总个数
# 执行示例：./test.sh aa bb cc
echo "参数总数量：$#"

# 3. $? ：上一条命令的退出状态码
# 返回 0 = 执行成功；非0 = 执行失败
ls /tmp
echo "ls命令执行结果码：$?"
ls /nonexist_dir
echo "访问不存在目录的结果码：$?"

# 4. $@ 与 $* ：两者都代表全部传入参数，核心差异在引号包裹后
# 无引号时：$@ 和 $* 行为完全一致，都会按空格分割所有参数
# 双引号包裹后：
# "$@" ：每个参数独立保留原始边界，视为独立数组元素（推荐循环使用）
# "$*" ：所有参数合并成**单个完整字符串**，中间用IFS分隔（默认空格）

# ====================== 二、实操对比 $@ 和 $* ======================
# 测试用例：带空格的参数，制造区分度
# 执行脚本命令：./test.sh "hello world" 666 test

echo "===== 遍历 \"\$@\" ====="
for arg in "$@"
do
  echo "参数：[$arg]"
done
# 输出结果：
# 参数：[hello world]
# 参数：[666]
# 参数：[test]
# 每个带空格参数完整保留，不会拆分，业务循环首选 "$@"

echo -e "\n===== 遍历 \"\$*\" ====="
for arg in "$*"
do
  echo "参数：[$arg]"
done
# 输出结果：
# 参数：[hello world 666 test]
# 全部参数揉成一条字符串，循环只会执行1次

echo -e "\n===== 无引号 $@ / $* 无区别 ====="
echo "无引号\$@：" $@
echo "无引号\$*：" $*
# 都会自动按空格切割，"hello world" 拆成 hello 和 world 两个元素

# ====================== 三、使用总结 ======================
# 1. $$ ：脚本PID，常用于生成临时文件 /tmp/log.$$
# 2. $# ：判断脚本是否传入参数，if [ $# -lt 1 ];then 提示缺少参数;fi
# 3. $? ：判断命令执行是否成功，做流程分支判断
# 4. "$@" ：遍历脚本参数标准写法，保留参数原始空格，生产脚本通用
# 5. "$*" ：极少使用，仅需要把所有参数拼接成一整串文本时才用


### 极简背诵版
1. $$ = 当前脚本PID
2. $# = 参数总数
3. $? = 上条命令返回码（0成功）
4. "$@"：参数各自独立，循环遍历首选
5. "$*"：所有参数合并成一条字符串
```

#### 运算符：算术运算、整数比较、字符串比较、逻辑运算

```md
# ====================== 一、算术运算（仅支持整数，小数用bc） ======================
# 写法1：$(( )) 推荐
a=10
b=3
echo $((a + b))   # 加 13
echo $((a - b))   # 减 7
echo $((a * b))   # 乘 30
echo $((a / b))   # 整除 3
echo $((a % b))   # 取余 1
echo $((a ** b))  # 幂运算 1000

# 写法2：expr （符号前后必须空格）
expr $a + $b

# 自增自减
i=1
echo $((i++)) # 先取值再加
echo $((++i)) # 先加再取值

# 小数计算借助bc
echo "scale=2; 10 / 3" | bc

# ====================== 二、整数比较 语法 [ 数字 操作符 数字 ] ======================
# -eq 等于  -ne 不等于
# -gt 大于  -ge 大于等于
# -lt 小于  -le 小于等于
x=8
if [ $x -gt 5 ]; then
  echo "x大于5"
fi

# (( )) 双括号可直接用 > < == 更直观
if (( x < 10 )); then
  echo "x小于10"
fi

# ====================== 三、字符串比较 [ 字符串 操作符 字符串 ] ======================
str1="abc"
str2="def"
# = 相等；!= 不等
if [ "$str1" = "$str2" ]; then
  echo "相等"
else
  echo "不相等"
fi

# -z 字符串长度为0（空）
if [ -z "$str1" ]; then
  echo "字符串为空"
fi
# -n 字符串非空
if [ -n "$str1" ]; then
  echo "字符串不为空"
fi

# 注意：变量必须双引号包裹，防止空变量语法报错

# ====================== 四、逻辑运算（与/或/非） ======================
# 1. 单括号 [ ] 逻辑符：-a 与  -o 或  ! 非
num=6
if [ $num -gt 2 -a $num -lt 10 ]; then
  echo "2<num<10"
fi

# 2. 双括号 (( )) / 双方括号 [[ ]] ：&& 与  || 或  ! 非
if [[ $num -gt 2 && $num -lt 10 ]]; then
  echo "区间成立"
fi

# 短路逻辑：&& 前面成功才执行后面；|| 前面失败才执行后面
ls /tmp && echo "目录存在"
ls /xxx || echo "目录不存在"

# ====================== 补充文件测试运算符（常用） ======================
# -f 是否普通文件；-d 是否目录；-e 文件存在；-r可读 -w可写 -x可执行
if [ -f "/etc/hosts" ]; then
  echo "hosts文件存在"
fi


## 速记汇总

1. **算术**：$((a+b)) 整数；bc 小数
2. **整数对比**：-eq/-gt/-lt 单括号；(( a > b )) 双括号
3. **字符串**：= != -z -n，变量必加双引号
4. **逻辑**
   - `[ ]`：-a -o !
   - `[[ ]]/(( ))`：`&& || !`（推荐，语法更通用）
   - 短路：`&&`成功后置执行，`||`失败后置执行
```

#### 条件判断：`if/elif/else`、`case` 多分支、`test/[ ]/[[ ]]`、正则匹配 `=~`

```md
# ====================== 一、if elif else 条件判断语法 ======================
# 基础格式
if 条件; then
  语句
elif 条件2; then
  语句2
else
  其他语句
fi

# 示例：判断数字大小
num=18
if (( num > 20 )); then
  echo "大于20"
elif (( num == 18 )); then
  echo "等于18"
else
  echo "小于20且不等于18"
fi

# ====================== 二、三种条件测试：test / [] / [[]] ======================
# 1. test 等价于单中括号 [ ]
test "$name" = "test"
[ "$name" = "test" ]

# 单括号限制：不支持正则、&&||要写-a/-o、空格严格、变量空容易报错
# 2. [[ ]] 双方括号（推荐生产脚本）
# 优势：支持 =~ 正则、直接 && ||、自动处理空变量、通配符匹配
str="hello123"
if [[ $str == hello* ]]; then
  echo "以hello开头"
fi

# ====================== 三、[[ ]] 正则匹配 =~ ======================
# 语法：[[ 变量 =~ 正则表达式 ]]
# 注意：正则不要加引号，否则变成纯字符串匹配
phone="13812345678"
# 判断手机号1开头，第二位3-9，后面9位数字
if [[ $phone =~ ^1[3-9][0-9]{9}$ ]]; then
  echo "手机号格式正确"
else
  echo "手机号非法"
fi

# 匹配数字
val="999"
if [[ $val =~ ^[0-9]+$ ]]; then
  echo "纯数字"
fi

# ====================== 四、case 多分支匹配（适合固定选项） ======================
# 语法：case 变量 in 模式) 语句 ;; esac
read -p "输入操作(start/stop/restart):" opt
case $opt in
start)
  echo "执行启动服务"
  ;;
stop)
  echo "执行停止服务"
  ;;
restart)
  echo "重启服务"
  ;;
*) # 匹配其他所有值
  echo "输入参数错误"
  ;;
esac

# case支持通配符
case $1 in
*.log) echo "日志文件" ;;
*.txt) echo "文本文件" ;;
esac

# ====================== 完整综合示例 ======================
#!/bin/bash
read -p "请输入数字：" n
# 判断是否纯数字
if [[ ! $n =~ ^[0-9]+$ ]]; then
  echo "输入不是整数"
  exit 1
fi

if (( n > 100 )); then
  echo "数字大于100"
elif (( n == 50 )); then
  echo "数字等于50"
else
  echo "小于100且不等于50"
fi

# case分支判断区间简化写法
case $n in
[1-9]) echo "个位数" ;;
[1-9][0-9]) echo "两位数" ;;
*) echo "三位数及以上" ;;
esac


## 核心区分速记
1. `test` / `[ ]`：基础判断，无正则，逻辑用 `-a -o`
2. `[[ ]]`：推荐，原生支持 `&& ||`、通配符、正则 `=~`，容错更强
3. `if/elif/else`：灵活多条件复杂逻辑
4. `case`：固定枚举、通配符匹配，简洁分支
5. 正则 `=~` 仅 `[[ ]]` 可用，正则表达式不能加双引号
```

#### 循环结构：`for` 循环、`while` 循环、`while read` 逐行读取、管道子 Shell 变量失效问题与解决方案

```md
# ====================== 一、for 循环两种写法 ======================
# 写法1：遍历列表（字符串、参数、文件）
for file in /etc/*.conf
do
  echo "配置文件：$file"
done

# 遍历脚本所有参数 "$@"
for arg in "$@"
do
  echo "参数：$arg"
done

# 写法2：C语言风格数字循环 $((;;))
for ((i=1; i<=5; i++))
do
  echo "数字 $i"
done

# 循环控制关键字
# break 跳出整个循环；continue 跳过本次，直接下一轮

# ====================== 二、while 基础循环 ======================
# 1. 条件循环
i=1
while (( i <= 3 ))
do
  echo "i=$i"
  ((i++))
done

# 2. 无限死循环
while true
do
  sleep 1
  echo "循环运行中"
done

# ====================== 三、while read 逐行读取文件（生产高频） ======================
# 标准安全读取，保留空格、空行，不会丢失内容
# 语法：while IFS= read -r line; do ... done < 文件
# IFS= 关闭行分割，保留行首尾空格；-r 禁止反斜杠转义
cat > test.txt <<EOF
line one
  line two 带空格
line3
EOF

# 正确逐行读取
while IFS= read -r line
do
  echo "行内容：|$line|"
done < test.txt

# 读取命令输出
ls -l /etc | while IFS= read -r row
do
  echo "$row"
done

# ====================== 四、管道导致子Shell变量失效问题（核心坑） ======================
# 问题原理：管道 | 会新开子shell，子shell内部修改的变量无法传回父shell
count=0
# 管道左边输出，右边while在子shell，count修改失效
cat test.txt | while IFS= read -r line
do
  ((count++))
done
echo "行数：$count" # 输出0，变量丢失！

# 三种解决方案
## 方案1：输入重定向替代管道（最优推荐）
count=0
while IFS= read -r line
do
  ((count++))
done < test.txt
echo "行数：$count" # 正常输出行数

## 方案2：进程替换 <(cmd)，不创建子shell
count=0
while IFS= read -r line
do
  ((count++))
done < <(cat test.txt)
echo "行数：$count"

## 方案3：把后续逻辑全部放进子shell，内部处理结果（不推荐复杂场景）
count=0
cat test.txt | {
  while IFS= read -r line
  do
    ((count++))
  done
  echo "内部行数：$count"
}

# ====================== 补充 until 循环（条件不成立才执行） ======================
i=1
until ((i>3))
do
  echo "until i=$i"
  ((i++))
done


# 核心知识点速记

1. for 两种：列表遍历 / C风格数字循环；break/continue控制流程
2. while read 标准模板：`while IFS= read -r line; do ... done < file`
3. 管道 `|` 产生子shell，循环内修改父变量会失效
4. 解决管道变量丢失优先用：输入重定向 `< 文件` 或进程替换 `<(命令)`
```

#### 函数：定义、传参、`return` 状态码、返回字符串的两种方式、`local` 局部变量

```md
# ====================== 一、函数两种定义格式 ======================
# 格式1：函数名() { 函数体 }（通用兼容所有shell）
func1() {
  echo "普通函数"
}

# 格式2：function 函数名 { 函数体 }（bash专属）
function func2 {
  echo "function关键字函数"
}

# 调用函数：直接写函数名，不用括号
func1
func2

# ====================== 二、函数传参（使用位置变量 $1 $2 $@ $#） ======================
test_arg() {
  echo "第一个参数：$1"
  echo "第二个参数：$2"
  echo "参数总数：$#"
  echo "全部参数：$@"
}
# 调用时空格后跟参数
test_arg apple banana orange

# ====================== 三、return 返回状态码（只能0~255整数，不能传字符串） ======================
# return 作用：返回命令执行退出码 $?，0成功，非0失败
check_num() {
  if (( $1 > 10 )); then
    return 0 # 成功
  else
    return 1 # 失败
  fi
}

check_num 15
echo "返回码：$?" # 输出0
check_num 5
echo "返回码：$?"  # 输出1

# ====================== 四、函数返回字符串/大数据两种标准方式 ======================
## 方式1：echo 标准输出捕获（最常用）
get_name() {
  echo "zhangsan"
}
# 用 $() 捕获函数输出赋值变量
res=$(get_name)
echo "函数返回字符串：$res"

## 方式2：全局变量传值（适合大量数据，无子shell开销）
out=""
get_msg() {
  out="hello world 123"
}
get_msg
echo "全局变量接收：$out"

# 注意：不能用 return "字符串"，会报语法错误，return仅支持0-255数字

# ====================== 五、local 局部变量（仅函数内部生效，隔离全局变量） ======================
# 不加local=全局变量；加local=仅当前函数内部有效
local_demo() {
  local a=100  # 局部变量
  b=200        # 全局变量
  echo "函数内部 a=$a b=$b"
}
local_demo
echo "函数外部 a=$a b=$b"
# 输出：a=  b=200，局部变量a外部不存在

# ====================== 综合完整示例 ======================
#!/bin/bash
# 计算两数之和，返回字符串结果；return判断是否合法
calc() {
  local n1=$1
  local n2=$2
  # 判断是否纯数字
  if [[ ! $n1 =~ ^[0-9]+$ || ! $n2 =~ ^[0-9]+$ ]]; then
    return 1 # 参数非法
  fi
  local sum=$((n1 + n2))
  echo "$sum"
  return 0
}

ret=$(calc 10 20)
code=$?
if (( code == 0 )); then
  echo "计算结果：$ret"
else
  echo "参数不是数字"
fi


## 核心速记
1. 定义：`func(){}` / `function func{}`，调用直接写函数名
2. 传参：函数后空格跟值，内部用 `$1 $2 $# $@`
3. `return`：仅返回0~255数字状态码，存于 `$?`，不能返回文字
4. 返回字符串：
   - 方案A：`echo` 输出 + `res=$(func)` 捕获（推荐）
   - 方案B：修改全局变量传值
5. `local`：函数内定义局部变量，外部不可访问，避免全局污染
```

#### 数组：索引数组、关联数组（`declare -A`）、遍历、片段截取、批量替换

```md
# ====================== 一、索引数组（数字下标，默认从0开始） ======================
# 1. 定义索引数组
arr=("apple" "banana" "orange" "grape")
# 单独赋值指定下标
arr[5]="pear"

# 2. 读取单个元素
echo ${arr[0]}       # 第0个：apple
echo ${arr[5]}       # pear
echo ${arr[-1]}      # 倒数第一个元素 grape

# 3. 读取全部元素
echo ${arr[@]}
echo ${arr[*]}

# 4. 数组长度
echo "数组元素总数：${#arr[@]}"

# ====================== 二、关联数组（key-value，字符串下标，必须 declare -A） ======================
# 声明关联数组（bash4+支持）
declare -A info
# 批量赋值
info=(
  ["name"]="zhangsan"
  ["age"]=20
  ["addr"]="Beijing"
)
# 单独赋值
info["job"]="ops"

# 取值
echo ${info["name"]}
echo ${info["job"]}

# 遍历所有key / 所有value
echo "所有键：${!info[@]}"
echo "所有值：${info[@]}"

# ====================== 三、数组遍历（索引/关联通用写法） ======================
## 1. 索引数组遍历
fruit=("a" "b" "c")
# 方式1：遍历值
for val in "${fruit[@]}"; do
  echo "$val"
done
# 方式2：带下标遍历
for i in "${!fruit[@]}"; do
  echo "下标$i 值: ${fruit[$i]}"
done

## 2. 关联数组遍历key+value
for k in "${!info[@]}"; do
  echo "key=$k val=${info[$k]}"
done

# ====================== 四、数组片段截取 ${arr[@]:起始:长度} ======================
nums=(10 20 30 40 50 60)
# 从下标1开始，取2个元素
echo ${nums[@]:1:2}    # 20 30
# 从下标2取到末尾（省略长度）
echo ${nums[@]:2}      # 30 40 50 60

# ====================== 五、数组元素批量替换（全局字符串替换） ======================
files=("test.log" "run.log" "err.txt" "nginx.log")
# 格式：${数组[@]/旧字符串/新字符串}
# 只替换第一个匹配
echo ${files[@]/log/txt}
# 全部全局替换（双斜杠 //）
echo ${files[@]//log/txt}

# 替换并生成新数组
new_files=("${files[@]//log/txt}")
echo ${new_files[@]}

# ====================== 六、数组常用操作补充 ======================
# 追加元素
arr+=("watermelon")

# 删除单个元素（unset）
unset arr[2]
# 删除整个数组
unset arr

# 判断数组是否包含元素
target="banana"
if [[ " ${arr[@]} " =~ " $target " ]]; then
  echo "存在 $target"
fi


# 核心速记
1. **索引数组**：数字下标，直接 `arr=()` 定义；下标默认0
2. **关联数组**：字符串key，必须先 `declare -A map`
3. 取值：
   - 全部元素 `${arr[@]}`（推荐遍历），`${arr[*]}` 合并成单串
   - 全部下标 `${!arr[@]}`
   - 长度 `${#arr[@]}`
4. 截取：`${arr[@]:start:len}`
5. 替换：
   - `${arr[@]/old/new}`：仅替换首个匹配
   - `${arr[@]//old/new}`：全局全部替换
6. 追加元素 `arr+=("xxx")`；删除 `unset arr[index]`
```

#### 生产规范：注释规范、退出状态码、错误处理、`set -euo pipefail`、日志函数封装

```md
#!/bin/bash
# @Author: Ops
# @Date: 2026-07-13
# @Desc: Shell脚本生产级规范模板，包含注释、错误处理、set参数、日志函数
# @Usage: ./demo.sh arg1 arg2

# ====================== 一、生产必加安全参数 set -euo pipefail ======================
# set -e：命令非0退出码直接终止脚本，避免错误继续执行
# set -u：使用未定义变量直接报错退出，防止空变量逻辑异常
# set -o pipefail：管道中任意命令失败，整条管道返回失败码（默认只取最后一条命令结果）
set -euo pipefail
# 可选：开启调试输出，上线注释
# set -x

# ====================== 二、全局常量、环境统一定义 ======================
SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
LOG_DIR="/var/log/ops"
LOG_FILE="${LOG_DIR}/${SCRIPT_NAME%.sh}.log"
# 退出状态码规范定义（统一语义，便于排错）
EXIT_SUCCESS=0
EXIT_ARGS_ERR=1
EXIT_FILE_MISS=2
EXIT_CMD_FAIL=3
EXIT_PERM_DENY=4

# ====================== 三、日志函数封装（生产标准：INFO/WARN/ERROR） ======================
# 自动打印时间、日志级别、内容，同时输出屏幕+写入日志
log_info() {
    local content="$1"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $content" | tee -a "$LOG_FILE"
}
log_warn() {
    local content="$1"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [WARN] $content" | tee -a "$LOG_FILE"
}
log_error() {
    local content="$1"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR] $content" | tee -a "$LOG_FILE"
}

# 初始化日志目录
init_log() {
    if [[ ! -d "$LOG_DIR" ]]; then
        mkdir -p "$LOG_DIR" || {
            log_error "日志目录 $LOG_DIR 创建失败，权限不足"
            exit $EXIT_PERM_DENY
        }
    fi
    log_info "===== 脚本 ${SCRIPT_NAME} 开始运行 ====="
}

# ====================== 四、通用错误处理函数 ======================
# 参数1：错误描述；参数2：退出码
error_exit() {
    local msg="$1"
    local code="${2:-$EXIT_CMD_FAIL}"
    log_error "$msg"
    log_info "脚本异常退出，退出码: $code"
    exit "$code"
}

# ====================== 五、注释规范示范 ======================
# 函数功能：校验脚本入参数量
# 入参：无，读取全局$#
# 返回：成功0；参数不足退出码EXIT_ARGS_ERR
check_args() {
    if [[ $# -lt 2 ]]; then
        error_exit "参数不足！正确用法：./${SCRIPT_NAME} arg1 arg2" $EXIT_ARGS_ERR
    fi
    log_info "参数校验通过，共传入 $# 个参数"
}

# 检查文件是否存在
check_file() {
    local file_path="$1"
    if [[ ! -f "$file_path" ]]; then
        error_exit "文件不存在：$file_path" $EXIT_FILE_MISS
    fi
    log_info "文件校验正常：$file_path"
}

# ====================== 六、主业务流程 ======================
main() {
    # 1. 初始化日志
    init_log
    # 2. 校验入参
    check_args "$@"
    # 3. 业务逻辑示例
    local target_file="$1"
    check_file "$target_file"

    log_info "开始执行业务逻辑，输入参数1=$1 参数2=$2"
    # 模拟业务命令，捕获异常示例
    cat "$target_file" || error_exit "读取文件 $target_file 失败"

    log_info "===== 脚本执行完成，退出码 0 ====="
    exit $EXIT_SUCCESS
}

# 入口调用
main "$@"

##############################################################

# 一、注释规范（生产强制）
1. **文件头部注释**
    - 作者、日期、脚本功能、使用方式、入参说明
2. **函数注释**
    - 函数用途、入参、返回码、风险点
3. **代码块注释**
    - 复杂逻辑前加单行说明，不重复描述显而易见代码
4. **禁止**：大量无意义注释、注释掉的废弃代码（直接删除）

# 二、退出状态码统一规范
| 码值 | 含义 | 使用场景 |
|------|------|----------|
| 0 | 执行成功 | 正常结束 |
| 1 | 参数错误 | 入参缺失、格式非法 |
| 2 | 文件/目录不存在 | 配置文件、数据文件丢失 |
| 3 | 命令执行失败 | 系统命令、工具调用报错 |
| 4 | 权限不足 | 读写目录、执行程序无权限 |

# 三、set -euo pipefail 作用拆解
1. `set -e`
   任意命令返回非0，脚本立即退出；
   规避：错误命令后继续执行脏逻辑、数据破坏。
2. `set -u`
   使用未定义变量直接崩溃；杜绝空变量导致路径/判断异常。
3. `set -o pipefail`
   管道 `cmd1 | cmd2`，cmd1失败时整条管道返回失败；
   默认仅取最后一条命令结果，会掩盖上游错误。

# 四、生产错误处理标准写法
1. 关键命令后加 `|| error_exit "描述"` 捕获可控异常
2. 封装统一 `error_exit`，统一打印日志+退出
3. 提前校验：参数、文件、目录、权限，前置拦截错误
4. 禁止：忽略命令返回码、单纯靠set -e不做自定义错误提示

# 五、日志函数设计规范
1. 分级：INFO正常、WARN警告、ERROR致命错误
2. 输出同时落地文件+标准输出（tee）
3. 每行携带时间戳、日志级别，便于日志检索排查
4. 脚本启停打印分隔线，方便分割单次运行记录
5. 日志目录自动创建，无目录直接抛出权限错误退出
```

---

### 模块10：日志管理与系统排障体系

**定位**：运维的核心价值——保障业务稳定，排障能力直接体现水平

#### 核心知识点

- 系统日志体系：rsyslog 原理、日志级别、`/var/log` 核心日志文件（`messages/secure/cron/maillog`）
- 日志轮转：logrotate 配置、轮转规则、压缩与保留策略
- **四维排障方法论**
  - CPU 维度：`top/vmstat`、用户态/内核态占比、负载均值解读
  - 内存维度：`free`、buffer/cache 区别、内存泄漏排查
  - 磁盘 IO 维度：`iostat/sar`、读写瓶颈定位
  - 网络维度：带宽、延迟、丢包、连接数排查
- 常用高级工具：`lsof`、`strace`、`pidstat`

#### 学习目标

遇到系统慢、服务异常、磁盘满等常见故障有清晰的排查思路，能通过日志定位问题根源。

#### 系统日志体系：rsyslog 原理、日志级别、`/var/log` 核心日志文件（`messages/secure/cron/maillog`）

```md
# 一、rsyslog 系统日志原理
## 1. 整体架构
1. **应用/内核**：程序、内核、cron、sshd、httpd 产生日志消息；
2. **日志源入口**
   - `/dev/log`：本地UNIX套接字，应用进程写入（如ssh、crontab）
   - `kmsg`：内核环形缓冲区，存储dmesg内核日志
   - TCP/UDP 514：接收远端服务器推送日志（集中日志收集）
3. **rsyslogd 服务**：系统日志守护进程，统一接收、过滤、分类、持久化；
4. **输出动作**：本地写入 `/var/log` 文件、转发至远程日志服务器、存入数据库。

## 2. 工作流程
应用产生日志 → 发送到 `/dev/log` → rsyslog 读取 → 根据**设施+日志级别**匹配规则 → 写入对应日志文件/转发远端。

## 3. Facility 设施（日志来源分类）
| 设施 | 说明 |
|------|------|
| auth/authpriv | 认证相关（ssh登录、sudo）→ secure |
| cron | 定时任务日志 → cron |
| mail | 邮件服务日志 → maillog |
| kern | 内核日志 |
| user | 用户程序通用日志 |
| daemon | 后台服务通用日志 |
| local0~local7 | 自定义业务程序日志（nginx、tomcat常用local7） |

## 4. 日志级别（由高到低，数字越小越严重）
0. emerg 系统崩溃，紧急广播
1. alert 必须立刻处理
2. crit 严重故障
3. err 错误（程序运行失败）
4. warn 警告（不中断运行，但存在风险）
5. notice 正常但值得关注
6. info 普通运行信息（默认收集级别）
7. debug 调试详细日志（生产默认关闭）

配置示例：`*.info;authpriv.none /var/log/messages`
含义：所有设施info及更高级别写入messages，但认证日志单独存secure，不再写入messages。

# 二、/var/log 核心日志文件详解（CentOS/RHEL）
## 1. /var/log/messages
- 系统**综合主日志**；
- 记录：系统启动、服务启停、内核普通信息、应用info/warn日志；
- 排除：认证、cron、邮件日志；
- 排查场景：服务器重启异常、服务启动失败、硬件告警。

查看：`tail -f /var/log/messages`

## 2. /var/log/secure（最常用安全日志）
- 设施：authpriv
- 记录：ssh远程登录、sudo提权、密码错误、用户登录失败、su切换用户；
- 安全排查：暴力破解ssh、异常账号登录、权限提权操作。

筛选登录失败：

grep "Failed password" /var/log/secure


## 3. /var/log/cron
- 设施：cron
- 记录：所有定时任务执行日志、crontab增删、任务执行输出/报错；
- 排查：定时脚本不执行、脚本报错、定时任务丢失。

## 4. /var/log/maillog
- 设施：mail
- 记录：sendmail/postfix邮件收发、投递失败、退信、连接日志；
- 排查：邮件发不出去、垃圾邮件、投递报错。

## 5. 其他配套关键日志
1. `/var/log/dmesg`：系统开机内核硬件日志（磁盘、网卡、内存报错）
2. `/var/log/lastlog`：所有用户最后一次登录时间（lastlog命令读取）
3. `/var/log/wtmp`：登录历史，`last` 命令查看
4. `/var/log/btmp`：失败登录记录，`lastb` 查看暴力破解
5. `/var/log/httpd/`：Apache访问/错误日志（独立程序日志，不归rsyslog管理）

# 三、rsyslog 基础配置实操
## 1. 主配置文件
`/etc/rsyslog.conf`
规则语法：`设施.级别 输出目标`

示例规则片段：
# 所有info日志，排除认证
*.info;mail.none;authpriv.none;cron.none    /var/log/messages
# 认证日志单独存放
authpriv.*                                  /var/log/secure
# cron日志
cron.*                                      /var/log/cron
# 邮件日志
mail.*                                      -/var/log/maillog



`-` 表示异步写入，减少磁盘IO压力。

## 2. 重载配置生效

systemctl restart rsyslog

# 查看状态

systemctl status rsyslog

# 四、日志轮转 logrotate 配套

rsyslog只会持续追加文件，文件无限变大；
`logrotate` 按周期切割、压缩、删除旧日志，配置路径 `/etc/logrotate.conf`
`/var/log` 下日志自动按周/日切割，保留历史归档。

# 速记总结

1. rsyslog：接收全系统日志，按设施+级别分发存储；
2. 级别0(emerg)~7(debug)，线上默认收集info及以上；
3. messages：系统综合日志；secure：登录安全；cron：定时任务；maillog：邮件；
4. 排查登录暴力破解看secure，定时任务异常看cron，系统启动故障看messages。
```

#### 日志轮转：logrotate 配置、轮转规则、压缩与保留策略

```md
# logrotate 日志轮转完整讲解
## 一、基础原理
1. 作用：防止日志文件无限膨胀占满磁盘，自动**切割、压缩、备份、清理过期日志**
2. 执行时机：系统定时任务 `cron` 每日自动执行 `/etc/cron.daily/logrotate`
3. 主配置：`/etc/logrotate.conf`（全局默认规则）
4. 独立服务配置目录：`/etc/logrotate.d/`（Nginx、rsyslog、mysql等单独配置）

## 二、核心配置参数（轮转规则、压缩、保留）
### 1. 轮转周期（四选一）
- `daily`：每天切割
- `weekly`：每周切割
- `monthly`：每月切割
- `yearly`：每年切割

### 2. 保留备份策略
`rotate N`：保留N份历史归档，超过自动删除
例：`rotate 7` 只保留最近7天日志，更早自动清理

### 3. 压缩相关
- `compress`：启用gzip压缩旧日志（默认后缀 `.gz`）
- `nocompress`：不压缩
- `delaycompress`：本次切割文件暂不压缩，下一轮转再压缩（服务持续写日志场景，如nginx）
- `compresscmd /usr/bin/zstd`：更换压缩工具（zstd更快）

### 4. 切割行为控制
- `copytruncate`（最常用）：复制当前日志到备份，原文件清空，**无需重启服务**（Nginx、Tomcat无日志reopen信号必备）
- `create mode owner group`：切割后新建空日志文件，指定权限、属主
- `postrotate / endscript`：轮转完成后执行脚本（重载服务、发告警）
- `prerotate / endscript`：轮转前执行脚本
- `missingok`：日志文件不存在不报错
- `notifempty`：文件为空不执行轮转
- `size 100M`：不按时间，文件达到指定大小立即切割（优先匹配size）

## 三、完整配置模板示例
### 示例1：rsyslog系统日志（/etc/logrotate.d/syslog）
/var/log/messages
/var/log/secure
/var/log/cron
/var/log/maillog
{
    daily               # 每日轮转
    rotate 7            # 保留7天日志
    compress            # gzip压缩旧日志
    delaycompress       # 延迟一周期压缩
    missingok           # 文件缺失不报错
    notifempty          # 空文件不轮转
    create 0600 root root  # 新建日志权限600，属主root
    sharedscripts
    postrotate
        /usr/bin/systemctl reload rsyslog > /dev/null 2>&1
    endscript
}


### 示例2：Nginx日志（copytruncate 无需重启）

/var/log/nginx/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    copytruncate    # 复制截断，不用重载nginx
    size 500M       # 超过500M强制切割
}


## 四、全局默认配置 /etc/logrotate.conf

weekly          # 默认每周轮转
rotate 4        # 默认保留4份备份
create          # 自动创建新日志
compress        # 默认开启压缩

# 加载独立配置目录
include /etc/logrotate.d


## 五、手动调试与执行命令

# 1. 模拟执行，只打印过程不实际切割（排错首选）

logrotate -d /etc/logrotate.d/nginx

# 2. 强制立即执行轮转

logrotate -f /etc/logrotate.d/syslog

# 3. 查看日志轮转状态记录

cat /var/lib/logrotate/logrotate.status

## 六、生产常用策略规范

1. 系统日志（messages/secure/cron）：`daily + rotate 7`，保留一周审计日志
2. Web服务(Nginx/Apache)：`daily + rotate 30 + size阈值 + copytruncate`，留存30天访问日志
3. 数据库日志：`daily + rotate 15`，配合delaycompress避免锁文件
4. 安全规范：日志权限 `create 0600 root root`，禁止普通用户读取secure登录日志

## 七、关键参数速记

1. 周期：daily/weekly/monthly

2. 留存：`rotate N` 控制备份数量

3. 压缩：`compress` 压缩，`delaycompress` 延后压缩

4. 不重启服务：`copytruncate`

5. 后置操作：`postrotate` 重载日志服务

6. 保护：`missingok`、`notifempty` 避免误报错误
```

#### **四维排障方法论**

- CPU 维度：`top/vmstat`、用户态/内核态占比、负载均值解读
- 内存维度：`free`、buffer/cache 区别、内存泄漏排查
- 磁盘 IO 维度：`iostat/sar`、读写瓶颈定位
- 网络维度：带宽、延迟、丢包、连接数排查

```md
# Linux 服务器四维排障完整方法论（CPU/内存/磁盘IO/网络）
## 一、CPU维度：负载、使用率、瓶颈定位
### 1. 核心工具
`top`（实时综合视图）、`vmstat n`（每n秒输出整体快照）、`pidstat -u`（单进程CPU细分）、`uptime`（仅看负载）

### 2. 关键指标解读
1. **负载均值 load average（1min,5min,15min）**
    逻辑：CPU核心数为基准
    - 4核CPU：负载4 = CPU满载；负载>4 队列堆积、请求排队等待CPU
    - 区分：短期高负载（1min高5/15低）瞬时峰值；长期三高代表持续CPU瓶颈
    - 误区：负载高 ≠ CPU使用率高，磁盘IO阻塞也会拉高负载（等待IO的进程计入负载）

2. **CPU使用率分段（top %Cpu行）**
- `us` 用户态：业务程序、应用代码消耗，us长期高=业务代码计算密集
- `sy` 内核态：系统调用、锁、磁盘读写、内核处理，sy高：频繁IO/频繁上下文切换/锁竞争
- `id` 空闲CPU，id接近0代表CPU打满
- `wa` IO等待（重点！）进程等待磁盘IO让出CPU，wa高=磁盘IO瓶颈，拉高负载但CPU空闲
- `si/hi` 软/硬中断，网络大量小包会拉高si

### 3. 排查步骤
1. uptime 看负载，判断瞬时/长期压力
2. top 看全局us/sy/wa/id；按P按CPU排序，定位耗CPU进程PID
3. vmstat 3 持续观察wa、us
4. pidstat -u -p PID 定位线程/函数消耗
5. 若si高：检查网卡小包、连接爆炸

## 二、内存维度：free/buffer/cache、泄漏排查
### 1. 工具
`free -h`、`vmstat`、`pidstat -r`、`smem`、`cat /proc/meminfo`

### 2. free输出字段含义（CentOS7+新版算法）

total        used        free      shared  buff/cache   available


- `free`：真正空闲裸内存（数值很小属正常）
- `buff`：块设备缓冲（磁盘元数据、块读写缓存）
- `cache`：文件页缓存（读取过的文件，可快速回收）
- `available`：**业务可用内存**（free+可回收buff/cache，判断内存是否充足唯一标准）

### buffer vs cache 核心区别
1. Buffer：面向**块设备**，磁盘读写临时缓冲；
2. Cache：面向**文件**，缓存读取的文件内容，系统会自动回收给应用使用。

### 3. 内存泄漏判断
1. available 持续下跌，free不断变小，buff/cache不释放，最终触发OOM Killer杀进程
2. 单进程RSS/VSZ持续缓慢上涨，业务无流量增长
3. 日志出现 `Out of memory: Kill process`

### 排查流程
1. free -h 看available，低于阈值预警
2. top 按M排序，定位占用内存最高PID
3. pidstat -r 持续观测进程内存增长趋势
4. 查看 `/var/log/messages` 是否存在OOM杀进程日志
5. 临时清理缓存（应急）：`echo 3 > /proc/sys/vm/drop_caches`

## 三、磁盘IO维度：iostat/sar 定位读写瓶颈
### 1. 工具
`iostat -x 2`（磁盘详细IO）、`sar -d 2`、`iotop`（进程IO）、`vmstat`看wa

### 2. iostat核心指标
- `%util`：磁盘设备繁忙度，接近100% 磁盘饱和IO瓶颈
- `rMB/s / wMB/s` 读写吞吐量
- `r_await / w_await` 读写IO等待耗时（ms），超过10ms说明延迟高
- `avgqu-sz` IO队列长度，队列堆积代表磁盘处理不过来

### 瓶颈场景区分
1. 大量随机读：cache命中率低，r_await高
2. 大量随机写：数据库刷盘、日志同步刷盘，w_await、%util打满
3. wa值持续高于30：进程卡在等待磁盘IO，CPU空闲但负载高

### 排查步骤
1. vmstat 先看wa是否长期偏高
2. iostat -x 2 确认哪个磁盘%util 100%
3. iotop -oP 定位哪个进程疯狂读写磁盘（MySQL/日志/备份脚本）
4. sar -d 历史回放，判断IO高峰时段

## 四、网络维度：带宽、延迟、丢包、连接数
### 1. 工具
- 带宽流量：`sar -n DEV 2`、`iftop`、`nload`
- 延迟丢包：`ping`、`mtr`（路由丢包排障神器）
- 连接数：`ss -s`、`ss -tulnp`、`netstat`
- 抓包底层：tcpdump

### 2. 四大网络故障点
1. **带宽打满**
sar查看rxkB/s/txkB/s网卡流量，接近网卡上限；iftop定位占用带宽IP/端口。

2. **延迟高**
ping 平均延迟>50ms内网异常；mtr逐跳定位中间路由节点延迟。

3. **丢包**
ping出现packet loss；mtr区分：
- 本机发送端丢包：服务器网卡/队列满、防火墙限流
- 中间链路丢包：运营商/交换机故障
- 对端服务器丢包：对方CPU/磁盘满无法应答

4. **TCP连接数爆满**
`ss -s` 查看Established、Time_wait、Syn_recv数量
- Time_wait爆炸：短连接大量创建销毁，调tcp_tw_reuse回收
- Syn_recv堆积：端口扫描、连接攻击、服务处理慢
- 连接耗尽：超出文件句柄限制，调整nofile

### 网络排障标准流程
1. mtr 同时看延迟+丢包，区分故障链路
2. sar -n DEV 查看网卡带宽是否跑满
3. ss -s 统计全量TCP连接状态
4. ss -ti 查看TCP重传Retrans（重传>0代表网络不稳定）
5. telnet/nc 测试端口连通；curl 验证应用层
6. tcpdump 抓包分析握手、响应慢、丢包根源

# 四维排障速记口诀
1. CPU：看负载、us业务、sy内核、wa是IO瓶颈；
2. 内存：只看available，buff/cache可回收，持续下跌是泄漏；
3. 磁盘IO：%util接近100%、await高、vmstat wa升高；
4. 网络：mtr查丢包延迟，sar看带宽，ss统计TCP连接状态。
```

#### 常用高级工具：`lsof`、`strace`、`pidstat`

```md
# 三大高级排障工具：lsof / strace / pidstat
## 一、pidstat（进程维度综合监控，CPU/内存/IO/上下文切换）
### 核心作用
分进程精细化输出CPU、内存、磁盘IO、上下文切换，比top精准，支持持续采样记录趋势。
### 常用参数
- `-u` CPU使用率（us/sy/guest/等待）
- `-r` 内存RSS/VSZ/缺页异常（内存泄漏）
- `-d` 磁盘IO读写吞吐量、IO等待
- `-w` 上下文切换（cswch：自愿切换；nvcswch：非自愿阻塞切换，性能杀手）
- `-t` 显示线程号
- `-p PID` 只监控指定进程
- 数字2：每2秒输出一次

### 实操示例
# 每2秒输出所有进程CPU
pidstat -u 2
# 监控进程1234内存变化，持续观测泄漏
pidstat -r -p 1234 2
# 查看进程磁盘IO读写瓶颈
pidstat -d -p $(pgrep mysql) 2
# 上下文切换飙升排查（锁/IO阻塞）
pidstat -w 2
# 同时监控CPU+IO+内存
pidstat -urd 2

### 关键指标
1. `%usr` 业务代码占用；`%system` 内核调用占用
2. `minflt/majflt` 内存缺页，majflt高代表频繁swap换页
3. `kB_rd/kB_wr` 进程读写磁盘速率
4. `nvcswch/s` 非自愿上下文切换持续高：CPU不足、大量锁竞争、IO阻塞

## 二、lsof（list open files，查看进程打开所有文件/套接字）
Linux一切皆文件：普通文件、目录、设备、管道、TCP/UDP socket都能查。
### 高频用法
1. 查看端口对应进程（替代netstat/ss）
lsof -i :80
lsof -i tcp:3306

2. 查看指定PID打开的所有文件句柄
lsof -p 1234
# 统计进程句柄数量（句柄泄露）
lsof -p 1234 | wc -l

3. 查看哪个进程占用某个文件（日志无法删除、磁盘占用不释放）
# 删除文件但进程仍持有句柄，磁盘空间不释放
lsof /var/log/nginx/access.log
# 查找已删除但未释放的大文件
lsof | grep deleted

4. 查看用户所有进程打开文件
lsof -u nginx

5. 列出所有TCP/UDP网络连接
lsof -i
lsof -i TCP

### 典型排障场景
- 磁盘空间df显示占用高，du找不到大文件：`lsof | grep deleted` 清理残留句柄
- 服务启动报“address already in use”：`lsof -i :端口` 杀残留进程
- 程序报错 `too many open files`：lsof统计句柄，调ulimit

## 三、strace（系统调用追踪，底层万能排错神器）
### 原理
拦截进程所有**系统调用**（open/read/write/connect/socket/mmap等），定位程序卡顿、文件缺失、权限失败、网络慢、死锁根源。
### 常用参数
- `-p PID` 附加追踪正在运行的进程
- `-c` 统计系统调用耗时、调用次数（性能瓶颈）
- `-e trace=xxx` 只过滤指定系统调用：open/read/write/connect/stat
- `-T` 打印每个系统调用耗时
- `-tt` 精确毫秒时间戳
- `-o log.txt` 输出到文件，不刷屏

### 实操示例
1. 跟踪运行中的MySQL进程所有系统调用
strace -tt -p $(pgrep mysqld)

2. 只看文件读写相关调用，排查读文件卡顿
strace -e trace=open,read,write -p 1234

3. 统计各系统调用总耗时，定位性能瓶颈
strace -c -p 1234

4. 追踪程序启动全过程，找配置文件加载失败
strace ./test.sh

5. 排查网络连接缓慢（connect调用耗时）
strace -e trace=connect,socket -p 1234

### 典型故障定位
1. 程序报错找不到配置：`open()` 返回 `-1 ENOENT`
2. 权限不足：`open()` 返回 `-1 EACCES`
3. 接口响应慢：`read/write/connect` 系统调用耗时巨大
4. 内存频繁换页：大量 `mmap/munmap`
5. DNS解析卡住：阻塞在 `connect` 到DNS 53端口

# 三者分工速记
1. **pidstat**：性能监控，宏观看进程CPU/内存/IO/上下文切换趋势
2. **lsof**：文件/句柄/端口占用排查，解决端口冲突、句柄泄漏、已删文件占磁盘
3. **strace**：底层微观追踪，定位程序卡慢、文件/网络/权限底层报错根源
```

---

## 二、完整学习路线图（分阶段落地）

### 阶段一：入门上手期（1~2周）

- **学习内容**：模块1 + 模块2 + 模块3
- **核心目标**：熟悉 Linux 操作习惯，掌握文件与用户权限管理
- **实战任务**：搭建 3 台虚拟机集群，创建多用户并分配不同权限，实现普通用户 sudo 提权

### 阶段二：命令精通期（2~3周）

- **学习内容**：模块4
- **核心目标**：命令形成肌肉记忆，三剑客能独立处理文本需求
- **实战任务**：用三剑客完成 Nginx 日志的 IP 统计、状态码统计、错误日志过滤；每天坚持敲命令练习

### 阶段三：系统管理期（2~3周）

- **学习内容**：模块5 + 模块6 + 模块7
- **核心目标**：掌握系统四大资源（进程、磁盘、网络、内存）的管理与排障
- **实战任务**：给服务器新增一块磁盘做 LVM 扩容；配置 iptables 白名单防火墙；编写 crontab 定时备份任务

### 阶段四：服务与脚本期（3~4周）

- **学习内容**：模块8 + 模块9
- **核心目标**：具备独立部署服务、编写自动化脚本的能力
- **实战任务**：部署 LNMP 环境；编写完整的系统巡检脚本；编写日志清理与备份脚本

### 阶段五：排障巩固期（1~2周）

- **学习内容**：模块10 + 全知识点串联
- **核心目标**：形成完整的知识体系，建立排障思维
- **实战任务**：模拟常见故障（端口不通、服务启动失败、磁盘满、系统慢），独立排查并解决

---

## 三、高效学习建议

1. **拒绝只看视频，必须动手实操**：运维是实操性极强的岗位，每一个命令、每一条规则都要亲手敲一遍，观察输出结果。
2. **重视原理，不要死记硬背**：比如 iptables 先懂四表五链和数据包流向，再记语法；先懂 inode 原理，再理解软硬链接。
3. **用生产场景驱动学习**：不要孤立学知识点，比如学完三剑客就去分析真实日志，学完 Shell 就去解决真实的批量处理需求。
4. **基础打牢再学进阶**：核心基础不扎实的情况下，不要急于学 Docker、K8s、Ansible 等进阶内容，否则很容易遇到底层问题无从下手。

基础全部掌握后，可按照自动化运维→监控告警→云原生的路径继续进阶，对应初中级运维的完整能力体系。

# 核心服务与中间件层

# 一、Web 反向代理层（中级运维第一核心）

## 1. Nginx 完整中级知识点（全覆盖）

### 1）基础架构

- Nginx 进程模型：master/worker 机制、CPU 亲和绑定
- 编译 / 官方包生产部署、目录结构解读
- 核心模块结构：main、events、http、server、location

```md
# Nginx 基础架构（中级核心深度版）

## 一、Nginx 进程模型：master / worker 机制

### 1. 双进程角色分工

Nginx 采用**多进程单线程**的事件驱动架构，启动后默认分为两类进程：

- **master 主进程（1个）**：管理控制角色，不处理业务请求
  - 读取并校验配置文件，维护全局配置
  - 启动、监控、管理 worker 工作进程
  - 接收外部信号（reload/stop/quit），实现平滑重启、热升级
  - 进程 PID 记录在 `nginx.pid` 文件中
- **worker 工作进程（N个）**：实际处理 HTTP 请求
  - 单线程、非阻塞IO模型，通过 epoll 处理并发连接
  - 每个 worker 独立承接请求，进程间互不影响，单个 worker 崩溃不会拖垮整体服务

### 2. 高并发核心原理

Nginx 高性能的底层支撑：

1. **异步非阻塞事件模型**：worker 采用 epoll 事件驱动，单个进程可同时处理上万连接，无需为每个连接创建新线程，内存与CPU开销极低
2. **多进程无锁设计**：worker 进程相互独立，请求处理全程无锁竞争，CPU 利用率高
3. **单线程低开销**：避免多线程上下文切换与锁竞争开销，适合 IO 密集型的 Web 反向代理场景

### 3. worker 数量与 CPU 亲和绑定

#### （1）worker 进程数配置

生产环境建议 **worker 数量 = CPU 物理核心数**，最大化利用 CPU 资源，避免进程跨核调度开销。


# nginx.conf 全局块配置

worker_processes auto;  # 自动匹配CPU核心数，生产推荐

# worker_processes 4;   # 手动指定4核

#### （2）CPU 亲和绑定

将每个 worker 进程固定绑定到指定 CPU 核心，减少进程上下文切换，进一步提升性能。


# 4核CPU，依次绑定到0、1、2、3号核心

worker_cpu_affinity 0001 0010 0100 1000;

# 自动分配亲和性（Nginx 1.9.10+ 支持）

worker_cpu_affinity auto;


### 4. 平滑重载（reload）原理

执行 `nginx -s reload` 时无业务中断，流程如下：

1. master 进程校验新配置语法，语法错误则保留旧配置不生效
2. master 启动新一批 worker 进程，使用新配置承接新请求
3. 旧 worker 进程停止接收新连接，处理完当前所有请求后自动退出
4. 最终全部替换为新配置的 worker，全程无服务中断

---

## 二、生产级部署方式

### 1. 官方源安装（YUM / APT）

#### 适用场景

业务无自定义模块需求、追求稳定省心、便于统一版本管理，是绝大多数企业的首选。

#### CentOS / RHEL 官方源部署


# 1. 安装依赖

yum install yum-utils -y

# 2. 配置Nginx官方源

cat > /etc/yum.repos.d/nginx.repo <<EOF
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
EOF

# 3. 安装稳定版

yum install nginx -y

# 4. 启动+开机自启

systemctl start nginx
systemctl enable nginx

#### Ubuntu / Debian 官方源部署

apt install curl gnupg2 ca-certificates lsb-release -y
curl -fsSL https://nginx.org/keys/nginx_signing.key | gpg --dearmor -o /usr/share/keyrings/nginx-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" > /etc/apt/sources.list.d/nginx.list
apt update && apt install nginx -y

### 2. 源码编译安装

#### 适用场景

需要开启第三方模块（如 lua-nginx-module）、自定义安装路径、裁剪功能模块、极致性能优化的场景。

#### 编译核心参数与常用模块


# 下载解压源码

wget https://nginx.org/download/nginx-1.26.1.tar.gz
tar zxf nginx-1.26.1.tar.gz
cd nginx-1.26.1

# 配置编译参数

./configure \
  --prefix=/usr/local/nginx \                  # 指定安装根目录
  --with-http_ssl_module \                     # HTTPS SSL模块
  --with-http_stub_status_module \             # 状态监控模块
  --with-http_realip_module \                  # 透传真实客户端IP
  --with-http_gzip_static_module \             # 静态gzip压缩
  --with-http_v2_module \                      # HTTP/2 支持
  --with-stream \                              # 四层TCP/UDP代理
  --with-pcre \                                # 正则支持（rewrite依赖）
  --user=nginx --group=nginx                   # 运行用户

# 多核编译+安装
make -j $(nproc)
make install


### 3. 两种部署方式对比

| 维度 | 官方源安装 | 源码编译安装 |
| --- | --- | --- |
| 部署效率 | 快，一键安装 | 慢，需解决依赖编译 |
| 模块扩展 | 固定官方模块，无法自定义 | 自由增减模块，支持第三方扩展 |
| 版本更新 | yum/apt 一键升级 | 需重新编译覆盖，升级繁琐 |
| 目录结构 | 分散到系统目录（/etc、/usr、/var） | 统一集中在指定 prefix 目录 |
| 适用场景 | 通用业务、标准反向代理 | 定制化需求、性能极致优化 |

---

## 三、标准目录结构解读

### 1. YUM/RPM 安装默认目录（分散式）

| 路径 | 作用 |
| --- | --- |
| `/etc/nginx/nginx.conf` | 主配置文件 |
| `/etc/nginx/conf.d/` | 子配置目录，存放虚拟主机 `.conf` 文件，主配置自动 include |
| `/usr/sbin/nginx` | Nginx 二进制可执行程序 |
| `/var/log/nginx/` | 日志目录（access.log / error.log） |
| `/usr/share/nginx/html/` | 默认站点根目录 |
| `/var/run/nginx.pid` | master 进程 PID 文件 |

### 2. 源码编译安装目录（集中式，以 `--prefix=/usr/local/nginx` 为例）

| 路径 | 作用 |
| --- | --- |
| `/usr/local/nginx/sbin/nginx` | 主程序二进制文件 |
| `/usr/local/nginx/conf/nginx.conf` | 主配置文件 |
| `/usr/local/nginx/conf/conf.d/` | 自定义子配置目录（需手动创建+include） |
| `/usr/local/nginx/html/` | 默认站点根目录 |
| `/usr/local/nginx/logs/` | 日志 + PID 文件目录 |
| `/usr/local/nginx/modules/` | 动态模块目录 |

> 
> 生产最佳实践：无论哪种部署方式，都将虚拟主机配置拆分到 `conf.d/` 目录，按域名命名，避免单配置文件过长难以维护。

---

## 四、配置文件核心模块层级结构
Nginx 配置采用**分层嵌套结构**，由外到内作用域逐级收敛，内层配置可覆盖外层。

### 1. 层级结构总览

main 全局块（最外层）
└── events 块
└── http 块
    ├── http 全局配置
    ├── server 块1（虚拟主机1）
    │   ├── server 全局配置
    │   ├── location / {...}
    │   └── location /api {...}
    └── server 块2（虚拟主机2）
        └── location ...


### 2. 各层级作用与核心指令

#### （1）main 全局块

配置文件最外层，作用于 Nginx 全局，与具体业务请求无关。
核心指令：

worker_processes auto;       # worker进程数
worker_cpu_affinity auto;    # CPU亲和
error_log  logs/error.log;   # 全局错误日志
pid        logs/nginx.pid;   # PID文件路径
user nginx nginx;            # 运行用户/用户组
worker_rlimit_nofile 65535;  # 单个worker最大文件句柄数


#### （2）events 块

控制 Nginx 连接处理底层模型，全局唯一。
核心指令：

events {
    use epoll;                 # 事件驱动模型，Linux默认epoll
    worker_connections 10240;  # 单个worker最大连接数
    multi_accept on;           # 一次接收多个连接
}


#### （3）http 块

HTTP 协议全局配置，所有虚拟主机共享，可包含多个 server 块。
核心指令：

http {
    include       mime.types;          # 文件类型映射
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    sendfile        on;                # 高效文件传输
    keepalive_timeout  65;             # 长连接超时
    gzip  on;                          # 开启压缩

    include /etc/nginx/conf.d/*.conf;  # 加载子配置目录

}


#### （4）server 块

对应一个虚拟主机，通过 `listen` 端口 + `server_name` 域名匹配请求。
核心指令：


server {
    listen       80;
    server_name  www.example.com;      # 绑定域名
    root   /usr/share/nginx/html;      # 站点根目录
    index  index.html index.htm;       # 默认首页

    access_log  /var/log/nginx/www.example.com_access.log  main;
    error_log   /var/log/nginx/www.example.com_error.log;

    # 多个location规则
    location / { ... }
    location /api { ... }

}


#### （5）location 块

最细粒度匹配，根据 URI 路径执行不同规则（反向代理、静态文件、重写等）。
匹配优先级：精确匹配 `=` > 前缀匹配 `^~` > 正则匹配 `~`/`~*` > 普通前缀匹配。
核心示例：


# 精确匹配首页
location = /index.html {
    root /data/static;
}

# 正则匹配图片资源，设置缓存

location ~* \.(jpg|png|gif)$ {
    expires 30d;
}

# 反向代理到后端服务
location /api {
    proxy_pass http://127.0.0.1:8080;
    proxy_set_header Host $host;
}


#补充知识点
## epoll 不等于协程，两者完全不是一个层面的东西
### 1. epoll 是什么

epoll 是 **Linux 内核提供的 IO 多路复用系统调用**，本质是一个 “事件通知器”：

- 你把成百上千个 socket 连接交给 epoll 管理；
- 当某个 socket 有数据可读、或者可写的时候，内核会告诉你哪些连接就绪了；
- 你程序只需要处理这些就绪的连接就行，不用挨个去轮询，也不用阻塞等待。

它解决的问题是：**单线程怎么高效知道 “哪个连接现在有事可做”**。

### 2. 协程是什么

协程是 **用户态的轻量级执行单元**，由程序自己调度，不用操作系统内核参与。

- 它可以在代码执行中途主动挂起（yield），去执行别的协程；
- 之后还能回到挂起的位置继续执行，上下文都保留着；
- 切换成本非常低，因为是用户态自己切，不经过内核。

### 3. 为什么你会觉得它们像？

因为两者都能实现「单线程同时处理大量 IO 并发」，但实现路径完全不同：

对比维度    epoll（IO 多路复用）                    协程
层级        内核系统调用                            用户态程序逻辑
作用        监控连接事件，告诉你哪个就绪了            切换代码执行流，挂起 / 恢复任务
代码写法    事件回调，异步风格                        同步写法，逻辑可以中途暂停继续
关系      协程的底层也可以用 epoll 来等待 IO 事件    协程是上层的调度方式，epoll 是它可用的底层工具

### 打个通俗的比方
- **epoll**：就像餐厅的叫号器。一个服务员守着叫号器，哪桌喊号了就去处理哪桌，不用挨个桌子去问 “好了没”。
- **协程**：就像这个服务员可以同时做半件事 —— 给 A 桌点单点到一半，先记下来，去给 B 桌送个菜，回来接着给 A 桌点单。
- **Nginx 原生模型**：一个服务员 + 一个叫号器（epoll），每桌的活一次性干完，干不完就等下一次叫号再接着干，不会中途切去干别的桌。

1. Nginx 是**多进程**（1 个 master + N 个 worker，都是独立进程）；
2. 每个 worker 是**单线程**，不靠多线程堆并发，靠 epoll + 非阻塞 IO 一个线程管上万连接；
3. 原生 Nginx **没有协程**，是事件回调模型；
4. epoll 是内核的 IO 事件通知工具，不是协程；协程是用户态的执行流调度，两者不是一回事。
```

### 2）虚拟主机（企业多站点核心）

- 基于域名、端口、IP 三种虚拟主机
- 多站点隔离配置、目录权限、日志分离

```md
# ==================================================
# Nginx 虚拟主机 生产级精简手册（配置+规范+排障）
# ==================================================

# --------------------------
# 1. 三种虚拟主机配置方式
# --------------------------
## 1.1 基于域名（生产首选，同IP同端口承载多站点）
cat > /etc/nginx/conf.d/www.aaa.com.conf <<'EOF'
server {
    listen 80;
    server_name www.aaa.com;
    root /data/www/www.aaa.com/html;
    index index.html index.htm;
    access_log /data/www/www.aaa.com/logs/access.log main;
    error_log  /data/www/www.aaa.com/logs/error.log;
}
EOF

cat > /etc/nginx/conf.d/www.bbb.com.conf <<'EOF'
server {
    listen 80;
    server_name www.bbb.com;
    root /data/www/www.bbb.com/html;
    index index.html index.htm;
    access_log /data/www/www.bbb.com/logs/access.log main;
    error_log  /data/www/www.bbb.com/logs/error.log;
}
EOF

## 1.2 基于端口（内网测试/内部服务用）
cat > /etc/nginx/conf.d/test-admin.conf <<'EOF'
server {
    listen 8080;
    server_name _;
    root /data/www/test-admin/html;
    access_log /data/www/test-admin/logs/access.log main;
}
EOF

## 1.3 基于IP（内外网业务物理隔离）
cat > /etc/nginx/conf.d/internal.conf <<'EOF'
server {
    listen 192.168.1.10:80;
    server_name _;
    root /data/www/internal/html;
}
EOF

# --------------------------
# 2. 多站点生产隔离规范
# --------------------------
## 2.1 标准目录结构（站点独立隔离）
mkdir -p /data/www/{www.aaa.com,www.bbb.com}/{html,logs,tmp,backup}

## 2.2 权限最小化隔离
# 属主：部署用户www；属组：nginx运行用户
chown -R www:nginx /data/www/www.aaa.com
find /data/www/www.aaa.com/html -type d -exec chmod 750 {} \;
find /data/www/www.aaa.com/html -type f -exec chmod 640 {} \;
# 仅上传目录单独放开写权限
chmod 770 /data/www/www.aaa.com/html/upload

## 2.3 server_name 匹配优先级（从高到低）
# 精确匹配 > 左通配 *.aaa.com > 右通配 www.aaa.* > 正则 > default_server

# --------------------------
# 3. 单站点日志轮转
# --------------------------
cat > /etc/logrotate.d/www.aaa.com <<'EOF'
/data/www/www.aaa.com/logs/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    sharedscripts
    postrotate
        /usr/sbin/nginx -s reopen > /dev/null 2>&1
    endscript
}
EOF

# --------------------------
# 4. 安全配置 + 生效 + 排障
# --------------------------
## 4.1 默认拒绝站点（拦截未匹配域名/IP直访）
cat > /etc/nginx/conf.d/00-default.conf <<'EOF'
server {
    listen 80 default_server;
    server_name _;
    return 444;
}
EOF

## 4.2 配置生效标准流程
nginx -t          # 语法校验（必做，防止配置错误宕机）
nginx -s reload   # 平滑重载，业务无中断

## 4.3 常见故障速查
# 访问错站点 → 检查Host请求头、server_name优先级、default_server
# 403 Forbidden → 目录/文件权限、缺失首页、selinux拦截
# 404 Not Found → root路径错误、文件不存在、location匹配偏差
# 日志不生成 → 日志目录不存在、nginx用户无写入权限
```

### 3）反向代理核心

- proxy_pass 反向代理规则、末尾 / 区别
- proxy_set_header 真实透传客户端 IP
- 代理超时、缓存、连接复用调优

```md
# ==================================================
# Nginx 反向代理核心 生产精简手册
# ==================================================

# --------------------------
# 1. proxy_pass 末尾斜杠核心区别（高频易错）
# 测试请求：http://www.example.com/api/user/list
# 规则：带/ = 去掉location前缀再转发；不带/ = 完整URI拼接转发
# --------------------------
cat > /etc/nginx/conf.d/proxy-demo.conf <<'EOF'
server {
    listen 80;
    server_name www.example.com;

    ## 示例1：末尾带 / → 转发：http://127.0.0.1:8080/user/list（自动去掉 /api 前缀）
    location /api/ {
        proxy_pass http://127.0.0.1:8080/;
    }

    ## 示例2：末尾不带 / → 转发：http://127.0.0.1:8080/api/user/list（完整拼接URI）
    location /api/ {
        proxy_pass http://127.0.0.1:8080;
    }
}
EOF

# --------------------------
# 2. proxy_set_header 透传真实客户端IP
# 解决：后端默认只能拿到Nginx内网IP，无法获取用户真实地址
# --------------------------
cat >> /etc/nginx/conf.d/proxy-demo.conf <<'EOF'
location /api/ {
    proxy_pass http://127.0.0.1:8080;

    # 透传原始域名（后端虚拟主机/业务域名识别）
    proxy_set_header Host $host;
    # 透传客户端真实IP
    proxy_set_header X-Real-IP $remote_addr;
    # 透传全链路代理IP（多级代理场景累加）
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    # 透传原始请求协议（http/https，后端判断是否加密）
    proxy_set_header X-Forwarded-Proto $scheme;
}
EOF

# --------------------------
# 3. 代理超时、缓冲、长连接复用调优
# --------------------------
cat > /etc/nginx/conf.d/proxy-optimize.conf <<'EOF'
http {
    # ========== 代理超时三段式 ==========
    proxy_connect_timeout 30s;   # 与后端建立TCP连接超时
    proxy_read_timeout    60s;   # 等待后端响应超时（两次接收数据间隔）
    proxy_send_timeout    60s;   # 向后端发送请求数据超时

    # ========== 代理缓冲（降低后端阻塞，提升吞吐） ==========
    proxy_buffering on;          # 开启缓冲：Nginx先收完后端响应，再发给客户端
    proxy_buffer_size 4k;        # 响应头缓冲区大小
    proxy_buffers 8 4k;          # 响应体缓冲区数量+单块大小

    # ========== 后端长连接复用（减少TCP握手开销） ==========
    upstream backend_pool {
        server 127.0.0.1:8080;
        keepalive 32;            # 每个worker保留32条长连接
    }

    server {
        listen 80;
        location /api/ {
            proxy_pass http://backend_pool;
            proxy_http_version 1.1;           # 启用HTTP/1.1支持长连接
            proxy_set_header Connection "";   # 清空Connection头，确保长连接复用生效
        }
    }
}
EOF

# --------------------------
# 生效校验 + 核心速记
# --------------------------
nginx -t && nginx -s reload

# 速记
# 1. proxy_pass：带/删前缀，不带/全拼接
# 2. 真实IP：X-Real-IP 单级透传，X-Forwarded-For 全链路透传
# 3. 调优：超时控三段、缓冲降阻塞、长连接减握手
```

### 4）负载均衡（面试 + 工作高频）

四种调度策略实战：

- 轮询、权重 weight、ip_hash、least_conn
- 后端健康检查、失败重试、宕机自动剔除
- 后端节点灰度、下线维护操作

```md
# ==================================================
# Nginx 负载均衡 生产精简手册
# ==================================================

# --------------------------
# 1. 四种核心调度策略
# --------------------------
cat > /etc/nginx/conf.d/upstream-demo.conf <<'EOF'
http {
    ## 1.1 轮询（默认）：请求依次均分，后端配置一致时使用
    upstream pool_round {
        server 192.168.1.11:8080;
        server 192.168.1.12:8080;
    }

    ## 1.2 权重 weight：按比例分配流量，硬件配置不均时使用
    upstream pool_weight {
        server 192.168.1.11:8080 weight=3;  # 分75%流量
        server 192.168.1.12:8080 weight=1;  # 分25%流量
    }

    ## 1.3 ip_hash：按客户端IP哈希固定分配节点，解决 session 会话保持问题
    upstream pool_iphash {
        ip_hash;
        server 192.168.1.11:8080;
        server 192.168.1.12:8080;
    }

    ## 1.4 least_conn：优先分配给连接数最少的节点，长连接业务首选
    upstream pool_leastconn {
        least_conn;
        server 192.168.1.11:8080;
        server 192.168.1.12:8080;
    }
}
EOF

# --------------------------
# 2. 被动健康检查 + 失败重试 + 宕机自动剔除
# --------------------------
cat >> /etc/nginx/conf.d/upstream-demo.conf <<'EOF'
http {
    upstream backend {
        # max_fails=2：连续失败2次判定节点宕机
        # fail_timeout=30s：剔除30秒后自动重试检测节点是否恢复
        server 192.168.1.11:8080 max_fails=2 fail_timeout=30s;
        server 192.168.1.12:8080 max_fails=2 fail_timeout=30s;
    }

    server {
        listen 80;
        location /api/ {
            proxy_pass http://backend;
            # 失败自动重试：后端报错/超时，自动转发到下一个节点
            proxy_next_upstream error timeout http_502 http_503 http_504;
            proxy_next_upstream_tries 2;      # 最多重试2个节点
            proxy_next_upstream_timeout 10s;  # 重试总超时
        }
    }
}
EOF

# --------------------------
# 3. 灰度发布 + 节点平滑下线维护
# --------------------------
cat >> /etc/nginx/conf.d/upstream-demo.conf <<'EOF'
http {
    ## 3.1 灰度发布：按权重逐步放量
    upstream pool_gray {
        server 192.168.1.11:8080 weight=9;  # 旧版本 90%流量
        server 192.168.1.12:8080 weight=1;  # 新版本 10%流量，逐步调大权重
    }

    ## 3.2 节点平滑下线：weight=0 不接收新请求，存量处理完再停机
    upstream pool_offline {
        server 192.168.1.11:8080 weight=0;  # 待下线节点
        server 192.168.1.12:8080;
    }

    ## 3.3 备份节点：主节点全部宕机时才启用
    upstream pool_backup {
        server 192.168.1.11:8080;
        server 192.168.1.12:8080 backup;  # 备用节点
    }
}

# 下线标准流程：改weight=0 → nginx -s reload → 等待连接耗尽 → 停机维护 → 恢复权重 → reload
EOF

# --------------------------
# 生效校验 + 速记
# --------------------------
nginx -t && nginx -s reload

# 速记
# 1. 四种策略：轮询均分、weight按比例、ip_hash保会话、least_conn选少连接
# 2. 健康检查：max_fails 判定失败，fail_timeout 周期恢复，proxy_next_upstream 自动重试
# 3. 灰度靠调权重，下线设 weight=0 平滑无中断
```

### 5）动静分离架构

- 静态资源本地缓存、动态转发后端
- 图片 / JS/CSS 过期缓存策略 expires
- 减轻后端 Tomcat/Java 压力

```md
# ==================================================
# Nginx 动静分离架构 生产精简手册
# 核心：静态资源Nginx直接响应，动态请求转发后端，大幅减轻Tomcat/Java压力
# ==================================================

# --------------------------
# 1. 动静分离核心配置
# 规则：匹配静态后缀本地处理，动态路径转发后端服务
# --------------------------
cat > /etc/nginx/conf.d/dynamic-static.conf <<'EOF'
server {
    listen 80;
    server_name www.example.com;

    # 1.1 静态资源：Nginx直接读取本地文件，不转发后端
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|ttf|eot)$ {
        root /data/web/static;
        expires 30d;          # 浏览器缓存30天
        access_log off;       # 静态资源关闭日志，减少磁盘IO
    }

    # 1.2 动态接口：全部转发到后端Tomcat/Java服务
    location /api/ {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # 1.3 页面入口：静态页面本地响应
    location / {
        root /data/web/static/html;
        index index.html;
    }
}
EOF

# --------------------------
# 2. 分级缓存策略 expires（精细化控制缓存周期）
# --------------------------
cat > /etc/nginx/conf.d/expires-policy.conf <<'EOF'
server {
    listen 80;
    server_name www.example.com;

    # 图片类：更新频率低，缓存30天
    location ~* \.(jpg|jpeg|png|gif|bmp|ico)$ {
        expires 30d;
        add_header Cache-Control "public, no-transform";
    }

    # JS/CSS：迭代适中，缓存7天
    location ~* \.(js|css)$ {
        expires 7d;
        add_header Cache-Control "public, no-transform";
    }

    # HTML页面：更新频繁，缓存1小时
    location ~* \.(html|htm)$ {
        expires 1h;
    }

    # 业务接口：禁止缓存，保证数据实时性
    location /api/ {
        expires -1;
        add_header Cache-Control "no-store, no-cache, must-revalidate";
        proxy_pass http://backend;
    }
}
EOF

# --------------------------
# 3. 配套优化（进一步降低后端负载）
# --------------------------
cat >> /etc/nginx/conf.d/dynamic-static.conf <<'EOF'
http {
    # 开启gzip压缩，减小传输体积，降低带宽与后端压力
    gzip on;
    gzip_min_length 1k;
    gzip_comp_level 2;
    gzip_types text/plain text/css application/javascript application/json image/jpeg image/png;
    gzip_vary on;
}
EOF

# --------------------------
# 生效校验 + 核心速记
# --------------------------
nginx -t && nginx -s reload

# 速记
# 1. 核心逻辑：静态资源本地读，动态请求转后端
# 2. expires 分级控缓存：图片长、脚本中、页面短、接口禁缓存
# 3. 收益：降低后端CPU/IO消耗，提升页面加载速度，减少带宽成本



扩展: 
# ip_hash 场景、缺陷、主流方案精简版
## 适用场景（必须用ip_hash）
后端Session本地内存存储，无Redis共享且不愿改代码：
1. 老旧Java/PHP项目，改造代价大
2. 小型内网系统，不想额外部署缓存
3. 临时过渡方案

## ip_hash 三大缺陷
1. 负载失衡：CDN/公司统一出口IP会全部打在单台后端
2. IP切换会话失效：手机切换WiFi/流量即掉线
3. 增减后端节点，哈希重算，全体用户会话丢失

## 企业标准方案（优先推荐）
所有节点Session统一存入Redis集中共享，负载均衡选用轮询/权重/least_conn，扩容缩容、节点故障均不影响登录。

## 总结
1. 轮询/权重：不绑定用户，适合Session共享、无状态业务
2. ip_hash：仅兼容本地内存会话，负载不均、容错差，生产尽量不用
3. 最优架构：Redis共享Session + 权重/least_conn均衡
```

### 6）HTTPS 全站加密

- SSL 证书签发、CRT/KEY 配置
- 强制 HTTP 跳转 HTTPS
- 加密套件优化、https 性能调优

```md
# Nginx HTTPS全站加密 精简生产配置手册
# 1.证书部署+CRT&KEY配置
cat > /etc/nginx/conf.d/https.conf <<'EOF'
server {
    listen 443 ssl;
    server_name www.example.com;
    # 证书文件路径
    ssl_certificate /etc/nginx/ssl/www.example.com.crt;
    ssl_certificate_key /etc/nginx/ssl/www.example.com.key;

    # 加密套件与协议优化
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_session_tickets off;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    root /data/web/static/html;
    location /api/ {
        proxy_pass http://backend_pool;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# 2.80端口强制跳转HTTPS
server {
    listen 80;
    server_name www.example.com;
    return 301 https://$host$request_uri;
}
EOF

# 证书目录创建，上传crt、key文件
mkdir -p /etc/nginx/ssl
# 证书权限加固，禁止其他用户读取
chmod 600 /etc/nginx/ssl/*

# 校验重载
nginx -t && nginx -s reload

# 核心速记
# 1.证书：ssl_certificate公钥crt，ssl_certificate_key私钥key
# 2.强制加密：80端口301跳转HTTPS
# 3.性能优化：仅保留TLS1.2/1.3、服务端优先加密套件、开启ssl会话缓存减少握手开销
# 4.HSTS头强制浏览器永久使用HTTPS，避免中间人劫持
```

### 7）Rewrite 重写规则（中级难点）

- 正则匹配、flag 标记 last/break/redirect/permanent
- 目录跳转、伪静态、域名迁移、防盗链实现

```md
# Nginx Rewrite重写规则 生产精简手册（中级难点）
# ====================== 1.四大flag标记核心区分 ======================
# last：匹配后重新走所有location，常用内部转发
# break：匹配后终止规则，不再重新匹配location
# redirect 302临时重定向，浏览器地址变更
# permanent 301永久重定向，浏览器缓存跳转记录
cat > /etc/nginx/conf.d/rewrite-demo.conf <<'EOF'
server {
    listen 80;
    server_name test.com www.test.com;
    root /data/www/html;

    # 1.伪静态：动态接口伪装静态页面
    rewrite ^/detail-(\d+)\.html$ /detail?id=$1 last;

    # 2.目录跳转，末尾加斜杠
    rewrite ^/article$ /article/ permanent;

    # 3.域名迁移：旧域名301永久跳新域名
    if ($host = old.test.com) {
        rewrite ^/(.*)$ https://new.test.com/$1 permanent;
    }

    # 4.防盗链：非本站来源拦截图片资源
    location ~* \.(jpg|png|gif|js|css)$ {
        valid_referers none blocked test.com *.test.com;
        if ($invalid_referer) {
            return 403;
        }
        expires 7d;
    }

    # 5.break示例：匹配后停止规则，不二次匹配location
    rewrite ^/static/ /data/static/ break;
}
EOF

# ====================== 2.正则匹配基础 ======================
# ^ 开头、$ 结尾、()捕获参数、.*任意字符、\d数字、~*不区分大小写正则匹配

# ====================== 3.实操校验 ======================
nginx -t && nginx -s reload

# ====================== 速记总结 ======================
# last/break 内部跳转不换地址；redirect(302临时) permanent(301永久) 外部跳转
# 四大场景：伪静态、目录补斜杠、域名迁移、图片防盗链
# 防盗链依靠valid_referers校验请求来源，非法referer返回403
```

### 8）Nginx 安全防护

- IP 黑白名单
- limit_req 限流防 CC
- limit_conn 并发连接限制
- Referer 防盗链
- 隐藏版本号

```md
# Nginx安全防护全套生产配置 精简手册
cat > /etc/nginx/conf.d/nginx-sec.conf <<'EOF'
http {
    # 1.隐藏Nginx版本号，避免漏洞针对性扫描
    server_tokens off;

    # 2.limit_req 请求限流防CC：单IP每秒最多5请求，突发缓冲10个
    limit_req_zone $binary_remote_addr zone=req_limit:10m rate=5r/s;
    # 3.limit_conn 并发连接限制：单IP最大并发20连接
    limit_conn_zone $binary_remote_addr zone=conn_limit:10m;

    # 4.IP黑白名单全局定义
    geo $ip_blacklist {
        default 0;
        192.168.1.100 1; # 拉黑恶意IP
    }
    geo $ip_whitelist {
        default 1;
        10.0.0.0/8 0; # 内网白名单不受限流限制
    }

    server {
        listen 80;
        server_name www.example.com;
        root /data/www/html;

        # 黑名单拦截
        if ($ip_blacklist) {
            return 444;
        }
        # 白名单跳过限流，其余IP启用限流
        if ($ip_whitelist = 1) {
            limit_req zone=req_limit burst=10 nodelay;
            limit_conn conn_limit 20;
        }

        # 5.Referer防盗链，拦截盗图爬虫
        location ~* \.(jpg|png|gif|ico|js|css)$ {
            valid_referers none blocked www.example.com *.example.com;
            if ($invalid_referer) {
                return 403;
            }
            expires 7d;
        }
    }
}
EOF

# 配置校验重载
nginx -t && nginx -s reload

# 速记要点
# 1.server_tokens off 隐藏版本，减少攻击面
# 2.limit_req 限制请求频率防CC；limit_conn 限制单IP并发连接
# 3.geo模块配置IP黑白名单，恶意IP直接444断开
# 4.valid_referers校验访问来源，非法引用返回403防盗链
# 5.内网可信IP加入白名单，免除限流拦截
```

### 9）性能调优（生产必做）

- worker 进程数、最大连接数
- epoll 事件模型调优
- 文件句柄优化
- TCP 内核参数配套调优
- 超时时间优化

```md
# Nginx生产性能全套调优配置
cat > /etc/nginx/conf.d/nginx-tune.conf <<'EOF'
# main全局块
worker_processes auto;                  # 自动匹配CPU核心数
worker_cpu_affinity auto;               # CPU亲和绑定，减少上下文切换
worker_rlimit_nofile 65535;             # 单进程最大文件句柄

# events块
events {
    use epoll;                           # Linux高性能IO多路复用模型
    worker_connections 10240;            # 单worker最大并发连接
    multi_accept on;                     # 一次性接收多条连接
}

# http全局调优
http {
    sendfile on;                         # 零拷贝传输文件，降低CPU
    tcp_nopush on;                       # 合并小包发送，减少网络交互
    tcp_nodelay on;

    # 超时优化
    keepalive_timeout 60;                # HTTP长连接超时
    client_header_timeout 10s;
    client_body_timeout 10s;
    send_timeout 15s;

    # 文件缓存元数据
    open_file_cache max=65535 inactive=60s;
    open_file_cache_valid 80s;
    open_file_cache_min_uses 2;
}
EOF

# 系统内核TCP参数调优 /etc/sysctl.conf
cat >> /etc/sysctl.conf <<'EOF'
# 调高全局文件句柄上限  # 整机所有进程（nginx、mysql、redis、ssh 等）打开的文件、socket、管道总和上限。
fs.file-max = 1048576
# TCP端口范围扩大
net.ipv4.ip_local_port_range = 1024 65535
# 快速回收TIME_WAIT连接
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
# TCP缓冲区调大
net.core.somaxconn = 65535
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
EOF
sysctl -p

# Nginx运行用户句柄限制 /etc/security/limits.conf
# 单个进程能打开的最大文件句柄数 作用于 nginx 运行用户：
# 软限制能调整到的最大值，root 才能修改 hard；soft 不能超过 hard。
cat >> /etc/security/limits.conf <<'EOF'
nginx soft nofile 65535
nginx hard nofile 65535
EOF

# 校验重载
nginx -t && nginx -s reload

# 速记
# 1.worker：auto进程数 + 大nofile句柄限制
# 2.events：epoll模型、调高单进程连接数
# 3.应用层：sendfile零拷贝、各类请求超时收紧
# 4.系统层：内核TCP参数、全局文件句柄、limits软硬限制



## sendfile on; 零拷贝通俗理解
### 无 sendfile（传统 read+write）流程，多次内存拷贝、耗 CPU：
1. 磁盘文件 → 内核缓冲区（拷贝 1）
2. 内核缓冲区 → 用户进程内存（read，拷贝 2）
3. 用户内存 → 内核 socket 缓冲区（write，拷贝 3）
4. socket 缓冲区 → 网卡发送

### sendfile 零拷贝机制：
系统调用直接在内核态完成数据转发，**跳过用户进程内存**，只 1 次内核内拷贝：
磁盘文件 → 内核缓冲区 → 网卡 socket，全程不经过 nginx 应用内存。

### 收益
1. 大幅减少 CPU 拷贝开销，静态文件、图片、JS/CSS 吞吐性能提升
2. 减少内存占用，高并发静态场景必开

## 精简速记
1. fs.file-max：整机全局总句柄上限；
2. soft nofile：进程日常可用上限；hard nofile：最大可调天花板；
3. sendfile 零拷贝：数据不走应用内存，内核直接转发，降低 CPU。
```

### 10）日志体系与轮转

- access_log/error_log 日志字段解读
- 日志切割 logrotate 生产配置
- 按天切割、延迟压缩、保留 30 天

```md
# Nginx日志体系+logrotate轮转生产配置
# 1. 自定义日志格式、站点分离日志
cat > /etc/nginx/conf.d/nginx-log.conf <<'EOF'
http {
    # 完整日志字段模板
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
}

server {
    listen 80;
    server_name www.example.com;
    # 站点独立访问/错误日志
    access_log /data/logs/www.example.com/access.log main;
    error_log  /data/logs/www.example.com/error.log warn;
}
EOF

# 2. 创建日志目录并授权
mkdir -p /data/logs/www.example.com
chown nginx:nginx /data/logs/www.example.com

# 3. logrotate 生产规则：按天切割、保留30天、延迟压缩
cat > /etc/logrotate.d/nginx-web <<'EOF'
# 匹配该站点下所有日志文件
/data/logs/www.example.com/\*.log {
    daily               # 切割周期：每天执行一次日志分割
    rotate 30           # 最多保留30份历史归档日志，超过自动删除最旧文件
    compress            # 开启gzip压缩归档日志，节省磁盘空间
    delaycompress       # 延迟压缩：刚切割出来的当天日志不压缩，次日再压
    missingok           # 日志文件不存在时不报错，避免定时任务告警
    notifempty          # 日志为空时不执行切割，减少无用空文件
    sharedscripts       # 所有匹配日志切割完成后，仅执行一次postrotate脚本
    postrotate
        # 通知nginx重新打开日志文件句柄，避免继续往旧归档文件写日志
        /usr/sbin/nginx -s reopen > /dev/null 2>&1
    endscript
}
EOF
# 关键补充解释
# 1. delaycompress 作用：当天日志需要实时排查问题，不压缩方便直接查看；次日再压缩归档
# 2. sharedscripts：多日志文件时，不会每条日志都执行一次nginx reopen，只执行一次提升效率
# 3. nginx -s reopen：区别reload，只重新打开日志，不重载配置、不中断连接，开销极小
# 4. rotate 30：满足企业30天日志留存审计规范


# 校验重载
nginx -t && nginx -s reload

# 速记
# 1.access日志记录全量请求信息，error日志记录报错，warn级别平衡日志量与排错
# 2.daily每日切割，rotate30留存30天归档
# 3.delaycompress本轮日志暂不压缩，避免占用IO；postrotate发送reopen重新生成日志文件
```

### 11）Nginx 故障排查体系

- 502/504/403/404 根因定位
- 端口占用、 upstream 后端宕机
- 连接打满、限流触发、文件权限问题

```md
# Nginx 线上故障排查体系 精简配置+定位手册
# ====================== 一、常见错误码根因定位 ======================
## 1. 403 Forbidden 禁止访问
# 诱因：
# 1.站点目录/文件权限不足，nginx用户无读权限
# 2.目录下无index首页文件
# 3.防盗链规则拦截、IP黑名单拦截
# 4.SELinux拦截站点目录访问
# 排查命令
ls -ld /data/www/html
chmod 750 /data/www/html && chown www:nginx /data/www/html
setenforce 0  # 临时关闭selinux验证

## 2. 404 Not Found 页面不存在
# 诱因：
# root站点路径配置错误、文件丢失、location匹配覆盖URI、proxy_pass路径写错
# 排查：核对server块root路径、检查本地文件是否存在

## 3. 502 Bad Gateway 网关错误
# 诱因：
# 1.upstream后端服务未启动/宕机
# 2.后端端口未监听、防火墙拦截后端端口
# 3.后端进程崩溃、内存溢出
# 排查命令
netstat -lntp | grep 8080
curl http://127.0.0.1:8080
tail -f /var/log/nginx/error.log

## 4. 504 Gateway Time-out 网关超时
# 诱因：
# proxy_read_timeout 时间太短，后端接口执行缓慢阻塞
# 后端数据库慢查询、死锁导致响应超时
# 解决：调大 proxy_read_timeout 60s

# ====================== 二、后端&端口类故障 ======================
## 1. 端口占用（Nginx启动失败）
# 排查
ss -lntp | grep :80
kill -9 占用进程 || 修改nginx listen端口

## 2. upstream后端宕机自动剔除失效
# 检查max_fails/fail_timeout参数，查看error日志大量connect() failed
# 修复：调整失败重试阈值，检查后端服务健康状态

# ====================== 三、高并发限流/连接打满故障 ======================
## 1. 大量 429 Too Many Requests
# 诱因：limit_req限流规则触发，单IP请求频率超限
# 临时处理：调高rate速率、内网IP加入白名单免限流

## 2. 大量 503 Service Unavailable
# 诱因：limit_conn并发连接打满、后端节点全部宕机无可用节点
# 排查：error日志提示 connections limit exceeded

## 3. 连接数打满/too many open files
# 诱因：文件句柄上限不足
# 核查三层限制
ulimit -n
cat /proc/sys/fs/file-max
grep nofile /etc/security/limits.conf

# ====================== 三、统一排查流程 ======================
# 1. 优先查看站点独立error.log，精准捕获报错堆栈
# 2. 验证后端服务裸访问 curl 127.0.0.1:port
# 3. 核对目录权限、SELinux状态
# 4. 检查限流、并发、文件句柄内核限制
# 5. 校验nginx配置 nginx -t

# 速记总结
# 4xx客户端侧：403权限/selinux；404路径文件缺失
# 5xx服务侧：502后端挂了；504后端响应慢超时
# 端口占用：ss命令查监听；连接爆满：调句柄、限流阈值
```

## 2. Apache（了解即可）

- 虚拟主机、rewrite、访问控制
- 仅做老旧业务维护兼容

```md
# Apache 基础了解（仅老旧业务兼容维护）
# 1. 虚拟主机配置示例
cat > /etc/httpd/conf.d/demo.conf <<'EOF'
<VirtualHost *:80>
    ServerName shturl.cc/u
    DocumentRoot "/data/old-web/html"
    ErrorLog "/data/old-web/logs/error.log"
    CustomLog "/data/old-web/logs/access.log" combined
</VirtualHost>
EOF

# 2. rewrite 伪静态/跳转规则
cat >> /etc/httpd/conf.d/demo.conf <<'EOF'
RewriteEngine On
# 伪静态
RewriteRule ^detail-(\d+)\.html$ /detail.php?id=$1 [L]
# 301域名跳转
RewriteCond %{HTTP_HOST} ^shturl.cc/u
RewriteRule ^(.*)$ shturl.cc/7f9QI5LLbj$1 [R=301,L]
EOF

# 3. 访问控制（IP黑白名单）
cat >> /etc/httpd/conf.d/demo.conf <<'EOF'
<Directory "/data/old-web/html">
    Require all granted
    Require ip 192.168.1.0/24
    Require not ip 192.168.1.100
</Directory>
EOF

# 启停校验
httpd -t
systemctl restart httpd

# 速记
# Apache适用场景：遗留PHP老项目，新项目统一使用Nginx
# 核心三要素：VirtualHost虚拟主机、mod_rewrite重写、Directory目录访问控制
# 性能、并发、运维便捷度弱于Nginx，仅做兼容维护
```

## Apache vs Nginx 核心对比表

| 对比维度  | Apache                        | Nginx                             |
| ----- | ----------------------------- | --------------------------------- |
| 核心架构  | 多进程/多线程同步阻塞模型                 | 多进程单线程+epoll异步非阻塞模型               |
| 并发能力  | 千级并发性能衰减明显，高并发场景瓶颈大           | 万级高并发支撑能力强，IO密集型场景性能优异            |
| 资源占用  | 内存、CPU开销高，进程臃肿                | 轻量极简，内存消耗极低，同并发下仅为Apache的1/5~1/10 |
| 配置体系  | 全局配置+.htaccess目录级分布式配置，灵活但易混乱 | 全局+server+location层级化配置，语法严谨，维护性强 |
| 核心优势  | 对老旧PHP生态兼容友好，动态语言适配成熟         | 反向代理、负载均衡、动静分离、限流、HTTPS优化能力拉满     |
| 适用场景  | 仅用于老旧PHP遗留系统维护                | 新项目、高并发网站、反向代理、API网关主流首选          |
| 热更新能力 | 配置重载会短暂阻塞业务，无真正平滑重启           | 配置重载全程无业务中断，支持热升级                 |
| 扩展能力  | 模块同步阻塞，扩展性能受限                 | 支持动态模块、第三方扩展（Lua/OpenResty），生态更灵活 |

核心精简总结

- 老旧PHP遗留系统维护选Apache，**所有新项目、高并发场景统一选Nginx**
- 两者核心差距来自底层并发模型：Nginx异步非阻塞架构天然适配高并发Web场景，Apache同步阻塞架构仅适配低并发动态业务

## nginx 知识点总结

```md
# CentOS Yum 安装 Nginx 默认目录结构（Markdown）
/etc/nginx/                  # 核心配置总目录
├── nginx.conf               # 主配置文件
├── conf.d/                  # 站点独立配置目录（自动加载所有*.conf）
├── modules/                 # 动态模块加载目录
├── snippets/                # 公共配置片段（ssl、代理头部等）
├── mime.types               # 媒体类型映射
├── fastcgi_params           # FastCGI代理参数
├── scgi_params
├── uwsgi_params
/usr/sbin/nginx              # Nginx二进制执行程序
/usr/lib64/nginx/modules/    # 模块库文件
/usr/share/nginx/html/       # 默认网站静态根目录（欢迎页）
/var/log/nginx/              # 日志目录
├── access.log               # 全局访问日志
└── error.log                # 全局错误日志
/var/cache/nginx/            # 代理缓存、临时文件目录
/etc/logrotate.d/nginx       # Nginx日志切割规则
/usr/lib/systemd/system/nginx.service  # systemd服务单元文件
/run/nginx.pid               # 运行PID文件

路径                        类型         核心作用
/etc/nginx/nginx.conf    主配置    全局 worker、events、http 公共参数入口，自动 include conf.d
/etc/nginx/conf.d/        站点配置目录    每个站点单独新建 xxx.conf，虚拟主机、反向代理、负载均衡写此处
/etc/nginx/snippets/    配置片段    存放 ssl 通用套件、proxy_set_header 公共片段，复用简化配置
/usr/sbin/nginx            二进制程序    启动、校验、重载命令本体（nginx -t /nginx -s reload）
/usr/share/nginx/html    默认站点根目录    初始测试页面存放，正式业务一般自定义 /data/www
/var/log/nginx/            日志目录    默认全局 access/error 日志；生产建议每个站点独立日志路径
/etc/logrotate.d/nginx    日志轮转配置    yum 自带默认切割规则，可修改为按天、保留 30 天
/var/cache/nginx        缓存临时目录    代理临时缓存、客户端上传临时文件存放
/usr/lib/systemd/system/nginx.service    服务管理文件    systemctl start/stop/enable nginx 依赖文件
/run/nginx.pid            PID 文件    Nginx 主进程 ID 存储位置

## 、常用查询命令
# 查看yum安装所有文件路径
rpm -ql nginx
# 查看nginx运行用户/进程
ps aux | grep nginx
# 查看nginx监听端口
ss -lntp | grep nginx


## 四、关键运维说明
1. **多站点规范**：所有业务站点配置统一放 `/etc/nginx/conf.d/`，不修改主 nginx.conf
2. **日志改造**：生产不使用默认全局日志，每个 server 单独指定日志到自定义目录 `/data/logs/xxx/`
3. **证书存放**：建议自建 `/etc/nginx/ssl/` 存放 crt/key，权限设 600
4. **区别源码安装**：yum 安装遵循 Linux 标准 FHS 分散目录；源码编译全部集中在 `/usr/local/nginx`
```

```nginx
# ==============================
# Nginx全套生产整合配置（覆盖11大知识点，逐段标注对应模块）
# 知识点：1.多进程架构调优 | 2.虚拟主机 | 3.反向代理 | 4.负载均衡
# 5.动静分离 | 6.HTTPS全站加密 | 7.Rewrite重写 | 8.安全防护
# 9.性能调优 | 10.日志与轮转 | 11.故障排查相关配置
# ==============================

# ====================== 全局main块：1.多进程架构 + 9.性能调优（进程/句柄） ======================
worker_processes auto;                 # 9.性能调优：进程数自动匹配CPU核心
worker_cpu_affinity auto;              # 9.性能调优：CPU亲和，减少上下文切换
worker_rlimit_nofile 65535;             # 9.性能调优：单进程最大文件句柄，解决too many open files

# ====================== events块：9.性能调优 epoll模型、并发连接 ======================
events {
    use epoll;                          # 9.性能调优：Linux IO多路复用异步模型
    worker_connections 10240;           # 9.性能调优：单个worker最大并发连接
    multi_accept on;                    # 9.性能调优：一次性接收多条TCP连接
}

# ====================== http块：公共通用配置，覆盖安全、限流、日志、缓存、代理 ======================
http {
    include       mime.types;
    default_type  application/octet-stream;

    # ---------------- 10.日志体系：自定义日志字段模板 ----------------
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    # ---------------- 8.安全防护：隐藏版本号，减少攻击面 ----------------
    server_tokens off;

    # ---------------- 8.安全防护：限流防CC、并发连接限制 ----------------
    # limit_req：限制单IP每秒请求频率，防CC攻击
    limit_req_zone $binary_remote_addr zone=req_zone:10m rate=5r/s;
    # limit_conn：限制单IP最大并发连接数
    limit_conn_zone $binary_remote_addr zone=conn_zone:10m;

    # ---------------- 9.性能调优：零拷贝、网络优化、超时控制 ----------------
    sendfile on;                        # 零拷贝，减少CPU内存拷贝开销
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 60;               # HTTP长连接超时
    client_header_timeout 10s;
    client_body_timeout 10s;
    send_timeout 15s;

    # 文件元数据缓存，降低磁盘IO
    open_file_cache max=65535 inactive=60s;
    open_file_cache_valid 80s;
    open_file_cache_min_uses 2;

    # ---------------- 3.反向代理：全局代理超时、缓冲统一配置 ----------------
    proxy_connect_timeout 30s;
    proxy_read_timeout 60s;
    proxy_send_timeout 60s;
    proxy_buffering on;
    proxy_buffer_size 4k;
    proxy_buffers 8 4k;

    # ---------------- 4.负载均衡 upstream模块 ----------------
    upstream backend_pool {
        # 权重策略：硬件性能不均时按比例分配流量
        server 192.168.1.11:8080 weight=3 max_fails=2 fail_timeout=30s;
        server 192.168.1.12:8080 weight=1 max_fails=2 fail_timeout=30s;
        # max_fails/fail_timeout：被动健康检查，失败自动剔除节点
        # 灰度发布：调整weight比例；下线维护：weight=0不接收新连接
        # ip_hash;       # 会话保持，老旧本地session场景专用，生产优先Redis共享session
        # least_conn;    # 优先分配给连接最少后端，长连接业务
        keepalive 32;   # 3.反向代理：后端长连接复用，减少TCP握手
    }

    # ====================== 2.虚拟主机1：80站点 + 6.HTTPS跳转 ======================
    server {
        listen 80;
        server_name www.example.com; # 基于域名虚拟主机
        # 6.HTTPS：HTTP全部301永久跳转加密站点
        return 301 https://$host$request_uri;
    }

    # ====================== 2.虚拟主机2：443 HTTPS全站加密 ======================
    server {
        listen 443 ssl;
        server_name www.example.com;
        root /data/www/www.example.com/html;
        index index.html;

        # 6.HTTPS：证书配置
        ssl_certificate /etc/nginx/ssl/www.example.com.crt;
        ssl_certificate_key /etc/nginx/ssl/www.example.com.key;
        # 6.加密套件、协议优化
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_prefer_server_ciphers on;
        ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

        # 10.日志：站点独立访问、错误日志，日志分离
        access_log /data/logs/www.example.com/access.log main;
        error_log /data/logs/www.example.com/error.log warn;

        # 8.安全防护：IP黑白名单（内网白名单免除限流）
        geo $black_ip { default 0; 192.168.1.100 1; }
        if ($black_ip) { return 444; } # 恶意IP直接断开

        # 8.安全防护：全局启用限流、并发限制
        limit_req zone=req_zone burst=10 nodelay;
        limit_conn conn_zone 20;

        # ---------------- 5.动静分离：静态资源本地处理、浏览器缓存 ----------------
        location ~* \.(jpg|png|gif|ico|css|js|woff)$ {
            root /data/www/www.example.com/static;
            expires 30d;        # 图片长缓存
            access_log off;     # 静态关闭日志，减少磁盘IO
            # 8.安全防护 Referer防盗链
            valid_referers none blocked www.example.com *.example.com;
            if ($invalid_referer) { return 403; }
        }

        # ---------------- 7.Rewrite重写规则：伪静态、目录补斜杠 ----------------
        rewrite ^/detail-(\d+)\.html$ /detail?id=$1 last; # last内部转发重新匹配location
        rewrite ^/article$ /article/ permanent;           # permanent 301永久跳转

        # ---------------- 3.反向代理：动态接口转发后端Java/Tomcat ----------------
        location /api/ {
            proxy_pass http://backend_pool; # 无/，完整拼接URI；加/会截取匹配前缀
            # 透传真实客户端IP、域名、请求协议
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            # 4.负载均衡：后端故障自动切换节点
            proxy_next_upstream error timeout http_502 http_503 http_504;
            proxy_next_upstream_tries 2;
            # 后端长连接配套
            proxy_http_version 1.1;
            proxy_set_header Connection "";
        }
    }
}

# ====================== 配套运维&故障知识点（配置文件外操作，注释记录） ======================
# 【10.日志轮转配套】/etc/logrotate.d/nginx-web
# /data/logs/www.example.com/*.log {
#     daily; rotate 30; compress; delaycompress; missingok; notifempty; sharedscripts
#     postrotate
#         /usr/sbin/nginx -s reopen > /dev/null 2>&1 # 重新打开日志句柄，不重载配置
#     endscript
# }

# 【11.故障排查对应配置报错场景】
# 403：目录权限不足、无index、防盗链拦截、SELinux
# 404：root路径错误、文件缺失、location覆盖
# 502：upstream后端未启动、端口占用、服务崩溃
# 504：proxy_read_timeout过小、后端接口慢阻塞
# 429：limit_req限流触发；503：limit_conn连接打满/无可用后端
# too many open files：调worker_rlimit_nofile、limits.conf、fs.file-max

# 配置校验与重载命令
# nginx -t        # 语法校验，防止配置错误宕机
# nginx -s reload # 平滑重载，无业务中断
# nginx -s reopen # 仅切换日志文件，性能损耗极低
```

---

# 二、数据库 & 缓存中间件（中级运维核心饭碗）

## 1. MySQL 运维全栈（生产重中之重）

### 1）生产部署

- YUM / 二进制 生产安装
- 多实例部署（3306/3307 多端口）
- 初始化安全配置、密码策略、远程权限

```md
# MySQL生产部署运维手册（YUM+二进制+多实例+安全初始化）
## 一、YUM在线安装 MySQL8.0（CentOS7/8 生产标准）
### 1. 安装流程

# 1. 导入官方yum源
rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum makecache

# 2. 安装服务端+客户端
yum install -y mysql-community-server mysql-community-client

# 3. 启动开机自启
systemctl start mysqld
systemctl enable mysqld

### 2. YUM默认目录结构
| 路径 | 作用 |
|------|------|
| `/etc/my.cnf` | 主配置文件 |
| `/var/lib/mysql/` | 默认数据目录、ibdata、binlog |
| `/var/log/mysqld.log` | 错误日志 |
| `/usr/bin/mysql/mysqldump` | 客户端工具 |
| `/usr/lib/systemd/system/mysqld.service` | 服务管理文件 |

### 3. 初始化安全配置

# 获取临时初始密码
grep 'temporary password' /var/log/mysqld.log

# 安全初始化脚本（生产必执行）
mysql_secure_installation
# 交互配置项：
# 1. 修改root初始密码
# 2. 开启密码强度校验策略
# 3. 删除匿名用户
# 4. 关闭root本地之外远程登录
# 5. 删除test测试库
# 6. 刷新权限


### 4. 开启远程访问权限
-- 8.0 密码认证插件caching_sha2_password
CREATE USER 'root'@'%' IDENTIFIED BY 'Root@123456';
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;


### 5. 密码策略调优（my.cnf）

[mysqld]
validate_password.policy=STRONG
validate_password.length=10
validate_password.mixed_case_on=1
validate_password.special_char_count=1


## 二、二进制包离线安装（隔离环境、定制数据盘）

### 1. 基础部署步骤

# 1. 解压到统一目录

tar -xf mysql-8.0.36-linux-glibc2.28-x86_64.tar.xz -C /usr/local/
ln -s /usr/local/mysql-8.0.36 /usr/local/mysql

# 2. 创建mysql运行用户、数据目录

useradd -s /sbin/nologin mysql
mkdir -p /data/mysql_3306
chown -R mysql:mysql /usr/local/mysql /data/mysql_3306

# 3. 初始化数据

/usr/local/mysql/bin/mysqld --initialize --user=mysql --datadir=/data/mysql_3306

# 4. 配置环境变量

echo 'export PATH=$PATH:/usr/local/mysql/bin' >> /etc/profile
source /etc/profile

# 5. 自建systemd服务管理

cat > /usr/lib/systemd/system/mysqld-3306.service <<EOF
[Unit]
Description=MySQL 3306
After=network.target

[Service]
User=mysql
Group=mysql
ExecStart=/usr/local/mysql/bin/mysqld --defaults-file=/etc/my_3306.cnf
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start mysqld-3306



## 三、多实例部署（3306/3307 多端口隔离，生产业务分库）

### 1. 多实例目录规划

/etc/
├── my_3306.cnf
└── my_3307.cnf
/data/
├── mysql_3306/
└── mysql_3307/
/var/log/mysql/
├── 3306.err
└── 3307.err


### 2. 单实例配置模板 `my_3306.cnf`

[mysqld]
port=3306
socket=/tmp/mysql3306.sock
datadir=/data/mysql_3306
pid-file=/run/mysql_3306.pid
log_error=/var/log/mysql/3306.err
server-id=3306

# 基础性能参数
character-set-server=utf8mb4
default-storage-engine=InnoDB
innodb_buffer_pool_size=2G


### 3. 3307实例仅修改端口、datadir、server-id、socket

### 4. 多实例启停命令


# 启动3307
systemctl start mysqld-3307
# 本地登录指定实例
mysql -S /tmp/mysql3307.sock -uroot -p
# 远程连接
mysql -h127.0.0.1 -P3307 -uroot -p


## 四、生产初始化核心规范总结

1. **安装选型**
   - 内网可联网服务器：YUM安装，运维简单
   - 隔离离线环境、高性能定制磁盘：二进制包
2. **多实例适用场景**
   - 服务器资源充足、业务库隔离、区分读写/测试库，不额外采购机器
3. **安全硬性规范**
   - 必须执行`mysql_secure_installation`
   - 强密码策略、大小写+数字+特殊字符、长度≥10
   - 禁止生产root无限制%远程，按需分配最小权限账号
   - 数据目录权限仅mysql用户可读，禁止777
4. **权限最小化**
   业务账号仅授予对应库SELECT/INSERT/UPDATE/DELETE，杜绝ALL PRIVILEGES
```

### 2）权限体系

- 用户创建、授权、回收权限
- 精细化业务账号、最小权限原则
- 禁止 root 远程登录

```md
# MySQL 权限体系生产实操（最小权限原则）
## 一、基础语法：创建用户、授权、回收、删除
### 1. 创建业务用户（MySQL8.0）
-- 格式：CREATE USER '账号'@'访问主机' IDENTIFIED BY '强密码';
-- 仅本地访问
CREATE USER 'biz_user'@'localhost' IDENTIFIED BY 'Biz@123456';
-- 内网网段访问
CREATE USER 'biz_user'@'192.168.%' IDENTIFIED BY 'Biz@123456';
-- 禁止 root@% 全局远程，只允许本地登录root
CREATE USER 'root'@'localhost' IDENTIFIED BY 'Root@Admin789';
-- 删除危险全局root（生产必执行）
DROP USER IF EXISTS 'root'@'%';
FLUSH PRIVILEGES;


### 2. 精细化授权（最小权限，禁止 ALL PRIVILEGES）

-- 语法：GRANT 权限列表 ON 库名.表 TO '用户'@'主机';
-- 场景1：普通业务读写账号（单库）
GRANT SELECT,INSERT,UPDATE,DELETE ON business_db.* TO 'biz_user'@'192.168.%';

-- 场景2：只读分析账号（报表、数据查询）
GRANT SELECT ON business_db.* TO 'read_user'@'192.168.%';

-- 场景3：DBA运维账号（仅管理库权限，不开放业务数据全量操作）
GRANT PROCESS,RELOAD,REPLICATION SLAVE,REPLICATION CLIENT ON *.* TO 'dba_admin'@'192.168.%';

-- 刷新权限，立即生效
FLUSH PRIVILEGES;


常用细分权限：

- DML：SELECT/INSERT/UPDATE/DELETE（业务必备）
- DDL：CREATE/DROP/ALTER（仅给运维，业务账号不授予）
- 运维：PROCESS（查看进程）、RELOAD（刷新配置）、REPLICATION（主从复制）

### 3. 回收权限

-- 回收指定库写权限
REVOKE INSERT,UPDATE,DELETE ON business_db.* FROM 'biz_user'@'192.168.%';
FLUSH PRIVILEGES;


### 4. 删除无用账号
DROP USER IF EXISTS 'test_user'@'%';
FLUSH PRIVILEGES;


## 二、查看权限相关命令
-- 查看当前用户权限
SHOW GRANTS;
-- 查看指定用户权限
SHOW GRANTS FOR 'biz_user'@'192.168.%';
-- 查看所有用户
SELECT user,host FROM mysql.user;


## 三、生产权限规范（核心要点）

1. **禁止 root 远程登录**

   - 删除 `root@%` 用户，root 仅保留 `localhost` 本地登录；
   - 远程运维单独创建DBA专用账号，不共用root。

2. **严格最小权限原则**

   - 业务账号只分配业务库，禁止 `*.*` 全库权限；
   - 区分读写账号：业务读写、报表只读分离；
   - 普通业务账号不授予 ALTER/DROP/CREATE 等DDL高危权限。

3. **访问主机限制**

   - 不使用 `%` 无限制通配；
   - 限定内网IP/网段（如`192.168.%`），公网禁止数据库端口暴露。

4. **账号生命周期管理**

   - 离职、下线业务及时回收权限、删除账号；
   - 定期执行 `SELECT user,host FROM mysql.user` 清理僵尸匿名用户、测试账号。

## 四、生产安全加固脚本示例

-- 1. 删除全局root
DROP USER IF EXISTS 'root'@'%';
-- 2. 删除匿名用户
DROP USER IF EXISTS ''@'localhost';
DROP USER IF EXISTS ''@'%';
-- 3. 新建内网DBA运维账号
CREATE USER 'dba_op'@'192.168.%' IDENTIFIED BY 'Dba@Op2026';
GRANT PROCESS,RELOAD,REPLICATION SLAVE,REPLICATION CLIENT ON *.* TO 'dba_op'@'192.168.%';
-- 4. 业务读写账号
CREATE USER 'app_biz'@'192.168.%' IDENTIFIED BY 'App@Biz666';
GRANT SELECT,INSERT,UPDATE,DELETE ON app_db.* TO 'app_biz'@'192.168.%';
FLUSH PRIVILEGES;
```

### 3）日志体系

- error_log 错误日志排障
- slow_query_log 慢查询开启、分析、优化
- binlog 二进制日志：作用、三种格式、日志截取恢复

```md
# ==================================================
# MySQL 三大日志体系 生产实操手册
# 1.error_log 故障排障 | 2.slow_query_log 性能优化 | 3.binlog 主从+数据恢复
# ==================================================

# --------------------------
# 1. error_log 错误日志（排障第一入口）
# 作用：记录启动/运行/停止过程中所有错误、警告、异常信息
# --------------------------
cat >> /etc/my.cnf <<'EOF'
[mysqld]
# 指定错误日志文件路径
log_error = /var/log/mysql/mysqld.err
# 记录警告级以上信息，生产建议开启
log_warnings = 2
EOF

# 实时排查命令
tail -f /var/log/mysql/mysqld.err          # 实时追踪报错
grep "ERROR" /var/log/mysql/mysqld.err    # 过滤所有错误行
# 常见报错场景：端口占用、数据目录权限、内存不足、主从同步中断、表损坏

# --------------------------
# 2. slow_query_log 慢查询日志（SQL性能优化核心）
# 作用：记录执行时间超过阈值的SQL，定位低效SQL做索引优化
# --------------------------
cat >> /etc/my.cnf <<'EOF'
[mysqld]
# 开启慢查询日志
slow_query_log = ON
# 慢查询日志文件路径
slow_query_log_file = /var/log/mysql/slow.log
# 慢查询阈值：执行时间超过1秒的SQL记录（单位：秒）
long_query_time = 1
# 记录未使用索引的SQL，即使执行快也记录
log_queries_not_using_indexes = ON
# 慢查询记录行数阈值，避免大量小查询刷屏
min_examined_row_limit = 100
EOF

# 慢查询分析工具 mysqldumpslow（MySQL自带）
# 按访问次数排序，取Top10慢SQL
mysqldumpslow -s c -t 10 /var/log/mysql/slow.log
# 按查询总耗时排序，取Top10
mysqldumpslow -s t -t 10 /var/log/mysql/slow.log
# 按平均耗时排序
mysqldumpslow -s at -t 10 /var/log/mysql/slow.log
# 带like模糊匹配，只查select语句
mysqldumpslow -s t -t 10 -g "select" /var/log/mysql/slow.log

# --------------------------
# 3. binlog 二进制日志（核心：主从复制 + 数据误删恢复）
# 作用：1.主从复制数据同步 2.增量备份 3.误操作数据闪回
# --------------------------
## 3.1 三种格式说明
# STATEMENT：记录执行的SQL语句，日志体积小；但函数/触发器会导致主从不一致，已淘汰
# ROW：记录每行数据的变更，日志体积大；数据准确无歧义，生产默认标准
# MIXED：混合模式，普通SQL用STATEMENT，不确定操作自动切ROW，兼容场景用

cat >> /etc/my.cnf <<'EOF'
[mysqld]
# 开启binlog，指定日志前缀（自动生成 mysql-bin.000001 递增文件）
log_bin = /var/lib/mysql/mysql-bin
# 生产标准格式：ROW行级模式，数据一致性最高
binlog_format = ROW
# 服务唯一ID，主从必须不同
server-id = 1
# binlog过期自动清理天数，生产保留7-30天
expire_logs_days = 7
# 单个binlog文件最大大小，默认1G
max_binlog_size = 1G
# 开启binlog行模式附加信息，方便闪回解析
binlog_rows_query_log_events = ON
EOF

## 3.2 常用运维命令
mysql -e "show variables like '%log_bin%';"    # 查看binlog是否开启
mysql -e "show binary logs;"                   # 查看所有binlog文件
mysql -e "show master status;"                 # 查看当前正在写入的binlog和位置点
mysql -e "flush logs;"                         # 手动滚动生成新binlog文件

## 3.3 binlog查看与数据恢复
# 文本方式查看binlog（ROW模式需加-vv解析行数据）
mysqlbinlog -vv /var/lib/mysql/mysql-bin.000001 | less

# 按时间范围截取binlog，导出为SQL用于恢复
mysqlbinlog --start-datetime="2026-07-14 09:00:00" \
            --stop-datetime="2026-07-14 12:00:00" \
            /var/lib/mysql/mysql-bin.000001 > /tmp/recover.sql

# 按精确位置点恢复（精准度最高，推荐生产使用）
mysqlbinlog --start-position=156 --stop-position=1200 \
            /var/lib/mysql/mysql-bin.000001 | mysql -uroot -p

# --------------------------
# 核心速记
# --------------------------
# 1. 出问题先看error_log：启动失败、主从断连、权限报错一目了然
# 2. 慢查询优化流程：开slow_log → mysqldumpslow定位TopN → 加索引/改写SQL
# 3. binlog生产必开：ROW格式为主从和数据兜底，误删靠时间点/位置点闪回恢复
```

### 4）索引优化基础（运维必备）

- 普通索引、唯一索引、联合索引最左匹配
- 慢 SQL 定位、explain 执行计划看懂
- 避免索引失效场景

```md
# ==================================================
# MySQL 索引优化基础（运维必备）
# 1. 核心索引类型 + 联合索引最左匹配原则
# 2. 慢SQL定位 + explain执行计划核心字段解读
# 3. 常见索引失效场景与避坑规则
# ==================================================

# --------------------------
# 一、核心索引类型与创建规则
# --------------------------
# 1. 普通索引：最基础索引，仅用于加速查询，无数据约束
# 适用：频繁作为查询条件、无唯一性要求的字段
mysql -uroot -p -e "CREATE INDEX idx_name ON test_db.user(name);"

# 2. 唯一索引：加速查询 + 强制字段值全局唯一（允许空值）
# 适用：手机号、身份证、订单号等天然唯一的业务字段
mysql -uroot -p -e "CREATE UNIQUE INDEX idx_phone ON test_db.user(phone);"

# 3. 主键索引：特殊的唯一索引，一张表只能有一个，非空+唯一，InnoDB下为聚簇索引
# 建表时指定：PRIMARY KEY(id)，推荐自增无业务意义的ID做主键

# 4. 联合索引（复合索引）：多个字段组合成一个索引，严格遵循【最左匹配原则】
# 适用：多字段组合查询的场景，比多个单列索引性能更高
mysql -uroot -p -e "CREATE INDEX idx_age_name_sex ON test_db.user(age,name,sex);"

# ===== 最左匹配原则核心规则 =====
# 联合索引按字段定义顺序从左到右匹配，跳过左侧字段则索引整体/部分失效
# 以上面 idx_age_name_sex(age,name,sex) 为例：
# ✅ 全值匹配走全索引：where age=10 and name='张三' and sex=1
# ✅ 走左侧部分索引：where age=10
# ✅ 走左侧两列索引：where age=10 and name='张三'
# ✅ 仅最左列生效：where age=10 and sex=1 （sex列无法用到索引）
# ❌ 完全失效：where name='张三' / where sex=1 （跳过最左字段age）

# 查看表上所有索引详情
mysql -uroot -p -e "SHOW INDEX FROM test_db.user;"
# 删除索引
mysql -uroot -p -e "DROP INDEX idx_name ON test_db.user;"

# --------------------------
# 二、慢SQL定位 + explain执行计划解读
# --------------------------
# 1. 第一步：定位慢SQL
# 开启慢查询日志 → 用mysqldumpslow分析TopN慢SQL（详见日志体系章节）
# 核心命令：mysqldumpslow -s t -t 10 /var/log/mysql/slow.log

# 2. 第二步：explain 分析执行计划（运维核心技能）
# 作用：判断SQL是否走索引、扫描行数、排序方式，定位性能瓶颈
mysql -uroot -p -e "EXPLAIN SELECT * FROM test_db.user WHERE age=25;"

# ===== explain 必背核心字段 =====
# 1. type：访问类型（性能从优到劣排序）
#    system > const > eq_ref > ref > range > index > ALL
#    优化底线：杜绝 ALL（全表扫描），核心SQL至少达到 range/ref 级别
# 2. possible_keys：可能用到的索引（候选）
# 3. key：实际真正用到的索引，NULL表示索引失效
# 4. key_len：索引使用字节长度，可判断联合索引生效了几列
# 5. rows：预估扫描的行数，数值越小性能越好
# 6. Extra：额外关键信息
#    ✅ Using index：覆盖索引，无需回表查询，性能最优
#    ⚠️  Using where：引擎层过滤后返回，正常场景
#    ❌ Using filesort：文件排序，无法利用索引排序，需优化
#    ❌ Using temporary：使用临时表，常见于分组去重，性能极差

# --------------------------
# 三、常见索引失效场景（避坑指南）
# --------------------------
# 前置条件：假设name字段建有普通索引 idx_name

# 1. ❌ 索引列使用函数、算术运算、表达式
# 失效示例：SELECT * FROM user WHERE LEFT(name,2)='张';
# 原因：函数破坏索引有序性，优化器无法匹配
# 优化：改写为右模糊匹配 name LIKE '张%'

# 2. ❌ 隐式类型转换
# 失效示例：SELECT * FROM user WHERE phone = 13800138000;
# 原因：phone是字符串类型，数字对比会触发隐式转换
# 优化：严格匹配类型 phone = '13800138000'

# 3. ❌ LIKE 左模糊 / 全模糊
# 失效示例：name LIKE '%张三' / name LIKE '%张三%'
# 原因：前缀不固定，无法利用B+树有序性
# 优化：右模糊 name LIKE '张%' 可走索引；复杂模糊搜索用ES全文引擎

# 4. ❌ 联合索引不满足最左前缀
# 失效示例：联合索引idx(a,b,c)，查询条件只有b、c
# 优化：查询条件必须包含最左列，调整索引字段顺序

# 5. ❌ 负向查询：!=、<>、NOT IN、NOT EXISTS
# 失效场景：数据量大时优化器放弃索引，选择全表扫描
# 优化：业务拆分查询，或用范围查询替代负向判断

# 6. ❌ OR 连接非索引列
# 失效示例：WHERE name='张三' OR age=25 （age无索引）
# 原因：只要有一列无索引，整句索引失效
# 优化：两列都建索引，或拆分为两条SQL用UNION合并

# 7. ❌ IS NULL / IS NOT NULL（大量数据场景）
# 原因：空值占比高时，优化器认为全表扫描更快
# 优化：字段设置默认值，业务上避免NULL判断

# --------------------------
# 核心速记
# --------------------------
# 1. 索引分类：普通加速、唯一去重、联合靠最左匹配
# 2. 优化流程：慢日志捞TopN → explain查执行计划 → 加索引/改写SQL
# 3. 失效避坑：忌函数运算、忌隐式转换、忌左模糊、忌跳最左列、忌负向全表扫
```

### 5）主从复制架构（企业必备）

- 主从原理、binlog 日志推送、IO/SQL 线程
- 异步复制 / 半同步复制部署
- 主从延迟排查、偏移量报错修复
- 主从数据一致性校验

```md
# ==================================================
# MySQL 主从复制架构 生产运维手册
# 1. 核心原理 | 2. 异步复制部署 | 3. 半同步复制部署
# 4. 主从延迟/报错排查修复 | 5. 数据一致性校验
# ==================================================

# --------------------------
# 【核心原理】
# 3个线程完成数据同步：
# 1. 主库 binlog dump 线程：监听binlog变更，主动推送新日志给从库
# 2. 从库 IO 线程：接收主库binlog，写入本地 relay log（中继日志）
# 3. 从库 SQL 线程：读取relay log，重放SQL到本地数据库
#
# 复制模式区别：
# 异步复制：主库事务提交后立即返回客户端，性能最高，极端情况丢数据
# 半同步复制：主库提交后等待至少1个从库接收binlog并返回ack，一致性高，性能有损耗
# --------------------------

# --------------------------
# 一、异步复制部署（生产默认方案，性能优先）
# --------------------------
# ===== 主库（Master）配置 =====
# 1. 追加主配置文件参数
cat >> /etc/my.cnf <<'EOF'
[mysqld]
server-id = 1                    # 全局唯一ID，主从节点必须不同
log_bin = /var/lib/mysql/mysql-bin  # 开启binlog，主从复制依赖
binlog_format = ROW              # 行级模式，数据一致性最高，生产标准
expire_logs_days = 7             # binlog自动过期清理
binlog-ignore-db = mysql         # 不同步系统库
binlog-ignore-db = information_schema
binlog-ignore-db = performance_schema
EOF

# 2. 重启主库生效
systemctl restart mysqld

# 3. 创建最小权限复制账号
mysql -uroot -p <<EOF
CREATE USER 'repl_user'@'192.168.%' IDENTIFIED BY 'Repl@Pass2026';
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'repl_user'@'192.168.%';
FLUSH PRIVILEGES;
EOF

# 4. 全量备份+记录binlog位置（InnoDB用单事务备份，不锁表）
mysqldump -uroot -p --all-databases --master-data=2 --single-transaction > /tmp/full_backup.sql
# 备份文件自带binlog文件名与偏移量，也可手动查看
mysql -uroot -p -e "SHOW MASTER STATUS;"

# ===== 从库（Slave）配置 =====
# 1. 追加从库配置参数
cat >> /etc/my.cnf <<'EOF'
[mysqld]
server-id = 2                    # 必须与主库不同
relay_log = /var/lib/mysql/relay-bin  # 中继日志
read_only = ON                   # 普通用户只读，防止业务误写从库（root等super权限不受限）
# 8.0 并行复制配置，解决SQL单线程重放延迟
slave_parallel_type = LOGICAL_CLOCK
slave_parallel_workers = 4
EOF

# 2. 重启从库，导入全量备份数据
systemctl restart mysqld
mysql -uroot -p < /tmp/full_backup.sql

# 3. 配置主库连接信息，启动复制
mysql -uroot -p <<EOF
CHANGE MASTER TO
  MASTER_HOST='192.168.1.10',
  MASTER_PORT=3306,
  MASTER_USER='repl_user',
  MASTER_PASSWORD='Repl@Pass2026',
  MASTER_LOG_FILE='mysql-bin.000001',
  MASTER_LOG_POS=156;
START SLAVE;
EOF

# 4. 验证主从状态
mysql -uroot -p -e "SHOW SLAVE STATUS\G"
# 正常核心标志：
# Slave_IO_Running: Yes    IO线程正常，持续接收binlog
# Slave_SQL_Running: Yes   SQL线程正常，持续重放数据
# Seconds_Behind_Master: 0 主从延迟秒数，0表示同步完成

# --------------------------
# 二、半同步复制部署（金融/核心业务，数据一致性优先）
# --------------------------
# ===== 主库安装半同步插件 =====
mysql -uroot -p <<EOF
INSTALL PLUGIN rpl_semi_sync_master SONAME 'semisync_master.so';
SET GLOBAL rpl_semi_sync_master_enabled = 1;
SET GLOBAL rpl_semi_sync_master_timeout = 1000;  # 1秒未收到ack自动降级为异步
SET GLOBAL rpl_semi_sync_master_wait_for_slave_count = 1;  # 至少等待1个从库确认
EOF

# 主库配置永久生效
cat >> /etc/my.cnf <<'EOF'
plugin-load-add = semisync_master.so
rpl_semi_sync_master_enabled = 1
rpl_semi_sync_master_timeout = 1000
EOF

# ===== 从库安装半同步插件 =====
mysql -uroot -p <<EOF
INSTALL PLUGIN rpl_semi_sync_slave SONAME 'semisync_slave.so';
SET GLOBAL rpl_semi_sync_slave_enabled = 1;
STOP SLAVE IO_THREAD;
START SLAVE IO_THREAD;  # 重启IO线程生效
EOF

# 从库配置永久生效
cat >> /etc/my.cnf <<'EOF'
plugin-load-add = semisync_slave.so
rpl_semi_sync_slave_enabled = 1
EOF

# 验证半同步状态
mysql -uroot -p -e "SHOW STATUS LIKE 'Rpl_semi_sync_master_status';"

# --------------------------
# 三、主从故障排查与修复
# --------------------------
# 统一排查入口
mysql -uroot -p -e "SHOW SLAVE STATUS\G"
# 重点字段：Last_IO_Error / Last_SQL_Error 直接给出报错原因

# ===== 场景1：主从延迟大（Seconds_Behind_Master数值高）=====
# 常见根因：
# 1. 主库大事务：批量删改、大表DDL，从库单线程重放跟不上
# 2. 从库硬件弱：CPU/磁盘IO性能低于主库
# 3. 未开并行复制：高并发写入下SQL线程瓶颈
# 4. 跨机房网络：binlog传输延迟
# 5. 从库慢查询：大查询占用IO资源，拖慢重放

# 优化方案：
# 1. 大事务拆分为小事务分批执行
# 2. 开启LOGICAL_CLOCK并行复制（已配置）
# 3. 从库升级磁盘/CPU，避免在从库跑大报表
# 4. 读写分离做负载，分散从库查询压力

# ===== 场景2：SQL线程报错（1032/1062 数据不一致）=====
# 1062错误：主键冲突，从库已存在对应记录
# 1032错误：要更新/删除的记录在从库不存在
# 临时应急：跳过单个事务（仅非核心数据使用，确认业务无影响）
mysql -uroot -p <<EOF
STOP SLAVE;
SET GLOBAL sql_slave_skip_counter = 1;
START SLAVE;
EOF

# 批量跳过指定错误号（不推荐长期开启，仅临时应急）
# 配置文件追加：slave_skip_errors = 1062,1032

# 彻底修复：执行数据一致性校验后同步差异，或重新全量搭建主从

# ===== 场景3：IO线程异常 =====
# 常见原因：主库端口不通、复制账号密码错误、主库binlog被清理
# 排查：telnet主库3306、验证复制账号权限、核对主库binlog留存周期

# --------------------------
# 四、主从数据一致性校验与修复
# 工具：percona-toolkit 生产标准套件
# --------------------------
# 1. 安装工具
yum install -y percona-toolkit

# 2. 校验指定库数据一致性（主库执行，自动对比主从差异）
pt-table-checksum \
  --user=root --password='Root@123456' \
  --host=127.0.0.1 \
  --databases=business_db \
  --replicate=percona.checksums \
  --no-check-binlog-format
# 结果DIFFS列为1，表示该表主从数据不一致

# 3. 修复差异数据（先预览再执行，避免误操作）
# --print 仅打印修复SQL；确认无误后替换为 --execute 正式执行
pt-table-sync \
  --user=root --password='Root@123456' \
  --sync-to-master \
  h=192.168.1.20,D=business_db,t=user_table \
  --print

# --------------------------
# 核心速记
# --------------------------
# 1. 复制流程：主库dump推binlog → 从库IO写中继日志 → SQL线程重放
# 2. 异步性能高、有丢数风险；半同步一致性高、性能略降，核心业务用
# 3. 健康标准：IO/SQL双Yes，延迟趋近于0
# 4. 延迟优化：拆大事务、开并行复制、提升从库硬件
# 5. 定期巡检：pt-table-checksum校验一致性，发现差异及时修复
```

### 6）读写分离架构认知

- 写主库、读从库
- 业务适配、故障切换思路

```md
# ==================================================
# MySQL 读写分离架构认知（生产必备）
# 核心逻辑：主库承接所有写操作，从库承接读请求，横向扩展读能力
# 基于主从复制架构实现，解决高并发读场景主库性能瓶颈
# ==================================================

# --------------------------
# 一、核心架构原理
# --------------------------
# 1. 流量划分规则
# ✅ 写请求（INSERT/UPDATE/DELETE/DDL）：全部路由到主库 Master
# ✅ 读请求（SELECT）：大部分路由到从库 Slave，特殊场景走主库
# 2. 数据基础：依赖主从复制，主库binlog同步到从库，保证数据最终一致性
# 3. 核心价值
#    - 横向扩展读并发能力，单主库读性能触顶时，新增从库即可扩容
#    - 读写资源隔离，复杂报表、统计查询不占用主库写入资源
# 4. 天生缺陷：存在主从复制延迟，写入后立即查询可能读不到最新数据

# --------------------------
# 二、两种主流实现方案（业务适配方式）
# --------------------------

## 方案1：应用层代码实现（轻量方案，中小项目常用）
# 原理：项目内配置多数据源，写操作走主库数据源，读操作走从库数据源
# 常见技术栈
# - Java：MyBatis-Plus 多数据源插件、Sharding-JDBC 内嵌代理
# - Go/Python：手动封装DB连接层，按SQL类型自动路由
# 优点：无额外中间件，架构简单，无网络转发性能损耗
# 缺点：与业务代码耦合，多语言项目适配成本高，故障切换需代码支持
# 业务适配要点
# - 封装路由逻辑，自动根据SQL语句判断读写分类
# - 预留强制走主库的接口，用于实时性要求极高的场景（如支付后查订单状态）

## 方案2：中间件代理层实现（中大型项目标准方案）
# 原理：业务统一连接中间件，中间件解析SQL后自动路由到对应节点，业务无感知
# 主流工具：ProxySQL（轻量高性能，业界主流）、MyCat（兼顾分库分表+读写分离）
# 优点：业务零侵入，统一管控，支持自动故障切换、读负载均衡
# 缺点：新增一层网络转发，有少量性能损耗，需维护中间件自身高可用

# 生产通用路由规则（ProxySQL 典型配置逻辑）
# 1. 带锁查询 SELECT ... FOR UPDATE → 强制路由主库
# 2. 普通 SELECT 查询 → 路由从库组，轮询/权重负载均衡
# 3. 所有非SELECT语句 → 全部路由主库
# 4. 延迟兜底：从库延迟超过阈值时，自动将读请求切回主库

# --------------------------
# 三、故障切换核心思路
# --------------------------

## 1. 从库故障（读节点宕机）
# 影响：整体读能力下降，不影响写入业务
# 处理流程
# 1. 监控告警检测到从库离线 / 主从延迟超标
# 2. 读写分离层自动剔除故障从库，读流量转移到剩余健康从库
# 3. 运维排查从库故障，修复后重新加入读资源池
# 4. 多从库部署场景下，单节点故障业务完全无感知

## 2. 主库故障（写节点宕机）
# 影响：数据库无法写入，属于核心级故障
# 处理思路：主从切换，提升一台数据最新的从库为新主库
# 生产常用自动切换工具：MHA、Orchestrator、云数据库自带高可用组件
# 标准切换步骤
# 1. 心跳检测确认主库宕机，触发切换流程
# 2. 选举数据最完整的从库（中继日志全部重放完成）作为新主库
# 3. 其余从库断开旧主库连接，指向新主库继续同步
# 4. 读写分离层更新路由规则，写流量切到新主库
# 5. 旧主库修复后，作为新主库的从库重新加入集群
# 注意：切换过程存在秒级写中断，核心业务需做降级容错

# --------------------------
# 四、生产落地避坑要点
# --------------------------
# 1. 主从延迟（最大坑点）
#    场景：写入后立刻查询，因复制延迟从库无数据，导致业务异常
#    解决方案：
#    ✅ 核心实时读（如下单、支付后状态查询）强制走主库
#    ✅ 中间件配置延迟阈值，从库延迟>1s时自动切主库
#    ✅ 业务层做短暂重试，容忍毫秒级复制延迟
# 2. 带锁查询必须走主库
#    SELECT ... FOR UPDATE、SELECT ... LOCK IN SHARE MODE 必须路由主库，否则从库只读报错
# 3. 读负载均衡
#    多从库场景按硬件性能分配权重，避免弱配置从库被打满
# 4. 不适用场景
#    - 读少写多的业务：无扩容价值，徒增架构复杂度
#    - 强一致性要求极高：金融核心账务类场景，无法容忍任何延迟，不适合读写分离

# --------------------------
# 核心速记
# --------------------------
# 1. 本质：写主读从，基于主从复制，横向扩展读性能
# 2. 选型：小项目用代码多数据源，中大型用ProxySQL中间件
# 3. 避坑：主从延迟是常态，实时读强制走主库
# 4. 故障：从库挂了摘节点，主库挂了做主从切换
# 5. 前提：先搭稳主从复制，再落地读写分离
```

### 7）备份与恢复（运维核心工作）

- mysqldump 全量备份 + 定时任务
- XtraBackup 物理热备（增量 / 全量）
- 定时备份脚本、异地备份、定期恢复演练

```md
# ==================================================
# MySQL 备份与恢复 生产运维核心手册
# 1. mysqldump 逻辑全量备份 | 2. XtraBackup 物理热备（全量+增量）
# 3. 定时备份策略 | 4. 异地备份 | 5. 恢复演练规范
# ==================================================

# --------------------------
# 一、mysqldump 逻辑全量备份（中小库通用，运维标配）
# 原理：导出SQL语句文本，兼容性强；大库备份慢、锁表风险高
# --------------------------
# 核心参数说明
# --single-transaction  InnoDB引擎热备，不锁表，保证数据一致性
# --master-data=2       记录binlog文件名与偏移量，用于增量恢复/搭建主从
# --all-databases       备份全库；指定单库替换为 库名
# --routines --triggers 备份存储过程、触发器
# -q                    不缓存查询结果，大库降低内存占用
# gzip 压缩             备份文件压缩存储，节省磁盘

# 1. 单库全量备份脚本示例
cat > /data/backup/mysql_backup.sh <<'EOF'
#!/bin/bash
# 配置项
BACKUP_DIR="/data/backup/mysql"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="business_db"
MYSQL_USER="root"
MYSQL_PWD="Root@123456"
KEEP_DAYS=7

# 创建目录
mkdir -p $BACKUP_DIR

# 执行备份（InnoDB热备，不锁表）
mysqldump -u$MYSQL_USER -p$MYSQL_PWD \
  --single-transaction --master-data=2 \
  --routines --triggers -q $DB_NAME \
  | gzip > $BACKUP_DIR/${DB_NAME}_$DATE.sql.gz

# 备份结果校验
if [ $? -eq 0 ]; then
  echo "[$(date)] 备份成功: ${DB_NAME}_$DATE.sql.gz" >> $BACKUP_DIR/backup.log
else
  echo "[$(date)] 备份失败！" >> $BACKUP_DIR/backup.log
fi

# 删除7天前过期备份
find $BACKUP_DIR -name "*.sql.gz" -mtime +$KEEP_DAYS -delete
EOF
chmod +x /data/backup/mysql_backup.sh

# 2. 恢复操作
# 方式1：压缩包直接恢复
gunzip < business_db_20260714_020000.sql.gz | mysql -uroot -p business_db
# 方式2：先解压再恢复
gunzip business_db_20260714_020000.sql.gz
mysql -uroot -p business_db < business_db_20260714_020000.sql

# 3. 增量恢复（全量备份+binlog）
# 步骤：先恢复全量备份 → 提取备份后到故障点的binlog → 重放SQL
mysqlbinlog --start-position=156 mysql-bin.000001 | mysql -uroot -p business_db

# mysqldump 优缺点
# ✅ 优点：轻量、文件小、兼容性强、可跨版本恢复、支持单库单表
# ❌ 缺点：大库备份/恢复慢，全量锁表风险（MyISAM），仅支持全量逻辑备份

# --------------------------
# 二、XtraBackup 物理热备（大库生产标准，支持增量）
# 原理：直接拷贝InnoDB数据文件+redo日志，热备不锁表，速度快
# 适用：10G以上大库，业务不能停服的核心数据库
# --------------------------
# 安装依赖（Percona官方工具）
yum install -y percona-xtrabackup-80

# 1. 全量物理备份
xtrabackup --user=root --password='Root@123456' \
  --backup --target-dir=/data/backup/xtra_full_$(date +%Y%m%d)
# 备份产物：数据文件、日志、binlog位置信息，可直接用于恢复

# 2. 增量备份（基于上一次全量/增量，只备份变更页，速度极快）
# 第一步：先做一次全量备份作为基准
BASE_DIR=/data/backup/xtra_full_20260714
# 第二步：每日增量备份，指定基准目录
xtrabackup --user=root --password='Root@123456' \
  --backup --target-dir=/data/backup/xtra_incr_$(date +%Y%m%d) \
  --incremental-basedir=$BASE_DIR

# 3. 完整恢复流程（三步：准备全量→合并增量→回拷数据）
# 步骤1：准备全量备份（应用redo日志，使数据处于一致性状态）
xtrabackup --prepare --apply-log-only --target-dir=/data/backup/xtra_full_20260714

# 步骤2：合并增量备份到全量（多个增量依次合并）
xtrabackup --prepare --apply-log-only \
  --target-dir=/data/backup/xtra_full_20260714 \
  --incremental-dir=/data/backup/xtra_incr_20260715

# 步骤3：最终一致性准备（最后一次不加--apply-log-only）
xtrabackup --prepare --target-dir=/data/backup/xtra_full_20260714

# 步骤4：停止MySQL，清空原数据目录，回拷备份数据
systemctl stop mysqld
rm -rf /var/lib/mysql/*
xtrabackup --copy-back --target-dir=/data/backup/xtra_full_20260714
chown -R mysql:mysql /var/lib/mysql
systemctl start mysqld

# XtraBackup 优缺点
# ✅ 优点：热备不锁表、速度快、支持增量、大库恢复快
# ❌ 缺点：物理文件备份、占用空间大、不能跨版本/跨平台恢复

# --------------------------
# 三、生产定时备份策略（crontab）
# --------------------------
# 标准策略：每日凌晨全量备份，binlog实时留存，异地同步
cat >> /var/spool/cron/root <<'EOF'
# 每天凌晨2点执行mysqldump全量逻辑备份
0 2 * * * /data/backup/mysql_backup.sh > /dev/null 2>&1
# 每天凌晨3点同步备份到异地备份服务器（rsync增量同步）
0 3 * * * rsync -avz /data/backup/mysql/ backup_user@192.168.1.100:/data/backup/mysql/ > /dev/null 2>&1
EOF

# 生产备份规范
# 1. 保留策略：本地保留7天，异地保留30天
# 2. 备份类型：核心库XtraBackup物理全量+每日增量；非核心库mysqldump全量
# 3. 备份校验：每次备份后检查文件大小、返回状态，异常告警
# 4. 权限隔离：备份账号仅授予备份所需最小权限，不使用super账号

# --------------------------
# 四、异地备份与安全
# --------------------------
# 1. 同城/异地服务器同步：rsync + ssh密钥免密
# 2. 云环境：备份文件同步到对象存储（OSS/COS/S3）
# 示例：同步到阿里云OSS
# ossutil cp /data/backup/mysql/ oss://backup-bucket/mysql/ -r

# 3. 备份加密：敏感业务备份文件加密存储
# openssl enc -aes256 -salt -in backup.sql.gz -out backup.sql.gz.enc -k 加密密钥

# --------------------------
# 五、定期恢复演练（生产硬性要求）
# --------------------------
# 核心原则：没有经过恢复验证的备份 = 无效备份
# 演练周期：核心库每月1次，非核心库每季度1次
# 标准演练流程
# 1. 搭建独立恢复测试机，配置同版本MySQL
# 2. 拉取最新全量备份+增量备份，执行完整恢复操作
# 3. 验证：数据完整性、表数量、核心业务表数据行数、关键字段数据
# 4. 记录恢复耗时、备份可用性，输出演练报告
# 5. 发现备份损坏/恢复失败，立即排查备份链路，修复后重新备份

# --------------------------
# 核心速记
# --------------------------
# 1. 小库用mysqldump：简单通用，逻辑备份，支持单库单表
# 2. 大库用XtraBackup：物理热备，速度快，支持增量
# 3. 数据兜底：全量备份 + binlog增量，可恢复到任意时间点
# 4. 安全保障：本地保留+异地备份，定期演练验证备份有效性
# 5. 故障恢复优先级：先从库切换 → 再备份恢复，备份是最后兜底手段
```

### 8）日常巡检与故障排障

- 连接数爆满、死锁、卡慢事务
- 磁盘 IO 过高、日志爆满
- 主从宕机、切换、数据恢复

```md
# ==================================================
# MySQL 日常巡检与故障排障 生产实操手册
# 覆盖场景：连接数爆满、死锁长事务、磁盘IO过高、日志爆满、主从宕机切换与数据恢复
# ==================================================

# --------------------------
# 一、日常核心巡检指标（每日必查，快速定位健康状态）
# --------------------------

## 1. 连接与运行状态巡检
mysql -uroot -p -e "
-- 查看当前连接数、峰值连接数
show global status like 'Threads_connected';
show global status like 'Max_used_connections';
-- 查看最大连接数配置
show variables like 'max_connections';
-- 查看运行线程状态
show processlist;
"
# 健康阈值：连接数不超过max_connections的70%；大量Sleep空闲连接说明连接泄露

## 2. 数据库核心运行指标
mysql -uroot -p -e "
-- QPS 每秒查询量
show global status like 'Questions';
-- TPS 每秒事务量
show global status like 'Com_commit';
show global status like 'Com_rollback';
-- 慢查询数量
show global status like 'Slow_queries';
-- InnoDB缓冲池命中率（目标>99%）
show global status like 'Innodb_buffer_pool_read_requests';
show global status like 'Innodb_buffer_pool_reads';
"

## 3. 主从同步巡检（从库执行）
mysql -uroot -p -e "SHOW SLAVE STATUS\G"
# 核心校验项：
# Slave_IO_Running=Yes、Slave_SQL_Running=Yes
# Seconds_Behind_Master=0（延迟趋近于0）
# Last_IO_Error、Last_SQL_Error 为空

## 4. 磁盘空间巡检
# 检查数据目录、日志目录占用
du -sh /var/lib/mysql/
du -sh /var/log/mysql/
# 检查磁盘整体使用率
df -h
# 健康阈值：磁盘使用率不超过80%，binlog/慢日志定期清理

# --------------------------
# 二、典型故障排查与处理
# --------------------------

# ==================================
# 故障1：连接数爆满，报错 Too many connections
# 现象：业务无法连接数据库，日志提示连接数超限
# ==================================
## 排查步骤
# 1. 查看连接分布，定位占满连接的来源
mysql -uroot -p -e "SHOW FULL PROCESSLIST;"
# 重点关注：大量Sleep空闲连接、长时间执行的慢SQL、同一IP大量连接

## 应急处理
# 1. 临时调大最大连接数（重启失效，先救业务）
mysql -uroot -p -e "SET GLOBAL max_connections = 2000;"
# 2. 批量杀掉空闲超时的Sleep连接（释放连接资源）
# 手动杀指定ID：KILL 进程ID;
# 批量杀超过300秒的空闲连接
mysql -uroot -p -e "SELECT CONCAT('KILL ',id,';') FROM information_schema.processlist WHERE Command='Sleep' AND Time>300;" | mysql -uroot -p

## 根因与根治
# 根因1：应用端连接池配置过大/连接泄露 → 优化连接池参数，设置合理超时
# 根因2：慢SQL占住连接不释放 → 优化慢SQL，加索引
# 根因3：短连接风暴 → 业务改用长连接池，减少频繁建连
# 根因4：max_connections配置过小 → my.cnf永久调大参数

# ==================================
# 故障2：死锁、长事务导致数据库卡慢
# 现象：业务接口超时，大量请求堆积，CPU/IO飙升
# ==================================
## 1. 排查死锁
# 查看最近一次死锁详情
mysql -uroot -p -e "SHOW ENGINE INNODB STATUS\G"
# 定位 LATEST DETECTED DEADLOCK 段落，查看冲突SQL、锁类型、事务信息

## 2. 排查长事务与锁等待
mysql -uroot -p -e "
-- 查看当前运行中所有事务（重点关注trx_started运行时长）
SELECT * FROM information_schema.innodb_trx\G
-- 查看当前锁等待关系
SELECT * FROM performance_schema.data_locks;
SELECT * FROM performance_schema.data_lock_waits;
"
# 危险信号：事务运行超过几十秒，持有行锁不释放，导致后续请求全部阻塞

## 应急处理
# 杀掉阻塞源头的长事务/死锁事务
mysql -uroot -p -e "KILL 事务对应的进程ID;"

## 优化与规避
# 1. 大事务拆分为小事务，避免长事务持有锁
# 2. 业务层面加分布式锁，减少并发冲突
# 3. 统一使用索引更新，避免全表扫描升级为表锁
# 4. 设置事务超时参数，自动回滚挂起事务

# ==================================
# 故障3：磁盘IO过高、日志爆满占满磁盘
# 现象：磁盘使用率100%，数据库无法写入，服务挂起
# ==================================
## 1. 磁盘IO过高排查
# 查看IO使用率TOP进程
iotop
# 查看MySQL IO相关指标
mysql -uroot -p -e "SHOW GLOBAL STATUS LIKE 'Innodb_data_reads';"
# 常见根因：
# - 大量慢查询全表扫描，读IO飙升
# - 大事务批量写入，刷盘频繁
# - innodb_buffer_pool_size太小，频繁磁盘读写

## 2. 日志爆满应急处理
# 第一步：定位大文件
find /var/lib/mysql -name "mysql-bin.*" -size +1G | sort -hr
du -sh /var/log/mysql/slow.log /var/log/mysql/mysqld.err

# 第二步：规范清理binlog（禁止直接rm删除文件，必须用MySQL命令）
# 清理指定文件之前的所有binlog
mysql -uroot -p -e "PURGE BINARY LOGS TO 'mysql-bin.000120';"
# 清理指定时间之前的binlog
mysql -uroot -p -e "PURGE BINARY LOGS BEFORE '2026-07-01 00:00:00';"
# 永久生效：my.cnf设置 expire_logs_days = 7 自动过期清理

# 第三步：大日志文件截断（慢日志/错误日志）
# 清空当前日志（不删除文件，避免MySQL找不到文件句柄）
> /var/log/mysql/slow.log
> /var/log/mysql/mysqld.err

## 根治方案
# 1. 配置logrotate轮转慢查询、错误日志，按天切割保留30天
# 2. 合理设置binlog过期时间，避免无限增长
# 3. 优化慢SQL，减少大事务写入，降低磁盘IO压力

# ==================================
# 故障4：主从宕机、切换与数据恢复
# ==================================
## 场景A：从库宕机/同步中断
# 排查步骤：
# 1. 查看从库错误日志，定位报错原因
tail -f /var/log/mysql/mysqld.err
# 2. 查看从库状态，获取具体报错
mysql -uroot -p -e "SHOW SLAVE STATUS\G"

# 常见处理：
# - 1062主键冲突/1032记录不存在：先跳过单事务验证，再做数据一致性修复
#   STOP SLAVE; SET GLOBAL sql_slave_skip_counter=1; START SLAVE;
# - 中继日志损坏：重置从库同步位点，重新全量同步
# - 服务器硬件故障：修复硬件后，用备份重建从库

## 场景B：主库宕机，手动主从切换（应急）
# 标准切换步骤：
# 1. 确认主库已无法恢复，停止所有业务写入
# 2. 在所有从库中，选择数据最完整的一台（Exec_Master_Log_Pos最大）作为新主库
# 3. 登录新主库，关闭只读，提升为主库
mysql -uroot -p -e "
STOP SLAVE;
RESET MASTER;
SET GLOBAL read_only = OFF;
"
# 4. 其余从库执行CHANGE MASTER指向新主库，重启同步
# 5. 修改业务配置/中间件路由，切换到新主库
# 6. 旧主库修复后，作为从库重新加入集群

## 场景C：数据误删/损坏，备份兜底恢复
# 恢复优先级：先从库延迟回放 → 再备份+binlog时间点恢复
# 标准流程：
# 1. 锁定现场，保留当前所有binlog，避免覆盖
# 2. 恢复最近一次全量备份到临时实例
# 3. 提取故障时间点之前的binlog，重放到临时实例
# 4. 验证数据无误后，回切到生产环境
# 5. 复盘操作流程，增加权限管控/操作审计

# --------------------------
# 核心速记
# --------------------------
# 1. 连接爆满：先调大上限、杀空闲连接，再查连接池与慢SQL
# 2. 死锁卡慢：innodb status查死锁，杀长事务，拆大事务加索引
# 3. 磁盘告警：binlog用purge清理，日志用>清空，禁止直接rm
# 4. 主从故障：从库断了修同步，主库挂了选新主切换，最后靠备份兜底
# 5. 巡检核心：连接数、主从延迟、磁盘空间、慢SQL数量每日必查
```

## 2. Redis 缓存全栈运维

### 1）生产部署

- 单机、多实例、端口配置
- 安全加固：密码、禁止外网、改名高危命令

```md
# ==================================================
# Redis 生产部署运维手册
# 1. YUM单机部署 | 2. 多实例多端口部署 | 3. 生产安全加固
# ==================================================

# --------------------------
# 一、YUM 单机部署（CentOS 生产标准方案）
# --------------------------
# 1. 安装epel源与Redis服务
yum install -y epel-release
yum install -y redis

# 2. 默认目录结构
# /etc/redis.conf          # 主配置文件
# /usr/bin/redis-server    # 服务端二进制程序
# /usr/bin/redis-cli       # 命令行客户端
# /var/lib/redis/          # 默认数据目录（存放RDB/AOF持久化文件）
# /var/log/redis/redis.log # 默认运行日志
# /usr/lib/systemd/system/redis.service # systemd服务管理文件

# 3. 启动与开机自启
systemctl start redis
systemctl enable redis

# 4. 基础验证
redis-cli ping
# 返回 PONG 表示服务运行正常

# --------------------------
# 二、多实例部署（6379/6380 多端口业务隔离）
# 适用场景：多业务缓存隔离、测试/生产环境复用服务器、避免单实例故障影响全业务
# --------------------------
# 1. 目录规划（每个实例独立数据、日志、配置）
mkdir -p /etc/redis/
mkdir -p /var/lib/redis/6379
mkdir -p /var/lib/redis/6380
mkdir -p /var/log/redis/
chown -R redis:redis /var/lib/redis /var/log/redis

# 2. 6379 实例基础配置
cat > /etc/redis/6379.conf <<'EOF'
# 端口配置
port 6379
# 后台守护进程运行
daemonize yes
pidfile /var/run/redis_6379.pid

# 日志与数据目录
logfile /var/log/redis/6379.log
dir /var/lib/redis/6379

# RDB持久化基础配置（后续章节详解）
save 900 1
save 300 10
save 60 10000
rdbcompression yes

# 内存上限与淘汰策略（生产必配，防止OOM）
maxmemory 2G
maxmemory-policy allkeys-lru
EOF

# 3. 6380 实例配置（仅修改端口、PID、日志、数据目录，其余参数对齐）
cat > /etc/redis/6380.conf <<'EOF'
port 6380
daemonize yes
pidfile /var/run/redis_6380.pid
logfile /var/log/redis/6380.log
dir /var/lib/redis/6380

save 900 1
save 300 10
save 60 10000
maxmemory 2G
maxmemory-policy allkeys-lru
EOF

# 4. systemd 服务文件（6379示例，6380替换端口即可）
cat > /usr/lib/systemd/system/redis-6379.service <<'EOF'
[Unit]
Description=Redis 6379 Server
After=network.target

[Service]
Type=forking
User=redis
Group=redis
ExecStart=/usr/bin/redis-server /etc/redis/6379.conf
ExecStop=/usr/bin/redis-cli -p 6379 -a 密码 shutdown
Restart=on-failure
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# 5. 重载服务并启动多实例
systemctl daemon-reload
systemctl start redis-6379 redis-6380
systemctl enable redis-6379 redis-6380

# 6. 多实例验证
redis-cli -p 6379 ping
redis-cli -p 6380 ping

# --------------------------
# 三、生产安全加固（硬性合规要求）
# 核心原则：最小暴露面 + 权限管控 + 高危操作拦截
# --------------------------
# 以下配置追加到所有实例配置文件中
cat >> /etc/redis/6379.conf <<'EOF'
# ========== 1. 禁止外网访问 ==========
# 仅绑定本地回环+内网网段，生产严禁 bind 0.0.0.0
bind 127.0.0.1 192.168.1.0/24

# ========== 2. 密码强认证 ==========
# 客户端连接必须先 AUTH 校验，生产禁止无密码运行
# 密码规范：大小写+数字+特殊字符，长度≥16位
requirepass Redis@Prod_20260714

# ========== 3. 高危命令重命名/禁用 ==========
# 防止误操作清空数据、未授权修改配置、全库遍历阻塞服务
# FLUSHALL/FLUSHDB：清空全库/单库，生产事故高频诱因
# CONFIG：可修改运行时核心参数，风险极高
# KEYS：全库遍历key，大库会导致Redis阻塞雪崩
# SHUTDOWN：直接关闭服务

# 重命名为自定义随机串，仅运维掌握
rename-command FLUSHALL "redis_op_flushall_9x2k7m"
rename-command FLUSHDB "redis_op_flushdb_4z8w1h"
rename-command CONFIG "redis_op_config_6j9d3q"
rename-command KEYS "redis_op_keys_5v2n7s"
rename-command SHUTDOWN "redis_op_shutdown_8r4t6y"

# 完全禁用命令示例（设为空字符串）
# rename-command FLUSHALL ""
EOF

# 补充系统层加固
# 1. 防火墙限制：仅内网网段可访问Redis端口
firewall-cmd --permanent --add-rich-rule="rule family='ipv4' source address='192.168.1.0/24' port protocol='tcp' port='6379' accept"
firewall-cmd --reload

# 2. 数据目录权限收敛，仅redis用户可读写
chmod 700 /var/lib/redis/6379
chown -R redis:redis /var/lib/redis/6379

# 3. 公网服务器严禁映射6379默认端口，避免被扫描爆破

# --------------------------
# 核心速记
# --------------------------
# 1. 部署选型：单业务单机部署，多业务隔离用多实例
# 2. 安全三板斧：绑定内网、设置强密码、重命名高危命令
# 3. 生产红线：禁止 0.0.0.0 监听、禁止无密码运行、禁止root账号启动
# 4. 多实例核心：独立端口、独立数据目录、独立日志、独立服务管理
```

### 2）持久化机制（必考）

- RDB 快照持久化：原理、触发机制、优缺点

- AOF 日志持久化：重写机制、三种刷盘策略

- 生产持久化组合方案

```md
# ==================================================
# Redis 持久化机制（运维/面试核心必考）
# 1. RDB 快照持久化 | 2. AOF 日志持久化 + 重写机制 + 三种刷盘策略
# 3. 生产标准组合方案：RDB+AOF混合持久化
# ==================================================

# --------------------------
# 持久化核心作用
# Redis 纯内存运行，断电/宕机内存数据全部丢失；
# 持久化将内存数据落地到磁盘，重启后自动加载恢复数据。
# --------------------------

# --------------------------
# 一、RDB 快照持久化
# 原理：在指定时间点，将内存中全量数据生成二进制压缩快照文件，保存到磁盘
# 核心：保存的是「数据结果」，不是操作过程
# --------------------------

## 1. 触发机制
# 【自动触发】按配置的保存规则自动执行
# 【手动触发】执行 SAVE / BGSAVE 命令
#   SAVE：主线程执行快照，全程阻塞Redis，生产禁用
#   BGSAVE：fork子进程后台生成快照，主线程不阻塞，生产默认方式

## 2. 生产配置（追加到redis.conf）
cat >> /etc/redis/6379.conf <<'EOF'
# ========== RDB 基础配置 ==========
# 开启RDB快照，配置保存规则：save 秒数 写入次数
# 900秒内至少1次写入 → 触发快照
save 900 1
# 300秒内至少10次写入 → 触发快照
save 300 10
# 60秒内至少10000次写入 → 触发快照
save 60 10000

# RDB快照文件名
dbfilename dump.rdb
# 快照文件保存目录（AOF文件也存在此目录）
dir /var/lib/redis/6379

# 开启RDB文件压缩，节省磁盘空间，轻微消耗CPU
rdbcompression yes
# 开启RDB文件校验，恢复时检查文件完整性
rdbchecksum yes

# 快照生成失败时，禁止Redis继续写入，避免数据不一致
stop-writes-on-bgsave-error yes
EOF

## 3. RDB 优缺点
# ✅ 优点：
# 1. 二进制压缩文件，体积小，适合全量备份、异地灾备
# 2. 恢复速度极快，直接加载数据到内存，远快于AOF
# 3. BGSAVE后台执行，不阻塞主线程，对业务影响小
# ❌ 缺点：
# 1. 间隔性快照，宕机会丢失最后一次快照之后的所有数据（分钟级丢失）
# 2. fork子进程时，大数据量场景会有短暂阻塞，且消耗额外内存
# 3. 频繁写入小数据场景，快照触发频繁，IO开销大

# --------------------------
# 二、AOF 日志持久化
# 原理：以日志形式记录每一条写命令，追加方式写入文件；
# 重启时重放所有写命令，恢复完整数据。
# 核心：保存的是「写操作过程」，不是数据结果
# --------------------------

## 1. 三种刷盘策略（appendfsync，生产核心选型）
# 决定写命令何时从内存缓冲区刷到磁盘，是数据安全性与性能的平衡
#
# ① always：每执行一条写命令，立即刷盘
#   ✅ 安全性最高，最多丢失一条命令数据
#   ❌ 性能最差，每条写都有磁盘IO，吞吐量极低
#
# ② everysec：每秒刷盘一次（生产默认标准）
#   ✅ 性能与安全平衡，最多丢失1秒数据，业务可接受
#   ❌ 极端宕机场景丢失1秒内写入的数据
#
# ③ no：完全交给操作系统决定刷盘时机（通常30秒左右）
#   ✅ 性能最高
#   ❌ 安全性最差，宕机丢失数据最多，生产不推荐

## 2. AOF 重写机制
# 背景：AOF采用追加写入，文件会越来越大；且存在大量冗余命令（如对同一个key反复修改）
# 原理：fork子进程，将内存中当前全量数据逆转为最小写命令集，生成新的AOF文件，替换旧文件
# 核心：压缩AOF文件体积，加快数据恢复速度
# 触发方式：
#   手动触发：BGREWRITEAOF 命令
#   自动触发：配置阈值，文件大小增长率和绝对大小同时满足时自动重写

## 3. 生产配置
cat >> /etc/redis/6379.conf <<'EOF'
# ========== AOF 基础配置 ==========
# 开启AOF持久化
appendonly yes
# AOF日志文件名
appendfilename "appendonly.aof"

# 核心：刷盘策略，生产标准 everysec
appendfsync everysec
# appendfsync always
# appendfsync no

# AOF重写期间，是否暂停刷盘，避免IO冲突导致阻塞
no-appendfsync-on-rewrite yes

# ========== AOF 自动重写配置 ==========
# AOF文件增长率达到100%（比上一次重写后大一倍）时触发重写
auto-aof-rewrite-percentage 100
# AOF文件至少达到64MB才触发重写，避免小文件频繁重写
auto-aof-rewrite-min-size 64mb

# AOF文件末尾损坏时，启动时自动截断损坏部分，保证服务可启动
aof-load-truncated yes
EOF

## 4. AOF 优缺点
# ✅ 优点：
# 1. 数据安全性高，everysec模式最多丢失1秒数据
# 2. 追加写入，无磁盘随机IO，写入性能好
# 3. 日志文件可读，可手动编辑、提取指定命令做数据恢复
# ❌ 缺点：
# 1. 相同数据集，AOF文件体积远大于RDB
# 2. 恢复速度慢，需要逐条重放所有命令
# 3. 存在重写开销，大数据量重写时有短暂性能影响

# --------------------------
# 三、生产标准组合方案：RDB + AOF 混合持久化
# Redis 4.0+ 支持，兼顾两者优势，是当前生产默认推荐方案
# --------------------------
# 原理：
# AOF重写时，先将当前内存全量数据以RDB格式写入AOF文件开头，
# 后续的写命令继续以AOF格式追加到文件末尾。
# 恢复时：先加载开头的RDB全量数据（速度快），再重放后面的增量AOF命令（数据全）。

## 生产配置
cat >> /etc/redis/6379.conf <<'EOF'
# 开启 RDB-AOF 混合持久化
aof-use-rdb-preamble yes
EOF

## 方案优势
# 1. 兼顾恢复速度：全量部分用RDB，恢复速度远超纯AOF
# 2. 兼顾数据安全：增量部分用AOF，最多丢失1秒数据
# 3. 文件体积更优：比纯AOF小很多，减少磁盘占用

## 场景选型建议
# 1. 纯缓存场景（允许数据全丢，重启从数据库重建）：仅开RDB即可
# 2. 通用业务缓存（可接受秒级数据丢失）：混合持久化（RDB+AOF everysec）
# 3. 高可靠数据场景（不能丢数据）：AOF always + 定期RDB全量备份
# 4. 禁止方案：生产环境不允许完全关闭持久化（宕机全量数据丢失）

# --------------------------
# 核心速记
# --------------------------
# 1. RDB存数据快照，体积小恢复快，丢数据多；AOF存写命令，数据全恢复慢
# 2. AOF三策略：always最安全慢，everysec平衡生产用，no最快丢得多
# 3. AOF重写：压缩文件体积，减少恢复时间，后台执行不阻塞
# 4. 生产标配：混合持久化 + everysec刷盘 + 定期RDB全量备份
```

### 3）内存管理

- 内存淘汰策略 8 种
- maxmemory 限制内存上限
- 大 key 发现、批量删除、内存溢出排查

```md
# ==================================================
# Redis 内存管理 生产运维手册
# 1. maxmemory 内存上限配置 | 2. 8种内存淘汰策略
# 3. 大key发现与安全删除 | 4. 内存溢出排查与优化
# ==================================================

# --------------------------
# 一、maxmemory 内存上限配置（生产必配，防止OOM）
# 作用：限制Redis最大内存使用量，超过阈值触发淘汰策略，避免进程被系统OOM杀死
# --------------------------
cat >> /etc/redis/6379.conf <<'EOF'
# 设置Redis最大可用内存，单位支持字节/K/M/G
# 生产配置原则：不超过服务器物理内存的70%~80%，预留系统内存+fork子进程开销
# 例如8G内存机器，建议设置为5~6G
maxmemory 6G

# 内存淘汰策略（下文详细说明8种），生产通用缓存推荐 allkeys-lru
maxmemory-policy allkeys-lru

# 每次淘汰采样数量，数值越大淘汰越精准，但CPU开销越高，默认5足够
maxmemory-samples 5
EOF

# 运行时查看与临时调整
redis-cli -p 6379 -a 密码 CONFIG GET maxmemory
redis-cli -p 6379 -a 密码 CONFIG SET maxmemory 8G  # 临时调整，重启失效

# --------------------------
# 二、8种内存淘汰策略（必考核心）
# 分类规则：allkeys 针对所有键；volatile 仅针对设置了过期时间的键
# --------------------------
# 【第一类：不淘汰策略（1种）】
# 1. noeviction
#    规则：内存达到上限后，所有写请求直接返回错误，不淘汰任何数据
#    适用：数据不能丢、持久化存储场景，纯缓存不推荐，默认策略

# 【第二类：allkeys 全键淘汰（3种）】
# 2. allkeys-lru  【生产通用缓存首选】
#    规则：在所有键中，淘汰最近最少使用（Least Recently Used）的键
#    适用：有明显冷热区分的业务缓存，保留热点数据，淘汰冷数据
# 3. allkeys-lfu  Redis4.0+新增
#    规则：在所有键中，淘汰访问频次最低（Least Frequently Used）的键
#    适用：访问频率差异大的场景，比LRU更精准判断数据热度
# 4. allkeys-random
#    规则：在所有键中随机淘汰
#    适用：所有key访问概率均等的场景，性能开销最小，但淘汰无差别

# 【第三类：volatile 过期键淘汰（4种）】
# 5. volatile-lru
#    规则：仅在设置了过期时间的键中，淘汰最近最少使用的
#    适用：同时存在永久数据和过期缓存，不希望淘汰永久数据的场景
# 6. volatile-lfu  Redis4.0+新增
#    规则：仅在设置了过期时间的键中，淘汰访问频次最低的
# 7. volatile-random
#    规则：仅在设置了过期时间的键中随机淘汰
# 8. volatile-ttl
#    规则：仅在设置了过期时间的键中，优先淘汰马上就要过期的键
#    适用：希望优先清理快过期的数据，保留长期有效缓存

# 生产选型速记
# ✅ 纯缓存业务、冷热明显：allkeys-lru
# ✅ 访问频次差异大：allkeys-lfu
# ✅ 混合永久数据+过期缓存：volatile-lru
# ❌ 纯缓存不推荐：noeviction（容易导致业务写入全失败）

# --------------------------
# 三、大key发现与安全删除（性能杀手，高频故障诱因）
# 大key定义：字符串value超过10KB；集合/哈希/列表元素超过1000个或总大小超过1MB
# 危害：阻塞Redis、网络IO飙升、内存碎片化、删除卡顿
# --------------------------

## 1. 线上大key扫描（低峰期执行，避免影响业务）
# 方式1：Redis自带工具，遍历所有key，输出各类型最大key，低峰使用
redis-cli -p 6379 -a 密码 --bigkeys

# 方式2：基于RDB文件离线分析（推荐，完全不影响线上业务）
# 安装分析工具
yum install -y python3-pip
pip3 install rdbtools
# 生成内存分析报告，找出TOP大key
rdb -c memory /var/lib/redis/6379/dump.rdb --bytes 10240 -f /tmp/redis_bigkeys.csv
# 按内存大小排序，定位TOP10大key
sort -t, -k4 -nr /tmp/redis_bigkeys.csv | head -10

## 2. 大key安全删除（禁止直接DEL，避免阻塞主线程）
# 方式1：异步删除（Redis4.0+推荐，后台线程释放内存，不阻塞主线程）
redis-cli -p 6379 -a 密码 UNLINK 大key名称

# 方式2：集合类大key分批删除（低版本兼容方案）
# 哈希大key：hscan分批获取字段，逐个hdel删除
# 列表大key：ltrim逐步截断
# 集合大key：sscan分批删除元素
# 示例：分批删除hash大key
for i in {1..100}; do
  redis-cli -p 6379 -a 密码 HSCAN 大hash_key $[i*100] COUNT 100
  # 对应执行hdel删除对应字段
done

# --------------------------
# 四、内存溢出（OOM）排查与优化
# 现象：写入报错OOM、淘汰频繁、业务响应超时、Redis进程被系统杀死
# --------------------------

## 第一步：核心内存指标排查
redis-cli -p 6379 -a 密码 INFO memory
# 关键字段解读：
# used_memory：Redis实际存储数据占用的内存（字节）
# used_memory_rss：操作系统视角的进程物理内存占用
# mem_fragmentation_ratio：内存碎片率 = used_memory_rss / used_memory
#   - 1 < 碎片率 < 1.5：正常健康范围
#   - 碎片率 > 1.5：内存碎片严重，实际可用内存少，需整理
#   - 碎片率 < 1：部分数据被交换到swap，性能急剧下降，必须优化
# used_memory_peak：历史内存峰值，用于评估容量

## 第二步：淘汰情况排查
redis-cli -p 6379 -a 密码 INFO stats | grep evicted_keys
# evicted_keys 数值持续增长 → 内存持续不足，频繁触发淘汰
# 业务表现：缓存命中率下降，数据库压力飙升

## 第三步：常见根因与优化方案
# 根因1：大key过多，内存占用远超预期
# 优化：拆分大key，大集合拆分为多个小key，设置合理过期时间

# 根因2：大量无过期时间的冷数据堆积，内存只增不减
# 优化：全量扫描无过期key，清理无效冷数据，规范业务设置TTL

# 根因3：maxmemory设置过小，业务增长快，容量不足
# 优化：评估业务增长，调大maxmemory，或扩容Redis集群分片

# 根因4：内存碎片严重
# 优化：Redis4.0+开启自动碎片整理
cat >> /etc/redis/6379.conf <<'EOF'
# 开启主动内存碎片整理
activedefrag yes
# 碎片率达到10%开始整理
active-defrag-ignore-bytes 100mb
active-defrag-threshold-lower 10
# 碎片率达到100%全力整理
active-defrag-threshold-upper 100
EOF
# 应急处理：低峰期执行内存整理（会短暂阻塞）
redis-cli -p 6379 -a 密码 MEMORY PURGE

# 根因5：缓存击穿/雪崩，瞬间大量数据涌入撑满内存
# 优化：加互斥锁、降级限流、预热热点数据

# --------------------------
# 核心速记
# --------------------------
# 1. 内存必设上限maxmemory，防止OOM杀进程
# 2. 8种淘汰策略：全键3种+过期4种+不淘汰1种，缓存首选allkeys-lru
# 3. 大key是性能杀手，--bigkeys/rdb工具排查，UNLINK异步删除
# 4. 内存告警先看碎片率、淘汰数、大key，再评估扩容与数据清理
```

### 4）高可用架构

- 主从复制部署、同步原理
- Sentinel 哨兵高可用（自动故障转移、主从切换）
- Cluster 集群架构认知、分片槽位

```md
# ==================================================
# Redis 高可用架构全栈
# 1. 主从复制：数据冗余+读写分离基础
# 2. Sentinel 哨兵：主从自动故障转移，解决主库单点
# 3. Cluster 集群：水平分片扩容，解决单节点容量/性能瓶颈
# ==================================================

# --------------------------
# 架构层级定位
# 主从复制 → 数据备份，无自动故障恢复
# 哨兵 → 基于主从，实现主库自动切换，高可用
# 集群 → 去中心化分片，支撑TB级数据+十万级并发
# --------------------------

# --------------------------
# 一、主从复制架构（基础必备）
# --------------------------
## 1. 同步核心原理
# 角色：1个Master主库（读写） + N个Slave从库（只读）
# 同步流程：
# ① 初次全量同步：从库发起同步 → 主库生成RDB快照 → 发送给从库加载 → 主库将期间增量命令发给从库
# ② 后续增量同步：主库持续将写命令异步推送给从库，从库回放保持数据一致
# 本质：异步复制，存在毫秒~秒级延迟；从库默认只读，不接受写入

## 2. 生产部署配置
# ===== 主库（Master 6379）无需特殊配置，确保开启持久化、设置密码即可
# ===== 从库（Slave 6380）核心配置
cat > /etc/redis/6380.conf <<'EOF'
port 6380
daemonize yes
pidfile /var/run/redis_6380.pid
dir /var/lib/redis/6380
logfile /var/log/redis/6380.log

# 密码认证（主库开启密码时，从库必须配置）
masterauth Redis@Prod_20260714
# 指定主库IP与端口，建立主从关系
replicaof 192.168.1.10 6379

# 从库只读模式（默认开启，防止业务误写从库）
replica-read-only yes
# 主从断开重连后，优先增量同步，避免全量同步
repl-diskless-sync no
# 复制缓冲区大小，大写入场景调大，减少全量同步概率
repl-backlog-size 64mb

# 内存与持久化对齐主库
maxmemory 2G
maxmemory-policy allkeys-lru
appendonly yes
appendfsync everysec
EOF

## 3. 启动与验证
systemctl start redis-6380
# 主从状态校验
redis-cli -p 6380 -a Redis@Prod_20260714 INFO replication
# 核心标志：
# role:slave
# master_link_status:up  主从连接正常
# master_sync_in_progress:0  同步完成

# 主库查看从节点
redis-cli -p 6379 -a Redis@Prod_20260714 INFO replication
# 输出 connected_slaves:1 表示从库已接入

## 4. 主从优缺点
# ✅ 优点：数据冗余备份、读写分离分摊读压力、架构简单
# ❌ 缺点：主库单点故障，需手动切换；无法解决单节点内存容量瓶颈

# --------------------------
# 二、Sentinel 哨兵高可用（中小规模生产标准）
# --------------------------
## 1. 核心功能
# ① 监控：持续检测主、从节点健康状态
# ② 自动故障转移：主库宕机后，哨兵集群投票选举新主库，自动切换
# ③ 通知：故障切换后通知客户端新主库地址
# ④ 配置中心：客户端连接哨兵获取主库地址，无需硬编码IP

## 2. 架构规范
# 哨兵节点必须 ≥3个，且分布在不同服务器；
# 故障判定需过半哨兵同意（quorum），防止脑裂误切换；
# 典型架构：3台哨兵 + 1主2从，生产最小高可用配置。

## 3. 三哨兵部署配置（端口26379/26380/26381，配置逻辑一致）
cat > /etc/redis/sentinel-26379.conf <<'EOF'
# 哨兵端口
port 26379
daemonize yes
pidfile /var/run/redis-sentinel-26379.pid
logfile /var/log/redis/sentinel-26379.log

# 监控主库：自定义集群名 + 主库IP端口 + quorum投票数
# 2表示2个哨兵认为主库故障，就触发切换（3哨兵设2，过半原则）
sentinel monitor mymaster 192.168.1.10 6379 2

# 主库密码（主库开启密码时必须配置）
sentinel auth-pass mymaster Redis@Prod_20260714

# 主库心跳超时时间（毫秒），超时判定为主观下线
sentinel down-after-milliseconds mymaster 30000

# 故障转移后，允许多少个从库同时同步新主库，数值越小切换越慢，业务影响越小
sentinel parallel-syncs mymaster 1

# 故障转移超时时间
sentinel failover-timeout mymaster 180000
EOF

# 26380/26381 仅修改端口、PID、日志文件，其余配置完全一致

## 4. 启动哨兵集群
redis-sentinel /etc/redis/sentinel-26379.conf
redis-sentinel /etc/redis/sentinel-26380.conf
redis-sentinel /etc/redis/sentinel-26381.conf

## 5. 状态验证
# 查看当前监控的主库信息
redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster
# 查看哨兵集群所有节点
redis-cli -p 26379 SENTINEL sentinels mymaster
# 查看从库列表
redis-cli -p 26379 SENTINEL slaves mymaster

## 6. 自动故障转移流程
# 1. 单个哨兵检测到主库超时 → 标记为主观下线（SDOWN）
# 2. 多个哨兵确认故障，达到quorum阈值 → 标记为客观下线（ODOWN）
# 3. 哨兵之间投票选举领头哨兵，负责执行切换
# 4. 从所有从库中选出数据最新的一台，提升为新主库
# 5. 其余从库指向新主库重新同步
# 6. 旧主库恢复后，自动变为新主库的从库

# --------------------------
# 三、Redis Cluster 集群架构（大规模生产，分片扩容）
# --------------------------
## 1. 核心设计：哈希槽分片
# ① 全集群共 16384 个哈希槽（Hash Slot），是数据分片的最小单位
# ② 每个Key通过 CRC16(key) mod 16384 计算出所属槽位，路由到对应节点
# ③ 每个主节点负责一部分槽位，例如3主节点：
#    节点1：0~5460
#    节点2：5461~10922
#    节点3：10923~16383
# ④ 去中心化：无中心节点，任意节点都可接收请求，非自身槽位返回重定向（MOVED）

## 2. 高可用架构
# 每个主节点配备1~N个从节点；
# 主节点宕机时，集群自动将其从节点提升为主节点，保证分片可用；
# 最小生产集群：3主3从（每个主1个从），共6个节点。

## 3. 核心特点
# ✅ 水平扩容：新增主节点，自动迁移槽位，线性提升容量与并发
# ✅ 无单点故障：去中心化，单节点故障不影响全集群
# ✅ 数据分片：解决单Redis内存上限，支撑TB级数据
# ❌ 限制：
#  - 不支持跨节点事务、多键操作（如MSET/MGET跨槽位报错）
#  - 批量操作需保证key在同一槽位（可使用{hash_tag}强制同槽）
#  - 运维复杂度高于哨兵架构

## 4. 集群节点基础配置模板（以7001节点为例）
cat > /etc/redis/cluster-7001.conf <<'EOF'
port 7001
daemonize yes
pidfile /var/run/redis-cluster-7001.pid
dir /var/lib/redis/cluster-7001
logfile /var/log/redis/cluster-7001.log

# 开启集群模式
cluster-enabled yes
# 集群节点信息文件，自动生成
cluster-config-file nodes-7001.conf
# 节点心跳超时时间，超时判定为故障
cluster-node-timeout 15000
# 集群槽位覆盖率要求，1表示所有槽位都可用才对外提供服务
cluster-require-full-coverage yes

# 密码认证（集群所有节点密码必须一致）
requirepass Redis@Cluster_2026
masterauth Redis@Cluster_2026

# 内存与持久化
maxmemory 4G
maxmemory-policy allkeys-lru
appendonly yes
appendfsync everysec
EOF

## 5. 集群创建命令（Redis5.0+ 原生支持）
# 所有节点启动后，一键创建3主3从集群
redis-cli -a Redis@Cluster_2026 --cluster create \
  192.168.1.10:7001 192.168.1.11:7002 192.168.1.12:7003 \
  192.168.1.13:7004 192.168.1.14:7005 192.168.1.15:7006 \
  --cluster-replicas 1
# --cluster-replicas 1 表示每个主节点配1个从节点

## 6. 常用集群运维命令
# 查看集群状态
redis-cli -c -p 7001 -a Redis@Cluster_2026 CLUSTER INFO
# 查看节点列表与槽位分配
redis-cli -c -p 7001 -a Redis@Cluster_2026 CLUSTER NODES
# -c 参数：开启集群重定向模式，自动跳转至目标节点

# --------------------------
# 核心速记
# --------------------------
# 1. 主从：数据备份+读写分离，主库单点，手动切换
# 2. 哨兵：基于主从，自动故障切换，中小业务首选高可用方案
# 3. 集群：16384哈希槽分片，去中心化，大流量大数据场景用
# 4. 选型：单节点内存足够用哨兵；单节点装不下、并发超高用集群
# 5. 硬性规范：哨兵/集群节点必须跨物理机，避免单机故障导致整体失效
```

### 5）常见故障排查

- 缓存雪崩、缓存击穿、缓存穿透原理
- 连接数打满、客户端超时、阻塞问题

```md
# ==================================================
# Redis 常见故障排查 生产运维手册
# 一、业务层经典问题：缓存穿透 / 缓存击穿 / 缓存雪崩
# 二、运维层故障：连接数打满 / 客户端超时 / 服务阻塞
# ==================================================

# --------------------------
# 一、业务层三大经典缓存故障（原理+现象+解决方案）
# --------------------------

# ==================================
# 故障1：缓存穿透
# 原理：查询一条数据库和缓存中都不存在的数据，请求每次都穿透缓存直接打到数据库
# 核心特征：缓存永远不命中，恶意攻击/非法参数最容易触发
# ==================================
## 典型现象
# 1. 缓存命中率骤降，数据库QPS飙升，数据库压力突增
# 2. 请求的都是不存在的ID/非法参数，缓存中无对应key
# 3. 严重时导致数据库被打挂

## 核心根因
# 1. 业务层未做参数校验，非法ID直接透传到数据库
# 2. 空结果没有缓存，每次不存在的查询都走数据库
# 3. 恶意攻击：用大量不存在的key暴力请求

## 解决方案
# 方案1：缓存空值（最简单通用）
#   查询结果为空时，也在Redis中缓存一个空值，设置较短过期时间（如30秒）
#   优点：实现简单；缺点：占用少量内存，可能存在短暂数据不一致
# 方案2：布隆过滤器（Bloom Filter）
#   全量合法key预先存入布隆过滤器，请求先过过滤器，不存在直接返回
#   优点：内存占用极小，拦截效率高；缺点：存在极小误判率，不支持删除
# 方案3：入口层参数校验
#   接口层增加合法性校验，过滤明显非法参数（如ID为负数、格式错误）

# ==================================
# 故障2：缓存击穿
# 原理：某一个热点key突然过期失效，瞬间大量并发请求全部打到数据库
# 核心特征：单个热点key失效，数据库瞬时压力暴增，区别于雪崩的大面积失效
# ==================================
## 典型现象
# 1. 某个热点商品/活动页面瞬间超时，数据库QPS突增后又快速回落
# 2. 刚好对应热点key的过期时间点
# 3. 其他key正常，仅单个热点数据对应接口异常

## 核心根因
# 1. 超高访问量的热点key设置了过期时间，到期瞬间并发全部击穿
# 2. 没有做并发控制，上千个请求同时去查数据库并回写缓存

## 解决方案
# 方案1：互斥锁（分布式锁）
#   缓存失效时，只允许第一个请求去查数据库并回写缓存，其余请求等待重试
#   优点：实现简单，数据一致性好；缺点：有短暂等待，吞吐量略降
# 方案2：热点数据永不过期
#   物理层面不设过期时间，后台异步线程定时更新缓存
#   适用：秒杀、热门商品等极端热点数据
# 方案3：缓存预热
#   活动/大促前，提前将热点数据加载到缓存中，设置合理过期时间

# ==================================
# 故障3：缓存雪崩
# 原理：大面积缓存同时失效，或Redis整体宕机，所有请求全部冲击数据库
# 核心特征：全量/大面积缓存不可用，数据库压力雪崩式增长，极易导致数据库宕机
# ==================================
## 两种典型场景
# 场景A：集中过期型雪崩
#   大量key设置了相同的过期时间，同一时间集体失效，流量全部打向数据库
# 场景B：故障型雪崩
#   Redis主库/集群宕机，缓存完全不可用，所有请求穿透到数据库

## 解决方案
# 针对集中过期：
# 1. 过期时间加随机偏移量，打散失效时间
#    例如：基础过期时间1小时 + 0~300秒随机值，避免同时过期
# 2. 分级缓存：一级内存缓存 + 二级Redis缓存，分层失效
# 针对Redis故障：
# 1. 高可用架构：哨兵/集群模式，自动故障切换，减少宕机时间
# 2. 服务降级与熔断：
#    Redis不可用时，业务接口降级，部分非核心接口直接返回，保护数据库
# 3. 本地缓存兜底：应用层本地缓存部分核心热点数据，顶过切换间隙
# 4. 限流：入口层限制数据库访问QPS，避免数据库被打垮

# --------------------------
# 二、运维层常见故障排查与处理
# --------------------------

# ==================================
# 故障1：连接数打满，客户端无法连接
# 现象：新连接报错 max number of clients reached，业务连接超时
# ==================================
## 1. 排查命令
# 查看当前连接数、最大连接数配置
redis-cli -p 6379 -a 密码 INFO clients
# 关键字段：
# connected_clients：当前已连接客户端数量
# maxclients：最大连接数上限

# 查看所有客户端连接详情，定位异常来源
redis-cli -p 6379 -a 密码 CLIENT LIST
# 重点看：空闲时间idle、连接IP、连接数量分布

## 2. 应急处理
# 临时调大最大连接数（先救业务）
redis-cli -p 6379 -a 密码 CONFIG SET maxclients 10000

# 批量杀掉长时间空闲的无效连接
# 杀掉空闲超过300秒的连接
redis-cli -p 6379 -a 密码 CLIENT KILL TYPE normal idle 300

## 3. 根因与根治
# 根因1：应用端连接池配置过大，多实例部署后总连接数超上限
#   优化：合理设置连接池大小，单应用连接数控制在合理范围
# 根因2：短连接风暴，业务频繁创建销毁连接
#   优化：改用长连接池，复用连接
# 根因3：客户端异常断开，连接未正常释放，堆积大量空闲连接
#   优化：配置Redis超时自动断开空闲连接
cat >> /etc/redis/6379.conf <<'EOF'
# 客户端空闲N秒后自动断开，0表示不限制
timeout 300
EOF

# ==================================
# 故障2：客户端请求超时，响应缓慢
# 现象：业务接口Redis操作超时，延迟飙升，偶发报错
# ==================================
## 排查步骤
# 1. 先查慢日志，定位是否有慢命令阻塞
redis-cli -p 6379 -a 密码 SLOWLOG GET 10
# 慢日志记录执行时间超过阈值的命令，默认阈值10毫秒
# 配置慢日志阈值：CONFIG SET slowlog-log-slower-than 10000 （单位微秒）

# 2. 检查是否存在大key，大key读写都会阻塞
redis-cli -p 6379 -a 密码 --bigkeys

# 3. 检查持久化fork耗时，fork期间主线程阻塞
redis-cli -p 6379 -a 密码 INFO stats | grep latest_fork_usec
# 单位微秒，数值越大阻塞时间越长，大内存实例更明显

# 4. 检查网络延迟
ping Redis服务器IP
telnet 服务器IP 6379
# 跨机房、网络抖动都会导致客户端超时

## 常见根因
# 1. 慢命令：KEYS、FLUSHALL、大集合全量遍历等
# 2. 大key：超大string/集合读写，网络+内存拷贝耗时久
# 3. 持久化阻塞：AOF重写、RDB快照fork子进程阻塞
# 4. 主从切换：哨兵/集群切换期间，秒级不可用

## 优化方向
# 1. 禁用高危慢命令，用SCAN替代KEYS
# 2. 拆分大key，集合类分批操作
# 3. 合理设置持久化策略，避免高峰期触发重写
# 4. 客户端配置合理超时与重试机制

# ==================================
# 故障3：Redis 整体阻塞，完全无响应
# 现象：所有命令都超时，Redis进程存活但不响应请求
# ==================================
## 快速排查定位
# 1. 查看Redis运行状态，进程是否存在
ps aux | grep redis
# 2. 查看内存使用，是否触发OOM
free -h
dmesg | grep oom
# 3. 查看磁盘IO，AOF刷盘是否打满磁盘
iotop
# 4. 查看日志，捕获异常信息
tail -f /var/log/redis/6379.log

## 常见阻塞根因
# 1. 执行了超慢命令：全库KEYS、超大集合排序/聚合，主线程被占住
# 2. 内存满了+noeviction策略，所有写入都阻塞报错
# 3. AOF刷盘阻塞：磁盘IO打满，fsync一直等待
# 4. 大内存实例fork子进程：生成RDB/AOF重写时，fork耗时过长阻塞主线程
# 5. 内存交换：Redis数据被系统换到swap，读写性能暴跌

## 应急与优化
# 应急：
# - 若慢命令阻塞：找到进程ID，重启Redis实例（低峰操作）
# - 若内存满：临时调大maxmemory，清理大key冷数据
# - 若AOF阻塞：临时关闭AOF，业务恢复后再开启
# 根治：
# 1. 生产禁用KEYS、FLUSHALL等高危命令，或重命名
# 2. 合理设置maxmemory与淘汰策略，杜绝OOM
# 3. 关闭系统swap，防止Redis内存被交换
echo "vm.swappiness = 0" >> /etc/sysctl.conf
sysctl -p
# 4. 大内存实例优化持久化策略，减少fork频率

# --------------------------
# 核心速记
# --------------------------
# 1. 业务三剑客：
#    穿透：查不存在的数据 → 空缓存+布隆过滤器
#    击穿：单热点key过期 → 互斥锁+热点永不过期
#    雪崩：大面积失效/宕机 → 随机过期+高可用+降级限流
# 2. 连接爆满：先调上限、杀空闲连接，再优化连接池
# 3. 超时阻塞：先查慢日志与大key，再看持久化fork与磁盘IO
# 4. 运维底线：关闭swap、设内存上限、重命名高危命令，从源头减少故障
```

### 命令行下使用redis

```md
# Redis 官方自带客户端 redis-cli 全教程
# 模块1：redis-cli 登录/连接/认证全套命令
# 模块2：全局通用key管理、运维监控命令
# 模块3：5大基础原生数据结构（全命令+示例+场景）
# 模块4：3大高级原生数据结构（Bitmap/HLL/Geo，Redis自带无需插件）
# 模块5：Lua脚本、集群、生产避坑总结

# ======================
# 一、redis-cli 客户端登录、连接、认证操作（所有生产必用）
# ======================
# 1. 默认本地无密码登录 127.0.0.1:6379 数据库0
redis-cli

# 2. 指定IP、端口连接远程Redis
# -h 指定主机IP  -p 指定端口
redis-cli -h 192.168.1.10 -p 6379

# 3. 连接时直接携带密码登录（-a）
redis-cli -h 192.168.1.10 -p 6379 -a Redis@2026

# 4. 安全登录：先连服务，进入客户端再输密码 AUTH（推荐，密码不暴露进程列表）
redis-cli -h 192.168.1.10 -p 6379
# 进入交互界面执行认证
AUTH Redis@2026

# 5. 连接时直接指定数据库（0~15，默认db0）-n
redis-cli -h 127.0.0.1 -p 6379 -n 1 -a 123456

# 6. Redis Cluster 集群连接加 -c 自动槽位重定向
redis-cli -c -h 192.168.1.10 -p 7001 -a 123456

# 7. URL格式一键连接（redis://账号:密码@IP:端口/库）
redis-cli -u redis://admin:Redis@2026@127.0.0.1:6379/0

# 8. 退出客户端交互界面
exit
quit

# 9. 非交互模式：一行命令直接执行后退出（脚本批量使用）
redis-cli -a 123456 GET user:info:1001
redis-cli -a 123456 SET test 123

# 10. 连通性测试，返回PONG代表正常
redis-cli PING

# ======================
# 二、全局通用命令（所有数据结构共用：key操作、数据库、运维监控）
# ======================
## 2.1 数据库切换、基础交互
SELECT 1          # 切换到db1（0~15共16个库）
DBSIZE            # 查看当前库key总数
FLUSHDB           # 清空当前数据库（生产禁用）
FLUSHALL          # 清空所有数据库（高危，生产重命名屏蔽）

## 2.2 Key 通用管理命令（全部数据结构通用）
SET key val           # 创建key
GET key               # 查询key值
TYPE key              # 查看key对应的数据结构类型
EXISTS key            # 判断key是否存在，1存在 0不存在
DEL key1 key2         # 删除key（阻塞大key，4.0+推荐UNLINK）
UNLINK key            # 异步删除大key，后台释放内存，不阻塞主线程
EXPIRE key 3600       # 设置key过期时间3600秒
TTL key               # 查看剩余过期秒数，-1永久，-2已过期
PERSIST key           # 移除过期时间，永久保存
RENAME old new        # 重命名key
KEYS user:*           # 模糊匹配所有user开头key（生产禁用，阻塞）
SCAN 0 MATCH user:* COUNT 100  # 分批遍历key，线上安全替代KEYS

## 2.3 运维监控、故障排查命令
INFO                  # 全量服务状态（内存、连接、持久化、主从）
INFO memory           # 仅查看内存使用、碎片率
INFO replication      # 主从同步状态
INFO clients          # 当前客户端连接
CLIENT LIST           # 列出所有连接IP、空闲时长
CLIENT KILL 192.168.1.5:51230  # 强制断开指定客户端
SLOWLOG GET 10        # 查询最近10条慢命令
MONITOR               # 实时打印所有执行命令（压测环境慎用）
CONFIG GET maxmemory  # 查询配置项
CONFIG SET maxmemory 8G  # 临时修改配置

## 2.4 持久化运维
BGSAVE                # 后台异步生成RDB快照（生产推荐）
SAVE                  # 同步阻塞生成RDB，大内存禁用
PURGE BINARY LOGS TO mysql-bin.00120  # 清理过期binlog

# ======================
# 三、五大基础原生数据结构（Redis2.0全版本自带，开发核心）
# ======================
## 3.1 String 字符串（最基础，二进制安全，最大512MB）
# 适用：验证码、Token、计数器、库存、简单缓存
SET user:token:1001 abc123 EX 3600  # 写入+过期时间
GET user:token:1001
MSET k1 v1 k2 v2    # 批量写入
MGET k1 k2          # 批量读取
INCR article:view:99    # 原子自增1（并发安全计数器）
INCRBY stock:goods:10 5 # 自增5
DECR stock:goods:10     # 原子减1（库存扣减）
STRLEN key         # 获取字符串长度
APPEND key suffix  # 字符串追加内容

## 3.2 Hash 哈希（key-field-value，适合对象存储）
# 适用：用户信息、商品属性，无需序列化JSON，单字段更新
HSET user:info:1001 name "张三" age 25
HGET user:info:1001 name
HMSET user:info:1002 name "李四" phone 13800138000
HMGET user:info:1002 name phone
HGETALL user:info:1001  # 获取全部字段（大hash阻塞，禁止线上）
HKEYS user:info:1001    # 获取所有字段名
HVALS user:info:1001    # 获取所有字段值
HINCRBY user:info:1001 score 10  # 字段原子自增
HDEL user:info:1001 age  # 删除单个字段
HLEN user:info:1001     # 字段总数
HSCAN 0 MATCH user:* COUNT 50  # 分批遍历大hash

## 3.3 List 列表（有序可重复，双向链表，头尾操作O(1)）
# 适用：简易消息队列、时间线、栈
LPUSH msg:queue order001 order002  # 头部插入（左进）
RPUSH msg:queue order003           # 尾部插入（右进）
LPOP msg:queue      # 头部弹出
RPOP msg:queue      # 尾部弹出（FIFO队列）
BLPOP msg:queue 10  # 阻塞弹出，10秒超时无消息返回
LRANGE msg:queue 0 9  # 分页读取前10条，0 -1代表全量（禁止大list）
LLEN msg:queue       # 列表长度
LTRIM msg:queue 0 9  # 裁剪列表，只保留前10条（清理旧数据）
LINDEX msg:queue 0   # 获取指定下标元素

## 3.4 Set 集合（无序、元素唯一，哈希表实现）
# 适用：点赞、去重、共同好友、黑白名单
SADD article:like:99 user1001 user1002
SISMEMBER article:like:99 user1001  # 判断是否存在
SCARD article:like:99    # 集合元素总数（点赞数）
SMEMBERS article:like:99 # 取出全部元素（大set阻塞，禁用）
SSCAN 0 MATCH * COUNT 100 # 分批遍历大集合
SREM article:like:99 user1001 # 删除元素
SINTER user:friend:1001 user:friend:1002 # 交集（共同好友）
SUNION 集合1 集合2 # 并集
SDIFF 集合1 集合2  # 差集

## 3.5 ZSet 有序集合（唯一元素，带score权重自动排序）
# 适用：排行榜、热搜、优先级队列
ZADD hot:rank 1200 "Python教程" 850 "Redis实战"
ZINCRBY hot:rank 50 "Redis实战" # 热度+50
ZREVRANGE hot:rank 0 2 WITHSCORES # 倒序Top3（高分在前）
ZRANGE hot:rank 0 2 WITHSCORES    # 正序
ZREVRANK hot:rank "Redis实战"     # 查询排名（从0开始）
ZCARD hot:rank                    # 元素总数
ZREM hot:rank "Python教程"        # 删除元素
ZSCAN 0 COUNT 50                 # 分批遍历大zset

# ======================
# 四、三大高级原生数据结构（Redis自带，无需额外模块）
# ======================
## 4.1 Bitmap 位图（底层String，Redis2.2+自带，1bit存状态）
# 适用：签到、日活、用户在线状态，极度省内存
SETBIT sign:user:1001:2026 15 1  # 第15位设1（当月15号签到）
GETBIT sign:user:1001:2026 15    # 查询当天是否签到
BITCOUNT sign:user:1001:2026     # 统计总签到天数（值为1的bit总数）
BITOP AND dau_2day dau0714 dau0715 # 位运算，统计两日留存

## 4.2 HyperLogLog(HLL) 基数统计（Redis2.8.9+原生）
# 适用：页面UV、海量去重计数，固定12KB内存，误差0.81%
PFADD uv:page:home user1001 user1002 user1003
PFCOUNT uv:page:home # 统计独立访客总数
PFMERGE uv:total uv:page:home uv:page:detail # 合并多页面UV

## 4.3 Geo 地理位置（Redis3.2+原生，底层封装ZSet）
# 适用：附近商家、LBS距离计算
GEOADD geo:shop 116.397 39.908 shop001 # 添加经纬度点位
GEODIST geo:shop shop001 shop002 km # 两点距离，单位km/m
GEORADIUS geo:shop 116.397 39.908 2 km WITHDIST ASC # 2公里内商家按距离排序
GEOPOS geo:shop shop001 # 查询点位经纬度
ZREM geo:shop shop001 # Geo无专属删除命令，底层ZSet删除

# ======================
# 五、Lua 脚本通用命令（原子操作，所有数据结构通用）
# ======================
# 直接执行Lua脚本，KEYS传键，ARGV传参数，单线程原子执行
EVAL "local s=tonumber(redis.call('GET',KEYS[1]));if s>0 then return redis.call('DECR',KEYS[1]) else return -1 end" 1 stock:goods:10
# 预加载脚本SHA1，减少网络传输
SCRIPT LOAD "lua代码"
EVALSHA 脚本SHA1 1 key 参数

# ======================
# 六、核心总结&开发规范
# ======================
# 1. redis-cli登录要点：生产优先先连接再AUTH，避免-a明文密码暴露
# 2. 通用key禁忌：线上禁止KEYS、HGETALL、SMEMBERS全量遍历，改用SCAN系列
# 3. 8种Redis原生自带数据结构：
#    基础5种：String / Hash / List / Set / ZSet
#    高级3种：Bitmap / HyperLogLog / Geo
# 4. 高级结构版本底线：
#    Bitmap ≥2.2 ；HLL≥2.8.9 ；Geo≥3.2
# 5. 生产删除大key：统一使用UNLINK，不使用DEL防止阻塞
# 6. 集群操作限制：多key命令(MGET/MSET/Lua)所有key必须同一HashTag槽位，否则报错
```

### 开发视角 Redis 核心学习路线

#### 5 种基础数据结构 + python 整合 + 缓存读写模式 + 分布式锁

```md
# ==================================================
# Redis 开发第一优先级 从零实战（Python版）
# 完整覆盖：1. 5种基础数据结构  2. Python Web 整合
#           3. Cache Aside 缓存读写模式  4. 分布式锁正确实现
# ==================================================

# --------------------------
# 0. 前置环境准备
# 依赖：本地/服务器已运行 Redis，Python 3.7+
# --------------------------
# 安装 Python 官方 Redis 客户端 + Flask Web 框架
pip3 install redis flask

# 快速验证 Redis 连接
python3 -c "
import redis
r = redis.Redis(host='127.0.0.1', port=6379, decode_responses=True)
print('Redis 连接测试:', r.ping())
"
# decode_responses=True：自动将 bytes 解码为字符串，开发阶段必加，避免编码问题
# 输出 True 表示环境正常，可继续后续实战

# --------------------------
# 一、5 种基础数据结构实战（开发核心基本功）
# 核心原则：先选对数据结构，再写代码；避免大 key、全量遍历
# --------------------------
cat > 01_basic_types.py <<'EOF'
import redis
r = redis.Redis(host='127.0.0.1', port=6379, decode_responses=True)

# ==================================
# 1. String 字符串类型
# 适用场景：验证码、登录 Token、计数器、库存、分布式 ID
# 本质：二进制安全，可存字符串/数字/二进制数据
# ==================================
print("===== 1. String 实战 =====")

# 基础读写 + 过期时间（生产所有业务 key 必须加 TTL，防止冷数据堆积）
r.set('user:token:1001', 'abc123xyz789', ex=3600)  # ex=过期秒数
print("登录 Token:", r.get('user:token:1001'))

# 原子计数器：文章浏览量（incr 是原子操作，并发不会出错）
r.incr('article:views:99')          # 自增 1
r.incrby('article:views:99', 5)     # 自增 5
print("文章浏览量:", r.get('article:views:99'))

# 库存扣减（原子操作，避免超卖）
r.set('goods:stock:10', 100)
remain = r.decr('goods:stock:10')   # 原子减 1
print("扣减后剩余库存:", remain)

# ❌ 避坑：不要把大 JSON 对象全塞一个 String 变成大 key
# ❌ 避坑：不要用 get 取值 → 代码计算 → set 写回，非原子会并发超卖
# ✅ 正确：计数类直接用 incr/decr 原子命令

# ==================================
# 2. Hash 哈希类型
# 适用场景：用户信息、商品详情等对象属性存储
# 优势：比 JSON 序列化更省空间，支持单字段读写，不用全量修改
# ==================================
print("\n===== 2. Hash 实战 =====")

# 单字段写入用户信息
r.hset('user:info:1001', 'name', '张三')
r.hset('user:info:1001', 'age', 25)
r.hset('user:info:1001', 'phone', '13800138000')

# 读取单个字段
print("用户名:", r.hget('user:info:1001', 'name'))
# 读取全量字段
user_info = r.hgetall('user:info:1001')
print("用户全量信息:", user_info)
# 单字段原子自增
r.hincrby('user:info:1001', 'score', 10)
print("用户积分:", r.hget('user:info:1001', 'score'))

# ❌ 避坑：字段不要超过 1000 个，避免大 hash
# ❌ 避坑：禁止用 hgetall 遍历大 hash，会阻塞 Redis
# ✅ 正确：大 hash 用 hscan 分批遍历

# ==================================
# 3. List 列表类型
# 适用场景：简单消息队列、文章时间线、栈/队列结构
# 本质：双向链表，头尾操作极快，中间插入删除性能差
# ==================================
print("\n===== 3. List 实战 =====")

# 消息队列：左进右出（FIFO 先进先出）
r.lpush('msg:order_queue', 'order_001')
r.lpush('msg:order_queue', 'order_002')
r.lpush('msg:order_queue', 'order_003')

# 消费一条消息
msg = r.rpop('msg:order_queue')
print("消费订单消息:", msg)

# 时间线：最新内容排在最前面
r.lpush('user:timeline:1001', '发布了 Python 教程')
r.lpush('user:timeline:1001', '点赞了 Redis 实战文章')
# 分页取前 10 条
timeline = r.lrange('user:timeline:1001', 0, 9)
print("个人时间线:", timeline)

# ❌ 避坑：不要用 lrange 0 -1 全量读取大列表
# ❌ 避坑：不要在列表中间做插入删除
# ✅ 正确：只操作头尾，固定范围分页

# ==================================
# 4. Set 集合类型
# 适用场景：点赞、去重、共同好友、标签、黑白名单
# 特性：无序、不可重复，支持交/并/差集运算
# ==================================
print("\n===== 4. Set 实战 =====")

# 文章点赞：天然去重，同一个用户重复点赞不会计数
r.sadd('article:like:99', 'user_1001')
r.sadd('article:like:99', 'user_1002')
r.sadd('article:like:99', 'user_1003')

# 判断是否已点赞（幂等校验）
is_liked = r.sismember('article:like:99', 'user_1001')
print("用户 1001 是否已点赞:", bool(is_liked))

# 点赞总数
like_count = r.scard('article:like:99')
print("文章总点赞数:", like_count)

# 共同好友：两个用户的好友交集
r.sadd('user:friend:1001', 'a','b','c','d')
r.sadd('user:friend:1002', 'b','c','e','f')
common_friends = r.sinter('user:friend:1001', 'user:friend:1002')
print("两个用户共同好友:", common_friends)

# ❌ 避坑：元素过多不要用 smembers 全量取出，大集合会阻塞 Redis
# ✅ 正确：大集合用 sscan 分批遍历

# ==================================
# 5. ZSet 有序集合
# 适用场景：排行榜、热搜榜、优先级队列、范围查找
# 特性：元素不可重复，每个元素带 score 权重，按 score 自动排序
# ==================================
print("\n===== 5. ZSet 实战 =====")

# 热搜排行榜：score 为热度值
r.zadd('hot:search_rank', {'Python入门': 1200, 'Redis实战': 850, 'MySQL优化': 2100})
r.zincrby('hot:search_rank', 50, 'Redis实战')  # 热度 +50

# Top3 热搜（倒序，从高到低，带分数）
top3 = r.zrevrange('hot:search_rank', 0, 2, withscores=True)
print("热搜榜 Top3:", top3)

# 查询指定内容排名
rank = r.zrevrank('hot:search_rank', 'MySQL优化')
print("MySQL优化 排名第:", rank+1)  # 排名从 0 开始，+1 转为自然排名

# ❌ 避坑：不要全量取出大 zset；相同 score 排序不保证按时间
# ✅ 正确：按范围分页取，需要时间维度可把时间戳拼到 score 里
EOF

# 运行数据结构实战脚本
python3 01_basic_types.py

# --------------------------
# 二、Python Web 整合 + Cache Aside 缓存读写模式
# 模式说明：旁路缓存模式，是业务开发最常用的缓存方案
# 读流程：先查缓存 → 命中返回 → 未命中查库 → 写入缓存再返回
# 写流程：先更新数据库 → 再删除缓存（不是更新缓存！）
# --------------------------
cat > 02_cache_aside.py <<'EOF'
from flask import Flask, jsonify
import redis
import time

app = Flask(__name__)
# Redis 连接初始化
cache = redis.Redis(host='127.0.0.1', port=6379, decode_responses=True)
# 模拟数据库（生产环境替换为 MySQL 等真实数据库）
mock_db = {
    1001: {'id':1001, 'name':'张三', 'age':25},
    1002: {'id':1002, 'name':'李四', 'age':30}
}

# ==================================
# 读接口：标准 Cache Aside 读流程
# ==================================
@app.route('/user/<int:user_id>')
def get_user(user_id):
    cache_key = f'user:info:{user_id}'

    # 第一步：优先查询缓存
    user_cache = cache.get(cache_key)
    if user_cache is not None:
        if user_cache == '':
            return jsonify({"code":1, "msg":"用户不存在"})
        print("[命中缓存] 直接返回")
        return jsonify({"code":0, "data": user_cache, "from":"cache"})

    # 第二步：缓存未命中，查询数据库
    print("[缓存未命中] 查询数据库")
    time.sleep(0.1)  # 模拟数据库查询耗时
    user = mock_db.get(user_id)

    if not user:
        # 缓存穿透优化：空值也缓存，设置短过期时间，防止反复打数据库
        cache.setex(cache_key, 60, '')
        return jsonify({"code":1, "msg":"用户不存在"})

    # 第三步：数据写入缓存，设置过期时间（兜底最终一致性）
    cache.setex(cache_key, 3600, str(user))
    return jsonify({"code":0, "data": user, "from":"database"})

# ==================================
# 写接口：标准 Cache Aside 写流程
# 核心原则：先更新数据库，再删除缓存
# 为什么不更新缓存？并发场景下会出现脏数据，删除缓存更简单可靠
# ==================================
@app.route('/user/update', methods=['POST'])
def update_user():
    user_id = 1001
    new_age = 26
    cache_key = f'user:info:{user_id}'

    # 第一步：更新数据库
    mock_db[user_id]['age'] = new_age
    print("[数据库] 更新完成")

    # 第二步：删除缓存（下次查询自动加载最新数据）
    cache.delete(cache_key)
    print("[缓存] 已删除")

    # ❌ 错误写法1：先删缓存再更数据库 → 并发读会把旧数据写回缓存
    # ❌ 错误写法2：更新完数据库直接更新缓存 → 并发写会导致脏数据
    # ✅ 进阶优化：延迟双删，解决极小概率脏数据
    # time.sleep(0.2)
    # cache.delete(cache_key)

    return jsonify({"code":0, "msg":"更新成功"})

if __name__ == '__main__':
    app.run(port=5000, debug=False)
EOF

# 启动 Web 服务（后台运行测试）
# python3 02_cache_aside.py &
# 测试命令：
# 第一次读：curl http://127.0.0.1:5000/user/1001  → 走数据库
# 第二次读：curl http://127.0.0.1:5000/user/1001  → 命中缓存
# 更新写：curl -X POST http://127.0.0.1:5000/user/update
# 更新后第一次读：重新从数据库加载最新数据

# --------------------------
# 三、分布式锁 从零正确实现
# 核心作用：分布式系统下控制共享资源并发访问，如库存扣减、防重复提交
# 正确三要素：1. 加锁原子性  2. 锁归属唯一  3. 释放原子性
# --------------------------
cat > 03_distributed_lock.py <<'EOF'
import redis
import uuid
import time

r = redis.Redis(host='127.0.0.1', port=6379, decode_responses=True)

class RedisDistributedLock:
    def __init__(self, lock_key, expire_time=10):
        self.lock_key = lock_key
        self.expire_time = expire_time  # 锁自动过期时间，防止服务宕机死锁
        self.lock_value = str(uuid.uuid4())  # 唯一标识，保证只能自己释放自己的锁

    # ==================================
    # 加锁：原子操作，set nx ex 一条命令完成
    # nx = key 不存在才设置成功（互斥性）
    # ex = 自动过期时间
    # ==================================
    def acquire(self):
        # 原子加锁：成功返回 True，失败返回 False
        result = r.set(self.lock_key, self.lock_value, nx=True, ex=self.expire_time)
        return result is not None

    # ==================================
    # 释放锁：Lua 脚本保证原子性（判断归属 + 删除）
    # 为什么不用 get + del？两步非原子，可能误删别人的锁
    # ==================================
    def release(self):
        # Lua 脚本：如果 key 的值等于自己的标识，才执行删除
        lua_script = """
        if redis.call('get', KEYS[1]) == ARGV[1] then
            return redis.call('del', KEYS[1])
        else
            return 0
        end
        """
        # 注册并执行 Lua 脚本，KEYS[1] 是锁 key，ARGV[1] 是自己的唯一值
        unlock_script = r.register_script(lua_script)
        result = unlock_script(keys=[self.lock_key], args=[self.lock_value])
        return result == 1

# ==================================
# 实战测试：模拟库存扣减并发场景
# ==================================
def stock_deduct_test():
    # 创建锁对象，锁粒度：单个商品库存
    lock = RedisDistributedLock('lock:goods:10', expire_time=5)

    # 尝试加锁
    if lock.acquire():
        print("[加锁成功] 执行库存扣减业务")
        try:
            # 业务逻辑：读取库存 → 判断 → 扣减
            stock = int(r.get('goods:stock:10') or 0)
            if stock > 0:
                r.decr('goods:stock:10')
                print(f"[扣减成功] 剩余库存: {stock-1}")
            else:
                print("[扣减失败] 库存不足")
            time.sleep(2)  # 模拟业务处理耗时
        finally:
            # 必须在 finally 中释放锁，防止业务异常导致死锁
            lock.release()
            print("[锁已释放]")
    else:
        print("[加锁失败] 资源被占用，稍后重试")

if __name__ == '__main__':
    # 初始化测试库存
    r.set('goods:stock:10', 10)
    stock_deduct_test()
EOF

# 运行分布式锁测试
python3 03_distributed_lock.py

# 避坑红线（必须牢记）
# ❌ 错误1：分开执行 set + expire → 中间宕机，锁永不过期，造成死锁
# ❌ 错误2：锁 value 不唯一 → 线程A的锁过期了，线程B加了锁，线程A误删B的锁
# ❌ 错误3：get 判断后 del 释放 → 两步非原子，判断完锁刚好过期，误删别人的锁
# ✅ 正确标准：set nx ex 原子加锁；唯一 value 标识归属；Lua 脚本原子释放

# 进阶问题说明
# 1. 锁续期：业务执行时间超过过期时间 → 启动守护线程，快过期时自动续期（看门狗机制）
# 2. 可重入：同一个线程多次加锁 → 记录加锁次数，释放时计数减一
# 3. 生产推荐：直接用成熟库 redlock-py，不建议业务自己造轮子
# 安装命令：pip3 install redlock-py

# --------------------------
# 核心速记
# --------------------------
# 1. 数据选型：计数用String、对象用Hash、队列用List、去重用Set、排序用ZSet
# 2. 缓存模式：读先查缓存、未命中查库回写；写先更数据库、再删缓存
# 3. 分布式锁：原子加锁、唯一归属、原子释放、必设过期、finally释放
# 4. 开发底线：所有 key 加过期时间、禁用全量遍历命令、避免大 key
```

#### 三大缓存问题方案 + 典型业务场景实现 + 大 key / 热 key 避坑

```md
# ==================================================
# Redis 开发第二优先级 从零实战（Python版）
# 完整覆盖： 1. 三大缓存问题代码级方案
#           2. 高频典型业务场景实现
#           3. 大 key / 热 key 避坑实战
# ==================================================

# 前置依赖安装
pip3 install redis flask

# --------------------------
# 一、三大缓存问题 代码级解决方案
# 穿透 / 击穿 / 雪崩 从原理到落地实现
# --------------------------
cat > 01_cache_problems.py <<'EOF'
import redis
import time
import random
import uuid

r = redis.Redis(host='127.0.0.1', port=6379, decode_responses=True)
mock_db = {}  # 模拟数据库

# ==================================
# 1. 缓存穿透
# 问题：查询数据库和缓存都不存在的数据，请求全部穿透到数据库
# 危害：恶意攻击可直接打垮数据库
# 方案1：空值缓存（简单通用，90%场景够用）
# 方案2：布隆过滤器（海量数据场景，拦截不存在的key）
# ==================================
print("===== 1. 缓存穿透解决方案 =====")

# ---------- 方案1：空值缓存 ----------
def get_user_with_null_cache(user_id):
    cache_key = f'user:info:{user_id}'
    # 1. 查缓存
    cache_val = r.get(cache_key)
    if cache_val is not None:
        if cache_val == '':
            print("[空缓存命中] 直接返回，不查数据库")
            return None
        print("[缓存命中] 直接返回")
        return cache_val

    # 2. 缓存未命中，查数据库
    print("[缓存未命中] 查询数据库")
    user = mock_db.get(user_id)

    if not user:
        # 核心：空结果也写入缓存，设置较短过期时间
        # 既防止反复打数据库，又避免长期占用内存
        r.setex(cache_key, 60, '')  # 空值只存60秒
        print("[空值写入缓存] 60秒内相同请求不再打库")
        return None

    # 3. 正常数据写入缓存
    r.setex(cache_key, 3600, str(user))
    return user

# 测试：连续查询不存在的用户
# get_user_with_null_cache(9999)
# get_user_with_null_cache(9999)


# ---------- 方案2：布隆过滤器 ----------
# 原理：将所有合法ID预先存入过滤器，请求先过过滤器
# 特点：判断不存在100%准确；判断存在有极小概率误判
# 生产推荐：使用 RedisBloom 模块，这里演示核心逻辑
class SimpleBloomFilter:
    def __init__(self, size=10000):
        self.size = size
        self.bit_key = 'bloom:user_id'
        r.delete(self.bit_key)  # 演示用清空

    def _hash(self, value):
        # 简化版：多个哈希函数映射到不同位
        return hash(str(value)) % self.size

    def add(self, value):
        """将合法ID加入布隆过滤器"""
        pos = self._hash(value)
        r.setbit(self.bit_key, pos, 1)

    def might_exist(self, value):
        """判断是否可能存在：False=一定不存在；True=可能存在"""
        pos = self._hash(value)
        return r.getbit(self.bit_key, pos) == 1

# 初始化：预加载全量合法用户ID
bloom = SimpleBloomFilter()
for uid in range(1, 1001):
    bloom.add(uid)  # 合法ID 1~1000

def get_user_with_bloom(user_id):
    # 第一步：先过布隆过滤器，不存在直接返回
    if not bloom.might_exist(user_id):
        print("[布隆拦截] ID不存在，直接拒绝，不打缓存和数据库")
        return None
    # 第二步：正常走缓存+数据库流程
    return get_user_with_null_cache(user_id)

# 测试：非法ID直接被拦截
get_user_with_bloom(99999)
get_user_with_bloom(500)

# 避坑：布隆过滤器不支持删除，数据变动频繁的场景慎用
# 生产建议：用 RedisBloom 官方模块，支持更多哈希函数、更低误判率


# ==================================
# 2. 缓存击穿
# 问题：单个热点key突然过期，瞬间大量并发全部打到数据库
# 特点：仅单个热点key失效，数据库瞬时压力暴增
# 方案1：互斥锁（通用方案，只让一个请求查库回写）
# 方案2：热点永不过期（极端热点场景，后台异步更新）
# ==================================
print("\n===== 2. 缓存击穿解决方案 =====")

# ---------- 方案1：互斥锁方案 ----------
def get_hot_data_with_lock(goods_id):
    cache_key = f'goods:info:{goods_id}'
    lock_key = f'lock:goods:{goods_id}'

    # 1. 正常查缓存
    data = r.get(cache_key)
    if data:
        return data

    # 2. 缓存未命中，尝试加锁
    lock_value = str(uuid.uuid4())
    lock_ok = r.set(lock_key, lock_value, nx=True, ex=3)

    if lock_ok:
        try:
            # 3. 拿到锁的线程查数据库并回写缓存
            print("[拿到锁] 查询数据库，回写缓存")
            time.sleep(0.2)  # 模拟数据库查询
            mock_data = f'商品{goods_id}详情'
            r.setex(cache_key, 3600, mock_data)
            return mock_data
        finally:
            # 释放锁
            if r.get(lock_key) == lock_value:
                r.delete(lock_key)
    else:
        # 4. 没拿到锁的线程，等待重试
        print("[未拿到锁] 等待100ms后重试")
        time.sleep(0.1)
        return get_hot_data_with_lock(goods_id)


# ---------- 方案2：热点数据永不过期 ----------
# 原理：物理上不设过期时间，后台异步线程定时更新缓存
# 适用：秒杀商品、首页热点数据等极端热点场景
def update_hot_data_async(goods_id):
    """后台异步更新任务，定时执行"""
    cache_key = f'goods:hot:{goods_id}'
    new_data = f'商品{goods_id}最新数据_{int(time.time())}'
    r.set(cache_key, new_data)  # 不设过期时间
    print(f"[后台更新] 热点数据已刷新")

def get_hot_data_forever(goods_id):
    """读接口：永远直接读缓存，不担心过期击穿"""
    cache_key = f'goods:hot:{goods_id}'
    return r.get(cache_key)


# ==================================
# 3. 缓存雪崩
# 问题：大面积缓存同时失效，或Redis整体宕机，全量请求打数据库
# 方案1：过期时间加随机偏移，打散失效点（预防集中过期型雪崩）
# 方案2：本地二级缓存兜底，顶过Redis故障间隙
# ==================================
print("\n===== 3. 缓存雪崩解决方案 =====")

# ---------- 方案1：随机过期打散 ----------
def set_cache_with_random_ttl(key, value, base_ttl=3600):
    """基础过期时间 + 0~300秒随机偏移，避免同时过期"""
    random_ttl = base_ttl + random.randint(0, 300)
    r.setex(key, random_ttl, value)
    print(f"设置缓存 {key}，过期时间 {random_ttl} 秒")

# 批量设置缓存，过期时间全部打散
for i in range(10):
    set_cache_with_random_ttl(f'product:{i}', f'商品{i}数据')


# ---------- 方案2：本地二级缓存兜底 ----------
# 一级：本地内存缓存（极快，容量小） 二级：Redis（容量大，共享）
# Redis故障时，降级到本地缓存，保护数据库
local_cache = {}  # 生产用 LRU 字典 / cachetools 库

def get_data_with_multilevel(key):
    # 1. 先查本地缓存
    if key in local_cache:
        print("[本地缓存命中]")
        return local_cache[key]

    # 2. 再查 Redis，加异常捕获
    try:
        data = r.get(key)
        if data:
            print("[Redis命中]，同步到本地缓存")
            local_cache[key] = data  # 同步到本地缓存
            return data
    except Exception as e:
        print(f"[Redis故障] {e}，降级本地缓存")

    # 3. Redis不可用或未命中，查数据库（限流保护，避免雪崩）
    print("[数据库查询]")
    data = f'数据库数据_{key}'
    local_cache[key] = data  # 写入本地缓存兜底
    return data

# 测试多级缓存
get_data_with_multilevel('product:1')
get_data_with_multilevel('product:1')

# 避坑：本地缓存要设置最大容量+过期时间，避免内存溢出
# 生产推荐：使用 cachetools 实现带LRU淘汰的本地缓存
EOF

# 运行三大缓存问题示例
python3 01_cache_problems.py


# --------------------------
# 二、典型业务场景实战
# 覆盖开发最高频的4类场景：限流、幂等、签到、排行榜
# --------------------------
cat > 02_business_scenarios.py <<'EOF'
import redis
import time
import uuid

r = redis.Redis(host='127.0.0.1', port=6379, decode_responses=True)

# ==================================
# 场景1：接口限流（防刷、防恶意请求）
# 实现：固定窗口计数器，简单高效；进阶可用滑动窗口
# ==================================
print("===== 场景1：接口限流 =====")

def rate_limit(user_id, limit=10, period=60):
    """
    限制用户每分钟最多请求10次
    user_id: 用户标识
    limit: 周期内最大次数
    period: 周期秒数
    """
    key = f'rate:limit:{user_id}'
    count = r.incr(key)
    if count == 1:
        # 第一次访问，设置过期时间
        r.expire(key, period)

    if count > limit:
        print(f"[限流触发] 用户{user_id}第{count}次请求，已超限")
        return False
    else:
        print(f"[请求通过] 用户{user_id}第{count}次请求")
        return True

# 测试：连续请求12次
for i in range(12):
    rate_limit('user_1001')

# 进阶方案：滑动窗口限流（用ZSet实现，精度更高）
# 令牌桶限流（适合平滑流量），生产按需选型


# ==================================
# 场景2：接口幂等性（防重复提交）
# 场景：订单提交、支付回调、表单重复提交
# 原理：先获取唯一幂等token，提交时校验并删除token，保证只执行一次
# ==================================
print("\n===== 场景2：接口幂等校验 =====")

def generate_idempotent_token(user_id):
    """生成幂等token，返回给前端，提交时携带"""
    token = str(uuid.uuid4())
    key = f'idempotent:{user_id}:{token}'
    r.setex(key, 300, '1')  # 5分钟有效期
    print(f"生成幂等token: {token}")
    return token

def check_idempotent(user_id, token):
    """提交时校验：删除成功表示第一次提交，失败表示重复提交"""
    key = f'idempotent:{user_id}:{token}'
    # 用 del 原子操作：存在则删除返回1，不存在返回0
    result = r.delete(key)
    if result == 1:
        print("[校验通过] 首次提交，执行业务逻辑")
        return True
    else:
        print("[重复提交] 校验失败，拒绝处理")
        return False

# 测试
token = generate_idempotent_token('user_1001')
check_idempotent('user_1001', token)
check_idempotent('user_1001', token)


# ==================================
# 场景3：用户签到 + 连续签到统计
# 实现：Bitmap 位图，1bit存一天签到状态，极省内存
# 亿级用户全年签到也只占十几MB内存
# ==================================
print("\n===== 场景3：用户签到统计 =====")

def user_sign(user_id, date_str='20260714'):
    """用户签到：key按年分，offset用一年中的第几天"""
    day_of_year = int(time.strftime('%j', time.strptime(date_str, '%Y%m%d')))
    key = f'sign:user:{user_id}:2026'
    r.setbit(key, day_of_year, 1)
    print(f"用户{user_id} {date_str} 签到成功")

def get_sign_count(user_id):
    """统计用户全年签到总天数"""
    key = f'sign:user:{user_id}:2026'
    total = r.bitcount(key)
    print(f"用户{user_id} 全年累计签到 {total} 天")
    return total

def check_signed(user_id, date_str='20260714'):
    """检查某天是否签到"""
    day_of_year = int(time.strftime('%j', time.strptime(date_str, '%Y%m%d')))
    key = f'sign:user:{user_id}:2026'
    signed = r.getbit(key, day_of_year)
    print(f"用户{user_id} {date_str} 是否签到: {bool(signed)}")
    return bool(signed)

# 测试
user_sign(1001)
user_sign(1001, '20260713')
check_signed(1001)
get_sign_count(1001)


# ==================================
# 场景4：商品销量排行榜
# 实现：ZSet 有序集合，score 为销量，自动排序
# ==================================
print("\n===== 场景4：销量排行榜 =====")

def incr_sales(goods_name, num=1):
    """商品销量增加"""
    r.zincrby('rank:sales', num, goods_name)
    print(f"商品 {goods_name} 销量 +{num}")

def get_top_n(n=5):
    """获取销量TopN"""
    top_list = r.zrevrange('rank:sales', 0, n-1, withscores=True)
    print(f"销量榜 Top{n}:")
    for idx, (goods, score) in enumerate(top_list, 1):
        print(f"  第{idx}名：{goods}，销量{int(score)}")

def get_goods_rank(goods_name):
    """查询单个商品排名"""
    rank = r.zrevrank('rank:sales', goods_name)
    if rank is not None:
        print(f"{goods_name} 排名第 {rank+1} 名")
    else:
        print(f"{goods_name} 未上榜")

# 测试
incr_sales('Python教程', 120)
incr_sales('Redis实战', 85)
incr_sales('MySQL优化', 210)
incr_sales('Linux运维', 96)
incr_sales('Go语言入门', 78)

get_top_n(3)
get_goods_rank('Redis实战')
EOF

# 运行业务场景示例
python3 02_business_scenarios.py


# --------------------------
# 三、大 key / 热 key 避坑实战
# 开发侧识别、优化、编码规范，从源头避免线上故障
# --------------------------
cat > 03_big_hot_key.py <<'EOF'
import redis

r = redis.Redis(host='127.0.0.1', port=6379, decode_responses=True)

# ==================================
# 1. 大 key 识别与拆分优化
# 大key标准：String > 10KB；集合类元素 > 1000个 或 总大小 > 1MB
# 危害：阻塞Redis、网络IO飙升、删除卡顿、内存碎片
# ==================================
print("===== 大 key 避坑实战 =====")

# ---------- 开发侧识别方法 ----------
# 1. 编码阶段：预估数据量，集合类提前规划拆分方案
# 2. 测试环境：用 redis-cli --bigkeys 扫描
# 3. 生产环境：低峰期用 RDB 文件离线分析（rdbtools）

# ---------- 常见大key优化方案 ----------

## 方案A：大 Hash 拆分
# 问题：单个hash存10万用户信息，变成超大key
# 优化：按用户ID取模，拆分为多个小hash
def big_hash_split(user_id, field, value):
    """大Hash分片：按用户ID后两位分100个小hash"""
    shard = user_id % 100
    key = f'user:big_info:shard_{shard}'
    r.hset(key, str(user_id), str(value))
    print(f"用户{user_id}写入分片 {shard}")

def get_big_hash(user_id, field):
    shard = user_id % 100
    key = f'user:big_info:shard_{shard}'
    return r.hget(key, str(user_id))

# 测试
for uid in range(1000):
    big_hash_split(uid, 'info', f'用户{uid}数据')


## 方案B：大 List 分页读取 + 截断
# 问题：lrange 0 -1 全量读取万级列表，直接阻塞Redis
# 优化：分批分页读取，只取需要的范围；定期裁剪旧数据
def get_list_page(key, page=1, page_size=20):
    """列表分页读取，禁止全量读取"""
    start = (page - 1) * page_size
    end = start + page_size - 1
    return r.lrange(key, start, end)

# ❌ 禁止：r.lrange('big_list', 0, -1)
# ✅ 正确：按页读取，控制单次返回量


## 方案C：大 Set/ZSet 分批遍历
# 问题：smembers / zrange 全量取出大集合
# 优化：用 sscan / zscan 游标分批遍历
def scan_big_set(key):
    """SSCAN 分批遍历大集合，不阻塞Redis"""
    cursor = 0
    while True:
        cursor, items = r.sscan(key, cursor, count=100)
        # 处理当前批次数据
        print(f"扫描到 {len(items)} 个元素")
        if cursor == 0:
            break

# ❌ 禁止：r.smembers('big_set')
# ✅ 正确：sscan 分批迭代


# ==================================
# 2. 热 key 识别与优化
# 热key：单个key每秒访问量上千，集中打在一个Redis节点
# 危害：节点CPU打满、网卡跑满、整体性能雪崩
# ==================================
print("\n===== 热 key 避坑实战 =====")

# ---------- 热key识别 ----------
# 1. 业务预判：秒杀商品、首页热点、活动入口
# 2. 监控发现：Redis热点key监控、客户端统计
# 3. 应急排查：redis-cli --hotkeys

# ---------- 优化方案 ----------

## 方案A：本地缓存二级加速
# 热点数据放应用本地内存，绝大部分请求不打到Redis
local_hot_cache = {}
HOT_KEY = 'hot:goods:1001'

def get_hot_goods(goods_id):
    """热点数据：先读本地缓存，未命中再读Redis"""
    if goods_id in local_hot_cache:
        print("[本地缓存命中热点]")
        return local_hot_cache[goods_id]

    data = r.get(f'goods:{goods_id}')
    if data:
        local_hot_cache[goods_id] = data  # 写入本地缓存
        print("[Redis读取，同步本地缓存]")
    return data


## 方案B：热 key 副本打散
# 原理：将一个热key复制N份，分布在不同节点，分散压力
def get_hot_key_shard(goods_id):
    """随机取一个副本读取，分散请求压力"""
    import random
    shard = random.randint(0, 9)  # 10个副本
    key = f'hot:goods:{goods_id}:copy_{shard}'
    return r.get(key)

# 注意：更新时要同步更新所有副本，保证数据一致性
# 适用：读多写少的极端热点数据


# ==================================
# 3. 开发编码红线（必须遵守）
# ==================================
# ❌ 1. 禁止线上使用 keys / smembers / hgetall / lrange 0 -1 等全量遍历命令
# ❌ 2. 禁止把无界增长的数据塞到一个key里（比如全量用户列表存一个list）
# ❌ 3. 禁止大事务、大Lua脚本一次性操作海量key
# ❌ 4. 禁止把Redis当数据库用，所有数据必须设置过期时间
# ✅ 1. 集合类默认分批操作，控制单次返回数据量
# ✅ 2. 预估数据量大的场景，提前做分片拆分
# ✅ 3. 热点数据优先加本地缓存，降低Redis压力
# ✅ 4. 键名规范统一，按业务模块前缀命名，方便排查与管理
EOF

# 运行大key热key避坑示例
python3 03_big_hot_key.py


# --------------------------
# 核心速记
# --------------------------
# 1. 三大问题解法：
#    穿透 → 空值缓存 + 布隆过滤器
#    击穿 → 互斥锁 + 热点永不过期
#    雪崩 → 随机过期打散 + 本地二级缓存兜底
# 2. 业务场景：
#    限流用计数器、幂等用唯一token、签到用Bitmap、排行用ZSet
# 3. 大key热key：
#    大key拆分分片、分批遍历；热key本地缓存、副本打散
#    核心原则：禁止全量操作，预估数据量，提前做拆分设计
```

#### 高级数据结构、Lua 脚本、集群模式注意事项

```md
# ==================================================
# Redis 开发第三优先级 从零实战（Python版）
# 完整覆盖：1. 三大高级数据结构
#           2. Lua 脚本原子化编程
#           3. 集群模式开发侧避坑指南
# ==================================================

pip3 install redis

# --------------------------
# 一、高级数据结构实战
# 解决特定业务场景，比基础结构更省内存、更高效
# --------------------------
cat > 01_advanced_types.py <<'EOF'
import redis
r = redis.Redis(host='127.0.0.1', port=6379, decode_responses=True)

# ==================================
# 1. Bitmap 位图（进阶用法）
# 本质：String 类型的位操作，1bit 存储一个状态
# 优势：极度省内存，1亿用户日活仅需12MB左右
# 适用：日活/月活统计、连续签到、用户留存、海量数据去重
# ==================================
print("===== 1. Bitmap 进阶实战 =====")

# ---------- 场景1：每日用户日活统计 ----------
# 设计：key = 日期，offset = 用户ID，1=活跃 0=未活跃
def user_active(day_str, user_id):
    """记录用户当日活跃"""
    key = f'dau:{day_str}'
    r.setbit(key, user_id, 1)

def get_dau(day_str):
    """统计当日活跃用户数"""
    key = f'dau:{day_str}'
    count = r.bitcount(key)
    print(f"{day_str} 日活用户数：{count}")
    return count

# 模拟数据：7月14日 100/200/300号用户活跃
for uid in [100, 200, 300, 400, 500]:
    user_active('20260714', uid)
# 7月15日 200/300/600号用户活跃
for uid in [200, 300, 600]:
    user_active('20260715', uid)

get_dau('20260714')
get_dau('20260715')

# ---------- 场景2：次日留存统计（两天都活跃的用户） ----------
def get_retention(day1, day2):
    """计算两天都活跃的留存用户数"""
    dest_key = f'retention:{day1}_{day2}'
    # 位与运算：两天对应位都为1才保留
    r.bitop('AND', dest_key, f'dau:{day1}', f'dau:{day2}')
    retention_count = r.bitcount(dest_key)
    print(f"{day1} 到 {day2} 次日留存用户数：{retention_count}")
    return retention_count

get_retention('20260714', '20260715')

# 避坑：用户ID必须是整数，且不能过大；超大ID会导致内存浪费
# 扩展：支持 OR（并集）、XOR（差集）、NOT（非集）运算


# ==================================
# 2. HyperLogLog 基数统计
# 本质：概率算法，极小内存统计海量去重数据
# 优势：12KB 内存可统计数十亿级基数，空间复杂度极低
# 误差：标准误差 0.81% 左右，适合不需要绝对精准的海量统计
# 适用：页面UV、独立访客、搜索关键词去重
# ==================================
print("\n===== 2. HyperLogLog 实战 =====")

# ---------- 场景：页面独立访客UV统计 ----------
def add_uv(page_id, user_id):
    """记录页面访问用户"""
    key = f'uv:page:{page_id}'
    r.pfadd(key, user_id)

def get_uv(page_id):
    """获取页面去重访问人数"""
    key = f'uv:page:{page_id}'
    uv = r.pfcount(key)
    print(f"页面 {page_id} 独立访客数：{uv}（近似值）")
    return uv

# 模拟1000个用户访问首页，其中有重复
for i in range(1000):
    add_uv('home', f'user_{i % 800}')  # 实际800个独立用户

get_uv('home')

# 合并多个页面的UV，统计全站UV
def merge_total_uv(page_list):
    dest_key = 'uv:total:site'
    keys = [f'uv:page:{p}' for p in page_list]
    r.pfmerge(dest_key, *keys)
    total = r.pfcount(dest_key)
    print(f"全站总独立访客数：{total}")
    return total

# 避坑：只适合统计总数，无法取出具体的用户列表
# 适合：亿级流量、允许微小误差的统计场景；精确去重请用 Set


# ==================================
# 3. Geo 地理空间
# 本质：底层基于 ZSet，将经纬度编码为52位Geohash
# 适用：附近的人、商家距离排序、位置范围查找
# ==================================
print("\n===== 3. Geo 实战 =====")

# ---------- 场景：附近商家查询 ----------
# 添加商家位置（名称, 经度, 纬度）
shops = [
    ('shop_001', 116.397, 39.908),  # 北京天安门
    ('shop_002', 116.410, 39.909),
    ('shop_003', 116.380, 39.915),
    ('shop_004', 116.405, 39.890),
]

for name, lon, lat in shops:
    r.geoadd('geo:shops', (lon, lat, name))

# 计算两个商家之间的距离（单位：千米）
distance = r.geodist('geo:shops', 'shop_001', 'shop_002', unit='km')
print(f"shop_001 到 shop_002 距离：{float(distance):.2f} km")

# 查询指定坐标 2公里内的商家，按距离由近到远排序
near_shops = r.georadius(
    'geo:shops',
    longitude=116.397, latitude=39.908,
    radius=2, unit='km',
    withdist=True, sort='ASC', count=5
)
print("2公里内的商家（由近到远）：")
for shop, dist in near_shops:
    print(f"  {shop}，距离 {float(dist):.2f} km")

# 避坑：坐标范围有限制，不能超出经纬度合法范围
# 注意：Geo 无法直接删除元素，底层是ZSet，用 zrem 删除
EOF

python3 01_advanced_types.py


# --------------------------
# 二、Lua 脚本原子化编程
# 核心价值：将多条命令打包成一个原子操作，解决并发竞态问题
# 同时减少网络往返，提升批量操作性能
# --------------------------
cat > 02_lua_script.py <<'EOF'
import redis
r = redis.Redis(host='127.0.0.1', port=6379, decode_responses=True)

# ==================================
# Lua 脚本核心原理
# 1. Redis 单线程执行 Lua 脚本，全程原子，不会被其他命令打断
# 2. 所有 key 必须通过 KEYS 数组传入，ARGV 传参数
# 3. 集群模式下，所有 key 必须落在同一个哈希槽
# ==================================
print("===== Lua 脚本原子化实战 =====")

# ---------- 场景1：原子扣减库存（带库存校验） ----------
# 普通 decr 会扣成负数；用 Lua 实现：库存>0才扣减，否则返回0
# 解决：并发场景下「判断库存 + 扣减」非原子导致的超卖问题
stock_deduct_lua = """
-- KEYS[1] = 库存key
-- ARGV[1] = 扣减数量
local stock = tonumber(redis.call('get', KEYS[1]) or 0)
local num = tonumber(ARGV[1])
if stock >= num then
    redis.call('decrby', KEYS[1], num)
    return stock - num  -- 返回扣减后剩余库存
else
    return -1  -- 库存不足，扣减失败
end
"""

# 注册脚本，生成脚本哈希，后续可复用
stock_script = r.register_script(stock_deduct_lua)

# 初始化库存
r.set('goods:stock:100', 10)

# 执行原子扣减
def deduct_stock(goods_id, num=1):
    key = f'goods:stock:{goods_id}'
    result = stock_script(keys=[key], args=[num])
    if result >= 0:
        print(f"扣减成功，剩余库存：{result}")
    else:
        print("扣减失败，库存不足")
    return result

# 测试：连续扣减12次
for i in range(12):
    deduct_stock(100)


# ---------- 场景2：原子释放分布式锁 ----------
# 解决：get + del 两步非原子，可能误删别人的锁
unlock_lua = """
-- KEYS[1] = 锁key
-- ARGV[1] = 锁的唯一标识（只有持有者才能释放）
if redis.call('get', KEYS[1]) == ARGV[1] then
    return redis.call('del', KEYS[1])
else
    return 0
end
"""
unlock_script = r.register_script(unlock_lua)

# 使用示例
lock_key = 'lock:order:1001'
lock_value = 'unique_request_id_123'
# 加锁
r.set(lock_key, lock_value, nx=True, ex=10)
# 原子释放
result = unlock_script(keys=[lock_key], args=[lock_value])
print(f"\n锁释放结果：{bool(result)}")


# ---------- 场景3：批量复合操作，减少网络往返 ----------
# 比如：同时写入用户信息 + 更新积分 + 记录操作日志，一次网络请求完成
batch_update_lua = """
local user_key = KEYS[1]
local score_key = KEYS[2]
local user_info = ARGV[1]
local add_score = ARGV[2]

redis.call('set', user_key, user_info)
redis.call('incrby', score_key, add_score)
return 1
"""
batch_script = r.register_script(batch_update_lua)

# 执行一次调用完成两个操作
ret = batch_script(
    keys=['user:info:2001', 'user:score:2001'],
    args=['用户2001信息', 10]
)
print(f"\n批量原子操作执行结果：{bool(ret)}")


# ==================================
# Lua 脚本开发红线（必须遵守）
# ==================================
# ❌ 1. 禁止在 Lua 中写复杂循环、耗时逻辑，会长期阻塞 Redis
# ❌ 2. 禁止集群模式下操作多个不同槽的 key，会报错
# ❌ 3. 禁止使用随机函数（time、random），导致主从数据不一致
# ❌ 4. 脚本体积不要过大，避免网络传输与解析开销
# ✅ 1. 所有 key 放 KEYS，参数放 ARGV，符合 Redis 规范
# ✅ 2. 短小精悍，只做原子逻辑，复杂计算放业务代码
# ✅ 3. 生产复用脚本哈希（evalsha），减少网络传输
EOF

python3 02_lua_script.py


# --------------------------
# 三、集群模式开发侧避坑指南
# 注意：不需要掌握集群部署，但必须知道写代码时的限制与坑
# --------------------------
cat > 03_cluster_notes.py <<'EOF'
# ==================================================
# Redis Cluster 开发核心认知
# 1. 全集群 16384 个哈希槽（Hash Slot），每个节点负责一部分槽
# 2. 每个 key 通过 CRC16(key) mod 16384 计算所属槽位
# 3. 客户端只连任意一个节点，非自身槽的请求会返回 MOVED 重定向
# 4. 单分片内支持所有命令；跨分片操作有大量限制
# ==================================================

print("===== 集群模式开发避坑指南 =====")

# ==================================
# 坑1：批量操作跨槽位直接报错
# 受影响命令：MGET / MSET / DEL 多个key、事务、Lua脚本
# ==================================
print("\n1. 跨槽批量操作问题")
# ❌ 错误示例：不同前缀的 key 大概率不在同一个槽，集群下 MGET 报错
# r.mget('user:1001', 'order:2001')  → 报错 CROSSSLOT

# ✅ 解决方案A：Hash Tag 强制同槽
# 规则：用 {} 包裹 key 的一部分，只计算 {} 内的字符串的哈希槽
# 只要 {} 内内容相同，key 就会落在同一个槽位
# 示例：
# user:{1001}:info    ← 都按 1001 计算槽，同槽
# user:{1001}:order
# user:{1001}:score
# 这样三个 key 可以安全使用 MGET/MSET 等批量命令

# ✅ 解决方案B：客户端侧拆分，按槽分组后分批请求
# 比如 mget 100个key，按槽位拆成5批，分别请求对应节点

# 开发规范：
# - 同一业务、需要批量操作的 key，提前设计 Hash Tag
# - 禁止无差别对大量随机 key 做批量操作


# ==================================
# 坑2：事务 / Lua 脚本跨槽失效
# ==================================
print("\n2. 事务与Lua限制")
# Redis 事务（MULTI/EXEC）和 Lua 脚本，都要求所有操作的 key 在同一个槽
# ❌ 跨槽事务 / 跨槽 Lua 直接报错
# ✅ 解决方案：用 Hash Tag 保证所有 key 同槽


# ==================================
# 坑3：全量遍历命令不返回全集群数据
# 受影响：KEYS、SCAN、FLUSHALL
# ==================================
print("\n3. 全量遍历限制")
# ❌ 单节点执行 keys *，只能扫到当前节点的 key，不是全集群
# ❌ 单节点 scan，也只能遍历当前分片
# ✅ 正确做法：
# - 遍历所有节点，分别执行 scan，再合并结果
# - 生产永远禁止用 keys *，无论单机还是集群


# ==================================
# 坑4：热点 key 无法通过集群分散压力
# ==================================
print("\n4. 热点key问题")
# 集群是按 key 分片扩容，单个热点 key 永远落在一个节点上
# 无法通过加节点分散这个 key 的压力，和单机一样会打满单节点
# ✅ 解决方案：
# - 本地内存缓存兜底（二级缓存）
# - 热 key 复制多份副本（hot_key_1 ~ hot_key_N），分散到不同槽
# - 读请求随机访问副本，分散压力


# ==================================
# 坑5：数据库与缓存双写一致性更复杂
# ==================================
print("\n5. 一致性注意")
# 集群扩容、节点故障切换时，可能出现短暂的数据不一致
# 业务侧不要强依赖 Redis 的强一致性
# 核心原则：Redis 是缓存，最终以数据库为准，所有缓存都要设置过期时间


# ==================================
# 集群模式开发最佳实践
# ==================================
# 1. key 设计阶段就考虑 Hash Tag，同业务聚合 key 用相同 tag
# 2. 批量操作优先按槽位拆分，或用 Hash Tag 保证同槽
# 3. 禁止全集群 keys、flush 等高危操作
# 4. 热点 key 提前做本地缓存 + 副本打散，不要依赖集群扩容解决
# 5. Lua / 事务严格控制在单槽范围内
# 6. 客户端使用支持集群重定向的 SDK（redis-py 集群模式）
EOF

python3 03_cluster_notes.py


# --------------------------
# 核心速记
# --------------------------
# 1. 高级结构：
#    Bitmap 存状态省内存，适合日活签到；HyperLogLog做海量基数统计，有误差；Geo做LBS位置查询
# 2. Lua 脚本：
#    解决并发原子问题，短小精悍，KEYS传键ARGV传参，集群保证同槽
# 3. 集群避坑：
#    跨槽批量会报错，Hash Tag来解决；热点key集群没用，本地缓存加副本
```

---

# 三、消息队列 + 存储服务（互联网企业必备）

## 1. 消息队列运维

### RabbitMQ

- 集群部署、节点角色
- 交换机类型：直连 / 主题 / 扇形 / 头部
- 队列持久化、消息持久化
- 用户权限、vhost 隔离
- **消息积压、消息丢失、重复消费排障**

```md
# 
# ==================================================
# RabbitMQ 生产运维全栈手册
# 1. 集群部署与节点角色 | 2. 四大交换机类型
# 3. 队列+消息持久化 | 4. vhost隔离与用户权限
# 5. 核心故障排障：消息积压 / 消息丢失 / 重复消费
# ==================================================

# --------------------------
# 一、集群部署与节点角色
# 核心作用：单节点性能/容量不足时横向扩容，多节点实现高可用
# 节点角色分类：
# 1. 磁盘节点（disc）：元数据（队列、交换机、绑定关系）持久化到磁盘
#    集群至少保留1个磁盘节点，防止全集群重启后元数据丢失
# 2. 内存节点（ram）：元数据仅存内存，读写性能高
#    用于高并发接入场景，重启后元数据从磁盘节点同步恢复
# 集群模式：普通集群（队列仅存单个节点）、镜像队列（队列同步多节点，高可用）
# --------------------------

## 1. 前置环境（所有节点执行）
# 安装依赖与服务
yum install -y erlang rabbitmq-server
# 开启Web管理控制台（端口15672）
rabbitmq-plugins enable rabbitmq_management
systemctl start rabbitmq-server
systemctl enable rabbitmq-server

## 2. 集群身份同步：Erlang Cookie（节点间认证凭证，全集群必须一致）
# 复制主节点Cookie到所有从节点，保证权限一致
# scp /var/lib/rabbitmq/.erlang.cookie root@从节点IP:/var/lib/rabbitmq/
# chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
# chmod 400 /var/lib/rabbitmq/.erlang.cookie
# systemctl restart rabbitmq-server

## 3. 从节点加入集群（在从节点本地执行）
rabbitmqctl stop_app
# 默认加入为磁盘节点；加 --ram 参数则为内存节点
rabbitmqctl join_cluster rabbit@主节点主机名
rabbitmqctl start_app

## 4. 集群状态校验
rabbitmqctl cluster_status
# 核心输出：所有节点列表、节点类型、运行状态、分区状态

## 5. 节点类型切换
rabbitmqctl change_cluster_node_type ram   # 改为内存节点
rabbitmqctl change_cluster_node_type disc  # 改为磁盘节点

## 6. 生产高可用标配：镜像队列策略
# 队列数据自动同步到集群多节点，单节点宕机不丢失队列数据
rabbitmqctl set_policy ha-all "^" '{"ha-mode":"all"}'
# 参数说明：
# ha-all：策略名称
# "^"：正则匹配所有队列；可指定前缀匹配特定业务队列
# ha-mode:all → 同步到集群所有节点；exactly → 指定副本数；nodes → 指定节点列表

# --------------------------
# 二、四大交换机类型（Exchange）
# 作用：接收生产者消息，根据路由规则转发到绑定的队列
# --------------------------

## 1. 直连交换机 Direct
# 路由规则：消息的 routing_key 与队列绑定的 binding_key 完全相等才转发
# 适用场景：点对点精准投递，如订单状态通知、短信验证码
rabbitmqadmin declare exchange name=direct_order type=direct durable=true

## 2. 主题交换机 Topic
# 路由规则：routing_key 支持通配符，用 . 分隔单词
# * 匹配1个单词；# 匹配0个或多个单词
# 适用场景：多维度分类投递，如日志分级、消息订阅、新闻分类推送
rabbitmqadmin declare exchange name=topic_log type=topic durable=true
# 绑定示例：log.info.* 匹配 log.info.order / log.info.pay
# 绑定示例：log.#     匹配 log.error / log.warn.db.user

## 3. 扇形交换机 Fanout
# 路由规则：忽略 routing_key，将消息广播到所有绑定的队列
# 适用场景：全局广播通知，如配置刷新、系统公告、活动群发
# 特点：无路由匹配开销，转发速度最快
rabbitmqadmin declare exchange name=fanout_notice type=fanout durable=true

## 4. 头部交换机 Headers
# 路由规则：根据消息的 headers 属性匹配，完全不依赖 routing_key
# 适用场景：复杂多条件路由的特殊业务，性能差，生产极少使用
rabbitmqadmin declare exchange name=headers_custom type=headers durable=true

# 常用查询命令
rabbitmqctl list_exchanges   # 查看所有交换机
rabbitmqctl list_bindings    # 查看所有交换机与队列的绑定关系

# --------------------------
# 三、持久化机制（宕机数据不丢失的核心）
# 完整持久化三要素：交换机持久化 + 队列持久化 + 消息持久化，三者缺一不可
# --------------------------

## 1. 交换机持久化
# 声明时指定 durable=true，服务重启后交换机配置保留，不会消失
# 上面创建交换机已开启 durable=true，生产所有业务交换机必须开启

## 2. 队列持久化
# 声明队列时指定 durable=true，服务重启后队列实体依然存在
rabbitmqadmin declare queue name=order_queue durable=true
# 注意：队列创建后持久化属性不可修改，必须删除重建
# 仅队列持久化，消息不持久化 → 重启后队列存在，消息全部丢失

## 3. 消息持久化
# 生产者发送消息时指定 delivery_mode = 2（持久化标识）
# 消息会异步写入磁盘，服务宕机重启后可恢复未消费的消息
# 注意：
# ✅ 持久化会降低写入吞吐量，非核心消息可根据业务权衡
# ✅ 极端宕机场景（刷盘前断电）仍可能丢失毫秒级数据，需100%可靠要开生产者确认

## 4. 持久化校验
rabbitmqctl list_queues name durable

# --------------------------
# 四、vhost 隔离与用户权限体系
# vhost = 虚拟主机，类似MySQL的库，实现多业务逻辑隔离
# 每个vhost拥有独立的交换机、队列、权限体系，业务之间完全不互通
# --------------------------

## 1. vhost 生命周期管理
# 按业务线创建独立vhost，实现资源与权限隔离
rabbitmqctl add_vhost /order_vhost
rabbitmqctl add_vhost /pay_vhost

# 查看所有vhost
rabbitmqctl list_vhosts

# 删除废弃vhost
# rabbitmqctl delete_vhost /test_vhost

## 2. 用户创建与最小权限授权
# 创建业务账号
rabbitmqctl add_user biz_order Order@Prod_2026
# 设置用户角色：none/management/policymaker/monitoring/administrator
# 普通业务账号设为 none，仅用于收发消息，无管理权限
rabbitmqctl set_user_tags biz_order none

# 授权vhost权限，格式：set_permissions -p vhost名 用户名 配置权限 写权限 读权限
# 权限说明：
# configure：创建/删除队列、交换机等资源
# write：发送消息
# read：消费消息
# 生产规范：业务账号最小权限，不授予configure权限
rabbitmqctl set_permissions -p /order_vhost biz_order "" ".*" ".*"

## 3. 权限查询与回收
# 查看指定用户所有权限
rabbitmqctl list_user_permissions biz_order
# 查看指定vhost下所有授权
rabbitmqctl list_permissions -p /order_vhost

# 回收权限
# rabbitmqctl clear_permissions -p /order_vhost biz_order

## 4. 生产安全硬性规范
# 1. 删除默认高危guest账号，禁止弱密码
rabbitmqctl delete_user guest
# 2. 不同业务使用独立vhost+独立账号，互不干扰
# 3. 管理端口15672仅内网开放，防火墙限制访问来源
# 4. 生产账号禁止administrator角色，单独创建运维管理员账号

# --------------------------
# 五、核心故障排障
# 覆盖：消息积压、消息丢失、重复消费
# --------------------------

## ==================================
## 故障1：消息积压（队列消息堆积，消费速度跟不上生产速度）
## 现象：业务处理延迟，队列消息数持续增长，告警触发
## ==================================
### 排查命令
# 全队列积压概览
rabbitmqctl list_queues name messages consumers
# 细分状态：待消费数 / 已投递未确认数
rabbitmqctl list_queues name messages_ready messages_unacknowledged consumers
# messages_ready：待消费积压量，核心告警指标
# messages_unacknowledged：已发给消费者但未ack的消息数

### 常见根因
# 1. 消费者服务宕机/异常，完全停止消费
# 2. 消费逻辑慢（数据库慢查询、外部接口超时），单条消息处理耗时久
# 3. 突发大流量，生产端消息量瞬时翻倍
# 4. 消费者线程数配置过少，消费能力不足

### 应急与优化
# 1. 快速扩容：增加消费者实例/消费线程数，最直接提升消费能力
# 2. 业务降级：非核心消息临时丢弃或转存，优先保障核心消息消费
# 3. 逻辑优化：优化消费端慢查询、减少外部调用，缩短单条处理时长
# 4. 死信兜底：配置死信队列，超过时长/次数的消息转入死信，避免阻塞主队列
# 5. 生产限流：入口侧限制生产速率，避免消息持续涌入扩大积压

## ==================================
## 故障2：消息丢失（发送成功但消费端未收到，重启后消息消失）
## ==================================
### 三类丢失场景与根因
# 场景1：生产端丢失 → 消息未成功到达RabbitMQ
# 原因：网络抖动、交换机无对应队列绑定，消息被静默丢弃
# 场景2：服务端丢失 → 未做持久化，服务宕机重启后消息/队列消失
# 场景3：消费端丢失 → 自动ack模式，消息刚投递就确认，业务处理失败消息不重发

### 完整解决方案
# 1. 生产端：开启生产者确认机制（Publisher Confirms）
#    消息成功写入队列后，MQ返回ack；失败返回nack，生产者重试
#    配合 mandatory 参数，无法路由的消息返回给生产者，不静默丢弃
#
# 2. 服务端：三要素全量持久化 + 镜像队列
#    交换机+队列+消息全部开启持久化；镜像队列多副本，单节点宕机不丢
#
# 3. 消费端：关闭自动ack，改为手动ack
#    业务逻辑全部处理完成后，再手动发送ack；处理失败则nack，消息重新入队
#
# 4. 兜底：死信交换机，无法路由、过期、被拒绝的消息转入死信队列，可追溯可恢复

## ==================================
## 故障3：重复消费（同一条消息被消费多次）
## ==================================
### 核心根因
# RabbitMQ 默认 At Least Once 保证，消息至少投递一次，无法100%避免重复
# 触发场景：
# 1. 消费者处理完未发送ack就宕机，消息重新入队再次投递
# 2. ack网络超时，MQ未收到确认，触发重发
# 3. 消费者手动nack，消息重新入队再次消费

### 排查与根治
# 排查：通过消息唯一ID对比消费日志，确认重复次数与触发时间
# 根治方案：**业务侧实现幂等性**，是唯一彻底解决重复消费的方案
# 常用幂等实现：
# 1. 唯一ID去重：消息带全局唯一ID，消费前查去重表，已处理则直接跳过
# 2. 数据库唯一键：利用主键/唯一索引约束，重复插入直接报错，不产生脏数据
# 3. 乐观锁：更新操作带版本号校验，版本不匹配则不执行
#
# MQ侧优化：
# 优化消费速度，减少超时重发概率；合理设置ack超时时间

# --------------------------
# 核心速记
# --------------------------
# 1. 集群：磁盘节点存元数据，内存节点提性能；镜像队列实现节点级高可用
# 2. 交换机：直连精准匹配、主题通配符、扇形广播、头部极少用
# 3. 持久化：交换机+队列+消息三要素全开，才会真正落盘
# 4. 权限：vhost做业务隔离，账号最小权限，删除默认guest
# 5. 故障三板斧：
#    积压 → 加消费者、优化消费逻辑
#    丢失 → 持久化+生产者确认+手动ack
#    重复 → 业务幂等是唯一根治方案
```

### 从零学 RabbitMQ

```md
# ==============================
# RabbitMQ 从零完整学习手册
# 1. 安装目录结构详解
# 2. 服务启停/状态命令大全
# 3. 虚拟主机vhost、用户、权限管理命令
# 4. 交换机、队列、绑定管理命令
# 5. 消息发布、消费、死信、监控运维命令
# 6. 集群管理、备份恢复命令
# 7. 开发核心概念+Python配套提示
# ==============================

# 安装依赖与服务
yum install -y erlang rabbitmq-server
# 一、开启Web管理插件命令
rabbitmq-plugins enable rabbitmq\_management
# 插件开启后无需重启RabbitMQ，直接访问
# 访问地址：http://服务器IP:15672
# 管理端口：15672；消息通信端口：5672

systemctl start rabbitmq-server
systemctl enable rabbitmq-server

# ==============================
# 二、默认账号密码 + 关键限制（必考踩坑点）
# ==============================
# 默认用户名：guest
# 默认密码：guest
# 强制安全限制（RabbitMQ 3.3.0及所有新版）：
# guest 仅允许 127.0.0.1 / localhost 本地登录，\*\*公网/远程IP访问直接401拒绝登录\*\*

## 解决方案1（生产推荐：新建管理员账号，永久解决远程访问）
# 1. 创建管理员用户 admin，密码自定义
rabbitmqctl add_user admin Admin@Rabbit2026
# 2. 赋予超级管理员角色 administrator
rabbitmqctl set_user_tags admin administrator
# 3. 给账号授予根vhost全部读写配置权限
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
# 4. 安全操作：删除默认高危guest账号（生产必须执行）
rabbitmqctl delete_user guest


# 一、RabbitMQ 安装后标准目录结构（CentOS yum安装）
# 1. 程序二进制文件
/usr/sbin/rabbitmq-server       # 主服务启动程序
/usr/sbin/rabbitmqctl          # 核心运维命令行工具（最常用）
/usr/sbin/rabbitmq-plugins      # 插件管理（开启web管理界面）
/usr/sbin/rabbitmq-diagnostics  # 诊断、监控工具
/usr/sbin/rabbitmq-env          # 环境变量脚本

# 2. 配置文件目录
/etc/rabbitmq/
    rabbitmq.conf               # 主配置文件（端口、内存、磁盘限制、持久化）
    advanced.config             # 高级Erlang语法配置（集群、镜像队列）
    enabled_plugins             # 已开启插件记录

# 3. 数据持久化目录（队列、消息、元数据、镜像副本）
/var/lib/rabbitmq/mnesia/
    # 存储交换机、队列、vhost、消息、用户权限、集群节点元数据

# 4. 日志目录
/var/log/rabbitmq/
    rabbit@主机名.log           # 服务运行日志、报错、连接日志
    rabbit@主机名-sasl.log      # Erlang底层安全、崩溃日志

# 5. 节点身份文件（集群同步关键）
/var/lib/rabbitmq/.erlang.cookie
# 集群所有节点cookie必须完全一致，否则节点无法互通

# 6. Web管理控制台访问地址
# http://服务器IP:15672  账号密码自行创建

# ==============================================
# 二、服务启停、基础状态命令
# ==============================================
# 1. 系统服务管理（systemd）
systemctl start rabbitmq-server     # 启动服务
systemctl stop rabbitmq-server      # 停止服务
systemctl restart rabbitmq-server   # 重启
systemctl enable rabbitmq-server     # 开机自启
systemctl disable rabbitmq-server    # 取消自启
systemctl status rabbitmq-server    # 查看运行状态

# 2. 前台启动（调试用，关闭终端即停止）
rabbitmq-server

# 3. 后台守护进程启动
rabbitmq-server -detached

# 4. 关闭节点（优雅停机，等待消费完成）
rabbitmqctl stop
# 快速强制关闭
rabbitmqctl stop_app

# 5. 查看节点运行状态
rabbitmqctl status
# 简易健康检查
rabbitmqctl ping

# 6. 开启Web管理插件（必须执行才能访问15672后台）
rabbitmq-plugins enable rabbitmq_management
# 查看已启用插件
rabbitmq-plugins list


# 一、RabbitMQ 整体架构组成
# ==============================
# 1. 客户端（Producer生产者 / Consumer消费者）
#    业务程序，Python/Java/Go，通过5672端口AMQP协议收发消息
#    生产者：发送消息；消费者：监听队列处理消息

# 2. Broker 服务节点（RabbitMQ 服务本体）
#    一台服务器启动一个 rabbitmq-server 进程就是一个Broker节点
#    内部由Erlang虚拟机运行，单线程处理消息读写

# 3. 虚拟主机 Vhost
#    逻辑隔离单元，类似MySQL数据库，每个vhost独立交换机、队列、权限
#    多业务共用MQ时拆分vhost，业务互不干扰

# 4. Exchange 交换机（路由层）
#    接收生产者消息，根据路由规则分发到绑定的队列
#    四种类型：Direct / Topic / Fanout / Headers

# 5. Binding 绑定关系
#    交换机 ↔ 队列之间的桥梁，携带routing_key路由规则

# 6. Queue 队列（消息存储层）
#    真正存放消息的容器，消费者只从队列拉取消息
#    支持持久化、死信、长度限制、消息TTL

# 7. Message 消息本体
#    消息头属性（routing_key、delivery_mode、message-id）+ 消息体业务数据

# 8. Web管理插件 rabbitmq_management
#    内置HTTP API，15672端口，提供页面、rabbitmqadmin命令操作资源

# 9. Erlang Cookie（集群组件）
#    集群节点间身份凭证，所有节点cookie必须一致才能组成集群

# 10. 持久化存储目录 mnesia
#    存放元数据（交换机/队列/用户）+ 持久化消息

# ==============================
# 二、完整工作流转原理（标准Direct点对点流程）
# ==============================
# 步骤1：生产者建立TCP连接，创建Channel通道（复用连接，节省开销）
# 步骤2：生产者声明交换机（不存在则创建，durable持久化）
# 步骤3：生产者发送消息，携带 exchange名称 + routing_key + 消息持久化标识
# 步骤4：Broker接收消息，交给对应交换机
# 步骤5：交换机根据自身类型 + binding绑定的routing_key匹配目标队列
# 步骤6：匹配成功，消息存入对应Queue；无匹配队列则丢弃/返回生产者（mandatory参数）
# 步骤7：消费者建立连接、声明队列、绑定交换机，开始监听队列
# 步骤8：Broker将队列消息推送给消费者（或消费者主动拉取）
# 步骤9：消费者执行业务逻辑，处理完成后发送手动ACK确认
# 步骤10：Broker收到ACK，永久删除该条消息；处理异常发送NACK，消息重新入队

生产者 → TCP 连接 / Channel → Exchange 交换机 (路由分发) → Binding 规则 → Queue 队列 (存消息) → 消费者 ACK 确认 → MQ 删除消息

# 扩展广播流程（Fanout）：
# 消息到达Fanout交换机，忽略routing_key，复制消息分发给所有绑定队列

# ==============================
# 三、全部核心概念精讲
# ==============================
# 1. Producer 生产者
# 发送消息的应用，只对接交换机，不感知队列存在

# 2. Consumer 消费者
# 监听队列、消费处理消息的应用，只从队列拿数据

# 3. Connection 连接
# TCP长连接，客户端与Broker之间的底层连接，创建成本高，尽量复用

# 4. Channel 通道（高频重点）
# 一个TCP连接内可创建上千个独立Channel，轻量级，绝大多数业务操作在Channel完成
# 作用：多线程共用一条TCP连接，避免频繁创建销毁TCP

# 5. Vhost 虚拟主机
# 隔离资源与权限，不同业务分配独立vhost，账号权限仅作用于指定vhost

# 6. Exchange 交换机 4种类型
# Direct：精准匹配routing_key，一对一投递（订单、短信）
# Topic：通配符模糊匹配，日志、多标签订阅
# Fanout：广播，无视路由键，发给全部绑定队列（配置通知）
# Headers：根据消息头部键值匹配，极少使用

# 7. Routing Key 路由键
# 生产者发送消息携带的标签，交换机依靠它匹配绑定规则

# 8. Binding 绑定
# 交换机和队列的关联关系，绑定的时候指定binding_key（匹配规则）

# 9. Queue 队列
# 消息存储载体，先进先出；支持：
# durable：队列元数据持久化
# exclusive：仅当前连接可用，连接断开自动删除
# auto_delete：无消费者时自动删除队列

# 10. Message 消息属性
# delivery_mode=1 临时消息，重启丢失
# delivery_mode=2 持久消息，落盘保存
# message-id：全局唯一ID，用于消费幂等
# expiration：消息过期时间TTL

# 11. ACK 消息确认机制（可靠性核心）
# auto_ack=true 自动确认：消息推给消费者立刻删除，易丢消息，生产禁用
# auto_ack=false 手动确认：业务处理成功 ch.ack；失败 ch.nack 重新入队

# 12. Qos 预取计数 prefetch_count
# 限制单次推送给消费者的未确认消息数量，防止消费者内存打爆

# 13. DLX 死信交换机 / DLQ 死信队列
# 消息三种情况转入死信：过期TTL、消费者拒绝且不重入、队列达到最大长度
# 用于兜底失败消息，避免无限重试堵塞主队列

# 14. 持久化三要素（防止宕机丢消息）
# 1. 交换机 durable=true
# 2. 队列 durable=true
# 3. 消息 delivery_mode=2
# 三者同时开启，重启MQ消息不丢失

# 15. 集群 & 镜像队列
# 普通集群：队列仅存在单个节点，节点宕机队列丢失
# 镜像队列：队列副本同步到集群多节点，高可用，单节点故障不丢数据

# 16. 消息三种异常问题底层原理
# 消息丢失：未持久化、自动ACK、无绑定队列直接丢弃
# 消息重复消费：消费完未发送ACK程序崩溃，消息重发（解决方案：业务幂等）
# 消息堆积：消费者离线/消费速度慢、单条消息处理耗时过长


RabbitMQ 官方标准5种消息模型，对应4种交换机实现
# 1. 简单模式 Simple（点对点）
# 2. 工作队列模式 Work Queue（多个消费者竞争消费）
# 3. 发布订阅 Publish/Subscribe（Fanout广播）
# 4. 路由模式 Routing（Direct精准过滤）
# 5. 主题模式 Topic（模糊通配符订阅）

# ==============================
# 模式1：Simple 简单模式（Direct交换机）
# 架构：1生产者 → 1队列 → 1消费者
# 适用：一对一单次通知，简单短信、验证码推送
# 流程：
# 生产者发消息到Direct交换机，绑定唯一队列，单个消费者监听队列
# 特点：
# 1. 一条消息只会被一个消费者处理
# 2. 无并发能力，仅适合单消费程序
# 缺陷：无法水平扩容，消费者挂掉消息堆积

# ==============================
# 模式2：Work Queue 工作队列（Direct交换机）
# 架构：1生产者 → 1队列 → N个消费者（竞争消费）
# 适用：任务削峰、耗时任务异步处理（邮件、文件解析）
# 核心机制：Qos prefetch_count
# 流程：
# 多个消费者监听同一个队列，MQ轮询分发消息，每条消息只分给一个空闲消费者
# 两种分发策略：
# 1. 默认轮询：不管消费者快慢，平均分配消息，慢消费者会堆积未处理消息
# 2. 公平分发（生产推荐）：设置prefetch_count=1，消费者处理完ACK才下发下一条
# 特点：水平扩容，多机器分担压力，秒杀、大量异步任务首选

# ==============================
# 模式3：Publish/Subscribe 发布订阅（Fanout扇形交换机）
# 架构：1生产者 → Fanout交换机 → N个独立队列（每个队列绑定一个消费者）
# 适用：全局广播通知、配置刷新、多服务同步更新
# 流程：
# Fanout忽略routing_key，消息复制多份，所有绑定该交换机的队列全部收到消息
# 特点：
# 1. 一条消息所有消费者都会完整接收
# 2. 完全解耦，新增业务只需新建队列绑定交换机，不用改生产者代码
# 案例：系统公告推送订单服务、库存服务、日志服务

# ==============================
# 模式4：Routing 路由模式（Direct直连交换机）
# 架构：生产者携带routing_key发送，队列绑定指定key，精准过滤消息
# 适用：日志分级、业务类型区分（支付消息、订单消息分开消费）
# 流程：
# 1. 队列绑定交换机时指定固定binding_key
# 2. 生产者消息携带routing_key，完全匹配才投递到对应队列
# 案例：
# key=error → 错误日志队列（告警推送）
# key=info → 普通日志队列（存储）
# 特点：精准一对一/一对多，只有匹配key的队列收到消息

# ==============================
# 模式5：Topic 主题模式（Topic主题交换机）
# 架构：基于 . 分割多级路由key，支持 * # 通配符模糊匹配
# 适用：复杂多维度日志、多标签业务消息订阅
# 通配符规则：
# * 匹配任意1个单词
# # 匹配0个或多个单词
# 示例：
# 消息rk：log.error.order
# 绑定1：log.error.*  → 匹配所有一级后缀error日志
# 绑定2：log.#       → 匹配全部日志
# 绑定3：#.order     → 匹配所有订单相关日志
# 特点：灵活模糊订阅，是Routing模式的升级版，业务最通用

# ==============================
# 补充区分速记
# Simple/Work：共用Direct，单队列，区别是消费者数量
# Publish/Subscribe：Fanout，全量广播，不区分key
# Routing：Direct，精准完整匹配key
# Topic：Topic，通配符模糊匹配key




# ==============================================
# 三、虚拟主机 vhost 管理（业务隔离核心）
# ==============================================
# 1. 创建虚拟主机
rabbitmqctl add_vhost /order_vhost
# 2. 删除废弃vhost
rabbitmqctl delete_vhost /test_vhost
# 3. 列出全部vhost
rabbitmqctl list_vhosts
# 4. 查看vhost详情（消息数、磁盘占用）
rabbitmqctl list_vhosts name tracing

# ==============================================
# 四、用户、角色、权限全套命令（安全必备）
# ==============================================
# 1. 创建用户 用户名 密码
rabbitmqctl add_user biz_order Order@2026
# 2. 修改用户密码
rabbitmqctl change_password biz_order NewPass@123
# 3. 删除用户
rabbitmqctl delete_user guest
# 4. 查看所有用户
rabbitmqctl list_users

# 5. 设置用户角色（权限分级）
# none：普通业务账号，仅收发消息（推荐业务使用）
# management：可登录web后台查看监控
# policymaker：可创建策略（镜像队列、死信规则）
# monitoring：完整监控权限
# administrator：超级管理员（所有权限）
rabbitmqctl set_user_tags biz_order none
rabbitmqctl set_user_tags admin administrator

# 6. 分配vhost权限 格式：set_permissions -p vhost 用户 配置权限 写权限 读权限
# 权限说明：
# configure：创建/删除队列、交换机
# write：发送消息
# read：消费消息
# 业务最小权限：无configure，仅读写
rabbitmqctl set_permissions -p vhost 用户名  配置权限 写权限 读权限
rabbitmqctl set_permissions [-p vhost] 用户名 配置正则 写正则 读正则
rabbitmqctl set_permissions -p /order_vhost biz_order "" ".*" ".*"
`""` 空字符串 = **完全没有配置权限**
`".*"` 正则匹配所有交换机，代表可以向本 vhost 内任意交换机发消息
`".*"` 匹配所有队列，代表可以消费本 vhost 任意队列消息


# 7. 查看用户权限
rabbitmqctl list_user_permissions biz_order
# 查看vhost下所有授权账号
rabbitmqctl list_permissions -p /order_vhost
# 回收权限
rabbitmqctl clear_permissions -p /order_vhost biz_order


# ==============================================
# 五、交换机 Exchange 管理命令（4种类型：direct/topic/fanout/headers）

# 交换机核心作用（一句话）
# 生产者不直接发给队列，消息先发给交换机；交换机根据规则路由分发消息到对应队列
# 核心定位：消息路由中转站，负责「消息分发逻辑」，没有交换机生产者无法投递消息到队列

# 完整流转流程
# 生产者(Python/业务代码) → 发送消息到 Exchange交换机 → 根据routing\_key+绑定规则匹配 → 投递到目标Queue队列 → 消费者监听队列取消息

# 为什么不能生产者直接发队列？交换机解决的业务能力
# 1. 灵活路由：一条消息分发到多个队列（广播、多订阅）
# 2. 分类过滤：按标签区分日志、订单、支付消息，不同消费者只接收自己关心的数据
# 3. 解耦：生产者只关心发给交换机，不用知道有多少队列、队列名称
# 4. 复杂分发：点对点、广播、模糊匹配、多条件筛选四种分发模式

# RabbitMQ 四种原生交换机类型（核心，开发必记）
## 1. Direct 直连交换机（点对点，最常用）
# 路由规则：消息routing\_key 必须 和 队列绑定的routing\_key完全相等，才投递
# 业务场景：订单推送、短信发送、一对一通知
# 示例命令创建：
rabbitmqctl declare_exchange /biz direct_order direct true
                声明交换机    vhost  交换机名称   交换机类型  `true`：durable，true = 持久化，重启不丢失交换机


# 创建交换机
rabbitmqadmin -u admin -p Admin@Rabbit2026 declare exchange -p /biz name=direct_order type=direct durable=true

# 队列绑定：routing\_key=order\_create
rabbitmqctl bind_exchange /biz queue_order direct_order order_create
绑定队列语法  
 /biz  虚拟主机名 vhost                 
queue_order：要绑定的队列名
direct_order 交换机名称
order_create：路由键，用于路由匹配


# 生产者发消息必须携带 routing\_key="order\_create" 才能进入队列

## 2. Fanout 扇形交换机（广播模式）
# 路由规则：完全忽略routing\_key，消息复制一份发给所有绑定该交换机的队列
# 业务场景：系统配置刷新、全局公告、活动全服务通知
# 特点：分发速度最快，无匹配计算
rabbitmqctl declare\_exchange /biz fanout_notice fanout true

## 3. Topic 主题交换机（模糊匹配订阅）
# 路由规则：routing\_key用 . 分割多级标签，支持通配符匹配队列绑定key
# 通配符：
# \*  匹配任意1个单词
# #  匹配0个或多个单词
# 业务场景：日志分级（log.error、log.info）、多维度消息订阅
# 例：绑定key log.# 接收所有日志；log.error.\* 只接收错误日志

## 4. Headers 头部交换机（极少使用）
# 路由规则：不看routing\_key，匹配消息headers键值对
# 适用：多字段复杂筛选，性能差，业务基本不用

# 关键配套概念：Binding 绑定
# 交换机本身不存消息，交换机和队列之间需要建立绑定关系 bind
# 绑定三要素：交换机名称、队列名称、路由键routing\_key
# 一条交换机可以绑定成千上万个队列，实现一对多分发

# ==============================================
# 语法：declare_exchange vhost 交换机名 类型 是否持久化
# durable true=持久化，服务重启交换机不消失（生产必开）
rabbitmqctl declare_exchange /order_vhost direct_order direct true
rabbitmqctl declare_exchange /order_vhost topic_log topic true
rabbitmqctl declare_exchange /order_vhost fanout_notice fanout true

# 删除交换机
rabbitmqctl delete_exchange /order_vhost direct_order

# 列出当前vhost所有交换机
rabbitmqctl list_exchanges -p /order_vhost name type durable


# ==============================================
# 六、队列 Queue 管理、绑定关系 Binding
# ==============================================
# 1. 声明队列：vhost 队列名 持久化true/false
rabbitmqctl declare_queue /order_vhost queue_order true

# 2. 交换机绑定队列（核心路由规则）
# 格式：bind_exchange vhost 队列 交换机 routing_key
rabbitmqctl bind_exchange /order_vhost queue_order direct_order order_rk

# 3. 解绑
rabbitmqctl unbind_exchange /order_vhost queue_order direct_order order_rk

# 4. 查看所有队列（积压消息、消费者数量、未确认消息）
rabbitmqctl list_queues -p /order_vhost name messages consumers messages_unacknowledged

# 5. 清空队列所有消息（不删除队列）
rabbitmqctl purge_queue -p /order_vhost queue_order

# 6. 删除队列（有消息/有消费者会报错，加 -f 强制删除）
rabbitmqctl delete_queue -p /order_vhost queue_order -f

# 7. 查看所有绑定关系
rabbitmqctl list_bindings -p /order_vhost

# ==============================================
# 七、消息发布、消费、测试命令（调试专用）
# ==============================================
# 1. 命令行发送消息（指定vhost、交换机、路由key、消息体）
rabbitmqctl publish -p /order_vhost direct_order order_rk '{"order_id":"ORD001"}'

# 2. 命令行消费消息（自动ack，调试用，生产不使用）
rabbitmqctl consume -p /order_vhost queue_order

# ==============================================
# 八、镜像队列策略（集群高可用，消息多副本）
# ==============================================
# 给所有队列设置镜像，同步到集群全部节点
rabbitmqctl set_policy -p /order_vhost ha-all "^" '{"ha-mode":"all"}'
# 查看策略
rabbitmqctl list_policies -p /order_vhost
# 删除策略
rabbitmqctl delete_policy -p /order_vhost ha-all

# ==============================================
# 九、集群运维命令
# ==============================================
# 1. 查看集群所有节点状态
rabbitmqctl cluster_status

# 2. 从节点加入集群（从节点执行）
rabbitmqctl stop_app
rabbitmqctl join_cluster rabbit@主节点主机名
rabbitmqctl start_app

# 3. 退出集群（节点单独拆分）
rabbitmqctl stop_app
rabbitmqctl reset
rabbitmqctl start_app

# ==============================================
# 十、故障排查、监控、诊断命令大全
# ==============================================
# 1. 查看所有客户端连接（IP、账号、队列、空闲时间）
rabbitmqctl list_connections name user state

# 2. 强制断开异常客户端连接
rabbitmqctl close_connection "连接标识" "断开原因"

# 3. 查看消费者列表（哪个进程在消费哪个队列）
rabbitmqctl list_consumers -p /order_vhost

# 4. 磁盘/内存告警状态
rabbitmqctl status | grep disk
rabbitmqctl status | grep memory

# 5. 导出完整诊断日志（故障上报）
rabbitmq-diagnostics status > rabbit_status.log
rabbitmq-diagnostics environment > rabbit_env.log

# 6. 重置节点（清空所有数据、用户、队列，慎用！）
rabbitmqctl stop_app
rabbitmqctl reset
rabbitmqctl start_app

# ==============================================
# 十一、备份与恢复命令（数据容灾）
# ==============================================
# 1. 全量元数据备份（交换机、队列、用户、vhost、权限策略）
rabbitmqctl export_definitions /data/rabbit_backup.json -u admin -p Admin@2026

# 2. 恢复元数据（重装/故障重建后导入）
rabbitmqctl import_definitions /data/rabbit_backup.json -u admin -p Admin@2026

# ==============================================
# 十二、从零学习完整目录（学习路线）
# ==============================================
# 阶段1：基础环境
# 1. 安装RabbitMQ，认识目录结构
# 2. 服务启停、开启web管理插件
# 3. 创建管理员账号，删除默认guest高危账号

# 阶段2：资源隔离（生产规范）
# 1. vhost虚拟主机创建、业务拆分隔离
# 2. 用户创建、最小权限分配、角色区分

# 阶段3：四大交换机与队列核心概念
# 1. Direct直连：点对点订单、短信
# 2. Topic主题：日志分级、多标签订阅
# 3. Fanout扇形：全局广播通知
# 4. Headers头部：极少使用，复杂多条件匹配
# 5. 队列声明、绑定关系、持久化开关

# 阶段4：消息可靠机制（开发核心）
# 1. 三层持久化：交换机durable、队列durable、消息delivery_mode=2
# 2. ACK确认：自动ack（禁用）/手动ack（生产强制）
# 3. QOS预取：prefetch_count 控制批量拉取，防止内存溢出
# 4. 死信队列DLX：消息过期、消费失败自动转发兜底

# 阶段5：Python开发实操
# 1. pika客户端连接封装（vhost+账号密码）
# 2. 四大交换机生产者、消费者代码
# 3. 死信队列实现、消息幂等处理（解决重复消费）
# 4. 连接重连、异常捕获、日志规范

# 阶段6：运维与高可用
# 1. 常用命令行日常巡检（队列积压、连接、消费者）
# 2. 镜像队列集群部署、节点扩容
# 3. 元数据备份恢复、故障排查
# 4. 消息丢失、消息积压、重复消费排障方案

# 阶段7：生产避坑规范
# 1. 禁止guest账号、禁止0.0.0.0外网无密码暴露
# 2. 所有业务交换机、队列必须持久化
# 3. 消费者关闭自动ack，业务完成手动确认
# 4. 配置死信队列，避免失败消息无限重试堵塞队列
# 5. 不同业务拆分独立vhost，互不干扰
# 6. 监控队列积压、磁盘使用率、客户端连接异常
```

### 开发视角学RabbitMQ

```md
# ==================================================
# RabbitMQ Python 开发完整从零实战
# 1. 开发使用场景（什么业务必须用MQ）
# 2. 环境安装、基础概念
# 3. 四大交换机 + 队列持久化/消息持久化
# 4. 生产者、消费者代码实战
# 5. 死信队列、消息丢失/重复消费业务解决方案
# 6. 生产开发规范避坑
# ==================================================

# 安装Python RabbitMQ客户端 pika（官方标准库）
pip3 install pika

# --------------------------
# 一、Python开发RabbitMQ适用业务场景（开发判断标准）
# --------------------------
cat > 00_scene_intro.py <<'EOF'
# 业务场景1：异步解耦（最常用）
# 举例：用户下单后，同步逻辑只完成创建订单；
# 异步任务：发短信、发推送、积分发放、日志记录、优惠券发放
# 不用同步串行执行，提升接口响应速度，用户无等待

# 业务场景2：流量削峰填谷（秒杀、活动大流量）
# 秒杀瞬间几万请求，直接操作数据库会压垮DB；
# 请求全部存入MQ，消费者匀速消费，控制数据库写入QPS

# 业务场景3：最终一致性分布式事务
# 跨服务操作：下单→扣库存→支付；
# 某服务失败，通过MQ重试、回滚消息保证数据最终一致

# 业务场景4：广播通知（多服务同时接收同一条消息）
# 配置更新、系统公告、活动上线通知；
# 一个消息发给订单服务、库存服务、统计服务同时处理

# 业务场景5：延时任务
# 订单30分钟未支付自动取消、优惠券到期提醒、定时推送消息

# 业务场景6：日志/大数据采集分流
# 业务日志统一投递MQ，消费端分发到ES、Hive、监控系统

# 不建议使用场景：
# 1. 需要强实时同步、强一致性（优先本地事务）
# 2. 简单单机同步小任务（直接函数调用，引入MQ增加复杂度）
# 3. 仅单机运行、无异步需求的小型工具项目
print("RabbitMQ Python适用场景讲解完成")
EOF
python3 00_scene_intro.py

# --------------------------
# 二、RabbitMQ核心基础概念（开发必懂）
# --------------------------
# 1. Producer 生产者：发送消息的Python程序
# 2. Consumer 消费者：监听队列、处理消息的Python程序
# 3. Queue 队列：存储消息，消息最终存在队列里
# 4. Exchange 交换机：接收生产者消息，按规则路由到队列（4种类型）
# 5. Binding 绑定：交换机和队列之间的绑定关系，携带路由key
# 6. Vhost 虚拟主机：多业务隔离，独立权限、交换机、队列
# 7. 持久化三要素：交换机持久、队列持久、消息持久（防宕机丢失）
# 8. ACK确认机制：手动/自动确认，控制消息是否重新投递

# --------------------------
# 三、基础直连交换机 Direct（点对点业务，订单、短信）
# --------------------------
cat > 01_direct_demo.py <<'EOF'
import pika

# ====================== 通用连接封装 ======================
def get_connection():
    # 连接参数，生产使用内网IP、账号密码，禁止guest外网访问
    credentials = pika.PlainCredentials("admin", "Admin@2026")
    conn_params = pika.ConnectionParameters(
        host="127.0.0.1",
        port=5672,
        virtual_host="/biz_vhost",
        credentials=credentials
    )
    connection = pika.BlockingConnection(conn_params)
    return connection

# ====================== 1. 生产者 Direct 直连交换机 ======================
def producer_direct():
    conn = get_connection()
    channel = conn.channel()

    # 1. 声明持久化交换机 direct_order，类型direct，durable=True持久
    channel.exchange_declare(
        exchange="direct_order",
        exchange_type="direct",
        durable=True
    )
    # 2. 声明持久化队列
    channel.queue_declare(queue="queue_order", durable=True)
    # 3. 交换机绑定队列，路由key=order_routing
    channel.queue_bind(
        exchange="direct_order",
        queue="queue_order",
        routing_key="order_routing"
    )

    # 发送消息，delivery_mode=2 开启消息持久化
    msg_body = '{"order_id":"ORD001","user_id":1001,"amount":99}'
    channel.basic_publish(
        exchange="direct_order",
        routing_key="order_routing",
        body=msg_body,
        properties=pika.BasicProperties(
            delivery_mode=2,  # 消息持久化，宕机不丢失
        )
    )
    print(f"生产者发送订单消息: {msg_body}")
    conn.close()

# ====================== 2. 消费者 Direct 直连交换机 ======================
def consumer_direct():
    conn = get_connection()
    channel = conn.channel()
    channel.exchange_declare(exchange="direct_order", exchange_type="direct", durable=True)
    channel.queue_declare(queue="queue_order", durable=True)
    channel.queue_bind(exchange="direct_order", queue="queue_order", routing_key="order_routing")

    # 核心：关闭自动ACK，改为手动确认（生产强制开启，防止消息丢失）
    channel.basic_consume(
        queue="queue_order",
        on_message_callback=callback,
        auto_ack=False
    )
    print("消费者等待订单消息...")
    channel.start_consuming()

# 消息处理回调函数
def callback(ch, method, properties, body):
    msg = body.decode("utf-8")
    print(f"收到订单消息: {msg}")
    try:
        # 执行业务逻辑：创建订单、扣减库存、发短信
        print("业务处理完成")
        # 手动ACK确认，告知MQ消息处理完毕，可以删除
        ch.basic_ack(delivery_tag=method.delivery_tag)
    except Exception as e:
        # 业务异常，NACK，消息重新入队重试
        print(f"处理失败，消息重发: {e}")
        ch.basic_nack(delivery_tag=method.delivery_tag, requeue=True)

if __name__ == '__main__':
    # 发送一条消息
    producer_direct()
    # 启动消费者监听（注释生产者，单独运行消费者持续监听）
    # consumer_direct()
EOF
# 运行生产者发送消息
python3 01_direct_demo.py
# 新开终端注释producer_direct，打开consumer_direct运行消费

# --------------------------
# 四、Topic主题交换机（日志分级、多标签订阅，通配符匹配）
# * 匹配单个单词  # 匹配0或多个单词
# --------------------------
cat > 02_topic_demo.py <<'EOF'
import pika

def get_connection():
    credentials = pika.PlainCredentials("admin", "Admin@2026")
    conn = pika.BlockingConnection(pika.ConnectionParameters("127.0.0.1", 5672, "/biz_vhost", credentials))
    return conn

# 生产者：推送不同级别日志
def producer_topic():
    conn = get_connection()
    ch = conn.channel()
    ch.exchange_declare(exchange="topic_log", exchange_type="topic", durable=True)

    # 三条不同路由key日志
    logs = [
        ("log.info.order", "订单正常日志"),
        ("log.error.pay", "支付异常日志"),
        ("log.warn.goods", "商品库存警告日志")
    ]
    for rk, content in logs:
        ch.basic_publish(
            exchange="topic_log",
            routing_key=rk,
            body=content,
            properties=pika.BasicProperties(delivery_mode=2)
        )
        print(f"发送日志 rk:{rk} 内容:{content}")
    conn.close()

# 消费者1：只接收error级日志 rk匹配 log.error.#
def consumer_error_log():
    conn = get_connection()
    ch = conn.channel()
    ch.exchange_declare(exchange="topic_log", exchange_type="topic", durable=True)
    # 临时队列，自动删除
    res = ch.queue_declare(queue="", exclusive=True)
    queue_name = res.method.queue
    ch.queue_bind(exchange="topic_log", queue=queue_name, routing_key="log.error.#")
    ch.basic_consume(queue=queue_name, on_message_callback=callback, auto_ack=False)
    print("【错误日志消费者】监听中")
    ch.start_consuming()

def callback(ch, method, props, body):
    print(f"收到日志: {body.decode()}")
    ch.basic_ack(method.delivery_tag)

if __name__ == '__main__':
    producer_topic()
    # consumer_error_log()
EOF
python3 02_topic_demo.py

# --------------------------
# 五、Fanout扇形交换机（广播，所有绑定队列全接收）
# 系统通知、配置刷新，无视routing_key
# --------------------------
cat > 03_fanout_demo.py <<'EOF'
import pika
def get_connection():
    cred = pika.PlainCredentials("admin", "Admin@2026")
    return pika.BlockingConnection(pika.ConnectionParameters("127.0.0.1", 5672, "/biz_vhost", cred))

def producer_fanout():
    conn = get_connection()
    ch = conn.channel()
    ch.exchange_declare(exchange="fanout_notice", exchange_type="fanout", durable=True)
    msg = "系统配置更新通知，请各服务重载配置"
    ch.basic_publish(exchange="fanout_notice", routing_key="", body=msg, properties=pika.BasicProperties(delivery_mode=2))
    print("广播通知已发送")
    conn.close()

# 多个消费者都会收到同一条广播消息
def consumer_notice():
    conn = get_connection()
    ch = conn.channel()
    ch.exchange_declare(exchange="fanout_notice", exchange_type="fanout", durable=True)
    q = ch.queue_declare("", exclusive=True)
    ch.queue_bind(exchange="fanout_notice", queue=q.method.queue)
    ch.basic_consume(queue=q.method.queue, on_message_callback=cb, auto_ack=False)
    print("通知消费者监听中")
    ch.start_consuming()

def cb(ch, method, props, body):
    print(f"收到广播: {body.decode()}")
    ch.basic_ack(method.delivery_tag)

if __name__ == '__main__':
    producer_fanout()
EOF
python3 03_fanout_demo.py

# --------------------------
# 六、消息丢失、重复消费、死信队列 生产核心解决方案（Python）
# --------------------------
cat > 04_dlx_safe_msg.py <<'EOF'
import pika
import time

def get_conn():
    cred = pika.PlainCredentials("admin", "Admin@2026")
    return pika.BlockingConnection(pika.ConnectionParameters("127.0.0.1", 5672, "/biz_vhost", cred))

# ====================== 1. 死信队列DLX配置（消息重试耗尽转入死信，不丢失） ======================
def init_dlx():
    conn = get_conn()
    ch = conn.channel()
    # 死信交换机、死信队列
    ch.exchange_declare("dlx_ex", "direct", durable=True)
    ch.queue_declare("dlx_queue", durable=True)
    ch.queue_bind("dlx_ex", "dlx_queue", "dlx_rk")

    # 业务队列绑定死信参数：消息过期/被拒绝则转发到死信交换机
    args = {
        "x-dead-letter-exchange": "dlx_ex",
        "x-dead-letter-routing-key": "dlx_rk",
        "x-message-ttl": 30000,  # 消息30秒过期
        "x-max-retry": 3  # 最大重试3次
    }
    ch.queue_declare("biz_queue", durable=True, arguments=args)
    ch.exchange_declare("biz_ex", "direct", durable=True)
    ch.queue_bind("biz_ex", "biz_queue", "biz_rk")
    conn.close()
    print("死信队列初始化完成")

# ====================== 生产者（完整持久化，防止生产端丢消息） ======================
def safe_producer():
    conn = get_conn()
    ch = conn.channel()
    # 开启生产者确认，消息落盘后返回ack，确保不丢失
    ch.confirm_delivery()
    ch.exchange_declare("biz_ex", "direct", durable=True)
    msg = '{"pay_id":10086}'
    # mandatory：无法路由的消息返回生产者，不丢弃
    success = ch.basic_publish(
        exchange="biz_ex",
        routing_key="biz_rk",
        body=msg,
        mandatory=True,
        properties=pika.BasicProperties(delivery_mode=2)
    )
    if success:
        print("消息投递成功")
    else:
        print("消息投递失败，本地日志重试")
    conn.close()

# ====================== 消费者 手动ACK，解决丢失与重复消费 ======================
def safe_consumer():
    conn = get_conn()
    ch = conn.channel()
    ch.basic_qos(prefetch_count=1)  # 公平分发，一次只拿一条消息
    ch.basic_consume(
        queue="biz_queue",
        on_message_callback=safe_cb,
        auto_ack=False
    )
    print("安全消费者启动")
    ch.start_consuming()

def safe_cb(ch, method, props, body):
    msg = body.decode()
    print(f"处理消息: {msg}")
    try:
        # 业务逻辑，必须实现幂等，防止重复消费
        # 幂等方案：消息唯一ID查询数据库是否已处理
        unique_id = props.message_id
        print(f"幂等校验ID:{unique_id}")
        # 模拟正常处理
        # 手动确认
        ch.basic_ack(method.delivery_tag)
    except Exception as e:
        print(f"处理异常，重试: {e}")
        # 拒绝消息，不重回原队列，进入死信
        ch.basic_nack(method.delivery_tag, requeue=False)

if __name__ == '__main__':
    init_dlx()
    safe_producer()
    # safe_consumer()
EOF
python3 04_dlx_safe_msg.py

# --------------------------
# 七、Python开发生产规范&避坑
# --------------------------
cat > 05_dev_rule.py <<'EOF'
# 1. 连接管理
# 长连接复用，不要每次发送新建连接；多线程每个线程独立channel
# 捕获连接断开异常，自动重连机制

# 2. 防消息丢失三层保障
# 生产者：开启confirm确认、mandatory、消息持久化
# 服务端：交换机durable、队列durable、delivery_mode=2
# 消费者：关闭auto_ack，业务成功后手动ack

# 3. 重复消费唯一解决方案：业务幂等
# 每条消息携带唯一message-id，消费前查询数据库是否已处理；
# 数据库唯一主键约束，重复插入直接报错，不产生脏数据

# 4. 流量控制
# 消费者设置basic_qos(prefetch_count=N)，防止一次性拉取海量消息占满内存

# 5. 禁止长耗时业务
# 单条消息处理不能过长，否则ACK超时，消息反复重试阻塞队列

# 6. 多业务隔离
# 不同业务创建独立vhost，独立账号，权限最小化，不共用队列交换机

# 7. 死信必须配置
# 失败消息不无限重试，转入死信队列人工排查，避免队列无限堆积

# 8. 日志规范
# 每条消息打印唯一ID、内容、处理耗时，方便排查丢失/重复问题
print("RabbitMQ Python开发规范讲解完成")
EOF
python3 05_dev_rule.py

# --------------------------
# 核心速记
# --------------------------
# 1. 使用场景：异步解耦、削峰、广播、延时任务、分布式事务
# 2. 四大交换机：Direct点对点、Topic通配订阅、Fanout广播、Headers极少使用
# 3. 安全三要素：生产者confirm、持久化、手动ACK
# 4. 消息异常兜底：死信队列DLX
# 5. 重复消费根治：业务幂等（唯一ID去重）
# 6. 开发底线：禁止自动ACK、禁止无持久化、不共用vhost、长连接复用
```

### Kafka

- 集群部署、broker/topic/ 分区 / 副本
- 生产者、消费者工作机制
- 日志采集场景运维
- 磁盘刷盘、副本同步、性能调优
- 消息堆积、消费异常排查

```md
# ==================================================
# Kafka 分布式消息队列 生产运维全栈
# 1. 核心概念：broker/topic/分区/副本 | 2. 3节点集群部署
# 3. 生产者/消费者工作机制 | 4. 日志采集场景运维
# 5. 性能调优：磁盘刷盘+副本同步 | 6. 故障排查：堆积/消费异常
# ==================================================

# --------------------------
# 一、核心基础概念
# --------------------------
# 1. Broker：Kafka 服务节点，一台服务器运行一个 broker，多节点组成集群
# 2. Topic：消息主题，业务逻辑分类，相当于消息的"逻辑队列"
# 3. Partition 分区：Topic 的物理分片，一个 topic 拆分为 N 个分区分布在不同 broker
#    - 分区是 Kafka 高并发的基础：生产者并行写，消费者并行读
#    - 单分区内消息严格有序，多分区整体无序
#    - 每个分区对应一个物理日志文件，顺序追加写入，性能极高
# 4. Replica 副本：每个分区有多份副本，保证高可用与数据冗余
#    - Leader 副本：唯一负责读写，生产者、消费者只与 leader 交互
#    - Follower 副本：只从 leader 同步数据，不提供读写；leader 宕机时选举新 leader
#    - ISR（In-Sync Replicas）：同步副本列表，与 leader 数据保持同步的副本集合
# 5. 集群元数据：传统架构依赖 Zookeeper 管理；3.x 新增 KRaft 模式，可无 ZK 独立运行

# --------------------------
# 二、3节点集群部署（生产标准 ZK 架构）
# --------------------------
## 前置依赖：所有节点安装 JDK1.8+，提前搭建好 3 节点 Zookeeper 集群

# 1. 下载解压二进制包，配置环境变量
tar -zxf kafka_2.13-3.6.1.tgz -C /usr/local/
ln -s /usr/local/kafka_2.13-3.6.1 /usr/local/kafka
echo 'export PATH=$PATH:/usr/local/kafka/bin' >> /etc/profile
source /etc/profile

# 2. 目录规划（数据与日志分离）
mkdir -p /data/kafka/kafka-logs   # 分区消息数据目录
mkdir -p /var/log/kafka          # 服务运行日志目录
useradd -s /sbin/nologin kafka
chown -R kafka:kafka /data/kafka /var/log/kafka /usr/local/kafka

# 3. 节点1核心配置 server.properties（节点2/3仅修改 broker.id 与监听IP）
cat > /usr/local/kafka/config/server.properties <<'EOF'
# ========== 节点基础配置 ==========
broker.id=1                     # 集群全局唯一，节点2设为2，节点3设为3
listeners=PLAINTEXT://192.168.1.10:9092  # 本机监听地址
advertised.listeners=PLAINTEXT://192.168.1.10:9092  # 对外广播的访问地址

# ========== 存储配置 ==========
log.dirs=/data/kafka/kafka-logs  # 消息数据目录，多磁盘可配多个目录并行IO
num.partitions=3                 # Topic 默认分区数
default.replication.factor=3     # 默认副本数，生产建议 3 副本保证高可用

# ========== Zookeeper 连接 ==========
zookeeper.connect=192.168.1.10:2181,192.168.1.11:2181,192.168.1.12:2181/kafka
zookeeper.connection.timeout.ms=6000

# ========== 副本与可靠性 ==========
offsets.topic.replication.factor=3   # 消费偏移量内置主题副本数
min.insync.replicas=2                # ISR 最小副本数，配合 acks=all 使用
replica.lag.time.max.ms=30000        # 副本落后超30秒踢出ISR

# ========== 消息留存 ==========
log.retention.hours=72          # 消息默认保留 72 小时，按磁盘与业务调整
log.segment.bytes=1073741824    # 单日志段最大 1G，满了自动滚动新文件
log.retention.check.interval.ms=300000

# ========== 性能基础参数 ==========
num.network.threads=8           # 网络请求处理线程数
num.io.threads=8                # 磁盘 IO 线程数
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
EOF

# 4. 节点2、节点3配置：仅修改 broker.id、listeners、advertised.listeners，其余参数完全对齐

# 5. 启动集群（每个节点后台启动）
su - kafka -c "kafka-server-start.sh -daemon /usr/local/kafka/config/server.properties"

# 6. 集群验证
# 查看所有在线 broker 节点
zookeeper-shell.sh 127.0.0.1:2181 ls /kafka/brokers/ids
# 创建测试 Topic
kafka-topics.sh --bootstrap-server 192.168.1.10:9092 \
  --create --topic test_topic --partitions 3 --replication-factor 3
# 查看 Topic 分区、副本、leader 分布
kafka-topics.sh --bootstrap-server 192.168.1.10:9092 --describe --topic test_topic

# --------------------------
# 三、生产者 & 消费者核心工作机制
# --------------------------

## 1. 生产者工作机制
# 流程：消息封装 → 分区分配 → 批量攒批 → 发送到对应分区 leader
#
# ① 分区分配策略
# - 轮询策略：无 key 时默认，消息均匀分配到所有分区，负载均衡最优
# - Key 哈希策略：指定 key 时，相同 key 的消息写入同一分区，保证单 key 有序
# - 自定义策略：按业务规则指定目标分区
#
# ② 可靠性核心：acks 应答机制
# acks=0：发完即返回，不等待 broker 确认
#   ✅ 性能最高 ❌ 可靠性最差，broker 宕机直接丢数据
# acks=1：leader 写入成功就返回（默认值）
#   ✅ 性能与可靠性平衡 ❌ leader 写入后 follower 同步前宕机，丢数据
# acks=-1 / all：ISR 内所有副本都写入成功才返回
#   ✅ 可靠性最高 ❌ 性能最低、延迟高，必须配合 min.insync.replicas 使用
#
# ③ 性能优化机制
# - 批量发送：batch.size 攒满一批再发，减少网络交互
# - 等待上限：linger.ms 到时间即使没攒满也发送，平衡延迟与吞吐
# - 压缩传输：compression.type=lz4/snappy，减少网络带宽与磁盘占用
# - 失败重试：retries 自动重试，避免临时网络波动丢消息

## 2. 消费者工作机制
# 核心概念：消费者组（Consumer Group）
# - 一个组包含多个消费者实例，共同消费一个 topic
# - 一个分区只能被组内**一个**消费者消费；一个消费者可消费多个分区
# - 组间隔离：同一个 topic，不同消费组各自消费全量数据，互不影响
#
# ① 重平衡（Rebalance）
# 触发：消费者实例增减、topic 分区数变化、订阅主题变更
# 影响：重平衡期间消费组暂停消费，可能导致重复消费、延迟升高
# 优化：调大超时时间、减少消费者频繁启停、稳定实例数量
#
# ② Offset 消费偏移量
# 作用：记录消费者消费到分区的位置，重启后接续消费
# 存储：内置主题 __consumer_offsets 持久化存储所有组偏移量
# 提交方式：
# - 自动提交：按时间间隔自动提交，简单但可能丢消息/重复消费
# - 手动提交：业务处理完成后手动提交，精准可控，生产推荐
#
# ③ 消费语义
# - 最多一次：自动提交，可能丢消息
# - 至少一次：手动提交，处理完再提交，可能重复消费（生产默认）
# - 精确一次：事务 + 幂等实现 Exactly Once，金融等核心场景用

# --------------------------
# 四、日志采集场景运维（ELK 标准架构）
# 典型链路：Filebeat（采集） → Kafka（削峰缓冲） → Logstash/Flink（清洗） → ES（检索）
# --------------------------

## 1. Topic 规划规范
# - 按业务+日志类型划分，如 log_nginx_access、log_java_error、log_syslog
# - 分区数评估：单分区写吞吐 10~20MB/s，按目标吞吐量反推分区数
# - 副本数：核心日志 3 副本，非核心日志 2 副本
# - 禁止：所有日志混发同一个 topic，导致消费隔离性差、故障影响面大

## 2. 消费组隔离
# 不同消费场景使用独立消费组，互不影响
# 例：实时检索组 group_log_es、离线分析组 group_log_hive、告警组 group_log_alert

## 3. 核心运维命令
# 查看所有 Topic 列表
kafka-topics.sh --bootstrap-server 127.0.0.1:9092 --list
# 查看消费组积压延迟（最核心运维指标）
kafka-consumer-groups.sh --bootstrap-server 127.0.0.1:9092 \
  --describe --group group_log_es
# 关键字段：
# CURRENT-OFFSET：当前已消费位置
# LOG-END-OFFSET：分区最新消息位置
# LAG：消息积压量，核心告警指标

## 4. 运维要点
# 1. 留存周期：普通日志保留 3~7 天，审计日志按月留存
# 2. 消息大小：单条消息建议不超过 1MB，超大日志裁剪或转存对象存储
# 3. 分区扩容：消费能力不足时增加分区数+扩容消费者；分区只能加不能减
# 4. 监控告警：消费组 LAG、broker 磁盘使用率、分区 leader 均衡性必监控

# --------------------------
# 五、性能调优：磁盘刷盘 + 副本同步 + 参数优化
# --------------------------

## 1. 磁盘刷盘机制
# Kafka 高性能核心：依赖操作系统页缓存（Page Cache），默认异步刷盘
# 写入路径：消息 → 操作系统页缓存 → 后台异步刷入磁盘
# 优势：顺序写入 + 页缓存，性能接近内存级
# 服务端调优参数
cat >> /usr/local/kafka/config/server.properties <<'EOF'
# 刷盘条数阈值（不建议调太小，会大幅降低性能）
log.flush.interval.messages=10000
# 刷盘时间阈值
log.flush.interval.ms=1000
# 生产原则：用副本机制保证可靠性，不强制同步刷盘，依赖系统异步刷盘保性能
EOF
# 系统层优化
# - 使用 SSD 磁盘，顺序写入性能远高于机械盘
# - 多块磁盘配置多个 log.dirs，并行 IO 提升吞吐量
# - 关闭 swap，避免页缓存被交换到磁盘导致性能暴跌

## 2. 副本同步调优
# 核心目标：稳定 ISR 列表，减少副本频繁进出，保证数据可靠性
cat >> /usr/local/kafka/config/server.properties <<'EOF'
# 副本拉取线程数，提升同步速度
num.replica.fetchers=4
# 单次拉取最大字节数
replica.fetch.max.bytes=1048576
# 副本最大落后时长，超时踢出 ISR
replica.lag.time.max.ms=30000
EOF

## 3. 生产端性能优化
# - 吞吐优先：acks=1 + 开启 lz4 压缩 + 调大 batch.size + linger.ms=5
# - 可靠优先：acks=all + min.insync.replicas=2 + 开启重试

## 4. 消费端性能优化
# - 消费者线程数与分区数对齐，不超过分区数
# - 调大拉取批量，减少网络交互
# - 手动批量提交 offset，减少提交开销

# --------------------------
# 六、常见故障排查
# --------------------------

## ==================================
## 故障1：消息堆积（消费组 LAG 持续增长）
## 现象：业务日志处理延迟，监控 LAG 指标持续上升
## ==================================
### 排查步骤
# 1. 定位范围：全集群堆积还是单个消费组？全 topic 还是单个 topic？
kafka-consumer-groups.sh --bootstrap-server 127.0.0.1:9092 --describe --group 组名
# 查看各分区 LAG，判断是全部分区堆积还是个别分区热点堆积

# 2. 排查消费者状态
# - 消费者服务是否存活、进程是否正常
# - 消费者报错日志：反序列化失败、业务异常、重平衡频繁

### 常见根因与解决
# 根因1：消费者服务宕机/重启，停止消费
# 解决：恢复服务，自动从上次 offset 接续消费
#
# 根因2：消费逻辑慢，单条处理耗时久
# 解决：优化业务逻辑、减少慢查询/外部调用；增加消费者实例/线程
#
# 根因3：分区热点，单分区消息量远超其他
# 解决：优化分区策略，打散热点 key；扩容分区重新分配
#
# 根因4：频繁重平衡，消费持续中断
# 解决：调大 session.timeout.ms、max.poll.interval.ms；稳定消费者实例数量

## ==================================
## 故障2：消费异常 / 消息丢失 / 重复消费
## ==================================
### 场景A：消费报错，无法正常消费
# 排查：查看消费者错误日志
# 常见原因：
# 1. 消息格式异常，反序列化失败 → 配置死信队列，异常消息转存，不阻塞主链路
# 2. Offset 越界：消费位置超出分区当前范围 → 重置 offset 到最早/最新位置
#    重置命令：kafka-consumer-groups.sh --reset-offsets --to-earliest --topic topic名 --group 组名 --execute
# 3. 权限不足 → 配置 ACL 权限

### 场景B：消息丢失
# 根因1：生产端 acks=0，broker 未收到就返回成功
# 解决：核心业务改为 acks=1/all，开启重试机制
# 根因2：broker 接收后未刷盘就宕机，且无副本
# 解决：设置合理副本数，多副本冗余
# 根因3：消费端自动提交 offset，业务未处理完就宕机
# 解决：改为手动提交，业务处理完成后再提交 offset

### 场景C：重复消费
# 根因：手动提交前消费者宕机、重平衡导致消息重新投递
# 解决：
# - 业务侧实现幂等性（唯一键去重、数据库唯一约束），是唯一根治方案
# - 优化提交时机，缩小处理与提交的时间差
# - 减少不必要的重平衡

## ==================================
## 故障3：Broker 节点故障
## ==================================
# 现象：节点离线，分区 leader 重新选举，短暂不可用
# 排查：
# 1. 查看服务日志 /var/log/kafka/server.log 定位报错
# 2. 检查磁盘空间、内存、端口占用、ZK 连接状态
# 处理：
# 1. 单节点故障：集群自动选举新 leader，业务无感知；修复后重新加入集群
# 2. 多节点故障：优先恢复数据最完整的节点，保证 ISR 副本可用
# 3. 日志损坏：删除损坏日志段，从其他副本同步恢复

# --------------------------
# 核心速记
# --------------------------
# 1. 核心四要素：broker 节点、topic 分类、分区并发、副本高可用
# 2. 生产者：acks 三档平衡性能与可靠，批量压缩提吞吐
# 3. 消费者：组内分区一对一，offset 控进度，手动提交更可靠
# 4. 性能：依赖页缓存异步刷盘，SSD+多目录提 IO，多副本保可靠
# 5. 故障：堆积先查 LAG 与消费者，丢数据查 ack 与提交，重复靠幂等兜底
# 6. 日志运维：按业务分 topic，消费组隔离，LAG 是核心监控指标
```

## 2. 企业文件存储服务

### NFS 局域网共享

- 服务端部署、exports 权限配置
- 客户端挂载、永久挂载 fstab
- 权限映射、读写故障、权限报错排查

```md
# ==============================
# NFS局域网共享 从零完整教学（补充完整端口详解）
# 包含：简介/架构/原理/端口详解/服务端部署/exports配置/客户端挂载/fstab永久挂载/权限故障排查
# ==============================

# 一、NFS简介、架构、工作原理、端口、核心概念
# 1. NFS简介
# Network File System 网络文件系统，Linux局域网机器共享目录
# 一台服务端共享文件夹，多台客户端远程挂载使用，像本地文件夹一样读写
# 优势：局域网高速、原生Linux支持、配置简单；仅Linux/Unix互通，Windows需额外客户端

# 2. 整体架构
# 服务端Server：存放原始文件，开启nfs服务，配置共享目录权限 /etc/exports
# 客户端Client：通过mount命令远程挂载服务端共享目录到本地路径
# 通信依赖RPC服务：NFS本身无固定端口注册能力，由rpcbind统一管理端口映射

# 3. NFS全套端口详细说明（重点补充）
## 固定端口（永久不变，防火墙必须放行）
# 1. rpcbind 端口：111（TCP/UDP）RPC核心注册端口，客户端第一步先连111查询NFS各服务端口
# 2. NFS主服务 nfs-server：2049（TCP/UDP）真正读写文件传输端口

## 动态随机端口（rpc.mountd、rpc.statd、rpc.lockd 每次重启随机分配，防火墙难放行）
# mountd：挂载守护进程，处理客户端mount挂载请求，随机端口
# statd：状态监控，检测客户端断开
# lockd：文件锁，防止多机器同时写文件冲突

## 企业固定动态端口方案（生产必配，避免防火墙拦截）
# 编辑 /etc/sysconfig/nfs，写入固定端口
RQUOTAD_PORT=4001
LOCKD_TCPPORT=4002
LOCKD_UDPPORT=4002
MOUNTD_PORT=4003
STATD_PORT=4004
STATD_OUTGOING_PORT=4005
# 修改后重启rpcbind、nfs-server，全部辅助端口固定，防火墙统一放行4001-4005

## 防火墙完整放行端口清单
# 111 tcp/udp、2049 tcp/udp、4001-4005 tcp/udp

# 4. 工作原理（结合端口流程）
# 1) 服务端启动rpcbind(111)、nfs-server(2049)、mountd/statd/lockd，向111端口注册所有子服务端口
# 2) 客户端先连接服务端111端口(rpcbind)，查询nfs、mountd等对应端口号
# 3) 客户端使用mountd端口发送挂载请求，校验IP、exports权限
# 4) 挂载成功后，客户端通过2049端口读写远程文件
# 5) lockd/statd负责文件锁、断线重连检测
# 6) 所有增删改文件实际操作服务端磁盘

# 5. 必备核心概念
# /etc/exports：NFS核心配置文件，定义共享目录、允许IP、权限参数
# rpcbind：RPC端口注册服务，NFS启动必须依赖，固定111端口
# nfs-server：NFS主程序，固定2049端口
# 权限映射root_squash：客户端root用户会被压缩为nobody普通用户（安全默认）
# no_root_squash：不压缩root，客户端root等同于服务端root（不安全，谨慎用）
# sync：同步写入，数据落盘才返回成功，稳定；async异步，性能高易丢数据
# ro：只读权限  rw：读写权限

# ==============================
# 二、NFS服务端部署（CentOS/RHEL，含端口固化+防火墙）
# ==============================
# 1. 安装依赖包
yum install -y nfs-utils rpcbind

# 2. 固化动态辅助端口（解决随机端口防火墙拦截问题）
vim /etc/sysconfig/nfs
# 末尾追加
RQUOTAD_PORT=4001
LOCKD_TCPPORT=4002
LOCKD_UDPPORT=4002
MOUNTD_PORT=4003
STATD_PORT=4004
STATD_OUTGOING_PORT=4005

# 3. 启动并设置开机自启（顺序不能变：先rpcbind后nfs）
systemctl enable --now rpcbind
systemctl enable --now nfs-server

# 4. 防火墙完整放行所有端口（固化端口后统一放行）
firewall-cmd --add-service=nfs --permanent
firewall-cmd --add-service=rpc-bind --permanent
firewall-cmd --add-port=111/tcp --permanent
firewall-cmd --add-port=111/udp --permanent
firewall-cmd --add-port=2049/tcp --permanent
firewall-cmd --add-port=2049/udp --permanent
firewall-cmd --add-port=4001-4005/tcp --permanent
firewall-cmd --add-port=4001-4005/udp --permanent
firewall-cmd --reload

# 5. 创建要共享的目录，设置基础权限
mkdir -p /data/nfs_share
chmod 777 /data/nfs_share

# 6. 编辑核心配置文件 /etc/exports
vim /etc/exports
# 写入配置模板，格式：共享目录 允许客户端IP(权限参数)
# 示例1：仅192.168.1.0网段所有机器可读可写
/data/nfs_share 192.168.1.0/24(rw,sync,root_squash,no_all_squash)
# 示例2：仅单台客户端192.168.1.10只读
# /data/nfs_share 192.168.1.10(ro,sync,root_squash)

# 参数详解：
# rw 读写 | ro 只读
# sync 同步写入（推荐）
# root_squash 客户端root转为nobody（安全默认）
# no_all_squash 普通用户保留原有UID/GID

# 7. 重载exports配置，无需重启服务
exportfs -r
# 查看当前生效共享列表
exportfs -v

# 8. 查看当前NFS所有注册端口（验证固化是否生效）
rpcinfo -p 127.0.0.1

# 9. 验证本机共享是否正常
showmount -e 127.0.0.1

# ==============================
# 三、客户端部署、临时挂载
# ==============================
# 1. 客户端安装工具
yum install -y nfs-utils

# 2. 查看服务端可共享目录（服务端IP 192.168.1.50）
showmount -e 192.168.1.50
# 连接失败排查：服务端111、2049、4001-4005端口防火墙未放行

# 3. 创建本地挂载点
mkdir -p /mnt/nfs_client

# 4. 临时挂载（重启失效）
mount -t nfs 192.168.1.50:/data/nfs_share /mnt/nfs_client

# 5. 查看已挂载分区
df -h

# 6. 临时卸载
umount /mnt/nfs_client

# ==============================
# 四、永久挂载 /etc/fstab 开机自动挂载
# ==============================
vim /etc/fstab
# 写入格式：服务端IP:共享目录 本地挂载点 文件系统类型 权限 备份自检
192.168.1.50:/data/nfs_share  /mnt/nfs_client  nfs  defaults,_netdev  0 0
# 参数 _netdev：告诉系统这是网络设备，等网卡启动后再挂载，避免开机找不到端口挂载失败

# 生效fstab配置，不重启验证
mount -a

# ==============================
# 五、权限映射、读写报错、端口故障完整排查
# ==============================
# 故障1：客户端无法写入文件，提示Permission denied
# 原因1：服务端共享目录本地权限不足（文件夹775/755无写权限）
# 修复：chmod 777 /data/nfs_share

# 原因2：root_squash压缩，客户端root变成nobody，目录不属于nobody
# 修复方案A（安全推荐）：目录归属nobody
chown nobody:nobody /data/nfs_share
# 修复方案B（内网信任环境，不推荐外网）：配置no_root_squash
# 修改/etc/exports：/data/nfs_share 192.168.1.0/24(rw,sync,no_root_squash)
exportfs -r

# 故障2：showmount -e 连接超时/无响应（端口类故障）
# 1. 服务端rpcbind、nfs-server未启动 systemctl status rpcbind nfs-server
# 2. 防火墙未放行111、2049、4001-4005端口
# 3. 未固化mountd等端口，每次重启端口随机，防火墙拦截
# 4. 客户端与服务端不在同一网段，IP规则未放行

# 故障3：mount -a 开机挂载失败，找不到共享目录
# fstab缺少 _netdev 参数，系统网卡没起来就执行挂载，端口未监听
# 修复：defaults,_netdev

# 故障4：能读不能写，exports配置写成ro只读
# 修复：修改/etc/exports参数为rw，执行exportfs -r重载

# 故障5：文件创建后属主显示nobody
# 正常现象，root_squash机制；多客户端账号统一UID/GID可解决用户错乱问题

# 故障6：文件多机器同时编辑报错lock冲突
# lockd端口未放行，文件锁功能失效，补齐4002端口防火墙规则

# ==============================
# 六、常用快捷命令总结
# ==============================
# 服务端重载共享配置
exportfs -r
# 查看共享
exportfs -v
# 查看RPC全部注册端口（端口排查核心命令）
rpcinfo -p 本机IP
# 客户端查看服务端共享
showmount -e 服务端IP
# 挂载/卸载
mount -t nfs IP:/共享目录 本地路径
umount 挂载点
# 开机挂载校验
mount -a
# 查看nfs服务状态
systemctl status nfs-server rpcbind
# 查看端口监听
netstat -lntp | grep -E "rpcbind|nfs"
ss -lntp | grep -E "rpcbind|nfs"
```

### Samba 跨平台共享

- Windows-Linux 文件互通
- 独立 smb 用户、权限管控
- 共享目录权限、访问故障排查

```md
# ==============================
# Samba跨平台文件共享 从零完整教学
# 覆盖：简介/架构/原理/端口/核心概念 | Linux<=>Windows互通 | SMB独立用户 | 权限管控 | 故障排查
# 环境：CentOS7/8/RHEL
# ==============================

# 一、Samba基础：简介、架构、工作原理、端口、核心概念
## 1. Samba简介
# Samba实现SMB/CIFS协议，实现Linux与Windows、macOS跨局域网文件共享
# NFS仅Linux互通；Samba主打Windows ↔ Linux 双向访问，打印机共享也支持

## 2. 架构组成
# 服务端两个核心进程：
# smbd：处理文件读写、权限、共享目录（核心）
# nmbd：NetBIOS名称解析，Windows可通过主机名访问Linux共享，不用输IP
# 客户端：Windows资源管理器 / Linux mount -t cifs

## 3. 完整工作原理
# 1. Windows客户端输入 \\LinuxIP 发起NetBIOS查询，nmbd解析主机名
# 2. 客户端连接smbd端口，发起SMB握手
# 3. 校验SMB独立账号密码（和系统Linux账号分离）
# 4. 权限双层校验：Samba配置权限 + Linux本地目录读写权限
# 5. 校验通过，挂载/读写远程目录；所有文件实际存Linux服务端磁盘

## 4. 全套端口（防火墙必须放行）
# 139/TCP/UDP：nmbd NetBIOS名称服务
# 445/TCP：SMB文件共享主端口（Windows主流只用445）
# 5. 核心必备概念
# /etc/samba/smb.conf：Samba主配置文件，定义共享目录、权限
# smbpasswd：Samba独立密码工具，SMB账号必须单独设密码（Linux系统用户≠Samba用户）
# security = user：账号密码认证模式（默认，企业通用）
# read only = no / yes：共享读写开关
# browseable = yes：Windows网络邻居可见该共享
# valid users：限制允许访问的smb用户
# create mask / directory mask：客户端新建文件/文件夹默认权限
# writable：等价read only=no，开启写入

# ==============================
# 二、服务端完整部署 Linux（CentOS）
## 1. 安装软件包
yum install -y samba samba-client

## 2. 开机自启，启动服务（smbd nmbd）
systemctl enable --now smbd nmbd
systemctl status smbd nmbd

## 3. 防火墙放行Samba端口
firewall-cmd --add-service=samba --permanent
# 手动放行端口备用
firewall-cmd --add-port=139/udp --permanent
firewall-cmd --add-port=139/tcp --permanent
firewall-cmd --add-port=445/tcp --permanent
firewall-cmd --reload

## 4. 创建共享目录 + 设置基础Linux权限
mkdir -p /data/samba_share
# 最低权限保证可读写
chmod 777 /data/samba_share

## 5. 创建系统用户（必须先有Linux系统用户，才能生成SMB账号）
useradd smbuser
# 可选设置系统登录密码（不用登录Linux可跳过）
passwd smbuser

## 6. 给系统用户设置Samba独立密码（关键！Windows访问靠这个密码）
smbpasswd -a smbuser
# -a 添加；-d 禁用；-x 删除smb账号

## 7. 编辑主配置文件 /etc/samba/smb.conf
vim /etc/samba/smb.conf
# ----------------配置模板----------------
[global]
   workgroup = WORKGROUP    # 和Windows工作组保持一致
   security = user
   map to guest = Bad User  # 禁止匿名访问
   netbios name = Linux-Server

# 自定义共享段 [共享名] Windows访问 \\IP\share
[myshare]
   path = /data/samba_share
   browseable = yes        # 网络邻居可见
   read only = no          # 允许读写
   writable = yes
   valid users = smbuser   # 仅smbuser可访问
   create mask = 0644      # 新建文件权限
   directory mask = 0755   # 新建文件夹权限
# ----------------------------------------

## 8. 校验配置语法（报错立即修复）
testparm

## 9. 重载Samba配置，不用重启服务
systemctl reload smbd

## 10. 查看当前生效共享列表
smbclient -L //127.0.0.1 -U smbuser

# ==============================
# 三、Windows 访问Linux Samba共享
## 方式1：Win+R 输入地址
\\192.168.1.100  # Linux服务端IP
# 弹窗输入用户名：smbuser  密码：smbpasswd设置的密码

## 方式2：映射网络驱动器（永久使用）
此电脑 → 右键映射网络驱动器
文件夹输入：\\192.168.1.100\myshare
勾选登录时重新连接，输入smb账号密码

# ==============================
# 四、Linux客户端挂载Windows共享 / Linux互访Samba
## 1. 客户端安装工具
yum install -y cifs-utils

## 2. 临时挂载Windows共享（重启失效）
mkdir /mnt/win_share
mount -t cifs //192.168.1.200/share /mnt/win_share -o username=Windows账号,password=Windows密码

## 3. /etc/fstab 永久开机挂载（推荐）
vim /etc/fstab
//192.168.1.200/share  /mnt/win_share  cifs  defaults,_netdev,username=winuser,password=123456 0 0
# _netdev 网络设备，等待网卡启动再挂载

# ==============================
# 五、SMB独立用户完整管控命令
# 1. 创建smb账号（前提存在同名Linux系统用户）
useradd testuser
smbpasswd -a testuser

# 2. 修改Samba密码
smbpasswd testuser

# 3. 禁用Samba账号（无法访问共享，不删系统用户）
smbpasswd -d testuser

# 4. 彻底删除Samba账号
smbpasswd -x testuser

# 5. 查看所有Samba用户
pdbedit -L

# ==============================
# 六、双层权限逻辑（必懂，90%报错根源）
# 两层权限同时校验，任意一层无权限就报错拒绝访问
# 第一层：Samba配置权限 smb.conf read only / valid users
# 第二层：Linux本地目录文件系统权限 chmod/chown
# 示例：smb.conf开了writable，但文件夹chmod=700，依然无法写入

# ==============================
# 七、访问故障、权限报错完整排查
## 故障1：Windows输入IP提示无法访问、找不到网络路径
# 1. 服务端smbd、nmbd未启动 systemctl start smbd nmbd
# 2. 防火墙139/445端口未放行
# 3. 客户端与服务端不在同一局域网，路由拦截139/445

## 故障2：账号密码错误，拒绝登录
# 1. 混淆Linux系统密码与Samba密码：必须用smbpasswd单独设置
# 2. 用户名写错，smb用户不存在：pdbedit -L 查看

## 故障3：能进入共享文件夹，但无法新建/删除文件 Permission denied
# 原因1：smb.conf read only=yes 只读，修改为no
# 原因2：Linux目录本地权限不足 chmod 777 /data/samba_share
# 原因3：valid users 未添加当前登录smb用户

## 故障4：testparm 报配置语法错误
# 检查smb.conf括号、换行、参数拼写，共享段[名称]不能有空格

## 故障5：网络邻居看不到共享文件夹
# smb.conf browseable = yes，且nmbd服务正常运行

## 故障6：Linux mount cifs挂载失败
# 缺少cifs-utils工具包；fstab账号密码写错；Windows防火墙拦截445

# ==============================
# 八、高频排查工具命令
# 校验配置
testparm
# 查看共享列表
smbclient -L //服务端IP -U smb用户名
# 交互式测试访问共享
smbclient //127.0.0.1/myshare -U smbuser
# 查看samba进程端口监听
ss -lntp | grep smbd
# 查看smb用户库
pdbedit -L
# 实时日志排错
tail -f /var/log/samba/log.smbd
```

### FTP/VSFTPD

- 匿名关闭、本地用户登录
- 上传下载权限、目录禁锢

```md
# VSFTPD/FTP 标准化学习架构全套脚本注释文档
# 统一学习标准：1基础认知 2服务端部署 3用户权限管控 4客户端使用 5安全隔离 6故障排查
# 适配系统：CentOS7/9 / Rocky Linux / Ubuntu20.04+
# 核心需求前置约束：关闭匿名登录、本地用户认证、上传下载权限可控、家目录chroot禁锢

###########################################################################
# 模块1：基础认知（简介、架构、协议端口、专业概念）
###########################################################################
# 1.1 FTP简介
# FTP：文件传输协议，C/S架构，明文传输账号密码，默认端口21控制端口
# VSFTPD：Very Secure FTP Daemon，Linux高性能轻量安全FTP服务端
# 核心模式：主动模式PORT / 被动模式PASV（生产环境强制使用被动模式）

# 1.2 双端口架构（控制通道+数据通道）
# 控制端口：21 永久固定，负责登录、命令交互（cd/ls/get/put）
# 主动模式数据端口：客户端随机高位端口 → 服务端20端口（防火墙极难放行，弃用）
# 被动模式数据端口：服务端自定义区间端口（示例40000-50000），客户端连接此区间传输文件

# 1.3 核心专业概念
# 匿名用户anonymous：无需系统账号，公开访问，生产环境必须关闭
# 本地用户local_user：读取/etc/passwd系统账号，密码/etc/shadow，企业主流认证方式
# chroot目录禁锢：限制用户登录后仅能访问自身家目录，禁止跨系统目录跳转
# write_enable：全局写入总开关，控制所有用户上传/删除/修改权限
# user_config_dir：用户独立配置目录，实现单用户差异化权限
# umask：文件/目录默认权限掩码，local_umask=022 生成文件644、目录755
# user_list黑白名单：精细化登录准入控制
# PAM认证：对接系统账号密码，vsftpd默认依赖pam_service_name=vsftpd

###########################################################################
# 模块2：服务端标准化部署流程（安装→启停→防火墙→目录→配置→校验生效）
###########################################################################
## 2.1 软件安装
# CentOS/RHEL系
# yum install -y vsftpd
# Ubuntu/Debian系
# apt update && apt install -y vsftpd

## 2.2 服务启停、开机自启
# systemctl enable --now vsftpd          # 开机自启+立即启动
# systemctl start vsftpd                 # 启动服务
# systemctl stop vsftpd                  # 停止服务
# systemctl restart vsftpd               # 重启加载配置
# systemctl reload vsftpd                # 平滑重载配置（不中断现有连接）
# systemctl status vsftpd                # 查看运行状态

## 2.3 防火墙放行（控制端口21 + 被动数据端口区间）
### firewalld(CentOS)
# firewall-cmd --permanent --add-service=ftp
# firewall-cmd --permanent --add-port=40000-50000/tcp
# firewall-cmd --reload
# firewall-cmd --list-ports --list-services

### ufw(Ubuntu)
# ufw allow 21/tcp
# ufw allow 40000:50000/tcp
# ufw reload

## 2.4 标准化业务目录规划
# 1. 用户家目录统一规范 /home/ftp_xxx
# 2. 上传子目录单独隔离，家目录禁止写权限（适配chroot禁锢）
# mkdir -p /etc/vsftpd/user_config_dir   # 单用户独立配置目录
# mkdir -p /data/ftp_public              # 公共FTP存储目录（可选）

## 2.5 主配置文件标准化写入 /etc/vsftpd/vsftpd.conf
# 备份原始配置
# cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak.$(date +%Y%m%d)
# 覆盖标准配置（关闭匿名、本地登录、chroot、被动端口、日志）
cat > /etc/vsftpd/vsftpd.conf <<EOF
# 关闭匿名访问
anonymous_enable=NO
anon_upload_enable=NO
anon_mkdir_write_enable=NO
# 开启本地系统用户登录
local_enable=YES
# 全局上传写入总开关
write_enable=YES
# 默认权限掩码
local_umask=022
# 开启目录禁锢，用户无法跳出家目录
chroot_local_user=YES
# chroot根目录禁止可写，规避登录报错
allow_writeable_chroot=NO
# 被动模式端口范围
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=50000
# 单用户差异化配置目录
user_config_dir=/etc/vsftpd/user_config_dir
# 日志开启
xferlog_enable=YES
xferlog_file=/var/log/vsftpd.log
xferlog_std_format=YES
# PAM系统账号认证
pam_service_name=vsftpd
# 监听ipv4，关闭ipv6
listen=YES
listen_ipv6=NO
EOF

## 2.6 配置语法校验 + 生效重载
# vsftpd /etc/vsftpd/vsftpd.conf        # 无输出=配置无语法错误
# systemctl reload vsftpd

###########################################################################
# 模块3：用户权限管控（账号管理 + 双层权限体系）
###########################################################################
## 3.1 系统FTP账号标准化管理
# 创建专用FTP用户，不允许ssh登录（安全加固）
# useradd -m -s /sbin/nologin ftp01
# passwd ftp01                           # 设置FTP登录密码
# userdel -r ftp01                       # 删除用户+家目录

# 修正家目录权限（chroot强制要求父目录不可写）
# chmod 755 /home/ftp01
# mkdir /home/ftp01/upload
# chmod 775 /home/ftp01/upload
# chown ftp01:ftp01 /home/ftp01/upload

## 3.2 双层权限管控架构
# 第一层：全局总控制（vsftpd.conf write_enable）
# 全局开启write_enable=YES：所有本地用户均可上传下载
# 全局关闭write_enable=NO：所有用户默认只读，需单独配置开启上传

# 第二层：单用户独立差异化权限（user_config_dir）
# 示例：仅ftp01允许上传，其他用户只读
# echo "write_enable=YES" > /etc/vsftpd/user_config_dir/ftp01
# chmod 644 /etc/vsftpd/user_config_dir/ftp01
# chown root:root /etc/vsftpd/user_config_dir/ftp01

## 3.3 登录黑白名单控制
# userlist_enable=YES
# userlist_file=/etc/vsftpd/user_list
# userlist_deny=NO  # 白名单：仅文件内用户可登录FTP
# userlist_deny=YES # 黑名单：文件内用户禁止登录FTP
# echo "ftp01" >> /etc/vsftpd/user_list

###########################################################################
# 模块4：客户端三种访问方式（临时连接 + 永久挂载 + Windows访问）
###########################################################################
## 4.1 Linux临时交互式ftp客户端
# yum install ftp / apt install ftp
# ftp 192.168.1.100  # 输入用户名、密码
# 常用交互命令：ls get put cd mkdir delete bye

## 4.2 Linux永久挂载FTP（curlftpfs，开机自动挂载）
# 安装工具
# yum install curlftpfs / apt install curlftpfs
# 临时挂载
# mkdir /mnt/ftp_mount
# curlftpfs ftp01:密码@192.168.1.100 /mnt/ftp_mount
# 永久开机挂载写入/etc/fstab
# echo "curlftpfs#ftp01:密码@192.168.1.100 /mnt/ftp_mount fuse allow_other,uid=1000,gid=1000 0 0" >> /etc/fstab
# mount -a

## 4.3 Windows客户端访问
# 方式1：资源管理器地址栏输入 ftp://192.168.1.100 输入账号密码
# 方式2：此电脑-右键添加网络位置，输入FTP地址，保存凭证永久访问
# 方式3：FileZilla图形客户端（推荐，被动模式自动适配）

###########################################################################
# 模块5：专属安全隔离功能（vsftpd核心安全特性）
###########################################################################
# 5.1 chroot_local_user 目录禁锢（核心隔离）
# 限制用户仅能访问自身/home/xxx，无法进入/ /etc /root等系统目录
# 约束：家目录权限不能777/770，必须755，否则登录直接失败

# 5.2 禁止匿名用户、关闭匿名上传，杜绝公开访问风险
anonymous_enable=NO

# 5.3 单用户独立权限隔离，不同用户读写权限分离
user_config_dir=/etc/vsftpd/user_config_dir

# 5.4 黑白名单账号隔离，限制高危账号登录FTP（root禁止登录）
# echo "root" >> /etc/vsftpd/user_list

# 5.5 被动端口区间限制，缩小防火墙开放端口范围，减少攻击面
pasv_min_port=40000
pasv_max_port=50000

# 5.6 日志全量记录上传下载行为，审计追溯文件操作
xferlog_enable=YES

# 5.7 FTP用户禁止SSH登录，降低账号泄露后服务器入侵风险
useradd -s /sbin/nologin ftpuser

###########################################################################
# 模块6：标准化故障排查完整流程（自上而下排查）
###########################################################################
## 步骤1：检查vsftpd服务状态
# systemctl status vsftpd
# 异常：systemctl restart vsftpd && 查看journalctl -u vsftpd

## 步骤2：校验配置文件语法
# vsftpd /etc/vsftpd/vsftpd.conf

## 步骤3：防火墙端口连通性测试
# telnet 192.168.1.100 21
# nc -zv 192.168.1.100 40000-50000

## 步骤4：账号与家目录权限排查（chroot登录失败最高发问题）
# ls -ld /home/ftp01
# 权限包含w权限执行 chmod 755 /home/ftp01
# 检查目录属主：chown ftp01:ftp01 /home/ftp01/upload

## 步骤5：登录日志排查，定位认证/权限报错
# tail -f /var/log/vsftpd.log
# journalctl -u vsftpd -f

## 步骤6：客户端模式排查（主动/被动模式报错）
# FileZilla客户端强制切换被动PASV模式重试

## 步骤7：权限读写故障排查
# 1. 检查全局write_enable配置
# 2. 检查用户独立配置是否关闭写入权限
# 3. 检查上传目录文件系统权限rwx
```

### MinIO 对象存储

- 私有对象存储部署
- 桶策略、权限、内外网访问
- 文件上传下载、分片存储特性

```md
# MinIO 对象存储 标准化学习文档
# 统一6模块学习架构：1基础认知 2服务端部署 3用户权限管控 4客户端使用 5安全隔离 6故障排查
# 业务场景：私有对象存储、桶策略精细化权限、内外网访问控制、分片上传/分布式存储特性
# 部署模式：单机独立部署（生产可扩展分布式集群）

###########################################################################
# 模块1：基础认知（简介、架构、端口、专业概念、分片存储特性）
###########################################################################
# 1.1 MinIO简介
# MinIO 是一款开源、轻量、兼容标准 S3 协议的分布式对象存储服务端程序
# 开发定位：专为私有环境、企业自建、云原生场景打造，兼容 AWS S3 全部主流API
# 核心用途：存储图片、视频、日志、备份、静态资源、大数据文件等海量非结构化数据
# https://www.minio.org.cn/

# 1.2 架构模型
# C/S架构：服务端MinIO Server + 客户端mc/mc-admin/SDK/浏览器控制台
# 存储单元层级：磁盘(驱动) → 存储池(erasure code纠删码) → Bucket(桶) → Object(对象/文件)
# 核心特性：分片存储、纠删码、对象版本、临时预签名、桶策略、IAM子账号

# 1.3 默认端口
# 9000：S3 API端口（程序上传下载、mc客户端交互）
# 9001：Web管理控制台端口（可视化管理桶/文件/权限）

# 1.4 核心专业概念
# Bucket桶：顶层隔离容器，等同于FTP根目录，全局唯一名称
# Object对象：存储的单个文件，支持分片、元数据、版本
# Erasure Code纠删码：分布式分片存储核心，多盘分片冗余，坏盘不丢数据
# 分片上传Multipart：大文件自动切分多块并行上传，断点续传，合并后完整对象
# IAM子账号：独立访问密钥AK/SK，精细化读写权限，区分管理员与业务账号
# 桶策略Bucket Policy：JSON权限规则，控制匿名/内网/外网访问、读写操作
# 预签名URL：临时带时效访问链接，无需密钥即可下载/上传文件
# 内外网分离：内网API直连，外网仅开放控制台/限制IP访问

# 1.5 分片存储特性重点
# 1. 文件自动分片：默认5MB分片阈值，大文件切割多part并行上传，提速
# 2. 断点续传：上传中断可续传已上传分片，无需重传全部文件
# 3. 分布式分片均衡：多磁盘自动打散分片，负载均衡
# 4. 分片合并：所有分片上传完成后MinIO自动合并为完整对象，前端无感知
# 5. 分片生命周期：可配置自动清理未完成分片垃圾文件，释放磁盘

###########################################################################
# 模块2：服务端标准化部署（私有单机部署流程）
# 安装→启停→防火墙→存储目录→环境变量配置→校验生效
###########################################################################
## 2.1 二进制安装（全Linux通用，推荐）
# wget https://dl.min.io/server/minio/release/linux-amd64/minio
# wget https://dl.minio.org.cn/server/minio/release/linux-amd64/minio
# chmod +x minio
# mv minio /usr/local/bin/

## 2.2 标准化存储目录规划（私有存储数据分离）
# mkdir -p /data/minio/storage        # 对象持久化存储目录
# mkdir -p /data/minio/logs           # 运行日志目录
# mkdir -p /etc/minio                 # 环境变量配置目录

## 2.3 私有部署核心环境变量（关闭匿名、设置管理员密钥）
cat > /etc/minio/env <<EOF
# 管理员账号密钥（私有存储禁止弱密钥）
MINIO_ROOT_USER=admin
MINIO_ROOT_PASSWORD=Admin@123456
# 监听地址：0.0.0.0允许内外网访问，可限定内网IP 192.168.1.100
MINIO_ADDRESS=0.0.0.0:9000
MINIO_CONSOLE_ADDRESS=0.0.0.0:9001
# 日志输出
MINIO_LOG_DIR=/data/minio/logs
# 关闭公开匿名访问（私有存储强制开启）
MINIO_BROWSER_REDIRECT_URL=
MINIO_PROMETHEUS_AUTH_TYPE=public
EOF

## 2.4 Systemd系统服务托管（标准化启停）
cat > /etc/systemd/system/minio.service <<EOF
[Unit]
Description=MinIO Private Object Storage
After=network.target

[Service]
EnvironmentFile=/etc/minio/env
ExecStart=/usr/local/bin/minio server /data/minio/storage
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

## 2.5 服务管理命令
# systemctl daemon-reload
# systemctl enable --now minio     # 开机自启+启动
# systemctl stop minio
# systemctl restart minio
# systemctl status minio
# journalctl -u minio -f           # 实时运行日志

## 2.6 防火墙放行端口（内外网分离控制）
# CentOS firewalld
# firewall-cmd --permanent --add-port=9000/tcp
# firewall-cmd --permanent --add-port=9001/tcp
# firewall-cmd --reload
# # 仅内网访问：限制来源IP
# firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.0.0/16" port protocol="tcp" port="9000" accept'

# Ubuntu ufw
# ufw allow from 192.168.0.0/16 to any port 9000,9001 proto tcp

## 2.7 部署校验
# curl http://127.0.0.1:9000/minio/health/live  # 健康检测
# 访问控制台 http://服务器IP:9001 登录管理员账号

###########################################################################
# 模块3：用户权限管控（IAM子账号 + 桶策略 + 内外网访问控制）
###########################################################################
# 前置：安装mc客户端用于命令行权限管理
# wget https://dl.min.io/client/mc/release/linux-amd64/mc
# wget https://dl.min.org.cn/client/mc/release/linux-amd64/mc
curl https://dl.minio.org.cn/client/mc/release/linux-amd64/mc \
  --create-dirs \
  -o $HOME/minio-binaries/mc
# chmod +x mc && mv mc /usr/local/bin/
# mc alias set minio http://127.0.0.1:9000 admin Admin@123456
# mc admin info minio 

## 3.1 IAM子账号管理（双层权限第一层：账号读写权限）
# 创建只读子账号
# mc admin user add minio user-read UserRead@666
# mc admin policy attach minio readonly --user user-read

# 创建仅上传子账号
# mc admin user add minio user-write UserWrite@666
# mc admin policy attach minio writeonly --user=user-write


# 自定义细粒度策略文件示例 bucket-only-write.json
cat > bucket-only-write.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::private-bucket/*",
        "arn:aws:s3:::private-bucket"
      ]
    }
  ]
}
EOF
# mc admin policy create minio bucket-write bucket-only-write.json
# mc admin policy set minio bucket-write user=user-bucket

## 3.2 桶策略 Bucket Policy（双层权限第二层：桶访问控制，管控内外网）
# 场景1：完全私有，禁止任何匿名内外网访问（私有存储默认）
cat > private-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": {"AWS": "*"},
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::data-bucket/*",
      "Condition": {
        "Bool": {"aws:SecureTransport": false}
      }
    }
  ]
}
EOF
# mc policy set-json minio/data-bucket private-policy.json

# 场景2：仅内网IP允许匿名下载，外网拒绝
cat > intranet-only.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"AWS": "*"},
      "Action": ["s3:GetObject"],
      "Resource": "arn:aws:s3:::public-data/*",
      "Condition": {
        "IpAddress": {"aws:SourceIp": "192.168.0.0/16"}
      }
    }
  ]
}
EOF

# 场景3：外网仅允许预签名URL访问，禁止直接匿名浏览
# 策略中拒绝所有外网直接s3:GetObject，仅允许带签名临时链接

# 桶策略生效命令
# mc policy set-json minio/桶名 策略文件.json
# mc policy get-json minio/桶名  # 查看当前桶策略

## 3.3 内外网访问隔离方案
# 1. 端口监听限制：MINIO_ADDRESS=192.168.1.100:9000 仅内网网卡监听
# 2. 防火墙IP白名单：仅内网段放行9000/9001，外网屏蔽
# 3. 桶策略IP条件：通过SourceIp限制仅内网IP操作对象
# 4. 外网业务仅使用时效预签名URL分发文件，不开放永久匿名权限

###########################################################################
# 模块4：客户端使用（命令行临时操作、永久挂载、Windows访问、分片上传）
###########################################################################
## 4.1 mc客户端临时上传下载、分片自动处理
# 新建桶
# mc mb minio/file-bucket
# 本地文件上传（自动分片，大文件断点续传）
# mc cp /data/test.iso minio/file-bucket/
# 下载对象到本地
# mc cp minio/file-bucket/test.iso /tmp/
# 列出桶内文件
# mc ls minio/file-bucket
# 生成1小时时效外网预签名下载链接
# mc share download --expire 1h minio/file-bucket/test.iso

## 4.2 Linux永久挂载MinIO（s3fs-fuse）
# yum install s3fs-fuse / apt install s3fs
# 写入AK/SK凭证
# echo "admin:Admin@123456" > /etc/passwd-s3fs
# chmod 600 /etc/passwd-s3fs
# 临时挂载桶到本地目录
# mkdir /mnt/minio-bucket
# s3fs file-bucket /mnt/minio-bucket -o url=http://127.0.0.1:9000
# fstab永久开机挂载写入
# file-bucket /mnt/minio-bucket fuse.s3fs _netdev,url=http://127.0.0.1:9000 0 0

## 4.3 Windows客户端访问
# 1. 浏览器控制台：http://服务器IP:9001，管理员/子账号登录可视化管理
# 2. 工具：WinSCP、Rclone、MinIO Browser，填写S3 Endpoint、AK/SK连接
# 3. 业务程序：Java/Python/Go SDK对接9000端口S3 API自动分片上传

## 4.4 分片上传手动控制（超大文件场景）
# mc cp --multipart-chunk-size 10M /data/large.tar minio/bucket/
# --multipart-chunk-size 指定分片大小，默认5MB
# 查看未完成分片任务
# mc ls minio/bucket --versions --recursive
# 清理过期未上传完成分片
# mc admin clean incomplete-uploads minio

###########################################################################
# 模块5：专属安全隔离功能（MinIO私有存储核心隔离能力）
###########################################################################
# 5.1 桶级资源隔离：不同业务分桶存储，桶策略互相隔离数据
# 5.2 IAM账号隔离：子账号独立AK/SK，权限最小化，无全局管理员权限
# 5.3 IP访问隔离：桶策略+防火墙双层限制内外网访问来源
# 5.4 传输加密：强制HTTPS，拒绝HTTP明文传输，关闭非加密访问
# 5.5 分片数据隔离：分片文件底层独立存储，未合并无法读取完整对象
# 5.6 时效访问隔离：预签名URL设置过期时间，外网临时访问限时可控
# 5.7 存储纠删隔离：分布式多盘分片冗余，单盘故障不泄露/丢失文件
# 5.8 匿名访问隔离：默认私有桶，必须手动配置桶策略才开放任何匿名权限

###########################################################################
# 模块6：标准化故障排查流程（固定顺序定位问题）
###########################################################################
## 步骤1：检查MinIO服务运行状态
# systemctl status minio
# journalctl -u minio -f 实时查看启动崩溃、权限报错

## 步骤2：端口连通性检测（内外网不通优先排查）
# telnet 服务器IP 9000
# curl http://IP:9000/minio/health/live 健康接口验证
# 内网能通外网不通：检查防火墙IP白名单、监听地址是否绑定0.0.0.0

## 步骤3：存储目录权限校验（启动失败高发）
# ls -ld /data/minio/storage
# chown -R root:root /data/minio/ && chmod 700 /data/minio/storage

## 步骤4：AK/SK账号与IAM权限排查
# mc admin user list minio
# mc admin policy info minio 策略名
# 上传403无权限：核对子账号绑定策略、桶策略是否允许PutObject

## 步骤5：桶策略访问异常（内外网访问拒绝）
# mc policy get-json minio/桶名
# 匿名无法下载：检查Statement是否允许s3:GetObject、IP条件是否匹配客户端地址

## 步骤6：分片上传失败排查
# 查看未完成分片 mc ls minio/桶 --incomplete
# 磁盘满导致分片写入失败：df -h /data/minio
# 分片超时：调整客户端超时参数，增大分片chunk大小

## 步骤7：Web控制台无法登录
# 核对MINIO_ROOT_USER/ROOT_PASSWORD环境变量
# 确认9001端口防火墙放行、无安全组拦截
```

---

# 四、企业基础网络服务（集群必备底层服务）

## 1. NTP 时间同步

- chrony 生产部署
- 阿里时间源同步
- 集群所有机器时间统一（日志 / 数据库 / 集群刚需）

```md
# NTP时间同步-Chrony标准化部署（遵循6模块学习架构）
# 业务需求：阿里公共时间源、服务器集群统一时间、日志/数据库/集群强依赖时间一致性
# 系统适配：CentOS7/8/9、Rocky、Ubuntu20.04+

###########################################################################
# 模块1：基础认知（简介、架构、端口、专业概念）
###########################################################################
# 1.1 简介
# NTP：网络时间协议，用于多服务器时间对齐；传统ntpd性能差，生产推荐chrony
# Chrony：轻量高精度时间同步工具，同步速度快、断网可维持本地时钟、适配虚拟机/云主机
# 集群时间统一刚需：日志时序排查、MySQL主从GTID、Kafka/Redis集群、Ansible批量任务、证书时效校验

# 1.2 架构角色
# chronyd：后台守护进程，持续同步时间、校正本地时钟漂移
# chronyc：命令行客户端，查询同步状态、手动触发同步
# 时间层级：本地服务器 → 阿里公共NTP源 → 标准UTC时间

# 1.3 端口说明
# 客户端向外同步：UDP 123（出站，无需放行入站）
# 若本机作为内网NTP服务端：UDP 123入站开放

# 1.4 核心术语
# stratum层级：时间源层级，阿里ntp为stratum2，本地机器stratum3
# driftfile：记录硬件时钟漂移，重启后快速恢复时间精度
# makestep：初次同步偏差过大时直接跳变时间，避免缓慢微调
# allow：内网网段，配置本机作为集群内部时间服务器

###########################################################################
# 模块2：服务端标准化部署（安装→启停→防火墙→配置→校验生效）
###########################################################################
## 2.1 安装chrony
# CentOS/RHEL
yum install -y chrony
# Ubuntu/Debian
apt update && apt install -y chrony

## 2.2 标准化配置文件 /etc/chrony.conf
# 备份原配置
cp /etc/chrony.conf /etc/chrony.conf.bak.$(date +%Y%m%d)
# 覆盖阿里时间源标准配置
cat > /etc/chrony.conf <<EOF
# 使用阿里公共NTP时间源
server ntp.aliyun.com iburst
server ntp2.aliyun.com iburst
server ntp3.aliyun.com iburst
server ntp4.aliyun.com iburst

# 记录时钟漂移文件
driftfile /var/lib/chrony/drift
# 前三次同步时差超过10秒直接跳变校准
makestep 10 3
# 启用硬件时钟同步
rtcsync
# 允许内网网段访问本机时间服务（集群机器可指向本机）
allow 192.168.0.0/16
# 本地时钟兜底，外网不通时维持时间
local stratum 10
# 日志路径
logdir /var/log/chrony
EOF

## 2.3 服务启停、开机自启
systemctl enable --now chronyd
systemctl stop chronyd
systemctl restart chronyd
systemctl status chronyd

## 2.4 防火墙（仅本机做内网时间服务器才需要放行123/UDP）
# firewalld
firewall-cmd --permanent --add-port=123/udp
firewall-cmd --reload
# ufw
ufw allow 123/udp

## 2.5 配置生效校验
chronyc sources         # 查看当前连接的时间源
chronyc tracking        # 查看时间偏移、同步精度
timedatectl             # 系统时间、时区总览

###########################################################################
# 模块3：用户/集群权限管控（集群分层时间架构）
###########################################################################
## 方案A：所有机器直连阿里NTP（小规模集群，10台以内）
# 所有服务器统一使用上面/etc/chrony.conf，直接同步阿里云公网源

## 方案B：集群分层同步（大规模生产集群，推荐）
# 1. 选1台中控机（ansible主机）同步阿里ntp，作为内网时间服务器
# 2. 其余业务机器同步中控机内网IP，减少公网请求
# 业务机配置替换server行：
# server 192.168.1.10 iburst

## 时区统一（全集群必须一致，推荐Asia/Shanghai）
timedatectl set-timezone Asia/Shanghai
# 写入硬件时钟
hwclock -w

###########################################################################
# 模块4：客户端使用（chronyc交互式工具、批量校验、Windows同步）
###########################################################################
## 4.1 Linux本地chronyc交互操作
chronyc                 # 进入交互终端
sources                 # 查看时间源
tracking                # 偏移量
synchronize             # 手动强制同步一次
quit                    # 退出

## 4.2 Ansible批量集群校验时间（集群统一巡检）
# ansible all -m shell -a "chronyc tracking | grep System     time"

## 4.3 Windows客户端同步阿里NTP
# 设置Internet时间服务器：ntp.aliyun.com
# cmd手动同步：w32tm /resync

###########################################################################
# 模块5：专属安全隔离&集群一致性保障功能
###########################################################################
# 5.1 iburst参数：开机快速并发同步，快速对齐集群时间
# 5.2 makestep：新装机时差巨大时直接校准，避免缓慢微调导致集群时间断层
# 5.3 driftfile：长期维持高精度，多次重启无大幅偏移
# 5.4 local stratum：断外网环境，集群内部仍可保持时间统一
# 5.5 allow网段限制：仅内网机器可从本机获取时间，拒绝外网请求
# 5.6 rtcsync：定期同步系统时间到硬件RTC时钟，断电不跑偏

###########################################################################
# 模块6：标准化故障排查流程
###########################################################################
## 步骤1：检查chronyd服务运行状态
systemctl status chronyd
journalctl -u chronyd -f

## 步骤2：检查时间源连通性（UDP 123出站）
# 测试阿里ntp连通
chronyc sources
# 无*标记代表同步失败，检查安全组/防火墙出站UDP123

## 步骤3：时区不一致问题
timedatectl
# 非Asia/Shanghai执行：timedatectl set-timezone Asia/Shanghai

## 步骤4：集群机器时间偏移过大
chronyc tracking
# System time     : X seconds fast/slow：偏移超1秒需重新同步
chronyc -a makestep

## 步骤5：内网机器无法同步中控时间服务器
# 检查中控机防火墙UDP123放行、chrony.conf allow网段匹配内网
# 业务机server IP填写正确，无拦截策略

## 步骤6：硬件时钟丢失
hwclock --show
hwclock -w
```

## 2. Rsync + Inotify 实时备份

- rsync 增量同步、参数详解
- 无差异同步、删除冗余、权限同步
- inotifywait 实时监控脚本
- 生产实时备份架构、异地容灾

```md
# Rsync+Inotify 实时文件备份标准化学习文档
# 严格6模块架构：1基础认知 2服务端部署 3权限管控 4客户端/脚本使用 5安全隔离 6故障排查
# 业务场景：本地实时增量备份、异地机房容灾、无差异镜像、自动清理冗余文件、完整权限同步

###########################################################################
# 模块1：基础认知（简介、架构、端口、专业概念）
###########################################################################
# 1.1 Rsync 简介
# rsync：远程增量同步工具，核心算法只传输文件差异块，相比scp/ftp节省带宽
# 三大工作模式：本地同步、ssh远程同步、rsync daemon服务端同步
# 核心特性：增量传输、保留文件权限属主、删除源端不存在文件、断点续传、压缩传输

# 1.2 Inotify 简介
# Linux内核文件事件监控机制，inotifywait为用户态工具；监控目录新增/修改/删除/移动事件
# 触发机制：文件发生变动后立刻执行rsync同步，实现秒级实时备份

# 1.3 整体备份架构
# 生产两层架构：
# 第一层：本地实时同步（本机磁盘多目录镜像）
# 第二层：异地远程实时同步（ssh/rsyncd跨机房容灾备份）
# 数据流：业务目录变更 → inotify捕获事件 → 调用rsync增量同步至备份端

# 1.4 端口与通信
# rsync over ssh：复用SSH 22端口（推荐生产，加密传输）
# rsync daemon模式：独立TCP 873端口（内网无加密，仅隔离内网使用）

# 1.5 核心专业术语
# 增量同步：仅传输修改部分，不重复全量文件
# 无差异镜像 --delete：目标目录完全和源对齐，删除目标多余冗余文件
# 权限同步：属主、属组、rwx权限、时间戳完整保留
# inotify事件：create/modify/attrib/close_write/move/delete
# 异地容灾：跨服务器/机房实时备份，单点故障不丢失数据

###########################################################################
# 模块2：服务端标准化部署（安装→防火墙→目录规划→基础同步测试）
###########################################################################
## 2.1 软件安装
# CentOS/RHEL
yum install -y rsync inotify-tools
# Ubuntu/Debian
apt update && apt install -y rsync inotify-tools

## 2.2 标准化目录规划
# 业务源目录（待监控）
SOURCE_DIR=/data/business
# 本地一级备份目录
LOCAL_BACKUP=/data/backup_local
# 异地远端备份路径（远端服务器）
REMOTE_USER=backup
REMOTE_IP=192.168.2.100
REMOTE_DIR=/data/remote_backup

# 创建目录
mkdir -p $SOURCE_DIR $LOCAL_BACKUP

## 2.3 防火墙配置（ssh模式仅开放22；daemon模式放行873）
# ssh模式无需额外端口，仅保障22端口互通
# daemon模式放行873（内网专用）
# firewall-cmd --permanent --add-port=873/tcp
# firewall-cmd --reload

## 2.4 Rsync核心参数详解（生产标准组合）
# 标准全量同步参数组合
# -a 归档模式 = -rlptgoD 递归+权限+时间+属主属组+设备文件
# -r 递归遍历子目录
# -l 保留软链接
# -p 保留文件权限
# -t 保留文件修改时间
# -g 保留属组
# -o 保留属主
# -D 保留设备/特殊文件
# --delete 无差异同步：删除目标端源不存在的冗余文件
# --exclude 排除不需要同步的目录/文件
# --compress 传输过程压缩，节省带宽
# --progress 打印同步进度（调试用，生产脚本可删除）
# --bwlimit 限制传输带宽，避免占满业务磁盘IO
# --chmod 统一同步后文件权限
# --chown 强制统一属主属组

## 2.5 基础本地同步测试（无差异镜像+权限同步）
rsync -a --delete --compress $SOURCE_DIR/ $LOCAL_BACKUP/
# 远程ssh同步测试
rsync -a --delete --compress $SOURCE_DIR/ $REMOTE_USER@$REMOTE_IP:$REMOTE_DIR/

###########################################################################
# 模块3：用户权限管控（同步账号、免密ssh、目录最小权限）
###########################################################################
## 3.1 专用备份账号（禁止登录ssh，最小权限）
useradd -m -s /sbin/nologin backup
# 赋予源目录读取权限、备份目录写入权限
chown -R backup:backup $SOURCE_DIR $LOCAL_BACKUP

## 3.2 异地免密SSH密钥（实时脚本自动化必备，无需手动输密码）
# 本地生成密钥
su - backup -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
# 推送公钥至异地备份服务器
su - backup -c "ssh-copy-id $REMOTE_USER@$REMOTE_IP"

## 3.3 权限管控规范
# 源目录：700，仅备份账号可读
# 备份目录：700，仅备份账号可读写
# 禁止777宽松权限，防止文件篡改泄露

## 3.4 黑白名单过滤同步文件
# --exclude '*.tmp' 排除临时文件
# --exclude 'logs/' 排除日志目录
# --include '*.jpg' 仅同步图片文件

###########################################################################
# 模块4：客户端/脚本使用（inotify实时监控脚本、开机自启、异地同步）
###########################################################################
## 4.1 生产级inotifywait实时备份脚本 /usr/local/bin/inotify_rsync.sh
cat > /usr/local/bin/inotify_rsync.sh <<'EOF'
#!/bin/bash
# 实时监控rsync同步脚本
SOURCE="/data/business"
LOCAL_BACK="/data/backup_local"
REMOTE_USER="backup"
REMOTE_IP="192.168.2.100"
REMOTE_PATH="/data/remote_backup"

# inotify监控事件：创建/修改/属性变更/写入完成/移动/删除
inotifywait -mrq --timefmt '%Y-%m-%d %H:%M:%S' --format '%T %w%f %e' \
-e create,modify,attrib,close_write,move,delete $SOURCE | while read line
do
    echo "检测文件变更：$line"
    # 1.本地实时无差异同步
    rsync -a --delete --compress $SOURCE/ $LOCAL_BACK/
    # 2.异地容灾实时同步
    rsync -a --delete --compress $SOURCE/ $REMOTE_USER@$REMOTE_IP:$REMOTE_PATH/
done
EOF

# 赋予脚本执行权限
chmod +x /usr/local/bin/inotify_rsync.sh

## 4.2 Systemd托管脚本，开机自启后台运行
cat > /etc/systemd/system/inotify-rsync.service <<EOF
[Unit]
Description=Inotify Real-Time Rsync Backup Service
After=network.target

[Service]
User=backup
ExecStart=/usr/local/bin/inotify_rsync.sh
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# 加载并启动服务
systemctl daemon-reload
systemctl enable --now inotify-rsync
systemctl status inotify-rsync

## 4.3 手动执行单次同步、定时兜底备份（补充实时脚本遗漏）
# 手动同步
/usr/local/bin/inotify_rsync.sh
# crontab每小时一次全量兜底，防止inotify漏事件
echo "0 * * * * backup rsync -a --delete --compress /data/business/ /data/backup_local/" >> /var/spool/cron/root

###########################################################################
# 模块5：专属安全隔离&容灾功能
###########################################################################
# 5.1 无差异镜像 --delete：目标目录和源完全一致，自动清理冗余垃圾文件
# 5.2 -a归档参数：完整同步权限、属主、时间戳，备份文件可直接恢复使用
# 5.3 inotify内核监控：仅文件变动触发同步，空闲无IO消耗，性能远优于定时rsync
# 5.4 SSH加密远程传输：异地备份数据加密，防止传输窃取
# 5.5 分层备份架构：本地一级备份+异地二级容灾，双重数据保障
# 5.6 专用备份账号隔离：业务进程与备份账号分离，权限最小化
# 5.7 文件过滤机制：exclude排除缓存、临时文件，减少无效同步流量
# 5.8 带宽限速--bwlimit：避免同步占用业务磁盘/网络带宽

###########################################################################
# 模块6：标准化故障排查流程
###########################################################################
## 步骤1：检查实时备份服务状态
systemctl status inotify-rsync
journalctl -u inotify-rsync -f

## 步骤2：inotify监控数量上限报错（文件多触发）
# 查看当前max_user_watches
cat /proc/sys/fs/inotify/max_user_watches
# 永久调大内核参数
echo "fs.inotify.max_user_watches=1048576" >> /etc/sysctl.conf
sysctl -p

## 步骤3：rsync同步失败、权限丢失
# 核对-a完整参数是否携带，源/备份目录属主是否为backup
ls -ld $SOURCE_DIR

## 步骤4：异地同步卡住/超时
# 测试免密ssh连通：ssh backup@192.168.2.100
# 检查防火墙22端口、异地磁盘空间df -h

## 步骤5：目标目录残留冗余文件（--delete失效）
# 源目录路径末尾必须带 / 如 /data/business/，否则同步目录本身而非内部文件

## 步骤6：文件变更无同步触发
# 手动执行inotifywait测试是否捕获事件
inotifywait -m /data/business
# 检查脚本用户backup是否拥有目录读取权限

## 步骤7：同步占用过高带宽
# rsync增加--bwlimit 10000 参数限制10MB/s带宽



# 核心架构总结
1. 实时层：inotify 内核监控文件变动，秒级触发同步
2. 同步层：rsync 增量传输，--delete 实现完全镜像，完整保留文件权限
3. 容灾层：本地备份 + 异地 ssh 加密备份双重架构
4. 兜底层：定时 crontab 每小时全量同步，弥补 inotify 事件丢失风险
```

## 3. DNS 服务 BIND

- 内网 DNS 服务器搭建
- 正向解析、反向解析
- A 记录、CNAME 记录、泛解析
- 企业内网域名统一解析、解析故障排查

```md
# BIND DNS 内网服务器标准化学习文档
# 统一6模块架构：1基础认知 2服务端部署 3权限/区域管控 4客户端使用 5安全隔离 6标准化故障排查
# 业务需求：企业内网DNS、正向/反向解析、A/CNAME/泛域名解析、统一内网域名、解析排错

###########################################################################
# 模块1：基础认知（简介、架构、端口、专业概念）
###########################################################################
# 1.1 BIND简介
# BIND = Berkeley Internet Name Domain，业界标准DNS服务程序，企业内网首选
# 作用：搭建私有内网DNS，自定义内部域名，无需修改hosts，全服务器统一解析
# 适用场景：内网业务主机、k8s集群、存储、中间件自定义域名访问

# 1.2 DNS架构分层
# 客户端 -> 本地DNS缓存(resolv.conf) -> BIND内网DNS服务器
# BIND分层角色：
# master主服务器：维护区域解析文件，权威数据源
# slave从服务器：同步主服务器区域数据，高可用冗余

# 1.3 端口
# UDP 53：域名查询（主流）
# TCP 53：区域传输、大解析包查询，防火墙需同时放行udp/tcp 53

# 1.4 核心解析概念
# 正向解析：域名 → IP（www.test.local → 192.168.1.10）
# 反向解析：IP → 域名（192.168.1.10 → www.test.local）
# A记录：域名映射IPv4地址
# CNAME：别名记录，域名指向另一个域名
# 泛解析 *.test.local：匹配所有子域名，统一指向同一IP
# SOA记录：区域起始授权记录，定义主从同步、刷新/过期时间
# NS记录：区域域名服务器记录
# PTR记录：反向解析专用记录

###########################################################################
# 模块2：服务端标准化部署（安装→启停→防火墙→配置→区域文件→校验生效）
###########################################################################
## 2.1 安装bind组件
# CentOS/RHEL/Rocky
yum install -y bind bind-chroot bind-utils
# Ubuntu/Debian
apt update && apt install -y bind9 dnsutils

## 2.2 核心目录说明
# /etc/named.conf          主配置文件（监听、访问控制、区域定义）
# /var/named/              区域解析文件存放目录
# /var/named/data/         缓存、运行数据
# /etc/rndc.key            rndc远程控制密钥

## 2.3 防火墙放行53端口
# firewalld
firewall-cmd --permanent --add-port=53/udp
firewall-cmd --permanent --add-port=53/tcp
firewall-cmd --reload
# ufw
ufw allow 53 proto udp
ufw allow 53 proto tcp

## 2.4 主配置 /etc/named.conf 内网标准模板
cp /etc/named.conf /etc/named.conf.bak.$(date +%Y%m%d)
cat > /etc/named.conf <<EOF
options {
    listen-on port 53 { any; };          # 监听所有网卡
    listen-on-v6 port 53 { ::1; };
    directory       "/var/named";
    dump-file       "/var/named/data/cache_dump.db";
    statistics-file "/var/named/data/named_stats.txt";
    memstatistics-file "/var/named/data/named_mem_stats.txt";
    allow-query     { 192.168.0.0/16; }; # 仅内网网段允许查询
    recursion yes;                       # 开启递归，外网域名也能解析
    forwarders {
        223.5.5.5;
        223.6.6.6;
    }; # 公网阿里DNS转发，内网查不到自动转发公网
};

# 内网正向区域 test.local
zone "test.local" IN {
    type master;
    file "named.test.local";
    allow-update { none; };
};

# 反向解析区域 192.168网段
zone "168.192.in-addr.arpa" IN {
    type master;
    file "named.192.168";
    allow-update { none; };
};

include "/etc/rndc.key";
EOF

## 2.5 正向解析区域文件 /var/named/named.test.local（A/CNAME/泛解析）
cat > /var/named/named.test.local <<EOF
\$TTL 86400
@   IN  SOA dns.test.local. admin.test.local. (
        2026071601  ; 版本号，修改解析必须递增
        3600        ; 刷新时间
        1800        ; 重试
        604800      ; 过期
        86400       ; 最小TTL
)
    IN  NS  dns.test.local.

# DNS服务器本机A记录
dns     IN  A   192.168.1.5

# 业务主机A记录
ansible IN  A   192.168.1.10
minio   IN  A   192.168.1.11
ntp     IN  A   192.168.1.12

# CNAME别名
storage IN  CNAME minio.test.local.

# 泛解析 *.test.local 统一指向192.168.1.99
*       IN  A   192.168.1.99
EOF

## 2.6 反向解析区域文件 /var/named/named.192.168
cat > /var/named/named.192.168 <<EOF
\$TTL 86400
@   IN  SOA dns.test.local. admin.test.local. (
        2026071601
        3600
        1800
        604800
        86400
)
    IN  NS  dns.test.local.

# PTR反向记录 格式：最后一段IP IN PTR 域名
5       IN  PTR dns.test.local.
10      IN  PTR ansible.test.local.
11      IN  PTR minio.test.local.
EOF

## 2.7 修正区域文件权限（bind运行用户named）
chown named:named /var/named/named.*
chmod 644 /var/named/named.*

## 2.8 服务启停、配置校验、生效
# 校验主配置语法
named-checkconf /etc/named.conf
# 校验正向区域文件
named-checkzone test.local /var/named/named.test.local
# 校验反向区域文件
named-checkzone 168.192.in-addr.arpa /var/named/named.192.168

# 服务管理
systemctl enable --now named
systemctl restart named
systemctl status named
# 重载配置不中断服务
rndc reload

###########################################################################
# 模块3：用户/访问权限管控（查询白名单、区域传输限制、主从权限）
###########################################################################
## 3.1 查询权限控制（主配置allow-query）
# allow-query { 192.168.0.0/16; }; 仅内网可查询，拒绝外网访问DNS服务

## 3.2 区域传输防泄露（禁止任意主机拉取全部解析记录）
# zone内配置 allow-transfer { none; }; 生产默认关闭
# 搭建从服务器时仅放开从机IP：allow-transfer {192.168.1.6;};

## 3.3 禁止动态更新 allow-update { none; };
# 关闭自动动态更新，所有解析手动修改文件，版本号递增

## 3.4 转发控制
# recursion yes 内网机器可递归查询公网域名
# 如需内网隔离外网：recursion no; 删除forwarders阿里DNS

###########################################################################
# 模块4：客户端使用（Linux配置DNS、解析测试、Windows内网DNS）
###########################################################################
## 4.1 Linux客户端配置DNS指向内网BIND
# 临时修改
echo "nameserver 192.168.1.5" > /etc/resolv.conf
# 永久网卡配置（CentOS nmcli示例）
nmcli connection modify eth0 ipv4.dns 192.168.1.5
nmcli connection up eth0

## 4.2 解析测试工具 nslookup / dig / host
# 正向解析查询A记录
dig ansible.test.local A
nslookup minio.test.local
# 查询CNAME
dig storage.test.local CNAME
# 测试泛解析
dig abc.test.local
# 反向解析IP查域名
dig -x 192.168.1.10
# 测试公网转发
dig www.baidu.com

## 4.3 Windows客户端配置
# 网卡IPv4 DNS手动填写内网DNS服务器IP 192.168.1.5
# cmd测试：nslookup ansible.test.local

## 4.4 rndc远程管理BIND服务
rndc status        # 查看运行状态
rndc reload        # 重载区域解析
rndc flush         # 清空DNS缓存

###########################################################################
# 模块5：专属安全隔离与内网统一解析能力
###########################################################################
# 5.1 网段访问隔离 allow-query：仅企业内网允许查询DNS，屏蔽外网访问
# 5.2 区域传输权限隔离：仅授权从服务器同步区域数据，防止解析泄露
# 5.3 内网域名统一管理：所有服务器共用一套DNS，不用每台修改/etc/hosts
# 5.4 泛解析批量管理：批量子域名统一指向同一IP，无需逐条新增A记录
# 5.5 正向+反向配套解析：运维排查IP对应主机名更便捷
# 5.6 公网转发兜底：内网不存在域名自动转发阿里公共DNS，内外网兼容
# 5.7 主从冗余架构：搭建slave从DNS，单台DNS故障不中断解析服务

###########################################################################
# 模块6：标准化故障排查流程
###########################################################################
## 步骤1：检查named服务运行状态
systemctl status named
journalctl -u named -f

## 步骤2：校验配置与区域文件语法（启动失败最高发）
named-checkconf
named-checkzone test.local /var/named/named.test.local
# 报错：版本号未递增、末尾缺少.、IP格式错误、权限不足

## 步骤3：端口连通性测试（客户端无法解析）
# 服务端本地测试
dig @127.0.0.1 ansible.test.local
# 客户端测53端口连通
telnet 192.168.1.5 53
# 检查防火墙udp/tcp 53是否放行

## 步骤4：客户端解析失效
# 查看客户端resolv.conf nameserver是否指向内网DNS
# 关闭NetworkManager自动覆盖resolv.conf

## 步骤5：新增解析不生效
# 修改区域文件后必须递增SOA版本号
# 执行 rndc reload 重载区域
# 客户端清空本地缓存：systemd-resolve --flush-caches

## 步骤6：反向解析查不出域名
# 核对反向区域PTR记录IP段书写、末尾带.、区域文件名匹配网段

## 步骤7：公网域名无法解析
# 检查主配置forwarders阿里DNS地址、recursion yes开启

## 步骤8：泛解析不生效
# 确认泛解析记录格式 * IN A x.x.x.x，无多余前缀，区域文件重载
```

## 4. DHCP 服务

- 局域网自动分配 IP
- 网关、DNS、租期配置
- 企业内网网络架构维护

```md
# DHCP(dhcpd) 局域网IP分配标准化学习文档
# 固定6模块学习架构：1基础认知 2服务端部署 3权限/地址管控 4客户端使用 5安全隔离 6故障排查
# 业务需求：企业内网自动分配IP、下发网关/DNS/租期、内网网络架构统一维护

###########################################################################
# 模块1：基础认知（简介、架构、端口、专业概念）
###########################################################################
# 1.1 DHCP简介
# DHCP：动态主机配置协议，局域网服务器自动给终端分配IP地址、子网掩码、网关、DNS、租期
# 解决痛点：内网机器不用手动配静态IP，批量设备上线自动获取网络参数，统一管控网段
# 服务程序：dhcpd（ISC DHCP，CentOS/RHEL主流）

# 1.2 工作流程(DORA四步)
# Discover 发现：客户端广播寻找DHCP服务器
# Offer 提供：DHCP服务器广播分配可用IP
# Request 请求：客户端确认选用该IP
# Ack 确认：服务器下发完整网络参数（网关/DNS/租期）

# 1.3 端口
# UDP 67：DHCP服务端监听端口
# UDP 68：客户端随机端口
# 全程广播通信，防火墙需放行UDP67

# 1.4 核心专业术语
# 地址池range：可自动分配的IP区间
# subnet：网段、子网掩码定义
# routers：下发网关地址
# domain-name-servers：下发DNS服务器
# default-lease-time：默认租期(秒)
# max-lease-time：最大租期
# static-host：静态绑定（MAC固定分配指定IP，服务器专用）
# lease文件：/var/lib/dhcpd/dhcpd.leases 记录已分配IP与MAC对应关系
# 广播域：单台DHCP仅管理同一局域网，跨网段需DHCP中继

###########################################################################
# 模块2：服务端标准化部署（安装→网卡配置→防火墙→主配置→校验生效）
###########################################################################
## 2.1 安装DHCP服务
# CentOS/RHEL/Rocky
yum install -y dhcp
# Ubuntu/Debian
apt update && apt install -y isc-dhcp-server

## 2.2 前置：DHCP服务器网卡必须配置静态IP
# 示例网卡eth0，静态内网IP 192.168.1.5/24
nmcli connection modify eth0 ipv4.method manual ipv4.addresses 192.168.1.5/24 ipv4.gateway 192.168.1.1 ipv4.dns 223.5.5.5
nmcli connection up eth0

## 2.3 指定DHCP监听网卡
# CentOS
echo "DHCPDARGS=eth0" >> /etc/sysconfig/dhcpd
# Ubuntu
echo "INTERFACESv4=\"eth0\"" >> /etc/default/isc-dhcp-server

## 2.4 防火墙放行UDP67端口
# firewalld
firewall-cmd --permanent --add-port=67/udp
firewall-cmd --reload
# ufw
ufw allow 67 proto udp

## 2.5 主配置文件 /etc/dhcp/dhcpd.conf 企业内网标准模板
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak.$(date +%Y%m%d)
cat > /etc/dhcp/dhcpd.conf <<EOF
# 全局域名、DNS配置
option domain-name "test.local";
# 下发内网BIND DNS + 阿里公网DNS
option domain-name-servers 192.168.1.5,223.5.5.5,223.6.6.6;

# 默认租期 12小时，最大租期24小时
default-lease-time 43200;
max-lease-time 86400;

# 日志记录
log-facility local7;

# 定义内网网段 192.168.1.0/24
subnet 192.168.1.0 netmask 255.255.255.0 {
    # 自动分配IP地址池
    range dynamic-bootp 192.168.1.100 192.168.1.200;
    # 下发网关
    option routers 192.168.1.1;
    # 子网掩码
    option subnet-mask 255.255.255.0;
    # 广播地址
    option broadcast-address 192.168.1.255;
}

# 静态绑定：服务器MAC固定分配静态IP（业务主机不参与动态池）
host ansible-server {
    hardware ethernet 00:xx:xx:xx:xx:01;
    fixed-address 192.168.1.10;
}
host minio-server {
    hardware ethernet 00:xx:xx:xx:xx:02;
    fixed-address 192.168.1.11;
}
EOF

## 2.6 配置语法校验 + 服务启停
# 校验dhcp配置语法
dhcpd -t -cf /etc/dhcp/dhcpd.conf
# 开机自启+启动
systemctl enable --now dhcpd
systemctl restart dhcpd
systemctl status dhcpd

# 查看IP分配租赁记录
cat /var/lib/dhcpd/dhcpd.leases

###########################################################################
# 模块3：内网地址&权限管控（地址池隔离、静态绑定、网段管控）
###########################################################################
## 3.1 IP地址分层规划（企业标准）
# 1~99：静态服务器（网关、DNS、存储、中间件，全部static-host绑定）
# 100~200：DHCP动态分配终端（PC、开发机、虚拟机）
# 201~254：预留扩展

## 3.2 租期管控规范
# 办公终端：默认12h，最大24h，减少地址长期占用
# 工业设备/摄像头：可延长至72h，避免频繁重获取IP

## 3.3 多网段隔离
# 新增业务网段新增subnet段落，独立range地址池，互不干扰
# 跨网段需交换机开启DHCP中继，否则无法跨网段分配IP

## 3.4 静态绑定管控
# 核心业务服务器全部MAC绑定固定IP，不进入动态地址池，IP永久不变
# 避免IP漂移导致DNS、监控、备份链路失效

## 3.5 DNS统一下发管控
# 所有终端强制获取内网BIND DNS，内网域名统一解析，无需手动配置

###########################################################################
# 模块4：客户端使用（Linux获取IP、释放续租、Windows客户端）
###########################################################################
## 4.1 Linux客户端自动获取IP
# 临时重新获取IP
dhclient eth0
# 释放当前IP
dhclient -r eth0
# 查看网卡获取的网络参数
nmcli connection show eth0

## 4.2 查看客户端获取的DNS/网关
cat /etc/resolv.conf
ip route

## 4.3 Windows客户端操作
# cmd释放IP
ipconfig /release
# 重新获取DHCP分配IP
ipconfig /renew
# 查看完整网络参数
ipconfig /all

## 4.4 查看DHCP服务分配记录
# 实时日志观察终端申请IP
journalctl -u dhcpd -f
# 查看已租赁IP与MAC对应关系
less /var/lib/dhcpd/dhcpd.leases

###########################################################################
# 模块5：专属内网网络架构隔离功能
###########################################################################
# 5.1 地址池分段隔离：服务器静态IP与终端动态IP分段，防止IP冲突
# 5.2 MAC静态绑定：核心设备IP永久固定，保障集群、存储、DNS稳定访问
# 5.3 统一批量下发网络参数：网关、DNS、掩码全局统一，内网架构标准化
# 5.4 租期可控：灵活调整地址释放周期，优化IP地址利用率
# 5.5 租赁记录持久化：完整记录每台设备MAC-IP映射，资产溯源
# 5.6 网段独立管理：多业务子网分开配置，网络故障隔离不扩散

###########################################################################
# 模块6：标准化故障排查流程
###########################################################################
## 步骤1：检查dhcpd服务运行状态
systemctl status dhcpd
journalctl -u dhcpd -f

## 步骤2：配置语法错误（启动失败）
dhcpd -t 校验配置，修正网段、MAC、IP格式错误

## 步骤3：客户端无法获取IP（最常见）
# 1. DHCP服务器网卡是否静态IP，同网段subnet配置匹配
# 2. 防火墙UDP67端口放行
# 3. 交换机是否限制广播、是否跨网段缺少DHCP中继
# 4. 地址池range是否耗尽，查看dhcpd.leases占用情况

## 步骤4：获取IP但无法解析内网域名
# 检查dhcpd.conf内option domain-name-servers 是否填写内网DNS地址

## 步骤5：终端获取IP但无法上网
# 核对option routers网关地址填写正确，网关本身连通外网

## 步骤6：服务器静态绑定失效，获取动态IP
# 核对MAC地址大小写、分隔符；host段落写在对应subnet内部/全局均可
# 重启dhcpd重载配置

## 步骤7：IP地址冲突
# 1. 部分设备手动配置静态IP落在DHCP地址池range区间
# 2. 调整range范围，静态服务器IP移出动态池
# 3. 查看dhcpd.leases定位冲突MAC设备

# 内网网络架构配套联动说明
DHCP + BIND DNS 组合企业标准架构：
1. DHCP 下发内网 DNS 地址，所有终端自动使用私有 DNS 解析内网业务域名
2. 核心服务器 MAC 绑定固定 IP，DNS 内录入对应 A 记录，IP 永久不变
3. 统一网关、网段规划，全网网络参数标准化，降低运维维护成本
```

---

# 最终：中级运维【纯增量无重复】学习路线图（4 周学完）

## 第 1 周：Nginx 全站核心（上岗第一技能）

虚拟主机、反向代理、负载均衡、动静分离、HTTPS、rewrite、限流、调优、日志、排障

## 第 2 周：MySQL 数据库运维

生产部署、多实例、权限、慢查询、索引、binlog、主从复制、XtraBackup 备份、故障恢复

## 第 3 周：Redis + 消息队列

Redis 持久化、内存策略、哨兵高可用；RabbitMQ/Kafka 集群、消息积压排障

## 第 4 周：存储 + 底层网络服务

NFS/Samba/MinIO/FTP + NTP 时间同步 + Rsync 实时备份 + BIND 内网 DNS

# CentOS7 操作系统标准化学习架构

```md
#!/bin/bash
# CentOS7 Linux操作系统 标准化学习6大模块
# 规则：将操作系统视为完整底层软件，严格遵循统一学习结构
# 固定六模块：1基础认知 2服务端部署安装 3用户权限管控 4客户端/工具使用 5安全隔离 6标准化故障排查

###########################################################################
# 模块1：基础认知（系统简介、内核架构、端口、核心专业概念）
###########################################################################
# 1.1 CentOS7简介
# CentOS7：RHEL7开源复刻发行版，企业服务器主流Linux发行版
# 内核版本：3.10.x，系统初始化工具systemd，文件系统XFS默认
# 核心定位：服务器底层操作系统，承载所有中间件、数据库、存储服务

# 1.2 整体分层架构（自底向上）
# 硬件层 → Linux内核 → 系统调用接口 → 系统工具/库 → 应用程序(vsftpd/minio/chrony/dhcp/bind)
# 内核四大核心子系统：进程管理、内存管理、文件系统、网络协议栈

# 1.3 核心端口/通信
# 本地通信：unix socket、管道、信号
# 网络通信：TCP/UDP端口，内核协议栈管理

# 1.4 必学专业概念
# systemd：系统初始化、服务管理、目标单元target
# runlevel：运行级别，CentOS7改用target替代传统runlevel
# 进程PID、PPID、前台/后台进程、守护进程daemon
# 虚拟内存、物理内存、swap交换分区、buffer/cache
# inode、块存储、文件系统权限rwx、软硬链接
# 用户UID/GID、sudo提权、pam认证
# 网络四层模型：网卡、IP、路由、防火墙netfilter/firewalld
# 磁盘分区：MBR/GPT、lvm逻辑卷、挂载点mount

###########################################################################
# 模块2：系统部署安装（安装→初始化→磁盘规划→网络配置→系统校验）
###########################################################################
## 2.1 系统安装方式
# 1. ISO本地光盘装机
# 2. PXE批量无人值守装机（企业批量部署）
# 3. 云主机镜像初始化

## 2.2 标准化磁盘分区规划（生产标准）
# /boot 200M：内核启动文件
# swap 内存1.5倍：内存交换分区
# / 根分区 /data业务数据分区 分离挂载（LVM逻辑卷）

## 2.3 系统初始化配置
# 1. 主机名 hostnamectl set-hostname ansible
# 2. 时区同步 chrony 统一Asia/Shanghai
# 3. 网卡静态IP配置 /etc/sysconfig/network-scripts/ifcfg-eth0
# 4. 关闭SELinux、防火墙策略标准化
# 5. yum本地/阿里源替换，软件仓库配置

## 2.4 系统服务基础管理（systemd）
# systemctl list-unit-files
# systemctl enable/disable/start/stop/restart 服务名
# systemctl get-default multi-user.target 字符界面

## 2.5 系统健康校验
# uname -r 内核版本
# df -h / free -m 磁盘内存
# ip addr 网络状态
# systemctl status 基础服务

###########################################################################
# 模块3：用户&资源权限管控（账号、文件、进程、网络四层权限）
###########################################################################
## 3.1 系统账号管理
# useradd/userdel/usermod 普通业务账号
# passwd 设置密码、/etc/shadow加密存储
# sudoers 权限提权配置，最小权限分配
# /sbin/nologin 禁止账号SSH登录（FTP/备份专用账号）

## 3.2 文件系统权限管控
# chmod/chown/chgrp 基础rwx权限
# umask默认权限掩码
# ACL扩展细粒度权限 setfacl/getfacl
# 特殊权限SUID/SGID/Sticky粘滞位

## 3.3 进程资源权限管控
# ulimit 进程打开文件数、进程数限制
# cgroup 资源隔离（docker底层依赖）
# nice/renice 进程优先级调度

## 3.4 网络访问权限管控
# firewalld 区域zone、端口/IP黑白名单
# iptables/netfilter 底层网络过滤规则

###########################################################################
# 模块4：客户端/系统工具使用（本地操作、远程连接、批量运维）
###########################################################################
## 4.1 本地Shell基础工具
# 文件操作：ls cd cp mv rm mkdir find tar
# 文本处理：vim cat grep sed awk
# 进程管理：ps top htop kill pstree
# 磁盘管理：mount umount fdisk lvresize df du
# 网络工具：ip route ss ping traceroute dig

## 4.2 远程连接客户端
# SSH客户端 ssh/scp/sftp 远程登录传输
# Xshell、SecureCRT Windows远程工具

## 4.3 批量运维工具
# Ansible 批量操作集群多台CentOS7
# rsync 批量文件同步

## 4.4 定时任务调度
# crontab 系统定时任务，兜底备份、日志清理

###########################################################################
# 模块5：操作系统专属安全隔离功能（内核+系统层原生隔离）
###########################################################################
# 5.1 用户账号隔离：普通用户无root权限，sudo精细化授权
# 5.2 文件权限隔离：目录/文件rwx控制，ACL细分多用户访问权限
# 5.3 进程资源隔离：ulimit限制进程资源，cgroup限制CPU/内存
# 5.4 网络流量隔离：firewalld基于IP/端口访问控制
# 5.5 SELinux强制访问控制（内核层安全隔离）
# 5.6 磁盘挂载隔离：独立/data业务分区，根分区故障不影响业务数据
# 5.7 系统服务隔离：每个中间件独立systemd服务，故障互不影响
# 5.8 内核安全参数：sysctl优化网络、防攻击、资源限制

###########################################################################
# 模块6：操作系统标准化故障排查固定流程
###########################################################################
## 步骤1：系统基础状态检查
# uptime 负载、free -m内存、df -h磁盘、ip addr网络

## 步骤2：系统启动故障排查
# journalctl -xb 系统启动日志
# grub引导故障、磁盘分区损坏、fstab挂载失败

## 步骤3：资源瓶颈排查
# CPU高负载：top/htop 定位占用进程
# 内存溢出：free、swap频繁使用、OOM日志
# 磁盘IO阻塞：iostat、iotop
# 磁盘满：df -h、find大文件清理

## 步骤4：网络故障排查
# 网卡状态→IP配置→路由→端口连通→防火墙拦截→DNS解析

## 步骤5：账号权限故障
# 登录失败：/var/log/secure日志、PAM认证、sudo权限
# 文件读写失败：ls -l权限、ACL、SELinux拦截

## 步骤6：服务启动异常
# systemctl status xxx
# journalctl -u xxx -f 实时服务日志
# 端口占用ss -lntp、目录权限不足、配置语法错误

## 步骤7：内核级系统报错
# dmesg 硬件、磁盘、内存、内核崩溃日志
# /var/log/messages 系统全局日志


## 总结：操作系统统一 6 大学习模块（通用，所有 Linux 发行版通用）

1. **基础认知**：发行版介绍、内核分层架构、核心系统概念、进程 / 内存 / 文件 / 网络底层原理
2. **系统部署**：系统安装方式、磁盘标准化分区、初始化配置、软件源、基础服务部署
3. **权限资源管控**：用户账号体系、文件权限、进程资源限制、网络防火墙访问控制
4. **工具客户端使用**：Shell 命令工具、远程 SSH 连接、批量运维工具、定时任务
5. **原生安全隔离**：账号隔离、文件权限隔离、进程资源隔离、网络隔离、SELinux、分区隔离
6. **标准化故障排查**：系统资源瓶颈、启动故障、网络故障、权限故障、服务异常、内核硬件报错
```



# Linux内核核心子系统 + 容器/云原生依赖内核特性（运维必掌握）

```md
#!/bin/bash
# Linux内核核心子系统 + 容器/云原生依赖内核特性（运维必掌握）
# 适配CentOS7 3.10内核，运维视角，区分：四大基础子系统 + 容器底层内核能力 + 其他高频上层依赖特性
###########################################################################
# 一、Linux内核四大基础核心子系统（所有应用底层依赖）
###########################################################################
# 1. 进程管理子系统
# 核心功能：进程创建fork/exec、调度、信号、PID/PPID、上下文切换、进程优先级nice
# 配套IPC进程间通信接口（你提到的）：
# 1) 管道pipe/匿名管道、命名管道FIFO
# 2) 信号Signal
# 3) 共享内存shmget/shmat
# 4) 消息队列msg
# 5) 信号量sem
# 6) Unix Domain Socket（本地套接字，进程本地通信，不走网卡）

# 2. 内存管理子系统
# 虚拟内存、物理内存、页表、swap、buffer/cache、OOM内存回收、大页HugePage

# 3. 文件系统子系统
# VFS虚拟文件系统层（统一ext4/xfs/btrfs/unionfs/overlayfs接口）
# 块设备驱动、inode、挂载mount、权限、软硬链接、磁盘IO调度

# 4. 网络协议栈子系统
# L2链路层、IP层、TCP/UDP、ICMP、Socket套接字API
# 底层netfilter防火墙、conntrack连接跟踪、tc流量控制、端口监听

###########################################################################
# 二、容器核心三大底层内核特性（Docker/K8s必备，运维重中之重）
###########################################################################
# 1. Namespace 资源隔离（实现容器独立视图）
# 7种隔离命名空间，容器全部启用：
# pid：容器内独立PID编号，看不到宿主机进程
# net：独立网络栈、网卡、IP、端口、路由表
# mnt：独立挂载树，容器文件系统隔离
# user：UID/GID映射，容器root不等于宿主机root
# uts：独立主机名、域名
# ipc：独立进程通信队列，容器间IPC隔离
# cgroup：独立cgroup资源视图

# 2. Cgroup 资源限制（限制容器CPU/内存/磁盘IO/网络）
# 各大子系统：
# cpu：CPU使用率、权重、绑定CPU核心
# cpuset：限定容器使用指定物理CPU
# memory：内存上限、swap限制、OOM控制
# blkio：磁盘读写IO带宽限速
# net_cls/net_prio：网络流量分类、优先级
# devices：限制容器读写硬件设备（屏蔽磁盘、usb）
# pids：限制容器最大进程数量

# 3. OverlayFS 联合文件系统（你说的UnionFS升级版，CentOS7 docker默认）
# 分层镜像：只读底层镜像层 + 可写容器层
# 写时复制CoW，节约磁盘空间，镜像复用，容器启动秒级
# 替代老旧AUFS，3.10内核原生支持

###########################################################################
# 三、运维必须掌握、上层业务/容器中间件高频调用的其他内核特性
###########################################################################
## 3.1 Capabilities 内核能力（容器权限精细化管控）
# 传统root全能权限拆分数十个细粒度能力
# 容器默认删除高危cap：CAP_SYS_ADMIN/CAP_SYS_MODULE等
# 用途：防止容器逃逸、最小权限运行容器，docker run --cap-add/--cap-drop

## 3.2 Seccomp 安全计算模式（系统调用过滤）
# 拦截容器内危险系统调用（挂载、修改内核、加载内核模块）
# K8s/docker默认内置seccomp策略，加固容器安全，防止提权逃逸

## 3.3 SELinux / AppArmor 内核强制访问控制MAC
# CentOS默认SELinux，内核安全模块，控制进程对文件/端口/设备访问权限
# 容器、Nginx、vsftpd大量依赖，运维排错高频遇到权限拦截

## 3.4 内核模块与设备驱动
# 加载网卡、磁盘、虚拟化驱动kvm、overlay、iptables/netfilter模块
# lsmod、modprobe管理，云主机、虚拟化必备

## 3.5 KVM 内核虚拟化模块（虚拟机底层）
# 内核内置虚拟化，OpenStack、VMware、Proxmox底层依赖
# 运维区分：容器（namespace+cgroup）是进程隔离；KVM是硬件级虚拟机隔离

## 3.6 epoll IO多路复用（高并发中间件底层）
# Nginx、Redis、MySQL、MinIO底层高并发网络模型
# 替代select/poll，百万并发连接，运维调优文件句柄数ulimit依赖此特性

## 3.7 inotify 文件事件监控（rsync+inotify实时备份底层）
# 内核监控文件增删改事件，无需轮询磁盘，实时同步工具底层依赖

## 3.8 大页HugePage（数据库、Redis、高性能存储必备）
# 减少内存页表开销，提升数据库读写性能，生产MySQL/Redis标准优化

## 3.9 tc 流量控制（内核网络QoS）
# 限制网卡上传下载带宽、流量整形，容器、网关限速底层依赖netfilter

## 3.10 conntrack 连接跟踪（iptables/firewalld/容器端口转发）
# 内核记录TCP/UDP连接状态，DNAT/SNAT、端口映射、防火墙状态放行依赖

## 3.11 tmpfs 内存文件系统
# 基于内存的临时文件系统，容器/tmp、Redis缓存、日志临时目录广泛使用

## 3.12 coredump 内核转储
# 程序崩溃保存内存堆栈，排查Java/Go/数据库崩溃故障运维必备

## 3.13 软中断irqbalance 内核中断均衡
# 网卡、磁盘硬件中断分散到多核CPU，高并发服务器性能优化

###########################################################################
# 四、分层总结：上层应用分别依赖哪些内核能力（运维记忆）
###########################################################################
# 1. Docker / K8s 容器：Namespace + Cgroup + OverlayFS + Capabilities + Seccomp
# 2. Nginx/Redis/MinIO高并发：epoll、socket、HugePage、tmpfs
# 3. 实时备份Rsync-Inotify：inotify
# 4. 防火墙/网关：Netfilter(iptables)、conntrack、tc流量控制
# 5. MySQL数据库：HugePage、OOM内存管理、IO调度、cgroup资源限制
# 6. 虚拟机平台：KVM内核虚拟化模块
# 7. 安全加固：SELinux、Capabilities、Seccomp
# 8. 进程通信业务：IPC全套（管道、共享内存、Unix Socket）

###########################################################################
# 五、运维学习优先级（从高到低）
###########################################################################
# 1. 必精通（日常天天接触）
# Namespace、Cgroup、OverlayFS、Capabilities、epoll、netfilter、inotify、SELinux
# 2. 生产优化常用（调优、性能故障）
# HugePage、tc流量控制、conntrack、irq均衡、ulimit资源限制
# 3. 进阶虚拟化/云平台（私有云、OpenStack）
# KVM、Seccomp、coredump、内核模块管理
# 4. 底层深度（性能攻坚、内核崩溃排查）
# IPC全套、内存OOM机制、IO调度、内核参数sysctl


# 精简问答总结
## 1. Linux 内核四大基础子系统
进程管理（含全套 IPC 通信）、内存管理、VFS 文件系统、TCP/IP 网络协议栈
## 2. 容器三大基石
Namespace（隔离视图）、Cgroup（限制资源）、OverlayFS（分层镜像存储）
## 3. 运维必须掌握的额外内核特性
Capabilities 细粒度权限、Seccomp 系统调用拦截、SELinux 强制访问控制、epoll 高并发 IO、inotify 文件监控、KVM 虚拟化、HugePage 大页、tc 流量控制、conntrack 连接跟踪、tmpfs 内存盘
## 4. 运维价值
排查容器逃逸、容器资源超限、Nginx 百万并发卡顿、数据库性能差、防火墙转发异常、实时备份失效等问题，全部需要理解对应内核底层机制。


 介绍一下Linux内核的内存管理子系统
 如何优化Linux内核的文件系统性能？
 如何使用Linux内核的IPC进程间通信接口？
```
