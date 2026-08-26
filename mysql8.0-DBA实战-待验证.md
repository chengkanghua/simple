# MySQL 8.0 DBA 实战(从零到 DBA 完整教程)

> 《MySQL8.0 DBA 实战》全套课件覆盖数据库入门 → 安装部署 → 授权认证 → SQL 基础与高级应用 → 数据库设计 → InnoDB 内核 → 字符集 → 锁与事务 → 表分区 → 主从复制 → 高可用架构(Mycat / Atlas / MHA / MMM)→ 周边组件(Redis / Elasticsearch / MongoDB)→ 备份恢复 → 索引调优 → 常见错误 → Percona Toolkit 自动化运维,目标是打造一份**从零开始学到 DBA 水平**的实战手册。

## 内容大纲

| 章节 | 主题 | 核心内容 |
|---|---|---|
| 第1课 | 数据库介绍篇 | 数据库概念、类型、关系型数据库、SQL 简介 |
| 第2课 | MySQL 入门介绍 | 历史、分支、架构、存储引擎、安装部署、连接管理 |
| 第3课 | MySQL 授权认证 | 权限体系、用户管理、GRANT/REVOKE、权限表 |
| 第4课 | SQL 基础语法 | 库表操作、增删改查、DML/DDL/DCL |
| 第5课 | MySQL 常用函数 | 字符串/数值/日期/流程控制/加密等函数 |
| 第6课 | SQL 高级应用 | 多表连接、子查询、视图、存储过程、触发器、事务 |
| 第7课 | MySQL 数据库设计 | 范式、数据类型、字符集、索引设计、ER 建模 |
| 第8课 | InnoDB 内核 | 页结构、B+树、redo/undo log、MVCC、双写 |
| 第9课 | MySQL 字符集 | 字符集与排序规则、utf8/utf8mb4、乱码排查 |
| 第10课 | 锁机制和事务 | 锁类型、事务隔离级别、MVCC、死锁 |
| 第11课 | MySQL 表分区 | RANGE/LIST/HASH/KEY、子分区、分区管理 |
| 第12课 | MySQL 复制 | binlog 复制、GTID、半同步、主从切换、延迟复制 |
| 第13课 | 高可用之 Mycat | 分库分表中间件、schema.xml、分片规则、读写分离 |
| 第14课 | 高可用之 Atlas | 360 中间件、读写分离、负载均衡、分表分片 |
| 第15课 | 高可用之 MHA/MMM | 故障自动切换、在线切换、VIP 漂移、架构对比 |
| 第16课 | MySQL 备份和恢复 | mysqldump、物理备份、时间点恢复、Xtrabackup |
| 第17课 | MySQL 索引和调优 | 索引原理、Explain、慢查询、调优规则 |
| 第18课 | MySQL 常见错误 | 权限/锁/连接/外键/GTID 等常见报错排查 |
| 第19课 | MySQL 8.0 新特性实战 | 窗口函数/CTE/角色/INSTANT 加列/直方图/不可见索引/函数索引/EXPLAIN ANALYZE/SET PERSIST/JSON/caching_sha2_password |
| 第20课 | MGR 组复制与 InnoDB Cluster | 组复制原理、单主/多主、部署、MySQL Shell、Router、高可用选型 |
| 第21课 | 性能监控与压测调优 | performance_schema/sys、慢查询分析、sysbench 压测、参数调优清单、Prometheus 监控 |
| 第22课 | 升级迁移与安全加固 | 5.7→8.0 升级、Clone 插件、SSL/TLS、审计、安全基线、巡检 |
| 第23课 | Percona Toolkit 实战 | pt-archiver/pt-kill/pt-osc/pt-query-digest 自动化 |
| 第24课 | Redis 数据库实战 | 数据类型、主从、哨兵、Cluster、迁移与运维 |
| 第25课 | Elasticsearch | 全文搜索、集群、分片副本、ELK 日志收集 |
| 第26课 | MongoDB | 文档数据库、副本集、认证、备份恢复 |

## 学习路线建议

1. **入门**(第1~4课):搞懂数据库概念与基本 SQL,能建库建表、增删改查;
2. **进阶**(第5~9课):函数、高级 SQL、设计规范、存储引擎与字符集;
3. **核心原理**(第8、10课):InnoDB 内核与锁事务,面试与排障的根基;
4. **高可用**(第11~15课):分区、复制、Mycat/Atlas/MHA/MMM,生产架构必备;
5. **生态**(第24~26课):Redis/ES/MongoDB 三大主流 NoSQL 组件;
6. **DBA 必备**(第16~18、23课):备份恢复、索引调优、错误排查、Percona 工具自动化;
7. **8.0 进阶**(第19~22课):8.0 新特性、官方高可用 MGR/InnoDB Cluster、性能监控与压测调优、升级迁移与安全加固——从"会用"到"8.0 DBA"的关键跨越。

> 补充说明:第19~22课为依据 8.0 目标查缺补漏新增的章节(覆盖官方 8.0 新特性、官方高可用、监控压测、升级安全),其余为课件原文整理。

---

# 第1课 数据库介绍篇

## 1.1 数据库背景知识

- **数据 + 库**:将信息(数据)按照计算机可识别的方式规则存放在磁盘库中,并提供一系列可供读写的方式。
- 相比较于磁盘文件,数据库最大的特点是提供了非常灵活的接口、方式可以获取完整数据或者特定部分数据(SQL);并提供了一套完整管理数据的方法(存储结构、备份恢复等)。
- **为什么要存储数据?**
  1. 数据要被随时随地反复使用,不是一次性消耗品
  2. 数据要被记录,防止遗忘

**生活例子——学校选课系统**:程序与后台数据库交互。后台数据库记录课程信息、学生信息、学生与课程的对应关系等。
- 学生登录账号 → 程序提取该学生所有信息,按格式展示到电脑上
- 学生选定课程 → 程序将选课信息记录到数据库

## 1.2 数据库在企业中的使用

- 企业无论大小,日常经营活动都会涉及数据存储,尤其是互联网公司,都会选择数据库作为存储数据的重要甚至唯一渠道。
- 涵盖的数据:客户数据、员工数据、财务数据、交易数据、物流数据、运营数据等。

## 1.3 数据库发展历史(时间线)

| 时间 | 事件 |
|---|---|
| 1964年 | 美国通用电气开发出**第一套数据库系统** |
| 1970年 | 提出**关系型数据库模型** |
| 1974年 | 辩论及研讨,确立关系数据库为现代数据库产品的主流 |
| 1974年 | 第一次提出 **SQL**(Structured Query Language)概念 |
| 1986年 | SQL 正式成为关系型数据库的标准语言,即 **SQL-86 标准** |
| 之后 | 陆续经历 SQL-89、SQL-92 标准,以及目前的 SQL3 标准 |
| web2.0 之后 | 非关系型数据库陆续火热起来 |

## 1.4 常见的数据库类型

### 关系型数据库
- 目前市场上占主要份额,以**二维表格**(行和列,类似 Excel)存储数据,表格之间用**字段引用**表示数据关系。
- 代表:Oracle、SQL Server、MySQL、DB2 等。

### 非关系型数据库(NoSQL)
出现时间较短,抛弃关系型死板的存储方式,提供更灵活的方式,分三类:

| 类型 | 特点 | 代表 |
|---|---|---|
| key-value 数据库 | 极高的并发读写性能 | Redis、Tokyo Cabinet、Flare |
| 文档型数据库 | 海量数据中快速查询 | MongoDB、CouchDB |
| 分布式数据库 | 解决传统数据库扩展性缺陷 | Cassandra 等 |

### 企业中的选择
- 常用数据存放在**关系型数据库**中;
- 逐步考虑用非关系型数据库支持部分业务;
- 但**关系型数据库还是主流**。

## 1.5 MySQL 简介

- MySQL 是一种**开放源代码的关系型数据库管理系统(RDBMS)**,使用 SQL(结构化查询语言)进行数据库管理。
- 历史最早可追溯到 **1979 年**。
- **2008年1月16日**被 Sun 公司收购;**2009年** Sun 又被 Oracle 收购。
- 优点:体积小、速度快、总体拥有成本低,尤其是**开放源码**,使得许多企业选择 MySQL。

## 1.6 数据库工程师在企业中的职责与定位

### 三类岗位

| 岗位 | 职责 |
|---|---|
| 数据库开发工程师 | ① 业务数据库系统的模型设计、表结构设计 ② 数据处理语句实现、存储过程逻辑实现 ③ 指导开发人员对语句性能优化 |
| 数据库管理员(DBA) | ① 业务数据库系统的部署实现 ② 数据库系统的高可用、备份恢复、性能调优、监控实现 |
| 数据库架构师 | ① 统筹业务数据库系统各层面的技术实现 ② 指导开发工程师和 DBA 工作,提供更优方案 |

### 企业中的定位
- **职能角度**:数据是所有企业的重要资产,互联网企业更是将数据视为生命线。优秀数据库工程师掌握企业核心价值,地位相对高,责任越大、地位越高、薪资越高。
- **竞争角度**:数据库工程师人数较少(1:10 或更高),"物以稀为贵",不可替代性强。

### 职业优劣势
- **优势**:不吃青春饭、越老越吃香,看重经验、生命周期长;公司地位高、薪资高。
- **劣势**:和运维体系有交叉,比较辛苦,需随时待命;岗位人数少,比较孤独。

## 1.7 数据库通用术语中英文对照(术语词典)

> 注意:本节是"术语词典",不是"数据库对象"清单。其中**数据库对象(database object)**特指数据库中实际存在、可被创建和管理的实体(表、索引、视图、存储过程、触发器、用户、主键/外键/唯一约束等);data/database/DBMS/instance 等属于**基础概念**;`select/update/delete/insert`、`grant/revoke` 则是 **SQL 语句关键字**(详细语法见第 4 课)。

| 术语 | 英文 | 说明 |
|---|---|---|
| 数据 | data | 对客观事件进行记录并可以鉴别的符号 |
| 数据库 | database | 存放数据的最大的逻辑对象,可按需求将同一项目数据放一个库中 |
| 数据库管理系统 | DBMS | 操纵和管理数据库的大型软件,分关系型和非关系型两种 |
| 关系型数据库管理系统 | RDBMS | 以关系模型为基础建立的数据库管理软件(Oracle/MySQL/SQL Server) |
| 实例 | instance | 数据库软件安装后启动起来就是一个实例;一台服务器可启动多个实例,一个实例可包含多个数据库 |
| 数据库对象 | database object | 数据库中用来存储、操作数据的对象:表、字段、索引、存储过程等 |
| 表 | table | 存储相同属性的数据,类似 Excel 的 sheet |
| 字段/列/属性 | field/column/attribute | 表中数据的组成部分,类似 Excel 的列 |
| 类型 | type | 字段属性之一,代表该字段下数据以什么形式呈现(整数、字符串等) |
| 键值 | key | 数据表的一个属性,可指定主键、外键 |
| 索引 | index | 为加速数据读取速度而创建的数据结构 |
| 视图 | view | 为简化部分数据获取方法而创建的定义 |
| 存储过程 | stored procedure(SP) | 在数据库内部创建的具有一系列数据处理逻辑的方法 |
| 触发器 | trigger | 当数据库表发生修改操作时自动触发某些数据处理的方法 |
| 数据库服务器 | database server | 特指运行数据库实例的物理或虚拟服务器 |
| 主键 | primary key | 唯一确定表中各行数据的一个或几个字段 |
| 外键 | foreign key | 当表中某些字段值来源于某个父表时,创建两个表之间的数据映射关系 |
| 唯一 | unique | Primary key 和 unique index 都可约束该列数据不重复 |
| 备份 | backup | 将数据库所有数据/对象导出成文件形式存储 |
| 恢复 | restore | 利用备份文件将数据库还原到备份时的状态 |
| 用户 | user | 为访问数据库中数据而创建的权限 |
| 授权 | grant | 授予某个数据库用户某个权限的动作 |
| 回收 | revoke | 将某个数据库用户的某个权限回收的动作 |
| 权限 | privilege | 用户对数据库对象执行操作的权利 |
| 查询/修改/删除/添加 | select/update/delete/insert | 数据库中浏览/修改/删除/新增数据的方法 |
| SQL 语句 | SQL statement | 对数据库中数据进行操作、管理的一套语法 |
| 数据库架构 | database architecture | 对数据库一个或多个实例的部署、数据协同、高可用、并发性等做的统一规划 |


---

# 第2课 MySQL 入门介绍

> 本课来源:《第二课MySQL入门介绍.pdf》(崔冬青 · 老男孩IT教育)

## 2.1 MySQL 是什么

- MySQL 是一种**开放源代码的关系型数据库管理系统(RDBMS)**,使用 SQL 进行数据库管理。
- 历史最早可追溯到 **1979 年**;2008年被 Sun 收购,2009年 Sun 又被 Oracle 收购。
- 体积小、速度快、总体拥有成本低,开放源码,被许多企业选择。

## 2.2 官网与资源

| 资源 | 地址 |
|---|---|
| 官方主页 | https://www.oracle.com/mysql/index.html |
| 下载主页面 | https://www.mysql.com/downloads/ |
| 社区资源下载页面 | https://dev.mysql.com/downloads/ |
| 社区版下载页面 | https://dev.mysql.com/downloads/mysql/ |

## 2.3 MySQL 相关产品

### 商业产品
| 产品 | 说明 |
|---|---|
| Oracle MySQL Cloud Service | 商业付费,基于 MySQL 企业版和 Oracle 云服务提供企业级数据库服务 |
| MySQL Enterprise Edition | 商业付费,包含数据库服务 + Connector(程序连接接口)+ Partition(表分区)+ Monitor(监控)+ HA(高可用)+ Backup(备份)+ Scalability(扩展) |
| MySQL Cluster CGE | 商业付费,基于 MySQL Cluster 和企业版功能,提供高并发、高吞吐的数据库服务 |

### 社区产品
| 产品 | 说明 |
|---|---|
| MySQL Community Server | 最流行的开源数据库管理软件 |
| MySQL Cluster | 基于 MySQL 的集群服务,自带高并发高负载特性 |
| MySQL Fabric | 官方提供的 MySQL 高可用和数据分片解决方案 |
| MySQL Connectors | 为应用程序提供 JDBC/ODBC 等访问 MySQL 的接口服务 |

## 2.4 MySQL 各版本主要区别(升级路线图)

| 版本 | 主要新增/变化 |
|---|---|
| 4.0 | 子查询支持、字符集增加 UTF-8、GROUP BY 增加 ROLLUP、mysql.user 表更好加密算法、InnoDB 开始支持单独表空间 |
| 5.0 | 存储过程 Stored procedures、视图 Views、游标 Cursors、触发器 Triggers、XA 事务支持、增加 INFORMATION_SCHEMA 系统数据库 |
| 5.5 | **默认存储引擎更改为 InnoDB**,提高性能和可扩展性,增加半同步复制 |
| 5.6 | 提高 InnoDB 性能,支持延迟复制 |
| 5.7 | 提升数据库性能和存储引擎,更健壮的复制功能,增加 sys 系统库存放数据库管理信息;**mysql 系统库表由 MyISAM 改为 InnoDB**(注意:默认引擎是 5.5 就改成 InnoDB 的,5.7 改的是系统表) |
| 8.0 | 默认字符集 utf8mb4;新增窗口函数/CTE、原子 DDL、数据字典重构、caching_sha2_password 认证、SET PERSIST 参数持久化、直方图/不可见索引/函数索引、INSTANT 秒级加列、EXPLAIN ANALYZE、Clone 插件、角色 Role;彻底移除查询缓存;sql_mode 默认值变化(详见第19课) |

## 2.5 安装准备

### 检查操作系统与 MySQL 版本适配度
- 确认操作系统版本(如 glibc 版本)与 MySQL 安装包匹配(x86_64 / aarch64)。

### 选择版本原则
1. 先判断是否要和公司已有 MySQL 保持版本一致
2. 无此要求则一般装最新稳定版
3. 非实验性质**不要选 development release**,要装 **General Availability(GA)稳定版**

### 安装方式选择
- **二进制安装包**:RPM、ZIP、Tar 等,一般选这种方式
- **源码方式**:有特殊需求(修改源码、深层次配置)才用

## 2.6 Linux 二进制安装 MySQL(经典步骤)

```bash
# 1. 下载正确的 tar 包(glibc 版本、架构匹配)

# 2. 解压到 /usr/local/ 并改名
cd /usr/local/
tar -xvf mysql-5.7.17-linux-glibc2.5-x86_64.tar
tar -zxvf mysql-5.7.17-linux-glibc2.5-x86_64.tar.gz
mv mysql-5.7.17-linux-glibc2.5-x86_64 mysql

# 3. 创建运行用户和组
groupadd mysql
useradd mysql -g mysql

# 4. 创建数据目录并授权
mkdir data
chown -R mysql .
chgrp -R mysql .

# 5. 初始化数据目录(5.7 起用 --initialize,会生成 root 初始随机密码,在错误日志里)
bin/mysqld --initialize --user=mysql --datadir=/usr/local/mysql/data

# 6. 复制默认配置文件
cp -f support-files/my-default.cnf /etc/my.cnf

# 7. 启动 MySQL
bin/mysqld_safe --datadir=/usr/local/mysql/data --user=mysql &

# 8. 加入自启动
cp support-files/mysql.server /etc/init.d/mysql.server
/etc/init.d/mysql.server start
```

**常见报错与解决**:`bin/mysqld: error while loading shared libraries: libaio.so.1: cannot open shared object file` → 安装依赖:`yum install -y libaio`

**不使用推荐路径的方法**:
```bash
bin/mysqld --initialize --user=mysql --basedir=/data/mysql --datadir=/data/mysql/data &
bin/mysqld_safe --basedir=/data/mysql --datadir=/data/mysql/data --user=mysql &
```

**修改 root 初始密码**(5.7 及以前):
```sql
mysql> set password=password('mysql');
mysql> flush privileges;
```

> **8.0 补充**:8.0 初始化命令为 `bin/mysqld --initialize-insecure --user=mysql`(空密码)或 `--initialize`(随机密码,记在错误日志);登录后改密码用 `ALTER USER 'root'@'localhost' IDENTIFIED BY '新密码';`。默认认证插件为 caching_sha2_password。

## 2.7 Windows 安装 MySQL
- 官方推荐使用 **MySQL Installer** 安装:https://dev.mysql.com/downloads/installer/
- 验证:查看 3306 端口已侦听;Windows 服务中 MySQL57 已启动,且"自动"表示重启后自启。
- 数据文件目录在安装时指定。

## 2.8 连接与退出 MySQL

- mysql 专有客户端连接 / Windows command line 连接(需将 MySQL bin 目录加入 PATH 环境变量)
- 切换数据库:`use database_name;`

## 2.9 常用客户端工具

| 工具 | 特点 | 下载 |
|---|---|---|
| Aqua Data Studio | 支持连接多种数据库类型的客户端 | 官网 |
| Navicat for MySQL | 专门针对 MySQL 的图形化客户端 | cr173.com/soft/38153.html |
| SQLyog | 简洁高效、功能强大的 MySQL 图形化管理工具 | cr173.com/soft/126913.html |

## 2.10 MySQL 基本文件结构

**一句话本质**:data 目录(datadir)是 MySQL 数据的"家"——一个数据库一个文件夹,一张 InnoDB 表(默认独立表空间)一个 `.ibd` 文件,公共数据放共享文件。

- **data 目录**为初始化的数据文件存放路径,可用 `show variables like 'datadir';` 查看
- data 目录里为**每一个数据库创建一个文件夹**
- 5.5~5.7 的 InnoDB 核心文件是 `ibdata1`(系统表空间)+ `ib_logfile0/1`(redo 日志)三个**共享文件**;**8.0 起 redo 日志挪进 `#innodb_redo/` 子目录**

### 模拟查看 data 目录(MySQL 8.0 初始化后)

```bash
$ ls -lh /data
total 48M
-rw-r----- 1 mysql mysql 2.8K 8月 26 10:00 auto.cnf          # 服务器 UUID(server-uuid),整目录拷贝到别的机器时要删掉重建,否则 UUID 重复
-rw-r----- 1 mysql mysql 1.7K 8月 26 10:00 ca-key.pem        # SSL 证书私钥(5.7 起初始化自动生成,用于开启加密连接)
-rw-r----- 1 mysql mysql 1.1K 8月 26 10:00 ca.pem            # SSL CA 根证书
-rw-r----- 1 mysql mysql 1.1K 8月 26 10:00 server-cert.pem   # 服务器证书
-rw-r----- 1 mysql mysql 1.7K 8月 26 10:00 server-key.pem    # 服务器私钥
-rw-r----- 1 mysql mysql 1.1K 8月 26 10:00 client-cert.pem   # 客户端证书
-rw-r----- 1 mysql mysql 1.7K 8月 26 10:00 client-key.pem    # 客户端私钥
-rw-r----- 1 mysql mysql  12M 8月 26 10:00 ibdata1           # InnoDB 系统表空间:8.0 里存 change buffer 等共享数据(5.7 里还存数据字典/双写缓冲)
-rw-r----- 1 mysql mysql  26M 8月 26 10:00 mysql.ibd         # 8.0 新增:数据字典 + mysql 系统库表,取代了 5.7 的 .frm 文件
-rw-r----- 1 mysql mysql  80M 8月 26 10:00 undo_001          # undo 回滚日志表空间 1(5.6 起从 ibdata1 中独立出来)
-rw-r----- 1 mysql mysql  80M 8月 26 10:00 undo_002          # undo 回滚日志表空间 2
-rw-r----- 1 mysql mysql  12M 8月 26 10:00 ib_buffer_pool    # 上次关闭时缓冲池内容转储,启动时"预热"用(可选)
-rw-r----- 1 mysql mysql  12M 8月 26 10:00 ibtmp1            # 磁盘临时表空间(大排序、临时表数据溢出时用)
drwxr-x--- 2 mysql mysql 4.0K 8月 26 10:00 mysql/            # mysql 系统库目录(8.0 里基本为空,系统表都在 mysql.ibd 中)
drwxr-x--- 2 mysql mysql 4.0K 8月 26 10:00 performance_schema/ # 性能库目录(内存表,无落盘文件)
drwxr-x--- 2 mysql mysql 4.0K 8月 26 10:00 sys/              # sys 视图库(5.7 起,基于 performance_schema 封装)
drwxr-x--- 2 mysql mysql 4.0K 8月 26 10:00 #innodb_redo/     # 8.0 的 redo 重做日志目录,内含 32 个 ib_logfileN(8.0.30+ 改名 #ib_redoN),默认共 100MB
drwxr-x--- 2 mysql mysql 4.0K 8月 26 10:00 #innodb_temp/     # 8.0 会话临时表空间目录
-rw-r----- 1 mysql mysql  154 8月 26 10:00 binlog.000001     # 二进制日志(需开启 log_bin 才会有)
-rw-r----- 1 mysql mysql   80 8月 26 10:00 binlog.index      # 二进制日志索引文件
```

### 模拟查看一个业务库目录(你的表存在哪)

```bash
# MySQL 5.7 及以前:一张表 = 表结构 + 表数据 两个文件
$ ls -lh /data/mydb
total 20M
-rw-r----- 1 mysql mysql 8.6K 8月 26 10:00 db.opt     # 库默认字符集/排序规则
-rw-r----- 1 mysql mysql 8.5K 8月 26 10:00 t1.frm     # 表结构定义
-rw-r----- 1 mysql mysql  20M 8月 26 10:00 t1.ibd     # 表的数据 + 索引(独立表空间)

# MySQL 8.0:.frm 和 db.opt 都取消了,表结构收进数据字典(mysql.ibd),表目录下只剩 .ibd
$ ls -lh /data/mydb
total 20M
-rw-r----- 1 mysql mysql 20M 8月 26 10:00 t1.ibd      # 表数据 + 索引;表结构在 mysql.ibd 数据字典里
```

### 别绕晕:目录层级到底长啥样

**核心一句话:`/data` 这个路径名不是"MySQL 数据库",它是 data 目录(datadir)——所有数据库的"总容器";里面每个子目录才是一个数据库**:

```text
/data                                 ← datadir 根目录
│
├── [文件们]  ← 全部直接躺在 datadir 根目录下,和下面的库目录"平级",不是谁的爹
│   ├── auto.cnf            # 服务器 UUID
│   ├── *.pem               # SSL 证书
│   ├── ibdata1             # 系统表空间
│   ├── mysql.ibd           # 8.0 数据字典 + mysql 系统库表数据
│   ├── undo_001/undo_002   # undo 回滚日志
│   └── binlog.000001 ...   # 二进制日志
│
├── [库目录们]  ← 每个子目录 = 一个数据库
│   ├── mysql/              # 系统库 mysql(存 user/权限表等)
│   ├── performance_schema/ # 性能库(内存表)
│   ├── sys/                # 视图库(5.7+)
│   └── mydb/               # 你自己建的业务库
│       └── t1.ibd          # 表 t1 的数据 + 索引(表结构在根目录的 mysql.ibd 数据字典里)
```

所以三个关键路径是:
- `/data/mysql.ibd` —— 共享文件(在 datadir **根目录**)
- `/data/mysql/` —— 系统库**目录**(和上面那个文件平级)
- `/data/mydb/t1.ibd` —— 业务库里的表文件

> **对照官方二进制包默认**(标准):basedir = `/usr/local/mysql`,datadir = `/usr/local/mysql/data`。把示例里的 `/data` 整体换成 `/usr/local/mysql/data` 即可,结构一模一样:
> `/usr/local/mysql/data/mysql.ibd`(共享文件)、`/usr/local/mysql/data/mysql/`(系统库目录)、`/usr/local/mysql/data/mydb/t1.ibd`(业务表)。
> 另外 yum/apt 包安装的默认 datadir 是 `/var/lib/mysql`。

| 出现的 `mysql` | 是什么 | 在哪 |
|---|---|---|
| `/data` | datadir **路径名**(安装时自己起的) | 磁盘路径 |
| `mysql/` | 名为 mysql 的**系统库**(存用户/权限表) | datadir 下的子目录 |
| `mysql.ibd` | 8.0 的**共享表空间文件**(数据字典 + mysql 库数据) | datadir 根目录,与 `mysql/` 平级 |

### 关键概念:共享文件 vs 每表独立文件

| 文件 | 类型 | 说明 |
|---|---|---|
| `ibdata1` | 共享(所有库共用) | 系统表空间。5.7 存数据字典/双写缓冲/change buffer;8.0 主要存 change buffer(8.0.20+ 双写缓冲独立为 `#ib_*.dblwr`) |
| `ib_logfile0/1` | 共享 | redo 重做日志,5.5~5.7 在 data 根目录;**8.0 起在 `#innodb_redo/` 目录内**(默认约 32 个文件共 100MB) |
| `undo_001/002` | 共享 | undo 回滚日志,5.6 起从 ibdata1 独立 |
| `mysql.ibd` | 共享 | **仅 8.0**:数据字典 + mysql 系统库表 |
| `mydb/t1.ibd` | 每表一个 | 独立表空间(默认 `innodb_file_per_table=ON`),每张表独占一个文件,drop 表时空间立即释放给 OS |

## 2.11 MySQL 启动相关参数(my.cnf 常用参数)

| 参数 | 说明 |
|---|---|
| basedir | MySQL 安装路径 |
| datadir | MySQL 数据文件路径 |
| port | 监听端口(默认 3306) |
| log-error | 启动日志和运行错误日志路径 |
| bind-address | 默认 `*` 接受所有 IPv4/IPv6 连接;`0.0.0.0` 只接受 IPv4;指定 IP 则只接受该地址连接 |
| character-set-server | 默认 latin1,指定字符集 |
| collation-server | 默认 latin1_swedish_ci,指定排序规则 |
| default-storage-engine | 默认 InnoDB |
| default-time-zone | 默认时区,不指定则与系统一致 |
| open-files-limit | 默认 5000,限制可打开文件数,避免 "Too many open files" |
| pid-file | mysqld 进程 ID 文件 |
| skip-grant-tables | 跳过内部权限表启动(忘记密码时用) |
| tmpdir | 临时表文件存放路径 |

## 2.12 修改参数后重启验证

**改端口为 3307**:修改 my.cnf 的 port → `/etc/init.d/mysql.server restart`

**改字符集为 utf8**:
```ini
character-set-server = utf8
collation-server = utf8_unicode_ci
```
重启后验证:
```sql
mysql> show variables like 'character_set_server%';
mysql> show variables like 'collation_server%';
```

**改数据目录到 /data/**:
```bash
/etc/init.d/mysql.server stop
mv data /data/
# 修改 my.cnf: datadir = /data/data
/etc/init.d/mysql.server start
```


---

# 第3课 MySQL 授权认证(权限体系)

## 3.1 权限系统介绍

- 权限系统的作用:授予来自**某个主机**的**某个用户**可以查询、插入、修改、删除等数据库操作的权限。
- **不能明确指定拒绝某个用户的连接**(只能通过不授权来间接限制)。
- 权限控制(授权与回收)的执行语句:`CREATE USER`、`GRANT`、`REVOKE`。
- 授权后的权限都存放在 MySQL 的内部数据库 **mysql**(库),并在启动后把权限信息**复制到内存**中。
- **MySQL 用户的认证信息不光包括用户名,还要包含连接发起的主机**。以下两个被认为是**不是**同一个用户:
  - `SHOW GRANTS FOR 'joe'@'office.example.com';`
  - `SHOW GRANTS FOR 'joe'@'home.example.com';`

## 3.2 权限级别(三级)

| 级别 | 作用范围 |
|---|---|
| 全局性管理权限 | 作用于整个 MySQL 实例级别 |
| 数据库级别权限 | 作用于某个指定的数据库或所有数据库 |
| 数据库对象级别权限 | 作用于指定的对象(表、视图等)或所有对象 |

权限存储在 mysql 库的 `user`、`db`、`tables_priv`、`columns_priv`、`procs_priv` 几个系统表中,实例启动后加载到内存。

## 3.3 查看默认用户权限(案例)

**root@localhost**(全局最高权限):
```sql
mysql> SHOW GRANTS FOR root@localhost;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION
```
对应的系统表:
- `user` 表:全是 'Y'(全局权限)
- `db` / `tables_priv` / `columns_priv` / `procs_priv`:无记录

**mysql.sys@localhost**(sys 库专用账号):
```sql
GRANT USAGE ON *.* TO 'mysql.sys'@'localhost';
GRANT TRIGGER ON `sys`.* TO 'mysql.sys'@'localhost';
GRANT SELECT ON `sys`.`sys_config` TO 'mysql.sys'@'localhost';
```
对应的系统表:user 表全是 'N';db 表有一条(sys 库 TRIGGER 权限为 Y);tables_priv 有一条(sys_config 表 select 权限)。

## 3.4 权限详解(逐条背下来)

| 权限 | 含义 |
|---|---|
| ALL / ALL PRIVILEGES | 全局或全数据库对象级别的所有权限 |
| ALTER | 修改表结构;必须配合 create 和 insert。rename 表名要求有 alter 和 drop 原表、create 和 insert 新表 |
| ALTER ROUTINE | 修改或删除存储过程、函数 |
| CREATE | 创建新的数据库和表 |
| CREATE ROUTINE | 创建存储过程、函数 |
| CREATE TABLESPACE | 创建、修改、删除表空间和日志组 |
| CREATE TEMPORARY TABLES | 创建临时表 |
| CREATE USER | 创建、修改、删除、重命名 user |
| CREATE VIEW | 创建视图 |
| DELETE | 删除行数据 |
| DROP | 删除数据库、表、视图,包括 TRUNCATE TABLE |
| EVENT | 查询、创建、修改、删除 MySQL 事件 |
| EXECUTE | 执行存储过程和函数 |
| FILE | 在 MySQL 可访问目录读写磁盘文件:LOAD DATA INFILE、SELECT ... INTO OUTFILE、LOAD_FILE() 函数 |
| GRANT OPTION | 是否允许此用户授权或收回给其他用户你给予的权限 |
| INDEX | 创建和删除索引 |
| INSERT | 插入数据;执行 ANALYZE TABLE、OPTIMIZE TABLE、REPAIR TABLE 也需要 |
| LOCK TABLES | 锁定拥有 SELECT 权限的表,防止其他连接读写 |
| PROCESS | 查看进程信息:SHOW PROCESSLIST、mysqladmin processlist、SHOW ENGINE 等 |
| REFERENCES | 5.7.6 之后引入,允许创建外键 |
| RELOAD | 执行 FLUSH 命令,重新加载权限表到内存;REFRESH 代表关闭重开日志文件并刷新所有表 |
| REPLICATION CLIENT | 允许执行 SHOW MASTER STATUS、SHOW SLAVE STATUS、SHOW BINARY LOGS |
| REPLICATION SLAVE | 允许 slave 主机通过此用户连接 master 建立主从复制 |
| SELECT | 从表中查看数据;某些不查表的 select 不需要(如 `SELECT 1+1`);update/delete 语句中带 where 也需要 select 权限 |
| SHOW DATABASES | 执行 SHOW DATABASES 查看所有库名 |
| SHOW VIEW | 执行 SHOW CREATE VIEW 查看视图创建语句 |
| SHUTDOWN | 关闭数据库实例,如 mysqladmin shutdown |
| SUPER | 一系列管理命令:kill 连接、change master to 建复制、create/alter/drop server 等 |
| TRIGGER | 创建、删除、执行、显示触发器 |
| UPDATE | 修改表中的数据 |
| USAGE | 创建用户后的默认权限,本身代表**连接登录权限**(无任何操作权限) |

## 3.5 系统权限表

| 表 | 存放的权限级别 |
|---|---|
| user | 用户账户信息 + **全局级别**(所有数据库)权限。有全局权限则对所有库都有权限 |
| db | **数据库级别**权限:哪些主机的哪些用户可以访问此数据库 |
| tables_priv | **表级别**权限 |
| columns_priv | **列级别**权限 |
| procs_priv | **存储过程和函数级别**权限 |

### user 表特殊字段
| 字段 | 说明 |
|---|---|
| plugin / password / authentication_string | 用户认证信息 |
| password_expired | 'Y' 表示密码已过期,使用者需重置(alter user / set password) |
| password_last_changed | 时间戳,密码上次修改时间;create user/alter user/set password/grant 时自动更新 |
| password_lifetime | 从 password_last_changed 起密码过期的天数 |
| account_locked | 用户被锁,无法使用 |

### 字段长度限制与大小写敏感
- 大小写**敏感**字段:user、password、authentication_string、db、table_name
- 大小写**不敏感**字段:host、column_name、routine_name
- 案例:已存在 `abc@localhost`,创建 `Abc@localhost` 可以,再创建 `abc@localhost` 报错(ERROR 1396);host `Localhost` 与 `localhost` 视为同一个(不敏感)

## 3.6 查看用户权限

```sql
SHOW GRANTS FOR 'root'@'localhost';       -- 查看授权信息
SHOW CREATE USER 'root'@'localhost';      -- 查看用户的非授权信息(认证方式、密码过期、锁定状态)
```

## 3.7 授权用户(账户 = 用户名 + 主机)

- 语法:`'user_name'@'host_name'`;单引号非必须,但包含特殊字符时必须是
- `''@'localhost'` 代表匿名用户
- host 可以是主机名或 IPv4/IPv6:`localhost`(本机)、`127.0.0.1`(IPv4 本机)、`::1`(IPv6 本机)
- host 支持通配符 `%` 和 `_`:`'%'` 所有主机;`'%.mysql.com'` mysql.com 域名下所有主机;`'192.168.1.%'` 该网段所有主机

## 3.8 修改权限如何生效

- 执行 **GRANT / REVOKE / SET PASSWORD / RENAME USER** 命令后,MySQL 自动同步到内存。
- 若用 **INSERT / UPDATE / DELETE 直接操作系统权限表**,必须执行刷新命令:`FLUSH PRIVILEGES` / `mysqladmin flush-privileges` / `mysqladmin reload`。
- 生效时机:
  - tables / columns 级别:客户端下次操作生效
  - database 级别:客户端执行 `use database` 后生效
  - global 级别:重新创建连接后生效
- `--skip-grant-tables` 可跳过所有权限表允许所有用户登录,只在特殊情况下暂时使用(如忘记 root 密码)。

## 3.9 连接 MySQL

```bash
mysql --user=finley --password db_name
mysql -u finley -p db_name
mysql --user=finley --password=password db_name
mysql -u finley -ppassword db_name
```

## 3.10 创建用户(两种方式)

- **推荐**:`CREATE USER` / `GRANT` 命令
- 不推荐:直接 INSERT 系统权限表

```sql
-- 全库全权限(注意 % 与 localhost 是两个不同用户)
CREATE USER 'finley'@'localhost' IDENTIFIED BY 'some_pass';
GRANT ALL PRIVILEGES ON *.* TO 'finley'@'localhost' WITH GRANT OPTION;
CREATE USER 'finley'@'%' IDENTIFIED BY 'some_pass';
GRANT ALL PRIVILEGES ON *.* TO 'finley'@'%' WITH GRANT OPTION;

-- 管理账号:只给 reload、process
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin_pass';
GRANT RELOAD, PROCESS ON *.* TO 'admin'@'localhost';

-- 列级别授权
GRANT SELECT(id) ON test.temp TO 'cdq'@'localhost';

-- 不同主机给不同库权限(一个用户多个账户)
CREATE USER 'custom'@'localhost' IDENTIFIED BY 'obscure';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP ON bankaccount.* TO 'custom'@'localhost';
CREATE USER 'custom'@'%.example.com' IDENTIFIED BY 'obscure';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP ON customer.* TO 'custom'@'%.example.com';
```

## 3.11 回收与删除用户

```sql
REVOKE select ON `sys`.`sys_config` FROM 'mysql.sys'@'localhost';  -- 回收权限
DROP USER 'jeffrey'@'localhost';                                   -- 删除用户
```

## 3.12 用户资源限制

- 全局变量 `max_user_connections` 可限制所有用户同一时间连接数,但无法对单个用户区别对待。

| 限制项 | 含义 |
|---|---|
| MAX_QUERIES_PER_HOUR | 一小时可执行查询次数(基本包含所有语句) |
| MAX_UPDATES_PER_HOUR | 一小时可执行修改次数(仅修改库/表的语句) |
| MAX_CONNECTIONS_PER_HOUR | 一小时可连接 MySQL 的次数 |
| MAX_USER_CONNECTIONS | 同一时间可连接实例的数量 |

```sql
CREATE USER 'francis'@'localhost' IDENTIFIED BY 'frank'
WITH MAX_QUERIES_PER_HOUR 20
     MAX_UPDATES_PER_HOUR 10
     MAX_CONNECTIONS_PER_HOUR 5
     MAX_USER_CONNECTIONS 2;
ALTER USER 'francis'@'localhost' WITH MAX_QUERIES_PER_HOUR 100;
-- 取消某项限制 = 改成 0
ALTER USER 'francis'@'localhost' WITH MAX_CONNECTIONS_PER_HOUR 0;
```
> 注意:某用户 max_user_connections 非 0 时忽略全局参数;反之全局参数生效。5.0.3 起对 `user@'%.example.com'` 的资源限制针对整个域名,不是单独每个主机。

## 3.13 设置用户密码

```sql
CREATE USER 'jeffrey'@'localhost' IDENTIFIED BY 'mypass';
ALTER USER 'jeffrey'@'localhost' IDENTIFIED BY 'mypass';             -- 8.0 推荐
SET PASSWORD FOR 'jeffrey'@'localhost' = PASSWORD('mypass');          -- 5.7 及以前
GRANT USAGE ON *.* TO 'jeffrey'@'localhost' IDENTIFIED BY 'mypass';   -- 旧用法
mysqladmin -u user_name -h host_name password "new_password"          -- shell 方式
-- 改自己密码
ALTER USER USER() IDENTIFIED BY 'mypass';
SET PASSWORD = PASSWORD('mypass');
```

## 3.14 密码过期策略

- 系统参数 `default_password_lifetime`:作用于所有用户。`180` 表示 180 天过期;`0` 表示永不过期。
- 单独设置会覆盖系统参数:
```sql
ALTER USER 'jeffrey'@'localhost' PASSWORD EXPIRE INTERVAL 90 DAY;  -- 90 天
ALTER USER 'jeffrey'@'localhost' PASSWORD EXPIRE NEVER;             -- 不过期
ALTER USER 'jeffrey'@'localhost' PASSWORD EXPIRE DEFAULT;           -- 默认策略
ALTER USER 'jeffrey'@'localhost' PASSWORD EXPIRE;                   -- 手动强制过期
```
- 强制过期后登录执行任何语句报:`ERROR 1820: You must SET PASSWORD before executing this statement`,需先 `ALTER USER USER() IDENTIFIED BY 'new_password';`

## 3.15 用户锁 account lock / unlock

- `CREATE USER` 默认 unlock;`ALTER USER` 默认不改 lock/unlock 状态。
```sql
CREATE USER abc2@localhost IDENTIFIED BY 'mysql' ACCOUNT LOCK;
ALTER USER 'mysql.sys'@localhost ACCOUNT LOCK;
ALTER USER 'mysql.sys'@localhost ACCOUNT UNLOCK;
```
- 被锁用户登录报错:`Access denied for user 'user_name'@'host_name'. Account is locked.`

## 3.16 企业生产中的常规用户规范

- 用户创建由 **DBA 统一协调、按需创建**;DBA 通常直接用 root 管理。
- **应用连接账号**:只给业务库的增删改查、临时表、存储过程权限:
```sql
CREATE USER app_full IDENTIFIED BY 'mysql';
GRANT SELECT,UPDATE,INSERT,DELETE,CREATE TEMPORARY TABLES,EXECUTE ON esn.* TO app_full@'10.0.0.%';
```
- **只读账号**:给指定库 select 权限,防止数据被修改:
```sql
CREATE USER app_readonly IDENTIFIED BY 'mysql';
GRANT SELECT ON esn.* TO app_readonly@'10.0.0.%';
```
- **密码规范**:企业生产密码设定有严格要求(复杂度、长度),用密码生成器生成随机密码。

## 3.17 MySQL 8.0 角色管理(Role)

**一句话本质:角色 = 一篮子权限的模板,把角色授给用户,批量授权/回收一步到位(类似 Linux 用户组),不用反复 GRANT 多条权限。**

```sql
-- 1. 创建角色(角色相当于"待授权的用户",无密码)
CREATE ROLE 'app_ro', 'app_rw';
GRANT SELECT, INSERT, UPDATE, DELETE ON appdb.* TO 'app_rw';
GRANT SELECT ON appdb.* TO 'app_ro';

-- 2. 角色授给用户(用户同时拥有自身权限 + 角色权限)
GRANT 'app_rw' TO 'zhangsan'@'%';

-- 3. 激活:默认登录不生效
SET DEFAULT ROLE 'app_rw' FOR 'zhangsan'@'%';  -- 登录自动激活(生产推荐)
SET ROLE 'app_rw';                             -- 本次会话临时激活
SET ROLE NONE;                                 -- 停用全部角色

-- 4. 查看
SELECT CURRENT_ROLE();                                    -- 当前激活角色
SHOW GRANTS FOR 'zhangsan'@'%' USING 'app_rw';            -- 含角色权限全貌

-- 5. 回收:收回角色=一次性收回一堆权限;删角色不影响已授权用户的当前会话
REVOKE 'app_rw' FROM 'zhangsan'@'%';
DROP ROLE 'app_ro';
```

> 企业价值:新员工入职只需 `GRANT 'app_ro' TO '新用户'`,权限模板化统一管控;离职一键 `REVOKE`。详细机制(角色本质、权限继承)见第 19 课 19.4。


---

# 第4课 SQL 基础语法

## 4.1 CREATE DATABASE(建库)

- `CREATE DATABASE` 与 `CREATE SCHEMA` 语义相同。
- 库已存在且没写 `IF NOT EXISTS` 时建库报错:`ERROR 1007: Can't create database 'test3'; database exists`。
- `create_specification`(属性:CHARACTER SET 默认字符集、COLLATE 排序规则)存储在 **db.opt** 文件。
- 建库后数据目录会创建同名文件夹存放后续表文件。
- **技巧**:也可以直接 `mkdir` 在数据目录建文件夹并 `chown mysql:mysql` 授权,MySQL 会识别为一个数据库。

```sql
CREATE DATABASE IF NOT EXISTS test3 DEFAULT CHARACTER SET utf8mb4;
USE test3;   -- 切换数据库
```

## 4.2 CREATE TABLE(建表)

### 基本语法
```sql
CREATE TABLE [IF NOT EXISTS] tbl_name (字段定义...);
-- 指定数据库建表
CREATE TABLE test3.students2(sid INT, sname VARCHAR(10));
```

### 关键子句

| 子句 | 说明 |
|---|---|
| TEMPORARY | 创建**临时表**:仅本连接可见,连接断开自动 drop。其他连接查询报 `ERROR 1146 Table doesn't exist` |
| LIKE | `CREATE TABLE students_copy LIKE students;` 按原表定义复制**空表**(字段+索引都相同,无数据) |
| AS SELECT | `CREATE TABLE t2 AS SELECT * FROM t1;` 建表同时插入查询结果,**索引/主外键不同步** |
| IGNORE / REPLACE | 插入数据违反唯一约束时:IGNORE 不插入、REPLACE 替换已有,默认都报错 |

### 字段约束

| 约束 | 说明 |
|---|---|
| NOT NULL / NULL | 默认 NULL 允许为空;NOT NULL 必须有值或默认值,否则报 `ERROR 1364 Field doesn't have a default value` |
| DEFAULT | 默认值:`gender INT DEFAULT 0` |
| AUTO_INCREMENT | 自增:整数/浮点 value+1(从当前表最大值的下一位开始,默认从 1);**一个表只能一个自增字段,且必须有 key 属性、不能有 default**;插入负值会被当成很大的正数 |
| PRIMARY KEY | 主键:必须唯一、非空,一个表只能一个,可含一个或多个字段 |
| UNIQUE | 唯一属性,允许多个 NULL |
| FOREIGN KEY | 外键字段 |
| CONSTRAINT | 为约束命名:`CONSTRAINT for_1 FOREIGN KEY (gender) REFERENCES gender(gender_id)` |
| COLUMN_FORMAT / STORAGE | 仅 NDB 引擎有用 |

> 注意:自增字段若未定义为主键会报错 `ERROR 1075: there can be only one auto column and it must be defined as a key`。

### 建表练习(学生选课数据库)
```sql
CREATE DATABASE course;
-- Students: sid 自增主键, sname 64位, gender 12位, dept_id 外键到 dept.id
-- Dept: id 自增主键, dept_name 64位
-- Course: id 自增主键, course_name 64位, teacher_id 外键到 teacher.id
-- Teacher: id 自增主键, name 64位, dept_id 外键到 dept.id
-- Students 和 Teacher 的 dept_id 为非空
```

## 4.3 INSERT(插入)

### 三种写法
```sql
INSERT INTO students VALUES(1,'aaa');                              -- 按字段顺序
INSERT INTO students SET sid=2, sname='bbb';                       -- 指定字段赋值
INSERT INTO students SELECT * FROM students_bak;                   -- 查询结果插入
-- 多行
INSERT INTO tbl_name (a,b,c) VALUES(1,2,3),(4,5,6),(7,8,9);
```

### 细节要点
- values 中可用表达式:`INSERT INTO tbl (col1,col2) VALUES(15,col1*2);`(但不能引用后面列:`VALUES(col2*2,15)` 错误)。
- 未指定的列插入默认值(或 NULL)。
- 返回信息:`Records: n Duplicates: n Warnings: n` —— Records 是操作行数,Duplicates 是违反唯一性的重复行数,Warnings 是警告数。
- `LOW_PRIORITY` / `HIGH_PRIORITY`:仅 MyISAM、MEMORY、MERGE 引擎生效。
- `IGNORE`:违反主键/唯一约束时**不报错只警告,违反行丢弃,整个语句不回退**;类型转换有问题也仅警告。

### INSERT IGNORE 示例
```sql
INSERT INTO students VALUES(1,'bbb',0);   -- ERROR 1062 Duplicate entry
INSERT IGNORE INTO students VALUES(1,'bbb',0);  -- Query OK, 1 warning
```

### INSERT ... ON DUPLICATE KEY UPDATE
- 违反主键/唯一约束时,转为 UPDATE 修改已存在行:
```sql
INSERT INTO table (a,b,c) VALUES (1,2,3)
ON DUPLICATE KEY UPDATE c=c+1;
-- 等同于
UPDATE table SET c=c+1 WHERE a=1;
```
- 后面可跟多个修改,逗号隔开。

### INSERT ... DELAYED(了解)

- 5.6.6 之前:目标表被其他连接使用时就等待;5.7 起关键词不再支持,执行只产生警告,后续版本去掉。

### INSERT ... SELECT 注意
- 目标表和 select 的表相同时,MySQL 会先把 select 结果存临时表再插入。

## 4.4 UPDATE(修改)

### 单表更新
```sql
UPDATE students SET sname='abcd', gender='1' WHERE sid=1;
UPDATE students SET sname='abc' LIMIT 2;        -- 只改最先找到的两行
UPDATE t SET id = id + 1 ORDER BY id DESC;      -- order by 避免唯一键冲突
```
- 无 WHERE 则修改所有行;ORDER BY 决定修改顺序;LIMIT 限制行数。
- **坑**:`UPDATE t SET id = id + 1;` 若 id 有唯一约束会报 ERROR 1062;加 `ORDER BY id DESC` 从大到小改就正常。
- `UPDATE ignore ...` 违反唯一约束不报错(数据不改动)。
- 同一语句内字段赋值按从左到右:`UPDATE t1 SET col1 = col1+1, col2 = col1;` 中 col2 等于 col1 的新值。

### 多表更新
```sql
UPDATE students, students2
SET students.sname=students2.sname
WHERE students.sid=students2.sid;
-- 多表更新不允许用 order by 和 limit
UPDATE items, month SET items.price=month.price WHERE items.id=month.id;
```

## 4.5 DELETE(删除)

### 单表删除
```sql
DELETE FROM students;                    -- 删所有行
DELETE FROM students WHERE sid=1;
DELETE FROM students ORDER BY sid;       -- 按顺序删
DELETE FROM students LIMIT 1;            -- 只删最先找到的一行
-- 经典用法:删除最老的一条
DELETE FROM somelog WHERE user='jcole' ORDER BY timestamp_column LIMIT 1;
```
- 无 WHERE 删所有行;ORDER BY 决定删除顺序;LIMIT 限制行数。

### 多表删除
```sql
DELETE t1, t2 FROM t1 INNER JOIN t2 INNER JOIN t3
WHERE t1.id=t2.id AND t2.id=t3.id;
DELETE FROM t1, t2 USING t1 INNER JOIN t2 INNER JOIN t3
WHERE t1.id=t2.id AND t2.id=t3.id;
```
- 多表删除中**别名只能在 table_references(USING 前的 FROM 区)使用**,DELETE 后的列表不能带别名:
  - `DELETE a1, a2 FROM t1 AS a1 INNER JOIN t2 AS a2` ✅
  - `DELETE t1 AS a1, t2 AS a2 FROM t1 INNER JOIN t2` ❌
- 被删除的表不能出现在子查询中。
- `QUICK`(MyISAM 不合并索引叶节点,加快删除)、`LOW_PRIORITY`(仅 MyISAM/MEMORY/MERGE)、`IGNORE`。

## 4.6 SELECT(查询)

### 基本用法
```sql
SELECT * FROM students;                                     -- 所有数据
SELECT sid,sname FROM students WHERE sid=1;                 -- 条件
SELECT * FROM students ORDER BY sid;                        -- 排序
SELECT sex,count(*) FROM students GROUP BY sex HAVING count(*)>=2;  -- 分组
SELECT * FROM students a INNER JOIN students2 b ON a.sid=b.sid;     -- 连接
SELECT sid AS a, sname AS b FROM students;                  -- 别名写法1
SELECT sid a, sname b FROM students;                        -- 别名写法2
```

### 关键点
- **WHERE 中不能使用 select 中定义的别名**(执行顺序 WHERE 在 SELECT 之前):`SELECT sid a FROM students WHERE a>1` 报 `ERROR 1054 Unknown column 'a'`。
- 多表同名字段必须用 `表名.字段` 或别名指定,否则报 `ERROR 1052 Column is ambiguous`。
- 跨库查询:`SELECT * FROM test2.students;` 或 `test2.students` 连表。
- ORDER BY / GROUP BY 可用列名、别名或序号:`ORDER BY 2, 3`。
- GROUP BY 常配聚合函数:MAX/MIN/AVG/COUNT/SUM。
- HAVING 跟在 GROUP BY 后过滤分组结果。
- LIMIT:`LIMIT 5` = 前 5 行(offset 0);`LIMIT 5,10` = 第 6~15 行(offset=5, count=10)。
- `DISTINCT` 去重 / `ALL`(默认,不去重);`COUNT(*)` vs `COUNT(ALL sid)` vs `COUNT(DISTINCT sid)`。
- `STRAIGHT_JOIN`:强制优化器按 FROM 子句表顺序执行连接。
- `SQL_CALC_FOUND_ROWS`:查询同时计算结果行数,再用 `SELECT FOUND_ROWS()` 获取(配合分页)。
- `MAX_STATEMENT_TIME=N`:语句执行超时(毫秒)。
- `FOR UPDATE`:查询行加**写锁**直到事务提交;`LOCK IN SHARE MODE`:查询行加**读锁**。

### SELECT ... INTO
```sql
-- 存变量(必须返回一行,否则报 no data / Result consisted of more than one row)
SELECT id, data INTO @x, @y FROM test.t1 LIMIT 1;
-- 存文件(文件在服务器本地,不能已存在)
SELECT sid,sname,sex INTO OUTFILE '/tmp/students.txt'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM students;
-- DUMPFILE:以一行格式写入文件,且只能写一行
SELECT * INTO DUMPFILE '/tmp/students4.txt' FROM students LIMIT 1;
```
- OUTFILE 报 `ERROR 1290 secure-file-priv` → 在配置中加 `secure_file_priv=/tmp/` 重启。

### 表连接
- `JOIN` / `INNER JOIN` / `CROSS JOIN` 三者意思相同。
- FROM 后可跟子查询,**子查询必须带别名**:`SELECT * FROM (SELECT 1,2,3) AS t1;`
- 无关联条件的多表 = **笛卡尔积**。
- `LEFT JOIN ... USING (sid)` 简化等值连接;支持多表连续 JOIN。
- `STRAIGHT_JOIN` 保证左表先读。

### UNION 合并
- 将多个 SELECT 结果合并;**第一个 SELECT 的列名作为结果列名**,对应列类型尽量一致。
- 默认去重(等同 UNION DISTINCT);`UNION ALL` 保留重复行。
- 对最终结果排序/limit 时,需把每个 SELECT 用括号括起来,ORDER BY/LIMIT 放最后:
```sql
(SELECT sid,sname FROM students)
UNION
(SELECT sid,sname FROM students2)
ORDER BY sid LIMIT 2;
```

## 4.7 CREATE VIEW(视图)

- 视图是**保存的查询定义**,本身不存储结果。
- `OR REPLACE`:视图已存在时替换。
- 视图定义固定:`SELECT *` 建的视图,后续给表**加字段不会**出现在视图中;**删字段会导致查询视图失败**(ERROR 1356)。
- 可跨库:`CREATE VIEW test.v AS SELECT * FROM test2.t;`;可指定字段名:`CREATE VIEW v_today (today) AS SELECT CURRENT_DATE;`
- 视图内 ORDER BY 允许,但查询视图时自带 ORDER BY 会忽略视图的。
- 当视图每行与表每行**一一对应**时,可对视图执行 INSERT/UPDATE/DELETE。

```sql
CREATE VIEW v_students_male AS SELECT sid,sname FROM students WHERE sex=0;
CREATE OR REPLACE VIEW v_students_male AS SELECT sid,sname,sex FROM students WHERE sex=0;
```

## 4.8 CREATE INDEX(建索引)

```sql
CREATE INDEX idx_st_sname ON students(sname);        -- 普通索引
CREATE INDEX idx_st_union ON students(sname,sex);    -- 复合索引
CREATE UNIQUE INDEX idx_st_sid ON students(sid);     -- 唯一索引(重复插入报 ERROR 1062)
```
- 复合索引可含多个字段(逗号隔开)。
- FULLTEXT 全文索引只能建在 **InnoDB 和 MyISAM** 的 char、varchar、text 字段上。
- 索引可建在含 NULL 值的字段上。
- `KEY_BLOCK_SIZE=value`(MyISAM 指定索引键 block 大小)、`COMMENT 'string'`(最长 1024 字符)。

## 4.9 ALTER(修改库/表/视图)

```sql
-- 修改数据库属性(字符集/排序规则;改了之后库中所有存储过程和函数要重新创建)
ALTER DATABASE db_name CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 修改视图(等同 create or replace view)
ALTER VIEW v_students_male AS SELECT sid,sname FROM students WHERE sex=0;

-- 修改表
ALTER TABLE t ADD COLUMN col_name INT;
ALTER TABLE t ADD CONSTRAINT uq_name UNIQUE INDEX (col_name);
ALTER TABLE t ADD CONSTRAINT fk_name FOREIGN KEY (col) REFERENCES parent(col);
ALTER TABLE t DROP COLUMN col_name;
ALTER TABLE t DROP INDEX index_name;
```

## 4.10 DROP / RENAME / TRUNCATE(删除与重命名)

```sql
-- 删库(连库带所有表;删除库目录下所有文件及 db.opt)
DROP DATABASE [IF EXISTS] db_name;

-- 删索引
DROP INDEX idx_st_sname ON students;

-- 删表(可多个,可删临时表;5.7 中 RESTRICT/CASCADE 无用)
DROP TABLE [IF EXISTS] students2;

-- 删视图
DROP VIEW [IF EXISTS] v_students_male;

-- 重命名表(可交换两个表名,先改名到临时名再换)
RENAME TABLE old_table TO new_table;
RENAME TABLE old_table TO tmp_table, new_table TO old_table, tmp_table TO new_table;
-- 注意:数据/索引/主键定义自动转换;视图和对原表的权限不会自动转换,需手动处理

-- 清空表(截断,类似 drop+create,性能比 delete 快,不可回滚)
TRUNCATE TABLE students_test;
```


---

# 第5课 MySQL 常用函数介绍

## 5.1 操作符优先级

- 所有操作符按优先级从高到低执行,同一行的操作符优先级相同,**相同优先级从左到右执行**。
- 想改变执行顺序用**括号**:
```sql
SELECT 1+2*3;      -- 7(先乘后加)
SELECT (1+2)*3;    -- 9
```

## 5.2 对比操作符(结果为 true/false/null 三种)

| 操作符 | 含义 |
|---|---|
| = | 相等:`'0'=0 → 1`,`'0.0'=0 → 1`,`'0.01'=0 → 0`,`'.01'=0.01 → 1` |
| <> / != | 不等于:`'.01'<>'0.01' → 1`,`.01<>'0.01' → 0`(字符串 vs 数字比较会转换) |
| > / >= / < / <= | 大于 / 大于等于 / 小于 / 小于等于 |
| BETWEEN A AND B | `min <= expr <= max`:`2 BETWEEN 1 AND 3 → 1`,`2 BETWEEN 3 AND 1 → 0` |
| NOT BETWEEN A AND B | `NOT(expr BETWEEN A AND B)` |
| IN() / NOT IN() | 值在/不在列表中:`2 IN (0,3,5,7) → 0`;支持行值 `(3,4) IN ((1,2),(3,4)) → 1` |
| IS / IS NOT | 与布尔值比较:`1 IS TRUE → 1`,`NULL IS UNKNOWN → 1` |
| IS NULL / IS NOT NULL | 是否为空 |
| ISNULL(expr) | 参数是 NULL 返回 1:`ISNULL(1/0) → 1` |
| LIKE / NOT LIKE | 字符匹配(见 5.6 字符串对比) |
| COALESCE(value,...) | 返回第一个非 NULL 的值,全 NULL 则返回 NULL |
| GREATEST(v1,v2,...) | 返回最大值 |
| LEAST(v1,v2,...) | 返回最小值,**有 NULL 则返回 NULL** |
| INTERVAL() | 返回比第一个参数小的参数的位置 |
| STRCMP() | 比较两个字符串 |

## 5.3 逻辑操作符(返回 1 / 0 / NULL)

| 操作符 | 说明 | 例子 |
|---|---|---|
| NOT / ! | 非 | `NOT 10 → 0`,`NOT NULL → NULL`,`!1+1 → 1`(= `(!1)+1`) |
| AND / && | 与 | `1 AND NULL → NULL`,`0 AND NULL → 0` |
| OR / \|\| | 或 | `1 OR NULL → 1`,`0 OR NULL → NULL` |
| XOR | 异或 | `1 XOR 1 → 0`,`1 XOR 1 XOR 1 → 1` |

## 5.4 赋值操作符

- `:=` 赋值:`SELECT @var1 := 1;`(SELECT 语句中只能用 := 赋值)
- `=` 在 **SET 语句** 和 **UPDATE 的 SET 子句** 中视为赋值,其他情况视为比较:
```sql
SET @a=1;
UPDATE t1 SET c1 = 2 WHERE c1 = @var1 := 1;   -- 先赋值 @var1=1 再比较
```

## 5.5 流程控制函数

| 函数 | 说明 | 例子 |
|---|---|---|
| CASE value WHEN cmp THEN result [WHEN ...] [ELSE r] END | value 等于哪个 cmp 返回哪个 result,没有匹配返回 ELSE 或 NULL | `CASE 1 WHEN 1 THEN 'one' WHEN 2 THEN 'two' ELSE 'more' END → 'one'` |
| CASE WHEN condition THEN result ... [ELSE r] END | 第一个满足的条件返回对应 result | `CASE WHEN 1>0 THEN 'true' ELSE 'false' END → 'true'` |
| IF(expr1,expr2,expr3) | expr1 为真返回 expr2,否则 expr3 | `IF(1>2,2,3) → 3` |
| IFNULL(expr1,expr2) | expr1 非 NULL 返回 expr1,否则 expr2 | `IFNULL(1/0,10) → 10` |
| NULLIF(expr1,expr2) | 相等返回 NULL,不相等返回 expr1 | `NULLIF(1,1) → NULL`,`NULLIF(1,2) → 1` |

## 5.6 字符串函数

| 函数 | 说明 | 例子 |
|---|---|---|
| ASCII(str) | 最左字符的 ASCII 码;空串 0;NULL 返回 NULL | `ASCII('dx') → 100` |
| CHAR(N,... [USING charset]) | 数字转成 ASCII 对应字符并连接 | `CHAR(77,121,83,81,'76') → 'MySQL'` |
| CHAR_LENGTH(str) | 字符长度 | - |
| CONCAT(str1,...) | 连接,**有 NULL 返回 NULL** | `CONCAT('My',NULL,'QL') → NULL` |
| CONCAT_WS(sep,str1,...) | 以第一个参数为分隔符连接,**NULL 忽略** | `CONCAT_WS(',','a',NULL,'b') → 'a,b'` |
| INSERT(str,pos,len,newstr) | pos 起 len 个字符替换为 newstr;pos 为负返回原串 | `INSERT('Quadratic',3,4,'What') → 'QuWhattic'` |
| INSTR(str,substr) | substr 首次出现位置,没有返回 0 | `INSTR('foobarbar','bar') → 4` |
| LEFT(str,len) / RIGHT(str,len) | 从左/右取 len 字符 | `LEFT('foobarbar',5) → 'fooba'` |
| LENGTH(str) | **字节**长度 | `LENGTH('text') → 4` |
| LOAD_FILE(file_name) | 读文件返回字符串 | `UPDATE t SET blob_col=LOAD_FILE('/tmp/picture') WHERE id=1;` |
| LOCATE(substr,str[,pos]) | substr 从 pos 起首次出现位置 | `LOCATE('bar','foobarbar',5) → 7` |
| LOWER(str) / UPPER(str) | 转小写/大写,**对二进制串无效**(需 CONVERT) | `LOWER('QUADRATICALLY') → 'quadratically'` |
| LPAD(str,len,padstr) / RPAD | 左/右补 padstr 到 len 长;str 比 len 长则截取左边 len 个 | `LPAD('hi',4,'??') → '??hi'` |
| LTRIM(str) / RTRIM(str) | 去左/右边空格 | `LTRIM(' barbar') → 'barbar'` |
| REPEAT(str,count) | 重复 count 次;count<1 返回空串 | `REPEAT('MySQL',3) → 'MySQLMySQLMySQL'` |
| REPLACE(str,from,to) | 所有 from 替换为 to | `REPLACE('www.mysql.com','w','Ww') → 'WwWwWw.mysql.com'` |
| REVERSE(str) | 倒序 | `REVERSE('abc') → 'cba'` |
| SPACE(N) | 返回 N 个空格 | - |
| SUBSTR/SUBSTRING(str,pos[,len]) | 截取子串;pos 负数从右数 | `SUBSTRING('Quadratically',5,6) → 'ratica'`,`SUBSTRING('Sakila',-3) → 'ila'` |
| SUBSTRING_INDEX(str,delim,count) | 按 delim 第 count 次前/后(负值从右)截取 | `SUBSTRING_INDEX('www.mysql.com','.',2) → 'www.mysql'`,`...-2 → 'mysql.com'` |

## 5.7 字符串对比函数

- `expr LIKE pat [ESCAPE 'char']`:`%` 匹配 0 或多个字符,`_` 匹配 1 个字符;特殊字符用 `\` 或 ESCAPE 转义:
```sql
SELECT 'David!' LIKE 'David_';      -- 1
SELECT 'David_' LIKE 'David\_';     -- 1(转义)
SELECT 'David_' LIKE 'David|_' ESCAPE '|';   -- 1
```
- `NOT LIKE`:反义。
- `STRCMP(expr1,expr2)`:相等 0,expr1<expr2 为 -1,反之为 1;**与排序规则(大小写)有关**:
```sql
SELECT STRCMP('text','text2');   -- -1
SELECT STRCMP(@s1,@s2);          -- ci 排序规则下 'x'='X' → 0
SELECT STRCMP(@s3,@s4);          -- cs 排序规则下 'x'<'X' → 1
```

## 5.8 数字函数

| 函数 | 说明 | 例子 |
|---|---|---|
| / 和 DIV | 除法;DIV 取整数部分 | `3/5 → 0.60`,`5 DIV 2 → 2`;`102/(1-1) → NULL` |
| ABS(X) | 绝对值 | `ABS(-32) → 32` |
| CEILING(X)/CEIL(X) | 返回 >=X 的最小整数 | `CEILING(-1.23) → -1` |
| FLOOR(X) | 返回 <=X 的最大整数 | `FLOOR(-1.23) → -2` |
| MOD(N,M) / N % M / N MOD M | 取余 | `MOD(234,10) → 4`,`MOD(34.5,3) → 1.5` |
| RAND([N]) | 0~1 随机小数;N 为种子(同种子同序列) | `FLOOR(7+(RAND()*5))` 取 7~12 随机整数;`ORDER BY RAND() LIMIT 1` 随机取行 |
| ROUND(X[,D]) | 四舍五入,D 位小数;D 为负往左 | `ROUND(1.298,1) → 1.3`,`ROUND(23.298,-1) → 20` |
| TRUNCATE(X,D) | 只保留 D 位小数,其余**直接舍弃**(非四舍五入) | `TRUNCATE(1.999,1) → 1.9`,`TRUNCATE(122,-2) → 100` |

## 5.9 日期和时间函数

| 函数 | 说明 | 例子 |
|---|---|---|
| ADDDATE(date,INTERVAL expr unit) / ADDDATE(expr,days) | 增加时间;负数=减少 | `ADDDATE('2008-01-02',INTERVAL 31 DAY) → '2008-02-02'` |
| ADDTIME(expr1,expr2) | 时间相加 | `ADDTIME('01:00:00.999999','02:00:00.999998') → '03:00:01.999997'` |
| CONVERT_TZ(dt,from_tz,to_tz) | 时区转换 | `CONVERT_TZ('2004-01-01 12:00:00','+00:00','+10:00') → '...22:00:00'` |
| CURDATE()/CURRENT_DATE() | 当前日期 | `CURDATE()+0 → 20080613` |
| CURTIME()/CURRENT_TIME() | 当前时间 | - |
| NOW()/CURRENT_TIMESTAMP() | 当前日期时间(**语句执行时间**) | - |
| SYSDATE() | 当前日期时间(**函数执行时间**,同一语句多次调用值不同) | `SELECT SYSDATE(),SLEEP(2),SYSDATE();` 两次不同;NOW() 两次相同 |
| DATE(expr) | 取日期部分 | `DATE('2003-12-31 01:02:03') → '2003-12-31'` |
| DATEDIFF(expr1,expr2) | 天数差(忽略时分秒) | `DATEDIFF('2007-12-31 23:59:59','2007-12-30') → 1` |
| DATE_ADD/DATE_SUB(date,INTERVAL expr unit) | 加/减时间;unit 支持 SECOND/DAY/MINUTE_SECOND/DAY_SECOND/DAY_HOUR/SECOND_MICROSECOND/MONTH 等 | `DATE_ADD('2009-01-30',INTERVAL 1 MONTH) → '2009-02-28'`(自动对齐月末) |
| DATE_FORMAT(date,format) | 按格式输出 | `DATE_FORMAT('2007-10-04 22:23:00','%H:%i:%s') → '22:23:00'`,`'%W %M %Y' → 'Sunday October 2009'` |
| DAY()/DAYOFMONTH(date) | 月中第几天 | `DAYOFMONTH('2007-02-03') → 3` |
| DAYNAME(date) | 星期几英文名 | `DAYNAME('2007-02-03') → 'Saturday'` |
| DAYOFWEEK(date) | 星期几(1=周日) | `DAYOFWEEK('2007-02-03') → 7` |
| DAYOFYEAR(date) | 一年中第几天(1~366) | `DAYOFYEAR('2007-02-03') → 34` |
| EXTRACT(unit FROM date) | 取指定部分 | `EXTRACT(YEAR_MONTH FROM '2009-07-02') → 200907` |
| FROM_UNIXTIME(ts[,format]) | 时间戳转日期 | `FROM_UNIXTIME(1447430881) → '2015-11-13 10:08:01'` |
| LAST_DAY(date) | 所在月最后一天 | `LAST_DAY('2004-02-05') → '2004-02-29'`;非法日期 `'2003-03-32' → NULL` |
| TIME(expr) | 取时间部分 | `TIME('2003-12-31 01:02:03') → '01:02:03'` |
| UNIX_TIMESTAMP([date]) | 日期转时间戳(距 1970-01-01 秒数);无参=当前 | `UNIX_TIMESTAMP('2015-11-13 10:20:19') → 1447431619` |

### DATE_FORMAT 常用格式符
`%Y` 四位年、`%y` 两位年、`%m` 月(01-12)、`%d` 日(01-31)、`%H` 24小时(00-23)、`%k` 小时(0-23)、`%i` 分钟、`%s` 秒、`%W` 星期英文、`%a` 星期缩写、`%M` 月英文、`%b` 月缩写、`%j` 年中第几天、`%X %V` 周年/周数。

## 5.10 格式转换函数

- `CAST(expr AS type)` 和 `CONVERT(expr,type)` / `CONVERT(expr USING charset)` 均可转换类型或字符集。
- 允许类型:`BINARY[N]`、`CHAR[N]`、`DATE`、`DATETIME`、`DECIMAL(M[,D])`、`TIME`、`SIGNED [INTEGER]`、`UNSIGNED [INTEGER]`。
```sql
SELECT CONVERT(_latin1'Müller' USING utf8);
SELECT CONVERT('test', CHAR CHARACTER SET utf8);
SELECT CAST('test' AS CHAR CHARACTER SET utf8);
SELECT CAST('2000-01-01' AS DATE);
```

## 5.11 聚合函数(常配 GROUP BY)

| 函数 | 说明 |
|---|---|
| AVG([DISTINCT] expr) | 平均值,可去重 |
| COUNT(expr) | 个数;无匹配返回 0;**注意 NULL 不计入** |
| COUNT(DISTINCT expr,...) | 去重后个数(非 NULL) |
| MAX([DISTINCT] expr) / MIN(...) | 最大 / 最小值 |
| SUM([DISTINCT] expr) | 求和 |

## 5.12 子查询

- 子查询是嵌套在外层语句中的完整 SELECT,通常用 `()` 括起来,可返回单一值、一行、一个表格。
- 可简化复杂 JOIN 和 UNION,提高可读性。
```sql
SELECT (SELECT s1 FROM t2) FROM t1;
SELECT * FROM t1 WHERE column1 = (SELECT MAX(column2) FROM t2);
DELETE FROM t1 WHERE column1 IN (SELECT column1 FROM t2);
SELECT s1 FROM t1 WHERE s1 = ANY (SELECT s1 FROM t2);
SELECT s1 FROM t1 WHERE s1 > ALL (SELECT s1 FROM t2);
SELECT * FROM t1 WHERE (col1,col2) = (SELECT col3,col4 FROM t2 WHERE id=10);
SELECT AVG(sum_column1) FROM (SELECT SUM(column1) AS sum_column1 FROM t1 GROUP BY column1) AS t1;
SELECT * FROM t1 WHERE id NOT IN (SELECT id FROM t2);
SELECT * FROM t1 WHERE NOT EXISTS (SELECT id FROM t2 WHERE t1.id=t2.id);
```

## 5.13 课堂强化练习(选课成绩系统,含参考答案)

练习建表:score(sid, course_id, score),清空原表数据后插入预置 students/dept/course/teacher/score 数据。

**练习题与参考答案:**
```sql
-- 4. 查看所有英语成绩超过数学成绩的学生的学号和姓名
SELECT aa.sid, aa.sname FROM
  (SELECT a1.sid, sname, score FROM students a1 JOIN score b1 ON a1.sid=b1.sid WHERE course_id=2) aa
  JOIN (SELECT a2.sid, sname, score FROM students a2 JOIN score b2 ON a2.sid=b2.sid WHERE course_id=1) bb
  ON aa.sid=bb.sid WHERE aa.score>bb.score;

-- 5. 平均成绩 >=60 的学生姓名和平均成绩
SELECT a.sid, a.sname, AVG(b.score) FROM students a JOIN score b ON a.sid=b.sid
GROUP BY a.sid, a.sname HAVING AVG(b.score)>=60;

-- 6. 所有同学学号、姓名、选课数、总成绩
SELECT a.sid, a.sname, COUNT(*), SUM(score) FROM students a JOIN score b ON a.sid=b.sid GROUP BY a.sid, a.sname;

-- 7. 姓 zhang 的老师个数
SELECT COUNT(*) FROM teacher WHERE name LIKE 'zhang%';

-- 8. 没学过 zhangsan 老师课程的学生学号和姓名
SELECT sid, sname FROM students WHERE sid NOT IN
  (SELECT b.sid FROM course a JOIN score b ON a.id=b.course_id JOIN teacher c ON a.teacher_id=c.id WHERE c.name='Zhang san');

-- 9. 既学过英语也学过语文的学生
SELECT a.sid, sname, COUNT(*) FROM students a JOIN score b ON a.sid=b.sid
JOIN course c ON b.course_id=c.id WHERE c.name IN ('english','chinese')
GROUP BY sid, sname HAVING COUNT(*)>=2;

-- 11. 有学生单科成绩 <60 的姓名和课程名称
SELECT a.sname, c.name FROM students a JOIN score b ON a.sid=b.sid
JOIN course c ON b.course_id=c.id WHERE b.score<60;

-- 13. 按平均成绩降序显示姓名和语文、数学、英语三科成绩
SELECT a.sid, AVG(score) score_avg,
  SUM(CASE WHEN b.name='chinese' THEN a.score ELSE 0 END) a1,
  SUM(CASE WHEN b.name='math' THEN a.score ELSE 0 END) a2,
  SUM(CASE WHEN b.name='English' THEN a.score ELSE 0 END) a3
FROM score a JOIN course b ON a.course_id=b.id GROUP BY a.sid;

-- 14. 各科最高分和最低分
SELECT course_id, MIN(score), MAX(score) FROM score GROUP BY course_id;

-- 15. 各科平均成绩和及格率百分比
SELECT course_id, AVG(score), SUM(CASE WHEN score>=60 THEN 1 ELSE 0 END)/COUNT(*)*100 FROM score GROUP BY course_id;

-- 16. 不同老师所教不同课程平均分从高到低
SELECT c.name, b.name, AVG(score) FROM score a JOIN course b ON a.course_id=b.id
JOIN teacher c ON b.teacher_id=c.id GROUP BY c.name, b.name ORDER BY AVG(score) DESC;

-- 17. 英语和数学课程成绩排名第 5 到第 10 位的学生
SELECT c.sname, a.score FROM score a JOIN course b ON a.course_id=b.id
JOIN students c ON a.sid=c.sid WHERE b.name='English' ORDER BY a.score LIMIT 4,6;

-- 18. 各科按分数段统计人数(>=90 / 80~90 / 60~80 / <60)
SELECT b.name,
  SUM(CASE WHEN score>=90 THEN 1 ELSE 0 END),
  SUM(CASE WHEN score<90 AND score>=80 THEN 1 ELSE 0 END),
  SUM(CASE WHEN score<80 AND score>=60 THEN 1 ELSE 0 END),
  SUM(CASE WHEN score<60 THEN 1 ELSE 0 END)
FROM score a JOIN course b ON a.course_id=b.id GROUP BY b.name;

-- 19. 每门课程被选修的学生数
SELECT course_id, COUNT(*) FROM score GROUP BY course_id;

-- 20. 只学了一门课的学生
SELECT a.sid, b.sname FROM (SELECT sid, COUNT(*) count1 FROM score GROUP BY sid HAVING COUNT(*)=1) a
JOIN students b ON a.sid=b.sid;

-- 21. 名字相同的学生名单和个数
SELECT sname, COUNT(*) FROM students GROUP BY sname HAVING COUNT(*)>=2;

-- 22. 85 年之后出生的学生人数
SELECT * FROM students WHERE birthday>='1985-01-01';

-- 23. 每门课平均成绩升序,相同则按课程 ID 降序
SELECT course_id, AVG(score) FROM score GROUP BY course_id ORDER BY AVG(score), course_id DESC;

-- 24. 有不及格学生的课程和不及格人数
SELECT course_id, COUNT(*) FROM score WHERE score<60 GROUP BY course_id;

-- 25. 去掉学生姓名前后空格
UPDATE students SET sname=LTRIM(RTRIM(sname));

-- 26. 成绩展示为"课程名:成绩"
SELECT a.sid, CONCAT(b.name,':',a.score) FROM score a JOIN course b ON a.course_id=b.id;

-- 27. 老师姓名拆成姓和名两个字段
SELECT name, SUBSTRING(name,1,LOCATE(' ',name)-1), SUBSTRING(name,LOCATE(' ',name)+1,50) FROM teacher;

-- 28. 生日转年月日格式,并计算每个学生年龄
SELECT name, birthday, DATE_FORMAT(birthday,'%Y%m%d'), YEAR(NOW())-YEAR(birthday), FLOOR(DATEDIFF(NOW(),birthday)/365) FROM students;
```


---

# 第6课 SQL 高级应用(存储过程 / 函数 / 游标 / 触发器)

## 6.1 CREATE PROCEDURE / FUNCTION(创建存储过程与函数)

### 核心区别

- **函数有返回值**,调用时直接引用函数名+参数;存储过程用 `CALL` 语句调用。
- 参数关键词 `IN / OUT / INOUT` **只适用于存储过程**;函数的参数**默认都是输入参数**。
  - IN:输入参数,把值传入存储过程
  - OUT:输出参数,把值传给调用者,**初始值为 NULL**
  - INOUT:输入输出参数,传入-修改-传回
- **DEFINER 与 SQL SECURITY**(安全环境):
  - `DEFINER`(默认):执行前验证 definer 指定的用户是否存在且有执行权限,否则报错
  - `INVOKER`:执行时验证**调用者**是否有相应权限
  - 案例:cdq 建的过程,root 调用;`drop user cdq@localhost` 后再 `call` 报 `ERROR 1449: The user specified as a definer ('cdq'@'localhost') does not exist`;`ALTER PROCEDURE simpleproc SQL SECURITY INVOKER;` 后 root 又能调用。

### 使用 DELIMITER
- MySQL 默认语句结束符是 `;`。存储过程/函数内部有 `;`,必须用 `DELIMITER` 临时改结束符,否则创建语句会提前结束。

### 属性短语(只有咨询含义,不强制)
| 属性 | 含义 |
|---|---|
| CONTAINS SQL(默认) | 不包含读写数据的语句 |
| NO SQL | 不包含 SQL 语句 |
| READS SQL DATA | 包含 select 查询,不包含 insert/delete |
| MODIFIES SQL DATA | 包含插入或删除数据的语句 |
| DETERMINISTIC / NOT DETERMINISTIC | 相同参数是否返回相同结果;默认 NOT DETERMINISTIC |
| COMMENT 'string' | 注释;LANGUAGE | 创建语言 |

### 完整示例
```sql
-- 存储过程:IN + OUT
DELIMITER //
CREATE PROCEDURE simpleproc (IN param1 INT, OUT param2 INT)
BEGIN
  SELECT COUNT(*) INTO param2 FROM students WHERE sid>param1;
END//
DELIMITER ;
CALL simpleproc(1, @a);
SELECT @a;   -- 2

-- 函数(带 RETURNS)
CREATE FUNCTION hello (s CHAR(20)) RETURNS CHAR(50)
RETURN CONCAT('Hello, ',s,'!');
SELECT hello('world');

-- 函数体内多条语句 + return
DELIMITER //
CREATE FUNCTION simplefunc(param1 INT) RETURNS INT
BEGIN
  UPDATE students SET sex=1 WHERE sid=param1;
  SELECT COUNT(*) INTO @a FROM students WHERE sid>param1;
  RETURN @a;
END//
DELIMITER ;
SELECT simplefunc(1);
```

### 存储过程/函数内可用 DDL
- routine_body 可包含单个/多个 SQL 语句(begin...end 包裹),**也可以包含 create / drop 等 DDL 语句**。

### DROP PROCEDURE / FUNCTION
```sql
DROP PROCEDURE simpleproc;
DROP FUNCTION IF EXISTS simplefunc;   -- IF EXISTS 避免删不存在的报错
```

## 6.2 复合语句 BEGIN...END 与标签

- BEGIN...END 出现在存储过程/函数/触发器中,可包含多个语句(用 `;` 分隔)。
- 标签(label)可加在 begin...end、loop、repeat、while 上;`ITERATE` 返回标签处继续循环,`LEAVE` 跳出标签。

```sql
DELIMITER //
CREATE PROCEDURE doiterate(IN p1 INT, OUT p2 INT)
BEGIN
  label1: LOOP
    SET p1 = p1 + 1;
    IF p1 < 10 THEN ITERATE label1; END IF;
    LEAVE label1;
  END LOOP label1;
  SET p2=p1;
END//
DELIMITER ;
CALL doiterate(1,@a);  SELECT @a;   -- 10
```

## 6.3 DECLARE 与存储过程变量

- DECLARE 用来声明**本地变量、游标、条件、handler**;只允许出现在 begin...end 中且**必须在第一行**。
- 声明顺序:**先本地变量 → 再游标 → 然后条件和 handler**。
- 本地变量:可 `DEFAULT` 指定默认值(不指定初始为 NULL);作用范围是声明的 begin...end 块;**变量名要和表字段名区分开**。
- 赋值:`SELECT ... INTO var_list`、`SET`、`FETCH ... INTO`。

```sql
DELIMITER //
CREATE PROCEDURE sp1 (v_sid INT)
BEGIN
  DECLARE xname VARCHAR(5) DEFAULT 'bob';
  DECLARE xsex INT;
  SELECT sname, sex INTO xname, xsex FROM students WHERE sid=v_sid;
  SELECT xname, xsex;
END//
DELIMITER ;
CALL sp1(1);
```

## 6.4 流程控制语句

### CASE(两种写法)
```sql
-- 写法1:case_value 与 when_value 相等匹配
CASE v WHEN 0 THEN update ... WHEN 1 THEN update ... ELSE update ... END CASE;
-- 写法2:条件判断
CASE WHEN v=0 THEN ... WHEN v=1 THEN ... ELSE ... END CASE;
```

### IF ... ELSEIF ... ELSE
```sql
DELIMITER //
CREATE FUNCTION SimpleCompare(n INT, m INT) RETURNS VARCHAR(20)
BEGIN
  DECLARE s VARCHAR(20);
  IF n > m THEN SET s = '>';
  ELSEIF n = m THEN SET s = '=';
  ELSE SET s = '<';
  END IF;
  SET s = CONCAT(n, ' ', s, ' ', m);
  RETURN s;
END//
DELIMITER ;
```
- IF 可嵌套。

### LOOP / REPEAT / WHILE / ITERATE / LEAVE / RETURN
| 语句 | 说明 |
|---|---|
| LOOP | 无限循环,需 ITERATE/LEAVE 配合退出 |
| REPEAT ... UNTIL cond END REPEAT | 先执行后判断,满足条件退出 |
| WHILE cond DO ... END WHILE | 先判断后执行,条件为 true 循环 |
| ITERATE label | 重新开始循环 |
| LEAVE label | 退出标签块 |
| RETURN | **仅函数使用**,结束函数并返回指定值;**函数中必须有至少一个 RETURN** |

```sql
-- REPEAT
DELIMITER //
CREATE PROCEDURE dorepeat(p1 INT)
BEGIN
  SET @x = 0;
  REPEAT SET @x = @x + 1; UNTIL @x > p1 END REPEAT;
END//
DELIMITER ;
CALL dorepeat(1000); SELECT @x;   -- 1001

-- WHILE
DELIMITER //
CREATE PROCEDURE dowhile()
BEGIN
  DECLARE v1 INT DEFAULT 5;
  WHILE v1 > 0 DO
    UPDATE students SET sex=-1 WHERE sid=v1;
    SET v1 = v1 - 1;
  END WHILE;
END//
DELIMITER ;

-- RETURN(多分支退出)
DELIMITER //
CREATE FUNCTION doreturn() RETURNS INT
BEGIN
  SELECT sex INTO @a FROM students WHERE sid=1;
  IF @a=1 THEN RETURN 1;
  ELSEIF @a=0 THEN RETURN 0;
  ELSE RETURN 999;
  END IF;
END//
DELIMITER ;
```

## 6.5 游标 CURSOR

- 游标用来声明一个数据集;声明顺序:**变量和条件之后,handler 之前**。
- 四类语句:
  | 语句 | 说明 |
  |---|---|
  | DECLARE ... CURSOR FOR select_statement | 声明游标(绑定 select 数据集) |
  | OPEN cur | 打开已声明的游标 |
  | FETCH cur INTO var_list | 取下一行数据,**字段与变量一一对应**;取完返回 NOT FOUND |
  | CLOSE cur | 关闭游标;关未打开的报错;不关则在 begin...end 执行完后自动关闭 |

```sql
CREATE PROCEDURE curdemo()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE a CHAR(16);
  DECLARE b, c INT;
  DECLARE cur1 CURSOR FOR SELECT id,data FROM test.t1;
  DECLARE cur2 CURSOR FOR SELECT i FROM test.t2;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1; OPEN cur2;
  read_loop: LOOP
    FETCH cur1 INTO a, b;
    FETCH cur2 INTO c;
    IF done THEN LEAVE read_loop; END IF;
    IF b < c THEN INSERT INTO test.t3 VALUES (a,b);
    ELSE INSERT INTO test.t3 VALUES (a,c); END IF;
  END LOOP;
  CLOSE cur1; CLOSE cur2;
END;
```

## 6.6 DECLARE CONDITION / HANDLER(错误处理)

### DECLARE CONDITION

- 给特定错误条件命名,供 handler 使用。条件值两种形式:
  - `Mysql_err_code`:MySQL 错误码整数(如 1051 = unknown table)
  - `SQLSTATE 'value'`:5 位字符串语句状态(如 '42S02' 对应 1051)
```sql
DECLARE no_such_table CONDITION FOR 1051;
DECLARE no_such_table CONDITION FOR SQLSTATE '42S02';
```

### DECLARE HANDLER
- 声明一个 handler 处理一个或多个特殊条件,条件满足时触发其中的语句执行。
- `handler_action`:CONTINUE(继续执行)/ EXIT(退出 begin...end)/ UNDO(已不支持)。
- `condition_value` 可选值:
  | 值 | 含义 |
  |---|---|
  | mysql_err_code | 整数错误码(如 1051) |
  | SQLSTATE 'xx' | 5 位状态(如 SQLSTATE '23000' = 主键冲突) |
  | condition_name | 之前 declare condition 声明的名字 |
  | SQLWARNING | 所有警告(01 打头) |
  | NOT FOUND | 查完/查不到数据(02 打头) |
  | SQLEXCEPTION | 所有错误 |
- **无 handler 时的默认处理**:SQLEXCEPTION → exit;SQLWARNING → continue;NOT FOUND → continue。

```sql
-- 主键冲突 '23000' 时跳过,继续执行
DELIMITER //
CREATE PROCEDURE handlerdemo()
BEGIN
  DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET @x2 = 1;
  SET @x = 1;
  INSERT INTO test.t VALUES (1);
  SET @x = 2;
  INSERT INTO test.t VALUES (1);   -- 触发 handler,不报错
  SET @x = 3;
END//
DELIMITER ;
CALL handlerdemo(); SELECT @x;   -- 3
```

## 6.7 触发器 TRIGGER

- 触发器:当表上有对应 SQL 语句发生时自动执行;创建时指定表名;不能建在临时表上。
- `trigger_time`:BEFORE / AFTER(每行数据修改前/后执行)。
- `trigger_event`:
  - INSERT:insert、load data、replace 插入新行时触发
  - UPDATE:update 时触发
  - DELETE:delete、replace 时触发
  - `INSERT ... ON DUPLICATE KEY UPDATE` 碰到重复行执行 update 时,触发 UPDATE 下的触发器
- 5.7.2 起同一表可建**多个相同 trigger_time+event** 的触发器,默认按创建顺序执行;用 `FOLLOWS`(后执行)/ `PRECEDES`(先执行)指定顺序。
- trigger_body 内可用 `OLD.col_name`(修改/删除前)和 `NEW.col_name`(插入/修改后)。

```sql
-- 记录 students 的每次修改到备份表
DELIMITER //
CREATE TRIGGER simple_trigger AFTER UPDATE ON students FOR EACH ROW
BEGIN
  INSERT INTO students_bak VALUES(old.sid, old.sname, new.sname, old.sex, new.sex, NOW());
END//
DELIMITER ;
UPDATE students SET sname='abc', sex=1;

-- DROP TRIGGER
DROP TRIGGER IF EXISTS simple_trigger;
-- 注意:drop table 时表上的触发器也被删掉
```

### 触发器课堂练习
```sql
-- 1. score 表插入时记录到 score_bak(带时间戳)
DELIMITER //
CREATE TRIGGER trig1 AFTER INSERT ON score FOR EACH ROW
BEGIN
  INSERT INTO score_bak(sid, course_id, score, tstamp) VALUES(new.sid, new.course_id, new.score, NOW());
END//
DELIMITER ;

-- 2. score 插入时更新/新增 score_avg 中该学生平均成绩
DELIMITER //
CREATE TRIGGER trig2 AFTER INSERT ON score FOR EACH ROW
BEGIN
  DECLARE n INT;
  SELECT COUNT(*) INTO n FROM score_avg WHERE sid=new.sid;
  IF n=1 THEN
    UPDATE score_avg SET avg_score=(SELECT AVG(score) FROM score WHERE sid=new.sid) WHERE sid=new.sid;
  ELSE
    INSERT INTO score_avg SELECT sid, AVG(score) FROM score WHERE sid=new.sid GROUP BY sid;
  END IF;
END//
DELIMITER ;
```

## 6.8 课堂强化练习(含参考答案)

### 练习1:存储过程批量造数
```sql
-- proc1:插入 10 万行固定数据(sid 递增,其余固定)
DELIMITER //
CREATE PROCEDURE proc1()
BEGIN
  DECLARE n INT DEFAULT 1;
  WHILE n<=100000 DO
    INSERT INTO students VALUES(n, 'mike', 1, 1);
    SET n=n+1;
  END WHILE;
END//
DELIMITER ;

-- proc1 的 loop 版本
DELIMITER //
CREATE PROCEDURE proc1_3()
BEGIN
  DECLARE n INT DEFAULT 1;
  start_label: LOOP
    IF n>100000 THEN LEAVE start_label; END IF;
    INSERT INTO students VALUES(n, 'mike', 1, 1);
    SET n=n+1;
  END LOOP;
END//
DELIMITER ;

-- proc2:10 万行,gender 随机 0/1,dept_id 随机 1~3
DELIMITER //
CREATE PROCEDURE proc2()
BEGIN
  DECLARE n INT DEFAULT 1;
  DECLARE v_gender_id INT;
  DECLARE v_dept_id INT;
  WHILE n<=100000 DO
    SET v_gender_id=ROUND(RAND());
    SET v_dept_id=FLOOR(RAND()*3+1);
    INSERT INTO students VALUES(n, 'mike', v_gender_id, v_dept_id);
    SET n=n+1;
  END WHILE;
END//
DELIMITER ;
```

### 练习2:函数
```sql
-- 输入 sid,返回该学生平均成绩
DELIMITER //
CREATE FUNCTION func1(v_sid INT) RETURNS INT
BEGIN
  SELECT AVG(score) INTO @x FROM score WHERE sid=v_sid;
  RETURN @x;
END//
DELIMITER ;

-- 输入老师 id,返回所教课程数;不及格学生入表A,及格入表B
DELIMITER //
CREATE FUNCTION func2(v_teacher_id INT) RETURNS INT
BEGIN
  DECLARE n_course INT;
  SELECT COUNT(*) INTO n_course FROM course WHERE teacher_id=v_teacher_id;
  INSERT INTO A SELECT a.sid, b.course_name, a.score FROM score a
    JOIN course b ON a.course_id=b.id
    WHERE b.teacher_id=v_teacher_id AND a.score<60;
  INSERT INTO B SELECT a.sid, b.course_name, a.score FROM score a
    JOIN course b ON a.course_id=b.id
    WHERE b.teacher_id=v_teacher_id AND a.score>=60;
  RETURN n_course;
END//
DELIMITER ;
```

### 练习3:课堂综合练习
1. 男生/女生数据分别存到男生表、女生表(insert into ... select where gender=0/1)。
2. 每个学生课程数、平均成绩、及格/非及格课程数存到单独表(score group by sid + case when)。
3. 存储过程输入 sid,输出该学生课程数和平均成绩。
4. 函数输入 sid,把课程数和平均成绩存表,返回平均成绩。
5. **游标版**:输入老师 id,返回课程数;遍历该老师所有课程的学生成绩,不及格入表A,及格入表B:
```sql
DELIMITER //
CREATE FUNCTION func3(v_teacher_id INT) RETURNS INT
BEGIN
  DECLARE n_course INT;
  DECLARE v_sid INT DEFAULT NULL;
  DECLARE v_course_name VARCHAR(60);
  DECLARE v_score INT;
  DECLARE cur1 CURSOR FOR
    SELECT a.sid, b.course_name, a.score FROM score a
    JOIN course b ON a.course_id=b.id
    WHERE b.teacher_id=v_teacher_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_sid=NULL;
  SELECT COUNT(*) INTO n_course FROM course WHERE teacher_id=v_teacher_id;
  OPEN cur1;
  FETCH cur1 INTO v_sid, v_course_name, v_score;
  WHILE v_sid IS NOT NULL DO
    IF v_score<60 THEN
      INSERT INTO A SELECT v_sid, v_course_name, v_score;
    ELSE
      INSERT INTO B SELECT v_sid, v_course_name, v_score;
    END IF;
    FETCH cur1 INTO v_sid, v_course_name, v_score;
  END WHILE;
  CLOSE cur1;
  RETURN n_course;
END//
DELIMITER ;
```


---

# 第7课 MySQL 数据库设计

## 7.1 数据类型之整数类型

| 类型 | 字节数 | 最小值 | 最大值 | 无符号(unsigned)范围 |
|---|---|---|---|---|
| TINYINT | 1 | -128 | 127 | 0 ~ 255 |
| SMALLINT | 2 | -32768 | 32767 | 0 ~ 65535 |
| MEDIUMINT | 3 | -8388608 | 8388607 | 0 ~ 16777215 |
| INT / INTEGER | 4 | -2147483648 | 2147483647 | 0 ~ 4294967295 |
| BIGINT | 8 | -9223372036854775808 | 9223372036854775807 | 0 ~ 2^64-1 |

- `unsigned` 不允许负数,正整数的取值范围扩大一倍。
- **整数宽度 `INT(11)` 无意义**:不限制值的合法范围,存储和计算上 `INT(1)` 与 `INT(20)` 相同,只是对交互工具规定了**显示字符个数**。
```sql
CREATE TABLE temp1(id INT(1), id2 INT(20));
INSERT INTO temp1 VALUES(1000000,1000000);   -- 都能存入
ALTER TABLE temp1 MODIFY id INT(1) ZEROFILL; -- 加 zerofill 前导补零
-- 结果:id=10 显示为 "10" 与 "00000000000000000010"(zerofill 按宽度补零)
```

## 7.2 固定浮点类型 DECIMAL / NUMERIC

- 用于**高精度精确计算**(如财务数据);`numeric` 与 `decimal` 含义相同。
- `DECIMAL[(M[,D])]`:M = 精度(总位数),D = 小数位数。`DECIMAL(5,2)` 范围 `-999.99 ~ 999.99`。
- 不指定小数:`DECIMAL(M)` = `DECIMAL(M,0)`;直接用 `DECIMAL` 默认 M=10。
- **M 最大 65,D 最大 30**;D=0 时可存储比 BIGINT 范围更大的整数值。
- 存储方式:每 4 个字节存储 9 个数字。如 `DECIMAL(18,9)` 共 9 字节 = 小数点前 9 位(4字节)+ 小数点后 9 位(4字节)+ 小数点本身(1字节)。

## 7.3 浮点类型 FLOAT / DOUBLE(不精确)

- `FLOAT[(M,D)]`:4 字节,范围约 ±3.402823466E+38;`DOUBLE[(M,D)]`:8 字节,范围约 ±1.7976931348623157E+308。
- **不精确类型**,存储同样范围的值通常比 decimal 用更少空间。
```sql
CREATE TABLE temp2(id FLOAT(10,2), id2 DOUBLE(10,2), id3 DECIMAL(10,2));
INSERT INTO temp2 VALUES(1234567.21, 1234567.21, 1234567.21),(9876543.21,9876543.12,9876543.12);
-- 结果:float 显示 1234567.25(精度丢失!)、9876543.00;double/decimal 正确
```

## 7.4 BIT 类型

- `BIT(M)` 存储 M 个 bit,M 范围 1~64;手工指定用 `b'value'` 格式(`b'111'` = 7,`b'10000000'` = 128)。
- 除非特殊情况,尽量不用。

## 7.5 日期时间类型

| 类型 | 默认格式 | 取值范围 |
|---|---|---|
| DATE | yyyy-mm-dd | 1000-01-01 ~ 9999-12-31 |
| DATETIME | yyyy-mm-dd hh:mi:ss | 1000-01-01 00:00:00 ~ 9999-12-31 23:59:59 |
| TIMESTAMP | yyyy-mm-dd hh:mi:ss | **1970-01-01 00:00:01 ~ 2038-01-19 03:14:07** |
| TIME | HH:MM:SS | **-838:59:59 ~ 838:59:59**(可超 24 小时,表示持续时长) |
| YEAR | YYYY | 1901 ~ 2155(非法转 0000) |

- DATETIME 和 TIMESTAMP 都支持微秒级精度(6 位),如 `DATETIME(6)`。
- 非法 date/datetime/timestamp 值转成 0 值(`0000-00-00` 或 `0000-00-00 00:00:00`);非法 year 转 0000。
- **TIMESTAMP 默认自动更新**(老版本行为):不指定默认值时,插入自动填当前时间;第二列以后 timestamp 默认值为 `0000-00-00 00:00:00`。
- 指定 `DEFAULT CURRENT_TIMESTAMP` = 插入不指定时填当前时间;`ON UPDATE CURRENT_TIMESTAMP` = 该行其他列被更新时自动更新为当前时间。
```sql
CREATE TABLE temp4(
  id INT,
  tstamp DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  tstamp2 DATETIME DEFAULT CURRENT_TIMESTAMP,
  tstamp3 TIMESTAMP,
  tstamp4 TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP);
UPDATE temp4 SET id=2;  -- 只有 tstamp、tstamp4 被更新为当前时间
```
- 毫秒微秒精度用 `type_name(fsp)` 表达,fsp 取 0~6:`TIME(3)`、`DATETIME(6)`(超过精度会**四舍五入**)。

## 7.6 字符类型 CHAR / VARCHAR

- **CHAR(M)**:定长,M 范围 0~255;**存储时右侧填充空格,取回时自动去掉末尾空格**。适合短字符串、长度接近固定、经常变更的数据(定长不易产生碎片,且不需要额外字节记录长度)。
- **VARCHAR(M)**:变长,M 范围 0~65535;仅使用必要空间,是最常见的字符串类型。
  - 额外用 **1 或 2 个字节记录长度**:列最大长度 <=255 字节用 1 字节,否则用 2 字节。如 latin1 下 `varchar(10)` 需要 11 字节,`varchar(1000)` 需要 1002 字节。
  - 行是变长的,update 后行可能变长,若页内无空间,InnoDB 会**把行拆成片段存储**。
- 验证 char 去空格、varchar 不去空格:
```sql
CREATE TABLE vc (v VARCHAR(4), c CHAR(4));
INSERT INTO vc VALUES ('ab ', 'ab ');
SELECT CONCAT('(', v, ')'), CONCAT('(', c, ')') FROM vc;
-- ('ab ')  ('ab')
```

## 7.7 二进制类型 BINARY / VARBINARY

- 与 char/varchar 类似但存二进制字符,不足长度**右侧补 `\0`**(BINARY 是定长)。
```sql
CREATE TABLE t (c BINARY(3));
INSERT INTO t SET c = 'a';
SELECT HEX(c), c = 'a', c = 'a\0\0' from t;
-- 610000   0        1(BINARY(3) 实际存的是 'a\0\0')
```

## 7.8 大数据类型 BLOB / TEXT

- BLOB 存二进制大数据;TEXT 存字符型大数据。各自分 4 种:**TINY**(256B)、普通(65,535B ~64KB)、**MEDIUM**(16,777,215B ~16MB)、**LONG**(4,294,967,295B ~4GB)。
- **BLOB 和 TEXT 列不能有默认值**。

## 7.9 枚举类型 ENUM

- 值从**事先指定的一系列值**中选出;存储时**转成数字**存储(节省空间),对应关系存在 .frm 文件。
- **排序按存储顺序(定义顺序),不按值本身**:想按自定义顺序用 `ORDER BY FIELD(size,'large','medium','small')`。
- 插入数字会被当成枚举值中的**第几个值**(从 1 开始);插入非法字符串报 `ERROR 1265 Data truncated`。
- 最多 **65535 个值**;空串是错误索引值(NULL 是合法值);允许 NULL 时默认值是 NULL。
- 增加取值必须 `ALTER TABLE ... MODIFY`。
```sql
CREATE TABLE shirts(name VARCHAR(40), size ENUM('x-small','small','medium','large','x-large'));
SELECT size+0 FROM shirts;   -- 显示存储的数字
INSERT INTO t (numbers) VALUES(2),('2'),('3');  -- ENUM('0','1','2') 结果 1,2,2(数字2=第2个值)
```

## 7.10 集合类型 SET

- 可含 **0 或多个值**,每个值必须是创建时指定的集合中;最多 255 个值。
- `SET('one','two')` NOT NULL 可含:`''`、`'one'`、`'two'`、`'one,two'`。
- 存储同样转成**数字(二进制位图)**:`SET('a','b','c','d')` 插入数字 9 = 二进制 1001 = `'a','d'`。
- 值顺序无关、重复自动忽略:`'a,d'`、`'d,a'`、`'a,d,a'` 都存成 `a,d`。

## 7.11 数据类型选择原则(性能三原则)

1. **更小的通常更好**:能用最小数据类型就用最小的(tinyint 能存 0~200 就别用 int),占用更小磁盘/内存/CPU 缓存。
2. **简单就好**:整型比较比字符比较代价低(字符集和排序规则复杂)。
3. **尽量避免 NULL**:可 NULL 的列让索引、索引统计、值比较更复杂;被索引的 NULL 列每个索引记录额外占 1 字节。

## 7.12 默认值 / 自增长字段

- DEFAULT 不能指定函数或表达式(唯一例外:`CURRENT_TIMESTAMP` 可作 timestamp 和 **datetime** 列的默认值);BLOB/TEXT 列不能指定默认值;没指定 default 且允许 NULL → 默认 NULL。
- **自增字段规则**:
  - 整型和浮点型可设为自增;插入 NULL 时按**当前表最大值+1** 插入。
  - 用 `LAST_INSERT_ID()` 获取刚插入的自增列值。
  - 一个表只能一个自增字段,且**不能含有默认值**;从 1 开始递增,不能插负值。
  - `ALTER TABLE tbl AUTO_INCREMENT = 100;` 修改起点。
  - **MyISAM 特例**:自增可加到多列键值的第二列,按第一列分组各自计数(如 `PRIMARY KEY(grp,id)`,每个 grp 内 id 从 1 开始)。
```sql
CREATE TABLE animals (id MEDIUMINT NOT NULL AUTO_INCREMENT, name CHAR(30) NOT NULL, PRIMARY KEY (id));
```

## 7.13 存储引擎总览

- `SHOW ENGINES;` 查看支持的引擎(Support: DEFAULT=默认, YES=支持, NO=不支持, DISABLED=可开)。
- 设置引擎三途径:① my.cnf `default-storage-engine` ② 会话级 `SET default_storage_engine=...` ③ 建表 `ENGINE=INNODB`;建表后 `ALTER TABLE t ENGINE=InnoDB`。

### InnoDB(默认,生产首选)
- 事务(ACID)、行级锁、聚簇索引(主键查询省 IO)、外键、**崩溃恢复**(crash recovery:自动识别已提交数据、回退未提交数据)。

### MyISAM(老版本默认)
- **表级锁**限制读写性能;适合只读表或读多写少(如 web 应用、数据仓库表)。
- 每表 3 个文件:`.frm`(结构)+ `.MYD`(数据)+ `.MYI`(索引)。

### Memory(内存表)
- 数据全在内存,MySQL 重启**数据丢失但表结构还在**;写操作表锁,限并发;磁盘仅存 `.frm`。

### CSV
- 表对应文本文件,数据逗号分隔,可用 csv 格式导入导出;3 个文件:`.frm`(结构)+ `.CSV`(数据)+ `.CSM`(元数据:状态、行数)。

### ARCHIVE(归档)
- 存大量**未加索引的历史归档数据**;`.frm` + `.ARZ` 两个文件;支持 insert/replace/select,**不支持 delete/update**;支持行级锁;支持 auto_increment 列(可建索引,其他字段不能建);zlib 压缩。

### BLACKHOLE(黑洞)
- 接收插入但不存储,查询永远空;用于主从复制中主库不想保留数据而**从库通过 binlog 保留数据**;仅 `.frm` 文件。

### MERGE(合并,MyISAM 专用)
- 将一批**字段/索引相同且顺序相同**的 MyISAM 表逻辑合并为一个;`.frm` + `.MRG`(包含成员表列表);建表用 `UNION=(t1,t2)` 指定成员,`INSERT_METHOD=FIRST/LAST/NO` 指定插入到第一/最后/禁止插入。

### FEDERATED(联邦)
- 提供从当前实例**访问其它实例数据**的能力(类似 Oracle dblink);默认 DISABLED,启动加 `--federated` 开启;`CONNECTION='mysql://user@host:port/db/table'` 指定远程表。

### EXAMPLE / NDB
- EXAMPLE:仅存在于源码,只留结构不存数据,面向开发者。
- NDB:专用于 **MySQL Cluster**,官方高可用集群方案。

## 7.14 数据库设计方法之 E-R 模型

- E-R 模型用于概念设计阶段,构成:实体集、属性、联系集。
  - **实体**:矩形框,框内写实体名(相同属性特征的实体集合)。
  - **属性**:椭圆,无向线与实体相连(描述实体的特性)。
  - **联系**:菱形,框内写联系名,无向线连接相关实体,并标注联系类型 `1:1`、`1:n`、`m:n`。
- 例:系/学生/课程 —— 系和学生 `1:n`;学生和课程 `m:n`。
- E-R 模型设计也要遵循三范式。

## 7.15 三大范式(数据库逻辑设计核心)

| 范式 | 要求 | 解决 |
|---|---|---|
| 1NF | **每个属性都不可分**(原子性) | 基本要求;仅满足 1NF 有数据冗余过大、插入/删除/修改异常 |
| 2NF | 1NF 基础上**一个表只表达一个实体** | - |
| 3NF | 2NF 基础上**每列都和主键有直接关系,不存在传递依赖** | 基本解决冗余和三类异常 |

**异常举例(仅 1NF 的表:学生+系+系主任)**:
- 插入异常:新建了系但没学生,无法单独插入系名和系主任数据
- 删除异常:删光某系所有学生记录,系与系主任数据也消失
- 修改异常:学生转系,需改多条记录的系与系主任数据

**范式化优点**:重复数据少、更新快;表更小更易进内存、操作快;少用 distinct/group by。
**范式化缺点**:通常需要表关联,代价昂贵。
**实际应用**:为性能常做到 2NF/1NF,混合使用;常见反范式手段:
- 将经常一起查询的字段(如老师姓名)冗余到子表(course),避免关联
- 子表依赖父表信息排序时,冗余排序字段到子表并建索引
- 频繁统计的计数(如课程数)冗余到父表,更新时同步

## 7.16 数据库设计工具

- **PowerDesigner**(Sybase CASE 工具):制作数据流程图、**概念数据模型(CDM)**(独立于 DBMS 的实体/关系)和**物理数据模型(PDM)**(针对具体 DBMS 落地)。
- **MySQL Workbench**:MySQL 官方可视化 ER/数据库建模、管理、迁移工具(开源+商业版,支持 Windows/Linux):https://dev.mysql.com/downloads/workbench/

## 7.17 字段属性设计要点

- **NOT NULL**:默认 NULL 容许为空。
- **主键**:表内唯一区分每行的字段;创建后**自动建唯一性索引**;每个主键字段必须 NOT NULL;一个表只能一个主键。
- **外键**:父子表建立映射关系,子表数据映射父表对应列;默认在子表创建**外键索引**;推荐父表子表相关字段都建索引避免全表扫描。
  - 子表 insert/update 时,父表无对应值 → MySQL 拒绝
  - 父表 update/delete 时对子表数据的处理依赖约束设置:
    | 约束 | 行为 |
    |---|---|
    | CASCADE | 子表对应数据自动 update/delete |
    | SET NULL | 子表对应数据自动置 NULL |
    | RESTRICT(默认) | 子表有对应数据则拒绝父表 update/delete |
    | NO ACTION | 同 RESTRICT |
    | SET DEFAULT | 子表对应数据自动置默认值 |
- **COMMENT 备注**:表或字段上写说明,最长 1024 字符。
- 完整外键建表示例:
```sql
CREATE TABLE product (category INT NOT NULL, id INT NOT NULL, price DECIMAL, PRIMARY KEY(category, id)) ENGINE=INNODB;
CREATE TABLE customer (id INT NOT NULL, PRIMARY KEY (id)) ENGINE=INNODB;
CREATE TABLE product_order (
  no INT NOT NULL AUTO_INCREMENT,
  product_category INT NOT NULL,
  product_id INT NOT NULL,
  customer_id INT NOT NULL,
  PRIMARY KEY(no),
  INDEX (product_category, product_id),
  INDEX (customer_id),
  FOREIGN KEY (product_category, product_id) REFERENCES product(category, id) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (customer_id) REFERENCES customer(id)
) ENGINE=INNODB;
```

## 7.18 JSON 与空间数据类型(8.0 必会)

### JSON 类型(8.0 原生)
- 8.0 起原生支持 `JSON` 类型:存储时自动校验 JSON 合法性、内部优化存储(不重复存键名)、**无法直接建普通索引**。
- 提取字段用 `->` / `->>`:`doc->>'$.name'` 返回纯字符串,`doc->'$.name'` 带引号。
- **给 JSON 字段建索引的方法:先建生成列(generated column),再在生成列上建索引**(生成列见下方)。
- 常用函数:`JSON_EXTRACT()`(同 `->`)、`JSON_CONTAINS()`、`JSON_SET()`、`JSON_TABLE()`(把 JSON 展开成表,8.0 新特性)。
- 适用场景:配置信息、日志/埋点、字段经常变化的"柔性"需求;**高频等值/范围查询的字段不建议塞 JSON**。
- 详细用法见第 19 课 19.9(JSON 全面增强)。

```sql
CREATE TABLE t (
  id INT PRIMARY KEY,
  info JSON,
  -- 生成列 + 索引:让 JSON 里的字段可以被索引
  age INT GENERATED ALWAYS AS (info->>'$.age') STORED,
  INDEX idx_age (age)
);
INSERT INTO t VALUES (1, '{"name":"张三","age":30}');
SELECT info->>'$.name' FROM t;      -- 张三
```

### 空间数据类型(Spatial Data)
- 8.0 提供 `GEOMETRY / POINT / LINESTRING / POLYGON` 等空间类型,用于地图、地理坐标存储。
- 空间索引:`SPATIAL INDEX`(仅 InnoDB/MyISAM 的几何类型列可建)。
- 常用函数:`ST_Distance_Sphere()` 计算球面距离(如两坐标点距离)、`ST_Contains()` 判断包含关系。
- 生产用得少,面试偶尔问"地图坐标怎么存":了解即可。


---

# 第8课 InnoDB 内核

## 8.1 InnoDB 存储引擎介绍

- MySQL 从 **5.5** 开始将 InnoDB 作为默认存储引擎;第一个完整支持 **ACID 事务**的引擎,支持行锁、MVCC、外键、一致性非锁定读。
- 关键属性:
  1. ACID 事务(commit、rollback、crash 恢复)
  2. 行级锁 + 多版本并发控制 MVCC
  3. **聚簇索引**(利用主键在底层存储数据,提升主键查询 IO 性能)
  4. 外键,管理数据完整性

## 8.2 InnoDB 与 ACID 模型

| 字母 | 含义 | 说明 |
|---|---|---|
| A | Atomicity 原子性 | 事务不可再分,要么都发生、要么都不发生 |
| C | Consistency 一致性 | 事务前后数据库完整性约束不被破坏 |
| I | Isolation 独立性 | 多个事务并发时相互隔离,互不影响 |
| D | Durability 持久性 | 事务完成后更改永久保存在数据库中,不会被回滚 |

**汇款 1000 元例子**:A 账户 -1000、B 账户 +1000、A 和 B 的流水日志,四个操作必须在一个事务中完成。
- 原子性:要么全成功(汇款成功),要么全回滚(汇款失败)
- 一致性:余额变化和操作日志可以对应起来
- 独立性:A→B 与 C→B 两个汇款事务互不影响
- 持久性:成功后数据已写磁盘,数据库重启也不会变

**实现机制**:
- **隔离性**通过**锁机制**实现
- **原子性、一致性、持久性**通过 **redo(重做)和 undo(回滚)日志**实现

### autocommit 实验(重要)
```sql
-- 默认 autocommit=ON:update 后 rollback 不起作用(每条语句自动提交)
show variables like '%autocommit%';   -- ON
update score set score=90 where sid=1;
rollback;                             -- 无效!数据还是 90

-- 显式开启事务后 rollback 才有效
start transaction;
update score set score=85 where sid=1;
rollback;                             -- 数据回滚回 90
```

## 8.3 InnoDB 多版本控制(MVCC)

- 为支持并发与回滚,InnoDB 将**修改前的数据存放在回滚段(undo)**中。
- **每一行额外增加三个字段**:
  | 字段 | 作用 |
  |---|---|
  | DB_TRX_ID | 最后一次 insert/update 该行的事务 ID(delete 也算 update,多一位标记) |
  | DB_ROLL_PTR | 指针,指向回滚段里对应的 undo 日志记录 |
  | DB_ROW_ID | 每一行的行 ID |
- 回滚段中的 undo 日志**只有在事务 commit 后才被丢弃**,要**及时 commit** 避免回滚段越来越大。
- **实验**:连接1 修改未提交,连接2 读到的还是旧数据(读自己的快照版本);连接1 commit 后,连接2 在**自己 commit 之前**依然读旧数据,commit 之后才能读到新数据(88)。

## 8.4 InnoDB 体系结构(存储格式与核心组件)

### 聚簇索引(表数据存储格式)
- 根据主键寻址速度很快;主键值**递增**时 insert 效率好;主键值**随机**时 insert 效率差。

### 缓存池 Buffer Pool
- InnoDB 在内存中开辟的缓存表数据和索引数据的区域,一般设 **50%~80%** 物理内存。
- 以 **page(16K)** 为单位读取到缓存;页之间组成 list,通过 **LRU(最近最少使用)算法**置换。
- 数据读写必须经过缓存;IO 效率高、性能好。

### 自适应哈希索引(Adaptive Hash Index, AHI)
- 通过 `innodb_adaptive_hash_index` 开启(默认开),`--skip-innodb_adaptive_hash_index` 关闭。
- InnoDB 监控对索引的查找,**自动**为访问频率高的页建立哈希索引(由缓冲池的 B+ 树构造,建立快)。
- 哈希等值查找 O(1);B+ 树一般 3-4 层需 3-4 次查询。
- 要求:**对该页的连续访问模式必须一样**(如 `where a=xxx` 和 `where a=xxx and b=xxx` 是不同模式)。
- AHI 启动后读写速度提高 2 倍,辅助索引连接操作性能提高 5 倍;DBA 应指导开发尽量用符合 AHI 条件的查询。

### Redo log buffer
- 存放写入 redo log 文件内容的内存区域,大小由 `innodb_log_buffer_size` 决定;定期刷新到磁盘 redo log 文件。
- `innodb_flush_log_at_trx_commit` 决定**刷新方式**,`innodb_flush_log_at_timeout` 决定**刷新频率**。

### 系统表空间
- 存放表和索引数据,同时是 **doublewrite 缓存、change 缓存和回滚日志** 的存储空间,多个表共享。
- 默认只有一个系统数据文件 **ibdata1**;位置和个数由 `innodb_data_file_path` 决定。

### Doublewrite 缓存(双写)
- 位于系统表空间,**缓存从 buffer pool flush 出来、还没写入数据文件的页**;写盘崩溃时,InnoDB 可从 doublewrite 找到页备份执行 crash 恢复。
- 组成:内存 doublewrite buffer(2M)+ 共享表空间中**连续的 128 个页(2 个区,2M)**。
- 流程:脏页刷新时先 memcpy 到内存 doublewrite buffer → 分两次每次 1M **顺序写**共享表空间物理磁盘 → 再离散写入各表空间文件。顺序写开销不大。
- 应用 redo 前需要页副本:写失效时先用副本还原页,再做重做,这就是 double write。

### Undo 日志
- 一系列事务的 undo 记录组成,每一条包含回滚原始信息,供其他事务查看修改前数据。
- 默认在系统表空间;可用 `innodb_undo_tablespaces` + `innodb_undo_directory` 设独立 undo 表空间。
- 最多 **128 个回滚段**(32 个服务临时表,96 个服务非临时表);每个回滚段同时支持 **1023** 个修改事务,共 96K 个;`innodb_undo_logs` 设置回滚段个数。
- 原理:操作任何数据前**先备份到 undo log**,出错误或 rollback 时用备份恢复到事务开始前状态。

### File-per-table 表空间
- 开启 `innodb_file_per_table` 后,每个表的数据和索引独立存放在 `.ibd` 文件(5.7 默认 ON)。

### 临时表空间
- 存放临时表,默认数据目录下 **ibtmp1**,每次自动增长 12MB;`innodb_temp_data_file_path` 指定位置。
- 正常 shutdown 自动清除;crash 时不自动清除,需 DBA 手动删或重启。临时表空间文件大时可重启 MySQL 释放空间。

### Redo log(磁盘文件)
- `ib_logfile0` 和 `ib_logfile1` 两个文件;crash 恢复时把**已提交但未写入数据文件**的事务在初始化时重放。
- 提供**组提交(group commit)**:一次写盘包含多个事务数据,提高性能。
- **数据持久化原理**:数据库修改都在内存缓存完成 → 断电内存丢失 → 靠持久化好的日志文件,把日志中未持久化到数据文件的记录重放到数据文件。

> **8.0 差异提醒**:MySQL 8.0.30 起 redo 日志不再用 `ib_logfile0/1`,改由 `innodb_redo_log_capacity`(默认 100MB)统一管理,文件存放在 `#innodb_redo` 目录(默认 32 个),可在线调大调小;8.0.34 起 `innodb_log_file_size`/`innodb_log_files_in_group` 已废弃。详见第 19 课 19.1。

### 日志持久化参数(innodb_flush_log_at_trx_commit)
| 值 | 行为 | 安全性/性能 |
|---|---|---|
| 0 | 每秒写入并持久化一次 | 不安全、性能高;MySQL 或服务器宕机最多丢 1 秒数据 |
| 1 | 每次 commit 都持久化 | 安全、性能低、IO 负担重(默认) |
| 2 | 每次 commit 写入内存缓存,每秒刷磁盘 | 折中;MySQL 宕机不丢,**服务器宕机**最多丢 1 秒 |

- `innodb_flush_log_at_timeout` 决定最多丢多少秒数据,默认 1 秒。

## 8.5 InnoDB 存储引擎配置

### 启动配置
- 合理规划:在创建实例前就定义好数据文件、日志文件、数据页大小等属性。
- my.cnf 默认查找路径从上到下,找到的文件先读,但**优先级逐级提升**。

### 系统表空间数据文件配置
```ini
innodb_data_file_path = ibdata1:50M;ibdata2:50M:autoextend
# datafile_spec = file_name:file_size[:autoextend[:max:max_file_size]]
# autoextend 默认一次增 64M(innodb_autoextend_increment 可改)
# max 限制最大容量;autoextend 和 max 只能用于最后一个文件
innodb_data_home_dir = /path/to/myibdata/    # 指定数据文件目录
```

### 日志文件配置
```ini
innodb_log_group_home_dir = /dr3/iblogs       # redo 日志位置
innodb_log_files_in_group = 2                 # 日志文件个数,默认和推荐都是 2
innodb_log_file_size = 50331648               # 每个日志文件大小(默认 48M)
```
- 日志文件越大,缓冲池文件间切换越少,减少 IO;至少保证**高峰期 1 小时**的日志能放进一个文件不切换;**所有日志文件总大小不能超过 512G**。

### Undo / 临时表空间配置
```ini
innodb_undo_directory    = ./        # 独立 undo 表空间目录
innodb_undo_logs         = 128       # 回滚段个数(可动态调整)
innodb_undo_tablespaces  = 0         # 独立 undo 表空间个数(建实例时配置,如 16 则创建 16 个 10M undo 文件)
innodb_temp_data_file_path = ibtmp1:12M:autoextend   # 临时表空间
```

### 数据页与内存配置
```ini
innodb_page_size = 16K        # 数据页大小:16K 默认,可 64K/32K/8K/4K,尽量接近磁盘 block size
innodb_buffer_pool_size = 128M   # 缓存表数据和索引的内存,推荐内存 50%~80%
innodb_buffer_pool_instances = N # 大内存拆多实例提高并发
innodb_log_buffer_size = 16M     # redo 缓存默认 16M;大事务改多可调大
```

### InnoDB 只读设置
```ini
innodb-read-only=1
# update 时报:ERROR 1015 Can't lock file - Table is read only
```

## 8.6 InnoDB buffer pool 配置(性能调优重点)

### 结构原理
- 底层是一个列表,通过 **LRU 算法**换入换出:列表头部 = 最常使用,尾部 = 最少使用。
- 列表后部 3/8(默认 `innodb_old_blocks_pct=37%`)保存最少使用页;最少使用区页被访问时移到头部。

### 配置大小
- 大小可在启动时配置,也可**运行中动态修改**(`SET GLOBAL innodb_buffer_pool_size=...`;执行时等当前所有事务结束,期间其他事务访问 buffer pool 会等待;用 error log 或 `Innodb_buffer_pool_resize_status` 查看进度)。
- 调整以**大块**为单位,块大小 `innodb_buffer_pool_chunk_size` 默认 **128M**,只能在启动前改。
- `innodb_buffer_pool_size` 必须是 `chunk_size × instances` 的整数倍,否则自动调整成大于设定值且最接近的值。例:设 9G + 16 instances → 实际 10G。

### 配置多个实例
- GB 级 buffer pool 时拆多个实例降低线程竞争:`innodb_buffer_pool_instances`,默认 1,最大 64。数据页随机放置到任意实例,每个实例独立完整特性。

### Scan Resistant(防全表扫描污染缓存)
- 新读的页插入 LRU 列表 3/8 处;`innodb_old_blocks_pct` 控制 old 区占比(默认 37%,5~95);`innodb_old_blocks_time` 默认 1000 毫秒,指定页读入后不移动到热区的时间窗口(防止一次性全表扫描把热数据挤出去)。

### 预读取(Read-Ahead)
- **线性 read ahead**:顺序读取一个区的页数 >= `innodb_read_ahead_threshold`(默认 56,0~64)时,触发异步读整个区。
- **随机 read ahead**:buffer pool 中同一区已有 13 个连续页时读入该区其它页;`innodb_random_read_ahead=ON` 开启。
- 用 `show engine innodb status` 的 `Innodb_buffer_pool_read_ahead` / `_evicted` / `_rnd` 判断有效性。

### Flushing(刷脏页)
- 脏页(已修改未写盘)占比达到 `innodb_max_dirty_pages_pct_lvm` 触发 flush,达到 `innodb_max_dirty_pages_pct` 会"强烈"flush。
- 修改繁忙系统可调:`innodb_adaptive_flushing_lwm`(redo log 容量超阈值触发 adaptive flush)、`innodb_io_capacity_max`、`innodb_flushing_avg_loops`。

### 保存/恢复 buffer pool 状态(防止冷启动慢)
```ini
innodb_buffer_pool_dump_at_shutdown = ON   # 默认开,关库把热数据页存到数据目录 ib_buffer_pool 文件
innodb_buffer_pool_load_at_startup  = ON   # 默认开,启动时批量加载
innodb_buffer_pool_dump_pct = 40           # 保留占比
```
```sql
SET GLOBAL innodb_buffer_pool_dump_now=ON;  -- 运行中保存
SET GLOBAL innodb_buffer_pool_load_now=ON;  -- 运行中加载
SHOW STATUS LIKE 'Innodb_buffer_pool_dump_status';  -- 查看进度
```

### 监控 buffer pool
- `show engine innodb status` 的 BUFFER POOL AND MEMORY 段:Total large memory allocated / Buffer pool size / Free buffers / Database pages / Modified db pages / **Buffer pool hit rate 1000/1000**(命中率接近 1000 说明缓存充足)。

## 8.7 InnoDB 其他配置

### Change Buffer(变更缓冲)
- 5.5 新增(insert buffer 加强版):**修改二级索引页但页不在 buffer pool 时**,把修改信息 cache 到 change buffer,等索引块被读到 buffer pool 时合并再写盘;减少随机 IO。
- `innodb_change_buffering`:all(默认,缓存 insert/delete/purges)/ none / inserts / deletes / changes(insert+delete)/ purges(update 视为 delete+insert)。
- `innodb_change_buffer_max_size`:change buffer 占 buffer pool 最大百分比,默认 **25%**,最大 50%;大量修改操作时调大。

### 线程并发度 / IO 线程
- `innodb_thread_concurrency`:限制同时执行的线程数,默认 0(不限制)。
- `innodb_read_io_threads` / `innodb_write_io_threads`:后台读写数据页线程数,默认 4,范围 1-64。
- `innodb_use_native_aio`:Linux 异步 IO 默认开,需 libaio 支持。
- `innodb_io_capacity`:整体 IO 能力,默认 200(=100 相当于 7200RPM 磁盘性能)。

### Purge 配置
- purge 是垃圾回收操作,回收已提交事务不再需要的 undo 页;`innodb_purge_threads` 设置 purge 线程数(最大 32),复杂 DML 可增加。

### 优化器统计信息
- 分**永久**和**非永久**两种;永久统计信息存磁盘 `mysql.innodb_table_stats` 和 `mysql.innodb_index_stats` 两表。
- `innodb_stats_auto_recalc`:表超过 10% 行变化是否自动更新(异步,未必马上);可执行 `analyze table` 同步更新。
- 表级子句:`STATS_PERSISTENT=1`(永久)、`STATS_AUTO_RECALC=1`、`STATS_SAMPLE_PAGES=25`(样本页数)。
- `innodb_table_stats` 字段:database_name / table_name / last_update / **n_rows**(行数)/ **clustered_index_size**(主键数据页数)/ **sum_of_other_index_sizes**(非主键索引页数)。
- `innodb_index_stats` 字段:database_name / table_name / **index_name** / last_update / **stat_name**(n_diff_pfxNN 表示前 N 列区别值数;n_leaf_pages 叶子页数;size 索引页数)/ sample_size / stat_description。
- 手工改完两表数据后要 `flush table 表名` 重新加载统计信息。
- `innodb_stats_persistent=OFF`(或单表 stats_persistent=0):统计只存内存,重启丢失;`show table status` / 查询 information_schema 时(innodb_stats_on_metadata 开)或 1/16 数据被修改时自动更新。
- `innodb_stats_persistent_sample_pages` 默认 20:执行计划不佳时增大以获得正确统计。

### 索引页合并阈值
- `merge_threshold`(默认 50,范围 1~50):索引页数据因删改低于阈值时与邻近页合并。
- 表级:`ALTER TABLE t1 COMMENT='MERGE_THRESHOLD=40'`;索引级:`KEY id_index (id) COMMENT 'MERGE_THRESHOLD=40'`。
- 用 `INFORMATION_SCHEMA.INNODB_METRICS` 里 `index_page_merge_attempts` / `index_page_merge_successful` 评估。

## 8.8 InnoDB 运维实操

### 重置系统表空间
- 简单方法:最后一个文件加 autoextend 自动增长(默认 64M,`innodb_autoextend_increment` 可改)。
- 增加数据文件:关库 → 把最后一个 autoextend 文件改成当前大小 → 配置里加新文件(可 autoextend)→ 启动。
- 减小系统表空间:mysqldump 出所有 InnoDB 表(含 mysql 库 5 个 InnoDB 表:innodb_index_stats/innodb_table_stats/slave_master_info/slave_relay_log_info/slave_worker_info)→ 关库 → 删除所有 .ibd、ib_log*、mysql 库下 .ibd → 删所有 .frm → 配置新表空间文件 → 启动 → 导入 dump。

### 重置 redo log 文件大小
- 关库 → 改 `innodb_log_file_size` / `innodb_log_files_in_group` → 启动。

### 单表表空间(innodb_file_per_table=1)
- **优势**:删表/truncate 回收磁盘空间(共享表空间只产生空闲空间);truncate 更快;`create table ... data directory=绝对路径` 可把表放指定磁盘;可物理拷贝单表到其他实例。
- **劣势**:每表有未使用空间,浪费磁盘。
- 共享表空间表转独立表空间:`SET GLOBAL innodb_file_per_table=1; ALTER TABLE t ENGINE=InnoDB;`
- `DATA DIRECTORY='/alternative/directory'`:指定路径下创建数据库同名文件夹含 .ibd;MySQL 数据目录下生成 `.isl` 链接文件。

### 传输表空间(单表迁移到另一实例)
```sql
-- 目标实例:建同结构表后去掉表空间(外键表需先 foreign_key_checks=0)
ALTER TABLE t DISCARD TABLESPACE;
-- 原实例:加锁只读并生成 .cfg 元文件
FLUSH TABLES t FOR EXPORT;
-- shell:scp .ibd 和 .cfg 到目标实例
UNLOCK TABLES;
-- 目标实例:导入
ALTER TABLE t IMPORT TABLESPACE;
```

### Undo log 独立表空间
- `innodb_undo_tablespaces` 只能在建实例时配置;`innodb_undo_log_truncate=ON` 开启 undo 表空间清空:文件超过 `innodb_max_undo_log_size`(默认 1G)标记清空 → 回滚段标记非激活(不接新事务,等已有事务完成)→ purge 释放 → 全部释放后表空间清空成初始 10M → 回滚段重新激活。

### 普通(共享)表空间
```sql
CREATE TABLESPACE ts1 ADD DATAFILE '/my/tablespace/directory/ts1.ibd' Engine=InnoDB;
CREATE TABLE t1 (c1 INT PRIMARY KEY) TABLESPACE ts1 ROW_FORMAT=COMPACT;
ALTER TABLE t2 TABLESPACE ts1;
-- 在系统表空间 / 独立表空间 / 普通表空间之间互转:
ALTER TABLE t TABLESPACE innodb_system;
ALTER TABLE t TABLESPACE innodb_file_per_table;
```
- `alter table ... tablespace` 都会导致**表重建**。
- 删普通表空间前必须删光其上所有表;drop database 不会自动删 tablespace;普通表空间**不支持临时表**、不支持 discard/import tablespace。

## 8.9 InnoDB 表

### 创建与文件
- 默认引擎即 InnoDB;创建后生成 `.frm`(结构);共享表空间数据放 ibdata1;独立表空间放 `.ibd`。
- `show table status like 'students'\G` 查看:Engine / Row_format(**Dynamic**)/ Rows / Data_length / Index_length / Auto_increment / Create_time 等。

### 自增长字段
- 表在内存保存自增长计数器;初始值 1(`auto_increment_offset` 改);插入时取当前表最大值+1;步长 `auto_increment_increment`。

### InnoDB 表主要限制
- 最多 **1017 个列**
- 最多 **64 个二级索引**
- 多列索引最多 **16 个列**
- 无 text/blob 字段时,**行数据最大 65535 字节**(超了报 ERROR 1118 Row size too large,需改 TEXT/BLOB)


---

# 第9课 MySQL 字符集

## 9.1 字符集与排序规则简介

- MySQL 提供多种字符集和排序规则:
  - **字符集(charset)**:与数据存储、客户端与实例交互相关
  - **排序规则(collation)**:与字符串对比规则相关
- 字符集可在 **实例、数据库、表、列** 四个级别设置;支持 InnoDB、MyISAM、Memory 三个引擎。
- 查看支持的字符集:
  - `SHOW CHARACTER SET;`
  - `SHOW CHARACTER SET LIKE 'latin%';`
  - `SELECT * FROM information_schema.character_sets;`

**SHOW CHARACTER SET 结果字段**:Charset(字符集名)/ Description(描述)/ Default collation(默认排序规则)/ Maxlen(每个字符最多字节数)。

## 9.2 排序规则简介

- 查看:`SHOW COLLATION;` / `SHOW COLLATION WHERE Charset='latin1';` / `information_schema.collations`。
- **不同的字符集不可能有相同的排序规则;每个字符集都有一个默认的排序规则**。
- 排序规则只属于一个字符集,混用报错:
```sql
SELECT _latin1 'x' COLLATE latin2_bin;
-- ERROR 1253 (42000): COLLATION 'latin2_bin' is not valid for CHARACTER SET 'latin1'
```
- latin1 部分排序规则含义:

| Collation | 含义 |
|---|---|
| latin1_bin | 二进制比较,区分大小写 |
| latin1_danish_ci | 丹麦语和挪威语 |
| latin1_general_ci | 支持多种语言(西欧),不区分大小写 |
| latin1_general_cs | 支持多种语言(西欧),**区分大小写** |
| latin1_german1_ci | 德语(字典排序) |
| latin1_german2_ci | 德语(电话本排序) |
| latin1_spanish_ci | 西班牙语 |
| latin1_swedish_ci | 瑞典语和芬兰语(默认) |

## 9.3 排序规则命名规则

- 以字符集名开头 + 语言名 + 结尾属性:
  - 例:`utf8_general_ci`、`latin1_swedish_ci`、`utf8_turkish_ci`(UTF8 的土耳其语)
- 结尾符含义:

| 结尾符 | 含义 |
|---|---|
| _ai | 重音不敏感(accent insensitive) |
| _as | 重音敏感(accent sensitive) |
| _ci | 大小写不敏感(case insensitive) |
| _cs | 大小写敏感(case sensitive) |
| _bin | 二进制 |

- 未写 _as/_ai 时由 _ci/_cs 推断:**_ci 暗指 _ai,_cs 暗指 _as**。
- Unicode 排序规则可含 unicode 算法版本号,如 `utf8_unicode_520_ci`(5.2.0 版)与 `utf8_unicode_ci`(4.0.0 版,无版本号默认 4.0.0)。

## 9.4 默认字符集与 latin1 特性

- 实例默认字符集 **latin1**:
```
character_set_client = latin1      character_set_connection = latin1
character_set_database = latin1    character_set_filesystem = binary
character_set_results = latin1     character_set_server = latin1
character_set_system = utf8        character_sets_dir = /usr/local/mysql/share/charsets/
```
- latin1(ISO 8859-1)是**单字节编码**,向下兼容 ASCII,编码范围 0x00-0xFF;**覆盖所有单字节**,任何字符串都能存进 latin1 列而不会被丢弃。
- 因此常把 gbk/utf8/big5 等字符串存进 latin1 列,原样取出仍是原编码;**latin1 只是"包装",不改内容**。若把 gbk 字符串存进 utf8 列,不符合 utf8 编码的内容会被抛弃,**数据被破坏、无法恢复**。
- 类比:latin1 像"单个苹果包装盒",每个字节单独装,能完整还原;utf8 像"按重量装箱",跨字节字符可能被切开破坏。
- 中文存 latin1 表中,`set names latin1` 时显示正常;`set names utf8` 后显示乱码 `ä¸­å›½`(数据没丢,是显示问题)。

### 大小写敏感实验(ci vs cs)
```sql
CREATE TABLE temp1(name varchar(10) charset latin1 collate latin1_general_ci,
                   name2 varchar(10) charset latin1 collate latin1_general_cs);
INSERT INTO temp1 VALUES('a','a'),('A','A');
SELECT count(distinct name), count(distinct name2) FROM temp1;
-- 1 (ci 不区分大小写,视为一个)    2 (cs 区分大小写)
```

## 9.5 四级字符集设置

### ① 实例级(character_set_server / collation_server)
- 启动参数 `--character-set-server` 与 `--collation-server`;只指定字符集时排序规则用默认值。
- 三个等价写法:`mysqld` / `mysqld --character-set-server=latin1` / `mysqld --character-set-server=latin1 --collation-server=latin1_swedish_ci`。
- 作用:create database 没指定字符集时,新库默认使用实例字符集。
- 5.7 注意:**老参数 `default-character-set` 在 mysqld 段会导致无法启动**:
```
ERROR: unknown variable 'default-character-set=utf8'
```
  (该参数只能用于 [client] 段)

### ② 数据库级(存在 db.opt 文件)
- `CREATE DATABASE db_name CHARACTER SET latin1 COLLATE latin1_swedish_ci;`
- 只指定字符集 → 用默认排序规则;只指定排序规则 → 用其对应字符集;都没指定 → 用实例级。
- **alter database 修改只影响后续新建的表**,已建表的字符集不变。

### ③ 表级
- `CREATE TABLE t1 (...) CHARACTER SET latin1 COLLATE latin1_danish_ci;`
- 规则同上:字段有定义用字段的;表没定义用数据库的。

### ④ 列级(仅字符串类型:char/varchar/text)
- `CREATE TABLE t1 (col1 VARCHAR(5) CHARACTER SET latin1 COLLATE latin1_german1_ci);`
- `ALTER TABLE t1 MODIFY col1 VARCHAR(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci;`
- **修改列字符集会尝试转换已有数据,可能造成数据丢失/变 ?**(如 utf8 中文列改成 greek:`'中国' → '????'`)。

### 继承优先级(字段/表/库/实例)
```
字段级指定 > 表级指定 > 数据库级指定 > 实例级(character_set_server)
```
- 字段只指定字符集,排序规则用该字符集**默认排序规则**(不是表的!)。例:表指定 `latin1_danish_ci`,字段只写 `CHARACTER SET latin1` → 字段排序规则是 `latin1_swedish_ci`。

## 9.6 连接级字符集

- 客户端每个连接有自己的字符集:发送语句用 `character_set_client`;与服务端交互转换用 `character_set_connection` / `collation_connection`;返回结果用 `character_set_results`。
- 字符串字面量比较用 `collation_connection`;字段比较用字段本身的排序规则。
- **SET NAMES 'charset_name' [COLLATE ...]** = 三条语句:
```sql
SET character_set_client = charset_name;
SET character_set_results = charset_name;
SET character_set_connection = charset_name;
```
- **SET CHARACTER SET 'charset_name'** = 三条语句(connection 取当前库字符集):
```sql
SET character_set_client = charset_name;
SET character_set_results = charset_name;
SET character_set_connection = @@character_set_database;
```
- 例:`set names latin1 collate latin1_general_cs;` 后 `'a'='A'` 结果为 0。

## 9.7 字符串字面量的字符集

- 显式指定语法:`[_charset_name]'string' [COLLATE collation_name]`
```sql
SELECT 'abc';
SELECT _latin1'abc';
SELECT _binary'abc';
SELECT _utf8'abc' COLLATE utf8_danish_ci;
```
- 指定优先级:显式 charset+collation > 只指定 charset(默认排序规则)> 只指定 collation(必须与 connection 字符集兼容)> 都不指定(用 connection 参数)。
- 例:`SELECT 'Müller' COLLATE utf8_general_ci;` 在 latin1 连接下报 `ERROR 1253`(排序规则与字符集不匹配)。

## 9.8 国家字符集

- 标准 SQL 的 `nchar`/`nvarchar` 在 MySQL 中就是 UTF8:
```sql
CHAR(10) CHARACTER SET utf8 ≡ NATIONAL CHARACTER(10) ≡ NCHAR(10)
VARCHAR(10) CHARACTER SET utf8 ≡ NVARCHAR(10) ≡ NCHAR VARCHAR(10) ≡ ...
SELECT N'some text' ≡ SELECT _utf8'some text';
```

## 9.9 排序规则在 SQL 中的使用(COLLATE 覆盖)

```sql
SELECT k FROM t1 ORDER BY k COLLATE latin1_german2_ci;     -- order by
SELECT k COLLATE latin1_german2_ci AS k1 FROM t1 ORDER BY k1; -- as
SELECT k FROM t1 GROUP BY k COLLATE latin1_german2_ci;     -- group by
SELECT MAX(k COLLATE latin1_german2_ci) FROM t1;           -- 聚合函数
SELECT DISTINCT k COLLATE latin1_german2_ci FROM t1;       -- distinct
SELECT * FROM t1 WHERE _latin1 'Müller' COLLATE latin1_german2_ci = k;  -- where
SELECT k FROM t1 GROUP BY k HAVING k = _latin1 'Müller' COLLATE latin1_german2_ci; -- having
```
- distinct 实验:`count(distinct name2)`(cs)= 4,`count(distinct name2 collate latin1_general_ci)` = 2。

## 9.10 排序规则冲突(ERROR 1267)

- 两个不同排序规则的值比较报错:
```sql
SELECT * FROM temp WHERE name=name2;
-- ERROR 1267: Illegal mix of collations (latin1_general_ci,IMPLICIT) and (latin1_general_cs,IMPLICIT) for operation '='
SELECT * FROM temp WHERE name collate latin1_general_ci='A' collate latin1_general_cs;
-- ERROR 1267 ... (EXPLICIT)
```

### coercibility(权重)规则
| 权重 | 情况 |
|---|---|
| 0 | 显式写明排序规则(EXPLICIT) |
| 1 | 两个不同排序规则的字符串连接 |
| 2 | 字段和本地参数(IMPLICIT) |
| 3 | 系统常量(VERSION() 等) |
| 4 | 字符串字面量自带(COERCIBLE) |
| 5 | 数字 |

- 选排序规则:优先权重最低;权重相同时:同为 Unicode 或同非 Unicode → 报错;一边 Unicode 一边非 → 非 Unicode 自动转 Unicode;同字符集一个 _bin 一个 _ci/_cs → 用 _bin。
- 查看权重:`SELECT COERCIBILITY('A' COLLATE latin1_swedish_ci); -- 0`,`COERCIBILITY(VERSION()) = 3`,`COERCIBILITY('A') = 4`,`COERCIBILITY(1000) = 5`。
- 典型结果:`column1 = 'A'` 用列排序规则;`column1 = 'A' COLLATE x` 用 x;`column1 COLLATE x = 'A' COLLATE y` 报错。

## 9.11 德语排序例子(latin1_swedish_ci vs german1 vs german2)

| latin1_swedish_ci | latin1_german1_ci | latin1_german2_ci |
|---|---|---|
| Muffler | Muffler | **Müller** |
| MX Systems | Müller | Muffler |
| Müller | MX Systems | MX Systems |
| MySQL | MySQL | MySQL |

## 9.12 Unicode 字符集

- Unicode 为每种语言的每个字符设定统一唯一的二进制编码;编码方案:Utf-8/Utf-16/Utf-32。

| Charset | 支持的字符 | 每字符字节数 |
|---|---|---|
| utf8 | BMP only | 1,2,3 字节 |
| ucs2 | BMP only | 2 字节 |
| utf8mb4 | BMP + 补充 | 1,2,3,4 字节 |
| utf16 / utf16le | BMP + 补充 | 2 或 4 字节 |
| utf32 | BMP + 补充 | 4 字节 |

- BMP(基本多语言平面)之外的扩展字符转成 utf8 等 BMP 字符集时,不认识的字符变 `?`。
- **客户端字符集只能设 UTF8**(set names/set character set 对 Unicode 只支持 UTF8)。
- utf8 编码规则:基础拉丁字母/数字/标点 1 字节;扩展拉丁/希腊/斯拉夫/阿拉伯 2 字节;韩语/中文/日语 3~4 字节;**MySQL 的 utf8 最多 3 字节,不支持扩展字符**。
- length vs char_length:
```sql
SELECT length('中国'), char_length('中国');  -- utf8 下:6 字节,2 字符
```

## 9.13 不同字符集下空间消耗

| 类型 | 存储空间 |
|---|---|
| CHAR(M) | M × w 字节(w = 该字符集最大字节数;M<=255) |
| BINARY(M) | M 字节(M<=255) |
| VARCHAR(M)/VARBINARY(M) | L+1(值<=255字节)或 L+2 字节 |
| TINYBLOB/TINYTEXT | L+1(L<2^8) |
| BLOB/TEXT | L+2(L<2^16) |
| MEDIUMBLOB/MEDIUMTEXT | L+3(L<2^24) |
| LONGBLOB/LONGTEXT | L+4(L<2^32) |
| ENUM | 1 或 2 字节(最多 65535 个值) |
| SET | 1/2/3/4/8 字节(最多 64 个成员) |

- 行数据最大 **65535 字节**(不含 BLOB/TEXT):utf8 下 varchar 最大 21844 字符:
```sql
CREATE TABLE temp2(name varchar(21845)) charset=utf8;
-- ERROR 1118: Row size too large. ... 65535
```

## 9.14 中文字符集

| 字符集 | 说明 | 默认排序规则 |
|---|---|---|
| big5 | 繁体中文 | big5_chinese_ci / big5_bin |
| gb2312 | 简体中文 | gb2312_chinese_ci / gb2312_bin |
| gbk | 简体中文(GBK) | gbk_chinese_ci / gbk_bin |
| gb18030 | **中国官方标准** | gb18030_chinese_ci(字母按字母、汉字按拼音)/ gb18030_bin / gb18030_unicode_520_ci |

- 混合字段示例:表字符集 latin1,c1=utf8、c2=gbk、c3=gb2312、c4 未指定(latin1),`set names utf8` 插入'测试' → c4 显示 `??`(latin1 存 utf8 中文被破坏)。

## 9.15 生产字符集配置与规范

### my.cnf 配置
```ini
[mysqld]
character_set_server=utf8          # 影响 character_set_server / character_set_database,需重启生效
[client]
default-character-set=utf8         # 影响 client/connection/results,无需重启
```
- `--init_connect="SET NAMES 'utf8'"`:每个客户端连接自动设置字符集,**对 SUPER 权限用户不生效**(root 不受影响)。
- `SET GLOBAL init_connect='SET AUTOCOMMIT=0;set names utf8';`(可同时指定多条语句)

### MySQL 字符集转化流程
```
① 客户端请求数据:character_set_client → character_set_connection
② 内部操作:character_set_connection → 内部操作字符集(字段>表>库>server 逐级查找)
③ 返回结果:内部操作字符集 → character_set_results
```

### 乱码的终极解决方案(面试/排障)
1. **先明确客户端编码**(命令行 gbk、网页 utf8、程序按代码设置)
2. 数据库统一 **utf8**(8.0 用 utf8mb4),所有编码通吃
3. **保证 connection 字符集 >= client 字符集**,否则信息丢失:
   `latin1 < gb2312 < gbk < utf8`
4. 存储全部转成 utf8/utf8mb4 后,再按需用 character_set_results 调节显示编码

### 乱码两种典型情况
- **存储编码比插入时编码大**(utf8 表 + latin1 连接插入):数据不丢,换对查询字符集即可恢复(显示乱码可逆)。
- **存储编码比插入时编码小**(latin1 表 + utf8 连接插入):超出范围的字符直接变 `?`,数据被破坏,**不可恢复**。


---

# 第10课 锁机制和事务

## 10.1 InnoDB 锁机制(总体)

- InnoDB 支持**行级锁**,大类分两种:
  - **S 共享锁(Shared)**:允许拥有共享锁的事务读取该行数据。一个事务持有一行的共享锁时,其他事务可以在同一行**也获得共享锁**,但**无法获得排他锁**。
  - **X 排他锁(Exclusive)**:允许拥有排他锁的事务修改/删除该行数据。其他事务在此行上**无法获得共享锁和排他锁**,只能等待锁释放。
- InnoDB 还支持**意图锁(Intention Lock)**,属于**表级锁**,表明事务后期会对该表的行施加共享或排他锁:
  - **IS 共享意图锁**:事务将对表的行施加共享锁(如 `SELECT ... LOCK IN SHARE MODE`)
  - **IX 排他意图锁**:事务将对表的行施加排他锁(如 `SELECT ... FOR UPDATE`)

### 四种锁共存/排斥矩阵
|  | X | IX | S | IS |
|---|---|---|---|---|
| X | Conflict | Conflict | Conflict | Conflict |
| IX | Conflict | **Compatible** | Conflict | Compatible |
| S | Conflict | Conflict | Compatible | Compatible |
| IS | Conflict | Compatible | Compatible | Compatible |

- 决定能否立即加锁:看该数据上已存在的锁与请求的锁是共存还是排斥;排斥则等待释放。

## 10.2 锁相关系统表(排查锁问题神器)

### information_schema.innodb_trx(正在执行的事务)
| 列 | 含义 |
|---|---|
| TRX_ID | InnoDB 内部事务 ID |
| TRX_WEIGHT | 事务权重 ≈ 锁住的行数;**死锁时 InnoDB 选择权重最小的事务作为牺牲品** |
| TRX_STATE | 状态:RUNNING / LOCK WAIT / ROLLING BACK / COMMITTING |
| TRX_STARTED | 事务开始时间 |
| TRX_REQUESTED_LOCK_ID | LOCK WAIT 时等待的锁 ID(对应 data_locks) |
| TRX_WAIT_STARTED | 等待锁的开始时间 |
| TRX_MYSQL_THREAD_ID | MySQL 线程 ID(对应 show processlist) |
| TRX_QUERY | 事务当前执行的语句 |
| TRX_OPERATION_STATE | 当前执行语句类型 |
| TRX_TABLES_IN_USE | 涉及几个 InnoDB 表 |
| TRX_TABLES_LOCKED | 行锁对应几个表 |
| TRX_LOCK_STRUCTS | 保留的锁个数 |
| TRX_LOCK_MEMORY_BYTES | 锁信息占内存字节数 |
| TRX_ROWS_LOCKED | ≈当前事务行锁数量 |
| TRX_ROWS_MODIFIED | 插入/修改的行数 |
| TRX_ISOLATION_LEVEL | 当前事务隔离级别 |
| TRX_UNIQUE_CHECKS / TRX_FOREIGN_KEY_CHECKS | 唯一/外键约束检查开关(批量导入常关闭) |
| TRX_IS_READ_ONLY | 1 = 只读事务 |
| TRX_AUTOCOMMIT_NON_LOCKING | 1 = 事务只有一条普通 select,不加锁 |

### performance_schema.data_locks(每个锁的信息)
| 列 | 含义 |
|---|---|
| ENGINE_LOCK_ID | 锁 ID |
| LOCK_TRX_ID | 持有锁的事务 ID |
| LOCK_MODE | 锁模式:S/X/IS/IX 及 S[,GAP]/X[,GAP]/INSERT_INTENTION/AUTO_INC 等 |
| LOCK_TYPE | RECORD(行锁)或 TABLE(表锁) |
| OBJECT_NAME | 表名 |
| INDEX_NAME | 行锁对应的索引名 |
| LOCK_SPACE | 表空间 ID |
| LOCK_DATA | 锁定记录的主键值(表锁为 NULL) |

### sys.innodb_lock_waits(锁等待关系)
| 列 | 含义 |
|---|---|
| waiting_trx_id | 请求锁被阻塞的事务 ID |
| waiting_pid | 被阻塞的 process id |
| blocking_trx_id | 阻塞别人的事务 ID |
| blocking_pid | 阻塞别人的 process id |

## 10.3 行级锁实验(有索引 vs 无索引)

- 行级锁施加在**索引行数据**上,如 `SELECT c1 FROM t WHERE c1=10 FOR UPDATE` 在 c1=10 的索引行上加锁,阻止其他事务对该索引行的 insert/update/delete。
- **表无任何索引时**,行锁施加在隐式创建的聚簇索引上;**一条 SQL 没走任何索引时,会在每一条聚簇索引后加 X 锁**,效果类似表锁,但原理不同。

### 实验1:无索引表(update id=1 后,update id=2 也被阻塞)
```sql
-- 无主键表 temp(id,name) 有 1,2,3 三行
-- 连接1
SET autocommit=0;
UPDATE temp SET name='aa' WHERE id=1;   -- 获得锁
-- 连接2
UPDATE temp SET name='bb' WHERE id=2;   -- 阻塞!(表无索引,全表记录都加了X锁)
-- 连接1 COMMIT 后,连接2 等待结束,执行成功
```
- 从 data_locks 可以看到:连接1 的锁模式为 IX(TABLE)+ X(RECORD)锁住所有记录(supremum pseudo-record + 每行),**即使 update 只涉及一行,其他行也被锁**。

### 实验2:加主键后(id 走 PRIMARY 索引)
- 连接1 `UPDATE temp SET name='aa' WHERE id=1` → 只锁 id=1 这一行(X,REC_NOT_GAP)。
- 连接2 `UPDATE temp SET name='bb' WHERE id=1` → 等待;`WHERE id=2` → **直接执行,不等待**。
- data_locks 显示:连接1 只有 PRIMARY 索引上 id=1 一条 X 锁记录。

> 结论:**给表加合适的索引,能大幅缩小锁范围、提高并发**。

## 10.4 间隔锁(Gap Lock)

- 用**范围条件**而非相等条件检索并请求共享/排他锁时,InnoDB 给符合条件已有记录的索引项加锁;**对条件范围内不存在的记录("间隙")也加锁**。
- 间隔锁是施加在索引记录**之间**的锁,锁住一个范围但不包括记录本身。例:`SELECT c1 FROM t WHERE c1 BETWEEN 10 AND 20 FOR UPDATE` 即使表里没有 c1=15,也**阻止其他事务插入 15**。
- **间隔锁只在部分事务隔离级别生效**;只阻止其他事务的**插入**操作。

### Gap Lock 前置条件(面试重点)
1. 事务隔离级别 **REPEATABLE-READ**,且 SQL 走**非唯一索引**(无论等值还是范围检索)
2. 事务隔离级别 REPEATABLE-READ,且 SQL 是**范围的当前读操作**(此时即使唯一索引也会加 gap lock)

- 参数 `innodb_locks_unsafe_for_binlog`(强制不使用间隔锁)**在 8.0 中已取消**。

### 实验:范围 update 阻止 insert
```sql
-- 表 temp 有主键 id,数据 1,2,3
-- 连接1
SET autocommit=0;
UPDATE temp SET name='abc' WHERE id BETWEEN 4 AND 6;  -- 匹配 0 行,但加了间隔锁
-- 连接2
INSERT INTO temp VALUES(4,'d');   -- 阻塞!(supremum pseudo-record 的 X 锁)
-- 连接1 COMMIT 后,连接2 插入成功
```
- 连接1 `WHERE id>4` 也一样,id=3~4 之间也算间隔,insert 4 被阻止。
- data_locks 显示:连接1 有 X RECORD 锁在 `supremum pseudo-record` 上;连接2 的 `X,INSERT_INTENTION` 锁处于 WAITING。

## 10.5 Next-Key 锁(记录锁 + 间隔锁)

- MySQL 默认隔离级别可重复读,默认采用 **Next-Key Locks**:记录锁和间隔锁的结合 —— **锁住记录本身,再锁住索引之间的间隙**。

## 10.6 插入意图锁(Insert Intention Lock)

- 插入数据时**首先获得的一种间隔锁**;只要不同事务插入的数据**位置不一样**,即使在同一间隔内也不互斥。
- 例:索引有 4 和 7 两个值,事务 A 插 5、事务 B 插 6,虽然都在 4~7 间隔,但位置不同,不互斥。
- 事务 A 对 `id>100` 加排他间隔锁,事务 B 插入 id=101 时**试图先加插入意图锁而必须等待**:
```sql
-- A
CREATE TABLE child (id int NOT NULL, PRIMARY KEY(id)) ENGINE=InnoDB;
INSERT INTO child (id) VALUES (90),(102);
START TRANSACTION;
SELECT * FROM child WHERE id > 100 FOR UPDATE;   -- 锁 102 + 间隔
-- B
START TRANSACTION;
INSERT INTO child (id) VALUES (101);            -- 阻塞,等待插入意图锁
```
- `SHOW ENGINE INNODB STATUS` 中可见:`lock_mode X locks gap before rec insert intention waiting`。

## 10.7 自增锁(AUTO-INC Lock)

- 针对事务插入表中自增列时施加的**特殊表级锁**:一个事务插入自增数据时,另一个事务必须等待,以便获得顺序的自增值。
- `innodb_autoinc_lock_mode` 控制自增锁的使用方式(0/1/2,生产常用 2 = 交错模式提高并发)。

## 10.8 锁相关系统变量

```sql
SHOW VARIABLES LIKE 'transaction_isolation';  -- REPEATABLE-READ(默认)
SHOW VARIABLES LIKE 'autocommit';             -- ON(默认)
SHOW VARIABLES LIKE 'innodb_table_locks';     -- ON
SHOW VARIABLES LIKE 'innodb_lock_wait_timeout'; -- 50(事务等待锁超时秒数)
```
- 等待超时实验:连接1 update id>4 未提交,连接2 insert 4 等待 50 秒后报错:
`ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction`,事务回滚。

## 10.9 事务隔离级别(四种)

```sql
SET [GLOBAL | SESSION] TRANSACTION ISOLATION LEVEL {
  READ UNCOMMITTED | READ COMMITTED | REPEATABLE READ | SERIALIZABLE };
```
- 实例级通过 `--transaction-isolation` 参数设置;不同隔离级别对应的锁使用方式不同。

### ① READ UNCOMMITTED(读取未提交内容)
- 所读到的数据可能是**脏数据**(可读到别的事务未提交的修改)。
- 实验:连接1 update 未提交,连接2 直接 select 看到 'bb'(未提交的数据)。

### ② READ COMMITTED(读取提交内容,RC)
- 每次读都产生自己**最新**的快照;加锁读(select...for update / lock in share mode)和 update/delete 只在**对应行**加锁,**不加间隔锁**,因此其他事务插入**非索引行上的数值**不受影响。
- **禁用间隔锁 → 会导致幻读**。
- **使用此隔离级别必须使用行级二进制日志**(binlog_format=ROW)。
- 特点:
  - update/delete 只在**约束条件对应的行**上加锁
  - update 时若对应行已有锁,InnoDB 执行**半一致读(semi-consistent read)**确定该行上次 commit 之后的数据是否仍在锁范围内:不是则不影响 update;是则等待锁释放
- 实验:连接1(autocommit=0)update id=1 未提交,连接2(autocommit=0)select 看到旧值 'bb';连接1 commit 后,连接2 **同一事务内再次 select 能看到已提交的 'aaa'**(READ COMMITTED 每次读新快照)。

### ③ REPEATABLE READ(可重复读,RR,默认)
- 同一事务**第一次读时创建快照**,事务结束前其他不加锁读操作都获得与第一次读相同的结果。
- 加锁读(select...for update / lock in share mode)和 update/delete 时,加锁方式取决于语句是否使用唯一索引访问唯一值或范围值:
  - 唯一索引访问**唯一值** → 只在索引行施加**行锁**
  - 唯一索引访问**范围值** → 在扫描的索引行加**间隔锁或 next-key 锁**,防止其他连接对此范围插入

### ④ SERIALIZABLE(串行化)
- 更接近可重复读,只是 autocommit 被禁用时,InnoDB 将每个普通 select 语句**隐含转化为 `SELECT ... LOCK IN SHARE MODE`**。
- 实验:连接1 update 未提交,连接2 普通 select 也被锁等待;commit 后 select 正常。

### 无索引表的行锁实验(对比 RR 与 RC)
- 表 t(a NOT NULL, b)数据 (1,2),(2,3),(3,2),(4,3),(5,2),无索引 → 用隐式聚簇索引加锁。
- **RR 级别**:事务1 `UPDATE t SET b=5 WHERE b=3` 会在**所有行**加 X 锁并保留到事务结束;事务2 `UPDATE t SET b=4 WHERE b=2` 一直等待(第一行就被阻塞)。
- **RC 级别**:事务1 在**确定不修改的行上立即释放锁**(只保留 b=3 对应的行);事务2 通过半一致读判断每行最后的数据是否在修改范围内,可为未加锁行加锁并直接执行。

## 10.10 Autocommit / commit / rollback

- autocommit 开启时,每条 SQL 语句都是**独立事务**;执行成功自动 commit,报错自动 rollback。
- autocommit 开启时,可用 `START TRANSACTION` / `BEGIN` 显式开启多语句事务,以 COMMIT 或 ROLLBACK 终结。
- `SET autocommit=0` 表示当前连接禁止自动提交,事务由 commit/rollback 终结,同时意味着下一个事务开始。
- **autocommit=0 时连接退出且没执行 commit,事务自动回滚**。
- 部分语句(如 DDL、LOCK TABLES)会隐含终结事务(等同 commit)。
- commit = 永久化并对其他事务可见;rollback = 回滚;两者都会**释放当前事务持有的锁**。

## 10.11 一致读(Consistent Read,快照读)

- RR 默认下:一致读在**事务首次读时产生镜像**,首次读之前其他事务提交的修改可读到;首次读之后提交的或未提交的修改都读不到。
- 例外:**首次读之前本事务自己的未提交修改**可以读到。
- RC 级别:每次读取操作都有**自己**的镜像。
- **一致读不加任何锁**,不阻止其他事务修改。
- 典型实验:Session A 事务内 select(空集)→ Session B insert+commit → Session A 再 select 仍空集(快照不变)→ A commit 后再 select 才能看到。
- **一致读在某些 DDL 下不生效**:`DROP TABLE`(无法使用被 drop 的表)、`ALTER TABLE`;`INSERT INTO ... SELECT` / `UPDATE ... SELECT` / `CREATE TABLE ... SELECT` 在默认隔离级别下执行更类似 **READ COMMITTED**。

## 10.12 加锁读(Locking Read,当前读)

- 当在一个事务中,读操作之后还要执行 insert/update 时,普通读无法阻止其他事务修改相同数据,InnoDB 提供两种加锁读:
  - **`SELECT ... LOCK IN SHARE MODE`**:在读取的行上加共享锁;其他事务可读不可改;若有其他事务已加锁则等待。
  - **`SELECT ... FOR UPDATE`**:和 update 一样在涉及行上加排他锁,阻止其他事务的修改和加锁读,但不阻止普通(不加锁)读。
  - 锁在事务提交或回滚后释放。

### 使用场景
- 子表插入前确认父表有值(防止读与插入之间父表数据被改):
```sql
SELECT * FROM parent WHERE NAME='Jones' LOCK IN SHARE MODE;
```
- 行数计数字段的原子递增(防止两个事务读到相同值):
```sql
SELECT counter_field FROM child_codes FOR UPDATE;
UPDATE child_codes SET counter_field = counter_field + 1;
```
- 外键约束:连接1 事务内 delete 父表 id=3 未提交;连接2 普通 select 子表仍能看到关联数据(一致读),但插入子表关联 id=3 报 `ERROR 1452: Cannot add or update a child row: a foreign key constraint fails`。

## 10.13 SQL 语句对应的锁(全表锁定场景)

- **加锁读、修改、删除 SQL 语句都会在索引扫描过的每一行加锁**:不仅 where 条件限制的索引行,也对扫描到的间隔加间隔锁。
- SQL 用二级索引查找数据且施加排他锁时,InnoDB **也会在对应聚簇索引行上施加锁**。
- SQL 无任何索引可用时,MySQL 需要**全表扫描,每一行都会被加锁** → 良好习惯:为表添加合适索引。
- 各类语句加锁行为:

| 语句 | 加锁行为 |
|---|---|
| SELECT ... FROM | 一致性读,默认不加锁;SERIALIZABLE 下加共享 next-key 锁(唯一索引唯一值只加行锁) |
| SELECT ... LOCK IN SHARE MODE | 扫描索引行加共享 next-key 锁(唯一索引唯一值只加行锁) |
| SELECT ... FOR UPDATE | 扫描索引行加排他 next-key 锁(唯一索引唯一值只加行锁) |
| UPDATE | 扫描索引行加排他 next-key 锁(唯一索引唯一值只加行锁) |
| DELETE | 扫描索引行加排他 next-key 锁(唯一索引唯一值只加行锁) |
| INSERT | 在插入行上锁(非 next-key),不阻止其他事务在该行值前的间隔插入 |
| INSERT INTO T SELECT ... FROM S | 对插入到 T 的行加排他锁(非间隔锁);RR 下对访问的 S 表行加共享 next-key 锁 |
| 带外键的表 insert/update/delete | 在需要检查外键约束的行上加共享行锁 |
| LOCK TABLES | 表级锁 |

## 10.14 幻读(Phantom Read)

- 幻读:同一事务中相同读操作前后两次返回**不同的结果集**。
- 例:表 t 的 id 上有索引,`SELECT * FROM child WHERE id>100 FOR UPDATE`,表里只有 90 和 102;如果没有间隔锁锁住 90~102 之间的间隔,其他事务插入 101,第二次读就返回 3 行 → 幻读。
- InnoDB 用 **next-key 锁**(行锁 + 间隔锁合并)阻止幻读:在每个索引行之前的间隔上施加锁,**其他 session 不能在间隔内插入新索引值**。
- 间隔锁施加在索引读碰到的行上;为阻止插入任何 >100 的值,也会锁住最后扫描的索引值 102 之前的间隔。

## 10.15 InnoDB 锁性能监控

```sql
SHOW STATUS LIKE '%innodb_row_lock%';
-- Innodb_row_lock_current_waits:当前等待锁的数量
-- Innodb_row_lock_time:系统启动至今锁定总时长
-- Innodb_row_lock_time_avg:每次平均锁定时间
-- Innodb_row_lock_time_max:最长一次锁定时间
-- Innodb_row_lock_waits:系统启动至今总共锁定次数
```

## 10.16 死锁(Deadlock)

- 死锁:不同事务**相互拥有对方需要的锁**,导致互相无限等待。
- 常见场景:不同事务对多个相同表和相同行加锁,但**操作顺序不同**。
- 减少死锁:避免使用 `LOCK TABLES`;让修改数据的范围尽可能小且快;不同事务修改多表/大量数据时尽量保证**操作顺序一致**。
- **死锁自动检测默认开启**:发现死锁时,将其中一个事务(通常是**权重最小、代价小**的事务)作为牺牲品回滚。选择依据:事务 insert/update/delete 的数据行规模。
- 若语句因错误回滚,语句上的锁可能还保留(InnoDB 只存行锁信息,不存由哪个语句产生)。
- 事务中 select 调用函数,函数内语句失败只回滚该语句;整个事务结束时 rollback 才回滚整个事务。
- `innodb_deadlock_detect` 可关闭死锁检测,只用 `innodb_lock_wait_timeout` 释放锁等待(高并发场景可关,避免检测开销)。

### 经典死锁实验
```sql
-- 连接1
CREATE TABLE t (i INT) ENGINE=InnoDB;
INSERT INTO t (i) VALUES(1);
START TRANSACTION;
SELECT * FROM t WHERE i=1 LOCK IN SHARE MODE;   -- 在 i=1 上加共享锁
-- 连接2
START TRANSACTION;
DELETE FROM t WHERE i=1;                        -- 请求排他锁,被连接1阻塞
-- 连接1
DELETE FROM t WHERE i=1;                        -- 升级排他锁被连接2阻塞 → 死锁
-- ERROR 1213 (40001): Deadlock found when trying to get lock; try restarting transaction
```
- 原因:连接1 的共享锁无法升级为排他锁(连接2 已请求排他锁等待中),互相等待。

### 死锁排查与减少方法
- 查看死锁:`SHOW ENGINE INNODB STATUS`(最后一次死锁);`innodb_print_all_deadlocks=ON` 把**所有**死锁打印到错误日志。
- 减少死锁方法:
  1. 事务尽量**小型化**,缩短执行时间
  2. 及时 commit/rollback,尽快释放锁
  3. 可用**较低隔离级别**(如 RC)配合 for update / lock in share mode
  4. 访问多表/不同行集合时**保持相同顺序**(可封装进存储过程统一调用)
  5. 增加合适索引,让扫描范围足够小
  6. 尽量少用锁:能承受幻读就用普通 select 代替 select...for update
  7. 实在不行用表级锁将事务串行化:`LOCK TABLES t1 WRITE, t2 READ; ...; COMMIT; UNLOCK TABLES;`


---

# 第11课 MySQL 表分区(8.0)

## 11.1 表分区介绍

- **表分区**:将一个表的数据按照一定的规则**水平划分为不同的逻辑块**,并分别进行物理存储。这个规则叫做**分区函数**,可以有不同分区规则。
- 5.7 可通过 `show plugins` 查看是否支持分区(partition 为 ACTIVE);**8.0 移除了 show plugins 中对 partition 的显示,但社区版表分区功能默认开启**。
- 建分区表示例:
```sql
CREATE TABLE employees (
  id INT NOT NULL, fname VARCHAR(30), lname VARCHAR(30),
  hired DATE NOT NULL DEFAULT '1970-01-01',
  separated DATE NOT NULL DEFAULT '9999-12-31',
  job_code INT NOT NULL, store_id INT NOT NULL)
PARTITION BY RANGE (store_id)
( PARTITION p0 VALUES LESS THAN (6), PARTITION p1 VALUES LESS THAN (11),
  PARTITION p2 VALUES LESS THAN (16), PARTITION p3 VALUES LESS THAN (21) );
-- 数据按 store_id 范围落到不同分区
SELECT * FROM employees PARTITION (p0);   -- 只查 p0 分区
```

### 分区表关键限制
- **当表中含有主键或唯一键时,每个被用作分区函数的字段必须是表中唯一键和主键的全部或一部分**,否则无法创建分区表:
```sql
CREATE TABLE tnp (
  id INT NOT NULL AUTO_INCREMENT, ref BIGINT NOT NULL, name VARCHAR(255),
  PRIMARY KEY pk (id), UNIQUE KEY uk (ref))
PARTITION BY RANGE (id) ( PARTITION p0 VALUES LESS THAN (6), PARTITION p1 VALUES LESS THAN (11));
-- ERROR 1503: A UNIQUE INDEX must include all columns in the table's partitioning function
-- 解决办法:① 去掉唯一键 ② 把主键扩展为包含分区函数字段
CREATE TABLE tnp (id INT NOT NULL , ref BIGINT NOT NULL, name VARCHAR(255),
  PRIMARY KEY pk (id,ref), UNIQUE KEY uk (ref))
PARTITION BY RANGE (ref) (...);  -- OK
```

### 表分区的主要优势
1. **一个表里存储更多的数据**,突破磁盘/文件系统限制(总大小上限 = 各分区磁盘之和)
2. **移除历史/过期数据很容易**:直接 drop 对应分区即可(比 delete 快)
3. 对某些查询/修改语句自动将**数据范围缩小到一或几个分区**(分区修剪),优化执行效率;也可**显示指定分区**执行语句:`SELECT * FROM t PARTITION (p0,p1) WHERE c < 5;`
- 物理文件:每个分区独立 `.ibd`,如 `employees#P#p0.ibd`、`tnp#P#p1.ibd`。

## 11.2 分区类型总览

| 类型 | 说明 |
|---|---|
| RANGE 表分区 | 按一定**范围值**确定每个分区包含的数据 |
| LIST 表分区 | 按一个一个**确定的值**确定每个分区包含的数据 |
| HASH 表分区 | 按自定义**函数返回值**确定每个分区包含的数据 |
| KEY 表分区 | 与 HASH 类似,但用 **MySQL 自己的 HASH 函数** |

## 11.3 RANGE 分区

- 分区函数使用的字段**必须只能是整数类型**;分区范围必须连续且不能重叠;通过 `VALUES LESS THAN` 定义,范围**从小到大**定义。
- `store_id<6` → p0;`6<=store_id<11` → p1;以此类推。数据 21 无分区容纳会报错:
```sql
INSERT INTO employees VALUES(4,'d','d',now(),now(),1,21);
-- ERROR 1526: Table has no partition for value 21
```
- 范围定义**必须严格递增**,否则报 `ERROR 1493: VALUES LESS THAN value must be strictly increasing for each partition`;字段不是整数报 `ERROR 1697: VALUES value for partition 'p0' must have type INT`。
- **MAXVALUE 关键词**表示可能的最大值:`PARTITION p3 VALUES LESS THAN MAXVALUE`,任何 >=16 的数据都进 p3。
- 分区函数可用表达式:`PARTITION BY RANGE ( YEAR(separated) )`。
- **对 timestamp 字段,可用的表达式仅有 `UNIX_TIMESTAMP()`**,其他都会报 `ERROR 1486`(如 `YEAR(tstamp)` 对 timestamp 报错,对 datetime 可以)。

## 11.4 LIST 分区

- `PARTITION BY LIST(expr)`,表达式必须返回**整数**,取值通过 `VALUES IN (value_list)` 定义。
- **没有 MAXVALUE 特殊值**:所有可能取值都要在 VALUES IN 中包含,没定义的值插入报错:
```sql
INSERT INTO h2 VALUES (3, 5);
-- ERROR 1525: Table has no partition for value 3
```
- 主键/唯一键存在时,分区函数字段同样必须包含在主键/唯一键中(报 ERROR 1503)。

## 11.5 多字段分区(RANGE COLUMNS / LIST COLUMNS)

- 对 range/list 分区,**分区函数可以包含多个字段**(COLUMNS 分区)。
- 支持字段类型:**TINYINT / SMALLINT / MEDIUMINT / INT / BIGINT、DATE / DATETIME、CHAR / VARCHAR / BINARY / VARBINARY**,其他不支持。
- 与普通范围分区的区别:
  - a) 字段类型多样化(非整数也可)
  - b) **不支持表达式,只能直接用字段名**
  - c) 支持一个或多个字段
- column_list 里字段与 value_list 里数值**一一对应,数据类型一致**。
- 行数据比较是**逐列比较**:`(a,b) < (5,12)` 先比 a 再比 b;第一列等于边界值时看第二列决定归属。
```sql
CREATE TABLE rcx (a INT, b INT, c CHAR(3), d INT)
PARTITION BY RANGE COLUMNS(a,b,c)
(PARTITION p0 VALUES LESS THAN (5,10,'ggg'),
 PARTITION p1 VALUES LESS THAN (10,20,'mmm'),
 PARTITION p2 VALUES LESS THAN (15,30,'sss'),
 PARTITION p3 VALUES LESS THAN (MAXVALUE,MAXVALUE,MAXVALUE));

CREATE TABLE customers_1 (...)
PARTITION BY LIST COLUMNS(city)
( PARTITION pRegion_1 VALUES IN('Oskarshamn', 'Högsby', 'Mönsterås'), ... );
-- 取值范围必须按字典序递增,否则报 ERROR 1493
```

## 11.6 HASH 分区

- `PARTITION BY HASH (expr)`,expr 必须返回整数,**基于分区个数取模(%)运算**,根据余数插入指定分区;只需定义分区个数,其他内部完成。
- 没写 `PARTITIONS n` 默认 1。
- 数据分配验证:store_id 1~5、PARTITIONS 4 → p0 存 4,p1 存 1 和 5,p2 存 2,p3 存 3(即 MOD(store_id,4))。
- 表达式可以是字段或函数:`PARTITION BY HASH( YEAR(hired) ) PARTITIONS 4;` 数据分区计算:`MOD(YEAR('2005-09-15'),4) = MOD(2005,4) = 1`。

## 11.7 KEY 分区

- 与 HASH 类似,但**哈希算法依赖 MySQL 本身**。
- `PARTITION BY KEY()` 括号里可 0 或多个字段,字段必须是主键或主键一部分;括号空 = 用主键。
- 无主键但**有唯一键**时用唯一键,但**唯一键字段必须 NOT NULL**,否则报 `ERROR 1488: Field in list of fields for partition function not found in table`。
- 字段**不必是整数**(可 CHAR 等):`PARTITION BY KEY(s1)`。

## 11.8 子分区(SUBPARTITION)

- 在表分区基础上再分区;**每个分区下的子分区个数必须一致**。
- **子分区必须是 RANGE/LIST + HASH/KEY 的组合**:
```sql
CREATE TABLE ts (id INT, purchased DATE)
PARTITION BY RANGE( YEAR(purchased) )
SUBPARTITION BY HASH( TO_DAYS(purchased) )
SUBPARTITIONS 2
( PARTITION p0 VALUES LESS THAN (1990),
  PARTITION p1 VALUES LESS THAN (2000),
  PARTITION p2 VALUES LESS THAN MAXVALUE );
-- 3 个范围分区 × 2 个子分区 = 6 个分区
-- 也可显式命名子分区:
PARTITION p0 VALUES LESS THAN (1990) ( SUBPARTITION s0, SUBPARTITION s1 ), ...
```

## 11.9 分区对 NULL 值的处理

- **RANGE 分区**:NULL 值放到**最小的分区**里(即使第一个分区是 `VALUES LESS THAN (0)` 也进 p0)。
- **LIST 分区**:某个分区的允许值中包含 NULL 才能插入 NULL,否则报 `ERROR 1504: Table has no partition for value NULL`。
- **HASH 和 KEY 分区**:NULL 值**当成 0 值对待**(与 0 进同一分区)。

## 11.10 分区管理(ALTER TABLE)

### RANGE/LIST 分区:增删分区
```sql
-- 删除分区(连带删除分区内所有数据!)
ALTER TABLE tr DROP PARTITION p2;

-- 增加分区:范围分区必须在尾部加,否则报 ERROR 1463
ALTER TABLE members ADD PARTITION (PARTITION p3 VALUES LESS THAN (2010));
-- 头部/中间加 → 用 REORGANIZE 拆分
ALTER TABLE members REORGANIZE PARTITION p0 INTO
  ( PARTITION n0 VALUES LESS THAN (1970), PARTITION n1 VALUES LESS THAN (1980) );
-- LIST 分区:新值不在已有分区即可 add partition
ALTER TABLE tt ADD PARTITION (PARTITION p2 VALUES IN (7, 14, 21));
```

### REORGANIZE 合并/重组分区
```sql
-- 范围分区重组,合并后边界必须与原范围一致(除最后一个分区可扩展),否则报 ERROR 1520
ALTER TABLE members REORGANIZE PARTITION n0,n1 INTO ( PARTITION p0 VALUES LESS THAN (1980) );
-- 多个重组为多个
ALTER TABLE members REORGANIZE PARTITION p0,p1,p2,p3 INTO
  ( PARTITION m0 VALUES LESS THAN (1980), PARTITION m1 VALUES LESS THAN (2020) );
-- LIST 分区:重组的分区必须是相邻分区(ERROR 1519),且已有的数据必须在新分区值中,否则数据丢失
ALTER TABLE tt REORGANIZE PARTITION p0,p1 INTO ( PARTITION p0 VALUES IN (6, 18), PARTITION p1 VALUES in (5,15));
```

### HASH/KEY 分区:只能合并/增加个数
```sql
-- COALESCE PARTITION n:合并,数字 n 代表"缩减的个数"(12→8 写 4)
ALTER TABLE clients COALESCE PARTITION 4;
-- ADD PARTITION PARTITIONS n:增加分区
ALTER TABLE clients ADD PARTITION PARTITIONS 6;
```

### EXCHANGE PARTITION(分区与普通表交换数据)
- 将分区/子分区的数据与普通表**相互交换**,分区表结构不变。
- **前提**:普通表结构与分区表**完全相同**(字段、类型、索引、存储引擎完全一样),否则 `ERROR 1736: Tables have different definitions`。
- 普通表有数据时,数据必须符合分区条件,否则 `ERROR 1707: Found row that does not match the partition`;可用 `WITHOUT VALIDATION` 跳过验证。
- **子分区表只能 exchange 单个子分区,不能整个分区**(`ERROR 1704: Subpartitioned table, use subpartition instead of partition`)。
```sql
CREATE TABLE e2 LIKE e;
ALTER TABLE e2 REMOVE PARTITIONING;               -- 普通表去掉分区
ALTER TABLE e EXCHANGE PARTITION p0 WITH TABLE e2; -- 交换
```

### 分区维护命令
```sql
ALTER TABLE t1 REBUILD PARTITION p0, p1;         -- 重建分区(相当于删数据重插,去碎片)
ALTER TABLE t1 OPTIMIZE PARTITION p0, p1;        -- 回收未用空间+重新收集统计信息
ALTER TABLE t1 ANALYZE PARTITION p3;             -- 重新收集分区统计信息
ALTER TABLE t1 REPAIR PARTITION p0,p1;           -- 修复异常分区
ALTER TABLE t1 CHECK PARTITION p1;               -- 检查分区数据/索引是否损坏
ALTER TABLE t1 TRUNCATE PARTITION p0;            -- 删除分区内所有数据
```

### 查看分区信息
```sql
SHOW CREATE TABLE e;                        -- 查看分区定义
SHOW TABLE STATUS LIKE 'e';                 -- Create_options 列显示 partitioned
SELECT * FROM information_schema.partitions WHERE table_name='e';  -- 最详细
```

## 11.11 分区修剪(Partition Pruning)

- 核心:**只扫描需要的分区**,自动进行。
- `explain` 可看到 `partitions` 列只列出需要的分区:
```sql
EXPLAIN SELECT ... FROM t1 WHERE region_code > 125 AND region_code < 130;
-- partitions 列: p1,p2
```
- 不只 select,**update/delete 也能使用分区修剪**。

## 11.12 分区选择(Partition Selection)

- 与修剪类似,但修剪是自动,分区选择是**显示指定分区范围**;支持 select/update/insert/delete。
```sql
SELECT * FROM employees PARTITION (p1);
SELECT * FROM employees PARTITION (p0, p2) WHERE lname LIKE 'S%';
DELETE FROM employees PARTITION (p0, p1) WHERE fname LIKE 'j%';
UPDATE employees PARTITION (p0) SET store_id = 2 WHERE fname = 'Jill';
-- INSERT 指定分区时,插入值必须符合该分区范围,否则:
INSERT INTO employees PARTITION (p2) VALUES (20, 'Jan', 'Jones', 1, 3);
-- ERROR 1729: Found a row not matching the given partition set
```

## 11.13 分区函数可用函数清单

`ABS() CEILING() DAY() DAYOFMONTH() DAYOFWEEK() DAYOFYEAR() DATEDIFF() EXTRACT() FLOOR() HOUR() MICROSECOND() MINUTE() MOD() MONTH() QUARTER() SECOND() TIME_TO_SEC() TO_DAYS() TO_SECONDS() UNIX_TIMESTAMP() WEEKDAY() YEAR() YEARWEEK()`


---

# 第12课 MySQL 复制(主从同步)

## 12.1 复制介绍

- MySQL 复制允许将**主实例(master)的数据同步到一个或多个从实例(slave)**,默认情况下复制是**异步**的,从库不需要一直连着主库。
- 数据粒度:所有数据库 / 指定一个或多个数据库 / 一个库里的指定表。
- **复制带来的优势**:
  | 优势 | 说明 |
  |---|---|
  | 扩展能力 | 所有写操作在 Master,读操作分到多个 slave,读写分离提升性能 |
  | 数据库备份 | 备份作业部署到从库,不影响主库性能 |
  | 数据分析和报表 | 在从实例执行,减少对主库的性能影响 |
  | 容灾能力 | 异地数据中心建 slave,主库所在地遇灾可快速恢复 |

## 12.2 复制方法 / 类型 / 格式

### 两种复制方法
- **传统方式(基于 binlog)**:基于主库 binlog 的日志事件和事件位置复制到从库,从库再应用。
- **GTID 方式(全局事务标识)**:基于**事务**复制,不依赖日志文件位置,更好地保证主从数据一致性。

### 四种复制类型
| 类型 | 说明 |
|---|---|
| 异步复制 | 一主一从/一主多从,数据异步同步 |
| 同步复制 | MySQL Cluster 特有 |
| 半同步复制 | 事务提交前**至少有一个从库已收到该事务并写入日志** |
| 延迟复制 | 人为设定主从同步延迟时间(至少延迟 N 秒) |

### 三种复制核心格式(binlog_format)
| 格式 | 说明 |
|---|---|
| statement(语句) | 将 SQL 语句写入 binlog |
| row(行) | 将每行数据变化作为事件写入 binlog(5.7.7 起默认) |
| mixed(混合) | 默认优先 statement,部分语句 statement 不安全时自动切 row |

## 12.3 基于 binlog 的复制(传统方式全流程)

### ① 前提准备
- 主库和每个从库必须有**唯一 ID:server-id**(正整数,范围 1~(2³²−1),同复制组不能重复)。
- **MySQL 8.0 中 binlog 默认开启**,`server_id` 默认为 1:
```sql
SHOW VARIABLES LIKE '%log_bin%';     -- log_bin ON, log_bin_basename /usr/local/mysql/data/binlog
SHOW VARIABLES LIKE '%server_id%';   -- 1
```
- 确保主库 `skip_networking` **非开启**,否则主从无法通信,复制失败。

### ② 主库创建复制专用用户
```sql
CREATE USER 'repl'@'192.168.237.%' IDENTIFIED BY 'mysql';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'192.168.237.%';
```
- 只用复制权限的独立用户(用户名密码会明文存在从库 master.info 文件,安全考虑)。

### ③ 获取主库日志信息(先锁表保证一致)
```sql
FLUSH TABLES WITH READ LOCK;       -- 主库所有表加读锁,停止修改
SHOW MASTER STATUS;                -- file=当前日志名, position=日志内位置
```
- 锁表期间执行 DDL/DML 会报 `ERROR 1223: Can't execute the query because you have a conflicting read lock`。

### ④ 主库数据生成镜像并传到从库(两种方式)
- **mysqldump 方式**(InnoDB 推荐):
```bash
bin/mysqldump --all-databases --master-data=2 --single-transaction -u root -p -P 3308 > dbdump.db
```
  - `--master-data=2`:导出文件直接带上 change master to 参数(注释形式)
  - `--single-transaction`:InnoDB 一致性快照,不锁表
- **文件拷贝方式**:临时关主库 → 打包 data 目录 → 拷贝到从库(sftp/scp)。效率高(省去 insert 更新索引),但 InnoDB 不推荐。
```bash
mysql> UNLOCK TABLES;    # 主库释放锁
```

### ⑤ 从库配置 server-id 并应用镜像
```ini
[mysqld]
server-id=2
```
- 从库 binlog 可开可不开(级联复制才必须开)。应用镜像:mysqldump 用 `source dbdump.db`;文件拷贝直接放同目录。

### ⑥ 从库指定主库信息
```sql
CHANGE MASTER TO
  MASTER_HOST='192.168.237.128',
  MASTER_PORT=3308,
  MASTER_USER='repl',
  MASTER_PASSWORD='mysql',
  MASTER_LOG_FILE='mysql-bin.000001',
  MASTER_LOG_POS=801;
START SLAVE;
```

### ⑦ 验证复制
```sql
SHOW SLAVE STATUS\G
-- Slave_IO_Running: Yes  Slave_SQL_Running: Yes  Seconds_Behind_Master: 0
```
- 最终验证:主库插入数据,从库能查到。

### 排错两个常见报错
| 报错 | 原因/解决 |
|---|---|
| `Last_IO_Errno: 1593` master and slave have equal MySQL server UUIDs | 主从 UUID 相同:删除从库 `auto.cnf`,重启生成新 UUID |
| `Last_IO_Errno: 2003` error connecting to master | 连接失败:检查防火墙、用户密码、端口 |

### 排错:备份前没有 lock 全表导致的数据复制异常(重点)
- **场景**:主库执行存储过程**循环插入 2 万行**期间,直接开始 `mysqldump` 并用该备份建立从库 → 备份内容**不是一致性快照**(dump 过程中数据还在变),导致**从库数据与主库不一致**。
- **教训**:建立从库的备份必须一致性:
  - 方式一(MyISAM 等):先 `FLUSH TABLES WITH READ LOCK` 锁全表,再 `SHOW MASTER STATUS` 取位点,再 dump,最后 `UNLOCK TABLES`;
  - 方式二(InnoDB 推荐):`mysqldump --single-transaction --master-data=2`(一致快照,见第 16 课);
  - 绝不能在**有写操作(尤其大批量写入)进行中**做裸备份建从库。

## 12.4 多 slave 环境

- 创建第一个 slave 后,再建其他 slave:① 分配新 server-id ② 应用之前备份镜像 ③ 相同 change master ④ start slave。
- **备份文件丢失或主库日志被清除时**,用已有从库复制出新从库:
  ```bash
  mysqladmin shutdown                          # 关闭现有从库
  tar -zcvf data.tar.gz data
  sftp 复制到新从库; tar -zxvf
  rm -rf data/auto.cnf                          # 删 UUID 文件
  ```
  ① 新从库分配唯一 server-id ② 启动 slave 进程(relay-log 若含主机名要调 relay-log-index 参数)。

## 12.5 复制相关系统变量

| 变量 | 说明 |
|---|---|
| server_id | 主从唯一标识(1~4294967295) |
| server_uuid | GTID 用;启动时从数据目录 `auto.cnf` 读取,无则自动生成 |
| log_slave_updates | 是否把从主库收到的更新也记到从库 binlog;**级联复制 A→B→C 必须开启**(还要开 log-bin) |
| relay-log | 指定 relay log 基础名,默认 `host_name-relay-bin.xxxx` |
| replicate-do-db | 只复制指定库(多库用多次);**statement 环境跨库操作会丢复制**;row 环境按数据库对象判断 |
| replicate-ignore-db | 忽略指定库的复制 |
| replicate-do-table=db.tbl | 仅复制指定表 |
| replicate-ignore-table=db.tbl | 过滤指定表 |
| replicate-wild-do-table=db.tbl | 通配符匹配表,支持 `_` `%`(`foo%.bar%`);`foo%.%` 也复制 create/drop/alter database foo 开头命令 |
| replicate-wild-ignore-table | 通配符过滤表 |
| slave_parallel_workers | 从库并行 SQL 线程数,默认 0(不允许),0~1024 |
| slave-parallel-type | database(按库并行,默认)/ LOGICAL_CLOCK(按 binlog 一组提交事务并行) |
| skip-slave-start | 启动时先不启动 slave 线程(暂停复制) |
| slave-skip-errors=[code1,code2,...\|all\|ddl_exist_errors] | 忽略指定复制错误继续;谨慎使用,否则数据不一致 |
| sql_slave_skip_counter | 非 GTID 环境跳过 N 个复制事件;设置后需 start slave 生效 |
| log-bin[=base_name] | 是否开启 binlog;默认 host_name-bin.xxxx |
| binlog-do-db / binlog-ignore-db | 决定哪些库的修改记入 binlog(与 replicate-do-db 行为类似) |
| binlog_format | statement/row/mixed;5.7.7 之前默认 statement,之后默认 row |

### replicate-do-db 的 statement 与 row 差异(重点)
- **statement 环境**:`replicate-do-db=sales` 时,`USE prices; UPDATE sales.january SET ...` **不会**复制(按当前库判断)。
- **row 环境**:只要操作对象属于指定库就复制;`USE sales; UPDATE prices.march ...` 不复制。
- 跨库 update:`USE db1; UPDATE db1.t1, db2.t2 ...` —— statement 会改两个表,row 只改 db1 表;需要跨库都生效用 `replicate-do-table`。

### 复制一致性实验(重点)
- **statement 环境**:主从数据不一致时复制还能继续(delete from temp limit 1 在主从删掉不同行,但复制不报错)。
- **row 环境**:主从数据不一致时(主库删除从库不存在的数据),复制报错 `Last_SQL_Errno: 1032`(找不到要删的行);手工在从库补上数据后复制恢复。

## 12.6 复制涉及的三线程

| 线程 | 位置 | 职责 |
|---|---|---|
| binlog dump thread | 主库 | 从库连接过来时发送 binlog 内容 |
| slave I/O thread | 从库 | 连接主库请求 binlog,把内容复制到本地 relay log |
| slave SQL thread | 从库 | 读取 relay log 并在本地执行事件 |

- `SHOW PROCESSLIST`:主库 `Command: Binlog Dump / State: Has sent all binlog to slave`;从库 `system user` 两个连接线程。
- 暂停/启动:
```sql
STOP SLAVE;                    START SLAVE;
STOP SLAVE IO_THREAD;          START SLAVE IO_THREAD;
STOP SLAVE SQL_THREAD;         START SLAVE SQL_THREAD;
```

## 12.7 SHOW SLAVE STATUS 关键字段

| 字段 | 含义 |
|---|---|
| Slave_IO_State | 当前 slave 状态 |
| Slave_IO_Running / Slave_SQL_Running | IO/SQL 线程是否运行,正常都 YES |
| Last_IO_Error / Last_SQL_Error | 最后一次 IO/SQL 线程错误,正常为空 |
| Seconds_Behind_Master | SQL 线程比主库 binlog 晚的秒数,0 = 无延迟 |
| Master_Log_File, Read_Master_Log_Pos | IO 线程在主库 binlog 的坐标 |
| Relay_Master_Log_File, Exec_Master_Log_Pos | SQL 线程在主库 binlog 的坐标 |
| Relay_Log_File, Relay_Log_Pos | SQL 线程在从库 relay log 的坐标 |

## 12.8 复制格式对比(mysqlbinlog 查看)

### statement 格式内容
```bash
bin/mysqlbinlog data/mysql-bin.000002
```
包含:`BEGIN`、`use course`、`insert into temp values('a','abc')`、`Xid=55 COMMIT` 等完整 SQL。

### row 格式内容
```bash
bin/mysqlbinlog -v data/mysql-bin.000003
```
包含:`Table_map: course.temp`、`Write_rows: table id 141`、`### INSERT INTO course.temp ### SET @1='b' @2='bcd'`(行级内容)。

### 对比结论
| 对比项 | statement | row |
|---|---|---|
| 优势 | 成熟、省空间(批量修改)、binlog 可做审计 | 所有修改都能复制(安全)、从库执行锁更少 |
| 劣势 | 不确定语句(rand()/sysdate()/limit 无 order by 等)复制异常并告警 | DML 批量修改时 binlog 很大,易延迟;不能直接看到 SQL;建议仅 InnoDB(MyISAM 行复制可能异常) |

## 12.9 复制使用场景(实战)

### 在从库做备份
- 小库:先 `STOP SLAVE SQL_THREAD` 再 `mysqldump --all-databases > fulldb.dump`,完成后 `START SLAVE`。
- 大库:物理拷贝,需 `mysqladmin shutdown` 关从库再 tar data 目录。

### 主从不同存储引擎
- 目的:主库 InnoDB(事务),从库 MyISAM(只读更快)。
- mysqldump 建从库:应用 dump 前修改文件里引擎;文件拷贝建从库:启动后 `STOP SLAVE; ALTER TABLE t ENGINE='myisam'; START SLAVE;`。

### 负载均衡水平扩展
- 把读压力分担到多个 slave(读多写少环境),应用层读写分离。

### 不同库复制到不同 slave
- slave1 配 `replicate-wild-do-table=databaseA.%`,slave2 配 databaseB.%,slave3 配 databaseC.%。每个 slave 收到完整 binlog,应用时过滤。

## 12.10 延迟复制(误操作救援神器)

- 从库对主库的延迟**至少是 N 秒**:`CHANGE MASTER TO MASTER_DELAY = N;`(N 默认 0)。
- 原理:从库收到 binlog 后**等指定秒数再执行**。
- 场景:① 主库被错误修改的数据能及时找回 ② 测试从库 IO 集中恢复 binlog 时对应用的影响 ③ 保留若干天前的数据库状态做对比。
- 状态:`SHOW SLAVE STATUS` 中 `SQL_Delay`(设置的延迟)、`SQL_Remaining_Delay`(剩余延迟)、`Slave_SQL_Running_State: Waiting until MASTER_DELAY seconds`。

## 12.11 主从切换

- GTID 复制可用 mysqlfailover 工具监控和自动切换;非 GTID 需其他方式。
- 新 master 产生后,其他 slave 执行 change master to 指向新 master(slave 不校验数据是否一致,直接取新 master 的 binlog 继续复制)。
- **新 master 必须运行在 log_bin 模式下**:
```sql
-- 新 master: log-bin=mysql-bin
-- 新 master: SHOW MASTER STATUS; 获取 file/position
-- 其他 slave:
STOP SLAVE;
RESET SLAVE ALL;
CHANGE MASTER TO MASTER_HOST='192.168.237.130', MASTER_PORT=3308,
  MASTER_USER='repl', MASTER_PASSWORD='mysql',
  MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=154;
START SLAVE;
```

## 12.12 半同步复制(5.7+)

- 异步复制主库不知道从库是否拿到事件,**主库崩溃切换时从库可能不是最新**。
- 半同步:**主库事务提交被阻止,直到至少一个半同步 slave 确认收到**;slave 只有在事件**记录到本地 relay log 之后**才发确认。
- 无 slave 确认**超时**时,半同步自动转**异步**;半同步牺牲性能换可靠性。
- `rpl_semi_sync_master_wait_point` 控制行为:`AFTER_SYNC`(默认)/ `AFTER_COMMIT`。
- 配置参数:`rpl_semi_sync_master_enabled`(主库开启)、`rpl_semi_sync_master_timeout`(默认 10000 毫秒超时转异步)、`rpl_semi_sync_slave_enabled`(从库开启)。

### 配置步骤(插件方式)
```sql
-- 前提:5.5+, have_dynamic_loading=YES, 已建好异步复制
-- 主库安装插件:
INSTALL PLUGIN rpl_semi_sync_master SONAME 'semisync_master.so';
-- 每个从库安装插件:
INSTALL PLUGIN rpl_semi_sync_slave SONAME 'semisync_slave.so';
-- 查看插件:
SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME LIKE '%semi%';
-- 主库开启:
SET GLOBAL rpl_semi_sync_master_enabled = 1;
SET GLOBAL rpl_semi_sync_master_timeout = 10000;
-- 从库开启:
SET GLOBAL rpl_semi_sync_slave_enabled = 1;
-- 从库重启 slave 进程:
STOP SLAVE; START SLAVE;
```

### 监控参数
```sql
SHOW STATUS LIKE 'rpl_semi_sync%';
-- Rpl_semi_sync_master_clients: 半同步 slave 个数
-- Rpl_semi_sync_master_status: 1=主库半同步正常;0=关闭或已转异步
-- Rpl_semi_sync_master_no_tx / yes_tx: 未收到/收到确认的提交数
-- Rpl_semi_sync_slave_status: 1=从库半同步正常
```
- 实验:关掉从库 IO 线程,主库 update 要等 10 秒超时,从库 `Rpl_semi_sync_slave_status` 变 OFF;恢复后变 ON。**只要有一个从库正常,主库插入立即返回**;全部从库都断了才等待超时。

## 12.13 基于 GTID 的复制(8.0 主流)

- **GTID(Global Transaction Identifiers)**:每个在主库执行的事务分配一个全局唯一 ID 并记录在从库。
- 格式:`GTID = source_id:transaction_id`(source_id = 主库 server_uuid;transaction_id = 按顺序提交的编号)。
- 优势:完全不需要找 binlog 文件和位置即可建立/切换复制,简化运维。

### GTID 复制原理
1. 主库事务提交 → 赋予 GTID → 记录主库 binary log
2. binlog 传到从库 relay log,从库读取 GTID 生成 `gtid_next`
3. 从库验证该 GTID 未在自己的 binlog 用过 → 应用事务

- 5.6:slave 必须开 binlog 和 log_slave_updates;5.7 起用系统表 `mysql.gtid_executed` 记录,不必开 log_slave_updates,减少从库压力。
```sql
SHOW MASTER STATUS;      -- Executed_Gtid_Set: 9eae8f34-...-1-25
SELECT * FROM mysql.gtid_executed;   -- source_uuid / interval_start / interval_end
```

### 传统复制转 GTID 步骤
```sql
-- ① 主从都 read only
SET @@global.read_only = ON;
-- ② 关闭主从
mysqladmin shutdown
-- ③ my.cnf 配置(从库先暂停 slave)
[mysqld]
gtid-mode=on
enforce-gtid-consistency=on
skip-slave-start=1
-- ④ 重新设置复制关系
CHANGE MASTER TO
  MASTER_HOST=..., MASTER_PORT=..., MASTER_USER=..., MASTER_PASSWORD=...,
  MASTER_AUTO_POSITION = 1;
START SLAVE;
-- ⑤ 关闭 read only
SET @@global.read_only = OFF;
```

### GTID 复制限制(面试重点)
1. **一个事务内不能混用 InnoDB 和 MyISAM(非事务表)**:可能产生多个 GTID;主从引擎不一致也异常。
2. **不支持 `CREATE TABLE ... SELECT`**(基于语句复制不安全;基于行复制拆成两个事件可能分配相同 GTID 导致 insert 被忽略):`ERROR 1786: Statement violates GTID consistency: CREATE TABLE ... SELECT.`
3. **create/drop temporary table 不能在事务中执行**,只能单独执行且 autocommit 开启。
4. **不支持 sql_slave_skip_counter**,跳过事务用 `gtid_executed` 变量。
5. 事务内对非事务表的修改:只能 autocommit 或单语句事务:`ERROR 1785: Updates to non-transactional tables can only be done in either autocommitted statements ... or single-statement transactions`。

## 12.14 MySQL 8.0 复制术语变化(8.0.22+)

**一句话本质:8.0 把带有奴隶制色彩的术语改名了,命令名/字段名全变,老脚本会报"Unknown"错误,升级必查。**

| 5.7 旧写法 | 8.0.22+ 新写法 |
|---|---|
| `SHOW SLAVE STATUS` | `SHOW REPLICA STATUS` |
| `START SLAVE` / `STOP SLAVE` | `START REPLICA` / `STOP REPLICA` |
| `RESET SLAVE` | `RESET REPLICA` |
| `CHANGE MASTER TO` | `CHANGE REPLICATION SOURCE TO` |
| `MASTER_HOST / MASTER_PORT / MASTER_USER / MASTER_PASSWORD` | `SOURCE_HOST / SOURCE_PORT / SOURCE_USER / SOURCE_PASSWORD` |
| `MASTER_LOG_FILE / MASTER_LOG_POS` | `SOURCE_LOG_FILE / SOURCE_LOG_POS` |
| `MASTER_AUTO_POSITION` | `SOURCE_AUTO_POSITION` |
| 字段 `Slave_IO_Running / Slave_SQL_Running` | 仍是旧字段名(别名保留),8.0 同时提供 `Replica_IO_Running` 等 |

> 8.0.21 及之前旧名仍可用(告警),8.0.22 起新名为主;**老脚本/监控直接兼容性报错**,生产巡检脚本要按 8.0 写法更新。

## 12.15 Clone 插件快速搭从库(8.0.17+)

**一句话本质:以前搭从库要 mysqldump 导数据再灌进去,几小时;8.0 Clone 直接"物理复制"数据目录,分钟级完成,且主库无锁无压力。**

```sql
-- ① 主库准备(插件 8.0.17+ 内置)
INSTALL PLUGIN clone SONAME 'mysql_clone.so';
CREATE USER 'clone_user'@'%' IDENTIFIED BY 'Clone@123';
GRANT BACKUP_ADMIN ON *.* TO 'clone_user'@'%';

-- ② 从库(新装空实例,datadir 必须为空)执行克隆
CLONE INSTANCE FROM 'clone_user'@'10.0.0.1:3306' IDENTIFIED BY 'Clone@123';
-- 成功后从库自动重启,数据与主库完全一致

-- ③ 配置并启动复制(8.0 新语法)
CHANGE REPLICATION SOURCE TO
  SOURCE_HOST='10.0.0.1', SOURCE_PORT=3306,
  SOURCE_USER='repl', SOURCE_PASSWORD='Repl@123',
  SOURCE_AUTO_POSITION=1;
START REPLICA;
SHOW REPLICA STATUS\G
```

> Clone 优点:比逻辑备份快得多、主库只读不锁表、自动携带 GTID;缺点:要求源/目标同大版本、目标数据目录必须为空、克隆期间目标库不可用。**生产新增从库/扩容,首选 Clone。** 详细见第 22 课 22.3。


---

# 第13课 MySQL 高可用架构之 Mycat(分库分表中间件)

## 13.1 Mycat 是什么

- Mycat 背后是阿里曾开源的知名产品 **Cobar**(关系型数据分布式处理系统)。
- **本质**:一个开源的分布式数据库系统,**实现了 MySQL 协议的 Server(数据库代理)**。
  - 前端:用户把它看作一个数据库代理,用 MySQL 客户端工具/命令行访问(端口 8066)。
  - 后端:用 MySQL 原生(Native)协议与多个 MySQL 服务器通信,也可用 JDBC 协议连大多数主流数据库。
  - **核心功能:分表分库**——将一个大表水平分割为 N 个小表,存储在后端多个 MySQL 服务器里。

### 功能特性(面试常考)
| 特性 | 说明 |
|---|---|
| SQL 92 标准 | 支持标准 SQL |
| Proxy 模式 | 支持 MySQL 集群,可作 Proxy 使用 |
| 多数据库 | 支持 JDBC 连 MySQL/mongodb/oracle/sqlserver/hive/db2/postgresql |
| 高可用分片集群 | 支持 galera for mysql、percona-cluster、mariadb cluster |
| 故障切换 | 自动故障切换,高可用 |
| 读写分离 | 支持 MySQL 双主多从、一主多从 |
| 全局表 | 数据自动分片到多个节点,用于高效表关联查询 |
| ER 分片 | 基于 E-R 关系的分片策略,高效表关联查询 |
| 一致性 Hash | 有效解决分片扩容难题 |
| 跨平台 | 部署实施简单 |
| Catlet 开发 | 类似数据库存储过程,跨分片复杂 SQL 的编码实现 |
| NIO/AIO | Windows 建议 AIO,Linux 建议 NIO |
| 其他 | 支持存储过程调用、SQL 拦截与改写(插件)、自增长主键、Oracle 的 Sequence 机制 |

### Mycat 原理:一个核心动词 —— "拦截"
1. 拦截用户发来的 SQL;
2. 对 SQL 做特定分析:**分片分析、路由分析、读写分离分析、缓存分析**等;
3. 把 SQL 发往后端的真实数据库;
4. 对返回结果做适当处理,最终返回给用户。

### 分片过程举例
- Orders 表分为 3 个分片 **datanode(dn)**,分布 2 台 MySQL Server(dataHost),即 `datanode = database @ datahost`。
- 分片规则 = **分片字段(sharding column) + 分片函数(rule function)**,例:分片字段 `prov`、函数为字符串枚举。
- 收到 `select * from Orders where prov=?` → 解析 SQL 找到表 → 看分片规则 → 取分片字段值 `prov=wuhan` → 匹配分片函数 → wuhan 返回 dn1 → SQL 发给 MySQL1 → 收集结果返回客户端。

## 13.2 Mycat 应用场景

| 场景 | 说明 |
|---|---|
| 单纯的读写分离 | 配置最简单,支持读写分离、主从切换 |
| 分表分库 | 超过 1000 万的表进行分片,最大支持 1000 亿单表分片 |
| 多租户应用 | 每个应用一个库,应用只连 Mycat,不改造程序实现多租户化 |
| 报表系统 | 借助分表能力处理大规模报表统计 |

## 13.3 Mycat 安装

```bash
yum install -y java          # 预先安装 Java 运行环境
# 确保 hostname 在 /etc/hosts 里存在(防止启动报错)
cat /etc/hosts               # 127.0.0.1 localhost ... vmware1
# 本机预先安装 MySQL 环境(不需要启动 MySQL 实例)

# 下载并解压: http://dl.mycat.io/1.6-RELEASE/
tar -zxvf Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz
mkdir logs                    # 创建日志目录
```

### 目录结构
| 目录 | 说明 |
|---|---|
| bin | 程序目录(linux/windows 版本脚本) |
| conf | 配置文件:`server.xml`(服务器参数+用户授权)、`schema.xml`(逻辑库+分片定义)、`rule.xml`(分片规则);修改配置需重启 Mycat 或通过 9066 端口 reload |
| lib | Mycat 依赖的 jar 文件 |
| logs | `mycat.log`,每天一个;日志配置在 `conf/log4j.xml`,可调 debug 级别排查问题 |

### 启动
```bash
cd bin && ./mycat start
ps -ef|grep mycat     # 能看到 wrapper + java 进程
```

## 13.4 schema.xml 配置(核心)

管理 Mycat 的**逻辑库、表、分片规则、DataNode、DataHost**,三大标签:**schema / dataNode / dataHost**。

### 基础示例
```xml
<mycat:schema xmlns:mycat="http://io.mycat/">
  <schema name="TESTDB" checkSQLschema="false" sqlMaxLimit="100" dataNode="dn1">
  </schema>
  <dataNode name="dn1" dataHost="localhost1" database="db1" />
  <dataHost name="localhost1" maxCon="1000" minCon="10" balance="1" writeType="0"
            dbType="mysql" dbDriver="native" switchType="1">
    <heartbeat>select user()</heartbeat>
    <writeHost host="wyg001" url="192.168.0.131:3306" user="root" password="123456">
      <readHost host="wyg002" url="192.168.0.132:3306" user="root" password="123456" />
    </writeHost>
  </dataHost>
</mycat:schema>
```

### schema 标签:定义逻辑库
- Mycat 可有多个逻辑库,逻辑库概念与 MySQL 的 Database 相同;不配置 schema 时所有表属于同一个默认逻辑库。
- 多逻辑库示例:定义 TESTDB(表 travelrecord 走 dn1,dn2,dn3)和 USERDB(company 走 dn10,dn11,dn12);查询不同逻辑库的表需要 `use` 切换。

### dataNode 属性(schema 内)
- 绑定逻辑库到具体数据节点;没有配置分片的表走默认节点,可以正常使用(工具查看无法显示)。

### checkSQLschema 属性
- **true**:`select * from TESTDB.travelrecord` 会被 Mycat 改写为 `select * from travelrecord`(去掉 schema 字符),避免后端报 `ERROR 1146 Table 'testdb.travelrecord' doesn't exist`;但若带的是非 schema 名(如 db1),则**不会删除**,没定义该库会报错 → 最好 SQL 不带库名前缀。
- **false**:语句原封不动发往后端 MySQL 执行。
- 实测:false 时 `select * from TESTDB.temp2` 报 1146,`select * from test.temp2` 正常;true 时两者都能查到。

### sqlMaxLimit 属性
- 仅当该 schema 中有**分片表**时生效;设置数值后,每条 SQL 没有 limit 时 Mycat 自动加 limit(如设 100,`select * from travelrecord` = `... limit 100`)。

### table 标签:定义逻辑表
```xml
<table name="travelrecord" dataNode="dn1,dn2,dn3" rule="auto-sharding-long">
</table>
```
- 所有需要拆分的表都要在此定义。
- **rule**:规则名字,与 rule.xml 中 tableRule 标签的 name 一一对应。
- **type**:逻辑表类型,`global`(全局表)或普通表(不写 global 即为普通)。
- primaryKey:非主键分片时填主键,Mycat 缓存主键→分片映射,提高查询性能。

### dataNode 标签:定义数据节点(数据分片)
```xml
<dataNode name="dn1" dataHost="lch3307" database="db1" ></dataNode>
```
- name:节点名字(唯一),table 标签引用;dataHost:属于哪个数据库实例;database:实例上的具体库。用"实例+库"两维度定义分片,每个库表结构一样,从而轻松水平拆分。

### dataHost 标签:定义数据库实例(最底层)
- 直接定义具体数据库实例、读写分离配置、心跳语句。
- **name**:唯一标识;**maxCon**:每个读写实例连接池最大连接;**minCon**:最小连接(初始化连接池大小)。
- **heartbeat**:心跳检查语句(MySQL 用 `select user()`,Oracle 用 `select 1 from dual`)。
- **writeHost / readHost**:指定后端数据库,实例化连接池;一个 dataHost 可定义多个。
  - **如果 writeHost 宕机,它绑定的所有 readHost 都不可用**;系统自动检测并切换到备用 writeHost。
  - host:标识实例(一般 writeHost 用 M1,readHost 用 S1);url:地址:端口;user/password;weight:读节点权重。
- **balance(负载均衡,读)**,3 种取值:
  - `0`:不开启读写分离,所有读操作发到当前可用的 writeHost。
  - `1`:全部 readHost 与 stand by writeHost 参与 select 负载均衡(双主双从 M1→S1,M2→S2 且 M1/M2 互为主备时,正常情况下 M2、S1、S2 都参与)。
  - `2`:所有读操作随机在 writeHost、readHost 上分发(每次查询结果可能不同,因主从数据延迟)。
- **writeType(写)**,2 种取值:
  - `0`:所有写操作发到配置的**第一个 writeHost**,挂了切到存活的第二个;重启后以切换后为准,**切换记录在 `dnindex.properties`**。
  - `1`:所有写操作随机发到 writeHost,不推荐。
- **switchType(切换)**:
  - `-1`:不自动切换(主库挂后插入报 `ERROR 1184 Connection refused`)。
  - `1`:默认值,自动切换。
  - `2`:基于 MySQL 主从同步状态决定是否切换,心跳语句为 `show slave status`(见 13.8 主从延时切换)。
- **tempReadHostAvailable**:配置为 1 后,writeHost 挂了其 readHost 仍可用(默认 0);实测主库挂后查询可执行、修改操作报 1184。

## 13.5 server.xml 配置(用户与权限)

### user 标签
```xml
<user name="test">
  <property name="password">test</property>
  <property name="schemas">TESTDB</property>      <!-- 可访问的逻辑库,多个用逗号 -->
  <property name="readOnly">true</property>       <!-- true=只读,false=读写,默认 false -->
  <property name="benchmark">11111</property>
  <property name="usingDecrypt">1</property>
</user>
```
- 用户只能访问列出的 schema,用 `use` 切到其他库报 `ERROR 1044 Access denied for user 'test' to database 'xxx'`。
- Mycat 目前只做**中间件逻辑库级别的读写权限控制**。

### 连接相关属性
| 属性 | 说明 | 默认 |
|---|---|---|
| packetHeaderSize | MySQL 协议报文头长度 | 4 |
| maxPacketSize | 协议携带数据最大长度 | 16M |
| idleTimeout | 连接空闲超时,超时回收 | 30 分钟 |
| charset | 连接初始化字符集 | utf8 |
| txIsolation | 前端连接初始化事务隔离级别 | REPEATED_READ=3 |
| sqlExecuteTimeout | SQL 执行超时时间,超时关闭连接 | 300 秒 |

### 服务相关属性
- **bindIp**:监听 IP,默认 0.0.0.0;**serverPort**:使用端口,默认 **8066**;**managerPort**:管理端口,默认 **9066**。

## 13.6 rule.xml 配置(分片规则)

- 定义表拆分涉及的路由规则,两个标签:**tableRule** 和 **function**。

### tableRule 标签
```xml
<tableRule name="rule1">
  <rule>
    <columns>id</columns>          <!-- 对哪一列拆分 -->
    <algorithm>hash-int</algorithm> <!-- 用什么路由算法 -->
  </rule>
</tableRule>
```
- columns:要拆分的列;algorithm:function 标签中的 name;多个表规则可连到同一个路由算法。

### function 标签
```xml
<function name="hash-int" class="org.opencloudb.route.function.PartitionByFileMap">
  <property name="mapFile">partition-hash-int.txt</property>
</function>
```
- name:算法名;class:路由算法的具体类;property:算法需要的一些属性(如 mapFile 配置文件路径、defaultNode 默认节点)。

## 13.7 分片规则详解

### ① 全局表
- 适用:数据字典/配置类,数据量不大、很少变动、大部分业务都会用到。
- 在所有分片上**各保存一份**;Join 时业务表与全局表**优先选同分片内的全局表 join**,避免跨库 Join。
- 插入:数据分发到全局表所有分片执行;读取:随机获取一个节点。
```xml
<table name="t_area" primaryKey="id" type="global" dataNode="dn1,dn2" />
```
- 注意:事先要在各节点创建该全局表;节点间无复制关系时数据只进 master 各库,有复制关系则同步到 slave。

### ② ER 分片表
- 适用:存在父子/主从关系的表(如 orders 与 order_detail,明细依赖订单)。
- 子表记录与所关联的父表记录**放在同一个数据分片**,避免 Join 跨库。
```xml
<table name="orders" dataNode="dn1,dn2" rule="mod-long">
  <childTable name="order_detail" primaryKey="id" joinKey="order_id" parentKey="id" />
</table>
```
- 插入时 Mycat 获取 order 所在分片,把 order_detail 也插入该分片(按 order_id 切分)。
- 注意:分片表 insert **必须带列名**:`insert into orders values(1,'a')` 报 `ERROR 1064: partition table, insert must provide ColumnList`,要写成 `insert into orders(id,name) values(...)`。

### ③ 分片枚举(sharding-by-intfile)
- 适用:省份/区县等固定枚举值场景(全国省份固定)。
```xml
<tableRule name="sharding-by-intfile">
  <rule><columns>user_id</columns><algorithm>hash-int</algorithm></rule>
</tableRule>
<function name="hash-int" class="org.opencloudb.route.function.PartitionByFileMap">
  <property name="mapFile">partition-hash-int.txt</property>
  <property name="type">0</property>
  <property name="defaultNode">0</property>
</function>
```
- mapFile 内容:`10000=0`、`10010=1`、`DEFAULT_NODE=1`(未匹配进默认节点)。

### ④ 范围约定(auto-sharding-long)
- 适用:提前规划好分片字段范围(`start <= range <= end`)。
```xml
<function name="rang-long" class="org.opencloudb.route.function.AutoPartitionByLong">
  <property name="mapFile">autopartition-long.txt</property>
  <property name="defaultNode">0</property>
</function>
```
- mapFile 内容:`0-1000=0`、`1000-2000=1`(K=1000,M=10000);超出范围进 defaultNode。
- 实测:id 10/100/1000/10000 落在 master(dn1),id 1001/1005 落在 slave(dn2)。

### ⑤ 取模(mod-long)
```xml
<function name="mod-long" class="org.opencloudb.route.function.PartitionByMod">
  <property name="count">3</property>   <!-- data node 个数 -->
</function>
```
- 根据 id 做十进制取模运算分配分片。

### ⑥ 自然月分片(sharding-by-month)
```xml
<function name="sharding-by-month" class="org.opencloudb.route.function.PartitionByMonth">
  <property name="dateFormat">yyyy-MM-dd</property>
  <property name="sBeginDate">2014-01-01</property>
</function>
```
- 按月份列分区,每个自然月一个分片;columns 为字符串类型日期字段。

### 分片选择原则(面试重点)
1. **能不分就不分**:1000 万以内的表不建议分片,用合适索引+读写分离即可。
2. **分片数量尽量少**,尽量均匀分布在多个 DataHost;查询跨分片越多性能越差;只在必要时扩容。
3. **分片规则慎重选择**:考虑数据增长模式、访问模式、分片关联性、扩容问题;范围/枚举/一致性 Hash 分片都有利于扩容。
4. **尽量不跨分片事务**:分布式事务难处理。
5. **查询条件尽量优化**:避免 `select *`、避免返回大量结果集、为频繁查询建索引。
6. 分片字段选择:**尽量均匀分布** + **是最频繁/最重要的查询条件**;没有合适字段时用**主键分片**(主键查询最快)。
7. 不带任何 WHERE 的查询会扫全部分片,性能最差,尽量避免。

## 13.8 日志查看语句路由(排查利器)

- 修改 `conf/log4j2.xml`:`<asyncRoot level="debug" includeLocation="true">`,重启 Mycat 后执行 SQL,查看 `wrapper.log`:
```
select * from temp, route={ 1 -> dn1{select * from temp} 2 -> dn2{select * from temp} }
```
- 说明 SQL 被分配到哪些分片同时执行;还可看到 `SQLRouteCache miss cache,key:...` 等路由缓存信息。

## 13.9 架构部署:读写分离

- **为什么要读写分离**:大多数系统瓶颈是 SQL 查询(计算瓶颈)而非存储;复杂 select 会耗尽 CPU 甚至拖垮数据库,所以要避免无主从复制机制的单节点数据库。
- 标准:一主多从(1 个 Master + 1~3 个读节点),Mycat 把主节点配为 writeHost、从节点配为 readHost;Mycat 定期对所有节点做心跳检测。
- 正常情况下 Mycat 把**第一个 writeHost 作为写节点**,所有 DML 发给它;开了读写分离则查询按策略发往 readHost(+writeHost)。
- 配置两个及以上 writeHost 时,第一个宕机后,Mycat 在**默认 3 次心跳失败**后自动切换到下一个可用 writeHost,并在 `conf/dnindex.properties` 记录当前 writeHost 的 index(第一个为 0,依次类推)。
- **注意:Mycat 不负责任何数据同步问题**,主从数据自动同步由 MySQL 端完成。

### 读写分离两种写法
```xml
<!-- 方式一:writeHost 内嵌 readHost(主挂则读也挂) -->
<writeHost host="hostM1" url="localhost:3306" ...>
  <readHost host="hostS1" url="localhost2:3306" ... weight="1" />
</writeHost>

<!-- 方式二:两个 writeHost(主挂后第二个继续用) -->
<writeHost host="hostM1" url="localhost:3306" .../>
<writeHost host="hostS1" url="localhost:3307" .../>
```
- 方式二更可靠;注意:**事务内部的一切操作都走写节点**,所以读操作不要加事务。

### 1 主 3 从模式配置
- 第一个从节点配置为 writeHost 2,第 2、3 个从节点配置为 writeHost 1 的 readHost。

### 强制走读/走写(1.6+)
```sql
/*!mycat:db_type=slave*/  select * from travelrecord   -- 强制走从
/*#mycat:db_type=slave*/  select * from travelrecord   -- 强制走从
/*!mycat:db_type=master*/ select * from travelrecord   -- 强制走写
/*#mycat:db_type=master*/ select * from travelrecord   -- 强制走写
```
- 实测:balance=2 下查询结果随机(主从数据不同);加 `/*!mycat:db_type=slave*/` 后稳定查从节点数据。

### 根据主从延时切换(1.4+,重点)
- 配置:`switchType="2"` + `slaveThreshold="100"`,心跳语句改为 `show slave status`。
- Mycat 心跳检测 `show slave status` 中的 **Seconds_Behind_Master、Slave_IO_Running、Slave_SQL_Running** 三字段判断主从状态。
- **当 Seconds_Behind_Master > slaveThreshold 时,读写分离筛选器过滤掉该 Slave**,防止读到很久之前的旧数据。
- **主节点宕机后,切换逻辑检查 Slave 的 Seconds_Behind_Master 是否为 0**:为 0 说明主从同步,可安全切换;否则不切换。
```xml
<dataHost name="localhost1" ... balance="0" writeType="0" switchType="2" slaveThreshold="100">
  <heartbeat>show slave status</heartbeat>
  <writeHost host="hostM1" url="localhost:3306" .../>
  <writeHost host="hostS1" url="localhost:3316" .../>
</dataHost>
```

## 13.10 集群架构

- Mycat 前面建议用 **HAProxy**(或硬件负载均衡器)做负载均衡;担心 HAProxy 单点再用 **Keepalived 的 VIP 浮动**强化。
- 整体架构:应用程序 → HAProxy(+Keepalived) → Mycat(负载均衡、故障自动切换、分库分表) → MySQL Master1/Master2(+Slave1/Slave2)。

## 13.11 Mycat 管理(9066 管理端口)

- 两个端口:**8066 数据端口、9066 管理端口**。
```bash
mysql -h127.0.0.1 -utest -ptest -P9066 [-dmycat]
# -h 主机; -u 逻辑库用户; -p 密码; -P 端口(大写); -d 逻辑库
```

### 常用管理命令
```sql
SHOW @@help;                -- 查看所有命令
RELOAD @@config_all;        -- 更新配置文件,无需重启(schema.xml 改了用这个)
SHOW @@database;            -- 显示逻辑库列表
SHOW @@datanode;            -- 数据节点列表(NAME/dataHost/ACTIVE/IDLE/SIZE 等)
SHOW @@heartbeat;           -- 心跳状态:RS_CODE 1=正常,-1=连接出错,-2=超时,0=初始化
                             -- 节点故障:连续默认 5 个周期心跳失败变 -1,确认故障后可能切换
SHOW @@connection;          -- 前端连接状态; KILL @@connection id 杀连接
SHOW @@cache;               -- 缓存:SQLRouteCache(路由)、TableID2DataNodeCache(主键-分片)、ER_SQL2PARENTID(ER父子)
SHOW @@datasource;          -- 数据源状态(W/R 标识读写)
SWITCH @@datasource name:index;  -- 手动切换数据源(index 从 0 开始)
OFFLINE; ONLINE;            -- 改变 Mycat 状态
```


---

# 第14课 MySQL 高可用架构之 Atlas(360 数据库中间件)

## 14.1 Atlas 介绍

- **Atlas** 是 **Qihoo 360** 公司 Web 平台部基础架构团队开发维护的、基于 MySQL 协议的数据中间层项目。
- 基于 MySQL 官方 **MySQL-Proxy 0.8.2** 版本改造:修复大量 bug、添加很多功能特性。360 内部广泛应用,每天承载读写请求几十亿条。
- **主要功能**:① 读写分离 ② 从库负载均衡 ③ IP 过滤 ④ 自动分表 ⑤ DBA 可平滑上下线 DB ⑥ 自动摘除宕机的 DB。

### 中间件位置
- Atlas 位于**应用程序与 MySQL 之间**:后端 DB 看来它是客户端,前端应用看来它是 DB。
- 同时实现 MySQL 客户端和服务端协议;对应用屏蔽 DB 细节;**维护连接池**降低 MySQL 负担。

### 相比官方 MySQL-Proxy 的优势
1. 主流程所有 Lua 代码用 **C 重写**(Lua 仅用于管理接口)
2. 重写网络模型、线程模型
3. 实现**真正意义上的连接池**
4. 优化锁机制,**性能提高数十倍**

## 14.2 Atlas 安装配置

### 安装
```bash
# 从 https://github.com/Qihoo360/Atlas/releases 下载最新版 RPM 包
sudo rpm -i Atlas-XX.el6.x86_64.rpm
```
- **注意事项:Atlas 只能安装运行在 64 位系统上;后端 MySQL 版本应大于 5.1,建议使用 MySQL 5.6**。
- 安装目录:`/usr/local/mysql-proxy`,默认配置文件 `conf/test.cnf`。

### 配置文件 test.cnf 核心项
```ini
[mysql-proxy]
admin-username = user                  # 管理接口用户名(必备)
admin-password = pwd                   # 管理接口密码(必备)
proxy-backend-addresses = 192.168.0.12:3306        # 主库 IP:端口(必备)
# 从库 IP:端口,@后数字是负载均衡权重,省略默认 1,多项逗号分隔;
# 想让主库也分担读请求,把主库也加进下面这项
proxy-read-only-backend-addresses = 192.168.0.13:3306,192.168.0.14:3306
pwds = myuser:HJBoxfRsjeI=             # 用户名:加密密码(用 bin/encrypt 加密),主从库要提前建好该用户且密码一致
daemon = true                          # true 守护进程/ false 前台(调试用 false)
keepalive = true                       # true 启动 monitor+worker 两个进程,worker 挂了自动重启
event-threads = 4                      # 工作线程数,推荐 CPU 核数 2~4 倍
log-level = message                    # message/warning/critical/error/debug
log-path = /usr/local/mysql-proxy/log
sql-log = OFF                          # OFF 不记;ON 缓冲刷新;REALTIME 实时写盘(调试)
sql-log-slow = 10                      # 只输出超过 10ms 的慢日志
wait-timeout = 10                      # 关闭不活跃客户端连接(秒)
proxy-address = 0.0.0.0:1234           # Atlas 工作接口 IP:端口(应用连这个)
admin-address = 0.0.0.0:2345           # Atlas 管理接口 IP:端口
charset = utf8                         # 默认 latin1,建议 utf8
client-ips = 127.0.0.1, 192.168.1      # 允许连接的客户端 IP/IP 段,不设则全允许
```

### 启动/停止/验证
```bash
cd /usr/local/mysql-proxy/bin
sudo ./mysql-proxyd test start         # 启动(restart 重启 / stop 停止)
mysql -h127.0.0.1 -P1234 -u用户名 -p密码   # 能连上即初步正常
```

### 兼容性坑(8.0 客户端连不上)
- **Atlas 安装的本机不能是 mysql 8.0 客户端环境**,否则连接报:
  `ERROR 1045 (28000): Access denied for user 'oldboy'@'127.0.0.1' (using password: YES)`
- 加 `--default-auth=mysql_native_password` 也没用;**本机 mysql 环境改成 5.7 才能正常连接**(Atlas 对 8.0 客户端认证插件不兼容)。

## 14.3 Atlas 读写分离

- 主库配 `proxy-backend-addresses`,从库配 `proxy-read-only-backend-addresses`。
- 实验(关闭主从复制,主从数据不同):
  - 主库 `temp2` 有 id=3/1,从库有 id=2 → 通过 Atlas 查询只返回**从库数据**(读走从库);
  - 通过 Atlas insert → **写走主库**;再查仍是从库数据(主从没同步,读不到新数据);
  - **主库关闭**:写操作失败(`ERROR 2013 Lost connection`),**读操作不受影响**;
  - **唯一从库关闭**:写操作成功,**读操作自动漂移到主库**执行。

## 14.4 Atlas 负载均衡(多从库)

- 多个从库按权重 `@权重` 参与读负载均衡(权重越大被读概率越高,省略默认 1)。
```ini
proxy-read-only-backend-addresses = 192.168.237.130:3308@1,192.168.237.131:3308@2
```
- 实验:两个从库数据不同,轮流查询结果在两个库之间切换;**第一个从库崩溃后,查询都落在第二个从库**(自动摘除宕机 DB)。

### 强制读主库(解决主从延迟读旧数据)
```sql
mysql -h127.0.0.1 -P1234 -uroot -pmysqltest -c
/*master*/ select * from sharding_test;   -- 读请求强制发往主库
```
- 命令行测试需加 **`-c`** 参数,防止 mysql 客户端过滤掉注释。
- FAQ:主库宕机读操作不受影响(读转到存活从库),但**写请求失败**(主库没了)。**不支持多主模式**,建议一主一从/一主多从。

## 14.5 Atlas 自动分表(非 sharding 版本)

- 配置文件设置 `tables` 参数:`数据库名.表名.分表字段.子表数量`,多项用逗号分隔。
  ```ini
  tables = test.students.id.3
  ```
- **用户需要手动建好 3 张子表 `students_0、students_1、students_2`(序号从 0 开始)**,且都在同一个 database 里。
- 通过 Atlas 执行 SELECT/DELETE/UPDATE/INSERT/REPLACE 时,按 `id%100=k` 定位子表 `stu_k`。
  - `select * from stu where id=110` → 自动查 `stu_10`;
  - **不带 id 条件**(如 `select * from stu` / `where id>2`)→ 报 `ERROR 1146: Table 'test.students' doesn't exist`(无法定位子表)。
- **不支持自动建表、不支持跨库分表**;**分表功能只有非 sharding 版本支持(sharding 版不支持)**。

## 14.6 Atlas 分片(Sharding 分布式分支)

- 基本思想:把一张表的数据**切分成多个部分存放到不同主机**(水平切分),缓解单台机器性能/容量问题,适用于单表数据庞大场景。
- 以表为单位分片;同一库内可同时存在分片表和不分片表;不分片表数据存在未分片数据库组。
- 支持 insert/delete/select/update;**写操作一次只能命中一个组**,否则报:
  `ERROR 1105 (HY000): Proxy Warning - write operation is only allow to one dbgroup!`

### 数据库组(DBGroup)
- 一个组 = **一台 master + 零台或多台 slave**(主从同步由用户自己配置);组间数据独立。
- 组内也做读写分离(命中组后读走 slave、写走 master)。

### 切分策略
| 策略 | 说明 |
|---|---|
| range | 按范围切分:id 0-1000 → Group0,1000-2000 → Group1,2000-MaxInt → Group2;范围可不相等;**暂时是静态的,不支持动态增加范围** |
| hash | 取模实现:`Hash(id) = id % group_count`,如 id=10、3 组 → 命中 DbGroup1 |

### 配置文件新增项
```ini
[shardrule-0]
table = test3.sharding_test     # 分表名:数据库.表名
type = range                    # sharding 类型:range 或 hash
shard-key = id                  # 分片字段
groups = 0:0-999,1:1000-1999    # range:group_id:id范围;hash:groups = 0,1

[group-0]                       # 每个 group 一个 section
proxy-backend-addresses = 192.168.237.130:3308    # 该组 master
#proxy-read-only-backend-addresses = ...          # 该组 slave
[group-1]
proxy-backend-addresses = 192.168.237.131:3308
```

### 支持的语句限制(重点)
- 只支持基本 Select、insert/replace、delete、update(CRUD)和全部 WHERE 语法(SQL-92)。
- **不支持 DDL(create/drop/alter)及管理语句**,DDL 直接连 MySQL 执行。
- 命中**多个 dbgroup 时不支持**:Limit Offset、Order by、Group by、Join、count/Max/Min 等函数;**子查询可能返回错误结果**,请拆成多句执行。
- 写操作命中多组(存在部分成功需回滚)也不支持,请拆分 SQL。
- 只命中一个组时这些特性都支持,如 `select count(*) from test where id < 1000`(dbgroup0 范围 0-1000)。

### 实测行为
- `insert ... values(100,..),(1500,..)` 跨组 → `ERROR 1105 write operation is only allow to one dbgroup!`(同组的多值插入 OK)。
- 不带 where 的 `update/delete` → `ERROR 1105: Syntax Forbidden!`;`where id<2000` 跨组 → 报错;`where id<999` 单组 → OK。
- `select * from sharding_test order by id`(跨组排序)→ `ERROR 1105 Sharing Hit Multi Dbgroup Not Support SQL`;`where id<500 order by id` 单组 → OK。
- `select count(*) ... where id>500` 跨组 → 不支持;`where id>1000` 单组 → 正常返回。
- 分片表 join 其他表 → `ERROR 1105: Sharing Hit Multi Dbgroup Not Support SQL`。


---

# 第15课 MySQL 高可用架构之 MHA 与 MMM

## 15.1 MHA 介绍

- **MHA(Master High Availability)**:MySQL 高可用环境下**故障切换和主从提升**的高可用软件,由日本 DeNA 公司 youshimaton(现就职于 Facebook)开发。
- 故障切换:**0~30 秒**内自动完成,最大程度保证**数据一致性**;还提供**在线主库切换**(0.5~2 秒),可在非维护期在线切换。

### 三大功能
1. **自动故障检测和自动故障转移**:监控 MySQL,检测到 Master 故障后自动转移。通过鉴定出最"新"的 Slave 的 relay log,并应用到所有 Slave,保证各 slave 数据一致。slave 是否能成为候选主节点可配置优先级,**所有 slave 都有希望成为新主**。
2. **交互式(手动)故障转移**:不监控 master 状态,确认故障后手动切换。
3. **在线切换 Master 到不同主机**:0.5~2 秒写阻塞,通常可接受;升级到高版本、更快服务器更轻松。

### MHA 优势
- 自动故障转移快;主库崩溃**不存在数据一致性问题**(基于 relay log 补齐);
- 配置无需对当前 MySQL 环境做重大修改;不需要额外服务器(**一台 manager 可管理上百个 replication**);
- 性能优秀,可工作于半同步和异步复制;监控时仅每隔 N 秒(默认 3 秒)向 master 发 ping 包,**对性能无影响**;
- 只要 replication 支持的存储引擎,MHA 都支持,不局限于 InnoDB。

### MHA 组成
- **Manager 节点**:单独部署在一台机器上管理多个 master-slave 集群,也可部署在 slave 上;定时探测 master,故障时把最新数据的 slave 提升为新 master,其他 slave 重指向新 master,全程对应用透明。
- **Node 节点**:运行在每台 MySQL 服务器上。

### MHA 工作原理(6 步)
1. 从宕机崩溃的 master 保存二进制日志事件(binlog events)
2. 识别含有最新更新的 slave
3. 应用差异的中继日志(relay log)到其他 slave
4. 应用从 master 保存的 binlog events
5. 提升一个 slave 为新的 master
6. 使其他 slave 连接新 master 进行复制

## 15.2 MHA 安装部署(一主两从 + 管理机)

### ① 下载与安装
```bash
# https://github.com/yoshinorim/mha4mysql-manager/releases/tag/v0.58
# 所有节点装 node
yum install -y perl-DBD-MySQL
rpm -ivh mha4mysql-node-0.58-0.noarch.rpm
# 管理节点装 manager(先装依赖)
rpm -ivh epel-release-latest-7.noarch.rpm
yum install perl-DBD-MySQL perl-Config-Tiny perl-Log-Dispatch perl-Parallel-ForkManager -y
rpm -ivh mha4mysql-manager-0.58-0.el7.noarch.rpm
```

### ② 配置 /etc/hosts(四节点)
```
192.168.237.132 mycat     # manager
192.168.237.128 master
192.168.237.130 slave1
192.168.237.131 slave2
```

### ③ 管理节点创建配置文件 /etc/app1.cnf
```ini
[server default]
user=root                  # mysql 监控用户
password=mysql
ssh_user=root              # ssh 用户
manager_workdir=/var/log/masterha/app1    # manager 工作目录
remote_workdir=/var/log/masterha/app1     # MySQL 服务器上的工作目录
repl_user=repl             # 复制用户
repl_password=mysql
[server1]
hostname=master
port=3308
master_binlog_dir=/usr/local/mysql/data   # master binlog 保存位置,用于恢复
[server2]
hostname=slave1
port=3308
master_binlog_dir=/usr/local/mysql/data
[server3]
hostname=slave2
port=3308
master_binlog_dir=/usr/local/mysql/data
```

### ④ slave 节点 my.cnf 关键项
```ini
server_id = 2
skip-slave-start=1        # 先不自动启动 slave
log-bin=mysql-bin
relay_log_purge=0         # 关键!关闭 relay log 自动清理(切换恢复要用)
log-slave-updates=true    # 记录到自己的 binlog(级联复制需要)
```
- 说明:**MHA 切换过程中 slave 恢复依赖 relay log,MHA 环境必须把 relay log 自动删除关掉**,改为手动清理。

### ⑤ 配置 SSH 免密(manager 与所有 node 之间)
```bash
ssh-keygen -t rsa
cat id_rsa.pub >> authorized_keys
# 全部节点间互通
mkdir /var/log/masterha/app1 -p
ln -s /usr/local/mysql/bin/mysqlbinlog /usr/bin/mysqlbinlog   # 软连接,否则可能找不到命令
ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
```

### ⑥ 检测 SSH 与复制配置
```bash
masterha_check_ssh --conf=/etc/app1.cnf
# All SSH connection tests passed successfully.

masterha_check_repl --conf=/etc/app1.cnf
# Alive Servers / Alive Slaves / MySQL Replication Health is OK.
```

### ⑦ 开启/检查/停止 manager
```bash
nohup masterha_manager --conf=/etc/app1.cnf >/var/log/masterha/app1/mha_manager.log < /dev/null &
masterha_check_status --conf=/etc/app1.cnf
# app1 (pid:3287) is running(0:PING_OK), master:master
masterha_stop --conf=/etc/app1.cnf
# Stopped app1 successfully.
```

## 15.3 自动故障转移测试

- 停掉 master 的 mysqld,查看 `mha_manager.log`:
```
MySQL Master failover master to slave1 succeeded
The latest slave slave1(...) has all relay logs for recovery. Selected slave1 as a new master.
slave2: ... Slave started, replicating from slave1.
slave1: Resetting slave info succeeded.
Master failover to slave1(...) completed successfully.
```
- 结果:slave1 的 `show slave status` 为空(它成了新主);slave2 的 Master_Host 已指向 slave1,`Slave_IO_Running/SQL_Running: Yes`。

### 验证"先补齐日志再切换"(数据零丢失核心)
1. 先 `stop slave` 停掉两个从库的复制线程;
2. 主库插入 `id=5000` 的记录(从库无此数据);
3. 直接关闭主库 MySQL;两个从库开启复制,依旧查不到 5000(主库已死);
4. 启动 MHA manager → 完成主从切换 → 在新主(slave1)上**能查到 5000**;
5. 查看保存下来的增量 binlog:`mysqlbinlog -v /var/log/masterha/app1/saved_master_binlog_from_master_3308_*.binlog`。
- 原理:MHA 从崩溃主库把缺失的 binlog 保存下来,补齐给新主,保证**不丢已提交事务**。

## 15.4 手动故障切换(master_state=dead)

```bash
masterha_stop --conf=/etc/app1.cnf          # ① 先停 MHA,防止自动切换
# ② 关闭 master 主库
masterha_master_switch --master_state=dead --conf=/etc/app1.cnf \
  --dead_master_host=master --dead_master_port=3308 \
  --new_master_ip=192.168.237.131 --new_master_port=3308
```

## 15.5 在线切换(master_state=alive)

- **前提(必须全部满足,否则切换失败)**:
  1. 所有 slave 的 **IO 线程都在运行**
  2. 所有 slave 的 **SQL 线程都在运行**
  3. 所有 `show slave status` 的 `Seconds_Behind_Master` 小于等于 `running_updates_limit`(默认 1 秒)
  4. master 端 `show processlist` 中没有执行时间超过 running_updates_limit 秒的更新
```bash
masterha_stop --conf=/etc/app1.cnf
masterha_master_switch --conf=/etc/app1.cnf --master_state=alive \
  --new_master_host=slave2 --new_master_port=3308 \
  --orig_master_is_new_slave --running_updates_limit=10000
```
- `--orig_master_is_new_slave`:切换后**原 master 变为 slave**;不加此参数原 master 将不启动。
- `--running_updates_limit=10000`:候选 master 有延迟时,延迟在此秒数内都可切换(切换耗时由 recover 时 relay 日志大小决定)。

## 15.6 MHA VIP 漂移

- 在 master 节点上添加 VIP:`ifconfig eno16777736:2 192.168.237.120/24`
- 监控节点配置脚本 `/usr/local/bin/master_ip_failover`(在 /etc/app1.cnf 加 `master_ip_failover_script=` 指向它)。
- 测试:关掉 master,查看 VIP 漂移到新的主节点上(应用只需连 VIP)。

## 15.7 MMM 介绍

- **MMM(Master-Master replication manager for MySQL)**:支持**双主故障切换和双主日常管理**的脚本程序,Perl 开发,监控和管理 MySQL 双主(Master-Master)复制。
- 虽然叫双主复制,但**业务上同一时刻只允许对一个主写入**,另一台备选主提供部分读服务(加速切换时备选主预热);内部附加工具脚本可实现**多个 slave 的读负载均衡**。
- 提供自动/手动两种方式移除复制延迟高的服务器的虚拟 IP;可备份数据、实现两节点数据同步。
- **缺点:无法完全保证数据一致性** → 适用于**对一致性要求不高、但追求业务可用性**的场景;**高一致性要求业务不建议用 MMM**。

### MMM 架构(两主一从)
- db1、db2 互为主从;**db3(192.168.0.40)为 db2 的从库**。
- 双主配置(避免自增主键冲突):
  - db1:`server-id=1`、`auto-increment-increment=2`、`auto-increment-offset=1`
  - db2:`server-id=2`、`auto-increment-increment=2`、`auto-increment-offset=2`
  - db3:`server-id=3`
  - 各节点都开 `log_slave_updates=1`
  - 用 `CHANGE MASTER TO` 建立复制关系

### MMM 配置文件(每台机器装 mysql-mmm-2.2.1:make install)
- **mmm_common.conf**(三台主机相同,从 db1 拷贝):
```ini
active_master_role  writer
<host default>
    cluster_interface  eth0
    replication_user   repl
    replication_password  mysql
    agent_user  mmm_agent
    agent_password  mmm_agent
</host>
<host db1> ip 192.168.237.128  mode master  peer db2 </host>
<host db2> ip 192.168.237.130  mode master  peer db1 </host>
<host db3> ip 192.168.237.131  mode slave </host>
<role writer>  hosts db1, db2  ips 192.168.237.120  mode exclusive </role>
<role reader>  hosts db2, db3  ips 192.168.237.121, 192.168.237.122  mode balanced </role>
```
- `mode exclusive`:主独占模式,同一时刻只能一个主;`mode balanced`:读负载均衡。
- **mmm_agent.conf**(每台不同):`include mmm_common.conf` + `this db1`(db2 写 this db2,db3 写 this db3)。
- **mmm_mon.conf**(monitor 主机):`include mmm_common.conf` + `<monitor>` 段配置 `ping_ips`(被监控主机 IP)与 `monitor_user/monitor_password`。

### 授权与启动
```sql
-- agent 用户(需 SUPER、REPLICATION CLIENT、PROCESS)
GRANT SUPER, REPLICATION CLIENT, PROCESS ON *.* TO 'mmm_agent'@'192.168.237.%' IDENTIFIED BY 'mmm_agent';
-- monitor 用户
GRANT REPLICATION CLIENT ON *.* TO 'mmm_monitor'@'192.168.237.%' IDENTIFIED BY 'mmm_monitor';
```
```bash
# 依赖:yum install -y cpan gcc;cpan -i Algorithm::Diff ... Net::ARP
/etc/init.d/mysql-mmm-agent start     # 三台 db 上启动
/etc/init.d/mysql-mmm-monitor start   # monitor 主机启动
# 日志:/var/log/mysql-mmm/mmm_agentd.log / mmm_mond.log
```

### MMM 常用命令
```bash
mmm_control checks all          # 检查所有主机 ping/mysql/rep_threads/rep_backlog
mmm_control show                # 显示集群在线状态与角色
mmm_control set_online db1      # 把主机上线(默认 AWAITING_RECOVERY)
```

### MMM 故障切换测试(重点)
- **模拟 db2 宕机**:monitor 日志 `db2 changed from ONLINE to HARD_OFFLINE (ping: OK, mysql: not OK)`;db2 的 reader 角色移除,db3 接管其读 VIP。重启 db2 后恢复 ONLINE 重新接管读请求。
- **模拟 db1(当前 writer)宕机**:
  - 日志:`db1 ... HARD_OFFLINE` → `Removed role 'writer(...)' from host 'db1'` → `Orphaned role 'writer' has been assigned to 'db2'`;
  - db2 变成 `Roles: reader(…), writer(…)`(接管写 VIP);db3 自动 `change master to` 指向 db2。
- **一致性风险**:若 db2、db3 已延时于 db1 时 db1 宕机,db3 会等数据追上 db1 再 change master;但**若 db2 落后于 db1 时切换,db2 变可写,数据一致性无法保证** —— 这就是 MMM 无法保证一致性的本质。

## 15.8 MHA vs MMM 对比

| 对比项 | MHA | MMM |
|---|---|---|
| 定位 | 单主复制环境故障切换+在线切换 | 双主复制管理+故障切换 |
| 数据一致性 | 从 master 保存 binlog 补齐,**保证不丢已提交事务** | **无法完全保证**数据一致性 |
| 适用场景 | 高一致性要求业务 | 一致性要求不高、重可用性业务 |
| 组成 | Manager + Node(每台 MySQL) | agent(每台 db)+ monitor(独立) |
| 特色 | 0~30s 自动切换、在线切换 0.5~2s | 多 slave 读负载均衡、VIP 漂移、自动上下线 |
| 注意点 | 必须关 relay_log_purge、SSH 免密、node 装全 | 双主自增步长/偏移要配置避免主键冲突 |


---

# 第16课 MySQL 备份和恢复

## 16.1 备份类型介绍

### 物理备份 vs 逻辑备份
| 对比项 | 物理备份 | 逻辑备份 |
|---|---|---|
| 备份方式 | **拷贝数据库文件** | 备份逻辑结构(create database/table)+数据(insert/文本文件) |
| 适用场景 | 数据库很大、数据重要、需快速恢复 | 数据库不大、需修改导出文件、希望重建到不同类型服务器 |
| 速度 | 快(直接拷贝文件) | 慢(要访问数据库并转换格式) |
| 备份文件 | 直接是数据文件 | 通常比物理备份大,不含配置文件和日志文件 |
| 粒度 | 整个数据库或单个文件;**能否单表恢复取决于存储引擎**(MyISAM 每表独立文件可单独恢复;InnoDB 可能共享数据文件) |
| 执行条件 | 通常要求数据库关闭;运行中执行则备份期间不能修改 | 必须在**数据库运行状态下**执行 |
| 工具 | 文件拷贝 / Xtrabackup | mysqldump / select...into outfile |

### 在线 vs 离线 / 本地 vs 远程 / 全量 vs 增量
- **在线备份**:数据库运行状态下执行;**离线备份**:数据库关闭状态下执行。
- **本地备份**:在 MySQL 运行主机上发起;远程备份:在其他主机发起(mysqldump 可连远程,但 select...into outfile 生成的文件存放在 MySQL 实例主机上)。
- **全量备份**:包含所有数据;**增量备份**:仅包含某时间段内的变化(MySQL 中借助二进制日志完成)。

## 16.2 MySQL 备份方法总览

1. **mysqldump 命令**执行备份;
2. **拷贝物理表文件**:每表有独立数据文件时可用;数据库运行中需先加只读锁 `FLUSH TABLES tbl_list WITH READ LOCK`。对 **MyISAM 支持很好**(天然分 frm/MYD/MYI 三文件),对 InnoDB 不太支持;
3. **select ... into outfile 生成文本文件**:或 mysqldump 加 `--tab` 参数;**只生成表数据,不生成表结构**;
4. **增量备份**:开启 log-bin,备份增量生成的二进制日志;
5. **Xtrabackup 工具**执行全量或增量备份。

## 16.3 MySQL 物理拷贝文件

### MyISAM 表(直接拷贝 3 个文件即可)
- MyISAM 每张表对应独立文件:`*.frm`(表结构)、`*.MYD`(数据)、`*.MYI`(索引)。
- 只要拷贝期间无写操作,可直接拷贝到另一实例同库目录:
```bash
[root@master course]# sftp slave1
sftp> cd /usr/local/mysql/data/test2
sftp> put students_myisam*
[root@slave1 test2]# chown mysql:mysql students_myisam.*
mysql> use test2; select * from students_myisam;   # 正常查到数据
```

### InnoDB 表(不能直接拷贝!即使 innodb_file_per_table=on)
- 直接拷贝 `students.frm + students.ibd` 到目标实例:
```bash
mysql> select * from students;
ERROR 1146 (42S02): Table 'test2.students' doesn't exist
# 错误日志:
# [Warning] InnoDB: Cannot open table test2/students from the internal
# data dictionary of InnoDB though the .frm file for the table exists.
```
- 原因:InnoDB 的**数据字典(内部字典)里没有该表登记**。

### InnoDB 正确做法:拷贝整个 data 目录
```bash
[root@master mysql]# /etc/init.d/mysql.server stop    # 先停库
[root@master mysql]# tar -zcvf data.tar.gz data
[root@master mysql]# sftp slave1; sftp> put data.tar.gz
[root@slave1 data]# mv data data_bak
[root@slave1 data]# tar -zxvf data.tar.gz
[root@slave1 data]# /etc/init.d/mysql.server start
```

## 16.4 mysqldump 详解

- mysqldump 生成**逻辑备份文件**,内容是构成数据库对象和数据内容的**可重复执行的 SQL 语句**。
- 三种用法:
```bash
mysqldump [options] db_name [tbl_name ...]          # 单库(表)
mysqldump [options] --databases db_name ...         # 多库(-B)
mysqldump [options] --all-databases                 # 所有库(-A)
```

### 常用参数(基础)
| 参数 | 说明 |
|---|---|
| -h / --host、-u / --user、-p / --password、-P / --port | 连接目标数据库的主机/用户/密码/端口 |
| --add-drop-database | 配合 -B/-A 时,在每个 create database 前加 drop database |
| --add-drop-table | 每个 create table 前加 drop table |
| --add-drop-trigger | 每个 create trigger 前加 drop trigger |
| --replace | 用 replace 代替 insert 插入数据 |
| --default-character-set=charset_name | 指定默认字符集(默认 UTF8) |
| --set-charset | 把 `SET NAMES default_character_set` 写入备份文件(默认开启) |

### 常用参数(复制/备份场景)
| 参数 | 说明 |
|---|---|
| --dump-slave[=value] | 在**从库**导出备份,文件中含 change master to 语句;**=1** 直接写入,=2 写入但注释掉;利用该备份可直接建立新从库 |
| --master-data[=value] | 在**主库**导出备份,用法同 dump-slave;使用它会自动打开 --lock-all-tables,除非同时加 --single-transaction |
| --ignore-table=db.tbl | 忽略某个表(多个要重复写多次) |
| --no-data / -d | 只导出表结构 |
| --routines / -R | 导出存储过程和函数 |
| --triggers | 导出触发器 |
| --where='where_condition' / -w | 仅导出符合条件的数据 |
| --lock-all-tables / -x | 导出过程中对每个数据库的每个表加只读锁 |
| --no-autocommit | 每个表的数据用 set autocommit=0 和 commit 包围 |
| --single-transaction | 将隔离级别设为可重复读,导出开始时 start transaction;**过程中不阻止任何读写操作** |

### 常用操作命令
```bash
# 导出一个数据库
mysqldump -uroot -p -P3308 --databases course > backup.sql
# 导出多个数据库(两种写法)
mysqldump -u root -p -P 3308 --databases course test > course.sql
mysqldump -u root -p -P 3308 -B course test > course.sql
# 导出所有数据库
mysqldump -u root -p -P 3308 --all-databases > course.sql
# 导出一个库的某几个表
mysqldump -u root -p -P 3308 course students students_myisam > course.sql
# 仅导出数据,不包含表结构
mysqldump -u root -p -P 3308 --no-create-info course > course.sql
# 仅导出表结构
mysqldump -u root -p -P 3308 --no-data course > course.sql
# 忽略指定表
mysqldump -u root -p -P 3308 --ignore-table=course.teacher --ignore-table=course.score course > course.sql
# 导出存储过程和触发器
mysqldump -u root -p -P 3308 --routine --trigger course > course.sql
# 导出符合 where 条件的数据
mysqldump -u root -p -P 3308 --where="sid in (1,2)" course students students_myisam > course.sql
# 远程导出(文件生成在发起命令的服务器上)
mysqldump -u root -p -P 3308 -h 192.168.237.128 course > course.sql
```

### FTWRL:FLUSH TABLES WITH READ LOCK(重点)
- 用于备份工具获取**一致性备份(数据与 binlog 位点匹配)**;但需要持有**两把全局 MDL 锁**并关闭所有表对象,**杀伤性很大,容易导致库 hang 住**。
- 三个步骤:① 上全局读锁(lock_global_read_lock)② 清理表缓存(close_cached_tables)③ 上全局 COMMIT 锁(make_global_read_lock_block_commit)。
- 影响:全局读锁阻塞所有更新;关闭表时若有**大查询等待关闭**,所有访问该表的查询/更新都要等待;全局 COMMIT 锁阻塞活跃事务提交。
```sql
mysql> flush tables with read lock;        -- session1
mysql> update dept set dept_name='bcd';    -- session2 写操作被阻塞(等待超时)
```

### FTWRL 与 LOCK TABLES READ LOCAL 的区别(实验)
- 第一个 session 执行 `set autocommit=0; update dept set dept_name='aaa';`(产生排他锁,未提交);
- 第二个 shell 窗口导出:
  - 带 **--master-data** 参数:`mysqldump --master-data course` **导出成功**(内部先 FLUSH TABLES WITH READ LOCK 不受排他锁影响);
  - 普通导出:`mysqldump course` 则**锁等待**(processlist 出现 `Waiting for table metadata lock`,`LOCK TABLES ... READ LOCAL`)。

### start transaction 与 start transaction with consistent snapshot(实验)
- `START TRANSACTION`:事务从**第一条语句**开始,第一条 select 建立一致性快照;
- `START TRANSACTION WITH CONSISTENT SNAPSHOT`:**立即**建立一致性快照,事务立即开始。
```sql
-- 实验1(普通 start transaction):
session A: start transaction;            -- 此时事务未开始
session B: insert into t1 values(1,1);
session A: select * from t1;             -- 能读到 1,1(snapshot 建立于 insert 之后)
-- 实验2(with consistent snapshot):
session A: start transaction with consistent snapshot;  -- 事务立即开始并建快照
session B: insert into t1 values(1,1);
session A: select * from t1;             -- 读不到(快照早于 insert)
```

### general_log 分析导出过程(理解内部逻辑)
- 普通导出:Connect → 设置 sql_mode/time_zone → 查询 information_schema → `Init DB course` → `show tables` → `LOCK TABLES course READ LOCAL,...` → 逐表 show create table / show fields → `SELECT /*!40001 SQL_NO_CACHE */ * FROM course`。
- 加 --master-data:先 `FLUSH TABLES`、`FLUSH TABLES WITH READ LOCK`、`SHOW MASTER STATUS`(取位点),再走普通流程。
- **--master-data + --single-transaction**:`FLUSH TABLES WITH READ LOCK` 后立即 `SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ`、`START TRANSACTION WITH CONSISTENT SNAPSHOT`、`SHOW MASTER STATUS`、**`UNLOCK TABLES`**,之后正常导出(**锁只在上锁瞬间持有**),后续不阻塞读写。
- 结论:**生产备份推荐 `--master-data=2 --single-transaction`**(InnoDB):锁瞬间获取并释放,导出一致性快照,不影响在线业务。

### 主从备份要点
- **从主库备份**:`mysqldump --master-data=2 --single-transaction course`;备份开始瞬间加 FTWRL 锁,拿到位点后立即释放,不影响后续读写。
- **从主库备份不能加 --dump-slave**:报 `Couldn't execute 'START SLAVE': The server is not configured as slave`。
- **从从库备份**:`mysqldump --dump-slave --single-transaction test`,文件中含 change master 语句,可直接建立新从库。

### 导入备份文件
```bash
mysql -u root -p course < course.sql
# 或登录后 source
mysql> use course;
mysql> source course.sql
```

### --tab 导出文本文件
- 每个表生成两个文件:`xxx.sql`(表结构)+ `xxx.txt`(数据);需先配置 `secure_file_priv` 指定路径。
```ini
# my.cnf 中:
secure_file_priv=/usr/local/mysql/backup/
```
```bash
mysqldump -u root -p --tab=/usr/local/mysql/backup course
# 自定义分隔符
mysqldump -u root -p --tab=/usr/local/mysql/backup \
  --fields-terminated-by=, --fields-enclosed-by='"' --lines-terminated-by=0x0d0a course
```
- 相关参数:`--fields-terminated-by`(字段间隔符,默认 tab)、`--fields-enclosed-by`(字段括起字符)、`--fields-optionally-enclosed-by`(非数字字段括起)、`--lines-terminated-by`(行结束符,默认 newline)。

### 文本文件导入(两步)
```bash
# ① 先导入表结构
mysql db1 < t1.sql     # 或 source
# ② 再导入数据:mysqlimport 或 load data infile
mysqlimport -u root -p --fields-terminated-by=, --fields-enclosed-by='"' \
  --lines-terminated-by=0x0d0a course /usr/local/mysql/backup/students.txt
```
```sql
mysql> load data infile '/usr/local/mysql/backup/students.txt' into table students
       FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n';
```

### 生产自动备份脚本(定期备份全部库并上传备份服务器)
```sh
#!/bin/sh
MYUSER=system; PORT=5001
DB_DATE=$(date +%F); DB_NAME=$(uname -n); MYPASS=********
MYLOGIN="/data/application/mysql/bin/mysql -u$MYUSER -p$MYPASS -P$PORT"
MYDUMP="/data/application/mysql/bin/mysqldump -u$MYUSER -p$MYPASS -P$PORT -B"
DATABASE="$($MYLOGIN -e "show databases;" | egrep -vi "information_schema|database|performance_schema|mysql")"
for dbname in $DATABASE; do
  MYDIR=/server/backup/$dbname
  [ ! -d $MYDIR ] && mkdir -p $MYDIR
  $MYDUMP $dbname --ignore-table=opsys.user_action | gzip > $MYDIR/${dbname}_${DB_NAME}_${DB_DATE}_sql.gz
done
# 删除 3 天前的备份,并 rsync 到备份服务器
find /server/backup/ -type f -name "*.gz" -mtime +3 | xargs rm -rf
find /server/backup/* -type d -name "*" -exec rsync -avz {} data_backup:/data/backup/ \;
```

## 16.5 select ... into outfile

- 导出表中符合条件的数据到文本文件;**不导出表结构,仅导出数据**。
```sql
select * from Table into outfile '/路径/文件名'
  fields terminated by ','      -- 字段值间隔符
  enclosed by '"'               -- 包裹字段值
  lines terminated by '\r\n';   -- 行结束符
```
```sql
-- 完整导出
select * from students into outfile '/usr/local/mysql/backup/students.txt'
  fields terminated by ',' enclosed by '"' lines terminated by '\r\n';
-- 部分数据
select * from students where sid in (1,2) into outfile '...students2.txt' ...;
-- 关联查询结果
select * from students a inner join dept b on a.dept_id=b.id into outfile '...students3.txt' ...;
```
- 子句说明:`TERMINATED BY` 字段间隔符;`ENCLOSED BY` 包裹字符;`ESCAPED BY` 转义字符(默认 `\`);`LINES TERMINATED BY` 行结束符。

### load data infile 导入(对应导出格式)
- 语法:`load data [low_priority] [local] infile 'file_name.txt' [replace | ignore] into table tbl_name [fields ...] [lines ...] [ignore number lines] [(col_name,...)]`
- `local` 指定从客户端主机读文件;不指定则文件必须在服务器上。
- `replace`:唯一键重复时**用新行替换**;`ignore`:唯一键重复时**跳过**;都不指定则遇到重复键报错,文件剩余部分被忽略。
```sql
mysql> load data infile '...students2.txt' into table students fields terminated by ',' enclosed by '"' lines terminated by '\r\n';
-- 忽略错误继续导入(重复的行被跳过)
mysql> load data infile '...students.txt' ignore into table students ...;
-- 冲突时替换
mysql> load data infile '...students.txt' replace into table students ...;
```

## 16.6 恢复类型

- **全量恢复**:恢复备份文件中所有数据,恢复后的数据 = 生成备份那一刻的状态。
- **基于时间点恢复**:恢复到指定时间点状态;通常先全量恢复,再用**二进制日志**把指定时间点前的所有操作重新执行一遍。

## 16.7 基于时间点恢复(mysqlbinlog)

### mysqlbinlog 用法
```bash
# 直接重新执行日志
shell> mysqlbinlog binlog_files | mysql -u root -p
shell> mysqlbinlog binlog.000001 binlog.000002 | mysql -u root -p
# 或先解析出来再执行
shell> mysqlbinlog binlog_files > tmpfile
shell> mysql -u root -p < tmpfile
```

### 时间范围恢复
```bash
# 恢复到某个时间点之前(--stop-datetime)
mysqlbinlog --stop-datetime="2005-04-20 9:59:59" /var/log/mysql/bin.123456 | mysql -u root -p
# 从某个时间点开始(--start-datetime)
mysqlbinlog --start-datetime="2005-04-20 10:01:00" /var/log/mysql/bin.123456 | mysql -u root -p
```
- 位置恢复:
```bash
mysqlbinlog --stop-position=368312  /var/log/mysql/bin.123456 | mysql -u root -p
mysqlbinlog --start-position=368315 /var/log/mysql/bin.123456 | mysql -u root -p
```

### 恢复实验示例
```sql
-- 构造数据(每个操作后 flush logs 生成新日志)
alter table students add tstamp timestamp;
flush logs;
insert into students values(1,'a',1,1),(2,'b',2,2);  -- 进入 mysql-bin.000050
flush logs;
insert into students values(3,'c',3,3),(4,'d',4,4);  -- 进入 mysql-bin.000051
insert into students values(5,'e',5,3),(6,'f',6,4);  -- 22:26:25 前后
flush logs;
mysql> truncate table students;                       -- 误删!
-- 恢复:全量回放第一个日志
mysqlbinlog mysql-bin.000050 | mysql -u root -p      -- 恢复 1,2
mysqlbinlog -v mysql-bin.000051 | mysql -u root -p   -- 恢复 3,4,5,6
-- 只恢复到 22:26:20(5、6 不恢复)
mysqlbinlog mysql-bin.000050 | mysql -u root -p
mysqlbinlog --stop-datetime="2017-07-11 22:26:20" mysql-bin.000051 | mysql -u root -p
-- 跳过 22:26:17~22:26:24 之间的数据(只恢复 5、6)
mysqlbinlog mysql-bin.000050 | mysql -u root -p
mysqlbinlog --start-datetime="2017-07-11 22:26:24" mysql-bin.000051 | mysql -u root -p
```

## 16.8 Xtrabackup(在线热备份)

- 支持**在线热备份**(备份时不影响读写);两个工具:`xtrabackup` 与 `innobackupex`(后者逐渐被前者取代)。
- 特点:① 备份快速可靠 ② 不打断正在执行的事务 ③ 支持压缩省空间流量 ④ 自动实现备份检验 ⑤ 还原速度快。
- 下载:https://www.percona.com/downloads/XtraBackup/LATEST/

### 安装
```bash
wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.9/binary/tarball/percona-xtrabackup-2.4.9-Linux-x86_64.tar.gz
tar -zxvf percona-xtrabackup-2.4.9-Linux-x86_64.tar.gz
cp xtrabackup-2.4.9/bin/* /usr/bin/
```

### 全量备份 / 恢复
```bash
# 全量备份
xtrabackup --backup --target-dir=/data/backups/ -u root -p mysql -P 3308 --host=127.0.0.1
# 备份目录内容:ibdata1、各库目录、xtrabackup_checkpoints、xtrabackup_binlog_info、xtrabackup_logfile 等

# 恢复前先 prepare(把不同时间点的数据文件准备到同一时间点,否则启动可能冲突)
mv /usr/local/mysql/data /usr/local/mysql/data_bak
mkdir data && chown mysql:mysql data
xtrabackup --prepare --target-dir=/data/backups/
# 复制回数据目录
xtrabackup --copy-back --target-dir=/data/backups/ --datadir=/usr/local/mysql/data
chown -R mysql:mysql /var/lib/mysql
/etc/init.d/mysql.server start
```

### 增量备份(xtrabackup)
```bash
# 先全量
xtrabackup --backup --target-dir=/data/backups/base -u root -p mysql -P 3308 --host=127.0.0.1
mysql> insert into students values(11,'aa',1,1,current_timestamp);  -- 变化数据
# 增量 1(基于 base)
xtrabackup --backup --target-dir=/data/backups/inc1 --incremental-basedir=/data/backups/base -u root -p mysql -P 3308 --host=127.0.0.1
mysql> insert into students values(13,'cc',3,3,current_timestamp);
# 增量 2(基于 inc1)
xtrabackup --backup --target-dir=/data/backups/inc2 --incremental-basedir=/data/backups/inc1 -u root -p mysql -P 3308 --host=127.0.0.1
```

### 增量恢复(xtrabackup)
```bash
mv data data_bak && mkdir data && chown mysql:mysql data
# 依次把 base、inc1、inc2 合并到 base(前两个加 --apply-log-only)
xtrabackup --prepare --apply-log-only --target-dir=/data/backups/base --datadir=/usr/local/mysql/data
xtrabackup --prepare --apply-log-only --target-dir=/data/backups/base --incremental-dir=/data/backups/inc1 --datadir=/usr/local/mysql/data
xtrabackup --prepare --target-dir=/data/backups/base --incremental-dir=/data/backups/inc2 --datadir=/usr/local/mysql/data
# 复制回数据目录
xtrabackup --copy-back --target-dir=/data/backups/base --datadir=/usr/local/mysql/data
mysql> select * from students;   # 1~4 + 11,12,13,14 全部恢复
```

### innobackupex 方式(老工具,逻辑同 xtrabackup)
```bash
# 全量备份(自动生成带时间戳目录)
innobackupex --user=root --password=mysql --host=127.0.0.1 --port=3308 /data/backups
# 全量还原
/etc/rc.d/init.d/mysqld stop
rm -rf /data/dbdata/*
innobackupex --apply-log /data/backups/2017-07-13_19-47-44          # 生成 ib_logfile
innobackupex --copy-back /data/backups/2017-07-13_19-47-44          # 还原数据(datadir 要在 my.cnf 配置)
chown -R mysql:mysql /usr/local/mysql/data
/etc/rc.d/init.d/mysqld start
# 增量备份
innobackupex --incremental-basedir=/data/backups/2017-07-14_22-32-11 --incremental /data/backups
# 增量还原(最后一个增量不加 --redo-only)
innobackupex --apply-log --redo-only /data/backups/2017-07-14_22-32-11
innobackupex --apply-log --redo-only /data/backups/2017-07-14_22-32-11 --incremental-dir=/data/backups/2017-07-14_22-36-23
innobackupex --apply-log /data/backups/2017-07-14_22-32-11 --incremental-dir=/data/backups/2017-07-14_22-37-32
innobackupex --apply-log /data/backups/2017-07-14_22-32-11
innobackupex --copy-back /data/backups/2017-07-14_22-32-11
chown -R mysql:mysql /usr/local/mysql/data
/etc/rc.d/init.d/mysqld start
```

## 16.9 备份策略总结(生产建议)

| 场景 | 推荐方案 |
|---|---|
| 中小库(百 GB 内) | mysqldump `--master-data=2 --single-transaction` 每日全量 + binlog 增量 |
| 大库(要求恢复快) | Xtrabackup 每日全量 + 每几小时增量 + binlog,恢复快 |
| 从库备份 | 在从库执行备份(--dump-slave),不影响主库性能 |
| 时间点恢复 | 全量恢复 + mysqlbinlog 按时间/位置回放 |
| 自动备份 | 脚本 + crontab 定时 + rsync/异地存储,保留 N 天 |


---

# 第17课 MySQL 索引和调优

## 17.1 索引介绍

- **索引**是高效获取数据的最重要的数据结构,表数据越来越多时获取效率下降,**索引(键)可有效提升效率**。
- 理解方式:索引就像**书的目录**,查特定章节先看目录,比翻阅全书高效得多。
- **多字段索引,字段顺序非常重要**:MySQL 从**最左边开始匹配**,没有最左边字段则用不了索引。

### 索引优势与缺点
- 优势:① 大大减少服务器需要扫描的数据量 ② 帮助服务器避免排序和临时表 ③ 可将**随机 IO 变成顺序 IO**。
- 缺点:① 创建和维护索引耗费时间,随数据量增加 ② 索引文件占用物理空间 ③ insert/update/delete 时索引需**动态维护,降低 DML 效率**。

## 17.2 索引类型之 B-Tree 索引

- B-Tree 索引使用 B-Tree 数据结构存储;不同引擎使用方式不同:
  - **MyISAM**:使用**前缀压缩**使索引空间更小;索引中记录对应数据的**物理位置**;
  - **InnoDB**:按原数据格式存储;索引中记录对应的**主键数值**。
- B-Tree 所有值按顺序存储,每个叶子页到根的距离相同;深度和表大小直接相关。
- 查找流程:从根节点开始,比较节点页的值,按指针进入下层子节点,直到叶子节点(找到或找不到)。

### 适用查找(以 key(last_name, first_name, dob) 为例)
1. **全键值匹配**:`last_name='zhang' and first_name='san' and dob='1982-1-1'`
2. **匹配最左前缀**:`last_name='zhang'`(只用最左列)
3. **匹配列前缀**:`last_name like 'z%'`
4. **匹配范围值**:`last_name between 'li' and 'wang'`
5. **精确匹配左边列 + 范围匹配右边列**:`last_name='zhang' and first_name like 's%'`
6. **只访问索引的查询(覆盖索引)**:`select last_name,first_name from people where last_name='zhang'`(Extra: Using index)

### B-Tree 索引限制(面试重点)
- **不是从最左列开始**则无法使用:`where first_name='san'`、`where dob=...`、`where last_name like '%ang'` → type=ALL 全表扫描(possible_keys 为 NULL)。
- **跳过中间列**:如 `last_name='zhang' and dob=...` 只用最左列。
- **某列范围查找,其右边的列无法用索引优化**:`last_name='zhang' and first_name like 's%' and dob='1982-1-1'` 只能用到前两列。

## 17.3 索引类型之哈希索引

- **只有 Memory 引擎支持哈希索引**(Memory 也支持 B-Tree);基于哈希表实现,**只有精确匹配索引所有列的查询才有效**。
- 每行数据对索引列计算哈希码,索引中存放哈希码 + 行指针;哈希码相同的行以链表存放;**哈希冲突**时需遍历链表行指针比较行数据。
```sql
CREATE TABLE testhash (
  fname VARCHAR(50) NOT NULL,
  lname VARCHAR(50) NOT NULL,
  KEY USING HASH(fname)
) ENGINE=MEMORY;
```
- **InnoDB 指定 hash 索引也能创建成功,但底层依旧是 B-Tree**:`show indexes` 里 Index_type 显示 BTREE。

### 哈希索引限制
- 只存哈希值和行指针,**不存字段值** → 无法使用覆盖索引;
- 数据**不按索引值顺序存储** → 排序无法用索引;
- 用索引列**全部内容**计算哈希码 → 只有部分索引字段时无法使用;
- **只支持等值比较**(=、IN),**不支持范围查询**:`explain select * from testhash where fname>'a'` → type=ALL;`fname in ('a','b')` → range 可用。

## 17.4 索引类型之全文索引(FULLTEXT)

- 创建在 **char、varchar、text** 文本字段上,加速查询和 DML;不是直接比较索引值,而是**查找文本中的关键词**,更像搜索引擎。
- 使用语法:`MATCH(col1,col2,...) AGAINST (expr [search_modifier])`。
- search_modifier 取值:`IN NATURAL LANGUAGE MODE`(默认)、`IN NATURAL LANGUAGE MODE WITH QUERY EXPANSION`、`IN BOOLEAN MODE`、`WITH QUERY EXPANSION`。
```sql
CREATE TABLE article (
  id int(11) NOT NULL AUTO_INCREMENT,
  title char(255) NOT NULL,
  content text NULL,
  PRIMARY KEY (id),
  FULLTEXT (content)                          -- 建表时加
);
ALTER TABLE article ADD FULLTEXT index_content(content);        -- 修改表结构加
CREATE FULLTEXT INDEX index_content ON article(content);         -- 直接创建
-- 使用
SELECT * FROM article WHERE MATCH(content) AGAINST('关键词');
```

## 17.5 索引创建

### 创建索引的三种途径
```sql
-- ① 直接创建
CREATE INDEX index_name ON table(column(length));
CREATE INDEX idx_st_sname ON students(sname);
-- ② 修改表结构添加
ALTER TABLE table_name ADD INDEX index_name ON (column(length));
-- ③ 创建表时同时创建
CREATE TABLE `table` (
  id int(11) NOT NULL AUTO_INCREMENT,
  title char(255) NOT NULL,
  PRIMARY KEY (id),
  INDEX index_name (title(length))
);
-- 删除索引
DROP INDEX index_name ON table;
ALTER TABLE table_name DROP INDEX index_name;
```
- 说明:复合索引=包含多个字段;unique index 值不能重复;**fulltext 只能建在 InnoDB/MyISAM 的 char/varchar/text 字段**;索引可建在含 NULL 的字段上;`key_block_size` 指定 MyISAM 索引键 block 大小;`COMMENT 'string'` 给索引加最长 1024 的注释。

### 唯一索引
- 与普通索引类似,额外要求**数据唯一性**;**允许空值**;多列唯一索引要求列组合每行唯一,否则插入失败(`ERROR 1062 Duplicate entry`)。
```sql
CREATE UNIQUE INDEX indexName ON table(column(length));
ALTER TABLE table_name ADD UNIQUE indexName ON (column(length));
```

### 索引删除
```sql
DROP INDEX index_name ON table_name;
ALTER TABLE table_name DROP INDEX index_name;     -- 与上等价
ALTER TABLE table_name DROP PRIMARY KEY;          -- 主键索引只能用这种方式删除
```

### 索引查看
```sql
show create table students;        -- 基本索引信息
show index from students\G         -- 详细信息
SELECT * FROM information_schema.statistics WHERE table_name='students';
```

### show index 字段说明
| 字段 | 含义 |
|---|---|
| Table | 表名 |
| Non_unique | 0=不能有重复值(唯一索引),1=可以 |
| Key_name | 索引名 |
| Seq_in_index | 索引中的列序号(从 1 开始) |
| Column_name | 列名 |
| Collation | A=升序,NULL=无分类 |
| Cardinality | 索引中唯一值数目的**估计值**(ANALYZE TABLE 更新);基数越大,join 时越可能使用该索引 |
| Sub_part | 部分索引字符数;整列索引为 NULL |
| Packed | 索引压缩方式,未压缩为 NULL |
| Null | 列是否可含 NULL |
| Index_type | BTREE / FULLTEXT / HASH / RTREE |
| Comment | 索引注释 |

## 17.6 聚簇索引与辅助索引(重点)

- 每个 InnoDB 表都有一个**聚簇索引**,索引中包含所有行数据;聚簇索引和主键是一个意思的两种叫法。
- **聚簇索引的确定顺序**:
  1. 显式定义主键 → 主键即聚簇索引;
  2. 没有主键 → 找**非 NULL 的唯一索引**,第一个作为聚簇索引;
  3. 都没有 → InnoDB 内部创建**虚构的聚簇索引**(包含 row ID)。

### 聚簇索引优势
- 通过聚簇索引能**直接定位并访问表数据**,性能高;
- **相关数据保存在一起**(如按用户 ID 建聚簇索引,一个用户的所有邮件只读少量数据页);
- 覆盖索引扫描可直接使用叶节点上的主键值。
- 聚簇索引叶子节点包含**主键值、事务 ID、回滚指针(用于 MVCC)、其余列**;节点页只含索引列。

### 辅助索引(二级索引)
- 所有非聚簇索引都叫辅助索引;InnoDB 辅助索引每一行包含**对应的主键值 + 辅助索引值**。
- 查询流程:**先定位主键值 → 再到聚簇索引查找行数据**(二次查询)。
- 二级索引存主键值而非行指针 → **行移动或页分裂时无需更新二级索引**。

### MyISAM vs InnoDB 索引结构对比
| 对比项 | MyISAM | InnoDB |
|---|---|---|
| 数据存储 | 独立行存储,按插入顺序存磁盘 | 聚簇索引相当于表,无需独立行存储 |
| 主键索引 | 与其他索引结构相同(叶子存行指针/行号) | 聚簇索引,叶子存整行数据 |
| 辅助索引 | 叶子存行指针 | 叶子存**主键值** |
| 行定位 | 先索引找行号,再回表 | 辅助索引先找主键,再查聚簇索引 |

## 17.7 InnoDB 索引物理结构

- 物理结构是 B-Tree,所有索引数据在叶节点;**默认索引页大小 16KB**。
- 插入数据时 InnoDB **保留 1/16 的索引页空闲空间**供后续插入/修改;
- 创建/重建索引时 bulk 加载数据到索引页;索引页数据占比低于 **merge_threshold(默认 50%)** 时执行索引页合并并释放;
- `innodb_page_size` 可指定页大小(64K/32K/16K/8K/4K),**实例创建后无法修改**;复制数据文件和日志文件到其他实例必须**页大小一致**。

## 17.8 索引使用策略(优化原则)

### ① 索引建立在经常搜索的列上
- where 条件、表连接关联字段、排序字段;很少使用的列建索引弊大于利。

### ② 使用独立的列(索引列不能是表达式/函数的一部分)
```sql
explain select * from students where sid=1;        -- const,走主键索引
explain select * from students where sid+1=2;      -- ALL,用不了索引!
explain select * from students where abs(sid)=1;   -- ALL,用不了索引!
-- 避免在索引字段上使用函数
```

### ③ 前缀索引(长字符列)
- 字段很长时,在**列开头部分字符串**上建索引;**选择性**(不重复索引值/总记录数)越接近 1 越好,筛选数据越多。
- BLOB/TEXT/超长 varchar 要选合适前缀长度;缺点:不能用于 order by/group by,也不能覆盖扫描。
```sql
-- 评估各长度选择性
SELECT COUNT(DISTINCT city)/COUNT(*) FROM sakila.city_demo;           -- 0.0312
SELECT COUNT(DISTINCT LEFT(city, 5))/COUNT(*) FROM sakila.city_demo;  -- 0.0305
SELECT COUNT(DISTINCT LEFT(city, 7))/COUNT(*) FROM sakila.city_demo;  -- 0.0310
ALTER TABLE sakila.city_demo ADD KEY (city(7));
-- 前缀索引验证:where sname='zhang san' 走索引;order by sname 变 Using filesort(前缀索引不支持排序)
```

### ④ 多列索引(复合索引)
- **错误做法**:在所有条件字段上都建单独索引;正确:判断多列**组合**是否经常出现且筛选范围优于单索引,是则建复合索引。
```sql
create index ind_union on students(sname, dept_id, teacher_id);
```

### ⑤ 覆盖索引
- 语句所需数据**完全可通过索引获得**;explain 的 Extra 显示 **Using index**。
```sql
explain select count(*) from students where dept_id=1 and gender=2;
-- Extra: Using index(idx_union_1 覆盖)
```
- 优势:① 索引远小于数据行,减少数据访问量 ② 索引按列值顺序存储,范围查询 IO 少 ③ InnoDB 二级索引覆盖可**避免对主键的二次查询**。
- 限制:覆盖索引必须存储索引列值,**只有 B-Tree 能用**(哈希/空间/全文索引不存列值)。

### ⑥ 索引列顺序选择(B-Tree)
- 复合索引列顺序很重要,**基于全局基数和选择性决定**:选择性高的列放前面(先过滤掉大部分无用数据)。
- 例:`where staff_id=? and customer_id=?`,若 customer_id 选择性更高则作为第一列。

## 17.9 索引统计信息

- 优化器通过两个 API 了解索引值分布;统计信息不准确时优化器可能做出错误决定 → 用 `analyze table` 重新生成。
- InnoDB 通过**抽样**计算统计信息(随机读少量索引页),参数 `innodb_stats_sample_pages`(默认 8)控制样本页数量。
- 触发重新计算:表首次打开、执行 analyze table、**表大小变化超过 1/16**。
- 5.6+ 可用 `innodb_analyze_is_persistent` 持久化统计信息。

## 17.10 索引碎片处理

- 数据增删改导致 B-Tree 索引碎片化,降低查询效率(碎片无序存储)。
- 处理:① `optimize table` 重新整理 ② 导出再导入重置数据 ③ 索引删除重建/rebuild ④ 不支持 optimize 的引擎:`alter table table_name engine=<原引擎>` 重建表。

## 17.11 Explain 执行计划(重点)

- 显示语句在 MySQL 中如何执行;对 **select/delete/update/insert/replace** 有效。

> **8.0 增强提示**:8.0 提供 `EXPLAIN FORMAT=TREE`(树形展示,不实际执行)与 `EXPLAIN ANALYZE`(真实执行并输出每步耗时/行数,8.0.18+),定位慢 SQL 更直观,详见第 19 课 19.7。
```sql
explain select count(*) from company_tmp;
-- +----+-------------+-------------+------+---------------+------+---------+------+---------+-------+
-- | id | select_type | table       | type | possible_keys | key  | key_len | ref  | rows    | Extra |
```

### 各列含义
| 列 | 说明 |
|---|---|
| id | 执行顺序:值越大优先级越高;值相同从上而下执行 |
| select_type | simple(无 union/子查询的简单查询);primary(最外层);union(union 第二个以后的表);dependent union(受外部查询影响);union result(union 结果集,id 为 NULL);subquery(from 之外出现的子查询);dependent subquery(受外部影响);derived(from 中的子查询/派生表) |
| table | 查询的表名/别名;`<derived N>` 表示来自 id=N 查询产生的临时表;`<union M,N>` 表示 union 结果集 |
| type | **访问类型,性能从低到高:ALL → index → range → ref → eq_ref → const, system → NULL** |
| possible_keys | 可能使用的索引(不一定会用) |
| key | 实际使用的索引;没用显示 NULL |
| key_len | 索引中使用字节数 |
| ref | 等值查询显示 const;连接查询显示驱动表关联字段;表达式/函数/隐式转换显示 func |
| rows | 估算需读取的行数 |
| Extra | Using index(覆盖索引)/ Using where(后过滤)/ Using temporary(临时表,常见于排序分组)/ Using filesort(文件排序,order by/group by 无法用索引时) |

### type 详解(面试高频)
- **ALL**:Full Table Scan,遍历全表;
- **index**:Full Index Scan,只遍历索引树(比 ALL 好,但仍全索引);
- **range**:索引范围扫描,常见 between、<、> 等;
- **ref**:非唯一性索引扫描,返回匹配某个单独值的所有行(非唯一索引/唯一索引的非唯一前缀);
- **eq_ref**:唯一性索引扫描,每个索引键只匹配一条记录(主键/唯一索引的多表连接);
- **const**:唯一索引或主键等值查询,一定返回 1 行;
- **system**:表中只有一行/空表(仅 MyISAM/Memory;InnoDB 通常是 all/index);
- **NULL**:优化时分解语句,执行时不用访问表或索引。

## 17.12 调优实战规则(重点)

### 优化规则 1:尽可能消除全表扫描(表数据 < 1 万条除外)
- `count(*)` 无主键 → ALL,扫描 190 万行耗时 0.73s;
- 加主键后(`alter table company_tmp modify cid int not null primary key`)→ type=index、**Using index**(只扫索引),耗时 0.32s,快一倍。

### 优化规则 2:增加适当索引的基本规则
1. 加在 **where 条件**上;
2. 加在**表之间 join 的键值**上;
3. 查询范围是少量字段时考虑**覆盖索引**(仅走索引);
4. 多个查询条件时考虑**复合索引,最常用字段放前面**;
5. **不要将索引加在区别率不高的字段上**(如 status:active 占比 99%,force index 反而全表扫,2.95s > 无索引 0.69s);
6. 字段上加了函数,索引用不了,考虑改变写法。

- **where 加索引对比**:cname 等值查询,无索引 ALL(0.65s)→ 有索引 ref(0.00s);
- **join 键值加索引对比**:200 万行 join,无索引 48.30s → 有索引 10.13s;
- **函数坏索引案例**:`DATE_FORMAT(me.birthday,'%c-%d') IN ('1-07')` 用不了索引 → 解决:新增冗余字段 `birthday_md varchar(10)` 存月份+日期并建索引。

### 优化规则 3:去掉不影响查询结果的表
- 示例 join 3 张表(QZ_MEMBER 实际用不到)→ 去掉该表,**效率提高 10 倍以上**。

## 17.13 慢查询日志

```ini
# my.cnf
slow_query_log = on                     # 开启
slow_query_log_file = /server/mysql/slow.log   # 日志位置
long_query_time = 2                     # 2 秒以上语句记录
```
- 日志内容示例:
```
# Time: 160816 12:04:15
# User@Host: root[root] @ [117.122.208.4]
# Query_time: 15.820842  Lock_time: 0.000106  Rows_sent: 999  Rows_examined: 1005
SET timestamp=1471320255;
SELECT * FROM product_for_mongo where product_id>(select begin_id from process_log ...);
```
- 分析要点:Query_time(执行时间)、Rows_examined(扫描行数)、Rows_sent(返回行数);配合 explain 定位问题 SQL。

## 17.14 课堂调优练习(500 万行压测)

```sql
-- 造数存储过程(50 万行)
delimiter //
CREATE PROCEDURE `proc_students`()
Begin
  Declare n int default 1;
  while n<=500000 do
    Insert into students values(n, concat('zhang san',n), floor(1+rand()*2), floor(1+rand()*4));
    Set n=n+1;
  End while;
End//
delimiter ;
```

### 测试结论汇总
| 测试 | 结果 |
|---|---|
| 所有字段建索引 vs 无索引插入 | 36.45s vs 25.08s(索引拖慢 DML 约 45%) |
| 关闭 autocommit vs 开启 | 25.08s vs 18分25s(**不关 autocommit 插入慢 44 倍**,每次提交刷盘) |
| 无索引 vs 有索引点查(sid=10000) | 0.24s(ALL, rows 498597)vs 0.00s(const, rows 1) |
| 区别度不高字段(gender=1 查 25 万行) | 有无索引耗时接近(1.85s vs 1.93s),别在低区分度字段建索引 |
| 索引查绝大多数数据(sid>1 查 50 万行) | 0.12s,type 仍走索引(全索引扫描) |
| join 关联字段有/无索引 | 0.10s(ref, Using index)vs 0.31s(ALL, Using join buffer) |

### 核心调优口诀
1. 建索引优先:where 条件、join 关联键、覆盖索引、复合索引最左前缀;
2. 避免:函数/表达式包索引列、低区分度字段建索引、select * 大字段、不带 where 的查询;
3. 大批量插入务必关 autocommit(事务包裹);
4. 慢 SQL 定位:慢查询日志 + explain(看 type/rows/Extra)。


---

# 第18课 MySQL 常见错误大全

## 18.1 ERROR 1040: Too many connections(连接数超限)

- 发生条件:已有 **max_connections** 个客户端连接了 mysqld 服务器。
- 解决:重启 mysqld(用更大的 max_connections 变量值),或动态调整后重启。
- **mysqld 实际允许 (max_connections+1) 个连接**,最后一个连接是为**管理员权限用户保留**的(不一般不给普通用户),管理员可登录后用 `SHOW PROCESSLIST` 排查问题。
- 实验(my.cnf 配 max_connections=5,开 6 个窗口):
  - 前 5 个连接成功;
  - 第 6 个:root 连接**成功**(保留的管理员连接),普通用户 cdq 连接**报 ERROR 1040**;
  - root 建**第 7 个连接**也报 `ERROR 1040 (HY000): Too many connections`(已用掉 6 个)。

## 18.2 Packet too large(包太大)

- mysql 用 `max_allowed_packet` 参数限制 server 接受的数据包大小;**当数据包超过该值时,报 Packet too large 错误并终止连接**。
- 解决:`mysqld` 命令行或 my.cnf 设置更大值,如存全长 BLOB 时 `max_allowed_packet=24M`;取值范围 **1024B ~ 1GB**。
```sql
set global max_allowed_packet=1024;   -- 重新连接生效
insert into students values(21,repeat('ab',1000),1,1);
-- ERROR 1301 (HY000): Result of repeat() was larger than max_allowed_packet (1024) - truncated
```

## 18.3 忘记 root 口令的重置方法

1. my.cnf 添加 `skip-grant-tables=1`,重启 mysqld;
2. 免密登录,执行:
```sql
mysql> flush privileges;
mysql> grant all privileges on *.* to root@'localhost' identified by 'mysql2';
```
3. 去掉 `skip-grant-tables=1`,重启 mysqld 后用新密码登录。

## 18.4 权限相关错误(1044/1045/1141/1142/1143)

| 错误 | 含义 |
|---|---|
| 1044 | 当前用户没有访问**数据库**的权限 |
| 1045 | 不能连接数据库,用户名或密码错误 |
| 1141 | 当前用户无权访问数据库 |
| 1142 | 当前用户无权访问**数据表** |
| 1143 | 当前用户无权访问数据表中的**字段** |

```sql
grant select on course.students to cdq@'localhost' identified by 'mysql';
grant select(id) on course.dept to cdq@'localhost';
-- 登录测试:
mysql -u cdq -p -D test
-- ERROR 1044 (42000): Access denied for user 'cdq'@'localhost' to database 'test'
mysql> select * from score;
-- ERROR 1142 (42000): SELECT command denied to user 'cdq'@'localhost' for table 'score'
mysql> select dept_name from dept;
-- ERROR 1143 (42000): SELECT command denied to user 'cdq'@'localhost' for column 'dept_name' in table 'dept'
```

## 18.5 1062 Duplicate entry(主键/唯一键重复)

- 索引是 primary/unique 时,字段必须保证唯一,否则报错。
```sql
insert into students values(1,'b',2,2);
-- ERROR 1062 (23000): Duplicate entry '1' for key 'PRIMARY'
insert into students values(2,'a',2,2);
-- ERROR 1062 (23000): Duplicate entry 'a' for key 'idx_sname'
```

## 18.6 1060 / 1050:重复列、重复表

```sql
alter table students add sname varchar(20);
-- ERROR 1060 (42S21): Duplicate column name 'sname'

create table students(id int);
-- ERROR 1050 (42S01): Table 'students' already exists
create table if not exists students(id int);   -- 用 if not exists 避免
```

## 18.7 Account lock:账号被锁定(3118)

```sql
alter user cdq@localhost account lock;
-- 登录报:
-- ERROR 3118 (HY000): Access denied for user 'cdq'@'localhost'. Account is locked.
select host,user,account_locked from mysql.user where user='cdq';  -- account_locked: Y
alter user cdq@localhost account unlock;      -- 解锁
```

## 18.8 ERROR 1205: Lock wait timeout exceeded(锁等待超时)

- 锁等待超时时间由 `innodb_lock_wait_timeout` 控制(默认 50 秒)。
```sql
-- Session 1:
set autocommit=0;
update dept set dept_name='abc';          -- 持锁未提交
-- Session 2:
update dept set dept_name='bcd';          -- 等待 50 秒后:
-- ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction
```

## 18.9 ERROR 2002: 无法通过 socket 连接

```
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)
```
- 原因:① MySQL 服务器没启动;② 服务器启动了但找不到 socket 文件(socket 被删)。
- 两种连接方式:**TCP/IP**(需指定 host+port)和 **socket**(本地连接,host 为空或 localhost,port 修改也不影响)。
- 处理:新装 MySQL 搜索并指定正确位置(`socket = /tmp/mysql.sock`);误删 sock 则重启 mysql 服务自动重新生成。
```bash
[root@master tmp]# mv mysql.sock mysql.sock_bak
[root@master tmp]# mysql -u root -p     # ERROR 2002
[root@master tmp]# mysql -u root -p -h 127.0.0.1 -P 3308   # TCP 方式仍可连接
[root@master tmp]# /etc/init.d/mysql.server restart        # 重启后自动生成 mysql.sock
```

## 18.10 启动失败:The server quit without updating PID file

- 日志 `log-error=...` 排查,常见是**文件权限问题**:
```
mysqld: File './mysql-bin.index' not found (Errcode: 13 - Permission denied)
```
- 解决:`chown mysql:mysql data -R` 后重新启动成功。

## 18.11 环境变量未设置:command not found

```bash
-bash: mysqldump: command not found
# 临时添加:
export PATH=$PATH:/usr/local/mysql/bin
# 永久设置:编辑 ~/.bash_profile 添加后 source 生效
PATH=$PATH:$HOME/bin:/usr/local/mysql/bin
export PATH
```

## 18.12 1451 / 1452:外键约束失败

| 错误 | 含义 |
|---|---|
| 1451 | 删除或修改**主表**记录失败(有子表引用) |
| 1452 | 更新**子表**记录失败(外键值在主表不存在) |

```sql
update dept set id=5 where id=4;
-- ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails
delete from dept where id=3;                    -- ERROR 1451
update students set dept_id=6 where sid=1;      -- ERROR 1452: child row
```

## 18.13 ERROR 1052: 列不明确(ambiguous)

- join 查询时两表都有同名列,必须加表别名限定。
```sql
select sid,sname,score from students a inner join score b on a.sid=b.sid;
-- ERROR 1052 (23000): Column 'sid' in field list is ambiguous
-- 解决:select a.sid,a.sname,b.score ...
```

## 18.14 ERROR 1068: Multiple primary key defined(多个主键)

- 一个表只能有一个主键。
```sql
alter table students add primary key(sname);
-- ERROR 1068 (42000): Multiple primary key defined
```

## 18.15 SQL 模式(sql_mode)

- MySQL 可以以不同 SQL 模式操作,也可为不同客户端应用不同模式;模式定义**支持哪些 SQL 语法、执行哪种数据验证检查**。
- 设置方式:my.cnf `sql_mode="modes"` 或 `SET [SESSION|GLOBAL] sql_mode='modes'`;查看 `SELECT @@sql_mode`。
- 默认(5.7):`STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION`(即"严格模式")。

### 主要 sql_mode 值
| 模式 | 作用 |
|---|---|
| ANSI | 语法行为更符合标准 SQL(宽松,非法值变警告) |
| STRICT_TRANS_TABLES | 事务引擎启用严格模式:非法或丢失值**报错并回滚**,而不是警告 |
| STRICT_ALL_TABLES | 对非事务引擎也严格 |
| TRADITIONAL | 传统模式:非法值**报错而非警告**(= STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER) |
| ERROR_FOR_DIVISION_BY_ZERO | 除零报错(否则为警告/返回 NULL) |
| NO_ENGINE_SUBSTITUTION | 所需存储引擎被禁用时不自动替换 |
| ONLY_FULL_GROUP_BY | 查询 select 列必须被 group by 或聚合,否则报错 |

### 严格模式 vs ANSI 实验
```sql
-- 默认严格模式:gender 传 'a' 报错
insert into students values(6,'ab','a',1);
-- ERROR 1366 (HY000): Incorrect integer value: 'a' for column 'gender'
-- ANSI 模式:警告并自动转成 0 插入
set session sql_mode='ANSI';
insert into students values(6,'ab','a',1);   -- Query OK, 1 warning
select * from students where sid=6;          -- gender: 0

-- 默认:数据超长报错
insert into students values(5,'abcdef',1,1);
-- ERROR 1406 (22001): Data too long for column 'sname'
-- ANSI:截断插入
insert into students values(6,'abcdef',1,1);  -- 存入 abcde

-- 除零实验
insert into students values(7,'a',1/0,1);     -- 默认模式:gender=NULL
set session sql_mode='STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION,ERROR_FOR_DIVISION_BY_ZERO';
insert into students values(8,'a',1/0,1);
-- ERROR 1365 (22012): Division by 0

-- ONLY_FULL_GROUP_BY
select sid,sname,count(*) from students group by sname;
-- ERROR 1055: ... not in GROUP BY clause ... incompatible with sql_mode=only_full_group_by
```

## 18.16 ERROR 1242: 子查询返回 1 行以上

```sql
select * from dept where id=(select dept_id from students);
-- ERROR 1242 (21000): Subquery returns more than 1 row
-- 解决:用 in
select * from dept where id in (select dept_id from students);
```

## 18.17 ERROR 1213: 死锁(Deadlock)

- 多个事务互相持有对方需要的锁,MySQL 检测后牺牲一个事务。
```sql
-- session1:                     session2:
set autocommit=0;                set autocommit=0;
update students set sname='b' where sid=1;
                                 update students set sname='bc' where sid=2;
update students set sname='cd' where sid=2;   -- 阻塞
                                 update students set sname='ac' where sid=1;
-- session2 报:
-- ERROR 1213 (40001): Deadlock found when trying to get lock; try restarting transaction
```
- 预防:事务尽量短、按相同顺序访问资源、合理设计索引减少锁范围。

## 18.18 ERROR 1449: definer 不存在

- 存储过程/触发器等对象有 **DEFINER(定义者)** 属性;当前数据库没有这个用户权限时执行会报错。
- 两种 SQL SECURITY 取值:
  - **definer**(默认):执行前验证 definer 用户(如 `cdq@127.0.0.1`)是否存在且有权限,否则报错;
  - **invoker**:执行时判断**调用者**是否有权限,否则报错。
- 解决:
```sql
alter procedure proc1 sql security invoker;   -- 改成调用者权限
```
```bash
# 或者 Shell 脚本替换 definer(如把 DEFINER=`cdq`@`127.0.0.1` 替换掉)
```
- 典型报错:`ERROR 1449 (HY000): The user specified as a definer ('cdq2'@'localhost') does not exist`(备份文件导到其他实例,原 definer 用户不存在);同时触发器也需要先 drop 后重建(触发器无法改 security)。

## 18.19 ERROR 1553: 不能删除外键相关索引

- 删除的索引如果是**外键相关的**,直接删除失败,须**先删外键再删索引**。
```sql
drop index dept_id on students;
-- ERROR 1553 (HY000): Cannot drop index 'dept_id': needed in a foreign key constraint
alter table students drop foreign key students_ibfk_1;   -- 先删外键
drop index dept_id on students;                          -- 再删索引 OK
```

## 18.20 ERROR 1075: 自增列定义错误

- **自增列必须被定义为表的主键或唯一键**。
```sql
create table temp1(id int auto_increment,name varchar(10));
-- ERROR 1075 (42000): Incorrect table definition; there can be only one auto column
-- and it must be defined as a key
create table temp1(id int auto_increment primary key,name varchar(10));  -- OK
```

## 18.21 ERROR 1356: 视图引用失效

- 视图依赖的表/列被修改或删除后,查询视图报错。
```sql
create view view_1 as select * from temp1;
alter table temp1 drop column name;
select * from view_1;
-- ERROR 1356 (HY000): View 'course.view_1' references invalid table(s) or column(s)
-- or function(s) or definer/invoker of view lack rights to use them
```

## 18.22 用户资源限制

- MySQL 可对**每个用户**做资源限制:
  | 参数 | 含义 |
  |---|---|
  | MAX_QUERIES_PER_HOUR | 一小时可执行查询次数(基本包含所有语句) |
  | MAX_UPDATES_PER_HOUR | 一小时可执行修改次数(仅修改数据库/表的语句) |
  | MAX_CONNECTIONS_PER_HOUR | 一小时可连接 MySQL 的次数 |
  | MAX_USER_CONNECTIONS | 同一时间可连接 MySQL 实例的数量 |
- 设置/修改:
```sql
CREATE USER 'cdq3'@'localhost' IDENTIFIED BY 'mysql'
WITH MAX_QUERIES_PER_HOUR 20
     MAX_UPDATES_PER_HOUR 10
     MAX_CONNECTIONS_PER_HOUR 5
     MAX_USER_CONNECTIONS 2;
ALTER USER 'cdq3'@'localhost' WITH MAX_QUERIES_PER_HOUR 100;   -- 修改
ALTER USER 'cdq3'@'localhost' WITH MAX_CONNECTIONS_PER_HOUR 0;  -- 置 0 取消限制
```
- 注意:**当用户级 max_user_connections 非 0 时,忽略全局参数 max_user_connections,反之全局参数生效**。
- 报错示例:
```
ERROR 1226 (42000): User 'cdq3' has exceeded the 'max_user_connections' resource (current value: 2)
ERROR 1226 (42000): User 'cdq3' has exceeded the 'max_connections_per_hour' resource (current value: 5)
```

## 18.23 数据误操作后的恢复(三种方式)

- 误删/误改表数据后的恢复,**取决于备份手段**:
  1. **通过 mysqldump 备份恢复**;
  2. **通过 replication 延迟复制恢复**;
  3. **通过 xtrabackup 全量备份恢复**。

### 方式一:mysqldump 恢复(单表)
```bash
# 全量备份
mysqldump -u root -p course>course.sql
# 误删除:
mysql> delete from students;
# ① 用 awk 从全备份中提取 students 表部分
awk '/^-- Table structure for table `students`/,/^-- Table structure for table `teacher`/{print}' course.sql > students.sql
# ② 删除 students.sql 中 drop/create table 语句,仅保留 insert 语句
# ③ 导入
mysql -u root -p; use course; source students.sql;
```
- 若全量备份后还有**正确的修改插入**,则还需从 binlog 中把备份之后的操作提取出来重放:
```bash
mysqlbinlog -v mysql-bin.000016 > a.log
# 取出其中 students 表的 INSERT 语句(参考 ### @1=100 行级信息)
# 转成标准 SQL 执行:
INSERT INTO `course`.`students` values(100,'ab',1,1);
INSERT INTO `course`.`students` values(101,'ab',1,1);
```

### 方式二:延迟复制恢复
```sql
-- 配置延迟复制(延迟 2 小时):
mysql> stop slave;
mysql> CHANGE MASTER TO MASTER_DELAY = 7200;
mysql> start slave;
-- 主库误删除 students3(从库还有 2 小时前的数据)
-- ① 关闭从库复制
mysql> stop slave;
-- ② 从库导出该表
[root@slave1 ~]# mysqldump -u root -p --no-create-info course students3 > students3.sql
-- ③ 传回主库并导入
mysql> source students3.sql;
-- ④ 从库重置复制关系
mysql> reset slave all;
```

### 方式三:xtrabackup 全量恢复(见第 16 课 16.8)

## 18.24 复制同步跳过临时错误

### 非 GTID 模式:SQL_SLAVE_SKIP_COUNTER
```sql
mysql> stop slave;
mysql> set GLOBAL SQL_SLAVE_SKIP_COUNTER=N;    -- N 代表 binlog 中 event 个数
mysql> start slave;
```
- **N 是 event 个数而非事务个数**:row 格式下一条 insert 可能有 5 个 event,`SET GLOBAL SQL_SLAVE_SKIP_COUNTER=5` 只跳过一个事务;事务类型不同可能要执行几次。
- 实验:从库 insert `(3,1,86)`,主库 insert `(3,1,88)`、`(3,2,88)` → 主从报错;从库执行 `set global SQL_SLAVE_SKIP_COUNTER=5` 跳过冲突事务,主库第二条插入正常同步过来。

### GTID 模式:跳过报错事务(重点)
- **GTID 模式下 SQL_SLAVE_SKIP_COUNTER 不可用**:
```
ERROR 1858 (HY000): sql_slave_skip_counter can not be set when the server is running
with @@GLOBAL.GTID_MODE = ON. Instead, for each transaction that you want to skip,
generate an empty transaction with the same GTID as the transaction
```
- 正确做法:从 `show slave status\G` 查看出错事务的 GTID,然后**用空事务占位**:
```sql
mysql> stop slave;
mysql> SET SESSION GTID_NEXT= 'f2ae5ebe-68a2-11e7-91e9-000c298d7ee3:3';  -- 出错事务 GTID
mysql> BEGIN; COMMIT;                          -- 空事务占位
mysql> SET SESSION GTID_NEXT = AUTOMATIC;      -- 恢复自动
mysql> start slave;
```


---

# 第19课 MySQL 8.0 新特性实战

> **一句话本质:8.0 用"数据字典 + 原子 DDL + 官方高可用(MGR/Clone)"重写了 MySQL 的底层架构,并带来一批 SQL 语法增强。**

## 19.1 8.0 架构级变化(底层重写)

| 变化 | 5.x 时代 | 8.0 时代 | 影响 |
|---|---|---|---|
| 数据字典 | 表结构存 `.frm` 文件、系统表多为 MyISAM | 统一存入 InnoDB 表 `mysql.ibd`,`.frm` 文件彻底移除 | DDL 原子化、information_schema 实时准确 |
| DDL 原子性 | 部分 DDL 失败会残留半成品 | **原子 DDL**:DDL 要么全成功要么全回滚 | 不再出现"表结构改了一半"的脏状态 |
| redo log | `ib_logfile0/1`,由 `innodb_log_file_size` 控制 | 8.0.30 起改由 `innodb_redo_log_capacity`(默认 100MB)控制,文件在 `#innodb_redo` 目录(默认 32 个),可在线调整;旧参数 8.0.34 起废弃 | 大事务/大写入不再频繁阻塞 checkpoint |
| undo 表空间 | 固定 1 个 `ibdata1` 内 | 默认独立 2 个 `undo_001/undo_002`,可自动增长/回收 | 减少 ibdata1 膨胀,支持在线截断 |
| 默认字符集 | `latin1` | **`utf8mb4`**(排序规则 `utf8mb4_0900_ai_ci`,基于 UCA 9.0) | 彻底解决 emoji/生僻字乱码 |
| 默认认证插件 | `mysql_native_password` | **`caching_sha2_password`** | 密码安全增强,老客户端需兼容处理(见 22.10) |
| 默认 sql_mode | 5.7 起 `ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,...` | 8.0 保持严格模式并移除部分旧值(`NO_AUTO_CREATE_USER` 等) | 宽松模式写进去的"脏数据"8.0 会报错 |
| 查询缓存 | 有(5.7 已废弃) | **彻底移除** | 依赖 `query_cache` 的应用/参数直接失效 |
| 内部临时表 | MEMORY 引擎 | **TempTable 引擎**,由 `temptable_max_ram` 控制内存上限 | 大数据量排序/去重更稳,不再轻易"磁盘临时表爆掉" |
| 系统函数 | `PASSWORD()/ENCRYPT()/OLD_PASSWORD()` 可用 | 全部移除 | 老备份/脚本若用到会报错 |
| 升级工具 | 手动 `mysql_upgrade` | 8.0.16 起**启动时自动检查并升级数据字典**;`mysql_upgrade` 8.0.34 起废弃 | 升级流程大幅简化(见第 22 课) |

## 19.2 窗口函数(8.0 杀手级新特性)

**一句话本质:让"每组内排名/滚动计算"不用再写复杂的自连接或变量,一行 OVER() 搞定。**

```sql
-- 语法:函数() OVER (PARTITION BY 分组 ORDER BY 排序 [frame])
-- 例:按部门分组,给员工按薪资排名
SELECT dept_id, emp_name, salary,
       ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS 排名
FROM emp;
```

常用窗口函数速查:

| 类别 | 函数 | 说明 |
|---|---|---|
| 排名 | `ROW_NUMBER()` | 不并列,1,2,3... |
| 排名 | `RANK()` | 并列留空:1,1,3 |
| 排名 | `DENSE_RANK()` | 并列不留空:1,1,2 |
| 排名 | `NTILE(n)` | 分成 n 桶,常用于分页/抽样 |
| 取值 | `LAG(col,n)` / `LEAD(col,n)` | 取前/后第 n 行(环比、同比核心) |
| 取值 | `FIRST_VALUE()` / `LAST_VALUE()` | 窗口内首/末值 |
| 统计 | `SUM()/AVG()/COUNT()` 配 OVER | 移动平均、累计求和(配 `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`) |
| 分布 | `CUME_DIST()` / `PERCENT_RANK()` | 累计分布/百分比排名 |

**典型应用(面试高频)**:

```sql
-- 1. 每部门薪资最高的员工(取每组第 1 名)
SELECT * FROM (
  SELECT dept_id, emp_name, salary,
         ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) rn
  FROM emp
) t WHERE rn = 1;

-- 2. 环比:本月 vs 上月销售额
SELECT ym, amount,
       amount - LAG(amount) OVER (ORDER BY ym) AS 环比差额
FROM sales_month;

-- 3. 累计求和(销售额逐月累计)
SELECT ym, amount,
       SUM(amount) OVER (ORDER BY ym ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 累计
FROM sales_month;
```

## 19.3 CTE 公共表表达式(8.0)

**一句话本质:把一段子查询"命名"出来,后面反复引用,复杂 SQL 立刻可读;递归 CTE 能干"查树/查层级"这种传统 SQL 办不到的事。**

```sql
-- 非递归:WITH 定义临时结果集(仅当前语句有效)
WITH dept_avg AS (
  SELECT dept_id, AVG(salary) avg_sal FROM emp GROUP BY dept_id
)
SELECT e.*, d.avg_sal
FROM emp e JOIN dept_avg d ON e.dept_id = d.dept_id;

-- 递归:生成 1~10 的数字表(递归必须带 UNION [ALL] 和终止条件)
WITH RECURSIVE num AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM num WHERE n < 10
)
SELECT * FROM num;

-- 递归典型场景:查询组织架构树(向下找所有子孙部门)
WITH RECURSIVE dept_tree AS (
  SELECT dept_id, dept_name, parent_id, 1 AS lvl FROM dept WHERE parent_id = 0
  UNION ALL
  SELECT d.dept_id, d.dept_name, d.parent_id, t.lvl + 1
  FROM dept d JOIN dept_tree t ON d.parent_id = t.dept_id
)
SELECT * FROM dept_tree;
```

> 注意:递归 CTE 必须有 `UNION [ALL]` + 递归终止条件(`WHERE n < 10`),否则死循环;8.0 对递归深度受 `cte_max_recursion_depth` 限制(默认 1000)。

## 19.4 角色管理(Role)

**一句话本质:角色 = 一篮子权限的"模板",把权限授给角色、再把角色授给用户,批量授权/回收一步到位(类似 Linux 用户组)。**

```sql
-- 1. 创建角色并授权
CREATE ROLE 'app_ro', 'app_rw';
GRANT SELECT, INSERT, UPDATE, DELETE ON appdb.* TO 'app_rw';
GRANT SELECT ON appdb.* TO 'app_ro';

-- 2. 角色授予用户(用户同时拥有自身权限 + 角色权限)
GRANT 'app_rw' TO 'zhangsan'@'%';
GRANT 'app_ro' TO 'lisi'@'%';

-- 3. 激活角色:默认登录不生效,需指定
SET DEFAULT ROLE 'app_rw' FOR 'zhangsan'@'%';   -- 登录自动激活
SET ROLE 'app_rw';                               -- 本次会话临时激活
SET ROLE NONE;                                   -- 停用所有角色
SET ROLE ALL;                                    -- 激活全部角色

-- 4. 查看
SELECT CURRENT_ROLE();                -- 当前激活的角色
SHOW GRANTS FOR 'zhangsan'@'%';       -- 只看自身权限
SHOW GRANTS FOR 'zhangsan'@'%' USING 'app_rw';  -- 含角色权限全貌
```

> 角色本质是 `mysql.role_edges` 里的授权关系,可以理解为"用户套用户"的权限继承;`CREATE USER ... DEFAULT ROLE` 也可在建用户时指定。

## 19.5 在线 DDL 增强:INSTANT 秒级加列(8.0.12+)

**一句话本质:8.0 的 `ALTER TABLE ... ADD COLUMN` 默认可以做到"只改元数据、不动数据文件",几十亿行大表加列也是毫秒级。**

```sql
ALTER TABLE big_table ADD COLUMN remark VARCHAR(50) DEFAULT '';

-- 显式指定算法(失败会直接报错,不会悄悄退化成拷贝)
ALTER TABLE big_table ADD COLUMN age INT ALGORITHM=INSTANT;
```

各 DDL 算法对比(面试常问):

| 算法 | 说明 | 是否锁表 | 适用 |
|---|---|---|---|
| `INPLACE` | 原地修改(部分仍需短暂 MDL 锁) | 大多数支持并发 DML | 加/删索引、修改列默认值等 |
| `INSTANT` | 只改数据字典,秒级 | 否 | 8.0.12+ **加列(末尾)**、8.0.29+ 任意位置加列、加/删索引等 |
| `COPY` | 建新表拷贝数据 | 是(需读锁) | 兜底方案,尽量别用 |

> 一次 `ALTER` 尽量合并多个操作(8.0 支持一条 ALTER 里组合多步),减少重建次数。

## 19.6 直方图 / 不可见索引 / 函数索引 / CHECK 约束

### 直方图(8.0)
**本质:给优化器"喂"列的数据分布统计,让不走索引的大表也能选对执行计划。**

```sql
ANALYZE TABLE emp UPDATE HISTOGRAM ON salary WITH 100 BUCKETS;
ANALYZE TABLE emp UPDATE HISTOGRAM ON city, age;          -- 多列
SELECT * FROM information_schema.COLUMN_STATISTICS \G      -- 查看
```

> 适用:不适合建索引的列(基数低、取值少但查询频繁),用直方图代替索引,避免优化器"误判为全表扫描更快"。

### 不可见索引(8.0)
**本质:索引还在,但优化器"看不见它",用来无风险地验证"删掉这个索引行不行"。**

```sql
ALTER TABLE emp ALTER INDEX idx_age INVISIBLE;   -- 隐藏
ALTER TABLE emp ALTER INDEX idx_age VISIBLE;     -- 恢复
-- 即使隐藏,也可用开关让优化器临时使用
SET SESSION optimizer_switch = 'use_invisible_indexes=on';
```

### 函数索引(8.0.13+)
**本质:对列做函数运算后,普通索引就失效了,函数索引让"索引列 = 表达式"直接命中。**

```sql
-- 错误写法(索引失效):WHERE LOWER(name)='tom' 用不到 idx_name
-- 正确做法:直接建"表达式索引"
CREATE INDEX idx_lower_name ON emp ((LOWER(name)));
SELECT * FROM emp WHERE LOWER(name) = 'tom';     -- 现在能走索引
```

### CHECK 约束(8.0.16 起真正生效)
**本质:8.0.16 之前 CHECK 写了也白写(只解析不执行),8.0.16 起强制执行。**

```sql
CREATE TABLE student (
  id INT PRIMARY KEY,
  age TINYINT,
  score DECIMAL(5,2),
  CONSTRAINT chk_age CHECK (age BETWEEN 0 AND 150),
  CONSTRAINT chk_score CHECK (score >= 0 AND score <= 100)
);
INSERT INTO student VALUES (1, 200, 99);   -- 报错:CHECK constraint 'chk_age' is violated
```

## 19.7 EXPLAIN ANALYZE 真实执行计划(8.0.18+)

**一句话本质:EXPLAIN 是"猜"的,EXPLAIN ANALYZE 是"真跑一遍"并把每步耗时、行数、循环次数打出来,定位慢 SQL 精确到行。**

```sql
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 12345 ORDER BY id LIMIT 10;
```

输出形如(重点看 `actual time` 和 `actual rows`):
```
-> Limit: 10 row(s)  (actual time=0.123..0.124 rows=10 loops=1)
   -> Sort: orders.customer_id  (actual time=0.123..0.123 rows=10 loops=1)
      -> Index lookup on orders using idx_customer (customer_id=12345)
         (actual time=0.012..0.015 rows=10 loops=1)
```

> 注意:EXPLAIN ANALYZE 会**真的执行语句**(DML 慎用,建议先包一层 WHERE 过滤或改成 SELECT 同计划),生产环境用 `EXPLAIN FORMAT=TREE` 看计划但不执行。

## 19.8 参数持久化 SET PERSIST(8.0)

**一句话本质:以前 `SET GLOBAL` 改完重启就丢,8.0 的 `SET PERSIST` 改完自动写进 `mysqld-auto.cnf`,重启还在。**

```sql
SET PERSIST max_connections = 500;        -- 生效并持久化(写 mysqld-auto.cnf)
SET PERSIST_ONLY innodb_buffer_pool_size = 8589934592;  -- 只写配置文件,本次不生效(适合需重启的参数)
SET PERSIST innodb_buffer_pool_size = 8G; -- 也支持缩写
RESET PERSIST;                            -- 清空所有持久化设置
RESET PERSIST max_connections;            -- 撤销单个
```

## 19.9 JSON 类型全面增强(8.0)

**一句话本质:JSON 列是"校验过的、可索引的、可被函数提取的"文档结构,不再是 TEXT 里存一串字符串。**

```sql
CREATE TABLE t (id INT PRIMARY KEY, doc JSON);
INSERT INTO t VALUES (1, '{"name":"张三","age":30,"addr":{"city":"北京"}}');

-- 提取字段(-> 返回带引号,->> 返回纯字符串,推荐用 ->>)
SELECT doc->>'$.name' AS name, doc->'$.addr.city' AS city FROM t;
SELECT JSON_EXTRACT(doc, '$.age') FROM t;   -- 等价写法

-- 判断/改值
SELECT JSON_CONTAINS(doc, '{"name":"张三"}') FROM t;
UPDATE t SET doc = JSON_SET(doc, '$.age', 31) WHERE id = 1;

-- 8.0 专用:JSON 转关系表(JSON_TABLE,8.0 新特性)
SELECT jt.* FROM t,
  JSON_TABLE(doc, '$' COLUMNS(name VARCHAR(50) PATH '$.name')) jt;

-- 给 JSON 字段建"生成列索引"(常用优化手段)
ALTER TABLE t ADD COLUMN age INT GENERATED ALWAYS AS (doc->>'$.age') STORED;
CREATE INDEX idx_age ON t(age);
```

> JSON 列适用:配置信息、埋点/日志、字段经常变更的"柔性"场景;高频等值查询的字段还是建议单独建列 + 索引(JSON 索引是建在虚拟列上的)。

## 19.10 caching_sha2_password 认证(8.0 默认)

**一句话本质:新认证插件,密码不以明文传输、服务端缓存哈希;但老客户端(5.7 及更早、老连接驱动)首次连接需要额外步骤,否则报 `Authentication plugin 'caching_sha2_password' cannot be loaded`。**

```sql
-- 情况1:客户端支持(新版 mysql 客户端、8.0 驱动、JDBC mysql-connector-j 8.x)直接连
-- 情况2:老客户端,指定公钥方式
mysql -h 127.0.0.1 -P 3306 -u root -p --get-server-public-key
-- 情况3:彻底兼容老应用(降级为旧插件,8.0.34 起会有废弃告警)
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '新密码';
```

> 升级到 8.0 后应用连不上,90% 是这个原因,排查顺序:驱动版本 → `--get-server-public-key` → 是否强制走 SSL(见第 22 课)。

## 19.11 8.0 移除/废弃功能清单(升级前必查)

| 移除/废弃项 | 影响 | 替代方案 |
|---|---|---|
| 查询缓存 QUERY CACHE | 参数 `query_cache_type` 等全部失效 | 应用层缓存(Redis,见第 24 课) |
| `PASSWORD()/ENCRYPT()/OLD_PASSWORD()` | 老脚本/备份语句报错 | 应用层哈希 |
| `mysql_native_password` | 8.0.34 起废弃告警,8.4 移除 | `caching_sha2_password` |
| `.frm` 文件 | 不再有 | 数据字典 |
| `mysql.proc / mysql.event` 系统表 | 不存在了 | 查 `information_schema.ROUTINES/EVENTS` |
| `NO_AUTO_CREATE_USER` sql_mode 值 | 移除 | 显式 `CREATE USER` |
| `innodb_file_format` 等 | 移除 | 无需配置,默认 Barracuda |
| `mysql_upgrade` | 8.0.34 起废弃 | 启动自动升级 |
| `mysqldump --all-databases` 部分行为 | 系统表不再支持 MyISAM dump | 见第 19/25 课 |

## 19.12 8.0 运维命令变化速查

```bash
# 初始化(5.7 用 --initialize-insecure 也是,但 8.0 无 my-default.cnf,模板在 /usr/share/mysql/my.cnf 附近)
mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
# 启动(8.0 与 5.7 一致)
service mysqld start

# 查看默认认证插件 / 版本
SHOW VARIABLES LIKE 'default_authentication_plugin';
SELECT VERSION();

# 在线调整 redo 容量(8.0.30+)
SET GLOBAL innodb_redo_log_capacity = 8G;

# 查看是否有使用 query cache 的老参数(8.0 直接报 Unknown system variable)
SHOW VARIABLES LIKE 'query_cache%';   -- 8.0 下会报错:证明已移除
```


---

# 第20课 MGR 组复制与 InnoDB Cluster(8.0 官方高可用)

> **一句话本质:传统复制(第12课)是"一主多从、单向异步"的,**主挂了要手动/半自动切(MHA/MMM,第15课);MGR 是**一组 MySQL 节点之间互相复制、靠 Paxos 共识自动选主**,故障自动切换,是 8.0 官方主推的高可用方案,InnoDB Cluster 则是"MGR + MySQL Shell + MySQL Router"的开箱组合。

## 20.1 MGR 是什么

**组复制(Group Replication):一个组(Group)内的所有节点,通过内置的 group_replication 插件,把事务复制到全组并达成共识。**

| 对比维度 | 传统异步复制 | 半同步复制 | MGR 组复制 |
|---|---|---|---|
| 架构 | 1 主多从 | 1 主多从 | 多节点成组(Paxos 共识) |
| 数据一致性 | 可能延迟丢数据 | 至少一份从库确认 | **全组确认(或法定人数确认)** |
| 故障切换 | MHA/MMM 脚本切换 | 同上 | **自动选举新主(秒级)** |
| 读写扩展 | 从库分担读 | 从库分担读 | 从库分担读,多主模式可多写 |
| 脑裂处理 | 依赖 vip/仲裁 | 依赖 vip/仲裁 | **共识机制天然防脑裂(法定人数)** |
| 对表要求 | 无 | 无 | **所有表必须有主键** |
| 官方程度 | 官方 | 官方 | **官方原生高可用** |

**两种模式**:

- **单主模式(Single-Primary)**:组内只有 1 个主节点可读写,其余只读(客户端路由只写主);写扩展与主从类似,但高可用自动。**推荐生产默认。**
- **多主模式(Multi-Primary)**:所有节点都可写,靠**行级冲突检测**保证一致(基于主键版本);冲突时按规则回滚一方事务。网络抖动/跨机房慎用。

## 20.2 MGR 核心原理(面试必问)

1. **组成员管理**:节点通过 `group_replication_group_seeds` 互连,动态加入/离开;组视图(成员列表)实时同步。
2. **事务广播**:主节点执行事务 → 写入 binlog(格式必须 ROW)→ 组内广播 → 各节点**并发执行并做冲突检测**(依据主键/行版本)→ 向组内其他节点"投票" → 超过法定人数确认后**提交并返回成功**。
3. **Paxos 共识**:组内所有决策(成员变化、事务提交顺序)走分布式共识协议,保证全局有序;天然防脑裂——**组必须过半成员存活才能继续工作**。
4. **failover**:主节点故障 → 组内检测(成员超时)→ 自动选举新的主(单主模式按成员优先级)。

> 注意几个硬性限制(部署前必须满足):
> - **所有表必须有主键**(否则 DML 报错 `Table doesn't have a primary key`);
> - binlog 格式必须是 ROW;
> - `gtid_mode=ON`、`enforce_gtid_consistency=ON`(MGR 强依赖 GTID);
> - 建议 `log_slave_updates=ON`(每个节点自己也要记完整 binlog);
> - 不建议 `read_only` 全局写死(单主模式靠插件控制从节点只读)。

## 20.3 MGR 单主模式部署(手把手)

环境:3 台机器或 1 台机器 3 个实例,统一准备(端口 3306/3307/3308,实例目录各自独立):

```ini
# 每台/每个实例的 my.cnf 公共部分(以节点1为例,server-id 必须不同)
[mysqld]
server-id = 1
gtid_mode = ON
enforce_gtid_consistency = ON
binlog_format = ROW
log_slave_updates = ON
log_bin = mysql-bin
binlog_expire_logs_seconds = 86400
disabled_storage_engines = MyISAM            # MGR 只支持 InnoDB
# ---- 组复制配置(以下每个节点写自己的地址) ----
plugin_load_add = 'group_replication.so'
group_replication_group_name = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"   # 任意合法 UUID
group_replication_start_on_boot = OFF        # 先关,手动 bootstrap 第一个节点
group_replication_local_address = "10.0.0.1:33061"     # 节点自己的组通信地址(新端口)
group_replication_group_seeds = "10.0.0.1:33061,10.0.0.2:33062,10.0.0.3:33063"  # 所有成员
group_replication_single_primary_mode = ON    # 单主模式
group_replication_enforce_update_everywhere_checks = OFF  # 单主模式固定为 OFF
```

启动第一个节点(引导组):

```sql
-- 先创建复制账号(所有节点用同一账号)
CREATE USER 'repl'@'%' IDENTIFIED BY 'Repl@123';
GRANT REPLICATION SLAVE, BACKUP_ADMIN ON *.* TO 'repl'@'%';

-- 节点1(引导节点)
SET GLOBAL group_replication_bootstrap_group = ON;   -- 仅第一个节点执行一次!
START GROUP_REPLICATION;
SET GLOBAL group_replication_bootstrap_group = OFF;  -- 立即关掉,防止重复引导
SELECT * FROM performance_schema.replication_group_members;  -- 确认 ONLINE
```

加入节点2/节点3(同样的 my.cnf 改 server-id/地址):

```sql
-- 2、3 节点:不需要 bootstrap,直接 START
START GROUP_REPLICATION;
SELECT * FROM performance_schema.replication_group_members;
-- 看到三个 ONLINE 即成功;MEMBER_ROLE 字段显示 PRIMARY/SECONDARY
```

验证与日常管理:

```sql
-- 状态查看(常用)
SELECT * FROM performance_schema.replication_group_members \G
SELECT * FROM performance_schema.replication_group_member_stats \G  -- 事务提交统计

-- 主动切换主(节点1让位)
STOP GROUP_REPLICATION;          -- 主节点退出,自动选新主
START GROUP_REPLICATION;         -- 重新加入(回来当从)

-- 添加新节点:同样的 my.cnf + START GROUP_REPLICATION
```

## 20.4 InnoDB Cluster:MySQL Shell + MGR + Router

**一句话本质:MySQL Shell(新客户端工具,8.0.16+)的 AdminAPI 把上面手动配置 MGR 的过程封装成几条命令;MySQL Router 再自动做"读写分离路由 + 故障转移",形成生产级官方高可用组合。**

```bash
# 1. 三台机器各自装好 MySQL 8.0 并启动,然后安装 MySQL Shell
mysqlsh --uri root@10.0.0.1:3306

# 2. 在 Shell 里创建集群(会自动配置 GTID/复制账号/MGR)
dba.configureInstance('root@10.0.0.1:3306');          # 检查并初始化实例(选 yes)
dba.createCluster('mycluster');                       # 创建集群(第一个实例成为主)
var cluster = dba.getCluster('mycluster');
cluster.status();                                     # 查看集群状态

# 3. 添加其余实例
cluster.addInstance('root@10.0.0.2:3306');            # 自动复制全量数据+加入组
cluster.addInstance('root@10.0.0.3:3306');

# 4. 部署 Router(任一台机器)
mysqlrouter --bootstrap root@10.0.0.1:3306 --user=mysqlrouter
# Router 提供两个端口:6446(读写走主)/ 6447(只读走从)
mysql -h127.0.0.1 -P6446 -u app -p          # 应用连这个,主挂了 Router 自动切
```

日常管理命令:

```sql
-- Shell 内常用
cluster.status();                 -- 集群状态(含延迟)
cluster.describe();               -- 集群拓扑
cluster.setPrimaryInstance('10.0.0.2:3306');   -- 手动切换主
cluster.removeInstance('10.0.0.3:3306');       -- 移除实例
cluster.addInstance('10.0.0.3:3306');          -- 重新加入(先清理旧数据)
```

> **Router 路由规则**:默认把**读请求**按轮询分发到所有节点(含主),**写请求**只发主;应用只认识 Router 端口,主节点切换对应用透明。

## 20.5 高可用方案选型对照(面试/架构决策)

| 方案 | 一致性 | 自动切换 | 复杂度 | 适用场景 |
|---|---|---|---|---|
| 主从异步复制 + 手动切 | 弱 | 无 | 低 | 学习/容灾备份 |
| 主从 + MHA(15课) | 弱 | 半自动(脚本) | 中 | 5.7 及以下存量架构 |
| MMM(15课) | 弱 | 半自动(vip 漂移) | 中 | 老架构、读写分离 |
| **MGR 单主(本课)** | 强(组确认) | **自动(秒级)** | 中高 | **8.0 官方推荐,金融/核心业务** |
| InnoDB Cluster(本课) | 强 | 自动 | 高(Shell 简化后中等) | **生产首选,含 Router 读写路由** |
| PXC(Percona XtraDB Cluster) | 强(同步写所有节点) | 自动 | 高 | 多写场景,但对写入性能影响大 |

> 选型建议:**新项目 8.0 直接用 InnoDB Cluster 单主模式**;存量 5.7 先升 8.0 再迁,别在 5.7 上硬套 MGR(官方也支持 5.7.17+ 组复制,但 8.0 才成熟)。

## 20.6 MGR 常见坑

1. **表没主键**:DML 直接报错,`ALTER TABLE t ADD PRIMARY KEY(id)` 解决。
2. **`group_replication_bootstrap_group` 忘了关**:多节点同时引导 → 组分裂,务必只用一次并立即 OFF。
3. **网络抖动导致节点被踢**:调大 `group_replication_communication_timeout`(或 8.0.20+ 用 `group_replication_member_expel_timeout`,默认 5s)。
4. **大事务阻塞全组**:MGR 是全组复制,单个大事务(如一次 update 千万行)会让所有节点卡住,业务上要拆分批量写。
5. **自增/主键冲突(多主模式)**:多主写并发时靠冲突检测回滚,压测前确认业务可接受;单主模式无此问题。
6. **只读从库被写入**:单主模式下从节点被插件置为只读,不要手动改 `read_only`。


---

# 第21课 性能监控与压测调优

> **一句话本质:DBA 调优三板斧——先量(监控看到问题在哪),再测(压测模拟线上流量),后调(参数/索引/架构)。本课讲清楚"用什么看、怎么压、参数怎么改"。**

## 21.1 监控体系总览

| 层级 | 工具 | 看什么 |
|---|---|---|
| 实时状态 | `SHOW STATUS` / `SHOW GLOBAL STATUS` | QPS、TPS、Threads_connected、慢查询数等 |
| 明细采样 | **performance_schema** | 语句耗时、锁等待、IO 明细、线程状态 |
| 汇总视图 | **sys schema**(8.0 自带,读 performance_schema) | 一条 SQL 查 Top 慢语句/锁等待 |
| 慢查询日志 | slow log | 超阈值 SQL 全量落盘 |
| 指标采集告警 | Prometheus + mysqld_exporter + Grafana | 趋势图、阈值告警 |
| 压测 | sysbench / mysqlslap / tpcc-mysql | 吞吐量、延迟、瓶颈定位 |

## 21.2 看懂状态变量(定位瓶颈第一步)

```sql
-- 每秒查询/写入量(采样两次相减,或直接看 8.0 的秒级统计)
SHOW GLOBAL STATUS LIKE 'Questions';        -- 总查询数
SHOW GLOBAL STATUS LIKE 'Com_insert';       -- insert 次数
SHOW GLOBAL STATUS LIKE 'Threads_connected';-- 当前连接数(对照 max_connections)
SHOW GLOBAL STATUS LIKE 'Threads_running';  -- 正在执行的线程(>10 说明有排队)
SHOW GLOBAL STATUS LIKE 'Slow_queries';     -- 慢查询累计
SHOW GLOBAL STATUS LIKE 'Innodb_buffer_pool_read_requests'; -- 逻辑读
SHOW GLOBAL STATUS LIKE 'Innodb_buffer_pool_reads';         -- 物理读(从磁盘)

-- 命中率计算:逻辑读远大于物理读则缓存命中率高
-- 缓存命中率 ≈ 1 - Innodb_buffer_pool_reads / Innodb_buffer_pool_read_requests
```

**定位套路**:

```
1. 看 Threads_running 是否堆积 → 并发瓶颈(锁/慢 SQL)
2. 看 Innodb_rows_read / Sort_% 是否异常大 → 全表扫描/排序过大(索引问题)
3. 看 Innodb_buffer_pool_reads 是否大 → buffer pool 偏小
4. 看 Slow_queries 增长 → 慢查询分析(24.4)
```

## 21.3 performance_schema 与 sys schema(8.0 必会)

performance_schema 默认开启(5.7 需手动),sys schema 默认安装。

```sql
-- 1) 最有用:按 digest 汇总的语句分析(Top 慢语句)
SELECT * FROM sys.statement_analysis
ORDER BY total_latency DESC LIMIT 10;

-- 等价:performance_schema.events_statements_summary_by_digest
SELECT SCHEMA_NAME, DIGEST_TEXT, COUNT_STAR, AVG_TIMER_WAIT/1e12 AS avg_ms
FROM performance_schema.events_statements_summary_by_digest
ORDER BY SUM_TIMER_WAIT DESC LIMIT 10;

-- 2) 查看锁等待(谁阻塞了谁,对应第10课)
SELECT * FROM sys.innodb_lock_waits \G

-- 3) 全表扫描的表(重点优化对象)
SELECT * FROM sys.statements_with_full_table_scans LIMIT 10;

-- 4) 会话/进程(比 SHOW PROCESSLIST 信息更全)
SELECT * FROM sys.processlist WHERE conn_id IS NOT NULL;

-- 5) IO 热点文件
SELECT * FROM sys.io_global_by_file_by_bytes ORDER BY total DESC LIMIT 10;

-- 6) 若没数据:检查采集开关
UPDATE performance_schema.setup_consumers SET ENABLED='YES' WHERE NAME LIKE '%events_statements%';
UPDATE performance_schema.setup_instruments SET ENABLED='YES' WHERE NAME LIKE 'statement/%';
```

> 8.0 起 performance_schema 提供 `sys.session`(视图)替代 `information_schema.processlist`,还新增 `sys.memory_by_user_by_current_bytes` 等内存分析视图。

## 21.4 慢查询日志与慢 SQL 分析

```ini
# my.cnf
slow_query_log = ON
slow_query_log_file = /data/mysql/slow.log
long_query_time = 1            # 超过 1 秒算慢(生产常用 1~2s;压测时可 0)
log_queries_not_using_indexes = ON    # 没走索引的也记
min_examined_row_limit = 1000  # 只记扫描超 1000 行的(避免噪音)
```

```bash
# 分析工具1:mysqldumpslow(MySQL 自带)
mysqldumpslow -s t -t 10 /data/mysql/slow.log          # 按耗时取 Top10(已聚合)
mysqldumpslow -s c -t 10 /data/mysql/slow.log          # 按次数取 Top10

# 分析工具2:pt-query-digest(Percona Toolkit,见第23课,更强大)
pt-query-digest /data/mysql/slow.log | head -100       # 按总耗时排名+示例
```

**慢 SQL 三板斧**(配合第17课 EXPLAIN):

```
1. 用 EXPLAIN ANALYZE(8.0,22.7)看真实执行计划:是否全表扫?有没有走错索引?
2. 常见原因:索引失效(函数/隐式转换/左模糊)、join 无索引、深分页 LIMIT 100000,10
3. 手段:加联合索引、改深分页(游标/延迟关联)、拆分大事务、改 SQL 写法
```

## 21.5 sysbench 压测(量化性能)

```bash
# 1. 安装
yum install -y sysbench            # 或 apt install sysbench
sysbench --version

# 2. 准备数据(oltp_read_write 是常用压测脚本;先 prepare)
sysbench /usr/share/sysbench/oltp_read_write.lua \
  --mysql-host=127.0.0.1 --mysql-port=3306 \
  --mysql-user=root --mysql-password=xxx \
  --mysql-db=testdb \
  --tables=10 --table-size=1000000 \
  --threads=16 --time=60 --report-interval=5 \
  prepare

# 3. 压测
sysbench /usr/share/sysbench/oltp_read_write.lua \
  --mysql-host=127.0.0.1 --mysql-port=3306 \
  --mysql-user=root --mysql-password=xxx \
  --mysql-db=testdb --tables=10 --table-size=1000000 \
  --threads=16 --time=60 --report-interval=5 \
  run

# 4. 清理
sysbench /usr/share/sysbench/oltp_read_write.lua ... cleanup
```

**压测报告核心指标**:
- **QPS(queries per second)** / **TPS(transactions per second)**:吞吐;
- **p95/p99 延迟**:响应质量;
- **threads 逐步加(16→32→64)**:找到吞吐拐点(再高不涨反跌=并发瓶颈)。

> 压测注意:先冷热数据都跑(第一次跑冷,第二次热);压测时记录系统层面 CPU/IO(`iostat -x 1`、`vmstat 1`),分清是 CPU 还是磁盘瓶颈。

## 21.6 关键参数调优清单(生产基线)

> 原则:**先解决索引/架构问题,再动参数**;参数宁少勿多,每改一个都要压测对比。以下为常见生产基线(8.0):

| 参数 | 建议 | 说明 |
|---|---|---|
| `max_connections` | 按机器配:8G 内存≈500,16G≈1000 | 连接过多先查连接池,别一味加 |
| `thread_cache_size` | 32~64 | 连接复用,减少线程创建 |
| `innodb_buffer_pool_size` | **物理内存 60~75%** | 最核心参数,数据/索引缓存 |
| `innodb_buffer_pool_instances` | =pool_size/1G 且 ≤16 | 减少大池锁竞争 |
| `innodb_flush_log_at_trx_commit` | 1(金融,每次提交刷盘)/2(性能优先) | 与 `sync_binlog` 配合决定丢多少数据 |
| `sync_binlog` | 1(金融)/0~N(性能) | 每 N 次事务刷一次 binlog |
| `innodb_flush_method` | O_DIRECT(Linux) | 绕过 OS 页缓存,避免双缓存 |
| `innodb_io_capacity` / `_max` | 2000 / 8000(SSD) | 控制刷脏页力度 |
| `innodb_log_file_size`(旧)/`innodb_redo_log_capacity`(8.0.30+) | 默认 100MB → 建议 4~8G(redo) | 太小则大事务频繁 checkpoint |
| `binlog_format` | ROW | 8.0 默认 ROW,主从安全 |
| `binlog_expire_logs_seconds` | 604800(7天) | 磁盘清理策略 |
| `table_open_cache` | 2000~4000 | 表缓存;`Opened_tables` 持续增长则加大 |
| `tmp_table_size` / `max_heap_table_size` | 64M~256M | 内存临时表上限,超了走磁盘 |
| `sort_buffer_size` / `join_buffer_size` | 2M~8M(别贪大) | **按连接分配,过大内存爆炸** |
| `transaction_isolation` | 默认 REPEATABLE-READ | 读多写少可改 READ-COMMITTED 减少间隙锁(业务确认) |
| `innodb_flush_neighbors` | 0(SSD) | SSD 无相邻刷盘收益 |
| `innodb_old_blocks_time` | 1000 | 防止大表扫描把热数据挤出缓冲池 |

**内存评估口诀**:`buffer_pool + 连接数×(sort+join+read_buffer...) ≈ 总内存×0.8`,别配满。

## 21.7 监控告警落地(Prometheus + mysqld_exporter + Grafana)

```bash
# 1. 部署 mysqld_exporter(每台 MySQL 一台)
wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.15.1/mysqld_exporter-0.15.1.linux-amd64.tar.gz
tar xf mysqld_exporter-*.tar.gz
# 创建监控账号
CREATE USER 'exporter'@'%' IDENTIFIED BY 'exporter@123';
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';
# 启动(暴露 9104 端口)
./mysqld_exporter --config.my-cnf=.my.cnf &
# .my.cnf 内容:[client] user=exporter password=exporter@123

# 2. prometheus.yml 加 target
#   - job_name: 'mysql'
#     static_configs: [ { targets: ['10.0.0.1:9104','10.0.0.2:9104'] } ]

# 3. Grafana 导入仪表盘:官方模板 ID 7362(MySQL Overview)
#    告警规则建议:连接数>80%上限、QPS 异常跌零、从库延迟>30s、慢查询突增
```

## 21.8 压测调优方法论(工作流)

```
1. 基线:先压测得出当前 QPS/TPS/延迟(记录);
2. 采样:用 performance_schema/sys 找出 Top 慢语句与全表扫描;
3. 优化:索引优先 → SQL 改写 → 参数调整(一次一个);
4. 复测:同条件再压,对比指标,确认收益与无副作用;
5. 固化:SET PERSIST 持久化(22.8),写进规范文档;
6. 容量规划:按业务增长(如 3 倍流量)压测预留,得出"这台机器够撑多久"。
```

> 交付物建议沉淀为《MySQL 压测报告》模板:环境、压测参数、基线/优化后对比表、瓶颈分析、后续建议——这也是高级 DBA 面试作品集的常见素材。


---

# 第22课 升级迁移与安全加固

> **一句话本质:升级的难点不在"换二进制",而在"老功能/老配置在 8.0 还能不能用";安全加固则是 DBA 的最后一道防线——从密码、网络、传输、审计四个层面堵漏。**

## 22.1 升级前检查(5.x → 8.0 必做)

**原则:先升级到 5.7 最新小版本,再迁 8.0;8.0 官方不支持 5.6 直接跨到 8.0。**

```sql
-- 1) 检查版本与即将使用的特性
SELECT VERSION();

-- 2) 检查不兼容项(官方 mysqlcheck 等价逻辑):
--    表引擎(MyISAM 要转 InnoDB)
SELECT table_schema, table_name, engine FROM information_schema.tables
WHERE engine <> 'InnoDB' AND table_schema NOT IN ('mysql','information_schema','performance_schema','sys');

-- 3) 检查 sql_mode:8.0 移除了 NO_AUTO_CREATE_USER,若配置里写了会启动失败
SHOW VARIABLES LIKE 'sql_mode';

-- 4) 检查默认认证插件:所有账号是否依赖 mysql_native_password(8.0.34 起告警)
SELECT user, host, plugin FROM mysql.user;

-- 5) 检查是否有 query cache 相关参数(8.0 直接报错)
SHOW VARIABLES LIKE 'query_cache%';

-- 6) 检查是否用到已移除函数:PASSWORD()、ENCRYPT() 等(查存储过程/视图定义)
SELECT routine_name, routine_definition FROM information_schema.routines
WHERE routine_definition LIKE '%PASSWORD(%';

-- 7) 检查字符集:建议统一 utf8mb4(9 课)
SELECT @@character_set_server, @@collation_server;

-- 8) 备份!(升级前必须全量备份,见 19 课)
```

## 22.2 升级路径(两种)

### 方式一:In-Place 原地升级(推荐,停机窗口小)

```bash
# 1. 备份 + 停写
mysqldump --single-transaction --master-data=2 --all-databases > /backup/full_bak.sql

# 2. 正常关闭旧实例
mysqladmin -uroot -p shutdown

# 3. 备份旧程序/数据目录
cp -r /usr/local/mysql /usr/local/mysql-5.7.bak
cp -r /data/mysql /data/mysql-5.7.bak

# 4. 替换为新版本二进制(解压 8.0 tar 包到 /usr/local/mysql,保留旧 my.cnf 但注释掉废弃参数)

# 5. 用新版本启动(8.0.16 起启动时自动升级数据字典,无需手动 mysql_upgrade)
/usr/local/mysql/bin/mysqld_safe --user=mysql &

# 6. 验证
mysql -uroot -p -e "SELECT VERSION(); SHOW WARNINGS;"   # 看升级警告
mysql_upgrade -uroot -p        # 老版本(8.0.34 前)兼容性检查用,非必需
mysql -uroot -p -e "FLUSH PRIVILEGES;"
```

### 方式二:逻辑迁移(跨机/大版本差异大时)

```bash
# 1. 旧库导出(注意 GTID:8.0 目标库建议导出时带 --set-gtid-purged=ON)
mysqldump -uroot -p --single-transaction --set-gtid-purged=ON --all-databases > full.sql

# 2. 新库导入(8.0 全新安装,先建库)
mysql -uroot -p < full.sql

# 3. 验证行数/字符集/权限,再切换应用连接串
```

> **降级警告:8.0 → 5.7 官方不支持(数据字典等底层变化不可逆),只能靠升级前的备份回滚。** 升级窗口务必留好回滚预案。

## 22.3 Clone 插件:快速克隆与搭从(8.0.17+)

**一句话本质:官方"物理热备份/秒级搭从"——把源实例的数据文件直接拷贝到目标实例,比 mysqldump 逻辑导出快一个数量级。**

```sql
-- 1. 主库安装并配置插件(默认已安装,8.0.17+ 内置)
INSTALL PLUGIN clone SONAME 'mysql_clone.so';
-- 源库添加授权(目标端执行克隆需要的权限)
CREATE USER 'clone_user'@'%' IDENTIFIED BY 'Clone@123';
GRANT BACKUP_ADMIN ON *.* TO 'clone_user'@'%';

-- 2. 目标实例(新装的空实例,datadir 必须为空)执行远程克隆
CLONE INSTANCE FROM 'clone_user'@'10.0.0.1:3306' IDENTIFIED BY 'Clone@123';
-- 成功后实例自动重启,数据与源库一致

-- 3. 本地备份(生成一份数据目录快照)
CLONE LOCAL DATA DIRECTORY = '/backup/clone_bak';
```

**Clone 快速搭从库**(复制章节的补充):

```sql
-- 目标从库克隆主库后,补 GTID 并启动复制(8.0.27+ 更简单)
CHANGE REPLICATION SOURCE TO SOURCE_HOST='10.0.0.1', SOURCE_USER='repl',
  SOURCE_PASSWORD='Repl@123', SOURCE_AUTO_POSITION=1;
START REPLICA;
```

> 限制:源库与目标库需同版本大版本;目标 datadir 必须为空;克隆期间源库要开 binlog(默认)。**生产搭建新从库,优先 Clone 而不是 dump+导入。**

## 22.4 SSL/TLS 传输加密

**一句话本质:默认 MySQL 8.0 会自动生成自签证书,启用 SSL 让数据在网络上不裸奔;`caching_sha2_password` 首次认证也需要 SSL 或 RSA 公钥。**

```sql
-- 查看 SSL 状态
SHOW VARIABLES LIKE '%ssl%';          -- have_ssl=YES 说明支持
SHOW STATUS LIKE 'Ssl_cipher';        -- 当前会话是否加密

-- 1) 强制指定账号必须走 SSL
ALTER USER 'app'@'%' REQUIRE SSL;
ALTER USER 'app'@'%' REQUIRE X509;    -- 更严格:必须客户端证书

-- 2) 全局强制(配置或 SET PERSIST)
SET PERSIST require_secure_transport = ON;   -- 8.0 全部连接必须 TLS(本地 socket 除外)

-- 3) 客户端显式指定
mysql -h db.example.com -u app -p --ssl-mode=REQUIRED
```

## 22.5 审计(audit_log)

**一句话本质:慢日志管性能,审计日志管"谁在什么时候执行了什么"——合规审计与排查删库事故的钥匙。**

```sql
-- 8.0 企业版/Percona Server 自带 audit_log 插件(社区版可用 general_log 或第三方)
INSTALL PLUGIN audit_log SONAME 'audit_log.so';
SHOW VARIABLES LIKE 'audit_log%';

-- 配置示例(my.cnf)
[mysqld]
audit_log_format = JSON            -- 输出格式 JSON/CSV/NEW
audit_log_file = /data/mysql/audit.log
# audit_log_policy = ALL           -- ALL(全记录)/LOGINS(只记录登录)/QUERIES/ERRORS
```

```sql
-- 社区版简易替代:general_log(记录所有语句,注意性能开销,仅临时开)
SET GLOBAL general_log = ON;
SET GLOBAL general_log_file = '/data/mysql/general.log';
-- 排查完毕记得关:SET GLOBAL general_log = OFF;
```

## 22.6 安全加固清单(基线)

| 层面 | 动作 | 命令/说明 |
|---|---|---|
| 密码 | 启用密码强度策略 | 8.0 用组件:`INSTALL COMPONENT 'file://component_validate_password';` 然后 `SET GLOBAL validate_password.policy=STRONG;` |
| 账号 | 删除匿名/空密码账号 | `SELECT user,host,authentication_string FROM mysql.user WHERE user='';` → DROP |
| 账号 | 删除测试库 | `DROP DATABASE IF EXISTS test;` |
| 账号 | 最小权限 | 只授业务需要的库表权限,禁用 `'root'@'%'` |
| 网络 | 端口收敛/防火墙 | 只对应用网段开放 3306;`mysqladmin ping` 外网禁通 |
| 网络 | 绑定地址 | `bind-address=内网IP`(别绑 0.0.0.0) |
| 传输 | 强制 SSL | 见 25.4 |
| 审计 | 开启 audit_log | 见 25.5 |
| 备份 | 备份加密+异地 | binlog 加密(企业版 keyring)、备份文件加密落盘 |
| 系统 | 低权限运行 | `--user=mysql`,数据目录权限 750 |
| 系统 | 补丁管理 | 关注 MySQL 安全公告(CVE),及时升小版本 |

```sql
-- 密码策略(validate_password 组件)示例
INSTALL COMPONENT 'file://component_validate_password';
SET GLOBAL validate_password.policy = STRONG;        -- LOW/MEDIUM/STRONG
SET GLOBAL validate_password.length = 12;            -- 最小长度
-- 之后设置弱密码会直接报错:Your password does not satisfy the current policy requirements
```

## 22.7 常用巡检脚本(每周/每月)

```sql
-- 1) 实例健康
SHOW STATUS LIKE 'Uptime';                          -- 运行时长(重启历史)
SHOW STATUS LIKE 'Threads_connected';
SHOW PROCESSLIST;                                   -- 有无长时间 Running/锁等待

-- 2) 磁盘与 binlog
SHOW VARIABLES LIKE 'binlog_expire_logs_seconds';
SHOW BINARY LOGS;                                   -- 对比磁盘剩余空间

-- 3) 复制健康(主从/MGR)
SHOW REPLICA STATUS\G                               -- 8.0 新语法
SELECT * FROM performance_schema.replication_group_members;  -- MGR

-- 4) 表/库大小 Top(规划扩容)
SELECT table_schema, ROUND(SUM(data_length+index_length)/1024/1024,1) MB
FROM information_schema.tables GROUP BY table_schema ORDER BY MB DESC;
```

> 建议输出《巡检日报》:运行时长、连接数、慢查询数、复制延迟、磁盘余量、备份完成情况,5 分钟可跑完,是 DBA 日常的肌肉记忆。


---

# 第23课 Percona Toolkit(pt 工具)实战及自动化

## 23.1 PT-Tools 是什么

- **Percona Toolkit(简称 pt 工具)** 是 Percona 公司开发的 MySQL 管理工具集。
- 功能:检查主从复制数据一致性、检查重复索引、定位 IO 占用高的表文件、在线 DDL 等,是 **DBA 面试和工作的必备技能**(很多公司招聘明确要求会用它)。
- 下载:https://www.percona.com/downloads/percona-toolkit/LATEST/
- 安装:`yum install -y percona-toolkit`(或下载 rpm 包安装);MySQL 5.1 之前的版本用不了。

## 23.2 工具分级

### Level 1(必须掌握,杀手锏)
| 工具 | 用途 |
|---|---|
| pt-archiver | MySQL 在线归档,**无影响生产**地删除/迁移大表历史数据 |
| pt-kill | 自定义查杀,确保慢查询及恶性攻击对生产无影响 |
| pt-online-schema-change | 在线 DDL,上亿大表加索引/加字段且对生产无影响 |
| pt-query-digest | 慢查询日志分析 |

### Level 2(了解,遇到问题能想到用它)
| 工具 | 用途 |
|---|---|
| pt-slave-delay | 指定从库比主库延迟多长时间 |
| pt-table-checksum & pt-table-sync | 检查主从一致性 / 修复不一致(搭配使用) |
| pt-find | 找出几天之前建立的表、大表、空表 |
| pt-slave-restart | 主从报错自动跳过 |
| pt-summary | 整个系统概述(CPU/内存/磁盘/网络) |
| pt-mysql-summary | MySQL 概述(版本/配置/变量/复制等) |
| pt-duplicate-key-checker | 检查数据库重复索引 |

## 23.3 pt-archiver:在线归档

- 归档条件:**被操作的表必须有主键**(没主键别让生产上线)。
- 用途:① 归档历史数据 ② 在线删除大批量数据 ③ 数据导出和备份 ④ 数据远程归档 ⑤ 数据清理。

### 常用参数
| 参数 | 说明 |
|---|---|
| `--limit 10000` | 每次取 10000 行处理 |
| `--txn-size 1000` | 1000 行作为一个事务提交一次 |
| `--where 'id<3000'` | 操作条件 |
| `--progress 5000` | 每处理 5000 行输出一次进度 |
| `--statistics` | 输出执行过程及最后统计 |
| `--charset UTF8` | 指定字符集,防止乱码 |
| `--bulk-delete` | 批量删除 source 上的旧数据 |
| `--no-delete` | 只归档(复制到目标)不删除原表记录 |
| `--purge` | 只删除不归档 |
| `--no-check-charset` | 不检查源/目标字符集 |

### 经典用法
```bash
# (1) 归档到目标库,不删除原表记录(--no-delete)
pt-archiver --source h=源IP,P=3306,u=用户,p=密码,D=库名,t=表名 \
  --dest h=目标IP,P=3306,u=用户,p=密码,D=库名,t=表名 \
  --no-check-charset --where 'CREATE_DATE<"2015-10-01 00:00:00"' \
  --progress 5000 --no-delete --limit=10000 --statistics

# (2) 归档并删除原表记录(去掉 --no-delete)
pt-archiver --source h=源IP,P=3306,u=用户,p=密码,D=库名,t=表名 \
  --dest h=目标IP,P=3306,u=用户,p=密码,D=库名,t=表名 \
  --no-check-charset --where 'CREATE_DATE<"2015-10-01 00:00:00"' \
  --progress 5000 --limit=10000 --statistics

# (3) 远程归档(带字符集)
pt-archiver --charset 'utf8' --source h=127.0.0.1,P=6006,u=root,p='密码',D=源库,t=源表 \
  --dest h=10.59.1.152,P=6006,u=sys_dba,p='密码',D=目标库,t=目标表 \
  --where 'periodID=1' --progress 5000 --limit=5000 --statistics

# (4) 只删除不归档(--purge,删 31 天前的数据)
pt-archiver --source h=127.0.0.1,P=6006,u=root,p='密码',D=eagleeyes_history,t=business_errmsg \
  --where 'collecttime < SUBDATE(curdate(),INTERVAL 31 DAY)' --purge \
  --limit=5000 --no-check-charset --statistics --progress 5000

# (5) 归档 updateTime < '2017-07-01' 的数据
pt-archiver --charset 'utf8' --source h=127.0.0.1,P=6006,u=root,p='password',D=acc_tasktrace,t=learn_tracedb \
  --dest h=10.59.1.152,P=6006,u=sys_dba,p='password',D=acc_tasktrace_history,t=learn_tracedb \
  --where 'updateTime < "2017-07-01"' --progress 5000 --limit=5000 --statistics
```

### pt-archiver 自动化思路
- DBA 服务器上建一张**配置表(配置中心)**:记录每台要归档服务器的 IP/用户名/密码/库名/表名/归档条件,以及目标服务器信息;
- 用 **Python 脚本遍历配置表**远程执行 pt-archiver,完成后把结果 Insert 到 DBA 库,再发邮件通知;
- 定时任务(crontab)驱动,实现无人值守归档。

## 23.4 pt-kill:自定义查杀

- 优秀的高危 SQL 终结者:出现大量阻塞/死锁、某条问题 SQL 导致负载很高、黑客攻击时,可**按运行时间、来源 IP、用户名、数据库名、SQL 语句、sleep/running 状态**匹配后 kill。

### 常用参数
| 参数 | 说明 |
|---|---|
| `--daemonize` | 后台守护进程运行 |
| `--interval` | 多久运行一次(默认 5 秒) |
| `--victims` | 默认 oldest(只杀最古老的查询);`all` 杀掉所有满足条件的线程 |
| `--all` | 杀掉所有满足条件的线程 |
| `--kill-query` | 只杀掉连接执行的语句,线程不终止 |
| `--print` | 打印满足条件的语句 |
| `--busy-time` | 杀掉已运行超过该时间的线程 |
| `--idle-time` | 杀掉 sleep 空闲超过该时间的连接(需配 `--match-command sleep`) |
| `--match-command` / `--ignore-command` | 匹配/忽略某类 command(注意:ignore 在前、match 在后) |
| `--match-db` | 匹配哪个库 |
| `--match-user` / `--match-host` / `--match-state` / `--match-info` | 按用户/IP/状态/SQL 内容匹配 |
| `--log-dsn D=库,t=表 --create-log-table` | 把杀掉的 SQL 记录到 MySQL 表(自动建表) |

### 实战案例
```bash
# ① 杀掉空闲 sleep 5 秒的连接,日志写文件
/usr/bin/pt-kill --match-command Sleep --idle-time 5 --victim all --interval 5 --kill --daemonize \
  -S /home/zb/data/my6006/socket/mysqld.sock --pid=/tmp/ptkill.pid --print --log=/home/pt-kill.log &

# ② 杀掉运行超过 1 分钟的 SELECT
/usr/bin/pt-kill --busy-time 60 --match-info "SELECT|select" --victim all --interval 5 --kill \
  --daemonize -S /home/zb/data/my6006/socket/mysqld.sock --pid=/tmp/ptkill.pid --print --log=/home/pt-kill.log &

# ③ 杀掉 select IFNULL... 开头的 SQL
pt-kill --victims all --busy-time=0 --match-info="select IFNULl.*" --interval 1 \
  -S /tmp/mysqld.sock --kill --daemonize --pid=/tmp/ptkill.pid --print --log=/home/pt-kill123.log &

# ④ 杀掉 state=Locked 的连接
/usr/bin/pt-kill --victims all --match-state='Locked' --interval 5 --kill --daemonize \
  -S /home/zb/data/my6006/socket/mysqld.sock --pid=/tmp/ptkill.pid --print --log=/home/pt-kill.log &

# ⑤ 杀掉指定库 + 指定来源 IP 的连接
pt-kill --victims all --match-db='qz_business_service' --match-host='10.59.2.37' --kill --daemonize \
  --interval 10 -S /home/zb/data/my6006/socket/mysqld.sock --pid=/tmp/ptkill.pid --print --log=/home/pt-kill.log &

# ⑥ 杀掉 root 用户 + command 为 query|Execute 的连接
pt-kill --victims all --match-user='root' --kill --daemonize --interval 10 \
  -S /home/zb/data/my6006/socket/mysqld.sock --pid=/tmp/ptkill.pid --print --log=/home/pt-kill.log &
pt-kill --victims all --match-command="query|Execute" --interval 5 --kill --daemonize \
  -S /home/zb/data/my6006/socket/mysqld.sock --pid=/tmp/ptkill.pid --print --log=/home/pt-kill.log &
```

### pt-kill 自动化(记录到表)
```bash
# 杀掉 select(不分大小写)超过 10 秒的语句,并把被杀的 SQL 记录到 dba_admin.killed_sql_table
# Dba_admin 库要存在,killed_sql_table 表没有会自动创建;默认 5 秒执行一次
pt-kill --log-dsn D=dba_admin,t=killed_sql_table --create-log-table \
  --host=127.0.0.1 --user=root --password='密码' --port=3306 \
  --busy-time=10 --print --kill-query --match-info "SELECT|select" --victims all &
```
- 自动化的完整闭环:
  1. 每台生产服务器后台运行 pt-kill(建议只杀 SELECT,update/delete 不建议自动杀);
  2. 被杀的 SQL 记录到本机 dba 库的 killed_sql_table 表;
  3. DBA 服务器脚本遍历所有机器的配置中心表,抓取被杀 SQL(取走即删),然后邮件通知 DBA。
```bash
# 生产机示例:杀掉超过 5 分钟的 SELECT,记录到表(忽略 update/delete 等 DML)
pt-kill --log-dsn D=dba,t=killed_sql_table --create-log-table --host=127.0.0.1 --user=root \
  --password='密码' --port=6006 --busy-time=300 --print --kill-query \
  --ignore-info "into|INTO|update|UPDATE|delete|DELETE" --match-info "SELECT|select" --victims all &
```

## 23.5 pt-online-schema-change(pt-osc):在线 DDL

### 为什么需要它
- MySQL 大表 DDL(加字段/索引/改属性)在 5.1 之前非常耗时;5.1 后 InnoDB 在线加索引有提升,但仍受 **MDL 锁**影响;5.6 才可避免大部分问题。很多生产版本还是 5.6 之前,**DDL 一直是运维头疼的事**。
- pt-osc **模仿 MySQL 内部改表方式,通过拷贝原始表完成改表,过程中原始表不被锁定,不影响读写**。

### 工作原理(面试重点)
1. 创建一个和原表结构一样的**新空表**(下划线开头,如 `_原表名`);
2. 在新表上执行 `alter table`(速度很快);
3. 在原表上创建**3 个触发器**(insert/update/delete);
4. **按块大小从原表拷贝数据**到新表,拷贝期间原表上的写操作通过触发器同步到新表;
5. **Rename** 原表为旧表,新表 Rename 为原表;
6. 如有外键引用该表,按 `--alter-foreign-keys-method` 参数处理相关表;
7. 默认最后删除旧原表。
- **注意点**:被操作的表有**触发器或外键时不能用**(生产规范 MySQL 不建议用外键与触发器),要先去外键/触发器再操作;
- 执行失败或手动停止后,需**手动删除下划线开头的表及 3 个触发器**。

### 常用参数
| 参数 | 说明 |
|---|---|
| `--user/--password/--database/--port/--host/--socket` | 连接参数 |
| `--alter "ADD INDEX ..."` | 要执行的 DDL(可多次指定) |
| `--dry-run` | 只创建和修改新表,**不真正执行**(和 --print 搭配看执行计划) |
| `--execute` | 真正执行;**--dry-run 与 --execute 必须二选一** |
| `--print` | 打印执行的 SQL |
| `--max-load` | 默认 Threads_running=25;每个 chunk 拷贝后检查状态指标,**超过则暂停**;可用逗号分隔多条件,格式 `指标=最大值` 或 `指标:最大值`,不指定则取当前值 120% |
| `--critical-load` | 默认 Threads_running=50;超过指定值则**工具直接退出**(不是暂停),默认当前值 200% |
| `--statistics` | 打印内部事件数(看到复制插入条数) |
| `--progress` | 复制数据时打印进度(百分比 + 时间) |
| `--quiet` | 不输出到标准输出 |

### 实战案例
```bash
# ① 给 learn_tracedb 表的 updateTime 列加索引
pt-online-schema-change --user=root --password='密码' --port=6006 --host=127.0.0.1 \
  --critical-load Threads_running=100 --alter "ADD INDEX index_updateTime (updateTime)" \
  D=acc_tasktrace,t=learn_tracedb --print --execute

# ② 给 cware_user_point 添加 periodID 列
pt-online-schema-change --user=root --password='密码' --port=6006 --host=127.0.0.1 \
  --critical-load Threads_running=200 --alter "ADD COLUMN periodID int(11)" \
  D=acc_cwaretiming,t=cware_user_point --print --execute

# ③ 删除列 sendName
pt-online-schema-change --user=root --password='密码' --port=6006 --host=127.0.0.1 \
  --critical-load Threads_running=200 --alter "drop column sendName" \
  D=logistics_service,t=logistics_send --print --execute

# ④ 加列和加索引同时操作
pt-online-schema-change --user=root --password='密码' --port=6006 --host=127.0.0.1 \
  --critical-load Threads_running=200 --alter "ADD COLUMN periodID int(11)" \
  --alter "ADD INDEX index_periodID (periodID)" D=acc_cwaretiming,t=cware_study_time \
  --print --execute

# ⑤ 先演练(--dry-run),确认无误后再执行
pt-online-schema-change --user=root --password='密码' --host=127.0.0.1 --alter "ADD INDEX ..." \
  D=db,t=tbl --print --dry-run
```

## 23.6 pt-query-digest:慢查询分析

- 前提:必须开启 MySQL 慢查询日志(`long_query_time` + `slow_query_log`)。
- 作用:对慢查询日志做聚合统计,排出最慢、执行次数最多的 SQL。

### 常用参数
| 参数 | 说明 |
|---|---|
| `--create-review-table` / `--create-history-table` | 分析结果输出到表时自动建表 |
| `--filter` | 按字符串匹配过滤后再分析 |
| `--limit` | 输出数量,默认 20(最慢的 20 条);写 50% 则按总响应时间占比排序,输出到总和达 50% 截止 |
| `--host/--user/--password` | 输出到表时连接 MySQL 用 |
| `--history` | 结果保存到表(详细),下次相同语句且时间段不同会再记录,可按 CHECKSUM 比较同类查询历史变化 |
| `--review` | 结果保存到表(简单,查询条件参数化后一种类型一条),相同语句不再记录 |
| `--output` | 输出类型:report(标准报告)/slowlog/json/json-anon,一般 report |
| `--since / --until` | 从什么时间开始/截止分析,支持 `yyyy-mm-dd [hh:mm:ss]` 或 `12h/2d` 等写法 |

### 实战用法
```bash
# ① 分析指定时间段的慢日志(输出到屏幕,可用 > 存文件)
pt-query-digest /home/zb/data/my6006/log/mysql_slow_2018-11-07.log \
  --since '2018-11-07 00:00:00' --until '2018-11-11 15:50:00' > log.txt

# ② 结果插入数据库(query_review 表)
pt-query-digest --user=root --password=abc123 \
  --review h=localhost,D=test,t=query_review --create-review-table slow.log

# ③ 只分析 select 开头的慢查询
pt-query-digest --filter '$event->{fingerprint} =~ m/^select/i' \
  /web/mysql/data/chinapen40-slow.log > slow_report4.log

# ④ 只分析 root 用户的慢查询
pt-query-digest --filter '($event->{user} || "") =~ m/^root/i' \
  /web/mysql/data/chinapen40-slow.log > slow_report5.log
```

### 报告解读
- `Overall`:总查询数;`Time range`:时间范围;`unique`:参数化后的唯一查询数;
- `total / min / max / avg / 95% / median`:执行耗时统计(**95% 位置的值最有参考价值**);
- 排名靠前的 SQL 最慢,需优先处理。

### 慢查询日报/网页自动化
- 每台服务器部署两个脚本:① 慢日志切割(每天 00:01 按日期命名)② 分析后的慢日志 insert 到 DBA 服务器 dba_admin 库;
- DBA 服务器定时脚本每天取前一天慢日志并发邮件;
- 开源 Web 展示工具:**Box Anemometer** —— 可以选 IP、时间范围查看慢查询分布、checksum(同类 SQL 分组)、explain 等,直观看到每台服务器慢查询增减情况。

## 23.7 Level 2 工具速览

### pt-slave-delay(延迟复制,从库执行)
- 原理:通过**启停从库 SQL 线程**,基于 relay log 的 position 让从库一直落后主库固定时间;IO 线程落后不多时不需要连主库。
- MySQL 5.6 之后有原生延迟配置:`CHANGE MASTER TO MASTER_DELAY = N;`,已不常用。
```bash
pt-slave-delay --delay=1m --interval=15s --run-time=10m u=root,p=123456,h=127.0.0.1,P=6006
# --delay 从库延迟主库 1 分钟;--interval 15 秒检查一次(默认 1 分钟);
# --run-time 运行 10 分钟关闭(默认永远运行,一般不加)
```

### pt-table-checksum & pt-table-sync(主从一致性)
- 搭配使用:先检查发现差异,再修复。
```bash
# ① 检查(主库执行;用户需能访问主从库)
pt-table-checksum --nocheck-replication-filters --no-check-binlog-format \
  --replicate=test.checksums --recursion-method=hosts \
  --databases=log_manage h=localhost,u=sys_dba,p='密码',P=6006
```
- 参数:`--replicate=test.checksums` 结果放哪张表(自动创建);`--databases` 检测的库(多个逗号分隔,不写=所有库);`--recursion-method=hosts` 主库探测从库的方式;`--no-check-binlog-format` 不检查 binlog 格式(**生产多为 ROW,而该工具会话自设 STATEMENT,务必加**)。
- 检查结果表字段:TS(时间)、ERRORS、DIFFS(0 一致 1 不一致)、ROWS、CHUNKS、SKIPPED、TIME、TABLE。
- 查看差异明细(在**从库**查 checksum 表):
```sql
SELECT db, tbl, SUM(this_cnt) AS total_rows, COUNT(*) AS chunks
FROM test.checksums
WHERE (master_cnt <> this_cnt OR master_crc <> this_crc OR ISNULL(master_crc) <> ISNULL(this_crc))
GROUP BY db, tbl;
```
- 修复(在从库执行;**表必须有主键或唯一索引**):
```bash
pt-table-sync --sync-to-master --replicate=test.checksums h=127.0.0.1,u=dba,P=6006,p='密码' --print
# --print 只打印不执行;改为 --execute 真正执行修复
```
- 报错"找不到从库"时:给主从配一个公用账号(权限大些),或用配置指定从库 IP 和端口。

### pt-find(找表)
```bash
# 找出大于 10G 的表
pt-find --socket=/home/zb/data/my6006/socket/mysqld.sock --user=root --password='密码' \
  --port=6006 --tablesize +10G
# 25 分钟之内修改过的表
pt-find --socket=... --port=6006 --mmin -25
# 空的(没数据的)表
pt-find --socket=... --port=6006 --empty
```

### pt-slave-restart(跳过主从复制错误)
- 在从库执行即可;参数:`--error-numbers` 指定跳过哪些错误(逗号分隔,如 1032);`--skip-count` 一次跳过个数(默认 1);`--log` 输出到文件;`--runtime` 运行时长;`--until-master "file:pos"` 到达指定位置停止。
```bash
# 自动跳过主从同步 1032(找不到要删的行)报错
/usr/bin/pt-slave-restart --user=root --password='密码' --port=6006 --host=127.0.0.1 \
  --error-numbers=1032
```

### pt-mysql-summary / pt-summary(系统巡检)
```bash
# MySQL 概况:版本、数据目录、命令统计、用户/库/复制、status/variables 及比例、配置文件等
pt-mysql-summary --user=root --password='password' --host=127.0.0.1 --port=6007
# 系统概况:CPU、内存、硬盘、网卡、文件系统、磁盘调度/队列、LVM、RAID、netstat、
# 前 10 负载占用、vmstat 信息
pt-summary
```

## 23.8 MySQL 升级经验(5.5 → 5.7,赠送)

- **不建议直接本机升级(没有回退方案);建议用主从方式升级**:
  
  1. 在主库(5.5)备份全库;
  2. 还原到新的 5.7 从库服务器,启动 5.7 实例;
  3. **查看 err.log**,里面会有批量报错,**所有 error 都要解决掉**;
  4. 执行 `mysql_upgrade --protocol=tcp -P3306 -p`(MySQL 内部自动升级数据字典/系统表);
  5. 清空 err.log 再重启 MySQL,验证版本;
  6. 检查无误后把业务切到 5.7。
- **升级后最常踩的坑:sql_mode**
  
  - MySQL 5.7 默认开启 `ONLY_FULL_GROUP_BY`,很多旧 SQL 直接报错:
  ```
  Error Code: 1055. Expression #3 of SELECT list is not in GROUP BY clause and
  contains nonaggregated column 'xxx' ... incompatible with sql_mode=only_full_group_by
  ```
  - 要求 select 的列都要在 group by 中,或本身是聚合列(SUM/AVG/MAX/MIN);
  - 开发不肯改 SQL 时,在 my.cnf 里去掉 ONLY_FULL_GROUP_BY(或改 sql_mode 配置)。

## 23.9 总结

- **Level 1 工具(pt-archiver / pt-kill / pt-osc / pt-query-digest)务必熟练掌握**,配合 Python/Shell 脚本 + 配置表 + crontab + 邮件通知,可实现归档、查杀、慢查询日报的**全自动化**;
- Level 2 工具了解即可,遇到问题要能想到用它们解决;
- 更多工具(重复索引检查、IO 占用分析等)可查阅官方文档自行研究。

# 第24课 Redis 数据库实战

## 24.1 Redis 是什么

- Redis 是**基于内存的 key-value NoSQL 数据库**(非关系型),数据保存在内存,读写极快。
- 支持数据类型丰富:`string(字符串)`、`hash(哈希)`、`list(列表)`、`set(集合)`、`zset(有序集合)`、`geo(地理)`、`bitmap`、`hyperloglog` 等。
- **单线程模型**:一条命令执行期间不会执行其他命令(原子性),杜绝并发竞争;瓶颈主要在**网络 IO 和内存**。
- 支持**持久化**(RDB 快照 / AOF 追加日志),重启不丢数据。

### Redis 特性(面试常考)
1. **速度快**:纯内存存储 + C 语言 + 单线程避免上下文切换,读写 10 万+/秒。
2. **类型丰富**:5 大数据类型(string/hash/list/set/zset)。
3. **操作丰富**:自增自减、集合运算、pipeline 批量执行、事务、过期时间等。
4. **集群化**:3.0 起官方支持 Redis Cluster,天然去中心化高可用。
5. **多语言客户端**:java、PHP、python、C、C++、Nodejs 等。
6. **持久化**:RDB 和 AOF 两种方式。
7. **主从复制 + 哨兵(Sentinel)+ 集群(Cluster)**:提供高可用。

## 24.2 Redis 使用场景

| 场景 | 说明 |
|---|---|
| 缓存 | 页面/数据缓存,把频繁访问数据放 Redis,减轻 MySQL 压力 |
| Session 共享 | 多台应用服务器共享 session(代替单机 session) |
| 消息队列 | list 的 lpush/rpop 实现简单队列(配合发布订阅 pub/sub) |
| 排行榜 | zset 有序集合,天然按分数排序(如热榜、游戏排行) |
| 计数器 | INCR/DECR 原子自增(点赞数、访问量、限流) |
| 分布式锁 | setnx + expire 实现,多进程互斥 |
| 配合 ELK | 日志队列缓冲,统一收集分析 |

## 24.3 生产目录规划

```
/data/soft/                                  # 软件安装包
/opt/redis_cluster/redis_{PORT}/{conf,logs,pid}   # 配置文件/日志/PID
/data/redis_cluster/redis_{PORT}/redis_{PORT}.rdb # 数据文件
/root/scripts/redis_shell.sh                  # 管理脚本
```

## 24.4 配置文件 redis.conf 关键项

```ini
daemonize yes                              # 后台运行
port 6379                                  # 监听端口
pidfile /opt/redis_cluster/redis_6379/pid/redis_6379.pid
logfile /opt/redis_cluster/redis_6379/logs/redis_6379.log
dir /data/redis_cluster/redis_6379/        # RDB/AOF 保存目录
bind 0.0.0.0                               # 监听所有网卡(生产按需收紧)
protected-mode no                          # 关闭保护模式(允许远程连接)
requirepass 123456                         # 设置密码(生产必配)
maxmemory 1gb                              # 最大内存,超限按淘汰策略处理
maxmemory-policy allkeys-lru               # 内存淘汰策略(见 16.8)
appendonly yes                             # 开启 AOF 持久化
appendfsync everysec                       # 每秒刷盘
save 900 1                                 # 900 秒内 1 次修改触发 RDB 快照
```

## 24.5 Redis 基础命令

| 命令 | 作用 |
|---|---|
| `keys *` | 查看所有 key(生产禁用,阻塞 Redis) |
| `dbsize` | 当前库 key 数量(不阻塞) |
| `exists key` | 存在返回 1,不存在返回 0 |
| `del key [key…]` | 删除 key,返回删除个数 |
| `expire key seconds` | 设置过期时间(秒) |
| `ttl key` | 剩余存活时间:-1 永不过期,-2 已不存在 |
| `type key` | 查看 key 类型 |
| `persist key` | 移除过期时间 |
| `select n` | 切换数据库(0-15,默认 0) |
| `flushdb` / `flushall` | 清空当前库 / 所有库(慎用) |

## 24.6 五大数据类型

### ① String 字符串(最常用)
```bash
set key1 value1        # OK
get key1               # "value1"
mset key3 v3 key4 v4   # 批量设置
mget key3 key4         # 批量获取
set key2 100
incr key2              # 101  原子自增 1
incrby key2 10         # 111  自增 10
decr key2              # 减 1
decrby key2 10         # 减 10
```
- 经典用法:缓存 JSON 数据、计数器、分布式锁(setnx)。

### ② Hash 哈希(适合对象)
```bash
hmset user:1000 username zhangya age 27 job it
hget user:1000 username          # "zhangya"
hmget user:1000 username age job # 批量取
hgetall user:1000                # 取全部字段
```
- 一个 hash 存一个对象(如用户、商品),比 string 省内存、方便单独字段更新。

### ③ List 列表(消息队列)
```bash
rpush list1 A B        # 从右推入
lpush list1 first      # 从左推入
lrange list1 0 -1      # 查看全部: first A B
lrange list1 1 -1      # A B(从下标 1 到结尾)
lpop list1             # 左弹出 first
rpop list1             # 右弹出 B
```
- 经典用法:`lpush` 生产者入队,`brpop` 消费者阻塞出队 → 简单消息队列。

### ④ Set 集合(去重 + 集合运算)
```bash
sadd set1 1 2 3 4      # 添加成员(自动去重)
sadd set2 1 4 5
smembers set1          # 查看所有成员
sdiff set1 set2        # 差集:2 3(set1 有 set2 没有)
sinter set1 set2       # 交集:1 4
sunion set1 set2       # 并集:1 2 3 4 5
srem set1 2 4          # 移除成员
```
- 经典用法:抽奖去重、好友关系、标签系统。

### ⑤ Zset 有序集合(排行榜)
```bash
zadd rank 100 zhangsan 90 lisi 80 wangwu   # 添加成员及分数
zrange rank 0 -1 withscores                # 按分数从小到大
zrevrange rank 0 -1 withscores             # 按分数从大到小(排行榜)
zincrby rank 10 zhangsan                   # 分数 +10
```
- 经典用法:排行榜、延时队列、限流窗口。

## 24.7 Redis 主从复制

- 一主多从:Master 负责写(可读),Slave 负责读,**读写分离** + 数据备份 + 故障容错。
- 配置方式(三种):
  1. 配置文件 `redis.conf` 里写:`slaveof {masterHost} {masterPort}`;
  2. 启动参数:`redis-server --slaveof {masterHost} {masterPort}`;
  3. 命令行动态:`slaveof {masterHost} {masterPort}`(立即生效,无需重启)。
- 查看状态:`info replication`(role、connected_slaves、master_link_status 等)。

### 主从故障处理
- 从库手动切换:`slaveof no one`(断开主从关系,从库变主库)。
- 故障转移步骤:
  1. 停止原主库写入;
  2. `slaveof no one` 提升从库为新主;
  3. 其他从库重新指向新主;
  4. 原主库恢复后作为新主的从库(`slaveof {newMasterIp} {newMasterPort}`)。
- 自动故障转移由 **Sentinel(哨兵)** 完成。

## 24.8 Redis 哨兵(Sentinel)

- Sentinel 是 Redis **高可用方案**:自动监控主从,主库宕机时**自动执行故障转移**,把从库提升为主库,并通知应用。
- **需要部署多个 Sentinel 组成集群**(互相通信、通过投票机制判断),防止误判(脑裂)。
- 哨兵数量建议**奇数**(如 3 个),`sentinel monitor` 参数最后一个数字是"几个哨兵确认才判定主库死亡"。
- Sentinel 本身也是 Redis 实例,但只做监控,不存数据。

### sentinel.conf 关键配置
```ini
sentinel monitor mymaster 172.16.1.90 6379 2
# 监控主库:名字、地址、端口;2 = 至少 2 个哨兵同意才判定主库挂了
sentinel down-after-milliseconds mymaster 30000
# 30 秒联系不上主库判定主观下线
sentinel parallel-syncs mymaster 1
# 故障转移后,允许同时同步新主数据的从库个数(1 逐个同步,避免阻塞)
sentinel failover-timeout mymaster 180000
# 故障转移超时时间(3 分钟)
```
- 启动:`redis-server sentinel.conf --sentinel`。

### Sentinel 常用 API
| 命令 | 作用 |
|---|---|
| `SENTINEL masters` | 查看所有被监控主库 |
| `SENTINEL master <name>` | 查看指定主库详情 |
| `SENTINEL slaves <name>` | 查看该主库的从库列表 |
| `SENTINEL sentinels <name>` | 查看其他哨兵 |
| `SENTINEL get-master-addr-by-name <name>` | 获取当前主库地址(应用获取) |
| `SENTINEL failover <name>` | 手动触发故障转移 |
| `SENTINEL flushconfig` | 把配置写回 sentinel.conf |

### 从库优先级与手动切换
- `slave-priority`(slave priority):从库优先级,**数值越小越优先被选为新主**;
  - 设为 0 表示该从库**永远不会被选为 master**(如只在备份的从库);
  - `CONFIG GET slave-priority` 查看,`CONFIG SET slave-priority 0` 设置。
- 故障转移期间,从库不可用;排除异常从库后按优先级选主。

## 24.9 Redis Cluster 集群(3.0+)

### 集群架构与数据分片
- 去中心化,所有节点互联(PING/PONG 心跳);数据通过 **hash slot(哈希槽)** 分布。
- 共 **16384 个槽位**,key 计算 `CRC16(key) % 16384` 决定落到哪个槽,每个主节点负责一段槽位。
- 集群由**多个主节点 + 从节点**组成:每个主节点至少一个从节点,主挂后从节点自动提升。

### 集群部署示例(3 主 3 从)
```bash
# ① 规划 6 个实例:3 台机器 × 2 端口(6380 主 / 6381 从)
mkdir -p /opt/redis_cluster/redis_{6380,6381}/{conf,logs,pid}
mkdir /data/redis_cluster/redis_{6380,6381}
# ② 配置文件启用集群
cluster-enabled yes
cluster-config-file nodes-6380.conf    # 集群节点信息文件
cluster-node-timeout 15000
# ③ 启动所有实例
redis-server /opt/redis_cluster/redis_6380/conf/redis_6380.conf
# ④ 节点互相发现(在任意节点执行 CLUSTER MEET)
redis-cli -h 172.16.1.90 -p 6380
CLUSTER MEET 172.16.1.90 6381
CLUSTER MEET 172.16.1.91 6380
CLUSTER MEET 172.16.1.92 6380
CLUSTER MEET 172.16.1.91 6381
CLUSTER MEET 172.16.1.92 6381
CLUSTER nodes        # 6 个节点都变成 master,互相认识
# ⑤ 分配哈希槽(3 个主节点各分一段)
redis-cli -h 172.16.1.90 -p 6380 cluster addslots {0..5461}
redis-cli -h 172.16.1.91 -p 6380 cluster addslots {5462..10922}
redis-cli -h 172.16.1.92 -p 6380 cluster addslots {10923..16383}
CLUSTER INFO         # cluster_state:ok,16384 槽全部分配
# ⑥ 指定从节点(CLUSTER REPLICATE 主节点 ID)
redis-cli -h 172.16.1.90 -p 6381 CLUSTER REPLICATE ad2ba4c5086b10a57ebb5179f05415a84ff44fdb
# 各从节点分别 REPLICATE 对应主节点
```

### 集群客户端访问(槽位重定向)
- 不带 `-c`:key 不在当前节点时报 `(error) MOVED 11998 172.16.1.92:6380`,客户端需按提示跳转。
- **加 `-c` 参数**:客户端自动重定向,如 `redis-cli -c -h 172.16.1.90 -p 6380`。
- 扩容迁移期间出现 `ASK` 重定向(数据正在迁移);`-c` 也能自动处理。

### Gossip 协议(集群节点间通信)
- 节点间通过 **Gossip 消息**交换状态,四种消息:
  - `meet`:邀请新节点加入集群;
  - `ping`:探活,节点定期互相发送;
  - `pong`:收到 ping/meet 后应答(确认存活、交换信息);
  - `fail`:某节点判定另一节点下线,广播该节点 ID。
- 槽位迁移期间 `CLUSTER SETSLOT <slot> MIGRATING/IMPORTING <node_id>` 控制迁移方向;`CLUSTER GETKEYSINSLOT <slot> <count>` 取该槽 key;`MIGRATE` 迁移数据。

### 集群故障转移与手动切换
- 主节点宕机 → 其从节点自动提升为主(`CLUSTER INFO` 变 ok 后恢复服务)。
- 手动切换:`CLUSTER FAILOVER`(在主节点上执行,与从节点完成切换)。
- 使用 `redis-trib.rb` 更简单(需要 Ruby 环境):
```bash
# 安装 ruby 与 redis gem
yum install rubygems
gem sources --remove https://rubygems.org/
gem sources -a http://mirrors.aliyun.com/rubygems/
gem install redis -v 3.3.5

# 创建集群(--replicas 1:每个主节点配 1 个从)
./redis-trib.rb create --replicas 1 \
  172.16.1.90:6390 172.16.1.91:6390 172.16.1.92:6390 \
  172.16.1.90:6391 172.16.1.91:6391 172.16.1.92:6391
./redis-trib.rb check 172.16.1.90:6390      # 检查集群
./redis-trib.rb reshard 172.16.1.90:6380    # 在线迁移槽位(扩容)
./redis-trib.rb rebalance 172.16.1.90:6380  # 槽位再平衡
./redis-trib.rb del-node <host:port> <node_id>  # 下线节点(先迁走它的槽)
```

### 集群扩容示例(增加 6395/6396)
1. 新节点:复制 6380 配置改成 6395/6396,启动;
2. `cluster meet` 让新节点加入集群;
3. `redis-trib.rb reshard` 把 4096 个槽位迁到新节点(自动迁移数据);
4. 迁移完成后新节点成为集群一员;下线节点则先把槽迁走再 `del-node`。

### CLUSTER 命令速查
```bash
CLUSTER INFO                  # 集群状态(ok/fail、槽分配情况)
CLUSTER NODES                 # 查看所有节点(ID/地址/角色/槽位)
CLUSTER MEET <ip> <port>      # 让节点加入集群
CLUSTER FORGET <node_id>      # 从集群移除节点
CLUSTER REPLICATE <node_id>   # 让当前节点成为指定主节点的从节点
CLUSTER ADDSLOTS <slot...>    # 把槽位分配给当前节点
CLUSTER DELSLOTS <slot...>    # 移除槽位
CLUSTER FLUSHSLOTS            # 清空所有槽位分配
CLUSTER SETSLOT <slot> NODE <node_id>          # 指定槽位归属节点
CLUSTER SETSLOT <slot> MIGRATING <node_id>     # 槽位迁出
CLUSTER SETSLOT <slot> IMPORTING <node_id>     # 槽位迁入
CLUSTER SETSLOT <slot> STABLE                  # 槽位迁移完成恢复
CLUSTER KEYSLOT <key>         # 计算 key 属于哪个槽
CLUSTER COUNTKEYSINSLOT <slot>   # 统计槽内 key 数量
CLUSTER GETKEYSINSLOT <slot> <count>           # 取槽内 key
```

## 24.10 Redis 数据迁移与诊断

### redis-migrate-tool(在线迁移)
- 支持 Redis 与 Redis 之间、不同集群之间的在线迁移。
```bash
git clone https://github.com/vipshop/redis-migrate-tool.git
cd redis-migrate-tool && autoreconf -fvi && ./configure && make && make install
```
- 配置文件 `redis_6379_to_6380.conf`:
```ini
[source]
type: single
servers:
- 172.16.1.90:6379
[target]
type: redis cluster
servers:
- 172.16.1.90:6380
[common]
listen: 0.0.0.0:8888
threads: 2
step: 1
mbuf_size: 1024
source_safe: true
```

### RDB 内存分析(rdbtools)
- 用 RDB 分析工具查看哪个 key 最占内存:
```bash
yum install python-pip gcc
pip install rdbtools
cd /data/redis_cluster/redis_6379/
rdb -c memory dump_6379.rdb -f 6379_memory.csv   # 导出 CSV
awk -F ',' '{print $4,$2,$3,$1}' 6379_memory.csv | sort > 6379.sort
```

## 24.11 Redis 高可用生产方案

- 生产标准组合:**主从复制 + 哨兵(Sentinel)+ 应用自动切换**,或直接使用 **Redis Cluster**。
- 故障转移流程(以 Cluster 为例):
  1. 主节点宕机;
  2. 从节点被提升为新主(自动 failover,也可手动 `CLUSTER FAILOVER`);
  3. 应用客户端重连并指向新主;
  4. 原主恢复后重新加入集群,自动成为新主的从节点;
  5. 用 `CLUSTER INFO` 确认 `cluster_state:ok`。
- 自动化运维:配合 **Ansible** 批量部署节点、批量修改配置;配合 **Git + GitLab + Ansible** 实现配置管理、发布与批量变更。
- 日常检查命令:`info memory`、`info clients`、`info stats`、`slowlog get`、`cluster info` 等。


---

# 第25课 Elasticsearch 搜索引擎(6.6)

## 25.1 Elasticsearch 介绍

- **Elasticsearch 是一个实时的分布式搜索分析引擎**,能以极快的速度和规模探索数据;用于**全文检索、结构化搜索、分析**以及三者组合。
- 基于 **Apache Lucene** 的开源搜索引擎。Lucene 是最先进、性能最好、功能最全的搜索库,但它只是一个 **Java 库**,集成和使用都很复杂。
- Elasticsearch 用 Java 开发,**以 Lucene 为核心**实现所有索引和搜索功能,通过简单的 **RESTful API** 隐藏 Lucene 的复杂性,让全文搜索变得简单。

### 为什么用 ES(对比 MySQL)
- MySQL 也能搜索,如 `like '%xxx%'` 但需要**全表扫描**,性能差;
- ES 非常适合全文检索,可灵活存储不同类型的数据。

### 应用场景
- 商城的商品搜索;所有产品的评论搜索;
- **高亮显示**搜索内容;
- 收集展示各种日志(配合 ELK/EFK 架构)。

## 25.2 数据格式(JSON 文档)

- ES 使用 **JSON** 作为文档序列化格式(NoSQL 标准格式),简单、简洁、易读。
```json
{
  "email": "john@smith.com",
  "first_name": "John",
  "last_name": "Smith",
  "info": { "bio": "Eco-warrior...", "age": 25, "interests": ["dolphins", "whales"] },
  "join_date": "2014/05/01"
}
```

## 25.3 安装部署

### 安装方式对比
| 方式 | 优点 | 缺点 |
|---|---|---|
| docker | 部署方便、开箱即用、启动迅速 | 需 docker 知识;改配置麻烦需重建镜像;数据要挂载目录 |
| tar | 部署灵活、对系统侵占性小 | 需自己写启动管理文件;目录需提前规划 |
| rpm/deb | 部署方便、启动脚本即用、目录标准化 | 组件分散在不同目录;卸载不干净;默认配置需改 |
| ansible | 极其灵活、批量部署快 | 需学 ansible;需提前规划标准;需专人维护 |

### RPM 安装
```bash
### 安装 java
yum install -y java-1.8.0-openjdk.x86_64
### 下载安装软件
mkdir -p /data/es_soft/
cd /data/es_soft/
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.6.0.rpm
rpm -ivh elasticsearch-6.6.0.rpm
### 配置启动
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
### 检查
ps -ef|grep elastic
lsof -i:9200
```

### 目录文件说明
```bash
rpm -ql elasticsearch   # 查看安装目录
rpm -qc elasticsearch   # 查看配置文件
```
| 文件/目录 | 说明 |
|---|---|
| /etc/elasticsearch/elasticsearch.yml | 主配置文件 |
| /etc/elasticsearch/jvm.options | JVM 虚拟机配置(内存等) |
| /etc/init.d/elasticsearch | init 启动文件 |
| /etc/sysconfig/elasticsearch | 环境变量配置文件 |
| /usr/lib/sysctl.d/elasticsearch.conf | sysctl 变量(最大描述符) |
| /usr/lib/systemd/system/elasticsearch.service | systemd 启动文件 |
| /var/lib/elasticsearch | 数据目录 |
| /var/log/elasticsearch | 日志目录 |
| /var/run/elasticsearch | pid 目录 |

### 核心配置(elasticsearch.yml)
```yaml
egrep -v "^#" /etc/elasticsearch/elasticsearch.yml
cluster.name: dba5            # 集群名称(同名节点自动组成集群)
node.name: node-1             # 节点名称
path.data: /data/elasticsearch # 数据目录
path.logs: /var/log/elasticsearch # 日志目录
bootstrap.memory_lock: true   # 锁定内存,防 swap
network.host: localhost       # 绑定 IP
http.port: 9200               # HTTP 端口
discovery.zen.ping.unicast.hosts: ["localhost"]  # 集群发现节点
discovery.zen.minimum_master_nodes: 2            # 最小主节点数(防脑裂)
```

### 启动失败:锁定内存
- 配置 `bootstrap.memory_lock: true` 后启动可能失败(日志报 mlockall 失败)。
- 解决:修改 systemd 启动文件:
```bash
systemctl edit elasticsearch      # 或 vim /usr/lib/systemd/system/elasticsearch.service
# [Service] 下增加:
LimitMEMLOCK=infinity
systemctl daemon-reload
systemctl restart elasticsearch
```
- 官方文档:setup-configuration-memory.html / setting-system-settings.html。

## 25.4 核心术语与概念

| 术语 | 说明(类比 MySQL) |
|---|---|
| 索引词 term | 能被索引的**精确值**;`foo`、`Foo`、`FOO` 是不同的索引词;用 term 查询精确搜索 |
| 文本 text | 普通非结构化文字,会被分词成索引词存储;文本字段需要事先分析 |
| 分析 analysis | 把文本转换为索引词的过程,结果依赖**分词器**(如 `FOO BAR` 和 `foo bar` 可能分析成相同索引词 foo/bar) |
| 集群 cluster | 一个或多个节点组成,对外提供索引和搜索;有唯一名称(默认 elasticsearch),同名节点自动加入 |
| 节点 node | 逻辑上独立的服务,是集群一部分,可存储数据、参与索引和搜索;有唯一名字 |
| 分片 shard | 单个 Lucene 实例,索引被分解成多个分片,可托管在集群任意节点;**分片一旦建立数量不能修改** |
| 主分片 | 文档先存主分片,再复制到副本;**默认一个索引 5 个主分片** |
| 副本分片 | 主分片的复制:① 高可用(主分片挂,副本提升为主)② 提升性能(查询可走副本);**副本必须部署在不同节点**;默认 1 个,可动态调整 |
| 索引 index | 具有相同结构的文档集合(≈ MySQL 的数据库/表);名字全小写 |
| 类型 type | 索引内的逻辑分区(≈ 表),如一个索引里分 user/blog/comment 类型(6.x 后逐步废弃) |
| 文档 doc | 存储在 ES 中的 JSON 字符串(≈ 表的一行),有 _type 和 _id |
| 映射 mapping | 定义索引中每个字段的类型(≈ 表结构),可预定义或首次存文档时自动识别 |
| 字段 field | 文档中的键值对(≈ 表的列),可指定如何分析 |
| _id | 文档唯一标识,不提供时系统自动生成;index/type/id 三者唯一确定一个文档 |

### 分片/副本要点(面试重点)
- 默认每个索引 **5 主分片 + 1 副本** = 10 个分片,集群至少 2 个节点才 green。
- **分片数量创建后不能修改;副本数量可随时改**。
- 单分片最大文档数:Lucene 极限 2,147,483,519(=integer.max_value-128)。
- 分片作用:① 水平分割扩展数据 ② 并行操作提升性能。

## 25.5 交互方式

- 所有语言通过 **RESTful API**(端口 9200)通信;通用格式:
```bash
curl -X<VERB> '<PROTOCOL>://<HOST>:<PORT>/<PATH>?<QUERY_STRING>' -d '<BODY>'
# VERB: GET/POST/PUT/HEAD/DELETE; PATH 如 _count、_cluster/stats; ?pretty 美化输出
```
| 方式 | 特点 |
|---|---|
| curl 命令 | 最繁琐复杂易错;无需安装任何软件 |
| es-head 插件 | 查看数据方便、操作容易;需要 node 环境 |
| kibana | 查看数据与报表格式丰富、操作简单;需要 java 环境并安装配置 |

### es-head 插件部署(两种方式)
```bash
# 方式一:docker
docker pull alivv/elasticsearch-head
docker run --name es-head -p 9100:9100 -dit alivv/elasticsearch-head
# 方式二:nodejs 编译
yum install nodejs npm openssl screen -y
npm install -g cnpm --registry=https://registry.npm.taobao.org
cd /opt/ && git clone git://github.com/mobz/elasticsearch-head.git
cd elasticsearch-head/ && cnpm install
screen -S es-head && cnpm run start    # Ctrl+A+D 后台
# 修改 ES 配置文件支持跨域:
http.cors.enabled: true
http.cors.allow-origin: "*"
```

## 25.6 ES API 实战(CRUD + 搜索)

### 创建索引 & 插入文档
```bash
# 创建索引
curl -XPUT '192.168.47.178:9200/vipinfo?pretty'
# 插入文档(index/type/id)
curl -XPUT 'localhost:9200/vipinfo/user/1?pretty' -H 'Content-Type: application/json' -d'
{ "first_name" : "John", "last_name": "Smith", "age" : 25,
  "about" : "I love to go rock climbing", "interests": [ "sports", "music" ] }'
```
- 文档三个必须元数据:`_index`(存哪)、`_type`(对象类别)、`_id`(唯一标识)。

### 查询
```bash
# 查询索引中全部文档
curl -XGET localhost:9200/vipinfo/user/_search?pretty
# 查询指定文档
curl -XGET 'localhost:9200/vipinfo/user/1?pretty'
# 按条件(URL 参数):搜索姓氏 Smith
curl -XGET 'localhost:9200/vipinfo/user/_search?q=last_name:Smith&pretty'
# Query-string 方式(match 查询)
curl -XGET 'localhost:9200/vipinfo/user/_search?pretty' -H 'Content-Type: application/json' -d'
{ "query" : { "match" : { "last_name" : "Smith" } } }'
# 过滤器查询:姓氏 Smith 且 age > 30(filter 高效结构化查询)
curl -XGET 'localhost:9200/vipinfo/user/_search?pretty' -H 'Content-Type: application/json' -d'
{ "query" : { "bool": {
    "must":   { "match": { "last_name": "smith" } },
    "filter": { "range": {"age": { "gt": 30 }} } } } }'
```

### 更新(两种方式)
```bash
# PUT 更新:必须填写完整信息(全量覆盖)
curl -XPUT 'localhost:9200/vipinfo/user/1?pretty' -H 'Content-Type: application/json' -d'
{ "first_name": "John", "last_name": "Smith", "age": 27, "about": "...", "interests": [...] }'
# POST 更新:只需填写需要更改的字段(部分更新)
curl -XPOST 'localhost:9200/vipinfo/user/1?pretty' -H 'Content-Type: application/json' -d'{ "age": 29 }'
```

### 删除
```bash
# 删除指定文档(返回 result: deleted)
curl -XDELETE 'localhost:9200/vipinfo/user/1?pretty'
# 删除整个索引
curl -XDELETE 'localhost:9200/vipinfo?pretty'     # acknowledged: true
```

## 25.7 ES 集群

- 可横向扩展至数百/数千节点,处理 PB 级数据;**天生分布式,屏蔽了分布式复杂性**。
- 后台自动执行:文档分配到分片、按节点均衡分片(负载均衡)、复制分片(冗余防硬件故障)、路由请求、扩容时无缝整合新节点并重新分配分片。
- 集群由**相同 cluster.name** 的节点组成;节点加入/移除时自动重新平均分布数据。
- **主节点**:负责集群范围内变更(增删索引/节点),**不涉及文档级变更和搜索**,流量增加也不会成为瓶颈;任何节点都可成为主节点;请求可发给集群任意节点,节点自动路由并汇总结果。

### 集群部署
- 和单机安装没区别,只是配置文件加上集群参数(每节点改 node.name / IP):
```yaml
cluster.name: dba6
node.name: node-1
network.host: localhost,localhost    # 本机 IP
discovery.zen.ping.unicast.hosts: ["IP1","IP2"]   # 集群发现 IP
discovery.zen.minimum_master_nodes: 1
```

### 集群健康检查
```bash
curl -XGET 'http://localhost:9200/_cluster/health?pretty'
```
| status | 含义 |
|---|---|
| green | 所有主分片和副本分片都正常运行 |
| yellow | 所有主分片正常运行,但**不是所有副本分片**正常运行(如单节点只有 1 个副本时无法分配) |
| red | **有主分片没能正常运行** |

### 其他集群 API
```bash
curl -XGET 'http://localhost:9200/_cluster/stats?human&pretty'              # 集群统计
curl -XGET 'http://localhost:9200/_cluster/settings?include_defaults=true&human&pretty'  # 集群设置
curl -XGET 'http://localhost:9200/_nodes/process?human&pretty'              # 节点状态
curl -XGET 'http://localhost:9200/_nodes/_all/info/jvm,process?human&pretty'
curl -XGET 'http://localhost:9200/_cat/nodes?human&pretty'
```

### 分片与副本管理
```bash
# 默认 5 分片 1 副本
curl -XPUT 'localhost:9200/index1?pretty'
# 手动指定分片/副本数(创建时)
curl -XPUT 'localhost:9200/index2?pretty' -H 'Content-Type: application/json' -d'
{ "settings": { "number_of_shards": 3, "number_of_replicas": 1 } }'
# 调整副本数(分片数不能改!)
curl -XPUT 'localhost:9200/index2/_settings?pretty' -H 'Content-Type: application/json' -d'
{ "settings": { "number_of_replicas": 2 } }'
```

### 节点故障演示
- 关闭 Node1:失去主分片 1、2 → 集群变 **red**;随后其他节点上的副本分片**立即被提升为主分片** → 集群变 **yellow**(因为要求的 2 份副本只剩 1 份,凑不齐 green)。
- 只要还有节点保留每片副本,程序就能不丢数据运行;重启 Node1 后集群自动重新分配缺失的副本。

## 25.8 x-pack 监控

- x-pack 为 ES/logstash/kibana 提供**监控、报警、用户认证**等功能的集成插件。
- 6.x 以前是独立插件,6.x 以后**默认集成在软件包里**;功能分开源/基础/黄金/铂金四版,默认基础版。
- **6.3 以后官方把监控功能免费了**,基础版即可用官方监控。
```bash
# 开启数据监控
curl -XPUT '_cluster/settings' -d '{"persistent": {"xpack.monitoring.collection.enabled": true}}'
# ES 配置文件追加:
xpack.monitoring.exporters.my_local:
  type: local
```

## 25.9 权限认证:Search Guard

- x-pack 的安全认证是收费功能,替代方案:**Search Guard**(开源)。
- 官方文档:docs.search-guard.com(installation / demo-installer / versions)。

## 25.10 优化与运维

### 系统优化(官方 system-config)
1. **JVM 最大/最小内存调整**(/etc/elasticsearch/jvm.options,建议 Xms=Xmx,不超过物理内存一半);
2. **关闭 SWAP 分区**(配合 bootstrap.memory_lock: true);
3. **vm.max_map_count 调整**(ES 默认要求 ≥ 262144,否则启动报错:`sysctl -w vm.max_map_count=262144`);
4. **ulimit 调整**(文件描述符 nofile、进程数 nproc,elasticsearch.conf 已设置);
5. 磁盘性能(SSD 等)。

### 备份与恢复:elasticsearch-dump
```bash
# github.com/taskrabbit/elasticsearch-dump
elasticdump --input=http://localhost:9200/index --output=index.json --type=data   # 导出
elasticdump --input=index.json --output=http://localhost:9200/index --type=data   # 导入
```

### Python 操作
- 官方客户端:pypi.org/project/elasticsearch(elasticsearch-py)。

### 防脑裂配置(面试重点)
```yaml
discovery.zen.minimum_master_nodes: 2     # 最少几个"候选主节点"参与选举才认定集群可用
discovery.zen.fd.ping_interval: 10s       # 节点探活间隔
discovery.zen.fd.ping_timeout: 60s        # 探活超时
discovery.zen.fd.ping_retries: 6          # 探活重试次数
```
- **minimum_master_nodes 推荐 = (主节点数/2)+1**,防止网络分区出现两个主节点(脑裂)。

## 25.11 项目实战:中文分词器(IK)

```bash
# 安装分词器插件
cd /usr/share/elasticsearch/bin
./elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v6.4.2/elasticsearch-analysis-ik-6.4.2.zip
# 创建索引和映射(指定 analyzer)
curl -XPUT http://localhost:9200/index
curl -XPOST http://localhost:9200/index/fulltext/_mapping -H 'Content-Type:application/json' -d'
{ "properties": { "content": { "type": "text",
    "analyzer": "ik_max_word", "search_analyzer": "ik_max_word" } } }'
# 插入文档
curl -XPOST 'http://localhost:9200/index/fulltext/1' -H 'Content-Type:application/json' -d'
{"content":"美国留给伊拉克的是个烂摊子吗"}'
curl -XPOST 'http://localhost:9200/index/fulltext/2' -H 'Content-Type:application/json' -d'
{"content":"公安部:各地校车将享最高路权"}'
# 搜索 + 高亮
curl -XPOST 'http://localhost:9200/index/fulltext/_search?pretty' -H 'Content-Type:application/json' -d'
{ "query": { "match": { "content": "中国" } },
  "highlight": { "pre_tags": ["<tag1>"], "post_tags": ["</tag1>"], "fields": { "content": {} } } }'
```

## 25.12 项目实战:日志收集展示(EFK/ELK 全家桶)

### 架构
Nginx(产生 JSON 格式日志) → filebeat(采集) → Redis(队列缓冲) → Logstash(过滤) → Elasticsearch(存储) → Kibana(展示)

### ① Nginx 日志改成 JSON 格式
```nginx
log_format access_json '{"@timestamp":"$time_iso8601",'
'"host":"$server_addr","clientip":"$remote_addr",'
'"size":$body_bytes_sent,"responsetime":$request_time,'
'"upstreamtime":"$upstream_response_time","upstreamhost":"$upstream_addr",'
'"http_host":"$host","url":"$uri","domain":"$host",'
'"xff":"$http_x_forwarded_for","referer":"$http_referer","status":"$status"}';
```

### ② Redis 队列(中转)
```ini
daemonize yes
bind localhost
port 6380
databases 16
```

### ③ filebeat 采集
```yaml
filebeat.prospectors:
- type: log
  enabled: true
  paths:
  - /usr/local/nginx/logs/*access.log
  json.keys_under_root: true
  json.overwrite_keys: true
output.redis:
  hosts: ["localhost"]
  key: "filebeat"
  db: 0
  timeout: 5
# 验证:redis-cli → keys * / LLEN filebeat / RPOP filebeat
```

### ④ Logstash 过滤 + 输出到 ES
```
input {
  redis { host => "localhost" port => "6380" db => "0" key => "filebeat" data_type => "list" }
}
filter {
  mutate { convert => ["upstream_time","float"] convert => ["request_time","float"] }
}
output {
  if [source] == "/usr/local/nginx/logs/act.goumin.com_access.log" {
    elasticsearch { hosts => "http://localhost:9200" manage_template => false index => "act-%{+YYYY.MM}" }
  }
  if [source] == "/usr/local/nginx/logs/app.goumin.com_access.log" {
    elasticsearch { hosts => "http://localhost:9200" manage_template => false index => "app-%{+YYYY.MM}" }
  }
}
```
- 也可以直接用 filebeat 的 nginx module 收集(filebeat-module-nginx)。


---

# 第26课 MongoDB 数据库(3.4)

## 26.1 MongoDB 介绍

- **MongoDB** 是文档型 NoSQL 数据库,数据以 **JSON 格式文档**存储,集合不需要指定 schema(动态结构)。
- 支持 CRUD(create/read/update/delete);**不支持 SQL**,但有自己丰富的查询语言。
- **事务**:3.4 不支持多文档事务(4.0 开始支持 ACID);但**单个文档上的操作是原子的**。
- **主键**:每个文档必须有唯一的 `_id` 字段(主键),省略时驱动自动生成 ObjectId;插入时 `upsert: true` 也可用于更新插入。
- 写操作都针对单个集合,基于单文档级别执行。

## 26.2 安装部署

### 官方文档与下载
- 官方:docs.mongodb.com/manual;下载:mongodb.com/download-center/community
- 选用 tar 包:`https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.4.20.tgz`

### 安装与目录规划(软连接方式)
```bash
mkdir /data/soft -p && cd /data/soft/
wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.4.20.tgz
tar zxvf mongodb-linux-x86_64-3.4.20.tgz -C /opt/
cd /opt/ && ln -s mongodb-linux-x86_64-3.4.20 mongodb   # 软连接
mkdir /data/mongodb                                        # 数据目录
mkdir /opt/mongodb/{conf,logs,pid}                         # 配置/日志/PID
```

### 配置文件 mongodb.conf(YAML 格式)
```yaml
systemLog:
  destination: file          # 日志输出到文件
  logAppend: true            # 重启后追加到旧日志,不新建
  path: /opt/mongodb/logs/mongodb.log   # 日志路径
storage:
  dbPath: /data/mongodb      # 数据存储目录
  journal:
    enabled: true            # 回滚日志(journal)
  directoryPerDB: true       # 每个库一个目录
  wiredTiger:
    engineConfig:
      cacheSizeGB: 1         # 数据缓存最大大小
      directoryForIndexes: true   # 索引存到独立子目录
processManagement:
  fork: true                 # 后台运行
  pidFilePath: /opt/mongodb/pid/mongod.pid
net:
  port: 27017                # 监听端口
  bindIp: 127.0.0.1,192.168.47.175   # 绑定 IP
# replication:               # 副本集(开启后生效)
#   oplogSizeMB: 1024        # 复制操作日志大小
#   replSetName: goumin      # 副本集名称,同一副本集必须相同
```

### 启动 / 检查 / 连接 / 关闭
```bash
# 启动
/opt/mongodb/bin/mongod -f /opt/mongodb/conf/mongodb.conf
# 检查
ps -ef|grep mongo
netstat -lntup|grep 27017
# 写入环境变量
echo 'PATH=$PATH:/opt/mongodb/bin' >> /etc/profile && source /etc/profile
# hosts 解析(副本集/多节点必须)
echo "192.168.47.175 mdb1" >> /etc/hosts
# 连接
mongo mdb1:27017
# 关闭:建议用内置命令(必须 localhost 登录)
mongo localhost:27017
> use admin
> db.shutdownServer()
```

### 启动警告(必须处理)
- 不开启认证会有 WARNING:Access control is not enabled(见 18.6)。
- **transparent_hugepage(THP)警告**:MongoDB 建议关闭透明大页。

## 26.3 警告优化:关闭 THP

```bash
# 查看状态:默认 [always]
cat /sys/kernel/mm/transparent_hugepage/enabled
cat /sys/kernel/mm/transparent_hugepage/defrag
# 关闭
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/defrag
# 检查:变为 always madvise [never] 即成功
```

## 26.4 基本操作

### 显示/帮助命令
```
help                        # 显示帮助
db.help()                   # 数据库方法帮助
db.<collection>.help()      # 集合方法帮助
show dbs                    # 列出所有数据库
use <db>                    # 切换数据库
show collections            # 列出当前库所有集合
show users / show roles     # 用户 / 角色列表
show profile                # 最近 5 个耗时 >= 1ms 的操作
load()                      # 执行 JavaScript 文件
```

### 索引
- **前台创建索引会阻塞该库所有读写**;大批量建索引用 `background: true` 后台构建。
```js
// 创建索引(age 升序),后台执行
db.test.createIndex({ age: 1 }, { background: true })
// 查看索引
db.test.getIndexes()
// 删除索引
db.test.dropIndex({ name: 1 })
// 查看执行计划(COLLSCAN 全表扫描 → 建索引后变 IXSCAN 索引扫描)
db.test.find({"age":{ $lt: 30 }}).explain()
```
- 索引优化前后对比:`winningPlan.stage` 从 `COLLSCAN`(全集合扫描)变为 `FETCH` + `IXSCAN`(索引扫描)。

### 插入数据
```js
// 单行插入
db.test.insert({"name":"zhangya","age":27,"ad":"北京市朝阳区"})
// 多行插入
db.inventory.insertMany([
  { "item": "journal", "qty": 25, "size": { "h": 14, "w": 21, "uom": "cm" }, "status": "A" },
  { "item": "notebook", "qty": 50, "size": { "h": 8.5, "w": 11, "uom": "in" }, "status": "A" },
  { "item": "paper", "qty": 100, "size": { "h": 8.5, "w": 11, "uom": "in" }, "status": "D" }
])
```

### 查询数据
```js
db.test.find()                    // 查询所有
db.test.findOne()                 // 查询单条
db.inventory.find({ status: "D" })              // 条件:status = D
db.inventory.find({ "size.uom": "in" })         // 嵌套字段用点
db.inventory.find({ status: "A", qty: { $lt: 30 } })          // AND
db.inventory.find({ $or: [ { status: "A" }, { qty: { $lt: 30 } } ] })  // OR
db.inventory.find({ status: "A", $or: [ { qty: { $lt: 30 } }, { item: /^p/ } ] }) // + 正则
```

### 更新数据
```js
// 更新单个文档($set 修改,$currentDate 自动加当前时间)
db.inventory.updateOne(
  { "item": "paper" },
  { $set: { "size.uom": "cm", "status": "P" }, $currentDate: { "lastModified": true } }
)   // matchedCount: 1, modifiedCount: 1
// 更新多条
db.inventory.updateMany(
  { "qty": { $lt: 50 } },
  { $set: { "size.uom": "cm", "status": "P" }, $currentDate: { "lastModified": true } }
)   // matchedCount: 2, modifiedCount: 2
```

### 删除数据
```js
db.inventory.deleteOne({ "status": "D" })     // 删除单条:deletedCount: 1
db.inventory.deleteMany({ "status": "P" })    // 删除多条:deletedCount: 3
```

## 26.5 常用工具

| 工具 | 说明 |
|---|---|
| mongod | MongoDB 主守护进程,处理数据请求、管理数据访问、执行后台管理 |
| mongos | **分片集群路由服务**,接收应用层查询,定位数据在分片集群中的位置;对应用来说与普通实例无异 |
| mongostat | 概览当前 mongod/mongos 状态(类似 vmstat) |
| mongotop | 跟踪实例读写耗时,提供每个集合级别统计,默认每秒返回 |
| mongooplog | 从远程服务器复制 oplog 操作应用到本地,支持实时迁移:`mongooplog --from mongodb0.example.net --host mongodb1.example.net` |
| mongoperf | 独立检查磁盘 I/O 性能:`echo "{nThreads:16, fileSizeMB:10000, r:true, w:true}" | mongoperf`(16 线程、10GB 测试文件随机读写) |

## 26.6 授权认证

### 用户管理命令
```
db.auth()                  # 验证用户
db.createUser()            # 创建新用户
db.changeUserPassword()    # 修改密码
db.dropUser() / db.dropAllUsers()   # 删除用户
db.getUser() / db.getUsers()        # 查看用户
db.grantRolesToUser() / db.revokeRolesFromUser()  # 授予/撤销角色
db.updateUser()            # 更新用户
```
- **注意:在数据库中创建的第一个用户应是具有管理其他用户权限的用户管理员(root)**。

### 创建管理员
```js
mongo mdb1:27017
db.createUser({user: "admin", pwd: "123456", roles:[ { role: "root", db: "admin" } ]})
```
- role=root(超级用户)+ db=admin。

### 开启认证(配置文件加)
```yaml
security:
  authorization: enabled    # 启用基于角色的访问控制
```
- 重启节点后,不用账号密码登录:执行任何操作都报 `Unauthorized`(code 13)。
- 带账号密码登录:`mongo mdb1:27017 -u admin -p`(交互输入密码)。

### 不同账号不同权限
```js
use test
db.createUser({
  user: "myTester", pwd: "xyz123",
  roles: [ { role: "readWrite", db: "test" }, { role: "read", db: "test2" } ]
})
// 登录后可读写 test 库;切到 test2 库只读,写入报错
```

## 26.7 副本集(Replica Set)

### 副本集介绍
- 一组 mongod 实例组成;**Primary(主)负责写,Secondary(从)负责读**,自动故障转移。
- 数据通过 **oplog(操作日志)** 同步;主挂了自动选举新主,从库自动重新同步。
- 从库默认**不可读**(`not master and slaveOk=false`,code 13435),需执行 `rs.slaveOk()` 才能读;写入报 `not master`(code 10107)。

### 部署(单机多实例 3 节点)
```bash
# ① 目录规划
mkdir -p /opt/mongodb2801{7,8,9}/{conf,logs,pid}
# ② 配置文件(28017 模板)
cat /opt/mongodb28017/conf/mongodb28017.conf
# 其他配置同单机,关键加:
replication:
  oplogSizeMB: 1024        # 复制操作日志大小
  replSetName: dba6        # 副本集名称,同副本集必须一致
net:
  port: 28017
# 复制并批量改端口
cp .../28017.conf .../28018.conf && sed -i 's#28017#28018#g' .../28018.conf
# ③ 创建数据目录
mkdir /data/mongodb2801{7,8,9}
# ④ 启动所有节点
mongod -f /opt/mongodb28017/conf/mongodb28017.conf
mongod -f /opt/mongodb28018/conf/mongodb28018.conf
mongod -f /opt/mongodb28019/conf/mongodb28019.conf
# ⑤ 初始化副本集(在 28017 执行)
mongo mdb1:28017
config = {
  _id : "dba6",
  members : [
    {_id : 0, host : "mdb1:28017"},
    {_id : 1, host : "mdb1:28018"},
    {_id : 2, host : "mdb1:28019"}
  ]
}
rs.initiate(config)     # { "ok" : 1 }
# 提示符变为 dba6:PRIMARY>
```

### 查看状态与数据测试
```js
rs.status()      // 查看副本集状态(每个成员 stateStr:PRIMARY/SECONDARY)
rs.conf()        // 查看集群配置
rs.slaveOk()     // 从库开启可读
// 主库写、从库读验证同步;从库删除报 not master
```

### 故障转移测试
```bash
kill 16548        # 杀掉主节点(28017)
# 登录 28019:自动变成 PRIMARY(选举产生新主)
# 新主写入数据 → 从库 rs.slaveOk() 后能查到
# 重启 28017:自动加入集群成为 SECONDARY,数据自动补同步
```

### 权重调整(选举优先权)
- 默认所有节点 `priority: 1`,都可以竞选主节点;priority **值越大越优先被选为主**,设为 0 则永不成为主。
```js
config.members[0].priority = 90   // 修改配置
rs.reconfig(config)               // 生效
rs.stepDown()                     // 主节点主动降级(触发重新选举)
```

### 增加 / 删除节点
```js
// 新增节点(先复制目录、改配置、启动、清数据目录)
rs.add("mdb1:28010")              // 主库执行,新节点自动变 SECONDARY
// 删除节点
rs.remove("mdb1:28010")           // 主库执行,节点状态变 OTHER,可安全关闭
```

### 增加仲裁节点(Arbiter)
- **Arbiter 只参与投票选举,不能被选为 Primary,也不从 Primary 同步数据**;用于奇数票数避免"票数相等"(比如 2 数据节点 + 1 仲裁 = 3 票)。
```js
// ① 清空新节点数据目录后重启(rm -rf /data/mongodb28010/*)
// ② 主库执行
rs.addArb("mdb1:28010")
rs.status()   // 该成员 stateStr: ARBITER(state 7)
```

## 26.8 升级步骤(滚动升级)

1. 首先确保是副本集状态;
2. 先关闭 1 个副本节点;
3. 检测数据是否可以升级;
4. 升级副本节点的可执行文件;
5. 更新配置文件;
6. 启动升级后的副本节点;
7. 确保集群工作正常;
8. 滚动升级其他副本节点;
9. 最后主节点降级(`rs.stepDown()`);
10. 确保集群可用;
11. 关闭降级的老的主节点;
12. 升级老的主节点;
13. 重新加入集群。

## 26.9 运维

### 数据备份与恢复
```bash
mongodump --host mdb1:27017 -u admin -p 123456 -o /backup/      # 全量备份
mongorestore --host mdb1:27017 -u admin -p 123456 /backup/      # 恢复
# 指定库/集合备份:--db dbname --collection collname
```
- 生产建议:副本集环境在从库备份,配合 oplog 做时间点恢复。

### 客户端工具
- **Robo 3T / Studio 3T**(图形化客户端)、mongosh(官方 shell)、pymongo(Python 驱动)等。


---

