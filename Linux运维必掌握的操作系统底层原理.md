# Linux 运维必掌握的操作系统底层原理（实战导向）

运维学习底层原理，核心目标是**故障根因排查、性能调优、资源管控**，无需深入内核源码，但要吃透核心机制与生产现象的对应关系。以下按优先级从高到低排序，全部贴合运维日常工作与面试考点。

------

## 一、进程与调度管理（日常排障最高频，必学）

### 核心原理

1. 进程本质与生命周期
   - 进程是资源分配的最小单位，内核通过`task_struct`（PCB 进程控制块）管理所有进程信息
   - 7 种核心状态：运行、就绪、可中断休眠、不可中断休眠、停止、僵尸进程、孤儿进程
   - 高频考点：僵尸进程 / 孤儿进程的成因、危害、处理方式
   - 文件描述符（fd）：进程打开文件 / 网络连接的内核句柄；`ulimit`限制原理，`too many open files`故障根因
2. 进程调度机制
   - 普通进程默认使用**CFS 完全公平调度器**，按时间片轮转调度；实时进程支持 FIFO/RR 调度
   - 优先级体系：nice 值（-20~19）、PRI 优先级，数值越低优先级越高
   - **Load Average 本质**：单位时间内「运行态 + 不可中断休眠态」的进程总数，不等于 CPU 使用率（面试必问）
3. 线程与进程
   - Linux 下线程本质是**轻量级进程（LWP）**，共享进程地址空间，由内核统一调度
   - 多进程 vs 多线程的资源开销、适用场景差异
4. 进程间通信（IPC）**IPC = Inter-Process Communication**
   - 管道、消息队列、共享内存、信号量、Unix 域套接字的原理与优缺点
   - 信号机制：`SIGTERM`/`SIGKILL`/`SIGHUP`等常见信号的区别，`kill`命令底层逻辑

### 运维关联工具

```
ps、top/htop、pstree、kill、nice/renice、strace、lsof
```

### 进程状态详解

```bash
ps 命令展示的进程状态（Linux 标准，分两类：内核原始 state /ps 展示简写）
一、ps 输出常见单字符状态码（ps aux / top 看到的 STAT 列）
表格
状态字符	内核真实状态	          含义说明
R	      TASK_RUNNING	        运行 / 就绪态：正在 CPU 运行，或排队等待调度
S	      TASK_INTERRUPTIBLE	可中断睡眠：等待资源，能被信号唤醒（最常见）
D	      TASK_UNINTERRUPTIBLE	不可中断睡眠（磁盘 IO 阻塞），无法被 kill -9 杀死
Z	      EXIT_ZOMBIE	        僵尸进程：子进程已退出，父进程未回收 PCB
T	      TASK_STOPPED	        暂停：收到 SIGSTOP、gdb 断点调试暂停
t	      TASK_TRACED	        被调试器跟踪（gdb 附加调试）
X	      EXIT_DEAD	            进程彻底消亡，仅短暂出现，基本看不到
I	      空闲内核线程	        内核后台线程（kworker 类）
二、额外附加标识（STAT 列第二个字符）
s：session leader（会话首进程，如 bash）
l：多线程进程（拥有多个 LWP 轻量级线程）
+：前台进程，绑定终端
N：低 nice 值，优先级降低
<：高优先级进程
L 进程持有内存锁（mlock 锁定内存不换出）

示例
Sl = 可中断睡眠 + 多线程程序
S+ = 前台运行的休眠进程
Rl+ = 前台多线程就绪 / 运行进程

三、内核 7 种完整 task_struct 状态（底层原理，和 ps 对应）
TASK_RUNNING (R)
TASK_INTERRUPTIBLE (S)
TASK_UNINTERRUPTIBLE (D)
TASK_STOPPED (T)
TASK_TRACED (t)
EXIT_ZOMBIE (Z)
EXIT_DEAD (X)
运维高频考点
D 状态进程：等待磁盘 / 存储硬件 IO，kill 无效，只能修复磁盘或重启服务器；
Z 僵尸进程：代码缺少 wait/waitpid 回收，堆积会耗尽 PID；
大量 R 进程：CPU 满载，存在计算瓶颈。
```









```bash

一、进程创建 (fork) 时，内核分配 / 复制的全部资源（基于 Linux task_struct）
进程是资源分配最小单位，线程是调度最小单位；调用fork()创建子进程，会复制父进程绝大多数资源，内核新建独立task_structPCB。
1. 核心内核结构体资源（必新建）
task_struct PCB 进程控制块
存储进程 PID、状态、优先级、调度 counter、信号掩码、退出码、内存指针、文件指针等全部元数据。
独立地址空间描述符 mm_struct
虚拟内存空间、页表、堆 / 栈 / 代码段映射、brk 堆指针、VMA 虚拟内存区域链表。
写时复制 COW：fork 初期父子共享物理内存页，任意一方修改才分配新物理页。
信号管理结构 signal_struct
独立信号处理函数、未决信号队列、信号屏蔽掩码、退出信号。
2. 文件相关资源（复制句柄，不复制文件本身）
文件描述符表 files_struct
0 标准输入、1 标准输出、2 标准错误、打开的普通文件 / 套接字 / 设备 fd 全部复制，引用计数 + 1；父子共用文件偏移量。
打开的目录、管道、socket、字符 / 块设备句柄全部继承。
文件系统上下文 fs_struct
根目录、当前工作目录 cwd、umask 权限掩码。
3. 内存资源
用户态栈：分配独立进程栈（默认 8M，有栈溢出保护）
内核栈：每个进程专属内核栈，系统调用 / 中断时使用
共享库、代码段：COW 共享，不立刻分配新物理内存
堆空间：共用映射，修改后新分配物理内存
4. 进程间通信 IPC 资源（继承引用）
消息队列、共享内存、信号量、匿名管道、命名管道、Unix 域套接字，继承引用计数。
5. 权限 / 身份资源
uid/gid、有效用户 euid、保存用户 suid、文件访问权限
进程能力 capabilities、SELinux 安全上下文
6. 调度相关资源
nice 值、静态 / 动态优先级、调度实体、调度组
CPU 亲和性掩码、NUMA 内存绑定配置
7. 时间、统计资源
进程 CPU 耗时（用户态 / 内核态）、页面缺页统计、IO 读写字节统计、计时器。
8. 命名空间资源（容器底层）
PID / 网络 / 挂载 / 用户 / UTS 命名空间，子进程继承父进程 ns（容器隔离核心）
9. 不复制、完全独立的资源
PID、TGID（进程组 ID）
待处理定时器
僵尸进程退出状态
锁、等待队列私有等待项
补充：execve 执行新程序时额外变更
fork 只复制资源，exec()加载新程序会销毁原有用户地址空间，重新分配代码段、全局数据、堆，仅保留 fd、信号掩码、权限、命名空间。
二、SRE / 运维必须吃透的进程全套核心知识点
1. 进程标识体系
PID：进程唯一 ID
PPID：父进程 ID；init/systemd (PID1) 是所有进程祖先
PGID 进程组 ID：管道、后台作业同属一个进程组
SID 会话 ID：终端登录会话，setsid 创建守护进程
前台 / 后台进程、SIGTTIN/SIGTTOU 终端控制信号
2. 7 种进程状态（task_struct->state，面试必考）
plaintext
TASK_RUNNING        运行/就绪，可被调度上CPU
TASK_INTERRUPTIBLE  可中断睡眠，等待资源，信号可唤醒（ps S）
TASK_UNINTERRUPTIBLE不可中断睡眠，磁盘IO/锁，信号无法唤醒（ps D）
TASK_STOPPED        暂停，SIGSTOP信号（ps T）
TASK_TRACED         被gdb调试暂停
EXIT_ZOMBIE         僵尸进程：子进程退出，父进程未wait回收PCB
EXIT_DEAD           彻底销毁，资源全部释放
僵尸进程危害：PCB 残留，占用 PID 资源，大量僵尸导致无法新建进程
孤儿进程：父进程先退出，自动被 PID1 收养，不会变僵尸
3. 调度核心（关联 Linux1.0 调度伪代码）
CFS 完全公平调度器、时间片 counter、动态优先级公式
nice -20~19，PRI 调度优先级
Load Average 含义：运行态 + 不可中断睡眠进程总数
上下文切换：用户态 <-> 内核态切换，频繁切换损耗 CPU 性能
多线程：Linux 线程是轻量级进程 LWP，共享 mm 内存、fd、信号；仅独立栈 + 调度实体
4. 内存与进程关系（高频故障）
VMA 虚拟内存区域：代码段、只读段、堆、栈、共享库、共享内存段
COW 写时复制原理，fork 性能优化
OOM Killer：内存耗尽，按 oom_score 杀死高内存进程
swapiness、kswapd 回收内存、页面缺页异常
栈溢出、ulimit 限制（nofile 栈大小 nproc 进程数）
5. 信号机制（进程通信基础）
常用信号：
SIGINT (2) Ctrl+C、SIGKILL (9) 强制杀、SIGTERM (15) 优雅退出、SIGCHLD 子进程退出、SIGSTOP 暂停
信号处理三方式：忽略、默认处理、自定义捕获
信号屏蔽、未决信号队列、不可屏蔽信号 9/19
守护进程标准流程：fork 两次 + setsid + 重定向 fd + 修改工作目录
6. 进程生命周期完整流程
fork()：复制 PCB 与资源，生成子进程
子进程execve()：加载可执行程序，重建地址空间
运行：CPU 调度执行代码，读写文件 / 网络 / 内存
退出：exit() / 信号杀死，进入僵尸态
父进程wait()/waitpid()：读取退出码，销毁 PCB，资源释放
7. 进程间通信 IPC（你之前学的 ipc 子系统）
匿名管道 pipe：父子进程单向通信
命名管道 FIFO：无亲缘进程通信
System V IPC：消息队列、信号量 (互斥锁)、共享内存 (最快 IPC)
Unix 域 socket：本地高性能套接字
信号：简单异步通知
8. 资源限制 ulimit /prlimit
每个进程资源硬限制，线上故障高发点：
open files：最大文件句柄（too many open files）
nproc：最大子进程数
stack：进程栈大小
core file：崩溃转储文件生成开关
9. 运维排查工具链（SRE 日常）
查看进程：ps -ef / ps aux / pstree / htop
查看 PCB 详情：cat /proc/[pid]/ 伪文件系统
/proc/pid/status 内存状态、fd 目录、maps 虚拟内存、cmdline 启动命令
追踪系统调用：strace -p pid 定位阻塞、文件、网络卡顿
内存查看：pmap -x pid
信号操作：kill / killall / pkill
优先级调整：nice / renice
10. 容器与进程关联（云原生 SRE 必备）
Namespace：PID / 网络 / 挂载隔离，容器本质是一组隔离的进程
Cgroup：限制进程 CPU、内存、IO、磁盘资源，防止单进程耗尽整机资源
rootfs 文件系统隔离、chroot 基础隔离原理
11. 常见线上故障（SRE 高频场景）
D 状态不可中断进程：磁盘卡死、存储故障，无法 kill，只能重启
大量僵尸进程：父进程未回收子进程，代码缺少 wait
句柄泄漏：程序打开文件 / 套接字不关闭，触发 too many open files
内存泄漏：进程堆持续上涨，最终触发 OOM
上下文切换过高：多线程锁竞争、频繁 IO、大量短生命周期进程
后台进程丢失输出、终端挂断进程退出（nohup/setsid 原理）





```

进程状态

```bash
ps 命令展示的进程状态（Linux 标准，分两类：内核原始 state /ps 展示简写）
一、ps 输出常见单字符状态码（ps aux / top 看到的 STAT 列）
表格
状态字符	内核真实状态	          含义说明
R	      TASK_RUNNING	        运行 / 就绪态：正在 CPU 运行，或排队等待调度
S	      TASK_INTERRUPTIBLE	可中断睡眠：等待资源，能被信号唤醒（最常见）
D	      TASK_UNINTERRUPTIBLE	不可中断睡眠（磁盘 IO 阻塞），无法被 kill -9 杀死
Z	      EXIT_ZOMBIE	        僵尸进程：子进程已退出，父进程未回收 PCB
T	      TASK_STOPPED	        暂停：收到 SIGSTOP、gdb 断点调试暂停
t	      TASK_TRACED	        被调试器跟踪（gdb 附加调试）
X	      EXIT_DEAD	            进程彻底消亡，仅短暂出现，基本看不到
I	      空闲内核线程	        内核后台线程（kworker 类）
二、额外附加标识（STAT 列第二个字符）
s：session leader（会话首进程，如 bash）
l：多线程进程（拥有多个 LWP 轻量级线程）
+：前台进程，绑定终端
N：低 nice 值，优先级降低
<：高优先级进程
L 进程持有内存锁（mlock 锁定内存不换出）
示例
Sl = 可中断睡眠 + 多线程程序
S+ = 前台运行的休眠进程
Rl+ = 前台多线程就绪 / 运行进程
三、内核 7 种完整 task_struct 状态（底层原理，和 ps 对应）
TASK_RUNNING (R)
TASK_INTERRUPTIBLE (S)
TASK_UNINTERRUPTIBLE (D)
TASK_STOPPED (T)
TASK_TRACED (t)
EXIT_ZOMBIE (Z)
EXIT_DEAD (X)
运维高频考点
D 状态进程：等待磁盘 / 存储硬件 IO，kill 无效，只能修复磁盘或重启服务器；
Z 僵尸进程：代码缺少 wait/waitpid 回收，堆积会耗尽 PID；
大量 R 进程：CPU 满载，存在计算瓶颈。
```





## 二、内存管理（性能调优 + 故障排查核心）

### 核心原理

1. 虚拟内存机制（核心基石）
   - 每个进程拥有独立的虚拟地址空间，通过 MMU 硬件 + 页表完成「虚拟地址→物理地址」转换
   - 核心价值：进程内存隔离、内存保护、支持内存超额分配
2. 物理内存分配
   - 伙伴系统：管理物理页，解决内存外部碎片问题
   - slab/slub 分配器：缓存内核小对象，解决内部碎片，提升内存分配效率
3. 页缓存（Page Cache）
   - 内核用空闲内存缓存文件数据，是`free`命令中`cached`的主体
   - 写缓存机制：先写内存再异步刷盘，由`pdflush`内核线程负责；`dirty`相关参数控制刷盘阈值
   - Buffer Cache：缓存块设备元数据，现代内核已逐步与页缓存融合
4. Swap 交换机制
   - 本质：用磁盘空间模拟内存，由`kswapd`内核线程触发内存回收
   - `swappiness`参数：控制内存回收时使用 Swap 的倾向，数据库场景建议调至 1~10
5. OOM Killer 机制
   - 系统内存耗尽时，内核按`oom_score`评分杀掉占用内存高的进程
   - 可通过`oom_adj`调整进程被杀优先级，保护核心业务进程
6. NUMA 内存架构
   - 多 CPU 服务器中，每个 CPU 绑定本地内存，跨 NUMA 节点访问内存延迟提升 50% 以上
   - 数据库场景关闭 NUMA 自动平衡、手动绑核绑内存的底层逻辑

### 运维关联工具

```
free`、`vmstat`、`sar -r`、`top`、`numactl`、`pmap`、`dmesg
```

------

## 三、文件系统与 IO 栈（IO 故障 + 调优核心）

### 核心原理

1. VFS 虚拟文件系统
   - 内核抽象层，提供统一的文件操作接口，向下兼容 Ext4、XFS、Btrfs 等不同文件系统
2. 主流文件系统核心特性
   - Ext4：日志式、延迟分配，通用场景稳定
   - XFS：高并发大文件性能优异，支持在线扩容，生产数据库标配
   - Btrfs：支持子卷、快照、数据校验，云原生场景逐步普及
   - 文件系统日志三模式：`writeback`/`ordered`/`journal`，可靠性与性能的权衡
3. IO 核心模型（面试高频）
   - 5 种 IO 模型：阻塞 IO、非阻塞 IO、IO 多路复用、信号驱动 IO、异步 IO
   - `epoll`核心原理：水平触发 / 边缘触发，Nginx、Redis 高性能的底层原因
   - Buffered IO（缓存 IO）vs Direct IO（直接 IO）：数据库绕过页缓存、使用 Direct IO 的原因
4. IO 调度算法
   - 主流算法：Noop、Deadline、CFQ（旧内核）、MQ-Deadline（新内核）
   - 选型规则：SSD/NVMe 用 Noop/Deadline，机械盘用 CFQ/BFQ

### 运维关联工具

```
iostat`、`iotop`、`df`、`du`、`fio`、`dd`、`tune2fs`、`xfs_info
```

------

## 四、网络协议栈（网络排障必备）

### 核心原理

1. 数据包内核处理路径

   网卡接收 → 硬中断通知 → 软中断协议栈解析 → socket 缓冲区 → 用户态进程

2. TCP 核心机制（面试 100% 高频）

   - 三次握手、四次挥手的完整状态流转
   - 滑动窗口、拥塞控制（慢启动、拥塞避免、快重传、快恢复）
   - `TIME_WAIT`/`CLOSE_WAIT`成因、危害、内核参数优化方案
   - 半连接队列、全连接队列原理，SYN 洪水攻击的防护手段

3. 中断与网络性能

   - 硬中断（`hi`）：硬件触发，快速响应；软中断（`si`）：内核线程延后处理，网络收包核心
   - 网卡多队列、中断亲和性调优：把网络中断分散到多个 CPU 核心，避免单核心瓶颈

4. Netfilter 防火墙机制

   - 五表五链钩子机制，iptables 数据包的完整处理流程
   - nftables 对 iptables 的演进与替代

5. 零拷贝技术

   - `mmap`、`sendfile`原理，Kafka、Nginx 实现高性能文件传输的底层逻辑

### 运维关联工具

```
ss`、`tcpdump`、`wireshark`、`ethtool`、`sar -n DEV`、`cat /proc/interrupts
```

------

## 五、系统启动与初始化（故障修复必备）

### 核心原理

1. 完整启动流程

   BIOS/UEFI 自检 → GRUB2 引导加载器 → 内核vmlinuz加载 → initramfs临时根文件系统 → Systemd 初始化 → 运行级别.target → 终端 / 用户登录

2. Systemd 核心机制

   - Unit 单元管理、Target 运行级别、依赖解析、并行启动
   - 相比传统 SysVinit 的核心优势

3. 常见启动故障

   GRUB 损坏、根文件系统挂载失败、内核 panic 的排查与修复思路

### 运维关联工具

```
grub2-install`、`systemctl`、`dmesg`、`journalctl
```

------

## 六、权限与安全底层（权限管控 + 合规）

### 核心原理

1. DAC 自主访问控制
   - UID/GID 权限模型，文件`rwx`权限的底层含义（目录与文件权限的差异）
   - SUID/SGID/ 粘滞位的原理与典型应用场景
2. Capabilities 能力机制
   - 拆分 root 超级权限，精细化赋予进程特定权限，是比 SUID 更安全的替代方案
3. MAC 强制访问控制
   - SELinux/AppArmor 核心逻辑，与 DAC 的本质区别
   - 运维高频坑：SELinux 导致服务权限异常的排查思路
4. 资源隔离基础
   - chroot、命名空间（Namespace）的原理，是容器技术的底层基石

### 运维关联工具

```
chmod`、`chown`、`getcap/setcap`、`getenforce`、`chroot
```

------

## 七、系统调用与中断（进阶理解）

### 核心原理

1. 用户态与内核态
   - CPU 权限分级，用户态只能访问受限资源，内核态可访问所有硬件资源
   - 切换触发场景：系统调用、异常、硬件中断
2. 系统调用
   - 本质：用户程序调用内核功能的统一接口（如`open`、`read`、`write`）
   - `strace`工具原理：跟踪进程所有系统调用，是排查程序异常的神器
3. 内核模块机制
   - Linux 模块化设计，驱动、功能可动态加载卸载，无需重新编译内核

### 运维关联工具

```
strace`、`ltrace`、`lsmod`、`modprobe
```

------

## 学习优先级总结

- **初级运维**：熟练掌握进程管理、内存管理、IO 基础、网络基础、启动流程
- **中级运维**：吃透全部核心原理，能对应到故障现象与调优手段
- **高级运维**：深入内核调优、资源隔离、性能瓶颈根因分析，支撑架构设计







# linux系统内核的模块划分

## Linux 1.0 内核的模块划分（源码目录对应）

Linux 1.0 总代码量约 15 万行，目录结构已经完全模块化，和现代内核一脉相承：

| 源码目录   | 对应内核子系统          | 核心功能                                       |
| :--------- | :---------------------- | :--------------------------------------------- |
| `kernel/`  | 进程调度子系统（核心）  | 进程创建销毁、CPU 调度、信号处理、系统调用入口 |
| `mm/`      | 内存管理子系统          | 虚拟内存、物理页分配、页表、内存回收           |
| `fs/`      | 虚拟文件系统子系统      | VFS 抽象层、Ext/MINIX 文件系统、块设备管理     |
| `net/`     | 网络子系统              | TCP/IP 协议栈、socket 接口、网卡驱动           |
| `ipc/`     | 进程间通信（IPC）子系统 | System V 标准 IPC 机制                         |
| `drivers/` | 硬件驱动层（底层支撑）  | 字符设备、块设备、终端、硬盘等硬件驱动         |

> 经典定义：前 5 个为**内核核心逻辑子系统**；驱动层是对接硬件的支撑模块，向上给各个子系统提供硬件操作能力，不单独作为逻辑子系统。



Linux 内核采用**单内核 + 模块化设计**，整体从下到上可分为「物理硬件→驱动层→内核核心子系统→系统调用接口→用户态命令 / 应用」五层。你说的 “最下层是硬件驱动” 完全正确：驱动是内核直接对接硬件的最底层模块，向上屏蔽硬件差异，给核心子系统提供统一的操作接口。

内核核心功能分为**6 大子系统**，下面逐个说明核心功能，并对应上层运维常用命令：

------

## 一、设备驱动子系统（内核最底层，对接硬件）

### 核心功能

内核与物理硬件的唯一桥梁，把不同硬件的操作差异封装起来，给上层提供统一调用接口，分为三类：

- 字符设备驱动：键盘、串口、终端等
- 块设备驱动：磁盘、U 盘等存储设备
- 网络设备驱动：网卡等

### 上层常用命令

- 硬件识别：`lspci`（PCI 设备）、`lsusb`（USB 设备）、`lsblk`（块存储设备）
- 驱动管理：`lsmod`（查看已加载驱动）、`modprobe`（加载 / 卸载驱动）
- 硬件状态：`ethtool`（网卡状态）、`smartctl`（硬盘健康）、`dmesg`（硬件驱动日志）

------

## 二、进程调度与管理子系统

### 核心功能

负责所有进程 / 线程的创建、销毁、状态切换、CPU 资源调度；默认使用 CFS 完全公平调度器，按时间片分配 CPU；管理进程生命周期、信号机制、系统负载计算。

### 上层常用命令

- 进程查看：`ps`、`top/htop`、`pstree`、`uptime`（系统负载）
- 进程控制：`kill`、`nice/renice`（调整进程优先级）
- 进程追踪：`strace`（跟踪进程系统调用）

------

## 三、内存管理子系统

### 核心功能

统一管理物理内存与虚拟内存；通过伙伴系统、slab 分配器精细化分配内存；实现页缓存、Swap 交换、OOM 内存回收、NUMA 内存调度；通过 MMU 硬件完成「虚拟地址→物理地址」的转换。

### 上层常用命令

- 内存概览：`free -h`、`vmstat 1`
- 进程级内存：`top`、`pmap`
- NUMA 管理：`numactl`
- 故障排查：`dmesg | grep -i oom`（查看 OOM 杀进程日志）

------

## 四、文件系统与 IO 子系统

### 核心功能

通过 VFS 虚拟文件系统抽象层，统一兼容 Ext4、XFS、Btrfs 等不同文件系统；管理块设备 IO 调度、页缓存、脏页异步刷盘；负责文件读写、权限校验、目录管理。

### 上层常用命令

- 空间查看：`df -h`、`du -sh`
- IO 监控：`iostat -x 1`、`iotop`
- 文件系统管理：`mount`、`mkfs`、`xfs_growfs`、`tune2fs`
- 性能压测：`fio`、`dd`

------

## 五、网络协议栈子系统

### 核心功能

实现完整 TCP/IP 协议栈，提供 socket 编程接口；处理网卡数据包收发、TCP 连接管理、滑动窗口、拥塞控制、路由转发；内置 netfilter 防火墙框架。

### 上层常用命令

- 连接查看：`ss`、`netstat`
- 网络配置：`ip addr`、`ip route`
- 抓包分析：`tcpdump`、`wireshark`
- 防火墙：`iptables`、`nftables`
- 流量监控：`sar -n DEV`、`iftop`

------

## 六、进程间通信（IPC）子系统

### 核心功能

提供同一主机内进程间数据交互的机制，包括管道、消息队列、共享内存、信号量、Unix 域套接字。

### 上层常用命令

`ipcs`（查看 IPC 资源）、`ipcrm`（删除 IPC 资源）

------

## 补充：内核基础支撑组件

除了 6 大核心子系统，还有贯穿所有模块的基础能力：

1. **系统调用接口**：用户态和内核态的唯一交互入口，所有命令、程序最终都通过系统调用调用内核能力
2. **中断处理**：响应硬件中断（如网卡收包、磁盘 IO 完成）
3. **内核同步机制**：解决多核并发下的资源竞争（自旋锁、信号量等）
4. **定时器**：管理内核定时任务（如脏页刷盘、连接超时检测）

------

## 上下层交互逻辑（以`ls`命令为例）

用户输入命令 → 调用系统 glibc 库 → 触发系统调用 → 内核文件系统子系统处理 → 调用块设备驱动 → 读取磁盘数据 → 逐层返回结果给用户。





# Linux 目录结构（FHS 标准 + 运维视角）

Linux 采用**单根树形目录结构**，统一遵循 FHS（文件系统层次标准），所有文件都以根目录 `/` 为起点。下面按功能分类梳理，标注运维高频使用的核心目录。

------

## 一、系统启动与内核目录

| 目录          | 核心作用                                                     | 运维说明                             |
| :------------ | :----------------------------------------------------------- | :----------------------------------- |
| `/boot`       | 存放系统启动核心文件：Linux 内核镜像（vmlinuz）、引导加载器（GRUB）、内存盘镜像（initramfs） | 系统启动必备目录，禁止随意删除文件   |
| `/boot/grub2` | GRUB 引导程序配置目录，开机启动项、内核启动参数都在此配置    | 修复系统启动、修改内核参数的核心目录 |

------

## 二、系统配置核心目录（运维最高频）

| 目录       | 核心作用                                                     | 典型子目录 / 文件                                            |
| :--------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| **`/etc`** | 系统全局配置文件总目录，所有系统服务、全局参数的配置几乎都在这里 | `/etc/sysconfig` 网络 / 服务参数`/etc/fstab` 磁盘挂载配置`/etc/profile` 全局环境变量`/etc/crontab` 系统定时任务`/etc/my.cnf` MySQL 等服务配置 |

> 补充：`/etc/init.d` 是旧版 SysVinit 服务脚本目录，systemd 体系下已逐步替代为 `/usr/lib/systemd/system`。

------

## 三、命令与程序安装目录

分为「基础维护命令」和「用户程序」两类，核心区别是：单用户救援模式下是否可用。



| 目录                  | 核心作用                                                     | 权限与场景                                                   |
| :-------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| `/bin`-->/usr/bin/    | 基础通用命令（ls、cp、mv、cat 等）                           | 所有用户可执行，单用户模式也能使用                           |
| `/sbin`-->/usr/sbin/  | 系统级管理命令（fdisk、reboot、ifconfig 等）                 | 仅 root 可用，用于系统维护修复                               |
| `/usrusr/sbin/`       | 全称 *Unix Software Resource*，系统软件资源主目录，相当于 Windows 的 Program Files | 系统自带软件、包管理器安装的软件都在此                       |
| `/usr/bin`            | 大部分普通用户命令、应用程序可执行文件                       | 普通用户可执行，日常命令大多在这里                           |
| `/usr/sbin`           | 更多系统管理命令、网络工具                                   | 仅 root 可执行                                               |
| `/usr/lib /usr/lib64` | 程序依赖的动态库、静态库文件                                 | 程序运行报错「缺少库文件」时排查此处                         |
| `/usr/local`          | 手动编译安装软件的默认路径                                   | 不被 yum/apt 包管理，自定义安装的软件放这里                  |
| `/opt`                | 可选第三方软件目录                                           | 大型商业软件、定制化绿色软件常安装于此（如 Oracle、自定义服务包） |

> 现代发行版说明：CentOS 7+、Ubuntu 16+ 已将 `/bin`、`/sbin`、`/lib` 软链接到 `/usr` 对应目录，统一了目录结构，但经典定义与使用习惯仍保留。

------

## 四、用户相关目录

| 目录        | 核心作用                                                     |                                                  |
| :---------- | :----------------------------------------------------------- | :----------------------------------------------- |
| `/home`     | 普通用户家目录总入口，每个用户对应一个子目录（如 `/home/zhangsan`），存放个人数据、配置 |                                                  |
| `/root`     | root 超级用户的专属家目录                                    | 不在 /home 下，单用户救援模式也可访问            |
| `/etc/skel` | 新用户默认配置模板目录                                       | 新建用户时，会自动把这里的文件复制到新用户家目录 |

------

## 五、设备与虚拟文件系统目录

均为内核映射生成，**不占用实际磁盘空间，数据存在于内存中**，重启后重置。

| 目录    | 核心作用                                         | 运维常用点                                                   |
| :------ | :----------------------------------------------- | :----------------------------------------------------------- |
| `/dev`  | 设备文件目录，所有硬件都以文件形式存在           | `/dev/sda` 第一块硬盘`/dev/null` 黑洞文件（丢弃所有写入）`/dev/zero` 零字符生成器 |
| `/proc` | 进程与内核状态虚拟文件系统，存放系统实时运行数据 | 排查故障核心目录：`/proc/cpuinfo` CPU 详情`/proc/meminfo` 内存详情`/proc/net/tcp` TCP 连接表`/proc/sys` 可临时修改内核参数 |
| `/sys`  | 硬件与内核参数虚拟文件系统                       | 比 /proc 更结构化，用于管理硬件设备、驱动、内核模块参数      |

------

## 六、可变数据目录（运维高频）

`/var` 存放运行中动态变化的数据，日志、运行时文件、持久化数据都在这里。



| 目录           | 核心作用                                                     |
| :------------- | :----------------------------------------------------------- |
| **`/var/log`** | 系统与服务日志总目录，故障排查第一入口核心日志：`/var/log/messages` 系统全局日志`/var/log/secure` 登录安全日志`/var/log/cron` 定时任务日志 |
| `/var/run`     | 进程运行时数据：PID 文件、socket 文件，系统重启后自动清空    |
| `/var/lib`     | 服务持久化数据：MySQL 数据文件、rpm 包数据库、系统状态数据   |
| `/var/spool`   | 队列类数据：邮件、打印任务、定时任务队列                     |
| `/var/tmp`     | 持久化临时文件，系统重启不会删除                             |

------

## 七、临时与挂载目录

| 目录          | 核心作用                                 |                                                 |
| :------------ | :--------------------------------------- | :---------------------------------------------- |
| `/tmp`        | 全局临时文件目录，所有用户可读写         | 系统会定期自动清理过期文件，禁止存放重要数据    |
| `/mnt`        | 手动临时挂载目录                         | 运维手动挂载 U 盘、移动硬盘、网络磁盘的默认入口 |
| `/media`      | 可移动设备自动挂载目录                   | U 盘、光盘插入后系统自动挂载到此                |
| `/lost+found` | 文件系统异常修复时，恢复的丢失文件存放处 | 每个独立分区的根目录下都有一个                  |

------

## 运维速记总结

1. **改配置找 `/etc`**
2. **查日志找 `/var/log`**
3. **装软件分三类：yum 装去 /usr，手动编译去 /usr/local，大型软件去 /opt**
4. **查系统状态看 `/proc`、查硬件看 `/sys`、看设备看 `/dev`**
5. **用户数据在 `/home`，管理员数据在 `/root`**







# python 伪代码 linux内核模块

## Linux 1.0 进程调度子系统

```python
# ====================== Linux 1.0 进程调度子系统 完整伪代码（Python版） ======================
# 对应内核源码 kernel/sched.c，采用「时间片轮转 + 动态优先级」的 O(n) 调度器
# 保留调度核心原理，简化内存、信号、文件等非调度逻辑，注释逐行讲解原理

# ====================== 1. 进程状态常量定义 ======================
# 对应 Linux 1.0 task_struct 结构体中的 state 字段，共 5 种核心状态
TASK_RUNNING = 0          # 就绪/运行态：具备调度资格，等待或正在使用CPU
TASK_INTERRUPTIBLE = 1    # 可中断睡眠：等待资源，收到信号可被唤醒
TASK_UNINTERRUPTIBLE = 2  # 不可中断睡眠：等待硬件IO，仅能被wake_up唤醒，不响应信号
TASK_ZOMBIE = 3           # 僵尸态：进程已执行结束，资源未被父进程回收
TASK_STOPPED = 4          # 停止态：被调试/暂停，如收到SIGSTOP信号

# ====================== 2. 进程控制块 PCB（task_struct） ======================
# 内核用该结构体完整描述一个进程，是进程管理的最小单位
class ProcessPCB:
    def __init__(self, pid, priority=20, nice=0):
        # 进程唯一标识ID
        self.pid = pid
        # 进程当前状态，新建进程默认进入就绪态
        self.state = TASK_RUNNING
        # 基础优先级：决定进程初始时间片大小，受nice值影响
        # nice 取值范围 -20~19，值越小优先级越高
        self.base_priority = priority + (20 - nice)
        # 剩余时间片 counter：调度核心字段，单位为时钟滴答
        # 每次时钟中断减1，减到0则让出CPU，触发重新调度
        self.counter = self.base_priority
        # 用户可调整的优先级参数，普通用户只能调大（降低优先级）
        self.nice = nice
        # 模拟进程上下文：真实内核中保存全部CPU寄存器、栈指针等
        self.context = f"进程{pid}的CPU寄存器上下文"

# ====================== 3. 进程调度器核心类 ======================
# 内核全局唯一调度器实例，负责所有进程的CPU资源分配与切换
class Scheduler:
    def __init__(self):
        # 全局进程列表：对应内核 task 数组，管理系统所有进程
        self.process_list = []
        # 当前正在CPU上运行的进程
        self.current_process = None
        # 系统全局时钟节拍计数，每10ms触发一次时钟中断，计数+1
        self.jiffies = 0

    # ====================== 3.1 创建新进程（模拟 fork 系统调用） ======================
    # 对应内核 sys_fork，创建子进程PCB并加入调度队列
    def fork_process(self, pid, priority=20, nice=0):
        # 初始化新进程控制块
        new_proc = ProcessPCB(pid, priority, nice)
        # 加入全局进程管理列表
        self.process_list.append(new_proc)
        print(f"[创建进程] PID={pid}, 基础优先级={new_proc.base_priority}, 初始时间片={new_proc.counter}")
        # 系统首次启动时，直接让第一个进程运行
        if self.current_process is None:
            self.current_process = new_proc
            print(f"[调度启动] 初始运行进程 PID={pid}")
        return new_proc

    # ====================== 3.2 时钟中断处理函数 ======================
    # 对应内核时钟中断处理程序，是调度器的驱动力
    # 硬件定时器每10ms触发一次，自动执行该函数
    def timer_interrupt(self):
        self.jiffies += 1
        # 无运行进程时直接触发调度
        if self.current_process is None:
            self.schedule()
            return

        # 当前运行进程的剩余时间片减1
        self.current_process.counter -= 1
        print(f"[时钟滴答] jiffies={self.jiffies}, 当前进程PID={self.current_process.pid}, 剩余时间片={self.current_process.counter}")

        # 时间片未用完，继续运行当前进程，不触发调度
        if self.current_process.counter > 0:
            return

        # 时间片耗尽，重置为0，触发调度让出CPU
        self.current_process.counter = 0
        print(f"[时间片耗尽] 进程PID={self.current_process.pid} 时间片用完，触发调度")
        self.schedule()

    # ====================== 3.3 调度主函数 schedule() 【核心逻辑】 ======================
    # Linux 1.0 最核心函数，所有进程切换最终都执行这里
    # 目标：从所有就绪进程中选出最优进程，完成CPU上下文切换
    def schedule(self):
        print("\n---------- 进入调度器 schedule() ----------")

        # 第一步：处理当前进程的状态收尾
        if self.current_process is not None:
            # 僵尸/停止态进程不再参与调度
            if self.current_process.state in (TASK_ZOMBIE, TASK_STOPPED):
                print(f"[进程收尾] PID={self.current_process.pid} 已退出/停止，移出调度候选")

            # 可中断睡眠态进程若收到信号，唤醒为就绪态
            if self.current_process.state == TASK_INTERRUPTIBLE:
                self.current_process.state = TASK_RUNNING
                print(f"[进程唤醒] PID={self.current_process.pid} 被信号唤醒，进入就绪态")

        # 第二步：遍历所有进程，选出剩余时间片最大的就绪进程
        max_counter = -1
        next_process = None

        # Linux 1.0 为 O(n) 调度器：遍历全部进程找最优解
        for proc in self.process_list:
            # 只筛选就绪态进程
            if proc.state != TASK_RUNNING:
                continue
            # 更新剩余时间片更大的候选进程
            if proc.counter > max_counter:
                max_counter = proc.counter
                next_process = proc

        # 第三步：所有就绪进程时间片耗尽，全局重算时间片
        # 这是 Linux 动态优先级调度的精髓，兼顾IO密集型与CPU密集型进程
        if next_process is None or max_counter == 0:
            print("[时间片重算] 所有就绪进程时间片耗尽，全局重新计算时间片")
            for proc in self.process_list:
                # 核心公式：counter = counter//2 + base_priority
                # 设计逻辑：
                # 1. IO密集型进程常睡眠，counter衰减少，重算后时间片更大，优先调度
                # 2. CPU密集型进程一直运行，counter每次耗尽，重算后为基础优先级
                # 3. 避免低优先级进程饥饿，保证所有进程都能获得CPU
                proc.counter = proc.counter // 2 + proc.base_priority
            # 重算完成后重新选择最优进程
            max_counter = -1
            for proc in self.process_list:
                if proc.state == TASK_RUNNING and proc.counter > max_counter:
                    max_counter = proc.counter
                    next_process = proc

        # 第四步：无就绪进程时，运行 idle 空闲进程
        # 真实内核中 idle 进程执行 hlt 指令，CPU进入低功耗空转
        if next_process is None:
            print("[空闲调度] 无就绪进程，运行 idle 空闲进程")
            self.current_process = None
            print("---------- 调度结束 ----------\n")
            return

        # 第五步：执行进程上下文切换
        # 真实内核在此保存旧进程寄存器，加载新进程寄存器
        if self.current_process != next_process:
            old_pid = self.current_process.pid if self.current_process else "空闲"
            print(f"[上下文切换] 从进程PID={old_pid} 切换到 PID={next_process.pid}")
            self.current_process = next_process

        print(f"[当前运行] 进程PID={self.current_process.pid}, 剩余时间片={self.current_process.counter}")
        print("---------- 调度结束 ----------\n")

    # ====================== 3.4 进程进入睡眠 ======================
    # 对应内核 sleep_on，进程等待IO、锁等资源时调用
    def process_sleep(self, pid, interruptible=True):
        target = self._find_process(pid)
        if not target or target.state != TASK_RUNNING:
            return

        # 设置为对应睡眠状态
        target.state = TASK_INTERRUPTIBLE if interruptible else TASK_UNINTERRUPTIBLE
        sleep_type = "可中断" if interruptible else "不可中断"
        print(f"[进程睡眠] PID={pid} 进入{sleep_type}睡眠态")

        # 若睡眠的是当前运行进程，立即触发调度让出CPU
        if target == self.current_process:
            self.schedule()

    # ====================== 3.5 唤醒睡眠进程 ======================
    # 对应内核 wake_up，IO完成、资源可用时调用
    def wake_up_process(self, pid):
        target = self._find_process(pid)
        if not target or target.state == TASK_RUNNING:
            return

        # 改回就绪态，重新参与调度
        target.state = TASK_RUNNING
        print(f"[唤醒进程] PID={pid} 被唤醒，进入就绪态等待调度")

    # ====================== 辅助方法：查找指定PID进程 ======================
    def _find_process(self, pid):
        for proc in self.process_list:
            if proc.pid == pid:
                return proc
        return None

# ====================== 4. 测试示例：模拟完整调度流程 ======================
if __name__ == "__main__":
    # 初始化全局调度器
    sched = Scheduler()

    # 创建3个不同优先级的测试进程
    print("===== 初始化进程 =====")
    p1 = sched.fork_process(pid=1, nice=0)    # 普通优先级
    p2 = sched.fork_process(pid=2, nice=-5)   # 高优先级（nice越小优先级越高）
    p3 = sched.fork_process(pid=3, nice=10)   # 低优先级

    # 模拟20次时钟中断，观察进程轮转调度
    print("\n===== 模拟时钟中断，触发调度 =====")
    for i in range(20):
        sched.timer_interrupt()

    # 模拟进程2进入睡眠，再唤醒的场景
    print("\n===== 模拟进程睡眠与唤醒 =====")
    sched.process_sleep(pid=2, interruptible=True)
    # 继续运行5个时钟滴答，观察进程2不再参与调度
    for i in range(5):
        sched.timer_interrupt()
    # 唤醒进程2
    sched.wake_up_process(pid=2)
    # 再运行5个时钟滴答，观察进程2重新被调度
    for i in range(5):
        sched.timer_interrupt()
```



## Linux 1.0 内存管理子系统

```python
# ====================== Linux 1.0 内存管理子系统 完整伪代码（Python版） ======================
# 对应内核源码 mm/ 目录核心逻辑，核心机制：伙伴系统物理内存管理 + 页式虚拟内存 + 请求调页 + Swap交换
# 简化地址空间分段、权限校验等细节，保留内存管理核心原理，注释逐行讲解设计思想

# ====================== 1. 内存核心常量定义 ======================
PAGE_SIZE = 4096        # 内存页大小，标准4KB，内存管理的最小分配单位
MAX_ORDER = 5           # 伙伴系统最大阶数，最大连续块为 2^MAX_ORDER 页 = 128KB
# 物理页状态常量
PAGE_FREE = 0           # 空闲可用状态
PAGE_USED = 1           # 已分配使用状态
PAGE_DIRTY = 2          # 脏页：内存数据被修改，换出时必须写回磁盘/Swap
PAGE_SWAPPED = 3        # 已换出：数据已存入Swap区，物理页已被回收

# ====================== 2. 物理页描述符（struct page） ======================
# 内核用该结构体描述每一个物理内存页，是物理内存管理的最小单元
class PhysicalPage:
    def __init__(self, pfn):
        self.pfn = pfn              # 物理页帧号（Physical Frame Number），物理页唯一标识
        self.state = PAGE_FREE      # 页当前状态
        self.order = 0              # 所属伙伴块的阶数，2^order 个页组成一个连续块
        self.is_head = False        # 是否是连续块的首页（块头）
        self.content = f"物理页{pfn}的原始数据"  # 模拟页中存储的业务数据

# ====================== 3. 伙伴系统（Buddy System） ======================
# Linux物理内存管理核心算法，解决「外部碎片」问题，管理连续物理页的分配与释放
# 核心思想：将空闲物理页按2^n大小分组，分配时拆分大块，释放时合并相邻伙伴块
class BuddySystem:
    def __init__(self, total_pages):
        self.total_pages = total_pages  # 系统总物理页数
        # 初始化所有物理页对象
        self.pages = [PhysicalPage(i) for i in range(total_pages)]
        # 空闲块链表数组：下标对应阶数，存储对应大小空闲块的起始页号
        self.free_lists = [[] for _ in range(MAX_ORDER + 1)]
        
        # 系统启动初始化：将所有内存整合成最大阶空闲块，加入空闲链表
        start_pfn = 0
        while start_pfn + (1 << MAX_ORDER) <= total_pages:
            self._set_block_state(start_pfn, MAX_ORDER, PAGE_FREE)
            self.free_lists[MAX_ORDER].append(start_pfn)
            start_pfn += (1 << MAX_ORDER)
        print(f"[伙伴系统初始化] 总物理页：{total_pages}，最大阶数：{MAX_ORDER}")

    # 辅助方法：批量设置连续块的阶数、状态、块头标记
    def _set_block_state(self, start_pfn, order, state):
        page_count = 1 << order
        for i in range(page_count):
            self.pages[start_pfn + i].order = order
            self.pages[start_pfn + i].state = state
            self.pages[start_pfn + i].is_head = (i == 0)

    # ====================== 核心：分配连续物理页 ======================
    # 分配 2^order 个连续物理页，返回块首页的页帧号；内存不足返回None
    def alloc_pages(self, order):
        if order > MAX_ORDER:
            print("[分配失败] 请求阶数超过系统最大限制")
            return None
        
        # 从目标阶开始，向上寻找有空闲块的阶
        current_order = order
        while current_order <= MAX_ORDER:
            if len(self.free_lists[current_order]) > 0:
                break
            current_order += 1
        
        # 所有阶都无空闲块，物理内存耗尽
        if current_order > MAX_ORDER:
            print("[分配失败] 物理内存不足，无可用连续页块")
            return None
        
        # 取出找到的高阶空闲块
        block_start = self.free_lists[current_order].pop(0)
        print(f"[伙伴分配] 从{current_order}阶空闲块拆分，起始页帧号：{block_start}")

        # 循环拆分大块：每次拆成两半，一半使用，另一半加入低阶空闲链表
        while current_order > order:
            current_order -= 1
            # 计算拆分后另一半伙伴块的起始页号
            buddy_start = block_start + (1 << current_order)
            # 另一半标记为空闲，加入对应阶的空闲链表
            self._set_block_state(buddy_start, current_order, PAGE_FREE)
            self.free_lists[current_order].append(buddy_start)
            print(f"  拆分出{current_order}阶伙伴块，起始页：{buddy_start}，加入空闲链表")
        
        # 标记最终分配的块为已使用
        self._set_block_state(block_start, order, PAGE_USED)
        page_count = 1 << order
        print(f"[分配完成] 分配{order}阶连续页，共{page_count}页，起始页帧号：{block_start}")
        return block_start

    # ====================== 核心：释放连续物理页 ======================
    # 释放起始页为start_pfn、大小为2^order的连续块，自动向上合并伙伴块
    def free_pages(self, start_pfn, order):
        # 先标记当前块为空闲
        self._set_block_state(start_pfn, order, PAGE_FREE)
        current_pfn = start_pfn
        current_order = order

        # 循环合并伙伴，直到无法合并或达到最大阶
        while current_order < MAX_ORDER:
            # 伙伴块计算：异或运算得到相邻的同大小伙伴块起始页号
            buddy_pfn = current_pfn ^ (1 << current_order)
            
            # 边界校验 + 伙伴块状态校验：必须空闲、同阶、是块头才能合并
            if buddy_pfn >= self.total_pages:
                break
            buddy_page = self.pages[buddy_pfn]
            if buddy_page.state != PAGE_FREE or buddy_page.order != current_order or not buddy_page.is_head:
                break
            
            # 满足合并条件：从空闲链表移除伙伴块
            self.free_lists[current_order].remove(buddy_pfn)
            print(f"[伙伴合并] 合并{current_order}阶块：{current_pfn} + {buddy_pfn}")
            
            # 合并后的块起始页为编号更小的那个
            current_pfn = min(current_pfn, buddy_pfn)
            current_order += 1
            self._set_block_state(current_pfn, current_order, PAGE_FREE)
        
        # 最终合并完成的块加入对应阶的空闲链表
        self.free_lists[current_order].append(current_pfn)
        print(f"[释放完成] 起始页{start_pfn}已释放，最终合并为{current_order}阶空闲块")

# ====================== 4. 内存管理子系统总类 ======================
# 整合物理内存管理、虚拟地址映射、缺页异常、Swap交换，对应内核完整mm子系统
class MemoryManager:
    def __init__(self, total_physical_pages):
        self.buddy = BuddySystem(total_physical_pages)
        self.swap_space = {}  # 模拟Swap交换区，key=交换槽位号，value=页数据
        self.swap_slot_id = 0 # Swap槽位自增ID
        # 进程独立页表：每个进程有自己的虚拟地址空间，页表独立
        # 真实内核中，页表指针存在进程task_struct的mm字段中
        self.process_page_tables = {}

    # 为新进程创建独立页表（虚拟地址空间）
    def create_process_mm(self, pid):
        # 页表结构：虚拟页号(VPN) -> 物理页帧号(PFN) / Swap槽位号
        self.process_page_tables[pid] = {}
        print(f"[页表创建] 进程{pid}的独立页表已初始化")

    # ====================== 虚拟地址转物理地址 ======================
    # 进程访问内存的统一入口，未映射则触发缺页异常
    def virt_to_phys(self, pid, virt_addr):
        # 拆分虚拟地址：虚拟页号 + 页内偏移
        vpn = virt_addr // PAGE_SIZE  # 虚拟页号（Virtual Page Number）
        offset = virt_addr % PAGE_SIZE # 页内偏移，页内地址不变

        page_table = self.process_page_tables.get(pid)
        if not page_table:
            print("[地址转换失败] 进程不存在，无对应页表")
            return None

        # 情况1：虚拟页已映射物理内存
        if vpn in page_table:
            entry = page_table[vpn]
            if entry >= 0:
                pfn = entry
                phys_addr = pfn * PAGE_SIZE + offset
                print(f"[地址转换] 虚拟地址0x{virt_addr:x} -> 物理地址0x{phys_addr:x}")
                return phys_addr
            # 情况2：虚拟页已换出到Swap，触发换入缺页
            else:
                print(f"[缺页异常] 虚拟页{vpn}已换出到Swap，触发页换入")
                pfn = self._swap_in_page(pid, vpn)
                if pfn:
                    return pfn * PAGE_SIZE + offset
                return None
        # 情况3：虚拟页从未映射，触发请求调页缺页
        else:
            print(f"[缺页异常] 进程{pid}访问虚拟地址0x{virt_addr:x}，虚拟页{vpn}未映射")
            return self._handle_page_fault(pid, vpn, offset)

    # ====================== 缺页异常处理（请求调页） ======================
    # Linux内存管理核心思想：用时才分配物理页，不预分配，节省内存
    def _handle_page_fault(self, pid, vpn, offset):
        # 第一步：尝试分配1个物理页
        pfn = self.buddy.alloc_pages(order=0)
        
        # 第二步：物理内存不足，先换出一页腾出空间
        if pfn is None:
            print("[内存不足] 启动页回收机制，换出一页到Swap")
            swap_success = self._swap_out_one_page(pid)
            if not swap_success:
                print("[OOM] 内存彻底耗尽，触发OOM Killer杀死进程")
                return None
            pfn = self.buddy.alloc_pages(order=0)

        # 第三步：建立虚拟页到物理页的映射，写入页表
        self.process_page_tables[pid][vpn] = pfn
        phys_addr = pfn * PAGE_SIZE + offset
        print(f"[缺页处理完成] 虚拟页{vpn} 映射到 物理页{pfn}")
        return phys_addr

    # ====================== 页换出（Swap Out） ======================
    # 内存不足时，选一页将数据写入交换区，释放物理内存
    # 真实内核用LRU算法选择最近最少使用的页，这里简化选第一个映射页
    def _swap_out_one_page(self, pid):
        page_table = self.process_page_tables[pid]
        for vpn, pfn in list(page_table.items()):
            if pfn < 0:  # 已经在Swap里的跳过
                continue
            
            # 1. 如果是脏页，将数据写入Swap交换区
            page = self.buddy.pages[pfn]
            self.swap_space[self.swap_slot_id] = page.content
            # 2. 页表项更新为负数，标记为已换出，记录Swap槽位
            page_table[vpn] = -self.swap_slot_id - 1
            self.swap_slot_id += 1
            # 3. 释放物理页，归还伙伴系统
            self.buddy.free_pages(pfn, order=0)
            print(f"[页换出] 虚拟页{vpn}（物理页{pfn}）已换出到Swap槽位{self.swap_slot_id-1}")
            return True
        return False

    # ====================== 页换入（Swap In） ======================
    # 访问已换出的页时，从Swap读回物理内存，重新建立映射
    def _swap_in_page(self, pid, vpn):
        page_table = self.process_page_tables[pid]
        # 从页表项解析出Swap槽位号
        swap_slot = -page_table[vpn] - 1
        
        # 分配新的物理页
        pfn = self.buddy.alloc_pages(order=0)
        if pfn is None:
            return None
        
        # 从Swap交换区读回数据
        self.buddy.pages[pfn].content = self.swap_space[swap_slot]
        # 更新页表，恢复正常物理页映射
        page_table[vpn] = pfn
        print(f"[页换入] 虚拟页{vpn} 从Swap槽位{swap_slot} 读回物理页{pfn}")
        return pfn

# ====================== 5. 测试示例：模拟内存管理完整流程 ======================
if __name__ == "__main__":
    # 初始化：总物理页16页 = 16 * 4KB = 64KB 物理内存
    print("===== 内存管理子系统启动 =====")
    mm = MemoryManager(total_physical_pages=16)

    # 为进程1创建独立虚拟地址空间
    mm.create_process_mm(pid=1)

    print("\n===== 测试1：访问虚拟内存，触发请求调页 =====")
    # 访问虚拟地址 0x0（第0个虚拟页）
    phys_addr1 = mm.virt_to_phys(pid=1, virt_addr=0x0)
    # 访问虚拟地址 0x2000（第2个虚拟页，0x2000 = 8192 = 2*4096）
    phys_addr2 = mm.virt_to_phys(pid=1, virt_addr=0x2000)

    print("\n===== 测试2：伙伴系统分配连续大页 =====")
    # 分配2阶连续页（4页 = 16KB）
    big_block_pfn = mm.buddy.alloc_pages(order=2)

    print("\n===== 测试3：释放单页，触发伙伴合并 =====")
    # 依次释放两个相邻的单页，观察合并过程
    mm.buddy.free_pages(start_pfn=0, order=0)
    mm.buddy.free_pages(start_pfn=1, order=0)

    print("\n===== 测试4：内存耗尽，触发Swap换出 =====")
    # 循环分配，占满所有物理内存，触发页换出
    for i in range(12):
        virt_addr = 0x3000 + i * PAGE_SIZE
        mm.virt_to_phys(pid=1, virt_addr=virt_addr)

    print("\n===== 测试5：访问已换出的页，触发Swap换入 =====")
    # 访问最早分配的虚拟页，已被换出，触发换入
    mm.virt_to_phys(pid=1, virt_addr=0x0)
```



## Linux 1.0 文件系统与IO子系统



```bash
# ====================== Linux 1.0 文件系统与IO子系统 完整伪代码（Python版） ======================
# 对应内核源码 fs/ 目录核心逻辑，IO栈分层：块设备驱动 → Buffer Cache块缓存 → IO调度器 → Ext2文件系统 → VFS虚拟文件系统
# 说明：Linux 1.0 时代以 Buffer Cache 为核心块级缓存（尚未引入Page Cache），VFS已完成抽象，Ext2为主流文件系统
# 简化权限、日志、间接块等细节，保留IO核心流程与设计思想，注释逐行讲解底层原理

# ====================== 1. 核心常量定义 ======================
BLOCK_SIZE = 4096        # 磁盘块大小，标准4KB，文件系统最小IO单位，与内存页对齐
MAX_BUFFER_NUM = 32      # Buffer Cache 总缓存块数量，模拟内存缓存上限

# 文件类型
FILE_REGULAR = 1         # 普通文件
FILE_DIR = 2             # 目录文件

# IO操作类型
IO_READ = 0
IO_WRITE = 1

# 缓冲区状态标记
BUF_CLEAN = 0            # 干净块：内存数据与磁盘完全一致
BUF_DIRTY = 1            # 脏块：内存已修改，未同步到磁盘
BUF_LOCKED = 2           # 锁定块：正在进行磁盘IO，禁止读写

# ====================== 2. 最底层：块设备驱动层 ======================
# 对应内核 drivers/block/ 目录，直接操作物理磁盘，向上提供「按块号读写」的统一接口
# 屏蔽不同硬盘（IDE/SCSI）的硬件差异，是整个IO栈的最底层
class BlockDevice:
    def __init__(self, total_blocks):
        self.total_blocks = total_blocks
        # 用列表模拟磁盘物理块，下标对应块号，存储块数据
        self.disk_blocks = [b"\x00" * BLOCK_SIZE for _ in range(total_blocks)]
        print(f"[块设备初始化] 磁盘总块数：{total_blocks}，单块大小：{BLOCK_SIZE}B，总容量：{total_blocks*BLOCK_SIZE//1024}KB")

    # 读磁盘块：从物理磁盘读取指定块号的数据
    def read_block(self, block_no):
        if block_no < 0 or block_no >= self.total_blocks:
            raise ValueError(f"块号{block_no}越界")
        print(f"[磁盘IO-读] 读取物理块号：{block_no}")
        return self.disk_blocks[block_no]

    # 写磁盘块：将数据写入物理磁盘指定块号
    def write_block(self, block_no, data):
        if block_no < 0 or block_no >= self.total_blocks:
            raise ValueError(f"块号{block_no}越界")
        # 数据对齐到块大小，不足补零
        data = data[:BLOCK_SIZE].ljust(BLOCK_SIZE, b"\x00")
        self.disk_blocks[block_no] = data
        print(f"[磁盘IO-写] 写入物理块号：{block_no}")

# ====================== 3. Buffer Cache 块缓存层 ======================
# 对应内核 fs/buffer.c，Linux 1.0 核心性能优化机制，用内存缓存磁盘块，减少慢速磁盘IO
# 每个缓存块由 buffer_head 描述符管理，通过哈希表快速查找，支持脏页异步刷盘
class BufferHead:
    """缓冲区描述符，对应内核 struct buffer_head，描述一个缓存的磁盘块"""
    def __init__(self, block_no):
        self.block_no = block_no  # 对应磁盘块号
        self.data = b""           # 缓存的块数据
        self.state = BUF_CLEAN    # 块状态：干净/脏/锁定
        self.count = 0            # 引用计数，被占用时计数+1

class BufferCache:
    def __init__(self, block_device):
        self.dev = block_device
        # 哈希表：块号 -> BufferHead，实现O(1)查找缓存块
        self.cache_map = {}
        # 空闲缓存块池
        self.free_buffers = [BufferHead(i) for i in range(MAX_BUFFER_NUM)]
        print(f"[Buffer Cache初始化] 总缓存块数：{MAX_BUFFER_NUM}，总缓存大小：{MAX_BUFFER_NUM*BLOCK_SIZE//1024}KB")

    # ====================== 核心：获取指定块 ======================
    # 先查缓存，命中直接返回；未命中则分配缓存块，从磁盘读入数据
    def getblk(self, block_no):
        # 1. 哈希查找：缓存命中，直接返回
        if block_no in self.cache_map:
            bh = self.cache_map[block_no]
            bh.count += 1
            print(f"[缓存命中] 块号{block_no}命中Buffer Cache")
            return bh

        # 2. 缓存未命中：从空闲链表取一个空闲缓存块
        if not self.free_buffers:
            # 无空闲块：淘汰一个引用计数为0的块（简化LRU，这里直接随机淘汰）
            for bh in self.cache_map.values():
                if bh.count == 0:
                    # 如果是脏块，先刷回磁盘再淘汰
                    if bh.state == BUF_DIRTY:
                        self._flush_block(bh)
                    del self.cache_map[bh.block_no]
                    self.free_buffers.append(bh)
                    break

        if not self.free_buffers:
            print("[缓存错误] 无可用缓存块，全部被占用")
            return None

        # 3. 分配新缓存块，从磁盘读取数据载入缓存
        new_bh = self.free_buffers.pop()
        new_bh.block_no = block_no
        new_bh.data = self.dev.read_block(block_no)
        new_bh.state = BUF_CLEAN
        new_bh.count = 1
        self.cache_map[block_no] = new_bh
        print(f"[缓存载入] 块号{block_no}从磁盘载入缓存")
        return new_bh

    # ====================== 标记脏块 ======================
    # 修改了缓存数据后调用，标记为脏，后续异步刷盘
    def mark_dirty(self, bh):
        if bh.state != BUF_LOCKED:
            bh.state = BUF_DIRTY
            print(f"[脏块标记] 块号{bh.block_no}标记为脏，待同步磁盘")

    # ====================== 单个块刷盘 ======================
    def _flush_block(self, bh):
        if bh.state == BUF_DIRTY:
            self.dev.write_block(bh.block_no, bh.data)
            bh.state = BUF_CLEAN
            print(f"[刷盘完成] 脏块{bh.block_no}已同步到磁盘")

    # ====================== 全局同步：所有脏块刷盘 ======================
    # 对应系统调用 sync()，将所有缓存脏数据写回磁盘，保证数据一致性
    def sync_all(self):
        print("\n---------- 启动全局缓存同步 ----------")
        for bh in self.cache_map.values():
            if bh.state == BUF_DIRTY:
                self._flush_block(bh)
        print("---------- 缓存同步完成 ----------\n")

    # 释放缓存块引用
    def release_block(self, bh):
        bh.count -= 1

# ====================== 4. IO调度器层 ======================
# 对应内核 elevator 电梯算法，Linux 1.0 标准IO调度器
# 作用：合并、排序IO请求，减少机械磁盘寻道时间，提升批量IO性能
class IORequest:
    """IO请求描述符，对应内核 struct request"""
    def __init__(self, block_no, op_type, data=None):
        self.block_no = block_no    # 操作的块号
        self.op_type = op_type      # 读/写
        self.data = data            # 写操作的数据
        self.completed = False      # 是否完成

class IOScheduler:
    def __init__(self, block_device):
        self.dev = block_device
        # 请求队列：按块号升序排列，模拟电梯单向扫描
        self.request_queue = []

    # 加入IO请求，按块号插入队列，实现电梯排序
    def add_request(self, req):
        # 简单插入排序，按块号升序
        inserted = False
        for i in range(len(self.request_queue)):
            if self.request_queue[i].block_no > req.block_no:
                self.request_queue.insert(i, req)
                inserted = True
                break
        if not inserted:
            self.request_queue.append(req)
        print(f"[IO调度] 请求加入队列，块号{req.block_no}，类型{'读' if req.op_type==IO_READ else '写'}")

    # 派发执行队列中所有IO请求
    def dispatch_all(self):
        if not self.request_queue:
            return []
        print(f"\n[IO调度派发] 队列共{len(self.request_queue)}个请求，按块号顺序执行")
        results = []
        for req in self.request_queue:
            if req.op_type == IO_READ:
                data = self.dev.read_block(req.block_no)
                results.append(data)
            else:
                self.dev.write_block(req.block_no, req.data)
                results.append(None)
            req.completed = True
        # 清空已完成队列
        self.request_queue.clear()
        return results

# ====================== 5. Ext2 文件系统层 ======================
# 对应内核 fs/ext2/ 目录，Linux 1.0 主流文件系统，基于inode管理，支持目录、文件元数据
# 简化版：仅实现直接块指针、位图管理、目录项查找，保留Ext2核心设计思想
class Inode:
    """inode 结构体，对应内核 struct ext2_inode，每个文件/目录对应唯一inode"""
    def __init__(self, inode_no, file_type):
        self.inode_no = inode_no    # inode编号，全局唯一
        self.file_type = file_type  # 文件类型：普通文件/目录
        self.size = 0               # 文件大小，单位字节
        self.direct_blocks = [-1]*10 # 10个直接块指针，存储数据块号，小文件足够用
        self.link_count = 1         # 硬链接计数

class DirEntry:
    """目录项，目录文件的内容就是若干目录项，存储 文件名->inode号 映射"""
    def __init__(self, filename, inode_no):
        self.filename = filename
        self.inode_no = inode_no

class Ext2FileSystem:
    def __init__(self, buffer_cache, total_blocks):
        self.buf_cache = buffer_cache
        self.total_blocks = total_blocks
        # ========== 超级块：文件系统元数据 ==========
        self.super_block = {
            "total_blocks": total_blocks,
            "total_inodes": total_blocks // 4,  # 平均每4个数据块配1个inode
            "block_bitmap_block": 1,            # 块位图所在块号
            "inode_bitmap_block": 2,            # inode位图所在块号
            "inode_table_start": 3,             # inode表起始块号
            "data_start_block": 20,             # 数据区起始块号
            "root_inode_no": 0                  # 根目录inode号
        }
        # 初始化位图、inode表、根目录
        self._init_filesystem()
        print("[Ext2文件系统] 格式化完成，根目录已创建")

    # 初始化文件系统结构（格式化）
    def _init_filesystem(self):
        # 初始化块位图：0=空闲，1=已占用
        self.block_bitmap = [0] * self.total_blocks
        # 前20个块为元数据区，标记为已占用
        for i in range(self.super_block["data_start_block"]):
            self.block_bitmap[i] = 1

        # 初始化inode位图
        total_inodes = self.super_block["total_inodes"]
        self.inode_bitmap = [0] * total_inodes
        # 0号inode分配给根目录
        self.inode_bitmap[0] = 1

        # 初始化inode表
        self.inode_table = [None] * total_inodes
        # 创建根目录inode
        root_inode = Inode(0, FILE_DIR)
        # 根目录分配一个数据块
        root_block = self._alloc_block()
        root_inode.direct_blocks[0] = root_block
        root_inode.size = BLOCK_SIZE
        self.inode_table[0] = root_inode
        # 根目录初始为空目录
        self._write_dir_entries(root_inode, [])

    # 分配一个空闲数据块，返回块号
    def _alloc_block(self):
        for i in range(self.super_block["data_start_block"], self.total_blocks):
            if self.block_bitmap[i] == 0:
                self.block_bitmap[i] = 1
                return i
        raise Exception("磁盘数据块耗尽")

    # 分配一个空闲inode，返回inode号
    def _alloc_inode(self):
        for i in range(len(self.inode_bitmap)):
            if self.inode_bitmap[i] == 0:
                self.inode_bitmap[i] = 1
                return i
        raise Exception("inode数量耗尽")

    # 读取目录的所有目录项
    def _read_dir_entries(self, dir_inode):
        block_no = dir_inode.direct_blocks[0]
        bh = self.buf_cache.getblk(block_no)
        # 解析目录项数据，简化处理
        entries = []
        data = bh.data.rstrip(b"\x00")
        if data:
            items = data.decode().split(";")
            for item in items:
                if item:
                    name, ino = item.split(":")
                    entries.append(DirEntry(name, int(ino)))
        self.buf_cache.release_block(bh)
        return entries

    # 写入目录项到目录文件
    def _write_dir_entries(self, dir_inode, entries):
        block_no = dir_inode.direct_blocks[0]
        bh = self.buf_cache.getblk(block_no)
        data_str = ";".join([f"{e.filename}:{e.inode_no}" for e in entries])
        bh.data = data_str.encode().ljust(BLOCK_SIZE, b"\x00")
        self.buf_cache.mark_dirty(bh)
        self.buf_cache.release_block(bh)

    # ====================== 目录查找：按文件名找inode号 ======================
    def lookup(self, dir_inode, filename):
        entries = self._read_dir_entries(dir_inode)
        for entry in entries:
            if entry.filename == filename:
                print(f"[目录查找] 找到文件：{filename}，inode号：{entry.inode_no}")
                return entry.inode_no
        print(f"[目录查找] 未找到文件：{filename}")
        return -1

    # ====================== 创建文件 ======================
    def create_file(self, dir_inode, filename, file_type=FILE_REGULAR):
        # 先检查是否已存在
        if self.lookup(dir_inode, filename) != -1:
            print(f"[创建失败] 文件{filename}已存在")
            return None
        # 分配新inode
        inode_no = self._alloc_inode()
        new_inode = Inode(inode_no, file_type)
        self.inode_table[inode_no] = new_inode
        # 添加目录项到父目录
        entries = self._read_dir_entries(dir_inode)
        entries.append(DirEntry(filename, inode_no))
        self._write_dir_entries(dir_inode, entries)
        print(f"[文件创建] {filename} 创建成功，inode号：{inode_no}")
        return new_inode

    # ====================== 读文件数据 ======================
    def read_file(self, inode, offset, length):
        if offset >= inode.size:
            return b""
        # 计算起始块号、块内偏移
        start_block_idx = offset // BLOCK_SIZE
        block_offset = offset % BLOCK_SIZE
        result = b""
        bytes_left = min(length, inode.size - offset)

        while bytes_left > 0 and start_block_idx < 10:
            block_no = inode.direct_blocks[start_block_idx]
            if block_no == -1:
                break
            # 从Buffer Cache读取块
            bh = self.buf_cache.getblk(block_no)
            # 截取需要的数据
            read_len = min(bytes_left, BLOCK_SIZE - block_offset)
            result += bh.data[block_offset : block_offset + read_len]
            self.buf_cache.release_block(bh)

            bytes_left -= read_len
            start_block_idx += 1
            block_offset = 0

        print(f"[文件读] 读取{len(result)}字节数据")
        return result

    # ====================== 写文件数据 ======================
    def write_file(self, inode, offset, data):
        data_len = len(data)
        start_block_idx = offset // BLOCK_SIZE
        block_offset = offset % BLOCK_SIZE
        bytes_left = data_len
        data_pos = 0

        while bytes_left > 0 and start_block_idx < 10:
            # 块未分配则先分配
            if inode.direct_blocks[start_block_idx] == -1:
                new_block = self._alloc_block()
                inode.direct_blocks[start_block_idx] = new_block
                print(f"[文件写] 分配新数据块：{new_block}")

            block_no = inode.direct_blocks[start_block_idx]
            bh = self.buf_cache.getblk(block_no)

            # 写入数据到缓存
            write_len = min(bytes_left, BLOCK_SIZE - block_offset)
            # 块内数据拼接，保留块内其他数据
            block_data = bytearray(bh.data)
            block_data[block_offset : block_offset + write_len] = data[data_pos : data_pos + write_len]
            bh.data = bytes(block_data)
            self.buf_cache.mark_dirty(bh)
            self.buf_cache.release_block(bh)

            bytes_left -= write_len
            data_pos += write_len
            start_block_idx += 1
            block_offset = 0

        # 更新文件大小
        if offset + data_len > inode.size:
            inode.size = offset + data_len

        print(f"[文件写] 写入{data_len}字节数据，文件当前大小：{inode.size}字节")

# ====================== 6. VFS 虚拟文件系统层 ======================
# 对应内核 VFS 抽象层，屏蔽底层不同文件系统差异，向上提供统一的系统调用接口
# 是Linux支持多文件系统共存的核心设计，所有用户态文件操作最终都通过VFS分发
class VirtualFileSystem:
    def __init__(self, fs):
        self.mounted_fs = fs  # 挂载的根文件系统
        self.fd_table = {}    # 文件描述符表，每个进程独立
        self.next_fd = 0      # 下一个可用文件描述符

    # 打开文件，返回文件描述符
    def open(self, filepath):
        # 简化路径解析，仅支持根目录下的文件
        if filepath.startswith("/"):
            filename = filepath[1:]
        else:
            filename = filepath

        root_inode = self.mounted_fs.inode_table[0]
        inode_no = self.mounted_fs.lookup(root_inode, filename)
        if inode_no == -1:
            print(f"[VFS open] 文件不存在：{filepath}")
            return -1

        inode = self.mounted_fs.inode_table[inode_no]
        fd = self.next_fd
        self.next_fd += 1
        self.fd_table[fd] = {
            "inode": inode,
            "pos": 0  # 文件读写偏移指针
        }
        print(f"[VFS open] 文件{filepath}打开成功，文件描述符：{fd}")
        return fd

    # 读文件
    def read(self, fd, length):
        if fd not in self.fd_table:
            return b""
        file_info = self.fd_table[fd]
        data = self.mounted_fs.read_file(file_info["inode"], file_info["pos"], length)
        file_info["pos"] += len(data)
        return data

    # 写文件
    def write(self, fd, data):
        if fd not in self.fd_table:
            return -1
        file_info = self.fd_table[fd]
        self.mounted_fs.write_file(file_info["inode"], file_info["pos"], data)
        file_info["pos"] += len(data)
        return len(data)

    # 同步所有缓存到磁盘
    def sync(self):
        print("[VFS sync] 发起全局磁盘同步")
        self.mounted_fs.buf_cache.sync_all()

# ====================== 7. 测试示例：完整IO流程模拟 ======================
if __name__ == "__main__":
    print("===== 文件系统与IO子系统启动 =====")
    # 1. 初始化最底层块设备：128块 = 512KB 磁盘
    disk = BlockDevice(total_blocks=128)

    # 2. 初始化Buffer Cache缓存层
    buffer_cache = BufferCache(disk)

    # 3. 初始化IO调度器
    io_sched = IOScheduler(disk)

    # 4. 格式化并挂载Ext2文件系统
    ext2_fs = Ext2FileSystem(buffer_cache, total_blocks=128)

    # 5. 初始化VFS虚拟文件系统
    vfs = VirtualFileSystem(ext2_fs)

    print("\n===== 测试1：创建文件并写入数据 =====")
    # 创建测试文件
    root_inode = ext2_fs.inode_table[0]
    test_inode = ext2_fs.create_file(root_inode, "test.txt", FILE_REGULAR)

    # 打开文件并写入数据
    fd = vfs.open("/test.txt")
    vfs.write(fd, b"Hello Linux IO System! This is Ext2 filesystem test.")

    print("\n===== 测试2：读取文件，观察缓存命中 =====")
    # 重置偏移，重新读取
    vfs.fd_table[fd]["pos"] = 0
    data = vfs.read(fd, 100)
    print("读取到的数据：", data.decode())

    # 第二次读取，完全命中缓存，无磁盘IO
    print("\n第二次读取（缓存命中）：")
    vfs.fd_table[fd]["pos"] = 0
    data2 = vfs.read(fd, 100)

    print("\n===== 测试3：同步缓存到磁盘 =====")
    vfs.sync()
```



## Linux 1.0 网络协议栈子系统

```python
# ====================== Linux 1.0 网络协议栈子系统 完整伪代码（Python版） ======================
# 对应内核源码 net/ 目录核心逻辑，分层设计：网卡驱动 → 链路层 → IP层 → TCP/UDP传输层 → Socket接口层
# 核心机制：硬中断收包 + 软中断协议栈处理 + sk_buff 套接字缓冲区 + TCP状态机 + 滑动窗口
# 说明：贴合Linux 1.0原生实现（无NAPI、原生BSD套接字接口），简化校验和、分片、路由表细节，保留核心原理

# ====================== 1. 核心常量定义 ======================
# 以太网帧类型
ETH_TYPE_IP = 0x0800    # IP协议
ETH_TYPE_ARP = 0x0806   # ARP协议

# IP层协议号
IP_PROTO_TCP = 6        # TCP协议
IP_PROTO_UDP = 17       # UDP协议

# TCP连接状态（TCP状态机核心，对应内核tcp.h）
TCP_CLOSED = 0          # 关闭状态
TCP_LISTEN = 1          # 监听状态（服务端）
TCP_SYN_SENT = 2        # 已发SYN（客户端）
TCP_SYN_RCVD = 3        # 已收SYN（服务端）
TCP_ESTABLISHED = 4     # 连接建立，可正常收发数据
TCP_FIN_WAIT1 = 5       # 已发FIN，等待对方ACK
TCP_FIN_WAIT2 = 6       # 收到FIN的ACK，等待对方FIN
TCP_TIME_WAIT = 7       # 等待2MSL，确保对方收到最后一个ACK
TCP_CLOSE_WAIT = 8      # 收到FIN，等待本地应用关闭
TCP_LAST_ACK = 9        # 已发FIN+ACK，等待对方最后一个ACK

# 网络接口默认配置
DEFAULT_MTU = 1500      # 最大传输单元
DEFAULT_WINDOW = 4096   # TCP滑动窗口大小

# ====================== 2. 核心数据结构：sk_buff 套接字缓冲区 ======================
# Linux网络栈的核心载体，所有数据包在各层之间传递都用sk_buff，对应内核struct sk_buff
# 每层处理时，只需要移动数据指针，不需要拷贝数据，提升性能
class SkBuff:
    def __init__(self, data=b""):
        self.data = data            # 数据包原始数据
        self.dev = None             # 接收/发送的网卡设备
        # 各层头部指针（逐层解析，不用拷贝数据）
        self.eth_hdr = None         # 以太网头指针
        self.ip_hdr = None          # IP头指针
        self.tcp_hdr = None         # TCP头指针
        self.payload = b""          # 应用层有效载荷

# ====================== 3. 最底层：网卡设备驱动层 ======================
# 对应内核 drivers/net/ 目录，直接操作物理网卡，负责硬件收发、硬中断触发
# 核心职责：收包时产生硬中断，把数据包放入内核接收队列；发包时把数据写入硬件
class NetworkCard:
    def __init__(self, name, ip_addr, mac_addr):
        self.name = name            # 网卡名，如eth0
        self.ip_addr = ip_addr      # 网卡IP地址
        self.mac_addr = mac_addr    # 网卡MAC地址
        self.rx_queue = []          # 接收队列：网卡收到的数据包放入这里
        self.tx_queue = []          # 发送队列：待发送的数据包
        self.interrupt_enabled = True  # 中断开关
        print(f"[网卡初始化] {name}  IP:{ip_addr}  MAC:{mac_addr}")

    # 模拟物理网卡收到数据包，触发硬中断
    def hardware_rx(self, frame_data):
        """模拟网线进来的数据包，硬件自动触发硬中断"""
        skb = SkBuff(frame_data)
        skb.dev = self
        self.rx_queue.append(skb)
        print(f"[网卡硬中断] {self.name} 收到数据包，放入接收队列")
        # 硬中断只做最紧急的事：收包入队，标记软中断待处理
        # 协议栈解析交给软中断，避免长时间关中断影响系统响应
        self._trigger_rx_softirq()

    # 触发接收软中断（对应内核NET_RX_SOFTIRQ）
    def _trigger_rx_softirq(self):
        """硬中断上半部结束，标记软中断待执行，协议栈处理在软中断中执行"""
        global NET_SOFTIRQ_PENDING
        NET_SOFTIRQ_PENDING = True

    # 发送数据包到物理网卡
    def hardware_tx(self, skb):
        """将封装好的以太网帧发送到网线"""
        print(f"[网卡发送] {self.name} 发送数据包，长度{len(skb.data)}字节")
        self.tx_queue.append(skb)
        # 模拟真实网卡发送完成，触发发送完成中断
        return True

# ====================== 4. 链路层：以太网 + ARP ======================
# 对应内核 net/ethernet/，负责以太网帧封装/解封装、MAC地址寻址、ARP地址解析
class LinkLayer:
    def __init__(self):
        self.arp_cache = {}  # ARP缓存：IP -> MAC地址映射
        print("[链路层初始化] 以太网模块、ARP模块加载完成")

    # 解封装以太网帧，解析出上层协议数据
    def eth_parse(self, skb):
        """接收方向：剥掉以太网头，识别上层协议"""
        # 简化以太网头解析：前6字节目的MAC，6字节源MAC，2字节协议类型
        if len(skb.data) < 14:
            return None
        dst_mac = skb.data[0:6]
        src_mac = skb.data[6:12]
        eth_type = int.from_bytes(skb.data[12:14], "big")
        
        skb.eth_hdr = {"dst_mac": dst_mac, "src_mac": src_mac, "type": eth_type}
        skb.payload = skb.data[14:]  # 去掉以太网头，剩下的交给上层
        print(f"[链路层解析] 源MAC:{src_mac.hex()}  目的MAC:{dst_mac.hex()}  协议类型:0x{eth_type:04x}")
        return eth_type

    # 封装以太网帧，准备发送
    def eth_encapsulate(self, skb, dst_mac, eth_type):
        """发送方向：添加以太网头，交给网卡发送"""
        src_mac = bytes.fromhex(skb.dev.mac_addr.replace(":", ""))
        eth_header = dst_mac + src_mac + eth_type.to_bytes(2, "big")
        skb.data = eth_header + skb.payload
        return True

    # ARP查询：根据IP找MAC地址
    def arp_lookup(self, ip_addr):
        if ip_addr in self.arp_cache:
            print(f"[ARP命中] {ip_addr} -> {self.arp_cache[ip_addr]}")
            return self.arp_cache[ip_addr]
        # 简化：模拟ARP请求后得到MAC
        fake_mac = bytes.fromhex("aa:bb:cc:dd:ee:ff".replace(":", ""))
        self.arp_cache[ip_addr] = fake_mac
        print(f"[ARP请求] 解析 {ip_addr} 得到MAC: {fake_mac.hex()}")
        return fake_mac

# ====================== 5. 网络层：IP协议 ======================
# 对应内核 net/ipv4/ip.c，负责IP报文封装/解封装、路由判断、向上层交付
class IPLayer:
    def __init__(self, local_ip_list):
        self.local_ips = local_ip_list  # 本机所有IP地址
        self.route_table = []           # 路由表（简化）
        print("[IP层初始化] 本机IP列表：", local_ip_list)

    # 解封装IP报文，判断是本机接收还是转发
    def ip_parse(self, skb):
        """接收方向：剥掉IP头，识别上层传输协议"""
        payload = skb.payload
        if len(payload) < 20:
            return None
        # 简化IP头解析：第10字节协议号，12字节源IP，16字节目的IP
        version_ihl = payload[0]
        ihl = (version_ihl & 0x0F) * 4  # IP头长度
        protocol = payload[9]
        src_ip = ".".join(map(str, payload[12:16]))
        dst_ip = ".".join(map(str, payload[16:20]))

        skb.ip_hdr = {
            "src_ip": src_ip,
            "dst_ip": dst_ip,
            "protocol": protocol
        }
        skb.payload = payload[ihl:]  # 去掉IP头，交给传输层
        print(f"[IP层解析] 源IP:{src_ip}  目的IP:{dst_ip}  上层协议:{protocol}")

        # 路由判断：目的IP是本机则向上交付，否则转发
        if dst_ip in self.local_ips:
            return protocol  # 返回上层协议号，交给对应传输层
        else:
            print("[IP转发] 非本机IP，执行转发（简化忽略）")
            return None

    # 封装IP头，准备发送
    def ip_encapsulate(self, skb, src_ip, dst_ip, protocol):
        """发送方向：添加IP头，交给链路层"""
        # 简化IP头构造
        ip_header = bytearray(20)
        ip_header[0] = 0x45  # IPv4 + 20字节头
        ip_header[9] = protocol
        ip_header[12:16] = bytes(map(int, src_ip.split(".")))
        ip_header[16:20] = bytes(map(int, dst_ip.split(".")))
        total_len = 20 + len(skb.payload)
        ip_header[2:4] = total_len.to_bytes(2, "big")
        
        skb.payload = bytes(ip_header) + skb.payload
        return True

# ====================== 6. 传输层：TCP协议（核心） ======================
# 对应内核 net/ipv4/tcp.c，核心是TCP状态机、三次握手、四次挥手、滑动窗口、可靠传输
# 每个TCP连接对应一个TCP控制块（TCB），存储连接所有状态信息
class TcpControlBlock:
    """TCP控制块 TCB，对应内核struct tcp_sock，描述一个TCP连接的全部状态"""
    def __init__(self):
        self.local_ip = ""
        self.local_port = 0
        self.remote_ip = ""
        self.remote_port = 0
        self.state = TCP_CLOSED    # 当前连接状态
        self.seq = 0              # 本地发送序号
        self.ack = 0              # 本地期望接收的序号
        self.window = DEFAULT_WINDOW  # 本地接收窗口大小
        self.rx_buffer = []       # 接收缓冲区
        self.tx_buffer = []       # 发送缓冲区
        self.backlog = []         # 半连接队列（SYN队列）
        self.accept_queue = []    # 全连接队列（已完成三次握手，等待accept）

class TCPLayer:
    def __init__(self, ip_layer, link_layer, nic):
        self.ip = ip_layer
        self.link = link_layer
        self.nic = nic
        # 所有TCP连接表：用 (本地IP,本地端口,远端IP,远端端口) 四元组唯一标识一个连接
        self.tcb_table = {}
        # 监听端口表：服务端监听的端口
        self.listen_ports = {}
        print("[TCP层初始化] TCP协议模块加载完成")

    # ====================== 接收方向：处理收到的TCP报文 ======================
    def tcp_rx(self, skb):
        """IP层向上交付的TCP报文，在此解析并驱动状态机"""
        payload = skb.payload
        if len(payload) < 20:
            return
        # 简化TCP头解析：源端口、目的端口、序号、确认号、标志位
        src_port = int.from_bytes(payload[0:2], "big")
        dst_port = int.from_bytes(payload[2:4], "big")
        seq = int.from_bytes(payload[4:8], "big")
        ack = int.from_bytes(payload[8:12], "big")
        flags = payload[13]  # TCP标志位：SYN/ACK/FIN等
        tcp_data = payload[20:]

        src_ip = skb.ip_hdr["src_ip"]
        dst_ip = skb.ip_hdr["dst_ip"]

        print(f"[TCP接收] {src_ip}:{src_port} -> {dst_ip}:{dst_port}  序号:{seq}  标志位:{flags:02x}")

        # 查找对应连接：先看是不是发给监听端口的
        if dst_port in self.listen_ports:
            # 服务端：处理新连接请求
            listen_tcb = self.listen_ports[dst_port]
            self._handle_listen_packet(listen_tcb, skb, seq, ack, flags, tcp_data, src_ip, src_port)
            return

        # 查找已建立的连接
        key = (dst_ip, dst_port, src_ip, src_port)
        if key not in self.tcb_table:
            print("[TCP丢弃] 找不到对应连接，丢弃数据包")
            return
        tcb = self.tcb_table[key]
        # 根据当前状态处理报文，驱动状态机
        self._tcp_state_machine(tcb, seq, ack, flags, tcp_data)

    # ====================== 核心：TCP状态机 ======================
    def _tcp_state_machine(self, tcb, seq, ack, flags, data):
        """根据当前状态和收到的标志位，执行状态跳转，对应内核tcp_rcv_state_process"""
        SYN = 0x02
        ACK = 0x10
        FIN = 0x01
        PSH = 0x08

        # ---- 状态1：SYN_SENT（客户端发完SYN，等SYN+ACK） ----
        if tcb.state == TCP_SYN_SENT:
            if flags & SYN and flags & ACK:
                # 收到SYN+ACK，回复ACK，连接建立
                tcb.ack = seq + 1
                tcb.seq = ack
                self._send_tcp_packet(tcb, flags=ACK)
                tcb.state = TCP_ESTABLISHED
                print("[TCP状态机] 客户端：SYN_SENT -> ESTABLISHED，三次握手完成")
            return

        # ---- 状态2：SYN_RCVD（服务端发完SYN+ACK，等ACK） ----
        if tcb.state == TCP_SYN_RCVD:
            if flags & ACK:
                # 收到第三次握手ACK，连接建立，移入全连接队列
                tcb.state = TCP_ESTABLISHED
                tcb.ack = seq
                # 加入accept队列，等待应用层accept
                tcb.accept_queue.append(tcb)
                print("[TCP状态机] 服务端：SYN_RCVD -> ESTABLISHED，三次握手完成")
            return

        # ---- 状态3：ESTABLISHED（连接已建立，正常收发数据） ----
        if tcb.state == TCP_ESTABLISHED:
            # 收到数据，放入接收缓冲区，回复ACK
            if len(data) > 0:
                tcb.rx_buffer.append(data)
                tcb.ack = seq + len(data)
                self._send_tcp_packet(tcb, flags=ACK)
                print(f"[TCP数据接收] 收到{len(data)}字节数据，已回复ACK")
            
            # 收到FIN，对方要关闭连接
            if flags & FIN:
                tcb.ack = seq + 1
                self._send_tcp_packet(tcb, flags=ACK)
                tcb.state = TCP_CLOSE_WAIT
                print("[TCP状态机] 收到对方FIN，进入CLOSE_WAIT，等待应用层关闭")
            return

        # ---- 状态4：FIN_WAIT1（主动关闭，发完FIN等ACK） ----
        if tcb.state == TCP_FIN_WAIT1:
            if flags & ACK:
                tcb.state = TCP_FIN_WAIT2
                print("[TCP状态机] FIN_WAIT1 -> FIN_WAIT2，等待对方FIN")
            return

        # ---- 状态5：FIN_WAIT2（等对方FIN） ----
        if tcb.state == TCP_FIN_WAIT2:
            if flags & FIN:
                tcb.ack = seq + 1
                self._send_tcp_packet(tcb, flags=ACK)
                tcb.state = TCP_TIME_WAIT
                print("[TCP状态机] FIN_WAIT2 -> TIME_WAIT，启动2MSL计时")
                # 简化：TIME_WAIT超时后自动关闭连接
            return

        # ---- 状态6：LAST_ACK（被动关闭，发完FIN等最后一个ACK） ----
        if tcb.state == TCP_LAST_ACK:
            if flags & ACK:
                tcb.state = TCP_CLOSED
                print("[TCP状态机] LAST_ACK -> CLOSED，连接彻底关闭")
                # 从连接表中移除
                key = (tcb.local_ip, tcb.local_port, tcb.remote_ip, tcb.remote_port)
                if key in self.tcb_table:
                    del self.tcb_table[key]
            return

    # ====================== 服务端监听处理 ======================
    def _handle_listen_packet(self, listen_tcb, skb, seq, ack, flags, data, src_ip, src_port):
        SYN = 0x02
        ACK = 0x10

        if flags & SYN:
            # 收到客户端SYN，创建新TCB，放入半连接队列
            new_tcb = TcpControlBlock()
            new_tcb.local_ip = skb.ip_hdr["dst_ip"]
            new_tcb.local_port = listen_tcb.local_port
            new_tcb.remote_ip = src_ip
            new_tcb.remote_port = src_port
            new_tcb.state = TCP_SYN_RCVD
            new_tcb.ack = seq + 1
            new_tcb.seq = 1000  # 模拟初始序号ISN
            
            # 回复SYN+ACK
            self._send_tcp_packet(new_tcb, flags=SYN | ACK)
            listen_tcb.backlog.append(new_tcb)
            print("[TCP服务端] 收到SYN，回复SYN+ACK，连接进入半连接队列")

    # ====================== 发送TCP报文 ======================
    def _send_tcp_packet(self, tcb, flags=0x10, data=b""):
        """构造TCP报文，向下交给IP层"""
        # 构造TCP头
        tcp_header = bytearray(20)
        tcp_header[0:2] = tcb.local_port.to_bytes(2, "big")
        tcp_header[2:4] = tcb.remote_port.to_bytes(2, "big")
        tcp_header[4:8] = tcb.seq.to_bytes(4, "big")
        tcp_header[8:12] = tcb.ack.to_bytes(4, "big")
        tcp_header[12] = 5 << 4  # 头长20字节
        tcp_header[13] = flags
        tcp_header[14:16] = tcb.window.to_bytes(2, "big")

        # 构造skb
        skb = SkBuff()
        skb.dev = self.nic
        skb.payload = bytes(tcp_header) + data

        # IP层封装
        self.ip.ip_encapsulate(skb, tcb.local_ip, tcb.remote_ip, IP_PROTO_TCP)

        # 链路层封装
        dst_mac = self.link.arp_lookup(tcb.remote_ip)
        self.link.eth_encapsulate(skb, dst_mac, ETH_TYPE_IP)

        # 网卡发送
        self.nic.hardware_tx(skb)
        tcb.seq += len(data)  # 发送序号前移

    # ====================== 服务端接口：监听端口 ======================
    def tcp_listen(self, local_ip, local_port, backlog=5):
        """对应内核tcp_listen，创建监听TCB"""
        tcb = TcpControlBlock()
        tcb.local_ip = local_ip
        tcb.local_port = local_port
        tcb.state = TCP_LISTEN
        self.listen_ports[local_port] = tcb
        print(f"[TCP监听] 端口 {local_port} 进入LISTEN状态，半连接队列长度{backlog}")
        return tcb

    # ====================== 客户端接口：发起连接 ======================
    def tcp_connect(self, local_ip, local_port, remote_ip, remote_port):
        """对应内核tcp_connect，客户端发起三次握手"""
        tcb = TcpControlBlock()
        tcb.local_ip = local_ip
        tcb.local_port = local_port
        tcb.remote_ip = remote_ip
        tcb.remote_port = remote_port
        tcb.seq = 100  # 客户端初始序号
        tcb.state = TCP_SYN_SENT

        # 发送SYN包，第一次握手
        self._send_tcp_packet(tcb, flags=0x02)
        key = (local_ip, local_port, remote_ip, remote_port)
        self.tcb_table[key] = tcb
        print(f"[TCP连接] 客户端发起连接，发送SYN，进入SYN_SENT状态")
        return tcb

    # ====================== 应用层发送数据 ======================
    def tcp_send(self, tcb, data):
        """应用层调用发送，放入发送缓冲区，封装TCP报文发出"""
        if tcb.state != TCP_ESTABLISHED:
            print("[TCP发送失败] 连接未建立")
            return -1
        self._send_tcp_packet(tcb, flags=0x18, data=data)  # PSH+ACK
        print(f"[TCP发送] 发送{len(data)}字节数据")
        return len(data)

    # ====================== 应用层接收数据 ======================
    def tcp_recv(self, tcb, length):
        """应用层从接收缓冲区读取数据"""
        if not tcb.rx_buffer:
            return b""
        data = b"".join(tcb.rx_buffer)
        tcb.rx_buffer.clear()
        return data[:length]

    # ====================== 主动关闭连接 ======================
    def tcp_close(self, tcb):
        """主动关闭，发送FIN，启动四次挥手"""
        if tcb.state == TCP_ESTABLISHED:
            self._send_tcp_packet(tcb, flags=0x01)  # FIN
            tcb.state = TCP_FIN_WAIT1
            print("[TCP关闭] 主动发送FIN，进入FIN_WAIT1，启动四次挥手")
        elif tcb.state == TCP_CLOSE_WAIT:
            # 被动关闭侧，应用层调用close，发送FIN
            self._send_tcp_packet(tcb, flags=0x01)
            tcb.state = TCP_LAST_ACK
            print("[TCP关闭] 被动侧发送FIN，进入LAST_ACK")

# ====================== 7. Socket系统调用层 ======================
# 对应内核 net/socket.c，对应用户态socket API，屏蔽底层协议差异，提供统一接口
# 所有用户态网络操作都通过socket系统调用进入内核
class SocketSystem:
    def __init__(self, tcp_layer):
        self.tcp = tcp_layer
        self.fd_table = {}      # 文件描述符 -> socket对象
        self.next_fd = 0
        print("[Socket层初始化] BSD套接字接口加载完成")

    def socket(self, proto=IP_PROTO_TCP):
        """创建socket，返回文件描述符"""
        fd = self.next_fd
        self.next_fd += 1
        self.fd_table[fd] = {"proto": proto, "tcb": None, "type": "socket"}
        print(f"[Socket创建] 文件描述符：{fd}，协议：TCP")
        return fd

    def bind(self, fd, ip, port):
        """绑定本地IP和端口"""
        if fd not in self.fd_table:
            return -1
        self.fd_table[fd]["local_ip"] = ip
        self.fd_table[fd]["local_port"] = port
        print(f"[Socket绑定] fd={fd} 绑定地址 {ip}:{port}")
        return 0

    def listen(self, fd, backlog=5):
        """服务端开启监听"""
        info = self.fd_table[fd]
        tcb = self.tcp.tcp_listen(info["local_ip"], info["local_port"], backlog)
        info["tcb"] = tcb
        return 0

    def connect(self, fd, remote_ip, remote_port):
        """客户端发起连接"""
        info = self.fd_table[fd]
        tcb = self.tcp.tcp_connect(
            info["local_ip"], info["local_port"],
            remote_ip, remote_port
        )
        info["tcb"] = tcb
        return 0

    def send(self, fd, data):
        """发送数据"""
        tcb = self.fd_table[fd]["tcb"]
        return self.tcp.tcp_send(tcb, data)

    def recv(self, fd, length=1024):
        """接收数据"""
        tcb = self.fd_table[fd]["tcb"]
        return self.tcp.tcp_recv(tcb, length)

    def close(self, fd):
        """关闭socket"""
        tcb = self.fd_table[fd]["tcb"]
        if tcb:
            self.tcp.tcp_close(tcb)
        del self.fd_table[fd]
        return 0

# ====================== 8. 网络栈总控：软中断处理 ======================
# 对应内核net_rx_action，软中断上下文处理接收队列里的所有数据包，逐层解析
NET_SOFTIRQ_PENDING = False

def net_softirq_handler(nic, link_layer, ip_layer, tcp_layer):
    """网络接收软中断处理函数，批量处理网卡接收队列的数据包"""
    global NET_SOFTIRQ_PENDING
    if not NET_SOFTIRQ_PENDING:
        return
    print("\n---------- 网络软中断处理开始 ----------")
    
    while nic.rx_queue:
        skb = nic.rx_queue.pop(0)
        # 逐层向上解析：链路层 → IP层 → TCP层
        eth_type = link_layer.eth_parse(skb)
        if eth_type == ETH_TYPE_IP:
            proto = ip_layer.ip_parse(skb)
            if proto == IP_PROTO_TCP:
                tcp_layer.tcp_rx(skb)
    
    NET_SOFTIRQ_PENDING = False
    print("---------- 网络软中断处理结束 ----------\n")

# ====================== 9. 测试示例：TCP三次握手+数据收发+四次挥手 ======================
if __name__ == "__main__":
    print("===== Linux 网络协议栈启动 =====")
    # 1. 初始化网卡
    server_nic = NetworkCard("eth0", "192.168.1.10", "00:11:22:33:44:55")
    client_nic = NetworkCard("eth0", "192.168.1.20", "aa:bb:cc:dd:ee:ff")

    # 2. 初始化各层协议
    link = LinkLayer()
    ip_server = IPLayer(["192.168.1.10"])
    ip_client = IPLayer(["192.168.1.20"])
    tcp_server = TCPLayer(ip_server, link, server_nic)
    tcp_client = TCPLayer(ip_client, link, client_nic)

    # 3. 初始化Socket接口
    server_socket = SocketSystem(tcp_server)
    client_socket = SocketSystem(tcp_client)

    print("\n===== 步骤1：服务端创建Socket并监听 =====")
    server_fd = server_socket.socket()
    server_socket.bind(server_fd, "192.168.1.10", 8080)
    server_socket.listen(server_fd)

    print("\n===== 步骤2：客户端发起连接（三次握手） =====")
    client_fd = client_socket.socket()
    client_socket.bind(client_fd, "192.168.1.20", 50001)
    client_socket.connect(client_fd, "192.168.1.10", 8080)

    # 模拟：客户端SYN包到达服务端网卡，触发硬中断+软中断
    syn_packet = client_nic.tx_queue.pop().data
    server_nic.hardware_rx(syn_packet)
    net_softirq_handler(server_nic, link, ip_server, tcp_server)

    # 模拟：服务端SYN+ACK到达客户端网卡
    synack_packet = server_nic.tx_queue.pop().data
    client_nic.hardware_rx(synack_packet)
    net_softirq_handler(client_nic, link, ip_client, tcp_client)

    # 模拟：客户端ACK到达服务端，三次握手完成
    ack_packet = client_nic.tx_queue.pop().data
    server_nic.hardware_rx(ack_packet)
    net_softirq_handler(server_nic, link, ip_server, tcp_server)

    print("\n===== 步骤3：数据收发 =====")
    # 客户端发送数据
    client_socket.send(client_fd, b"Hello Linux TCP Stack!")
    # 数据包到达服务端
    data_packet = client_nic.tx_queue.pop().data
    server_nic.hardware_rx(data_packet)
    net_softirq_handler(server_nic, link, ip_server, tcp_server)

    # 服务端读取数据
    server_tcb = tcp_server.listen_ports[8080].accept_queue[0]
    recv_data = tcp_server.tcp_recv(server_tcb, 1024)
    print("服务端收到数据：", recv_data.decode())

    print("\n===== 步骤4：主动关闭连接（四次挥手） =====")
    # 客户端主动关闭
    client_socket.close(client_fd)
    # FIN包到达服务端
    fin_packet = client_nic.tx_queue.pop().data
    server_nic.hardware_rx(fin_packet)
    net_softirq_handler(server_nic, link, ip_server, tcp_server)

    # 服务端回复ACK，再调用close发FIN
    tcp_server.tcp_close(server_tcb)
    # 服务端FIN到达客户端
    fin2_packet = server_nic.tx_queue.pop().data
    client_nic.hardware_rx(fin2_packet)
    net_softirq_handler(client_nic, link, ip_client, tcp_client)

    # 客户端最后一个ACK到达服务端
    last_ack = client_nic.tx_queue.pop().data
    server_nic.hardware_rx(last_ack)
    net_softirq_handler(server_nic, link, ip_server, tcp_server)
```



## Linux 1.0 进程间通信（IPC）子系统

```python
# ====================== Linux 1.0 进程间通信（IPC）子系统 完整伪代码（Python版） ======================
# 对应内核源码 ipc/ 目录，实现 System V 标准 IPC 三大机制：消息队列、信号量、共享内存
# 核心设计：统一 IPC 权限结构 + 标识符管理，三种机制独立实现，均通过系统调用供用户态进程使用
# 简化权限校验、复杂锁机制，保留 IPC 核心原理与经典接口，注释逐行讲解设计思想

# ====================== 1. 核心常量定义 ======================
# IPC 通用控制命令（对应内核 ipc.h）
IPC_CREAT = 0o1000    # 若对象不存在则创建
IPC_RMID = 0          # 删除 IPC 对象
IPC_PRIVATE = 0       # 私有 IPC 键，每次创建全新对象

# 消息队列常量
MSG_MAX_SIZE = 1024   # 单条消息最大长度
MSG_MAX_BYTES = 4096  # 单个队列最大总字节数

# 信号量操作命令
SETVAL = 1            # 设置单个信号量的值
GETVAL = 2            # 获取单个信号量的值
SEM_UNDO = 0x1000     # 进程退出时自动还原信号量值

# 共享内存常量
SHM_MAX_SIZE = 65536  # 单个共享内存段最大大小
SHM_RDONLY = 0o10000  # 只读方式挂载

# ====================== 2. IPC 通用权限结构 ======================
# 对应内核 struct ipc_perm，所有 IPC 对象都包含该结构，用于权限校验、唯一标识
class IPCPerm:
    def __init__(self, key, uid=0, gid=0, mode=0o666):
        self.key = key      # 用户传入的键值，用于查找 IPC 对象
        self.uid = uid      # 所有者用户ID
        self.gid = gid      # 所有组ID
        self.mode = mode    # 读写权限位，和文件权限一致
        self.seq = 0        # 序号，用于生成唯一 IPC 标识符

# ====================== 3. 机制一：消息队列 ======================
# 对应内核 ipc/msg.c，进程间传递结构化消息，按消息类型收发，自带同步阻塞
# 特点：异步、自带消息边界、支持按优先级（类型）读取，无需手动同步
class Message:
    """单条消息结构：消息类型 + 消息数据"""
    def __init__(self, msg_type, data):
        self.msg_type = msg_type  # 消息类型，可用于优先级区分
        self.data = data          # 消息内容

class MsgQueue:
    """消息队列控制结构，对应内核 struct msg_queue"""
    def __init__(self, qid, perm):
        self.qid = qid            # 消息队列ID（内核全局唯一标识符）
        self.perm = perm          # 通用权限结构
        self.msg_list = []        # 消息链表，按入队顺序存储
        self.cbytes = 0           # 当前队列总字节数
        self.qnum = 0             # 当前消息条数
        self.max_bytes = MSG_MAX_BYTES  # 队列最大字节数

# ====================== 4. 机制二：信号量 ======================
# 对应内核 ipc/sem.c，本质是计数器，用于进程间互斥与同步，控制共享资源并发访问
# 特点：System V 信号量以「信号量集」为单位，支持批量操作，保证原子性
class Semaphore:
    """单个信号量结构"""
    def __init__(self, val=0):
        self.val = val            # 信号量当前值
        self.sempid = 0           # 最后操作该信号量的进程PID

class SemArray:
    """信号量集控制结构，对应内核 struct sem_array"""
    def __init__(self, semid, perm, nsems):
        self.semid = semid        # 信号量集ID
        self.perm = perm          # 通用权限结构
        self.sems = [Semaphore() for _ in range(nsems)]  # 信号量数组
        self.nsems = nsems        # 集合内信号量数量

# ====================== 5. 机制三：共享内存 ======================
# 对应内核 ipc/shm.c，多进程映射同一块物理内存，是速度最快的IPC方式
# 特点：无数据拷贝，速度极快；本身无同步机制，需配合信号量/互斥锁使用
class ShmSegment:
    """共享内存段控制结构，对应内核 struct shmid_ds"""
    def __init__(self, shmid, perm, size):
        self.shmid = shmid        # 共享内存段ID
        self.perm = perm          # 通用权限结构
        self.size = size          # 内存段大小
        self.data = bytearray(size)  # 模拟共享物理内存数据
        self.attach_count = 0     # 当前挂载进程数
        self.attached_procs = set()  # 挂载该段的进程PID集合

# ====================== 6. IPC 子系统总控类 ======================
# 对应内核 ipc/util.c 总控逻辑，全局管理所有 IPC 对象，提供三大机制的系统调用接口
class IPCSubsystem:
    def __init__(self):
        # 全局 IPC 对象表，用字典模拟内核数组，ID 为键
        self.msg_queues = {}      # 消息队列表
        self.sem_arrays = {}      # 信号量表
        self.shm_segments = {}    # 共享内存表
        
        # 自增ID生成器
        self._next_msgid = 0
        self._next_semid = 0
        self._next_shmid = 0
        print("[IPC子系统初始化] System V IPC 三大机制加载完成")

    # ==================================================
    # 消息队列接口（对应系统调用 msgget / msgsnd / msgrcv / msgctl）
    # ==================================================
    def msgget(self, key, flags=0o666):
        """创建或获取一个消息队列，返回队列ID"""
        # 私有键：直接创建新队列
        if key == IPC_PRIVATE or (flags & IPC_CREAT):
            qid = self._next_msgid
            self._next_msgid += 1
            perm = IPCPerm(key, mode=flags & 0o777)
            self.msg_queues[qid] = MsgQueue(qid, perm)
            print(f"[消息队列] 创建队列，ID={qid}, key={key}")
            return qid
        
        # 非私有键：查找已存在的队列
        for q in self.msg_queues.values():
            if q.perm.key == key:
                print(f"[消息队列] 获取已存在队列，ID={q.qid}")
                return q.qid
        
        raise Exception("消息队列不存在，且未指定创建标志")

    def msgsnd(self, qid, msg_type, data, pid=0):
        """向指定队列发送一条消息"""
        if qid not in self.msg_queues:
            raise Exception("消息队列不存在")
        queue = self.msg_queues[qid]
        
        # 队列满则阻塞（简化处理：直接报错，真实内核会睡眠等待）
        if queue.cbytes + len(data) > queue.max_bytes:
            raise Exception("消息队列已满，写入阻塞")
        
        # 消息入队
        msg = Message(msg_type, data)
        queue.msg_list.append(msg)
        queue.cbytes += len(data)
        queue.qnum += 1
        print(f"[消息队列] 进程{pid}向队列{qid}发送消息，类型={msg_type}，长度={len(data)}字节")

    def msgrcv(self, qid, msg_type=0, pid=0):
        """从队列接收一条消息，支持按类型筛选"""
        if qid not in self.msg_queues:
            raise Exception("消息队列不存在")
        queue = self.msg_queues[qid]
        
        if not queue.msg_list:
            print(f"[消息队列] 队列{qid}为空，进程{pid}阻塞等待")
            return None
        
        # msg_type=0：按先进先出取第一条
        # msg_type>0：取第一条类型匹配的消息
        target_idx = 0
        if msg_type > 0:
            for i, msg in enumerate(queue.msg_list):
                if msg.msg_type == msg_type:
                    target_idx = i
                    break
        
        msg = queue.msg_list.pop(target_idx)
        queue.cbytes -= len(msg.data)
        queue.qnum -= 1
        print(f"[消息队列] 进程{pid}从队列{qid}接收消息，类型={msg.msg_type}，内容：{msg.data}")
        return msg.data

    def msgctl(self, qid, cmd):
        """控制消息队列，常用删除操作"""
        if cmd == IPC_RMID:
            if qid in self.msg_queues:
                del self.msg_queues[qid]
                print(f"[消息队列] 删除队列 ID={qid}")
                return 0
        return -1

    # ==================================================
    # 信号量接口（对应系统调用 semget / semop / semctl）
    # ==================================================
    def semget(self, key, nsems, flags=0o666):
        """创建或获取信号量集，nsems为集合内信号量数量"""
        if key == IPC_PRIVATE or (flags & IPC_CREAT):
            semid = self._next_semid
            self._next_semid += 1
            perm = IPCPerm(key, mode=flags & 0o777)
            self.sem_arrays[semid] = SemArray(semid, perm, nsems)
            print(f"[信号量] 创建信号量集，ID={semid}，包含{nsems}个信号量")
            return semid
        
        for s in self.sem_arrays.values():
            if s.perm.key == key:
                return s.semid
        raise Exception("信号量集不存在")

    def semop(self, semid, sem_num, op_val, pid=0):
        """
        信号量原子操作（P/V操作）
        op_val < 0：P操作，申请资源，信号量值减少，不够则阻塞
        op_val > 0：V操作，释放资源，信号量值增加
        """
        if semid not in self.sem_arrays:
            raise Exception("信号量集不存在")
        sem_array = self.sem_arrays[semid]
        sem = sem_array.sems[sem_num]
        
        # P操作：申请资源，值不足则阻塞
        if op_val < 0:
            need = abs(op_val)
            if sem.val < need:
                print(f"[信号量] 进程{pid}申请{need}个资源，当前值={sem.val}，阻塞等待")
                return False
            sem.val -= need
            sem.sempid = pid
            print(f"[信号量-P] 进程{pid}申请{need}个资源，剩余值={sem.val}")
            return True
        
        # V操作：释放资源
        if op_val > 0:
            sem.val += op_val
            sem.sempid = pid
            print(f"[信号量-V] 进程{pid}释放{op_val}个资源，当前值={sem.val}")
            return True
        return False

    def semctl(self, semid, sem_num, cmd, val=0):
        """控制信号量：设置值、获取值、删除集合"""
        if semid not in self.sem_arrays:
            return -1
        sem_array = self.sem_arrays[semid]
        
        if cmd == SETVAL:
            sem_array.sems[sem_num].val = val
            print(f"[信号量控制] 设置第{sem_num}个信号量值为{val}")
            return 0
        elif cmd == GETVAL:
            return sem_array.sems[sem_num].val
        elif cmd == IPC_RMID:
            del self.sem_arrays[semid]
            print(f"[信号量] 删除信号量集 ID={semid}")
            return 0
        return -1

    # ==================================================
    # 共享内存接口（对应系统调用 shmget / shmat / shmdt / shmctl）
    # ==================================================
    def shmget(self, key, size, flags=0o666):
        """创建或获取共享内存段，返回段ID"""
        if key == IPC_PRIVATE or (flags & IPC_CREAT):
            if size > SHM_MAX_SIZE:
                raise Exception("共享内存大小超过上限")
            shmid = self._next_shmid
            self._next_shmid += 1
            perm = IPCPerm(key, mode=flags & 0o777)
            self.shm_segments[shmid] = ShmSegment(shmid, perm, size)
            print(f"[共享内存] 创建段，ID={shmid}，大小={size}字节")
            return shmid
        
        for s in self.shm_segments.values():
            if s.perm.key == key:
                return s.shmid
        raise Exception("共享内存段不存在")

    def shmat(self, shmid, pid, readonly=False):
        """
        进程挂载共享内存，将物理内存映射到进程虚拟地址空间
        返回共享内存数据对象（模拟进程拿到的内存指针）
        """
        if shmid not in self.shm_segments:
            raise Exception("共享内存段不存在")
        seg = self.shm_segments[shmid]
        
        seg.attach_count += 1
        seg.attached_procs.add(pid)
        mode = "只读" if readonly else "读写"
        print(f"[共享内存挂载] 进程{pid}挂载段{shmid}，模式：{mode}，当前挂载数={seg.attach_count}")
        # 返回共享内存数据引用，进程可直接读写
        return seg.data

    def shmdt(self, shmid, pid):
        """进程卸载共享内存，解除地址映射"""
        if shmid not in self.shm_segments:
            return -1
        seg = self.shm_segments[shmid]
        
        if pid in seg.attached_procs:
            seg.attached_procs.remove(pid)
            seg.attach_count -= 1
            print(f"[共享内存卸载] 进程{pid}卸载段{shmid}，当前挂载数={seg.attach_count}")
        return 0

    def shmctl(self, shmid, cmd):
        """控制共享内存，常用删除操作"""
        if cmd == IPC_RMID:
            if shmid in self.shm_segments:
                del self.shm_segments[shmid]
                print(f"[共享内存] 删除段 ID={shmid}")
                return 0
        return -1

# ====================== 7. 测试示例：模拟进程间通信完整流程 ======================
if __name__ == "__main__":
    print("===== IPC 子系统启动 =====")
    ipc = IPCSubsystem()

    print("\n===== 测试1：消息队列 - 进程间异步传消息 =====")
    # 创建消息队列
    mq_id = ipc.msgget(IPC_PRIVATE, IPC_CREAT | 0o666)
    # 进程1发送两条不同类型的消息
    ipc.msgsnd(mq_id, msg_type=1, data=b"Hello, this is type 1", pid=1001)
    ipc.msgsnd(mq_id, msg_type=2, data=b"Priority message type 2", pid=1001)
    # 进程2按类型接收消息
    ipc.msgrcv(mq_id, msg_type=2, pid=1002)  # 优先接收类型2
    ipc.msgrcv(mq_id, msg_type=0, pid=1002)  # 接收剩余的
    # 删除队列
    ipc.msgctl(mq_id, IPC_RMID)

    print("\n===== 测试2：信号量 - 进程互斥同步 =====")
    # 创建包含1个信号量的集合
    sem_id = ipc.semget(IPC_PRIVATE, 1, IPC_CREAT | 0o666)
    # 初始化信号量值为1（二元信号量，作互斥锁用）
    ipc.semctl(sem_id, 0, SETVAL, 1)
    
    # 进程A申请锁（P操作）
    ipc.semop(sem_id, 0, -1, pid=2001)
    # 进程B再申请，资源不足阻塞
    ipc.semop(sem_id, 0, -1, pid=2002)
    # 进程A释放锁（V操作）
    ipc.semop(sem_id, 0, 1, pid=2001)
    # 进程B再次申请成功
    ipc.semop(sem_id, 0, -1, pid=2002)
    # 删除信号量集
    ipc.semctl(sem_id, 0, IPC_RMID)

    print("\n===== 测试3：共享内存 - 进程间高速大数据传输 =====")
    # 创建1KB共享内存段
    shm_id = ipc.shmget(IPC_PRIVATE, 1024, IPC_CREAT | 0o666)
    
    # 进程1挂载，写入数据
    shm_ptr1 = ipc.shmat(shm_id, pid=3001)
    shm_ptr1[0:20] = b"Shared memory test data"
    print(f"[进程3001] 写入共享内存：{bytes(shm_ptr1[0:20]).decode()}")
    
    # 进程2挂载，直接读取数据（无拷贝，最快IPC）
    shm_ptr2 = ipc.shmat(shm_id, pid=3002)
    print(f"[进程3002] 读取共享内存：{bytes(shm_ptr2[0:20]).decode()}")
    
    # 两进程卸载
    ipc.shmdt(shm_id, 3001)
    ipc.shmdt(shm_id, 3002)
    # 删除共享内存段
    ipc.shmctl(shm_id, IPC_RMID)
```





## linux1.0 设备驱动子系统

```bash
# ====================== Linux 1.0 设备驱动子系统 完整伪代码（Python版） ======================
# 对应内核源码 drivers/ 目录核心逻辑，是内核与硬件之间的唯一桥梁
# 核心设计：按设备类型分为「字符设备 / 块设备 / 网络设备」三大类，通过「设备号 + 操作函数集」统一管理
# 向上对接 VFS 虚拟文件系统，屏蔽硬件差异；向下直接操作硬件寄存器，控制硬件工作
# 简化硬件寄存器操作、中断处理细节，保留驱动注册、设备号管理、操作集抽象的核心原理

# ====================== 1. 核心常量定义 ======================
# 设备大类
DEVICE_TYPE_CHAR = 1    # 字符设备：按字节流读写，无缓存，如串口、键盘、终端
DEVICE_TYPE_BLOCK = 2   # 块设备：按固定块读写，带缓存，如磁盘、U盘
DEVICE_TYPE_NET = 3     # 网络设备：面向数据包收发，无设备文件，通过socket接口访问

# 经典主设备号（Linux 1.0 标准分配）
MAJOR_TTY = 4           # 串口/终端设备主设备号
MAJOR_RAMDISK = 1       # RAM虚拟盘主设备号
MAJOR_IDE_DISK = 3      # IDE硬盘主设备号

# ====================== 2. 驱动操作函数集 file_operations ======================
# 对应内核 include/linux/fs.h 中的 struct file_operations
# 驱动的核心：每个驱动实现自己的读写等函数，挂载到这个结构里，内核通过统一接口调用
class FileOperations:
    """驱动向上提供的操作接口，所有驱动都按这个标准实现，VFS通过它调用驱动"""
    def __init__(self):
        # 函数指针集合，对应内核里的函数指针，每个驱动自行实现
        self.open = None      # 打开设备
        self.read = None      # 读设备数据
        self.write = None     # 写数据到设备
        self.release = None   # 关闭设备
        self.ioctl = None     # 设备控制命令（特殊配置）

# ====================== 3. 字符设备驱动结构 ======================
# 对应内核 drivers/char/ 目录下的字符设备驱动
# 特点：字节流访问、顺序读写，无块缓存，最简单直接的设备类型
class CharDeviceDriver:
    def __init__(self, major, name, fops):
        self.major = major    # 主设备号：唯一标识一类驱动
        self.name = name      # 驱动名称
        self.fops = fops      # 操作函数集
        self.minor_devices = {}  # 次设备号 -> 具体设备实例
        print(f"[字符驱动注册] 主设备号{major}，驱动名：{name}")

# ====================== 4. 块设备驱动结构 ======================
# 对应内核 drivers/block/ 目录下的块设备驱动
# 特点：按固定块大小读写，配合 Buffer Cache 缓存，有 IO 请求队列，性能更优
class BlockDeviceDriver:
    def __init__(self, major, name, fops, block_size=4096):
        self.major = major    # 主设备号
        self.name = name      # 驱动名称
        self.fops = fops      # 操作函数集
        self.block_size = block_size  # 块大小
        self.request_queue = []       # IO请求队列，电梯调度在此处理
        self.minor_devices = {}       # 次设备号 -> 具体块设备实例
        print(f"[块驱动注册] 主设备号{major}，驱动名：{name}，块大小：{block_size}B")

# ====================== 5. 设备文件结构（对应 /dev 目录下的设备节点） ======================
# 用户态通过设备文件访问硬件，设备文件通过「设备类型+主设备号+次设备号」找到对应驱动
class DeviceFile:
    def __init__(self, filename, dev_type, major, minor):
        self.filename = filename    # 设备文件名，如 /dev/tty0
        self.dev_type = dev_type    # 设备类型：字符/块
        self.major = major          # 主设备号：找驱动
        self.minor = minor          # 次设备号：找同驱动下的具体硬件
        print(f"[创建设备文件] {filename}  类型：{'字符' if dev_type==DEVICE_TYPE_CHAR else '块'}  设备号：{major}:{minor}")

# ====================== 6. 驱动子系统总控类 ======================
# 对应内核 drivers/char/mem.c、drivers/block/ll_rw_blk.c 等总控逻辑
# 负责驱动注册、设备号管理、向上对接VFS、向下分发操作到具体驱动
class DeviceDriverManager:
    def __init__(self):
        # 字符设备表：下标为主设备号，值为字符驱动对象
        self.char_devices = {}
        # 块设备表：下标为主设备号，值为块驱动对象
        self.block_devices = {}
        # 已创建的设备文件
        self.dev_files = {}
        print("[设备驱动子系统初始化] 字符设备、块设备管理框架加载完成")

    # ====================== 6.1 驱动注册接口 ======================
    def register_chrdev(self, major, name, fops):
        """注册字符设备驱动，对应内核 register_chrdev 函数"""
        if major in self.char_devices:
            raise Exception(f"主设备号{major}已被占用")
        driver = CharDeviceDriver(major, name, fops)
        self.char_devices[major] = driver
        return 0

    def register_blkdev(self, major, name, fops, block_size=4096):
        """注册块设备驱动，对应内核 register_blkdev 函数"""
        if major in self.block_devices:
            raise Exception(f"主设备号{major}已被占用")
        driver = BlockDeviceDriver(major, name, fops, block_size)
        self.block_devices[major] = driver
        return 0

    # ====================== 6.2 创建设备文件（对应 mknod 命令） ======================
    def mknod(self, filename, dev_type, major, minor):
        """创建设备文件节点，用户态通过 mknod 命令调用"""
        if filename in self.dev_files:
            raise Exception("设备文件已存在")
        dev_file = DeviceFile(filename, dev_type, major, minor)
        self.dev_files[filename] = dev_file
        return 0

    # ====================== 6.3 通用设备操作入口（VFS -> 驱动的桥梁） ======================
    # 用户态 open/read/write 设备文件时，VFS 找到对应驱动，调用驱动的实现函数
    def open_device(self, filename, pid=0):
        if filename not in self.dev_files:
            raise Exception("设备文件不存在")
        dev = self.dev_files[filename]
        # 根据设备类型找对应驱动
        if dev.dev_type == DEVICE_TYPE_CHAR:
            driver = self.char_devices.get(dev.major)
        else:
            driver = self.block_devices.get(dev.major)
        
        if not driver:
            raise Exception(f"找不到主设备号{dev.major}对应的驱动")
        
        # 调用驱动的 open 函数
        if driver.fops.open:
            driver.fops.open(dev.minor, pid)
        print(f"[设备打开] 进程{pid}打开设备 {filename}")
        return driver

    def read_device(self, filename, length, offset=0, pid=0):
        driver = self.open_device(filename, pid)
        if driver.fops.read:
            data = driver.fops.read(self.dev_files[filename].minor, length, offset)
            print(f"[设备读] 进程{pid}从 {filename} 读取 {len(data)} 字节")
            return data
        return b""

    def write_device(self, filename, data, offset=0, pid=0):
        driver = self.open_device(filename, pid)
        if driver.fops.write:
            ret = driver.fops.write(self.dev_files[filename].minor, data, offset)
            print(f"[设备写] 进程{pid}向 {filename} 写入 {len(data)} 字节")
            return ret
        return -1

# ====================== 7. 具体驱动实现1：串口字符设备驱动 ======================
# 对应内核 drivers/char/serial.c，最经典的字符设备，按字节流收发数据
class SerialDriver:
    def __init__(self):
        # 模拟串口硬件的收发缓冲区
        self.rx_buffer = {}  # 次设备号 -> 接收缓冲区
        self.tx_buffer = {}  # 次设备号 -> 发送缓冲区
        self.fops = FileOperations()
        # 挂载驱动实现的函数到操作集
        self.fops.open = self.serial_open
        self.fops.read = self.serial_read
        self.fops.write = self.serial_write
        self.fops.release = self.serial_close

    def serial_open(self, minor, pid):
        """打开串口：初始化硬件缓冲区，配置波特率等（简化）"""
        if minor not in self.rx_buffer:
            self.rx_buffer[minor] = bytearray()
            self.tx_buffer[minor] = bytearray()
        print(f"  [串口驱动] 打开串口 tty{minor}，硬件初始化完成")

    def serial_read(self, minor, length, offset):
        """读串口：从接收缓冲区取数据，模拟硬件接收到的数据"""
        if minor not in self.rx_buffer:
            return b""
        buf = self.rx_buffer[minor]
        data = bytes(buf[:length])
        del buf[:length]
        print(f"  [串口驱动] 串口{minor}读取 {len(data)} 字节")
        return data

    def serial_write(self, minor, data, offset):
        """写串口：数据写入发送缓冲区，模拟硬件发出去"""
        if minor not in self.tx_buffer:
            return -1
        self.tx_buffer[minor].extend(data)
        print(f"  [串口驱动] 串口{minor}发送 {len(data)} 字节数据到硬件")
        return len(data)

    def serial_close(self, minor, pid):
        print(f"  [串口驱动] 关闭串口 tty{minor}")

    # 模拟硬件收到数据，放入接收缓冲区（对应硬件中断）
    def hardware_rx(self, minor, data):
        if minor in self.rx_buffer:
            self.rx_buffer[minor].extend(data)
            print(f"  [串口硬件中断] 串口{minor}收到外部数据：{data}")

# ====================== 8. 具体驱动实现2：RAM虚拟盘块设备驱动 ======================
# 对应内核 drivers/block/rd.c，用内存模拟磁盘，是最简单的块设备驱动
class RamDiskDriver:
    def __init__(self, disk_size=1024*1024, block_size=4096):
        self.disk_size = disk_size    # 磁盘总大小
        self.block_size = block_size  # 块大小
        self.total_blocks = disk_size // block_size
        # 用内存模拟磁盘存储空间，每个次设备号对应一块独立RAM盘
        self.disks = {}
        self.fops = FileOperations()
        self.fops.open = self.rd_open
        self.fops.read = self.rd_read_block
        self.fops.write = self.rd_write_block

    def rd_open(self, minor, pid):
        """打开RAM盘：初始化内存空间"""
        if minor not in self.disks:
            self.disks[minor] = bytearray(self.disk_size)
        print(f"  [RAM盘驱动] 打开RAM盘 {minor}，总大小：{self.disk_size//1024}KB")

    def rd_read_block(self, minor, length, offset):
        """按块读取：从内存模拟的磁盘中读取数据"""
        if minor not in self.disks:
            return b""
        disk = self.disks[minor]
        # 块设备必须按块对齐读写，这里简化处理
        end = min(offset + length, self.disk_size)
        data = bytes(disk[offset:end])
        print(f"  [RAM盘驱动] 从盘{minor}偏移{offset}读取 {len(data)} 字节")
        return data

    def rd_write_block(self, minor, data, offset):
        """按块写入：数据写入内存模拟的磁盘"""
        if minor not in self.disks:
            return -1
        disk = self.disks[minor]
        write_len = min(len(data), self.disk_size - offset)
        disk[offset:offset+write_len] = data[:write_len]
        print(f"  [RAM盘驱动] 向盘{minor}偏移{offset}写入 {write_len} 字节")
        return write_len

# ====================== 9. 测试示例：驱动注册 + 设备文件操作 ======================
if __name__ == "__main__":
    print("===== 设备驱动子系统启动 =====")
    # 1. 初始化驱动管理器
    drv_mgr = DeviceDriverManager()

    print("\n===== 测试1：串口字符设备驱动 =====")
    # 实例化串口驱动
    serial_drv = SerialDriver()
    # 向内核注册字符设备驱动，主设备号4
    drv_mgr.register_chrdev(MAJOR_TTY, "serial", serial_drv.fops)
    # 创建设备文件 /dev/tty0，次设备号0
    drv_mgr.mknod("/dev/tty0", DEVICE_TYPE_CHAR, MAJOR_TTY, 0)

    # 模拟硬件串口收到数据（硬件中断）
    serial_drv.hardware_rx(0, b"UART received data")
    # 进程打开串口并读取数据
    data = drv_mgr.read_device("/dev/tty0", 100, pid=1001)
    print("用户态读到串口数据：", data.decode())

    # 进程向串口写入数据
    drv_mgr.write_device("/dev/tty0", b"Hello Serial Port", pid=1001)

    print("\n===== 测试2：RAM盘块设备驱动 =====")
    # 实例化RAM盘驱动
    ram_drv = RamDiskDriver(disk_size=64*1024)  # 64KB虚拟盘
    # 向内核注册块设备驱动，主设备号1
    drv_mgr.register_blkdev(MAJOR_RAMDISK, "ramdisk", ram_drv.fops)
    # 创建设备文件 /dev/ram0，次设备号0
    drv_mgr.mknod("/dev/ram0", DEVICE_TYPE_BLOCK, MAJOR_RAMDISK, 0)

    # 向RAM盘写入数据
    drv_mgr.write_device("/dev/ram0", b"Ramdisk test data block", offset=0, pid=1002)
    # 从RAM盘读取数据
    data2 = drv_mgr.read_device("/dev/ram0", 50, offset=0, pid=1002)
    print("用户态读到RAM盘数据：", data2.decode())
```







# sre工程师和linux运维区别  

### 一、英文全称

1. **SRE**：**Site Reliability Engineer**，站点可靠性工程师，概念最早由 Google 提出，核心是用软件工程的方法解决运维问题。
2. **Linux 运维**：通用英文为 **Linux Operations Engineer**，也常称 System Administrator（系统管理员），行业内简称运维 / Ops。

------

### 二、核心区别对比



| 维度             | Linux 运维工程师                                             | SRE 工程师                                                   |
| :--------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| **核心目标**     | 保障业务稳定运行，出问题快速修复，完成日常运维事务           | 用工程化手段**系统性提升系统可靠性、可扩展性**，从根源减少故障、降低人工操作 |
| **工作重心**     | 面向「操作执行」：部署、配置、巡检、排障、资源交付、硬件 / 系统维护 | 面向「架构优化」：监控体系设计、容量规划、自动化工具开发、故障根因分析、混沌工程、SLA/SLO 达标 |
| **对待人工操作** | 人工操作是主要工作方式，追求操作准确、高效                   | 认为人工重复劳动（Toil）是负担，目标是**用代码 / 自动化替代人工**，尽量减少手动操作 |
| **核心技能栈**   | Linux 系统、Shell 脚本、常用服务部署（Nginx/MySQL/Redis）、基础监控、硬件排障 | Linux 底层原理 + 编程能力（Go/Python） + 分布式架构 + 可观测性设计 + 容量与性能优化 + 自动化平台开发 |
| **衡量标准**     | 故障响应速度、部署完成率、系统是否正常运行                   | 服务可用性指标（SLO）、故障恢复时长（MTTR）、自动化率、重复劳动占比 |
| **故障处理思路** | 优先快速恢复业务，事后简单复盘                               | 快速恢复 + 深度根因分析（RCA），从架构 / 代码层面彻底规避同类故障 |

------

### 三、通俗总结

- **Linux 运维**：相当于系统的 “维修工 + 管理员”，保证机器、服务能跑起来，坏了能尽快修好。
- **SRE**：相当于系统的 “可靠性架构师”，不光要修问题，还要从设计、工具、架构层面让系统尽量不出问题，同时把运维工作做成自动化、可量化的工程体系。

两者不是完全割裂的关系：SRE 需要扎实的 Linux 运维基础，进阶的运维工程师也会逐步向 SRE 的工程化方向发展。



# 成为 SRE 工程师的完整成长路线

SRE 的成长本质是 **「运维基础 → 工具能力 → 工程能力 → 架构思维」**的四层进阶，核心分水岭是**编程能力**和**可靠性工程思维 **—— 这也是传统运维和 SRE 的核心分界线。

以下是分阶段、可落地的学习路径，贴合从 Linux 运维入门的学习节奏。

------

## 第一阶段：筑牢底层根基（入门必备，3-6 个月）

这是 SRE 的核心底色，决定了你排障、调优的深度上限，也是你当前正在深耕的内容。

### 1. Linux 系统深度掌握

- **核心目标**：不止会敲命令，而是吃透进程、内存、IO、网络四大子系统原理，能从内核层面定位问题
- 学习重点：
  - 进程调度、虚拟内存、文件系统 IO 栈、网络协议栈的底层逻辑
  - 性能分析工具链：`perf`、`strace`、`tcpdump`、`iostat`、`vmstat`、`ss`、`sar`
  - 内核参数调优、系统异常（OOM、IO 夯住、软中断过高）根因排查
- **验收标准**：遇到 CPU 飙升、内存泄漏、磁盘打满、网络丢包等问题，能定位到根因（程序问题 / 内核问题 / 硬件问题），而非只会重启服务

### 2. 网络协议栈深度

- **核心目标**：能独立排查全链路网络问题，理解分布式系统的通信原理
- 学习重点：
  - TCP/IP 协议栈全流程、TCP 状态机、拥塞控制、重传机制
  - HTTP/HTTPS、DNS、负载均衡、防火墙、VPC 网络原理
  - 常见异常排查：TIME_WAIT 堆积、半连接溢出、丢包延迟、跨机房访问慢
- **核心工具**：`tcpdump`、`wireshark`、`mtr`、`ss`、`ip route`

### 3. 跨过第一道分水岭：编程能力

这是运维转 SRE 的最大门槛，也是 SRE “用工程方法解决运维问题” 的基础。

- **入门必学 Python**：快速写自动化脚本、批量处理、监控告警、对接 API，消灭手工重复劳动
- **进阶必学 Go**：云原生生态通用语言，K8s、Prometheus 全系 Go 实现，用于写高性能运维工具、自定义控制器
- **学习重心**：不用钻研业务算法，重点掌握文件处理、网络编程、并发、API 调用、错误处理
- **验收标准**：能独立写出批量运维工具、故障自愈脚本，能看懂主流开源运维项目的核心源码

------

## 第二阶段：掌握 SRE 核心工具栈（初级 SRE 能力，6-9 个月）

核心三大支柱：**可观测性、自动化、容器云原生**，是 SRE 日常工作的核心抓手。

### 1. 可观测性体系（SRE 的眼睛）

- **指标监控**：Prometheus + Grafana，掌握 PromQL、告警规则设计、Exporter 生态、高可用部署
- **日志系统**：ELK/EFK 栈，日志采集、解析、检索、异常告警
- **链路追踪**：SkyWalking/Jaeger，用于分布式故障定位
- **核心要求**：不是 “把工具搭起来”，而是 “设计得好用”—— 指标分层、告警降噪、能通过监控快速缩小故障范围

### 2. 自动化与 CI/CD

- **基础配置自动化**：Ansible 批量部署、配置管理
- **基础设施即代码 (IaC)**：Terraform 实现资源编排，保证多环境一致性
- **CI/CD 流水线**：GitLab CI / Jenkins / ArgoCD，实现代码→构建→测试→部署全流程自动化
- **进阶方向**：用 Python/Go 开发自定义自动化平台，比如资源自助交付、故障自愈平台

### 3. 容器与 Kubernetes（当前 SRE 标配）

- **基础**：Docker 镜像构建、镜像优化、容器底层原理
- **核心**：K8s 核心资源、调度原理、网络模型、存储方案、集群故障排查
- **生态**：Helm、Ingress、HPA、StatefulSet、Operator 模式
- **验收标准**：能独立维护生产级 K8s 集群，快速排查 Pod 异常、网络不通、存储挂载等常见问题

------

## 第三阶段：建立 SRE 核心方法论（区分高级运维和 SRE 的关键，9-12 个月）

这是 SRE 的灵魂：不是堆砌工具，而是用工程化方法**系统性提升服务可靠性**，对应 Google SRE 的核心思想。

### 1. 可靠性度量体系

- 掌握 SLI/SLO/SLA、错误预算的设计与落地
- 学会用错误预算驱动发布决策、工作优先级排序

### 2. 故障全生命周期管理

- 故障分级、应急响应流程、OnCall 机制设计
- **根因分析（RCA）**：用 5Why、鱼骨图等方法挖到本质原因，输出可落地的架构 / 流程改进项，而非停留在 “操作失误” 的表层结论
- 故障自愈设计：通过自动化机制让常见故障自动恢复，减少人工介入

### 3. 容量规划与成本优化

- 容量评估方法、全链路压测、资源水位管控
- 资源利用率优化、服务器 / 云资源成本缩减方案

### 4. 高可用与弹性架构

- 高可用设计原则：冗余、隔离、降级、熔断、限流、重试
- 容灾方案：同城双活、异地灾备、数据一致性策略

### 5. 混沌工程

- 主动注入故障，验证系统容错能力，提前暴露隐患，推动架构优化

------

## 第四阶段：实战沉淀与求职进阶

SRE 是强实战岗位，面试和工作都看重落地成果，而非纸面知识。

1. **搭建个人实验环境**

   用虚拟机 / 云服务器搭完整技术栈：K8s 集群 + Prometheus 监控 + ELK 日志 + CI/CD 流水线；主动模拟故障注入（CPU 打满、磁盘满、网络延迟、服务宕机），练习排障和自愈。

2. **沉淀可量化的项目成果**

   典型项目方向：企业级监控告警体系搭建、自动化运维平台开发、业务容器化改造、混沌工程演练落地。

   简历中必须量化收益：自动化率提升多少、故障平均恢复时长缩短多少、服务可用性从几个 9 提升到几个 9、资源成本节省多少。

3. **积累故障复盘案例**

   每次故障都做完整复盘，整理排查思路、根因分析、改进方案，这是 SRE 面试的核心竞争力。

------

## 关键避坑建议

1. **不要只堆工具**。工具是手段，解决可靠性问题才是目的。很多人学了一堆工具，但说不出 “为什么用这个工具、解决了什么问题、带来了什么收益”。
2. **先打基础再追热点**。不要上来就啃 K8s、混沌工程，Linux 和网络底子不牢，只能停留在 “点点点” 的表面，遇到深层问题就卡壳。
3. **完成思维转变**。从 “出问题快速修好” 转向 “怎么让问题不发生”，从 “手工操作高效完成” 转向 “怎么用代码彻底替代手工”。

### 入门经典资料

- 书籍：《SRE：Google 运维解密》（建立核心认知）、《SRE 工作手册》（落地实践指南）
- 社区：CNCF 云原生全景图、SREcon/KubeCon 会议资料、大厂技术团队博客
