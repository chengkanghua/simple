# Redis 实战笔记

> 通俗易懂的 Redis 实战手册：从安装部署、五大数据类型到持久化、主从复制、Sentinel 高可用、Cluster 集群，理论精简，命令可直接复制运行。

## Redis 简介

**一句话：Redis 是开源的、基于内存的 Key-Value 数据库（NoSQL），C 语言编写，读写极快、数据类型丰富，是当下最流行的缓存中间件。**

核心特点：
- 高速读写：基于内存，单机 QPS 可达 10 万+
- 数据类型丰富：String / Hash / List / Set / ZSet
- 支持持久化：内存数据可落盘（RDB/AOF），重启不丢
- 支持高可用、分布式集群：主从复制、Sentinel、Cluster
- 企业中常用"单机多实例"架构：一台机器跑多个 Redis 实例

**软件获取与帮助：**

| 用途 | 地址 |
| :--- | :--- |
| 官方网站 | https://redis.io/ |
| 下载网站 | http://download.redis.io/releases/ |
| 帮助文档 | http://redisdoc.com/ |


## Redis 安装部署
```
 
# 安装依赖包
 yum install -y ncurses-devel libaio-devel cmake  gcc-c++ 
 #yum -y install gcc automake autoconf libtool make

#下载
wget http://download.redis.io/releases/redis-3.2.12.tar.gz
#解压
tar xf redis-3.2.12.tar.gz
#移动到指定目录
mv redis-3.2.12 /application/
#做软链接
ln -s /application/redis-3.2.12 /application/redis
#进入redis目录
cd /application/redis
#编译
make

#解决“jemalloc/jemalloc.h：没有那个文件或目录“问题，在进行编译（因为上次编译失败，有残留的文件）
#[root@bogon redis-3.2.0]# make distclean
#[root@bogon redis-3.2.0]# make && make install

#添加环境变量
echo 'export PATH="/application/redis/src:$PATH"' > /etc/profile.d/redis.sh
source /etc/profile

#启动redis
src/redis-server &
#连接redis
#redis-cli
#退出redis
#127.0.0.1:6379> quit
#关闭redis服务
# redis-cli
127.0.0.1:6379> shutdown


# 基本配置
#创建redis工作目录
mkdir -p /etc/redis/6379
#创建redis配置文件
cat > /etc/redis/6379/redis.conf <<EOF
daemonize yes
port 6379
logfile /etc/redis/6379/redis.log
dir /etc/redis/6379
dbfilename dump.rdb
#指定ip地址监听
bind 127.0.0.1 10.0.0.4
#认证密码
requirepass ckh
EOF

#指定配置文件启动redis
redis-server /etc/redis/6379/redis.conf

#redis-cli
127.0.0.1:6379> auth ckh    #认证密码
OK 
127.0.0.1:6379> set foo bar #设置键值对
OK
127.0.0.1:6379> get foo     #取出值
"bar"

```

## Redis 安全配置

| 配置项 | 作用 |
| :--- | :--- |
| `protected-mode yes/no` | 保护模式：`yes` 仅允许本机访问，生产环境建议开启 |
| `bind IP` | 指定允许监听的 IP |
| `requirepass 密码` | 设置连接密码 |
| `AUTH 密码` | 在 redis-cli 中手动认证 |
```
#添加到配置文件
[root@db01 redis]# vim /etc/redis/6379/redis.conf
bind 127.0.0.1 10.0.0.51
requirepass  ckh

#不加认证，报错
[root@db01 redis]# redis-cli
127.0.0.1:6379> set name zhangsan
(error) NOAUTH Authentication required.
#连接方式1
[root@db01 redis]# redis-cli
127.0.0.1:6379> AUTH ckh
127.0.0.1:6379> set name zhangsan
OK
#连接方式2
[root@db01 redis]# redis-cli -a ckh
127.0.0.1:6379> set name lisi
OK

```
**在线查看/修改配置（无需重启，动态生效）：**
```
#查看配置文件中的监听地址
127.0.0.1:6379> CONFIG GET bind
#查看dir
127.0.0.1:6379> CONFIG GET dir
#查看所有配置
127.0.0.1:6379> CONFIG GET *
#修改配置，即时生效 没有修改配置文件,重启redis后失效
127.0.0.1:6379> CONFIG SET requirepass 123
#测试修改后连接
[root@db01 redis]# redis-cli -a 123
#查看配置文件
[root@db01 redis]# cat /etc/redis/6379/redis.conf

```
## Redis 持久化

**什么是持久化？** 把内存中的数据保存到磁盘上，防止重启/宕机后数据丢失。

**两种持久化方式：**

| 方式 | 原理 | 优点 | 缺点 |
| :--- | :--- | :--- | :--- |
| RDB（快照） | 按时间间隔给整个数据集拍一张"快照"存盘 | 速度快、文件小，适合备份；主从复制基于它 | 两次快照之间的数据可能丢失 |
| AOF（日志） | 把每条写命令追加记录到文件，启动时重放命令还原数据 | 数据最安全、丢失最少 | 日志文件大、恢复慢 |


RDB持久化核心配置参数
```
#编辑配置文件
[root@db01 redis]# vim /etc/redis/6379/redis.conf
#持久化数据文件存储位置
dir /etc/redis/6379
#rdb持久化数据文件名
dbfilename dump.rdb
#900秒（15分钟）内有1个更改
save 900 1
#300秒（5分钟）内有10个更改
save 300 10
#60秒（1分钟）内有10000个更改
save 60 10000

#RDB持久化高级配置
#编辑配置文件
[root@db01 redis]# vim /etc/redis/6379/redis.conf
#后台备份进程出错时,主进程停不停止写入? 主进程不停止容易造成数据不一致
stop-writes-on-bgsave-error yes
#导出的rdb文件是否压缩 如果rdb的大小很大的话建议这么做
rdbcompression yes 
#导入rbd恢复时数据时,要不要检验rdb的完整性 验证版本是不是一致
rdbchecksum yes

```
AOF持久化核心配置参数
```
#修改配置文件
[root@db01 redis]# vim /etc/redis/6379/redis.conf
#是否打开AOF日志功能
appendonly yes/no
#每一条命令都立即同步到AOF
appendfsync always
#每秒写一次
appendfsync everysec
#写入工作交给操作系统,由操作系统判断缓冲区大小,统一写入到AOF
appendfsync no

#AOF持久化高级配置
#编辑配置文件
[root@db01 redis]# vim /etc/redis/6379/redis.conf
#正在导出rdb快照的过程中,要不要停止同步aof
no-appendfsync-on-rewrite yes/no
#aof文件大小比起上次重写时的大小,增长率100%时重写,缺点:业务开始的时候，会重复重写多次
auto-aof-rewrite-percentage 100
#aof文件,至少超过64M时,重写
auto-aof-rewrite-min-size 64mb
```

**面试高频：Redis 持久化方式有哪些？有什么区别？**
- **RDB**：基于快照，速度快、文件小，适合备份；主从复制依赖它。
- **AOF**：以追加方式记录操作日志，数据最安全，相当于 MySQL 的 binlog。


### 数据类型

**结构理解：Redis 是"键值对"存储，key 是自己起的名字，value 可选多种数据类型。**

| 类型 | key | value 示例 |
| :--- | :--- | :--- |
| String（字符串） | name | "zhangsan" |
| Hash（字典） | stu | {id:101, name:zhangsan} |
| List（列表） | wechat | [v1, v2, v3] |
| Set（集合，无序去重） | set1 | {0, 1, 2} |
| ZSet（有序集合） | zset1 | [score1→m1, score2→m2, score3→m3] |
### 应用场景

| 类型 | 典型应用场景 |
| :--- | :--- |
| String | 计数：微博粉丝数、浏览量、点击量、游戏血量/蓝量等 |
| Hash | 最接近 MySQL 表结构：用户信息、商品信息等部分字段会变更的数据 |
| List | 消息队列、最新消息列表（如微博最新 ID 缓存、朋友圈） |
| Set | 社交关系：关注/粉丝集合，配合交集、并集、差集实现“共同关注、二度好友” |
| ZSet | 排行榜 TOP N：以 score 为权重排序，一条 ZADD 即可实现 |

### 数据类型基本操作

**通用操作（所有类型通用）：**
```
#查看所有的key
127.0.0.1:6379> KEYS *
#判断key是否存在
127.0.0.1:6379> EXISTS name
#变更key名
127.0.0.1:6379> RENAME age nianling
127.0.0.1:6379> type name
#删除key
127.0.0.1:6379> del name
#以秒为单位设置生存时间
127.0.0.1:6379> EXPIRE name 10
#以毫秒为单位设置生存时间
127.0.0.1:6379> PEXPIRE name 10000
#取消剩余生存时间
127.0.0.1:6379> PERSIST name

```
string
```
基本操作：
127.0.0.1:6379> set name zhangsan 
OK
127.0.0.1:6379> get name
"zhangsan"
127.0.0.1:6379> mset id 101 name zhangsan age 20 gender male 
OK
127.0.0.1:6379> mget id name age gender

计数器应用

127.0.0.1:6379> incr fensi
127.0.0.1:6379> DECR fensi
127.0.0.1:6379> INCRBY fensi 10000
127.0.0.1:6379> DECRBY fensi 10003

127.0.0.1:6379> get fensi
```

hash
```
127.0.0.1:6379> hset zhangsan name zs
(integer) 1
127.0.0.1:6379> hmset student id 101 name zs age 20 gender male
OK
127.0.0.1:6379> hmset stu id 102 name lisi age 21 gender male
OK
127.0.0.1:6379> hmget stu id name age gender
1) "102"
2) "lisi"
3) "21"
4) "male"
127.0.0.1:6379> hgetall stu
1) "id"
2) "102"
3) "name"
4) "lisi"
5) "age"
6) "21"
7) "gender"
8) "male"

小扩展：
MySQL 中 city表中前10行数据，灌入到redis中

MySQL:
		id        name      age    gender 
		101       zhangsan  20      male
		
hmset zhangsan_stu  id 101 name zhangsan  age 20 gender male


思路：
mysql> desc t1;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int(11)     | YES  |     | NULL    |       |
| name  | varchar(20) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.00 sec)

mysql> select concat("hmset stu_",name," id ",id," name ",name) from t1;
+---------------------------------------------------+
| concat("hmset stu_",name," id ",id," name ",name) |
+---------------------------------------------------+
| hmset stu_zhang3 id 1 name zhang3                 |
| hmset stu_li4 id 2 name li4                       |
| hmset stu_wang5 id 3 name wang5                   |
+---------------------------------------------------+
```

list
```
例子：微信朋友圈应用
127.0.0.1:6379> LPUSH wechat "today is 1"
(integer) 1
127.0.0.1:6379> LPUSH wechat "today is 2"
(integer) 2
127.0.0.1:6379> LPUSH wechat "today is 3"
(integer) 3
127.0.0.1:6379> LPUSH wechat "today is 4"
(integer) 4
127.0.0.1:6379> LPUSH wechat "today is 5"

127.0.0.1:6379> LRANGE wechat 0 -1
1) "today is 5"
2) "today is 4"
3) "today is 3"
4) "today is 2"
5) "today is 1"
127.0.0.1:6379> 

```
set
```
#若key不存在,创建该键及与其关联的set,依次插入
#若key存在,则插入value中,value中存在的不插入
127.0.0.1:6379> sadd lxl pg1 pg2 baoqiang masu marong 
(integer) 5
127.0.0.1:6379> sadd jnl baoqiang yufan baobeier zhouxingchi 
(integer) 4
# 取并集: 两个人的好友都列出来
127.0.0.1:6379> SUNION lxl jnl 
1) "zhouxingchi"
2) "baobeier"
3) "pg2"
4) "yufan"
5) "masu"
6) "baoqiang"
7) "pg1"
8) "marong"
127.0.0.1:6379>
# 取交集: 共同好友
127.0.0.1:6379> SINTER lxl jnl
1) "baoqiang"
# lxl 和jnl比较获得独有的值
127.0.0.1:6379> SDIFF lxl jnl
1) "masu"
2) "pg1"
3) "marong"
4) "pg2"
# 取差集: jnl有的好友,lxl没有的好友
127.0.0.1:6379> SDIFF jnl lxl
1) "yufan"
2) "zhouxingchi"
3) "baobeier"
# 取差集: lxl有的好友,jnl没有的好友
127.0.0.1:6379> sdiff lxl jnl
1) "marong"
2) "pg2"
3) "pg1"
4) "masu"

```
sorted-set (有序)
```
#增
#添加两个分数分别是 2 和 3 的两个成员
127.0.0.1:6379> zadd myzset 2 "two" 3 "three"
#删
#删除多个成员变量,返回删除的数量
127.0.0.1:6379> zrem myzset one two
#改
#将成员 one 的分数增加 2，并返回该成员更新后的分数
127.0.0.1:6379> zincrby myzset 2 one
#查
#返回所有成员和分数,不加WITHSCORES,只返回成员
127.0.0.1:6379> zrange myzset 0 -1 WITHSCORES
1) "one"
2) "2"
3) "three"
4) "3"
#获取成员one在Sorted-Set中的位置索引值。0表示第一个位置
127.0.0.1:6379> zrank myzset one
(integer) 0
#获取 myzset 键中成员的数量
127.0.0.1:6379> zcard myzset
(integer) 2
#获取分数满足表达式 1 <= score <= 2 的成员的数量
127.0.0.1:6379> zcount myzset 1 2
(integer) 1  
#获取成员 three 的分数 
127.0.0.1:6379> zscore myzset three
"3"
#获取分数满足表达式 1 < score <= 2 的成员
127.0.0.1:6379> zrangebyscore myzset  1 2
1) "one"
#-inf 表示第一个成员，+inf最后一个成员
#limit限制关键字
#2  3  是索引号
zrangebyscore myzset -inf +inf limit 2 3  返回索引是2和3的成员
#删除分数 1<= score <= 2 的成员，并返回实际删除的数量
127.0.0.1:6379> zremrangebyscore myzset 1 2
(integer) 1
#删除位置索引满足表达式 0 <= rank <= 1 的成员
127.0.0.1:6379> zremrangebyrank myzset 0 1
(integer) 1
#按位置索引从高到低,获取所有成员和分数
127.0.0.1:6379> zrevrange myzset 0 -1 WITHSCORES
#原始成员:位置索引从小到大
      one  0
      two  1
#执行顺序:把索引反转
      位置索引:从大到小
      one 1
      two 0
#输出结果: 
       two
       one
#获取位置索引,为1,2,3的成员
127.0.0.1:6379> zrevrange myzset 1 3
(empty list or set)
#相反的顺序:从高到低的顺序
#获取分数 3>=score>=0的成员并以相反的顺序输出
127.0.0.1:6379> zrevrangebyscore myzset 3 0
(empty list or set)
#获取索引是1和2的成员,并反转位置索引
127.0.0.1:6379> zrevrangebyscore myzset 4 0 limit 1 2
(empty list or set)


```

## Redis 消息队列

> 生产-消费模型：生产者把消息放进队列就返回，消费者从队列取消息，两边互不关心。

```txt
              ┌──────────┐                          ┌──────────┐
   🏠 ──────► │          │                          │          │ ◄────── 🛒
              │          │                          │          │
   🏠 ──────► │  生产者   │   🌐    ╔════════════╗    │  消费者   │ ◄────── 🛒
              │          │  ────►  ║            ║ ──►│          │
   🏠 ──────► │ Producers │         ║  消息队列   ║    │ Consumers │ ◄────── 🛒
              │          │         ║  Message    ║    │          │
              │          │         ║  Queue      ║    │          │
              └──────────┘         ╚════════════╝    └──────────┘


```

![image-20230101194527548](redis.assets/image-20230101194527548.png)

**什么是消息队列？** 类似“工厂（生产者）→ 超市（队列）→ 顾客（消费者）”：生产者只管把消息发到 MQ 就返回，消费者只管取消息，双方不需要知道对方存在，由 MQ 保证消息可靠传递。

**为什么要用消息队列？**
- **异步**：如订单系统下单后要扣库存、发短信、记日志，把不紧急的放进队列慢慢做，主流程不用等；
- **解耦**：生产者和消费者互不影响，一方挂了另一方照常运行；
- **削峰**：秒杀等突发流量先入队，系统按自身节奏消费，避免被冲垮；
- **最终一致**：各系统按队列顺序处理，最终数据一致。

**常见消息队列产品：**

| 产品 | 说明 |
| :--- | :--- |
| RabbitMQ | 起源于金融系统，功能完善（OpenStack 使用） |
| ZeroMQ | 轻量级消息库（SaltStack 使用） |
| Kafka | 高吞吐、日志型，大数据标配（Java） |
| Redis | 缓存 + 消息队列，简单易用，适合轻量场景 |


## Redis 发布消息的两种模式

**1. 任务队列模式（Queue）**
任务队列就是“传递任务的队列”：生产者把任务放进去，消费者不断取出执行。好处：① 松耦合，双方只需按约定格式写代码；② 易扩展，多消费者可分布在多台服务器，降低单机负载。

**2. 发布-订阅模式（Pub/Sub）**
更像广播系统：发布者（电台）往频道发消息，订阅者（收音机）按频道接收。

| 模型 | 应用场景 |
| :--- | :--- |
| 1 发布者 → 多订阅者 | 通知、公告 |
| 多发布者 → 1 订阅者 | 排行榜、投票、计数（各程序发消息，统一收口处理） |
| 多发布者 → 多订阅者 | 群聊、聊天室 |


## Redis 发布订阅实践

**常用命令：**

| 命令 | 作用 |
| :--- | :--- |
| `PUBLISH channel msg` | 向指定频道发送消息 |
| `SUBSCRIBE channel ...` | 订阅一个或多个频道 |
| `UNSUBSCRIBE [channel ...]` | 取消订阅（不带参数则取消全部） |
| `PSUBSCRIBE pattern ...` | 按模式订阅，`*` 为通配符（如 `it*` 匹配所有 it 开头的频道） |
| `PUNSUBSCRIBE [pattern ...]` | 按模式退订 |
| `PUBSUB subcommand ...` | 查看订阅/发布系统状态 |


**订阅单个频道**
```
#第一个窗口
#登录Redis
[root@db01 ~]# redis-cli -a ckh
#在订阅者的服务器上输入订阅zls
127.0.0.1:6379> SUBSCRIBE zls
Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "zls"
3) (integer) 1
#第二个窗口
#登录Redis
[root@db01 ~]# redis-cli -a ckh
#在发布者的服务器上输入信息
127.0.0.1:6379> PUBLISH zls "The Nice Boy Like Me."
(integer) 1
#第一个窗口
#在订阅者的服务器上会看到如下信息
1) "message"
2) "zls"
3) "The Nice Boy Like Me."
```

**订阅多个频道**
```
#第一个窗口
#登录Redis
[root@db01 ~]# redis-cli -a ckh
#在订阅者服务器上输入订阅所有频道
127.0.0.1:6379> PSUBSCRIBE *
Reading messages... (press Ctrl-C to quit)
1) "psubscribe"
2) "*"
3) (integer) 1
#第二个窗口
#在发布者服务器上输入多频道信息
127.0.0.1:6379> PUBLISH zls "The Nice Boy Like Me."
(integer) 1
127.0.0.1:6379> PUBLISH bgx "The Ugly Old Man Like Me."
(integer) 1
#第一个窗口
#在订阅者的服务器上会看到如下信息
1) "pmessage"
2) "*"
3) "zls"
4) "The Nice Boy Like Me."
1) "pmessage"
2) "*"
3) "bgx"
4) "The Ugly Old Man Like Me."
```
**Redis 发布订阅 vs 专业 MQ：**
- 客户端订阅后只能执行订阅/退订四类命令；Redis 不持久化消息，订阅者收不到订阅之前的消息；
- 相比 Kafka / RocketMQ / RabbitMQ，Redis 无法实现消息堆积和回溯；
- 但胜在简单，能容忍这些缺点的小场景完全可用。

## Redis 事务、锁及管理命令

**Redis 事务 vs MySQL 事务：**
- MySQL 事务有 ACID 四大特性（原子性 A / 一致性 C / 隔离性 I / 持久性 D），并靠 MVCC 实现隔离；
- Redis 事务把多条命令放进队列，`EXEC` 时一次性执行，但**不保证回滚**：
  - 命令语法错误 → 直接取消整个队列，什么都不执行；
  - 命令执行中出错 → 其他命令照常执行，不回滚（Redis 命令简单、出错概率低，故如此设计）。

**Redis 事务命令：**

| 命令 | 作用 |
| :--- | :--- |
| `MULTI` | 开启事务（相当于 MySQL 的 begin） |
| `EXEC` | 提交事务，执行队列中所有命令（相当于 commit） |
| `DISCARD` | 取消事务（不是回滚，是队列命令根本没执行） |
| `WATCH key ...` | 监视 key，事务执行前被其他客户端改动则事务作废（乐观锁） |
| `UNWATCH` | 取消所有 key 的监视 |

**MySQL 与 Redis 事务对比：**

| 步骤 | MySQL | Redis |
| :--- | :--- | :--- |
| 开启 | `BEGIN` / `START TRANSACTION` | `MULTI` |
| 执行 | 普通 SQL | 普通命令（先进队列） |
| 失败 | `ROLLBACK` 回滚 | `DISCARD` 取消（命令未执行，非回滚） |
| 成功 | `COMMIT` | `EXEC` |


**事务测试**
```
#登录redis
[root@db01 ~]# redis-cli
#验证密码
127.0.0.1:6379> auth 123
OK
#不开启事务直接设置key
127.0.0.1:6379> set zls "Nice"
OK
#查看结果
127.0.0.1:6379> get zls
"Nice"
#开启事务
127.0.0.1:6379> MULTI
OK
#设置一个key
127.0.0.1:6379> set bgx "low"
QUEUED
127.0.0.1:6379> set alex "Ugly"
QUEUED
#开启另一个窗口查看结果
127.0.0.1:6379> get bgx
(nil)
127.0.0.1:6379> get alex
(nil)
#执行exec完成事务
127.0.0.1:6379> EXEC
1) OK
2) OK
#再次查看结果
127.0.0.1:6379> get bgx
"low"
127.0.0.1:6379> get alex
"Ugly"
```

## Redis 乐观锁

**场景：** 买票，票只有 1 张（ticket=1）。如果我在 `MULTI` 之后、`EXEC` 之前，票被别人买走了（ticket=0），我如何发现并停止提交？

**悲观锁 vs 乐观锁：**
- **悲观锁**：认为一定有人抢，直接给 ticket 上锁，只有我能操作；
- **乐观锁**：认为没多少人抢，只需盯住“ticket 的值有没有被改过”。
- **Redis 事务用的是乐观锁**：通过 `WATCH` 监视 key，`EXEC` 前若被改动，事务直接作废。

**一句话总结：** 乐观锁 = 不上锁，谁先付款票归谁；悲观锁 = 先锁住，别人都抢不了。

**乐观锁实现**
模拟买票两个窗口实现
```
#首先在第一个窗口设置一个key（ticket 1）
127.0.0.1:6379> set ticket 1
OK
#设置完票的数量之后观察这个票
127.0.0.1:6379> WATCH ticket
OK
#开启事务
127.0.0.1:6379> MULTI
OK
#买了票所以ticket设置为0
127.0.0.1:6379> set ticket 0
QUEUED
#然后在第二个窗口观察票
127.0.0.1:6379> WATCH ticket
OK
#开启事务
127.0.0.1:6379> MULTI
OK
#同样设置ticket为0
127.0.0.1:6379> set ticket 0
QUEUED
#此时如果谁先付款，也就是执行了exec另外一个窗口就操作不了这张票了
#在第二个窗口先付款（执行exec）
127.0.0.1:6379> exec
1) OK
#然后在第一个窗口再执行exec
127.0.0.1:6379> exec
(nil)       //无，也就是说我们无法对这张票进行操作
```

## Redis 管理命令

**info（查看运行信息：Server / Clients / Memory / Persistence / Replication / CPU 等 9 大块）**
```
#查看redis相关信息
127.0.0.1:6379> info
#服务端信息
# Server
#版本号
redis_version:3.2.12
#redis版本控制安全hash算法
redis_git_sha1:00000000
#redis版本控制脏数据
redis_git_dirty:0
#redis建立id
redis_build_id:3b947b91b7c31389
#运行模式：单机（如果是集群：cluster）
redis_mode:standalone
#redis所在宿主机的操作系统
os:Linux 2.6.32-431.el6.x86_64 x86_64
#架构（64位）
arch_bits:64
#redis事件循环机制
multiplexing_api:epoll
#GCC的版本
gcc_version:4.4.7
#redis进程的pid
process_id:33007
#redis服务器的随机标识符(用于sentinel和集群)
run_id:46b07234cf763cab04d1b31433b94e31b68c6e26
#redis的端口
tcp_port:6379
#redis服务器的运行时间（单位秒）
uptime_in_seconds:318283
#redis服务器的运行时间（单位天）
uptime_in_days:3
#redis内部调度（进行关闭timeout的客户端，删除过期key等等）频率，程序规定serverCron每秒运行10次
hz:10
#自增的时钟，用于LRU管理,该时钟100ms(hz=10,因此每1000ms/10=100ms执行一次定时任务)更新一次
lru_clock:13601047
#服务端运行命令路径
executable:/application/redis-3.2.12/redis-server
#配置文件路径
config_file:/etc/redis/6379/redis.conf
#客户端信息
# Clients
#已连接客户端的数量(不包括通过slave的数量)
connected_clients:2
##当前连接的客户端当中，最长的输出列表，用client list命令观察omem字段最大值
client_longest_output_list:0
#当前连接的客户端当中，最大输入缓存，用client list命令观察qbuf和qbuf-free两个字段最大值
client_biggest_input_buf:0
#正在等待阻塞命令(BLPOP、BRPOP、BRPOPLPUSH)的客户端的数量
blocked_clients:0
#内存信息
# Memory
#由redis分配器分配的内存总量，以字节为单位
used_memory:845336
#以人类可读的格式返回redis分配的内存总量
used_memory_human:825.52K
#从操作系统的角度，返回redis已分配的内存总量(俗称常驻集大小)。这个值和top命令的输出一致
used_memory_rss:1654784
#以人类可读方式，返回redis已分配的内存总量
used_memory_rss_human:1.58M
#redis的内存消耗峰值(以字节为单位)
used_memory_peak:845336
#以人类可读的格式返回redis的内存消耗峰值
used_memory_peak_human:825.52K
#整个系统内存
total_system_memory:1028517888
#以人类可读的格式，显示整个系统内存
total_system_memory_human:980.87M
#Lua脚本存储占用的内存
used_memory_lua:37888
#以人类可读的格式，显示Lua脚本存储占用的内存
used_memory_lua_human:37.00K
#Redis实例的最大内存配置
maxmemory:0
#以人类可读的格式，显示Redis实例的最大内存配置
maxmemory_human:0B
#当达到maxmemory时的淘汰策略
maxmemory_policy:noeviction
#内存分裂比例（used_memory_rss/ used_memory）
mem_fragmentation_ratio:1.96
#内存分配器
mem_allocator:jemalloc-4.0.3
#持久化信息
# Persistence
#服务器是否正在载入持久化文件
loading:0
#离最近一次成功生成rdb文件，写入命令的个数，即有多少个写入命令没有持久化
rdb_changes_since_last_save:131
#服务器是否正在创建rdb文件
rdb_bgsave_in_progress:0
#最近一次rdb持久化保存时间
rdb_last_save_time:1540009420
#最近一次rdb持久化是否成功
rdb_last_bgsave_status:ok
#最近一次成功生成rdb文件耗时秒数
rdb_last_bgsave_time_sec:-1
#如果服务器正在创建rdb文件，那么这个域记录的就是当前的创建操作已经耗费的秒数
rdb_current_bgsave_time_sec:-1
#是否开启了aof
aof_enabled:0
#标识aof的rewrite操作是否在进行中
aof_rewrite_in_progress:0
#rewrite任务计划，当客户端发送bgrewriteaof指令，如果当前rewrite子进程正在执行，那么将客户端请求的bgrewriteaof变为计划任务，待aof子进程结束后执行rewrite
aof_rewrite_scheduled:0
#最近一次aof rewrite耗费的时长
aof_last_rewrite_time_sec:-1
#如果rewrite操作正在进行，则记录所使用的时间，单位秒
aof_current_rewrite_time_sec:-1
#上次bgrewriteaof操作的状态
aof_last_bgrewrite_status:ok
#上次aof写入状态
aof_last_write_status:ok
#统计信息
# Stats
#新创建连接个数,如果新创建连接过多，过度地创建和销毁连接对性能有影响，说明短连接严重或连接池使用有问题，需调研代码的连接设置
total_connections_received:19
#redis处理的命令数
total_commands_processed:299
#redis当前的qps，redis内部较实时的每秒执行的命令数
instantaneous_ops_per_sec:0
#redis网络入口流量字节数
total_net_input_bytes:10773
#redis网络出口流量字节数
total_net_output_bytes:97146
#redis网络入口kps
instantaneous_input_kbps:0.00
#redis网络出口kps
instantaneous_output_kbps:0.00
#拒绝的连接个数，redis连接个数达到maxclients限制，拒绝新连接的个数
rejected_connections:0
#主从完全同步次数
sync_full:0
#主从完全同步成功次数
sync_partial_ok:0
#主从完全同步失败次数
sync_partial_err:0
#运行以来过期的key的数量
expired_keys:5
#过期的比率
evicted_keys:0
#命中次数
keyspace_hits:85
#没命中次数
keyspace_misses:17
#当前使用中的频道数量
pubsub_channels:0
#当前使用的模式的数量
pubsub_patterns:0
#最近一次fork操作阻塞redis进程的耗时数，单位微秒
latest_fork_usec:0
#是否已经缓存了到该地址的连接
migrate_cached_sockets:0
#主从复制信息
# Replication
#角色主库
role:master
#连接slave的个数
connected_slaves:0
#主从同步偏移量,此值如果和上面的offset相同说明主从一致没延迟，与master_replid可被用来标识主实例复制流中的位置
master_repl_offset:0
#复制积压缓冲区是否开启
repl_backlog_active:0
#复制积压缓冲大小
repl_backlog_size:1048576
#复制缓冲区里偏移量的大小
repl_backlog_first_byte_offset:0
#此值等于 master_repl_offset - repl_backlog_first_byte_offset,该值不会超过repl_backlog_size的大小
repl_backlog_histlen:0
#CPU信息
# CPU
#将所有redis主进程在内核态所占用的CPU时求和累计起来
used_cpu_sys:203.44
#将所有redis主进程在用户态所占用的CPU时求和累计起来
used_cpu_user:114.57
#将后台进程在内核态所占用的CPU时求和累计起来
used_cpu_sys_children:0.00
#将后台进程在用户态所占用的CPU时求和累计起来
used_cpu_user_children:0.00
#集群信息
# Cluster
#实例是否启用集群模式
cluster_enabled:0
#库相关统计信息
# Keyspace
#db0的key的数量,以及带有生存期的key的数,平均存活时间
db0:keys=17,expires=0,avg_ttl=0
#单独查看某一个信息（例：查看CPU信息）
127.0.0.1:6379> info cpu
# CPU
used_cpu_sys:203.45
used_cpu_user:114.58
used_cpu_sys_children:0.00
used_cpu_user_children:0.00

```

**client**
```
#查看客户端连接信息（有几个会话就会看到几条信息）
127.0.0.1:6379> CLIENT LIST
id=19 addr=127.0.0.1:35687 fd=6 name= age=30474 idle=8962 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=0 obl=0 oll=0 omem=0 events=r cmd=info
id=21 addr=127.0.0.1:35689 fd=7 name= age=3 idle=0 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=32768 obl=0 oll=0 omem=0 events=r cmd=client
#杀掉某一个会话
127.0.0.1:6379> CLIENT KILL 127.0.0.1:35687
```

**config**
```
#重置统计状态信息
127.0.0.1:6379> CONFIG RESETSTAT
#查看所有配置信息
127.0.0.1:6379> CONFIG GET *
#查看某个配置信息
127.0.0.1:6379> CONFIG GET maxmemory
1) "maxmemory"
2) "0"
#动态修改配置信息
127.0.0.1:6379> CONFIG SET maxmemory 60G
OK
#再次查看修改后的配置信息
127.0.0.1:6379> CONFIG GET maxmemory
1) "maxmemory"
2) "60000000000"
```

**dbsize（查看当前库 key 数量）**
```
#查看当前库内有多少个key
127.0.0.1:6379> DBSIZE
(integer) 17
#验证key的数量
127.0.0.1:6379> KEYS *
 1) "lidao_fans"
 2) "ticket"
 3) "myhash"
 4) "teacher1"
 5) "name"
 6) "zls_fans"
 7) "bgx_fans"
 8) "mykey"
 9) "bgx"
10) "diffkey"
11) "alex"
12) "KEY"
13) "teacher"
14) "key3"
15) "unionkey"
16) "zls"
17) "wechat"
```
**select（切换库）**
Redis 默认有 16 个库（0~15），不需要手动创建，默认在 0 库操作。类似 MySQL 的 `USE dbname`，用 `SELECT n` 切换，**各库之间数据隔离**。
```
#在0库中创建一个key
127.0.0.1:6379> set name zls
OK
#查看0库中的所有key
127.0.0.1:6379> KEYS *
1) "name"
#进1库中
127.0.0.1:6379> SELECT 1
OK
#查看所有key
127.0.0.1:6379[1]> KEYS *
(empty list or set)         //由此可见，每个库之间都是隔离的
```

**flushdb / flushall（清库）**
```
#删库跑路专用命令（删除所有库）
127.0.0.1:6379> FLUSHALL
OK
#验证一下是否真的删库了
127.0.0.1:6379> DBSIZE
(integer) 0
127.0.0.1:6379> KEYS *
(empty list or set)
#删除单个库中数据
127.0.0.1:6379> FLUSHDB
OK
```

**MONITOR（实时监控命令）**
开启两个窗口：一个窗口执行 MONITOR，另一个窗口执行的命令会被实时显示出来。
```
#在第一个窗口开启监控
127.0.0.1:6379> MONITOR
OK
#在第二个窗口输入命令
127.0.0.1:6379> SELECT 2
OK
127.0.0.1:6379[2]> set name bgx
OK
127.0.0.1:6379[2]> info
#在第一个窗口会实时显示执行的命令
127.0.0.1:6379> MONITOR
OK
1540392396.690268 [0 127.0.0.1:35689] "SELECT" "2"
1540392409.883011 [2 127.0.0.1:35689] "set" "name" "bgx"
1540392543.892889 [2 127.0.0.1:35689] "info"
```
**shutdown（关闭 Redis）**
```
#关闭Redis服务
127.0.0.1:6379> SHUTDOWN
not connected>
```

## Redis 主从复制

**核心概念：**
- 主从复制 = 主库写、从库同步复制，实现**读写分离 + 数据冗余**，是高可用的基础；
- 一个主服务器可以有多个从服务器，从服务器也可以有自己的从服务器（图状结构）；
- 复制**异步**进行，不会阻塞主服务器；从服务器同步期间可用旧数据继续服务查询。

**复制流程（全量同步）：**

```txt
+--------------------+                              +--------------------+
|                    |                              |                    |
|                    | ──────► ① 发送SYNC命令 ────► |                    |
|                    |                              |                    |
|                    | ◄────── ② 发送RDB文件 ◄──── |                    |
|     从 服 务 器     |                              |     主 服 务 器     |
|       Slave        |                              |       Master       |
|                    |                              |                    |
|                    | ◄─── ③ 发送缓冲区保存的 ◄─── |                    |
|                    |         所有写命令            |                    |
|                    |                              |                    |
+--------------------+                              +--------------------+


```

1. 从服务器向主服务器发送 `SYNC`（老版本）或 `PSYNC` 命令；
2. 主服务器执行 `BGSAVE` 生成 RDB 快照，并把期间的写命令记入缓冲区；
3. 主服务器把 RDB 发给从服务器，从服务器载入；
4. 主服务器把缓冲区的写命令发给从服务器执行。

**命令传播：** 同步完成后，主服务器每执行一个写命令都会实时转发给从服务器执行，保证主从数据一致。

**SYNC 与 PSYNC：**
- Redis 2.8 之前：断线重连后只能做一次**完整重同步**；
- 从 2.8 开始用 `PSYNC`：断线重连后，只要条件允许只同步**断线期间缺失的部分数据**（部分重同步），不用全量同步。原理：主服务器维护复制流缓冲区，主从各自记录复制偏移量 + 主服务器 ID。

**一致性问题（重点）：**
- 主从是异步复制，客户端“读从库”可能读到旧数据（写命令还没同步过来）；
- 解决：通过 `min-slaves-to-write` + `min-slaves-max-lag` 两个参数，主服务器只在“有足够多、延迟足够低”的从库时才执行写操作，把数据丢失窗口限制在指定秒数内。


```
#执行写操作所需的至少从服务器数量
min-slaves-to-write <number of slaves>
#指定网络延迟的最大值
min-slaves-max-lag <number of seconds>
```
**工作原理：** 从服务器每秒 PING 主服务器一次并上报延迟。只有“从服务器数量 ≥ `min-slaves-to-write` 且延迟都 < `min-slaves-max-lag` 秒”时，主服务器才执行写操作；否则拒绝并报错。相当于放宽版的强一致——数据不保证一定不丢，但丢失窗口被严格限制。

**主从复制实现**

```
1、环境：
准备两个或两个以上redis实例

mkdir /data/638{0..2}

#配置文件示例：
cat > /data/6380/redis.conf<<EOF
port 6380
daemonize yes
pidfile /data/6380/redis.pid
loglevel notice
logfile "/data/6380/redis.log"
dbfilename dump.rdb
dir /data/6380
protected-mode no
EOF

cat > /data/6381/redis.conf<<EOF
port 6381
daemonize yes
pidfile /data/6381/redis.pid
loglevel notice
logfile "/data/6381/redis.log"
dbfilename dump.rdb
dir /data/6381
protected-mode no
EOF

cat > /data/6382/redis.conf<<EOF
port 6382
daemonize yes
pidfile /data/6382/redis.pid
loglevel notice
logfile "/data/6382/redis.log"
dbfilename dump.rdb
dir /data/6382
protected-mode no
EOF

#启动：
redis-server /data/6380/redis.conf
redis-server /data/6381/redis.conf
redis-server /data/6382/redis.conf


主节点：6380
从节点：6381、6382


2、开启主从：
6381/6382命令行:

redis-cli -p 6381
SLAVEOF 127.0.0.1 6380

redis-cli -p 6382
SLAVEOF 127.0.0.1 6380


3、查询主从状态

从库：
127.0.0.1:6382> info replication

主库：
127.0.0.1:6380> info replication



主库故障模拟及切换（failover过程）：

4、从库切为主库

模拟主库故障

redis-cli -p 6380
shutdown

redis-cli -p 6381
info replication
slaveof no one  #取消从库



6382连接到6381：
[root@db03 ~]# redis-cli -p 6382
127.0.0.1:6382> SLAVEOF no one
127.0.0.1:6382> SLAVEOF 127.0.0.1 6381
```

## Redis Sentinel（哨兵）

**Sentinel 是什么？** Redis 官方推荐的高可用（HA）方案。主从复制中主库宕机后不会自动切换，Sentinel 是独立运行的“哨兵”进程，负责**监控 → 通知 → 自动故障转移**。

**三大功能：**
1. **监控**：持续检查主/从服务器是否正常；
2. **通知**：出问题时通过 API 通知管理员或应用；
3. **自动故障转移**：主库失效时，自动把某个从库升为新主库，其余从库和客户端都指向它。

**Sentinel 如何发现彼此？**
- 通过配置文件发现主服务器，并向主从服务器各建两条连接：**命令连接**（发命令）+ **订阅连接**（广播 HELLO 信息互相发现）；
- Sentinel 之间只建立命令连接（HELLO 消息通过主从服务器转发）。

**主观下线 vs 客观下线：**
- **主观下线（SDOWN）**：单个 Sentinel 判定某台服务器下线（PING 超时，默认 `down-after-milliseconds`）；
- **客观下线（ODOWN）**：多个 Sentinel 都判定其下线并互相确认后，才触发故障转移。

**故障转移流程（FAILOVER）：**
1. 确认主库客观下线；
2. 基于 Raft 协议投票选举 leader Sentinel；
3. 选出一个从库升级为新主库（执行 `SLAVEOF NO ONE`）；
4. 通过发布订阅把新配置广播给所有 Sentinel；
5. 让其余从库复制新主库；全部完成后结束本次故障转移。


**Sentinel 搭建过程**
```
mkdir /data/26380
cd /data/26380

vim sentinel.conf
port 26380
dir "/data/26380"
sentinel monitor mymaster 127.0.0.1 6380 1
sentinel down-after-milliseconds mymaster 5000

启动：
redis-sentinel /data/26380/sentinel.conf &


停主库测试：
[root@db01 ~]# redis-cli -p 6380
shutdown

[root@db01 ~]# redis-cli -p 6381
info replication

启动源主库（6380），看状态。
```
**参数说明：**
```
# 监视主服务器：名为 mymaster，地址 127.0.0.1:6379，至少 2 个 Sentinel 判定其失效才执行故障转移
# 注意：发起故障转移必须获得多数派（>半数）Sentinel 支持，只有少数派在线时不会切换
sentinel monitor mymaster 127.0.0.1 6379 2

# 判定主观下线(SDOWN)：主服务器 5 秒内没回应 PING 即标记下线
# 多个 Sentinel 都标记 SDOWN 且互相确认后，才升级为客观下线(ODOWN)，才真正触发故障转移
sentinel down-after-milliseconds mymaster 5000

# 故障转移超时时间：180 秒内没完成切换就放弃
sentinel failover-timeout mymaster 180000

# 故障转移后，最多 1 个从服务器同时向新主库同步数据
# 值越小越稳（从库加载 RDB 时短暂无法服务），值越大切换越快
sentinel parallel-syncs mymaster 1
```

**Sentinel 管理命令（不常用）**
```
#连接sentinel管理端口
[root@db01 26380]# redis-cli -p 26380
#检测状态，返回PONG
127.0.0.1:26380> PING
PONG
#列出所有被监视的主服务器
127.0.0.1:26380> SENTINEL masters
#列出所有被监视的从服务器
127.0.0.1:26380> SENTINEL slaves mymaster
#返回给定名字的主服务器的IP地址和端口号
127.0.0.1:26380> SENTINEL get-master-addr-by-name mymaster
1) "127.0.0.1"
2) "6380"
#重置所有名字和给定模式
127.0.0.1:26380> SENTINEL reset mymaster
#当主服务器失效时，在不询问其他Sentinel意见的情况下，强制开始一次自动故障迁移。
127.0.0.1:26380> SENTINEL failover mymaster
```

## Redis Cluster 集群核心技术

**Cluster 是什么？** Redis 官方分布式集群方案：数据自动分片到多台机器，并提供高可用，解决单机内存/性能瓶颈。

**核心原理：**
- 整个集群有 **16384 个槽位（slot）**，均匀分配给各分片主节点；
- 存数据时：`slot = CRC16(key) % 16384`，算出槽位后找到对应节点存储；
- 每个分片一主一从（主从复制 + 自动故障转移），类似 Sentinel 功能但集成在节点内部；
- 客户端连接任意一个节点即可，数据不在当前节点时返回 `MOVED` 转向错误，客户端重定向到正确节点执行。

**运行机制：**
- 所有节点两两互联（PING-PONG 心跳），内部用二进制协议通信；
- 节点故障判定：超过半数 master 确认才生效；
- 客户端直连节点，不需要代理层，连接任意一个可用节点即可。

**高可用：**
- 每分片一主一从；主挂了从库自动顶替（复用 SLAVEOF 复制逻辑）；
- 若主从同时挂掉，该分片槽位不可用，集群可能停止服务。


### 规划、搭建过程
6个redis实例，一般会放到3台硬件服务器
注：在企业规划中，一个分片的两个节点，分到不同的物理机，防止硬件主机宕机造成的整个分片数据丢失。

```
端口号：7000-7005

1、安装集群插件
EPEL源安装ruby支持
yum install ruby rubygems -y

使用国内源
gem sources -l
gem sources -a http://mirrors.aliyun.com/rubygems/ 
gem sources  --remove http://rubygems.org/
gem install redis -v 3.3.3
gem sources -l

或者：
gem sources -a http://mirrors.aliyun.com/rubygems/  --remove http://rubygems.org/ 

---
2、集群节点准备

mkdir /data/700{0..5}

cat > /data/7000/redis.conf<<EOF
port 7000
daemonize yes
pidfile /data/7000/redis.pid
loglevel notice
logfile "/data/7000/redis.log"
dbfilename dump.rdb
dir /data/7000
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

cat > /data/7001/redis.conf<<EOF
port 7001
daemonize yes
pidfile /data/7001/redis.pid
loglevel notice
logfile "/data/7001/redis.log"
dbfilename dump.rdb
dir /data/7001
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

cat > /data/7002/redis.conf<<EOF
port 7002
daemonize yes
pidfile /data/7002/redis.pid
loglevel notice
logfile "/data/7002/redis.log"
dbfilename dump.rdb
dir /data/7002
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

cat > /data/7003/redis.conf<<EOF
port 7003
daemonize yes
pidfile /data/7003/redis.pid
loglevel notice
logfile "/data/7003/redis.log"
dbfilename dump.rdb
dir /data/7003
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

cat > /data/7004/redis.conf<<EOF
port 7004
daemonize yes
pidfile /data/7004/redis.pid
loglevel notice
logfile "/data/7004/redis.log"
dbfilename dump.rdb
dir /data/7004
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

cat > /data/7005/redis.conf<<EOF
port 7005
daemonize yes
pidfile /data/7005/redis.pid
loglevel notice
logfile "/data/7005/redis.log"
dbfilename dump.rdb
dir /data/7005
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

启动节点：

redis-server /data/7000/redis.conf 
redis-server /data/7001/redis.conf 
redis-server /data/7002/redis.conf 
redis-server /data/7003/redis.conf 
redis-server /data/7004/redis.conf 
redis-server /data/7005/redis.conf 



[root@db01 ~]# ps -ef |grep redis
root       8854      1  0 03:56 ?        00:00:00 redis-server *:7000 [cluster]     
root       8858      1  0 03:56 ?        00:00:00 redis-server *:7001 [cluster]     
root       8860      1  0 03:56 ?        00:00:00 redis-server *:7002 [cluster]     
root       8864      1  0 03:56 ?        00:00:00 redis-server *:7003 [cluster]     
root       8866      1  0 03:56 ?        00:00:00 redis-server *:7004 [cluster]     
root       8874      1  0 03:56 ?        00:00:00 redis-server *:7005 [cluster]  


3、将节点加入集群管理

redis-trib.rb create --replicas 1 127.0.0.1:7000 127.0.0.1:7001 \
127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005


4、集群状态查看

集群主节点状态
redis-cli -p 7000 cluster nodes | grep master
集群从节点状态
redis-cli -p 7000 cluster nodes | grep slave




5、集群节点管理

5.1 增加新的节点

mkdir /data/7006
mkdir /data/7007


cat > /data/7006/redis.conf<<EOF
port 7006
daemonize yes
pidfile /data/7006/redis.pid
loglevel notice
logfile "/data/7006/redis.log"
dbfilename dump.rdb
dir /data/7006
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

cat > /data/7007/redis.conf<<EOF 
port 7007
daemonize yes
pidfile /data/7007/redis.pid
loglevel notice
logfile "/data/7007/redis.log"
dbfilename dump.rdb
dir /data/7007
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

redis-server /data/7006/redis.conf 
redis-server /data/7007/redis.conf 

5.2 添加主节点：
redis-trib.rb add-node 127.0.0.1:7006  127.0.0.1:7000

# 查看新添加的主节点未分配slot
[root@db03 ~]# redis-cli -p 7000 cluster nodes |grep master
2bfbffadde1af44b96e9b1e2adb091d43d47e68c 127.0.0.1:7006 master - 0 1672626387663 0 connected
32cef43072cc9ea4e362217cbdf96cba0677fd5d 127.0.0.1:7000 myself,master - 0 0 1 connected 0-5460
1af712efb561aac2bd629d51098544fb0de8e910 127.0.0.1:7001 master - 0 1672626388665 2 connected 5461-10922
3cdb72a1f8050ef169e65ccc31cf5e6aa9fd4f9c 127.0.0.1:7002 master - 0 1672626389167 3 connected 10923-16383


5.3 转移slot（重新分片）
redis-trib.rb reshard 127.0.0.1:7000


[root@db03 26380]# redis-trib.rb reshard 127.0.0.1:7000
>>> Performing Cluster Check (using node 127.0.0.1:7000)
M: 32cef43072cc9ea4e362217cbdf96cba0677fd5d 127.0.0.1:7000
   slots:0-5460 (5461 slots) master
   1 additional replica(s)
M: 2bfbffadde1af44b96e9b1e2adb091d43d47e68c 127.0.0.1:7006
   slots: (0 slots) master
   0 additional replica(s)
S: ca9f7c0cf3e73b40ca04407971cca1dea219a046 127.0.0.1:7003
   slots: (0 slots) slave
   replicates 32cef43072cc9ea4e362217cbdf96cba0677fd5d
S: 25a201d2ac98109882296d1f17ac837a64c33586 127.0.0.1:7005
   slots: (0 slots) slave
   replicates 3cdb72a1f8050ef169e65ccc31cf5e6aa9fd4f9c
S: 7e3cd66eb4670a2de266007656be41e75b88dbd5 127.0.0.1:7004
   slots: (0 slots) slave
   replicates 1af712efb561aac2bd629d51098544fb0de8e910
M: 1af712efb561aac2bd629d51098544fb0de8e910 127.0.0.1:7001
   slots:5461-10922 (5462 slots) master
   1 additional replica(s)
M: 3cdb72a1f8050ef169e65ccc31cf5e6aa9fd4f9c 127.0.0.1:7002
   slots:10923-16383 (5461 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
# 你想给新节点分配多少个slots 
How many slots do you want to move (from 1 to 16384)? 4096 # 计算 16384/4=4096
What is the receiving node ID? 2bfbffadde1af44b96e9b1e2adb091d43d47e68c #添加7006的节点id

Please enter all the source node IDs.
  Type 'all' to use all the nodes as source nodes for the hash slots.
  Type 'done' once you entered all the source nodes IDs.
Source node #1:all #从所有节点分别拿一部分slots给新节点


5.4 添加从节点
# id这填写主库7006的id
redis-trib.rb add-node --slave --master-id 2bfbffadde1af44b96e9b1e2adb091d43d47e68c 127.0.0.1:7007 127.0.0.1:7000

#查看
[root@db03 26380]# redis-cli -p 7000 cluster nodes|grep slave


6.删除节点

6.1 将需要删除节点slot移动走

redis-trib.rb reshard 127.0.0.1:7000

[root@db03 26380]# redis-trib.rb reshard 127.0.0.1:7000
How many slots do you want to move (from 1 to 16384)? 4096  #需要移动多少个slots
What is the receiving node ID? 32cef43072cc9ea4e362217cbdf96cba0677fd5d #谁接收 目标节点
Please enter all the source node IDs.
  Type 'all' to use all the nodes as source nodes for the hash slots.
  Type 'done' once you entered all the source nodes IDs.
Source node #1:2bfbffadde1af44b96e9b1e2adb091d43d47e68c  #从哪移  源节点
Source node #2:done                                     #有其他节点可继续添加


删除一个节点
删除master节点之前首先要使用reshard移除master的全部slot,然后再删除当前节点

从节点删除：
redis-trib.rb del-node 127.0.0.1:7007 4c3f6e9366f08a96eda22b20a32c5041ec37c7c4
主节点删除：
redis-trib.rb del-node 127.0.0.1:7006 2bfbffadde1af44b96e9b1e2adb091d43d47e68c


```

---

# Redis 经典常见面试题（含答案）

> 覆盖：原理、缓存三兄弟、持久化、过期淘汰、高可用、事务锁。标注 🔴（必背）/ 🟡（重点）/ 🟢（了解）。

## 一、基础与原理

**Q1. Redis 是什么？为什么快？（🔴）**

**一句话：Redis 是基于内存的 Key-Value 数据库（NoSQL），C 语言编写，单机 QPS 可达 10 万+。**

快的 4 个原因：
1. **纯内存操作**：数据都在内存，没有磁盘 IO（IO 是最大的瓶颈）
2. **单线程 + IO 多路复用**：避免了线程切换和锁竞争的开销
3. **高效数据结构**：SDS、跳表、哈希表等，都是为性能设计的
4. **非阻塞 IO**：`epoll` 同时监听大量连接，就绪才处理

**Q2. 既然单线程，为什么还快？Redis 6.0 为什么引入多线程？（🔴）**

- 瓶颈不在 CPU，而在**网络 IO 和内存**，单线程省掉了锁竞争、上下文切换
- 单线程还让命令**原子执行**（天然无并发问题），也简化了实现
- Redis 6.0 引入多线程只做两件事：**网络读、网络写**（IO 多线程），**命令执行仍是单线程**，所以原子性不受影响

**Q3. Redis 有哪些数据类型？底层用什么实现？（🔴）**

| 类型 | 底层结构 | 典型场景 |
| :--- | :--- | :--- |
| String | SDS（动态字符串） | 缓存、计数 |
| Hash | 哈希表 / ziplist | 用户信息等对象存储 |
| List | 双向链表 / quicklist | 消息队列 |
| Set | 哈希表 / intset | 去重、共同关注（交集并集） |
| ZSet | 跳表 + 哈希表 | 排行榜 |

**Q4. ZSet 为什么用跳表不用红黑树？（🟡）**

- 跳表实现简单，代码好维护；红黑树实现复杂
- 跳表做范围查询（`ZRANGE`）比红黑树方便（红黑树需中序遍历）
- 内存上跳表可用概率法控制层数，与红黑树差距不大

**Q5. 项目中 Redis 一般用来做什么？（🔴）**

缓存、分布式锁、计数器（点赞/粉丝数）、排行榜、消息队列、分布式 Session、限流、唯一 ID 生成（INCR）。

## 二、缓存三兄弟（必考）

**Q6. 什么是缓存穿透？怎么解决？（🔴）**

**现象：** 查询一个**根本不存在的数据**，每次都会穿过缓存打到数据库，数据库压力大甚至被打挂。

**解决：**
1. **布隆过滤器**：请求先过过滤器，不存在直接拦截
2. **缓存空值**：查不到也缓存一个 null（设置短过期时间，防止恶意刷）
3. 参数校验：非法 id（如负数）直接拒绝

**Q7. 什么是缓存击穿？怎么解决？（🔴）**

**现象：** 某个**热点 key 过期**瞬间，大量请求同时打到数据库。

**解决：**
1. **互斥锁**：重建缓存时只让一个线程查库，其他线程等待
2. **逻辑过期**：key 永不过期，存过期时间字段，异步重建
3. **热点 key 不设置过期时间** + 后台更新

**Q8. 什么是缓存雪崩？怎么解决？（🔴）**

**现象：** **大量 key 同时过期**（或 Redis 宕机），所有请求瞬间打到数据库。

**解决：**
1. 过期时间加**随机值**，避免同时失效
2. **集群高可用**：主从 + 哨兵 + Cluster，防止 Redis 宕机
3. 服务降级/限流：数据库扛不住时先返回降级数据
4. 热点数据**预热**：提前加载到缓存

**Q9. 缓存和数据库双写，怎么保证一致性？（🔴）**

**业界标准做法：先更新数据库，再删除缓存（Cache Aside 模式）。**
- 读：先读缓存，没有就读库并写缓存
- 写：先更新数据库，再删缓存（而不是更新缓存）
- 删缓存失败怎么办：**消息队列重试** 或 **binlog 订阅（Canal）** 异步删除
- 为什么删而不是更新：更新缓存有并发写覆盖问题，删除让它"下次读时重建"

## 三、持久化

**Q10. RDB 和 AOF 有什么区别？怎么选？（🔴）**

| 对比项 | RDB（快照） | AOF（日志） |
| :--- | :--- | :--- |
| 原理 | 定期全量拍快照 | 追加记录每条写命令 |
| 文件 | 小、二进制 | 大、文本 |
| 恢复 | 快 | 慢（重放命令） |
| 数据安全 | 两次快照间可能丢 | 按策略最多丢 1 秒 |
| 适用 | 备份、主从复制 | 数据安全要求高 |

**Redis 4.0+ 支持混合持久化：** AOF 重写时用 RDB 打底 + 增量命令，兼顾恢复速度和安全性。
**选型口诀：** 丢一点可以 → RDB；一点都不能丢 → AOF；都想要 → 混合。

**Q11. Redis 宕机了怎么恢复？（🟡）**

重启后自动加载持久化文件：
- 只开了 RDB → 加载 dump.rdb
- 只开了 AOF → 加载 appendonly.aof（优先于 RDB，因为更全）
- 混合模式 → 加载 AOF（内含 RDB 头）

## 四、过期与淘汰

**Q12. Redis 的 key 过期了会立刻删除吗？（🔴）**

**不会。** Redis 用的是**惰性删除 + 定期删除**：
- **惰性删除**：每次访问 key 时才检查是否过期，过期才删（省 CPU，但过期 key 会残留）
- **定期删除**：每 100ms 随机抽一批带过期时间的 key 检查删除（防止残留过多）
- 两者都删不掉时 → 靠**内存淘汰策略**兜底

**Q13. Redis 内存满了怎么办？8 种淘汰策略？（🔴）**

**默认 `noeviction`（不淘汰，直接报错）。** 常用的是 `allkeys-lru`（LRU 最近最少使用）。

| 策略 | 说明 |
| :--- | :--- |
| noeviction | 不淘汰，写命令直接报错（默认） |
| allkeys-lru / lfu | 所有 key 中按 LRU/LFU 淘汰 |
| volatile-lru / lfu | 只对设置了过期时间的 key 按 LRU/LFU 淘汰 |
| allkeys-random / volatile-random | 随机淘汰 |
| volatile-ttl | 淘汰剩余存活时间最短的 key |

**注意：** LRU 是"近似 LRU"（抽样 5 个淘汰最旧），不是严格 LRU。

**Q14. 大量 key 同时过期怎么办？（🟡）**

- 给过期时间加**随机数**打散（避免瞬时高负载）
- 与缓存雪崩同理，这是雪崩的常见诱因之一

## 五、高可用

**Q15. Redis 主从复制原理？全量同步和增量同步？（🔴）**

**全量同步（首次/断连太久）：**
1. 从库向主库发 `PSYNC` 请求
2. 主库执行 `BGSAVE` 生成 RDB 快照发给从库
3. 同步期间的新命令存入缓冲区，快照发完后补发给从库

**增量同步（短断重连）：** 从库带着 `replid + offset` 回来，主库只把断线期间积压的命令（积压缓冲区 backlog）发给从库，不用全量。

**一句话：** 第一次全量 RDB，之后靠 backlog 增量；积压溢出就退回全量。

**Q16. Sentinel 哨兵原理？（🔴）**

**作用：监控 + 自动故障转移，让 Redis 高可用。**

流程：
1. 每 1 秒 PING 一次，判断**主观下线（SDOWN）**
2. 多个哨兵互相确认后升级为**客观下线（ODOWN）**
3. 哨兵内部投票选出 Leader，**多数派**同意才执行故障转移
4. 从从库中**选一个最优的**提升为新主库，其他从库重新指向新主库

**Q17. 为什么选从库时看 offset？为什么集群最少 3 个主节点？（🟢）**

- offset 越大说明数据越新，优先选它当主库，数据丢失最少
- Cluster 最少 3 主是因为集群要保证**半数以上存活**才可用；3 主挂 1 个还剩 2 个（过半）；2 主挂 1 个只剩 1 个就不可用了

**Q18. Redis Cluster 集群原理？为什么是 16384 个槽？（🟡）**

- 数据按 **key 的 CRC16 哈希值 % 16384** 计算槽位，槽分配到各节点，节点只存自己那部分槽
- 客户端直连任意节点，访问不属于它的 key 会返回 `MOVED` 重定向
- 每个主节点可带从节点，主挂自动提升从库
- **为什么 16384：** 槽位越多节点间心跳包越大；16384 在节点数（最多 1000）下网络开销和均衡性平衡最好

**Q19. 如何保证 Redis 高可用？（🔴）**

**三件套：主从复制（数据备份）+ 哨兵（自动切换）+ Cluster（水平扩展）。**
单点必挂，主从保证有副本，哨兵保证挂了能自动顶上，Cluster 保证数据量大了能扩展。

## 六、事务与锁

**Q20. Redis 事务和 MySQL 事务有什么区别？（🔴）**

| 对比 | MySQL 事务 | Redis 事务（MULTI/EXEC） |
| :--- | :--- | :--- |
| 原子性 | 全部成功或全部回滚 | **不支持回滚**，命令顺序执行，出错继续 |
| 隔离性 | 隔离级别 | 单线程执行，天然隔离 |
| 一致性 | 强一致 | 弱一致 |

**Redis 事务用 `MULTI` 开始、`EXEC` 执行、`DISCARD` 取消；只保证"一批命令不被插入执行"，不保证"出错回滚"。**

**Q21. Redis 怎么实现分布式锁？（🔴）**

**正确姿势：`SET key value NX EX 30`（原子：不存在才设置 + 30 秒过期），释放用 Lua 脚本保证原子：**
```lua
-- 先比对 value（自己的唯一标识），一样才删除，防止误删别人的锁
if redis.call("get", KEYS[1]) == ARGV[1] then
    return redis.call("del", KEYS[1])
else
    return 0
end
```

**为什么用 Lua：** 把"判断 + 删除"两步合并成一步，避免非原子操作。

**三个注意点：**
1. value 必须是**唯一标识**（如 UUID），防止误删
2. 过期时间必须加（防止持有锁的进程挂了锁不释放）
3. 过期时间太短任务没跑完怎么办 → **看门狗续期**（Redisson 的实现）

**Q22. 乐观锁 / Watch 在 Redis 里怎么用？（🟡）**

`WATCH` 监视一个 key，如果事务执行前 key 被改动，事务直接失败（返回 nil），客户端重试即可——这就是 Redis 版的 CAS（Compare And Swap），典型应用：秒杀扣库存。

## 七、其他高频题

**Q23. 什么是热点 key / 大 key？怎么解决？（🟡）**

**热点 key：** 某个 key 被大量请求同时访问，单节点被打满。
解决：读写分离 + 多副本分流量（同数据复制多份 + 不同 key 后缀）+ 本地缓存（JVM 缓存兜底）。

**大 key：** value 过大（如几 MB 的 String、上百万成员的 Set）。
解决：拆分（大 hash 拆成多个小 hash）+ 避免 `DEL` 阻塞（用 `UNLINK` 异步删除或分批删除）。

**Q24. Redis 发布订阅和消息队列（MQ）的区别？（🟡）**

| 对比 | Redis Pub/Sub | 专业 MQ（RabbitMQ/Kafka） |
| :--- | :--- | :--- |
| 消息持久化 | 不持久化，断线就丢 | 持久化，可追溯 |
| 消息堆积 | 无积压能力，超出就丢 | 支持大量积压 |
| 可靠性 | 不保证送达 | 确认机制，保证不丢 |
| 适用 | 实时性要求高、可丢 | 业务消息、削峰填谷 |

**Q25. 布隆过滤器是什么？原理？（🟡）**

**用很小的内存判断"一个元素一定不存在 / 可能存在"的数据结构。**

原理：多次哈希映射到位数组，查询时只要有一个位是 0，就**一定不存在**；全是 1 则**可能存在**（有误判率）。
应用：**防缓存穿透**（在缓存前挡一道）、去重、爬虫 URL 过滤。
注意：**不能删除**（多个元素可能共享同一位），Redis 里用 `RedisBloom` 模块实现。

**Q26. Redis 怎么实现限流？（🟢）**

1. `INCR + EXPIRE`：固定窗口计数，超阈值拒绝（简单）
2. `SET NX PX`（token bucket / 滑动窗口 Lua 脚本）：平滑限流
3. Redisson 的 `RRateLimiter`：基于 Lua 的令牌桶实现