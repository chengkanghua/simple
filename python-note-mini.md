

## python 国内下载地址

https://mirrors.huaweicloud.com/python/
https://www.python.org/downloads/release/python-390/


## 推荐教程地址

[官方教程](https://docs.python.org/zh-cn/3/tutorial/index.html)
[廖雪峰python](https://www.liaoxuefeng.com/wiki/1016959663602400)

## python虚拟环境创建
```
cd /Users/kanghua/env/
$ python3.9 -m venv python3-base
$ cd python3-base/
python3-base kanghua$ source bin/activate   #激活

```

## python注释

```py
'''
注释内容
'''

"""
注释内容
"""

# 注释内容

print("string",end="")
input('please username:')

单行注释用#，多行注释可以用三对双引号“”” “””
代码注释原则:
1. 不用给全部代码加注释，只需要在自己觉得重要或不好理解的部分加注释即可
2. 注释可以用中文或英文，但绝对不要拼音噢
3. 注释不光要给自己看，还要给别人看，所以请认真写
```


## 数据类型分类
数字
	int      整形
	float    浮点数
	complex
布尔类型
	bool	
字符串
	str
列表
	list
元组
	tuple
字典
	dict
集合
	set


特殊的值 None  空 相当于其他语言中的null


```py

num = 10000
print(bin(num))


v1 = True + True
print(v1) # 2

#str   字符串创建后不可被修改
str.startswith()
str.endswith()
str.isdecimal()
str.isdigit()
str.strip()
str.lstrip()
str.rstrip()
str.upper()
str.lower()
str.replace("source","dest")
str.split("|",[num]) # 按|分割 返回一个列表 num为分割次数，默认全部-1
str.join(data_list) #"|".join(data_list)
str.format()
str.encode()
str.decode()
str.center()
str.ljust()
str.rjust()
str.zfill()  #zero 填充0


#list   有序可变
user_list = ['佐助',"宝强",18,True,'alex']
user_list.append("锤子")
user_list.extend([11,22,33])
user_list.insert(0,"李小璐")
user_list.remove("宝强")
user_list.pop(1) #索引1位置踢出
user_list.pop()  #索引最后一个位置踢出
user_list.clear()
user_list.index("alex") #根据值找索引位置
user_list.sort(reverse=True)
user_list.reverse()

print(user_list)

#tuple  有序且不可变的容器  但元组的元素如果是可变类型，可变类型内部是可以修改的。
(1,)
(1,2,3,)
#公共功能
tuple + tuple
tuple * 2
len(tuple)
tuple[0]
tuple[0:2]
tuple[1:]
tuple[:-1]

tuple[1:4:2]

tuple[::-1]

# str、list、tuple set 可以被for循环
for item in tuple:
	pass 


#set集合，无序，一个不允许重复 & 可变类型（元素可哈希）。
#元素必须是可哈希，可哈希的数据类型：int、bool、str、tuple，而list、set是不可哈希的。
v1 = []
v11 = list()

v2 = ()
v22 = tuple()

v3 = set() #定义空集合

v4 = {} # 空字典
v44 = dict()

v1 = {11,22,33,"alex"}
v1.add(55)
v1.discard("alex")

s1 = {"刘能", "赵四", "⽪⻓⼭"}
s2 = {"刘科⻓", "冯乡⻓", "⽪⻓⼭"}
#取交集：共同的好友
print(s1.intersection(s2))
print(s1 & s2)
#并集：两个人所有的好友
print(s1.union(s2))
print(s1 | s2)
#差集：我有你没有的
print(s1.difference(s2))
print(s1 - s2)


#dict字典，一个容器且元素必须是键值对。
字典是 无序(3.6版本之后是有序)、键不重复 且 元素只能是键值对的可变的容器。
data = { "k1":1,  "k2":2 }

字典中对键值得要求：
- 键：必须可哈希。 int/bool/str/tuple；
	不可哈希的类型：list/set/dict。
- 值：任意类型。

dict.get("name")
dict.get("hobby",123) #值不在就返回123
dict.keys()  #返回dict_keys([xx,xxx]) 使用list() 转换list
dict.values()
dict.items()

for item in dict_data: #for item in dict_data.key():
	print(item)

for key,value in info.items():
	print(key,values)  

for item in info.items():
	print(item[0],item[1])

if ("age",12) in dict_data:
	print("is in")

dict.setdefault("age",18) #类似于list	.append
dict.update("age":14,"name":"alex")
dict.pop("age")
dict.popitem()  #后进先出 3.6版本之后移除最后的值，3.6之前随机删除

dict1 | dict2 # 3.9版本新增功能  并集：

len(dict_data)
"age" in dict_data #是否包含

#根据键添加 修改 删除值
dict['gender'] = "male"
del dict['gender']

#float类型，我们生活中常见的小数。
v1 = 3.14
v2 = 9.89

v1 = 3.14 
data = int(v1)
print(data) # 3

v1 = 3.1415926
result = round(v1,3)
print(result) # 3.142

#如果遇到精确的小数计算应该怎么办？
import decimal

v1 = decimal.Decimal("0.1")
v2 = decimal.Decimal("0.2")
v3 = v1 + v2
print(v3) # 0.3

```

三句话搞定类型转换：
- 其他所有类型转换为布尔类型时，除了 空字符串、0以为其他都是True。
- 字符串转整形时，只有那种 "988" 格式的字符串才可以转换为整形，其他都报错。
- 想要转换为那种类型，就用这类型的英文包裹一下就行。 

## 编码
```py
axcii 字符与二进制对照表
unicode 字符与二进制对照表
utf8   对unicode字符集的码位进行压缩处理，间接也维护了字符和二进制的对照表。

# 字符串类型
name = "武沛齐"

print(name) # 武沛齐
# 字符串转换为字节类型(按utf8编码转换，也可以换成gbk)
data = name.encode("utf-8")
print(data) # b'\xe6\xad\xa6\xe6\xb2\x9b\xe9\xbd\x90'

# 把字节转换为字符串
old = data.decode("utf-8")
print(old
```

## 条件语句

```py

print("开始")
if True:
  print("123")
else:
  print("456")
print("结束")


if 条件A:
  A成立，执行此缩进中的所有代码
  ...
elif 条件B:
  B成立，执行此缩进中的所有代码
  ...
elif 条件C:
  C成立，执行此缩进中的所有代码
  ...
else:
  上述ABC都不成立。


print("欢迎致电10086，我们提供了如下服务： 1.话费相关；2.业务办理；3.人工服务")

choice = input("请选择服务序号")

if choice == "1":
    print("话费相关业务")
    cost = input("查询话费请按1;交话费请按2")
    if cost == "1":
        print("查询话费余额为100")
    elif cost == "2":
        print("交互费")
    else:
        print("输入错误")
elif choice == "2":
    print("业务办理")
elif choice == "3":
    print("人工服务")
else:
    print("序号输入错误")
```


## 循环语句

```py
#while
print("123")
while 条件:
  ...
  ...
  ...
print(456)


break，用于在while循环中帮你终止循环。
continue，在循环中用于 结束本次循环，开始下一次循环。

# for

for i in (1,2,3,4,5):
	print(i,end=" ")

for i in range(1,6):
	print(i,end=" ")

for i in range(6):
	print(i,end=" ")

for i in range(1,100,2):
	print(i,end=" ")

for i in range(1,100,-2):
	print(i,end=" ")



```


## 字符串格式化

```py

#基本格式化
name = "武沛齐"
age = 18
# text = "我叫%s，今年%s岁" %("武沛齐",18)
# text = "我叫%s，今年%s岁" %(name,age)
text = "我叫%s，今年%d岁" %(name,age)


message = "%(name)s你什么时候过来呀？%(user)s今天不在呀。" % {"name": "死鬼", "user": "李杰"}
print(message)


# format（推荐）

text = "我叫{0}，今年{1}岁，真是的姓名是{0}。".format("武沛齐",18)

text = "我叫{n1}，今年{age}岁，真是的姓名是{n1}。".format(n1="武沛齐",age=18)


# f  python3.6版本之后

name = "喵喵"
age = 19
text = f"嫂子的名字叫{name}，今年{age}岁"
print(text)

# 在Python3.8引入
text = f"嫂子的名字叫喵喵，今年{19 + 2=}岁"
print(text)
```


## 运算符
```text
算数运算符
+ 
-
*
/
%
**
//

比较运算符
==     #比较值是否相等
!=
>
< 
>=
<=
<>

python赋值运算符
=
+=
-=
*=
%=
**=
//=

按位运算符
&
！
^
~
<<
>>

逻辑运算符
and
or
not

成员运算符
in
not in

身份运算符
is        #is比较内存地址是否一致
not is

运算符优先级

常用的运算符： 算术> 比较 > 逻辑 >赋值


运算符					描述
** 						指数运算符优先于表达式中使用的所有其他运算符。
〜+ <->					</->否定，一元加减。
* /％//					乘法，除法，模块，提醒和楼层划分。
+ <->					</->二进制加减
>> << 					左移和右移
＆						二进制和。
^ |						二元xor和or
<= <>> = 				比较运算符（小于，小于等于，大于，大于等于）。
<> ==！=					比较运算符
=％= / = // = - = + = 	等于运算符
* = ** =				赋值运算符
is is not				身份运算符
in not in				成员运算符
not and or				逻辑运算符

```


## 文件操作
```py

file_object = open('info.txt',mode='rt',encoding="utf8")
data= file_object.read()
file_object.close()

file_object = open('a1.png', mode='rb')
data = file_object.read()
file_object.close()

# 模式：wb（要求写入的内容需要是字节类型）
file_object = open("t1.txt", mode='wb')
file_object.write(    "武沛齐".encode("utf-8")    )
file_object.close()

# wt 写入是文本字符串类型
file_object = open("t1.txt", mode='wt', encoding='utf-8')
file_object.write("武沛齐")
file_object.close()

#写图片 
f1 = open('a1.png',mode='rb')
content = f1.read()
f1.close()
f2 = open('a2.png',mode='wb')
f2.write(content)
f2.close()

#文件打开模式
========= ===============================================================
Character Meaning
--------- ---------------------------------------------------------------
'r'       open for reading (default)
'w'       open for writing, truncating the file first
'x'       create a new file and open it for writing
'a'       open for writing, appending to the end of the file if it exists

'b'       binary mode
't'       text mode (default)

'+'       open a disk file for updating (reading and writing)

The default mode is 'rt' (open for reading text).

关于文件的打开模式常见应用有：
- 只读：r、rt、rb （用）
  - 存在，读
  - 不存在，报错
- 只写：w、wt、wb（用）
  - 存在，清空再写
  - 不存在，创建再写
- 只写：x、xt、xb
  - 存在，报错
  - 不存在，创建再写。
- 只写：a、at、ab【尾部追加】（用）
  - 存在，尾部追加。
  - 不存在，创建再写。


file_object.read() 		#读所有
file_object.read(1) 	#都一个字节
file_object.readline()  #读一行
file_object.readlines() #读所有行，每行为列表的一个元素
file_object.flush()     #缓冲区内容刷到硬盘
file_object.seek(3)  	#移动光标位置 移动到字节的位置
file_object.tell()      #返回光标位置


#循环读大文件  
f = open('info.txt',mode='r',encoding='utf-8')
for line in f:
	print(line.strip())
f.close()

#上下文管理
with open("xx.txt", mode='rb') as file_object:
	data = file_object.read()
	print(data)

with open("xx.txt", mode='rb') as f1, open("xxx.txt", mode='rb') as f2:
	data = file_object.read():
	pass

# 文件当前路径	
import os
base_dir = os.path.dirname(os.path.abspath(__file__))
file_path = os.path.join(base_dir, 'files', 'info.txt')
print(file_path)
if os.path.exists(file_path):
    file_object = open(file_path, mode='r', encoding='utf-8')
    data = file_object.read()
    file_object.close()

    print(data)
else:
    print('文件路径不存在')


#文件路径相关
import os
import shutil
os.path.abspath(__file__)
os.path.dirname(__file__)
os.path.join(base_path,'xxx','a1.png')
os.path.exists(path)
os.makedirs(path)
os.path.isdir(file_path)
os.remove("文件路径")
shutil.copytree("","") #拷贝文件夹
shutil.copy("","")     #拷贝文件
shutil.move("","")     #文件或文件夹重命名

```


## 函数入门

```py

def send_email(email):
    # ### 1.邮件内容配置 ###
    # 邮件文本
    msg = MIMEText("约吗", 'html', 'utf-8') 
    # 邮件上显示的发件人
    msg['From'] = formataddr(["武沛齐", "wptawy@126.com"])
    # 邮件上显示的主题
    msg['Subject'] = "邮件主题"
	
    # ### 2.发送邮件 ### 
    server = smtplib.SMTP_SSL("smtp.126.com")
    server.login("wptawy@126.com", "WIYSAILOVUKPQGHY")
    server.sendmail("wptawy@126.com", email, msg.as_string())
    server.quit()
    
v1 = "424662508@qq.com"
send_email(v1)

v2 = "424662509@qq.com"
send_email(v2)


1. 形参
2. 实参
3. 位置传参
4. 关键字传参


默认参数

动态参数
# 1. ** 必须放在 * 的后面
def func1(*args, **kwargs):
    print(args, **kwargs)

函数的返回值， 默认返回None

```

## 函数进阶
```py
python的函数传参时：传递的是内存地址。
Python参数的这一特性有两个好处：
- 节省内存
- 对于可变类型且函数中修改元素的内容，所有的地方都会修改。可变类型：列表、字典、集合。



#深拷贝
#不可变类型，不拷贝
import copy
v1 = "eric"
v2 = copy.deepcopy(v1)
print(v1 is v2)  #True 内存地址一样 
-----------------------------------
import copy
v1 = ( "dd","root")
v2 = copy.deepcopy(v1)
print(v1 is v2) #True    #特殊： 元组中无可变类型 不拷贝；
--------------------------------------------
import copy
v1 = ( "dd","root",[11,(33,44),(11,[],33),33])
v2 = copy.deepcopy(v1)
#元祖元素中有可变类型，找到所有【可变类型】或【含有可变类型的元组】均拷贝一份
print(v1 is v2) #False
print(v1[2] is v2[2]) #False
print(v1[2][1] is v2[2][1]) #True
print(v1[2][2] is v2[2][2]) #False
print(v1[2][3] is v2[2][3]) #True
-----------------------------------------------
#可变类型，找到所有层级的 【可变类型】或【含有可变类型的元组】 均拷贝一份
import copy
v1 = ["武沛齐", "root", [11, [44, 55], (11, 22), (11, [], 22), 33]]
v2 = copy.deepcopy(v1)
print(v1 is v2) #False
print(v1[2] is v2[2]) #False
print(v1[2][1] is v2[2][1]) #False
print(v1[2][2] is v2[2][2]) #True
print(v1[2][3] is v2[2][3]) #False



#浅拷贝
import copy
v1 = "eric"
v2 = copy.copy(v1)
print(v1 is v2)  #True 内存地址一样
#按理说拷贝 内存地址应该不同，但由于python内部优化机制，内存地址是相同，因为对不可变数据类型而言，
#如果以后修改值，会重新创建一份数据，不会影响源数据。所以不拷贝也无妨
--------------------------------------------
import copy
#可变类型只拷贝第一层
v1 = ['nolocal','root',[11,22]]
v2 = copy.copy(v1)
print(v1 is v2)  #True
print(v1[2] is v2[2]) #False




参数的默认值
def func(a1,a2=18):
    print(a1,a2)
原理：Python在创建函数（未执行）时，如果发现函数的参数中有默认值，则在函数内部会创建一块区域并维护这个默认值。
- 执行函数未传值时，则让a2指向 函数维护的那个值的地址。
    func("root")

- 执行函数传值时，则让a2指向新传入的值的地址。
    func("admin",20)
在特定情况【默认参数的值是可变类型 list/dict/set】 & 【函数内部会修改这个值】


动态参数
def func(*args,**kwargs):
    print(args,kwargs)
    
func("宝强","杰伦",n1="alex",n2="eric")
---------------------------------------------
def func(a1,a2):
    print(a1,"|",a2)

func(11,22)
func(a1=1,a2=2)

func(*[11,22])
func(**{"a1":11,"a2":22})

--------------------------------------------
def func(*args,**kwargs):
    print(args,kwargs)

func(11,22)
func(11,22,name="peiqi",age=18)

func([11,22,33],{"k1":1,"k2":2})  #小坑，([11,22,33], {"k1":1,"k2":2}), {}
func(*[11,22,33],**{"k1":1,"k2":2}) #(11, 22, 33) {'k1': 1, 'k2': 2}

-----------------------------------------------
v1 = "我是{},年龄：{}。".format("武沛齐",18)
v2 = "我是{name},年龄：{age}。".format(name="武沛齐",age=18)

v3 = "我是{},年龄：{}。".format(*["武沛齐",18])
v4 = "我是{name},年龄：{age}。".format(**{"name":"武沛齐","age":18})
------------------------------------------------

函数名就是一个变量，这个变量代指函数。
函数名可以放入列表中。
函数同时也可被哈希，所以函数名通知也可以当做 集合的元素、字典的键。

func send_msg():
	pass
func send_email():
	pass
func_dict = {
	"1":send_msg,
	"2":send_email,
}
print("欢迎使用xx系统")
print("请选择：1.发送消息；2.发送图片；3.发送表情；4.发送文件")
choice = input("输入选择的序号") # "1"
func = function_dict.get(choice)
if not func:
    print("输入错误")
else:
    # 执行函数
    func()

全局与局部
Python中以函数为作用域，函数的作用域其实是一个局部作用域。

默认情况下，在局部作用域对全局变量只能进行：读取和修改内部元素（可变类型），
global关键字实现局部作用域对全局变量重新赋值


nonlocal关键字用来在函数或其它作用域中使用外层（非全局）变量

```

## 函数高级

```py

#函数嵌套
name = "alex"
def run():
	name = "alex"
	def inner():
		print(name)
	return [inner,inner,inner]

func_list =run()
func_list[2]() #alex
func_list[1]() #alex

#闭包
闭包，简而言之就是将数据封装在一个包（区域）中，使用时再去里面取。（本质上 闭包是基于函数嵌套搞出来一个中特殊嵌套）

def task(arg):
    def inner():
        print(arg)
    return inner

v1 = task(11)
v2 = task(22)
v3 = task(33)
v1()
v2()
v3()

# 装饰器
在不修改函数源码的前提下，实现在函数执行前和执行后分别输入 "before" 和 "after"

def outer(origin):
	def inner(*agrs,**kwargs):
		#before
		res = origin(*args,**kwargs)
		#after
		return res
	return inner

@outer
def func():
	pass

func()

# functools 伪装的更像，内部读取__name__ 不会变。
import functools
def auth(func):
	@functools.wraps(func)
	def inner(*args,**kwargs):
		#before
		res = func(*args,**kwargs)
		return res 
	return inner


# 匿名函数， 返回值默认将执行结果返回
lambda x: 函数体
lambda x1,x2: 函数体
lambda *args, **kwargs: 函数体

foo = lambda a1,a2: a1 + a2 + 100
匿名函数适用于简单的业务处理，可以快速并简单的创建函数。

# 三元运算
num = input("请写入内容")
data = "臭不要脸" if "苍老师" in num else "正经人"
print(data)

# 结果 =  条件成立时    if   条件   else   不成立

#三元+匿名函数
func = lambda x: "大了" if x > 66 else "小了"


#一个函数就可以接收另一个函数作为参数，这种函数就称之为高阶函数。
map()函数接收两个参数，一个是函数，一个是Iterable，map将传入的函数依次作用到序列的每个元素，并把结果作为新的Iterator返回。
>>> def f(x):
...     return x * x
...
>>> r = map(f, [1, 2, 3, 4, 5, 6, 7, 8, 9])
>>> list(r)
[1, 4, 9, 16, 25, 36, 49, 64, 81]
----------------------------------------------
>>> list(map(str, [1, 2, 3, 4, 5, 6, 7, 8, 9]))
['1', '2', '3', '4', '5', '6', '7', '8', '9']

reduce把一个函数作用在一个序列[x1, x2, x3, ...]上，这个函数必须接收两个参数，reduce把结果继续和序列的下一个元素做累积计算，其效果就是：
reduce(f, [x1, x2, x3, x4]) = f(f(f(x1, x2), x3), x4)
#序列求和
>>> from functools import reduce
>>> def add(x, y):
...     return x + y
...
>>> reduce(add, [1, 3, 5, 7, 9])
25
-------------------------------------
>>> from functools import reduce
>>> def fn(x, y):
...     return x * 10 + y
...
>>> reduce(fn, [1, 3, 5, 7, 9])
13579


#把str转换为int的函数：
from functools import reduce
DIGITS = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9}
def char2num(s):
    return DIGITS[s]
def str2int(s):
    return reduce(lambda x, y: x * 10 + y, map(char2num, s))

print(reduce(fn, map(char2num, '13579'))) #13579


filter()把传入的函数依次作用于每个元素，然后根据返回值是True还是False决定保留还是丢弃该元素。

#只保留奇数
def is_odd(n):
    return n % 2 == 1

list(filter(is_odd, [1, 2, 4, 5, 6, 9, 10, 15])) ## 结果: [1, 5, 9, 15]

#去掉空空字符串
def not_empty(s):
    return s and s.strip()

list(filter(not_empty, ['A', '', 'B', None, 'C', '  ']))# 结果: ['A', 'B', 'C']

# sorted()函数也是一个高阶函数，它还可以接收一个key函数来实现自定义的排序，
#例如按绝对值大小排序：
>>> sorted([36, 5, -12, 9, -21], key=abs)
[5, 9, -12, -21, 36]

>>> sorted([36, 5, -12, 9, -21])
[-21, -12, 5, 9, 36]

#默认是按ascii码的大小比较的
>>> sorted(['bob', 'about', 'Zoo', 'Credit'])
['Credit', 'Zoo', 'about', 'bob']
>>> sorted(['bob', 'about', 'Zoo', 'Credit'], key=str.lower)
['about', 'bob', 'Credit', 'Zoo']
>>> sorted(['bob', 'about', 'Zoo', 'Credit'], key=str.lower, reverse=True)
['Zoo', 'Credit', 'bob', 'about']


#偏函数
functools.partial的作用就是，把一个函数的某些参数给固定住（也就是设置默认值），返回一个新的函数，调用这个新函数会更简单。
>>> import functools
>>> int2 = functools.partial(int, base=2)
>>> int2('1000000')
64
>>> int2('1010101')
85

```


## 高级特性

### 切片
```py
L = ['Michael', 'Sarah', 'Tracy', 'Bob', 'Jack']
L[0:3]
L[:3]
L[1:3]
L[-2:]
L[-2:-1]
L = list(range(100))
L[10:20]
L[:10:2]
L[::5]
L[::-1] #翻转
```

### 迭代
```py
# python for循环可以作用在可迭代对象上
L = ["a",'b',"c"]
for i,value in enumerate(L):
	print(i,value)

#判断对象是否可迭代
from collections.abc import Iterable
print(isinstance("abc",Iterable))   #True
print(isinstance([1,2,3],Iterable)) #True
print(isinstance(123,Iterable))     #False

```

### 列表生成式
```py
>>> list(range(1, 11))
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

>>> [x * x for x in range(1, 11)]
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

>>> [x * x for x in range(1, 11) if x % 2 == 0]
[4, 16, 36, 64, 100]

>>> L = ['Hello', 'World', 'IBM', 'Apple']
>>> [s.lower() for s in L]
['hello', 'world', 'ibm', 'apple']

>>> [x for x in range(1, 11) if x % 2 == 0]
[2, 4, 6, 8, 10]

>>> [x if x % 2 == 0 else -x for x in range(1, 11)]
[-1, 2, -3, 4, -5, 6, -7, 8, -9, 10]
上述for前面的表达式x if x % 2 == 0 else -x才能根据x计算出确定的结果。

#元组，是得到一个生成器
# 不会立即执行内部循环去生成数据，而是得到一个生成器。
data = (i for i in range(10))
print(data)
for item in data:
    print(item)


```
### 生成器
```py
>>> g = (x * x for x in range(10))
>>> g
<generator object <genexpr> at 0x1022ef630>

>>> next(g)
0
>>> next(g)
1
>>> next(g)
4
>>> next(g)
9
>>> next(g)
16
>>> next(g)
25
>>> next(g)
36
>>> next(g)
49
>>> next(g)
64
>>> next(g)
81
>>> next(g)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
StopIteration

>>> g = (x * x for x in range(10))
>>> for n in g:
...     print(n)

#函数定义中包含yield关键字，这个函数就不是普通函数，而是一个generator函数，
#生成器的特点是，记录在函数中的执行位置，下次执行next时，会从上一次的位置基础上再继续向下执行。
def fib(max):
    n, a, b = 0, 0, 1
    while n < max:
        yield b
        a, b = b, a + b
        n = n + 1
    return 'done'

>>> f = fib(6)
>>> f
<generator object fib at 0x104feaaa0>


#获取genterator的返回值， for循环拿不到
>>> g = fib(6)
>>> while True:
...     try:
...         x = next(g)
...         print('g:', x)
...     except StopIteration as e:
...         print('Generator return value:', e.value)
...         break


#在python3.3之后有引入了一个yield from。
def foo():
    yield 2
    yield 2
    yield 2

def func():
    yield 1
    yield 1
    yield 1
    yield from foo() #这是运行foo() 222
    yield 1
    yield 1

for item in func():
    print(item)


```
### 迭代器
```py

凡是可作用于for循环的对象都是Iterable类型；
凡是可作用于next()函数的对象都是Iterator类型，它们表示一个惰性计算的序列；
集合数据类型如list、dict、str等是Iterable但不是Iterator，不过可以通过iter()函数获得一个Iterator对象。
Python的for循环本质上就是通过不断调用next()函数实现的，例如：
for x in [1,2,3,4,5]:
	pass

实际等价于：
it = iter([1,2,3,4,5])
while True:
	try:
		x = next(it)
	except StopIteration:
		break


```

## 内置函数
```py
abs(-10) #绝对值
pow(2,5) #指数
sum([11,22,44])
v1,v2 = divmod(9,2) #商和余数
round(4,11786,2)  #小数点后n位，四舍五入

min(11,2,3,4,5)
max(11,2,3,4,56)
all([11,22,33,""]) #是否全部为True
any([11,22,33,4,""]) #是否存在True

bin   #十进制转二进制
oct   #十进制转八进制
hex   #十进制转十六进制

ord("中")   #字符对应的unicode码点
chr(20013) #根据码点(十进制) 获取对应的字符

v1 = "武沛齐"  # str类型
v2 = v1.encode('utf-8')  # bytes类型
v3 = bytes(v1,encoding="utf-8") # bytes类型
int 
float
str
bytes 
bool
list
dict
tuple
set

len
print
input
open
type
range
enumerate
id 
hash
help  #终端使用
zip
callable #是否可执行
sorted    #排序



```

## 模块

### 自定义模块
```py
- 一个py文件，模块（module）。
- 含多个py文件的文件夹，包（package）。

注意：在包（文件夹）中有一个默认内容为空的__init__.py的文件，一般用于描述当前包的信息（在导入他下面的模块时，也会自动加载）。

当定义好一个模块或包之后，如果想要使用其中定义的功能，必须要先导入，然后再能使用。
导入，其实就是将模块或包加载的内存中，以后再去内存中去拿就行。

在Python内部默认设置了一些路径，导入模块或包时，都会按照指定顺序逐一去特定的路径查找。
import sys
print(sys.path)

#手动添加路径
import sys
sys.path.append("路径A")

import xxxxx  # 导入路径A下的一个xxxxx.py文件

-------------------------------------------
from xxx import xxx #导入模块的个别成员

from xxx.xxx import xx as xo  #别名
import x1.x2 as pg


#执行py文件时
__name__ = "__main__"

```

### 第三方模块
```py
pip3 install 模块名称==版本 -i https://pypi.douban.com/simple

#升级pip
python3.9 -m pip install --upgrade pip

pip3.9 config set global.index-url https://pypi.douban.com/simple/


#源码  https://pypi.org/project/requests/#files
python3 setup.py build
python3 setup.py install


#wheel   https://pypi.org/project/requests/#files
pip3.9 install wheel

pip3 install  xxxx.

#安装的第三方模块路径
Max系统：
	/Library/Frameworks/Python.framework/Versions/3.9/lib/python3.9/site-packages
Windows系统：
	C:\Python39\Lib\site-packages\

```
### 内置模块
```py
import os

abs_path = os.path.abspath(__file__)
base_path = os.path.dirname(os.path.dirname(路径))
p1 = os.path.join(base_path,'xx')
p2 = os.path.join(base_path,'xx','oo','a1.png')
exists = os.path.exists(p1)
os.makedirs(路径)
file_path = os.path.join(base_path,'xx','uuu.png')
is_dir = os.path.isdir(file_path)
os.remove("文件路径")
shutil.rmtree(path)


```

遍历文件夹下所有文件
```py
import os

data = os.walk("/Users/kanghua/env/python3-base")
for path,folder_list,file_list in data:
    for file_name in file_list:
        file_abs_path = os.path.join(path,file_name)
        ext = file_abs_path.rsplit(".")[-1]
        if ext == "py":
            print(file_abs_path)

```

shutil
```py
import shutil
import os
base_path = os.path.dirname(os.path.abspath(__file__))

shutil.rmtree(path)
shutil.copytree("","") #拷贝文件夹
shutil.copy("","")  #拷贝文件
shutil.move("","")

shutil.make_archive(base_name=r'datafile',format='zip',root_dir=r'files')
# base_name，压缩后的压缩包文件
# format，压缩的格式，例如："zip", "tar", "gztar", "bztar", or "xztar".
# root_dir，要压缩的文件夹路径

shutil.unpack_archive(filename=r'datafile.zip',extract_dir=r'xxxxx/xo',format='zip')
# filename，要解压的压缩包文件
# extract_dir，解压的路径
# format，压缩文件格式

```

sys
```py
import sys
print(sys.version)
print(sys.version_info)
print(sys.version_info.major,sys.version_info.minor,sys.version_info.micro)

print(sys.path)



```

argv 执行脚本时，python解析器后面传入的参数
```py
import sys
print(sys.argv)

# 例如，请实现下载图片的一个工具。
def download_image(url):
    print("下载图片", url)

def run():
    # 接受用户传入的参数
    url_list = sys.argv[1:]
    for url in url_list:
        download_image(url)

if __name__ == '__main__':
    run()

----------------------------------
kanghua$ python3.9 /Users/kanghua/DevelopAutomation/study.py aa bb cc
['/Users/kanghua/DevelopAutomation/study.py', 'aa', 'bb', 'cc']
下载图片 aa
下载图片 bb
下载图片 cc

```

random
```py
import random
random.randint(10,20)
random.uniform(1,10)
random.choice([11,22,33,44,55])
random.sample([11,22,33,44,55])
data = [1,2,3,4,5,56,67]
random.shuffle(data) #打乱顺序

```

hashlib
```py
import hashlib
hash_object = hashlib.md5()
hash_object.update("李小鹿".encode('utf-8'))
result = hash_object.hexdigest()
print(result)

--------------------------------
improt hashlib
hash_object = hashlib.md5("dskfjksdjf".encode('utf-8')) #加盐
hash_object.update("李小璐".encode("utf-8"))
result = hash_object.hexdigest()
print(result)



```

json
```py
import json

data = [
    {"id": 1, "name": "武沛齐", "age": 18},
    {"id": 2, "name": "alex", "age": 18},
]

# 数据类型 --》 json字符串  称：序列化
res = json.dumps(data)
print(res) # '[{"id": 1, "name": "\u6b66\u6c9b\u9f50", "age": 18}, {"id": 2, "name": "alex", "age": 18}]'

res = json.dumps(data,ensure_ascii=False)
print(res) # '[{"id": 1, "name": "武沛齐", "age": 18}, {"id": 2, "name": "alex", "age": 18}]'

# json --》 数据类型   称： 反序列化
import json
data_string = '[{"id": 1, "name": "武沛齐", "age": 18}, {"id": 2, "name": "alex", "age": 18}]'

data_list = json.loads(data_string)
print(data_list)
-------------------------------------------
json.dumps()  #序列化生成一个字符串
json.loads()  #反序列化生成一个python数据类型
json.dump()   #将数据序列化并写入文件
json.load()   #读取文件中的数据并反序列化成python数据类型

import json
data = [
    {"id": 1, "name": "武沛齐", "age": 18},
    {"id": 2, "name": "alex", "age": 18},
]

file_object = open('xxx.json',mode='w',encoding='utf-8')
json.dump(data,file_object)
file_object.close()

file_object = open('xxx.json',mode='r',encoding='utf-8')
data = json.load(file_object)
print(data)
file_object.close()



```

datatime
时间三种格式
	datetime
	字符串
	时间戳
```py

import time
v1 = time.time() #时间戳
print(v1)
v2 = time.timezone  #时区
print(v2)


```

datetime
```py
from datetime import datetime, timezone, timedelta

v1 = datetime.now()  # 当前本地时间
print(v1)

# 时间的加减
v2 = v1 + timedelta(days=140, minutes=5)
print(v2)

v1 = datetime.now()
print(v1)

v2 = datetime.utcnow()  # 当前UTC时间
print(v2)

# datetime之间相减，计算间隔时间（不能相加）
data = v1 - v2
print(data.days, data.seconds / 60 / 60, data.microseconds)

```

字符串
```py

from datetime import datetime, timezone, timedelta
#字符串转为 datetime格式时间  
text = "2011-11-11"
v1 = datetime.strptime(text,'%Y-%m-%d')
print(v1) #2011-11-11 00:00:00


# datetime格式 ----> 转换为字符串格式
v1 = datetime.now()
val = v1.strftime("%Y-%m-%d %H:%M:%S")
print(val) #2023-01-22 15:00:09


```

时间戳
```py
import time

from datetime import datetime, timezone, timedelta

# 时间戳格式 --> 转换为datetime格式
ctime = time.time() # 11213245345.123
v1 = datetime.fromtimestamp(ctime)
print(v1)

# datetime格式 ---> 转换为时间戳格式
v1 = datetime.now()
val = v1.timestamp()
print(val)


```


## 正则表达式
```text
import re

text = "你好wupeiqi,阿斯顿发wupeiqasd 阿士大夫能接受的wupeiqiff"
data_list = re.findall("wupeiqi", text)
print(data_list) # ['wupeiqi', 'wupeiqi'] 可用于计算字符串中某个字符出现的次数

[abc] # 匹配a或b或c 字符。
[a-z] # 匹配a~z的任意字符
[0-9]
.      #代指除换行符以外的任意字符。
\w     # 字母数字下划线
\d     # 数字
\s     # 任意空白符 包括空格制表符等

*      #0 次更多次
+      # 1次更多次
？     # 0次或1次
{n}    #重复n次
{n,}   #最少n次
{n,m}  # 最少n次 最多m次


() #分组
|

^   #开始 
$   #结束

\   #转义符

```

## re模块
```py
import re
re.findall()  #获取匹配到的所有数据
re.match()    #从起始位置开始匹配，匹配成功返回一个对象，未匹配成功返回None
re.search() #浏览整个字符串去匹配第一个，未匹配成功返回None
re.sub()    #替换
re.split()  #分割
re.finditer()  #匹配所有 可以命名分组

----------------------------------------------
import re

text = "d4Bsf1234d13242B3BX大小逗2B最逗3B欢乐"

print(re.findall("(\d{2})(\d{1,3})([0-9]|X)",text)) #匹配所有

#从开头找
print(re.match("3B",text)) #None
data = re.match("d\dB", text)
if data:
    content = data.group()
    print(content)      #d4B

#搜索找到第一个
data = re.search("逗\dB", text)
if data:
    print(data.group())  #"逗2B"

#替换
data = re.sub("\dB", "沙雕", text) #全部替换
print(data) # d沙雕sf1234d1324沙雕沙雕X大小逗沙雕最逗沙雕欢乐
data = re.sub("\dB", "沙雕", text, 1)  #替换1次
print(data) # d沙雕sf1234d13242B3BX大小逗2B最逗3B欢乐

#分割
data = re.split("\dB", text)  #分割
print(data) # ['d', 'sf1234d1324', '', 'X大小逗', '最逗', '欢乐']
data = re.split("\dB", text, 1) #分割1次
print(data) # ['d', 'sf1234d13242B3BX大小逗2B最逗3B欢乐']

#找到分组打印
data = re.finditer("\dB", text)
for item in data:
    print(item.group(),end=" ")  #4B 2B 3B 2B 3B

data = re.finditer("(?P<xx>\dB)", text)  # 命名分组
for item in data:
    print(item.groupdict(),end=" ") #{'xx': '4B'} {'xx': '2B'} {'xx': '3B'} {'xx': '2B'} {'xx': '3B'}


```


## 面向对象

```py
class Message:

    def __init__(self, content):
        self.data = content

    def send_email(self, email):
        data = "给{}发邮件，内容是：{}".format(email, self.data)
        print(data)

    def send_wechat(self, vid):
        data = "给{}发微信，内容是：{}".format(vid, self.data)
        print(data)

# 对象 = 类名() # 自动执行类中的 __init__ 方法。

# 1. 根据类型创建一个对象，内存的一块 区域 。
# 2. 执行__init__方法，模块会将创建的那块区域的内存地址当self参数传递进去。    往区域中(data="注册成功")
msg_object = Message("注册成功")

msg_object.send_email("wupeiqi@live.com") # 给wupeiqi@live.com发邮件，内容是：注册成功
msg_object.send_wechat("武沛齐") # 给武沛齐发微信，内容是：注册成功

-------------
- self，本质上就是一个参数。这个参数是Python内部会提供，其实本质上就是调用当前方法的那个对象。
- 对象，基于类实例化出来”一块内存“，默认里面没有数据；经过类的 __init__方法，可以在内存中初始化一些数据。

常见成员
- 实例变量，属于对象，只能通过对象调用。
- 绑定方法，属于类，通过对象调用 或 通过类调用。


面向对象三大特性
	封装、继承、多态。

封装主要体现在两个方面：
- 将同一类方法封装到了一个类中，例如上述示例中：匪徒的相关方法都写在Terrorist类中；警察的相关方法都写在Police类中。
- 将数据封装到了对象中，在实例化一个对象时，可以通过__init__初始化方法在对象中封装一些数据，便于以后使用。

继承
面向对象中也有这样的理念，即：子类可以继承父类中的方法和类变量（不是拷贝一份，父类的还是属于父类，子类可以继承而已）。

多态
多态，按字面翻译其实就是多种形态。

- 其他编程语言多态
- Python中多态
在java或其他语言中的多态是基于：接口 或 抽象类和抽象方法来实现，让数据可以以多种形态存在。

在Python中则不一样，由于Python对数据类型没有任何限制，所以他天生支持多态。
Python默认支持多态（这种方式称之为鸭子类型）
def func(arg):
    v1 = arg.copy() # 浅拷贝
    print(v1)
    
func("武沛齐")
func([11,22,33,44])

面向对象所有成员：
- 变量
  - 实例变量
  - 类变量
- 方法
  - 绑定方法
  - 类方法
  - 静态方法
- 属性

成员修饰符：
- 公有  在任何地方都可以调用这个成员。
- 私有  只有在类的内部才可以调用改成员（成员是以两个下划线开头，则表示该成员为私有）。父类中的私有成员，子类无法继承。

特殊成员
__init__ 

__new__
class Foo(object):
    def __init__(self, name):
        print("第二步：初始化对象，在空对象中创建数据")
        self.name = name
    def __new__(cls, *args, **kwargs):
        print("第一步：先创建空对象并返回")
        return object.__new__(cls)

obj = Foo("武沛齐")
-----------------------------
__call__
class Foo(object):
    def __call__(self, *args, **kwargs):
        print("执行call方法")

obj = Foo()
obj()  #执行 __call__方法
-----------------------------
__str__
class Foo(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age

obj = Foo("武沛齐",19)
print(obj.__dict__)  #{'name': '武沛齐', 'age': 19}
-------------------------------
__dict__    #类的属性（包含一个字典，由类的数据属性组成）

class Foo(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age
obj = Foo("武沛齐",19)
print(obj.__dict__)  #{'name': '武沛齐', 'age': 19}

----------------------
__enter__   
__exit___

class Foo(object):
    def __enter__(self):
        print("进入了")
        return 666
    def __exit__(self, exc_type, exc_val, exc_tb):
        print("出去了")

obj = Foo()
with obj as data:  #with 上下文管理 会自动执行， 开始 __enter___ 结束__exit__
    print(data)
------------------------------

__add__    #加运算
class Foo(object):
    def __init__(self, name):
        self.name = name
    def __add__(self, other):
        return "{}-{}".format(self.name, other.name)
v1 = Foo("alex")
v2 = Foo("sb")
# 对象+值，内部会去执行 对象.__add__方法，并将+后面的值当做参数传递过去。
v3 = v1 + v2
print(v3)  #alex-sb
--------------------------------

__iter__
# 迭代器类型的定义：
    1.当类中定义了 __iter__ 和 __next__ 两个方法。
    2.__iter__ 方法需要返回对象本身，即：self
    3. __next__ 方法，返回下一个数据，如果没有数据了，则需要抛出一个StopIteration的异常。
	官方文档：https://docs.python.org/3/library/stdtypes.html#iterator-types
        
# 创建 迭代器类型 ：
	class IT(object):
        def __init__(self):
            self.counter = 0
        def __iter__(self):
            return self
        def __next__(self):
            self.counter += 1
            if self.counter == 3:
                raise StopIteration()
            return self.counter

# 根据类实例化创建一个迭代器对象：
    obj1 = IT()
    
    # v1 = obj1.__next__()
    # v2 = obj1.__next__()
    # v3 = obj1.__next__() # 抛出异常
    
    v1 = next(obj1) # obj1.__next__()
    print(v1)

    v2 = next(obj1)
    print(v2)

    v3 = next(obj1)
    print(v3)


    obj2 = IT()
    for item in obj2:  # 首先会执行迭代器对象的__iter__方法并获取返回值，一直去反复的执行 next(对象) 
        print(item)
        
迭代器对象支持通过next取值，如果取值结束则自动抛出StopIteration。
for循环内部在循环时，先执行__iter__方法，获取一个迭代器对象，然后不断执行的next取值（有异常StopIteration则终止循环）。

生成器
# 创建生成器函数
    def func():
        yield 1
        yield 2
    
# 创建生成器对象（内部是根据生成器类generator创建的对象），生成器类的内部也声明了：__iter__、__next__ 方法。
    obj1 = func()
    
    v1 = next(obj1)
    print(v1)

    v2 = next(obj1)
    print(v2)

    v3 = next(obj1)
    print(v3)

    obj2 = func()
    for item in obj2:
        print(item)

如果按照迭代器的规定来看，其实生成器类也是一种特殊的迭代器类（生成器也是一个中特殊的迭代器）。

可迭代对象
# 如果一个类中有__iter__方法且返回一个迭代器对象 ；则我们称以这个类创建的对象为可迭代对象。

class Foo(object): 
    def __iter__(self):
        return self迭代器对象(生成器对象)
    
obj = Foo() # obj是 可迭代对象。

# 可迭代对象是可以使用for来进行循环，在循环的内部其实是先执行 __iter__ 方法，获取其迭代器对象，然后再在内部执行这个迭代器对象的next功能，逐步取值。
for item in obj:
    pass

```


## 异常处理
```py
try:
    # 逻辑代码
except Exception as e:
    # try中的代码如果有异常，则此代码块中的代码会执行。
finally:
    # try中的代码无论是否报错，finally中的代码都会执行，一般用于释放资源。

print("end")



常见异常：
"""
AttributeError 试图访问一个对象没有的树形，比如foo.x，但是foo没有属性x
IOError 输入/输出异常；基本上是无法打开文件
ImportError 无法引入模块或包；基本上是路径问题或名称错误
IndentationError 语法错误（的子类） ；代码没有正确对齐
IndexError 下标索引超出序列边界，比如当x只有三个元素，却试图访问n x[5]
KeyError 试图访问字典里不存在的键 inf['xx']
KeyboardInterrupt Ctrl+C被按下
NameError 使用一个还未被赋予对象的变量
SyntaxError Python代码非法，代码不能编译(个人认为这是语法错误，写错了）
TypeError 传入对象类型与要求的不符合
UnboundLocalError 试图访问一个还未被设置的局部变量，基本上是由于另有一个同名的全局变量，
导致你以为正在访问它
ValueError 传入一个调用者不期望的值，即使值的类型是正确的
"""


```



## 网络编程
```py

#服务端
import socket

# 1.监听本机的IP和端口
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.bind(('127.0.0.1', 8001))  # 127.0.0.1 或 查看自己局域网本地IP地址
sock.listen(5)

while True:
    # 2.等待，有人来连接（阻塞）
    conn, addr = sock.accept()
    print("有人来连接了...")

    # 3.连接成功后立即发送
    conn.sendall("欢迎使用xx系统，请输入您想要办理的业务！".encode("utf-8"))

    while True:
        # 3.等待接受信息
        data = conn.recv(1024)
        if not data:
            break
        data_string = data.decode("utf-8")

        # 4.回复消息
        conn.sendall("你说啥？".encode("utf-8"))
    print("断开连接了")
    # 5.关闭与此人的连接
    conn.close()

# 6.停止服务端程序
sock.close()
-------------------------------------------------------

#客户端
import socket

# 1. 向指定IP发送连接请求
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(('127.0.0.1', 8001))

# 2.连接成功后，获取系统登录信息
message = client.recv(1024)
print(message.decode("utf-8"))

while True:
    content = input("请输入(q/Q退出)：")
    if content.upper() == 'Q':
        break
    client.sendall(content.encode("utf-8"))

    # 3. 等待，消息的回复
    reply = client.recv(1024)
    print(reply.decode("utf-8"))

# 关闭连接，关闭连接时会向服务端发送空数据。
client.close()





```


### osi 7层模型
```text

- 应用层：规定数据的格式。
      "GET /s?wd=你好 HTTP/1.1\r\nHost:www.baidu.com\r\n\r\n"
- 表示层：对应用层数据的编码、压缩（解压缩）、分块、加密（解密）等任务。
      "GET /s?wd=你好 HTTP/1.1\r\nHost:www.baidu.com\r\n\r\n你好".encode('utf-8')
- 会话层：负责与目标建立、中断连接。
      在发送数据之前，需要会先发送 “连接” 的请求，与远程建立连接后，再发送数据。当然，发送完毕之后，也涉及中断连接的操作。
- 传输层：建立端口到端口的通信，其实就确定双方的端口信息。
      数据："GET /s?wd=你好 HTTP/1.1\r\nHost:www.baidu.com\r\n\r\n你好".encode('utf-8')
      端口：
      	- 目标：80
      	- 本地：6784
- 网络层：标记目标IP信息（IP协议层）
      数据："GET /s?wd=你好 HTTP/1.1\r\nHost:www.baidu.com\r\n\r\n你好".encode('utf-8')
      端口：
      	- 目标：80
      	- 本地：6784
      IP：
      	- 目标IP：110.242.68.3（百度）
      	- 本地IP：192.168.10.1
- 数据链路层：对数据进行分组并设置源和目标mac地址
      数据："POST /s?wd=你好 HTTP/1.1\r\nHost:www.baidu.com\r\n\r\n你好".encode('utf-8')
      端口：
      	- 目标：80
      	- 本地：6784
      IP：
      	- 目标IP：110.242.68.3（百度）
      	- 本地IP：192.168.10.1
      MAC：
      	- 目标MAC：FF-FF-FF-FF-FF-FF 
      	- 本机MAC：11-9d-d8-1a-dd-cd
- 物理层：将二进制数据在物理媒体上传输。
		通过网线将二进制数据发送出去


```

### udp和tcp协议
```py
- UDP（User Data Protocol）用户数据报协议， 是⼀个⽆连接的简单的⾯向数据报的传输层协议。 UDP不提供可靠性， 它只是把应⽤程序传给IP层的数据报发送出去， 但是并不能保证它们能到达⽬的地。 由于UDP在传输数据报前不⽤在客户和服务器之间建⽴⼀个连接， 且没有超时重发等机制， 故⽽传输速度很快。
      常见的有：语音通话、视频通话、实时游戏画面 等。
- TCP（Transmission Control Protocol，传输控制协议）是面向连接的协议，也就是说，在收发数据前，必须和对方建立可靠的连接，然后再进行收发数据。
      常见有：网站、手机APP数据获取等。

UDP 
#server
import socket

server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
server.bind(('127.0.0.1', 8002))

while True:
    data, (host, port) = server.recvfrom(1024) # 阻塞
    print(data, host, port)
    server.sendto("好的".encode('utf-8'), (host, port))
#client
import socket

client = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
while True:
    text = input("请输入要发送的内容：")
    if text.upper() == 'Q':
        break
    client.sendto(text.encode('utf-8'), ('127.0.0.1', 8002))
    data, (host, port) = client.recvfrom(1024)
    print(data.decode('utf-8'))

client.close()
--------------------------------------------------------
TCP
#server
import socket

# 1.监听本机的IP和端口
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.bind(('127.0.0.1', 8001))
sock.listen(5)

while True:
    # 2.等待，有人来连接（阻塞）
    conn, addr = sock.accept()

    # 3.等待，连接者发送消息（阻塞）
    client_data = conn.recv(1024)
    print(client_data)

    # 4.给连接者回复消息
    conn.sendall(b"hello world")

    # 5.关闭连接
    conn.close()

# 6.停止服务端程序
sock.close()

#client
import socket

# 1. 向指定IP发送连接请求
client = socket.socket()
client.connect(('127.0.0.1', 8001))

# 2. 连接成功之后，发送消息
client.sendall(b'hello')

# 3. 等待，消息的回复（阻塞）
reply = client.recv(1024)
print(reply)

# 4. 关闭连接
client.close()


```































