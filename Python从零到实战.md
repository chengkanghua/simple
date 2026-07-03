# Python 从零到实战：完整学习路线

# 第一阶段：Python 环境搭建

先把工具装好，才能开始写代码

1. 下载安装 Python（官网免费，记得勾选 **Add Python to PATH**）
2. 安装代码编辑器：推荐 **VS Code**（最简单、免费）
3. 测试是否成功：打开命令行输入 `python --version`，出现版本号就成功了



```bash
企业生产最主流：Python 3.11.x
生态兼容性最强，几乎所有第三方库都完美适配，维护到 2027 年 10 月，老项目、运维、数据分析岗位最常用。

新手 / 新项目首选：Python 3.12.x（强烈推荐你安装）
长期稳定支持到 2028 年 10 月，运行速度大幅提升，语法更简洁，兼顾稳定 + 新特性，新手直接装这个，避坑最多。

主流工具盘点
（1）VS Code（微软）
免费开源、轻量启动快、插件无限扩展，支持所有编程语言，低配电脑也流畅，新手首选第一名。
（2）PyCharm
专业级 Python IDE，社区版免费，内置全部 Python 功能，不用装插件；缺点：体积大、内存占用高，适合大型项目、专业开发。
（3）Jupyter Notebook/Lab
交互式编辑器，一行代码一运行，适合数据分析、爬虫、AI 学习、笔记式写代码，经常搭配 VS Code 使用。
（4）自带 IDLE
Python 安装自带，极简无插件，仅适合临时写几行测试代码，不适合长期开发。
（5）Sublime Text
极速轻量，付费可无限试用，适合追求流畅极简的开发者。


# python 国内下载地址
https://www.python.org/ftp/python/3.12.10/
https://mirrors.huaweicloud.com/python/

```



## vs code python插件

```bash
三、VS Code Python 必装插件（附详细作用）
🔴 4 个核心必装（缺一不可）
1. Python（Microsoft 官方）
Python官方插件
作用：Python 开发基础核心
识别.py文件、代码高亮、一键运行 Python 代码
断点调试、变量查看、错误报错提醒
自动识别本机多个 Python 解释器、虚拟环境管理
内置 Jupyter Notebook 运行能力，不用额外装软件
2. Pylance（微软官方，安装 Python 插件会自动附带）
作用：超强智能代码提示引擎
代码自动补全、函数参数提示、点击跳转源码定义
实时语法纠错、提前发现变量类型错误、拼写错误
大幅提升大项目代码加载速度，告别编辑器卡顿
3. Black Formatter
作用：一键自动格式化代码
Python 有严格编码规范，手写容易格式混乱；保存文件瞬间自动缩进、换行、对齐，统一代码风格，避免低级格式报错，团队协作必备。
4. isort
作用：自动整理导入包顺序
自动把代码里import导入的第三方库、系统库分类排序，代码整洁规范。
🟡 新手进阶推荐插件（按需安装）
Chinese (Simplified) Language Pack
VS Code 中文汉化插件，英文界面一键切换中文，新手必备。
Python Snippets
内置上百个 Python 常用代码片段（循环、判断、函数、文件读写模板），输入简写一键生成代码，不用重复敲基础模板。
GitLens
代码版本管理插件，查看每一行代码是谁修改、什么时候改的，后续做项目必备。
Error Lens
把代码错误直接显示在代码行右侧，不用鼠标悬浮查看，一眼定位 bug 位置。
🟢 数据分析方向额外装
Jupyter：在 VS Code 里直接运行.ipynb 交互式代码文件，做爬虫、数据分析、机器学习专用。
Data Preview：表格、Excel 数据可视化预览。

四、新手极简安装步骤总结
安装 Python 3.12.x，务必勾选Add Python to PATH
安装 VS Code + Chinese 中文汉化插件
扩展商店搜索安装：Python、Black Formatter、isort
打开.py 文件，右上角选择本机 3.12 解释器，即可开始写代码
```



## 虚拟环境创建

```bash

vscode  ctrl+shift +p   输入 python: create Environments 
选择 venv 新建项目虚拟环境

方案 1：【最标准、企业通用推荐】放在当前项目根目录
✅ 路径格式：你的项目文件夹/.venv
示例：D:\code\PythonStudy01\.venv

命令行原生操作（venv，不用依赖插件）
进入你的项目文件夹终端
快捷键 Ctrl+` 打开 VS Code 内置终端，确保当前路径是项目根目录
# Windows / Mac / Linux 通用
python -m venv .venv
# 激活虚拟环境（必须激活才能隔离包）
cmd
.venv\Scripts\activate.bat
powershell
.\.venv\Scripts\Activate.ps1
Mac / Linux：
source .venv/bin/activate

在虚拟环境安装依赖
# 仅当前项目可用
pip install requests pandas
# 查看当前环境所有包
pip list
# 导出项目依赖清单（给别人部署用）
pip freeze > requirements.txt
# 别人一键安装所有依赖
pip install -r requirements.txt

退出虚拟环境
deactivate

删除虚拟环境 
直接删除.venv文件夹
```






## 推荐教程地址

[官方教程](https://docs.python.org/zh-cn/3/tutorial/index.html)
[廖雪峰python](https://www.liaoxuefeng.com/wiki/1016959663602400)

# 第二阶段 python基础

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

单行注释用#，多行注释可以用三对双引号""""  """"
代码注释原则:
1. 不用给全部代码加注释，只需要在自己觉得重要或不好理解的部分加注释即可
2. 注释可以用中文或英文，但绝对不要拼音噢
3. 注释不光要给自己看，还要给别人看，所以请认真写
```

## python 变量和数据类型

### 你只要记住 5个类型：

1. `"文字"` → **str 字符串**
2. `123` → **int 整数**
3. `1.23` → **float 浮点数**
4. `True / False` → **bool 布尔**
5. NoneType

```python
# ====================== 1. 什么是变量？ ======================
# 变量 = 给数据起个名字，方便以后使用
# 格式：变量名 = 数据
name = "张三"          # 名字叫name，存的是字符串"张三"
age = 20              # 名字叫age，存的是数字20
height = 1.75         # 身高
is_student = True     # 是否是学生

# ====================== 2. 打印变量（看变量里存了啥） ======================
print(name)
print(age)
print(height)
print(is_student)

# ====================== 3. Python 最常用 5 种数据类型 ======================
# ① 字符串 str —— 文字、名字、句子（必须用引号包起来）
a = "我是字符串"
b = 'Python也可以单引号'
print(type(a))  # type() 查看数据类型

# ② 整数 int —— 没有小数点的数字
c = 100
d = -50
print(type(c))

num = 10000
print(bin(num))

# ③ 浮点数 float —— 带小数点的数字
e = 3.14
f = 0.5
print(type(e))

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

# ④ 布尔值 bool —— 只有两个值：True / False
g = True
h = False
print(type(g))

v1 = True + True
print(v1) # 2
# 底层原理：Python中布尔类型bool是整数类型int的子类
# True在底层等价于整型数字 1
# False在底层等价于整型数字 0
# 布尔值参与算术运算时，会自动转换成对应的整数进行计算
# True + True = 1 + 1 = 2

# ====================== 4. 变量可以重新赋值（随时改） ======================
age = 20
age = 21        # 覆盖原来的值
print(age)      # 输出21

# 5. 空类型 NoneType（很多新手容易漏掉，用来表示空、无数据）
none_data = None
print(type(none_data))

# ====================== 5. 变量命名规则（必须遵守） ======================
# 1. 只能用 字母、数字、下划线
# 2. 不能以数字开头
# 3. 区分大小写
# 4. 不要用中文（企业规范不用中文）
# 5. 见名知意：name、age、score 比 a、b、c 专业

# 正确
user_name = "小明"
score = 99

# 错误（不能数字开头）
# 123abc = 10

# ====================== 6. 最简单的练习：变量拼接输出 ======================
name = "李四"
age = 22
print("姓名：", name, "年龄：", age)

#输入和输出
name = input("请输入你的名字：")
print("你好：", name)

# ==================== 3. 补充：类型分类小总结 ====================
# 1. 基础单一类型（5种）：str、int、float、bool、NoneType
# 2. 容器复合类型（4种）：list、tuple、set、dict


三句话搞定类型转换：
- 其他所有类型转换为布尔类型时，除了 空字符串、0以为其他都是True。
- 字符串转整形时，只有那种 "988" 格式的字符串才可以转换为整形，其他都报错。
- 想要转换为那种类型，就用这类型的英文包裹一下就行。
```



## 字符串内置方法

```bash
# 字符串特性：字符串str属于不可变类型，
# 一旦创建无法在原内存中修改字符，所有字符串方法均会返回新字符串，原字符串保持不变

# 1. 开头结尾判断
str.startswith()       # 判断字符串是否以指定子串开头，返回布尔值True/False
str.endswith()         # 判断字符串是否以指定子串结尾，返回布尔值True/False

# 2. 数字类判断方法
str.isdecimal()        # 判断字符串是否仅包含十进制数字，仅支持纯阿拉伯数字，不识别罗马数字、中文数字
str.isdigit()          # 判断字符串是否为数字字符，可识别阿拉伯数字、带上下标的数字字符

# 3. 首尾空白字符去除（空格、制表符\t、换行符\n）
str.strip()            # 移除字符串 左侧+右侧 所有空白字符，可指定要移除的字符
str.lstrip()           # 仅移除字符串 左侧 空白字符，可指定要移除的字符
str.rstrip()           # 仅移除字符串 右侧 空白字符，可指定要移除的字符

# 4. 大小写转换
str.upper()            # 将字符串中所有英文字母转为大写，返回新字符串
str.lower()            # 将字符串中所有英文字母转为小写，返回新字符串
str.capitalize()       # 首字母大写，其余字母全部小写
str.title()            # 每个单词的首字母转为大写，其余小写
str.swapcase()         # 大小写互相反转，大写变小写、小写变大写

# 5. 字符串替换
str.replace("source","dest")  # 将字符串中所有匹配的source子串替换为dest，可传入第三个参数指定最大替换次数

# 6. 分割与拼接
str.split("|",[num])   # 按照指定分隔符分割字符串，返回列表；num限制分割次数，默认分割全部匹配项
str.rsplit("|",[num])  # 从字符串右侧开始执行分割操作
str.join(data_list)    # 以当前字符串作为分隔符，将可迭代序列（列表/元组等）中的所有元素拼接成一个新字符串

# 7. 格式化输出
str.format()           # 占位符{}格式化字符串，通过位置、关键字参数填充占位内容
f-string               # Python3.6+推荐格式化写法，直接在{}中嵌入变量、表达式
str.format_map()       # 使用字典键值对填充字符串占位符

# 8. 编码解码（字节串与字符串互转）
str.encode()           # 将字符串按照指定编码格式（默认utf-8）编码为bytes字节类型
bytes.decode()         # 将bytes字节数据按照指定编码解码还原为字符串

# 9. 对齐、填充方法
str.center(width)      # 设置总宽度width，字符串居中对齐，两侧默认用空格填充，可指定填充字符
str.ljust(width)       # 设置总宽度width，字符串左对齐，右侧填充字符
str.rjust(width)       # 设置总宽度width，字符串右对齐，左侧填充字符
str.zfill(width)       # 右侧对齐，在字符串左侧用数字0填充至指定总宽度，常用于补全编号

# 10. 查找统计类常用方法
str.find()             # 从左向右查找子串首次出现的索引，找不到返回-1
str.rfind()            # 从右向左查找子串首次出现的索引，找不到返回-1
str.index()            # 从左向右查找子串索引，找不到直接抛出异常
str.rindex()           # 从右向左查找子串索引，找不到直接抛出异常
str.count()            # 统计指定子串在字符串中出现的总次数

# 11. 字符类型校验补充常用方法
str.isalpha()          # 判断字符串是否全部由字母组成
str.isalnum()          # 判断字符串是否仅由字母+数字组成
str.isspace()          # 判断字符串是否全部由空白字符（空格、\t、\n）构成
str.istitle()          # 判断字符串是否符合每个单词首字母大写的标题格式
str.islower()          # 判断字符串所有英文字母是否均为小写
str.isupper()          # 判断字符串所有英文字母是否均为大写

# 12. 其他高频常用方法
str.partition()        # 按第一个匹配的分隔符把字符串分割为：(前缀,分隔符,后缀)三元元组
str.rpartition()       # 从右侧第一个匹配分隔符分割为(前缀,分隔符,后缀)三元元组
str.expandtabs()       # 将字符串中的制表符\t替换为指定个数的空格
```









## python运算符

```python
# ====================== 一、知识点总结（你的理解验证） ======================
# 1. Python 五大基础标量（单个值）数据类型：str、int、float、bool、NoneType
#    这类变量只能存储单个数据，属于最底层基础类型
str_var = "测试字符串"
int_var = 10
float_var = 3.5
bool_var = True
none_var = None
print(type(str_var), type(int_var), type(float_var), type(bool_var), type(none_var))

# 2. 容器类型(list/tuple/set/dict)完全可以理解为Python内置的数据结构
#    作用：批量存储、管理多个基础类型的数据，是组织数据的结构载体
list_var = [1, "a", True]
dict_var = {"name":"张三", "age":20}
print(type(list_var), type(dict_var))

# 3. 你的理解正确：Python运算符主要就是针对基础数据类型做计算、比较、逻辑判断
#    容器类型也支持部分运算符（比如列表拼接、集合运算），但核心运算场景还是基础标量类型

# ====================== 二、Python 全部常用运算符（代码+详细注释演示） ======================
# 1. 算术运算符（数字int/float最常用，做加减乘除数学计算）
a = 10
b = 3
print("==========算术运算符==========")
print(f"a + b = {a + b}")      # 加法
print(f"a - b = {a - b}")      # 减法
print(f"a * b = {a * b}")      # 乘法
print(f"a / b = {a / b}")      # 除法，结果永远是float浮点数
print(f"a // b = {a // b}")    # 地板除（向下取整，只保留整数部分）
print(f"a % b = {a % b}")      # 取余，获取除法后的余数
print(f"a ** b = {a ** b}")    # 幂运算，10的3次方

# 字符串仅支持 + 拼接、* 重复两个算术运算
str1 = "Hello"
str2 = "Python"
print(str1 + str2)  # 字符串拼接
print(str1 * 3)     # 字符串重复3次

# 2. 赋值运算符：给变量赋值、运算后重新赋值
print("\n==========赋值运算符==========")
num = 5
num += 2   # 等价于 num = num + 2
print(num)
num -= 1   # num = num -1
print(num)
num *= 3   # num = num *3
print(num)
num /= 2   # num = num /2
print(num)
num //= 2  # 地板除后赋值
num %= 2   # 取余赋值
num **= 2  # 幂运算赋值

# 3. 比较运算符：返回结果一定是布尔值True/False，用于条件判断
print("\n==========比较运算符==========")
x = 20
y = 15
print(x == y)   # == 判断是否相等
print(x != y)   # != 判断是否不相等
print(x > y)    # 大于
print(x < y)    # 小于
print(x >= y)   # 大于等于
print(x <= y)   # 小于等于

# 4. 逻辑运算符：操作布尔类型，多条件组合判断
print("\n==========逻辑运算符==========")
score = 85
# and 并且：两个条件同时满足才返回True
print(score > 60 and score < 90)
# or 或者：任意一个条件满足就返回True
print(score > 90 or score < 60)
# not 取反：布尔值反转
print(not score > 90)

# 5. 身份运算符：判断两个变量是否指向同一个内存地址
print("\n==========身份运算符==========")
m = [1,2,3]
n = [1,2,3]
print(m is n)       # is 判断是否是同一个对象
print(m is not n)   # is not 判断不是同一个对象

# 6. 成员运算符：判断元素是否存在于容器类型（数据结构）中
print("\n==========成员运算符==========")
name_list = ["张三", "李四", "王五"]
print("张三" in name_list)      # in 判断元素是否在容器内
print("赵六" not in name_list)  # not in 判断元素不在容器内

# 7. 位运算符（二进制底层运算，开发较少用，底层、算法场景使用）
print("\n==========位运算符==========")
p = 6  # 二进制 110
q = 3  # 二进制 011
print(p & q)   # 按位与
print(p | q)   # 按位或
print(p ^ q)   # 按位异或
print(~p)      # 按位取反
print(p << 1)  # 左移1位
print(p >> 1)  # 右移1位

充要点
None 空类型不能参与算术、逻辑运算，只能用 is / == 判断是否为空；
布尔类型本质是整数子类，True=1、False=0，可以直接参与数字算术运算；
运算符优先级：算术 > 比较 > 逻辑，想改变运算顺序可以用小括号()包裹。

# ===================== 运算符优先级 =====================
# 括号 > 幂运算 > 乘除取余 > 加减 > 移位 > 位运算 > 比较 > not > and > or
# 同级运算符：大部分从左向右计算，只有幂运算** 是从右向左计算
# 示例：复杂运算验证优先级
complex_res = 10 + 2 ** 3 * 4 > 30 and not 5 < 2
print(f"\n复杂表达式运算结果：10 + 2 ** 3 * 4 > 30 and not 5 < 2 = {complex_res}")
# 分步拆解：
# 1. 先算幂运算 2**3=8
# 2. 再算乘法 8*4=32
# 3. 再加法 10+32=42
# 4. 比较 42>30 → True
# 5. not 5<2 → True
# 6. True and True → True

```



## python 的容器类型（数据结构）

```bash
# ===================== Python四大容器类型（内置常用数据结构） =====================
# 容器作用：可以存放多个数据，用来批量管理基础类型变量
# 四大容器：列表list、元组tuple、集合set、字典dict
# 两大分类：序列类型(list/tuple)、无序类型(set/dict)

# ===================== 一、列表 list 【最常用，有序、可重复、可增删改查】 =====================
# 定义：[] 中括号，元素可以是任意数据类型，允许重复，有序排列
# 企业场景：存储一组有序数据、表格多行数据、临时数据缓存
list_demo = ["张三", 22, 1.75, True, "张三"]
print("原始列表：", list_demo)
print("列表类型：", type(list_demo))
print("通过索引取值(从0开始)：", list_demo[0])
print("列表长度：", len(list_demo))

# 1. 增
list_demo.append("李四")  # 末尾追加元素
list_demo.insert(1, "插入元素")  # 指定索引位置插入
list_demo.extend([11,22,33])
# 2. 删
list_demo.pop()  # 默认删除末尾元素，可指定索引删除
list_demo.pop(1) #索引1位置踢出
list_demo.remove("张三")  # 根据元素值删除第一个匹配项
# 3. 改
list_demo[0] = "小明"  # 通过索引直接赋值修改元素
# 4. 查
print("正向索引取值：", list_demo[1])
print("反向索引取值(倒数第一个)：", list_demo[-1])
list_demo.index("alex") #根据值找索引位置

# 遍历列表
for item in list_demo:
    print("遍历列表元素：", item)

#list   有序可变
list_demo = ['佐助',"宝强",18,True,'alex']
list_demo.clear()  #清空列表内所有元素
list_demo.sort(reverse=True) ## 对列表内元素进行原地升序排序；reverse=True代表降序排序，仅支持元素类型一致的列表
list_demo.reverse() # # 将列表中元素顺序原地反转，不做大小排序，只是颠倒原有前后位置
print(user_list)




# ===================== 二、元组 tuple 【有序、可重复、不可修改（只读安全）】 =====================
# 定义：() 小括号，一旦定义不能增删改，只能查询，适合固定不变的数据
# 场景：配置参数、坐标、函数多返回值，防止数据被意外篡改
tuple_demo = ("北京", "上海", "广州", "深圳")
print("\n原始元组：", tuple_demo)
print("元组类型：", type(tuple_demo))
print("索引取值：", tuple_demo[1])

# 注意：元组不可修改，以下代码会直接报错
# tuple_demo[0] = "南京"

# 特殊：只有一个元素的元组必须加逗号，否则会被识别为字符串/数字
single_tuple = (10,)
print("单元素元组类型：", type(single_tuple))

#tuple  有序且不可变的容器  但元组的元素如果是可变类型，可变类型内部是可以修改的。
(1,)  # 单元素元组，必须末尾加逗号，否则会被识别为普通整型变量
(1,2,3,)  # 多元素元组，末尾可以加逗号，不影响语法，属于规范写法

# 元组公共操作功能
tuple + tuple  # 两个元组进行拼接，返回新元组，原元组不会被修改
tuple * 2  # 元组重复指定次数，返回拼接后的新元组
len(tuple)  # 获取元组内元素总个数，返回整数
tuple[0]  # 通过正向索引取值，获取元组第1个元素
tuple[0:2]  # 切片操作，从索引0开始截取，到索引2之前结束，左闭右开，返回新元组
tuple[1:]  # 从索引1位置开始，截取到元组末尾所有元素
tuple[:-1]  # 从开头截取到倒数第2个元素，排除最后一个元素
tuple[1:4:2]  # 带步长切片：索引1开始、索引4前结束，每隔2个元素取一个
tuple[::-1]  # 步长为-1，对元组进行反转，返回元素倒序排列的新元组

# str、list、tuple set 可以被for循环
for item in tuple:
	pass 



# ===================== 三、集合 set 【无序、元素唯一自动去重、可增删、不能索引取值】 =====================
# 定义：{} 大括号，无序排列，重复元素会自动剔除，不能通过索引取值
# 场景：数据去重、两个数据集求交集、并集、差集
set_demo = {10, 20, 20, 30, 10, "Python"}
print("\n去重后的集合：", set_demo)
print("集合类型：", type(set_demo))

# 增删操作
set_demo.add(40)  # 添加单个元素
set_demo.remove(10)  # 删除指定元素;元素不存在时，会直接抛出KeyError异常，程序终止
set_demo.discard("alex")  # 删除集合中指定元素，若该元素不存在不会抛出异常，程序正常执行

# 集合运算
set1 = {1, 2, 3, 4}
set2 = {3, 4, 5, 6}
print("交集(两个集合都有的元素)：", set1 & set2)
print("并集(两个集合所有元素去重)：", set1 | set2)
print("差集(只在set1存在的元素)：", set1 - set2)

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



# ===================== 四、字典 dict 【无序(3.7+插入有序)、键值对存储、键唯一不可重复】 =====================
# 定义：{key: value} 键值对格式，无序(3.6版本之后是有序);key必须是不可变类型(str/int/tuple)，value可以是任意类型
# 场景：存储结构化数据（用户信息、接口返回JSON数据），开发最高频容器
字典中对键值得要求：
- 键：必须可哈希。 int/bool/str/tuple；
	不可哈希的类型：list/set/dict。
- 值：任意类型。

dict_demo = {
    "name": "张三",
    "age": 22,
    "height": 1.75,
    "is_student": True
}
print("\n原始字典：", dict_demo)
print("字典类型：", type(dict_demo))

# 1. 查：通过键获取值
print("根据key取值姓名：", dict_demo["name"])
print("根据key取值姓名：", dict_demo.get["name"])
print("安全取值(不存在不会报错)：", dict_demo.get("gender", "未知"))

# 2. 增/改：key存在则修改，不存在则新增
dict_demo["gender"] = "男"
dict_demo["age"] = 23
dict.setdefault("age",18) #类似于list.append
dict.update("age":14,"name":"alex")

# 3. 删
dict_demo.pop("height")
dict.popitem()  #后进先出 3.6版本之后移除最后的值，3.6之前随机删除
del dict['gender']

# 字典常用遍历
print("遍历所有key：", list(dict_demo.keys()))
print("遍历所有value：", list(dict_demo.values()))
print("遍历键值对：", list(dict_demo.items()))
dict.keys()  #返回dict_keys([xx,xxx]) 使用list() 转换list
dict.values()
dict.items()

for item in dict_data: # for item in dict_data.key():
	print(item)

for key,value in info.items():
	print(key,values)  

for item in info.items():
	print(item[0],item[1])

if ("age",12) in dict_data:
	print("is in")
	
	
# dict1 | dict2 # 3.9版本新增功能  并集：
len(dict_data)
"age" in dict_data #是否包含





# ===================== 四大容器核心特性总结 =====================
'''
1. list 列表：有序、可重复、可增删改 → 通用存储有序数据
2. tuple 元组：有序、可重复、只读不可改 → 存放固定配置数据
3. set 集合：无序、自动去重、无索引 → 数据去重、集合运算
4. dict 字典：键值对、key唯一、value任意 → 结构化数据存储
'''

# ===================== 可变类型 vs 不可变类型（高频面试考点） =====================
# 可变容器：list、set、dict → 可以在原内存地址修改内部元素
# 不可变容器：tuple → 无法修改内部元素，只能重新创建
```



## Python 类型系统深度解析：从底层原理到设计哲学

```python
# ==================================================
# Python 类型系统深度解析：从底层原理到设计哲学
# 核心认知：Python 是「动态强类型」语言，一切皆对象，变量是「名字绑定」而非「值容器」
# 掌握这一层，才能从语法使用者进阶到原理理解者
# ==================================================

# ===================== 一、变量的本质：名字绑定（引用语义） =====================
# 【新手最容易踩的坑】Python 变量不是装数据的「盒子」，而是贴在对象上的「标签/名字」
# 所有数据（int/str/list...）都是堆内存中的对象，变量只是绑定对象的引用名字
# 这是 Python 和 C/Java 基础类型最本质的区别

a = 100
b = a
print(id(a) == id(b))  # True：两个名字绑定同一个整数对象，内存地址完全相同
# 设计缘由：
# 1. 统一对象模型：所有数据都是对象，统一用引用传递，简化类型系统
# 2. 内存高效：不可变对象可复用，不用每个变量都存一份副本
# 3. 函数传参默认传引用：避免大对象拷贝的性能开销

# 关键区分：is vs ==
# is：比较两个变量是否绑定同一个内存对象（地址相同）
# ==：比较两个对象的「值」是否相等（调用__eq__魔法方法）
list1 = [1,2,3]
list2 = [1,2,3]
print(list1 == list2)  # True：值相同
print(list1 is list2)  # False：是两个独立的列表对象，内存地址不同

# 延伸：可变对象的引用副作用
list3 = list1
list3.append(4)
print(list1)  # [1,2,3,4]：list1和list3是同一个对象的两个名字，改一个另一个跟着变
# 设计取舍：
# 优点：大对象传递不用拷贝，性能高
# 缺点：容易出现意外修改，所以诞生了浅拷贝/深拷贝的解决方案


# ===================== 二、基础标量类型：不可变设计的底层逻辑 =====================
# 五大基础类型：int / float / str / bool / NoneType
# 共同特性：全部是「不可变对象」——对象创建后，内存中的值绝对不能修改
# 为什么要设计成不可变？四大核心原因：
# 1. 哈希安全：哈希值固定，可作为字典的key、集合的元素
# 2. 内存复用：相同值的对象可以全局共享，节省内存（小整数池、字符串驻留）
# 3. 线程安全：多线程环境下只读对象不会产生竞态条件，无需加锁
# 4. 语义可靠：作为常量、配置时，不会被意外修改

# ---------- 1. int 整数：任意精度大整数 ----------
# 底层实现：C 语言实现的大整数结构体（PyLongObject），不是C语言的int/long
# 设计特性：无溢出风险，支持无限大的整数，牺牲微量性能换取极致易用性
# 优化机制：小整数池缓存
# Python 启动时会提前创建 [-5, 256] 范围内的所有整数对象，全局复用
a = 10
b = 10
print(a is b)  # True：10在小整数池内，全局同一个对象

c = 1000
d = 1000
print(c is d)  # 交互式环境下为False，超出小整数池范围，每次创建新对象
# 设计缘由：小整数是程序中最高频使用的，缓存后避免频繁创建销毁，大幅提升性能

# ---------- 2. str 字符串：Unicode 不可变字符序列 ----------
# Python3 彻底统一为 Unicode 字符串，解决了Python2的编码灾难
# 底层：PyUnicodeObject 结构体，按字符宽度存储，兼容全语言字符
# 不可变设计的核心收益：
# 1. 字符串驻留（intern机制）：相同字面量的字符串全局复用
s1 = "hello"
s2 = "hello"
print(s1 is s2)  # True：驻留机制复用对象
# 2. 可哈希：天然可以作为字典的key
# 3. 字符串方法全返回新对象，原字符串永远安全，不会被意外篡改
# 设计取舍：频繁拼接字符串会产生大量临时对象，所以推荐用join而非+=

# ---------- 3. float 浮点数：IEEE 754 双精度浮点数 ----------
# 底层：完全遵循IEEE 754工业标准，64位双精度，和C的double完全一致
# 经典问题：0.1 + 0.2 != 0.3
print(0.1 + 0.2)  # 0.30000000000000004
# 缘由：十进制小数转二进制会出现无限循环，浮点数只能存储近似值
# 设计选择：采用通用工业标准，兼容性优先；高精度场景用decimal模块

# ---------- 4. bool 布尔类型：int 的子类 ----------
# 历史缘由：Python 2.2 才引入bool类型，为了向后兼容，直接设计为int的子类
# True 底层就是整数1，False就是整数0
print(int(True))   # 1
print(int(False))  # 0
print(True + True) # 2：算术运算时自动转为int
# 设计意义：语义化区分逻辑值和整数，提升代码可读性
# 注意：isinstance(True, int) 返回True，这是设计使然，不是bug

# ---------- 5. NoneType：单例空值类型 ----------
# 全局只有一个None对象，严格单例模式
print(id(None))  # 全局唯一地址
a = None
b = None
print(a is b)  # True：永远只有一个None实例
# 设计思想：
# 1. 统一空值语义：表示「不存在、无值、未初始化」，避免用0/空字符串/False产生歧义
# 2. 单例模式：节省内存，判断空值统一用 `x is None`，高效且规范


# ===================== 三、容器类型：四大内置数据结构的设计权衡 =====================
# 设计哲学：「内置电池」——把开发最高频的数据结构内置化，C语言实现，性能拉满
# 每个容器都针对特定场景做了极致优化，没有银弹，选对场景才是大师水准

# ---------- 1. list 列表：动态数组（可变、有序、可重复） ----------
# 底层数据结构：C实现的动态指针数组（PyListObject），连续内存存储元素的指针
# 核心特性：
# - 随机访问：通过索引取值 O(1) 时间复杂度，极快
# - 尾部操作：append/pop尾部 均摊O(1)
# - 中间操作：插入/删除中间元素 O(n)，需要移动后续所有元素
# 动态扩容机制：
# 当列表容量不足时自动扩容，扩容因子约为 1.125 倍（new_size = size + size//8 + 3）
# 设计权衡：
# 优点：随机访问快，尾部操作高效，最符合日常开发的线性存储需求
# 缺点：中间插入删除慢，内存连续，超大列表对内存碎片敏感
# 适用场景：绝大多数有序数据存储、遍历、尾部追加的场景

# ---------- 2. tuple 元组：不可变数组（只读、有序、可重复） ----------
# 底层：和list一样是指针数组，但是创建后长度、元素绑定关系都不能修改
# 为什么有了list还要tuple？三大设计意义：
# 1. 语义化：表示「固定不变的一组数据」，比如坐标、函数多返回值，代码可读性更强
# 2. 性能优势：创建速度比list快30%以上，小元组有缓存复用，内存占用更小
# 3. 可哈希：元素全为不可变类型的元组，可以当字典的key、放进集合
t = (1,2,3)
print(hash(t))  # 有固定哈希值
# 设计取舍：牺牲修改能力换安全性、性能、哈希能力，是Python「只读语义」的核心体现
# 延伸：元组拆包语法，就是为了多值传递更简洁设计的语法糖

# ---------- 3. set 集合：哈希表实现的无序去重集合 ----------
# 底层：开放寻址法实现的哈希表，只有key没有value，和dict同源
# 核心特性：
# - 元素唯一：自动去重，重复元素无法存入
# - 查找极快：成员判断 in 操作平均O(1)，比list的O(n)快几个数量级
# - 原生支持集合运算：交&、并|、差-、对称差^，完全对齐数学集合语义
# 设计取舍：
# 优点：去重、成员判断、集合运算性能天花板
# 缺点：元素必须可哈希（不可变），语义上不保证有序，不支持索引访问
# 适用场景：数据去重、海量数据成员判断、多集合逻辑运算
# 注意：Python3.7+ 底层实现上保留插入顺序，但语言规范不承诺有序，集合的核心是成员关系不是顺序

# ---------- 4. dict 字典：哈希表实现的键值映射 ----------
# 底层：开放寻址法的哈希表，Python3.6后重构为有序哈希表，3.7正式成为语言规范
# 核心特性：
# - 键值对存储：通过key快速查找value，平均O(1)时间复杂度
# - key必须可哈希：不可变类型才能当key，可变类型（list/dict）会直接报错
# - 插入有序：保留键的插入顺序，兼顾哈希性能和顺序语义
# 设计地位：Python 中最核心的数据结构，类的属性、全局变量、模块命名空间，底层全是dict
# 设计优化历程：
# Python2：无序，链地址法哈希表，内存占用大
# Python3.6+：开放寻址+插入有序，内存减少30%以上，综合性能大幅提升
# 设计思想：把最常用的映射结构做到极致，是Python「内置电池」哲学的最佳体现


# ===================== 四、Python 类型系统的顶层设计哲学 =====================
# 1. 一切皆对象：统一对象模型
# 没有Java那种「基本类型」和「引用类型」的区分，int/str/函数/类全都是对象
# 好处：类型系统高度一致，所有对象都可以赋值、传参、调用方法，学习成本低

# 2. 易用性优先，性能做兜底
# 比如：任意精度int、自动内存管理（引用计数+分代GC）、内置丰富方法
# 设计理念：99%的场景下，开发者不用关心底层，专注业务逻辑；
# 极端性能场景可以用C扩展，不牺牲普通场景的易用性

# 3. 约定优于配置，语法直观
# [] 列表、() 元组、{} 字典/集合，字面量语法直观，不用new关键字
# 方法命名统一语义，比如append/add/pop，见名知意

# 4. 可变与不可变的边界清晰
# 基础类型全不可变（安全、可缓存），容器类型分可变/不可变
# 给开发者选择的空间：需要安全、哈希就用不可变；需要动态修改就用可变

# 5. 性能与功能的平衡艺术
# 每个类型都不是完美的，都是针对核心场景做了极致优化，非核心场景做妥协
# 大师级使用：不是什么都用list，而是根据场景选最合适的容器
# 比如：只做成员判断用set，存结构化数据用dict，固定配置用tuple，动态列表用list
```



## Python vs Shell 核心差异

```bash
# ========== Python vs Shell 核心差异（精简版） ==========
# 1. 本质定位
# Python: 通用高级编程语言，自身具备完整计算与抽象能力
# Shell:  系统命令解释器，核心是调度外部工具的胶水，自身计算能力极弱

# 2. 变量与类型
# Python: 动态强类型，原生 str/int/float/bool/None，变量是对象引用
# Shell:  无原生类型，所有变量本质都是字符串；取值必须加$，算术依赖 $(( ))

# 3. 数据结构
# Python: 原生 list/tuple/set/dict，工业级性能，支持任意嵌套
# Shell:  仅支持一维字符串数组，bash4+才有简陋关联数组；无原生集合，功能极简

# 4. 执行模型
# Python: 单进程虚拟机内执行，计算在自身进程完成，纯运算性能高
# Shell:  绝大多数功能靠 fork 子进程调用外部命令；管道本质是多进程传数据，进程开销大

# 5. 错误处理
# Python: 完整 try-except 异常机制，报错带栈回溯，调试成本低
# Shell:  靠退出码 $? 判断成败，默认出错不终止脚本，需手动 set -e 增强健壮性

# 6. 选型原则
# Shell:  几十行内轻量运维、纯管道处理大文本、批量执行系统命令
# Python: 复杂逻辑、结构化数据处理、跨平台脚本、需长期维护的代码
```



 

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
print(old)
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































