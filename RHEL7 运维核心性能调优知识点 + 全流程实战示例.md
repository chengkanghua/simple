# RHEL7 运维核心性能调优知识点 + 全流程实战示例

基于红帽官方性能调优指南，提炼**生产必用、面试必考**的核心知识点，并通过一个完整的高并发 Web 服务器调优案例串联所有工具和概念。

------

## 一、运维必须掌握的核心知识点

### 1. 性能监控工具体系（排查问题的基础）

| 工具分类           | 核心工具                                            | 生产用途                                    |
| :----------------- | :-------------------------------------------------- | :------------------------------------------ |
| **基础全局监控**   | `vmstat`、`sar`、`top`、`ps`                        | 快速定位 CPU / 内存 / IO / 网络整体瓶颈     |
| **CPU 专项**       | `turbostat`、`numastat`、`numad`、`tuna`、`taskset` | NUMA 架构分析、CPU 亲和性调整、电源状态监控 |
| **存储专项**       | `iostat`、`blktrace`、`btt`、`iowatcher`            | 磁盘 IO 瓶颈定位、IO 堆栈延迟分析           |
| **网络专项**       | `ss`、`ethtool`、`dropwatch`、`ip`                  | 套接字统计、网卡配置、丢包排查              |
| **高级性能分析**   | `perf`、`SystemTap`                                 | 内核级性能剖析、热点函数定位                |
| **自动化调优**     | `tuned`、`tuned-adm`                                | 一键应用生产级调优配置                      |
| **系统级监控框架** | `PCP`                                               | 长期性能数据采集、历史趋势分析              |

vmstat    sar 

```BASH
[root@ansible ~]# vmstat  1 3
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  0      0 1672084   2108 141408    0    0   436    37  316  509  1  4 96  0  0
 0  0      0 1672084   2108 141408    0    0     0     0   86   99  0  0 100  0  0
 0  0      0 1672084   2108 141408    0    0     0     0   92  105  0  0 100  0  0
 procs 进程相关
 r	Running  运行的
 b	Blocked  阻塞的
 
memory 内存相关
swpd	Swap
free  空闲的
buff	Buffer	缓冲区（磁盘读写临时缓存）	2108	几乎没用
cache	Cache	页缓存（文件缓存，你之前学的 PageCache）141408	正常文件缓存

swap 交换分区
si	Swap In	   从 swap 读入内存（换入）	0	无 swap 交换
so	Swap Out	内存写入 swap（换出）	0	内存完全够用
 
io 磁盘 IO 
bi	Block In	从磁盘读数据（块 / 秒）	436 → 0	开机有读，后续无 IO  
bo	Block Out	向磁盘写数据（块 / 秒）	37 → 0	几乎无磁盘写入
以 内存 为中心：
bi = Block In → 数据块 进入内存 ← 从磁盘读取（读磁盘）
bo = Block Out → 数据块 流出内存 → 写入磁盘（写磁盘）



system 系统中断（看内核 / 硬件调度）
in (Interrupt) = 每秒的 硬中断总数 + 软中断总数
cs	Context Switch	每秒进程上下文切换次数	     509 → 105	切换极少，无压力

cpu CPU 使用率（100%= 总和，最关键）
us	User	用户进程 CPU 占比	1/0/0	无程序运行
sy	System	内核 CPU 占比（系统调用、中断）	4/0/0	内核几乎不干活
id	Idle	空闲 CPU 占比	96/100/100	系统极度空闲
wa	Wait	等待 IO 的 CPU 占比	0	无 IO 等待
st	Stolen	虚拟机被偷走的 CPU（物理机 = 0）	0	正常


重要区分（别搞混）
内存 /swap → 单位：KB
磁盘 IO（bi/bo）→ 单位：块（默认 512 字节）

#查看验证 文件系统的ioblack 块是多大
stat /
blockdev --getbsz /dev/sda  ## 查看磁盘逻辑块大小（内核识别的）
blockdev --getpbsz /dev/sda  # 查看磁盘物理扇区大小
#查看磁盘物理扇区大小
fdisk -l /dev/sda | grep -i sector


sar（System Activity Reporter）是 Linux 最全能的系统监控工具，能实时 / 历史查看 CPU、内存、磁盘、网络、进程、中断 所有性能数据
sar -u 1 3	CPU 使用率
sar -r 1 3	内存 / 缓存
sar -d 1 3	磁盘 IO
sar -n DEV 1 3	网卡流量
sar -q 1 3	系统负载
sar -w 1 3	上下文切换


usr	  User	用户进程占用 CPU（业务程序）	越低越好
nice  Nice	低优先级用户进程 CPU 占比,只统计：nice 值为正数（> 0）的进程
		谦让度越高（nice 大） → 越不争 CPU → 优先级越低
		谦让度越低（nice 小） → 越抢 CPU → 优先级越高
sys	  System 	内核占用 CPU（系统调用、中断、驱动）	<30%
iowait	IO Wait	CPU 等待磁盘 IO 的时间	>20% 说明磁盘拥堵
steal	Stolen	虚拟机被宿主机偷走的 CPU	物理机 = 0
idle	Idle	CPU 空闲时间	>80% 说明 CPU 空闲

kbmemfree	空闲物理内存	真正空闲、没被占用的内存	1673652	空闲 1.6GB，非常充足
kbmemused	已用物理内存	进程 + 缓存总共占用的内存	318936	仅用 310MB，极少
%memused	物理内存使用率	已用内存占总内存的百分比	16.01%	内存极其空闲
kbbuffers	缓冲区内存	磁盘读写临时缓冲（对应 vmstat buff）	2108	几乎没用，正常
kbcached	页缓存内存	文件读取缓存（对应 vmstat cache）	125036	正常文件缓存，可回收
kbcommit	已分配虚拟内存	应用程序申请的虚拟内存总和	821424	正常业务占用
%commit	    虚拟内存使用率	虚拟内存占用比例	20.09%	无压力  Commit = 内核承诺分配
kbactive	活跃内存	正在被进程 / 系统使用的内存	49956	活跃内存极少
kbinact	   非活跃内存	闲置缓存，内存不足时可自动释放	123631	可回收缓存充足
kbdirty	   脏页内存	   内存中待写入磁盘的数据	0/40	无数据等待写入磁盘


tps	每秒向磁盘发起的 IO 次数	数值越高 IO 越忙
rd_sec/s	每秒读取扇区数	换算：×512 = 字节数
wr_sec/s	每秒写入扇区数	换算：×512 = 字节数
avgrq-sz	平均 IO 请求大小	-
avgqu-sz	平均 IO 队列长度	越大磁盘越拥堵
await	平均 IO 等待时间（毫秒）	>20ms 磁盘性能差
svctm	平均 IO 服务时间（毫秒）	<5ms 正常
%util	磁盘繁忙率	100% 说明磁盘跑满
----、
字段	完整英文单词	中文释义
tps	       Transactions Per Second	每秒 IO 事务数（IOPS）
rd_sec/s	Read Sectors Per Second	每秒读取磁盘扇区数
wr_sec/s	Write Sectors Per Second	每秒写入磁盘扇区数
avgrq-sz	Average Request Size	平均 IO 请求大小
avgqu-sz	Average Queue Size	平均 IO 等待队列长度
await	Average Wait Time	平均 IO 等待时间（毫秒）
svctm	Service Time	平均 IO 服务时间（毫秒）
%util	Percentage Utilization	磁盘繁忙利用率


-n DEV：监控 网络设备（Network Device） 即网卡流量
字段	   完整英文全称	中文翻译	大白话解释	运维关注点
IFACE	Interface	网卡名称	网卡名（eth0/ens33/lo）	看物理网卡
rxpck/s	Receive Packets Per Second	每秒接收数据包数	收包速度	数值高 = 入站流量大
txpck/s	Transmit Packets Per Second	每秒发送数据包数	发包速度	数值高 = 出站流量大
rxkB/s	Receive KBytes Per Second	每秒接收数据大小（KB）	下载带宽	核心看带宽
txkB/s	Transmit KBytes Per Second	每秒发送数据大小（KB）	上传带宽	核心看带宽
rxcmp/s	Receive Compressed Per Second	每秒接收压缩数据包数	压缩收包	一般为 0
txcmp/s	Transmit Compressed Per Second	每秒发送压缩数据包数	压缩发包	一般为 0
rxmcst/s	Receive Multicast Per Second	每秒接收组播数据包数	组播收包


-q：Queue（队列），查看系统进程队列 + 系统平均负载
字段	     完整英文全称	        中文解释						运维实战关注点	
runq-sz	   Run Queue Size	等待 CPU 的就绪进程队列长度	正常值 < CPU 核心数；持续过高 = CPU 瓶颈
plist-sz   Process List Size	系统总进程 + 线程数量	数值平稳为正常；突增可能是程序 BUG	-
ldavg-1	   Load Average 1 minute	1 分钟系统平均负载	核心指标，反映系统繁忙程度	-
ldavg-5	   Load Average 5 minutes	5 分钟系统平均负载	看短期趋势	-
ldavg-15	Load Average 15 minutes	15 分钟系统平均负载	看长期趋势
blocked	   Blocked Processes	阻塞的进程数  （等待磁盘 IO / 硬件，不可中断）

-w：查看 进程创建 + 上下文切换 统计
字段	  完整英文全称	              通俗解释	        你的数值	      状态解读
proc/s	processes per second	  每秒新建的进程数	   0.00	     没有创建任何新进程，系统非常稳定
cswch/s	context switches per second	每秒上下文切换次数	94~98	切换次数极低，CPU 调度毫无压力



```

top

```bash
字段	完整英文  核心含义	                       你的数值	 状态
us	user	用户态 CPU：业务程序 / 应用使用的 CPU	0.0	无业务运行
sy	system	内核态 CPU：系统调用、驱动、调度使用的 CPU	0.0	内核无操作
ni	nice	低优先级用户进程占用的 CPU	             0.0	无低优先级任务
id	idle	空闲 CPU（最重要）	                   100.0	CPU 完全空闲
wa	iowait	CPU 等待磁盘 IO 的时间	                 0.0	无磁盘 IO 等待
hi	hardware irq	硬中断占用（网卡 / 磁盘硬件通知）	0.0	无硬件中断
si	software irq	软中断占用（内核网络 / 调度）	0.0	无软中断
st	steal time	虚拟机被宿主机偷走的 CPU	           0.0	无 CPU 资源争抢
st = Steal Time（CPU 窃取时间） 你的虚拟机 被物理机 / 其他虚拟机 偷走的 CPU 时间百分比


字段			全称	      通俗解释										你的数值含义
KiB Swap	Swap Space	交换分区（虚拟内存，硬盘模拟内存）	单位：千字节
total	    Total	    交换分区总大小	2097148 KiB = 2GB
free	    Free	     交换分区空闲大小	2GB 完全空闲
used	    Used	     交换分区已使用大小	0，完全没用到
avail Mem	Available Memory	系统真正可用的物理内存（核心）	1776872 KiB ≈ 1.7GB
avail Mem = 空闲free + 可回收的buff/cache 

字段	英文全称	   通俗解释	      核心重点
PID	  Process ID	进程 ID 号	    系统唯一标识，杀进程用这个号
USER	User	运行该进程的用户	看是谁启动的进程
PR	   Priority	进程优先级	      数字越小，优先级越高，越先被 CPU 执行
NI	    Nice	进程谦让值	      微调优先级；负数 = 高优先级，正数 = 低优先级
        PR (Priority)：内核真正用的调度优先级 → 用户不能直接改！
        NI (Nice)：用户能手动调整的谦让值 → 用户可以随便改
        NI 是用来计算 PR 的参数，不是独立的优先级！
VIRT	Virtual Memory	虚拟内存	进程申请的总虚拟内存（不用关注，虚高）
RES	    Resident Memory	常驻物理内存	✅ 最重要！ 进程实际占用的物理内存
SHR	    Shared Memory	共享内存	与其他进程共享的内存（库、共享资源）
S	    Status	进程状态	 常用：R = 运行 S = 睡眠 D=IO 阻塞 Z = 僵尸进程 I = 内核空闲线程，系统自带、待命状态、完全正常
%CPU	CPU Utilization	进程 CPU 使用率		单进程吃 CPU 多少
%MEM	Memory Utilization	进程物理内存使用率	占总物理内存的百分比
TIME+	Time	进程累计占用 CPU 总时间	运行越久，数值越大
COMMAND	Command	进程名称 / 启动命令			看是什么程序（nginx、mysql 等）


#PR NI
PR  NI
20   0  → 默认，没谦让
15  -5  → 手动调了NI（谦让-5），内核算出PR=15（更高优先级）
30  10  → 手动调了NI（谦让10），内核算出PR=30（更低优先级）
#top进去之后常用操作
P → 看谁占 CPU 最高
M → 看谁占内存最高
1 → 看所有 CPU 核心
k → 杀进程
q → 退出
c -> 显示命令的完整路径


#查看系统全量进程的标准命令
ps -ef 
字段	 全称	         通俗解释
UID	  User ID	   运行这个进程的用户（你这里全是 root）
PID	  Process ID	进程唯一 ID 号（1 号、2 号是系统核心进程）
PPID  Parent PID	父进程 ID（子进程由谁启动）
C	   CPU	       进程 CPU 占用百分比（旧版统计方式）
STIME	Start Time	进程启动时间
TTY	   Terminal	   启动进程的终端（? = 无终端，tty1 = 本地物理终端,pts/0 = 远程伪终端  后台 / 内核进程）
TIME	CPU Time   进程累计占用 CPU 的总时间
CMD	   Command	   进程名称 / 启动命令  列带[]代表Linux 内核线程，







```

ss

```bash
ss 是 CentOS 系统自带、替代 netstat 的网络连接查看工具
参数	含义
-t	只看 TCP 连接
-u	只看 UDP 连接
-l	只看 监听中 的端口（服务开的端口）
-n	用数字显示 IP / 端口（不解析域名，速度快）
-p	显示进程名 / PID（必须 root 执行）
-a	显示所有连接（监听 + 已建立）

# 查看所有监听端口
ss -tuln
# 查看监听端口 + 对应进程名 / PID（定位谁占用端口）
ss -tulnp

字段	全称	通俗大白话解释
Netid	Network Type	协议类型：tcp / udp / raw
State	Connection State	连接状态（最重要）：
        ✅ LISTEN：监听中（服务已启动）
        ✅ ESTAB：已建立连接（正在通信）
        ✅ TIME_WAIT：连接关闭中（正常）
		   CLOSE-WAIT	等待程序关闭连接	⚠️ 过多 = 程序异常
		   SYN-RECV   半连接，握手未完成 	⚠️ 过多 = 可能被攻击

Recv-Q	Receive Queue	接收队列：已收到、还没被进程取走的字节数 → 一直很高 = 进程处理不过来
Send-Q	Send Queue	发送队列：发出去、对方没确认的字节数→ 一直很高 = 网络拥堵
Local Address:Port	Local IP:Port	本地 IP + 端口 0.0.0.0:22 = 所有网卡监听 22 端口
Peer Address:Port	Peer IP:Port	对方 IP + 端口 0.0.0.0:* = 监听状态，等待任何人连接 有具体 IP = 正在和对方通信


```

ip

```bash
ip a　　　看 IP 网卡
ip link　 看网卡状态
ip route　看网关路由
ip neigh　看 ARP 同网段 MAC
ip link set eth0 up/down 启停网卡

[root@ansible ~]# ip a show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether(以太网类型) 00:0c:29:85:1b:ae brd ff:ff:ff:ff:ff:ff  # 二层链路 MAC 信息
    inet 10.0.0.6/24 brd 10.0.0.255 scope global noprefixroute eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::20c:29ff:fe85:1bae/64 scope link
       valid_lft forever preferred_lft forev
       
标记	意思
BROADCAST	支持广播
MULTICAST	支持组播
UP	网卡已启用（相当于开机）
LOWER_UP	链路已通（插了网线 / 网络正常连通）
mtu 1500   最大传输单元，默认 1500 字节 Byte，以太网标准。
qdisc  全称：queueing discipline  含义：内核网络队列调度器  作用：网卡发数据包时，排队、限流、调度先后顺序的算法。noqueue = 没有队列

mq    Multi Queue 多队列调度器   多队列分流，多核分别处理网络包，性能更高
state UP   网卡软件层面已启用，正常工作。
group default   网卡归属默认网络分组
qlen 1000    tx queue length 发送队列长度

scope 范围  global	全局地址，可以跨网段通信（正常业务 IP）
			link	只能同网卡内部通，不能外网路由
			host	仅本机自己访问自己
			
valid_lft：还能生效多久
preferred_lft：首选能用多久
			forever 永久静态地址
```









### 2. Tuned 自动化调优（生产首选）

- **核心概念**：静态调优（一次性应用配置）+ 动态调优（根据负载自动调整），通过插件管理 CPU / 内存 / 磁盘 / 网络等子系统

- 生产必用配置集

  - `throughput-performance`：默认服务器配置，优先吞吐量
- `latency-performance`：低延迟场景（数据库、交易系统）
  - `network-latency`：网络低延迟（负载均衡、网关）
  - `network-throughput`：网络高吞吐量（Web 服务器、文件服务器）
  - `virtual-guest`/`virtual-host`：虚拟机 / 宿主机专用
  
  

- 常用命令

  ```
  tuned-adm list          # 查看所有可用配置集
  tuned-adm active        # 查看当前激活的配置集
  tuned-adm profile xxx   # 切换到指定配置集
  tuned-adm recommend     # 获取系统推荐配置集
  ```




#### 一、Tuned 到底修改了系统哪些地方？

按修改优先级和影响范围排序，Tuned 会修改以下 6 大类系统配置：

#### 1. **sysctl 内核参数（最核心，占 80% 调优内容）**

这是 Tuned 最主要的工作，它会批量修改 `/proc/sys/` 下的所有内核参数，也就是你之前手动改的 `/etc/sysctl.d/` 里的所有内容。

#### 二、Tuned 的核心工作原理：插件机制

Tuned 所有功能都通过**插件**实现，每个插件负责管理一个子系统的调优：

| 插件类型     | 负责调优的子系统             | 对应修改的系统位置         |
| :----------- | :--------------------------- | :------------------------- |
| `sysctl`     | 所有内核参数                 | `/proc/sys/`               |
| `cpu`        | CPU 调度、电源管理           | `/sys/devices/system/cpu/` |
| `disk`       | 磁盘 IO 调度、预读、电源管理 | `/sys/block/`              |
| `net`        | 网络接口参数                 | `/sys/class/net/`          |
| `vm`         | 内存管理、巨页               | `/sys/kernel/mm/`          |
| `bootloader` | 内核启动参数                 | `/etc/default/grub`        |
| `script`     | 自定义操作                   | 任意脚本                   |
| `mounts`     | 文件系统挂载选项             | `/etc/fstab`               |

------

#### 三、静态调优 vs 动态调优

Tuned 支持两种调优模式：

#### 1. **静态调优（默认，99% 场景用这个）**

- 切换配置集时**一次性执行所有调优命令**
- 之后不会再自动修改系统配置
- 优点：稳定、可预测，不会出现意外的性能波动
- 缺点：无法根据负载变化自动调整

#### 2. **动态调优（默认关闭）**

- Tuned 守护进程会**定期监控系统负载**（CPU、磁盘、网络使用率）
- 根据负载实时调整调优参数
- 示例：低负载时降低 CPU 频率节能，高负载时切换到性能模式
- 缺点：可能导致性能波动，生产环境不建议开启

**开启动态调优**：

```
# 编辑/etc/tuned/tuned-main.conf
dynamic_tuning=1
update_interval=10  # 每10秒检查一次负载
```

------

#### 四、关键注意事项（生产必知）

#### 1. **Tuned 配置优先级最高**

Tuned 会**定期重新应用**它的配置（默认每 10 秒），所以：

- 如果你手动修改了 sysctl 或 sysfs 参数，Tuned 会在下次检查时**覆盖你的修改**
- 正确做法：**自定义 Tuned 配置集**，把你的修改加进去

#### 2. **如何查看 Tuned 实际修改了什么？**

```bash
# 查看当前激活的配置集
tuned-adm active

# 查看配置集的原始配置文件
cat /usr/lib/tuned/throughput-performance/tuned.conf

# 查看Tuned应用的所有sysctl参数
sysctl -a | grep -E "(vm|net|kernel)" | sort
```

#### 3. **如何完全回滚 Tuned 的所有修改？**

```bash
# 切换到空配置集，恢复系统默认值
tuned-adm off

# 验证：所有Tuned修改的参数都会恢复到系统默认
sysctl vm.swappiness
# 输出：vm.swappiness = 60（系统默认值）
```

------

#### 五、一句话总结

Tuned 就是**红帽官方写好的 "调优脚本集合"**，它把你本来要手动改的几百个内核参数、sysfs 参数、服务配置，打包成几个针对不同场景的配置集，一键应用，避免你手动调优出错。

**生产最佳实践**：99% 的场景直接用 Tuned 官方提供的配置集即可，不要自己手动改参数，除非你明确知道这个参数的影响，并且已经在测试环境验证过。





### 3. CPU 性能调优

- 核心概念

  - NUMA 架构：CPU 访问本地内存比远程内存快 2-3 倍，需保证进程和内存同节点
- 调度策略：`SCHED_OTHER`（默认公平调度）、`SCHED_FIFO`/`SCHED_RR`（实时调度）
  - 中断亲和性：将硬件中断绑定到指定 CPU，避免跨节点调度
  - CPU 隔离：通过`isolcpus`参数隔离 CPU，仅运行指定业务进程
  
  

- **关键参数**：`isolcpus`、`nohz_full`（无空循环内核）、`kernel.sched_rt_period_us`、`kernel.sched_rt_runtime_us`

#### 一. NUMA 架构绑定（生产最常用，性能提升 20-50%）

**适用场景**

- 数据库（MySQL/Redis/PostgreSQL）
- 单进程高 CPU 占用的服务（Nginx/HAProxy/Java 应用）
- 所有双路及以上服务器的核心业务进程

**核心操作**

```BASH
1. 先查看系统 NUMA 状态（必做第一步）
# 1. 查看系统NUMA拓扑
numactl --hardware

# 2. 查看指定进程的NUMA内存分布（排查核心命令）
numastat -p $(pgrep redis-server)

# 3. 查看进程当前运行在哪些CPU上
ps -o pid,psr,comm $(pgrep redis-server)

2. 启动进程时绑定到指定 NUMA 节点（推荐）
这是生产最标准的做法，保证进程的 CPU 和内存永远在同一个节点：
# 绑定到NUMA节点0（使用节点0的所有CPU和内存）
numactl --cpunodebind=0 --membind=0 /usr/bin/redis-server /etc/redis.conf

# 绑定到指定CPU核心（更精细）
numactl --physcpubind=0-7 --membind=0 /usr/bin/mysqld_safe --defaults-file=/etc/my.cnf

3. 运行时绑定已启动的进程
# 方法1：用tuna（最简单，推荐）
tuna --cpus=0-7 --threads=$(pgrep nginx) --move

# 方法2：用taskset（只能绑CPU，不能绑内存，不推荐单独用）
taskset -pc 0-7 $(pgrep nginx)

4. 自动 NUMA 管理（适合多进程混合部署）
# 启动numad守护进程，自动优化所有进程的NUMA亲和性
systemctl enable --now numad

# 查看numad日志
tail -f /var/log/numad.log

```

 **生产踩坑点**

1. **绝对不要让单实例跨 NUMA 节点**：比如 Redis 单实例最多用 1 个 NUMA 节点的 CPU 和内存，多实例就每个节点跑一个
2. **numactl 比 taskset 好**：taskset 只能绑 CPU，不能保证内存分配在同一个节点；numactl 同时绑定 CPU 和内存
3. **K8s 必须开启拓扑管理器**：`--feature-gates=TopologyManager=true`，否则容器会自动跨 NUMA 节点



#### 二. 调度策略调整（适合对延迟敏感的业务）

 **适用场景**

- 低延迟网关、负载均衡器
- 实时数据采集、工业控制
- 高频交易系统

**三种调度策略对比**

| 调度策略      | 优先级    | 特点                                     | 生产用途                 |
| :------------ | :-------- | :--------------------------------------- | :----------------------- |
| `SCHED_OTHER` | 0（默认） | 完全公平调度，按时间片轮转               | 99% 的普通进程           |
| `SCHED_FIFO`  | 1-99      | 实时调度，先入先出，高优先级抢占低优先级 | 对延迟要求极高的核心进程 |
| `SCHED_RR`    | 1-99      | 实时调度，时间片轮转，同优先级轮流执行   | 多个同优先级实时进程     |

**核心操作**

```BASH
1. 查看进程当前的调度策略
# 方法1：用ps
ps -o pid,cls,rtprio,comm $(pgrep haproxy)
# cls列：TS=SCHED_OTHER，FF=SCHED_FIFO，RR=SCHED_RR

# 方法2：用chrt（更详细）
chrt -p $(pgrep haproxy)

2. 修改进程的调度策略和优先级
# 1. 设置为SCHED_FIFO，优先级40（优先级越高数字越大）
chrt -f -p 40 $(pgrep haproxy)

# 2. 设置为SCHED_RR，优先级30
chrt -r -p 30 $(pgrep haproxy)

# 3. 恢复为默认的SCHED_OTHER
chrt -o -p 0 $(pgrep haproxy)

# 4. 启动时直接指定调度策略
chrt -f 40 /usr/bin/haproxy -f /etc/haproxy/haproxy.cfg

3. 调整实时调度全局参数
# 查看当前参数
sysctl kernel.sched_rt_period_us kernel.sched_rt_runtime_us
# 默认值：period=1000000us(1秒)，runtime=950000us(0.95秒)
# 含义：每1秒内，实时进程最多运行0.95秒，留0.05秒给普通进程

# 生产调整（给普通进程留更多时间，防止系统挂死）
sysctl -w kernel.sched_rt_runtime_us=900000

# 永久生效
echo "kernel.sched_rt_runtime_us=900000" >> /etc/sysctl.d/99-cpu-tuning.conf

```

**生产踩坑点**

1. **绝对不要设置优先级 99**：这和内核的 migration、watchdog 线程优先级相同，如果你的进程进入死循环，系统会直接挂死
2. **实时进程不要太多**：所有实时进程加起来的 CPU 使用率不要超过 90%，否则普通进程会饿死
3. **不要给数据库设置实时调度**：数据库有大量 IO 等待，实时调度反而会导致性能下降



#### 三.中断亲和性绑定（解决单 CPU 跑满问题）

 **适用场景**

- 高并发网络服务器（网卡中断占满单个 CPU）
- 高速存储服务器（磁盘 IO 中断占满单个 CPU）
- 所有多队列网卡 / 多队列磁盘

 **核心操作**

```bash
1. 先查看中断分布
# 查看所有中断的CPU分布（重点看eth0、nvme0等设备）
cat /proc/interrupts

# 只看网卡中断
grep eth0 /proc/interrupts

2. 临时绑定中断到指定 CPU
# 1. 计算CPU掩码（二进制转十六进制）
# 绑定到CPU0-3：二进制00001111 → 十六进制0xf
# 绑定到CPU4-7：二进制11110000 → 十六进制0xf0

# 2. 绑定中断号123到CPU0-3
echo 0xf > /proc/irq/123/smp_affinity

# 3. 验证
cat /proc/irq/123/smp_affinity

3. 永久绑定中断（推荐用 tuna）
# 1. 先停止irqbalance（否则会自动调整）
systemctl stop irqbalance
systemctl disable irqbalance

# 2. 用tuna绑定所有eth0中断到CPU4-7
tuna --irqs=eth0* --cpus=4-7 --move

# 3. 验证
tuna --show_irqs | grep eth0

4. 多队列网卡最优配置
# 1. 查看网卡队列数
ethtool -l eth0

# 2. 每个队列绑定到一个独立的CPU（同NUMA节点）
# 比如4个队列，绑定到CPU0-3
echo 1 > /proc/irq/120/smp_affinity  # 队列0→CPU0
echo 2 > /proc/irq/121/smp_affinity  # 队列1→CPU1
echo 4 > /proc/irq/122/smp_affinity  # 队列2→CPU2
echo 8 > /proc/irq/123/smp_affinity  # 队列3→CPU3

```

**生产踩坑点**

1. **中断和业务进程不要绑在同一个 CPU 上**：否则会互相抢占 CPU 资源
2. **多队列网卡不要跨 NUMA 节点绑定**：把网卡中断绑定到和网卡同 NUMA 节点的 CPU 上
3. **不要手动绑定 NVMe 磁盘中断**：RHEL7.5 + 会自动优化 NVMe 中断的亲和性，手动绑定反而可能更差

#### 四、CPU 隔离（适合超低延迟业务）

 **适用场景**

- 高频交易、实时控制系统
- 对抖动（jitter）要求低于 1ms 的业务
- 单进程独占 CPU 核心的场景

**核心操作**

```BASH
1. 配置内核参数隔离 CPU（永久生效，需重启）
编辑/etc/default/grub，在GRUB_CMDLINE_LINUX中添加以下参数：
# 隔离CPU2-7，共6个核心，留CPU0-1给系统
isolcpus=2-7
# 开启无空循环内核，隔离CPU上不触发定时器中断
nohz_full=2-7
# 把RCU回调移到非隔离CPU
rcu_nocbs=2-7

然后重建 GRUB 配置并重启：
# BIOS系统
grub2-mkconfig -o /boot/grub2/grub.cfg

# UEFI系统
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg

# 重启
reboot

2. 验证 CPU 隔离成功
# 方法1：查看内核启动参数
cat /proc/cmdline | grep isolcpus

# 方法2：查看哪些CPU上有内核线程运行
ps -eo pid,psr,comm | awk '$2 >=2 && $2 <=7'
# 正常情况下，隔离CPU上应该只有你手动绑定的进程

3. 把业务进程绑定到隔离 CPU
# 绑定到隔离的CPU2-7
numactl --physcpubind=2-7 /usr/bin/low-latency-app

```

**生产踩坑点**

1. **至少留 2 个 CPU 给系统**：不要把所有 CPU 都隔离，否则系统无法正常运行
2. **隔离 CPU 上不要运行任何其他进程**：包括系统服务、定时任务等
3. **配合实时调度使用**：CPU 隔离 + SCHED_FIFO 调度，可以把抖动降到 100us 以下
4. **不要在虚拟机里用 CPU 隔离**：虚拟机的 CPU 是虚拟的，隔离没有任何效果



#### cpu性能调优总结

**第一步：先做 NUMA 绑定**：成本最低，收益最高，所有双路服务器必做

**第二步：调整中断亲和性**：解决高并发下单个 CPU 被中断占满的问题

**第三步：根据业务选择调度策略**：普通业务用默认，低延迟用 SCHED_FIFO

**第四步：只有极端低延迟场景才做 CPU 隔离**：复杂度高，维护成本大





### 4. 内存性能调优

- 核心概念

  - 巨页技术：`HugeTLB`（静态巨页，需手动预留）、`THP`（透明巨页，内核自动管理），减少 TLB 未命中
  
  理解
  
  ```BASH
  巨页 = 把内存从 “小格子” 换成 “大箱子”，让 CPU 找内存更快、更少迷路。
  
  TLB = Translation Lookaside Buffer
  中文：页表缓冲 / 地址转换后备缓冲器
  大白话：CPU 里用来快速查 “虚拟地址→物理地址” 的小抄本
  
  THP = Transparent Huge Pages
  中文：透明巨页
  大白话：内核自动帮你开的巨页，不用你管
  
  HugeTLB = Huge Page TLB
  中文：静态巨页
  大白话：手动预留、性能最稳的巨页
  
  
  
  ```
  
- 虚拟内存管理：脏页刷盘策略、内存超分配、OOM killer 机制
  
  

- 关键参数

  ```ini
  vm.swappiness=1                # 尽量不使用swap
  vm.dirty_ratio=10              # 脏页占10%时开始后台刷盘
  vm.dirty_background_ratio=5    # 脏页占5%时开始后台刷盘
  vm.max_map_count=262144        # 进程最大内存映射数（ES/Redis必调）
  vm.overcommit_memory=1         # 允许内存超分配
  ```
  

####  一. 巨页技术实战（性能提升 30%-100%）

**核心原理**

CPU 通过 **TLB（翻译后备缓冲器）** 缓存虚拟地址到物理地址的映射。默认 4KB 小页面，大内存应用会产生大量 TLB 未命中，导致 CPU 性能下降。巨页（2MB/1GB）大幅减少 TLB 条目数量，提升内存访问速度。

##### 核心操作

```BASH
1. THP（透明巨页）：内核自动管理，90% 场景首选
**适用场景**：绝大多数通用业务（Nginx、Java 应用、普通数据库），无需应用修改代码。
**不适用场景**：Oracle 数据库、部分老版本 PostgreSQL（官方建议关闭）。

查看当前 THP 状态
# 查看THP开关状态
cat /sys/kernel/mm/transparent_hugepage/enabled
# 输出示例：[always] madvise never → always表示全局开启

# 查看THP碎片整理状态
cat /sys/kernel/mm/transparent_hugepage/defrag
开启 / 关闭 THP
# 1. 临时开启（推荐，先测试）
echo always > /sys/kernel/mm/transparent_hugepage/enabled
echo madvise > /sys/kernel/mm/transparent_hugepage/defrag

# 2. 临时关闭（Oracle等场景）
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/defrag

# 3. 永久生效（写入rc.local，避免被Tuned覆盖）
echo "echo always > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.d/rc.local
echo "echo madvise > /sys/kernel/mm/transparent_hugepage/defrag" >> /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local

验证 THP 生效
# 查看系统已使用的透明巨页数量
grep AnonHugePages /proc/meminfo
# 输出示例：AnonHugePages: 2097152 kB → 已使用2GB透明巨页


2. HugeTLB（静态巨页）：手动预留，极致性能场景
适用场景：对性能要求极高的数据库（Redis、MySQL、Elasticsearch）、KVM 虚拟化、容器大内存应用。
特点：提前预留物理内存，不会被交换到 swap，性能最稳定；但需要应用显式支持。
核心操作

配置 2MB 静态巨页（最常用）
# 1. 临时预留1024个2MB巨页（共2GB）
echo 1024 > /proc/sys/vm/nr_hugepages

# 2. 永久生效（写入sysctl配置）
echo "vm.nr_hugepages=1024" >> /etc/sysctl.d/99-memory-tuning.conf
sysctl -p /etc/sysctl.d/99-memory-tuning.conf

# 3. 验证预留成功
grep HugePages_Total /proc/meminfo
# 输出示例：HugePages_Total: 1024
grep HugePages_Free /proc/meminfo
# 输出示例：HugePages_Free: 1024 → 未使用的巨页数量
配置 1GB 静态巨页（极致性能，需 CPU 支持）
1GB 巨页性能更好，但必须在内核启动时预留，运行时无法调整。
bash
运行
# 1. 编辑GRUB配置，添加内核参数
vim /etc/default/grub
# 在GRUB_CMDLINE_LINUX中添加：
default_hugepagesz=1G hugepagesz=1G hugepages=4
# 含义：默认巨页大小1GB，预留4个1GB巨页（共4GB）

# 2. 重建GRUB配置并重启
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot

# 3. 验证
grep Hugepagesize /proc/meminfo
# 输出示例：Hugepagesize: 1048576 kB → 1GB
让应用使用静态巨页
方法 1：应用原生支持（推荐）
大多数数据库都有专门的巨页配置参数：
bash
运行
# Redis：在redis.conf中添加
hugepage yes

# MySQL：在my.cnf中添加
[mysqld]
large-pages

# Elasticsearch：在jvm.options中添加
-XX:+UseLargePages
方法 2：通过 libhugetlbfs 挂载（通用方法）
bash
运行
# 1. 安装libhugetlbfs
yum install libhugetlbfs

# 2. 挂载巨页文件系统
mkdir -p /mnt/hugepages
mount -t hugetlbfs nodev /mnt/hugepages

# 3. 启动应用时使用巨页
hugetlbfs-run /usr/bin/your-app

为什么 MySQL、 Redis、 Oracle 必须开巨页？
它们全是超级大内存用户
Redis：整库数据放内存，可能 10G、32G、64G
MySQL：Buffer Pool 缓冲池 16G、64G、128G
Oracle：SGA 共享内存区 几十上百 G
数据库 / 缓存都是大内存狂魔，
小页太多 → TLB 装不下 → CPU 白干活 → 性能烂；
巨页一大 → 条目极少 → TLB 全命中 → 速度飞。
```

**巨页生产踩坑点**

1. **静态巨页预留要适量**：预留的巨页会被系统独占，普通进程无法使用。预留过多会导致系统内存不足，预留过少没有效果。建议预留总内存的 30%-50% 给数据库。
2. **THP 和静态巨页可以共存**：系统会优先使用静态巨页，剩余内存使用透明巨页。
3. **容器中使用巨页**：Docker/K8s 需要额外配置才能使用巨页。K8s 需要开启`HugePages`特性门控，并在 Pod 中声明巨页资源。
4. **不要在 NUMA 节点间共享巨页**：静态巨页会平均分配到各个 NUMA 节点，确保应用和巨页在同一个节点。



#### 二、虚拟内存管理实战

##### 1. vm.swappiness：控制 swap 使用倾向

```bash
核心作用：值范围 0-100，值越小越倾向于使用物理内存，值越大越倾向于使用 swap。
核心操作


# 1. 查看当前值
sysctl vm.swappiness
# 默认值：60

# 2. 临时修改为1（生产推荐值）
sysctl -w vm.swappiness=1

# 3. 永久生效
echo "vm.swappiness=1" >> /etc/sysctl.d/99-memory-tuning.conf
sysctl -p /etc/sysctl.d/99-memory-tuning.conf

生产最佳实践
所有服务器都设为 1：而不是 0。设为 0 会导致当物理内存不足时，内核直接触发 OOM 杀死进程，而不是先使用一点 swap。
容器服务器必须设为 1：防止容器内存被换出到 swap，导致性能暴跌。
数据库服务器绝对不要设为 0：数据库 swap 会导致严重的性能问题，但设为 1 可以在极端情况下避免 OOM。

```



##### 2. 脏页刷盘策略：控制内存数据写入磁盘的时机

```bash
脏页 = 内存改了、硬盘还没更的新数据
为了快才攒脏页，太多会卡顿，太少性能差。

核心概念：
vm.dirty_background_ratio：当脏页占总内存的比例达到该值时，内核后台线程开始异步刷盘，不阻塞应用。
vm.dirty_ratio：当脏页占总内存的比例达到该值时，所有写操作会被阻塞，强制同步刷盘。

核心操作
# 1. 查看当前值  数值是百分比的意思
sysctl vm.dirty_ratio vm.dirty_background_ratio
# 默认值：dirty_ratio=20，dirty_background_ratio=10

# 2. 临时修改为生产推荐值
sysctl -w vm.dirty_ratio=10
sysctl -w vm.dirty_background_ratio=5

# 3. 永久生效
echo "vm.dirty_ratio=10" >> /etc/sysctl.d/99-memory-tuning.conf
echo "vm.dirty_background_ratio=5" >> /etc/sysctl.d/99-memory-tuning.conf
sysctl -p /etc/sysctl.d/99-memory-tuning.conf

生产最佳实践
普通服务器：使用默认值即可。
高并发写入服务器（日志、消息队列）：适当调大这两个值（如 dirty_ratio=20，dirty_background_ratio=10），减少刷盘次数，提升写入性能。
数据库服务器：适当调小这两个值（如 dirty_ratio=10，dirty_background_ratio=5），避免突然大量刷盘导致 IO 卡顿。
SSD 服务器：可以调大这两个值，SSD 写入速度快，不会出现明显卡顿。

```



##### 3. vm.max_map_count：进程最大内存映射数

```bash
核心作用：限制单个进程可以拥有的内存映射区域数量。Elasticsearch、Redis 等内存数据库会创建大量内存映射，默认值（65530）不够用。
核心操作

# 1. 查看当前值
sysctl vm.max_map_count
# 默认值：65530

# 2. 临时修改为262144（生产推荐值）
sysctl -w vm.max_map_count=262144

# 3. 永久生效
echo "vm.max_map_count=262144" >> /etc/sysctl.d/99-memory-tuning.conf
sysctl -p /etc/sysctl.d/99-memory-tuning.conf

生产最佳实践
Elasticsearch 服务器必须调大：否则启动会失败，报错 "max virtual memory areas vm.max_map_count [65530] is too low"。
Redis、MongoDB 服务器建议调大：提升大内存使用时的性能。
普通服务器无需修改：默认值足够用。

```





##### 4. vm.overcommit_memory：内存超分配策略

```bash
核心作用：控制内核是否允许申请超过物理内存的内存。
0（默认）：内核会估算可用内存，拒绝明显过量的申请。
1：允许超分配，只要有进程申请就批准。
2：禁止超分配，最多只能申请物理内存 + swap 的总量。
核心操作

# 1. 查看当前值
sysctl vm.overcommit_memory
# 默认值：0

# 2. 临时修改为1（容器/数据库推荐）
sysctl -w vm.overcommit_memory=1

# 3. 永久生效
echo "vm.overcommit_memory=1" >> /etc/sysctl.d/99-memory-tuning.conf
sysctl -p /etc/sysctl.d/99-memory-tuning.conf

生产最佳实践
容器服务器必须设为 1：K8s/Docker 依赖内存超分配来提高资源利用率。
Redis 服务器建议设为 1：Redis fork 时需要申请和当前内存一样大的空间，设为 1 可以避免 fork 失败。
数据库服务器（MySQL/PostgreSQL）建议设为 0：防止超分配导致 OOM。
绝对不要设为 2：会导致很多应用无法正常启动。
```





##### 5. OOM killer 机制：内存不足时的进程杀死策略

```bash
核心原理：当系统内存严重不足时，内核会根据oom_score值杀死进程，值越高越容易被杀死。
核心操作
查看进程的 OOM 分数


# 查看指定进程的oom_score
cat /proc/$(pgrep redis-server)/oom_score

# 查看oom_score_adj（调整因子，范围-1000到1000）
cat /proc/$(pgrep redis-server)/oom_score_adj
# oom_score = 系统计算的基础分 + oom_score_adj

保护重要进程不被 OOM 杀死

# 1. 临时保护（重启失效）
# 设为-1000表示永远不会被OOM杀死
echo -1000 > /proc/$(pgrep mysql)/oom_score_adj

# 2. 永久保护（通过systemd服务）
# 编辑服务文件，添加以下行
[Service]
OOMScoreAdjust=-1000

# 3. 重新加载服务
systemctl daemon-reload
systemctl restart mysql

调整 OOM 杀死优先级

# 让不重要的进程更容易被杀死
echo 500 > /proc/$(pgrep cron)/oom_score_adj

生产踩坑点
不要随便把进程设为 - 1000：如果系统内存不足，内核会杀死其他所有进程，最后可能导致系统挂死。
数据库进程建议设为 - 500：既保护数据库不被轻易杀死，又在极端情况下允许内核杀死它来挽救系统。
容器中的 OOM：容器的 OOM 是由 Cgroups 控制的，和宿主机的 OOM killer 是两个独立的机制。

```

#### 生产内存调优优先级总结

1. **第一步：开启 THP**：成本最低，收益最高，所有服务器必做。
2. **第二步：调整 vm.swappiness=1**：避免不必要的 swap 使用，提升性能。
3. **第三步：根据业务调整脏页刷盘策略**：高写入调大，数据库调小。
4. **第四步：数据库服务器配置静态巨页**：获得极致性能。
5. **第五步：调整 OOM 优先级**：保护核心业务进程。

不同应用的内存调优模板

| 应用类型      | vm.swappiness | vm.dirty_ratio | vm.dirty_background_ratio | vm.max_map_count | vm.overcommit_memory | 巨页配置     |
| :------------ | :------------ | :------------- | :------------------------ | :--------------- | :------------------- | :----------- |
| Nginx/HAProxy | 1             | 10             | 5                         | 65530            | 0                    | THP 开启     |
| Redis         | 1             | 10             | 5                         | 262144           | 1                    | 静态巨页 2MB |
| MySQL         | 1             | 10             | 5                         | 65530            | 0                    | 静态巨页 2MB |
| Elasticsearch | 1             | 20             | 10                        | 262144           | 0                    | THP 开启     |
| K8s 节点      | 1             | 20             | 10                        | 262144           | 1                    | THP 开启     |

小笔记

```BASH
Linux 默认内存页 = 4KB ✅
和文件系统 block 4KB 是同一个大小逻辑 ✅
系统把内存切成无数个 4KB 小页 ✅
巨页 = 把很多 4KB 拼成 2MB / 1GB 大页 ✅
目的就是：减少地址查找，更快访问内存 ✅
Redis/ES/Oracle 最终都是调用内核去用内存 ✅
TLB = CPU 里的 “虚拟地址→物理地址” 小抄本 ✅
虚拟地址 <-> 物理地址 由 Linux 内核管理 ✅

内存页（Page）：内存管理的最小单位
Block：磁盘文件系统的最小单位

程序用虚拟地址  ->实际数据在物理地址
CPU 必须做转换
巨页的作用：
让 CPU 转换地址更快、更少查表、更少卡顿。

虚拟地址 → 物理地址，为什么要这么设计？
核心原因只有 3 个：
① 让每个程序以为自己独占整台内存 ,程序以为自己从 0 开始用，互不干扰。
→ 安全、隔离、稳定
② 让程序不用关心物理内存长啥样,程序只管写虚拟地址，内核帮你映射。
→ 程序简单、好开发、可移植
③ 可以用 swap（交换分区）,内核可以把页换入换出。
→ 内存不够也能跑

虚拟地址 ↔ 物理地址 谁维护？
Linux 内核 + CPU 硬件共同维护
内核：负责建立映射表（页表）
CPU：负责高速缓存这个表（TLB）

精简大白话总结
内存默认切成 4KB 小页
程序用虚拟地址，CPU 要转成物理地址
TLB 是 CPU 里的地址快查表
小页太多 → TLB 装不下 → 变慢
巨页 = 合并成 2MB/1GB 大页
大页少 → TLB 装得下 → 变快
虚拟地址是为了隔离、安全、方便
映射关系由内核 + CPU 共同维护
```









### 5. 存储与文件系统调优

- 核心概念

  - I/O 调度器：`deadline`（默认，适合大多数场景）、`cfq`（SATA 磁盘）、`noop`（SSD / 虚拟磁盘）
  
  ```BASH
   Input / Output
   In → 进硬盘 = 写
  Out → 出硬盘 = 读
  
  IO 调度器 = 磁盘交通警察
  Input = 写（进硬盘）
  Output = 读（出硬盘）
  机械盘用 deadline
  SSD / 云盘用 noop
   
  ```
  
- XFS 调优：默认文件系统，支持大文件、高并发，格式化时优化条带对齐
  - 挂载选项：`noatime`（禁用访问时间更新）、`inode64`（大于 1TB 文件系统必开）
  
  

- 关键参数

  ```bash
  echo deadline > /sys/block/sda/queue/scheduler  # 切换调度器
  echo 4096 > /sys/block/sda/queue/read_ahead_kb  # 增大预读值
  ```
  



#### 一、I/O 调度器调优（最基础、最常用）

核心原理

I/O 调度器决定了磁盘读写请求的执行顺序和优先级，不同存储介质的物理特性不同，需要匹配不同的调度器才能获得最佳性能。

 **三种调度器适用场景**

| 调度器     | 适用存储                      | 核心特点                                           | 生产用途                             |
| ---------- | ----------------------------- | -------------------------------------------------- | ------------------------------------ |
| `deadline` | 机械硬盘 (HDD)、SAS/SATA 磁盘 | 按请求截止时间排序，优先处理读请求，保证低延迟     | 90% 的服务器场景，数据库、文件服务器 |
| `cfq`      | 普通 SATA 机械硬盘            | 完全公平队列，按进程分配 I/O 时间片                | 桌面系统、多用户共享的 SATA 磁盘     |
| `noop`     | SSD、NVMe、虚拟磁盘           | 简单 FIFO（first In first out） 队列，不做复杂排序 | 所有 SSD/NVMe、KVM 虚拟机、云服务器  |

核心操作

```bash
查看当前磁盘的调度器
# 查看所有磁盘的调度器
cat /sys/block/*/queue/scheduler

# 查看指定磁盘的调度器（比如sda）
cat /sys/block/sda/queue/scheduler
# 输出示例：noop deadline [cfq] → 中括号里的是当前使用的调度器


临时切换调度器（立即生效，重启失效）
# 切换sda为deadline（推荐HDD使用）
echo deadline > /sys/block/sda/queue/scheduler

# 切换sdb为noop（推荐SSD/NVMe使用）
echo noop > /sys/block/sdb/queue/scheduler

# 切换所有磁盘为deadline（批量操作）
for dev in /sys/block/sd*; do echo deadline > $dev/queue/scheduler; done


永久切换调度器（重启生效）
方法 1：通过 Tuned 配置（推荐，不会被覆盖）
# 创建自定义Tuned配置集
mkdir -p /etc/tuned/io-tuning
cat > /etc/tuned/io-tuning/tuned.conf << EOF
[main]
include=throughput-performance

[disk]
elevator=deadline
EOF

# 激活配置集
tuned-adm profile io-tuning

方法 2：通过 GRUB 内核参数（全局生效）
# 编辑GRUB配置
vim /etc/default/grub
# 在GRUB_CMDLINE_LINUX中添加：
elevator=deadline

# 重建GRUB配置
grub2-mkconfig -o /boot/grub2/grub.cfg

# 重启生效
reboot

验证调度器永久生效
# 重启后查看
cat /sys/block/sda/queue/scheduler
# 输出示例：noop [deadline] cfq → 已切换为deadline


 生产踩坑点
SSD/NVMe 绝对不要用 deadline/cfq：SSD 没有寻道时间，复杂的调度算法只会增加 CPU 开销，用 noop 性能最好。
云服务器默认就是 noop：阿里云、腾讯云等云服务器的虚拟磁盘已经在底层做了调度，不需要再改。
不要给 RAID 控制器用 cfq：硬件 RAID 控制器会自己调度 I/O，用 deadline 或 noop 即可。
Tuned 会覆盖手动修改：如果开启了 Tuned，一定要通过 Tuned 修改调度器，否则会被定期覆盖。

```

#### 二、XFS 文件系统调优（RHEL7 默认文件系统）

 **核心原理**

XFS 是 RHEL7 默认的文件系统，专为大文件、高并发设计。格式化时的参数决定了文件系统的基础性能，格式化后无法修改，必须提前规划。

------

格式化时优化条带对齐（性能提升 20%-50%）

**条带对齐是 XFS 调优最重要的一步**，如果不对齐，每次 I/O 都会跨多个 RAID 条带，性能直接减半。

 **如何计算条带参数**

- **条带单元 (sunit)**：RAID 的条带大小（单位：512 字节块）
- **条带宽度 (swidth)**：RAID 数据盘数量 × 条带单元

**示例**：

- RAID5，3 块数据盘，条带大小 64KB
- sunit = 64KB / 512B = 128
- swidth = 3 × 128 = 384

```bash
格式化命令（生产标准写法）
# 普通单盘格式化（无RAID）
mkfs.xfs -f /dev/sdb1

# RAID5格式化（3数据盘，64KB条带）
mkfs.xfs -f -d su=64k,sw=3 /dev/md0

# RAID10格式化（4数据盘，64KB条带）
mkfs.xfs -f -d su=64k,sw=4 /dev/md0

# 大于1TB的文件系统，必须加inode64参数
mkfs.xfs -f -i size=512 -d su=64k,sw=3 /dev/md0

验证格式化参数
# 查看XFS文件系统参数
xfs_info /dev/sdb1
# 输出关键行：
# data     = bsize=4096 blocks=26214400, imaxpct=25
#          = sunit=128 swidth=384
# naming   =version 2 bsize=4096 ascii-ci=0 ftype=1
# log      =internal bsize=4096 blocks=12800, version=2
#          = sunit=128 swidth=384 lazy-count=1
# realtime =none extsz=4096 blocks=0, rtextents=0

注意： 
su = RAID 条带大小（看你 RAID 配置）
sw = 数据盘数量（不算校验盘、热备盘）
格式化时必须写对，否则性能暴跌
示例：
RAID5，8 块数据盘，条带 64k
mkfs.xfs -f -d su=64k,sw=7 /dev/sdb1

RAID10，4 盘，条带 128k
mkfs.xfs -f -d su=128k,sw=2 /dev/sdb1

RAID0，3 盘，条带 256k
mkfs.xfs -f -d su=256k,sw=3 /dev/sdb1




```

挂载选项调优（格式化后可修改）

**生产必用挂载选项**

| 选项            | 作用                                             | 适用场景                                  |
| --------------- | ------------------------------------------------ | ----------------------------------------- |
| `noatime`       | 禁用文件访问时间更新，减少写入 IO                | 所有场景                                  |
| `nodiratime`    | 禁用目录访问时间更新，减少写入 IO                | 所有场景（noatime 会自动包含 nodiratime） |
| `inode64`       | 允许 inode 分配在整个磁盘，大于 1TB 文件系统必开 | 大于 1TB 的文件系统                       |
| `logbufs=8`     | 增加日志缓冲区数量，提高写入性能                 | 高并发写入场景                            |
| `logbsize=256k` | 增大日志缓冲区大小，提高写入性能                 | 高并发写入场景                            |

```BASH
临时挂载测试
# 挂载sdb1到/data，使用生产推荐选项
mount -o noatime,inode64,logbufs=8,logbsize=256k /dev/sdb1 /data

永久挂载（写入 /etc/fstab）
# 编辑fstab
vim /etc/fstab
# 添加以下行：
/dev/sdb1 /data xfs defaults,noatime,inode64,logbufs=8,logbsize=256k 0 0

# 验证fstab配置（非常重要！避免重启无法挂载）
mount -a

# 验证挂载选项
mount | grep /data
# 输出示例：/dev/sdb1 on /data type xfs (rw,noatime,inode64,logbufs=8,logbsize=262144)

产踩坑点
条带参数格式化后无法修改：格式化前一定要计算正确，否则只能重新格式化。
大于 1TB 的文件系统必须加 inode64：否则 inode 只能分配在磁盘前 1TB，导致磁盘还有空间但无法创建文件。
noatime 不会影响 mtime 和 ctime：只会禁用访问时间 atime，修改时间 mtime 和状态时间 ctime 不受影响，不影响备份、监控等功能。
XFS 不支持缩小：只能扩大，不能缩小，分区时要规划好大小。



```

#### 三、磁盘预读值调优（read_ahead_kb）

 **核心原理**

预读是指系统提前把磁盘上连续的数据读到内存中，当程序需要时可以直接从内存获取，大幅提高顺序读性能。

 核心操作

```BASH
查看当前预读值
# 查看sda的预读值（单位：KB）
cat /sys/block/sda/queue/read_ahead_kb
# 默认值：128 KB

临时修改预读值（立即生效，重启失效）
# 普通HDD：设置为1024 KB
echo 1024 > /sys/block/sda/queue/read_ahead_kb

# RAID阵列/SSD：设置为4096 KB（推荐）
echo 4096 > /sys/block/sdb/queue/read_ahead_kb

# 批量修改所有磁盘
for dev in /sys/block/sd*; do echo 4096 > $dev/queue/read_ahead_kb; done

永久修改预读值（通过 Tuned，推荐）
# 编辑之前创建的自定义Tuned配置
vim /etc/tuned/io-tuning/tuned.conf
# 添加以下内容：
[disk]
readahead=4096

# 重新激活配置集
tuned-adm profile io-tuning

验证永久生效
# 重启后查看
cat /sys/block/sda/queue/read_ahead_kb
# 输出：4096

```



**生产最佳实践**

- **普通 HDD**：1024-2048 KB
- **RAID 阵列**：4096-8192 KB
- **SSD/NVMe**：4096 KB（太大反而会增加 CPU 开销）
- **随机读为主的场景（数据库）**：不要调太大，1024 KB 即可
- **顺序读为主的场景（文件服务器、视频服务器）**：可以调到 8192 KB 甚至更大



#### 生产存储调优优先级总结

1. 第一步：选择正确的 I/O 调度器
   - HDD 用 deadline，SSD/NVMe 用 noop
2. 第二步：格式化 XFS 时优化条带对齐
   - 这是性能影响最大的一步，格式化后无法修改
3. 第三步：挂载时添加 noatime 和 inode64 选项
   - 零成本提升性能，所有场景必用
4. 第四步：根据场景调整预读值
   - 顺序读调大，随机读调小







### 6. 网络性能调优

- 核心概念

  - RSS（接收端扩展）：硬件多队列，将网络流量分发到多个 CPU
  - RPS/RFS：软件级流量分发，提高 CPU 缓存命中率
  - 中断合并：减少中断次数，提高吞吐量
  
- 关键参数

  ```ini
  net.core.rmem_default=262144    # 默认接收缓冲区
  net.core.rmem_max=16777216      # 最大接收缓冲区
  net.core.dev_weight=64           # 单次中断处理的数据包数
  net.core.busy_poll=50            # 低延迟网络轮询
  ```




#### 1. RSS  **Receive Side Scaling**（接收端缩放 / 接收方扩展）：硬件多队列，性能提升 50%-200%

**核心原理**：现代网卡支持多个接收队列，每个队列可以绑定到不同的 CPU 核心，让多个 CPU 同时处理网络流量，解决单 CPU 被中断占满的问题。**Receive Side Scaling**（接收端缩放 / 接收方扩展）

**适用场景**：所有千兆及以上网卡、高并发网络服务器（Nginx/HAProxy/ 网关）。

**核心操作**

```BASH
第一步：查看网卡是否支持 RSS 及队列数

# 查看网卡最大队列数和当前队列数
ethtool -l eth0

# 输出示例：
# Channel parameters for eth0:
# Pre-set maximums:
# RX:		8
# TX:		8
# Other:		1
# Combined:	8
# Current hardware settings:
# RX:		8
# TX:		8
# Other:		1
# Combined:	8
Combined: 8表示网卡支持 8 个多队列，每个队列可以独立产生中断。


第二步：查看当前中断分布

# 查看网卡中断的CPU分布
grep eth0 /proc/interrupts

# 输出示例：
#  32:   123456      0      0      0      0      0      0      0  IR-PCI-MSI  eth0-rx-0
#  33:        0  234567      0      0      0      0      0      0  IR-PCI-MSI  eth0-rx-1
#  34:        0      0  345678      0      0      0      0      0  IR-PCI-MSI  eth0-rx-2
#  ...
正常情况下，每个队列的中断应该分布在不同的 CPU 上。
第三步：手动绑定中断到指定 CPU（生产标准做法）

先停止 irqbalance（否则会自动调整）：
systemctl stop irqbalance
systemctl disable irqbalance

方法 1：手动绑定（最精确）
# 每个队列绑定到一个独立的CPU（同NUMA节点）
# 队列0→CPU0，队列1→CPU1，以此类推
echo 1 > /proc/irq/32/smp_affinity  # 二进制00000001→CPU0
echo 2 > /proc/irq/33/smp_affinity  # 二进制00000010→CPU1
echo 4 > /proc/irq/34/smp_affinity  # 二进制00000100→CPU2
echo 8 > /proc/irq/35/smp_affinity  # 二进制00001000→CPU3
echo 16 > /proc/irq/36/smp_affinity # 二进制00010000→CPU4
echo 32 > /proc/irq/37/smp_affinity # 二进制00100000→CPU5
echo 64 > /proc/irq/38/smp_affinity # 二进制01000000→CPU6
echo 128 > /proc/irq/39/smp_affinity# 二进制10000000→CPU7

方法 2：用 tuna 工具一键绑定（推荐）
# 安装tuna
yum install tuna

# 把所有eth0的接收中断绑定到CPU0-7
tuna --irqs=eth0-rx* --cpus=0-7 --move

第四步：验证绑定成功
# 查看中断亲和性
cat /proc/irq/32/smp_affinity
# 输出：00000001 → 已绑定到CPU0

# 压测后查看中断分布，应该每个CPU都有流量
grep eth0 /proc/interrupts


生产踩坑点
中断必须绑定到和网卡同 NUMA 节点的 CPU：

# 查看网卡所在的NUMA节点
cat /sys/class/net/eth0/device/numa_node
# 输出0表示在Node0，中断只能绑到Node0的CPU上
中断和业务进程不要绑在同一个 CPU 上：否则会互相抢占 CPU 资源。
不要跨 NUMA 节点绑定中断：会导致远程内存访问，性能暴跌 50% 以上。

```



#### 2. RPS/RFS：软件级流量分发，提升 CPU 缓存命中率

**核心原理**：

- **RPS**  Receive Packet Steering**（接收数据包引导 / 转向））**：当网卡不支持 RSS 时，软件将流量分发到多个 CPU；配合 RSS 使用时，可以进一步平衡负载。

- **RFS**  Receive Flow Steering（接收流引导 / 转向）

  ：在 RPS 基础上，将同一个 TCP 连接的流量分发到同一个 CPU，大幅提高 CPU 缓存命中率。

  适用场景

  ：不支持 RSS 的老网卡、高并发短连接场景（Web/API）。



**核心操作**

```BASH
开启 RPS

# 查看网卡有多少个接收队列
ls /sys/class/net/eth0/queues/rx-*

# 给每个队列配置RPS CPU掩码（这里绑定到CPU0-7）
for queue in /sys/class/net/eth0/queues/rx-*; do
    echo ff > $queue/rps_cpus  # ff是二进制11111111，对应CPU0-7
done

开启 RFS（必须配合 RPS 使用）
# 全局流表大小（生产推荐32768）
sysctl -w net.core.rps_sock_flow_entries=32768

# 每个队列的流表大小（等于全局值除以队列数）
for queue in /sys/class/net/eth0/queues/rx-*; do
    echo 4096 > $queue/rps_flow_cnt  # 32768 / 8 = 4096
done

永久生效（写入 rc.local）
echo "for queue in /sys/class/net/eth0/queues/rx-*; do echo ff > \$queue/rps_cpus; done" >> /etc/rc.d/rc.local
echo "sysctl -w net.core.rps_sock_flow_entries=32768" >> /etc/rc.d/rc.local
echo "for queue in /sys/class/net/eth0/queues/rx-*; do echo 4096 > \$queue/rps_flow_cnt; done" >> /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local

验证生效
# 查看RPS配置
cat /sys/class/net/eth0/queues/rx-0/rps_cpus
# 输出：ff → 已开启

# 查看RFS配置
sysctl net.core.rps_sock_flow_entries
# 输出：32768 → 已开启

生产踩坑点
RPS 不要跨 NUMA 节点：CPU 掩码只能包含和网卡同 NUMA 节点的 CPU。
开启 RPS 后必须开启 RFS：否则同一个连接的流量会在不同 CPU 间跳转，缓存命中率极低。
已经开启 RSS 的网卡，RPS 可以作为补充：但不要完全依赖 RPS，硬件 RSS 性能远好于软件 RPS。

```



#### 3. 中断合并：平衡吞吐量和延迟

**核心原理**：网卡收到多个数据包后，合并成一个中断发送给 CPU，减少中断次数，提高吞吐量，但会增加一点延迟。

**适用场景**：高吞吐量场景（文件服务器、视频服务器）；低延迟场景（高频交易）需要关闭。



 **核心操作**

```bash
查看当前中断合并设置

ethtool -c eth0
# 输出关键行：
# rx-usecs: 100        # 接收中断延迟（微秒）
# tx-usecs: 100        # 发送中断延迟（微秒）
# adaptive-rx: on      # 自适应接收中断合并
# adaptive-tx: on      # 自适应发送中断合并

调整中断合并策略
# 高吞吐量场景：增大延迟，减少中断次数
ethtool -C eth0 rx-usecs 200 tx-usecs 200

# 低延迟场景：关闭中断合并，最小化延迟
ethtool -C eth0 rx-usecs 0 tx-usecs 0

# 开启自适应中断合并（推荐大多数场景）
ethtool -C eth0 adaptive-rx on adaptive-tx on

永久生效（写入 rc.local）
echo "ethtool -C eth0 adaptive-rx on adaptive-tx on" >> /etc/rc.d/rc.local

生产踩坑点
低延迟场景必须关闭中断合并：否则会导致延迟抖动增大。
高吞吐量场景可以适当增大 rx-usecs：但不要超过 500 微秒，否则会导致缓冲区溢出丢包。
自适应中断合并是最佳折中：大多数场景下开启即可，系统会自动根据负载调整。

```



#### 关键内核参数调优

所有参数均为**生产验证过的推荐值**，临时修改立即生效，永久修改写入 sysctl 配置文件。

```bash
1. 网络缓冲区参数
# 查看当前值
sysctl net.core.rmem_default net.core.rmem_max net.core.wmem_default net.core.wmem_max

# 临时修改（生产推荐值）
sysctl -w net.core.rmem_default=262144    # 默认接收缓冲区：256KB
sysctl -w net.core.rmem_max=16777216      # 最大接收缓冲区：16MB
sysctl -w net.core.wmem_default=262144    # 默认发送缓冲区：256KB
sysctl -w net.core.wmem_max=16777216      # 最大发送缓冲区：16MB

# 永久生效
cat >> /etc/sysctl.d/99-network-tuning.conf << EOF
net.core.rmem_default=262144
net.core.rmem_max=16777216
net.core.wmem_default=262144
net.core.wmem_max=16777216
EOF

# 应用配置
sysctl -p /etc/sysctl.d/99-network-tuning.conf

2. 中断处理参数
# 单次中断处理的最大数据包数（默认64，高吞吐量调至128）
sysctl -w net.core.dev_weight=128

# 低延迟网络轮询（单位：微秒，推荐50）
sysctl -w net.core.busy_poll=50
sysctl -w net.core.busy_read=50

# 永久生效
cat >> /etc/sysctl.d/99-network-tuning.conf << EOF
net.core.dev_weight=128
net.core.busy_poll=50
net.core.busy_read=50
EOF

3. TCP 连接参数（高并发必调）
# 临时修改
sysctl -w net.ipv4.tcp_syncookies=1              # 开启SYN洪水保护
sysctl -w net.ipv4.tcp_tw_reuse=1                # 允许TIME_WAIT套接字重用
sysctl -w net.ipv4.tcp_fin_timeout=30            # 缩短FIN_WAIT2超时时间
sysctl -w net.ipv4.tcp_max_syn_backlog=8192      # 增大SYN队列长度
sysctl -w net.core.somaxconn=65535               # 增大监听队列长度

# 永久生效
cat >> /etc/sysctl.d/99-network-tuning.conf << EOF
net.ipv4.tcp_syncookies=1
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_fin_timeout=30
net.ipv4.tcp_max_syn_backlog=8192
net.core.somaxconn=65535
EOF


```

**生产调优优先级总结**
第一步：开启并配置 RSS：硬件多队列，成本最低，收益最大，所有千兆及以上网卡必做。
第二步：配置 RPS/RFS：配合 RSS 使用，提高 CPU 缓存命中率，高并发短连接场景必做。
第三步：调整中断合并策略：高吞吐量开启自适应，低延迟关闭。
第四步：调整内核网络缓冲区和 TCP 参数：解决连接数和缓冲区瓶颈。

**不同应用的网络调优模板**

| 应用类型      | RSS                        | RPS/RFS | 中断合并             | 核心参数                             |
| ------------- | -------------------------- | ------- | -------------------- | ------------------------------------ |
| Nginx/HAProxy | 开启，每个队列绑一个 CPU   | 开启    | 自适应               | dev_weight=128, somaxconn=65535      |
| Redis         | 开启，绑到同 NUMA 节点 CPU | 关闭    | 关闭（低延迟）       | busy_poll=50, rmem_max=16M           |
| MySQL         | 开启，绑到同 NUMA 节点 CPU | 关闭    | 自适应               | rmem_default=256K, wmem_default=256K |
| 文件服务器    | 开启                       | 开启    | 开启（rx-usecs=200） | rmem_max=32M, wmem_max=32M           |
| 高频交易      | 开启，绑到隔离 CPU         | 关闭    | 完全关闭             | busy_poll=10, dev_weight=64          |





## 二、全流程实战示例：高并发 Nginx 服务器性能调优

### 场景描述

某生产环境 Nginx 服务器（4 核 8G，2 个 NUMA 节点）出现 ** 用户访问延迟高、CPU 使用率 80%+、IO 等待 20%+** 问题，QPS 仅能达到 2000，远低于预期。

**QPS = Queries Per Second** **每秒查询率 / 每秒请求数**

### 步骤 1：初步全局排查（定位瓶颈方向）

```bash
# 1. 查看系统整体状态（每秒刷新一次）
vmstat 1
# 重点关注：us(用户CPU)、sy(系统CPU)、wa(IO等待)、id(空闲CPU)
# 输出示例：us=65, sy=20, wa=15, id=0 → CPU和IO双瓶颈

# 2. 查看进程CPU占用
top -c
# 发现nginx进程占用70% CPU，kswapd0进程占用10% → 内存可能不足

# 3. 查看磁盘IO状态
iostat -x 1
# 重点关注：%util(磁盘利用率)、await(平均IO等待时间)
# 输出示例：sda %util=85%, await=40ms → 磁盘IO瓶颈

# 4. 查看网络连接状态
ss -s
# 输出示例：TCP: 15000 established → 高并发连接正常
```

### 步骤 2：深入专项分析（定位具体问题）

#### 2.1 CPU 与 NUMA 分析



```bash
# 1. 查看NUMA拓扑
numactl --hardware
# 输出：2个节点，node0(CPU0-1, 4G内存)，node1(CPU2-3, 4G内存)

# 2. 查看进程NUMA内存分配
numastat -p $(pgrep nginx)
# 输出：nginx进程60%内存分配在node1，但进程运行在node0 → NUMA不平衡

# 3. 查看CPU电源状态
turbostat -i 5
# 输出：CPU频繁进入C3/C6状态 → 电源管理导致延迟增加

# 4. 查看中断分布
cat /proc/interrupts | grep eth0
# 输出：eth0中断全部由CPU0处理 → 中断不均衡
```

#### 2.2 内存分析



```bash
# 1. 查看内存使用
cat /proc/meminfo | grep -E "HugePages|AnonHugePages"
# 输出：AnonHugePages=0 → 透明巨页未启用

# 2. 查看虚拟内存参数
sysctl vm.dirty_ratio vm.dirty_background_ratio
# 输出：vm.dirty_ratio=20, vm.dirty_background_ratio=10 → 脏页刷盘不及时

```

#### 2.3 存储分析



```bash
# 1. 查看IO调度器
cat /sys/block/sda/queue/scheduler
# 输出：[cfq] deadline noop → 使用了不适合SSD的cfq调度器

# 2. 查看预读值
cat /sys/block/sda/queue/read_ahead_kb
# 输出：128 → 预读值太小，顺序读性能差
```

#### 2.4 网络分析



```bash
# 1. 查看网卡队列
ethtool -l eth0
# 输出：RX queues: 1 → 单队列网卡，无法利用多核

# 2. 查看套接字缓冲区
sysctl net.core.rmem_default net.core.rmem_max
# 输出：默认值太小，高并发下容易丢包

```

### 步骤 3：实施调优（按优先级排序）

#### 3.1 应用 Tuned 基础配置



```bash
# 切换到网络高吞吐量配置集
tuned-adm profile network-throughput
# 验证：tuned-adm active
```

#### 3.2 CPU 与 NUMA 调优



```bash
# 1. 绑定Nginx进程到node0的CPU0-1
tuna --cpus=0,1 --threads=nginx* --move

# 2. 将eth0中断绑定到node1的CPU2-3
tuna --irqs=eth0* --cpus=2,3 --move

# 3. 设置CPU电源策略为性能模式
x86_energy_perf_policy performance

# 4. 禁用不必要的C状态（临时生效）
echo 1 > /sys/devices/system/cpu/cpu*/cpufreq/performance
```

#### 3.3 内存调优



```bash
# 1. 启用透明巨页
echo always > /sys/kernel/mm/transparent_hugepage/enabled

# 2. 调整脏页刷盘参数
sysctl -w vm.dirty_ratio=10
sysctl -w vm.dirty_background_ratio=5

# 3. 永久写入配置
echo "vm.dirty_ratio=10" >> /etc/sysctl.d/99-tuning.conf
echo "vm.dirty_background_ratio=5" >> /etc/sysctl.d/99-tuning.conf
sysctl -p /etc/sysctl.d/99-tuning.conf
```

#### 3.4 存储调优



```bash
# 1. 切换IO调度器为deadline
echo deadline > /sys/block/sda/queue/scheduler

# 2. 增大预读值到4MB
echo 4096 > /sys/block/sda/queue/read_ahead_kb

# 3. 重新挂载根分区，启用noatime
mount -o remount,noatime /
# 永久生效：编辑/etc/fstab，在defaults后添加,noatime
```

#### 3.5 网络调优



```bash
# 查看网卡当前队列数   2015之后的机器默认是开启了rss的
ethtool -l eth0  # Combined值大于 1 → 已经开启了 RSS
如果没开启，手动开启 RSS（物理机必做）
# 把队列数设置为CPU核心数（这里以8核为例）
ethtool -L eth0 combined 8
# 验证
ethtool -l eth0 | grep Combined



# 1. 启用RPS（软件多队列）
echo f > /sys/class/net/eth0/queues/rx-0/rps_cpus  # f=二进制1111，使用所有CPU

# 2. 启用RFS（接收流转向）
sysctl -w net.core.rps_sock_flow_entries=32768
echo 2048 > /sys/class/net/eth0/queues/rx-0/rps_flow_cnt

# 3. 调整套接字缓冲区
sysctl -w net.core.rmem_default=262144
sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_default=262144
sysctl -w net.core.wmem_max=16777216

# 4. 永久写入配置
echo "net.core.rps_sock_flow_entries=32768" >> /etc/sysctl.d/99-tuning.conf
echo "net.core.rmem_default=262144" >> /etc/sysctl.d/99-tuning.conf
sysctl -p /etc/sysctl.d/99-tuning.conf

```

### 步骤 4：效果验证



```bash
# 1. 用ab工具压测
ab -n 100000 -c 1000 http://服务器IP/

# 调优前结果：QPS=2000，平均延迟=500ms，CPU使用率=85%，IO等待=20%
# 调优后结果：QPS=5500，平均延迟=180ms，CPU使用率=60%，IO等待=5%
```

### 步骤 5：永久化配置

将所有临时生效的配置写入对应配置文件，确保重启后依然生效，并通过 Ansible 批量部署到所有同类型服务器。

------

## 三、生产最佳实践

1. **先监控后调优**：没有数据支撑不要盲目调优，优先使用 Tuned 官方配置集
2. **最小化调优**：只调整有明确收益的参数，避免过度调优
3. **测试验证**：所有调优必须先在测试环境验证，再逐步灰度到生产
4. **持续监控**：通过 PCP 或其他监控工具长期跟踪性能指标，及时发现新的瓶颈
5. **结合业务**：不同业务场景调优重点不同（数据库侧重 IO 和内存，Web 服务器侧重网络和 CPU）









# 扩展

## 1. NUMA

SMP 和 NUMA 都是**多处理器架构**，只有当服务器有**2 个及以上物理 CPU**时，才会采用其中一种架构。

单 CPU 服务器只有一个处理器和一组内存，不存在 "多 CPU 共享内存" 的问题，因此没有多处理器架构的概念。

SMP vs NUMA 核心对比

| 特性               | SMP（对称多处理）<br />Symmetric Multi-Processing     | NUMA（非一致性内存访问）<br />Non-Uniform Memory Access      |
| ------------------ | ----------------------------------------------------- | ------------------------------------------------------------ |
| **出现时间**       | 2000 年以前的老服务器                                 | 2000 年以后至今的所有现代服务器                              |
| **内存访问**       | 所有 CPU 共享同一条内存总线，访问所有内存速度完全一致 | 分成多个独立节点，每个节点有自己的 CPU 和内存CPU 访问**本地节点内存**速度最快CPU 访问**远程节点内存**速度慢 2-3 倍 |
| **扩展性**         | 极差，最多支持 2-4 个 CPU，再多内存总线就会成为瓶颈   | 极好，可支持几十上百个 CPU，是现在唯一的多 CPU 服务器架构    |
| **现在机房普及率** | 0%，已完全淘汰                                        | 100%，所有双路及以上 x86 服务器都是 NUMA 架构                |

### 运维必用的 NUMA 命令（生产天天用）

```BASH

1. 基础查看
numactl --hardware    # 查看NUMA拓扑（最常用）
numastat              # 查看每个节点的内存分配统计
numastat -p <PID>     # 查看指定进程的NUMA内存分布（排查核心命令）
lstopo-no-graphics    # 图形化显示NUMA拓扑（需要安装hwloc）

2. 手动绑定进程到指定 NUMA 节点（性能提升最明显）
# 启动进程时绑定到Node0的CPU和内存
numactl --cpunodebind=0 --membind=0 /usr/bin/redis-server /etc/redis.conf

# 绑定已运行的进程到Node0
tuna --cpus=0-15 --threads=<PID> --move
3. 自动 NUMA 管理
# 启动numad守护进程，自动优化进程的NUMA亲和性
systemctl enable --now numad

# 查看内核自动NUMA平衡状态
sysctl kernel.numa_balancing
# 输出：kernel.numa_balancing = 1（默认开启）
4. Tuned 中的 NUMA 优化
# 低延迟场景禁用自动NUMA平衡
tuned-adm profile network-latency

# 高吞吐量场景启用自动NUMA平衡
tuned-adm profile throughput-performance
```

