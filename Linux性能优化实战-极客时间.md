Linux 性能优化实战



```bash
#ubuntu18.04 修改成静态ip地址 
vi /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:
      dhcp4: no
      addresses: [10.0.0.50/24]
      gateway4: 10.0.0.254
      nameservers:
        addresses: [223.5.5.5, 4.4.4.4]
        
sudo netplan apply

#修改成华为源
sudo sed -i "s@http://.*archive.ubuntu.com@http://mirrors.huaweicloud.com@g" /etc/apt/sources.list
sudo sed -i "s@http://.*security.ubuntu.com@http://mirrors.huaweicloud.com@g" /etc/apt/sources.list

# 用系统自带 timesyncd（推荐，不用装软件）
# 开启 NTP 自动同步
sudo timedatectl set-ntp true
# 重启服务立即同步
sudo systemctl restart systemd-timesyncd
# 再看状态
timedatectl


#ubuntu22.04版本 修改
#禁用 cloud-init 网络配置
echo "network: {config: disabled}" | tee /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg

vim /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:
      dhcp4: no
      addresses: [10.0.0.50/24]
      routes:
        - to: default
          via: 10.0.0.254
      nameservers:
        addresses: [223.5.5.5, 8.8.8.8]

sudo netplan apply        
        
        
```





性能指标是什么？

​						高并发  响应快

性能优化的两个核心指标——“吞吐”和“延时”。



# 到底应该怎么理解“平均负载”？

```bash
平均负载是指单位时间内，系统处于可运行状态和不可中断状态的平均进程数，也就是平均活跃进程数，它和CPU使用率并没有直接关系。
平均负载其实就是平均活跃进程数。

比如当平均负载为2时，意味着什么呢？
    在只有2个CPU的系统上，意味着所有的CPU都刚好被完全占用。
    在4个CPU的系统上，意味着CPU有50%的空闲。
    而在只有1个CPU的系统中，则意味着有一半的进程竞争不到CPU
```

当平均负载高于CPU数量70%的时候，你就应该分析排查负载高的问题了



平均负载与CPU使用率

```
CPU	密集型进程，使用大量	CPU	会导致平均负载升高，此时这两者是一致的；
I/O	密集型进程，等待	I/O	也会导致平均负载升高，但CPU	使用率不一定很高；
大量等待CPU	的进程调度也会导致平均负载升高，此时的CPU使用率也会比较高

```



```bash
yum	install	stress sysstat

# stress 是一个 Linux 系统压力测试工具，
# sysstat 包含了常用的 Linux 性能工具，用来监控和分析系统的性能。
mpstat 是一个常用的多核 CPU 性能分析工具，用来实时查看每个 CPU 的性能指标，以及所有CPU的平
均指标。
pidstat 是一个常用的进程性能分析工具，用来实时查看进程的 CPU、内存、I/O 以及上下文切换等性能
指标

# 测试前的负载情况
[root@ansible ~]# uptime
 16:52:39 up  2:55,  1 user,  load average: 0.02, 0.02, 0.00

# cpu密集型进程
# 模拟一个 CPU 使用率 100% 的场景：
stress --cpu 1 --timeout 600

#第二个终端运行uptime查看平均负载的变化情况：
# watch -d uptime
Every 2.0s: uptime                                                                                                                                                                       Sun May 24 16:56:54 2026

 16:56:54 up  2:59,  3 users,  load average: 0.94, 0.43, 0.17
 
# 第三个终端运行mpstat查看 CPU 使用率的变化情况：
#	-P	ALL	表⽰监控所有CPU，后⾯数字5表⽰间隔5秒后输出⼀组数据
[root@ansible ~]# mpstat -P ALL 5
Linux 6.9.10-1.el7.x86_64 (ansible)     05/24/2026      _x86_64_        (2 CPU)

04:56:34 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
04:56:39 PM  all   43.22    0.00    0.11    0.00    0.00    0.00    0.00    0.00    0.00   56.67
04:56:39 PM    0  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
04:56:39 PM    1    0.20    0.00    0.20    0.00    0.00    0.00    0.00    0.00    0.00   99.60

# -u：只输出 CPU 相关统计  5 间隔5秒  1 一共输出1组
# 排查是哪个进程占用了cpu较高的使用率
[root@ansible ~]# pidstat -u 5 1
Linux 6.9.10-1.el7.x86_64 (ansible)     05/24/2026      _x86_64_        (2 CPU)

05:01:32 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
05:01:37 PM     0       818    0.00    0.20    0.00    0.20     1  vmtoolsd
05:01:37 PM     0     23597    0.00    0.20    0.00    0.20     0  kworker/0:0-events
05:01:37 PM     0     23629  100.00    0.00    0.00  100.00     0  stress
05:01:37 PM     0     23657    0.20    0.00    0.00    0.20     1  watch

Average:      UID       PID    %usr %system  %guest    %CPU   CPU  Command
Average:        0       818    0.00    0.20    0.00    0.20     -  vmtoolsd
Average:        0     23597    0.00    0.20    0.00    0.20     -  kworker/0:0-events
Average:        0     23629  100.00    0.00    0.00  100.00     -  stress
Average:        0     23657    0.20    0.00    0.00    0.20     -  watch

#上面两个命令 使用 top  按数字1 大写P 也能看到

# 模拟 I/O 密集型进程
stress -i 1 --timeout 600
stress -d 1 --timeout 600
-i：仅内存缓存落盘，轻量操作，几乎无 IO 等待
-d：文件频繁读写删除，实打实磁盘阻塞，iowait 明显上涨


watch -d uptime
mpstat -P ALL 5
pidstat -u 5 1


#大量进程的场景
# 模拟的是 4 个进程
stress -c 4 --timeout 600

watch -d uptime   
mpstat -P ALL 5
pidstat -u 5 1



```

平均负载的理解

- 平均负载高有可能是	CPU	密集型进程导致的；

- 平均负载高并不一定代表	CPU	使用率高，还有可能是	I/O	更繁忙了；

- 当发现负载高的时候，你可以使用	mpstat、pidstat	等工具，辅助分析负载的来源。



# cpu上下文什么意思？

CPU 里有一堆**寄存器**，还有一个**程序计数器 PC**。

这些东西合起来，就是 **CPU 上下文**：

- **通用寄存器**（如 RAX、RBX、RCX…）：存临时数据、函数参数、计算结果
- **程序计数器 PC**：存「下一条要执行的指令地址」——CPU 靠它知道接下来跑哪条指令
- **栈指针 SP**：指向当前函数调用栈顶
- **标志寄存器**：记录运算结果状态（是否为 0、是否进位等）
- **浮点 / SIMD 寄存器**：浮点运算、向量运算的状态

**什么是上下文切换（Context Switch）**

CPU 只有几个核，但同时跑几十上百个进程 / 线程。

做法就是：**轮流用 CPU，每次只跑一小会儿（几毫秒），然后切给下一个任务。**

切换时要做两件事：

1. **保存旧上下文**：把当前任务的寄存器、PC 等存到内存里（内核栈 / 进程控制块）
2. **加载新上下文**：把下一个任务的寄存器、PC 恢复到 CPU 里
3. **跳转到新 PC 地址**，继续跑新任务

**常见的三种上下文切换**

### （1）进程上下文切换（最重）

```bash
Linux 按照特权等级，把进程的运行空间分为内核空间和用户空间，

内核空间（Ring 0）具有最高权限，可以直接访问所有资源；

用户空间（Ring 3）只能访问受限资源，不能直接访问内存等硬件设备，必须通过系统调用陷入到内核中，才能访问这些特权资源。

从用户态到内核态的转变，需要通过系统调用 系 来完成

CPU 寄存器里原来用户态的指令位置，需要先保存起来。接着，为了执行内核态代码，CPU 寄存器需要更
新为内核态指令的新位置。最后才是跳转到内核态运行内核任务。
而系统调用结束后，CPU寄存器需要恢复恢 原来保存的用户态，然后再切换到用户空间，继续运行进程。所
以，一次系统调用的过程，其实是发生了两次 CPU 上下文切换。

系统调用过程通常称为特权模式切换，而不是上下文切换。 。但实际上，系统调用过程中，CPU	的上
下文切换还是无法避免的
```





- 不同进程之间切换
- 要换：寄存器、PC、**页表（虚拟内存）**、用户栈、内核栈等
- 开销大，频繁切换会把 CPU 拖慢（sys 高、iowait 高）

### （2）线程上下文切换（较轻）

线程是调度的基本单位，而进程则是资源拥有的基本单位

- 同一进程里的线程之间切换
- 共享同一进程的内存 / 页表，**不用换页表**
- 只换：寄存器、PC、栈指针
- 开销比进程小很多

### （3）中断上下文切换（最轻、最快）

中断处理会打断进程的正常调度和执行，对同一个CPU来说，中断处理比进程拥有更高的优先级，

- 硬件发中断（网卡、键盘、定时器）
- CPU 立刻停下当前任务，进中断处理程序
- 只保存少量寄存器，**不切换进程 / 线程，不碰用户态内存**
- 非常快，但中断太多也会耗 CPU



小结： 

1. CPU上下文切换，是保证Linux系统正常工作的核心功能之一，一般情况下不需要我们特别关注。
2. 但过多的上下文切换，会把CPU时间消耗在寄存器、内核栈以及虚拟内存等数据的保存和恢复上，从而缩

短进程真正运行的时间，导致系统的整体性能大幅下降。



vmstat 是一个常用的系统性能分析工具，主要用来分析系统的内存使用情况，也常用来分析CPU上下文切

换和中断的次数

```bash
root@ubuntu:~# vmstat 2 3
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 0  0   4352 146680   7840 210444    0    1    84    28   91   82 22  0 77  0  0
 0  0   4352 146424   7840 210444    0    0     0     0   72   99  0  0 100  0  0
 0  0   4352 146424   7840 210444    0    0     0     0   64   91  0  0 100  0  0
 
cs（context	switch）是每秒上下文切换的次数。
in（interrupt）则是每秒中断的次数。
r（Running	or	Runnable）是就绪队列的长度，也就是正在运行和等待CPU的进程数。
b（Blocked）则是处于不可中断睡眠状态的进程数。  #进程卡在等硬件 / 网络 IO 响应，内核不允许强行终止，就变成 D 阻塞态 

```



pidstat -w 5 查看每个进程上下文切换的情况

```bash
每隔5秒输出1组数据
root@ubuntu:~# pidstat -w 5
Linux 4.15.0-156-generic (ubuntu)       05/24/26        _x86_64_        (2 CPU)

07:00:10      UID       PID   cswch/s nvcswch/s  Command
07:00:15        0         8     14.60      0.00  rcu_sched
07:00:15        0        11      0.20      0.00  watchdog/0
07:00:15        0        14      0.20      0.00  watchdog/1
07:00:15        0        23      1.00      0.00  kworker/0:1
07:00:15        0       254      2.40      0.00  kworker/u256:26
07:00:15        0       256      5.00      0.00  kworker/u256:28
07:00:15        0       430     11.20      0.00  vmtoolsd
07:00:15      100       950      0.20      0.00  systemd-network
07:00:15        0       967      2.00      0.00  sshd
07:00:15        0      1184      6.20      0.00  kworker/1:4
07:00:15        0      1929      1.80      2.00  watch
07:00:15        0      4670      0.20      0.00  pidstat


cswch 表示每秒自愿上下文切换（voluntary context switches）的次数
nvcswch 非自愿上下文切换（non voluntary context switches）的次数

所谓自愿上下文切换，是指进程无法获取所需资源，导致的上下文切换 自 。比如说， I/O、内存等系统资源
不足时，就会发生自愿上下文切换。
而非自愿上下文切换，则是指进程由于时间片已到等原因，被系统强制调度，进而发生的上下文切换 非 。比
如说，大量进程都在争抢 CPU 时，就容易发生非自愿上下文切换。
```



案例分析

```BASH
vmstat 1 1   

apt install -y sysbench
# 模拟系统多线程调度的瓶颈：
# 以10个线程运⾏5分钟的基准测试，模拟多线程切换的问题
sysbench --threads=10 --max-time=300 threads run

# 第二个终端查看
vmstat 1


# 每隔1秒输出1组数据（需要 Ctrl+C 才结束）
# -w参数表⽰输出进程切换指标，⽽-u参数则表⽰输出CPU使⽤指标
pidstat -w -u 1
# -t 是显示线程的指标
pidstat -wt 1 1


# 查看系统中断的各种情况
#	-d	参数表⽰⾼亮显⽰变化的区域
watch -d cat /proc/interrupts


#每列格式说明
cat /proc/interrupts
基础列格式
中断号 CPU0次数 CPU1次数 中断控制器 触发类型 设备名称

root@ubuntu:~# cat /proc/interrupts
            CPU0       CPU1
   0:          1          0   IO-APIC    2-edge      timer 系统定时器中断，每秒钟触发约 1000 次（取决于内核配置）
   1:        414          0   IO-APIC    1-edge      i8042  键盘鼠标控制器
   8:          0          1   IO-APIC    8-edge      rtc0  RTC 实时时钟中断，用于系统时间同步
   9:          0          0   IO-APIC    9-fasteoi   acpi  ACPI 电源管理中断，处理休眠、唤醒、电源事件
  12:       1085         70   IO-APIC   12-edge      i8042  键盘鼠标控制器
  14:          0          0   IO-APIC   14-edge      ata_piix  老式 IDE/SATA 硬盘控制器，
  15:          0          0   IO-APIC   15-edge      ata_piix  你的数值为 0 说明没有使用 IDE 硬盘
  16:          0          0   IO-APIC   16-fasteoi   ehci_hcd:usb1, vmwgfxUSB 控制器中断
  18:          0          0   IO-APIC   18-fasteoi   uhci_hcd:usb2  USB 控制器中断
  19:          0      12536   IO-APIC   19-fasteoi   ens33  ens33 网卡中断
  24:          0          0   PCI-MSI 344064-edge      PCIe PME, pciehp
  25:          0          0   PCI-MSI 346112-edge      PCIe PME, pciehp
  26:          0          0   PCI-MSI 348160-edge      PCIe PME, pciehp
  27:          0          0   PCI-MSI 350208-edge      PCIe PME, pciehp
  28:          0          0   PCI-MSI 352256-edge      PCIe PME, pciehp
  29:          0          0   PCI-MSI 354304-edge      PCIe PME, pciehp
  30:          0          0   PCI-MSI 356352-edge      PCIe PME, pciehp
  31:          0          0   PCI-MSI 358400-edge      PCIe PME, pciehp
  32:          0          0   PCI-MSI 360448-edge      PCIe PME, pciehp
  33:          0          0   PCI-MSI 362496-edge      PCIe PME, pciehp
  34:          0          0   PCI-MSI 364544-edge      PCIe PME, pciehp
  35:          0          0   PCI-MSI 366592-edge      PCIe PME, pciehp
  36:          0          0   PCI-MSI 368640-edge      PCIe PME, pciehp
  37:          0          0   PCI-MSI 370688-edge      PCIe PME, pciehp
  38:          0          0   PCI-MSI 372736-edge      PCIe PME, pciehp
  39:          0          0   PCI-MSI 374784-edge      PCIe PME, pciehp
  40:          0          0   PCI-MSI 376832-edge      PCIe PME, pciehp
  41:          0          0   PCI-MSI 378880-edge      PCIe PME, pciehp
  42:          0          0   PCI-MSI 380928-edge      PCIe PME, pciehp
  43:          0          0   PCI-MSI 382976-edge      PCIe PME, pciehp
  44:          0          0   PCI-MSI 385024-edge      PCIe PME, pciehp
  45:          0          0   PCI-MSI 387072-edge      PCIe PME, pciehp
  46:          0          0   PCI-MSI 389120-edge      PCIe PME, pciehp
  47:          0          0   PCI-MSI 391168-edge      PCIe PME, pciehp
  48:          0          0   PCI-MSI 393216-edge      PCIe PME, pciehp
  49:          0          0   PCI-MSI 395264-edge      PCIe PME, pciehp
  50:          0          0   PCI-MSI 397312-edge      PCIe PME, pciehp
  51:          0          0   PCI-MSI 399360-edge      PCIe PME, pciehp
  52:          0          0   PCI-MSI 401408-edge      PCIe PME, pciehp
  53:          0          0   PCI-MSI 403456-edge      PCIe PME, pciehp
  54:          0          0   PCI-MSI 405504-edge      PCIe PME, pciehp
  55:          0          0   PCI-MSI 407552-edge      PCIe PME, pciehp
  56:         22          0   PCI-MSI 1572864-edge      xhci_hcd  USB3.0 控制器
  57:          0          0   PCI-MSI 1572865-edge      xhci_hcd
  58:          0          0   PCI-MSI 1572866-edge      xhci_hcd
  59:          0          0   PCI-MSI 1097728-edge      ahci[0000:02:03.0] AHCI SATA 硬盘控制器，数值为 0 说明没有 SATA 硬盘在使用
  60:       9232          0   PCI-MSI 5767168-edge      nvme0q0, nvme0q1  NVMe 固态硬盘中断
  61:          0       4642   PCI-MSI 5767169-edge      nvme0q2
  62:          0          0   PCI-MSI 5767170-edge      nvme0q3
  63:          0          0   PCI-MSI 5767171-edge      nvme0q4
  64:          0          0   PCI-MSI 5767172-edge      nvme0q5
  65:          0          0   PCI-MSI 5767173-edge      nvme0q6
  66:          0          0   PCI-MSI 5767174-edge      nvme0q7
  67:          0          0   PCI-MSI 5767175-edge      nvme0q8
  68:          0          0   PCI-MSI 5767176-edge      nvme0q9
  69:          0          0   PCI-MSI 5767177-edge      nvme0q10
  70:          0          0   PCI-MSI 5767178-edge      nvme0q11
  71:          0          0   PCI-MSI 5767179-edge      nvme0q12
  72:          0          0   PCI-MSI 5767180-edge      nvme0q13
  73:          0          0   PCI-MSI 5767181-edge      nvme0q14
  74:          0          0   PCI-MSI 5767182-edge      nvme0q15
  75:        444          0   PCI-MSI 129024-edge      vmw_vmci
  76:          0          0   PCI-MSI 129025-edge      vmw_vmci
 NMI:          0          0   Non-maskable interrupts不可屏蔽中断，用于严重硬件错误（如内存校验错误）正常情况为 0
 LOC:     309550     328595   Local timer interrupts 每个 CPU 自己的本地定时器中断，数值最高是正常的，用于进程调度、计时
 SPU:          0          0   Spurious interrupts
 PMI:          0          0   Performance monitoring interrupts
 IWI:          1          0   IRQ work interrupts
 RTR:          0          0   APIC ICR read retries
 RES:   20597356   20448383   Rescheduling interrupts 重调度中断，数值极高是正常的
 CAL:       4719       3009   Function call interrupts 跨 CPU 函数调用中断，用于内核在其他 CPU 上执行函数
 TLB:         28         16   TLB shootdowns   TLB 刷新中断，当一个 CPU 修改了页表，需要通知其他 CPU 刷新 TLB 缓存
 TRM:          0          0   Thermal event interrupts
 THR:          0          0   Threshold APIC interrupts
 DFR:          0          0   Deferred Error APIC interrupts
 MCE:          0          0   Machine check exceptions
 MCP:         12         13   Machine check polls
 ERR:          0     错误中断和丢失中断，正常情况为 0，数值不为 0 说明有硬件问题
 MIS:          0     错误中断和丢失中断，正常情况为 0，数值不为 0 说明有硬件问题
 PIN:          0          0   Posted-interrupt notification event
 NPI:          0          0   Nested posted-interrupt event
 PIW:          0          0   Posted-interrupt wakeup event

1. 常见中断控制器
IO-APIC：传统主板中断控制器，用于老式外设（键盘、鼠标、SATA 硬盘）
PCI-MSI：消息信号中断（Message Signaled Interrupts），现代 PCIe 设备专用，性能更好，支持多核分配
PCI-MSI-X：MSI 的增强版，支持更多中断向量，是 NVMe、万兆网卡的标配
2. 常见触发方式
edge：边沿触发，信号从低变高或高变低时触发一次
fasteoi：快速结束中断，电平触发的优化版，现代设备常用
level：电平触发，只要信号保持就一直触发


异常情况判断
ERR/MIS 数值不为 0 → 硬件故障（如硬盘、网卡损坏）
NMI 数值不为 0 → 严重硬件错误（如 CPU、内存故障）
TLB 数值异常高 → 内存管理有问题（如大量 fork 进程）
```



# cpu使用率100%

/proc/stat 完整详解

**一句话定位**：这是 Linux 内核导出的**系统级核心统计文件**，所有性能监控工具（top、vmstat、sar、htop）的底层数据来源。

**关键特点**：所有数值都是**自开机以来的累计值**（单位：jiffies，通常 1jiffy=10ms），必须两次采样计算差值才能得到实时指标。

```
root@ubuntu:~# cat /proc/stat| grep ^cpu
cpu  user nice system idle iowait irq softirq steal guest guest_nice
cpu  92073 0 114140 857276 150 0 39 0 0 0
cpu0 46054 0 57083 428826 91 0 18 0 0 0
cpu1 46018 0 57056 428450 58 0 21 0 0 0

user（通常缩写为 us），代表用户态 CPU 时间。注意，它不包括下面的 nice 时间，但包括了 guest 时间。
nice（通常缩写为 ni），代表低优先级用户态 CPU 时间，也就是进程的 nice 值被调整为 1-19 之间时的
CPU 时间。这里注意，nice 可取值范围是 -20 到 19，数值越大，优先级反而越低。
system（通常缩写为sys），代表内核态 CPU 时间。
idle（通常缩写为id），代表空闲时间。注意，它不包括等待 I/O 的时间（iowait）。
iowait（通常缩写为 wa），代表等待 I/O 的 CPU 时间。
irq（通常缩写为 hi），代表处理硬中断的 CPU 时间。
softirq（通常缩写为 si），代表处理软中断的 CPU 时间。
steal（通常缩写为 st），代表当系统运行在虚拟机中的时候，被其他虚拟机占用的 CPU 时间。
guest（通常缩写为 guest），代表通过虚拟化运行其他操作系统的时间，也就是运行虚拟机的 CPU 时间。
guest_nice（通常缩写为 gnice），代表以低优先级运行虚拟机的时间。





root@ubuntu:~# cat /proc/stat
# 第一部分：CPU统计（最核心）
cpu  92076 0 114149 920025 152 0 39 0 0 0
cpu0 46057 0 57090 460213 92 0 18 0 0 0
cpu1 46019 0 57058 459812 60 0 21 0 0 0

# 第二部分：系统全局统计
intr 45578161 1 414 0 0 0 0 0 0 1 0 0 0 1155 0 0 0 0 0 0 15872 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...

ctxt 1596225559
btime 1779629075
processes 5972
procs_running 2
procs_blocked 0
softirq 1104943 3 637396 1125 15889 0 0 1280 265353 0 183897

intr 123456789 ...  # 中断统计  
第一个数字：自开机以来的总硬件中断次数
后续数字：每个中断号的累计触发次数（和/proc/interrupts一一对应）
第 2 位：1（中断 0 timer）
第 3 位：414（中断 1 键盘）
第 10 位：1（中断 8 rtc0）
第 14 位：1155（中断 12 鼠标）
第 21 位：12536（中断 19 网卡）
/proc/stat 的 intr 行只能看传统中断，想看所有中断必须用 /proc/interrupts


ctxt 987654321      # 上下文切换总数
btime 1716543210    # 系统开机时间（Unix时间戳）
processes 123456    # 自开机以来创建的总进程/线程数
procs_running 2     # 当前正在运行的进程数
procs_blocked 0     # 当前处于不可中断睡眠(D状态)的进程数
softirq 76543210 ... # 软中断统计
第一个数字：自开机以来的总软中断次数
后续 10 个数字：对应 10 种软中断的累计次数（和/proc/softirqs一一对应）
第 1 个：HI（高优先级 tasklet）
第 2 个：TIMER（定时器）
第 3 个：NET_TX（网络发包）
第 4 个：NET_RX（网络收包）
第 5 个：BLOCK（磁盘 IO）
第 6 个：IRQ_POLL（IO 轮询）
第 7 个：TASKLET（普通 tasklet）
第 8 个：SCHED（调度器）
第 9 个：HRTIMER（高精度定时器）
第 10 个：RCU（RCU 内存回收）





性能分析工具给出的都是间隔一段时间的平均	CPU	使用率，所以要注意间隔时间的设置，
对比一下top	和ps这两个工具报告的	CPU	使用率，默认的结果很可能不一样，因为top默认使用3秒时间间隔，而ps使用的却是进程的整个生命周期。

top	显示了系统总体的	CPU	和内存使用情况，以及各个进程的资源使用情况。
ps	则只显示了每个进程的资源使用情况。
pidstat 2 5  top 并没有细分进程的用户态CPU和内核态 CPU。用这个命令查看每个进程的详细情况


GDB（The GNU Project Debugger）， # 强大的程序调试利器
因为 GDB 调试程序的过程会中断程序运行，这在线上环境往往是不允许的。所以，GDB 只适合用在性能分析的后期，当你找到了出问题的大致函数后，线下再借助它来进一步调试函数内部的问题。

perf  perf 是 Linux 2.6.31 以后内置的性能分析工具。
# CentOS/RHEL
yum install perf
# Debian/Ubuntu
apt install linux-tools-common linux-tools-$(uname -r)



perf top 实时显示占用CPU时钟最多的函数或者指令，因此可以用来查找热点函数

perf record -g -p 进程ID
perf report    # 分析结果
perf stat ./程序名  #统计系统调用 / 事件
perf trace -p 进程ID   # 跟踪系统调用

# perf top
采样数（Samples）  事件类型（event）  事件总数量Event count
总共采集了2000个CPU时钟事件，而总事件数则为26005598
Samples: 2K of event 'cpu-clock', Event count (approx.): 26005598
Overhead  Shared Object             Symbol                                                             
  27.02%  [kernel]                  [k] vmw_cmdbuf_header_submit                                       
  10.95%  [kernel]                  [k] _raw_spin_unlock_irqrestore                                     
   8.37%  [kernel]                  [k] e1000_xmit_frame                                               
   8.19%  [kernel]                  [k] __softirqentry_text_start                                       
   2.53%  [kernel]                  [k] do_idle                                                         
   2.39%  [kernel]                  [k] tick_nohz_idle_enter                                           
   2.23%  libslang.so.2.3.1         [.] SLsmg_write_chars                                               
   1.97%  [kernel]                  [k] e1000_clean                                                     
   1.94%  [kernel]                  [k] clear_page_erms        
   
第一列	Overhead	，是该符号的性能事件在所有采样中的比例，用百分比来表示。
第二列	Shared	，是该函数或指令所在的动态共享对象（Dynamic	Shared	Object），如内核、进程名、动态链接库名、内核模块名等
第三列	Object	，是动态共享对象的类型。比如	[.]	表示用户空间的可执行程序、或者动态链接库，而	[k]则表示内核空间
最后一列	Symbol	是符号名，也就是函数名。当函数名未知时，用十六进制的地址来表示。


root@ubuntu:~# perf record  #	按Ctrl+C终⽌采样
^C[ perf record: Woken up 7 times to write data ]
[ perf record: Captured and wrote 1.877 MB perf.data (38235 samples) ]

root@ubuntu:~# perf report  #	展⽰类似于perf	top的报告
```



案例

```bash
apt install docker.io sysstat linux-tools-common apache2-utils

docker 安装
https://mirrors.huaweicloud.com/mirrorDetail/5ea14d84b58d16ef329c5c13?mirrorName=docker-ce&catalog=docker


sudo apt-get remove docker docker-engine docker.io
sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common

curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://mirrors.huaweicloud.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update
sudo apt-get install docker-ce


#华为云的镜像加速地址
https://console.huaweicloud.com/swr/?region=cn-north-4#/swr/mirror
进入华为云搜索“容器镜像服务”或者 "SWR" ，进入控制台
点击 “镜像资源”---> “镜像中心”---> "镜像加速器"
vi /etc/docker/daemon.json

{
    "registry-mirrors": [ "https://4c0c57d8b79a402d811834c1be74f7ae.mirror.swr.myhuaweicloud.com" ]
}

#上面地址不生效，重新添加多一些
{
  "registry-mirrors": [ 
  "https://cr.console.aliyun.com",
  "https://docker.m.daocloud.io",
  "https://public.ecr.aws",
  "https://dockerhub.timeweb.cloud",
  "https://4c0c57d8b79a402d811834c1be74f7ae.mirror.swr.myhuaweicloud.com"
   ]
}


docker run --name nginx -p 10000:80 -itd feisky/nginx
docker run --name phpfpm -itd --network container:nginx feisky/php-fpm





# 第二个终端
#	10.0.0.51 是第⼀台虚拟机的IP地址
curl http://10.0.0.51:10000/
# 并发10个请求测试Nginx性能，总共测试100个请求
ab -c 10 -n 100 http://10.0.0.51:10000/

#核心结果说明
Requests per second:    34.03 [#/sec] (mean)
每秒处理请求数：平均34.03次（QPS）
Time per request:       293.838 [ms] (mean)
单个请求平均响应耗时：293.8毫秒
Time per request:       29.384 [ms] (mean, across all concurrent requests)
分摊到并发下的单次理论耗时：29.4毫秒
Transfer rate:          5.72 [Kbytes/sec] received
数据接收传输速率：每秒5.72KB


ab -c 10 -n 10000 http://10.0.0.51:10000/

#换一个终端查看
top
top - 17:44:25 up 11 min,  2 users,  load average: 0.85, 0.25, 0.12
Tasks: 157 total,   6 running,  86 sleeping,   0 stopped,   0 zombie
%Cpu(s): 91.3 us,  8.2 sy,  0.0 ni,  0.0 id,  0.0 wa,  0.0 hi,  0.5 si,  0.0 st
KiB Mem :   469128 total,     5768 free,   204168 used,   259192 buff/cache
KiB Swap:  1942896 total,  1940592 free,     2304 used.   234356 avail Mem

   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
  1262 daemon    20   0  336696  12160   7028 R  40.7  2.6   0:04.03 php-fpm
  1264 daemon    20   0  336696  12552   7416 R  40.3  2.7   0:03.98 php-fpm
  1265 daemon    20   0  336696  12552   7416 R  40.0  2.7   0:03.94 php-fpm
  1261 daemon    20   0  336696  12256   7128 R  39.3  2.6   0:03.99 php-fpm
  
  
# -g开启调⽤关系分析，-p指定php-fpm的进程号21515
#上下方向键 + enter 展开 看到 调用关系最终到了 sqrt 和 add_function 
$ perf top -g -p 1262   
    Children      Self  Shared Object       Symbol                                                       
-   94.67%     1.91%  php-fpm             [.] execute_ex
   - 55.38% execute_ex                                                                                   
      - 25.18% 0x8c4a7c                                                                                 
           6.53% sqrt                                                                                   
           2.81% 0x681b9d                                                                                     - 9.49% 0x98dea3                                                                                   
           1.82% 0x98de23                                                                               
         - 1.76% 0x98dd97                                                                               
              1.51% add_function                                                                         
           1.63% 0x98de1f                                                                               
        3.99% 0x94ede0          
        
        
# 从容器phpfpm中将PHP源码拷⻉出来
$ docker cp phpfpm:/app .
# 使⽤grep查找函数调⽤
$ grep sqrt -r app/ #找到了sqrt调⽤
app/index.php: $x += sqrt($x);
$ grep add_function -r app/ #没找到add_function调⽤，这其实是PHP内置函数

root@ubuntu:~# cat app/index.php
<?php
// test only.
$x = 0.0001;
for ($i = 0; $i <= 1000000; $i++) {
  $x += sqrt($x);
}

echo "It works!"

# 上面测试代码没删除



#	停⽌原来的应⽤
docker rm -f nginx phpfpm
#	运⾏优化后的应⽤
docker run --name nginx -p 10000:80 -itd feisky/nginx:cpu-fix
docker run --name phpfpm -itd --network container:nginx feisky/php-fpm:cpu-fix


# 再次压测查看
ab -c 10 -n 10000 http://10.0.0.51:10000/


尤其要弄清楚用户（%user）、Nice（%nice）、系统（%system）	、等待I/O（%iowait）、中断（%irq）以及软中断（%softirq）这几种不同	CPU	的使用率。比如说：

用户	CPU	和	Nice	CPU	高，说明用户态进程占用了较多的	CPU，所以应该着重排查进程的性能问题。
系统	CPU	高，说明内核态占用了较多的	CPU，所以应该着重排查内核线程或者系统调用的性能问题。
I/O	等待	CPU	高，说明等待	I/O	的时间比较长，所以应该着重排查系统存储是不是出现了	I/O	问题。
软中断和硬中断高，说明软中断或硬中断的处理程序占用了较多的 CPU，所以应该着重排查内核中的中断服务程序。

碰到 CPU 使用率升高的问题，你可以借助 top、pidstat 等工具，确认引发 CPU 性能问题的来源；再使用
perf 等工具，排查出引起性能问题的具体函数。
```



案例

```bash
docker rm -f nginx phpfpm

docker run --name nginx -p 10000:80 -itd feisky/nginx:sp
docker run --name phpfpm -itd --network container:nginx feisky/php-fpm:sp

#第二个终端访问
curl http://10.0.0.51:10000/

# 并发100个请求测试Nginx性能，总共测试1000个请求
ab -c 100 -n 1000 http://10.0.0.51:10000/

# -t 请求时常 600秒
ab -c 5 -t 600 http://10.0.0.51:10000/


top 
pidstat 1 

# 25322是top里看到的 stress 进程id
pidstat -p 25322
ps aux | grep 25322

root@ubuntu:~# pstree | grep stress
        |-containerd-shim-+-php-fpm---5*[php-fpm---sh---stress---stress]
        
        
# 拷⻉源码到本地
$ docker cp phpfpm:/app .
# grep 查找看看是不是有代码在调⽤stress命令
$ grep stress -r app
app/index.php:// fake I/O with stress (via write()/unlink()).
app/index.php:$result = exec("/usr/local/bin/stress -t 1 -d 1 2>&1", $output, $status);
root@ubuntu:~# cat app/index.php
<?php
// fake I/O with stress (via write()/unlink()).
$result = exec("/usr/local/bin/stress -t 1 -d 1 2>&1", $output, $status);
if (isset($_GET["verbose"]) && $_GET["verbose"]==1 && $status != 0) {
  echo "Server internal error: ";
  print_r($output);
} else {
  echo "It works!";
}

?>

root@ubuntu:~# curl http://10.0.0.51:10000?verbose=1
Server internal error: Array
(
    [0] => stress: info: [60709] dispatching hogs: 0 cpu, 0 io, 0 vm, 1 hdd
    [1] => stress: FAIL: [60710] (563) mkstemp failed: Permission denied
    [2] => stress: FAIL: [60709] (394) <-- worker 60710 returned error 1
    [3] => stress: WARN: [60709] (396) now reaping child worker processes
    [4] => stress: FAIL: [60709] (400) kill error: No such process
    [5] => stress: FAIL: [60709] (451) failed run completed in 0s
)


#	记录性能事件，等待⼤约15秒后按	Ctrl+C	退出
perf record	-g
#	查看报告
perf report


docker rm -f nginx phpfpm




# 专门用来实时跟踪系统中所有新创建的进程，能抓到 ps、top 看不到的短命进程。
sudo apt install bpfcc-tools
execsnoop
execsnoop-bpfcc


```





# 系统中出现大量不可中断进程和僵尸进程怎么办



当iowait升高时，进程很可能因为得不到硬件的响应，而长时间处于不可中断状态。从ps或者top命令的输出中，你可以发现它们都处于D状态，也就是不可中断状态（Uninterruptible Sleep）。

进程状态

- R 是Running或Runnable的缩写，表示进程在CPU的就绪队列中，正在运行或者正在等待运行。
- D 是Disk Sleep的缩写，不可中断状态睡眠（Uninterruptible Sleep），一般表示进程正在跟硬件交互，并且交互过程不允许被其他进程或中断打断。
- Z 是Zombie的缩写，僵尸进程，也就是进程实际上已经结束了，但是父进程还没有回收它的资源（比如进程的描述符、PID等）。

- S 是 Interruptible Sleep 的缩写，可中断状态睡眠，表示进程因为等待某个事件而被系统挂起。当进程等待的事件发生时，它会被唤醒并进入 R 状态。
- I 是 Idle 的缩写，空闲状态，用在不可中断睡眠的内核线程上。前面说了，硬件交互导致的不可中断进程用 D 表示，但对某些内核线程来说，它们有可能实际上并没有任何负载，用 Idle 正是为了区分这种情况。要注意，D 状态的进程会导致平均负载升高， I 状态的进程却不会。

-  T 或者 t T ，也就是 Stopped 或 Traced 的缩写，表示进程处于暂停或者跟踪状态。

-  X，也就是 Dead 的缩写，表示进程已经消亡，所以你不会在 top 或者 ps 命令中看到它

案例

```
apt install dstat

docker run --privileged --name=app -itd feisky/app:iowait

ps aux|grep /app
top


```

进程状态包括运行（R）、空闲（I）、不可中断睡眠（D）、可中断睡眠（S）、僵尸（Z）以及暂停（T）等。

不可中断状态，表示进程正在跟硬件交互，为了保护进程数据和硬件的一致性，系统不允许其他进程或中断打断这个进程。进程长时间处于不可中断状态，通常表示系统有I/O性能问题。

僵尸进程表示进程已经退出，但它的父进程还没有回收子进程占用的资源。短暂的僵尸状态我们通常不必理会，但进程长时间处于僵尸状态，就应该注意了，可能有应用程序没有正常处理子进程的退出。



案例

```BASH
#	先删除上次启动的案例
docker rm -f app
#	重新运⾏案例
docker run --privileged --name=app -itd feisky/app:iowait


#	间隔1秒输出10组数据
dstat 1 10

# 观察⼀会⼉按 Ctrl+C 结束
top

# -d 展⽰ I/O 统计数据，-p 指定进程号，间隔 1 秒输出 3 组数据
pidstat -d -p 4344 1 3

#	间隔	1	秒输出多组数据	(这⾥是	20	组)
pidstat -d 1 20

# strace 跟踪进程系统调用的工具
strace -p 6082

ps aux | grep 6082

perf record -g
perf report


# ⾸先删除原来的应⽤
docker rm -f app
# 运⾏新的应⽤
docker run --privileged --name=app -itd feisky/app:iowait-fix1

# -a 表⽰输出命令⾏选项
# p表PID
# s表⽰指定进程的⽗进程
pstree -aps 3084


#先停⽌产⽣僵⼫进程的	app
docker rm -f app
#然后启动新的	app
docker run --privileged --name=app -itd feisky/app:iowait-fix2



owait 高不一定代表I/O 有性能瓶颈。当系统中只有I/O类型的进程在运行时，iowait也会很高，但实际上，磁盘的读写远没有达到性能瓶颈的程度。
因此，碰到 iowait 升高时，需要先用 dstat、pidstat 等工具，确认是不是磁盘 I/O 的问题，然后再找是哪些进程导致了 I/O。
等待 I/O 的进程一般是不可中断状态，
所以用 ps 命令找到的 D 状态（即不可中断状态）的进程，多为可疑进程。但这个案例中，在 I/O 操作后，进程又变成了僵尸进程，所以不能用 strace 直接分析这个进程的系统调用。
这种情况下，我们用了 perf 工具，来分析系统的 CPU 时钟事件，最终发现是直接 I/O 导致的问题。再检查源码中对应位置的问题，就很轻松了。
而僵尸进程的问题相对容易排查，使用 pstree 找出父进程后，去查看父进程的代码，检查 wait() / waitpid()的调用，或是 SIGCHLD 信号处理函数的注册就行了。


```



# 怎么理解Linux软中断？

中断其实是一种异步的事件处理机制，可以提高系统的并发处理能力

为了减少对正常进程运行调度的影响，中断处理程序就需要尽可能快地运行

Linux 将中断处理过程分成了两个阶段，也就是上半部和下半部 上 ：

上半部用来快速处理中断 上 ，它在中断禁止模式下运行，主要处理跟硬件紧密相关的或时间敏感的工作。
下半部用来延迟处理上半部未完成的工作，通常以内核线程的方式运行



/proc/softirqs	提供了软中断的运行情况；

/proc/interrupts	提供了硬中断的运行情况。



Linux 中的中断处理程序分为上半部和下半部：

上半部对应硬件中断，用来快速处理中断。

下半部对应软中断，用来异步处理上半部未完成的工作。

Linux 中的软中断包括网络收发、定时、调度、RCU锁等各种类型，可以通过查看 /proc/softirqs 来观察软

中断的运行情况。



**RCU = Read-Copy-Update（读 - 复制 - 更新）**，是 Linux 内核中**专为读多写少场景设计的颠覆性无锁同步机制**，读操作几乎零开销，性能比传统读写锁高 10~30 倍，是内核中使用最广泛的同步原语之一。

**读者永远无锁直接读；写者不修改原数据，而是复制一份改副本，原子替换指针后，等所有正在用旧数据的读者都离开，再安全回收旧数据**。



案例

```BASH
apt install sysstat hping3 tcpdump iputils-ping 

sar	是一个系统活动报告工具，既可以实时查看系统的当前活动，又可以配置保存和报告历史统计数据。
hping3	是一个可以构造	TCP/IP	协议数据包的工具，可以对系统进行安全审计、防火墙测试等。
tcpdump	是一个常用的网络抓包工具，常用来分析各种网络问题。


# 运⾏Nginx服务并对外开放80端⼝
docker run -itd --name=nginx -p 80:80 nginx

#第二个vm终端 curl
curl http://10.0.0.51

#	-S参数表⽰设置TCP协议的SYN（同步序列号），-p表⽰⽬的端⼝为80
#	-i	u100表⽰每隔100微秒发送⼀个⽹络帧
#	注：如果你在实践过程中现象不明显，可以尝试把100调⼩，⽐如调成10甚⾄1
hping3 -S -p 80 -i u10 10.0.0.51
#这是一个	SYN	FLOOD	攻击，

#发现速度变慢
curl http://10.0.0.51

#回到ngxin服务器终端排查
top   #软中断变多
#通过 /proc/softirqs 文件内容的变化情况，你可以发现， TIMER（定时中断）、NET_RX（网络接收）、
# SCHED（内核调度）、RCU（RCU锁）等这几个软中断都在不停变化。
watch -d column -t /proc/softirqs  

sar -n DEV 1

#	-i	eth0	只抓取eth0⽹卡，-n不解析协议名和主机名
#	tcp	port	80表⽰只抓取tcp协议并且端⼝号为80的⽹络帧
# tcpdump -i ens33 -n tcp port 80

23:42:53.443400 IP 10.0.0.52.34864 > 10.0.0.51.80: Flags [S], seq 2058459779, win 512, length 0

Flags [S] ==> [S] = SYN
简写	标识名	全称	作用说明
S	SYN	Synchronize	同步，发起 TCP 连接（三次握手第一步）
A	ACK	Acknowledgment	确认，应答收到的报文
F	FIN	Finish	结束，请求断开连接
R	RST	Reset	重置，强制断开 / 拒绝连接
P	PSH	Push	推送，数据立即交付应用，不缓存
U	URG	Urgent	紧急，报文包含紧急数据



```



# 套路篇：如何迅速分析出系统CPU的瓶颈在哪里？



CPU使用率描述了非空闲时间占总CPU时间的百分比,根据CPU上运行任务的不同，又被分为

- 用户CPU、
- 系统CPU、
- 等待I/OCPU、
- 软中断和硬中断等。



平均负载（Load Average），也就是系统的平均活跃进程数。

​	平均负载等于逻辑CPU个数，这表示每个CPU都恰好被充分利用。如果平均负载大于逻辑CPU个数，就表示负载比较重了

​	负载数字长时间大于逻辑cpu 70%考虑解决



进程上下文切换

​	无法获取资源而导致的自愿上下文切换；

​	被系统强制调度导致的非自愿上下文切换。

       ```BASH
       # w参数看进程的上下文， -p 指定进程id
       pidstat -w -p 2370 1 3
       ```



CPU缓存的命中率

```bash
apt install linux-tools-common linux-tools-$(uname -r)

查看 L1/L2/L3 缓存命中 / 未命中
# 每 1 秒输出一次，持续采样
perf stat -e L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses -a -I 1000

字段释义
事件名						含义
L1-dcache-loads	L1 		数据缓存总读取次数
L1-dcache-load-misses	L1 数据缓存未命中次数
LLC-loads				最后一级缓存（L3）总读取次数
LLC-load-misses	L3 		缓存未命中（穿透到内存）


2. 只监控单个进程 PID
# 监控 PID=1234，持续输出
perf stat -e L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses -p 1234 -I 1000

3. 采样一段时间后汇总（非实时）
统计 5 秒整体缓存情况：
perf stat -e L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses -a sleep 5



# ubuntu18.04 安装 bpfcc-tools + 对应内核头文件
sudo apt install -y bpfcc-tools linux-headers-$(uname -r)

sudo ln -s /usr/sbin/cachestat-bpfcc /usr/local/bin/cachestat
sudo ln -s /usr/sbin/cachetop-bpfcc /usr/local/bin/cachetop

cachestat 1
cachetop


root@ubuntu:~# cachestat 1
    HITS   MISSES  DIRTIES  READ_HIT% WRITE_HIT%   BUFFERS_MB  CACHED_MB
       0       25        0       0.0%     100.0%           14        205
       0        0        0       0.0%       0.0%           14        205
HITS      0      ← 缓存命中次数（没用到缓存）
MISSES   25      ← 缓存未命中（必须去读磁盘）
DIRTIES   0      ← 新增脏页（无写入）
READ_HIT% 0.0%   ← 读缓存命中率（越高越好，正常 >90%）
WRITE_HIT% 100%  ← 写命中率100%（因为没写入）
BUFFERS_MB 14    ← 系统缓冲区
CACHED_MB 205    ← 页缓存大小




apt install -y pv
# 限速 1MB/s 写 100MB 文件
dd if=/dev/zero bs=1M count=100 | pv -L 1M | dd of=test.dat bs=1M
#-L 1M：限速 1MB/s
#改成 -L 512K 就是 512KB/s
# 改成 -L 10M 就是 10MB/s

cachetop #观察缓存命中率

cachetop 头部信息，简单解读：
Buffers MB: 14
系统块设备缓冲区占用 14MB，用于磁盘读写缓冲，数值稳定说明无大量块设备 IO。
Cached MB: 207
页缓存合计 207MB（文件、目录、程序运行数据等都存在这里），相比之前 206MB 小幅上涨，只是少量文件 / 数据被载入缓存，属于正常波动。
Sort: HITS / Order: ascending
当前按缓存命中次数升序排列，所以低命中进程排在最上方。

```



性能工具



| 性能指标            | 工具                                 | 说明                                                         |
| ------------------- | ------------------------------------ | ------------------------------------------------------------ |
| 平均负载            | uptime、top                          | uptime 最简单；top 提供了更全的指标                          |
| 系统整体 CPU 使用率 | vmstat、mpstat、top、sar、/proc/stat | top、vmstat、mpstat 只可以动态查看，而 sar 还可以记录历史数据；/proc/stat 是其他性能工具的数据来源 |
| 进程 CPU 使用率     | top、pidstat、ps、htop、atop         | top 和 ps 可以按 CPU 使用率给进程排序，而 pidstat 只显示实际用了 CPU 的进程；htop 和 atop 以不同颜色显示更直观 |
| 系统上下文切换      | vmstat                               | 除了上下文切换次数，还提供运行状态和不可中断状态进程的数量   |
| 进程上下文切换      | pidstat                              | 注意加上 -w 选项                                             |
| 软中断              | top、/proc/softirqs、mpstat          | top 提供软中断 CPU 使用率，而 /proc/softirqs 和 mpstat 提供了各种软中断在每个 CPU 上的运行次数 |
| 硬中断              | vmstat、/proc/interrupts             | vmstat 提供总的中断次数，而 /proc/interrupts 提供各种中断在每个 CPU 上运行的累积次数 |
| 网络                | dstat、sar、tcpdump                  | dstat 和 sar 提供总的网络接收和发送情况，而 tcpdump 则是动态抓取正在进行的网络通讯 |
| I/O                 | dstat、sar                           | dstat 和 sar 都提供了 I/O 的整体情况                         |
| CPU 个数            | /proc/cpuinfo、lscpu                 | lscpu 更直观                                                 |
| 事件剖析            | perf、execsnoop                      | perf 可以用来分析 CPU 的缓存以及内核调用链，execsnoop 用来监控短时进程 |



| 性能工具         | CPU 性能指标                                                 |
| ---------------- | ------------------------------------------------------------ |
| uptime           | 平均负载                                                     |
| top              | 平均负载、运行队列、整体的 CPU 使用率以及每个进程的状态和 CPU 使用率 |
| htop             | top 增强版，以不同颜色区分不同类型的进程，更直观             |
| atop             | CPU、内存、磁盘和网络等各种资源的全面监控                    |
| vmstat           | 系统整体的 CPU 使用率、上下文切换次数、中断次数，还包括处于运行和不可中断状态的进程数量 |
| mpstat           | 每个 CPU 的使用率和软中断次数                                |
| pidstat          | 进程和线程的 CPU 使用率、中断上下文切换次数                  |
| /proc/softirqs   | 软中断类型和在每个 CPU 上的累积中断次数                      |
| /proc/interrupts | 硬中断类型和在每个 CPU 上的累积中断次数                      |
| ps               | 每个进程的状态和 CPU 使用率                                  |
| pstree           | 进程的父子关系                                               |
| dstat            | 系统整体的 CPU 使用率                                        |
| sar              | 系统整体的 CPU 使用率，包括可配置的历史数据                  |
| strace           | 进程的系统调用                                               |
| perf             | CPU 性能事件剖析，如调用链分析、CPU 缓存、CPU 调度等         |
| execsnoop        | 监控短时进程                                                 |



# 套路篇：CPU性能优化的几个思路

CPU性能优化思路

方法论

1.性能优化的效果判断

三步走理论

(1)确定性能的量化指标－一般从应用程序纬度和系统资源纬度分析

(2)测试优化前的性能指标

(3)测试性能优化后的性能指标

2.当性能问题有多个时，优先级问题

先优化最重要的且最大程度提升性能的问题开始优化

3.优化方法有多个时，该如何选

综合多方面因素

CPU优化

应用程序优化:排除不必要工作，只留核心逻辑

1.减少循环次数 减少递归 减少动态没错分配

2.编译器优化

3.算法优化

4.异步处理

5.多线程代替多进程

6.缓存

系统优化:利用CPU缓存本地性，加速缓存访问;控制进程的cpu使用情况，减少程序的处理速度

1.CPU绑定

2.CPU独占

3.优先级调整

4.为进程设置资源限制

5.NUMA优化

6.中断负载均衡

很重要的一点:切记过早优化



# linux内存是怎么工作的？

对普通进程来说，它能看到的其实是内核提供的虚拟内存，这些虚拟内存还需要通过页表，由系统映射为物理内存。
当进程通过	malloc()	申请内存后，内存并不会立即分配，而是在首次访问时，才通过缺页异常陷入内核中分配内存。
由于进程的虚拟地址空间比物理内存大很多，Linux还提供了一系列的机制，应对内存不足的问题，比如缓存的回收、交换分区Swap以及OOM等。

当你需要了解系统或者进程的内存使用情况时，可以用free和top、ps等性能工具。它们都是分析性能问
题时最常用的性能工具，



# 怎么理解内存中的Buffer和Cache？

Buffer是缓冲区，Cache是缓存，两者都是数据在内存中的临时存储。

Buffers	是对原始磁盘块的临时存储，也就是用来缓存磁盘的数据，通常不会特别大（20MB左右）。这样，内核就可以把分散的写集中起来，统一优化磁盘的写入，比如可以把多次小的写合并成单次大的写等等。

Cached	是从磁盘读取文件的页缓存，也就是用来缓存从文件读取的数据。这样，下次访问这些文件数据时，就可以直接从内存中快速获取，而不需要再次访问缓慢的磁盘。

SReclaimable 是Slab的一部分。Slab包括两部分，其中的可回收部分，用SReclaimable 记录；而不可回收部分，用SUnreclaim记录。



```BASH
#	清理⽂件⻚、⽬录项、Inodes等各种缓存
echo 3 > /proc/sys/vm/drop_caches

# 在终端一执行
vmstat 1 

#在另一个终端执行
dd if=/dev/urandom of=/tmp/file bs=1M count=500

```



Buffer既可以用作“将要写入磁盘数据的缓存”，也可以用作“从磁盘读取数据的缓存”。

Cache既可以用作“从文件读取数据的页缓存”，也可以用作“写文件的页缓存”。

简单来说，Buffer是对磁盘数据的缓存，而Cache是文件数据的缓存，它们既会用在读请求中，也会用在写请求中。



# 如何利用系统缓存优化程序的运行效率？



```bash
# ubuntu18.04 安装 bpfcc-tools + 对应内核头文件
sudo apt install -y bpfcc-tools linux-headers-$(uname -r)

sudo ln -s /usr/sbin/cachestat-bpfcc /usr/local/bin/cachestat
sudo ln -s /usr/sbin/cachetop-bpfcc /usr/local/bin/cachetop

cachestat 1
cachetop


root@ubuntu:~# cachestat 1
    HITS   MISSES  DIRTIES  READ_HIT% WRITE_HIT%   BUFFERS_MB  CACHED_MB
       0       25        0       0.0%     100.0%           14        205
       0        0        0       0.0%       0.0%           14        205
HITS      0      ← 缓存命中次数（没用到缓存）
MISSES   25      ← 缓存未命中（必须去读磁盘）
DIRTIES   0      ← 新增脏页（无写入）
READ_HIT% 0.0%   ← 读缓存命中率（越高越好，正常 >90%）
WRITE_HIT% 100%  ← 写命中率100%（因为没写入）
BUFFERS_MB 14    ← 系统缓冲区
CACHED_MB 205    ← 页缓存大小

# 安装 pcstat 
# 查看指定文件的缓存大小
wget https://dl.google.com/go/go1.26.0.linux-amd64.tar.gz
tar zxvf go1.26.0.linux-amd64.tar.gz -C /usr/local/

vi /etc/profile
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin

source /etc/profile

root@ubuntu:~# go version


go get golang.org/x/sys/unix
go get github.com/tobert/pcstat/pcstat

#上面两行地址不通，使用国内地址代理
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
go env -w GOSUMDB=sum.golang.google.cn  # 国内sumdb镜像，替代官方
go install golang.org/x/sys/unix@latest

# 安装 pcstat（带版本号，正确语法）
go install github.com/tobert/pcstat@latest

 mv ~/go/bin/pcstat /usr/local/go/bin/
 
 root@ubuntu:~# pcstat /bin/ls
+---------+----------------+------------+-----------+---------+
| Name    | Size (bytes)   | Pages      | Cached    | Percent |
|---------+----------------+------------+-----------+---------|
| /bin/ls | 133792         | 33         | 33        | 100.000 |
+---------+----------------+------------+-----------+---------+
 
 
 

```





# 套路篇：如何“快准狠”找到系统内存的问题



根据指标找工具（内存性能）

| 内存指标                         | 性能工具                         |
| -------------------------------- | -------------------------------- |
| 系统已用、可用、剩余内存         | free、vmstat、sar、/proc/meminfo |
| 进程虚拟内存、常驻内存、共享内存 | ps、top                          |
| 进程内存分布                     | pmap                             |
| 进程 Swap 换出内存               | top、/proc/pid/status            |
| 进程缺页异常                     | ps、top                          |
| 系统换页情况                     | sar                              |
| 缓存 / 缓冲区用量                | free、vmstat、sar、cachestat     |
| 缓存 / 缓冲区命中率              | cachetop                         |
| SWAP 已用空间和剩余空间          | free、sar                        |
| Swap 换入换出                    | vmstat                           |
| 内存泄漏检测                     | memleak、valgrind                |
| 指定文件的缓存大小               | pcstat                           |



根据工具查指标(内存性能)

| 性能工具              | 内存指标                                                     |
| --------------------- | ------------------------------------------------------------ |
| free、/proc/meminfo   | 系统已用、可用、剩余内存以及缓存和缓冲区的使用量             |
| top、ps               | 进程虚拟、常驻、共享内存以及缺页异常                         |
| vmstat                | 系统剩余内存、缓存、缓冲区、换入、换出                       |
| sar                   | 系统内存换页情况、内存使用率、缓存和缓冲区用量以及 Swap 使用情况 |
| cachestat             | 系统缓存和缓冲区的命中率                                     |
| cachetop              | 进程缓存和缓冲区的命中率                                     |
| slabtop               | 系统 Slab 缓存使用情况                                       |
| /proc/pid/status      | 进程 Swap 内存等                                             |
| /proc/pid/smaps、pmap | 进程地址空间和内存状态                                       |
| valgrind              | 进程内存错误检查器，用来检测内存初始化、泄漏、越界访问等各种内存错误 |
| memleak               | 内存泄漏检测                                                 |
| pcstat                | 查看指定文件的缓存情况                                       |



内存调优最重要的就是，保证应用程序的热点数据放到内存中，并尽量减少换页和交换。

常见的优化思路有这么几种。

1. 最好禁止Swap。如果必须开启Swap，降低swappiness的值，减少内存回收时Swap的使用倾向。
2. 减少内存的动态分配。比如，可以使用内存池、大页（HugePage）等。
3. 尽量使用缓存和缓冲区来访问数据。比如，可以使用堆栈明确声明内存空间，来存储需要缓存的数据；或者用Redis这类的外部缓存组件，优化数据的访问。

4. 使用cgroups等方式限制进程的内存使用情况。这样，可以确保系统内存不会被异常进程耗尽。
5. 通过/proc/pid/oom_adj，调整核心应用的oom_score。这样，可以保证即使内存紧张，核心应用也不会被OOM杀死。





# Linux文件系统是怎么工作的？

文件系统，是对存储设备上的文件，进行组织管理的一种机制。为了支持各类不同的文件系统，

Linux在各种文件系统实现上，抽象了一层虚拟文件系统（VFS）。
VFS定义了一组所有文件系统都支持的数据结构和标准接口。这样，用户进程和内核中的其他子系统，就只需要跟VFS提供的统一接口进行交互。

为了降低慢速磁盘对性能的影响，文件系统又通过页缓存、目录项缓存以及索引节点缓存，缓和磁盘延迟对应用程序的影响。




# Linux磁盘IO是怎么工作的

## 一、IO 整体栈（从上到下）

应用进程 → 系统调用 → VFS → **Page Cache (页缓存)** → 文件系统 → 块层 → 驱动 → 物理磁盘

- 核心：**Page Cache 是 Linux IO 核心**，用内存缓存磁盘数据，减少真实磁盘访问。

## 二、两大 IO 模式

### 1. 缓存 IO（系统默认，通用业务）

- **读**：优先查缓存，命中直接返回；未命中才读磁盘，顺带预读相邻数据。

- 写

  ：数据先写入内存标记为

  脏页

  ，

  ```
  write
  ```

   直接返回；内核后台批量刷盘。

  

  触发刷盘：超时、脏页占内存达阈值；需强一致性用 

  ```
  fsync/fdatasync
  ```

   强制落盘。

### 2. 直接 IO（Direct IO，数据库常用）

- 绕开 Page Cache，数据直连应用与磁盘；要求 4K 对齐，无缓存优化，小 IO 性能差。

### 补充：异步 IO

传统同步 IO 会阻塞进程；新版 `io_uring` 异步 IO 不阻塞进程，高并发场景性能更强。

## 三、块层 & IO 调度器

1. **队列**：主流 `blk-mq` 多队列（每 CPU 独立队列，NVMe 标配，中断分散）。

2. 调度器

   （查看命令：cat /sys/block/sda/queue/scheduler）

   - NONE： 并非真正的 IO 调度算法，内核完全不处理、不调度 IO 请求；
     适用：虚拟机（IO 调度交由物理机 / 底层硬件负责）、高端硬件阵列。

   - `noop`：空调度，**NVMe 首选 **  最简单的调度逻辑，基于 ** 先入先出 (FIFO)** 队列，仅做基础 IO 请求合并，不做排序；

     适用：**SSD/NVMe 固态硬盘**（无机械寻道，排序无收益）。

   - CFQ（Completely Fair Scheduler），也被称为完全公平调度器，为每个进程单独创建 IO 队列，均匀分配 IO 资源，还支持进程 IO 优先级；

     适用：多进程并发场景、桌面系统、多媒体应用；

     现状：老系统默认，新内核已淘汰。

   - `mq-deadline`：平衡延迟与吞吐，**SATA SSD / 机械盘 默认** 

     读写请求分离为两个独立队列，为请求设置最大等待时限，避免请求长期阻塞；

     优势：大幅提升机械盘吞吐，抗压能力强；

     适用：**高 IO 压力场景（数据库）**、机械硬盘、普通 SATA 固态盘。

## 四、三类磁盘硬件特性

1. **机械盘 HDD**：有寻道 / 旋转延迟，**顺序 IO 快、随机 IO 极慢**，依赖 IO 合并排序。
2. **SATA SSD**：无机械延迟，受 SATA 带宽限制，随机 IO 远强于 HDD。
3. **NVMe SSD**：PCIe 总线，高带宽、低延迟、原生多队列，综合性能最优。

## 五、核心运维指标（原理对应排查）

1. **%iowait(wa)**：CPU 空闲但等待磁盘 IO，数值高 = **IO 瓶颈**。
2. **D 状态进程 /procs_blocked**：进程卡在等待 IO，大量 D 进程 = IO 队列拥堵。
3. **iostat**：`r_await/w_await` >10ms 代表队列阻塞；`%util` 表示磁盘繁忙度。
4. **脏页参数**：`vm.dirty_*` 控制脏页刷盘时机，写压力大时可调低阈值防突发拥堵。
5. **Page Cache**：空闲内存会自动用作缓存，占用高属于正常现象。

## 六、常见 IO 问题根因

1. 读写慢 + 高 iowait：小 IO 过多、脏页集中刷盘、磁盘 / RAID 故障。
2. 读性能差：缓存命中率低、全量冷数据。
3. NVMe 性能不佳：调度器 / 中断绑定不合理。
4. IO 突发抖动：定时备份、日志切割、脏页定时回刷抢占资源。



## **磁盘性能指标**

使用率、饱和度、IOPS、 吞吐量以及响应时间



使用率：是指磁盘处理I/O的时间百分比。过高的使用率（比如超过80%），通常意味着磁盘I/O存在性能瓶颈。
饱和度： 是指磁盘处理I/O的繁忙程度。过高的饱和度，意味着磁盘存在严重的性能瓶颈。当饱和度为100%时，磁盘无法接受新的I/O请求。
IOPS（Input/Output Per Second）： 是指每秒的I/O请求数。
吞吐量： 是指每秒的I/O请求大小。
响应时间：是指I/O请求从发出到收到响应的间隔时间。



## 磁盘I/O观测

```BASH

# -d -x表⽰显⽰所有磁盘I/O的指标
root@ubuntu:~# iostat -d -x 1
Linux 4.15.0-156-generic (ubuntu)       05/28/26        _x86_64_        (2 CPU)
Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme0n1         78.41   14.47   3299.31    172.14     0.00    12.24   0.00  45.83    0.43    0.47   0.03    42.08    11.90   0.07   0.64


注意： 
%util	，就是我们前面提到的磁盘I/O使用率；
r/s+	w/s	，就是	IOPS；
rkB/s+wkB/s	，就是吞吐量；
r_await+w_await	，就是响应时间。





```



| 性能指标   | 含义                                          | 提示                                                         |
| ---------- | --------------------------------------------- | ------------------------------------------------------------ |
| `r/s`      | 每秒发送给磁盘的读请求数                      | 合并后的请求数                                               |
| `w/s`      | 每秒发送给磁盘的写请求数                      | 合并后的请求数                                               |
| `rkB/s`    | 每秒从磁盘读取的数据量                        | 单位为 kB                                                    |
| `wkB/s`    | 每秒向磁盘写入的数据量                        | 单位为 kB                                                    |
| `rrqm/s`   | 每秒合并的读请求数                            | `%rrqm` 表示合并读请求的百分比                               |
| `wrqm/s`   | 每秒合并的写请求数                            | `%wrqm` 表示合并写请求的百分比                               |
| `r_await`  | 读请求处理完成等待时间                        | 包括队列中的等待时间和设备实际处理的时间，单位为毫秒         |
| `w_await`  | 写请求处理完成等待时间                        | 包括队列中的等待时间和设备实际处理的时间，单位为毫秒         |
| `aqu-sz`   | 平均请求队列长度                              | 旧版中为 `avgqu-sz`                                          |
| `rareq-sz` | 平均读请求大小                                | 单位为 kB                                                    |
| `wareq-sz` | 平均写请求大小                                | 单位为 kB                                                    |
| `svctm`    | 处理 I/O 请求所需的平均时间（不包括等待时间） | 单位为毫秒。注意这是推断的数据，并不保证完全准确             |
| `%util`    | 磁盘处理 I/O 的时间百分比                     | 即使用率，由于可能存在并行 I/O，100% 并不一定表明磁盘 I/O 饱和 |



## 进程I/O观测

```
root@ubuntu:~# pidstat -d 1
Linux 4.15.0-156-generic (ubuntu)       05/28/26        _x86_64_        (2 CPU)

09:08:16      UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s iodelay  Command
09:08:17        0       279      0.00      4.00      0.00       0  jbd2/nvme0n1p1-


用户ID（UID）和进程ID（PID） 。
每秒读取的数据大小（kB_rd/s） ，单位是 KB。
每秒发出的写请求数据大小（kB_wr/s） ，单位是 KB。
每秒取消的写请求数据大小（kB_ccwr/s） ，单位是 KB。
块I/O延迟（iodelay），包括等待同步块I/O和换入块I/O结束的时间，单位是时钟周期


# iotop
Total DISK READ :       0.00 B/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:       0.00 B/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND
     1 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % init noprompt
     2 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kthreadd]
     3 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kworker/0:0]
     
字段	含义
Total DISK READ	系统总计磁盘读速率，单位 B/s
Total DISK WRITE	系统总计磁盘写速率，单位 B/s
Actual DISK READ	实际下发到物理磁盘的读速率（扣除缓存、合并等）
Actual DISK WRITE	实际下发到物理磁盘的写速率
TID	线程 ID（Thread ID），Linux 下线程 / 进程都用 TID 标识
PRIO	线程 IO 优先级，be/4 是默认后台优先级
USER	进程 / 线程所属用户名
DISK READ	当前线程每秒磁盘读取量
DISK WRITE	当前线程每秒磁盘写入量
SWAPIN	换入内存耗时占比（%），数值高表示频繁发生内存交换
IO>	线程阻塞在 I/O 等待的时间占比（%），越高说明该线程越受磁盘 IO 影响
COMMAND	进程 / 线程名称、命令
     
```



# 案例篇：如何找出狂打日志的“内鬼”



```bash
 docker run -v /tmp:/tmp --name=app -itd feisky/logapp
 
 
 
  ps -ef | grep /app.py
 
 # 按1切换到每个CPU的使⽤情况
$ top
 
 free -h
 
 
#	-d表⽰显⽰I/O性能指标，-x表⽰显⽰扩展统计（即所有I/O指标）
$	iostat	-x	-d	1	

$	pidstat	-d	1	 

strace -p 18940 # id是python进程id  查进程pid命令：  pidof python

lsof -p 18940	
字段	说明
FD	文件描述符（File Descriptor），进程打开文件 / 句柄编号
TYPE	文件类型，区分普通文件、套接字、管道、设备等
DEVICE	设备号，格式 主设备号:次设备号
NODE	文件对应的 inode 编号

FD（文件描述符）完整说明
1. 标准基础编号
0：标准输入 stdin
1：标准输出 stdout
2：标准错误 stderr
3+：进程后续打开的文件、套接字、管道等句柄
2. FD 后缀标识（权限 / 状态）
FD 数字后常带标记：
r：只读模式
w：只写模式
u：读写模式
空格：默认状态
*：代表内存映射文件
3. 特殊 FD 名称
cwd：进程当前工作目录
txt：进程可执行程序文件（二进制本体）
mem：内存映射文件 / 库文件
rtd：根目录 /

TYPE 常见类型（运维高频）
TYPE	类型说明	场景
REG	普通文件（Regular File）	日志、配置、二进制、数据文件
DIR	目录（Directory）	进程访问的文件夹
CHR	字符设备（Character Device）	串口、终端、/dev/null、键盘、控制台
BLK	块设备（Block Device）	磁盘、分区、U 盘（/dev/sda）
FIFO	命名管道（有名管道）	进程间通信
PIPE	匿名管道	父子进程临时通信
SOCK	套接字（Socket）	网络通信、本地域套接字（TCP/UDP/UNIX socket）
IPv4/IPv6	网络套接字	对应 TCP/UDP 网络连接
LNK	软链接（Symbolic Link）	符号链接文件



#拷⻉案例应⽤源代码到当前⽬录
 docker cp app:/app.py .
#查看案例应⽤的源代码
 cat app.py

kill -SIGUSR2 18940    # kill -12 18940
    
top
iostat -d -x 1
   
```



# 案例篇：为什么我的磁盘IO延迟很高？



```bash
docker run --name=app -p 10000:80 -itd feisky/word-pop


#另一个客户端访问
curl http://10.0.0.51:10000/

# 这个接口居然这么长时间都没响应，究竟是怎么回事呢？
curl http://10.0.0.51:10000/popularity/word	  

while true; do time curl http://10.0.0.51:10000/popularity/word; sleep 1; done	



#服务端排查
df
top
ps aux | grep app.py
iostat -d -x 1
pidstat -d 1

strace -p 1174
strace -p 1174 2>&1 | grep write	
trace -p PID后加上-f，多进程和多线程都可以跟踪。
strace -fp 1174 2>&1|grep write  #这样能跟踪到写操作


Linux 进程默认打开3 个文件描述符：
0 = 标准输入（stdin）
1 = 标准输出（stdout，正常打印信息）
2 = 标准错误（stderr，报错信息）
>&：重定向绑定语法
2>&1 就是把错误信息重定向到标准输出



# 安装filetop工具
# 基于Linux内核的eBPF（extended Berkeley Packet Filters 机制,主要跟踪内核中文件的读写情况，并输出线程ID（TID）、读写大小、读写类型以及文件名称
sudo apt-get install bpfcc-tools linux-headers-$(uname -r)

# -C 选项表⽰输出新内容时不清空屏幕
filetop-bpfcc -C
# T 显示线程号spid
 ps -efT

# 第四列显示线程号 LWP
ps -efL
 
#动态跟踪内核中的open系统调用。 看到文件路径
opensnoop-bpfcc

# 发现文件路径不存在  这些目录都是应用程序动态生成的，用完就删了。
ls /tmp/0115cb94-5b36-11f1-b4f4-0242ac110002/| wc -l

# docker cp app:/app.py .
# cat app.py   #查看源码 修改优化代码
```



# 案例篇：一个SQL查询要15秒，这是怎么回事？



```BASH
git clone https://github.com/feiskyer/linux-perf-examples
cd linux-perf-examples/mysql-slow
$ make run     #下面三个容器会自动运行了
# 注意下⾯的随机字符串是容器ID，每次运⾏均会不同，并且你不需要关注它，因为我们只会⽤到名字
docker run --name=mysql -itd -p 10000:80 -m 800m feisky/mysql:5.6
docker run --name=dataservice -itd --privileged feisky/mysql-dataservice
docker run --name=app --network=container:mysql -itd feisky/mysql-slow

-----------------------------
docker ps 
docker logs -f mysql
curl http://127.0.0.1:10000/

$ make init  #初始化数据库，并插入10000条商品信息。这个过程比较慢，


# 切换到客户端访问
curl http://10.0.0.51:10000/products/geektime
while true; do curl http://10.0.0.51:10000/products/geektime; sleep 5; done
#查询数据是空的 反应特别慢， 

#服务器端排查问题
top
iostat -d -x 1
pidstat -d 1

strace -fp `pidof mysqld`
lsof -p `pidof mysqld`


# -t表⽰显⽰线程，-a表⽰显⽰命令⾏参数   
# 看mysqld有多少线程
$ pstree -t -a -p `pidof mysqld`

docker exec -it mysql ls -l /var/lib/mysql/test/

# 查看数据的存储路径
docker exec -i -t mysql mysql -e 'show global variables like "%datadir%";' 

docker exec -i -t mysql mysql
> show full processlist;
# 多执行几次  能看到select 的语句

# 切换到test库
mysql> use test;
# 执⾏explain命令
mysql> explain select * from products where productName='geektime';

mysql> explain select * from products where productName='geektime';
+----+-------------+----------+------+---------------+------+---------+------+-------+-------------+
| id | select_type | table    | type | possible_keys | key  | key_len | ref  | rows  | Extra       |
+----+-------------+----------+------+---------------+------+---------+------+-------+-------------+
|  1 | SIMPLE      | products | ALL  | NULL          | NULL | NULL    | NULL | 10000 | Using where |
+----+-------------+----------+------+---------------+------+---------+------+-------+-------------+

select_type	表示查询类型，而这里的SIMPLE	表示此查询不包括	UNION	查询或者子查询；
table	表示数据表的名字，这里是	products；
type	表示查询类型，这里的	ALL	表示全表查询，但索引查询应该是	index	类型才对；
possible_keys	表示可能选用的索引，这里是	NULL；
key	表示确切会使用的索引，这里也是	NULL；
rows	表示查询扫描的行数，这里是	10000。

根据这些信息，我们可以确定，这条查询语句压根儿没有使用索引，所以查询时，会扫描全表，并且扫描行
数高达	10000	行。响应速度那么慢也就难怪了

mysql> show create tableproducts;
mysql> CREATE INDEX products_index ON products(productName);
ERROR 1170 (42000): BLOB/TEXT column 'productName' used in key specification without a key length
mysql> CREATE INDEX products_index ON products(productName(64));




DataService 是一个严重影响 MySQL 性能的干扰应用。抛开上述索引优化方法不说，这个案例还
有一种优化方法，也就是停止 DataService 应用。

# 删除索引
$ docker exec -i -t mysql mysql
mysql> use test;
mysql> DROP INDEX products_index ON products;

#	停⽌	DataService	应⽤
$ docker rm -f dataservice

```

# 案例篇：Redis响应严重延迟，如何解决？





```bash
#server 
# 注意下⾯的随机字符串是容器ID，每次运⾏均会不同，并且你不需要关注它
docker run --name=redis -itd -p 10000:80 feisky/redis-server
docker run --name=app --network=container:redis -itd feisky/redis-app

docker ps

curl http://10.0.0.51:10000/

# 案例插⼊5000条数据，在实践时可以根据磁盘的类型适当调整，⽐如使⽤SSD时可以调⼤，⽽HDD可以适当调⼩
curl http://10.0.0.51:10000/init/50000


curl http://10.0.0.51:10000/get_cache
while true; do curl http://10.0.0.51:10000/get_cache; done  #客户端访问

#服务端排查
top
iostat -d 1 
pidstat -d 1
#	-f表⽰跟踪⼦进程和⼦线程，-T表⽰显⽰系统调⽤的时⻓，-tt表⽰显⽰跟踪时间
strace -f -T -tt -p `pidof redis-server`
lsof -p `pidof redis-server`

strace -f -p `pidof redis-server` -T -tt -e	fdatasync
参数	全称 / 含义
-p 	--pid，附着到指定进程 PID 跟踪
-f	--follow-forks，跟踪 fork/clone 产生的子进程 / 子线程
-T	显示每个系统调用的执行耗时（单位：秒）
-tt	每行开头输出精确到微秒的时间戳
-e  fdatasync	过滤规则：只捕获 fdatasync 系统调用，忽略其他调用


# 由于这两个容器共享同⼀个⽹络命名空间，所以我们只需要进⼊app的⽹络命名空间即可
PID=$(docker inspect --format {{.State.Pid}} app)
# -i表⽰显⽰⽹络套接字信息
nsenter --target $PID --net -- lsof -i
参数	说明
nsenter	进入指定进程的命名空间执行命令，容器 / 网络隔离场景专用
--target $PID	以 $PID 进程为目标，继承它的命名空间
--net	只进入网络命名空间（隔离网卡、IP、路由、端口、套接字）
--	分隔符，后面接要执行的命令
lsof -i	查看当前网络套接字、监听端口、网络连接


# 更改redis配置
docker exec -it redis redis-cli config set appendfsync everysec

#还有一个问题修改源码了
https://github.com/feiskyer/linux-perf-examples/blob/master/redis-slow/app.py

#修改代码的接口  这个接口来访问它。
curl  http://10.0.0.51:10000/get_cache_data 

docker rm -f app redis
```



# 套路篇：如何迅速分析出系统IO的瓶颈在哪里？





根据指标找工具（文件系统和磁盘 I/O）

| 性能指标                                                     | 工具                       | 说明                                           |
| ------------------------------------------------------------ | -------------------------- | ---------------------------------------------- |
| 文件系统空间容量、使用量以及剩余空间                         | df                         | 详细文档见 info coreutils ’df invocation’      |
| 索引节点容量、使用量以及剩余量                               | df                         | 使用 -i 选项                                   |
| 页缓存和可回收 Slab 缓存                                     | /proc/meminfo、sar、vmstat | 使用 sar -r 选项                               |
| 缓冲区                                                       | /proc/meminfo、sar、vmstat | 使用 sar -r 选项                               |
| 目录项、索引节点以及文件系统的缓存                           | /proc/slabinfo、slabtop    | slabtop 更直观                                 |
| 磁盘 I/O 使用率、IOPS、吞吐量、响应时间、I/O 平均大小以及等待队列长度 | iostat、sar、dstat         | 使用 iostat -d -x 或 sar -d 选项               |
| 进程 I/O 大小以及 I/O 延迟                                   | pidstat、iotop             | 使用 pidstat -d 选项                           |
| 块设备 I/O 事件跟踪                                          | blktrace                   | 示例：`blktrace -d /dev/sda -o-| blkparse -i-` |
| 进程 I/O 系统调用跟踪                                        | strace                     | 通过系统调用跟踪进程的 I/O                     |
| 进程块设备 I/O 大小跟踪                                      | biosnoop、biotop           | 需要安装 bcc 软件包                            |



根据工具查指标（文件系统和磁盘 I/O）

| 性能工具        | 性能指标                                                     |
| --------------- | ------------------------------------------------------------ |
| iostat          | 磁盘 I/O 使用率、IOPS、吞吐量、响应时间、I/O 平均大小以及等待队列长度 |
| pidstat         | 进程 I/O 大小以及 I/O 延迟                                   |
| sar             | 磁盘 I/O 使用率、IOPS、吞吐量以及响应时间                    |
| dstat           | 磁盘 I/O 使用率、IOPS 以及吞吐量                             |
| iotop           | 按 I/O 大小对进程排序                                        |
| slabtop         | 目录项、索引节点以及文件系统的缓存                           |
| /proc/slabinfo  | 目录项、索引节点以及文件系统的缓存                           |
| /proc/meminfo   | 页缓存和可回收 Slab 缓存                                     |
| /proc/diskstats | 磁盘的 IOPS、吞吐量以及延迟                                  |
| /proc/pid/io    | 进程 IOPS、I/O 大小以及 I/O 延迟                             |
| vmstat          | 缓存和缓冲区用量汇总                                         |
| blktrace        | 跟踪块设备 I/O 事件                                          |
| biosnoop        | 跟踪进程的块设备 I/O 大小                                    |
| biotop          | 跟踪进程块 I/O 并按 I/O 大小排序                             |
| strace          | 跟踪进程的 I/O 系统调用                                      |
| perf            | 跟踪内核中的 I/O 事件                                        |
| df              | 磁盘空间和索引节点使用量和剩余量                             |
| mount           | 文件系统的挂载路径以及挂载参数                               |
| du              | 目录占用的磁盘空间大小                                       |
| tune2fs         | 显示和设置文件系统参数                                       |
| hdparam         | 显示和设置磁盘参数                                           |



如何迅速分析I/O的性能瓶颈

1.	 先用iostat发现磁盘I/O性能瓶颈；
2.	 再借助pidstat，定位出导致瓶颈的进程；
3.	 随后分析进程的I/O行为；
4.	 最后，结合应用程序的原理，分析这些I/O的来源

iostat、vmstat、pidstat	是最核心的几个性能工具，



# Linux 系统 IO 瓶颈快速分析指南

## 一、核心性能指标（分文件系统 + 磁盘）

### 1. 文件系统 I/O 性能指标

| 指标类别       | 核心指标                | 异常阈值             | 说明                                      |                |
| :------------- | :---------------------- | :------------------- | :---------------------------------------- | :------------- |
| **空间容量**   | 磁盘使用率              | >85% 预警，>95% 严重 | `df -h` 查看                              |                |
|                | 索引节点 (inode) 使用率 | >80% 预警            | `df -i` 查看，小文件过多会耗尽 inode      |                |
| **缓存性能**   | Page Cache 命中率       | <90% 异常            | 读性能差的核心原因                        |                |
|                | Slab 缓存占用           | 超过可用内存 30%     | `slabtop` 查看，目录项 / 索引节点缓存泄露 |                |
|                | 脏页占比                | >10% 会触发刷盘抖动  | `cat /proc/vmstat                         | grep nr_dirty` |
| **IO 延迟**    | 文件系统读写延迟        | 读 > 20ms，写 > 50ms | 包含内核缓存、文件系统开销                |                |
| **元数据性能** | 元数据操作耗时          | stat/ls 命令卡顿     | 目录项过多、文件系统碎片导致              |                |

### 2. 磁盘 I/O 性能指标（最核心）

| 指标                          | 异常阈值               | 说明                                                         |
| :---------------------------- | :--------------------- | :----------------------------------------------------------- |
| **% util（磁盘繁忙率）**      | HDD>80%，NVMe>90%      | 磁盘处理 IO 的时间占比；**注意：NVMe 多队列盘 100% 不一定饱和** |
| **await（平均 IO 等待时间）** | >10ms 拥堵，>50ms 严重 | 包含队列等待 + 磁盘处理时间，最直观的延迟指标                |
| **r_await/w_await**           | 读 > 10ms，写 > 20ms   | 区分读写延迟，定位是读瓶颈还是写瓶颈                         |
| **aqu-sz（平均队列长度）**    | >2 拥堵，>5 严重       | 等待处理的 IO 请求数，队列越长阻塞越严重                     |
| **IOPS**                      | 低于磁盘标称值         | HDD 随机 IOPS≈100-200，SATA SSD≈1 万 - 5 万，NVMe≈10 万 +    |
| **吞吐量**                    | 低于磁盘标称带宽       | HDD≈100-200MB/s，SATA SSD≈500MB/s，NVMe≈3-7GB/s              |
| **rrqm/s/wrqm/s**             | 合并率 < 30%           | 说明大量随机小 IO，内核无法有效合并                          |

## 二、核心性能工具速查（按排查顺序）

### 1. 全局磁盘 IO 概览（第一步必用）

| 工具   | 常用命令         | 能查什么                                       |
| :----- | :--------------- | :--------------------------------------------- |
| iostat | `iostat -d -x 1` | 所有磁盘的使用率、IOPS、吞吐量、延迟、队列长度 |
| vmstat | `vmstat 1`       | 全局 IO 等待（% iowait）、缓存、块设备读写总量 |
| sar    | `sar -d 1`       | 历史 IO 数据回放，排查周期性问题               |

### 2. 进程级 IO 定位（找到哪个进程在搞事）

| 工具    | 常用命令       | 能查什么                                 |
| :------ | :------------- | :--------------------------------------- |
| iotop   | `iotop -o`     | 实时按 IO 大小排序进程，显示磁盘读写速率 |
| pidstat | `pidstat -d 1` | 每个进程的 IO 读写量、IO 延迟、IO 使用率 |
| lsof    | `lsof -p PID`  | 查看进程打开的文件、套接字、设备句柄     |

### 3. 内核级 IO 跟踪（深入底层行为）

| 工具       | 常用命令                                               | 能查什么                                        |                                            |
| :--------- | :----------------------------------------------------- | :---------------------------------------------- | :----------------------------------------- |
| strace     | `strace -f -p PID -e trace=read,write,fsync,fdatasync` | 跟踪进程的 IO 系统调用，统计调用次数和耗时      |                                            |
| blktrace   | `blktrace -d /dev/sda -o-                              | blkparse -i-`                                   | 跟踪块设备层所有 IO 事件，分析 IO 队列行为 |
| bcc 工具集 | `biosnoop`/`biotop`/`filetop`                          | 精确跟踪每个进程的块设备 IO、文件 IO 大小和延迟 |                                            |
| perf       | `perf trace -e syscalls:*read* -p PID`                 | 低开销跟踪内核 IO 事件                          |                                            |

### 4. 文件系统专用工具

| 工具    | 常用命令        | 能查什么                                       |
| :------ | :-------------- | :--------------------------------------------- |
| df      | `df -h`/`df -i` | 磁盘空间和 inode 使用率                        |
| du      | `du -sh *`      | 目录占用磁盘空间大小                           |
| slabtop | `slabtop`       | 内核 Slab 缓存使用情况，定位元数据缓存泄露     |
| mount   | `mount`         | 查看文件系统挂载参数（如 noatime、barrier 等） |

## 三、标准 IO 瓶颈分析流程（5 步走）

### 第一步：确认系统是否存在 IO 瓶颈

1. 执行 vmstat   1，看 %iowait列
   - % iowait > 30%：系统存在明显 IO 瓶颈
   - % iowait > 50%：IO 严重阻塞，CPU 大部分时间在等磁盘
2. 同时看 procs b列（阻塞在 IO 的进程数）
   - 持续大于 CPU 核心数：IO 队列严重拥堵

### 第二步：定位哪个磁盘有问题

执行 `iostat -d -x 1`，重点看：

1. 哪个磁盘的 **%util** 最高
2. 该磁盘的 **await**、**aqu-sz** 是否超标
3. 区分是读瓶颈（r_await 高）还是写瓶颈（w_await 高）
4. 看 **rrqm/s/wrqm/s**，判断是随机 IO 还是顺序 IO

### 第三步：找到占用 IO 最多的进程

1. 执行 `iotop -o`，实时看哪个进程的 **DISK READ/DISK WRITE** 最高
2. 执行 `pidstat -d 1`，统计每个进程的 IO 读写量和延迟
3. 记录高 IO 进程的 PID

### 第四步：分析进程的 IO 行为

1. 查看进程打开的文件：`lsof -p PID`

2. 跟踪进程的 IO 系统调用：

   ```
   # 跟踪读写和刷盘调用，统计耗时
   strace -f -p PID -T -tt -e trace=read,write,fsync,fdatasync
   ```

3. 查看进程的 IO 统计：`cat /proc/PID/io`

### 第五步：深入内核层验证

如果需要更精确的底层数据：

- 用 `biosnoop` 查看每个 IO 请求的进程、大小、延迟
- 用 `blktrace` 分析块设备层的 IO 队列和调度行为
- 用 `slabtop` 检查是否存在元数据缓存泄露

## 四、常见 IO 瓶颈的典型特征

| 瓶颈类型       | 典型指标异常                            | 常见原因                               |
| :------------- | :-------------------------------------- | :------------------------------------- |
| 随机小 IO 瓶颈 | await 高、% util 高、IOPS 低、rrqm/s 低 | 数据库随机读写、大量小文件操作         |
| 顺序大 IO 瓶颈 | 吞吐量跑满、% util 高、await 正常       | 备份、日志切割、大文件拷贝             |
| 写刷盘抖动     | w_await 突然飙升、% util 瞬间 100%      | 脏页集中刷盘、fsync/fdatasync 频繁调用 |
| 缓存命中率低   | 读 IOPS 高、Page Cache 命中率低         | 冷数据访问、缓存配置不合理             |
| 元数据瓶颈     | ls/stat 命令卡顿、slab 占用高           | 目录下文件过多、inode 缓存泄露         |
| 磁盘硬件故障   | % util 持续 100%、await>1000ms、IO 错误 | 磁盘坏道、阵列卡故障、线缆问题         |





# 磁盘io 优化的几个思路



## fio（Flexible I/O Tester）正是最常用的文件系统和磁盘I/O性能基准测试工具

```bash
#	Ubuntu
apt-get	install	-y fio
#	CentOS
yum	install	-y fio	


# 随机读
fio -name=randread -direct=1 -iodepth=64 -rw=randread -ioengine=libaio -bs=4k -size=1G -numjobs=1 -runtime=1000 -group_reporting -filename=/dev/sdb
# 随机写
fio -name=randwrite -direct=1 -iodepth=64 -rw=randwrite -ioengine=libaio -bs=4k -size=1G -numjobs=1 -runtime=1000 -group_reporting -filename=/dev/sdb
# 顺序读
fio -name=read -direct=1 -iodepth=64 -rw=read -ioengine=libaio -bs=4k -size=1G -numjobs=1 -runtime=1000 -group_reporting -filename=/dev/sdb
# 顺序写
fio -name=write -direct=1 -iodepth=64 -rw=write -ioengine=libaio -bs=4k -size=1G -numjobs=1 -runtime=1000 -group_reporting


direct，表示是否跳过系统缓存。上面示例中，我设置的 1 ，就表示跳过系统缓存。
iodepth，表示使用异步 I/O（asynchronous I/O，简称AIO）时，同时发出的 I/O 请求上限。在上面的示例中，我设置的是 64。
rw，表示 I/O 模式。我的示例中， read/write 分别表示顺序读/写，而 randread/randwrite 则分别表示随机读/写。
ioengine，表示 I/O 引擎，它支持同步（sync）、异步（libaio）、内存映射（mmap）、网络（net）等各种 I/O 引擎。上面示例中，我设置的 libaio 表示使用异步 I/O。
bs，表示 I/O 的大小。示例中，我设置成了 4K（这也是默认值）。
filename，表示文件路径，当然，它可以是磁盘路径（测试磁盘性能），也可以是文件路径（测试文件系统性能）。示例中，我把它设置成了磁盘 /dev/sdb。不过注意，用磁盘路径测试写，会破坏这个磁盘中的文件系统，所以在使用前，你一定要事先做好数据备份。

#	使⽤blktrace跟踪磁盘I/O，注意指定应⽤程序正在操作的磁盘
blktrace /dev/sdb
#	查看blktrace记录的结果
#	ls
sdb.blktrace.0		sdb.blktrace.1
#	将结果转化为⼆进制⽂件
blkparse sdb -d sdb.bin
#	使⽤fio重放⽇志
fio --name=replay --filename=/dev/sdb --direct=1 --read_iolog=sdb.bin	

```



## 应用程序I/O 优化（7 条精简版）

1. 优先使用**追加写**替代随机写，减少磁盘寻址开销，提升写入效率。
2. 合理利用操作系统缓存，减少下发到物理磁盘的 I/O 次数。
3. 自建应用缓存或引入 Redis 等外部缓存，自主管理缓存生命周期，避免其他程序抢占系统缓存影响性能；优先使用 `fopen/fread` 等带库缓存的函数，而非直接调用 `open/read` 系统调用。
4. 针对同一片区域频繁读写的场景，用 `mmap` 替代 `read/write`，减少内存数据拷贝。
5. 同步写场景下合并零散写请求，使用 `fsync()` 代替 `O_SYNC`，避免单次请求频繁落盘。
6. 多应用共享磁盘时，通过 **cgroups IO 子系统** 限制进程 / 进程组的 IOPS 和吞吐量，防止 IO 资源被独占。
7. 磁盘使用 CFQ 调度器时，借助 `ionice` 调整进程 I/O 优先级；该工具包含 Idle、Best-effort、Realtime 三类优先级，后两者支持 0~7 分级，**数值越小优先级越高**。



## 文件系统 I/O 优化 精简总结

1. **按需选型文件系统**：根据负载选择适配类型，ext4 支持分区收缩，xfs 支持超大分区与海量文件，无法收缩。

2. **调整文件系统配置**：通过 `tune2fs` 修改文件系统特性，借助 `mount` 或 `/etc/fstab` 调整日志模式、挂载参数（如 `noatime`）。

3. **优化内核缓存参数**：修改脏页刷新频率、占用阈值相关参数；调整 `vfs_cache_pressure`，控制目录项、索引节点缓存的回收力度。

   ```
   比如，你可以优化pdflush	脏页的刷新频率（比如设置dirty_expire_centisecs	和 dirty_writeback_centisecs）以及脏页的限额（比如调整dirty_background_ratio和dirty_ratio等）。
   
   还可以优化内核回收目录项缓存和索引节点缓存的倾向，即调整vfs_cache_pressure（/proc/sys/vm/vfs_cache_pressure，默认值100），数值越大，就表示越容易回收。
   ```

   

4. **使用内存文件系统**：无需数据持久化时，采用 `tmpfs`（如 `/dev/shm`），数据存放于内存，大幅提升 I/O 性能。

## 磁盘层 I/O 优化（7 条精简版）

1. 升级硬件，使用 **SSD** 替换传统机械盘 HDD，从底层提升读写性能。

2. 搭建 **RAID 磁盘阵列**，同时实现数据冗余备份与整体 I/O 性能提升。

3. 根据磁盘类型与业务负载选择适配的 I/O 调度算法，SSD / 虚拟机磁盘推荐 `noop`，数据库场景推荐 `deadline`。

4. 做磁盘资源隔离，将日志、数据库等高 I/O 业务部署在独立磁盘，避免相互争抢资源。

5. 顺序读居多的场景，调大磁盘预读大小，优化读取效率。

   ```
   调整内核选项 /sys/block/sdb/queue/read_ahead_kb，默认大小是 128 KB，单位为KB。
   
   使用 blockdev 工具设置，比如 blockdev --setra 8192 /dev/sdb，注意这里的单位是 512B（0.5KB），所以它的数值总是 read_ahead_kb 的两倍
   ```

   

6. 调整内核块设备参数，修改磁盘队列长度 `nr_requests`，权衡吞吐量与 I/O 延迟。

   ```
   调整磁盘队列的长度
   /sys/block/sdb/queue/nr_requests，适当增大队列长度，可以提升磁盘的吞吐量（当然也会致 I/O 延迟增大）
   ```

   

7. 定期检测磁盘硬件与文件系统故障，通过 `dmesg`、`smartctl`、`badblocks`、`fsck` 等工具排查并修复问题



# 关于Linux网络，你必须知道这些

开放式系统互联通信参考模型（Open System Interconnection ReferenceModel），

简称为OSI网络模型。

- 应用层，负责为应用程序提供统一的接口。
- 表示层，负责把数据转换成兼容接收系统的格式。
- 会话层，负责维护计算机之间的通信连接。
- 传输层，负责为数据加上传输表头，形成数据包。
- 网络层，负责数据的路由和转发。
- 数据链路层，负责MAC寻址、错误侦测和改错。
- 物理层，负责在物理网络中传输数据帧。



在Linux中，使用的是另一个更实用的四层模型，即TCP/IP网络模型。

- 应用层，负责向用户提供一组应用程序，比如	HTTP、FTP、DNS	等。
- 传输层，负责端到端的通信，比如	TCP、UDP	等。
- 网络层，负责网络包的封装、寻址和路由，比如 IP、ICMP 等。
- 网络接口层，负责网络包在物理网络中的传输，比如 MAC 寻址、错误侦测以及通过网卡传输网络帧等。

| OSI 模型 |            | TCP/IP 模型 |            |
| -------- | ---------- | ----------- | ---------- |
| 层级     | 层名称     | 层级        | 层名称     |
| 7        | 应用层     | 4           | 应用层     |
| 6        | 表示层     | -           | -          |
| 5        | 会话层     | -           | -          |
| 4        | 传输层     | 3           | 传输层     |
| 3        | 网络层     | 2           | 网络层     |
| 2        | 数据链路层 | 1           | 网络接口层 |
| 1        | 物理层     | -           | -          |



### 网络四大核心指标（精简版）

1. **带宽**：链路理论最大传输速率，单位 b/s（比特 / 秒）。
2. **吞吐量**：单位时间实际成功传输的数据量，单位 b/s 或 B/s，受带宽约束；吞吐量 / 带宽 = 网络使用率。
3. **延时**：请求发出到收到响应的耗时，常见包含 TCP 握手时延、数据包往返时间（RTT）。
4. **PPS**：**全称**：**Packets Per Second** **中文**：**每秒数据包数** 每秒转发数据包数量，用于衡量设备报文转发能力，Linux 转发性能易受包大小影响。



网络配置

```bash
ifconfig和ip	分别属于软件包	net-tools和iproute2，iproute2	是net-tools的下一代
ifconfig ens33
ip -s addr show dev ens33

errors 表示发生错误的数据包数，比如校验错误、帧同步错误等；
dropped 表示丢弃的数据包数，即数据包已经收到了 Ring Buffer，但因为内存不足等原因丢包；
overruns 表示超限数据包数，即网络 I/O 速度过快，导致 Ring Buffer 中的数据包来不及处理（队列满）而导致的丢包；
carrier 表示发生 carrirer 错误的数据包数，比如双工模式不匹配、物理电缆出现问题等；
collisions 表示碰撞数据包数。


ifconfig 和 ip 只显示了网络接口收发数据包的统计信息
netstat 或者 ss ，来查看套接字、网络栈、网络接口以及路由表的信息

推荐使用ss来查询网络的连接信息，因为它比netstat提供了更好的性能（速度更快）。
#	-l	表⽰只显⽰监听套接字
#	-t	表⽰只显⽰	TCP	套接字
#	-n	表⽰显⽰数字地址和端⼝(⽽不是名字)
#	-p	表⽰显⽰进程信息
ss -ltnp | head -n 3




# 协议栈统计信息
root@ubuntu:~# netstat -s
Ip:
    Forwarding: 1                  # 已开启IP转发功能，本机可作为路由转发数据包
    392 total packets received     # 本机网卡累计接收IP数据包总数 392 个
    0 forwarded                    # 转发出去的IP数据包数量为 0
    0 incoming packets discarded  # 入站IP包无丢弃
    392 incoming packets delivered # 接收的IP包全部递交给上层协议处理
    245 requests sent out          # 本机主动发出的IP请求包共 245 个
    20 outgoing packets dropped   # 出站IP包被丢弃 20 个

Icmp:
    40 ICMP messages received      # 累计接收 ICMP 报文 40 个
    0 input ICMP message failed    # 接收 ICMP 报文无解析/处理错误
    ICMP input histogram: # 直译：ICMP 接收报文类型统计直方图 ，简单理解：按报文类型，统计本机收到的各类 ICMP 报文数量。
        destination unreachable: 40 # 收到 40 个「目标不可达」类型 ICMP 报文
    40 ICMP messages sent          # 累计发送 ICMP 报文 40 个
    0 ICMP messages failed        # 发送 ICMP 报文无失败
    ICMP output histogram:
        destination unreachable: 40 # 向外发送 40 个「目标不可达」ICMP 应答

IcmpMsg:
        InType3: 40                # 接收 Type3（目标不可达）ICMP 报文 40 条
        OutType3: 40               # 发送 Type3（目标不可达）ICMP 报文 40 条

Tcp:
    0 active connection openings   # 主动发起的 TCP 连接数 0
    1 passive connection openings   # 被动监听并接受的 TCP 连接数 1
    0 failed connection attempts   # TCP 连接尝试失败次数 0
    0 connection resets received   # 收到 TCP 连接重置报文次数 0
    1 connections established      # 成功建立的 TCP 连接总数 1
    246 segments received          # 接收 TCP 数据分片共 246 个
    151 segments sent out          # 发送 TCP 数据分片共 151 个
    0 segments retransmitted      # TCP 报文重传次数 0（链路无丢包抖动）
    0 bad segments received        # 收到损坏/非法 TCP 分片数 0
    0 resets sent                  # 主动发送 TCP 连接重置报文数 0

Udp:
    14 packets received            # 接收 UDP 数据包共 14 个
    40 packets to unknown port received # 收到 40 个访问本机未监听UDP端口的报文
    0 packet receive errors        # UDP 报文接收错误数 0
    54 packets sent                # 发送 UDP 数据包共 54 个
    0 receive buffer errors        # UDP 接收缓冲区无溢出/异常错误
    0 send buffer errors           # UDP 发送缓冲区无溢出/异常错误
    IgnoredMulti: 52               # 忽略的组播数据包数量 52

UdpLite:                           # 未启用 UDP Lite 协议，无统计数据
# 轻量化 UDP，仅做部分校验，多用于流媒体；你当前机器无相关流量。

TcpExt:   #TCP Extended Statistics（TCP 扩展统计）
    1 delayed acks sent            # 发送延迟应答（Delayed ACK）次数 1
    73 packet headers predicted    # 内核预测报文头，优化接收效率的次数 73
    24 acknowledgments not containing data payload received # 收到纯ACK报文24 个
    101 predicted acknowledgments  # 内核预测应答，提升传输效率次数 101
    TCPOrigDataSent: 151           # TCP 原始数据报文发送总数 151

IpExt:
    InBcastPkts: 52                # 接收广播包总数 52 个
    InOctets: 29266                # 入站IP数据总字节数 29266
    OutOctets: 27503               # 出站IP数据总字节数 27503
    InBcastOctets: 5113            # 接收广播数据总字节数 5113
    InNoECTPkts: 392               # 不支持显式拥塞标记(ECT)的入站IP包总数 392


root@ubuntu:~# ss -s
Total: 515 (kernel 1886)                     
# 用户态视角套接字总数 515 个；内核层面统计网络套接字及关联结构共 1886 个（内核统计包含底层附属结构，数值更大）
TCP:   5 (estab 1, closed 0, orphaned 0, synrecv 0, timewait 0/0), ports 0  
# TCP 套接字总计 5 个；
# 已建立连接(estab)1个，已关闭连接0个，孤儿连接0个，半连接(synrecv)0个，TIME_WAIT状态连接0个；当前无监听端口占用统计

Transport Total     IP        IPv6          # 表头：传输类型 | 总数量 | IPv4 数量 | IPv6 数量
*         1886      -         -             # 所有内核网络结构合计 1886 个，不区分 IPv4/IPv6
RAW       1         0         1             # 原始套接字(RAW)共 1 个；IPv4 RAW 0 个，IPv6 RAW 1 个
UDP       1         1         0             # UDP 套接字共 1 个；IPv4 UDP 1 个，IPv6 UDP 0 个
TCP       5         4         1             # TCP 套接字共 5 个；IPv4 TCP 4 个，IPv6 TCP 1 个
INET      7         5         2             # 全称：Internet Domain（互联网域） 互联网域套接字(TCP/UDP/RAW统称)合计 7 个；IPv4 总计 5 个，IPv6 总计 2 个
FRAG      0         0         0             # 全称：IP Fragment（IP 分片） IP 分片重组相关资源数量，当前全为 0，无分片任务

补充关键字段说明（方便排障）
estab：TCP 正常已连接状态，业务正常通信依赖该状态
orphaned：孤儿连接，异常断开、内核未正常回收的 TCP 连接，非 0 代表存在连接泄露
synrecv：TCP 半连接（收到客户端 SYN、未完成三次握手），数量持续走高大概率遭遇 SYN 攻击
timewait 0/0：timewait 数量 / 系统阈值，大量 TIME_WAIT 会占用端口与内核资源
RAW 套接字：常用于抓包、网络调试、自定义协议，普通业务极少使用


网络吞吐和 PPS
# 数字1表⽰每隔1秒输出⼀组数据
# 比如网络接口（DEV）、网络接口错误（EDEV）、TCP、UDP、ICMP 等等
sar -n DEV 1

root@ubuntu:~# sar -n DEV 1
Linux 4.15.0-156-generic (ubuntu)       05/29/26        _x86_64_        (2 CPU)
21:08:14        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
# 时间          网卡名    接收PPS    发送PPS    接收流量   发送流量  接收压缩包  发送压缩包 接收组播包   网卡利用率
21:08:15           lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
21:08:15        ens33      0.99      0.00      0.06      0.00      0.00      0.00      0.00      0.00

字段	   全称 / 含义	                  解释
IFACE	Interface（网络接口）	          网卡名称（lo = 本地回环网卡，ens33 = 物理网卡）
rxpck/s	receive packets per second	  每秒接收的数据包数（接收 PPS）
txpck/s	transmit packets per second	  每秒发送的数据包数（发送 PPS）
rxkB/s	receive KB per second	      每秒接收的数据量（单位：KB）
txkB/s	transmit KB per second	      每秒发送的数据量（单位：KB）
rxcmp/s	receive compressed packets	  每秒接收的压缩数据包数（几乎不用）
txcmp/s	transmit compressed packets	  每秒发送的压缩数据包数（几乎不用）
rxmcst/s	receive multicast packets 每秒接收的组播数据包数
%ifutil	interface utilization	      网卡带宽使用率



root@ubuntu:~# ethtool ens33
Settings for ens33:                 # ens33 网卡的配置详情
        Supported ports: [ TP ]     # 支持的端口类型：TP = 双绞线（普通网线口）
        Supported link modes:       # 网卡硬件支持的速率+双工模式
                                10baseT/Half 10baseT/Full  # 支持10M半双工、10M全双工
                                100baseT/Half 100baseT/Full # 支持100M半双工、100M全双工
                                1000baseT/Full              # 支持1000M(1G)全双工
        Supported pause frame use: No  # 不支持流量控制暂停帧
        Supports auto-negotiation: Yes # 硬件支持【速率自动协商】
        Supported FEC modes: Not reported # 不支持前向纠错(FEC)
        Advertised link modes:      # 网卡对外广播的支持模式（和上面一致）
                                10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Advertised pause frame use: No  # 对外声明不使用暂停帧
        Advertised auto-negotiation: Yes # 对外声明开启自动协商
        Advertised FEC modes: Not reported # 对外声明不支持FEC
        Speed: 1000Mb/s             # 当前网卡速率：1000兆（1Gbps）****
        Duplex: Full                # 当前双工模式：全双工（可同时收发数据） *****
        Port: Twisted Pair          # 端口类型：双绞线（普通网线）
        PHYAD: 0                    # 物理层地址（驱动内部参数，无需管）
        Transceiver: internal       # 收发器：内置集成在网卡上
        Auto-negotiation: on        # 速率自动协商：开启（正常默认状态）
        MDI-X: off (auto)           # 网线线序自动翻转：关闭（自动模式）
        Supports Wake-on: d         # 支持网络唤醒功能：d=禁用
        Wake-on: d                  # 当前网络唤醒状态：禁用
        Current message level: 0x00000007 (7) # 网卡日志级别
                               drv probe link # 日志包含：驱动、探测、链路状态
        Link detected: yes          # 链路状态：已连接（网线插好、正常连通）  *****


连通性和延时
#	-c3表⽰发送三次ICMP包后停⽌
ping -c3 114.114.114.114

# 执行ping命令，-c3 表示只发送3个探测包，目标IP 223.5.5.5（阿里云公共DNS）
root@ubuntu:~# ping -c3 223.5.5.5  
PING 223.5.5.5 (223.5.5.5) 56(84) bytes of data. # 开始ping，目标IP 223.5.5.5，发送56字节数据（总报文84字节）
64 bytes from 223.5.5.5: icmp_seq=1 ttl=128 time=34.2 ms # 收到第1个响应包：64字节，ICMP序号1，TTL=128，延迟34.2毫秒
64 bytes from 223.5.5.5: icmp_seq=2 ttl=128 time=34.4 ms # 收到第2个响应包：64字节，ICMP序号2，TTL=128，延迟34.4毫秒
64 bytes from 223.5.5.5: icmp_seq=3 ttl=128 time=34.5 ms # 收到第3个响应包：64字节，ICMP序号3，TTL=128，延迟34.5毫秒

icmp_seq：数据包序号（1/2/3 代表第几个包）
ttl：数据包生存时间（不用深究，代表网络路由层级）
time=34.2ms：网络延迟，数值越小网速越快




```



# 基础篇：C10K和C1000K回顾

C10K和C1000K的首字母C是Client的缩写。

C10K就是单机同时处理1万个请求（并发连接1万）的问题,

C1000K也就是单机支持处理100万个请求（并发连接100万）的问题。

## 一、C10K 问题

**定义**：解决 **Linux 单机同时处理 10000 个网络连接** 的性能瓶颈问题

核心痛点：传统 I/O 模型 + 工作模型，资源占用极高，无法支撑万级并发

### 1. I/O 模型优化（核心）

抛弃低效率的阻塞 I/O，转向**高性能 I/O 方案**：

1. 非阻塞 I/O + I/O 多路复用
2. 淘汰低效的 `select/poll`（连接数受限、遍历开销大）
3. 使用 **epoll**（Linux 专属，事件通知、无遍历损耗，支撑万级连接）

### 2. 工作模型优化

抛弃高开销的多进程 / 多线程模型：

1. 单线程 **Reactor 事件驱动模型**（Nginx、Redis 核心架构）
2. 线程池协程化，避免线程上下文切换损耗
3. 一个线程管理海量连接，仅在有 I/O 事件时处理

------

## 二、C1000K 问题

**定义**：解决 **Linux 单机同时处理 1000000 个网络连接** 的进阶问题

核心：C10K 仅优化应用层，C1000K 需要**应用 + 内核 + 网络 + 硬件**全栈优化

### 核心优化方向

1. 内核参数极致调优

   调整端口范围、TCP 队列、Socket 缓冲区、文件句柄上限，突破系统限制

2. 网卡与中断优化

   网卡多队列、RPS/RFS 负载均衡、CPU 中断绑定，消除单核瓶颈

3. I/O 模型极致优化

   epoll 边缘触发（ET）、零拷贝技术，减少数据拷贝与内核开销

4. 内核旁路技术

   DPDK、XDP 直接绕过内核协议栈，由用户态直接处理网卡数据

5. 工作模型升级

   主从 Reactor、多线程 Reactor，利用多核 CPU 并行处理

6. 硬件升级

   多核 CPU、万兆网卡、大内存，支撑百万级连接的资源消耗

------

## 三、一句话总结

- **C10K**：解决**万级并发**，核心是 **epoll + 事件驱动**，优化应用层 I/O
- **C1000K**：解决**百万级并发**，核心是 **全栈优化**（内核 + 网卡 + 应用 + 硬件）





# 怎么评估系统的网络性能？



性能指标回顾

第一： 带宽，表示链路的最大传输速率，单位是b/s（比特/秒）。在你为服务器选购网卡时，带宽就是最核
心的参考指标。常用的带宽有1000M、10G、40G、100G等。
第二，吞吐量，表示没有丢包时的最大数据传输速率，单位通常为b/s（比特/秒）或者B/s（字节/秒）。吞吐量受带宽的限制，吞吐量/带宽也就是该网络链路的使用率。
第三，延时，表示从网络请求发出后，一直到收到远端响应，所需要的时间延迟。这个指标在不同场景中可
能会有不同的含义。它可以表示建立连接需要的时间（比如TCP握手延时），或者一个数据包往返所需时
间（比如RTT）。
需要用	XDP	方式，在内核协议栈之前，先处理网络包。
或基于	DPDK	，直接跳过网络协议栈，在用户空间通过轮询的方式处理。

第四： PPS  是 Packet Per Second（包/秒）的缩写，表示以网络包为单位的传输速率。PPS 通常用来评估
网络的转发能力，而基于 Linux 服务器的转发，很容易受到网络包大小的影响（交换机通常不会受到太大影
响，即交换机可以线性转发）。



##转发性能

```BASH
 Linux内核自带的高性能网络测试工具pktgen
root@ubuntu:~# modprobe pktgen
root@ubuntu:~# ps -ef |grep pktgen | grep -v grep
root        970      2  0 10:22 ?        00:00:00 [kpktgend_0]
root        971      2  0 10:22 ?        00:00:00 [kpktgend_1]
root@ubuntu:~# ls /proc/net/pktgen/
kpktgend_0  kpktgend_1  pgctrl


#	定义⼀个⼯具函数，⽅便后⾯配置各种测试选项
function pgset() {
    local result
    echo $1 > $PGDEV
    result=`cat $PGDEV | fgrep "Result: OK:"`
    if [ "$result" = "" ]; then
    cat $PGDEV | fgrep Result:
    fi
}
# 为0号线程绑定ens33⽹卡
PGDEV=/proc/net/pktgen/kpktgend_0
pgset "rem_device_all" # 清空⽹卡绑定
pgset "add_device ens33" # 添加eth0⽹卡
# 配置ens33⽹卡的测试选项
PGDEV=/proc/net/pktgen/ens33
pgset "count 1000000" # 总发包数量
pgset "delay 5000" # 不同包之间的发送延迟(单位纳秒)
pgset "clone_skb 0" # SKB包复制
pgset "pkt_size 64" # ⽹络包⼤⼩
pgset "dst 10.0.0.51" # ⽬的IP
pgset "dst_mac 00:0c:29:51:5c:47" # ⽬的MAC
# 启动测试
PGDEV=/proc/net/pktgen/pgctrl
pgset "start"

root@ubuntu:~# cat /proc/net/pktgen/ens33
# 查看 ens33 网卡的内核发包工具 pktgen 配置、运行状态、测试结果

Params: count 1000000  min_pkt_size: 64  max_pkt_size: 64
     # 测试参数：计划发送 100万个 数据包，数据包大小固定为 64字节
     frags: 0  delay: 5000  clone_skb: 0  ifname: ens33
     # 分片数：0；发包间隔延迟：5000微秒；不克隆数据包；测试网卡：ens33
     flows: 0 flowlen: 0
     # 网络流数量：0，流长度：0（单流测试）
     queue_map_min: 0  queue_map_max: 0
     # 使用网卡队列：0号队列（单队列测试）
     dst_min: 10.0.0.51  dst_max:
     # 目标IP地址：固定为 10.0.0.51
     src_min:   src_max:
     # 未指定源IP范围
     src_mac: 00:0c:29:76:7c:11 dst_mac: 00:0c:29:51:5c:47
     # 源MAC地址、目标MAC地址
     udp_src_min: 9  udp_src_max: 9  udp_dst_min: 9  udp_dst_max: 9
     # UDP源端口、目标端口：均固定为 9
     src_mac_count: 0  dst_mac_count: 0
     # 源/目标MAC地址不动态变化
     Flags:
     # 无额外测试标记

Current:
     # 当前测试运行实时状态
     pkts-sofar: 1000000  errors: 0
     # 已成功发送 100万个 数据包，发包错误数：0
     started: 252328463us  stopped: 257330409us idle: 137971us
     # 测试开始时间、结束时间（内核微秒），空闲等待时间：137971微秒
     seq_num: 1000001  cur_dst_mac_offset: 0  cur_src_mac_offset: 0
     # 下一个数据包序号：1000001，MAC地址无偏移
     cur_saddr: 10.0.0.52  cur_daddr: 10.0.0.51
     # 当前实际源IP：10.0.0.52，目标IP：10.0.0.51
     cur_udp_dst: 9  cur_udp_src: 9
     # 当前使用的UDP端口：源/目标均为9
     cur_queue_map: 0
     # 当前使用网卡队列：0号
     flows: 0
     # 实时网络流数：0

Result: OK: 5001945(c4863974+d137971) usec, 1000000 (64byte,0frags)
     # 测试结果：成功；总耗时5001945微秒，发送100万个64字节无分片数据包
  199922pps 102Mb/sec (102360064bps) errors: 0
     # 核心性能：每秒发包199922个(PPS)，吞吐量102Mb/秒，无任何发包错误
```

## TCP/UDP	性能



```bash
iperf和netperf都是最常用的网络性能测试工具，测试TCP和UDP的吞吐量。

#	Ubuntu
apt-get	install	iperf3
#	CentOS
yum	install	iperf3


#  在目标机器10.0.0.52上启动	iperf	服务端：
# -s表⽰启动服务端，-i表⽰汇报间隔，-p表⽰监听端⼝
iperf3 -s -i 1 -p 10000


#	-c表⽰启动客⼾端，10.0.0.52为⽬标服务器的IP
#	-b表⽰⽬标带宽(单位是bits/s)
#	-t表⽰测试时间
#	-P表⽰并发数，-p表⽰⽬标服务器监听端⼝
iperf3 -c 10.0.0.52 -b 1G -t 15 -P 2 -p 10000


# 执行命令：iperf3客户端 连接10.0.0.52服务端，限速1G，测试15秒，2条并发流，端口10000
root@ubuntu:~# iperf3 -c 10.0.0.52 -b 1G -t 15 -P 2 -p 10000

Connecting to host 10.0.0.52, port 10000          # 正在连接服务端 10.0.0.52:10000
[  4] local 10.0.0.51 port 58774 connected to 10.0.0.52 port 10000  # 并发流4：本地连接成功
[  6] local 10.0.0.51 port 58776 connected to 10.0.0.52 port 10000  # 并发流6：本地连接成功

# 表头：线程ID | 时间区间 | 传输总量 | 带宽 | 重传数 | 拥塞窗口
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd

# ----------- 每秒实时统计 -----------
[  4]   0.00-1.00   sec  57.7 MBytes   484 Mbits/sec    0    189 KBytes  # 流4：1秒传57.7MB，带宽484Mbps
[  6]   0.00-1.00   sec  57.6 MBytes   483 Mbits/sec    0    201 KBytes  # 流6：1秒传57.6MB，带宽483Mbps
[SUM]   0.00-1.00   sec   115 MBytes   968 Mbits/sec    0               # 总流量：1秒968Mbps，0重传
- - - - - - - - - - - - - - - - - - - - - - - - -
[  4]   1.00-2.00   sec  71.0 MBytes   595 Mbits/sec    0    209 KBytes  # 流4：第2秒带宽595Mbps
[  6]   1.00-2.00   sec  70.8 MBytes   594 Mbits/sec    0    201 KBytes  # 流6：第2秒带宽594Mbps
[SUM]   1.00-2.00   sec   142 MBytes  1.19 Gbits/sec    0               # 总带宽：1.19Gbps
# 中间每秒统计逻辑完全一致，省略重复注释
- - - - - - - - - - - - - - - - - - - - - - - - -
[  4]  14.00-15.00  sec  67.5 MBytes   566 Mbits/sec    0    259 KBytes  # 流4：最后1秒带宽566Mbps
[  6]  14.00-15.00  sec  67.5 MBytes   566 Mbits/sec    0    293 KBytes  # 流6：最后1秒带宽566Mbps
[SUM]  14.00-15.00  sec   135 MBytes  1.13 Gbits/sec    0               # 最后1秒总带宽1.13Gbps

# ----------- 15秒最终汇总统计 -----------
[  4]   0.00-15.00  sec  1.02 GBytes   586 Mbits/sec    0             sender  
# 流4：发送端总数据1.02GB，0重传
[  4]   0.00-15.00  sec  1.02 GBytes   586 Mbits/sec                  receiver  
# 流4：接收端统计一致
[  6]   0.00-15.00  sec  1.02 GBytes   587 Mbits/sec    0             sender  
# 流6：发送端总数据1.02GB，0重传
[  6]   0.00-15.00  sec  1.02 GBytes   586 Mbits/sec                  receiver  
# 流6：接收端统计一致
[SUM]   0.00-15.00  sec  2.05 GBytes  1.17 Gbits/sec    0             sender  
# 【核心结果】总发送：2.05GB，1.17Gbps
[SUM]   0.00-15.00  sec  2.05 GBytes  1.17 Gbits/sec                  receiver 
# 接收端总带宽与发送端一致

iperf Done.  # 带宽测试完成

核心结果总结（最重要）
测试场景：双线程、15 秒、千兆带宽压力测试
总性能：1.17 Gbps（跑满千兆网卡，性能优异）
网络质量：0 重传、0 丢包、0 错误
结论：虚拟机 / 物理机之间的网络链路完全正常、性能拉满
```

### HTTP 性能

```bash
# Ubuntu
apt-get install -y apache2-utils
# CentOS
$ yum install -y httpd-tools

# 目标机器运行
docker run -p 80:80 -itd nginx

# 另一台客户端测试
# -c表⽰并发请求数为1000，-n表⽰总的请求数为10000
ab -c 1000 -n 10000 http://10.0.0.51/

# 执行压测命令：并发1000个请求，总发送10000个请求，测试 http://10.0.0.51/ 页面
root@ubuntu:~# ab -c 1000 -n 10000 http://10.0.0.51/

# ab工具版本信息
This is ApacheBench, Version 2.3 <$Revision: 1807734 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

# 开始压测 10.0.0.51 服务器（请等待）
Benchmarking 10.0.0.51 (be patient)
Completed 1000 requests  # 已完成1000个请求
Completed 2000 requests  # 已完成2000个请求
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests # 已完成全部10000个请求
Finished 10000 requests  # 压测结束

# 服务器基础信息
Server Software:        nginx/1.31.1  # 服务器软件：Nginx 1.31.1
Server Hostname:        10.0.0.51     # 服务器IP
Server Port:            80           # 服务器端口：HTTP默认80

Document Path:          /            # 测试的页面路径：根目录
Document Length:        896 bytes     # 页面大小：896字节

# 压测核心统计
Concurrency Level:      1000          # 并发数：1000（同时发送1000个请求）
Time taken for tests:   1.776 seconds # 压测总耗时：1.776秒
Complete requests:      10000         # 成功完成的请求数：10000
Failed requests:        0             # 失败请求数：0（无失败、无报错）
Total transferred:      11290000 bytes # 总传输数据量：11290000字节
HTML transferred:       8960000 bytes  # 页面正文传输量：8960000字节

# 最核心性能指标
Requests per second:    5631.72 [#/sec] (mean) # **QPS：每秒处理5631个请求**
Time per request:       177.566 [ms] (mean)    # 单个并发组的平均请求时间：177ms
Time per request:       0.178 [ms] (mean, across all concurrent requests) # 单请求平均耗时：0.178ms
Transfer rate:          6209.19 [Kbytes/sec] received # 传输速率：6209 KB/s

# 连接耗时统计（单位：毫秒）
Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   2.4      0      11  # 连接耗时：最小0，平均1，最大11
Processing:     4   55 222.6      9    1758  # 处理耗时：最小4，平均55，最大1758
Waiting:        4   55 222.6      9    1757  # 等待耗时：最小4，平均55，最大1757
Total:          4   56 224.1      9    1766  # 总耗时：最小4，平均56，最大1766

# 响应时间分布（关键：多少比例的请求在指定时间内完成）
Percentage of the requests served within a certain time (ms)
  50%      9    # 50%的请求 ≤9ms完成
  66%     10    # 66%的请求 ≤10ms完成
  75%     10    # 75%的请求 ≤10ms完成
  80%     11    # 80%的请求 ≤11ms完成
  90%     18    # 90%的请求 ≤18ms完成
  95%     40    # 95%的请求 ≤40ms完成
  98%    892    # 98%的请求 ≤892ms完成
  99%    907    # 99%的请求 ≤907ms完成
 100%   1766 (longest request) # 100%请求完成，最长耗时1766ms

```

## 应用负载性能

用iperf或者ab等测试工具，得到TCP、HTTP等的性能数据后，这些数据是否就能表示应用程序的实际性能呢？我想，你的答案应该是否定的。

为了得到应用程序的实际性能，就要求性能工具本身可以模拟用户的请求负载，而iperf、ab这类工具就无能为力了。幸运的是，我们还可以用wrk、TCPCopy、Jmeter或者LoadRunner等实现这个目标

✅ **开源免费（随便用、无版权、免费）**

1. **wrk**
2. **TCPCopy**
3. **JMeter**

💰 **商业收费（付费软件，极贵，企业专用）**

1. **LoadRunner**

以 wrk 为例，它是一个 HTTP 性能测试工具，内置了 LuaJIT，方便你根据实际需求，生成所需的请求负载，

或者自定义响应的处理方法。

```BASH
# https://github.com/wg/wrk
git clone https://github.com/wg/wrk.git
cd wrk
apt-get install build-essential unzip -y
make
cp wrk /usr/local/bin/


# -c表⽰并发连接数1000，-t表⽰线程数为2
# 用 wrk 压测：2线程，1000并发连接，测试 http://10.0.0.51/，默认压10秒
root@ubuntu:~# wrk -c 1000 -t 2 http://10.0.0.51/

Running 10s test @ http://10.0.0.51/     # 压测 10 秒钟
  2 threads and 1000 connections         # 2个压测线程，1000个并发连接

  Thread Stats   Avg      Stdev     Max   +/- Stdev
    # 线程统计：平均   标准差    最大值   正态分布比例
    Latency    50.74ms   83.41ms   1.98s    98.90%
    # 响应延迟：平均 50ms，最大 1.98s，98.9% 请求延迟很稳定

    Req/Sec     9.04k     3.38k   16.11k    67.50%
    # 每个线程每秒处理：平均 9040 请求

  179940 requests in 10.05s, 194.60MB read
  # 10秒总共处理：179940 个请求，传输 194MB

  Socket errors: connect 0, read 0, write 0, timeout 311
  # 套接字错误：连接0/读0/写0，超时 311 个（少量超时）

Requests/sec:  17906.16
# **核心性能：QPS = 17906**（每秒近 1.8 万请求）

Transfer/sec:     19.36MB   #吞吐量
# 每秒带宽：19.36 MB
```



# DNS解析时快时慢，我该怎么办？



```bash
root@ubuntu:~# nslookup time.geekbang.org
Server:         223.5.5.5
Address:        223.5.5.5#53

Non-authoritative answer:
Name:   time.geekbang.org
Address: 39.106.233.176


#  +trace：强制从根服务器开始，逐级追踪完整的DNS解析链路
#	+nodnssec表⽰禁⽌DNS安全扩展

root@ubuntu:~# dig +trace +nodnssec time.geekbang.org
该命令用于完整追踪DNS域名解析全过程，从根服务器逐级查询到最终IP地址

【第一阶段：查询根域名服务器（DNS顶层）】
; <<>> DiG 9.11.3-1ubuntu1.15-Ubuntu <<>> +trace +nodnssec time.geekbang.org
# dig工具版本信息与本次执行的完整命令
;; global options: +cmd
# dig工具的全局配置选项
.                       3433    IN      NS      i.root-servers.net.
# . 代表根域名，3433是DNS缓存TTL秒数，IN为互联网标准记录，NS为域名服务器记录，i.root-servers.net是根域名服务器
.                       3433    IN      NS      g.root-servers.net.
# 全球根域名服务器g
.                       3433    IN      NS      b.root-servers.net.
# 全球根域名服务器b
.                       3433    IN      NS      c.root-servers.net.
# 全球根域名服务器c
.                       3433    IN      NS      e.root-servers.net.
# 全球根域名服务器e
.                       3433    IN      NS      h.root-servers.net.
# 全球根域名服务器h
.                       3433    IN      NS      f.root-servers.net.
# 全球根域名服务器f
.                       3433    IN      NS      l.root-servers.net.
# 全球根域名服务器l
.                       3433    IN      NS      m.root-servers.net.
# 全球根域名服务器m
.                       3433    IN      NS      j.root-servers.net.
# 全球根域名服务器j
.                       3433    IN      NS      k.root-servers.net.
# 全球根域名服务器k
.                       3433    IN      NS      d.root-servers.net.
# 全球根域名服务器d
.                       3433    IN      NS      a.root-servers.net.
# 全球根域名服务器a（DNS全球共13台根域名服务器）
;; Received 444 bytes from 223.5.5.5#53(223.5.5.5) in 33 ms
# 从阿里云公共DNS 223.5.5.5的53端口获取根服务器列表，数据大小444字节，查询耗时33毫秒

【第二阶段：根服务器指引查询org顶级域名服务器】
org.                    172800  IN      NS      a2.org.afilias-nst.info.
# org为顶级域名，172800是缓存TTL秒数，NS为org域名的权威管理服务器
org.                    172800  IN      NS      b2.org.afilias-nst.org.
# org后缀的顶级域名管理服务器
org.                    172800  IN      NS      d0.org.afilias-nst.org.
# org后缀的顶级域名管理服务器
org.                    172800  IN      NS      a0.org.afilias-nst.info.
# org后缀的顶级域名管理服务器
org.                    172800  IN      NS      b0.org.afilias-nst.org.
# org后缀的顶级域名管理服务器
org.                    172800  IN      NS      c0.org.afilias-nst.info.
# org后缀的顶级域名管理服务器
;; Received 448 bytes from 198.41.0.4#53(a.root-servers.net) in 205 ms
# 从根服务器a.root-servers.net的53端口获取org顶级域服务器列表，数据大小448字节，耗时205毫秒

【第三阶段：org顶级域服务器指引查询geekbang.org权威DNS】
geekbang.org.           3600    IN      NS      dns10.hichina.com.
# geekbang.org为目标主域名，3600是缓存TTL秒数，NS为其官方权威DNS服务器（阿里云万网）
geekbang.org.           3600    IN      NS      dns9.hichina.com.
# geekbang.org的备用官方权威DNS服务器
;; Received 96 bytes from 199.19.54.1#53(b0.org.afilias-nst.org) in 201 ms
# 从org顶级域服务器b0.org.afilias-nst.org的53端口获取geekbang权威DNS，数据大小96字节，耗时201毫秒

【第四阶段：权威DNS返回最终IP地址，解析完成】
time.geekbang.org.      600     IN      A       39.106.233.176
# time.geekbang.org为查询的完整域名，600是缓存TTL秒数，A记录为IPv4地址记录，39.106.233.176是域名最终解析IP
;; Received 62 bytes from 39.96.153.41#53(dns10.hichina.com) in 37 ms
# 从阿里云dns10.hichina.com的53端口获取最终IP，数据大小62字节，查询耗时37毫秒

【核心术语解释】
NS记录：域名服务器记录，作用是逐级指引DNS查询方向
A记录：IPv4地址记录，存储域名对应的真实服务器IP地址
TTL：缓存生存时间，单位为秒，代表DNS记录的有效缓存时长



```





案例

```BASH
docker pull feisky/dnsutils

root@ubuntu:~# egrep -v '^#|^$' /etc/resolv.conf
nameserver 223.5.5.5

# 进⼊案例环境的SHELL终端中
docker run -it --rm -v $(mktemp):/etc/resolv.conf feisky/dnsutils bash
root@0794adb09619:/# nslookup time.geekbang.org 
#命令阻塞很久后，还是失败了，报了 connection timed out 和 no servers could bereached 错误。

ping 223.5.5.5 #是通的
root@0794adb09619:/#  nslookup -debug time.geekbang.org
;; Connection to 127.0.0.1#53(127.0.0.1) for time.geekbang.org failed: connection refused.
;; Connection to ::1#53(::1) for time.geekbang.org failed: address not available.
root@0794adb09619:/# cat /etc/resolv.conf
root@0794adb09619:/# echo "nameserver 223.5.5.5">/etc/resolv.conf


```

案例2 dns不稳定

```BASH
root@ubuntu:~# docker run -it --rm --cap-add=NET_ADMIN --dns 8.8.8.8 feisky/dnsutils bash
root@e6741ceae6b1:/# time nslookup time.geekbang.org
Server:         8.8.8.8
Address:        8.8.8.8#53

Non-authoritative answer:
Name:   time.geekbang.org
Address: 39.106.233.176


real    0m1.019s  #用了1秒， 有时间要10秒，有时候;; connection timed out; no servers could be reached
user    0m0.000s
sys     0m0.015s

root@e6741ceae6b1:/# ping -c3 8.8.8.8
PING 8.8.8.8 (8.8.8.8): 56 data bytes
64 bytes from 8.8.8.8: icmp_seq=0 ttl=127 time=251.171 ms  #延时比较大
64 bytes from 8.8.8.8: icmp_seq=1 ttl=127 time=246.636 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=127 time=244.618 ms
--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max/stddev = 244.618/247.475/251.171/2.740 ms
root@feb138ba0702:/# ping 223.5.5.5
root@feb138ba0702:/# echo 'nameserver 223.5.5.5' > /etc/resolv.conf
root@feb138ba0702:/# time nslookup time.geekbang.org
Server:         223.5.5.5
Address:        223.5.5.5#53

Non-authoritative answer:
Name:   time.geekbang.org
Address: 39.106.233.176


real    0m0.156s
user    0m0.000s
sys     0m0.011s

root@feb138ba0702:/# /etc/init.d/dnsmasq start
 * Starting DNS forwarder and DHCP server dnsmasq    
 # DNS 服务器改为 dnsmasq 的监听地址，这儿是 127.0.0.1。接
root@feb138ba0702:/#  echo nameserver 127.0.0.1 > /etc/resolv.conf

root@feb138ba0702:/# time nslookup time.geekbang.org
Server:         127.0.0.1
Address:        127.0.0.1#53

Non-authoritative answer:
Name:   time.geekbang.org
Address: 39.106.233.176


real    0m1.144s
user    0m0.009s
sys     0m0.000s
root@feb138ba0702:/# time nslookup time.geekbang.org
Server:         127.0.0.1
Address:        127.0.0.1#53

Non-authoritative answer:
Name:   time.geekbang.org
Address: 39.106.233.176


real    0m0.008s  #第二次走了dns缓存
user    0m0.007s
sys     0m0.000s
```





# 怎么使用tcpdump和Wireshark分析网络流量？





```BASH
#	Ubuntu
apt-get	install	tcpdump	wireshark
#	CentOS
yum	install	-y	tcpdump	wireshark

wireshark是图形化界面，推荐在win11上安装  https://www.wireshark.org/


# ping 3 次（默认每次发送间隔1秒）
# 假设DNS服务器还是上⼀期配置的223.5.5.5
ping -c3 time.geekbang.org


# 禁⽌接收从DNS服务器发送过来并包含googleusercontent的包

# 禁⽌接收从DNS服务器发送过来并包含googleusercontent的包
iptables -I INPUT -p udp --sport 53 -m string --string googleusercontent --algo bm -j DROP

time nslookup geektime.org

tcpdump -nn udp port 53 or host 39.106.233.176

ping -n -c3 time.geekbang.org

iptables -D INPUT -p udp --sport 53 -m string --string googleusercontent --algo bm -jDROP
```



 wireshark 分析

```bash

tcpdump -nn udp port 53 or host 39.106.233.176 -w ping.pcap

ping -c3 time.geekbang.org


# 把文件复制到win11 上，然后导入wireshark分析
scp root@10.0.0.51:/root/ping.pcap ./

-------------------------------------------------------------
root@ubuntu:~# dig +short example.com
172.66.147.243
104.20.23.154


tcpdump -nn host 172.66.147.243 -w web.pcap

curl http://example.com

scp root@10.0.0.51:/root/web.pcap ./



No. Time       Source          Destination     Protocol Length Info
1   0.000000   10.0.0.51       104.20.23.154  TCP      74     39346 → 80 [SYN] Seq=0 Win=64240 Len=0 MSS=1460 SACK_PERM TSval=2083205146 TSecr=0 WS=64
# 客户端发起TCP连接请求（SYN包），序号从0开始，协商MSS、SACK、时间戳和窗口缩放

2   0.123537   104.20.23.154   10.0.0.51      TCP      60     80 → 39346 [SYN, ACK] Seq=0 Ack=1 Win=64240 Len=0 MSS=1460
# 服务器回复SYN+ACK包，确认客户端连接请求，同时发起自己的连接请求，序号从0开始，确认号为1

3   0.124600   10.0.0.51       104.20.23.154  TCP      54     39346 → 80 [ACK] Seq=1 Ack=1 Win=64240 Len=0
# 客户端回复ACK包，确认服务器的SYN请求，三次握手完成，连接正式建立

4   0.125161   10.0.0.51       104.20.23.154  HTTP     129    GET / HTTP/1.1
# 客户端发送HTTP GET请求，请求访问根路径/，使用HTTP/1.1协议

5   0.125831   104.20.23.154   10.0.0.51      TCP      60     80 → 39346 [ACK] Seq=1 Ack=76 Win=64240 Len=0
# 服务器回复ACK包，确认收到客户端的HTTP请求，确认号为76（序号1 + 数据长度75）

6   0.406475   104.20.23.154   10.0.0.51      HTTP     896    HTTP/1.1 200 OK  (text/html)
# 服务器返回HTTP 200响应，内容类型为text/html，响应体长度896字节

7   0.406551   10.0.0.51       104.20.23.154  TCP      54     39346 → 80 [ACK] Seq=76 Ack=843 Win=63992 Len=0
# 客户端回复ACK包，确认收到服务器的HTTP响应，确认号为843（序号1 + 响应数据长度842）

8   0.407278   10.0.0.51       104.20.23.154  TCP      54     39346 → 80 [FIN, ACK] Seq=76 Ack=843 Win=63992 Len=0
# 客户端发送FIN+ACK包，主动关闭连接，告知服务器客户端已无数据要发送

9   0.408184   104.20.23.154   10.0.0.51      TCP      60     80 → 39346 [ACK] Seq=843 Ack=77 Win=64239 Len=0
# 服务器回复ACK包，确认收到客户端的FIN请求，确认号为77（序号76 + 1）

10  0.529955   104.20.23.154   10.0.0.51      TCP      60     80 → 39346 [FIN, PSH, ACK] Seq=843 Ack=77 Win=64239 Len=0
# 服务器发送FIN+PSH+ACK包，关闭服务器端连接，同时确认客户端的FIN请求（合并确认和关闭步骤）

11  0.530016   10.0.0.51       104.20.23.154  TCP      54     39346 → 80 [ACK] Seq=77 Ack=844 Win=63992 Len=0
# 客户端回复ACK包，确认收到服务器的FIN请求，四次挥手完成，连接正式关闭
```



# 怎么缓解DDoS攻击带来的性能下降问题？

DDoS（Distributed Denial of Service）分布式拒绝服务攻击

DDoS的前身是DoS（Denail of Service），即拒绝服务攻击，指利用大量的合理请求，来占用过多的目标

资源，从而使目标服务无法响应正常请求

DDoS	可以分为下面几种类型。
第一种，耗尽带宽。无论是服务器还是路由器、交换机等网络设备，带宽都有固定的上限。带宽耗尽后，就
会发生网络拥堵，从而无法传输其他正常的网络报文。
第二种，耗尽操作系统的资源。网络服务的正常运行，都需要一定的系统资源，像是CPU、内存等物理资
源，以及连接表等软件资源。一旦资源耗尽，系统就不能处理其他正常的网络连接。
第三种，消耗应用程序的运行资源。应用程序的运行，通常还需要跟其他的资源或系统交互。如果应用程序
一直忙于处理无效请求，也会导致正常请求的处理变慢，甚至得不到响应。

```bash
apt-get	install	hping3 tcpdump curl

三台虚拟机vm
vm1 10.0.0.51  nginx+php
vm2 10.0.0.52  dos攻击
vm3 10.0.0.53  curl正常客户端

-----vm1
#	运⾏Nginx服务并对外开放80端⼝
#	--network=host表⽰使⽤主机⽹络（这是为了⽅便后⾯排查问题）
docker run -itd --name=nginx --network=host nginx


--vm3
# -w表⽰只输出HTTP状态码及总时间，-o表⽰将响应重定向到/dev/null
root@ubuntu:~# curl -s -w 'Http code: %{http_code}\nTotal time:%{time_total}s\n' -o /dev/null http://10.0.0.51/
Http code: 200
Total time:0.002067s

--vm2
#模拟dos攻击
#	-S参数表⽰设置TCP协议的SYN（同步序列号），-p表⽰⽬的端⼝为80
#	-i	u10表⽰每隔10微秒发送⼀个⽹络帧
hping3 -S -p 80 -i u10 10.0.0.51
#上面没效果，改成u1 或者这条语句
hping3 -S -p 80 --flood 10.0.0.51

--vm3
#	--connect-timeout表⽰连接超时时间
root@ubuntu:~# curl -w 'Http code:%{http_code}\nTotaltime:%{time_total}s\n' -o /dev/null --connect-timeout 10 http://10.0.0.51
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   896  100   896    0     0    185      0  0:00:04  0:00:04 --:--:--   246
Http code:200
Totaltime:4.839046s

----vm1
root@ubuntu:~# sar -n DEV 1
Linux 4.15.0-156-generic (ubuntu)       05/31/26        _x86_64_        (2 CPU)

02:24:41        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
02:24:42      docker0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
02:24:42        ens33 135424.00  99080.00   7935.00   5806.29      0.00      0.00      0.00      6.50
02:24:42           lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00


# -i eth0 只抓取eth0⽹卡，-n不解析协议名和主机名
# tcp port 80表⽰只抓取tcp协议并且端⼝号为80的⽹络帧
tcpdump -i ens33 -n tcp port 80


Flags [S] 表示这是一个 SYN 包。大量的 SYN 包表明，这是一个 SYN Flood 攻击。

# -n表⽰不解析名字，-p表⽰显⽰连接所属进程
# 查看 TCP 半开连接
netstat -n -p | grep SYN_REC

netstat -n -p | grep SYN_REC | wc -l

# 拦截来自 10.0.0.52 的所有 TCP 入站请求，主动回包拒绝连接。
iptables -I INPUT -s 10.0.0.52 -p tcp -j REJECT

#	限制syn并发数为每秒1次
iptables -A INPUT -p tcp --syn -m limit --limit 1/s -j ACCEPT
#	限制单个IP在60秒新建⽴的连接数为10
iptables -I INPUT -p tcp --dport 80 --syn -m recent --name SYN_FLOOD --update --seconds 60 --hitcount 10 -j REJECT

# 默认的半连接容量
root@ubuntu:~# sysctl net.ipv4.tcp_max_syn_backlog
net.ipv4.tcp_max_syn_backlog = 128

sysctl -w net.ipv4.tcp_max_syn_backlog=1024
# 连接每个 SYN_RECV 时，如果失败的话，内核还会自动重试，并且默认的重试次数是5次,减少到1次
sysctl -w net.ipv4.tcp_synack_retries=1


# TCP SYN Cookies 也是一种专门防御 SYN Flood 攻击的方法。
sysctl -w net.ipv4.tcp_syncookies=1


#配置持久化
$ cat /etc/sysctl.conf
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_max_syn_backlog = 1024

sysctl -p







```



# 案例篇：网络请求延迟变大了，我该怎么办？

很多网络服务会把 ICMP 禁止掉，这也就导致我们无法用 ping ，来测试网络服务的可用性和往返延时。



```BASH
# -c表⽰发送3次请求，-S表⽰设置TCP SYN，-p表⽰端⼝号为80
hping3 -c 3 -S -p 80 baidu.com

root@ubuntu:~# hping3 -c 3 -S -p 80 baidu.com
# hping3 发送3个TCP SYN包，探测百度80端口
HPING baidu.com (ens33 124.237.177.164): S set, 40 headers + 0 data bytes
# 目标IP：124.237.177.164，仅发SYN标记包，无数据载荷

len=46 ip=124.237.177.164 ttl=128 id=34227 sport=80 flags=SA seq=0 win=64240 rtt=47.5 ms
# 报文长46字节，TTL=128，源端口80，标记SA(SYN+ACK)，端口开放，往返延迟47.5ms

id=34227 # IP 首部标识字段，内核用来区分不同 IP 分片，仅系统内部使用，日常无需关注。
win=64240 #TCP 接收窗口大小（单位：字节），代表对方当前可接收的数据缓冲区上限，用于 TCP 流量控制，数值越大单次可传输数据越多。


# --tcp表⽰使⽤TCP协议，-p表⽰端⼝号，-n表⽰不对结果中的IP地址执⾏反向域名解析
root@ubuntu:~# traceroute --tcp -p 80 -n baidu.com
# TCP模式追踪路由，探测80端口，-n 不解析域名，最大30跳，包长60字节
traceroute to baidu.com (124.237.177.164), 30 hops max, 60 byte packets
 1  10.0.0.254  0.134 ms  0.085 ms  0.067 ms
# 第1跳：网关10.0.0.254，三次探测延迟均极低
 2  * * 124.237.177.164  42.984 ms
# 第2跳：前两次探测超时(* )，第三次直达百度IP，总延迟42.984ms
raceroute 会在路由的每一跳发送三个包，并在收到响应后，输出往返延时。如果无响应或者响应超时（默
认5s），就会输出一个星号。



```



案例

```bash

----VM1  10.0.0.51  NGINX+PHP
----VM2  10.0.0.52  hping3 curl wrk

--vm1
docker run --network=host --name=good -itd nginx
docker run --name nginx --network=host -itd feisky/nginx:latency


--vm2
# 80端⼝正常
curl http://10.0.0.51 
# 8080端⼝正常
curl http://10.0.0.51:8080

# 测试80端⼝延迟
hping3 -c 3 -S -p 80 10.0.0.51

#	测试8080端⼝延迟
hping3 -c 3 -S -p 8080 10.0.0.51




#	测试80端⼝性能
wrk --latency -c 100 -t 2 --timeout 2 http://10.0.0.51/
#	测试8080端⼝性能
wrk --latency -c 100 -t 2 --timeout 2 http://10.0.0.51:8080/
Running 10s test @ http://10.0.0.51:8080/
# 压测时长10秒
  2 threads and 100 connections
# 2个压测线程，100个并发连接

  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    43.77ms    6.53ms  69.62ms   95.87%
    # 平均延迟43.77ms，最大69.62ms，延迟整体稳定
    Req/Sec     1.14k   141.90     2.01k    85.50%
    # 单线程每秒平均1140请求

  Latency Distribution  # 延迟分位统计
     50%   44.06ms  # 半数请求 ≤44.06ms
     75%   44.49ms
     90%   47.62ms
     99%   51.93ms  # 99%请求 ≤51.93ms

  22827 requests in 10.03s, 18.53MB read
  # 10秒总计22827次请求，读取18.53MB数据
Requests/sec:   2276.86  # 整体QPS：2277
Transfer/sec:      1.85MB # 每秒传输1.85MB


问题： 80端口的服务平均延时4.30ms   8080端口达到了43ms

--vm1
tcpdump -nn tcp port 8080 -w nginx.pcap
--vm2
wrk --latency -c 100 -t 2 --timeout 2 http://10.0.0.51:8080/

#拿到win11 wirkshark 分析
scp root@10.0.0.51:/root/nginx.pcap ./


40ms后才发出了ACK响应,这是TCP延迟确认（Delayed ACK）的最小超时时间。
man tcp


# strace -f wrk --latency -c 100 -t 2 --timeout 2  http://10.0.0.51:8080/
...
setsockopt(52, SOL_TCP, TCP_NODELAY, [1], 4) = 0
...

----vm1
root@ubuntu:~# docker exec nginx cat /etc/nginx/nginx.conf|grep tcp_nodelay
    tcp_nodelay    off;
    
    
#	删除案例应⽤
docker rm -f nginx
#	启动优化后的应⽤
docker run --name nginx --network=host -itd feisky/nginx:nodelay    


--vm2
wrk --latency -c 100 -t 2 --timeout 2 http://10.0.0.51:8080/

```



# 案例篇：如何优化NAT性能？





```BASH
#	Ubuntu
apt-get install -y docker.io tcpdump curl apache2-utils
		
#	CentOS
curl -fsSL https://get.docker.com | sh
yum	install -y tcpdump curl httpd-tools
		

SystemTap 是	Linux 的一种动态追踪框架，它把用户提供的脚本，转换为内核模块来执行，用来监测和跟
踪内核的行为。

#	Ubuntu
apt-get install -y systemtap-runtime systemtap
#	Configure	ddebs	source
cat /etc/apt/sources.list.d/ddebs.list
deb http://ddebs.ubuntu.com bionic main restricted universe multiverse
deb http://ddebs.ubuntu.com bionic-updates main restricted universe multiverse
deb http://ddebs.ubuntu.com bionic-proposed main restricted universe multiverse


# Install dbgsym
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F2EDC64DC5AEE1F6B9C621F0C8CAB6595FDFF622
apt-get	update
apt install ubuntu-dbgsym-keyring
stap-prep
#升级新版本内核
apt install linux-image-4.15.0-211-generic  
reboot

apt install -y linux-headers-4.15.0-211-generic
apt-get install linux-image-`uname -r`-dbgsym

# CentOS
yum install systemtap kernel-devel yum-utils kernel
stab-prep


VM1 --10.0.0.51   NGINX+PHP
VM2 --10.0.0.52  CURL  AB

--vm1
docker run --name nginx-hostnet --privileged --network=host -itd feisky/nginx:80


--vm2
curl http://10.0.0.51
#	open	files
ulimit -n  # 默认1024
#	临时增⼤当前会话的最⼤⽂件描述符数
ulimit -n 65536
#	-r表⽰套接字接收错误时仍然继续执⾏，-s表⽰设置每个请求的超时时间为2s
ab -c 5000 -n 100000 -r -s 2 http://10.0.0.51/


--vm1 
docker rm -f nginx-hostnet
docker run --name nginx --privileged -p 8080:8080 -itd feisky/nginx:nat

root@ubuntu:~# docker logs nginx
/bin/sh: 1: cannot create /proc/sys/net/netfilter/nf_conntrack_max: Permission denied

#未解决

# Nginx 启动后，你可以执行 iptables 命令，确认 DNAT 规则已经创建：
iptables -nL -t nat


--vm2
curl http://10.0.0.51:8080/
```





# 套路篇：网络性能优化的几个思路



根据指标找工具（网络性能）



| 性能指标       | 工具                   | 说明                                               |
| -------------- | ---------------------- | -------------------------------------------------- |
| 吞吐量（BPS）  | sar、nethogs、iftop    | 分别可以查看网络接口、进程以及 IP 地址的网络吞吐量 |
| PPS            | sar、/proc/net/dev     | 查看网络接口的 PPS                                 |
| 连接数         | netstat、ss            | 查看网络连接数                                     |
| 延迟           | ping、hping3           | 通过 ICMP、TCP 等测试网络延迟                      |
| 连接跟踪数     | conntrack              | 查看和管理连接跟踪状况                             |
| 路由           | mtr、route、traceroute | 查看路由并测试链路信息                             |
| DNS            | dig、nslookup          | 排查 DNS 解析问题                                  |
| 防火墙和 NAT   | iptables               | 配置和管理防火墙及 NAT 规则                        |
| 网卡功能       | ethtool                | 查看和配置网络接口的功能                           |
| 抓包           | tcpdump、Wireshark     | 抓包分析网络流量                                   |
| 内核协议栈跟踪 | bcc、systemtap         | 动态跟踪内核协议栈的行为                           |





根据工具查指标（网络性能)

| 性能工具                                            | 主要功能                    |
| --------------------------------------------------- | --------------------------- |
| ifconfig、ip                                        | 配置和查看网络接口          |
| ss                                                  | 查看网络连接数              |
| sar、/proc/net/dev、/sys/class/net/eth0/statistics/ | 查看网络接口的网络收发情况  |
| nethogs                                             | 查看进程的网络收发情况      |
| iftop                                               | 查看 IP 的网络收发情况      |
| ethtool                                             | 查看和配置网络接口          |
| conntrack                                           | 查看和管理连接跟踪状况      |
| nslookup、dig                                       | 排查 DNS 解析问题           |
| mtr、route、traceroute                              | 查看路由并测试链路信息      |
| ping、hping3                                        | 测试网络延迟                |
| tcpdump                                             | 网络抓包工具                |
| Wireshark                                           | 网络抓包和图形界面分析工具  |
| iptables                                            | 配置和管理防火墙及 NAT 规则 |
| perf                                                | 剖析内核协议栈的性能        |
| systemtap、bcc                                      | 动态追踪内核协议栈的行为    |



从网络 I/O 的角度来说，主要有下面两种优化思路。

第一种是最常用的 I/O 多路复用技术 epoll，主要用来取代 select 和 poll。这其实是解决 C10K 问题的关
键，也是目前很多网络应用默认使用的机制。

第二种是使用异步 I/O（Asynchronous I/O，AIO）。AIO 允许应用程序同时发起很多 I/O 操作，而不用等
待这些操作完成。等到 I/O完成后，系统会用事件通知的方式，告诉应用程序结果。不过，AIO 的使用比较
复杂，你需要小心处理很多边缘情况。

而从进程的工作模型来说，也有两种不同的模型用来优化。

第一种，主进程+多个 worker 子进程。其中，主进程负责管理网络连接，而子进程负责实际的业务处理。
这也是最常用的一种模型。

第二种，监听到相同端口的多进程模型。在这种模型下，所有进程都会监听相同接口，并且开启
SO_REUSEPORT 选项，由内核负责，把请求负载均衡到这些监听进程中去。



除了网络I/O和进程的工作模型外，应用层的网络协议优化，也是至关重要的一点。我总结了常见的几种优化方法。

- 使用长连接取代短连接，可以显著降低TCP建立连接的成本。在每秒请求次数较多时，这样做的效果非常明显。
- 使用内存等方式，来缓存不常变化的数据，可以降低网络I/O次数，同时加快应用程序的响应速度。
- 使用ProtocolBuffer等序列化的方式，压缩网络I/O的数据量，可以提高应用程序的吞吐。
- 使用DNS缓存、预取、HTTPDNS等方式，减少DNS解析的延迟，也可以提升网络I/O的整体速度。



## 网络性能优化

tcp优化

```BASH

# TCP 优化实操（Ubuntu 18.04+/Debian 系列通用）
# 所有参数都写在 /etc/sysctl.conf 里，修改后执行 sysctl -p 生效

# 1. 增大处于 TIME_WAIT 状态的连接数量
# 内核选项：net.ipv4.tcp_max_tw_buckets
echo "net.ipv4.tcp_max_tw_buckets = 1048576" >> /etc/sysctl.conf
sysctl -p
# 说明：调整系统可同时容纳的 TIME_WAIT 连接上限，避免高并发场景下连接数耗尽

# 2. 增大连接跟踪表的大小
# 内核选项：net.netfilter.nf_conntrack_max
echo "net.netfilter.nf_conntrack_max = 1048576" >> /etc/sysctl.conf
sysctl -p
# 说明：调整 NAT/防火墙连接跟踪表的容量，高并发压测/网关场景必须调大

# 3. 缩短处于 TIME_WAIT 状态的超时时间
# 内核选项：net.ipv4.tcp_fin_timeout
echo "net.ipv4.tcp_fin_timeout = 15" >> /etc/sysctl.conf
sysctl -p
# 说明：减少 FIN-WAIT-2 状态的超时等待时间，加快连接回收

# 4. 缩短连接跟踪表中处于 TIME_WAIT 状态连接的超时时间
# 内核选项：net.netfilter.nf_conntrack_tcp_timeout_time_wait
echo "net.netfilter.nf_conntrack_tcp_timeout_time_wait = 30" >> /etc/sysctl.conf
sysctl -p
# 说明：让 NAT/防火墙更快清理 TIME_WAIT 状态的连接，释放资源

# 5. 允许 TIME_WAIT 状态占用的端口还可以用到新建的连接中
# 内核选项：net.ipv4.tcp_tw_reuse
echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
sysctl -p
# 说明：允许新建连接复用 TIME_WAIT 状态的端口，缓解端口资源紧张问题

# 6. 增大本地端口号的范围
# 内核选项：net.ipv4.ip_local_port_range
echo "net.ipv4.ip_local_port_range = 10000 65000" >> /etc/sysctl.conf
sysctl -p
# 说明：扩大客户端发起连接时可用的临时端口范围，支持更多并发连接

# 7. 增加系统和应用程序的最大文件描述符数
# 系统内核选项：fs.nr_open
echo "fs.nr_open = 1048576" >> /etc/sysctl.conf
sysctl -p
# 应用程序配置：修改 /etc/security/limits.conf
echo "* soft nofile 1048576" >> /etc/security/limits.conf
echo "* hard nofile 1048576" >> /etc/security/limits.conf
echo "root soft nofile 1048576" >> /etc/security/limits.conf
echo "root hard nofile 1048576" >> /etc/security/limits.conf
# 说明：提升进程可打开的最大文件句柄数，高并发服务必备优化

# 8. 增加半连接的最大数量
# 内核选项：net.ipv4.tcp_max_syn_backlog
echo "net.ipv4.tcp_max_syn_backlog = 16384" >> /etc/sysctl.conf
sysctl -p
# 说明：调整 SYN 队列长度，提升服务端应对 SYN 洪泛攻击和高并发连接的能力

# 9. 开启 SYN Cookies
# 内核选项：net.ipv4.tcp_syncookies
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
sysctl -p
# 说明：启用 SYN Cookies，在 SYN 队列溢出时保护系统免受攻击

# 10. 缩短发送 Keepalive 探测包的间隔时间
# 内核选项：net.ipv4.tcp_keepalive_intvl
echo "net.ipv4.tcp_keepalive_intvl = 30" >> /etc/sysctl.conf
sysctl -p
# 说明：调整 TCP 保活探测包的发送间隔，加快异常连接的识别

# 11. 减少 Keepalive 探测失败后通知应用程序前的重试次数
# 内核选项：net.ipv4.tcp_keepalive_probes
echo "net.ipv4.tcp_keepalive_probes = 3" >> /etc/sysctl.conf
sysctl -p
# 说明：减少 TCP 保活探测的重试次数，更快判定连接失效

# 12. 缩短最后一次数据包到 Keepalive 探测包的间隔时间
# 内核选项：net.ipv4.tcp_keepalive_time
echo "net.ipv4.tcp_keepalive_time = 600" >> /etc/sysctl.conf
sysctl -p
# 说明：调整空闲连接多久后开始发送 TCP 保活探测包，提前识别死连接



```



udp优化

```BASH
# --------------------------
# UDP 优化实操（Ubuntu/Debian）
# 所有内核参数写入 /etc/sysctl.conf，sysctl -p 生效
# --------------------------

# 1. 增大套接字缓冲区大小（UDP/TCP 共用，提升吞吐量）
# 调整单 socket 读缓冲区最大值（单位：字节，默认通常较小）
echo "net.core.rmem_max = 16777216" >> /etc/sysctl.conf
sysctl -p
# 说明：设置最大读缓冲区为 16MB，适合高带宽/高吞吐场景

# 调整单 socket 写缓冲区最大值
echo "net.core.wmem_max = 16777216" >> /etc/sysctl.conf
sysctl -p
# 说明：设置最大写缓冲区为 16MB，提升发送大数据包的能力

# 调整UDP读缓冲区默认值（内核自动分配的起始大小）
echo "net.ipv4.udp_rmem_min = 4096" >> /etc/sysctl.conf
sysctl -p
# 说明：设置UDP读缓冲区最小值，避免缓冲区过小导致丢包

# 调整UDP写缓冲区默认值
echo "net.ipv4.udp_wmem_min = 4096" >> /etc/sysctl.conf
sysctl -p
# 说明：设置UDP写缓冲区最小值，适配低延迟小数据场景

# 2. 增大本地端口号范围（与TCP共用，解决UDP临时端口不足）
echo "net.ipv4.ip_local_port_range = 10000 65000" >> /etc/sysctl.conf
sysctl -p
# 说明：扩大客户端发起UDP连接的临时端口池，支持更多并发会话

# 3. 根据MTU调整UDP数据包大小，减少分片
# 先查看网卡MTU（例如eth0）
ip link show eth0 | grep mtu
# 说明：确认当前MTU值（常见为1500），UDP包建议不超过 MTU-28（IP头20+UDP头8）

# 示例：若MTU=1500，则UDP应用层数据最大设为1472字节，避免IP分片
# 需在应用层配置发送/接收缓冲区，例如：
# setsockopt(sockfd, SOL_SOCKET, SO_SNDBUF, &bufsize, sizeof(bufsize));
# setsockopt(sockfd, SOL_SOCKET, SO_RCVBUF, &bufsize, sizeof(bufsize));
# 说明：应用层控制包大小，比内核参数更直接有效

# 可选：开启UDP分片错误日志（排查分片问题用）
echo "net.ipv4.udp_err_msgs = 1" >> /etc/sysctl.conf
sysctl -p
# 说明：开启后可在dmesg中看到UDP分片失败、ICMP不可达等错误信息

# 可选：增大UDP接收队列长度，缓解高并发下的丢包
echo "net.core.netdev_max_backlog = 16384" >> /etc/sysctl.conf
sysctl -p
# 说明：调整网卡驱动接收队列深度，减少大流量UDP包的内核丢包

# 可选：开启UDP校验和（默认开启，确认未被禁用）
# 通常网卡硬件自动处理，无需额外配置
# 若需检查：ethtool -k eth0 | grep tx-udp-segmentation-offload
# 说明：UDP校验和是基础可靠性保障，禁用会导致数据损坏

# --------------------------
# 生效与验证
# --------------------------
# 加载所有sysctl配置
sysctl -p

# 验证缓冲区参数
sysctl net.core.rmem_max net.core.wmem_max net.ipv4.udp_rmem_min net.ipv4.udp_wmem_min

# 验证端口范围
sysctl net.ipv4.ip_local_port_range

# 查看当前MTU
ip addr show eth0


补充说明：
UDP 优化中，应用层控制包大小（不超过 MTU-28） 比内核参数更关键，分片会严重影响性能；
缓冲区大小建议根据业务场景调整：高吞吐场景可设 16MB，低延迟场景保持默认即可；
所有 sysctl 参数修改后重启会保留，无需额外操作。
```



网络层优化

```BASH
# --------------------------
# 网络层优化实操（Ubuntu/Debian）
# 所有内核参数写入 /etc/sysctl.conf，sysctl -p 生效
# --------------------------

# ========== 一、路由与转发优化 ==========

# 1. 开启IP转发（NAT网关、Docker容器、路由器场景必备）
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
# 说明：允许服务器转发IP数据包，是NAT网关、Docker桥接网络等场景的基础配置

# 2. 调整数据包TTL生存周期（默认通常为64，不建议盲目增大）
echo "net.ipv4.ip_default_ttl = 64" >> /etc/sysctl.conf
sysctl -p
# 说明：TTL值过大会增加路由转发消耗，降低系统性能，一般保持默认即可

# 3. 开启反向地址校验（防止IP欺骗，减少伪造IP DDoS攻击）
echo "net.ipv4.conf.eth0.rp_filter = 1" >> /etc/sysctl.conf
sysctl -p
# 说明：对eth0网卡启用反向路径校验，丢弃源IP路由不可达的数据包
echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.conf
sysctl -p
# 说明：对所有网卡全局启用反向地址校验，增强整体安全性

# ========== 二、MTU 分片优化 ==========

# 1. 查看当前网卡MTU（以eth0为例）
ip link show eth0
# 说明：确认当前MTU值，标准以太网默认1500，需根据网络环境调整

# 2. 临时修改网卡MTU（重启后失效，适合测试）
ip link set eth0 mtu 1500
# 说明：设置标准以太网MTU为1500，适用于普通网络环境

# 3. 永久修改网卡MTU（以netplan为例，Ubuntu 18.04+）
cat > /etc/netplan/01-netcfg.yaml <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: true
      mtu: 1500
EOF
netplan apply
# 说明：通过netplan配置永久生效的MTU，修改为1500适配标准以太网

# 4. VXLAN/GRE隧道场景MTU调整示例
# 场景：VXLAN隧道会额外增加50字节头部，需调整两端MTU避免分片
# 方案A：增大交换机/路由器MTU到1550
# 方案B：减小虚拟机/容器网卡MTU到1450（推荐）
ip link set eth0 mtu 1450
# 说明：MTU=1450，加上VXLAN等头部后刚好不超过1500，避免IP分片

# 5. 巨帧环境MTU调整（设备支持时使用）
ip link set eth0 mtu 9000
# 说明：设置巨帧MTU为9000，提升大流量传输吞吐量，需交换机/网卡同时支持

# ========== 三、ICMP 安全优化 ==========

# 1. 禁止ICMP回显请求（外部主机无法ping通本机，隐藏主机）
echo "net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.conf
sysctl -p
# 说明：完全禁止响应ping请求，可避免主机探测，但会影响网络连通性排查

# 2. 禁止广播ICMP回显请求（防止广播ping攻击）
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.conf
sysctl -p
# 说明：拒绝响应广播/多播地址的ICMP请求，减少广播风暴和DDoS攻击

# 3. 可选：忽略无效ICMP错误报文（减少系统资源消耗）
echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.conf
sysctl -p
# 说明：忽略伪造或无效的ICMP错误响应，降低系统处理负担

# --------------------------
# 生效与验证
# --------------------------
# 加载所有sysctl配置
sysctl -p

# 验证路由转发配置
sysctl net.ipv4.ip_forward

# 验证反向地址校验
sysctl net.ipv4.conf.all.rp_filter

# 验证ICMP配置
sysctl net.ipv4.icmp_echo_ignore_all net.ipv4.icmp_echo_ignore_broadcasts

# 验证网卡MTU
ip addr show eth0 | grep mtu




```



数据链路层优化

```BASH
# =====================================================
# 链路层网络优化实操（Ubuntu/Debian 通用）
# 说明：以下命令以网卡 eth0 为例，根据实际网卡名替换
# =====================================================

# --------------------------
# 1. 查看网卡基本信息（先确认环境）
# --------------------------
# 查看网卡型号、队列数、特性
ethtool eth0
ethtool -i eth0
# 说明：先确认网卡是否支持多队列、RSS、硬件卸载等功能

# 查看当前中断亲和性（irq 与 CPU 绑定）
cat /proc/interrupts | grep eth0
# 说明：找到 eth0 对应的中断号，用于后续 smp_affinity 配置

# --------------------------
# 2. 网卡中断亲和性优化（smp_affinity / irqbalance）
# --------------------------
# 方案A：使用 irqbalance 自动均衡（推荐，简单通用）
apt install -y irqbalance
systemctl enable --now irqbalance
# 说明：irqbalance 会自动把网卡中断分配到不同 CPU 上，平衡负载

# 方案B：手动设置 smp_affinity（精细控制，需先找到中断号）
# 假设 eth0 中断号为 45（替换成实际值）
echo 3 > /proc/irq/45/smp_affinity
# 说明：二进制掩码 3（0b11）表示绑定到 CPU0 和 CPU1，按需调整

# --------------------------
# 3. 开启 RPS/RFS（软中断 CPU 亲和性优化）
# --------------------------
# 查看网卡队列数
ls /sys/class/net/eth0/queues/
# 假设只有 rx-0 队列，设置 RPS 到所有 CPU（CPU 数为 N）
echo f > /sys/class/net/eth0/queues/rx-0/rps_cpus
# 说明：十六进制掩码 f 表示 4 核 CPU，按需调整（如 0xff 对应 8 核）

# 开启 RFS，让软中断和应用进程在同一 CPU 运行，提升缓存命中率
echo 32768 > /proc/sys/net/core/rps_sock_flow_entries
echo 32768 > /sys/class/net/eth0/queues/rx-0/rps_flow_cnt
# 说明：rps_sock_flow_entries 是全局流表大小，建议设为 CPU 数 × 1024

# --------------------------
# 4. 网卡硬件卸载功能优化（TSO/GSO/GRO 等）
# --------------------------
# 查看当前网卡卸载特性
ethtool -k eth0 | grep "offload\|segment"

# 开启 TSO（TCP 分段卸载）和 UFO（UDP 分片卸载）
ethtool -K eth0 tx-tcp-segmentation-onload on
ethtool -K eth0 tx-udp-fragmentation-onload on
# 说明：让网卡硬件完成 TCP/UDP 分段/分片，减轻 CPU 负担

# 开启 GSO（通用分段卸载）
ethtool -K eth0 tx-generic-segmentation-onload on
# 说明：当网卡不支持 TSO/UFO 时，用 GSO 延迟分段到网卡发送前执行

# 开启 GRO（通用接收卸载，修复 LRO 缺陷）
ethtool -K eth0 rx-generic-receive-offload on
# 说明：让网卡合并 TCP/UDP 接收包，减少内核处理次数，提升吞吐量

# 关闭 LRO（如需 IP 转发，必须关闭，否则可能导致校验错误）
ethtool -K eth0 rx-large-receive-offload off
# 说明：LRO 合并的包在转发时头部不一致，会导致校验错误

# 开启 RSS（多队列接收），让多个 CPU 处理网卡接收包
# 先查看网卡支持的队列数
ethtool -l eth0
# 设置 TX/RX 队列数为最大支持值（假设最大 8 队列）
ethtool -L eth0 tx 8 rx 8
# 说明：多队列配合 RSS，可让多个 CPU 并行处理网络包

# 开启 VXLAN 卸载（网卡支持时使用）
ethtool -K eth0 tx-vxlan-segmentation-onload on
# 说明：让网卡硬件完成 VXLAN 封装，减少 CPU 消耗

# --------------------------
# 5. 网卡队列与缓冲区优化
# --------------------------
# 增大网卡接收/发送队列长度
ethtool -G eth0 rx 4096 tx 4096
# 说明：增大队列长度可减少丢包，但可能增加延迟，需根据业务调整

# 增大内核网络设备接收队列（netdev_max_backlog）
echo 16384 > /proc/sys/net/core/netdev_max_backlog
sysctl -w net.core.netdev_max_backlog=16384
# 说明：增大内核接收队列深度，缓解高流量下的丢包问题

# --------------------------
# 6. 流量控制与 QoS（TC 工具）
# --------------------------
# 示例：为 eth0 配置简单流量控制（限速 100Mbps）
tc qdisc add dev eth0 root tbf rate 100mbit burst 32kbit latency 400ms
# 说明：tbf 令牌桶过滤器，可用于限速、配置 QoS，具体规则按业务调整

# 查看当前 TC 配置
tc qdisc show dev eth0

# --------------------------
# 7. 验证与持久化配置
# --------------------------
# 验证卸载功能是否生效
ethtool -k eth0 | grep "onload"

# 验证队列数
ethtool -l eth0

# 持久化配置（重启后保留，以 Ubuntu netplan 为例）
cat > /etc/netplan/01-netcfg.yaml <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: true
      mtu: 1500
      ethtool:
        features:
          tx-tcp-segmentation-onload: on
          rx-generic-receive-offload: on
EOF
netplan apply
# 说明：通过 netplan 持久化 ethtool 配置，避免重启失效


💡 补充说明：
所有操作以 eth0 为例，请根据实际网卡名替换；
硬件卸载功能（TSO/GRO/RSS 等）需网卡驱动支持，部分虚拟机环境可能受限；
LRO 功能在需要 IP 转发的场景（如 NAT 网关）必须关闭，否则会导致网络异常；
队列长度和缓冲区大小调整需根据业务场景测试，过大可能增加延迟，过小易丢包。
```



**DPDK** 是 “用户态硬刚”：用用户态接管网卡，性能拉满，但成本高、配置复杂。

**XDP** 是 “内核态轻量加速”：在内核早期阶段快速处理包，性能很高且不影响系统，适合大部分场景。

```BASH
# =====================================================
# 一、DPDK 基础环境配置（用户态高性能网络）
# 说明：DPDK 跳过内核协议栈，用户态轮询收发包，性能极高
# =====================================================

# --------------------------
# 1. 安装依赖与工具
# --------------------------
apt update && apt install -y build-essential libnuma-dev linux-headers-$(uname -r) meson ninja
# 说明：安装编译依赖、NUMA 库、内核头文件，用于编译 DPDK

# --------------------------
# 2. 配置大页内存（DPDK 必须）
# --------------------------
# 临时配置大页（重启失效，测试用）
echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
# 说明：分配 1024 个 2MB 大页，共 2GB，可根据需求调整

# 永久配置大页（写入 /etc/default/grub）
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="default_hugepagesz=1G hugepagesz=1G hugepages=2 /' /etc/default/grub
update-grub
# 说明：配置 2 个 1GB 大页，重启后生效，适合生产环境
reboot

# 验证大页配置
cat /proc/meminfo | grep HugePages
# 说明：查看 HugePages_Total 是否为配置值

# --------------------------
# 3. 绑定网卡到 DPDK 驱动（uio_pci_generic / vfio-pci）
# --------------------------
# 加载 uio 模块
modprobe uio
modprobe uio_pci_generic
# 说明：uio_pci_generic 是通用用户态 I/O 驱动，虚拟机常用

# 查看网卡 PCI 地址（以 eth0 为例）
lspci | grep -i eth
# 示例输出：00:03.0 Ethernet controller: Virtio device

# 绑定网卡到 DPDK 驱动（替换为实际 PCI 地址）
dpdk-devbind.py --bind=uio_pci_generic 00:03.0
# 说明：绑定后，网卡不再受内核控制，由 DPDK 应用直接管理

# 验证绑定状态
dpdk-devbind.py --status

# --------------------------
# 4. CPU 亲和性与进程绑定（DPDK 应用优化）
# --------------------------
# 查看 CPU 核心与 NUMA 节点
lscpu
numactl --hardware

# 绑定 DPDK 进程到指定 CPU 核心（示例，以 l2fwd 为例）
./build/examples/dpdk-l2fwd -l 0-3 -n 4 -- -p 0x3
# 说明：-l 0-3 表示绑定到 CPU 0-3，-n 4 表示 4 个内存通道

# 手动设置进程 CPU 亲和性（用 taskset）
taskset -c 0-3 ./dpdk-app
# 说明：将进程绑定到 CPU 0-3，避免上下文切换

# --------------------------
# 5. 编译运行 DPDK 示例程序（l2fwd 二层转发）
# --------------------------
# 下载并解压 DPDK（以 22.11 为例）
wget https://fast.dpdk.org/rel/dpdk-22.11.tar.xz
tar -xf dpdk-22.11.tar.xz && cd dpdk-22.11

# 编译 DPDK
meson setup build
cd build && ninja install

# 运行 l2fwd 示例
./examples/dpdk-l2fwd -l 0-1 -n 2 -- -q 2 -p 0x3
# 说明：使用 2 个核心，2 个队列，处理 0x3（两个端口）的流量



# =====================================================
# 二、XDP 基础环境配置（内核 eBPF 快速包处理）
# 说明：XDP 在网卡驱动层直接处理包，性能接近 DPDK，无需绑定网卡
# =====================================================

# --------------------------
# 1. 安装依赖与工具
# --------------------------
apt install -y clang llvm libbpf-dev linux-tools-$(uname -r)
# 说明：安装 clang 编译器、libbpf 库、bpftool 工具

# 加载必要内核模块
modprobe xdp
modprobe bpf
modprobe tracepoints
# 说明：加载 XDP 和 eBPF 相关模块

# --------------------------
# 2. 编写并编译简单 XDP 程序（示例：丢弃 ICMP 包）
# --------------------------
# 创建 xdp-drop-icmp.c
cat > xdp-drop-icmp.c <<EOF
#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/in.h>

SEC("xdp")
int drop_icmp(struct xdp_md *ctx) {
    void *data = (void *)(long)ctx->data;
    void *data_end = (void *)(long)ctx->data_end;

    struct ethhdr *eth = data;
    if ((void *)(eth + 1) > data_end) return XDP_PASS;

    if (eth->h_proto != htons(ETH_P_IP)) return XDP_PASS;

    struct iphdr *ip = (void *)(eth + 1);
    if ((void *)(ip + 1) > data_end) return XDP_PASS;

    if (ip->protocol == IPPROTO_ICMP) {
        return XDP_DROP; // 丢弃 ICMP 包
    }

    return XDP_PASS;
}
char _license[] SEC("license") = "GPL";
EOF

# 编译为 eBPF 字节码
clang -O2 -target bpf -c xdp-drop-icmp.c -o xdp-drop-icmp.o
# 说明：生成可加载的 XDP 程序

# --------------------------
# 3. 加载 XDP 程序到网卡（以 eth0 为例）
# --------------------------
# 使用 ip 命令加载（推荐）
ip link set dev eth0 xdp obj xdp-drop-icmp.o sec xdp
# 说明：将编译好的 XDP 程序附加到 eth0 网卡

# 验证 XDP 程序是否加载成功
ip link show eth0
# 说明：输出中会有 "xdp" 标记

# 使用 bpftool 查看加载的 XDP 程序
bpftool prog list | grep xdp

# --------------------------
# 4. 卸载 XDP 程序
# --------------------------
ip link set dev eth0 xdp off
# 说明：移除网卡上的 XDP 程序，恢复正常处理

# --------------------------
# 5. 高级：使用 xdpcap 抓包或 tc 配合 XDP
# --------------------------
# 安装 xdpcap 工具（可选）
go install github.com/cloudflare/xdpcap/cmd/xdpcap@latest

# 使用 tc 加载 XDP 程序（部分场景需要）
tc qdisc add dev eth0 clsact
tc filter add dev eth0 ingress bpf obj xdp-drop-icmp.o sec xdp
# 说明：通过 tc 的 clsact 挂载点加载 XDP 程序

# --------------------------
# 6. 性能验证
# --------------------------
# 使用 ping 测试 XDP 效果（加载后 ICMP 会被丢弃）
ping 192.168.1.1
# 说明：加载 drop-icmp 程序后，ping 会无响应

# 使用 perf 查看 XDP 程序性能
perf record -e xdp:* -g -- sleep 10
perf report
# 说明：分析 XDP 程序的 CPU 消耗和执行情况
```



- 在应用程序中，主要是优化 I/O 模型、工作模型以及应用层的网络协议；
- 在套接字层中，主要是优化套接字的缓冲区大小；
- 在传输层中，主要是优化 TCP 和 UDP 协议；
- 在网络层中，主要是优化路由、转发、分片以及 ICMP 协议；
- 最后，在链路层中，主要是优化网络包的收发、网络功能卸载以及网卡选项。

如果这些方法依然不能满足你的要求，那就可以考虑，使用 DPDK 等用户态方式，绕过内核协议栈；或者，
使用 XDP，在网络包进入内核协议栈前进行处理。





# 为什么应用容器化后，启动慢了很多？



```BASH
apt	install	docker.io curl jq sysstat
jq	工具专门用来在命令行中处理json。为了更好的展示json数据，我们用这个工具，来格式化json输出。

# -m表⽰设置内存为512MB
docker run --name tomcat --cpus 0.1 -m 512M -p 8080:8080 -itd feisky/tomcat:8



root@ubuntu:~# curl localhost:8080
curl: (56) Recv failure: Connection reset by peer

root@ubuntu:~# docker logs -f tomcat
Using CATALINA_BASE:   /usr/local/tomcat
Using CATALINA_HOME:   /usr/local/tomcat
Using CATALINA_TMPDIR: /usr/local/tomcat/temp
Using JRE_HOME:        /docker-java-home/jre

#新建一个终端
root@ubuntu:~# for ((i=0;i<30;i++));do curl localhost:8080;sleep 1;done



# 显⽰容器状态，jq⽤来格式化json输出
docker inspect tomcat -f '{{json .State}}' | jq

dmesg

# 重新启动容器
# docker rm -f tomcat
# docker run --name tomcat --cpus 0.1 -m 512M -p 8080:8080 -itd feisky/tomcat:8
# 查看堆内存，注意单位是字节
docker exec tomcat java -XX:+PrintFlagsFinal -version | grep HeapSize

docker exec tomcat free -h

#删除问题容器
docker rm -f tomcat
#运⾏新的容器
docker run --name tomcat --cpus 0.1 -m 512M -e JAVA_OPTS='-Xmx512m -Xms512m' -p 8080:8080 -itd feisky/tomcat:8

docker logs -f tomcat
# 启动过程，居然需要	27秒，太慢了吧。
top

# -t表⽰显⽰线程，-p指定进程号
pidstat -t -p `pidof java` 1


#查询新容器中进程的Pid
PID=$(docker inspect tomcat -f '{{.State.Pid}}')
#执⾏	pidstat  #同时另一终端 for ((i=0;i<50;i++));do curl localhost:8080;sleep 1;done
pidstat -t -p $PID 1  
# 观察发现 %wait非常高

#删除旧容器
docker rm -f tomcat
#运⾏新容器
docker run --name tomcat --cpus 1 -m 512M -e JAVA_OPTS='-Xmx512m -Xms512m' -p 8080:8080 -itd feisky/tomcat:8
#查看容器⽇志  #Server startup in 847 ms
docker logs -f tomcat    

```





# 服务器总是时不时丢包，我该怎么办？



```bash
vm1- 10.0.0.51  nginx +php
vm2- 10.0.0.52 curl hping3

vm1-----
docker run --name nginx --hostname nginx --privileged -p 80:80 -itd feisky/nginx:drop
docker ps


vm2---
#	-c表⽰发送10个请求，-S表⽰使⽤TCP	SYN，-p指定端⼝为80
hping3 -c 10 -S -p 80 10.0.0.51 

root@ubuntu:~# hping3 -c 10 -S -p 80 10.0.0.51
HPING 10.0.0.51 (ens33 10.0.0.51): S set, 40 headers + 0 data bytes
len=46 ip=10.0.0.51 ttl=63 DF id=0 sport=80 flags=SA seq=0 win=65535 rtt=7.6 ms
len=46 ip=10.0.0.51 ttl=63 DF id=0 sport=80 flags=SA seq=2 win=65535 rtt=6.9 ms
len=46 ip=10.0.0.51 ttl=63 DF id=0 sport=80 flags=SA seq=4 win=65535 rtt=6.4 ms
len=46 ip=10.0.0.51 ttl=63 DF id=0 sport=80 flags=SA seq=3 win=65535 rtt=3046.3 ms
len=46 ip=10.0.0.51 ttl=63 DF id=0 sport=80 flags=SA seq=8 win=65535 rtt=4.2 ms
len=46 ip=10.0.0.51 ttl=63 DF id=0 sport=80 flags=SA seq=5 win=65535 rtt=3038.5 ms
len=46 ip=10.0.0.51 ttl=63 DF id=0 sport=80 flags=SA seq=6 win=65535 rtt=3045.1 ms

--- 10.0.0.51 hping statistic ---
10 packets transmitted, 7 packets received, 30% packet loss
round-trip min/avg/max = 4.2/1307.9/3046.3 ms



docker exec -it nginx bash

root@ubuntu:~# docker exec -it nginx bash
root@nginx:/# netstat -i
Kernel Interface table
Iface      MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
eth0       100       33      0      0 0            10      0      0      0 BMRU
lo       65536        0      0      0 0             0      0      0      0 LRU
root@nginx:/# tc -s qdisc show dev eth0
qdisc netem 8001: root refcnt 2 limit 1000 loss 30%
 Sent 548 bytes 10 pkt (dropped 4, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
root@nginx:/# tc qdisc del dev eth0 root netem loss 30%
root@nginx:/# netstat -s
# netstat -s 内核协议栈统计信息
Ip:
    Forwarding: 1                  #1：IP转发开启(容器NAT环境开启转发)
    34 total packets received      #本机网卡一共收到34个IP数据包
    0 forwarded                    #0个数据包经过本机转发出去
    0 incoming packets discarded   #入站报文内核丢弃数量0
    24 incoming packets delivered  #24个IP包递交给上层(TCP/UDP)协议处理
    18 requests sent out          #本机向外发送18个IP报文
Icmp:
    0 ICMP messages received       #未收到任何ICMP报文(ping类报文)
    0 input ICMP message failed    #ICMP报文接收失败数0
    ICMP input histogram:
    0 ICMP messages sent           #本机没有发送ICMP报文
    0 ICMP messages failed         #ICMP发送失败数量0
    ICMP output histogram:
Tcp:
    0 active connection openings   #主动发起TCP连接次数0(客户端向外建连)
    0 passive connection openings  #被动监听被连接次数0(服务端被访问)
    10 failed connection attempts  #TCP连接失败10次
    0 connection resets received  #收到对方RST断开报文0
    0 connections established      #成功完成三次握手建立连接0
    24 segments received          #TCP收到分片总数24
    26 segments sent out           #TCP发出分片总数26
    8 segments retransmitted       #TCP重传报文8个(网络不稳/丢包触发重传)
    0 bad segments received        #收到损坏、校验错误TCP分片0
    0 resets sent                  #本机主动发送RST重置连接0
Udp:
    0 packets received             #UDP入站数据包0
    0 packets to unknown port received #访问本机不存在UDP端口的包0
    0 packet receive errors        #UDP接收异常报错0
    0 packets sent                 #UDP出站发送数据包0
    0 receive buffer errors        #UDP接收缓冲区满溢出丢包0
    0 send buffer errors           #UDP发送缓冲区满溢出丢包0
UdpLite:
TcpExt:
    10 resets received for embryonic SYN_RECV sockets #SYN_RECV半连接阶段收到RST共10次，对应上面连接失败
    0 packet headers predicted     #TCP头部预测优化命中0
    TCPTimeouts: 12                #TCP超时重传触发总次数12(关键异常指标)
    TCPSynRetrans: 8               #SYN握手报文重传8次，和上面segments retransmitted对应
IpExt:
    InOctets: 1360                 #入站总字节1360Bytes
    OutOctets: 792                 #出站总字节792Bytes
    InNoECTPkts: 34                #不带拥塞标记的入站IP包34个
    
    
    
#	容器终端中执⾏exit
root@nginx:/# exit

#主机终端中查询内核配置
root@ubuntu:~# sysctl net.netfilter.nf_conntrack_max
net.netfilter.nf_conntrack_max = 30720
root@ubuntu:~# sysctl net.netfilter.nf_conntrack_count
net.netfilter.nf_conntrack_count = 1


# 在主机中执⾏
docker exec -it nginx bash
# 在容器中执⾏
root@nginx:/# iptables -t filter -nvL
Chain INPUT (policy ACCEPT 24 packets, 960 bytes)
 pkts bytes target     prot opt in     out     source               destination
   10   400 DROP       all  --  *      *       0.0.0.0/0            0.0.0.0/0            statistic mode random probability 0.29999999981

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 18 packets, 792 bytes)
 pkts bytes target     prot opt in     out     source               destination
    8   352 DROP       all  --  *      *       0.0.0.0/0            0.0.0.0/0            statistic mode random probability 0.29999999981
    
    
    
root@nginx:/# iptables -t filter -D INPUT -m statistic --mode random --probability 0.30 -j DROP
root@nginx:/# iptables -t filter -D OUTPUT -m statistic --mode random --probability 0.30 -j DROP

--vm2 再次测试
hping3 -c 10 -S -p 80 10.0.0.51

# # --max-time 3：全局超时3秒，3秒内没完成整个连接+数据接收直接终止curl
root@ubuntu:~# curl --max-time 3 http://10.0.0.51
curl: (28) Operation timed out after 3011 milliseconds with 0 bytes received

--vm1 
tcpdump -i ens33 -nn port 80



# tcpdump -i ens33 -nn port 80
# -i ens33：抓取ens33网卡流量；-nn：IP/端口不解析域名；port80只抓80端口报文
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
# 【三次握手第一步：客户端SYN请求建连】
00:30:10.788229 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [S], seq 2859533998, win 64240, options [mss 1460,sackOK,TS val 2412398474 ecr 0,nop,wscale 6], length 0
# Flags[S]=SYN，客户端10.0.0.52随机端口58570向服务端10.0.0.51:80发起连接请求
# 【三次握手第二步：服务端SYN+ACK回复】
00:30:10.788459 IP 10.0.0.51.80 > 10.0.0.52.58570: Flags [S.], seq 1100733135, ack 2859533999, win 65392, options [mss 256,sackOK,TS val 1085805845 ecr 2412398474,nop,wscale 7], length 0
# Flags[S.]=SYN+ACK，服务端同意建立连接，确认客户端序列号
# 【三次握手第三步：客户端ACK确认，连接正式就绪】
00:30:10.788966 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [.], ack 1, win 1004, options [nop,nop,TS val 2412398475 ecr 1085805845], length 0
# Flags[.]=纯ACK，三次握手完成，可以收发业务数据
# 【客户端发送HTTP GET请求报文(P标识PSH推送数据)】
00:30:10.789000 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [P.], seq 1:74, ack 1, win 1004, options [nop,nop,TS val 2412398475 ecr 1085805845], length 73: HTTP: GET / HTTP/1.1
# P=PSH：内核立即向上层应用递交数据包，长度73字节是GET请求内容
# =========异常开始：服务端无任何HTTP响应，客户端反复重传GET请求============
00:30:10.997845 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [P.], seq 1:74, ack 1, win 1004, options [nop,nop,TS val 2412398683 ecr 1085805845], length 73: HTTP: GET / HTTP/1.1 #第一次超时重传GET
00:30:11.214542 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [P.], seq 1:74, ack 1, win 1004, options [nop,nop,TS val 2412398900 ecr 1085805845], length 73: HTTP: GET / HTTP/1.1 #第二次重传
00:30:11.664424 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [P.], seq 1:74, ack 1, win 1004, options [nop,nop,TS val 2412399350 ecr 1085805845], length 73: HTTP: GET / HTTP/1.1 #第三次重传
00:30:12.492585 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [P.], seq 1:74, ack 1, win 1004, options [nop,nop,TS val 2412400177 ecr 1085805845], length 73: HTTP: GET / HTTP/1.1 #第四次重传
# 客户端发FIN准备关闭连接
00:30:13.801039 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [F.], seq 74, ack 1, win 1004, options [nop,nop,TS val 2412401487 ecr 1085805845], length 0 #F=FIN，客户端请求断开连接
# 服务端ACK确认FIN，但依旧没有返回HTTP数据，还附带sack标记缺失报文
00:30:13.801225 IP 10.0.0.51.80 > 10.0.0.52.58570: Flags [.], ack 1, win 511, options [nop,nop,TS val 1085808858 ecr 2412398475,nop,nop,sack 1 {74:75}], length 0
# 客户端继续重试发送GET（连接没彻底断开，继续重试请求）
00:30:13.802691 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [P.], seq 1:74, ack 1, win 1004, options [nop,nop,TS val 2412401489 ecr 1085808858], length 73: HTTP: GET / HTTP/1.1
00:30:14.016545 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [P.], seq 1:74, ack 1, win 1004, options [nop,nop,TS val 2412401702 ecr 1085808858], length 73: HTTP: GET / HTTP/1.1
00:30:14.438157 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [P.], seq 1:74, ack 1, win 1004, options [nop,nop,TS val 2412402124 ecr 1085808858], length 73: HTTP: GET / HTTP/1.1
00:30:15.267316 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [P.], seq 1:74, ack 1, win 1004, options [nop,nop,TS val 2412402952 ecr 1085808858], length 73: HTTP: GET / HTTP/1.1
00:30:16.929793 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [P.], seq 1:74, ack 1, win 1004, options [nop,nop,TS val 2412404615 ecr 1085808858], length 73: HTTP: GET / HTTP/1.1
00:30:20.359073 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [P.], seq 1:74, ack 1, win 1004, options [nop,nop,TS val 2412408045 ecr 1085808858], length 73: HTTP: GET / HTTP/1.1
00:30:27.010400 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [P.], seq 1:74, ack 1, win 1004, options [nop,nop,TS val 2412414697 ecr 1085808858], length 73: HTTP: GET / HTTP/1.1
00:30:40.332472 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [P.], seq 1:74, ack 1, win 1004, options [nop,nop,TS val 2412428020 ecr 1085808858], length 73: HTTP: GET / HTTP/1.1
00:31:07.721880 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [P.], seq 1:74, ack 1, win 1004, options [nop,nop,TS val 2412455408 ecr 1085808858], length 73: HTTP: GET / HTTP/1.1
# 长时间无应答，服务端主动发FIN关闭连接
00:31:10.861108 IP 10.0.0.51.80 > 10.0.0.52.58570: Flags [F.], seq 1, ack 1, win 511, options [nop,nop,TS val 1085865920 ecr 2412398475,nop,nop,sack 1 {74:75}], length 0
# 客户端ACK确认关闭，四次挥手完成，会话断开
00:31:10.861927 IP 10.0.0.52.58570 > 10.0.0.51.80: Flags [.], ack 2, win 1004, options [nop,nop,TS val 2412458550 ecr 1085865920], length 0



root@ubuntu:~# docker exec -it nginx bash
root@nginx:/# netstat -i
Kernel Interface table
Iface      MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
eth0       100       92      0     56 0            42      0      0      0 BMRU
lo       65536        0      0      0 0             0      0      0      0 LRU
root@nginx:/# ifconfig eth0 mtu 1500


--vm2 再次测试
root@ubuntu:~# curl --max-time 3 http://10.0.0.51

--vm1 
 docker rm -f nginx
 
 
 
# netstat -i ：查看网卡硬件收发统计、丢包、错包（链路层统计）
netstat -i
# 参数释义
# Iface：网卡名称
# MTU：网卡最大传输单元
# RX-OK：成功收到数据包总数
# RX-ERR：接收错误包（网卡硬件/线路故障）
# RX-DRP：内核队列满，接收丢包
# RX-OVR：网卡溢出丢包
# TX-OK：成功发送数据包
# TX-ERR：发送错误
# TX-DRP：发送丢包
# TX-OVR：发送溢出

# netstat -s ：各协议内核栈统计（IP/TCP/UDP/ICMP四层统计）
# 1.IP：整网收包、转发、丢弃统计
# 2.ICMP：ping报文收发、报错统计
# 3.TCP：连接建立、失败、重传、重置、超时（排查TCP丢包首选）
# 4.UDP：入站、未知端口、缓冲区溢出丢包
# 5.TcpExt：TCP详细拓展指标（SYN重传、超时、半连接重置）

# 区分一句话
# netstat -i → 网卡硬件层面丢包
# netstat -s → 内核协议栈、应用层丢包/TCP异常
```



# 内核线程CPU利用率太高，我该怎么办？

Linux在启动过程中，有三个特殊的进程，也就是PID号最小的三个进程。

- 0号进程为idle进程，这也是系统创建的第一个进程，它在初始化1号和2号进程后，演变为空闲任务。当CPU上没有其他任务执行时，就会运行它。
- 1号进程为init进程，通常是systemd进程，在用户态运行，用来管理其他用户态进程。
- 2号进程为kthreadd进程，在内核态运行，用来管理内核线程。





```bash
# 1、kthreadd（PID固定=2，所有内核线程始祖）
# 作用：系统唯一内核线程管理器，负责创建孵化全部其他内核线程(ksoftirqd/kworker/migration等)
# 正常状态：CPU常年0占用，自身几乎不消耗资源
# 查看：ps -f -p2

# 2、ksoftirqd/[0~n]  每颗CPU对应1个软中断线程
# 作用：承接硬件中断后置的软中断任务（网卡收发包NET_RX、磁盘IO等软中断）
# 故障：ksoftirqd CPU飙升 → 网卡流量爆满、软中断过载
# 排查：cat /proc/softirqs | grep NET_RX
ps aux | grep ksoftirqd

# 3、kswapd0 内存回收线程
# 空闲内存不足时回收内存页，把不常用内存置换到Swap
# CPU高 = 物理内存资源枯竭，频繁换入Swap，业务卡顿
free -h

# 4、kworker 内核工作队列线程(新版内核pdflush合并入它)
# kworker/CPU:xx 绑定固定CPU；kworker/uPOOL:xx 全局浮动CPU
# 占用高：磁盘脏页刷盘量大、IO负载打满
cat /proc/meminfo | grep Dirty

# 5、migration/[0~n] 进程CPU迁移线程，单CPU一个
# 内核负载均衡，跨CPU挪动进程；CPU高代表多核负载失衡、频繁进程漂移
mpstat -P ALL 1

# 6、jbd2/sda1-xx  ext4文件系统日志线程，一个ext4分区一条
# 负责文件系统日志落盘；IO高=对应分区大量写入操作
iostat -x 1

# 7、pdflush 老内核(3.10前)脏页刷盘线程，新内核并入kworker，已淘汰
# 负责内存脏页定时写入磁盘

速记汇总
kthreadd(PID2)：所有内核线程老爸，只创建线程
ksoftirqd：软中断→网络繁忙 CPU 高
kswapd0：内存回收→缺内存、swap 暴涨
kworker：内核任务 + 脏页落盘→磁盘 IO 满
migration：进程跨核搬迁→CPU 负载不均衡
jbd2：ext4 日志→分区大量写 IO
pdflush：老旧内核脏页刷盘，新版并入 kworker


# 作用：查看内核主线程 + 它所有派生的内核线程(ksoftirqd、kswapd等)
ps -f --ppid 2 -p 2
ps -fH --ppid 2 -p 2
ps -ef | grep "\[.*\]"
```

案例



```BASH
VM1--10.0.0.51  NGINX
VM2--10.0.0.52  hping3 curl

#	运⾏Nginx服务并对外开放80端⼝
docker run -itd --name=nginx -p 80:80 nginx

--vm2
curl http://10.0.0.51
# -S参数表⽰设置TCP协议的SYN（同步序列号），-p表⽰⽬的端⼝为80
# -i u10表⽰每隔10微秒发送⼀个⽹络帧
# 注：如果你在实践过程中现象不明显，可以尝试把10调⼩，⽐如调成5甚⾄1
hping3 -S -p 80 -i u5 10.0.0.51

root@ubuntu:~# pstack 9
Could not attach to target 9: Operation not permitted.
detach: No such process
root@ubuntu:~# cat /proc/9/stack
[<0>] rcu_gp_kthread+0x8eb/0x980
[<0>] kthread+0x121/0x140
[<0>] ret_from_fork+0x1f/0x40
[<0>] 0xffffffffffffffff
# 1、报错解析：pstack 9 提示 Operation not permitted
# 原因：PID=9是【内核线程rcu_gp】，运行在内核态，pstack(用户态调试工具)不能附着内核进程，无法抓取栈
# 补充：普通用户进程才能用pstack/gdb attach，所有带[]的内核线程都不支持pstack

# 2、cat /proc/9/stack ：内核线程专属栈查看方式（唯一可行）
# [<0>] rcu_gp_kthread+0x8eb/0x980 → 当前正在执行RCU同步回收内核资源，rcu_gp是RCU主线程
# [<0>] kthread+0x121/0x140 → 依托kthread内核框架创建，父进程kthreadd(PID=2)
# [<0>] ret_from_fork+0x1f/0x40 → fork创建线程的系统调用返回栈


root@ubuntu:~# ps -ef |grep ksoftirqd
root          7      2  0 Jun01 ?        00:00:00 [ksoftirqd/0]
root         16      2  0 Jun01 ?        00:00:22 [ksoftirqd/1]
#	采样30s后退出
perf record -a -g -p 9 -- sleep 30
perf record -g -p 9 -- sleep 30

perf record -g -p 16 -- sleep 30
# 查看汇总报告
perf report


# 从perf record记录生成火焰图的工具
git clone https://github.com/brendangregg/FlameGraph
cd FlameGraph

perf script -i /root/perf.data|	./stackcollapse-perf.pl	--all | ./flamegraph.pl > ksoftirqd.svg
scp root@10.0.0.51:/root/FlameGraph/ksoftirqd.svg ./
#使用win 浏览器打开

```





# 套路篇：分析性能问题的一般步骤

系统资源瓶颈  使用   USE法

## 简要释义

1. **Utilization (使用率)**：资源被占用的时间百分比（CPU%、磁盘繁忙率、网卡带宽占用）
2. **Saturation (饱和度)**：资源请求排队积压量（CPU 就绪队列、磁盘 IO 队列、TCP 全连接队列、网卡 ring 队列满）
3. **Errors (错误数)**：各类软硬件异常报错（丢包、磁盘错误、page fault、nf_conntrack 满丢包）

## 落地：CPU / 磁盘 / 网卡 / 内存全部套用 USE

- CPU：使用率高、运行队列饱和、硬件异常 / 内核报错
- 磁盘：% util、IO 队列变长、磁盘读写 error
- 网卡：带宽占用、rx 队列满溢出、rx_fifo_errors/rx_dropped
- 内存：内存占用、swap 飙升、OOM、缺页异常增多



应用程序的监控来说，这些指标显然就不合适了。因为应用程序的核心指标，是请求数、错误数和响应时间。

RED 方法，是 Weave Cloud 在监控微服务性能时，结合 Prometheus 监控，所提出的一种监控思路——即

对微服务来说，监控它们的

- 请求数（Rate）、
- 错误数（Errors）
- 响应时间（Duration）。

所以，RED 方法适用于微服务应用的监控，而 USE 方法适用于系统资源的监控。

```bash
# ===================== Linux CPU性能排查工具思维导图（注释版） =====================
# ① top：整机全局指标查看
# 关键字段：用户CPU、系统CPU、僵尸进程、硬中断、平均负载、iowait(等待IO的CPU)
top

# ② vmstat：整机汇总：上下文切换、中断、就绪进程、D不可中断进程
# cs：上下文切换次数 | in：硬件中断 | r：运行队列 | b：不可中断阻塞进程
vmstat 1

# ③ pidstat：按进程拆分CPU、上下文切换
# cswch/s：自愿上下文切换(进程主动放弃CPU)
# nvcswch/s：非自愿上下文切换(时间片用完、被抢占，CPU瓶颈特征)
pidstat -u 1
pidstat -w 1    # 专门看上下文切换

# /proc/interrupts  硬中断明细（各硬件设备硬中断计数）
cat /proc/interrupts

# /proc/softirqs    软中断明细：NET_RX网卡收、NET_TX网卡发、SCHED调度软中断等
# SCHED软中断上涨 → 非自愿上下文切换飙升
cat /proc/softirqs

# -------------------------- I/O分析工具 --------------------------
dstat -d 1
sar -d 1

# -------------------------- 网络分析工具 --------------------------
sar -n DEV 1
tcpdump -i eth0

# -------------------------- 进程深度定位工具 --------------------------
# perf：内核/用户态调用栈采样，定位CPU高耗函数
perf record -g -p PID sleep 3;perf report
# strace：跟踪进程系统调用
strace -p PID
# ps：静态查看进程状态、僵尸进程
ps -efH
# execsnoop：跟踪进程exec创建，排查频繁短进程创建
execsnoop






```





```bash
#==================== Linux内存排查整套命令（按排查链路顺序）====================
# 第一步：free 查看整机内存大盘：总用/剩余/可用/Buffer/Cache/Swap占用
free -h
#字段对应：
# total:总内存 | used:已用 | free:空闲 | buff/cache:缓冲区+缓存 | available:真正可用内存
# Swap:used=已换出,free=剩余交换分区

# 第二步：vmstat / sar 监控内存趋势、Swap换入换出、缺页异常
vmstat 1
# si:swap in(磁盘→内存换入) | so:swap out(内存→磁盘换出) | fault:缺页异常
sar -r 1       # 内存使用率趋势
sar -S 1       # Swap分区使用趋势

# ================== 判断内存瓶颈的6类现象 ==================
# 1.系统剩余内存不足；2.可用内存available偏低；3.缓存占用过大
# 4.内存泄漏(进程RSS持续上涨不回落)；5.缺页异常(fault)飙升
# 6.si/so频繁非0，大量使用Swap、Swap剩余空间不足

#================= 分支1：进程内存分析（定位哪个进程吃内存）=================
# top / pidstat 查看进程内存、缺页
top
pidstat -r 1
# %MEM内存占比 | VSZ虚拟内存 | RSS常驻物理内存 | minflt/majflt缺页异常

# pmap / proc/pid 精细化查看单进程内存分布
pmap -x <PID>
cat /proc/<PID>/status    # VmRSS/VmSize实际占用
cat /proc/<PID>/smaps    # 细分内存段(堆/栈/共享库)

#================= 分支2：缓存/缓冲区占用过高分析 =================
cachetop          # 查看页缓存占用来源进程
cachestat         # 缓存读写命中统计
slabtop           # 内核slab缓存(内核对象占用内存)
pcstat            # 查看文件pagecache占用

# 手动释放buff/cache（应急）
echo 3 > /proc/sys/vm/drop_caches

#================= 分支3：内存泄漏/内核内存分配分析 =================
valgrind  # 开发态检测用户态内存泄漏
memleak   # bpf工具在线追踪内存泄漏(生产无停机)
strace    # 跟踪mmap/brk内存申请系统调用
slabtop   # 内核slab泄漏排查
cat /proc/buddyinfo # 内核伙伴系统，查看物理内存碎片
```





```bash
#==================== Linux磁盘IO性能排查全流程（按思维导图排查顺序） ====================
# 第一步：iostat / sar 整机磁盘大盘指标（确认IO瓶颈）
# 指标：IO使用率%util、IOPS(r/s w/s)、吞吐量(rkB/wkB)、平均响应时间(await)
iostat -x 1
sar -d 1

# 第二步：vmstat 辅助验证iowait、缓存、Swap波动
# %iowait：CPU等待IO耗时占比；si/so：swap换入换出(内存不足引发被动磁盘IO)
vmstat 1

# 第三步：pidstat 按进程粒度拆分IO：单进程读、写、IO延迟
pidstat -d 1

# ================== 拆分3大类IO源头（内核线程 / 普通进程 / 内存缓存刷盘） ==================
## 分支1：内核线程IO排查（kswapd、jbd2、kworker等内核线程刷盘IO）
# 文件系统&磁盘分析工具
df -h && du -sh /*                  # df磁盘挂载、du目录占用
blktrace /dev/sda                   # 块设备IO全链路追踪
perf record -g sleep 3;perf report  # perf定位耗IO内核函数
biosnoop                            # bpf追踪块设备IO延迟
biotop                              # 按磁盘排序IO占用进程

## 分支2：普通用户进程IO定位
# strace：跟踪进程读写系统调用、fd、IO参数
strace -p <PID> -e trace=read,write
# lsof：查看进程打开文件、磁盘、网络fd
lsof -p <PID>
# 从lsof结果区分：操作本地文件/磁盘分区 → 应用分析(MySQL/Redis)；操作socket → 网络分析

## 分支3：内存/缓存引发的IO（脏页刷盘、缓存占用过高触发落盘）
# 内存缓存专项排查
cat /proc/meminfo
cat /proc/slabinfo
slabtop          # 内核slab内存占用
pcstat           # 查看文件占用pagecache大小
cachetop         # 统计页缓存对应进程
cachestat        # 缓存读写命中、缺页统计

# 补充：缓存过高应急清理(临时释放pagecache)
echo 3 > /proc/sys/vm/drop_caches


# 1.iostat看磁盘整体繁忙 → vmstat看iowait是否走高、swap是否频繁换入
# 2.pidstat定位哪个进程耗IO，区分三类来源：
#    ①kworker/jbd2/kswapd内核线程IO → biosnoop/biotop/perf查内核刷盘
#    ②应用进程(MySQL) → strace+lsof查读写文件
#    ③buff/cache过大脏页落盘 → cachetop/slabtop/pcstat查缓存占用
# 3.lsof区分：进程是本地磁盘IO 还是网络IO
```





```bash
# ===================== Linux网络收发全链路性能排查（对照网卡收发流程图） =====================
## 收包全链路：网线→网卡硬件FIFO → DMA→RX Ring(内存环形缓冲) → ksoftirqd软中断 → 内核协议栈(链路/IP/TCP) → socket接收缓冲区 → 应用recv()
## 发包全链路：应用send() → socket发送缓冲区 → TCP/IP封装 → TX Ring → DMA→网卡硬件FIFO → 网线发出

#========== 1、第一层：网卡硬件 + RX/TX环形Ring缓冲区排查（链路层，对应图中环形缓冲区DMA）==========
# 查看网卡Ring缓冲区大小(RX=接收环，TX=发送环，在内核内存)
ethtool -g eth0
# 修改Ring大小（临时扩容，解决ring满丢包）
ethtool -G eth0 rx 2048 tx 2048

# 查看网卡硬件丢包：rx_fifo_errors=网卡硬件FIFO溢出丢包；rx_dropped=RX Ring满内核丢包
ethtool -S eth0 | grep -E "rx_fifo_errors|rx_dropped|tx_fifo_errors|tx_dropped"

# 查看网卡带宽占用
sar -n DEV 1

#========== 2、第二层：软中断&内核协议栈（ksoftirqd处理网卡收发包软中断，/proc/softirqs）==========
# 查看软中断统计：NET_RX(网卡接收软中断暴涨=收包瓶颈)、NET_TX(网卡发送软中断)
cat /proc/softirqs
# 查看ksoftirqd软中断线程CPU占用（ksoftirqd占用高→网卡流量过载）
pidstat -u 1 | grep ksoftirqd

#========== 3、第三层：TCP内核参数 + Socket收发缓冲区（图中套接字缓冲区）==========
# tcp_rmem：socket接收缓冲区  min/默认/max；tcp_wmem：socket发送缓冲区
sysctl net.ipv4.tcp_rmem
sysctl net.ipv4.tcp_wmem

# 查看TCP全连接/半连接队列溢出（listen队列满导致建连失败）
cat /proc/net/synq
ss -s

# nf_conntrack连接跟踪满丢包（之前学的连接表打满丢新连接）
sysctl net.netfilter.nf_conntrack_max
sysctl net.netfilter.nf_conntrack_count

#========== 4、第四层：连接&进程网络定位（套接字→应用程序）==========
# ss：查看TCP连接状态(ESTAB/TIME_WAIT/LISTEN)，替代老旧netstat
ss -antp

# lsof：查看进程占用的socket、端口（定位哪个应用收发数据）
lsof -i :端口号

# tcpdump抓包：链路层抓原始数据包，排查报文异常
tcpdump -i eth0 -nn

#========== 5、分层故障快速定位口诀（对照收发流程图）==========
# 1、rx_fifo_errors上涨 → 网卡硬件缓存太小，硬件丢包
# 2、rx_dropped上涨 → RX Ring缓冲区不足，内核层丢包，ethtool -G扩容RX
# 3、/proc/softirqs NET_RX飙升 + ksoftirqd CPU高 → 网卡收包过载，软中断瓶颈
# 4、大量syn丢包/连接超时 → 全连接队列满(Listen)或nf_conntrack表打满
# 5、应用recv卡顿 → socket接收缓冲区过小，调大tcp_rmem
```





应用程序瓶颈

1. 资源瓶颈，其实还是指刚才提到的CPU、内存、磁盘和文件系统I/O、网络以及内核资源等各类软硬
   件资源出现了瓶颈，从而导致应用程序的运行受限。对于这种情况，我们就可以用前面系统资源瓶颈模块提到的各种方法来分析。
2. 依赖服务的瓶颈，也就是诸如数据库、分布式缓存、中间件等应用程序，直接或者间接调用的服务出现了性能问题，从而导致应用程序的响应变慢，或者错误率升高。这说白了就是跨应用的性能问题，使用全链路跟踪系统，就可以帮你快速定位这类问题的根源。
3. 应用程序自身的性能问题，包括了多线程处理不当、死锁、业务算法的复杂度过高等等。对于这类问题，在我们前面讲过的应用程序指标监控以及日志监控中，观察关键环节的耗时和内部执行过程中的错误，就可以帮你缩小问题的范围。

```bash
# ================== 常规CPU/内存/磁盘/网络排查无果 → 应用进程深度性能定位命令集 ==================
## 模块1：strace 追踪进程系统调用（定位阻塞、频繁读写、网络、文件操作瓶颈）
# -p 附着运行中进程；-tt打印时间戳；-e 筛选指定系统调用(read/write/connect/open)
strace -tt -p <应用PID>
# 只监控文件读写+网络相关系统调用，精简输出
strace -tt -e trace=open,read,write,connect,send,recv -p <PID>
# 统计各类系统调用耗时、调用次数（-c汇总统计，跑完自动出报表）
strace -c -p <PID>

## 模块2：perf 采样 + 火焰图 定位CPU热点函数（用户态/内核态耗时最高代码）
# 1. 对指定进程采样30秒，-g抓取调用栈，生成perf.data
perf record -g -p <PID> -- sleep 30
# 2. 交互式查看热点函数（文本报表）
perf report -g
# 3. 生成火焰图svg（需安装flamegraph脚本，可视化看CPU耗时链路）
perf script | ./stackcollapse-perf.pl | ./flamegraph.pl > app_flame.svg

# 补充：全系统采样，找不到对应进程时使用
perf record -g -a sleep 30

## 模块3：BPF动态追踪工具（无侵入动态跟踪，定位隐式瓶颈：内存泄漏、频繁打开文件、慢IO、进程频繁创建）
### 3.1 opensnoop：跟踪进程所有open打开文件，排查频繁磁盘小文件IO
opensnoop -p <PID>
### 3.2 execsnoop：跟踪进程频繁fork/exec新建子进程（大量短进程消耗CPU/上下文切换）
execsnoop
### 3.3 memleak：在线追踪应用内存泄漏（生产无需停机，定位堆内存持续上涨）
memleak -p <PID>
### 3.4 biosnoop：跟踪进程单次磁盘IO耗时，排查偶发IO卡顿
biosnoop -p <PID>


# 1. strace看到大量read/write阻塞 → 应用磁盘IO瓶颈；大量connect阻塞 → 网络调用超时
# 2. perf火焰图某自定义函数占CPU过高 → 应用代码逻辑CPU密集型瓶颈
# 3. opensnoop疯狂输出大量小文件open → 应用频繁打开关闭文件拖慢性能
# 4. execsnoop刷屏大量进程 → 程序频繁创建销毁进程，上下文切换飙升
# 5. memleak持续统计内存上涨 → 用户态代码内存泄漏，RSS持续走高
```



# 优化性能问题的一般方法



```bash
# ========================= CPU三大优化实操命令（3类优化：CPU亲和、中断均衡、优先级+cgroup限流） =========================
# 优化1：进程CPU亲和性（taskset：绑定进程到指定CPU核心，提升cache命中率、减少上下文切换）
## 语法：taskset -c CPU核心号 PID；核心编号从0开始
# 1. 运行程序时直接绑定到CPU0、1
taskset -c 0,1 ./your_app

# 2. 对已在运行的PID=1234进程，修改绑定至CPU2、3
taskset -cp 2,3 1234

# 3. 查看进程当前CPU绑定状态
taskset -p 1234

# 优化2：硬件中断IRQ多CPU负载均衡（irqbalance + /proc/irq，分散硬中断到多核，避免单CPU被软/硬中断打满）
## 方式1：启用irqbalance服务（自动把各硬件中断分散到各个CPU，生产推荐）
systemctl enable --now irqbalance

## 方式2：手动指定某中断号绑定CPU掩码（可选，特殊网卡手动调优）
# 查看所有硬件中断编号
cat /proc/interrupts
# 示例：中断号54，绑定CPU0~3，掩码0xf(二进制1111)
echo f > /proc/irq/54/smp_affinity

# 优化3：进程优先级调整 + Cgroups CPU资源配额限制（防止进程吃满整机CPU，核心业务提优先级）
### 3.1 nice/renice 修改进程调度优先级（nice范围：-20最高优先级 ~ 19最低，root可设负值）
# 启动程序时设置高优先级(nice -10)
nice -n -10 ./core_business_app
# 已运行PID=5678，调高优先级
renice -n -15 -p 5678

### 3.2 chrt 修改实时调度优先级（对核心业务设置SCHED_FIFO实时调度，抢占优先）
# SCHED_FIFO实时优先级，优先级50
chrt -f -p 50 5678

### 3.3 cgroup 限制进程最大CPU使用率（限制进程最多占用1核CPU，避免耗空资源）
# 1.挂载cgroup控制器（部分系统已自动挂载）
mkdir -p /sys/fs/cgroup/cpu/my_limit_cg
# 2.限制该cgroup最多使用1个CPU（cpu.cfs_quota_us=100000，周期默认100000）
echo 100000 > /sys/fs/cgroup/cpu/my_limit_cg/cpu.cfs_quota_us
echo 100000 > /sys/fs/cgroup/cpu/my_limit_cg/cpu.cfs_period_us
# 3.把目标进程PID写入cgroup，进程自动受限
echo 5678 > /sys/fs/cgroup/cpu/my_limit_cg/cgroup.procs

# ==================优化原理备注=================
# 1.CPU亲和taskset：进程固定跑在指定CPU，L1/L2 Cache不会频繁失效，减少缓存颠簸、减少调度
# 2.irqbalance：网卡/磁盘硬件中断分散多核，防止单CPU被ksoftirqd占满
# 3.nice/chrt：核心业务调高调度优先级；cgroup限流：流氓进程无法抢占全部CPU算力



```





```bash
# ===================== Linux内存三大优化实操命令（对应文档3种优化方案） =====================
## 优化1：Swap优化，尽量关闭/调低swap使用率，避免频繁磁盘换页拖慢性能
# 1.临时关闭swap（立即生效）
swapoff -a
# 永久关闭swap：注释/etc/fstab里swap挂载项
sed -i '/swap/s/^/#/' /etc/fstab

# 2.不关闭swap时，调整swappiness(0~100，值越小越尽量不用swap；推荐生产设10)
# swappiness=0：尽量优先使用物理内存，迫不得已才用swap
sysctl -w vm.swappiness=10
# 永久写入配置
echo "vm.swappiness=10" >> /etc/sysctl.conf && sysctl -p

# 3.应急手动释放页缓存/目录项/Inode缓存（buff/cache占用过高时）
# 1：释放页缓存；2：释放 dentries+inode；3：全部释放
echo 3 > /proc/sys/vm/drop_caches

## 优化2：Cgroup限制进程最大内存 + 核心应用调低oom_score防OOM杀死
### 2.1 cgroup对进程做内存配额，防止单个进程耗尽整机内存
# 创建内存cgroup目录
mkdir -p /sys/fs/cgroup/memory/app_limit
# 限制最大物理内存512M，超出触发OOM
echo 536870912 > /sys/fs/cgroup/memory/app_limit/memory.limit_in_bytes
# 限制swap使用上限(可选，512M)
echo 536870912 > /sys/fs/cgroup/memory/app_limit/memory.swap_limit_in_bytes
# 将目标进程PID加入cgroup管控
echo 1234 > /sys/fs/cgroup/memory/app_limit/cgroup.procs

### 2.2 降低核心进程oom_score_adj（-1000：永远不会被OOM杀手杀掉；0默认；1000最容易被杀）
# PID=1234是核心业务进程，设置为-900，大幅降低被OOM干掉概率
echo -900 > /proc/1234/oom_score_adj
# 查看当前值
cat /proc/1234/oom_score_adj

## 优化3：配置HugePage大页内存，减少缺页异常、减少动态内存分配开销
# 1.查看当前系统空闲大页、默认单页大小(2MB标准大页)
grep Huge /proc/meminfo

# 2.临时配置预留128个2M大页(128*2M=256M)
sysctl -w vm.nr_hugepages=128
# 永久配置大页数量
echo "vm.nr_hugepages=128" >> /etc/sysctl.conf && sysctl -p

# 3.挂载大页文件系统，应用挂载使用
mkdir /mnt/huge
mount -t hugetlbfs none /mnt/huge

# 补充：透明大页THP优化（数据库常用，按需开启/关闭）
# 关闭透明大页（数据库如MySQL推荐关闭，减少内存碎片）
echo never > /sys/kernel/mm/transparent_hugepage/enabled


# 优化原理注释
# 1.swap：调低swappiness减少si/so磁盘IO，swapoff彻底杜绝交换IO，解决swap频繁换入换出性能下滑
# 2.cgroup：限制进程内存上限防内存溢出；oom_score_adj调低，核心业务规避OOM kill
# 3.大页HugePage：大页减少TLB缺失、减少minor缺页，降低内核动态内存分配开销
```



```bash
#==================== 磁盘&文件系统IO三类优化实操命令（对应文档3大优化方向） ====================
## 优化1：硬件层优化（SSD替换HDD、RAID配置为硬件操作，系统侧相关查看命令）
# 查看磁盘类型（SSD/HDD）
lsblk -d -o name,rota
# rota=0 → SSD固态硬盘；rota=1 → HDD机械盘

# 查看RAID状态（软RAID mdadm）
cat /proc/mdstat
mdadm -D /dev/md0

## 优化2：修改磁盘IO调度算法（SSD用noop，数据库HDD用deadline，以sda举例）
# 1.查看当前磁盘调度策略
cat /sys/block/sda/queue/scheduler

# 2.SSD磁盘临时修改为noop调度
echo noop > /sys/block/sda/queue/scheduler
# 数据库机械盘临时改成deadline
echo deadline > /sys/block/sda/queue/scheduler
# 永久修改：内核启动参数 elevator=noop（/etc/grub.cfg配置）

# 优化磁盘队列深度（增大队列提升并发IO，SSD常用）
cat /sys/block/sda/queue/nr_requests
echo 512 > /sys/block/sda/queue/nr_requests

# 磁盘预读优化（blockdev设置预读扇区，数据库调高预读）
# 查看当前预读(单位：扇区，1扇区=512B)
blockdev --getra /dev/sda
# 设置预读16384扇区=8M
blockdev --setra 16384 /dev/sda

## 优化3：内核脏页缓存参数优化（脏页刷新阈值、刷盘频率，管控buffer/cache落盘时机）
# 查看当前脏页配置
sysctl vm.dirty_ratio vm.dirty_background_ratio vm.dirty_expire_centisecs vm.dirty_writeback_centisecs

# vm.dirty_background_ratio：后台开始异步刷脏页占内存百分比(默认10，数据库建议5)
# vm.dirty_ratio：脏页占内存上限，超过则应用同步阻塞刷盘(默认20，数据库建议10)
sysctl -w vm.dirty_background_ratio=5
sysctl -w vm.dirty_ratio=10
# 脏页超期5秒(500厘秒)强制刷盘
sysctl -w vm.dirty_expire_centisecs=500
# 每1秒唤醒pdflush线程检查脏页
sysctl -w vm.dirty_writeback_centisecs=100

# 永久写入sysctl配置
echo "vm.dirty_background_ratio=5" >> /etc/sysctl.conf
echo "vm.dirty_ratio=10" >> /etc/sysctl.conf
sysctl -p

# 优化inode/dentry缓存回收倾向(增大vfs_cache_pressure，更快回收目录和inode缓存，默认100)
# 数值越大越积极回收，业务小文件多可上调至150~200
sysctl -w vm.vfs_cache_pressure=150
echo "vm.vfs_cache_pressure=150" >> /etc/sysctl.conf

## 补充：文件系统挂载优化（mount参数优化，数据库挂载常用）
# 示例：ext4挂载关闭atime(减少元数据写IO)
# /etc/fstab挂载参数添加 noatime,nodiratime
mount -o remount,noatime,nodiratime /data

# 临时手动释放脏缓存(应急清理大量buff/cache)
echo 3 > /proc/sys/vm/drop_caches

#优化注释说明
#1.IO调度：SSD无机械寻道→noop(极简调度)；机械盘数据库→deadline(保证IO截止时间，防饥饿)
#2.脏页参数：调低dirty_background/ratio，减少瞬间大量刷盘引发IO毛刺；
#3.vfs_cache_pressure上调：频繁创建删除小文件场景，加速回收inode/dentry缓存，减少内存占用；
#4.noatime挂载：取消文件访问时间记录，大幅减少随机元数据写IO

```





```bash
# ===================== Linux网络三层优化实操（内核TCP参数+网卡卸载+DPDK/XDP简介） =====================
## 一、内核TCP协议栈参数优化（sysctl配置：缓冲区、连接数、超时、端口复用、MTU）
# 1. TCP收发缓冲区优化（增大socket缓冲，提升大流量吞吐）
sysctl -w net.ipv4.tcp_rmem="4096 87380 67108864"
sysctl -w net.ipv4.tcp_wmem="4096 65536 67108864"
# 全局TCP内存上限
sysctl -w net.ipv4.tcp_mem="786432 1048576 1572864"

# 2. 系统最大文件句柄/本地端口范围（海量连接必备）
# 本地临时修改端口范围
sysctl -w net.ipv4.ip_local_port_range="1024 65535"
# 系统全局最大fd
echo "* soft nofile 655350" >> /etc/security/limits.conf
echo "* hard nofile 655350" >> /etc/security/limits.conf

# 3. nf_conntrack连接跟踪表扩容（防止连接表打满丢包）
sysctl -w net.netfilter.nf_conntrack_max=1048576
sysctl -w net.netfilter.nf_conntrack_tcp_timeout_established=3600

# 4. TIME_WAIT优化：开启端口复用、快速回收，减少超时积压
sysctl -w net.ipv4.tcp_tw_reuse=1
sysctl -w net.ipv4.tcp_tw_recycle=0  # centos7+关闭recycle，改用reuse
sysctl -w net.ipv4.tcp_fin_timeout=30

# 5. Keepalive保活参数优化（缩短探测间隔，快速清理死连接）
sysctl -w net.ipv4.tcp_keepalive_time=300
sysctl -w net.ipv4.tcp_keepalive_intvl=30
sysctl -w net.ipv4.tcp_keepalive_probes=3

# 6. 开启反向地址校验，防伪造报文
sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.default.rp_filter=1

# 7. 调整网卡MTU（以太网标准1500，巨帧9000）
ip link set eth0 mtu 9000

# 永久保存所有sysctl参数
sysctl -p /etc/sysctl.conf

## 二、网卡硬件优化（ethtool：RSS/GRO/GSO/环形缓冲区、多队列、中断均衡）
# 1. 查看网卡卸载功能状态
ethtool -k eth0
# 开启GRO/GSO/TX/UFO硬件卸载（把TCP分片计算交给网卡硬件，减负CPU）
ethtool -K eth0 gro on gso on tx offload on

# 2. 调整RX/TX环形Ring缓冲区大小，提升网卡缓冲，减少rx_fifo丢包
ethtool -g eth0
ethtool -G eth0 rx 4096 tx 4096

# 3. RSS多队列+irqbalance（多中断分散多核CPU，ksoftirqd不单核打满）
systemctl enable --now irqbalance
# 查看网卡队列数
ethtool -l eth0
# 修改网卡收发队列数量（和CPU核心对齐）
ethtool -L eth0 rx 4 tx 4

# 4. 查看网卡丢包统计
ethtool -S eth0 | grep -E "rx_fifo|rx_dropped|tx_dropped"

## 三、高性能旁路方案：XDP/DPDK（绕开内核协议栈，超高并发C10M场景）
### XDP（内核原生，无需驱动改造，eBPF抓包前置处理）
# 查看网卡是否支持XDP
ip link show eth0
# 加载xdp程序（示例，需要编译xdp.o）
ip link set eth0 xdp object xdp.o

### DPDK（用户态轮询，完全绕过内核，需绑定网卡到vfio驱动）
# 网卡绑定DPDK驱动示例
dpdk-devbind.py --bind=vfio-pci eth0
# 配套优化：大页+CPU亲和（前面内存/CPU优化命令：hugepage、taskset）

## 补充查看网络指标命令
ss -s                  # 全量连接统计
sar -n DEV 1           # 网卡实时流量
cat /proc/softirqs     # NET_RX/NET_TX软中断计数

# 优化要点注释
# 1.内核参数：调大缓冲区+端口+连接表，解决海量连接；tw_reuse复用time_wait端口减少端口耗尽
# 2.网卡卸载GRO/GSO：TCP分段由硬件完成，大幅降低ksoftirqd软中断CPU占用
# 3.RSS多队列：网卡多队列对应多核中断，分散NET_RX软中断负载
# 4.XDP/DPDK：超高并发C10M场景绕内核协议栈，规避内核TCP栈瓶颈
```



# 应用程序 5 大方向优化伪代码（代码设计层面优化，配套注释）

## 1、CPU 优化：精简算法、异步、减少无效计算，降低 CPU 开销



```python
# 优化前：暴力全量遍历(高CPU，O(n²)低效算法)
def query_user_all():
    for user in all_user_list: # 全量循环遍历，海量数据CPU暴涨
        if user.id == target_id:
            return user

# 优化后：哈希索引+异步解耦，降低循环CPU消耗(O(1)查找)
user_hash_map = dict() # 全局缓存索引，预加载数据
# 异步任务：非阻塞异步处理耗时逻辑，不阻塞主线程占用CPU
@async_task
def preload_user_data():
    for user in db.select("select id,name from user"):
        user_hash_map[user.id] = user

def query_user_opt(target_id):
    return user_hash_map.get(target_id, None) # 哈希直接查找，大幅减少CPU运算
```

## 2、IO 优化：本地缓存代替频繁磁盘 SQL 查询，减少随机磁盘 IO



```java
//优化前：每次请求直接查DB，频繁磁盘IO拖慢响应
User getUser(long uid){
    return db.query("select * from user where id=?",uid); // 每次都落盘查库，大量IO
}

//优化后：本地内存缓存+读写分离，命中缓存不走磁盘
Map<Long,User> localCache = new ConcurrentHashMap<>();
User getUserOpt(long uid){
    //1.优先读取内存缓存
    User cacheUser = localCache.get(uid);
    if(cacheUser != null) return cacheUser;
    //2.缓存未命中才查询DB
    User dbUser = db.query("select * from user where id=?",uid);
    localCache.put(uid,dbUser); //写入缓存，后续请求复用
    return dbUser;
}
```

## 3、内存优化：内存池预分配 + 大页，避免频繁动态 malloc/free 缺页异常



```c
//优化前：频繁动态申请释放内存（频繁malloc造成缺页、内存碎片）
void handle_request(){
    char* buf = malloc(4096); // 每次临时申请内存，用完释放
    deal_data(buf);
    free(buf);
}

//优化后：内存池提前批量预分配内存，从池中取用，减少动态分配
#define POOL_SIZE 1024
char* memory_pool[POOL_SIZE];
//程序启动时一次性预分配内存（配合系统HugePage大页）
void pool_init(){
    for(int i=0;i<POOL_SIZE;i++){
        memory_pool[i] = huge_malloc(4096); // 使用大页内存申请
    }
}
//从内存池获取空闲内存，无需反复malloc
char* pool_get_buf(){
    return get_free_node(memory_pool);
}
void handle_request_opt(){
    char* buf = pool_get_buf(); // 复用池内存，无动态分配
    deal_data(buf);
    pool_free_buf(buf); //归还池子，不释放到OS
}
```

## 4、网络优化：IO 多路复用 + 长连接池，替代短连接频繁建连断连



```go
//优化前：短连接模型，每次请求新建TCP，三次握手+四次挥手消耗网络/CPU
func short_link_req(){
    conn,err := net.Dial("tcp","127.0.0.1:3306") // 每次新建连接
    write_data(conn,req)
    read_resp(conn)
    conn.Close() //用完立刻关闭，大量TIME_WAIT
}

//优化后：连接池+epoll IO多路复用，长连接复用socket
var client_pool *ConnPool //全局长连接池，初始化提前创建N条TCP长连接
func long_link_req(){
    conn := client_pool.GetConn() //从池子取存活长连接，不再新建
    write_data(conn,req)
    read_resp(conn)
    client_pool.PutConn(conn) //归还连接，不关闭socket
}
//epoll多路复用：单线程监听成千上百fd，不用一连接一线程
func epoll_server(){
    epfd := epoll_create()
    epoll_add(epfd,listen_fd)
    for{
        events := epoll_wait(epfd) //阻塞等待就绪事件
        for _,ev := range events{ handle_event(ev) }
    }
}
```

## 5、进程模型优化：多线程 / 异步队列，充分利用多核 CPU



```python
from concurrent.futures import ThreadPoolExecutor
#优化前：单线程串行处理请求，无法利用多核CPU
def server_single():
    while True:
        req = accept_socket()
        handle_business(req) #串行阻塞，CPU跑不满

#优化后：线程池+异步任务，多线程并发利用多核
executor = ThreadPoolExecutor(max_workers=8) #线程池数量匹配CPU核心数
def server_multi():
    while True:
        req = accept_socket()
        executor.submit(handle_business,req) #提交异步任务，多线程并行处理
```

## 补充架构优化：MQ 异步削峰、分布式负载均衡（伪代码）



```java
//优化前：同步调用下游服务，峰值压垮DB/接口
void create_order(){
    db.insert_order();
    rpc_call_pay();//同步阻塞调用支付服务，高峰并发卡死
}

//优化后：MQ异步解耦，下单发消息，下游异步消费
void create_order_mq(){
    db.insert_order();
    mq.send("order_topic",orderMsg); //投递消息立刻返回，不阻塞
}
//消费者异步处理支付
@MqListener(topic="order_topic")
void consume_order(OrderMsg msg){
    rpc_call_pay(msg); //异步削峰，规避瞬时高并发
}
```



# Linux性能工具速查



```bash
CPU性能指标
    ├─CPU使用率
    │   ├─用户CPU
    │   ├─系统CPU
    │   ├─IOWAIT
    │   ├─软中断
    │   ├─硬中断
    │   ├─窃取CPU
    │   └─客户CPU
    ├─上下文切换
    │   ├─自愿上下文切换
    │   └─非自愿上下文切换
    ├─平均负载
    └─CPU缓存命中率
    
# 平均负载
# uptime top /proc/loadavg
# uptime最简单；top提供了更全的指标；/proc/loadavg常用于监控系统

# 系统CPU使用率
# vmstat mpstat top sar /proc/stat
# top、vmstat、mpstat 只可以动态查看，而 sar 还可以记录历史数据；/proc/stat是其他性能工具的数据来源，也常用于监控

# 进程CPU使用率
# top ps pidstat htop atop
# top和ps可以按CPU使用率给进程排序，而pidstat只显示实际用了CPU的进程；htop和atop以不同颜色显示更直观

# 系统上下文切换
# vmstat
# 除了上下文切换次数，还提供运行状态和不可中断状态进程的数量

# 进程上下文切换
# pidstat
# 注意加上 -w 选项

# 软中断
# top mpstat /proc/softirqs
# top提供软中断CPU使用率，而/proc/softirqs和mpstat提供了各种软中断在每个CPU上的运行次数

# 硬中断
# vmstat /proc/interrupts
# vmstat提供总的中断次数，而/proc/interrupts提供各种中断在每个CPU上运行的累积次数

# 网络
# dstat sar tcpdump
# dstat和sar提供总的网络接收和发送情况，而tcpdump则是动态抓取正在进行的网络通讯

# I/O
# dstat sar
# dstat和sar都提供了I/O的整体情况

# CPU缓存
# perf
# 使用 perf stat 子命令

# CPU数
# lscpu /proc/cpuinfo
# lscpu更直观

# 事件剖析
# perf、火焰图 execsnoop
# perf和火焰图用来分析热点函数以及调用栈，execsnoop用来监测短时进程

# 动态追踪
# ftrace bcc、systemtap
# ftrace用于跟踪内核函数调用栈，而bcc和systemtap则用于跟踪内核或应用程序的执行过程（注意bcc要求内核版本>=4.1）



内存性能指标
    |-系统内存指标
    |    |-已用内存
    |    |-剩余内存
    |    |-可用内存
    |    |-缺页异常
    |    |    |-主缺页异常
    |    |    |-次缺页异常
    |    |-缓存/缓冲区
    |    |    |-使用量
    |    |    |-命中率
    |    |-Slabs
    |-进程内存指标
    |    |-虚拟内存（VSS）
    |    |-常驻内存（RSS）
    |    |-按比例分配共享内存后的物理内存（PSS）
    |    |-独占内存（USS）
    |    |-共享内存
    |    |-SWAP内存
    |    |-缺页异常
    |    |    |-主缺页异常
    |    |    |-次缺页异常
    |-SWAP
    |    |-已用空间
    |    |-剩余空间
    |    |-换入速度
    |    |-换出速度
    
    
# 系统已用、可用、剩余内存
# free、vmstat、sar /proc/meminfo
# free最为简单，而vmstat、sar更为全面；/proc/meminfo是其他工具的数据来源，也常用于监控系统中

# 进程虚拟内存、常驻内存、共享内存
# ps、top、pidstat /proc/pid/stat /proc/pid/status
# ps和top最简单，而pidstat则需要加上-r选项；/proc/pid/stat和/proc/pid/status是其他工具的数据来源，也常用于监控系统中

# 进程内存分布
# pmap /proc/pid/maps
# /proc/pid/maps是pmap的数据来源

# 进程Swap换出内存
# top、/proc/pid/status
# /proc/pid/status是top的数据来源

# 进程缺页异常
# ps、top、pidstat
# 注意给pidstat加上-r选项

# 系统换页情况
# sar
# 注意加上-B选项

# 缓存/缓冲区用量
# free、vmstat 、sar cachestat
# vmstat最常用，而cachestat需要安装bcc

# 缓存/缓冲区命中率
# cachetop
# 需要安装bcc

# SWAP已用空间和剩余空间
# free、sar
# free最为简单，而sar还可以记录历史

# Swap换入换出
# vmstat、sar
# vmstat最为简单，而sar还可以记录历史

# 内存泄漏检测
# memleak、valgrind
# memleak需要安装bcc，valgrind还可以在旧版本（如3.x）内核中使用

# 指定文件的缓存大小
# pcstat
# 需要从源码下载安装 https://github.com/tobert/pcstat   


I/O性能指标
    |-文件系统
    |    |-存储空间容量、使用量以及剩余空间
    |    |-索引节点容量、使用量以及剩余量
    |    |-缓存
    |    |    |-页缓存
    |    |    |-目录项缓存
    |    |    |-索引节点缓存
    |    |    |-具体文件系统缓存（如ext4的缓存）
    |    |-IOPS（文件I/O）
    |    |-响应时间（延迟）
    |    |-吞吐量（B/s）
    |-磁盘
    |    |-使用率
    |    |-IOPS
    |    |-吞吐量（B/s）
    |    |-响应时间（延迟）
    |    |-缓冲区
    |    |-相关因素
    |    |    |-读写类型（如顺序还是随机）
    |    |    |-读写比例
    |    |    |-读写大小
    |    |    |-存储类型（如RAID级别、本地还是网络）
    
# 文件系统空间容量、使用量以及剩余空间
# df
# 详细文档可以执行 info coreutils 'df invocation' 命令查询

# 索引节点容量、使用量以及剩余量
# df
# 注意加上 -i 选项

# 页缓存和可回收Slab缓存
# /proc/meminfo sar、vmstat
# 注意sar需要加上-r选项，而/proc/meminfo是其他工具的数据来源，也常用于监控

# 缓冲区
# /proc/meminfo sar、vmstat
# 注意sar需要加上-r选项，而/proc/meminfo是其他工具的数据来源，也常用于监控

# 目录项、索引节点以及文件系统的缓存
# /proc/slabinfo slabtop
# slabtop更直观，而/proc/slabinfo常用于监控

# 磁盘I/O使用率、IOPS、吞吐量、响应时间、I/O平均大小以及等待队列长度
# iostat、sar、dstat /proc/diskstats
# iostat最为常用，注意使用 iostat -d -x 或 sar -d 选项；/proc/diskstats则是其他工具数据来源，也常用于监控

# 进程I/O大小以及I/O延迟
# pidstat、iotop
# 注意使用 pidstat -d 选项

# 块设备I/O事件跟踪
# blktrace
# 需要跟blkparse配合使用，比如blktrace -d /dev/sda -o- | blkparse -i-

# 进程I/O系统调用跟踪
# strace、perf trace
# strace只可以跟踪单个进程，而perf trace还可以跟踪所有进程的系统调用

# 进程块设备I/O大小跟踪
# biosnoop、biotop
# 需要安装bcc

# 动态追踪
# ftrace bcc、systemtap
# ftrace用于跟踪内核函数调用栈，而bcc和systemtap则用于跟踪内核或应用程序的执行过程（注意bcc要求内核版本>=4.1）


网络性能指标
    |-应用层
    |    |-QPS（每秒请求数）
    |    |-套接字缓冲区大小
    |    |-DNS解析延迟
    |    |-响应时间
    |    |-错误数
    |-网络层
    |    |-丢包数
    |    |-TTL
    |    |-拆包
    |-链路层
    |    |-PPS（每秒网络帧数）
    |    |-BPS（每秒字节数）
    |    |-丢包数
    |    |-错误数
    |-传输层
    |    |-TCP连接数
    |    |    |-全连接
    |    |    |-半连接
    |    |    |-TIMEWAIT
    |    |-连接跟踪数
    |    |-重传数
    |    |-丢包数
    |    |-延迟
    
# 吞吐量（BPS）
# sar、nethogs、iftop /proc/net/dev
# 分别可以查看网络接口、进程以及IP地址的网络吞吐量；/proc/net/dev常用于监控

# 吞吐量（PPS）
# sar、/proc/net/dev
# 注意使用sar -n DEV选项

# 网络连接数
# netstat、ss
# ss速度更快

# 网络错误数
# netstat、sar
# 注意使用netstat -s或者sar -n EDEV/EIP选项

# 网络延迟
# ping、hping3
# ping基于ICMP，而hping3则基于TCP协议

# 连接跟踪数
# conntrack /proc/sys/net/netfilter/nf_conntrack_count /proc/sys/net/netfilter/nf_conntrack_max
# conntrack可用来查看所有连接跟踪的相信信息，nf_conntrack_count只是连接跟踪的数量，而nf_conntrack_max则限制了总的连接跟踪数量

# 路由
# mtr、traceroute、route
# route用于查询路由表，而mtr和traceroute则用来排查和定位网络链路中的路由问题

# DNS
# dig、nslookup
# 用于排查DNS解析的问题

# 防火墙和NAT
# iptables
# 用于排查防火墙及NAT的问题

# 网卡选项
# ethtool
# 用于查看和配置网络接口的功能选项

# 网络抓包
# tcpdump、Wireshark
# 通常在服务器中使用tcpdump抓包后再复制出来用Wireshark的图形界面分析

# 动态追踪
# ftrace bcc、systemtap
# ftrace用于跟踪内核函数调用栈，而bcc和systemtap则用于跟踪内核或应用程序的执行过程（注意bcc要求内核版本>=4.1）
```





# 基准测试工具

## Linux 各子系统实操基准测试工具分类

## 1.CPU 基准测试

**实操工具：sysbench、UnixBench、lmbench、perf bench**

- sysbench：多线程压测 CPU 运算、质数计算，最简常用；
- UnixBench：整机综合跑分，测试 CPU、进程调度综合性能；
- lmbench：测算进程切换、系统调用延迟；
- perf bench：内核自带，测试调度、指令性能。

## 2. 内存基准测试

**实操工具：sysbench、lmbench、perf bench**

- sysbench：批量读写内存，测内存吞吐、分配效率；
- lmbench：测试内存访问时延、缓存命中率。

## 3. 磁盘 / IO 基准测试（重点实操）

**实操工具：fio、dd、hdparm**

- fio：工业级 IO 压测，自定义随机 / 顺序读写、块大小，测 IOPS、时延、带宽（生产首选）；
- dd：简易测速，测磁盘连续读写速度；
- hdparm：测试磁盘裸读速度。

## 4. 网络基准测试（重点实操）

**实操工具：iperf、pktgen、hping3、ping/mtr/traceroute**

- iperf：TCP/UDP 带宽、吞吐、时延测试；
- pktgen：内核发包工具，高 PPS 压测网卡极限；
- hping3：构造自定义 TCP 报文，测网络连通、丢包；
- ping/mtr：链路时延、丢包率排查。

## 5. 应用层（Web 服务）基准测试

**实操工具：ab、wrk、jmeter**

- ab：Apache 自带，短连接压测 Nginx/HTTP 接口；
- wrk：高并发长连接压测，支持 lua 脚本，测 QPS；
- jmeter：复杂业务场景、多接口压力测试。

## 6. 编译 / 系统库测试

**实操工具：gcc/llvm、openssl**

- openssl：加解密运算，压测 CPU 加解密性能；
- gcc/llvm：编译跑分，测试整机编译吞吐。

```BASH
#=========================CPU基准测试=========================
#1.sysbench CPU质数运算压测：4线程、运行30秒
sysbench cpu --cpu-max-prime=20000 --threads=4 run

#2.UnixBench整机综合跑分
#./Run

#3.perf bench 内核调度性能测试
perf bench sched all

#=========================内存基准测试=======================
#sysbench内存压测：4线程，读写总大小10G，块1K
sysbench memory --memory-block-size=1K --memory-total-size=10G --threads=4 run

#=========================磁盘IO基准测试======================
#1.fio磁盘IO测试，测试目录/data
##随机读
fio -name=randread -directory=/data -ioengine=libaio -rw=randread -bs=4k -size=1G -numjobs=4
##随机写
fio -name=randwrite -directory=/data -ioengine=libaio -rw=randwrite -bs=4k -size=1G -numjobs=4
##顺序读写
fio -name=seqrw -directory=/data -rw=rw -bs=128k -size=2G -numjobs=2

#2.dd简易磁盘测速
##顺序写
dd if=/dev/zero of=/data/test bs=1G count=1 oflag=direct
##顺序读
dd if=/data/test of=/dev/null bs=1G count=1 iflag=direct

#3.hdparm测磁盘读速度
hdparm -t /dev/sda

#=========================网络基准测试=======================
#1.iperf TCP带宽测试
##服务端执行：iperf -s
##客户端执行：iperf -c 192.168.1.100
##UDP测速：iperf -u -c 192.168.1.100

#2.mtr链路延迟丢包探测
mtr 192.168.1.100

#3.hping3探测目标80端口
hping3 -S -p 80 192.168.1.100

#=========================Web应用压测(Nginx)=================
#1.ab短连接压测：100并发、总请求1000次
ab -c 100 -n 1000 http://127.0.0.1/

#2.wrk长连接压测：12线程200连接，持续30s
wrk -t12 -c200 -d30s http://127.0.0.1/

#3.jmeter 直接命令启动图形界面
#jmeter

#=========================Openssl加解密CPU跑分===============
openssl speed aes-256-cbc
```

---

# Linux 系统资源优化 vs 公司产品应用优化实战

> 很多新手把"调 Linux 系统参数"当成性能优化的全部，但到了真实业务里会发现：**系统参数只是地基，产品应用的优化才是决定用户体感的关键。** 两者是"**通用能力**"和"**专项攻坚**"的关系。

## 一、两者本质区别（一句话）

- **Linux 系统资源优化**：把**操作系统这台机器**调得更高效——CPU、内存、磁盘、网络这些"资源"不浪费、不拖后腿。解决的是"**机器本身好不好用**"。
- **公司产品应用优化实战**：把**跑在机器上的业务程序**调得更快——代码逻辑、数据库 SQL、接口耗时、缓存命中、架构设计。解决的是"**业务跑得快不快**"。

**打个比方：** 系统优化是"把公路修宽修平"，应用优化是"把车造快 + 选好路线"。路再宽，车本身慢，照样到不了目的地。

## 二、核心对比表（必背）

| 对比维度 | Linux 系统资源优化 | 公司产品应用优化实战 |
| :--- | :--- | :--- |
| **优化对象** | 操作系统资源（CPU/内存/磁盘/网络） | 业务代码、数据库、中间件、接口、架构 |
| **目标** | 资源利用率高、系统稳定不宕机 | 响应快、吞吐高、用户体验好 |
| **视角** | 通用、无业务含义，任何机器都适用 | 强业务相关，一个公司一套玩法 |
| **周期** | 上线前调好 + 日常巡检维护 | 贯穿开发、测试、上线、压测、线上排查全流程 |
| **手段** | 内核参数、调度策略、IO 调度器、资源限制 | 代码优化、SQL 优化、缓存、异步、架构拆分 |
| **工具** | `top`/`vmstat`/`iostat`/`sar`/`perf`/`strace` | APM 平台、`ab`/`wrk`/`jmeter` 压测、链路追踪、慢日志 |
| **衡量指标** | CPU 使用率、内存占用、IOPS、带宽、负载 | QPS、RT（响应时间）、TP99、错误率、可用性 |
| **谁来做** | 运维 / SRE / 平台工程师 | 研发（后端/中间件/架构师）+ 运维协作 |
| **典型场景** | 服务器 CPU 100%、内存 OOM、磁盘 IO 慢、网络抖动 | 接口慢、数据库慢查询、缓存穿透、高峰期系统卡顿 |

## 三、Linux 系统资源优化思路（工具链）

**套路四步走：找瓶颈 → 定位根因 → 优化 → 验证。**

```bash
# ① 看整体负载与 CPU（有瓶颈再往下追）
uptime                          # 负载均衡判断（对照核数）
top / htop                      # 谁占 CPU / 内存
vmstat 1                        # CPU 空转(r,b)、上下文切换(cs)
mpstat -P ALL 1                 # 是不是单核打满（进程绑定问题）

# ② 内存篇
free -h                         # 总内存 / 可用 / 缓存
cat /proc/meminfo               # 细看各内存区域
ps aux --sort=-%mem | head      # 谁是内存大户
dmesg | grep -i oom             # 有没有 OOM 杀进程

# ③ 磁盘篇
iostat -x 1                     # 看 util/await/svctm，判断是否磁盘瓶颈
iotop                           # 谁在疯狂读写磁盘
fio / dd                        # 测磁盘最大吞吐，判断是硬件还是业务问题

# ④ 网络篇
sar -n DEV 1                    # 网卡吞吐 / 丢包
ss -s                           # 连接数状态统计
nicstat / iftop                 # 网卡占用 / 单 IP 流量

# ⑤ 深入根因
perf top                        # CPU 热点函数（内核/应用哪里烧 CPU）
strace -p PID                   # 卡在哪个系统调用
pidstat -d -p PID 1             # 进程级 IO 统计
```

**系统层常用调优参数（红线要谨慎）：**

```bash
# 文件句柄不够：Too many open files
ulimit -n 65535                 # 会话级
vim /etc/security/limits.conf   # 持久化：nofile 65535

# TCP 连接数 / TIME_WAIT 堆积
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_tw_reuse = 1               # 复用 TIME_WAIT（仅客户端场景）

# 内存回收 / 缓存策略
vm.swappiness = 10                      # 尽量少用 swap，优先用内存

# 磁盘 IO 调度（SSD 一般用 none/noop 更好）
cat /sys/block/sda/queue/scheduler
```

> ⚠️ **注意**：系统参数调优是"通用手术"，改错了可能影响所有应用。**公司内部一般不允许乱动，要走变更审批。**

## 四、公司产品应用优化实战思路（业务视角）

**核心思想：一切优化以"用户体感"为准，以"数据"为依据，优化的是业务链路而不是单台机器。**

```text
优化流程（业务链路视角）：
  用户请求 → 网关 → 应用服务 → 数据库/Redis → 第三方依赖
       ↓        ↓         ↓          ↓            ↓
  压测/监控   限流      接口优化     SQL/索引      超时/降级
  发现瓶颈    削峰      缓存/异步    慢查询优化     熔断保护
```

**按层次优化，优先级从高到低：**

| 层次 | 优化手段 | 举例 |
| :--- | :--- | :--- |
| ① 架构层 | 拆分、微服务、读写分离、多活 | 大单体拆服务；订单表读写分离 |
| ② 缓存层 | 加 Redis、本地缓存、CDN | 热点数据缓存，DB 压力降 90% |
| ③ 应用层 | 代码逻辑、异步化、连接池 | 慢循环改位运算；发消息改 MQ 异步 |
| ④ 数据层 | SQL 优化、索引、分库分表 | 慢查询加索引；大表按月分表 |
| ⑤ 系统层 | 前面第三章那套参数 | 最后才动系统，先自查业务 |

**实战常用工具（区别于纯系统命令）：**

```bash
# 压测工具（验证优化效果的核心）
ab -c 100 -n 1000 http://127.0.0.1/api/user    # 简单接口压测
wrk -t12 -c200 -d30s http://127.0.0.1/          # 长连接高并发压测
jmeter                                          # 复杂业务场景压测（图形化）

# 数据库层（业务优化最大突破口）
show processlist;                       # 看当前在跑什么 SQL
explain select ...;                     # 看执行计划是否走索引
show global status like 'Slow_queries'; # 慢查询统计
# 开启慢查询日志：
#   slow_query_log=ON  long_query_time=1

# 应用层监控
# APM 平台（SkyWalking/Pinpoint/Arthas）：接口级耗时、调用链
java -jar arthas-boot.jar              # 阿里诊断神器，线上看方法耗时
```

**业务优化三步法（判断"该不该优化"）：**

```text
1. 有数据吗？    先埋点/监控/压测，用 TP99、QPS、错误率说话，别凭感觉
2. 瓶颈在哪？   链路追踪：网关→服务→DB→Redis，逐层看耗时占比
3. 先业务后系统？ 90% 的瓶颈在应用和数据库，系统参数往往不是第一嫌疑
```

## 五、两者的关系与配合（面试高频）

**结论：系统优化是"必要不充分"条件——地基必须稳，但真正决定业务体验的是应用优化。**

```text
一条完整链路上的优化配合：

  纯系统优化能做的：         纯应用优化能做的：
  ┌─────────────────┐        ┌──────────────────────────┐
  │ CPU/内存/磁盘/网络│        │ 代码/SQL/缓存/架构/异步   │
  │ 内核参数、调度    │        │ 压测、链路追踪、限流降级   │
  └────────┬────────┘        └────────────┬─────────────┘
           │                              │
           └─────────── 结合使用 ─────────┘
                      ↓
         QPS 上不去 → 先压测定位是"机器资源满了"
                     还是"应用代码本身就慢"
                     ↓
        机器满了 → 看系统层（扩机器/调参数）
        应用慢   → 看代码/SQL/缓存（这才是大头）
```

**面试怎么答：**
- 问"你会做性能优化吗？" → 先说**完整套路**（压测找瓶颈→逐层分析→先应用后系统），再举例
- 问"系统参数和应用优化有什么区别？" → 用对比表，强调**通用 vs 业务**、**机器 vs 链路**
- 加分项：提到**性能优化要回归到业务指标（QPS/RT/TP99）**，而不是只盯 CPU/内存

## 六、速记口诀

```text
系统优化修地基，应用优化提业务；
先压测找瓶颈，再逐层分析定位；
能上缓存先缓存，SQL 索引紧跟上；
应用调完调系统，最后才动内核参；
一切优化看数据，QPS 吞吐 RT 说话。
```

---

# 性能三指标：QPS / RT / TP99（面试必考）

> 压测/优化绕不开的三个核心指标，看一个系统好不好就看它们。**QPS 看吞吐、RT 看速度、TP99 看稳定。**

## 一、QPS —— 吞吐量（能干多少活）

**定义：每秒能处理的请求数（Queries Per Second）。** 衡量系统"干活能力"。

```text
QPS = 总请求数 ÷ 耗时（秒）
例：压测 10 秒发了 20000 个请求，全部成功
    QPS = 20000 ÷ 10 = 2000，即每秒处理 2000 个请求
```

**易混概念区分：**

| 名词 | 含义 | 区别 |
| :--- | :--- | :--- |
| QPS | 每秒查询/请求数 | 偏"读"的统计口径 |
| TPS | 每秒事务数（Transactions） | 带完整业务（可能含多次请求），如一次下单 = 1 个事务 |
| 吞吐量 | 单位时间处理总量 | 广义说法，QPS/TPS 都是它的具体体现 |

**压测怎么看 QPS：**
```bash
ab -n 1000 -c 100 http://127.0.0.1/   # 100 并发、共 1000 请求
# 结果里 `Requests per second` 那一行就是 QPS
wrk -t12 -c200 -d30s http://127.0.0.1/ # 12 线程 200 连接持续 30s
```

**QPS 上不去的常见瓶颈：** CPU 打满、数据库慢查询、连接池不够、单线程处理（如 PHP-FPM 默认单进程模型）、锁竞争。

## 二、RT —— 响应时间（快不快）

**定义：一个请求从发出去到拿到完整响应的时间（Response Time）。** 衡量"用户体感"。

```text
RT = 响应完成时刻 - 请求发起时刻
例：点击"查询订单"，0.05 秒后返回结果 → RT = 50ms
```

**RT 由哪些部分组成（定位慢在哪）：**

```text
一个请求的 RT 拆解：
  网络传输(客户端→服务器) + 排队等待 + 服务处理 + 数据库查询 + 网络返回
   ↑                        ↑          ↑           ↑            ↑
 带宽/延迟              线程池排队   业务代码    慢 SQL/缓存   带宽/延迟
```

**为什么不能只看平均 RT：** 平均会被极端值拉高（后面 TP99 会细讲）。正确姿势：
- 看 **平均 RT** 了解整体水平
- 看 **RT 分布**（哪些请求慢、慢多少）
- 压测时**并发逐步加大**，记录"不同并发下的 RT 拐点"——拐点处就是系统瓶颈

**QPS 与 RT 的"跷跷板"关系：**
```text
并发小 → 每个请求都快(RT低)，但总量少(QPS低)
并发大 → 总量上去了(QPS高)，但排队变长(RT高)
        ↓
真实压测要找"平衡点"：
  在 RT 可接受（如 TP99 < 500ms）前提下，QPS 能达到的最大值
```

## 三、TP99 —— 99% 分位耗时（稳不稳）

**定义：把一次压测的所有 RT 从快到慢排序，排在第 99% 位置的那个耗时。** 含义：99% 的请求比它快，只有 1% 的请求比它慢。

```text
1000 个请求的 RT 从快到慢排好：
  第 1 个  → 最快（如 2ms）
  第 990 个 → 这就是 TP99   ← 99% × 1000
  第 1000 个 → 最慢（如 3s）

结论：TP99 = 第 990 个请求的耗时
```

**为什么用 TP99 不用平均 RT？（面试必问）**

```text
例子：压测 100 个请求
  99 个耗时 10ms，1 个耗时 10s（GC 停顿/慢 SQL）
  平均 RT = (99×10 + 10000) ÷ 100 ≈ 109ms   ← 看着还行
  TP99    = 第 99 个的耗时 = 10ms            ← 更真实
  TP100   = 10000ms                          ← 暴露极端慢请求

结论：
  平均 RT 把少数极端慢请求"摊薄"了，掩盖真相
  TP99/TP999 才能暴露"尾部慢请求"（long tail）
```

**常看组合：** TP95 / TP99 / TP999 —— 越往后越严苛，专门抓那 0.1% 的极端情况（如 GC Full、慢 SQL、锁等待、网络抖动）。

**压测数据怎么读（真实示例）：**

```text
                TP50    TP95    TP99    TP999
接口 A          20ms    45ms    80ms    500ms   ← 整体不错，TP999 有波动
接口 B          30ms    200ms   800ms   3000ms  ← TP99 明显偏高，有大量慢请求
接口 C          15ms    18ms    22ms    25ms    ← 非常稳定，性能极佳

读法：先看 TP99 是否达标，再看 TP999 有没有"尖刺"（突发的极端慢）
```

## 四、三者关系图

```text
            压测报告示例（并发 100 时）
┌──────────────────────────────────────────────┐
│ QPS   = 2000    每秒处理 2000 个请求          │
│ 平均RT = 45ms    大部分请求还挺快             │
│ TP99  = 320ms    但 1% 的请求慢到 320ms       │
│              ↓ 结论                            │
│ 系统吞吐不错(QPS高)，但存在尾部慢请求         │
│ → 去查 TP99 那些慢请求是什么原因(慢SQL?GC?)  │
└──────────────────────────────────────────────┘
```

**三者配套看才有意义：**

```text
QPS 高 + RT 低 + TP99 低 = 系统健康 ✅
QPS 高 + RT 高          = 系统过载，在硬扛（大量排队）
QPS 低 + RT 高          = 有请求被卡住（慢SQL/锁/IO等待）
QPS 低 + RT 低 + TP99 高 = 存在少量极端慢请求（尾部问题）
```

## 五、速记口诀

```text
QPS 看吞吐（能干多少活），RT 看速度（响应快不快），TP99 看稳定（揪出尾部慢请求）。
压测必看三件套：QPS 打底、RT 兜底、TP99 找极端。
面试答法：QPS 不达标扩机器，RT 过长查代码，TP99 高查慢 SQL/GC/锁——指标落到优化动作。
```





















































































































