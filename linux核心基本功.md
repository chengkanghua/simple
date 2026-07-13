

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
```bash
vi /etc/sysconfig/network-scripts/ifcfg-ens33
ONBOOT=yes
```
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
```bash
nmcli connection modify ens33 connection.autoconnect yes
nmcli connection up ens33
```

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
```

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
```

# 二、systemd Target 目标单元（CentOS7+/Ubuntu16.04+ 主流）
systemd 抛弃数字runlevel，改用**target目标**，target之间存在依赖关系，并行启动服务。
## 1. Target 与 runlevel 一一对应
| systemd Target          | 等效runlevel | 说明 |
|-------------------------|-------------|------|
| poweroff.target         | 0           | 关机 |
| rescue.target           | 1           | 单用户救援模式（单用户） |
| multi-user.target       | 3           | 字符多用户，服务器默认 |
| graphical.target        | 5           | 图形桌面 |
| reboot.target           | 6           | 重启 |
| emergency.target        | -           | 紧急模式，比rescue更精简 |

## 2. 核心操作命令
```bash
# 查看当前默认启动目标
systemctl get-default

# 设置开机默认字符界面
systemctl set-default multi-user.target

# 临时切换（立即生效）
systemctl isolate multi-user.target
systemctl isolate graphical.target

# 查看目标依赖的服务
systemctl list-dependencies multi-user.target
```

## 3. systemd 启动流程简化
`sysinit.target` → `basic.target` → `multi-user.target`
所有自定义服务（sshd、nginx、mysql）挂载在 `multi-user.target` 下开机自启。

# 三、单用户模式重置root密码（CentOS7/9 通用，GRUB2操作）
适用场景：忘记root密码，本地服务器物理操作
## 步骤1：开机在GRUB菜单界面
1. 出现内核选择页面，选中默认内核，按 `e` 进入编辑模式
## 步骤2：修改内核启动参数
找到以 `linux16`（CentOS7）/ `linux`（CentOS9）开头的一行，做两处修改：
1. 将参数 `ro`（只读）改为 `rw`（读写挂载根分区）
2. 在该行末尾添加：`init=/bin/bash`
## 步骤3：进入单用户shell
按 `Ctrl + X` 启动，直接进入root bash，无需密码
## 步骤4：重置密码
```bash
# 修改root密码
passwd root
# SELinux环境必须更新上下文，否则重启无法登录
touch /.autorelabel
```
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
```bash
systemctl isolate rescue.target
```

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
```
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```
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
```bash
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
```

## 三、SSH 密钥登录完整配置（免密登录核心）
### 原理
非对称密钥对：
- **私钥 id_rsa**：客户端本地保管，绝不外泄
- **公钥 id_rsa.pub**：上传到服务端 `~/.ssh/authorized_keys`
流程：客户端私钥签名，服务端用对应公钥校验，匹配成功免密登录。

### 操作步骤（客户端执行）
#### 1. 生成密钥对
```bash
# 一路回车，不设置密钥密码（单纯免密）
ssh-keygen -t rsa
# -t rsa 指定加密算法，默认2048位；可加 -b 4096 提升强度
```
生成文件路径：`~/.ssh/`
- id_rsa 私钥（权限必须600）
- id_rsa.pub 公钥

#### 2. 推送公钥到目标服务器（一键命令）
```bash
ssh-copy-id root@192.168.1.100
# 底层自动创建 .ssh 目录，把公钥写入 authorized_keys
```

#### 3. 免密登录测试
```bash
ssh root@192.168.1.100
# 无需输入密码直接进入
```

### 手动推送方案（无 ssh-copy-id 工具时）
```bash
# 本地输出公钥，ssh管道追加到服务端认证文件
cat ~/.ssh/id_rsa.pub | ssh root@ip "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### 权限硬性要求（权限过大SSH拒绝密钥登录）
服务端目录/文件权限：
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
# 家目录权限不能777，否则校验失败
chmod 755 ~
```

## 四、SSH 服务安全加固（生产必做，面试高频）
配置文件：`/etc/ssh/sshd_config`
修改后重载服务生效：
```bash
# CentOS7/9
systemctl restart sshd
# Ubuntu
systemctl restart ssh
```

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
```ini
HostKey /etc/ssh/ssh_host_rsa_key
# 生成4096位主机密钥替换默认弱密钥
ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key
# ssh-keygen -t ed25519  # ed25519（现代更强、体积更小，推荐）
```

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
```
Host web01
  HostName 192.168.1.10
  User root
  Port 22345
  IdentityFile ~/.ssh/id_ed25519
```
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
```
-rw-r--r-- 1 root root  120 Jul 10 test.txt
```

### 2. 目录文件 `d`
标识：首字符 `d`
文件夹，内部存储该目录下所有文件的文件名与对应inode映射表。
目录默认权限至少执行权限x，否则无法进入目录查看内容。
```
drwxr-xr-x 2 root root 4096 Jul 10 data/
```

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
```bash
ln source.txt hardlink.txt
```
#### 判断硬链接：ls -l 第二列是链接计数，多个文件inode相同
```
ls -i
# 相同inode即为硬链接
```

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
```
brw-rw---- 1 root disk 8, 0 Jul 10 /dev/sda
brw-rw---- 1 root disk 8, 1 Jul 10 /dev/sda1
```

#### （2）字符设备 `c`
标识：首字符 `c`
无缓冲，流式逐个字节读写，终端、黑洞、随机数设备
```
crw-rw-rw- 1 root tty  1, 3 Jul 10 /dev/null
crw--w---- 1 root tty  4, 0 Jul 10 /dev/tty0
```

### 6. 管道文件（命名管道FIFO）`p`
标识：首字符 `p`
进程间通信IPC，单向数据流，先进先出；
常用于程序间传递数据，不占用磁盘空间。
创建：
```bash
mkfifo pipe_test
```
输出示例：
```
prw-r--r-- 1 root root 0 Jul 10 pipe_test
```

### 7. 套接字文件 socket `s`
标识：首字符 `s`
本地进程间IPC通信（比管道更强大，支持双向通信）；
数据库、Web服务本地通信大量使用，存放于 `/var/run/`
示例：`/var/run/mysqld/mysqld.sock`
```
srwxrwxrwx 1 mysql mysql 0 Jul 10 mysqld.sock
```

## 三、速查表（背诵）
| 首字符 | 文件类型 | 核心特点 |
|--------|---------|---------|
| `-` | 普通文件 | 文本、程序、日志、压缩包 |
| `d` | 目录 | 存放文件名与inode映射 |
| `l` | 软链接 | 独立inode，存目标路径，源删则失效 |
| 无单独标识 | 硬链接 | 共享inode，同分区，删文件不丢数据 |
| `b` | 块设备 | 磁盘分区、光驱，带缓存块读写 |
| `c` | 字符设备 | /dev/null、终端，流式字节读写 |
| `p` | 管道FIFO | 单向进程通信 |
| `s` | socket套接字 | 本地双向进程通信（数据库常用） |

## 四、高频面试区分：硬链接 vs 软链接
1. inode：硬链接同inode；软链接独立inode
2. 跨分区：硬链接不行；软链接支持
3. 链接目录：硬链接不允许；软链接可以
4. 删除源文件：硬链接数据保留；软链接失效
5. 文件大小：硬链接和源文件大小一致；软链接大小等于目标路径字符长度

## 五、实操判断命令
```bash
# 1. 看类型符号
ls -l filename

# 2. 精确识别文件类型
file filename

# 3. 查看inode区分硬链接
ls -i filename

# 4. 查看底层设备号、链接数
stat filename
```

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
```bash
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
```

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
```bash
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
```

## 特殊扩展通配符（bash 开启 `shopt -s extglob`）
```bash
# ?(pattern) 匹配0次或1次
# *(pattern) 匹配0次或多次
# +(pattern) 匹配1次或多次
# !(pattern) 不匹配该模式
```

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
```bash
grep '^root' /etc/passwd      # 以root开头行
grep 'bash$' /etc/passwd      # bash结尾行
grep 'r..t' /etc/passwd       # r任意两字符t
grep 'ro*t' test.txt          # o出现0/多次 rt rot rooot
grep '[0-9]\{3\}' test.txt    # 连续3个数字
grep '\(ab\)\{2\}' test.txt   # abab
```

# 三、扩展正则表达式 ERE（grep -E / sed -r / awk 默认）
不用大量反斜杠，新增 `+ ? | () {}`，符号原生生效
## 新增核心符号
1. `+` 前字符至少匹配1次（1次及以上）
2. `?` 前字符匹配0或1次（可有可无）
3. `|` 或，多模式任选其一
4. `()` 分组，无需转义
5. `{n,m}` 次数限定，无需转义

## ERE 示例
```bash
# grep -E 启用扩展正则
grep -E 'ro+t' test.txt       # o至少1次 rot rooot
grep -E 'ro?t' test.txt       # o出现0/1次 rt rot
grep -E 'root|nginx' file     # 匹配root 或 nginx
grep -E '(abc){2,3}' test     # abcabc / abcabcabc
grep -E '[0-9]{1,3}' test     # 1~3位数字
```

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
```bash
ps -ef | grep sshd
cat /proc/1234/cmdline
```

### 2. 全局系统信息（无数字命名文件）
```bash
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
```

### 3. 动态内核可调参数 /proc/sys/（高频运维）
路径分类：`/proc/sys/net`、`/proc/sys/vm`、`/proc/sys/fs`
可直接echo写入修改，临时生效
```bash
# 开启内核IP转发（网关/iptables NAT必备）
echo 1 > /proc/sys/net/ipv4/ip_forward

# 调整TCP连接回收
echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse

# 内存脏页写入阈值
cat /proc/sys/vm/dirty_ratio
```
永久保存需写入 `/etc/sysctl.conf`，执行 `sysctl -p`

## 三、/sys 伪文件系统（标准化硬件、总线、驱动）
### 定位
专门管理**硬件设备、总线、驱动**，是比/proc更规范的硬件标准接口；systemd、udev依赖/sys识别硬件生成/dev设备文件。
### 顶层核心目录
1. `/sys/block`：所有块设备（磁盘、分区 sda、sdb、sr0）
```bash
ls /sys/block/sda/size      # 磁盘扇区大小
cat /sys/block/sda/queue/scheduler # IO调度算法
```
2. `/sys/class`：硬件设备分类（网卡、显卡、终端、声卡）
```bash
# 网卡信息
ls /sys/class/net/ens33/
cat /sys/class/net/ens33/speed
```
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
```bash
# 基础创建，自动创建同名组、家目录/home/test、默认shell /bin/sh
useradd test

# 常用参数组合（生产标准写法）
# -u 指定UID  -g 指定主组  -G 附加组  -m 自动创建家目录  -s 指定登录shell
useradd -u 1005 -g dev -G docker,nginx -m -s /bin/bash admin

# -r 创建系统用户（无家目录、UID<1000，用于运行服务进程）
useradd -r nginx
```

## 2. usermod 修改已有用户属性
```bash
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
```

## 3. userdel 删除用户
```bash
# 仅删除用户，保留家目录与邮件
userdel test
# -r 删除用户 + 同步删除家目录、邮件文件（彻底清理）
userdel -r test
```

## 4. passwd 密码管理
```bash
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
```

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
```bash
groupadd dev          # 创建组
groupmod -n newdev dev # 修改组名
groupdel dev          # 删除空组
groups test           # 查看用户所有组
id test               # 查看UID/GID/附加组
```

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
```bash
# 基础创建，自动分配GID
groupadd ops

# -g 指定自定义GID
groupadd -g 2000 docker

# -r 创建系统组（GID < 1000，服务进程使用）
groupadd -r nginx
```

## 2. groupmod 修改已有组
```bash
# -g 修改组ID
groupmod -g 2001 docker

# -n 修改组名称
groupmod -n dev ops
```

## 3. groupdel 删除组
```bash
# 只能删除没有用户作为【主组】的空组
groupdel dev
```
坑：如果某用户的主组是该组，无法直接删除，需先修改用户主组。

## 4. 查看用户所属组
```bash
# 打印用户全部组（主组+附加组）
groups admin

# 详细输出UID/GID/主组/附加组
id admin
```

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
```bash
usermod -g 目标组 用户名
# 示例：把admin主组改为ops
usermod -g ops admin
```

## 2. 附加组（附属组，Supplementary Group）
1. 用于赋予额外权限，如docker、sudo、nginx；
2. 一个用户可以拥有**多个附加组**；
3. 附加组成员记录在 `/etc/group` 最后一列；
4. 修改附加组必须带 `-a` 追加，否则覆盖清空原有附加组。

### 追加附加组（正确写法）
```bash
# -a 追加，-G 指定附加组列表
usermod -aG docker,sudo admin
```
坑：不加 `-a`，`usermod -G docker admin` 会删除用户原有所有附加组，只保留docker。

## 3. 主组、附加组完整演示
```bash
# 创建用户admin，主组admin，附加组docker
useradd -m admin
usermod -aG docker admin

# id查看
id admin
# uid=1000(admin) gid=1000(admin) 主组gid
# 组列表：1000(admin),2000(docker) 主组+附加组
```

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
```bash
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
```

## 2. 数字法（八进制，运维最常用）
r=4，w=2，x=1；每段权限数值相加，三位数字代表 u g o
- r=4  w=2  x=1
- --- =0  --x=1  -w-=2  -wx=3  r--=4  r-x=5  rw-=6  rwx=7

### 常用标准权限
| 数字 | 权限含义 | 适用场景 |
|------|----------|----------|
| 644 | rw-r--r-- | 普通文本、配置文件 |
| 755 | rwxr-xr-x | 目录、脚本程序 |
| 600 | rw------- | 密钥、隐私文件、/root |
| 700 | rwx------ | 私密目录、ssh .ssh文件夹 |
| 777 | rwxrwxrwx | 所有人完全读写执行，生产严禁使用 |

示例：
```bash
# 文件标准权限
chmod 644 nginx.conf
# 目录/脚本标准权限
chmod 755 start.sh
# 私密密钥
chmod 600 id_rsa
# 私密目录
chmod 700 ~/.ssh
```

# 三、核心命令 chmod / chown / chgrp
## 1. chmod 修改权限（rwx读写执行权限）
```bash
# 数字法
chmod 755 test.sh
# 符号法
chmod u+x test.sh
# -R 递归修改目录下所有文件+子目录
chmod -R 755 /data/www
```

## 2. chown 修改属主、属组
格式：`chown 属主[:属组] 文件`
```bash
# 只改属主
chown admin test.txt
# 同时改属主+属组
chown admin:ops test.txt
# 递归修改目录所有文件归属
chown -R admin:ops /data/www
```

## 3. chgrp 仅修改属组
```bash
# 修改文件属组为nginx
chgrp nginx test.log
# 递归
chgrp -R nginx /var/log/nginx
```

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
```bash
# 属主rwx，属组其他rx，附加SUID(4)
chmod 4755 /usr/bin/mycmd
```
#### 符号法
```bash
chmod u+s /usr/bin/mycmd
# 移除SUID
chmod u-s /usr/bin/mycmd
```

### 安全风险（高危）
1. 自定义程序设置SUID root，程序存在漏洞可提权至root；
2. 生产环境严禁随意给自定义脚本/二进制加 SUID root；
3. 排查服务器危险SUID文件：
```bash
find / -perm -4000 2>/dev/null
```

---

## 2. SGID 置组ID（文件 + 目录均生效）
### 场景1：作用于可执行二进制文件
用户运行程序时，临时获得**文件所属组**权限，极少使用。

### 场景2：作用于目录（运维高频使用）
目录设置SGID后，**所有在该目录新建的文件/子目录，自动继承目录的属组**，而非创建者的默认主组。
适用场景：多人协作共享目录，统一文件属组，方便权限管控。

### 配置方式
数字法（2开头）
```bash
chmod 2770 /data/share
```
符号法
```bash
chmod g+s /data/share
# 移除
chmod g-s /data/share
```

### 风险
共享目录若属组权限过宽，容易造成文件越权读取；禁止给系统关键目录配置SGID。

### 查找带SGID文件/目录
```bash
find / -perm -2000 2>/dev/null
```

---

## 3. Sticky Bit 粘滞位（**仅目录生效，文件无效**）
### 作用
目录开启粘滞位后：
**每个用户只能删除/改名自己创建的文件，不能删除别人的文件**。
经典示例：`/tmp` 临时目录，所有人可读写，但不能删他人临时文件。

### 配置方式
数字法（1开头）
```bash
chmod 1777 /tmp
```
符号法
```bash
chmod o+t /tmp
# 移除
chmod o-t /tmp
```

### 适用场景
公共临时目录、多用户上传共享目录，防止误删他人文件。
风险极低，属于安全加固常用权限。

### 查找带Sticky目录
```bash
find / -perm -1000 -type d 2>/dev/null
```

---

# 三、三种特殊权限速查表
| 权限    | 八进制值 | 生效对象       | 核心功能                                                     |
|---------|----------|----------------|--------------------------------------------------------------|
| SUID    | 4000     | 仅二进制文件   | 执行时临时拥有文件**属主**身份                               |
| SGID    | 2000     | 文件/目录      | 文件：临时获得文件属组；目录：新建文件自动继承目录属组        |
| Sticky  | 1000     | 仅目录         | 目录内用户只能删除自己创建的文件                             |

# 四、组合写法示例
```bash
# 同时开启SUID+SGID
chmod 6755 test.bin
# SGID + Sticky
chmod 3770 share
# SUID + SGID + Sticky
chmod 7777 test
```

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
```
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
```bash
# 查看文件/目录完整ACL规则
getfacl /edu
```
输出字段：
```
# file: /edu
# owner: root
# group: root
user::rwx            # 文件属主默认权限
user:zhangsan:r-x    # 单独给用户zhangsan分配r-x
group::rwx           # 文件属组默认权限
group:dev:r--        # 单独给组dev分配只读
mask::rwx            # 权限掩码，限制ACL最大可用权限
other::r-x           # 其他用户默认权限
```
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
```bash
# 用户zhangsan 读写执行
setfacl -m u:zhangsan:rwx /edu
# 用户lisi 只读
setfacl -m u:lisi:r-- /edu
```

### 2. 给单个用户组分配权限
```bash
# 组ops 读写
setfacl -m g:ops:rw- /edu
# 组test 仅执行
setfacl -m g:test:--x /edu
```

### 3. 修改mask掩码
```bash
setfacl -m m:rwx /edu
```

### 4. 递归给整个目录配置ACL
```bash
setfacl -R -m u:zhangsan:rwx /edu
```

### 5. 默认ACL（目录新建文件自动继承权限，多人共享目录必备）
不加 `-d` 时，后续新建文件不会带上ACL；默认ACL仅对目录生效。
```bash
# 设置默认ACL，未来新建文件自动继承zhangsan rwx
setfacl -d -m u:zhangsan:rwx /edu
# 同时递归+默认ACL
setfacl -R -d -m u:zhangsan:rwx /edu
```

## 五、删除ACL规则
```bash
# 删除单个用户zhangsan的ACL
setfacl -x u:zhangsan /edu

# 删除单个组dev的ACL
setfacl -x g:dev /edu

# 清空全部ACL规则（ls末尾+消失）
setfacl -b /edu
```

## 六、备份与恢复ACL（迁移目录必备）
```bash
# 备份目录ACL到文件
getfacl -R /edu > acl_bak.txt

# 恢复ACL
setfacl --restore=acl_bak.txt
```

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
```bash
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
```
用户名  主机=(可切换身份:可切换组)  允许执行命令列表 [NOPASSWD:免密]
```
### 内置默认规则（系统自带）
```ini
# root 用户拥有全部权限
root    ALL=(ALL)       ALL

# wheel组所有用户拥有全部sudo权限（CentOS）
%wheel  ALL=(ALL)       ALL

# sudo组（Debian/Ubuntu）
%sudo   ALL=(ALL:ALL) ALL
```
字段拆解：
1. `用户名 / %组名`：授权对象，`%` 代表用户组
2. `ALL`（主机）：在哪台机器生效，ALL=所有本机
3. `(ALL)`：可切换到哪个用户，ALL=任意账号
4. `ALL`：允许执行的命令，ALL=全部root命令

## 三、常用配置示例（visudo内添加）
### 1. 普通用户完整sudo权限（不推荐生产，权限过大）
```ini
admin  ALL=(ALL) ALL
```
使用：输入admin自身密码即可执行任意root命令
```bash
sudo systemctl restart nginx
sudo rm -rf /etc/*
```

### 2. 免密完整sudo（高危）
`NOPASSWD:` 跳过密码校验
```ini
admin  ALL=(ALL) NOPASSWD: ALL
```

### 3. 权限最小化（生产标准，重点）
只允许指定几条命令，禁止全部root权限
#### 示例1：仅允许操作nginx服务
```ini
nginxuser  ALL=(ALL) /usr/bin/systemctl restart nginx, /usr/bin/systemctl start nginx, /usr/bin/systemctl stop nginx
```
#### 示例2：允许查看日志、df、free，禁止修改系统
```ini
ops  ALL=(ALL) /usr/bin/df, /usr/bin/free, /usr/bin/cat /var/log/*
```
#### 示例3：允许切换指定用户（运维账户切换业务账号）
```ini
dev  ALL=(www) ALL
# dev无需root，可sudo -u www 执行程序
```

### 4. 组批量授权（%组名）
```ini
# dev组所有人可重启nginx
%dev  ALL=(ALL) /usr/bin/systemctl restart nginx
```

### 5. 免密执行指定命令（推荐，兼顾便捷与安全）
```ini
ops  ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx
```

### 6. 禁止危险命令（! 取反）
```ini
# 拥有全部权限，但禁止su、passwd、rm -rf /
admin ALL=(ALL) ALL, !/usr/bin/su, !/usr/bin/passwd root, !/bin/rm -rf /
```

## 四、别名简化配置（大批量运维场景）
### 1. Host_Alias 主机别名
```ini
Host_Alias LOCAL = localhost,127.0.0.1
```
### 2. User_Alias 用户别名
```ini
User_Alias OPS = zhangsan,lisi,wangwu
```
### 3. Cmnd_Alias 命令别名（批量管理常用命令）
```ini
Cmnd_Alias NGINX_CMD = /usr/bin/systemctl start nginx, /usr/bin/systemctl stop nginx, /usr/bin/systemctl restart nginx
```
### 组合使用
```ini
OPS  LOCAL=(ALL) NOPASSWD: NGINX_CMD
```

## 五、sudo 相关实操命令
```bash
# 查看当前用户拥有哪些sudo权限
sudo -l

# 切换root，使用sudo权限（无需root密码）
sudo -i
sudo su -

# 以指定用户执行命令
sudo -u www python app.py

# 免密配置后直接执行，无需输密码
sudo systemctl restart nginx
```

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
```bash
# 方式1（常用）
getenforce
# 输出 Enforcing / Permissive / Disabled

# 方式2
sestatus
```

## 四、临时切换模式（重启失效）
```bash
# 设为宽容模式调试
setenforce 0

# 切回强制模式
setenforce 1
```
> 无法临时切换到 disabled，只能改配置文件重启生效。

## 五、永久修改模式（配置文件 `/etc/selinux/config`）
```ini
# SELINUX=enforcing
# SELINUX=permissive
SELINUX=disabled
```
修改后**必须重启服务器**才生效。

字段说明：
`SELINUX=` 控制运行模式；
`SELINUXTYPE=targeted` 策略类型，不用改。

## 六、SELinux 上下文基础（ls -Z）
`ls -l` 末尾带 `.` 代表文件有 selinux 上下文标签
```bash
ls -Z /var/www/html
```
常见场景：nginx 无法读取网站文件，大多是上下文不匹配。

### 修复上下文命令
```bash
# 自动还原目录默认安全上下文（最常用排障）
restorecon -R /var/www/html

# 手动修改上下文
chcon -R -t httpd_sys_content_t /var/www/html
```

## 七、简单排障思路
1. 服务访问文件/端口被拒绝 → 先临时 `setenforce 0` 测试
   - 关闭后正常：问题就是 SELinux 拦截，修复上下文/放行策略
   - 关闭仍报错：是防火墙、文件rwx权限、程序配置问题
2. 查看拦截日志
```bash
grep avc: /var/log/audit/audit.log
```
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
```bash
ps -ef            # 第二列PID，第三列PPID
ps aux
cat /proc/$$/stat # $$ 当前shell进程PID
pstree -p         # 树形展示父子进程+PID
```

## 三、四种核心进程状态
### 1. 运行态 R (Running)
进程正在CPU上执行，或就绪排队等待CPU调度。
### 2. 休眠态（两种）
1. S 可中断休眠：等待资源、IO、信号，收到信号可唤醒（绝大多数进程常态）
2. D 不可中断休眠：等待磁盘IO，无法被信号唤醒，强制关机可能丢失数据
### 3. 僵尸进程 Z (Zombie)
1. 子进程执行完毕退出，父进程**未调用wait()回收子进程退出状态**；
2. 子进程资源已释放，仅残留PID条目存退出码；
3. 危害：大量僵尸占用PID号，系统无法新建进程；
4. 解决：杀死父进程，由PID=1 systemd接管自动回收僵尸。

### 4. 孤儿进程
1. 父进程提前退出，子进程失去父进程；
2. 系统自动将孤儿进程的PPID改为1（systemd）；
3. 无害，PID=1会负责回收其退出信息，不会变成僵尸。

## 配套查看命令（bash注释版）
```bash
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
```

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
```

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
```conf
# 所有info日志，排除认证
*.info;mail.none;authpriv.none;cron.none    /var/log/messages
# 认证日志单独存放
authpriv.*                                  /var/log/secure
# cron日志
cron.*                                      /var/log/cron
# 邮件日志
mail.*                                      -/var/log/maillog
```
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
```conf
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
```

### 示例2：Nginx日志（copytruncate 无需重启）
```conf
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
```

## 四、全局默认配置 /etc/logrotate.conf
```conf
weekly          # 默认每周轮转
rotate 4        # 默认保留4份备份
create          # 自动创建新日志
compress        # 默认开启压缩

# 加载独立配置目录
include /etc/logrotate.d
```

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
```
total        used        free      shared  buff/cache   available
```
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






















