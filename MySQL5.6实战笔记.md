
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
#查看binlog信息
mysql> show master status;
#创建一个binlog库
mysql> create database binlog;
#使用binlog库
mysql> use binlog
#创建binglog_table表
mysql> create table binlog_table(id int);
#查看binlog信息
mysql> show master status;
#插入数据1
mysql> insert into binlog_table values(1);
#查看binlog信息
mysql> show master status;
#提交
mysql> commit;
#查看binlog信息
mysql> show master status;
#插入数据2
mysql> insert into binlog_table values(2);
#插入数据3
mysql> insert into binlog_table values(3);
#查看binlog信息
mysql> show master status;
#提交
mysql> commit;
#删除数据1
mysql> delete from binlog_table where id=1;
#查看binlog信息
mysql> show master status;
#提交
mysql> commit;
#更改数据2为22
mysql> update binlog_table set id=22 where id=2;
#查看binlog
mysql> show master status;
#提交
mysql> commit;
#查看binlog信息
mysql> show master status;
#查看数据
mysql> select * from binlog_table;
#删表
mysql> drop table binlog_table;
#删库
mysql> drop database binlog;
```
恢复数据到delete之前 
```
#查看binlog事件
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
#分析
update binlog.binlog_table
set
@1=22 --------->@1表示binlog_table中的第一列,集合表结构就是id=22
where
@1=2  --------->@1表示binlog_table中的第一列,集合表结构就是id=2
#结果
update binlog.binlog_table set id=22 where id=2;
#截取二进制日志
查看二进制日志后，发现delete语句开始位置是858
[root@db01 data]# mysqlbinlog --start-position=120 --stop-position=858 /application/mysql/data/mysql-bin.000013
#临时关闭binlog
mysql> set sql_log_bin=0;
#执行sql文件
mysql> source /tmp/binlog.sql
#查看删除的库
mysql> show databases;
#进binlog库
mysql> use binlog
#查看删除的表
mysql> show tables;
#查看表中内容
mysql> select * from binlog_table;
```









