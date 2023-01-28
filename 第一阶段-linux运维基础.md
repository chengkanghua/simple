1-01、如何用正确的姿势学习IT技术
```
input --> output--> correction 
```
计算机硬件介绍
```
● 输入设备，键盘、鼠标
● 输出设备：屏幕  打印机  音箱  投影仪等
● 主机部分：机箱、机箱内的零件
	cpu  内存 硬盘 主板  显卡 电源  键盘鼠标

计算机单位:
	Bit 位
	Byte 字节  1Byte=8Bits
	kilobyte (KB)  千字节 1kb = 1024Byte 
	Megabyte (MB) 兆字节 1MB = 1024KB
	Gigabyte (GB) 千兆字节 1GB = 1024MB


主板架构
● 北桥 “图形与内存控制器”：负责链接速度较快的CPU、内存条、显卡等
● 南桥“输入/输出控制器”：负责连接速度较慢的硬盘、USB、网卡等
现在的CPU制造工艺越来越先进，集成度越来越高，内存控制器已被集成到CPU里，就连显卡也被收进CPU了（就是我们所说的核显），而PCIE控制器收归南桥管理了，因此北桥芯片组的功能被瓜分了，所以现在的Intel芯片组把北桥取消掉只剩南桥了，而AMD也只有早期的主板还保留着北桥和南桥。


程序：python / golang语言编写的代码文件，存放在磁盘中的静态数据
进程：已经执行的程序，进程数据已经加载到内存中
守护进程：daemon，伴随着主任务的结束就随之结束的程序

Raid级别
raid0  条带
raid1  镜像
raid 5  奇偶校验码
冗余从好到坏：raid1、raid10、raid5、raid0
性能从好到坏：raid0、raid10、raid5、raid1
成本从低到高：raid0、raid5、raid1、raid10
● 单台服务器，很重要，盘不多，系统盘 raid1。
● 数据库/存储服务器，主库 raid10，从库 raid5\ raid0(为了维护成本，raid10)
● web 服务器，如果没有太多数据的话，raid5,raid0(单盘)
● 有多台，监控\应用服务器，raid0,raid5。

Linux运维人员的核心职责
● 网站数据不能丢
● 网站7*24小时运转
● 提升用户体验，访问速度要快
```

1-12、操作系统与计算机
```
操作系统：是一个人与计算机硬件的中介。


Linux  系统各组成部分的贡献人员
Linux 内核	                      GNU 组件(gcc,bash)	                              其他必要应用程序
开发者 Linus Torvalds	项目发起人 Richard Stallman(斯托曼)	BSD Unix和X Windows 以及成千上万的程序员


vmware 网络模式
  NAT 地址转换
  Bridged(桥接模式)
  Host-only(仅主机)

磁盘分区

● 常见网络集群架构中的节点服务器（多个功能一样的服务器，服务器数据有多份）分区方案：
  ○ /boot分区：存放引导程序，centos-6 给200M
  ○ swap：虚拟内存
    ■ 物理内存 < 8G ，swap分配 内存*1.5数量
    ■ 物理内存 > 8G，swap就给8G
  ○ / 根目录，存放所有数据，剩余空间都给根目录（/usr，/home，/var等分区共用/目录，如同c盘下的系统文件夹）
● 数据库角色的服务器，有大量数据需要访问（重要数据单独分区，便于备份和管理）
  ○ /boot ：存放引导程序，CentOS6分配200M，centOS7分配200M
  ○ Swap：虚拟内存
    ■ 物理内存 < 8G ，swap分配 8*1.5数量
    ■ 物理内存 > 8G，swap就给8G
  ○ /：根目录，50-200G，只存放系统相关文件，不存放数据文件
  ○ /data：剩余硬盘空间全部给/data
● 大型门户网站，大型企业分区思路
  ○ /boot:存放引导程序，CentOS6 给 200M，CentOS7 给 200M
  ○ swap:虚拟内存，1.5 倍内存大小
    ■ 工作中:物理内存<8G，SWAP 就 1.5
    ■ 物理内存>8G，SWAP 就 8G
  ○ / 根目录，50-200G，放系统相关文件
  ○ 剩余磁盘空间，保留，由业务需求决定分区
● LVM性能差
● 操作系统自带软RAID不用，性能差、没有冗余，生产环境用硬件raid
* 生产服务器很多不分swap分区

```
1-22、远程连接linux与初识命令行
```
命令提示符
[py@hello ~]$            普通用户py，登陆后
[root@hello ~]#        超级用户root，登录后
root代表当前登录的用户
@ 分隔符
hello 主机名
~  当前的登录的位置，此时是家目录
# 超级用户身份提示符
$ 普通用户身份提示符
```
2-01、Linux命令语法

2-02、Linux目录结构
1.Linux下一切从根开始
2.Linux下面的目录是一个有层次的目录结构
3.在linux中每个目录可以挂载到不同的设备(磁盘)上
4.Linux 下设备不挂载不能使用，不挂载的设备相当于没门没窗户的监狱(进不去出不来)，挂载相当于给设备创造了一个入口(挂载点，一般为目录)

2-03、Linux常用目录含义
```
● /bin：bin是Binary的缩写, 这个目录存放着最经常使用的命令。
● /boot：这里存放的是启动Linux时使用的一些核心文件，包括一些连接文件以及镜像文件。
● /dev ：dev是Device(设备)的缩写, 该目录下存放的是Linux的外部设备，在Linux中访问设备的方式和访问文件的方式是相同的。
● /etc：这个目录用来存放所有的系统管理所需要的配置文件和子目录。
● /home：用户的主目录，在Linux中，每个用户都有一个自己的目录，一般该目录名是以用户的账号命名的。
● /lib：这个目录里存放着系统最基本的动态连接共享库，其作用类似于Windows里的DLL文件。几乎所有的应用程序都需要用到这些共享库。
● /lost+found：这个目录一般情况下是空的，当系统非法关机后，这里就存放了一些文件。
● /media：linux系统会自动识别一些设备，例如U盘、光驱等等，当识别后，linux会把识别的设备挂载到这个目录下。
● /mnt：系统提供该目录是为了让用户临时挂载别的文件系统的，我们可以将光驱挂载在/mnt/上，然后进入该目录就可以查看光驱里的内容了。
● /opt： 这是给主机额外安装软件所摆放的目录。比如你安装一个ORACLE数据库则就可以放到这个目录下。默认是空的。
● /proc：这个目录是一个虚拟的目录，它是系统内存的映射，我们可以通过直接访问这个目录来获取系统信息。 这个目录的内容不在硬盘上而是在内存里，我们也可以直接修改里面的某些文件，比如可以通过下面的命令来屏蔽主机的ping命令，使别人无法ping你的机器：
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
● /root：该目录为系统管理员，也称作超级权限者的用户主目录。
● /sbin：s就是Super User的意思，这里存放的是系统管理员使用的系统管理程序。
● /selinux： 这个目录是Redhat/CentOS所特有的目录，Selinux是一个安全机制，类似于windows的防火墙，但是这套机制比较复杂，这个目录就是存放selinux相关的文件的。
● /srv： 该目录存放一些服务启动之后需要提取的数据。
● /sys：这是linux2.6内核的一个很大的变化。该目录下安装了2.6内核中新出现的一个文件系统 sysfs 。
sysfs文件系统集成了下面3种文件系统的信息：针对进程信息的proc文件系统、针对设备的devfs文件系统以及针对伪终端的devpts文件系统。该文件系统是内核设备树的一个直观反映。当一个内核对象被创建的时候，对应的文件和目录也在内核对象子系统中被创建。
● /tmp：这个目录是用来存放一些临时文件的。
● /usr：这是一个非常重要的目录，用户的很多应用程序和文件都放在这个目录下，类似于windows下的program files目录。
● /usr/bin：系统用户使用的应用程序。
● /usr/sbin：超级用户使用的比较高级的管理程序和系统守护程序。
● /usr/src：内核源代码默认的放置目录。
● /var：这个目录中存放着在不断扩充着的东西，我们习惯将那些经常被修改的目录放在这个目录下。包括各种日志文件。

在linux系统中，有几个目录是比较重要的，平时需要注意不要误删除或者随意更改内部文件。
/etc： 上边也提到了，这个是系统中的配置文件，如果你更改了该目录下的某个文件可能会导致系统不能启动。
/bin, /sbin, /usr/bin, /usr/sbin: 这是系统预设的执行文件的放置目录，比如 ls 就是在/bin/ls 目录下的。
值得提出的是，/bin, /usr/bin 是给系统用户使用的指令（除root外的通用户），而/sbin, /usr/sbin 则是给root使用的指令。
/var： 这是一个非常重要的目录，系统上跑了很多程序，那么每个程序都会有相应的日志产生，而这些日志就被记录到这个目录下，具体在/var/log 目录下，另外mail的预设放置也是在这里。
```
2-05、核心命令ls和cd
```
命令	            对应英文	                              作用
ls	                  list	                                    查看文件夹内容
pwd   	          print work directory	    查看当前所在目录
cd 目录名	   Change directory	              切换文件夹
touch 文件名	touch	如果文件不存在，则创建
mkdir 目录名	Make directory	             创建目录
rm 文件名	   Remove	                              删除指定文件

cd 
  .    当前目录
  ..    上一层目录
  -    前一个工作目录
    ~    当前【用户】所在的家目录
    /            顶级根目录


```
2-06、mkdir命令讲解
```
用法：mkdir [选项]... 目录...
若指定目录不存在则创建目录。
-m, --mode=模式       设置权限模式(类似chmod)，而不是rwxrwxrwx 减umask
-p, --parents         需要时创建目标目录的上层目录，但即使这些目录已存在也不当作错误处理
mkdir {1..3}加花括号创建连续的目录，用..隔开 花括号内可以是连续的数字、连续的字母mkdir {a..e}

mkdir {alex,pyyu,mjj}  创建三个文件夹，逗号隔开
mkdir alex{1..5}    创建连续的目录
mkdir cunzhang longting  创建少量连续目录
```

2-07、绝对相对路径与touch命令
● 绝对路径：由根目录(/)为开始写起的文件名或者目录名称，如/home/oldboy/test.py;
● 相对路径：相对于目前路径的文件名写法。
```
用法：touch [选项]... 文件...
将每个文件的访问时间和修改时间改为当前时间。
不存在的文件将会被创建为空文件，除非使用-c 或-h 选项。
touch {连续数字或字母} 创建多个文件序列
touch {1..10}
touch {a..z}
  -c, --no-create       不创建任何文件
  -t STAMP              使用[[CC]YY]MMDDhhmm[.ss] 格式的时间替代当前时间
  -r, --reference=文件  使用指定文件的时间属性替代当前文件时间
  
  修改文件时间
touch -t 06010808 alex1    #修改alex1文件的时间是 6月1号8点8分
touch -r alex1 alex2        #把alex2的时间改成alex1一样
```

2-08、cp命令
```
用法：cp [选项]... [-T] 源文件 目标文件
　或：cp [选项]... 源文件... 目录
　或：cp [选项]... -t 目录 源文件...
将源文件复制至目标文件，或将多个源文件复制至目标目录。
-r 递归式复制目录，即复制目录下的所有层级的子目录及文件 -p 复制的时候 保持属性不变
-d 复制的时候保持软连接(快捷方式)
-a 等于-pdr
-p                等于--preserve=模式,所有权,时间戳，复制文件时保持源文件的权限、时间属性
-i, --interactive        覆盖前询问提示
----------------------------------------------
复制 > copy > cp
#移动xxx.py到/tmp目录下
cp xxx.py /tmp/
#移动xxx.py顺便改名为chaoge.py
cp xxx.py /tmp/chaoge.py
Linux下面很多命令，一般没有办法直接处理文件夹,因此需要加上（参数） 
cp -r 递归,复制目录以及目录的子孙后代
cp -p 复制文件，同时保持文件属性不变    可以用stat
cp -a 相当于-pdr
#递归复制test文件夹，为test2
cp -r test test2
cp是个好命令，操作文件前，先备份
cp main.py main.py.bak
移动多个文件，放入文件夹c中
cp -r  文件1  文件2  文件夹a   文件夹c
```


2-09、rm删除命令
```
用法：rm [选项]... 文件...
删除 (unlink) 文件。
rm命令就是remove的含义，删除一个或者多个文件，这是Linux系统重要命令
-f, --force           强制删除。忽略不存在的文件，不提示确认
-i                    在删除前需要确认
-I                    在删除超过三个文件或者递归删除前要求确认。
-d, --dir    删除空目录
-r, -R, --recursive   递归删除目录及其内容
-v, --verbose         详细显示进行的步骤
      --help            显示此帮助信息并退出
      --version         显示版本信息并退出
```
2-10、Linux帮助命令
```
man ls
ls --help
help ls(只对bash内置命令)
info ls
```
linux命令行常用快捷键
```
ctrl + c     cancel取消当前操作
ctrl + l    清空屏幕内容
ctrl + d    退出当前用户
ctrl + a     光标移到行首
ctrl + e    光标移到行尾
ctrl + u  删除光标到行首的内容
```


2-11、vim使用
三种模式:
  命令模式（Command mode）
  输入模式（Insert mode）
  底线命令模式（Last line mode）

  

2-12、vim快捷键
2-13、vim交换文件解决办法
vim -r 文件名  #恢复数据
rm -f  xxx.swp #删除隐藏文件 

2-14、重定向符号
```
< 或者<<	标准输入stdin，代码为0
>或>>	标准输出stdout，代码为1
2>或2>>	标准错误输出stderr，代码为2
```

特殊符号
```
*	 匹配任意个字符
?	 匹配一个字符
|	 管道符
&	 后台进程符
&&	逻辑与符号，命令1 && 命令2 ，当命令1执行成功继续执行命令2
||	逻辑或符号，命令1 ||命令2，当命令1执行失败才会执行命令2
#	  注释符
" "	双引号表示字符串，能够识别，``反引号，$符，\ 转义符
' '	单引号表示普通字符串，无特殊含义
$	  变量符 如 $name
\	  转义字符
```


2-15、cat命令讲解
```
cat命令用于查看纯文本文件（常用于内容较少的）， 可以理解为是猫，瞄一眼文件内容

功能	                  说明
查看文件内容	          cat file.txt
多个文件合并	          cat file.txt file2.txt > file3.tx
非交互式编辑或追加内容	   cat >> file.txt << EOF
                      欢迎来到路飞学城
                      EOF
清空文件内容	   cat /dev/null > file.txt 【/dev/null是linux系统的黑洞文件】

用法：cat [选项] [文件]...
将[文件]或标准输入组合输出到标准输出。
清空文件内容,慎用
> 文件名
-A, --show-all           等价于 -vET
-b, --number-nonblank    对非空输出行编号
-e                       等价于 -vE
-E, --show-ends          在每行结束处显示 $
-n, --number             对输出的所有行编号
-s, --squeeze-blank      不输出多行空行
-t                       与 -vT 等价
-T, --show-tabs          将跳格字符显示为 ^I
-u                       (被忽略)
-v, --show-nonprinting   使用 ^ 和 M- 引用，除了 LFD 和 TAB 之外
--help     显示此帮助信息并退出
--version  输出版本信息并退出
如果[文件]缺省，或者[文件]为 - ，则读取标准输入。


tac命令
与cat命令作用相反，反向读取文件内容
```
2-16、其他读取文件内容命令
more  less  head  tail

2-17、cut命令用法
```
cut - 在文件的每一行中提取片断
在每个文件FILE的各行中, 把提取的片断显示在标准输出。
语法
cut 参数  文件
-b         以字节为单位分割
-n         取消分割多字节字符，与-b一起用
-c         以字符为单位
-d         自定义分隔符，默认以tab为分隔符
-f         与-d一起使用，指定显示哪个区域
N       第 N 个 字节, 字符 或 字段, 从 1 计数 起 
N-       从 第 N 个 字节, 字符 或 字段 直至 行尾 
N-M     从 第 N 到 第 M (并包括 第M) 个 字节, 字符 或 字段 
-M       从 第 1 到 第 M (并包括 第M) 个 字节, 字符 或 字段

  #以冒号切割，显示第6-7的区域信息
[root@MiWiFi-srv ~]# cut -d : -f6-7 /etc/passwd |head -5
/root:/bin/bash
/bin:/sbin/nologin
/sbin:/sbin/nologin
/var/adm:/sbin/nologin
/var/spool/lpd:/sbin/nologin

```
2-18、sort排序命令
```
sort命令将输入的文件内容按照规则排序，然后输出结果
用法：sort [选项]... [文件]...
　或：sort [选项]... --files0-from=F
串联排序所有指定文件并将结果写到标准输出。
 -b, --ignore-leading-blanks   忽略前导的空白区域
 -n, --numeric-sort            根据字符串数值比较
 -r, --reverse                 逆序输出排序结果
 -u, --unique          配合-c，严格校验排序；不配合-c，则只输出一次排序结果
 -t, --field-separator=分隔符  使用指定的分隔符代替非空格到空格的转换
 -k, --key=位置1[,位置2]       在位置1 开始一个key，在位置2 终止(默认为行尾)
 
 #sort 是默认以第一个数据来排序，而且默认是以字符串形式来排序,所以由字母 a 开始升序排序
[root@hello tmp]# cat /etc/passwd | sort  
[root@hello tmp]# sort -n sort.txt        #按照数字从大到小排序
[root@hello tmp]# sort -nr sort.txt        #降序排序
[root@hello tmp]# sort -u sort.txt        #去重排序
[root@hello tmp]# sort -t " " -k 2 sort.txt            #指定分隔符，指定序列
10.0.0.15 a
10.0.0.12 e
10.0.0.22 e
10.0.0.54 f
10.0.0.34 q
10.0.0.63 q
10.0.0.3 r
10.0.0.34 r
10.0.0.4 v
10.0.0.44 w
10.0.0.5 x
[root@hello tmp]# cat /etc/passwd| sort -t ":" -k 3     #以分号分割，对第三列排序，以第一位数字排序
#以分号分割，对第一个区域的第2到3个字符排序
[root@hello tmp]# cat /etc/passwd | sort -t ":" -k 1.2,1.3

```

2-19、uniq、wc、tr命令讲解
```
uniq命令可以输出或者忽略文件中的重复行，常与sort排序结合使用
用法：uniq [选项]... [文件]
从输入文件或者标准输入中筛选相邻的匹配行并写入到输出文件或标准输出。
不附加任何选项时匹配行将在首次出现处被合并。
-c, --count           在每行前加上表示相应行目出现次数的前缀编号
-d, --repeated        只输出重复的行
-u, --unique          只显示出现过一次的行,注意了，uniq的只出现过一次，是针对-c统计之后的结果

#测试数据文件
[root@hello tmp]# cat luffy.txt    
10.0.0.1
10.0.0.1
10.0.0.51
10.0.0.51
10.0.0.1
10.0.0.1
10.0.0.51
10.0.0.31
10.0.0.21
10.0.0.2
10.0.0.12
10.0.0.2
10.0.0.5
10.0.0.5
10.0.0.5
10.0.0.5
[root@hello tmp]# uniq luffy.txt            #仅仅在首次出现的时候合并，最好是排序后去重
10.0.0.1
10.0.0.51
10.0.0.1
10.0.0.51
10.0.0.31
10.0.0.21
10.0.0.2
10.0.0.12
10.0.0.2
10.0.0.5
[root@hello tmp]# sort luffy.txt |uniq -c            #排序后去重且显示重复次数
      4 10.0.0.1
      1 10.0.0.12
      2 10.0.0.2
      1 10.0.0.21
      1 10.0.0.31
      4 10.0.0.5
      3 10.0.0.51
[root@hello tmp]# sort luffy.txt |uniq -c  -d            #找出重复的行，且计算重复次数
      4 10.0.0.1
      2 10.0.0.2
      4 10.0.0.5
      3 10.0.0.51
[root@hello tmp]# sort luffy.txt |uniq -c -u        #找到只出现一次的行
      1 10.0.0.12
      1 10.0.0.21
      1 10.0.0.31


wc命令
wc命令用于统计文件的行数、单词、字节数
-c, --bytes打印字节数
-m, --chars  打印字符数 
-l, --lines  打印行数 
-L, --max-line-length  打印最长行的长度
-w, --words 打印单词数
[root@hello tmp]# wc -l luffy.txt        #统计文本有多少行，如同cat -n 看到的行数
21 luffy.txt
#统计单词数量，以空格区分
[root@hello tmp]# echo "alex peiqi  yuchao  mjj  cunzhang" | wc -w
5
[root@hello tmp]# echo "alex" |wc -m        #统计字符数，由于结尾有个$
5
[root@hello tmp]# echo "alex" |cat -E        #证明结尾有个$
alex$
[root@hello tmp]# wc -L alex.qq            #统计最长的行，字符数
9 alex.qq
[root@hello tmp]# who|wc -l        #当前机器有几个登录客户端

tr命令
tr命令从标准输入中替换、缩减或删除字符，将结果写入到标准输出
用法：tr [选项]... SET1 [SET2]
从标准输入中替换、缩减和/或删除字符，并将结果写到标准输出。
字符集1：指定要转换或删除的原字符集。
当执行转换操作时，必须使用参数“字符集2”指定转换的目标字符集。
但执行删除操作时，不需要参数“字符集2”；
字符集2：指定要转换成的目标字符集。
-c或——complerment：取代所有不属于第一字符集的字符；
-d或——delete：删除所有属于第一字符集的字符；
-s或--squeeze-repeats：把连续重复的字符以单独一个字符表示；
-t或--truncate-set1：先删除第一字符集较第二字符集多出的字符。
#将输入字符由小写换为大写：
[root@hello ~]# echo "My name is alex" | tr 'a-z' 'A-Z'
MY NAME IS ALEX
#tr删除字符或数字，只要匹配上属于第一个字符串的字符，都被删掉
[root@hello ~]# echo "My name is alex and i am 30 years old." | tr -d "0-9"
My name is alex and i am  years old.
[root@hello ~]# echo "My name is alex and i am 33456 years old." | tr -d "1234"
My name is alex and i am 56 years old.
#删除字符，所有的数字，以及小写字符
[root@hello ~]# echo "My name is alex and i am 33456 years old." | tr -d "0-9","a-z"

[root@hello tmp]# tr "[a-z]" "[A-Z]" < alex.txt            #全部换成大写
I AM hello CTO.
I AM 30 YEARS OLD.
I LIKE EAT DA XI GUA .
#删除文中出现的换行符、制表符（tab键）
tr -d "\n\t" < alex.txt
#去重连续的字符，tr是挨个匹配" ia" 每一个字符，包括空格去重
[root@hello tmp]# echo "iiiii      am  aaaaalex,iiii like  hot girl" | tr -s " ia"
i am alex,i like hot girl
#-c取反结果，将所有除了'a'以外的全部替换为'A'
[root@hello tmp]# echo 'i am alex' | tr -c 'a' 'A'
AAaAAaAAAA

```

2-20、find命令和xargs精讲
```
find 查找目录和文件，语法：
find 路径 -命令参数 [输出形式]
参数说明：
路径：告诉find在哪儿去找你要的东西，

参数	解释
pathname	要查找的路径
options选项	
-maxdepth	<目录层级>：设置最大目录层级；
-mindepth	<目录层级>：设置最小目录层级；
tests模块	
-atime	按照文件访问access的时间查找，单位是天
-ctime	按照文件的改变change状态来查找文件，单位是天
-mtime	根据文件修改modify时间查找文件【最常用】
-name	按照文件名字查找，支持* ? [] 通配符
-group	按照文件的所属组查找
-perm	按照文件的权限查找
-size n[cwbkMG]	按照文件的大小 为 n 个由后缀决定的数据块。
其中后缀为：
b: 代表 512 位元组的区块（如果用户没有指定后缀，则默认为 b）
c: 表示字节数
k: 表示 kilo bytes （1024字节）
w: 字 （2字节）
M:兆字节（1048576字节）
G: 千兆字节 （1073741824字节）
-type 查找某一类型的文件	b - 块设备文件。
d - 目录。
c - 字符设备文件。
p - 管道文件。
l - 符号链接文件。
f - 普通文件。
s - socket文件
-user	按照文件属主来查找文件。
-path	配合-prune参数排除指定目录
Actions模块	
-prune	使find命令不在指定的目录寻找
-delete	删除找出的文件
-exec 或-ok	对匹配的文件执行相应shell命令
-print	将匹配的结果标准输出
OPERATORS	
!	取反
-a -o	取交集、并集，作用类似&&和\\

根据名字查找
[root@hello tmp]# ls
alex.txt
[root@hello tmp]# find . -name "alex.txt" -delete        #找出名为alex.txt且删除
[root@hello tmp]# ls    #已经找不到
[root@hello tmp]# touch python{1..10}.pid
[root@hello tmp]# ls
python1.pid  python10.pid  python2.pid  python3.pid  python4.pid  python5.pid  python6.pid  python7.pid  python8.pid  python9.pid
[root@hello tmp]#
[root@hello tmp]#
[root@hello tmp]# find . -name "*.pid"        #找出所有的pid
./python1.pid
./python2.pid
....
[root@hello tmp]# find . -name "[0-9]*.pid"        #找到所以以数字开头的pid文件
./123a.pid
./123b.pid
.....

NIX/Linux文件系统每个文件都有三种时间戳：
● 访问时间（-atime/天，-amin/分钟）：用户最近一次访问时间（文件修改了，还未被读取过，则不变）。
● 修改时间（-mtime/天，-mmin/分钟）：文件最后一次修改时间（数据变动）。
● 变化时间（-ctime/天，-cmin/分钟）：文件数据元（例如权限等）最后一次修改时间。

touch -a ：仅更新Access time（同时更新Change为current time）
touch -m：仅更新Modify time（同时更新Change为current time）
touch -c：不创建新文件
touch -t：使用指定的时间更新时间戳（仅更改Access time与Modify time，Change time更新为current time）

● 文件任何数据改变，change变化，无论是元数据变动，或是对文件mv，cp等
● 文件内容被修改时，modify和change更新
● 当change更新后，第一次访问该文件（cat，less等），access time首次会更新，之后则不会

find根据修改时间查找文件
#一天以内，被访问access过的文件
find . -atime -1  
#一天以内，内容变化的文件
find . -mtime -1 
#恰好在7天内被访问过的文件
[root@hello home]# find /  -maxdepth 3  -type f -atime 7
时间说明
● -atime -2 搜索在2天内被访问过的文件
● -atime 2 搜索恰好在2天前被访问过的文件
● -atime +2 超过2天内被访问的文件

#find 反向查找
[root@hello opt]# find . -maxdepth 1  -type d      #在opt目录下 查找最大目录深度为1 文件夹类型的数据
[root@hello opt]# find . -maxdepth 1  ! -type d    # 加上感叹号，后面接条件，代表取除了文件夹以外类型

#根据权限查找
[root@hello opt]# find . -maxdepth 2  -perm 755 -type f  #寻找权限类型是755的文件

#根据文件大小查找
[root@hello opt]# du -h `find . -maxdepth 2 -size +10M`        #找出超过10M大小的文件
14M    ./Python-3.7.3/python
24M    ./Python-3.7.3/libpython3.7m.a
322M    ./s21-centos-vim.tar.gz

#查找文件忽略目录
[root@hello s18tngx]# find . -path "./conf.d" -prune -o -name "*.conf" -print

#根据用户组匹配
[root@hello home]# find / -maxdepth 3 -group yu        #全局搜索深度为3，用户组是yu的文件
/home/yu
/home/yu/.bashrc
/home/yu/.bash_profile
/home/yu/.bash_history
/home/yu/.cache
/home/yu/.bash_logout
/home/yu/.config

#使用 -exec 或者-ok再次处理
#找出以.txt结尾的文件后执行删除动作且确认
[root@hello opt]# find /opt/luffy_boy  -type f -name "*.txt" -ok  rm  {}  \;
备注
-exec 跟着shell命令，结尾必须以;分号结束，考虑系统差异，加上转义符\;
{}作用是替代find查阅到的结果
{}前后得有空格

#找到目录中所有的.txt文件，且将查询结果写入到all.txt文件中
[root@hello opt]# find ./mydj2/ -type f -name "*.txt" -exec cat {} \; > all.txt
#把30天以前的日志，移动到old文件夹中
find . -type f -mtime +30 -name "*.log" -exec cp {} old \;

xargs 又称管道命令，构造参数等。
是给命令传递参数的一个过滤器,也是组合多个命令的一个工具它把一个数据流分割为一些足够小的块,以方便过滤器和命令进行处理 。
简单的说就是把其他命令的给它的数据，传递给它后面的命令作为参数
-d 为输入指定一个定制的分割符，默认分隔符是空格
-i 用 {} 代替 传递的数据
-I string 用string来代替传递的数据-n[数字] 设置每次传递几行数据
-n 选项限制单个命令行的参数个数
-t 显示执行详情
-p 交互模式
-P n 允许的最大线程数量为n
-s[大小] 设置传递参数的最大字节数(小于131072字节)
-x 大于 -s 设置的最大长度结束 xargs命令执行
-0，--null项用null分隔，而不是空白，禁用引号和反斜杠处理

#多行变单行
[root@luffycity tmp]# cat mjj.txt
1 2 3 4
5 6 7 8
9 10
[root@luffycity tmp]# xargs < mjj.txt
1 2 3 4 5 6 7 8 9 10

-n参数限制每行输出个数
[root@luffycity tmp]# xargs -n 3 < mjj.txt        #每行最多输出3个
1 2 3
4 5 6
7 8 9
10

#自定义分隔符 -d参数
[root@luffycity tmp]# echo "alex,alex,alex,alex,alex," |xargs -d ","
alex alex alex alex alex
#定义分隔符后，限制每行参数个数
[root@luffycity tmp]# echo "alex,alex,alex,alex,alex," |xargs -d "," -n 2
alex alex
alex alex
alex

-i参数的用法，用{}替换传递的数据
-I 参数用法，用string代替数据
#找到当前目录所有的.txt文件，然后拷贝到其他目录下
[root@luffycity tmp]# find . -name "*.txt" |xargs -i  cp {} heihei/
[root@luffycity tmp]# find . -name "*.txt" |xargs -I data cp data  heihei/
#找到当前目录下所有txt文件，然后删除
[root@luffycity tmp]# find . -name "*.txt" |xargs -i rm -rf {}

重点
xargs识别字符串的标识是空格或是换行符，因此如果遇见文件名有空格或是换行符，xargs就会识别为两个字符串，就会报错
● -print0在find中表示每一个结果之后加一个NULL字符，而不是换行符（find默认在结果后加上\n，因此结果是换行输出的）
● Xargs -0 表示xargs用NULL作为分隔符

#修改find的输出结果，-print0可以改结尾为null
[root@luffycity tmp]# find . -name "*.txt" -print
./hello luffycity.txt
[root@luffycity tmp]# find . -name "*.txt" -print0
./hello luffycity.txt[root@luffycity tmp]#
#修改xargs，理解默认分隔符是NULL
find . -name "*.txt" -print0 |xargs -0 rm

```


2-21、文件属性介绍
```
文件或目录属性主要包括：
● 索引节点，inode
● 文件类型
● 文件权限
● 硬链接个数
● 归属的用户和用户组
● 最新修改时间

ls -lhi  /opt

文件类型
格式	类型
ls -l看第一个字符	
-	普通文件regular file，（二进制，图片，日志，txt等）
d	文件夹directory
b	块设备文件，/dev/sda1，硬盘，光驱
c	设备文件，终端/dev/tty1,网络串口文件
s	套接字文件，进程间通信（socket）文件
p	管道文件pipe
l	链接文件,link类型，快捷方式

file 命令   显示文件的类型
which 命令  查找PATH环境变量中的文件，linux内置命令不在path中
whereis 命令  whereis命令用来定位指令的二进制程序、源代码文件和man手册页等相关文件的路径。

```
2-22、tar、gzip、zip命令
```
语法：
tar(选项)(参数)
-A或--catenate：新增文件到以存在的备份文件；
-B：设置区块大小；
-c或--create：建立新的备份文件；
-C <目录>：这个选项用在解压缩，若要在特定目录解压缩，可以使用这个选项。
-d：记录文件的差别；
-x或--extract或--get：从备份文件中还原文件；
-t或--list：列出备份文件的内容；
-z或--gzip或--ungzip：通过gzip指令处理备份文件；
-Z或--compress或--uncompress：通过compress指令处理备份文件；
-f<备份文件>或--file=<备份文件>：指定备份文件；
-v或--verbose：显示指令执行过程；
-r：添加文件到已经压缩的文件；
-u：添加改变了和现有的文件到已经存在的压缩文件；
-j：支持bzip2解压文件；
-v：显示操作过程；
-l：文件系统边界设置；
-k：保留原有文件不覆盖；
-m：保留文件不被覆盖；
-w：确认压缩文件的正确性；
-p或--same-permissions：用原来的文件权限还原文件；
-P或--absolute-names：文件名使用绝对名称，不移除文件名称前的“/”号；不建议使用
-N <日期格式> 或 --newer=<日期时间>：只将较指定日期更新的文件保存到备份文件里；
--exclude=<范本样式>：排除符合范本样式的文件。
-h, --dereference跟踪符号链接；将它们所指向的文件归档并输出

打包后且用gzip命令压缩，节省磁盘空间
[alex@luffycity tmp]$ tar -zcvf alltmp.tar ./*

注意
● f参数必须写在最后，后面紧跟压缩文件名
● tar命令仅打包，习惯用.tar作为后缀
● tar命令加上z参数，文件以.tar.gz或.tgz表示

列出tar包内文件
tar -ztvf alltmp2.tar.gz
#解开tar包
tar -xf alltmp.tar
查出tar的压缩包
tar -zxvf ../alltmp2.tar.gz ./

#指定目录解包
tar -xf alltmp.tar -C /opt/data/

#打包链接文件
-h参数能够保证，打包的不仅仅是个快捷方式，而是找到源文件


gzip命令
要说tar命令是个纸箱子用于打包，gzip命令就是压缩机器
gzip通过压缩算法lempel-ziv 算法(lz77) 将文件压缩为较小文件，节省60%以上的存储空间，以及网络传输速率
gzip(选项)(参数)
-a或——ascii：使用ASCII文字模式；
-c或--stdout或--to-stdout 　把解压后的文件输出到标准输出设备。 
-d或--decompress或----uncompress：解开压缩文件；
-f或——force：强行压缩文件。不理会文件名称或硬连接是否存在以及该文件是否为符号连接；
-h或——help：在线帮助；
-l或——list：列出压缩文件的相关信息；
-L或——license：显示版本与版权信息；
-n或--no-name：压缩文件时，不保存原来的文件名称及时间戳记；
-N或——name：压缩文件时，保存原来的文件名称及时间戳记；
-q或——quiet：不显示警告信息；
-r或——recursive：递归处理，将指定目录下的所有文件及子目录一并处理；
-S或<压缩字尾字符串>或----suffix<压缩字尾字符串>：更改压缩字尾字符串；
-t或——test：测试压缩文件是否正确无误；
-v或——verbose：显示指令执行过程；
-V或——version：显示版本信息；
-<压缩效率>：压缩效率是一个介于1~9的数值，预设值为“6”，指定愈大的数值，压缩效率就会愈高；
--best：此参数的效果和指定“-9”参数相同；
--fast：此参数的效果和指定“-1”参数相同。

#压缩目录中每一个log文件为.gz,文件夹无法压缩，必须先tar打包
gzip *.log           #gzip压缩，解压都会删除源文件
gzip -l *.gz         #不解压显示压缩文件内信息，以及压缩率
gzip -dv *.gz        #解压缩且显示过程
gzip -c  alltmp.tar > alltmp.tar.gz # 压缩保留源文件

gzip套件提供了许多方便的工具命令，可以直接操作压缩文件内容
● zcat，直接读取压缩文件内容zcat hehe.txt.gz
● zgrep
● zless
● zdiff

zip命令
zip 命令：是一个应用广泛的跨平台的压缩工具，压缩文件的后缀为 zip文件，还可以压缩文件夹
语法：
zip 压缩文件名  要压缩的内容
-A 自动解压文件
-c 给压缩文件加注释
-d 删除文件
-F 修复损坏文件
-k 兼容 DOS
-m 压缩完毕后，删除源文件
-q 运行时不显示信息处理信息
-r 处理指定目录和指定目录下的使用子目录
-v 显示信息的处理信息
-x “文件列表” 压缩时排除文件列表中指定的文件
-y 保留符号链接
-b<目录> 指定压缩到的目录
-i<格式> 匹配格式进行压缩
-L 显示版权信息
-t<日期> 指定压缩文件的日期
-<压缩率> 指定压缩率
最后更新 2018-03-08 19:33:4

#压缩当前目录下所有内容为alltmp.zip文件
[root@luffycity tmp]# zip alltmp.zip ./*
#压缩多个文件夹
[root@luffycity tmp]# zip -r data.zip ./data ./data2

unzip 解压
-l：显示压缩文件内所包含的文件；
-d<目录> 指定文件解压缩后所要存储的目录。
#查看压缩文件内容
[root@luffycity tmp]# unzip -l data.zip
#解压缩zip文件
[root@luffycity tmp]# unzip data.zip


```

3-01、用户管理一
3-02、用户管理二
3-03、文件权限管理一
3-04、文件权限与数字转化
3-05、文件权限与umask
```
mask 命令用来限制新文件权限的掩码。
也称之为遮罩码，防止文件、文件夹创建的时候，权限过大

#1 文件默认权限计算
文件默认最大权限666 
	假定umask值为022 （所有位位偶数）
		666-022=644
	假定umask值为045 （其他用户组位为奇数）
		666-045=621 (奇数位加1) + 001=622（真是文件权限）
2.目录默认权限计算（umask没有奇偶之分）
创建目录默认最大权限777  umask值022
	777-022=755
```
3-07、Linux通配符
```
常见通配符
*
?

[abcd]
[a-z]
[!abcd]
[^abcd]

符号	作用
[[:upper:]]	所有大写字母
[[:lower:]]	所有小写字母
[[:alpha:]]	所有字母
[[:digit:]]	所有数字
[[:alnum:]]	所有的字母和数字
[[:space:]]	所有的空白字符
[[:punct:]]	所有标点符号


路径相关
~    当前登录用户家目录
-    上一次工作路径
.    当前工作路径,或隐藏文件
..   上一级目录

特殊引号
单引号 ''	所见即所得，强引用，单引号中内容会原样输出
双引号 ""	弱引用，能够识别各种特殊符号、变量、转义符等，解析后再输出结果
没有引号	一般连续字符串、数字、路径可以省略双引号，遇见特殊字符，空格、变量等，必须加上双引号
反引号 ``	常用于引用命令结果，同于$(命令)


程序的数据流：
● 输入流：<---标准输入 （stdin），键盘
● 输出流：-->标准输出（stdout），显示器，终端
程序启动时默认打开三个I/O设备文件：
● 标准输入文件stdin，文件描述符0
● 标准输出文件stdout，文件描述符1
● 标准错误输出文件stderr，文件描述符2

符号	特殊符号	简介
标准输入stdin	代码为0，配合< 或<<	数据流从右向左 👈
标准输出stdout	代码1，配合>或>>	数据从左向右👉
标准错误stderr	代码2，配合>或>>	数据从左向右👉
		
重定向符号		数据流是箭头方向
标准输入重定向	0< 或 <	数据一般从文件流向处理命令
追加输入重定向	0<<或<<	数据一般从文件流向处理命令
标准输出重定向	1>或>	正常输出重定向给文件，默认覆盖
标准输出追加重定向	1>>或>>	内容追加重定向到文件底部，追加
标准错误输出重定向	2>	讲标准错误内容重定向到文件，默认覆盖
标准错误输出追加重定向	2>>	标准错误内容追加到文件底部

其他特殊符号
符号	解释
;	分号，命令分隔符或是结束符
#	1.文件中注释的内容 2.root身份提示符
|	管道符，传递命令结果给下一个命令
$	1.$变量，取出变量的值 2.普通用户身份提示符
\	转义符，将特殊含义的字符还原成普通字符
{}	1.生成序列 2.引用变量作为变量与普通字符的分割

逻辑操作符
命令	解释
&&	前一个命令成功，再执行下一个命令
||	前一个命令失败了，再执行下一个命令
!	1.在bash中取反 2.在vim中强制性 3.历史命令中 !ls找出最近一次以ls开头的命令

bash
alias,unalias

history
!行号
!! 上一次的命令

ctrl + a  移动到行首
ctrl + e  移动到行尾
ctrl + u  删除光标之前的字符
ctrl + k  删除光标之后的字符
ctrl + l  清空屏幕终端内容，同于clear

tab键
补全
    $PATH中存在的命令
    
    
基本正则表达式bre集合
符号	作用
^	尖角号，用于模式的最左侧，如 "^oldboy"，匹配以oldboy单词开头的行
$	美元符，用于模式的最右侧，如"oldboy$"，表示以oldboy单词结尾的行
^$	组合符，表示空行
.	匹配任意一个且只有一个字符，不能匹配空行
\	转义字符，让特殊含义的字符，现出原形，还原本意，例如\.
代表小数点
*	匹配前一个字符（连续出现）0次或1次以上 ，重复0次代表空，即匹配所有内容
.*	组合符，匹配任意长度的任意字符
^.*	组合符，匹配任意多个字符开头的内容
.*$	组合符，匹配以任意多个字符结尾的内容
[abc]	匹配[]集合内的任意一个字符，a或b或c，可以写[a-c]
[^abc]	匹配除了^后面的任意字符，a或b或c，^表示对[abc]的取反
<pattern>	匹配完整的内容
<或>	定位单词的左侧，和右侧，如<chao>
可以找出"The chao ge"，缺找不出"yuchao"

扩展正则表达式ERE集合
字符	作用
+	匹配前一个字符1次或多次，前面字符至少出现1次
[:/]+	匹配括号内的":"或者"/"字符1次或多次
?	匹配前一个字符0次或1次，前面字符可有可无
竖线	表示或者，同时过滤多个字符串
()	分组过滤，被括起来的内容表示一个整体
	
a{n,m}	匹配前一个字符最少n次，最多m次
a{n,}	匹配前一个字符最少n次
a{n}	匹配前一个字符正好n次
a{,m}	匹配前一个字符最多m次


```

