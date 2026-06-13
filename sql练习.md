



```sql


wget https://static.jyshare.com/download/websites.sql
wget https://static.jyshare.com/download/access_log.sql
wget https://static.jyshare.com/download/apps.sql

curl -s https://static.jyshare.com/download/access_log.sql | mysql -uroot -p123 runoob
curl -s https://static.jyshare.com/download/apps.sql | mysql -uroot -p123 runoob
curl -s https://static.jyshare.com/download/websites.sql | mysql -uroot -p123 runoob

-- 规范库名：小写、下划线、业务前缀，指定字符集+排序规则
CREATE DATABASE IF NOT EXISTS biz_user
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_unicode_ci;

企业分两类场景：
日常开发（Navicat/DBeaver/Workbench）：可视化点选自动生成建库语句，不用手敲
上线发布 / 脚本版本管理：必须手写 SQL 文件，工具生成的语句复制后标准化修改提交 git

create database RUNOOB default character set utf8mb4 default collate utf8mb4_unicode_ci;

utf8mb4：绑定字符集，支持 emoji、全量 Unicode
unicode：遵循标准 UCA Unicode 排序算法，多语言排序精准
ci = case insensitive：字符串查询 / 排序不区分大小写（A=a、B=b）
对象				大小写控制项
库名、表名          lower_case_table_names
字段名称			固定不区分大小写，无参数控制
字段存储的字符串数据	对应字段 / 库 collate 排序规则

# vim /etc/my.cnf 
[mysqld]
#企业设置 库名 表名 不区分大小写
lower_case_table_names=1

/etc/init.d/mysql.server restart 
之前大写库名怎么办?
-- 1.新建小写库
CREATE DATABASE runoob DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- 2.把大写库所有表迁移到小写库
RENAME TABLE `RUNOOB`.t1 TO runoob.t1;
-- 3.迁移完删除旧大写库
DROP DATABASE RUNOOB;



show collation;
show charset;

mysql.sock [(none)]>SHOW VARIABLES LIKE 'character_set%';
+--------------------------+-------------------------------------------+
| Variable_name            | Value                                     |
+--------------------------+-------------------------------------------+
| character_set_client     | utf8                                      |
| character_set_connection | utf8                                      |
| character_set_database   | utf8mb4                                   |
| character_set_filesystem | binary                                    |
| character_set_results    | utf8                                      |
| character_set_server     | utf8mb4                                   |
| character_set_system     | utf8                                      |
| character_sets_dir       | /application/mysql-5.6.40/share/charsets/ |

character_set_server=utf8mb4
全局默认库字符集，新建库没指定字符集时自动用它。
character_set_client=utf8
客户端发给 MySQL 数据用的编码。
character_set_connection=utf8
客户端→服务端中间转码编码。
character_set_results=utf8
MySQL 返回查询结果给客户端的编码。

-- 交互会话临时修改成 utf8mb4 -- 三个会话参数都修改了
set names utf8mb4;

vi /etc/my.cnf
[mysql]
default-character-set=utf8mb4


mysql -uroot -p123 runoob < /root/websites.sql
mysql -uroot -p123 runoob < /root/access_log.sql
mysql -uroot -p123 runoob < /root/apps.sql
mysql> source /root/apps.sql
mysql.sock [(none)]>system ls -l /root/


use runoob;show tables; select * from websites;
show tables from runoob;



一些最重要的 SQL 命令
SELECT - 从数据库中提取数据
select column_name(s) from table_name where condition order by column_name asc|desc

UPDATE - 更新数据库中的数据

update table_name set coumne1=value1,... where condition

DELETE - 从数据库中删除数据
delete from table_name where condition

INSERT INTO - 向数据库中插入新数据
insert into table_name(column1,column2...) values(value1,value2....)

CREATE DATABASE - 创建新数据库

ALTER DATABASE - 修改数据库

CREATE TABLE - 创建新表
create table table_name(
	column1 data_type constraint,
    column2 data_type constraint,
);

ALTER TABLE - 变更（改变）数据库表
alter table table_name add column_name data_type;
alter table table_name drop column column_name;

DROP TABLE - 删除表
drop table table_name;

CREATE INDEX - 创建索引（搜索键）
create index index_name on table_name(column_name);

DROP INDEX - 删除索引
drop index index_name from table_name

where 
select column(s) from table_name where condition;

order by用于对结果集进行排序。
select column(s) from table_name order by asc|desc

group by 用于将结果集按一列或多列进行分组。
select column(s), aggregate_function(column_name) from table_name where condition group by column_name(s)

HAVING：用于对分组后的结果集进行筛选。
select column(s), aggregate_function(column_name) from table_name where condition group by column_name(s) having condition

JOIN：用于将两个或多个表的记录结合起来。
select column(s) from table_name1 join table_name2 on table_name1.column_name=table_name2.column_name

DISTINCT：用于返回唯一不同的值。
select distinct from table_name


select * from runoob.websites; select distinct country from websites;

select * from websites where country='cn';
where 条件有哪些?
=	等于
<>	不等于。注释：在 SQL 的一些版本中，该操作符可被写成 !=
>	大于
<	小于
>=	大于等于
<=	小于等于
BETWEEN	在某个范围内
LIKE	搜索某种模式
IN	指定针对某个列的多个可能值

select * from runoob.websites where alexa>50 and country='CN';
select * from runoob.websites where country='usa' or country='cn';
select * from runoob.websites where alexa>15 and (country='usa' or country='cn');
select * from runoob.websites order by alexa;
select * from runoob.websites order by alexa desc;

排序逻辑（多字段分层排序）
先按第 1 列 country 整体排序；country 值相同的行，再用第 2 列 alexa 内部二次排序，
select * from runoob.websites order by country,alexa;

insert into websites(name,url,alexa,country) values('百度','http://www.baidu.com','4','CN');

insert into websites(name,url,country) values('stackoverflow','http://www.stackoverflow','IND');

Alexa Internet, Inc.（亚马逊旗下网站流量统计公司）
行业术语 Alexa Rank（Alexa 排名）：

update runoob.websites set alexa='5000',country='USA' where name='菜鸟教程';
delete from runoob.websites where name='facebook' and country='USA';

select * from runoob.websites limit 2;
select * from runoob.websites where name like "G%";
select * from runoob.websites where name like "%w";
select * from runoob.websites where name like "%oo%";
select * from runoob.websites where name not like "%oo%";

通配符	      描述
%	        替代 0 个或多个字符
_	        替代一个字符
[charlist]	字符列中的任何单一字符
[^charlist] 不在字符列中的任何单一字符
[!charlist]	不在字符列中的任何单一字符

select * from runoob.websites where name like "_oogle";
select * from runoob.websites where name like "_oo_le";
select * from runoob.websites where name regexp "^[GFs]";
select * from runoob.websites where name regexp "^[A-H]";
select * from runoob.websites where name regexp "^[a-zA-H]";
select * from runoob.websites where name regexp "^[^A-H]";
select * from runoob.websites where name in ("Google","菜鸟教程");
select * from runoob.websites where alexa not between 1 and 20;
select * from runoob.websites where (alexa between 1 and 20) and country not in ("IND","USA");
-- 选取 name 以介于 'A' 和 'H' 之间字母开始的所有网站：
select * from runoob.websites where name between "A" and "H";
select * from runoob.websites where name not between "A" and "H";
select * from access_log where date between "2016-5-10" and "2016-5-14";
select name as n,country as c from runoob.websites
select w.name,w.url,a.count,a.date from runoob.websites as w ,runoob.access_log as a where a.site_id=w.id and w.name="菜鸟教程";

INNER JOIN	返回两个表中满足连接条件的记录（交集）。
LEFT JOIN	返回左表中的所有记录，即使右表中没有匹配的记录（保留左表）。
RIGHT JOIN	返回右表中的所有记录，即使左表中没有匹配的记录（保留右表）。
FULL OUTER JOIN	同时保留两个表中所有的记录，即使其中一方没有匹配项。
CROSS JOIN	返回两个表的笛卡尔积，每条左表记录与每条右表记录进行组合。
SELF JOIN	一张表自己和自己拼，起两个不同别名当两张表用（查层级、上下级常用）
NATURAL JOIN	基于同名字段自动匹配连接的表。不用写 ON 条件，自动拿两张表名字相同的字段做等值匹配；可读性差，企业基本不用

select websites.id,websites.url,access_log.count,access_log.date from websites inner join access_log where websites.id=access_log.site_id;
select websites.id,websites.url,access_log.count,access_log.date from websites inner join access_log where websites.id=access_log.site_id order by access_log.count;

select websites.name,access_log.count,access_log.date from websites left join access_log on websites.id=access_log.site_id order by access_log.count desc;

select websites.name,access_log.count,access_log.date from websites right join access_log on access_log.site_id=websites.id order by access_log.count desc;


#MySQL中不支持 FULL OUTER JOIN，你可以在 SQL Server 测试以下实例。
select websites.name,access_log.count,access_log.date from websites full outer join access_log on websites.id=access_log.site_id order by access_log.count desc;

-- 从 "Websites" 和 "apps" 表中选取所有不同的country（只有不同的值）：
select country from runoob.websites union select country from runoob.apps order by country;
-- union all 所有的 相同的也显示出来
select country from websites union all select country from apps order by country;

select country,name from websites where country="CN" union all select country,app_name from apps where country="CN" order by country;

# 从一个表复制数据，然后把数据插入到另一个新表employees_backup中。
# MySQL 数据库不支持 SELECT ... INTO 语句，但支持 INSERT INTO ... SELECT 。
SELECT EmployeeID, FirstName, LastName, Age, Department
INTO employees_backup
FROM employees
WHERE Age > 25;

-- 1. 复刻表结构、主键、索引、字符集
CREATE TABLE websites_copy LIKE websites;
-- 2. 单独插入数据，GTID完全支持
INSERT INTO websites_copy SELECT * FROM websites;

insert into websites(name,country) select app_name,country from apps;
insert into websites(name,country) select app_name,country from apps where id=1;

create database my_db;
create database my_db default character set utf8mb4 default collate utf8mb4_unicode_ci;
create database my_db character set utf8mb4 collate utf8mb4_unicode_ci;

create table person(
	person_id int,
    first_name varchar(255),
    last_name varchar(255),
    address varchar(255),
    city varchar(255)
);
-- 建表时对键字段的约束
NOT NULL - 指示某列不能存储 NULL 值。
UNIQUE - 保证某列的每行必须有唯一的值。
PRIMARY KEY - NOT NULL 和 UNIQUE 的结合。确保某列（或两个列多个列的结合）有唯一标识，有助于更容易更快速地找到表中的一个特定的记录。
FOREIGN KEY - 保证一个表中的数据匹配另一个表中的值的参照完整性。
CHECK - 保证列中的值符合指定的条件。
DEFAULT - 规定没有给列赋值时的默认值。
INDEX - 用于快速访问数据库表中的数据。

[my_db]>create table students(
Student_ID int not null,
last_name varchar(50) not null,
first_name varchar(50),
age int);


CREATE TABLE Orders (
    OrderID INT NOT NULL PRIMARY KEY,
    OrderNumber INT NOT NULL,
    CustomerID INT,
    -- 确保一个表中的值匹配另一个表中的值，从而建立两表之间的关系。
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Products (
    ProductID INT NOT NULL PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) CHECK (Price >= 0)
);

CREATE TABLE Customers (
    CustomerID INT NOT NULL PRIMARY KEY,
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50),
    JoinDate DATE DEFAULT (NOW())
);


create index idx_lastname on students(last_name);


create table persons(
	ID int not null,
    LastName varchar(255) not null,
    FirstName varchar(255) not null,
    Age int
);

alter table persons modify Age int not null;
alter table persons modify Age int null;

create table persons(
    P_ID int not null,
    LastName varchar(64) not null,
    firstName varchar(255),
    Address varchar(255),
    City varchar(255),
    constraint uc_PersonID unique(P_ID,LastName)
);

alter table persons add unique(P_ID);
alter table persons add constraint uc_personId unique(P_ID,LastName);
alter table person drop index uc_personId;


create talbe persons(
	P_ID int not null,
    LastName varchar(64) not null,
    firstName varchar(255),
    Address varchar(255),
    City varchar(255),
    primary key(P_ID)
)

alter table persons add primary key(P_ID);
alter table persons drop primary key;

# 外键 ,企业不推荐,
CREATE TABLE Orders(
    O_Id int NOT NULL,
    OrderNo int NOT NULL,
    P_Id int,
    PRIMARY KEY (O_Id),
    FOREIGN KEY (P_Id) REFERENCES Persons(P_Id)
);

ALTER TABLE Orders ADD FOREIGN KEY (P_Id) REFERENCES Persons(P_Id)
ALTER TABLE Orders DROP FOREIGN KEY fk_PerOrders

CREATE TABLE Persons(
P_Id int NOT NULL,
LastName varchar(255) NOT NULL,
FirstName varchar(255),
Address varchar(255),
City varchar(255),
CHECK (P_Id>0)
);

alter table Persons add check(P_ID>0);
alter table Persons add constraint chk_Person check(P_ID>0 and City="Sandnes");
alter table Persons drop check chk_Person;


CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    HireDate DATE DEFAULT GETDATE(), -- 默认值为当前日期
    Salary DECIMAL(10, 2) DEFAULT 0.00 -- 默认值为 0.00
);

alter table employees alter column Salary set default 0.00;
ALTER TABLE employees ALTER COLUMN Salary DROP DEFAULT;

create index Pindex on Person(LastName);
create index PIndex on person(lastName,FirstName);

drop index Pindex on person;
drop table my_table;
drop database database_name;
truncate table table_name;


alter table table_name add column_name data_type;
alter table table_name drop column column_name;

CREATE TABLE Persons(
ID int NOT NULL AUTO_INCREMENT,
LastName varchar(255) NOT NULL,
FirstName varchar(255),
Address varchar(255),
City varchar(255),
PRIMARY KEY (ID)
)


一、什么是视图
视图本质是一条预存好的 SELECT 查询语句，虚拟表，不存真实数据。
物理上没有文件 / 数据，访问视图时临时执行里面的 SQL 查原表；
对外看起来和普通表用法一样，可以 SELECT * FROM 视图名。
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;

SELECT * FROM view_name;

drop view view_name;


-- 查看总目录
HELP 'contents';

-- 查看所有函数分类
HELP 'functions';

-- 分类查看对应内置函数
HELP 'string functions';    -- 字符串函数
HELP 'date and time functions'; -- 日期时间
HELP 'numeric functions';   -- 数学函数
HELP 'aggregate functions'; -- 聚合SUM/COUNT/MAX
HELP 'control flow functions'; -- IF/CASE

NOW()	返回当前的日期和时间
CURDATE()	返回当前的日期
CURTIME()	返回当前的时间
DATE()	   提取日期或日期/时间表达式的日期部分
EXTRACT()	返回日期/时间的单独部分
DATE_ADD()	向日期添加指定的时间间隔
DATE_SUB()	从日期减去指定的时间间隔
DATEDIFF()	返回两个日期之间的天数
DATE_FORMAT()	用不同的格式显示日期/时间


SELECT LastName,FirstName,Address FROM Persons WHERE Address IS NULL
SELECT LastName,FirstName,Address FROM Persons WHERE Address IS NOT NULL

ProductName：商品名称
UnitPrice：单品单价
UnitsInStock：仓库现有库存数量
UnitsOnOrder：已下单待入库的订货数量（该字段可能为 NULL） 
IFNULL(UnitsOnOrder, 0): 如果 UnitsOnOrder 是 NULL（无订货），自动替换成数字 0
SELECT ProductName,UnitPrice*(UnitsInStock+IFNULL(UnitsOnOrder,0)) FROM Products

SELECT ProductName,UnitPrice*(UnitsInStock+COALESCE(UnitsOnOrder,0)) FROM Products


SQL 函数
SQL 拥有很多可用于计数和计算的内建函数。

SQL Aggregate 函数
SQL Aggregate 函数计算从列中取得的值，返回一个单一的值。
有用的 Aggregate 函数：
AVG() - 返回平均值
COUNT() - 返回行数
FIRST() - 返回第一个记录的值
LAST() - 返回最后一个记录的值
MAX() - 返回最大值
MIN() - 返回最小值
SUM() - 返回总和

SQL Scalar 函数
SQL Scalar 函数基于输入值，返回一个单一的值。
有用的 Scalar 函数：
UCASE() - 将某个字段转换为大写
LCASE() - 将某个字段转换为小写
MID() - 从某个文本字段提取字符，MySql 中使用
SubString(字段，1，end) - 从某个文本字段提取字符
LEN() - 返回某个文本字段的长度
ROUND() - 对某个数值字段进行指定小数位数的四舍五入
NOW() - 返回当前的系统日期和时间
FORMAT() - 格式化某个字段的显示方式


select avg(count) as count_avg from access_log;
select site_id,count from access_log where count > (select avg(count) from access_log);


select count(*) as nums from access_log where id=3;
select count(*) as nums from access_log;
select count(distinct site_id) as nums from access_log;

select name as firstSite from runoob.websites limit 1;

select name from runoob.websites order by id desc limit 1;

select max(alexa) as max_Alexa from runoob.websites;
select min(alexa) as min_Alexa from runoob.websites;

select sum(count) as sum_count from access_log;
select site_id,sum(count) as nums from runoob.access_log group by site_id;

select websites.name,sum(access_log.site_id) from access_log left join websites on access_log.site_id=websites.id group by websites.name;


HAVING 一句话核心作用
专门用来过滤 GROUP BY 分组后的聚合结果（SUM/COUNT/MAX/AVG 等）
1. WHERE 和 HAVING 严格区分（必记）
WHERE：分组前过滤原始行，不能写聚合函数,过滤表里原始数据，先筛数据，再分组求和
HAVING：分组后过滤聚合计算出来的值，只能放聚合函数,先分组统计，再把统计结果筛选一遍

-- 查找总访问量大于 200 的网站。
SELECT Websites.name, Websites.url, SUM(access_log.count) AS nums FROM (access_log
INNER JOIN Websites
ON access_log.site_id=Websites.id)
GROUP BY Websites.name
HAVING SUM(access_log.count) > 200;

-- 查找总访问量大于 200 的网站，并且 alexa 排名小于 200。
SELECT Websites.name, SUM(access_log.count) AS nums FROM Websites
INNER JOIN access_log
ON Websites.id=access_log.site_id
WHERE Websites.alexa < 200 
GROUP BY Websites.name
HAVING SUM(access_log.count) > 200;

-- 查找总访问量(count 字段)大于 200 的网站是否存在。
SELECT Websites.name, Websites.url  FROM Websites  WHERE exists (SELECT count FROM access_log WHERE Websites.id = access_log.site_id AND count > 200);

SELECT DISTINCT w.name, w.url FROM Websites w INNER JOIN access_log a ON w.id=a.site_id WHERE a.count>200;

SELECT Websites.name, Websites.url FROM Websites WHERE NOT EXISTS (SELECT count FROM access_log WHERE Websites.id = access_log.site_id AND count > 200);

-- name转大写
select ucase(name) as site_title,url from runoob.websites;
-- name转小写
select lcase(name) as site_title,url from runoob.websites;
-- 从 "Websites" 表的 "name" 列中提取前 4 个字符：
select mid(name,1,4) as short_title,url from runoob.websites;
-- 返回文本字段中值的长度。
select name,length(url) as lengthOurl from websites;

-- round 四舍五入
select round(1.3);
select round(1.58);
select round(1.298,1);

select name,url,Now() as date from websites;

-- FORMAT() 函数用于对字段的显示进行格式化。
select name,url,date_format(Now(),"%Y-%m-%d") from websites;








```

