# python基础

## 认识python

- **Python 哲学**：明确、优雅、简单（Keep It Simple, Stupid）。
- **学了 shell 为什么还要学 Python？** Python 更强大、功能更丰富、执行效率比 shell 高，也是"开发型运维"的趋势。

## python的优缺点

**优点：**

1. **简单易学、开发效率高**：语法简单，Linux 上用 vi 写完直接就能运行，和写 shell 一样方便。
2. **免费开源**：运维用的软件大部分都是开源。
3. **跨平台**：程序无需修改即可在 Linux、Windows、Mac 上运行。
4. **可扩展**：关键代码可用 C/C++ 重写提升性能，或保护算法不公开。
5. **丰富的库**：随机数、OS 操作、MySQL 等都有现成库可调，各种场景全覆盖。
6. **代码规范**：强制缩进让代码可读性极佳。

**缺点：**

1. **执行效率慢**：解释型语言通病，但已被越来越强的硬件性能弥补，多数场景感觉不到。
2. **代码不能加密**：解释型语言通病，可用混淆代码，或用 C 扩展保护核心算法（见优点 4）。

## Python应用场景

1. **运维自动化脚本**：可读性、性能、扩展性均优于 shell 脚本。
2. **Web 开发**：Django、TurboGears 等框架可轻松开发复杂 Web 程序。
3. **服务器软件 / 网络爬虫**：对网络协议支持完善，Twisted 支持异步高性能网络编程。
4. **游戏**：用 C++ 写高性能图形模块，Python/Lua 写游戏逻辑与服务器。
5. **科学计算**：NumPy、SciPy、Matplotlib 支撑科学计算。
6. **其它**：无人驾驶、人工智能等。

## 解释型语言与编译型语言

计算机只能识别机器语言（如 01010101001），程序员不能直接写 01 代码，所以要把程序员写的程序语言翻译成机器语言。将其他语言翻译成机器语言的工具称之为**编译器**。翻译方式有两种：一种是**编译**，一种是**解释**。

### 一句话本质区别

- **编译型**：先全部翻译成机器码，再执行（先翻译后执行）
- **解释型**：边翻译边执行，一行一行来（边读边译边跑）

### 执行流程对比

```text
编译型（C / C++ / Go / Java）：
源码 → 编译器一次性翻译 → 机器码文件(.exe/.o) → 操作系统加载 → CPU 直接执行

解释型（Python / Shell / JavaScript）：
源码 → 解释器逐行读取 → 边翻译边执行 → 操作系统调用 → CPU 执行
```

### 核心区别对照

| 维度 | 编译型 | 解释型 |
| :--- | :--- | :--- |
| 翻译时机 | 运行前一次性翻译完 | 运行时逐行翻译 |
| 执行速度 | 快（机器码直接跑） | 慢（每次都要解释） |
| 是否生成可执行文件 | 是（exe / 二进制） | 否（直接跑源码） |
| 开发效率 | 低（编译 + 修改周期长） | 高（改完立刻能跑） |
| 跨平台 | 差（每个平台重新编译） | 好（有解释器就能跑） |
| 代码安全性 | 高（编译后看不到源码） | 低（源码公开，无法加密） |
| 典型语言 | C、C++、Go、Rust、Java | Python、Shell、JavaScript、PHP |

### 两个关键澄清

1. **Java 是编译型还是解释型？**
   两者都沾：Java 先编译成字节码（.class），再由 JVM 解释/即时编译（JIT）执行。所以常说 Java 是"半编译半解释"，这也是它"一次编译到处运行"的原因。

2. **为什么说解释型语言开发快但执行慢？**
   - 开发快：不用等编译，写完直接跑，调试成本低（Python 写小工具秒级验证）
   - 执行慢：解释器每次运行都要逐行翻译，而编译型只翻译一次、之后直接执行机器码

### 运维 / 开发怎么选？

- 追求性能、系统级/底层：编译型（C 写内核、Go 写高并发服务）
- 追求效率、脚本自动化、快速迭代：解释型（Python 做运维脚本、数据分析、Shell 做批量任务）
- 实际生产中常混合使用：业务用 Python/Go 开发，核心性能模块用 C/C++ 编写

**核心区别**：编译型语言"先全部翻译再执行"，执行快、可加密；解释型语言"边解释边执行"，开发快、跨平台，但执行慢、源码不加密。

## python版本

- python2.x：已于 2020 年终止维护，不再使用。
- python3.x：目前主流版本。
- 官网下载地址：https://www.python.org/getit/

## 第一个python脚本

```py
# vim 1.py
#!/usr/bin/python # 声明解释器路径
#-*- coding: utf-8 -*- # 指定 utf-8 编码（python3 默认，无需指定）
print ("hello world") # python3 写法（python2 写 print "..." 会报错）
print ("哈哈") # python3 直接支持中文

执行方法一:
# python 1.py

执行方法二:（需有执行权限和声明类型）
# chmod 755 1.py
# ./1.py
```

交互模式运行：

```py
# python
>>> print ("hello world")
hello world
>>> exit()  # 或 ctrl+d 退出
```

## python安装

在 Linux 上（虚拟机建议把内存调大）编译安装 python3.x（以 3.6.6 为例）：

```bash
# 安装依赖包（缺包会编译报错）
yum install zlib-devel openssl openssl-devel
# 编译安装
tar xf Python-3.6.6.tar.xz -C /usr/src/
cd /usr/src/Python-3.6.6/
./configure --enable-optimizations   # 报错多为缺依赖包
make                                # 耗时 20-30 分钟
make install
# 验证
ls /usr/local/bin/python3.6   # python 命令
ls /usr/local/bin/pip3.6      # pip 为 python 安装模块的命令
```

pycharm 安装：

- PyCharm 是 Python 的 IDE（集成开发环境），提供调试、语法高亮、代码跳转、智能提示等功能。
- 官网下载：http://www.jetbrains.com/pycharm/download/#section=linux
- **专业版**：功能全，收费，可试用 30 天；**社区版**：免费，学习够用。

## pyenv安装(了解)

**pyenv** 是 Python 多版本管理工具，可在一台机器上隔离使用多个 Python 版本，互不影响。

```bash
# 1. 安装到 ~/.pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
# 2. 配置环境变量并生效
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /etc/profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /etc/profile
source ~/.bash_profile
# 3. 安装编译依赖，否则下一步会报错
yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel libpcap-devel xz-devel -y
# 4. 安装指定版本
pyenv install 3.6.6
# 5. 查看已安装版本（带 * 为当前默认）
pyenv versions
```

**pyenv-virtualenv** 是 pyenv 插件，为指定 Python 版本创建隔离的虚拟环境：

```bash
# 1. 安装插件
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
# 2. 创建虚拟环境（名字自定义）
pyenv virtualenv 3.6.6 python3.6.6
# 3. 激活（报错需先执行下面两条）
echo 'eval "$(pyenv init -)"' >> /etc/profile
echo 'eval "$(pyenv virtualenv-init -)"' >> /etc/profile
source /etc/profile
pyenv activate python3.6.6
# 4. 退出虚拟环境 / 删除虚拟环境
pyenv deactivate
pyenv uninstall python3.6.6
```

**小结：几种 python 开发环境对比**

| 环境 | 交互式 | 辅助功能 | 图形化 |
| :--- | :--- | :--- | :--- |
| python3.6（命令行） | 是 | 无 | 否 |
| vim 1.py | 否 | 无 | 否 |
| pycharm | 否 | 有 | 是 |
| ipython | 是 | 有 | 否 |

## print 打印

**基本规则**：字符串用引号（单/双）引起来；`\` 为显式行连接，`() [] {}` 内换行自动连接（隐式）。

换行打印：

```py
help(print)          # 查看帮助
print("hello world") # 默认换行
print("hello world\npython") # \n 换行
print('''hello world
python''')           # 三引号多行字符串
```

不换行打印：

```py
print('hello world',end=" ") # end="" 指定结尾，默认是 \n
print("python")
print("hello world" "python") # 字符串自动拼接
```

彩色打印（VT100 控制码，终端显示颜色）：

```py
print("\033[31;1;31mhello world\033[0m") # \033[颜色m 开始，\033[0m 结束
print("\033[31;1;32mhello world\033[0m")
print("\033[31;1;33mhello world\033[0m")
```

## 注释

```py
# 单行注释（# 后加空格，pycharm 规范）
print("hello world")  # 行尾注释，代码和 # 之间至少两个空格

# 多行注释：三引号（''' 或 """）内包含注释内容
'''
注释内容
"""
注释内容
"""
快捷键 ctrl + /
```

## 代码规范PEP

- PEP 是 Python 官方的增强提案文档，其中 **PEP 8** 专门规范 Python 代码格式。
- 文档地址：https://www.python.org/dev/peps/pep-0008/
- 中文版：http://zh-google-styleguide.readthedocs.io/en/latest/google-python-styleguide/python_style_rules/

## 变量

**变量**：给数据起个名字，通过名字访问和修改内存中的数据。可以反复存储、取出、更改。

**命名规则**：
- 只能由字母、数字、下划线组成，且**首字符不能是数字**
- 见名知义（如 `user_name`），区分大小写
- 不能用 Python 关键字（`if`、`for`、`class` 等）

```py
import keyword
print(keyword.kwlist) # 打印所有关键字
```

## 变量的创建

```py
num=100      # 首次出现 = 定义变量
num=num-10   # 再次出现 = 给变量赋新值
print(num)

name1="daniel"
name2="daniel"
print(id(name1), id(name2)) # id() 获取内存地址；值相同则指向同一内存空间
```

## 两个变量值的交换

```py
a=1; b=2
a,b=b,a   # Python 一行即可交换两个变量
print(a,b)
```

## 变量的类型

Python 是**强类型动态**语言：不用声明类型，变量类型由赋值决定；不同类型不允许相加（如 str+int 报错）。

```py
name="zhangsan" # str 类型
age=25          # int 类型（加引号则是 str）
height=1.8      # float 类型
marry=True      # bool 类型
print(type(name), type(age), type(height), type(marry)) # type() 查看类型
```

## Python基本数据类型分类

| 类型 | 写法 | 说明 |
| :--- | :--- | :--- |
| int | `1, -2` | 整型 |
| float | `3.14` | 浮点型 |
| bool | `True/False` | 布尔型 |
| complex | `4+3J` | 复数（了解即可） |
| str | `"hello"` | 字符串，引号内内容 |
| list | `[1,2,3]` | 列表，中括号 |
| tuple | `(1,2,3)` | 元组，小括号 |
| dict | `{"a":1}` | 字典，大括号，key-value 键值对 |
| set | `{1,2,3}` | 集合，大括号，无序不重复 |

## 类型的转换

| 函数 | 说明 |
| :--- | :--- |
| int(xxx) | 转整数 |
| float(xxx) | 转浮点数 |
| str(xxx) | 转字符串 |
| list(xxx) / tuple(xxx) | 转列表 / 元组 |
| dict(xxx) / set(xxx) | 转字典 / 集合 |
| chr(xxx) / ord(xxx) | 整数 ↔ ASCII 码 |

```py
age=25
print(type(age)) # int
age=str(25)
print(type(age)) # str

name="zhangsan"; age=25
print(name,"你"+age+"岁了") # 报错：str+int 不能拼接，需先 str(age)
```

## 输入输出

**输入**：python3 用 `input()` 等待用户输入，输入内容默认为 **str 类型**（python2 为 `raw_input()`）。

```py
name=input("what is your name: ")
age=input("what is your age: ")
print(name,"你"+age+"岁了")
```

**输出**：用 `print()`。

```py
print("="*10)   # 连续打印 10 个 =
print('''1-系统
2-数据库
3-quit''')     # 三引号自动换行
```

## 格式化输出

python 用 `%` 或 `.format()` 做格式化输出（类似 shell 的 printf）：

| 操作符 | 说明 |
| :--- | :--- |
| %s | 字符串 |
| %d | 整数 |
| %f | 浮点数 |
| %% | 输出 % |

```py
name=input("what is your name: ")
age=input("what is your age: ")
num=int(input("what is your phone number: ")) # input 得到的是 str，要转 int 才能对应 %d

# 方式一：% 占位符（按顺序对应）
print(name,"you are %s years old,and your phone number is %d"%(age,num))

# 方式二：.format()（{} 按顺序对应，{0}/{1} 按下标对应，不用纠结 %s/%d）
print(name,"you are {} years old, and your phone number is {}".format(age,num))
print(name,"you are {1} years old, and your phone number is {0}".format(num,age))

# 方式三：多行信息格式化
info = '''
---------- information of {} ----------
name: {}
sex: {}
job: {}
phonenum: {}
'''.format(name, name, sex, job, phonenum)
print(info)
```

## 运算符

```text
算术运算符：
+ 加   - 减   * 乘   / 除（保留小数）
// 整除（10//3=3）   ** 求幂（2**3=8）   % 取余（10%3=1）

赋值运算符：= += -= *= /= //= **= %=

比较运算符：== != > < >= <=（结果为 bool）

逻辑运算符：and(都真才真)  or(一真即真)  not(取反)

成员运算符：in / not in（判断是否在序列中）

身份运算符：is / is not（判断是否引用同一对象）
```

**is 与 == 的区别**：`is` 判断是否同一个内存对象，`==` 判断值是否相等。

```py
a=[1,2,3]; b=a[:]; c=a
print(b is a) # False（b 是拷贝，不同对象）
print(b == a) # True（值相等）
print(c is a) # True（c 直接引用 a）
```

**运算符优先级**：算术 > 比较 > 逻辑 > 赋值。

```py
result = 3-4 >=0 and 4*(6-2)>15
#        -1>=0(False) 且  16>15(True)  → False
print(result)
```

## 判断语句

python 的 `if` 语法（注意**缩进表示代码块**，没有 shell 的 fi/case）：

```py
if 条件:
   动作一
elif 条件2:
   动作二
else:
   动作三
```

示例 1：判断字符类型

```py
char=input("input a char: ")
if char.isdigit():
   print(char,"is digit")
elif char.islower():
   print("{} is a lower".format(char))
elif char.isupper():
   print("{} is a upper".format(char))
else:
   print("{} is other char".format(char))
```

示例 2：os 模块判断文件是否存在（跨平台，shell 的 -e 只能用于 Linux）

```py
import os
file=input("input a file: ")
if os.path.exists(file):
   print(file,"exists")
else:
   print(file,"not exists")
```

示例 3：getpass 隐藏输入密码（在 pycharm 有 bug 会卡住，建议 bash 下执行）

```py
import getpass
username=input("username:")
password=getpass.getpass("password:")
if username == "daniel" and password == "123":
   print("login success")
else:
   print("login failed")
```

示例 4：按年龄与性别判断称呼（多分支 elif）

```py
name=input("what is your name: ")
age=int(input("how old are you: "))
sex=input("what is your sex: ")
if age >= 18 and sex=="male":
   print(name,"sir")
elif age>=18 and sex=="female":
   print(name,"lady")
elif age<18 and sex=="male":
   print(name,"boy")
else:
   print(name,"girl")
```

练习：判断闰年（能被 4 整除但不能被 100 整除，或能被 400 整除）

```py
# 方法一：calendar 模块
import calendar
a=int(input("input a year: "))
print(calendar.isleap(a))

# 方法二：条件判断
year=int(input("input a year: "))
if year%4 == 0 and year%100 != 0 or year%400 ==0:
   print(year,"is leapyear")
else:
   print(year,"is not leapyear")
```

if 嵌套（if 里还有 if，层次不宜过多）

```py
if 条件一:
   if 条件二:
      动作一  # 条件一、二都为 True
   else:
      动作二  # 条件一 True，条件二 False
else:
   if 条件三:
      动作三
   else:
      动作四
```

## 循环语句

**while 循环**：条件满足时一直执行。

```py
while 条件:
   动作
```

- `continue`：跳出本次循环，直接进入下一次
- `break`：退出整个循环
- `exit()`：退出 python 程序

示例：打印 1-10

```py
i=1
while i<=10:
   print(i,end=" ")
   i+=1
```

示例：猜数字小游戏

```py
import random
num=random.randint(1,100) # 1-100 随机数（含两端）
while True:
   gnum=int(input("please guess:"))
   if gnum > num:
      print("bigger"); continue
   elif gnum<num:
      print("smaller"); continue
   else:
      print("right"); break
```

练习：求 1-100 所有偶数之和

```py
sum=0
for i in range(2,101,2): # range(起始,结束,步长)
   sum+=i
print(sum)
```

## for循环

**for 循环**：遍历序列（字符串、列表、元组等），循环次数由元素个数决定；`for` 是定循环，`while` 是不定循环。

```py
for i in (1,2,3,4,5):   # 元组/列表/集合均可
   print(i,end=" ")
for i in range(1,6):    # range(1,6)=1,2,3,4,5（不含6）
   print(i)
for i in range(1,100,2):  # 步长为 2
   print(i,end=" ")
```

练习：1-100 中能被 5 和 3 同时整除的数之和

```py
sum=0
for i in range(1,101):
   if i%5 == 0 and i%3 == 0:
      sum+=i
print(sum)
```

练习：猜数字最多 5 次

```py
import random
num=random.randint(1,100)
for i in range(5):
   gnum=int(input("please guess:"))
   if gnum > num:   print("bigger")
   elif gnum<num:   print("smaller")
   else:
      print("right"); break
   if i == 4:
      print("you are out of chances"); exit()
```

**循环嵌套**：if、while、for 可以互相嵌套。

练习：打印九九乘法表

```py
for i in range(1,10):
   for j in range(1,i+1):
      print("{}*{}={}".format(j,i,i*j),end=" ")
   print()
```

## 字符串-str

python 数据类型：数字（int/float/bool）、字符串 str、列表 list、元组 tuple、字典 dict、集合 set。

## 字符串-str

**定义**：用引号（单/双/三引号）引起来的就是字符串；`input()` 输入、`str()` 转换得到的也是字符串。

```py
string1="hello"; string2='hello'
string3="""hello
python"""        # 三引号支持多行
print(isinstance(string3,str)) # isinstance() 判断数据类型
```

**拼接**：三种方式结果一样。

```py
name="daniel"
print("==="+name+"===")        # 方式一：+
print("===%s==="%(name))       # 方式二：%
print("==={}===".format(name)) # 方式三：.format()
```

**下标与遍历**：字符串、列表、元组都是序列，有下标（从 0 开始）；`enumerate()` 同时得到下标和值。

```py
str1="hello,python"
for i in str1:       # 直接遍历
   print(i,end=" ")
for i,j in enumerate(str1):  # 下标 i + 字符 j
   print(i,j)
```

**切片与倒序**：`字符串[开始:结束:步长]`，结束下标不包含。

```py
a="abcdefg"
print(a[0:3])   # abc（取第1-3个，不含第4个）
print(a[1:])    # bcdefg（第2个到最后）
print(a[::-1])  # gfedcba（倒序）
print(a[0:5:2]) # ace（步长2）
```

字符串的常见操作

```py
abc="hello,nice to meet you"
print(len(abc))             # 长度
print(abc.upper())          # 全大写
print(abc.lower())          # 全小写
print(abc.capitalize())     # 首字母大写
print(abc.title())          # 每个单词首字母大写
print(abc.strip())          # 去除两端空格/换行（lstrip/rstrip 去单边）
print(abc.startswith("h"))  # 是否以某字符串开头（endswith 结尾）
print(abc.count("e"))       # 统计出现次数
print(abc.find("nice"))     # 找下标，找不到返回 -1（index 找不到会报错）
print(abc.isdigit())        # 是否纯数字（isalpha 字母 / isspace 空白 / isalnum 数字或字母）
```

**字符串不可变**：数字、字符串、元组是不可变类型，下面的操作会生成新字符串，原值不变。

```py
aaa="hello world,itcast"
bbb=aaa.replace('l','L',2) # 替换，最多替换 2 个
print(aaa)  # 原值不变
print(bbb)  # 新字符串

print("root:x:0:0".split(":"))     # 按分隔符拆成列表
print(" ".join(['df','-h']))       # 列表用分隔符合成字符串
```

练习：判断强密码（长度≥8，且包含大写、小写、数字、下划线四类）

```py
str=input("input a str: ")
flag=[True]*4  # 记录四类字符是否出现过
if len(str) < 8:
   print("not enough length"); exit()
count=0
for i in str:
   if flag[0] and i in "0123456789":                  count+=1; flag[0]=False
   if flag[1] and i in "abcdefghijklmnopqrstuvwxyz":  count+=1; flag[1]=False
   if flag[2] and i in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":  count+=1; flag[2]=False
   if flag[3] and i in "_":                           count+=1; flag[3]=False
print("strong password" if count==4 else "not strong password")
```

## 列表-list

列表是**可变**的序列（字符串/元组不可变），用中括号 `[]` 括起来，元素可以是不同类型。

**创建、下标、切片**（与字符串类似）：

```py
os=["rhel","centos","suse","ubuntu"]
for i,j in enumerate(os):
   print(i,j)          # 下标 + 值
print(os[::-1])        # 切片倒序
os.reverse()           # reverse 原地倒序（直接改原列表）
```

**增删改查**：

```py
os=["rhel","centos","suse"]
os.append("ubuntu")        # 增：末尾加
os.insert(2,"windowsxp")   # 增：指定位置插入
os[2]="windows10"          # 改：按下标修改
os.remove("windows10")     # 删：按值删（del os[2] 按下标删，os.pop() 删末尾）
print(os[0])               # 查：按下标取值
print(os.index("centos"))  # 找元素下标
os.sort()                  # 排序（ASCII）
os.clear()                 # 清空所有元素
```

**列表合并**：

```py
list1=["haha","hehe"]
list2=["xixi","hoho"]
list1.extend(list2)  # 等价于 list1 += list2
print(list1)
```

**双列表 / 列表嵌套遍历**：

```py
name_list=["zhangsan","lisi","wangwu"]
salary=[18000,16000,20000]
for i in range(len(name_list)):
   print("{}的月收入为{}元".format(name_list[i],salary[i]))

emp=[["zhangsan",18000],["lisi",16000],["wangwu",20000]]
for i in range(len(emp)):
   print("{}的月收入为{}元".format(emp[i][0],emp[i][1]))
```

## 元组-tuple

元组 = **只读的列表**（小括号 `()`），不可增删改，只有 `count`/`index` 两个方法，支持切片。

```py
tuple1=(1,2,3,4,5,1,7)
print(tuple1.index(3)) # 元素下标
print(tuple1.count(1)) # 统计次数
print(tuple1[2:5])     # 切片
tuple1[5]=6            # 报错！元组不可修改
```

- **可变类型**（值可改、内存地址不变）：列表、字典、集合
- **不可变类型**（改值即新建内存空间）：数字、字符串、元组
- 元组里的列表仍可修改：`emp2[0].append("haha")` 合法。

综合练习（有难度，尽量尝试，不做要求）:

```py
tvlist = [
   "戏说西游记:讲述了西游路上的三角恋.",[
      "孙悟空:悟空爱上了白骨精......",
      "唐三藏:唐僧只想取经......",
      "白骨精:她爱上了唐僧......",
      ],
   "穿越三国:王二狗打怪升级修仙史",[
      "王二狗:开局一把刀,一条狗......",
      "吕布:看我方天画鸡......",
      "貂蝉:油腻的师姐,充值998就送!",
   ],
   "金瓶梅:你懂的",[
      "西门大官人:你懂的......",
      "潘金莲:你懂的......",
      "武大郎:你懂的......",
      "武松:你懂的......",
   ],
   "大明湖畔:我编不下去了......",[
      "夏雨荷:xxxxxx",
      "乾隆:xxxxxx",
      "容么么:xxxxxx",
   ],
]
```

```py
答案:
tv_name_num = random.randrange(0,len(tvlist),2)
tv_role_num = tv_name_num + 1
print("今日的通告: ")
print(tvlist[tv_name_num])
print("可接的角色有: ")

for index,role in enumerate(tvlist[tv_role_num]):
   print(index+1,role)

choice = int(input("请问你要接哪个角色(请输入数字): "))

print("恭喜你,你接了{}这个角色,相信我们的合作会让这部剧大火".format(tvlist[tv_role_num][choice-1].split(":")[0]))
```

综合练习（有难度，尽量尝试，不做要求）:
小购物车程序 1,双十一来了，你的卡里有一定金额(自定义) 2,买东西，会出现一个商品列表(商品名，价格) 3,选择
你要买的商品,卡里的钱够就扣钱成功，并加入到购物车;卡里钱不够则报余额不足 （或者做成把要买的商品都先加
入到购物车，最后可以查看购物车，并可以删除购物车里的商品；确定后，一次性付款） 4,买完后退出，会最后显
示你一共买了哪些商品和显示你的余额

```py
提示部分代码:
money=20000
goods_list=[
   ["iphoneX",8000],
   ["laptop",5000],
   ["book",30],
   ["earphone",100],
   ["share_girlfriend",2000],
]
cart_list=[]
```

```py
while True:
   for index,good in enumerate(goods_list):
      print(index+1,good)
   choice = int(input("请输入你要购买的商品编号: "))
   buy_good_price = goods_list[choice-1][1]
   if money >= buy_good_price:
      money -= buy_good_price
      cart_list.append(goods_list[choice-1][0])
   else:
      print("余额不足，请充值!")
      break
print(money)
print(cart_list)
```

## 字典-dict

字典是 **key:value 键值对**数据，无序（无下标），底层是 hash 表，**查找快**；key 重复自动去重。字符串/列表/元组有下标，字典/集合没有。

```py
dict1 = {
   'stu01':"zhangsan",
   'stu02':"lisi",
   'stu03':"wangwu",
   'stu04':"maliu",
}
print(type(dict1))
print(len(dict1))
print(dict1)
```

字典的常见操作（增改写法相同，区别在 key 是否存在）

```py
dict1["stu05"]="tianqi"  # 增：key 不存在则增加
dict1["stu04"]="马六"     # 改：key 存在则修改
print(dict1["stu01"])    # 查：key 不存在报 KeyError
print(dict1.get("stu01"))# 查：key 不存在返回 None，更安全
dict1.pop("stu05")       # 删：删除指定 key（del dict1["stu05"] 同理）
dict1.popitem()          # 删：删除最后一条
dict1.clear()            # 清空所有
```

其它操作（了解）

```py
print(dict1.keys())           # 所有 keys
print(dict1.values())         # 所有 values
print(dict1.items())          # 转成列表套元组
print("stu01" in dict1)       # 判断 key 是否存在
dict1.setdefault("stu08","老八") # key 不存在才增加（类似 if key not in dict）
dict1.update({"stu02":"李四","stu09":"老九"}) # 合并另一个字典，同 key 覆盖
```

字典练习：嵌套字典（城市→区→说明）

```py
city={
   "北京": {"东城":"景点","朝阳":"娱乐","海淀":"大学"},
   "深圳": {"罗湖":"老城区","南山":"IT男聚集","福田":"华强北"},
}
```

```py
print(city["北京"]["东城"])        # 取：东城区的说明
city["北京"]["东城"]="故宫在这"    # 改
city["北京"]["昌平"]="我们在这"    # 增
city["北京"]["海淀"]=["清华","北大","北邮"] # 值改为列表
city["北京"]["海淀"].append("北影")
for index,i in enumerate(city["北京"].keys()):
   print(index+1,i)              # 循环打印区名，序号从 1 开始
```

练习：打印出所有 value 为 2 的 key

```py
dict1={'张三':2,'田七':4,'李四':3,'马六':2,'王五':1,'陈八':2,'赵九':2}
for line in dict1.items():
   if line[1] == 2:
      print(line[0])
```

## 集合-set(了解)

集合用大括号 `{}`，**没有 value、无序**，相当于只有 key 的字典。特点：

1. **天生去重**（自动去掉重复值）
2. 可增删，但**不能修改**元素
3. 方便求交集、并集、差集

**可变类型**：列表、字典、集合；**不可变类型**：数字、字符串、元组。

示例：

```py
set1={1,2,3,4,5,1,2}
set2={2,3,6,8,8}
print(set1, set2)  # 打印结果自动去重
```

```py
set1={1,4,7,5,9,6}; set2=set([2,4,5,9,8])
print(set1 & set2)   # 交集（intersection）
print(set1 | set2)   # 并集（union）
print(set1 - set2)   # 差集：set1 有 set2 没有（difference）
print(set1 ^ set2)   # 对称差集：我有你没有 + 你有我没有
set1.add(88)         # 增：添加一个元素
set1.update([168,998]) # 增：添加多个
set1.remove(88)      # 删：不存在会报错
set1.discard(666)    # 删：不存在不报错（更安全）
print(set1)
```

练习：4 个选修课名单，求交集

```py
math=["张三","田七","李四","马六"]
english=["李四","王五","田七","陈八"]
art=["陈八","张三","田七","赵九"]
music=["李四","田七","马六","赵九"]
# 同时选修 math 和 music 的人
print(set(math).intersection(set(music)))
# 同时选修 4 门课的人
print(set(math).intersection(set(english),set(music),set(art)))
```

**python 数据类型总结**：

- 序列（有下标）：字符串、列表、元组；无下标：字典、集合。
- 不可变：数字、字符串、元组；可变：列表、字典、集合。
- 可增删：列表、字典、集合；可改元素：列表、字典（集合不可改元素）。

**括号使用总结**：`()` 元组/调用；`[]` 列表/下标/字典取 key；`{}` 字典/集合/format 占位。

## python文件IO操作

**文件操作三步骤**：open 打开 → 读写操作 → close 关闭。

**访问模式**（`open(文件, 模式)`）：

| 模式 | 说明 |
| :--- | :--- |
| r | 只读（文件必须存在） |
| w | 只写（存在则覆盖，不存在则创建） |
| a | 追加（不能读） |
| r+/w+/a+ | 读写 / 写读 / 追加读 |
| rb/wb/ab | 二进制读 / 写 / 追加 |

**只读模式（r）**：

```py
f=open("/tmp/1.txt",encoding="utf-8") # 默认只读；跨平台编码不一致时需指定 encoding
data1=f.read()
data2=f.read()   # 读第二遍无结果：光标已到文件末尾
f.close()
```

**只写模式（w）**（存在则覆盖，注意不要误清原文件）：

```py
f=open("/tmp/1.txt",'w')
f.write("hello\n") # 不加 \n 不换行
f.truncate(3)      # 截断：保留前 3 字节（0 为清空）
f.flush()          # 强制把缓冲区写入磁盘
f.close()
```

**追加模式（a）**（类似 shell 的 `>>`）：

```py
f=open("/tmp/2.txt",'a')
f.write("hello\n")
f.close()
```

> 扩展：Linux 上 `chattr +a /tmp/2.txt` 后文件只能追加，python 的 w/a 模式也无法用 truncate 清空。

## 深入理解 python的io操作

**文件光标**：`tell()` 查看光标位置，`seek(n)` 移动光标；`read()` 读光标后的所有内容。

```py
f=open("/tmp/2.txt","r")
print(f.tell())     # 刚打开光标在 0
f.seek(5)           # 光标移到第 5 个字符
data1=f.read()      # read：读光标后全部
data2=f.readline()  # readline：读光标所在行
data3=f.readlines() # readlines：按行做成列表
f.close()
```

**文件读的循环**：大文件推荐 `for line in f` 逐行读（不一次性全读，效率高）；`strip()` 去掉换行。

```py
f=open("/tmp/2.txt","r")
for index,line in enumerate(f):  # 推荐：逐行读
   print(index,line.strip())
f.close()
```

示例：通过 /proc/meminfo 获取可用内存

```py
f=open("/proc/meminfo","r")
for line in f:
   if line.startswith("MemAvailable"):
      print(line.split()[1])
f.close()
```

练习：打印指定行范围（前 5 行 / 3-7 行 / 奇数行，行号从 1 开始）

```py
f=open("/etc/passwd","r")
for index,line in enumerate(f):
   # if index<5:                 # 前 5 行
   # if 2<=index<=6:             # 3-7 行
   if (index+1)%2 == 1:          # 奇数行
      print(index+1,line.strip())
f.close()
```

通过 /proc/cpuinfo 获取 CPU 核数

```py
f=open("/proc/cpuinfo","r")
count=0
for line in f:
   if line.startswith("processor"):
      count+=1
f.close()
print(count)
```

**r+ / w+ / a+ 区别**：r+ 不清空原文件（只读基础上加写）；w+ 清空原文件（只写基础上加读）；a+ 不清空原文件（追加基础上加读）。

混合读写注意：读写切换时用 `seek()` 确认光标位置。

```py
f=open("/tmp/2.txt","w+")
f.write("11111\n"); f.write("22222\n"); f.write("33333\n")
f.seek(0)        # 光标移到开头
f.write("bbb")   # 覆盖第一行前 3 个字符
f.close()
```

练习：写一个三角形到新文件

```py
f=open("/tmp/3.txt","w+")
for i in range(1,6):
   for j in range(i):
      f.write("*")
   f.write("\n")
f.seek(0)     # 写后需 seek(0) 才能读出来
print(f.read())
f.close()
```

练习：修改 httpd.conf 第 42 行监听端口为 8080

```py
f=open("/etc/httpd/conf/httpd.conf","r+")
for i in range(41):
   f.readline()
f.seek(f.tell())       # 写光标同步到读光标位置
f.write("Listen 8080\n")
f.close()
```

**读写切换要点**：`read()/readline()` 后写光标会跑到末尾，`write()` 也会影响读光标；切换前用 `seek(0)` 或 `seek(f.tell())` 确认位置。

**二进制模式**（用于网络传输）：读写需要 `encode()/decode()`。

```py
f=open("/tmp/2.txt","rb")  # 二进制读
print(f.readline())
f=open("/tmp/2.txt","wb")  # 二进制写
f.write("hello".encode())
f.close()
```

**文件字符串全替换**（了解）：一读一写，替换后覆盖回来。

```py
import sys,os
oldstr=sys.argv[1]; newstr=sys.argv[2] # 类似 shell 的 $1 $2
f1=open("/tmp/1.txt",'r'); f2=open("/tmp/2.txt",'w')
for i in f1:
   if oldstr in i:
      i=i.replace(oldstr,newstr)
   f2.write(i)
os.remove("/tmp/1.txt"); os.rename("/tmp/2.txt","/tmp/1.txt")
f1.close(); f2.close()
```

## 模块

**模块**：以 `.py` 结尾的 python 文件（如 `hello.py`，模块名 `hello`），实现一个或多个功能。

**模块分类**：①标准库（自带，直接 import）；②第三方模块（需 pip 安装）；③自定义模块。

**模块路径**：`sys.path` 查看（类似 shell 的 $PATH，按顺序找同名模块），可用 `sys.path.append()` 添加。

**`__name__ == "__main__"`**：直接执行本文件时成立；被 import 时不成立。

```py
# hello.py
def funct1(): print("funct1")
if __name__ == "__main__":
   print("直接执行时打印")
else:
   print("被导入时打印")
```

**导入语法**：

```py
import hello              # 导入单模块
import module1,module2    # 导入多模块
from hello import *       # 导入所有（直接用函数名）
from hello import funct1  # 导入部分
from hello import funct1 as f1  # 别名，避免与本地函数冲突
```

**import 与 from 的区别**：`import` 需 `模块.函数()` 调用；`from` 相当于把函数定义复制到本地，直接 `函数()` 调用，但可能与本地的同名函数冲突（本地的覆盖导入的）。

```py
import hello
hello.funct1()  # 需带模块名

from hello import funct1
funct1()        # 直接调用；本地有同名函数则本地优先
```

**包（了解）**：包是组织模块的目录，目录里必须有 `__init__.py` 文件（导入包即执行它）。

**标准库之 os 模块**：

```py
import os
os.getcwd()                # 当前目录
os.listdir("/")            # 列出目录内容
os.path.getsize(__file__)  # 文件大小（__file__ 代表程序自身）
os.path.abspath(__file__)  # 绝对路径
os.path.dirname("/etc/fstab")  # 目录名
os.path.basename("/etc/fstab") # 文件名
os.path.join("/etc","fstab")   # 拼接路径
os.path.exists("/tmp/1.txt")   # 是否存在
os.path.isfile() / isdir() / islink()  # 判断文件/目录/链接
os.rename() / os.remove() / os.mkdir() / os.rmdir()
os.makedirs("/tmp/a/b/c/d")    # 连续建多级目录
```

**os.popen 与 os.system**：都可执行 Linux 命令；`os.popen(cmd).read()` 能拿到命令输出，`os.system(cmd)` 只显示返回值（类似 shell 的 $?）。拿输出赋值用 popen。

练习：递归查找一个目录里的所有链接文件

```py
import os
dir=input("input a directory: ")
def find_symlink(dir):
   for file in os.listdir(dir):
      absfile = os.path.join(dir,file)
      if os.path.islink(absfile):
         print("{} is a symbol link".format(absfile))
      elif os.path.isdir(absfile):
         find_symlink(absfile)
if os.path.isdir(dir):
   find_symlink(dir)
```

扩展练习：
- 递归查找空文件：`if os.path.getsize(absfile) == 0:`
- 递归查找死链接：`if os.path.islink(absfile) and not os.path.exists(absfile):`
- 递归查找特定类型文件：`if absfile.endswith(".avi") or absfile.endswith(".mp4"):`
- 递归查找 24 小时内修改的文件：`if time.time() - os.path.getmtime(absfile) <= 86400:`

**标准库之 sys 模块**：

```py
print(sys.path)              # 模块路径
print(sys.version)           # python 版本
print(sys.platform)          # 平台名（linux 等）
sys.argv[0]                  # 脚本名（类似 $0），argv[1] 类似 $1
sys.exit(1)                  # 退出程序
sys.stdout.write('hi')       # 不换行打印
```

```py
import sys,os
command=" ".join(sys.argv[1:])  # 把命令行参数拼成命令字符串
print(os.popen(command).read()) # 执行并取结果
# 用法：python3.6 1.py df -h
```

**标准库之 random 模块**：

```py
import random
random.random()          # 0-1 之间浮点数
random.randint(1,3)      # 1-3 整数（含 3）
random.randrange(1,9,2)  # 1,3,5,7（步长 2）
random.choice("hello")   # 随机取一个字符
random.sample("hello",3) # 随机取 3 个做列表
random.shuffle(list)     # 洗牌
```

示例：生成验证码（小写字母 / 混合大写+小写+数字）

```py
import random
# 4 位小写字母
code="".join(chr(random.randint(97,122)) for i in range(4))
print(code)
# 混合大写、小写、数字
code=""
for i in range(4):
   a=random.randint(1,3)
   if a==1:      code+=chr(random.randrange(65,91))  # A-Z
   elif a==2:    code+=chr(random.randrange(97,123)) # a-z
   else:         code+=chr(random.randrange(48,58))  # 0-9
print(code)
```

课外兴趣题（不做要求）：伪随机抽卡游戏，按自己想法扩展。

标准库之re模块
re是regex的缩写,也就是正则表达式

```text
表达式或符号   描述
^              开头
$              结尾
[abc]          代表一个字符（a,b,c任取其一）
[^abc]         代表一个字符（但不能为a,b,c其一)
[0-9]          代表一个字符（0-9任取其一)
[a-z]          代表一个字符（a-z任取其一)
[A-Z]          代表一个字符（A-Z任取其一)
.              一个任意字符
*0             个或多个前字符
.*             代表任意字符
+1             个或多个前字符
?              代表0个或1个前字符
\d             匹配数字0-9
\D             匹配非数字
\w             匹配[A-Za-z0-9]
\W             匹配非[A-Za-z0-9]
\s             匹配空格,制表符
\S             匹配非空格，非制表符
{n}            匹配n次前字符
{n,m}          匹配n到m次前字符

模块+函数（方法）    描述
re.match()           开头匹配,类似shell里的^符号
re.search()          整行匹配，但只匹配第一个
re.findall()         全匹配并把所有匹配的字符串做成列表
re.split()           以匹配的字符串做分隔符，并将分隔的转为list类型
re.sub()             匹配并替换
```

**re 模块常用函数**：

```py
import re
re.match("aaa","aaasd")          # 开头匹配（类似 ^），成功返回对象，失败 None
re.search("aaa","sdfaaasd")      # 全串匹配，只返回第一个
re.findall("aaa\d+","aaa111bbb") # 匹配全部，返回列表
re.split(":","root:x:0")         # 按匹配内容分隔成列表
re.sub(":","-","root:x:0",count=2) # 替换（count 限制次数）
# 匹配结果用 .group() 取出
```

练习：用正则判断强密码（长度≥8，含大写/小写/数字/下划线）

```py
import re
password=input('check passwd:')
if len(password)<8:
   print('too short')
elif re.search('\d',password) and re.search('[a-z]',password) \
     and re.search('[A-Z]',password) and re.search('[_]',password):
   print('strong passwd')
else:
   print('weak passwd')
```

## 标准库之 time / datetime / calendar 模块

**三种时间类型**：

| 类型 | 说明 |
| :--- | :--- |
| struct_time 时间元组 | 记录年、月、日、时、分等 |
| timestamp 时间戳 | 距 1970-01-01 00:00:00 的秒数 |
| 格式化字符串 | 如 "2018-01-01 12:00:00" |

三种类型之间的转换关系:

```text
                        ┌─────────────────────────────┐
                        │   格式化字符串（str）          │
                        │   如 "2018-01-01 12:00:00"   │
                        └─────────────┬───────────────┘
                                      │
               strptime(字符串→元组)   │   strftime(元组→字符串)
                                      ▼
                        ┌─────────────────────────────┐
                        │   时间元组 struct_time       │
                        │   time.localtime() 获取      │
                        └─────────────┬───────────────┘
                                      │
                localtime/gmtime(戳→组)│   mktime(元组→时间戳)
                                      ▼
                        ┌─────────────────────────────┐
                        │   时间戳 timestamp           │
                        │   time.time() 距1970的秒数    │
                        └─────────────────────────────┘

转换速记：
- 时间戳 ↔ 时间元组：time.localtime(戳) / time.mktime(组)
- 时间元组 ↔ 格式化字符串：time.strftime(格式, 组) / time.strptime(串, 格式)
- 时间戳 → 格式化字符串：time.ctime(戳) / time.strftime(格式, time.localtime(戳))
```

示例：三种基本格式的打印与转换

```py
import time
print(time.time())                          # 时间戳
print(time.localtime())                     # 时间元组（本地时区）
print(time.strftime("%Y-%m-%d %H:%M:%S"))   # 格式化字符串
# 转换
print(time.mktime(time.localtime()))                      # 元组→时间戳
print(time.strftime("%Y-%m-%d",time.localtime()))         # 元组→字符串
print(time.strptime("2018-01-01","%Y-%m-%d"))             # 字符串→元组
print(time.ctime(335235))                                 # 时间戳→字符串
```

datetime / calendar 模块：

```py
import datetime,calendar
print(datetime.datetime.now())                 # 当前时间
print(datetime.datetime.now()+datetime.timedelta(days=-3))  # 三天前
print(datetime.datetime.now()+datetime.timedelta(hours=5))  # 五小时后
print(calendar.isleap(2016))                   # 是否闰年
```

练习：打印昨天日期 / 一年后时间

```py
# 昨天日期
import time
print(time.strftime("%Y-%m-%d",time.localtime(time.time()-86400)))
# 一年后
time_list=list(time.localtime()); time_list[0]+=1
print(time.strftime("%F %T",tuple(time_list)))
```
练习：写一个倒计时 / 定时程序

```py
import time
goal=input("输入定时时间(年-月-日 时:分:秒):")
while True:
   now=time.strftime("%Y-%m-%d %H:%M:%S")
   time.sleep(1)
   if now==goal:
      print("时间到了!"); break
```

## 第三方模块之psutil

psutil 是跨平台系统监控库，可获取进程和 CPU/内存/磁盘/网络等系统利用率（对应 top/vmstat/sar/free 等命令）。第三方模块需先安装：

```bash
pip3.6 install psutil
```

示例：psutil 常用操作

```py
import psutil
# CPU
print(psutil.cpu_times()) # CPU 状态
print(psutil.cpu_count()) # CPU 核数
# 内存
print(psutil.virtual_memory()) # 内存状态
print(psutil.swap_memory())    # swap 状态
# 磁盘
print(psutil.disk_partitions()) # 所有分区
print(psutil.disk_usage("/"))   # / 分区使用情况
# 网络 / 进程
print(psutil.net_io_counters())  # 网卡总收发信息
print(psutil.pids())             # 所有进程 pid
print(psutil.pid_exists(1))      # 判断 pid 是否存在
print(psutil.users())            # 当前登录用户
```

示例：监控 / 分区磁盘使用率，超阈值发微信（需 itchat 模块）

```py
import psutil,itchat
itchat.auto_login(hotReload=True)                    # 扫码登录，缓存免重复登录
user_id=itchat.search_friends("Candy")[0]['UserName']
if psutil.disk_usage("/")[1]/psutil.disk_usage("/")[0] > 0.9:  # 使用率超 90%
   itchat.send("/ is overload", toUserName=user_id)
```

## 第三方模块之paramiko

paramiko 用 SSH 远程执行命令、上传/下载文件。Linux 下远程 SSH 免密一般用 `ssh-keygen` 或 `expect` 应答密码。

```bash
pip3.6 install paramiko
```

示例：传密码远程登录并执行命令

```py
import paramiko
ssh=paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy) # 免去首次连接的 yes 确认
ssh.connect(hostname="10.1.1.12",port=22,username="root",password="123456")
stdin,stdout,stderr=ssh.exec_command("touch /tmp/123")  # 执行命令
print(stdout.read().decode())  # 网络传输是二进制，需 decode
ssh.close()
```
示例：input 传参 + getpass 隐藏密码（getpass 在 pycharm 有 bug，建议 bash 下执行）

```py
import paramiko,getpass
host=input("input your ip: ")
command=input("input your command: ")
passwd=getpass.getpass("input your password: ")
ssh=paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
ssh.connect(hostname=host,port=22,username="root",password=passwd)
stdin,stdout,stderr=ssh.exec_command(command)
print(stdout.read().decode())
print(stderr.read().decode())
ssh.close()
```

示例：密钥免密登录（先 `ssh-keygen` + `ssh-copy-id` 做好免密）

```py
import paramiko
private_key=paramiko.RSAKey.from_private_key_file("/root/.ssh/id_rsa")
ssh=paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
ssh.connect(hostname="10.1.1.12",port=22,username="root",pkey=private_key)
stdin,stdout,stderr=ssh.exec_command("touch /tmp/321")
print(stdout.read().decode())
ssh.close()
```

示例：文件上传下载（sftp，密码 / 密钥两种方式，路径必须写完整文件名）

```py
import paramiko
trans=paramiko.Transport(("10.1.1.12",22))
trans.connect(username="root",password="123456")  # 或用 pkey=private_key 免密
sftp=paramiko.SFTPClient.from_transport(trans)
sftp.get("/etc/fstab","/tmp/fstab")  # 远程下载到本地
sftp.put("/etc/inittab","/tmp/inittab") # 本地上传到远程
trans.close()
```

第三模块之pymysql(拓展)

```bash
yum install mariadb*
systemctl restart mariadb
pip3.6 install pymysql
```

示例：连接、查询、建表

```py
import pymysql
db=pymysql.connect(host="localhost",user="root",password="",port=3306,db="mysql")
cursor=db.cursor()              # 创建游标（类似操作光标）
cursor.execute("show tables;")
print(cursor.fetchall())        # fetchone/fetchmany(2)/fetchall 取一行/N行/全部
cursor.execute("create table emp(ename varchar(20),sex char(1),sal int)")
cursor.close(); db.close()
```

示例：远程数据库授权 + 远程连接插入数据（DML 需 commit 才真正生效）

```py
# 在数据库服务器上授权
# create database aaadb;
# grant all on aaadb.* to 'aaa'@'10.1.1.11' identified by '123';

import pymysql
db=pymysql.connect(host="10.1.1.12",user="aaa",password="123",port=3306,db="aaadb")
cursor=db.cursor()
cursor.execute("create table hosts(ip varchar(15),password varchar(10),hostgroup tinyint)")

# 插入数据三种方式
cursor.execute("insert into hosts(ip,password,hostgroup) values('10.1.1.22','123456',1)")
insertsql='''insert into hosts values ('10.1.1.23','123456',1),('10.1.1.24','123456',1)'''
cursor.execute(insertsql)
data=[('10.1.1.25','12345',2),('10.1.1.26','12345',3)]
cursor.executemany("insert into hosts(ip,password,hostgroup) values(%s,%s,%s);",data)
db.commit() # DML 操作必须 commit 才真正写入数据库
cursor.execute("select * from hosts;")
print(cursor.fetchall())
cursor.close(); db.close()
```

## 异常处理(了解)

程序运行出错会抛出异常，不处理会导致程序终止。常见异常：

```text
IndentationError  缩进错误     NameError  名字未定义
IndexError       下标越界     KeyError   键不存在
SyntaxError      语法错误     TypeError  类型错误
AttributeError   属性不存在   ImportError 导入模块失败
KeyboardInterrupt  Ctrl+C 被按下
```

**try/except 语法**：

```py
try:
   可能出错的代码
except 异常类型 as err:   # 捕获指定异常，多个 except 从上往下匹配
   处理代码
else:                     # 没有异常才执行
   ...
finally:                  # 无论是否异常都执行
   ...
```

示例：

```py
list1=[1,2,3]
try:
   print(list1[3])              # IndexError
except TypeError as err:        # 类型不匹配
   print("error1",err)
except IndexError as err:       # 下标越界
   print("error2:",err)
except Exception as err:        # Exception 兜底所有异常
   print("error3",err)
else:
   print("everything is ok")
finally:
   print("无论异常与否都会执行")
```

自定义异常（学了面向对象后理解）：继承 `Exception`，用 `raise` 主动抛出。

```py
class Daniel_define_exception(Exception):
   def __init__(self, error_msg):
      self.error_msg=error_msg
num=int(input("input a num bigger than 10:"))
if num<11:
   try:
      raise Daniel_define_exception("must bigger than 10!")
   except Daniel_define_exception as error:
      print(error)
```

## 面向对象编程

**面向过程 vs 面向对象**：面向过程强调"自己一步步做"；面向对象强调"让对象帮你做"。

**类与对象**：类是特征抽象（创建对象的模板），对象是类的具体实例。

**类的三要素**：类名、属性（数据）、方法（行为）。

```py
class People(object):  # 类名建议大驼峰命名
   pass
p1=People()  # 实例化：创建对象
print(id(p1)) # 每个实例是独立内存对象
```

**给对象加属性 / 用构造函数传参**：

```py
# 方式一：实例化后手动加属性
p1=People(); p2=People()
p1.name="zhangsan"; p1.sex="man"
p2.name="lisi";     p2.sex="woman"
print(p1.name,p1.sex)

# 方式二：__init__ 构造函数，实例化时直接传参（self 代表实例本身）
class People(object):
   def __init__(self,name,sex):  # 构造函数
      self.name=name  # 实例变量
      self.sex=sex
p1=People("zhangsan","man")
print(p1.name,p1.sex)
```

**给类加方法**（方法就是一个封装在类里的函数）：

```py
class People(object):
   def __init__(self,name,sex):
      self.name=name; self.sex=sex
   def info(self):  # 方法
      print(self.name,self.sex)
p1=People("zhangsan","man")
p1.info()  # 对象调用方法
```

**类的变量（类变量 vs 实例变量）**：

```py
class People(object):
   country="china"  # 类变量：所有实例共享
   def __init__(self,name,sex):
      self.name=name  # 实例变量
      self.sex=sex
p1=People("zhangsan","man"); p2=People("lisi","woman")
print(People.country)  # 类名可调用类变量
print(p1.country)      # 实例也可调用
# 同名时实例变量优先；对某实例修改类变量不影响其他实例
p2.country="USA"
print(p1.country, p2.country)  # china, USA
```

**类变量小结**：
- 类变量对所有实例生效，增删改也影响所有实例（与实例变量同名时实例变量优先）。
- 类和实例是独立内存空间，在实例里修改只对本实例生效。
- 类比：类变量像全局配置，实例变量像子配置。

**__str__ 与 __del__（了解）**：

```py
class Hero(object):
   def __init__(self,name):
      self.name=name
   def __str__(self):   # print(对象) 时输出此返回值
      return "我叫{},我为自己代言".format(self.name)
   def __del__(self):   # 对象销毁时自动调用（收尾工作）
      print("......我{}还会回来的......".format(self.name))

hero1=Hero("亚瑟")
print(hero1)
del hero1
```

小结：`__init__` 创建对象时自动调用；`__str__` 打印对象时调用；`__del__` 对象销毁时自动调用（收尾，如关闭文件）。

**私有属性与私有方法（拓展）**：python 没有 public/private 关键字，在变量/方法名前加 `__` 即私有，类外部不能直接调用。

```py
class People(object):
   __country="china"      # 私有类属性
   def __init__(self,name,sex):
      self.name=name
      self.__sex=sex      # 私有实例属性
   def __info(self):      # 私有方法
      print(self.name,self.__sex)
   def show_info(self):   # 对外提供的方法来访问私有属性
      self.__info()
p1=People("zhangsan","man")
p1.show_info()            # 通过公有方法间接访问私有
```

## 继承

面向对象三大特性：**封装、继承、多态**。继承的作用：减少代码冗余、便于功能升级与扩展。

```py
class People(object):
   def __init__(self,name,age):
      self.name=name; self.age=age
   def eat(self):
      print("come to eat,{}".format(self.name))
   def drink(self):
      print("come to drink,{}".format(self.name))

class Man(People):   # Man 继承父类 People
   pass
class Woman(People):
   pass
m1=Man("zhangsan",16)
m1.eat()   # 继承后可直接调用父类方法
```

**方法重写**：子类定义与父类同名方法，子类方法优先生效。

```py
class Man(People):
   def drink(self):   # 重写父类 drink
      if self.age>=18:
         print("you can drink!")
      else:
         print("you can not drink!")
m1=Man("zhangsan",16)
m1.drink()
```

**子类重新构造属性**：子类新增属性时重写 `__init__`，用 `People.__init__(self,..)` 或 `super()` 调用父类构造。

```py
class Woman(People):
   def __init__(self,name,age,bra_size):
      People.__init__(self,name,age)  # 或 super(Woman,self).__init__(name,age)
      self.bra_size=bra_size
w1=Woman("lisi",18,"D")
w1.eat()
```

**多层继承**：孩子类可调用爷爷类的方法。

```py
class Grandfather():
   def house(self): print("a big house!")
class Father(Grandfather):
   def car(self): print("a cool car!")
class child(Father):
   pass
p1=child(); p1.house()  # 调用爷爷的方法
```

**多继承（了解）**：子类有多个父类（python/c++ 支持，java/php 只支持单继承），继承所有父类特性。

```py
class Father(object):
   def sing(self): print("can sing")
class Mother(object):
   def dance(self): print("can dance")
class child(Father,Mother):  # 多继承
   pass
p1=child(); p1.sing(); p1.dance()
```

**多态（了解）**：一类事物多种形态（如水：蒸汽/水/冰）。python 变量类型由赋值决定（动态），只要对象有该方法就能调用，这就是"鸭子类型"——关注对象怎么用，不关注类型本身。作用：接口统一。

```py
class Animal(object):
   def jiao(self): pass
class Dog(Animal):
   def jiao(self): print("wang wang...")
class Cat(Animal):
   def jiao(self): print("miao miao...")

def jiao(obj):   # 统一调用接口
   obj.jiao()
jiao(Dog()); jiao(Cat())
```

## 综合题目
示例: 一个英雄与怪物互砍小游戏
```py
import random
# 定义英雄类
class Hero(object):
   def __init__(self,name):
      self.name = name
      self.hp = 100 # 血量
      self.attack = random.randint(31, 100) # 随机产生攻击值
      self.defense = 30
   # 显示英雄信息
   def __str__(self):
      return "名字:%s 血量:%s 攻击:%d 防御:%d" % (self.name, self.hp, self.attack,self.defense)
   # 攻击函数
   def fight(self, monster):
      # 计算怪物掉血多少
      mhp = self.attack - monster.defense
      # 减少怪物血量
      monster.hp = monster.hp - mhp
      # 提示信息
      print("英雄[%s]对怪物[%s]造成了%d伤害!" % (self.name, monster.name, mhp))

# 定义怪物类
class Monster(object):
   def __init__(self,name):
      self.name = name
      self.hp = 100 # 血量
      self.attack = random.randint(31, 100) # 随机产生攻击值
      self.defense = 30
   # 显示怪物信息
   def __str__(self):
      return "名字:%s 血量:%s 攻击:%d 防御:%d" % (self.name, self.hp, self.attack,self.defense)
   # 攻击函数
   def fight(self, hero):
      # 计算怪物掉血多少
      mhp = self.attack - hero.defense
      # 减少怪物血量
      hero.hp = hero.hp - mhp
      # 提示信息
      print("怪物[%s]对英雄[%s]造成了%d伤害!" % (self.name, hero.name, mhp))

# 创建对象
hero = Hero("一刀满级")
# 创建怪物
monster = Monster("打死我爆好装备")
# 回合数
my_round = 1
# 开始回合战斗
while True:
   input()
   print(hero)
   print(monster)
   print("-"*50)
   print("当前第%d回合:" % my_round)
   hero.fight(monster)
   if monster.hp <= 0:
      print("英雄[%s]击败了怪物[%s],顺利通关!" % (hero.name, monster.name))
      break
   monster.fight(hero)
   if hero.hp <= 0:
      print("怪物[%s]仰天大笑，哈哈哈,弱鸡!" % monster.name)
      break
   my_round += 1
print("Game Over!")

```

示例: 下例把paramiko的远程执行命令，上传，下载功能简单地做成了面向对象编程的方法。请解决相关bug或按
此思路扩展写其它程序
```py
import paramiko,sys
class Host(object):
   port = 22
   def __init__(self,ip,port,username,password):
      self.ip=ip
      self.port=port
      self.username=username
      self.password=password
   def exec_cmd(self):
      ssh=paramiko.SSHClient()
      ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
      ssh.connect(hostname=self.ip,port=self.port,username=self.username,password=self.password)
      input_cmd=input("input your command: ")
      stdin, stdout, stderr = ssh.exec_command(input_cmd)
      cor_res = stdout.read()
      err_res = stderr.read()
      print(cor_res.decode())
      print(err_res.decode())
      ssh.close()
   def get_or_put(self):
      trans=paramiko.Transport((self.ip,int(self.port)))
      trans.connect(username=self.username,password=self.password)
      sftp = paramiko.SFTPClient.from_transport(trans)
      if choice == 2:
         get_remote_file=input("下载文件的路径: ")
         get_local_file=input("下载到本地的路径: ")
         sftp.get(get_remote_file,get_local_file)
      else:
         put_local_file=input("要上传的本地文件路径: ")
         put_remote_path=input("上传到远程的路径: ")
         sftp.put(put_local_file,put_remote_path)

print("菜单")
print("1-exec")
print("2-get")
print("3-put")
print("0-quit")

host1=Host(sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4])
choice=int(input("your choice: "))
if choice == 1:
   host1.exec_cmd()
elif choice == 2 or choice == 3:
   host1.get_or_put()
elif choice == 0:
   exit(1)

# python3.6 脚本名 10.1.1.12 22 root 123456
```

