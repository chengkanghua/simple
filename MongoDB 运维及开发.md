# MongoDB 运维及开发

not Mango      Humongous:巨大


### 安装MongoDB

```
#获取MongoDB
https://www.mongodb.com/try/download/community

wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-4.2.23.tgz

mkdir -p /mongodb && cd /mongodb
tar xf mongodb-linux-x86_64-rhel70-4.2.8.tgz
mv /mongodb/mongodb-linux-x86_64-rhel70-4.2.23 /mongodb/app

# 关闭THP
root用户下
在vi /etc/rc.local最后添加如下代码
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
	echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi

[root@node01 app]# cat /sys/kernel/mm/transparent_hugepage/enabled
always madvise [never]
[root@node01 app]# cat /sys/kernel/mm/transparent_hugepage/defrag
always madvise [never]

#环境准备
#创建用户和组
useradd mongod
passwd mongod
#(2)创建mongodb所需目录结构
mkdir -p /mongodb/conf
mkdir -p /mongodb/log
mkdir -p /mongodb/data
#(3) 修改权限
chown -R mongod:mongod /mongodb
#(4) 切换用户并设置环境变量
su - mongod
echo 'export PATH=/mongodb/app/bin:$PATH' >> ~/.bash_profile
source  ~/.bash_profile

#启动数据库并初始化数据
su - mongod
mongod --dbpath=/mongodb/data --logpath=/mongodb/log/mongodb.log --port=27017 --logappend --fork

# 登录mongodb
$ mongo

#使用配置文件
cat > /mongodb/conf/mongodb.conf<<EOF
logpath=/mongodb/log/mongodb.log
dbpath=/mongodb/data
port=27017
logappend=true
fork=true
EOF

#关闭mongodb
mongod -f /mongodb/conf/mongodb.conf --shutdown
使用配置文件启动mongodb
mongod -f /mongodb/conf/mongodb.conf


#YAML例子
cat > /mongodb/conf/mongo.conf <<EOF
systemLog:
   destination: file
   path: "/mongodb/log/mongodb.log"
   logAppend: true
storage:
   journal:
      enabled: true
   dbPath: "/mongodb/data/"
processManagement:
   fork: true
net:
   port: 27017
   bindIp: 10.0.0.4,127.0.0.1
EOF
mongod -f /mongodb/conf/mongo.conf --shutdown
mongod -f /mongodb/conf/mongo.conf   


# 与mysql相同的命令
> use oldguo
switched to db oldguo
> show databases;
admin   0.000GB
config  0.000GB
local   0.000GB
> db
oldguo
> show tables;
> use admin
switched to db admin
> show tables;
system.version
> use local
switched to db local
> show tables;
startup_log
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB


```

## 用户和权限管理


```
用户管理*****
注意:
验证库，建立用户时use到的库，在使用用户时，要加上验证库才能登陆。
对于管理员用户,必须在admin下创建.
1. 建用户时,use到的库,就是此用户的验证库
2. 登录时,必须明确指定验证库才能登录
3. 通常,管理员用的验证库是admin,普通用户的验证库一般是所管理的库设置为验证库
4. 如果直接登录到数据库,不进行use,默认的验证库是test,不是我们生产建议的.


#基本语法
use admin
mongo 10.0.51/admin
db.createUser
{
    user: "<name>",
    pwd: "<cleartext password>",
    roles: [
    { role: "<role>",
    db: "<database>" } | "<role>",
    ...
    ]
}

验证数据库:
mongo -u test -p 123 10.0.51/test
-----------------------------------------------------
(1) --创建超级管理员：管理所有数据库（必须use admin再去创建）
$ mongo
use admin
db.createUser(
{
    user: "root",
    pwd: "root123",
    roles: [ { role: "root", db: "admin" } ]
}
)

验证用户
db.auth('root','root123')

配置文件中，加入以下配置
security:
  authorization: enabled

重启mongodb
mongod -f /mongodb/conf/mongo.conf --shutdown
mongod -f /mongodb/conf/mongo.conf

登录验证
mongo -uroot -proot123 admin
mongo -uroot -proot123 10.0.51/admin

###### 或者
mongo
use admin
db.auth('root','root123')

#查看用户:
use admin
db.system.users.find().pretty()

2 、创建库管理用户
mongo -uroot -proot123 admin

use app
db.createUser(
{
user: "admin",
pwd: "admin",
roles: [ { role: "dbAdmin", db: "app" } ]
}
)

db.auth('admin','admin')
#命令行登录执行
mongo -uadmin -padmin localhost/app

```
## mongo常规操作

```
> help
        db.help()                    help on db methods
        db.mycoll.help()             help on collection methods
        sh.help()                    sharding helpers
        rs.help()                    replica set helpers

> db.help()
DB methods:
        db.adminCommand(nameOrDocument) - switches to 'admin' db, and runs command [just calls db.runCommand(...)]
        db.aggregate([pipeline], {options}) - performs a collectionless aggregation on this database; returns a cursor
        db.auth(username, password)
        db.cloneDatabase(fromhost) - will only function with MongoDB 4.0 and below

> db.t1.help();

db.[TAB][TAB]
db.t1.[TAB][TAB]

#常用操作
> db.version()
4.2.23
#显示当前数据库
> db
> db.getName()
#显示所有数据库
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
#切换数据库
> use local
switched to db local
#查看local数据
> use local
switched to db local
> db.stats()
#查看当前数据库的连接机器地址
> db.getMongo()
connection to 127.0.0.1:27017

#指定数据库连接,(默认连接test数据库)
[mongod@db03 mongodb]$ mongo localhost/admin

#库和表的操作
//建库
> use test
switched to db test
//删除
> db.dropDatabase()
{ "ok" : 1 }

#创建集合(表)
方法1:
> use app
switched to db app
> db.createCollection('a')
{ "ok" : 1 }
> db.createCollection('b')
{ "ok" : 1 }
> show tables;
a
b
方法2: 当插入一个文档的时候,一个集合就会自动创建
> use app
switched to db app
> db.c.insert({username:"mongodb"})
WriteResult({ "nInserted" : 1 })
> show collections
a
b
c
> db.c.find()
{ "_id" : ObjectId("63b2a178fbcb498413395e4b"), "username" : "mongodb" }

#删除集合
> use app
> db.c.drop()


# 重命名集合
> db.c.insert({username:"mongodb"})
> db.c.renameCollection("log")


```
### insert

```
操作格式：
db.<集合>.insertOne(<JSON对象>)
db.<集合>.insertMany([<JSON 1>, <JSON 2>, …<JSON n>])
示例：
> use test
db.fruit.insertOne({name: "apple"})
db.fruit.insertMany([
{name: "apple"},
{name: "pear"},
{name: "orange"}
])
//查看
> db.fruit.find()
批量插入数据：
for(i=0;i<10000;i++){db.log.insert({"uid":i,"name":"mongodb","age":6,"date":new Date()}); }
```

### find

```
# 关于 find:
find 是 MongoDB 中查询数据的基本指令，相当于 SQL 中的 SELECT 。
find 返回的是游标。
# find 示例：
db.movies.find( { "year" : 1975 } ) //单条件查询
db.movies.find( { "year" : 1989, "title" : "Batman" } ) //多条件and查询
db.movies.find( { $and : [ {"title" : "Batman"}, { "category" : "action" }] }
) // and的另一种形式
db.movies.find( { $or: [{"year" : 1989}, {"title" : "Batman"}] } ) //多条件or查询
db.movies.find( { "title" : /^B/} ) //按正则表达式查找


查询条件对照
sql                msql
a=1           {a:1}
a<>1          {a:{$ne: 1}}
a>1           {a:{$gt: 1}}
a>=1          {a:{$gte: 1}}
a<1           {a:{$lt: 1}}
a<=1		  {a:{$lte: 1}}

查询逻辑对照
sql                msql
a=1 and b=1        {a: 1,b: 1}或{$and:[{a: 1},{b: 1}]}
a=1 or b=1         {$or:[{a: 1},{b:1}]}
a is null		   {a:{$exists: false}}
a in(1,2,3)		   {a:{$in:[1,2,3]}}

查询逻辑运算符
$lt  
$lte
$gt
$gte
$ne
$in
$nin
$or
$and

#find 搜索子文档
> db.fruit.insertOne({
name:"apple",
from:{
country:"china",
province:"guangdong"}
})

> db.fruit.find({"from.country":"china"})


#find搜索属组
> db.fruit.insert([
{"name":"apple",color:["red","green"]},
{"name":"mango",color:["yellow","green"]}
])
//查看单个条件
> db.fruit.find({color:"red"})
//查询多个条件
> db.fruit.find({$or: [{color:"red"},{color:"yellow"}]} )

#find搜索数组中的对象
db.movies.insertOne( {
"title" : "Raiders of the Lost Ark",
"filming_locations" : [
{ "city" : "Los Angeles", "state" : "CA", "country" : "USA" },
{ "city" : "Rome", "state" : "Lazio", "country" : "Italy" },
{ "city" : "Florence", "state" : "SC", "country" : "USA" }
]
})
// 查找城市是 Rome 的记录
db.movies.find({"filming_locations.city": "Rome"})


# find搜索属组的对象
在数组中搜索子对象的多个字段时，如果使用 $elemMatch，它表示必须是同一个
子对象满足多个条件。
考虑以下两个查询：
db.getCollection('movies').find({
"filming_locations.city": "Rome",
"filming_locations.country": "USA"
})

db.movies.insertOne( {
"title" : "11111",
"filming_locations" : [
{ "city" : "bj", "state" : "CA", "country" : "CHN" },
{ "city" : "Rome", "state" : "Lazio", "country" : "Italy" },
{ "city" : "tlp", "state" : "SC", "country" : "USA" }
]
})

db.getCollection('movies').find({
"filming_locations": {
$elemMatch:{"city":"bj", "country": "CHN"}
}
})

# 控制find返回的字段
find 可以指定只返回指定的字段；
● _id字段必须明确指明不返回，否则默认返回；
● 在 MongoDB 中我们称这为投影（projection）；
● db.movies.find({},{"_id":0, title:1}) 

参数说明
{"_id":0, title:1} // 不显示id ,返回title


# 使用remove 删除文档
remove 命令需要配合查询条件使用；
● 匹配查询条件的的文档会被删除；
● 指定一个空文档条件会删除所有文档；
● 以下示例：
db.testcol.remove( { a : 1 } ) // 删除a 等于1的记录
db.testcol.remove( { a : { $lt : 5 } } ) // 删除a 小于5的记录
db.testcol.remove( { } ) // 删除所有记录
db.testcol.remove() //报错

> db.movies.remove({"title":"11111"})
WriteResult({ "nRemoved" : 1 })

#使用update更新文档
Update 操作执行格式：db.<集合>.update(<查询条件>, <更新字段>)
● 以以下数据为例：
db.fruit.insertMany([
{name: "apple"},
{name: "pear"},
{name: "orange"}
])
db.fruit.updateOne({name: "apple"}, {$set: {from: "China"}})


● 使用 updateOne 表示无论条件匹配多少条记录，始终只更新第一条；
● 使用 updateMany 表示条件匹配多少条就更新多少条；
● updateOne/updateMany 方法要求更新条件部分必须具有以下之一，否则将报错：
• $set/$unset
• $push/$pushAll/$pop
• $pull/$pullAll
• $addToSet
● // 报错
db.fruit.updateOne({name: "apple"}, {from: "China"})


//使用 update 更新数组
● $push: 增加一个对象到数组底部
● $pushAll: 增加多个对象到数组底部
● $pop: 从数组底部删除一个对象
● $pull: 如果匹配指定的值，从数组中删除相应的对象
● $pullAll: 如果匹配任意的值，从数据中删除相应的对象
● $addToSet: 如果不存在则增加一个值到数组

//使用drop删除集合
● 使用 db.<集合>.drop() 来删除一个集合
● 集合中的全部文档都会被删除
● 集合相关的索引也会被删除
db.colToBeDropped.drop()

//使用 dropDatabase 删除数据库
● 使用 db.dropDatabase() 来删除数据库
● 数据库相应文件也会被删除，磁盘空间将被释放
use tempDB
db.dropDatabase()
show collections // No collections
show dbs // The db is gone
```
## python连接mongodb
```
在 Python 中使用 MongoDB 之前必须先安装用于访问数据库的驱动程序：
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum install -y python3
pip3 install pymongo
在 python 交互模式下导入 pymongo，检查驱动是否已正确安装：
import pymongo
pymongo.version

#创建连接
确定 MongoDB 连接串
使用驱动连接到 MongoDB 集群只需要指定 MongoDB 连接字符串即可。其基本格式可
以参考文档: Connection String URI Format 最简单的形式是
mongodb://数据库服务器主机地址：端口号
如：mongodb://127.0.0.1:27017
● 初始化数据库连接
from pymongo import MongoClient
uri = "mongodb://root:root123@10.0.0.4:27017"
client = MongoClient(uri)
client

#插入数据
初始化数据库和集合
db = client["eshop"]
user_coll = db["users"]
插入一条新的用户数据
new_user = {"username": "nina", "password": "xxxx", "email":
"123456@qq.com "}
result = user_coll.insert_one(new_user)
result

```

## MongoDB RS (Replica Set)
```
MongoDB 复制集的主要意义在于实现服务高可用,它的现实依赖于两个方面的功能：
• 数据写入时将数据迅速复制到另一个独立节点上
• 在接受写入的节点发生故障时自动选举出一个新的替代节点
在实现高可用的同时，复制集实现了其他几个附加作用：
• 数据分发：将数据从一个区域复制到另一个区域，减少另一个区域的读延迟
• 读写分离：不同类型的压力分别在不同的节点上执行
• 异地容灾：在数据中心故障时候快速切换到异地

 典型复制集结构
 一个典型的复制集由3个以上具有投票权的节点组成，包括：
• 一个主节点（PRIMARY）：接受写入操作和选举时投票
• 两个（或多个）从节点（SECONDARY）：复制主节点上的新数据和选举时投票
• Arbiter（投票节点）

数据是如何复制的
当一个修改操作，无论是插入、更新或删除，到达主节点时，它对数据的操作将被记录下来（经过一些必
要的转换），这些记录称为 oplog。
从节点通过在主节点上打开一个 tailable 游标不断获取新进入主节点的 oplog，并在自己的数据上
回放，以此保持跟主节点的数据一致


通过选举完成故障恢复
具有投票权的节点之间两两互相发送心跳；
● 当5次心跳未收到时判断为节点失联；
● 如果失联的是主节点，从节点会发起选举，选出新的主节点；
● 如果失联的是从节点则不会产生新的选举；
● 选举基于 RAFT 一致性算法实现，选举成功的必要条件是大多数投票节点存活；

影响选举的因素
整个集群必须有大多数节点存活；被选举为主节点的节点必须：
• 能够与多数节点建立连接
• 具有较新的 oplog
• 具有较高的优先级（如果有配置）

常见选项
复制集节点有以下常见的选配项：
• 是否具有投票权（v 参数）：有则参与投票；
• 优先级（priority 参数）：优先级越高的节点越优先成为主节点。优先级为0的节点无法成为主节
点；
• 隐藏（hidden 参数）：复制数据，但对应用不可见。隐藏节点可以具有投票仅，但优先级必须为0；
• 延迟（slaveDelay 参数）：复制 n 秒之前的数据，保持与主节点的时间差。

复制集注意事项
● 关于硬件：
• 因为正常的复制集节点都有可能成为主节点，它们的地位是一样的，因此硬件配置上必须一致；
• 为了保证节点不会同时宕机，各节点使用的硬件必须具有独立性。
● 关于软件：
• 复制集各节点软件版本必须一致，以避免出现不可预知的问题。
● 增加节点不会增加系统写性能
```
### Replcation Set配置过程详解
```
#a规划
三个以上的mongodb节点（或多实例）
多实例：
（1）多个端口：28017、28018、28019、28020
（2）多套目录：
su - mongod
mkdir -p /mongodb/28017/conf /mongodb/28017/data /mongodb/28017/log
mkdir -p /mongodb/28018/conf /mongodb/28018/data /mongodb/28018/log
mkdir -p /mongodb/28019/conf /mongodb/28019/data /mongodb/28019/log
mkdir -p /mongodb/28020/conf /mongodb/28020/data /mongodb/28020/log
(3)配置文件内容准备
cat > /mongodb/28017/conf/mongod.conf <<EOF
systemLog:
  destination: file
  path: /mongodb/28017/log/mongodb.log
  logAppend: true
storage:
  journal:
    enabled: true
  dbPath: /mongodb/28017/data
  directoryPerDB: true
  #engine: wiredTiger
  wiredTiger:
    engineConfig:
      cacheSizeGB: 1
      directoryForIndexes: true
    collectionConfig:
      blockCompressor: zlib
    indexConfig:
      prefixCompression: true
processManagement:
  fork: true
net:
  port: 28017
  bindIp: 10.0.0.4,127.0.0.1
replication:
  oplogSizeMB: 2048
  replSetName: my_repl
EOF

\cp /mongodb/28017/conf/mongod.conf /mongodb/28018/conf/
\cp /mongodb/28017/conf/mongod.conf /mongodb/28019/conf/
\cp /mongodb/28017/conf/mongod.conf /mongodb/28020/conf/
sed 's#28017#28018#g' /mongodb/28018/conf/mongod.conf -i
sed 's#28017#28019#g' /mongodb/28019/conf/mongod.conf -i
sed 's#28017#28020#g' /mongodb/28020/conf/mongod.conf -i

sed 's#10.0.0.4#10.0.0.4#g' /mongodb/28017/conf/mongod.conf -i
sed 's#10.0.0.4#10.0.0.4#g' /mongodb/28018/conf/mongod.conf -i
sed 's#10.0.0.4#10.0.0.4#g' /mongodb/28019/conf/mongod.conf -i
sed 's#10.0.0.4#10.0.0.4#g' /mongodb/28020/conf/mongod.conf -i
------------------------------------------------------------
(4)启动多个实例备用
mongod -f /mongodb/28017/conf/mongod.conf
mongod -f /mongodb/28018/conf/mongod.conf
mongod -f /mongodb/28019/conf/mongod.conf
mongod -f /mongodb/28020/conf/mongod.conf

# b配置复制集
（1）1主2从，从库普通从库(PSS)
// 连接其中一个节点
mongo --port 28017 
use admin
config = {_id: 'my_repl', members: [
{_id: 0, host: '10.0.0.4:28017'},
{_id: 1, host: '10.0.0.4:28018'},
{_id: 2, host: '10.0.0.4:28019'}]
}
rs.initiate(config)

（2）1主1从1个arbiter(PSA)
# my_repl集群名称   
// 连接其中一个节点
mongo --port 28017   
use admin
config = {_id: 'my_repl', members: [
{_id: 0, host: '10.0.0.4:28017'},
{_id: 1, host: '10.0.0.4:28018'},
{_id: 2, host: '10.0.0.4:28019',"arbiterOnly":true}]
}
rs.initiate(config)

#c 复制集测试

my_repl:PRIMARY> use test
my_repl:PRIMARY> db.movies.insert([ 
{ "title" : "Jaws", "year" : 1975,"imdb_rating" : 8.1 },
{ "title" : "Batman", "year" : 1989, "imdb_rating" : 7.6 },
] );


my_repl:SECONDARY> db.movies.find().pretty();

注：在mongodb复制集当中，默认从库不允许读写。
rs.slaveOk();  //打开从库读功能
my_repl:SECONDARY> db.movies.find().pretty();

#d. 复制集管理操作：
（1）查看复制集状态：
rs.status(); //查看整体复制集状态
rs.isMaster(); // 查看当前是否是主节点
（2）添加删除节点
rs.add("ip:port"); // 新增从节点
rs.addArb("ip:port"); // 新增仲裁节点
rs.remove("ip:port"); // 删除一个节点

my_repl:PRIMARY> rs.add("10.0.0.4:28020")

（3）特殊从节点的配置
• 优先级（priority 参数：0-1000）：
优先级越高的节点越优先成为主节点。
优先级为0的节点无法成为主节点；
• 隐藏（hidden 参数）：复制数据，但对应用不可见。隐藏节点可以具有投票仅，但优先级必须为0；
• 延迟（slaveDelay 参数）：复制 n 秒之前的数据，保持与主节点的时间差。
配置延时节点（一般延时节点也配置成hidden）
cfg=rs.conf()
cfg.members[3].priority=0
cfg.members[3].slaveDelay=120
cfg.members[3].hidden=true
cfg.members[3].votes=0
rs.reconfig(cfg)

//cfg.members[3]  数字是rs.conf() 里members属组里索引位置从0开始算
改回来：
cfg=rs.conf()
cfg.members[3].priority=1
cfg.members[3].slaveDelay=0
cfg.members[3].hidden=0
cfg.members[3].votes=1
rs.reconfig(cfg)
配置成功后，通过以下命令查询配置后的属性
rs.conf();

#e. 副本集其他操作命令：
--查看副本集的配置信息
admin> rs.config()

--查看副本集各成员的状态
admin> rs.status()
--副本集角色切换（不要人为顺便操作，有风险） 主库切成从库
admin> rs.stepDown()

注：
admin> rs.freeze(300) //锁定从，使其不会转变成主库
freeze()和stepDown单位都是秒。

--设置副本节点可读：在副本节点执行
admin> rs.slaveOk()

eg：
admin> use app
switched to db app
app> db.createCollection('a')
{ "ok" : 0, "errmsg" : "not master", "code" : 10107 }

--查看副本节点
admin> rs.printSlaveReplicationInfo()
source: 192.168.1.22:27017
syncedTo: Thu May 26 2016 10:28:56 GMT+0800 (CST)
0 secs (0 hrs) behind the primary

```

## MongoDB常见架构

单机版  开发与测试   20%
复制集高可用             70%
分片集群横向扩展    10%

为什么使用分片集群
• 数据容量日益增大，访问性能日渐降低，怎么破？
• 新品上线异常火爆，如何支撑更多的并发用户？
• 单库已有 10TB 数据，恢复需要1-2天，如何加速？
• 地理分布数据


•银行交易单表内10亿笔资料
•超负荷运转

把数据分成两半

把数据分成4部分


分片架构介绍
• Mongos 路由节点
    提供集群单一入口
    转发应用端请求
    选择合适数据节点进行读写
    合并多个数据节点的返回
    无状态
    建议至少2个
• Config Servers配置节点
    提供集群元数据存储
    分片数据分布的映射
• Shards 数据节点
    以复制集为单位
    横向扩展
    最大1024分片
    分片之间数据不重复
    所有分片在一起才可完整工作

MongoDB 分片集群特点
• 应用全透明，无特殊处理
• 数据自动均衡
• 动态扩容，无须下线
• 提供三种分片方式


分片集群数据分布方式
• 基于范围
• 基于 Hash
• 基于 zone / tag

基于范围
优点
    片键范围查询性能号 
    优化读
缺点
	数据分布可能不均匀
	容易有热点

基于哈希
优点
	数据分布均匀,写优化
	适用:日志,物联网等高并发场景
缺点:
	范围查询效率低

自定义Zone
	按地区存储到最近的片区
	

## 分片集群搭建

```
#分片规划
10个实例：38017-38026
(1)configserver:
	3台构成的复制集（1主两从，不支持arbiter）38018-38020
(2)shard节点：
    sh1：38021-23 （1主两从，其中一个节点为arbiter，复制集名字sh1）
    sh2：38024-26 （1主两从，其中一个节点为arbiter，复制集名字sh2）
(3)mongos
    38017


#配置过程
a. shard复制集配置：
1. 创建：
mkdir -p /mongodb/38021/conf /mongodb/38021/log /mongodb/38021/data
mkdir -p /mongodb/38022/conf /mongodb/38022/log /mongodb/38022/data
mkdir -p /mongodb/38023/conf /mongodb/38023/log /mongodb/38023/data
mkdir -p /mongodb/38024/conf /mongodb/38024/log /mongodb/38024/data
mkdir -p /mongodb/38025/conf /mongodb/38025/log /mongodb/38025/data
mkdir -p /mongodb/38026/conf /mongodb/38026/log /mongodb/38026/data

2. 配置文件：

sh1:
vi /mongodb/38021/conf/mongodb.conf
===============
根据需求修改相应参数：
systemLog:
  destination: file
  path: /mongodb/38021/log/mongodb.log
  logAppend: true
storage:
  journal:
    enabled: true
  dbPath: /mongodb/38021/data
  directoryPerDB: true
  #engine: wiredTiger
  wiredTiger:
    engineConfig:
      cacheSizeGB: 1
      directoryForIndexes: true
    collectionConfig:
      blockCompressor: zlib
    indexConfig:
      prefixCompression: true
net:
  bindIp: 10.0.0.4,127.0.0.1
  port: 38021
replication:
  oplogSizeMB: 2048
  replSetName: sh1
sharding:
  clusterRole: shardsvr
processManagement:
  fork: true



===============
\cp /mongodb/38021/conf/mongodb.conf /mongodb/38022/conf/
\cp /mongodb/38021/conf/mongodb.conf /mongodb/38023/conf/

sed 's#38021#38022#g' /mongodb/38022/conf/mongodb.conf -i
sed 's#38021#38023#g' /mongodb/38023/conf/mongodb.conf -i

sh2:
vi /mongodb/38024/conf/mongodb.conf
========
根据需求修改相应参数：
systemLog:
  destination: file
  path: /mongodb/38024/log/mongodb.log
  logAppend: true
storage:
  journal:
    enabled: true
  dbPath: /mongodb/38024/data
  directoryPerDB: true
  wiredTiger:
    engineConfig:
      cacheSizeGB: 1
      directoryForIndexes: true
    collectionConfig:
      blockCompressor: zlib
    indexConfig:
      prefixCompression: true
net:
  bindIp: 10.0.0.4,127.0.0.1
  port: 38024
replication:
  oplogSizeMB: 2048
  replSetName: sh2
sharding:
  clusterRole: shardsvr
processManagement:
  fork: true
========


\cp /mongodb/38024/conf/mongodb.conf /mongodb/38025/conf/
\cp /mongodb/38024/conf/mongodb.conf /mongodb/38026/conf/

sed 's#38024#38025#g' /mongodb/38025/conf/mongodb.conf -i
sed 's#38024#38026#g' /mongodb/38026/conf/mongodb.conf -i
# chown -R mongod.mongod /mongodb

3. 所有节点，并搭建复制集：

mongod -f /mongodb/38021/conf/mongodb.conf
mongod -f /mongodb/38022/conf/mongodb.conf
mongod -f /mongodb/38023/conf/mongodb.conf
mongod -f /mongodb/38024/conf/mongodb.conf
mongod -f /mongodb/38025/conf/mongodb.conf
mongod -f /mongodb/38026/conf/mongodb.conf

mongo --port 38021
use admin
config = {_id: 'sh1', members: [
{_id: 0, host: '10.0.0.4:38021'},
{_id: 1, host: '10.0.0.4:38022'},
{_id: 2, host: '10.0.0.4:38023',"arbiterOnly":true}]
}
rs.initiate(config)

mongo --port 38024
use admin
config = {_id: 'sh2', members: [
{_id: 0, host: '10.0.0.4:38024'},
{_id: 1, host: '10.0.0.4:38025'},
{_id: 2, host: '10.0.0.4:38026',"arbiterOnly":true}]
}
rs.initiate(config)

=-=----=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
b.config节点配置：

1. 目录创建：
mkdir -p /mongodb/38018/conf /mongodb/38018/log /mongodb/38018/data
mkdir -p /mongodb/38019/conf /mongodb/38019/log /mongodb/38019/data
mkdir -p /mongodb/38020/conf /mongodb/38020/log /mongodb/38020/data
2. 修改配置文件：
[mongod@server1 ~]$ vi /mongodb/38018/conf/mongodb.conf
systemLog:
  destination: file
  path: /mongodb/38018/log/mongodb.conf
  logAppend: true
storage:
  journal:
    enabled: true
  dbPath: /mongodb/38018/data
  directoryPerDB: true
  #engine: wiredTiger
  wiredTiger:
    engineConfig:
      cacheSizeGB: 0.25
      directoryForIndexes: true
    collectionConfig:
      blockCompressor: zlib
    indexConfig:
      prefixCompression: true
net:
  bindIp: 10.0.0.4,127.0.0.1
  port: 38018
replication:
  oplogSizeMB: 2048
  replSetName: configReplSet
sharding:
  clusterRole: configsvr
processManagement:
  fork: true

---------------------------------------------------------------
\cp /mongodb/38018/conf/mongodb.conf /mongodb/38019/conf/
\cp /mongodb/38018/conf/mongodb.conf /mongodb/38020/conf/

sed 's#38018#38019#g' /mongodb/38019/conf/mongodb.conf -i
sed 's#38018#38020#g' /mongodb/38020/conf/mongodb.conf -i
# chown -R mongod.mongod /mongodb


3. 启动节点，并配置复制集
mongod -f /mongodb/38018/conf/mongodb.conf
mongod -f /mongodb/38019/conf/mongodb.conf
mongod -f /mongodb/38020/conf/mongodb.conf


mongo --port 38018
use admin
config = {_id: 'configReplSet', members: [
{_id: 0, host: '10.0.0.4:38018'},
{_id: 1, host: '10.0.0.4:38019'},
{_id: 2, host: '10.0.0.4:38020'}]
}
rs.initiate(config)


注：configserver 可以是一个节点，官方建议复制集。configserver不能有arbiter。
新版本中，要求必须是复制集。
注：mongodb 3.4之后，虽然要求config server为replica set，但是不支持arbiter

===============================
c. mongos节点配置：
1. 创建目录：
mkdir -p /mongodb/38017/conf /mongodb/38017/log

2配置文件：
vi /mongodb/38017/conf/mongos.conf
systemLog:
  destination: file
  path: /mongodb/38017/log/mongos.log
  logAppend: true
net:
  bindIp: 10.0.0.4,127.0.0.1
  port: 38017
sharding:
  configDB: configReplSet/10.0.0.4:38018,10.0.0.4:38019,10.0.0.4:38020
processManagement:
  fork: true


3. 启动mongos
mongos -f /mongodb/38017/conf/mongos.conf

d. 分片集群操作：
连接到其中一个mongos（10.0.0.4），做以下配置
（1）连接到mongs的admin数据库
# su - mongod
$ mongo 10.0.0.4:38017/admin

（2）添加分片
db.runCommand( { addshard :"sh1/10.0.0.4:38021,10.0.0.4:38022,10.0.0.4:38023",name:"shard1"} )
db.runCommand( { addshard :"sh2/10.0.0.4:38024,10.0.0.4:38025,10.0.0.4:38026",name:"shard2"} )

（3）列出分片
mongos> db.runCommand( { listshards : 1 } )

（4）整体状态查看
mongos> sh.status();

=================================

e. 使用分片集群
##RANGE分片配置及测试
test库下的vast大表进行手工分片

1、激活数据库分片功能
mongo --port 38017 admin
admin> ( { enablesharding : "数据库名称" } )

eg：
# 对test库激活分片功能
admin> db.runCommand( { enablesharding : "test" } )

2、指定分片建对集合分片
eg：范围片键
--创建索引
use test
# 对vast表建索引  id:1表示按顺序 从小到大
> db.vast.ensureIndex( { id: 1 } )

--开启分片
use admin
> db.runCommand( { shardcollection : "test.vast",key : {id: 1} } )


3、集合分片验证
admin> use test

test> for(i=1;i<500000;i++){
db.vast.insert({"id":i,"name":"shenzheng","age":70,"date":new Date()}); }

test> db.vast.stats()

4、分片结果测试

shard1:
mongo --port 38021
db.vast.count();

shard2:
mongo --port 38024
db.vast.count();

----------------------------------------------------
f. Hash分片例子：
对test库下的vast大表进行hash
创建哈希索引
（1）对于test1开启分片功能
mongo --port 38017 admin
use admin
admin> db.runCommand( { enablesharding : "test1" } )

（2）对于test1库下的vast表建立hash索引
use test1
test> db.vast.ensureIndex( { id: "hashed" } )

（3）开启分片
use admin
admin > sh.shardCollection( "test1.vast", { id: "hashed" } )

（4）录入10w行数据测试
use test1
for(i=1;i<100000;i++){
db.vast.insert({"id":i,"name":"shenzheng","age":70,"date":new Date()}); }

（5）hash分片结果测试
mongo --port 38021
use test1
db.vast.count();

mongo --port 38024
use test1
db.vast.count();
---------------------------
g. 分片的管理
1、判断是否Shard集群
admin> db.runCommand({ isdbgrid : 1})

2、列出所有分片信息
admin> db.runCommand({ listshards : 1})

3、列出开启分片的数据库
admin> use config
config> db.databases.find( { "partitioned": true } )
或者：
config> db.databases.find() //列出所有数据库分片情况

4、查看分片的片键
config> db.collections.find().pretty()
{
"_id" : "test.vast",
"lastmodEpoch" : ObjectId("58a599f19c898bbfb818b63c"),
"lastmod" : ISODate("1970-02-19T17:02:47.296Z"),
"dropped" : false,
"key" : {
"id" : 1
},
"unique" : false
}

5、查看分片的详细信息
admin> db.printShardingStatus()
或
admin> sh.status()

6、删除分片节点（谨慎）
（1）确认blance是否在工作
sh.getBalancerState()

（2）删除shard2节点(谨慎)
mongos> db.runCommand( { removeShard: "shard2" } )

注意：删除操作一定会立即触发blancer。

7、balancer操作

介绍：
mongos的一个重要功能，自动巡查所有shard节点上的chunk的情况，自动做chunk迁移。
什么时候工作？
1、自动运行，会检测系统不繁忙的时候做迁移
2、在做节点删除的时候，立即开始迁移工作
3、balancer只能在预设定的时间窗口内运行

有需要时可以关闭和开启blancer（备份的时候）
mongos> sh.stopBalancer()
mongos> sh.startBalancer()

8、自定义 自动平衡进行的时间段
https://docs.mongodb.com/manual/tutorial/manage-sharded-cluster-balancer/#schedule-the-balancing-window
// connect to mongos

mongo --port 38017
use config
sh.setBalancerState( true )
db.settings.update({ _id : "balancer" }, { $set : { activeWindow : { start: "3:00", stop : "5:00" } } }, true )

sh.getBalancerWindow()
sh.status()

```

## 企业中分片集群设计

```
分片的基本标准
• 关于数据：数据量不超过3TB，尽可能保持在2TB一个片；
• 关于索引：常用索引必须容纳进内存；
• 按照以上标准初步确定分片后，还需要考虑业务压力，随着压力增大，CPU、RAM、磁盘中的任何一项
出现瓶颈时，都可以通过添加更多分片来解决。

如何粗略判断需要多少分片
条件                                     分片个数
B : 工作集大小 / 单服务器内存容量           400GB / （256G * 0.6） = 3
A : 所需存储总量 / 单服务器可挂载容量        8TB / 2TB = 4
C : 并发量总数 /（单服务器并发量 * 0.7）     30000 / (9000*0.7) = 6
D: 额外开销 ？															?
分片数量 = max(A, B, C)+D =?

额外的考量
考虑分片的分布：
• 是否需要跨机房分布分片？
• 是否需要容灾？
• 高可用的要求如何?

选择片键的正确姿势
影响片键效率的主要因素：
• 取值基数（Cardinality）；
• 取值分布；
• 分散写，集中读；
• 被尽可能多的业务场景用到；
• 避免单调递增或递减的片键；

a. 选择基数大的片键
对于小基数的片键：
• 因为备选值有限，那么块的总数量就有限；
• 随着数据增多，块的大小会越来越大；
• 水平扩展时移动块会非常困难；
例如：存储一个高中的师生数据，以年龄（假设年龄范围为15~65岁）作为片键，
15<=年龄<=65，且只为整数,所以最多只会有51个 chunk
结论：取值基数要大！

b.选择分布均匀的片键
对于分布不均匀的片键：
• 造成某些块的数据量急剧增大
• 这些块压力随之增大
• 数据均衡以 chunk 为单位，所以系统无能为力 • 例如：存储一个学校的师生数据，以年龄（假设年
龄范围为15~65岁）作为片键，
那么：
• 15<=年龄<=65，且只为整数
• 大部分人的年龄范围为15~18岁（学生） • 15、16、17、18四个 chunk 的数据量、访问压力远大
于其他 chunk
结论：取值分布应尽可能均匀

c. 通过一个例子来看片键选择
{
_id: ObjectId(),
user: 123,
time: Date(),
subject: “...”,
recipients: [],
body: “...”,
attachments: []
}

选择片键： { _id: 1}
  基数  ✔
  写分布
  定向查询

选择片键： { _id: ”hashed”}
	基数  ✔
	写分布 ✔
	定向查询
	
选择片键： { user_id: 1 }
	基数
	写分布 ✔
	定向查询  ✔
	
选择片键： { user_id: 1, time:1 }
		基数  ✔
	  写分布 ✔
	  定向查询  ✔
	
如何规划硬件
• mongos 与 config 通常消耗很少的资源，可以选择低规格虚拟机；
• 资源的重点在于 shard 服务器：
• 需要足以容纳热数据索引的内存；
• 正确创建索引后 CPU 通常不会成为瓶颈，除非涉及非常多的计算；
• 磁盘尽量选用 SSD；
实际测试是最好的检验，来看你的资源配置是否完备。
另外，即使项目初期已经具备了足够的资源，仍然需要考虑在合适的时候扩展。建议监控
各项资源使用情况，无论哪一项达到60%以上，则开始考虑扩展。
• 扩展需要新的资源，申请新资源需要时间；
• 扩展后数据需要均衡，均衡需要时间。应保证新数据入库速度慢于均衡速度
• 均衡需要资源，如果资源即将或已经耗尽，均衡也是会很低效的。

```

## 高级集群设计：两地三中心

```
两地三中心规划及实施
a. 准备虚拟机及数据库实例
1. 规划
# 10.0.0.4   #北京海淀DC
primary:10.0.0.4:10001
s1 :10.0.0.4:10002

# 10.0.0.5  #北京亦庄DC
s3 :10.0.0.5:10003
s4 :10.0.0.5:10004

# 10.0.0.6  #上海浦东DC
s5 :10.0.0.6:10005


2. 准备实例
# 配置文件-db01
su - mongod
mkdir -p /mongodb/10001/conf /mongodb/10001/data /mongodb/10001/log
mkdir -p /mongodb/10002/conf /mongodb/10002/data /mongodb/10002/log
cat > /mongodb/10001/conf/mongod.conf <<EOF
systemLog:
  destination: file
  path: /mongodb/10001/log/mongodb.log
  logAppend: true
storage:
  journal:
    enabled: true
  dbPath: /mongodb/10001/data
  directoryPerDB: true
  #engine: wiredTiger
  wiredTiger:
    engineConfig:
      cacheSizeGB: 0.5
      directoryForIndexes: true
    collectionConfig:
      blockCompressor: zlib
    indexConfig:
      prefixCompression: true
processManagement:
  fork: true
net:
  port: 10001
  bindIp: 10.0.0.4,127.0.0.1
replication:
  oplogSizeMB: 2048
  replSetName: my_repl
EOF

\cp /mongodb/10001/conf/mongod.conf /mongodb/10002/conf/
sed 's#10001#10002#g' /mongodb/10002/conf/mongod.conf -i

mongod -f /mongodb/10001/conf/mongod.conf
mongod -f /mongodb/10002/conf/mongod.conf


# 配置文件-db02
su - mongod
mkdir -p /mongodb/10003/conf /mongodb/10003/data /mongodb/10003/log
mkdir -p /mongodb/10004/conf /mongodb/10004/data /mongodb/10004/log
cat > /mongodb/10003/conf/mongod.conf <<EOF
systemLog:
  destination: file
  path: /mongodb/10003/log/mongodb.log
  logAppend: true
storage:
  journal:
    enabled: true
  dbPath: /mongodb/10003/data
  directoryPerDB: true
  #engine: wiredTiger
  wiredTiger:
    engineConfig:
      cacheSizeGB: 0.5
      directoryForIndexes: true
    collectionConfig:
      blockCompressor: zlib
    indexConfig:
      prefixCompression: true
processManagement:
  fork: true
net:
  port: 10003
  bindIp: 10.0.0.5,127.0.0.1
replication:
  oplogSizeMB: 2048
  replSetName: my_repl
EOF

\cp /mongodb/10003/conf/mongod.conf /mongodb/10004/conf/
sed 's#10003#10004#g' /mongodb/10004/conf/mongod.conf -i

mongod -f /mongodb/10003/conf/mongod.conf
mongod -f /mongodb/10004/conf/mongod.conf


# 配置文件-db03
su - mongod
mkdir -p /mongodb/10005/conf /mongodb/10005/data /mongodb/10005/log
cat > /mongodb/10005/conf/mongod.conf <<EOF
systemLog:
  destination: file
  path: /mongodb/10005/log/mongodb.log
  logAppend: true
storage:
  journal:
    enabled: true
  dbPath: /mongodb/10005/data
  directoryPerDB: true
  #engine: wiredTiger
  wiredTiger:
    engineConfig:
      cacheSizeGB: 0.5
      directoryForIndexes: true
    collectionConfig:
      blockCompressor: zlib
    indexConfig:
      prefixCompression: true
processManagement:
  fork: true
net:
  port: 10005
  bindIp: 10.0.0.6,127.0.0.1
replication:
  oplogSizeMB: 2048
  replSetName: my_repl
EOF

mongod -f /mongodb/10005/conf/mongod.conf

//主节点配置复制集
mongo --port 10001
use admin
config = {_id: 'my_repl', members: [
{_id: 0, host: '10.0.0.4:10001'},
{_id: 1, host: '10.0.0.4:10002'},
{_id: 2, host: '10.0.0.5:10003'},
{_id: 3, host: '10.0.0.5:10004'},
{_id: 4, host: '10.0.0.6:10005'}
]}
rs.initiate(config)
rs.status()

b. 两地三中心定制化配置
// 主库宕机后,选举新主库的 优先级
cfg = rs.conf()
cfg.members[1].priority = 20
cfg.members[2].priority = 10
cfg.members[3].priority = 10
rs.reconfig(cfg)

c. 复制集安全加固
# db01 主节点
openssl rand -base64 756 > /mongodb/10001/conf/keyfile
cp -a /mongodb/10001/conf/keyfile /mongodb/10002/conf
chmod 600 /mongodb/10001/conf/keyfile /mongodb/10002/conf/keyfile
scp -p /mongodb/10001/conf/keyfile 10.0.0.5:/mongodb/10003/conf
scp -p /mongodb/10001/conf/keyfile 10.0.0.5:/mongodb/10004/conf
scp -p /mongodb/10001/conf/keyfile 10.0.0.6:/mongodb/10005/conf

每个节点开启验证：
# db01
cat >> /mongodb/10001/conf/mongod.conf<<EOF
security:
  keyFile: /mongodb/10001/conf/keyfile
EOF
cat >>/mongodb/10002/conf/mongod.conf<<EOF
security:
  keyFile: /mongodb/10002/conf/keyfile
EOF
# db02
cat >> /mongodb/10003/conf/mongod.conf <<EOF
security:
  keyFile: /mongodb/10003/conf/keyfile
EOF
cat >> /mongodb/10004/conf/mongod.conf <<EOF
security:
  keyFile: /mongodb/10004/conf/keyfile
EOF
# db03
cat >> /mongodb/10005/conf/mongod.conf <<EOF
security:
  keyFile: /mongodb/10005/conf/keyfile
EOF

---------------------------------------------------------------
// 重启生效上面的配置  ,从库先停
mongo --port 10005
mongo --port 10004
mongo --port 10003
mongo --port 10002
mongo --port 10001
//上面所有节点都执行关机
use admin
db.shutdownServer()

+++++
Shut down each mongod in the replica set, starting with the secondaries.
Continue until all members of the replica set are offline, including any
arbiters. The primary must be the last member shut down to avoid potential
rollbacks.
+++++

//再启动
mongod -f /mongodb/10001/conf/mongod.conf
mongod -f /mongodb/10002/conf/mongod.conf

mongod -f /mongodb/10003/conf/mongod.conf
mongod -f /mongodb/10004/conf/mongod.conf

mongod -f /mongodb/10005/conf/mongod.conf


启动所有节点，在主节点添加用户：
[mongod@db01 ~]$ mongo --port 10002
my_repl:PRIMARY>
use admin
db.createUser(
{
user: "root",
pwd: "root123",
roles: [ { role: "root", db: "admin" } ]
}
)
//上面创建新用户方式 密码暴露了

手工交互式输入密码
[mongod@db01 ~]$ mongo --port 10002 -uroot -proot123
use admin
db.createUser(
{
user: "root1",
pwd: passwordPrompt(),
roles: [ { role: "root", db: "admin" } ]
})

手工交互式验证
my_repl:PRIMARY> use admin
switched to db admin
my_repl:PRIMARY> db.auth("root1",passwordPrompt())
Enter password:


```


## 高级集群设计: 全球多写

```
db01 中国区用户
db02 北美区用户

# db01:
su - mongod
mkdir -p /mongodb/20001/conf /mongodb/20001/data /mongodb/20001/log
mkdir -p /mongodb/20002/conf /mongodb/20002/data /mongodb/20002/log
mkdir -p /mongodb/20003/conf /mongodb/20003/data /mongodb/20003/log
cat > /mongodb/20001/conf/mongod.conf <<EOF
systemLog:
  destination: file
  path: /mongodb/20001/log/mongodb.log
  logAppend: true
storage:
  journal:
    enabled: true
  dbPath: /mongodb/20001/data
  directoryPerDB: true
  #engine: wiredTiger
  wiredTiger:
    engineConfig:
      cacheSizeGB: 0.5
      directoryForIndexes: true
    collectionConfig:
      blockCompressor: zlib
    indexConfig:
      prefixCompression: true
processManagement:
  fork: true
net:
  port: 20001
  bindIp: 10.0.0.4,127.0.0.1
replication:
  oplogSizeMB: 2048
  replSetName: CN_sh
sharding:
  clusterRole: shardsvr
EOF

\cp /mongodb/20001/conf/mongod.conf /mongodb/20002/conf/
\cp /mongodb/20001/conf/mongod.conf /mongodb/20003/conf/
sed 's#20001#20002#g' /mongodb/20002/conf/mongod.conf -i
sed 's#20001#20003#g' /mongodb/20003/conf/mongod.conf -i
sed 's#CN_sh#US_sh#g' /mongodb/20003/conf/mongod.conf -i


mongod -f /mongodb/20001/conf/mongod.conf
mongod -f /mongodb/20002/conf/mongod.conf
mongod -f /mongodb/20003/conf/mongod.conf


# db02:
su - mongod
mkdir -p /mongodb/20001/conf /mongodb/20001/data /mongodb/20001/log
mkdir -p /mongodb/20002/conf /mongodb/20002/data /mongodb/20002/log
mkdir -p /mongodb/20003/conf /mongodb/20003/data /mongodb/20003/log
cat > /mongodb/20001/conf/mongod.conf <<EOF
systemLog:
  destination: file
  path: /mongodb/20001/log/mongodb.log
  logAppend: true
storage:
  journal:
    enabled: true 
  dbPath: /mongodb/20001/data
  directoryPerDB: true
  #engine: wiredTiger
  wiredTiger:
    engineConfig:
      cacheSizeGB: 0.5
      directoryForIndexes: true
    collectionConfig:
      blockCompressor: zlib
    indexConfig:
      prefixCompression: true
processManagement:
  fork: true
net:
  port: 20001
  bindIp: 10.0.0.5,127.0.0.1
replication:
  oplogSizeMB: 2048
  replSetName: US_sh
sharding:
  clusterRole: shardsvr
EOF

\cp /mongodb/20001/conf/mongod.conf /mongodb/20002/conf/
\cp /mongodb/20001/conf/mongod.conf /mongodb/20003/conf/
sed 's#20001#20002#g' /mongodb/20002/conf/mongod.conf -i
sed 's#20001#20003#g' /mongodb/20003/conf/mongod.conf -i
sed 's#US_sh#CN_sh#g' /mongodb/20003/conf/mongod.conf -i


mongod -f /mongodb/20001/conf/mongod.conf
mongod -f /mongodb/20002/conf/mongod.conf
mongod -f /mongodb/20003/conf/mongod.conf

# db01:
mkdir -p /mongodb/20004/conf /mongodb/20004/data /mongodb/20004/log
mkdir -p /mongodb/20005/conf /mongodb/20005/data /mongodb/20005/log
mkdir -p /mongodb/20006/conf /mongodb/20006/data /mongodb/20006/log
cat > /mongodb/20004/conf/mongod.conf <<EOF
systemLog:
  destination: file
  path: /mongodb/20004/log/mongodb.log
  logAppend: true
storage:
  journal:
    enabled: true
  dbPath: /mongodb/20004/data
  directoryPerDB: true
  #engine: wiredTiger
  wiredTiger:
    engineConfig:
      cacheSizeGB: 0.5
      directoryForIndexes: true
    collectionConfig:
      blockCompressor: zlib
    indexConfig:
      prefixCompression: true
processManagement:
  fork: true
net:
  port: 20004
  bindIp: 10.0.0.4,127.0.0.1
replication:
  oplogSizeMB: 2048
  replSetName: config
sharding:
  clusterRole: configsvr
EOF

\cp /mongodb/20004/conf/mongod.conf /mongodb/20005/conf/
\cp /mongodb/20004/conf/mongod.conf /mongodb/20006/conf/
sed 's#20004#20005#g' /mongodb/20005/conf/mongod.conf -i
sed 's#20004#20006#g' /mongodb/20006/conf/mongod.conf -i

mongod -f /mongodb/20004/conf/mongod.conf
mongod -f /mongodb/20005/conf/mongod.conf
mongod -f /mongodb/20006/conf/mongod.conf

复制集配置
# db01
mongo --port 20001
config = {_id: 'CN_sh', members: [
{_id: 0, host: '10.0.0.4:20001'},
{_id: 1, host: '10.0.0.4:20002'},
{_id: 2, host: '10.0.0.5:20003'}]
}
rs.initiate(config)

#db02
mongo --port 20001
config = {_id: 'US_sh', members: [
{_id: 0, host: '10.0.0.5:20001'},
{_id: 1, host: '10.0.0.5:20002'},
{_id: 2, host: '10.0.0.4:20003'}]
}
rs.initiate(config)

#db01
mongo --port 20004
config = {_id: 'config', members: [
{_id: 0, host: '10.0.0.4:20004'},
{_id: 1, host: '10.0.0.4:20005'},
{_id: 2, host: '10.0.0.4:20006'}]
}
rs.initiate(config)


# mongos配置
#db01
mkdir -p /mongodb/20010/conf /mongodb/20010/log

cat > /mongodb/20010/conf/mongos.conf<<EOF
systemLog:
  destination: file
  path: /mongodb/20010/log/mongos.log
  logAppend: true
net:
  bindIp: 10.0.0.4,127.0.0.1
  port: 20010
sharding:
  configDB: config/10.0.0.4:20004,10.0.0.4:20005,10.0.0.4:20006
processManagement:
  fork: true
EOF

mongos -f /mongodb/20010/conf/mongos.conf

#db02
mkdir -p /mongodb/20011/conf /mongodb/20011/log

cat> /mongodb/20011/conf/mongos.conf <<EOF
systemLog:
  destination: file
  path: /mongodb/20011/log/mongos.log
  logAppend: true
net:
  bindIp: 10.0.0.5,127.0.0.1
  port: 20011
sharding:
  configDB: config/10.0.0.4:20004,10.0.0.4:20005,10.0.0.4:20006
processManagement:
  fork: true
EOF
mongos -f /mongodb/20011/conf/mongos.conf

#db01 
mongo --port 20010
use admin
//添加分片
db.runCommand( { addshard :"CN_sh/10.0.0.4:20001,10.0.0.4:20002,10.0.0.5:20003",name:"CN_sh"} )
db.runCommand( { addshard :"US_sh/10.0.0.5:20001,10.0.0.5:20002,10.0.0.4:20003",name:"US_sh"} )


//为两个分片打个标签
sh.addShardTag("CN_sh", "ASIA")
sh.addShardTag("US_sh", "AMERICA")

//分片策略
mongos> db.runCommand({ enablesharding: "crm"})
sh.addTagRange( "crm.orders", 
{ "locationCode" : "CN", "order_id" : MinKey},
{ "locationCode" : "CN", "order_id" : MaxKey },
"ASIA" )

sh.addTagRange( "crm.orders",
{ "locationCode" : "US", "order_id" : MinKey },
{ "locationCode" : "US", "order_id" : MaxKey },
"AMERICA" )

sh.addTagRange( "crm.orders",
{ "locationCode" : "CA", "order_id" : MinKey },
{ "locationCode" : "CA", "order_id" : MaxKey },
"AMERICA" )

sh.status()

#插入数据需要的列 crm库下的 orders表  order_id,order_name,locationCode


```

## mongodb 备份与恢复及迁移

#备份恢复工具介绍:
（1）** mongoexport/mongoimport
（2）***** mongodump/mongorestore

#备份工具区别?
mongoexport/mongoimport 导入/导出的是JSON格式或者CSV格式，
mongodump/mongorestore 导入/导出的是BSON格式。

应用场景:
mongoexport/mongoimport: json csv
1、异构平台迁移 mysql <---> mongodb
2、同平台，跨大版本：mongodb 2 ----> mongodb 3

mongodump/mongorestore
日常备份恢复时使用.

### 导出工具mongoexport

```
#导出工具mongoexport
Mongodb中的mongoexport工具可以把一个collection导出成JSON格式或CSV格式的文件。
可以通过参数指定导出的数据项，也可以根据指定的条件导出数据。
（1）版本差异较大
（2）异构平台数据迁移
mongoexport具体用法如下所示：
$ mongoexport --help
参数说明：
-h:指明数据库宿主机的IP
-u:指明数据库的用户名
-p:指明数据库的密码
-d:指明数据库的名字
-c:指明collection的名字
-f:指明要导出那些列
-o:指明到要导出的文件名
-q:指明导出数据的过滤条件
--authenticationDatabase admin

#启动一台单机玩
[mongod@db01 ~]$ cat /mongodb/conf/mongo.conf
systemLog:
   destination: file
   path: "/mongodb/log/mongodb.log"
   logAppend: true
storage:
   journal:
      enabled: true
   dbPath: "/mongodb/data/"
processManagement:
   fork: true
net:
   port: 27017
   bindIp: 10.0.0.4,127.0.0.1
security:
   authorization: enabled
[mongod@db01 ~]$ mongod -f /mongodb/conf/mongo.conf


1.单表备份至json格式
[mongod@db01 ~]$ mongo -uroot -proot123 --port 27017 admin
use test
for(i=0;i<10000;i++){
db.log.insert({"uid":i,"name":"mongodb","age":6,"date":new Date()}); }\

mongoexport -uroot -proot123 --port 27017 --authenticationDatabase admin -d test -c log -o /mongodb/log.json

注：备份文件的名字可以自定义，默认导出了JSON格式的数据。
2. 单表备份至csv格式
如果我们需要导出CSV格式的数据，则需要使用--type=csv参数：
mongoexport -uroot -proot123 --port 27017 --authenticationDatabase admin -d test -c log --type=csv -f uid,name,age,date -o /mongodb/log.csv


#导入工具mongoimport
Mongodb中的mongoimport工具可以把一个特定格式文件中的内容导入到指定的collection中。该
工具可以导入JSON格式数据，也可以导入CSV格式数据。具体使用如下所示：
$ mongoimport --help
参数说明：
-h:指明数据库宿主机的IP
-u:指明数据库的用户名
-p:指明数据库的密码
-d:指明数据库的名字
-c:指明collection的名字
-f:指明要导入那些列
-j, --numInsertionWorkers=<number> number of insert operations to run
concurrently (defaults to 1)
//并行

数据恢复:
1.恢复json格式表数据到log1
mongoimport -uroot -proot123 --port 27017 --authenticationDatabase admin -d test -c log /mongodb/log.json

#上面导入id冲突, --drop 是把之前的的表数据删除掉 覆盖导入
mongoimport -uroot -proot123 --port 27017 --authenticationDatabase admin --drop -d test -c log1 /mongodb/log.json

# -j 2 并发
mongoimport -uroot -proot123 --port 27017 --authenticationDatabase admin -j 2 -d test -c log2 /mongodb/log.json

2.恢复csv格式的文件到log2
上面演示的是导入JSON格式的文件中的内容，如果要导入CSV格式文件中的内容，则需要通过--type
参数指定导入格式，具体如下所示：
错误的恢复

注意：
（1）csv格式的文件头行，有列名字
mongoimport -uroot -proot123 --port 27017 --authenticationDatabase admin -d test -c log2 --type=csv --headerline --file /mongodb/log.csv
（2）csv格式的文件头行，没有列名字
mongoimport -uroot -proot123 --port 27017 --authenticationDatabase admin -d test -c log3 -j 4 --type=csv -f id,name,age,date --file /mongodb/log.csv

--headerline:指明第一行是列名，不需要导入。

3. 异构平台迁移案例
mysql -----> mongodb
world数据库下city表进行导出，导入到mongodb

（1）mysql开启安全路径
vim /etc/my.cnf --->添加以下配置
secure-file-priv=/tmp/
--重启数据库生效
/etc/init.d/mysqld restart

（2）导出mysql的city表数据
select * from test.t100w into outfile '/tmp/t100w.csv' fields terminated by ',' ENCLOSED BY '"' ;

（3）获取列信息
mysql> select table_name,group_concat(column_name) from
information_schema.columns where table_schema='test' group by table_name
order by null ;
+------------+---------------------------+
| TABLE_NAME | group_concat(column_name) |
+------------+---------------------------+
| t100w | dt,id,k1,k2,num |
+------------+---------------------------+
1 row in set (0.07 sec)

(4)在mongodb中导入备份
mongoimport -uroot -proot123 --port 27017 --authenticationDatabase admin -d
test -c t100w --type=csv -f id,num，k1,k2,,dt --file /tmp/t100w.csv
use world
db.t100w.find({});

4. 彩蛋————如何将MySQL大量表迁移到MongoDB
痛点：
（1） 批量从MySQL导出多张表
mysqldump --fields-terminated-by ',' --fields-enclosed-by '"' world -T /tmp/
cd /data/backup
rm -rf /data/backup/*.sql
find ./ -name "*.txt" | awk -F "." '{print $2}' | xargs -i -t mv ./{}.txt ./{}.csv

(2) 拼接语句
select concat("mongoimport -uroot -proot123 --port 27017 --authenticationDatabase admin -d ",table_schema, " -c ",table_name ," --type=csv "," -f ", group_concat(column_name) ," --file /data/backup/",table_name ,".csv") from information_schema.columns where table_schema='world' group by table_name;

(3) 导入数据
[mongod@db01 backup]$ ll
total 256
-rwxrwxrwx 1 mysql mysql 184355 Jul 22 13:45 city.csv
-rwxrwxrwx 1 mysql mysql 38659 Jul 22 13:45 country.csv
-rwxrwxrwx 1 mysql mysql 26106 Jul 22 13:45 countrylanguage.csv
-rwxrwxrwx 1 mysql mysql 656 Jul 22 13:45 import.sh
[mongod@db01 backup]$ sh import.sh


```

### mongodump和mongorestore

```
#a介绍
mongodump能够在Mongodb运行时进行备份，它的工作原理是对运行的Mongodb做查询，然后将所有查
到的文档写入磁盘。但是存在的问题时使用mongodump产生的备份不一定是数据库的实时快照，如果我
们在备份时对数据库进行了写入操作，则备份出来的文件可能不完全和Mongodb实时数据相等。另外在备
份时可能会对其它客户端性能产生不利的影响。

#b. mongodump参数
$ mongodump --help
参数说明：
-h:指明数据库宿主机的IP
-u:指明数据库的用户名
-p:指明数据库的密码
-d:指明数据库的名字
-c:指明collection的名字
-o:指明到要导出的文件名
-q:指明导出数据的过滤条件
-j, --numParallelCollections= number of collections to dump in parallel (4
by default)
--oplog 备份的同时备份oplog

#c. mongodump和mongorestore基本使用
全库备份
mkdir /mongodb/backup -p
mongodump -uroot -proot123 --port 27017 --authenticationDatabase admin -o /mongodb/backup

--备份test库
$ mongodump -uroot -proot123 --port 27017 --authenticationDatabase admin -d test -o /mongodb/backup/

--备份test库下的log集合
$ mongodump -uroot -proot123 --port 27017 --authenticationDatabase admin -d test -c log -o /mongodb/backup/

--压缩备份
$ mongodump -uroot -proot123 --port 27017 --authenticationDatabase admin -d abc -o /mongodb/backup/ --gzip

mongodump -uroot -proot123 --port 27017 --authenticationDatabase admin -o /mongodb/backup/ --gzip

$ mongodump -uroot -proot123 --port 27017 --authenticationDatabase admin -d app -c vast -o /mongodb/backup/ --gzip

--全库恢复  覆盖恢复 admin后面添加参数 -drop
$ mongorestore -uroot -proot123 --port 27017 --authenticationDatabase admin  /mongodb/backup/

--全备中恢复单库
$ mongorestore -uroot -proot123 --port 27017 --authenticationDatabase admin -d world1 /mongodb/backup/world

--全备中恢复单表
[mongod@db01 backup]$ mongorestore -uroot -proot123 --port 27017 --authenticationDatabase admin -d a -c t1 /mongodb/backup/world/t5.bson.gz --gzip

--drop表示恢复的时候把之前的集合drop掉(危险)
$ mongorestore -uroot -proot123 --port 27017 --authenticationDatabase admin -d test --drop /mongodb/backup/test

#d. mongodump和mongorestore高级企业应用（--oplog）
注意：这是replica set模式专用
--oplog
use oplog for taking a point-in-time snapshot

# oplog介绍
在replica set中oplog是一个定容集合（capped collection），它的默认大小是磁盘空间的
5%（可以通过--oplogSizeMB参数修改）.

位于local库的db.oplog.rs，有兴趣可以看看里面到底有些什么内容。
其中记录的是整个mongod实例一段时间内数据库的所有变更（插入/更新/删除）操作。
当空间用完时新记录自动覆盖最老的记录。
其覆盖范围被称作oplog时间窗口。需要注意的是，因为oplog是一个定容集合，
所以时间窗口能覆盖的范围会因为你单位时间内的更新次数不同而变化。
想要查看当前的oplog时间窗口预计值，可以使用以下命令：

mongod -f /mongodb/28017/conf/mongod.conf
mongod -f /mongodb/28018/conf/mongod.conf
mongod -f /mongodb/28019/conf/mongod.conf
mongod -f /mongodb/28020/conf/mongod.conf

use local
db.oplog.rs.find().pretty()

  "ts" : Timestamp(1553597844, 1),
  "op" : "n"
  "o" :
  
  "i": insert
  "u": update
  "d": delete
  "c": db cmd

test:PRIMARY> rs.printReplicationInfo()
configured oplog size: 1561.5615234375MB <--集合大小
log length start to end: 423849secs (117.74hrs) <--预计窗口覆盖时间
oplog first event time: Wed Sep 09 2015 17:39:50 GMT+0800 (CST)
oplog last event time: Mon Sep 14 2015 15:23:59 GMT+0800 (CST)
now: Mon Sep 14 2015 16:37:30 GMT+0800 (CST)

# oplog企业级应用
（1）实现热备，在备份时使用--oplog选项
注：为了演示效果我们在备份过程，模拟数据插入
（2）准备测试数据
use test

for(var i = 1 ;i < 100; i++) {
db.foo.insert({a:i});
}

my_repl:PRIMARY> db.oplog.rs.find({"op":"i"}).pretty()


oplog 配合mongodump实现热备
mongodump -uroot -proot123 --port 28017 --authenticationDatabase admin --oplog -o /mongodb/backup

作用介绍：--oplog 会记录备份过程中的数据变化。会以oplog.bson保存下来

恢复
mongorestore --port 28017 --oplogReplay /mongodb/backup

!!!!!!!!!!oplog高级应用 ==========binlog应用

背景：每天0点全备，oplog恢复窗口为48小时
某天，上午10点world.city 业务表被误删除。

恢复思路：
0、停应用
2、找测试库
3、恢复昨天晚上全备
4、截取全备之后到world.city误删除时间点的oplog，并恢复到测试库
5、将误删除表导出，恢复到生产库

恢复步骤：
模拟故障环境：
1、全备数据库
模拟原始数据
mongo --port 28017
use wo
for(var i = 1 ;i < 20; i++) {
db.ci.insert({a: i});
}

全备:
rm -rf /mongodb/backup/*
mongodump --port 28017 --oplog -o /mongodb/backup
--oplog功能:在备份同时,将备份过程中产生的日志进行备份
文件必须存放在/mongodb/backup下,自动命令为oplog.bson
再次模拟数据
db.ci1.insert({id:1})
db.ci2.insert({id:2})
2、上午10点：删除wo库下的ci表
10:00时刻,误删除

db.ci.drop()
show tables;

3、备份现有的oplog.rs表
mongodump --port 28017 -d local -c oplog.rs -o /mongodb/backup

4、截取oplog并恢复到drop之前的位置
更合理的方法：登陆到原数据库
[mongod@db03 local]$ mongo --port 28017
my_repl:PRIMARY> use local
db.oplog.rs.find({op:"c"}).pretty();
{
  "ts" : Timestamp(1600489082, 1),
  "t" : NumberLong(1),
  "h" : NumberLong(0),
  "v" : 2,
  "op" : "c",
  "ns" : "wo.$cmd",
  "ui" : UUID("875f2a41-57e3-4b6b-b738-469fad032b18"),
  "o2" : {
  "numRecords" : 19
  },
  "wall" : ISODate("2020-09-19T04:18:02.717Z"),
  "o" : {
  "drop" : "ci"
	}
}

获取到oplog误删除时间点位置:
1600489082, 1

5、恢复备份+应用oplog

[mongod@db03 backup]$ cd /mongodb/backup/local/
[mongod@db03 local]$ ls
oplog.rs.bson oplog.rs.metadata.json
[mongod@db03 local]$ cp oplog.rs.bson ../oplog.bson
rm -rf /mongodb/backup/local/

mongorestore --port 28017 --oplogReplay --oplogLimit "1600489082:1" --
drop /mongodb/backup/


6. 分片集群的备份思路
6.1 需要备份的数据
shard 、 configserver

6.2 痛点
chunk 迁移 ，关闭或者调整balancer时间窗口
备份出来的数据时间不一致。

6.3
a.使用Ops Manager    #商用版
b.
balancer 关闭--->
同一时刻config、shard其中一个节点脱离集群--->
开始备份节点数据 --->
把节点恢复到集群

PSS
PSA



```

