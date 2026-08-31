# UNIX 环境高级编程（APUE）教学精读

> ⚠️ **版本重要说明**：本教学文档精读自附件 `Unix环境高级编程第三版.pdf`。
> 经核查，**该书 PDF 正文实际是 APUE 第 2 版**（W. Richard Stevens 经典结构，共 **19 章**）：
> 终端 I/O 在第 11 章、无独立"线程"章节、含"调制解调器拨号器"等老版独有章，正文是老版"字母间带空格"排版。
> 文件名虽标"第三版"，但正文并非第三版（第三版为 21 章，线程在第 11–12 章）。
> 因此本教学**严格按 PDF 真实 19 章结构组织**，章节与 PDF 一一对应。
> 对照阅读推荐：你已有的《Linux/UNIX系统编程手册》(TLPI) 是 Linux 视角的现代版（含线程、epoll、inotify 等第三版内容），两书互补。

---

## 0. 书本介绍

**作者与地位**
- 作者 W. Richard Stevens，UNIX 系统编程领域的"圣经"级作者（另著有《TCP/IP 详解》《UNIX 网络编程》）。
- 本书是 UNIX 系统编程的权威教材，讲清楚一件事：**应用程序如何向内核请求服务**（文件、进程、信号、进程间通信）。

**这本书讲什么**
- 从"程序员视角"系统讲解 UNIX 各版本（重点是 SVR4 和 4.3+BSD 两大派系）提供的服务和界面。
- 核心主线：**系统调用（进入内核的入口） + 库函数（C 库包装）**，以及它们如何组合成真实程序。

**为什么值得学（对你：运维 / 后端 / Python）**
- 运维：进程控制、信号、守护进程、文件权限与属主，全是日常排障底层逻辑。
- 后端：I/O 多路复用、进程间通信、并发模型的根基。
- Python：你熟悉的 `os` / `signal` / `subprocess` / `fcntl` 模块，底层全是把本书讲的系统调用用 C 包了一层；懂 syscall 才懂"为什么这么设计"。

**全书知识地图（19 章 · 9 大模块串联）**
1. 入门基础：第1章 UNIX 基础、第2章 标准与实现
2. 文件 I/O：第3章 文件 I/O、第4章 文件与目录、第5章 标准 I/O 库
3. 系统数据：第6章 系统数据文件和信息
4. 进程模型：第7章 进程环境、第8章 进程控制、第9章 进程关系、第10章 信号
5. 终端：第11章 终端 I/O
6. 高级 I/O：第12章 高级 I/O（记录锁 / select·poll / 异步 I/O / mmap）
7. 守护进程：第13章 精灵进程
8. 进程间通信：第14章 IPC、第15章 高级 IPC
9. 老版特色应用：第16章 数据库函数库、第17章 PostScript 打印机、第18章 调制解调器拨号器、第19章 伪终端

**怎么读**
- 书中所有示例都包含统一的 `ourhdr.h` 头文件（封装 `err_sys` / `err_quit` 出错处理），重点在"理解机制"，不必逐行抄代码。
- 建议配合 TLPI 对照：本书是"跨 UNIX 版本的标准视角"，TLPI 是"Linux 具体实现视角"，遇到 Linux 特有机制（epoll、线程、inotify）以 TLPI 为准。

---

## 第1章 UNIX基础知识

**一句话本质**：从程序员视角快速浏览 UNIX 提供的服务，建立后续所有章节共用的"术语地基"（文件描述符、进程、信号、系统调用）。

**生活类比**：把 UNIX 系统想象成一家**大型餐厅厨房**——内核是后台厨师，程序是顾客点的菜，系统调用是顾客向厨房要服务的"取餐窗口"，文件描述符是取餐号，进程是正在做的一单生意，信号是服务员拍你肩膀说"有个情况"。

**核心知识点（串联讲解）**
- **登录**：系统查 `/etc/passwd`（7 字段：登录名:加密口令:uid:gid:注释:起始目录:shell），据此决定用哪个 shell。
- **文件系统**：层次结构，根 `/`；目录项 = 文件名 + 属性（类型/长度/属主/权限/修改时间）。自动有 `.`（当前）和 `..`（父）。文件名不能含 `/` 和 `\0`。
- **路径名**：以 `/` 开头 = 绝对路径；否则相对当前工作目录（可用 `chdir` 改）。
- **I/O 两大流派**：
  - 不带缓存 I/O：`open` `read` `write` `lseek` `close`，每次调用都进内核（第3章详讲）。
  - 标准 I/O：`<stdio.h>` 提供带缓存的封装（`printf` `fgets`），免你操心缓存长度（第5章详讲）。
- **程序 vs 进程**：程序是磁盘上的可执行文件；进程是它的**执行实例**，有唯一非负 **PID**。
- **进程控制三件套**：`fork`（复制自己）、`exec`（替换程序）、`waitpid`（等子进程结束）。`fork` 调用一次返回两次（父得子 PID，子得 0）。
- **ANSI C 包装**：函数原型让编译期查参；`void*` 作类属指针；`_t` 结尾的原始系统类型（`pid_t` `ssize_t` `size_t`）屏蔽各系统差异。
- **出错处理**：函数出错通常返 `-1`，整型 `errno` 被设成特定值（如 `EACCES` 权限问题）；`strerror(errno)` 取消息，`perror(msg)` 打印。两条铁律：① 只有返回值指明出错才查 `errno`；② 任何函数都不会把 `errno` 清 0。
- **用户标识**：`uid`（用户 ID，0 = root 超级用户）、`gid`（组 ID）、添加组 ID（一个用户可属多组，从 `/etc/group` 取）。
- **信号**：内核通知进程"某条件发生"的机制。三种处理：忽略 / 默认动作 / 自定义函数（捕获）。键盘 `Ctrl-C` → `SIGINT` 终止进程。
- **时间值**：日历时间（`time_t`，1970-1-1 起秒数）；进程时间（`clock_t`，CPU 滴答，含用户 CPU + 系统 CPU）。
- **系统调用 vs 库函数**：系统调用是进内核的入口（不可替换）；库函数是 C 库包装（可替换）。例：`malloc` 是库函数，底层用 `sbrk` 系统调用要内存；`printf` 库函数最终调 `write` 系统调用。

**关键 API 速查**
- `getpid()` → 取进程 ID
- `getuid()` / `getgid()` → 取用户/组 ID
- `strerror(errno)` / `perror(msg)` → 出错信息
- `fork()` / `exec` 族 / `waitpid()` → 进程控制
- `signal(SIGINT, handler)` → 注册信号处理
- `time` 命令（`time grep ...`）→ 测时钟/用户/系统 CPU 时间

**易错点 & 实战**
- 别在"没出错"时查 `errno`——它可能保留旧值。
- `fork` 后父子共享打开文件表项：父子同时写同一文件会"交织"，要用原子操作或锁（见第3章）。
- 实战：写一个"迷你 shell"——循环 `fgets` 读命令，`fork` + `execlp` 执行，`waitpid` 等结束（书程序 1-5）。

**面试考点**
- 文件描述符 0/1/2 分别是什么？为什么 `open` 总返回"最小未用"描述符？（shell 重定向靠它）
- `fork` 为什么"调用一次返回两次"？父/子各拿到什么？
- 系统调用和库函数的本质区别？为什么说"可以替换库函数但不能替换系统调用"？

**代码实战**

下面这个迷你 `ls` 把第1章的关键点一次性跑出来：目录遍历、用 `stat` 取属性、数字 uid/gid 换成名字、把时间值格式化、出错时用 `errno`/`perror` 翻译成中文、用 `S_IS*` 宏判断文件类型。

```c
/* ch1_unix基础.c —— 迷你 ls, 落地第1章知识点
 * 体现: 目录读取(opendir/readdir)、stat 取属性、用户/组(getpwuid/getgrgid)、
 *       时间(localtime/strftime)、出错处理(errno+perror)、文件类型(S_IS* 宏)
 * 编译: cc ch1_unix基础.c -o ch1 && ./ch1 .
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <pwd.h>
#include <grp.h>
#include <time.h>
#include <errno.h>
#include <sys/stat.h>

void print_mode(mode_t m) {                 // 把 st_mode 翻译成 ls 的 rwx 串
    putchar(S_ISDIR(m)  ? 'd' : S_ISLNK(m) ? 'l' :
            S_ISCHR(m)  ? 'c' : S_ISBLK(m) ? 'b' :
            S_ISFIFO(m) ? 'p' : S_ISSOCK(m)? 's' : '-');
    for (int i = 8; i >= 0; i--)            // 9 位权限(属主/组/其他)
        putchar(m & (1 << i) ? "xwrxwrxwr"[i] : '-');
}

int main(int argc, char *argv[]) {
    const char *dir = argc > 1 ? argv[1] : ".";
    DIR *dp = opendir(dir);
    if (!dp) { perror("opendir"); exit(1); }        // 出错处理: errno -> 人话

    struct dirent *ent;
    while ((ent = readdir(dp)) != NULL) {           // 遍历目录
        if (!strcmp(ent->d_name, ".") || !strcmp(ent->d_name, "..")) continue;
        char path[1024];
        snprintf(path, sizeof path, "%s/%s", dir, ent->d_name);

        struct stat st;
        if (lstat(path, &st) == -1) { perror("lstat"); continue; }  // lstat 不跟随软链

        print_mode(st.st_mode);
        printf(" %lu %-8s %-8s %8lld  ",
               st.st_nlink,
               getpwuid(st.st_uid)->pw_name,        // 数字 uid -> 名字(第6章)
               getgrgid(st.st_gid)->gr_name,
               (long long)st.st_size);

        char buf[32];
        strftime(buf, sizeof buf, "%m-%d %H:%M", localtime(&st.st_mtime)); // 时间值
        printf("%s %s\n", buf, ent->d_name);
    }
    closedir(dp);
    return 0;   // 等价于 exit(0): 刷新标准 I/O 缓存后终止
}
```

**本章串联**：地基章。第3章展开"不带缓存 I/O"，第4/5 章展开文件与目录/标准 I/O，第7/8 章展开进程环境与 `fork`/`exec`，第10章展开信号——本章每个术语都会在后面"回锅"深入。

---

## 第2章 UNIX标准化及实现

**一句话本质**：解释"为什么不同 UNIX 版本代码能互相跑"——靠标准（ANSI C / POSIX / XPG3）约束界面，再由厂商实现成具体系统（SVR4 / 4.3+BSD）。并讲清如何**可移植地获取系统限制值**。

**生活类比**：标准像**交通规则**（大家都守同一套手势），各车厂（AT&T、伯克利）造出不同的车（SVR4、BSD）。限制值像不同道路的限速——有的是固定路牌（编译时常量），有的要现场看电子牌（运行时函数查）。

**核心知识点（串联讲解）**
- **三大标准**：
  - ANSI C（X3.159-1989 / ISO 9899）：管 C 语言本身可移植（语法 + 标准库 `<stdio.h>` 等）。
  - IEEE POSIX.1（1003.1-1988 / ISO 9945-1）：管"操作系统界面"（不区分系统调用和库函数，统称函数），本书主角。
  - X/Open XPG3：POSIX 的**超集**，多了消息设施等。
- **FIPS 151-1**：美国政府采购标准，比 POSIX 更严（强制要求作业控制、保存设置 ID 等）。
- **两大实现（本书贯穿对比）**：
  - **SVR4**：AT&T 商用 UNIX（汇合 SVR3.2 + SunOS + 4.3BSD + Xenix），符合 POSIX + XPG3。
  - **4.3+BSD**：加州伯克利版（BSD 网络软件 2.0 ～ 4.4BSD），POSIX 兼容。
- **限制值的三种来源**（可移植关键）：
  - 编译时常量（头文件 `<limits.h>` 写死，如 `INT_MAX`）。
  - 运行时不确定值：必须调函数查——`sysconf(name)`（系统级）、`pathconf(path, name)` / `fpathconf(fd, name)`（与文件/目录相关）。
  - 例：`OPEN_MAX`（每进程最多打开文件数）、`PATH_MAX`（路径长）、`NAME_MAX`（文件名长）。
- **功能测试宏**：`_POSIX_SOURCE`（只用 POSIX 定义）、`_XOPEN_SOURCE`（含 XPG）、`__STDC__`（编译器自动定义，区分 ANSI C）。编译时 `cc -D_POSIX_SOURCE` 开启。
- **基本系统数据类型**：`<sys/types.h>` 里 `_t` 结尾类型（`pid_t` `uid_t` `off_t` `ssize_t` …），屏蔽"int 还是 long"的实现差异。
- **标准冲突示例**：ANSI C 的 `clock()` 与 POSIX 的 `times()` 都用 `clock_t`，但"每秒滴答数"含义不同（一个微秒、一个 50/60/100）——用 `sysconf(_SC_CLK_TCK)` 取真实值。

**关键 API 速查**
- `sysconf(_SC_OPEN_MAX)` → 运行时取系统限制
- `pathconf("/path", _PC_NAME_MAX)` → 取某目录下的文件名长度上限
- `fpathconf(fd, _PC_PIPE_BUF)` → 取管道原子写字节数
- 常用 name：`_SC_CLK_TCK` `_SC_ARG_MAX` `_PC_PATH_MAX` `_PC_PIPE_BUF`

**易错点 & 实战**
- `PATH_MAX` 等若"不确定"，编译时不能当数组长度用——要运行时查或 `malloc` 动态分配（书程序 2-2）。
- 关闭所有打开文件描述符时别写死 `for(i=0;i<NOFILE;i++)`，改用 `sysconf(_SC_OPEN_MAX)` 或 `getdtablesize()`。
- 可移植代码：永远用 `STDIN_FILENO` 等符号常量，别写死 `0/1/2`。

**面试考点**
- POSIX.1 和 ANSI C 分别解决什么可移植性？
- 为什么"未确定的运行时限制"不能用头文件常量？`sysconf`/`pathconf` 解决什么？
- `off_t` `pid_t` 这类 `_t` 类型存在的意义？

**代码实战**

第2章的核心主张是"别硬编码幻数，用 `sysconf`/`pathconf` 现查"。下面程序打印一批运行时限制值，并演示 Feature Test Macro（编译时加 `-D_POSIX_C_SOURCE=200809L` 才会暴露某些 POSIX 接口）。

```c
/* ch2_标准化及实现.c —— 用 sysconf/pathconf 取代"幻数"
 * 体现: POSIX/SUS 限制值(运行时 sysconf)、路径相关限制(pathconf)、
 *       不要写死 4096/BUFSIZ, 而用 _SC_* / _PC_* 查询
 * 编译: cc ch2_标准化及实现.c -o ch2 && ./ch2
 *       (想看更完整的 POSIX 接口可加: cc -D_POSIX_C_SOURCE=200809L ch2_*.c -o ch2)
 */
#include <stdio.h>
#include <unistd.h>

static void show(const char *name, long v) {
    printf("%-26s = %ld%s\n", name, v, v < 0 ? "  (不确定/不支持)" : "");
}

int main(void) {
    show("_SC_ARG_MAX   (exec 参数字节上限)", sysconf(_SC_ARG_MAX));
    show("_SC_CHILD_MAX (单用户最大子进程)",  sysconf(_SC_CHILD_MAX));
    show("_SC_OPEN_MAX  (每进程最多打开 fd)", sysconf(_SC_OPEN_MAX));
    show("_SC_NPROCESSORS_ONLN (在线 CPU)",   sysconf(_SC_NPROCESSORS_ONLN));
    show("_SC_CLK_TCK   (每秒时钟滴答)",       sysconf(_SC_CLK_TCK));

    // 路径相关限制: 必须传一个已存在的路径(或配 fd 用 fpathconf)
    printf("_PC_NAME_MAX  = %ld\n", pathconf(".", _PC_NAME_MAX));  // 文件名最大长度
    printf("_PC_PATH_MAX  = %ld\n", pathconf(".", _PC_PATH_MAX));  // 路径名最大长度
    printf("_PC_MAX_CANON = %ld\n", pathconf(".", _PC_MAX_CANON)); // 终端规范行上限(第11章)
    return 0;
}
```

**本章串联**：限制值贯穿全书（文件长度、打开数、管道原子写等）。第3章 `open` 的 `NAME_MAX` 截短行为、第4章文件属性、第12章记录锁都回头引用本章。SVR4 vs BSD 的差异标注也是全书"实现对比"的主线。

---

## 第3章 文件 I/O

**一句话本质**：UNIX 文件 I/O 只需 5 个函数（`open`/`read`/`write`/`lseek`/`close`），它们**每次都进内核（不带缓存）**；本章讲清文件描述符、内核三张表、共享文件、以及"原子操作"为何重要。

**生活类比**：文件描述符是**取餐号**；内核的"文件表项"是**这桌的账单**（记录当前读写位置、打开状态）；v 节点是**菜品配方**（文件类型 + 操作函数）；`lseek` 是移动读写**光标**；原子操作像"先占座再写"一步完成，避免两人抢同一行。

**核心知识点（串联讲解）**
- **文件描述符**：非负小整数，内核借此标识打开的文件。惯例 0/1/2 = 标准输入/输出/出错（应写 `STDIN_FILENO` 等）。`open` 总返回**最小未用**描述符。
- **open 的 oflag**（按位或）：
  - 三选一：`O_RDONLY` / `O_WRONLY` / `O_RDWR`
  - 常用附加：`O_CREAT`（不存在则建）、`O_EXCL`（配合 `O_CREAT` 测存在+创建原子）、`O_APPEND`（每次写前定位到尾端）、`O_TRUNC`（截为 0）、`O_NONBLOCK`（非阻塞，第12章）、`O_SYNC`（写等落盘）
- **creat** = `open(path, O_WRONLY|O_CREAT|O_TRUNC, mode)`，现已多余（老 UNIX 的 `open` 不能建文件）。
- **lseek**：设置"当前文件位移量"。`SEEK_SET/CUR/END`。位移量可**超过文件长度**形成"空洞"（读为 0，不占盘）。管道/FIFO 上 `lseek` 返回 `-1`（设 `errno=EPIPE`）。
- **read/write 返回可能少于请求**：
  - 普通文件读到末尾（再读返 0）；终端默认一次一行；网络受缓冲影响；磁带一次一记录。
  - 写满盘 / 超进程文件长度限制会出错。
- **I/O 效率**：`BUFFSIZE` 太小→系统 CPU 时间飙升；大到文件系统块长（如 8192）后系统时间不再降（书表 3-1）。**教训：缓存长度要够大，但不必无限大**。
- **内核三张表（文件共享核心）**：
  1. 进程表 → 打开文件描述符表（每项含：fd 标志、指向文件表项的指针）
  2. 文件表（每打开文件一项：状态标志、当前位移量、指向 v 节点指针）
  3. v 节点表（文件类型 + 操作函数 + i 节点信息：属主/长度/数据块指针）
  - 两个进程各开同一文件 → 各有文件表项，但**共享一个 v 节点**。每个进程有自己的"当前位移量"，所以各读各的不乱；但**多进程写同一文件会交错**。
- **原子操作**（多进程共享时的救命绳）：
  - `O_APPEND`：把"定位到尾 + 写"合成一个原子步，避免 A、B 两进程 `lseek` 后各写各的互相覆盖。
  - `O_CREAT|O_EXCL`：把"检查存在 + 创建"合成原子步，避免两进程都以为自己创建了文件。
  - 本质：需多步完成、步骤间可能被内核切换的操作，**不是原子**；用内核提供的标志让它一步完成。
- **dup/dup2**：复制描述符，**共享同一文件表项**（同位移量、同状态标志）。`dup2(fd, fd2)` 可在指定 fd 上打开（shell 重定向用）。
- **fcntl**：改已打开文件的性质——复制描述符（`F_DUPFD`）、取/设 fd 标志（`F_GETFD`/`F_SETFD`，如 `FD_CLOEXEC`）、取/设状态标志（`F_GETFL`/`F_SETFL`，可改 `O_APPEND`/`O_NONBLOCK`/`O_SYNC`/`O_ASYNC`）、记录锁（第12章）。取标志要"先读再改再写"，别直接 `F_SETFL` 覆盖。
- **ioctl**：I/O 杂物箱，终端 I/O 用它最多（第11章 POSIX 用新函数替代部分）。
- **/dev/fd/n**：打开它等效 `dup(n)`，主要给 shell 用，让标准输入/输出也能当普通路径名传参。

**关键 API 速查**
- `int open(path, oflag, ...mode)` → fd 或 -1
- `ssize_t read(fd, buf, n)` / `ssize_t write(fd, buf, n)`
- `off_t lseek(fd, offset, whence)`
- `int close(fd)`
- `int dup(fd)` / `int dup2(fd, fd2)`
- `int fcntl(fd, cmd, ...)`：F_DUPFD / F_GETFL / F_SETFL / F_GETFD / F_SETFD
- `int ioctl(fd, request, ...)`

**易错点 & 实战**
- 比较 `lseek` 返回值要用 `== -1`，别用 `< 0`（位移量可能为负，普通文件则非负）。
- 多个进程 append 日志**必须用 `O_APPEND`**，否则用 `lseek`+`write` 两步走会丢数据。
- `F_SETFL` 前先 `F_GETFL` 或标志位，否则会清掉之前设的 `O_APPEND`。
- 实战：用 `open`/`read`/`write` 实现 `cp`（书程序 3-3），测不同 `BUFFSIZE` 的耗时；用 `O_APPEND` 写多进程安全日志。

**面试考点**
- 不带缓存 I/O 是什么意思？和标准 I/O 区别？
- 内核三张表关系？`fork` 后父子进程的文件描述符如何共享？
- 为什么多进程写文件需要原子操作？`O_APPEND` 解决了什么？
- `dup2(fd,1)` 和 `close(1); fcntl(fd,F_DUPFD,1)` 等价吗？（不完全：dup2 原子、errno 不同）

**代码实战**

第3章的"不带缓存 I/O"就是 `open`/`read`/`write`/`lseek`/`close`。下面用它们实现一个 `cp`，并顺带演示三个易错点：`O_CREAT|O_EXCL` 原子新建、`O_APPEND` 原子追加、`lseek` 制造文件空洞。

```c
/* ch3_文件IO.c —— open/read/write/lseek 实现 cp, 附带 O_APPEND 与空洞演示
 * 体现: 不带缓存 I/O、creat 等价(O_CREAT|O_WRONLY|O_TRUNC)、O_EXCL 原子新建、
 *       O_APPEND 原子追加、lseek 制造空洞、write 可能写不足需循环
 * 编译: cc ch3_文件IO.c -o ch3 && ./ch3 源文件 目标文件
 */
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

#define BUF 4096

int main(int argc, char *argv[]) {
    if (argc != 3) { fprintf(stderr, "用法: %s 源 目标\n", argv[0]); return 1; }

    int fdin = open(argv[1], O_RDONLY);
    if (fdin < 0) { perror("open 源"); return 1; }

    // O_CREAT|O_EXCL: 目标已存在则失败 —— 原子地"仅当不存在才新建"
    int fdout = open(argv[2], O_WRONLY | O_CREAT | O_EXCL, 0644);
    if (fdout < 0) { perror("open 目标"); return 1; }

    char buf[BUF];
    ssize_t n;
    while ((n = read(fdin, buf, BUF)) > 0) {
        ssize_t off = 0;
        while (off < n) {                 // write 可能写不足, 必须循环补写
            ssize_t w = write(fdout, buf + off, n - off);
            if (w < 0) { perror("write"); return 1; }
            off += w;
        }
    }
    close(fdin); close(fdout);

    // ---- O_APPEND: 内核保证"先定位到尾再写"的原子性, 多进程追加不交错 ----
    int fa = open(argv[2], O_WRONLY | O_APPEND);
    write(fa, "<<APPEND>>", 10);
    close(fa);

    // ---- lseek 跳过一段制造"空洞": 中间不占磁盘块, du 很小而 ls -l 显示大 ----
    int fh = open("hole.dat", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    write(fh, "head", 4);
    lseek(fh, 1024, SEEK_CUR);           // 往后跳 1KB
    write(fh, "tail", 4);                 // 1028 字节, 但中间是空洞
    close(fh);
    return 0;
}
```

**本章串联**：文件表/v 节点是全书 I/O 的"地基"——第4章文件属性（`stat`）、第5章标准 I/O、第12章记录锁（锁在文件表项上）、第14章管道都回头引用。原子操作概念在第4章 `link`、第12章记录锁再次出现。

## 第4章 文件和目录

**一句话本质**：用 `stat` 看清文件的全部属性（类型/权限/属主/时间/链接数），并掌握"增、删、改、查"文件的系统调用。这是 UNIX 文件观的骨架。

**生活类比**：文件像**档案袋**，`i` 节点是袋里的**信息卡**（类型、权限、长度、数据块指针），目录项是**索引便签**（文件名 → i 节点号）。硬链接 = 多个便签指向同一张卡；符号链接 = 便签上写"去 XX 找"。

**核心知识点（串联讲解）**
- **看属性**：`stat(path, &buf)` / `fstat(fd, &buf)` / `lstat(path, &buf)`。三者填 `stat` 结构；`lstat` 看符号链接**本身**而非它指向的文件（遍历目录要用它）。
- **7 种文件类型**（存在 `st_mode`）：普通文件、目录、字符特殊、块特殊、FIFO、套接字、符号链接。用 `S_ISREG()`/`S_ISDIR()`/`S_ISCHR()`… 宏判断（别直接 `& S_IFMT`）。
- **SUID / SGID 位**：文件 `st_mode` 里若设了"设置-用户-ID"位，执行它时进程的有效 uid 变成文件属主（如 `passwd` 用它改 `/etc/shadow`）。写 SUID 程序要极谨慎。
- **9 个权限位** = 用户/组/其他 × 读/写/执行。关键易混点：
  - 目录的**执行位 = 搜索位**（能 `cd` 进、能解析路径里的它）；**读位 = 能列文件名**。
  - 删除文件只需对**所在目录**有写+执行权限，对文件本身无要求。
  - 权限测试四步：有效 uid=0（root）放行 → 属主匹配看用户位 → 组匹配看组位 → 其他位。
- **新文件归属**：用户 ID = 进程有效 uid；组 ID = 进程有效 gid **或** 父目录的组 ID（看目录的 SGID 位，FIPS 要求继承目录组）。
- **改属性**：
  - `umask(cm)`:进程创建屏蔽字，建文件时 mode 中被屏蔽的位变 0（只关不开关）。
  - `chmod`/`fchmod`:改权限；`chown`/`fchown`/`lchown`:改属主（受 `_POSIX_CHOWN_RESTRICTED` 限制，非 root 通常只能改自己文件的组到自己所属的组）。
  - `access(path, mode)`:按**实际** uid/gid 测权限（SUID 程序用来判断"真用户"能否访问）。
  - 粘住位 `S_ISVTX`：在目录上 = 只有文件属主/目录属主/root 能删改其中的文件（`/tmp` 用它防互删）。
- **文件系统结构**：磁盘→分区→文件系统；`i` 节点是定长记录（存类型/权限/长度/数据块指针）；目录项 = 文件名 + i 节点号。**硬链接**连接计数 `st_nlink`，减到 0 才释放数据；**符号链接**内容是指向路径（可跨文件系统）。`link`(建硬链)/`unlink`(删目录项，计数0且无人打开才真删)/`rename`/`remove`。
  - 经典技巧：`open` 后立刻 `unlink` 临时文件 → 进程崩了也不会留垃圾（关闭才删除内容）。
- **三个时间**：`st_atime`(读)/`st_mtime`(改内容)/`st_ctime`(改 i 节点如 chmod)。`utime` 改前两个。
- **目录与设备**：`mkdir`/`rmdir`；`opendir`/`readdir`/`closedir`（`dirent` 含 `d_ino`+`d_name`）；`chdir`/`fchdir`/`getcwd`（内核只存 i 节点号，getcwd 靠逐级上溯拼出绝对路径）；特殊设备文件 `st_dev`(所在文件系统设备号)/`st_rdev`(实际设备号)，用 `major()`/`minor()` 取。
- **落盘**：`sync`(刷所有脏缓存，不等待)/`fsync(fd)`(等单个文件落盘，数据库用)。内核"延迟写"提升性能但故障可能丢数据。

**关键 API 速查**
- `stat`/`lstat`/`fstat` → 取属性
- `chmod`/`chown`/`lchown`/`umask`/`access`/`utime`
- `link`/`unlink`/`rename`/`remove`/`symlink`/`readlink`
- `mkdir`/`rmdir`/`opendir`/`readdir`/`closedir`/`chdir`/`getcwd`
- `sync`/`fsync`

**易错点 & 实战**
- `st_mtime`(内容改) 和 `st_ctime`(i节点改) 不是一回事：`chmod` 改的是 ctime 不是 mtime。
- 删一个别人正在写的文件：`unlink` 只是删目录项，进程仍持有 fd 能继续写，关闭后才释放空间（可用 `df` 看空间变化，`du` 看不到）。
- 实战：写 `cp` 支持"空洞文件"不写 0（读到的 0 区不写）；写递归遍历目录统计各类型文件数（用 `lstat` 防符号链接死循环）。

**面试考点**
- 删除一个文件需要什么权限？（目录的写+执行，不是文件本身）
- 硬链接 vs 符号链接区别？为什么 `ln` 不允许硬链接指向目录（防循环）？
- `open` 后 `unlink` 临时文件有什么好处？
- SUID 位的作用与风险？`passwd` 为什么需要它？

**代码实战**

第4章围绕 `stat` 和文件类型展开。下面程序打印文件的类型/权限/inode/大小，并演示 `lstat`（不跟随软链）、`link`/`rename`/`unlink` 这些"靠 inode 工作"的调用。

```c
/* ch4_文件和目录.c —— stat / 文件类型 / 符号链接 / 删除
 * 体现: stat/fstat/lstat、S_IS* 文件类型宏、access、umask、chmod、
 *       link/unlink/rename、mkdir/opendir/readdir、chdir/getcwd
 * 编译: cc ch4_文件和目录.c -o ch4 && ./ch4 某个文件
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>

int main(int argc, char *argv[]) {
    if (argc != 2) { fprintf(stderr, "用法: %s 文件\n", argv[0]); return 1; }
    const char *path = argv[1];

    struct stat st;
    // lstat 不跟随软链: 若 path 是软链, st 描述的是"链接本身"而非目标
    if (lstat(path, &st) == -1) { perror("lstat"); return 1; }

    printf("类型: ");
    if      (S_ISREG(st.st_mode))  printf("普通文件\n");
    else if (S_ISDIR(st.st_mode))  printf("目录\n");
    else if (S_ISLNK(st.st_mode))  printf("符号链接\n");
    else if (S_ISCHR(st.st_mode))  printf("字符设备\n");
    else if (S_ISBLK(st.st_mode))  printf("块设备\n");
    else if (S_ISFIFO(st.st_mode)) printf("FIFO\n");
    else if (S_ISSOCK(st.st_mode)) printf("socket\n");

    printf("inode=%ld  硬链接数=%lu  大小=%lld 字节\n",
           (long)st.st_ino, (unsigned long)st.st_nlink, (long long)st.st_size);
    printf("权限=%04o  属主uid=%d\n", st.st_mode & 0777, st.st_uid);

    if (access(path, R_OK) == 0) printf("当前用户可读\n");   // 按实际 uid 测权限

    mkdir("demo_dir", 0755);                                    // 建目录(受 umask 影响)
    if (link(path, "hardlink_to_path") == 0) printf("已建硬链接\n");
    if (rename("hardlink_to_path", "renamed_link") == 0) printf("已改名\n");
    unlink("renamed_link");                                     // 删硬链: 计数-1, 归零才真删

    char cwd[1024];
    printf("当前目录: %s\n", getcwd(cwd, sizeof cwd));
    return 0;
}
```

**本章串联**：`stat`/`i`节点/硬链接是全书基石——第5章标准 I/O 的 `FILE` 底层是本章 fd；第12章记录锁锁在文件表项上；第14章 FIFO、第15章 socket 都在文件类型里。权限/SUID 在第8章 exec 时再深入。

---

## 第5章 标准 I/O 库

**一句话本质**：在第3章"不带缓存 I/O"之上包一层**带缓存的流（`FILE *`）**，免你操心缓存长度，但"缓存机制"本身也是 bug 温床（务必理解刷新时机）。

**生活类比**：不带缓存 I/O 像每次买东西都自己跑仓库（`read`/`write` 系统调用）；标准 I/O 是**采购代理**——一次囤一批（全缓存）或结账时送（行缓存），省你跑腿，但代理"何时送货"的规矩要懂。

**核心知识点（串联讲解）**
- **流与 FILE 对象**：`fopen` 返回 `FILE *`（内含 fd、缓存指针、长度、出错标志）。应用不必看 FILE 内部。
- **三种缓存**（标准 I/O 最易混的点）：
  - 全缓存：填满缓存才做实际 I/O（磁盘文件默认）。
  - 行缓存：遇 `\n` 才 I/O（终端默认，stdin/stdout）。
  - 不带缓存：直接 `write`（stderr 默认，出错信息立刻显示）。
  - `setbuf`/`setvbuf` 改类型；`fflush(fp)` 刷（fp=NULL 刷所有输出流）。注意"刷新"在 stdio 里是"写盘"，在终端驱动里是"丢弃"——两义。
- **打开流**：`fopen`(路径)/`freopen`(指定流上重开)/`fdopen`(把已有 fd 包成流，管道/socket 必须用)。type：`r`/`w`/`a`/`r+`/`w+`/`a+`；`w`/`a` 创建文件时权限固定（无 umask 般可控）。`+` 读写模式中间必须 `fflush`/`fseek` 才能切换读写方向。
- **读**：`getc`/`fgetc`/`getchar`（一次一字符，`getc` 是宏、`fgetc` 是函数，返回值必须存 `int` 不能存 `char` 否则 EOF 歧义）；`fgets`(一次一行，安全，限长 n)；`fread`(二进制)。区分 EOF 与出错用 `feof`/`ferror`；`ungetc` 回送一个字符（分词时先看后送）。
- **写**：`putc`/`fputc`/`putchar`、`fputs`、`fwrite`。
- **`gets` 危险**：不限制长度 → 缓冲区溢出 → 1988 年互联网蠕虫。**只用 `fgets`**。
- **效率真相**（书表 5-4）：标准 I/O 并不比 `read`/`write` 慢多少——系统 CPU 时间相同（底层 `read`/`write` 次数一样）；`fgetc` 版比 `BUFFSIZE=1` 的 `read` 版快约百倍，因为系统调用从 300 万次降到 360 次。**经验：复杂应用的主要 CPU 在业务逻辑，不在 I/O 库**。
- **二进制 I/O**：`fread`/`fwrite` 一次读写结构；但**跨系统不可移植**（结构体对齐、多字节整数/浮点字节序不同）——异构系统要用高层协议（如网络字节序）。
- **定位流**：`ftell`/`fseek`（假设位置能放 `long`）；`fgetpos`/`fsetpos`（用 `fpos_t`，可移植到非 UNIX）。文本文件定位受限（一般只支持 `SEEK_SET`+0 或回到 `ftell` 值）。
- **格式化**：`printf`/`fprintf`/`sprintf`（注意 `sprintf` 可能溢出，调用者负责长度）；`scanf` 族；`vprintf` 族（可变参数，书附录出错函数用它）。
- **`fileno(fp)`**：取流对应 fd（要调 `dup`/`fcntl` 时用）。
- **临时文件**：`tmpnam`(唯一路径名)/`tmpfile`(建后立刻 `unlink`，关闭即删)/`tempnam`(指定目录与前缀)。
- **替代软件**：`sfio`、基于 `mmap` 的 ASI——减少数据复制量提升性能。

**关键 API 速查**
- `fopen`/`fdopen`/`fclose`/`freopen`
- `getc`/`fgetc`/`getchar`/`fgets`/`fread`；`putc`/`fputc`/`fputs`/`fwrite`
- `feof`/`ferror`/`clearerr`/`ungetc`
- `setbuf`/`setvbuf`/`fflush`/`fseek`/`ftell`/`rewind`/`fgetpos`/`fsetpos`
- `printf`/`scanf` 族、`fileno`

**易错点 & 实战**
- `getc`/`fgetc` 返回值存 `int`，存 `char` 会和 `EOF`(-1) 混淆。
- 行缓存的坑：`printf("prompt")` 没 `\n` 也不 `fflush` → 在终端上看不到（行缓存未满不刷）；重定向到文件变全缓存更看不到。交互提示要手动 `fflush(stdout)`。
- 实战：写 `grep` 用 `fgets`+`memccpy` 比逐字符 `getc` 快约 2 倍（书 5.14）。

**面试考点**
- 全缓存/行缓存/不带缓存的区别与默认场景？
- 为什么 `gets` 不能用？`fgets` 比它安全在哪？
- 标准 I/O 为什么通常比裸 `read(1字节)` 快得多？（缓存减少系统调用）
- `fflush` 在 stdio 和终端驱动里语义为何不同？

**代码实战**

第5章的标准 I/O 库在底层还是第3章的 `open`/`read`/`write`，只是加了缓存。下面演示：缓存类型差异、`fopen` 逐行读、`fdopen`/`fileno` 与 fd 互通、以及 `setvbuf` 自管缓存。

```c
/* ch5_标准IO.c —— 标准 I/O 库: 缓存/逐行读/fdopen/fileno/setvbuf
 * 体现: fopen/fclose、getc/putc/fgets/fputs、fread/fwrite、printf 族、
 *       fdopen/fileno 与第3章 fd 互通、setvbuf 控制缓存、tmpfile
 * 编译: cc ch5_标准IO.c -o ch5 && ./ch5
 */
#include <stdio.h>

int main(void) {
    // 1) stderr 无缓存(立即出现); 连终端的 stdout 是行缓存(\n 才刷)
    fprintf(stderr, "标准出错: 立即出现(无缓存)\n");
    printf("标准输出: 行缓存, 遇换行或程序结束才刷\n");

    // 2) fopen + fgets 逐行读普通文件
    FILE *fp = fopen("/etc/hosts", "r");
    if (fp) {
        char line[256];
        while (fgets(line, sizeof line, fp))   // 读到 EOF/出错返回 NULL
            fputs(line, stdout);
        fclose(fp);                             // 关闭会刷缓存并释放
    }

    // 3) 与第3章 fd 互通: popen 内部就是 fork+exec+管道+fdopen(第14章)
    FILE *pf = popen("ls -l", "r");
    if (pf) {
        printf("fileno(popen流)=%d\n", fileno(pf)); // fileno 反向取底层 fd
        pclose(pf);
    }

    // 4) 自管缓存: 全缓存 + tmpfile(关闭即自动 unlink, 不留痕)
    FILE *tf = tmpfile();
    if (tf) {
        setvbuf(tf, NULL, _IOFBF, 65536);      // 全缓存, 64K 由库分配
        fwrite("hello", 1, 5, tf);
        rewind(tf);
        char buf[8] = {0};
        fread(buf, 1, 5, tf);
        printf("tmpfile 读回: %s\n", buf);
    }
    return 0;
}
```

**本章串联**：标准 I/O 底层全走第3章 `open`/`read`/`write`（用 `fileno` 可互通）。第7章 `malloc` 分配的缓存要在流关闭前有效；第14章管道常 `fdopen` 包装；第12章 `mmap` 是另一种"少复制"的高性能替代。

---

## 第6章 系统数据文件和信息

**一句话本质**：系统把"口令/组/主机"等信息放在数据文件里，并提供统一的 **get / set / end 函数族**来查——你不用自己 parse 文本，换实现也不影响代码。

**生活类比**：像公司 **HR 系统**——不用翻纸质花名册，调 `getpwnam("stevens")` 就拿员工卡（uid/gid/shell/home）。底层格式变（文本→数据库）你无感知。

**核心知识点（串联讲解）**
- **口令文件 `/etc/passwd`**：7 字段 `name:passwd:uid:gid:gecos:dir:shell`。`getpwuid`(ls 用，uid→名)/`getpwnam`(login 用)；遍历用 `getpwent`/`setpwent`/`endpwent`（看完必须 `endpwent` 关文件）。
- **阴影口令**：加密口令单存 `/etc/shadow`(SVR4) 或 `/etc/master.passwd`(BSD)，普通用户读不到，提升安全性；`login`/`passwd` 等 SUID 程序才访问。
- **组文件 `/etc/group`**：`getgrgid`/`getgrnam`；**添加组 ID**（4.2BSD 引入，最多 `NGROUPS_MAX=16`）让一个用户同时属多组，权限检查比对有效 gid 和所有添加组。**FIPS 要求支持且至少 8 个**。
  - `getgroups`(取添加组表)/`setgroups`(特权)/`initgroups`(login 时初始化，调 setgroups)。
- **其他数据文件**：`hosts`/`networks`/`protocols`/`services` 等，全部遵循"get 取一条 + set 反绕 + end 关闭 + 按关键字搜索"的统一模式（表 6-3）。
- **登录会计**：`utmp`(当前登录)、`wtmp`(历史登录注销)；`who`/`last` 读它们。
- **系统标识**：`uname` 取 `sysname/nodename/release/version/machine`；伯克利 `gethostname` 取主机名（TCP/IP 域名）。
- **时间日期**（ANSI C 定义，POSIX 加 `TZ` 环境变量）：
  - `time_t` = 1970-1-1 起秒数（内核基准，UTC）。
  - `time()` 取当前；`localtime`(本地时区)/`gmtime`(UTC) → `struct tm`（分解时间）；`mktime` 反向。
  - `ctime`/`asctime` → 26 字节字符串；`strftime` 像 `printf` 一样格式化（受 `TZ` 影响，处理夏时制）。
  - BSD `gettimeofday` 提供微秒级分辨率（SVR4 用 `stime` 设时间）。

**关键 API 速查**
- `getpwuid`/`getpwnam`/`getpwent`；`getgrgid`/`getgrnam`/`getgrent`
- `getgroups`/`initgroups`；`getutx`/`getut`(登录会计)
- `uname`/`gethostname`；`time`/`localtime`/`gmtime`/`mktime`/`ctime`/`strftime`

**易错点 & 实战**
- `getpwent` 等返回的 struct 是**静态区**，下次调用被覆盖——要保存得先 `memcpy`。
- 遍历口令文件后忘 `endpwent` → 文件描述符泄漏。
- 实战：写一个 `mywho`（读 utmp）、`mylast`（读 wtmp）；用 `strftime` 输出类 `date` 格式并改 `TZ` 观察时区变化。

**面试考点**
- 为什么要有阴影口令文件？普通用户读不到加密口令有何安全意义？
- 添加组 ID 解决了什么问题？（一个用户参与多项目，不必频繁 `newgrp`）
- `time_t` 是什么？`localtime` 与 `gmtime` 区别？`TZ` 环境变量影响哪些函数？

**代码实战**

第6章是"系统数据文件"——口令文件、组文件、主机信息、时间。下面把当前用户、主组、附加组、系统名、时间都查出来。

```c
/* ch6_系统数据文件.c —— 口令/组/主机/时间
 * 体现: getpwuid/getpwnam、getgrgid/getgrnam、getgroups、uname、
 *       time/localtime/strftime、gettimeofday
 * 编译: cc ch6_系统数据文件.c -o ch6 && ./ch6
 */
#include <stdio.h>
#include <unistd.h>
#include <sys/utsname.h>
#include <sys/time.h>
#include <pwd.h>
#include <grp.h>

int main(void) {
    uid_t uid = getuid();
    struct passwd *pw = getpwuid(uid);         // 查当前用户口令项
    printf("当前用户: %s (uid=%d, 家=%s, shell=%s)\n",
           pw->pw_name, pw->pw_uid, pw->pw_dir, pw->pw_shell);

    struct group *gr = getgrgid(pw->pw_gid);   // 查主组
    printf("主组: %s (gid=%d)\n", gr->gr_name, gr->gr_gid);

    gid_t groups[32];
    int ng = getgroups(32, groups);            // 附加组: 进程可属多组
    printf("附加组数=%d: ", ng < 0 ? 0 : ng);
    for (int i = 0; i < ng; i++) {
        struct group *g = getgrgid(groups[i]);
        if (g) printf("%s ", g->gr_name);
    }
    putchar('\n');

    struct utsname u;
    if (uname(&u) == 0)                         // 系统身份
        printf("系统: %s %s %s\n", u.sysname, u.release, u.machine);

    time_t now = time(NULL);
    char buf[64];
    strftime(buf, sizeof buf, "%Y-%m-%d %H:%M:%S", localtime(&now)); // 人类可读
    printf("现在: %s\n", buf);
    struct timeval tv;
    gettimeofday(&tv, NULL);                    // 微秒级
    printf("微秒部分: %ld\n", (long)tv.tv_usec);
    return 0;
}
```

**本章串联**：`getpwuid` 在第1章 ls 例子里已用；uid/gid/添加组是本章与第4章权限、第8章 exec 时 SUID 程序的"实际/有效 ID"检查紧密咬合。时间函数在第1章 `time` 命令、第8章进程时间统计复用。

---

## 第7章 UNIX进程的环境

**一句话本质**：进程启动靠 `exec`→启动例程→`main`；进程终止有 5 种方式；本章讲清 C 程序的内存布局、命令行参数、环境变量、动态分配、非局部跳转 `setjmp`/`longjmp`，以及资源限制——这是理解第8章进程控制的前置知识。

**生活类比**：进程像一个**上班的人**——起床（启动例程）→打卡做任务（`main`）→下班（终止）。内存布局是办公室各区：正文段=公司制度手册（只读、全员共享）、初始化数据=固定工位、bss=空储物柜（启动才清零）、堆=按需申领的仓库、栈=临时办公桌（函数调用现场）。环境变量=便签纸 `name=value`；`atexit`=下班前必办的手续清单（倒序办）。

**核心知识点（串联讲解）**
- **main 如何被调用**：内核 `exec` → 启动例程（汇编，连接编辑器设的入口）从内核取 `argv`/`envp` → 调 `main(argc, argv)`。启动例程形如 `exit(main(argc,argv))`，所以 **main 返回 == 调 exit**。main 原型应是 `int main(int, char *[])`。
- **5 种终止方式**：正常 (a)`main` 返回 (b)`exit` (c)`_exit`；异常 (a)`abort` (b)信号。`_exit` 直接进内核；`exit` 先做清理（终止处理程序→刷标准 I/O→关流）再进内核。
- **退出状态陷阱**：main 没 `return` / 调 `exit` 不带参数 → 终止状态**未定义**。经典 `main(){printf("hi\n");}` 不完整，应 `return 0` 或 `exit(0)`。
- **atexit**：登记最多 32 个终止处理程序，`exit` 时**逆序**调用，登记多次调多次（ANSI C 引入的机制）。
- **命令行参数**：ANSI/POSIX 要求 `argv[argc]==NULL`，循环可写 `for(i=0; argv[i]; i++)`。
- **环境表**：`extern char **environ`；形式 `name=value` 字符串数组。传统 main 第三参 `envp` 已被 `environ` 取代（POSIX 不推荐）。用 `getenv`/`putenv`/`setenv`/`unsetenv` 操作：`putenv("name=val")` 直接放表（已存在先删）；`setenv(name,val,rewrite)` 中 `rewrite=0` 时不覆盖已有；`unsetenv` 删定义。改环境只影响当前进程及**子进程**，不影响父（通常是 shell）。
- **C 程序存储布局**（高→低：栈 / 堆 / 未初始化数据 bss / 初始化数据 / 正文）：正文段机器指令（只读、可共享）；初始化数据初值存盘；bss 启动内核清零、**不占磁盘文件**；堆 `malloc` 动态分配；栈放自动变量与函数调用现场（支持递归）。`size` 命令报 text/data/bss（不含堆、栈，运行时才定）。
- **共享库**：库例程放所有进程共享区，首次执行/调用时动态连接。减小可执行文件、换库版本无需重连；代价是一点运行开销。
- **存储分配** `malloc`/`calloc`(每位 0)/`realloc`(改长度，ptr=NULL 时同 malloc)。返回指针**适当对齐**。实现靠 `sbrk` 扩堆；`free` 释放回池（通常不还给内核）。**致命坑**：写越分配区尾部→破坏相邻块管理信息（极难查）；释放后又用；`free` 非 alloc 返回的指针；`realloc` 移动后旧指针失效。`alloca` 在栈帧上分配，函数返回自动释放（非所有系统支持）。
- **setjmp/longjmp**：非局部跳转（跨函数栈帧回跳），处理深层嵌套错误。`setjmp(env)` 直接调返 0，从 `longjmp(env,val)` 返非 0。**变量坑**：`longjmp` 后自动/寄存器变量值**不确定**（依赖实现）；要跨跳转保持值用 `volatile`。全局/静态变量保持不变。另一坑：函数返回后其栈帧被复用，不能返回指向自动变量的指针。
- **资源限制 getrlimit/setrlimit**：`struct rlimit{rlim_cur(软), rlim_max(硬)}`。规则：(1)软≤硬可改；(2)普通用户能降硬（不可逆）；(3)只有 root 能升硬。`RLIM_INFINITY`=无限。`RLIMIT_CORE`/`CPU`/`DATA`/`FSIZE`/`NOFILE`/`STACK`/`NPROC` 等。限制被子进程继承→想影响 shell 所有后续进程就放进 shell（`ulimit`/`limit`）。

**关键 API 速查**
- `void exit(int)` / `void _exit(int)`(unistd.h)
- `int atexit(void (*)(void))`
- `char *getenv(name)`；`putenv` / `setenv` / `unsetenv`
- `void *malloc` / `calloc` / `realloc` / `free`
- `int setjmp(jmp_buf)` / `void longjmp(jmp_buf, int)`
- `getrlimit` / `setrlimit(int, struct rlimit*)`

**易错点 & 实战**
- main 忘记 `return`/`exit` → 终止状态随机（书习题 7.1：只 `printf("hello")` 不调 exit，返回码＝栈上残留值，常见 13）。
- `setjmp`/`longjmp` 跨跳转后用 `volatile` 保变量；信号处理里改用 `sigsetjmp`/`siglongjmp`（第10章）。
- 不要在函数内给自动变量设 I/O 缓存后返回。
- Python 对照：`os.environ` 读写环境变量；`atexit.register` 注册退出处理；`resource.setrlimit` 设资源限制。
- 实战：用 `atexit` 注册两个处理程序验证"逆序调用"；用 `resource.setrlimit(resource.RLIMIT_CORE, (0,0))` 禁止产生 core。

**面试考点**
- `exit` vs `_exit` 区别？标准 I/O 缓存在何时刷？
- main 返回 == exit 吗？为什么 main 要声明返回 int？
- C 程序内存分几段？bss 为什么不占磁盘？
- `setjmp`/`longjmp` 有什么坑？为什么信号里不能用普通 longjmp？
- 资源限制的软/硬限制区别？普通用户能改硬限制吗？

**代码实战**

第7章讲进程"启动前后"的一切：命令行参数、环境表、退出清理、非局部跳转、内存布局、资源限制。下面一次性演示 `atexit` 逆序、`getenv`、资源限制，以及 `setjmp`/`longjmp`（注意 `volatile`）。

```c
/* ch7_进程环境.c —— atexit 逆序 / 环境表 / setjmp-longjmp / 资源限制
 * 体现: exit/_exit、atexit(逆序调用)、getenv、setjmp/longjmp、volatile 的必要性、
 *       getrlimit/setrlimit
 * 编译: cc ch7_进程环境.c -o ch7 && ./ch7
 */
#include <stdio.h>
#include <stdlib.h>
#include <setjmp.h>
#include <sys/resource.h>

static jmp_buf env;

void bye1(void) { printf("atexit #1 (先注册)\n"); }
void bye2(void) { printf("atexit #2 (后注册, 但先执行)\n"); }

int main(int argc, char *argv[]) {
    atexit(bye1);
    atexit(bye2);                          // 清理函数按"注册逆序"调用

    printf("环境变量 PATH=%s\n", getenv("PATH"));   // 环境表查询

    // 资源限制: 查询"每进程最多打开文件数"
    struct rlimit rl;
    getrlimit(RLIMIT_NOFILE, &rl);
    printf("打开文件数: 软限=%ld 硬限=%ld\n", (long)rl.rlim_cur, (long)rl.rlim_max);

    // setjmp 首次返回 0; longjmp 跳回时返回 42
    volatile int v = 0;                    // 必须用 volatile: longjmp 后值才确定
    if (setjmp(env) != 0) {
        printf("从 longjmp 跳回, v=%d\n", v);
        return 0;                          // 返回会按逆序触发 atexit
    }
    v = 100;
    printf("即将 longjmp...\n");
    longjmp(env, 42);                      // 跳过中间代码, 直接回 setjmp
    printf("这行永不执行\n");              // 不可达
    (void)argc; (void)argv;
}
```

**本章串联**：进程环境是进程控制的前置知识——第8章 `fork`/`exec` 直接复用本章的内存布局/环境表/`atexit`；`exec` 不换环境指针但可换内容；`setjmp` 在第10章信号处理里升级为 `sigsetjmp`。资源限制与第2章 `sysconf`、第8章进程会计呼应。

---

## 第8章 进程控制

**一句话本质**：UNIX 创建新进程的唯一方法是 `fork`（或 `vfork`）；新程序靠 `exec` 族替换正文/数据/堆/栈；父进程用 `wait`/`waitpid` 收尸取终止状态；此外还有 `exit`、僵死进程、用户/组 ID 切换、解释器文件、`system`、进程会计。

**生活类比**：`fork`=**克隆自己**（父子长得一样但各有身份证 pid，写时才真分开）；`exec`=**换脑**（人不换，但脑子里装的本领全换成另一个程序）；`wait`=**父母等孩子下班问表现**（终止状态）；僵死=孩子死了但父母没去销户，留着档案（zombie）。

**核心知识点（串联讲解）**
- **进程 ID**：唯一非负整数。0=调度（swapper，内核进程），1=init（引导后起系统，普通用户进程但特权，永终止，领养孤儿），2=页精灵（虚存）。`getpid`/`getppid`/`getuid`/`geteuid`/`getgid`/`getegid` 都无出错返回。
- **fork**：调一次返两次（子返 0，父返子 pid）。子复制父的数据/堆/栈（COW 写时复制：共享只读，谁改谁拷页）；正文段只读则共享。**文件描述符父子共享同一文件表项**（同位移量）——这是 fork 后文件共享的基础。继承：实际/有效 uid/gid、进程组、会话、环境、资源限制… **不继承**：父的文件锁、子未决告警/信号、tms_* 置 0、pid/ppid 不同。失败两因：进程太多 / 超 `CHILD_MAX`。两种用法：(1)父复制自己各跑一段；(2)子立刻 `exec`（shell）。
- **vfork**：不复制地址空间（子在父空间跑，直到 `exec`/`exit`）；保证**子先跑**。子必须用 `_exit`（不是 `exit`）——`exit` 会刷标准 I/O 把父的流关了。
- **exit / 终止状态 / 僵死**：父先死→子被 init **领养**（父 pid 改 1）。子先死、父没 `wait`→子变**僵死**（zombie，`ps` 显示 Z），内核留 pid+状态+CPU 时间，父 `wait` 才收尸。init 领养的进程终止，init 会 `wait`，不会变僵死。
- **wait / waitpid**：`wait` 阻塞到任一子终止，返子 pid。`waitpid(pid, statloc, opt)`：pid=-1 任一子 / >0 指定 / =0 同组 / <0 组=|pid|。options：`WNOHANG`（不阻塞）/ `WUNTRACED`（作业控制）。查状态宏：`WIFEXITED`→`WEXITSTATUS`（低8位）/`WIFSIGNALED`→`WTERMSIG`（+`WCOREDUMP`）/`WIFSTOPPED`→`WSTOPSIG`。避免僵死技巧：**fork 两次**（父 fork 子，子再 fork 孙，子立刻退出，孙被 init 领养）。
- **wait3/wait4**：多一个 `rusage` 参数，返回终止进程及其子进程资源摘要。
- **竞态条件**：多进程抢共享数据，结果看执行顺序。fork 后谁先跑不确定→竞态温床。避免：IPC/信号同步（第10章）。`while(getppid()!=1) sleep(1)` 轮询浪费 CPU。
- **exec 族**（6 个）：`execl`/`execlp`/`execle`/`execv`/`execvp`/`execve`。成功**不返回**，出错返 -1。区别：p=用 `PATH` 找 filename；l=参数表（NULL 结尾）；v=argv[] 数组；e=传 `envp[]`。只有 `execve` 是内核系统调用。exec 后 **pid 不变**，保持 uid/gid、进程组、会话、cwd、信号屏蔽、资源限制等；打开文件看 `FD_CLOEXEC`（默认 exec 后仍开）；有效 uid 是否变看文件 SUID/SGID 位。参数/环境表总长限制 `ARG_MAX`。
- **setuid/setgid（改用户/组 ID）**：三套 ID（实际/有效/保存的设置-用户-ID）。超级用户 `setuid(uid)`→全改；非特权且 uid==实际或保存的→只改**有效** uid；否则 EPERM。exec 时文件 SUID 位开→有效 uid=文件属主并复制到"保存的"，使程序能临时降权再升回。`seteuid(uid)` 只改有效 uid；`setreuid` 交换实际/有效（老 BSD）。添加组 ID 不受 `setgid` 影响。
- **解释器文件**：首行 `#! pathname [arg]`。内核 `exec` 时实际跑 pathname，argv[0]=解释器，argv[1]=可选参数，之后是解释器路径+原参数。例 `#!/bin/awk -f`。好处：隐藏"是脚本"、比 shell 包一层省开销、可用非 /bin/sh 的 shell。
- **system(cmd)**：内部 `fork`+`exec`+/bin/sh -c cmd+`waitpid`。返回：fork/waitpid 失败 -1；exec 失败返 127；全成功返 shell 状态。**安全漏洞**：设置-用户-ID 程序里**绝不能**调 `system`（shell 继承 SUID 特权）。应直接用 `fork`+`exec` 并在 exec 前降回普通权。
- **进程会计**：选项开启后进程结束内核写会计记录（命令名/CPU/uid/gid/启动时间）。`accton` 起停。`ac_flag`：AFORK/ASU/ACORE/AXSIG。记录对应"进程"非"程序"。
- **getlogin**：取登录名（需连终端，精灵进程会失败）。`LOGNAME` 环境变量可改，不能用来确认用户，用 `getlogin`。
- **times**：取进程及终止子进程的墙上时钟/用户 CPU/系统 CPU（tms 结构）。墙上时间=函数返回值（相对值，两次相减）。`clock_t` 用 `_SC_CLK_TCK` 转秒。

**关键 API 速查**
- `pid_t fork(void)` / `pid_t vfork(void)`
- `void exit(int)` / `void _exit(int)`
- `pid_t wait(int*)` / `pid_t waitpid(pid_t, int*, int)`
- `execl`/`execlp`/`execle`/`execv`/`execvp`/`execve`
- `int setuid(uid_t)` / `seteuid(uid_t)` / `setreuid`
- `char *getlogin(void)`；`clock_t times(struct tms*)`

**易错点 & 实战**
- fork 后父/子谁先跑不确定→不要假设顺序；要同步用信号/IPC。
- fork 后文件描述符共享位移量→父子写同一 fd 会交织（除非有同步或各自关掉不用的）。
- vfork 子必须 `_exit`，否则 `exit` 刷走父的 stdio。
- 忘了 `wait` 子进程→大量僵死（长期运行程序常见）。
- 设置-UID 程序别用 `system`；用 `fork`+`exec` 并先 `setuid` 降权。
- Python 对照：`os.fork()`、`os.exec*`、`os.wait`/`os.waitpid`、`os._exit`、`subprocess`（推荐日常）、`os.setuid`/`os.seteuid`。
- 实战：用 `os.fork` 写多进程服务器骨架（父 wait，子处理）；制造僵死进程并 `ps` 观察 Z 状态；用 `subprocess.run` 替代 `system`。

**面试考点**
- fork 一次返回两次？子为什么返 0？
- 写时复制（COW）是什么？为什么 fork 后通常不立刻拷贝？
- fork 后文件描述符如何共享？有什么坑？
- 僵死进程怎么产生？怎么避免？为什么 init 领养的不会僵死？
- exec 后哪些属性保留？哪些变？
- 设置-用户-ID 程序为什么不能用 system？SUID 三套 ID 与保存 ID 的作用？

**代码实战**

第8章的"四大原语"是 `fork`/`exec`/`wait`/`_exit`。下面演示：`fork`+`execl`+`waitpid`、`fork` 两次避免僵死子进程、`system`（内部也是 fork+exec）。

```c
/* ch8_进程控制.c —— fork / waitpid / exec / 两次 fork 防僵死 / system
 * 体现: fork(写时复制, 父子共享 fd)、exit/_exit(子进程勿用 exit 刷 stdio)、
 *       wait/waitpid + WIF* 宏、fork 两次避免僵死、exec 六变体、system
 * 编译: cc ch8_进程控制.c -o ch8 && ./ch8
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(void) {
    // 1) fork: 子进程是父进程副本(写时复制), 共用已打开的 fd
    pid_t pid = fork();
    if (pid < 0) { perror("fork"); exit(1); }

    if (pid == 0) {                                // 子进程
        execl("/bin/ls", "ls", "-l", (char *)NULL);  // 映像换成 /bin/ls, 成功不返回
        perror("execl");                           // 只有失败才走到这
        _exit(127);                                // 用 _exit, 不刷父进程的 stdio 缓存
    }
    int status;
    waitpid(pid, &status, 0);                      // 回收子进程, 防僵死
    if (WIFEXITED(status)) printf("子进程正常退出, 码=%d\n", WEXITSTATUS(status));

    // 2) fork 两次: 孙进程被 init 接管, 父直接回收中间子进程 -> 无僵死孙进程
    pid_t p1 = fork();
    if (p1 == 0) {
        if (fork() > 0) _exit(0);                  // 中间子进程再 fork 后立刻退出
        sleep(1);                                   // 孙进程: 中间子已退, 被 init 收养
        printf("孙进程(pid=%d)在工作, 不会被父进程留下僵死\n", getpid());
        _exit(0);
    }
    waitpid(p1, NULL, 0);                           // 回收中间子进程(它已立刻退出)

    // 3) system: 内部 fork+/bin/sh -c + exec, 并对 SIGINT/SIGQUIT 特殊处理(第10章)
    printf("--- 下面用 system 跑 date ---\n");
    system("date");
    return 0;
}
```

**本章串联**：fork/exec/wait/_exit 是进程控制"四大原语"，全书后面全用它拼——第9章进程关系、第10章信号（父子同步）、第14章管道 `popen`（=fork+exec+管道）、第15章 socket 并发服务（fork 每连接）。SUID 与第4章权限、第7章环境咬合。

---

## 第9章 进程关系

**一句话本质**：进程不是孤岛——有父/子，还按"进程组"和"会话"成团。本章讲终端登录、网络登录的进程链，进程组/会话/控制终端的概念，作业控制，以及孤儿进程组。

**生活类比**：进程组像**一个项目组**（组长=进程组长，组 ID=组长 pid）；会话像**一家公司**（含多个项目组，有前台组在干活、后台组在待命）；控制终端是**公司的前台电话**，只有前台组能接客户（Ctrl-C 只打前台组）。

**核心知识点（串联讲解）**
- **终端登录**（4.3+BSD 为例）：init(PID1) 读 /etc/ttys → 每终端 `fork` → `exec getty`（显示 `login:`）→ 用户输名 → getty `exec login` → login 验密、`chdir` 到家、设组 ID、`setuid` 成用户、`exec` 登录 shell（argv[0] 首字符 `-` 表示登录 shell）。登录 shell 的 fd0/1/2=终端；父是 init→shell 死 init 再拉 getty。
- **网络登录**：不知多少连接，用 `inetd`（internet superserver）等 TCP 连接；到达时 `fork` → 子 `exec` 适当程序（telnetd）→ telnetd 开伪终端、`fork` → 子 `exec login`。最终也得到连伪终端的登录 shell。
- **进程组**：一组进程的集合，唯一 pgid。`getpgrp()` 取自己组；组长 pgid==pid。组存在与否取决于"还有没有成员"，与组长死活无关。`setpgid(pid, pgid)` 把进程加入/新建组（只能改自己或子进程，子 exec 后不能改）。
- **会话（session）**：一个或多个进程组的集合。`setsid()` 建新会话：调用者成会话首进程+新进程组组长+无控制终端（若已是组长则报错→惯例先 `fork` 让子调 `setsid`，子必非组长）。SVR4 有 `getsid` 取会话 ID（=首进程 pid）。
- **控制终端**：会话可有**一个**控制终端（登录终端/伪终端）。会话首进程=控制进程。会话分一个前台进程组 + 若干后台进程组。Ctrl-C/Ctrl-\ 产生的信号只送**前台组**。终端断开→挂断信号送控制进程。`/dev/tty` 是控制终端同义文件（无控制终端则打开失败）。
- **tcgetpgrp/tcsetpgrp**：取/设前台进程组 ID（通常作业控制 shell 调，不是应用）。
- **作业控制**（BSD 1980 引入，POSIX 标准化）：一个终端上多作业，控制谁占终端、谁后台跑。需要三支持：作业控制 shell + 内核终端驱动 + 作业控制信号。前台起 `vi`；后台起 `pr *.c | lpr &`、`make all &`。特殊字符：中断（Ctrl-C→SIGINT）、退出（Ctrl-\→SIGQUIT）、挂起（Ctrl-Z→SIGTSTP）送前台组。后台读终端→`SIGTTIN`（停）；后台写终端→`SIGTTOU`（可禁，`stty tostop`）。`fg`/`bg` 由 shell 用 `tcsetpgrp`+`SIGCONT` 调度。
- **shell 执行程序**（看 `ps -xj`）：经典 Bourne shell（无作业控制）前台/后台/管道线都在同一进程组（163），shell 是组长，管道最后一个命令是 shell 子进程其余是其孙；作业控制 shell（ksh/csh）每个作业放自己进程组，前台作业组=控制终端前台组，shell 自己在另一组。
- **孤儿进程组**：组内每个成员的父进程要么也在本组，要么不在本会话。POSIX：进程组变孤儿且组内有**停止**进程→内核先发 `SIGHUP` 再 `SIGCONT`（让停止的进程能继续，否则永远停）。孤儿组读控制终端→`read` 返 `EIO`（不是 SIGTTIN，因无人能续它）。

**关键 API 速查**
- `pid_t getpgrp(void)`；`int setpgid(pid_t, pid_t)`
- `pid_t setsid(void)`；（SVR4）`pid_t getsid(pid_t)`
- `pid_t tcgetpgrp(int fd)`；`int tcsetpgrp(int fd, pid_t)`
- 相关信号：SIGHUP/SIGCONT/SIGTSTP/SIGTTIN/SIGTTOU/SIGINT/SIGQUIT

**易错点 & 实战**
- `setsid` 前若已是进程组长会失败→先 `fork` 让子调。
- 后台作业读终端被 SIGTTIN 停，不是错误——用 `fg` 拉前台才能读。
- 孤儿进程组里的停止进程会收到 SIGHUP+SIGCONT，若没捕捉 SIGHUP 默认终止。
- Python：`os.setsid()`、`os.setpgrp()`、`os.killpg(pgid, sig)` 给进程组发信号；`os.getpgrp()`。
- 实战：写程序 `fork` 后 `setsid` 验证"无控制终端"（打开 /dev/tty 失败）；用 `killpg` 给整组发 SIGTERM 杀子进程树。

**面试考点**
- 进程组、会话、控制终端的关系？前台/后台进程组区别？
- Ctrl-C 为什么只杀前台进程组？
- 孤儿进程 vs 孤儿进程组 区别？孤儿进程组的处理？
- `setsid` 为什么要先 fork？
- 作业控制 shell 和普通 shell exec 管道时进程组织有何不同？

**代码实战**

第9章是"谁属于哪个组、哪个会话、谁握着控制终端"。下面演示进程组、`setsid` 创建新会话（顺便失去控制终端）、以及 `fork` 后子进程自建会话。

```c
/* ch9_进程关系.c —— 进程组 / 会话 / 控制终端
 * 体现: getpgrp/setpgid、setsid(新会话, 无控制终端, 会话首进程)、
 *       tcgetpgrp/tcsetpgrp(前后台组)、fork 后建会话
 * 编译: cc ch9_进程关系.c -o ch9 && ./ch9
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void) {
    printf("启动: pid=%d  pgrp=%d\n", getpid(), getpgrp());

    setpgid(getpid(), getpid());            // 把自己移入新进程组, 自己当组长
    printf("设为自己组长后 pgrp=%d\n", getpgrp());

    // setsid: 新会话 = 新进程组 + 无控制终端 + 本进程成会话首进程
    // 注意: 若已是进程组长, setsid 会失败(所以先 setpgid 独立成组)
    pid_t sid = setsid();
    if (sid < 0) perror("setsid");
    else printf("新会话 id=%d\n", sid);

    pid_t pid = fork();
    if (pid == 0) {
        setsid();                           // 子进程建独立会话(无控制终端)
        printf("子: pid=%d  pgrp=%d  (独立会话, 无控制终端)\n", getpid(), getpgrp());
        _exit(0);
    }
    waitpid(pid, NULL, 0);
    printf("父: pid=%d  pgrp=%d\n", getpid(), getpgrp());
    return 0;
}
```

**本章串联**：进程关系是信号的前置——第10章 SIGHUP/SIGCONT/SIGTSTP/SIGTTIN/SIGTTOU 全是围绕会话/作业控制运作；终端驱动的第11章还要改这些特殊字符。`fork`（第8章）后调 `setpgid` 是作业控制 shell 的标准动作。

---

## 第10章 信号

**一句话本质**：信号是**软件中断**——处理异步事件的机制（终端键、硬件异常、`kill`、软件条件如闹钟/管道断开）。本章核心是 POSIX.1 的**可靠信号**模型及全套函数，并用它实现 `abort`/`system`/`sleep`。

**生活类比**：信号像**公司里的紧急广播**——不知道什么时候响（异步），响了一种就有标准应对（默认动作：终止/忽略/停/续）。早期广播会漏播（不可靠）；POSIX 规定：广播必到、处理期间同类广播先屏蔽、处理完恢复（可靠）。

**核心知识点（串联讲解）**
- **信号本质**：名字 `SIGxxx`（正整数，无 0 号=空信号）。产生源：终端键（DELETE→SIGINT）、硬件异常（0除→SIGSEGV）、`kill`（进程/进程组）、`kill(1)` 命令、软件条件（SIGALRM 闹钟/SIGPIPE 管道读端关/SIGURG）。
- **处理方式**：(1)`SIG_DFL` 默认 (2)`SIG_IGN` 忽略 (3)捕获（用户函数）。
- **早期不可靠信号的问题**：信号可能丢失；处理中无法可靠阻塞同类信号；处理完动作被复位成默认（需重注册）。POSIX 可靠信号解决。
- **signal 函数**：`void (*signal(int, void(*)(int)))(int)`。书用 `sigaction` 实现可靠版 signal（默认 `SA_RESTART` 重启被中断系统调用，但 SIGALRM 不重启以保留超时能力）。
- **可中断系统调用**：早期 `read` 等被信号中断返 `EINTR` 且数据可能没读全。解决：(1)手动重读 (2)`SA_RESTART` 自动重启 (3)`sigaction` 设 `SA_RESTART`。
- **异步信号安全**：信号处理里只做最简事——设 `sig_atomic_t` 全局变量（如 `volatile sig_atomic_t flag`）；不能调非异步安全函数（如 `printf`/`malloc`）。表10-3 列了安全函数。
- **kill/raise/alarm**：`kill(pid,sig)` 发信号（pid>0 指定，=0 同组，<0 组=|pid|，=-1 所有有权限进程；0 号=空信号测存在）。`raise(sig)`=给自己发。`alarm(sec)` 设闹钟，超发 SIGALRM，返剩余秒；同进程只一个闹钟。
- **信号集 sigset_t**：`sigemptyset`/`sigfillset`/`sigaddset`/`sigdelset`/`sigismember`。用位掩码实现（信号编号-1=位号）。
- **sigprocmask**：查/改**信号屏蔽字**（当前阻塞不递送的集合）。how=`SIG_BLOCK`（或）/`SIG_UNBLOCK`（减）/`SIG_SETMASK`（赋值）。改后若有不再阻塞的未决信号，返回前至少递送一个。函数里临时阻塞某信号：必须**保存旧屏蔽字并用 SIG_SETMASK 还原**，不能 `SIG_UNBLOCK`（调用者可能也已阻塞它）。
- **sigpending**：取"被阻塞且未决"的信号集。
- **sigaction**：查/改指定信号动作（取代 signal）。`struct sigaction{ sa_handler; sa_mask; sa_flags; }`。`sa_mask` 在处理函数调用前加到屏蔽字，返回时恢复（保证处理函数跑完前同类信号被阻塞）。`sa_flags`：`SA_RESTART`（重启系统调用）/`SA_NOCLDSTOP`（子停不发 SIGCHLD）/`SA_NOCLDWAIT`（子终不僵死）/`SA_NODEFER`（处理中不自动阻塞）/`SA_RESETHAND`（入口复位默认）/`SA_SIGINFO`（带附加信息）。
- **sigsetjmp/siglongjmp**：信号处理里做非局部跳转要用它（普通 `setjmp`/`longjmp` 对信号屏蔽字行为依赖实现）。`sigsetjmp(env, savemask)` 中 `savemask≠0` 时保存屏蔽字，`siglongjmp` 恢复。保护：跳转前用 `volatile sig_atomic_t canjump` 标志，未初始化不跳。
- **sigsuspend**：**原子地**"用 sigmask 替换屏蔽字 + 挂起等信号"。返回总是 -1（EINTR）。用来保护临界区不被指定信号中断，或等某信号处理程序设全局变量。解决了"解除阻塞与 pause 之间信号丢失"的竞态。
- **abort**：发 SIGABRT 给自己，进程不应忽略（覆盖阻塞/忽略）。捕捉到也不能返回（除非 exit/_exit/longjmp）。POSIX 要求终止时刷所有标准 I/O 流（难实现，保护性代码自己先刷）。
- **system 的可靠版**：POSIX.2 要求 system **忽略 SIGINT/SIGQUIT、阻塞 SIGCHLD**（避免父误收子终信号、避免父子都收终端信号）。实现须在 **fork 之前**改信号配置（否则子先跑可能漏）。返回值=shell 终止状态（异常终止时 shell 返 128+信号号，如 SIGINT=2→130）。
- **sleep**：挂起到 seconds 到 或 捕获信号返回。返 0（睡足）/未睡秒数（被信号打断）。实现可用 alarm（但与已设闹钟有交互，POSIX 未定义）。程序10-21 是可靠版（用 sigaction 避免竞态，不用非局部跳转）。
- **作业控制信号**（表10-1）：SIGCHLD（子停/终）、SIGCONT（续）、SIGSTOP（停，不可捕获）、SIGTSTP（交互停）、SIGTTIN（后台读终端）、SIGTTOU（后台写终端）。停止信号与 SIGCONT 互弃未决。管理终端的程序（如 vi）自行处理 SIGTSTP 以恢复终端状态。

**关键 API 速查**
- `void (*signal(int, void(*)(int)))(int)`；`sigaction`
- `int kill(pid_t, int)`；`raise(int)`；`unsigned alarm(unsigned)`
- `sigemptyset`/`sigfillset`/`sigaddset`/`sigdelset`/`sigismember`
- `sigprocmask`/`sigpending`/`sigsuspend`
- `sigsetjmp`/`siglongjmp`；`abort`；`sleep`

**易错点 & 实战**
- 信号处理函数里只能做异步安全操作，别调 `printf`/`malloc`；用 `volatile sig_atomic_t` 全局标志。
- 早期不可靠 signal：处理完动作复位，需重注册；用 `sigaction` 一劳永逸。
- 慢系统调用被信号中断返 EINTR → 用 `SA_RESTART` 或手动重读。
- `system` 在 SUID 程序里同样危险（继承特权）；调用前父要忽略 SIGINT/SIGQUIT、阻塞 SIGCHLD。
- 解除阻塞+等待信号要用 `sigsuspend`，不能用"unblock 然后 pause"（竞态丢信号）。
- Python：`signal.signal(sig, handler)`、`signal.pause()`、`signal.alarm`、`os.kill`/`os.killpg`（主线程才能设 handler，handler 里尽量简单）。
- 实战：用 signal 捕获 SIGINT 做优雅退出（置 flag，主循环检查）；用 `SIGCHLD` 处理子进程回收避免僵死；用 `signal.signal`+`signal.pause` 写可靠闹钟。

**面试考点**
- 信号是什么？三种处理方式？
- 早期不可靠信号的问题？POSIX 可靠信号怎么解决（不丢失/处理中阻塞/动作持久）？
- `SA_RESTART` 作用？为什么 SIGALRM 常不重启？
- 信号处理函数里为什么不能随便调 printf？什么是异步信号安全？
- `sigprocmask` 临时阻塞信号为什么用 `SIG_SETMASK` 还原而不是 `SIG_UNBLOCK`？
- `sigsuspend` 解决什么竞态？
- `SIGCHLD` 怎么用来避免僵死？`system` 为何要忽略 SIGINT/阻塞 SIGCHLD？

**代码实战**

第10章信号的关键是"可靠 + 异步信号安全"。下面用 `sigaction`（而非老 `signal`）注册处理器，演示 `sa_mask`/`SA_RESTART`、用 `sigprocmask`+`sigsuspend` 保护临界区、以及 `alarm`/`kill`。

```c
/* ch10_信号.c —— sigaction / 信号掩码 / sigsuspend / kill / alarm
 * 体现: sigaction(可靠)、sa_mask/sa_flags(SA_RESTART)、kill、alarm/pause、
 *       sigprocmask/sigpending/sigsuspend(保护临界区)、sig_atomic_t(异步安全)
 * 编译: cc ch10_信号.c -o ch10 && ./ch10  (也可另终端: kill -USR1 <pid>)
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>

static volatile sig_atomic_t got_usr1 = 0;   // 异步信号安全: 只用 sig_atomic_t

static void handler(int sig) {                // 处理函数只做最少的事
    got_usr1 = 1;
    printf("收到信号 %d\n", sig);
}

int main(void) {
    struct sigaction sa;
    sa.sa_handler = handler;
    sigemptyset(&sa.sa_mask);                  // 处理期间额外阻塞的信号
    sa.sa_flags = SA_RESTART;                  // 被中断的慢系统调用自动重启
    sigaction(SIGUSR1, &sa, NULL);             // 优于 signal(): 可靠、可设掩码

    // 临界区保护: 阻塞 SIGUSR1, 用 sigsuspend 原子等待 SIGALRM 唤醒
    sigset_t old, block;
    sigemptyset(&block); sigaddset(&block, SIGUSR1);
    sigprocmask(SIG_BLOCK, &block, &old);       // 临界区开始
    printf("临界区: SIGUSR1 已阻塞, 等 2 秒 SIGALRM 唤醒...\n");
    alarm(2);
    sigsuspend(&old);                          // 解锁并睡, 直到 SIGALRM 到来
    sigprocmask(SIG_SETMASK, &old, NULL);      // 恢复掩码

    kill(getpid(), SIGUSR1);                   // 给自己发信号(等价于 raise)
    printf("got_usr1=%d\n", got_usr1);
    return 0;
}
```

**本章串联**：信号串起前面所有进程机制——第8章 `fork` 后用信号做父子同步（TELL/WAIT）、`system` 的信号处理；第9章 SIGHUP/SIGCONT/SIGTSTP/SIGTTIN/SIGTTOU 全是作业控制信号；第11章终端驱动的特殊字符产生这些信号；第14章管道读端关写端收 SIGPIPE。`setjmp` 在本章升级为 `sigsetjmp`。

---

## 第11章 终端 I/O

**一句话本质**：终端设备的行为由内核的"终端行规程/驱动"控制，所有可配置项都装在一个 `termios` 结构里（输入/输出/控制/本地 四类标志 + 特殊字符数组）。POSIX.1 提供 12 个函数统一操作它——规范（按行）与非规范（按字节）两种输入方式是核心。

**生活类比**：终端像**前台的翻译官**（行规程）。你敲的键先过它加工（回显、把 Ctrl-C 变成信号、把字符装配成行）才递给程序；你设 `termios` 就是给翻译官立规矩。

**核心知识点（串联讲解）**
- **两种输入方式**：规范方式（ICANON 开）按行装配，read 一次最多返回一行；非规范方式（关 ICANON）不装配，靠 `MIN`/`TIME` 控制 read 何时返回。cbreak（关回送、每次 1 字节、仍处理信号）与 raw（还关 ISIG/IEXTEN/ICRNL/IXON、8 位原始）是两种常见非规范配置。
- **终端结构**：输入队列 + 输出队列 + 行规程模块（图11-2）。队列长度有限（`MAX_INPUT`/`MAX_CANON`），输出满时内核让写进程睡眠。
- **termios 四大字段**：`c_iflag`（输入，如 ICRNL/IXON/ISTRIP）、`c_oflag`（输出，如 OPOST/ONLCR）、`c_cflag`（控制/RS-232，如 CLOCAL/CREAD/PARENB/字符长度 CSIZE）、`c_lflag`（本地/用户交互，如 ECHO/ICANON/ISIG/TOSTOP）。`c_cc[NCCS]` 数组存特殊字符。
- **12 个 POSIX 函数**：`tcgetattr`/`tcsetattr`（取/设属性，opt=TCSANOW 立刻 / TCSADRAIN 输完改 / TCSAFLUSH 输完并清未读输入）、`cfgetispeed`/`cfgetospeed`/`cfsetispeed`/`cfsetospeed`（波特率）、`tcdrain`/`tcflow`/`tcflush`/`tcsendbreak`（行控制）、`tcgetpgrp`/`tcsetpgrp`（第9章讲过）。
- **特殊输入字符**（POSIX 11 个，9 个可改）：INTR（Ctrl-C→SIGINT）、QUIT（Ctrl-\→SIGQUIT）、EOF（Ctrl-D）、ERASE、KILL、SUSP（Ctrl-Z→SIGTSTP）、STOP/START（Ctrl-S/Q 流控）、REPRINT/WERASE 等。改 `c_cc[Vxxx]` 即可；可用 `_POSIX_VDISABLE` 禁用某字符。
- **规范 vs 非规范**：`ICANON` 关后进入非规范；`MIN`/`TIME` 四种情形（表11-4）决定 read 返回时机——`MIN>0,TIME>0`（字节间计时器）、`MIN>0,TIME=0`（凑够 MIN 才返，可能永久阻塞）、`MIN=0,TIME>0`（读计时器）、`MIN=0,TIME=0`（有数据即返）。
- **窗口大小**：内核存 `winsize` 结构，`ioctl(TIOCGWINSZ/TIOCSWINSZ)` 取/设；变化向前台进程组发 `SIGWINCH`（默认忽略），vi 等据此重绘屏幕。
- **终端标识**：`ctermid`（控制终端名）、`isatty`（是否终端设备）、`ttyname`（路径名）。应用层有 `stty` 命令与 `termcap`/`terminfo`/`curses` 库。

**关键 API 速查**
- `tcgetattr`/`tcsetattr(int, int opt, termios*)`
- `cfgetispeed`/`cfgetospeed`/`cfsetispeed`/`cfsetospeed`
- `tcdrain`/`tcflow`/`tcflush`/`tcsendbreak`
- `isatty`/`ttyname`/`ctermid`

**易错点 & 实战**
- 改终端属性前**先 `tcgetattr` 保存原值，程序退出（含被信号打断）前要恢复**，否则终端"坏掉"（用 `reset` 命令救）。编写这类程序应 catch 多数信号再恢复。
- 写读口令程序（`getpass`）要临时关回送 + 阻塞 INTR/SUSP，否则输入明文回显且 Ctrl-C 会卡在"无回送"状态。
- Python：`termios`/`tty` 模块直接操 `termios`；`fcntl.ioctl` 取窗口大小；`select` 模块做非阻塞。
- 实战：用 `termios` 实现"输入无回显"的密码读取；用 `stty -a` 看 vi 设的 `MIN`/`TIME`（非规范）。

**面试考点**
- 规范方式 vs 非规范方式区别？`ICANON` 控制什么？
- EOF/INTR/KILL 特殊字符分别起什么作用？为什么禁止中断字符 ≠ 忽略 SIGINT？
- `tcsetattr` 的 `TCSAFLUSH` 语义？为什么改属性后常要再 `tcgetattr` 比对？
- 非规范下 `MIN`/`TIME` 的四种情形各自何时让 read 返回？

**代码实战**

第11章终端 I/O 靠 `termios` 结构体。下面演示两种经典操作：设"原始模式"（关规范/回显/信号，用 `VMIN`/`VTIME` 控制一次返回多少），以及"只关回显读口令"。

```c
/* ch11_终端IO.c —— termios 原始模式 / 不回显读口令
 * 体现: tcgetattr/tcsetattr、ICANON/ECHO/ISIG、VMIN/VTIME 实例、
 *       cfgetispeed/cfsetospeed、tcflush
 * 编译: cc ch11_终端IO.c -o ch11 && ./ch11   (需在真实终端, 非管道)
 */
#include <stdio.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

int main(void) {
    struct termios old;
    tcgetattr(STDIN_FILENO, &old);             // 先存原始设置, 退出前要还原!

    // 原始(非规范)模式: 关 规范行/回显/信号, 每来 1 字符即返回(VMIN=1,VTIME=0)
    struct termios t = old;
    t.c_lflag &= ~(ICANON | ECHO | ISIG);
    t.c_cc[VMIN]  = 1;
    t.c_cc[VTIME] = 0;
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &t);
    printf("原始模式: 输入不回显, 按任意键继续...\n");
    char c;
    if (read(STDIN_FILENO, &c, 1) == 1) printf("你按了: %c\n", c);
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &old);  // 务必还原终端

    // 只关回显读口令(保留规范模式): 用独立快照还原, 别误用上面的 old
    struct termios pw, saved;
    tcgetattr(STDIN_FILENO, &pw); saved = pw;
    pw.c_lflag &= ~ECHO;
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &pw);
    printf("\n请输入口令(不回显): "); fflush(stdout);
    char pwd[64];
    if (fgets(pwd, sizeof pwd, stdin)) printf("\n口令长度 %zu\n", strlen(pwd) - 1);
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &saved);
    return 0;
}
```

**本章串联**：终端 I/O 是很多机制的"下半身"——特殊字符产生的 SIGINT/SIGQUIT/SIGTSTP 正是第10章信号；控制终端/前台组概念来自第9章；`tcflush`/`tcsetpgrp` 与作业控制绑定。第17章（PostScript 打印机）、第18章（调制解调器）会实战用到本章。

---

## 第12章 高级 I/O

**一句话本质**：一组"高级" I/O 利器——非阻塞 I/O、记录锁（`fcntl`）、System V 流、I/O 多路转接（`select`/`poll`）、`readv`/`writev`、存储映射 `mmap`。它们解决"不阻塞等待""多描述符并发""免拷贝读写"等高级需求。

**生活类比**：阻塞 I/O 像**排队等窗口**（不叫到号不走）；非阻塞像**看一眼没号就走**（轮询，费 CPU）；`select`/`poll` 像**取了号坐着等广播叫你**（多路转接）；`mmap` 像**把文件摊在桌上直接改**（省去读写搬运）。

**核心知识点（串联讲解）**
- **非阻塞 I/O**：`open` 带 `O_NONBLOCK` 或 `fcntl` 加该状态标志。不能完成立即返 -1 且 `errno=EAGAIN`（或 `EWOULDBLOCK`）。用于终端、网络、流设备。单纯轮询浪费 CPU → 改用多路转接。
- **记录锁**：`fcntl` 的 `F_SETLK`/`F_SETLKW`/`F_GETLK` + `flock` 结构。读锁（共享，多进程可共存）vs 写锁（独占）。锁区域由 `l_start`+`l_whence`+`l_len` 定，`l_len=0` 表示"到文件尾无穷远"。兼容性：多读可共存；读写/写写互斥。
  - **继承与释放三规则**：(1)进程终止或关闭任一相关 fd，该进程设的锁全释放；(2)`fork` 后子进程**不继承**父锁；(3)`exec` 后新程序继承原锁（SVR4/4.3+BSD）。
  - **建议性 vs 强制性**：建议性锁只约束"合作进程"（都走同一加锁库才有效）；强制性锁（仅 SVR4，设组 ID 位 + 关组执行位）由内核对每次 `read`/`write`/`open` 检查。书上结论：新程序优先用建议性锁 + 普通编辑器约定。
  - 死锁：两进程互等对方持有的锁，内核检测后选一个返 `EDEADLK`。
- **System V 流**：用户进程与设备驱动间的全双工通路，可压入处理模块（如终端的 `ldterm`）。消息制（`M_DATA`/`M_PROTO`），用 `putmsg`/`getmsg` + `ioctl(I_xxx)`。`isastream` 判断是否流设备。
- **I/O 多路转接**：`select(maxfdp1, readfds, writefds, exceptfds, tvptr)` 配 `FD_ZERO/SET/ISSET`，返回就绪描述符数；`poll(struct pollfd[], nfds, timeout)` 用 `pollfd` 数组（`events`/`revents`）。二者告诉内核"关心哪些 fd 的读/写/异常，就绪才返回"，从而单进程并发处理多描述符。注意：描述符本身阻塞与否不影响 `select`/`poll` 是否阻塞；"准备好"= read/write 不阻塞；文件结尾 `select` 视为"可读"（read 返 0）。
- **异步 I/O**：`SIGPOLL`（SVR4，仅流设备）/`SIGIO`+`SIGURG`（4.3+BSD，仅终端/网络）。每进程只有一个信号 → 不知是哪个 fd 就绪，限制大。
- **readv/writev**：散布读/聚集写，一次系统调用处理多个不连续缓存（比多次 `read`/`write` 省系统调用）。
- **readn/writen**：封装"read/write 可能返回少于请求"的循环（终端/网络/流必备）。
- **存储映射 mmap**：`mmap` 把文件映射到内存，读写内存即读写文件。`prot`（PROT_READ/WRITE/EXEC，须与 `open` 方式匹配）`flag`（MAP_SHARED 改文件 / MAP_PRIVATE 副本 / MAP_FIXED）。`munmap` 解除；关 fd **不**解除映射。`fork` 继承、`exec` 不继承。`SIGSEGV`（越权访问）/ `SIGBUS`（映射区被别人截短）。性能：大文件复制比 `read`/`write` 快（省一次内核↔用户拷贝）。

**关键 API 速查**
- `open O_NONBLOCK` / `fcntl` 记录锁（`F_SETLK`/`F_SETLKW`/`F_GETLK`）
- `select` / `poll`
- `readv` / `writev` / `readn` / `writen`
- `mmap` / `munmap`

**易错点 & 实战**
- 非阻塞 read 返 -1/`EAGAIN` 要重试，且别写成死循环——配合 `select` 等就绪再读。
- 记录锁 `l_len=0` 表示"到文件尾无穷"，容易因绝对/相对位移换算差异耗尽内核锁表（`ENOLCK`）；`fork` 后子不继承父锁，不能靠它做父子互斥。
- `mmap` 后必须先设输出文件长度（写字节或 `ftruncate`），否则首次访问映射区会 `SIGBUS`；关闭输入 fd 不会使映射失效。
- Python：`selectors`/`select` 模块做多路转接；`mmap` 模块；`fcntl.flock`/`fcntl.lockf` 做记录锁。
- 实战：用 `select` 写一个同时读终端和网络的拨号程序；用 `mmap` 复制大文件；用记录锁做"单实例守护进程"。

**面试考点**
- 阻塞 vs 非阻塞 I/O 区别？非阻塞 read 返 `EAGAIN` 怎么处理？
- `select` 与 `poll` 区别？`select` 的 `maxfdp1` 是什么？
- 记录锁"建议性" vs "强制性"？`fcntl` 锁的继承规则（尤其 `fork` 不继承）？
- `mmap` 的优缺点？为什么 `fork` 继承、`exec` 不继承？`SIGBUS` 什么时候来？
- 为什么网络/终端的 `read`/`write` 可能返回少于请求字节？（需用 `readn`/`writen`）

**代码实战**

第12章是"性能与并发工具箱"。下面给两个独立示例：`select` 单进程并发回显服务器（非阻塞多路），以及 `fcntl` 建议记录锁（多进程互斥）。

```c
/* ch12_高级IO.c (1/2) —— select 单进程并发回显服务器
 * 体现: fcntl O_NONBLOCK、select 多路转接、FD_SET 宏、非阻塞 accept/read
 * 编译: cc ch12_select.c -o ch12s && ./ch12s 8080
 *      测试: 另开终端 nc 127.0.0.1 8080, 输入会被回显
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <arpa/inet.h>
#include <sys/select.h>

int main(int argc, char *argv[]) {
    int port = argc > 1 ? atoi(argv[1]) : 8080;
    int lfd = socket(AF_INET, SOCK_STREAM, 0);
    int opt = 1; setsockopt(lfd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof opt);
    struct sockaddr_in a = {0};
    a.sin_family = AF_INET; a.sin_port = htons(port);
    bind(lfd, (void*)&a, sizeof a); listen(lfd, 5);

    fd_set master, rds; FD_ZERO(&master); FD_SET(lfd, &master);
    int maxfd = lfd;
    printf("select 回显服务器监听 %d...\n", port);

    for (;;) {
        rds = master;
        select(maxfd + 1, &rds, NULL, NULL, NULL);   // 同时盯一批 fd
        for (int fd = 0; fd <= maxfd; fd++) {
            if (!FD_ISSET(fd, &rds)) continue;
            if (fd == lfd) {                          // 新连接
                int cfd = accept(lfd, NULL, NULL);
                FD_SET(cfd, &master); if (cfd > maxfd) maxfd = cfd;
            } else {                                  // 某客户端来数据
                char buf[1024];
                ssize_t n = read(fd, buf, sizeof buf);
                if (n <= 0) { close(fd); FD_CLR(fd, &master); }  // 断开
                else write(fd, buf, n);               // 回显
            }
        }
    }
}
```

```c
/* ch12_高级IO.c (2/2) —— 建议记录锁(多进程并发控制)
 * 体现: fcntl F_SETLK/F_SETLKW/F_GETLK、struct flock、写锁互斥/读锁共享
 * 编译: cc ch12_lock.c -o ch12l && ./ch12l 文件
 *      两个终端同时跑, 会看到一方拿锁期间另一方被阻塞
 */
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    if (argc != 2) { fprintf(stderr, "用法: %s 文件\n", argv[0]); return 1; }
    int fd = open(argv[1], O_RDWR | O_CREAT, 0644);

    struct flock lk;
    lk.l_type   = F_WRLCK;                 // F_RDLCK 共享读锁 / F_WRLCK 互斥写锁
    lk.l_whence = SEEK_SET; lk.l_start = 0; lk.l_len = 1;  // 锁第0字节 = 整库粗锁

    printf("尝试加写锁(阻塞等待)...\n");
    fcntl(fd, F_SETLKW, &lk);              // LKW: 拿不到就等; F_SETLK 则立即返回
    printf("已加锁, 睡 10 秒(期间别的进程被挡住)\n");
    sleep(10);
    lk.l_type = F_UNLCK; fcntl(fd, F_SETLK, &lk);   // 释放
    printf("已解锁\n");
    close(fd);
    return 0;
}
```

**本章串联**：本章是全书的"性能与并发工具箱"——非阻塞+多路转接是网络编程（第15/16章 socket、第17章打印机、第18章调制解调器）的基石；记录锁是第16章数据库函数库并发控制的核心；`mmap` 在第14章共享存储还要再用；`readv`/`writev`、`readn`/`writen` 在后续流管道里反复出现。

---

## 第13章 精灵进程

**一句话本质**：精灵进程（daemon）是后台长期运行、无控制终端的进程（如 `syslogd`/`cron`/`inetd`/`lpd`）。编写要遵循一套固定规则（`fork`→`setsid`→`chdir`→`umask`→关 fd），出错用 `syslog` 而非 stderr。

**生活类比**：精灵进程像**大楼的夜班值守**——没人在终端看着它，24h 跑；它出问题不能喊人，只能写"值班日志"（`syslog`）。

**核心知识点（串联讲解）**
- **特征（`ps -axj` 可见）**：无控制终端（TTY 显示 `?`）、父进程是 init、通常以 root 运行、是会话/进程组首进程且唯一成员。进程 0/1/2 是特殊的内核进程。
- **编程规则（daemon_init）**：(1)`fork` 后父 `exit`——让 shell 认为命令完成，且子进程非进程组组长（为 `setsid` 铺路）；(2)`setsid` 建新会话（无控制终端、新进程组首）；(3)`chdir /`——避免占用可卸载的文件系统；(4)`umask(0)`——不屏蔽任何权限位；(5)关闭继承的多余 fd（用 `open_max` 上限循环关）。
- **出错记录**：无终端不能写 stderr。BSD 的 `syslog` 设施最常用：`syslogd` 精灵经 `/dev/log`（UNIX 域数据报套接口）收集，`/etc/syslog.conf` 决定去向（文件/控制台/邮件）。`openlog`/`syslog`/`closelog`；`facility`（LOG_DAEMON/LOG_AUTH/LOG_CRON/LOG_LPR…）+ `level`（LOG_EMERG 最高 → LOG_DEBUG 最低）。`%m` 自动换成 `errno` 对应消息。SVR4 用流 `log` 驱动。
- **客户机-服务器模型**：精灵常作服务器，单向（如 `lpd` 只收请求）或双向。

**关键 API 速查**
- daemon 套路：`fork` / `setsid` / `chdir` / `umask` / `close`
- `openlog` / `syslog` / `closelog`

**易错点 & 实战**
- 忘了恢复终端方式（若改过）会"搞坏"终端；单实例守护可用记录锁（对 PID 文件加写锁并保持，运行时阻止第二份副本启动）。
- `syslog` 的 `%m` 只在格式串里有效；多份副本问题用 PID 文件 + `fcntl` 写锁比死循环重试更稳。
- Python：标准库没有现成 `daemonize`，可自己 `fork`+`setsid`+`chdir`+`umask`+关 stdin/out/err；日志用 `logging` 的 `SysLogHandler`（走 `/dev/log`）或交给 systemd。
- 实战：写 `daemon_init` 后用 `ps -axj` 验证（TTY=?、SID=PID）；用 `syslog` 记一条错误并 `tail /var/log/...` 查看。

**面试考点**
- 守护进程的特征？`ps` 里怎么认出它？
- 为什么要 `fork` 两次（或 `setsid` 后建议再 fork）？`setsid` 的作用？
- 为什么要 `chdir /` 和 `umask(0)`？
- 守护进程怎么记日志？`syslog` 的 facility/level 是什么？
- 单实例守护进程怎么实现？（PID 文件 + 写锁）

**代码实战**

第13章的"精灵进程"有固定套路：`fork`+`setsid`+再`fork`+`chdir`+`umask`+关 fd+`syslog`。下面把这个 `daemon_init` 写出来。

```c
/* ch13_精灵进程.c —— 标准守护进程化 daemon_init
 * 体现: fork+setsid(脱离控制终端)、再 fork(禁止再申请控制终端)、
 *       chdir("/")、umask(0)、关闭0/1/2 重定向到 /dev/null、openlog/syslog
 * 编译: cc ch13_精灵进程.c -o ch13 && ./ch13  (ps 可看; 日志在 syslog/journalctl)
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <syslog.h>

void daemon_init(void) {
    if (fork() != 0) exit(0);            // 父退出, 子被 init 收养
    setsid();                            // 新会话, 脱离原控制终端
    if (fork() != 0) exit(0);            // 再 fork: 孙不是会话首, 拿不到控制终端
    chdir("/");                          // 改到家目录, 不挡卸载文件系统
    umask(0);                            // 清掉继承来的文件模式掩码
    int fd = open("/dev/null", O_RDWR);  // 关闭继承的 0/1/2, 重定向到 /dev/null
    dup2(fd, STDIN_FILENO); dup2(fd, STDOUT_FILENO); dup2(fd, STDERR_FILENO);
    if (fd > 2) close(fd);
}

int main(void) {
    daemon_init();
    openlog("myDaemon", LOG_PID, LOG_DAEMON);   // 守护进程用 syslog, 不写 stderr
    for (int i = 0; i < 5; i++) {
        syslog(LOG_INFO, "心跳 #%d, 还活着", i);
        sleep(2);
    }
    syslog(LOG_INFO, "守护进程退出");
    closelog();
    return 0;
}
```

**本章串联**：守护进程是前面进程关系（第9章会话/控制终端）与信号（第10章）的综合应用——`setsid` 出自第9章，出错记录依赖第14/15章的 IPC（UNIX 域套接口）。第14章客户-服务器、第15章"open 服务器"都以守护进程形态出现；第16章数据库函数库也用记录锁做单实例。

---

## 第14章 进程间通信

**一句话本质**：进程间通信（IPC）手段——管道、FIFO，以及 System V 三件套（消息队列/信号量/共享存储）。半双工管道是唯一所有 UNIX 都保证可移植的 IPC；System V IPC 问题多，新程序应慎用。

**生活类比**：管道像**两根进程间的传声筒**（一端说一端听）；FIFO 是**有名字的传声筒**（不相关进程也能用）；消息队列像**带编号的信箱**；信号量像**停车场空位计数器**；共享存储像**两进程共用的白板**（最快，但要自己同步）。

**核心知识点（串联讲解）**
- **管道 `pipe`**：半双工，仅相关进程（共同祖先）。`filedes[0]` 读、`[1]` 写。fork 后关多余端。规则：所有写端关 → 读返 0（EOF）；读端关 → 写产生 `SIGPIPE`（忽略/从 handler 返回则 write 返 -1/`EPIPE`）。`PIPE_BUF` 保证 ≤ 其长的写是原子的。
  - **popen/pclose**：`= fork + exec(sh -c cmd) + 管道 + waitpid` 的封装。`type="r"` 返回可读 `FILE*`（连命令 stdout），`"w"` 可写（连命令 stdin）。用于把数据直接喂给分页器/过滤器。
  - **协同进程**：用两个半双工管道连它的 stdin 和 stdout，先写其输入再读其输出（如 `add2` 求和）。
- **FIFO（命名管道）**：`mkfifo` 建在文件系统，不相关进程可用。open 时 `O_NONBLOCK` 改变阻塞语义（只读立即返；只写无读者则 `ENXIO`）。用途：shell 复制输出流（`tee`）、客户-服务器（众所知 FIFO 收请求，每客户建专用 FIFO 回送）。缺点：客户崩了留 FIFO 在磁盘；服务器要 catch `SIGPIPE`。
- **System V IPC 共性**：标识符（非负整数，创建后递增回绕）+ `key`（`ftok` 由路径名+课题 ID 生成）。`ipc_perm` 权限结构。`msgget`/`semget`/`shmget` 用 `key` + `IPC_CREAT`/`IPC_EXCL` 创建或访问。**三大缺点**：无访问计数（删了残留系统中）、无文件系统名字（需 `ipcs`/`ipcrm` 命令）、无文件描述符（`select`/`poll` 用不了）。
- **消息队列**：`msgget`/`msgsnd`/`msgrcv`/`msgctl`。消息 = 正长整型类型 + 数据，可**非 FIFO** 按 type 取。可靠/流控/面向记录，但书建议新程序别用（速度已不比流管道快，且有上面缺点）。
- **信号量**：计数器，同步共享资源存取。`semget`/`semop`(原子：全做或全不做)/`semctl`。System V 复杂（集合、创建与赋初值分开→非原子、undo 机制）。`SEM_UNDO` 进程退出自动回退调整值。书建议：只锁单一资源用记录锁更简单（退出自动释放）。
- **共享存储**：**最快**（免数据复制）。`shmget`/`shmat`(连接地址空间)/`shmdt`(脱接)/`shmctl`。必须另配信号量/记录锁同步。相关进程也可 `mmap /dev/zero`（MAP_SHARED）或 4.3+BSD `MAP_ANON` 匿名映射。
- **客户机-服务器身份验证难点**：IPC 不经内核标识发送者；靠客户专用 FIFO/队列的权限 + 时间戳近似验证（更好的是第15章传 fd 时内核直接给 uid）。

**关键 API 速查**
- `pipe` / `popen` / `pclose` / `mkfifo`
- `msgget` / `msgsnd` / `msgrcv` / `msgctl`
- `semget` / `semop` / `semctl`
- `shmget` / `shmat` / `shmdt` / `shmctl`

**易错点 & 实战**
- 管道写端全关 → 读返 EOF；读端关 → 写 `SIGPIPE`；多写者要保证原子须 ≤ `PIPE_BUF`。
- 协同进程若用标准 I/O 默认全缓存会死锁（双方都在等对方输出）——需 `setvbuf` 设行缓存，或第19章用伪终端骗它"连着终端"。
- 共享存储要配信号量同步，否则数据竞争。
- Python：`os.pipe`、`subprocess.Popen`（即 popen 封装）、`os.mkfifo`、`multiprocessing.Queue`/`Value`（共享内存+锁）、`mmap`。
- 实战：用 `pipe`+`fork` 实现父子同步（TELL/WAIT）；用 `mkfifo` 做简单客户-服务器；用共享内存 + `Semaphore` 做并发计数器。

**面试考点**
- 管道的两个限制？为什么写已关闭读端的管道会收到 `SIGPIPE`？
- FIFO 与普通管道的区别？FIFO 的客户-服务器模型有什么坑？
- System V IPC 三大缺点？为什么书建议新程序避开消息队列/信号量？
- 消息队列/信号量/共享存储各自适合什么场景？共享存储为什么必须配同步？
- `popen` 的原理？它和 `system` 有何异同？

**代码实战**

第14章 IPC：下面两个独立示例——(1) `pipe`+`fork`+`dup2` 拼出 `ls | wc -l`；(2) System V 共享内存 + 信号量做进程间计数器（不加信号量会丢更新）。

```c
/* ch14_IPC.c (1/2) —— pipe + fork + dup2 实现 "ls | wc -l"
 * 体现: pipe、fork、dup2(重定向)、execl、读端关则写端收 SIGPIPE
 * 编译: cc ch14_pipe.c -o ch14p && ./ch14p
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void) {
    int fd[2];
    pipe(fd);                            // fd[0]=读端, fd[1]=写端
    pid_t pid = fork();
    if (pid == 0) {                      // 子进程 -> wc -l, 从管道读
        dup2(fd[0], STDIN_FILENO);       // 管道读端接到标准输入
        close(fd[1]); close(fd[0]);
        execl("/usr/bin/wc", "wc", "-l", (char*)NULL);
        _exit(127);
    }
    dup2(fd[1], STDOUT_FILENO);          // 父进程 -> ls, 输出灌进管道
    close(fd[0]); close(fd[1]);
    execl("/bin/ls", "ls", (char*)NULL);
    _exit(127);
}
```

```c
/* ch14_IPC.c (2/2) —— System V 共享内存 + 信号量同步
 * 体现: shmget/shmat(共享内存)、semget/semop(信号量互斥)、父子共享
 * 编译: cc ch14_shm.c -o ch14s && ./ch14s
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/shm.h>
#include <sys/sem.h>
#include <sys/wait.h>

union semun { int val; };
struct sembuf P = {0, -1, 0}, V = {0, 1, 0};   // P 取锁 / V 还锁

int main(void) {
    int shmid = shmget(IPC_PRIVATE, 4096, IPC_CREAT | 0600);
    int *p = shmat(shmid, NULL, 0);     // 映射到本进程地址空间
    *p = 0;

    int semid = semget(IPC_PRIVATE, 1, IPC_CREAT | 0600);
    union semun u; u.val = 1; semctl(semid, 0, SETVAL, u);  // 二元信号量初值1

    pid_t pid = fork();
    if (pid == 0) {
        for (int i = 0; i < 100000; i++) { semop(semid, &P, 1); (*p)++; semop(semid, &V, 1); }
        shmdt(p); _exit(0);
    }
    for (int i = 0; i < 100000; i++) { semop(semid, &P, 1); (*p)++; semop(semid, &V, 1); }
    waitpid(pid, NULL, 0);
    printf("期望 200000, 实际 %d (有信号量保护, 不丢)\n", *p);
    shmdt(p); shmctl(shmid, IPC_RMID, NULL); semctl(semid, 0, IPC_RMID);
    return 0;
}
```

**本章串联**：IPC 把第8章（fork/exec/wait）、第9章（会话）、第10章（SIGPIPE/SIGCHLD）全部串起来——`popen` 内部就是 fork+exec+管道，`system` 同理；管道读写端关闭的 EOF/`SIGPIPE` 是信号章节的实例；共享存储的同步用第12章记录锁或信号量。第15章在管道之上加"传文件描述符"和全双工流管道。

---

## 第15章 高级进程间通信

**一句话本质**：高级 IPC——流管道（全双工）、命名流管道，以及最关键的**"在进程间传送打开文件描述符"**能力。用这些可构建健壮的客户机-服务器（每个客户独立连接、服务器用多路转接并发）。

**生活类比**：传送文件描述符像**把"已经开好的文件抽屉的钥匙"直接递给另一个进程**——两进程共享同一个抽屉（同一文件表项），不是复制内容；流管道像**一根双向电话线**（一根顶两根半双工）。

**核心知识点（串联讲解）**
- **流管道 `s_pipe`**：全双工（单根双向）。SVR4 下 `pipe` 本就是流管道；4.3+BSD 用 `socketpair` 实现。可替代"两个半双工管道"，简化协同进程。
- **传送打开文件描述符**：`send_fd`/`recv_fd`（经流管道）。本质：发送方把"指向同一文件表项的指针"交给接收方——两进程**共享同一文件表项**（同位移量，如 fork 后父子）。发送方通常关掉自己的那份，不影响接收方（关闭的是"描述符"，文件表项仍被对方引用）。接收方 fd 编号通常与发送方不同。SVR4 用 `ioctl(I_SENDFD/I_RECVFD)`；BSD 用 `sendmsg`/`recvmsg` 的辅助数据（`cmsghdr`/`SCM_RIGHTS`）。
- **open 服务器（第1版）**：客户 `fork`+`exec` 调用服务器，服务器 `open` 文件后把 fd 传回客户。优点：服务器可做额外权限检查、可设 SUID 获特权、文件内容**不须经 IPC 搬运**。
- **客户机-服务器连接函数**：`serv_listen`/`serv_accept`/`cli_conn`，用命名流管道（SVR4 `connld` 模块 + `fattach` + `I_RECVFD`，每新客户自动建全新连接）或 UNIX 域套接口（BSD `socket`/`bind`/`listen`/`accept`）。服务器用 `select`/`poll` 多路处理所有客户。
- **open 服务器（第2版，精灵）**：一个守护进程服务所有客户，维护 `client` 数组，`loop` 用 `select`（SVR4 也可 `poll`）：`listenfd` 就绪 = 新客户连入（`serv_accept`）；某客户 fd 就绪 = 新请求（`request`）或客户终止（read 返 0 → 清理）。比"每客户 fork"更高效。

**关键 API 速查**
- `s_pipe`（全双工流管道）
- `send_fd` / `recv_fd`（传打开描述符）
- `serv_listen` / `serv_accept` / `cli_conn`
- BSD：`socketpair`；`sendmsg`/`recvmsg` + `SCM_RIGHTS`

**易错点 & 实战**
- 传送 fd 后发送方关掉自己的那份**不影响**接收方（共享文件表项），这正是设计意图；两进程此后对文件位移量的修改互相可见。
- 全双工流管道每端都能读写，注意别在两端同时 read 造成自己跟自己"对话"。
- Python：`socket` 模块支持 `sendmsg`/`recvmsg` 传 fd（较底层）；一般业务直接用 `socket` 或 `multiprocessing` 替代，不必手写传 fd。
- 实战：理解"为什么传 fd 比传文件名好"（免搬运内容、可做权限委托）；用 UNIX 域 socket 实现一个"每客户一连接"的服务端并用 `select` 多路监听。

**面试考点**
- 为什么要在进程间传 fd 而不是传文件名？传 fd 后两进程是什么关系（共享文件表项）？
- 发送方关闭 fd 后，接收方为什么还能继续用？（共享文件表项，引用计数）
- 流管道 vs 普通半双工管道？为什么 SVR4 的 `pipe` 本身就是全双工？
- 精灵 open 服务器相比"每客户 fork 一个"的优势？（省 fork/exec、单一连接点、可并发多路）
- `select`/`poll` 在服务器 `loop` 里怎么区分"新客户"和"老客户的新请求"？

**代码实战**

第15章的"传文件描述符"是全书最巧妙的 IPC：通过 Unix 域 socket 的 `SCM_RIGHTS` 控制消息，把一个"已打开的 fd"从一个进程复制到另一个进程。下面父进程打开日志文件，把 fd 传给子进程，子进程用这个 fd 写同一文件。

```c
/* ch15_高级IPC.c —— UNIX 域 socketpair + SCM_RIGHTS 传文件描述符
 * 体现: socketpair(流管道)、fork、sendmsg/recvmsg + cmsg(传打开的 fd)、
 *       父把"已打开的日志 fd"传给子, 子用它写同一文件
 * 编译: cc ch15_fdpass.c -o ch15 && ./ch15  (然后看 daemon.log)
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/socket.h>

int send_fd(int sock, int fd) {
    struct msghdr msg = {0};
    char buf[1] = {0}; struct iovec io = {buf, 1};
    msg.msg_iov = &io; msg.msg_iovlen = 1;
    char cmsg[CMSG_SPACE(sizeof(int))];
    msg.msg_control = cmsg; msg.msg_controllen = sizeof cmsg;
    struct cmsghdr *c = CMSG_FIRSTHDR(&msg);
    c->cmsg_level = SOL_SOCKET; c->cmsg_type = SCM_RIGHTS;
    c->cmsg_len = CMSG_LEN(sizeof(int));
    *(int*)CMSG_DATA(c) = fd;              // 把 fd 装进控制消息
    return sendmsg(sock, &msg, 0);
}

int recv_fd(int sock) {
    struct msghdr msg = {0};
    char buf[1]; struct iovec io = {buf, 1};
    msg.msg_iov = &io; msg.msg_iovlen = 1;
    char cmsg[CMSG_SPACE(sizeof(int))];
    msg.msg_control = cmsg; msg.msg_controllen = sizeof cmsg;
    recvmsg(sock, &msg, 0);
    struct cmsghdr *c = CMSG_FIRSTHDR(&msg);
    return *(int*)CMSG_DATA(c);            // 取出收到的 fd(在子进程里是新编号)
}

int main(void) {
    int sv[2];
    socketpair(AF_UNIX, SOCK_STREAM, 0, sv);          // 全双工流管道
    int logfd = open("daemon.log", O_WRONLY | O_CREAT | O_APPEND, 0644);

    if (fork() == 0) {                            // 子: 收 fd 并写
        close(sv[0]);
        int fd = recv_fd(sv[1]);
        dprintf(fd, "子进程通过传来的 fd 写日志\n");  // 写的是父打开的同一文件
        close(fd); _exit(0);
    }
    close(sv[1]);                                 // 父: 发 fd 给子
    send_fd(sv[0], logfd);
    wait(NULL);
    close(logfd);
    return 0;
}
```

**本章串联**：本章是 IPC 的"高阶收口"——流管道建立在第14章管道之上，传 fd 依赖第3章文件表项/第8章 fork 语义，服务器多路转接用第12章 `select`/`poll`，身份验证用第9章会话/uid 概念。open 服务器把"权限委托 + 免内容拷贝"发挥到极致，是守护进程（第13章）与网络编程（后续 socket 章节）之间的重要桥梁。

---

## 第16章 数据库函数库

**一句话本质**：本章用约 200 行 C 实现一个迷你数据库函数库（Berkeley DB 风格），核心是用"索引文件 `.idx` + 数据文件 `.dat` + 散列表 + 链表"组织数据，并用第12章的记录锁做多进程并发控制——是前面文件 I/O、记录锁、`readv`/`writev` 的综合实战。

**生活类比**：数据库像**带目录的档案柜**（索引文件=目录卡片，数据文件=档案袋）；记录锁像**柜子的使用权限条**——粗锁=整柜上锁，细锁=只锁某一格抽屉。

**核心知识点（串联讲解）**
- **接口（`db.h`）**：`db_open`/`db_close`、`db_store`（`flag`=INSERT/REPLACE）、`db_fetch`、`db_delete`、`db_rewind`/`db_nextrec`。关键字必须唯一，记录以 NULL 结尾的字符串存储（不含 NULL 的任意字符）。
- **文件结构**：索引文件 = 空闲链表指针 + 散列表（固定 N 条链）+ 索引记录（`chain ptr` + `idx len` + `key` + `dat off` + `dat len`，分号分隔，回车结尾便于 `cat` 查看）；数据文件 = 数据记录。散列冲突用链表法。`db_store` 有四种情形：新增追加到尾 / 重用同尺寸的空闲记录 / 替换但长度变了（删后追加）/ 替换且长度相同（原地重写）。
- **集中式 vs 非集中式**：集中式（一个管理进程经 IPC 存取数据库，可按需控制优先级但慢）；非集中式（各进程自己加锁，避免 IPC 拷贝，本章采用，用记录锁实现并发）。
- **并发控制两档**：
  - 粗锁：对索引文件 0 字节加读/写锁 = 锁整个库。写时其他进程连别的散列链也进不来，并发度最低。
  - 细锁：先锁"某条散列链"（多读单写）+ 空闲链表写锁 + 向文件追加时锁对应区域。并发度高。
  - 直接调 `read`/`readv`/`write`/`writev`（不用标准 I/O），避免别的进程改了数据而本进程还在用 10 分钟前的标准 I/O 缓存。
  - `db_nextrec` 对空闲链表加读锁，返回的是"某一时刻的快照"，不保证遍历顺序。
- **性能（16.8）**：单进程加不加锁差别很小；强制锁比建议锁多约 15% 系统开销；细锁比粗锁并发更好，但进程数 >7 后收益很小（作者都怀疑为细锁多写的代码值不值）。

**关键 API 速查**
- 库接口：`db_open` / `db_store` / `db_fetch` / `db_delete` / `db_rewind` / `db_nextrec`
- 底层：`readv` / `writev`、`fcntl` 记录锁（`readw_lock`/`writew_lock`/`un_lock`）

**易错点 & 实战**
- 两进程同时 `db_open` 建库会互毁数据 → 必须用 `readw_lock`/`writew_lock` 保护初始化（先 fstat 再初始化之间有竞态）。
- 删除记录 = 把索引记录移到空闲链表（类似 FIFO 栈）；重用需"关键字长度 + 数据长度"都匹配，算法较保守。
- `fsync` 没集成进库（习题16.4），崩溃可能丢尾部数据；NFS/RFS 上记录锁可能失效（习题16.7）。
- Python 对照：真要用嵌入式 DB 直接用 `sqlite3`（自带 B 树和锁），不必自己造；但读懂这一章有助于理解任何"两文件 + 锁"的存储引擎（含 MySQL 的某些存储层思路）。

**面试考点**
- 数据库为什么用两个文件（索引+数据）而不放一起？散列表 + 链表解决什么？
- 集中式 vs 非集中式？粗锁 vs 细锁？细锁一定比粗锁快吗？
- 为什么这里不用标准 I/O 而用 `read`/`write`？强制锁比建议锁慢多少？

**代码实战**

第16章用约 200 行 C 实现了一个散列数据库。下面是一个"思想版"迷你数据库：单文件 + 散列表（桶号标注）+ `O_APPEND` 原子追加 + `fcntl` 建议锁（粗锁）。原书用 `.idx`+`.dat` 两个文件、空闲链表、细锁，思路一致。

```c
/* ch16_数据库函数库.c —— 迷你散列数据库(单文件 + 记录锁)
 * 体现: 散列表(桶)+链表思想、read/write 不定长记录、O_APPEND 原子追加、
 *       fcntl 建议锁做并发控制(粗锁=整个文件一把锁)
 * 说明: 原书用 .idx(散列表+空闲链表)+.dat 两文件+细锁; 此简化版只演示核心思想
 * 编译: cc ch16_数据库函数库.c -o ch16 && ./ch16
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

#define BUCKETS 10
int hash(const char *k){ unsigned h=0; while(*k) h=(h*31+(unsigned char)*k++); return h%BUCKETS; }

void wlock(int fd){ struct flock l={F_WRLCK,SEEK_SET,0,0,0}; fcntl(fd,F_SETLKW,&l); }
void rlock(int fd){ struct flock l={F_RDLCK,SEEK_SET,0,0,0}; fcntl(fd,F_SETLKW,&l); }
void ulock(int fd){ struct flock l={F_UNLCK,SEEK_SET,0,0,0}; fcntl(fd,F_SETLK,&l); }

int main(void){
    int fd = open("mydb.dat", O_RDWR|O_CREAT, 0644);

    wlock(fd);                                            // 粗锁: 写前锁整个库
    char rec[256];
    snprintf(rec,sizeof rec,"%d\tname\tkanghua\n", hash("name"));
    lseek(fd,0,SEEK_END); write(fd,rec,strlen(rec));     // 追加一条记录
    snprintf(rec,sizeof rec,"%d\tage\t18\n", hash("age"));
    lseek(fd,0,SEEK_END); write(fd,rec,strlen(rec));
    ulock(fd);

    rlock(fd);                                            // 粗锁: 读前加读锁
    lseek(fd,0,SEEK_SET);
    char buf[1024]; ssize_t n=read(fd,buf,sizeof buf); buf[n>0?n:0]=0;
    char *line=strtok(buf,"\n");
    while(line){
        int b; char k[64],v[64];
        if(sscanf(line,"%d\t%s\t%s",&b,k,v)==3 && strcmp(k,"name")==0)
            printf("fetch name -> %s (落在散列桶 %d)\n", v, b);
        line=strtok(NULL,"\n");
    }
    ulock(fd);
    close(fd);
    return 0;
}
```

**本章串联**：散列表/链表（数据结构基础）、`readv`/`writev`（第12章）、记录锁（第12/14章）、多进程 `fork` 竞争（第8章）。把"文件 I/O + 锁"从概念走到一个能跑的并发存储引擎，是前面知识的完整闭环。

---

## 第17章 与 PostScript 打印机通信

**一句话本质**：写一个和 PostScript 打印机对话的程序（`lprps`）。打印机经 RS-232 串口连主机，你"发一段 PostScript 程序让它执行"的同时还要"收它的状态/错误消息"——全程全双工，所以是 第11章终端 I/O + 第12章非阻塞 I/O 与 `select`/`poll` + 第10章信号 + 第13章守护进程/`syslog` 的大综合。

**生活类比**：打印机像**一个会执行你给的脚本、还会回嘴报错的外语同事**——你发命令（PostScript 程序），它回 `%%[ Error: ... ]%%` 这样的便签；你得一边发一边听，不能发完就走。

**核心知识点（串联讲解）**
- **PostScript 通信本质**：发的是"程序"不是"文件"；解释器执行后通过 `showpage` 出纸、`print` 回字符。错误随时可能返回，必须处理。
- **特殊字符（表17-1/17-2）**：Ctrl-C（中断执行）、Ctrl-D（文件终止 EOF，用于同步）、Ctrl-T（状态查询，回 `%%[ status: idle ]%%`）、Ctrl-S/Ctrl-Q（XOFF/XON 流控）。
- **状态消息格式** `%%[ key:val ]%%`，常见 `Error` / `PrinterError` / `Flushing` / `pagecount`。出错时解释器常再发 `Flushing: ... ignored` 然后丢弃剩余作业。
- **全双工 → 必须 `select`/`poll` 多路**（边发边收），且写要设非阻塞——否则发数据时阻塞、收不到错误 → 死锁。
- **程序 `lprps` 构成**：`main`（可 `-d` 交互或作守护，用 `syslog`）、`tty.c`（终端 I/O：`tcgetattr`/`tcsetattr`/`cfsetispeed`、设非规范+波特率）、非阻塞写 + `select`、`SIGINT`（lprm 删作业时发来）/`SIGALRM`（超时）信号，在 `EINTR` 处检测 `intr_flag`/`alrm_flag`。`send_file` 逐字符 `out_char`；收消息 `proc_input_char` 用状态机解析 `%%[ ... ]%%`。
- **BSD 假脱机**：`printcap` 描述打印机参数（波特率/设备/过滤器 `if`），`lpd` 调过滤程序 `psif` → `lprps` 发送 PostScript；文本文件先经 `textps` 转 PostScript。

**关键 API 速查**
- 终端：`tcgetattr` / `tcsetattr` / `cfsetispeed` / `cfsetospeed`、`tcflush`
- I/O/信号：`fcntl` `O_NONBLOCK`、`select`、`signal_intr`、`openlog` / `syslog`

**易错点 & 实战**
- 写打印机阻塞时若同时来错误消息会死锁 → 写必须非阻塞 + `select` 双向多路；内核会缓存终端输入输出，出错时用 `tcflush` 刷清。
- `select` 被信号（`SIGALRM`/`SIGINT`）中断后不自动重启（`SA_RESTART` 对 `select` 行为依系统），要检查 `EINTR` 重试。
- 收 `%%[ status: waiting ]%%` 要补发 EOF 清除状态；取页码用一段约 10 个操作符的 PostScript 小程序。
- Python 对照：用 `pyserial` 操作串口、`select.select` 做多路，比书里裸 `termios` 简单；"全双工设备要双向 `select`"是通用套路（也适用于串口、套接字）。

**面试考点**
- 为什么和打印机通信要非阻塞 + `select`？PostScript 打印机交互的特殊性在哪？
- `select` 被信号打断怎么办？守护进程为什么用 `syslog` 不用 stderr？
- 状态消息 `%%[ key:val ]%%` 怎么解析才稳？

**代码实战**

第17章本质是"全双工设备 + 非阻塞写 + `select` 读 + 解析 `%%[key:val]%%` 状态流"。下面用管道模拟"打印机回的状态流"，把状态机解析 + `select` 多路这条路数跑通（真实场景把管道换成串口/pty，按第11章设终端）。

```c
/* ch17_打印机.c —— 全双工: 非阻塞读 + select 等 + 解析 %%[key:val]%% 状态
 * 体现: 全双工设备(第11章终端/串口)、O_NONBLOCK、select 双向多路、
 *       字符流状态机解析、SIGINT/SIGALRM 超时(第10章, 此处略)
 * 编译: cc ch17_打印机.c -o ch17 && ./ch17   (用管道模拟"打印机状态流")
 */
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/select.h>

// 状态机: 在字符流里认出 %%[ ... ]%% 包起来的状态消息
void parse(int fd){
    enum {OUT, OPEN, IN} st = OUT;
    char msg[256]; int i = 0; char c;
    while (read(fd, &c, 1) == 1) {
        if      (st==OUT && c=='%') st = OPEN;
        else if (st==OPEN && c=='%'){ st = IN; i = 0; }
        else if (st==IN){
            if (c==']'){ st=OUT; msg[i]=0; printf(">>> 解析到打印机状态: %s\n", msg); }
            else if (i < (int)sizeof msg-1) msg[i++] = c;
        } else st = OUT;
    }
}

int main(void){
    int p[2]; pipe(p);
    const char *s = "hello\r\n%%[ status : idle ]%%\r\n%%[ pagecount: 3 ]%%\r\n";
    write(p[1], s, strlen(s)); close(p[1]);   // 模拟"打印机"回的状态流

    fcntl(p[0], F_SETFL, O_NONBLOCK);         // 非阻塞读(真实: 边发边读, 防死锁)
    fd_set rds; FD_ZERO(&rds); FD_SET(p[0], &rds);
    struct timeval tv = {2, 0};
    if (select(p[0]+1, &rds, NULL, NULL, &tv) > 0)
        parse(p[0]);                          // 用 select 等"打印机有消息"
    close(p[0]);
    return 0;
}
```

**本章串联**：终端 I/O（11）、非阻塞 + `select`（12）、信号 `SIGINT`/`SIGALRM`（10）、守护进程 + `syslog`（13）、字符流状态机解析（与后面第19章 pty 驱动异曲同工）。首次把"全双工 + 非阻塞 + 多路"用到真实外设。

---

## 第18章 调制解调器拨号器

**一句话本质**：建一个"调制解调器拨号服务器"守护进程（`calld`）+ 一个像 `cu`/`tip` 的客户端（`call`）。服务器统一处理所有拨号细节（读 `Systems`/`Devices`/`Dialers` 配置、开锁、拨号），成功后把调制解调器的文件描述符传给客户端（第15章传 fd），客户端只管和远端聊天——是 第15章客户机-服务器 + 传描述符 + 第12章 `poll`/`select` + 第11章终端 + 第10章 `SIGCHLD` 的综合。

**生活类比**：服务器像**前台总机**（你报"拨 host1"，它去插线、拨号、开锁，然后把听筒递给你）；你拿着听筒（文件描述符）直接和对方聊，挂机（关管道）前台就自动解锁。

**核心知识点（串联讲解）**
- **目标（18.3）**：不改源码支持新猫（配置放 `Dialers` 文件）；进程崩溃自动释放锁（服务器在客户端断连时释放）；客户端无需特权（特权只给服务器）；拨号像函数调用一样简单。
- **客户机-服务器模型（图18-1/18-2）**：客户 `cli_conn` 连服务器 → 请求拨号 → 服务器查 `Systems`/`Devices`/`Dialers` → `fork` 子进程实际拨号（15~30 秒）→ 成功 `send_fd` 给客户 → 客户直接读写该 fd；客户关流管道 → 服务器自动释放锁。
- **三个数据文件（Honey DanBer UUCP）**：`Systems`（远程系统名/时间/类型/速率/电话）、`Devices`（设备行/class/dialer）、`Dialers`（各猫的拨号指令，"期望-发送串"）。查找顺序 `Systems` → `Devices` → `Dialers`。
- **服务器设计（18.5）**：父（精灵）管锁 + `serv_listen`/`serv_accept` + 查表 + `fork`；子实际拨号。父用 `select` 多路处理多客户；`SIGCHLD` → `waitpid` 记状态；子 `exit(0)` 成功 / `exit(1)` 失败则父试 `Systems` 下一项。用 `TELL_WAIT` 同步父子（先加锁再 `fork`，避免竞态）。
- **客户端 `call`（18.7）**：单进程用 `poll` 多路（终端 ↔ 调制解调器 fd）；本地终端上方行规程设非规范（raw），远端设规范，使远端特殊字符（EOF/ERASE）生效。支持转义命令：`~.` 断开、`~^Z` 挂起、BREAK（`tcsendbreak`）、`~t take`（取文件）、`~p put`（送文件）。`take` 用 `cat src; echo ˆA` 检测结束，且**批量读缓存**（每次读 57~58 字节而非 1 字节，性能从 16 秒 → 5 秒）。

**关键 API 速查**
- `cli_conn` / `serv_listen` / `serv_accept`、`send_fd`（第15章）
- `fork` / `signal_intr`（`SIGCHLD`）/ `TELL_WAIT`
- `poll` / `select`、`tty_open`（设 `CLOCAL` + 非阻塞）、`tcflush`、`tcsendbreak`

**易错点 & 实战**
- 拨号要 15~30 秒 → 必须 `fork` 子进程做，父才能并发服务其他客户；否则单线程卡死。
- 直接相连设备开终端要设 `CLOCAL`，且以非阻塞打开（向外拨不等地载波），结尾 `clr_fl` 清掉非阻塞。
- `take`/`put` 经远端 shell 执行命令，文件名含分号/特殊字符有注入风险（习题18.5）；`put` 要 `stty -echo` 否则整个文件被回送。
- 单进程 vs 双进程（18.7.2）：早期 `cu`/`tip` 用双进程（无 `select`），但终止/文件传送时进程间通知很麻烦，故本书用单进程 `poll`。
- Python 对照：客户端逻辑用 `pexpect`（封装了 pty + 交互驱动）或 `serial` + `select`；理解"单进程 `poll` 双向全双工"是通用终端程序写法。

**面试考点**
- 为什么拨号要 `fork` 子进程？客户端关管道服务器怎么知道释放锁？
- 单进程 vs 双进程终端程序优劣？`take` 为什么必须批量读缓存？
- 服务器怎么避免"查到未被锁的设备"和"`fork` 后才加锁"之间的竞态（`TELL_WAIT` 的作用）？

**代码实战**

第18章 = 拨号服务器（传 fd）+ `call` 客户端（`poll` 双向全双工）。下面把"服务器把拨到的设备 fd 传给客户端、客户端 `poll` 在终端与设备间转发、关管道即释放"这条主线跑通（用 pty 主设备当"猫"的替身；真实场景开 `/dev/ttyXX` 并跑 Dialers 握手）。

```c
/* ch18_拨号器.c —— 拨号服务器: 用 pty 当"猫", 把主设备 fd 传给客户端, 客户端 poll 多路
 * 体现: 客户机-服务器(第15章)、socketpair 流管道、SCM_RIGHTS 传 fd、
 *       poll 双向全双工、终端行规程(第11章)、断连即释放锁/设备
 * 编译: cc ch18_拨号器.c -o ch18 && ./ch18  (输入会从 pty 从设备回显回来)
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <poll.h>
#include <sys/socket.h>

static int send_fd(int s, int fd){
    struct msghdr m={0}; char b=0; struct iovec io={&b,1};
    m.msg_iov=&io; m.msg_iovlen=1;
    char c[CMSG_SPACE(sizeof(int))];
    m.msg_control=c; m.msg_controllen=sizeof c;
    struct cmsghdr *h=CMSG_FIRSTHDR(&m);
    h->cmsg_level=SOL_SOCKET; h->cmsg_type=SCM_RIGHTS; h->cmsg_len=CMSG_LEN(sizeof(int));
    *(int*)CMSG_DATA(h)=fd; return sendmsg(s,&m,0);
}
static int recv_fd(int s){
    struct msghdr m={0}; char b; struct iovec io={&b,1};
    m.msg_iov=&io; m.msg_iovlen=1;
    char c[CMSG_SPACE(sizeof(int))];
    m.msg_control=c; m.msg_controllen=sizeof c;
    recvmsg(s,&m,0);
    return *(int*)CMSG_DATA(CMSG_FIRSTHDR(&m));
}

int main(void){
    int sv[2]; socketpair(AF_UNIX, SOCK_STREAM, 0, sv);
    // 服务器"拨号": 用 pty 主设备模拟调制解调器(真实场景开 /dev/ttyXX 并跑 Dialers 握手)
    int mfd = posix_openpt(O_RDWR); grantpt(mfd); unlockpt(mfd);
    char *slave = ptsname(mfd);
    int sfd = open(slave, O_RDWR);              // 从设备(模拟远端), 会回显输入

    if (fork()==0){ close(sv[0]); send_fd(sv[1], mfd); _exit(0); }  // 服务器: 传 fd
    close(sv[1]);
    int modem = recv_fd(sv[0]);                 // 客户端拿到"调制解调器"fd
    close(sv[0]);

    struct pollfd fds[2]={{STDIN_FILENO,POLLIN,0},{modem,POLLIN,0}};
    char buf[256];
    for(;;){
        poll(fds,2,-1);
        if(fds[0].revents&POLLIN){ int n=read(STDIN_FILENO,buf,sizeof buf); if(n<=0)break; write(modem,buf,n); }
        if(fds[1].revents&POLLIN){ int n=read(modem,buf,sizeof buf); if(n<=0)break; write(STDOUT_FILENO,buf,n); }
    }
    close(modem); close(sfd);                   // 关管道/设备 -> 服务器自动释放(第18章核心)
    return 0;
}
```

**本章串联**：传文件描述符（15.3）、客户机-服务器连接（15.5）、`select`/`poll`（12）、终端行规程（11）、`SIGCHLD` 安全处理（10）、`fork` 同步 `TELL_WAIT`（10）。是客户机-服务器 + 传 fd 在真实通信设备上的落地。

---

## 第19章 伪终端

**一句话本质**：伪终端（pty）是一对"主/从"虚拟设备：从设备对程序来说就是一个终端（有行规程、能当控制终端），主设备由另一个进程掌控。它让"没有真终端的地方"也能获得终端语义——网络登录（`telnetd`/`rlogind`）、`script`、`expect`、驱动协同进程、看慢程序输出都靠它。是 第9章会话/控制终端 + 第11章 `termios`/`winsize` + 第14/15章协同进程/fd 传递 的集大成。

**生活类比**：伪终端像**给程序配了个"影子键盘显示器"**：程序以为自己在跟真终端说话（回显、行编辑都生效），其实对面是另一个进程在替真用户收发；这个进程可以把"对面"接到网络、文件或脚本上。

**核心知识点（串联讲解）**
- **结构（图19-1/19-2）**：主设备 ↔ 从设备，从设备上有终端行规程。写到主 = 从的输入，反之亦然。没有真硬件，改波特率/奇偶校验等无意义调用被忽略。
- **打开方式**：
  - SVR4：开 `/dev/ptmx`（clone 设备，自动分配未用主设备）→ `grantpt`（改从设备属主/权限，经 setuid 的 `pt_chmod`）→ `unlockpt` → `ptsname`（得 `/dev/pts/N`）→ 开从设备（自动成为控制终端），再压 `ptem`+`ldterm`（+`ttcompat`）流模块。
  - 4.3+BSD：自己从 `/dev/ptyXX` 遍历找第一个未用的主设备，对应从设备 `/dev/ttyXX`；需 setuid root 的 `grantpt` 等价物改权限；用 `ioctl(TIOCSCTTY)` 分配控制终端。
- **`pty_fork`（程序19-3）**：开主从 → `fork` → 子 `setsid`（新会话/新进程组/无控制终端）→ `ptys_open` 使从设备成控制终端（SVR4 自动 / BSD 用 `TIOCSCTTY`）→ 初始化 `termios`+`winsize` → `dup2` 到 0/1/2 → `exec`。父返回主 fd 和子 pid。
- **`pty` 程序**：`pty prog` = 在独立会话里、连着 pty 跑 `prog`。父用两进程模型（`SIGTERM` 互通知），`loop` 把 stdin ↔ 主设备、主设备 ↔ stdout 转发。
- **典型用途**：
  - 网络登录（图19-3）：`telnetd`/`rlogind` 驱动 pty 主，另一端是 TCP/IP，必用 `select`/`poll` 或多进程。
  - `script`：`pty "${SHELL}" | tee typescript`（图19-8），把终端会话录进文件（不含口令，因口令不回显）。
  - 协同进程（图19-5/19-9）：把 pty 当协同进程的输入输出，标准 I/O 自动行缓存，**解决第14章程序14-10 的全缓存死锁**。
  - 慢程序输出观察（图19-6）：`pty slowout < /dev/null > file &`，骗过 stdio 的成块缓存。
- **其他特性（19.7）**：打包模式 `TIOCPKT`（主设备感知从设备状态变化，供 rlogin 用）、远程模式 `TIOCREMOTE`（从设备行规程不处理输入，窗口管理器自己编辑）、窗口大小 `TIOCSWINSZ`（变化 → `SIGWINCH`，第11章）、信号发生 `TIOCSIGNAL`/`TIOCSIG`（主向从进程组发信号）。

**关键 API 速查**
- `posix_openpt` / `grantpt` / `unlockpt` / `ptsname`（SVR4）
- `pty_fork`、`setsid`、`ioctl(TIOCSCTTY)`
- `tcgetattr`、`ioctl(TIOCSWINSZ` / `TIOCPKT` / `TIOCREMOTE)`、`SIGWINCH`

**易错点 & 实战**
- 子进程必须在 `setsid` **之后**才 `ptys_open`，否则从设备无法成为控制终端（若已是进程组组长 `setsid` 语义不对）。
- 交互程序跑在 pty 下要 `-e`（关回显）否则字符被显示两次；协同进程场景尤其要 `-e` 并清 `ONLCR`。
- 孤儿进程组问题（第9章）：`pty cat` 按 Ctrl-Z，`cat` 属另一会话的孤儿组，内核不真停它（POSIX 不送 `SIGTSTP` 或送了立即 `SIGCONT`）；跑作业控制 shell 才正常。
- `pty` 直接驱动交互程序（如 `pty call`）有局限——它只盲目转发，不懂"先等 Connected 再发数据"，这种场景要用带命令语言的 `expect`。
- Python 对照：`pty.openpty()` / `os.forkpty()` 直接拿主从 fd；`pexpect` 底层就是 pty + 驱动循环。读完这章能看懂 SSH / telnet / 终端复用器（tmux）的底层原理。

**面试考点**
- 伪终端解决什么问题？主从设备是什么关系？为什么网络登录需要 pty？
- pty 怎么解决协同进程死锁（对比第14章）？`TIOCPKT` / `SIGWINCH` 干嘛用？
- 子进程为什么 `setsid` 之后再开从设备？`grantpt` 为什么要 setuid root？

**代码实战**

第19章的 `pty_fork` 套路：`posix_openpt` 开主设备 → `fork` → 子进程 `setsid` → 开从设备（成为控制终端）→ `dup2` 到 0/1/2 → `exec` shell；父进程 `select` 在真实终端与 pty 主设备间双向转发。这正是 `script`、`telnetd` 的底层。

```c
/* ch19_伪终端.c —— pty_fork 套路: 开 pty, fork, 子 setsid+控制终端+exec shell
 * 体现: posix_openpt/grantpt/unlockpt/ptsname、fork、setsid、TIOCSCTTY、
 *       终端行规程(第11章)、父进程 select 在 终端 与 pty主 之间转发
 * 编译: cc ch19_伪终端.c -o ch19 && ./ch19  (得到一个连在 pty 上的新 shell)
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <sys/select.h>
#include <sys/ioctl.h>

int main(void){
    int mfd = posix_openpt(O_RDWR);            // 开 pty 主设备(/dev/ptmx, clone 设备)
    grantpt(mfd); unlockpt(mfd);               // 改从设备权限并解锁
    char *slave = ptsname(mfd);                // 从设备名, 如 /dev/pts/3

    if (fork()==0){                            // 子进程
        close(mfd);
        setsid();                              // 新会话(此后才能分配控制终端)
        int sfd = open(slave, O_RDWR);         // 开从设备 -> 成为本进程控制终端
#ifdef TIOCSCTTY
        ioctl(sfd, TIOCSCTTY, 1);              // BSD 需显式设控制终端; SVR4 开从时自动
#endif
        dup2(sfd, STDIN_FILENO); dup2(sfd, STDOUT_FILENO); dup2(sfd, STDERR_FILENO);
        execl("/bin/sh","sh",(char*)NULL);     // 从设备上有完整终端语义
        _exit(127);
    }
    // 父进程: 在 真实终端(stdio) 与 pty 主设备 之间双向转发
    fd_set rds; char buf[256];
    for(;;){
        FD_ZERO(&rds); FD_SET(STDIN_FILENO,&rds); FD_SET(mfd,&rds);
        select(mfd+1, &rds, NULL, NULL, NULL);
        if(FD_ISSET(STDIN_FILENO,&rds)){
            int n=read(STDIN_FILENO,buf,sizeof buf); if(n<=0)break; write(mfd,buf,n);
        }
        if(FD_ISSET(mfd,&rds)){
            int n=read(mfd,buf,sizeof buf); if(n<=0)break; write(STDOUT_FILENO,buf,n);
        }
    }
    close(mfd);
    return 0;
}
```

**本章串联**：会话/控制终端（9）、`termios`/`winsize`/`SIGWINCH`（11）、`select`/`poll`（12）、`SIGCHLD`/`SIGTERM`（10）、协同进程死锁（14）、传 fd（15）。伪终端是"终端语义"在客户机-服务器时代的终极应用，也是全书的收官——把第9~15章几乎所有机制缝在了一起。

<!-- APPEND_CHAPTERS -->
