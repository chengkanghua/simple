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













































































