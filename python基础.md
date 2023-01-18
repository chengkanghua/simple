python基础

## 认识python

python的哲学: 明确,优雅,简单
kiss keep it simple,keep it stupid
问题: 我都学了shell，为什么还要学python？
答: python更强大，功能更丰富，执行效率比shell高。还有就是顺应开发型运维的趋势.

## python的优缺点

python优点:

1. 简单,易学,易懂,开发效率高：Python容易上手,语法较简单。在linux上和写shell一样，拿着vi都可以写，直接就可以运行。
2. 免费、开源：我们运维用的大部分软件都是开源啊,亲！
3. 可移植性,跨平台：Python已经被移植在许多不同的平台上,Python程序无需修改就可以在Linux,Windows,mac等平台上运行。
4. 可扩展性：如果你需要你的一段关键代码运行得更快或者希望某些算法不公开，你可以把你的部分程序用C或C++编写，然后在你的Python程序中使用它们（讲完编译型语言和解释型语言区别就容易理解了)。
5. 丰富的库： 想产生个随机数? 调库啊。想操作os? 调库啊。想操作mysql? 调库啊调库君。。。。。。Python的库太丰富宠大了，它可以帮助你处理及应对各种场景应用。
6. 规范的代码：Python采用强制缩进的方式使得代码具有极佳的可读性。

python缺点：

1. 执行效率慢 : 这是解释型语言(下面的解释器会讲解说明)所通有的，同时这个缺点也被计算机越来越强性能所弥补。有些场景慢个几微秒几毫秒,一般也感觉不到。
2. 代码不能加密: 这也是解释型语言的通有毛病，当然也有一些方法可以混淆代码。解决方法: 参考优点的第4条.

## Python应用场景

1. 操作系统管理、服务器运维的自动化脚本
   一般说来，Python编写的系统管理脚本在可读性、性能、代码重用度、扩展性几方面都优于普通的shell脚本。
2. Web开发
   Python经常被用于Web开发。比如，通过mod_wsgi模块，Apache可以运行用Python编写的Web程序。Python定   义了WSGI标准应用接口来协调Http服务器与基于Python的Web程序之间的通信。一些Web框架，如   Django,TurboGears,web2py,Zope等，可以让程序员轻松地开发和管理复杂的Web程序。
3. 服务器软件（网络软件）
   Python对于各种网络协议的支持很完善，因此经常被用于编写服务器软件、网络爬虫。第三方库Twisted支持异步   网络编程和多数标准的网络协议(包含客户端和服务器)，并且提供了多种工具，被广泛用于编写高性能的服务器软件。
4. 游戏
   很多游戏使用C++编写图形显示等高性能模块，而使用Python或者Lua编写游戏的逻辑、服务器。相较于Python，   Lua的功能更简单、体积更小；而Python则支持更多的特性和数据类型。
5. 科学计算
   NumPy,SciPy,Matplotlib可以让Python程序员编写科学计算程序。
6. 其它领域
   无人驾驶，人工智能等。

## 解释型语言与编译型语言

计算机只能识别机器语言（如:01010101001这种）, 程序员不能直接去写01这种代码，所以要程序员所编写的程序
语言翻译成机器语言。将其他语言翻译成机器语言的工具，称之为编译器。
如：中国人 ---（翻译）----外国人
编译器翻译的方式有两种，一种是编译，一种是解释。区别如下:

![](assets_python基础/2023-01-18-12-42-05-image.png)

正因为这样的区别，所以解释型语言开发效率高,但执行慢和无法加密代码



## python版本

python2.x 2020年终止维护
python3.x 目前主流版本
python官网下载地址:
https://www.python.org/getit/



## 第一个python脚本

```py
# vim 1.py
#!/usr/bin/python # 声明类型,指明解释器命令路径
#-*- coding: utf-8 -*- # 指定字符格式为utf-8（可以打印中文）,python3不用再指定了
print "hellow world" # python2的写法,python3执行会报错
print ("hello world") # python3的写法,python2也可以执行
print ("哈哈") # python2指定了utf-8字符，那么这里就可以使用中文
执行方法一:
# python 1.py
执行方法二:
# chmod 755 1.py
# ./1.py # 需要有执行权限和声明类型才能这样执行
```

2. 使用python命令（默认版本)交互写

```py
# python
>>> print ("hello world")
hello world
>>> exit() --使用exit()或ctrl+d键来退出
```

## python安装

在linux上(虚拟机的话请把内存调大点)安装python3.x（我这里为3.6.6版本)

```bash
linux系统如果gnome图形界面和开发工具都安装了,那么就还需要安装zlib-devel,openssl,openssl-devel这
几个依赖包
# yum install zlib-devel openssl openssl-devel
# tar xf Python-3.6.6.tar.xz -C /usr/src/
# cd /usr/src/Python-3.6.6/
# ./configure --enable-optimizations
编译第一步如果报错,十之八九是缺少依赖包
# make --这一步时间较长(20-30分钟，视机器速度而定)
编译第二步如果报错,有可能是系统兼容性的问题，换一个版本或编译参数试试（有人这一步可能会卡住，那么在前一步
不加--enable-optimizations参数重试)
# make install
编译第三步几乎不会报错，除非你的安装路径空间不够了
# ls /usr/local/bin/python3.6 --确认此命令
# ls /usr/local/bin/pip3.6 --确认此命令,pip为python安装模块的命令
```

pycharm安装

yCharm是一种Python IDE（Integrated Development Environment, 集成开发环境）。它带有一整套可以帮助
用户在使用Python语言开发时提高其效率的工具，比如调试、语法高亮、Project管理、代码跳转、智能提示、自
动完成、单元测试、版本控制。
pycharm官网下载地址:
http://www.jetbrains.com/pycharm/download/#section=linux
专业版: 功能全，需要收费，但可以试用30天
社区版: 免费版，学习基础够用了



## pyenv安装(了解)

pyenv是一个python多版本管理工具，当服务器上存在不同版本的python项目时，使用pyenv可以做到多版本的
隔离使用(类似虚拟化)，每个项目使用不同版本互不影响。
pyenv文档及安装地址:
https://github.com/pyenv/pyenv

```bash
1,使用git clone下载安装到家目录的.pyenv目录
# git clone https://github.com/pyenv/pyenv.git ~/.pyenv
2,设置环境变量,并使之生效,这样才能直接使用pyenv命令
# echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /etc/profile
# echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /etc/profile
# source ~/.bash_profile
# pyenv help
# pyenv install -l --或者使用pyenv install --list列出所有的python当前可用版本
3,先解决常见依赖包的问题，否则下一步安装会报错
# yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-
devel tk-devel gdbm-devel libpcap-devel xz-devel -y
4,安装3.6.6版本,需要下载并安装,速度较慢。它会安装到~/.pyenv/versions/下对应的版本号
# pyenv install 3.6.6
5,查看当前安装的版本,前面带*号的是默认使用的版本
# pyenv versions
* system (set by /root/.pyenv/version)
3.6.6
```

pyenv-virtualenv是pyenv的插件，为pyenv设置的python版本提供隔离的虚拟环境。不同版本的python在不同
的虚拟环境里使用互不影响。
pyenv-virtualenv文档及安装地址:
https://github.com/pyenv/pyenv-virtualenv



```bash
1，将pyenv-virtualenv这个plugin下载安装到pyenv根目录的plugins/下叫pyenv-virtualenv
# git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-
virtualenv
2，把安装的3.6.6版本做一个隔离的虚拟化环境，取名为python3.6.6(这个取名是自定义的)
# pyenv virtualenv 3.6.6 python3.6.6
3，active激活使用，但报错
# pyenv activate python3.6.6
Failed to activate virtualenv.
Perhaps pyenv-virtualenv has not been loaded into your shell properly.
Please restart current shell and try again.
解决方法:
# echo 'eval "$(pyenv init -)"' >> /etc/profile
# echo 'eval "$(pyenv virtualenv-init -)"' >> /etc/profile# source /etc/profile
4,再次激活，成功
# pyenv activate python3.6.6
pyenv-virtualenv: prompt changing will be removed from future release. configure
`export PYENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
(python3.6.6) [root@daniel ~]# pip install ipython --安装一个ipython测试
5,使用ipython测试完后退出虚拟环境
(python3.6.6) [root@daniel ~]# ipython
In [1]: print ("hello word")
hello word
In [2]: exit
(python3.6.6) [root@daniel ~]# pyenv deactivate --这里exit就退出终端了，用此命令退出虚拟环境
[root@daniel ~]#
这样的话，你可以在linux安装多个版本的python,使用不同的隔离环境来开发不同版本的python程序.
删除隔离环境的方法:
# pyenv uninstall python3.6.6
```
小结:
我们已经安装的几种python开发环境对比:
1. /usr/local/bin/python3.6回车 交互式，没有辅助功能，非图形化
2. vim 1.py 非交互式，没有辅助功能，非图形化
3. pycharm 非交互式，有辅助功能，图形化
4. ipython 交互式，有辅助功能，非图形化


## print 打印

基本的打印规则
Python程序由多个逻辑行构成，一个逻辑行不一定为一个物理行(人眼看到的行)
显式行连接: \ 在物理行后跟反斜杠， 代表此行连接下一行代码
隐式行连接: () [] {} 在括号里换行会自动行连接
字符串需要用引号引起来，单引双引都可以。
示例: 换行打印

```bash
help(print) # 帮助方法
print("hello world")
print("python") # 这是两句分开的打印，会打印两行
print("hello world\npython") # 打印的结果会换行
print('''hello world
python''') # 打印的结果会换行
print("hello world
python") # 错误写法

```
示例: 不换行打印

```bash
print('hello world',end=" ") # python3里加上end=" "，可以实现不换行打印.这两句只打印一行
print("python")
print("hello world \
python") # 使用\符号连接行，物理上换了行，逻辑上并没有换行。
print("hello world"
"python") # (),[],{}里的多行内容不用\连接，但需要每行引起来;打印出来的结果不换行

```
示例: 使用VT100控制码(用来在终端扩展显示的代码)实现有颜色的打印
```bash
shell里也可以实现有颜色的打印
# vim 1.sh
#!/bin/bash
echo -en "\\033[0;30m\\033[0;31mhello world\n\\033[0;30m"
echo -en "\\033[0;30m\\033[0;32mhello world\n\\033[0;30m"
echo -en "\\033[0;30m\\033[0;33mhello world\n\\033[0;30m"
echo -en "\\033[0;30m\\033[0;34mhello world\n\\033[0;30m"
echo -en "\\033[0;30m\\033[0;35mhello world\n\\033[0;30m"
echo -en "\\033[0;30m\\033[0;36mhello world\n\\033[0;30m"

python里实现的有颜色打印
print("\033[31;1;31mhello world\033[0m")
print("\033[31;1;32mhello world\033[0m")
print("\033[31;1;33mhello world\033[0m")
print("\033[31;1;34mhello world\033[0m")
print("\033[31;1;35mhello world\033[0m")
print("\033[31;1;36mhello world\033[0m")
结果如下:
```

## 注释
```py
单行注释
#hello   #后不空行 pycharm下面会有线
# hello  #后空行,pycharm里一切ok

在代码的后面添加注释 ：注释和代码之间要至少有两个空格
print("hello world")# comment
print("hello world") # comment
print("hello world")  # comment  //注释和代码之间两个空格

多行注释 : 三引号（三个双引或三个单引)里包含注释内容
'''
注释内容
'''

"""
注释内容
"""
快捷键 ctrl + /

```
## 代码规范PEP

Python 官方提供有一系列 PEP（Python Enhancement Proposals） 文档
其中第 8 篇文档专门针对 Python 的代码格式 给出了建议，也就是俗称的 PEP 8
文档地址：https://www.python.org/dev/peps/pep-0008/
谷歌有对应的中文文档：http://zh-google-styleguide.readthedocs.io/en/latest/google-python-styleguide/pyth
on_style_rules/

## 变量

变量：在内存中开辟一块空间，存储规定范围内的值，值可以改变。通俗的说变量就是给数据起个名字，通过这个名字来访问和存储空间中的数据。

变量的特点
可以反复存储数据
可以反复取出数据
可以反复更改数据

变量的命名规则
变量名只能是字母、数字或下划线的任意组合
变量名的第一个字符不能是数字
变量名要有见名知义的效果, 如UserName,user_name
变量名区分大小写

以下关键字不能声明为变量名(关键字是python内部使用或有特殊含义的字符) ['False', 'None', 'True', 'and','as', 'assert', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global', 'if','import', 'in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try', 'while', 'with', 'yield']

import keyword # 导入keyword模块
print(keyword.kwlist) # 打印上面的关键字列表


## 变量的创建
```py
num=100 # num第一次出现是表示定义这个变量
num=num-10 # 再次出现，是为此变量赋一个新的值
print(num)

name1="daniel"
print(id(name1))
name2="daniel"
print(id(name2)) # id()函数用于获取对象内存地址;name1和name2得到的id相同,说明指向同一个内存空间
```

## 两个变量值的交换
```py 
a=1
b=2
print(a,b)

a,b=b,a
print(a,b)
```

## 变量的类型

在程序中，为了更好的区分变量的功能和更有效的管理内存，变量也分为不同的类型。
Python是强类型的动态解释型语言。
强类型: 不允许不同类型相加。如整型+字符串会报错。
动态：不用显式声明数据类型，确定一个变量的类型是在第一次给它赋值的时候，也就是说: 变量的数据类型是由值决定的。

```py
name="zhangsan" # str类型
age=25 # 25没有加引号，则为int类型；加了引号，则为str类型;
height=1.8 # float类型
marry=True # bool类型（布尔值)
print(type(name)) # 通过type()函数得知变量的类型
print(type(age))
print(type(height))
print(type(marry))

```

## Python基本数据类型分类

1. 数字
   int 整型(1, 2, -1, -2)
   float 浮点型(34.678)
   bool 布尔型(True/False)
   complex 复数(4+3J, 不应用于常规编程，这种仅了解一下就好
2. 字符串
str 单引号和双引号内表示的内容为字符串 “hello world" "12345"
3. 列表
list 使用中括号表示 [1, 2, 3, 4]
4. 元组
tuple 使用小括号表示 (1, 2, 3, 4)
5. 字典
dict 使用大括号表示，存放key-value键值对 {"a":1, "b":2, "c":3}
6. 集合
set 也使用大括号表示，但与字典有所不同 {1, 2, 3, 4}

## 类型的转换

转换函数      说明
int(xxx)     将xxx转换为整数
float(xxx)   将xxx转换为浮点型
str(xxx)     将xxx转换为字符串
list(xxx)    将xxx转换为列表
tuple(xxx)   将xxx转换为元组
dict(xxx)    将xxx转换为字典
set(xxx)     将xxx转换为集合
chr(xxx)     把整数[0-255]转成对应的ASCII码
ord(xxx)     把ASCII码转成对应的整数[0-255]

```
age=25
print(type(age)) # int类型
age=str(25)
print(type(age)) # str类型

name="zhangsan"
age=25
print(name,"你"+age+"岁了") # str+int，字符串拼接报错;age=str(25),这一句就可以成功。
```

## 输入输出

输入 
还记得shell里的read吗？
```bash
shell里的read输入用法
#!/bin/bash
read -p "input your name:" name
read -p "input your age:" age
echo "$name,you are $age old years"

用python3中可以使用input()函数等待用户的输入（python2中为raw_input()函数)

python里的input输入用法
name=input("what is your name: ")
age=input("what is your age: ") # input输入的直接就为str类型，不需要再str()转换了
print(name,"你"+age+"岁了")
```
输出
普通输出
输出用print()

```bash
print("="*10) # 表示连续打印10个=符号
print("1-系统")
print("2-数据库")
print("3-quit")
print("="*10)
或者
print("="*10)
print('''1-系统 # 使用''' '''符号来换行
2-数据库
3-quit''')
print("="*10)

```

## 格式化输出
还记得awk里的printf吗? (学过C基础的也肯定知道printf)
python里不用printf，但也可以用 % 表示格式化操作符

操作符    说明
%s       字符串
%d       整数
%f       浮点数
%%       输出 %

```py
name=input("what is your name: ")
age=input("what is your age: ")
num=int(input("what is your phone number: ")) # 因为iput输入的纯数字也是是str类型,所以用int()转成int类型，这样才能在后面对应%d

print(name,"you are %s years old,and your phone number is %d"%(age,num)) # 按顺序对应,age对应%s，num对应%d

name=input("what is your name: ")
age=input("what is your age: ")
num=int(input("what is your phone number: "))
# 下面这是一种新的格式化输出写法,不用去纠结是写%s还是%d，只对应好顺序就行.（0代表第一个,1代表第二个)
print(name,"you are {} years old, and your phone number is {}".format(age,num))
print(name,"you are {1} years old, and your phone number is {0}".format(num,age))

```py
name = input("what is your name: ")
sex = input("what is your sex: ")
job = input("what is your job: ")
phonenum = input("what is your number: ")
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

```
算术运算符   描述           
+           加法             
-           减法             
*           乘法             
/           除法             
//           整除                10//3=3(不能整除的只保留整数部分)
**           求幂                2**3=8
%           取余（取模）          10%3=1 得到除法的余数


赋值运算符            描述
=              简单的赋值运算符，下面的全部为复合运算符
+=             加法赋值运算符
-=             减法赋值运算符
*=             乘法赋值运算符
/=             除法赋值运算符
//=            整除赋值运算符
**=            求幂赋值运算符
%=             取余（取模)赋值运算符

比较运算符     描述
==           等于
!=           不等于
<>           不等于
>            大于
<            小于
>=           大于等于
<=           小于等于

print(type(2<=1)) # 结果为bool类型，所以返回值要么为True,要么为False.

逻辑运算符     
and             x and y   两个都为true则返回true
or              x or y    任意一个条件为true,则返回true
not             not x     取反  

成员运算符
在后面讲解和使用序列(str,list,tuple) 时，还会用到以下的运算符
in               x 在 y序列中 就返回true
not in           x  不在 y序列中 就返回true 

身份运算符
is          is判断两个标识符是不是引用一个对象  x i y 类似 id(x) == id(y)
is not      is not判断两个标识符是不是引用不同的对象. x is not y,类似 id(x) != id(y)

is 与 == 区别：
is 用于判断两个变量引用对象是否为同一个(同一个内存空间)， == 用于判断引用变量的值是否相等。
a=[1,2,3]
b=a[:]
c=a
print(b is a) # False
print(b == a) # True
print(c is a) # True
print(c == a) # True

位运算符 (了解)
还记得IP地址与子网掩码的二进制算法吗？
这里的python位运算符也是用于操作二进制的。

位运算符     说明
&           对应二进制位两个都为1，结果为1
|           对应二进制位两个有一个1, 结果为1, 两个都为0才为0
^           对应二进制位两个不一样才为1,否则为0
>>          去除二进制位最右边的位，正数上面补0, 负数上面补1
<<          去除二进制位最左边的位，右边补0
~           二进制位，原为1的变成0, 原为0变成1

运算符的优先级
常用的运算符中: 算术 > 比较 > 逻辑 > 赋值
示例: 请问下面的结果是什么?
result = 3-4 >=0 and 4*(6-2)>15
print(result)

result = 3-4 >=0 and 4*(6-2)>15
          -1          16
            flast      true 
            False
```

## 判断语句

```bash
shell里的判断语句格式
shell单分支判断语句:
if 条件;then
执行动作一
fi
shell双分支判断语句:
if 条件;then
执行动作一
else
执行动作二
fi
shell多分支判断语句:
if 条件一;then
   执行动作一
elif 条件二;then
   执行动作二
elif 条件三;then
   执行动作三
else
   执行动作四
fi

case 变量 in
   值一 )
      动作一;;
   值二 )
      动作二;;
   * )
      其它动作
esac

```







