第五阶段：Shell编程企业级实战


为什么需要学习Shell编程
    shell时linux底层核心
    linux运维工作常用工具
    自动化运维必备基础工具
    
学好shell编程所需linux基础
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

















