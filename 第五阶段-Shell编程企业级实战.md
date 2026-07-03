第五阶段：Shell编程企业级实战

## 为什么需要学习Shell编程

shell时linux底层核心
linux运维工作常用工具
自动化运维必备基础工具

## 学好shell编程所需linux基础

熟练使用vim
熟悉使用Linux常用命令
熟练使用三剑客及正则表达式

## 什么是shell?

Shell 是用户和 Linux 内核之间的命令解释器；

## 什么是shell脚本?

Shell 脚本就是把一系列 Linux 命令、逻辑写在文件里批量自动执行。

## 主流 Shell 核心对比表



| Shell      | 兼容性                | 特点                 | 典型使用场景                    |
| :--------- | :-------------------- | :------------------- | :------------------------------ |
| sh(Bourne) | POSIX 标准            | 极简、跨平台         | 系统开机脚本、通用兼容脚本      |
| bash       | 完全兼容 sh           | 功能最全，Linux 默认 | 绝大多数 Shell 脚本、服务器交互 |
| dash       | POSIX 精简            | 速度快、资源占用小   | Ubuntu 系统底层启动脚本         |
| tcsh/csh   | C 语言风格，不兼容 sh | 老旧 Unix 遗留       | 几乎淘汰                        |
| zsh        | 兼容 bash，扩展极强   | 高颜值、智能补全     | 个人开发、macOS 默认            |

## 面试高频总结

1. 写可移植脚本用 `#!/bin/sh`（遵循 POSIX）；
2. Linux 日常脚本、运维自动化统一用 `#!/bin/bash`；
3. Ubuntu 系统脚本启动快靠 `dash`；
4. 个人开发美化终端优先 `zsh+oh-my-zsh`。

## shell脚本在linux运维工作中地位

### 1. 自动化重复工作，解放运维双手（最核心价值）

日常大量重复操作：批量创建用户、日志清理、备份数据库、部署服务、解压打包、巡检服务器，全部可以写成脚本一键执行，避免人工操作失误、重复加班。

### 2. 服务器日常巡检必备工具

编写巡检脚本，自动采集：CPU、内存、磁盘、网卡、端口、进程、磁盘使用率、服务状态，异常自动输出告警，替代人工一台台登录查看，大规模集群必备。

### 3. 服务自动化部署、发布、扩容

单机 / 批量部署 Nginx、MySQL、Java 服务，实现环境初始化、依赖安装、配置修改、启停服务，结合 `scp/rsync` 实现多机器批量发布。

### 4. 结合定时任务 crontab 实现无人值守运维

数据库定时备份、日志定时轮转清理、监控定时巡检、业务定时数据统计，脚本 + crontab 是线上最经典的定时运维方案。

### 5. 监控告警的脚本载体

结合 Zabbix/Prometheus 自定义监控项，通过 Shell 脚本采集业务指标、自定义端口、接口可用性，异常触发短信 / 邮件告警。

### 6. 批量运维集群机器

配合 `sshpass`、`ansible`，Shell 脚本可以批量在上百台服务器执行命令、推送文件、升级配置，是集群运维的基础能力。

### 7. 运维入门必备编程语言，衔接高级自动化

Shell 是运维第一道自动化门槛：

- 简单场景用 Shell 足够，开发快、上手简单、不需要额外运行环境，所有 Linux 机器原生支持；
- 复杂场景再过渡到 Python，但日常轻量自动化优先 Shell。

### 8. 故障应急处理

编写故障自动处理脚本：磁盘满自动清理、异常进程自动重启、服务宕机自动拉起，缩短故障处理时长。

## 脚本的建立

 一、脚本首行规范

脚本第一行必须指定解释器：`#!/bin/bash` 或 `#!/bin/sh`，该行限制 255 字符内，用于声明用哪个 Shell 程序解析脚本。

 二、bash 与 sh 区别

bash 兼容 sh 语法，还集成 csh、ksh 特性，绝大多数 bash 脚本可直接在 sh 中运行；CentOS/RHEL 系统默认 Shell 为 bash。

 三、注意事项

1. 不写解释器声明时，脚本会使用系统默认 bash 执行；
2. 若需要更换解释器，必须在首行明确指定，否则执行结果会异常；
3. 规范写法：所有脚本务必开头声明解释器。

四、脚本注释

`#` 开头为单行注释；也可使用语法实现多行注释，仅对代码做说明，不会被解释执行。



## Shell 编程设计思想

1. 粘合型脚本语言不是用来独立开发大型软件，核心作用是调用 Linux 系统现有命令、工具，把零散命令组合串联，实现任务自动化，属于系统工具的 “粘合剂”。
2. 面向过程、命令驱动自上而下顺序执行，依靠顺序、分支、循环、函数完成业务逻辑，没有面向对象、类、继承等特性。
3. 解释执行、无需编译写完脚本直接运行，不需要提前编译成二进制文件，由 bash 解释器逐行解析执行，开发调试效率高。
4. 默认全局作用域为主变量默认全局，函数内需要手动用local定义局部变量，设计偏向简单易用，弱化复杂的语法约束。
5. 兼容 Unix 管道、重定向生态深度依托管道|、输入输出重定向，实现命令之间数据流转，充分复用系统现有工具能力。

## Shell（Bash）语言特点

1. **语法简单、上手快**，语法规则少，运维人员可以快速编写自动化脚本。
2. **跨服务器通用**，所有 Linux、Unix 类系统默认自带 bash 环境，无需额外安装运行依赖。
3. **弱类型语言**，默认所有变量都按字符串存储，不会强制校验数据类型。
4. **丰富内置变量、位置参数**，天然支持脚本传参、进程状态获取，非常适合运维巡检、批量任务。
5. **原生支持数组、关联数组**，可以处理一组结构化数据。
6. **擅长文本处理**，结合 grep、sed、awk 等三剑客，日志分析、数据过滤能力极强。
7. **不适合海量浮点运算、高并发复杂业务**，只适合轻量级自动化场景。



## shell 支持的运算

### 1. 算术运算符（整数）

1. 四则：`+ - * / %`
2. 自增自减：`i++  ++i  i--  --i`
3. 位运算：`& | ^ << >>` 与、或、异或、左移、右移
4. 逻辑运算：`&& || !`
5. 比较：`> < >= <= == !=`

示例：

```bash
a=$((1<<2))    # 左移 1*4=4
b=$((5&3))     # 按位与
```

### 2. 浮点 / 小数运算（依赖 bc）

Shell 本身没有浮点运算能力，借助 `bc` 工具实现：

```bash
echo "scale=2;10/3" | bc
```

### 3. 其他运算场景

- 字符串运算：截取、替换、长度、匹配
- 数组运算：遍历、下标取值
- 逻辑布尔运算：`if` 判断、条件表达式



## Shell 脚本四种执行方式

1. **bash/sh 脚本名**

   无需脚本执行权限，会手动指定解释器运行；脚本未写 Shebang 时推荐用该方式。

2. **./ 脚本名 / 绝对路径执行**

   需要先用`chmod +x 脚本名`赋予执行权限，依赖脚本首行`#!`指定的解释器运行。

3. **source 脚本名 或。脚本名**

   在当前 Shell 进程内执行脚本，脚本内变量、函数会直接作用于当前终端环境。

4. **sh < 脚本名 或 cat 脚本名 | sh**

   通过标准输入将脚本内容交给解释器执行，不需要脚本具备执行权限。

## 脚本例子  父shell 子shell

```bash
cat <<EOF > test.sh
user=`whoami`
EOF
chmod +x test.sh
sh test.sh  #开启子shell执行
echo $user  #当前环境没有user变量

source ./test.sh  #在当前shell执行 和.文件名.sh类似
echo $user


写法	           执行方式	            是否新建子Shel $0 值	      权限要求
./test.sh	     执行可执行文件	      是	       ./test.sh	需要执行权限
. ./test.sh	     内置点命令 (source)	    否	    -bash	     仅需读权限
source ./test.sh  source 内置命令	    否	     -bash	      仅需读权限

. 是source的简写

```

## 一、Shell 脚本编写 7 条规范

1. 首行通过 `#!/bin/bash` 指定解释器
2. 脚本开头注释写明作者、日期、功能、版权信息
3. 脚本后缀统一使用 `.sh`
4. 脚本存放固定目录（如 `/server/scripts/`）
5. 脚本代码、注释尽量不使用中文，避免编码乱码
6. `""`、`''`、`()`、`[]` 等成对符号先一次性写完，再填充内容
7. `for`、`while`、`if` 等循环 / 判断框架先整体写完，再填充内部业务逻辑

规范示例脚本（`/server/scripts/check_disk.sh`）

```bash
#!/bin/bash
# Author: test
# Date: 2026-07-01
# Function: Check disk usage and alert when over 80%
# Copyright: All Rights Reserved

# 获取根分区使用率
disk_used=$(df -h / | grep -v Filesystem | awk '{print $5}' | sed 's/%//')

# 判断磁盘是否超过阈值
if [ ${disk_used} -ge 80 ];then
    echo "Warning: Disk usage is ${disk_used}%, please clean up files quickly"
else
    echo "Disk usage normal: ${disk_used}%"
fi

------------------------------------------------
# 1.进入固定目录
mkdir -p /server/scripts
cd /server/scripts

# 2.创建并编写脚本
vim check_disk.sh

# 3.赋予执行权限
chmod +x check_disk.sh

# 4.执行脚本
./check_disk.sh


```



范例2_3：写一个包含命令、变量和流程控制语句的清除/var/log下messages日志文件的Shell脚本。

```bash
#!/bin/bash
LOG_DIR=/var/log
ROOT_UID=0 
#第一关，必须是root才能执行脚本，否则给出友好提示并终止脚本运行。
if [ "$UID" -ne "$ROOT_UID" ] 
then
    echo "Must be root to run this script." 
    exit 1
fi
#第二关，成功切换目录（cd /var/log），否则给出友好提示并终止脚本运行。
cd $LOG_DIR || {
echo "Cannot change to necessary directory."
exit 1
}
#第三关，清理日志（cat /dev/null > messages），清理成功，给出正确提示。
cat /dev/null>messages && {
echo "Logs cleaned up."
exit 0
}
#第四关，通关或失败，给出相应提示（echo输出）。
echo "Logs cleaned up fail."
exit 1
```

范例2_3：写一个包含命令、变量和流程控制语句的清除/var/log下messages日志文件的Shell脚本。

```bash
#!/bin/bash
#清除日志脚本, 版本 2
LOG_DIR=/var/log
ROOT_UID=0     #<==$UID为0的用户,即root用户
#脚本需要使用root用户来运行，因此，对当前用户进行判断，不合要求的给出友好提示，并终止程序运行。
if [ "$UID" -ne "$ROOT_UID" ] #<==如果当前用户不是root，不允许执行脚本。
then
    echo "Must be root to run this script." #<==给出提示后退出。
    exit 1 #<==退出脚本。
fi
#如果切换到指定目录不成功，给出提示，并终止程序运行。
cd $LOG_DIR || {
echo "Cannot change to necessary directory."
exit 1
}
#经过上述两个判断后，此处的用户权限和路径就应该是对的了，只有清空成功，才打印成功提示。
cat /dev/null>messages && {
echo "Logs cleaned up."
   exit 0  #退出之前返回0表示成功. 返回1表示失败。
}
echo "Logs cleaned up fail."
  exit 1
```

对于范例2_3的脚本可以分成如下几关来设计：
第一关，必须是root才能执行脚本，否则给出友好提示并终止脚本运行。
第二关，成功切换目录（cd /var/log），否则给出友好提示并终止脚本运行。
第三关，清理日志（cat /dev/null > messages），清理成功，给出正确提示。
第四关，通关或失败，给出相应提示（echo输出）。

## Shell脚本单行和多行注释

方法1 行开头加 #
方法2

```bash
[root@web01 ~]# cat eric.sh
#!/bin/bash
:<<EOF
echo "I am eric"
echo "I am eric"
echo "I am eric"
EOF #<==顶格写，和老男孩老师讲的cat命令追加多行文本是一个原理。
echo "I am eric"
[root@web01 ~]# sh eric.sh 
I am eric
```

## 变量

Shell 属于**弱类型、动态类型语言**，默认所有变量统一按字符串存储，赋值什么格式就怎么解析

### declare 命令

一、作用

`declare` 用于**声明变量类型、设置变量属性**，默认 Shell 所有变量都是字符串，用 declare 可以指定整数、数组、只读、环境变量等。

语法：`declare [参数] 变量名=值`

二、常用参数  `-i`整型、`-r`只读、`-x`环境变量、`-a`普通数组、`-A`关联数组。

```bash
# -i：声明整型变量（只能存数字，支持直接加减乘除运算）
declare -i num=10
num=num+20
echo $num  # 输出30，不用$(( ))也能运算

# -r：声明只读变量，等价于readonly，不可修改、不能 unset 删除
declare -r VERSION="1.0"

# -x：把变量导出为环境变量，等价于export
declare -x PATH
declare -x NAME="test"

# -a：声明普通索引数组
declare -a arr=("java" "python" "shell")

declare -p arr
echo $arr[0]
echo $arr[2]

# -A：声明关联数组（字典），可以用字符串当索引（运维常用）
declare -A info
info["name"]="zhangsan"
info["age"]=20

declare -A info=([name]="zhangsan" [age]=20 [ip]="192.168.1.100")

# -f：查看已定义的所有函数
declare -f
# -F：只查看函数名，不显示函数代码

不加任何参数直接执行declare，会列出当前所有已定义变量、函数；
用+可以取消属性（只读-r不能取消）
例：declare +i num 取消整型限制，变回字符串变量；
脚本中定义数组、字典、规范类型变量，优先用declare。

declare -p  VAR  会输出变量的属性 + 类型定义
declare --	普通字符串（默认类型）
declare -i	整型变量  i = integer，中文：整数
declare -r	只读变量  readonly
declare -a	索引数组  array （普通数字索引数组）
declare -A	关联数组  Associative array（关联哈希数组）
declare -x	已导出环境变量

# declare -i num=10
# declare -p num
declare -i num="10"

普通索引数组和关联哈希数值区别
索引数组-a：
底层稀疏线性顺序结构，下标只能是整数（字符串数字自动转 int），有序、支持切片、负索引，允许下标不连续稀疏赋值。
关联数组-A：
底层哈希表，所有键都是原生字符串，永不自动转数字，无序，只支持精确 key 查询，没有隐藏数字索引，不能切片。

```



### **Shell 所有变量底层永远都是字符串类型**：

Shell  **变量本身永远是字符串,只是内容可以是数字文本** ，没有真正意义上的 int/string 数据对象；

1. 存储层（磁盘 / 内存）：Shell 所有普通变量、数组元素、环境变量，**存储形式只有字符串**；
2. 语法层：只有在特定上下文（算术、数值比较、数组索引）才会临时把字符串内容解析成整数做运算 / 寻址，执行结束立刻转回字符串存储；
3. 布尔：无原生布尔类型，依赖命令退出状态码实现逻辑判断；
4. 数组只是多元素容器结构：
   - 索引数组：key 会临时转整数寻址，value 全字符串；
   - 关联数组：key 固定为字符串，value 依旧全字符串；
5. `declare -i/-a/-A/-r/-x` 全部是**变量属性修饰符**，用来约束赋值、寻址、作用域规则，不会改变底层字符串存储本质。

#### 举个终极例子验证

```bash
declare -i num=100
echo "$num"   # 输出字符串形式的100
declare -p num
# declare -i num="100"  引号包裹，说明存储内容是字符串
```

哪怕标记为整型，bash 依然用双引号包裹值，本质就是字符串。



## 变量分类

#### 1. 自定义变量（用户自己定义）

1. 定义规则

- 变量名由字母、数字、下划线组成，**不能以数字开头**
- 等号两边**不能有空格**：`name=test` 正确；`name = test` 错误
- 默认字符串类型，Shell 无整数、浮点类型，数字运算需要特殊语法
- 变量区分大小写

1. 调用：`$变量名` 或 `${变量名}`（推荐大括号，防止变量名粘连出错）

```bash
name="zhangsan"
echo $name
echo ${name}test
```

1. 局部变量：默认只在当前 Shell 生效；脚本内变量仅脚本进程内有效
2. 全局环境变量：`export 变量名` 导出，子 Shell、脚本均可读取

#### 2. 环境变量（系统自带）

- 全局有效，所有进程均可调用
- 常用：`PATH、HOME、USER、PWD、SHELL `PS1,UID
- 查看：`env`、`printenv`、`set`
- 永久生效：写入 `/etc/profile`（全局）、`~/.bash_profile`（当前用户）

#### 3. 位置参数变量（脚本传参必备 $0 $1 \(2…\)n）

- `$0`：脚本文件名
- `$1 $2 … ${10}`：第 1、2、10 个参数，10 以上必须加大括号
- `$#`：脚本传入参数总个数
- `$*`：所有参数，当作一个整体字符串
- `$@`：所有参数，逐个独立参数（循环遍历优先用`$@`）

#### 4. 特殊预设变量

- `$?`：上一条命令执行返回状态，0 代表成功，非 0 失败
- `$$`：当前脚本进程 PID
- `$!`：后台运行最后一个进程 PID
- `$_`：上一条命令最后一个参数

### 二、变量赋值方式

1. 直接赋值：`var="hello"`
2. 命令赋值（反引号 `` 或 `$()，推荐`$()`）

```
time=$(date +%Y-%m-%d)
ip=`hostname -I`
```

1. 从键盘读取赋值：`read`

```
read -p "请输入姓名:" name
```

### 三、单引号、双引号、无引号、反引号区别（高频考点）

1. **双引号 ""**：解析变量、转义符，保留空格，推荐字符串使用
2. **单引号 ''**：原样输出，不解析变量、转义符
3. **无引号**：不能保留空格，适合纯数字、单个单词
4. **反引号 `` / $()**：执行命令，获取命令输出结果赋值

### 四、变量运算

1. 整数运算：`$(( ))`（最常用）、`expr`

```
a=10
b=20
echo $((a+b))
```

1. 小数运算：借助 `bc` 工具，Shell 原生不支持浮点运算

### 五、变量字符串操作（常用）

1. 字符串长度：`${#变量名}`
2. 字符串截取：`${var:起始位置:长度}`
3. 字符串替换、删除开头 / 结尾字符

### 六、变量作用域

1. 普通变量：仅当前 Shell / 当前脚本有效，子 Shell 无法访问
2. `export` 导出环境变量：子 Shell 可继承
3. `source` 执行脚本：脚本变量直接加载到当前 Shell 环境
4. `local`：函数内局部变量，仅函数内部可用

### 七、变量删除

- `unset 变量名`：删除变量，不能删除只读变量
- `readonly 变量名`：定义只读变量，无法修改、删除



## linux环境变量文件

```bash
# ========== 全局配置（所有用户生效） ==========
/etc/profile          # 登录Shell加载，配置全局环境变量、PATH
/etc/profile.d/*.sh   # 全局自定义脚本目录，被/etc/profile自动加载
/etc/bashrc           # 非登录Shell加载，配置全局别名、公共函数

# ========== 用户个人配置（仅当前用户生效） ==========
~/.bash_profile       # 登录时加载，个人环境变量，内部会加载.bashrc
~/.bash_login         # .bash_profile不存在才加载，极少用
~/.profile            # 前两个文件不存在才加载，Ubuntu常用
~/.bashrc             # 每次打开终端加载，个人别名、自定义函数
~/.bash_logout        # 用户退出登录时执行


su：仅换身份、不换环境，非登录 Shell；
su -：模拟完整登录，清空旧环境，加载目标用户所有登录配置，切换到家目录。

#登录式 Shell 完整加载流程
/etc/profile → /etc/profile.d/*.sh → ~/.bash_profile → ~/.bashrc → /etc/bashrc

非登录式shell (直接执行bash,su 用户名 不带杠)
只执行两步：
~/.bashrc（当前用户会话配置）--> /etc/bashrc（系统全局会话配置）
```



## 变量的知识进阶

企业应用;
一般在启动脚本的结尾会使用$0获取脚本的路径和名字给用户提示用。
/etc/init.d/crond

```bash
$1,$2----$n
$1表示脚本后的第一个参数
$2表示脚本后的第二个参数
....
超过$9,${10}  #n大于9 则用{}括起来

企业应用：

#cat /etc/init.d/crond
case "$1" in
    start)  #当第一个参数等于start 就执行 rh_status_q 函数
        rh_status_q && exit 0
        $1
        ;;
    stop)
    
    
    
```

$# 脚本后面所有参数的个数
企业应用：

```bash
[root@web01 scripts]# cat test.sh 
#!/bin/bash
#参数不等于2
if [ $# -ne 2 ]
then
   echo "Usage:$0 arg1 arg2"
   exit 1
fi
echo ok
```



```bash
$*  获取脚本的所有参数合并成一个字符串，“$1 $2 $3”
$@  获取脚本的所有参数 可遍历，"$1" "$2" "$3"

当需要接收脚本后面所有参数时，但是又不知道参数个数就用这两个变量。

区别:

[root@web01 scripts]# cat test.sh 
#!/bin/bash
for arg in "$*"
do
  echo $arg
done
echo \#--------------------------
for arg1 in "$@"
do
  echo $arg1
done
[root@web01 scripts]# bash test.sh "I am" eric teacher.
I am eric teacher.
#--------------------------
I am
eric
teacher.
```

make  #编译软件之后 查看前面是不是编译成功,查看$?
echo $?

特殊状态变量:

```
$? 获取上一个命令的返回值，如果返回值为0就证明上一个命令执行正确，非0，就证明上一个命令执行失败的。 ***
$$ 获取当前执行脚本的进程号
$! 获取上一个后台工作进程的进程号  (了解)
$_ 获取上一个执行脚本的最后一个参数 (了解)
```

## Shell变量子串

```bash
表达式                           说明 
${parameter}                    变量值
${#parameter}                   变量长度(按字符)  **
${parameter:offset}             从变量offset位置到结尾
${parameter:offset:length}      从变量offset位置之后取length长度子串
${var#xxx}：左删，最短匹配，开头删最短符合的内容
${var##xxx}：左删，最长匹配，开头删最长符合的内容
${var%xxx}：右删，最短匹配，结尾删最短符合的内容
${var%%xxx}：右删，最长匹配，结尾删最长符合的内容
${parameter/pattern/string}     变量中string替换第一个匹配的pattern
${parameter//pattern/string}    变量中string替换所有匹配的pattern

----------------------------------------------------------------------
eric="I am eric"
echo ${eric}

echo ${#eric} #返回变量内容的长度,按字符  9
echo $eric|wc -L   #9
expr length "$eric"  # 推荐 echo ${#eric} 速度更快
echo $eric|awk '{print length}'
echo $eric|awk '{print length ($0)}'

echo ${eric:2}  # am eric
# echo ${eric:1}  #从0开始算  1好位置是空格, 再终端没显示出来
am eric
# echo ==${eric:1}==   #验证是有空格的
== am eric==

echo ${eric:3:4}  #m er

echo ${eric/am/am not}  #I am not eric
echo ${eric// /-}  #I-am-eric

echo ${eric#I }  #左边删除 匹配到I 成功
echo ${eric#am}  #左边删除,开头不是am,匹配不成, 如果是要删除到am,可以写成 ${eric#*am}
echo ${eric%eric} # 右边删除  I am 

```



## expr 命令

```bash
expr 是 Shell 内置的老式运算 / 字符串处理命令，主要两大用途：
整数算术运算（加减乘除、取余）
字符串操作：获取长度、截取、匹配、索引查找

1. 整数算术运算
支持：+ - \* / %
# 加法
expr 10 + 3
# 减法
expr 10 - 3
# 乘法 必须 \*
expr 10 \* 3
# 整数除法
expr 10 / 3
# 取余
expr 10 % 3

赋值用法
num=$(expr 10 + 5)
echo $num

2. 字符串常用操作
expr length "字符串"  #expr length 字符串：获取字符串长度
expr index "linux" n # 查找n第一次出现位置：输出4
expr substr "helloworld" 2 3  # 从第2位开始截取3位：ell

# 提取开头数字  expr match 字符串 正则：开头匹配
expr match "123abc" '\([0-9]*\)'

3. 比较运算（返回 1 真，0 假）
运算符：= != \> \>= \< \<=
# 相等
expr 10 = 10
# 大于
expr 10 \> 5

expr 坑点总结
所有符号左右必须空格
❌ expr 1+2
✅ expr 1 + 2
乘号 * 必须转义 \*
下标、位置全部从 1 开始，Shell 字符串截取 ${var:0:3} 是从 0 开始，注意区分
只支持整数，不支持小数运算，浮点只能用 bc
变量不加双引号，带空格会语法报错


替代方案（现代 Shell 推荐）
算长度：${#eric}
eric="hello"
echo ${#eric}  # 直接输出5，比expr更快
算术：$((a+b))
字符串截取：${var:start:len}


```





练习题：

```bash
I am eric I teach linux
打印这些字符串中字符数小于3的单词。
涉及知识点：取字符串长度，for,if。

echo ${eric:2} #从第2个字符开启取到结尾
echo ${eric:2:2}
echo ${eric:2:4}
echo ${eric}
echo ${eric#a*c}
echo ${eric##a*c}
echo ${eric%a*C}
echo ${eric%a*c}
echo ${eric%%a*c}
echo ${eric#a*c}
echo ${eric##a*c}


```



## Shell特殊变量扩展知识

```bash
result=${variable:-word}
# 变量未定义/为空：result=word，不修改原variable
# 变量有值：result=$variable

result=${variable:=word}
# 变量未定义/为空：variable=word、result=word
# 变量有值：result=$variable

result=${variable:?word}
# 变量未定义/为空：stderr打印word，脚本直接退出
# 变量有值：result=$variable

result=${variable:+word}
# 变量未定义/为空：result为空，原变量不变
# 变量有值：result=word，不修改原variable

语法		  触发条件		行为                是否修改原变量
${var:-w}	未定义/空	 取 w	              ❌
${var:=w}	未定义/空	 取 w，同时赋值给 var	  ✅
${var:?w}	未定义/空	 输出 w，脚本退出	      ❌
${var:+w}	有值		  返回 w；空则返回空	   ❌


result=${eric1:-word}
echo $result  # word

result=${eric1:=word}
echo $eric1 $result  #word word

result=${eric1:?word}  #无返回值  bash: eric1: word

ric2=2
echo $eric2

result=${eric2:+word}
echo $result  #word

echo $eric2  #2

```



## 变量的数值计算



```bash
算数运算符                 意义

+ -                    		加法  减法
* / %                      乘法  除法  取余(取模)
  **                        幂运算
  ++ --                     增加  减少  (步长1) 
  ! && ||                   非(取反)  与(and)  或(or)
  <  <= >  >=               小于  小于等于  大于 大于等于
  << >>                     向左移位    向右移位
  ~ | & ^                   按位取反   按位异或  按位与  按位或
  = += -= *= /= %=          赋值运算符 a+=1相当a=a+1

数值运算命令：
只适合整数运算
1、(()) 推荐
2、let 次推荐
3、expr
4、$[]
既适合整数，又适合小数运算。
1、bc
2、awk 推荐

declare    定义变量值和属性,-i 参数可以用于定义整形变量做运算

1、(()) 推荐
i=$((a+1))
echo $i
echo $((a+3))
echo $((1+3))
echo $((2**3))
echo $((1+2**3-5/3))
echo $((1+2**3-5%3))

2、let 次推荐  等价于 $(( )) 赋值写法

# let写法
let a=1+2
# 等价写法
a=$((1+2))

let：直接赋值，表达式不能带空格；
$(( ))：支持表达式带空格，可读性更好，日常更推荐。

3、expr用于运算

4、$[]

=============
bc
awk
echo 1+2|bc
echo 1.1+2|bc
echo 1.1+2.3|bc
echo 2.1 1.4|awk '{print $1-$2}'
echo 2.1 1.4|awk '{print $1*$2}'
expr 2 + 2

[root@web01 scripts]# expr 2 + a
expr: non-numeric argument
[root@web01 scripts]# echo $?
2

[root@web01 scripts]# a=2
[root@web01 scripts]# expr 2 + $a &>/dev/null
[root@web01 scripts]# echo $?
0
[root@web01 scripts]# a=ckhedu
[root@web01 scripts]# expr 2 + $a &>/dev/null
[root@web01 scripts]# echo $?
2

[root@web01 scripts]# cat judge1.sh
#!/bin/bash
expr 2 + $1 &>/dev/null
if [ $? -eq 0 ]
then
   echo "$1 is 整数"
else
   echo "$1 不是整数"
fi
[root@web01 scripts]# bash judge1.sh 123
123 is 整数
[root@web01 scripts]# bash judge1.sh ckhedu
ckhedu 不是整数
```









```bash
expr 字符串 : 正则表达式
作用：从字符串开头做正则匹配，匹配成功返回捕获的字符长度；匹配失败返回 0。

cat <<EOF > judge_kuozhan.sh 
#!/bin/bash
expr "$1" : ".*\.txt" &>/dev/null
if [ $? -eq 0 ]
then
    echo "$1 是文本"
else
    echo "$1 不是文本"
fi 
EOF

[root@ckhedu scripts]# cat test.sh    
#!/bin/bash
a=6
b=2
echo "a-b=$(($a-$b))"
echo "a+b=$(($a+$b))"
echo "a*b=$(($a*$b))"
echo "a/b=$(($a/$b))"
echo "a**b=$(($a**$b))"
echo "a%b=$(($a%$b))"



```



变量的赋值：

```bash
1、定义法
a=1
2、传参法
cat <<EOF > test7.sh 
#!/bin/bash
a=$1
b=$2
echo "a-b=$(($a-$b))"
echo "a+b=$(($a+$b))"
echo "a*b=$(($a*$b))"
echo "a/b=$(($a/$b))"
echo "a**b=$(($a**$b))"
echo "a%b=$(($a%$b))"
EOF

# sh test7.sh 3 2
a-b=1
a+b=5
a*b=6
a/b=1
a**b=9
a%b=1



```

3、read读入，读取用户输入。

```
-p 提示
-t 等待用户输入的时间
read -t 30 -p "请输入一个数字:"
# read -t 30 -p "请输入一个数字:" a
请输入一个数字:11
[root@web01 scripts]# echo $a
11
[root@web01 scripts]# a=11
[root@web01 scripts]# echo $a
11


```

read读入有什么作用
和用户交互。

```bash
[root@web01 scripts]# cat test6.sh
#!/bin/bash
read -p "请输入两个数字：" a b
echo "a-b=$(($a-$b))"
echo "a+b=$(($a+$b))"
echo "a*b=$(($a*$b))"
echo "a/b=$(($a/$b))"
echo "a**b=$(($a**$b))"
echo "a%b=$(($a%$b))"

```

read企业应用

```bash
cat <<EOF >select1.sh
#!/bin/bash
cat <<EOF
  1.install lamp
  2.install lnmp
  3.exit
EOF
read -p "请选择一个序号（必须是数字）：" num
#1.判断是否为整数
expr 2 + $num &>/dev/null
if [ $? -ne 0 ]
then
    echo "Usage:$0 {1|2|3}"
    exit 1
fi
#2.判断执行处理
if [ $num -eq 1 ]
then
    echo "install lamp..."
elif [ $num -eq 2 ]
then
    echo "install lnmp..."
elif [ $num -eq 3 ]
then
    echo "bye."
    exit 
else
    echo "Usage:$0 {1|2|3}"
    exit 1
fi
EOF

----------------扩展
# 方式1：expr 加法校验（老写法，POSIX兼容）
expr 1 + "$num" &>/dev/null
if [ $? -ne 0 ];then echo "非数字";fi

# 方式2：[[ ]] 正则校验（bash推荐）
if [[ ! "$num" =~ ^[0-9]+$ ]];then echo "非数字";fi

[[ ! "$num" =~ ^[0-9]+$ ]] 详解:
1、=~ 运算符（bash 专属）
= 普通字符串相等
=~：正则匹配运算符
含义：判断左边字符串 $num 是否匹配右侧正则表达式

2、! 取反

3、正则 ^[0-9]+$ 拆解
^ 锚点：匹配字符串开头
[0-9]：匹配任意一位数字 0~9
+：前面的数字出现 至少 1 次（1 次或多次），不能是空
$ 锚点：匹配字符串结尾

```



## Bash 内置数据类型

### 1. 字符串（最基础、默认类型）

所有未声明类型的变量，本质都是字符串，可存储文字、数字、符号。

```
name="linux"
num="123"
```

> Shell 没有单独的整数、浮点类型，数字本质也是字符串，需要`declare -i`或`$(( ))`做整数运算，浮点要借助 bc 第三方工具。

### 2. 整型（需要手动声明）

原生不自带，通过 `declare -i` 声明，才能直接做四则运算。

```
declare -i a=10 b=20
```

### 3. 普通索引数组（declare -a）

下标从 0 开始的数字索引，存放一组有序数据。

```
declare -a arr=("nginx" "mysql" "redis")
```

### 4. 关联数组（哈希 / 字典，declare -A）

字符串自定义下标，键值对存储，适合做统计、映射场景。

```bash
declare -A user
user["name"]="test"
user["age"]=22

declare -A user=(["name"]="test" ["age"]=22)

```

### 补充：不存在的类型

1. 没有浮点型、布尔类型：真假依靠命令退出状态`$?`判断，0 为真，非 0 为假；
2. 没有结构体、指针、类等复杂数据类型。

### 面试精简背诵版

1. 设计思想：作为命令粘合剂，面向过程、解释执行，依托 Linux 现有工具实现自动化，主打轻量批量运维。
2. 语言特点：语法简单、系统自带无需部署、弱类型、深度支持管道重定向、文本处理能力强，适合运维自动化，不适合复杂数值计算。
3. 内置数据类型：字符串（默认）、整型（declare -i 声明）、索引数组、关联数组；无浮点、布尔、面向对象类型。



```bash
# 内置变量判断真假  true false

# true 命令退出码 0（真）
if true; then
    echo "条件成立"
fi

# false 命令退出码 1（假）
if false; then
    echo "不会执行"
fi

# [ ]是 test 的别名，也是一条内置命令，执行后返回 0/1 代表条件真假：
# 等价于执行 test -f "/etc/passwd"，根据退出码判断
if [ -f "/etc/passwd" ];then 

逻辑与 &&、逻辑或 || 本质
命令1 && 命令2
# 命令1返回0（真），才执行命令2

命令1 || 命令2
# 命令1返回非0（假），才执行命令2
```



### []、[[]]、(()) 三者区别

```bash
一、[ ] 等价于 test 命令（POSIX 标准，所有 Shell 通用）
本质：[ 是 Linux 内置命令，必须前后加空格
适用场景：字符串比较、文件属性判断、简单整数比较
限制：
不支持正则、&&、||，只能用 -a -o
变量不加双引号容易因空格报错
示例：
[ "$name" = "test" ]
[ $num -gt 10 ]
[ -f /etc/hosts ]

二、[[ ]] 双中括号（Bash 扩展语法，推荐日常使用）
不是命令，是 Bash 关键字，语法更安全强大
优势：
支持 && || 逻辑运算符
支持 =~ 正则匹配、通配符
变量带空格不容易出错
常用场景：字符串模糊匹配、正则、多条件判断
示例：
[[ $name == t* && $age -gt 18 ]]
[[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]

三、(( )) 双小括号（专门用于整数运算 + 整数条件判断）
只支持整数，不支持字符串、文件判断
可以直接使用 > < >= <= == != && || 数学运算符，不用 -gt -lt
支持变量自增、四则运算
示例：
if (( a > 10 && b < 20 ));then
((i++))

四、核心选型总结
要兼容所有 Shell（sh）：用 [ ]
bash 脚本做字符串、正则、多条件：优先 [[ ]]
纯整数比较、数值运算：直接 (( ))
```





## 条件表达式

````bash
条件表达式6种写法：if,while
语法1: test <测试表达式>
语法2: [ <测试表达式> ]    #两端有空格
语法3：[[ <测试表达式> ]]  #两端有空格
语法4：((<测试表达式>))    #不需要空格

语法5：(命令表达式) 
语法6：`命令表达式`

编程语法：
[ <测试表达式> ] && 命令1
如果前面表达式成功，那么就执行后面命令。

[ <测试表达式> ] || 命令1
如果前面表达式失败，那么就执行后面命令。


[ <测试表达式> ] && {
命令1
命令2
命令3
}
如果前面表达式成功，那么就执行后面命令。

[ <测试表达式> ] && 命令1 || 命令2
如果前面表达式成功，那么就执行命令1，否则执行命令2。

[ <测试表达式> ] && {
命令1
命令2
}||{
命令3
命令4
}
如果前面表达式成功，那么就执行命令1，2，否则执行命令3,4。


<测试表达式>有哪些：

````











为什么需要文件测试表达式？
操作一个对象，就要看对象条件是否满足，否则不要操作。
1、常见功能
2、实践
3、企业应用：启动脚本中的应用。

## 文件测试表达式：

```bash
操作符号       记忆单词
[ -f ]        f file              文件存在且为普通文件 真
[ -d ]        d directory         文件存在且为目录 真             
[ -e ]        e exist             文件或目录存在  真

[ -r ]        r read              文件存在且可读  真
[ -w ]        w write             文件存在且可写  真
[ -x ]        x executable        文件存在且可执行  真

[ -s ]        s size              文件存在且文件大小不为0  真
[ -L ]        L link              文件存在且为链接文件  真

[ f1 -nt f2 ] nt newer than       f1比f2文件新  真 根据文件修改时间算  
[ f1 -or f2 ] or older than       f1比f2文件旧 真  根据文件修改时间算
```



## 字符串测试表达式

```bash
[ -n "字符串" ]    字符串长度[不]为0，表达式为真。 not zero。
[ -z "字符串" ]    字符串长度为0，表达式为真。 zero。
[ "字符串1" == "字符串2" ]  两个字符串相同则为真。可用 =代替
[ "字符串1" != "字符串2" ] 两个字符串不相同则为真。不可用 !== 代替 

# 字符串判断
[ -n "$var" ]       # 字符串非空
[ -z "$var" ]       # 字符串为空
[ "$a" = "$b" ]     # 相等
[ "$a" != "$b" ]    # 不等

注意：
1、字符串就用双引号
2、等号可以用一个或者两个。
3、=号两端必须要有空格。

实践：
[ -n "ckhedu" ] && echo 1 || echo 0

[ -z "ckhedu" ] && echo 1 || echo 0

char="ckhedu"
 [ -z "$char" ] && echo 1 || echo 0
0
[root@web01 ~]# unset char
[ -z "$char" ] && echo 1 || echo 0

[ "dd" == "dd" ] && echo 1 || echo 0

[ "dd" == "ff" ] && echo 1 || echo 0
[ "dd" = "ff" ] && echo 1 || echo 0

[ "dd" != "ff" ] && echo 1 || echo 0

[ "dd" != "dd" ] && echo 1 || echo 0

```







企业应用：


```bash
[root@db03 scripts]# cat yunsuan.sh
#!/bin/bash
##############################################################
# File Name: yunsuan.sh
# Version: V1.0
# Author: ckhedu
# Organization: www.ckhedu.com
# Created Time : 2018-05-30 09:03:10
# Description:
##############################################################
#!/bin/bash
read -p "pls input two num:" a b

if [ -z "$b" ]
then
    echo "请输入两个数"
    exit 1
fi
expr $a + $b + 1 &>/dev/null
if [ $? -ne 0 ]
then
    echo "Usage:$0 num1 num2"
    exit 1
fi

echo "a-b=$(($a-$b))"
echo "a+b=$(($a+$b))"
echo "a*b=$(($a*$b))"
echo "a/b=$(($a/$b))"
echo "a**b=$(($a**$b))"
echo "a%b=$(($a%$b))"
```

## 整数测试表达式：

```bash
[]内的比较符号          在(())和[[]]的比较符号        说明 
[ 整数1 -eq 整数2 ]    (( 整数1 ==或= 整数2 ))       相等 equal
        -ne                    !=                 不相等 not equal
        -gt                    >                  大于 greater than
        -ge                    >=                 大于等于 greater equal                    
        -lt                    <                  小于 less than
        -le                    <=                 小于等于 less equal


小题：使用read的交互方式，来比较两个整数的大小。
分析：
1、要求整数
2、2个数
3、比较大小
    大于
    等于
    小于
    
    
    
```



[root@web01 scripts]# cat com1.sh 

```bash
#!/bin/bash
read -p "请输入两个整数：" a b

#1.判断是不是输入两个数
[ -z "$b" ] &&{
    echo "请输入两个整数"
    exit 1
}

#2.判断整数
expr $a + $b + 1 &>/dev/null
[ $? -ne 0 ] &&{
     echo "请输入两个整数"
     exit 2
}

#3.判断是否大于
[ $a -gt $b ] &&{
    echo "$a>$b"
    exit 0
}

#4.判断是否等于
[ $a -eq $b ] &&{
    echo "$a=$b"
    exit 0
}
#5.判断是否小于
echo "$a<$b"
```

​    
[root@db03 scripts]# cat comp.sh 

```bash
#!/bin/bash
##############################################################
# File Name: comp.sh
# Version: V1.0
# Author: ckhedu
# Organization: www.ckhedu.com
# Created Time : 2018-05-30 11:36:19
# Description:
##############################################################
read -p "Pls input two num:" a b
#1.第一关判断传入的内容都是整数
expr $a + $b + 100 &>/dev/null
[ $? -ne 0 ] &&{
   echo "Usage:$0 num1 num2"
   exit 1
}

#2.第二关输入两个数
[ -z "$b" ] &&{
   echo "Usage:$0 num1 num2"
   exit 2
}


#3.比较大小
[ $a -gt $b ] && {
   echo "$a>$b"
   exit 0
}

[ $a -eq $b ] && {
   echo "$a=$b"
   exit 0
}
echo "$a<$b"
exit 0
```

[root@db03 scripts]# cat comp.sh 

```
#!/bin/bash
##############################################################
# File Name: comp.sh
# Version: V1.0
# Author: ckhedu
# Organization: www.ckhedu.com
# Created Time : 2020-05-30 11:36:19
# Description:
##############################################################
read -p "Pls input two num:" a b
#1.第一关判断传入的内容都是整数
expr $a + $b + 100 &>/dev/null
[ $? -ne 0 ] &&{
   echo "Usage:$0 num1 num2"
   exit 1
}

#2.第二关输入两个数
[ -z "$b" ] &&{
   echo "Usage:$0 num1 num2"
   exit 2
}

#3.比较大小
if [ $a -gt $b ]
then
   echo "$a>$b"
elif [ $a -eq $b ]
then
    echo "$a=$b"
else
    echo "$a<$b"
fi
```

### 逻辑测试表达式

```bash
[]内的比较符号          在(())和[[]]的比较符号      说明 
-a                      &&                      and与
-o                      ||                      or 或 
!                       !                       not 非

[]中 使用 -a -o
[[]]或(())里面 使用&& ||
[] [[]] (()) 这些符号之间连接 使用&& ||

make && make install

[root@db03 scripts]# [ 1 -eq 1 -a -f /etc/hosts ] && echo 1 || echo 0
1
[root@db03 scripts]# [ 1 -eq 2 -a -f /etc/hosts ] && echo 1 || echo 0
0
[root@db03 scripts]# [ 1 -eq 2 && -f /etc/hosts ] && echo 1 || echo 0
-bash: [: missing `]'
0
[root@db03 scripts]# [[ 1 -eq 2 && -f /etc/hosts ]] && echo 1 || echo 0
0
[root@db03 scripts]# [ 1 -eq 2 ] && [ -f /etc/hosts ] && echo 1 || echo 0
0
[root@db03 scripts]# [ -f /etc/hosts ] && echo 1 || echo 0
1
[root@db03 scripts]# [ ! -f /etc/hosts ] && echo 1 || echo 0
0


小题：如果/tmp/ckhedu.sh是普通文件，并且可执行，就执行该脚本。
file="/tmp/ckhedu.sh"
if [ -f $file ] && [ -x $file ]
then
    bash $file
fi


```



## shell 单分支  双分支  多分支 语法

```bash
# 1. 单分支 if
if [ 条件 ];then
  命令
fi

# 2. 双分支 if-else
if [ 条件 ];then
  条件成立执行
else
  不成立执行
fi

# 3. 多分支 if-elif-else
if [ 条件1 ];then
  命令1
elif [ 条件2 ];then
  命令2
elif [ 条件3 ];then
  命令3
else
  都不满足执行
fi

# 4. 多分支 case（固定选项推荐）
case $变量 in
值1)
  命令1
;;
值2)
  命令2
;;
*)
  默认命令
;;
esac
```



范例7_2：开发Shell脚本判断系统剩余内存的大小，如果低于100MB就邮件报警给系统管理员，
并且将脚本加入系统定时任务，即每3分钟执行一次检查。

```bash
分析思路：
1、取内存
free -m|awk 'NR==3{print $NF}'
2、发邮件
mail -s "主题" 邮件地址 </etc/hosts
echo ""|mail -s "主题" 邮件地址
3、开发脚本判断发邮件
full="内存充足。"
leak="内存不足。"
free=`free -m|awk 'NR==3{print $NF}'`
if [ $free -lt 1000 ]
then
    echo "$leak"|tee /tmp/mail.log
    mail -s "$leak`date`" 31333741-@qq.com </tmp/mail.log
else
    echo "$full"
fi

4、加入定时任务
[root@db03 scripts]# crontab -l|tail -2
###########
*/3 * * * * /bin/sh /server/scripts/judge.sh >/dev/null 2>&1

练习：开发Shell脚本判断系统根分区剩余空间的大小，如果低于1000MB报警空间不足，
如果低于500M，就报警空间严重不足，最后把结果邮件发给系统管理员，
并且将脚本加入系统定时任务，即每3分钟执行一次检查。
```





## Shell函数的语法

```bash
# 写法2：bash兼容老式写法
function 函数名{
    指令集..
    return n
}

# 写法1：标准定义
func_name() {
    # 函数体
    echo "函数执行"
    # 位置参数 $1 $2 $@ $#
    return 0  # 返回退出状态(0-255)
}

# 调用函数
func_name
# 传参调用
func_name arg1 arg2

# 函数内变量
# 局部变量加local
demo(){
    local num=10
    echo $num
}

# 返回值只能用return（仅整数状态码）
# 需要返回字符串用echo输出，$()捕获
get_val(){
    echo "hello"
}
res=$(get_val)




将函数传参转为脚本传参
ckhedu() {
    echo "I am $1."
}
ckhedu $1


# 将函数体和函数执行分离成不同的文件。
---------------------------------------------------
cat <<\EOF > fun.lib
#!/bin/bash
# 函数库文件，只定义函数，不执行
add(){
    echo $(( $1 + $2 ))
}

check_num(){
    if [[ ! $1 =~ ^[0-9]+$ ]];then
        echo "$1不是数字"
        return 1
    fi
    echo "$1是数字"
    return 0
}
EOF

cat <<\EOF > main.sh
#!/bin/bash
# 加载外部函数文件
source ./fun.lib

# 调用外部文件里定义的函数
res=$(add 10 20)
echo "计算结果：$res"

check_num abc
check_num 666
EOF

# 赋予执行权限
chmod +x fun.lib main.sh
# 运行主脚本
./main.sh
```



企业案例：通过脚本传参的方式，检查Web 网站URL是否正常。
```bash

wget命令：
--spider 模拟爬虫
-q 安静访问
-o /dev/null 不输出
-T --timeout 超时时间
-t --tries 重试次数
[root@web01 ~]# wget --spider -T 5 -q -o /dev/null -t 2 www.baidu.com
[root@web01 ~]# echo $?
0
curl命令：
-I 看响应头
-s 安静的
-o /dev/null 不输出
-w %｛http_code｝ 返回状态码，200
[root@web01 ~]# curl www.baidu.com -s &>/dev/null
[root@web01 ~]# echo $?
0
[root@web01 ~]# curl -I -m 5 -s -w "%{http_code}\n" -o /dev/null  www.baidu.com
200



```



不用函数的实现写法

```bash
#!/bin/sh
if [ $# -ne 1 ]
  then
    echo $"usage:$0 url"
    exit 1
fi
wget --spider -q -o /dev/null --tries=1 -T 5 $1 #<==-T指定超时时间，这里的$1为脚本的参数。
if [ $? -eq 0 ]
  then
    echo "$1 is yes."
else
    echo "$1 is no."
fi
```

高端专业的函数写法：

```bash
cat <<\EOF > checkurl.sh 
#!/bin/bash
##############################################################
# File Name: checkurl.sh
# Version: V1.0
# Author: ckhedu
# Organization: www.ckheduedu.com
# Created Time : 2018-06-07 18:29:19
# Description:
##############################################################
usage(){
    echo "Usage:$0 url"
    exit 1
}
checkurl(){
    wget -q -o /dev/null -t 2 -T 5 $1
    if [ $? -eq 0 ]
    then
        echo "$1 is ok"
    else
        echo "$1 is fail"
    fi
}
main(){
    if [ $# -ne 1 ]
    then
        usage
    fi
    checkurl $1
}
main $*
EOF

```

[root@ckhedu scripts]# cat 8_5_1.sh  

```bash
#!/bin/sh
function usage() {     #<==帮助函数
    echo $"usage:$0 url"
    exit 1
}

function check_url() { #<==检测URL函数。
  wget --spider -q -o /dev/null --tries=1 -T 5 $1 #<==这里的$1就是函数传参。
  if [ $? -eq 0 ]
   then
     echo "$1 is yes."
  else
    echo "$1 is no."
  fi
}

function main() {   #<==主函数。
  if [ $# -ne 1 ]  #<==如果传入的多个参数，则打印帮助函数，提示用户。
  then
    usage
  fi
  check_url $1     #<==接收函数的传参，即把结尾的$*传到这里。
}
main $*            #<==这里的$*就是把命令行接收的所有参数作为函数参数传给函数内部，常用手法。
```

## case语句

```bash
#  多分支 case（固定选项推荐）
case $变量 in
值1)
  命令1
;;
值2)
  命令2
;;
*)
  默认命令
;;
esac
```



范例9_2：执行shell脚本，打印一个如下的水果菜单：
1.apple
2.pear
3.banana
4.cherry
当用户输入对应的数字选择水果的时候，告诉他选择的水果是什么，并给水果单词加上一种颜色（随意），要求用case语句实现。

```bash
适用场景
case 适合变量取值为少量固定数字 / 字符串；不适合范围类判断。if 适用所有场景，覆盖 case 全部场景。
典型用途
case 多用于服务启停脚本（start/stop/restart 类固定参数）；if 多用于数值比较、多条件、范围、文件 / 字符串复杂判断。
优缺点
case 等价多分支 if-elif，代码结构规整、可读性更强；if 通用性更广、灵活度更高。

cat <<\EOF > fruit.sh
#!/bin/bash
# 定义颜色 红色
RED='\033[31m'
NC='\033[0m'

# 打印菜单
cat <<MENU
========水果菜单========
1.apple
2.pear
3.banana
4.cherry
========================
MENU

read -p "请输入水果序号(1-4)：" num

case $num in
1)
    echo -e "你选择的水果是：${RED}apple${NC}"
;;
2)
    echo -e "你选择的水果是：${RED}pear${NC}"
;;
3)
    echo -e "你选择的水果是：${RED}banana${NC}"
;;
4)
    echo -e "你选择的水果是：${RED}cherry${NC}"
;;
*)
    echo "输入错误，请选择1-4之间的数字"
    exit 1
;;
esac
EOF


chmod +x fruit.sh
./fruit.sh
```



范例9_3：给内容加不同的颜色。
```bash
内容的颜色用数字表示，范围为30-37，每个数字代表一种颜色。代码如下： 

echo -e "\033[30m 黑色字ckhedu trainning \033[0m" #<==30m表示黑色字。
echo -e "\033[31m 红色字ckhedu trainning \033[0m" #<==31m表示红色字。
echo -e "\033[32m 绿色字ckhedu trainning \033[0m" #<==32m表示绿色字。
echo -e "\033[33m 棕色字ckhedu trainning \033[0m" #<==33m表示棕色字（brown），和黄色字相近。
echo -e "\033[34m 蓝色字ckhedu trainning \033[0m" #<==34m表示蓝色字。
echo -e "\033[35m 洋红字ckhedu trainning \033[0m" #<==35m表示洋红色字（magenta），和紫色字相近。
echo -e "\033[36m 蓝绿色ckhedu trainning \033[0m" #<==36m表示蓝绿色字（cyan），和浅蓝色字相近。
echo -e "\033[37m 白色字ckhedu trainning \033[0m" #<==37m表示白色字。

说明：不同的数字对应的字体颜色，见系统帮助（来源man console_codes命令的结果）。
```



范例9_6： 给输出的字符串加不同的背景颜色。

```bash

echo -e "\033[40;37m 黑底白字ckhedu\033[0m"   #<==40m表示黑色背景。
echo -e "\033[41;37m 红底白字ckhedu\033[0m"   #<==41m表示红色背景。
echo -e "\033[42;37m 绿底白字ckhedu\033[0m"   #<==42m表示绿色背景。
echo -e "\033[43;37m 棕底白字ckhedu\033[0m"   #<==43m表示棕色背景（brown），和黄色背景相近。
echo -e "\033[44;37m 蓝底白字ckhedu\033[0m"   #<==44m表示蓝色背景。
echo -e "\033[45;37m 洋红底白字ckhedu\033[0m"  #<==45m表示洋红色背景（magenta），和紫色背景相近。
echo -e "\033[46;37m蓝绿底白字ckhedu\033[0m"   #<==46m表示蓝绿色背景（cyan），和浅蓝色背景相近。
echo -e "\033[47;30m 白底黑字ckhedu\033[0m"    #<==47m表示白色背景。
```



范例9_10：利用case语句开发Rsync服务启动停止脚本，本例采用case语句以及新的思路来实现。

```bash
分析：
启动：
	rsync --daemon
停止：
    pkill rsync
    killall rsync
    kill 进程号

/etc/init.d/rsyncd {start|stop|restart}



cat <<\EOF > /etc/init.d/rsyncd
#!/bin/bash
# chkconfig: 35 20 80
# description: rsync service start stop restart

case "$1" in
start)
    rsync --daemon
    echo "rsync 服务已启动"
;;
stop)
    killall rsync &>/dev/null
    echo "rsync 服务已停止"
;;
restart)
    $0 stop
    $0 start
    echo "rsync 服务已重启"
;;
*)
    echo "用法: $0 {start|stop|restart}"
    exit 1
;;
esac
EOF

/etc/init.d/rsyncd start
/etc/init.d/rsyncd stop
/etc/init.d/rsyncd restart
```



## While循环语句

```bash

While循环语法
while <条件表达式>
do
    指令...
done


```



范例10_1：每隔2秒输出一次系统负载（负载是系统性能的基础重要指标）情况。

```bash
cat <<\EOF > while1.sh
#!/bin/sh
while true 
do
    uptime >>/tmp/uptime.log
    sleep 2
done
EOF

用法                 说明
sh while1.sh &       把脚本while1.sh放到后台执行（后台运行脚本时常用）*
nohup while1.sh &    使用nohup把脚本while1.sh放到后台执行
ctl+c                停止执行当前脚本或任务
ctl+z                暂停执行当前脚本或任务
bg                    把当前脚本或任务放到后台执行，bg可以理解为background
fg                    把当前脚本或任务拿到前台执行，
jobs                 查看当前执行的脚本或任务
kill                 关闭执行的脚本任务，即以“kill %任务编号”

后台运行 nohup &、、screen（运维人员）

kill、killall、pkill：杀掉进程。
ps：查看进程。
pstree：显示进程状态树。
top：显示进程。
renice：改变优先权。 
nohup：用户退出系统之后继续工作。
pgrep：查找匹配条件的进程。
strace：跟踪一个进程的系统调用情况。
ltrace：跟踪进程调用库函数的情况。
```



范例10_2：请使用while循环对下面的脚本进行修改，使得当执行脚本时，每次执行完脚本以后不退出脚本了，而是继续提示用户输入。

```bash
#!/bin/bash
read -t 15 -p "please input two number:" a b
echo "a-b=$(($a-$b))"
echo "a+b=$(($a+$b))"
echo "a*b=$(($a*$b))"
echo "a/b=$(($a/$b))"
echo "a**b=$(($a**$b))"
echo "a%b=$(($a%$b))"

```

解答:

```bash
cat <<EOF > 10-02.sh
#!/bin/bash
while true
do
    read -p "请输入两个数字：" a b
    if [ -z "$b" ]
    then
        echo "请输入两个数字："
        continue
    fi
    expr 10 + $a + $b &>/dev/null
    if [ $? -ne 0 ]
    then
        echo "请输入两个数字："
        continue
    fi
    echo "a-b=$(($a-$b))"
    echo "a+b=$(($a+$b))"
    echo "a*b=$(($a*$b))"
    echo "a/b=$(($a/$b))"
    echo "a**b=$(($a**$b))"
    echo "a%b=$(($a%$b))"
done
EOF

```



范例10_4：猜数字游戏。首先让系统随机生成一个数字，给这个数字定一个范围（1-60），让用户输入猜的数字，对输入进行判断，如果不符合要求，就给予高或低的提示，猜对后则给出猜对用的次数，请用while语句实现。
提示：可以赋予一个猜水果的价格游戏。
分析：
1）给这个数字定一个范围（1-60）
echo $((RANDOM%60)) 执行脚本后是固定的，例如；50

2)read -p "输入猜数字：" num
用户输入的数字和已知的随机数比较。

3）连续猜就需要用while

```
random="$((RANDOM%60))"
count=0
while true
do
    ((count++))
    read -p "请猜数字：" num
    if [ $num -gt $random ]
    then
        echo "猜高了。"
    elif [ $num -eq $random ]
    then
        echo "牛啊，猜对了，一共猜了${count}次。"
        exit
    else
        echo "猜低了。"
    fi
done
```



范例10_8：分析Apache访问日志(access_2010-12-8.log)，把日志中每行的访问字节数对应字段数字相加，计算出总的访问量。给出实现程序，请用while循环实现。（3分钟）

方式1：在while循环结尾done通过输入重定向指定读取的文件。

```bash
while read line
do
    cmd
done<FILE
```

方式2：使用cat读取文件内容，然后通过管道进入while循环处理。

```bash
cat FILE_PATH|while read line
do
    cmd
done
```

方式3：采用exec读取文件后，然后进入while循环处理。

```bash
exec <FILE
sum=0
while read line
do
    cmd
done

```

## Shell 常用语句精简总结 

1. **while 循环**

   适合守护进程、无限循环场景，需用`sleep`控制执行频率；常规循环可被 for 循环或 crontab 定时任务替代。

2. **case 语句**

   可由 if 替换，多用于服务启停、固定参数菜单类脚本；常规条件判断优先用 if。

3. **使用优先级**

   if、for 使用最频繁；while 用于常驻循环；case 用于固定参数启停脚本。

4. **各语法适用场景**

- 条件表达式：简短判断，如文件权限、字符串空值校验
- if：多条件、范围、复杂逻辑判断
- for：常规批量循环处理（最常用）
- while：常驻守护、无限轮询任务
- case：固定选项的菜单、服务启停脚本
- 函数：封装重复代码，精简脚本、逻辑结构化





## for循环语句

```bash
# 一、for循环两种语法
## 1. 遍历取值（常用）
for 变量 in 值1 值2 值3
do
    循环体命令
done

# 示例
for i in 1 2 3
do
    echo $i
done

# 序列写法
for i in {1..10}        #1到10
for i in {1..10..2}     #1、3、5、7、9

# 命令结果遍历
for file in $(ls /tmp)
do
    echo $file
done

## 2. C语言风格for（bash专用）
for ((i=1;i<=10;i++))
do
    echo $i
done

# 二、循环控制
break   # 跳出整个循环
continue # 跳过本次，进入下一次循环

# 三、常用场景
# 1.批量创建文件
for i in test{1..5}.txt;do touch $i;done

# 2.批量处理IP、主机
# 3.批量用户创建、日志遍历

范例1：用for循环竖向打印1、2、3、4、5共5个数字。
for i in {1..5}
do
	echo $i
done


范例2：通过开发脚本实现仅设置sshd rsyslog crond network sysstat服务开机自启动。
#!/bin/bash
# 定义需要开机自启的服务列表
service_list="sshd rsyslog crond network sysstat"

# for循环遍历设置开机自启
for service in $service_list
do
    # CentOS7+ systemd方式
    systemctl enable $service
    # 查看设置结果
    if [ $? -eq 0 ];then
        echo "$service 已设置开机自启"
    else
        echo "$service 设置开机自启失败"
    fi
done


范例3：计算从1加到100之和。
for i in {1..100}
do
	# sum=$((sum+i))
	# ((sum+=i))
	let sum+=i
done
echo $sum


范例4：在Linux下批量修改文件名，将文件名中的“_finished”去掉。
准备测试数据，如下。
mkdir /ckhedu -p
cd /ckhedu
touch stu_102999_{1..5}_finished.jpg

答:
rename "_finished" "" *.jpg

ls *.jpg|awk -F "_finished" '{print "mv",$0,$1$2}'|bash

for file in `ls ./*.jpg`
do
    mv $file `echo ${file/_finished/}`
done

```



## 循环和条件句等的控制

```bash
# 1. break
# 跳出当前一层 for/while 循环，继续执行循环后面的代码
for i in {1..5};do
  [ $i -eq 3 ] && break
  echo $i
done
# 输出：1 2

# 2. continue
# 跳过本次循环剩余代码，直接进入下一次循环
for i in {1..5};do
  [ $i -eq 3 ] && continue
  echo $i
done
# 输出：1 2 4 5

# 3. exit [n]
# 直接终止整个脚本，返回退出码n；脚本任何位置执行都结束整个程序
# 常用于错误校验、不符合条件直接退出脚本

# 4. return [n]
# 仅用在函数内部，退出当前函数，返回0~255状态码；不会终止主脚本
# 函数外不能使用return

核心区别精简
break：跳出循环，脚本继续往下走
continue：跳过本次循环，下一轮继续
exit：整个脚本直接结束
return：仅退出当前函数，脚本继续执行





```



## shell数组

```bash
# 1. 定义数组
arr=("apple" "pear" "banana")

# 2. 取值
${arr[0]}          # 获取第1个元素
${arr[@]}          # 获取所有元素
${arr[*]}          # 所有元素拼成一个字符串
${#arr[@]}         # 数组长度
${#arr[0]}         # 第一个元素字符串长度

# 3. 遍历数组
for item in "${arr[@]}"
do
    echo $item
done

# 下标遍历
for ((i=0;i<${#arr[@]};i++))
do
    echo ${arr[$i]}
done

# 4. 修改、追加元素
arr[2]="cherry"
arr+=("orange")

# 5. 删除元素
unset arr[1]
# 清空数组
unset arr


[root@ansible ckhedu]# arr=("apple" "banner" "pear")
[root@ansible ckhedu]# declare -p arr
declare -a arr='([0]="apple" [1]="banner" [2]="pear")'


# 默认是索引数组, 需要申请关联数组必须写上 declare -A
[root@ansible ckhedu]# user=(["name"]="test" ["age"]=22)
[root@ansible ckhedu]# declare -p user
declare -a user='([0]="22")'
[root@ansible ckhedu]# unset user
[root@ansible ckhedu]# declare -A user=(["name"]="test" ["age"]=22)
[root@ansible ckhedu]# declare -p user
declare -A user='([name]="test" [age]="22" )'
```



数组内容的截取和替换
```bash

array=(1 2 3 4 5)
echo ${array[@]:1:3}        #<==从下标为1的元素开始截取，共取3个数组元素。

array=({a..z})             #<==将变量的结果赋值给数组变量。
echo ${array[@]}
echo ${array[@]:1:3}       #<==从下标为1的元素开始截取，共取3个数组元素。
echo ${array[@]:0:2}       #<==从下标为0的元素开始截取，共取2个数组元素。

array=(1 2 3 1 1)   
echo ${array[@]/1/b}    #<==把数组中的1替换成b，原数组未被修改,和sed很像。

提示：调用方法是：${数组名[@或*]/查找字符/替换字符} 该操作不会改变原先数组内容，
如果需要修改，可以看上面例子，重新定义数组。

数组元素部分内容的删除如下：
array=(one two three four five)
echo ${array[@]}               
[root@ckhedu data]# echo ${array[@]#o*}    #<==从左边开始匹配最短的，并删除。 
ne two three four five
[root@ckhedu data]# echo ${array[@]##o*}  #<==从左边开始匹配最长的，并删除。 
two three four five

[root@m01 ckhedu]# array=(one two three four fivef)
[root@ckhedu data]# echo ${array[@]%f*}    #<==从右边开始匹配最短的，并删除。 
one two three five
[root@ckhedu data]# echo ${array[@]%%f*}   #<==从右边开始匹配最长的，并删除。
one two three

提示：数组也是变量，因此也适合于前面讲解过的变量的子串处理的功能应用。
数组的其他相关知识通过man bash然后搜Arrays来了解。

```



## Shell数组脚本开发实践

范例13_1：使用循环批量输出数组的元素。
方法1：通过C语言型的for循环语句打印数组元素。
[root@ckhedu scripts]# cat 13_1_1.sh

```bash
#!/bin/sh
array=(1 2 3 4 5)
for((i=0;i<${#array[*]};i++))  #<==从数组的第一个小标0开始，循环数组的所有下标。
do
    echo ${array[i]}            #<==打印数组元素。
done
```

方法2：通过普通for循环语句打印数组元素。

```bash
[root@ckhedu scripts]# cat 13_1_2.sh
#!/bin/sh
array=(1 2 3 4 5)
for n in ${array[@]}  #<==${array[*]}表示输出数组所有元素，相当于列表数组元素。
do
    echo $n           #<==这里就不是直接去数组里取元素了，而是变量n的值。
done
```

方法3：使用while循环语句打印数组元素。

```bash
[root@ckhedu scripts]# cat 13_1_3.sh    
#!/bin/sh
array=(1 2 3 4 5)
i=0
while ((i<${#array[*]}))
do
    echo ${array[i]}
    ((i++))
done
```

范例13_2：通过竖向列举法定义数组元素并批量打印。

```bash
[root@ckhedu scripts]# cat 13_2_1.sh
#!/bin/sh
array=(         #<==对于元素特别长的时候，例如URL地址，竖向列出来看起来舒服和规范。
    ckhedu
    oldgirl
    xiaoting
    bingbing
)
for ((i=0; i<${#array[*]}; i++))
do
    echo "This is num $i,then content is ${array[$i]}"
done
echo ----------------------
echo "array len:${#array[*]}"
```

范例13_3：把命令结果作为数组元素定义并打印。


```bash
准备数据：
mkdir -p /array/
touch /array/{1..3}.txt


[root@ckhedu scripts]# cat 13_3_1.sh 
#!/bin/bash
dir=($(ls /array))              #<==把ls /array命令结果放数组里。
for ((i=0; i<${#dir[*]}; i++))  #<==${#dir[*]}为数组的长度。
do
    echo "This is NO.$i,filename is ${dir[$i]}"
done
```

## Shell数组的重要命令

```bash
1定义命令
静态数组:
# 索引静态数组
arr=("zhangsan" "lisi" "wangwu")

# 关联静态数组
declare -A user=(["name"]="test" ["age"]=22)


动态数组:

# 1. 先定义空数组
arr=()
# 2. 循环动态追加
for i in {1..5};do
    arr+=("user$i")
done
# 3. 从命令结果批量存入数组
files=($(ls /etc/*.conf))
array=($(ls))
或array=(`ls`)
#动态追加
arr+=("新元素")


#关联数组也可以动态追加
declare -A user
user["name"]="jack"
user["gender"]="man"

给数组赋值:
array[3]=4

2打印命令
打印所有元素:
${array[@]}或${array[*]}

打印数组长度:
${#array[@]}或${#array[*]}

打印单个元素:
${array[i]}             #<==i是数组下标。


3循环打印的常用基本循环
#!/bin/sh
arr=(
    172.16.1.11
    172.16.1.22
    172.16.1.33
)
#C语言for循环语法
for ((i=0;i<${#arr[*]};i++))
do
    echo "${arr[$i]}"
done
echo ---------------

#普通for循环语法
for n in ${arr[*]}
do
    echo "$n"
done


```



##  linux 通配符  基础正则  扩展正则

```bash

# 1. Shell 通配符Globbing（用于文件名匹配：ls/cp/mv/find）
符号		作用
*		 匹配任意长度任意字符（不含隐藏文件开头.）
?		 匹配单个任意字符
[abc]	 匹配括号内任意一个字符
[a-z]	 匹配区间内单个字符
[^0-9]	 匹配不在区间内的单个字符
[!字符集] 取反，匹配不在括号内的单个字符	
{a,b,c}	批量匹配多个字符串，不属于正则，属于 bash 花括号扩展

#POSIX 字符类（在 [] 内使用）
# 用于更规范的字符范围匹配，避免不同编码下的范围异常。
字符类			含义			示例
[:digit:]	数字 0-9		 ls [[:digit:]]*.txt 数字开头的 txt 文件
[:alpha:]	大小写字母	   ls [[:alpha:]]*.log 字母开头的 log 文件
[:lower:]	小写字母		ls [[:lower:]]* 小写开头的所有文件
[:upper:]	大写字母		ls [[:upper:]]* 大写开头的所有文件
[:alnum:]	字母 + 数字		ls [[:alnum:]]*.conf 字母数字开头的 conf
[:space:]	空白字符（空格、制表符等）	匹配含空格的文件名
[:punct:]	标点符号	              匹配含标点的文件名

# 开启扩展通配符
shopt -s extglob

大括号扩展 {}
纯字符串枚举生成，不检查文件是否存在，常用于批量创建、批量操作。
枚举：{a,b,c} → 生成 a b c
序列：{1..10}、{a..z}、{10..1} 倒序
嵌套组合：{web,db}_{log,data} → web_log web_data db_log db_data


常用示例：
# 快速备份文件
cp nginx.conf{,.bak}
# 批量创建目录
mkdir -p /data/{app,log,backup,script}
# 批量创建有序文件
touch file{1..10}.txt

递归通配 **
# 递归列出所有子目录的log文件
ls **/*.log
# 递归查找所有yaml配置
ls **/*.yaml

波浪号 ~ 扩展
~：当前用户家目录
~用户名：指定用户的家目录
~+：当前工作目录
~-：上一个工作目录
.    当前工作路径,或隐藏文件
..   上一级目录
回家用 cd ~，切回上目录用 cd -，自己家目录加 ~/，查其他用户用 ~用户名。



运维常用组合 
1. 匹配多类后缀文件
# 基础写法
ls *.log *.txt *.conf
# 扩展通配符写法（更简洁）
ls *.@(log|txt|conf)

2. 查看所有隐藏文件（排除。和 ..）
ls -d .[!.]*
# - d只展示目录自身，不遍历目录内内容。

3. 排除某类文件批量操作
# 删除除配置文件外的所有文件（需extglob）
shopt -s extglob
rm !(*.conf|*.yaml)
场景：清理目录时保留核心配置，删除临时文件。

4. 批量备份配置文件
# 单个文件快速备份
cp nginx.conf{,.bak}
# 批量备份所有conf文件
for f in *.conf; do cp "$f"{,.bak}; done

5. 匹配数字 / 字母开头的文件
# 匹配纯数字开头的日志
ls [0-9]*.log
# 匹配大写字母开头的配置
ls [A-Z]*.conf

6. 递归批量查找文件
# 需globstar，替代 find . -name "*.log"
shopt -s globstar
ls -l **/*.log
场景：快速定位多层目录下的目标文件。


--------------------------------------------------------------------------
shopt 用来控制 Bash 通配、历史、命令纠错等 Shell 行为；最常用globstar递归遍历、extglob扩展通配、nullglob防止脚本误操作。
shopt          # 查看所有选项开关状态
shopt 选项名    # 单独查看某一个选项状态
shopt -s 选项名 # set 开启
shopt -u 选项名 # unset 关闭
shopt -q 选项名 # 静默查询，仅返回退出码（脚本用）

globstar
    开启：** 递归匹配所有层级目录文件；
    关闭：** 等价于 */*，仅匹配一级子目录。
extglob 开启扩展正则通配：?() *() +() @() !()，用于文件排除、多后缀匹配。
dotglob   默认*不匹配隐藏文件；开启后通配符可匹配.开头文件。
nullglob  通配符无匹配结果时返回空，不会把通配符当作普通字符串，避免 rm 误删。
nocaseglob  文件名通配匹配忽略大小写。
cdspell  cd 命令自动拼写错误纠错。

运维推荐常驻配置
shopt -s extglob globstar nullglob dotglob

cat >> ~/.bashrc <<'EOF'
shopt -s extglob
shopt -s globstar
shopt -s nullglob
shopt -s dotglob
EOF
source ~/.bashrc
----------------------------------------------------------------------------

Regular Expression，缩写：Regex / Regexp
中文：正则表达式、规则表达式

基础正则表达式
全称：Basic Regular Expression
缩写：BRE
扩展正则表达式
全称：Extended Regular Expression
缩写：ERE

# 2. 基础正则（grep、sed 默认支持）
^  行开头
$  行结尾
.  任意单个字符
*  前面字符出现0次或多次
[]   字符集合	
[^]   取反
\     转义符
\{n\} 前面字符精准n次
\{n,\} 至少n次
\{n,m\} n~m次

#组合示例
^$	组合符，表示空行
.*	组合符，匹配任意长度的任意字符
^.*	组合符，匹配任意多个字符开头的内容
.*$	组合符，匹配以任意多个字符结尾的内容
[abc]	匹配[]集合内的任意一个字符，a或b或c，可以写[a-c]
[^abc]	匹配除了^后面的任意字符，a或b或c，^表示对[abc]的取反

<pattern>	匹配完整的内容
<或>	定位单词的左侧，和右侧，如<chao> 可以找出"The chao ge"，缺找不出"yuchao"


# 3. 扩展正则（egrep/grep -E、sed -r、awk 默认支持）
+  前面字符至少1次
?  前面字符0或1次
() 分组 被括起来的内容表示一个整体
|  或者
{n} {n,} {,m} {n,m} 次数限定


组合:
[:/]+	匹配括号内的":"或者"/"字符1次或多次

次数限制说明
a{n}	匹配前一个字符正好n次
a{n,}	匹配前一个字符最少n次
a{,m}	匹配前一个字符最多m次
a{n,m}	匹配前一个字符最少n次，最多m次



```



## grep sed awk

```bash
grep 过滤筛选文本
全称：Global Regular Expression Print  中文：全局正则表达式打印
grep [选项] '匹配模式' 文件名
常用参数
-v：取反匹配   invert match
-i：忽略大小写   ignore case
-n：显示行号    line number
-c：统计匹配行数  count 
-o：只输出匹配到的内容  only matching 
-E：启用扩展正则（egrep）  extended regex 
-A n：匹配行后 n 行   after
-B n：匹配行前 n 行   before
-C n：前后各 n 行    context 
-r/-R：递归遍历目录  recursive 
-w：精确匹配单词     word regexp
-q：静默匹配，只返回退出码   quiet 

# 过滤日志关键词并显示前后 10 行
grep -C10 "error" app.log
# 统计报错行数
grep -ic "fail" app.log 
# 递归查找含指定内容的文件
grep -r "192.168.1.1" /etc/
# 排除注释行、空行
grep -v '^#' nginx.conf | grep -v '^$'

grep -nE "^[0-9]+" test.txt
grep "error" log1.log log2.log
ps -ef | grep java



sed 用法（流式编辑器：增删改查）  核心处理机制：逐行读取、模式空间处理
全称：Stream Editor   中文：流式编辑器
记忆：Stream（数据流、一行行流式读取）+ Editor（编辑器）
对应特点：逐行读取文本、流式处理，不用一次性加载整个文件，适合大文件批量处理（增删改查、替换）。

sed [OPTIONS] 'ADDR1[,ADDR2] COMMAND' file
参数 
-n：只输出匹配行   No automatic print（禁止自动打印）
-e：多个表达式   expression
-f：从脚本文件读取规则  file
-r/-E：扩展正则   extended-regexp，
-i：直接修改原文件；in-place(重定向;原地直接修改原文件) ;-i.bak 先备份再修改  
常用动作
p 打印  print
d 删除  delete 
s/旧/新/g    替换substitute ，g 全局 global
a 行后追加   appent
i 行前插入   insert
c 整行替换   change 
= 打印行号   print line number

# 无地址，全文执行动作
sed 's/old/new/g' test.txt
sed '5d' test.txt
sed -n '3,10p' test.txt
sed '/^#/d' nginx.conf
# -i.bak：先备份，匹配root的行整行替换
sed -i.bak '/root/c admin:x:0:0::/root:/bin/bash' /etc/passwd


# 全局替换，备份原文件
sed -i.bak 's/80/8080/g' nginx.conf
# 删除空行、注释行
sed '/^#/d;/^$/d' nginx.conf
# 在第 10 行前插入新行内容
sed -i '10i listen 80;' nginx.conf
# 只查看匹配行（不修改）
sed -n '/root/p' nginx.conf
# 只查看第5-10行
sed -n '5,10p' nginx.conf
# 截取指定时间段日志
sed -n '/2026-07-03 09:00/,/2026-07-03 10:00/p' app.log


awk 用法（列处理、统计、格式化输出）
取自三位开发者姓氏首字母：Aho、Weinberger、Kernighan  没有英文释义缩写，只能记来源；
定位：文本分析语言、列处理器
记忆：grep 擅长按行过滤、sed 擅长按行修改、awk 擅长按列截取 + 统计计算。

awk [OPTIONS] 'PATTERN {ACTION}' file1 file2...
三段式标准结构（核心）
awk '
BEGIN{ 初始化代码; 执行一次，读取文件前运行 }
PATTERN{ 逐行匹配执行 }
END{ 收尾代码; 所有文件读取完毕后执行一次 }
' 文件名
PATTERN：正则、数值判断、空（匹配所有行）
ACTION：print、循环、判断、格式化输出等代码块

结构:  awk 'BEGIN{初始化} 条件{执行动作} END{收尾}'

参数
-F：指定分隔符  --field-separator
-v：定义外部变量  
	在 awk 脚本执行前（包含BEGIN块）定义外部变量，用于把 Shell 变量传入 awk
	awk -v 变量名=值 '条件{动作}' 文件
	awk -v num=10 '$3>num' test.txt
-f：从脚本文件执行 file;    awk -f script.awk data.txt
高频内置变量
$0 整行
$1 $2 ... 第 1、2 列
NF 当前行总列数  Number of Fields $NF最后一列
NR 全局行号  Number of Records，全局总记录行号，多文件持续累加
FNR 单个文件行号  File Number of Records，单个文件独立行号，新文件从 1 重新计数
FS 输入分隔符   Field Separator，输入字段分隔符，默认空格 / 制表符
OFS 输出分隔符  Output Field Separator，输出字段分隔符，默认空格
RS：Record Separator，输入记录（行）分隔符，默认换行
ORS：Output Record Separator，输出行分隔符，默认换行

一、AWK 核心处理流程
执行 BEGIN{} 代码块（文件读取前，仅执行 1 次）
初始化变量、设置分隔符 FS/OFS、打印表头、预处理等
循环逐行读取文件每一条记录
按照FS（输入分隔符）把当前行$0切割为$1、$2...$NF字段
判断当前行是否匹配PATTERN（条件 / 正则）
匹配成功则执行{ACTION}动作块
文件所有行遍历结束后，执行一次 END{} 代码块
做汇总、统计、结果输出等收尾操作

# -F 参数 和 内置变量 FS; 本质完全等价，都是用来设置输入字段分隔符
# 写法1：命令行 -F 指定分隔符
awk -F: '{print $1}' /etc/passwd
# 写法2：BEGIN中手动赋值FS，效果完全一致
awk 'BEGIN{FS=":"} {print $1}' /etc/passwd


# 查看系统连接状态统计（netstat/ss）
netstat -ant | awk 'NR>2{print $6}'| sort|uniq -c|sort -rn
#前两行不要的其他方式 
netstat -ant | sed '1,2d' | awk '{print $6}'
netstat -ant | tail -n +3 | awk '{print $6}'
# 统计内存使用率
free -m | awk 'NR==2{print $3/$2*100"%"}'
# 过滤第三列大于 100 的行
awk '$3>100' test.txt
# 多分隔符筛选字段
awk -F '[ :\t]' '{print $1,$5}' info.txt
# 多分隔符匹配
awk -F '[ :]' '{print $1,$4}' test.txt
# 打印第1、第5列
awk '{print $1,$5}' access.log
# 过滤连接数，统计IP访问量
awk '{print $1}' access.log |sort|uniq -c|sort -nr|head -10



三剑客组合运维高频套路
# 批量杀进程
ps -ef | grep java | grep -v grep | awk '{print $2}' | xargs kill -9
# Nginx 访问 IP TOP20 统计
grep "200" access.log | awk '{print $1}' | sort | uniq -c | sort -nr | head -20
# 清理配置注释空行并批量替换参数
sed '/^#/d;/^$/d' nginx.conf | sed 's/worker_connections 1024/worker_connections 2048/g'


-----------------------------------------------------------------------
xargs
将管道输出的标准输入转换成命令的参数，解决很多命令不支持管道接收数据的问题。

全称 + 记忆技巧
xargs = extended arguments   中文：扩展参数
记忆口诀：x（扩展）+ args（arguments 参数）→ 把标准输入扩展成命令行参数。

常用参数
-n num：每次传递num个参数执行一次命令
-d '分隔符'：自定义分隔符（默认空格、换行）
-I {}：用{}占位接收参数，可在命令任意位置使用
-0：配合find -print0，处理带空格、特殊字符的文件名

常用示例
# 批量杀进程
ps -ef | grep java | grep -v grep | awk '{print $2}' | xargs kill -9
# 每次传2个参数删除文件
ls | xargs -n 2 rm -f
# 占位批量重命名 #当前目录所有 .log 文件，统一重命名为 .log.bak
find . -maxdepth 1 -name "*.log" | xargs -I {} mv {} {}.bak
# 拆解说明
-I {}：{} 是占位符，每拿到一个文件名就放到 {} 的位置
mv {} {}.bak
第一个{} = 原文件名（如app.log）
第二个{} = 原文件名，拼接后缀.bak
执行后：app.log → app.log.bak
----------------------------------------------------------------


```



## awk语言详细介绍

**AWK 是一门完备的文本处理型编程语言（属于解释型脚本语言）**，满足编程语言核心要素：

变量、数据类型、分支、循环、数组、函数、输入输出、格式化、正则内置支持，自带语法体系，可独立写复杂业务脚本，并非单纯命令过滤工具。

### 1. 数据类型

AWK 只有两种基础类型，会自动隐式转换：

1. **字符串类型**（默认所有内容都是字符串）

2. 数值类型

   （参与四则运算时自动转为数字）

   无布尔类型：

   ```
   0、空字符串
   ```

    为假；非 0、非空字符串为真。

### 2. 核心数据结构：关联数组（唯一原生数据结构）

AWK 只有一种数据结构：**关联数组（Associative Array）**

- 下标可以是**数字 / 字符串**，不需要提前声明长度，自动扩容；
- 典型用途：统计 IP、日志计数、去重、键值存储；

```
# 语法：数组名[下标]=值
ip_arr[$1]++
# 遍历数组
for(key in ip_arr){print key,ip_arr[key]}
```

- 无普通顺序数组、链表、哈希表等，全部基于关联数组实现。

### 3. 变量分类

1. **内置全局变量**：NR、NF、FS、OFS、RS、ORS、FILENAME 等，全局生效；
2. **自定义全局变量**：脚本直接定义，默认全局；
3. **局部变量**：仅在自定义函数内部用 `local` 声明（gawk 支持）；
4. **外部传入变量**：`-v` 从 Shell 传入。

### 4. 流程控制语句

#### （1）分支判断

```awk
# if单分支
if(条件){动作}

# if-else
if(条件){
}else{
}

# 多分支 else if
if(){}else if(){}else{}

# 三元运算符
max = a>b ? a : b
```

#### （2）循环

```awk
# while循环
while(条件){}

# do while 先执行再判断
do{}while(条件)

# for数值循环
for(i=1;i<=10;i++){}

# for遍历关联数组（固定语法）
for(key in arr){}
```

#### （3）循环控制关键字

`break`：跳出当前循环

`continue`：跳过本次循环，进入下一次迭代

### 5. 函数体系

1. 内置函数

   字符串：

   ```
   sub/gsub/index/length/split/tolower/toupper
   ```

   数值：

   ```
   int/sqrt/rand/srand
   ```

2. **自定义函数**

```bash
func add(a,b){
    return a+b
}
```

### 6. 输入输出基础

- `print`：简单输出
- `printf`：格式化输出（% d % s %.2f）
- 支持重定向 `> >> |`

### 7. AWK 完整执行流回顾

```
BEGIN{}` → 逐行循环（分割字段→条件匹配→执行动作） → `END{}
```

## 二、AWK vs Shell 编程 核心区别对比

### 1. 设计定位

- **AWK**：专门面向 ** 结构化文本（按列）** 处理、日志统计、数据格式化、聚合分析，内置正则 + 关联数组，擅长行列数据计算。
- **Shell（Bash）**：系统交互脚本，擅长调用 Linux 命令、流程调度、文件操作、服务启停、循环执行系统指令，通用运维编排。

### 2. 数据处理能力

- AWK：原生列分割、内置高效关联数组，海量日志统计性能远高于 Shell；自动字符串 / 数字隐式转换，数学计算友好。
- Shell：默认按行处理，数组仅支持数字下标，统计需要大量管道组合，大数据量效率低；数值计算需要依赖 `bc`/`expr`。

### 3. 正则支持

- AWK：默认**扩展正则**，语法简洁，正则性能强，适合批量文本匹配提取。
- Shell：原生基础正则，高级正则需要调用 `grep/sed` 外部命令。

### 4. 运行效率

- 大文件（百万行日志）：AWK >> Shell

  AWK 单次进程遍历文件；Shell 多次管道会创建多个子进程，频繁 IO 开销大。

### 5. 适用场景

### AWK 适合

1. 日志字段提取、IP / 接口访问量统计、去重排序聚合
2. 格式化输出报表、内存 / 磁盘 / 连接数计算
3. 结构化配置文件（passwd、nginx 配置）列处理

### Shell 适合

1. 批量执行命令、文件遍历备份、定时任务
2. 服务启停、容器编排、多脚本调度
3. 交互式操作、判断文件状态、循环调用工具

### 6. 语法差异

1. AWK 变量直接使用，不用 `$` 赋值，取值部分场景需要；Shell 变量赋值不能加`$`，取值必须`$变量`。
2. AWK 条件不需要 `[]`；Shell `if` 判断必须 `[ ]`/`[[ ]]`。
3. AWK 内置格式化`printf`；Shell 格式化能力弱。

### 7. 相互配合关系

二者互补，不是替代：

- Shell 负责流程调度，把文本交给 AWK 做数据清洗统计；
- AWK 算出结果后，交给 Shell 做后续运维操作（如批量告警、清理）。

### 三、极简总结

1. AWK 是完备编程语言，只有**字符串、数字**两种类型，唯一数据结构是**关联数组**；
   - shell只有字符串类型,(整数计算是临时隐式转换) ; 数据结构: 普通索引数组和关联数组
2. 拥有 if/for/while、switch case, 自定义函数、格式化 IO，擅长结构化文本统计；
3. Shell 侧重系统命令调度，AWK 侧重行列数据聚合，运维中经常搭配使用。





## Vim 新建脚本自动模板（企业最通用）



```bash
# 创建模板文件
mkdir -p ~/.vim/templates
cat <<\EOF > ~/.vim/templates/shell.sh
#!/bin/bash
# ==============================================================================
# Author: 
# Create Date:     $(date +%Y-%m-%d)
# Version:         V1.0
# Description:     
# Copyright:       All Rights Reserved
# ==============================================================================
set -euo pipefail
IFS=$'\n\t'

# 脚本业务逻辑开始
EOF
# set -euo pipefail
# -e：命令失败直接退出脚本
# -u：使用未定义变量直接报错退出
# -o pipefail：管道任意命令失败，整条管道判定失败

# IFS=$'\n\t'
# 仅用换行、制表符做分隔符，避免带空格的文件/字符串遍历错乱

# 配置 vim 自动加载模板
cat >> ~/.vimrc <<'EOF'
" 新建sh脚本自动加载模板
autocmd BufNewFile *.sh 0r ~/.vim/templates/shell.sh
" 新建后光标定位到作者那一行尾，方便直接编辑
autocmd BufNewFile *.sh normal 3G$
EOF

# 4.生效vim配置
vim +source ~/.vimrc +q

# 方式2：管道echo给vim执行（更直观）
# vim -c "source ~/.vimrc" -c "q"

-------------------------------------------------------上面方式时间不会自动更改
#清空配置文件
> ~/.vimrc
# 写入Shell头部自动生成函数
cat >> ~/.vimrc <<'EOF'
func SetShellHeader()
    call setline(1,"#!/bin/bash")
    call setline(2,"# ==============================================================================")
    call setline(3,"# Author:          ")
    call setline(4,"# Create Date:     ".strftime("%Y-%m-%d"))
    call setline(5,"# Version:         V1.0")
    call setline(6,"# Description:     ")
    call setline(7,"# Copyright:       All Rights Reserved")
    call setline(8,"# ==============================================================================")
    call setline(9,"set -euo pipefail")
    call setline(10,"IFS=\$'\\n\\t'")
    call setline(11,"")
    execute "normal! 3G\$A"
endfunc

autocmd BufNewFile *.sh call SetShellHeader()
EOF

vim +source ~/.vimrc +q


```









## Shell数组相关企业面试题及高级实战案例

### 范例13_4：利用bash for循环打印下面这句话中字母数不大于6的单词（某企业面试真题）。

```bash
I am ckhedu teacher welcome to ckhedu training class
解答思路：
1）先把所有的单词放到数组里，然后依次进行判断。命令如下：
array=(I am ckhedu teacher welcome to ckhedu training class)
2）对变量内容计算长度，这在前文已经讲解过了。常见方法有4种：
char=ckhedu
echo $char|wc -L

echo ${#char}

expr length $char

echo $char|awk '{print length}'

```



方法1：通过数组方法实现。

```bash
arr=(I am ckhedu teacher welcome to ckhedu training class)
for ((i=0;i<${#arr[*]};i++))
do 
    if [ ${#arr[$i]} -le 6 ]
      then
        echo "${arr[$i]}"
    fi
done
echo -----------------------
for word in ${arr[*]}
do
    if [ `expr length $word` -le 6 ];then
        echo $word
    fi
done
说明：本例给出了两种for循环语法打印数组元素的方法。        
```

方法2：使用for循环列举取值列表法

```bash
for word in I am ckhedu teacher welcome to ckhedu training class  #<==看起来有点low吧。
do
    if [ `echo $word|wc -L` -le 6 ];then
        echo $word
    fi
done

chars="I am ckhedu teacher welcome to ckhedu training class"      #<==定义字符串也可以。
for word in $chars
do
    if [ `echo $word|wc -L` -le 6 ];then
        echo $word
    fi
done
```

方法3：通过awk循环实现。

```bash
chars="I am ckhedu teacher welcome to ckhedu training class"
echo $chars|awk '{for(i=1;i<=NF;i++) if(length($i)<=6)print $i}'

```

### 范例13_5：批量检查多个网站地址是否正常 

要求：
1）使用Shell数组方法实现，检测策略尽量模拟用户访问。
2）每10秒钟做一次所有的检测，无法访问的输出报警。
3）待检测的地址如下。
http://blog.ckheduedu.com
http://blog.etiantian.org
http://ckhedu.blog.51cto.com
http://172.16.1.7

解题思路：
1）把URL定义成数组，形成函数。
2）编写URL检查脚本函数，传入数组的元素，即URL。
3）组合实现整个案例，编写main主函数（即执行函数），每隔10秒检查一次。
下面的参考答案采用了Shell数组方法，同时检测多个URL是否正常，并给出专业的展示效果

```bash
[root@ckhedu scripts]# cat 10_7_2.sh
#!/bin/bash
# this script is created by ckhedu.
# e_mail:343264992@qq.com
# function:case example
# version:1.3
. /etc/init.d/functions
check_count=0
url_list=(         #<==定义检测的URL数组，包含多个URL地址。
http://blog.ckheduedu.com
http://blog.etiantian.org
http://ckhedu.blog.51cto.com
http://172.16.1.7
)

function wait()    #<==定义3,2,1倒计时函数。
{
    echo -n '3秒后,执行检查URL操作.';
    for ((i=0;i<3;i++))
    do
        echo -n ".";sleep 1
    done
    echo
}
function check_url()  #<==定义检测URL的函数。
{
    wait              #<==执行倒计时函数。
    for ((i=0; i<`echo ${#url_list[*]}`; i++))    #<==循环数组元素。
    do
    wget -o /dev/null -T 3 --tries=1 --spider ${url_list[$i]} >/dev/null 2>&1   #<==检测是否可以访问数组元素的地址。
    if [ $? -eq 0 ]   #<==如果返回值为0，表示访问成功。
          then
            action "${url_list[$i]}" /bin/true   #<==优美的显示成功结果。
    else
            action "${url_list[$i]}" /bin/false  #<==优美的显示失败结果。
    fi
    done
    ((check_count++))  #<==检测次数加1。
}
main(){                #<==定义主函数。
    while true         #<==开启一个持续循环。
    do
        check_url      #<==加载检测url的函数。
        echo "-------check count:${check_count}---------"
        sleep 10       #<==间歇10秒。
    done
}
main                   #<==优美的显示成功结果，调用主函数运行程序。


# wget参数精简说明
# -o /dev/null：将wget日志输出到黑洞
# -T 3：超时时间3秒
# --tries=1：仅重试1次（失败不重复请求）
# --spider：爬虫模式，只检测URL是否可访问，不下载文件
# >/dev/null 2>&1：标准输出、标准错误全部丢弃


可将颜色这类通用基础函数抽离到独立函数文件（如/etc/init.d/functions），主脚本通过引入调用，实现代码解耦、结构整洁，这也是大型程序常用开发方式。
```



### 范例13_6：开发一个守护进程脚本，每30秒监控MySQL主从复制是否异常（包括不同步以及延迟），如果异常，则发送短信并发送邮件给管理员存档（此为生产实战案例）。

提示：如果没主从复制的环境，可以把下面的文本放到文件里读取来模拟主从复制状态：

```
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 172.16.1.51 
                  Master_User: rep
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000013
          Read_Master_Log_Pos: 502547
               Relay_Log_File: relay-bin.000013
                Relay_Log_Pos: 251
        Relay_Master_Log_File: mysql-bin.000013
             Slave_IO_Running: Yes  #<==IO线程状态必须为Yes
            Slave_SQL_Running: Yes  #<==SQL线程状态必须为Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: mysql
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 502547
              Relay_Log_Space: 502986
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0   #<==和主库比同步延迟的秒数，这个参数很重要。
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error:                   
```



```
解题思路：
1）判断主从复制是否异常，主要就是检测如下参数对应的值是否和如下一致。
Slave_IO_Running: Yes  #<==IO线程状态必须为Yes。
Slave_SQL_Running: Yes  #<==SQL线程状态必须为Yes。
Seconds_Behind_Master: 0     #<==和主库比同步延迟的秒数，这个参数很重要。
2）读取状态数据或状态文件，然后取出对应值，和正确时的值进行比对，如果不符合就表示故障了，即调用报警脚本报警。
3）为了更专业，还可以在当主从不同步时，查看相应错误号，判断对应错误号以进行自动恢复主从复制故障（这些错误号也可以通过配置文件里配置参数实现自动忽略故障）。


```



```bash
cat <<\EOF > slave.log
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 172.16.1.51 
                  Master_User: rep
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000013
          Read_Master_Log_Pos: 502547
               Relay_Log_File: relay-bin.000013
                Relay_Log_Pos: 251
        Relay_Master_Log_File: mysql-bin.000013
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: mysql
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 502547
              Relay_Log_Space: 502986
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error:
EOF

```

然后开发脚本，开发脚本有多种方法，下面分别给出。
方法1：

```bash
# awk -F ': ' '/_Running|_Behind/{print $NF}' slave.log
#<==获取所有复制相关的状态值。
Yes
Yes
0
[root@ckhedu scripts]# cat 13_6_1.sh
count=0
status=($(awk -F ': ' '/_Running|_Behind/{print $NF}' slave.log)) #<==获取所有复制相关的状态值赋值给数组status。
for((i=0;i<${#status[*]};i++)) #<==循环数组元素。
do
    if [ "${status[${i}]}" != "Yes" -a "${status[${i}]}" != "0" ] #<==如果数组元素值不为Yes并且不为0任意一个，那就表示复制出故障了。
      then
        let count+=1                 #<==错误数加1。
    fi
done
if [ $count -ne 0 ];then              #<==只要错误数不等于0，就表示状态值肯定有有问题的。
    echo "mysql replcation is failed" #<==提示复制出现问题。
else
    echo "mysql replcation is sucess" #<==否则提示复制正常。
fi


```

测试结果如下：

```bash
[root@ckhedu scripts]# sh 13_6_1.sh   
mysql replcation is sucess
[root@ckhedu scripts]# sed -i 's#Slave_IO_Running: Yes#Slave_IO_Running: No#g' slave.log  #<==提模拟IO线程故障。
[root@ckhedu scripts]# sh 13_6_1.sh
mysql replcation is failed

```

方法2：本方法和方法1实现的功能差不多，但是开发手法就更高大上一些。

```bash
[root@ckhedu scripts]# cat 13_6_2.sh
#!/bin/bash
CheckDb(){
  count=0
status=($(awk -F ': ' '/_Running|_Behind/{print $NF}' slave.log))
for((i=0;i<${#status[*]};i++))
do
      if [ "${status[${i}]}" != "Yes" -a "${status[${i}]}" != "0" ]
      then
        let count+=1
    fi
done
if [ $count -ne 0 ];then
   echo "mysql replcation is failed"
    return 1
else
    echo "mysql replcation is sucess"
    return 0
fi
}
main(){
while true
do
         CheckDb
         sleep 3
done
}
main


```

测试结果如下：

```bash
[root@ckhedu scripts]# sed -i 's#Slave_IO_Running: No#Slave_IO_Running: Yes#g' slave.log  #<==模拟IO线程恢复正常。
[root@ckhedu scripts]# sh 13_6_2.sh 
mysql replcation is sucess
mysql replcation is sucess
mysql replcation is sucess
^C
[root@ckhedu scripts]# sed -i 's#Slave_IO_Running: Yes#Slave_IO_Running: No#g' slave.log  #<==提示复制出现问题。
[root@ckhedu scripts]# sh 13_6_2.sh 
mysql replcation is failed
mysql replcation is failed
^C

```

方法3（此为企业生产正式检查脚本）：

```bash
[root@ckhedu scripts]# cat 13_6_3.sh
#!/bin/bash
###########################################
# this script function is :
# check_mysql_slave_replication_status
# USER        YYYY-MM-DD - ACTION
# ckhedu      2009-02-16 - Created
############################################
path=/server/scripts  #<==定义脚本存放路径，大家注意这个规范。
MAIL_GROUP="1111@qq.com 2222@qq.com"   #<==邮件列表，以空格隔开。
PAGER_GROUP="18600338340 18911718229"  #<==手机列表，以空格隔开。
LOG_FILE="/tmp/web_check.log"  #<==日志路径。
USER=root  #<==数据库用户。
PASSWORD=ckhedu123  #<==用户密码。
PORT=3307 #<==端口。
MYSQLCMD="mysql -u$USER -p$PASSWORD -S /data/$PORT/mysql.sock" #<==登录数据库命令。
error=(1008 1007 1062) #<==可以忽略的主从复制错误号。
RETVAL=0
[ ! -d "$path" ] && mkdir -p $path
function JudgeError(){  #<==定义判断主从复制错误的函数。
    for((i=0;i<${#error[*]};i++))
    do
        if [ "$1" == "${error[$i]}" ] #<==如果传入的错误号和数组里的元素匹配，则执行then后命令。
          then
            echo "MySQL slave errorno is $1,auto repairing it."
            $MYSQLCMD -e "stop slave;set global sql_slave_skip_counter=1;start slave;" #<==自动修复。
        fi
    done
    return $1
}
function CheckDb(){ #<==定义检查数据库主从复制状态的函数。
status=($(awk -F ': ' '/_Running|Last_Errno|_Behind/{print $NF}' slave.log))
    expr ${status[3]} + 1 &>/dev/null #<==这个是延迟状态值，进行是否为数字判断。
    if [ $? -ne 0 ];then #<==如果不为数字。
        status[3]=300 #<==赋值300，当数据库出现复制故障时，延迟这个状态值有可能是NULL，即非数字。
    fi
    
    if [ "${status[0]}" == "Yes" -a "${status[1]}" == "Yes" -a ${status[3]} -lt 120 ]
 #<==两个线程都为Yes，并且延迟小于120秒，即认为复制状态是正常的。
      then
        #echo "Mysql slave status is ok"
        return 0 #<==返回0。
    else
        #echo "mysql replcation is failed"
        JudgeError ${status[2]} #<==否则将错误号${status[2]}，传入JudgeError函数，判断错误号是否可以自动修复。
    fi
}
function MAIL(){            #<==定义邮件函数，在范例11_13讲过此函数。
local SUBJECT_CONTENT=$1    #<==函数的第一个传参赋值给主题变量。
for MAIL_USER  in `echo $MAIL_GROUP` #<==遍历邮件列表。
do
    mail -s "$SUBJECT_CONTENT " $MAIL_USER <$LOG_FILE #<==发邮件。
done
}
function PAGER(){  #<==定义手机函数，在范例11_13讲过此函数。
    for PAGER_USER  in `echo $PAGER_GROUP` #<==遍历手机列表。
    do
        TITLE=$1     #<==函数的第一个传参赋值给主题变量。
        CONTACT=$PAGER_USER  #<==手机号赋值给CONTACT变量。
        HTTPGW=http://ckhedu.sms.cn/smsproxy/sendsms.action #<==发短信地址，这个地址需要用户付费购买的，如果免费的就得用139，微信替代了。
        #send_message method1
        curl -d  cdkey=5ADF-EFA -d password=ckhedu -d phone=$CONTACT -d message="$TITLE[$2]" $HTTPGW
#<==发送短信报警的命令。cdkey是购买短信网关时，售卖者给的，password是密码，也是售卖者给的。
    done
}
function SendMsg(){
    if [ $1 -ne 0 ] #<==传入$1，如果不为0表示复制有问题，这里的$1即CheckDb里的返回值（用检测失败的次数作为返回值）,在后文主函数main执行时调用SendMsg传参时传进来。
      then 
        RETVAL=1
        NOW_TIME=`date +"%Y-%m-%d %H:%M:%S"`#<==报警时间。
        SUBJECT_CONTENT="mysql slave is error,errorno is $2,${NOW_TIME}."#<==报警主题。
        echo -e "$SUBJECT_CONTENT"|tee $LOG_FILE #<==输出信息，并记录到日志。
        MAIL $SUBJECT_CONTENT #<==发邮件报警，$SUBJECT_CONTENT作为函数参数传给MAIL函数体的$1。
        PAGER $SUBJECT_CONTENT $NOW_TIME #<==发短信报警，$SUBJECT_CONTENT作为函数参数传给MAIL函数体的$1，$NOW_TIME作为函数体传给$2。
    else
        echo "Mysql slave status is ok"
        RETVAL=0 #<==以0作为返回值。
    fi
    return $RETVAL
}
function main(){
while true
do
      CheckDb
      SendMsg $?   #<==传入第一个参数$?，即CheckDb里的返回值（用检测失败的次数作为返回值）。
      sleep 300
done
}
main      


```



## shell实战企业面试题

### 面试题 1：批量生成随机字符文件名案例

```bash
使用 for 循环在/eric 目录下批量创建 10个html文件，其中每个文件需要包含10个随机
小写字母加固定字符串 eric，创建的结果名称示例如下：
[root@oldgirl C19]# ls /eric
apquvdpqbk_eric.html mpyogpsmwj_eric.html txynzwofgg_eric.html
bmqiwhfpgv_eric.html mtrzobsprf_eric.html vjxmlflawa_eric.html
jhjdcjnjxc_eric.html qeztkkmewn_eric.html
jpvirsnjld_eric.html ruscyxwxai_eric.html

解答：
思路分析：
1、本题第一步核心是：创建 10 个随机小写字母
生成随机数的 7 种方法：
1）echo $RANDOM 范围是 0-32767
2）openssl rand -base64 100
3）date +%s%N
4）head /dev/urandom|cksum
5）uuidgen
6）cat /proc/sys/kernel/random/uuid
7）mkpasswd(yum install expect -y)

示例：
[root@web01 ~]# mkpasswd -l 20 -d 10 -C 5 -c 3 -s 2
71r1-17A7R8x38U"r5HZ
-l 长度
-d 数字
-c 小写字母
-C 大写字母
-s 特殊字符

2、获取到随机 10 个小写字母
[root@web01 ~]# echo "eric$RANDOM"|md5sum|tr "0-9" "m-z"|cut -c 2-11
mtbrdbrpbq

# tr = translate（也可称 transliterate），意思：字符转换、字符映射。
# tr "0-9" "m-z"：把输入里所有数字替换成m到z的字母
# cut -c 2-11：截取每行第2到第11个字符


3、for 循环创建
[root@web01 eric_shell_14]# cat 03_01.sh
#!/bin/bash
##############################################################
# File Name: 03_01.sh
# Version: V1.0
# Author: eric
# Organization: www.ericedu.com
# Created Time : 2018-06-13 22:16:59
##############################################################
path=/eric
[ -d $path ]||mkdir $path
for n in {1..10}
do
random=`echo "eric$RANDOM"|md5sum|tr "0-9" "m-z"|cut -c 2-11`
touch $path/${random}_eric.html
done



```

### 面试题 2：批量改名特殊案例

```bash
将以上面试题 1 中结果文件名中的 eric 字符串全部改成 oldgirl(最好用 for 循环实
现),并且将扩展名 html 全部改成大写。
解答：
思路分析：
1、 要改所有，先缩小改一个。
拼接的目标：mv arqordoamn_eric.html arqordoamn_oldgirl.HTML

file=arqordoamn_eric.html
mv $file `echo ${file/eric.html/oldgirl.HTML}`

```

2、 如果修改所有那就用 for 循环
方法 1：for 循环
方法 2：拼接法：

```bash
[root@web01 eric]# ls *.HTML|awk -F "oldgirl.HTML" '{print "mv",$0,$1"eric.html"}'|bash
[root@web01 eric]# ls
madoqdrpqo_eric.html rnpeusurmf_eric.html vavftumomu_eric.html
arqordoamn_eric.html maoopfqrbv_eric.html smnbvqdtfo_eric.html
bqfmsrvabs_eric.html perpcvaaor_eric.html sqnvmptfuu_eric.html
ccrcpdovam_eric.html rmdqptfetm_eric.html


# for循环
#!/bin/bash
path=/eric
for file in `ls ${path}`
do
  cd $path
  mv $file `echo ${file/eric.html/oldgirl.HTML}`
done

```

方法 3：

```bash
rename "eric.html" "oldgirl.HTML" *.html

```



### 3：批量创建特殊要求用户案例

```bash
批量创建 10 个系统帐号 eric01-eric10 并设置密码（密码为随机数，要求字符和数等混合）。
不用 for 循环的实现思路参考:

方法1：
echo stu{01..10}|tr " " "\n"|sed -r 's#(.*)#useradd \1 ; pass=$((RANDOM+10000000)); echo "$pass"|passwd --stdin \1; echo -e "\1 \t `echo "$pass"`">>/tmp/eric.log#g'|bash

上述命令实际就是再拼N条下面的命令的组合，举一条命令stu01用户的过程拆解如下：
useradd stu01 ;
pass=$((RANDOM+10000000));
echo "$pass"|passwd --stdin stu01;
echo -e "stu01	`echo "$pass"`">>/tmp/eric.log
特别说明：如果用shell循环结构会更简单，

方法2：
echo stu{11..12}|xargs -n1 useradd ;echo stu{11..12}:`cat /dev/urandom|tr -dc 0-9|fold -w8|head -1`|xargs -n1|tee -a pass.txt|chpasswd

说明:
tr -dc 0-9  # 删除不是0-9的字符 
fold #限制文件列宽

方法3：
有个参数写错了， cut时应该取第二个字段 应是 -f2  结果应该是这样: 
echo stu{21..30} | tr ' ' '\n' | sed -e 's/^/useradd /' -e 's/\(stu[0-9]\{2\}\)$/\1 \&\& echo "\1:`echo $[$RANDOM**3] | cut -c1-8`" | tee -a userInfo.txt | cut -d: -f2 | passwd --stdin \1/' | bash
功能: 创建10个用户 分别是 stu21-stu30 其密码是用随机数变量RANDOM生成，均保存至 userInfo.txt中，
格式: username:passwd   这个写的不算好  如果有更好的一定要分享哦！  上面的随机数 我之前是用日期生成的，是不对的，因为有可能会有重复现象，所以我后来干脆用RANDOM**3取其前8位，可确保唯一性

方法4:
echo stu{01..10} |tr ' ' '\n'|sed -rn 's@^(.*)$@useradd \1 ; echo $RANDOM|md5sum|cut -c 1-8 >/data/\1;cat /data/\1|passwd --stdin \1@gp'|bash

```

解答：


```bash
分析：
1）01..10
[root@web01 ~]# echo {01..10}
01 02 03 04 05 06 07 08 09 10
[root@web01 ~]# seq -w 10
01
02
03
04
05
06
07
08
09
10
2）随机数 有很多种
openssl rand -base64 100
3）创建用户密码
useradd eric01
echo 密码|passwd --stdin
方法 2：chpasswd 设置密码
格式要符合下面的形式
eric01:passwd
eric02:passwd
4）for 循环

#!/bin/bash
##############################################################
# File Name: 14_03_01.sh
# Version: V1.0
# Author: eric
# Organization: www.ericedu.com
# Created Time : 2018-06-14 03:52:23
##############################################################
for n in {01..10}
do
pass=`openssl rand -base64 10`
useradd eric$n
echo $pass|passwd --stdin eric$n
echo -e "eric$n\t$pass" >>/tmp/user.list
done
```

```bash
#!/bin/bash
##############################################################
# File Name: 14_03_01.sh
# Version: V1.0
# Author: eric
# Organization: www.ericedu.com
# Created Time : 2018-06-14 03:52:23
# Description:
##############################################################
for n in `seq -w 11 15`
do
pass=`openssl rand -base64 10`
useradd eric$n
echo "eric$n:$pass" >>/tmp/chpasswd.log
done
chpasswd </tmp/chpasswd.log
```

```bash
#!/bin/bash
##############################################################
# File Name: 14_03_01.sh
# Version: V1.0
# Author: eric
# Organization: www.ericedu.com
# Created Time : 2018-06-14 03:52:23
# Description:
##############################################################
. /etc/init.d/functions
if [ $UID -ne 0 ]
then
    echo "必须用 root 执行本脚本"
    exit 1
fi

for n in {23..29}
do
    pass=`openssl rand -base64 10`
    if [ `grep -w "eric$n" /etc/passwd|wc -l` -eq 0 ]
        then
            useradd eric$n &>/dev/null &&\
            echo $pass|passwd --stdin eric$n &>/dev/null &&\
            echo -e "eric$n\t$pass" >>/tmp/user.list &&\
            action "eric$n is successful." /bin/true
        else
        	action "eric$n is exist." /bin/false
    fi
done
```

### 面试题 4：扫描网络内存活主机案例

```bash
写一个 Shell 脚本，判断 172.16.1.0/24 网络里，当前在线的 IP 有哪些？
解答：
1） 如何判断主机存活
ping 172.16.1.7

ping -c 2 -i 1 -w 3 172.16.1.7
# -c 2：发送2个数据包
# -i 1：数据包间隔1秒
# -w 3：总超时3秒

nmap -sP 172.16.1.0/24
# 网络扫描工具，用于探测网段存活主机、开放端口、服务版本等。
# -sP：ping扫描，只检测主机是否存活，不扫描端口
# 172.16.1.0/24：扫描该C段整个网段所有主机

2） 最终实现答案
[root@ansible script]# nmap -sP 10.0.0.0/24

Starting Nmap 6.40 ( http://nmap.org ) at 2026-07-02 23:42 CST
Nmap scan report for 10.0.0.1
Host is up (0.00080s latency).
MAC Address: 00:50:56:C0:00:08 (VMware)
Nmap scan report for 10.0.0.254
Host is up (0.0010s latency).
MAC Address: 00:50:56:EC:5C:D5 (VMware)
Nmap scan report for 10.0.0.6
Host is up.
Nmap done: 256 IP addresses (3 hosts up) scanned in 4.98 seconds

# nmap -sP 10.0.0.0/24 | awk '/for/{print $NF}'
# /for/：正则匹配包含for的行（nmap输出中存活主机行带有for）
# print $NF：打印当前行最后一列字段（目标IP地址）


```



方法 2：

```bash
[root@web01 eric_shell_14]# cat 14_04_01.sh
#!/bin/bash
##############################################################
# File Name: 14_04_01.sh
# Version: V1.0
# Author: eric
# Organization: www.ericedu.com
# Created Time : 2018-06-14 04:54:00
##############################################################
for n in {1..254}
do
  if `ping -c 1 -w 3 172.16.1.$n &>/dev/null`
  then
    echo "172.16.1.$n is up."
  else
    echo "172.16.1.$n is down"
  fi
done

[root@web01 eric_shell_14]# cat 14_04_02.sh
#!/bin/bash
##############################################################
# File Name: 14_04_01.sh
# Version: V1.0
# Author: eric
# Organization: www.ericedu.com
# Created Time : 2018-06-14 04:54:00
##############################################################
for n in {1..254}
do
  {
  if `ping -c 1 -w 3 172.16.1.$n &>/dev/null`
  then
    echo "172.16.1.$n is up."
  else
    echo "172.16.1.$n is down"
  fi
  } &
done

------
{}：把多条命令打包成一组命令块，当成一个整体执行；
&：放到后台异步运行，不阻塞循环，实现并发批量 ping 扫描。

# 大括号后台并发（当前写法，最常用）
for i in {1..100}
do
{
  任务命令
} &
done
wait  # 等待所有后台子进程全部执行完毕再往下走


# ()子 shell 后台执行
(任务命令) &



```

### 面试题 5：解决 DOS 攻击生产案例



```bash
写一个 Shell 脚本解决 DOS 攻击生产案例。
请根据 web 日志或者或者网络连接数，监控当某个 IP 并发连接数或者短时内 PV 达到 100
（读者根据实际情况设定），即调用防火墙命令封掉对应的IP。
防火墙命令为：iptables -I INPUT -s IP 地址 -j DROP。

解答：
DOS Deny Of Service
DDOS
分析：
1、封 ip 的命令
iptables -I INPUT -s IP 地址 -j DROP。

2、web 日志或者或者网络连接数
日志文件，netstat -an|grep -i est，排序去重。
判断 pv 或者链接数大于 100，取出 Ip 让后封

参考答案 1
#!/bin/bash
##########################################
# File Name: 14_10_01.sh
# Version: V1.0
# Author: eric
# Organization: www.ericedu.com
##########################################
awk '{S[$1]++}END{for(key in S) print S[key],key}' access_2010-12-8.log|sort -rn|head >/tmp/ip.log

while read line
do
    ip=`echo $line|awk '{print $2}'`
    count=`echo $line|awk '{print $1}'`
    if [ $count -gt 100 -a `grep "$ip" /tmp/drop.log|wc -l` -lt 1 ]
    then
        iptables -I INPUT -s $ip -j DROP &&\
        echo "$ip" >>/tmp/drop.log
    else
        echo "$ip" >>/tmp/accept.log
    fi
done</tmp/ip.log

```

参考答案 2：

```bash
#!/bin/bash
##########################################
# File Name: 14_10_01.sh
# Version: V1.0
# Author: eric
# Organization: www.ericedu.com
##########################################
awk '/ESTAB/{print $0}' netstat.log |awk -F "[ :]+" '{print $(NF-3)}'|sort|uniq -c|sort -rn|head >/tmp/ip.log

while read line
do
    ip=`echo $line|awk '{print $2}'`
    count=`echo $line|awk '{print $1}'`
    if [ $count -gt 10 -a `grep "$ip" /tmp/drop.log|wc -l` -lt 1 ]
    then
        iptables -I INPUT -s $ip -j DROP &&\
        echo "$ip" >>/tmp/drop.log
    else
        echo "$ip" >>/tmp/accept.log
    fi
done</tmp/ip.log
```

### 面试题 6：MySQL 数据库分库备份

```bash
请实现对 MySQL 数据库进行分库备份，用脚本实现。
解答：
常规方法：
    mysqldump -B eric oldgirl test|gzip >bak.sql.gz
分库备份：
    mysqldump -B eric |gzip >bak.sql.gz
    mysqldump -B oldgirl |gzip >bak.sql.gz
    mysqldump -B test|gzip >bak.sql.gz
    
    
参考答案：
#!/bin/bash
##############################################################
# File Name: 14_05_01.sh
# Version: V1.0
# Author: eric
# Organization: www.ericedu.com
##############################################################
path=/backup
mysql="mysql -uroot -p123"
mysqldump="mysqldump -uroot -p123"
[ -d $path ]||mkdir $path -p
for dbname in `$mysql -e "show databases;" 2>/dev/null|grep -v _schema|sed 1d`
do
    $mysqldump -B $dbname|gzip >$path/${dbname}_$(date +%F).sql.gz 2>/dev/null
done


# sed 1d  #删除第一行
```

### Shell 面试题 7：MySQL 数据库分库分表备份

```bash
如何实现对 MySQL 数据库进行分库加分表备份，请用脚本实现。
解答：
    mysqldump eric test test1|gzip >bak.sql.gz
1、 eric 库名
2、 test、test1 都是表名

解答：
常规方法：
    mysqldump -B eric oldgirl test|gzip >bak.sql.gz
分库备份：
    mysqldump -B eric |gzip >bak.sql.gz
    mysqldump -B oldgirl |gzip >bak.sql.gz
    mysqldump -B test|gzip >bak.sql.gz
方法：
    mysqldump -B eric |gzip >bak.sql.gz：
    mysqldump eric test1
    mysqldump eric test2
    mysqldump eric test3
    mysqldump -B oldgirl |gzip >bak.sql.gz：
    mysqldump oldgirl test1
    mysqldump oldgirl test2
    mysqldump oldgirl test3

参考答案：
[root@web01 eric_shell_14]# cat 14_06_01.sh
#!/bin/bash
##############################################################
# File Name: 14_06_01.sh
# Version: V1.0
# Author: eric
# Organization: www.ericedu.com
##############################################################
path=/backup
[ -d $path ]||mkdir $path -p
for dbname in `mysql -e "show databases;"|grep -v _schema|sed 1d`
do
    for tname in `mysql -e "show tables from $dbname;"|sed 1d`
    do
        if [ "$dbname" = "mysql" ]
        then
            mysqldump --skip-lock-tables $dbname $tname|gzip >$path/${dbname}-${tname}.sql.gz
        else
            mysqldump $dbname $tname|gzip >$path/${dbname}-${tname}.sql.gz
        fi
    done
done

```

### 面试题 8：筛选符合长度的单词案例



```bash
利用 bash for 循环打印下面这句话中字母数不大于 6 的单词(某企业面试真题)。
I am eric teacher welcome to eric training class
解答：数组部分有答案讲解，这里不给答案了。

arr=(I am ckhedu teacher welcome to ckhedu training class)
for ((i=0;i<${#arr[*]};i++))
do 
    if [ ${#arr[$i]} -le 6 ]
      then
        echo "${arr[$i]}"
    fi
done
echo -----------------------
for word in ${arr[*]}
do
    if [ `expr length $word` -le 6 ];then
        echo $word
    fi
done

```

### 面试题 9：比较整数大小经典案例



```bash
综合实战案例：开发 shell 脚本分别实现以脚本传参以及 read 读入的方式比较 2 个整数大小。
用条件表达式（禁止 if）进行判断并以屏幕输出的方式提醒用户比较结果。
注意：一共是开发 2 个脚本。当用脚本传参以及 read 读入的方式需要对变量是否为数字、
并且传参个数不对给予提示。
解答：见第二模块 Shell 考试题答案

#!/bin/bash
read -p "请输入两个数字：" a b
#1.判断b是否为空
if [ -z "$b" ]
then
    echo "缺少一个参数，请输入两个整数"
    exit 1
fi

#2.整数判断
expr 100 + $a + $b &>/dev/null
if [ $? -ne 0 ]
then
    echo "请输入两个整数"
    exit 2
fi

#3.判断
if [ $a -gt $b ]
then
    echo "$a>$b"
elif [ $a -eq $b ]
then
    echo "$a=$b"
else
    echo "$a<$b"
fi


```

### 面试题 10：菜单自动化软件部署经典案例



```bash
综合实例：打印选择菜单，按照选择一键安装不同的 Web 服务。
示例菜单：
[root@eric scripts]# sh menu.sh
1.[install lamp]
2.[install lnmp]
3.[exit]
pls input the num you want:

要求：
1、当用户输入 1 时，输出“start installing lamp.提示” 然后执行/server/scripts/lamp.sh，脚本
内容输出"lamp is installed"后退出脚本，工作中就是正式 lamp 一键安装脚本；
2、当用户输入 2 时，输出“start installing lnmp.提示” 然后执行/server/scripts/lnmp.sh 输出
"lnmp is installed"后退出脚本，工作中就是正式 lnmp 一键安装脚本；
3、当输入 3 时，退出当前菜单及脚本；
4、当输入任何其它字符，给出提示“Input error”后退出脚本；
5、要对执行的脚本进行相关的条件判断，例如：脚本文件是否存在，是否可执行等判断，
尽量用上前面讲解的知识点。

解答：见第二模块 Shell 考试题答案


```



```bash
#!/bin/bash
cat <<EOF
1.install lamp
2.install lnmp
3.exit
EOF
read -p "请选择一个序号（必须是数字）：" num
#1.判断是否为整数
expr 2 + $num &>/dev/null
if [ $? -ne 0 ]
then
    echo "Usage:$0 {1|2|3}"
    exit 1
fi

#2.判断执行处理
case $num in
    1)
        echo "install lamp..."
        ;;
    2)
        echo "install lnmp..."
        ;;
    3)
        echo "bye."
        exit 
        ;;
    *)
        echo "Usage:$0 {1|2|3}"
        exit 1
esac   

```

### 面试题 11：破解 RANDOM 随机数案例



```bash
已知下面的字符串是通过 RANDOM 随机数变量 md5sum 后，再截取一部分连续字符串的结果，
请破解这些字符串对应的使用 md5sum 处理前的 RANDOM 对应的数字？
21029299
00205d1c
a3da1677
1f6d12dd
890684b

参考答案
#!/bin/bash
##########################################
# File Name: 14_08_01.sh
# Version: V1.0
# Author: eric
# Organization: www.ericedu.com
##########################################
array=(
21029299
00205d1c
a3da1677
1f6d12dd
890684b
)
Funmd5(){
    for n in {0..32767}
    do
    	# 命令块放入后台并发执行，加快批量计算速度
        {	
        	# 1. echo $n：输出当前循环的数字n
            # 2. 管道交给md5sum命令，计算该数字字符串的MD5哈希值
            # 3. echo -e "$n\txxx"：制表符分隔，格式：数字	MD5值
            # 4. >> 追加写入 /tmp/md5sum1.log，保存全部明文+密文映射
        	echo -e "$n\t`echo $n|md5sum`" >>/tmp/md5sum1.log 
        } &
    done
    # 等待上面所有后台并发进程全部执行完毕，再往下执行后续代码
    # 如果不加wait，前面md5还没算完就去匹配，会缺失数据导致匹配失败
    wait
}
FunJudge(){
    # ${array[*]}：把数组所有元素展开成一行空格分隔的字符串
    # tr " " "|"：将元素之间的空格替换成正则或符号 |
    # char变量最终结果：21029299|00205d1c|a3da1677|1f6d12dd|890684b
    char="`echo ${array[*]}|tr " " "|"`"
    
    # egrep 支持扩展正则，匹配任意一个 | 分隔的密文
    # 从md5日志中筛选出包含目标密文的行，输出：原始数字对应MD5，实现md5暴力破解
    egrep "$char" /tmp/md5sum1.log
}
main(){
    Funmd5
    FunJudge
}
main


[root@ansible script]# sh judge.sh
1346    00205d1cbbeb97738ad5bbdde2a6793d  -
7041    1f6d12dd61b5c7523f038a7b966413d9  -
10082   890684ba3685395c782547daf296935f  -
25345   a3da1677501d9e4700ed867c5f33538a  -
25667   2102929901ee1aa769d0f479d7d78b05  -
1346    00205d1cbbeb97738ad5bbdde2a6793d  -
7041    1f6d12dd61b5c7523f038a7b966413d9  -
10082   890684ba3685395c782547daf296935f  -
25345   a3da1677501d9e4700ed867c5f33538a  -
25667   2102929901ee1aa769d0f479d7d78b05  -  #21029299可能的对应的数字

```

### 面试题 12：批量检查多个网站地址是否正常



```bash
要求：
1、使用 shell 数组方法实现，检测策略尽量模拟用户访问。
2、每 10 秒钟做一次所有的检测，无法访问的输出报警。
3、待检测的地址如下
http://blog.ericedu.com
http://blog.etiantian.org
http://eric.blog.51cto.com
http://10.0.0.7

参考答案
#!/bin/bash
##########################################
# File Name: 14_09_01.sh
# Version: V1.0
# Author: eric
# Organization: www.ericedu.com
##########################################
. /etc/init.d/functions
URL=(
http://www.ericedu.com
http://blog.ericedu.com
http://www.baidu.com
http://10.0.0.7
http://10.0.0.8
)

CheckUrl(){
    wget -T 10 -t 2 --spider -o /dev/null -q $1 
    if [ $? -eq 0 ]
    then
        action "$1 is successful" /bin/true
    else
        action "$1 is failure" /bin/false
    fi
}

DealUrl(){
    for((i=0;i<${#URL[*]};i++))
    do
        CheckUrl ${URL[$i]}
    done
}
main(){
    while true
    do
        DealUrl
        sleep 2
        echo ---------------------
    done
}
main
```

### 面试题 13：单词及字母去重排序案例



```bash
用 shell 处理以下内容
1、按单词出现频率降序排序！  # 按【单词】统计排序（词频）
2、按字母出现频率降序排序！  # 功能：统计文件中【每个英文字符】的出现次数，按出现次数从高到低排序输出
the squid project provides a number of resources to assist users design,implement and support squid installations. Please browse the documentation and support sections for more infomation

解答：
cat <<EOF > eric.log 
the squid project provides a number of resources to assist users design,implement and support squid installations. Please browse the documentation and support sections for more infomation,by eric training.
EOF

按单词排序解答：
法1:
tr ",." " " <eric.log|xargs -n 1|sort|uniq -c|sort -rn|head

# 单词频次统计+降序展示Top10
#tr ",." " " < eric.log  # 替换逗号、句号为空格，清理标点
# xargs -n 1            # 逐个拆分单词，每行一个
# sort                  # 单词字典序排序 ,排序规则: 开头字母 A~Z /a~z 字母顺序排列
# uniq -c               # 统计每个单词重复次数
# sort -rn              # 按次数数值降序排序
# head                  # 展示频次最高前10个单词

法2：
tr ",." " " <eric.log|xargs -n 1|awk '{S[$1]++}END{for(key in S)print S[key],key}'|sort -rn|head

# 整体功能：统计eric.log中每个英文单词的出现次数，按频次从高到低降序，展示出现最多的前10个单词
# 步骤1：tr ",." " " < eric.log
# 将文本里的英文逗号,、英文句号. 统一替换成空格，去除标点符号，避免标点附着在单词上干扰统计
# 步骤2：xargs -n 1
# 以空格作为分隔符拆分所有内容，每行只输出1个单词，把所有单词纵向单列输出
# awk '{S[$1]++}END{for(key in S)print S[key],key}' \
# 步骤3：awk 数组统计单词频次
# 定义关联数组S，S[单词]用来计数；每读取一行单个单词$1，对应数组元素数值+1
# 所有行读取完毕后进入END最终块：遍历数组中所有的键（即所有不重复单词），依次打印「出现次数 单词」
# 步骤4：sort -rn
# -n：按照纯数字解析出现次数；-r：倒序排列，实现按单词出现次数从多到少排序
# 步骤5：head
# 默认输出排序后的前10行，展示出现频次最高的前10个单词
法3：
awk -F "[,. ]+" '{for(i=1;i<=NF;i++)S[$i]++}END{for(key in S)print S[key],key}' eric.log |sort -rn|head



按字母频率排序
法1
tr -d ' {,|.}' < eric.txt|awk -F ""  '{for(i=1;i<=NF;i++)array[$i]++}END{for(key in array)print array[key],key|"sort -nr"}'

-------------------------------------------------
# 1. tr -d ' {,|.}'
# 将大括号、空格、逗号、句号，全部删除掉
# 作用：所有的字母都连到一起了
| awk -F ""  '{
    # -F "" ：把分隔符设置为空，代表按【单个字符】切割当前行，NF就是当前行总字符数
    for(i=1;i<=NF;i++){
        array[$i]++  # 用关联数组，以单个字符为下标，每出现一次该字符，计数+1
    }
}
END{
    # 所有字符遍历统计完成后，遍历数组所有键（去重后的所有字符）
    # 输出格式：次数 字符，交给管道命令 sort -nr 按数字降序排序
    for(key in array){
        print array[key],key | "sort -nr"
    }
}

------------------------------------------------------------------------

tr "[ ,.]" "\n"<eric.txt|awk '{for(i=1; i<=length($0); i++) ++S[substr($0,i,1)]} END {for(a in S) print S[a], a|"sort -rn"}'


echo "the squid project provides a number of resources toassist users design,implement and support squid installations. Please browsethe documentation and support sections for more infomation"|sed 's# ##g'|sed -r 's#(.)#\1\n#g'|sort|uniq -c|sort -rn -k1

echo "the squid project provides a number of resources toassist users design,implement and support squid installations. Please browsethe documentation and support sections for more infomation"|sed 's# ##g'|awk -F "" '{for(n=1;n<=NF;n++) print $n}'|sort|uniq -c|sort -k1 -nr




```

### 面试题 14：企业批量管理和分发文件案例实战



```bash
3 台机器 A、B、C，实现从 A 到 B 和 C 免秘钥登录，
然后开发脚本实现，批量管理远程主机
（执行任意命令），批量分发本地任意文件到远端任意路径下。

分发脚本：
#!/bin/bash
. /etc/init.d/functions
if [ $# -ne 2 ]
then
    echo "usage:$0 localdir remotedir"
    exit 1
fi

for n in 8 41 42 43
do
    scp -rp $1 10.0.0.$n:$2 &>/dev/null
    if [ $? -eq 0 ]
    then
        action "10.0.0.$n is successful" /bin/true
    else
        action "10.0.0.$n is failure" /bin/false
    fi
done


```

查看脚本；

```bash
#!/bin/bash
if [ $# -ne 1 ]
then
    echo "usage:$0 cmd"
    exit 1
fi
for n in 8 41
do
    echo "--------10.0.0.$n---------"
    ssh 10.0.0.$n $1
done


```



## 合格运维人员必会的脚本列表

1）系统及各类服务的监控脚本，例如：文件、内存、磁盘、端口，URL监控报警等。
2）监控网站目录下文件是否被篡改，以及站点目录批量被篡改后如何批量恢复的脚本。
3）各类服务Rsync、Nginx、MySQL等的启动及停止专业脚本（使用chkconfig管理）。
4）MySQL主从复制监控报警以及自动处理不复制故障的脚本。
5）一键配置MySQL多实例、一键配置MySQL主从部署脚本。
6）监控HTTP/MySQL/Rsync/NFS/Memcached等服务是否异常的生产脚本。
7）一键软件安装及优化的脚本，比如LANMP、Linux一键优化，一键数据库安装、优化等。
8）MySQL多实例启动脚本，分库、分表自动备份脚本。
9）根据网络连接数以及根据Web日志PV封IP的脚本。
10）监控网站的PV以及流量，并且对流量信息进行统计的脚本。
11）检查Web服务器多个URL地址是否异常的脚本，要可以批量处理且通用。
12）系统的基础优化一键优化的脚本。
13）TCP连接状态及IP统计报警脚本。
14）批量创建用户并设置随机8位密码的脚本。



# 一、运维必掌握 Shell 核心知识点

## 1. 基础必备

1. 脚本规范：`#!/bin/bash`、脚本权限、执行三种方式、注释、set 脚本容错（`set -euo pipefail`）

1. 变量：普通变量、环境变量、位置参数 `$0 $1 $2 $# $@ $* $?`、局部变量 `local`
2. 字符串操作：拼接、截取、替换、去首尾空格、判断空 / 非空、字符串比较
3. 算术运算：`$(( ))`、`let`、`bc` 浮点运算

```bash

写在脚本开头（企业生产最常用，全局生效）
放在 #!/bin/bash 下面第一行，整个脚本所有命令都生效。

#!/bin/bash
# 全局开启严格模式
set -euo pipefail
# 调试模式按需开启
# set -x

# 下面所有代码都会遵循以上规则
echo "脚本开始执行"

set -e：命令执行失败直接退出，避免错误向下传递（比如删除失败还继续备份）
set -u：变量没定义直接报错，防止手敲变量名拼写错误导致业务异常
set -o pipefail：管道任意环节失败整条管道算失败，set -e 可以捕获管道错误
set -x：调试模式，逐条打印执行的命令 + 变量替换后内容，排错用

总结
上线正式脚本：开头固定写 set -euo pipefail，不写 -x；
调试排错：两种方式：
脚本临时打开 set -x
执行脚本：bash -x 脚本名
命令行直接 set 仅当前终端有效，退出终端失效。

set -o pipefail 详细解释
-----------------------------------------------
示例:脚本中的一段
# 1.txt 不存在，cat 一定会报错（返回非0）
cat 1.txt | grep "abc"

执行结果：
cat: 1.txt: No such file or directory 报错
但后面的 grep 命令本身执行语法没问题，只是没匹配到内容，grep 返回码是 0
整条管道最终返回码 = 最后一条 grep 的返回码 0
set -e 看到返回码是 0，不会退出脚本，继续执行后面 echo
问题：前面关键命令失败了，脚本却没终止，会留下隐藏 bug。

未开启 pipefail：管道只认最后一条命令的结果；前面命令崩了也不算失败，set -e 不会触发退出。
开启 pipefail：管道里任意一个命令失败，整条管道就判定为失败，set -e 可以正常捕获错误终止脚本。
----------------------------------------------------
```



## 2. 条件判断（高频）

1. 文件测试：`-f -d -e -r -w -x -s`
2. 数值比较：`-eq -ne -gt -lt -ge -le`
3. 字符串：`-z -n = !=`
4. `[]`、`[[ ]]`、`(( ))` 三者区别、正则匹配 `=~`
5. `if` 单 / 双 / 多分支、`case` 服务启停脚本

## 3. 循环结构

1. `for` 两种写法：遍历列表、C 语言风格；批量运维场景（批量主机、文件、服务）
2. `while` 循环：守护进程、无限轮询、按行读取文件 `while read line`
3. `break continue exit return` 四者区别

## 4. 函数

1. 两种函数定义方式、传参、返回值（仅 0-255 状态码）
2. 全局变量 / 局部变量、函数库分离（`source` 加载外部脚本）
3. 封装重复运维逻辑

## 5. 数组（面试高频）

1. 普通索引数组：定义、遍历、截取、追加、删除、数组长度
2. 关联数组 `declare -A`：必须显式声明、键值存储、遍历 key/value
3. 字符串截取、前缀后缀删除、单个 / 全局替换

## 6. 三剑客（Shell 灵魂，运维必考）

```
grep sed awk
```

- grep：过滤、正则、反向匹配、统计行数
- sed：增删改查、替换、批量修改配置
- awk：列截取、统计、求和、格式化输出、条件判断

## 7. 高级常用

1. 颜色输出、菜单 `here-doc`
2. 定时任务结合脚本、日志输出重定向 `> >> 2>&1`
3. 信号捕获 `trap`、脚本异常处理
4. 静态数组、动态数组、批量巡检脚本开发
5. 服务启停脚本、日志清理、数据备份脚本

# 二、Shell 高频面试题（精简）

## 1. 基础类

1. `$@` 和 `$*` 区别，加双引号与不加的差异
2. `$?`、`$$`、`$!`、`$0`、`$_` 含义
3. `[]` `[[ ]]` `(( ))` 区别、各自适用场景
4. 脚本三种执行方式区别（`./`、`sh`、`source`）
5. `set -e`、`set -u` 作用

## 2. 条件判断类

1. 如何判断输入是否为纯数字（expr 加法 / 正则 /case）
2. 文件常用测试参数、如何判断文件是否为空
3. 正则 `^ $ [] +` 含义，如何匹配手机号、IP

## 3. 循环类

1. `while read` 按行读文件为什么不能用管道直接循环？如何避免变量失效？
2. `break n`、`continue n` 多层循环跳出用法
3. for 与 while 适用场景：批量处理 / 守护进程

## 4. 函数 + 数组（重中之重）

1. return 和 exit 区别、函数只能返回数值如何返回字符串？
2. 关联数组为什么必须 `declare -A`？不声明会出现什么问题？
3. 数组遍历两种方式、数组片段截取、批量元素替换
4. 如何封装函数库、source 和./ 加载脚本区别

## 5. 三剑客高频面试

1. sed 批量替换配置文件、只替换第 N 行
2. awk 统计日志访问量、IP 访问次数、求和、去重
3. grep 过滤空行、注释行、反向过滤

## 6. 实战脚本面试题（手写）

1. 批量创建 100 个用户并设置随机密码，存入文件
2. 日志清理脚本：打包 N 天前日志、删除过期日志
3. 系统巡检脚本：CPU、内存、磁盘、端口、服务状态
4. rsync/nginx 服务启停 case 脚本
5. 监控端口 / 进程异常，异常则重启并告警
6. 统计 Nginx 访问日志中 Top10 访问 IP

## 7. 坑点面试题

1. 管道后循环内变量不生效怎么解决？
2. 数组带空格元素遍历为什么要加双引号 `"${arr[@]}"`
3. 浮点运算 Shell 原生不支持，用什么工具？
4. 脚本后台运行、nohup 与 & 区别、日志丢失问题

# 三、运维高频实战脚本方向

1. 系统巡检、监控告警脚本
2. 数据备份、日志切割清理
3. 批量主机操作、批量部署
4. 服务启停、进程保活守护脚本
5. 日志统计分析、安全审计脚本
