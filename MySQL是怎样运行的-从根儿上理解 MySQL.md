# MySQL 是怎样运行的 · 从根儿上理解 MySQL（通俗精讲 + 实战）

> 以 **MySQL 5.7** 为标准版本，风格：**一句话本质 → 通俗解释 → 实战命令 → 面试速记**。
> 目标：把"MySQL 底层到底怎么跑的"讲透，既要懂原理，也能上手验证。
> 文中所有命令、参数、系统变量均以 MySQL 5.7 行为为准；与 8.0 差异处会单独标注。

---

## 第1章　初识 MySQL

### 1.1　MySQL 的客户端/服务器架构
- **本质**：MySQL 是 C/S（客户端-服务器）架构。一个常驻进程 **mysqld** 在后台管数据，你敲的 `mysql` 命令只是连上去的"遥控器"。
- 通俗解释：
  - **服务器进程（mysqld）**：真正干活的，负责存数据、执行 SQL、保证安全。它一直开着，等你连。mysqld 是**单进程多线程**模型——一个进程内开多个线程服务不同连接。
  - **客户端进程（mysql / navicat / 你的程序）**：发请求、收结果。客户端有很多种，但服务器只有一个。
- MySQL 服务器自己又分三层，一条 SQL 进来要过这三关：
  ```text
  客户端( mysql / JDBC / Navicat )
            │  (TCP/命名管道/Unix socket 三种通信方式)
            ▼
  ┌─────────────────────────────────────────────┐
  │  MySQL 服务器 (mysqld, 单进程多线程)          │
  │                                               │
  │  ① 连接管理     ② 解析与优化      ③ 存储引擎  │
  │  连接池/鉴权    SQL解析→查询缓存   插件式      │
  │  线程处理         →优化器选计划    InnoDB等    │
  └─────────────────────────────────────────────┘
            │
            ▼
        文件系统 (数据目录 / 表空间)
  ```
  - **连接管理**：负责握手、鉴权、分配线程；客户端断开前一直占用一个线程。
  - **解析与优化**：SQL 词法/语法解析 → 查询缓存（8.0 已移除，见下）→ 优化器选执行计划。
  - **存储引擎**：真正读写数据的"插件"，InnoDB / MyISAM 等可插拔，5.7 默认 InnoDB。
- 实战：启动与连接
  ```bash
  # 启动服务器（Linux，方式依安装而定）
  mysqld_safe &          # 或 systemctl start mysqld
  
  # 客户端连接
  mysql -h 127.0.0.1 -P 3306 -u root -p
  ```
- 三种通信方式：
  | 方式 | 适用 | 示例 |
  |---|---|---|
  | TCP/IP | 跨机/本机皆可 | `mysql -h 127.0.0.1 -P 3306` |
  | 命名管道(Named Pipe) | Windows 本机 | `mysql --pipe` |
  | Unix Socket | Linux 本机 | `mysql -S /tmp/mysql.sock` |
- 面试速记：MySQL = 一个服务器进程 mysqld（单进程多线程）+ 多个客户端；客户端发 SQL，服务器三层（连接→解析优化→存储引擎）处理后返回。

### 1.2　MySQL 安装（5.7 要点）

- 本质：装好三样东西——**服务器程序、客户端程序、数据目录**。
- 启动服务器的几种方式（其本质不同，生产中推荐 `mysql.server` / systemd）：
  ```bash
  mysqld                 # 直接拉起，前台运行，退出即停
  mysqld_safe &          # 监控 mysqld，崩了自动拉起，推荐
  mysql.server start     # 封装了 mysqld_safe 的 SysV 脚本
  systemctl start mysqld # systemd 管理（现代发行版）
  ```
- 实战（Linux Yum 装 5.7）：
  ```bash
  yum install -y mysql-community-server
  systemctl start mysqld
  # 5.7 首次启动会生成临时 root 密码，存在日志里
  grep 'temporary password' /var/log/mysqld.log
  mysql_secure_installation   # 改密码、删匿名用户
  ```
- 面试速记：5.7 区别于 8.0——默认密码策略更强、首次启动生成临时密码、默认字符集 latin1（8.0 改 utf8mb4）。

### 1.3　启动选项和系统变量
- **本质**：
  - **启动选项（option）**：命令行或配置文件里给 mysqld 的"启动指令"，如 `--port=3306`。
  - **系统变量（system variable）**：mysqld 运行过程中可读取/修改的参数，如 `max_connections`。
  - 关系：启动选项负责"启动时设初值"，系统变量是"运行时的值"，**大多数启动选项会映射成一个系统变量**（去掉前导 `--`、下划线变点）。
- 实战：
  ```bash
  # 命令行选项
  mysqld --port=3306 --default-storage-engine=InnoDB
  
  # 配置文件（推荐，/etc/my.cnf）
  [mysqld]
  port=3306
  default-storage-engine=InnoDB
  max_connections=200
  
  # 查看系统变量
  SHOW VARIABLES LIKE 'max_connections';
  SELECT @@max_connections;
  SELECT @@global.max_connections, @@session.max_connections;
  
  # 动态修改（仅部分支持，且重启失效除非写配置文件）
  SET GLOBAL max_connections = 500;
  ```
- 长选项 vs 短选项、选项值带 `-` 时加 `=` 防歧义（`--sort-buffer-size=4M`）。
- 面试速记：启动选项 = 启动指令；系统变量 = 运行时参数；`SHOW VARIABLES` 看，`SET GLOBAL` 改。

### 1.4　配置文件的使用
- 本质：MySQL 按固定顺序读配置文件，后读的覆盖先读的。
- 读取顺序（Linux）：`/etc/my.cnf` → `/etc/mysql/my.cnf` → `/usr/etc/my.cnf` → `~/.my.cnf`。用 `mysqld --verbose --help | grep -A1 "Default options"` 可看实际顺序。
- 配置文件按**选项组（group）**归类，不同程序读不同组：
  ```ini
  [server]            # 所有服务器程序(mysqld/mysqld_safe)都读
  [mysqld]            # 仅 mysqld 读（最常用）
  [mysqld_safe]       # 仅 mysqld_safe 读
  [client]            # 所有客户端(mysql/mysqldump)都读
  [mysql]             # 仅 mysql 客户端读
  port=3306
  [mysqld]
  default-storage-engine=InnoDB
  [mysql]
  prompt=\u@\h \d>
  ```
  常用映射：`--port` → `[mysqld] port=`、`--default-storage-engine` → `[mysqld] default-storage-engine=`。组名写错 MySQL 不会报错但**静默忽略**。
- 面试速记：配置文件有分组，`[mysqld]` 给服务器、`[mysql]` 给客户端；后读覆盖先读，`[server]`/`[client]` 是通配组。

### 1.5　系统变量作用范围
- 本质：系统变量分**全局（GLOBAL）**和**会话（SESSION）**两个作用域，像"全局设置"和"本次连接私有设置"。修改 GLOBAL 不影响已存在的会话，只影响之后新建的连接。
- 实战：
  ```sql
  SET GLOBAL sort_buffer_size = 2*1024*1024;   -- 对所有新连接生效
  SET SESSION sort_buffer_size = 4*1024*1024;  -- 仅当前连接生效
  SHOW GLOBAL VARIABLES LIKE 'sort_buffer_size';
  SHOW SESSION VARIABLES LIKE 'sort_buffer_size';
  -- 也可写成 SELECT @@global.sort_buffer_size, @@session.sort_buffer_size;
  ```
- 面试速记：GLOBAL 影响后续连接，SESSION 只管自己；`@@global.x` / `@@session.x` 读取。

### 1.6　状态变量
- 本质：状态变量是**只读**的运行时计数器，反映"MySQL 现在累成啥样了"（已建立多少连接、执行多少查询）。它们分 GLOBAL（累计全实例）和 SESSION（当前连接）两种。
- 实战：
  ```sql
  SHOW STATUS LIKE 'Threads_connected';  -- 当前连接数
  SHOW STATUS LIKE 'Questions';          -- 累计查询数
  SHOW GLOBAL STATUS LIKE 'Innodb_buffer_pool_read%';
  ```
- 面试速记：状态变量 = 运行计数器，只读用 `SHOW STATUS` 看，调优时盯它。

### 1.7　存储引擎一览
- 本质：存储引擎是"数据怎么存、怎么取"的插件。一张表只能用一个引擎，用 `ENGINE=` 指定。
  | 引擎 | 事务 | 锁粒度 | 外键 | 典型场景 |
  |---|---|---|---|---|
  | **InnoDB** | ✅ | 行锁 | ✅ | 默认，OLTP 业务表 |
  | MyISAM | ❌ | 表锁 | ❌ | 只读/报表、全文检索(旧) |
  | MEMORY | ❌ | 表锁 | ❌ | 临时缓存、会话表 |
  | CSV | ❌ | 表锁 | ❌ | 与 CSV 文件交换 |
  | ARCHIVE | ❌ | 行锁 | ❌ | 历史归档、高压缩 |
- 实战：
  ```sql
  SHOW ENGINES;                              -- 看所有引擎及默认
  CREATE TABLE log (...) ENGINE=MyISAM;      -- 指定引擎
  ```
- 面试速记：InnoDB 是 5.7 默认引擎，支持事务/行锁/外键；MyISAM 表锁无事务；建表可显式 `ENGINE=`。

### 1.8　查询缓存（8.0 已删除）
- 本质：5.7 曾有一个"查询缓存"——SQL 文本一模一样就直接返回上次结果，免去执行。但它**只要表有写入就整体失效**，高并发写场景反而拖累性能。
- > 注意：**MySQL 8.0 已彻底移除查询缓存**（`query_cache_type` 等变量不再存在）。5.7 若要用也建议关掉（`query_cache_type=OFF`）以省开销。
- 实战（5.7 查看）：
  ```sql
  SHOW VARIABLES LIKE 'query_cache%';
  ```

> 第1章面试高频：C/S 架构（连接→解析优化→存储引擎三层）、启动选项 vs 系统变量、GLOBAL vs SESSION、配置文件读取顺序与选项组、存储引擎对比、8.0 移除查询缓存。

### 1.9　实战演练：CentOS 7 二进制安装 MySQL 5.7.40

> 理论为实战服务。下面在 **CentOS 7** 上用**官方二进制 tarball** 安装 5.7.40，全程可复制粘贴。每行都带注释。

```bash
# ===== 1) 准备环境：卸载系统自带 mariadb，装依赖 =====
cat /etc/redhat-release                       # 确认系统 CentOS Linux release 7.x
rpm -qa | grep mariadb                        # 看是否有 mariadb 包
yum remove -y mariadb-libs                    # 卸载冲突的 mariadb 库（必须，否则端口/文件冲突）
yum install -y libaio numactl-libs           # MySQL 依赖的异步IO库等

# ===== 2) 下载并解压官方二进制包（5.7.40，el7 x86_64）=====
cd /usr/local/src
wget https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.40-linux-glibc2.12-x86_64.tar.gz
# 若 wget 不通，可手动下载后 rz 上传；包约 600MB
tar -xzf mysql-5.7.40-linux-glibc2.12-x86_64.tar.gz
ln -s /usr/local/src/mysql-5.7.40-linux-glibc2.12-x86_64 /usr/local/mysql   # 软链，方便升级
cd /usr/local/mysql

# ===== 3) 创建用户、数据目录、授权 =====
groupadd mysql                                # 创建 mysql 组
useradd -r -g mysql -s /bin/false mysql       # 创建不可登录的系统用户 mysql
mkdir -p /data/mysql/data                     # 数据目录（datadir）
mkdir -p /data/mysql/logs                     # 日志目录
mkdir -p /data/mysql/tmp                      # 临时目录
chown -R mysql:mysql /data/mysql              # 整棵树归 mysql 用户
chown -R mysql:mysql /usr/local/mysql         # 二进制目录也归 mysql

# ===== 4) 写配置文件 /etc/my.cnf（对应 1.3/1.4 章节：选项组 + 系统变量）=====
cat > /etc/my.cnf <<'EOF'
[client]
port=3306
socket=/data/mysql/tmp/mysql.sock
default-character-set=utf8mb4                 # 客户端默认字符集（第4章）

[mysqld]
user=mysql
basedir=/usr/local/mysql                      # 二进制根目录
datadir=/data/mysql/data                      # 数据目录（第2章）
tmpdir=/data/mysql/tmp
socket=/data/mysql/tmp/mysql.sock
pid-file=/data/mysql/tmp/mysqld.pid
log-error=/data/mysql/logs/error.log          # 错误日志路径
port=3306
character-set-server=utf8mb4                  # 服务器默认字符集（第4章）
collation-server=utf8mb4_general_ci
default-storage-engine=INNODB                 # 默认存储引擎（第1.7章）
innodb_file_per_table=ON                      # 独立表空间（第8章，5.7默认ON）
max_connections=500                           # 最大连接数（第1.6章 状态变量关联）
EOF

# ===== 5) 初始化数据目录（生成系统库 + 临时 root 密码）=====
/usr/local/mysql/bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql/data
# 注意：5.7 用 --initialize 会生成临时密码，存在错误日志里：
grep 'temporary password' /data/mysql/logs/error.log    # 记下临时密码，形如 A临时密码>

# ===== 6) 配置 systemd 启动（对应 1.2 章 启动方式）=====
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
# CentOS7 用 systemd 最稳，写 service 文件：
cat > /usr/lib/systemd/system/mysqld.service <<'EOF'
[Unit]
Description=MySQL Server 5.7.40
After=network.target
[Service]
User=mysql
Group=mysql
ExecStart=/usr/local/mysql/bin/mysqld --defaults-file=/etc/my.cnf
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable mysqld                       # 开机自启
systemctl start mysqld                        # 启动（等价于 1.2 章 mysqld_safe）
systemctl status mysqld                        # 确认 active (running)

# ===== 7) 登录并改密码（对应 1.1 章 客户端连接）=====
/usr/local/mysql/bin/mysql -uroot -p -S /data/mysql/tmp/mysql.sock   # 输入上面的临时密码
# 进库后第一件事：改密码（5.7 密码策略要求复杂度）
ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass#2024';
# 为方便，把 mysql 命令加进 PATH：
echo 'export PATH=/usr/local/mysql/bin:$PATH' >> /etc/profile
source /etc/profile
mysql -uroot -p                              # 之后可直接用 mysql 命令
```

> 至此，一台 CentOS 7 上的 MySQL 5.7.40 二进制实例已跑起来。下面每一章的实战都基于它，直接连上去操作即可。

### 1.11　生产环境建议（安装与基础配置）

> 上面是最小可用安装。生产环境还要补这几步，直接可复制。

```bash
# ===== 1) 生产级 /etc/my.cnf 关键参数（在 1.9 基础上补充）=====
cat >> /etc/my.cnf <<'EOF'

[mysqld]
# —— 安全 ——
skip_name_resolve                              # 禁用 DNS 反向解析，避免连接鉴权卡顿/_host 查询
local_infile=0                                 # 禁止 LOAD DATA LOCAL，防本地文件读漏洞
max_connect_errors=100000                      # 放宽防暴力破解误杀（配合防火墙更稳）

# —— 性能 ——
innodb_buffer_pool_size=2G                     # 物理内存 60%~80%（示例 4G 机器设 2G）
innodb_buffer_pool_instances=2                 # size≥1G 时拆多实例，减内部锁竞争
innodb_flush_log_at_trx_commit=1               # 双1：redo 每次提交刷盘
sync_binlog=1                                   # 双1：binlog 每次提交刷盘（防丢失）
innodb_io_capacity=2000                        # 告诉 InnoDB 磁盘 IO 能力（SSD 调高）
innodb_io_capacity_max=4000

# —— 复制/恢复必备 ——
server-id=1                                    # 主从复制必须唯一
log_bin=/data/mysql/logs/mysql-bin             # 开 binlog（备份+主从+点对点恢复）
binlog_format=ROW                             # 行格式 binlog，恢复/主从更安全
expire_logs_days=7                             # binlog 保留天数（按备份策略定）
gtid_mode=ON                                   # 8.0 推荐开 GTID；5.7 也支持，主从切换更稳
enforce_gtid_consistency=ON

# —— 可观测 ——
slow_query_log=1
long_query_time=1
log_queries_not_using_indexes=1               # 记录全表扫（便于发现缺索引 SQL）
EOF
systemctl restart mysqld

# ===== 2) 安全初始化（生产必做）=====
mysql_secure_installation                       # 交互：改 root 密码/删匿名用户/禁 root 远程登录
# 或直接 SQL 等价操作：
#   DELETE FROM mysql.user WHERE User='';                      -- 删匿名用户
#   DELETE FROM mysql.user WHERE Host<>'localhost';            -- 禁 root 远程（仅留 localhost）

# ===== 3) 生产账号规范（不要共用 root）=====
# 建一个业务账号，只给业务库权限，且限制来源 IP（见第3章 3.4）
#   CREATE USER 'app'@'10.0.%.%' IDENTIFIED WITH mysql_native_password BY '强密码';
#   GRANT SELECT,INSERT,UPDATE,DELETE ON pract.* TO 'app'@'10.0.%.%';

# ===== 4) 开机自启 + 监控进程 =====
systemctl enable mysqld                        # 已做；确保重启自动拉起
# 用监控（zabbix/prometheus）盯：Threads_connected、Innodb_buffer_pool 命中率、Slave 延迟、慢日志量
```

> **📌 8.0 提示**：`gtid_mode`/`enforce_gtid_consistency` 在 8.0 默认推荐开启；`caching_sha2_password` 下主从复制需用 SSL 或 `mysql_native_password` 账号（见 1.9 注释）。

> **📌 MySQL 8.0 安装差异（对照本实战）**
> - **下载包不同**：8.0 包名形如 `mysql-8.0.x-linux-glibc2.12-x86_64.tar.xz`（`.tar.xz` 而非 `.tar.gz`，archive 路径为 `/archives/get/p/30/file/`），解压用 `tar -xJf`。
> - **认证插件变了（最容易踩坑）**：5.7 默认 `mysql_native_password`；**8.0 默认 `caching_sha2_password`**。老版本 JDBC/客户端连 8.0 会报 `Authentication plugin 'caching_sha2_password' cannot be loaded`。解决：在 `[mysqld]` 加 `default_authentication_plugin=mysql_native_password`，或建用户时显式 `IDENTIFIED WITH mysql_native_password BY '密码'`（见第3章 3.4 实战注释）。
> - **默认字符集**：8.0 已默认 `utf8mb4`，本实战配置文件里显式写了 `character-set-server=utf8mb4` 在 8.0 下也安全、可保留。
> - **`mysql_secure_installation`**：8.0 用该命令初始化安全设置（密码强度、匿名用户等），交互式；5.7 首次启动后须在 error.log 取临时密码登录再改。
> - **数据字典**：8.0 把 `mysql` 系统库里的元数据表改为 InnoDB 引擎 + 事务型数据字典，且**没有 `.frm` 文件**（表结构合并进 `.ibd`，见第2章 2.5 实战），`innodb_file_per_table` 在 8.0 默认同样 ON。
> - **`--initialize` 行为一致**：8.0 同样生成临时 root 密码到 error.log，登录后必须改密才能操作（与 5.7 相同）。

### 1.10　实战演练：启动选项 / 系统变量 / 状态变量 验证

```bash
# 启动选项 vs 系统变量（1.3 章）：命令行选项 --xxx 通常映射成系统变量 xxx
mysql -uroot -p -e "SHOW VARIABLES LIKE 'max_connections';"     # 看当前值（配置文件里设了500）
mysql -uroot -p -e "SHOW VARIABLES LIKE 'default_storage_engine';"

# GLOBAL vs SESSION（1.5 章）
mysql -uroot -p -e "SET GLOBAL max_connections=800;"           # 全局改，新连接生效
mysql -uroot -p -e "SET SESSION sql_mode='';"                  # 仅当前会话
mysql -uroot -p -e "SELECT @@global.max_connections, @@session.max_connections;"

# 状态变量（1.6 章）：只读计数器
mysql -uroot -p -e "SHOW GLOBAL STATUS LIKE 'Threads_connected';"
mysql -uroot -p -e "SHOW GLOBAL STATUS LIKE 'Questions';"
mysql -uroot -p -e "SHOW GLOBAL STATUS LIKE 'Innodb_buffer_pool_read%';"

# 存储引擎一览（1.7 章）
mysql -uroot -p -e "SHOW ENGINES;"
```

---

## 第2章　MySQL 的数据目录

### 2.1　数据目录的位置
- 本质：数据目录（datadir）是 mysqld 存放所有数据库文件的根文件夹。
- 实战：
  ```sql
  SHOW VARIABLES LIKE 'datadir';   -- 如 /var/lib/mysql/
  ```

### 2.2　数据库在文件系统中的表示
- 本质：每个数据库 = 数据目录下的**一个子文件夹**；文件夹名就是库名。
- 实战（Linux）：
  ```bash
  ls /var/lib/mysql/        # 每个目录对应一个库
  ```
- 注意：库名、表名在 Linux 上**区分大小写**（由 `lower_case_table_names` 控制，默认 0）。

### 2.3　表在文件系统中的表示
- 本质：一张表由若干文件组成，格式取决于**存储引擎**。
- InnoDB（5.7 默认）：
  - `表名.frm`：表结构定义（5.7 仍有，8.0 才合并进 ibd）。
  - `表名.ibd`：表数据 + 索引（独立表空间，前提是 `innodb_file_per_table=ON`，5.7 默认 ON）。
- MyISAM：
  - `表名.frm`（结构）、`表名.MYD`（数据）、`表名.MYI`（索引）三个文件。
- 实战：
  ```bash
  ls /var/lib/mysql/test/   # 看 test 库里的表文件
  ```

### 2.4　视图 / 其他文件
- 视图：只有 `.frm` 文件，没有数据文件（视图是虚拟表）。
- 其他：服务器日志（错误日志、慢查询日志）、pid 文件、socket 文件等也在数据目录或指定路径。

> 第2章面试高频：datadir 是什么、InnoDB 的 .frm/.ibd、MyISAM 三件套、库=目录 表=文件。

### 2.5　实战演练：数据目录与表文件观察

```bash
# 数据目录位置（2.1 章）
mysql -uroot -p -e "SHOW VARIABLES LIKE 'datadir';"     # 显示 /data/mysql/data/

# 在文件系统上观察：库=目录，表=文件（2.2 / 2.3 章）
mysql -uroot -p -e "CREATE DATABASE pract DEFAULT CHARSET utf8mb4;"
ls -lh /data/mysql/data/pract/                          # 空库目录下会有 db.opt（库级字符集）

# 建 InnoDB 表与 MyISAM 表，看文件差异
mysql -uroot -p pract -e "CREATE TABLE t_inno (id INT PRIMARY KEY, name VARCHAR(20)) ENGINE=INNODB;"
mysql -uroot -p pract -e "CREATE TABLE t_myisam (id INT, name VARCHAR(20)) ENGINE=MYISAM;"
ls -lh /data/mysql/data/pract/
# 结果：t_inno.frm + t_inno.ibd（5.7 有 .frm，8.0 才合并进 ibd）；t_myisam.frm + .MYD + .MYI

# 查看视图只生成 .frm（2.4 章）
mysql -uroot -p pract -e "CREATE VIEW v_name AS SELECT name FROM t_inno;"
ls -lh /data/mysql/data/pract/ | grep v_name            # 只有 v_name.frm

# 📌 8.0 差异：8.0 彻底移除了 .frm 文件（表/视图结构都合并进 .ibd 或数据字典），
#    所以 8.0 下 ls 看不到 t_inno.frm / v_name.frm，表结构请改用 SHOW CREATE TABLE 查看。
```

---

## 第3章　用户与权限管理

### 3.1　用户与权限概述
- 本质：MySQL 用 **"用户 + 主机"** 唯一标识一个账号（`'user'@'host'`），权限是"能对这个对象做什么"。
- 实战：
  ```sql
  CREATE USER 'app'@'192.168.%' IDENTIFIED BY 'pwd123';
  GRANT SELECT, INSERT ON shop.* TO 'app'@'192.168.%';
  FLUSH PRIVILEGES;
  ```

### 3.2　权限的存放
- 本质：权限存在 `mysql` 系统库的几个表里：`user`（全局）、`db`（库级）、`tables_priv`、`columns_priv`。
- 实战：
  ```sql
  SELECT user, host, authentication_string FROM mysql.user;
  ```

### 3.3　访问控制（两步）
- 本质：连接时先**身份认证**（你是谁），执行 SQL 时再**权限检查**（你能不能做）。
- 面试速记：先验证身份，再校验权限，两步都过才放行。

> 第3章面试高频：`'user'@'host'` 唯一、GRANT/REVOKE、权限表层级 user→db→tables_priv。

### 3.4　实战演练：用户与权限

```sql
-- 创建用户（'user'@'host' 唯一，3.1 章）：host 用 % 表示任意远程
CREATE USER 'app'@'192.168.%' IDENTIFIED BY 'AppPass#123';
CREATE USER 'reader'@'localhost' IDENTIFIED BY 'ReadPass#123';
-- 📌 8.0 差异：5.7 默认认证插件 mysql_native_password；8.0 默认 caching_sha2_password。
--    老版本 JDBC/Navicat 连 8.0 会报插件加载失败。8.0 下兼容老客户端请显式指定插件：
--    CREATE USER 'app'@'192.168.%' IDENTIFIED WITH mysql_native_password BY 'AppPass#123';
--    或全局在 [mysqld] 加 default_authentication_plugin=mysql_native_password（见第1章 1.9 安装实战注释）

-- 授权（3.1 / 3.2 章）：库级、表级、列级
GRANT SELECT, INSERT, UPDATE, DELETE ON pract.* TO 'app'@'192.168.%';
GRANT SELECT ON pract.t_inno TO 'reader'@'localhost';
FLUSH PRIVILEGES;                       -- 刷新权限缓存（改权限表后建议执行）

-- 查看权限存放在哪（3.2 章）
SELECT user, host, authentication_string FROM mysql.user;
SHOW GRANTS FOR 'app'@'192.168.%';      -- 看某账号被授予了什么
-- 📌 8.0 差异：mysql.user 表的密码字段/插件列结构变化，可加看 plugin 列确认认证方式：
--    SELECT user, host, plugin FROM mysql.user;

-- 回收权限 + 删用户
REVOKE INSERT ON pract.* FROM 'app'@'192.168.%';
DROP USER 'reader'@'localhost';

-- 访问控制两步（3.3 章）：先身份认证再权限检查，用新用户登录验证
mysql -uapp -pAppPass#123 -h 127.0.0.1 -P 3306 pract -e "SELECT 1;"   # 认证+授权都过才成功
```

---

## 第4章　字符集和比较规则

### 4.1　字符集和比较规则简介
- **本质**：
  - **字符集（charset）**：字符 → 二进制 的映射规则（utf8mb4 能存 emoji，latin1 不能）。
  - **比较规则（collation）**：两个字符怎么比大小、是否区分大小写。
- 通俗解释：字符集决定"字怎么编码"，比较规则决定"字怎么排序"。
- 字符集与比较规则是**一对多**：一个字符集可配多个比较规则（如 `utf8mb4` 有 `general_ci`、`bin` 等），但每个字符集有唯一**默认**比较规则。

### 4.2　MySQL 支持的字符集
- 实战：
  ```sql
  SHOW CHARSET;                 -- 看所有字符集（含默认 collation、最大字节数）
  SHOW COLLATION LIKE 'utf8mb4%';
  ```
- 重点：MySQL 的 `utf8` 是"假 utf8"——实际是 **utf8mb3**（最多 3 字节，存不了 emoji 和部分生僻字）；**真正完整的是 `utf8mb4`**（4 字节，= 真正的 UTF-8）。
  > 注意：**MySQL 8.0 已把 `utf8` 的默认字符集改为 `utf8mb4`**，且 `utf8mb3` 被标记为弃用。新项目一律用 `utf8mb4`。

### 4.3　字符集和比较规则的应用
- 四个层级：服务器 → 数据库 → 表 → 列，层层可覆盖；低层级不写就用高层级的。
  ```text
  服务器 (character_set_server)
    └─ 数据库 (CREATE DATABASE ... CHARSET)
         └─ 表 (CREATE TABLE ... CHARSET)
              └─ 列 (col VARCHAR(20) CHARSET)   ← 最细粒度，优先级最高
  ```
- 比较规则命名规则：`字符集_语言_后缀`，后缀决定排序语义：
  | 后缀 | 含义 |
  |---|---|
  | `ai` | accent insensitive，不区分重音（如 a=á）|
  | `as` | accent sensitive，区分重音 |
  | `ci` | case insensitive，不区分大小写 |
  | `cs` | case sensitive，区分大小写 |
  | `bin` | binary，按字符编码值比较，最快最严 |
- 实战：
  ```sql
  CREATE DATABASE shop DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_general_ci;
  CREATE TABLE user (
    name VARCHAR(50) CHARSET utf8mb4 COLLATE utf8mb4_bin  -- 列级覆盖，区分大小写
  ) DEFAULT CHARSET=utf8mb4;
  ```

### 4.4　各层级字符集的继承与转换
- 本质：低层级没指定就用高层级的；**客户端 ↔ 服务器** 之间还有"通讯字符集"三件套，不一致会乱码。
  - `character_set_client`：客户端发来的 SQL 用什么编码解读。
  - `character_set_connection`：SQL 进入服务器后，做字面量/转换时用的编码。
  - `character_set_results`：结果集返回客户端用什么编码。
- 实战（防乱码三连）：
  ```sql
  SET NAMES utf8mb4;   -- 一次性设 client/connection/results 三者
  -- 等价于下面三条
  -- SET character_set_client = utf8mb4;
  -- SET character_set_connection = utf8mb4;
  -- SET character_set_results = utf8mb4;
  ```
- 数据流示意：客户端(编码A) → client解码 → connection转码处理 → 按表列字符集存 → results编码 → 客户端(编码A)。只要这三者与客户端实际编码一致，就不会乱码。

### 4.5　比较规则影响排序与索引
- 本质：**区分大小写的列（_bin 或 _cs）和区分大小写的查询，可能排序结果不同，且对索引前缀/覆盖有影响**。
- 实战：
  ```sql
  -- utf8mb4_general_ci 不区分大小写：'A' = 'a'
  SELECT 'A' = 'a';   -- 1（ci = case insensitive）
  
  -- utf8mb4_bin 区分大小写，排序也按编码值
  SELECT 'a' < 'B';   -- 取决于 collation
  ```
- 比较规则不同会导致**索引无法复用**：`WHERE name='Tom' COLLATE utf8mb4_bin` 与列默认 `ci` 不一致时，可能不走索引或触发隐式转换。

> 第4章面试高频：utf8(utf8mb3) vs utf8mb4（emoji）、`SET NAMES` 防乱码、collation 后缀(ai/as/ci/cs/bin)、区分大小写对排序/索引的影响、8.0 默认 utf8mb4。

### 4.6　实战演练：字符集与乱码排查

```sql
-- 查看支持的字符集与比较规则（4.2 章）
SHOW CHARSET;
SHOW COLLATION LIKE 'utf8mb4%';

-- 四个层级继承（4.3 章）：服务器→库→表→列
SHOW VARIABLES LIKE 'character_set_server';                 -- 服务器层
CREATE DATABASE shop DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_general_ci;
SHOW CREATE DATABASE shop;                                  -- 看库级字符集
CREATE TABLE shop.user (
  id INT,
  name VARCHAR(50) CHARSET utf8mb4 COLLATE utf8mb4_bin      -- 列级覆盖：区分大小写
) DEFAULT CHARSET=utf8mb4;
SHOW FULL COLUMNS FROM shop.user;                           -- 看列级字符集/排序

-- emoji 测试：utf8mb4 能存，utf8mb3(假utf8) 存不了（4.2 章）
INSERT INTO shop.user VALUES (1, '😀emoji');
SELECT * FROM shop.user;                                    -- 正常显示

-- 防乱码三连（4.4 章）：客户端↔服务器字符集一致
SET NAMES utf8mb4;                                          -- 一次性设 client/connection/results
SHOW VARIABLES LIKE 'character_set_%';                     -- 确认三个变量都是 utf8mb4

-- 比较规则影响排序与索引（4.5 章）
CREATE TABLE shop.cmp (c VARCHAR(10) COLLATE utf8mb4_general_ci);
INSERT INTO shop.cmp VALUES ('A'),('a'),('B');
SELECT * FROM shop.cmp WHERE c = 'a';                      -- ci 下返回 A 和 a（不区分大小写）
SELECT * FROM shop.cmp ORDER BY c COLLATE utf8mb4_bin;     -- 改 bin 排序，A/B/a 严格按编码
```

---

## 第5章　InnoDB 记录存储结构

> 这一章讲"一行数据在磁盘上到底长啥样"，是理解索引的基础。

### 5.1　行格式（Row Format）

- **本质**：InnoDB 把一行数据按某种"格式"打包存储；5.7 默认是 **DYNAMIC**（COMPACT 的升级）。
- 种类：`REDUNDANT`（老）、`COMPACT`（紧凑）、`DYNAMIC`（5.7 默认，超长字段溢出到单独页）、`COMPRESSED`（压缩）。
- 实战：
  ```sql
  CREATE TABLE t (...) ROW_FORMAT=DYNAMIC;
  SHOW TABLE STATUS LIKE 't';   -- 看 Row_format
  -- 或建表时指定，全局默认由 innodb_default_row_format 控制
  SHOW VARIABLES LIKE 'innodb_default_row_format';
  ```

### 5.2　COMPACT 行格式详解

- 本质：一行 = **变长字段长度列表 + NULL 值列表 + 记录头信息 + 真实列数据(+隐藏列)**。
- 一条记录的内存/磁盘布局（Compact）：
  ```text
  ┌─────────────────────────────────────────────────────────┐
  │ 变长字段长度列表   (逆序存放，每列1~2字节，如 VARCHAR)   │
  │ NULL 值列表        (位图，1=NULL，逆序对应各可空列)      │
  │ 记录头信息         (5 字节，见下)                         │
  │ 隐藏列：DB_ROW_ID  (6B，无主键时自动生成)                │
  │ 隐藏列：DB_TRX_ID  (6B，最近修改的事务ID，MVCC用)        │
  │ 隐藏列：DB_ROLL_PTR(7B，回滚指针，指向undo版本链)        │
  │ 真实列数据         (按建表顺序，NULL列不占空间)           │
  └─────────────────────────────────────────────────────────┘
  ```
- 记录头（5 字节 = 40 位）里的关键位：
  - `delete_flag`（1位）：删除标记（删了不真删，打标记，后面 purge 回收）。
  - `min_rec_flag`（1位）：B+树非叶子节点的最小目录项标记。
  - `n_owned`（4位）：本记录所属"页目录槽"拥有的记录数。
  - `heap_no`（13位）：记录在页内的物理序号（0=Infimum，1=Supremum）。
  - `record_type`（3位）：0=普通记录，1=非叶节点目录项，2=最小记录(Infimum)，3=最大记录(Supremum)。
  - `next_record`（16位）：指向**下一条记录**的偏移量，所有记录用**单向链表**串起来（按主键有序）。
- 隐藏列说明：
  | 隐藏列 | 大小 | 作用 |
  |---|---|---|
  | DB_ROW_ID | 6B | 无主键/无非空唯一索引时，InnoDB 自动生成行标识 |
  | DB_TRX_ID | 6B | 最近一次修改本行的事务ID，MVCC 版本链核心 |
  | DB_ROLL_PTR | 7B | 回滚指针，指向 undo 中的历史版本 |

### 5.3　变长字段与 NULL 值的存储
- 变长字段（VARCHAR/TEXT/BLOB/变长 CHAR）：前面存"实际长度"（1~2 字节，按上限定），因为长度不固定。
- NULL：不占数据位，只在 NULL 值列表里记一个 bit（1=NULL），省空间；这与"空字符串"不同——空串要占长度字节。
- 实战体会：
  ```sql
  -- VARCHAR 比 CHAR 省空间，但更新变长可能行迁移(overflow page)
  CREATE TABLE demo (a VARCHAR(10), b CHAR(10));
  INSERT INTO demo VALUES('x', 'y');   -- b 虽 CHAR(10) 但 utf8mb4 下按实际占
  ```

### 5.4　溢出列（行溢出）
- 本质：一页 16KB，如果一行太大（比如有个超长 TEXT/BLOB），装不下就**把大部分数据放到"溢出页"**（uncompressed blob page），原页只留指针。
  ```text
  COMPACT 行格式：              DYNAMIC / COMPRESSED 行格式：
  ┌──────────────┐             ┌──────────────┐
  │ 前 768 字节   │──指针─────▶ │  溢出页(存    │
  │ + 20B 指针    │             │  全部真实数据)│
  └──────────────┘             └──────────────┘
  （本页留前768字节）            （本页只留20B指针，更彻底）
  ```
- DYNAMIC vs COMPACT：COMPACT 前 768 字节留本页，DYNAMIC 全放溢出页只留指针（更彻底，适合大字段）。`off_page` 阈值由列实际长度决定。

### 5.5　CHAR 与 VARCHAR 的字符集影响
- 本质：CHAR(N) 在 **变长字符集（utf8mb4）下最多占 4N 字节**，且按实际字符数存储（不再是老 fixed 定长），设计时要算清。
- 反例：`CHAR(10)` 在 latin1 下固定 10 字节；在 utf8mb4 下最多 40 字节。排序/比较仍按 CHAR 的"补齐空格"语义。

### 5.6　Redundant 行格式（了解）
- 老格式，5.0 前默认。与 Compact 区别：没有单独的 NULL 位图，头部用 6 字节且偏移量正向存储，字段长度用 1~3 字节，冗余多、已废弃。新表无需关注。

> 第5章面试高频：行格式 DYNAMIC、记录头 delete_flag/next_record/record_type、隐藏列 DB_TRX_ID/DB_ROLL_PTR/DB_ROW_ID、变长字段+NULL 省空间、行溢出(Compact留768B vs Dynamic全溢出)、utf8mb4 下 CHAR 变长。

### 5.7　实战演练：行格式与变长/NULL/溢出观察

```sql
-- 看/指定行格式（5.1 章）
CREATE TABLE pract.t_row (id INT PRIMARY KEY, a VARCHAR(10), b CHAR(10)) ROW_FORMAT=DYNAMIC;
SHOW TABLE STATUS FROM pract LIKE 't_row';                -- Row_format 列显示 DYNAMIC
SHOW VARIABLES LIKE 'innodb_default_row_format';          -- 全局默认行格式

-- 变长 vs 定长（5.3 / 5.5 章）：utf8mb4 下 CHAR 也变长存储
CREATE TABLE pract.t_len (
  vc VARCHAR(10),                 -- 变长
  cc CHAR(10)                     -- utf8mb4 下最多 40 字节，按实际占
) DEFAULT CHARSET=utf8mb4;
INSERT INTO pract.t_len VALUES ('x', 'y');
SELECT vc, cc, CHAR_LENGTH(vc), CHAR_LENGTH(cc), LENGTH(vc), LENGTH(cc)
FROM pract.t_len;                -- LENGTH 看字节数（utf8mb4 下 'x' 占 1~3 字节）

-- NULL 不占数据位（5.3 章）：只有 NULL 位图记一下
INSERT INTO pract.t_len (vc) VALUES ('hello');             -- cc 为 NULL，不占数据位
SELECT * FROM pract.t_len;

-- 行溢出（5.4 章）：超长 TEXT 触发溢出页
CREATE TABLE pract.t_over (id INT PRIMARY KEY, big TEXT) ROW_FORMAT=DYNAMIC;
INSERT INTO pract.t_over VALUES (1, REPEAT('a', 16000));   -- 超过 8KB，绝大部分进溢出页
-- 文件层面：.ibd 里该记录原页只留 20B 指针，真实数据在溢出页
ls -lh /data/mysql/data/pract/t_over.ibd

-- 隐藏列（5.2 章）：DB_TRX_ID / DB_ROLL_PTR 不能直接 SELECT，但可通过 MVCC 实验感知（见第20章）
-- 用 INFORMATION_SCHEMA 看表结构
SELECT COLUMN_NAME, COLUMN_KEY, EXTRA FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='pract' AND TABLE_NAME='t_row';
```

---

## 第6章　InnoDB 数据页结构

> 一页（Page）是 InnoDB 读写磁盘的**最小单位（16KB）**。理解页，才理解索引和 IO。

### 6.1　数据页的整体结构

- 本质：一页 = **文件头(38B) + 页头(56B) + 最小/最大记录 + 用户记录区 + 空闲区 + 页目录 + 文件尾(8B)**。
  ```text
  ┌──────────────────────────────────────────────┐
  │ File Header      文件头        38 字节         │  记录页的通用信息
  │ Page Header      页头          56 字节         │  本页专有信息(记录数等)
  │ Infimum + Supremum 最小/最大记录 26 字节       │  两条伪记录(边界)
  │ User Records     用户记录区     (实际行数据)    │  插入时从空闲区划过来
  │ Free Space       空闲区        (剩余空间)      │
  │ Page Directory   页目录         (槽 slot 数组)  │  二分查找入口
  │ File Trailer     文件尾        8 字节          │  校验页完整性(checksum)
  └──────────────────────────────────────────────┘
  ```
- 关键是 **页目录（Page Directory）**：把页内记录分组，存每组最后一条的"槽位"地址，实现页内**二分查找**（不是全表扫）。
- 文件头里存了上一页/下一页指针（`FIL_PAGE_PREV` / `FIL_PAGE_NEXT`），所以**同层页之间也是双向链表**。

### 6.2　记录在页中的存储（Infimum/Supremum）

- 本质：每个页自带两条伪记录——**Infimum（最小）** 和 **Supremum（最大）**，作为链表头尾边界。
- 页内所有用户记录用 `next_record` 指针串成**单向链表**，按主键有序：
  ```text
  Infimum ──▶ rec1 ──▶ rec2 ──▶ rec3 ──▶ ... ──▶ Supremum
  (heap_no=0)   (按主键升序)                    (heap_no=1)
  ```
- 删除记录只把 `delete_flag` 置 1，并把 `next_record` 从链表摘掉，空间留待复用（或被 purge 回收为空闲）。

### 6.3　页目录（Page Directory）与查找
- 本质：页目录是"槽（slot）"数组，每个槽指向一组记录里**最大**的那条；分组规则：Infimum 单独一组，Supremum 所在组 1~8 条，其余组 4~8 条。
- 查找流程（页内二分）：
  ```text
  1. 通过 Page Directory 的 slot[] 做二分，定位"目标主键值落在该槽指向记录与上槽之间"
  2. 从该槽指向的记录出发，沿 next_record 单向链表向后遍历，直到找到/越过目标
  例：slot = [指向rec2, 指向rec5, 指向Supremum]
      二分得 rec2 所在组 → 链表遍历 rec2→rec3→rec4 命中
  ```
- 面试速记：页内查找 = 二分定位槽 + 组内顺序找，避免逐条扫描。

### 6.4　页分裂与页合并
- 本质：
  - **页分裂**：插入导致一页满，把一半记录挪到新页，保持有序（也是 B+ 树长高的原因）。分裂点通常选在插入位置，保证新页与原页都不过半空。
  - **页合并**：删除导致两页都太空，合并回收（由 `MERGE_THRESHOLD` 控制，默认 50%，即当页数据 < 50% 时尝试与相邻页合并）。
  ```text
  分裂前:   [1 2 3 4 5 6 7 8]         合并前:  [1 2]  [9 10]
            │ 插入9，满                  │ 删除使过空
            ▼                            ▼
  分裂后:   [1 2 3 4]  [5 6 7 8 9]   合并后:  [1 2 9 10]
  ```
- 实战观察（页碎片/行数）：
  ```sql
  SHOW TABLE STATUS LIKE 't';   -- Data_free 反映碎片空间
  ```

> 第6章面试高频：页=16KB 最小 IO 单位、页内7部分结构、页目录二分查找、Infimum/Supremum、页分裂/合并、同层页双向链表。

### 6.5　实战演练：页与页分裂观察

```sql
-- 页是 16KB 最小 IO 单位（6.1 章）
SHOW VARIABLES LIKE 'innodb_page_size';                    -- 默认 16384 = 16KB

-- 造一张自增主键表，观察页分裂（6.4 章）
CREATE TABLE pract.t_page (id INT PRIMARY KEY, v VARCHAR(100)) ENGINE=INNODB;
-- 乱序插入会触发更多页分裂；先看当前数据页占用
INSERT INTO pract.t_page (id, v)
  SELECT seq, REPEAT('x', 50) FROM (SELECT 1 seq UNION ALL SELECT 2 UNION ALL SELECT 3
  UNION ALL SELECT 4 UNION ALL SELECT 5) t;               -- 插 5 行
SHOW TABLE STATUS FROM pract LIKE 't_page';               -- Data_free 反映碎片/空闲；Data_length 看表大小

-- 观察页内记录：通过 Information Schema 的缓冲池无法直看，但可用 innodb_ruby 工具（需额外装）
-- 简单办法：利用自增主键顺序插入，页几乎无碎片；逆序插入制造分裂
CREATE TABLE pract.t_page2 (id INT PRIMARY KEY, v VARCHAR(100)) ENGINE=INNODB;
INSERT INTO pract.t_page2 SELECT 1000000-id, REPEAT('x',50) FROM pract.t_page;  -- 逆序
SHOW TABLE STATUS FROM pract LIKE 't_page2';              -- Data_free 通常更大（分裂碎片）

-- 文件层面：一页 = .ibd 里 16384 字节
ls -lh /data/mysql/data/pract/t_page.ibd
```

---

## 第7章　B+ 树索引（重点）

> 索引是 MySQL 性能的灵魂，本章是全书核心。

### 7.1　没有索引的查找

- 本质：没索引 = 从第一页开始**全表扫描**，一页页读、页内顺序找，数据量一大就崩。

### 7.2　索引的本质：B+ 树
- **本质**：InnoDB 的索引是一棵 **B+ 树**。非叶子节点只存"目录键+子页指针"，**叶子节点存完整数据（聚簇索引）或主键（二级索引）**，叶子之间用**双向链表**相连。
- 通俗解释：B+ 树像"多层通讯录"——上层只告诉你在哪一册，最下层册子才是真人；册子之间还有书签串联，方便按顺序翻。
  ```text
              [非叶子层：目录项 (key, 子页号)]
                    /          |          \
          [页10]             [页11]            [页12]
            │                  │                 │
  ┌─── 叶子层（双向链表相连）──────────────────────────┐
  │ 页10: (1,row)→(3,row)→(5,row) ⇄ 页11: (7..) ⇄ 页12 │
  └───────────────────────────────────────────────────┘
  ```
- 为什么是 B+ 树而不是二叉/B 树：① 矮胖（三层可存千万级行），IO 少；② 叶子全连，范围扫描 `WHERE id BETWEEN 1 AND 100` 只需顺链表走；③ 非叶子只存键，单页能放更多目录项。
- 用一个真实 `用户表(name, birthday, phone, country)` 看聚簇索引与二级索引在同一棵 B+ 树里的样子（内节点存**目录项记录** `key+主键`，叶子存数据；二级索引叶子**不含 country 列**，只存索引列+主键）：
  ```text
  内节点（目录项记录：按 name 排序，指向子页）
  ┌──────────┐   ┌──────────┐        ┌──────────┐
  │ Asa      │   │ Baird    │   ...  │ Carter    │
  │ 1988-..  │   │ 1990-..  │        │ 1992-..  │
  │ 13928..  │   │ 18639..  │        │ 15523..  │
  │ 23       │   │ 900      │        │ 1500     │   ← 目录项里的"主键值"
  └────┬─────┘   └────┬─────┘        └────┬─────┘
       │              │                    │
       ▼              ▼                    ▼
  叶子节点（聚簇索引：完整用户记录，含 country；叶子间双向链表 ⇄）
  ┌──────────────────────────┐  ┌──────────────────────────┐
  │ Asa  1988-.. 13928.. 23 美国│⇄│ Baird 1990-.. 18639.. 900 英国│⇄ ...
  └──────────────────────────┘  └──────────────────────────┘
  
  二级索引 idx_name（叶子只存 name+主键，无 country，需回表拿 country）
  ┌─────────────────────┐  ┌─────────────────────┐
  │ Asa    23            │⇄│ Baird  900           │⇄ ...
  └─────────────────────┘  └─────────────────────┘
  ```

### 7.3　聚簇索引（Clustered Index）
- 本质：**以主键构建的 B+ 树，叶子节点就是整行数据**；一张表**只能有一个**聚簇索引（就是主键）。
- 特点：① 数据即索引、索引即数据；② 按主键查极快（一路到叶子就拿全行）；③ 主键最好自增（避免页分裂）。
- 实战：
  ```sql
  CREATE TABLE t (id INT PRIMARY KEY, name VARCHAR(20));  -- id 即聚簇索引
  -- 无显式主键时：优先用第一个非空唯一索引；都没有则 InnoDB 自动生成 6B 的 DB_ROW_ID
  ```

### 7.4　二级索引（Secondary Index）
- 本质：在别的列上建的索引，叶子节点**不存整行，只存"索引列值 + 主键值"**。查到主键后还要**回表**去聚簇索引拿整行。
  ```text
  二级索引 idx_name (B+树)              聚簇索引 (按主键, B+树)
  叶子: ('Tom', 5)                      叶子: (5, Tom, 20, ...整行)
        ('Amy', 2)  ──回表──▶ 拿 id=2 ─▶ (2, Amy, 18, ...)
  ```
- 实战：
  ```sql
  CREATE INDEX idx_name ON t(name);
  SELECT * FROM t WHERE name='Tom';  -- 先走 idx_name 拿到 id，再回表取整行
  ```

### 7.5　联合索引与最左前缀
- 本质：多列建一个索引 `(a,b,c)`，B+ 树按 a→b→c **字典序**排序；**只能从最左列开始用**（像查电话本先按省、再市、再区）。
  ```text
  联合索引 (a,b,c) 的叶子排序：
  (1,2,3) (1,2,5) (1,4,1) (2,1,9) (2,3,0) ...
   ↑a有序  ↑a同则b有序  ↑a,b同则c有序
  ```
- 实战：
  ```sql
  CREATE INDEX idx_abc ON t(a,b,c);
  WHERE a=1 AND b=2;        -- ✅ 用索引
  WHERE b=2;                -- ❌ 跳过了 a，用不上
  WHERE a=1 AND c=3;        -- ⚠️ 只用 a，c 过滤在回表后
  WHERE a>1 AND b=2;        -- ⚠️ a 范围后 b 在索引内无序，b 不能继续走索引
  ```

### 7.6　覆盖索引（Covering Index）
- 本质：查询要的**列刚好都在二级索引里**，不用回表，直接返回，最快。
- 实战：
  ```sql
  SELECT a,b FROM t WHERE a=1;   -- 若 idx_abc 含 a,b → 覆盖，不回表
  -- EXPLAIN 的 Extra 显示 Using index 即表示覆盖索引
  ```

### 7.7　索引的代价
- 本质：索引占空间、拖慢 **INSERT/UPDATE/DELETE**（每次改数据要顺带改索引树，二级索引还要维护）；不是越多越好。
- 经验：写多读少的表索引要克制；联合索引可"一索引多场景"（满足最左前缀），比单列堆砌更好。

### 7.8　Index Merge（索引合并）
- 本质：5.7 优化器在**单表**上可能把多个索引的扫描结果做集合运算再合并，避免退化为全表扫。三类：
  - **Intersection（交集）**：`AND` 连接的条件各自走索引，取主键交集（`WHERE a=1 AND b=2`）。要求各索引都能拿到主键且多为等值，效率才高。
  - **Union（并集）**：`OR` 连接且各条件都能走索引（`WHERE a=1 OR b=2`）。
  - **Sort-Union（排序并集）**：Union 的升级，当各索引结果按主键无序时先排序再合并。
- > 注意：**Index Merge 通常意味着没有更优的联合索引**。若 `(a)`、`(b)` 各自单索引却常 `a=X AND b=Y` 一起查，应建 `(a,b)` 联合索引替代，效率更高。
- 实战：
  ```sql
  EXPLAIN SELECT * FROM t WHERE a=1 OR b=2;
  -- type 列出现 index_merge，key 显示 idx_a,idx_b，Extra 显示 Using union(idx_a,idx_b)
  ```

> 第7章面试高频：聚簇 vs 二级索引(回表)、B+树叶子双向链表、最左前缀、覆盖索引(Using index)、索引代价、Index Merge 三类与"应改用联合索引"的取舍。

### 7.9　实战演练：索引建与用（聚簇/二级/联合/覆盖/Index Merge）

```sql
-- 准备表（7.3 章聚簇索引 = 主键）
CREATE TABLE pract.t_idx (
  id  INT PRIMARY KEY,                       -- 聚簇索引
  a   VARCHAR(20),
  b   INT,
  c   VARCHAR(20),
  common VARCHAR(20)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4;
INSERT INTO pract.t_idx VALUES
  (1,'Tom',10,'x','m'),(2,'Amy',20,'y','n'),(3,'Tom',30,'z','m'),
  (4,'Bob',10,'x','n'),(5,'Tom',40,'y','m');

-- 二级索引 + 回表（7.4 章）：叶子只存 (a, 主键id)
CREATE INDEX idx_a ON pract.t_idx(a);
EXPLAIN SELECT * FROM pract.t_idx WHERE a='Tom';          -- type=ref，key=idx_a，回表拿整行

-- 联合索引 + 最左前缀（7.5 章）
CREATE INDEX idx_abc ON pract.t_idx(a,b,c);
EXPLAIN SELECT * FROM pract.t_idx WHERE a='Tom' AND b=10;       -- ✅ 用 idx_abc
EXPLAIN SELECT * FROM pract.t_idx WHERE b=10;                   -- ❌ 跳 a，type=ALL
EXPLAIN SELECT * FROM pract.t_idx WHERE a='Tom' AND c='x';      -- ⚠️ 只用 a，c 回表后过滤

-- 覆盖索引（7.6 章）：要的列都在索引里，不回表
EXPLAIN SELECT a,b FROM pract.t_idx WHERE a='Tom';      -- Extra 显示 Using index

-- 索引失效（7.7 / 9.7 章）：函数包列、隐式转换、前模糊
EXPLAIN SELECT * FROM pract.t_idx WHERE YEAR(b)=10;    -- ❌ 函数包列，索引失效
EXPLAIN SELECT * FROM pract.t_idx WHERE a=123;         -- ❌ a 是字符串给数字，隐式转换失效
EXPLAIN SELECT * FROM pract.t_idx WHERE a LIKE 'To%';  -- ✅ 后模糊，可用前缀

-- Index Merge（7.8 章）：OR 连接两索引 → union
CREATE INDEX idx_b ON pract.t_idx(b);
EXPLAIN SELECT * FROM pract.t_idx WHERE a='Tom' OR b=10;  -- type=index_merge, Extra=Using union(idx_a,idx_b)
-- 注意：Index Merge 通常说明该建联合索引 (a,b) 取代两个单列索引
```

---

## 第8章　MySQL 的数据目录与表空间（InnoDB 存储结构）

### 8.1　表空间（Tablespace）概念

- 本质：表空间是 InnoDB 管理存储的**逻辑容器**，由若干"段(Segment)→区(Extent)→页(Page)"组成。
  ```text
  表空间 Tablespace
    └─ 段 Segment  (叶子节点段 / 非叶子节点段 / 回滚段 等)
         └─ 区 Extent  (连续 64 页 = 1MB，减少随机IO)
              └─ 页 Page  (16KB，最小IO单位)
  ```
  - **页 Page** = 16KB（最小 IO 单位，见第6章）。
  - **区 Extent** = 64 个连续页 = 1MB（一次申请一区，避免零散页造成的随机 IO）。
  - **段 Segment** = 存放某棵 B+ 树叶子/非叶子节点的逻辑分组（一个索引对应两个段：叶子段 + 非叶子段）。

### 8.1.1　表空间的分组与首区页类型（图片细节）
- 本质：表空间里的区按 **每 256 个 extent 为一组**（约 256MB）管理；**每组的第一个 extent 的前几个页是固定类型的"管理页"**，其余区则不同。
  ```text
  表空间
  ┌─ 第 0 组 (extent 0~255) ─────────────────────┐
  │ extent 0 前几页:                              │
  │   page0 FSP_HDR  (表空间头，记录整体分配)     │
  │   page1 IBUF_BITMAP (插入缓冲位图)            │
  │   page2 INODE     (段/索引的段入口)           │
  │   page3 XDES      ( extent 描述，本组)         │
  │   ... 余下页为普通数据/索引页                 │
  └───────────────────────────────────────────────┘
  ┌─ 第 1 组 (extent 256~511) ───────────────────┐
  │ extent 256 前几页:                            │
  │   page0 XDES   (本组 extent 描述)             │
  │   page1 IBUF_BITMAP                          │
  │   page2 XDES   ...                            │
  └───────────────────────────────────────────────┘
  （第 2 组起结构同第 1 组，仅首个 extent 前几页是 XDES+IBUF_BITMAP）
  ```
- 关键点：`FSP_HDR` 只在表空间**最开头出现一次**；`INODE` 页存放各 Segment 的 extent 链表入口（对应 8.5 的 INODE）；`XDES` 描述本组 extent 的分配状态。

### 8.2　区的分配状态与碎片区
- 本质：为防"小表也占满 1MB 区"的浪费，InnoDB 对**未达到 32 个页**的段，先放进**碎片区(Fragment)**——碎片区里的页可被不同段混用；段长到 32 页后才整区分配。
  ```text
  表空间
   ├─ 碎片区(Fragment)：页分散给多个段共用（小表/段早期）
   └─ 完整的区：专属某一段（段长大后批量分配）
  ```
- 区的四种状态：FREE（空闲）、FREE_FRAG（碎片区中空闲页）、FULL_FRAG（碎片区已满）、FSEG（专属某段）。

### 8.3　独立表空间 vs 系统表空间

- 本质：
  - `innodb_file_per_table=ON`（5.7 默认）：每张表一个 `.ibd` 文件（独立表空间），`DROP` 直接删文件，好管理。
  - OFF：所有表塞进系统表空间 `ibdata1`，删表空间不回收。
- 实战：
  ```sql
  SHOW VARIABLES LIKE 'innodb_file_per_table';
  -- 建表临时指定：CREATE TABLE t(...) TABLESPACE = innodb_file_per_table;
  ```

### 8.4　系统表空间结构（ibdata1）
- 本质：存放 **数据字典、双写缓冲(Doublewrite)、Change Buffer、undo 日志** 等公共信息，即使开了独立表空间也离不开它。系统表空间由 `ibdata1`（可配多个文件 `ibdata2...`）组成，`innodb_data_file_path` 控制大小。

### 8.5　独立表空间结构（.ibd）
- 本质：一个 `.ibd` 文件内部也是按"区/页"组织，包含若干索引的 B+ 树（聚簇 + 各二级索引各占一棵）。文件头有 **FSP Header（表空间头）**，记录区/段/碎片分配情况；索引根页通过 **INODE 页** 找到各段的首区。
  ```text
  .ibd 文件
   ├─ FSP Header  (表空间整体信息)
   ├─ INODE 页    (各段 Segment 的区链表入口)
   ├─ 索引1的B+树 (叶子段 + 非叶子段)
   ├─ 索引2的B+树
   └─ ...
  ```

> 第8章面试高频：页(16KB)/区(64页=1MB)/段层级、碎片区与 32 页阈值、独立表空间(ibd) vs 系统表空间(ibdata1)、file_per_table 默认 ON、INODE/FSP Header。

### 8.6　实战演练：表空间与文件观察

```sql
-- 页/区/段（8.1 章）
SHOW VARIABLES LIKE 'innodb_page_size';                    -- 16KB
SELECT 64*16384/1024/1024 AS extent_MB;                   -- 一个区 = 64页 = 1MB

-- 独立表空间 vs 系统表空间（8.3 / 8.5 章）
SHOW VARIABLES LIKE 'innodb_file_per_table';               -- ON：每张表一个 .ibd
ls -lh /data/mysql/data/pract/t_idx.ibd                   -- 独立表空间文件存在
ls -lh /data/mysql/data/ibdata1                            -- 系统表空间（放数据字典/undo/doublewrite等）

-- 切换为系统表空间（演示）：建表时指定
CREATE TABLE pract.t_sys (id INT PRIMARY KEY) TABLESPACE = innodb_system;  -- 进 ibdata1
-- 一般不建议；生产默认 file_per_table=ON

-- 区分配状态/碎片（8.2 章）：小表先用碎片区，长大后才整区分配
SHOW TABLE STATUS FROM pract LIKE 't_idx';                -- Data_free 看空闲碎片字节
SELECT * FROM information_schema.INNODB_SYS_TABLESPACES
WHERE NAME LIKE 'pract/%';                                 -- 看表空间 extent/页信息（8.0 在 INNODB_TABLESPACES）
```

---

## 第9章　单表访问方法（怎么用索引查）

> 讲优化器"挑哪种方式访问一张表"，直接对应 EXPLAIN 的 type 列。

### 9.1　访问方法（access method）分类
- 本质：按是否用索引、用得怎么样，分成几档（性能从差到好）：
  - `ALL`：全表扫描（最差，扫聚簇索引所有叶子页）。
  - `index`：全索引扫描（遍历整个二级索引树，再按需回表）。
  - `range`：索引范围扫描（`>、<、BETWEEN、IN` 等，扫描索引一段）。
  - `ref`：非唯一索引等值（返回多行，如普通二级索引 `=`）。
  - `eq_ref`：唯一索引/主键等值（连表时常见，一行对一行）。
  - `const` / `system`：主键/唯一索引等值，优化成常量（最快，一行命中）。
- 官方还有 `ref_or_null`（等值+找 NULL）、`unique_subquery`/`index_subquery`（子查询优化）等细分，但面试常背上面几档即可。

### 9.2　const（常量访问）
- 实战（以经典 `single_table` 表为例）：
  ```sql
  CREATE TABLE single_table (
    id           INT NOT NULL AUTO_INCREMENT,
    key1         VARCHAR(100),
    key2         INT,
    key3         VARCHAR(100),
    key_part1    VARCHAR(100),
    key_part2    VARCHAR(100),
    key_part3    VARCHAR(100),
    common_field VARCHAR(100),
    PRIMARY KEY (id),
    KEY idx_key1 (key1),
    KEY idx_key2 (key2),
    KEY idx_key3 (key3),
    KEY idx_key_part (key_part1, key_part2, key_part3)
  ) Engine=InnoDB CHARSET=utf8;
  
  SELECT * FROM single_table WHERE id=5;   -- id 是主键 → const，一步到位
  ```

### 9.3　ref 与 range
- 实战：
  ```sql
  SELECT * FROM single_table WHERE key1='Tom';        -- key1 普通索引 → ref
  SELECT * FROM single_table WHERE id BETWEEN 10 AND 20;  -- 主键范围 → range
  SELECT * FROM single_table WHERE key2 > 100;        -- 二级索引范围 → range
  ```

### 9.4　范围区间的提取（优化器怎么算"能用到多少索引"）
- 本质：优化器把 `WHERE` 条件按索引列拆成**扫描区间**，再估算命中行数。规则（以 `idx_key_part(a,b,c)` 与单列 `idx_key1` 为例）：
  - **AND 取各条件的"交集区间"**：`WHERE a=1 AND b>2` → 在 `a=1` 前缀下取 `b>2` 的子区间，仍可走索引。
  - **OR 取各条件的"并集区间"**，且只有各子条件用的索引**能合并(ROR, 行定序一致)** 时才走 Index Merge；否则退化为全表扫。
  - **范围条件会"截断"后续列**：`WHERE a>1 AND b=2` 中，因 `a` 是范围，`b` 在索引内不再有序，只能用到 `a`，`b` 在回表后过滤。
  ```sql
  -- 能提取出 [('a','Tom'),('a','Tom')] 单点区间 → ref/const
  WHERE key1 = 'Tom'
  -- 提取出 [('a','x'),('a','z')) 区间 → range
  WHERE key1 > 'x' AND key1 < 'z'
  ```

### 9.5　索引合并（Index Merge）
- 本质：5.7 优化器可能把多个索引的结果 **求交集(intersect)/并集(union)** 再合并，避免全表扫（详见第7章 7.8）。

### 9.6　排序与分组如何利用索引
- **ORDER BY 用索引**：当 `ORDER BY` 的列顺序与某索引(或联合索引前缀)一致且方向相同，可免去 filesort，直接按索引顺序取。
  ```sql
  -- idx_key_part(a,b,c)：以下都能利用索引排序
  ORDER BY key_part1, key_part2, key_part3          -- ✅ 与索引顺序一致
  ORDER BY key_part1 DESC, key_part2 DESC           -- ✅ 同方向
  ORDER BY key_part1 ASC, key_part2 DESC            -- ❌ 混合方向，需 filesort
  ```
- **GROUP BY 用索引**：`GROUP BY` 实际先排序再分组，若能用索引顺序则可免临时表+排序。

### 9.7　为什么有时候不走索引
- 本质：优化器觉得"走索引+回表"比"全表扫"还慢时（比如命中大部分行），会放弃索引。
- 常见原因（索引失效写法）：
  ```sql
  SELECT * FROM single_table WHERE YEAR(ctime)=2024;   -- ❌ 函数包列，索引失效
  SELECT * FROM single_table WHERE ctime>='2024-01-01';-- ✅ 范围，能用索引
  SELECT * FROM single_table WHERE key1 = 123;         -- ❌ 隐式转换(key1是字符串，给数字)
  SELECT * FROM single_table WHERE key1 LIKE '%Tom';    -- ❌ 前模糊，无法用 B+树前缀
  SELECT * FROM single_table WHERE key1 LIKE 'Tom%';    -- ✅ 后模糊，可用前缀
  SELECT * FROM single_table WHERE key1 = 'a' OR common_field='b'; -- ❌ OR 含无索引列
  ```
- 实战：用 `EXPLAIN` 看 `type` 与 `key`，判断是否真用了索引（见第14章）。

> 第9章面试高频：访问方法 const→eq_ref→ref→range→index→ALL、范围区间 AND 交/OR 并提取规则、范围截断后续列、排序/分组用索引、索引失效的常见写法。

### 9.8　实战演练：访问方法 type 与失效写法

```sql
-- 建 single_table 风格表（9.2 章）
CREATE TABLE pract.single_table (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  key1 VARCHAR(100), key2 INT, key3 VARCHAR(100),
  key_part1 VARCHAR(100), key_part2 VARCHAR(100), key_part3 VARCHAR(100),
  common_field VARCHAR(100),
  KEY idx_key1 (key1), KEY idx_key2 (key2), KEY idx_key3 (key3),
  KEY idx_key_part (key_part1, key_part2, key_part3)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

-- 各访问方法（9.1 章）看 type 列
EXPLAIN SELECT * FROM pract.single_table WHERE id=5;                       -- const
EXPLAIN SELECT * FROM pract.single_table WHERE key1='Tom';                 -- ref
EXPLAIN SELECT * FROM pract.single_table WHERE id BETWEEN 10 AND 20;        -- range
EXPLAIN SELECT * FROM pract.single_table WHERE key1 LIKE 'a%';             -- range
EXPLAIN SELECT key1 FROM pract.single_table;                               -- index（全索引扫）
EXPLAIN SELECT * FROM pract.single_table;                                  -- ALL（全表扫）

-- 索引失效写法（9.7 章）
EXPLAIN SELECT * FROM pract.single_table WHERE YEAR(key3)='2024';          -- ❌ 函数包列
EXPLAIN SELECT * FROM pract.single_table WHERE key1 = 123;                -- ❌ 隐式转换
EXPLAIN SELECT * FROM pract.single_table WHERE key1 LIKE '%Tom';          -- ❌ 前模糊
EXPLAIN SELECT * FROM pract.single_table WHERE key1='a' OR common_field='b'; -- ❌ OR 含无索引列

-- 排序/分组用索引（9.6 章）
EXPLAIN SELECT * FROM pract.single_table ORDER BY key_part1, key_part2;    -- ✅ 用索引排序，无 filesort
EXPLAIN SELECT key_part1, COUNT(*) FROM pract.single_table GROUP BY key_part1; -- 无索引则 Using temporary;filesort
CREATE INDEX idx_kp ON pract.single_table(key_part1);                      -- 补索引优化
```

---

## 第10章　连接的原理与算法

### 10.1　连接的本质

- 本质：连接 = 驱动表每取一条，去被驱动表**按连接条件找匹配**，本质是两表"嵌套循环"。结果集是"驱动表记录 × 匹配上的被驱动表记录"的笛卡尔积筛选。
- 实战：
  ```sql
  SELECT * FROM a JOIN b ON a.id = b.aid;
  -- 等价语义：对 a 每一行，去 b 找 aid=a.id 的行拼在一起
  ```

### 10.2　嵌套循环连接（Nested-Loop Join, NLJ）

- 本质：外层驱动表取一行，内层被驱动表用索引找匹配。被驱动表的连接列**有索引**才高效（否则内层每次都全表扫，复杂度 O(N×M) 灾难）。
  ```text
  for 每一行 r in 驱动表 a:            -- 走 a 的主键/全表
      for 每一行 s in 被驱动表 b:      -- 走 b.aid 的索引(高效)
          if s.aid == r.id: 输出 r⋈s
  ```

### 10.3　基于块的嵌套循环（Block Nested-Loop, BNL）
- 本质：被驱动表**没索引**时，MySQL 把驱动表**一批行放进 join buffer**，一次性和被驱动表整表比对，减少被驱动表扫描次数（从 N 次降到 ⌈驱动行数/批大小⌉ 次）。5.7 默认启用。
  ```text
  join buffer: [r1, r2, r3, ... 一批驱动行]
        │
        ▼ 一次扫描被驱动表 b
  for 每一行 s in b:
      for 每个 r in join buffer:
          if s.aid == r.id: 输出
  ```
- 实战优化：调大 `join_buffer_size` 可一次塞更多驱动行，进一步减少被驱动表扫描次数。
  ```sql
  SHOW VARIABLES LIKE 'join_buffer_size';
  SET SESSION join_buffer_size = 2*1024*1024;
  ```
- > 注意：**BNL 本身说明被驱动表缺索引**，治本是给连接列加索引走 NLJ；join buffer 只是缓解。

### 10.4　选择驱动表

- 本质：优化器挑"小表/过滤后行数少"的作驱动表；驱动表走全表（外层循环次数 = 驱动行数），被驱动表走索引。驱动表越小、外层循环越少。
- 多表连接时按"成本"排连接顺序（见第11章），不保证写在 `FROM` 前面的就是驱动表。

### 10.5　外连接与 NULL 补充（了解）
- 左外连接（LEFT JOIN）：驱动表（左表）的行**即使匹配不上也被保留**，被驱动表补 NULL。右外连接反之。
- 本质：外连接 = 内连接结果 + 驱动表"没匹配上"的补 NULL 行。当被驱动表有**非空条件**能排除 NULL 行时，优化器会把它**自动转成内连接**（内连接优化空间更大，见第13章）。

> 第10章面试高频：NLJ（被驱动表走索引）vs BNL（join buffer 批处理）、被驱动表连接列要有索引、join buffer_size 调优、驱动表选小表、外连接转内连接。

### 10.6　实战演练：连接算法 NLJ vs BNL

```sql
-- 准备两表（10.1 章）
CREATE TABLE pract.a (id INT PRIMARY KEY, name VARCHAR(20)) ENGINE=INNODB;
CREATE TABLE pract.b (aid INT, info VARCHAR(20), KEY idx_aid (aid)) ENGINE=INNODB;
INSERT INTO pract.a VALUES (1,'Tom'),(2,'Amy'),(3,'Bob');
INSERT INTO pract.b VALUES (1,'i1'),(1,'i2'),(2,'i3'),(3,'i4');

-- NLJ：被驱动表 b.aid 有索引 → 走索引（10.2 章）
EXPLAIN SELECT * FROM pract.a JOIN pract.b ON a.id=b.aid;     -- b 的 type=ref，用 idx_aid

-- BNL：被驱动表连接列无索引时退化（10.3 章）
ALTER TABLE pract.b DROP INDEX idx_aid;
EXPLAIN SELECT * FROM pract.a JOIN pract.b ON a.id=b.aid;     -- Extra 显示 Using join buffer (Block Nested Loop)
-- 调大 join buffer 缓解（10.3 章）
SET SESSION join_buffer_size = 2*1024*1024;
SHOW VARIABLES LIKE 'join_buffer_size';

-- 外连接转内连接（10.5 章）：被驱动表有非空条件时优化器自动转内连接
EXPLAIN SELECT * FROM pract.a LEFT JOIN pract.b ON a.id=b.aid WHERE b.info IS NOT NULL;
-- 因 b.info 非空条件排除 NULL，EXPLAIN 显示等价于 INNER JOIN

-- 还原索引（治本）
ALTER TABLE pract.b ADD INDEX idx_aid (aid);
```

---

## 第11章　基于成本的优化（Cost-Based Optimizer）

### 11.1　什么是成本
- **本质**：优化器给每种执行计划算"代价"，选最便宜的。成本 ≈ **IO 成本 + CPU 成本**。
  ```text
  总成本 = IO成本 + CPU成本
  IO成本  = 读取的页数 × 1.0          (磁盘/Buffer Pool 读一页的代价)
  CPU成本 = 读取并过滤的行数 × 0.2    (处理一行的代价)
  ```
- 通俗解释：哪个方案"读盘少 + 计算少"，就选哪个。这些系数是 5.7 的默认值，可用 `optimizer_cost` 相关变量调整。

### 11.2　单表查询的成本计算
- 本质：优化器对**每个可用索引**都估算一遍成本，再和全表扫比较，取最小。步骤：
  1. 根据 `WHERE` 提取扫描区间，估算**区间命中行数（rows）**。
  2. IO 成本 ≈ 区间页数 × 1.0（回表还要额外算聚簇索引页）。
  3. CPU 成本 ≈ rows × 0.2（读取 + 过滤）。
  4. 全表扫也参与：IO = 聚簇索引页数 × 1.0，CPU = 总行数 × 0.2。
- 所以即使有索引，若估算命中"大部分行"，全表扫成本反而更低 → 放弃索引（呼应第9章 9.7）。

### 11.3　连接查询的成本
- 本质：总成本 = 驱动表成本 + 驱动表行数 × 被驱动表单次访问成本。所以驱动表越小、被驱动表索引越好，总成本越低。
  ```text
  总成本 ≈ 驱动表成本
         + (驱动表估算行数 × 被驱动表单次访问成本[含回表])
  ```
- 多表连接会枚举连接顺序，对每种顺序算总成本，挑最低（连接数多时组合爆炸，受 `optimizer_search_depth` 限制）。

### 11.4　成本计算实战
- 实战（看优化器算的成本）：
  ```sql
  EXPLAIN FORMAT=JSON SELECT * FROM single_table WHERE key1='Tom' AND key2>100;
  -- 输出 "cost_info": { "query_cost": "x.xx" }；各候选计划在 considered_execution_plans 里
  -- 也可用 optimizer trace 看更细（见第15章）
  ```

> 第11章面试高频：成本 = IO×1.0 + CPU×0.2、优化器选最便宜计划、单表每个索引都参与比较、小驱动表省成本、命中大部分行时全表扫更优。

### 11.5　实战演练：成本与执行计划选择

```sql
-- 成本公式 IO×1.0 + CPU×0.2（11.1 章）：用 FORMAT=JSON 看 query_cost
EXPLAIN FORMAT=JSON
  SELECT * FROM pract.single_table WHERE key1='Tom' AND key2>100\G
-- 输出里 "cost_info": { "query_cost": "x.xx" }，各候选计划在 considered_execution_plans

-- 单表每个索引都参与比较（11.2 章）：对比走索引 vs 全表扫
EXPLAIN SELECT * FROM pract.single_table WHERE key2 > 0;      -- 若命中大多数行，优化器放弃 idx_key2 选 ALL
EXPLAIN SELECT * FROM pract.single_table WHERE key2 = 100;    -- 命中少，走 idx_key2 (ref)

-- 连接成本：小驱动表省成本（11.3 章）
EXPLAIN FORMAT=JSON
  SELECT * FROM pract.a JOIN pract.b ON a.id=b.aid\G
-- "query_cost" = 驱动表成本 + 驱动行数 × 被驱动表单次访问成本

-- 临时改成本系数看影响（仅观察，不建议生产改）
SHOW VARIABLES LIKE 'optimizer_cost%';                        -- 成本相关系统变量
```

---

## 第12章　MySQL 基于成本的统计数据

### 12.1　统计信息是什么
- 本质：优化器不会真去数，而是靠**统计信息**估算行数/基数——存在内存里，定期或触发生成。
- 两类：
  - **表统计**：多少行（`n_rows`）、多少聚簇页（`clustered_index_size`）、多少二级索引页。
  - **索引统计**：每个索引的"基数 Cardinality"（大概多少不同值），决定索引区分度。

### 12.2　统计信息的采集
- 本质：5.7 默认 `innodb_stats_persistent=ON`（持久化到 `mysql.innodb_table_stats` / `innodb_index_stats`，重启不丢）；采**样本页**估算，不是全扫。
  ```sql
  SHOW VARIABLES LIKE 'innodb_stats_persistent';
  SHOW VARIABLES LIKE 'innodb_stats_persistent_sample_pages';  -- 采样页数，默认20，越大越准越慢
  SHOW VARIABLES LIKE 'innodb_stats_auto_recalc';  -- 默认ON：表改动超10%自动重算
  ```
- 实战：
  ```sql
  SHOW TABLE STATUS LIKE 'single_table';   -- Rows 是估值(n_rows)
  SHOW INDEX FROM single_table;             -- Cardinality 是估值
  ANALYZE TABLE single_table;               -- 手动重新采样统计
  -- 查看持久化统计表
  SELECT * FROM mysql.innodb_table_stats WHERE table_name='single_table';
  SELECT * FROM mysql.innodb_index_stats WHERE table_name='single_table';
  ```

### 12.3　统计信息不准导致选错索引
- 本质：估算偏差大时，优化器可能弃用最优索引 → 慢查询（尤其数据倾斜、大批量导入后未统计）。解决：`ANALYZE TABLE` 或 `FORCE INDEX` / `USE INDEX`。
- 实战：
  ```sql
  SELECT * FROM single_table FORCE INDEX(idx_key1) WHERE key1='Tom';  -- 强制走某索引
  ANALYZE TABLE single_table;   -- 大批量写入后建议手动刷新统计
  ```
- > 注意：统计信息是**估算值**，Cardinality 不是精确去重数；`SHOW INDEX` 看到的可能是过时的，以 `ANALYZE` 后为准。

> 第12章面试高频：统计信息是估算、Cardinality 表区分度、持久化(innodb_stats_persistent)、采样页、自动重算(>10%)、ANALYZE TABLE、不准时用 FORCE INDEX。

### 12.4　实战演练：统计信息采集与不准处理

```sql
-- 统计信息持久化（12.2 章）
SHOW VARIABLES LIKE 'innodb_stats_persistent';             -- ON
SHOW VARIABLES LIKE 'innodb_stats_persistent_sample_pages';-- 采样页数，默认 20
SHOW VARIABLES LIKE 'innodb_stats_auto_recalc';            -- ON：改动超 10% 自动重算

-- 造数据看估算
INSERT INTO pract.single_table (key1,key2,key3,key_part1,key_part2,key_part3,common_field)
SELECT CONCAT('k',FLOOR(RAND()*1000)), FLOOR(RAND()*1000), CONCAT('k',FLOOR(RAND()*1000)),
       CONCAT('p',FLOOR(RAND()*10)), CONCAT('p',FLOOR(RAND()*10)), CONCAT('p',FLOOR(RAND()*10)),
       'c' FROM pract.single_table;   -- 翻倍插入，制造数据量

SHOW TABLE STATUS FROM pract LIKE 'single_table';          -- Rows 是估值
SHOW INDEX FROM pract.single_table;                         -- Cardinality 是估值（区分度）
SELECT * FROM mysql.innodb_table_stats  WHERE table_name='single_table';   -- 持久化表统计
SELECT * FROM mysql.innodb_index_stats  WHERE table_name='single_table';   -- 持久化索引统计

-- 不准时强制重算（12.3 章）
ANALYZE TABLE pract.single_table;                           -- 手动刷新统计
-- 或强制走某索引
EXPLAIN SELECT * FROM pract.single_table FORCE INDEX(idx_key1) WHERE key1='k5';
```

---

## 第13章　基于规则的优化（RBO / 启发式）

### 13.1　RBO 与 CBO 的区别
- 本质：CBO 看成本（第11章）；RBO 是"写死的规矩"，**无条件改写 SQL**，发生在 CBO 之前。5.7 以 CBO 为主，但仍有少量 RBO 规则先对语法树做等价变换，给 CBO 更优的输入。

### 13.2　常见的规则优化
- 本质（自动发生，无需你管）：
  - **恒成立/恒不成立条件移除**：`WHERE 1=1` 被删；`WHERE 1=0` 直接返回空集。
  - **外连接转内连接**：当被驱动表有"非空"条件能排除 NULL 行时，自动转内连接（内连接优化空间更大，可自由调连接顺序）。
  - **表达式化简**：`WHERE a = 5+3` 化简成 `a = 8`；`WHERE a = a` 化简；常量折叠。
  - **COUNT(*) / MIN / MAX 优化**：`MIN()` 走索引最左（B+树最小），`COUNT(*)` 用聚簇索引统计。

### 13.3　子查询优化（重点）
- 本质：MySQL 5.7 对子查询做了大量优化，避免"外层每行都执行一次子查询（DEPENDENT SUBQUERY）"的灾难。核心两条路：
  - **半连接（Semi-Join）**：`IN / =ANY (子查询)` 转成"只关心是否存在匹配"的连接，外层行最多输出一次。
    ```text
    优化前: SELECT * FROM a WHERE a.id IN (SELECT aid FROM b);
    优化后: a 与 b 做 semi-join（等价于 JOIN 但 a 每行最多留一条）
    ```
  - **物化（Materialization）**：把子查询结果物化成一张临时表（带去重索引），再与外层 JOIN，避免重复执行。
    ```text
    SELECT * FROM a WHERE a.id IN (子查询)
        → 子查询结果写入临时表 tmp(带索引)
        → a JOIN tmp
    ```
- 实战（看子查询怎么被优化）：
  ```sql
  EXPLAIN SELECT * FROM single_table
    WHERE key1 IN (SELECT key2 FROM single_table WHERE common_field='x');
  -- select_type 出现 SUBQUERY / MATERIALIZED；Extra 出现 Start temporary / End temporary（semi-join 标记）
  ```
- > 注意：若 `EXPLAIN` 看到 **`DEPENDENT SUBQUERY`**（依赖外层、每行重算），往往是性能坑，应改写 JOIN 或加索引让优化器走 semi-join/物化。

> 第13章面试高频：RBO 先于 CBO、外连接转内连接、表达式化简、子查询 semi-join(每行最多一条) 与物化(Materialization)、警惕 DEPENDENT SUBQUERY。

### 13.4　实战演练：子查询 semi-join 与物化观察

```sql
-- 准备子查询数据（13.3 章）
INSERT INTO pract.b (aid, info) VALUES (1,'x'),(2,'y'),(3,'z');

-- IN 子查询：5.7 常优化成 semi-join / 物化
EXPLAIN SELECT * FROM pract.a
  WHERE a.id IN (SELECT aid FROM pract.b WHERE info='x')\G
-- select_type 出现 SUBQUERY / MATERIALIZED；Extra 出现 Start temporary / End temporary（semi-join 标记）

-- 警惕 DEPENDENT SUBQUERY（性能坑）：相关子查询每行重算
EXPLAIN SELECT * FROM pract.a
  WHERE EXISTS (SELECT 1 FROM pract.b WHERE b.aid=a.id AND b.info='x')\G
-- 若 select_type=DEPENDENT SUBQUERY，改写 JOIN 或加索引走 semi-join

-- 表达式化简（13.2 章）：WHERE a.id = 1+1 被优化成 a.id=2（等价但直观验证）
EXPLAIN SELECT * FROM pract.a WHERE id = 1+1;              -- type=const，已化简
```

---

## 第14章　EXPLAIN 详解（重点实战）

### 14.1　怎么看执行计划

- 实战：
  ```sql
  EXPLAIN SELECT * FROM single_table WHERE key1='Tom';
  EXPLAIN FORMAT=JSON SELECT ...;   -- 更细（含 cost_info、used_key_parts）
  ```

### 14.2　关键列解读
EXPLAIN 各列含义速查：
```text
id        : 每个 SELECT 的编号。值越大越先执行；相同 id 自上而下顺序执行；NULL 为合并/物化
select_type: 查询类型
type      : 访问方法(见下，性能 const>eq_ref>ref>range>index>ALL)
possible_keys: 优化器认为可能用到的索引
key       : 实际选用的索引；NULL = 没用索引
key_len   : 实际用的索引字节数（看联合索引用到几列）
ref       : 与索引比较的字段/常量（如 const、库.表.列）
rows      : 估算扫描行数（越小越好）
filtered  : 估算被 WHERE 过滤后剩下的百分比（100=无额外过滤）
Extra     : 额外信息（见下，最重要）
```

- `id`：执行顺序，越大越先执行，相同则从上往下。
- `select_type` 常见取值：
  | 值 | 含义 |
  |---|---|
  | SIMPLE | 简单查询，无子查询/UNION |
  | PRIMARY | 最外层查询 |
  | SUBQUERY | 非相关子查询（只算一次）|
  | DEPENDENT SUBQUERY | 相关子查询，外层每行重算（性能坑）|
  | DERIVED | 派生表（FROM 子查询）|
  | MATERIALIZED | 物化子查询 |
  | UNION / UNION RESULT | UNION 各分支 / 去重合并结果 |
- `type`（访问方法，见第9章）：`const` > `eq_ref` > `ref` > `range` > `index` > `ALL`。
- `key_len` 小技巧：联合索引 `(a,b,c)`，若 `key_len` 只覆盖 a 的字节数，说明只用到了 a，b/c 没用上。
- `Extra` 关键项：
  - `Using index`：覆盖索引，好。
  - `Using where`：回表后还过滤（或索引没过滤完）。
  - `Using index condition`：**索引条件下推 ICP**（在存储引擎层用索引过滤，减少回表），5.6+ 特性，好。
  - `Using filesort`：不能利用索引排序，要额外排序，慢。
  - `Using temporary`：用了临时表（如 GROUP BY 无索引 / DISTINCT），慢。
  - `Using join buffer (Block Nested Loop)`：走了 BNL，被驱动表缺索引。

### 14.3　EXPLAIN 实战诊断
- 实战：
  ```sql
  EXPLAIN SELECT key_part1, COUNT(*) FROM single_table GROUP BY key_part1;
  -- 若 Extra 出现 Using temporary; Using filesort → 给 key_part1 加索引优化
  CREATE INDEX idx_kp ON single_table(key_part1);
  
  -- ICP 示例：范围后剩余条件在引擎层用索引过滤
  EXPLAIN SELECT * FROM single_table WHERE key1 LIKE 'a%' AND common_field='x';
  -- 若 key1 是索引、common_field 不是，Extra 可能显示 Using index condition
  ```

> 第14章面试高频：EXPLAIN 全列(id/select_type/type/key/key_len/rows/Extra)、type 档次、覆盖索引(Using index)/ICP(Using index condition)、filesort/temporary 是性能信号、key_len 看联合索引用到几列。

### 14.4　实战演练：EXPLAIN 逐列解读

```sql
-- 建联合索引便于观察 key_len（14.2 章）
CREATE INDEX idx_kp23 ON pract.single_table(key_part1, key_part2, key_part3);

-- 看 key_len：只用前 1 列
EXPLAIN SELECT * FROM pract.single_table WHERE key_part1='p1'\G
-- key_len 显示 key_part1 的字节数（utf8mb4 VARCHAR(100) 变长，约 302 = 100*3+2）

-- 用满 3 列
EXPLAIN SELECT * FROM pract.single_table WHERE key_part1='p1' AND key_part2='p2' AND key_part3='p3'\G
-- key_len 变大，说明联合索引三列都用上了

-- ICP（索引条件下推，14.2 章）：范围后剩余条件在引擎层过滤
EXPLAIN SELECT * FROM pract.single_table WHERE key1 LIKE 'k%' AND common_field='c'\G
-- Extra 可能显示 Using index condition（好，减少回表）

-- filesort / temporary 信号（14.3 章）
EXPLAIN SELECT key_part1, COUNT(*) FROM pract.single_table GROUP BY key_part1\G
-- 无 idx_kp 单列时 Extra=Using temporary; Using filesort；建 idx_kp 后消失
```

---

## 第15章　optimizer trace（优化器追踪）

### 15.1　为什么需要 trace

- 本质：EXPLAIN 只给"结果"，trace 给你看优化器**怎么算成本、为什么选这个计划**——排错利器。它把优化全过程（等价变换、索引候选、各计划成本、最终决策）以 JSON 输出。

### 15.2　使用方法

- 实战：
  ```sql
  SET optimizer_trace="enabled=on";        -- 开启（仅当前会话、仅下一条语句）
  SET optimizer_trace_max_mem_size=1000000; -- 防止大查询被截断
  SELECT * FROM single_table WHERE key1='Tom' AND key2>100;
  SELECT * FROM information_schema.OPTIMIZER_TRACE;   -- 看完整 JSON
  SET optimizer_trace="enabled=off";
  ```
- `OPTIMIZER_TRACE` 表关键字段：
  
  ```text
  OPTIMIZER_TRACE 表
   ├─ QUERY                      : 原始 SQL
   ├─ TRACE (JSON)
   │    ├─ join_preparation      : 准备阶段（RBO 等价变换、外连接转内连接）
   │    ├─ join_optimization
   │    │    ├─ rows_estimated   : 各表估算行数
   │    │    ├─ considered_execution_plans : 候选执行计划 + cost_info
   │    │    └─ chosen_access_method / best_access_path
   │    └─ join_execution        : 执行阶段（排序/临时表等）
   └─ MISSING_BYTES_BEYOND_MAX_MEM_SIZE : 是否被截断(0=完整)
  ```
- 重点看 `considered_execution_plans` 里各候选的 `cost_info`（含 `read_cost`、`eval_cost`、`prefix_cost`、`data_read_per_join`），对比为什么选了某个索引/连接顺序。

### 15.3　optimizer_switch 与开关

- 本质：许多优化（如 `index_merge`、`semijoin`、`materialization`、`mrr`）由 `optimizer_switch` 控制，可临时关闭来对比行为。
  ```sql
  SELECT @@optimizer_switch\G            -- 看所有开关
  SET optimizer_switch='index_merge=off';-- 临时关索引合并做对比
  ```
- 实战排查：当怀疑某优化"帮倒忙"时，关掉对应开关 + trace 对比，定位问题。

> 第15章面试高频：optimizer_trace 看成本计算过程（considered_execution_plans/cost_info）、information_schema.OPTIMIZER_TRACE 表结构、optimizer_switch 控制优化器开关。

### 15.4　实战演练：optimizer trace 看优化器决策

```sql
-- 开启 trace（15.2 章）
SET optimizer_trace="enabled=on";
SET optimizer_trace_max_mem_size=1000000;                  -- 防大查询被截断

-- 执行一条查询
SELECT * FROM pract.single_table WHERE key1='k5' AND key2>100;

-- 查看完整优化过程 JSON
SELECT * FROM information_schema.OPTIMIZER_TRACE\G
-- 重点看：
--   join_preparation：RBO 阶段做了什么等价变换
--   join_optimization.considered_execution_plans：各候选计划 + cost_info
--   MISSING_BYTES_BEYOND_MAX_MEM_SIZE = 0 表示完整

-- 用 optimizer_switch 关闭某优化做对比（15.3 章）
SELECT @@optimizer_switch\G                                -- 看所有开关
SET optimizer_switch='index_merge=off';                   -- 临时关索引合并
SELECT * FROM pract.single_table WHERE key1='k5' OR key2=100;
SELECT * FROM information_schema.OPTIMIZER_TRACE\G        -- 对比关掉后的计划差异
SET optimizer_switch='index_merge=on';                    -- 还原

SET optimizer_trace="enabled=off";
```

---

## 第16章　InnoDB 的 Buffer Pool（重点）

### 16.1　Buffer Pool 是什么

- **本质**：Buffer Pool 是 InnoDB 在内存里开的**一大块缓冲**，缓存"数据页 + 索引页"。读数据时先找它，命中就免磁盘 IO。
- 通俗解释：它是 MySQL 的"工作台"，最常访问的页摊在工作台上，不用每次跑仓库（磁盘）拿。
- 内部结构：Buffer Pool 被切成等大的**缓冲页（默认 16KB，与数据页一一对应）**，外加**控制块**（存页元数据）。还有一套 **chunk** 机制支持在线调整大小。
- Buffer Pool 向 OS 申请的是一整块连续内存，物理上按"控制块 + 碎片 + 缓存页"排列（控制块与缓存页一一配对，通过指针双向关联）：
  ```text
  <──── 向操作系统申请的一片连续内存 ────>
  ┌────┬────┬────┬────┬──────┬──────────────────────────┐
  │控制│控制│控制│控制│ 碎片 │ 缓存页 │ 缓存页 │ ... │ 缓存页 │
  │块1 │块2 │块3 │块4 │(对齐)│ (16KB) │ (16KB) │     │ (16KB) │
  └─┬──┴─┬──┴─┬──┴─┬──┴──────┴────────┴────────┴─────┴────────┘
    │      │      │    │           ↑ 每个控制块用指针指向自己描述的缓存页
    └──────┴──────┴────┘
  （控制块与缓存页成对；中间"碎片"是为内存对齐留的小空隙）
  ```
- free / flush / LRU 三条链表都由**链表基节点（记录 start/end/count）+ 控制块里的 pre/next 指针**串成：
  ```text
  free 链表基节点            flush 链表基节点           LRU 链表基节点
  ┌──────────┐             ┌──────────┐              ┌──────────┐
  │ start: ● │─┬─► 控制块   │ start: ● │─┬─► 脏控制块 │ start: ● │─┬─► 控制块
  │ end:   ● │ │  free_pre │ end:   ● │ │  flush_pre │ end:   ● │ │  (young热区…)
  │ count: n │ │  free_next│ count: m │ │  flush_next│ count: k │ │  (…old冷区)
  └──────────┘ │  ⇄ ...    └──────────┘ │  ⇄ ...     └──────────┘ │  ⇄ ...
               └────────────────────────┘                          │
  ```
- 多实例（innodb_buffer_pool_instances）下，每个实例**独立**维护上述三套链表；每个实例内部再按 **chunk** 切分，chunk 是运行时增减内存的粒度（实例间互不干扰，减少内部锁竞争）。

### 16.2　三条链表与 LRU 分代

- 本质：Buffer Pool 用三条链表管理缓冲页：
  ```text
  Buffer Pool 内存
   ├─ free 链表    : 空闲缓冲页（未被使用）
   ├─ LRU 链表     : 已用页，按"最近最少用"排序，淘汰尾部
   │     ┌─ young 区 (热，占 5/8) ─┐┌─ old 区 (冷，占 3/8) ─┐
   │     │ 最近访问的页           ││ 新载入的页先放这里    │
   │     └────────────────────────┘└──────────────────────┘
   │     (old 区页停留 > innodb_old_blocks_time 才升入 young)
   └─ flush 链表   : 脏页（被改过、还没写回磁盘），后台慢慢刷盘
  ```
  - **free 链表**：空闲页槽位，不够时从 LRU 淘汰。
  - **LRU 链表**：改进版分代 LRU，**新页先进 old 区**；只有停留超过 `innodb_old_blocks_time`（默认 1s）又被访问，才升入 young 区——这样**全表扫**只短暂占 old 区，不会冲掉热数据。
  - **flush 链表**：脏页链表，由 **后台刷盘线程**（page cleaner）按一定节奏写回磁盘。

### 16.3　多实例、chunk 与预读
- **多实例（instances）**：大内存下可拆成多个 Buffer Pool 实例（`innodb_buffer_pool_instances`，默认 8，当 size≥1G 时），减少内部 mutex 争用。
- **chunk**：每个实例由若干 chunk 组成，使得 `innodb_buffer_pool_size` 可**在线调整**（不需重启）。
- **预读（read-ahead）**：检测到顺序访问某个区（extent）时，主动把相邻页批量读入 Buffer Pool，减少后续 IO（`innodb_read_ahead_threshold`）。

### 16.4　配置与调优
- 实战：
  ```sql
  SHOW VARIABLES LIKE 'innodb_buffer_pool_size';  -- 一般设物理内存 60%~80%
  SHOW VARIABLES LIKE 'innodb_buffer_pool_instances';
  SHOW VARIABLES LIKE 'innodb_old_blocks_time';
  SHOW STATUS LIKE 'Innodb_buffer_pool_read%';    -- 看命中率
  ```
- 命中率 = 1 - (Innodb_buffer_pool_reads / Innodb_buffer_pool_read_requests)，越接近 1 越好。
- > 注意：**Buffer Pool 命中率**是核心健康指标；若命中率骤降，多半是全表扫/大查询把 old 区占满或内存不够。

> 第16章面试高频：Buffer Pool 缓存数据/索引页、三条链表(free/LRU/flush)、LRU 分代 young/old 防全表扫污染、chunk 在线调整、多实例、预读、buffer_pool_size 配内存 60-80%、命中率。

### 16.5　实战演练：Buffer Pool 调优与命中率

```sql
-- 查看 Buffer Pool 配置（16.1 / 16.3 章）
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';             -- 一般设物理内存 60%~80%
SHOW VARIABLES LIKE 'innodb_buffer_pool_instances';        -- 多实例，默认 8（size≥1G 时）
SHOW VARIABLES LIKE 'innodb_old_blocks_time';              -- old 区停留阈值，默认 1000ms
SHOW VARIABLES LIKE 'innodb_read_ahead_threshold';          -- 预读触发阈值

-- 命中率（16.4 章）：越接近 1 越好
SHOW GLOBAL STATUS LIKE 'Innodb_buffer_pool_read_requests'; -- 总请求次数
SHOW GLOBAL STATUS LIKE 'Innodb_buffer_pool_reads';         -- 其中落盘次数
-- 命中率 = 1 - (reads / read_requests)，可用 SQL 直接算：
SELECT 1 - (V.reads / V.requests) AS hit_rate
FROM (
  SELECT
    (SELECT VARIABLE_VALUE FROM information_schema.GLOBAL_STATUS
       WHERE VARIABLE_NAME='Innodb_buffer_pool_reads') AS reads,
    (SELECT VARIABLE_VALUE FROM information_schema.GLOBAL_STATUS
       WHERE VARIABLE_NAME='Innodb_buffer_pool_read_requests') AS requests
) V;

-- 在线调大 Buffer Pool（16.3 章 chunk 机制，无需重启）
SET GLOBAL innodb_buffer_pool_size = 2*1024*1024*1024;     -- 动态改为 2G（需 chunk 整除）
SHOW VARIABLES LIKE 'innodb_buffer_pool_chunk_size';       -- chunk 大小，调整需为其整数倍
```

> **生产监控建议（Buffer Pool 相关）**
> - **命中率告警线**：缓冲区命中率 `hit_rate` 持续 < 0.99（尤其 < 0.95）要告警——通常意味着内存不足或出现了大表全扫。
> - **脏页刷盘**：盯 `Innodb_buffer_pool_wait_free`（等待空闲页次数），持续增长说明 flush 跟不上写入，需调大 `innodb_io_capacity` 或 `innodb_max_dirty_pages_pct`。
> - **内存规划**：`innodb_buffer_pool_size` 设物理内存 60%~80%；专用 DB 机可到 75%~80%，但要给 OS 页缓存留余地（否则 swap 反而更慢）。
> - **监控命令（接入 zabbix/prometheus 示例）**：
>   ```bash
>   # 一键取命中率
>   mysql -uroot -p'xxx' -N -e "SHOW GLOBAL STATUS LIKE 'Innodb_buffer_pool_read%'" \
>     | awk '/requests/{r=$2} /reads/{s=$2} END{printf \"hit_rate=%.4f\n\", 1-s/r}'
>   # 看脏页比例与等待
>   mysql -uroot -p'xxx' -e "SHOW GLOBAL STATUS LIKE 'Innodb_buffer_pool_wait_free';"
>   ```
> - **在线扩内存**：先用 `SELECT @@innodb_buffer_pool_chunk_size` 确认 chunk，再 `SET GLOBAL innodb_buffer_pool_size=新值`（必须为 chunk×instances 整数倍），无需重启。

---

## 第17章　事务（重点）

### 17.1　事务的概念
- **本质**：事务 = 一组 SQL 要么**全部成功、要么全部失败**的原子单元。ACID 四大特性。
- 通俗举例（转账）：A 扣 100、B 加 100 必须同时成功或同时失败，不能只扣不加。
- 为什么需要事务——看并发交错如何破坏数据（两个事务各做 `A=A-5; B=B+5`，初始 A=10, B=10）：
  ```text
  串行执行(先T1后T2 或 先T2后T1)：最终 A=0, B=20  ← 结果一致、正确
  
  但 T1、T2 交替执行(无事务隔离)会乱：
  T1: read(A)=11      T2:                read(A)=11
  T1: A=A-5=6         T2:                A=A-5=6
  T1: write(A)=6      T2:                write(A)=6   ← 两次-5只减了一次！
  T1: read(B)=2       T2:                read(B)=7
  T1: B=B+5=7         T2:                B=B+5=12
  T1: write(B)=7      T2:                write(B)=12  ← 最终 A=6, B=12 错！
  ```
  这种"交叉执行导致更新丢失/脏写"正是事务（原子性+隔离性）要解决的问题。
- 实战：
  ```sql
  START TRANSACTION;
  UPDATE account SET money=money-100 WHERE id=1;
  UPDATE account SET money=money+100 WHERE id=2;
  COMMIT;          -- 或 ROLLBACK;
  ```

### 17.2　事务的状态机
- 本质：一个事务在生命周期里经历若干状态，不是"开/关"两态：
  ```text
         START TRANSACTION
                │
                ▼
           ACTIVE (活动中，可增删改查)
                │ 执行部分语句
                ▼
        ┌─ 部分提交 (语句执行完，未 COMMIT)
        │        │ COMMIT
        │        ▼
        │     COMMITTED (已提交，不可逆)
        │
        └─ 失败/ROLLBACK ─▶ ABORTED (已中止/回滚)
  ```
  - **ACTIVE**：活动中，正在执行语句。
  - **PARTIALLY COMMITTED**：最后一条语句执行完、还没真正提交。
  - **COMMITTED**：提交完成，改动持久化。
  - **ABORTED**：回滚/失败，改动撤销。
  - 只有 COMMITTED 的改动对外可见、不可回退。

### 17.3　ACID
- **A 原子性**：事务不可分割（靠 **undo log** 回滚到事务前状态）。
- **C 一致性**：数据从一个合法状态到另一个合法状态（业务层约束 + 数据库共同保证，如外键、唯一索引）。
- **I 隔离性**：并发事务互不干扰（靠 **锁 + MVCC**，见第20章）。
- **D 持久性**：提交后数据不丢（靠 **redo log + 刷盘**，见第18章）。
  ```text
  A 原子性 ── undo log
  C 一致性 ── 业务 + 约束
  I 隔离性 ── 锁 + MVCC
  D 持久性 ── redo log
  ```

### 17.4　事务的四种隔离级别
- 本质（并发问题递进）：
  | 隔离级别 | 脏读 | 不可重复读 | 幻读 |
  |---|---|---|---|
  | READ UNCOMMITTED（读未提交） | ❌有 | ❌有 | ❌有 |
  | READ COMMITTED (RC，读已提交) | ✅无 | ❌有 | ❌有 |
  | REPEATABLE READ (RR，5.7默认) | ✅无 | ✅无 | ⚠️基本无(靠MVCC+Next-Key) |
  | SERIALIZABLE（串行化） | ✅无 | ✅无 | ✅无 |

  **脏读**：读到别的事务未提交的数据（RU 才会）。
  **不可重复读**：同一行，别的事务修改更新，本事务前后读该行内容变了（侧重 **update，单行数据变化**）。
  **幻读**：范围查询，别的事务插入 / 删除，**结果集行数变化**（侧重 insert/delete，行数增减）。
- 实战：
  ```sql
  SELECT @@tx_isolation;                       -- 5.7 用 tx_isolation
  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  
  -- mysql8.0 查询当前事务隔离级别（变量名已改）
  SELECT @@transaction_isolation;
  ```

### 17.5　事务的使用

- 自动提交：`autocommit=ON`（默认），每条 SQL 自带隐式提交；显式 `START TRANSACTION` 会暂停自动提交。
- **隐式提交**：执行 DDL（`ALTER`/`CREATE` 等）、`SET AUTOCOMMIT=1` 等某些语句会悄悄提交当前事务。
- **保存点（savepoint）**：事务内可打点，只回滚到某点而非整段：
  ```sql
  START TRANSACTION;
  INSERT ...; SAVEPOINT sp1; INSERT ...;  -- 出错时
  ROLLBACK TO sp1;   -- 只撤回到 sp1，前面 INSERT 仍保留
  COMMIT;
  ```
- 实战：
  ```sql
  SET autocommit = 0;   -- 关闭自动提交，需手动 COMMIT
  ```

> 第17章面试高频：ACID 各自靠什么实现(undo/约束/锁+MVCC/redo)、事务状态机(ACTIVE→COMMITTED/ABORTED)、四种隔离级别能防什么问题、5.7 默认 RR、autocommit、8.0 变量改名 transaction_isolation。

### 17.6　实战演练：事务、隔离级别、保存点

```sql
-- 建转账表（17.1 章）
CREATE TABLE pract.account (id INT PRIMARY KEY, money INT) ENGINE=INNODB;
INSERT INTO pract.account VALUES (1,1000),(2,1000);

-- 原子性：要么全成功要么全回滚（17.1 章）
START TRANSACTION;
UPDATE pract.account SET money=money-100 WHERE id=1;
UPDATE pract.account SET money=money+100 WHERE id=2;
COMMIT;                                                  -- 两条同时生效
-- 回滚演示
START TRANSACTION;
UPDATE pract.account SET money=money-100 WHERE id=1;
ROLLBACK;                                                -- 撤销，id=1 仍 900/1000

-- 保存点（17.5 章）
START TRANSACTION;
INSERT INTO pract.account VALUES (3,500);
SAVEPOINT sp1;
INSERT INTO pract.account VALUES (4,500);
ROLLBACK TO sp1;                                        -- 只撤回到 sp1：id=3 在，id=4 不在
COMMIT;

-- 隔离级别（17.4 章）：看默认 + 切换
SELECT @@tx_isolation;                                  -- 5.7 用 tx_isolation，默认 REPEATABLE-READ
-- 📌 8.0 差异：8.0 把 tx_isolation 改名为 transaction_isolation，上面语句在 8.0 会报未知变量。
--    8.0 下请用：SELECT @@transaction_isolation;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT @@tx_isolation;
-- 📌 8.0 下对应：SELECT @@transaction_isolation;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- 自动提交（17.5 章）
SHOW VARIABLES LIKE 'autocommit';                       -- ON
SET autocommit=0;                                       -- 关闭，需手动 COMMIT
UPDATE pract.account SET money=2000 WHERE id=2;
ROLLBACK;                                               -- 因 autocommit=0 未提交，可回滚
SET autocommit=1;
```

---

## 第18章　redo 日志（重点）

### 18.1　为什么需要 redo
- **本质**：改数据先改内存（Buffer Pool），不能每次都立刻写磁盘（太慢）。redo 日志记录"哪个页改了啥"，**崩溃后靠它重放恢复**，保证持久性（D）。
- 核心价值：把"随机写数据页"变成"顺序写 redo 日志"，极大提升写入吞吐；脏页可以延迟、批量刷盘。

### 18.2　redo 日志格式与写入流程
- 本质：redo 是**物理逻辑日志**（记"页号 + 偏移 + 改后值"），先写 **redo log buffer**，再按策略刷盘（`innodb_flush_log_at_trx_commit`）。
  ```text
  事务改 Buffer Pool 页
        │ 同步生成 redo
        ▼
   redo log buffer (内存)
        │ 按 flush_log_at_trx_commit 刷盘
        ▼
   ib_logfile0/1 (磁盘，顺序写)
        │ 后台/Checkpoint 触发
        ▼
   脏页写回 .ibd 数据文件
  ```
- 实战（持久性关键参数）：
  ```sql
  SHOW VARIABLES LIKE 'innodb_flush_log_at_trx_commit';
  -- 1(默认)：每次提交都 fsync 刷盘，最安全（不丢已提交）
  -- 2：写 OS 缓存(页缓存)，靠 OS 刷，宕机可能丢
  -- 0：每秒刷一次，宕机可能丢约 1 秒
  ```

### 18.3　redo 日志文件与循环写
- 本质：redo 文件（`ib_logfile0/1`）**固定大小、循环写**；两个指针：
  - `write pos`：当前写入位置。
  - `checkpoint`：已刷脏、可覆盖的位置。二者之间空着，追上则要等刷脏。
- **Checkpoint 作用**：推进"可覆盖点"，记录"哪些脏页已落盘"，崩溃恢复只需从 checkpoint 之后重放。

### 18.4　崩溃恢复
- 本质：重启时，从最后一个 Checkpoint 开始**重放 redo**（已提交的事务补上），再靠 undo 回滚未提交的。
  ```text
  崩溃重启
    1. 定位最近 Checkpoint
    2. 顺序重放 redo：把已提交事务的改动补全到数据页
    3. 用 undo 回滚"未提交却被重放"的事务（保证原子性）
  ```
- 要点：redo 重放是**幂等**的（同一个改动重放多次结果一样），所以即使部分脏页已落盘也不怕。

> 第18章面试高频：redo 保证持久性、物理逻辑日志、redo buffer→fsync、flush_log_at_trx_commit=1 最安全、循环写(write pos/checkpoint)、崩溃重放+undo 回滚、redo 随机改→顺序写。

### 18.5　实战演练：redo 与持久性参数

```sql
-- redo 刷盘策略（18.2 章）：双1 中的第一条
SHOW VARIABLES LIKE 'innodb_flush_log_at_trx_commit';     -- 默认 1，每次提交 fsync 最安全
SHOW VARIABLES LIKE 'innodb_log_file_size';               -- 单个 redo 文件大小（默认 48M~50M）
SHOW VARIABLES LIKE 'innodb_log_files_in_group';          -- redo 文件个数（默认 2：ib_logfile0/1）
SHOW VARIABLES LIKE 'innodb_log_group_home_dir';          -- redo 文件目录（默认 datadir）

-- 验证持久性：提交后即使 mysqld 崩溃也不丢（18.4 章）
START TRANSACTION;
UPDATE pract.account SET money=9999 WHERE id=1;
COMMIT;                                                   -- 提交即 fsync 到 ib_logfile
-- 此时杀掉 mysqld -9，重启后 money=9999 仍在（靠 redo 重放恢复）

-- 循环写：看 Checkpoint 推进（18.3 章）
SHOW ENGINE INNODB STATUS\G                              -- 找 Log section:
--   Log sequence number   当前 LSN
--   Log flushed up to     已刷盘 LSN
--   Last checkpoint at    检查点 LSN（可覆盖点）

-- 调大 redo 文件（需重启且清旧文件，演示用，生产谨慎）
-- 修改 /etc/my.cnf: innodb_log_file_size=256M，停库→删旧 ib_logfile*→启动
```

---

## 第19章　undo 日志（重点）

### 19.1　undo 是什么
- **本质**：undo 记录"改之前的值"，用于**事务回滚**和 **MVCC 读旧版本**。它存在 undo 页里，通过版本链（roll_pointer）串成历史。

### 19.2　undo 的类型
- 两类，回收时机不同：
  ```text
  undo 日志
   ├─ insert undo  : INSERT 产生，事务提交后立刻丢弃（别人看不到新插入的行）
   └─ update undo  : UPDATE/DELETE 产生，要保留供 MVCC 历史版本，由 purge 线程回收
  ```
  - `insert undo`：插入的事务回滚用，提交后可直接丢（因为插入的行只有本事务自己可见）。
  - `update undo`：更新/删除用，要保留供 **MVCC 历史版本**，等所有快照读都不再需要后才由 purge 回收。

### 19.3　rollback 与 purge
- 本质：`ROLLBACK` 用 undo 把数据改回去（反向日志）；已提交事务的 update undo 留着给 MVCC，等没人要了由 **purge 线程**清理（否则 undo 表空间膨胀）。
  ```text
  正常提交：insert undo 丢；update undo 入 history 链表待 purge
  回滚：    顺着 undo 反向应用，恢复到事务前
  purge线程：定期清理"已无快照需要"的 update undo，回收 undo 页
  ```
- 实战观察 undo 膨胀：
  ```sql
  SHOW ENGINE INNODB STATUS\G   -- 看 History list length（越大说明待 purge 越多）
  ```
  > 注意：**长事务**会导致 update undo 长期无法 purge，undo 表空间持续膨胀，是线上常见隐患。

> 第19章面试高频：undo 用于回滚+MVCC、insert/update undo 区别(提交即丢 vs 待purge)、purge 线程回收、History list length 监控、长事务导致 undo 膨胀。

### 19.4　实战演练：undo、回滚与长事务监控

```sql
-- rollback 用 undo 回滚（19.3 章）
START TRANSACTION;
UPDATE pract.account SET money=1 WHERE id=1;
SELECT money FROM pract.account WHERE id=1;              -- 本事务内看到 1
ROLLBACK;                                                -- 用 undo 恢复
SELECT money FROM pract.account WHERE id=1;              -- 恢复为回滚前的值

-- 监控 undo 历史链表长度（19.3 章）：越大说明待 purge 越多
SHOW ENGINE INNODB STATUS\G                              -- 找 "History list length" 行

-- 长事务导致 undo 膨胀（19.3 章）：开一个长时间未提交的事务
START TRANSACTION;
SELECT * FROM pract.single_table;                        -- 开启快照读，持有旧版本
-- 在另一个会话大量 UPDATE，旧版本无法 purge → History list length 涨
SHOW ENGINE INNODB STATUS\G                              -- 对比 History list length 增大
COMMIT;                                                   -- 提交后 purge 线程会回收

-- undo 表空间（8.0 默认独立 undo 表空间；5.7 在 ibdata1 或独立 undo）
SHOW VARIABLES LIKE 'innodb_undo_directory';
SHOW VARIABLES LIKE 'innodb_undo_tablespaces';
```

---

## 第20章　MVCC 与隔离级别实现（重点）

### 20.1　MVCC 是什么

- **本质**：多版本并发控制——**同一行数据保留多个历史版本**，读不加锁、读写不阻塞，靠"版本链 + ReadView"实现。它让"读"和"写"各看各的版本，互不阻塞。

### 20.2　版本链（隐藏列）

- 本质：每行有隐藏列 `trx_id`（最近改它的事务ID）、`roll_pointer`（指向 undo 里的上个版本）；每次改都写入新版本，用 roll_pointer 链起 undo 里的旧版本，形成**版本链**。
  ```text
  当前聚簇索引行:  [数据] trx_id=20  roll_pointer ──▶ undo 版本(trx_id=15)
                                                     roll_pointer ──▶ undo 版本(trx_id=10)
  ```
  - 读取某行时，顺着 roll_pointer 在版本链上挑出"对自己可见"的那个版本。

### 20.3　ReadView（读视图）
- 本质：读时生成一个 ReadView（快照），记录**当前活跃（未提交）事务的 ID 列表** + 下一个将分配的事务 ID（`max_trx_id`）。判定规则：
  - 若版本的 `trx_id` < 活跃列表中最小 ID（即已提交且早于本快照）→ **可见**。
  - 若 `trx_id` 在活跃列表里或 ≥ max_trx_id（未提交/晚于快照）→ **不可见**，沿版本链往前找。
- 两种隔离级别的区别在"何时生成/复用 ReadView"：
  ```text
  READ COMMITTED (RC)：每次 SELECT 都生成新 ReadView
                       → 每次都能看到别人"刚提交"的 → 不可重复读
  REPEATABLE READ(RR)：事务内第一次 SELECT 生成 ReadView，之后复用同一个
                       → 始终看到同一快照 → 可重复读
  ```
- 实战：
  ```sql
  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  BEGIN;
  SELECT * FROM t;   -- 生成 ReadView(快照)，后续同事务 SELECT 复用它
  ```

### 20.4　MVCC 如何解决并发问题

- 本质：快照读（普通 `SELECT`）走 MVCC 不加锁，读写互不阻塞；当前读（`SELECT ... FOR UPDATE`、`UPDATE`、`DELETE`）才加锁，读到最新已提交版本。
  | 读类型 | 语句 | 是否加锁 | 实现 |
  |---|---|---|---|
  | 快照读 | 普通 `SELECT` | 否 | MVCC 版本链 |
  | 当前读 | `SELECT ... FOR UPDATE` / `LOCK IN SHARE MODE` / 写 | 是 | 加行锁/Next-Key Lock |
- RR 下靠 **Next-Key Lock（记录锁+间隙锁）** 防幻读（见第21章 21.3）。

> 第20章面试高频：MVCC=版本链+ReadView、trx_id/roll_pointer 形成版本链、ReadView 可见性判定、RC每次新视图/RR复用视图、快照读(不加锁)vs当前读(加锁)。

### 20.5　实战演练：MVCC 快照读验证（RR vs RC）

```sql
-- 会话A、会话B 两个连接，验证 MVCC（20.3 / 20.4 章）
-- 准备
CREATE TABLE pract.mvcc (id INT PRIMARY KEY, v INT) ENGINE=INNODB;
INSERT INTO pract.mvcc VALUES (1,100);

-- 场景1：RR 下可重复读（复用 ReadView）
-- 会话A: SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; BEGIN;
-- 会话A: SELECT * FROM pract.mvcc WHERE id=1;          -- 看到 v=100
-- 会话B: UPDATE pract.mvcc SET v=200 WHERE id=1; COMMIT;
-- 会话A: SELECT * FROM pract.mvcc WHERE id=1;          -- 仍看到 v=100（复用快照，可重复读）

-- 场景2：RC 下不可重复读（每次新 ReadView）
-- 会话A: SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; BEGIN;
-- 会话A: SELECT * FROM pract.mvcc WHERE id=1;          -- v=100
-- 会话B: UPDATE pract.mvcc SET v=300 WHERE id=1; COMMIT;
-- 会话A: SELECT * FROM pract.mvcc WHERE id=1;          -- 看到 v=300（RC 每次新视图）

-- 当前读（20.4 章）：加锁读最新已提交版本，不受快照影响
-- 会话A: BEGIN;
-- 会话A: SELECT * FROM pract.mvcc WHERE id=1 FOR UPDATE;  -- 当前读，看到最新 v
-- 会话A: COMMIT;

-- 查看当前事务与版本（观察 trx_id 思路）
SELECT * FROM information_schema.INNODB_TRX\G            -- 看活跃事务、trx_id
```

---

## 第21章　锁（重点）

### 21.1　锁的分类

- 本质：
  - **按粒度**：表锁（MyISAM 默认，开销小但并发低）、行锁（InnoDB，锁索引记录，并发高）。
  - **按模式**：共享锁 S（读，多事务可同时拿）、排他锁 X（写，独占）。
  - **意向锁**：表级 **IS / IX**，是"表里某行已被 S/X 锁"的标记，用于快速判断能否加表锁，避免逐行扫。
  ```text
  兼容性（请求/已有）：  IS   IX    S    X
          IS           ✓    ✓    ✓    ✗
          IX           ✓    ✓    ✗    ✗
          S            ✓    ✗    ✓    ✗
          X            ✗    ✗    ✗    ✗
  ```

### 21.2　行锁与索引的关系

- 本质：**InnoDB 行锁锁的是索引记录**。若 `WHERE` 没走索引（或索引失效）→ 退化为**锁全表（所有聚簇索引记录 + 间隙）**，危害极大，得小心！
- 实战体会：
  ```sql
  -- key1 有索引：只锁匹配到的索引记录
  UPDATE single_table SET common_field='x' WHERE key1='Tom';
  -- key1 被函数包/隐式转换导致索引失效：锁全表！
  UPDATE single_table SET common_field='x' WHERE YEAR(ctime)=2024;
  ```

### 21.3　Next-Key Lock（重点）

- **本质**：RR 隔离级别下，InnoDB 用 **Next-Key Lock = 记录锁(Record Lock) + 间隙锁(Gap Lock)**，锁住"某记录及其前面的间隙"，既防修改也防插入 → **解决幻读**。
  
  ```text
  索引记录:   ... 5   8   10   15 ...
  Next-Key Lock 锁定区间（左开右闭）：
    锁 id=10 时 → 锁住 (8, 10]；同时 (10,15) 间隙也可能被锁
    防别人 INSERT id=9（落在间隙）→ 防幻读
  ```
- 实战：
  ```sql
  SELECT * FROM single_table WHERE id=10 FOR UPDATE;  -- RR 下可能锁 (8,10]，防插入 id=9
  ```
- 注意：Next-Key Lock 在**唯一索引等值命中**（如 `id=10` 存在）时会**退化为只锁记录**（无需间隙锁）；范围查询或等值未命中才保留间隙锁。

### 21.4　死锁

- 本质：两个事务互相等待对方持有的锁。InnoDB 用**等待图（wait-for graph）**检测环，回滚其中一个（"代价小/undo 少"的）。
  ```text
  事务A 持有 id=1 的X锁，请求 id=2 的X锁
  事务B 持有 id=2 的X锁，请求 id=1 的X锁
        └─ 互相等待 → 形成环 → 死锁，InnoDB 回滚其一
  ```
- 实战规避：固定加锁顺序、缩短事务、降低隔离级别、给连接列加索引减少锁范围。

### 21.5　实战排锁
- 实战：
  ```sql
  SHOW ENGINE INNODB STATUS\G;   -- 看最近死锁、锁等待详情(LATEST DETECTED DEADLOCK)
  ```
- > 注意：**MySQL 8.0 移除了 `information_schema.INNODB_LOCKS` / `INNODB_LOCK_WAITS`**，改用 `performance_schema` 下的表：
  ```sql
  -- 等价原 INNODB_LOCKS：当前所有被持有的锁 + 等待的锁
  SELECT * FROM performance_schema.data_locks;
  -- 等价原 INNODB_LOCK_WAITS：锁等待关系
  SELECT * FROM performance_schema.data_lock_waits;
  ```
  > 5.7 仍可用 `information_schema.INNODB_LOCKS`，但 8.0 必须用上面的 `performance_schema` 表。

> 第21章面试高频：行锁锁索引、没索引=表锁、S/X/意向锁兼容矩阵、Next-Key=记录锁+间隙锁防幻读(唯一索引等值退化为记录锁)、死锁检测回滚、8.0 用 performance_schema.data_locks 看锁。

### 21.6　实战演练：锁、Next-Key 与死锁观察

```sql
-- 准备（21.2 章）：连接列有索引才能锁行
CREATE TABLE pract.lock_t (id INT PRIMARY KEY, v VARCHAR(20), KEY idx_v(v)) ENGINE=INNODB;
INSERT INTO pract.lock_t VALUES (1,'a'),(2,'b'),(3,'c'),(5,'e'),(8,'h'),(10,'j');

-- 行锁锁索引：有索引只锁匹配行
-- 会话A: BEGIN; UPDATE pract.lock_t SET v='x' WHERE id=1;   -- 锁 id=1 记录
-- 会话B: UPDATE pract.lock_t SET v='y' WHERE id=2;          -- 不阻塞，各锁各行
-- 会话B: UPDATE pract.lock_t SET v='z' WHERE id=1;          -- 阻塞，等 A 释放

-- Next-Key Lock（21.3 章）：RR 下范围/间隙锁防幻读
-- 会话A: SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; BEGIN;
-- 会话A: SELECT * FROM pract.lock_t WHERE id=10 FOR UPDATE; -- 锁 (8,10]，防插入 id=9
-- 会话B: INSERT INTO pract.lock_t VALUES (9,'m');           -- 阻塞！落在间隙被锁

-- 看当前锁（21.5 章）：5.7 用 INNODB_LOCKS（8.0 用 performance_schema.data_locks）
SELECT * FROM information_schema.INNODB_LOCKS;             -- 5.7 当前持有的锁
SHOW ENGINE INNODB STATUS\G                              -- LATEST DETECTED DEADLOCK 看死锁
-- 8.0 等价：
-- SELECT * FROM performance_schema.data_locks;
-- SELECT * FROM performance_schema.data_lock_waits;

-- 死锁演示（21.4 章）：互相等待
-- 会话A: BEGIN; UPDATE pract.lock_t SET v='x' WHERE id=1;
-- 会话B: BEGIN; UPDATE pract.lock_t SET v='y' WHERE id=2;
-- 会话A: UPDATE pract.lock_t SET v='x' WHERE id=2;          -- 等 B
-- 会话B: UPDATE pract.lock_t SET v='y' WHERE id=1;          -- 等 A → 死锁，一方被回滚
```

---

## 第22章　MySQL 实战调优与运维速查

### 22.1　慢查询定位

- 实战：
  ```sql
  SHOW VARIABLES LIKE 'slow_query_log';
  SET GLOBAL slow_query_log = ON;
  SET GLOBAL long_query_time = 1;   -- 超 1 秒记慢日志
  -- 用 mysqldumpslow 分析
  mysqldumpslow -s t /var/log/mysql/slow.log
  ```

### 22.2　慢查询优化套路
- 本质：① `EXPLAIN` 看 type/key/rows/Extra → ② 缺索引就加（注意最左前缀）→ ③ 避免索引失效写法 → ④ 大表分页用延时关联 → ⑤ 大事务拆小。
- 实战（深分页优化）：
  ```sql
  -- 慢：SELECT * FROM t ORDER BY id LIMIT 1000000,10;
  -- 快：先拿 id 再回表
  SELECT * FROM t JOIN (SELECT id FROM t ORDER BY id LIMIT 1000000,10) x USING(id);
  
  -- 拆解意思   
  -- x是别名  USING(id) 等价于 ON t.id = x.id，用 10 个 id 去主表 t 精确匹配。
  子查询: 扫主键索引 → 跳过100万 → 取10个id (无回表, 极快)
     ↓ 10个id
  JOIN 主表: 用10个id走主键 → 精准回表10次 → 拿整行
  
  
  用 EXPLAIN 看差异
  -- 原始慢 SQL
  EXPLAIN SELECT * FROM t ORDER BY id LIMIT 1000000,10;
  -- type=index 或 ALL, rows≈1000010, Extra 可能有 Using filesort
  
  -- 优化后
  EXPLAIN
  SELECT * FROM t
  JOIN (SELECT id FROM t ORDER BY id LIMIT 1000000,10) x
  USING(id);
  -- 派生表 x: type=index/range, rows≈10
  -- 主表 t: type=eq_ref, key=PRIMARY, rows=1  ← 精准命中
  
  
  ```

### 22.3　关键参数速查
- `innodb_buffer_pool_size`：内存 60-80%，核心。
- `innodb_flush_log_at_trx_commit=1`：redo 提交刷盘，保持久。
- `sync_binlog=1`：binlog 每事务刷盘，双1保不丢。
- `max_connections`：最大连接数。
- `innodb_file_per_table=ON`：独立表空间（5.7 默认）。

### 22.4　备份与恢复
- 实战：
  ```bash
  mysqldump -uroot -p --single-transaction shop > shop.sql   # 逻辑备份(InnoDB热备)
  mysql -uroot -p shop < shop.sql                            # 恢复
  ```

### 22.4.1　生产环境备份策略（直接可用）

> 生产不能只靠 `mysqldump`。推荐 **xtrabackup 物理全量 + binlog 增量（时间点恢复 PITR）** 组合。

```bash
# ===== A. 物理全备（xtrabackup，热备不锁表，速度快、适合大库）=====
# 安装：yum install -y percona-xtrabackup-24   # 5.7 用 2.4；8.0 用 xtrabackup-80
# 全量备份到 /backup/full
xtrabackup --backup --target-dir=/backup/full \
  --user=root --password='MyNewPass#2024' \
  --socket=/data/mysql/tmp/mysql.sock
# 准备（apply redo，使备份一致）
xtrabackup --prepare --target-dir=/backup/full
# 恢复：先停库，清空 datadir，再拷回
#   systemctl stop mysqld
#   rm -rf /data/mysql/data/*
#   xtrabackup --copy-back --target-dir=/backup/full
#   chown -R mysql:mysql /data/mysql/data && systemctl start mysqld

# ===== B. 增量备份（基于上次全量/增量）=====
xtrabackup --backup --target-dir=/backup/inc1 \
  --incremental-basedir=/backup/full \
  --user=root --password='MyNewPass#2024' --socket=/data/mysql/tmp/mysql.sock

# ===== C. 定时任务（crontab，每日全备+ binlog  flush）=====
# 0 2 * * *  xtrabackup --backup --target-dir=/backup/full_$(date +\%F) --user=root --password=xxx
# 0 1 * * *  mysql -uroot -p'xxx' -e "FLUSH BINARY LOGS"     # 切 binlog，旧的可归档

# ===== D. 时间点恢复 PITR（误删表后恢复到删除前）=====
# 1) 用全备+增量恢复到"误操作前"的基础
# 2) 用 mysqlbinlog 回放 binlog 到误操作前一刻：
mysqlbinlog --start-datetime="2026-08-14 02:00:00" \
            --stop-datetime="2026-08-14 09:30:00" \
            /data/mysql/logs/mysql-bin.000012 | mysql -uroot -p
# 📌 前提：已开 log_bin（见 1.11 生产配置），否则无法 PITR
```

> **生产铁律**：备份后**务必演练恢复**（restore drill）！没验证过的备份等于没备份。`expire_logs_days` 要 ≥ 全备周期，保证能链式恢复。

> 第22章面试高频：慢日志+EXPLAIN 组合拳、深分页延时关联、双1参数(buffer+sync_binlog)、mysqldump 热备、xtrabackup 物理备+binlog PITR。

### 22.5　实战演练：慢查询、深分页、备份与 binlog

```sql
-- 慢查询定位（22.1 章）
SHOW VARIABLES LIKE 'slow_query_log';
SET GLOBAL slow_query_log = ON;
SET GLOBAL long_query_time = 1;                           -- 超过 1 秒记慢日志
SHOW VARIABLES LIKE 'slow_query_log_file';
-- 造一条慢 SQL（无索引全表扫）
SELECT SQL_NO_CACHE * FROM pract.single_table WHERE common_field='c' AND key1 LIKE '%x';
-- 系统层分析慢日志
# mysqldumpslow -s t /data/mysql/logs/slow.log          -- 按时间排序 top 慢查询

-- 深分页优化（22.2 章）：延时关联
SELECT * FROM pract.single_table ORDER BY id LIMIT 1000000,10;                     -- 慢
SELECT * FROM pract.single_table t
  JOIN (SELECT id FROM pract.single_table ORDER BY id LIMIT 1000000,10) x USING(id);  -- 快

-- 双1 参数（22.3 章）：保证不丢
SHOW VARIABLES LIKE 'innodb_flush_log_at_trx_commit';    -- 1
SHOW VARIABLES LIKE 'sync_binlog';                       -- 1（binlog 每事务刷盘）

-- 备份与恢复（22.4 章）
# mysqldump -uroot -p --single-transaction pract > /tmp/pract.sql    # InnoDB 热备
# mysql -uroot -p pract < /tmp/pract.sql                             # 恢复

-- binlog（配合备份做点对点恢复）
SHOW VARIABLES LIKE 'log_bin';                            -- 是否开启 binlog
SHOW BINARY LOGS;                                         -- 列出 binlog 文件
SHOW MASTER STATUS;                                       -- 当前 binlog 位置
# mysqlbinlog /data/mysql/logs/mysql-bin.000001 | less    # 解析 binlog 内容
```

---

## 全书面试高频速记（自测）

1. **架构**：C/S、mysqld 单进程多线程、启动选项 vs 系统变量。
2. **存储**：页16KB、行格式 DYNAMIC、聚簇索引=数据、二级索引回表。
3. **索引**：B+ 树、最左前缀、覆盖索引、索引失效（函数/隐式转换/%前模糊）。
4. **优化**：EXPLAIN 的 type/key/rows/Extra、成本=IO+CPU、统计信息估算。
5. **事务**：ACID、RR 默认、MVCC 版本链+ReadView、redo 持久 / undo 回滚。
6. **锁**：行锁锁索引、Next-Key 防幻读、死锁检测回滚。
7. **调优**：Buffer Pool 命中率、慢日志+EXPLAIN、双1、深分页优化。

---

## 参考资料（延伸阅读）

> 本章内容提炼自《MySQL是怎样运行的》原书第26章"参考资料"的标题，供进一步深入。

### 官方文档与站点
- MySQL 官方文档（5.7）：https://dev.mysql.com/doc/refman/5.7/en/
- MySQL Internals Manual：https://dev.mysql.com/doc/internals/en/
- MySQL 8.0 源码文档：https://dev.mysql.com/doc/dev/mysql-server
- MySQL Server Blog：http://mysqlserverteam.com/

### 优质博客 / 专栏
- 何登成（hedengcheng）技术博客：https://github.com/hedengcheng/tech
- orczhou 的博客：http://www.orczhou.com/
- Jeremy Cole 的 InnoDB 博客（含 innodb_ruby 工具）：https://blog.jcole.us/innodb/
- 那海蓝蓝（李海翔）博客、taobao 月报（源码阅读指南）：http://mysql.taobao.org/monthly/
- mysql_lover、Jorgen's point of view、MariaDB 查询优化文档、非官方优化文档（optimizer-trace 详解）

### 书籍
- 《高性能 MySQL》（Baron Schwartz 等）
- 《MySQL 技术内幕：InnoDB 存储引擎（第2版）》（姜承尧）
- 《数据库查询优化器的艺术》《数据库事务处理的艺术》（李海翔）
- 《MySQL 运维内参》（周彦伟等）
- 《Effective MySQL：Optimizing SQL Statements》（Ronald Bradford）
- 《MySQL 技术内幕（第5版）》（Paul DuBois）
- 《数据库系统概念》（Silberschatz 等）
- 《事务处理：概念与技术》（Jim Gray 等）

---

## 从零开始实操（CentOS 7 二进制 5.7.40，一步一命令可复制）

> 把全书的 22 章知识点串成一条**可复制粘贴**的实操线。理论为实战服务：每执行一步，回前面对应章节看"为什么"。
> 约定：以 `#` 开头是 shell 命令，`mysql>` 开头是 SQL；`<临时密码>` 等尖括号需替换成你机器上的实际值。

### 阶段 0：安装与启动（对应第1、2章）

```bash
# 0.1 卸冲突包 + 装依赖（第1章 1.9）
yum remove -y mariadb-libs
yum install -y libaio numactl-libs wget

# 0.2 下载官方二进制包 5.7.40（el7 x86_64）
cd /usr/local/src
wget https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.40-linux-glibc2.12-x86_64.tar.gz
tar -xzf mysql-5.7.40-linux-glibc2.12-x86_64.tar.gz
ln -s /usr/local/src/mysql-5.7.40-linux-glibc2.12-x86_64 /usr/local/mysql

# 0.3 建用户与目录（第2章 数据目录）
groupadd mysql
useradd -r -g mysql -s /bin/false mysql
mkdir -p /data/mysql/{data,logs,tmp}
chown -R mysql:mysql /data/mysql /usr/local/mysql

# 0.4 写配置文件 /etc/my.cnf（第1.3/1.4 章 选项组 + 系统变量；第4章 字符集）
cat > /etc/my.cnf <<'EOF'
[client]
port=3306
socket=/data/mysql/tmp/mysql.sock
default-character-set=utf8mb4
[mysqld]
user=mysql
basedir=/usr/local/mysql
datadir=/data/mysql/data
tmpdir=/data/mysql/tmp
socket=/data/mysql/tmp/mysql.sock
pid-file=/data/mysql/tmp/mysqld.pid
log-error=/data/mysql/logs/error.log
port=3306
character-set-server=utf8mb4
collation-server=utf8mb4_general_ci
default-storage-engine=INNODB
innodb_file_per_table=ON
max_connections=500
EOF

# 0.5 初始化数据目录（第2章；5.7 生成临时 root 密码）
/usr/local/mysql/bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql/data
grep 'temporary password' /data/mysql/logs/error.log        # 记下 <临时密码>

# 0.6 systemd 托管并启动（第1.2 章 启动方式）
cat > /usr/lib/systemd/system/mysqld.service <<'EOF'
[Unit]
Description=MySQL Server 5.7.40
After=network.target
[Service]
User=mysql
Group=mysql
ExecStart=/usr/local/mysql/bin/mysqld --defaults-file=/etc/my.cnf
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable mysqld
systemctl start mysqld
systemctl status mysqld                                # 应显示 active (running)

# 0.7 登录改密码 + 加 PATH（第1.1 章 客户端连接）
/usr/local/mysql/bin/mysql -uroot -p -S /data/mysql/tmp/mysql.sock   # 输入 <临时密码>
# 进库执行：
#   ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass#2024';
echo 'export PATH=/usr/local/mysql/bin:$PATH' >> /etc/profile
source /etc/profile
```

> **📌 MySQL 8.0 安装差异（对照本阶段 0）**
> - 下载包：8.0 为 `mysql-8.0.x-linux-glibc2.12-x86_64.tar.xz`（`.tar.xz`、archive 路径 `/archives/get/p/30/file/`），解压 `tar -xJf`。
> - 认证插件：5.7 默认 `mysql_native_password`，**8.0 默认 `caching_sha2_password`**（老驱动连不上）。在 `[mysqld]` 加 `default_authentication_plugin=mysql_native_password` 或建用户显式指定插件（见阶段1注释）。
> - `.frm` 文件：5.7 表结构有 `.frm`；8.0 已合并进 `.ibd`，无 `.frm`（见阶段1/第2章）。
> - 默认字符集：8.0 已默认 `utf8mb4`，本配置显式写 `utf8mb4` 在 8.0 下同样安全。
> - `--initialize` 一致：8.0 同样生成临时 root 密码到 error.log。

### 阶段 1：权限 / 字符集 / 行格式（对应第3、4、5章）

```sql
-- 第3章 用户权限（3.4 实战）
CREATE USER 'app'@'192.168.%' IDENTIFIED BY 'AppPass#123';
-- 📌 8.0 差异：8.0 默认认证插件 caching_sha2_password，老客户端连不上。8.0 兼容写法：
--    CREATE USER 'app'@'192.168.%' IDENTIFIED WITH mysql_native_password BY 'AppPass#123';
GRANT SELECT, INSERT, UPDATE, DELETE ON pract.* TO 'app'@'192.168.%';
FLUSH PRIVILEGES;
SELECT user, host FROM mysql.user;
SHOW GRANTS FOR 'app'@'192.168.%';

-- 第4章 字符集（4.6 实战）：四层级 + emoji + 防乱码
CREATE DATABASE shop DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE TABLE shop.user (
  id INT,
  name VARCHAR(50) CHARSET utf8mb4 COLLATE utf8mb4_bin
) DEFAULT CHARSET=utf8mb4;
INSERT INTO shop.user VALUES (1, '😀emoji');
SET NAMES utf8mb4;                                       -- 防乱码三连
SHOW VARIABLES LIKE 'character_set_%';
SELECT 'A' = 'a' COLLATE utf8mb4_general_ci;            -- 1（ci 不区分大小写）

-- 第5章 行格式（5.7 实战）：DYNAMIC 默认 + 变长/溢出
CREATE TABLE pract.t_row (id INT PRIMARY KEY, a VARCHAR(10), b CHAR(10)) ROW_FORMAT=DYNAMIC;
SHOW TABLE STATUS FROM pract LIKE 't_row';              -- Row_format=DYNAMIC
CREATE TABLE pract.t_over (id INT PRIMARY KEY, big TEXT) ROW_FORMAT=DYNAMIC;
INSERT INTO pract.t_over VALUES (1, REPEAT('a', 16000)); -- 触发行溢出
```

### 阶段 2：索引 / 表空间 / 访问方法（对应第6、7、8、9章）

```sql
-- 第6章 页（6.5 实战）
SHOW VARIABLES LIKE 'innodb_page_size';                  -- 16384 = 16KB

-- 第7章 索引（7.9 实战）：聚簇/二级/联合/覆盖/Index Merge
CREATE TABLE pract.t_idx (
  id INT PRIMARY KEY, a VARCHAR(20), b INT, c VARCHAR(20), common VARCHAR(20)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4;
INSERT INTO pract.t_idx VALUES
  (1,'Tom',10,'x','m'),(2,'Amy',20,'y','n'),(3,'Tom',30,'z','m'),(4,'Bob',10,'x','n');
CREATE INDEX idx_a ON pract.t_idx(a);
CREATE INDEX idx_abc ON pract.t_idx(a,b,c);
EXPLAIN SELECT * FROM pract.t_idx WHERE a='Tom';         -- ref + 回表
EXPLAIN SELECT a,b FROM pract.t_idx WHERE a='Tom';       -- Using index（覆盖）
EXPLAIN SELECT * FROM pract.t_idx WHERE b=10;            -- ALL（跳 a 失效）

-- 第8章 表空间（8.6 实战）
SHOW VARIABLES LIKE 'innodb_file_per_table';             -- ON
ls -lh /data/mysql/data/pract/t_idx.ibd                  -- 独立表空间文件

-- 第9章 访问方法（9.8 实战）
CREATE TABLE pract.single_table (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  key1 VARCHAR(100), key2 INT, key3 VARCHAR(100),
  key_part1 VARCHAR(100), key_part2 VARCHAR(100), key_part3 VARCHAR(100),
  common_field VARCHAR(100),
  KEY idx_key1 (key1), KEY idx_key2 (key2), KEY idx_key3 (key3),
  KEY idx_key_part (key_part1, key_part2, key_part3)
) ENGINE=INNODB DEFAULT CHARSET=utf8;
EXPLAIN SELECT * FROM pract.single_table WHERE id=5;     -- const
EXPLAIN SELECT * FROM pract.single_table WHERE key1='Tom'; -- ref
EXPLAIN SELECT * FROM pract.single_table WHERE key1 LIKE '%Tom'; -- ALL（前模糊失效）
```

### 阶段 3：连接 / 成本 / 统计 / 优化器（对应第10、11、12、13、14、15章）

```sql
-- 第10章 连接（10.6 实战）
CREATE TABLE pract.a (id INT PRIMARY KEY, name VARCHAR(20)) ENGINE=INNODB;
CREATE TABLE pract.b (aid INT, info VARCHAR(20), KEY idx_aid(aid)) ENGINE=INNODB;
INSERT INTO pract.a VALUES (1,'Tom'),(2,'Amy'),(3,'Bob');
INSERT INTO pract.b VALUES (1,'i1'),(2,'i3'),(3,'i4');
EXPLAIN SELECT * FROM pract.a JOIN pract.b ON a.id=b.aid;   -- b 走 ref（NLJ）

-- 第11章 成本（11.5 实战）
EXPLAIN FORMAT=JSON SELECT * FROM pract.single_table WHERE key1='Tom' AND key2>100\G  -- 看 query_cost

-- 第12章 统计（12.4 实战）
SHOW VARIABLES LIKE 'innodb_stats_persistent';
SHOW INDEX FROM pract.single_table;                      -- Cardinality 估算
ANALYZE TABLE pract.single_table;                        -- 手动刷新

-- 第13章 子查询（13.4 实战）
EXPLAIN SELECT * FROM pract.a WHERE a.id IN (SELECT aid FROM pract.b WHERE info='x')\G; -- semi-join/物化

-- 第14章 EXPLAIN（14.4 实战）：看 key_len
CREATE INDEX idx_kp23 ON pract.single_table(key_part1,key_part2,key_part3);
EXPLAIN SELECT * FROM pract.single_table WHERE key_part1='p1' AND key_part2='p2'\G;     -- key_len 含前两列

-- 第15章 optimizer trace（15.4 实战）
SET optimizer_trace="enabled=on";
SELECT * FROM pract.single_table WHERE key1='k5' AND key2>100;
SELECT * FROM information_schema.OPTIMIZER_TRACE\G        -- 看 considered_execution_plans
SET optimizer_trace="enabled=off";
```

### 阶段 4：Buffer Pool / 事务 / 日志 / MVCC / 锁（对应第16–21章）

```sql
-- 第16章 Buffer Pool（16.5 实战）
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
SELECT 1 - (V.reads/V.requests) AS hit_rate FROM (
  SELECT
   (SELECT VARIABLE_VALUE FROM information_schema.GLOBAL_STATUS WHERE VARIABLE_NAME='Innodb_buffer_pool_reads') reads,
   (SELECT VARIABLE_VALUE FROM information_schema.GLOBAL_STATUS WHERE VARIABLE_NAME='Innodb_buffer_pool_read_requests') requests
) V;

-- 第17章 事务（17.6 实战）
CREATE TABLE pract.account (id INT PRIMARY KEY, money INT) ENGINE=INNODB;
INSERT INTO pract.account VALUES (1,1000),(2,1000);
START TRANSACTION;
UPDATE pract.account SET money=money-100 WHERE id=1;
UPDATE pract.account SET money=money+100 WHERE id=2;
COMMIT;                                                   -- 原子性：两条同时生效
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;  -- 切隔离级别
SELECT @@tx_isolation;                                    -- 5.7 用 tx_isolation
-- 📌 8.0 差异：8.0 变量改名 transaction_isolation，请用 SELECT @@transaction_isolation;

-- 第18章 redo（18.5 实战）
SHOW VARIABLES LIKE 'innodb_flush_log_at_trx_commit';     -- 1 最安全
SHOW ENGINE INNODB STATUS\G                              -- Log sequence / Checkpoint

-- 第19章 undo（19.4 实战）
START TRANSACTION; UPDATE pract.account SET money=1 WHERE id=1; ROLLBACK;  -- undo 回滚
SHOW ENGINE INNODB STATUS\G                              -- History list length

-- 第20章 MVCC（20.5 实战）：开两个会话对比 RR/RC
CREATE TABLE pract.mvcc (id INT PRIMARY KEY, v INT) ENGINE=INNODB;
INSERT INTO pract.mvcc VALUES (1,100);
-- 会话A(RR): BEGIN; SELECT * FROM pract.mvcc WHERE id=1;  -- v=100
-- 会话B:      UPDATE pract.mvcc SET v=200 WHERE id=1; COMMIT;
-- 会话A:      SELECT * FROM pract.mvcc WHERE id=1;        -- RR 仍看到 100

-- 第21章 锁（21.6 实战）
CREATE TABLE pract.lock_t (id INT PRIMARY KEY, v VARCHAR(20), KEY idx_v(v)) ENGINE=INNODB;
INSERT INTO pract.lock_t VALUES (1,'a'),(2,'b'),(3,'c'),(5,'e'),(8,'h'),(10,'j');
-- 会话A: BEGIN; SELECT * FROM pract.lock_t WHERE id=10 FOR UPDATE;  -- RR 锁 (8,10]
-- 会话B: INSERT INTO pract.lock_t VALUES (9,'m');                    -- 阻塞（间隙锁防幻读）
SELECT * FROM information_schema.INNODB_LOCKS;           -- 5.7 看当前锁
-- 📌 8.0 差异：8.0 移除 INNODB_LOCKS，改用 performance_schema.data_locks：
--    SELECT * FROM performance_schema.data_locks;
```

### 阶段 5：调优与运维（对应第22章）

```sql
-- 第22章（22.5 实战）
SET GLOBAL slow_query_log = ON;
SET GLOBAL long_query_time = 1;
SELECT * FROM pract.single_table ORDER BY id LIMIT 1000000,10;                    -- 慢：深分页
SELECT * FROM pract.single_table t
  JOIN (SELECT id FROM pract.single_table ORDER BY id LIMIT 1000000,10) x USING(id);  -- 快：延时关联
SHOW VARIABLES LIKE 'sync_binlog';                       -- 双1 之 binlog 刷盘
SHOW BINARY LOGS;                                        -- binlog 文件列表
```
```bash
# 逻辑备份 / 恢复（22.4 实战，适合小库/单表）
mysqldump -uroot -p --single-transaction pract > /tmp/pract.sql     # InnoDB 热备
mysql -uroot -p pract < /tmp/pract.sql                              # 恢复
# 慢日志分析
mysqldumpslow -s t /data/mysql/logs/slow.log                       # 按耗时排序

# ===== 生产备份组合：xtrabackup 物理全备 + binlog（详细见 22.4.1）=====
# 每日全备（crontab）
# 0 2 * * * xtrabackup --backup --target-dir=/backup/full_$(date +\%F) \
#   --user=root --password='xxx' --socket=/data/mysql/tmp/mysql.sock
# 每日切 binlog，保证可 PITR
# 0 1 * * * mysql -uroot -p'xxx' -e "FLUSH BINARY LOGS"
# 恢复演练（务必定期做！）：
#   xtrabackup --prepare --target-dir=/backup/full_2026-08-14
#   systemctl stop mysqld; rm -rf /data/mysql/data/*; \
#   xtrabackup --copy-back --target-dir=/backup/full_2026-08-14; \
#   chown -R mysql:mysql /data/mysql/data; systemctl start mysqld

# ===== 生产监控一键体检（接入告警）=====
# 命中率
mysql -uroot -p'xxx' -N -e "SHOW GLOBAL STATUS LIKE 'Innodb_buffer_pool_read%'" \
  | awk '/requests/{r=$2} /reads/{s=$2} END{printf \"buffer_hit_rate=%.4f\n\", 1-s/r}'
# 连接数 / 慢查询量 / 主从延迟
mysql -uroot -p'xxx' -e "SHOW GLOBAL STATUS LIKE 'Threads_connected';"
mysql -uroot -p'xxx' -e "SHOW GLOBAL STATUS LIKE 'Slow_queries';"
# 主从：mysql -uroot -p'xxx' -e "SHOW SLAVE STATUS\G"  # 看 Seconds_Behind_Master
```

> 跑完以上 6 个阶段，你已亲手实践了全书 22 章的核心知识点。哪里现象和预期不符，回对应章节的"本质/原理"部分查证即可。

> 第0~22 章实战均已落盘，文档同时具备"理论四段式 + 每章实战小节 + 从零开始一套命令"三层结构，可直接照做。

