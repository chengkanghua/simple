# Linux 运维工程师 核心基础知识框架 + 学习路线图

Linux 核心基础是所有运维方向（传统运维、云原生运维、运维开发、DBA、信创运维）的通用底层能力，对应企业招聘中「Linux 基础扎实」的硬性要求。以下按 **从底层到应用、从入门到上岗** 的逻辑拆分十大模块，标注必会/了解等级，最后给出完整学习路径与实战建议。

---

# Linux 运维核心基础十大模块

## 模块 1：Linux 认知与系统启动体系（入门第一关）

**定位**：建立对 Linux 的整体认知；懂启动原理，才能排查系统级故障。

> **本节统一模板**：①一句话本质 → ②原理 / 流程 → ③命令示例 → ④易错点 → ⑤🎯面试考点
> **标注含义**：★ 重点必会 ｜ ★★ 核心中的核心 ｜ 🎯 面试高频

### 核心知识点

- ★ Linux 发展历史、开源协议、三大发行版派系（RHEL/CentOS、Debian/Ubuntu、国产欧拉/统信）
- 虚拟机环境搭建（VMware/VirtualBox），CentOS 7/9、Ubuntu 22.04 最小化安装
- ★★ 系统完整启动流程：BIOS/UEFI → GRUB2 → 内核 → systemd → 登录
- ★ 运行级别与 systemd target、单用户重置密码、救援（rescue / emergency）模式
- ★★ SSH 连接原理、密钥免密登录、SSH 安全加固

**学习目标**

能独立完成系统安装与远程连接，能一口气说出"开机 → 登录"的完整链路，能处理启动类故障。

### 1.1 Linux 发展史、开源协议与发行版派系 ★

```md
【① 一句话本质】
Linux = GNU 工具集 + Linux 内核（正确叫法 GNU/Linux），是一套免费开源的类 Unix 系统。
今天服务器、云主机、Docker/K8s、路由器、安卓、物联网的底层几乎全是它（仅桌面端仍是 Windows/macOS 占优）。

【② 原理 / 脉络】
1) 前置背景
- 1969：Unix 诞生于贝尔实验室，闭源商用、价格昂贵。
- 1983：Richard Stallman 发起 GNU 项目，要造"完全自由的类 Unix 系统"，但一直缺内核。
- GNU 的贡献：ls / cat / cp / bash / gcc / sed / awk / coreutils —— 我们每天敲的命令大多出自 GNU。

2) 内核诞生
- 1991：芬兰大学生 Linus Torvalds 基于 Minix 写出轻量内核 Linux，公开源码。
- 采用 GPLv2：改了就要开源 → 全世界开发者共同迭代。

3) 发展关键节点
- 90 年代中后期：厂商把内核 + 软件 + 包管理器打包 → 各种发行版诞生。
- 2004：Ubuntu 发布，大幅降低使用门槛。
- 2013 起：云时代爆发，Linux 垄断服务器 / 容器 / 云底层。
- 2014：RHEL 7 全面转向 systemd，成为企业服务器标杆。
- 国内：早期基于 CentOS 改国产系统 → 华为开源 openEuler、深度做统信 UOS，形成信创体系。

4) 开源协议（运维必须能区分）
- GPLv2（Linux 内核、bash、coreutils）：★强传染性 —— 只要软件包含/链接了 GPL 代码，
  整个项目必须同样以 GPL 开源；对外分发（售卖、公开部署）必须公开修改后的完整源码。
- LGPL（glibc 等类库专用）：商业闭源程序动态链接它，你的程序不用开源；只有改了库本身才需开源。
- Apache 2.0（Nginx、K8s、Go 生态）：可商用、可闭源，修改需标注变更，★明确授予专利授权，无传染。
- MIT：只保留版权声明，随便用，几乎无约束（但无专利保护）。

速记：GPL 改了就开源 ｜ LGPL 库专用、动态链接不传染 ｜ Apache 商用友好带专利 ｜ MIT 极简随便用。

5) 三大发行版派系
派系一 RHEL 系（企业服务器主流）
- RHEL：商业收费，面向政企/金融/大型生产；卖的是官方源、7~10 年长期支持、安全补丁、售后。
- CentOS：RHEL 的免费复刻（去掉商标）。★CentOS 7 于 2024 停服、CentOS 8 于 2021 停更；
  替代方案 Rocky Linux / AlmaLinux。运维现状：大量存量业务仍跑在 CentOS 7。
- 统一特征：软件包 .rpm ｜ 包管理 yum(7) / dnf(8/9) ｜ 防火墙 firewalld ｜ 默认文件系统 xfs。

派系二 Debian / Ubuntu 系
- Debian：纯社区驱动、极致稳定、软件版本偏旧；包 .deb、apt；适合服务器与容器基础镜像。
- Ubuntu：Canonical 维护，分桌面版与 Server 版；每 2 年一个 LTS（20.04/22.04/24.04），免费维护 5 年；
  软件源丰富、文档多、云厂商默认镜像、新手友好；防火墙默认 ufw。

派系三 国产信创
- openEuler（华为开源，服务器端）：自研内核、兼容 RPM、适配 ARM/x86/鲲鹏，
  配套 iSula 容器与云原生组件，是国内政企/运营商/金融替换 CentOS 的主力。
- 统信 UOS（基于 Debian，桌面为主）：政务办公终端、国产化 PC，适配飞腾/龙芯，deb 包管理。

【④ 易错点】
- "Linux 操作系统"严格应叫 GNU/Linux —— 只有内核跑不起来，命令工具来自 GNU。
- GPL 的"传染"针对"对外分发"行为；公司内部自用通常不触发开源义务（具体以法务意见为准）。

【⑤ 🎯 面试考点】
🎯 发行版怎么选型？
  传统企业/金融生产 → RHEL / Rocky Linux；开发、云主机、测试 → Ubuntu Server；
  嵌入式、极简容器底层 → Debian；信创替换 CentOS → openEuler；政务桌面 → 统信 UOS。
🎯 GPL 与 LGPL 区别？
  GPL 强传染，链接了就要整体开源；LGPL 只约束库本身，动态链接它的商业程序不用开源。
```

### 1.2 实验环境：虚拟机与最小化安装

```md
【① 一句话本质】
用虚拟机装 3 台最小化 Linux（CentOS 7 / CentOS 9 / Ubuntu 22.04），搭出可随时快照回滚的练习环境。

【② 原理 / 要点】
1) 虚拟机软件
- VMware Workstation Pro（推荐）：快照/克隆/共享文件夹完善，磁盘 IO 与网络延迟低，运维学习首选；商用收费。
- VirtualBox：免费轻量，但多虚拟机卡顿、快照慢、共享文件夹坑多。
★BIOS 必须开启虚拟化 Intel-VT / AMD-V，否则虚拟机极卡。

2) 三种网卡模式（必会）
- 桥接：虚拟机与宿主机同网段，局域网其他机器可访问 → 多机集群实验用这个。
- NAT（默认）：虚拟机能上外网，外部无法主动访问它 → 单机学习推荐。
- 仅主机：仅宿主机与虚拟机互通，无外网 → 隔离测试。

3) 镜像与硬件
- CentOS-7-x86_64-Minimal.iso、CentOS-Stream-9-x86_64-minimal.iso、ubuntu-22.04-live-server-amd64.iso
- 单台最低配置：2 核 / 2G 内存 / 20G 磁盘（1G 内存安装极易卡死）。

4) 安装共性（三系统通用）
- 语言选 English（避免终端中文乱码）；
- 软件选择 Minimal（最小化，不装图形桌面）；
- 分区统一方案：/boot 1G、swap 2G、/ 剩余全部；
- 时区选 Shanghai、打开网卡开关、设置主机名。

5) 三个系统的差异点
- CentOS 7：装完要手动开网卡
  vi /etc/sysconfig/network-scripts/ifcfg-ens33   →   ONBOOT=yes
  systemctl restart network
  ip a
- CentOS 9 Stream：改用 NetworkManager（无 network 服务），包管理 dnf，默认 XFS，安装界面全新
  nmcli connection modify ens33 connection.autoconnect yes
  nmcli connection up ens33
- Ubuntu 22.04：★禁止 root 远程登录，必须建普通用户，之后 sudo -i 切 root；软件源用 apt；
  最小化关键是不勾选任何服务组件（OpenSSH server 可选）。

6) 集群实验环境标准配置
- 三台统一桥接、同网段互通；全开 OpenSSH；学习环境关闭防火墙与 SELinux；
- 配 /etc/hosts 互相解析 + SSH 免密；★装完立刻打快照，后续实验出错一键恢复。

【④ 易错点 / 排错】
- 虚拟机无法联网：网卡 ONBOOT 没开、NAT 服务未启动、虚拟网卡驱动异常。
- 安装找不到磁盘：虚拟机磁盘未分配、BIOS 磁盘模式不兼容。
- 安装卡在镜像加载：镜像校验失败，重新下载官方 minimal 镜像。
- 宿主机连不上虚拟机 SSH：防火墙拦截、NAT 未放行 22 端口、桥接网段不通。
```

### 1.3 系统启动全流程 ★★

```md
【① 一句话本质】
上电 → BIOS/UEFI 自检 → GRUB2 引导 → 内核加载（借 initramfs 找到根分区）→ systemd(PID=1) 初始化 → getty/login。

【② 五阶段流程】
阶段 1：BIOS / UEFI 固件自检（硬件层）
- BIOS（传统 Legacy）：上电 → POST 自检（CPU/内存/硬盘/显卡，故障直接停机）
  → 按启动顺序找 MBR（硬盘前 512 字节）→ 读 0 扇区前 446 字节引导程序 → 交给 GRUB。
- UEFI（新式，CentOS 8+/Ubuntu 20.04+ 默认）：图形化固件、支持 GPT 大硬盘（>2T）、
  自带文件系统驱动可直接识别 FAT32 的 ESP 分区 → 读取 grubx64.efi；支持安全启动、启动更快。
★对应关系：BIOS ↔ MBR 分区表；UEFI ↔ GPT 分区表。虚拟机装 2T 以上磁盘必须开 UEFI。

阶段 2：GRUB2 引导（选内核、加载内核）
- 读 /boot/grub2/grub.cfg 展示启动菜单（多内核、救援、单用户）；
- 做两件事：加载 vmlinuz（内核压缩镜像）+ initramfs（临时内存文件系统，内含驱动）；
- 然后把控制权交给内核。
关键文件：/boot/vmlinuz-xxx、/boot/initramfs-xxx.img、/etc/default/grub（配置模板）。
改完模板要重新生成：grub2-mkconfig -o /boot/grub2/grub.cfg
★单用户改密码、进救援模式，都是在 GRUB 菜单这里操作。

阶段 3：内核加载与初始化（内核空间）
解压到内存 → 初始化 CPU/内存/时钟 → 挂载 initramfs 载入磁盘/RAID/LVM 驱动 → 识别真实硬盘分区
→ 卸载 initramfs → 以只读方式挂载真实根分区 → 启动第一个用户态进程 systemd（PID 恒为 1）。

阶段 4：systemd 初始化（CentOS 7+/Ubuntu 16.04+ 统一）
- 按 /etc/fstab 挂载 /、/boot、/var、/home、swap，并把根分区重新挂成可读写；
- sysinit.target：内核参数、主机名、sysctl、udev 识别硬件、时钟、LVM、加密盘、fsck；
- basic.target：rsyslog 日志、NetworkManager、安全策略、定时任务等基础服务；
- 切换到 multi-user.target（服务器默认）或 graphical.target（图形）；
  ★所有开机自启服务（nginx/sshd/mysql）都挂在 multi-user.target 下并行启动。
- 级别对应：0 poweroff ｜ 1 rescue ｜ 3 multi-user ｜ 5 graphical ｜ 6 reboot

阶段 5：登录（用户态）
systemd 起 getty 监听 tty → 输入账号密码 → PAM 校验 /etc/passwd 与 /etc/shadow → 启动 bash；
远程场景则是 sshd 监听 22 端口，同样走 PAM 认证。

【③ 常用命令】
systemctl get-default                   # 查看默认启动目标
systemctl set-default multi-user.target # 设为默认字符界面
systemctl isolate graphical.target      # 临时切换

【⑤ 🎯 面试考点】
🎯 initramfs 有什么用？
  内核自带驱动有限，initramfs 里装了磁盘/LVM/RAID 驱动，保证内核能识别并挂载真实根分区。
🎯 systemd 相比旧 init 的优势？
  并行启动、自动依赖管理、统一管控进程/挂载/网络、支持服务自动重启、日志统一（journald）。
🎯 最小化服务器默认进哪个 target？ → multi-user.target
🎯 卡在 GRUB 阶段怎么排查？ → 镜像损坏、磁盘引导损坏、/boot 分区丢失、grub.cfg 配置错误。
🎯 内核加载完卡死大概率是什么？ → 根分区损坏、fstab 挂载错误、磁盘驱动缺失、LVM 异常。
🎯 MBR 为什么最大 2TB、主分区为什么只能 4 个？
  - 只能 4 个：MBR 分区表只有 64 字节，每条分区记录 16 字节 → 64/16 = 4
    （512 - 446 引导程序 - 2 校验 = 64）；想更多分区必须用"扩展分区 + 逻辑分区"。
  - 最大 2TB：MBR 采用 32 位 LBA 寻址，每扇区 512B → 2^32 × 512B = 2048GB，再大地址就溢出。
```

### 1.4 运行级别、systemd target 与救援模式 ★

```md
【① 一句话本质】
runlevel 是老式数字级别，systemd target 是它的升级版；忘密码用单用户，系统坏了用救援模式。

【② 原理 / 对照】
1) 传统 runlevel（CentOS 6 及更早）
0 关机 ｜ 1 单用户（仅 root、无网络，改密码/修复用）｜ 2 多用户无 NFS ｜ 3 完整多用户字符（服务器默认）
4 保留 ｜ 5 图形 ｜ 6 重启
命令：runlevel、who -r、init 0/3/5/6；默认级别写在 /etc/inittab：id:3:initdefault:

2) systemd target（CentOS 7+/Ubuntu 16.04+）
poweroff(0) ｜ rescue(1) ｜ multi-user(3，服务器默认) ｜ graphical(5) ｜ reboot(6) ｜ emergency(比 rescue 更精简)
命令：
systemctl get-default                          # 查看默认目标
systemctl set-default multi-user.target         # 设置默认
systemctl isolate rescue.target                 # 立即切换
systemctl list-dependencies multi-user.target   # 查看目标依赖的服务
启动链：sysinit.target → basic.target → multi-user.target

3) 单用户模式重置 root 密码（CentOS 7/9 通用）
① 开机到 GRUB 菜单，选中默认内核按 e 进入编辑；
② 找到 linux16（CentOS 7）/ linux（CentOS 9）开头的行，做两处修改：
   - 把 ro 改成 rw（让根分区可写）
   - 行尾追加 init=/bin/bash
③ Ctrl + X 启动，直接拿到免密的 root bash；
④ 改密码：passwd root
⑤ ★SELinux 机器必须执行：touch /.autorelabel（否则重启后登录失败）
⑥ exec /sbin/init 正常启动（会自动做 SELinux 重新标记，需等几分钟）。
Ubuntu 区别：默认没有 root 登录，改的是普通用户密码，或先启用 root。

4) 救援模式：rescue vs emergency
- rescue.target：会挂载根分区、起少量基础服务、有基本工具
  → 修 fstab、修文件系统、重装 grub 都用它。
- emergency.target：根分区只读、几乎无服务、工具极少 → fstab 挂载失败时系统会自动掉进来。
进入方式：
- GRUB 菜单在内核行末尾加 systemd.unit=rescue.target，Ctrl+X，输入 root 密码；
- 或系统正常时执行 systemctl isolate rescue.target。
典型修复场景：
- fstab 写错导致开机卡住 → rescue 下编辑 /etc/fstab 注释掉错误项
- 文件系统损坏 → xfs_repair /dev/sda1 或 fsck.ext4
- GRUB 引导损坏 → 重新安装 grub2

【④ 易错点】
- ro 忘改成 rw → 根分区只读，passwd 根本写不进去。
- ★漏了 touch /.autorelabel → SELinux 环境下重启后直接登录失败（这是最常见的翻车点）。
- 改完密码不执行 exec /sbin/init 而直接断电 → SELinux 标记没做，同样可能登不上。

【⑤ 🎯 面试考点】
🎯 CentOS 7 前后运行级别的区别？
  7 前用数字 runlevel（配在 /etc/inittab）；7+ 用 systemd target，是 runlevel 的升级版，支持并行启动。
🎯 multi-user.target 和 graphical.target 对应哪个 runlevel？ → 分别是 3 和 5。
🎯 单用户改密的核心三步？ → ro 改 rw、加 init=/bin/bash、SELinux 机器 touch /.autorelabel。
🎯 单用户和 rescue 分别什么时候用？
  单用户 = 单纯忘密码；rescue = fstab/磁盘/系统文件损坏等严重启动故障。
🎯 emergency 模式特点？ → 根分区只读、几乎无服务，挂载异常时系统自动进入。
```

### 1.5 SSH 远程连接与安全加固 ★★

```md
【① 一句话本质】
SSH 是加密的远程登录协议（默认 TCP 22），用"非对称加密协商密钥 + 对称加密传数据"，替代明文 Telnet。

【② 原理】
1) 两层加密
- 传输层（握手）：客户端与服务端先用非对称算法（RSA/ECDSA）交换会话密钥，
  之后全部数据改用对称加密（AES）传输 —— 兼顾安全与速度。
- 认证层：密码认证 或 密钥对认证。
2) 连接流程
  TCP 连 22 端口 → 服务端发送主机公钥 → 协商算法、生成临时会话密钥 → 客户端发起认证 → 建立加密 Shell。
3) 主机指纹
  首次连接提示是否信任，确认后指纹存入客户端 ~/.ssh/known_hosts；
  以后指纹对不上（服务器重装、IP 复用）SSH 会直接拒绝连接 → 防止中间人劫持。

【③ 命令与工具】
终端工具：Xshell（功能最全，企业首选）、MobaXterm（自带 sftp 和 Linux 小工具）、
FinalShell（国产，带服务器监控面板）；Windows 10 1809+ 的 PowerShell/cmd 与 Mac/Linux 自带 ssh/scp/sftp。

ssh root@192.168.1.100              # 密码登录
ssh root@192.168.1.100 -p 2222      # 指定端口
ssh root@192.168.1.100 "df -h"      # 远程执行单条命令，不进交互
scp local.file root@ip:/tmp/        # 上传
scp root@ip:/tmp/test.txt ./        # 下载
scp -r /data root@ip:/data/         # 传目录（加 -r）

免密登录三步（客户端执行）：
ssh-keygen -t rsa                   # 生成密钥对（可加 -b 4096 提高强度）
ssh-copy-id root@192.168.1.100      # 一键推送公钥到服务端
ssh root@192.168.1.100              # 免密验证
没有 ssh-copy-id 时手动推：
cat ~/.ssh/id_rsa.pub | ssh root@ip "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

【④ 易错点：权限（免密失败最常见原因）】
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 755 ~            # 家目录不能是 777，否则密钥校验直接失败
私钥 id_rsa 权限必须 600，且绝不外泄。

【⑤ 生产安全加固（/etc/ssh/sshd_config，改完 systemctl restart sshd / ssh）】
PasswordAuthentication no     # ★关闭密码登录，只允许密钥（最重要）
Port 22345                    # 改默认端口（记得防火墙放行新端口）
PermitRootLogin no            # 禁止 root 直接远程登录，改用普通用户 + sudo
AllowUsers admin user01       # 登录用户白名单
PermitEmptyPasswords no       # 禁空密码
ClientAliveInterval 300 / ClientAliveCountMax 3               # 5 分钟无操作自动断开
KexAlgorithms diffie-hellman-group-exchange-sha256,ecdh-sha2-nistp256
MACs hmac-sha2-256,hmac-sha2-512                              # 禁用弱 DH / 弱 MAC 算法
MaxAuthTries 3 / MaxSessions 5                                # 防暴力爆破
ssh-keygen -t ed25519                                         # 更强的密钥（或 rsa -b 4096）
配套策略：防火墙只放行指定源 IP、部署 fail2ban 自动封爆破 IP、
定期审计 /var/log/secure（CentOS）或 /var/log/auth.log（Ubuntu）、ssh-keygen -p 给私钥加密码保护。

【⑥ 关键文件清单】
服务端：/etc/ssh/sshd_config（主配置）、/etc/ssh/ssh_host_*（主机密钥对）、
        /etc/ssh/moduli（DH 参数）、/etc/pam.d/sshd（PAM 认证配置）
客户端：~/.ssh/id_rsa + id_rsa.pub、id_ed25519（+ .pub）、~/.ssh/known_hosts（主机指纹）、
        ~/.ssh/config（快捷配置：Host/HostName/User/Port/IdentityFile，配完 ssh web01 直连）
服务端认证文件：~/.ssh/authorized_keys（一行一个客户端公钥）

【⑦ 🎯 面试考点】
🎯 SSH 为什么比 Telnet 安全？
  SSH 数据全程对称加密传输、身份用非对称密钥校验；Telnet 明文传账号密码，抓包即泄露。
🎯 免密登录的核心文件与权限？
  客户端私钥 id_rsa(600)；服务端 authorized_keys(600)、.ssh 目录 700、家目录不能 777。
🎯 生产最优 SSH 安全策略？
  改端口 + 禁 root 远程 + 关密码登录（仅密钥）+ 用户白名单 + 防火墙限源 IP + fail2ban。
🎯 首次连接的指纹提示有什么用？
  校验服务器主机公钥，防止中间人劫持，避免连到钓鱼服务器。
🎯 免密登录失败怎么排查？
  ①网络/端口通不通 ②sshd_config 是否开启 PubkeyAuthentication yes
  ③服务端 .ssh 与 authorized_keys 权限 ④公钥是否完整写入 ⑤SELinux 是否拦截（CentOS 常见）
```

---

## 模块2：文件系统与目录结构（底层核心，一切皆文件）

**定位**：Linux 最核心的哲学——一切皆文件，所有操作都基于文件体系，必须吃透原理。

### 核心知识点

- ★ FHS 目录层级标准：`/etc /var /usr /proc /sys /dev /tmp /home /root` 等核心目录的作用
- ★ 七种文件类型识别：普通文件、目录、软/硬链接、块设备、字符设备、管道、套接字
- ★★ **inode 与 block 底层原理**：存储结构、硬链接本质、磁盘满的两种场景（inode 耗尽 / block 耗尽）
- 文件基础操作：`ls/cd/pwd/mkdir/touch/cp/mv/rm/ln/file/stat`
- ★ 通配符与基础正则（BRE / ERE）的区别与用法
- ★ `/proc` 与 `/sys` 伪文件系统：查看内核参数与系统状态的入口

**学习目标**

看到目录名就知道用途，能清晰区分软硬链接，理解 inode 原理，熟练完成文件日常操作。

### 2.1 FHS 目录层级标准 ★

```md
【① 一句话本质】
FHS 规定所有发行版统一的目录用途；Linux 一切皆文件，目录就是"文件的组织地图"。

【② 核心目录逐条】
- /etc：★系统全局静态配置（纯文本，改完重载生效，不含二进制）
  passwd / shadow 账号密码、sshd_config、yum.repos.d 软件源、fstab 挂载表、
  ifcfg-ens33 网卡配置、crontab 系统定时任务
  特点：重装系统会丢失，重要配置必须备份。
- /var：可变数据（运行期不断写入，★磁盘占用大户）
  /var/log 全系统日志 ｜ /var/lib 服务持久化数据（MySQL 库、Redis 数据、rpm 数据库）
  /var/run PID 文件与 socket（软链到 /run）｜ /var/tmp 长期临时 ｜ /var/spool 队列（打印、邮件）
- /usr：操作系统软件资源（≈ Windows 的 Program Files）
  /usr/bin 普通命令（ls、cat、awk、curl）｜ /usr/sbin 管理员命令（systemctl、fdisk、iptables）
  /usr/lib、/usr/lib64 动态库 .so ｜ /usr/share 文档、模板、时区
  ★/usr/local 源码编译安装默认位置（自建程序，不会被 yum/apt 升级覆盖）
- /boot：启动文件（vmlinuz 内核、initramfs、grub 配置）
  ★必须单独分区约 1G，这个分区满了会直接无法开机。
- /dev：设备文件（硬件抽象成文件，读写文件 = 操作硬件）
  块设备 b（带缓存、按块读写）：/dev/sda 磁盘、/dev/sda1 分区、/dev/cdrom
  字符设备 c（无缓存、按字节流式）：/dev/tty0 终端、/dev/null 黑洞、/dev/zero 无限 0（造 swap 用）、
  /dev/random 与 /dev/urandom 随机熵池
- /tmp：临时文件，所有用户可读写，★重启自动清空，10 天未访问的文件会被系统定时清理
- /home：普通用户家目录集合（~/.ssh、~/.bashrc、文档、代码都在这）
- /root：root 专属家目录，权限 700，普通用户无法访问（注意 root 不在 /home 下）
- /mnt：管理员临时手动挂载（U 盘、移动硬盘、共享存储）
- /media：桌面系统自动挂载外设（U 盘、光盘）
- /lib、/lib64：系统启动必备的底层动态库（/usr/lib 则是应用库）

【③ 速记口诀】
/etc 静态配置 ｜ /var 动态日志数据 ｜ /usr 系统软件命令 ｜ /proc 进程内核参数 ｜ /sys 硬件驱动 ｜
/dev 设备文件 ｜ /tmp 临时重启清 ｜ /home 普通用户 ｜ /root 管理员 ｜ /boot 启动内核

【⑤ 🎯 面试考点】
🎯 /var 和 /usr 的区别？
  /var 放运行期不断变化的数据（日志、服务数据）；/usr 放系统安装的软件、命令与库。
🎯 源码编译的软件装哪里？为什么？
  /usr/local —— 与包管理器安装的软件隔离，避免被 yum/apt 升级覆盖。
🎯 /boot 为什么要单独分区？
  放内核与引导文件；被日志或业务数据撑满会直接导致开不了机，单独分区可隔离风险。
```

### 2.2 七种文件类型与软硬链接 ★

```md
【① 一句话本质】
`ls -l` 第一个字符就是文件类型；七类里最常考的是软链接与硬链接的区别。

【② 类型速览】
1) 普通文件 `-`：文本文件（.txt/.sh/.conf）、二进制程序（/bin/ls）、数据文件（日志、压缩包）
2) 目录 `d`：本质是一张"文件名 → inode"映射表；★目录必须有 x 权限才能进入
3) 硬链接（无独立类型符号，显示同 `-`）：多个文件名指向同一个 inode
   - 删掉其中一个，只要链接计数 > 0，数据就不丢
   - 限制：不能跨分区（各分区 inode 表独立）、不支持目录（防止循环递归）
   - 查看：`ls -l` 第二列是链接计数；`ls -i` 中 inode 相同即为硬链接
   - 创建：ln source.txt hardlink.txt
4) 软链接 `l`：★有独立 inode，文件内容只保存目标路径字符串（≈ Windows 快捷方式）
   - 可跨分区、可链接目录；源文件删除或移动后失效（broken link）
   - 文件大小 = 目标路径的字符长度；创建：ln -s source.txt softlink.txt
5) 块设备 `b`：带缓冲、按块读写 → 磁盘、分区、光驱
   形如：brw-rw---- 1 root disk 8, 0 /dev/sda
6) 字符设备 `c`：无缓冲、按字节流式 → /dev/null、/dev/tty0、终端
7) 管道 FIFO `p`：mkfifo 创建，单向先进先出的进程间通信，不占磁盘空间
8) socket 套接字 `s`：本地双向 IPC，如 /var/run/mysqld/mysqld.sock

【③ 判别命令】
ls -l 文件名     # 看首字符判类型
file 文件名      # 精确识别文件类型
ls -i 文件名     # 看 inode 号（判硬链接）
stat 文件名      # 看 inode、链接数、设备号、三个时间

【④ 易错点】
- 目录只给 w 不给 x → 依然删不了里面的文件；★进目录必须要 x 权限。
- 软链接用相对路径时，一旦链接文件被移动就会失效；生产环境建议用绝对路径。

【⑤ 🎯 面试考点：硬链接 vs 软链接】
1) inode：硬链接共享同一个 inode；软链接有独立 inode
2) 跨分区：硬链接不行；软链接可以
3) 链接目录：硬链接不允许；软链接可以
4) 删除源文件：硬链接数据仍保留（计数 -1）；软链接直接失效
5) 文件大小：硬链接与源文件一致；软链接大小 = 目标路径字符串长度
```

### 2.3 inode 与 block 底层原理 ★★

```md
【① 一句话本质】
分区格式化后分成两片：inode 区存"文件属性"，block 区存"真实内容"；★文件名不在 inode 里，而存在目录的 block 中。

【② 原理】
1) block：最小读写单位（常见 4K）；大文件占多个 block，小文件也至少占 1 个（所以会有空间浪费）
2) inode：每个文件唯一对应一个 inode，★只存元数据，不存文件名：
   文件大小、权限 rwx、属主属组、三个时间（atime 访问 / mtime 内容修改 / ctime 属性变更）、
   文件类型、数据 block 指针、硬链接计数
3) 文件名存在哪？ → 存在"目录的 block"里，目录本身就是 `文件名 → inode号` 的映射表
4) 打开文件的三步：
   进目录读 block 找到 inode 号 → 读 inode 拿属性与指针 → 按指针读真实数据块
5) 硬链接本质：ln a.txt link_a.txt → 两个文件名共用一个 inode，计数 +1；
   删一个计数 -1，计数 > 0 数据不丢；不能跨分区、不能链目录。

【③ 磁盘满的两种情况（★生产高频故障）】
情况 1：block 耗尽（最常见）
  - 现象：df -h 显示 100%，touch 新建文件报 No space left on device
  - 原因：大日志、业务数据占满数据块
  - 处理：清理大文件，释放 block 空间
情况 2：inode 耗尽（★磁盘明明还有空间，却建不了文件）
  - 现象：df -h 只用了 50%，但 df -i 显示 100%，touch 依然报 No space left on device
  - 原因：海量小文件（百万级碎缓存、空日志）把 inode 号用光（格式化时 inode 数量固定）
  - 处理：批量删除细碎小文件，释放 inode

【④ 配套命令】
ls -i test.txt          # 查看文件 inode 号
df -i                   # 查看分区 inode 使用率（判断是否 inode 耗尽）
stat test.txt           # 查看 inode 详细信息
find . -inum 131073     # 按 inode 号找文件（找硬链接的"同伴"）
ls -A | wc -l           # 统计目录下文件数（判断 inode 消耗）

【⑤ 🎯 面试考点】
🎯 文件名存在哪里？ → 存在目录的 block 里，inode 本身不存文件名。
🎯 磁盘满了但 df -h 显示没满，为什么？ → inode 耗尽，用 df -i 确认，清理小文件。
🎯 硬链接为什么不能跨分区？ → 每个分区的 inode 表独立，inode 号不通用。
🎯 df 显示满、du 却很小是怎么回事？ → 文件被删除但句柄仍被进程占用（空间未释放），
   用 lsof | grep deleted 找出占用进程，重启或清空该进程。
```

### 2.4 文件基础操作命令

```md
【① 一句话本质】
日常 90% 的操作就是增删改查，下面是带高频参数的命令速查。

【③ 命令速查】
pwd                                    # 打印当前工作目录
cd /tmp ｜ cd ~ ｜ cd - ｜ cd .. ｜ cd ../data
ls ｜ ls -l（长格式）｜ ls -lh（人类可读）｜ ls -a（含隐藏）｜ ls -i（显 inode）｜ ls -ld /etc（看目录自身）
mkdir test_dir ｜ mkdir -p parent/child/grandson ｜ mkdir -m 700 secure_dir
touch test.txt ｜ touch file{1..5}.txt（批量）
cp test.txt /tmp/ ｜ cp test.txt /tmp/new.txt（改名复制）｜ cp -r dir /tmp/（递归）
  cp -p（保留权限与时间戳）｜ cp -i（覆盖前询问）
mv test.txt new.txt（同目录=重命名）｜ mv new.txt /tmp/（跨目录=移动）
rm test.txt ｜ rm -i（询问）｜ rm -rf dir（★递归强制，生产高危）
ln test.txt hard.txt（硬链接）｜ ln -s test.txt soft.txt（软链接）
file test.txt ｜ file /dev/sda
stat test.txt

【④ 易错点】
- ★rm -rf 是运维第一高危命令，执行前先 ls 确认路径，生产建议先 mv 到临时目录再删。
- cp 复制目录必须加 -r，否则会静默跳过目录（不报错，但没复制成功）。
- mv 跨目录时若目标有同名文件会直接覆盖，重要文件建议先用 cp -i。
```

### 2.5 通配符与正则表达式 ★

```md
【① 一句话本质】
★通配符匹配"文件名"（由 Shell 解析）；正则匹配"文本内容"（由 grep/sed/awk 解析）——两者别混用。

【② 通配符（文件名场景）】
*   任意长度字符：ls *.txt、ls test*
?   单个任意字符：ls file?.txt（不匹配 file10.txt）
[]  括号内任一字符：file[123].txt、file[a-z].txt、file[0-9].txt、file[!0-9].txt（! 取反）
{a,b,c} 枚举：file{1,2,3}.txt
扩展（需 shopt -s extglob）：?(pattern) 0或1次 ｜ *(pattern) 0或多次 ｜ +(pattern) 1或多次 ｜ !(pattern) 取反

【③ 基础正则 BRE（grep / sed 默认，元字符要转义）】
. 任意单字符 ｜ * 前一字符 0 或多次 ｜ ^ 行首 ｜ $ 行尾 ｜ [] 字符集、[^] 取反
\(\) 分组 ｜ \{n\} \{n,\} \{n,m\} 次数 ｜ \ 转义
grep '^root' /etc/passwd          # 以 root 开头的行
grep 'bash$' /etc/passwd          # 以 bash 结尾的行
grep 'r..t' /etc/passwd           # r + 任意两字符 + t
grep 'ro*t' test.txt              # rt / rot / rooot
grep '[0-9]\{3\}' test.txt        # 连续 3 位数字
grep '\(ab\)\{2\}' test.txt       # abab
grep '^$' file                    # 空行

【④ 扩展正则 ERE（grep -E / sed -r / awk，元字符原生生效）】
+ 1 次以上 ｜ ? 0 或 1 次 ｜ | 或 ｜ () 分组 ｜ {n,m} 次数
grep -E 'ro+t' test.txt           # rot / rooot
grep -E 'ro?t' test.txt           # rt / rot
grep -E 'root|nginx' file         # 匹配 root 或 nginx
grep -E '(abc){2,3}' test         # abcabc / abcabcabc
grep -E '[0-9]{1,3}' test         # 1~3 位数字

【⑤ 🎯 面试考点：三者区分】
- 通配符：只匹配文件名，由 Shell 解析（* ? []）
- BRE：grep / sed 默认，() {} + ? | 都要加反斜杠转义
- ERE：grep -E / sed -r / awk，元字符直接使用，无需转义
速记：匹配文件名 → 通配符；过滤文本 → 正则（不加参数 = BRE 需转义，加 -E/-r = ERE 直接写）
```

### 2.6 /proc 与 /sys 伪文件系统 ★

```md
【① 一句话本质】
两者都是"内存里的伪文件系统"，是内核对外暴露状态的窗口：读 = 看状态，写 = 临时改参数（重启失效）。

【② 共同特点】
- 只存在于内存，没有真实磁盘文件，重启后全部丢失；
- 开机由内核自动挂载，不需要写进 /etc/fstab；
- 读：查看系统 / 硬件 / 进程状态；写：临时修改内核参数（立即生效，重启失效）。

【③ /proc：进程 + 全局内核参数】
进程维度（数字目录 = PID）：
  /proc/PID/cmdline 启动命令 ｜ /proc/PID/status 内存、线程、UID、状态
  /proc/PID/fd/ 该进程打开的所有文件句柄 ｜ /proc/PID/mem 虚拟内存 ｜ /proc/PID/cwd 当前工作目录
全局维度：
  /proc/cpuinfo CPU 信息 ｜ /proc/meminfo 内存 ｜ /proc/loadavg 1/5/15 分钟负载
  /proc/version 内核版本 ｜ /proc/mounts 挂载点 ｜ /proc/diskstats 磁盘 IO
  /proc/net/tcp、/proc/net/udp 网络连接 ｜ /proc/interrupts 中断信息
可调参数 /proc/sys/：
  echo 1 > /proc/sys/net/ipv4/ip_forward      # 开启 IP 转发（网关 / NAT 必备）
  echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse    # TCP 连接回收
  cat /proc/sys/vm/dirty_ratio                # 内存脏页写入阈值
  ★永久生效：写进 /etc/sysctl.conf，再执行 sysctl -p

【④ /sys：硬件、总线、驱动（比 /proc 更规范）】
/sys/block  块设备：cat /sys/block/sda/queue/scheduler 看 IO 调度算法
/sys/class  硬件分类：cat /sys/class/net/ens33/speed 看网卡速率
/sys/bus    总线（pci、usb）｜ /sys/devices 完整硬件设备树 ｜ /sys/fs 文件系统与 cgroup
特点：格式标准化（单值或短字符串，便于程序读取）；
★udev 靠 /sys 识别硬件并生成 /dev 下的设备文件；可修改 IO 调度、网卡节能等硬件策略。

【⑤ 两者对比（面试必背）】
- /proc：管进程、系统负载、内核网络与内存运行参数；早期调试接口，格式较杂乱；运维手动查看为主
- /sys：管磁盘、网卡、PCI、USB 等物理硬件；标准化硬件管理接口；使用者是 udev、systemd、硬件管理程序
- 能否改硬件属性：/proc 几乎不能；/sys 可以（IO 调度、网卡参数）

【⑥ 🎯 面试考点】
🎯 修改 /proc/sys 参数重启就失效，怎么办？ → 写入 /etc/sysctl.conf，再 sysctl -p 永久生效。
🎯 udev 靠哪个文件系统识别硬件生成 /dev？ → /sys。
🎯 想看某个进程打开了哪些文件？ → /proc/进程PID/fd。
🎯 查看或修改磁盘 IO 调度器去哪？ → /sys/block/sda/queue/scheduler。
🎯 这两个目录的数据存在磁盘上吗？ → 不存在，全部驻留内存，重启清空。
口诀：/proc 管进程、负载、内核网络内存参数；/sys 管磁盘网卡各类物理硬件。
```

---

## 模块3：用户、权限与安全基础（运维安全底线）

**定位**：日常操作高频使用，★权限配置错误是生产事故重灾区，也是面试问得最密的一块。

### 核心知识点

- ★ 用户管理：`useradd/usermod/userdel/passwd`、`/etc/passwd` 与 `/etc/shadow` 结构解析
- ★ 用户组管理：`groupadd/groupmod/groupdel`、`/etc/group`、主组与附加组
- ★★ **基础权限 rwx**：符号法、数字法、`chmod/chown/chgrp`、umask
- ★ 特殊权限：SUID / SGID / Sticky Bit 的作用、风险与配置
- ACL 精细权限：`setfacl/getfacl`
- ★★ sudo 提权：`/etc/sudoers`、visudo、最小权限原则
- SELinux 基础：三种模式、切换、上下文与排障

**学习目标**

能灵活管理用户与权限，遵循最小权限原则配置生产环境，理解各类权限的适用场景。

### 3.1 用户管理与两个核心文件 ★

```md
【① 一句话本质】
用户 = /etc/passwd 里的一行记录 + /etc/shadow 里的一行密文；命令只是帮你改这两个文件。

【③ 命令速查】
1) useradd 创建
useradd test                                              # 自动建同名组、家目录 /home/test
useradd -u 1005 -g dev -G docker,nginx -m -s /bin/bash admin   # ★生产标准写法
useradd -r nginx                                          # 系统用户（无家目录，UID<1000，跑服务用）
参数：-u UID ｜ -g 主组 ｜ -G 附加组 ｜ -m 建家目录 ｜ -s 登录 shell ｜ -r 系统用户

2) usermod 修改
usermod -l newuser olduser        # 改用户名
usermod -d /home/new -m newuser   # 改家目录并迁移原文件
usermod -u 1010 newuser           # 改 UID
usermod -g ops newuser            # 改主组
usermod -aG docker newuser        # ★追加附加组（-a 必须加，否则覆盖原有附加组）
usermod -s /sbin/nologin newuser  # 禁止登录
usermod -L test / usermod -U test # 锁定 / 解锁

3) userdel 删除
userdel test        # 只删用户，保留家目录
userdel -r test     # 连家目录、邮件一起删（彻底清理）

4) passwd 密码
passwd                                # 改自己的密码
passwd test                           # root 改指定用户
echo "123456" | passwd --stdin test   # 非交互（脚本用）
passwd -l test / passwd -u test       # 锁 / 解锁
passwd -S test                        # 看密码状态
passwd -x 7 test                      # 7 天后过期

【② /etc/passwd 结构（全局可读，7 段）】
格式：用户名 : 密码占位符x : UID : GID : 注释 : 家目录 : 登录Shell
示例：root:x:0:0:root:/root:/bin/bash
- UID：0 = 超级管理员 root；1~999 = 系统用户（跑进程，不可登录）；≥1000 = 普通可登录用户
- ★UID 为 0 的任何账号都等价 root 权限
- Shell：/bin/bash 可交互登录；/sbin/nologin、/bin/false 禁止登录
  （区别：nologin 会提示账号不可登录；false 无任何提示直接断开）

【② /etc/shadow 结构（★仅 root 可读，9 段）】
格式：用户名:加密密码:最后改密天数:最小间隔:最大有效期:提前提醒:过期宽限:账号过期:保留
示例：root:$6$xxxx$xxxx:18900:0:99999:7:::
- $6$ = SHA-512 算法；中间是盐值；末尾是哈希；!! 或 ! 表示账号锁定/无密码
- 18900 = 从 1970-01-01 到上次改密码的天数
- ★权限必须严格（-rw-------）：普通用户可读就能暴力破解哈希

【④ 易错点】
- usermod -G 不加 -a → 直接覆盖用户原有全部附加组，导致权限丢失（★高频事故）。
- groupdel 删不掉组 → 有用户把它当主组，需先 usermod -g 改掉主组。
- 想禁止登录别直接删用户，改成 /sbin/nologin 更安全（保留文件属主）。

【⑤ 🎯 面试考点】
🎯 /etc/passwd 里的 x 是什么？
  密码占位符，启用影子密码机制，真密文转移到仅 root 可读的 shadow，提升安全性。
🎯 shadow 文件权限为什么要严格？
  存的是加密哈希，普通用户可读就会被暴力破解，所以只有 root 能读写。
```

### 3.2 用户组管理与主组 / 附加组 ★

```md
【① 一句话本质】
主组决定"新建文件属于哪个组"（唯一）；附加组决定"你额外拥有哪些权限"（可多个）。

【③ 命令速查】
groupadd ops              # 建组
groupadd -g 2000 docker    # 指定 GID
groupadd -r nginx          # 系统组（GID<1000）
groupmod -g 2001 docker    # 改 GID
groupmod -n dev ops        # 改组名
groupdel dev               # 删空组（有用户以其为主组则删不掉）
groups admin               # 看用户所有组
id admin                   # 看 UID/GID/附加组（最常用）

【② /etc/group 结构（4 段）】
格式：组名 : 密码占位符x : GID : 附加组成员列表
示例：docker:x:2000:admin,www
★最后一列只列"把该组当附加组"的用户，不列以它为主组的用户。

【② 主组 vs 附加组】
- 主组（Primary）：用户创建时默认生成同名组；记录在 /etc/passwd 第 4 列 GID；
  ★新建文件/目录的默认属组就是主组；一个用户只能有 1 个主组。
- 附加组（Supplementary）：用于追加权限（docker、sudo、nginx）；记录在 /etc/group 最后一列；
  可以有很多个；★修改必须带 -a 追加。

【④ 易错点】
- usermod -g 改主组、-G 改附加组，两个别混；-G 不加 -a 会清空原有附加组。
- /etc/group 里看不到某用户，不代表他不属于该组 —— 可能该组是他的主组。

【⑤ 🎯 面试考点】
🎯 /etc/group 最后一列是什么用户？ → 仅附加组成员，不含以该组为主组的用户。
🎯 新建文件的属组由谁决定？ → 用户的有效主组（id 命令里的 gid）。
🎯 -g 和 -G 的区别？ → -g 改唯一主组；-G 设置附加组列表，不加 -a 会覆盖。
```

### 3.3 基础权限 rwx 与 umask ★★

```md
【① 一句话本质】
9 位权限分三段（属主 u / 属组 g / 其他 o），每段 r=4 w=2 x=1；★目录的 x 是"进入权"，不是"执行"。

【② rwx 在文件与目录上的区别（★最常考）】
- r 读 (4)：文件 = 读内容；目录 = 列出目录内文件名（ls）
- w 写 (2)：文件 = 修改/覆盖内容；目录 = 创建、删除、重命名目录内文件
- x 执行 (1)：文件 = 可作为程序运行；目录 = 可 cd 进入、可看文件详情
★关键坑：目录只有 w 没有 x，依然删不了里面的文件；进入目录必须要有 x。

【③ 两种表示与常用组合】
符号法：u/g/o/a + + - =
  chmod u+x test.sh ｜ chmod o-w test.txt ｜ chmod a+r test.txt
  chmod u=rwx,g=r,o=r test.txt
数字法（r4 w2 x1，三位分别代表 u g o）
  644 rw-r--r--  普通文件、配置文件
  755 rwxr-xr-x  目录、脚本程序
  600 rw-------  私钥、隐私文件
  700 rwx------  私密目录、~/.ssh
  777 rwxrwxrwx  ★生产严禁使用

【③ 核心命令】
chmod 755 test.sh ｜ chmod -R 755 /data/www（递归）
chown admin test.txt ｜ chown admin:ops test.txt ｜ chown -R admin:ops /data/www
chgrp nginx test.log ｜ chgrp -R nginx /var/log/nginx

【③ umask：新建文件/目录的默认权限】
原理：系统用"权限最大值"减去 umask
- 文件最大 666（新文件默认不带执行位）→ 666 - umask
- 目录最大 777 → 777 - umask
例（umask 022，CentOS 默认）：新文件 644、新目录 755
umask              # 查看（常见 0022，首位 0 是特殊权限位）
umask 027          # 临时设置（收紧属组写权限）
永久：写进 /etc/profile.d/ 下的脚本

【④ 易错点】
- chmod -R 777 是典型错误操作，等于把系统门户大开。
- chown 改属主属组、chmod 只改权限位，别混用。
- umask 越大权限越紧，0027 会封掉属组的写权限，共享目录要谨慎。

【⑤ 🎯 面试考点】
🎯 目录缺少 x 权限会怎样？ → 无法 cd 进入，无法 ls -l 看详情；只有 w 无 x 也删不了文件。
🎯 数字权限怎么算？ → r=4 w=2 x=1，三段分别算 u/g/o 后拼接。
🎯 chmod / chown / chgrp 区别？ → 改权限位 / 改属主属组 / 只改属组。
🎯 生产常用权限？ → 配置 644、目录与程序 755、私钥 600、.ssh 目录 700。
```

### 3.4 特殊权限 SUID / SGID / Sticky ★

```md
【① 一句话本质】
普通 rwx 管"谁能读写执行"；三个特殊权限管"执行时临时借谁的身份"以及"公共目录谁能删"。

【② 数值与标识】
八进制第 1 位：SUID=4 ｜ SGID=2 ｜ Sticky=1
ls -l 表现：
- SUID：属主执行位 x → s（无 x 则显示大写 S，表示失效）
- SGID：属组执行位 x → s（大写 S 同理失效）
- Sticky：其他用户执行位 x → t（大写 T 表示失效）

【② 逐个说明】
1) SUID（★仅对二进制可执行文件生效，目录无效）
   - 作用：普通用户执行该程序时，临时获得"文件属主"的身份权限
   - 经典：/usr/bin/passwd —— 属主是 root，普通用户改密码要写仅 root 可写的 /etc/shadow，
     靠 SUID 临时拿到 root 权限，改完即收回
   - chmod 4755 file ｜ chmod u+s file ｜ chmod u-s file
   - ★风险：自定义程序设 root SUID，一旦有漏洞就能本地提权；
     排查危险文件：find / -perm -4000 2>/dev/null

2) SGID（文件 + 目录都生效）
   - 文件：执行时临时获得文件所属组权限（很少用）
   - ★目录（运维高频）：该目录下新建的文件/子目录自动继承目录的属组
     → 多人协作共享目录必备（不用手动 chgrp）
   - chmod 2770 /data/share ｜ chmod g+s ｜ chmod g-s
   - 查找：find / -perm -2000 2>/dev/null

3) Sticky Bit（★仅目录生效）
   - 作用：目录下每个用户只能删除/改名"自己创建"的文件，不能删别人的
   - 经典：/tmp 默认 1777
   - chmod 1777 /tmp ｜ chmod o+t ｜ chmod o-t
   - 查找：find / -perm -1000 -type d 2>/dev/null

【③ 组合写法】
chmod 6755 test.bin   # SUID + SGID
chmod 3770 share      # SGID + Sticky
chmod 7777 test       # 三者全开

【④ 易错点：ls -l 末尾的 + 和 .】
- 末尾 `+`：该文件配了 ACL（用 getfacl 看，setfacl -b 清除）
- 末尾 `.`：存在 SELinux 安全标签（ls -Z 查看，chcon 可改）
- 第 10 位 t = Sticky；第 4 位 s = SUID

【⑤ 🎯 面试考点】
🎯 passwd 为什么有 SUID？ → 普通用户无权写 /etc/shadow，靠 SUID 临时获得 root 权限改密码。
🎯 SGID 作用在目录上有什么用？ → 新建文件自动继承目录属组，多人共享目录必备。
🎯 Sticky Bit 作用？哪个目录默认有？ → 防止删他人文件；/tmp 默认 1777。
🎯 SUID 最大安全隐患？ → 自定义程序配 root SUID 可本地提权，需定期扫 4000 权限文件。
🎯 s/S、t/T 大小写区别？ → 小写表示原本有 x 执行权限（生效）；大写表示无 x，特殊权限失效。
```

### 3.5 ACL 精细权限

```md
【① 一句话本质】
ugo 只能分三类人，ACL 可以"单独给某个用户或某个组"开小灶；ls -l 末尾出现 + 就说明配了 ACL。

【③ 命令速查】
getfacl /edu                       # 查看完整 ACL 规则
setfacl -m u:zhangsan:rwx /edu     # 给单个用户授权
setfacl -m g:dev:r-- /edu          # 给单个组授权
setfacl -m m:rwx /edu              # 修改 mask 掩码
setfacl -R -m u:zhangsan:rwx /edu  # 递归
setfacl -d -m u:zhangsan:rwx /edu  # ★默认 ACL：目录内新建文件自动继承
setfacl -x u:zhangsan /edu         # 删单条
setfacl -b /edu                    # 清空全部 ACL（+ 号消失）
getfacl -R /edu > acl_bak.txt      # 备份
setfacl --restore=acl_bak.txt      # 恢复

【② getfacl 输出字段】
file: /edu ｜ owner: root ｜ group: root
user::rwx            属主默认权限
user:zhangsan:r-x    单独给 zhangsan 的权限
group::rwx ｜ group:dev:r--
mask::rwx            ★权限掩码，限制所有 ACL 用户/组能拿到的最大权限
other::r-x

【④ 易错点】
- mask 太小会"截断"权限：mask 是 r-- 时，哪怕给用户配了 rwx，实际也只有读。
- 不加 -d 时，目录里后续新建的文件不会带 ACL —— 共享目录必须配默认 ACL。

【⑤ 🎯 面试考点】
🎯 ls -l 末尾的 + 代表什么？ → 配了 ACL 扩展权限，用 getfacl 查看。
🎯 -d 默认 ACL 的作用？ → 仅对目录生效，新建文件/子目录自动继承 ACL。
🎯 mask 有什么用？ → 限制 ACL 用户与组的最大权限，mask 过小会截断。
🎯 ugo 与 ACL 的区别？ → ugo 只有三类；ACL 可针对任意单个用户/组独立授权。
```

### 3.6 sudo 提权与最小权限原则 ★★

```md
【① 一句话本质】
sudo 让普通用户临时借用 root 权限执行命令；★配置必须用 visudo（带语法校验），
用 vim 改错会直接锁死所有人的 sudo。

【② /etc/sudoers 语法】
格式：用户名/组  主机 =(可切换身份:可切换组)  命令列表 [NOPASSWD:]
系统默认：
root    ALL=(ALL) ALL          # root 全权限
%wheel  ALL=(ALL) ALL          # CentOS：wheel 组成员全权限
%sudo   ALL=(ALL:ALL) ALL      # Ubuntu：sudo 组
字段：% 代表组 ｜ 主机 ALL=本机 ｜ (ALL)=可切到任意用户 ｜ 末尾 ALL=允许全部命令

【③ 常用配置示例】
admin  ALL=(ALL) ALL                       # 完整权限（生产不推荐）
admin  ALL=(ALL) NOPASSWD: ALL             # 免密全权限（★高危）
nginxuser ALL=(ALL) /usr/bin/systemctl restart nginx, /usr/bin/systemctl start nginx
ops  ALL=(ALL) /usr/bin/df, /usr/bin/free  # 只给查看类命令
dev  ALL=(www) ALL                         # 可切到 www 用户执行
%dev ALL=(ALL) /usr/bin/systemctl restart nginx     # 组批量授权
ops  ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx   # 免密单条（推荐）
admin ALL=(ALL) ALL, !/usr/bin/su, !/usr/bin/passwd root, !/bin/rm   # 禁止危险命令
★注意：sudoers 的 ! 只能匹配命令名、不能带参数，写 !/bin/rm -rf / 实际等于禁止所有 rm。

【③ 别名（批量场景）】
Host_Alias LOCAL = localhost,127.0.0.1
User_Alias OPS = zhangsan, lisi
Cmnd_Alias NGINX_CMD = /usr/bin/systemctl start nginx, ...
OPS LOCAL=(ALL) NOPASSWD: NGINX_CMD

【③ 相关命令】
sudo -l                      # 查看当前用户被授予的 sudo 权限
sudo -i / sudo su -          # 切到 root（用自己密码，不需要 root 密码）
sudo -u www python app.py    # 以指定用户执行

【④ 最小权限原则（★生产规范，面试必背）】
1) 能给单条命令就不给 ALL
2) ★命令必须写完整绝对路径（写 /usr/bin/systemctl，不写 systemctl，防同名恶意程序绕过）
3) 免密只给自动化脚本/定时任务等刚需场景，人工运维保留密码验证
4) 区分粒度：只给重启服务，不给改配置、删文件
5) 优先用组批量授权，便于维护
6) 禁止普通用户拥有 sudo su / sudo -i 的完整切 root 能力

【⑤ 🎯 面试考点】
🎯 为什么必须用 visudo？ → 自带语法校验；用 vim 存了错配置会让所有 sudo 失效。
🎯 NOPASSWD 的作用与风险？ → 免密提权；风险是账号泄露后攻击者可无限制执行 root 命令。
🎯 最小权限怎么落地？ → 只给必需命令、用绝对路径、不开 ALL、禁用 su/passwd/rm。
🎯 sudo -l 是干什么的？ → 查看当前用户被授予的所有 sudo 权限清单。
```

### 3.7 SELinux 基础

```md
【① 一句话本质】
SELinux 是"强制访问控制 MAC"，在传统 rwx（自主访问控制 DAC）之外再加一层策略拦截；
CentOS/RHEL 默认开启，很多中小业务为了省事直接关闭。

【② 三种模式】
- enforcing 强制：违反策略直接拒绝，并记录到 /var/log/audit/audit.log
- permissive 宽容：不拦截，只记告警日志（★调试排错用）
- disabled 关闭：完全不运行，无上下文、无拦截、无日志

【③ 查看与切换】
getenforce              # 看当前模式
sestatus                # 详细信息
setenforce 0            # 临时切宽容（重启失效）
setenforce 1            # 临时切强制
★无法临时切到 disabled，只能改配置文件后重启
永久：/etc/selinux/config 里改 SELINUX=enforcing|permissive|disabled，★必须重启生效

【③ 上下文与修复】
ls -Z /var/www/html       # 看安全上下文（ls -l 末尾的 . 表示有 SELinux 标签）
restorecon -R /var/www/html        # ★最常用：自动还原目录默认上下文
chcon -R -t httpd_sys_content_t /var/www/html   # 手动改上下文

【④ 排障思路】
1) 服务访问文件/端口被拒绝 → 先 setenforce 0 测试
   - 关了就正常：问题在 SELinux（修上下文或放行策略）
   - 关了仍报错：是防火墙、rwx 权限或程序配置问题
2) 查拦截日志：grep avc: /var/log/audit/audit.log
3) 网站目录、自定义程序目录优先 restorecon -R

【⑤ 生产现状与面试】
- 中小业务普遍关闭以减少兼容问题；等保、金融、高安全场景必须 enforcing。
- 关闭风险：程序漏洞提权后少了这层隔离防护。
🎯 面试精简背诵：
  三种模式（enforcing 拦 / permissive 告警 / disabled 关）；
  setenforce 0/1 临时切换，改 /etc/selinux/config 永久需重启；
  ls -Z 看上下文，权限位末尾 . 表示有 SELinux 标签；
  排障第一步临时切 permissive 验证；修复用 restorecon -R。
```

---

## 模块4：核心命令与文本三剑客（日常吃饭的工具）

**定位**：运维日常工作 80% 的操作都靠命令；★三剑客是"面试 + 生产"双核心。

### 核心知识点

- ★ 文件查看：`cat/more/less/head/tail`（★`tail -F` 与 `-f` 的区别）
- ★★ 文件查找：`find`（按名称/大小/时间/权限，配合 `-exec`/`xargs`）、`locate/which/whereis`
- 压缩打包：`tar`（z/j）、`gzip/bzip2/zip/unzip`
- ★ 系统信息：`uname/hostname/uptime/free/df/du/lscpu`
- ★★ 管道与重定向：`|`、`>`、`>>`、`<`、`2>`、`2>&1`、`/dev/null`
- ★★ 文本三剑客：grep（过滤）、sed（行编辑替换）、awk（列切割统计）
- 辅助工具：`cut/sort/uniq/wc/tr`

**学习目标**

日常操作无需查文档，三剑客能独立完成 90% 的日志分析、文本处理、配置批量修改场景。

### 4.1 文件查看命令 ★

```md
【① 一句话本质】
小文件用 cat，大文件用 less，看头尾用 head/tail，★实时追日志必须用 tail -F（不是 -f）。

【③ 命令速查】
cat test.txt            # 一次性打印全文（只适合小文件）
cat -n test.txt         # -n 显示行号
cat -s test.txt         # -s 把连续空行压缩成一行
more nginx.log          # 基础分页，只能向下翻（空格下一页、回车下一行、q 退出）
less nginx.log          # ★生产推荐：支持上下翻 + 搜索（/关键词，n 下一条，N 上一条，q 退出）
head test.txt           # 默认前 10 行；head -n 20 指定前 20 行
tail test.txt           # 默认后 10 行；tail -n 30 指定末尾 30 行

【④ 易错点：tail -f 与 tail -F（★面试常考）】
tail -f  access.log     # 实时跟踪；★日志被切割/改名后会断流（追的是原 inode）
tail -F  access.log     # ★生产首选：日志滚动、切割、改名依然持续追踪（会重新打开文件）

【⑤ 🎯 面试考点】
🎯 为什么生产用 tail -F 而不是 tail -f？
  日志切割（logrotate）后原文件被改名，-f 还盯着旧 inode 会断流；-F 会重试打开新文件。
```

### 4.2 文件查找 find / locate / which / whereis ★★

```md
【① 一句话本质】
find 是实时遍历磁盘的"万能查找"（重中之重）；locate 查数据库所以快；which/whereis 只找命令。

【③ find 四大查找维度】
按名称：
find /etc -name "hosts"          # 精准查找
find /var/log -name "*.log"      # 通配匹配
find /tmp -iname "test*.txt"     # -iname 忽略大小写
按大小：
find / -size +100M               # 大于 100M（清理大文件常用）
find /tmp -size -10k             # 小于 10k
按时间：
find /tmp -mtime +7              # 7 天前修改过的（清理旧日志）
find /tmp -mtime -1              # 24 小时内修改的
find /data -amin -10             # 10 分钟内被访问的
按权限 / 属主：
find / -perm -4000 2>/dev/null   # ★全局查带 SUID 的高危文件（2>/dev/null 屏蔽报错）
find /home -user root            # 属主为 root 的文件
find /data -perm 777             # 查权限全开的危险文件

【③ find 的两种后续处理】
-exec（{} 代表匹配到的文件，\; 固定结尾）：
find /var/log -name "*.log" -mtime +7 -exec rm -f {} \;      # 删 7 天前旧日志
find /data/www -type f -exec chmod 644 {} \;                 # 批量设 644
xargs（★批量处理效率高于 -exec）：
find /var/log -name "*.log" -mtime +3 | xargs gzip           # 批量压缩
find /tmp -name "tmp*" | xargs rm -rf                        # 批量删除

【③ 另外三个】
locate hosts      # 基于索引数据库，速度快；★新建的文件搜不到时先执行 updatedb
which ls / nginx  # 查可执行命令的绝对路径
whereis nginx     # 查命令的二进制、源码、帮助手册路径

【⑤ 🎯 面试考点】
🎯 如何找出系统里所有带 SUID 的危险文件？ → find / -perm -4000 2>/dev/null
🎯 -exec 和 xargs 哪个效率高？ → xargs（它把多个文件合成一批传给命令，减少进程创建）。
🎯 locate 找不到刚创建的文件怎么办？ → 执行 updatedb 更新索引数据库。
```

### 4.3 压缩打包

```md
【① 一句话本质】
tar 负责"打包"（可带压缩），gzip/bzip2 只压单个文件；★跨 Windows/Linux 传文件用 zip。

【③ 命令速查】
tar 参数：c 创建 ｜ x 解压 ｜ v 显示过程 ｜ f 指定包文件 ｜ -C 指定解压目录
-z（gzip，速度快，后缀 .tar.gz）：
tar -zcvf test.tar.gz /data/test        # 打包压缩
tar -zxvf test.tar.gz -C /tmp           # 解压到 /tmp
-j（bzip2，压缩率更高，后缀 .tar.bz2）：
tar -jcvf test.tar.bz2 /data/test
tar -jxvf test.tar.bz2 -C /tmp

gzip test.txt / gunzip test.txt.gz      # 单文件压缩；★不保留原文件、不支持打包目录
bzip2 test.txt / bunzip2 test.txt.bz2   # 单文件高压缩
zip -r test.zip /data/test              # 跨平台格式，-r 递归目录
unzip test.zip -d /tmp                  # 解压到指定目录

【④ 易错点】
- gzip 压缩后原文件消失，重要文件先备份再压。
- tar 打包目录时若用绝对路径，解压可能覆盖原路径 —— 建议先 cd 到上级目录用相对路径打包。
```

### 4.4 系统信息命令 ★

```md
【③ 命令速查】
uname -r                          # 只看内核版本
uname -a                          # 完整系统、硬件、时间信息
hostname                          # 看主机名
hostname web01                    # 临时改（重启失效）
hostnamectl set-hostname web01    # ★CentOS 7+ 永久修改主机名
uptime                            # 运行时长 + 登录用户 + 1/5/15 分钟负载
free -h                           # 内存；字段：total/used/free/buff/cache/★available(真实可用)
df -h                             # 各分区磁盘使用率
df -i                             # ★查 inode 使用率（排查 inode 耗尽）
du -sh /data                      # 目录总大小
du -h --max-depth=1 /var/log      # ★只看一级子目录大小，快速定位大文件夹
lscpu                             # CPU 规格（核心、线程、架构、主频）

【④ 易错点】
- 看内存余量要看 available，不是 free（buff/cache 是可回收的缓存）。
- df 显示满但 du 统计很小 → 文件被删但句柄仍被占用，用 lsof | grep deleted 查。
```

### 4.5 管道与重定向 ★★

```md
【① 一句话本质】
管道把"前一个命令的输出"变成"后一个命令的输入"；重定向决定"输出去哪儿"。

【③ 管道 |】
cat /etc/passwd | grep root                 # 过滤含 root 的行
who | wc -l                                 # 统计登录用户数
ps -ef | less                               # 分页看进程
cat access.log | grep "404" | wc -l         # 统计 404 次数
find /tmp -name "*.tmp" | xargs rm -rf      # 管道 + xargs 批量删除

【③ 输出重定向】
>  覆盖（清空后写入）：echo "第一行" > test.txt
>> 追加（末尾追加不覆盖）：echo "第二行" >> test.txt
ls -l /etc > ls_etc.txt

【③ 输入重定向 <】
wc -l < test.txt                            # 把文件内容作为输入
mysql -uroot -p < init.sql                  # 批量导入 SQL（脚本常用）

【③ 标准输出 1 / 标准错误 2（★必考）】
ls /etc /nonexist > ok.txt                  # 只存正常输出，错误仍打屏幕
ls /etc /nonexist 2> err.txt                # 只存错误，正常仍打屏幕
ls /etc /nonexist > ok.txt 2> err.txt       # 正常与错误分开保存
ls /etc /nonexist > all.txt 2>&1            # ★合并写入同一文件（通用写法）
ls /etc /nonexist &> all.txt                # bash 简化写法，等价上一条

【③ /dev/null 黑洞（屏蔽输出）】
ls /etc > /dev/null                         # 丢弃正常输出
ls /nonexist 2> /dev/null                   # 丢弃报错
ls /etc /nonexist > /dev/null 2>&1          # ★全部丢弃（定时任务最常用）
*/5 * * * * /root/clean_log.sh &> /dev/null # 定时任务屏蔽无用输出
grep "ERROR" /var/log/*.log >> error.log 2>/dev/null   # 综合示例

【⑤ 🎯 面试考点】
🎯 2>&1 是什么意思？ → 把标准错误合并到标准输出，一起写进同一个文件。
🎯 定时任务为什么常写 > /dev/null 2>&1？ → 避免产生大量无用邮件/日志占满磁盘。
```

### 4.6 文本三剑客 grep / sed / awk ★★

```md
【① 一句话本质】
grep 按"行"过滤，sed 按"行"增删改替换，awk 按"列"切割与统计 —— 三者常配合管道使用。

【② grep：文本过滤】
核心参数：-i 忽略大小写 ｜ -n 显示行号 ｜ -c 统计匹配行数 ｜ -v 反向过滤 ｜ -E 扩展正则 ｜ -r 递归目录
grep "root" /etc/passwd                      # 基础匹配
grep -i "root" /etc/passwd                   # 忽略大小写
grep -n "ssl" /etc/nginx/nginx.conf          # 带行号（定位配置错误行）
grep -c "500" /var/log/nginx/error.log       # 统计报错量
grep -v "^#" /etc/profile | grep -v "^$"     # ★排除注释行和空行
grep -E "root|nginx" /etc/passwd             # 扩展正则（等价 egrep）
grep -r "listen 80" /etc/nginx/              # 递归搜目录

【② sed：行编辑器】
格式：sed [参数] '地址+操作' 文件
操作：a 行后新增 ｜ i 行前插入 ｜ d 删除 ｜ s/旧/新/g 替换 ｜ p 打印
查：sed -n '/root/p' /etc/passwd
删：sed '/^#/d' test.conf（注释）｜ sed '/^$/d' test.conf（空行）｜ sed '3d' ｜ sed '2,5d'
增：sed '2a new_line' test.txt（第2行后）｜ sed '3i insert_line' test.txt（第3行前）
替换：
sed 's/old/new/g' test.txt                          # g = 全局，不加 g 只换行内第一个
sed -i 's/Listen 80/Listen 8080/g' nginx.conf       # ★-i 直接改源文件（不加 -i 只预览）
sed 's/^/# /g' test.txt                             # 每行行首加注释
sed 's/$/;/g' test.txt                              # 每行行尾加分号
sed '/nginx/s/root/www/g' nginx.conf                # ★地址定位：只对含 nginx 的行替换

【② awk：列切割与统计】
内置变量：$0 整行 ｜ $1..$n 第几列 ｜ NF 总列数 ｜ NR 行号 ｜ FS 输入分隔符（默认空白）
awk '{print $1,$7}' /etc/passwd              # 打印第 1、7 列
awk -F: '{print $1,$3}' /etc/passwd          # -F 指定冒号分隔
awk '{print NR, NF, $0}' test.txt            # 行号 + 列数 + 整行
awk '/root/' /etc/passwd                     # 条件过滤（类似 grep）
awk -F: '$3 == 0' /etc/passwd                # UID 等于 0（即 root）
awk -F: '$3 >= 1000' /etc/passwd             # 普通用户
awk '{print $1}' access.log | sort | uniq -c | sort -nr   # ★统计 IP 访问量 TOP
df -m | awk '/^\/dev/ {sum+=$3} END{print sum}'           # 求和
awk -F: 'BEGIN{print "用户 UID"} {print $1,$3} END{print "读取完成"}' /etc/passwd
echo "1|2|3|4" | awk -F "|" '{print $2}'     # 自定义分隔符

【④ 易错点（★高频）】
- sed 不加 -i 只是预览，很多人以为改了其实没改。
- awk 求和用 df -h 会因为单位不同（M/G）算错，★要用 df -m 统一单位。
- grep -v 排除的是"行"，想排除注释+空行要连写两次。

【⑤ 🎯 面试考点】
🎯 统计访问日志里 TOP 10 的 IP？
  awk '{print $1}' access.log | sort | uniq -c | sort -nr | head -10
🎯 批量把配置里 80 端口改成 8080？
  sed -i 's/Listen 80/Listen 8080/g' /etc/nginx/nginx.conf
🎯 三剑客各自擅长什么？
  grep 筛行、sed 改内容、awk 取列与统计。
```

### 4.7 辅助工具 cut / sort / uniq / wc / tr

```md
【③ 命令速查】
cut（按列截取）：
cut -d: -f1 /etc/passwd            # -d 分隔符，-f 第 1 列
cut -d: -f1,3 /etc/passwd          # 第 1、3 列
cut -d: -f1-4 /etc/passwd          # 第 1~4 列
echo "abc123xyz" | cut -c1-3       # -c 按字符位置截取
cat access.log | cut -d' ' -f1     # 取 IP 列

sort（排序）：
sort test.txt                      # 默认 ASCII 升序
sort -r test.txt                   # -r 降序
sort -n num.txt                    # -n 按数字大小（纯数字必加）
sort -k2 test.txt                  # -k 按第 2 列
sort -t: -k3 -n /etc/passwd        # 按 UID 数字排序

uniq（去重，★只能去"相邻"重复，必须先 sort）：
sort ip.txt | uniq                 # 去重
sort ip.txt | uniq -c              # -c 统计重复次数（日志统计 IP 访问量）
sort ip.txt | uniq -d              # -d 只显示重复过的行
sort ip.txt | uniq -u              # -u 只显示出现一次的行
awk '{print $1}' access.log | sort | uniq -c | sort -nr    # ★经典组合

wc（统计）：
wc -l test.txt                     # -l 行数（最常用）
wc -w / wc -c                      # 单词数 / 字符数
grep "500" error.log | wc -l       # 统计匹配行数

tr（字符替换/删除/压缩）：
echo "a-b-c-d" | tr '-' '_'        # 字符替换
echo "Hello" | tr 'a-z' 'A-Z'      # 小写转大写（反向同理）
echo "123abc456" | tr -d '0-9'     # -d 删除数字
echo "aaa   bbb" | tr -s ' '       # -s 压缩连续重复字符

【④ 易错点】
- uniq 只去相邻重复行，直接用往往"没效果"，必须先 sort。
- sort 默认按字符排（10 会排在 9 前面），排数字一定要加 -n。
```

---

## 模块5：进程、服务与定时任务

**定位**：管理系统里运行的程序与服务，是业务稳定的基础。

### 核心知识点

- ★★ 进程基础：进程与线程、PID/PPID、**进程状态（R/S/D/T/Z 与僵尸、孤儿）**
- ★ 进程管理：`ps/top/htop`、`pstree`、`kill/killall/pkill`、`nice/renice`
- ★ 后台任务：`&`、`jobs`、`fg/bg`、`nohup`、`screen/tmux` 会话保持
- ★★ **systemd 服务管理**：systemctl、`.service` 单元文件、开机自启、故障排查
- ★★ **定时任务 crontab**：语法、编写规范、环境变量坑点、排错、`at`、`anacron`

**学习目标**

能快速定位异常进程，独立管理系统服务，编写合规的定时任务，处理僵尸进程与服务异常退出。

### 5.1 进程、线程与进程状态 ★★

```md
【① 一句话本质】
进程是"资源分配的最小单位"（独立内存），线程是"CPU 调度的最小单位"（共享内存）；
★面试要分清"课本五态"和"Linux 实际 STAT 标记"两套体系。

【② 进程 vs 线程】
- 进程：程序运行后的实例，拥有独立内存空间、文件描述符、PID、环境变量；进程间完全隔离，切换开销大。
- 线程：隶属于进程，共享进程的内存与文件句柄，切换开销极小。
- 关系：一个进程至少包含 1 个主线程，可创建多个子线程。

【② PID / PPID】
- PID：进程唯一编号；★CentOS 7+ 的 systemd 固定为 PID = 1
- PPID：父进程 ID
- 查看：ps -ef（第 2 列 PID、第 3 列 PPID）｜ pstree -p（树形带 PID）｜ cat /proc/PID/status

【② ★两套进程状态体系（别混淆）】
第一层：课本理论五态（考操作系统原理用）
  创建 → 就绪 → 运行 → 阻塞（休眠/暂停） → 终止
  ★只讲 CPU 调度，不涉及僵尸与孤儿。

第二层：Linux 实际状态（ps 看到的 STAT，运维必背）
  R 运行/就绪：正在 CPU 跑，或排队等 CPU
  S 可中断休眠：等网络、锁、信号，可被信号唤醒（★绝大多数后台服务的常态）
  D 不可中断休眠：正在等磁盘 IO，★不接收任何信号，kill 杀不掉，只能等 IO 完成或重启
  T 暂停：Ctrl+Z 或 kill -STOP 暂停，需手动恢复
  Z 僵尸：★子进程已退出，但父进程没调用 wait() 回收退出状态；
          资源已释放，只残留 PID 与退出码；危害是占满 PID 导致无法新建进程
  （孤儿不是状态标记，是父子关系：父进程先死，子进程 PPID 自动改为 1 由 systemd 托管，
   ★无害，不会变成僵尸）

【② 两套体系的对应】
- 理论的"阻塞" = Linux 的 S + D + T
- 理论的"终止态"：正常回收就消失；父进程不回收 → 变成 Linux 独有的 Z 僵尸

【④ 易错点 / 处理】
- ★僵尸进程怎么清？ → 直接 kill 僵尸是无效的（它已经死了），要杀掉它的父进程，
  让它被 PID 1 的 systemd 收养并回收。
- ★kill -9 杀不掉的进程？ → 大概率是 D 状态（不可中断休眠，等磁盘/网络 IO），
  只能等 IO 恢复，实在不行重启系统。

【⑤ 🎯 面试考点】
🎯 僵尸进程和孤儿进程的区别？
  僵尸：子进程退出但父进程没回收，占 PID，有害；
  孤儿：父进程先死，子进程被 systemd（PID 1）收养，无害。
🎯 考试问"进程有哪几种状态"答哪套？
  考操作系统原理 → 答五态（创建/就绪/运行/阻塞/终止）；
  考 Linux 运维与 ps 命令 → 答 R/S/D/T/Z 加僵尸孤儿。
```

### 5.2 进程管理命令 ★

```md
【③ 查看工具】
ps -ef                  # 全格式：UID PID PPID CMD
ps aux                  # 含 CPU/内存占用 与 STAT 状态
ps aux --sort=-%cpu     # 按 CPU 降序
ps aux --sort=-%mem     # 按内存降序
ps -ef | grep nginx     # 过滤指定进程
ps -Lf 1234             # 查看某进程的线程
top                     # 实时刷新（默认 3 秒）；交互：P 按CPU、M 按内存、k 杀进程、q 退出
htop                    # top 增强版，界面友好（需安装）
pstree -p               # 树形展示父子进程 + PID

【③ 终止信号 kill / killall / pkill】
常用信号：1 SIGHUP 重载配置 ｜ 15 SIGTERM 优雅终止（默认）｜ 9 SIGKILL 强制杀死
kill 1234               # 默认发 15，优雅停止
kill -1 1234            # 平滑重载配置（nginx/apache 常用，不断连接）
kill -9 1234            # ★强制杀死，资源不释放，尽量少用
pkill nginx             # 按进程名批量发信号
pkill -9 java           # 强制杀所有 java 进程
killall nginx           # 按完整进程名批量操作

【③ 优先级 nice / renice】
nice 范围 -20（最高）～ 19（最低）；★普通用户只能调 0~19，root 才能设 -20~19
nice -n 10 ./test.sh        # 启动时指定优先级
nice -n -15 /usr/bin/nginx  # root 以高优先级启动
renice 5 -p 1234            # 修改运行中进程的优先级
renice 3 -u www             # 修改某用户所有进程的优先级

【④ 易错点】
- 优先用 kill -15（优雅）而不是 -9；-9 会导致程序来不及清理（如数据库可能损坏）。
- kill -1 是重载不是重启，nginx 改完配置用它，不断业务。
```

### 5.3 后台任务与会话保持 ★

```md
【① 一句话本质】
& 只是放后台，★SSH 一断进程就没了；要真正脱离终端得用 nohup，要恢复现场用 screen/tmux。

【③ 基础前后台】
sleep 300 &             # 命令末尾加 & 放后台（显示 [任务号] PID）
jobs / jobs -l          # 查看当前终端后台任务（-l 带 PID）
fg 1                    # 把任务 1 调回前台
Ctrl+Z                  # 暂停前台程序并丢到后台（Stopped）
bg 1                    # 唤醒暂停的任务，后台继续跑

【③ nohup（★断开 SSH 也不中断）】
单纯 & 的后台进程会随 SSH 断开被终止；nohup 让进程忽略挂断信号 SIGHUP。
nohup ./long_task.sh &                    # 输出默认写入 nohup.out
nohup ./long_task.sh > task.log 2>&1 &    # ★推荐：自定义日志并屏蔽多余输出
./long.sh & ; disown -h $!                # 对已运行后台进程追加脱离终端（$! 是上条命令 PID）

【③ screen】
screen -mS task_session     # 建会话
Ctrl+A 松开再按 D           # 分离会话（SSH 可断开）
screen -ls                  # 查看会话
screen -r task_session      # 重新接入
exit                        # 会话内执行，彻底关闭

【③ tmux（比 screen 更强）】
tmux new -s data_task       # 建会话
Ctrl+B 松开再按 D           # 分离
tmux ls                     # 查看
tmux a -t data_task         # 接入
tmux kill-session -t data_task ／ 会话内 exit   # 关闭

【⑤ 🎯 面试考点】
🎯 后台跑任务，SSH 断开后就没了，怎么解决？
  用 nohup ... & 忽略挂断信号，或用 screen/tmux 建会话后再跑。
```

### 5.4 systemd 服务管理 ★★

```md
【③ 核心命令】
systemctl list-unit-files --type=service             # 所有服务单元
systemctl list-units --type=service --state=running  # 只看运行中的
systemctl start/stop/restart nginx                   # 启停重启
systemctl reload nginx                               # ★平滑重载配置，不杀进程
systemctl daemon-reload                              # ★改了 .service 文件后必须执行
systemctl enable / disable nginx                     # 开机自启 / 取消
systemctl enable --now nginx                         # 立即启动 + 开机自启一步到位
systemctl status nginx                               # 状态 + 报错 + 日志片段
journalctl -u nginx -f                               # 实时跟踪服务日志
journalctl -u nginx --since "1 hour ago"             # 近一小时日志
systemctl mask / unmask nginx                        # 彻底禁用（连手动启动都不行）/ 解除

【③ 自定义 .service 单元文件模板】
路径：/etc/systemd/system/xxx.service，分 [Unit] [Service] [Install] 三段
[Unit]
Description=Demo Long Run Service
After=network.target          # 网络就绪后再启动
Wants=network.target
[Service]
ExecStart=/usr/bin/python3 /opt/demo/main.py   # ★必须绝对路径
Type=simple                   # 后台常驻进程类型
Restart=on-failure            # 崩溃自动重启
RestartSec=3                  # 重启间隔秒数
User=www
Group=www
StandardOutput=journal+console
StandardError=journal+console
[Install]
WantedBy=multi-user.target    # 多用户模式下开机启动
写完执行：systemctl daemon-reload → systemctl enable --now demo

【④ 服务故障排查四步】
1) systemctl status demo              # 看简要状态与报错
2) journalctl -u demo -f              # 实时看详细日志
3) systemctl cat demo                 # 看单元文件内容
   systemd-analyze verify /etc/systemd/system/demo.service   # 校验语法
   systemd-analyze blame              # 看各服务启动耗时
4) /usr/bin/python3 /opt/demo/main.py # ★跳过 systemd 前台直跑，直接看到报错

【⑤ 🎯 面试考点】
🎯 reload 和 restart 的区别？
  reload 平滑重载配置不杀进程（不断业务）；restart 是完整重启进程。
🎯 改完 service 文件为什么不生效？ → 没执行 systemctl daemon-reload。
🎯 怎么让服务崩溃后自动拉起？ → [Service] 里配 Restart=on-failure（或 always）。
```

### 5.5 定时任务 crontab / at / anacron ★★

```md
【② 语法：分 时 日 月 周 命令】
取值范围：分 0-59 ｜ 时 0-23 ｜ 日 1-31 ｜ 月 1-12 ｜ 周 0-6（0 和 7 都是周日）
特殊符号：*/n 每隔 n 单位 ｜ , 多个时间点 ｜ - 连续区间
示例：
*/5 * * * * /root/clean_log.sh        # 每 5 分钟
30 2 * * * /root/bak_data.sh          # 每天 2:30
0 3 * * 0 /root/full_bak.sh           # 每周日 3 点
0 1 1 * * /root/month_task.sh         # 每月 1 号 1 点
*/30 9-18 * * * /root/monitor.sh      # 每天 9-18 点每半小时

【③ 操作命令】
crontab -l / -e / -r        # 查看 / 编辑（自带语法校验，推荐）/ 删除全部（慎用）
crontab -u www -l / -e      # root 管理其他用户的任务
cat /etc/crontab            # 系统级任务
/etc/cron.hourly/、cron.daily/、cron.weekly/、cron.monthly/   # 系统周期任务目录（不用写表达式）

【④ ★三大编写规范与四个坑（面试高频）】
规范 1：命令与脚本一律用绝对路径
  错误：sh clean.sh        正确：/bin/sh /root/clean.sh
规范 2：输出必须重定向，否则持续发邮件把磁盘撑爆
  */5 * * * * /root/clean.sh &> /dev/null
  */5 * * * * /root/clean.sh >> /var/log/clean.log 2>&1
规范 3：脚本里手动导入环境变量（crontab 的 PATH 极短）
  方式一：脚本开头 export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
  方式二：0 2 * * * source /etc/profile; /root/task.sh &> /dev/null
四个坑：
  1) 没有完整 PATH → java/python/mysql 报 command not found
  2) 工作目录不是家目录 → 相对路径找不到文件
  3) 输出不重定向 → /var/spool/mail/root 暴涨
  4) 脚本有交互式输入 → 无终端直接卡住

【③ 排错步骤】
tail -f /var/log/cron                 # 只看是否被调度，★不记录脚本内部报错
env -i /bin/sh /root/task.sh          # ★用空环境模拟 crontab 复现问题（最有效）
在脚本开头加 exec >> /var/log/task_run.log 2>&1   # 捕获执行异常
chmod +x /root/task.sh                # 确认脚本有执行权限

【③ at：一次性任务】
yum install at / apt install at；systemctl start atd && systemctl enable atd
at now +5 minutes     → 输入命令 → Ctrl+D 提交
at 02:00 tomorrow     → 输入命令 → Ctrl+D
atq                   # 查看任务列表
atrm 1                # 删除 1 号任务

【③ anacron：关机补执行】
痛点：crontab 在关机时错过的任务会直接放弃；
anacron 开机后检查错过的日/周/月任务并自动补执行。
配置 /etc/anacrontab，字段：周期天数 延迟分钟 任务ID 执行脚本
例：1 5 cron.daily run-parts /etc/cron.daily  → 每日任务，开机延迟 5 分钟补跑
★注意：anacron 只处理日/周/月级任务，不处理分钟级 crontab。

【⑤ 🎯 面试考点】
🎯 定时任务写了却不执行，怎么排查？
  ①tail /var/log/cron 确认是否被调度 ②用 env -i 模拟极简环境复现（多数是 PATH 问题）
  ③改用绝对路径 ④检查脚本执行权限 ⑤看输出日志。
🎯 为什么 crontab 里命令要用绝对路径？ → crontab 的 PATH 很短，相对路径找不到命令。
```

---

## 模块6：磁盘存储与文件系统管理

**定位**：数据是企业核心资产，磁盘管理是运维的基本功。

### 核心知识点

- ★ 磁盘基础：命名规则（`/dev/sda`/`vda`/`nvme`）、MBR/GPT 分区表、HDD/SSD 差异
- ★★ 分区与挂载：`fdisk/parted`、`mkfs`、`mount`、**`/etc/fstab` 永久挂载**
- ★ 文件系统：ext4 / xfs 特性对比与修复（`fsck`/`xfs_repair`）
- ★ Swap 交换分区：创建、启停、swappiness 优化
- ★★ **LVM 逻辑卷**：PV/VG/LV 三层、在线扩容、缩容、快照
- ★ RAID：RAID 0/1/5/10 原理对比与软 RAID（mdadm）

**学习目标**

能独立完成磁盘分区、格式化、挂载，熟练做 LVM 在线扩容，能根据业务选型 RAID 方案。

### 6.1 磁盘命名、分区表与介质 ★

```md
【③ 设备命名规则】
- SATA/USB 盘：/dev/sdX —— sda 第一块、sdb 第二块；sda1 表示第一块盘的第一个分区
- 云服务器虚拟盘（KVM）：/dev/vdX —— 阿里云/腾讯云 ECS 常见，如 /dev/vda1
- NVMe 固态盘：/dev/nvme0n1p1 —— nvme0 控制器、n1 命名空间、p1 分区
- 查看：lsblk（★树形看磁盘/分区/挂载点）、fdisk -l（分区详情）、df -h（已挂载使用率）

【② MBR vs GPT（★面试常考）】
MBR（老式）：
  - ★最大只支持 2TB
  - ★最多 4 个主分区；想更多就做成 3 主 + 1 扩展，扩展里再分逻辑分区（逻辑分区从 5 开始编号）
  - 分区表存在磁盘最前面 512 字节
GPT（现代，推荐）：
  - 支持单盘最大 9.4ZB，无 2TB 限制
  - 默认最多 128 个主分区，不需要扩展/逻辑分区
  - ★分区表有多份备份 + CRC 校验，损坏可恢复，更安全
  - 需搭配 UEFI 启动
查看类型：gdisk -l /dev/sda（识别 GPT）、fdisk -l /dev/sda

【② HDD vs SSD】
HDD 机械盘：磁头+盘片机械转动
  优点：单价低、容量大、寿命长、数据恢复容易
  缺点：随机读写慢、怕震动磕碰、噪音与功耗高
  适用：数据归档备份、大容量存储服务器
SSD 固态盘（含 NVMe/M.2/SATA）：闪存芯片，无机械部件
  优点：随机读写极快、防震抗摔、无噪音低功耗
  缺点：有擦写寿命（高频写入会消耗）、同容量价格更高
  适用：系统盘、数据库、高并发业务、云主机本地盘
运维要点：★数据库业务优先 SSD，冷数据备份用 HDD；SSD 避免频繁大量随机写，定期监控磨损量。
```

### 6.2 分区、格式化与挂载 ★★

```md
【③ 分区工具】
fdisk（仅 MBR，单盘 ≤2TB，老盘适用）：
  fdisk /dev/sdb
  交互指令：m 帮助 ｜ p 打印分区表 ｜ n 新建 ｜ d 删除 ｜ w 保存退出 ｜ q 放弃退出
parted（★GPT/MBR 通用，支持 2TB 以上，企业推荐）：
  parted /dev/sdb
  交互：print 查看 ｜ mklabel gpt 改 GPT 分区表 ｜ mkpart 创建分区 ｜ rm 删除 ｜ quit 退出
分区后刷新内核识别（不重启生效）：partprobe /dev/sdb 或 udevadm trigger

【③ 格式化 mkfs】
mkfs.xfs /dev/sdb1          # ★CentOS 7+ 默认 XFS（不支持缩容）
mkfs.ext4 /dev/sdb1         # ext4 兼容广，支持缩容
mkfs.xfs -L data_disk /dev/sdb1    # -L 加标签，方便识别

【③ 临时挂载 mount（重启失效）】
mkdir -p /data                          # 先建空挂载点
mount /dev/sdb1 /data
mount -o rw,noatime /dev/sdb1 /data     # ★noatime 不更新访问时间，减少写入（SSD 优化）
查看：mount ｜ df -h
卸载：umount /data（有程序在读写会失败）｜ umount -l /data（强制卸载，慎用，可能丢缓存）

【② ★/etc/fstab 永久挂载（6 个字段）】
格式：设备  挂载点  文件系统  挂载参数  dump备份  fsck自检优先级
- 设备：★推荐用 UUID（blkid 获取），磁盘顺序变化也不受影响
- 挂载参数：defaults（等价 rw,suid,dev,exec,auto,nouser,async）、noatime
- dump：0 不备份
- fsck 优先级：0 不自检 ｜ 根分区 1 ｜ 其他分区 2
示例：UUID="abc123-..."  /data  xfs  defaults,noatime  0 0
★写完必须执行 mount -a 校验 —— 配置写错会导致开机起不来。

【③ 新盘上线完整流程（背下来）】
parted /dev/sdb mklabel gpt                 # 1. 建 GPT 分区表
parted /dev/sdb mkpart primary 0 100%       # 2. 分区
partprobe /dev/sdb                          # 3. 刷新内核
mkfs.xfs /dev/sdb1                          # 4. 格式化
mkdir /data && mount /dev/sdb1 /data        # 5. 建目录 + 临时挂载测试
blkid /dev/sdb1                             # 6. 取 UUID 写入 /etc/fstab
mount -a && df -h                           # 7. 校验并确认

【⑤ 🎯 面试考点】
🎯 fstab 里为什么推荐用 UUID 而不是 /dev/sdb1？
  设备名可能因磁盘顺序变化而漂移，UUID 唯一且稳定。
🎯 改完 fstab 必须做什么？ → mount -a 校验语法并挂载，避免开机崩溃。
```

### 6.3 文件系统 ext4 / xfs 与修复 ★

```md
【② ext4 vs XFS】
ext4（老一代通用）：
  优点：★支持缩容（resize2fs）、日志完善、老旧硬件兼容极好、有 e4defrag
  缺点：单文件最大 16TB；超大容量/高并发下性能弱于 XFS；子目录约 32000 上限
  适用：测试机、小分区、后期可能需要缩容、老旧环境
XFS（★CentOS 7+ 默认，企业首选）：
  优点：支持超大容量（单文件 8EB）；★海量小文件与并发读写性能强；子目录无硬性上限；
        延迟分配等优化，SSD/HDD 表现均衡
  缺点：★不支持缩容（只能扩不能缩）；CentOS 6 等老系统需额外装工具
  适用：生产服务器、数据库、大容量磁盘、高并发业务

【③ 扩容操作】
ext4：partprobe /dev/sdb1 → resize2fs /dev/sdb1
XFS：★必须在"已挂载"状态执行 xfs_growfs /data

【③ 修复（★铁律：必须卸载后修复，挂载中修复会损坏数据）】
ext4：
  umount /dev/sdb1
  fsck /dev/sdb1              # 只扫描不修复
  e2fsck -f /dev/sdb1         # 强制检查（干净盘默认跳过）
  e2fsck -y /dev/sdb1         # 自动确认修复
  mount /dev/sdb1 /data
XFS：
  umount /dev/sdb1
  xfs_repair -n /dev/sdb1     # 只检测不修复
  xfs_repair /dev/sdb1        # 执行修复
  xfs_repair -L /dev/sdb1     # ★清空日志强制修复（有丢文件风险，万不得已才用）
  mount /dev/sdb1 /data

【④ 易错点】
- 异常断电/强制关机最容易损坏文件系统元数据，开机可能触发自检。
- XFS 不能缩容，划容量前必须提前规划。
- 修复前先备份数据，属于高危操作。
```

### 6.4 Swap 交换分区 ★

```md
【① 一句话本质】
拿硬盘当"应急内存"：内存不足时把冷数据换出去；★磁盘比内存慢得多，大量用 Swap 系统必卡。

【③ 两种创建方式】
方式 1：独立分区（性能好，企业推荐）
  fdisk /dev/sdc → n 新建 → t 改类型 → 82(swap) → w 保存
  partprobe /dev/sdc1
  mkswap /dev/sdc1
  swapon /dev/sdc1
  echo 'UUID=xxx swap swap defaults 0 0' >> /etc/fstab    # blkid 取 UUID
方式 2：swap 文件（灵活，测试机/云主机常用）
  dd if=/dev/zero of=/swapfile bs=1G count=2     # 创建 2G 文件
  chmod 600 /swapfile                            # ★权限必须 600
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile swap swap defaults 0 0' >> /etc/fstab

【③ 查看与开关】
swapon -s      # 查看所有 swap 设备
free -h        # 内存 + swap 整体使用
swapoff /swapfile ／ swapoff -a    # 关闭单个 / 关闭全部
swapon -a                          # 启用 fstab 中所有 swap

【③ 内核参数优化】
swappiness（使用 swap 的倾向，0~100，默认 60）：
  ★数据库/高并发生产推荐 10~30（尽量少用 swap）
  sysctl vm.swappiness=10                              # 临时
  echo 'vm.swappiness=10' >> /etc/sysctl.conf && sysctl -p   # 永久
vfs_cache_pressure（回收目录/文件缓存力度，默认 100）：
  ★数据库推荐 50（多保留缓存）。同样写进 sysctl.conf。

【③ 生产规范】
容量规划：内存 ≤2G → 2 倍内存 ｜ 2~8G → 等于内存 ｜ 8~64G → 4~8G ｜ >64G → 2~4G 应急即可
- Swap 优先放 SSD，★禁止放机械盘
- ★Swap 使用率长期 >30% 说明物理内存不足，应该加内存，而不是扩 swap
- swap 文件权限必须 600，防信息泄露；swap 只作兜底应急，别让业务依赖它
```

### 6.5 LVM 逻辑卷 ★★

```md
【① 一句话本质】
把多块盘变成"一个可伸缩的存储池"：磁盘(PV) → 资源池(VG) → 业务分区(LV)，★支持在线扩容。

【② 三层结构】
PV 物理卷：底层磁盘或分区（/dev/sdb1），打上 LVM 标签
VG 卷组：多个 PV 合并成的存储资源池
LV 逻辑卷：从 VG 里划分出来，可直接格式化挂载
★注意：XFS 不支持 LV 缩容，ext4 支持。

【③ 创建流程（PV → VG → LV）】
pvcreate /dev/sdb1 /dev/sdc1              # 1. 建 PV（pvs / pvdisplay 查看）
vgcreate vg_data /dev/sdb1 /dev/sdc1      # 2. 建 VG（vgs / vgdisplay 查看）
lvcreate -L 100G -n lv_data vg_data       # 3. 划 100G 的 LV（lvs / lvdisplay 查看）
mkfs.xfs /dev/vg_data/lv_data             # 4. 格式化
mkdir /data && mount /dev/vg_data/lv_data /data   # 5. 挂载
echo '/dev/vg_data/lv_data /data xfs defaults 0 0' >> /etc/fstab && mount -a

【③ VG 扩容（加新盘）】
pvcreate /dev/sdd1 → vgextend vg_data /dev/sdd1 → vgs 看容量增加

【③ ★LV 在线扩容（生产高频，业务不中断）】
lvextend -L +50G /dev/vg_data/lv_data     # 1. 扩 LV
xfs_growfs /data                          # 2a. XFS：★挂载状态执行
resize2fs /dev/vg_data/lv_data            # 2b. ext4
一次性用掉全部剩余空间：
lvextend -l +100%FREE /dev/vg_data/lv_data && xfs_growfs /data

【③ LV 缩容（★仅 ext4，高危）】
umount /data → e2fsck -f /dev/vg_data/lv_data → resize2fs ... 80G → lvreduce -L 80G ... → mount

【③ LVM 快照（写时复制 COW，只占变更数据空间）】
lvcreate -s -L 10G -n lv_data_snap /dev/vg_data/lv_data    # 建快照（预留 10G）
mkdir /mnt/snap && mount /dev/vg_data/lv_data_snap /mnt/snap # 挂载看历史数据
回滚（★需停机）：umount /data 与 /mnt/snap → lvconvert --merge /dev/vg_data/lv_data_snap → mount /data
用完删除：lvremove /dev/vg_data/lv_data_snap

【③ 删除整套 LVM】
umount /data → lvremove → vgremove → pvremove

【⑤ 🎯 面试考点】
🎯 LVM 相比直接分区的优势？ → 在线扩容、快照、跨盘统一管理，业务不中断。
🎯 扩完 LV 后为什么 df 看不到变大？ → 忘了执行文件系统扩容（xfs_growfs / resize2fs）。
🎯 XFS 的 LV 能缩容吗？ → 不能，XFS 只支持扩容；要缩容只能备份重建。
```

### 6.6 RAID 磁盘阵列 ★

```md
【② 四种主流 RAID 对比（★面试必考）】
RAID 0 条带（≥2 块）：
  数据拆分并发写入所有盘；★读写最快；无冗余，坏一块全盘数据丢失；容量 = 各盘之和
  适用：临时缓存、可重建的非核心数据
RAID 1 镜像（≥2 块，偶数）：
  两盘写完全相同副本；读性能好、写一般；★最多坏 1 块；容量 = 单盘容量（浪费 50%）
  适用：系统盘、数据库日志盘等高可靠小容量场景
RAID 5 奇偶校验（≥3 块）：
  数据 + 校验位分散存储；读快、★写偏弱（每次写要更新校验）；最多坏 1 块；
  容量 = (N-1) × 单盘；★不适合高频随机写（数据库）；重建压力大，机械盘重建易二次损坏
RAID 10（先镜像后条带，≥4 块，偶数）：
  读写性能都极强；每组镜像最多坏 1 块（同组两块同时坏才丢数据）；容量 = 总容量/2
  ★适用：数据库、高并发业务、核心存储（企业生产首选均衡方案）

速记：速度 0 > 10 > 5 > 1 ｜ 可靠性 1 ≈ 10 > 5 > 0 ｜ 空间利用率 0 > 5 > 1 = 10

【③ 软 RAID（mdadm）实操】
mdadm -C /dev/md0 -l 0 -n 2 /dev/sdb /dev/sdc        # -C 创建 -l 级别 -n 盘数
mdadm -C /dev/md1 -l 1 -n 2 /dev/sdb /dev/sdc        # RAID1
mdadm -C /dev/md5 -l 5 -n 3 /dev/sdb /dev/sdc /dev/sdd
mdadm -C /dev/md10 -l 10 -n 4 /dev/sdb /dev/sdc /dev/sdd /dev/sde
mdadm -D /dev/md0 ／ cat /proc/mdstat                # 查看阵列状态
mkfs.xfs /dev/md0 && mount /dev/md0 /raid0           # 格式化挂载
mdadm -Ds >> /etc/mdadm.conf                         # 保存配置，开机自动组装
echo '/dev/md0 /raid0 xfs defaults 0 0' >> /etc/fstab

【③ 坏盘替换】
mdadm /dev/md10 -f /dev/sdb      # 1. 标记故障
mdadm /dev/md10 -r /dev/sdb      # 2. 移除坏盘
mdadm /dev/md10 -a /dev/sdf      # 3. 插入新盘加入阵列重建
watch cat /proc/mdstat           # 4. 看重建进度

【③ 删除阵列】
umount /raid0 → mdadm --stop /dev/md0 → mdadm --zero-superblock /dev/sdb /dev/sdc
```

---

## 模块7：网络基础与防火墙

**定位**：运维一半的故障都和网络有关，网络能力直接决定排障效率。

### 核心知识点

- ★ 网络模型与核心协议：OSI 七层 / TCP-IP 四层、**TCP 三次握手/四次挥手**、UDP、HTTP/HTTPS
- ★ IP / 子网 / 网关 / DNS / 路由基础
- ★ 网络配置与排障：`ip`、静态 IP、主机名、`ping/traceroute/mtr`、`ss/netstat`、`telnet/nc`、`curl/wget`、`tcpdump`
- ★★ 防火墙：**iptables**（四表五链、白名单、NAT）、firewalld

**学习目标**

能独立配置服务器网络，快速定位端口不通、网络超时等常见故障，能编写基础防火墙安全规则。

### 7.1 网络模型与核心协议 ★

```md
【① 一句话本质】
数据从 A 到 B 要"分层打包"，每层只管自己那点事；TCP 负责"可靠"，UDP 负责"快"。

【② OSI 七层 vs TCP-IP 四层】
OSI 七层（理论标准，自上而下）：
  1.应用层 HTTP/FTP/DNS/SSH
  2.表示层 加密/编码/压缩（HTTPS 加密在此）
  3.会话层 建立/维持/断开会话
  4.传输层 TCP/UDP，端口区分程序
  5.网络层 IP/ICMP，跨主机寻址与路由
  6.数据链路层 MAC 地址、交换机、帧
  7.物理层 网线/光纤/网卡硬件
TCP-IP 四层（Linux/互联网实际用，合并简化）：
  应用层（=OSI 上三）／ 传输层 ／ 网际层（网络层）／ 网络接口层（链路+物理）

【② TCP 三次握手（建立连接）】
  1. 客户端 → 服务端：SYN（seq=x）
  2. 服务端 → 客户端：SYN+ACK（ack=x+1, seq=y）
  3. 客户端 → 服务端：ACK（ack=y+1）
  目的：协商双方收发能力、同步初始序列号，防止失效的旧连接请求干扰。

【② 四次挥手（断开连接，全双工两端各自关闭）】
  1. 客户端 → 服务端：FIN（我不再发数据）
  2. 服务端 → 客户端：ACK（收到关闭请求，还可发剩余数据）
  3. 服务端 → 客户端：FIN（服务端数据发完，也要关）
  4. 客户端 → 服务端：ACK（确认关闭，等超时释放端口）

【② UDP（无连接不可靠）】
  无握手、无重传、无拥塞控制，开销极小；适用直播、语音、DNS 查询、游戏（丢包可容忍，求低延迟）。

【② HTTP / HTTPS】
  HTTP：明文传输，80 端口，抓包直接看到账号密码。
  HTTPS = HTTP + TLS 加密，443 端口；握手协商加密套件，传输密文，防窃听/篡改/中间人劫持。

【⑤ 🎯 面试考点】
🎯 为什么握手 3 次、挥手 4 次？
  握手 2、3 步可合并成一次（服务端 SYN+ACK 一起发）；挥手时服务端收到 FIN 后可能还有数据要发，
  所以 ACK 和 FIN 必须分开（先回 ACK，发完数据再发 FIN），所以是 4 次。
🎯 TCP 和 UDP 的区别？ → TCP 可靠面向连接（握手/确认/重传），UDP 快但不可靠。
```

### 7.2 IP / 子网 / 网关 / DNS / 路由 ★

```md
【② IP 地址】
IPv4 32 位，四段十进制 0~255，分"网络位 + 主机位"；
分类 A/B/C/D/E，日常内网多用 C 类私网：10.x.x.x、172.16~172.31.x.x、192.168.x.x。

【② 子网与掩码】
子网掩码区分网络位与主机位：192.168.1.100/24 = 掩码 255.255.255.0
  /24：前 24 位网络位，后 8 位主机位，最多 254 台可用（网络地址+广播地址不可分配）
作用：隔离广播域，区分本地网段和跨网段流量。

【② 网关】
不同网段通信的出入口；本机目标 IP 不在同子网，数据包全部发给网关转发。
内网主机网关一般是路由器/防火墙内网口 IP。
默认路由 0.0.0.0/0：所有匹配不到明细路由的流量统一交给默认网关。

【② DNS 域名解析】
域名 ↔ IP 转换，UDP 53 端口；
流程：客户端 → 本地缓存 → 递归服务器 → 根 → 顶级域 → 权威服务器，返回 IP。

【② 路由类型】
1. 直连路由：同网段，二层直接转发
2. 静态路由：手动配目标网段 + 下一跳
3. 默认路由 0.0.0.0/0：兜底走网关
4. 动态路由：OSPF/RIP/BGP，设备自动学习网段
```

### 7.3 网络配置与排障工具 ★

```md
【③ 网卡与 IP 配置】
ip a                                    # 查看所有网卡、IP、MAC
ip link set eth0 up / down              # 启用 / 关闭网卡
ip addr add 192.168.1.100/24 dev eth0   # ★临时配置静态 IP（重启失效）
ip route add default via 192.168.1.1 dev eth0   # ★临时加默认网关

【③ 永久静态 IP】
CentOS 7 及更早：/etc/sysconfig/network-scripts/ifcfg-eth0
  TYPE=Ethernet ｜ BOOTPROTO=static ｜ NAME=eth0 ｜ DEVICE=eth0
  ONBOOT=yes ｜ IPADDR=192.168.1.100 ｜ NETMASK=255.255.255.0
  GATEWAY=192.168.1.1 ｜ DNS1=223.5.5.5 ｜ DNS2=114.114.114.114
  生效：systemctl restart network
RHEL 8+ / CentOS 8+（NetworkManager）：
  nmcli connection add con-name eth0 type ethernet ifname eth0 \
    ipv4.method manual ipv4.addresses 192.168.1.100/24 \
    ipv4.gateway 192.168.1.1 ipv4.dns "223.5.5.5 114.114.114.114" ipv4.autoconnect yes
  nmcli connection up eth0

【③ 主机名】
hostname                          # 查看
hostname web01                    # 临时改（重启失效）
hostnamectl set-hostname web01    # ★CentOS7+/Ubuntu 永久改
cat /etc/hostname                 # 配置文件

【③ 连通性排障（从底层到应用逐层）】
ping -c 4 192.168.1.1             # ICMP 连通性（三层）
traceroute www.baidu.com          # 追踪路由跳转，定位断链节点
mtr www.baidu.com                 # ★ping+traceroute 整合，实时看每跳丢包延迟（排障首选）
ss -tulnp                         # ★推荐替代 netstat，看监听端口（tTCP uUDP l监听 n数字 p进程）
ss -ant                           # 所有 TCP 连接（含已建立）
netstat -tulnp / netstat -rn      # 传统工具 / 看路由表
telnet 192.168.1.200 80           # TCP 端口连通测试（仅 TCP）
nc -zv 192.168.1.200 80           # 端口扫描（TCP/UDP 都支持）
nc -zv 192.168.1.200 80-90        # 批量扫端口段
curl www.baidu.com                # 测试 HTTP 服务
curl -I www.baidu.com             # 仅返回响应头，看 200/404/502 状态码
curl -v www.baidu.com             # -v 打印完整握手过程（详细排错）
wget www.baidu.com -O /tmp/index.html   # 下载测试

【③ tcpdump 抓包（底层分析）】
tcpdump -i eth0 -w net.pcap                 # 抓 eth0 流量存文件
tcpdump -i eth0 port 80                     # 只抓 80 端口
tcpdump -i eth0 src 192.168.1.100           # 指定源 IP
tcpdump -i eth0 host 192.168.1.100 and port 443   # 组合过滤
tcpdump -r net.pcap                         # 读取抓包文件

【④ 易错点】
- ip addr add 是临时生效，重启网卡/机器会丢；生产必须写进配置文件或 nmcli。
- 排障顺序：ping 通不通 → ss 看端口监听没 → telnet/nc 测端口通不通 → curl 看应用层。
```

### 7.4 防火墙 iptables ★★

```md
【① 一句话本质】
iptables 是内核 netfilter 的"用户层管理工具"，靠"表 + 链 + 规则"控制数据包的放行/拒绝/改写。

【② 四表（优先级从高到低：raw > mangle > nat > filter）】
filter（默认）：过滤放行/拒绝，含 INPUT OUTPUT FORWARD
nat：地址转换，含 PREROUTING POSTROUTING OUTPUT
mangle：修改包标记/TTL，全五链可用
raw：关闭连接跟踪，极少用

【② 五链（数据包流经的节点）】
PREROUTING：进网卡、路由判断前（★DNAT 在这里做）
INPUT：目标是本机进程的包
FORWARD：跨机器转发（网关/转发场景）
OUTPUT：本机向外发出的包
POSTROUTING：出网卡前（★SNAT/MASQUERADE 在这里做）

【③ 基础参数】
-A 追加 / -I 插入 / -D 删除 / -L 查看 / -F 清空 / -P 默认策略
-s 源IP -d 目标IP --sport 源端口 --dport 目标端口
-j 动作：ACCEPT 放行 / DROP 丢弃 / REJECT 拒绝并回复 / DNAT / SNAT / MASQUERADE

【③ 生产白名单（最安全写法）】
iptables -P INPUT DROP                    # 默认拒绝（生产安全规范）
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
iptables -A INPUT -i lo -j ACCEPT                    # 放行本地回环
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT   # ★已建立连接自动放行
iptables -A INPUT -s 192.168.1.0/24 -p tcp --dport 22 -j ACCEPT   # 仅内网 SSH
iptables -A INPUT -p tcp --dport 80 -j ACCEPT        # 放行 80
iptables -A INPUT -p tcp --dport 443 -j ACCEPT       # 放行 443
iptables -A INPUT -s 10.0.0.100 -j DROP              # 拒绝指定 IP
★--dport 必须配合 -p tcp/udp 使用，否则报错。

【③ NAT 地址转换】
SNAT（固定公网 IP 共享上网）：
  iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -j SNAT --to-source 203.0.113.10
MASQUERADE（动态公网 IP 宽带，替代 SNAT）：
  iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth0 -j MASQUERADE
DNAT（端口映射：公网 8080 → 内网 80）：
  iptables -t nat -A PREROUTING -d 203.0.113.10 --dport 8080 -j DNAT --to-destination 192.168.1.10:80

【③ 持久化（否则重启失效）】
iptables-save > /etc/sysconfig/iptables     # 保存
iptables-restore < /etc/sysconfig/iptables  # 恢复
CentOS 7+：yum install iptables-services && systemctl enable iptables

【⑤ 🎯 面试考点】
🎯 四表五链分别是什么？ → 表 filter/nat/mangle/raw；链 PREROUTING/INPUT/FORWARD/OUTPUT/POSTROUTING。
🎯 SNAT 和 DNAT 区别？ → SNAT 改源 IP（内网出网共享），DNAT 改目标 IP（外网进内网端口映射）。
🎯 生产防火墙为什么默认 DROP？ → 默认拒绝是"白名单"思路，只允许明确放行的，最安全。
```

### 7.5 防火墙 firewalld ★

```md
【② 与 iptables 的关系】
firewalld 是上层防火墙管理工具；RHEL 7 底层基于 iptables，RHEL 8+ 默认 nftables（iptables 走兼容层）。
语法比 iptables 简单，按"区域 zone"管理流量。

【② 区域 zone（按可信程度）】
trusted 全放行 ｜ internal 内网 ｜ public 公网（默认）｜ dmz 隔离区 ｜ block 全拒绝

【③ 运行时规则（临时，重启失效）】
firewall-cmd --add-port=80/tcp                          # 放行 80
firewall-cmd --add-service=ssh                         # 放行服务
firewall-cmd --add-rich-rule='rule family=ipv4 source address=192.168.1.0/24 accept'   # 放行 IP 段

【③ 永久规则（加 --permanent，需 --reload 生效）】
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --permanent --add-service=http
firewall-cmd --reload                                  # ★改完永久规则必须 reload

【③ 端口转发（DNAT）】
firewall-cmd --permanent --add-forward-port=port=8080:proto=tcp:toaddr=192.168.1.10:toport=80
firewall-cmd --reload

【③ 查看与切换】
firewall-cmd --list-all                                # 查看当前区域所有规则
firewall-cmd --get-default-zone / --get-zones
systemctl stop firewalld && systemctl disable firewalld   # 关闭 firewalld
systemctl start iptables && systemctl enable iptables     # 切回 iptables

【④ 易错点】
- 加了 --permanent 却没 --reload，规则不生效（临时规则不需要 reload，永久规则需要）。
- 云服务器还要注意安全组（云平台侧的防火墙），本地 firewall 放行了仍可能被安全组挡住。
```

---

## 模块8：软件包管理与基础服务部署

**定位**：运维日常核心工作——部署业务依赖的各类服务。

### 核心知识点

- ★ RPM 底层包管理：`rpm` 安装/查询/卸载、依赖处理
- ★★ **YUM/DNF**：原理、仓库源配置、高频命令、分组安装
- ★ Debian 系 APT：`apt` 命令、源配置（与 yum 对照）
- ★ 源码编译安装：`./configure → make → make install`、优缺点、排坑
- ★ 常用基础服务：chrony(NTP)、DNS/BIND、rsync/inotify、NFS、FTP/Samba

**学习目标**

能通过 RPM/YUM/APT/源码三种方式安装软件，独立部署常用基础服务，排查服务启动失败的常见问题。

### 8.1 RPM 底层包管理 ★

```md
【② rpm 包命名】
格式：软件名-版本-发布号.架构.rpm，例 nginx-1.20.1-9.el7.x86_64.rpm

【③ 安装 / 升级 / 卸载】
rpm -ivh nginx.rpm                 # 安装本地包（-v 进度 -h 进度条）
rpm -Uvh nginx.rpm                 # 升级（不存在则直接安装）
rpm -ivh --force nginx.rpm         # 强制覆盖已装文件（文件冲突时）
rpm -ivh --nodeps nginx.rpm        # 忽略依赖装（★生产禁用，极易运行崩溃）
rpm -e nginx                       # 正常卸载（有依赖会拦截）
rpm -e --nodeps nginx              # 强制卸载（谨慎，会破坏依赖它的程序）

【③ 查询】
rpm -q nginx                       # 是否安装
rpm -qi nginx                      # 详细信息（版本/发布人/说明）
rpm -ql nginx                      # 安装出的所有文件路径
rpm -qc nginx                      # 只列配置文件
rpm -qR nginx                      # 依赖哪些库/程序
rpm -qf /usr/sbin/nginx           # 按文件反查所属 rpm 包
rpm -qip / -qlp nginx.rpm         # 查离线包详情 / 内含文件

【③ 依赖处理（rpm 本身不自动解决）】
yum localinstall nginx.rpm         # ★推荐：yum 自动补依赖
rpm -ivh *.rpm                     # 离线环境准备好全套依赖后批量装
rpm -V nginx                       # 校验文件是否被改/删/权限变（空输出=正常）

【④ 易错点】
- --nodeps 只能临时测试，长期用会导致程序运行缺库崩溃。
- rpm 找不到文件归属时用 rpm -qf 反查，是排障利器。
```

### 8.2 YUM/DNF 包管理 ★★

```md
【① 一句话本质】
yum/dnf 是 rpm 的"上层管家"——自动解析、下载、安装依赖，解决 rpm 最痛的依赖问题。

【② 原理】
读 repo 配置 → 下载元数据（包清单+依赖关系）→ 计算依赖链 → 批量下载安装 rpm。
CentOS 7 用 yum；CentOS 8+/Rocky/AlmaLinux 用 dnf（完全兼容 yum 语法，性能更强）。
源分类：公网源（阿里/163/官方）、本地光盘源、自建私有源。

【③ 仓库配置（/etc/yum.repos.d/*.repo）】
标准模板：
[base]                               # 仓库 ID（唯一）
name=CentOS-$releasever - Base - Aliyun
baseurl=https://mirrors.aliyun.com/centos/$releasever/os/$basearch/
gpgcheck=1                           # 开启校验防篡改
gpgkey=https://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
enabled=1                            # 1 启用 0 禁用
本地光盘源（无外网）：mount /dev/cdrom /mnt/cdrom
  baseurl=file:///mnt/cdrom ｜ gpgcheck=0 ｜ enabled=1
生成元数据缓存：yum clean all && yum makecache

【③ 高频命令】
yum search nginx                    # 搜索
yum install nginx -y                # 安装
yum update nginx -y / yum update -y # 升级指定 / 全系统
yum remove nginx -y                 # 卸载
yum list installed | grep nginx    # 查已装
yum info nginx / yum provides /usr/bin/nginx   # 详情 / 查文件所属包
yum install --downloadonly --downloaddir=/tmp nginx  # 只下载不装（离线备份）
yum history / yum history undo 10  # 历史 / 撤销第 10 条操作
分组：yum grouplist / yum groupinstall "Development Tools" -y / yum groupremove

【③ 源管理】
yum install nginx --disablerepo=epel    # 临时禁用某仓库
yum install nginx --enablerepo=epel     # 只用指定仓库
yum repolist all                        # 列出所有仓库

【⑤ 🎯 面试考点】
🎯 yum 和 rpm 的关系？ → rpm 是底层打包工具不解决依赖；yum 在 rpm 之上自动解决依赖。
🎯 配置仓库后为什么要 makecache？ → 把远程元数据下载到本地，后续查询/安装不重复联网。
```

### 8.3 Debian 系 APT ★

```md
【② 与 yum 对照】
dpkg（底层，对应 rpm，不自动解决依赖）/ apt（上层，对应 yum，自动依赖）。
源配置 /etc/apt/sources.list：deb 地址 版本代号 组件
  例 Ubuntu 22.04：deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
  代号：jammy=22.04、focal=20.04、Debian12=bookworm
  组件：main 官方开源 ｜ restricted 专有驱动 ｜ universe 社区维护 ｜ multiverse 版权受限
改完源先 apt update 同步

【③ 高频命令】
apt update                          # 同步元数据（必做）
apt upgrade -y                      # 升级（不删旧依赖）
apt full-upgrade -y                 # 大版本升级（自动处理依赖增减）
apt install nginx -y                # 安装
apt install ./nginx.deb             # 本地 deb 自动补依赖
apt remove nginx / apt purge nginx  # 卸载（保留/删除配置）
apt autoremove -y                   # 清残留依赖
apt clean                           # 清下载缓存
apt search / show nginx             # 搜索 / 详情
apt list --installed / --upgradable # 已装 / 可升级
apt-file find /usr/bin/nginx        # 查文件所属包（需先 apt install apt-file + apt-file update）

【③ 底层 dpkg】
dpkg -i nginx.deb                   # 装本地包；缺依赖后执行 apt -f install -y 修复
dpkg -l | grep nginx / dpkg -L nginx / dpkg -S /usr/sbin/nginx / dpkg -r / dpkg -P（留/删配置）

【③ 版本锁定】
apt-mark hold nginx / unhold / showhold   # 锁定/解锁/查看锁定

【④ 易错点】
- Ubuntu 改完 sources.list 必须 apt update，否则装的是旧列表。
- 本地 deb 用 apt install ./xxx.deb 而不是 dpkg -i，因为 apt 会自动补依赖。
```

### 8.4 源码编译安装 ★

```md
【① 一句话本质】
包管理器装不了自定义模块或要最新版时，自己下载源码编译——灵活但运维成本高。

【③ 标准三步】
./configure --prefix=/usr/local/nginx --with-http_ssl_module
    # 1. 检测系统环境/依赖/编译器，生成 Makefile；--prefix 指定目录（★必须，方便卸载+多版本共存）
make -j4                            # 2. 调用 gcc 编译（-j4 用 4 核加速）
make install                       # 3. 复制到 --prefix 目录

【③ 完整示例：Nginx 源码编译】
wget https://nginx.org/download/nginx-1.26.1.tar.gz && tar zxf nginx-1.26.1.tar.gz && cd nginx-1.26.1
./configure --prefix=/usr/local/nginx --with-http_ssl_module
make -j4 && make install
ln -s /usr/local/nginx/sbin/nginx /usr/local/bin/nginx   # 软链接进 PATH
nginx -v

【③ 依赖准备（先装工具链，否则 configure 报错）】
CentOS：yum groupinstall "Development Tools" -y ｜ yum install openssl-devel pcre-devel zlib-devel -y
Ubuntu：apt install build-essential libssl-dev libpcre3-dev zlib1g-dev -y

【③ 卸载】
rm -rf /usr/local/nginx            # 直接删安装目录（源码无统一卸载命令）
部分软件支持 cd 源码目录 && make uninstall

【② 优缺点】
优点：自定义模块（包管理器做不到）、自由指定路径多版本共存、拿最新版、编译优化性能更高、跨发行版通用
缺点：手动解决依赖、无包管理器查询/升级、升级需重新编译、卸载繁琐易残留、缺 systemd 单元文件需手动写

【④ 通用排坑】
no acceptable C compiler → 没装 gcc ｜ xxx.h not found → 缺 -devel/-dev 开发库
make 内存不足 → 降 -j 单线程 ｜ 命令找不到 → 没软链接/PATH ｜ 多版本冲突 → 用 --prefix 隔离
```

### 8.5 常用基础服务部署 ★

```md
【③ 1. chrony 时间同步（NTP，CentOS7+/Ubuntu 默认）】
yum/apt install chrony -y
vim /etc/chrony.conf   # server ntp.aliyun.com iburst（阿里 NTP 源）
systemctl start/enable chronyd
chronyc sources / chronyc tracking / chronyc makestep   # 状态 / 详情 / 强制同步
ntpdate ntp.aliyun.com   # 临时一次性同步
★用途：日志、数据库、集群要求时间一致，时间错位会出诡异故障。

【③ 2. DNS 客户端 + BIND 自建解析】
临时：echo "nameserver 223.5.5.5" > /etc/resolv.conf
永久：CentOS 网卡 ifcfg DNS1=223.5.5.5；Ubuntu /etc/netplan 或 /etc/systemd/resolved.conf
BIND 自建：yum install bind bind-chroot；/etc/named.conf 设 allow-query { 192.168.1.0/24; };
正向 zone A 记录：www IN A 192.168.1.10；named-checkconf / named-checkzone 校验；
systemctl start named；nslookup/dig www.demo.com @127.0.0.1 测试。

【③ 3. rsync 增量同步 + inotify 实时同步】
rsync -avz /data/ /backup/                              # 本地增量
rsync -avz /data/ root@192.168.1.20:/data/              # 远程（ssh）
rsync -avz --delete /data/ root@192.168.1.20:/data/     # 镜像（删目标多余文件）
服务端模式 /etc/rsyncd.conf [data] path=/data ...；客户端 --password-file
inotify 实时：inotifywait -mrq --format '%w%f %e' /data | while read file event; do rsync -avz --delete /data/ root@192.168.1.20:/data/; done

【③ 4. NFS 局域网共享（Linux 间）】
服务端：yum install nfs-utils rpcbind；/etc/exports 写 /data 192.168.1.0/24(rw,sync,no_root_squash)
exportfs -r（生效）；systemctl start rpcbind nfs-server
客户端：mount -t nfs 192.168.1.10:/data /mnt/nfs；fstab 写 192.168.1.10:/data /mnt/nfs nfs defaults 0 0；showmount -e 查看共享

【③ 5. FTP vs Samba】
vsftpd（跨平台传输，21 端口）：yum install vsftpd；/etc/vsftpd.conf 设 anonymous_enable=NO / local_enable=YES / write_enable=YES；systemctl start vsftpd；ftp/lftp 测试
Samba（Windows↔Linux 共享）：yum install samba samba-client；/etc/samba/smb.conf [share] path/browseable/writable/valid users；useradd + smbpasswd -a；testparm 校验；systemctl start smb nmb；Linux mount -t cifs //ip/share；Windows 访问 \\ip\share

【② 服务用途速记】
chrony 管时间统一 ｜ DNS 管域名转 IP ｜ rsync 管定时/实时备份 ｜ NFS 管 Linux 间高速共享 ｜ vsftpd 管跨平台文件传输 ｜ Samba 管 Windows-Linux 互通
```

---

## 模块9：Shell 脚本编程（初级→中级的核心门槛）

**定位**：运维核心硬技能，实现自动化的基础，面试必考。

### 核心知识点

- ★ 脚本基础：格式、三种执行方式、变量分类（环境/局部/位置/特殊）
- ★★ 特殊变量：**`$@` 与 `$*` 的区别**
- ★ 运算符：算术、整数/字符串比较、逻辑、文件测试
- ★ 条件判断：`if/elif/else`、`case`、`[[ ]]`、正则 `=~`
- ★★ 循环与**管道子 Shell 变量失效**陷阱
- ★ 函数：传参、`return` 状态码、返回字符串的两种方式、`local`
- ★ 数组：索引数组、关联数组、遍历、片段、替换
- ★ 生产规范：`set -euo pipefail`、退出码、日志函数、错误处理
- ★ 进阶：select 菜单、getopts、trap、调试三板斧

**学习目标**

能独立编写系统巡检、数据备份、日志清理、批量处理类生产脚本，代码规范、可维护。

### 9.1 脚本基础与变量 ★

```md
【② 脚本格式】
首行必须是解释器声明：#!/bin/bash；注释只有 # 单行，没有多行注释符。
标准开头：#!/bin/bash ＋ 作者/功能注释，再 chmod +x demo.sh。

【② 三种执行方式（核心区别在是否开子进程）】
./demo.sh                  # 方式1：开子 shell 运行（推荐）；需 chmod +x；变量不污染当前终端
bash demo.sh               # 方式2：开子 shell，忽略首行 #!，无需执行权限
source demo.sh / . demo.sh # 方式3：在当前终端执行，变量/函数留存（★适合加载配置、改环境变量）

【② 四大类变量】
1) 环境变量（export 导出，所有子 shell 继承）：echo $PATH/$HOME/$USER/$PWD/$SHELL
   export APP_NAME="nginx"   # 自定义导出后子 shell 才能读到
2) 局部变量：脚本普通变量或函数内 local，子 shell 不可见
   name="test"              # 普通变量
3) 位置变量（执行脚本传入的参数）：./demo.sh aaa bbb → $1=aaa $2=bbb；$0 是脚本名；
   超过 9 个参数用大括号 ${10}
4) 特殊变量：$# 参数个数 ｜ $@ 所有参数 ｜ $* 所有参数 ｜ $$ 当前PID ｜ $! 上条后台PID ｜ $? 上条命令返回码

【④ 易错点】
- 赋值**等号两边不能有空格**：name="abc" 正确，name = "abc" 报错。
- 调用变量加 $；边界歧义用大括号：${name}_log。
- readonly VERSION="1.0" 后不可修改。
```

### 9.2 特殊变量与 $@/$* 区别 ★★

```md
【② $$ / $# / $?】
$$  ：当前脚本 PID，常用于临时文件 /tmp/log.$$
$#  ：参数总个数，if [ $# -lt 1 ] 用来判断缺参数
$?  ：上一条命令退出码，0 成功、非 0 失败（流程判断必用）

【② ★$@ 与 $* 的区别（面试高频）】
两者都代表全部参数，差异只在"双引号包裹后"：
- 无引号：$@ 和 $* 行为一致，都按空格切分
- "$@"：每个参数独立保留原始边界（★循环遍历首选，带空格的参数不会拆开）
- "$*"：所有参数合并成单个字符串（默认空格连接），循环只会执行 1 次

【③ 实操对比】
执行 ./test.sh "hello world" 666 test
for arg in "$@"; do echo "[$arg]"; done
  → [hello world] [666] [test]      # 3 次，空格保留
for arg in "$*"; do echo "[$arg]"; done
  → [hello world 666 test]           # 1 次，全揉成一条

【⑤ 🎯 面试考点】
🎯 遍历脚本参数用哪个？ → 永远用 "$@"，它能保留每个参数的原始空格。
🎯 "$*" 什么时候用？ → 极少，仅在需要把所有参数拼成一整串文本时。
```

### 9.3 运算符 ★

```md
【③ 算术运算（仅整数，小数用 bc）】
echo $((a + b))   # 加 ｜ $((a - b)) 减 ｜ $((a * b)) 乘 ｜ $((a / b)) 整除 ｜ $((a % b)) 取余 ｜ $((a ** b)) 幂
expr $a + $b      # 旧式，符号前后必须空格
echo $((i++)) / $((++i))   # 先取值再加 / 先加再取值
echo "scale=2; 10 / 3" | bc   # 小数计算

【③ 整数比较】
[ $x -gt 5 ]   # -eq 等 -ne 不等 -gt 大于 -ge 大于等于 -lt 小于 -le 小于等于
(( x < 10 ))   # 双括号可直接用 > < ==，更直观

【③ 字符串比较】
[ "$str1" = "$str2" ] / [ "$str1" != "$str2" ]   # 相等/不等
[ -z "$str" ]   # 空 ｜ [ -n "$str" ]   # 非空
★变量必须双引号包裹，防止空变量导致语法报错

【③ 逻辑运算】
[ ] 用 -a 与、-o 或、! 非
[[ ]] / (( )) 用 && || !（推荐）
短路：ls /tmp && echo "存在"  ｜  ls /xxx || echo "不存在"

【③ 文件测试】
[ -f "/etc/hosts" ] 普通文件 ｜ [ -d dir ] 目录 ｜ [ -e ] 存在 ｜ -r -w -x 权限

【⑤ 🎯 面试考点】
🎯 为什么字符串比较变量要加双引号？ → 空变量展开后变成 `[ = "x" ]` 语法错；加引号变 `[ "" = "x" ]` 正确。
```

### 9.4 条件判断 if / case / [[ ]] / =~ ★

```md
【③ if/elif/else】
if (( num > 20 )); then ...
elif (( num == 18 )); then ...
else ... fi

【③ 三种测试：test / [ ] / [[ ]]】
test 等价于 [ ]；[ ] 不支持正则、逻辑用 -a/-o、变量空易错。
[[ ]]（★推荐生产）：支持 =~ 正则、直接 && ||、通配符、自动容错空变量。
  str="hello123"; if [[ $str == hello* ]]; then echo "以 hello 开头"; fi

【③ 正则匹配 =~（仅 [[ ]] 可用，正则不能加引号）】
phone="13812345678"
if [[ $phone =~ ^1[3-9][0-9]{9}$ ]]; then echo "手机号合法"; fi

【③ case 多分支（固定选项/通配符）】
read -p "操作:" opt
case $opt in
  start) systemctl start nginx ;;
  stop)  systemctl stop nginx ;;
  *.log) echo "日志文件" ;;
  *) echo "输入错误" ;;
esac

【⑤ 🎯 面试考点】
🎯 test/[ ]/[[ ]] 怎么选？ → 一律用 [[ ]]，正则、&&、通配符、容错全面更强。
```

### 9.5 循环与管道子 Shell 陷阱 ★★

```md
【③ for 循环】
for file in /etc/*.conf; do echo "$file"; done        # 列表遍历
for arg in "$@"; do echo "$arg"; done                  # 遍历参数（用 "$@"）
for ((i=1; i<=5; i++)); do echo "$i"; done             # C 风格数字循环
break 跳出 / continue 跳过本次

【③ while 循环】
i=1; while (( i <= 3 )); do echo "$i"; ((i++)); done   # 条件循环
while true; do sleep 1; echo run; done                 # 死循环

【③ ★while read 逐行读取（生产高频）】
while IFS= read -r line; do echo "|$line|"; done < test.txt
  # IFS= 关闭行分割保留首尾空格；-r 禁止反斜杠转义；用 < 重定向而非 cat

【② ★★管道导致子 Shell 变量失效（核心坑）】
count=0
cat test.txt | while IFS= read -r line; do ((count++)); done
echo "$count"   # 输出 0！管道右边在子 shell 执行，count 修改传不回父 shell

解决方案（三选一）：
  方案1（★最优）：改用输入重定向
    count=0; while IFS= read -r line; do ((count++)); done < test.txt
  方案2：进程替换（不创建子 shell）
    while IFS= read -r line; do ((count++)); done < <(cat test.txt)
  方案3：把后续逻辑整体放进子 shell 的 {} 里

【③ until 循环】条件不成立才执行：until ((i>3)); do echo $i; ((i++)); done

【⑤ 🎯 面试考点】
🎯 管道里改的变量为什么丢了？ → 管道右侧开全新子 shell，子 shell 的修改不影响父 shell。
🎯 怎么解决？ → 用输入重定向 < file 或进程替换 < <(cmd) 代替 cat | while。
```

### 9.6 函数 ★

```md
【③ 定义与调用】
func1() { echo "普通函数"; }          # 通用写法（推荐）
function func2 { echo "bash 专属"; }   # bash 写法
func1                                  # 调用直接写函数名，不加括号

【③ 传参】用位置变量，调用时空格跟值
test_arg() { echo "第1个:$1 总数:$# 全部:$@"; }
test_arg apple banana

【③ return 返回状态码】
return 只能返回 0~255 整数（存于 $?），不能返回字符串：
check_num() { if (( $1 > 10 )); then return 0; else return 1; fi; }

【③ 返回字符串的两种方式】
方式1（★推荐）：echo 输出 + $() 捕获
  get_name() { echo "zhangsan"; }
  res=$(get_name)
方式2：修改全局变量传值（适合大数据）
  get_msg() { out="hello"; }   # 外部直接读 $out

【③ local 局部变量】避免污染全局
demo() { local a=100; b=200; }   # a 仅函数内；b 是全局

【⑤ 🎯 面试考点】
🎯 函数怎么返回字符串？ → 不能 return，要用 echo + $(func) 捕获，或改全局变量。
🎯 为什么用 local？ → 避免函数内变量覆盖同名的全局变量。
```

### 9.7 数组 ★

```md
【③ 索引数组（数字下标，默认从 0）】
arr=("apple" "banana" "orange"); arr[5]="pear"
echo ${arr[0]} ${arr[-1]}        # 取首/取倒数第一
echo ${arr[@]}                   # 所有元素
echo ${#arr[@]}                  # 元素个数

【③ 关联数组（key-value，必须先 declare -A）】
declare -A info
info=(["name"]="zhangsan" ["age"]=20)
info["job"]="ops"
echo ${info["name"]}             # 取值
echo ${!info[@]}                 # 所有 key
echo ${info[@]}                  # 所有 value

【③ 遍历】
for val in "${fruit[@]}"; do echo "$val"; done                 # 索引：遍历值
for i in "${!fruit[@]}"; do echo "$i=${fruit[$i]}"; done      # 索引：带下标
for k in "${!info[@]}"; do echo "$k=${info[$k]}"; done         # 关联：key+value

【③ 片段与替换】
echo ${nums[@]:1:2}              # 从下标1取2个
echo ${nums[@]:2}                # 从下标2取到末尾
echo ${files[@]/log/txt}         # 仅替换首个匹配
echo ${files[@]//log/txt}        # 全局替换
new=("${files[@]//log/txt}")     # 替换生成新数组

【③ 其他操作】
arr+=("watermelon")               # 追加
unset arr[2]                      # 删单个 ｜ unset arr 删整个
if [[ " ${arr[@]} " =~ " $target " ]]; then echo "存在"; fi   # 包含判断

【⑤ 🎯 面试考点】
🎯 关联数组怎么用？ → 先 declare -A 声明，再 info["k"]="v" 赋值，否则报错。
```

### 9.8 生产规范（可维护性基线） ★

```md
【③ set -euo pipefail（生产脚本必加首行）】
set -e               # 任意命令非 0 退出码，脚本立即终止（避免错误继续执行）
set -u               # 使用未定义变量直接报错退出（防空变量逻辑异常）
set -o pipefail      # 管道中任意命令失败，整条管道返回失败（默认只取最后一条结果，会掩盖上游错误）
（set -x 调试用，上线注释）

【③ 退出状态码统一规范】
0 成功 ｜ 1 参数错误 ｜ 2 文件/目录不存在 ｜ 3 命令执行失败 ｜ 4 权限不足

【③ 日志函数封装（同时屏显 + 写文件）】
log_info() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_warn() / log_error() 同理（改级别）
init_log() { mkdir -p "$LOG_DIR" || exit 4; }   # 日志目录自动创建

【③ 错误处理标准写法】
error_exit() { log_error "$1"; exit "${2:-3}"; }   # 统一打印+退出
cat "$file" || error_exit "读取 $file 失败"         # 关键命令后捕获异常
前置校验参数/文件/目录/权限，错误提前拦截

【③ 注释规范】
文件头：作者、日期、功能、用法、入参 ｜ 函数：用途/入参/返回码/风险
★禁止：大量无意义注释、注释掉的废弃代码（直接删）

【⑤ 🎯 面试考点】
🎯 为什么生产脚本要 set -euo pipefail？ → 防错误命令继续执行、防空变量异常、防管道上游错误被掩盖。
```

### 9.9 进阶技巧（加分项） ★

```md
【③ select 菜单】自动生成编号菜单，替代手写 while+read
PS3='请选择: '; select opt in 启动 停止 重启 退出; do
  case $opt in 启动) systemctl start nginx;; 退出) break;; *) echo "无效";; esac
done

【③ getopts 参数解析】规范处理 -h 主机 -p 端口 选项
while getopts "h:p:n" opt; do
  case $opt in h) HOST=$OPTARG;; p) PORT=$OPTARG;; n) FORCE=1;; \?) exit 1;; esac
done
shift $((OPTIND - 1))   # 剔除选项，剩下的是位置参数

【③ trap 信号捕获】退出前清理临时文件
trap 'echo 清理; rm -f /tmp/*.tmp; exit 1' INT TERM
trap 'echo 完毕' EXIT

【③ 调试三板斧】
bash -x script.sh          # 逐条打印执行过程（最常用）
set -x ... set +x          # 只对中间某段启用跟踪
set -euo pipefail          # 遇错即停 + 未定义变量报错 + 管道失败即整体失败

【③ 实用小技巧】
echo $((RANDOM % 100 + 1))          # 1-100 随机数
echo "耗时 $SECONDS 秒"              # SECONDS 自动统计运行秒数
tmp=$(mktemp /tmp/xxx.XXXXXX)       # 自动生成不冲突临时文件
read -t 10 -p "请输入:" ans          # 10 秒超时自动跳过
```

---

## 模块10：日志管理与系统排障体系

**定位**：运维的核心价值——保障业务稳定，排障能力直接体现水平。

### 核心知识点

- ★ 系统日志体系：rsyslog 原理、日志级别、`/var/log` 核心文件（messages/secure/cron/maillog）
- ★ 日志轮转：logrotate 配置、压缩与保留策略
- ★ journalctl：systemd 统一日志查询
- ★★ **四维排障方法论**：CPU / 内存 / 磁盘 IO / 网络
- ★ 高级工具：`lsof`、`strace`、`pidstat`

**学习目标**

遇到系统慢、服务异常、磁盘满等常见故障有清晰排查思路，能通过日志定位问题根源。

### 10.1 系统日志体系 ★

```md
【② rsyslog 原理】
应用/内核产生日志 → 写入入口（/dev/log 本地套接字、kmsg 内核缓冲、TCP/UDP 514 远程）→ rsyslogd 守护进程按"设施+级别"过滤分类 → 写入 /var/log 文件或转发远端。

【② Facility 设施（日志来源）】
auth/authpriv → secure（认证/ssh/sudo）｜ cron → cron（定时任务）｜ mail → maillog
kern 内核 ｜ user 用户程序 ｜ daemon 后台服务 ｜ local0~local7 自定义（nginx/tomcat 常用 local7）

【② 日志级别（0 最严重 ~ 7 调试）】
0 emerg 崩溃 ｜ 1 alert 立即处理 ｜ 2 crit 严重 ｜ 3 err 错误 ｜ 4 warn 警告 ｜ 5 notice ｜ 6 info（默认收集级别）｜ 7 debug（生产关闭）
配置语法：设施.级别 目标；例 *.info;mail.none;authpriv.none /var/log/messages（所有 info 写入，但邮件/认证单独存）

【② /var/log 核心文件（CentOS/RHEL）】
/var/log/messages：系统综合主日志（启动、服务、内核普通信息），排除认证/cron/邮件；tail -f 实时看
/var/log/secure（★安全排查最常用）：ssh 登录、sudo、密码错误、su；grep "Failed password" 查暴力破解
/var/log/cron：定时任务执行与报错
/var/log/maillog：邮件收发与退信
配套：dmesg（内核硬件）、lastlog（lastlog 命令）、wtmp（last 登录历史）、btmp（lastb 失败登录）、httpd/（Apache 独立）

【③ 配置与重载】
主配置 /etc/rsyslog.conf；改完 systemctl restart rsyslog

【⑤ 🎯 面试考点】
🎯 secure 日志能排查什么？ → ssh 暴力破解、异常登录、sudo 提权、密码错误。
🎯 级别数字越小越严重还是越大？ → 越小越严重（0 emerg 最高优先级）。
```

### 10.2 日志轮转 logrotate ★

```md
【① 一句话本质】
rsyslog 只会无限追加，logrotate 负责按周期"切割、压缩、备份、清理"，防止撑爆磁盘。

【③ 配置位置】
主配置 /etc/logrotate.conf（全局默认）；独立服务放 /etc/logrotate.d/（nginx/mysql 等）

【③ 核心参数】
周期：daily / weekly / monthly / yearly
rotate N            # 保留 N 份历史，超出自动删
compress / nocompress / delaycompress   # 压缩 / 不压缩 / 延迟一轮再压（nginx 持续写场景）
copytruncate       # ★复制后清空原文件，无需重启服务（nginx/tomcat 必备）
create 0600 root root   # 切割后新建日志，指定权限属主
postrotate/endscript   # 轮转后执行（重载服务）
missingok / notifempty  # 文件缺失不报错 / 空文件不轮转
size 100M           # 不按时间，达到大小立即切

【③ 模板示例】
/var/log/nginx/*.log {
    daily; rotate 30; compress; delaycompress; missingok; notifempty
    copytruncate       # 不用重载 nginx
    size 500M          # 超 500M 强制切
}
/var/log/messages /var/log/secure {
    daily; rotate 7; compress; delaycompress; create 0600 root root
    sharedscripts; postrotate /usr/bin/systemctl reload rsyslog >/dev/null 2>&1; endscript
}

【③ 调试命令】
logrotate -d /etc/logrotate.d/nginx   # 模拟执行（只打印不真切，排错首选）
logrotate -f /etc/logrotate.d/syslog  # 强制立即轮转
cat /var/lib/logrotate/logrotate.status  # 查看状态

【⑤ 🎯 面试考点】
🎯 copytruncate 和 create 区别？ → copytruncate 清空原文件（服务持续写不用重启）；create 新建文件（常需重载服务 reopen）。
```

### 10.3 journalctl 查询 ★

```md
【③ 基本与常用】
journalctl                 # 全部日志（分页）
journalctl -xe             # ★最近错误 + 附加说明（排障第一条命令）
journalctl -u nginx        # 只看某服务（-u nginx -u mysql 看多个）
journalctl --since "1 hour ago" / --since "2026-08-25 10:00" / --since today
journalctl -f              # 实时跟踪（类似 tail -f）
journalctl -n 50           # 最近 50 行
journalctl -p err          # 只看 err 及以上
journalctl --no-pager      # 不分页，便于管道 grep

【② 与 rsyslog 的关系】
journald 默认把日志存内存环形缓冲，重启会丢；生产应配 rsyslog 持久化，或用 journalctl --vacuum-size=500M 控制磁盘占用。
排查服务起不来：journalctl -xe 比 grep messages 更直观。

【⑤ 🎯 面试考点】
🎯 服务起不来先看什么？ → journalctl -u 服务名 -xe，直接看最近报错。
```

### 10.4 四维排障方法论 ★★

```md
【② CPU 维度：top/vmstat/pidstat -u/uptime】
负载均值（1/5/15min）：以 CPU 核心数为基准，4 核负载 4 = 满载，>4 排队；短期高(1min高、5/15低)=瞬时峰值，长期三高=持续瓶颈。
★误区：负载高 ≠ CPU 使用率高，磁盘 IO 阻塞也会拉高负载。
%Cpu 行：us 业务代码（长期高=计算密集）｜ sy 内核（频繁 IO/上下文切换/锁竞争）｜ wa IO 等待（★wa 高=磁盘 IO 瓶颈，拉高负载但 CPU 空闲）｜ id 空闲 ｜ si 软中断（小包风暴）
步骤：uptime 看负载 → top 按 P 排 CPU 定位进程 PID → vmstat 3 看 wa/us → pidstat -u -p PID 定位线程

【② 内存维度：free -h/vmstat/pidstat -r】
free 字段：free 裸空闲（★数值小属正常）｜ buff 块设备缓冲 ｜ cache 文件页缓存（可回收）｜ available ★业务可用内存（判断内存是否充足唯一标准）
buff vs cache：buff 面向块设备（磁盘读写缓冲）；cache 面向文件（读过的文件缓存）
内存泄漏判断：available 持续下跌、free 变小且 buff/cache 不释放、单进程 RSS/VSZ 缓涨、最终 OOM Killer（日志 Out of memory: Kill process）
步骤：free -h 看 available → top 按 M 排内存定位 PID → pidstat -r -p PID 看趋势 → 查 messages OOM 日志 → 应急 echo 3 > /proc/sys/vm/drop_caches

【② 磁盘 IO 维度：iostat -x 2/sar -d/iotop/vmstat wa】
iostat 核心：%util 接近 100% = 磁盘饱和；rMB/s/wMB/s 吞吐；r_await/w_await >10ms = 延迟高；avgqu-sz 队列堆积
场景：随机读 cache 命中低 r_await 高；随机写 w_await/%util 打满；wa 持续 >30 进程卡 IO
步骤：vmstat 看 wa → iostat -x 2 定位哪块盘 %util 100% → iotop -oP 定位进程（MySQL/日志/备份）→ sar -d 历史回放

【② 网络维度：sar -n DEV/iftop/nload、ping/mtr、ss -s/tcpdump】
带宽打满：sar 看 rxkB/s/txkB/s 接近上限；iftop 定位 IP
延迟高：ping 平均 >50ms 内网异常；mtr 逐跳定位
丢包：ping packet loss；mtr 区分本机(网卡/防火墙限流)/中间链路(运营商)/对端(CPU磁盘满)
TCP 连接爆满：ss -s 看 Established/Time_wait/Syn_recv；Time_wait 爆炸调 tcp_tw_reuse；Syn_recv 堆积=扫描/攻击；连接耗尽调 nofile
流程：mtr（延迟+丢包）→ sar -n DEV（带宽）→ ss -s（连接状态）→ ss -ti（重传>0 网络不稳）→ telnet/curl（应用层）→ tcpdump（抓包）

【⑤ 🎯 面试考点】
🎯 负载高但 CPU 空闲，可能是什么原因？ → 磁盘 IO 瓶颈（wa 高）或大量 D 状态进程等待 IO。
🎯 看内存到底看哪个字段？ → available，不是 free（buff/cache 是可回收的缓存）。
```

### 10.5 高级工具 lsof / strace / pidstat ★

```md
【③ pidstat（进程级综合监控）】
分进程精细化输出 CPU/内存/IO/上下文切换，比 top 精准，支持持续采样。
-u CPU ｜ -r 内存(RSS/VSZ/缺页) ｜ -d 磁盘IO ｜ -w 上下文切换 ｜ -t 线程 ｜ -p PID ｜ 数字2每2秒
pidstat -u 2 / pidstat -r -p 1234 2(泄漏观测) / pidstat -d -p $(pgrep mysql) 2 / pidstat -w 2
关键指标：%usr 业务 / %system 内核；majflt 高=频繁 swap 换页；nvcswch/s 非自愿切换持续高=CPU不足/锁竞争/IO阻塞

【③ lsof（list open files，一切皆文件）】
lsof -i:80 / lsof -i tcp:3306        # 查端口对应进程（替代 netstat）
lsof -p 1234                        # 查 PID 打开的句柄；| wc -l 统计（句柄泄漏）
lsof | grep deleted                 # ★已删除但未释放的大文件（df 高 du 找不到时就查它）
lsof -u nginx / lsof -i             # 用户所有进程 / 所有网络连接
场景：df 满 du 找不到→lsof|grep deleted；address already in use→lsof -i:端口；too many open files→调 ulimit

【③ strace（系统调用追踪，底层万能排错）】
拦截进程所有系统调用（open/read/write/connect 等），定位卡顿、文件缺失、权限失败、网络慢。
-p PID 附加 ｜ -c 统计耗时/次数 ｜ -e trace=open,read,write 过滤 ｜ -T 耗时 ｜ -tt 毫秒时间戳 ｜ -o 文件
strace -tt -p $(pgrep mysqld) / strace -c -p 1234 / strace ./test.sh
典型定位：open() 返回 -1 ENOENT=配置找不到；-1 EACCES=权限不足；connect 耗时大=网络慢；mmap 频繁=换页；DNS 卡在 connect 53

【② 三者分工】
pidstat 宏观看进程资源趋势 ｜ lsof 查文件/句柄/端口占用（端口冲突、句柄泄漏、已删文件占盘）｜ strace 微观追踪系统调用找卡慢根因
```

二、完整学习路线图（分阶段落地）

阶段一：入门上手期（1~2周）

- **学习内容**：模块1 + 模块2 + 模块3
- **核心目标**：熟悉 Linux 操作习惯，掌握文件与用户权限管理
- **实战任务**：搭建 3 台虚拟机集群，创建多用户并分配不同权限，实现普通用户 sudo 提权

阶段二：命令精通期（2~3周）

- **学习内容**：模块4
- **核心目标**：命令形成肌肉记忆，三剑客能独立处理文本需求
- **实战任务**：用三剑客完成 Nginx 日志的 IP 统计、状态码统计、错误日志过滤；每天坚持敲命令练习

阶段三：系统管理期（2~3周）

- **学习内容**：模块5 + 模块6 + 模块7
- **核心目标**：掌握系统四大资源（进程、磁盘、网络、内存）的管理与排障
- **实战任务**：给服务器新增一块磁盘做 LVM 扩容；配置 iptables 白名单防火墙；编写 crontab 定时备份任务

阶段四：服务与脚本期（3~4周）

- **学习内容**：模块8 + 模块9
- **核心目标**：具备独立部署服务、编写自动化脚本的能力
- **实战任务**：部署 LNMP 环境；编写完整的系统巡检脚本；编写日志清理与备份脚本

阶段五：排障巩固期（1~2周）

- **学习内容**：模块10 + 全知识点串联
- **核心目标**：形成完整的知识体系，建立排障思维
- **实战任务**：模拟常见故障（端口不通、服务启动失败、磁盘满、系统慢），独立排查并解决

---

三、高效学习建议

1. **拒绝只看视频，必须动手实操**：运维是实操性极强的岗位，每一个命令、每一条规则都要亲手敲一遍，观察输出结果。
2. **重视原理，不要死记硬背**：比如 iptables 先懂四表五链和数据包流向，再记语法；先懂 inode 原理，再理解软硬链接。
3. **用生产场景驱动学习**：不要孤立学知识点，比如学完三剑客就去分析真实日志，学完 Shell 就去解决真实的批量处理需求。
4. **基础打牢再学进阶**：核心基础不扎实的情况下，不要急于学 Docker、K8s、Ansible 等进阶内容，否则很容易遇到底层问题无从下手。

基础全部掌握后，可按照自动化运维→监控告警→云原生的路径继续进阶，对应初中级运维的完整能力体系。

# 中级运维的完整能力体系: 核心服务与中间件层

## 一、Web 反向代理层（中级运维第一核心）

1. Nginx 完整中级知识点（全覆盖）

### 1）基础架构

**① 一句话本质**：Nginx 用 master-worker 多进程 + epoll 事件驱动，单 worker 单线程异步非阻塞即可处理上万并发，是高性能反向代理的基石。


- Nginx 进程模型：master/worker 机制、CPU 亲和绑定
- 编译 / 官方包生产部署、目录结构解读
- 核心模块结构：main、events、http、server、location

``` md
Nginx 基础架构（中级核心深度版）

一、Nginx 进程模型：master / worker 机制

1. 双进程角色分工

Nginx 采用 **多进程单线程** 的事件驱动架构，启动后默认分为两类进程：

**master 主进程（1 个）**：管理控制角色，不处理业务请求
读取并校验配置文件，维护全局配置
启动、监控、管理 worker 工作进程
接收外部信号（reload/stop/quit），实现平滑重启、热升级
进程 PID 记录在 `nginx.pid` 文件中
**worker 工作进程（N 个）**：实际处理 HTTP 请求
单线程、非阻塞 IO 模型，通过 epoll 处理并发连接
每个 worker 独立承接请求，进程间互不影响，单个 worker 崩溃不会拖垮整体服务

2. 高并发核心原理

Nginx 高性能的底层支撑：

1. **异步非阻塞事件模型**：worker 采用 epoll 事件驱动，单个进程可同时处理上万连接，无需为每个连接创建新线程，内存与 CPU 开销极低
2. **多进程无锁设计**：worker 进程相互独立，请求处理全程无锁竞争，CPU 利用率高
3. **单线程低开销**：避免多线程上下文切换与锁竞争开销，适合 IO 密集型的 Web 反向代理场景

3. worker 数量与 CPU 亲和绑定

（1）worker 进程数配置

生产环境建议 **worker 数量 = CPU 物理核心数**，最大化利用 CPU 资源，避免进程跨核调度开销。

nginx.conf 全局块配置

worker_processes auto;  # 自动匹配 CPU 核心数，生产推荐

worker_processes 4;   # 手动指定 4 核

（2）CPU 亲和绑定

将每个 worker 进程固定绑定到指定 CPU 核心，减少进程上下文切换，进一步提升性能。

4 核 CPU，依次绑定到 0、1、2、3 号核心

worker_cpu_affinity 0001 0010 0100 1000;

自动分配亲和性（Nginx 1.9.10+ 支持）

worker_cpu_affinity auto;

4. 平滑重载（reload）原理

执行 `nginx -s reload` 时无业务中断，流程如下：

1. master 进程校验新配置语法，语法错误则保留旧配置不生效
2. master 启动新一批 worker 进程，使用新配置承接新请求
3. 旧 worker 进程停止接收新连接，处理完当前所有请求后自动退出
4. 最终全部替换为新配置的 worker，全程无服务中断

二、生产级部署方式

1. 官方源安装（YUM / APT）

适用场景

业务无自定义模块需求、追求稳定省心、便于统一版本管理，是绝大多数企业的首选。

CentOS / RHEL 官方源部署

1. 安装依赖

yum install yum-utils -y

2. 配置 Nginx 官方源

cat > /etc/yum.repos.d/nginx.repo << EOF
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
EOF

3. 安装稳定版

yum install nginx -y

4. 启动+开机自启

systemctl start nginx
systemctl enable nginx

Ubuntu / Debian 官方源部署

apt install curl gnupg2 ca-certificates lsb-release -y
curl -fsSL https://nginx.org/keys/nginx_signing.key | gpg --dearmor -o /usr/share/keyrings/nginx-archive-keyring.gpg
echo " deb [signed-by =/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx " > /etc/apt/sources.list.d/nginx.list
apt update && apt install nginx -y

2. 源码编译安装

适用场景

需要开启第三方模块（如 lua-nginx-module）、自定义安装路径、裁剪功能模块、极致性能优化的场景。

编译核心参数与常用模块

下载解压源码

wget https://nginx.org/download/nginx-1.26.1.tar.gz
tar zxf nginx-1.26.1.tar.gz
cd nginx-1.26.1

配置编译参数

./configure \
prefix=/usr/local/nginx \                  # 指定安装根目录
with-http_ssl_module \                     # HTTPS SSL 模块
with-http_stub_status_module \             # 状态监控模块
with-http_realip_module \                  # 透传真实客户端 IP
with-http_gzip_static_module \             # 静态 gzip 压缩
with-http_v2_module \                      # HTTP/2 支持
with-stream \                              # 四层 TCP/UDP 代理
with-pcre \                                # 正则支持（rewrite 依赖）
user=nginx --group=nginx                   # 运行用户

多核编译+安装
make -j $(nproc)
make install

3. 两种部署方式对比

| 维度 | 官方源安装 | 源码编译安装 |
| --- | --- | --- |
| 部署效率 | 快，一键安装 | 慢，需解决依赖编译 |
| 模块扩展 | 固定官方模块，无法自定义 | 自由增减模块，支持第三方扩展 |
| 版本更新 | yum/apt 一键升级 | 需重新编译覆盖，升级繁琐 |
| 目录结构 | 分散到系统目录（/etc、/usr、/var） | 统一集中在指定 prefix 目录 |
| 适用场景 | 通用业务、标准反向代理 | 定制化需求、性能极致优化 |

三、标准目录结构解读

1. YUM/RPM 安装默认目录（分散式）

| 路径 | 作用 |
| --- | --- |
| `/etc/nginx/nginx.conf` | 主配置文件 |
| `/etc/nginx/conf.d/` | 子配置目录，存放虚拟主机 `.conf` 文件，主配置自动 include |
| `/usr/sbin/nginx` | Nginx 二进制可执行程序 |
| `/var/log/nginx/` | 日志目录（access.log / error.log） |
| `/usr/share/nginx/html/` | 默认站点根目录 |
| `/var/run/nginx.pid` | master 进程 PID 文件 |

2. 源码编译安装目录（集中式，以 `--prefix=/usr/local/nginx` 为例）

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

四、配置文件核心模块层级结构
Nginx 配置采用 **分层嵌套结构**，由外到内作用域逐级收敛，内层配置可覆盖外层。

1. 层级结构总览

main 全局块（最外层）
└── events 块
└── http 块
    ├── http 全局配置
    ├── server 块 1（虚拟主机 1）
    │   ├── server 全局配置
    │   ├── location / {...}
    │   └── location /api {...}
    └── server 块 2（虚拟主机 2）
        └── location ...

2. 各层级作用与核心指令

（1）main 全局块

配置文件最外层，作用于 Nginx 全局，与具体业务请求无关。
核心指令：

worker_processes auto;       # worker 进程数
worker_cpu_affinity auto;    # CPU 亲和
error_log  logs/error.log;   # 全局错误日志
pid        logs/nginx.pid;   # PID 文件路径
user nginx nginx;            # 运行用户/用户组
worker_rlimit_nofile 65535;  # 单个 worker 最大文件句柄数

（2）events 块

控制 Nginx 连接处理底层模型，全局唯一。
核心指令：

events {
    use epoll;                 # 事件驱动模型，Linux 默认 epoll
    worker_connections 10240;  # 单个 worker 最大连接数
    multi_accept on;           # 一次接收多个连接
}

（3）http 块

HTTP 协议全局配置，所有虚拟主机共享，可包含多个 server 块。
核心指令：

http {
    include       mime.types;          # 文件类型映射
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request " '
                      '$status $body_bytes_sent "$http_referer " '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    sendfile        on;                # 高效文件传输
    keepalive_timeout  65;             # 长连接超时
    gzip  on;                          # 开启压缩

    include /etc/nginx/conf.d/*.conf;  # 加载子配置目录

}

（4）server 块

对应一个虚拟主机，通过 `listen` 端口 + `server_name` 域名匹配请求。
核心指令：

server {
    listen       80;
    server_name  www.example.com;      # 绑定域名
    root   /usr/share/nginx/html;      # 站点根目录
    index  index.html index.htm;       # 默认首页

    access_log  /var/log/nginx/www.example.com_access.log  main;
    error_log   /var/log/nginx/www.example.com_error.log;

    # 多个 location 规则
    location / { ... }
    location /api { ... }

}

（5）location 块

最细粒度匹配，根据 URI 路径执行不同规则（反向代理、静态文件、重写等）。
匹配优先级：精确匹配 `=` > 前缀匹配 `^~` > 正则匹配 `~`/`~*` > 普通前缀匹配。
核心示例：

精确匹配首页
location = /index.html {
    root /data/static;
}

正则匹配图片资源，设置缓存

location ~* \.(jpg|png|gif)$ {
    expires 30d;
}

反向代理到后端服务
location /api {
    proxy_pass http://127.0.0.1:8080;
    proxy_set_header Host $host;
}

#补充知识点
epoll 不等于协程，两者完全不是一个层面的东西
1. epoll 是什么

epoll 是 **Linux 内核提供的 IO 多路复用系统调用**，本质是一个 “事件通知器”：

你把成百上千个 socket 连接交给 epoll 管理；
当某个 socket 有数据可读、或者可写的时候，内核会告诉你哪些连接就绪了；
你程序只需要处理这些就绪的连接就行，不用挨个去轮询，也不用阻塞等待。

它解决的问题是：**单线程怎么高效知道 “哪个连接现在有事可做”**。

2. 协程是什么

协程是 **用户态的轻量级执行单元**，由程序自己调度，不用操作系统内核参与。

它可以在代码执行中途主动挂起（yield），去执行别的协程；
之后还能回到挂起的位置继续执行，上下文都保留着；
切换成本非常低，因为是用户态自己切，不经过内核。

3. 为什么你会觉得它们像？

因为两者都能实现「单线程同时处理大量 IO 并发」，但实现路径完全不同：

对比维度    epoll（IO 多路复用）                    协程
层级        内核系统调用                            用户态程序逻辑
作用        监控连接事件，告诉你哪个就绪了            切换代码执行流，挂起 / 恢复任务
代码写法    事件回调，异步风格                        同步写法，逻辑可以中途暂停继续
关系      协程的底层也可以用 epoll 来等待 IO 事件    协程是上层的调度方式，epoll 是它可用的底层工具

打个通俗的比方
**epoll**：就像餐厅的叫号器。一个服务员守着叫号器，哪桌喊号了就去处理哪桌，不用挨个桌子去问 “好了没”。
**协程**：就像这个服务员可以同时做半件事 —— 给 A 桌点单点到一半，先记下来，去给 B 桌送个菜，回来接着给 A 桌点单。
**Nginx 原生模型**：一个服务员 + 一个叫号器（epoll），每桌的活一次性干完，干不完就等下一次叫号再接着干，不会中途切去干别的桌。

1. Nginx 是 **多进程**（1 个 master + N 个 worker，都是独立进程）；
2. 每个 worker 是 **单线程**，不靠多线程堆并发，靠 epoll + 非阻塞 IO 一个线程管上万连接；
3. 原生 Nginx **没有协程**，是事件回调模型；
4. epoll 是内核的 IO 事件通知工具，不是协程；协程是用户态的执行流调度，两者不是一回事。
```


**⑤ 🎯 面试考点**：
- master 与 worker 分工？答：master 读配置、管理 worker、收信号做平滑重启/热升级；worker 实际处理请求，单 worker 崩不影响整体。
- 平滑 reload 为何不中断业务？答：master 校验新配置后起新 worker 接新请求，旧 worker 处理完现有连接再退出，全程无断连。
- epoll 与协程是一回事吗？答：不是。epoll 是内核 IO 多路复用系统调用（事件通知器）；协程是用户态执行流调度；Nginx 原生 epoll+事件回调，无协程。
- worker 数为何等于 CPU 核心数？答：worker 单线程无锁，每核一个可充分利用 CPU、避免跨核调度与上下文切换开销。

### 2）虚拟主机（企业多站点核心）

**① 一句话本质**：一个 Nginx 用多个 server 块按域名/端口/IP 承载多站点，靠 server_name 匹配实现隔离。


- 基于域名、端口、IP 三种虚拟主机
- 多站点隔离配置、目录权限、日志分离

``` md
Nginx 虚拟主机 生产级精简手册（配置+规范+排障）

1. 三种虚拟主机配置方式
1.1 基于域名（生产首选，同 IP 同端口承载多站点）
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

1.2 基于端口（内网测试/内部服务用）
cat > /etc/nginx/conf.d/test-admin.conf <<'EOF'
server {
    listen 8080;
    server_name _;
    root /data/www/test-admin/html;
    access_log /data/www/test-admin/logs/access.log main;
}
EOF

1.3 基于 IP（内外网业务物理隔离）
cat > /etc/nginx/conf.d/internal.conf <<'EOF'
server {
    listen 192.168.1.10:80;
    server_name _;
    root /data/www/internal/html;
}
EOF

2. 多站点生产隔离规范
2.1 标准目录结构（站点独立隔离）
mkdir -p /data/www/{www.aaa.com, www.bbb.com}/{html, logs, tmp, backup}

2.2 权限最小化隔离
属主：部署用户 www；属组：nginx 运行用户
chown -R www: nginx /data/www/www.aaa.com
find /data/www/www.aaa.com/html -type d -exec chmod 750 {} \;
find /data/www/www.aaa.com/html -type f -exec chmod 640 {} \;
仅上传目录单独放开写权限
chmod 770 /data/www/www.aaa.com/html/upload

2.3 server_name 匹配优先级（从高到低）
精确匹配 > 左通配 *.aaa.com > 右通配 www.aaa.* > 正则 > default_server

3. 单站点日志轮转
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

4. 安全配置 + 生效 + 排障
4.1 默认拒绝站点（拦截未匹配域名/IP 直访）
cat > /etc/nginx/conf.d/00-default.conf <<'EOF'
server {
    listen 80 default_server;
    server_name _;
    return 444;
}
EOF

4.2 配置生效标准流程
nginx -t          # 语法校验（必做，防止配置错误宕机）
nginx -s reload   # 平滑重载，业务无中断

4.3 常见故障速查
访问错站点 → 检查 Host 请求头、server_name 优先级、default_server
403 Forbidden → 目录/文件权限、缺失首页、selinux 拦截
404 Not Found → root 路径错误、文件不存在、location 匹配偏差
日志不生成 → 日志目录不存在、nginx 用户无写入权限
```


**⑤ 🎯 面试考点**：
- 三种虚拟主机区别？答：基于域名（同 IP 同端口多站点，生产首选）/基于端口（内网测试）/基于 IP（内外网物理隔离）。
- server_name 匹配优先级？答：精确匹配 > 左通配 *.a.com > 右通配 www.a.* > 正则 > default_server。
- 403/404 常见诱因？答：403=权限不足、无 index、防盗链/IP 黑名单、SELinux；404=root 路径错、文件缺失、location 覆盖、proxy_pass 路径错。

### 3）反向代理核心

**① 一句话本质**：proxy_pass 把客户端请求转发给后端，Nginx 做中介，关键是 URI 拼接规则与真实客户端 IP 透传。


- proxy_pass 反向代理规则、末尾 / 区别
- proxy_set_header 真实透传客户端 IP
- 代理超时、缓存、连接复用调优

``` md
Nginx 反向代理核心 生产精简手册

1. proxy_pass 末尾斜杠核心区别（高频易错）
测试请求：http://www.example.com/api/user/list
规则：带/ = 去掉 location 前缀再转发；不带/ = 完整 URI 拼接转发
cat > /etc/nginx/conf.d/proxy-demo.conf <<'EOF'
server {
    listen 80;
    server_name www.example.com;

    ## 示例 1：末尾带 / → 转发：http://127.0.0.1:8080/user/list（自动去掉 /api 前缀）
    location /api/ {
        proxy_pass http://127.0.0.1:8080/;
    }

    ## 示例 2：末尾不带 / → 转发：http://127.0.0.1:8080/api/user/list（完整拼接 URI）
    location /api/ {
        proxy_pass http://127.0.0.1:8080;
    }
}
EOF

2. proxy_set_header 透传真实客户端 IP
解决：后端默认只能拿到 Nginx 内网 IP，无法获取用户真实地址
cat >> /etc/nginx/conf.d/proxy-demo.conf <<'EOF'
location /api/ {
    proxy_pass http://127.0.0.1:8080;

    # 透传原始域名（后端虚拟主机/业务域名识别）
    proxy_set_header Host $host;
    # 透传客户端真实 IP
    proxy_set_header X-Real-IP $remote_addr;
    # 透传全链路代理 IP（多级代理场景累加）
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    # 透传原始请求协议（http/https，后端判断是否加密）
    proxy_set_header X-Forwarded-Proto $scheme;
}
EOF

3. 代理超时、缓冲、长连接复用调优
cat > /etc/nginx/conf.d/proxy-optimize.conf <<'EOF'
http {
    # ==== ==== == 代理超时三段式 == ==== ====
    proxy_connect_timeout 30s;   # 与后端建立 TCP 连接超时
    proxy_read_timeout    60s;   # 等待后端响应超时（两次接收数据间隔）
    proxy_send_timeout    60s;   # 向后端发送请求数据超时

    # ==== ==== == 代理缓冲（降低后端阻塞，提升吞吐） == ==== ====
    proxy_buffering on;          # 开启缓冲：Nginx 先收完后端响应，再发给客户端
    proxy_buffer_size 4k;        # 响应头缓冲区大小
    proxy_buffers 8 4k;          # 响应体缓冲区数量+单块大小

    # ==== ==== == 后端长连接复用（减少 TCP 握手开销） == ==== ====
    upstream backend_pool {
        server 127.0.0.1:8080;
        keepalive 32;            # 每个 worker 保留 32 条长连接
    }

    server {
        listen 80;
        location /api/ {
            proxy_pass http://backend_pool;
            proxy_http_version 1.1;           # 启用 HTTP/1.1 支持长连接
            proxy_set_header Connection "";   # 清空 Connection 头，确保长连接复用生效
        }
    }
}
EOF

生效校验 + 核心速记
nginx -t && nginx -s reload

速记
1. proxy_pass：带/删前缀，不带/全拼接
2. 真实 IP：X-Real-IP 单级透传，X-Forwarded-For 全链路透传
3. 调优：超时控三段、缓冲降阻塞、长连接减握手
```


**⑤ 🎯 面试考点**：
- proxy_pass 末尾 / 区别？答：带 / 去掉 location 前缀再转发（如 /api/ → 后端 /）；不带 / 完整 URI 拼接转发。
- 如何透传真实客户端 IP？答：proxy_set_header X-Real-IP $remote_addr（单级）；X-Forwarded-For $proxy_add_x_forwarded_for（全链路累加）。
- 后端长连接复用怎么配？答：upstream 配 keepalive N + proxy_http_version 1.1 + proxy_set_header Connection "" 清空连接头。

### 4）负载均衡（面试 + 工作高频）

**① 一句话本质**：upstream 定义后端池 + 调度算法，把流量分发到多节点，实现横向扩展与高可用。


四种调度策略实战：

- 轮询、权重 weight、ip_hash、least_conn
- 后端健康检查、失败重试、宕机自动剔除
- 后端节点灰度、下线维护操作

``` md
Nginx 负载均衡 生产精简手册

1. 四种核心调度策略
cat > /etc/nginx/conf.d/upstream-demo.conf <<'EOF'
http {
    ## 1.1 轮询（默认）：请求依次均分，后端配置一致时使用
    upstream pool_round {
        server 192.168.1.11:8080;
        server 192.168.1.12:8080;
    }

    ## 1.2 权重 weight：按比例分配流量，硬件配置不均时使用
    upstream pool_weight {
        server 192.168.1.11:8080 weight = 3;  # 分 75%流量
        server 192.168.1.12:8080 weight = 1;  # 分 25%流量
    }

    ## 1.3 ip_hash：按客户端 IP 哈希固定分配节点，解决 session 会话保持问题
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

2. 被动健康检查 + 失败重试 + 宕机自动剔除
cat >> /etc/nginx/conf.d/upstream-demo.conf <<'EOF'
http {
    upstream backend {
        # max_fails = 2：连续失败 2 次判定节点宕机
        # fail_timeout = 30s：剔除 30 秒后自动重试检测节点是否恢复
        server 192.168.1.11:8080 max_fails = 2 fail_timeout = 30s;
        server 192.168.1.12:8080 max_fails = 2 fail_timeout = 30s;
    }

    server {
        listen 80;
        location /api/ {
            proxy_pass http://backend;
            # 失败自动重试：后端报错/超时，自动转发到下一个节点
            proxy_next_upstream error timeout http_502 http_503 http_504;
            proxy_next_upstream_tries 2;      # 最多重试 2 个节点
            proxy_next_upstream_timeout 10s;  # 重试总超时
        }
    }
}
EOF

3. 灰度发布 + 节点平滑下线维护
cat >> /etc/nginx/conf.d/upstream-demo.conf <<'EOF'
http {
    ## 3.1 灰度发布：按权重逐步放量
    upstream pool_gray {
        server 192.168.1.11:8080 weight = 9;  # 旧版本 90%流量
        server 192.168.1.12:8080 weight = 1;  # 新版本 10%流量，逐步调大权重
    }

    ## 3.2 节点平滑下线：weight = 0 不接收新请求，存量处理完再停机
    upstream pool_offline {
        server 192.168.1.11:8080 weight = 0;  # 待下线节点
        server 192.168.1.12:8080;
    }

    ## 3.3 备份节点：主节点全部宕机时才启用
    upstream pool_backup {
        server 192.168.1.11:8080;
        server 192.168.1.12:8080 backup;  # 备用节点
    }
}

下线标准流程：改 weight = 0 → nginx -s reload → 等待连接耗尽 → 停机维护 → 恢复权重 → reload
EOF

生效校验 + 速记
nginx -t && nginx -s reload

速记
1. 四种策略：轮询均分、weight 按比例、ip_hash 保会话、least_conn 选少连接
2. 健康检查：max_fails 判定失败，fail_timeout 周期恢复，proxy_next_upstream 自动重试
3. 灰度靠调权重，下线设 weight = 0 平滑无中断
```


**⑤ 🎯 面试考点**：
- 四种调度策略及场景？答：轮询（均分）/weight（按比例，硬件不均）/ip_hash（按 IP 哈希保会话）/least_conn（给连接最少节点，长连接优）。
- ip_hash 三大缺陷？答：出口 IP 集中致负载不均；IP 切换会话失效；扩缩容哈希重算全体掉线。生产用 Redis 共享 Session + 轮询/least_conn。
- 被动健康检查参数？答：max_fails=N 连续失败判定宕机，fail_timeout=M 周期内自动重试探测；proxy_next_upstream 失败自动换节点。
- 灰度/下线操作？答：灰度调大新节点 weight 逐步放量；下线设 weight=0 平滑无中断（存量处理完再停）。

### 5）动静分离架构

**① 一句话本质**：静态资源由 Nginx 本地直接响应、动态请求转发后端，大幅减轻 Tomcat/Java 压力。


- 静态资源本地缓存、动态转发后端
- 图片 / JS/CSS 过期缓存策略 expires
- 减轻后端 Tomcat/Java 压力

``` md
Nginx 动静分离架构 生产精简手册
核心：静态资源 Nginx 直接响应，动态请求转发后端，大幅减轻 Tomcat/Java 压力

1. 动静分离核心配置
规则：匹配静态后缀本地处理，动态路径转发后端服务
cat > /etc/nginx/conf.d/dynamic-static.conf <<'EOF'
server {
    listen 80;
    server_name www.example.com;

    # 1.1 静态资源：Nginx 直接读取本地文件，不转发后端
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|ttf|eot)$ {
        root /data/web/static;
        expires 30d;          # 浏览器缓存 30 天
        access_log off;       # 静态资源关闭日志，减少磁盘 IO
    }

    # 1.2 动态接口：全部转发到后端 Tomcat/Java 服务
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

2. 分级缓存策略 expires（精细化控制缓存周期）
cat > /etc/nginx/conf.d/expires-policy.conf <<'EOF'
server {
    listen 80;
    server_name www.example.com;

    # 图片类：更新频率低，缓存 30 天
    location ~* \.(jpg|jpeg|png|gif|bmp|ico)$ {
        expires 30d;
        add_header Cache-Control "public, no-transform";
    }

    # JS/CSS：迭代适中，缓存 7 天
    location ~* \.(js|css)$ {
        expires 7d;
        add_header Cache-Control "public, no-transform";
    }

    # HTML 页面：更新频繁，缓存 1 小时
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

3. 配套优化（进一步降低后端负载）
cat >> /etc/nginx/conf.d/dynamic-static.conf <<'EOF'
http {
    # 开启 gzip 压缩，减小传输体积，降低带宽与后端压力
    gzip on;
    gzip_min_length 1k;
    gzip_comp_level 2;
    gzip_types text/plain text/css application/javascript application/json image/jpeg image/png;
    gzip_vary on;
}
EOF

生效校验 + 核心速记
nginx -t && nginx -s reload

速记
1. 核心逻辑：静态资源本地读，动态请求转后端
2. expires 分级控缓存：图片长、脚本中、页面短、接口禁缓存
3. 收益：降低后端 CPU/IO 消耗，提升页面加载速度，减少带宽成本

扩展:
ip_hash 场景、缺陷、主流方案精简版
适用场景（必须用 ip_hash）
后端 Session 本地内存存储，无 Redis 共享且不愿改代码：
1. 老旧 Java/PHP 项目，改造代价大
2. 小型内网系统，不想额外部署缓存
3. 临时过渡方案

ip_hash 三大缺陷
1. 负载失衡：CDN/公司统一出口 IP 会全部打在单台后端
2. IP 切换会话失效：手机切换 WiFi/流量即掉线
3. 增减后端节点，哈希重算，全体用户会话丢失

企业标准方案（优先推荐）
所有节点 Session 统一存入 Redis 集中共享，负载均衡选用轮询/权重/least_conn，扩容缩容、节点故障均不影响登录。

总结
1. 轮询/权重：不绑定用户，适合 Session 共享、无状态业务
2. ip_hash：仅兼容本地内存会话，负载不均、容错差，生产尽量不用
3. 最优架构：Redis 共享 Session + 权重/least_conn 均衡
```


**⑤ 🎯 面试考点**：
- 核心配置？答：静态后缀 location 本地 root 响应并 expires 缓存；/api 转发后端。
- expires 分级策略？答：图片 30d、JS/CSS 7d、HTML 1h、接口 no-store 禁缓存。
- ip_hash 会话保持为何生产不推荐？答：本地内存 Session 容错差、扩容掉线；Redis 共享 Session 才是正解。

### 6）HTTPS 全站加密

**① 一句话本质**：用 TLS 证书加密站点流量，443 监听 + 80 强制跳转 + HSTS，防中间人劫持。


- SSL 证书签发、CRT/KEY 配置
- 强制 HTTP 跳转 HTTPS
- 加密套件优化、https 性能调优

``` md
Nginx HTTPS 全站加密 精简生产配置手册
1.证书部署+CRT&KEY 配置
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
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256: ECDHE-RSA-AES128-GCM-SHA256: ECDHE-ECDSA-AES256-GCM-SHA384: ECDHE-RSA-AES256-GCM-SHA384: ECDHE-ECDSA-CHACHA20-POLY1305: ECDHE-RSA-CHACHA20-POLY1305: DHE-RSA-AES128-GCM-SHA256: DHE-RSA-AES256-GCM-SHA384;
    ssl_session_cache shared: SSL: 10m;
    ssl_session_timeout 10m;
    ssl_session_tickets off;
    add_header Strict-Transport-Security "max-age = 31536000; includeSubDomains" always;

    root /data/web/static/html;
    location /api/ {
        proxy_pass http://backend_pool;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

2.80 端口强制跳转 HTTPS
server {
    listen 80;
    server_name www.example.com;
    return 301 https://$host$request_uri;
}
EOF

证书目录创建，上传 crt、key 文件
mkdir -p /etc/nginx/ssl
证书权限加固，禁止其他用户读取
chmod 600 /etc/nginx/ssl/*

校验重载
nginx -t && nginx -s reload

核心速记
1.证书：ssl_certificate 公钥 crt，ssl_certificate_key 私钥 key
2.强制加密：80 端口 301 跳转 HTTPS
3.性能优化：仅保留 TLS1.2/1.3、服务端优先加密套件、开启 ssl 会话缓存减少握手开销
4.HSTS 头强制浏览器永久使用 HTTPS，避免中间人劫持
```


**⑤ 🎯 面试考点**：
- ssl_certificate 与 ssl_certificate_key 区别？答：crt 是公钥证书（服务端下发客户端）；key 是私钥（保密、权限 600）。
- 80 强制跳 443？答：80 server 用 return 301 https://$host$request_uri。
- HSTS 作用？答：Strict-Transport-Security 头强制浏览器长期走 HTTPS，防中间人降级劫持。
- 为何只留 TLS1.2/1.3？答：1.0/1.1 有已知漏洞（BEAST/POODLE），1.3 去不安全套件、握手更快。

### 7）Rewrite 重写规则（中级难点）

**① 一句话本质**：用正则改写请求 URI/域名，实现伪静态、目录跳转、域名迁移、防盗链。


- 正则匹配、flag 标记 last/break/redirect/permanent
- 目录跳转、伪静态、域名迁移、防盗链实现

``` md
Nginx Rewrite 重写规则 生产精简手册（中级难点）
1.四大 flag 标记核心区分
last：匹配后重新走所有 location，常用内部转发
break：匹配后终止规则，不再重新匹配 location
redirect 302 临时重定向，浏览器地址变更
permanent 301 永久重定向，浏览器缓存跳转记录
cat > /etc/nginx/conf.d/rewrite-demo.conf <<'EOF'
server {
    listen 80;
    server_name test.com www.test.com;
    root /data/www/html;

    # 1.伪静态：动态接口伪装静态页面
    rewrite ^/detail-(\d+)\.html $ /detail?id=$ 1 last;

    # 2.目录跳转，末尾加斜杠
    rewrite ^/article$ /article/ permanent;

    # 3.域名迁移：旧域名 301 永久跳新域名
    if ($host = old.test.com) {
        rewrite ^/(.*)$https://new.test.com/$ 1 permanent;
    }

    # 4.防盗链：非本站来源拦截图片资源
    location ~* \.(jpg|png|gif|js|css)$ {
        valid_referers none blocked test.com *.test.com;
        if ($invalid_referer) {
            return 403;
        }
        expires 7d;
    }

    # 5.break 示例：匹配后停止规则，不二次匹配 location
    rewrite ^/static/ /data/static/ break;
}
EOF

2.正则匹配基础
^ 开头、$ 结尾、()捕获参数、.*任意字符、\d 数字、~*不区分大小写正则匹配

3.实操校验
nginx -t && nginx -s reload

速记总结
last/break 内部跳转不换地址；redirect(302 临时) permanent(301 永久) 外部跳转
四大场景：伪静态、目录补斜杠、域名迁移、图片防盗链
防盗链依靠 valid_referers 校验请求来源，非法 referer 返回 403
```


**⑤ 🎯 面试考点**：
- last 与 break 区别？答：last 匹配后重走所有 location（内部转发）；break 匹配后终止规则不再匹配 location。
- redirect(302) 与 permanent(301) 区别？答：302 临时（浏览器不缓存）；301 永久（浏览器缓存跳转）。
- 防盗链原理？答：valid_referers 校验 Referer，非法来源返回 403。

### 8）Nginx 安全防护

**① 一句话本质**：版本隐藏 + 限流 + 并发限制 + IP 黑白名单 + 防盗链，组合成站点基础防护。


- IP 黑白名单
- limit_req 限流防 CC
- limit_conn 并发连接限制
- Referer 防盗链
- 隐藏版本号

``` md
Nginx 安全防护全套生产配置 精简手册
cat > /etc/nginx/conf.d/nginx-sec.conf <<'EOF'
http {
    # 1.隐藏 Nginx 版本号，避免漏洞针对性扫描
    server_tokens off;

    # 2.limit_req 请求限流防 CC：单 IP 每秒最多 5 请求，突发缓冲 10 个
    limit_req_zone $binary_remote_addr zone = req_limit: 10m rate = 5r/s;
    # 3.limit_conn 并发连接限制：单 IP 最大并发 20 连接
    limit_conn_zone $binary_remote_addr zone = conn_limit: 10m;

    # 4.IP 黑白名单全局定义
    geo $ip_blacklist {
        default 0;
        192.168.1.100 1; # 拉黑恶意 IP
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
        # 白名单跳过限流，其余 IP 启用限流
        if ($ip_whitelist = 1) {
            limit_req zone = req_limit burst = 10 nodelay;
            limit_conn conn_limit 20;
        }

        # 5.Referer 防盗链，拦截盗图爬虫
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

配置校验重载
nginx -t && nginx -s reload

速记要点
1.server_tokens off 隐藏版本，减少攻击面
2.limit_req 限制请求频率防 CC；limit_conn 限制单 IP 并发连接
3.geo 模块配置 IP 黑白名单，恶意 IP 直接 444 断开
4.valid_referers 校验访问来源，非法引用返回 403 防盗链
5.内网可信 IP 加入白名单，免除限流拦截
```


**⑤ 🎯 面试考点**：
- limit_req 与 limit_conn 区别？答：limit_req 限单 IP 请求频率（r/s）防 CC；limit_conn 限单 IP 并发连接数。
- geo 模块怎么做黑白名单？答：geo 按客户端 IP 映射变量，黑名单 return 444 断开，白名单跳过限流。
- server_tokens off 作用？答：隐藏版本号，减小漏洞针对性扫描面。

### 9）性能调优（生产必做）

**① 一句话本质**：从进程 / 事件 / 应用 / 系统四层调优，让 Nginx 扛更高并发、更低延迟。


- worker 进程数、最大连接数
- epoll 事件模型调优
- 文件句柄优化
- TCP 内核参数配套调优
- 超时时间优化

``` md
Nginx 生产性能全套调优配置
cat > /etc/nginx/conf.d/nginx-tune.conf <<'EOF'
main 全局块
worker_processes auto;                  # 自动匹配 CPU 核心数
worker_cpu_affinity auto;               # CPU 亲和绑定，减少上下文切换
worker_rlimit_nofile 65535;             # 单进程最大文件句柄

events 块
events {
    use epoll;                           # Linux 高性能 IO 多路复用模型
    worker_connections 10240;            # 单 worker 最大并发连接
    multi_accept on;                     # 一次性接收多条连接
}

http 全局调优
http {
    sendfile on;                         # 零拷贝传输文件，降低 CPU
    tcp_nopush on;                       # 合并小包发送，减少网络交互
    tcp_nodelay on;

    # 超时优化
    keepalive_timeout 60;                # HTTP 长连接超时
    client_header_timeout 10s;
    client_body_timeout 10s;
    send_timeout 15s;

    # 文件缓存元数据
    open_file_cache max = 65535 inactive = 60s;
    open_file_cache_valid 80s;
    open_file_cache_min_uses 2;
}
EOF

系统内核 TCP 参数调优 /etc/sysctl.conf
cat >> /etc/sysctl.conf <<'EOF'
调高全局文件句柄上限  # 整机所有进程（nginx、mysql、redis、ssh 等）打开的文件、socket、管道总和上限。
fs.file-max = 1048576
TCP 端口范围扩大
net.ipv4.ip_local_port_range = 1024 65535
快速回收 TIME_WAIT 连接
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
TCP 缓冲区调大
net.core.somaxconn = 65535
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
EOF
sysctl -p

Nginx 运行用户句柄限制 /etc/security/limits.conf
单个进程能打开的最大文件句柄数 作用于 nginx 运行用户：
软限制能调整到的最大值，root 才能修改 hard；soft 不能超过 hard。
cat >> /etc/security/limits.conf <<'EOF'
nginx soft nofile 65535
nginx hard nofile 65535
EOF

校验重载
nginx -t && nginx -s reload

速记
1.worker：auto 进程数 + 大 nofile 句柄限制
2.events：epoll 模型、调高单进程连接数
3.应用层：sendfile 零拷贝、各类请求超时收紧
4.系统层：内核 TCP 参数、全局文件句柄、limits 软硬限制

sendfile on; 零拷贝通俗理解
无 sendfile（传统 read+write）流程，多次内存拷贝、耗 CPU：
1. 磁盘文件 → 内核缓冲区（拷贝 1）
2. 内核缓冲区 → 用户进程内存（read，拷贝 2）
3. 用户内存 → 内核 socket 缓冲区（write，拷贝 3）
4. socket 缓冲区 → 网卡发送

sendfile 零拷贝机制：
系统调用直接在内核态完成数据转发，**跳过用户进程内存**，只 1 次内核内拷贝：
磁盘文件 → 内核缓冲区 → 网卡 socket，全程不经过 nginx 应用内存。

收益
1. 大幅减少 CPU 拷贝开销，静态文件、图片、JS/CSS 吞吐性能提升
2. 减少内存占用，高并发静态场景必开

精简速记
1. fs.file-max：整机全局总句柄上限；
2. soft nofile：进程日常可用上限；hard nofile：最大可调天花板；
3. sendfile 零拷贝：数据不走应用内存，内核直接转发，降低 CPU。
```


**⑤ 🎯 面试考点**：
- sendfile 零拷贝原理？答：内核直接把磁盘文件拷到 socket，跳过用户态内存，少一次拷贝省 CPU。
- worker_rlimit_nofile 解决什么？答：单 worker 最大文件句柄，解决高并发 too many open files。
- epoll 为何高性能？答：事件驱动、单线程管上万连接、无锁无上下文切换。

### 10）日志体系与轮转

**① 一句话本质**：access/error 日志记录请求与报错，logrotate 按天切割保障可观测与合规留存。


- access_log/error_log 日志字段解读
- 日志切割 logrotate 生产配置
- 按天切割、延迟压缩、保留 30 天

``` md
Nginx 日志体系+logrotate 轮转生产配置
1. 自定义日志格式、站点分离日志
cat > /etc/nginx/conf.d/nginx-log.conf <<'EOF'
http {
    # 完整日志字段模板
    log_format main '$remote_addr - $remote_user [$time_local] "$request " '
                    '$status $body_bytes_sent "$http_referer " '
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

2. 创建日志目录并授权
mkdir -p /data/logs/www.example.com
chown nginx: nginx /data/logs/www.example.com

3. logrotate 生产规则：按天切割、保留 30 天、延迟压缩
cat > /etc/logrotate.d/nginx-web <<'EOF'
匹配该站点下所有日志文件
/data/logs/www.example.com/\*.log {
    daily               # 切割周期：每天执行一次日志分割
    rotate 30           # 最多保留 30 份历史归档日志，超过自动删除最旧文件
    compress            # 开启 gzip 压缩归档日志，节省磁盘空间
    delaycompress       # 延迟压缩：刚切割出来的当天日志不压缩，次日再压
    missingok           # 日志文件不存在时不报错，避免定时任务告警
    notifempty          # 日志为空时不执行切割，减少无用空文件
    sharedscripts       # 所有匹配日志切割完成后，仅执行一次 postrotate 脚本
    postrotate
        # 通知 nginx 重新打开日志文件句柄，避免继续往旧归档文件写日志
        /usr/sbin/nginx -s reopen > /dev/null 2>&1
    endscript
}
EOF
关键补充解释
1. delaycompress 作用：当天日志需要实时排查问题，不压缩方便直接查看；次日再压缩归档
2. sharedscripts：多日志文件时，不会每条日志都执行一次 nginx reopen，只执行一次提升效率
3. nginx -s reopen：区别 reload，只重新打开日志，不重载配置、不中断连接，开销极小
4. rotate 30：满足企业 30 天日志留存审计规范

校验重载
nginx -t && nginx -s reload

速记
1.access 日志记录全量请求信息，error 日志记录报错，warn 级别平衡日志量与排错
2.daily 每日切割，rotate30 留存 30 天归档
3.delaycompress 本轮日志暂不压缩，避免占用 IO；postrotate 发送 reopen 重新生成日志文件
```


**⑤ 🎯 面试考点**：
- log_format 常用字段？答：$remote_addr 客户端、$status 状态码、$request 请求行、$http_x_forwarded_for 真实 IP 等。
- delaycompress 作用？答：当天日志不压缩便于实时排查，次日再压，省 IO。
- nginx -s reopen 与 reload 区别？答：reopen 只重开日志句柄不重载配置不中断；reload 重载配置。

### 11）Nginx 故障排查体系

**① 一句话本质**：按错误码分层定位：4xx 多为客户端/配置侧，5xx 多为后端侧，再结合端口/权限/限流。


- 502/504/403/404 根因定位
- 端口占用、 upstream 后端宕机
- 连接打满、限流触发、文件权限问题

``` md
Nginx 线上故障排查体系 精简配置+定位手册
一、常见错误码根因定位
1. 403 Forbidden 禁止访问
诱因：
1.站点目录/文件权限不足，nginx 用户无读权限
2.目录下无 index 首页文件
3.防盗链规则拦截、IP 黑名单拦截
4.SELinux 拦截站点目录访问
排查命令
ls -ld /data/www/html
chmod 750 /data/www/html && chown www: nginx /data/www/html
setenforce 0  # 临时关闭 selinux 验证

2. 404 Not Found 页面不存在
诱因：
root 站点路径配置错误、文件丢失、location 匹配覆盖 URI、proxy_pass 路径写错
排查：核对 server 块 root 路径、检查本地文件是否存在

3. 502 Bad Gateway 网关错误
诱因：
1.upstream 后端服务未启动/宕机
2.后端端口未监听、防火墙拦截后端端口
3.后端进程崩溃、内存溢出
排查命令
netstat -lntp | grep 8080
curl http://127.0.0.1:8080
tail -f /var/log/nginx/error.log

4. 504 Gateway Time-out 网关超时
诱因：
proxy_read_timeout 时间太短，后端接口执行缓慢阻塞
后端数据库慢查询、死锁导致响应超时
解决：调大 proxy_read_timeout 60s

二、后端&端口类故障
1. 端口占用（Nginx 启动失败）
排查
ss -lntp | grep : 80
kill -9 占用进程 || 修改 nginx listen 端口

2. upstream 后端宕机自动剔除失效
检查 max_fails/fail_timeout 参数，查看 error 日志大量 connect() failed
修复：调整失败重试阈值，检查后端服务健康状态

三、高并发限流/连接打满故障
1. 大量 429 Too Many Requests
诱因：limit_req 限流规则触发，单 IP 请求频率超限
临时处理：调高 rate 速率、内网 IP 加入白名单免限流

2. 大量 503 Service Unavailable
诱因：limit_conn 并发连接打满、后端节点全部宕机无可用节点
排查：error 日志提示 connections limit exceeded

3. 连接数打满/too many open files
诱因：文件句柄上限不足
核查三层限制
ulimit -n
cat /proc/sys/fs/file-max
grep nofile /etc/security/limits.conf

三、统一排查流程
1. 优先查看站点独立 error.log，精准捕获报错堆栈
2. 验证后端服务裸访问 curl 127.0.0.1: port
3. 核对目录权限、SELinux 状态
4. 检查限流、并发、文件句柄内核限制
5. 校验 nginx 配置 nginx -t

速记总结
4xx 客户端侧：403 权限/selinux；404 路径文件缺失
5xx 服务侧：502 后端挂了；504 后端响应慢超时
端口占用：ss 命令查监听；连接爆满：调句柄、限流阈值
```


**⑤ 🎯 面试考点**：
- 502 与 504 区别？答：502 后端未起/端口不通/进程崩；504 后端响应慢超 proxy_read_timeout。
- 403 常见诱因？答：权限/无 index/防盗链/SELinux。
- too many open files 三层排查？答：ulimit -n（进程软限）、fs.file-max（整机硬上限）、/etc/security/limits.conf（硬限）。

### 12）Stream 四层负载均衡（TCP/UDP 代理，运维必会）

**① 一句话本质**：stream 模块做 IP:端口 四层透传，用来代理 MySQL/Redis/SSH 等非 HTTP 服务。


``` md
Stream 四层负载均衡（TCP/UDP 级代理，MySQL/Redis/SSH 等非 HTTP 服务都用它）
一、HTTP 与 Stream 的区别
1. http 模块：7 层，认 URL/Host/Header，适合 Web 服务
2. stream 模块：4 层，只认 IP+端口 透传 TCP/UDP，支持 MySQL、Redis、SSH、RDP 等

二、基础配置（编译需 --with-stream）
stream {
    upstream mysql_pool {
        server 192.168.1.11:3306 max_fails=3 fail_timeout=30s;
        server 192.168.1.12:3306 max_fails=3 fail_timeout=30s;
    }
    server {
        listen 3306;
        proxy_pass mysql_pool;       # 四层负载
        proxy_connect_timeout 3s;    # 连接超时
    }
}

三、常见场景
1. MySQL 读写入口：客户端连 Nginx 3306，后端两台 MySQL 轮询
2. Redis 集群代理：TCP 透传多个 Redis 节点
3. SSH 堡垒跳板：Nginx 监听 2222 转发到内网服务器 22

四、与 http 负载均衡对比速记
1. 相同：都支持 upstream + 轮询/权重/ip_hash
2. 区别：http 能按 URL 分流、看 Host、做缓存；stream 纯 IP:端口 转发，性能更高更简单
3. 检测：stream 默认不主动探活后端，靠 max_fails 被动判定，重要服务建议配合脚本健康检查
```


**⑤ 🎯 面试考点**：
- http 模块与 stream 模块区别？答：http 7 层认 URL/Host/Header；stream 4 层只认 IP:端口透传 TCP/UDP（MySQL/Redis/SSH）。
- stream 默认不主动探活怎么办？答：靠 max_fails 被动判定，重要服务配脚本健康检查。
- 编译需 --with-stream？答：是，默认未编译该模块。

### 2. Apache（了解即可）

**① 一句话本质**：Apache 多进程/线程同步阻塞模型，仅用于兼容老旧 PHP，新项目统一用 Nginx。


- 虚拟主机、rewrite、访问控制
- 仅做老旧业务维护兼容

``` md
Apache 基础了解（仅老旧业务兼容维护）
1. 虚拟主机配置示例
cat > /etc/httpd/conf.d/demo.conf <<'EOF'
<VirtualHost *:80>
    ServerName shturl.cc/u
    DocumentRoot "/data/old-web/html"
    ErrorLog "/data/old-web/logs/error.log"
    CustomLog "/data/old-web/logs/access.log" combined
</VirtualHost>
EOF

2. rewrite 伪静态/跳转规则
cat >> /etc/httpd/conf.d/demo.conf <<'EOF'
RewriteEngine On
伪静态
RewriteRule ^detail-(\d+)\.html $ /detail.php?id=$ 1 [L]
301 域名跳转
RewriteCond %{HTTP_HOST} ^shturl.cc/u
RewriteRule ^(.*)$ https://shturl.cc/$1 [R=301,L]
EOF

3. 访问控制（IP 黑白名单）
cat >> /etc/httpd/conf.d/demo.conf <<'EOF'
<Directory "/data/old-web/html">
    Require all granted
    Require ip 192.168.1.0/24
    Require not ip 192.168.1.100
</Directory>
EOF

启停校验
httpd -t
systemctl restart httpd

速记
Apache 适用场景：遗留 PHP 老项目，新项目统一使用 Nginx
核心三要素：VirtualHost 虚拟主机、mod_rewrite 重写、Directory 目录访问控制
性能、并发、运维便捷度弱于 Nginx，仅做兼容维护
```

Apache vs Nginx 核心对比表


- **核心架构**：Apache 多进程/多线程同步阻塞；Nginx 多进程单线程 + epoll 异步非阻塞。
- **并发能力**：Apache 千级并发性能衰减明显；Nginx 万级高并发支撑强。
- **资源占用**：Apache 内存/CPU 开销高；Nginx 轻量，同并发下约为 Apache 的 1/5~1/10。
- **配置体系**：Apache 全局 + .htaccess 灵活但易乱；Nginx 全局+server+location 层级严谨。
- **核心优势**：Apache 对老旧 PHP 生态兼容友好；Nginx 反代/负载/动静/限流/HTTPS 能力拉满。
- **适用场景**：Apache 仅用于老旧 PHP 遗留系统；Nginx 是新项目、高并发、API 网关主流首选。
- **热更新**：Apache 重载短暂阻塞、无真正平滑重启；Nginx reload 全程无中断、支持热升级。
- **扩展能力**：Apache 模块同步阻塞受限；Nginx 支持动态模块、Lua/OpenResty 等第三方扩展。
核心精简总结

- 老旧PHP遗留系统维护选Apache，**所有新项目、高并发场景统一选Nginx**
- 两者核心差距来自底层并发模型：Nginx异步非阻塞架构天然适配高并发Web场景，Apache同步阻塞架构仅适配低并发动态业务


**⑤ 🎯 面试考点**：
- Apache 与 Nginx 架构核心差异？答：Apache 多进程/线程同步阻塞；Nginx 多进程单线程+epoll 异步非阻塞。
- 为何新项目统一选 Nginx？答：高并发 IO 场景性能强、资源省、反代/负载/动静/限流/HTTPS 能力全。
- Apache 三要素？答：VirtualHost 虚拟主机、mod_rewrite 重写、Directory 目录访问控制。

### nginx 知识点总结

``` md
CentOS Yum 安装 Nginx 默认目录结构（Markdown）
/etc/nginx/                  # 核心配置总目录
├── nginx.conf               # 主配置文件
├── conf.d/                  # 站点独立配置目录（自动加载所有*.conf）
├── modules/                 # 动态模块加载目录
├── snippets/                # 公共配置片段（ssl、代理头部等）
├── mime.types               # 媒体类型映射
├── fastcgi_params           # FastCGI 代理参数
├── scgi_params
├── uwsgi_params
/usr/sbin/nginx              # Nginx 二进制执行程序
/usr/lib64/nginx/modules/    # 模块库文件
/usr/share/nginx/html/       # 默认网站静态根目录（欢迎页）
/var/log/nginx/              # 日志目录
├── access.log               # 全局访问日志
└── error.log                # 全局错误日志
/var/cache/nginx/            # 代理缓存、临时文件目录
/etc/logrotate.d/nginx       # Nginx 日志切割规则
/usr/lib/systemd/system/nginx.service  # systemd 服务单元文件
/run/nginx.pid               # 运行 PID 文件

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

、常用查询命令
查看 yum 安装所有文件路径
rpm -ql nginx
查看 nginx 运行用户/进程
ps aux | grep nginx
查看 nginx 监听端口
ss -lntp | grep nginx

四、关键运维说明
1. **多站点规范**：所有业务站点配置统一放 `/etc/nginx/conf.d/`，不修改主 nginx.conf
2. **日志改造**：生产不使用默认全局日志，每个 server 单独指定日志到自定义目录 `/data/logs/xxx/`
3. **证书存放**：建议自建 `/etc/nginx/ssl/` 存放 crt/key，权限设 600
4. **区别源码安装**：yum 安装遵循 Linux 标准 FHS 分散目录；源码编译全部集中在 `/usr/local/nginx`
```

``` nginx
==== ==== ==== ==== ==== ====
Nginx 全套生产整合配置（覆盖 11 大知识点，逐段标注对应模块）
知识点：1.多进程架构调优 | 2.虚拟主机 | 3.反向代理 | 4.负载均衡
5.动静分离 | 6.HTTPS 全站加密 | 7.Rewrite 重写 | 8.安全防护
9.性能调优 | 10.日志与轮转 | 11.故障排查相关配置
==== ==== ==== ==== ==== ====

==== ==== ==== ==== == 全局 main 块：1.多进程架构 + 9.性能调优（进程/句柄） == ==== ==== ==== ====
worker_processes auto;                 # 9.性能调优：进程数自动匹配 CPU 核心
worker_cpu_affinity auto;              # 9.性能调优：CPU 亲和，减少上下文切换
worker_rlimit_nofile 65535;             # 9.性能调优：单进程最大文件句柄，解决 too many open files

==== ==== ==== ==== == events 块：9.性能调优 epoll 模型、并发连接 == ==== ==== ==== ====
events {
    # 9.性能调优：理论最大并发连接数 = worker_processes × worker_connections；
    #   该值同时受 worker_rlimit_nofile、系统 ulimit、内核 fs.file-max 三者最小值的约束（取最小上限）
    use epoll;                          # 9.性能调优：Linux 下 IO 多路复用异步模型，高并发首选
    worker_connections 10240;           # 9.性能调优：单个 worker 进程最大并发连接数（配合 worker_processes 放大总并发）
    multi_accept on;                    # 9.性能调优：一次 accept 尽量多拿连接，提升新连接吞吐
    accept_mutex off;                   # 9.性能调优：关闭 accept 锁，避免多 worker 惊群（1.11.3+ 默认 off，高并发推荐关）
}

==== ==== ==== ==== == http 块：公共通用配置，覆盖安全、限流、日志、缓存、代理 == ==== ==== ==== ====
http {
    include       mime.types;
    default_type  application/octet-stream;

    # ---------------- 10.日志体系：自定义日志字段模板 ----------------
    log_format main '$remote_addr - $remote_user [$time_local] "$request " '
                    '$status $body_bytes_sent "$http_referer " '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    # ---------------- 8.安全防护：隐藏版本号，减少攻击面 ----------------
    server_tokens off;

    # ---------------- 8.安全防护：限流防 CC、并发连接限制 ----------------
    # limit_req：限制单 IP 每秒请求频率，防 CC 攻击
    limit_req_zone $binary_remote_addr zone = req_zone: 10m rate = 5r/s;
    # limit_conn：限制单 IP 最大并发连接数
    limit_conn_zone $binary_remote_addr zone = conn_zone: 10m;

    # ---------------- 9.性能调优：零拷贝、TCP 网络优化、长连接、超时、压缩、缓存 ----------------
    # 1) 零拷贝：数据直接内核态→网卡，跳过用户态，省 CPU 拷贝
    sendfile on;                        # 9.性能调优：开启零拷贝，静态文件大杀器

    # 2) TCP 发送优化：与 sendfile 配合，凑满一个包再发，提升带宽利用率
    tcp_nopush on;                      # 9.性能调优：开启 Nagle 反向（满包才发），配合 sendfile 不延迟、提带宽利用率
    tcp_nodelay on;                     # 9.性能调优：关闭 Nagle 算法，小包立即发，降低交互延迟（实时/keepalive 场景必备）

    # 3) 长连接：减少 TCP 握手/挥手开销，但需配上限防单连接长期占用
    keepalive_timeout 60;               # 9.性能调优：客户端长连接超时，超时回收
    keepalive_requests 10000;           # 9.性能调优：单条长连接上最多处理请求数，到数断开重连，防被单客户端长期霸占
    reset_timedout_connection on;       # 9.性能调优：超时连接直接发 RST 立即释放，避免 FIN_WAIT/ TIME_WAIT 堆积耗尽端口

    # 4) 超时控制：防慢客户端拖死 worker 连接
    client_header_timeout 10s;          # 9.性能调优：读取客户端请求头超时
    client_body_timeout 10s;            # 9.性能调优：读取客户端请求体超时
    send_timeout 15s;                   # 9.性能调优：向客户端发送响应超时（两次写操作之间）

    # 5) 文件元数据缓存：把 fd/大小/修改时间缓存内存，降低 stat 系统调用与磁盘 IO
    open_file_cache max = 65535 inactive = 60s;       # 9.性能调优：最多缓存 65535 个文件句柄，60s 无访问即淘汰
    open_file_cache_valid 80s;          # 9.性能调优：缓存元素 80s 后校验一次是否过期
    open_file_cache_min_uses 2;         # 9.性能调优：文件被访问 >=2 次才进缓存，避免冷文件占坑
    open_file_cache_errors on;          # 9.性能调优：缓存「文件不存在」错误，避免反复 stat 不存在的路径

    # 6) 响应压缩：文本类响应压缩后传输，省带宽、提速首屏（CPU 换带宽；图片/视频已压缩不宜再压）
    gzip on;                            # 9.性能调优：开启 gzip 压缩
    gzip_min_length 1k;                 # 9.性能调优：小于 1k 不压缩（压缩比低反而亏 CPU）
    gzip_comp_level 5;                  # 9.性能调优：压缩级别 1-9，5 为性价比均衡点
    gzip_types text/plain text/css application/json application/javascript application/xml image/svg+xml;  # 9.性能调优：只对文本类 MIME 压缩
    gzip_vary on;                       # 9.性能调优：响应头加 Vary: Accept-Encoding，避免下游代理缓存错版本
    gzip_disable "msie6";               # 9.性能调优：老 IE6 不支持 gzip，跳过

    # 7) 七层代理缓存：把后端响应缓到本地磁盘，命中直接返回，大幅降低后端压力（配合 location /api/ 的 proxy_cache 使用）
    proxy_cache_path /data/nginx/cache levels = 1: 2 keys_zone = mycache: 100m inactive = 60m max_size = 10g;  # 9.性能调优：缓存路径/目录层级/共享内存名/最大体积

    # ---------------- 3.反向代理：全局代理超时、缓冲统一配置 ----------------
    proxy_connect_timeout 30s;
    proxy_read_timeout 60s;
    proxy_send_timeout 60s;
    proxy_buffering on;
    proxy_buffer_size 4k;
    proxy_buffers 8 4k;

    # ---------------- 4.负载均衡 upstream 模块 ----------------
    upstream backend_pool {
        # 权重策略：硬件性能不均时按比例分配流量
        server 192.168.1.11:8080 weight = 3 max_fails = 2 fail_timeout = 30s;
        server 192.168.1.12:8080 weight = 1 max_fails = 2 fail_timeout = 30s;
        # max_fails/fail_timeout：被动健康检查，失败自动剔除节点
        # 灰度发布：调整 weight 比例；下线维护：weight = 0 不接收新连接
        # ip_hash;       # 会话保持，老旧本地 session 场景专用，生产优先 Redis 共享 session
        # least_conn;    # 优先分配给连接最少后端，长连接业务
        keepalive 32;   # 3.反向代理：后端长连接复用，减少 TCP 握手
    }

    # ==== ==== ==== ==== ==== == 2.虚拟主机 1：80 站点 + 6.HTTPS 跳转 == ==== ==== ==== ==== ====
    server {
        listen 80 reuseport backlog = 4096;   # 9.性能调优：reuseport 多 worker 独立监听降锁竞争；backlog 调大 accept 队列防 SYN 丢包
        server_name www.example.com; # 基于域名虚拟主机
        # 6.HTTPS：HTTP 全部 301 永久跳转加密站点
        return 301 https://$host$request_uri;
    }

    # ==== ==== ==== ==== ==== == 2.虚拟主机 2：443 HTTPS 全站加密 == ==== ==== ==== ==== ====
    server {
        listen 443 ssl http2 reuseport backlog = 4096;  # 9.性能调优：HTTP/2 多路复用；reuseport + 大 backlog 提升并发
        server_name www.example.com;
        root /data/www/www.example.com/html;
        index index.html;

        # 6.HTTPS：证书配置
        ssl_certificate /etc/nginx/ssl/www.example.com.crt;
        ssl_certificate_key /etc/nginx/ssl/www.example.com.key;
        # 6.加密套件、协议优化
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_prefer_server_ciphers on;
        ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256: ECDHE-RSA-AES128-GCM-SHA256;
        ssl_session_cache shared: SSL: 10m;
        ssl_session_timeout 10m;
        add_header Strict-Transport-Security "max-age = 31536000; includeSubDomains" always;

        # 10.日志：站点独立访问、错误日志，日志分离
        access_log /data/logs/www.example.com/access.log main;
        error_log /data/logs/www.example.com/error.log warn;

        # 8.安全防护：IP 黑白名单（内网白名单免除限流）
        geo $black_ip { default 0; 192.168.1.100 1; }
        if ($black_ip) { return 444; } # 恶意 IP 直接断开

        # 8.安全防护：全局启用限流、并发限制
        limit_req zone = req_zone burst = 10 nodelay;
        limit_conn conn_zone 20;

        # ---------------- 5.动静分离：静态资源本地处理、浏览器缓存 ----------------
        location ~* \.(jpg|png|gif|ico|css|js|woff)$ {
            root /data/www/www.example.com/static;
            expires 30d;        # 图片长缓存
            access_log off;     # 静态关闭日志，减少磁盘 IO
            # 8.安全防护 Referer 防盗链
            valid_referers none blocked www.example.com *.example.com;
            if ($invalid_referer) { return 403; }
        }

        # ---------------- 7.Rewrite 重写规则：伪静态、目录补斜杠 ----------------
        rewrite ^/detail-(\d+)\.html $ /detail?id=$ 1 last; # last 内部转发重新匹配 location
        rewrite ^/article$ /article/ permanent;           # permanent 301 永久跳转

        # ---------------- 3.反向代理：动态接口转发后端 Java/Tomcat ----------------
        location /api/ {
            proxy_pass http://backend_pool; # 无/，完整拼接 URI；加/会截取匹配前缀
            # 9.性能调优：七层代理缓存，命中直接返回不转发后端
            proxy_cache mycache;                            # 启用上面定义的 mycache 共享内存区
            proxy_cache_valid 200 302 10m;                  # 200/302 响应缓存 10 分钟
            proxy_cache_valid 404 1m;                       # 404 也短暂缓存，避免重复打后端
            proxy_cache_key $host$uri$is_args$args;         # 缓存 key（默认即此，显式声明便于调）
            add_header X-Cache $upstream_cache_status;      # 响应头暴露 HIT/MISS/BYPASS，便于排查命中率
            # 透传真实客户端 IP、域名、请求协议
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

==== ==== ==== ==== == 配套运维&故障知识点（配置文件外操作，注释记录） == ==== ==== ==== ====
【10.日志轮转配套】/etc/logrotate.d/nginx-web
/data/logs/www.example.com/*.log {
daily; rotate 30; compress; delaycompress; missingok; notifempty; sharedscripts
postrotate
/usr/sbin/nginx -s reopen > /dev/null 2>&1 # 重新打开日志句柄，不重载配置
endscript
}

【11.故障排查对应配置报错场景】
403：目录权限不足、无 index、防盗链拦截、SELinux
404：root 路径错误、文件缺失、location 覆盖
502：upstream 后端未启动、端口占用、服务崩溃
504：proxy_read_timeout 过小、后端接口慢阻塞
429：limit_req 限流触发；503：limit_conn 连接打满/无可用后端
too many open files：调 worker_rlimit_nofile、limits.conf、fs.file-max

配置校验与重载命令
nginx -t        # 语法校验，防止配置错误宕机
nginx -s reload # 平滑重载，无业务中断
nginx -s reopen # 仅切换日志文件，性能损耗极低
```

---

## 二、数据库 & 缓存中间件（中级运维核心饭碗）

1. MySQL 运维全栈（生产重中之重）

### 1）生产部署

**① 一句话本质**：MySQL 生产部署 = 选 yum/源码安装 + 初始化 + 安全加固（my.cnf 调优、专用运行用户、目录规划），是后续所有库操作的基础。


- YUM / 二进制 生产安装
- 多实例部署（3306/3307 多端口）
- 初始化安全配置、密码策略、远程权限

``` md
MySQL 生产部署运维手册（YUM+二进制+多实例+安全初始化）
一、YUM 在线安装 MySQL8.0（CentOS7/8 生产标准）
1. 安装流程

1. 导入官方 yum 源
rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum makecache

2. 安装服务端+客户端
yum install -y mysql-community-server mysql-community-client

3. 启动开机自启
systemctl start mysqld
systemctl enable mysqld

2. YUM 默认目录结构
| 路径 | 作用 |
|------|------|
| `/etc/my.cnf` | 主配置文件 |
| `/var/lib/mysql/` | 默认数据目录、ibdata、binlog |
| `/var/log/mysqld.log` | 错误日志 |
| `/usr/bin/mysqldump` | 客户端工具 |
| `/usr/lib/systemd/system/mysqld.service` | 服务管理文件 |

3. 初始化安全配置

获取临时初始密码
grep 'temporary password' /var/log/mysqld.log

安全初始化脚本（生产必执行）
mysql_secure_installation
交互配置项：
1. 修改 root 初始密码
2. 开启密码强度校验策略
3. 删除匿名用户
4. 关闭 root 本地之外远程登录
5. 删除 test 测试库
6. 刷新权限

4. 开启远程访问权限
8.0 密码认证插件 caching_sha2_password
CREATE USER 'root'@'%' IDENTIFIED BY 'Root@123456';
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

5. 密码策略调优（my.cnf）

[mysqld]
validate_password.policy = STRONG
validate_password.length = 10
validate_password.mixed_case_on = 1
validate_password.special_char_count = 1

二、二进制包离线安装（隔离环境、定制数据盘）

1. 基础部署步骤

1. 解压到统一目录

tar -xf mysql-8.0.36-linux-glibc2.28-x86_64.tar.xz -C /usr/local/
ln -s /usr/local/mysql-8.0.36 /usr/local/mysql

2. 创建 mysql 运行用户、数据目录

useradd -s /sbin/nologin mysql
mkdir -p /data/mysql_3306
chown -R mysql: mysql /usr/local/mysql /data/mysql_3306

3. 初始化数据

/usr/local/mysql/bin/mysqld --initialize --user=mysql --datadir=/data/mysql_3306

4. 配置环境变量

echo 'export PATH =$PATH:/usr/local/mysql/bin' >> /etc/profile
source /etc/profile

5. 自建 systemd 服务管理

cat > /usr/lib/systemd/system/mysqld-3306.service << EOF
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

三、多实例部署（3306/3307 多端口隔离，生产业务分库）

1. 多实例目录规划

/etc/
├── my_3306.cnf
└── my_3307.cnf
/data/
├── mysql_3306/
└── mysql_3307/
/var/log/mysql/
├── 3306.err
└── 3307.err

2. 单实例配置模板 `my_3306.cnf`

[mysqld]
port=3306
socket=/tmp/mysql3306.sock
datadir=/data/mysql_3306
pid-file =/run/mysql_3306.pid
log_error=/var/log/mysql/3306.err
server-id = 3306

基础性能参数
character-set-server = utf8mb4
default-storage-engine = InnoDB
innodb_buffer_pool_size=2G

3. 3307 实例仅修改端口、datadir、server-id、socket

4. 多实例启停命令

启动 3307
systemctl start mysqld-3307
本地登录指定实例
mysql -S /tmp/mysql3307.sock -uroot -p
远程连接
mysql -h127.0.0.1 -P3307 -uroot -p

四、生产初始化核心规范总结

1. **安装选型**
内网可联网服务器：YUM 安装，运维简单
隔离离线环境、高性能定制磁盘：二进制包
2. **多实例适用场景**
服务器资源充足、业务库隔离、区分读写/测试库，不额外采购机器
3. **安全硬性规范**
必须执行 `mysql_secure_installation`
强密码策略、大小写+数字+特殊字符、长度 ≥10
禁止生产 root 无限制%远程，按需分配最小权限账号
数据目录权限仅 mysql 用户可读，禁止 777
4. **权限最小化**
   业务账号仅授予对应库 SELECT/INSERT/UPDATE/DELETE，杜绝 ALL PRIVILEGES
```


**⑤ 🎯 面试考点**：
- yum 装 vs 源码编译区别？答：yum 快、版本固定、易升级；源码可加模块/定制路径，升级繁。
- mysqld --initialize 生成什么？答：初始系统库、临时 root 密码（在错误日志）、ssl 文件。
- my.cnf 关键参数？答：innodb_buffer_pool_size（缓冲池，设物理内存 60-80%）、character_set_server=utf8mb4、datadir、log_bin。

### 2）权限体系

**① 一句话本质**：MySQL 权限 = 用户(user)+主机(host)+权限粒度三层，用 grant/revoke 管理，root 必须加固。


- 用户创建、授权、回收权限
- 精细化业务账号、最小权限原则
- 禁止 root 远程登录

``` md
MySQL 权限体系生产实操（最小权限原则）
一、基础语法：创建用户、授权、回收、删除
1. 创建业务用户（MySQL8.0）
格式：CREATE USER '账号'@'访问主机' IDENTIFIED BY '强密码';
仅本地访问
CREATE USER 'biz_user'@'localhost' IDENTIFIED BY 'Biz@123456';
内网网段访问
CREATE USER 'biz_user'@'192.168.%' IDENTIFIED BY 'Biz@123456';
禁止 root@% 全局远程，只允许本地登录 root
CREATE USER 'root'@'localhost' IDENTIFIED BY 'Root@Admin789';
删除危险全局 root（生产必执行）
DROP USER IF EXISTS 'root'@'%';
FLUSH PRIVILEGES;

2. 精细化授权（最小权限，禁止 ALL PRIVILEGES）

语法：GRANT 权限列表 ON 库名.表 TO '用户'@'主机';
场景 1：普通业务读写账号（单库）
GRANT SELECT, INSERT, UPDATE, DELETE ON business_db.* TO 'biz_user'@'192.168.%';

场景 2：只读分析账号（报表、数据查询）
GRANT SELECT ON business_db.* TO 'read_user'@'192.168.%';

场景 3：DBA 运维账号（仅管理库权限，不开放业务数据全量操作）
GRANT PROCESS, RELOAD, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'dba_admin'@'192.168.%';

刷新权限，立即生效
FLUSH PRIVILEGES;

常用细分权限：

DML：SELECT/INSERT/UPDATE/DELETE（业务必备）
DDL：CREATE/DROP/ALTER（仅给运维，业务账号不授予）
运维：PROCESS（查看进程）、RELOAD（刷新配置）、REPLICATION（主从复制）

3. 回收权限

回收指定库写权限
REVOKE INSERT, UPDATE, DELETE ON business_db.* FROM 'biz_user'@'192.168.%';
FLUSH PRIVILEGES;

4. 删除无用账号
DROP USER IF EXISTS 'test_user'@'%';
FLUSH PRIVILEGES;

二、查看权限相关命令
查看当前用户权限
SHOW GRANTS;
查看指定用户权限
SHOW GRANTS FOR 'biz_user'@'192.168.%';
查看所有用户
SELECT user, host FROM mysql.user;

三、生产权限规范（核心要点）

1. **禁止 root 远程登录**

删除 `root@%` 用户，root 仅保留 `localhost` 本地登录；
远程运维单独创建 DBA 专用账号，不共用 root。

2. **严格最小权限原则**

业务账号只分配业务库，禁止 `*.*` 全库权限；
区分读写账号：业务读写、报表只读分离；
普通业务账号不授予 ALTER/DROP/CREATE 等 DDL 高危权限。

3. **访问主机限制**

不使用 `%` 无限制通配；
限定内网 IP/网段（如 `192.168.%`），公网禁止数据库端口暴露。

4. **账号生命周期管理**

离职、下线业务及时回收权限、删除账号；
定期执行 `SELECT user,host FROM mysql.user` 清理僵尸匿名用户、测试账号。

四、生产安全加固脚本示例

1. 删除全局 root
DROP USER IF EXISTS 'root'@'%';
2. 删除匿名用户
DROP USER IF EXISTS ''@'localhost';
DROP USER IF EXISTS ''@'%';
3. 新建内网 DBA 运维账号
CREATE USER 'dba_op'@'192.168.%' IDENTIFIED BY 'Dba@Op2026';
GRANT PROCESS, RELOAD, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'dba_op'@'192.168.%';
4. 业务读写账号
CREATE USER 'app_biz'@'192.168.%' IDENTIFIED BY 'App@Biz666';
GRANT SELECT, INSERT, UPDATE, DELETE ON app_db.* TO 'app_biz'@'192.168.%';
FLUSH PRIVILEGES;
```


**⑤ 🎯 面试考点**：
- "user"@"host" 中 host 作用？答：限定来源 IP/网段，'root'@'localhost' 与 'root'@'%' 是不同账户。
- grant all on db.* 含义？答：对 db 库所有表授权；*.* 为全局。
- 如何禁止 root 远程登录？答：删 'root'@'%' 仅留 localhost，或设强密+限制来源。

### 3）日志体系

**① 一句话本质**：MySQL 日志 = error/binlog/slow/redo/undo，是排障、主从复制、数据恢复的核心依据。


- error_log 错误日志排障
- slow_query_log 慢查询开启、分析、优化
- binlog 二进制日志：作用、三种格式、日志截取恢复

``` md
MySQL 三大日志体系 生产实操手册
1.error_log 故障排障 | 2.slow_query_log 性能优化 | 3.binlog 主从+数据恢复

1. error_log 错误日志（排障第一入口）
作用：记录启动/运行/停止过程中所有错误、警告、异常信息
cat >> /etc/my.cnf <<'EOF'
[mysqld]
指定错误日志文件路径
log_error=/var/log/mysql/mysqld.err
记录警告级以上信息，生产建议开启
log_warnings=2
EOF

实时排查命令
tail -f /var/log/mysql/mysqld.err          # 实时追踪报错
grep "ERROR" /var/log/mysql/mysqld.err    # 过滤所有错误行
常见报错场景：端口占用、数据目录权限、内存不足、主从同步中断、表损坏

2. slow_query_log 慢查询日志（SQL 性能优化核心）
作用：记录执行时间超过阈值的 SQL，定位低效 SQL 做索引优化
cat >> /etc/my.cnf <<'EOF'
[mysqld]
开启慢查询日志
slow_query_log=ON
慢查询日志文件路径
slow_query_log_file=/var/log/mysql/slow.log
慢查询阈值：执行时间超过 1 秒的 SQL 记录（单位：秒）
long_query_time=1
记录未使用索引的 SQL，即使执行快也记录
log_queries_not_using_indexes=ON
慢查询记录行数阈值，避免大量小查询刷屏
min_examined_row_limit=100
EOF

慢查询分析工具 mysqldumpslow（MySQL 自带）
按访问次数排序，取 Top10 慢 SQL
mysqldumpslow -s c -t 10 /var/log/mysql/slow.log
按查询总耗时排序，取 Top10
mysqldumpslow -s t -t 10 /var/log/mysql/slow.log
按平均耗时排序
mysqldumpslow -s at -t 10 /var/log/mysql/slow.log
带 like 模糊匹配，只查 select 语句
mysqldumpslow -s t -t 10 -g "select" /var/log/mysql/slow.log

3. binlog 二进制日志（核心：主从复制 + 数据误删恢复）
作用：1.主从复制数据同步 2.增量备份 3.误操作数据闪回
3.1 三种格式说明
STATEMENT：记录执行的 SQL 语句，日志体积小；但函数/触发器会导致主从不一致，已淘汰
ROW：记录每行数据的变更，日志体积大；数据准确无歧义，生产默认标准
MIXED：混合模式，普通 SQL 用 STATEMENT，不确定操作自动切 ROW，兼容场景用

cat >> /etc/my.cnf <<'EOF'
[mysqld]
开启 binlog，指定日志前缀（自动生成 mysql-bin.000001 递增文件）
log_bin=/var/lib/mysql/mysql-bin
生产标准格式：ROW 行级模式，数据一致性最高
binlog_format=ROW
服务唯一 ID，主从必须不同
server-id = 1
binlog 过期自动清理天数，生产保留 7-30 天
expire_logs_days=7
单个 binlog 文件最大大小，默认 1G
max_binlog_size=1G
开启 binlog 行模式附加信息，方便闪回解析
binlog_rows_query_log_events=ON
EOF

3.2 常用运维命令
mysql -e "show variables like '%log_bin%';"    # 查看 binlog 是否开启
mysql -e "show binary logs;"                   # 查看所有 binlog 文件
mysql -e "show master status;"                 # 查看当前正在写入的 binlog 和位置点
mysql -e "flush logs;"                         # 手动滚动生成新 binlog 文件

3.3 binlog 查看与数据恢复
文本方式查看 binlog（ROW 模式需加-vv 解析行数据）
mysqlbinlog -vv /var/lib/mysql/mysql-bin.000001 | less

按时间范围截取 binlog，导出为 SQL 用于恢复
mysqlbinlog --start-datetime="2026-07-14 09:00:00" \
stop-datetime="2026-07-14 12:00:00" \
            /var/lib/mysql/mysql-bin.000001 > /tmp/recover.sql

按精确位置点恢复（精准度最高，推荐生产使用）
mysqlbinlog --start-position=156 --stop-position=1200 \
            /var/lib/mysql/mysql-bin.000001 | mysql -uroot -p

核心速记
1. 出问题先看 error_log：启动失败、主从断连、权限报错一目了然
2. 慢查询优化流程：开 slow_log → mysqldumpslow 定位 TopN → 加索引/改写 SQL
3. binlog 生产必开：ROW 格式为主从和数据兜底，误删靠时间点/位置点闪回恢复
```


**⑤ 🎯 面试考点**：
- binlog 三种格式区别？答：STATEMENT（记 SQL，省空间有函数隐患）/ROW（记行变更，安全占空间）/MIXED（混合）。
- slow log 阈值参数？答：slow_query_log=on、long_query_time（默认 10s）。
- binlog 两大作用？答：主从复制数据源 + 时间点恢复。

### 4）索引优化基础（运维必备）

**① 一句话本质**：MySQL 索引 = 加速查询的 B+Tree 结构，合理建索引避免全表扫描，但过多索引拖慢写入。


- 普通索引、唯一索引、联合索引最左匹配
- 慢 SQL 定位、explain 执行计划看懂
- 避免索引失效场景

``` md
MySQL 索引优化基础（运维必备）
1. 核心索引类型 + 联合索引最左匹配原则
2. 慢 SQL 定位 + explain 执行计划核心字段解读
3. 常见索引失效场景与避坑规则

一、核心索引类型与创建规则
1. 普通索引：最基础索引，仅用于加速查询，无数据约束
适用：频繁作为查询条件、无唯一性要求的字段
mysql -uroot -p -e "CREATE INDEX idx_name ON test_db.user(name);"

2. 唯一索引：加速查询 + 强制字段值全局唯一（允许空值）
适用：手机号、身份证、订单号等天然唯一的业务字段
mysql -uroot -p -e "CREATE UNIQUE INDEX idx_phone ON test_db.user(phone);"

3. 主键索引：特殊的唯一索引，一张表只能有一个，非空+唯一，InnoDB 下为聚簇索引
建表时指定：PRIMARY KEY(id)，推荐自增无业务意义的 ID 做主键

4. 联合索引（复合索引）：多个字段组合成一个索引，严格遵循【最左匹配原则】
适用：多字段组合查询的场景，比多个单列索引性能更高
mysql -uroot -p -e "CREATE INDEX idx_age_name_sex ON test_db.user(age, name, sex);"

最左匹配原则核心规则
联合索引按字段定义顺序从左到右匹配，跳过左侧字段则索引整体/部分失效
以上面 idx_age_name_sex(age, name, sex) 为例：
✅ 全值匹配走全索引：where age = 10 and name ='张三' and sex = 1
✅ 走左侧部分索引：where age = 10
✅ 走左侧两列索引：where age = 10 and name ='张三'
✅ 仅最左列生效：where age = 10 and sex = 1 （sex 列无法用到索引）
❌ 完全失效：where name ='张三' / where sex = 1 （跳过最左字段 age）

查看表上所有索引详情
mysql -uroot -p -e "SHOW INDEX FROM test_db.user;"
删除索引
mysql -uroot -p -e "DROP INDEX idx_name ON test_db.user;"

二、慢 SQL 定位 + explain 执行计划解读
1. 第一步：定位慢 SQL
开启慢查询日志 → 用 mysqldumpslow 分析 TopN 慢 SQL（详见日志体系章节）
核心命令：mysqldumpslow -s t -t 10 /var/log/mysql/slow.log

2. 第二步：explain 分析执行计划（运维核心技能）
作用：判断 SQL 是否走索引、扫描行数、排序方式，定位性能瓶颈
mysql -uroot -p -e " EXPLAIN SELECT * FROM test_db.user WHERE age = 25;"

explain 必背核心字段
1. type：访问类型（性能从优到劣排序）
system > const > eq_ref > ref > range > index > ALL
优化底线：杜绝 ALL（全表扫描），核心 SQL 至少达到 range/ref 级别
2. possible_keys：可能用到的索引（候选）
3. key：实际真正用到的索引，NULL 表示索引失效
4. key_len：索引使用字节长度，可判断联合索引生效了几列
5. rows：预估扫描的行数，数值越小性能越好
6. Extra：额外关键信息
✅ Using index：覆盖索引，无需回表查询，性能最优
⚠️  Using where：引擎层过滤后返回，正常场景
❌ Using filesort：文件排序，无法利用索引排序，需优化
❌ Using temporary：使用临时表，常见于分组去重，性能极差

三、常见索引失效场景（避坑指南）
前置条件：假设 name 字段建有普通索引 idx_name

1. ❌ 索引列使用函数、算术运算、表达式
失效示例：SELECT * FROM user WHERE LEFT(name,2)='张';
原因：函数破坏索引有序性，优化器无法匹配
优化：改写为右模糊匹配 name LIKE '张%'

2. ❌ 隐式类型转换
失效示例：SELECT * FROM user WHERE phone = 13800138000;
原因：phone 是字符串类型，数字对比会触发隐式转换
优化：严格匹配类型 phone = '13800138000'

3. ❌ LIKE 左模糊 / 全模糊
失效示例：name LIKE '%张三' / name LIKE '%张三%'
原因：前缀不固定，无法利用 B+树有序性
优化：右模糊 name LIKE '张%' 可走索引；复杂模糊搜索用 ES 全文引擎

4. ❌ 联合索引不满足最左前缀
失效示例：联合索引 idx(a, b, c)，查询条件只有 b、c
优化：查询条件必须包含最左列，调整索引字段顺序

5. ❌ 负向查询：!=、<>、NOT IN、NOT EXISTS
失效场景：数据量大时优化器放弃索引，选择全表扫描
优化：业务拆分查询，或用范围查询替代负向判断

6. ❌ OR 连接非索引列
失效示例：WHERE name ='张三' OR age = 25 （age 无索引）
原因：只要有一列无索引，整句索引失效
优化：两列都建索引，或拆分为两条 SQL 用 UNION 合并

7. ❌ IS NULL / IS NOT NULL（大量数据场景）
原因：空值占比高时，优化器认为全表扫描更快
优化：字段设置默认值，业务上避免 NULL 判断

核心速记
1. 索引分类：普通加速、唯一去重、联合靠最左匹配
2. 优化流程：慢日志捞 TopN → explain 查执行计划 → 加索引/改写 SQL
3. 失效避坑：忌函数运算、忌隐式转换、忌左模糊、忌跳最左列、忌负向全表扫
```


**⑤ 🎯 面试考点**：
- 最左前缀原则？答：联合索引 (a,b,c) 只在 a 开头查询时用上，跳过 a 失效。
- 聚簇 vs 非聚簇？答：InnoDB 聚簇（叶子存整行，主键即聚簇键）；MyISAM 非聚簇（叶子存指针）。
- 索引失效场景？答：对索引列函数/运算、隐式类型转换、前导模糊 like '%x'、or 含非索引列。
- explain 看什么？答：type（const/ref/range/ALL）、key（用到的索引）、rows（扫描行）、Extra（Using index/filesort）。

### 5）主从复制架构（企业必备）

**① 一句话本质**：MySQL 主从 = 基于 binlog 异步复制，从库重放实现读写扩展与热备。


- 主从原理、binlog 日志推送、IO/SQL 线程
- 异步复制 / 半同步复制部署
- 主从延迟排查、偏移量报错修复
- 主从数据一致性校验

``` md
MySQL 主从复制架构 生产运维手册
1. 核心原理 | 2. 异步复制部署 | 3. 半同步复制部署
4. 主从延迟/报错排查修复 | 5. 数据一致性校验

【核心原理】
3 个线程完成数据同步：
1. 主库 binlog dump 线程：监听 binlog 变更，主动推送新日志给从库
2. 从库 IO 线程：接收主库 binlog，写入本地 relay log（中继日志）
3. 从库 SQL 线程：读取 relay log，重放 SQL 到本地数据库
#
复制模式区别：
异步复制：主库事务提交后立即返回客户端，性能最高，极端情况丢数据
半同步复制：主库提交后等待至少 1 个从库接收 binlog 并返回 ack，一致性高，性能有损耗

一、异步复制部署（生产默认方案，性能优先）
主库（Master）配置
1. 追加主配置文件参数
cat >> /etc/my.cnf <<'EOF'
[mysqld]
server-id = 1                    # 全局唯一 ID，主从节点必须不同
log_bin=/var/lib/mysql/mysql-bin  # 开启 binlog，主从复制依赖
binlog_format=ROW              # 行级模式，数据一致性最高，生产标准
binlog_expire_logs_seconds=604800  # binlog 自动过期清理（8.0 替代 expire_logs_days；5.7 旧版用 expire_logs_days = 7）
注意：information_schema/performance_schema 系统库本身不会进 binlog，无需 ignore；
复制过滤建议用 replicate-ignore-db（从库端）而非 binlog-ignore-db（主库端，易引发主从不一致）
EOF

2. 重启主库生效
systemctl restart mysqld

3. 创建最小权限复制账号
mysql -uroot -p << EOF
CREATE USER 'repl_user'@'192.168.%' IDENTIFIED BY 'Repl@Pass2026';
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'repl_user'@'192.168.%';
FLUSH PRIVILEGES;
EOF

4. 全量备份+记录 binlog 位置（InnoDB 用单事务备份，不锁表）
mysqldump -uroot -p --all-databases --master-data=2 --single-transaction > /tmp/full_backup.sql
备份文件自带 binlog 文件名与偏移量，也可手动查看
mysql -uroot -p -e "SHOW MASTER STATUS;"

从库（Slave）配置
1. 追加从库配置参数
cat >> /etc/my.cnf <<'EOF'
[mysqld]
server-id = 2                    # 必须与主库不同
relay_log=/var/lib/mysql/relay-bin  # 中继日志
read_only=ON                   # 普通用户只读，防止业务误写从库（root 等 super 权限不受限）
并行复制配置，解决 SQL 单线程重放延迟（5.7 用 slave_parallel_type；8.0 已更名 replica_parallel_type）
replica_parallel_type=LOGICAL_CLOCK
replica_parallel_workers=4
EOF

2. 重启从库，导入全量备份数据
systemctl restart mysqld
mysql -uroot -p < /tmp/full_backup.sql

3. 配置主库连接信息，启动复制
mysql -uroot -p << EOF
8.0+ 新语法：CHANGE REPLICATION SOURCE TO ... / START REPLICA / SHOW REPLICA STATUS
CHANGE MASTER TO
  MASTER_HOST='192.168.1.10',
  MASTER_PORT=3306,
  MASTER_USER='repl_user',
  MASTER_PASSWORD='Repl@Pass2026',
  MASTER_LOG_FILE='mysql-bin.000001',
  MASTER_LOG_POS=156;
START SLAVE;
EOF

4. 验证主从状态
mysql -uroot -p -e "SHOW SLAVE STATUS\G"   # 8.0+ 可用 SHOW REPLICA STATUS
正常核心标志：
Slave_IO_Running: Yes    IO 线程正常，持续接收 binlog
Slave_SQL_Running: Yes   SQL 线程正常，持续重放数据
Seconds_Behind_Master: 0 主从延迟秒数，0 表示同步完成

二、半同步复制部署（金融/核心业务，数据一致性优先）
主库安装半同步插件
mysql -uroot -p << EOF
INSTALL PLUGIN rpl_semi_sync_master SONAME 'semisync_master.so';
SET GLOBAL rpl_semi_sync_master_enabled = 1;
SET GLOBAL rpl_semi_sync_master_timeout = 1000;  # 1 秒未收到 ack 自动降级为异步
SET GLOBAL rpl_semi_sync_master_wait_for_slave_count = 1;  # 至少等待 1 个从库确认
EOF

主库配置永久生效
cat >> /etc/my.cnf <<'EOF'
plugin-load-add = semisync_master.so
rpl_semi_sync_master_enabled=1
rpl_semi_sync_master_timeout=1000
EOF

从库安装半同步插件
mysql -uroot -p << EOF
INSTALL PLUGIN rpl_semi_sync_slave SONAME 'semisync_slave.so';
SET GLOBAL rpl_semi_sync_slave_enabled = 1;
STOP SLAVE IO_THREAD;
START SLAVE IO_THREAD;  # 重启 IO 线程生效
EOF

从库配置永久生效
cat >> /etc/my.cnf <<'EOF'
plugin-load-add = semisync_slave.so
rpl_semi_sync_slave_enabled=1
EOF

验证半同步状态
mysql -uroot -p -e "SHOW STATUS LIKE 'Rpl_semi_sync_master_status';"

三、主从故障排查与修复
统一排查入口
mysql -uroot -p -e "SHOW SLAVE STATUS\G"
重点字段：Last_IO_Error / Last_SQL_Error 直接给出报错原因

场景 1：主从延迟大（Seconds_Behind_Master 数值高）
常见根因：
1. 主库大事务：批量删改、大表 DDL，从库单线程重放跟不上
2. 从库硬件弱：CPU/磁盘 IO 性能低于主库
3. 未开并行复制：高并发写入下 SQL 线程瓶颈
4. 跨机房网络：binlog 传输延迟
5. 从库慢查询：大查询占用 IO 资源，拖慢重放

优化方案：
1. 大事务拆分为小事务分批执行
2. 开启 LOGICAL_CLOCK 并行复制（已配置）
3. 从库升级磁盘/CPU，避免在从库跑大报表
4. 读写分离做负载，分散从库查询压力

场景 2：SQL 线程报错（1032/1062 数据不一致）
1062 错误：主键冲突，从库已存在对应记录
1032 错误：要更新/删除的记录在从库不存在
临时应急：跳过单个事务（仅非核心数据使用，确认业务无影响）
mysql -uroot -p << EOF
STOP SLAVE;
SET GLOBAL sql_slave_skip_counter = 1;
START SLAVE;
EOF

批量跳过指定错误号（不推荐长期开启，仅临时应急）
配置文件追加：slave_skip_errors = 1062,1032

彻底修复：执行数据一致性校验后同步差异，或重新全量搭建主从

场景 3：IO 线程异常
常见原因：主库端口不通、复制账号密码错误、主库 binlog 被清理
排查：telnet 主库 3306、验证复制账号权限、核对主库 binlog 留存周期

四、主从数据一致性校验与修复
工具：percona-toolkit 生产标准套件
1. 安装工具
yum install -y percona-toolkit

2. 校验指定库数据一致性（主库执行，自动对比主从差异）
pt-table-checksum \
user=root --password='Root@123456' \
host=127.0.0.1 \
databases=business_db \
replicate=percona.checksums \
no-check-binlog-format
结果 DIFFS 列为 1，表示该表主从数据不一致

3. 修复差异数据（先预览再执行，避免误操作）
print 仅打印修复 SQL；确认无误后替换为 --execute 正式执行
pt-table-sync \
user=root --password='Root@123456' \
sync-to-master \
  h=192.168.1.20, D=business_db, t=user_table \
print

核心速记
1. 复制流程：主库 dump 推 binlog → 从库 IO 写中继日志 → SQL 线程重放
2. 异步性能高、有丢数风险；半同步一致性高、性能略降，核心业务用
3. 健康标准：IO/SQL 双 Yes，延迟趋近于 0
4. 延迟优化：拆大事务、开并行复制、提升从库硬件
5. 定期巡检：pt-table-checksum 校验一致性，发现差异及时修复
```


**⑤ 🎯 面试考点**：
- 主从原理？答：主库写 binlog→从库 IO 线程拉取存 relay log→SQL 线程重放。
- 主从延迟原因？答：从库单 SQL 线程跟不上、大事务、从库负载高、网络。
- 半同步复制？答：主库等至少一个从库接收 binlog 才返回，降数据丢失风险、增延迟。

### GTID 主从复制（生产主流方案，必会）

**① 一句话本质**：GTID = 给每个事务全局唯一 ID，复制位点自动追踪，故障切换比传统位点复制简单可靠。


``` md
GTID 主从复制（全局事务标识，替代传统 binlog+pos，MySQL 5.6+ 生产主流）
一、GTID 与传统复制的区别
1. 传统复制：从库靠 日志文件名 + 偏移量 定位同步位置，主从日志名不同会错位
2. GTID 复制：每个事务有全局唯一 ID（server_uuid:事务号），从库自动找断点，天然防错位
3. 优势：主从切换无需手动找位置；自动跳过已执行事务；级联复制更安全

二、主库配置（my.cnf）
server-id=1
gtid_mode=ON
enforce_gtid_consistency=ON
log_bin=mysql-bin
binlog_format=ROW

三、从库配置
server-id=2
gtid_mode=ON
enforce_gtid_consistency=ON

四、主从建立（关键：先备份还原，自动接管 GTID）
1. 主库全备（含 GTID 信息）
mysqldump --all-databases --single-transaction --set-gtid-purged=ON > /tmp/all.sql
2. 从库还原：mysql < /tmp/all.sql
3. 从库指向主库（无需指定日志文件名和位置）
CHANGE MASTER TO MASTER_HOST='192.168.1.10', MASTER_USER='repl',
MASTER_PASSWORD='Repl@123456', MASTER_AUTO_POSITION=1;
4. 启动复制：START SLAVE;
5. 验证：SHOW SLAVE STATUS\G  # Slave_IO_Running 和 Slave_SQL_Running 双 Yes

五、主从切换（故障演练重点）
1. 从库追平后：STOP SLAVE; RESET MASTER;
2. 原从库提升为主，其他从库 CHANGE MASTER 指向新主（Master_Auto_Position=1）
3. 全程无需手工计算 binlog 位置，比传统复制简单可靠

速记：gtid_mode=ON 开启，MASTER_AUTO_POSITION=1 自动定位，切换不用找 binlog 位置
```


**⑤ 🎯 面试考点**：
- GTID 与传统复制区别？答：GTID 全局唯一事务 ID 替代文件名+位点，复制自动定位。
- gtid_mode 作用？答：开启需 enforce_gtid_consistency=ON，保证事务幂等。
- 故障切换优势？答：无需找 binlog 位点，自动找下一个 GTID，简化运维。

### 6）读写分离架构认知

**① 一句话本质**：读写分离 = 写主库、读从库，减轻主库压力，但需面对主从延迟带来的数据一致性问题。


- 写主库、读从库
- 业务适配、故障切换思路

``` md
MySQL 读写分离架构认知（生产必备）
核心逻辑：主库承接所有写操作，从库承接读请求，横向扩展读能力
基于主从复制架构实现，解决高并发读场景主库性能瓶颈

一、核心架构原理
1. 流量划分规则
✅ 写请求（INSERT/UPDATE/DELETE/DDL）：全部路由到主库 Master
✅ 读请求（SELECT）：大部分路由到从库 Slave，特殊场景走主库
2. 数据基础：依赖主从复制，主库 binlog 同步到从库，保证数据最终一致性
3. 核心价值
横向扩展读并发能力，单主库读性能触顶时，新增从库即可扩容
读写资源隔离，复杂报表、统计查询不占用主库写入资源
4. 天生缺陷：存在主从复制延迟，写入后立即查询可能读不到最新数据

二、两种主流实现方案（业务适配方式）

方案 1：应用层代码实现（轻量方案，中小项目常用）
原理：项目内配置多数据源，写操作走主库数据源，读操作走从库数据源
常见技术栈
Java：MyBatis-Plus 多数据源插件、Sharding-JDBC 内嵌代理
Go/Python：手动封装 DB 连接层，按 SQL 类型自动路由
优点：无额外中间件，架构简单，无网络转发性能损耗
缺点：与业务代码耦合，多语言项目适配成本高，故障切换需代码支持
业务适配要点
封装路由逻辑，自动根据 SQL 语句判断读写分类
预留强制走主库的接口，用于实时性要求极高的场景（如支付后查订单状态）

方案 2：中间件代理层实现（中大型项目标准方案）
原理：业务统一连接中间件，中间件解析 SQL 后自动路由到对应节点，业务无感知
主流工具：ProxySQL（轻量高性能，业界主流）、MyCat（兼顾分库分表+读写分离）
优点：业务零侵入，统一管控，支持自动故障切换、读负载均衡
缺点：新增一层网络转发，有少量性能损耗，需维护中间件自身高可用

生产通用路由规则（ProxySQL 典型配置逻辑）
1. 带锁查询 SELECT ... FOR UPDATE → 强制路由主库
2. 普通 SELECT 查询 → 路由从库组，轮询/权重负载均衡
3. 所有非 SELECT 语句 → 全部路由主库
4. 延迟兜底：从库延迟超过阈值时，自动将读请求切回主库

三、故障切换核心思路

1. 从库故障（读节点宕机）
影响：整体读能力下降，不影响写入业务
处理流程
1. 监控告警检测到从库离线 / 主从延迟超标
2. 读写分离层自动剔除故障从库，读流量转移到剩余健康从库
3. 运维排查从库故障，修复后重新加入读资源池
4. 多从库部署场景下，单节点故障业务完全无感知

2. 主库故障（写节点宕机）
影响：数据库无法写入，属于核心级故障
处理思路：主从切换，提升一台数据最新的从库为新主库
生产常用自动切换工具：MHA、Orchestrator、云数据库自带高可用组件
标准切换步骤
1. 心跳检测确认主库宕机，触发切换流程
2. 选举数据最完整的从库（中继日志全部重放完成）作为新主库
3. 其余从库断开旧主库连接，指向新主库继续同步
4. 读写分离层更新路由规则，写流量切到新主库
5. 旧主库修复后，作为新主库的从库重新加入集群
注意：切换过程存在秒级写中断，核心业务需做降级容错

四、生产落地避坑要点
1. 主从延迟（最大坑点）
场景：写入后立刻查询，因复制延迟从库无数据，导致业务异常
解决方案：
✅ 核心实时读（如下单、支付后状态查询）强制走主库
✅ 中间件配置延迟阈值，从库延迟 > 1s 时自动切主库
✅ 业务层做短暂重试，容忍毫秒级复制延迟
2. 带锁查询必须走主库
SELECT ... FOR UPDATE、SELECT ... LOCK IN SHARE MODE 必须路由主库，否则从库只读报错
3. 读负载均衡
多从库场景按硬件性能分配权重，避免弱配置从库被打满
4. 不适用场景
读少写多的业务：无扩容价值，徒增架构复杂度
强一致性要求极高：金融核心账务类场景，无法容忍任何延迟，不适合读写分离

核心速记
1. 本质：写主读从，基于主从复制，横向扩展读性能
2. 选型：小项目用代码多数据源，中大型用 ProxySQL 中间件
3. 避坑：主从延迟是常态，实时读强制走主库
4. 故障：从库挂了摘节点，主库挂了做主从切换
5. 前提：先搭稳主从复制，再落地读写分离
```


**⑤ 🎯 面试考点**：
- 实现方式？答：中间件（MyCat/ProxySQL）或代码路由（写主读从）。
- 主从延迟导致脏读怎么解？答：关键读强制走主，或用延迟感知/写完等同步再读。

### 7）备份与恢复（运维核心工作）

**① 一句话本质**：备份 = mysqldump 逻辑备份 + xtrabackup 物理热备，恢复能力是数据不丢的最后防线。


- mysqldump 全量备份 + 定时任务
- XtraBackup 物理热备（增量 / 全量）
- 定时备份脚本、异地备份、定期恢复演练

``` md
MySQL 备份与恢复 生产运维核心手册
1. mysqldump 逻辑全量备份 | 2. XtraBackup 物理热备（全量+增量）
3. 定时备份策略 | 4. 异地备份 | 5. 恢复演练规范

一、mysqldump 逻辑全量备份（中小库通用，运维标配）
原理：导出 SQL 语句文本，兼容性强；大库备份慢、锁表风险高
核心参数说明
single-transaction  InnoDB 引擎热备，不锁表，保证数据一致性
master-data=2       记录 binlog 文件名与偏移量，用于增量恢复/搭建主从
all-databases       备份全库；指定单库替换为 库名
routines --triggers 备份存储过程、触发器
q                    不缓存查询结果，大库降低内存占用
gzip 压缩             备份文件压缩存储，节省磁盘

1. 单库全量备份脚本示例
cat > /data/backup/mysql_backup.sh <<'EOF'
#!/bin/bash
配置项
BACKUP_DIR="/data/backup/mysql"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="business_db"
MYSQL_USER="root"
MYSQL_PWD="Root@123456"
KEEP_DAYS=7

创建目录
mkdir -p $BACKUP_DIR

执行备份（InnoDB 热备，不锁表）
mysqldump -u $MYSQL_USER -p$MYSQL_PWD \
single-transaction --master-data=2 \
routines --triggers -q $DB_NAME \
  | gzip > $BACKUP_DIR/${DB_NAME}_$DATE.sql.gz

备份结果校验
if [ $? -eq 0 ]; then
  echo "[$(date)] 备份成功: ${DB_NAME}_$DATE.sql.gz" >> $BACKUP_DIR/backup.log
else
  echo "[$(date)] 备份失败！" >> $BACKUP_DIR/backup.log
fi

删除 7 天前过期备份
find $BACKUP_DIR -name "*.sql.gz" -mtime +$KEEP_DAYS -delete
EOF
chmod +x /data/backup/mysql_backup.sh

2. 恢复操作
方式 1：压缩包直接恢复
gunzip < business_db_20260714_020000.sql.gz | mysql -uroot -p business_db
方式 2：先解压再恢复
gunzip business_db_20260714_020000.sql.gz
mysql -uroot -p business_db < business_db_20260714_020000.sql

3. 增量恢复（全量备份+binlog）
步骤：先恢复全量备份 → 提取备份后到故障点的 binlog → 重放 SQL
mysqlbinlog --start-position=156 mysql-bin.000001 | mysql -uroot -p business_db

mysqldump 优缺点
✅ 优点：轻量、文件小、兼容性强、可跨版本恢复、支持单库单表
❌ 缺点：大库备份/恢复慢，全量锁表风险（MyISAM），仅支持全量逻辑备份

二、XtraBackup 物理热备（大库生产标准，支持增量）
原理：直接拷贝 InnoDB 数据文件+redo 日志，热备不锁表，速度快
适用：10G 以上大库，业务不能停服的核心数据库
安装依赖（Percona 官方工具）
yum install -y percona-xtrabackup-80

1. 全量物理备份
xtrabackup --user=root --password='Root@123456' \
backup --target-dir=/data/backup/xtra_full_$(date +%Y%m%d)
备份产物：数据文件、日志、binlog 位置信息，可直接用于恢复

2. 增量备份（基于上一次全量/增量，只备份变更页，速度极快）
第一步：先做一次全量备份作为基准
BASE_DIR=/data/backup/xtra_full_20260714
第二步：每日增量备份，指定基准目录
xtrabackup --user=root --password='Root@123456' \
backup --target-dir=/data/backup/xtra_incr_$(date +%Y%m%d) \
incremental-basedir=$BASE_DIR

3. 完整恢复流程（三步：准备全量 → 合并增量 → 回拷数据）
步骤 1：准备全量备份（应用 redo 日志，使数据处于一致性状态）
xtrabackup --prepare --apply-log-only --target-dir=/data/backup/xtra_full_20260714

步骤 2：合并增量备份到全量（多个增量依次合并）
xtrabackup --prepare --apply-log-only \
target-dir=/data/backup/xtra_full_20260714 \
incremental-dir=/data/backup/xtra_incr_20260715

步骤 3：最终一致性准备（最后一次不加--apply-log-only）
xtrabackup --prepare --target-dir=/data/backup/xtra_full_20260714

步骤 4：停止 MySQL，清空原数据目录，回拷备份数据
systemctl stop mysqld
rm -rf /var/lib/mysql/*
xtrabackup --copy-back --target-dir=/data/backup/xtra_full_20260714
chown -R mysql: mysql /var/lib/mysql
systemctl start mysqld

XtraBackup 优缺点
✅ 优点：热备不锁表、速度快、支持增量、大库恢复快
❌ 缺点：物理文件备份、占用空间大、不能跨版本/跨平台恢复

三、生产定时备份策略（crontab）
标准策略：每日凌晨全量备份，binlog 实时留存，异地同步
cat >> /var/spool/cron/root <<'EOF'
每天凌晨 2 点执行 mysqldump 全量逻辑备份
0 2 * * * /data/backup/mysql_backup.sh > /dev/null 2>&1
每天凌晨 3 点同步备份到异地备份服务器（rsync 增量同步）
0 3 * * * rsync -avz /data/backup/mysql/ backup_user@192.168.1.100:/data/backup/mysql/ > /dev/null 2>&1
EOF

生产备份规范
1. 保留策略：本地保留 7 天，异地保留 30 天
2. 备份类型：核心库 XtraBackup 物理全量+每日增量；非核心库 mysqldump 全量
3. 备份校验：每次备份后检查文件大小、返回状态，异常告警
4. 权限隔离：备份账号仅授予备份所需最小权限，不使用 super 账号

四、异地备份与安全
1. 同城/异地服务器同步：rsync + ssh 密钥免密
2. 云环境：备份文件同步到对象存储（OSS/COS/S3）
示例：同步到阿里云 OSS
ossutil cp /data/backup/mysql/ oss://backup-bucket/mysql/ -r

3. 备份加密：敏感业务备份文件加密存储
openssl enc -aes256 -salt -in backup.sql.gz -out backup.sql.gz.enc -k 加密密钥

五、定期恢复演练（生产硬性要求）
核心原则：没有经过恢复验证的备份 = 无效备份
演练周期：核心库每月 1 次，非核心库每季度 1 次
标准演练流程
1. 搭建独立恢复测试机，配置同版本 MySQL
2. 拉取最新全量备份+增量备份，执行完整恢复操作
3. 验证：数据完整性、表数量、核心业务表数据行数、关键字段数据
4. 记录恢复耗时、备份可用性，输出演练报告
5. 发现备份损坏/恢复失败，立即排查备份链路，修复后重新备份

核心速记
1. 小库用 mysqldump：简单通用，逻辑备份，支持单库单表
2. 大库用 XtraBackup：物理热备，速度快，支持增量
3. 数据兜底：全量备份 + binlog 增量，可恢复到任意时间点
4. 安全保障：本地保留+异地备份，定期演练验证备份有效性
5. 故障恢复优先级：先从库切换 → 再备份恢复，备份是最后兜底手段
```


**⑤ 🎯 面试考点**：
- 逻辑 vs 物理备份区别？答：mysqldump 逻辑（慢、锁表、跨版兼容）；xtrabackup 物理（热备、快、需同版本）。
- xtrabackup 热备原理？答：拷数据文件+redo，备份期间不锁表。
- 为何要做恢复演练？答：备份不验证=没备份，定期演练确保可恢复。

### 8）日常巡检与故障排障

**① 一句话本质**：日常巡检 = 监控核心指标 + 慢查询 + 复制状态，故障按"连接/锁/复制/磁盘"分层定位。


- 连接数爆满、死锁、卡慢事务
- 磁盘 IO 过高、日志爆满
- 主从宕机、切换、数据恢复

``` md
MySQL 日常巡检与故障排障 生产实操手册
覆盖场景：连接数爆满、死锁长事务、磁盘 IO 过高、日志爆满、主从宕机切换与数据恢复

一、日常核心巡检指标（每日必查，快速定位健康状态）

1. 连接与运行状态巡检
mysql -uroot -p -e "
查看当前连接数、峰值连接数
show global status like 'Threads_connected';
show global status like 'Max_used_connections';
查看最大连接数配置
show variables like 'max_connections';
查看运行线程状态
show processlist;
"
健康阈值：连接数不超过 max_connections 的 70%；大量 Sleep 空闲连接说明连接泄露

2. 数据库核心运行指标
mysql -uroot -p -e "
QPS 每秒查询量
show global status like 'Questions';
TPS 每秒事务量
show global status like 'Com_commit';
show global status like 'Com_rollback';
慢查询数量
show global status like 'Slow_queries';
InnoDB 缓冲池命中率（目标 > 99%）
show global status like 'Innodb_buffer_pool_read_requests';
show global status like 'Innodb_buffer_pool_reads';
"

3. 主从同步巡检（从库执行）
mysql -uroot -p -e "SHOW SLAVE STATUS\G"
核心校验项：
Slave_IO_Running=Yes、Slave_SQL_Running = Yes
Seconds_Behind_Master=0（延迟趋近于 0）
Last_IO_Error、Last_SQL_Error 为空

4. 磁盘空间巡检
检查数据目录、日志目录占用
du -sh /var/lib/mysql/
du -sh /var/log/mysql/
检查磁盘整体使用率
df -h
健康阈值：磁盘使用率不超过 80%，binlog/慢日志定期清理

二、典型故障排查与处理

故障 1：连接数爆满，报错 Too many connections
现象：业务无法连接数据库，日志提示连接数超限
排查步骤
1. 查看连接分布，定位占满连接的来源
mysql -uroot -p -e "SHOW FULL PROCESSLIST;"
重点关注：大量 Sleep 空闲连接、长时间执行的慢 SQL、同一 IP 大量连接

应急处理
1. 临时调大最大连接数（重启失效，先救业务）
mysql -uroot -p -e "SET GLOBAL max_connections = 2000;"
2. 批量杀掉空闲超时的 Sleep 连接（释放连接资源）
手动杀指定 ID：KILL 进程 ID;
批量杀超过 300 秒的空闲连接
mysql -uroot -p -e "SELECT CONCAT('KILL ', id,';') FROM information_schema.processlist WHERE Command ='Sleep' AND Time > 300;" | mysql -uroot -p

根因与根治
根因 1：应用端连接池配置过大/连接泄露 → 优化连接池参数，设置合理超时
根因 2：慢 SQL 占住连接不释放 → 优化慢 SQL，加索引
根因 3：短连接风暴 → 业务改用长连接池，减少频繁建连
根因 4：max_connections 配置过小 → my.cnf 永久调大参数

故障 2：死锁、长事务导致数据库卡慢
现象：业务接口超时，大量请求堆积，CPU/IO 飙升
1. 排查死锁
查看最近一次死锁详情
mysql -uroot -p -e "SHOW ENGINE INNODB STATUS\G"
定位 LATEST DETECTED DEADLOCK 段落，查看冲突 SQL、锁类型、事务信息

2. 排查长事务与锁等待
mysql -uroot -p -e "
查看当前运行中所有事务（重点关注 trx_started 运行时长）
SELECT * FROM information_schema.innodb_trx\G
查看当前锁等待关系
SELECT * FROM performance_schema.data_locks;
SELECT * FROM performance_schema.data_lock_waits;
"
危险信号：事务运行超过几十秒，持有行锁不释放，导致后续请求全部阻塞

应急处理
杀掉阻塞源头的长事务/死锁事务
mysql -uroot -p -e "KILL 事务对应的进程 ID;"

优化与规避
1. 大事务拆分为小事务，避免长事务持有锁
2. 业务层面加分布式锁，减少并发冲突
3. 统一使用索引更新，避免全表扫描升级为表锁
4. 设置事务超时参数，自动回滚挂起事务

故障 3：磁盘 IO 过高、日志爆满占满磁盘
现象：磁盘使用率 100%，数据库无法写入，服务挂起
1. 磁盘 IO 过高排查
查看 IO 使用率 TOP 进程
iotop
查看 MySQL IO 相关指标
mysql -uroot -p -e "SHOW GLOBAL STATUS LIKE 'Innodb_data_reads';"
常见根因：
大量慢查询全表扫描，读 IO 飙升
大事务批量写入，刷盘频繁
innodb_buffer_pool_size 太小，频繁磁盘读写

2. 日志爆满应急处理
第一步：定位大文件
find /var/lib/mysql -name " mysql-bin.*" -size +1G | sort -hr
du -sh /var/log/mysql/slow.log /var/log/mysql/mysqld.err

第二步：规范清理 binlog（禁止直接 rm 删除文件，必须用 MySQL 命令）
清理指定文件之前的所有 binlog
mysql -uroot -p -e "PURGE BINARY LOGS TO 'mysql-bin.000120';"
清理指定时间之前的 binlog
mysql -uroot -p -e "PURGE BINARY LOGS BEFORE '2026-07-01 00:00:00';"
永久生效：my.cnf 设置 expire_logs_days = 7 自动过期清理

第三步：大日志文件截断（慢日志/错误日志）
清空当前日志（不删除文件，避免 MySQL 找不到文件句柄）
> /var/log/mysql/slow.log
> /var/log/mysql/mysqld.err

根治方案
1. 配置 logrotate 轮转慢查询、错误日志，按天切割保留 30 天
2. 合理设置 binlog 过期时间，避免无限增长
3. 优化慢 SQL，减少大事务写入，降低磁盘 IO 压力

故障 4：主从宕机、切换与数据恢复
场景 A：从库宕机/同步中断
排查步骤：
1. 查看从库错误日志，定位报错原因
tail -f /var/log/mysql/mysqld.err
2. 查看从库状态，获取具体报错
mysql -uroot -p -e "SHOW SLAVE STATUS\G"

常见处理：
1062 主键冲突/1032 记录不存在：先跳过单事务验证，再做数据一致性修复
STOP SLAVE; SET GLOBAL sql_slave_skip_counter = 1; START SLAVE;
中继日志损坏：重置从库同步位点，重新全量同步
服务器硬件故障：修复硬件后，用备份重建从库

场景 B：主库宕机，手动主从切换（应急）
标准切换步骤：
1. 确认主库已无法恢复，停止所有业务写入
2. 在所有从库中，选择数据最完整的一台（Exec_Master_Log_Pos 最大）作为新主库
3. 登录新主库，关闭只读，提升为主库
mysql -uroot -p -e "
STOP SLAVE;
RESET MASTER;
SET GLOBAL read_only = OFF;
"
4. 其余从库执行 CHANGE MASTER 指向新主库，重启同步
5. 修改业务配置/中间件路由，切换到新主库
6. 旧主库修复后，作为从库重新加入集群

场景 C：数据误删/损坏，备份兜底恢复
恢复优先级：先从库延迟回放 → 再备份+binlog 时间点恢复
标准流程：
1. 锁定现场，保留当前所有 binlog，避免覆盖
2. 恢复最近一次全量备份到临时实例
3. 提取故障时间点之前的 binlog，重放到临时实例
4. 验证数据无误后，回切到生产环境
5. 复盘操作流程，增加权限管控/操作审计

核心速记
1. 连接爆满：先调大上限、杀空闲连接，再查连接池与慢 SQL
2. 死锁卡慢：innodb status 查死锁，杀长事务，拆大事务加索引
3. 磁盘告警：binlog 用 purge 清理，日志用 > 清空，禁止直接 rm
4. 主从故障：从库断了修同步，主库挂了选新主切换，最后靠备份兜底
5. 巡检核心：连接数、主从延迟、磁盘空间、慢 SQL 数量每日必查
```

2. Redis 缓存全栈运维


**⑤ 🎯 面试考点**：
- 常见故障？答：连接数爆（max_connections）、复制中断（位点/网络）、锁等待（行锁/表锁）、磁盘满。
- show processlist 看什么？答：当前连接状态（Sleep/Query/Sending data）、长事务、锁等待。
- 如何定位慢 SQL？答：slow log + explain 分析。

### 1）生产部署

**① 一句话本质**：Redis = 单线程内存 KV 库，生产部署关注编译/包安装 + 持久化配置 + maxmemory 上限 + 安全（bind/保护模式）。


- 单机、多实例、端口配置
- 安全加固：密码、禁止外网、改名高危命令

``` md
Redis 生产部署运维手册
1. YUM 单机部署 | 2. 多实例多端口部署 | 3. 生产安全加固

一、YUM 单机部署（CentOS 生产标准方案）
1. 安装 epel 源与 Redis 服务
yum install -y epel-release
yum install -y redis

2. 默认目录结构
/etc/redis.conf          # 主配置文件
/usr/bin/redis-server    # 服务端二进制程序
/usr/bin/redis-cli       # 命令行客户端
/var/lib/redis/          # 默认数据目录（存放 RDB/AOF 持久化文件）
/var/log/redis/redis.log # 默认运行日志
/usr/lib/systemd/system/redis.service # systemd 服务管理文件

3. 启动与开机自启
systemctl start redis
systemctl enable redis

4. 基础验证
redis-cli ping
返回 PONG 表示服务运行正常

二、多实例部署（6379/6380 多端口业务隔离）
适用场景：多业务缓存隔离、测试/生产环境复用服务器、避免单实例故障影响全业务
1. 目录规划（每个实例独立数据、日志、配置）
mkdir -p /etc/redis/
mkdir -p /var/lib/redis/6379
mkdir -p /var/lib/redis/6380
mkdir -p /var/log/redis/
chown -R redis: redis /var/lib/redis /var/log/redis

2. 6379 实例基础配置
cat > /etc/redis/6379.conf <<'EOF'
端口配置
port 6379
后台守护进程运行
daemonize yes
pidfile /var/run/redis_6379.pid

日志与数据目录
logfile /var/log/redis/6379.log
dir /var/lib/redis/6379

RDB 持久化基础配置（后续章节详解）
save 900 1
save 300 10
save 60 10000
rdbcompression yes

内存上限与淘汰策略（生产必配，防止 OOM）
maxmemory 2G
maxmemory-policy allkeys-lru
EOF

3. 6380 实例配置（仅修改端口、PID、日志、数据目录，其余参数对齐）
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

4. systemd 服务文件（6379 示例，6380 替换端口即可）
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

5. 重载服务并启动多实例
systemctl daemon-reload
systemctl start redis-6379 redis-6380
systemctl enable redis-6379 redis-6380

6. 多实例验证
redis-cli -p 6379 ping
redis-cli -p 6380 ping

三、生产安全加固（硬性合规要求）
核心原则：最小暴露面 + 权限管控 + 高危操作拦截
以下配置追加到所有实例配置文件中
cat >> /etc/redis/6379.conf <<'EOF'
1. 禁止外网访问
仅绑定本地回环+内网 IP，生产严禁 bind 0.0.0.0
注意：bind 只支持具体 IP，不支持 CIDR/掩码写法；限制网段需结合防火墙
bind 127.0.0.1 192.168.1.10

2. 密码强认证
客户端连接必须先 AUTH 校验，生产禁止无密码运行
密码规范：大小写+数字+特殊字符，长度 ≥16 位
requirepass Redis@Prod_20260714

3. 高危命令重命名/禁用
防止误操作清空数据、未授权修改配置、全库遍历阻塞服务
FLUSHALL/FLUSHDB：清空全库/单库，生产事故高频诱因
CONFIG：可修改运行时核心参数，风险极高
KEYS：全库遍历 key，大库会导致 Redis 阻塞雪崩
SHUTDOWN：直接关闭服务

重命名为自定义随机串，仅运维掌握
rename-command FLUSHALL "redis_op_flushall_9x2k7m"
rename-command FLUSHDB "redis_op_flushdb_4z8w1h"
rename-command CONFIG "redis_op_config_6j9d3q"
rename-command KEYS "redis_op_keys_5v2n7s"
rename-command SHUTDOWN "redis_op_shutdown_8r4t6y"

完全禁用命令示例（设为空字符串）
rename-command FLUSHALL ""
EOF

补充系统层加固
1. 防火墙限制：仅内网网段可访问 Redis 端口
firewall-cmd --permanent --add-rich-rule="rule family ='ipv4' source address ='192.168.1.0/24' port protocol ='tcp' port ='6379' accept"
firewall-cmd --reload

2. 数据目录权限收敛，仅 redis 用户可读写
chmod 700 /var/lib/redis/6379
chown -R redis: redis /var/lib/redis/6379

3. 公网服务器严禁映射 6379 默认端口，避免被扫描爆破

核心速记
1. 部署选型：单业务单机部署，多业务隔离用多实例
2. 安全三板斧：绑定内网、设置强密码、重命名高危命令
3. 生产红线：禁止 0.0.0.0 监听、禁止无密码运行、禁止 root 账号启动
4. 多实例核心：独立端口、独立数据目录、独立日志、独立服务管理
```


**⑤ 🎯 面试考点**：
- 单线程为何还这么快？答：纯内存、IO 多路复用（epoll）、无锁竞争、避免上下文切换。
- maxmemory 策略？答：达上限触发淘汰（见内存管理），防 OOM。
- protected-mode/bind 安全作用？答：bind 限监听 IP、protected-mode 防外网未授权访问、设 requirepass。

### 2）持久化机制（必考）

**① 一句话本质**：Redis 持久化 = RDB 快照 + AOF 日志，二者权衡性能与数据安全，生产常混合使用。


- RDB 快照持久化：原理、触发机制、优缺点

- AOF 日志持久化：重写机制、三种刷盘策略

- 生产持久化组合方案

``` md
Redis 持久化机制（运维/面试核心必考）
1. RDB 快照持久化 | 2. AOF 日志持久化 + 重写机制 + 三种刷盘策略
3. 生产标准组合方案：RDB+AOF 混合持久化

持久化核心作用
Redis 纯内存运行，断电/宕机内存数据全部丢失；
持久化将内存数据落地到磁盘，重启后自动加载恢复数据。

一、RDB 快照持久化
原理：在指定时间点，将内存中全量数据生成二进制压缩快照文件，保存到磁盘
核心：保存的是「数据结果」，不是操作过程

1. 触发机制
【自动触发】按配置的保存规则自动执行
【手动触发】执行 SAVE / BGSAVE 命令
SAVE：主线程执行快照，全程阻塞 Redis，生产禁用
BGSAVE：fork 子进程后台生成快照，主线程不阻塞，生产默认方式

2. 生产配置（追加到 redis.conf）
cat >> /etc/redis/6379.conf <<'EOF'
RDB 基础配置
开启 RDB 快照，配置保存规则：save 秒数 写入次数
900 秒内至少 1 次写入 → 触发快照
save 900 1
300 秒内至少 10 次写入 → 触发快照
save 300 10
60 秒内至少 10000 次写入 → 触发快照
save 60 10000

RDB 快照文件名
dbfilename dump.rdb
快照文件保存目录（AOF 文件也存在此目录）
dir /var/lib/redis/6379

开启 RDB 文件压缩，节省磁盘空间，轻微消耗 CPU
rdbcompression yes
开启 RDB 文件校验，恢复时检查文件完整性
rdbchecksum yes

快照生成失败时，禁止 Redis 继续写入，避免数据不一致
stop-writes-on-bgsave-error yes
EOF

3. RDB 优缺点
✅ 优点：
1. 二进制压缩文件，体积小，适合全量备份、异地灾备
2. 恢复速度极快，直接加载数据到内存，远快于 AOF
3. BGSAVE 后台执行，不阻塞主线程，对业务影响小
❌ 缺点：
1. 间隔性快照，宕机会丢失最后一次快照之后的所有数据（分钟级丢失）
2. fork 子进程时，大数据量场景会有短暂阻塞，且消耗额外内存
3. 频繁写入小数据场景，快照触发频繁，IO 开销大

二、AOF 日志持久化
原理：以日志形式记录每一条写命令，追加方式写入文件；
重启时重放所有写命令，恢复完整数据。
核心：保存的是「写操作过程」，不是数据结果

1. 三种刷盘策略（appendfsync，生产核心选型）
决定写命令何时从内存缓冲区刷到磁盘，是数据安全性与性能的平衡
#
① always：每执行一条写命令，立即刷盘
✅ 安全性最高，最多丢失一条命令数据
❌ 性能最差，每条写都有磁盘 IO，吞吐量极低
#
② everysec：每秒刷盘一次（生产默认标准）
✅ 性能与安全平衡，最多丢失 1 秒数据，业务可接受
❌ 极端宕机场景丢失 1 秒内写入的数据
#
③ no：完全交给操作系统决定刷盘时机（通常 30 秒左右）
✅ 性能最高
❌ 安全性最差，宕机丢失数据最多，生产不推荐

2. AOF 重写机制
背景：AOF 采用追加写入，文件会越来越大；且存在大量冗余命令（如对同一个 key 反复修改）
原理：fork 子进程，将内存中当前全量数据逆转为最小写命令集，生成新的 AOF 文件，替换旧文件
核心：压缩 AOF 文件体积，加快数据恢复速度
触发方式：
手动触发：BGREWRITEAOF 命令
自动触发：配置阈值，文件大小增长率和绝对大小同时满足时自动重写

3. 生产配置
cat >> /etc/redis/6379.conf <<'EOF'
AOF 基础配置
开启 AOF 持久化
appendonly yes
AOF 日志文件名
appendfilename "appendonly.aof"

核心：刷盘策略，生产标准 everysec
appendfsync everysec
appendfsync always
appendfsync no

AOF 重写期间，是否暂停刷盘，避免 IO 冲突导致阻塞
no-appendfsync-on-rewrite yes

AOF 自动重写配置
AOF 文件增长率达到 100%（比上一次重写后大一倍）时触发重写
auto-aof-rewrite-percentage 100
AOF 文件至少达到 64MB 才触发重写，避免小文件频繁重写
auto-aof-rewrite-min-size 64mb

AOF 文件末尾损坏时，启动时自动截断损坏部分，保证服务可启动
aof-load-truncated yes
EOF

4. AOF 优缺点
✅ 优点：
1. 数据安全性高，everysec 模式最多丢失 1 秒数据
2. 追加写入，无磁盘随机 IO，写入性能好
3. 日志文件可读，可手动编辑、提取指定命令做数据恢复
❌ 缺点：
1. 相同数据集，AOF 文件体积远大于 RDB
2. 恢复速度慢，需要逐条重放所有命令
3. 存在重写开销，大数据量重写时有短暂性能影响

三、生产标准组合方案：RDB + AOF 混合持久化
Redis 4.0+ 支持，兼顾两者优势，是当前生产默认推荐方案
原理：
AOF 重写时，先将当前内存全量数据以 RDB 格式写入 AOF 文件开头，
后续的写命令继续以 AOF 格式追加到文件末尾。
恢复时：先加载开头的 RDB 全量数据（速度快），再重放后面的增量 AOF 命令（数据全）。

生产配置
cat >> /etc/redis/6379.conf <<'EOF'
开启 RDB-AOF 混合持久化
aof-use-rdb-preamble yes
EOF

方案优势
1. 兼顾恢复速度：全量部分用 RDB，恢复速度远超纯 AOF
2. 兼顾数据安全：增量部分用 AOF，最多丢失 1 秒数据
3. 文件体积更优：比纯 AOF 小很多，减少磁盘占用

场景选型建议
1. 纯缓存场景（允许数据全丢，重启从数据库重建）：仅开 RDB 即可
2. 通用业务缓存（可接受秒级数据丢失）：混合持久化（RDB+AOF everysec）
3. 高可靠数据场景（不能丢数据）：AOF always + 定期 RDB 全量备份
4. 禁止方案：生产环境不允许完全关闭持久化（宕机全量数据丢失）

核心速记
1. RDB 存数据快照，体积小恢复快，丢数据多；AOF 存写命令，数据全恢复慢
2. AOF 三策略：always 最安全慢，everysec 平衡生产用，no 最快丢得多
3. AOF 重写：压缩文件体积，减少恢复时间，后台执行不阻塞
4. 生产标配：混合持久化 + everysec 刷盘 + 定期 RDB 全量备份
```


**⑤ 🎯 面试考点**：
- RDB vs AOF 区别？答：RDB 定时快照（快、体积小、丢最后一次后数据）；AOF 记写命令（安全、文件大、恢复慢）。
- AOF 重写原理？答：压缩 AOF（去无效/重复命令），bgrewriteaof 生成最小集。
- 混合持久化？答：aof-use-rdb-preamble 让 AOF 头部为 RDB，兼顾速度与完整。

### 3）内存管理

**① 一句话本质**：Redis 内存管理 = maxmemory 上限 + 淘汰策略 + 碎片整理，防内存撑爆与浪费。


- 内存淘汰策略 8 种
- maxmemory 限制内存上限
- 大 key 发现、批量删除、内存溢出排查

``` md
Redis 内存管理 生产运维手册
1. maxmemory 内存上限配置 | 2. 8 种内存淘汰策略
3. 大 key 发现与安全删除 | 4. 内存溢出排查与优化

一、maxmemory 内存上限配置（生产必配，防止 OOM）
作用：限制 Redis 最大内存使用量，超过阈值触发淘汰策略，避免进程被系统 OOM 杀死
cat >> /etc/redis/6379.conf <<'EOF'
设置 Redis 最大可用内存，单位支持字节/K/M/G
生产配置原则：不超过服务器物理内存的 70%~80%，预留系统内存+fork 子进程开销
例如 8G 内存机器，建议设置为 5~6G
maxmemory 6G

内存淘汰策略（下文详细说明 8 种），生产通用缓存推荐 allkeys-lru
maxmemory-policy allkeys-lru

每次淘汰采样数量，数值越大淘汰越精准，但 CPU 开销越高，默认 5 足够
maxmemory-samples 5
EOF

运行时查看与临时调整
redis-cli -p 6379 -a 密码 CONFIG GET maxmemory
redis-cli -p 6379 -a 密码 CONFIG SET maxmemory 8G  # 临时调整，重启失效

二、8 种内存淘汰策略（必考核心）
分类规则：allkeys 针对所有键；volatile 仅针对设置了过期时间的键
【第一类：不淘汰策略（1 种）】
1. noeviction
规则：内存达到上限后，所有写请求直接返回错误，不淘汰任何数据
适用：数据不能丢、持久化存储场景，纯缓存不推荐，默认策略

【第二类：allkeys 全键淘汰（3 种）】
2. allkeys-lru  【生产通用缓存首选】
规则：在所有键中，淘汰最近最少使用（Least Recently Used）的键
适用：有明显冷热区分的业务缓存，保留热点数据，淘汰冷数据
3. allkeys-lfu  Redis4.0+新增
规则：在所有键中，淘汰访问频次最低（Least Frequently Used）的键
适用：访问频率差异大的场景，比 LRU 更精准判断数据热度
4. allkeys-random
规则：在所有键中随机淘汰
适用：所有 key 访问概率均等的场景，性能开销最小，但淘汰无差别

【第三类：volatile 过期键淘汰（4 种）】
5. volatile-lru
规则：仅在设置了过期时间的键中，淘汰最近最少使用的
适用：同时存在永久数据和过期缓存，不希望淘汰永久数据的场景
6. volatile-lfu  Redis4.0+新增
规则：仅在设置了过期时间的键中，淘汰访问频次最低的
7. volatile-random
规则：仅在设置了过期时间的键中随机淘汰
8. volatile-ttl
规则：仅在设置了过期时间的键中，优先淘汰马上就要过期的键
适用：希望优先清理快过期的数据，保留长期有效缓存

生产选型速记
✅ 纯缓存业务、冷热明显：allkeys-lru
✅ 访问频次差异大：allkeys-lfu
✅ 混合永久数据+过期缓存：volatile-lru
❌ 纯缓存不推荐：noeviction（容易导致业务写入全失败）

三、大 key 发现与安全删除（性能杀手，高频故障诱因）
大 key 定义：字符串 value 超过 10KB；集合/哈希/列表元素超过 1000 个或总大小超过 1MB
危害：阻塞 Redis、网络 IO 飙升、内存碎片化、删除卡顿

1. 线上大 key 扫描（低峰期执行，避免影响业务）
方式 1：Redis 自带工具，遍历所有 key，输出各类型最大 key，低峰使用
redis-cli -p 6379 -a 密码 --bigkeys

方式 2：基于 RDB 文件离线分析（推荐，完全不影响线上业务）
安装分析工具
yum install -y python3-pip
pip3 install rdbtools
生成内存分析报告，找出 TOP 大 key
rdb -c memory /var/lib/redis/6379/dump.rdb --bytes 10240 -f /tmp/redis_bigkeys.csv
按内存大小排序，定位 TOP10 大 key
sort -t, -k4 -nr /tmp/redis_bigkeys.csv | head -10

2. 大 key 安全删除（禁止直接 DEL，避免阻塞主线程）
方式 1：异步删除（Redis4.0+推荐，后台线程释放内存，不阻塞主线程）
redis-cli -p 6379 -a 密码 UNLINK 大 key 名称

方式 2：集合类大 key 分批删除（低版本兼容方案）
哈希大 key：hscan 分批获取字段，逐个 hdel 删除
列表大 key：ltrim 逐步截断
集合大 key：sscan 分批删除元素
示例：分批删除 hash 大 key
for i in {1..100}; do
  redis-cli -p 6379 -a 密码 HSCAN 大 hash_key $[i*100] COUNT 100
  # 对应执行 hdel 删除对应字段
done

四、内存溢出（OOM）排查与优化
现象：写入报错 OOM、淘汰频繁、业务响应超时、Redis 进程被系统杀死

第一步：核心内存指标排查
redis-cli -p 6379 -a 密码 INFO memory
关键字段解读：
used_memory：Redis 实际存储数据占用的内存（字节）
used_memory_rss：操作系统视角的进程物理内存占用
mem_fragmentation_ratio：内存碎片率 = used_memory_rss / used_memory
1 < 碎片率 < 1.5：正常健康范围
碎片率 > 1.5：内存碎片严重，实际可用内存少，需整理
碎片率 < 1：部分数据被交换到 swap，性能急剧下降，必须优化
used_memory_peak：历史内存峰值，用于评估容量

第二步：淘汰情况排查
redis-cli -p 6379 -a 密码 INFO stats | grep evicted_keys
evicted_keys 数值持续增长 → 内存持续不足，频繁触发淘汰
业务表现：缓存命中率下降，数据库压力飙升

第三步：常见根因与优化方案
根因 1：大 key 过多，内存占用远超预期
优化：拆分大 key，大集合拆分为多个小 key，设置合理过期时间

根因 2：大量无过期时间的冷数据堆积，内存只增不减
优化：全量扫描无过期 key，清理无效冷数据，规范业务设置 TTL

根因 3：maxmemory 设置过小，业务增长快，容量不足
优化：评估业务增长，调大 maxmemory，或扩容 Redis 集群分片

根因 4：内存碎片严重
优化：Redis4.0+开启自动碎片整理
cat >> /etc/redis/6379.conf <<'EOF'
开启主动内存碎片整理
activedefrag yes
碎片率达到 10%开始整理
active-defrag-ignore-bytes 100mb
active-defrag-threshold-lower 10
碎片率达到 100%全力整理
active-defrag-threshold-upper 100
EOF
应急处理：低峰期执行内存整理（会短暂阻塞）
redis-cli -p 6379 -a 密码 MEMORY PURGE

根因 5：缓存击穿/雪崩，瞬间大量数据涌入撑满内存
优化：加互斥锁、降级限流、预热热点数据

核心速记
1. 内存必设上限 maxmemory，防止 OOM 杀进程
2. 8 种淘汰策略：全键 3 种+过期 4 种+不淘汰 1 种，缓存首选 allkeys-lru
3. 大 key 是性能杀手，--bigkeys/rdb 工具排查，UNLINK 异步删除
4. 内存告警先看碎片率、淘汰数、大 key，再评估扩容与数据清理
```


**⑤ 🎯 面试考点**：
- 8 种淘汰策略？答：noeviction、allkeys-lru/lfu、volatile-lru/lfu、allkeys-random、volatile-random、volatile-ttl。
- allkeys-lru vs volatile-lru？答：allkeys 对所有 key；volatile 只对设了 ttl 的 key；lru=最近最少、lfu=最不常用。
- 内存碎片率？答：mem_fragmentation_ratio=used_memory_rss/used_memory；>1.5 碎片多，可 activedefrag。

### 4）高可用架构

**① 一句话本质**：Redis 高可用 = 主从 + 哨兵（自动故障转移）+ Cluster（分片），按规模选型。


- 主从复制部署、同步原理
- Sentinel 哨兵高可用（自动故障转移、主从切换）
- Cluster 集群架构认知、分片槽位

``` md
Redis 高可用架构全栈
1. 主从复制：数据冗余+读写分离基础
2. Sentinel 哨兵：主从自动故障转移，解决主库单点
3. Cluster 集群：水平分片扩容，解决单节点容量/性能瓶颈

架构层级定位
主从复制 → 数据备份，无自动故障恢复
哨兵 → 基于主从，实现主库自动切换，高可用
集群 → 去中心化分片，支撑 TB 级数据+十万级并发

一、主从复制架构（基础必备）
1. 同步核心原理
角色：1 个 Master 主库（读写） + N 个 Slave 从库（只读）
同步流程：
① 初次全量同步：从库发起同步 → 主库生成 RDB 快照 → 发送给从库加载 → 主库将期间增量命令发给从库
② 后续增量同步：主库持续将写命令异步推送给从库，从库回放保持数据一致
本质：异步复制，存在毫秒~秒级延迟；从库默认只读，不接受写入

2. 生产部署配置
主库（Master 6379）无需特殊配置，确保开启持久化、设置密码即可
从库（Slave 6380）核心配置
cat > /etc/redis/6380.conf <<'EOF'
port 6380
daemonize yes
pidfile /var/run/redis_6380.pid
dir /var/lib/redis/6380
logfile /var/log/redis/6380.log

密码认证（主库开启密码时，从库必须配置）
masterauth Redis@Prod_20260714
指定主库 IP 与端口，建立主从关系
replicaof 192.168.1.10 6379

从库只读模式（默认开启，防止业务误写从库）
replica-read-only yes
主从断开重连后能否增量补，取决于主库复制缓冲区 backlog（断线时间落在 backlog 内才能增量）
复制缓冲区大小，大写入场景调大，减少全量同步概率
repl-backlog-size 64mb
全量同步传输方式：no 主库先落盘再传 RDB（默认）；yes 不落盘直接网络流式传，磁盘压力小
repl-diskless-sync no

内存与持久化对齐主库
maxmemory 2G
maxmemory-policy allkeys-lru
appendonly yes
appendfsync everysec
EOF

3. 启动与验证
systemctl start redis-6380
主从状态校验
redis-cli -p 6380 -a Redis@Prod_20260714 INFO replication
核心标志：
role: slave
master_link_status: up  主从连接正常
master_sync_in_progress: 0  同步完成

主库查看从节点
redis-cli -p 6379 -a Redis@Prod_20260714 INFO replication
输出 connected_slaves: 1 表示从库已接入

4. 主从优缺点
✅ 优点：数据冗余备份、读写分离分摊读压力、架构简单
❌ 缺点：主库单点故障，需手动切换；无法解决单节点内存容量瓶颈

二、Sentinel 哨兵高可用（中小规模生产标准）
1. 核心功能
① 监控：持续检测主、从节点健康状态
② 自动故障转移：主库宕机后，哨兵集群投票选举新主库，自动切换
③ 通知：故障切换后通知客户端新主库地址
④ 配置中心：客户端连接哨兵获取主库地址，无需硬编码 IP

2. 架构规范
哨兵节点必须 ≥3 个，且分布在不同服务器；
故障判定需过半哨兵同意（quorum），防止脑裂误切换；
典型架构：3 台哨兵 + 1 主 2 从，生产最小高可用配置。

3. 三哨兵部署配置（端口 26379/26380/26381，配置逻辑一致）
cat > /etc/redis/sentinel-26379.conf <<'EOF'
哨兵端口
port 26379
daemonize yes
pidfile /var/run/redis-sentinel-26379.pid
logfile /var/log/redis/sentinel-26379.log

监控主库：自定义集群名 + 主库 IP 端口 + quorum 投票数
2 表示 2 个哨兵认为主库故障，就触发切换（3 哨兵设 2，过半原则）
sentinel monitor mymaster 192.168.1.10 6379 2

主库密码（主库开启密码时必须配置）
sentinel auth-pass mymaster Redis@Prod_20260714

主库心跳超时时间（毫秒），超时判定为主观下线
sentinel down-after-milliseconds mymaster 30000

故障转移后，允许多少个从库同时同步新主库，数值越小切换越慢，业务影响越小
sentinel parallel-syncs mymaster 1

故障转移超时时间
sentinel failover-timeout mymaster 180000
EOF

26380/26381 仅修改端口、PID、日志文件，其余配置完全一致

4. 启动哨兵集群
redis-sentinel /etc/redis/sentinel-26379.conf
redis-sentinel /etc/redis/sentinel-26380.conf
redis-sentinel /etc/redis/sentinel-26381.conf

5. 状态验证
查看当前监控的主库信息
redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster
查看哨兵集群所有节点
redis-cli -p 26379 SENTINEL sentinels mymaster
查看从库列表
redis-cli -p 26379 SENTINEL slaves mymaster

6. 自动故障转移流程
1. 单个哨兵检测到主库超时 → 标记为主观下线（SDOWN）
2. 多个哨兵确认故障，达到 quorum 阈值 → 标记为客观下线（ODOWN）
3. 哨兵之间投票选举领头哨兵，负责执行切换
4. 从所有从库中选出数据最新的一台，提升为新主库
5. 其余从库指向新主库重新同步
6. 旧主库恢复后，自动变为新主库的从库

三、Redis Cluster 集群架构（大规模生产，分片扩容）
1. 核心设计：哈希槽分片
① 全集群共 16384 个哈希槽（Hash Slot），是数据分片的最小单位
② 每个 Key 通过 CRC16(key) mod 16384 计算出所属槽位，路由到对应节点
③ 每个主节点负责一部分槽位，例如 3 主节点：
节点 1：0~5460
节点 2：5461~10922
节点 3：10923~16383
④ 去中心化：无中心节点，任意节点都可接收请求，非自身槽位返回重定向（MOVED）

2. 高可用架构
每个主节点配备 1~N 个从节点；
主节点宕机时，集群自动将其从节点提升为主节点，保证分片可用；
最小生产集群：3 主 3 从（每个主 1 个从），共 6 个节点。

3. 核心特点
✅ 水平扩容：新增主节点，自动迁移槽位，线性提升容量与并发
✅ 无单点故障：去中心化，单节点故障不影响全集群
✅ 数据分片：解决单 Redis 内存上限，支撑 TB 级数据
❌ 限制：
不支持跨节点事务、多键操作（如 MSET/MGET 跨槽位报错）
批量操作需保证 key 在同一槽位（可使用{hash_tag}强制同槽）
运维复杂度高于哨兵架构

4. 集群节点基础配置模板（以 7001 节点为例）
cat > /etc/redis/cluster-7001.conf <<'EOF'
port 7001
daemonize yes
pidfile /var/run/redis-cluster-7001.pid
dir /var/lib/redis/cluster-7001
logfile /var/log/redis/cluster-7001.log

开启集群模式
cluster-enabled yes
集群节点信息文件，自动生成
cluster-config-file nodes-7001.conf
节点心跳超时时间，超时判定为故障
cluster-node-timeout 15000
集群槽位覆盖率要求，1 表示所有槽位都可用才对外提供服务
cluster-require-full-coverage yes

密码认证（集群所有节点密码必须一致）
requirepass Redis@Cluster_2026
masterauth Redis@Cluster_2026

内存与持久化
maxmemory 4G
maxmemory-policy allkeys-lru
appendonly yes
appendfsync everysec
EOF

5. 集群创建命令（Redis5.0+ 原生支持）
所有节点启动后，一键创建 3 主 3 从集群
redis-cli -a Redis@Cluster_2026 --cluster create \
  192.168.1.10:7001 192.168.1.11:7002 192.168.1.12:7003 \
  192.168.1.13:7004 192.168.1.14:7005 192.168.1.15:7006 \
cluster-replicas 1
cluster-replicas 1 表示每个主节点配 1 个从节点

6. 常用集群运维命令
查看集群状态
redis-cli -c -p 7001 -a Redis@Cluster_2026 CLUSTER INFO
查看节点列表与槽位分配
redis-cli -c -p 7001 -a Redis@Cluster_2026 CLUSTER NODES
c 参数：开启集群重定向模式，自动跳转至目标节点

核心速记
1. 主从：数据备份+读写分离，主库单点，手动切换
2. 哨兵：基于主从，自动故障切换，中小业务首选高可用方案
3. 集群：16384 哈希槽分片，去中心化，大流量大数据场景用
4. 选型：单节点内存足够用哨兵；单节点装不下、并发超高用集群
5. 硬性规范：哨兵/集群节点必须跨物理机，避免单机故障导致整体失效
```


**⑤ 🎯 面试考点**：
- 哨兵原理？答：监控+自动故障转移+通知；quorum 判定主观/客观下线，选新主。
- Cluster 16384 slot？答：数据按 key 哈希槽分片到节点，扩缩容迁移槽。
- 脑裂危害？答：网络分区旧主仍收写，恢复后数据冲突；min-replicas-to-write 防孤主写。

### 5）常见故障排查

**① 一句话本质**：Redis 故障排查 = 慢查询/内存暴涨/连接打满/脑裂，靠 info、慢日志、monitor 定位。


- 缓存雪崩、缓存击穿、缓存穿透原理
- 连接数打满、客户端超时、阻塞问题

``` md
Redis 常见故障排查 生产运维手册
一、业务层经典问题：缓存穿透 / 缓存击穿 / 缓存雪崩
二、运维层故障：连接数打满 / 客户端超时 / 服务阻塞

一、业务层三大经典缓存故障（原理+现象+解决方案）

故障 1：缓存穿透
原理：查询一条数据库和缓存中都不存在的数据，请求每次都穿透缓存直接打到数据库
核心特征：缓存永远不命中，恶意攻击/非法参数最容易触发
典型现象
1. 缓存命中率骤降，数据库 QPS 飙升，数据库压力突增
2. 请求的都是不存在的 ID/非法参数，缓存中无对应 key
3. 严重时导致数据库被打挂

核心根因
1. 业务层未做参数校验，非法 ID 直接透传到数据库
2. 空结果没有缓存，每次不存在的查询都走数据库
3. 恶意攻击：用大量不存在的 key 暴力请求

解决方案
方案 1：缓存空值（最简单通用）
查询结果为空时，也在 Redis 中缓存一个空值，设置较短过期时间（如 30 秒）
优点：实现简单；缺点：占用少量内存，可能存在短暂数据不一致
方案 2：布隆过滤器（Bloom Filter）
全量合法 key 预先存入布隆过滤器，请求先过过滤器，不存在直接返回
优点：内存占用极小，拦截效率高；缺点：存在极小误判率，不支持删除
方案 3：入口层参数校验
接口层增加合法性校验，过滤明显非法参数（如 ID 为负数、格式错误）

故障 2：缓存击穿
原理：某一个热点 key 突然过期失效，瞬间大量并发请求全部打到数据库
核心特征：单个热点 key 失效，数据库瞬时压力暴增，区别于雪崩的大面积失效
典型现象
1. 某个热点商品/活动页面瞬间超时，数据库 QPS 突增后又快速回落
2. 刚好对应热点 key 的过期时间点
3. 其他 key 正常，仅单个热点数据对应接口异常

核心根因
1. 超高访问量的热点 key 设置了过期时间，到期瞬间并发全部击穿
2. 没有做并发控制，上千个请求同时去查数据库并回写缓存

解决方案
方案 1：互斥锁（分布式锁）
缓存失效时，只允许第一个请求去查数据库并回写缓存，其余请求等待重试
优点：实现简单，数据一致性好；缺点：有短暂等待，吞吐量略降
方案 2：热点数据永不过期
物理层面不设过期时间，后台异步线程定时更新缓存
适用：秒杀、热门商品等极端热点数据
方案 3：缓存预热
活动/大促前，提前将热点数据加载到缓存中，设置合理过期时间

故障 3：缓存雪崩
原理：大面积缓存同时失效，或 Redis 整体宕机，所有请求全部冲击数据库
核心特征：全量/大面积缓存不可用，数据库压力雪崩式增长，极易导致数据库宕机
两种典型场景
场景 A：集中过期型雪崩
大量 key 设置了相同的过期时间，同一时间集体失效，流量全部打向数据库
场景 B：故障型雪崩
Redis 主库/集群宕机，缓存完全不可用，所有请求穿透到数据库

解决方案
针对集中过期：
1. 过期时间加随机偏移量，打散失效时间
例如：基础过期时间 1 小时 + 0~300 秒随机值，避免同时过期
2. 分级缓存：一级内存缓存 + 二级 Redis 缓存，分层失效
针对 Redis 故障：
1. 高可用架构：哨兵/集群模式，自动故障切换，减少宕机时间
2. 服务降级与熔断：
Redis 不可用时，业务接口降级，部分非核心接口直接返回，保护数据库
3. 本地缓存兜底：应用层本地缓存部分核心热点数据，顶过切换间隙
4. 限流：入口层限制数据库访问 QPS，避免数据库被打垮

二、运维层常见故障排查与处理

故障 1：连接数打满，客户端无法连接
现象：新连接报错 max number of clients reached，业务连接超时
1. 排查命令
查看当前连接数、最大连接数配置
redis-cli -p 6379 -a 密码 INFO clients
关键字段：
connected_clients：当前已连接客户端数量
maxclients：最大连接数上限

查看所有客户端连接详情，定位异常来源
redis-cli -p 6379 -a 密码 CLIENT LIST
重点看：空闲时间 idle、连接 IP、连接数量分布

2. 应急处理
临时调大最大连接数（先救业务）
redis-cli -p 6379 -a 密码 CONFIG SET maxclients 10000

批量杀掉长时间空闲的无效连接
杀掉空闲超过 300 秒的连接
redis-cli -p 6379 -a 密码 CLIENT KILL TYPE normal idle 300

3. 根因与根治
根因 1：应用端连接池配置过大，多实例部署后总连接数超上限
优化：合理设置连接池大小，单应用连接数控制在合理范围
根因 2：短连接风暴，业务频繁创建销毁连接
优化：改用长连接池，复用连接
根因 3：客户端异常断开，连接未正常释放，堆积大量空闲连接
优化：配置 Redis 超时自动断开空闲连接
cat >> /etc/redis/6379.conf <<'EOF'
客户端空闲 N 秒后自动断开，0 表示不限制
timeout 300
EOF

故障 2：客户端请求超时，响应缓慢
现象：业务接口 Redis 操作超时，延迟飙升，偶发报错
排查步骤
1. 先查慢日志，定位是否有慢命令阻塞
redis-cli -p 6379 -a 密码 SLOWLOG GET 10
慢日志记录执行时间超过阈值的命令，默认阈值 10 毫秒
配置慢日志阈值：CONFIG SET slowlog-log-slower-than 10000 （单位微秒）

2. 检查是否存在大 key，大 key 读写都会阻塞
redis-cli -p 6379 -a 密码 --bigkeys

3. 检查持久化 fork 耗时，fork 期间主线程阻塞
redis-cli -p 6379 -a 密码 INFO stats | grep latest_fork_usec
单位微秒，数值越大阻塞时间越长，大内存实例更明显

4. 检查网络延迟
ping Redis 服务器 IP
telnet 服务器 IP 6379
跨机房、网络抖动都会导致客户端超时

常见根因
1. 慢命令：KEYS、FLUSHALL、大集合全量遍历等
2. 大 key：超大 string/集合读写，网络+内存拷贝耗时久
3. 持久化阻塞：AOF 重写、RDB 快照 fork 子进程阻塞
4. 主从切换：哨兵/集群切换期间，秒级不可用

优化方向
1. 禁用高危慢命令，用 SCAN 替代 KEYS
2. 拆分大 key，集合类分批操作
3. 合理设置持久化策略，避免高峰期触发重写
4. 客户端配置合理超时与重试机制

故障 3：Redis 整体阻塞，完全无响应
现象：所有命令都超时，Redis 进程存活但不响应请求
快速排查定位
1. 查看 Redis 运行状态，进程是否存在
ps aux | grep redis
2. 查看内存使用，是否触发 OOM
free -h
dmesg | grep oom
3. 查看磁盘 IO，AOF 刷盘是否打满磁盘
iotop
4. 查看日志，捕获异常信息
tail -f /var/log/redis/6379.log

常见阻塞根因
1. 执行了超慢命令：全库 KEYS、超大集合排序/聚合，主线程被占住
2. 内存满了+noeviction 策略，所有写入都阻塞报错
3. AOF 刷盘阻塞：磁盘 IO 打满，fsync 一直等待
4. 大内存实例 fork 子进程：生成 RDB/AOF 重写时，fork 耗时过长阻塞主线程
5. 内存交换：Redis 数据被系统换到 swap，读写性能暴跌

应急与优化
应急：
若慢命令阻塞：找到进程 ID，重启 Redis 实例（低峰操作）
若内存满：临时调大 maxmemory，清理大 key 冷数据
若 AOF 阻塞：临时关闭 AOF，业务恢复后再开启
根治：
1. 生产禁用 KEYS、FLUSHALL 等高危命令，或重命名
2. 合理设置 maxmemory 与淘汰策略，杜绝 OOM
3. 关闭系统 swap，防止 Redis 内存被交换
echo "vm.swappiness = 0" >> /etc/sysctl.conf
sysctl -p
4. 大内存实例优化持久化策略，减少 fork 频率

核心速记
1. 业务三剑客：
穿透：查不存在的数据 → 空缓存+布隆过滤器
击穿：单热点 key 过期 → 互斥锁+热点永不过期
雪崩：大面积失效/宕机 → 随机过期+高可用+降级限流
2. 连接爆满：先调上限、杀空闲连接，再优化连接池
3. 超时阻塞：先查慢日志与大 key，再看持久化 fork 与磁盘 IO
4. 运维底线：关闭 swap、设内存上限、重命名高危命令，从源头减少故障
```


**⑤ 🎯 面试考点**：
- 缓存雪崩/穿透/击穿区别与方案？答：穿透=查不存在 key（布隆/空值）；击穿=热点 key 过期瞬压（互斥/逻辑过期）；雪崩=大量 key 同过期（错峰 TTL/多级缓存）。
- bigkey 危害？答：大 value 删除阻塞、迁移慢、超时；用拆分/渐进删除（UNLINK）。

### 命令行下使用redis

**① 一句话本质**：redis-cli = 连接/增删查 + 实例管理命令，是日常运维最直接工具。


``` md
Redis 官方自带客户端 redis-cli 全教程
模块 1：redis-cli 登录/连接/认证全套命令
模块 2：全局通用 key 管理、运维监控命令
模块 3：5 大基础原生数据结构（全命令+示例+场景）
模块 4：3 大高级原生数据结构（Bitmap/HLL/Geo，Redis 自带无需插件）
模块 5：Lua 脚本、集群、生产避坑总结

一、redis-cli 客户端登录、连接、认证操作（所有生产必用）
1. 默认本地无密码登录 127.0.0.1:6379 数据库 0
redis-cli

2. 指定 IP、端口连接远程 Redis
h 指定主机 IP  -p 指定端口
redis-cli -h 192.168.1.10 -p 6379

3. 连接时直接携带密码登录（-a）
redis-cli -h 192.168.1.10 -p 6379 -a Redis@2026

4. 安全登录：先连服务，进入客户端再输密码 AUTH（推荐，密码不暴露进程列表）
redis-cli -h 192.168.1.10 -p 6379
进入交互界面执行认证
AUTH Redis@2026

5. 连接时直接指定数据库（0~15，默认 db0）-n
redis-cli -h 127.0.0.1 -p 6379 -n 1 -a 123456

6. Redis Cluster 集群连接加 -c 自动槽位重定向
redis-cli -c -h 192.168.1.10 -p 7001 -a 123456

7. URL 格式一键连接（redis://账号: 密码@IP: 端口/库）
redis-cli -u redis://admin: Redis@2026@127.0.0.1:6379/0

8. 退出客户端交互界面
exit
quit

9. 非交互模式：一行命令直接执行后退出（脚本批量使用）
redis-cli -a 123456 GET user:info:1001
redis-cli -a 123456 SET test 123

10. 连通性测试，返回 PONG 代表正常
redis-cli PING

二、全局通用命令（所有数据结构共用：key 操作、数据库、运维监控）
2.1 数据库切换、基础交互
SELECT 1          # 切换到 db1（0~15 共 16 个库）
DBSIZE            # 查看当前库 key 总数
FLUSHDB           # 清空当前数据库（生产禁用）
FLUSHALL          # 清空所有数据库（高危，生产重命名屏蔽）

2.2 Key 通用管理命令（全部数据结构通用）
SET key val           # 创建 key
GET key               # 查询 key 值
TYPE key              # 查看 key 对应的数据结构类型
EXISTS key            # 判断 key 是否存在，1 存在 0 不存在
DEL key1 key2         # 删除 key（阻塞大 key，4.0+推荐 UNLINK）
UNLINK key            # 异步删除大 key，后台释放内存，不阻塞主线程
EXPIRE key 3600       # 设置 key 过期时间 3600 秒
TTL key               # 查看剩余过期秒数，-1 永久，-2 已过期
PERSIST key           # 移除过期时间，永久保存
RENAME old new        # 重命名 key
KEYS user:*           # 模糊匹配所有 user 开头 key（生产禁用，阻塞）
SCAN 0 MATCH user:* COUNT 100  # 分批遍历 key，线上安全替代 KEYS

2.3 运维监控、故障排查命令
INFO                  # 全量服务状态（内存、连接、持久化、主从）
INFO memory           # 仅查看内存使用、碎片率
INFO replication      # 主从同步状态
INFO clients          # 当前客户端连接
CLIENT LIST           # 列出所有连接 IP、空闲时长
CLIENT KILL 192.168.1.5:51230  # 强制断开指定客户端
SLOWLOG GET 10        # 查询最近 10 条慢命令
MONITOR               # 实时打印所有执行命令（压测环境慎用）
CONFIG GET maxmemory  # 查询配置项
CONFIG SET maxmemory 8G  # 临时修改配置

2.4 持久化运维
BGSAVE                # 后台异步生成 RDB 快照（生产推荐）
SAVE                  # 同步阻塞生成 RDB，大内存禁用

三、五大基础原生数据结构（Redis2.0 全版本自带，开发核心）
3.1 String 字符串（最基础，二进制安全，最大 512MB）
适用：验证码、Token、计数器、库存、简单缓存
SET user:token:1001 abc123 EX 3600  # 写入+过期时间
GET user:token:1001
MSET k1 v1 k2 v2    # 批量写入
MGET k1 k2          # 批量读取
INCR article:view:99    # 原子自增 1（并发安全计数器）
INCRBY stock:goods:10 5 # 自增 5
DECR stock:goods:10     # 原子减 1（库存扣减）
STRLEN key         # 获取字符串长度
APPEND key suffix  # 字符串追加内容

3.2 Hash 哈希（key-field-value，适合对象存储）
适用：用户信息、商品属性，无需序列化 JSON，单字段更新
HSET user:info:1001 name "张三" age 25
HGET user:info:1001 name
HMSET user:info:1002 name "李四" phone 13800138000
HMGET user:info:1002 name phone
HGETALL user:info:1001  # 获取全部字段（大 hash 阻塞，禁止线上）
HKEYS user:info:1001    # 获取所有字段名
HVALS user:info:1001    # 获取所有字段值
HINCRBY user:info:1001 score 10  # 字段原子自增
HDEL user:info:1001 age  # 删除单个字段
HLEN user:info:1001     # 字段总数
HSCAN 0 MATCH user:* COUNT 50  # 分批遍历大 hash

3.3 List 列表（有序可重复，双向链表，头尾操作 O(1)）
适用：简易消息队列、时间线、栈
LPUSH msg: queue order001 order002  # 头部插入（左进）
RPUSH msg: queue order003           # 尾部插入（右进）
LPOP msg: queue      # 头部弹出
RPOP msg: queue      # 尾部弹出（FIFO 队列）
BLPOP msg: queue 10  # 阻塞弹出，10 秒超时无消息返回
LRANGE msg: queue 0 9  # 分页读取前 10 条，0 -1 代表全量（禁止大 list）
LLEN msg: queue       # 列表长度
LTRIM msg: queue 0 9  # 裁剪列表，只保留前 10 条（清理旧数据）
LINDEX msg: queue 0   # 获取指定下标元素

3.4 Set 集合（无序、元素唯一，哈希表实现）
适用：点赞、去重、共同好友、黑白名单
SADD article:like:99 user1001 user1002
SISMEMBER article:like:99 user1001  # 判断是否存在
SCARD article:like:99    # 集合元素总数（点赞数）
SMEMBERS article:like:99 # 取出全部元素（大 set 阻塞，禁用）
SSCAN 0 MATCH * COUNT 100 # 分批遍历大集合
SREM article:like:99 user1001 # 删除元素
SINTER user:friend:1001 user:friend:1002 # 交集（共同好友）
SUNION 集合 1 集合 2 # 并集
SDIFF 集合 1 集合 2  # 差集

3.5 ZSet 有序集合（唯一元素，带 score 权重自动排序）
适用：排行榜、热搜、优先级队列
ZADD hot: rank 1200 "Python 教程" 850 "Redis 实战"
ZINCRBY hot: rank 50 "Redis 实战" # 热度+50
ZREVRANGE hot: rank 0 2 WITHSCORES # 倒序 Top3（高分在前）
ZRANGE hot: rank 0 2 WITHSCORES    # 正序
ZREVRANK hot: rank "Redis 实战"     # 查询排名（从 0 开始）
ZCARD hot: rank                    # 元素总数
ZREM hot: rank "Python 教程"        # 删除元素
ZSCAN 0 COUNT 50                 # 分批遍历大 zset

四、三大高级原生数据结构（Redis 自带，无需额外模块）
4.1 Bitmap 位图（底层 String，Redis2.2+自带，1bit 存状态）
适用：签到、日活、用户在线状态，极度省内存
SETBIT sign:user:1001:2026 15 1  # 第 15 位设 1（当月 15 号签到）
GETBIT sign:user:1001:2026 15    # 查询当天是否签到
BITCOUNT sign:user:1001:2026     # 统计总签到天数（值为 1 的 bit 总数）
BITOP AND dau_2day dau0714 dau0715 # 位运算，统计两日留存

4.2 HyperLogLog(HLL) 基数统计（Redis2.8.9+原生）
适用：页面 UV、海量去重计数，固定 12KB 内存，误差 0.81%
PFADD uv:page:home user1001 user1002 user1003
PFCOUNT uv:page:home # 统计独立访客总数
PFMERGE uv: total uv:page:home uv:page:detail # 合并多页面 UV

4.3 Geo 地理位置（Redis3.2+原生，底层封装 ZSet）
适用：附近商家、LBS 距离计算
GEOADD geo: shop 116.397 39.908 shop001 # 添加经纬度点位
GEODIST geo: shop shop001 shop002 km # 两点距离，单位 km/m
GEORADIUS geo: shop 116.397 39.908 2 km WITHDIST ASC # 2 公里内商家按距离排序
GEOPOS geo: shop shop001 # 查询点位经纬度
ZREM geo: shop shop001 # Geo 无专属删除命令，底层 ZSet 删除

五、Lua 脚本通用命令（原子操作，所有数据结构通用）
直接执行 Lua 脚本，KEYS 传键，ARGV 传参数，单线程原子执行
EVAL "local s = tonumber(redis.call('GET', KEYS [1])); if s > 0 then return redis.call('DECR', KEYS [1]) else return -1 end" 1 stock:goods:10
预加载脚本 SHA1，减少网络传输
SCRIPT LOAD "lua 代码"
EVALSHA 脚本 SHA1 1 key 参数

六、核心总结&开发规范
1. redis-cli 登录要点：生产优先先连接再 AUTH，避免-a 明文密码暴露
2. 通用 key 禁忌：线上禁止 KEYS、HGETALL、SMEMBERS 全量遍历，改用 SCAN 系列
3. 8 种 Redis 原生自带数据结构：
基础 5 种：String / Hash / List / Set / ZSet
高级 3 种：Bitmap / HyperLogLog / Geo
4. 高级结构版本底线：
Bitmap ≥2.2 ；HLL≥2.8.9 ；Geo≥3.2
5. 生产删除大 key：统一使用 UNLINK，不使用 DEL 防止阻塞
6. 集群操作限制：多 key 命令(MGET/MSET/Lua)所有 key 必须同一 HashTag 槽位，否则报错
```

开发视角 Redis 核心学习路线


**⑤ 🎯 面试考点**：
- redis-cli 常用？答：ping/set/get/del/exists/expire/ttl/info/dbsize。
- info 子命令？答：memory（内存）、replication（主从）、persistence（持久化）、stats（命令统计）、clients。
- 为何禁用 keys *？答：阻塞单线程遍历全库，生产用 scan 替代。

### 5 种基础数据结构 + python 整合 + 缓存读写模式 + 分布式锁

**① 一句话本质**：Redis 5 种结构（string/hash/list/set/zset）+ Python 整合 + 缓存读写模式 + 分布式锁（set nx px）。


``` md
Redis 开发第一优先级 从零实战（Python 版）
完整覆盖：1. 5 种基础数据结构  2. Python Web 整合
3. Cache Aside 缓存读写模式  4. 分布式锁正确实现

0. 前置环境准备
依赖：本地/服务器已运行 Redis，Python 3.7+
安装 Python 官方 Redis 客户端 + Flask Web 框架
pip3 install redis flask

快速验证 Redis 连接
python3 -c "
import redis
r=redis.Redis(host ='127.0.0.1', port = 6379, decode_responses = True)
print('Redis 连接测试:', r.ping())
"
decode_responses=True：自动将 bytes 解码为字符串，开发阶段必加，避免编码问题
输出 True 表示环境正常，可继续后续实战

一、5 种基础数据结构实战（开发核心基本功）
核心原则：先选对数据结构，再写代码；避免大 key、全量遍历
cat > 01_basic_types.py <<'EOF'
import redis
r=redis.Redis(host ='127.0.0.1', port = 6379, decode_responses = True)

1. String 字符串类型
适用场景：验证码、登录 Token、计数器、库存、分布式 ID
本质：二进制安全，可存字符串/数字/二进制数据
print("==== = 1. String 实战 ==== =")

基础读写 + 过期时间（生产所有业务 key 必须加 TTL，防止冷数据堆积）
r.set('user:token:1001', 'abc123xyz789', ex = 3600)  # ex = 过期秒数
print("登录 Token:", r.get('user:token:1001'))

原子计数器：文章浏览量（incr 是原子操作，并发不会出错）
r.incr('article:views:99')          # 自增 1
r.incrby('article:views:99', 5)     # 自增 5
print("文章浏览量:", r.get('article:views:99'))

库存扣减（原子操作，避免超卖）
r.set('goods:stock:10', 100)
remain=r.decr('goods:stock:10')   # 原子减 1
print("扣减后剩余库存:", remain)

❌ 避坑：不要把大 JSON 对象全塞一个 String 变成大 key
❌ 避坑：不要用 get 取值 → 代码计算 → set 写回，非原子会并发超卖
✅ 正确：计数类直接用 incr/decr 原子命令

2. Hash 哈希类型
适用场景：用户信息、商品详情等对象属性存储
优势：比 JSON 序列化更省空间，支持单字段读写，不用全量修改
print("\n ==== = 2. Hash 实战 ==== =")

单字段写入用户信息
r.hset('user:info:1001', 'name', '张三')
r.hset('user:info:1001', 'age', 25)
r.hset('user:info:1001', 'phone', '13800138000')

读取单个字段
print("用户名:", r.hget('user:info:1001', 'name'))
读取全量字段
user_info=r.hgetall('user:info:1001')
print("用户全量信息:", user_info)
单字段原子自增
r.hincrby('user:info:1001', 'score', 10)
print("用户积分:", r.hget('user:info:1001', 'score'))

❌ 避坑：字段不要超过 1000 个，避免大 hash
❌ 避坑：禁止用 hgetall 遍历大 hash，会阻塞 Redis
✅ 正确：大 hash 用 hscan 分批遍历

3. List 列表类型
适用场景：简单消息队列、文章时间线、栈/队列结构
本质：双向链表，头尾操作极快，中间插入删除性能差
print("\n ==== = 3. List 实战 ==== =")

消息队列：左进右出（FIFO 先进先出）
r.lpush('msg: order_queue', 'order_001')
r.lpush('msg: order_queue', 'order_002')
r.lpush('msg: order_queue', 'order_003')

消费一条消息
msg=r.rpop('msg: order_queue')
print("消费订单消息:", msg)

时间线：最新内容排在最前面
r.lpush('user:timeline:1001', '发布了 Python 教程')
r.lpush('user:timeline:1001', '点赞了 Redis 实战文章')
分页取前 10 条
timeline=r.lrange('user:timeline:1001', 0, 9)
print("个人时间线:", timeline)

❌ 避坑：不要用 lrange 0 -1 全量读取大列表
❌ 避坑：不要在列表中间做插入删除
✅ 正确：只操作头尾，固定范围分页

4. Set 集合类型
适用场景：点赞、去重、共同好友、标签、黑白名单
特性：无序、不可重复，支持交/并/差集运算
print("\n ==== = 4. Set 实战 ==== =")

文章点赞：天然去重，同一个用户重复点赞不会计数
r.sadd('article:like:99', 'user_1001')
r.sadd('article:like:99', 'user_1002')
r.sadd('article:like:99', 'user_1003')

判断是否已点赞（幂等校验）
is_liked=r.sismember('article:like:99', 'user_1001')
print("用户 1001 是否已点赞:", bool(is_liked))

点赞总数
like_count=r.scard('article:like:99')
print("文章总点赞数:", like_count)

共同好友：两个用户的好友交集
r.sadd('user:friend:1001', 'a','b','c','d')
r.sadd('user:friend:1002', 'b','c','e','f')
common_friends=r.sinter('user:friend:1001', 'user:friend:1002')
print("两个用户共同好友:", common_friends)

❌ 避坑：元素过多不要用 smembers 全量取出，大集合会阻塞 Redis
✅ 正确：大集合用 sscan 分批遍历

5. ZSet 有序集合
适用场景：排行榜、热搜榜、优先级队列、范围查找
特性：元素不可重复，每个元素带 score 权重，按 score 自动排序
print("\n ==== = 5. ZSet 实战 ==== =")

热搜排行榜：score 为热度值
r.zadd('hot: search_rank', {'Python 入门': 1200, 'Redis 实战': 850, 'MySQL 优化': 2100})
r.zincrby('hot: search_rank', 50, 'Redis 实战')  # 热度 +50

Top3 热搜（倒序，从高到低，带分数）
top3=r.zrevrange('hot: search_rank', 0, 2, withscores = True)
print("热搜榜 Top3:", top3)

查询指定内容排名
rank=r.zrevrank('hot: search_rank', 'MySQL 优化')
print("MySQL 优化 排名第:", rank+1)  # 排名从 0 开始，+1 转为自然排名

❌ 避坑：不要全量取出大 zset；相同 score 排序不保证按时间
✅ 正确：按范围分页取，需要时间维度可把时间戳拼到 score 里
EOF

运行数据结构实战脚本
python3 01_basic_types.py

二、Python Web 整合 + Cache Aside 缓存读写模式
模式说明：旁路缓存模式，是业务开发最常用的缓存方案
读流程：先查缓存 → 命中返回 → 未命中查库 → 写入缓存再返回
写流程：先更新数据库 → 再删除缓存（不是更新缓存！）
cat > 02_cache_aside.py <<'EOF'
from flask import Flask, jsonify
import redis
import time

app=Flask(__name__)
Redis 连接初始化
cache=redis.Redis(host ='127.0.0.1', port = 6379, decode_responses = True)
模拟数据库（生产环境替换为 MySQL 等真实数据库）
mock_db={
    1001: {'id': 1001, 'name':'张三', 'age': 25},
    1002: {'id': 1002, 'name':'李四', 'age': 30}
}

读接口：标准 Cache Aside 读流程
@app.route('/user/<int:user_id>')
def get_user(user_id):
    cache_key=f'user:info:{user_id}'

    # 第一步：优先查询缓存
    user_cache=cache.get(cache_key)
    if user_cache is not None:
        if user_cache == '':
            return jsonify({"code": 1, "msg": "用户不存在"})
        print("[命中缓存] 直接返回")
        return jsonify({"code": 0, "data": user_cache, "from": "cache"})

    # 第二步：缓存未命中，查询数据库
    print("[缓存未命中] 查询数据库")
    time.sleep(0.1)  # 模拟数据库查询耗时
    user=mock_db.get(user_id)

    if not user:
        # 缓存穿透优化：空值也缓存，设置短过期时间，防止反复打数据库
        cache.setex(cache_key, 60, '')
        return jsonify({"code": 1, "msg": "用户不存在"})

    # 第三步：数据写入缓存，设置过期时间（兜底最终一致性）
    cache.setex(cache_key, 3600, str(user))
    return jsonify({"code": 0, "data": user, "from": "database"})

写接口：标准 Cache Aside 写流程
核心原则：先更新数据库，再删除缓存
为什么不更新缓存？并发场景下会出现脏数据，删除缓存更简单可靠
@app.route('/user/update', methods = ['POST'])
def update_user():
    user_id=1001
    new_age=26
    cache_key=f'user:info:{user_id}'

    # 第一步：更新数据库
    mock_db [user_id]['age'] = new_age
    print("[数据库] 更新完成")

    # 第二步：删除缓存（下次查询自动加载最新数据）
    cache.delete(cache_key)
    print("[缓存] 已删除")

    # ❌ 错误写法 1：先删缓存再更数据库 → 并发读会把旧数据写回缓存
    # ❌ 错误写法 2：更新完数据库直接更新缓存 → 并发写会导致脏数据
    # ✅ 进阶优化：延迟双删，解决极小概率脏数据
    # time.sleep(0.2)
    # cache.delete(cache_key)

    return jsonify({"code": 0, "msg": "更新成功"})

if __name__ == '__main__':
    app.run(port = 5000, debug = False)
EOF

启动 Web 服务（后台运行测试）
python3 02_cache_aside.py &
测试命令：
第一次读：curl http://127.0.0.1:5000/user/1001  → 走数据库
第二次读：curl http://127.0.0.1:5000/user/1001  → 命中缓存
更新写：curl -X POST http://127.0.0.1:5000/user/update
更新后第一次读：重新从数据库加载最新数据

三、分布式锁 从零正确实现
核心作用：分布式系统下控制共享资源并发访问，如库存扣减、防重复提交
正确三要素：1. 加锁原子性  2. 锁归属唯一  3. 释放原子性
cat > 03_distributed_lock.py <<'EOF'
import redis
import uuid
import time

r=redis.Redis(host ='127.0.0.1', port = 6379, decode_responses = True)

class RedisDistributedLock:
    def __init__(self, lock_key, expire_time = 10):
        self.lock_key = lock_key
        self.expire_time = expire_time  # 锁自动过期时间，防止服务宕机死锁
        self.lock_value = str(uuid.uuid4())  # 唯一标识，保证只能自己释放自己的锁

    # ==== ==== ==== ==== ==== ==== ==== ==== ==
    # 加锁：原子操作，set nx ex 一条命令完成
    # nx = key 不存在才设置成功（互斥性）
    # ex = 自动过期时间
    # ==== ==== ==== ==== ==== ==== ==== ==== ==
    def acquire(self):
        # 原子加锁：成功返回 True，失败返回 False
        result=r.set(self.lock_key, self.lock_value, nx = True, ex = self.expire_time)
        return result is not None

    # ==== ==== ==== ==== ==== ==== ==== ==== ==
    # 释放锁：Lua 脚本保证原子性（判断归属 + 删除）
    # 为什么不用 get + del？两步非原子，可能误删别人的锁
    # ==== ==== ==== ==== ==== ==== ==== ==== ==
    def release(self):
        # Lua 脚本：如果 key 的值等于自己的标识，才执行删除
        lua_script="" "
        if redis.call('get', KEYS [1]) == ARGV [1] then
            return redis.call('del', KEYS [1])
        else
            return 0
        end
        "" "
        # 注册并执行 Lua 脚本，KEYS [1] 是锁 key，ARGV [1] 是自己的唯一值
        unlock_script=r.register_script(lua_script)
        result=unlock_script(keys = [self.lock_key], args = [self.lock_value])
        return result == 1

实战测试：模拟库存扣减并发场景
def stock_deduct_test():
    # 创建锁对象，锁粒度：单个商品库存
    lock=RedisDistributedLock('lock:goods:10', expire_time = 5)

    # 尝试加锁
    if lock.acquire():
        print("[加锁成功] 执行库存扣减业务")
        try:
            # 业务逻辑：读取库存 → 判断 → 扣减
            stock=int(r.get('goods:stock:10') or 0)
            if stock > 0:
                r.decr('goods:stock:10')
                print(f "[扣减成功] 剩余库存: {stock-1}")
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

运行分布式锁测试
python3 03_distributed_lock.py

避坑红线（必须牢记）
❌ 错误 1：分开执行 set + expire → 中间宕机，锁永不过期，造成死锁
❌ 错误 2：锁 value 不唯一 → 线程 A 的锁过期了，线程 B 加了锁，线程 A 误删 B 的锁
❌ 错误 3：get 判断后 del 释放 → 两步非原子，判断完锁刚好过期，误删别人的锁
✅ 正确标准：set nx ex 原子加锁；唯一 value 标识归属；Lua 脚本原子释放

进阶问题说明
1. 锁续期：业务执行时间超过过期时间 → 启动守护线程，快过期时自动续期（看门狗机制）
2. 可重入：同一个线程多次加锁 → 记录加锁次数，释放时计数减一
3. 生产推荐：直接用成熟库 redlock-py，不建议业务自己造轮子
安装命令：pip3 install redlock-py

核心速记
1. 数据选型：计数用 String、对象用 Hash、队列用 List、去重用 Set、排序用 ZSet
2. 缓存模式：读先查缓存、未命中查库回写；写先更数据库、再删缓存
3. 分布式锁：原子加锁、唯一归属、原子释放、必设过期、finally 释放
4. 开发底线：所有 key 加过期时间、禁用全量遍历命令、避免大 key
```


**⑤ 🎯 面试考点**：
- zset 跳表？答：跳表实现，范围/排行榜 O(log n)，按 score 排序。
- 分布式锁？答：SET key val NX PX ttl 抢锁，Lua 释放；Redlock 多实例增强。
- 缓存穿透解决？答：布隆过滤器拦截不存在 key，或缓存空值。

### 三大缓存问题方案 + 典型业务场景实现 + 大 key / 热 key 避坑

**① 一句话本质**：三大缓存问题 = 穿透/击穿/雪崩 + 大 key/热 key 避坑，是缓存设计的必考题。


``` md
Redis 开发第二优先级 从零实战（Python 版）
完整覆盖： 1. 三大缓存问题代码级方案
2. 高频典型业务场景实现
3. 大 key / 热 key 避坑实战

前置依赖安装
pip3 install redis flask

一、三大缓存问题 代码级解决方案
穿透 / 击穿 / 雪崩 从原理到落地实现
cat > 01_cache_problems.py <<'EOF'
import redis
import time
import random
import uuid

r=redis.Redis(host ='127.0.0.1', port = 6379, decode_responses = True)
mock_db={}  # 模拟数据库

1. 缓存穿透
问题：查询数据库和缓存都不存在的数据，请求全部穿透到数据库
危害：恶意攻击可直接打垮数据库
方案 1：空值缓存（简单通用，90%场景够用）
方案 2：布隆过滤器（海量数据场景，拦截不存在的 key）
print("==== = 1. 缓存穿透解决方案 ==== =")

方案 1：空值缓存
def get_user_with_null_cache(user_id):
    cache_key=f'user:info:{user_id}'
    # 1. 查缓存
    cache_val=r.get(cache_key)
    if cache_val is not None:
        if cache_val == '':
            print("[空缓存命中] 直接返回，不查数据库")
            return None
        print("[缓存命中] 直接返回")
        return cache_val

    # 2. 缓存未命中，查数据库
    print("[缓存未命中] 查询数据库")
    user=mock_db.get(user_id)

    if not user:
        # 核心：空结果也写入缓存，设置较短过期时间
        # 既防止反复打数据库，又避免长期占用内存
        r.setex(cache_key, 60, '')  # 空值只存 60 秒
        print("[空值写入缓存] 60 秒内相同请求不再打库")
        return None

    # 3. 正常数据写入缓存
    r.setex(cache_key, 3600, str(user))
    return user

测试：连续查询不存在的用户
get_user_with_null_cache(9999)
get_user_with_null_cache(9999)

方案 2：布隆过滤器
原理：将所有合法 ID 预先存入过滤器，请求先过过滤器
特点：判断不存在 100%准确；判断存在有极小概率误判
生产推荐：使用 RedisBloom 模块，这里演示核心逻辑
class SimpleBloomFilter:
    def __init__(self, size = 10000):
        self.size = size
        self.bit_key = 'bloom: user_id'
        r.delete(self.bit_key)  # 演示用清空

    def _hash(self, value):
        # 简化版：多个哈希函数映射到不同位
        return hash(str(value)) % self.size

    def add(self, value):
        "" "将合法 ID 加入布隆过滤器" ""
        pos=self._hash(value)
        r.setbit(self.bit_key, pos, 1)

    def might_exist(self, value):
        "" "判断是否可能存在：False = 一定不存在；True = 可能存在" ""
        pos=self._hash(value)
        return r.getbit(self.bit_key, pos) == 1

初始化：预加载全量合法用户 ID
bloom=SimpleBloomFilter()
for uid in range(1, 1001):
    bloom.add(uid)  # 合法 ID 1~1000

def get_user_with_bloom(user_id):
    # 第一步：先过布隆过滤器，不存在直接返回
    if not bloom.might_exist(user_id):
        print("[布隆拦截] ID 不存在，直接拒绝，不打缓存和数据库")
        return None
    # 第二步：正常走缓存+数据库流程
    return get_user_with_null_cache(user_id)

测试：非法 ID 直接被拦截
get_user_with_bloom(99999)
get_user_with_bloom(500)

避坑：布隆过滤器不支持删除，数据变动频繁的场景慎用
生产建议：用 RedisBloom 官方模块，支持更多哈希函数、更低误判率

2. 缓存击穿
问题：单个热点 key 突然过期，瞬间大量并发全部打到数据库
特点：仅单个热点 key 失效，数据库瞬时压力暴增
方案 1：互斥锁（通用方案，只让一个请求查库回写）
方案 2：热点永不过期（极端热点场景，后台异步更新）
print("\n ==== = 2. 缓存击穿解决方案 ==== =")

方案 1：互斥锁方案
def get_hot_data_with_lock(goods_id):
    cache_key=f'goods:info:{goods_id}'
    lock_key=f'lock:goods:{goods_id}'

    # 1. 正常查缓存
    data=r.get(cache_key)
    if data:
        return data

    # 2. 缓存未命中，尝试加锁
    lock_value=str(uuid.uuid4())
    lock_ok=r.set(lock_key, lock_value, nx = True, ex = 3)

    if lock_ok:
        try:
            # 3. 拿到锁的线程查数据库并回写缓存
            print("[拿到锁] 查询数据库，回写缓存")
            time.sleep(0.2)  # 模拟数据库查询
            mock_data=f'商品{goods_id}详情'
            r.setex(cache_key, 3600, mock_data)
            return mock_data
        finally:
            # 释放锁
            if r.get(lock_key) == lock_value:
                r.delete(lock_key)
    else:
        # 4. 没拿到锁的线程，等待重试
        print("[未拿到锁] 等待 100ms 后重试")
        time.sleep(0.1)
        return get_hot_data_with_lock(goods_id)

方案 2：热点数据永不过期
原理：物理上不设过期时间，后台异步线程定时更新缓存
适用：秒杀商品、首页热点数据等极端热点场景
def update_hot_data_async(goods_id):
    "" "后台异步更新任务，定时执行" ""
    cache_key=f'goods:hot:{goods_id}'
    new_data=f'商品{goods_id}最新数据_{int(time.time())}'
    r.set(cache_key, new_data)  # 不设过期时间
    print(f "[后台更新] 热点数据已刷新")

def get_hot_data_forever(goods_id):
    "" "读接口：永远直接读缓存，不担心过期击穿" ""
    cache_key=f'goods:hot:{goods_id}'
    return r.get(cache_key)

3. 缓存雪崩
问题：大面积缓存同时失效，或 Redis 整体宕机，全量请求打数据库
方案 1：过期时间加随机偏移，打散失效点（预防集中过期型雪崩）
方案 2：本地二级缓存兜底，顶过 Redis 故障间隙
print("\n ==== = 3. 缓存雪崩解决方案 ==== =")

方案 1：随机过期打散
def set_cache_with_random_ttl(key, value, base_ttl = 3600):
    "" "基础过期时间 + 0~300 秒随机偏移，避免同时过期" ""
    random_ttl=base_ttl + random.randint(0, 300)
    r.setex(key, random_ttl, value)
    print(f "设置缓存 {key}，过期时间 {random_ttl} 秒")

批量设置缓存，过期时间全部打散
for i in range(10):
    set_cache_with_random_ttl(f'product:{i}', f'商品{i}数据')

方案 2：本地二级缓存兜底
一级：本地内存缓存（极快，容量小） 二级：Redis（容量大，共享）
Redis 故障时，降级到本地缓存，保护数据库
local_cache={}  # 生产用 LRU 字典 / cachetools 库

def get_data_with_multilevel(key):
    # 1. 先查本地缓存
    if key in local_cache:
        print("[本地缓存命中]")
        return local_cache [key]

    # 2. 再查 Redis，加异常捕获
    try:
        data=r.get(key)
        if data:
            print("[Redis 命中]，同步到本地缓存")
            local_cache [key] = data  # 同步到本地缓存
            return data
    except Exception as e:
        print(f "[Redis 故障] {e}，降级本地缓存")

    # 3. Redis 不可用或未命中，查数据库（限流保护，避免雪崩）
    print("[数据库查询]")
    data=f'数据库数据_{key}'
    local_cache [key] = data  # 写入本地缓存兜底
    return data

测试多级缓存
get_data_with_multilevel('product: 1')
get_data_with_multilevel('product: 1')

避坑：本地缓存要设置最大容量+过期时间，避免内存溢出
生产推荐：使用 cachetools 实现带 LRU 淘汰的本地缓存
EOF

运行三大缓存问题示例
python3 01_cache_problems.py

二、典型业务场景实战
覆盖开发最高频的 4 类场景：限流、幂等、签到、排行榜
cat > 02_business_scenarios.py <<'EOF'
import redis
import time
import uuid

r=redis.Redis(host ='127.0.0.1', port = 6379, decode_responses = True)

场景 1：接口限流（防刷、防恶意请求）
实现：固定窗口计数器，简单高效；进阶可用滑动窗口
print("==== = 场景 1：接口限流 ==== =")

def rate_limit(user_id, limit = 10, period = 60):
    "" "
    限制用户每分钟最多请求 10 次
    user_id: 用户标识
    limit: 周期内最大次数
    period: 周期秒数
    "" "
    key=f'rate:limit:{user_id}'
    count=r.incr(key)
    if count == 1:
        # 第一次访问，设置过期时间
        r.expire(key, period)

    if count > limit:
        print(f "[限流触发] 用户{user_id}第{count}次请求，已超限")
        return False
    else:
        print(f "[请求通过] 用户{user_id}第{count}次请求")
        return True

测试：连续请求 12 次
for i in range(12):
    rate_limit('user_1001')

进阶方案：滑动窗口限流（用 ZSet 实现，精度更高）
令牌桶限流（适合平滑流量），生产按需选型

场景 2：接口幂等性（防重复提交）
场景：订单提交、支付回调、表单重复提交
原理：先获取唯一幂等 token，提交时校验并删除 token，保证只执行一次
print("\n ==== = 场景 2：接口幂等校验 ==== =")

def generate_idempotent_token(user_id):
    "" "生成幂等 token，返回给前端，提交时携带" ""
    token=str(uuid.uuid4())
    key=f'idempotent:{user_id}:{token}'
    r.setex(key, 300, '1')  # 5 分钟有效期
    print(f "生成幂等 token: {token}")
    return token

def check_idempotent(user_id, token):
    "" "提交时校验：删除成功表示第一次提交，失败表示重复提交" ""
    key=f'idempotent:{user_id}:{token}'
    # 用 del 原子操作：存在则删除返回 1，不存在返回 0
    result=r.delete(key)
    if result == 1:
        print("[校验通过] 首次提交，执行业务逻辑")
        return True
    else:
        print("[重复提交] 校验失败，拒绝处理")
        return False

测试
token=generate_idempotent_token('user_1001')
check_idempotent('user_1001', token)
check_idempotent('user_1001', token)

场景 3：用户签到 + 连续签到统计
实现：Bitmap 位图，1bit 存一天签到状态，极省内存
亿级用户全年签到也只占十几 MB 内存
print("\n ==== = 场景 3：用户签到统计 ==== =")

def user_sign(user_id, date_str ='20260714'):
    "" "用户签到：key 按年分，offset 用一年中的第几天" ""
    day_of_year=int(time.strftime('%j', time.strptime(date_str, '%Y%m%d')))
    key=f'sign:user:{user_id}: 2026'
    r.setbit(key, day_of_year, 1)
    print(f "用户{user_id} {date_str} 签到成功")

def get_sign_count(user_id):
    "" "统计用户全年签到总天数" ""
    key=f'sign:user:{user_id}: 2026'
    total=r.bitcount(key)
    print(f "用户{user_id} 全年累计签到 {total} 天")
    return total

def check_signed(user_id, date_str ='20260714'):
    "" "检查某天是否签到" ""
    day_of_year=int(time.strftime('%j', time.strptime(date_str, '%Y%m%d')))
    key=f'sign:user:{user_id}: 2026'
    signed=r.getbit(key, day_of_year)
    print(f "用户{user_id} {date_str} 是否签到: {bool(signed)}")
    return bool(signed)

测试
user_sign(1001)
user_sign(1001, '20260713')
check_signed(1001)
get_sign_count(1001)

场景 4：商品销量排行榜
实现：ZSet 有序集合，score 为销量，自动排序
print("\n ==== = 场景 4：销量排行榜 ==== =")

def incr_sales(goods_name, num = 1):
    "" "商品销量增加" ""
    r.zincrby('rank: sales', num, goods_name)
    print(f "商品 {goods_name} 销量 +{num}")

def get_top_n(n = 5):
    "" "获取销量 TopN" ""
    top_list=r.zrevrange('rank: sales', 0, n-1, withscores = True)
    print(f "销量榜 Top{n}:")
    for idx, (goods, score) in enumerate(top_list, 1):
        print(f "  第{idx}名：{goods}，销量{int(score)}")

def get_goods_rank(goods_name):
    "" "查询单个商品排名" ""
    rank=r.zrevrank('rank: sales', goods_name)
    if rank is not None:
        print(f "{goods_name} 排名第 {rank+1} 名")
    else:
        print(f "{goods_name} 未上榜")

测试
incr_sales('Python 教程', 120)
incr_sales('Redis 实战', 85)
incr_sales('MySQL 优化', 210)
incr_sales('Linux 运维', 96)
incr_sales('Go 语言入门', 78)

get_top_n(3)
get_goods_rank('Redis 实战')
EOF

运行业务场景示例
python3 02_business_scenarios.py

三、大 key / 热 key 避坑实战
开发侧识别、优化、编码规范，从源头避免线上故障
cat > 03_big_hot_key.py <<'EOF'
import redis

r=redis.Redis(host ='127.0.0.1', port = 6379, decode_responses = True)

1. 大 key 识别与拆分优化
大 key 标准：String > 10KB；集合类元素 > 1000 个 或 总大小 > 1MB
危害：阻塞 Redis、网络 IO 飙升、删除卡顿、内存碎片
print("==== = 大 key 避坑实战 ==== =")

开发侧识别方法
1. 编码阶段：预估数据量，集合类提前规划拆分方案
2. 测试环境：用 redis-cli --bigkeys 扫描
3. 生产环境：低峰期用 RDB 文件离线分析（rdbtools）

常见大 key 优化方案

方案 A：大 Hash 拆分
问题：单个 hash 存 10 万用户信息，变成超大 key
优化：按用户 ID 取模，拆分为多个小 hash
def big_hash_split(user_id, field, value):
    "" "大 Hash 分片：按用户 ID 后两位分 100 个小 hash" ""
    shard=user_id % 100
    key=f'user:big_info:shard_{shard}'
    r.hset(key, str(user_id), str(value))
    print(f "用户{user_id}写入分片 {shard}")

def get_big_hash(user_id, field):
    shard=user_id % 100
    key=f'user:big_info:shard_{shard}'
    return r.hget(key, str(user_id))

测试
for uid in range(1000):
    big_hash_split(uid, 'info', f'用户{uid}数据')

方案 B：大 List 分页读取 + 截断
问题：lrange 0 -1 全量读取万级列表，直接阻塞 Redis
优化：分批分页读取，只取需要的范围；定期裁剪旧数据
def get_list_page(key, page = 1, page_size = 20):
    "" "列表分页读取，禁止全量读取" ""
    start=(page - 1) * page_size
    end=start + page_size - 1
    return r.lrange(key, start, end)

❌ 禁止：r.lrange('big_list', 0, -1)
✅ 正确：按页读取，控制单次返回量

方案 C：大 Set/ZSet 分批遍历
问题：smembers / zrange 全量取出大集合
优化：用 sscan / zscan 游标分批遍历
def scan_big_set(key):
    "" "SSCAN 分批遍历大集合，不阻塞 Redis" ""
    cursor=0
    while True:
        cursor, items = r.sscan(key, cursor, count = 100)
        # 处理当前批次数据
        print(f "扫描到 {len(items)} 个元素")
        if cursor == 0:
            break

❌ 禁止：r.smembers('big_set')
✅ 正确：sscan 分批迭代

2. 热 key 识别与优化
热 key：单个 key 每秒访问量上千，集中打在一个 Redis 节点
危害：节点 CPU 打满、网卡跑满、整体性能雪崩
print("\n ==== = 热 key 避坑实战 ==== =")

热 key 识别
1. 业务预判：秒杀商品、首页热点、活动入口
2. 监控发现：Redis 热点 key 监控、客户端统计
3. 应急排查：redis-cli --hotkeys

优化方案

方案 A：本地缓存二级加速
热点数据放应用本地内存，绝大部分请求不打到 Redis
local_hot_cache={}
HOT_KEY='hot:goods:1001'

def get_hot_goods(goods_id):
    "" "热点数据：先读本地缓存，未命中再读 Redis" ""
    if goods_id in local_hot_cache:
        print("[本地缓存命中热点]")
        return local_hot_cache [goods_id]

    data=r.get(f'goods:{goods_id}')
    if data:
        local_hot_cache [goods_id] = data  # 写入本地缓存
        print("[Redis 读取，同步本地缓存]")
    return data

方案 B：热 key 副本打散
原理：将一个热 key 复制 N 份，分布在不同节点，分散压力
def get_hot_key_shard(goods_id):
    "" "随机取一个副本读取，分散请求压力" ""
    import random
    shard=random.randint(0, 9)  # 10 个副本
    key=f'hot:goods:{goods_id}: copy_{shard}'
    return r.get(key)

注意：更新时要同步更新所有副本，保证数据一致性
适用：读多写少的极端热点数据

3. 开发编码红线（必须遵守）
❌ 1. 禁止线上使用 keys / smembers / hgetall / lrange 0 -1 等全量遍历命令
❌ 2. 禁止把无界增长的数据塞到一个 key 里（比如全量用户列表存一个 list）
❌ 3. 禁止大事务、大 Lua 脚本一次性操作海量 key
❌ 4. 禁止把 Redis 当数据库用，所有数据必须设置过期时间
✅ 1. 集合类默认分批操作，控制单次返回数据量
✅ 2. 预估数据量大的场景，提前做分片拆分
✅ 3. 热点数据优先加本地缓存，降低 Redis 压力
✅ 4. 键名规范统一，按业务模块前缀命名，方便排查与管理
EOF

运行大 key 热 key 避坑示例
python3 03_big_hot_key.py

核心速记
1. 三大问题解法：
穿透 → 空值缓存 + 布隆过滤器
击穿 → 互斥锁 + 热点永不过期
雪崩 → 随机过期打散 + 本地二级缓存兜底
2. 业务场景：
限流用计数器、幂等用唯一 token、签到用 Bitmap、排行用 ZSet
3. 大 key 热 key：
大 key 拆分分片、分批遍历；热 key 本地缓存、副本打散
核心原则：禁止全量操作，预估数据量，提前做拆分设计
```


**⑤ 🎯 面试考点**：
- 三者区别与各自方案？答：见故障排查（穿透/击穿/雪崩）。
- 大 key/热 key 危害与处理？答：大 key 拆分+UNLINK；热 key 多副本/本地缓存/分片分散。

### 高级数据结构、Lua 脚本、集群模式注意事项

**① 一句话本质**：高级结构 + Lua 原子脚本 + Cluster 注意事项（多 key 同 slot、迁移兼容）。


``` md
Redis 开发第三优先级 从零实战（Python 版）
完整覆盖：1. 三大高级数据结构
2. Lua 脚本原子化编程
3. 集群模式开发侧避坑指南

pip3 install redis

一、高级数据结构实战
解决特定业务场景，比基础结构更省内存、更高效
cat > 01_advanced_types.py <<'EOF'
import redis
r=redis.Redis(host ='127.0.0.1', port = 6379, decode_responses = True)

1. Bitmap 位图（进阶用法）
本质：String 类型的位操作，1bit 存储一个状态
优势：极度省内存，1 亿用户日活仅需 12MB 左右
适用：日活/月活统计、连续签到、用户留存、海量数据去重
print("==== = 1. Bitmap 进阶实战 ==== =")

场景 1：每日用户日活统计
设计：key = 日期，offset = 用户 ID，1 = 活跃 0 = 未活跃
def user_active(day_str, user_id):
    "" "记录用户当日活跃" ""
    key=f'dau:{day_str}'
    r.setbit(key, user_id, 1)

def get_dau(day_str):
    "" "统计当日活跃用户数" ""
    key=f'dau:{day_str}'
    count=r.bitcount(key)
    print(f "{day_str} 日活用户数：{count}")
    return count

模拟数据：7 月 14 日 100/200/300 号用户活跃
for uid in [100, 200, 300, 400, 500]:
    user_active('20260714', uid)
7 月 15 日 200/300/600 号用户活跃
for uid in [200, 300, 600]:
    user_active('20260715', uid)

get_dau('20260714')
get_dau('20260715')

场景 2：次日留存统计（两天都活跃的用户）
def get_retention(day1, day2):
    "" "计算两天都活跃的留存用户数" ""
    dest_key=f'retention:{day1}_{day2}'
    # 位与运算：两天对应位都为 1 才保留
    r.bitop('AND', dest_key, f'dau:{day1}', f'dau:{day2}')
    retention_count=r.bitcount(dest_key)
    print(f "{day1} 到 {day2} 次日留存用户数：{retention_count}")
    return retention_count

get_retention('20260714', '20260715')

避坑：用户 ID 必须是整数，且不能过大；超大 ID 会导致内存浪费
扩展：支持 OR（并集）、XOR（差集）、NOT（非集）运算

2. HyperLogLog 基数统计
本质：概率算法，极小内存统计海量去重数据
优势：12KB 内存可统计数十亿级基数，空间复杂度极低
误差：标准误差 0.81% 左右，适合不需要绝对精准的海量统计
适用：页面 UV、独立访客、搜索关键词去重
print("\n ==== = 2. HyperLogLog 实战 ==== =")

场景：页面独立访客 UV 统计
def add_uv(page_id, user_id):
    "" "记录页面访问用户" ""
    key=f'uv:page:{page_id}'
    r.pfadd(key, user_id)

def get_uv(page_id):
    "" "获取页面去重访问人数" ""
    key=f'uv:page:{page_id}'
    uv=r.pfcount(key)
    print(f "页面 {page_id} 独立访客数：{uv}（近似值）")
    return uv

模拟 1000 个用户访问首页，其中有重复
for i in range(1000):
    add_uv('home', f'user_{i % 800}')  # 实际 800 个独立用户

get_uv('home')

合并多个页面的 UV，统计全站 UV
def merge_total_uv(page_list):
    dest_key='uv:total:site'
    keys=[f'uv:page:{p}' for p in page_list]
    r.pfmerge(dest_key, *keys)
    total=r.pfcount(dest_key)
    print(f "全站总独立访客数：{total}")
    return total

避坑：只适合统计总数，无法取出具体的用户列表
适合：亿级流量、允许微小误差的统计场景；精确去重请用 Set

3. Geo 地理空间
本质：底层基于 ZSet，将经纬度编码为 52 位 Geohash
适用：附近的人、商家距离排序、位置范围查找
print("\n ==== = 3. Geo 实战 ==== =")

场景：附近商家查询
添加商家位置（名称, 经度, 纬度）
shops=[
    ('shop_001', 116.397, 39.908),  # 北京天安门
    ('shop_002', 116.410, 39.909),
    ('shop_003', 116.380, 39.915),
    ('shop_004', 116.405, 39.890),
]

for name, lon, lat in shops:
    r.geoadd('geo: shops', (lon, lat, name))

计算两个商家之间的距离（单位：千米）
distance=r.geodist('geo: shops', 'shop_001', 'shop_002', unit ='km')
print(f "shop_001 到 shop_002 距离：{float(distance):.2f} km")

查询指定坐标 2 公里内的商家，按距离由近到远排序
near_shops=r.georadius(
    'geo: shops',
    longitude=116.397, latitude = 39.908,
    radius=2, unit ='km',
    withdist=True, sort ='ASC', count = 5
)
print("2 公里内的商家（由近到远）：")
for shop, dist in near_shops:
    print(f "  {shop}，距离 {float(dist):.2f} km")

避坑：坐标范围有限制，不能超出经纬度合法范围
注意：Geo 无法直接删除元素，底层是 ZSet，用 zrem 删除
EOF

python3 01_advanced_types.py

二、Lua 脚本原子化编程
核心价值：将多条命令打包成一个原子操作，解决并发竞态问题
同时减少网络往返，提升批量操作性能
cat > 02_lua_script.py <<'EOF'
import redis
r=redis.Redis(host ='127.0.0.1', port = 6379, decode_responses = True)

Lua 脚本核心原理
1. Redis 单线程执行 Lua 脚本，全程原子，不会被其他命令打断
2. 所有 key 必须通过 KEYS 数组传入，ARGV 传参数
3. 集群模式下，所有 key 必须落在同一个哈希槽
print("==== = Lua 脚本原子化实战 ==== =")

场景 1：原子扣减库存（带库存校验）
普通 decr 会扣成负数；用 Lua 实现：库存 > 0 才扣减，否则返回 0
解决：并发场景下「判断库存 + 扣减」非原子导致的超卖问题
stock_deduct_lua="" "
KEYS [1] = 库存 key
ARGV [1] = 扣减数量
local stock = tonumber(redis.call('get', KEYS [1]) or 0)
local num = tonumber(ARGV [1])
if stock >= num then
    redis.call('decrby', KEYS [1], num)
    return stock - num  -- 返回扣减后剩余库存
else
    return -1  -- 库存不足，扣减失败
end
"" "

注册脚本，生成脚本哈希，后续可复用
stock_script=r.register_script(stock_deduct_lua)

初始化库存
r.set('goods:stock:100', 10)

执行原子扣减
def deduct_stock(goods_id, num = 1):
    key=f'goods:stock:{goods_id}'
    result=stock_script(keys = [key], args = [num])
    if result >= 0:
        print(f "扣减成功，剩余库存：{result}")
    else:
        print("扣减失败，库存不足")
    return result

测试：连续扣减 12 次
for i in range(12):
    deduct_stock(100)

场景 2：原子释放分布式锁
解决：get + del 两步非原子，可能误删别人的锁
unlock_lua="" "
KEYS [1] = 锁 key
ARGV [1] = 锁的唯一标识（只有持有者才能释放）
if redis.call('get', KEYS [1]) == ARGV [1] then
    return redis.call('del', KEYS [1])
else
    return 0
end
"" "
unlock_script=r.register_script(unlock_lua)

使用示例
lock_key='lock:order:1001'
lock_value='unique_request_id_123'
加锁
r.set(lock_key, lock_value, nx = True, ex = 10)
原子释放
result=unlock_script(keys = [lock_key], args = [lock_value])
print(f "\n 锁释放结果：{bool(result)}")

场景 3：批量复合操作，减少网络往返
比如：同时写入用户信息 + 更新积分 + 记录操作日志，一次网络请求完成
batch_update_lua="" "
local user_key = KEYS [1]
local score_key = KEYS [2]
local user_info = ARGV [1]
local add_score = ARGV [2]

redis.call('set', user_key, user_info)
redis.call('incrby', score_key, add_score)
return 1
"" "
batch_script=r.register_script(batch_update_lua)

执行一次调用完成两个操作
ret=batch_script(
    keys=['user:info:2001', 'user:score:2001'],
    args=['用户 2001 信息', 10]
)
print(f "\n 批量原子操作执行结果：{bool(ret)}")

Lua 脚本开发红线（必须遵守）
❌ 1. 禁止在 Lua 中写复杂循环、耗时逻辑，会长期阻塞 Redis
❌ 2. 禁止集群模式下操作多个不同槽的 key，会报错
❌ 3. 禁止使用随机函数（time、random），导致主从数据不一致
❌ 4. 脚本体积不要过大，避免网络传输与解析开销
✅ 1. 所有 key 放 KEYS，参数放 ARGV，符合 Redis 规范
✅ 2. 短小精悍，只做原子逻辑，复杂计算放业务代码
✅ 3. 生产复用脚本哈希（evalsha），减少网络传输
EOF

python3 02_lua_script.py

三、集群模式开发侧避坑指南
注意：不需要掌握集群部署，但必须知道写代码时的限制与坑
cat > 03_cluster_notes.py <<'EOF'
Redis Cluster 开发核心认知
1. 全集群 16384 个哈希槽（Hash Slot），每个节点负责一部分槽
2. 每个 key 通过 CRC16(key) mod 16384 计算所属槽位
3. 客户端只连任意一个节点，非自身槽的请求会返回 MOVED 重定向
4. 单分片内支持所有命令；跨分片操作有大量限制

print("==== = 集群模式开发避坑指南 ==== =")

坑 1：批量操作跨槽位直接报错
受影响命令：MGET / MSET / DEL 多个 key、事务、Lua 脚本
print("\n1. 跨槽批量操作问题")
❌ 错误示例：不同前缀的 key 大概率不在同一个槽，集群下 MGET 报错
r.mget('user: 1001', 'order: 2001')  → 报错 CROSSSLOT

✅ 解决方案 A：Hash Tag 强制同槽
规则：用 {} 包裹 key 的一部分，只计算 {} 内的字符串的哈希槽
只要 {} 内内容相同，key 就会落在同一个槽位
示例：
user:{1001}: info    ← 都按 1001 计算槽，同槽
user:{1001}: order
user:{1001}: score
这样三个 key 可以安全使用 MGET/MSET 等批量命令

✅ 解决方案 B：客户端侧拆分，按槽分组后分批请求
比如 mget 100 个 key，按槽位拆成 5 批，分别请求对应节点

开发规范：
同一业务、需要批量操作的 key，提前设计 Hash Tag
禁止无差别对大量随机 key 做批量操作

坑 2：事务 / Lua 脚本跨槽失效
print("\n2. 事务与 Lua 限制")
Redis 事务（MULTI/EXEC）和 Lua 脚本，都要求所有操作的 key 在同一个槽
❌ 跨槽事务 / 跨槽 Lua 直接报错
✅ 解决方案：用 Hash Tag 保证所有 key 同槽

坑 3：全量遍历命令不返回全集群数据
受影响：KEYS、SCAN、FLUSHALL
print("\n3. 全量遍历限制")
❌ 单节点执行 keys *，只能扫到当前节点的 key，不是全集群
❌ 单节点 scan，也只能遍历当前分片
✅ 正确做法：
遍历所有节点，分别执行 scan，再合并结果
生产永远禁止用 keys *，无论单机还是集群

坑 4：热点 key 无法通过集群分散压力
print("\n4. 热点 key 问题")
集群是按 key 分片扩容，单个热点 key 永远落在一个节点上
无法通过加节点分散这个 key 的压力，和单机一样会打满单节点
✅ 解决方案：
本地内存缓存兜底（二级缓存）
热 key 复制多份副本（hot_key_1 ~ hot_key_N），分散到不同槽
读请求随机访问副本，分散压力

坑 5：数据库与缓存双写一致性更复杂
print("\n5. 一致性注意")
集群扩容、节点故障切换时，可能出现短暂的数据不一致
业务侧不要强依赖 Redis 的强一致性
核心原则：Redis 是缓存，最终以数据库为准，所有缓存都要设置过期时间

集群模式开发最佳实践
1. key 设计阶段就考虑 Hash Tag，同业务聚合 key 用相同 tag
2. 批量操作优先按槽位拆分，或用 Hash Tag 保证同槽
3. 禁止全集群 keys、flush 等高危操作
4. 热点 key 提前做本地缓存 + 副本打散，不要依赖集群扩容解决
5. Lua / 事务严格控制在单槽范围内
6. 客户端使用支持集群重定向的 SDK（redis-py 集群模式）
EOF

python3 03_cluster_notes.py

核心速记
1. 高级结构：
Bitmap 存状态省内存，适合日活签到；HyperLogLog 做海量基数统计，有误差；Geo 做 LBS 位置查询
2. Lua 脚本：
解决并发原子问题，短小精悍，KEYS 传键 ARGV 传参，集群保证同槽
3. 集群避坑：
跨槽批量会报错，Hash Tag 来解决；热点 key 集群没用，本地缓存加副本
```


**⑤ 🎯 面试考点**：
- Lua 脚本原子性？答：执行期间单线程独占，原子无并发；禁长脚本。
- Cluster 下跨 slot 限制？答：多 key 需同 slot（hash tag {}），否则报错；mget/事务受限。
- reshard 注意？答：迁移 slot 期间部分 key 返回 ASK/MOVED，客户端需重定向；低峰操作。

### 生产补充：Stream 消息队列、ACL 权限、集群 reshard

**① 一句话本质**：生产补充 = Stream 消息队列 + ACL 细粒度权限 + 集群扩缩容 reshard。


``` md
Redis 生产补充三连：Stream、ACL、集群 reshard
一、Stream 消息队列（5.0+ 自带轻量 MQ，替代 List 队列）
1. 为什么用 Stream：List 的 BRPOP 是"抢消息"（一条消息只能被一个消费者拿走）；
Stream 支持 多消费者组 + 消息持久化 + ACK 确认，能实现"每个消费者组都独立读到"
2. 核心命令
XADD orders * item iphone     # 添加消息，* 自动生成 ID（时间戳-序号）
XLEN orders                   # 查看消息数量
XREAD COUNT 5 STREAMS orders 0   # 从头读 5 条
3. 消费组（类似 Kafka 消费者组，组内消息不重复）
XGROUP CREATE orders g1 0
XREADGROUP GROUP g1 c1 COUNT 10 STREAMS orders >   # > 表示只读新消息
4. 手动 ACK：XACK orders g1 消息ID   # 不 ACK 的消息留在 PEL，可被重新投递

二、ACL 权限控制（6.0+，生产必配）
1. 背景：默认无密码 + 所有人可执行 FLUSHALL/KEYS，高危
2. 创建只读用户：ACL SETUSER readonly on > 'Read@123' ~* +@read
   on 启用用户、> '密码' 设置密码、~* 允许所有 key、+@read 只给读命令
3. 限定 key 的业务用户：ACL SETUSER biz on > 'Biz@123' ~orders:* +get +xadd
4. 查看：ACL LIST、ACL WHOAMI
5. 生产建议：禁用默认用户高危命令，rename-command FLUSHALL "" 或只授权给运维专用账号

三、集群在线扩缩容 reshard
1. 新节点加入集群：redis-cli --cluster add-node 新节点IP:6379 旧节点IP:6379
2. 迁移槽位（把 500 个槽从旧节点分给新节点）
redis-cli --cluster reshard 新节点IP:6379 \
cluster-from 旧节点ID --cluster-to 新节点ID --cluster-slots 500 --cluster-yes
3. 平衡所有节点槽位：redis-cli --cluster rebalance 任意节点IP:6379
4. 下线节点（先迁走它的所有槽）：redis-cli --cluster del-node 任意节点IP:6379 待下线节点ID
5. 注意：迁移期间 key 按槽逐批搬移业务无感知，但要监控迁移速度与网络流量
```

---


**⑤ 🎯 面试考点**：
- Stream 与 Kafka 定位差异？答：Redis Stream 轻量内嵌，适中小场景；Kafka 高吞吐分布式，适大数据管道。
- ACL 作用？答：细粒度授权（用户/命令/key 级），从单 requirepass 升级多用户。
- reshard 数据迁移风险？答：迁移槽期间流量短暂重定向，规划低峰、控批次。

## 三、消息队列 + 存储服务（互联网企业必备）

1. 消息队列运维

### RabbitMQ

**① 一句话本质**：RabbitMQ = AMQP 消息队列，核心模型是 交换机(exchange)+队列(queue)+绑定(binding) 路由消息。


- 集群部署、节点角色
- 交换机类型：直连 / 主题 / 扇形 / 头部
- 队列持久化、消息持久化
- 用户权限、vhost 隔离
- **消息积压、消息丢失、重复消费排障**

``` md

RabbitMQ 生产运维全栈手册
1. 集群部署与节点角色 | 2. 四大交换机类型
3. 队列+消息持久化 | 4. vhost 隔离与用户权限
5. 核心故障排障：消息积压 / 消息丢失 / 重复消费

一、集群部署与节点角色
核心作用：单节点性能/容量不足时横向扩容，多节点实现高可用
节点角色分类：
1. 磁盘节点（disc）：元数据（队列、交换机、绑定关系）持久化到磁盘
集群至少保留 1 个磁盘节点，防止全集群重启后元数据丢失
2. 内存节点（ram）：元数据仅存内存，读写性能高
用于高并发接入场景，重启后元数据从磁盘节点同步恢复
集群模式：普通集群（队列仅存单个节点）、镜像队列（队列同步多节点，高可用）

1. 前置环境（所有节点执行）
安装依赖与服务
yum install -y erlang rabbitmq-server
开启 Web 管理控制台（端口 15672）
rabbitmq-plugins enable rabbitmq_management
systemctl start rabbitmq-server
systemctl enable rabbitmq-server

2. 集群身份同步：Erlang Cookie（节点间认证凭证，全集群必须一致）
复制主节点 Cookie 到所有从节点，保证权限一致
scp /var/lib/rabbitmq/.erlang.cookie root@从节点 IP:/var/lib/rabbitmq/
chown rabbitmq: rabbitmq /var/lib/rabbitmq/.erlang.cookie
chmod 400 /var/lib/rabbitmq/.erlang.cookie
systemctl restart rabbitmq-server

3. 从节点加入集群（在从节点本地执行）
rabbitmqctl stop_app
默认加入为磁盘节点；加 --ram 参数则为内存节点
rabbitmqctl join_cluster rabbit@主节点主机名
rabbitmqctl start_app

4. 集群状态校验
rabbitmqctl cluster_status
核心输出：所有节点列表、节点类型、运行状态、分区状态

5. 节点类型切换
rabbitmqctl change_cluster_node_type ram   # 改为内存节点
rabbitmqctl change_cluster_node_type disc  # 改为磁盘节点

6. 生产高可用标配：镜像队列策略
队列数据自动同步到集群多节点，单节点宕机不丢失队列数据
rabbitmqctl set_policy ha-all "^" '{"ha-mode": "all"}'
参数说明：
ha-all：策略名称
"^"：正则匹配所有队列；可指定前缀匹配特定业务队列
ha-mode: all → 同步到集群所有节点；exactly → 指定副本数；nodes → 指定节点列表

二、四大交换机类型（Exchange）
作用：接收生产者消息，根据路由规则转发到绑定的队列

1. 直连交换机 Direct
路由规则：消息的 routing_key 与队列绑定的 binding_key 完全相等才转发
适用场景：点对点精准投递，如订单状态通知、短信验证码
rabbitmqadmin declare exchange name = direct_order type = direct durable = true

2. 主题交换机 Topic
路由规则：routing_key 支持通配符，用 . 分隔单词
* 匹配 1 个单词；# 匹配 0 个或多个单词
适用场景：多维度分类投递，如日志分级、消息订阅、新闻分类推送
rabbitmqadmin declare exchange name = topic_log type = topic durable = true
绑定示例：log.info.* 匹配 log.info.order / log.info.pay
绑定示例：log.#     匹配 log.error / log.warn.db.user

3. 扇形交换机 Fanout
路由规则：忽略 routing_key，将消息广播到所有绑定的队列
适用场景：全局广播通知，如配置刷新、系统公告、活动群发
特点：无路由匹配开销，转发速度最快
rabbitmqadmin declare exchange name = fanout_notice type = fanout durable = true

4. 头部交换机 Headers
路由规则：根据消息的 headers 属性匹配，完全不依赖 routing_key
适用场景：复杂多条件路由的特殊业务，性能差，生产极少使用
rabbitmqadmin declare exchange name = headers_custom type = headers durable = true

常用查询命令
rabbitmqctl list_exchanges   # 查看所有交换机
rabbitmqctl list_bindings    # 查看所有交换机与队列的绑定关系

三、持久化机制（宕机数据不丢失的核心）
完整持久化三要素：交换机持久化 + 队列持久化 + 消息持久化，三者缺一不可

1. 交换机持久化
声明时指定 durable = true，服务重启后交换机配置保留，不会消失
上面创建交换机已开启 durable = true，生产所有业务交换机必须开启

2. 队列持久化
声明队列时指定 durable = true，服务重启后队列实体依然存在
rabbitmqadmin declare queue name = order_queue durable = true
注意：队列创建后持久化属性不可修改，必须删除重建
仅队列持久化，消息不持久化 → 重启后队列存在，消息全部丢失

3. 消息持久化
生产者发送消息时指定 delivery_mode = 2（持久化标识）
消息会异步写入磁盘，服务宕机重启后可恢复未消费的消息
注意：
✅ 持久化会降低写入吞吐量，非核心消息可根据业务权衡
✅ 极端宕机场景（刷盘前断电）仍可能丢失毫秒级数据，需 100%可靠要开生产者确认

4. 持久化校验
rabbitmqctl list_queues name durable

四、vhost 隔离与用户权限体系
vhost=虚拟主机，类似 MySQL 的库，实现多业务逻辑隔离
每个 vhost 拥有独立的交换机、队列、权限体系，业务之间完全不互通

1. vhost 生命周期管理
按业务线创建独立 vhost，实现资源与权限隔离
rabbitmqctl add_vhost /order_vhost
rabbitmqctl add_vhost /pay_vhost

查看所有 vhost
rabbitmqctl list_vhosts

删除废弃 vhost
rabbitmqctl delete_vhost /test_vhost

2. 用户创建与最小权限授权
创建业务账号
rabbitmqctl add_user biz_order Order@Prod_2026
设置用户角色：none/management/policymaker/monitoring/administrator
普通业务账号设为 none，仅用于收发消息，无管理权限
rabbitmqctl set_user_tags biz_order none

授权 vhost 权限，格式：set_permissions -p vhost 名 用户名 配置权限 写权限 读权限
权限说明：
configure：创建/删除队列、交换机等资源
write：发送消息
read：消费消息
生产规范：业务账号最小权限，不授予 configure 权限
rabbitmqctl set_permissions -p /order_vhost biz_order "" ".*" ".*"

3. 权限查询与回收
查看指定用户所有权限
rabbitmqctl list_user_permissions biz_order
查看指定 vhost 下所有授权
rabbitmqctl list_permissions -p /order_vhost

回收权限
rabbitmqctl clear_permissions -p /order_vhost biz_order

4. 生产安全硬性规范
1. 删除默认高危 guest 账号，禁止弱密码
rabbitmqctl delete_user guest
2. 不同业务使用独立 vhost+独立账号，互不干扰
3. 管理端口 15672 仅内网开放，防火墙限制访问来源
4. 生产账号禁止 administrator 角色，单独创建运维管理员账号

五、核心故障排障
覆盖：消息积压、消息丢失、重复消费

故障 1：消息积压（队列消息堆积，消费速度跟不上生产速度）
现象：业务处理延迟，队列消息数持续增长，告警触发
排查命令
全队列积压概览
rabbitmqctl list_queues name messages consumers
细分状态：待消费数 / 已投递未确认数
rabbitmqctl list_queues name messages_ready messages_unacknowledged consumers
messages_ready：待消费积压量，核心告警指标
messages_unacknowledged：已发给消费者但未 ack 的消息数

常见根因
1. 消费者服务宕机/异常，完全停止消费
2. 消费逻辑慢（数据库慢查询、外部接口超时），单条消息处理耗时久
3. 突发大流量，生产端消息量瞬时翻倍
4. 消费者线程数配置过少，消费能力不足

应急与优化
1. 快速扩容：增加消费者实例/消费线程数，最直接提升消费能力
2. 业务降级：非核心消息临时丢弃或转存，优先保障核心消息消费
3. 逻辑优化：优化消费端慢查询、减少外部调用，缩短单条处理时长
4. 死信兜底：配置死信队列，超过时长/次数的消息转入死信，避免阻塞主队列
5. 生产限流：入口侧限制生产速率，避免消息持续涌入扩大积压

故障 2：消息丢失（发送成功但消费端未收到，重启后消息消失）
三类丢失场景与根因
场景 1：生产端丢失 → 消息未成功到达 RabbitMQ
原因：网络抖动、交换机无对应队列绑定，消息被静默丢弃
场景 2：服务端丢失 → 未做持久化，服务宕机重启后消息/队列消失
场景 3：消费端丢失 → 自动 ack 模式，消息刚投递就确认，业务处理失败消息不重发

完整解决方案
1. 生产端：开启生产者确认机制（Publisher Confirms）
消息成功写入队列后，MQ 返回 ack；失败返回 nack，生产者重试
配合 mandatory 参数，无法路由的消息返回给生产者，不静默丢弃
#
2. 服务端：三要素全量持久化 + 镜像队列
交换机+队列+消息全部开启持久化；镜像队列多副本，单节点宕机不丢
#
3. 消费端：关闭自动 ack，改为手动 ack
业务逻辑全部处理完成后，再手动发送 ack；处理失败则 nack，消息重新入队
#
4. 兜底：死信交换机，无法路由、过期、被拒绝的消息转入死信队列，可追溯可恢复

故障 3：重复消费（同一条消息被消费多次）
核心根因
RabbitMQ 默认 At Least Once 保证，消息至少投递一次，无法 100%避免重复
触发场景：
1. 消费者处理完未发送 ack 就宕机，消息重新入队再次投递
2. ack 网络超时，MQ 未收到确认，触发重发
3. 消费者手动 nack，消息重新入队再次消费

排查与根治
排查：通过消息唯一 ID 对比消费日志，确认重复次数与触发时间
根治方案：**业务侧实现幂等性**，是唯一彻底解决重复消费的方案
常用幂等实现：
1. 唯一 ID 去重：消息带全局唯一 ID，消费前查去重表，已处理则直接跳过
2. 数据库唯一键：利用主键/唯一索引约束，重复插入直接报错，不产生脏数据
3. 乐观锁：更新操作带版本号校验，版本不匹配则不执行
#
MQ 侧优化：
优化消费速度，减少超时重发概率；合理设置 ack 超时时间

核心速记
1. 集群：磁盘节点存元数据，内存节点提性能；镜像队列实现节点级高可用
2. 交换机：直连精准匹配、主题通配符、扇形广播、头部极少用
3. 持久化：交换机+队列+消息三要素全开，才会真正落盘
4. 权限：vhost 做业务隔离，账号最小权限，删除默认 guest
5. 故障三板斧：
积压 → 加消费者、优化消费逻辑
丢失 → 持久化+生产者确认+手动 ack
重复 → 业务幂等是唯一根治方案
```


**⑤ 🎯 面试考点**：
- 四种交换机类型？答：direct（精确路由键）、fanout（广播）、topic（模式匹配）、headers（头匹配，少用）。
- 消息确认机制？答：消费者显式 ack 才删消息；autoAck=false 防丢失；nack 重入队。
- 队列/消息持久化？答：队列 durable + 消息 delivery_mode=2 + 交换机 durable，防重启丢。

### 从零学 RabbitMQ

**① 一句话本质**：从零学 = 安装部署 + 基础概念（生产者/消费者/信道）+ Hello World 收发。


``` md
RabbitMQ 从零完整学习手册
1. 安装目录结构详解
2. 服务启停/状态命令大全
3. 虚拟主机 vhost、用户、权限管理命令
4. 交换机、队列、绑定管理命令
5. 消息发布、消费、死信、监控运维命令
6. 集群管理、备份恢复命令
7. 开发核心概念+Python 配套提示

安装依赖与服务
yum install -y erlang rabbitmq-server
一、开启 Web 管理插件命令
rabbitmq-plugins enable rabbitmq\_management
插件开启后无需重启 RabbitMQ，直接访问
访问地址：http://服务器 IP: 15672
管理端口：15672；消息通信端口：5672

systemctl start rabbitmq-server
systemctl enable rabbitmq-server

二、默认账号密码 + 关键限制（必考踩坑点）
默认用户名：guest
默认密码：guest
强制安全限制（RabbitMQ 3.3.0 及所有新版）：
guest 仅允许 127.0.0.1 / localhost 本地登录，\*\*公网/远程 IP 访问直接 401 拒绝登录\*\*

解决方案 1（生产推荐：新建管理员账号，永久解决远程访问）
1. 创建管理员用户 admin，密码自定义
rabbitmqctl add_user admin Admin@Rabbit2026
2. 赋予超级管理员角色 administrator
rabbitmqctl set_user_tags admin administrator
3. 给账号授予根 vhost 全部读写配置权限
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
4. 安全操作：删除默认高危 guest 账号（生产必须执行）
rabbitmqctl delete_user guest

一、RabbitMQ 安装后标准目录结构（CentOS yum 安装）
1. 程序二进制文件
/usr/sbin/rabbitmq-server       # 主服务启动程序
/usr/sbin/rabbitmqctl          # 核心运维命令行工具（最常用）
/usr/sbin/rabbitmq-plugins      # 插件管理（开启 web 管理界面）
/usr/sbin/rabbitmq-diagnostics  # 诊断、监控工具
/usr/sbin/rabbitmq-env          # 环境变量脚本

2. 配置文件目录
/etc/rabbitmq/
    rabbitmq.conf               # 主配置文件（端口、内存、磁盘限制、持久化）
    advanced.config             # 高级 Erlang 语法配置（集群、镜像队列）
    enabled_plugins             # 已开启插件记录

3. 数据持久化目录（队列、消息、元数据、镜像副本）
/var/lib/rabbitmq/mnesia/
    # 存储交换机、队列、vhost、消息、用户权限、集群节点元数据

4. 日志目录
/var/log/rabbitmq/
    rabbit@主机名.log           # 服务运行日志、报错、连接日志
    rabbit@主机名-sasl.log      # Erlang 底层安全、崩溃日志

5. 节点身份文件（集群同步关键）
/var/lib/rabbitmq/.erlang.cookie
集群所有节点 cookie 必须完全一致，否则节点无法互通

6. Web 管理控制台访问地址
http://服务器 IP: 15672  账号密码自行创建

二、服务启停、基础状态命令
1. 系统服务管理（systemd）
systemctl start rabbitmq-server     # 启动服务
systemctl stop rabbitmq-server      # 停止服务
systemctl restart rabbitmq-server   # 重启
systemctl enable rabbitmq-server     # 开机自启
systemctl disable rabbitmq-server    # 取消自启
systemctl status rabbitmq-server    # 查看运行状态

2. 前台启动（调试用，关闭终端即停止）
rabbitmq-server

3. 后台守护进程启动
rabbitmq-server -detached

4. 关闭节点（优雅停机，等待消费完成）
rabbitmqctl stop
快速强制关闭
rabbitmqctl stop_app

5. 查看节点运行状态
rabbitmqctl status
简易健康检查
rabbitmqctl ping

6. 开启 Web 管理插件（必须执行才能访问 15672 后台）
rabbitmq-plugins enable rabbitmq_management
查看已启用插件
rabbitmq-plugins list

一、RabbitMQ 整体架构组成
1. 客户端（Producer 生产者 / Consumer 消费者）
业务程序，Python/Java/Go，通过 5672 端口 AMQP 协议收发消息
生产者：发送消息；消费者：监听队列处理消息

2. Broker 服务节点（RabbitMQ 服务本体）
一台服务器启动一个 rabbitmq-server 进程就是一个 Broker 节点
内部由 Erlang 虚拟机运行，单线程处理消息读写

3. 虚拟主机 Vhost
逻辑隔离单元，类似 MySQL 数据库，每个 vhost 独立交换机、队列、权限
多业务共用 MQ 时拆分 vhost，业务互不干扰

4. Exchange 交换机（路由层）
接收生产者消息，根据路由规则分发到绑定的队列
四种类型：Direct / Topic / Fanout / Headers

5. Binding 绑定关系
交换机 ↔ 队列之间的桥梁，携带 routing_key 路由规则

6. Queue 队列（消息存储层）
真正存放消息的容器，消费者只从队列拉取消息
支持持久化、死信、长度限制、消息 TTL

7. Message 消息本体
消息头属性（routing_key、delivery_mode、message-id）+ 消息体业务数据

8. Web 管理插件 rabbitmq_management
内置 HTTP API，15672 端口，提供页面、rabbitmqadmin 命令操作资源

9. Erlang Cookie（集群组件）
集群节点间身份凭证，所有节点 cookie 必须一致才能组成集群

10. 持久化存储目录 mnesia
存放元数据（交换机/队列/用户）+ 持久化消息

二、完整工作流转原理（标准 Direct 点对点流程）
步骤 1：生产者建立 TCP 连接，创建 Channel 通道（复用连接，节省开销）
步骤 2：生产者声明交换机（不存在则创建，durable 持久化）
步骤 3：生产者发送消息，携带 exchange 名称 + routing_key + 消息持久化标识
步骤 4：Broker 接收消息，交给对应交换机
步骤 5：交换机根据自身类型 + binding 绑定的 routing_key 匹配目标队列
步骤 6：匹配成功，消息存入对应 Queue；无匹配队列则丢弃/返回生产者（mandatory 参数）
步骤 7：消费者建立连接、声明队列、绑定交换机，开始监听队列
步骤 8：Broker 将队列消息推送给消费者（或消费者主动拉取）
步骤 9：消费者执行业务逻辑，处理完成后发送手动 ACK 确认
步骤 10：Broker 收到 ACK，永久删除该条消息；处理异常发送 NACK，消息重新入队

生产者 → TCP 连接 / Channel → Exchange 交换机 (路由分发) → Binding 规则 → Queue 队列 (存消息) → 消费者 ACK 确认 → MQ 删除消息

扩展广播流程（Fanout）：
消息到达 Fanout 交换机，忽略 routing_key，复制消息分发给所有绑定队列

三、全部核心概念精讲
1. Producer 生产者
发送消息的应用，只对接交换机，不感知队列存在

2. Consumer 消费者
监听队列、消费处理消息的应用，只从队列拿数据

3. Connection 连接
TCP 长连接，客户端与 Broker 之间的底层连接，创建成本高，尽量复用

4. Channel 通道（高频重点）
一个 TCP 连接内可创建上千个独立 Channel，轻量级，绝大多数业务操作在 Channel 完成
作用：多线程共用一条 TCP 连接，避免频繁创建销毁 TCP

5. Vhost 虚拟主机
隔离资源与权限，不同业务分配独立 vhost，账号权限仅作用于指定 vhost

6. Exchange 交换机 4 种类型
Direct：精准匹配 routing_key，一对一投递（订单、短信）
Topic：通配符模糊匹配，日志、多标签订阅
Fanout：广播，无视路由键，发给全部绑定队列（配置通知）
Headers：根据消息头部键值匹配，极少使用

7. Routing Key 路由键
生产者发送消息携带的标签，交换机依靠它匹配绑定规则

8. Binding 绑定
交换机和队列的关联关系，绑定的时候指定 binding_key（匹配规则）

9. Queue 队列
消息存储载体，先进先出；支持：
durable：队列元数据持久化
exclusive：仅当前连接可用，连接断开自动删除
auto_delete：无消费者时自动删除队列

10. Message 消息属性
delivery_mode=1 临时消息，重启丢失
delivery_mode=2 持久消息，落盘保存
message-id：全局唯一 ID，用于消费幂等
expiration：消息过期时间 TTL

11. ACK 消息确认机制（可靠性核心）
auto_ack=true 自动确认：消息推给消费者立刻删除，易丢消息，生产禁用
auto_ack=false 手动确认：业务处理成功 ch.ack；失败 ch.nack 重新入队

12. Qos 预取计数 prefetch_count
限制单次推送给消费者的未确认消息数量，防止消费者内存打爆

13. DLX 死信交换机 / DLQ 死信队列
消息三种情况转入死信：过期 TTL、消费者拒绝且不重入、队列达到最大长度
用于兜底失败消息，避免无限重试堵塞主队列

14. 持久化三要素（防止宕机丢消息）
1. 交换机 durable = true
2. 队列 durable = true
3. 消息 delivery_mode = 2
三者同时开启，重启 MQ 消息不丢失

15. 集群 & 镜像队列
普通集群：队列仅存在单个节点，节点宕机队列丢失
镜像队列：队列副本同步到集群多节点，高可用，单节点故障不丢数据

16. 消息三种异常问题底层原理
消息丢失：未持久化、自动 ACK、无绑定队列直接丢弃
消息重复消费：消费完未发送 ACK 程序崩溃，消息重发（解决方案：业务幂等）
消息堆积：消费者离线/消费速度慢、单条消息处理耗时过长

RabbitMQ 官方标准 5 种消息模型，对应 4 种交换机实现
1. 简单模式 Simple（点对点）
2. 工作队列模式 Work Queue（多个消费者竞争消费）
3. 发布订阅 Publish/Subscribe（Fanout 广播）
4. 路由模式 Routing（Direct 精准过滤）
5. 主题模式 Topic（模糊通配符订阅）

模式 1：Simple 简单模式（Direct 交换机）
架构：1 生产者 → 1 队列 → 1 消费者
适用：一对一单次通知，简单短信、验证码推送
流程：
生产者发消息到 Direct 交换机，绑定唯一队列，单个消费者监听队列
特点：
1. 一条消息只会被一个消费者处理
2. 无并发能力，仅适合单消费程序
缺陷：无法水平扩容，消费者挂掉消息堆积

模式 2：Work Queue 工作队列（Direct 交换机）
架构：1 生产者 → 1 队列 → N 个消费者（竞争消费）
适用：任务削峰、耗时任务异步处理（邮件、文件解析）
核心机制：Qos prefetch_count
流程：
多个消费者监听同一个队列，MQ 轮询分发消息，每条消息只分给一个空闲消费者
两种分发策略：
1. 默认轮询：不管消费者快慢，平均分配消息，慢消费者会堆积未处理消息
2. 公平分发（生产推荐）：设置 prefetch_count = 1，消费者处理完 ACK 才下发下一条
特点：水平扩容，多机器分担压力，秒杀、大量异步任务首选

模式 3：Publish/Subscribe 发布订阅（Fanout 扇形交换机）
架构：1 生产者 → Fanout 交换机 → N 个独立队列（每个队列绑定一个消费者）
适用：全局广播通知、配置刷新、多服务同步更新
流程：
Fanout 忽略 routing_key，消息复制多份，所有绑定该交换机的队列全部收到消息
特点：
1. 一条消息所有消费者都会完整接收
2. 完全解耦，新增业务只需新建队列绑定交换机，不用改生产者代码
案例：系统公告推送订单服务、库存服务、日志服务

模式 4：Routing 路由模式（Direct 直连交换机）
架构：生产者携带 routing_key 发送，队列绑定指定 key，精准过滤消息
适用：日志分级、业务类型区分（支付消息、订单消息分开消费）
流程：
1. 队列绑定交换机时指定固定 binding_key
2. 生产者消息携带 routing_key，完全匹配才投递到对应队列
案例：
key=error → 错误日志队列（告警推送）
key=info → 普通日志队列（存储）
特点：精准一对一/一对多，只有匹配 key 的队列收到消息

模式 5：Topic 主题模式（Topic 主题交换机）
架构：基于 . 分割多级路由 key，支持 * # 通配符模糊匹配
适用：复杂多维度日志、多标签业务消息订阅
通配符规则：
* 匹配任意 1 个单词
匹配 0 个或多个单词
示例：
消息 rk：log.error.order
绑定 1：log.error.*  → 匹配所有一级后缀 error 日志
绑定 2：log.#       → 匹配全部日志
绑定 3：#.order     → 匹配所有订单相关日志
特点：灵活模糊订阅，是 Routing 模式的升级版，业务最通用

补充区分速记
Simple/Work：共用 Direct，单队列，区别是消费者数量
Publish/Subscribe：Fanout，全量广播，不区分 key
Routing：Direct，精准完整匹配 key
Topic：Topic，通配符模糊匹配 key

三、虚拟主机 vhost 管理（业务隔离核心）
1. 创建虚拟主机
rabbitmqctl add_vhost /order_vhost
2. 删除废弃 vhost
rabbitmqctl delete_vhost /test_vhost
3. 列出全部 vhost
rabbitmqctl list_vhosts
4. 查看 vhost 详情（消息数、磁盘占用）
rabbitmqctl list_vhosts name tracing

四、用户、角色、权限全套命令（安全必备）
1. 创建用户 用户名 密码
rabbitmqctl add_user biz_order Order@2026
2. 修改用户密码
rabbitmqctl change_password biz_order NewPass@123
3. 删除用户
rabbitmqctl delete_user guest
4. 查看所有用户
rabbitmqctl list_users

5. 设置用户角色（权限分级）
none：普通业务账号，仅收发消息（推荐业务使用）
management：可登录 web 后台查看监控
policymaker：可创建策略（镜像队列、死信规则）
monitoring：完整监控权限
administrator：超级管理员（所有权限）
rabbitmqctl set_user_tags biz_order none
rabbitmqctl set_user_tags admin administrator

6. 分配 vhost 权限 格式：set_permissions -p vhost 用户 配置权限 写权限 读权限
权限说明：
configure：创建/删除队列、交换机
write：发送消息
read：消费消息
业务最小权限：无 configure，仅读写
rabbitmqctl set_permissions -p vhost 用户名  配置权限 写权限 读权限
rabbitmqctl set_permissions [-p vhost] 用户名 配置正则 写正则 读正则
rabbitmqctl set_permissions -p /order_vhost biz_order "" ".*" ".*"
`""` 空字符串 = **完全没有配置权限**
`".*"` 正则匹配所有交换机，代表可以向本 vhost 内任意交换机发消息
`".*"` 匹配所有队列，代表可以消费本 vhost 任意队列消息

7. 查看用户权限
rabbitmqctl list_user_permissions biz_order
查看 vhost 下所有授权账号
rabbitmqctl list_permissions -p /order_vhost
回收权限
rabbitmqctl clear_permissions -p /order_vhost biz_order

五、交换机 Exchange 管理命令（4 种类型：direct/topic/fanout/headers）

交换机核心作用（一句话）
生产者不直接发给队列，消息先发给交换机；交换机根据规则路由分发消息到对应队列
核心定位：消息路由中转站，负责「消息分发逻辑」，没有交换机生产者无法投递消息到队列

完整流转流程
生产者(Python/业务代码) → 发送消息到 Exchange 交换机 → 根据 routing\_key+绑定规则匹配 → 投递到目标 Queue 队列 → 消费者监听队列取消息

为什么不能生产者直接发队列？交换机解决的业务能力
1. 灵活路由：一条消息分发到多个队列（广播、多订阅）
2. 分类过滤：按标签区分日志、订单、支付消息，不同消费者只接收自己关心的数据
3. 解耦：生产者只关心发给交换机，不用知道有多少队列、队列名称
4. 复杂分发：点对点、广播、模糊匹配、多条件筛选四种分发模式

RabbitMQ 四种原生交换机类型（核心，开发必记）
1. Direct 直连交换机（点对点，最常用）
路由规则：消息 routing\_key 必须 和 队列绑定的 routing\_key 完全相等，才投递
业务场景：订单推送、短信发送、一对一通知
示例命令创建（rabbitmqctl 没有 declare_exchange 子命令，用 rabbitmqadmin 或 HTTP API）：

创建交换机
rabbitmqadmin -u admin -p 'Admin@Rabbit2026' declare exchange -V /biz name=direct_order type=direct durable=true

队列绑定：routing\_key = order\_create
rabbitmqctl bind_exchange /biz queue_order direct_order order_create
绑定队列语法
 /biz  虚拟主机名 vhost
queue_order：要绑定的队列名
direct_order 交换机名称
order_create：路由键，用于路由匹配

生产者发消息必须携带 routing\_key = "order\_create" 才能进入队列

2. Fanout 扇形交换机（广播模式）
路由规则：完全忽略 routing\_key，消息复制一份发给所有绑定该交换机的队列
业务场景：系统配置刷新、全局公告、活动全服务通知
特点：分发速度最快，无匹配计算
rabbitmqctl declare\_exchange /biz fanout_notice fanout true

3. Topic 主题交换机（模糊匹配订阅）
路由规则：routing\_key 用 . 分割多级标签，支持通配符匹配队列绑定 key
通配符：
\*  匹配任意 1 个单词
匹配 0 个或多个单词
业务场景：日志分级（log.error、log.info）、多维度消息订阅
例：绑定 key log.# 接收所有日志；log.error.\* 只接收错误日志

4. Headers 头部交换机（极少使用）
路由规则：不看 routing\_key，匹配消息 headers 键值对
适用：多字段复杂筛选，性能差，业务基本不用

关键配套概念：Binding 绑定
交换机本身不存消息，交换机和队列之间需要建立绑定关系 bind
绑定三要素：交换机名称、队列名称、路由键 routing\_key
一条交换机可以绑定成千上万个队列，实现一对多分发

语法：rabbitmqadmin -V vhost declare exchange name=交换机名 type=类型 durable=是否持久化
durable=true 持久化，服务重启交换机不消失（生产必开）
rabbitmqadmin -V /order_vhost declare exchange name=direct_order type=direct durable=true
rabbitmqadmin -V /order_vhost declare exchange name=topic_log type=topic durable=true
rabbitmqadmin -V /order_vhost declare exchange name=fanout_notice type=fanout durable=true

删除交换机
rabbitmqadmin -V /order_vhost delete exchange name=direct_order

列出当前 vhost 所有交换机
rabbitmqctl list_exchanges -p /order_vhost name type durable

六、队列 Queue 管理、绑定关系 Binding
1. 声明队列：vhost 队列名 持久化 true/false
rabbitmqctl declare_queue /order_vhost queue_order true

2. 交换机绑定队列（核心路由规则）
格式：bind_exchange vhost 队列 交换机 routing_key
rabbitmqctl bind_exchange /order_vhost queue_order direct_order order_rk

3. 解绑
rabbitmqctl unbind_exchange /order_vhost queue_order direct_order order_rk

4. 查看所有队列（积压消息、消费者数量、未确认消息）
rabbitmqctl list_queues -p /order_vhost name messages consumers messages_unacknowledged

5. 清空队列所有消息（不删除队列）
rabbitmqadmin -V /order_vhost purge queue name=queue_order

6. 删除队列（有消息/有消费者会报错，rabbitmqadmin 加 -f 强制删除）
rabbitmqadmin -V /order_vhost delete queue name=queue_order

7. 查看所有绑定关系
rabbitmqctl list_bindings -p /order_vhost

七、消息发布、消费、测试命令（调试专用）
1. 命令行发送消息（指定交换机、路由 key、消息体）
rabbitmqadmin -V /order_vhost publish exchange=direct_order routing_key=order_rk payload='{"order_id": "ORD001"}'

2. 命令行消费消息（手动 ack，调试用，生产不使用）
rabbitmqadmin -V /order_vhost get queue=queue_order ackmode=ack_requeue_false count=1

八、镜像队列策略（集群高可用，消息多副本）
给所有队列设置镜像，同步到集群全部节点
rabbitmqctl set_policy -p /order_vhost ha-all "^" '{"ha-mode": "all"}'
查看策略
rabbitmqctl list_policies -p /order_vhost
删除策略
rabbitmqctl clear_policy -p /order_vhost ha-all

九、集群运维命令
1. 查看集群所有节点状态
rabbitmqctl cluster_status

2. 从节点加入集群（从节点执行）
rabbitmqctl stop_app
rabbitmqctl join_cluster rabbit@主节点主机名
rabbitmqctl start_app

3. 退出集群（节点单独拆分）
rabbitmqctl stop_app
rabbitmqctl reset
rabbitmqctl start_app

十、故障排查、监控、诊断命令大全
1. 查看所有客户端连接（IP、账号、队列、空闲时间）
rabbitmqctl list_connections name user state

2. 强制断开异常客户端连接
rabbitmqctl close_connection "连接标识" "断开原因"

3. 查看消费者列表（哪个进程在消费哪个队列）
rabbitmqctl list_consumers -p /order_vhost

4. 磁盘/内存告警状态
rabbitmqctl status | grep disk
rabbitmqctl status | grep memory

5. 导出完整诊断日志（故障上报）
rabbitmq-diagnostics status > rabbit_status.log
rabbitmq-diagnostics environment > rabbit_env.log

6. 重置节点（清空所有数据、用户、队列，慎用！）
rabbitmqctl stop_app
rabbitmqctl reset
rabbitmqctl start_app

十一、备份与恢复命令（数据容灾）
1. 全量元数据备份（交换机、队列、用户、vhost、权限策略）
rabbitmqctl export_definitions /data/rabbit_backup.json -u admin -p Admin@2026

2. 恢复元数据（重装/故障重建后导入）
rabbitmqctl import_definitions /data/rabbit_backup.json -u admin -p Admin@2026

十二、从零学习完整目录（学习路线）
阶段 1：基础环境
1. 安装 RabbitMQ，认识目录结构
2. 服务启停、开启 web 管理插件
3. 创建管理员账号，删除默认 guest 高危账号

阶段 2：资源隔离（生产规范）
1. vhost 虚拟主机创建、业务拆分隔离
2. 用户创建、最小权限分配、角色区分

阶段 3：四大交换机与队列核心概念
1. Direct 直连：点对点订单、短信
2. Topic 主题：日志分级、多标签订阅
3. Fanout 扇形：全局广播通知
4. Headers 头部：极少使用，复杂多条件匹配
5. 队列声明、绑定关系、持久化开关

阶段 4：消息可靠机制（开发核心）
1. 三层持久化：交换机 durable、队列 durable、消息 delivery_mode = 2
2. ACK 确认：自动 ack（禁用）/手动 ack（生产强制）
3. QOS 预取：prefetch_count 控制批量拉取，防止内存溢出
4. 死信队列 DLX：消息过期、消费失败自动转发兜底

阶段 5：Python 开发实操
1. pika 客户端连接封装（vhost+账号密码）
2. 四大交换机生产者、消费者代码
3. 死信队列实现、消息幂等处理（解决重复消费）
4. 连接重连、异常捕获、日志规范

阶段 6：运维与高可用
1. 常用命令行日常巡检（队列积压、连接、消费者）
2. 镜像队列集群部署、节点扩容
3. 元数据备份恢复、故障排查
4. 消息丢失、消息积压、重复消费排障方案

阶段 7：生产避坑规范
1. 禁止 guest 账号、禁止 0.0.0.0 外网无密码暴露
2. 所有业务交换机、队列必须持久化
3. 消费者关闭自动 ack，业务完成手动确认
4. 配置死信队列，避免失败消息无限重试堵塞队列
5. 不同业务拆分独立 vhost，互不干扰
6. 监控队列积压、磁盘使用率、客户端连接异常
```


**⑤ 🎯 面试考点**：
- 工作队列模式？答：一个队列多消费者分摊任务。
- 轮询 vs 公平分发？答：轮询均发（可能忙闲不均）；prefetch=1 公平分发（处理完才发下条）。
- 信道 channel 作用？答：复用一个 TCP 连接的多路信道，省连接开销。

### 开发视角学RabbitMQ

**① 一句话本质**：开发视角 = 生产者/消费者代码 + 发布确认 + 死信队列/延时队列实现。


``` md
RabbitMQ Python 开发完整从零实战
1. 开发使用场景（什么业务必须用 MQ）
2. 环境安装、基础概念
3. 四大交换机 + 队列持久化/消息持久化
4. 生产者、消费者代码实战
5. 死信队列、消息丢失/重复消费业务解决方案
6. 生产开发规范避坑

安装 Python RabbitMQ 客户端 pika（官方标准库）
pip3 install pika

一、Python 开发 RabbitMQ 适用业务场景（开发判断标准）
cat > 00_scene_intro.py <<'EOF'
业务场景 1：异步解耦（最常用）
举例：用户下单后，同步逻辑只完成创建订单；
异步任务：发短信、发推送、积分发放、日志记录、优惠券发放
不用同步串行执行，提升接口响应速度，用户无等待

业务场景 2：流量削峰填谷（秒杀、活动大流量）
秒杀瞬间几万请求，直接操作数据库会压垮 DB；
请求全部存入 MQ，消费者匀速消费，控制数据库写入 QPS

业务场景 3：最终一致性分布式事务
跨服务操作：下单 → 扣库存 → 支付；
某服务失败，通过 MQ 重试、回滚消息保证数据最终一致

业务场景 4：广播通知（多服务同时接收同一条消息）
配置更新、系统公告、活动上线通知；
一个消息发给订单服务、库存服务、统计服务同时处理

业务场景 5：延时任务
订单 30 分钟未支付自动取消、优惠券到期提醒、定时推送消息

业务场景 6：日志/大数据采集分流
业务日志统一投递 MQ，消费端分发到 ES、Hive、监控系统

不建议使用场景：
1. 需要强实时同步、强一致性（优先本地事务）
2. 简单单机同步小任务（直接函数调用，引入 MQ 增加复杂度）
3. 仅单机运行、无异步需求的小型工具项目
print("RabbitMQ Python 适用场景讲解完成")
EOF
python3 00_scene_intro.py

二、RabbitMQ 核心基础概念（开发必懂）
1. Producer 生产者：发送消息的 Python 程序
2. Consumer 消费者：监听队列、处理消息的 Python 程序
3. Queue 队列：存储消息，消息最终存在队列里
4. Exchange 交换机：接收生产者消息，按规则路由到队列（4 种类型）
5. Binding 绑定：交换机和队列之间的绑定关系，携带路由 key
6. Vhost 虚拟主机：多业务隔离，独立权限、交换机、队列
7. 持久化三要素：交换机持久、队列持久、消息持久（防宕机丢失）
8. ACK 确认机制：手动/自动确认，控制消息是否重新投递

三、基础直连交换机 Direct（点对点业务，订单、短信）
cat > 01_direct_demo.py <<'EOF'
import pika

通用连接封装
def get_connection():
    # 连接参数，生产使用内网 IP、账号密码，禁止 guest 外网访问
    credentials=pika.PlainCredentials("admin", "Admin@2026")
    conn_params=pika.ConnectionParameters(
        host="127.0.0.1",
        port=5672,
        virtual_host="/biz_vhost",
        credentials=credentials
    )
    connection=pika.BlockingConnection(conn_params)
    return connection

1. 生产者 Direct 直连交换机
def producer_direct():
    conn=get_connection()
    channel=conn.channel()

    # 1. 声明持久化交换机 direct_order，类型 direct，durable = True 持久
    channel.exchange_declare(
        exchange="direct_order",
        exchange_type="direct",
        durable=True
    )
    # 2. 声明持久化队列
    channel.queue_declare(queue = "queue_order", durable = True)
    # 3. 交换机绑定队列，路由 key = order_routing
    channel.queue_bind(
        exchange="direct_order",
        queue="queue_order",
        routing_key="order_routing"
    )

    # 发送消息，delivery_mode = 2 开启消息持久化
    msg_body='{"order_id": "ORD001", "user_id": 1001, "amount": 99}'
    channel.basic_publish(
        exchange="direct_order",
        routing_key="order_routing",
        body=msg_body,
        properties=pika.BasicProperties(
            delivery_mode=2,  # 消息持久化，宕机不丢失
        )
    )
    print(f "生产者发送订单消息: {msg_body}")
    conn.close()

2. 消费者 Direct 直连交换机
def consumer_direct():
    conn=get_connection()
    channel=conn.channel()
    channel.exchange_declare(exchange = "direct_order", exchange_type = "direct", durable = True)
    channel.queue_declare(queue = "queue_order", durable = True)
    channel.queue_bind(exchange = "direct_order", queue = "queue_order", routing_key = "order_routing")

    # 核心：关闭自动 ACK，改为手动确认（生产强制开启，防止消息丢失）
    channel.basic_consume(
        queue="queue_order",
        on_message_callback=callback,
        auto_ack=False
    )
    print("消费者等待订单消息...")
    channel.start_consuming()

消息处理回调函数
def callback(ch, method, properties, body):
    msg=body.decode("utf-8")
    print(f "收到订单消息: {msg}")
    try:
        # 执行业务逻辑：创建订单、扣减库存、发短信
        print("业务处理完成")
        # 手动 ACK 确认，告知 MQ 消息处理完毕，可以删除
        ch.basic_ack(delivery_tag = method.delivery_tag)
    except Exception as e:
        # 业务异常，NACK，消息重新入队重试
        print(f "处理失败，消息重发: {e}")
        ch.basic_nack(delivery_tag = method.delivery_tag, requeue = True)

if __name__ == '__main__':
    # 发送一条消息
    producer_direct()
    # 启动消费者监听（注释生产者，单独运行消费者持续监听）
    # consumer_direct()
EOF
运行生产者发送消息
python3 01_direct_demo.py
新开终端注释 producer_direct，打开 consumer_direct 运行消费

四、Topic 主题交换机（日志分级、多标签订阅，通配符匹配）
* 匹配单个单词  # 匹配 0 或多个单词
cat > 02_topic_demo.py <<'EOF'
import pika

def get_connection():
    credentials=pika.PlainCredentials("admin", "Admin@2026")
    conn=pika.BlockingConnection(pika.ConnectionParameters("127.0.0.1", 5672, "/biz_vhost", credentials))
    return conn

生产者：推送不同级别日志
def producer_topic():
    conn=get_connection()
    ch=conn.channel()
    ch.exchange_declare(exchange = "topic_log", exchange_type = "topic", durable = True)

    # 三条不同路由 key 日志
    logs=[
        ("log.info.order", "订单正常日志"),
        ("log.error.pay", "支付异常日志"),
        ("log.warn.goods", "商品库存警告日志")
    ]
    for rk, content in logs:
        ch.basic_publish(
            exchange="topic_log",
            routing_key=rk,
            body=content,
            properties=pika.BasicProperties(delivery_mode = 2)
        )
        print(f "发送日志 rk:{rk} 内容:{content}")
    conn.close()

消费者 1：只接收 error 级日志 rk 匹配 log.error.#
def consumer_error_log():
    conn=get_connection()
    ch=conn.channel()
    ch.exchange_declare(exchange = "topic_log", exchange_type = "topic", durable = True)
    # 临时队列，自动删除
    res=ch.queue_declare(queue = "", exclusive = True)
    queue_name=res.method.queue
    ch.queue_bind(exchange = "topic_log", queue = queue_name, routing_key = "log.error.#")
    ch.basic_consume(queue = queue_name, on_message_callback = callback, auto_ack = False)
    print("【错误日志消费者】监听中")
    ch.start_consuming()

def callback(ch, method, props, body):
    print(f "收到日志: {body.decode()}")
    ch.basic_ack(method.delivery_tag)

if __name__ == '__main__':
    producer_topic()
    # consumer_error_log()
EOF
python3 02_topic_demo.py

五、Fanout 扇形交换机（广播，所有绑定队列全接收）
系统通知、配置刷新，无视 routing_key
cat > 03_fanout_demo.py <<'EOF'
import pika
def get_connection():
    cred=pika.PlainCredentials("admin", "Admin@2026")
    return pika.BlockingConnection(pika.ConnectionParameters("127.0.0.1", 5672, "/biz_vhost", cred))

def producer_fanout():
    conn=get_connection()
    ch=conn.channel()
    ch.exchange_declare(exchange = "fanout_notice", exchange_type = "fanout", durable = True)
    msg="系统配置更新通知，请各服务重载配置"
    ch.basic_publish(exchange = "fanout_notice", routing_key = "", body = msg, properties = pika.BasicProperties(delivery_mode = 2))
    print("广播通知已发送")
    conn.close()

多个消费者都会收到同一条广播消息
def consumer_notice():
    conn=get_connection()
    ch=conn.channel()
    ch.exchange_declare(exchange = "fanout_notice", exchange_type = "fanout", durable = True)
    q=ch.queue_declare("", exclusive = True)
    ch.queue_bind(exchange = "fanout_notice", queue = q.method.queue)
    ch.basic_consume(queue = q.method.queue, on_message_callback = cb, auto_ack = False)
    print("通知消费者监听中")
    ch.start_consuming()

def cb(ch, method, props, body):
    print(f "收到广播: {body.decode()}")
    ch.basic_ack(method.delivery_tag)

if __name__ == '__main__':
    producer_fanout()
EOF
python3 03_fanout_demo.py

六、消息丢失、重复消费、死信队列 生产核心解决方案（Python）
cat > 04_dlx_safe_msg.py <<'EOF'
import pika
import time

def get_conn():
    cred=pika.PlainCredentials("admin", "Admin@2026")
    return pika.BlockingConnection(pika.ConnectionParameters("127.0.0.1", 5672, "/biz_vhost", cred))

1. 死信队列 DLX 配置（消息重试耗尽转入死信，不丢失）
def init_dlx():
    conn=get_conn()
    ch=conn.channel()
    # 死信交换机、死信队列
    ch.exchange_declare("dlx_ex", "direct", durable = True)
    ch.queue_declare("dlx_queue", durable = True)
    ch.queue_bind("dlx_ex", "dlx_queue", "dlx_rk")

    # 业务队列绑定死信参数：消息过期/被拒绝则转发到死信交换机
    args={
        "x-dead-letter-exchange": "dlx_ex",
        "x-dead-letter-routing-key": "dlx_rk",
        "x-message-ttl": 30000,  # 消息 30 秒过期
        "x-max-retry": 3  # 最大重试 3 次
    }
    ch.queue_declare("biz_queue", durable = True, arguments = args)
    ch.exchange_declare("biz_ex", "direct", durable = True)
    ch.queue_bind("biz_ex", "biz_queue", "biz_rk")
    conn.close()
    print("死信队列初始化完成")

生产者（完整持久化，防止生产端丢消息）
def safe_producer():
    conn=get_conn()
    ch=conn.channel()
    # 开启生产者确认，消息落盘后返回 ack，确保不丢失
    ch.confirm_delivery()
    ch.exchange_declare("biz_ex", "direct", durable = True)
    msg='{"pay_id": 10086}'
    # mandatory：无法路由的消息返回生产者，不丢弃
    success=ch.basic_publish(
        exchange="biz_ex",
        routing_key="biz_rk",
        body=msg,
        mandatory=True,
        properties=pika.BasicProperties(delivery_mode = 2)
    )
    if success:
        print("消息投递成功")
    else:
        print("消息投递失败，本地日志重试")
    conn.close()

消费者 手动 ACK，解决丢失与重复消费
def safe_consumer():
    conn=get_conn()
    ch=conn.channel()
    ch.basic_qos(prefetch_count = 1)  # 公平分发，一次只拿一条消息
    ch.basic_consume(
        queue="biz_queue",
        on_message_callback=safe_cb,
        auto_ack=False
    )
    print("安全消费者启动")
    ch.start_consuming()

def safe_cb(ch, method, props, body):
    msg=body.decode()
    print(f "处理消息: {msg}")
    try:
        # 业务逻辑，必须实现幂等，防止重复消费
        # 幂等方案：消息唯一 ID 查询数据库是否已处理
        unique_id=props.message_id
        print(f "幂等校验 ID:{unique_id}")
        # 模拟正常处理
        # 手动确认
        ch.basic_ack(method.delivery_tag)
    except Exception as e:
        print(f "处理异常，重试: {e}")
        # 拒绝消息，不重回原队列，进入死信
        ch.basic_nack(method.delivery_tag, requeue = False)

if __name__ == '__main__':
    init_dlx()
    safe_producer()
    # safe_consumer()
EOF
python3 04_dlx_safe_msg.py

七、Python 开发生产规范&避坑
cat > 05_dev_rule.py <<'EOF'
1. 连接管理
长连接复用，不要每次发送新建连接；多线程每个线程独立 channel
捕获连接断开异常，自动重连机制

2. 防消息丢失三层保障
生产者：开启 confirm 确认、mandatory、消息持久化
服务端：交换机 durable、队列 durable、delivery_mode = 2
消费者：关闭 auto_ack，业务成功后手动 ack

3. 重复消费唯一解决方案：业务幂等
每条消息携带唯一 message-id，消费前查询数据库是否已处理；
数据库唯一主键约束，重复插入直接报错，不产生脏数据

4. 流量控制
消费者设置 basic_qos(prefetch_count = N)，防止一次性拉取海量消息占满内存

5. 禁止长耗时业务
单条消息处理不能过长，否则 ACK 超时，消息反复重试阻塞队列

6. 多业务隔离
不同业务创建独立 vhost，独立账号，权限最小化，不共用队列交换机

7. 死信必须配置
失败消息不无限重试，转入死信队列人工排查，避免队列无限堆积

8. 日志规范
每条消息打印唯一 ID、内容、处理耗时，方便排查丢失/重复问题
print("RabbitMQ Python 开发规范讲解完成")
EOF
python3 05_dev_rule.py

核心速记
1. 使用场景：异步解耦、削峰、广播、延时任务、分布式事务
2. 四大交换机：Direct 点对点、Topic 通配订阅、Fanout 广播、Headers 极少使用
3. 安全三要素：生产者 confirm、持久化、手动 ACK
4. 消息异常兜底：死信队列 DLX
5. 重复消费根治：业务幂等（唯一 ID 去重）
6. 开发底线：禁止自动 ACK、禁止无持久化、不共用 vhost、长连接复用
```


**⑤ 🎯 面试考点**：
- publisher confirm？答：生产者确认消息到 broker，防丢失（异步 confirm）。
- 死信队列？答：消息被拒/过期/TTL 到转入 DLX，用于重试/审计。
- 延时消息？答：TTL+死信实现（或插件 delayed-message）。

### Kafka

**① 一句话本质**：Kafka = 高吞吐分布式日志系统，核心是 topic + partition + consumer group。


- 集群部署、broker/topic/ 分区 / 副本
- 生产者、消费者工作机制
- 日志采集场景运维
- 磁盘刷盘、副本同步、性能调优
- 消息堆积、消费异常排查

``` md
Kafka 分布式消息队列 生产运维全栈
1. 核心概念：broker/topic/分区/副本 | 2. 3 节点集群部署
3. 生产者/消费者工作机制 | 4. 日志采集场景运维
5. 性能调优：磁盘刷盘+副本同步 | 6. 故障排查：堆积/消费异常

一、核心基础概念
1. Broker：Kafka 服务节点，一台服务器运行一个 broker，多节点组成集群
2. Topic：消息主题，业务逻辑分类，相当于消息的 "逻辑队列"
3. Partition 分区：Topic 的物理分片，一个 topic 拆分为 N 个分区分布在不同 broker
分区是 Kafka 高并发的基础：生产者并行写，消费者并行读
单分区内消息严格有序，多分区整体无序
每个分区对应一个物理日志文件，顺序追加写入，性能极高
4. Replica 副本：每个分区有多份副本，保证高可用与数据冗余
Leader 副本：唯一负责读写，生产者、消费者只与 leader 交互
Follower 副本：只从 leader 同步数据，不提供读写；leader 宕机时选举新 leader
ISR（In-Sync Replicas）：同步副本列表，与 leader 数据保持同步的副本集合
5. 集群元数据：传统架构依赖 Zookeeper 管理；3.x 新增 KRaft 模式，可无 ZK 独立运行

二、3 节点集群部署（生产标准 ZK 架构）
前置依赖：所有节点安装 JDK1.8+，提前搭建好 3 节点 Zookeeper 集群

1. 下载解压二进制包，配置环境变量
tar -zxf kafka_2.13-3.6.1.tgz -C /usr/local/
ln -s /usr/local/kafka_2.13-3.6.1 /usr/local/kafka
echo 'export PATH =$PATH:/usr/local/kafka/bin' >> /etc/profile
source /etc/profile

2. 目录规划（数据与日志分离）
mkdir -p /data/kafka/kafka-logs   # 分区消息数据目录
mkdir -p /var/log/kafka          # 服务运行日志目录
useradd -s /sbin/nologin kafka
chown -R kafka: kafka /data/kafka /var/log/kafka /usr/local/kafka

3. 节点 1 核心配置 server.properties（节点 2/3 仅修改 broker.id 与监听 IP）
cat > /usr/local/kafka/config/server.properties <<'EOF'
节点基础配置
broker.id = 1                     # 集群全局唯一，节点 2 设为 2，节点 3 设为 3
listeners=PLAINTEXT://192.168.1.10:9092  # 本机监听地址
advertised.listeners = PLAINTEXT://192.168.1.10:9092  # 对外广播的访问地址

存储配置
log.dirs =/data/kafka/kafka-logs  # 消息数据目录，多磁盘可配多个目录并行 IO
num.partitions = 3                 # Topic 默认分区数
default.replication.factor = 3     # 默认副本数，生产建议 3 副本保证高可用

Zookeeper 连接
zookeeper.connect = 192.168.1.10:2181,192.168.1.11:2181,192.168.1.12:2181/kafka
zookeeper.connection.timeout.ms = 6000

副本与可靠性
offsets.topic.replication.factor = 3   # 消费偏移量内置主题副本数
min.insync.replicas = 2                # ISR 最小副本数，配合 acks = all 使用
replica.lag.time.max.ms = 30000        # 副本落后超 30 秒踢出 ISR

消息留存
log.retention.hours = 72          # 消息默认保留 72 小时，按磁盘与业务调整
log.segment.bytes = 1073741824    # 单日志段最大 1G，满了自动滚动新文件
log.retention.check.interval.ms = 300000

性能基础参数
num.network.threads = 8           # 网络请求处理线程数
num.io.threads = 8                # 磁盘 IO 线程数
socket.send.buffer.bytes = 102400
socket.receive.buffer.bytes = 102400
EOF

4. 节点 2、节点 3 配置：仅修改 broker.id、listeners、advertised.listeners，其余参数完全对齐

5. 启动集群（每个节点后台启动）
su - kafka -c "kafka-server-start.sh -daemon /usr/local/kafka/config/server.properties"

6. 集群验证
查看所有在线 broker 节点
zookeeper-shell.sh 127.0.0.1:2181 ls /kafka/brokers/ids
创建测试 Topic
kafka-topics.sh --bootstrap-server 192.168.1.10:9092 \
create --topic test_topic --partitions 3 --replication-factor 3
查看 Topic 分区、副本、leader 分布
kafka-topics.sh --bootstrap-server 192.168.1.10:9092 --describe --topic test_topic

三、生产者 & 消费者核心工作机制

1. 生产者工作机制
流程：消息封装 → 分区分配 → 批量攒批 → 发送到对应分区 leader
#
① 分区分配策略
轮询策略：无 key 时默认，消息均匀分配到所有分区，负载均衡最优
Key 哈希策略：指定 key 时，相同 key 的消息写入同一分区，保证单 key 有序
自定义策略：按业务规则指定目标分区
#
② 可靠性核心：acks 应答机制
acks=0：发完即返回，不等待 broker 确认
✅ 性能最高 ❌ 可靠性最差，broker 宕机直接丢数据
acks=1：leader 写入成功就返回（默认值）
✅ 性能与可靠性平衡 ❌ leader 写入后 follower 同步前宕机，丢数据
acks=-1 / all：ISR 内所有副本都写入成功才返回
✅ 可靠性最高 ❌ 性能最低、延迟高，必须配合 min.insync.replicas 使用
#
③ 性能优化机制
批量发送：batch.size 攒满一批再发，减少网络交互
等待上限：linger.ms 到时间即使没攒满也发送，平衡延迟与吞吐
压缩传输：compression.type = lz4/snappy，减少网络带宽与磁盘占用
失败重试：retries 自动重试，避免临时网络波动丢消息

2. 消费者工作机制
核心概念：消费者组（Consumer Group）
一个组包含多个消费者实例，共同消费一个 topic
一个分区只能被组内 **一个** 消费者消费；一个消费者可消费多个分区
组间隔离：同一个 topic，不同消费组各自消费全量数据，互不影响
#
① 重平衡（Rebalance）
触发：消费者实例增减、topic 分区数变化、订阅主题变更
影响：重平衡期间消费组暂停消费，可能导致重复消费、延迟升高
优化：调大超时时间、减少消费者频繁启停、稳定实例数量
#
② Offset 消费偏移量
作用：记录消费者消费到分区的位置，重启后接续消费
存储：内置主题 __consumer_offsets 持久化存储所有组偏移量
提交方式：
自动提交：按时间间隔自动提交，简单但可能丢消息/重复消费
手动提交：业务处理完成后手动提交，精准可控，生产推荐
#
③ 消费语义
最多一次：自动提交，可能丢消息
至少一次：手动提交，处理完再提交，可能重复消费（生产默认）
精确一次：事务 + 幂等实现 Exactly Once，金融等核心场景用

四、日志采集场景运维（ELK 标准架构）
典型链路：Filebeat（采集） → Kafka（削峰缓冲） → Logstash/Flink（清洗） → ES（检索）

1. Topic 规划规范
按业务+日志类型划分，如 log_nginx_access、log_java_error、log_syslog
分区数评估：单分区写吞吐 10~20MB/s，按目标吞吐量反推分区数
副本数：核心日志 3 副本，非核心日志 2 副本
禁止：所有日志混发同一个 topic，导致消费隔离性差、故障影响面大

2. 消费组隔离
不同消费场景使用独立消费组，互不影响
例：实时检索组 group_log_es、离线分析组 group_log_hive、告警组 group_log_alert

3. 核心运维命令
查看所有 Topic 列表
kafka-topics.sh --bootstrap-server 127.0.0.1:9092 --list
查看消费组积压延迟（最核心运维指标）
kafka-consumer-groups.sh --bootstrap-server 127.0.0.1:9092 \
describe --group group_log_es
关键字段：
CURRENT-OFFSET：当前已消费位置
LOG-END-OFFSET：分区最新消息位置
LAG：消息积压量，核心告警指标

4. 运维要点
1. 留存周期：普通日志保留 3~7 天，审计日志按月留存
2. 消息大小：单条消息建议不超过 1MB，超大日志裁剪或转存对象存储
3. 分区扩容：消费能力不足时增加分区数+扩容消费者；分区只能加不能减
4. 监控告警：消费组 LAG、broker 磁盘使用率、分区 leader 均衡性必监控

五、性能调优：磁盘刷盘 + 副本同步 + 参数优化

1. 磁盘刷盘机制
Kafka 高性能核心：依赖操作系统页缓存（Page Cache），默认异步刷盘
写入路径：消息 → 操作系统页缓存 → 后台异步刷入磁盘
优势：顺序写入 + 页缓存，性能接近内存级
服务端调优参数
cat >> /usr/local/kafka/config/server.properties <<'EOF'
刷盘条数阈值（不建议调太小，会大幅降低性能）
log.flush.interval.messages = 10000
刷盘时间阈值
log.flush.interval.ms = 1000
生产原则：用副本机制保证可靠性，不强制同步刷盘，依赖系统异步刷盘保性能
EOF
系统层优化
使用 SSD 磁盘，顺序写入性能远高于机械盘
多块磁盘配置多个 log.dirs，并行 IO 提升吞吐量
关闭 swap，避免页缓存被交换到磁盘导致性能暴跌

2. 副本同步调优
核心目标：稳定 ISR 列表，减少副本频繁进出，保证数据可靠性
cat >> /usr/local/kafka/config/server.properties <<'EOF'
副本拉取线程数，提升同步速度
num.replica.fetchers = 4
单次拉取最大字节数
replica.fetch.max.bytes = 1048576
副本最大落后时长，超时踢出 ISR
replica.lag.time.max.ms = 30000
EOF

3. 生产端性能优化
吞吐优先：acks = 1 + 开启 lz4 压缩 + 调大 batch.size + linger.ms = 5
可靠优先：acks = all + min.insync.replicas = 2 + 开启重试

4. 消费端性能优化
消费者线程数与分区数对齐，不超过分区数
调大拉取批量，减少网络交互
手动批量提交 offset，减少提交开销

六、常见故障排查

故障 1：消息堆积（消费组 LAG 持续增长）
现象：业务日志处理延迟，监控 LAG 指标持续上升
排查步骤
1. 定位范围：全集群堆积还是单个消费组？全 topic 还是单个 topic？
kafka-consumer-groups.sh --bootstrap-server 127.0.0.1:9092 --describe --group 组名
查看各分区 LAG，判断是全部分区堆积还是个别分区热点堆积

2. 排查消费者状态
消费者服务是否存活、进程是否正常
消费者报错日志：反序列化失败、业务异常、重平衡频繁

常见根因与解决
根因 1：消费者服务宕机/重启，停止消费
解决：恢复服务，自动从上次 offset 接续消费
#
根因 2：消费逻辑慢，单条处理耗时久
解决：优化业务逻辑、减少慢查询/外部调用；增加消费者实例/线程
#
根因 3：分区热点，单分区消息量远超其他
解决：优化分区策略，打散热点 key；扩容分区重新分配
#
根因 4：频繁重平衡，消费持续中断
解决：调大 session.timeout.ms、max.poll.interval.ms；稳定消费者实例数量

故障 2：消费异常 / 消息丢失 / 重复消费
场景 A：消费报错，无法正常消费
排查：查看消费者错误日志
常见原因：
1. 消息格式异常，反序列化失败 → 配置死信队列，异常消息转存，不阻塞主链路
2. Offset 越界：消费位置超出分区当前范围 → 重置 offset 到最早/最新位置
重置命令：kafka-consumer-groups.sh --reset-offsets --to-earliest --topic topic 名 --group 组名 --execute
3. 权限不足 → 配置 ACL 权限

场景 B：消息丢失
根因 1：生产端 acks = 0，broker 未收到就返回成功
解决：核心业务改为 acks = 1/all，开启重试机制
根因 2：broker 接收后未刷盘就宕机，且无副本
解决：设置合理副本数，多副本冗余
根因 3：消费端自动提交 offset，业务未处理完就宕机
解决：改为手动提交，业务处理完成后再提交 offset

场景 C：重复消费
根因：手动提交前消费者宕机、重平衡导致消息重新投递
解决：
业务侧实现幂等性（唯一键去重、数据库唯一约束），是唯一根治方案
优化提交时机，缩小处理与提交的时间差
减少不必要的重平衡

故障 3：Broker 节点故障
现象：节点离线，分区 leader 重新选举，短暂不可用
排查：
1. 查看服务日志 /var/log/kafka/server.log 定位报错
2. 检查磁盘空间、内存、端口占用、ZK 连接状态
处理：
1. 单节点故障：集群自动选举新 leader，业务无感知；修复后重新加入集群
2. 多节点故障：优先恢复数据最完整的节点，保证 ISR 副本可用
3. 日志损坏：删除损坏日志段，从其他副本同步恢复

核心速记
1. 核心四要素：broker 节点、topic 分类、分区并发、副本高可用
2. 生产者：acks 三档平衡性能与可靠，批量压缩提吞吐
3. 消费者：组内分区一对一，offset 控进度，手动提交更可靠
4. 性能：依赖页缓存异步刷盘，SSD+多目录提 IO，多副本保可靠
5. 故障：堆积先查 LAG 与消费者，丢数据查 ack 与提交，重复靠幂等兜底
6. 日志运维：按业务分 topic，消费组隔离，LAG 是核心监控指标
```


**⑤ 🎯 面试考点**：
- partition 作用？答：并行单位（同 partition 有序）、提高吞吐；消费者按 partition 分配。
- offset 含义？答：消费者在 partition 上的消费位移，提交位点到 broker。
- rebalance？答：消费组成员变更触发重分配 partition，期间短暂停止消费（尽量少触发）。

### Kafka KRaft 模式（去掉 ZooKeeper，3.x+ 新架构）

**① 一句话本质**：KRaft = Kafka 去掉 ZooKeeper，自带共识元数据（Raft），部署与运维简化。


``` md
Kafka KRaft 模式（去掉 ZooKeeper，3.3+ 生产可用，面试高频）
一、为什么替代 ZK
1. 传统架构：Kafka 依赖 ZooKeeper 存元数据（leader、ISR、配置），多一套组件就多一套故障点
2. KRaft：Kafka 用内部 Raft 协议自己存元数据，部署简化、启动更快、元数据同步更稳定
3. 3.x 起逐步迁移，4.x 起 ZK 模式废弃

二、与传统部署的差异
1. 不再单独部署 ZK 集群，节点角色改为 combined（controller+broker）或独立 controller
2. server.properties 关键配置
process.roles = broker,controller
node.id = 1
controller.quorum.voters = 1@kafka1:9093, 2@kafka2:9093, 3@kafka3:9093
3. 首次启动前格式化存储目录（只执行一次，集群 ID 全局唯一）
kafka-storage.sh random-uuid           # 生成集群 ID
kafka-storage.sh format -t 集群ID -c config/server.properties

三、运维对比速记
1. 原来：先起 ZK 再起 Kafka，ZK 挂 = 集群元数据不可用
2. 现在：只起 Kafka，controller 角色内部选举，节点数建议 1/3/5 奇数
3. 排障：看 controller.log，而不是 zookeeper 日志
```

2. 企业文件存储服务


**⑤ 🎯 面试考点**：
- KRaft vs ZK 架构差异？答：去 ZooKeeper，元数据存 Kafka 自身（Raft quorum），部署简化少依赖。
- controller 选举？答：基于 Raft 选 controller 仲裁元数据。
- 迁移注意？答：老集群 ZK 转 KRaft 需滚动、双写元数据过渡。

### NFS 局域网共享

**① 一句话本质**：NFS = 网络文件系统，服务端 export 共享、客户端 mount 挂载，跨机共享文件。


- 服务端部署、exports 权限配置
- 客户端挂载、永久挂载 fstab
- 权限映射、读写故障、权限报错排查

``` md
NFS 局域网共享 从零完整教学（补充完整端口详解）
包含：简介/架构/原理/端口详解/服务端部署/exports 配置/客户端挂载/fstab 永久挂载/权限故障排查

一、NFS 简介、架构、工作原理、端口、核心概念
1. NFS 简介
Network File System 网络文件系统，Linux 局域网机器共享目录
一台服务端共享文件夹，多台客户端远程挂载使用，像本地文件夹一样读写
优势：局域网高速、原生 Linux 支持、配置简单；仅 Linux/Unix 互通，Windows 需额外客户端

2. 整体架构
服务端 Server：存放原始文件，开启 nfs 服务，配置共享目录权限 /etc/exports
客户端 Client：通过 mount 命令远程挂载服务端共享目录到本地路径
通信依赖 RPC 服务：NFS 本身无固定端口注册能力，由 rpcbind 统一管理端口映射

3. NFS 全套端口详细说明（重点补充）
固定端口（永久不变，防火墙必须放行）
1. rpcbind 端口：111（TCP/UDP）RPC 核心注册端口，客户端第一步先连 111 查询 NFS 各服务端口
2. NFS 主服务 nfs-server：2049（TCP/UDP）真正读写文件传输端口

动态随机端口（rpc.mountd、rpc.statd、rpc.lockd 每次重启随机分配，防火墙难放行）
mountd：挂载守护进程，处理客户端 mount 挂载请求，随机端口
statd：状态监控，检测客户端断开
lockd：文件锁，防止多机器同时写文件冲突

企业固定动态端口方案（生产必配，避免防火墙拦截）
编辑 /etc/sysconfig/nfs，写入固定端口
RQUOTAD_PORT=4001
LOCKD_TCPPORT=4002
LOCKD_UDPPORT=4002
MOUNTD_PORT=4003
STATD_PORT=4004
STATD_OUTGOING_PORT=4005
修改后重启 rpcbind、nfs-server，全部辅助端口固定，防火墙统一放行 4001-4005

防火墙完整放行端口清单
111 tcp/udp、2049 tcp/udp、4001-4005 tcp/udp

4. 工作原理（结合端口流程）
1) 服务端启动 rpcbind(111)、nfs-server(2049)、mountd/statd/lockd，向 111 端口注册所有子服务端口
2) 客户端先连接服务端 111 端口(rpcbind)，查询 nfs、mountd 等对应端口号
3) 客户端使用 mountd 端口发送挂载请求，校验 IP、exports 权限
4) 挂载成功后，客户端通过 2049 端口读写远程文件
5) lockd/statd 负责文件锁、断线重连检测
6) 所有增删改文件实际操作服务端磁盘

5. 必备核心概念
/etc/exports：NFS 核心配置文件，定义共享目录、允许 IP、权限参数
rpcbind：RPC 端口注册服务，NFS 启动必须依赖，固定 111 端口
nfs-server：NFS 主程序，固定 2049 端口
权限映射 root_squash：客户端 root 用户会被压缩为 nobody 普通用户（安全默认）
no_root_squash：不压缩 root，客户端 root 等同于服务端 root（不安全，谨慎用）
sync：同步写入，数据落盘才返回成功，稳定；async 异步，性能高易丢数据
ro：只读权限  rw：读写权限

二、NFS 服务端部署（CentOS/RHEL，含端口固化+防火墙）
1. 安装依赖包
yum install -y nfs-utils rpcbind

2. 固化动态辅助端口（解决随机端口防火墙拦截问题）
vim /etc/sysconfig/nfs
末尾追加
RQUOTAD_PORT=4001
LOCKD_TCPPORT=4002
LOCKD_UDPPORT=4002
MOUNTD_PORT=4003
STATD_PORT=4004
STATD_OUTGOING_PORT=4005

3. 启动并设置开机自启（顺序不能变：先 rpcbind 后 nfs）
systemctl enable --now rpcbind
systemctl enable --now nfs-server

4. 防火墙完整放行所有端口（固化端口后统一放行）
firewall-cmd --add-service=nfs --permanent
firewall-cmd --add-service=rpc-bind --permanent
firewall-cmd --add-port=111/tcp --permanent
firewall-cmd --add-port=111/udp --permanent
firewall-cmd --add-port=2049/tcp --permanent
firewall-cmd --add-port=2049/udp --permanent
firewall-cmd --add-port=4001-4005/tcp --permanent
firewall-cmd --add-port=4001-4005/udp --permanent
firewall-cmd --reload

5. 创建要共享的目录，设置基础权限
mkdir -p /data/nfs_share
chmod 777 /data/nfs_share

6. 编辑核心配置文件 /etc/exports
vim /etc/exports
写入配置模板，格式：共享目录 允许客户端 IP(权限参数)
示例 1：仅 192.168.1.0 网段所有机器可读可写
/data/nfs_share 192.168.1.0/24(rw, sync, root_squash, no_all_squash)
示例 2：仅单台客户端 192.168.1.10 只读
/data/nfs_share 192.168.1.10(ro, sync, root_squash)

参数详解：
rw 读写 | ro 只读
sync 同步写入（推荐）
root_squash 客户端 root 转为 nobody（安全默认）
no_all_squash 普通用户保留原有 UID/GID

7. 重载 exports 配置，无需重启服务
exportfs -r
查看当前生效共享列表
exportfs -v

8. 查看当前 NFS 所有注册端口（验证固化是否生效）
rpcinfo -p 127.0.0.1

9. 验证本机共享是否正常
showmount -e 127.0.0.1

三、客户端部署、临时挂载
1. 客户端安装工具
yum install -y nfs-utils

2. 查看服务端可共享目录（服务端 IP 192.168.1.50）
showmount -e 192.168.1.50
连接失败排查：服务端 111、2049、4001-4005 端口防火墙未放行

3. 创建本地挂载点
mkdir -p /mnt/nfs_client

4. 临时挂载（重启失效）
mount -t nfs 192.168.1.50:/data/nfs_share /mnt/nfs_client

5. 查看已挂载分区
df -h

6. 临时卸载
umount /mnt/nfs_client

四、永久挂载 /etc/fstab 开机自动挂载
vim /etc/fstab
写入格式：服务端 IP: 共享目录 本地挂载点 文件系统类型 权限 备份自检
192.168.1.50:/data/nfs_share  /mnt/nfs_client  nfs  defaults,_netdev  0 0
参数 _netdev：告诉系统这是网络设备，等网卡启动后再挂载，避免开机找不到端口挂载失败

生效 fstab 配置，不重启验证
mount -a

五、权限映射、读写报错、端口故障完整排查
故障 1：客户端无法写入文件，提示 Permission denied
原因 1：服务端共享目录本地权限不足（文件夹 775/755 无写权限）
修复：chmod 777 /data/nfs_share

原因 2：root_squash 压缩，客户端 root 变成 nobody，目录不属于 nobody
修复方案 A（安全推荐）：目录归属 nobody
chown nobody: nobody /data/nfs_share
修复方案 B（内网信任环境，不推荐外网）：配置 no_root_squash
修改/etc/exports：/data/nfs_share 192.168.1.0/24(rw, sync, no_root_squash)
exportfs -r

故障 2：showmount -e 连接超时/无响应（端口类故障）
1. 服务端 rpcbind、nfs-server 未启动 systemctl status rpcbind nfs-server
2. 防火墙未放行 111、2049、4001-4005 端口
3. 未固化 mountd 等端口，每次重启端口随机，防火墙拦截
4. 客户端与服务端不在同一网段，IP 规则未放行

故障 3：mount -a 开机挂载失败，找不到共享目录
fstab 缺少 _netdev 参数，系统网卡没起来就执行挂载，端口未监听
修复：defaults,_netdev

故障 4：能读不能写，exports 配置写成 ro 只读
修复：修改/etc/exports 参数为 rw，执行 exportfs -r 重载

故障 5：文件创建后属主显示 nobody
正常现象，root_squash 机制；多客户端账号统一 UID/GID 可解决用户错乱问题

故障 6：文件多机器同时编辑报错 lock 冲突
lockd 端口未放行，文件锁功能失效，补齐 4002 端口防火墙规则

六、常用快捷命令总结
服务端重载共享配置
exportfs -r
查看共享
exportfs -v
查看 RPC 全部注册端口（端口排查核心命令）
rpcinfo -p 本机 IP
客户端查看服务端共享
showmount -e 服务端 IP
挂载/卸载
mount -t nfs IP:/共享目录 本地路径
umount 挂载点
开机挂载校验
mount -a
查看 nfs 服务状态
systemctl status nfs-server rpcbind
查看端口监听
netstat -lntp | grep -E "rpcbind|nfs"
ss -lntp | grep -E "rpcbind|nfs"
```


**⑤ 🎯 面试考点**：
- no_root_squash 安全风险？答：客户端 root 映射为服务端 root，极高风险，禁用。
- 挂载选项？答：vers（协议版本）、nolock、rw/ro、hard/soft。
- exports 权限？答：rw/ro、root_squash（默认安全）、sync/async。

### Samba 跨平台共享

**① 一句话本质**：Samba = 在 Linux 上实现 SMB/CIFS，让 Windows 与 Linux 互通文件共享。


- Windows-Linux 文件互通
- 独立 smb 用户、权限管控
- 共享目录权限、访问故障排查

``` md
Samba 跨平台文件共享 从零完整教学
覆盖：简介/架构/原理/端口/核心概念 | Linux <=> Windows 互通 | SMB 独立用户 | 权限管控 | 故障排查
环境：CentOS7/8/RHEL

一、Samba 基础：简介、架构、工作原理、端口、核心概念
1. Samba 简介
Samba 实现 SMB/CIFS 协议，实现 Linux 与 Windows、macOS 跨局域网文件共享
NFS 仅 Linux 互通；Samba 主打 Windows ↔ Linux 双向访问，打印机共享也支持

2. 架构组成
服务端两个核心进程：
smbd：处理文件读写、权限、共享目录（核心）
nmbd：NetBIOS 名称解析，Windows 可通过主机名访问 Linux 共享，不用输 IP
客户端：Windows 资源管理器 / Linux mount -t cifs

3. 完整工作原理
1. Windows 客户端输入 \\LinuxIP 发起 NetBIOS 查询，nmbd 解析主机名
2. 客户端连接 smbd 端口，发起 SMB 握手
3. 校验 SMB 独立账号密码（和系统 Linux 账号分离）
4. 权限双层校验：Samba 配置权限 + Linux 本地目录读写权限
5. 校验通过，挂载/读写远程目录；所有文件实际存 Linux 服务端磁盘

4. 全套端口（防火墙必须放行）
139/TCP/UDP：nmbd NetBIOS 名称服务
445/TCP：SMB 文件共享主端口（Windows 主流只用 445）
5. 核心必备概念
/etc/samba/smb.conf：Samba 主配置文件，定义共享目录、权限
smbpasswd：Samba 独立密码工具，SMB 账号必须单独设密码（Linux 系统用户 ≠Samba 用户）
security=user：账号密码认证模式（默认，企业通用）
read only = no / yes：共享读写开关
browseable=yes：Windows 网络邻居可见该共享
valid users：限制允许访问的 smb 用户
create mask / directory mask：客户端新建文件/文件夹默认权限
writable：等价 read only = no，开启写入

二、服务端完整部署 Linux（CentOS）
1. 安装软件包
yum install -y samba samba-client

2. 开机自启，启动服务（smbd nmbd）
systemctl enable --now smbd nmbd
systemctl status smbd nmbd

3. 防火墙放行 Samba 端口
firewall-cmd --add-service=samba --permanent
手动放行端口备用
firewall-cmd --add-port=139/udp --permanent
firewall-cmd --add-port=139/tcp --permanent
firewall-cmd --add-port=445/tcp --permanent
firewall-cmd --reload

4. 创建共享目录 + 设置基础 Linux 权限
mkdir -p /data/samba_share
最低权限保证可读写
chmod 777 /data/samba_share

5. 创建系统用户（必须先有 Linux 系统用户，才能生成 SMB 账号）
useradd smbuser
可选设置系统登录密码（不用登录 Linux 可跳过）
passwd smbuser

6. 给系统用户设置 Samba 独立密码（关键！Windows 访问靠这个密码）
smbpasswd -a smbuser
a 添加；-d 禁用；-x 删除 smb 账号

7. 编辑主配置文件 /etc/samba/smb.conf
vim /etc/samba/smb.conf
配置模板
[global]
   workgroup=WORKGROUP    # 和 Windows 工作组保持一致
   security=user
   map to guest = Bad User  # 禁止匿名访问
   netbios name = Linux-Server

自定义共享段 [共享名] Windows 访问 \\IP\share
[myshare]
   path=/data/samba_share
   browseable=yes        # 网络邻居可见
   read only = no          # 允许读写
   writable=yes
   valid users = smbuser   # 仅 smbuser 可访问
   create mask = 0644      # 新建文件权限
   directory mask = 0755   # 新建文件夹权限

8. 校验配置语法（报错立即修复）
testparm

9. 重载 Samba 配置，不用重启服务
systemctl reload smbd

10. 查看当前生效共享列表
smbclient -L //127.0.0.1 -U smbuser

三、Windows 访问 Linux Samba 共享
方式 1：Win+R 输入地址
\\192.168.1.100  # Linux 服务端 IP
弹窗输入用户名：smbuser  密码：smbpasswd 设置的密码

方式 2：映射网络驱动器（永久使用）
此电脑 → 右键映射网络驱动器
文件夹输入：\\192.168.1.100\myshare
勾选登录时重新连接，输入 smb 账号密码

四、Linux 客户端挂载 Windows 共享 / Linux 互访 Samba
1. 客户端安装工具
yum install -y cifs-utils

2. 临时挂载 Windows 共享（重启失效）
mkdir /mnt/win_share
mount -t cifs //192.168.1.200/share /mnt/win_share -o username = Windows 账号, password = Windows 密码

3. /etc/fstab 永久开机挂载（推荐）
vim /etc/fstab
//192.168.1.200/share  /mnt/win_share  cifs  defaults,_netdev, username = winuser, password = 123456 0 0
_netdev 网络设备，等待网卡启动再挂载

五、SMB 独立用户完整管控命令
1. 创建 smb 账号（前提存在同名 Linux 系统用户）
useradd testuser
smbpasswd -a testuser

2. 修改 Samba 密码
smbpasswd testuser

3. 禁用 Samba 账号（无法访问共享，不删系统用户）
smbpasswd -d testuser

4. 彻底删除 Samba 账号
smbpasswd -x testuser

5. 查看所有 Samba 用户
pdbedit -L

六、双层权限逻辑（必懂，90%报错根源）
两层权限同时校验，任意一层无权限就报错拒绝访问
第一层：Samba 配置权限 smb.conf read only / valid users
第二层：Linux 本地目录文件系统权限 chmod/chown
示例：smb.conf 开了 writable，但文件夹 chmod = 700，依然无法写入

七、访问故障、权限报错完整排查
故障 1：Windows 输入 IP 提示无法访问、找不到网络路径
1. 服务端 smbd、nmbd 未启动 systemctl start smbd nmbd
2. 防火墙 139/445 端口未放行
3. 客户端与服务端不在同一局域网，路由拦截 139/445

故障 2：账号密码错误，拒绝登录
1. 混淆 Linux 系统密码与 Samba 密码：必须用 smbpasswd 单独设置
2. 用户名写错，smb 用户不存在：pdbedit -L 查看

故障 3：能进入共享文件夹，但无法新建/删除文件 Permission denied
原因 1：smb.conf read only = yes 只读，修改为 no
原因 2：Linux 目录本地权限不足 chmod 777 /data/samba_share
原因 3：valid users 未添加当前登录 smb 用户

故障 4：testparm 报配置语法错误
检查 smb.conf 括号、换行、参数拼写，共享段 [名称] 不能有空格

故障 5：网络邻居看不到共享文件夹
smb.conf browseable = yes，且 nmbd 服务正常运行

故障 6：Linux mount cifs 挂载失败
缺少 cifs-utils 工具包；fstab 账号密码写错；Windows 防火墙拦截 445

八、高频排查工具命令
校验配置
testparm
查看共享列表
smbclient -L //服务端 IP -U smb 用户名
交互式测试访问共享
smbclient //127.0.0.1/myshare -U smbuser
查看 samba 进程端口监听
ss -lntp | grep smbd
查看 smb 用户库
pdbedit -L
实时日志排错
tail -f /var/log/samba/log.smbd
```


**⑤ 🎯 面试考点**：
- SMB vs NFS 适用？答：SMB 面向 Windows 文件/打印共享；NFS 面向 Unix 文件。
- smb.conf 配置？答：[share] 段 path、valid users、read only、browseable。
- 用户映射？答：smbpasswd -a 加 Samba 用户（独立于系统口令）。

### FTP/VSFTPD

**① 一句话本质**：FTP = 文件传输协议，vsftpd 是主流安全服务端，分主动/被动两种模式。


- 匿名关闭、本地用户登录
- 上传下载权限、目录禁锢

``` md
VSFTPD/FTP 标准化学习架构全套脚本注释文档
统一学习标准：1 基础认知 2 服务端部署 3 用户权限管控 4 客户端使用 5 安全隔离 6 故障排查
适配系统：CentOS7/9 / Rocky Linux / Ubuntu20.04+
核心需求前置约束：关闭匿名登录、本地用户认证、上传下载权限可控、家目录 chroot 禁锢

###########################################################################
模块 1：基础认知（简介、架构、协议端口、专业概念）
###########################################################################
1.1 FTP 简介
FTP：文件传输协议，C/S 架构，明文传输账号密码，默认端口 21 控制端口
VSFTPD：Very Secure FTP Daemon，Linux 高性能轻量安全 FTP 服务端
核心模式：主动模式 PORT / 被动模式 PASV（生产环境强制使用被动模式）

1.2 双端口架构（控制通道+数据通道）
控制端口：21 永久固定，负责登录、命令交互（cd/ls/get/put）
主动模式数据端口：客户端随机高位端口 → 服务端 20 端口（防火墙极难放行，弃用）
被动模式数据端口：服务端自定义区间端口（示例 40000-50000），客户端连接此区间传输文件

1.3 核心专业概念
匿名用户 anonymous：无需系统账号，公开访问，生产环境必须关闭
本地用户 local_user：读取/etc/passwd 系统账号，密码/etc/shadow，企业主流认证方式
chroot 目录禁锢：限制用户登录后仅能访问自身家目录，禁止跨系统目录跳转
write_enable：全局写入总开关，控制所有用户上传/删除/修改权限
user_config_dir：用户独立配置目录，实现单用户差异化权限
umask：文件/目录默认权限掩码，local_umask = 022 生成文件 644、目录 755
user_list 黑白名单：精细化登录准入控制
PAM 认证：对接系统账号密码，vsftpd 默认依赖 pam_service_name = vsftpd

###########################################################################
模块 2：服务端标准化部署流程（安装 → 启停 → 防火墙 → 目录 → 配置 → 校验生效）
###########################################################################
2.1 软件安装
CentOS/RHEL 系
yum install -y vsftpd
Ubuntu/Debian 系
apt update && apt install -y vsftpd

2.2 服务启停、开机自启
systemctl enable --now vsftpd          # 开机自启+立即启动
systemctl start vsftpd                 # 启动服务
systemctl stop vsftpd                  # 停止服务
systemctl restart vsftpd               # 重启加载配置
systemctl reload vsftpd                # 平滑重载配置（不中断现有连接）
systemctl status vsftpd                # 查看运行状态

2.3 防火墙放行（控制端口 21 + 被动数据端口区间）
firewalld(CentOS)
firewall-cmd --permanent --add-service=ftp
firewall-cmd --permanent --add-port=40000-50000/tcp
firewall-cmd --reload
firewall-cmd --list-ports --list-services

ufw(Ubuntu)
ufw allow 21/tcp
ufw allow 40000:50000/tcp
ufw reload

2.4 标准化业务目录规划
1. 用户家目录统一规范 /home/ftp_xxx
2. 上传子目录单独隔离，家目录禁止写权限（适配 chroot 禁锢）
mkdir -p /etc/vsftpd/user_config_dir   # 单用户独立配置目录
mkdir -p /data/ftp_public              # 公共 FTP 存储目录（可选）

2.5 主配置文件标准化写入 /etc/vsftpd/vsftpd.conf
备份原始配置
cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak.$(date +%Y%m%d)
覆盖标准配置（关闭匿名、本地登录、chroot、被动端口、日志）
cat > /etc/vsftpd/vsftpd.conf << EOF
关闭匿名访问
anonymous_enable=NO
anon_upload_enable=NO
anon_mkdir_write_enable=NO
开启本地系统用户登录
local_enable=YES
全局上传写入总开关
write_enable=YES
默认权限掩码
local_umask=022
开启目录禁锢，用户无法跳出家目录
chroot_local_user=YES
chroot 根目录禁止可写，规避登录报错
allow_writeable_chroot=NO
被动模式端口范围
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=50000
单用户差异化配置目录
user_config_dir=/etc/vsftpd/user_config_dir
日志开启
xferlog_enable=YES
xferlog_file=/var/log/vsftpd.log
xferlog_std_format=YES
PAM 系统账号认证
pam_service_name=vsftpd
监听 ipv4，关闭 ipv6
listen=YES
listen_ipv6=NO
EOF

2.6 配置语法校验 + 生效重载
vsftpd /etc/vsftpd/vsftpd.conf        # 无输出 = 配置无语法错误
systemctl reload vsftpd

###########################################################################
模块 3：用户权限管控（账号管理 + 双层权限体系）
###########################################################################
3.1 系统 FTP 账号标准化管理
创建专用 FTP 用户，不允许 ssh 登录（安全加固）
useradd -m -s /sbin/nologin ftp01
passwd ftp01                           # 设置 FTP 登录密码
userdel -r ftp01                       # 删除用户+家目录

修正家目录权限（chroot 强制要求父目录不可写）
chmod 755 /home/ftp01
mkdir /home/ftp01/upload
chmod 775 /home/ftp01/upload
chown ftp01: ftp01 /home/ftp01/upload

3.2 双层权限管控架构
第一层：全局总控制（vsftpd.conf write_enable）
全局开启 write_enable = YES：所有本地用户均可上传下载
全局关闭 write_enable = NO：所有用户默认只读，需单独配置开启上传

第二层：单用户独立差异化权限（user_config_dir）
示例：仅 ftp01 允许上传，其他用户只读
echo "write_enable = YES" > /etc/vsftpd/user_config_dir/ftp01
chmod 644 /etc/vsftpd/user_config_dir/ftp01
chown root: root /etc/vsftpd/user_config_dir/ftp01

3.3 登录黑白名单控制
userlist_enable=YES
userlist_file=/etc/vsftpd/user_list
userlist_deny=NO  # 白名单：仅文件内用户可登录 FTP
userlist_deny=YES # 黑名单：文件内用户禁止登录 FTP
echo "ftp01" >> /etc/vsftpd/user_list

###########################################################################
模块 4：客户端三种访问方式（临时连接 + 永久挂载 + Windows 访问）
###########################################################################
4.1 Linux 临时交互式 ftp 客户端
yum install ftp / apt install ftp
ftp 192.168.1.100  # 输入用户名、密码
常用交互命令：ls get put cd mkdir delete bye

4.2 Linux 永久挂载 FTP（curlftpfs，开机自动挂载）
安装工具
yum install curlftpfs / apt install curlftpfs
临时挂载
mkdir /mnt/ftp_mount
curlftpfs ftp01: 密码@192.168.1.100 /mnt/ftp_mount
永久开机挂载写入/etc/fstab
echo "curlftpfs#ftp01: 密码@192.168.1.100 /mnt/ftp_mount fuse allow_other, uid = 1000, gid = 1000 0 0" >> /etc/fstab
mount -a

4.3 Windows 客户端访问
方式 1：资源管理器地址栏输入 ftp://192.168.1.100 输入账号密码
方式 2：此电脑-右键添加网络位置，输入 FTP 地址，保存凭证永久访问
方式 3：FileZilla 图形客户端（推荐，被动模式自动适配）

###########################################################################
模块 5：专属安全隔离功能（vsftpd 核心安全特性）
###########################################################################
5.1 chroot_local_user 目录禁锢（核心隔离）
限制用户仅能访问自身/home/xxx，无法进入/ /etc /root 等系统目录
约束：家目录权限不能 777/770，必须 755，否则登录直接失败

5.2 禁止匿名用户、关闭匿名上传，杜绝公开访问风险
anonymous_enable=NO

5.3 单用户独立权限隔离，不同用户读写权限分离
user_config_dir=/etc/vsftpd/user_config_dir

5.4 黑白名单账号隔离，限制高危账号登录 FTP（root 禁止登录）
echo "root" >> /etc/vsftpd/user_list

5.5 被动端口区间限制，缩小防火墙开放端口范围，减少攻击面
pasv_min_port=40000
pasv_max_port=50000

5.6 日志全量记录上传下载行为，审计追溯文件操作
xferlog_enable=YES

5.7 FTP 用户禁止 SSH 登录，降低账号泄露后服务器入侵风险
useradd -s /sbin/nologin ftpuser

###########################################################################
模块 6：标准化故障排查完整流程（自上而下排查）
###########################################################################
步骤 1：检查 vsftpd 服务状态
systemctl status vsftpd
异常：systemctl restart vsftpd && 查看 journalctl -u vsftpd

步骤 2：校验配置文件语法
vsftpd /etc/vsftpd/vsftpd.conf

步骤 3：防火墙端口连通性测试
telnet 192.168.1.100 21
nc -zv 192.168.1.100 40000-50000

步骤 4：账号与家目录权限排查（chroot 登录失败最高发问题）
ls -ld /home/ftp01
权限包含 w 权限执行 chmod 755 /home/ftp01
检查目录属主：chown ftp01: ftp01 /home/ftp01/upload

步骤 5：登录日志排查，定位认证/权限报错
tail -f /var/log/vsftpd.log
journalctl -u vsftpd -f

步骤 6：客户端模式排查（主动/被动模式报错）
FileZilla 客户端强制切换被动 PASV 模式重试

步骤 7：权限读写故障排查
1. 检查全局 write_enable 配置
2. 检查用户独立配置是否关闭写入权限
3. 检查上传目录文件系统权限 rwx
```


**⑤ 🎯 面试考点**：
- 主动 vs 被动模式？答：主动（服务端连客户端高端口，防火墙不友好）；被动（客户端连服务端被动端口，常用）。
- chroot 限制？答：限制用户根目录防越权。
- 匿名登录风险？答：匿名上传易成肉鸡，禁匿名写或限目录。

### MinIO 对象存储

**① 一句话本质**：MinIO = S3 兼容的对象存储，可自建私有云存储，替代公有云 OSS。


- 私有对象存储部署
- 桶策略、权限、内外网访问
- 文件上传下载、分片存储特性

``` md
MinIO 对象存储 标准化学习文档
统一 6 模块学习架构：1 基础认知 2 服务端部署 3 用户权限管控 4 客户端使用 5 安全隔离 6 故障排查
业务场景：私有对象存储、桶策略精细化权限、内外网访问控制、分片上传/分布式存储特性
部署模式：单机独立部署（生产可扩展分布式集群）

###########################################################################
模块 1：基础认知（简介、架构、端口、专业概念、分片存储特性）
###########################################################################
1.1 MinIO 简介
MinIO 是一款开源、轻量、兼容标准 S3 协议的分布式对象存储服务端程序
开发定位：专为私有环境、企业自建、云原生场景打造，兼容 AWS S3 全部主流 API
核心用途：存储图片、视频、日志、备份、静态资源、大数据文件等海量非结构化数据
https://www.minio.org.cn/

1.2 架构模型
C/S 架构：服务端 MinIO Server + 客户端 mc/mc-admin/SDK/浏览器控制台
存储单元层级：磁盘(驱动) → 存储池(erasure code 纠删码) → Bucket(桶) → Object(对象/文件)
核心特性：分片存储、纠删码、对象版本、临时预签名、桶策略、IAM 子账号

1.3 默认端口
9000：S3 API 端口（程序上传下载、mc 客户端交互）
9001：Web 管理控制台端口（可视化管理桶/文件/权限）

1.4 核心专业概念
Bucket 桶：顶层隔离容器，等同于 FTP 根目录，全局唯一名称
Object 对象：存储的单个文件，支持分片、元数据、版本
Erasure Code 纠删码：分布式分片存储核心，多盘分片冗余，坏盘不丢数据
分片上传 Multipart：大文件自动切分多块并行上传，断点续传，合并后完整对象
IAM 子账号：独立访问密钥 AK/SK，精细化读写权限，区分管理员与业务账号
桶策略 Bucket Policy：JSON 权限规则，控制匿名/内网/外网访问、读写操作
预签名 URL：临时带时效访问链接，无需密钥即可下载/上传文件
内外网分离：内网 API 直连，外网仅开放控制台/限制 IP 访问

1.5 分片存储特性重点
1. 文件自动分片：默认 5MB 分片阈值，大文件切割多 part 并行上传，提速
2. 断点续传：上传中断可续传已上传分片，无需重传全部文件
3. 分布式分片均衡：多磁盘自动打散分片，负载均衡
4. 分片合并：所有分片上传完成后 MinIO 自动合并为完整对象，前端无感知
5. 分片生命周期：可配置自动清理未完成分片垃圾文件，释放磁盘

###########################################################################
模块 2：服务端标准化部署（私有单机部署流程）
安装 → 启停 → 防火墙 → 存储目录 → 环境变量配置 → 校验生效
###########################################################################
2.1 二进制安装（全 Linux 通用，推荐）
wget https://dl.min.io/server/minio/release/linux-amd64/minio
wget https://dl.minio.org.cn/server/minio/release/linux-amd64/minio
chmod +x minio
mv minio /usr/local/bin/

2.2 标准化存储目录规划（私有存储数据分离）
mkdir -p /data/minio/storage        # 对象持久化存储目录
mkdir -p /data/minio/logs           # 运行日志目录
mkdir -p /etc/minio                 # 环境变量配置目录

2.3 私有部署核心环境变量（关闭匿名、设置管理员密钥）
cat > /etc/minio/env << EOF
管理员账号密钥（私有存储禁止弱密钥）
MINIO_ROOT_USER=admin
MINIO_ROOT_PASSWORD=Admin@123456
监听地址：0.0.0.0 允许内外网访问，可限定内网 IP 192.168.1.100
MINIO_ADDRESS=0.0.0.0:9000
MINIO_CONSOLE_ADDRESS=0.0.0.0:9001
日志输出
MINIO_LOG_DIR=/data/minio/logs
关闭公开匿名访问（私有存储强制开启）
MINIO_BROWSER_REDIRECT_URL=
MINIO_PROMETHEUS_AUTH_TYPE=public
EOF

2.4 Systemd 系统服务托管（标准化启停）
cat > /etc/systemd/system/minio.service << EOF
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

2.5 服务管理命令
systemctl daemon-reload
systemctl enable --now minio     # 开机自启+启动
systemctl stop minio
systemctl restart minio
systemctl status minio
journalctl -u minio -f           # 实时运行日志

2.6 防火墙放行端口（内外网分离控制）
CentOS firewalld
firewall-cmd --permanent --add-port=9000/tcp
firewall-cmd --permanent --add-port=9001/tcp
firewall-cmd --reload
仅内网访问：限制来源 IP
firewall-cmd --permanent --add-rich-rule='rule family = "ipv4" source address = "192.168.0.0/16" port protocol = "tcp" port = "9000" accept'

Ubuntu ufw
ufw allow from 192.168.0.0/16 to any port 9000,9001 proto tcp

2.7 部署校验
curl http://127.0.0.1:9000/minio/health/live  # 健康检测
访问控制台 http://服务器 IP: 9001 登录管理员账号

###########################################################################
模块 3：用户权限管控（IAM 子账号 + 桶策略 + 内外网访问控制）
###########################################################################
前置：安装 mc 客户端用于命令行权限管理
wget https://dl.min.io/client/mc/release/linux-amd64/mc
wget https://dl.min.org.cn/client/mc/release/linux-amd64/mc
curl https://dl.minio.org.cn/client/mc/release/linux-amd64/mc \
create-dirs \
o $HOME/minio-binaries/mc
chmod +x mc && mv mc /usr/local/bin/
mc alias set minio http://127.0.0.1:9000 admin Admin@123456
mc admin info minio

3.1 IAM 子账号管理（双层权限第一层：账号读写权限）
创建只读子账号
mc admin user add minio user-read UserRead@666
mc admin policy attach minio readonly --user user-read

创建仅上传子账号
mc admin user add minio user-write UserWrite@666
mc admin policy attach minio writeonly --user=user-write

自定义细粒度策略文件示例 bucket-only-write.json
cat > bucket-only-write.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3: PutObject",
        "s3: ListBucket"
      ],
      "Resource": [
        " arn:aws:s3::: private-bucket/*",
        "arn:aws:s3::: private-bucket"
      ]
    }
  ]
}
EOF
mc admin policy create minio bucket-write bucket-only-write.json
mc admin policy set minio bucket-write user = user-bucket

3.2 桶策略 Bucket Policy（双层权限第二层：桶访问控制，管控内外网）
场景 1：完全私有，禁止任何匿名内外网访问（私有存储默认）
cat > private-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": {"AWS": "*"},
      "Action": " s3:*",
      "Resource": " arn:aws:s3::: data-bucket/*",
      "Condition": {
        "Bool": {"aws: SecureTransport": false}
      }
    }
  ]
}
EOF
mc policy set-json minio/data-bucket private-policy.json

场景 2：仅内网 IP 允许匿名下载，外网拒绝
cat > intranet-only.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"AWS": "*"},
      "Action": ["s3: GetObject"],
      "Resource": " arn:aws:s3::: public-data/*",
      "Condition": {
        "IpAddress": {"aws: SourceIp": "192.168.0.0/16"}
      }
    }
  ]
}
EOF

场景 3：外网仅允许预签名 URL 访问，禁止直接匿名浏览
策略中拒绝所有外网直接 s3: GetObject，仅允许带签名临时链接

桶策略生效命令
mc policy set-json minio/桶名 策略文件.json
mc policy get-json minio/桶名  # 查看当前桶策略

3.3 内外网访问隔离方案
1. 端口监听限制：MINIO_ADDRESS = 192.168.1.100:9000 仅内网网卡监听
2. 防火墙 IP 白名单：仅内网段放行 9000/9001，外网屏蔽
3. 桶策略 IP 条件：通过 SourceIp 限制仅内网 IP 操作对象
4. 外网业务仅使用时效预签名 URL 分发文件，不开放永久匿名权限

###########################################################################
模块 4：客户端使用（命令行临时操作、永久挂载、Windows 访问、分片上传）
###########################################################################
4.1 mc 客户端临时上传下载、分片自动处理
新建桶
mc mb minio/file-bucket
本地文件上传（自动分片，大文件断点续传）
mc cp /data/test.iso minio/file-bucket/
下载对象到本地
mc cp minio/file-bucket/test.iso /tmp/
列出桶内文件
mc ls minio/file-bucket
生成 1 小时时效外网预签名下载链接
mc share download --expire 1h minio/file-bucket/test.iso

4.2 Linux 永久挂载 MinIO（s3fs-fuse）
yum install s3fs-fuse / apt install s3fs
写入 AK/SK 凭证
echo "admin: Admin@123456" > /etc/passwd-s3fs
chmod 600 /etc/passwd-s3fs
临时挂载桶到本地目录
mkdir /mnt/minio-bucket
s3fs file-bucket /mnt/minio-bucket -o url = http://127.0.0.1:9000
fstab 永久开机挂载写入
file-bucket /mnt/minio-bucket fuse.s3fs _netdev, url = http://127.0.0.1:9000 0 0

4.3 Windows 客户端访问
1. 浏览器控制台：http://服务器 IP: 9001，管理员/子账号登录可视化管理
2. 工具：WinSCP、Rclone、MinIO Browser，填写 S3 Endpoint、AK/SK 连接
3. 业务程序：Java/Python/Go SDK 对接 9000 端口 S3 API 自动分片上传

4.4 分片上传手动控制（超大文件场景）
mc cp --multipart-chunk-size 10M /data/large.tar minio/bucket/
multipart-chunk-size 指定分片大小，默认 5MB
查看未完成分片任务
mc ls minio/bucket --versions --recursive
清理过期未上传完成分片
mc admin clean incomplete-uploads minio

###########################################################################
模块 5：专属安全隔离功能（MinIO 私有存储核心隔离能力）
###########################################################################
5.1 桶级资源隔离：不同业务分桶存储，桶策略互相隔离数据
5.2 IAM 账号隔离：子账号独立 AK/SK，权限最小化，无全局管理员权限
5.3 IP 访问隔离：桶策略+防火墙双层限制内外网访问来源
5.4 传输加密：强制 HTTPS，拒绝 HTTP 明文传输，关闭非加密访问
5.5 分片数据隔离：分片文件底层独立存储，未合并无法读取完整对象
5.6 时效访问隔离：预签名 URL 设置过期时间，外网临时访问限时可控
5.7 存储纠删隔离：分布式多盘分片冗余，单盘故障不泄露/丢失文件
5.8 匿名访问隔离：默认私有桶，必须手动配置桶策略才开放任何匿名权限

###########################################################################
模块 6：标准化故障排查流程（固定顺序定位问题）
###########################################################################
步骤 1：检查 MinIO 服务运行状态
systemctl status minio
journalctl -u minio -f 实时查看启动崩溃、权限报错

步骤 2：端口连通性检测（内外网不通优先排查）
telnet 服务器 IP 9000
curl http://IP: 9000/minio/health/live 健康接口验证
内网能通外网不通：检查防火墙 IP 白名单、监听地址是否绑定 0.0.0.0

步骤 3：存储目录权限校验（启动失败高发）
ls -ld /data/minio/storage
chown -R root: root /data/minio/ && chmod 700 /data/minio/storage

步骤 4：AK/SK 账号与 IAM 权限排查
mc admin user list minio
mc admin policy info minio 策略名
上传 403 无权限：核对子账号绑定策略、桶策略是否允许 PutObject

步骤 5：桶策略访问异常（内外网访问拒绝）
mc policy get-json minio/桶名
匿名无法下载：检查 Statement 是否允许 s3: GetObject、IP 条件是否匹配客户端地址

步骤 6：分片上传失败排查
查看未完成分片 mc ls minio/桶 --incomplete
磁盘满导致分片写入失败：df -h /data/minio
分片超时：调整客户端超时参数，增大分片 chunk 大小

步骤 7：Web 控制台无法登录
核对 MINIO_ROOT_USER/ROOT_PASSWORD 环境变量
确认 9001 端口防火墙放行、无安全组拦截
```

---


**⑤ 🎯 面试考点**：
- 与 AWS S3 兼容意义？答：兼容 S3 API，可替换公有云 OSS，应用无改动。
- 分布式部署？答：erasure code 纠删码，N/2 节点宕机仍可恢复。
- bucket 权限？答：private/public-read 等策略控制访问。

## 四、企业基础网络服务（集群必备底层服务）

### 1. NTP 时间同步

**① 一句话本质**：NTP = 网络时间同步协议，集群时间一致是日志对齐、证书、事务、分布式协调的基础。


- chrony 生产部署
- 阿里时间源同步
- 集群所有机器时间统一（日志 / 数据库 / 集群刚需）

``` md
NTP 时间同步-Chrony 标准化部署（遵循 6 模块学习架构）
业务需求：阿里公共时间源、服务器集群统一时间、日志/数据库/集群强依赖时间一致性
系统适配：CentOS7/8/9、Rocky、Ubuntu20.04+

###########################################################################
模块 1：基础认知（简介、架构、端口、专业概念）
###########################################################################
1.1 简介
NTP：网络时间协议，用于多服务器时间对齐；传统 ntpd 性能差，生产推荐 chrony
Chrony：轻量高精度时间同步工具，同步速度快、断网可维持本地时钟、适配虚拟机/云主机
集群时间统一刚需：日志时序排查、MySQL 主从 GTID、Kafka/Redis 集群、Ansible 批量任务、证书时效校验

1.2 架构角色
chronyd：后台守护进程，持续同步时间、校正本地时钟漂移
chronyc：命令行客户端，查询同步状态、手动触发同步
时间层级：本地服务器 → 阿里公共 NTP 源 → 标准 UTC 时间

1.3 端口说明
客户端向外同步：UDP 123（出站，无需放行入站）
若本机作为内网 NTP 服务端：UDP 123 入站开放

1.4 核心术语
stratum 层级：时间源层级，阿里 ntp 为 stratum2，本地机器 stratum3
driftfile：记录硬件时钟漂移，重启后快速恢复时间精度
makestep：初次同步偏差过大时直接跳变时间，避免缓慢微调
allow：内网网段，配置本机作为集群内部时间服务器

###########################################################################
模块 2：服务端标准化部署（安装 → 启停 → 防火墙 → 配置 → 校验生效）
###########################################################################
2.1 安装 chrony
CentOS/RHEL
yum install -y chrony
Ubuntu/Debian
apt update && apt install -y chrony

2.2 标准化配置文件 /etc/chrony.conf
备份原配置
cp /etc/chrony.conf /etc/chrony.conf.bak.$(date +%Y%m%d)
覆盖阿里时间源标准配置
cat > /etc/chrony.conf << EOF
使用阿里公共 NTP 时间源
server ntp.aliyun.com iburst
server ntp2.aliyun.com iburst
server ntp3.aliyun.com iburst
server ntp4.aliyun.com iburst

记录时钟漂移文件
driftfile /var/lib/chrony/drift
前三次同步时差超过 10 秒直接跳变校准
makestep 10 3
启用硬件时钟同步
rtcsync
允许内网网段访问本机时间服务（集群机器可指向本机）
allow 192.168.0.0/16
本地时钟兜底，外网不通时维持时间
local stratum 10
日志路径
logdir /var/log/chrony
EOF

2.3 服务启停、开机自启
systemctl enable --now chronyd
systemctl stop chronyd
systemctl restart chronyd
systemctl status chronyd

2.4 防火墙（仅本机做内网时间服务器才需要放行 123/UDP）
firewalld
firewall-cmd --permanent --add-port=123/udp
firewall-cmd --reload
ufw
ufw allow 123/udp

2.5 配置生效校验
chronyc sources         # 查看当前连接的时间源
chronyc tracking        # 查看时间偏移、同步精度
timedatectl             # 系统时间、时区总览

###########################################################################
模块 3：用户/集群权限管控（集群分层时间架构）
###########################################################################
方案 A：所有机器直连阿里 NTP（小规模集群，10 台以内）
所有服务器统一使用上面/etc/chrony.conf，直接同步阿里云公网源

方案 B：集群分层同步（大规模生产集群，推荐）
1. 选 1 台中控机（ansible 主机）同步阿里 ntp，作为内网时间服务器
2. 其余业务机器同步中控机内网 IP，减少公网请求
业务机配置替换 server 行：
server 192.168.1.10 iburst

时区统一（全集群必须一致，推荐 Asia/Shanghai）
timedatectl set-timezone Asia/Shanghai
写入硬件时钟
hwclock -w

###########################################################################
模块 4：客户端使用（chronyc 交互式工具、批量校验、Windows 同步）
###########################################################################
4.1 Linux 本地 chronyc 交互操作
chronyc                 # 进入交互终端
sources                 # 查看时间源
tracking                # 偏移量
synchronize             # 手动强制同步一次
quit                    # 退出

4.2 Ansible 批量集群校验时间（集群统一巡检）
ansible all -m shell -a "chronyc tracking | grep System     time"

4.3 Windows 客户端同步阿里 NTP
设置 Internet 时间服务器：ntp.aliyun.com
cmd 手动同步：w32tm /resync

###########################################################################
模块 5：专属安全隔离&集群一致性保障功能
###########################################################################
5.1 iburst 参数：开机快速并发同步，快速对齐集群时间
5.2 makestep：新装机时差巨大时直接校准，避免缓慢微调导致集群时间断层
5.3 driftfile：长期维持高精度，多次重启无大幅偏移
5.4 local stratum：断外网环境，集群内部仍可保持时间统一
5.5 allow 网段限制：仅内网机器可从本机获取时间，拒绝外网请求
5.6 rtcsync：定期同步系统时间到硬件 RTC 时钟，断电不跑偏

###########################################################################
模块 6：标准化故障排查流程
###########################################################################
步骤 1：检查 chronyd 服务运行状态
systemctl status chronyd
journalctl -u chronyd -f

步骤 2：检查时间源连通性（UDP 123 出站）
测试阿里 ntp 连通
chronyc sources
无*标记代表同步失败，检查安全组/防火墙出站 UDP123

步骤 3：时区不一致问题
timedatectl
非 Asia/Shanghai 执行：timedatectl set-timezone Asia/Shanghai

步骤 4：集群机器时间偏移过大
chronyc tracking
System time     : X seconds fast/slow：偏移超 1 秒需重新同步
chronyc -a makestep

步骤 5：内网机器无法同步中控时间服务器
检查中控机防火墙 UDP123 放行、chrony.conf allow 网段匹配内网
业务机 server IP 填写正确，无拦截策略

步骤 6：硬件时钟丢失
hwclock --show
hwclock -w
```


**⑤ 🎯 面试考点**：
- stratum 层级？答：0 为基准时钟，每跳 +1，值越大越远越不准。
- 时间不一致危害？答：日志时间错乱难排障、证书校验失败、DB 主从/分布式事务异常。
- chrony 优势？答：比 ntpd 更快同步、适应间歇网络、更好应对时钟漂移。

### 2. Rsync + Inotify 实时备份

**① 一句话本质**：rsync 增量同步 + inotify 实时监控文件变化，组合实现准实时备份。


- rsync 增量同步、参数详解
- 无差异同步、删除冗余、权限同步
- inotifywait 实时监控脚本
- 生产实时备份架构、异地容灾

``` md
Rsync+Inotify 实时文件备份标准化学习文档
严格 6 模块架构：1 基础认知 2 服务端部署 3 权限管控 4 客户端/脚本使用 5 安全隔离 6 故障排查
业务场景：本地实时增量备份、异地机房容灾、无差异镜像、自动清理冗余文件、完整权限同步

###########################################################################
模块 1：基础认知（简介、架构、端口、专业概念）
###########################################################################
1.1 Rsync 简介
rsync：远程增量同步工具，核心算法只传输文件差异块，相比 scp/ftp 节省带宽
三大工作模式：本地同步、ssh 远程同步、rsync daemon 服务端同步
核心特性：增量传输、保留文件权限属主、删除源端不存在文件、断点续传、压缩传输

1.2 Inotify 简介
Linux 内核文件事件监控机制，inotifywait 为用户态工具；监控目录新增/修改/删除/移动事件
触发机制：文件发生变动后立刻执行 rsync 同步，实现秒级实时备份

1.3 整体备份架构
生产两层架构：
第一层：本地实时同步（本机磁盘多目录镜像）
第二层：异地远程实时同步（ssh/rsyncd 跨机房容灾备份）
数据流：业务目录变更 → inotify 捕获事件 → 调用 rsync 增量同步至备份端

1.4 端口与通信
rsync over ssh：复用 SSH 22 端口（推荐生产，加密传输）
rsync daemon 模式：独立 TCP 873 端口（内网无加密，仅隔离内网使用）

1.5 核心专业术语
增量同步：仅传输修改部分，不重复全量文件
无差异镜像 --delete：目标目录完全和源对齐，删除目标多余冗余文件
权限同步：属主、属组、rwx 权限、时间戳完整保留
inotify 事件：create/modify/attrib/close_write/move/delete
异地容灾：跨服务器/机房实时备份，单点故障不丢失数据

###########################################################################
模块 2：服务端标准化部署（安装 → 防火墙 → 目录规划 → 基础同步测试）
###########################################################################
2.1 软件安装
CentOS/RHEL
yum install -y rsync inotify-tools
Ubuntu/Debian
apt update && apt install -y rsync inotify-tools

2.2 标准化目录规划
业务源目录（待监控）
SOURCE_DIR=/data/business
本地一级备份目录
LOCAL_BACKUP=/data/backup_local
异地远端备份路径（远端服务器）
REMOTE_USER=backup
REMOTE_IP=192.168.2.100
REMOTE_DIR=/data/remote_backup

创建目录
mkdir -p $SOURCE_DIR $LOCAL_BACKUP

2.3 防火墙配置（ssh 模式仅开放 22；daemon 模式放行 873）
ssh 模式无需额外端口，仅保障 22 端口互通
daemon 模式放行 873（内网专用）
firewall-cmd --permanent --add-port=873/tcp
firewall-cmd --reload

2.4 Rsync 核心参数详解（生产标准组合）
标准全量同步参数组合
a 归档模式 = -rlptgoD 递归+权限+时间+属主属组+设备文件
r 递归遍历子目录
l 保留软链接
p 保留文件权限
t 保留文件修改时间
g 保留属组
o 保留属主
D 保留设备/特殊文件
delete 无差异同步：删除目标端源不存在的冗余文件
exclude 排除不需要同步的目录/文件
compress 传输过程压缩，节省带宽
progress 打印同步进度（调试用，生产脚本可删除）
bwlimit 限制传输带宽，避免占满业务磁盘 IO
chmod 统一同步后文件权限
chown 强制统一属主属组

2.5 基础本地同步测试（无差异镜像+权限同步）
rsync -a --delete --compress $SOURCE_DIR/ $LOCAL_BACKUP/
远程 ssh 同步测试
rsync -a --delete --compress $SOURCE_DIR/ $REMOTE_USER@$REMOTE_IP:$REMOTE_DIR/

###########################################################################
模块 3：用户权限管控（同步账号、免密 ssh、目录最小权限）
###########################################################################
3.1 专用备份账号（禁止登录 ssh，最小权限）
useradd -m -s /sbin/nologin backup
赋予源目录读取权限、备份目录写入权限
chown -R backup: backup $SOURCE_DIR $LOCAL_BACKUP

3.2 异地免密 SSH 密钥（实时脚本自动化必备，无需手动输密码）
本地生成密钥
su - backup -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
推送公钥至异地备份服务器
su - backup -c "ssh-copy-id $REMOTE_USER@$REMOTE_IP"

3.3 权限管控规范
源目录：700，仅备份账号可读
备份目录：700，仅备份账号可读写
禁止 777 宽松权限，防止文件篡改泄露

3.4 黑白名单过滤同步文件
exclude '*.tmp' 排除临时文件
exclude 'logs/' 排除日志目录
include '*.jpg' 仅同步图片文件

###########################################################################
模块 4：客户端/脚本使用（inotify 实时监控脚本、开机自启、异地同步）
###########################################################################
4.1 生产级 inotifywait 实时备份脚本 /usr/local/bin/inotify_rsync.sh
cat > /usr/local/bin/inotify_rsync.sh <<'EOF'
#!/bin/bash
实时监控 rsync 同步脚本
SOURCE="/data/business"
LOCAL_BACK="/data/backup_local"
REMOTE_USER="backup"
REMOTE_IP="192.168.2.100"
REMOTE_PATH="/data/remote_backup"

inotify 监控事件：创建/修改/属性变更/写入完成/移动/删除
inotifywait -mrq --timefmt '%Y-%m-%d %H:%M:%S' --format '%T %w%f %e' \
e create,modify, attrib, close_write, move, delete $SOURCE | while read line
do
    echo " 检测文件变更：$line "
    # 1.本地实时无差异同步
    rsync -a --delete --compress $SOURCE/ $LOCAL_BACK/
    # 2.异地容灾实时同步
    rsync -a --delete --compress $SOURCE/ $REMOTE_USER@$REMOTE_IP:$REMOTE_PATH/
done
EOF

赋予脚本执行权限
chmod +x /usr/local/bin/inotify_rsync.sh

4.2 Systemd 托管脚本，开机自启后台运行
cat > /etc/systemd/system/inotify-rsync.service << EOF
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

加载并启动服务
systemctl daemon-reload
systemctl enable --now inotify-rsync
systemctl status inotify-rsync

4.3 手动执行单次同步、定时兜底备份（补充实时脚本遗漏）
手动同步
/usr/local/bin/inotify_rsync.sh
crontab 每小时一次全量兜底，防止 inotify 漏事件
echo "0 * * * * rsync -a --delete --compress /data/business/ /data/backup_local/" >> /var/spool/cron/root

###########################################################################
模块 5：专属安全隔离&容灾功能
###########################################################################
5.1 无差异镜像 --delete：目标目录和源完全一致，自动清理冗余垃圾文件
5.2 -a 归档参数：完整同步权限、属主、时间戳，备份文件可直接恢复使用
5.3 inotify 内核监控：仅文件变动触发同步，空闲无 IO 消耗，性能远优于定时 rsync
5.4 SSH 加密远程传输：异地备份数据加密，防止传输窃取
5.5 分层备份架构：本地一级备份+异地二级容灾，双重数据保障
5.6 专用备份账号隔离：业务进程与备份账号分离，权限最小化
5.7 文件过滤机制：exclude 排除缓存、临时文件，减少无效同步流量
5.8 带宽限速--bwlimit：避免同步占用业务磁盘/网络带宽

###########################################################################
模块 6：标准化故障排查流程
###########################################################################
步骤 1：检查实时备份服务状态
systemctl status inotify-rsync
journalctl -u inotify-rsync -f

步骤 2：inotify 监控数量上限报错（文件多触发）
查看当前 max_user_watches
cat /proc/sys/fs/inotify/max_user_watches
永久调大内核参数
echo "fs.inotify.max_user_watches = 1048576" >> /etc/sysctl.conf
sysctl -p

步骤 3：rsync 同步失败、权限丢失
核对-a 完整参数是否携带，源/备份目录属主是否为 backup
ls -ld $SOURCE_DIR

步骤 4：异地同步卡住/超时
测试免密 ssh 连通：ssh backup@192.168.2.100
检查防火墙 22 端口、异地磁盘空间 df -h

步骤 5：目标目录残留冗余文件（--delete 失效）
源目录路径末尾必须带 / 如 /data/business/，否则同步目录本身而非内部文件

步骤 6：文件变更无同步触发
手动执行 inotifywait 测试是否捕获事件
inotifywait -m /data/business
检查脚本用户 backup 是否拥有目录读取权限

步骤 7：同步占用过高带宽
rsync 增加--bwlimit 10000 参数限制 10MB/s 带宽

核心架构总结
1. 实时层：inotify 内核监控文件变动，秒级触发同步
2. 同步层：rsync 增量传输，--delete 实现完全镜像，完整保留文件权限
3. 容灾层：本地备份 + 异地 ssh 加密备份双重架构
4. 兜底层：定时 crontab 每小时全量同步，弥补 inotify 事件丢失风险
```


**⑤ 🎯 面试考点**：
- rsync 增量原理？答：rsync 算法比对差异块，只传变更部分，省带宽。
- inotify 触发？答：监控文件事件，变化时调 rsync 脚本实现近实时。
- 为何走 ssh？答：rsync -e ssh 加密传输，安全。

### 3. DNS 服务 BIND

**① 一句话本质**：DNS = 域名解析系统，BIND 是主流服务端，用 zone 文件管理各类记录。


- 内网 DNS 服务器搭建
- 正向解析、反向解析
- A 记录、CNAME 记录、泛解析
- 企业内网域名统一解析、解析故障排查

``` md
BIND DNS 内网服务器标准化学习文档
统一 6 模块架构：1 基础认知 2 服务端部署 3 权限/区域管控 4 客户端使用 5 安全隔离 6 标准化故障排查
业务需求：企业内网 DNS、正向/反向解析、A/CNAME/泛域名解析、统一内网域名、解析排错

###########################################################################
模块 1：基础认知（简介、架构、端口、专业概念）
###########################################################################
1.1 BIND 简介
BIND=Berkeley Internet Name Domain，业界标准 DNS 服务程序，企业内网首选
作用：搭建私有内网 DNS，自定义内部域名，无需修改 hosts，全服务器统一解析
适用场景：内网业务主机、k8s 集群、存储、中间件自定义域名访问

1.2 DNS 架构分层
客户端 -> 本地 DNS 缓存(resolv.conf) -> BIND 内网 DNS 服务器
BIND 分层角色：
master 主服务器：维护区域解析文件，权威数据源
slave 从服务器：同步主服务器区域数据，高可用冗余

1.3 端口
UDP 53：域名查询（主流）
TCP 53：区域传输、大解析包查询，防火墙需同时放行 udp/tcp 53

1.4 核心解析概念
正向解析：域名 → IP（www.test.local → 192.168.1.10）
反向解析：IP → 域名（192.168.1.10 → www.test.local）
A 记录：域名映射 IPv4 地址
CNAME：别名记录，域名指向另一个域名
泛解析 *.test.local：匹配所有子域名，统一指向同一 IP
SOA 记录：区域起始授权记录，定义主从同步、刷新/过期时间
NS 记录：区域域名服务器记录
PTR 记录：反向解析专用记录

###########################################################################
模块 2：服务端标准化部署（安装 → 启停 → 防火墙 → 配置 → 区域文件 → 校验生效）
###########################################################################
2.1 安装 bind 组件
CentOS/RHEL/Rocky
yum install -y bind bind-chroot bind-utils
Ubuntu/Debian
apt update && apt install -y bind9 dnsutils

2.2 核心目录说明
/etc/named.conf          主配置文件（监听、访问控制、区域定义）
/var/named/              区域解析文件存放目录
/var/named/data/         缓存、运行数据
/etc/rndc.key            rndc 远程控制密钥

2.3 防火墙放行 53 端口
firewalld
firewall-cmd --permanent --add-port=53/udp
firewall-cmd --permanent --add-port=53/tcp
firewall-cmd --reload
ufw
ufw allow 53 proto udp
ufw allow 53 proto tcp

2.4 主配置 /etc/named.conf 内网标准模板
cp /etc/named.conf /etc/named.conf.bak.$(date +%Y%m%d)
cat > /etc/named.conf << EOF
options {
    listen-on port 53 { any; };          # 监听所有网卡
    listen-on-v6 port 53 { :: 1; };
    directory       "/var/named";
    dump-file       "/var/named/data/cache_dump.db";
    statistics-file "/var/named/data/named_stats.txt";
    memstatistics-file "/var/named/data/named_mem_stats.txt";
    allow-query     { 192.168.0.0/16; }; # 仅内网网段允许查询
    recursion yes;                       # 开启递归，外网域名也能解析
    forwarders {
        223.5.5.5;
        223.6.6.6;
    }; # 公网阿里 DNS 转发，内网查不到自动转发公网
};

内网正向区域 test.local
zone "test.local" IN {
    type master;
    file "named.test.local";
    allow-update { none; };
};

反向解析区域 192.168 网段
zone "168.192.in-addr.arpa" IN {
    type master;
    file "named.192.168";
    allow-update { none; };
};

include "/etc/rndc.key";
EOF

2.5 正向解析区域文件 /var/named/named.test.local（A/CNAME/泛解析）
cat > /var/named/named.test.local << EOF
\$TTL 86400
@   IN  SOA dns.test.local. admin.test.local. (
        2026071601  ; 版本号，修改解析必须递增
        3600        ; 刷新时间
        1800        ; 重试
        604800      ; 过期
        86400       ; 最小 TTL
)
    IN  NS  dns.test.local.

DNS 服务器本机 A 记录
dns     IN  A   192.168.1.5

业务主机 A 记录
ansible IN  A   192.168.1.10
minio   IN  A   192.168.1.11
ntp     IN  A   192.168.1.12

CNAME 别名
storage IN  CNAME minio.test.local.

泛解析 *.test.local 统一指向 192.168.1.99
*       IN  A   192.168.1.99
EOF

2.6 反向解析区域文件 /var/named/named.192.168
cat > /var/named/named.192.168 << EOF
\$TTL 86400
@   IN  SOA dns.test.local. admin.test.local. (
        2026071601
        3600
        1800
        604800
        86400
)
    IN  NS  dns.test.local.

PTR 反向记录 格式：最后一段 IP IN PTR 域名
5       IN  PTR dns.test.local.
10      IN  PTR ansible.test.local.
11      IN  PTR minio.test.local.
EOF

2.7 修正区域文件权限（bind 运行用户 named）
chown named: named /var/named/named.*
chmod 644 /var/named/named.*

2.8 服务启停、配置校验、生效
校验主配置语法
named-checkconf /etc/named.conf
校验正向区域文件
named-checkzone test.local /var/named/named.test.local
校验反向区域文件
named-checkzone 168.192.in-addr.arpa /var/named/named.192.168

服务管理
systemctl enable --now named
systemctl restart named
systemctl status named
重载配置不中断服务
rndc reload

###########################################################################
模块 3：用户/访问权限管控（查询白名单、区域传输限制、主从权限）
###########################################################################
3.1 查询权限控制（主配置 allow-query）
allow-query { 192.168.0.0/16; }; 仅内网可查询，拒绝外网访问 DNS 服务

3.2 区域传输防泄露（禁止任意主机拉取全部解析记录）
zone 内配置 allow-transfer { none; }; 生产默认关闭
搭建从服务器时仅放开从机 IP：allow-transfer {192.168.1.6;};

3.3 禁止动态更新 allow-update { none; };
关闭自动动态更新，所有解析手动修改文件，版本号递增

3.4 转发控制
recursion yes 内网机器可递归查询公网域名
如需内网隔离外网：recursion no; 删除 forwarders 阿里 DNS

###########################################################################
模块 4：客户端使用（Linux 配置 DNS、解析测试、Windows 内网 DNS）
###########################################################################
4.1 Linux 客户端配置 DNS 指向内网 BIND
临时修改
echo "nameserver 192.168.1.5" > /etc/resolv.conf
永久网卡配置（CentOS nmcli 示例）
nmcli connection modify eth0 ipv4.dns 192.168.1.5
nmcli connection up eth0

4.2 解析测试工具 nslookup / dig / host
正向解析查询 A 记录
dig ansible.test.local A
nslookup minio.test.local
查询 CNAME
dig storage.test.local CNAME
测试泛解析
dig abc.test.local
反向解析 IP 查域名
dig -x 192.168.1.10
测试公网转发
dig www.baidu.com

4.3 Windows 客户端配置
网卡 IPv4 DNS 手动填写内网 DNS 服务器 IP 192.168.1.5
cmd 测试：nslookup ansible.test.local

4.4 rndc 远程管理 BIND 服务
rndc status        # 查看运行状态
rndc reload        # 重载区域解析
rndc flush         # 清空 DNS 缓存

###########################################################################
模块 5：专属安全隔离与内网统一解析能力
###########################################################################
5.1 网段访问隔离 allow-query：仅企业内网允许查询 DNS，屏蔽外网访问
5.2 区域传输权限隔离：仅授权从服务器同步区域数据，防止解析泄露
5.3 内网域名统一管理：所有服务器共用一套 DNS，不用每台修改/etc/hosts
5.4 泛解析批量管理：批量子域名统一指向同一 IP，无需逐条新增 A 记录
5.5 正向+反向配套解析：运维排查 IP 对应主机名更便捷
5.6 公网转发兜底：内网不存在域名自动转发阿里公共 DNS，内外网兼容
5.7 主从冗余架构：搭建 slave 从 DNS，单台 DNS 故障不中断解析服务

###########################################################################
模块 6：标准化故障排查流程
###########################################################################
步骤 1：检查 named 服务运行状态
systemctl status named
journalctl -u named -f

步骤 2：校验配置与区域文件语法（启动失败最高发）
named-checkconf
named-checkzone test.local /var/named/named.test.local
报错：版本号未递增、末尾缺少.、IP 格式错误、权限不足

步骤 3：端口连通性测试（客户端无法解析）
服务端本地测试
dig @127.0.0.1 ansible.test.local
客户端测 53 端口连通
telnet 192.168.1.5 53
检查防火墙 udp/tcp 53 是否放行

步骤 4：客户端解析失效
查看客户端 resolv.conf nameserver 是否指向内网 DNS
关闭 NetworkManager 自动覆盖 resolv.conf

步骤 5：新增解析不生效
修改区域文件后必须递增 SOA 版本号
执行 rndc reload 重载区域
客户端清空本地缓存：systemd-resolve --flush-caches

步骤 6：反向解析查不出域名
核对反向区域 PTR 记录 IP 段书写、末尾带.、区域文件名匹配网段

步骤 7：公网域名无法解析
检查主配置 forwarders 阿里 DNS 地址、recursion yes 开启

步骤 8：泛解析不生效
确认泛解析记录格式 * IN A x.x.x.x，无多余前缀，区域文件重载
```


**⑤ 🎯 面试考点**：
- 递归 vs 迭代查询？答：递归（服务器代查到底返回结果）；迭代（返回下一级地址，上层继续）。
- 记录类型？答：A/AAAA、CNAME（别名）、MX（邮件）、NS（权威）、TXT、PTR（反向）。
- zone 传输？答：主从同步用 AXFR/IXFR（增量），TSIG 认证。

### TSIG 安全：区域传输加密认证（面试加分）

**① 一句话本质**：TSIG = 用共享密钥对 DNS 区域传输做 HMAC 认证，防伪造与劫持。


``` md
TSIG 区域传输安全（防止主从同步被伪造/篡改，企业安全加分项）
一、为什么需要 TSIG
1. 默认区域传输 AXFR 明文，任何人知道 from 配置就能拉走全部域名记录
2. TSIG：主从之间用共享密钥对请求签名，伪造请求直接拒绝

二、配置步骤（主从都做）
1. 在主服务器生成密钥
dnssec-keygen -a HMAC-SHA256 -b 256 -n HOST tsig-key   # 生成的 .private 中 Key: 后面的字符串就是共享密钥
2. 主服务器 named.conf 增加
key "tsig-key" {
    algorithm hmac-sha256;
    secret "上一步生成的密钥字符串";
};
zone "example.com" IN {
    type master;
    file "example.com.zone";
    allow-transfer { key "tsig-key"; };   # 只有带正确签名的从站能拉区
};
3. 从服务器：同样配置 key 块，allow-transfer 声明相同 key

三、验证
1. dig @主服务器 example.com AXFR -y hmac-sha256:tsig-key:密钥字符串
   能拉出记录 = 认证通过；不加 -y 被拒绝 = 配置生效
2. 查看日志：grep "TSIG" /var/log/messages 确认签名校验结果

速记：共享密钥 + allow-transfer { key xxx; } + dig -y 验证，明文 AXFR 就断了
```


**⑤ 🎯 面试考点**：
- TSIG 作用？答：HMAC 共享密钥签名 zone 传输，防伪造/劫持。
- 与主从 DNS 关系？答：主从 zone 传输用 TSIG 认证。
- 优于 IP 白名单？答：IP 可伪造，TSIG 密码学认证更可靠。

### 4. DHCP 服务

**① 一句话本质**：DHCP = 动态分配 IP 地址，核心是地址池 + 租约（lease）机制。


- 局域网自动分配 IP
- 网关、DNS、租期配置
- 企业内网网络架构维护

``` md
DHCP(dhcpd) 局域网 IP 分配标准化学习文档
固定 6 模块学习架构：1 基础认知 2 服务端部署 3 权限/地址管控 4 客户端使用 5 安全隔离 6 故障排查
业务需求：企业内网自动分配 IP、下发网关/DNS/租期、内网网络架构统一维护

###########################################################################
模块 1：基础认知（简介、架构、端口、专业概念）
###########################################################################
1.1 DHCP 简介
DHCP：动态主机配置协议，局域网服务器自动给终端分配 IP 地址、子网掩码、网关、DNS、租期
解决痛点：内网机器不用手动配静态 IP，批量设备上线自动获取网络参数，统一管控网段
服务程序：dhcpd（ISC DHCP，CentOS/RHEL 主流）

1.2 工作流程(DORA 四步)
Discover 发现：客户端广播寻找 DHCP 服务器
Offer 提供：DHCP 服务器广播分配可用 IP
Request 请求：客户端确认选用该 IP
Ack 确认：服务器下发完整网络参数（网关/DNS/租期）

1.3 端口
UDP 67：DHCP 服务端监听端口
UDP 68：客户端随机端口
全程广播通信，防火墙需放行 UDP67

1.4 核心专业术语
地址池 range：可自动分配的 IP 区间
subnet：网段、子网掩码定义
routers：下发网关地址
domain-name-servers：下发 DNS 服务器
default-lease-time：默认租期(秒)
max-lease-time：最大租期
static-host：静态绑定（MAC 固定分配指定 IP，服务器专用）
lease 文件：/var/lib/dhcpd/dhcpd.leases 记录已分配 IP 与 MAC 对应关系
广播域：单台 DHCP 仅管理同一局域网，跨网段需 DHCP 中继

###########################################################################
模块 2：服务端标准化部署（安装 → 网卡配置 → 防火墙 → 主配置 → 校验生效）
###########################################################################
2.1 安装 DHCP 服务
CentOS/RHEL/Rocky
yum install -y dhcp
Ubuntu/Debian
apt update && apt install -y isc-dhcp-server

2.2 前置：DHCP 服务器网卡必须配置静态 IP
示例网卡 eth0，静态内网 IP 192.168.1.5/24
nmcli connection modify eth0 ipv4.method manual ipv4.addresses 192.168.1.5/24 ipv4.gateway 192.168.1.1 ipv4.dns 223.5.5.5
nmcli connection up eth0

2.3 指定 DHCP 监听网卡
CentOS
echo "DHCPDARGS = eth0" >> /etc/sysconfig/dhcpd
Ubuntu
echo "INTERFACESv4 =\" eth0 \"" >> /etc/default/isc-dhcp-server

2.4 防火墙放行 UDP67 端口
firewalld
firewall-cmd --permanent --add-port=67/udp
firewall-cmd --reload
ufw
ufw allow 67 proto udp

2.5 主配置文件 /etc/dhcp/dhcpd.conf 企业内网标准模板
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak.$(date +%Y%m%d)
cat > /etc/dhcp/dhcpd.conf << EOF
全局域名、DNS 配置
option domain-name "test.local";
下发内网 BIND DNS + 阿里公网 DNS
option domain-name-servers 192.168.1.5,223.5.5.5,223.6.6.6;

默认租期 12 小时，最大租期 24 小时
default-lease-time 43200;
max-lease-time 86400;

日志记录
log-facility local7;

定义内网网段 192.168.1.0/24
subnet 192.168.1.0 netmask 255.255.255.0 {
    # 自动分配 IP 地址池
    range dynamic-bootp 192.168.1.100 192.168.1.200;
    # 下发网关
    option routers 192.168.1.1;
    # 子网掩码
    option subnet-mask 255.255.255.0;
    # 广播地址
    option broadcast-address 192.168.1.255;
}

静态绑定：服务器 MAC 固定分配静态 IP（业务主机不参与动态池）
host ansible-server {
    hardware ethernet 00:xx:xx:xx:xx: 01;
    fixed-address 192.168.1.10;
}
host minio-server {
    hardware ethernet 00:xx:xx:xx:xx: 02;
    fixed-address 192.168.1.11;
}
EOF

2.6 配置语法校验 + 服务启停
校验 dhcp 配置语法
dhcpd -t -cf /etc/dhcp/dhcpd.conf
开机自启+启动
systemctl enable --now dhcpd
systemctl restart dhcpd
systemctl status dhcpd

查看 IP 分配租赁记录
cat /var/lib/dhcpd/dhcpd.leases

###########################################################################
模块 3：内网地址&权限管控（地址池隔离、静态绑定、网段管控）
###########################################################################
3.1 IP 地址分层规划（企业标准）
1~99：静态服务器（网关、DNS、存储、中间件，全部 static-host 绑定）
100~200：DHCP 动态分配终端（PC、开发机、虚拟机）
201~254：预留扩展

3.2 租期管控规范
办公终端：默认 12h，最大 24h，减少地址长期占用
工业设备/摄像头：可延长至 72h，避免频繁重获取 IP

3.3 多网段隔离
新增业务网段新增 subnet 段落，独立 range 地址池，互不干扰
跨网段需交换机开启 DHCP 中继，否则无法跨网段分配 IP

3.4 静态绑定管控
核心业务服务器全部 MAC 绑定固定 IP，不进入动态地址池，IP 永久不变
避免 IP 漂移导致 DNS、监控、备份链路失效

3.5 DNS 统一下发管控
所有终端强制获取内网 BIND DNS，内网域名统一解析，无需手动配置

###########################################################################
模块 4：客户端使用（Linux 获取 IP、释放续租、Windows 客户端）
###########################################################################
4.1 Linux 客户端自动获取 IP
临时重新获取 IP
dhclient eth0
释放当前 IP
dhclient -r eth0
查看网卡获取的网络参数
nmcli connection show eth0

4.2 查看客户端获取的 DNS/网关
cat /etc/resolv.conf
ip route

4.3 Windows 客户端操作
cmd 释放 IP
ipconfig /release
重新获取 DHCP 分配 IP
ipconfig /renew
查看完整网络参数
ipconfig /all

4.4 查看 DHCP 服务分配记录
实时日志观察终端申请 IP
journalctl -u dhcpd -f
查看已租赁 IP 与 MAC 对应关系
less /var/lib/dhcpd/dhcpd.leases

###########################################################################
模块 5：专属内网网络架构隔离功能
###########################################################################
5.1 地址池分段隔离：服务器静态 IP 与终端动态 IP 分段，防止 IP 冲突
5.2 MAC 静态绑定：核心设备 IP 永久固定，保障集群、存储、DNS 稳定访问
5.3 统一批量下发网络参数：网关、DNS、掩码全局统一，内网架构标准化
5.4 租期可控：灵活调整地址释放周期，优化 IP 地址利用率
5.5 租赁记录持久化：完整记录每台设备 MAC-IP 映射，资产溯源
5.6 网段独立管理：多业务子网分开配置，网络故障隔离不扩散

###########################################################################
模块 6：标准化故障排查流程
###########################################################################
步骤 1：检查 dhcpd 服务运行状态
systemctl status dhcpd
journalctl -u dhcpd -f

步骤 2：配置语法错误（启动失败）
dhcpd -t 校验配置，修正网段、MAC、IP 格式错误

步骤 3：客户端无法获取 IP（最常见）
1. DHCP 服务器网卡是否静态 IP，同网段 subnet 配置匹配
2. 防火墙 UDP67 端口放行
3. 交换机是否限制广播、是否跨网段缺少 DHCP 中继
4. 地址池 range 是否耗尽，查看 dhcpd.leases 占用情况

步骤 4：获取 IP 但无法解析内网域名
检查 dhcpd.conf 内 option domain-name-servers 是否填写内网 DNS 地址

步骤 5：终端获取 IP 但无法上网
核对 option routers 网关地址填写正确，网关本身连通外网

步骤 6：服务器静态绑定失效，获取动态 IP
核对 MAC 地址大小写、分隔符；host 段落写在对应 subnet 内部/全局均可
重启 dhcpd 重载配置

步骤 7：IP 地址冲突
1. 部分设备手动配置静态 IP 落在 DHCP 地址池 range 区间
2. 调整 range 范围，静态服务器 IP 移出动态池
3. 查看 dhcpd.leases 定位冲突 MAC 设备

内网网络架构配套联动说明
DHCP + BIND DNS 组合企业标准架构：
1. DHCP 下发内网 DNS 地址，所有终端自动使用私有 DNS 解析内网业务域名
2. 核心服务器 MAC 绑定固定 IP，DNS 内录入对应 A 记录，IP 永久不变
3. 统一网关、网段规划，全网网络参数标准化，降低运维维护成本
```

---

最终：中级运维【纯增量无重复】学习路线图（4 周学完）

第 1 周：Nginx 全站核心（上岗第一技能）

虚拟主机、反向代理、负载均衡、动静分离、HTTPS、rewrite、限流、调优、日志、排障

第 2 周：MySQL 数据库运维

生产部署、多实例、权限、慢查询、索引、binlog、主从复制、XtraBackup 备份、故障恢复

第 3 周：Redis + 消息队列

Redis 持久化、内存策略、哨兵高可用；RabbitMQ/Kafka 集群、消息积压排障

第 4 周：存储 + 底层网络服务

NFS/Samba/MinIO/FTP + NTP 时间同步 + Rsync 实时备份 + BIND 内网 DNS


**⑤ 🎯 面试考点**：
- 分配四步？答：DISCOVER（广播找）→OFFER（分配）→REQUEST（确认）→ACK（确认）。
- IP 保留？答：fixed-address 按 MAC 绑固定 IP。
- 地址耗尽处理？答：调短租约、扩大地址池、排查私接 DHCP。

# CentOS7 操作系统标准化学习架构

**① 一句话本质**：标准化 = 系统初始化规范（分区/源/内核参数/安全基线），让批量机器一致可维护。


``` md
#!/bin/bash
CentOS7 Linux 操作系统 标准化学习 6 大模块
规则：将操作系统视为完整底层软件，严格遵循统一学习结构
固定六模块：1 基础认知 2 服务端部署安装 3 用户权限管控 4 客户端/工具使用 5 安全隔离 6 标准化故障排查

###########################################################################
模块 1：基础认知（系统简介、内核架构、端口、核心专业概念）
###########################################################################
1.1 CentOS7 简介
CentOS7：RHEL7 开源复刻发行版，企业服务器主流 Linux 发行版
内核版本：3.10.x，系统初始化工具 systemd，文件系统 XFS 默认
核心定位：服务器底层操作系统，承载所有中间件、数据库、存储服务

1.2 整体分层架构（自底向上）
硬件层 → Linux 内核 → 系统调用接口 → 系统工具/库 → 应用程序(vsftpd/minio/chrony/dhcp/bind)
内核四大核心子系统：进程管理、内存管理、文件系统、网络协议栈

1.3 核心端口/通信
本地通信：unix socket、管道、信号
网络通信：TCP/UDP 端口，内核协议栈管理

1.4 必学专业概念
systemd：系统初始化、服务管理、目标单元 target
runlevel：运行级别，CentOS7 改用 target 替代传统 runlevel
进程 PID、PPID、前台/后台进程、守护进程 daemon
虚拟内存、物理内存、swap 交换分区、buffer/cache
inode、块存储、文件系统权限 rwx、软硬链接
用户 UID/GID、sudo 提权、pam 认证
网络四层模型：网卡、IP、路由、防火墙 netfilter/firewalld
磁盘分区：MBR/GPT、lvm 逻辑卷、挂载点 mount

###########################################################################
模块 2：系统部署安装（安装 → 初始化 → 磁盘规划 → 网络配置 → 系统校验）
###########################################################################
2.1 系统安装方式
1. ISO 本地光盘装机
2. PXE 批量无人值守装机（企业批量部署）
3. 云主机镜像初始化

2.2 标准化磁盘分区规划（生产标准）
/boot 200M：内核启动文件
swap 内存 1.5 倍：内存交换分区
/ 根分区 /data 业务数据分区 分离挂载（LVM 逻辑卷）

2.3 系统初始化配置
1. 主机名 hostnamectl set-hostname ansible
2. 时区同步 chrony 统一 Asia/Shanghai
3. 网卡静态 IP 配置 /etc/sysconfig/network-scripts/ifcfg-eth0
4. 关闭 SELinux、防火墙策略标准化
5. yum 本地/阿里源替换，软件仓库配置

2.4 系统服务基础管理（systemd）
systemctl list-unit-files
systemctl enable/disable/start/stop/restart 服务名
systemctl get-default multi-user.target 字符界面

2.5 系统健康校验
uname -r 内核版本
df -h / free -m 磁盘内存
ip addr 网络状态
systemctl status 基础服务

###########################################################################
模块 3：用户&资源权限管控（账号、文件、进程、网络四层权限）
###########################################################################
3.1 系统账号管理
useradd/userdel/usermod 普通业务账号
passwd 设置密码、/etc/shadow 加密存储
sudoers 权限提权配置，最小权限分配
/sbin/nologin 禁止账号 SSH 登录（FTP/备份专用账号）

3.2 文件系统权限管控
chmod/chown/chgrp 基础 rwx 权限
umask 默认权限掩码
ACL 扩展细粒度权限 setfacl/getfacl
特殊权限 SUID/SGID/Sticky 粘滞位

3.3 进程资源权限管控
ulimit 进程打开文件数、进程数限制
cgroup 资源隔离（docker 底层依赖）
nice/renice 进程优先级调度

3.4 网络访问权限管控
firewalld 区域 zone、端口/IP 黑白名单
iptables/netfilter 底层网络过滤规则

###########################################################################
模块 4：客户端/系统工具使用（本地操作、远程连接、批量运维）
###########################################################################
4.1 本地 Shell 基础工具
文件操作：ls cd cp mv rm mkdir find tar
文本处理：vim cat grep sed awk
进程管理：ps top htop kill pstree
磁盘管理：mount umount fdisk lvresize df du
网络工具：ip route ss ping traceroute dig

4.2 远程连接客户端
SSH 客户端 ssh/scp/sftp 远程登录传输
Xshell、SecureCRT Windows 远程工具

4.3 批量运维工具
Ansible 批量操作集群多台 CentOS7
rsync 批量文件同步

4.4 定时任务调度
crontab 系统定时任务，兜底备份、日志清理

###########################################################################
模块 5：操作系统专属安全隔离功能（内核+系统层原生隔离）
###########################################################################
5.1 用户账号隔离：普通用户无 root 权限，sudo 精细化授权
5.2 文件权限隔离：目录/文件 rwx 控制，ACL 细分多用户访问权限
5.3 进程资源隔离：ulimit 限制进程资源，cgroup 限制 CPU/内存
5.4 网络流量隔离：firewalld 基于 IP/端口访问控制
5.5 SELinux 强制访问控制（内核层安全隔离）
5.6 磁盘挂载隔离：独立/data 业务分区，根分区故障不影响业务数据
5.7 系统服务隔离：每个中间件独立 systemd 服务，故障互不影响
5.8 内核安全参数：sysctl 优化网络、防攻击、资源限制

###########################################################################
模块 6：操作系统标准化故障排查固定流程
###########################################################################
步骤 1：系统基础状态检查
uptime 负载、free -m 内存、df -h 磁盘、ip addr 网络

步骤 2：系统启动故障排查
journalctl -xb 系统启动日志
grub 引导故障、磁盘分区损坏、fstab 挂载失败

步骤 3：资源瓶颈排查
CPU 高负载：top/htop 定位占用进程
内存溢出：free、swap 频繁使用、OOM 日志
磁盘 IO 阻塞：iostat、iotop
磁盘满：df -h、find 大文件清理

步骤 4：网络故障排查
网卡状态 →IP 配置 → 路由 → 端口连通 → 防火墙拦截 →DNS 解析

步骤 5：账号权限故障
登录失败：/var/log/secure 日志、PAM 认证、sudo 权限
文件读写失败：ls -l 权限、ACL、SELinux 拦截

步骤 6：服务启动异常
systemctl status xxx
journalctl -u xxx -f 实时服务日志
端口占用 ss -lntp、目录权限不足、配置语法错误

步骤 7：内核级系统报错
dmesg 硬件、磁盘、内存、内核崩溃日志
/var/log/messages 系统全局日志

总结：操作系统统一 6 大学习模块（通用，所有 Linux 发行版通用）

1. **基础认知**：发行版介绍、内核分层架构、核心系统概念、进程 / 内存 / 文件 / 网络底层原理
2. **系统部署**：系统安装方式、磁盘标准化分区、初始化配置、软件源、基础服务部署
3. **权限资源管控**：用户账号体系、文件权限、进程资源限制、网络防火墙访问控制
4. **工具客户端使用**：Shell 命令工具、远程 SSH 连接、批量运维工具、定时任务
5. **原生安全隔离**：账号隔离、文件权限隔离、进程资源隔离、网络隔离、SELinux、分区隔离
6. **标准化故障排查**：系统资源瓶颈、启动故障、网络故障、权限故障、服务异常、内核硬件报错
```


**⑤ 🎯 面试考点**：
- 标准化意义？答：批量机器一致、易复制、易排障、合规。
- 最小化安装？答：只装必需包，减攻击面。
- 安全基线要点？答：防火墙开、SSH 禁 root 密码、账户最小化、自动更新、审计。

### Linux内核核心子系统 + 容器/云原生依赖内核特性（运维必掌握）

**① 一句话本质**：Linux 内核子系统 = 进程/内存/IO/网络/文件，容器与云原生依赖其 namespace/cgroup/epoll 等特性。


``` md
#!/bin/bash
Linux 内核核心子系统 + 容器/云原生依赖内核特性（运维必掌握）
适配 CentOS7 3.10 内核，运维视角，区分：四大基础子系统 + 容器底层内核能力 + 其他高频上层依赖特性
###########################################################################
一、Linux 内核四大基础核心子系统（所有应用底层依赖）
###########################################################################
1. 进程管理子系统
核心功能：进程创建 fork/exec、调度、信号、PID/PPID、上下文切换、进程优先级 nice
配套 IPC 进程间通信接口（你提到的）：
1) 管道 pipe/匿名管道、命名管道 FIFO
2) 信号 Signal
3) 共享内存 shmget/shmat
4) 消息队列 msg
5) 信号量 sem
6) Unix Domain Socket（本地套接字，进程本地通信，不走网卡）

2. 内存管理子系统
虚拟内存、物理内存、页表、swap、buffer/cache、OOM 内存回收、大页 HugePage

3. 文件系统子系统
VFS 虚拟文件系统层（统一 ext4/xfs/btrfs/unionfs/overlayfs 接口）
块设备驱动、inode、挂载 mount、权限、软硬链接、磁盘 IO 调度

4. 网络协议栈子系统
L2 链路层、IP 层、TCP/UDP、ICMP、Socket 套接字 API
底层 netfilter 防火墙、conntrack 连接跟踪、tc 流量控制、端口监听

###########################################################################
二、容器核心三大底层内核特性（Docker/K8s 必备，运维重中之重）
###########################################################################
1. Namespace 资源隔离（实现容器独立视图）
7 种隔离命名空间，容器全部启用：
pid：容器内独立 PID 编号，看不到宿主机进程
net：独立网络栈、网卡、IP、端口、路由表
mnt：独立挂载树，容器文件系统隔离
user：UID/GID 映射，容器 root 不等于宿主机 root
uts：独立主机名、域名
ipc：独立进程通信队列，容器间 IPC 隔离
cgroup：独立 cgroup 资源视图

2. Cgroup 资源限制（限制容器 CPU/内存/磁盘 IO/网络）
各大子系统：
cpu：CPU 使用率、权重、绑定 CPU 核心
cpuset：限定容器使用指定物理 CPU
memory：内存上限、swap 限制、OOM 控制
blkio：磁盘读写 IO 带宽限速
net_cls/net_prio：网络流量分类、优先级
devices：限制容器读写硬件设备（屏蔽磁盘、usb）
pids：限制容器最大进程数量

3. OverlayFS 联合文件系统（你说的 UnionFS 升级版，CentOS7 docker 默认）
分层镜像：只读底层镜像层 + 可写容器层
写时复制 CoW，节约磁盘空间，镜像复用，容器启动秒级
替代老旧 AUFS，3.10 内核原生支持

###########################################################################
三、运维必须掌握、上层业务/容器中间件高频调用的其他内核特性
###########################################################################
3.1 Capabilities 内核能力（容器权限精细化管控）
传统 root 全能权限拆分数十个细粒度能力
容器默认删除高危 cap：CAP_SYS_ADMIN/CAP_SYS_MODULE 等
用途：防止容器逃逸、最小权限运行容器，docker run --cap-add/--cap-drop

3.2 Seccomp 安全计算模式（系统调用过滤）
拦截容器内危险系统调用（挂载、修改内核、加载内核模块）
K8s/docker 默认内置 seccomp 策略，加固容器安全，防止提权逃逸

3.3 SELinux / AppArmor 内核强制访问控制 MAC
CentOS 默认 SELinux，内核安全模块，控制进程对文件/端口/设备访问权限
容器、Nginx、vsftpd 大量依赖，运维排错高频遇到权限拦截

3.4 内核模块与设备驱动
加载网卡、磁盘、虚拟化驱动 kvm、overlay、iptables/netfilter 模块
lsmod、modprobe 管理，云主机、虚拟化必备

3.5 KVM 内核虚拟化模块（虚拟机底层）
内核内置虚拟化，OpenStack、VMware、Proxmox 底层依赖
运维区分：容器（namespace+cgroup）是进程隔离；KVM 是硬件级虚拟机隔离

3.6 epoll IO 多路复用（高并发中间件底层）
Nginx、Redis、MySQL、MinIO 底层高并发网络模型
替代 select/poll，百万并发连接，运维调优文件句柄数 ulimit 依赖此特性

3.7 inotify 文件事件监控（rsync+inotify 实时备份底层）
内核监控文件增删改事件，无需轮询磁盘，实时同步工具底层依赖

3.8 大页 HugePage（数据库、Redis、高性能存储必备）
减少内存页表开销，提升数据库读写性能，生产 MySQL/Redis 标准优化

3.9 tc 流量控制（内核网络 QoS）
限制网卡上传下载带宽、流量整形，容器、网关限速底层依赖 netfilter

3.10 conntrack 连接跟踪（iptables/firewalld/容器端口转发）
内核记录 TCP/UDP 连接状态，DNAT/SNAT、端口映射、防火墙状态放行依赖

3.11 tmpfs 内存文件系统
基于内存的临时文件系统，容器/tmp、Redis 缓存、日志临时目录广泛使用

3.12 coredump 内核转储
程序崩溃保存内存堆栈，排查 Java/Go/数据库崩溃故障运维必备

3.13 软中断 irqbalance 内核中断均衡
网卡、磁盘硬件中断分散到多核 CPU，高并发服务器性能优化

###########################################################################
四、分层总结：上层应用分别依赖哪些内核能力（运维记忆）
###########################################################################
1. Docker / K8s 容器：Namespace + Cgroup + OverlayFS + Capabilities + Seccomp
2. Nginx/Redis/MinIO 高并发：epoll、socket、HugePage、tmpfs
3. 实时备份 Rsync-Inotify：inotify
4. 防火墙/网关：Netfilter(iptables)、conntrack、tc 流量控制
5. MySQL 数据库：HugePage、OOM 内存管理、IO 调度、cgroup 资源限制
6. 虚拟机平台：KVM 内核虚拟化模块
7. 安全加固：SELinux、Capabilities、Seccomp
8. 进程通信业务：IPC 全套（管道、共享内存、Unix Socket）

###########################################################################
五、运维学习优先级（从高到低）
###########################################################################
1. 必精通（日常天天接触）
Namespace、Cgroup、OverlayFS、Capabilities、epoll、netfilter、inotify、SELinux
2. 生产优化常用（调优、性能故障）
HugePage、tc 流量控制、conntrack、irq 均衡、ulimit 资源限制
3. 进阶虚拟化/云平台（私有云、OpenStack）
KVM、Seccomp、coredump、内核模块管理
4. 底层深度（性能攻坚、内核崩溃排查）
IPC 全套、内存 OOM 机制、IO 调度、内核参数 sysctl

精简问答总结
1. Linux 内核四大基础子系统
进程管理（含全套 IPC 通信）、内存管理、VFS 文件系统、TCP/IP 网络协议栈
2. 容器三大基石
Namespace（隔离视图）、Cgroup（限制资源）、OverlayFS（分层镜像存储）
3. 运维必须掌握的额外内核特性
Capabilities 细粒度权限、Seccomp 系统调用拦截、SELinux 强制访问控制、epoll 高并发 IO、inotify 文件监控、KVM 虚拟化、HugePage 大页、tc 流量控制、conntrack 连接跟踪、tmpfs 内存盘
4. 运维价值
排查容器逃逸、容器资源超限、Nginx 百万并发卡顿、数据库性能差、防火墙转发异常、实时备份失效等问题，全部需要理解对应内核底层机制。

 介绍一下 Linux 内核的内存管理子系统
面试答案要点：
1) 职责：分配/回收物理内存，管理虚拟内存（页表映射），每个进程有独立地址空间互不干扰
2) 核心机制：
虚拟内存+页表：进程看到的是虚拟地址，按需映射到物理内存，实现进程隔离与内存复用
swap 交换分区：物理内存不足时，把冷数据页换出到磁盘，释放内存给热点数据
页缓存 page cache：读写文件先经过内存缓存，大幅提升 IO 性能（buff/cache 即此）
OOM Killer：内存彻底耗尽时按评分(oom_score)选择杀进程，防止整个系统崩溃
HugePage 大页：默认 4KB 页，页表项多、TLB 易 miss；2MB 大页减少页表与 TLB miss，DB/Redis 优化必备
3) 运维命令：free -m / cat /proc/meminfo / vmstat 1 / top 看内存状态
4) 面试追问：判断内存不足 →swap 使用率高、free 极少、dmesg 有 OOM 日志；
脏页刷盘参数 vm.dirty_ratio（默认 20%）调大可提升写吞吐，但宕机丢数据风险升高
 如何优化 Linux 内核的文件系统性能？
面试答案要点：
1) 选对文件系统：CentOS7 默认 xfs（大数据量、高并发、大文件强）；小文件海量场景可选 ext4
2) 挂载参数优化：noatime/nodiratime（不更新访问时间，减少随机写 IO，收益最明显）
3) 磁盘 IO 调度：SSD/NVMe 用 none(noop)，避免无意义重排序；机械盘用 deadline，减少寻道延迟
4) 内核刷盘参数：调大 vm.dirty_ratio / vm.dirty_background_ratio，让脏页批量落盘，提升吞吐
5) 预读优化：blockdev --setra / sysfs read_ahead_kb 提升顺序读性能；mkfs 时按文件量规划 inode 数量
6) 内存加速：tmpfs 内存盘、HugePage 承载热点数据，绕开磁盘 IO 瓶颈
7) 验证手段：iostat -x 1 看 await/%util，fio 压测对比调优前后效果
 如何使用 Linux 内核的 IPC 进程间通信接口？
面试答案要点（6 种 IPC 全家桶）：
1) 管道 pipe：匿名管道父子进程单向通信，如 cmd1 | cmd2；FIFO 命名管道可任意进程通信
2) 信号 Signal：进程间异步通知，kill -9/-15、SIGCHLD 等，运维最常用
3) 共享内存 shmget/shmat：多进程映射同一物理内存，零拷贝速度最快，需信号量配合防并发冲突
4) 消息队列 msgget/msgsnd/msgrcv：有格式消息传递，多对多，适合小数据量解耦
5) 信号量 semget/semop：PV 操作实现进程互斥与同步，常与共享内存搭配使用
6) Unix Domain Socket：本地 socket 走内存不走网卡，速度高；MySQL(/tmp/mysql.sock)、Nginx、Redis 跨进程通信常用
查看/清理：ipcs -m/-q/-s 查看共享内存/消息队列/信号量；ipcrm 按 ID 删除
面试追问：为什么共享内存最快？→ 多进程直接映射同一块物理内存，读写零拷贝；管道/消息队列数据都要经内核拷贝。
```
``` md
附：Linux 运维核心基本功 经典面试题（带答案）

一、系统启动与初始化
1) 从开机到进入 Linux 系统的完整流程？
BIOS/UEFI 自检 → 读 MBR/GPT→GRUB 加载内核与 initramfs→ 内核初始化硬件 → 挂载根文件系统 →
启动 PID1(systemd)→ 并行启动服务 → 进入登录界面
2) systemd 相比 SysV init 强在哪？
并行启动、按依赖排序、cgroup 管理服务、自动重启、开机更快；SysV 串行脚本慢
3) 如何设置程序开机自启？
systemctl enable 服务名（生成软链）；或 /etc/rc.d/rc.local 加命令并赋执行权限
4) 忘记 root 密码怎么办？
启动菜单按 e 进入 GRUB 编辑，在 linux 行末尾加 rd.break 或 init =/bin/sh，切根后 passwd 重置

二、文件与权限
5) 硬链接和软链接区别？
硬链接：同一 inode、链接计数+1、不能跨文件系统、不能链接目录；
软链接：独立 inode 存目标路径、可跨文件系统、可链接目录、源文件删除即失效
6) 文件权限 rwx 含义与 umask 作用？
r 读 4 w 写 2 x 执行 1；目录 x = 进入权限；umask 决定新建文件/目录默认权限（文件 666 减、目录 777 减）
7) SUID / SGID / 粘滞位？
SUID：以文件属主身份运行；SGID：继承属组（目录继承组）；粘滞位：/tmp 防他人删除自己文件
8) 如何查找大文件 / 目录占用？
du -sh * / du -h --max-depth=1 看目录；find / -size +1G 找大文件；df 看分区

三、进程与系统资源
9) 僵尸进程和孤儿进程区别？
僵尸：子进程退出父进程没 wait，占用 PCB；孤儿：父进程先退，被 init(1 号)收养
10) 如何定位 CPU / 内存 / IO 瓶颈？
CPU：top 看 us/sy/wa，load 对比核数，pidstat 定位进程；
内存：free 看 available/swap，top 按 RES 排序；
IO：iostat -x 看%util/await，iotop 定位进程
11) 如何限制进程可打开文件数和线程数？
ulimit -n 文件句柄、ulimit -u 进程数；永久改 /etc/security/limits.conf
12) 进程被 kill -9 杀不掉怎么办？
大概率 D 状态（不可中断睡眠），等待磁盘/内核 IO 恢复；实在不行只能重启系统

四、网络基础
13) TCP 三次握手与四次挥手？
握手：SYN→SYN+ACK→ACK，建立连接；挥手：FIN→ACK→FIN→ACK，先关一方再关另一方
14) 如何排查端口被占用 / 服务连不上？
ss -tulnp 看监听；telnet/nc 测端口连通；netstat -ant 看连接状态；tcpdump 抓包分析
15) 静态 IP 配置两种方式？
nmcli con mod 连接名 ipv4.addresses/ipv4.method manual + nmcli con up；或传统 ifcfg 文件
16) DNS 解析顺序？
hosts 文件 → 系统缓存 →DNS 服务器；nslookup/dig 查解析，getent hosts 看系统实际解析

五、Shell 与文本处理
17) 三剑客各擅长什么？
grep：文本筛选匹配；sed：流编辑替换/删除/增行；awk：列处理统计求和
18) find 高频用法？
find /path -name '*.log' -mtime +7 -delete 按名/时间/大小找并删除；-exec 配合处理
19) 如何查看日志实时输出与关键字？
tail -f 实时跟；tail -n 100 看末尾；grep -i error 过滤；journalctl -u 服务 看 systemd 日志

六、存储与磁盘
20) df 和 du 区别？
df 看文件系统空间（含已删未释放）；du 看实际目录占用；df 满但 du 小 →lsof|grep deleted 查已删句柄
21) inode 耗尽怎么办？
df -i 为 100%：大量小文件占满；find 找出小文件目录清理，或规划更大 inode 的文件系统
22) LVM 是什么？优势？
逻辑卷管理：跨盘扩容、快照、在线扩展；pvcreate→vgcreate→lvcreate 三步

七、服务与安全
23) SSH 安全加固要点？
禁 root 登录、密钥登录、改端口、禁密码登录、限制来源 IP、Fail2ban 防爆破
24) firewalld 常用操作？
firewall-cmd --add-port/--add-service --permanent + --reload；zone 概念
25) 系统被入侵第一反应？
断网隔离 → 查进程/启动项/定时任务 → 审计日志 → 修复漏洞 → 改口令

八、容器基础
26) Docker 与虚拟机区别？
Docker 共享宿主机内核，namespace+cgroup 隔离，秒级启动、资源开销小；
虚拟机有独立内核，隔离强、开销大
27) 容器日志怎么看？
docker logs -f 容器；挂载/var/log 持久化；生产用日志采集器(Fluentd/Filebeat)

九、速记口诀
启动：BIOS→GRUB→ 内核 →systemd；权限：r4w2x1，umask 666/777 减；
排查：top 看 CPU、free 看内存、iostat 看 IO、ss 看端口；SSH 安全：禁 root 禁密码

```

---


**⑤ 🎯 面试考点**：
- namespace/cgroup 与容器关系？答：namespace 隔离视图、cgroup 限资源，是容器基石。
- epoll 属于哪个子系统？答：网络/IO 子系统，提供高效事件通知。
- 容器网络靠哪层？答：网络子系统（netns + 虚拟网卡 + 桥/路由）。

# 全文四大补充（学习路线图 / 性能排查方法论 / 监控告警体系 / 容器与 K8s 基础）

> 在模块 1～10 重构完成后追加，不打断既有结构。本章独立成章，与模块 10「四维排障速查」互补：模块 10 是"遇到某类问题用什么命令"的速查；补充二是"怎么系统地把问题想清楚并用高级工具定位根因"；补充三是监控告警；补充四是容器与 K8s。

---

## 补充一、学习路线图整合（从入门到专家的完整路径）

### 1. 一句话本质

- 路线图 = 把全书零散知识点按"能用 → 熟练 → 精通"串成阶梯，让你随时知道"现在在哪、下一步学什么、哪些该深哪些够用"。

### 2. 为什么需要路线图

- 运维知识体系广、易"学散"：今天学 Docker、明天学 MySQL，彼此不连，遇到故障仍不会定位。
- 路线图作用：① 建立全局观；② 区分深度与广度；③ 面试时有一条主线可讲，比罗列技能显体系。

### 3. 四个阶段总览（编号清单，避免表格）

1. **初级（0～1 年，能上岗）**
   - 核心：Linux 基础命令、文件/权限、软件包、基础服务部署、Shell 脚本。
   - 对应模块：模块 1～4、模块 7（包管理）、模块 8（基础服务）、模块 9（Shell）。
   - 里程碑：独立装系统、部署 LNMP、写自动化备份脚本。
2. **中级（1～3 年，能排障）**
   - 核心：网络排障、性能排查、日志体系、监控搭建、数据库与缓存运维。
   - 对应模块：模块 5（网络）、模块 6（安全）、模块 10（日志/排障）、补充二/三。
   - 里程碑：线上故障 30 分钟内定位、独立搭建 Prometheus + Grafana 监控。
3. **高级（3～5 年，能架构）**
   - 核心：容器与 K8s、高可用架构、CI/CD、容量规划、SRE 实践。
   - 对应模块：补充四（容器 K8s）、模块 8 进阶、补充二（高阶排查）。
   - 里程碑：设计高可用 Web 架构、主导 K8s 集群落地。
4. **专家（5 年+，能定标准）**
   - 核心：多云/混合云、可观测性体系、故障演练、SLO 治理、团队规范。
   - 对应：补充二/三深化、SRE 工程实践。
   - 里程碑：定 SLO、建混沌工程、带团队沉淀方法论。

### 4. 推荐学习顺序（关键路径）

1. 先打 Linux 底子（模块 1～4），**不要跳**：命令不熟直接学 K8s 会卡在"为什么 Pod 起不来"。
2. 再学网络 + 脚本（模块 5、9）：排障一半靠网络知识，一半靠会写脚本批量操作。
3. 然后性能 + 日志 + 监控（模块 10、补充二/三）：开始具备"线上战斗力"。
4. 最后容器云原生（补充四）：在前面的地基上，容器只是"包装方式"，并不难。

### 5. 每阶段建议时长

1. 初级：3～6 个月，交付一台可上线服务器。
2. 中级：6～12 个月，独立负责一个服务的监控 + 告警 + 排障。
3. 高级：12～24 个月，主导一次架构升级且零事故。
4. 专家：持续，建立团队可复用方法论。

### 6. 常见弯路（避坑）

- ★ 只学工具不学原理：会敲 `kubectl` 但不懂 cgroup，集群一异常就懵。
- ★ 过早追新：K8s 没熟就学 Service Mesh，基础不稳。
- ★ 忽视脚本：手工操作不沉淀，重复劳动且易错。
- ★ 不碰监控：等故障才慌，没有数据支撑决策。

### 7. 🎯 面试怎么讲路线图

- 用"四阶段"框架自我介绍成长路径，比罗列技能更显体系。
- 每个阶段能举一两个"我做过的项目 / 排过的故障"佐证，而不是空讲概念。

---

## 补充二、性能排查方法论（系统化）

> 与模块 10「四维排障速查」互补：模块 10 是"遇到 CPU/内存/磁盘/网络问题用什么命令"的速查表；本章是"怎么系统地把问题想清楚、用高级工具定位根因"。

### 1. 一句话本质

- 性能排查 = 在「资源（CPU/内存/IO/网络）」和「时间（延迟/吞吐）」两个维度上，用数据定位瓶颈，而不是靠猜。

### 2. 总方法论：从现象到根因的五步

1. **定义问题（现象）**：是什么慢？QPS 掉 / 延迟高 / 超时？用可量化指标描述（如 P99 从 50ms 涨到 800ms）。
2. **建立基线**：正常时指标什么样？没基线就无法判断"异常"——这就是监控的价值。
3. **分层定位（瓶颈在哪层）**：应用层 → 系统调用层 → 内核层 → 硬件层，自顶向下逐层排除。
4. **根因分析**：用 USE / RED 方法缩小范围，用 `perf` / 火焰图看"时间花哪了"。
5. **验证与回归**：改完复测，确认指标回到基线，并加监控/告警防复发。

### 3. 三个思维模型

- **USE 方法（资源类）**：对每类资源问 Utilization（利用率）/ Saturation（饱和度，即排队）/ Errors（错误）。适合排"资源瓶颈"。
- **RED 方法（请求类）**：对每类服务问 Rate（速率）/ Errors（错误率）/ Duration（耗时）。适合排"服务慢"。
- **黄金四信号（Google SRE）**：延迟 / 流量 / 错误 / 饱和度。监控告警都围绕这四个。

### 4. 工具矩阵（系统化，编号清单替代表格）

1. **概览层**：`top` / `htop`（进程）、`vmstat 1`（系统整体）、`sar -A`（历史回溯）。
2. **CPU 层**：`mpstat -P ALL 1`（每核）、`pidstat -u 1`（进程级）、`perf top` / `perf record`。
3. **内存层**：`free -h`、`cat /proc/meminfo`、`pidstat -r 1`、`smem`（按进程真实占用）。
4. **IO 层**：`iostat -xz 1`（磁盘）、`iotop`（进程级）、`lsof`（打开文件）。
5. **网络层**：`ss -tanp`、`ip -s link`、`sar -n DEV 1`、`tcpdump` / `wireshark`。
6. **内核/高级**：`perf`、`ftrace`、`bcc` / `bpftrace`（eBPF 动态追踪）、火焰图（`FlameGraph`）。

### 5. 火焰图（最值得学的可视化）

- **是什么**：把调用栈按"占用 CPU/时间"横向堆叠，宽 = 耗时多。横轴是采样堆叠（不代表时间顺序），纵轴是调用深度。
- **怎么读**：找最宽的"平顶"——那是热点函数。
- **怎么生成（on-CPU 火焰图）**：

```bash
# 1) 采样 30 秒，记录调用栈（需 perf，CentOS: yum install perf）
perf record -F 99 -a -g -- sleep 30
#   -F 99   采样频率 99Hz（每秒约 99 次，避开 100 的取整偏差）
#   -a      所有 CPU
#   -g      记录调用栈
#   -- sleep 30  采样持续 30 秒

# 2) 生成火焰图（需 FlameGraph 脚本：git clone https://github.com/brendangregg/FlameGraph）
perf script | ./FlameGraph/stackcollapse-perf.pl | ./FlameGraph/flamegraph.pl > cpu.svg
#   浏览器打开 cpu.svg，横向最宽处即 CPU 热点
```

- **常见类型**：on-CPU（CPU 热点）、off-CPU（等锁 / 等 IO）、内存 / 堆火焰图。

### 6. 典型场景系统化套路

- **CPU 100%**：`top` 找进程 → `perf top` 看函数 → 火焰图定位热点 → 是否死循环 / 正则回溯 / 频繁序列化。
- **内存慢慢涨（泄漏）**：`free` / `smem` 观察趋势 → 区分 cache 还是 RSS → 应用层查对象未释放（Java 堆 dump / Python 看引用）。
- **IO 瓶颈**：`iostat -xz 1` 看 %util / await → `iotop` 找进程 → 是否日志狂写 / 全表扫库。
- **偶发卡顿（锁竞争）**：`perf` 看 `futex` 占比 → off-CPU 火焰图 → 是否锁粒度粗 / 串行。

### 7. 易错点

- ★ 只看 `top` 的 %CPU 就下结论，忽略 `load average` 与 IO 等待（`wa` 高说明在等磁盘，非 CPU 忙）。
- ★ 把 buff/cache 当"内存泄漏"：cache 可回收，`free` 低但 `available` 够就没事。
- ★ 没基线：不知道"正常是多少"，无法判断异常。
- ★ 在容器里看 `top`：看到的是宿主机视角（除非正确隔离），要用 `kubectl top` / cgroup 数据。

### 8. 🎯 面试考点

- USE 与 RED 区别？答：USE 看资源（利用率/饱和度/错误），RED 看请求（速率/错误/耗时）。
- 火焰图横轴代表什么？答：采样堆叠，宽 = 耗时多，非时间线。
- CPU 高但 load 不高？答：可能单核跑满、其他核闲，或计算密集型短任务。

---

## 补充三、监控告警体系

### 1. 一句话本质

- 监控 = 给系统装"仪表盘 + 警报器"，让故障在发生前或发生时被看见，而不是等用户投诉。

### 2. 监控三层（可观测性三大支柱）

1. **Metrics（指标）**：数值时间序列，如 CPU%、QPS。适合告警与趋势。工具 Prometheus。
2. **Logs（日志）**：离散事件文本，如错误栈。适合查"具体为什么"。工具 Loki / ELK。
3. **Traces（链路）**：一次请求跨服务的调用链。适合查"慢在哪一段"。工具 Jaeger / OpenTelemetry。

### 3. 黄金四指标（每个服务都该有）

1. **延迟（Latency）**：请求耗时，看 P99 而非平均（平均会掩盖长尾）。
2. **流量（Traffic）**：QPS / 并发数。
3. **错误（Errors）**：错误率（5xx / 超时占比）。
4. **饱和度（Saturation）**：资源占用，如 CPU%、连接池使用率。

### 4. 技术栈（编号清单）

- **采集**：node_exporter（主机）、mysqld_exporter（DB）、应用埋点（Prometheus client 库）。
- **存储/查询**：Prometheus（TSDB，拉模型）、VictoriaMetrics（替代/横向扩展）。
- **可视化**：Grafana（仪表盘）。
- **告警**：Alertmanager（分组 / 抑制 / 静默 / 路由）。
- **链路**：OpenTelemetry（采集标准）+ Jaeger（存储展示）。

### 5. 告警设计（关键）

- **分级**：P0（电话）/ P1（IM 群）/ P2（工单）。避免全 P0 = 全不理。
- **收敛**：同因多条告警合并（`group_by`）。
- **抑制**：已知维护期 / 依赖故障抑制下游告警（`inhibit_rules`）。
- **静默**：计划内操作临时静默（`silence`）。
- **避免告警疲劳**：★ 每条告警都要"收到后能行动"，否则降级为仪表盘指标。

### 6. SLO / SLI / 错误预算（SRE 核心）

- **SLI** = 实际指标（如成功率）。**SLO** = 目标（如 99.9%）。**错误预算** = 允许失败额度。
- 错误预算烧太快 → 冻结发布；有余量 → 可大胆迭代。用预算替代"唯可用性论"。

### 7. 易错点

- ★ 只监控主机不监控业务：CPU 正常但下单失败，主机指标看不出。
- ★ 告警阈值拍脑袋：靠历史分位设（如 P99 × 1.5），别写死 80%。
- ★ 监控本身无监控：Prometheus 挂了没人知道（用黑盒探测 / 外部心跳）。

### 8. 🎯 面试考点

- Metrics / Logs / Traces 区别？各自用什么？答：指标用 Prometheus、日志用 Loki/ELK、链路用 Jaeger/OTel。
- Prometheus 拉模型 vs 推模型？为何拉？答：拉模型（server 主动 scrape）简单、易自愈、单点故障影响小。
- 如何避免告警疲劳？答：分级 + 收敛 + 抑制 + 每条可行动。

---

## 补充四、容器与 K8s 基础

### 1. 一句话本质

- 容器 = 用 namespace（隔离视图）+ cgroup（限制资源）把进程"关进带自己文件系统的盒子"；K8s = 管理成千上万个这种盒子的调度系统。

### 2. 容器 vs 虚拟机

- **VM**：虚拟化硬件，跑完整 Guest OS，重、启动慢、隔离强。
- **容器**：共享宿主机内核，只隔离进程，轻、启动秒级、密度高。
- 二者不是替代：容器常跑在 VM 里（云上常见组合）。

### 3. 容器三大技术（内核提供）

1. **namespace**：隔离 PID / 网络 / 挂载 / UTS / IPC / User，让容器以为自己独占。
2. **cgroup**：限制 CPU / 内存 / IO 配额，防一个容器吃光宿主机。
3. **镜像分层**：只读层 + 可写层（overlayfs），复用基础镜像，体积小。

### 4. Docker 速用

- **三要素**：镜像（Image）/ 容器（Container）/ 仓库（Registry）。
- **常用命令**：

```bash
docker build -t myapp:v1 .          # 按当前目录 Dockerfile 构建镜像
docker run -d -p 8080:80 --name web myapp:v1   # 后台起容器，映射端口
docker ps                            # 看运行中的容器
docker logs -f web                   # 跟踪日志
docker exec -it web sh               # 进容器排障
docker rm -f web                     # 强删
```

- **Dockerfile 关键指令**：FROM（基础）、RUN（构建层）、COPY/ADD、ENV、EXPOSE、CMD/ENTRYPOINT（启动命令）。
- **镜像瘦身**：多阶段构建（multi-stage）、用 alpine 基础、合并 RUN 并清缓存。

### 5. K8s 架构（控制面 + 数据面）

- **控制面（Master）**：api-server（唯一入口）、scheduler（调度）、controller-manager（维持期望状态）、etcd（唯一数据库）。
- **数据面（Node）**：kubelet（管本机 Pod）、kube-proxy（转发规则）、容器运行时（containerd）。
- 一句话：你告诉 api-server"我要 3 个副本"，controller + scheduler 让现实逼近期望，kubelet 落地。

### 6. 核心对象（必须会）

1. **Pod**：最小调度单位，一个 / 多个共享网络的容器。
2. **Deployment**：管理副本数 + 滚动更新（无宕期发布）。
3. **Service**：固定访问入口，负载均衡到 Pod（ClusterIP / NodePort / LoadBalancer）。
4. **Ingress**：七层路由（域名 → Service）。
5. **ConfigMap / Secret**：配置 / 密钥，与镜像解耦。
6. **PV / PVC**：持久存储声明，Pod 重启数据不丢。

### 7. 关键机制

- **调度**：scheduler 按资源 / 亲和性选节点。
- **健康探针**：liveness（挂了重启）/ readiness（没就绪不接流量）。
- **滚动更新**：Deployment 逐批换 Pod，失败可 `rollback`。
- **HPA**：按 CPU / 自定义指标自动扩副本。

### 8. 网络（CNI）

- Pod 各有 IP，跨节点互通靠 CNI 插件（Calico / Flannel / Cilium）。
- Service 的 ClusterIP 是虚拟 IP，靠 kube-proxy（iptables + ipvs）转发。
- 容器网络模型：Pod 内共享 netns，Pod 间扁平（同网段可达）。

### 9. 实战：部署一个 Web 服务

```bash
kubectl create deployment web --image=myapp:v1 --replicas=3   # 起 3 副本
kubectl expose deployment web --port=80 --target-port=8080    # 暴露 Service
kubectl scale deployment web --replicas=5                      # 扩到 5 副本
kubectl set image deployment/web myapp:v2                      # 滚动更新到 v2
kubectl rollout status deployment/web                         # 看更新进度
kubectl rollout undo deployment/web                           # 回滚
```

### 10. 易错点

- ★ 把容器当 VM：容器是进程，PID 1 退出 = 容器退出，别跑 systemd。
- ★ 镜像存密钥：Secret 用 K8s 管理，别 bake 进镜像。
- ★ 没设资源 limit：一个 Pod 吃满节点；最好显式 `requests` / `limits`。
- ★ 用 `latest` 标签：不可重现，生产锁版本 + 摘要（@sha256）。

### 11. 🎯 面试考点

- 容器底层技术？答：namespace（隔离）+ cgroup（限制）+ overlayfs（分层存储）。
- Pod 与容器区别？答：Pod 是调度最小单位，可含多容器共享网络/存储。
- 滚动更新原理？答：Deployment 控制 ReplicaSet 逐批替换旧 Pod，失败可回滚。
- etcd 作用？答：K8s 唯一真源数据库，存全部集群状态。
