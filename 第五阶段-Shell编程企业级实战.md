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
Shell是一个命令解释器，它的作用是解释执行用户输入
的命令及程序等，用户输入一条命令，Shell就解释执行
一条。这种从键盘一输入命令，就可以立即得到回应的
对话方式，被称之为交互的方式。
Shell存在于操作系统的最外层，负责直接与用户对话，
把用户的输入解释给操作系统，并处理各种各样的操作
系统的输出结果，输出到屏幕返回给用户，当我们输入
系统用户名和密码，登录到Linux后的所有操作都是由
Shell解释并执行的


## 什么是shell脚本?
了解了Shell后，理解Shell脚本就简单了。当命令或程序
语句不在命令行下执行，而是通过一个程序文件执行
时，该程序就被称为Shell脚本。如果在Shell脚本里内置
了很多条命令、语句及循环控制，然后一次性把这些命
令执行完，这种通过文件执行脚本的方式，称为非交互
的方式。Shell脚本类似于DOS系统下的批处理程序。用户
可以在Shell脚本中敲入一系列的命令及命令语句组合。
这些命令、变量和流程控制语句等有机地结合起来就形
成了一个功能强大的Shell脚本。


## shell脚本在linux运维工作中地位
Shell脚本语言很擅长处理纯文本类型的数据，而Linux系统中几乎所有的
配置文件、日志文件（如NFS、Rsync、Httpd、Nginx、LVS、MySQL
等），以及绝大多数的启动文件都是纯文本类型的文件。自然学好Shell
脚本语言，就可以利用它在Linux系统中发挥巨大的作用。


## 脚本的建立
```
1.脚本的第一行
一个规范的Shell脚本在第一行会指出由哪个程序（解释器）来执行脚本中的内容，这一行内容在Linux bash编程中一般为：
#!/bin/bash或#!/bin/sh #<==255个字符以内
2. bash和sh 的区别
早期的bash与sh稍有不同，它还包含了csh和ksh的特色，
但大多数脚本都可以不加修改地在sh上运行。
3.需要注意的地方
CentOS和Red Hat Linux下默认的Shell均为bash。因此，在
写Shell脚本的时候，脚本的开头即使不加#!/bin/bash，
它也会交给bash解释。如果写脚本不希望使用系统默认
的Shell解释，那么就必须要指定解释器了。否则脚本文
件执行的结果可能就不是你想要的。建议读者养成好的
编程习惯，不管什么脚本最好都加上相应的开头解释器
语言标识，养成Shell编程规范。
4.Shell脚本的注释
#号后面表示注释，了解多行注释。

```

## 脚本的执行
```
1. bash script-name或sh script-name
这是当脚本文件本身没有可执行权限（即文件权限属性x
位为-号）时常使用的方法，或者脚本文件开头没有指定
解释器时需要使用的方法，这也是推荐的使
用方法。

2. path/script-name 或 ./script-name
指在当前路径下执行脚本（脚本要有执行权限），需要先将脚本文件的权限改为可执行（即文件权限属性加x位），具体方法为chmod +x script-name。然后通过脚本绝对路径或相对路径就可以直接执行脚本了。

3. source script-name 或 . script-name
4. sh<script-name或cat scripts-name|sh

```

## 脚本例子  父shell 子shell
```
[root@web03 ~]# cat test.sh
user=`whoami`
[root@web03 ~]# sh test.sh  #开启子shell执行
[root@web03 ~]# echo $user  #当前环境没有user变量

[root@web03 ~]# source ./test.sh  #在当前shell执行 和.*.sh类似
[root@web03 ~]# echo $user
root

```


1.开头加脚本解释器
2.附带作者及版权信息
3.脚本扩展名为*.sh
4.脚本存放在固定的目录下
5.脚本中不用中文
6.成对的符号一次书写完成
7.循环格式一次性输入完成



范例2_3：写一个包含命令、变量和流程控制语句的清除/var/log下messages日志文件的Shell脚本。
```
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
```
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
```
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

什么是变量？
就是用一个字符或字符串，表示一堆的内容，这个字符或字符串就叫变量
x=1  
x就是变量
=赋值，==表示相等
等号右边的内容，变量的内容。

变量的类型。
shell变量不是区分类型。
x=abc
用的时候区分变量类型。
declare -i n=1
弱类型语言

```
Linux declare 命令用于声明 shell 变量。
declare 为 shell 指令，
第一种语法中可用来声明变量并设置变量的属性([rix]即为变量的属性），
在第二种语法中可用来显示 shell 函数。若不加上任何参数，则会显示全部的 shell 变量与函数(与执行 set 指令的效果相同)。
+/- 　"-"可用来指定变量的属性，"+"则是取消变量所设的属性。
-f 　仅显示函数。
r 　将变量设置为只读。
x 　指定的变量会成为环境变量，可供shell以外的程序来使用。
i 　[设置值]可以是数值，字符串或运算式。

#declare -i ab //声明整数型变量
#ab=56 //改变变量内容
#echo $ab //显示变量内容56
```


shell分类：
环境变量（全局变量）
系统中默认就存在得，作用是解决系统的一些必要的问题。

显示环境变量：
1、echo $变量名字
2、env,set

定义环境变量：
PS1,PATH,HOME,UID系统固有的，默认就表示一定意义

3种方法
环境变量尽量大写,环境变量全局生效。
a.
export eric=1

b.
OLDGIRL=2
export OLDGIRL

c.declare
declare -x A=1

[root@web01 scripts]# tail -1 /etc/profile
export eric=1
[root@web01 scripts]# . /etc/profile
[root@web01 scripts]# echo $eric
1

环境变量取消
unset eric


环境变量的文件：
全局文件
	/etc/profile
	/etc/bashrc
用户环境变量文件
	~/.bashrc
	~/.bash_profile


~/.bash_profile  4
~/.bashrc 3 
/etc/bashrc 2
/etc/profile 1

登录shell
优先/etc/profile,然后加载~/.bash_profile ，
再次加载~/.bashrc，最后加载/etc/bashrc

## 变量的知识进阶

特殊位置变量：
```
$0  获取脚本的名字，如果脚本前面跟着路径的话，那就获取路径加上脚本名字。
$n  取执行脚本的第n个参数值,n>9时候要用${10}, n=0时候表示取脚本的路径和文件名,
$#  脚本后面所有参数的个数
$*  获取脚本的所有参数，“$1 $2 $3”
$@  获取脚本的所有参数，"$1" "$2" "$3"
```
```
[root@web01 scripts]# cat test.sh
#!/bin/bash
echo $0
[root@web01 scripts]# bash test.sh 
test.sh
[root@web01 scripts]# bash /server/scripts/test.sh 
/server/scripts/test.sh
```
企业应用;
一般在启动脚本的结尾会使用$0获取脚本的路径和名字给用户提示用。
/etc/init.d/crond

$1,$2----$n
$1表示脚本后的第一个参数
$2表示脚本后的第二个参数
....
超过$9,${10}  #n大于9 则用{}括起来
企业应用：
```
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
```
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
$*  获取脚本的所有参数，“$1 $2 $3”
$@  获取脚本的所有参数，"$1" "$2" "$3"

当需要接收脚本后面所有参数时，但是又不知道参数个数就用这两个变量。

区别:
```
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

Shell变量子串
```
表达式                           说明 
${parameter}                    变量值
${#parameter}                   变量长度(按字符)  **
${parameter:offset}             从变量offset位置到结尾
${parameter:offset:length}      从变量offset位置之后取length长度子串
${parameter#word}               变量中从开头最短匹配删除word
${parameter##word}              变量中从开头最长匹配删除word
${parameter%word}               变量中从结尾最短匹配删除word
${parameter%%word}              变量中从结尾最长匹配删除word
${parameter/pattern/string}     变量中string替换第一个匹配的pattern
${parameter//pattern/string}    变量中string替换所有匹配的pattern
```

[root@web01 scripts]# eric="I am eric"
[root@web01 scripts]# echo ${eric}
I am eric
[root@web01 scripts]# echo ${#eric} #返回变量内容的长度,按字符
11
[root@web01 scripts]# echo $eric|wc -L
11
[root@web01 scripts]# expr length "$eric"
11
[root@web01 scripts]# echo $eric|awk '{print length}'
11
[root@web01 scripts]# echo $eric|awk '{print length ($0)}'
11

练习题：
I am eric I teach linux
打印这些字符串中字符数小于3的单词。
涉及知识点：取字符串长度，for,if。


[root@web01 scripts]# echo ${eric:2} #从第2个字符开启取到结尾
am eric
[root@web01 scripts]# echo ${eric:2:2}
am
[root@web01 scripts]# echo ${eric:2:4}
am o


eric=abcABC123ABCabc
[root@web01 scripts]# echo ${eric}
abcABC123ABCabc
[root@m01 ~]# echo ${eric#a*c}
ABC123ABCabc
[root@m01 ~]# echo ${eric##a*c}

[root@web01 scripts]# echo ${eric%a*C}
abcABC123ABCabc
[root@web01 scripts]# echo ${eric%a*c}
abcABC123ABC
[root@web01 scripts]# echo ${eric%%a*c}

[root@m01 ~]# echo ${eric#a*c}
ABC123ABCabc
[root@m01 ~]# echo ${eric##a*c}

Shell特殊变量扩展知识
```
result=${parameter:-word}  #变量值空或未赋值,返回word字符串给变量result
result=${parameter:=word}  #变量值空或未赋值,设置parameter为word字符串并返回word字符串给变量result
result=${parameter:?word}  #变量值空或未赋值,word作为标准错误输出;无返回值
result=${parameter:+word}  #变量值空或未赋值,什么都不做.否则返回word字符串给result, parameter变量的值不变
```

[root@m01 ~]# result=${eric1:-word}
[root@m01 ~]# echo $result
word
[root@m01 ~]# result=${eric1:=word}
[root@m01 ~]# echo $eric1 $result
word word
[root@m01 ~]# result=${eric1:?word}  #无返回值
bash: eric1: word


[root@m01 ~]# eric2=2
[root@m01 ~]# echo $eric2
2
[root@m01 ~]# result=${eric2:+word}
[root@m01 ~]# echo $result
word
[root@m01 ~]# echo $eric2
2


## 变量的数值计算

算数运算符                 意义
+ -                       加法  减法
* / %                     乘法  除法  取余(取模)
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
[root@web01 scripts]# i=$((a+1))
[root@web01 scripts]# echo $i
2
[root@web01 scripts]# 
[root@web01 scripts]# echo $((a+3))
4
[root@web01 scripts]# echo $((1+3))
4
[root@web01 scripts]# echo $((2**3))
8
[root@web01 scripts]# echo $((1+2**3-5/3))
8
[root@web01 scripts]# echo $((1+2**3-5%3))
7

2、let 次推荐
[root@web01 scripts]# let i=$a+1
[root@web01 scripts]# echo $i
2

3、expr用于运算

4、$[]

=============
bc
awk
[root@web01 scripts]# echo 1+2|bc
3
[root@web01 scripts]# 
[root@web01 scripts]# echo 1.1+2|bc
3.1
[root@web01 scripts]# echo 1.1+2.3|bc
3.4
[root@web01 scripts]# echo 2.1 1.4|awk '{print $1-$2}'
0.7
[root@web01 scripts]# echo 2.1 1.4|awk '{print $1*$2}'
2.94


[root@web01 scripts]# expr 2 + 2
4
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
```
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
```
root@web01 scripts]# cat judge_kuozhan.sh 
#!/bin/bash
expr "$1" : ".*\.txt" &>/dev/null
if [ $? -eq 0 ]
then
    echo "$1 是文本"
else
    echo "$1 不是文本"
fi 
[root@web01 scripts]# sh judge_kuozhan.sh ckhedu.txt
ckhedu.txt 是文本
[root@web01 scripts]# sh judge_kuozhan.sh alex.log
alex.log 不是文本
[root@web01 scripts]# sh judge_kuozhan.sh peiqi.log
peiqi.log 不是文本
[root@web01 scripts]# sh judge_kuozhan.sh 老男孩老师.txt
老男孩老师.txt 是文本
```
```
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
1、定义法
a=1

2、传参法
```
[root@web01 scripts]# cat test7.sh 
#!/bin/bash
a=$1
b=$2
echo "a-b=$(($a-$b))"
echo "a+b=$(($a+$b))"
echo "a*b=$(($a*$b))"
echo "a/b=$(($a/$b))"
echo "a**b=$(($a**$b))"
echo "a%b=$(($a%$b))"
```
3、read读入，读取用户输入。
-p 提示
-t 等待用户输入的时间
```
read -t 30 -p "请输入一个数字:"
[root@web01 scripts]# read -t 30 -p "请输入一个数字:" a
请输入一个数字:11
[root@web01 scripts]# echo $a
11
[root@web01 scripts]# a=11
[root@web01 scripts]# echo $a
11
```
read读入有什么作用
和用户交互。
```
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
[root@web01 scripts]# cat select1.sh
```
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
```

## 条件表达式

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


为什么需要文件测试表达式？
操作一个对象，就要看对象条件是否满足，否则不要操作。
1、常见功能
2、实践
3、企业应用：启动脚本中的应用。

文件测试表达式：
操作符号      记忆单词
[ -d ]        d directory         文件存在且为目录 真             
[ -f ]        f file              文件存在且为普通文件 真
[ -e ]        e exist             文件或目录存在  真
[ -r ]        r read              文件存在且可读  真
[ -s ]        s size              文件存在且文件大小不为0  真
[ -w ]        w write             文件存在且可写  真
[ -x ]        x executable        文件存在且可执行  真
[ -L ]        L link              文件存在且为链接文件  真
[ f1 -nt f2 ] nt newer than       f1比f2文件新  真 根据文件修改时间算  
[ f1 -or f2 ] or older than       f1比f2文件旧 真  根据文件修改时间算



字符串测试表达式
[ -n "字符串" ]    字符串长度[不]为0，表达式为真。 not zero。
[ -z "字符串" ]    字符串长度为0，表达式为真。 zero。
[ "字符串1" == "字符串2" ]  两个字符串相同则为真。可用 =代替
[ "字符串1" != "字符串2" ] 两个字符串不相同则为真。不可用 !== 代替 


注意：
1、字符串就用双引号
2、等号可以用一个或者两个。
3、=号两端必须要有空格。
实践：
[root@web01 ~]# [ -n "ckhedu" ] && echo 1 || echo 0
1
[root@web01 ~]# [ -z "ckhedu" ] && echo 1 || echo 0
0
[root@web01 ~]# char="ckhedu"
[root@web01 ~]# [ -z "$char" ] && echo 1 || echo 0
0
[root@web01 ~]# unset char
[root@web01 ~]# [ -z "$char" ] && echo 1 || echo 0
1
[root@web01 ~]# [ "dd" == "dd" ] && echo 1 || echo 0
1
[root@web01 ~]# [ "dd" == "ff" ] && echo 1 || echo 0
0
[root@web01 ~]# [ "dd" = "ff" ] && echo 1 || echo 0
0
[root@web01 ~]# [ "dd" != "ff" ] && echo 1 || echo 0
1
[root@web01 ~]# [ "dd" != "dd" ] && echo 1 || echo 0
0


企业应用：
[root@db03 scripts]# cat yunsuan1.sh
```
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

整数测试表达式：
[]内的比较符号          在(())和[[]]的比较符号      说明 
[ 整数1 -eq 整数2 ]    (( 整数1 ==或= 整数2 ))     相等 equal
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
	
[root@web01 scripts]# cat com1.sh 
```
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
```
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

逻辑测试表达式
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
[root@db03 scripts]# [ -f /etc/hosts ] && echo 1 || echo 0
1
[root@db03 scripts]# [ ! -f /etc/hosts ] && echo 1 || echo 0
0


小题：如果/tmp/ckhedu.sh是普通文件，并且可执行，就执行改脚本。
file="/tmp/ckhedu.sh"
if [ -f $file ] && [ -x $file ]
then
    bash $file
fi


1. 单分支结构
第一种语法：
if  <条件表达式>
    then
    指令
fi
第二种语法：
if <条件表达式>; then
    指令
fi


如果 <你有房>
  那么
    我就嫁给你
果如


if条件句的双分支结构语法为：
if <条件表达式>
  then
    指令集1
else
    指令集2
fi

如果 <你有房>
  那么
    我就嫁给你
否则
    我再考虑下
果如

多分支：
if  <条件表达式1>
  then
    指令1...
elif <条件表达式2>
  then
    指令2...
elif <条件表达式3>
  then
    指令3... 
else
    指令4...
fi


范例7_2：开发Shell脚本判断系统剩余内存的大小，如果低于100MB就邮件报警给系统管理员，
并且将脚本加入系统定时任务，即每3分钟执行一次检查。

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

## Shell函数的语法

function 函数名(){
    指令集...
    return n
}
简写1:
function 函数名{
    指令集..
    return n
}
简写2: 推荐
函数名(){
    指令集...
    return n
}

简单函数执行:
```
ckhedu() {
    echo "I am ckhedu."
}
function oldgirl {
    echo "I am oldgirl."
}
test() {
    echo "Hello world."
}
ckhedu
oldgirl
```
带参数函数
```
ckhedu() {
    echo "I am $1."
}
ckhedu ckhedu
```
将函数传参转为脚本传参
```
ckhedu() {
    echo "I am $1."
}
ckhedu $1
```
将函数体和函数执行分离成不同的文件。

企业案例：通过脚本传参的方式，检查Web 网站URL是否正常。
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

不用函数的实现写法
```
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
```
[root@ckhedu ~]# cat checkurl.sh 
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
```

[root@ckhedu scripts]# cat 8_5_1.sh  
``` 
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

case语法:
case "变量" in 
    值1)
        指令1...
        ;;
    值2)
        指令2...
        ;;
    值3)
        指令3...
;;
    *)
        指令4...
esac

形象语法:
case “找老公条件”  in 
    家里有房子)
        嫁给你... 
        ;;
    家庭有背景)
        嫁给你... 
        ;;
    很努力吃苦)
        先谈谈男女朋友... 
          ;;
    *)
        good bye！！...
esac

范例9_2：执行shell脚本，打印一个如下的水果菜单：
1.apple
2.pear
3.banana
4.cherry
当用户输入对应的数字选择水果的时候，告诉他选择的水果是什么，并给水果单词加上一种颜色（随意），要求用case语句实现。




case条件句的使用总结
(1)case语句和if条件句的适用性·
case语句比较适合变量值较少且为固定的数字或字符串集合的情况（非不确定的内容，例
如范围)，如果变量的值是已知固定的start/stop/restart等元素，那么采用case语句实现就
比较适合。
(2)case语句和if条件句的常见应用场景。
case主要是写服务的启动脚本，一般情况下，传参不同且具有少量的字符串，其适用
范围较窄。
if就是取值判断、比较，应用比case更广。几乎所有的case语句都可以用if条件语句实现。
(3)case语句的特点及优势.
case语句就相当于多分支的if/elif/else语句，但是case语句的优势是更规范、易读。


范例9_3：给内容加不同的颜色。
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

范例9_6： 给输出的字符串加不同的背景颜色。

echo -e "\033[40;37m 黑底白字ckhedu\033[0m"   #<==40m表示黑色背景。
echo -e "\033[41;37m 红底白字ckhedu\033[0m"   #<==41m表示红色背景。
echo -e "\033[42;37m 绿底白字ckhedu\033[0m"   #<==42m表示绿色背景。
echo -e "\033[43;37m 棕底白字ckhedu\033[0m"   #<==43m表示棕色背景（brown），和黄色背景相近。
echo -e "\033[44;37m 蓝底白字ckhedu\033[0m"   #<==44m表示蓝色背景。
echo -e "\033[45;37m 洋红底白字ckhedu\033[0m"  #<==45m表示洋红色背景（magenta），和紫色背景相近。
echo -e "\033[46;37m蓝绿底白字ckhedu\033[0m"   #<==46m表示蓝绿色背景（cyan），和浅蓝色背景相近。
echo -e "\033[47;30m 白底黑字ckhedu\033[0m"    #<==47m表示白色背景。

范例9_10：利用case语句开发Rsync服务启动停止脚本，本例采用case语句以及新的思路来实现。

分析：
启动：
rsync --daemon
停止：
pkill rsync
killall rsync
kill 进程号

/etc/init.d/rsyncd {start|stop|restart}
case


## While循环语句

While循环语法
while <条件表达式>
do
    指令...
done

While循环中文形象语法
当<手机话费是否充足>时
开始做
       发短信
已做完

范例10_1：每隔2秒输出一次系统负载（负载是系统性能的基础重要指标）情况。
```
[root@ckhedu scripts]# cat 10_1_1.sh
#!/bin/sh
while true 
do
    uptime >>/tmp/uptime.log
    sleep 2
done
```
用法	            说明
sh while1.sh &	    把脚本while1.sh放到后台执行（后台运行脚本时常用）*
nohup while1.sh &	使用nohup把脚本while1.sh放到后台执行
ctl+c	            停止执行当前脚本或任务
ctl+z	            暂停执行当前脚本或任务
bg	                把当前脚本或任务放到后台执行，bg可以理解为background
fg	                把当前脚本或任务拿到前台执行，如果有多个任务，可以使用fg加任务编号调出对应脚本任务，如fg 2，调出第二个脚本任务，fg可以理解为frontground
jobs 	            查看当前执行的脚本或任务
kill	            关闭执行的脚本任务，即以“kill %任务编号”的形式关闭脚本，这个任务编号，可以通过jobs获得

后台运行 &、nohup、screen（运维人员）

kill、killall、pkill：杀掉进程。
ps：查看进程。
pstree：显示进程状态树。
top：显示进程。
renice：改变优先权。 
nohup：用户退出系统之后继续工作。
pgrep：查找匹配条件的进程。
strace：跟踪一个进程的系统调用情况。
ltrace：跟踪进程调用库函数的情况。

范例10_2：请使用while循环对下面的脚本进行修改，使得当执行脚本时，每次执行完脚本以后不退出脚本了，而是继续提示用户输入。
```
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
[root@web01 10]# cat 10-02.sh
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
```
while read line
do
    cmd
done<FILE

```

方式2：使用cat读取文件内容，然后通过管道进入while循环处理。
```
cat FILE_PATH|while read line
do
    cmd
done
```
方式3：采用exec读取文件后，然后进入while循环处理。
```
exec <FILE
sum=0
while read line
do
    cmd
done

```

While循环结构及相关语句综合实践小结
wile循环的特长是执行守护进程，以及实现我们希望循环不退出持续执行的应用，
擅长用于频率小于1分钟循环处理，其他的whi1e循环几乎都可以被后面即将要讲到的
for循环以及定时任务crond功能替代。
case语句可以用if语句替换，一般在系统启动脚本传入少量固定规则字符串，多用
case语句，其他普通判断多用if。
一句话，if语句、for语句最常用，其次while(守护进程)，case(服务启动脚本)。
(2)Shel1脚本中各个语句的使用场景。
条件表达式，用于简短的条件判断及输出（文件是否存在，字符串是否为空等）
f取值判断，多用于不同值数量较少的情况。
for正常的循环应用处理，最常用！
while多用于守护进程、无限循环（要加sleep,usleep控制频率）应用。
case多用于服务启动脚本、打印菜单可用select语句，不过很少用，都用cat
的here文档方法替代。
函数用途主要是编码逻辑清晰，减少重复语句开发。·


## for循环语句

for循环语法
1）普通语法
for 变量名 in 变量取值列表
do
    指令...
done
2）C语言型for循环语法
for((exp1;exp2;exp3))
do
    指令...
done

for循环中文形象语法
for 男人 in 世界上所有男人
do
    if [ 有房 ] && [有车] && [存款] && [会做家务] && [帅气] && [体贴] && [逛街买西];
    then
        echo "女孩喜欢这个男人"
    else
        rm -f $男人(不符合条件的)
    fi
done

范例1：用for循环竖向打印1、2、3、4、5共5个数字。
范例2：通过开发脚本实现仅设置sshd rsyslog crond network sysstat服务开机自启动。
范例3：计算从1加到100之和。
范例4：在Linux下批量修改文件名，将文件名中的“_finished”去掉。
准备测试数据，如下。
mkdir /ckhedu -p
cd /ckhedu
touch stu_102999_1_finished.jpg stu_102999_2_finished.jpg stu_102999_3_finished.jpg 
touch stu_102999_4_finished.jpg stu_102999_5_finished.jpg
[root@ckhedu ckhedu]# ls -l
总用量 0
-rw-r--r-- 1 root root 0 9月   5 10:43 stu_102999_1_finished.jpg
-rw-r--r-- 1 root root 0 9月   5 10:43 stu_102999_2_finished.jpg
-rw-r--r-- 1 root root 0 9月   5 10:43 stu_102999_3_finished.jpg
-rw-r--r-- 1 root root 0 9月   5 10:43 stu_102999_4_finished.jpg
-rw-r--r-- 1 root root 0 9月   5 10:43 stu_102999_5_finished.jpg

```
ls *.jpg|awk -F "_finished" '{print "mv",$0,$1$2}'|bash

rename "_finished" "" *.jpg

for file in `ls ./*.jpg`
do
    mv $file `echo ${file/_finished/}`
done
```

## 循环和条件句等的控制
break（循环控制）、
continue（循环控制）、
exit（退出脚本）、
return（退出函数）。

break、continue、exit、return的区别和对比
break、continue在条件语句及循环语句（for、while、if等）中用于控制程序的走向
而exit则用于终止所有语句并退出当前脚本，除此之外，exit还可以返回上一次程序或命令的执行状态值给当前Shell
return类似exit，只不过return仅用于在函数内部返回函数执行的状态值。

命令	        说明
break n	        如果省略n表示跳出整个循环，n 表示跳出循环的层数
continue n	    如果省略n表示跳过本次循环，忽略本次循环的剩余代码，进入循环的下一次循环。n 表示退到第n层继续循环
exit n	        退出当前shell程序，n为上一次程序执行的状态返回值。n也可以省略，再下一个shell里可通过$?接收exit n的n值
return n	    用于在函数里，作为函数的返回值，用于判断函数执行是否正确。


## shell数组
什么是Shell数组
简单地说，Shell的数组就是把有限个元素（变量或字符内容）用一个名字命名，
然后用编号对它们进行区分的元素集合。这个名字就称为数组名，用于区分不
同内容的编号就称为数组下标。组成数组的各个元素（变量）称为数组的元素，
有时也称为下标变量。

数组的本质还是变量，是特殊的变量形式
array=(1 2 3 4 5)

Shell数组的定义
方法1：推荐
array=(one two three four)
方法2：
array=([0]=one [1]=two [2]=three [3]=four)
方法3：
[root@web01 ~]# array[0]=one
[root@web01 ~]# array[1]=two
[root@web01 ~]# array[2]=three
[root@web01 ~]# array[3]=four
[root@web01 ~]# echo ${array[@]}
one two three four
方法4：命令的结果放到数组里，推荐。
array=(`ls /server/scripts`)
array=($(命令))

操作数组元素
读取数组内容:
[root@web01 ~]# array=( 1 2 3 4 5)
[root@web01 ~]# echo ${array[0]}
1
[root@web01 ~]# echo ${array[1]}
2
[root@web01 ~]# echo ${array[2]}
3
[root@web01 ~]# echo ${array[3]}
4
[root@web01 ~]# echo ${array[4]}
5
[root@web01 ~]# echo ${array[5]}

[root@web01 ~]# echo ${array[*]}
1 2 3 4 5
[root@web01 ~]# echo ${array[@]}
1 2 3 4 5
[root@web01 ~]# echo ${#array[@]} #元素长度
5
[root@web01 ~]# echo ${#array[*]}
5

给数组增加内容：
[root@web01 ~]# array[5]=ckhedu
[root@web01 ~]# echo ${#array[*]}
6
[root@web01 ~]# echo ${array[*]}
1 2 3 4 5 ckhedu

删除数组元素:
[root@web01 ~]# unset array[1]
[root@web01 ~]# echo ${array[*]}
1 3 4 ckhedu
[root@web01 ~]# unset array[0]
[root@web01 ~]# echo ${array[*]}
3 4 ckhedu

使用for循环打印数组元素
```
array=(1 2 3 4 5)
for n in ${array[*]}
do
    echo $n
done
echo \#=====================
#i为数组下标
for ((i=0;i<${#array[*]};i++))
do
    echo ${array[i]}
done 
```

数据内容的截取和替换
[root@ckhedu ~]# array=(1 2 3 4 5)
[root@ckhedu ~]# echo ${array[@]:1:3}          #<==从下标为1的元素开始截取，共取3个数组元素。
2 3 4
[root@ckhedu data]# array=({a..z})             #<==将变量的结果赋值给数组变量。
[root@ckhedu data]# echo ${array[@]}
a b c d e f g h i j k l m n o p q r s t u v w x y z
[root@ckhedu data]# echo ${array[@]:1:3}       #<==从下标为1的元素开始截取，共取3个数组元素。
b c d
[root@ckhedu data]# echo ${array[@]:0:2}       #<==从下标为0的元素开始截取，共取2个数组元素。
a b


[root@ckhedu data]# array=(1 2 3 1 1)   
[root@ckhedu data]# echo ${array[@]/1/b}    #<==把数组中的1替换成b，原数组未被修改,和sed很像。
b 2 3 b b
提示：调用方法是：${数组名[@或*]/查找字符/替换字符} 该操作不会改变原先数组内容，
如果需要修改，可以看上面例子，重新定义数组。

数组元素部分内容的删除如下：
[root@ckhedu data]# array=(one two three four five)
[root@ckhedu data]# echo ${array[@]}               
one two three four five
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


## Shell数组脚本开发实践
范例13_1：使用循环批量输出数组的元素。
方法1：通过C语言型的for循环语句打印数组元素。
[root@ckhedu scripts]# cat 13_1_1.sh
```
#!/bin/sh
array=(1 2 3 4 5)
for((i=0;i<${#array[*]};i++))  #<==从数组的第一个小标0开始，循环数组的所有下标。
do
    echo ${array[i]}            #<==打印数组元素。
done
```
方法2：通过普通for循环语句打印数组元素。
```
[root@ckhedu scripts]# cat 13_1_2.sh
#!/bin/sh
array=(1 2 3 4 5)
for n in ${array[*]}  #<==${array[*]}表示输出数组所有元素，相当于列表数组元素。
do
    echo $n           #<==这里就不是直接去数组里取元素了，而是变量n的值。
done
```
方法3：使用while循环语句打印数组元素。
```
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
```
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
准备数据：
[root@ckhedu scripts]# mkdir -p /array/
[root@ckhedu scripts]# touch /array/{1..3}.txt
[root@ckhedu scripts]# ls /array/
1.txt  2.txt  3.txt

```
[root@ckhedu scripts]# cat 13_3_1.sh 
#!/bin/bash
dir=($(ls /array))              #<==把ls /array命令结果放数组里。
for ((i=0; i<${#dir[*]}; i++))  #<==${#dir[*]}为数组的长度。
do
    echo "This is NO.$i,filename is ${dir[$i]}"
done
```

## Shell数组的重要命令
```
1定义命令
静态数组:
array=(1 2 3)
动态数组:
array=($(ls))或array=(`ls`)
给数组赋值:
array[3]=4
2打印命令
打印所有元素:
${array[@]}或${array[*]}
打印数组长度:
${#array[@]}或${#array[*]}
打印单个元素:
${array[i]}             #<==i是数组下标。
```

3循环打印的常用基本循环

```bash
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

## Shell数组相关企业面试题及高级实战案例

范例13_4：利用bash for循环打印下面这句话中字母数不大于6的单词（某企业面试真题）。
I am ckhedu teacher welcome to ckhedu training class
解答思路：
1）先把所有的单词放到数组里，然后依次进行判断。命令如下：
array=(I am ckhedu teacher welcome to ckhedu training class)
2）对变量内容计算长度，这在前文已经讲解过了。常见方法有4种：
[root@ckhedu scripts]# char=ckhedu
[root@ckhedu scripts]# echo $char|wc -L
6
[root@ckhedu scripts]# echo ${#char}
6
[root@ckhedu scripts]# expr length $char
6
[root@ckhedu scripts]# echo $char|awk '{print length}'
6

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

范例13_5：批量检查多个网站地址是否正常 
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

```
提示：实际使用时，一些基础的函数脚本（例如：加颜色的函数）是放在函数文件里的（例如：放在/etc/init.d/functions里，与执行的脚本内容部分分离，看起来更清爽，大型的语言程序都是这样开发的），另外，特别注意wget命令后要接重试次数--tries参数，否则检查时会卡住。


范例13_6：开发一个守护进程脚本，每30秒监控MySQL主从复制是否异常（包括不同步以及延迟），如果异常，则发送短信并发送邮件给管理员存档（此为生产实战案例）。
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

解题思路：
1）判断主从复制是否异常，主要就是检测如下参数对应的值是否和如下一致。
```
       Slave_IO_Running: Yes  #<==IO线程状态必须为Yes。
            Slave_SQL_Running: Yes  #<==SQL线程状态必须为Yes。
       Seconds_Behind_Master: 0     #<==和主库比同步延迟的秒数，这个参数很重要。
```
2）读取状态数据或状态文件，然后取出对应值，和正确时的值进行比对，如果不符合就表示故障了，即调用报警脚本报警。
3）为了更专业，还可以在当主从不同步时，查看相应错误号，判断对应错误号以进行自动恢复主从复制故障（这些错误号也可以通过配置文件里配置参数实现自动忽略故障）。

```bash
[root@ckhedu scripts]# cat slave.log
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
```

然后开发脚本，开发脚本有多种方法，下面分别给出。
方法1：
```bash
[root@ckhedu scripts]# awk -F ': ' '/_Running|_Behind/{print $NF}' slave.log
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

```
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

```
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
function PAGER(){#<==定义手机函数，在范例11_13讲过此函数。
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


## shell实战企业面试题

面试题 1：批量生成随机字符文件名案例
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
老男孩给出生成随机数的 7 种方法：
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

Linux tr 命令用于转换或删除文件中的字符。
tr 指令从标准输入设备读取数据，经过字符串转译后，将结果输出到标准输出设备。
cat testfile |tr a-z A-Z  #全部小写字母转换成大写字母

Linux cut命令用于显示每行从开头算起 num1 到 num2 的文字。
cut  [-bn] [file]
cut [-c] [file]
cut [-df] [file]
-b ：以字节为单位进行分割。这些字节位置将忽略多字节字符边界，除非也指定了 -n 标志。
-c ：以字符为单位进行分割。
-d ：自定义分隔符，默认为制表符。
-f ：与-d一起使用，指定显示哪个区域。
-n ：取消分割多字节字符。仅和 -b 标志一起使用。如果字符的最后一个字节落在由 -b 标志的 List 参数指示的
范围之内，该字符将被写出；否则，该字符将被排除



3、for 循环创建
```bash
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

面试题 2：批量改名特殊案例

将以上面试题 1 中结果文件名中的 eric 字符串全部改成 oldgirl(最好用 for 循环实
现),并且将扩展名 html 全部改成大写。
解答：
思路分析：
1、 要改所有，先缩小改一个。
拼接的目标：mv arqordoamn_eric.html arqordoamn_oldgirl.HTML
```
[root@web01 eric]# file=arqordoamn_eric.html
[root@web01 eric]# echo $file
arqordoamn_eric.html
[root@web01 eric]# echo ${file/eric.html/oldgirl.HTML}
arqordoamn_oldgirl.HTML
[root@web01 eric]# mv $file `echo ${file/eric.html/oldgirl.HTML}`
```
2、 如果修改所有那就用 for 循环
方法 1：for 循环
方法 2：拼接法：
```
[root@web01 eric]# ls *.HTML|awk -F "oldgirl.HTML" '{print "mv",$0,$1"eric.html"}'|bash
[root@web01 eric]# ls
madoqdrpqo_eric.html rnpeusurmf_eric.html vavftumomu_eric.html
arqordoamn_eric.html maoopfqrbv_eric.html smnbvqdtfo_eric.html
bqfmsrvabs_eric.html perpcvaaor_eric.html sqnvmptfuu_eric.html
ccrcpdovam_eric.html rmdqptfetm_eric.html
```
方法 3：
```
[root@web01 eric]# rename "eric.html" "oldgirl.HTML" *.html
[root@web01 eric]# ls
03_02.sh madoqdrpqo_oldgirl.HTML rnpeusurmf_oldgirl.HTML vavftumomu_oldgirl.HTML
arqordoamn_oldgirl.HTML maoopfqrbv_oldgirl.HTML smnbvqdtfo_oldgirl.HTML
bqfmsrvabs_oldgirl.HTML perpcvaaor_oldgirl.HTML sqnvmptfuu_oldgirl.HTML
ccrcpdovam_oldgirl.HTML rmdqptfetm_oldgirl.HTML test.sh
```

for循环
```bash
#!/bin/bash
path=/eric
for file in `ls ${path}`
do
  cd $path
  mv $file `echo ${file/eric.html/oldgirl.HTML}`
done
```

3：批量创建特殊要求用户案例
批量创建 10 个系统帐号 eric01-eric10 并设置密码（密码为随机数，要求字符和数等
混合）。
不用 for 循环的实现思路参考:
```bash
方法1：
echo stu{01..10}|tr " " "\n"|sed -r 's#(.*)#useradd \1 ; pass=$((RANDOM+10000000)); echo "$pass"|passwd --stdin \1; echo -e "\1 \t `echo "$pass"`">>/tmp/eric.log#g'|bash
 
上述命令实际就是再拼N条下面的命令的组合，举一条命令stu01用户的过程拆解如下：
useradd stu01 ;
pass=$((RANDOM+10000000));
echo "$pass"|passwd --stdin stu01;
echo -e "stu01        `echo "$pass"`">>/tmp/eric.log
特别说明：如果用shell循环结构会更简单，

方法2：
echo stu{11..12}|xargs -n1 useradd ;echo stu{11..12}:`cat /dev/urandom|tr -dc 0-9|fold -w8|head -1`|xargs -n1|tee -a pass.txt|chpasswd

说明:
tr -dc 0-9 #删除不是0-9的字符 
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
```bash
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

面试题 4：扫描网络内存活主机案例

写一个 Shell 脚本，判断 172.16.1.0/24 网络里，当前在线的 IP 有哪些？

解答：
1） 如何判断主机存活
ping 172.16.1.7
[root@web01 eric_shell_14]# ping -c 2 -i 1 -w 3 172.16.1.7
PING 172.16.1.7 (172.16.1.7) 56(84) bytes of data.
64 bytes from 172.16.1.7: icmp_seq=1 ttl=64 time=0.020 ms
64 bytes from 172.16.1.7: icmp_seq=2 ttl=64 time=0.022 ms
--- 172.16.1.7 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.020/0.021/0.022/0.001 ms

nmap -sP 172.16.1.0/24

2） 最终实现答案
方法 1：
[root@web01 eric_shell_14]# nmap -sP 172.16.1.0/24|awk '/Nmap scan report for/{print $NF}'
172.16.1.1
172.16.1.7
172.16.1.8
172.16.1.41
172.16.1.254

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
```
面试题 5：解决 DOS 攻击生产案例

写一个 Shell 脚本解决 DOS 攻击生产案例。
请根据 web 日志或者或者网络连接数，监控当某个 IP 并发连接数或者短时内 PV 达到 100
（读者根据实际情况设定），即调用防火墙命令封掉对应的IP。防火墙命令为：iptables -I INPUT -s IP 地址 -j DROP。
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
```bash
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

面试题 6：MySQL 数据库分库备份
请实现对 MySQL 数据库进行分库备份，用脚本实现。
解答：
常规方法：
    mysqldump -B eric oldgirl test|gzip >bak.sql.gz
分库备份：
    mysqldump -B eric |gzip >bak.sql.gz
    mysqldump -B oldgirl |gzip >bak.sql.gz
    mysqldump -B test|gzip >bak.sql.gz

参考答案：
```bash
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
```

Shell 面试题 7：MySQL 数据库分库分表备份

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
```bash
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

面试题 8：筛选符合长度的单词案例

利用 bash for 循环打印下面这句话中字母数不大于 6 的单词(某企业面试真题)。
I am eric teacher welcome to eric training class
解答：
数组部分有答案讲解，这里不给答案了。
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
```
面试题 9：比较整数大小经典案例

综合实战案例：开发 shell 脚本分别实现以脚本传参以及 read 读入的方式比较 2 个整数大
小。
用条件表达式（禁止 if）进行判断并以屏幕输出的方式提醒用户比较结果。注意：一共
是开发 2 个脚本。当用脚本传参以及 read 读入的方式需要对变量是否为数字、并且传参个
数不对给予提示。
解答：
见第二模块 Shell 考试题答案
```bash
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
面试题 10：菜单自动化软件部署经典案例

综合实例：打印选择菜单，按照选择一键安装不同的 Web 服务。
示例菜单：
```bash
[root@eric scripts]# sh menu.sh
1.[install lamp]
2.[install lnmp]
3.[exit]
pls input the num you want:
```
要求：
1、当用户输入 1 时，输出“start installing lamp.提示”然后执行/server/scripts/lamp.sh，脚本
内容输出"lamp is installed"后退出脚本，工作中就是正式 lamp 一键安装脚本；
2、当用户输入 2 时，输出“start installing lnmp.提示” 然后执行/server/scripts/lnmp.sh 输出
"lnmp is installed"后退出脚本，工作中就是正式 lnmp 一键安装脚本；
3、当输入 3 时，退出当前菜单及脚本；
4、当输入任何其它字符，给出提示“Input error”后退出脚本；
5、要对执行的脚本进行相关的条件判断，例如：脚本文件是否存在，是否可执行等判断，
尽量用上前面讲解的知识点。
解答：
见第二模块 Shell 考试题答案
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

面试题 11：破解 RANDOM 随机数案例

已知下面的字符串是通过 RANDOM 随机数变量 md5sum 后，再截取一部分连续字符串的结
果，请破解这些字符串对应的使用 md5sum 处理前的 RANDOM 对应的数字？
21029299
00205d1c
a3da1677
1f6d12dd
890684b

参考答案
```bash
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
        echo -e "$n\t`echo $n|md5sum`" >>/tmp/md5sum1.log &
    done
}
FunJudge(){
    char="`echo ${array[*]}|tr " " "|"`"
    egrep "$char" /tmp/md5sum1.log
}
main(){
    Funmd5
    FunJudge
}
main
```

面试题 12：批量检查多个网站地址是否正常
要求：
1、使用 shell 数组方法实现，检测策略尽量模拟用户访问。
2、每 10 秒钟做一次所有的检测，无法访问的输出报警。
3、待检测的地址如下
http://blog.ericedu.com
http://blog.etiantian.org
http://eric.blog.51cto.com
http://10.0.0.7

参考答案
```bash
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

面试题 13：单词及字母去重排序案例

用 shell 处理以下内容
1、按单词出现频率降序排序！
2、按字母出现频率降序排序！
the squid project provides a number of resources to assist users design,implement and support squid installations. Please browse the documentation and support sections for more infomation,by eric training.

```bash
1、按单词出现频率降序排序！
2、按字母出现频率降序排序！
the squid project provides a number of resources to assist users design,implement and support squid installations. Please browse the documentation and support sections for more infomation

解答：
# cat eric.txt 
the squid project provides a number of resources to assist users design,implement and support squid installations. Please browse the documentation and support sections for more infomation

按单词排序解答：
法1:
tr ",." " " <eric.log|xargs -n 1|sort|uniq -c|sort -rn|head

法2：
tr ",." " " <eric.log|xargs -n 1|awk '{S[$1]++}END{for(key in S)print S[key],key}'|sort -rn|head2 the

法3：
awk -F "[,. ]+" '{for(i=1;i<=NF;i++)S[$i]++}END{for(key in S)print S[key],key}' eric.log |sort -rn|head

按字母频率排序
法1
tr "{ |,|.}" "\n"<eric.txt|awk -F ""  '{for(i=1;i<=NF;i++)array[$i]++}END{for(key in array)print array[key],key|"sort -nr"}'

tr "[ ,.]" "\n"<eric.txt|awk '{for(i=1; i<=length($0); i++) ++S[substr($0,i,1)]} END {for(a in S) print S[a], a|"sort -rn"}'

echo "the squid project provides a number of resources toassist users design,implement and support squid installations. Please browsethe documentation and support sections for more infomation"|sed 's# ##g'|sed -r 's#(.)#\1\n#g'|sort|uniq -c|sort -rn -k1

echo "the squid project provides a number of resources toassist users design,implement and support squid installations. Please browsethe documentation and support sections for more infomation"|sed 's# ##g'|awk -F "" '{for(n=1;n<=NF;n++) print $n}'|sort|uniq -c|sort -k1 -nr


```

面试题 14：企业批量管理和分发文件案例实战

3 台机器 A、B、C，实现从 A 到 B 和 C 免秘钥登录，然后开发脚本实现，批量管理远程主机
（执行任意命令），批量分发本地任意文件到远端任意路径下。

分发脚本：
```bash
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

















