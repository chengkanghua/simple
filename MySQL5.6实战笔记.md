
DBMS（database management system）

# MySQL二进制安装：
```bash
#安装所需要的依赖包
yum -y install cmake bison-devel ncurses-devel libaio-devel gcc gcc-c++ automake autoconf
#卸载冲突 的mariadb
rpm -qa |grep mariadb  

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

#MySQL查看报错：
#tail -100 /application/mysql/data/db01.err

#连接MySQL：
# mysql

#查看库：
#mysql> show databases;

#修改密码
#/usr/local/mysql/bin/mysqladmin -u root password 'Ckh123.com'
#mysql -u root -pCkh123.com
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
	- 套接字   mysql -uroot -S /tmp/mysql.sock 
	思考：mysql -uroot -poldboy123是使用了哪个连接方式？？？ socket


什么是实例
	-1 MySQL的后台进程+线程+预分配内存结构
	-2 mysql启动过程会启动后台守护进程，并生成工作线程，预分配内存结构供mysql处理数据使用。
	
# mysqld服务器程序构成
客户端 --》 连接器--》 分析器（查询缓存有就直接返回）--》优化器--》执行器 --》 存储引擎层

连接器:管理连接,权限验证
分析器:词法分析,语法分析
优化器:执行计划生成,索引选择
执行器:操作引擎,返回结果
存储引擎层: 存储数据，提供读写接口

# mysql结构
逻辑结构
	1 库
	2 表: 元数据+真是数据行
	3 元数据: 列+其他属性 (行数+占用空间大小+权限)
	4 列: 列名字+数据类型+其他约束(非空,唯一,非负数,自增长,默认值)
	
二维表:
select user,password,host from mysql.user;

mysql逻辑结构与linux系统对比:
mysql           			linux 
库							目录
show databases;  			ls -l /
use mysql;       			cd /mysql 
表               			文件
show tables;     			ls
二维表=元数据+真实数据行	文件=文件名+文件属性

# mysql 物理结构
myisam:
	user.frm
	user.MYD
	user.MYI
innodb:
	old.frm
	old.ibd

段、区、页（块）
● 1、段：理论上一个表就是一个段，由多个区构成，（分区表是一个分区一个段）
● 2、区：连续的多个页构成
● 3、页：最小的数据存储单元，默认是16k

#mysql用户权限管理

#创建用户并设置密码
create user '[新用户名]'@'[作用域]' identified by '[密码]';
flush privileges;　　//创建完要记得刷新权限表

#授权加创建用户

grant [权限] on [数据库名].[表名] to '[用户名]'@'[作用域]' identified by '[密码]';
flush privileges;　　//记得刷新权限表

#删除用户 二选一

drop user '[用户名]'@'[作用域]';　　
delete from mysql.user where user='[用户名]' and host='[作用域];  
flush privileges;　　//刷新权限表

#修改用户密码

#mysql  # 配置文件添加 跳过授权表skip-grant-tables　　//添加

mysql> update user set authentication_string=password('123') where user='root';
mysql> flush privileges;　　//刷新权限表

用户的定义: username@'主机域' 

#刚装完mysql初始化密码
mysqladmin -uroot -p password ‘oldboy123’

#误删除所有用户

#关闭数据库
[root@db02 mysql-5.7.20]# /etc/init.d/mysqld stop
#启动数据库
[root@db02 mysql-5.7.20]# mysqld_safe --skip-grant-tables --skip-networking
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

#忘记root密码
#关闭数据库
[root@db02 mysql-5.7.20]# /etc/init.d/mysqld stop
#启动数据库
[root@db02 mysql-5.7.20]# mysqld_safe --skip-grant-tables --skip-networking
#修改root用户密码
mysql> update user set password=PASSWORD('oldboy123') where user='root' and host='localhost';

#一般给开发创建用户权限
grant select,update,delete,insert on *.* to oldboy@’10.0.0.%’ identified by ‘123’;


# mysql连接管理
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

# mysql启动关闭流程
mysql.server 启动  ---> mysql_safe 启动   --> mysqld 
service mysqld start   ./bin/mysqld_safe &

/etc/init.d/mysqld start ------> mysqld_safe ------> mysqld

关闭
/etc/init.d/mysqld stop 
mysqladmin -uroot -poldboy123 shutdown

kill -9 pid ?
killall mysqld ?
pkill mysqld ?
出现问题：
- 1、如果在业务繁忙的情况下，数据库不会释放pid和sock文件
- 2、号称可以达到和Oracle一样的安全性，但是并不能100%达到
- 3、在业务繁忙的情况下，丢数据（补救措施，高可用）


# mysql实例初始化配置
配置文件读取顺序：
/etc/my.cnf
/etc/mysql/my.cnf
$MYSQL_HOME/my.cnf（前提是在环境变量中定义了MYSQL_HOME变量）
defaults-extra-file （类似include）
~/my.cnf

优先级结论：
● 1、命令行
● 2、defaults-file
● 3、配置文件
● 4、预编译



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
	mysql 
		- 连接 
		- 管理
```
#MySQL接口自带的命令
\h 或 help 或？      查看帮助
\G                  格式化查看数据（key：value）
\T 或 tee            记录日志
\c（5.7可以ctrl+c）   结束命令
\s 或 status         查看状态信息
\. 或 source         导入SQL数据
\u或 use             使用数据库
\q 或 exit 或 quit   退出
```
		- 接收用户sql语句     发送给服务器
	
	mysqladmin 
			- 命令行管理工具
	mysqldump
			- 备份数据库和表工具

help命令使用
```
mysql> help
mysql> help contents
mysql> help select
mysql> help create
mysql> help create user
mysql> help status
mysql> help show
```
source命令的使用
```
#在MySQL中处理输入文件：
#如果这些文件包含SQL语句则称为：
#1.脚本文件
#2.批处理文件
mysql> SOURCE /data/mysql/world.sql
#或者使用非交互式
mysql</data/mysql/world.sql
```
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
```
#查看MySQL存活状态
[root@db01 ~]# mysqladmin -uroot -p123 ping
#查看MySQL状态信息
[root@db01 ~]# mysqladmin -uroot -p123 status
#关闭MySQL进程
[root@db01 ~]# mysqladmin -uroot -p123 shutdown
#查看MySQL参数
[root@db01 ~]# mysqladmin -uroot -p123 variables
#删除数据库
[root@db01 ~]# mysqladmin -uroot -p123 drop DATABASE
#创建数据库
[root@db01 ~]# mysqladmin -uroot -p123 create DATABASE
#重载授权表
[root@db01 ~]# mysqladmin -uroot -p123 reload
#刷新日志
[root@db01 ~]# mysqladmin -uroot -p123 flush-log
#刷新缓存主机
[root@db01 ~]# mysqladmin -uroot -p123 reload
#修改口令
[root@db01 ~]# mysqladmin -uroot -p123 password
```

# 接收用户的sql语句
- 什么是sql ?  结构化的查询语句
- sql的种类    
	- DDL: 数据库定义语句 #库 表
		create database
		drop database
		alter database
		create table 
		drop table 
		alter table
	- DCL：数据控制语言   #针对权限进行控制
		grant 
		revoke 
	- DML：数据操作语言
		insert 
		update
		delete 
	- DQL：数据查询语言
		select 

# ddl 数据定义语言
## 库对象: 库名字,库属性
create database testa charset utf8;
show create database testa ;
help create database

alter database testa charset gbk;

drop database testa;

## 表对象: 列名,列属性,约束
help create table 
create table student(
sid int,
sname varchar(20),
sage tinyint,
sgender enum('m','f'),
cometime datetime);
数据类型
	int： 整数 -231 ~ 231 -1
	varchar：字符类型 （变长）
	char： 字符类型 （定长）
	tinyint： 整数 -128 ~ 128
	enum： 枚举类型
	datetime： 时间类型 年月日时分秒
	
## 创建表加其他属性
mysql> create table student(
sid INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT ‘学号’,
sname VARCHAR(20) NOT NULL COMMENT ‘学生姓名’,
sage TINYINT UNSIGNED COMMENT ‘学生年龄’,
sgender ENUM('m','f')  NOT NULL DEFAULT ‘m’ COMMENT ‘学生性别’,
cometime DATETIME NOT NULL COMMENT ‘入学时间’)chatset utf8 engine innodb;
show create table student;
show tables
desc student;
数据属性
	not null： 非空
	primary key： 主键（唯一且非空的）
	auto_increment： 自增（此列必须是：primary key或者unique key）
	unique key： 单独的唯一的
	default： 默认值
	unsigned： 非负数
	comment： 注释

## 修改表定义 alter table 
alter table student rename stu;
alter table stu add age int;
alter table stu add test varchar(20),add qq int;
alter table stu add classid varchar(20) first;
alter table stu add phone int alter age;
alter table stu drop qq;
alter table stu modify sid varchar(20);
alter table stu change phone telphone char(20);

## 删除表
drop table stu;

# dcl 数据控制语言
## 授权 grant 
- 授权root@10.0.0.51用户所有权限 (非超级管理员)
grant all on *.* to root@'10.0.0.51' identified by 'old123'
- 怎么去授权一个超级管理员
grant all on *.* to root@'10.0.0.51' identified by 'old123' with grant option;
- 其他参数（扩展）
max_queries_per_hour：一个用户每小时可发出的查询数量
max_updates_per_hour：一个用户每小时可发出的更新数量
max_connetions_per_hour：一个用户每小时可连接到服务器的次数
max_user_connetions：允许同时连接数量

## 收回权限revoke  
revoke select on *.* from root@'10.0.0.51'; 
show grants from root@'10.0.0.51';

# dml 数据操作语言 
- insert 
insert into stu values('linux01',1,NOW(),'zhangsan',20,'m',NOW(),110,123456);

insert into stu(classid,birth,sname,sage,sgender,comtime,telnum,qq) values('linux01',1,NOW(),'zhangsan',20,'m',NOW(),110,123456);

insert into stu(classid,birth.sname,sage,sgender,comtime,telnum,qq) values('linux01',1,NOW(),'zhangsan',20,'m',NOW(),110,123456),('linux02',2,NOW(),'zhangsi',21,'f',NOW(),111,1234567);


- update 
update student set sgender='f'; #不规范
update student set sgender='f' where sid=1 ;
update student set sgender='f' where 1=1;  #如果非要全表修改

- delete 
delete from student; #不规范
delete from studnet where id=3;
truncate table student; # ddl删除表  

- update 代替delete
alter table student add status enum(1,0) default 1;
update student set enum='0' where sid=1;
select * from student where status=1;

# dql 数据查询语言
select countrycode,district from city;
select countrycode from city;
select countrycode,district from city limit 2;
select id,countrycode,district from city limit 2,2;
select name,population from city where countrycode='CHN';
select name,population from city where countrycode='CHN' and district='heilongjiang';
select name.population,countrycode from city where countrycode like '%H%' limit 10;
select id,name,population,countrycode from city order by countrycode limit 10;
select id,name,population,countrycode from city order by countrycode desc limit 10;
select * from city where population>=1410000;
select * from city where countrycode='CHN' or countrycode='USA';
select * from city where countrycode in ('CHN','USA');


# 字符集定义
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

# 字符集设置
- 操作系统级别
source /etc/sysconfig/i18n
echo $LANG
zh_CN.UTF-8

- mysql实例级别
编译时候指定
cmake . 
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS=all \

配置文件设置字符集
[mysqld]
character-set-server=utf8

建库级别
create database oldboy charset utf8 default collate=utf8_general_ci;

建表级别
create table test(
id int(4) not null auto_increment,
name char(20) not null,
primary key (id)
)engine=innodb auto_increment=13 default charset=utf8;


思考问题：如果在生产环境中，字符集不够用或者字符集不合适该怎么处理？
alter database oldboy character set utf8 collate utf8_general_ci;
alter table t1 character set utf8;

# select 高级用法
- 多表连接查询

select t1.sname,t2.mark from t1,t2 where t1.sid=t2.sid and t1.sname=’zhang3’;

## 传统连接  内连接 取交集
- 世界上小于100人的人口城市是哪个国家的？
select city.name,city.countrycode,country.name 
from city,country 
where city.countrycode=country.code 
and city.population<100;

## NATURAL　JOIN（自连接的表要有共同的列名字）
SELECT city.name,city.countrycode ,countrylanguage.language ,city.population
FROM  city NATURAL  JOIN  countrylanguage 
WHERE population > 1000000
ORDER BY population;

## 企业中多表连接查询（内连接）
select city.name,city.countrycode,country.name 
from city join country on city.countrycode=country.code 
where city.population<100;

建议：使用join语句时，小表在前，大表在后。
- 外连接
select city.name,city.countrycode,country.name 
from city left join country 
on city.countrycode=country.code 
and city.population<100;

- UNION（合并查询）
	union：去重复合并
	union all ：不去重复
	使用情况：union<union all
	#范围查询OR语句
	select * from city where countrycode='CHN' or countrycode='USA';
	#范围查询IN语句
	select * from city where countrycode in ('CHN','USA');
	替换为：
	select * from city where countrycode='CHN' 
	union  all
	select * from city where countrycode='USA' limit 10

# 索引管理及执行计划
- 什么是索引
	1）索引就好比一本书的目录，它能让你更快的找到自己想要的内容。
	2）让获取的数据更有目的性，从而提高数据库检索数据的性能。
	

2.索引类型介绍
	1)BTREE:B+树索引
	2)HASH：HASH索引
	3)FULLTEXT：全文索引
	4)RTREE：R树索引
	
3.索引管理
	索引建立在表的列上(字段)的。
	在where后面的列建立索引才会加快查询速度。
	pages<---索引（属性）<----查数据。
	
● 1、索引分类：
主键索引
普通索引*****
唯一索引

2、添加索引：
alter table add index index_name(name)
create index index_name on test(name);
desc table;
show index from table;
alter table test drop key index_name;
alter table student add unique key uni_xxx(xxx);

select count(*) from city;
select count(distinct name) from city;  # distinct 去重复 

- 前缀索引
alter table test add index index_name(name(10));
避免对大列建索引,如果有，就使用前缀索引

- 联合索引
多个字段建立一个索引
例：
where a.女生 and b.身高 and c.体重 and d.身材好 #查询条件
index(a,b,c) #联合索引顺序 
特点：前缀生效特性
a,ab,ac,abc,abcd 可以走索引或部分走索引
b bc bcd cd c d ba ... 不走索引
- 原则：把最常用来做为条件查询的列放在最前面

create table pepople(id int,name varchar(20),age tinyint,memy int,gender enum('m','f'));
alter table people add index idx_gam(gender,age,meney);


# explain
explain select name,countrycode from city where id=1;

● 1.全表扫描1）在explain语句结果中type为ALL
	● 2）什么时候出现全表扫描?
	  ○   2.1 业务确实要获取所有数据
	  ○   2.2 不走索引导致的全表扫描
		■     2.2.1 没索引
		■     2.2.2 索引创建有问题
		■     2.2.3 语句有问题
生产中,mysql在使用全表扫描时的性能是极其差的，所以MySQL尽量避免出现全表扫描
● 2.索引扫描
	2.1 常见的索引扫描类型:
	1）index
	2）range
	3）ref
	4）eq_ref
	5）const
	6）system
	7）null
从上到下，性能从最差到最好，我们认为至少要达到range级别
index：Full Index Scan，index与ALL区别为index类型只遍历索引树。
range：索引范围扫描，对索引的扫描开始于某一点，返回匹配值域的行。显而易见的索引范围扫描是带有between或者where子句里带有<,>查询。
alter table city add index idx_city(population);
explain select * from city where population>30000000;

ref：使用非唯一索引扫描或者唯一索引的前缀扫描，返回匹配某个单独值的记录行。
alter table city drop key idx_code;
explain select * from city where countrycode='chn';
explain select * from city where countrycode in ('CHN','USA');
explain select * from city where countrycode='CHN' union all select * from city where countrycode='USA';

eq_ref：类似ref，区别就在使用的索引是唯一索引，对于每个索引键值，表中只有一条记录匹配，简单来说，就是多表连接中使用primary key或者 unique key作为关联条件A

join B 
on A.sid=B.sid

const、system：当MySQL对查询某部分进行优化，并转换为一个常量时，使用这些类型访问。
如将主键置于where列表中，MySQL就能将该查询转换为一个常量
explain select * from city where id=1000;

NULL：MySQL在优化过程中分解语句，执行时甚至不用访问表或索引，例如从一个索引列里选取最小值可以通过单独索引查找完成。
explain select * from city where id=1000000000000000000000000000;

Extra（扩展）
	Using temporary
	Using filesort 使用了默认的文件排序（如果使用了索引，会避免这类排序）
	Using join buffer

如果出现Using filesort请检查order by ,group by ,distinct,join 条件列上没有索引
explain select * from city where countrycode='CHN' order by population;
	
当order by语句中出现Using filesort，那就尽量让排序值在where条件中出现	
explain select * from city where population>30000000 order by population;
select * from city where population=2870300 order by population;

key_len: 越小越好
	● 前缀索引去控制
rows: 越小越好

# 建立索引的原则（规范）
● 1、选择唯一性索引
唯一性索引的值是唯一的，可以更快速的通过该索引来确定某条记录。
主键索引和唯一键索引，在查询中使用是效率最高的。
select count(*) from world.city;
select count(distinct countrycode) from world.city;
select count(distinct countrycode,population ) from world.city;
注意：如果重复值较多，可以考虑采用联合索引

● 2．为经常需要排序、分组和联合操作的字段建立索引

● 3．为常作为查询条件的字段建立索引
  ○   3.1 经常查询
  ○   3.2 列值的重复值少
注：如果经常作为条件的列，重复值特别多，可以建立联合索引

● 4．尽量使用前缀来索引
● 5．限制索引的数目
索引的数目不是越多越好。每个索引都需要占用磁盘空间，索引越多，需要的磁盘空间就越大。 修改表时，对索引的重构和更新很麻烦。越多的索引，会使更新表变得很浪费时间。
● 6．删除不再使用或者很少使用的索引 表中的数据被大量更新，或者数据的使用方式被改变后，原有的一些索引可能不再需要。数据库管理
员应当定期找出这些索引，将它们删除，从而减少索引对更新操作的影响。
	

## 重点关注
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
selec  * from tab  order by  price  limit 10;
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
or或in尽量改成union
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


# 存储引擎  
● 1、文件系统：
  ○ 1.1 操作系统组织和存取数据的一种机制。
  ○ 1.2 文件系统是一种软件。
● 2、文件系统类型：ext2 3 4 ，xfs 数据
  ○ 2.1 不管使用什么文件系统，数据内容不会变化
  ○ 2.2 不同的是，存储空间、大小、速度。
● 3、MySQL引擎：
  ○ 3.1 可以理解为，MySQL的“文件系统”，只不过功能更加强大。
● 4、MySQL引擎功能：
  ○ 4.1 除了可以提供基本的存取功能，还有更多功能事务功能、锁定、备份和恢复、优化以及特殊功能
总之，存储引擎的各项特性就是为了保障数据库的安全和性能设计结构。

## MySQL自带提供以下存储引擎:
01）InnoDB
02）MyISAM
03）MEMORY
04）ARCHIVE
05）FEDERATED
06）EXAMPLE
07）BLACKHOLE
08）MERGE
09）NDBCLUSTER
10）CSV
还可以使用第三方存储引擎.

MySQL当中插件式的存储引擎类型
MySQL的两个分支
	- perconaDB
	- mariaDB

```
# 查看当前支持的引擎
show engines;
# 查看innodb的表有哪些
select table_schema,table_name,engine from information_schema.tables where engine='innodb';
# 查看myisam的表有哪些
select table_schema,table_name,engine from information_schema.tables where engine='myisam';
```

## innodb和myisam的区别
- 物理上区别:
```
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

- 查看存储引擎 
select @@default_storage_engine;

- 使用show 确认每个表的存储引擎
show create table city\G 
show table status like 'CountryLanguage'\G 

- 使用 INFORMATION_SCHEMA 确认每个表的存储引擎
#查看表的存储引擎
SELECT TABLE_NAME, ENGINE FROM INFORMATION_SCHEMA.TABLESWHERE TABLE_NAME='City' AND TABLE_SCHEMA='world'\G

## 存储引擎的设置
```
#在配置文件的[mysqld]标签下添加
[mysqld]
default-storage-engine=<Storage Engine>
#在MySQL命令行中临时设置
SET @@storage_engine=<Storage Engine>
#建表的时候指定存储引擎
CREATE TABLE t (i INT) ENGINE = <Storage Engine>;
```
# Innodb存储引擎——表空间介绍
5.5版本以后出现共享表空间概念
表空间的管理模式的出现是为了数据库的存储更容易扩展

5.6版本中默认是独立表空间

### 查看共享表空间
```
#物理查看
[root@db01 ~]# ll /application/mysql/data/
-rw-rw---- 1 mysql mysql 79691776 Aug 14 16:23 ibdata1
#命令行查看
mysql> show variables like '%path%';
innodb_data_file_path =bdata1:12M:autoextend
```
5.6版本中默认存储:
		1.系统数据
		2.undo
		3.临时表
5.7版本中默认会将undo和临时表独立出来，5.6版本也可以独立，只不过需要在初始化的时候进行配置
设置方法
- 编辑配置文件
[root@db01 ~]# vim /etc/my.cnf
[mysqld]
innodb_data_file_path=ibdata1:50M;ibdata2:50M:autoextend

### 独立表空间
对于用户自主创建的表，会采用此种模式，每个表由一个独立的表空间进行管理
- 物理查看
[root@db01 ~]# ll /application/mysql/data/world/
-rw-rw---- 1 mysql mysql 688128 Aug 14 16:23 city.ibd
#命令行查看
mysql> show variables like '%per_table%';
innodb_file_per_table=ON

# Innodb核心特性——事务

● 事务ACID特性
Atomic（原子性）
所有语句作为一个单元全部成功执行或全部取消。
Consistent（一致性）
如果数据库在事务开始时处于一致状态，则在执行该事务期间将保留一致状态。
Isolated（隔离性）
事务之间不相互影响。
Durable（持久性）
事务成功完成后，所做的所有更改都会准确地记录在数据库中。所做的更改不会丢失。

- 事务自动提交
show variables like 'autocommit';
set autocommit=0; #临时关闭
#永久关闭
vim /etc/my.cnf 
[mysqld]
autocommit=0

- 事务演示
---成功提交
create table stu(id int,name varchar(10),sex enum('f','m'),money int);
begin;
insert into stu(id,name,sex,money) values(1,'zhang3','m',100), (2,'zhang4','m',110);
commit;
---事务回滚
begin;
update stu set name='zhang3';
delete from stu;
rollback; 

● 事务隐式提交情况
1）现在版本在开启事务时，不需要手工begin，只要你输入的是DML语句，就会自动开启事务。
2）有些情况下事务会被隐式提交
	例如:
	在事务运行期间，手工执行begin的时候会自动提交上个事务
	在事务运行期间，加入DDL、DCL操作会自动提交上个事务
	在事务运行期间，执行锁定语句（lock tables、unlock tables）
	load data infile
	select for update
	在autocommit=1的时候

## 事务日志redo基本功能
1）Redo是什么？
redo,顾名思义“重做日志”，是事务日志的一种。
2）作用是什么？
在事务ACID过程中，实现的是“D”持久化的作用。

特性:WAL(Write Ahead Log)日志优先写
REDO：记录的是，内存数据页的变化过程

3）REDO工作过程
#执行步骤
update t1 set num=2 where num=1;
1）首先将t1表中num=1的行所在数据页加载到内存中buffer page
2）MySQL实例在内存中将num=1的数据页改成num=2
3）num=1变成num=2的变化过程会记录到 redo内存区域，也就是redo buffer page中
#提交事务执行步骤
commit;
1）当敲下commit命令的瞬间，MySQL会将redo buffer page写入磁盘区域redo log
2）当写入成功之后，commit返回ok

### redo数据实例恢复过程
## 事务日志undo
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

### 事务中的锁
1）什么是“锁”？
“锁”顾名思义就是锁定的意思。
2）“锁”的作用是什么？
在事务ACID特性过程中，“锁”和“隔离级别”一起来实现“I”隔离性的作用。

排他锁：保证在多事务操作时，数据的一致性。
共享锁：保证在多事务工作期间，数据查询时不会被阻塞。

### 多版本并发控制（MVCC）
1）只阻塞修改类操作，不阻塞查询类操作
2）乐观锁的机制（谁先提交谁为准）

### 锁的粒度
● MyIsam：低并发锁（表级锁）
● Innodb：高并发锁（行级锁）

### 事务的隔离级别
四种隔离级别：
    READ UNCOMMITTED（独立提交）  允许事务查看其他事务所进行的未提交更改
    READ COMMITTED (读提交)      允许事务查看其他事务所进行的已提交更改
    REPEATABLE READ(重复读)      确保每个事务的 SELECT 输出一致 # InnoDB 的默认级别
    SERIALIZABLE   (串行)        将一个事务的结果与其他事务完全隔离

```
#查看隔离级别
mysql> show variables like '%iso%';
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

# mysql日志
日志文件      选项                文件名/表名称                    程序
错误         --log=error        host_name.err
常规         --general_log      host_name.log/general.log
慢速查询     --slow_query_log    host_name-slow.log           mysqldumpslow
			--long_query_time   
二进制       --log-bin            host_name-bin.000001        mysqlbinlog
			 --expire-logs-days   
审计         --audit_log
			--audit_log_file      audit.log  

## 错误日志
默认位置: $MYSQL_HOME/data/ 
开启方式 (安装完默认开启 )
```
vim /etc/my.cnf 
[mysqld]
log_error=/application/mysql/data/$hostname.err 

#查看方式
show variables like 'log_error';

```
## 一般查询日志
作用：
记录mysql所有执行成功的SQL语句信息，可以做审计用，但是我们很少开启。
默认位置：
$MYSQL_HOME/data/
开启方式:（MySQL安装完之后默认不开启）
```
#编辑配置文件
[root@db01 ~]# vim /etc/my.cnf
[mysqld]
general_log=on
general_log_file=/application/mysql/data/$hostnamel.log
#查看方式
mysql> show variables like '%gen%';
```

## 二进制日志
作用：
记录已提交的DML事务语句，并拆分为多个事件（event）来进行记录
记录所有DDL、DCL等语句
总之，二进制日志会记录所有对数据库发生修改的操作

二进制日志模式:
statement：语句模式，上图中将update语句进行记录（默认模式）。
row：行模式，即数据行的变化过程，上图中Age=19修改成Age=20的过程事件。
mixed：以上两者的混合模式。
企业推荐使用row模式

优缺点:
statement模式：
	优点：简单明了，容易被看懂，就是sql语句，记录时不需要太多的磁盘空间。
	缺点：记录不够严谨。
row模式：
	优点：记录更加严谨。
	缺点：有可能会需要更多的磁盘空间，不太容易被读懂。

binlog的作用:
	1）如果我拥有数据库搭建开始所有的二进制日志，那么我可以把数据恢复到任意时刻
	2）数据的备份恢复
	3）数据的复制

二进制日志的管理操作实战

```
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
```

```
#物理查看
[root@db01 data]# ll /application/mysql/data/
-rw-rw---- 1 mysql mysql      285 Mar  6  2017 mysql-bin.000001
#命令行查看
mysql> show binary logs;
mysql> show master status;
#查看binlog事件
mysql> show binlog events in 'mysql-bin.000007';

```
事件介绍
	1）在binlog中最小的记录单元为event
	2）一个事务会被拆分成多个事件（event）
事件（event）特性
	1）每个event都有一个开始位置（start position）和结束位置（stop position）。
	2）所谓的位置就是event对整个二进制的文件的相对位置。
	3）对于一个二进制日志中，前120个position是文件格式信息预留空间。
	4）MySQL第一个记录的事件，都是从120开始的。

row模式下二进制日志分析及数据恢复
```
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
```
恢复数据到delete之前 
```
mysql> show binlog events in 'mysql-bin.000013';
#使用mysqlbinlog来查看
[root@db01 data]# mysqlbinlog /application/mysql/data/mysql-bin.000013
[root@db01 data]# mysqlbinlog /application/mysql/data/mysql-bin.000013|grep -v SET
[root@db01 data]# mysqlbinlog --base64-output=decode-rows -vvv mysql-bin.000013
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
[root@db01 data]# mysqlbinlog --start-position=120 --stop-position=1347 /application/mysql/data/mysql-bin.000013 >/tmp/binlog.sql


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
```
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
刷新binlog日志
    1）flush logs;
    2）重启数据库时会刷新
    3）二进制日志上限（max_binlog_size）

删除二进制日志
    1）原则 - 在存储能力范围内，能多保留则多保留
    2)基于上一次全备前的可以选择删除

删除方式
1.根据存在时间删除日志
#临时生效
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

# 慢查询日志
作用： 记录慢SQL语句的日志,定位低效SQL语句的工具日志


默认位置： $MYSQL_HOME/data/$hostname-slow.log

开启方式（默认没有开启）：
```
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
#查询语句的执行行数检查返回少于该参数指定行的SQL不被记录到慢查询日志 
min_examined_row_limit=100（鸡肋）
```
模拟慢查询语句
```
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
```

#输出记录次数最多的10条SQL语句
$PATH/mysqldumpslow -s c -t 10 /database/mysql/slow-log

参数说明:
-s:
    是表示按照何种方式排序，c、t、l、r分别是按照记录次数、时间、查询时间、返回的记录数来排序，ac、at、al、ar，表示相应的倒叙；
-t:
	是top n的意思，即为返回前面多少条的数据；
-g:
	后边可以写一个正则匹配模式，大小写不敏感的；

#得到返回记录集最多的10个查询
$PATH/mysqldumpslow -s r -t 10 /database/mysql/slow-log
#得到按照时间排序的前10条里面含有左连接的查询语句
$PATH/mysqldumpslow -s t -t 10 -g “left join”/database/mysql/slow-log

第三方推荐（扩展）
#tinghua mirror
yum install https://mirrors.tuna.tsinghua.edu.cn/percona/yum/percona-release-latest.noarch.rpm
yum clean all && yum makecache

[root@db03 ~]# yum list percona*
$ percona-release enable tools
$ yum install -y percona-toolkit

#xtrabackup对应mysql版本
percona-xtrabackup-24       # for 5.6/5.7
percona-xtrabackup-80       # for 8.0

[root@db03 ~]# pt-query-digest /application/mysql/data/slow.log

# MySQL的备份和恢复

## 备份原因

运维工作的核心简单概括就两件事:
    1）第一个是保护公司的数据.
    2）第二个是让网站能7*24小时提供服务(用户体验)。

1）备份就是为了恢复。
2）尽量减少数据的丢失（公司的损失）

## 备份类型
	- 冷备份  # 停业务备份
	- 温备份  # 用户可读取数据,但不能修改数据情况下备份
	- 热备份  # 用户可读取和修改的操作下 备份

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





