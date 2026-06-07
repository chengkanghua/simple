
DBMS（database management system）

# MySQL二进制安装：
```bash
#安装所需要的依赖包
yum -y install cmake bison-devel ncurses-devel libaio-devel gcc gcc-c++ automake autoconf
#卸载冲突 的mariadb
rpm -qa |grep mariadb  
yum remove mariadb*

#1.创建安装目录：
mkdir /application

#2.下载二进制安装包：
wget https://downloads.mysql.com/archives/get/p/23/file/mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz

#3.解压二进制包：
tar zxvf mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz

#4.移动解压目录
mv mysql-5.6.40-linux-glibc2.12-x86_64 /application/mysql-5.6.40

#5.做MySQL软连接
ln -s /application/mysql-5.6.40/ /application/mysql

#6.创建MySQL用户
useradd mysql -s /sbin/nologin -M

#useradd mysql -r -g mysql -s /sbin/nologin -M
#-r 　建立系统帐号。
#-g<群组> 　指定用户所属的群组。
#-s<shell>　 　指定用户登入后所使用的shell。
# -M 　不要自动建立用户的登入目录。

#7.进入配置文件及启动脚本目录
cd /application/mysql-5.6.40/support-files

#8.拷贝配置文件到/etc/my.cnf
cp my-default.cnf /etc/my.cnf

#9.拷贝启动脚本
cp mysql.server /etc/init.d/mysqld

10.初始化MySQL
cd /application/mysql-5.6.40/scripts
./mysql_install_db --user=mysql --basedir=/application/mysql --datadir=/application/mysql/data
#--user 		指定mysql用户
#--basedir 	指定mysql安装目录
#--datadir	 指定mysql数据目录
#授权 
chown -R mysql.mysql /application/mysql-5.6.40

#11.修改MySQL启动脚本及启动程序
sed -i 's#/usr/local#/application#g' /etc/init.d/mysqld /application/mysql/bin/mysqld_safe 

#12.启动MySQL
/etc/init.d/mysqld start
/etc/init.d/mysqld stop
#13.添加环境变量
echo 'export PATH="/application/mysql/bin:$PATH"' > /etc/profile.d/mysql.sh

#14.加载环境变量
source /etc/profile

#15.添加systemd启动
cat > /etc/systemd/system/mysqld.service <<EOF
[Unit]
Description=MySQL Server
Documentation=man:mysqld(8)
Documentation=https://dev.mysql.com/doc/refman/en/using-systemd.html
After=network.target
After=syslog.target
[Install]
WantedBy=multi-user.target
[Service]
User=mysql
Group=mysql
ExecStart=/application/mysql/bin/mysqld --defaults-file=/etc/my.cnf
LimitNOFILE = 5000
EOF

cat > /etc/my.cnf <<EOF
[mysqld]
basedir=/application/mysql
datadir=/application/mysql/data
port=3306
socket=/tmp/mysql.sock
[mysql]
socket=/tmp/mysql.sock
prompt=3306 [\\d]>
EOF
#加载配置
systemctl daemon-reload
systemctl start mysqld
systemctl status mysqld

#MySQL查看报错：
#tail -100 /application/mysql/data/db01.err

#连接MySQL：
# mysql

#查看库：
#mysql> show databases;

# 首次初始化密码
#/usr/local/mysql/bin/mysqladmin -u root password 'Ckh123.com'
/application/mysql/bin/mysqladmin -u root password 'Ckh123.com'
#mysql -u root -pCkh123.com
mysql -uroot -pCkh123.com -S /tmp/mysql.sock
#有密码第二次再改
mysqladmin -u root -pCkh123.com password '123'

```

# mysql体系结构
## 客户端与服务端模型

- mysql是一个典型的C/S服务结构
   -  mysql自带的客户端程序（/application/mysql/bin）
    ■     mysql
     ■     mysqladmin
     ■     mysqldump
	
- mysqld一个二进制程序，后台的守护进程
  ○   单进程
  ○   多线程	

- 应用程序连接mysql方式
	- tcp/ip   mysql -uroot -pxxx -h10.0.0.5
	
	- 套接字   mysql -uroot -S /tmp/mysql.sock  ， # 这个是  本地套接字（Socket / Unix Domain Socket）连接
	  思考：mysql -uroot -pCkh123.com是使用了哪个连接方式？？？ socket 
	
	   答： 配置文件如果没有指定网络连接参数, 默认是 socket 连接.


什么是实例
	-1 MySQL的后台进程+线程+预分配内存结构
	-2 mysql启动过程会启动后台守护进程，并生成工作线程，预分配内存结构供mysql处理数据使用。
	

# mysqld服务器程序构成



```BASH
mysqld = MySQL 服务器主程序
它是一个单进程多线程架构的程序，负责接收连接、管理内存、管理存储引擎、管理磁盘文件


mysqld 程序运行时的 核心结构（最经典图）
客户端
   ↓
连接管理模块（连接/线程/鉴权）
   ↓
SQL 接口 → 查询解析 → 查询优化 → 查询执行
   ↓
存储引擎层（InnoDB/MyISAM...）
   ↓
系统文件（数据文件、日志文件、socket、pid）


mysqld 服务器程序 核心 4 大组成部分
1. 连接管理模块（Connection Management）
负责：接收客户端连接
处理 TCP/IP 连接（3306 端口）
处理 UNIX Socket 连接（/tmp/mysql.sock）
管理线程池（每来一个连接创建一个线程）
验证用户名密码
你用的：
mysql -uroot -p
就是和这个模块交互。
2. 查询处理模块（Query Handling / SQL Interface）
负责：处理 SQL
包含 4 个步骤：
解析器（Parser）：检查 SQL 语法是否正确
预处理器（Preprocessor）：检查表、权限
查询优化器（Optimizer）：选择最优执行计划
执行器（Executor）：调用存储引擎获取数据
3. 存储引擎层（Storage Engines）
负责：数据怎么存、怎么取
插件式架构，可插拔：
InnoDB（默认，支持事务、行锁、外键）
MyISAM（不支持事务）
Memory（内存表）
CSV、Blackhole 等
MySQL 5.6 默认：InnoDB


系统服务模块（System Services）
后台支撑所有功能
内存管理（缓冲池、日志缓冲）
事务管理
锁机制（行锁、表锁、MDL 锁）
日志模块（redo log、undo log、binlog）
复制模块
备份恢复
故障自动恢复
```

面试题

```BASH
#==================================================
#              mysqld 服务器程序构成（核心 5 大模块）
#==================================================

# 1. 连接管理模块（Connection Management）
# 作用：接收客户端连接、验证、创建线程
# 支持：TCP/IP(3306)、UNIX Socket(/tmp/mysql.sock)
# 功能：身份验证、线程管理、连接回收

# 2. SQL 接口模块（SQL Interface）
# 作用：接收 SQL 命令，返回结果集
# 支持：DML、DDL、DCL、存储过程、触发器

# 3. 查询解析与优化模块（Parser + Optimizer）
# 解析器：检查 SQL 语法、生成解析树
# 预处理器：检查表、列、权限是否合法
# 优化器：生成最优执行计划（索引选择、关联顺序）

# 4. 执行器 + 存储引擎层
# 执行器：调用存储引擎接口
# 存储引擎：真正负责数据读写（InnoDB/MyISAM/Memory）
# MySQL 特点：插件式存储引擎架构

# 5. 系统服务模块（System Services）
# 功能：
#   内存管理（缓冲池、日志缓冲）
#   事务管理（ACID）
#   锁机制（行锁、表锁、MDL锁）
#   日志模块（redo/undo/binlog）
#   主从复制
#   备份恢复
#   故障自动恢复

#==================================================
#                  经典流程（必须背）
#==================================================
客户端连接
   ↓
连接管理（验证、线程）
   ↓
SQL 接口（接收 SQL）
   ↓
解析器 → 优化器 → 执行器
   ↓
存储引擎（InnoDB）
   ↓
磁盘文件（ibd、frm、log）

#==================================================
#               mysqld 高频面试题（12 道）
#==================================================

1. mysqld 是什么？
答：MySQL 服务器主进程，单进程多线程架构。

2. mysqld 由哪 5 大模块组成？
答：连接管理、SQL接口、解析优化、执行器+存储引擎、系统服务。

3. 连接管理模块干什么？
答：接收连接、验证用户、创建线程。

4. MySQL 有哪两种连接方式？
答：TCP/IP(3306)、UNIX Socket(本地最快)。

5. 优化器的作用是什么？
答：生成最优 SQL 执行计划。

6. 执行器干什么？
答：调用存储引擎，完成数据读写。

7. 什么是插件式存储引擎？
答：引擎可插拔，不影响核心服务（InnoDB/MyISAM 切换）。

8. 默认存储引擎是什么？
答：InnoDB。

9. InnoDB 优点？
答：事务、行锁、外键、崩溃恢复。

10. 系统服务模块包含哪些功能？
答：内存、事务、锁、日志、复制、恢复。

11. MySQL 最小 I/O 单元是什么？
答：页（16K）。

12. SQL 语句在 mysqld 内部的执行流程？
答：连接 → SQL 接收 → 解析 → 优化 → 执行 → 引擎 → 磁盘
```







# mysql结构
逻辑结构
	1 库
	2 表: 元数据+真是数据行
	3 元数据: 列+其他属性 (行数+占用空间大小+权限)
	4 列: 列名字+数据类型+其他约束(非空,唯一,非负数,自增长,默认值)
	
二维表:
select user,password,host from mysql.user;

**mysql逻辑结构与linux系统对比:**

| MySQL                    | Linux                |
| ------------------------ | -------------------- |
| 库                       | 目录                 |
| show databases;          | ls-l /               |
| use mysql                | cd /mysql            |
| 表                       | 文件                 |
| show tables;             | ls                   |
| 二维表=元数据+真实数据行 | 文件=文件名+文件属性 |

# mysql 物理结构

```BASH
#=============================
# MySQL 物理结构
#=============================

#-----------------------------
# 一、MyISAM 存储引擎物理文件
#-----------------------------
# 每张表 = 3个文件
user.frm    # 表结构文件（表定义、字段、索引结构）
user.MYD    # 数据文件（MyISAM Data）
user.MYI    # 索引文件（MyISAM Index）

#-----------------------------
# 二、InnoDB 存储引擎物理文件
#-----------------------------
# 每张表 = 2个文件（独立表空间）
old.frm     # 表结构文件
old.ibd     # 数据 + 索引 都在这个文件里

#-----------------------------
# 三、InnoDB 逻辑存储结构
#-----------------------------
# 三层结构：段 → 区 → 页（块）

# 1. 段 (Segment)
# - 理论上：一张表就是一个段
# - 由多个 区 组成
# - 分区表：一个分区 = 一个段

# 2. 区 (Extent)
# - 由连续的多个 页 组成
# - 固定大小：1MB（默认）

# 3. 页 (Page)
# - 最小的数据 I/O 单元
# - 默认大小：16K
# - 所有读写都以页为单位


段、区、页 到底是什么？（用 “书本” 比喻）
1. 页（Page）= 一张纸
最小单位
大小：16K
作用：MySQL 读写数据的最小单元
类比：你写字不能只写半个字，MySQL 读写不能只读写 1B，必须整页操作
2. 区（Extent）= 一叠纸
由连续 64 个页组成
大小：64 × 16K = 1MB（固定）
作用：为了连续存储，减少磁盘碎片
类比：纸不是散乱放的，而是一叠一叠放
3. 段（Segment）= 一本书
由很多个区组成
一个表 ≈ 一个段
类比：一本书 = 很多叠纸组成
终极层级关系（必须背）
plaintext
一张表 = 1个段
1个段 = N 个 区（1MB）
1个区 = 64 个 页（16K）
1个页 = 16K 字节
```



面试题

```BASH
#=============================================
# MySQL 物理结构 面试必背 15 题
#=============================================

#-----------------------------
# 一、文件结构类（高频）
#-----------------------------
1. MyISAM 引擎一张表有几个文件？分别是什么？
答：3 个
   .frm  表结构
   .MYD  数据
   .MYI  索引

2. InnoDB 独立表空间一张表有几个文件？
答：2 个
   .frm  表结构
   .ibd  数据+索引（聚簇索引）

3. .frm 文件是干嘛的？
答：存储表结构定义（字段、类型、索引、约束），所有引擎都有。

4. MyISAM 和 InnoDB 最大的文件区别？
答：MyISAM 数据和索引分离；InnoDB 数据和索引存在一起（.ibd）。

5. ibdata1 是什么？
答：InnoDB 共享表空间，存储数据字典、undo、系统数据。

#-----------------------------
# 二、InnoDB 逻辑结构：段、区、页（必考）
#-----------------------------
6. InnoDB 最小 I/O 单元是什么？
答：页（Page）

7. InnoDB 默认页大小是多少？
答：16K

8. 什么是区（Extent）？
答：连续多个页组成，默认大小 1M。

9. 什么是段（Segment）？
答：一个表通常就是一个段，由多个区组成。
   分区表：一个分区 = 一个段。

10. 段 → 区 → 页 关系是什么？
答：段由多个区组成，区由连续多个页组成。
    表 → 段 → 区 → 页

11. 为什么 InnoDB 要设计“段区页”？
答：减少磁盘碎片、提升连续 I/O、管理更高效。

#-----------------------------
# 三、对比类（面试高频）
#-----------------------------
12. MyISAM 支持事务吗？
答：不支持

13. InnoDB 支持事务吗？
答：支持（默认引擎）

14. MyISAM 和 InnoDB 索引区别？
答：MyISAM：非聚簇索引（数据和索引分开）
    InnoDB：聚簇索引（数据就是索引，索引就是数据）

15. MySQL 一台服务器运行时，哪些是物理文件？
答：.frm .ibd .MYD .MYI ibdata1 ib_logfile binlog 等
```





#mysql用户权限管理

```BASH
#创建用户并设置密码
create user '[新用户名]'@'[作用域]' identified by '[密码]';
flush privileges;　　//创建完要记得刷新权限表
create user oldboy@'10.0.0.%' identified by '123';

#查看用户
select user,host from mysql.user;

#授权加创建用户
grant [权限] on [数据库名].[表名] to '[用户名]'@'[作用域]' identified by '[密码]';
flush privileges;　　//记得刷新权限表

#删除用户 二选一
drop user '[用户名]'@'[作用域]';　　
delete from mysql.user where user='[用户名]' and host='[作用域];  
flush privileges;　　//刷新权限表
drop user oldboy@‘10.0.0.%’；


#修改用户密码

用户的定义: username@'主机域' 
# set password 命令修改密码
SET PASSWORD FOR 'username'@'host' = PASSWORD('new_password');
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root123');

# 推荐alter命令修改用户密码
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root123';
alter user 'root'@'%' identified by 'root123';

# mysql-5.6  
update mysql.user set password=PASSWORD('oldboy123') where user='root' and host='localhost';
# mysq-5.7 版本修改用户密码
update mysql.user set authentication_string=PASSWORD('oldboy123') where user='root' and host='localhost';

# 授权命令,用户不存在会创建
grant all privileges on *.* to oldboy@’10.0.0.%’ identified by ‘123’;

#最后都要刷新授权表
flush privileges;


#刚装完mysql初始化密码
mysqladmin -uroot -p password ‘Ckh123.com’


#误删除所有用户

#关闭数据库
[root@db02 mysql-5.7.20]# /etc/init.d/mysqld stop

#启动数据库
[root@db02 mysql-5.7.20]# mysqld_safe --skip-grant-tables --skip-networking &  #如果没加&符号前台运行,ctrl+z;bg
#或
vi /etc/my.cnf
[mysqld] 后面添加
skip-grant-tables
skip-networking

mysql #直接登录
#使用mysql库
mysql> use mysql
#错误方法1、创建root用户
mysql> create user root@’localhost’;

#错误方法2、创建root用户
mysql> insert into user(user,host,password) values('root','10.0.0.55',PASSWORD('123'));

#正确方法创建root用户
mysql> insert into mysql.user values ('localhost','root',PASSWORD('123'),
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'',
'',
'',
'',0,0,0,0,'mysql_native_password','','N');

3306 [(none)]>quit
pkill mysql
systemctl start mysqld
[root@db03 ~]# mysql -uroot -p
3306 [(none)]>show grants for 'root'@'localhost';


--------------------------mysql-5.7 推荐下面方法 5.6使用也可以, 效果和上面insert语句一样.
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '123' WITH GRANT OPTION;
flush privileges;

select * from mysql.user where user='root'\G;

#忘记root密码

#关闭数据库
[root@db02 mysql-5.7.20]# /etc/init.d/mysqld stop

#启动数据库
[root@db02 mysql-5.7.20]# mysqld_safe --skip-grant-tables --skip-networking

#修改root用户密码
mysql> update user set password=PASSWORD('oldboy123') where user='root' and host='localhost';



```



mysql权限大全

```BASH
#=============================================
#           MySQL 权限完整列表（必背）
#=============================================

#=========================
# 一、全局权限 ( *.* )
#=========================
ALL PRIVILEGES        # 所有权限（万能）
CREATE                # 创建库/表
DROP                  # 删除库/表
DELETE                # 删除数据
INSERT                # 插入数据
UPDATE                # 更新数据
SELECT                # 查询数据
ALTER                 # 修改表结构
INDEX                 # 创建/删除索引
RELOAD                # 刷新权限
SHUTDOWN              # 关闭MySQL
PROCESS               # 查看进程
FILE                  # 读写文件
GRANT OPTION          # 授权他人
SUPER                 # 超级权限（杀线程、改配置）
REPLICATION SLAVE     # 从库复制权限
REPLICATION CLIENT    # 查看主从状态
CREATE USER           # 创建用户
SHOW DATABASES        # 查看所有库

#=========================
# 二、数据库级别权限 ( db.* )
#=========================
CREATE                # 在该库下创建表
DROP                  # 删除该库/表
DELETE                # 库内删数据
INSERT                # 库内插数据
SELECT                # 库内查询
UPDATE                # 库内更新
ALTER                 # 库内改表
INDEX                 # 库内索引
CREATE ROUTINE        # 创建存储过程
ALTER ROUTINE         # 修改存储过程
EXECUTE               # 执行存储过程
LOCK TABLES           # 锁表

#=========================
# 三、表级别权限 ( db.tb )
#=========================
SELECT                # 查询表
INSERT                # 插入表
DELETE                # 删除表
UPDATE                # 更新表
ALTER                 # 修改表
INDEX                 # 索引
CREATE                # 创建表
DROP                  # 删除表
TRIGGER               # 触发器

#=========================
# 四、列级别权限（最细）
#=========================
SELECT (col1,col2)    # 只查某些列
INSERT (col1,col2)    # 只插某些列
UPDATE (col1,col2)    # 只改某些列

#=========================
# 五、管理类权限（DBA专用）
#=========================
CREATE USER           # 用户管理
SHOW DATABASES        # 查看所有库
SUPER                 # 核心管理
PROCESS               # 查看连接
RELOAD                # flush privileges
GRANT OPTION          # 可转授权限

#=========================
# 六、最常用 3 套权限（工作直接用）
#=========================

# 1. 只读账号（最常用）
GRANT SELECT ON *.* TO 'user'@'%';

# 2. 普通读写账号（开发）
GRANT SELECT,INSERT,UPDATE,DELETE ON db.* TO 'user'@'%';

# 3. DBA超级管理员
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;


#一般给开发创建用户权限
grant select,update,delete,insert on db.* to user@’10.0.0.%’ identified by ‘123’;
```



mysql权限高频面试题

```BASH
#==================================================
#           MySQL 权限 面试必考题（含答案）
#==================================================

#--------------------------
# 1. 基础概念类（必考）
#--------------------------
1. MySQL 权限分为哪几个级别（从大到小）？
答：全局权限(*.*) → 库权限(db.*) → 表权限(db.tb) → 列权限。

2. MySQL 权限存在哪几个系统表里？
答：
mysql.user       # 全局权限
mysql.db         # 库权限
mysql.tables_priv# 表权限
mysql.columns_priv# 列权限

3. % 代表什么意思？
答：代表任何IP地址都可以连接。

4. localhost 代表什么？
答：代表只能本机连接。

#--------------------------
# 2. 常用权限类
#--------------------------
5. 给一个用户创建只读权限，命令是什么？
答：
GRANT SELECT ON *.* TO 'user'@'%';

6. 给一个用户分配某一个库的读写权限，命令是什么？
答：
GRANT SELECT,INSERT,UPDATE,DELETE ON testdb.* TO 'user'@'%';

7. SUPER 权限是干嘛的？
答：超级权限，可以杀线程、修改全局变量、主从复制管理。

8. REPLICATION SLAVE 是干嘛的？
答：从库连接主库的复制权限。

9. GRANT OPTION 作用？
答：允许把自己的权限再授权给别人。

#--------------------------
# 3. 操作命令类
#--------------------------
10. 查看当前用户权限的命令？
答：show grants;

11. 查看指定用户权限？
答：show grants for 'user'@'%';

12. 回收权限用什么命令？
答：revoke。
例：revoke delete on *.* from 'user'@'%';

13. 授权后必须执行什么命令？
答：flush privileges; 刷新权限。

#--------------------------
# 4. 综合面试题
#--------------------------
14. root 远程连接不上一般是什么原因？
答：
1) root 只允许 localhost 登录
2) 没有给 root@'%' 授权
3) 防火墙没开 3306
4) 绑定地址 bind-address 限制

15. 生产环境为什么不能给普通账号 SUPER、ALL PRIVILEGES？
答：
1) 权限过大，危险
2) 可删库、可删数据、可杀连接
3) 不符合最小权限原则
```






# mysql连接管理
```BASH
## 连接工具

	mysql 
		-u 指定用户 
		-p 指定密码
		-h 指定主机
		-P 指定端口
		-S 指定sock
		-e 指定sql
		--protocol=name：指定连接方式
	
	第三方连接工具 sqlyog、navicat

## 连接方式

socket连接
	mysql -uroot -pold -S /tmp/mysql.sock 
	msyql -uroot -p 
tcp/ip 
	mysql -uroot -p123 -h10.0.0.5 -P3306 
```



# mysql启动关闭流程
```BASH
mysql.server 启动     ---> mysql_safe 启动   --> mysqld 
   ^						   ^
   |						   |
service mysqld start    ./bin/mysqld_safe &

启动
/etc/init.d/mysqld start ------> mysqld_safe ------> mysqld

关闭
/etc/init.d/mysqld stop 
mysqladmin -uroot -p**** shutdown

kill -9 pid ?
killall mysqld ?
pkill mysqld ?
出现问题：
- 1、如果在业务繁忙的情况下，数据库不会释放pid和sock文件
- 2、号称可以达到和Oracle一样的安全性，但是并不能100%达到
- 3、在业务繁忙的情况下，丢数据（补救措施，高可用）

---------------------------------------------------------------------
#==================================================
#              MySQL 启动 → 运行 → 关闭 全流程
#==================================================

#=========================
# 一、MySQL 启动流程（重点）
#=========================
1. 读取配置文件
   - my.cnf / my.ini
   - 加载端口、数据目录、内存、字符集等

2. 初始化核心内存结构
   - 缓冲池 (Buffer Pool)
   - 日志缓冲、表缓存等

3. 启动后台线程
   - 主线程、IO线程、Purge清理线程、锁线程

4. 打开物理文件
   - ibdata1、ib_logfile、redo log、binlog
   - 加载表空间文件 .ibd

5. 恢复阶段（崩溃恢复）
   - 应用 redo log 前滚
   - 回滚未提交事务 undo log

6. 启动监听
   - 打开 3306 端口
   - 生成 /tmp/mysql.sock
   - 开始接收客户端连接

7. 启动完成
   - 可以登录 mysql
   - 提供读写服务


#=========================
# 二、MySQL 关闭流程（重点）
#=========================
1. 停止接收新连接
   - 关闭 3306 端口
   - 关闭 socket 文件

2. 等待活跃事务执行完毕
   - 不允许新事务
   - 等待运行中 SQL 结束

3. 刷新脏页到磁盘
   - 将 Buffer Pool 里的修改数据写入 .ibd

4. 关闭所有存储引擎
   - InnoDB 做 checkpoint
   - 确保数据完全落盘

5. 关闭线程、释放内存
   - 退出所有后台线程
   - 释放缓冲池

6. 退出进程 mysqld
   - 删除 pid 文件
   - 完全关闭


#=========================
# 三、常用启动/关闭命令
#=========================

# 1. 启动
systemctl start mysqld
service mysqld start
/etc/init.d/mysqld start

# 2. 关闭（推荐安全关闭）
systemctl stop mysqld
service mysqld stop
/etc/init.d/mysqld stop

# 3. 重启
systemctl restart mysqld

# 4. 强制关闭（不推荐，可能丢数据）
pkill mysqld
kill -9 进程号


#=========================
# 四、启动关闭 3 个关键点（面试必考）
#=========================
1. 启动必须做：崩溃恢复（redo + undo）
2. 关闭必须做：刷脏页、做 checkpoint
3. kill -9 会丢数据，绝对不能乱用！


#=========================
# 五、一句话总结流程
#=========================
启动：读配置 → 开内存 → 启线程 → 开文件 → 崩溃恢复 → 监听端口
关闭：停连接 → 等事务 → 刷数据 → 关引擎 → 退进程
```




# mysql实例初始化配置


```BASH
优先级结论：
● 1、命令行   		 #mysqld --port=3307 --datadir=/data/mysql2
● 2、defaults-file  #mysqld --defaults-file=/etc/my3306.cnf  #指定配置文件 ，其他的配置文件都不读。
● 3、配置文件   
● 4、预编译


配置文件读取顺序：
/etc/my.cnf
/etc/mysql/my.cnf
$MYSQL_HOME/my.cnf（前提是在环境变量中定义了MYSQL_HOME变量）
defaults-extra-file （类似include） # mysqld --defaults-extra-file=/path/extra.cnf
~/my.cnf



1）MySQL 5.7 初始化（最常用）
mysqld --initialize --user=mysql --datadir=/data/mysql
会生成临时密码（记下来）
安全初始化
2）MySQL 5.6 初始化
mysql_install_db --user=mysql --datadir=/data/mysql
初始无密码
3）MySQL 8.0 初始化
mysqld --initialize --user=mysql --datadir=/data/mysql
和 5.7 一样
```



# MySQL多实例配置
● 1.什么是多实例
	1）多套后台进程+线程+内存结构
	2）多个配置文件
		a.多个端口
		b.多个socket文件
		c.多个日志文件
		d.多个server_id
	3）多套数据

## 多实例实战
```bash
#创建数据目录
mkdir -p /data/330{7..9}
#创建配置文件
touch /data/330{7..9}/my.cnf
#编辑3307配置文件
cat > /data/3307/my.cnf <<EOF
[mysqld]
basedir=/application/mysql
datadir=/data/3307/data
socket=/data/3307/mysql.sock
log_error=/data/3307/mysql.log
log-bin=/data/3307/mysql-bin
server_id=7
port=3307
[client]
socket=/data/3307/mysql.sock
EOF
#编辑3308配置文件
cat > /data/3308/my.cnf <<EOF
[mysqld]
basedir=/application/mysql
datadir=/data/3308/data
socket=/data/3308/mysql.sock
log_error=/data/3308/mysql.log
log-bin=/data/3308/mysql-bin
server_id=8
port=3308
[client]
socket=/data/3308/mysql.sock
EOF
#编辑3309配置文件
cat > /data/3309/my.cnf <<EOF
[mysqld]
basedir=/application/mysql
datadir=/data/3309/data
socket=/data/3309/mysql.sock
log_error=/data/3309/mysql.log
log-bin=/data/3309/mysql-bin
server_id=9
port=3309
[client]
socket=/data/3309/mysql.sock
EOF

#初始化3307数据
/application/mysql/scripts/mysql_install_db --user=mysql --defaults-file=/data/3307/my.cnf --basedir=/application/mysql --datadir=/data/3307/data
#初始化3308数据
/application/mysql/scripts/mysql_install_db --user=mysql --defaults-file=/data/3308/my.cnf --basedir=/application/mysql --datadir=/data/3308/data
#初始化3309数据
/application/mysql/scripts/mysql_install_db --user=mysql --defaults-file=/data/3309/my.cnf --basedir=/application/mysql --datadir=/data/3309/data
#修改目录权限
chown -R mysql.mysql /data/330*


# systemd 管理多套实例
cp /etc/systemd/system/mysqld.service /etc/systemd/system/mysqld3307.service
cp /etc/systemd/system/mysqld.service /etc/systemd/system/mysqld3308.service
cp /etc/systemd/system/mysqld.service /etc/systemd/system/mysqld3309.service

sed -i s#--defaults-file=/etc/my.cnf#--defaults-file=/data/3307/my.cnf#g /etc/systemd/system/mysqld3307.service
sed -i s#--defaults-file=/etc/my.cnf#--defaults-file=/data/3308/my.cnf#g /etc/systemd/system/mysqld3308.service
sed -i s#--defaults-file=/etc/my.cnf#--defaults-file=/data/3309/my.cnf#g /etc/systemd/system/mysqld3309.service

systemctl daemon-reload
systemctl start mysqld3307.service
systemctl start mysqld3308.service
systemctl start mysqld3309.service

#验证多实例
netstat -lnp|grep 330
mysql -S /data/3307/mysql.sock -e "select @@server_id"
mysql -S /data/3308/mysql.sock -e "select @@server_id"
mysql -S /data/3309/mysql.sock -e "select @@server_id"


```
# mysql客户端工具及sql
# 客户端命令
```mysql
mysql 
 - 连接 （略）

2） 管理：	
#MySQL接口自带的命令
\h 或 help 或？      查看帮助
\G                  格式化查看数据（key：value）
\T 或 tee            记录日志
\c（5.7可以ctrl+c）   结束命令
\s 或 status         查看状态信息
\. 或 source         导入SQL数据
\u或 use             使用数据库
\q 或 exit 或 quit   退出

3）接收用户的SQL语句
● 2、将用户的SQL语句发送到服务器

mysqladmin
● 1、命令行管理工具
mysqldump
● 1、备份数据库和表的内容

help命令的使用
mysql> help
mysql> help contents
mysql> help select
mysql> help create
mysql> help create user
mysql> help status
mysql> help show

source命令的使用
#在MySQL中处理输入文件：
#如果这些文件包含SQL语句则称为：
#1.脚本文件
#2.批处理文件
mysql> SOURCE /data/mysql/world.sql
#或者使用非交互式
mysql</data/mysql/world.sql


mysqladmin命令的使用
01）“强制回应 (Ping)”服务器。
02）关闭服务器。
03）创建和删除数据库。
04）显示服务器和版本信息。
05）显示或重置服务器状态变量。
06）设置口令。
07）重新刷新授权表。
08）刷新日志文件和高速缓存。
09）启动和停止复制。
10）显示客户机信息。
#查看MySQL存活状态
mysqladmin -uroot -p123 ping
#查看MySQL状态信息
mysqladmin -uroot -p123 status
#关闭MySQL进程
mysqladmin -uroot -p123 shutdown
#查看MySQL参数
mysqladmin -uroot -p123 variables
#删除数据库
mysqladmin -uroot -p123 drop DATABASE
#创建数据库
mysqladmin -uroot -p123 create DATABASE
#重载授权表
mysqladmin -uroot -p123 reload
#刷新日志
mysqladmin -uroot -p123 flush-log
#刷新缓存主机
mysqladmin -uroot -p123 reload
#修改口令
mysqladmin -uroot -p123 password
```


# 接收用户的sql语句


```sql
-- SQL 全称：Structured Query Language
-- 中文：结构化查询语言
-- 用来操作数据库的语言

-- ==============================================
-- SQL 五大种类 完整版（一个SQL全包含）
-- ==============================================
-- 1. DDL ： Data Definition Language     数据定义语言
-- 2. DML ： Data Manipulation Language    数据操作语言
-- 3. DQL ： Data Query Language           数据查询语言
-- 4. DCL ： Data Control Language          数据控制语言
-- 5. TCL ： Transaction Control Language   事务控制语言


-- 1. DDL 数据定义语言：定义库、表、结构（CREATE、ALTER、DROP、TRUNCATE）
-- 管：库、表、索引、结构
-- 关键字： CREATE、ALTER、DROP、TRUNCATE、RENAME
CREATE DATABASE testdb;
CREATE TABLE user (id INT);
ALTER TABLE user ADD name VARCHAR(10);
TRUNCATE TABLE user;
DROP TABLE user;
DROP DATABASE testdb;

-- 2. DML 数据操作语言：操作数据（增、删、改）
-- 关键字： INSERT、UPDATE、DELETE
INSERT INTO user(id,name) VALUES(1,'zhangsan');
UPDATE user SET name='lisi' WHERE id=1;
DELETE FROM user WHERE id=1;

-- 3. DQL 数据查询语言：查询数据
-- 关键字： SELECT
SELECT * FROM user;

-- 4. DCL 数据控制语言：权限、用户管理
-- 关键字： GRANT、REVOKE、CREATE USER
GRANT SELECT ON *.* TO 'test'@'%';
REVOKE SELECT ON *.* FROM 'test'@'%';
CREATE USER 'test'@'%' IDENTIFIED BY '123';

-- 5. TCL 事务控制语言：事务提交/回滚
-- 管：事务提交、回滚
-- 关键字： COMMIT、ROLLBACK、SAVEPOINT
BEGIN;
INSERT INTO user VALUES(2,'wangwu');
COMMIT;
-- ROLLBACK;


```



# DDL（Data Definition Language）数据定义语言

```SQL
## 库对象: 库名字,库属性
库对象：库名字、库属性
开发规范：库名小写
创建库：create database|schema
-- 创建oldboy数据库;
create database oldboy;
#创建OLDBOY数据库
create database OLDBOY;
#查看数据库
show databases;
#查看oldboy的创建语句（DQL）
show create database oldboy;
#查看创建数据库语句帮助
help create database
#创建testa数据库添加属性
create database testa charset utf8;
create database testa charset utf8mb4;

-- 删库：drop database
drop database testa;

# 修改定义库：alter database
-- 修改oldboy数据库属性;
alter database oldboy charset gbk;
-- 查看oldboy的创建语句（DQL）;
show create database oldboy;


# 表对象:列名、列属性、约束
# 创建表：create table （开发做）
-- #查看创建表语句帮助;
help create table
-- #创建表;
mysql> create table student(
  sid INT,
  sname VARCHAR(20),
  sage TINYINT,
  sgender ENUM('m','f'),
  cometime DATETIME);
  
数据类型
int： 整数 -2次方31 ~ 2次方331 -1
varchar：字符类型 （变长）
char： 字符类型 （定长）
tinyint： 整数 -128 ~ 128
enum： 枚举类型
datetime： 时间类型 年月日时分秒

-- #创建表加其他属性;
create table student(
sid INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT ‘学号’,
sname VARCHAR(20) NOT NULL COMMENT ‘学生姓名’,
sage TINYINT UNSIGNED COMMENT ‘学生年龄’,
sgender ENUM('m','f')  NOT NULL DEFAULT ‘m’ COMMENT ‘学生性别’,
cometime DATETIME NOT NULL COMMENT ‘入学时间’)chatset utf8 engine innodb;

-- #查看建表语句;
show create table student;
-- #查看表;
show tables;
-- #查看表中列的定义信息;
desc student;

数据属性
	not null： 非空
	primary key： 主键（唯一且非空的）
	auto_increment： 自增（此列必须是：primary key或者unique key）
	unique key： 单独的唯一的
	default： 默认值
	unsigned： 非负数
	comment： 注释



# 修改表定义：alter table （开发做）
-- #修改表名;
alter table student rename stu;
alter table stu rename student;
-- #添加列和列定义;
alter table stu add age int;
--#添加多个列;
alter table stu add test varchar(20),add qq int;
-- #指定位置进行添加列（表首）;
alter table stu add classid varchar(20) first;
-- #指定位置进行添加列（指定列）;
alter table stu add phone int after age;
-- #删除指定的列及定义;
alter table stu drop qq;
alter table student drop classid;
-- #修改列及定义（列属性）;
alter table stu modify sid varchar(20);
-- #修改列及定义（列名及属性）;
alter table stu change phone telphone char(20);
alter table student change sid id int ;
alter table student change sname name varchar(20);
alter table student change sgender gender enum('m','f');
alter table student drop sage;
alter table student change test classname varchar(20);
alter table student modify id int auto_increment;

-- #删除表;
drop table student;


# 表 + 所有字段 + 已有数据 全部转成 utf8   collate排序规则 utf8mb4_unicode_ci = 不区分大小写的通用排序规则
ALTER TABLE student CONVERT TO CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;


```



# DCL（Data Control Language）数据控制语言

```BASH
## 授权 grant 

- 授权root@10.0.0.51用户所有权限 (非超级管理员)
  grant all on *.* to root@'%' identified by 'old123'
- 怎么去授权一个超级管理员
  grant all on *.* to root@'%'' identified by 'old123' with grant option;
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'' IDENTIFIED BY 'old123' WITH GRANT OPTION;

- 其他参数（扩展）
  max_queries_per_hour：一个用户每小时可发出的查询数量
  max_updates_per_hour：一个用户每小时可发出的更新数量
  max_connetions_per_hour：一个用户每小时可连接到服务器的次数
  max_user_connetions：允许同时连接数量

## 收回权限revoke  

revoke select on *.* from root@'%''; 
show grants from root@'%'';



```



# DML：（Data Manipulation Language）数据操作语言

```sql
-- 操作表的数据行信息
-- insert
-- #基础用法，插入数据


| student | CREATE TABLE `student` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` enum('m','f') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cometime` datetime DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `telphone` char(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `classname` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci |

insert into student values(null,'zhangsan','m',NOW(),'18',110,'linxu');

-- #规范用法，插入数据
insert into student(name,gender,cometime,age,telphone,classname) values('lisi','f',NOW(),20,110,"python");

-- #插入多条数据
insert into student(name,gender,cometime,age,telphone,classname) values('lisi','f',NOW(),20,110,"python"),('wu','f',now(),20,118,'go');




- update 
-- #不规范
update student set gender='f';
-- #规范update修改
update student set gender='f' where id=1;
update student set gender='m' where id=4 or id=1;
update student set gender='f' where id in(1,3);\

-- #如果非要全表修改
update student set gender='f' where 1=1;


- delete 
-- #不规范
delete from student;
-- #规范删除（危险）
delete from student where id=3;
-- #DDL删除表
-- 如果你需要删除表中的所有行，并且不需要回滚操作，TRUNCATE 是一个更快的选择;
truncate table student;


delete from student;  truncate table student; 区别
命令	   类型	自增 ID	能否回滚  速度
DELETE	 DML	保留	   能	    慢
TRUNCATE DDL	重置	  不能	   极快
DELETE： 一行一行删数据， 属于 DML
TRUNCATE： 直接清空整张表，直接摧毁重建表  属于 DDL

- update 代替delete
1）额外添加一个状态列
alter table student add status enum('1','0') default 1;
2）使用update
update student set status='0' where id=1;
3）应用查询存在的数据
select * from student where status=1;
● 2、使用触发器（了解） trigger

-- 触发器：当执行 delete 时，自动改为逻辑删除
DELIMITER //  -- 临时修改语句结束符
CREATE TRIGGER trigger_student_del
BEFORE DELETE ON student
FOR EACH ROW
BEGIN
    -- 直接抛错，不让删除
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '禁止物理删除！请使用逻辑删除：update student set status=0 where id=xxx';
END //
DELIMITER ;

-- 测试效果
DELETE FROM student WHERE id=1;
-- 删除触发器
DROP TRIGGER trigger_student_del;
DROP TRIGGER IF EXISTS trigger_student_del;

SHOW TRIGGERS;

```



# DQL（Data Query Language）数据查询语言

```sql
# https://dev.mysql.com/doc/index-other.html
# Example Databases 下载
# wget https://downloads.mysql.com/docs/world-db.tar.gz
# tar xf world-db.tar.gz && cd world-db
# mysql -uroot -proot123 < world.sql

-- 先认识 world 库的 3 张表（关联字段）
-- 1. city  城市表    关键字段：ID(主键)、Name(城市名)、CountryCode(国家编码)
-- 2. country 国家表  关键字段：Code(国家编码,主键)、Name(国家名)、Continent(洲)
-- 3. countrylanguage 语言表 关键字段：CountryCode(国家编码)、Language(语言)
-- 关联关系：city.CountryCode = country.Code
--          countrylanguage.CountryCode = country.Code


use world;
-- #基础查询

-- 1. 查询所有数据 *代表所有列
SELECT * FROM city;
-- 2. 查询指定列
SELECT Name, Population FROM city;
-- 3. 去重查询 DISTINCT
SELECT DISTINCT Continent FROM country;

-- 条件查询
-- 1. 查询中国(CN)的所有城市
SELECT * FROM city WHERE CountryCode='CHN';
-- 2. 查询人口大于100万的城市
SELECT * FROM city WHERE Population > 1000000;
-- 3. 多条件 and/or
SELECT * FROM city WHERE CountryCode='CHN' AND Population>50000;

-- 排序 ORDER BY / 分页 LIMIT
-- 1. 按人口降序排序（大→小）
SELECT * FROM city ORDER BY Population DESC;
-- 2. 查询前10条数据
SELECT * FROM city LIMIT 10;
SELECT * FROM city LIMIT 2,2;

-- #排序查询（顺序）
select id,name,population,countrycode from city order by countrycode limit 10;
-- #排序查询（倒叙）
select id,name,population,countrycode from city order by countrycode desc limit 10;


-- #模糊查询
select name,population,countrycode from city where countrycode like '%H%' limit 10;

-- #范围查询(>,<,>=,<=,<>)
select * from city where population>=1410000;
-- #范围查询OR语句
select * from city where countrycode='CHN' or countrycode='USA';
-- #范围查询IN语句
select * from city where countrycode in ('CHN','USA');


-- 分组统计 GROUP BY + 聚合函数
-- 统计每个国家的城市数量
SELECT CountryCode, COUNT(*) AS city_count FROM city GROUP BY CountryCode;

-- 1. 内连接 INNER JOIN（取交集，两张表都匹配的数据）
-- 作用：只查询相互匹配的数据

-- 查询：城市名 + 对应的国家名
SELECT 
	c.Name AS 城市名, 
	cou.Name AS 国家名 
FROM city c 
INNER JOIN country cou 
ON c.CountryCode = cou.Code; -- 关联条件：国家编码相等

-- 2. 左连接 LEFT JOIN（左表全显示，右表匹配，不匹配为 NULL）
-- 作用：左表数据全部保留，右表有就显示，没有显示 NULL
-- 左表：country 国家表
-- 右表：countrylanguage 语言表
-- 查询：所有国家 + 对应的官方语言（没有语言也显示国家）
SELECT 
  cou.Name AS 国家名,
  cl.Language AS 语言
FROM country cou
LEFT JOIN countrylanguage cl 
ON cou.Code = cl.CountryCode;

-- 3. 右连接 RIGHT JOIN（右表全显示，左表匹配）
-- 作用：右表数据全部保留，左表匹配
-- 右表：city 城市表 全显示
-- 左表：country 匹配显示
SELECT 
  cou.Name AS 国家名,
  c.Name AS 城市名
FROM country cou
RIGHT JOIN city c 
ON cou.Code = c.CountryCode;

-- 子查询(查询嵌套)
-- 查询人口最多的城市
SELECT * FROM city 
WHERE Population = (SELECT MAX(Population) FROM city);



```




# 字符集定义
```bash
● 1什么是字符集
计算机是以二进制存储数据,我们再屏幕上看到文字在存储之前被转换成二进制,在显示的时候也要根据二进制找到对应的字符. 可想而知,特定的文字对应着固定的二进制.否则转换会发生混乱.
文字与二进制的对应关系的一套规范就称为字符集(character set)或者叫字符编码 (character encoding)

● 2.MySQL数据库的字符集
	1）字符集（CHARACTER）
	2）校对规则（COLLATION）
● 3.MySQL中常见的字符集
	1）UTF8
	2）LATIN1
	3）GBK
● 4.常见校对规则
	1）ci：大小写不敏感
	2）cs或bin：大小写敏感

● 5.我们可以使用以下命令查看
show charset;
show collation;

字符集   特点	             能不能存中文	能不能存表情 😊	推荐度
latin1	老编码， 只支持英文	   ❌ 不能	  ❌ 不能	        不推荐
utf8	MySQL 假 utf8，3 字节	✅ 能	  ❌ 不能	        淘汰
utf8mb4	真 utf8，4 字节	        ✅ 能	  ✅ 能	         生产必用


字符集（CHARSET）：决定 能存什么字     推荐utf8mb4 
排序规则（COLLATE）：决定 文字怎么排序、比大小  推荐utf8mb4_unicode_ci
```



# 字符集设置
```sql
-- 操作系统级别
  source /etc/sysconfig/i18n
  echo $LANG
  zh_CN.UTF-8

-- mysql实例级别
  编译时候指定
  cmake . 
  -DDEFAULT_CHARSET=utf8mb4 \
  -DDEFAULT_COLLATION=utf8mb4_unicode_ci \
  -DWITH_EXTRA_CHARSETS=all \

配置文件设置字符集
[mysqld]
character-set-server=utf8mb4

建库级别
create database oldboy charset utf8mb4 default collate=utf8mb4_unicode_ci;
create database oldboy charset utf8mb4 default collate = utf8mb4_unicode_ci;
建表级别
create table test(
id int(4) not null auto_increment,
name char(20) not null,
primary key (id)
)engine=innodb auto_increment=13 default charset=utf8mb4;
-- auto_increment=13 表示自增数字从13开始，不写默认是从1开始

-- 思考问题：如果在生产环境中，字符集不够用或者字符集不合适该怎么处理？
-- 答： 生产环境更改数据库（含数据）字符集的方法
alter database oldboy character set utf8mb4 collate utf8mb4_unicode_ci;
alter table t1 character set utf8mb4;



```



# select 高级用法

```sql
- 多表连接查询
select t1.sname,t2.mark from t1,t2 where t1.sid=t2.sid and t1.sname=’zhang3’;

-- 先认识 world 库的 3 张表（关联字段）
-- 1. city  城市表    关键字段：ID(主键)、Name(城市名)、CountryCode(国家编码)
-- 2. country 国家表  关键字段：Code(国家编码,主键)、Name(国家名)、Continent(洲)
-- 3. countrylanguage 语言表 关键字段：CountryCode(国家编码)、Language(语言)
-- 关联关系：city.CountryCode = country.Code
--          countrylanguage.CountryCode = country.Code

## 传统连接  内连接 取交集
USE world;
-- 世界上小于100人的人口城市是哪个国家的？
select city.name as 城市名,city.countrycode,country.name as 国家民,city.population
from city,country 
where city.countrycode=country.code 
and city.population<100;

## NATURAL　JOIN（自连接的表要有共同的列名字）
SELECT city.name,city.countrycode ,countrylanguage.language ,city.population
FROM  city NATURAL  JOIN  countrylanguage 
WHERE population > 1000000
ORDER BY population;

## 企业中多表连接查询（内连接）
select city.name as 城市名,city.countrycode,country.name as 国家名,city.population
from city inner join country on city.countrycode=country.code 
where city.population<100;

-- 建议：使用join语句时，小表在前，大表在后。

- 左连接
select city.name as 城市名,city.countrycode,country.name as 国家名,city.population
from city left join country 
on city.countrycode=country.code 
and city.population<100;

-- 上面左连接查出来 population人数大于100也显示出来了
执行规则（LEFT JOIN 铁律）
左表 city ：所有行 100% 全部显示（无论 ON 条件是否成立）
右表 country ：只有满足 code匹配 + 人口<100 才显示，不满足显示 NULL
结果：city 表的 population 还是原来的数字，大于 100 的依然会显示！

-- INNER JOIN	内连接	只查匹配的数据
-- LEFT JOIN	左连接	左表全显示，右表匹配
-- RIGHT JOIN	右连接	右表全显示，左表匹配

--正确写法
select city.name as 城市名,city.countrycode,country.name as 国家名,city.population
from city 
left join country
on city.countrycode=country.code  -- 🔴 只写表关联条件
-- 🟢 真正的过滤条件，放这里！
where city.population < 100; 


- UNION（合并查询）
用途：把多个「完全不同的查询」结果，拼到一张表里展示
UNION：合并 + 自动去重（速度慢）
UNION ALL：合并 + 不去重（速度快，生产首选）
MySQL 5.6 版本有硬性规定：UNION 里的每个 SELECT 带 LIMIT，必须加括号 () 包裹！

#范围查询OR语句
select * from city where countrycode='CHN' or countrycode='USA';
#范围查询IN语句
select * from city where countrycode in ('CHN','USA');

替换为：
(select * from city where countrycode='CHN' limit 10)
union  all
(select * from city where countrycode='USA' limit 10);


-- 查询中国(CN)前2个城市
(SELECT Name, CountryCode, Population FROM city WHERE CountryCode='CHN' LIMIT 2)
UNION all
-- 查询美国(US)前2个城市
(SELECT Name, CountryCode, Population FROM city WHERE CountryCode='USA' LIMIT 2);


```



# mysql数据类型

数值类型 + 字符串类型 + 日期时间类型

## 数值类型

| 分类   | 数据类型  | 占用字节   | 说明                                      | 常用场景                                          |
| ------ | --------- | ---------- | ----------------------------------------- | ------------------------------------------------- |
| 整数   | TINYINT   | 1 字节     | 极小整数；有符号：-128~127，无符号：0~255 | 状态标记 (0/1)、性别、年龄、开关字段              |
| 整数   | SMALLINT  | 2 字节     | 较小整数（−215∼215−1）                    | 年份、小型统计数量、区域编号                      |
| 整数   | MEDIUMINT | 3 字节     | 中型整数（−223∼223−1）                    | 中小型业务计数、行政区划编码                      |
| 整数   | INT       | 4 字节     | 常规整数（−231∼231−1）                    | **主键自增 ID、订单数量、人口统计（日常最常用）** |
| 整数   | BIGINT    | 8 字节     | 大整数（−263∼263−1）                      | 雪花 ID、超大订单编号、海量数据主键               |
| 浮点数 | FLOAT     | 4 字节     | 单精度浮点、近似存储                      | 科学实验数据、非精密小数（**禁止存金额**）        |
| 浮点数 | DOUBLE    | 8 字节     | 双精度浮点、近似存储                      | 大数据科学运算、非财务类小数                      |
| 定点数 | DECIMAL   | 变长 (M+2) | 定点精确存储，整数 + 小数精准保存         | **金额、商品单价、财务账务（必须精准计算）**      |
| BIT    | BIT       | 1~64 位    | 位字段，自定义位数存储二进制              | 多选项位标记、权限位掩码存储                      |

**补充知识点**

1. `DECIMAL(M,D)`：M 总有效位数、D 小数位，存储长度随 M 动态变化；
2. 带`UNSIGNED`无符号修饰时：数值下限变为 0，上限翻倍；
3. 金额业务**永远优先 DECIMAL，禁用 FLOAT/DOUBLE**（浮点存在精度丢失）。



## 字符串类型

| 分类 | 类型       | 占用字节                                                 | 说明                                                  | 常用场景                                               |
| ---- | ---------- | -------------------------------------------------------- | ----------------------------------------------------- | ------------------------------------------------------ |
| 文本 | CHAR(M)    | 固定：`M × 单字符字节(utf8mb4=4B)`，M 最大 255           | 固定长度字符串，不足长度自动补空格，上限 255 字符     | 手机号、身份证号、固定长度编码、验证码                 |
| 文本 | VARCHAR(M) | 变长：实际内容字节 + 1/2 字节长度标识，总上限 65535 字节 | 可变长度字符串，最大占用 65535 字节，按需分配存储空间 | **姓名、地址、昵称（业务最常用字符串）**               |
| 文本 | TINYTEXT   | 实际内容 + 1 字节，最大 255 字节                         | 可变长文本，最多存储 255 字节内容                     | 简短简介、备注、商品小标题                             |
| 文本 | TEXT       | 实际内容 + 2 字节，最大 65535 字节                       | 可变长文本，上限 65535 字节                           | 商品详情、短篇文案、留言内容                           |
| 文本 | MEDIUMTEXT | 实际内容 + 3 字节，最大 16777215 字节                    | 中型大容量文本                                        | 中篇文章、产品说明书、长表单备注                       |
| 文本 | LONGTEXT   | 实际内容 + 4 字节，最大 4294967295 字节                  | 超大容量长文本                                        | 小说全文、大型文档、富文本博文                         |
| 枚举 | ENUM       | 1~2 字节                                                 | 单选枚举，只能从预设值里选 1 个数据                   | 性别`('m','f')`、状态`('0','1')`、学历（固定单选选项） |
| 集合 | SET        | 1~8 字节                                                 | 多选集合，可从预设值里多选任意多个                    | 用户兴趣标签、多选权限、爱好勾选                       |

**补充知识点**

1. **VARCHAR 上限 65535 是字节，不是字符**：`utf8mb4`单个汉字占 4 字节，因此 VARCHAR 实际可存字符≈16000 个；
2. **CHAR 固定长度优势：查询速度更快**，固定长度字段索引效率优于 VARCHAR；
3. **大文本 (TEXT 系列) 不能加默认值，不建议做索引**，超长内容优先用 LONGTEXT。



## 日期类型

| 分类     | 数据类型  | 占用字节 | 说明                                                         | 常用场景                               |
| -------- | --------- | -------- | ------------------------------------------------------------ | -------------------------------------- |
| 日期时间 | YEAR      | 1 字节   | 仅存储年份，格式`YYYY`，取值范围：1901～2155                 | 入学年份、出生年份、产品投产年份       |
| 日期时间 | DATE      | 3 字节   | 只存年月日，格式`YYYY-MM-DD`，范围：`1000-01-01 ~ 9999-12-31` | 用户生日、订单下单日期、活动日期       |
| 日期时间 | TIME      | 3 字节   | 时分秒`HH:MM:SS`，支持正负时长，范围`-838:59:59 ~ 838:59:59` | 课程时长、视频播放时长、考勤耗时       |
| 日期时间 | DATETIME  | 8 字节   | 年月日 + 时分秒`YYYY-MM-DD HH:MM:SS`，范围同 DATE，**不受时区影响** | 数据创建时间、业务操作时间（项目首选） |
| 日期时间 | TIMESTAMP | 4 字节   | 时间戳自动转日期，范围`1970-01-01 ~ 2038-01-19`，跟随数据库时区变化，可设置`ON UPDATE CURRENT_TIMESTAMP`自动更新 | 数据最后修改时间、日志记录时间         |

 **关键补充知识点**

1. **TIMESTAMP 特性**：字段配置 `update CURRENT_TIMESTAMP` 后，该行数据更新时自动刷新为当前时间；受系统时区制约，2038 年后数据溢出，新项目优先 DATETIME。
2. **DATETIME 优势**：无 2038 年限制、不受时区影响，**企业开发存储创建时间标配**。
3. 插入数据简写：`CURRENT_DATE`(当前日期)、`NOW()`/`CURRENT_TIMESTAMP`(当前年月日时分秒)。



## 二进制数据类型

| 分类   | 类型         | 占用字节                                                   | 说明                                                         | 常用场景                                     |
| ------ | ------------ | ---------------------------------------------------------- | ------------------------------------------------------------ | -------------------------------------------- |
| 二进制 | BINARY(M)    | 固定占用 M 字节，M≤255                                     | 固定长度二进制串，对标 CHAR，存储原始二进制字节，不做字符集转码 | 固定长度密钥、硬件设备标识码、短二进制哈希值 |
| 二进制 | VARBINARY(M) | 实际二进制数据字节 + 1~2 字节长度标识，整体上限 65535 字节 | 可变长二进制串，对标 VARCHAR，按需占用存储空间               | 不定长加密密文、零散二进制数据包             |
| BLOB   | TINYBLOB     | 数据 + 1 字节头部，最大 255 字节                           | 最小容量二进制大对象                                         | 图标缩略图、小型二进制配置文件               |
| BLOB   | BLOB         | 数据 + 2 字节头部，最大 65535 字节                         | 标准容量二进制大对象                                         | 小尺寸图片、文件片段、短二进制附件           |
| BLOB   | MEDIUMBLOB   | 数据 + 3 字节头部，最大 16777215 字节                      | 中大容量二进制大对象                                         | 高清图片、普通 PDF 文档、中等压缩包          |
| BLOB   | LONGBLOB     | 数据 + 4 字节头部，最大 4294967295 字节                    | 超大容量二进制大对象                                         | 原图、短视频、大型安装包、完整压缩文件       |

 **补充知识点**

1. **BLOB 不推荐存大图 / 大文件**：生产环境一般只存文件路径，文件放服务器 / 对象存储，数据库只存 URL，减少库体积、提升查询性能；
2. BINARY/VARBINARY 和 CHAR/VARCHAR 本质区别：前者**按二进制字节比对**，后者按字符集编码比对，不受字符集排序规则影响。



## **列属性介绍**

| 属性           | 简要说明           | 示例                                        | 使用场景         | 适用类型 |
| -------------- | ------------------ | ------------------------------------------- | ---------------- | -------- |
| NOT NULL       | 非空，必填         | name varchar(20) NOT NULL                   | 账号、手机号必填 | 全部     |
| DEFAULT        | 设置默认值         | status tinyint DEFAULT 1                    | 状态默认启用     | 全部     |
| AUTO_INCREMENT | 自增 + 1           | id int AUTO_INCREMENT                       | 主键编号         | 数值     |
| PRIMARY KEY    | 主键 (唯一 + 非空) | id int PRIMARY KEY                          | 数据唯一标识     | 全部     |
| UNIQUE         | 字段值唯一         | phone char(11) UNIQUE                       | 手机号不能重复   | 全部     |
| UNSIGNED       | 无符号、无负数     | age tinyint UNSIGNED                        | 年龄、库存       | 数值     |
| ZEROFILL       | 数字前置补 0       | num int(4) ZEROFILL                         | 业务编号         | 数值     |
| COMMENT        | 字段注释           | name varchar (20) COMMENT ' 姓名'           | 字段备注说明     | 全部     |
| CHARSET        | 字段字符集         | name varchar(20) CHARSET utf8mb4            | 单独指定编码     | 字符     |
| COLLATE        | 排序规则           | name varchar(20) COLLATE utf8mb4_unicode_ci | 字符串排序比对   | 字符     |

完整建表示例（融合全部属性）

```SQL
CREATE TABLE `user` (
  id INT UNSIGNED ZEROFILL AUTO_INCREMENT PRIMARY KEY COMMENT '用户主键ID',
  username VARCHAR(30) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录用户名',
  password CHAR(32) CHARSET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '密码(二进制区分大小写)',
  phone CHAR(11) UNIQUE NOT NULL COMMENT '手机号码',
  status TINYINT UNSIGNED DEFAULT 1 COMMENT '账号状态:1正常,0禁用',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  remark TEXT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用户备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_unicode_ci COMMENT='用户信息主表';


-- 关键补充要点
字符集 / 排序规则：只针对字符型字段生效，INT、DATE、BLOB等无法指定 CHARSET/COLLATE；
utf8mb4_bin：二进制排序，大小写严格区分，密码字段推荐使用；utf8mb4_unicode_ci：不区分大小写，常规姓名、地址使用；
生产规范：字符集统一在表设置 DEFAULT CHARSET，极少单独给字段指定字符集。

password CHAR(32) CHARSET utf8mb4 COLLATE utf8mb4_bin；
这里COLLATE utf8mb4_bin，控制的是：字符串比较时，区不区分大小写
对查询匹配有很大影响； Admin123 和 admin123 必须是两个不同密码！
utf8mb4_bin：按原始二进制字节对比，不仅区分大小写，还区分全角 / 半角、特殊符号，精准度最高，是密钥类首选。
```





# 索引管理及执行计划

## 索引底层算法介绍

```SQL
-- 什么是索引
  1）索引就好比一本书的目录，它能让你更快的找到自己想要的内容。
  2）让获取的数据更有目的性，从而提高数据库检索数据的性能。

2.索引底层算法介绍
	1)BTREE:B+树索引
	2)HASH：HASH索引
	3)FULLTEXT：全文索引
	4)RTREE：R树索引
	
MySQL 索引最核心、最主流的底层算法只有 2 个
1. B+ Tree （99% 索引都用它！）
2. Hash （偶尔用，极少）

B+tree 介绍
一棵 “多路平衡查找树”，专门为磁盘、为数据库设计的超级快查找结构。
B+ Tree 优点（必须记住）
查询超级快：几百万数据只需要 3~4 次查找
稳定：每次查询速度几乎一样
支持范围查询：
where id > 100
order by id
between and
这些只有 B+ Tree 能做！
适合磁盘存储：MySQL 就是靠它撑起来的
哪些索引用 B+ Tree？全部都是！
主键索引
唯一索引
普通索引
联合索引

B Tree 和 B+ Tree 区别
1. B Tree 结构
           [10,20]
          /    |    \
   [5,7] [12,15] [22,25]
特点：
每个节点存数据
叶子、非叶子都存数据
不适合范围查询

2. B+ Tree 结构（MySQL 使用）
           [10,20]
          /    |    \
   [5,7] [12,15] [22,25]
     |     |      |
[5,7] → [12,15] → [22,25] → 链表
特点：
只有叶子节点存真实数据
叶子节点用链表串起来
范围查询 / 排序 /like 超快
磁盘 IO 最少（MySQL 选它的原因）
总结：
B Tree：每个节点都存数据，不适合范围查询。
B+ Tree：只有叶子存数据，自带链表，范围 / 排序超快 → MySQL 唯一选择！


--  B树/B+树/B*树三者区别、分裂/合并、页(16KB)、树高(通常3~4层)
-- B Tree 与 B+Tree 与 B*Tree
B Tree 结构
特点：
每个节点存数据
叶子、非叶子都存数据
不适合范围查询

【B+Tree】
非叶子：只存键+子页指针
叶子：主键+整行数据 + 单向链表
空间利用率：50%
分裂：随时分裂
适用：MySQL InnoDB（主流）

【B*Tree】
非叶子：存键 + 双向链表
叶子：存数据 + 双向链表
空间利用率：66.7%
分裂：更少、更晚
适用：MyISAM、文件系统、部分数据库




-- 聚簇索引（主键索引）VS 普通索引 区别？
主键索引（聚簇）：叶子存整行数据
普通索引（二级）：叶子只存主键值，需要回表



Hash 索引（哈希索引） 它是什么？
把字段值算一个哈希值（key），直接定位数据。
哈希算法
name → 哈希值 → 指针指向数据
张三 → 0x123 → 数据行
李四 → 0x456 → 数据行
优点
等值查询 = 极速
where name='张三'

FULLTEXT 全文索引（用于：文章、内容搜索）
专门用来做 文章里搜关键词
SELECT * FROM article WHERE content LIKE '%数据库%';
普通索引用不了 % 开头 %，只有全文索引能做。

底层原理（画图）
文章内容：
"我在学习MySQL数据库，索引非常重要"
全文索引会自动分词：
我 → 文章1
学习 → 文章1
MySQL → 文章1
数据库 → 文章1
索引 → 文章1
重要 → 文章1

结构就是：关键词 → 对应文章 ID
关键词     |  文章ID
---------------------
数据库     →  1,5,9
索引       →  1,3,6
学习       →  2,4,8

3. 优点
搜文章、搜内容极快
支持 MATCH AGAINST 语法
比 LIKE '%关键词%' 快 100 倍
4. 缺点
只能用于 TEXT / VARCHAR
企业一般不用，都用 Elasticsearch（ES）

-- R-Tree 管二维（坐标、地图、区域） R-Tree 只有地图功能才用
-- RTREE：专门做地理位置查询； 地图、经纬度、地理位置




MySQL DBA / 高级开发必备索引知识清单
## 一、索引分类 & 建索引语法（实操必会）
#1 索引种类
- PRIMARY 主键索引(聚簇)、UNIQUE唯一、INDEX普通、联合索引、前缀索引、覆盖索引、FULLTEXT、SPATIAL(R树)
#2 DDL语法
# 创建/删除/修改索引
ALTER TABLE xxx ADD [PRIMARY/UNIQUE/INDEX] idx_xxx(col1,col2);
DROP INDEX idx_xxx ON tbl;
# 前缀索引：col(n)、分区索引、函数索引(MySQL8.0+)

## 二、底层数据结构（原理面试核心）
#1 InnoDB默认BTREE(B+Tree)
# B树/B+树/B*树三者区别、分裂/合并、页(16KB)、树高(通常3~4层)
#2 聚簇&二级索引核心
- 聚簇索引：叶子=整行数据；二级索引：叶子=主键id、回表
- 覆盖索引：不需要回表，查询字段全部在索引列内
#3 Hash索引(Memory引擎)：等值快、不支持范围/排序/like前缀
#4 RTree：空间地理POINT/POLYGON；FullText分词索引

## 三、联合索引：最左前缀法则（优化重中之重）
#1 生效规则：联合(a,b,c)
where a=?               ✅走索引
where a=? and b=?       ✅
where a=? and b=? and c ✅
where b=?               ❌失效
#2 失效场景：
范围条件(> < between like%)右边列索引失效
例：idx(a,b,c) where a=10 and b>20 and c=30 → c不走索引
#3 隐式转换导致索引失效(字符串不加引号、字段类型不一致)
-- phone char(11) 建唯一索引 UNI
-- ① 正确：加引号，走索引
explain select * from user where phone='168';
-- ② 错误：纯数字不带引号，隐式转换，索引失效
explain select * from user where phone=168;

## 四、SQL优化+执行计划explain（日常排错）
# explain关键字段：type/key/key_len/rows/Extra
# type性能排序：system>const>eq_ref>ref>range>index>ALL(全表扫描最差)
- key：实际使用索引名；key_len：索引占用字节(判断联合索引用到几个字段)
- Extra:Using filesort(文件排序)、Using temporary(临时表)、Using index(覆盖索引)
# 优化准则
1. 避免索引失效：!=、is not null、%xxx前置模糊查询
2. 索引选择性(Cardinality)：基数越高索引越优
3. 不要滥用索引：增删改会维护索引，大字段/text不建常规索引

## 五、高阶进阶（资深DBA）
#1 索引物理层面
InnoDB页结构、页分裂/页合并、索引碎片、OPTIMIZE TABLE优化碎片
#2 特殊索引
函数索引、降序索引、不可见索引(invisible)、分区表索引
#3 生产规范
1. 主键推荐自增int(减少页分裂)，禁用随机字符串做主键
2. 单表索引不宜过多(建议≤5个)
3. 超长varchar使用前缀索引，计算最优前缀长度
#4 慢SQL排查：慢日志+explain+索引裁剪
```



## 索引管理

```sql
3.索引管理
	索引建立在表的列上(字段)的。
	在where后面的列建立索引才会加快查询速度。
	pages<---索引（属性）<----查数据。
	
● 1、索引分类：
主键索引
普通索引*****
唯一索引

-- 测试数据
CREATE TABLE `user` (
  `id` int(10) unsigned zerofill NOT NULL AUTO_INCREMENT COMMENT '用户主键ID',
  `username` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录用户名',
  `password` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '密码(二进制区分大小写)',
  `phone` char(11) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '手机号码',
  `status` tinyint(3) unsigned DEFAULT '1' COMMENT '账号状态:1正常,0禁用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `remark` text COLLATE utf8mb4_unicode_ci COMMENT '用户备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户信息主表';     

insert into user(username,password,phone,status,create_time,remark)\
values('lisi','****','123',1,NOW(),"YYYYY"),\
('wangwu','****','167',1,NOW(),"eeee"),
('liuliu','****','168',1,NOW(),"rr");

-- 不小心删除了username字段 ，添加回来
-- ALTER TABLE user ADD username varchar(30) NOT NULL COMMENT '登录用户名' AFTER id;

2、添加索引：
#创建索引
-- alter table test add index index_name(name);
alter table user add index index_name(username);
#创建索引
-- create index 索引名 on 表名(字段名);
create index username on user(username);
#查看索引
-- desc table;
desc user;
#显示结果
Key 显示	全称	含义
PRI	PRIMARY	主键索引
UNI	UNIQUE	唯一索引
MUL	INDEX	普通索引 / 联合索引
(空)	无	没有索引

#查看索引
-- show index from table;
show index from user;
# show index from user; 13列极简解释
Table          索引所属表名
Non_unique     0=唯一索引(主键/UNI) 1=普通索引(MUL)
Key_name       索引名称(PRIMARY=主键)
Seq_in_index   联合索引字段顺序(单列=1)
Column_name    索引字段名
Collation      排序方式(A=升序)
Cardinality    索引基数(值越多索引效果越好)
Sub_part       前缀索引长度(NULL=全字段索引)
Packed         索引压缩方式(一般NULL)
Null           字段是否允许NULL(空=不允许)
Index_type     索引类型(默认BTREE=B+树)
Comment        字段注释
Index_comment  索引注释

#删除索引
-- alter table 表名 drop key 索引名;
alter table user drop key index_name;
alter table user drop key username;
DROP INDEX idx_xxx ON tbl;
#添加主键索引（略）
ALTER TABLE user ADD PRIMARY KEY (id);

#添加唯一性索引
alter table 表明 add unique key 索引名字(字段名);
alter table user add unique key username(username);

#查看表中数据行数
select count(*) as 总行数 from user;
#查看去重数据行数    # distinct 去重复 
-- insert into user values(null,'liuliu','***','168',NOW(),'RR');  --添加要给相同名字的
select count(distinct name) from city; 

--  前缀索引 避免对大列建索引,如果有，就使用前缀索引
-- username(3) 表示前三个字符
alter table user add index username(username(3));
  
-- 联合索引；  多个字段建立一个索引
  where a.女生 and b.身高 and c.体重 and d.身材好 #查询条件
  index(a,b,c) #联合索引顺序 
  特点：前缀生效特性
  a,ab,ac,abc,abcd 可以走索引或部分走索引
  b bc bcd cd c d ba ... 不走索引
-- 原则：把最常用来做为条件查询的列放在最前面
alter table user add index idx_up(username,phone);

-- 覆盖索引  Extra有Using index #查询的结果全部都市索引上，不需要回表查询
explain select id,username from user where username='liuliu';
# 需要手动单独建索引（物理真实存在，show index可查到）
1.普通单列索引  add index idx(col)
2.唯一索引      add unique index idx(col)
3.主键索引      add primary key(col)
4.联合索引      add index idx(col1,col2,col3)
5.前缀索引      add index idx(col(3))
6.全文/空间索引 add fulltext/spatial index

# 不用建索引，只是查询现象（逻辑概念，无实体索引）
覆盖索引：依托上面已建好的任意B+索引，SQL查询字段全落在索引列→触发Using index、免回表
```





# explain

```SQL
explain select name,countrycode from city where id=1;

3306 [world]>explain select name,countrycode from city where id=1 \G;
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: city
         type: const
possible_keys: PRIMARY
          key: PRIMARY
      key_len: 4
          ref: const
         rows: 1
        Extra: NULL
1 row in set (0.00 sec)

# 逐条解析 \G 结果
id:1                 # 单表简单SQL，查询编号1
select_type:SIMPLE   # 无子查询、无union，普通简单查询
table:city           # 查询目标表city
type:const           # 主键精准等值，常量查询，最优级别，仅定位1行
possible_keys:PRIMARY# 优化器可选索引：主键索引
key:PRIMARY          # 实际执行使用主键索引；   实际使用索引名
key_len:4            # id为int(4字节)，索引占用4字节 → 判断联合索引用了几个字段  
ref:const            # 索引匹配常量：where id=1；索引匹配来源；三种取值：const、字段名、func
rows:1               # 预估扫描仅1行， 越少越好
Extra:NULL           # 无额外操作：无回表、无排序、无临时表

-- select_type 查询类型
类型	           说明                        示例 SQL
SIMPLE	        简单查询，无子查询、无 union   
-- EXPLAIN SELECT name FROM city WHERE id=1;
PRIMARY	        最外层主SQL       
-- EXPLAIN SELECT name FROM city WHERE id=(SELECT MAX(id) FROM city);
SUBQUERY	    WHERE里子查询    
-- EXPLAIN SELECT * FROM city WHERE countrycode=(SELECT code FROM country LIMIT 1);
DERIVED			FROM里派生临时表 (子查询生成临时表)  
-- EXPLAIN SELECT a.* FROM (SELECT * FROM city LIMIT 10) a;
UNION			union后面的 SQL    
-- EXPLAIN SELECT id FROM city WHERE id<10 UNION SELECT id FROM city WHERE id>100;
UNION RESULT	union合并结果集   
-- 同上 UNION 语句最后一行自动生成 UNION RESULT

-- type【重中之重：访问类型，性能优先级从优→劣】 常见类型
system > const > eq_ref > ref > range > index > ALL
# system：系统表，仅1行数据，极罕见
# const：主键/唯一索引精准匹配，常量，仅匹配1行(=固定值)
# eq_ref：关联查询主键/唯一索引，关联每条只匹配1行（多表join最优）
# ref：普通索引等值匹配，命中多行（最常用）
# range：索引范围查询 > < between in like '前缀%'，用到索引范围段
# index：全索引树扫描（只扫索引不回表，优于全表）
# ALL：全表扫描【重点优化目标】
生产底线：至少 range/ref，杜绝 ALL

-- 英文单词
eq_ref
EQ = Equal（等值） + ref = reference（索引引用）
全称：Equal Reference

-- Extra 
# 1.Using index ✅ 覆盖索引，无回表，最优
# 2.Using filesort ❌ 文件排序：无法用索引排序，需要额外排序(ORDER BY没走索引)
# 3.Using temporary ❌ 临时表：GROUP BY/UNION创建临时内存/磁盘表
# 4.Using where：存储引擎取数后在server层过滤(正常现象)
# 5.Using join buffer：join没走索引，使用连接缓冲区
# 6.Impossible where：where条件永远不成立，无结果

如果出现Using filesort请检查order by ,group by ,distinct,join 条件列上没有索引
explain select * from city where countrycode='CHN' order by population;
当order by语句中出现Using filesort，那就尽量让排序值在where条件中出现	
explain select * from city where population>30000000 order by population;
		select * from city where population=2870300 order by population;




-- type详细介绍
## 1.system（最优，极少出现）
# 表只有1条数据、系统元数据表，MyISAM/Memory常见
# 场景：系统表、表数据总行数=1
## 2.const（主键/唯一索引精准等值 =常量，你刚才 id=1 就是）
# 条件：主键/UNIQUE索引 等值查询 where id=1
# 特征：优化器预转为常量，rows=1
## 3.eq_ref（多表JOIN顶级）
# JOIN时：被关联字段是主键/唯一索引，每条匹配唯一一行
# 示例：city JOIN country ON city.countrycode=country.code（code主键）
# 一一对应，每条只命中1行
## 4.ref（普通索引等值，开发最常用）
# 普通单列/联合索引等值匹配，可命中多行
# where username='test'  username建普通索引
-- ## 5.ref_or_null（ref变种）
# 索引字段等值+可查NULL：where phone='138' or phone is null
# 字段建有索引且允许NULL
-- ## 6.fulltext（全文索引专属）
# MATCH(col) AGAINST('关键词') 使用全文索引
## 7.range（索引范围查询）
# > < >= <= between in() like '前缀%'
# where id>100 and id<200
# 走索引区间扫描，优于全表
## 8.index（整棵索引树全扫，比ALL快）
# 只访问索引字段（覆盖索引但全索引遍历），不走聚簇数据
# select id from user; id是主键，遍历整棵主键索引
## 9.ALL（全表扫描，最差，优化重点）
# 没任何可用索引，从头到尾扫整表数据
# where status=1 status无索引 → type=ALL


# 了解
-- NULL：MySQL在优化过程中分解语句，执行时甚至不用访问表或索引，例如从一个索引列里选取最小值可以通过单独索引查找完成。
-- explain select * from city where id=1000000000000000000000000000;
-- explain select * from city where 1=2; # 同样Impossible WHERE，type全NULL







```

mysql5.7官方文件 explain连接类型介绍

```BASH
EXPLAIN 连接类型说明 # https://dev.mysql.com/doc/refman/5.7/en/explain-output.html
EXPLAIN 执行结果中的type字段用于描述数据表的关联方式；在 JSON 格式的输出结果里，该信息对应access_type字段的值。下面按性能从优到劣依次介绍各类连接类型：
1. system
数据表仅有 1 行数据（系统内置系统表），是const类型的特殊场景。
2. const
数据表最多只匹配到一行数据，在 SQL 语句执行初期就完成读取。由于数据唯一，优化器可将该行字段值视作常量参与后续计算；该类型仅读取一次数据表，查询速度极快。
使用条件：使用等值条件完整匹配主键（PRIMARY KEY）或唯一索引（UNIQUE）所有索引字段，示例 SQL 中TBL_NAME表会被识别为 const 表：
sql
SELECT * FROM TBL_NAME WHERE PRIMARY_KEY=1;
SELECT * FROM TBL_NAME WHERE PRIMARY_KEY_PART1=1 AND PRIMARY_KEY_PART2=2;
3. eq_ref
关联前表的每一条记录，本表仅匹配返回一行数据；除system、const外，这是性能最优的关联类型。
使用条件：关联条件完整命中主键或非空唯一索引（UNIQUE NOT NULL）的全部索引字段，使用=做等值比对。对比值可以是常量，也可以是前面关联表的字段。
示例中REF_TABLE采用 eq_ref 关联：
sql
SELECT * FROM REF_TABLE,OTHER_TABLE WHERE REF_TABLE.KEY_COLUMN=OTHER_TABLE.COLUMN;
SELECT * FROM REF_TABLE,OTHER_TABLE WHERE REF_TABLE.KEY_COLUMN_PART1=OTHER_TABLE.COLUMN AND REF_TABLE.KEY_COLUMN_PART2=1;
4. ref
关联前表每条数据时，本表匹配所有符合索引条件的数据行。
使用条件：仅用到联合索引最左前缀，或索引并非主键 / 唯一索引（无法通过索引锁定单行）；使用=、<=>等值匹配索引列。若匹配结果行数很少，ref 属于高效关联类型。
示例：
sql
SELECT * FROM REF_TABLE WHERE KEY_COLUMN=EXPR;
SELECT * FROM REF_TABLE,OTHER_TABLE WHERE REF_TABLE.KEY_COLUMN=OTHER_TABLE.COLUMN;
SELECT * FROM REF_TABLE,OTHER_TABLE WHERE REF_TABLE.KEY_COLUMN_PART1=OTHER_TABLE.COLUMN AND REF_TABLE.KEY_COLUMN_PART2=1;
5. fulltext
借助全文索引（FULLTEXT）完成表关联查询。
6. ref_or_null
逻辑和 ref 基本一致，额外针对索引字段为NULL的数据做补充检索；多用于子查询优化。
示例 SQL 会触发 ref_or_null：
sql
SELECT * FROM REF_TABLE WHERE KEY_COLUMN=EXPR OR KEY_COLUMN IS NULL;
7. index_merge
启用索引合并优化，一条 SQL 同时使用多个独立索引分别检索再合并结果；结果集key字段会列出所有用到的索引，key_len标注各索引使用的最长索引段。
8. unique_subquery
优化IN格式子查询，子查询字段是主键时，用索引精准查找替换原 IN 子查询逻辑，替代部分场景下的 eq_ref：
sql
VALUE IN (SELECT PRIMARY_KEY FROM SINGLE_TABLE WHERE SOME_EXPR)
9. index_subquery
与 unique_subquery 类似，适配非唯一索引的 IN 子查询优化：
sql
VALUE IN (SELECT KEY_COLUMN FROM SINGLE_TABLE WHERE SOME_EXPR)
10. range
通过索引检索指定区间内的数据，仅扫描索引命中范围数据，优于全表扫描。结果key字段标识所用索引，key_len记录使用的索引长度，ref字段为 NULL。
可用运算符：=、<>、>、>=、<、<=、IS NULL、<=>、BETWEEN、LIKE、IN()。
示例：
sql
SELECT * FROM TBL_NAME WHERE KEY_COLUMN = 10;
SELECT * FROM TBL_NAME WHERE KEY_COLUMN BETWEEN 10 and 20;
SELECT * FROM TBL_NAME WHERE KEY_COLUMN IN (10,20,30);
SELECT * FROM TBL_NAME WHERE KEY_PART1 = 10 AND KEY_PART2 IN (10,20,30);
11. index
和全表扫描ALL逻辑相近，但遍历的是索引树，分两种场景：
覆盖索引（Using index）：查询所需全部字段都在索引中，仅扫描索引即可拿到全部数据，不再回表读取原数据，性能远优于全表扫描，Extra 字段显示Using index；
索引排序遍历：按索引顺序遍历索引、再回表读取完整行数据，Extra 字段不会出现 Using index。
触发条件：查询需要的字段全部隶属于同一个索引。
12. ALL
全表扫描，遍历整张数据表；在前表非 const 的场景下性能极差，是需要优先优化的关联类型。
优化方案：添加合适索引，通过常量或关联前置表字段过滤数据，避免全表扫描。
补充说明
性能优先级（从优→劣）：
system > const > eq_ref > ref > fulltext > ref_or_null > index_merge > unique_subquery > index_subquery > range > index > ALL

```





# 建立索引的原则（规范）
````SQL
# 索引创建精简6条规范
## 1.优先唯一/主键索引
# 唯一值字段建唯一/主键，查询效率最优；重复多改用联合索引

## 2.排序分组字段建索引
# order by/group by/distinct字段建索引，规避文件排序Using filesort

## 3.高频查询字段建索引
# where常用字段，基数高(重复少)单列索引；重复量大改用联合索引

## 4.超长字符用前缀索引
# 长varchar，取前N字符建前缀索引，节省空间

## 5.严控索引总量
# 索引过多占用磁盘，增删改开销变大，单表索引不宜过多

## 6.定期清理无效索引
# 废弃、极少使用索引及时删除，降低DML维护成本
	

# 8类索引失效精简总结 
## 1.无查询条件/条件无索引 → 全表扫描
# select * from tbl; 大数据严禁全表，加where/limit+索引

## 2.筛选数据超25% → 优化：limit分页，海量数据迁移Redis

## 3.频繁DML导致索引统计失真
# 解决：重建索引/analyze table更新统计信息

## 4.索引字段做运算、套函数(+-*/、函数)
# 错：where id-1=9  对：where id=10

## 5.隐式字段类型转换(字符串字段查数字)
# telnum varchar查数字120失效，加引号'120'生效

## 6.<>、not in通常失效；in/or建议拆分union all
# >/</in返回大量数据也会放弃索引，建议搭配limit

## 7.like通配符%前置失效(%abc)；后缀%(abc%)可走range
# 全文模糊检索改用ES

## 8.联合索引违背最左前缀
# idx(money,age,sex)，跳过首列money直接查age/sex → 索引失效






# 8类索引失效详细版本

1.没有查询条件，或者查询条件没有建立索引
#全表扫描
select * from table;
select  * from tab where 1=1;
在业务数据库中，特别是数据量比较大的表,是没有全表扫描这种需求。
	1）对用户查看是非常痛苦的。
	2）对服务器来讲毁灭性的。
	3）SQL改写成以下语句：

```
#情况1
#全表扫描
select * from table;
#需要在price列上建立索引
select  * from tab  order by  price  limit 10;
#情况2
#name列没有索引
select * from table where name='zhangsan'; 
1、换成有索引的列作为查询条件
2、将name列建立索引
```

2.查询结果集是原表中的大部分数据，应该是25％以上
explain select * from city where population>3000 order by population;
	1）如果业务允许，可以使用limit控制。
	2）结合业务判断，有没有更好的方式。如果没有更好的改写方案就尽量不要在mysql存放这个数据了，放到redis里面。

3.索引本身失效，统计数据不真实
索引有自我维护的能力。
对于表内容变化比较频繁的情况下，有可能会出现索引失效。
重建索引就可以解决

4.查询条件使用函数在索引列上或者对索引列进行运算，运算包括(+，-，*等)

#例子
错误的例子：select * from test where id-1=9; 
正确的例子：select * from test where id=10;

5.隐式转换导致索引失效.这一点应当引起重视.也是开发中经常会犯的错误
create table test (id int ,name varchar(20),telnum varchar(10));
insert into test values(1,'zs','110'),(2,'l4',120),(3,'w5',119),(4,'z4',112);
explain select * from test where telnum=120;
alter table test add index idx_tel(telnum);
explain select * from test where telnum=120;
explain select * from test where telnum=120;
explain select * from test where telnum='120';

6． <> ，not in 不走索引
select * from tab where telnum <> '1555555';
explain select * from tab where telnum <> '1555555';
单独的>,<,in 有可能走，也有可能不走，和结果集有关，尽量结合业务添加limit
or或in尽量改成union all
EXPLAIN  SELECT * FROM teltab WHERE telnum IN ('110','119');

#改写成
EXPLAIN SELECT * FROM teltab WHERE telnum='110'
UNION ALL
SELECT * FROM teltab WHERE telnum='119'

7．like "%_" 百分号在最前面不走

#走range索引扫描

EXPLAIN SELECT * FROM teltab WHERE telnum LIKE '31%';

#不走索引
EXPLAIN SELECT * FROM teltab WHERE telnum LIKE '%110';

%linux%类的搜索需求，可以使用Elasticsearch -------> ELK

8.单独引用联合索引里非第一位置的索引列
CREATE TABLE t1 (
id INT,
NAME VARCHAR(20),
age INT ,
sex ENUM('m','f'),
money INT);

ALTER TABLE t1 ADD INDEX t1_idx(money,age,sex);
DESC t1
SHOW INDEX FROM t1

#走索引的情况测试
EXPLAIN SELECT NAME,age,sex,money FROM t1 WHERE money=30 AND age=30  AND sex='m';

#部分走索引
EXPLAIN SELECT NAME,age,sex,money FROM t1 WHERE money=30 AND age=30;
EXPLAIN SELECT NAME,age,sex,money FROM t1 WHERE money=30  AND sex='m'; 

#不走索引
EXPLAIN SELECT  NAME,age,sex,money FROM t1 WHERE age=20
EXPLAIN SELECT NAME,age,sex,money FROM t1 WHERE age=30 AND sex='m';
EXPLAIN SELECT NAME,age,sex,money FROM t1 WHERE sex='m';



````




# 存储引擎  
```BASH
存储引擎 = MySQL 数据表的数据读写管理器
MySQL 服务是外壳，一张表选用哪个引擎，就由它负责：存文件、读数据、加锁、事务、索引落地。
特点：单库不同表可以使用不同存储引擎
# 建表指定引擎
CREATE TABLE t(...) ENGINE=InnoDB;
# 查看当前默认引擎
show variables like 'default_storage_engine';

# MySQL主流存储引擎:

## 1.InnoDB(默认，生产首选)
# 特性
1.支持事务、ACID、行级锁、MVCC、外键
2.聚簇索引，数据和索引捆绑
3.崩溃自动恢复，支持热备份
# 适用：增删改频繁、业务数据表

## 2.MyISAM(老项目遗留)
# 特性
1.不支持事务、外键，表级锁
2.非聚簇，索引与数据分开存储
3.查询速度快，占用资源少
# 缺点：宕机易丢数据
# 适用：静态历史数据、只查不改

## 3.Memory(Heap内存引擎)
# 全数据存内存，断电数据清空，表级锁
# 适用：临时统计表、缓存临时数据，索引HASH/BTREE可选

## 4.Archive
# 高压缩存储，只支持插入、查询，无索引
# 适用：海量日志归档

## 5.CSV
# 文件为csv文本，无内置索引，方便外部程序读写


还可以使用第三方存储引擎.
MySQL当中插件式的存储引擎类型

MySQL的两个分支
	- perconaDB
	- mariaDB


# 查看当前支持的引擎
show engines;
# 查看innodb的表有哪些
select table_schema,table_name,engine from information_schema.tables where engine='innodb';
# 查看myisam的表有哪些
select table_schema,table_name,engine from information_schema.tables where engine='myisam';


## innodb和myisam的区别
物理上区别:
#查看所有user的文件
[root@db01 mysql]# ll user.*
-rw-rw---- 1 mysql mysql 10684 Mar  6  2017 user.frm
-rw-rw---- 1 mysql mysql   960 Aug 14 01:15 user.MYD
-rw-rw---- 1 mysql mysql  2048 Aug 14 01:15 user.MYI
#进入word目录
[root@db01 world]# cd /application/mysql/data/world/
#查看所有city的文件
[root@db01 world]# ll city.*
-rw-rw---- 1 mysql mysql   8710 Aug 14 16:23 city.frm
-rw-rw---- 1 mysql mysql 688128 Aug 14 16:23 city.ibd
```



## innodb存储引擎的简介

```SQL
在MySQL5.5版本之后，默认的存储引擎，提供高可靠性和高性能。
优点:
01）事务安全（遵从 ACID）
02）MVCC（Multi-Versioning Concurrency Control，多版本并发控制）
03）InnoDB 行级别锁定
04）Oracle 样式一致非锁定读取
05）表数据进行整理来优化基于主键的查询
06）支持外键引用完整性约束
07）大型数据卷上的最大性能
08）将对表的查询与不同存储引擎混合
09）出现故障后快速自动恢复
10）用于在内存中缓存数据和索引的缓冲区池

innodb核心特性
重点:
	MVCC
	事务
	行级锁
	热备份
	Crash Safe Recovery（自动故障恢复）

InnoDB 五大核心特性精简详解
1. 事务 (ACID)
满足原子、一致性、隔离性、持久性
原子：一个事务要么全成功 commit，要么全失败 rollback（转账 A 扣钱 B 加钱，失败两边回滚）
一致：事务前后数据合法，约束不被破坏；
隔离：多事务互不干扰，靠隔离级别控制脏读 / 不可重复读 / 幻读
持久：commit 后数据永久落地磁盘，宕机不丢失
2.MVCC 多版本并发控制
快照读不加锁，实现读写并发
每行数据隐藏字段：trx_id(修改事务 ID)、roll_pointer(指向 undo 历史版本)
普通select= 快照读：读取 undo 里历史版本，读不阻塞写、写不阻塞读
update/delete/insert = 当前读，加行锁
作用：大幅提升并发，是 InnoDB 高并发基石。
3. 行级锁（Record Lock+Gap+Next-key）
行锁：只锁定被修改的单行，其他行可正常读写，并发高（对比 MyISAM 全表锁）
主键精准等值：加 Record 行锁；范围查询加临键锁 (Next-key)+ 间隙锁 (Gap)，防止幻读
无索引→降级为表锁
4.Crash Safe Recovery 崩溃自动恢复（依靠 redo+undo）
redo 日志：崩溃重做：事务提交先写 redo，宕机重启，通过 redo 把已提交数据刷入磁盘，保证持久化
undo 日志：回滚 + MVCC：未提交事务，重启用 undo 回滚撤销数据
断电、宕机重启自动修复数据，不会损坏表、丢失已提交数据。
5. 热备份
数据库不停机、不锁表，在线备份数据
mysqldump 加 --single-transaction：利用 MVCC 快照，全库一致性备份，业务正常读写
XtraBackup 物理热备：拷贝 ibd 文件，在线增量备份
MyISAM 需要锁表冷备，InnoDB 支持在线热备，不影响线上业务。
一句话总结
事务保证数据逻辑安全，MVCC + 行锁拉高并发，redo/undo 实现宕机自愈，MVCC 支撑在线热备。





- 查看存储引擎 
  select @@default_storage_engine;

- 使用show 确认每个表的存储引擎
  show create table city\G 
  show table status like 'CountryLanguage'\G 

- 使用 INFORMATION_SCHEMA 确认每个表的存储引擎
#查看表的存储引擎
SELECT TABLE_NAME, ENGINE FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='city' AND TABLE_SCHEMA='world'\G

## 存储引擎的设置
#在配置文件的[mysqld]标签下添加
[mysqld]
default-storage-engine=<Storage Engine>
#在MySQL命令行中临时设置
SET @@storage_engine=<Storage Engine>
#建表的时候指定存储引擎
CREATE TABLE t (i INT) ENGINE = <Storage Engine>;
```









# Innodb存储引擎——表空间介绍

## 一、基础概念

**表空间 (Tablespace)：InnoDB 最高层逻辑存储容器**，物理对应磁盘文件（`.ibdata`/`.ibd`），向下拆分为：**段 Segment → 区 Extent → 页 Page（默认 16KB，最小 IO 单元）**

- 页：16KB，B + 树节点、行数据存放单位
- 区：64 页 = 1MB，磁盘空间批量分配单位
- 段：一张索引 = 2 段（叶子段 + 非叶子段），由多个区组成

> InnoDB 一共**5 大类表空间**，整理表格如下：



| 表空间类型            | 物理文件名                   | 存储内容                                                     | 关键特点 & 优缺点                                            | 配置 / 版本                                    |
| :-------------------- | :--------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- | :--------------------------------------------- |
| **系统表空间**        | ibdata1（可扩展 ibdata2...） | 数据字典、Change Buffer、Doublewrite、旧版 Undo；未开独立表空间时存全库表 + 索引 | ✅必启、全局共享❌**空间只增不减，删表不释放磁盘给 OS**；文件膨胀难回收 | innodb_data_file_path 配置文件大小             |
| **独立表空间 (单表)** | 库名 / 表名.ibd              | 当前单张表**全部数据 + 二级索引**                            | ✅DROP/TRUNCATE 直接删文件、释放磁盘；支持单表迁移、表压缩、透明加密❌表多则小文件过多 | `innodb_file_per_table=ON`(5.6 + 默认开启)     |
| **通用表空间**        | 自定义 xxx.ibd               | 多张不同表共用一个 ibd                                       | 手动创建、多表聚合，适合小表汇总，减少零散小文件             | `CREATE TABLESPACE xxx ADD DATAFILE 'xxx.ibd'` |
| **Undo 回滚表空间**   | undo_001、undo_002...        | Undo 日志（事务回滚、MVCC 快照读）                           | 8.0 独立拆分、可动态扩容缩容、在线收缩空间；5.7 及以前 Undo 存在 ibdata1 里 | innodb_undo_tablespaces 控制数量               |
| **临时表空间**        | ibtmp1                       | 临时表、group by/join 排序中间临时数据                       | **MySQL 重启自动清空重建**；运行中自动扩容，不持久化落地数据 | innodb_temp_data_file_path                     |

## 二、重点参数说明

```BASH
1. innodb_file_per_table（生产默认 ON）
-- 查看状态
show variables like 'innodb_file_per_table';
ON：新建表生成单独.ibd，删除表立刻归还磁盘；OPTIMIZE TABLE可回收碎片空间
OFF：所有表数据全写入 ibdata1，无论删多少数据，ibdata1 体积不会变小（经典磁盘暴涨坑）

2. 系统表空间 ibdata1 配置示例（my.cnf）
# 初始1G，自动扩展最大10G
innodb_data_file_path=ibdata1:1G:autoextend:max:10G

三、日常运维常用 SQL
-- 查看所有表空间文件
SELECT FILE_NAME,TABLESPACE_NAME FROM INFORMATION_SCHEMA.FILES;

-- 把已有表迁移到通用表空间
ALTER TABLE test_tbl TABLESPACE ts_common;

-- 回收独立表空间碎片
OPTIMIZE TABLE test_tbl;

四、选型总结
线上业务：默认独立表空间（innodb_file_per_table=ON），方便空间回收、单表备份迁移
大量零散小表：创建通用表空间，多表合并存储，减少海量小文件
Undo：8.0 默认独立 undo 文件，避免 ibdata1 无限膨胀



3306 [world]>show variables like 'innodb_file_per_table';  
+-----------------------+-------+
| Variable_name         | Value |
+-----------------------+-------+
| innodb_file_per_table | ON    |
+-----------------------+-------+

# 每个表单独一个文件
[root@db world]# ll /application/mysql/data/world/
total 1000
-rw-rw---- 1 mysql mysql   8710 Jun  5 04:39 city.frm  
-rw-rw---- 1 mysql mysql 573440 Jun  5 04:39 city.ibd
。。。。。。
-rw-rw---- 1 mysql mysql     67 Jun  5 04:39 db.opt

当前环境：独立表空间开启，三张表真实数据全部在各自.ibd，
ibdata1（系统表空间）不再存业务数据，只存：数据字典、DoubleWrite、ChangeBuffer、Undo 日志（5.7 及以下 undo 在 ibdata，8.0undo 独立文件）。
如果innodb_file_per_table=OFF：没有.ibd 文件，三张表的数据 + 索引全部写入 ibdata1/ibdata2，只保留 frm+db.opt，删表 ibdata 不会缩容。

-- city.frm
表结构元数据文件，和存储引擎无关：
1. 字段名、字段类型、长度、默认值、非空、主键约束
2. 字段字符集、注释、外键定义、表行格式
3. 普通索引(记录索引名，哪些字段创建的)、主键的定义元数据
不含任何真实行数据、索引数据
-- city.ibd
InnoDB 独立表空间文件（单表独占）：
1. 整张表所有行数据（聚集索引叶子）
2. 主键 + 全部二级索引（B + 树非叶子 + 叶子页）
3. MVCC 隐藏列（trx_id、roll_ptr）、事务多版本快照数据
4. 本表单表空间头、段 / 区管理页、Change Buffer 位图页
5. 空闲空间、碎片管理信息

-- db.opt	
库级配置文本文件：
记录当前world库默认字符集 + 排序规则 collation
示例内容：default-character-set=utf8mb4 / default-collation=utf8mb4_unicode_ci
新建表不指定字符集时，默认继承该配置
[root@db world]# cat db.opt
default-character-set=utf8mb4
default-collation=utf8mb4_general_ci



```





# Innodb核心特性——事务

ACID 四大特性

| 特性                | 说明                                                         |
| ------------------- | ------------------------------------------------------------ |
| **原子 Atomic**     | 事务是最小单元，**要么全成功 commit，要么全失败 rollback**，不能半截提交。例：转账 A 扣钱、B 加钱，任意出错两边全部回滚 |
| **一致 Consistent** | 事务执行前后，数据约束合法（主键唯一、外键、字段非空），不会出现脏数据 |
| **隔离 Isolate**    | 多个事务并发互不干扰，由**4 种隔离级别**控制脏读 / 不可重复读 / 幻读 |
| **持久 Durable**    | `commit`提交后，数据永久落盘，宕机断电不丢失，依靠 redo 日志保障 |

```SQL
ACID 四者关系（重点，解开误区）
原子性 (A)：保证操作要么全成、全败，解决业务逻辑一致性（靠 undo 回滚实现）
隔离性 (I)：并发环境下，避免多个事务互相篡改，破坏一致性（锁 + MVCC）
持久性 (D)：提交成功的数据永久保存，宕机不会莫名丢失，保证一致性不被硬件故障破坏（redo）
一致性 (C)：最终结果要求，前面三者全部服务于 C
一致性就是：事务提交完毕，表数据既要符合字段、主键、外键等数据库规则，又符合业务算数 / 业务规则，不存在畸形、错乱、不合逻辑的数据。


- 事务自动提交
3306 [world]>show variables like 'autocommit';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| autocommit    | ON    |
+---------------+-------+

set autocommit=0; #临时关闭
#永久关闭
vim /etc/my.cnf 
[mysqld]
autocommit=0

-- 事务演示
-- 成功提交
create database demo charset utf8mb4;
use demo
create table stu(id int,name varchar(10),sex enum('f','m'),money int);
begin;
insert into stu(id,name,sex,money) values(1,'zhang3','m',100), (2,'zhang4','m',110);
commit;
-- 事务回滚
begin;
update stu set name='zhang3';
delete from stu;
rollback; 
select * from stu;

● 事务隐式提交情况
1）现在版本在开启事务时，不需要手工begin，只要你输入的是DML语句，就会自动开启事务。
2）有些情况下事务会被隐式提交
例如:
在事务运行期间，手工执行begin的时候会自动提交上个事务
在事务运行期间，加入DDL、DCL操作会自动提交上个事务
在事务运行期间，执行锁定语句（lock tables、unlock tables）
前提： autocommit=1（默认自动提交，单条 SQL 默认执行完立刻 commit）
3 类特殊 SQL：
LOCK TABLES / UNLOCK TABLES：隐式结束当前事务
LOAD DATA INFILE：DML 批量导入，受事务控制
SELECT ... FOR UPDATE：当前读、加行锁、开启隐式事务，不会自动提交

示例： 	
SET autocommit = 1;
CREATE TABLE t(id INT PRIMARY KEY,money INT);
INSERT INTO t VALUES(1,1000),(2,2000);

-- 1，SELECT ... FOR UPDATE
# 会话1
SET autocommit=1;
SELECT * FROM t WHERE id=1 FOR UPDATE; -- 锁住id=1，事务未提交
# 会话2
UPDATE t SET money=999 WHERE id=1; -- 阻塞等待
# 会话1执行提交，锁释放
COMMIT;

-- 2、LOCK TABLES 会强制提交正在运行的事务
SET autocommit=1;
START TRANSACTION;
UPDATE t SET money=111 WHERE id=1; -- 修改未提交

LOCK TABLES t WRITE; -- 触发隐式COMMIT，上面update直接落地，事务结束
# 现在t被加独占表锁，其他会话无法读写

UNLOCK TABLES; -- 释放表锁
规则：LOCK TABLES 是 DDL 类锁定语法，强制关闭现有事务

-- 3、LOAD DATA INFILE
-- 方式1：自动提交
SET autocommit=1;
LOAD DATA INFILE '/tmp/t.txt' INTO TABLE t; -- 导入完自动commit
-- 方式2：包裹事务可回滚
START TRANSACTION;
LOAD DATA INFILE '/tmp/t.txt' INTO TABLE t;
ROLLBACK; -- 导入数据全部撤销


```



## 事务日志redo基本功能
```BASH
1）Redo是什么？
	redo,顾名思义“重做日志”，是事务日志的一种。
2）作用是什么？
	在事务ACID过程中，实现的是“D”持久化的作用。
特性:WAL(Write Ahead Log)日志优先写
REDO：记录的是，内存数据页的变化过程

3）# Redo简化流程(WAL预写日志)
# update t1 set num=2 where num=1;
#1 数据页载入BufferPool内存
#2 内存修改页面：1→2，生成redo写入redo_buffer
#3 页面标记脏页，不立刻落地磁盘
# commit;
#1 redo_buffer数据刷入磁盘ib_logfile
#2 日志落盘成功，事务提交OK（数据页仍在内存）

# 后台
# checkpoint慢慢把脏页刷入ibd；日志文件循环覆盖

### redo数据实例恢复过程
如果此时服务器断电:
1)启动MySQL的过程中，读取redo log。(MySQL启动的很慢)
2)首先将数据页中的原数据1  加载到内存中。
3)将redolog中的修改过程，加载到内存中。
4)在内存中将数据修改(1改成2)。
5)写入磁盘。


[root@db world]# ll /application/mysql/data
total 176152
-rw-rw---- 1 mysql mysql       56 Jun  4 16:36 auto.cnf
-rw-rw---- 1 mysql mysql     5421 Jun  4 16:36 db.err
-rw-rw---- 1 mysql mysql        5 Jun  5 05:48 db.pid
drwx------ 2 mysql mysql       52 Jun  5 10:58 home
-rw-rw---- 1 mysql mysql 79691776 Jun  5 10:58 ibdata1
-rw-rw---- 1 mysql mysql 50331648 Jun  5 10:58 ib_logfile0  # redo.log 文件
-rw-rw---- 1 mysql mysql 50331648 Jun  4 16:36 ib_logfile1 
。。。。


3306 [world]>show variables like '%innodb_log%';
+-----------------------------+----------+
| Variable_name               | Value    |
+-----------------------------+----------+
| innodb_log_buffer_size      | 8388608  |
| innodb_log_compressed_pages | ON       |
| innodb_log_file_size        | 50331648 |
| innodb_log_files_in_group   | 2        |
| innodb_log_group_home_dir   | ./       |
+-----------------------------+----------+

# 1.innodb_log_buffer_size=8388608(8M)
# redo内存缓冲区,DML产生的redo先写到「log buffer 内存」;commit/缓冲区满/定时触发刷盘到磁盘redo文件
# 大写入业务调大 (32M/64M)，减少磁盘频繁刷写。

# 2.innodb_log_compressed_pages=ON
# 压缩表的数据变更写入redo，保障压缩表崩溃可恢复，默认不动
# 3.innodb_log_file_size=50331648(48M)
# 单个redo磁盘文件大小，太小频繁checkpoint、太大宕机恢复慢
# 单个文件上限：5.6/5.7 推荐 1G 以内；超大导入场景可设 512M~1G

# 4.innodb_log_files_in_group=2
# redo日志文件个数2个:ib_logfile0、ib_logfile1，循环覆写
# 不能设为 1，生产一般保持 2~4 个。

# 5.innodb_log_group_home_dir=./
# redo文件存放路径，./代表mysql数据目录





```



## 事务日志undo

```BASH
1）undo是什么？
undo,顾名思义“回滚日志”，是事务日志的一种。
2）作用是什么？
在事务ACID过程中，实现的是“A”原子性的作用。当然CI的特性也和undo有关

redo和undo的存储位置
#redo位置
[root@db01 data]# ll /application/mysql/data/
-rw-rw---- 1 mysql mysql 50331648 Aug 15 06:34 ib_logfile0
-rw-rw---- 1 mysql mysql 50331648 Mar  6  2017 ib_logfile1

#undo位置
[root@db01 data]# ll /application/mysql/data/
-rw-rw---- 1 mysql mysql 79691776 Aug 15 06:34 ibdata1
-rw-rw---- 1 mysql mysql 79691776 Aug 15 06:34 ibdata2

在MySQL5.6版本中undo是在ibdata文件中，在MySQL5.7版本会独立出来。


#=====================
# 一、Undo 日常工作流程
#=====================
#1.DML更新数据前，记录修改前原始数据生成undo
#2.undo写入独立undo表空间文件
#3.事务未提交：rollback通过undo还原旧数据，实现原子回滚
#4.事务已提交：undo不立刻删除，供MVCC快照读；无事务引用后，Purge线程异步清理undo空间


#=====================
# 二、MySQL宕机重启：Redo+Undo协同故障恢复流程
#=====================
#步骤1：加载redo日志，重做【已提交但脏页没刷磁盘】的数据，把数据落盘(依靠redo持久性)
#步骤2：扫描undo日志，找出所有【未提交/异常中断事务】，利用undo回滚撤销脏修改
#步骤3：事务状态全部规整完毕，InnoDB引擎正常启动对外提供服务


```

## redo 与 undo 区别表格（InnoDB 日志核心）



| 对比项       | Redo Log（重做日志）                                         | Undo Log（回滚日志）                                         |
| ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **英文全称** | Re-do Log                                                    | Un-do Log                                                    |
| **核心作用** | **崩溃恢复、保证持久性 D**宕机后把已提交事务数据刷磁盘       | **事务回滚 + MVCC 多版本**1.rollback 撤销未提交修改2. 生成历史快照实现快照读 |
| **记录内容** | **物理修改：磁盘页改动（哪个页、改了什么字节）**例：163 号 page，offset20 位置值从 100 改成 200 | **逻辑 SQL 反向数据**改 update 就存修改前原值；insert 存删除标记；delete 存插入数据 |
| **写入时机** | **修改内存 Buffer Pool 前先写 redo（先写日志）**事务提交不立刻刷数据页，redo 落盘即可 | 数据修改 Buffer Pool 时同步生成 undo，写入 undo 段           |
| **生命周期** | 事务提交后不马上删，**脏页刷完磁盘才被覆盖复用**             | 事务提交后 undo 不立即删除，MVCC 快照还在引用就保留，无用后 purge 线程清理 |
| **故障表现** | 宕机→靠 redo 重做，**已提交数据不丢失**                      | 宕机未提交事务→靠 undo 回滚撤销改动                          |
| **存放位置** | ib_logfile0、ib_logfile1（固定大小循环文件）                 | 5.7 前在 ibdata1；8.0 独立 undo_xx 表空间 ibd 文件           |

 **一句话速记**

1. **Redo：存改后数据，用来 “出事了重做、保提交不丢”**
2. **Undo：存改前老数据，用来 “回滚撤销 + 多版本读”**

补充实战示例

```bash
UPDATE user SET money=900 WHERE id=1; --原1000
- redo：记录对应数据页被修改成900（物理页变更）
- undo：记录原值1000，rollback时写回1000；别的事务快照读读取1000

额外区分
redo 保证 D 持久性
undo 支撑 A 原子性 + I 隔离性 (MVCC)
```



### 事务中的锁

1）什么是“锁”？
“锁”顾名思义就是锁定的意思。
2）“锁”的作用是什么？
在事务ACID特性过程中，“锁”和“隔离级别”一起来实现“I”隔离性的作用。

排他锁：保证在多事务操作时，数据的一致性。
共享锁：保证在多事务工作期间，数据查询时不会被阻塞。

```bash
#=====================
# InnoDB 事务锁：共享锁(S)、排他锁(X)
#=====================
# 1. 共享锁 S (Shared Lock)
#  作用：多事务可同时加S锁读取数据，读操作互不阻塞
#  限制：持有S锁期间，其他事务无法加排他锁修改数据
#  手动加锁：SELECT ... LOCK IN SHARE MODE

# 2. 排他锁 X (Exclusive Lock)
#  作用：独占数据，防止并发篡改，保障修改后数据一致
#  限制：持有X锁时，其他事务既不能读、也不能改，全部阻塞
#  触发场景：UPDATE/DELETE、SELECT ... FOR UPDATE（自动/手动加X锁）

#=====================
# 锁兼容规则（核心）
#=====================
# S + S：兼容，可共存
# S + X：互斥，阻塞
# X + 任意锁：互斥，阻塞

#=====================
# 补充要点
#=====================
# 1. 普通SELECT 是MVCC快照读，**不加锁**，读写互不影响
# 2. 锁生命周期：事务内加锁，commit/rollback 才释放
# 3. 有索引走行锁；无索引，行锁降级为全表锁


# ======================
# 二、锁粒度（从细到粗）
# ======================
# 1. 行锁(默认)：只锁定命中数据行，并发最高，InnoDB主力锁
#    触发：DML、for update 走有效索引时生效
# 2. 表锁：锁定整张表，并发极低
#    触发：LOCK TABLES、索引失效/无索引(行锁降级)
# 3. 意向锁(IS/IX)：表级辅助锁，标记表内存在行锁，避免全表扫描判断锁

# ======================
# 三、MVCC 多版本并发控制    Multi-Version Concurrency Control
# ======================
# 1. 适用：RC、RR隔离级别，**快照读(普通SELECT)不加锁**
# 2. 依赖：undo日志 + 行隐藏事务字段，生成数据历史快照
# 3. 作用：读写不阻塞，大幅提升并发；配合隔离级别解决读异常
# 4. 区分：
#    快照读：普通SELECT，走MVCC无锁
#    当前读：UPDATE/DELETE/FOR UPDATE，走行锁


# ======================
# 二、悲观锁 & 乐观锁（两种并发控制思想）
# ======================
# 悲观锁
# 含义：默认并发一定会产生数据冲突，**提前加锁**阻止别人操作
# 实现：依赖上面的共享锁、排他锁、行锁、表锁
# 场景：写操作频繁、并发冲突高的业务
# 排他锁、共享锁 = 悲观锁的具体实现


# 乐观锁 
# 含义：默认冲突概率很低，**全程不加锁**，更新时再校验数据是否被改动
# 实现：依赖版本号/时间戳字段做校验
# 场景：读多写少、冲突少，追求高并发性能 谁先提交谁为准

# ======================
# 三、三大并发读异常（隔离级别要解决的问题）
# ======================
# 1. 脏读
# 含义：一个事务读到了**其他事务未提交**的修改数据
# 问题：对方事务回滚后，读到的数据就变成无效脏数据
# 出现场景：读未提交 隔离级别

# 2. 不可重复读
# 含义：**同一个事务内**，两次查询同一条数据，结果不一致  #同一行数据不一样
# 原因：间隔期间其他事务执行UPDATE并提交
# 侧重点：单条数据内容被修改
# 出现场景：读已提交(RC) 隔离级别

# 3. 幻读
# 含义：**同一个事务内**，按条件多次查询，数据行数忽多/忽少 #数据行不一样
# 原因：间隔期间其他事务执行INSERT/DELETE并提交
# 侧重点：数据条数发生变化（新增/消失行）
# 出现场景：可重复读(RR)仍会存在，InnoDB靠间隙锁缓解，串行化彻底解决

```

### 事务的隔离级别

```sql
事务隔离级别（由低→高）
READ UNCOMMITTED（独立提交）  允许事务查看其他事务所进行的未提交更改
READ COMMITTED (读提交 RC)      允许事务查看其他事务所进行的已提交更改
REPEATABLE READ(重复读 RR)      确保每个事务的 SELECT 输出一致 # InnoDB 的默认级别
SERIALIZABLE   (串行)        将一个事务的结果与其他事务完全隔离

#查看隔离级别
3306 [(none)]>show variables like 'tx_isolation';
+---------------+-----------------+
| Variable_name | Value           |
+---------------+-----------------+
| tx_isolation  | REPEATABLE-READ |
+---------------+-----------------+
#修改隔离级别为RU
[mysqld]
transaction_isolation=read-uncommit
mysql> use oldboy
mysql> select * from stu;
mysql> insert into stu(id,name,sex,money) values(2,'li4','f',123);
#修改隔离级别为RC
[mysqld]
transaction_isolation=read-commit
```

乐观锁  悲观锁 实战

```BASH
一、悲观锁（基于排他行锁）

# 核心：提前加锁，阻塞并发修改，强数据一致
# 前提：关闭自动提交，查询字段带索引
CREATE TABLE goods(id INT PRIMARY KEY,stock INT);
INSERT goods VALUES(1,10);

-- 会话1 加锁执行业务
SET autocommit=0;
START TRANSACTION;
SELECT * FROM goods WHERE id=1 FOR UPDATE; -- 加排他行锁
UPDATE goods SET stock=stock-1 WHERE id=1;
COMMIT; -- 提交释放锁

-- 会话2 操作同行会阻塞，直至锁释放
特点：并发低，易产生锁等待。
二、乐观锁（版本号实现，主流）
# 核心：全程无锁，更新时校验版本判断数据是否被篡改
CREATE TABLE goods(id INT PRIMARY KEY,stock INT,version INT DEFAULT 0);
INSERT goods VALUES(1,10,0);

SELECT stock,version FROM goods WHERE id=1; -- 查询获取版本号
-- 版本匹配则更新，版本号自增；行数为0代表数据已被修改（冲突）
UPDATE goods SET stock=stock-1,version=version+1 WHERE id=1 AND version=0;

时间戳替代方案
ALTER TABLE goods ADD update_time DATETIME;
UPDATE goods SET stock=stock-1,update_time=NOW() WHERE id=1 AND update_time='旧时间';
特点：无锁高并发，冲突需业务层重试。

极简总结
# 悲观锁：加锁阻塞，适合写多、要求强一致场景
# 乐观锁：字段校验，无锁高并发，适合读多写少场景


```



# mysql日志

| 日志文件                       | 相关选项                              | 文件名 / 表名称                           | 常用程序        |
| ------------------------------ | ------------------------------------- | ----------------------------------------- | --------------- |
| **错误日志**                   | `--log-error`                         | `host_name.err`                           | N/A             |
| **常规日志（通用日志）**       | `--general_log`                       | `host_name.log` / `general_log`（表名）   | N/A             |
| **慢速查询日志（慢查询日志）** | `--slow_query_log``--long_query_time` | `host_name-slow.log` / `slow_log`（表名） | `mysqldumpslow` |
| **二进制日志（binlog）**       | `--log-bin``--expire-logs-days`       | `host_name-bin.000001`                    | `mysqlbinlog`   |
| **审计日志**                   | `--audit_log``--audit_log_file` ...   | `audit.log`                               | N/A             |

```bash
# 错误日志：--log-error，记录错误/警告，生产必开，用于排错
# 通用日志：--general_log，记录所有SQL，性能开销大，默认关闭，临时排查用
# 慢查询日志：--slow_query_log --long_query_time，记录慢SQL，生产必开，优化性能用
# Binlog：--log-bin --expire-logs-days，记录所有变更，主从/恢复用，生产必须开
# 审计日志：--audit_log，合规审计用，按需开启
```





## 错误日志

```sql
默认位置: $MYSQL_HOME/data/ 
开启方式 (安装完默认开启 )
vim /etc/my.cnf 
[mysqld]
# $hostname 改成主机名 这个配置默认就是这样的，也可以不用写
log_error=/application/mysql/data/$hostname.err 

#查看方式
show variables like 'log_error';

```
## 一般查询日志

```sql
作用：
记录mysql所有执行成功的SQL语句信息，可以做审计用，但是我们很少开启。
默认位置：$MYSQL_HOME/data/
开启方式:（MySQL安装完之后默认不开启）
#编辑配置文件
[root@db01 ~]# vim /etc/my.cnf
[mysqld]
general_log=on
general_log_file=/application/mysql/data/$hostnamel.log  #$hostname 改成主机名 
#查看方式
mysql> show variables like '%gen%';
```

## 二进制日志

```bash
# ======================
# 一、二进制日志（Binlog）核心概念
# ======================
# 作用：记录所有DDL/DML/DCL变更（不记录SELECT/查询），用于主从复制、数据恢复、审计
# 格式：host_name-bin.000001, 000002... 循环生成，由index文件维护顺序

# 核心配置（/etc/my.cnf）
[mysqld]
log_bin=mysql-bin               # 开启binlog，指定前缀
binlog_format=ROW              # 推荐ROW格式（记录行级变更，避免主从不一致）
expire_logs_days=7             # 日志保留7天，自动清理过期文件
max_binlog_size=1G             # 单个binlog文件最大1G，超过自动生成新文件
server_id=1                     # 主从复制必须，主从节点ID唯一不重复

# ======================
# 二、Binlog三种格式对比
# ======================
# STATEMENT：记录SQL语句，体积小但主从可能不一致（如RAND()、NOW()）
# ROW：记录行级变更，体积大但主从100%一致（企业推荐）
# MIXED：默认模式，混合使用两种格式，MySQL自动判断使用哪种

# ======================
# 三、常用操作命令
# ======================
-- 查看binlog是否开启
SHOW VARIABLES LIKE '%log_bin%';

-- 查看当前所有binlog文件
SHOW BINARY LOGS;

-- 查看当前正在写入的binlog文件
SHOW MASTER STATUS;

-- 查看binlog内容（需用mysqlbinlog工具）
mysqlbinlog /var/lib/mysql/mysql-bin.000001

-- 按时间范围恢复数据（示例）
mysqlbinlog --start-datetime="2026-06-01 00:00:00" --stop-datetime="2026-06-01 12:00:00" /var/lib/mysql/mysql-bin.000001 | mysql -u root -p

--  查看二进制日志后，发现delete语句开始位置是1347  按position位置截取
mysqlbinlog --start-position=120 --stop-position=1347 /application/mysql/data/mysql-bin.000002 >/tmp/binlog.sql


-- 清理binlog（需谨慎）
PURGE BINARY LOGS BEFORE '2026-06-01 00:00:00';  # 清理指定时间前的日志
RESET MASTER;                                     # 重置所有binlog（主库慎用）

# ======================
# 四、生产环境使用要点
# ======================
# 1. 必须开启binlog，否则无法主从复制和数据恢复
# 2. 推荐使用ROW格式，避免主从不一致问题
# 3. 配置合理的expire_logs_days，防止磁盘占满
# 4. binlog文件需定期备份，配合全量备份做数据恢复
# 5. 主从复制时，server_id必须唯一，否则会导致复制异常
```



二进制日志的管理操作实战

```bash
# mysql5.6开启 
[root@db01 data]# vim /etc/my.cnf
[mysqld]
log-bin=mysql-bin
binlog_format=row

mysql 5.7开启binlog必须要加上server-id。
[root@db01 data]# vim /etc/my.cnf
[mysqld]
log-bin=mysql-bin
binlog_format=row
server_id=1

#物理查看
[root@db01 data]# ll /application/mysql/data/
-rw-rw---- 1 mysql mysql      285 Mar  6  2017 mysql-bin.000001
#命令行查看
mysql> show binary logs;
mysql> show master status;
#查看binlog事件
mysql> show binlog events in 'mysql-bin.000001';

事件介绍
	1）在binlog中最小的记录单元为event
	2）一个事务会被拆分成多个事件（event）
事件（event）特性
	1）每个event都有一个开始位置（start position）和结束位置（stop position）。
	2）所谓的位置就是event对整个二进制的文件的相对位置。
	3）对于一个二进制日志中，前120个position是文件格式信息预留空间。
	4）MySQL第一个记录的事件，都是从120开始的。
	
	
	
```



row模式下二进制日志分析及数据恢复
```sql
set autocommit=0; #临时关闭

show master status;
-- 刷新一个新的binlog
flush logs;
show master status;
create database binlog;
use binlog
create table binlog_table(id int);
show master status;
insert into binlog_table values(1);
show master status;
commit;
show master status;
insert into binlog_table values(2);
insert into binlog_table values(3);
show master status;
commit;

delete from binlog_table where id=1;
show master status;
commit;
update binlog_table set id=22 where id=2;
show master status;
commit;
show master status;
select * from binlog_table;
drop table binlog_table;
drop database binlog;


-- show binlog events in 'mysql-bin.000002';
# 一、常见 Event_type 分类及释义（MySQL 5.6/5.7/8.0 通用）
# 基础文件事件
Format_desc        # 日志文件头部描述事件，每个binlog文件首个事件，记录版本、格式
Rotate             # 日志切换事件，代表写完当前文件，切换到下一个binlog

# 事务边界事件（InnoDB 事务必备）
Query              # 记录普通SQL/事务开始(BEGIN)、提交(COMMIT)、DDL语句
Xid                # 事务提交标记（XA事务/InnoDB事务结束标识）

# DML数据变更事件（由 binlog_format 决定出现哪种）
# STATEMENT/MIXED 模式：主要走 Query 事件记录SQL
# ROW 模式（主流）：行级变更专属事件
Table_map          # 记录表名、表结构映射，行事件前置事件
Write_rows         # 对应 INSERT 操作，新增数据行
Delete_rows        # 对应 DELETE 操作，删除数据行
Update_rows        # 对应 UPDATE 操作，更新数据行

# 其他少见事件
Intvar             # 记录自增ID、LAST_INSERT_ID() 等变量值
User_var           # 记录用户自定义变量
Stop               # MySQL正常停止时产生的结束事件


-- 恢复数据到delete之前 
mysql> show binlog events in 'mysql-bin.000002';
#使用mysqlbinlog来查看
mysqlbinlog /application/mysql/data/mysql-bin.000002
mysqlbinlog /application/mysql/data/mysql-bin.000002|grep -v SET
# mysqlbinlog --base64-output=decode-rows -vvv mysql-bin.000002
### UPDATE `binlog`.`binlog_table`
### WHERE
###   @1=2 /* INT meta=0 nullable=1 is_null=0 */
### SET
###   @1=22 /* INT meta=0 nullable=1 is_null=0 */
-------------------------------------------------------
#分析
update binlog.binlog_table
set
@1=22 --------->@1表示binlog_table中的第一列,集合表结构就是id=22
where
@1=2  --------->@1表示binlog_table中的第一列,集合表结构就是id=2
#结果
update binlog.binlog_table set id=22 where id=2;
------------------------------------------------------
# at 1316
#221228  9:55:18 server id 1  end_log_pos 1347 CRC32 0x252f9d79         Xid = 27
COMMIT/*!*/;
# at 1347
#221228  9:56:18 server id 1  end_log_pos 1476 CRC32 0x2f772fc9         Query   thread_id=1     exec_time=0     error_code                                                                                                              =0
SET TIMESTAMP=1672192578/*!*/;
DROP TABLE `binlog_table` /* generated by server */
/*!*/;
# at 1476
#221228  9:56:24 server id 1  end_log_pos 1565 CRC32 0x6e8693a9         Query   thread_id=1     exec_time=0     error_code                                                                                                              =0
SET TIMESTAMP=1672192584/*!*/;
drop database binlog
/*!*/;



#截取二进制日志
查看二进制日志后，发现delete语句开始位置是1347
[root@db01 data]# mysqlbinlog --start-position=120 --stop-position=1347 /application/mysql/data/mysql-bin.000002 >/tmp/binlog.sql


mysql -uroot -p123
mysql> set sql_log_bin=0;
mysql> source /tmp/binlog.sql  #临时关闭binlog

mysql> show databases;
mysql> use binlog
mysql> show tables;
mysql> select * from binlog_table;
```


存在问题:
数据库或表被误删除的是很久之前创建的（一年前）
如果基于binlog全量恢复，成本很高
    1）可以用备份恢复+短时间内二进制日志，恢复到故障之前
    2）非官方方法，binlog2sql，binlog取反，类似于Oracle的flushback
    3）延时从库
如果同一时间内和故障库无关的数据库都有操作，在截取binlog时都会被截取到
想一个办法过滤出来？
    1）grep？
    其他过滤方案？
    2）-d 参数接库名

模拟数据
```sql
#为了让大家更清晰看到新的操作
#刷新一个新的binlog
mysql> flush logs;

create database db1;
create database db2;
use db1
create table t1(id int);
insert into t1 values(1),(2),(3),(4),(5);
commit;

#库db2操作
use db2
create table t2(id int);
insert into t2 values(1),(2),(3);
commit;

#查看binlog事件
mysql> show binlog events in 'mysql-bin.000014';
mysql> quit
#查看db1的操作 -d参数 指定库
[root@db01 data]# mysqlbinlog -d db1 --base64-output=decode-rows -vvv /application/mysql/data/mysql-bin.000014
```
**删除、刷新binlog**

```BASH
刷新binlog日志
    1）flush logs;
    2）重启数据库时会刷新
    3）二进制日志上限（max_binlog_size）
[(none)]>show variables like 'max_binlog_size';
+-----------------+------------+
| Variable_name   | Value      |
+-----------------+------------+
| max_binlog_size | 1073741824 |
+-----------------+------------+
#计算  默认是 1G 就会刷新 binlog 日志
1073741824/1024/1024




删除二进制日志
    1）原则 - 在存储能力范围内，能多保留则多保留
    2)基于上一次全备前的可以选择删除

删除方式
1.根据存在时间删除日志

#临时生效   只保留7天内的
SET GLOBAL expire_logs_days = 7;

#永久生效
[root@db01 data]# vim /etc/my.cnf
[mysqld]
expire_logs_days=7

2.使用purge命令删除
PURGE BINARY LOGS BEFORE now() - INTERVAL 3 day;
msyql> purge binary logs before NOW() - interval 3 day;

3.根据文件名删除
show binary logs;#查看
PURGE BINARY LOGS TO 'mysql-bin.000010';
purge binary logs to 'mysql-bin.000002';

4.使用reset master  重置,从mysql-bin.000001 开始
mysql> reset master;
```



# 慢查询日志

```sql
作用： 记录慢SQL语句的日志,定位低效SQL语句的工具日志
默认位置： $MYSQL_HOME/data/$hostname-slow.log
开启方式（默认没有开启）：

[root@db01 ~]# vim /etc/my.cnf
[mysqld]
#开关
slow_query_log = 1
#文件位置及名称
slow_query_log_file=/application/mysql/data/slow.log
#设定慢查询的阀值(默认10s)
long_query_time=0.05
#没走索引的语句也记录:
log_queries_not_using_indexes
#查询语句的扫描行数少于该参数指定行的SQL不被记录到慢查询日志   #默认0 不做行数限制，只要超时就记录
min_examined_row_limit=0


```
模拟慢查询语句
```sql
use world
show tables
#将city表中所有内容加到t1表中
create table t1 select * from city;
#查看t1的表结构
desc t1;
#将t1表所有内容插入到t1表中（多插入几次）
insert into t1 select * from t1;
insert into t1 select * from t1;
insert into t1 select * from t1;
insert into t1 select * from t1;
commit;
delete from t1 where id>2000;
quit
[root@db01 ~]# cat /application/mysql/data/slow.log

#输出记录次数最多的10条SQL语句
mysqldumpslow -s c -t 10 /application/mysql/data/slow.log

参数说明:
-s:是表示按照何种方式排序，c 次数、t 时间、l 查询时间、r 返回的记录数 来排序，
		ac、at、al、ar，表示相应的倒叙；
-t:是top n的意思，即为返回前面多少条的数据；
-g:后边可以写一个正则匹配模式，大小写不敏感的；

#得到返回记录集最多的10个查询
mysqldumpslow -s r -t 10 /application/mysql/data/slow.log

#得到按照时间排序的前10条里面含有左连接的查询语句
mysqldumpslow -s t -t 10 -g “left join” /application/mysql/data/slow.log

-- 拿到慢 SQL → explain 分析执行计划
explain SELECT * FROM user WHERE username='xxx';

```



第三方推荐（扩展）



```bash
yum install -y percona-toolkit-3.0.11-1.el6.x86_64.rpm
-------------------------------------------------------------------------------------------

# 安装官方 percona-release
yum install -y https://repo.percona.com/yum/percona-release-latest.noarch.rpm
# 2. 启用 tools 源（生成 repo 文件）
percona-release enable-only tools release
#官方源太慢
#把官方地址替换成腾讯云（关键）
sed -i 's#repo.percona.com#mirrors.cloud.tencent.com/percona#g' /etc/yum.repos.d/percona-*.repo
yum clean all && yum makecache
------------------------------或者
# 1. 创建 percona.repo
cat > /etc/yum.repos.d/percona.repo <<'EOF'
[percona-tools]
name=Percona Tools (Tencent Cloud Mirror)
baseurl=https://mirrors.cloud.tencent.com/percona/yum/
enabled=1
gpgcheck=0
EOF
# 2. 清缓存、建缓存
yum clean all
yum makecache
# 3. 安装工具（pt-toolkit、xtrabackup）
yum install -y percona-toolkit percona-xtrabackup
---------------------------------

yum install percona-toolkit


# xtrabackup对应mysql版本
percona-xtrabackup-24       # for 5.6/5.7
percona-xtrabackup-80       # for 8.0

使用percona公司提供的pt-query-digest工具分析慢查询日志
pt-query-digest /application/mysql/data/slow.log

[root@db yum.repos.d]# pt-query-digest /application/mysql/data/slow.log
*******************************************************************
 Using the default of SSL_verify_mode of SSL_VERIFY_NONE for client
 is deprecated! Please set SSL_verify_mode to SSL_VERIFY_PEER
 possibly with SSL_ca_file|SSL_ca_path for verification.
 If you really don't want to verify the certificate and keep the
 connection open to Man-In-The-Middle attacks please set
 SSL_verify_mode explicitly to SSL_VERIFY_NONE in your application.
*******************************************************************
  at /usr/bin/pt-query-digest line 12150.
*******************************************************************
 Using the default of SSL_verify_mode of SSL_VERIFY_NONE for client
 is deprecated! Please set SSL_verify_mode to SSL_VERIFY_PEER
 possibly with SSL_ca_file|SSL_ca_path for verification.
 If you really don't want to verify the certificate and keep the
 connection open to Man-In-The-Middle attacks please set
 SSL_verify_mode explicitly to SSL_VERIFY_NONE in your application.
*******************************************************************
  at /usr/bin/pt-query-digest line 12150.

# 3 software updates are available:
#   * The current version for DBD::mysql is 5.013
#   * The current version for Percona::Toolkit is 3.7.1
#   * The current version for Perl is 5.42.0


# 50ms user time, 100ms system time, 28.94M rss, 241.96M vsz
# Current date: Sat Jun  6 04:12:16 2026
# Hostname: db
# Files: /application/mysql/data/slow.log
# Overall: 6 total, 3 unique, 0.21 QPS, 0.01x concurrency ________________
# Time range: 2026-06-06 03:39:05 to 03:39:34
# Attribute          total     min     max     avg     95%  stddev  median
# ============     ======= ======= ======= ======= ======= ======= =======
# Exec time          262ms    21ms    73ms    44ms    71ms    18ms    50ms
# Lock time           20ms    55us    15ms     3ms    14ms     5ms     2ms
# Rows sent              0       0       0       0       0       0       0
# Rows examine     187.22k   3.98k  63.73k  31.20k  62.55k  24.22k  47.07k
# Query size           186      28      34      31   33.28    1.70   30.19

# Profile
# Rank Query ID                            Response time Calls R/Call V/M
# ==== =================================== ============= ===== ====== ====
#    1 0x049A46817126F277D990BC7C09F20BDA   0.1742 66.6%     4 0.0436  0.01 INSERT SELECT t?
#    2 0x7FE0BDA11B6681AF6F6EB4D37DDD5C23   0.0604 23.1%     1 0.0604  0.00 DELETE t?
#    3 0xEC97A6454DCD8D137C91989972B6F3C0   0.0270 10.3%     1 0.0270  0.00 CREATE TABLE city t1

# Query 1: 4 QPS, 0.17x concurrency, ID 0x049A46817126F277D990BC7C09F20BDA at byte 999
# This item is included in the report because it matches --limit.
# Scores: V/M = 0.01
# Time range: 2026-06-06 03:39:22 to 03:39:23
# Attribute    pct   total     min     max     avg     95%  stddev  median
# ============ === ======= ======= ======= ======= ======= ======= =======
# Count         66       4
# Exec time     66   174ms    21ms    73ms    44ms    71ms    18ms    56ms
# Lock time      4   956us    55us   458us   239us   445us   147us   366us
# Rows sent      0       0       0       0       0       0       0       0
# Rows examine  63 119.50k   7.97k  63.73k  29.88k  62.55k  21.08k  47.07k
# Query size    66     124      31      31      31      31       0      31
# String:
# Databases    world
# Hosts        localhost
# Users        root
# Query_time distribution
#   1us
#  10us
# 100us
#   1ms
#  10ms  ################################################################
# 100ms
#    1s
#  10s+
# Tables
#    SHOW TABLE STATUS FROM `world` LIKE 't1'\G
#    SHOW CREATE TABLE `world`.`t1`\G
insert into t1 select * from t1\G


# 一、开头SSL警告（可忽略，仅Perl模块弃用提示，不影响分析结果）
*******************************************************************
# 提示：旧SSL校验模式已废弃，建议开启证书校验；纯内网分析慢日志可直接忽略
 Using the default of SSL_verify_mode of SSL_VERIFY_NONE for client
 is deprecated! Please set SSL_verify_mode to SSL_VERIFY_PEER
 possibly with SSL_ca_file|SSL_ca_path for verification.
 If you really don't want to verify the certificate and keep the
 connection open to Man-In-The-Middle attacks please set
 SSL_verify_mode explicitly to SSL_VERIFY_NONE in your application.
*******************************************************************
  at /usr/bin/pt-query-digest line 12150.

# 软件版本更新提示，当前工具、Perl版本偏低，按需升级即可
# 3 software updates are available:
#   * DBD::mysql 数据库驱动当前版本 5.013
#   * Percona::Toolkit 工具包当前版本 3.7.1
#   * Perl 脚本环境当前版本 5.42.0

# 二、服务器&运行资源统计
# 50ms 用户态耗时, 100ms 系统态耗时, 28.94M 物理内存占用, 241.96M 虚拟内存占用
# Current date: 分析执行时间 2026-06-06 04:12:16
# Hostname: 主机名 db
# Files: 分析的慢日志文件 /application/mysql/data/slow.log

# 三、日志整体汇总（全局指标）
# Overall: 总计6条SQL, 3条独立SQL, 0.21 QPS(每秒查询数), 0.01 平均并发数
# Time range: 慢日志记录时间范围 2026-06-06 03:39:05 ~ 03:39:34

# 核心性能指标总览
# Exec time 执行总耗时：262ms，单条最小21ms、最大73ms，平均44ms，95%线71ms
# Lock time 锁等待总耗时：20ms，SQL锁竞争整体很小
# Rows sent 返回客户端行数：0，都是无结果集的DML/DDL语句
# Rows examine 存储引擎扫描总行数：187.22k，单条平均扫描31.20k行（扫描量大，优化重点）
# Query size SQL语句字节大小：平均31字节，语句本身不长

# 四、SQL排名（按响应时间降序，重点看Rank排行）
# Rank 排名 | Query ID SQL唯一标识 | Response time 总耗时&占比 | Calls 执行次数 | R/Call 单次耗时 | V/M 波动系数
# 1 排名第一(最耗性能)：INSERT SELECT 语句，执行4次，总耗时占比66.6%，核心优化对象
# 2 排名第二：DELETE 语句，执行1次，总耗时占比23.1%
# 3 排名第三：CREATE TABLE 建表语句，执行1次，总耗时占比10.3%

# 五、TOP1 详细分析（问题SQL：insert into t1 select * from t1）
# Count：共执行4次，占总条数66%
# Exec time：总耗时174ms，单条最大73ms，执行耗时偏高
# Lock time：总锁等待956us，锁压力很小
# Rows examine：累计扫描119.50k行，占总扫描行数63%，**扫描行数过多是慢的主因**
# 执行用户：root，客户端地址：localhost，操作库：world

# Query_time distribution 执行耗时分布：
# 10ms区间占比最高，说明这批SQL大多落在10ms~100ms区间，符合慢日志阈值规则

# 执行前自动执行表结构查询（工具默认行为）
# SHOW TABLE STATUS FROM `world` LIKE 't1'\G  查询表状态
# SHOW CREATE TABLE `world`.`t1`\G             查询表建表语句

# 最终问题SQL
insert into t1 select * from t1\G
# 风险说明：自复制插入数据，表数据会不断膨胀，且全表扫描导致行数巨大，持续拖慢性能
```

 

# MySQL的备份和恢复

## 备份原因

运维工作的核心简单概括就两件事:
    1）第一个是保护公司的数据.
    2）第二个是让网站能7*24小时提供服务(用户体验)。

1）备份就是为了恢复。
2）尽量减少数据的丢失（公司的损失）

## 备份类型
```bash
- 冷备份  # 停业务备份
- 温备份  # 用户可读取数据,但不能修改数据情况下备份
- 热备份  # 用户可读取和修改的操作下 备份
```

## 备份方式
	- 逻辑备份   #基于sql语句的备份
		1)binlog  
		2)into outfile  
		3)mysqldump 
		4)replication
	- 物理备份   #基于数据文件的备份
		1) Xtrabackup (percona公司)	

## 备份策略
	- 全量备份 full 
	- 增量备份 increamental

## 备份工具
	- mysqldump (逻辑)
	- mysqlbinlog (逻辑)
	- xtrabackup (物理)


# 备份工具使用

## mysqldump 使用
	参数
		-u  #用户名
		-p  #密码
		-h  #地址
		-P 	#端口
		-S  # socket 连接
	    -A,--all-databases  #全库备份
```
mysqldump -uroot -p123 -A > /backup/full.sql

#单库备份
mysqldump -uroot -p123 db1 > /backup/db1.sql
#单表备份
mysqldump -uroot -p123 world city > /backup/city.sql

-B 指定库备份
mysqldump -uroot -p123 -B db1 > /backup/db1.sql
mysqldump -uroot -p123 -B db1 db2 /backup/db1_db2.sql

# -F : flush logs 在备份的时候刷新binlog #不常用
mysqldump -uroot -p123 -A -R --triggers -F > /backup/full_2.sql

#--master-data=2：备份时加入change master语句 0没有 1不注释 2注释
mysqldump -uroot -p123 --master-data=2 > /backup/full.sql

# -d 仅表结构
# -t 仅数据

备份额外扩展
# -R,--routines: 备份存储过程和函数数据
# --triggers:  备份触发器数据

mysqldump特殊参数
-x  锁表备份 (myisam 温备份)
--single-transaction    快照备份
mysqldump -uroot -p123 -A -R --triggers --master-data=2 --single-transaction > /backup/full.sql

#gzip 压缩备份
mysqldump -uroot -p123 -A -R --triggers --master-data=2 --single-transaction|gzip>/backup/full.sql.gz

```

mysqldump 恢复

```
#临时关闭二进制日志
set sql_log_bin=0;
#库内恢复
source /backup/full.sql

# linux命令行恢复
mysql -uroot -p123 < /backup/full.sql
```
注意：
    1）mysqldump在备份和恢复时都需要MySQL实例启动为前提
    2）一般数据量级100G以内，大约15-30分钟可以恢复（PB、EB就需要考虑别的方式）
    3）mysqldump是以覆盖的形式恢复数据的

## xtrabackup
安装
```
#下载epel源
wget -O /etc/yum.repos.d/epel.repo  https://mirrors.aliyun.com/repo/epel-6.repo
#安装依赖
yum -y install perl perl-devel libaio libaio-devel perl-Time-HiRes perl-DBD-MySQL
#下载Xtrabackup
wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.4/binary/redhat/6/x86_64/percona-xtrabackup-24-2.4.4-1.el6.x86_64.rpm
```

备份方式（物理备份）
    1）对于非innodb表（比如myisam）是直接锁表cp数据文件，属于一种温备。
    2）对于innodb的表（支持事务），不锁表，cp数据页最终以数据文件方式保存下来，并且把redo和undo一并备走，属于热备方式。
    3）备份时读取配置文件/etc/my.cnf

**全量备份**
```
#全备   自动会在backup目录下生成一个时间日期的文件夹
innobackupex --user=root --password=123 /backup
innobackupex --user=root --password=123 -S /tmp/mysql.sock  /backup

#自定义备份目录名
innobackupex --user=root --password=123 --no-timestamp /backup/full
innobackupex --user=root --password=123 --no-timestamp -S /tmp/mysql.sock /backup/full

[root@db03 backup]# ls -lh /backup/full
....
#记录binlog文件名和binlog的位置点
-rw-r-----. 1 root root   26 Dec 28 17:06 xtrabackup_binlog_info
#备份时刻，立即将已经commit过的内存中的数据页刷新到磁盘
#备份时刻有可能会有其他数据写入，已备走的数据文件就不会再发生变化了
#在备份过程中，备份软件会一直监控着redo和undo，一旦有变化会将日志一并备走
-rw-r-----. 1 root root  141 Dec 28 17:06 xtrabackup_checkpoints
#备份汇总信息
-rw-r-----. 1 root root  511 Dec 28 17:06 xtrabackup_info
#备份的redo文件
-rw-r-----. 1 root root 2.5K Dec 28 17:06 xtrabackup_logfile

```
**全备恢复**

```
#准备备份
#将redo进行重做，已提交的写到数据文件，未提交的使用undo回滚，模拟CSR的过程
innobackupex --user=root --password=123 --apply-log /backup/full

#恢复备份
#前提1：被恢复的目录是空的
#前提2：被恢复的数据库的实例是关闭的

#/etc/init.d/mysqld stop
systemctl stop mysqld

#删除data目录（在生产中可以备份一下）
rm -fr /application/mysql/data/
#拷贝数据
innobackupex --copy-back /backup/full
#授权
chown -R mysql.mysql /application/mysql/data/

# /etc/init.d/mysqld start
systemctl start mysqld

```

**增量备份及恢复**
备份方式
    1）基于上一次备份进行增量
    2）增量备份无法单独恢复，必须基于全备进行恢复
    3）所有增量必须要按顺序合并到全备当中

```
#不使用之前的全备，执行一次全备
#innobackupex --user=root --password=123 --no-timestamp /backup/full
innobackupex --user=root --password=123 --no-timestamp -S /tmp/mysql.sock /backup/full

#模拟数据变化
mysql -uroot -p123
create database inc1;
use inc1
create table inc1_tab(id int);
insert into inc1_tab values(1),(2),(3);
commit;
select * from inc1_tab;
quit

#第一次增量备份
#innobackupex --user=root --password=123 --no-timestamp --incremental --incremental-basedir=/backup/full/ /backup/inc1
innobackupex --user=root --password=123 --no-timestamp --incremental --incremental-basedir=/backup/full/ -S /tmp/mysql.sock /backup/inc1

参数说明:
--incremental：开启增量备份功能
--incremental-basedir：上一次备份的路径

#再次模拟数据变化
mysql -uroot -p123
create database inc2;
use inc2
create table inc2_tab(id int);
insert into inc2_tab values(1),(2),(3);
commit;
quit
#第二次增量备份
#innobackupex --user=root --password=123 --no-timestamp --incremental --incremental-basedir=/backup/inc1/ /backup/inc2
innobackupex --user=root --password=123 --no-timestamp --incremental --incremental-basedir=/backup/inc1/ -S /tmp/mysql.sock /backup/inc2

#破坏数据
[root@db01 ~]# rm -fr /application/mysql/data/
systemctl stop mysqld
```

**增量恢复**
	1）full+inc1+inc2
	2）需要将inc1和inc2按顺序合并到full中
	3）分步骤进行--apply-log

```
#1 在全备中apply-log时，只应用redo，不应用undo
innobackupex --apply-log --redo-only /backup/full/

#2 合并inc1合并到full中，并且apply-log，只应用redo，不应用undo
innobackupex --apply-log --redo-only --incremental-dir=/backup/inc1/ /backup/full/

#3 合并inc2合并到full中，redo和undo都应用
innobackupex --apply-log --incremental-dir=/backup/inc2/ /backup/full/

#4 整体full执行apply-log，redo和undo都应用
innobackupex --apply-log /backup/full/
#copy-back
innobackupex --copy-back /backup/full/
chown -R mysql.mysql /application/mysql/data/
#/etc/init.d/mysqld start
systemctl start mysqld
```



# mysql主从复制

```css
1. 主库的修改操作会记录二进制日志
2. 从库会请求主库的二进制日志并在本地应用其内容.
	IO: 请求主库,获取上一次执行过的新的事件,并存放到reaylog
	sql: 从reaylog中将sql语句翻译给从库执行.


主从复制核心功能:
	辅助备份,处理物理损坏                   
	扩展新型的架构:高可用,高性能,分布式架构等
```



## 主从复制原理

**主从复制的前提**

1）两台或两台以上的数据库实例
2）主库要开启二进制日志
3）主库要有复制用户
4）主库的server_id和从库不同
5）从库需要在开启复制功能前，要获取到主库之前的数据（主库备份，并且记录binlog当时位置）
6）从库在第一次开启主从复制时，时必须获知主库：ip，port，user，password，logfile，pos
    IP：10.0.0.51
    Port：3306
    User：rep
    Password：oldboy123
    logFile：mysql-bin.000002
    Pos：120
7）从库要开启相关线程：IO、SQL
8）从库需要记录复制相关用户信息，还应该记录到上次已经从主库请求到哪个二进制日志
9）从库请求过来的binlog，首先要存下来，并且执行binlog，执行过的信息保存下来

**主从复制涉及到的文件和线程**

*主库：*
1）主库binlog：记录主库发生过的修改事件
2）dump thread：给从库传送（TP）二进制日志线程

*从库：*
1）relay-log（中继日志）：存储所有主库TP过来的binlog事件
2）master.info：存储复制用户信息，上次请求到的主库binlog位置点
3）IO thread：接收主库发来的binlog日志，也是从库请求主库的线程
4）SQL thread：执行主库TP过来的日志

原理
1）通过change master to语句告诉从库主库的ip，port，user，password，file，pos
2）从库通过start slave命令开启复制必要的IO线程和SQL线程
3）从库通过IO线程拿着change master to用户密码相关信息，连接主库，验证合法性
4）从库连接成功后，会根据binlog的pos问主库，有没有比这个更新的
5）主库接收到从库请求后，比较一下binlog信息，如果有就将最新数据通过dump线程给从库IO线程
6）从库通过IO线程接收到主库发来的binlog事件，存储到TCP/IP缓存中，并返回ACK更新master.info
7）将TCP/IP缓存中的内容存到relay-log中
8）SQL线程读取relay-log.info，读取到上次已经执行过的relay-log位置点，继续执行后续的relay-log日志，执行完成后，更新relay-log.info

**主从复制搭建实战**
```
[root@db03 system]# systemctl start mysqld3307.service #主库
[root@db04 system]# systemctl start mysqld3308.service #从库
#主库操作
[root@db03 ~]# cat /data/3307/my.cnf
[mysqld]
basedir=/application/mysql
datadir=/data/3307/data
socket=/data/3307/mysql.sock
log_error=/data/3307/mysql.log
log-bin=/data/3307/mysql-bin  # 开启binlog日志
server_id=1   # 主库server_id 为1 从库不等于1
port=3307
[client]
socket=/data/3307/mysql.sock

#创建主从复制用户
[root@db03 ~]# mysql -uroot -S /data/3307/mysql.sock -p123
mysql>grant replication slave on *.* to rep@'10.0.0.%' identified by '123';


#全备主库发给从库恢复
mysqldump -uroot -p -S /data/3307/mysql.sock -A --master-data=2 --single-transaction -R --triggers > /backup/full.sql


#从库操作
[root@db04 ~]# cat /data/3308/my.cnf
[mysqld]
basedir=/application/mysql
datadir=/data/3308/data
socket=/data/3308/mysql.sock
log_error=/data/3308/mysql.log
log-bin=/data/3308/mysql-bin
server_id=8  #server_id 8 ***
port=3308
[client]
socket=/data/3308/mysql.sock

[root@db04 ~]# systemctl start mysqld3308
#恢复主库的数据
[root@db04 ~]# mysql -uroot -S /data/3308/mysql.sock -p < /backup/full.sql
# 查看主库的 position位置数
[root@db03 ~]# mysql -uroot -p123 -S /data/3307/mysql.sock -e "show master status";

+------------------+----------+--------------+------------------+----
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+----
| mysql-bin.000001 |      120 |              |                  |                   |
+------------------+----------+--------------+------------------+----

# 告知从库的复制信息 ip port user  password  binlog position 
[root@db04 ~]# mysql -uroot -p123 -S /data/3308/mysql.sock
mysql> help change master to
CHANGE MASTER TO
  MASTER_HOST='master2.example.com',
  MASTER_USER='replication',
  MASTER_PASSWORD='bigs3cret',
  MASTER_PORT=3306,
  MASTER_LOG_FILE='master2-bin.001',
  MASTER_LOG_POS=4,
  MASTER_CONNECT_RETRY=10;


CHANGE MASTER TO
  MASTER_HOST='10.0.0.4',
  MASTER_USER='rep',
  MASTER_PASSWORD='123',
  MASTER_PORT=3307,
  MASTER_LOG_FILE='mysql-bin.000001',
  MASTER_LOG_POS=120,
  MASTER_CONNECT_RETRY=10;

  
mysql> start slave;
mysql> show slave status\G
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes



主从连接故障处理方法
stop  slave;  
reset slave all; 
change master to  ... 
start slave;

1)重新备份数据库,恢复到从库
2)给从从库设置为只读
read_only=1;
# 临时生效
mysql> set global read_only=1;

[root@db04 ~]# cat /data/3308/my.cnf
[mysqld]
read_only=1 添加

mysql> show variables like '%read_only%';

```

# 延时从库
为什么要有延时从库
    数据库故障?
    物理损坏
    主从复制非常擅长解决物理损坏.
    逻辑损坏
    普通主从复制没办法解决逻辑损坏


企业中一般会延时3-6小时

```
#停止主从
mysql>stop slave;
#设置延时为180秒
mysql>CHANGE MASTER TO MASTER_DELAY = 180;
#开启主从
mysql>start slave;
#查看状态
mysql> show slave status \G
SQL_Delay: 180
3.延时从库停止方法
#停止主从
mysql> stop slave;
#设置延时为0
mysql> CHANGE MASTER TO MASTER_DELAY = 0;
#开启主从
mysql> start slave;
```

# 半同步复制
从MYSQL5.5开始，支持半自动复制。之前版本的MySQL Replication都是异步（asynchronous）的，主库在执行完一些事务后，是不会管备库的进度的。如果备库不幸落后，而更不幸的是主库此时又出现Crash（例如宕机），这时备库中的数据就是不完整的。简而言之，在主库发生故障的时候，我们无法使用备库来继续提供数据一致的服务了。
半同步复制（Semi synchronous Replication）则一定程度上保证提交的事务已经传给了至少一个备库。
出发点是保证主从数据一致性问题，安全的考虑。

半同步复制开启方法
```
#1）安装（主库）
# mysql -uroot -p123
#查看是否有动态支持
#mysql> show global variables like 'have_dynamic_loading';
#安装自带插件
INSTALL PLUGIN rpl_semi_sync_master SONAME 'semisync_master.so';
#启动插件
SET GLOBAL rpl_semi_sync_master_enabled = 1;
#设置超时
SET GLOBAL rpl_semi_sync_master_timeout = 1000;
#修改配置文件
# vim /etc/my.cnf
#在[mysqld]标签下添加如下内容（不用重启库）
[mysqld]
rpl_semi_sync_master_enabled=1
rpl_semi_sync_master_timeout=1000
检查安装：
mysql> show variables like'rpl%';
mysql> show global status like 'rpl_semi%';

2）安装（从库）
#登录数据库
# mysql -uroot -p123
#安装slave半同步插件
INSTALL PLUGIN rpl_semi_sync_slave SONAME 'semisync_slave.so';
#启动插件
SET GLOBAL rpl_semi_sync_slave_enabled = 1;
#重启io线程使其生效
stop slave io_thread;
start slave io_thread;
#编辑配置文件（不需要重启数据库）
# vim /etc/my.cnf
#在[mysqld]标签下添加如下内容
[mysqld]
rpl_semi_sync_slave_enabled =1


查看是否在运行
主:
show status like 'Rpl_semi_sync_master_status';
从:
show status like 'Rpl_semi_sync_slave_status';

```
注：相关参数说明
rpl_semi_sync_master_timeout=milliseconds
设置此参数值（ms）,为了防止半同步复制在没有收到确认的情况下发生堵塞，如果Master在超时之前没有收到任何确认，将恢复到正常的异步复制，并继续执行没有半同步的复制操作。
rpl_semi_sync_master_wait_no_slave={ON|OFF}
如果一个事务被提交,但Master没有任何Slave的连接，这时不可能将事务发送到其它地方保护起来。默认情况下，Master会在时间限制范围内继续等待Slave的连接，并确认该事务已经被正确的写到磁盘上。
可以使用此参数选项关闭这种行为，在这种情况下，如果没有Slave连接，Master就会恢复到异步复制。

# 过滤复制

主库：
    binlog-do-db      #白名单:只记录白名单中列出的库的二进制日志
    binlog-ignore-db  #黑名单：不记录黑名单列出的库的二进制日志
从库：
白名单：只执行白名单中列出的库或者表的中继日志
replicate-do-db=test
replicate-do-table=test.t1
replicate-wild-do-table=test.t2
黑名单：不执行黑名单中列出的库或者表的中继日志
replicate-ignore-db
replicate-ignore-table
replicate-wild-ignore-table

---------------------------------------------------------------
replicate-wild-do-table和replicate-do-table 参数区别?
结论：对于binlog_format=statement或mixed，
	只在从库设置replicate-wild-do-table=world.% 另两个参数不用设置 或
			  replicate-wild-ignore-table=world.%
	此时可以避免跨库更新问题。
binlog_format=row 直接忽略replicate-wild-do-table replicate-wild-ignore-table参数即可

----------------------------------------------------------------


复制过滤配置
```
# vim /data/3308/my.cnf 
#在[mysqld]标签下添加  表示只复制主库的 world库的数据.其他的库不复制
replicate-do-db=world

# 重启mysql 
# systemctl restart msyqld3308
```

# 主从复制新特性——GTID复制
GTID
5.6新特性
GTID(Global Transaction ID)是对于一个已提交事务的编号，并且是一个全局唯一的编号。
它的官方定义如下：
GTID = source_id ：transaction_id
7E11FA47-31CA-19E1-9E56-C43AA21293967:29

每一台mysql实例中，都会有一个唯一的uuid，标识实例的唯一性
auto.cnf，存放在数据目录下

重要参数：
gtid-mode=on
enforce-gtid-consistency=true
log-slave-updates=1


gtid-mode=on		                --启用gtid类型，否则就是普通的复制架构
enforce-gtid-consistency=true		--强制GTID的一致性
log-slave-updates=1					--slave更新是否记入日志



规划：
	主库：  10.0.0.4/24
	从库1:  10.0.0.5/24
	从库2： 10.0.0.6/24

```
# 三台机器初始化
rm -rf /application/mysql/data/*
/application/mysql/scripts/mysql_install_db --user=mysql --basedir=/application/mysql/ --datadir=/application/mysql/data/
systemctl start mysqld
mysqladmin -uroot password '123'


#master
[root@db03 ~]# cat /etc/my.cnf
[mysqld]
basedir=/application/mysql
datadir=/application/mysql/data
log-error=/application/mysql/data
port=3306
socket=/tmp/mysql.sock
log-bin=mysql-bin
binlog_format=row
skip-name-resolve
server-id=51
gtid-mode=on
enforce-gtid-consistency=true
log-slave-updates=1
[mysql]
socket=/tmp/mysql.sock
prompt=3306 [\\d]>

#slave1
[root@db04 ~]# cat /etc/my.cnf
[mysqld]
basedir=/application/mysql
datadir=/application/mysql/data
log-error=/application/mysql/data
port=3306
socket=/tmp/mysql.sock
log-bin=mysql-bin
binlog_format=row
skip-name-resolve
server-id=5
gtid-mode=on
enforce-gtid-consistency=true
log-slave-updates=1
[mysql]
socket=/tmp/mysql.sock
prompt=3306 [\\d]>

#slave2
[root@db05 ~]# cat /etc/my.cnf
[mysqld]
basedir=/application/mysql
datadir=/application/mysql/data
log-error=/application/mysql/data
port=3306
socket=/tmp/mysql.sock
log-bin=mysql-bin
binlog_format=row
skip-name-resolve
server-id=6
gtid-mode=on
enforce-gtid-consistency=true
log-slave-updates=1
[mysql]
socket=/tmp/mysql.sock
prompt=3306 [\\d]>

#三节点
systemctl restart mysqld

测试启动情况：
mysql -uroot -p123 -e "show variables like 'server_id'"


#master:
grant replication slave  on *.* to repl@'10.0.0.%' identified by '123';

#slave1\slave2
change master to master_host='10.0.0.4',master_user='repl',master_password='123' ,MASTER_AUTO_POSITION=1;

start slave;


# 问题多次操作 出现 slave_IO_running:ON的问题
查看日志:[ERROR] Slave I/O: Got fatal error 1236 from master when reading data from binary log:
解决:清空binlog日志
3306 [(none)]>show binary logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000001 |     65393 |
| mysql-bin.000002 |   1206100 |
| mysql-bin.000003 |   1334180 |
| mysql-bin.000004 |       254 |
| mysql-bin.000005 |    643586 |
| mysql-bin.000006 |       231 |
+------------------+-----------+
6 rows in set (0.00 sec)

3306 [(none)]>reset master;
Query OK, 0 rows affected (0.01 sec)

```

# MHA高可用及读写分离

软件简介
MHA能够在较短的时间内实现自动故障检测和故障转移，通常在10-30秒以内;在复制框架中，MHA能够很好地解决复制过程中的数据一致性问题，由于不需要在现有的replication中添加额外的服务器，仅需要一个manager节点，而一个Manager能管理多套复制，所以能大大地节约服务器的数量;另外，安装简单，无性能损耗，以及不需要修改现有的复制部署也是它的优势之处。
MHA还提供在线主库切换的功能，能够安全地切换当前运行的主库到一个新的主库中(通过将从库提升为主库),大概0.5-2秒内即可完成。
MHA由两部分组成：MHA Manager（管理节点）和MHA Node（数据节点）。MHA Manager可以独立部署在一台独立的机器上管理多个Master-Slave集群，也可以部署在一台Slave上。当Master出现故障时，它可以自动将最新数据的Slave提升为新的Master,然后将所有其他的Slave重新指向新的Master。整个故障转移过程对应用程序是完全透明的。

**工作流程**
1)把宕机的master二进制日志保存下来。
2)找到binlog位置点最新的slave。
3)在binlog位置点最新的slave上用relay log（差异日志）修复其它slave。
4)将宕机的master上保存下来的二进制日志恢复到含有最新位置点的slave上。
5)将含有最新位置点binlog所在的slave提升为master。
6)将其它slave重新指向新提升的master，并开启主从复制。

**工具介绍**
MHA软件由两部分组成，Manager工具包和Node工具包，具体的说明如下：
Manager工具包主要包括以下几个工具：

manager 工具
```
masterha_check_ssh              #检查MHA的ssh-key
masterha_check_repl             #检查主从复制情况
masterha_manger                 #启动MHA
masterha_check_status           #检测MHA的运行状态
masterha_master_monitor         #检测master是否宕机
masterha_master_switch          #手动故障转移
masterha_conf_host              #手动添加server信息
masterha_secondary_check        #建立TCP连接从远程服务器
masterha_stop                   #停止MHA
```
Node工具包主要包括以下几个工具：
```
save_binary_logs                #保存宕机的master的binlog
apply_diff_relay_logs           #识别relay log的差异
filter_mysqlbinlog              #防止回滚事件
purge_relay_logs                #清除中继日志
```

MHA优点总结
1）Masterfailover and slave promotion can be done very quickly
自动故障转移快
2）Mastercrash does not result in data inconsistency
主库崩溃不存在数据一致性问题
3）Noneed to modify current MySQL settings (MHA works with regular MySQL)
不需要对当前mysql环境做重大修改
4）Noneed to increase lots of servers
不需要添加额外的服务器(仅一台manager就可管理上百个replication)
5）Noperformance penalty
性能优秀，可工作在半同步复制和异步复制，当监控mysql状态时，仅需要每隔N秒向master发送ping包(默认3秒)，所以对性能无影响。你可以理解为MHA的性能和简单的主从复制框架性能一样。
6）Works with any storage engine
只要replication支持的存储引擎，MHA都支持，不会局限于innodb

**环境准备**
```
#master
[root@db03 ~]# cat /etc/redhat-release;uname -r ;hostname -I
CentOS Linux release 7.9.2009 (Core)
3.10.0-1160.el7.x86_64
10.0.0.4
#slave1
[root@db04 data]#  cat /etc/redhat-release;uname -r ;hostname -I
CentOS Linux release 7.9.2009 (Core)
3.10.0-1160.el7.x86_64
10.0.0.5
#slave2
[root@db05 ~]#  cat /etc/redhat-release;uname -r ;hostname -I
CentOS Linux release 7.9.2009 (Core)
3.10.0-1160.el7.x86_64
10.0.0.6

```
安装mysql5.6.40版本,初始化 root密码123 #省略

基于GTID主从复制  #略过 配置参考
``` 
#主库配置
# vim /etc/my.cnf
[mysqld]
#主库server-id为1，从库不等于1
server_id =1
#开启binlog日志
log_bin=mysql-bin
gtid_mode=ON
log_slave_updates
enforce_gtid_consistency

#从库配置  
# vim /etc/my.cnf
[mysqld]
#主库server-id为1，从库必须大于1
server_id =5
#开启binlog日志
log_bin=mysql-bin
gtid_mode=ON
log_slave_updates
enforce_gtid_consistency
#禁用自动删除relay log 永久生效
relay_log_purge = 0
#设置只读 通过命令设置只读 mysql> set global read_only=1
#read_only=1

注：主库从库都需要开启GTID否则在做主从复制的时候就会报错：
3306 [(none)]>show global variables like '%gtid%';
+---------------------------------+-------+
| Variable_name                   | Value |
+---------------------------------+-------+
| binlog_gtid_simple_recovery     | OFF   |
| enforce_gtid_consistency        | ON    | #执行GTID一致
| gtid_executed                   |       |
| gtid_mode                       | ON    | #开启GTID模块
| gtid_owned                      |       |
| gtid_purged                     |       |
| simplified_binlog_gtid_recovery | OFF   |
+---------------------------------+-------+

```
## 部署MHA

```
# 所有节点操作
yum install perl-DBD-MySQL -y #安装依赖包
rpm -ivh mha4mysql-node-0.56-0.el6.noarch.rpm


[root@db03 MHA]# mysql -uroot -p123  #这里创建mha账号,主库配置,从库会自动同步.
3306 [(none)]>grant all privileges on *.* to mha@'10.0.0.%' identified by 'mha';


# 命令软链接
#如果不创建命令软连接，检测mha复制情况的时候会报错
ln -s /application/mysql/bin/mysqlbinlog /usr/bin/mysqlbinlog
ln -s /application/mysql/bin/mysql /usr/bin/mysql

#所有节点ssh互信
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa > /dev/null 2>&1
ssh-copy-id -i /root/.ssh/id_dsa.pub root@10.0.0.4
ssh-copy-id -i /root/.ssh/id_dsa.pub root@10.0.0.5
ssh-copy-id -i /root/.ssh/id_dsa.pub root@10.0.0.6

```

**部署管理节点（mha-manager:mysql-db03）**
```
yum -y install epel-release
yum install -y perl-Config-Tiny epel-release perl-Log-Dispatch perl-Parallel-ForkManager perl-Time-HiRes
rpm -ivh /tmp/mha4mysql-manager-0.56-0.el6.noarch.rpm

#编辑配置文件
[root@db05 ~]# mkdir -p /etc/mha
[root@db05 ~]# mkdir -p /var/log/mha/app1
[root@db05 ~]# cat /etc/mha/app1.cnf
[server default]
manager_log=/var/log/mha/app1/manager
manager_workdir=/var/log/mha/app1
master_binlog_dir=/application/mysql/data
user=mha
password=mha
ping_interval=2
repl_password=123
repl_user=repl
ssh_user=root
[server1]
hostname=10.0.0.4
port=3306
[server2]
candidate_master=1
check_repl_delay=0
hostname=10.0.0.5
port=3306
[server3]
hostname=10.0.0.6
port=3306

```
启动测试
```
#测试ssh
[root@mysql-db05 ~]# masterha_check_ssh --conf=/etc/mha/app1.cnf
#看到如下字样，则测试成功
Tue Mar  7 01:03:33 2017 - [info] All SSH connection tests passed successfully.
#测试复制
[root@mysql-db05 ~]# masterha_check_repl --conf=/etc/mha/app1.cnf
#看到如下字样，则测试成功
MySQL Replication Health is OK.
```
启动MHA
```
[root@db05 ~]# nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &

```
切换master测试
```
#登录数据库（db02）
[root@mysql-db02 ~]# mysql -uroot -poldboy123
#检查复制情况
mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.0.0.51
                  Master_User: rep
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000006
          Read_Master_Log_Pos: 191
               Relay_Log_File: mysql-db02-relay-bin.000002
                Relay_Log_Pos: 361
        Relay_Master_Log_File: mysql-bin.000006
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
#登录数据库（db03）
[root@mysql-db03 ~]# mysql -uroot -poldboy123
#检查复制情况
mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.0.0.51
                  Master_User: rep
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000006
          Read_Master_Log_Pos: 191
               Relay_Log_File: mysql-db03-relay-bin.000002
                Relay_Log_Pos: 361
        Relay_Master_Log_File: mysql-bin.000006
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
#停掉主库
[root@mysql-db01 ~]# /etc/init.d/mysqld stop
Shutting down MySQL..... SUCCESS!
#登录数据库（db02）
[root@mysql-db02 ~]# mysql -uroot -poldboy123
#查看slave状态
mysql> show slave status\G
#db02的slave已经为空
Empty set (0.00 sec)
#登录数据库（db03）
[root@mysql-db03 ~]# mysql -uroot -poldboy123
#查看slave状态
mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.0.0.52
                  Master_User: rep
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000006
          Read_Master_Log_Pos: 191
               Relay_Log_File: mysql-db03-relay-bin.000002
                Relay_Log_Pos: 361
        Relay_Master_Log_File: mysql-bin.000006
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
```

测试成功后 修复主从
```
[root@db05 ~]# vi /var/log/mha/app1/manager  # 查看切换过程日志
All other slaves should start replication from here. Statement should be: CHANGE MASTER TO MASTER_HOST='10.0.0.5', MASTER_PORT=3306, MASTER_AUTO_POSITION=1, MASTER_USER='repl', MASTER_PASSWORD='xxx';
#这里有提示 命令   xxx修改成 repl的密码123

# 之前的坏的主库修复后,指向新的主库
[root@db03 data]# mysql -uroot -p123
3306 [(none)]>change master to master_host='10.0.0.5',master_user='repl',master_password='123' ,MASTER_AUTO_POSITION=1;
3306 [(none)]>start slave;
3306 [(none)]>show slave status\G

#修改mha配置  #修复的主机地址添加回来
[root@db05 ~]# vi /etc/mha/app1.cnf
[server2]
hostname=10.0.0.4
port=3306

#启动MHA
[root@db05 ~]# nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &

```

# 来配置vip漂移
VIP漂移的两种方式
    1）通过keepalived的方式，管理虚拟IP的漂移
    2）通过MHA自带脚本方式，管理虚拟IP的漂移

master_ip_failover 脚本文件
```
[root@db05 ~]# ll /tmp/master_ip_failover
-rwxr-x---. 1 root root 2248 Dec 29 19:20 /tmp/master_ip_failover
[root@db05 ~]# cat /tmp/master_ip_failover
#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Getopt::Long;

my (
    $command,          $ssh_user,        $orig_master_host, $orig_master_ip,
    $orig_master_port, $new_master_host, $new_master_ip,    $new_master_port
);

my $vip = '10.0.0.55/24';
my $key = '1';
my $ssh_start_vip = "/sbin/ifconfig eth1:$key $vip";
my $ssh_stop_vip = "/sbin/ifconfig eth1:$key down";

GetOptions(
    'command=s'          => \$command,
    'ssh_user=s'         => \$ssh_user,
    'orig_master_host=s' => \$orig_master_host,
    'orig_master_ip=s'   => \$orig_master_ip,
    'orig_master_port=i' => \$orig_master_port,
    'new_master_host=s'  => \$new_master_host,
    'new_master_ip=s'    => \$new_master_ip,
    'new_master_port=i'  => \$new_master_port,
);

exit &main();

sub main {

    print "\n\nIN SCRIPT TEST====$ssh_stop_vip==$ssh_start_vip===\n\n";

    if ( $command eq "stop" || $command eq "stopssh" ) {

        my $exit_code = 1;
        eval {
            print "Disabling the VIP on old master: $orig_master_host \n";
            &stop_vip();
            $exit_code = 0;
        };
        if ($@) {
            warn "Got Error: $@\n";
            exit $exit_code;
        }
        exit $exit_code;
    }
    elsif ( $command eq "start" ) {

        my $exit_code = 10;
        eval {
            print "Enabling the VIP - $vip on the new master - $new_master_host \n";
            &start_vip();
            $exit_code = 0;
        };
        if ($@) {
            warn $@;
            exit $exit_code;
        }
        exit $exit_code;
    }
    elsif ( $command eq "status" ) {
        print "Checking the Status of the script.. OK \n";
        exit 0;
    }
    else {
        &usage();
        exit 1;
    }
}

sub start_vip() {
    `ssh $ssh_user\@$new_master_host \" $ssh_start_vip \"`;
}
sub stop_vip() {
     return 0  unless  ($ssh_user);
    `ssh $ssh_user\@$orig_master_host \" $ssh_stop_vip \"`;
}

sub usage {
    print
    "Usage: master_ip_failover --command=start|stop|stopssh|status --orig_master_host=host --orig_master_ip=ip --orig_master_port=port --new_master_host=host --new_master_ip=ip --new_master_port=port\n";
}[root@db05 ~]# vi /tmp/master_ip_failover
[root@db05 ~]# ll /tmp/master_ip_failover
-rwxr-x---. 1 root root 2248 Dec 29 19:20 /tmp/master_ip_failover
[root@db05 ~]# cat /tmp/master_ip_failover
#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Getopt::Long;

my (
    $command,          $ssh_user,        $orig_master_host, $orig_master_ip,
    $orig_master_port, $new_master_host, $new_master_ip,    $new_master_port
);

my $vip = '10.0.0.55/24';
my $key = '1';
my $ssh_start_vip = "/sbin/ifconfig eth1:$key $vip";
my $ssh_stop_vip = "/sbin/ifconfig eth1:$key down";

GetOptions(
    'command=s'          => \$command,
    'ssh_user=s'         => \$ssh_user,
    'orig_master_host=s' => \$orig_master_host,
    'orig_master_ip=s'   => \$orig_master_ip,
    'orig_master_port=i' => \$orig_master_port,
    'new_master_host=s'  => \$new_master_host,
    'new_master_ip=s'    => \$new_master_ip,
    'new_master_port=i'  => \$new_master_port,
);

exit &main();

sub main {

    print "\n\nIN SCRIPT TEST====$ssh_stop_vip==$ssh_start_vip===\n\n";

    if ( $command eq "stop" || $command eq "stopssh" ) {

        my $exit_code = 1;
        eval {
            print "Disabling the VIP on old master: $orig_master_host \n";
            &stop_vip();
            $exit_code = 0;
        };
        if ($@) {
            warn "Got Error: $@\n";
            exit $exit_code;
        }
        exit $exit_code;
    }
    elsif ( $command eq "start" ) {

        my $exit_code = 10;
        eval {
            print "Enabling the VIP - $vip on the new master - $new_master_host \n";
            &start_vip();
            $exit_code = 0;
        };
        if ($@) {
            warn $@;
            exit $exit_code;
        }
        exit $exit_code;
    }
    elsif ( $command eq "status" ) {
        print "Checking the Status of the script.. OK \n";
        exit 0;
    }
    else {
        &usage();
        exit 1;
    }
}

sub start_vip() {
    `ssh $ssh_user\@$new_master_host \" $ssh_start_vip \"`;
}
sub stop_vip() {
     return 0  unless  ($ssh_user);
    `ssh $ssh_user\@$orig_master_host \" $ssh_stop_vip \"`;
}

sub usage {
    print
    "Usage: master_ip_failover --command=start|stop|stopssh|status --orig_master_host=host --orig_master_ip=ip --orig_master_port=port --new_master_host=host --new_master_ip=ip --new_master_port=port\n";
}
```

```
配置步骤
上传准备好的/usr/local/bin/master_ip_failover
dos2unix /usr/local/bin/master_ip_failover  #widows复制过来的文件需要转换一下
#编辑配置文件
[root@mysql-db03 ~]# vim /etc/mha/app1.cnf
#在[server default]标签下添加
[server default]
#使用MHA自带脚本
master_ip_failover_script=/usr/local/bin/master_ip_failover


#根据配置文件中脚本路径编辑
[root@mysql-db05 ~]# vim /usr/local/bin/master_ip_failover
#修改以下几行内容
my $vip = '10.0.0.55/24';   #这里修改成同网段空闲的地址
my $key = '0';               #key是网卡名称后拼接:0 
#这里网卡名称eth0 是本地上的网络名称
my $ssh_start_vip = "/sbin/ifconfig eth0:$key $vip";  
my $ssh_stop_vip = "/sbin/ifconfig eth0:$key down"; 
-----------------------------
my $vip = '10.0.0.55/24';
my $key = '0';
my $ssh_start_vip = "/sbin/ifconfig ens33:$key $vip";
my $ssh_stop_vip = "/sbin/ifconfig ens33:$key down";
------------------------

#添加执行权限，否则mha无法启动
[root@mysql-db03 ~]# chmod +x /usr/local/bin/master_ip_failover

# 主库上手动绑定vip
ifconfig ens33:0 10.0.0.55/24
[root@db03 MHA]# ip a|grep ens33
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    inet 10.0.0.5/24 brd 10.0.0.255 scope global dynamic ens33
    inet 10.0.0.55/24 brd 10.0.0.255 scope global secondary ens33:1

```

测试ip漂移

```
#登录slave1
# mysql -uroot -poldboy123
#查看slave信息
3306 [(none)]>show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.0.0.4
                  Master_User: repl
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000002
          Read_Master_Log_Pos: 191
               Relay_Log_File: db04-relay-bin.000002
                Relay_Log_Pos: 361
        Relay_Master_Log_File: mysql-bin.000002
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes

#停掉主库
[root@db03 MHA]# systemctl stop mysqld

#在slave3上查看从库slave信息
3306 [(none)]>show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.0.0.5
                  Master_User: repl
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000003
          Read_Master_Log_Pos: 231
               Relay_Log_File: db05-relay-bin.000002
                Relay_Log_Pos: 361
        Relay_Master_Log_File: mysql-bin.000003
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes

#在主库 上查看vip信息
[root@db03 MHA]# ip a|grep ens33
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    inet 10.0.0.4/24 brd 10.0.0.255 scope global dynamic ens33

#在slave1 上查看vip信息
[root@db04 data]# ip a|grep ens33
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    inet 10.0.0.5/24 brd 10.0.0.255 scope global dynamic ens33
    inet 10.0.0.55/24 brd 10.0.0.255 scope global secondary ens33:1

```
## 邮件提醒
```
# 这里写一个发送邮件的脚本放到/usr/local/bin/send
1. 参数：
report_script=/usr/local/bin/send
2. 准备邮件脚本
send_report
(1)准备发邮件的脚本(上传 email_2019-最新.zip中的脚本，到/usr/local/bin/中)
(2)将准备好的脚本添加到mha配置文件中,让其调用

3. 修改manager配置文件，调用邮件脚本
vi /etc/mha/app1.cnf
report_script=/usr/local/bin/send

（3）停止MHA
masterha_stop --conf=/etc/mha/app1.cnf
（4）开启MHA    
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &
        
(5) 关闭主库,看警告邮件  
故障修复：
1. 恢复故障节点
（1）实例宕掉
/etc/init.d/mysqld start 
（2）主机损坏，有可能数据也损坏了
备份并恢复故障节点。
2.恢复主从环境
看日志文件：
CHANGE MASTER TO MASTER_HOST='10.0.0.52', MASTER_PORT=3306, MASTER_AUTO_POSITION=1, MASTER_USER='repl', MASTER_PASSWORD='123';
start slave ;
3.恢复manager
3.1 修好的故障节点配置信息，加入到配置文件
[server1]
hostname=10.0.0.51
port=3306
3.2 启动manager   
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &

```
## 配置binlog-server
防止主库连接不上,用来存储binlog日志

```
binlogserver配置：
找一台额外的机器，必须要有5.6以上的版本，支持gtid并开启，我们直接用的第二个slave（db03）
[root@mysql-db03 ~]# vim /etc/mha/app1.cnf
[binlog1]
no_master=1
hostname=10.0.0.6
master_binlog_dir=/data/mysql/binlog/

#创建备份binlog目录
mkdir -p /data/mysql/binlog/
cd /data/mysql/binlog/
#备份binlog  #binlog 实时拉取主库上的binlog日志.
mysqlbinlog  -R --host=10.0.0.5 --user=mha --password=mha --raw  --stop-never mysql-bin.000001 &
#启动mha
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &
注意：
	拉取日志的起点,需要按照目前从库的已经获取到的二进制日志点为起点


```
测试binlog 备份
```
[root@db05 binlog]# ll
total 12
-rw-rw----. 1 root root 427 Dec 30 00:23 mysql-bin.000001
-rw-rw----. 1 root root 463 Dec 30 00:23 mysql-bin.000002
-rw-rw----. 1 root root 231 Dec 30 00:23 mysql-bin.000003

# 登录主库
[root@db04 ~]# mysql -uroot -p123
3306 [(none)]>flush logs;

# 再次查看binlog目录
[root@db05 binlog]# ll
total 16
-rw-rw----. 1 root root 427 Dec 30 00:23 mysql-bin.000001
-rw-rw----. 1 root root 463 Dec 30 00:23 mysql-bin.000002
-rw-rw----. 1 root root 278 Dec 30 00:37 mysql-bin.000003
-rw-rw----. 1 root root 231 Dec 30 00:37 mysql-bin.000004

```

故障处理
```
主库宕机，binlogserver 自动停掉，manager 也会自动停止。
处理思路：
1、重新获取新主库的binlog到binlogserver中
2、重新配置文件binlog server信息
3、最后再启动MHA
```

# mysql中间件Atlas
 Atlas是由 Qihoo 360, Web平台部基础架构团队开发维护的一个基于MySQL协议的数据中间层项目。
它是在mysql-proxy 0.8.2版本的基础上，对其进行了优化，增加了一些新的功能特性。
360内部使用Atlas运行的mysql业务，每天承载的读写请求数达几十亿条。
下载地址
https://github.com/Qihoo360/Atlas/releases
注意：
1、Atlas只能安装运行在64位的系统上
2、Centos 5.X安装 Atlas-XX.el5.x86_64.rpm，Centos 6.X安装Atlas-XX.el6.x86_64.rpm。
3、后端mysql版本应大于5.1，建议使用Mysql 5.6以上

Atlas主要功能
    1.读写分离
    2.从库负载均衡
    3.IP过滤
    4.自动分表
    5.DBA可平滑上下线DB
    6.自动摘除宕机的DB

```
#安装
[root@db03 MHA]# rpm -ivh Atlas-2.2.1.el6.x86_64.rpm

#生成密码
[root@db03 MHA]# cd /usr/local/mysql-proxy/bin/
[root@db03 bin]# ./encrypt 123
3yb5jEku5h4=

[root@db03 bin]# cat /usr/local/mysql-proxy/conf/test.cnf
[mysql-proxy]
admin-username = user
admin-password = pwd
#Atlas后端连接的MySQL主库的IP和端口，可设置多项，用逗号分隔
proxy-backend-addresses = 10.0.0.55:3306
#Atlas后端连接的MySQL从库的IP和端口
proxy-read-only-backend-addresses = 10.0.0.4:3306,10.0.0.6:3306
#用户名与其对应的加密过的MySQL密码
pwds = root:3yb5jEku5h4=,repl:3yb5jEku5h4=,mha:O2jBXONX098=
daemon = true
keepalive = true
event-threads = 8
log-level = message
log-path = /usr/local/mysql-proxy/log
#SQL日志的开关
sql-log=ON
admin-address = 0.0.0.0:2345
#Atlas监听的工作接口IP和端口
proxy-address = 0.0.0.0:3307
#默认字符集，设置该项后客户端不再需要执行SET NAMES语句
charset=utf8

#启动Atlas
[root@db03 bin]# /usr/local/mysql-proxy/bin/mysql-proxyd test start


```

Atlas 管理操作
```
#用atlas管理用户登录
[root@mysql-db01 ~]# mysql -uuser -ppwd -h127.0.0.1 -P2345
#查看可用命令帮助
mysql> select * from help;
#查看后端代理的库
mysql> SELECT * FROM backends;
+-------------+----------------+-------+------+
| backend_ndx | address        | state | type |
+-------------+----------------+-------+------+
|           1 | 10.0.0.51:3307 | up    | rw   |
|           2 | 10.0.0.53:3307 | up    | ro   |
|           3 | 10.0.0.52:3307 | up    | ro   |
+-------------+----------------+-------+------+
#平滑摘除mysql
mysql> REMOVE BACKEND 2;
Empty set (0.00 sec)
#检查是否摘除成功
mysql> SELECT * FROM backends;
+-------------+----------------+-------+------+
| backend_ndx | address        | state | type |
+-------------+----------------+-------+------+
|           1 | 10.0.0.51:3307 | up    | rw   |
|           2 | 10.0.0.52:3307 | up    | ro   |
+-------------+----------------+-------+------+
#保存到配置文件中
mysql> SAVE CONFIG;
Empty set (0.06 sec)
```
atlas读写功能测试
```
[root@db03 bin]# mysql -umha -pmha -h 10.0.0.4 -P3307
3306 [(none)]>select @@server_id;
3306 [(none)]>begin;select @@server_id;commit;

```

生产用户要求

```
开发人员申请一个应用用户 app(  select  update  insert)  密码123456,要通过10网段登录
1. 在主库中,创建用户
grant select ,update,insert on *.* to app@'10.0.0.%' identified by '123456';
2. 在atlas中添加生产用户
/usr/local/mysql-proxy/bin/encrypt  123456      ---->制作加密密码
vim test.cnf
pwds = repl:3yb5jEku5h4=,mha:O2jBXONX098=,app:/iZxz+0GRoA=
/usr/local/mysql-proxy/bin/mysql-proxyd test restart
[root@db03 conf]# mysql -uapp -p123456  -h 10.0.0.4 -P 33060
```





# MySQL性能优化

一、优化工具：

## 1、系统优化工具
1.1 top 
(1)简介：
	实时监控当前操作系统的负载情况的，每秒刷新一次状态,通常会关注三大指标（CPU、MEM、IO）
	
（2）评判标准	
（2.1）	整体的负载情况，判断标准，如果值非常高，只能告诉我们操作系统很繁忙
		load average: 0.00, 0.00, 0.00    
（2.2）CPU使用情况
	Cpu(s):  0.2%us,  0.2%sy, 99.7%id,  0.0%wa
	%id:   CPU空闲的百分比
	问一个问题？你觉得在一个已投产的系统中ID值是高好还是低好呢？
	一般情况下我们建议，95%以下都算是正常的，但是呢，我们去准备硬件的时候，一般都会预留一部分（3年）硬件配置
	%us:用户程序，占用的CPU时间片的百分比。我们认为us%高是好事，但要在cpu正常能力范围内。
	%sy:系统程序（和内核工作有关），资源调配，资源管理，内核其他功能的管理（system call）
		对于比较成熟的操作系统，对sy%应该是占比很少的。我们认为越少越好。
		如果飙升，可能说明两件事情，1，系统bug；2，中病毒了
	%wa 这个参数越少越好。如果wait高说明了，
							1，IO很慢（速度慢，全表扫描）
							2、内存满了OOM（内存小，全表扫描）
																		
（2.3）
Mem:   4040596k total,  1692536k used,  2348060k free,   152348k buffers
Swap:   786428k total,        0k used,   786428k free,   620256k cached

Mem：
	total：总的内存量
	used：已经被使用的内存量
	free：空闲的内存空间
	buffer：专门负责操作系统当中，与文件修改类操作有关的内存缓冲区（专门负责写操作的），可以被重复利用的内存区域
	cached：专门负责操作系统当中，与文件读取有关的缓存区域（专门负责文件读取操作的），
对于操作系统可用内存量=free+buffer+cached
used：used=RSS+anon+buffer+cached


补充：
1.Linux操作系统内存划分的三大区域：
	RSS：常驻内存集，主要负责程序运行需要的内存区域
	Page Cache：文件系统缓存，主要负责文件有关的缓冲和缓存，buffer+cached
	anon page: 匿名页，主要负责程序之间交互时使用到内存区域

2.连续的地址位，定义为了page（页），并且进行了量化。

（1）基于固定大小page分配模式，他的一些不足的地方？
     在申请内存时，需要整个内存进行遍历
	 会有大量的内存碎片，导致程序OOM（out of memory）
（2）SLAB Allocator内存管理子系统
	1、将内存逻辑化成chain+chunk模式，内存区域会有多条链。每条chain下都“挂着”多个等同大小的chunk（2的幂）
	2、在每条链的头部，都会有一个专门的chunk位图，来更快速的找到需要的空闲chunk，并且记录每个chunk最后被访问的时间戳。
	
（3）buddy system（伙伴系统）
	1、提供了多种内存实现回收和整理内存碎片算法，最经典的就是LRU算法。 
	2、当内存free空间紧张时，会触发进行整理或释放，不再使用buffer和cached
通过以下命令，手工释放所有buffer和cached
echo 3 > /proc/sys/vm/drop_caches 


SWAP：交换分区，当内存紧张的时候，会将内存区域当中的数据临时置换到SWAP中。
默认：在内存使用量达到60%
[root@db02 ~]# cat /proc/sys/vm/swappiness 
60
对于MySQL环境，要尽量避免swap使用
sysctl.conf 
临时修改：
[root@db02 ~]# echo 0 >/proc/sys/vm/swappiness 

2、iostat 
测试当前环境IO水平
mount /dev/sdb /data
iostat -dm 1 /dev/sdb
dd if=/dev/zero of=/data/bigfile

在优化过程中，我们一般会结合CPU和内存的使用情况看IO状态

CPU非常繁忙（MYSQL）：
		1、user 很高
			再看IO水平，正常情况下IO也会很高
			不正常的情况，user很高，但是IO很低？
			在做大量的计算（多表连接查询、排序、分组、子查询很复杂或者很频繁）
		2、wait 很高
		   IO很少
				（1）很有可能是全表扫描
				（2）IO有问题（RAID规划或者磁盘IO本身问题）

3、vmstat
vmstat 1 10

4、dstat
yum install -y dstat 

2、数据库层面优化工具
基础优化命令工具
（1）mysql
用法举例：查看数据库当前的一些性能指标
mysql -uroot -p123 -e "show status like '%lock%'"

（2）SHOW ENGINE INNODB STATUS
mysql> show engine innodb status\G
一般关注比较多的：
内存、锁相关
（3）show index
（4）Information Schema
（5）mysql库下的  innodb_table_stats  innodb_index_stats
 (6)  SHOW [SESSION | GLOBAL] STATUS
 		3306 [(none)]>show status; #当前会话
 		3306 [(none)]>show global status; #全局状态

 (7) SHOW [FULL]  PROCESSLIST(应急调优)
 		3306 [(none)]>show full processlist; #当前MySQL会话列表
 (8) explain   #执行计划
 (9) mysqldumpslow （pt-query-diagest）#分析慢日志

深度优化命令工具（扩展）
mysqlslap
sysbench
tpcc
Performance Schema(5.7默认开启)

-----------------------------------------
## 二、硬件优化：
主机：
根据数据库类型
（1）主机CPU选择
	IO密集型：可以处理多并发的CPU类型，特点是核心数量较多，主频中等
			  Intel E系列
	CPU密集型：可以处理高性能计算的cpu类型，主频非常高，核心数量中等
			  Intel I系列的
	MySQL的线上业务，处理高并发访问的业务。属于IO密集型的业务，所以选择志强系列的CPU更好一些。
	MySQL非线上的业务，数据处理数据分析，属于CPU密集型业务，所以选择I系列的CPU。
	
（2）内存容量选择
	一般是选择cpu核心数量的2倍
		
（3）IO的选择
	1、磁盘选择
	SATAIII   SAS   FC  SSD   pci-e SSD  Flash	
	主机 RAID卡的BBU(Battery Backup Unit)关闭 #备用电池
存储（有条件的公司会选择单独存储设备）：
	根据存储数据种类的不同，选择不同的存储设备
	配置合理的RAID级别(raid5、raid10、热备盘)
	raid0   ：性能高（条带化），安全性和单盘一样
	raid1   ：安全性高（镜像功能），性能和单盘一样
	raid10  ：读写性能都很高（0级别条带化功能），安全性高（1级别，镜像功能），企业如果有条件推荐的一种raid级别
	raid5   ：较好的安全性（校验），较好的性能（条带化功能，读性能比较高，写性能一般），对于读多写少的业务可以使用此级别
	
高端存储：IBM EMC  HDS，一般都是raid1（就是raid10） ，自带条带化功能，而且只支持4块盘做一个raid


使用合适raid级别，避免过度条带化	
IOPS峰值：对于每一块硬件磁盘来讲，都有一个固定参数IOPS，每秒最多能够进行的IO的次数。   


网络设备：
	使用流量支持更高的网络设备（交换机、路由器、网线、网卡、HBA卡）
网卡绑定：
	bonding     0模式负载均衡模式   1主备模式
	
交换机：堆叠



## 三、系统层面优化：

1、Swap调整
```
/proc/sys/vm/swappiness的内容改成0（临时）
echo 0>/proc/sys/vm/swappiness

/etc/sysctl.conf上添加vm.swappiness=0（永久）
#vim /etc/sysctl.conf 
vm.swappiness=0

# sysctl -p #命令生效
```
这个参数决定了Linux是倾向于使用swap，还是倾向于释放文件系统cache。在内存紧张的情况下，数值越低越倾向于释放文件系统cache。
当然，这个参数只能减少使用swap的概率，并不能避免Linux使用swap。


2、IO调度策略
```
临时修改：
[root@db02 ~]# cat /sys/block/sda/queue/scheduler 
noop anticipatory deadline [cfq] 
[root@db02 ~]# cat /sys/block/sdb/queue/scheduler 
noop anticipatory deadline [cfq] 
[root@db02 ~]# echo deadline >/sys/block/sda/queue/scheduler
[root@db02 ~]# echo deadline >/sys/block/sdb/queue/scheduler
[root@db02 ~]# cat /sys/block/sdb/queue/scheduler 
noop anticipatory [deadline] cfq 
[root@db02 ~]# 
永久修改：
更改到如下内容: 修改grub.conf 增加elevator=deadline
kernel /vmlinuz-2.6.32-696.el6.x86_64 ro root=UUID=40c9133f-6007-485c-be19-4082c8361df3 rd_NO_LUKS rd_NO_LVM LANG=en_US.UTF-8
rd_NO_MD SYSFONT=latarcyrheb-sun16 crashkernel=auto  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM elevator=deadline rhgb quiet
```
3、FS：
	NO  LVM  #不要用lvm性能不好
	ext4或xfs
	ssd（binlog  relay）#binlog 和relay log 单独存到ssd盘上


4、关闭无用服务
	chkconfig --level 23456 acpid off
	chkconfig --level 23456 anacron off
	chkconfig --level 23456 autofs off
	chkconfig --level 23456 avahi-daemon off
	chkconfig --level 23456 bluetooth off
	chkconfig --level 23456 cups off
	chkconfig --level 23456 firstboot off
	chkconfig --level 23456 haldaemon off
	chkconfig --level 23456 hplip off
	chkconfig --level 23456 ip6tables off
	chkconfig --level 23456 iptables  off
	chkconfig --level 23456 isdn off
	chkconfig --level 23456 pcscd off
	chkconfig --level 23456 sendmail  off
	chkconfig --level 23456 yum-updatesd  off
	
以上：硬件优化建议，操作系统优化建议，应该在业务架构搭建初始应该做好。	
	
	
## 四、数据库层面优化：
4.1	参数优化（见参数优化建议）

4.2	数据库索引优化(见索引管理章节)
4.3	锁优化
4.4	数据库架构优化（扩展）


4.3	锁优化
MyIASM： 表级锁
优点：申请和释放时，需要更少系统资源，减少死锁产生。
缺点：不利于并发处理，在某个事务在对表进行修改操作时，会锁定整个表，其他事务只能等待完成之后，才能操作。
有非常严重的锁等待。

InnoDB：
	支持行级锁，行级锁在索引锁。如果表中没有任何索引，那么我们做表数据处理的时候，依然会表级锁。
	GAP锁：主要针对范围数据操作时
	

死锁的处理过程：

1、show processlist
2、show  engine innodb status\G;
LOCK WAIT 2 lock struct(s), heap size 1184, 1 row lock(s)
MySQL thread id 4, OS thread handle 0x7f37d66f0700, query id 44 localhost root Sending data
select * from t1 where id=3 for update
Trx read view will not see trx with id >= 2323, sees < 2323
------- TRX HAS BEEN WAITING 3 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 14 page no 3 n bits 72 index `GEN_CLUST_INDEX` of table `test`.`t1` trx id 2322 lock_mode X waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 5; compact format; info bits 0

3、kill 4;

避免死锁的方法：
（1）将index lock 转换为table lock
set autocommit=0;
lock table t1;
insert to
update
delete
commit
unlock table t1;

（2）将所有事务处理表数据的顺序尽量保证一致。

4.4架构优化扩展
高可用
读写分离
分布式架构（分库分表）



# mysql参数优化建议

```
MySQL参数优化测试建议

一、参数优化前压力测试
0、优化测试前提
MacBook：虚拟机vm12.5，OS centos 6.9（系统已优化），cpu*2（I5 4288u 2.6GHZ）,MEM*4GB ,HardDisk:Apple SSD(SM-0512F)

1、模拟数据库数据
为了测试我们创建一个test1的库创建一个tb1的表，然后导入20万行数据，脚本如下：
vim slap.sh
#!/bin/bash  
HOSTNAME="localhost" 
PORT="3306" 
USERNAME="root" 
PASSWORD="123" 
DBNAME="oldboy" 
TABLENAME="lufei" 
#create database 
mysql -h ${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} -e "drop database if exists ${DBNAME}" 
create_db_sql="create database if not exists ${DBNAME}" 
mysql -h ${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} -e "${create_db_sql}" 
#create table 
create_table_sql="create table if not exists ${TABLENAME}(stuid int not null primary key,stuname varchar(20) not null,stusex char(1)   
not null,cardid varchar(20) not null,birthday datetime,entertime datetime,address varchar(100) default null)" 
mysql -h ${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${create_table_sql}" 
#insert data to table 
i="1" 
while [ $i -le 200000 ]  
do  
insert_sql="insert into ${TABLENAME}  values($i,'guojialei_$i','1','110011198809163418','1988-09-16','2017-09-13','oldboyedu_$i')"
mysql -h ${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${insert_sql}"
let i++  
done  
#select data  
select_sql="select count(*) from ${TABLENAME}" 
mysql -h ${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${select_sql}"

执行脚本：
sh slap.sh

2、检查数据可用性
mysql -uroot -p123
select count(*) from oldboy.lufei;

3、在没有优化之前我们使用mysqlslap来进行压力测试
mysqlslap --defaults-file=/etc/my.cnf \
--concurrency=100 --iterations=1 --create-schema='oldboy' \
--query='select * from oldboy.lufei where stuname="guojialei_100"' engine=innodb \
--number-of-queries=3000 -uroot -p123 -verbose

Benchmark
        Running for engine rbose
        Average number of seconds to run all queries: 88.360 seconds
        Minimum number of seconds to run all queries: 88.360 seconds
        Maximum number of seconds to run all queries: 88.360 seconds
        Number of clients running queries: 100
        Average number of queries per client: 30

	
--------------------------------mysqlslap使用说明----------------------------
mysqlslap工具介绍
​ mysqlslap来自于mariadb包，测试的过程默认生成一个mysqlslap的schema,生成测试表t1，查询和插入测试数据，mysqlslap库自动生成，如果已经存在则先删除。用--only-print来打印实际的测试过程，整个测试完成后不会在数据库中留下痕迹。

常用选项：

--auto-generate-sql, -a 自动生成测试表和数据，表示用mysqlslap工具自己生成的SQL脚本来测试并发压力
--auto-generate-sql-load-type=type 测试语句的类型。代表要测试的环境是读操作还是写操作还是两者混合的。取值包括：read，key，write，update和mixed(默认)
--auto-generate-sql-add-auto-increment 代表对生成的表自动添加auto_increment列，从5.1.18版本开始支持
--number-char-cols=N, -x N 自动生成的测试表中包含多少个字符类型的列，默认1
--number-int-cols=N, -y N 自动生成的测试表中包含多少个数字类型的列，默认1
--number-of-queries=N 总的测试查询次数(并发客户数×每客户查询次数)
--query=name,-q 使用自定义脚本执行测试，例如可以调用自定义的存储过程或者sql语句来执行测试
--create-schema 代表自定义的测试库名称，测试的schema，MySQL中schema也就是database
--commint=N 多少条DML后提交一次
--compress, -C 如服务器和客户端都支持压缩，则压缩信息
--concurrency=N, -c N 表示并发量，即模拟多少个客户端同时执行select；可指定多个值，以逗号或者--delimiter参数指定值做为分隔符
--engine=engine_name, -e engine_name 代表要测试的引擎，可以有多个，用分隔符隔开
--iterations=N, -i N 测试执行的迭代次数，代表要在不同并发环境下，各自运行测试多少次
--only-print 只打印测试语句而不实际执行
--detach=N 执行N条语句后断开重连
--debug-info, -T 打印内存和CPU的相关信息
测试示例：

1）单线程测试

[root@centos7 ~]# mysqlslap -a -uroot -p
Enter password: 
Benchmark
        Average number of seconds to run all queries: 0.004 seconds
        Minimum number of seconds to run all queries: 0.004 seconds
        Maximum number of seconds to run all queries: 0.004 seconds
        Number of clients running queries: 1
        Average number of queries per client: 0
2）多线程测试，使用--concurrency来模拟并发连接

[root@centos7 ~]# mysqlslap -uroot -p -a -c 500
Enter password: 
Benchmark
        Average number of seconds to run all queries: 3.384 seconds
        Minimum number of seconds to run all queries: 3.384 seconds
        Maximum number of seconds to run all queries: 3.384 seconds
        Number of clients running queries: 500
        Average number of queries per client: 0
3）同时测试不同的存储引擎的性能进行对比

[root@centos7 ~]# mysqlslap -uroot -p -a --concurrency=500 --number-of-queries 1000 --iterations=5 --engine=myisam,innodb --debug-info
Enter password: 
Benchmark
        Running for engine myisam
        Average number of seconds to run all queries: 0.192 seconds
        Minimum number of seconds to run all queries: 0.187 seconds
        Maximum number of seconds to run all queries: 0.202 seconds
        Number of clients running queries: 500
        Average number of queries per client: 2

Benchmark
        Running for engine innodb
        Average number of seconds to run all queries: 0.355 seconds
        Minimum number of seconds to run all queries: 0.350 seconds
        Maximum number of seconds to run all queries: 0.364 seconds
        Number of clients running queries: 500
        Average number of queries per client: 2


User time 0.33, System time 0.58
Maximum resident set size 22892, Integral resident set size 0
Non-physical pagefaults 46012, Physical pagefaults 0, Swaps 0
Blocks in 0 out 0, Messages in 0 out 0, Signals 0
Voluntary context switches 31896, Involuntary context switches 0
4）执行一次测试，分别500和1000个并发，执行5000次总查询

[root@centos7 ~]# mysqlslap -uroot -p -a --concurrency=500,1000 --number-of-queries 5000 --debug-info
Enter password: 
Benchmark
        Average number of seconds to run all queries: 3.378 seconds
        Minimum number of seconds to run all queries: 3.378 seconds
        Maximum number of seconds to run all queries: 3.378 seconds
        Number of clients running queries: 500
        Average number of queries per client: 10

Benchmark
        Average number of seconds to run all queries: 3.101 seconds
        Minimum number of seconds to run all queries: 3.101 seconds
        Maximum number of seconds to run all queries: 3.101 seconds
        Number of clients running queries: 1000
        Average number of queries per client: 5


User time 0.84, System time 0.64
Maximum resident set size 83068, Integral resident set size 0
Non-physical pagefaults 139977, Physical pagefaults 0, Swaps 0
Blocks in 0 out 0, Messages in 0 out 0, Signals 0
Voluntary context switches 31524, Involuntary context switches 3
5）迭代测试

[root@centos7 ~]# mysqlslap -uroot -p -a --concurrency=500 --number-of-queries 5000 --iterations=5 --debug-info
Enter password: 
Benchmark
        Average number of seconds to run all queries: 3.307 seconds
        Minimum number of seconds to run all queries: 3.184 seconds
        Maximum number of seconds to run all queries: 3.421 seconds
        Number of clients running queries: 500
        Average number of queries per client: 10


User time 2.18, System time 1.58
Maximum resident set size 74872, Integral resident set size 0
Non-physical pagefaults 327732, Physical pagefaults 0, Swaps 0
Blocks in 0 out 0, Messages in 0 out 0, Signals 0
Voluntary context switches 73904, Involuntary context switches 3	
----------------------------------------------------------------------------	
	
	

二、优化细节：

1、参数优化
1.1 Max_connections
（1）简介
Mysql的最大连接数，如果服务器的并发请求量比较大，可以调高这个值，当然这是要建立在机器能够支撑的情况下，因为如果连接数越来越多，mysql会为每个连接提供缓冲区，就会开销的越多的内存，所以需要适当的调整该值，不能随便去提高设值。
（2）判断依据
show variables like 'max_connections';
	+-----------------+-------+
	| Variable_name   | Value |
	+-----------------+-------+
	| max_connections | 151   |
	+-----------------+-------+
show status like 'Max_used_connections';
	+----------------------+-------+
	| Variable_name        | Value |
	+----------------------+-------+
	| Max_used_connections | 101   |
	+----------------------+-------+
如果max_used_connections跟max_connections相同,那么就是max_connections设置过低或者超过服务器的负载上限了，低于10%则设置过大.
（3）修改方式举例
vim /etc/my.cnf 
Max_connections=1024

1.2 back_log
（1）简介
mysql能暂存的连接数量，当主要mysql线程在一个很短时间内得到非常多的连接请求时候它就会起作用，如果mysql的连接数据达到max_connections时候，新来的请求将会被存在堆栈中，等待某一连接释放资源，该推栈的数量及back_log,如果等待连接的数量超过back_log，将不被授予连接资源。
back_log值指出在mysql暂时停止回答新请求之前的短时间内有多少个请求可以被存在推栈中，只有如果期望在一个短时间内有很多连接的时候需要增加它

（2）判断依据
show full processlist
发现大量的待连接进程时，就需要加大back_log或者加大max_connections的值

（3）修改方式举例
vim /etc/my.cnf 
back_log=1024

1.3 wait_timeout和interactive_timeout

（1）简介
wait_timeout：指的是mysql在关闭一个非交互的连接之前所要等待的秒数
interactive_timeout：指的是mysql在关闭一个交互的连接之前所需要等待的秒数，比如我们在终端上进行mysql管理，使用的即使交互的连接，这时候，如果没有操作的时间超过了interactive_time设置的时间就会自动的断开，默认的是28800，可调优为7200。
wait_timeout:如果设置太小，那么连接关闭的就很快，从而使一些持久的连接不起作用

（2）设置建议
如果设置太大，容易造成连接打开时间过长，在show processlist时候，能看到很多的连接 ，一般希望wait_timeout尽可能低

（3）修改方式举例
wait_timeout=1200
interactive_timeout=1200

1.4 key_buffer_size
（1）简介
key_buffer_size指定索引缓冲区的大小，它决定索引处理的速度，尤其是索引读的速度

（2）设置依据
通过key_read_requests和key_reads可以直到key_baffer_size设置是否合理。

mysql> show variables like "key_buffer_size%";
+-----------------+---------+
| Variable_name   | Value   |
+-----------------+---------+
| key_buffer_size | 8388608 |
+-----------------+---------+
1 row in set (0.00 sec)

mysql> 

mysql> show status like "key_read%";
+-------------------+-------+
| Variable_name     | Value |
+-------------------+-------+
| Key_read_requests | 10    |
| Key_reads         | 2     |
+-------------------+-------+
2 rows in set (0.00 sec)

mysql> 

一共有10个索引读取请求，有2个请求在内存中没有找到直接从硬盘中读取索引

-----------------------------------------------------
注：key_buffer_size只对myisam表起作用，即使不使用myisam表，但是内部的临时磁盘表是myisam表，也要使用该值。
可以使用检查状态值created_tmp_disk_tables得知：
mysql> show status like "created_tmp%";
+-------------------------+-------+
| Variable_name           | Value |
+-------------------------+-------+
| Created_tmp_disk_tables | 0     |
| Created_tmp_files       | 6     |
| Created_tmp_tables      | 1     |
+-------------------------+-------+
3 rows in set (0.00 sec)
mysql> 

通常地，我们习惯以 Created_tmp_tables/(Created_tmp_disk_tables + Created_tmp_tables) 或者已各自的一个时段内的差额计算，来判断基于内存的临时表利用率。所以，我们会比较关注 Created_tmp_disk_tables 是否过多，从而认定当前服务器运行状况的优劣。
看以下例子：
在调用mysqldump备份数据时，大概执行步骤如下：
180322 17:39:33       7 Connect     root@localhost on
7 Query       /*!40100 SET @@SQL_MODE='' */
7 Init DB     guo
7 Query       SHOW TABLES LIKE 'guo'
7 Query       LOCK TABLES `guo` READ /*!32311 LOCAL */
7 Query       SET OPTION SQL_QUOTE_SHOW_CREATE=1
7 Query       show create table `guo`
7 Query       show fields from `guo`
7 Query       show table status like 'guo'
7 Query       SELECT /*!40001 SQL_NO_CACHE */ * FROM `guo`
7 Query       UNLOCK TABLES
7 Quit


其中，有一步是：show fields from `guo`。从slow query记录的执行计划中，可以知道它也产生了 Tmp_table_on_disk。

所以说，以上公式并不能真正反映到mysql里临时表的利用率，有些情况下产生的 Tmp_table_on_disk 我们完全不用担心，因此没必要过分关注 Created_tmp_disk_tables，但如果它的值大的离谱的话，那就好好查一下，你的服务器到底都在执行什么查询了。 
--------------------------------------------
（3）配置方法
key_buffer_size=64M


1.5 query_cache_size
（1）简介：
查询缓存简称QC，使用查询缓冲，mysql将查询结果存放在缓冲区中，今后对于同样的select语句（区分大小写）,将直接从缓冲区中读取结果。
一个sql查询如果以select开头，那么mysql服务器将尝试对其使用查询缓存。
注：两个sql语句，只要想差哪怕是一个字符（列如大小写不一样；多一个空格等）,那么这两个sql将使用不同的一个cache。
（2）判断依据
mysql> show status like "%Qcache%";
+-------------------------+---------+
| Variable_name           | Value   |
+-------------------------+---------+
| Qcache_free_blocks      | 1       |
| Qcache_free_memory      | 1031360 |
| Qcache_hits             | 0       |
| Qcache_inserts          | 0       |
| Qcache_lowmem_prunes    | 0       |
| Qcache_not_cached       | 2002    |
| Qcache_queries_in_cache | 0       |
| Qcache_total_blocks     | 1       |
+-------------------------+---------+
8 rows in set (0.00 sec)

---------------------状态说明--------------------
Qcache_free_blocks：缓存中相邻内存块的个数。如果该值显示较大，则说明Query Cache 中的内存碎片较多了，
FLUSH QUERY CACHE会对缓存中的碎片进行整理，从而得到一个空闲块。
注：当一个表被更新之后，和它相关的cache blocks将被free。但是这个block依然可能存在队列中，除非是在队列的尾部。可以用FLUSH QUERY CACHE语句来清空free blocks
Qcache_free_memory：Query Cache 中目前剩余的内存大小。通过这个参数我们可以较为准确的观察出当前系统中的Query Cache 内存大小是否足够，是需要增加还是过多了。
Qcache_hits：表示有多少次命中缓存。我们主要可以通过该值来验证我们的查询缓存的效果。数字越大，缓存效果越理想。
Qcache_inserts：表示多少次未命中然后插入，意思是新来的SQL请求在缓存中未找到，不得不执行查询处理，执行查询处理后把结果insert到查询缓存中。这样的情况的次数越多，表示查询缓存应用到的比较少，效果也就不理想。当然系统刚启动后，查询缓存是空的，这很正常。
Qcache_hits/Qcache_hits+Qcache_inserts=命中率


Qcache_lowmem_prunes：多少条Query 因为内存不足而被清除出Query Cache。通过“Qcache_lowmem_prunes”和“Qcache_free_memory”相互结合，能够更清楚的了解到我们系统中Query Cache 的内存大小是否真的足够，是否非常频繁的出现因为内存不足而有Query 被换出。这个数字最好长时间来看；如果这个数字在不断增长，就表示可能碎片非常严重，或者内存很少。（上面的free_blocks和free_memory可以告诉您属于哪种情况）
Qcache_not_cached：不适合进行缓存的查询的数量，通常是由于这些查询不是 SELECT 语句或者用了now()之类的函数。
Qcache_queries_in_cache：当前Query Cache 中cache 的Query 数量；
Qcache_total_blocks：当前Query Cache 中的block 数量；。
-------------------------------------

（3）配置示例

mysql> show variables like '%query_cache%' ;
+------------------------------+---------+
| Variable_name                | Value   |
+------------------------------+---------+
| have_query_cache             | YES     |
| query_cache_limit            | 1048576 |
| query_cache_min_res_unit     | 4096    |
| query_cache_size             | 1048576 |
| query_cache_type             | OFF     |
| query_cache_wlock_invalidate | OFF     |
+------------------------------+---------+
6 rows in set (0.00 sec)

mysql> 

-------------------配置说明-------------------------------
以上信息可以看出query_cache_type为off表示不缓存任何查询
各字段的解释：
query_cache_limit：超过此大小的查询将不缓存
query_cache_min_res_unit：缓存块的最小大小，query_cache_min_res_unit的配置是一柄”双刃剑”，默认是4KB，设置值大对大数据查询有好处，但如果你的查询都是小数据查询，就容易造成内存碎片和浪费。
query_cache_size：查询缓存大小 (注：QC存储的最小单位是1024byte，所以如果你设定了一个不是1024的倍数的值，这个值会被四舍五入到最接近当前值的等于1024的倍数的值。)
query_cache_type：缓存类型，决定缓存什么样的查询，注意这个值不能随便设置，必须设置为数字，可选项目以及说明如下：
如果设置为0，那么可以说，你的缓存根本就没有用，相当于禁用了。
如果设置为1，将会缓存所有的结果，除非你的select语句使用SQL_NO_CACHE禁用了查询缓存。
如果设置为2，则只缓存在select语句中通过SQL_CACHE指定需要缓存的查询。

修改/etc/my.cnf,配置完后的部分文件如下：
query_cache_size=256M
query_cache_type=1

现在行业中,通过NOSQL产品改善大并发查询,比如:redis

-----------------------------------------------------
1.6 max_connect_errors
max_connect_errors是一个mysql中与安全有关的计数器值，它负责阻止过多尝试失败的客户端以防止暴力破解密码等情况，当超过指定次数，mysql服务器将禁止host的连接请求，直到mysql服务器重启或通过flush hosts命令清空此host的相关信息 max_connect_errors的值与性能并无太大关系。

修改/etc/my.cnf文件，在[mysqld]下面添加如下内容
max_connect_errors=2000

1.7 sort_buffer_size
（1）简介：
每个需要进行排序的线程分配该大小的一个缓冲区。增加这值加速ORDER BY 或GROUP BY操作，
（2）配置依据
Sort_Buffer_Size并不是越大越好，由于是connection级的参数，过大的设置+高并发可能会耗尽系统内存资源。
列如：500个连接将会消耗500*sort_buffer_size（2M）=1G内存
（3）配置方法
 修改/etc/my.cnf文件，在[mysqld]下面添加如下：
sort_buffer_size=1M

1.8 max_allowed_packet
（1）简介：
mysql根据配置文件会限制，server接受的数据包大小。
（2）配置依据：
有时候大的插入和更新会受max_allowed_packet参数限制，导致写入或者更新失败，更大值是1GB，必须设置1024的倍数
（3）配置方法：
max_allowed_packet=32M

1.9 join_buffer_size
用于表间关联缓存的大小，和sort_buffer_size一样，该参数对应的分配内存也是每个连接独享。

1.10 thread_cache_size 
(1)简介
服务器线程缓存，这个值表示可以重新利用保存在缓存中线程的数量,当断开连接时,那么客户端的线程将被放到缓存中以响应下一个客户而不是销毁(前提是缓存数未达上限),如果线程重新被请求，那么请求将从缓存中读取,如果缓存中是空的或者是新的请求，那么这个线程将被重新创建,如果有很多新的线程，增加这个值可以改善系统性能.
（2）配置依据
通过比较 Connections 和 Threads_created 状态的变量，可以看到这个变量的作用。
设置规则如下：1GB 内存配置为8，2GB配置为16，3GB配置为32，4GB或更高内存，可配置更大。
服务器处理此客户的线程将会缓存起来以响应下一个客户而不是销毁(前提是缓存数未达上限)

试图连接到MySQL(不管是否连接成功)的连接数
mysql>  show status like 'threads_%';
+-------------------+-------+
| Variable_name     | Value |
+-------------------+-------+
| Threads_cached    | 8     |
| Threads_connected | 2     |
| Threads_created   | 4783  |
| Threads_running   | 1     |
+-------------------+-------+
4 rows in set (0.00 sec)
Threads_cached :代表当前此时此刻线程缓存中有多少空闲线程。
Threads_connected :代表当前已建立连接的数量，因为一个连接就需要一个线程，所以也可以看成当前被使用的线程数。
Threads_created:代表从最近一次服务启动，已创建线程的数量，如果发现Threads_created值过大的话，表明MySQL服务器一直在创建线程，这也是比较耗资源，可以适当增加配置文件中thread_cache_size值。
Threads_running :代表当前激活的（非睡眠状态）线程数。并不是代表正在使用的线程数，有时候连接已建立，但是连接处于sleep状态。
(3)配置方法：
thread_cache_size=32

1.11 innodb_buffer_pool_size
（1）简介
对于InnoDB表来说，innodb_buffer_pool_size的作用就相当于key_buffer_size对于MyISAM表的作用一样。
（2）配置依据：
InnoDB使用该参数指定大小的内存来缓冲数据和索引。
对于单独的MySQL数据库服务器，最大可以把该值设置成物理内存的80%,一般我们建议不要超过物理内存的70%。
mysql> SHOW GLOBAL STATUS LIKE 'Innodb_buffer_pool%'
+---------------------------------------+-------------+
| Variable_name                         | Value       |
+---------------------------------------+-------------+
| Innodb_buffer_pool_dump_status        | not started |
| Innodb_buffer_pool_load_status        | not started |
| Innodb_buffer_pool_pages_data         | 1557        |
| Innodb_buffer_pool_bytes_data         | 25509888    |
| Innodb_buffer_pool_pages_dirty        | 0           |
| Innodb_buffer_pool_bytes_dirty        | 0           |
| Innodb_buffer_pool_pages_flushed      | 2305        |
| Innodb_buffer_pool_pages_free         | 63977       |
| Innodb_buffer_pool_pages_misc         | 2           |
| Innodb_buffer_pool_pages_total        | 65536       |
| Innodb_buffer_pool_read_ahead_rnd     | 0           |
| Innodb_buffer_pool_read_ahead         | 64          |
| Innodb_buffer_pool_read_ahead_evicted | 0           |
| Innodb_buffer_pool_read_requests      | 32036288    |
| Innodb_buffer_pool_reads              | 600         |
| Innodb_buffer_pool_wait_free          | 0           |
| Innodb_buffer_pool_write_requests     | 280891      |
+---------------------------------------+-------------+
17 rows in set (0.00 sec)

mysql>
Innodb_buffer_pool_pages_data
The number of pages in the InnoDB buffer pool containing data. The number includes both dirty and
clean pages.

Innodb_buffer_pool_pages_total
The total size of the InnoDB buffer pool, in pages.

Innodb_page_size
InnoDB page size (default 16KB). Many values are counted in pages; the page size enables them to be
easily converted to bytes

（3）配置方法
innodb_buffer_pool_size=1024M

1.12 innodb_flush_log_at_trx_commit
（1）简介
主要控制了innodb将log buffer中的数据写入日志文件并flush磁盘的时间点，取值分别为0、1、2三个。
0，表示当事务提交时，不做日志写入操作，而是每秒钟将log buffer中的数据写入日志文件并flush磁盘一次；
1，则在每秒钟或是每次事物的提交都会引起日志文件写入、flush磁盘的操作，确保了事务的ACID；
2，每次事务提交引起写入日志文件的动作，但每秒钟完成一次flush磁盘操作。
（2）配置依据

实际测试发现，该值对插入数据的速度影响非常大，设置为2时插入10000条记录只需要2秒，设置为0时只需要1秒，而设置为1时则需要229秒。因此，MySQL手册也建议尽量将插入操作合并成一个事务，这样可以大幅提高速度。
根据MySQL官方文档，在允许丢失最近部分事务的危险的前提下，可以把该值设为0或2。
（3）配置方法
innodb_flush_log_at_trx_commit=1

1.13 innodb_thread_concurrency 
（1）简介
此参数用来设置innodb线程的并发数量，默认值为0表示不限制。
（2）配置依据
在官方doc上，对于innodb_thread_concurrency的使用，也给出了一些建议，如下：
如果一个工作负载中，并发用户线程的数量小于64，建议设置innodb_thread_concurrency=0；
如果工作负载一直较为严重甚至偶尔达到顶峰，建议先设置innodb_thread_concurrency=128，
并通过不断的降低这个参数，96, 80, 64等等，直到发现能够提供最佳性能的线程数，

例如，假设系统通常有40到50个用户，但定期的数量增加至60，70，甚至200。你会发现，
性能在80个并发用户设置时表现稳定，如果高于这个数，性能反而下降。在这种情况下，
建议设置innodb_thread_concurrency参数为80，以避免影响性能。

如果你不希望InnoDB使用的虚拟CPU数量比用户线程使用的虚拟CPU更多（比如20个虚拟CPU），
建议通过设置innodb_thread_concurrency 参数为这个值（也可能更低，这取决于性能体现），
如果你的目标是将MySQL与其他应用隔离，你可以考虑绑定mysqld进程到专有的虚拟CPU。

但是需 要注意的是，这种绑定，在myslqd进程一直不是很忙的情况下，可能会导致非最优的硬件使用率。在这种情况下，
你可能会设置mysqld进程绑定的虚拟 CPU，允许其他应用程序使用虚拟CPU的一部分或全部。
在某些情况下，最佳的innodb_thread_concurrency参数设置可以比虚拟CPU的数量小。
定期检测和分析系统，负载量、用户数或者工作环境的改变可能都需要对innodb_thread_concurrency参数的设置进行调整。

（3）配置方法：
innodb_thread_concurrency=8


1.14 innodb_log_buffer_size

此参数确定些日志文件所用的内存大小，以M为单位。缓冲区更大能提高性能，对于较大的事务，可以增大缓存大小。
innodb_log_buffer_size=8M


1.15. innodb_log_file_size = 50M
此参数确定数据日志文件的大小，以M为单位，更大的设置可以提高性能.

如果设置过小,data buffer写入ibd频率会过高,对于IO压力较大

1.16. innodb_log_files_in_group = 3
为提高性能，MySQL可以以循环方式将日志文件写到多个文件。推荐设置为3

1.17.read_buffer_size = 1M
MySql读入缓冲区大小。对表进行顺序扫描的请求将分配一个读入缓冲区，MySql会为它分配一段内存缓冲区。如果对表的顺序扫描请求非常频繁，并且你认为频繁扫描进行得太慢，可以通过增加该变量值以及内存缓冲区大小提高其性能。和 sort_buffer_size一样，该参数对应的分配内存也是每个连接独享

18.read_rnd_buffer_size = 1M MySql的随机读（查询操作）缓冲区大小。当按任意顺序读取行时(例如，按照排序顺序)，将分配一个随机读缓存区。进行排序查询时，MySql会首先扫描一遍该缓冲，以避免磁盘搜索，提高查询速度，如果需要排序大量数据，可适当调高该值。但MySql会为每个客户连接发放该缓冲空间，所以应尽量适当设置该值，以避免内存开销过大。
 注：顺序读是指根据索引的叶节点数据就能顺序地读取所需要的行数据。随机读是指一般需要根据辅助索引叶节点中的主键寻找实际行数据，而辅助索引和主键所在的数据段不同，因此访问方式是随机的。

19.bulk_insert_buffer_size = 8M
批量插入数据缓存大小，可以有效提高插入效率，默认为8M

1.20.binary log
log-bin=/data/mysql-bin
binlog_format=row
binlog_cache_size = 2M //为每个session 分配的内存，在事务过程中用来存储二进制日志的缓存, 提高记录bin-log的效率。没有什么大事务，dml也不是很频繁的情况下可以设置小一点，如果事务大而且多，dml操作也频繁，则可以适当的调大一点。前者建议是--1M，后者建议是：即 2--4M
max_binlog_cache_size = 8M //表示的是binlog 能够使用的最大cache 内存大小
max_binlog_size= 512M //指定binlog日志文件的大小，如果当前的日志大小达到max_binlog_size，还会自动创建新的二进制日志。你不能将该变量设置为大于1GB或小于4096字节。默认值是1GB。在导入大容量的sql文件时，建议关闭sql_log_bin，否则硬盘扛不住，而且建议定期做删除。

expire_logs_days = 7 //定义了mysql清除过期日志的时间。
二进制日志自动删除的天数。默认值为0,表示“没有自动删除”。



innodb_max_dirty_pages_pct        ***********
innodb_additional_mem_pool_size (于2G内存的机器，推荐值是20M。32G内存的?100M)
transaction_isolation            *********


1.21 安全参数

Innodb_flush_method=(O_DIRECT, fdatasync) 
		1、fdatasync    ：
		（1）在数据页需要持久化时，首先将数据写入OS buffer中，然后由os决定什么时候写入磁盘
		（2）在redo buffuer需要持久化时，首先将数据写入OS buffer中，然后由os决定什么时候写入磁盘
			但，如果innodb_flush_log_at_trx_commit=1的话，日志还是直接每次commit直接写入磁盘
		2、 Innodb_flush_method=O_DIRECT
		 （1）在数据页需要持久化时，直接写入磁盘
		 （2）在redo buffuer需要持久化时，首先将数据写入OS buffer中，然后由os决定什么时候写入磁盘
			但，如果innodb_flush_log_at_trx_commit=1的话，日志还是直接每次commit直接写入磁盘

最高安全模式：
		innodb_flush_log_at_trx_commit=1
		innodb_flush_method=O_DIRECT
最高性能模式：
		innodb_flush_log_at_trx_commit=0
		innodb_flush_method=fdatasync
		
一般情况下，我们更偏向于安全。
		
“双一标准”
		innodb_flush_log_at_trx_commit=1        ***************
		sync_binlog=1                    		***************
		innodb_flush_method=O_DIRECT


	



三、参数优化结果
[mysqld]
basedir=/application/mysql
datadir=/application/mysql/data
socket=/tmp/mysql.sock
log-error=/var/log/mysql.log
log_bin=/data/binlog/mysql-bin
binlog_format=row
skip-name-resolve
server-id=52
gtid-mode=on
enforce-gtid-consistency=true
log-slave-updates=1
relay_log_purge=0
max_connections=1024
back_log=128
wait_timeout=60
interactive_timeout=7200
key_buffer_size=16M
query_cache_size=64M
query_cache_type=1
query_cache_limit=50M
max_connect_errors=20
sort_buffer_size=2M
max_allowed_packet=32M
join_buffer_size=2M
thread_cache_size=200
innodb_buffer_pool_size=1024M
innodb_flush_log_at_trx_commit=1
innodb_log_buffer_size=32M
innodb_log_file_size=128M
innodb_log_files_in_group=3
binlog_cache_size=2M
max_binlog_cache_size=8M
max_binlog_size=512M
expire_logs_days=7
read_buffer_size=2M
read_rnd_buffer_size=2M
bulk_insert_buffer_size=8M
[client]
socket=/tmp/mysql.sock	
		
再次压力测试	：

[root@db02 ~]# mysqlslap --defaults-file=/etc/my.cnf \
>  --concurrency=100 --iterations=1 --create-schema='oldboy' \
> --query='select * from oldboy.lufei where stuname="guojialei_100"' engine=innodb \
> --number-of-queries=2000 -uroot -p123 -verbose
Warning: Using a password on the command line interface can be insecure.
Benchmark
        Running for engine rbose
        Average number of seconds to run all queries: 3.171 seconds
        Minimum number of seconds to run all queries: 3.171 seconds
        Maximum number of seconds to run all queries: 3.171 seconds
        Number of clients running queries: 100
        Average number of queries per client: 30

对比之前：
mysqlslap --defaults-file=/etc/my.cnf \
--concurrency=100 --iterations=1 --create-schema='oldboy' \
--query='select * from oldboy.lufei where stuname="guojialei_100"' engine=innodb \
--number-of-queries=3000 -uroot -p123 -verbose

Benchmark
        Running for engine rbose
        Average number of seconds to run all queries: 88.360 seconds
        Minimum number of seconds to run all queries: 88.360 seconds
        Maximum number of seconds to run all queries: 88.360 seconds
        Number of clients running queries: 100
        Average number of queries per client: 30

#继续优化  增加索引
mysql> alter table oldboy.lufei add index idx_name(stuname);
mysql> explain select * from oldboy.lufei where stuname='guojialei_101';


[root@db04 ~]# mysqlslap --defaults-file=/etc/my.cnf --concurrency=100 --iterations=1 --create-schema='oldboy' --query='select * from oldboy.lufei where stuname="guojialei_100"' engine=innodb --number-of-queries=3000 -uroot -p123 -verbose
Warning: Using a password on the command line interface can be insecure.
Benchmark
        Running for engine rbose
        Average number of seconds to run all queries: 0.081 seconds
        Minimum number of seconds to run all queries: 0.081 seconds
        Maximum number of seconds to run all queries: 0.081 seconds
        Number of clients running queries: 100
        Average number of queries per client: 30




```





## mysqlslap 工具介绍

```
mysqlslap工具介绍
​ mysqlslap来自于mariadb包，测试的过程默认生成一个mysqlslap的schema,生成测试表t1，查询和插入测试数据，mysqlslap库自动生成，如果已经存在则先删除。用--only-print来打印实际的测试过程，整个测试完成后不会在数据库中留下痕迹。

常用选项：

--auto-generate-sql, -a 自动生成测试表和数据，表示用mysqlslap工具自己生成的SQL脚本来测试并发压力
--auto-generate-sql-load-type=type 测试语句的类型。代表要测试的环境是读操作还是写操作还是两者混合的。取值包括：read，key，write，update和mixed(默认)
--auto-generate-sql-add-auto-increment 代表对生成的表自动添加auto_increment列，从5.1.18版本开始支持
--number-char-cols=N, -x N 自动生成的测试表中包含多少个字符类型的列，默认1
--number-int-cols=N, -y N 自动生成的测试表中包含多少个数字类型的列，默认1
--number-of-queries=N 总的测试查询次数(并发客户数×每客户查询次数)
--query=name,-q 使用自定义脚本执行测试，例如可以调用自定义的存储过程或者sql语句来执行测试
--create-schema 代表自定义的测试库名称，测试的schema，MySQL中schema也就是database
--commint=N 多少条DML后提交一次
--compress, -C 如服务器和客户端都支持压缩，则压缩信息
--concurrency=N, -c N 表示并发量，即模拟多少个客户端同时执行select；可指定多个值，以逗号或者--delimiter参数指定值做为分隔符
--engine=engine_name, -e engine_name 代表要测试的引擎，可以有多个，用分隔符隔开
--iterations=N, -i N 测试执行的迭代次数，代表要在不同并发环境下，各自运行测试多少次
--only-print 只打印测试语句而不实际执行
--detach=N 执行N条语句后断开重连
--debug-info, -T 打印内存和CPU的相关信息
测试示例：

1）单线程测试

[root@centos7 ~]# mysqlslap -a -uroot -p
Enter password: 
Benchmark
        Average number of seconds to run all queries: 0.004 seconds
        Minimum number of seconds to run all queries: 0.004 seconds
        Maximum number of seconds to run all queries: 0.004 seconds
        Number of clients running queries: 1
        Average number of queries per client: 0
2）多线程测试，使用--concurrency来模拟并发连接

[root@centos7 ~]# mysqlslap -uroot -p -a -c 500
Enter password: 
Benchmark
        Average number of seconds to run all queries: 3.384 seconds
        Minimum number of seconds to run all queries: 3.384 seconds
        Maximum number of seconds to run all queries: 3.384 seconds
        Number of clients running queries: 500
        Average number of queries per client: 0
3）同时测试不同的存储引擎的性能进行对比

[root@centos7 ~]# mysqlslap -uroot -p -a --concurrency=500 --number-of-queries 1000 --iterations=5 --engine=myisam,innodb --debug-info
Enter password: 
Benchmark
        Running for engine myisam
        Average number of seconds to run all queries: 0.192 seconds
        Minimum number of seconds to run all queries: 0.187 seconds
        Maximum number of seconds to run all queries: 0.202 seconds
        Number of clients running queries: 500
        Average number of queries per client: 2

Benchmark
        Running for engine innodb
        Average number of seconds to run all queries: 0.355 seconds
        Minimum number of seconds to run all queries: 0.350 seconds
        Maximum number of seconds to run all queries: 0.364 seconds
        Number of clients running queries: 500
        Average number of queries per client: 2


User time 0.33, System time 0.58
Maximum resident set size 22892, Integral resident set size 0
Non-physical pagefaults 46012, Physical pagefaults 0, Swaps 0
Blocks in 0 out 0, Messages in 0 out 0, Signals 0
Voluntary context switches 31896, Involuntary context switches 0
4）执行一次测试，分别500和1000个并发，执行5000次总查询

[root@centos7 ~]# mysqlslap -uroot -p -a --concurrency=500,1000 --number-of-queries 5000 --debug-info
Enter password: 
Benchmark
        Average number of seconds to run all queries: 3.378 seconds
        Minimum number of seconds to run all queries: 3.378 seconds
        Maximum number of seconds to run all queries: 3.378 seconds
        Number of clients running queries: 500
        Average number of queries per client: 10

Benchmark
        Average number of seconds to run all queries: 3.101 seconds
        Minimum number of seconds to run all queries: 3.101 seconds
        Maximum number of seconds to run all queries: 3.101 seconds
        Number of clients running queries: 1000
        Average number of queries per client: 5


User time 0.84, System time 0.64
Maximum resident set size 83068, Integral resident set size 0
Non-physical pagefaults 139977, Physical pagefaults 0, Swaps 0
Blocks in 0 out 0, Messages in 0 out 0, Signals 0
Voluntary context switches 31524, Involuntary context switches 3
5）迭代测试

[root@centos7 ~]# mysqlslap -uroot -p -a --concurrency=500 --number-of-queries 5000 --iterations=5 --debug-info
Enter password: 
Benchmark
        Average number of seconds to run all queries: 3.307 seconds
        Minimum number of seconds to run all queries: 3.184 seconds
        Maximum number of seconds to run all queries: 3.421 seconds
        Number of clients running queries: 500
        Average number of queries per client: 10


User time 2.18, System time 1.58
Maximum resident set size 74872, Integral resident set size 0
Non-physical pagefaults 327732, Physical pagefaults 0, Swaps 0
Blocks in 0 out 0, Messages in 0 out 0, Signals 0
Voluntary context switches 73904, Involuntary context switches 3	
```





