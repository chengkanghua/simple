redis

## Redis简介
Redis是一款开源的，ANSI C语言编写的，高级键值(key-value)缓存和支持永久存储NoSQL数据库产品。
Redis采用内存(In-Memory)数据集(DataSet) 。
支持多种数据类型。
运行于大多数POSIX系统，如Linux、*BSD、OS X等。

软件获取和帮助
● 官方网站：https://redis.io/
● 下载网站：http://download.redis.io/releases/
● 帮助网站：http://redisdoc.com/


软件功能
1）高速读写
2）数据类型丰富
3）支持持久化
4）多种内存分配及回收策略
5）支持事物
6）消息队列、消息订阅
7）支持高可用
8）支持分布式分片集群

redis一般在企业中，是单机多实例架构


## Redis安装部署
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

## redis安全配置

protected-mode： 禁止protected-mode yes/no （保护模式，是否只允许本地访问）
bind：指定IP进行监听
requirepass： 增加密码
	auth {password}： 在redis-cli中使用，进行认证
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
redis在线查看和修改配置
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
## redis持久化
什么是持久化？
持久化：就是将内存中的数据，写入到磁盘上，并且永久存在的。


RDB 持久化
	可以在指定的时间间隔内生成数据集的时间点快照（point-in-time snapshot）。
AOF 持久化
	记录服务器执行的所有写操作命令，并在服务器启动时，通过重新执行这些命令来还原数据集。 AOF 文件中的命令全部以 Redis 协议的格式来保存，新命令会被追加到文件的末尾。

RDB持久化优缺点总结
● 优点：速度快，适合于用作备份，主从复制也是基于RDB持久化功能实现的。
● 缺点：会有数据丢失、导致服务停止几秒

AOF持久化优缺点总结
● 优点：可以最大程度保证数据不丢失
● 缺点：日志记录量级比较大


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

面试： 
redis 持久化方式有哪些？有什么区别？
rdb：基于快照的持久化，速度更快，一般用作备份，主从复制也是依赖于rdb持久化功能
aof：以追加的方式记录redis操作日志的文件。可以最大程度的保证redis数据安全，类似于mysql的binlog


### 数据类型
介绍
                key            			 value
                键		       			值
                自主定制的名字				多数据类型的存储模式
● String类型		  name                     			 "zhangsan" 
● Hash类型		stu                                                 {id:101,name:zhangsan}
● List类型                       wechat                                          {v1,v2,v3}
● Set 集合类型              set1                  			   0  1  2
● Sorted set(有序)       zset1                                              [score m1,score m2,score m3]
									        0	   1	   2
### 应用场景
strings :  
	常规计数：微博数、粉丝数、
	互联网当中，点击量，访问量，关注量等
	网页游戏应用当中的，血量、蓝量等
hash类型 (字典类型)
    应用场景：最接近于MySQL表结构的数据类型
    存储部分变更的数据，如用户信息,商品信息等。
List（列表）
	消息队列系统
	比如sina微博: 在Redis中我们的最新微博ID使用了常驻缓存，这是一直更新的。但是做了限制不能超过5000个ID，因此获取ID的函数会一直询问Redis。只有在start/count参数超出了这个范围的时候，才需要去访问数据库。 系统不会像传统方式那样“刷新”缓存，Redis实例中的信息永远是一致的。SQL数据库（或是硬盘上的其他类型数据库）只是在用户需要获取“很远”的数据时才会被触发，而主页或第一个评论页是不会麻烦到硬盘上的数据库了。
Set（集合)
	在微博应用中，可以将一个用户所有的关注人存在一个集合中，将其所有粉丝存在一个集合。Redis还为集合提供了求交集、并集、差集等操作，可以非常方便的实现如共同关注、共同喜好、二度好友等功能，对上面的所有集合操作，你还可以使用不同的命令选择将结果返回给客户端还是存集到一个新的集合中。
Sorted-Set（有序集合）
	排行榜应用，取TOP N操作
	这个需求与上面需求的不同之处在于，前面操作以时间为权重，这个是以某个条件为权重，比如按顶的次数排序，这时候就需要我们的sorted set出马了，将你要排序的值设置成sorted set的score，将具体的数据设置成相应的value，每次只需要执行一条ZADD命令即可。

### 数据类型基本操作

通用操作
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















