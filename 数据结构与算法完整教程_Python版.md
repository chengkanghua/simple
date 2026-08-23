# 数据结构与算法 · 完整教程（Python版）
> 本教程从零开始，以 Python 为教学语言，用简洁明了、通俗易懂的方式系统讲解数据结构与算法。
> 全教程分为 8 个阶段、23 个主题，每个主题都包含概念讲解、Python 代码实现、复杂度分析和经典例题。

---

## 数据结构与算法 · 从零开始学习大纲

> 本大纲按照由浅入深的顺序编排，适合编程零基础或初学者系统学习。建议每个阶段配合大量练习题巩固理解。

---

### 第一阶段：基础铺垫

**1. 前置知识**

选择一门编程语言入门（推荐 Python 或 C++），掌握变量、条件判断、循环、函数、数组等基本语法。理解"程序 = 数据结构 + 算法"这句话的含义——数据结构是组织数据的方式，算法是解决问题的步骤。

**2. 复杂度分析**

学习大 O 表示法，理解时间复杂度和空间复杂度的概念。能分析一段简单代码的复杂度，掌握常见复杂度量级的比较：O(1) < O(log n) < O(n) < O(n log n) < O(n²) < O(2ⁿ)。这是贯穿后续所有内容的分析工具，越早掌握越好。

---

### 第二阶段：基础数据结构

**3. 数组（Array）**

理解数组在内存中的连续存储方式，掌握通过下标随机访问的原理（O(1)）。学习数组的基本操作：遍历、插入、删除，以及它们的时间复杂度。拓展了解动态数组（如 Python 的 list、C++ 的 vector）的扩容机制。

**4. 链表（Linked List）**

理解链表通过指针将离散节点串联的结构。区分单链表、双链表和循环链表。掌握链表的基本操作：头插、尾插、删除节点、反转链表。对比数组与链表在访问、插入、删除上的优劣，理解"顺序存储 vs 链式存储"这个根本性的设计取舍。

**5. 栈（Stack）**

理解栈"后进先出"（LIFO）的特性。掌握基本操作：入栈、出栈、查看栈顶。了解栈的典型应用：函数调用栈、括号匹配、表达式求值、浏览器前进后退。

**6. 队列（Queue）**

理解队列"先进先出"（FIFO）的特性。掌握基本操作：入队、出队。了解变体：循环队列、双端队列（Deque）。了解队列的典型应用：广度优先搜索、任务调度、消息队列。

---

### 第三阶段：基础算法

**7. 递归（Recursion）**

理解递归的核心思想：将问题分解为规模更小的同类子问题。掌握递归的两个要素：基准情形（终止条件）和递推关系。通过经典案例加深理解：阶乘、斐波那契数列、汉诺塔。理解递归与栈的关系，了解递归过深的栈溢出问题。

**8. 排序算法**

从简单排序入手建立直觉：冒泡排序、选择排序、插入排序（理解 O(n²) 的思路）。然后学习高效排序：归并排序（分治思想的入门）、快速排序（partition 的核心概念）、堆排序（为后面学堆做铺垫）。理解排序算法的稳定性概念。掌握各排序算法的时间/空间复杂度和适用场景。

**9. 查找算法**

掌握二分查找：理解其前提条件（有序数组）、实现方式、复杂度 O(log n)。学会二分查找的变体：查找第一个等于给定值的元素、查找最后一个小于等于给定值的元素等。了解二分查找在实际问题中的灵活运用。

---

### 第四阶段：中级数据结构

**10. 哈希表（Hash Table）**

理解哈希函数的概念：将键映射到数组下标。掌握哈希冲突的两种解决方式：链地址法和开放寻址法。了解哈希表的扩容/ rehash 机制。掌握哈希表的典型应用：快速查找、去重、计数统计、两数之和等经典问题。

**11. 树（Tree）**

从二叉树开始，掌握基本术语：根、叶、深度、高度、子树。掌握二叉树的四种遍历方式：前序、中序、后序（递归实现）和层序遍历（用队列实现 BFS）。理解二叉搜索树（BST）的性质：左小右大，中序遍历有序。掌握 BST 的查找、插入、删除操作。了解树的实际应用：文件系统目录结构、数据库索引。

**12. 堆（Heap）**

理解完全二叉树的概念。掌握优先队列的抽象数据类型。学习堆的核心操作：插入、删除最大值/最小值、堆化。区分大顶堆和小顶堆。掌握堆的经典应用：Top-K 问题、堆排序、合并 K 个有序链表。

---

### 第五阶段：中级算法

**13. 分治法（Divide and Conquer）**

理解分治的核心思路：分解 → 解决 → 合并。通过归并排序、快速排序巩固分治思想。学习用分治法解决其他问题：大整数乘法、最近点对问题。

**14. 贪心算法（Greedy）**

理解贪心策略的核心：每一步做当前看起来最优的选择，期望全局最优。学习贪心适用的场景：活动选择问题、分数背包问题、霍夫曼编码。理解贪心不一定能得到全局最优解，需要证明贪心选择性质。

**15. 回溯法（Backtracking）**

理解回溯的本质：穷举所有可能，遇到不满足条件的情况就"回退"。掌握回溯的模板：做选择 → 递归 → 撤销选择。通过经典问题练习：全排列、组合、N 皇后、数独求解。了解剪枝优化：提前排除不可能的分支，减少搜索空间。

---

### 第六阶段：高级数据结构

**16. 图（Graph）**

掌握图的基本概念：顶点、边、有向图/无向图、权重。掌握图的两种存储方式：邻接矩阵和邻接表。理解图的 DFS（深度优先搜索）和 BFS（广度优先搜索）遍历。

**17. 高级树结构**

了解平衡二叉搜索树的概念（AVL 树、红黑树），理解"自平衡"的意义——保证树的高度为 O(log n)，从而保证操作效率。了解 Trie（字典树）：用于高效处理字符串前缀问题。了解并查集（Union-Find）：用于处理集合的合并与查询，在图的连通性问题中非常有用。

---

### 第七阶段：高级算法

**18. 动态规划（Dynamic Programming）**

理解动态规划的核心：将问题分解为重叠子问题，通过记忆化避免重复计算。掌握 DP 的两个关键要素：状态定义和状态转移方程。从经典入门题开始：爬楼梯、斐波那契、背包问题（0-1 背包和完全背包）。进阶题型：最长公共子序列、编辑距离、最长递增子序列。理解自顶向下（记忆化搜索）和自底向上（递推）两种实现方式。

**19. 图算法**

最短路径：Dijkstra 算法（单源最短路径，贪心思想）、Floyd 算法（全源最短路径，DP 思想）、Bellman-Ford 算法（处理负权边）。最小生成树：Kruskal 算法（贪心 + 并查集）、Prim 算法（贪心）。拓扑排序：用于有向无环图中的任务调度问题。

**20. 字符串算法**

掌握字符串匹配：暴力匹配、KMP 算法（理解 next 数组的含义）。了解字符串哈希：Rabin-Karp 算法。了解后缀数组的基本概念。

---

### 第八阶段：进阶与实战

**21. 高级主题（选学）**

线段树与树状数组：用于高效处理区间查询和更新。字典树（Trie）的进阶应用。单调栈与单调队列：解决"下一个更大元素"等问题。跳表（Skip List）：理解 Redis 等系统中的数据结构设计。

**22. 算法设计思想总结**

回顾和对比各算法思想：枚举、贪心、分治、动态规划、回溯、搜索。学会识别问题类型，选择合适的算法策略。

**23. 刷题实战**

按专题刷题巩固：每个专题先做 5-10 道经典题，再随机混合练习。推荐平台：LeetCode（力扣）、洛谷、Codeforces。建议路线：先刷 Hot 100 → 再按标签分类刷 → 最后做模拟面试套题。

---

### 学习建议

**关于节奏**：不要追求速度，理解比刷题数量重要。一个数据结构如果没理解透，后面的学习会越来越吃力。建议每个主题至少花 3-5 天，配合手写实现和练习题。

**关于练习**：每学完一个知识点，至少做 3-5 道对应的练习题。做题时先独立思考 15-20 分钟，实在没思路再看题解，看完后一定要自己重新写一遍。

**关于手写实现**：核心数据结构（链表、栈、队列、二叉树、堆、哈希表）至少要手动实现一次，不要只依赖语言内置的数据结构。

**关于复习**：算法学习容易遗忘，建议用间隔重复的方式复习。可以每周安排一天回顾本周学过的内容，每月做一次综合练习。


---


## 第一阶段：基础铺垫

### 主题1：前置知识


#### 一、Python基础快速回顾

在正式学习数据结构与算法之前，我们先快速回顾一下 Python 的基础语法。你可以把这看作是"出发前的装备检查"——确保我们手里有趁手的工具。

##### 1.1 变量与数据类型

变量就像一个**贴了标签的盒子**，你往里面放什么东西，它就是什么类型。

```python
# ========== 变量与基本数据类型 ==========

# 整数（int）—— 用来计数
student_count = 100

# 浮点数（float）—— 用来表示小数
price = 19.9

# 字符串（str）—— 用来表示文本
name = "小明"

# 布尔值（bool）—— 只有 True 和 False 两个值
is_passed = True

# 用 type() 查看变量类型
print(type(student_count))  # <class 'int'>
print(type(price))          # <class 'float'>
print(type(name))           # <class 'str'>
print(type(is_passed))      # <class 'bool'>

# Python 是动态类型语言：同一个变量可以重新赋值为不同类型
# 就像同一个盒子，标签不变，但里面的东西可以换
x = 42          # x 现在是整数
x = "hello"     # x 现在是字符串，完全合法
print(x)        # 输出: hello
```

**Python 基础数据类型全景**（上例只列了最常用的 4 种，下面是全部基础类型）：

| 类型 | 名称 | 示例 | 说明 | 常用度 |
|------|------|------|------|--------|
| `int` | 整数 | `100` | 任意大整数 | ★★★ 常用 |
| `float` | 浮点数 | `19.9` | 小数（双精度） | ★★★ 常用 |
| `str` | 字符串 | `"hello"` | 文本，不可变 | ★★★ 常用 |
| `bool` | 布尔 | `True` | 只有 True/False | ★★★ 常用 |
| `NoneType` | 空值 | `None` | 表示"什么都没有" | ★★★ 常用 |
| `complex` | 复数 | `1+2j` | 数学复数 | ★ 不常用 |
| `bytes` | 字节串 | `b"abc"` | 二进制数据，不可变 | ★★ 用（网络/文件） |
| `bytearray` | 可变字节串 | `bytearray(b"abc")` | 可修改的 bytes | ★ 不常用 |

```python
# ========== 补充的几种基础类型 ==========

# None：表示"没有值"（类似其他语言的 null）
result = None
print(result)            # None
print(result is None)    # True（判断是否为空）

# complex 复数：a + bj
z = 3 + 4j
print(z.real, z.imag)    # 3.0 4.0

# bytes 字节串：b 前缀，用于二进制数据（网络/文件读写）
data = b"hello"
print(data[0])           # 104（第一个字节的十进制值）

# bytearray 可变字节串（不常用）
buf = bytearray(b"abc")
buf[0] = 120             # 可以原地修改
print(buf)               # bytearray(b'xbc')
```

##### 1.2 条件判断（if / elif / else）

条件判断就像**人生的岔路口**——根据不同的条件，走不同的路。

```python
# ========== 条件判断 ==========

score = 85

if score >= 90:
    print("优秀！")        # 90分及以上走这条路
elif score >= 80:
    print("良好！")        # 80~89分走这条路
elif score >= 60:
    print("及格。")        # 60~79分走这条路
else:
    print("不及格！")      # 60分以下走这条路

# 输出: 良好！

# --- 实际例子：判断一个数是正数、负数还是零 ---
def check_number(n):
    """判断一个数的正负性"""
    if n > 0:
        return "正数"
    elif n < 0:
        return "负数"
    else:
        return "零"

print(check_number(7))    # 输出: 正数
print(check_number(-3))   # 输出: 负数
print(check_number(0))    # 输出: 零
```

##### 1.3 循环（for / while）

循环就是**重复做某件事**——就像操场跑圈，跑够圈数才停下来。

```python
# ========== for 循环 ==========
# 适用于"已知要循环多少次"的场景

# 遍历一个列表
fruits = ["苹果", "香蕉", "橘子"]
for fruit in fruits:
    print(f"我喜欢吃{fruit}")

# 输出:
# 我喜欢吃苹果
# 我喜欢吃香蕉
# 我喜欢吃橘子

# 使用 range() 生成数字序列
# range(5) 生成 0, 1, 2, 3, 4（注意：不包含5）
for i in range(5):
    print(f"第 {i} 次循环")

# range(1, 6) 生成 1, 2, 3, 4, 5
for i in range(1, 6):
    print(f"倒数第 {6 - i} 名")

# ========== while 循环 ==========
# 适用于"不确定要循环多少次，但知道什么时候停"的场景

# 倒计时
countdown = 5
while countdown > 0:
    print(f"倒计时: {countdown}")
    countdown -= 1       # 每次减1，别忘了这步，否则会死循环！
print("发射！🚀")

# --- break 和 continue ---
# break: 直接跳出整个循环
# continue: 跳过本次，进入下一次循环

for i in range(10):
    if i == 3:
        continue    # 跳过3，继续下一轮
    if i == 7:
        break       # 到7就彻底结束循环
    print(i, end=" ")

# 输出: 0 1 2 4 5 6
# 注意：3被continue跳过了，7及之后的数字因为break没有出现
```

##### 1.4 函数定义

函数就像一个**自动售货机**：你投入原料（参数），它返回商品（返回值）。

```python
# ========== 函数定义 ==========

# 基本语法：def 函数名(参数):
def greet(name):
    """向某人打招呼（这个字符串叫文档字符串，说明函数的功能）"""
    return f"你好，{name}！欢迎学习数据结构！"

# 调用函数
message = greet("小红")
print(message)  # 输出: 你好，小红！欢迎学习数据结构！

# --- 带多个参数的函数 ---
def calculate_area(width, height):
    """计算矩形面积"""
    return width * height

area = calculate_area(5, 3)
print(f"面积是: {area}")  # 输出: 面积是: 15

# --- 带默认参数的函数 ---
def power(base, exponent=2):
    """计算幂，默认计算平方"""
    return base ** exponent

print(power(3))      # 输出: 9  （3的2次方）
print(power(2, 10))  # 输出: 1024 （2的10次方）

# --- 返回多个值 ---
def min_max(numbers):
    """返回列表的最小值和最大值"""
    return min(numbers), max(numbers)

smallest, largest = min_max([3, 1, 4, 1, 5, 9, 2, 6])
print(f"最小值: {smallest}, 最大值: {largest}")  # 输出: 最小值: 1, 最大值: 9
```

##### 1.5 列表（list）基本操作

列表是 Python 中最常用的数据结构，就像一个**可伸缩的排队队伍**。

```python
# ========== 列表基本操作 ==========

# 创建列表
numbers = [10, 20, 30, 40, 50]

# 访问元素（索引从0开始）
print(numbers[0])    # 输出: 10（第一个元素）
print(numbers[-1])   # 输出: 50（最后一个元素）
print(numbers[1:3])  # 输出: [20, 30]（切片：取索引1到2的元素）

# 修改元素
numbers[0] = 99
print(numbers)       # 输出: [99, 20, 30, 40, 50]

# 添加元素
numbers.append(60)         # 在末尾添加
print(numbers)             # 输出: [99, 20, 30, 40, 50, 60]

numbers.insert(0, 5)       # 在指定位置插入（索引0处插入5）
print(numbers)             # 输出: [5, 99, 20, 30, 40, 50, 60]

# 删除元素
numbers.pop()              # 删除并返回最后一个元素
print(numbers)             # 输出: [5, 99, 20, 30, 40, 50]

numbers.remove(99)         # 删除第一个值为99的元素
print(numbers)             # 输出: [5, 20, 30, 40, 50]

# 常用方法
print(len(numbers))        # 长度: 5
print(30 in numbers)       # 判断30是否在列表中: True
numbers.sort()             # 排序（原地排序，改变原列表）
print(numbers)             # 输出: [5, 20, 30, 40, 50]

# 列表拼接
list_a = [1, 2, 3]
list_b = [4, 5, 6]
combined = list_a + list_b
print(combined)            # 输出: [1, 2, 3, 4, 5, 6]
```

---

#### 二、"程序 = 数据结构 + 算法"的含义

这个著名的公式由瑞士计算机科学家 Niklaus Wirth 提出（他的一本书就叫这个名字）。我们来拆解一下：

```
程序 = 数据结构 + 算法
```

- **数据结构**：数据在计算机中**如何组织、存储**——相当于"仓库的货架怎么摆"
- **算法**：对数据进行**操作的步骤**——相当于"怎么从仓库里快速找到想要的货"

##### 生活中的类比

想象你经营一家**外卖厨房**：

| 概念 | 对应到厨房 |
|------|-----------|
| 数据 | 各种食材（蔬菜、肉类、调料） |
| 数据结构 | 冰箱、货架、调料盒——食材**怎么存放** |
| 算法 | 菜谱——按什么步骤**把食材变成菜品** |
| 程序 | 整个厨房的运作方式 |

如果食材乱放（数据结构差），找鸡蛋翻半天，做菜就慢；如果步骤混乱（算法差），即使食材摆得整齐也做不出好菜。**两者缺一不可**。

```python
# ========== 一个简单的"程序 = 数据结构 + 算法"示例 ==========

# 数据结构：用一个列表存储学生成绩
scores = [78, 92, 65, 88, 55, 91, 73]

# 算法：一个找出最高分的步骤
def find_max_score(score_list):
    """在列表中找到最大值"""
    # 假设第一个元素是最大值
    max_score = score_list[0]
    # 遍历剩余元素，逐个比较
    for score in score_list[1:]:
        if score > max_score:
            max_score = score  # 发现更大的，更新最大值
    return max_score

# 程序：数据结构 + 算法 = 完整的程序
result = find_max_score(scores)
print(f"最高分是: {result}")  # 输出: 最高分是: 92
```

---

#### 三、什么是数据结构

##### 图书馆整理书架的类比

想象你是一座图书馆的管理员。图书馆有100万本书，你需要解决的问题是：**怎么摆放这些书，才能让读者最快找到想要的书？**

方案一：随便堆在地板上。——找一本书就像大海捞针。

方案二：按编号排成一排。——能找到，但100万本书排成一排也太长了。

方案三：先按类别分区（文学、科学、历史……），每个区内再按作者姓氏排列，每排书架再标上索引号。——这就是一个好的**数据结构**。

```
图书馆的类比：
┌─────────────────────────────────────────────────┐
│  图书馆 = 计算机的内存（存储空间）                    │
│  书 = 数据                                       │
│  书架的排列方式 = 数据结构                          │
│  找书的方法 = 算法                                │
└─────────────────────────────────────────────────┘
```

**数据结构的本质**：选择一种方式来组织数据，使得后续的操作（查找、插入、删除等）尽可能高效。

```python
# ========== 不同"数据结构"的对比 ==========

# 方案一：书随便堆——用无序列表
shelf_random = ["西游记", "三体", "红楼梦", "基地", "三国演义"]

# 找"三体"？只能一本一本翻
def find_book_random(shelf, book_name):
    """无序查找——一本一本看"""
    for i, book in enumerate(shelf):
        if book == book_name:
            return f"找到了！在第 {i} 个位置"
    return "没找到"

print(find_book_random(shelf_random, "三体"))  # 找到了！在第 1 个位置

# 方案二：书按拼音排好——用有序列表
shelf_sorted = ["基地", "红楼梦", "三国演义", "三体", "西游记"]

# 找"三体"？可以用二分查找（每次排除一半），快得多！
def find_book_binary(shelf, book_name):
    """二分查找——每次排除一半"""
    left = 0
    right = len(shelf) - 1

    while left <= right:
        mid = (left + right) // 2       # 看中间那本
        if shelf[mid] == book_name:
            return f"找到了！在第 {mid} 个位置"
        elif shelf[mid] < book_name:
            left = mid + 1              # 目标在右半边
        else:
            right = mid - 1             # 目标在左半边
    return "没找到"

print(find_book_binary(shelf_sorted, "三体"))  # 找到了！在第 3 个位置

# 方案三：用字典做索引——直接定位
shelf_index = {
    "西游记": "A区-3架-5层",
    "三体": "B区-1架-2层",
    "红楼梦": "A区-1架-1层",
}

# 找"三体"？直接查索引，一步到位！
print(f"三体的位置: {shelf_index['三体']}")  # B区-1架-2层
```

> **小结**：同样的数据，用不同的结构来组织，查找效率天差地别。这就是学习数据结构的意义。

---

#### 四、什么是算法

##### 做菜步骤的类比

算法就是**解决问题的明确步骤**。做菜时，菜谱就是算法：

```
菜谱（算法）：西红柿炒鸡蛋
─────────────────────
输入：西红柿2个、鸡蛋3个、油、盐、糖
步骤：
  1. 西红柿洗净切块
  2. 鸡蛋打散加少许盐
  3. 热锅倒油
  4. 倒入蛋液，炒至凝固，盛出
  5. 再倒少许油，放入西红柿翻炒
  6. 加盐和糖调味
  7. 倒回鸡蛋，翻炒均匀
输出：一盘西红柿炒鸡蛋
```

算法的特征：
- **有输入**：食材（数据）
- **有输出**：做好的菜（结果）
- **明确性**：每一步都清晰无歧义
- **有限性**：步骤有限，最终会结束
- **可行性**：每一步都能做到

```python
# ========== 算法示例：两种排序方法 ==========

# 算法1：冒泡排序——像水中气泡一样，大的慢慢"浮"到后面
def bubble_sort(arr):
    """冒泡排序：相邻元素两两比较，把大的往后换"""
    n = len(arr)
    for i in range(n):
        for j in range(0, n - i - 1):
            # 如果前一个比后一个大，就交换
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]  # 交换
    return arr

print("冒泡排序:", bubble_sort([64, 34, 25, 12, 22]))
# 输出: 冒泡排序: [12, 22, 25, 34, 64]

# 算法2：选择排序——每次从未排序部分选出最小的，放到前面
def selection_sort(arr):
    """选择排序：每次选出最小的，放到已排序部分的末尾"""
    n = len(arr)
    for i in range(n):
        # 假设当前位置是最小值的索引
        min_idx = i
        for j in range(i + 1, n):
            if arr[j] < arr[min_idx]:
                min_idx = j  # 找到更小的，更新索引
        # 把找到的最小值换到当前位置
        arr[i], arr[min_idx] = arr[min_idx], arr[i]
    return arr

print("选择排序:", selection_sort([64, 34, 25, 12, 22]))
# 输出: 选择排序: [12, 22, 25, 34, 64]
```

> 同一个问题（排序）可以有不同的算法，就像同一道菜可以有不同的做法。后面我们会学习如何评价哪个算法更"好"。

---

#### 五、Python中常用的内置数据结构

Python 自带了几种非常实用的"工具箱"，我们在写算法时会频繁用到。

##### 5.1 列表（list）—— 有序、可变、可重复

类比：**一列火车**，每节车厢有编号，可以加挂或卸下车厢。

```python
# ========== 列表（list）==========
# 特点：有序、可变、允许重复元素

fruits = ["苹果", "香蕉", "苹果", "橘子"]
print(fruits)        # ['苹果', '香蕉', '苹果', '橘子']
print(fruits[1])     # 香蕉（通过索引访问）
print(len(fruits))   # 4（包含重复元素）

fruits.append("西瓜")     # 末尾添加
fruits.insert(1, "葡萄")  # 在索引1处插入
print(fruits)        # ['苹果', '葡萄', '香蕉', '苹果', '橘子', '西瓜']
```

##### 5.2 元组（tuple）—— 有序、不可变

类比：**密封的档案袋**，一旦装好就不能改了，只能看。

```python
# ========== 元组（tuple）==========
# 特点：有序、不可变（创建后不能修改）、允许重复

point = (3, 4)             # 一个二维坐标
print(point[0])            # 3
# point[0] = 5             # 报错！元组不能修改

# 用途：表示不应该被改变的数据
# 比如：GPS坐标、RGB颜色值、数据库查询结果

rgb_red = (255, 0, 0)      # 红色的RGB值，永远不会变
print(f"红色的R值: {rgb_red[0]}")  # 255

# 元组解包（非常常用！）
x, y = point
print(f"x={x}, y={y}")    # x=3, y=4
```

##### 5.3 字典（dict）—— 键值对、无序（Python 3.7+保持插入顺序）

类比：**电话簿**——通过名字（键）查电话号码（值）。

```python
# ========== 字典（dict）==========
# 特点：键值对存储，键唯一，查找速度极快

student = {
    "name": "小明",
    "age": 18,
    "grade": "高三"
}

# 通过键访问值
print(student["name"])     # 小明
print(student.get("age"))  # 18（get方法更安全，键不存在时返回None）

# 添加/修改
student["score"] = 95      # 添加新键值对
student["age"] = 19        # 修改已有的值

# 遍历字典
for key, value in student.items():
    print(f"{key}: {value}")

# 判断键是否存在
if "name" in student:
    print(f"学生姓名: {student['name']}")

# 字典的最大优势：查找速度快
# 不管字典有10条还是1000万条数据，通过键查找的速度几乎一样快！
# 后面学复杂度分析时会详细解释为什么
```

##### 5.4 集合（set）—— 无序、不重复

类比：**一袋弹珠**——每颗弹珠都是独立的，袋子里不会有完全一样的两颗。

```python
# ========== 集合（set）==========
# 特点：无序、不重复、支持集合运算

# 创建集合
numbers = {1, 2, 3, 4, 5}
print(numbers)    # {1, 2, 3, 4, 5}

# 自动去重
duplicates = [1, 2, 2, 3, 3, 3, 4]
unique = set(duplicates)
print(unique)     # {1, 2, 3, 4}

# 集合运算
class_a = {"小明", "小红", "小刚"}
class_b = {"小红", "小刚", "小丽"}

# 交集：两个班都有的学生
print(class_a & class_b)    # {'小红', '小刚'}

# 并集：所有学生（不重复）
print(class_a | class_b)    # {'小明', '小红', '小刚', '小丽'}

# 差集：在A班但不在B班的学生
print(class_a - class_b)    # {'小明'}

# 用途：快速判断某个元素是否存在
# 和字典一样，集合的查找速度也非常快
valid_ids = {1001, 1002, 1003, 1004, 1005}
print(1003 in valid_ids)    # True（瞬间完成，不管集合多大）
```

##### 5.5 frozenset（不可变集合）—— 像"密封的袋装弹珠"

`frozenset` 和 `set` 几乎一样（无序、不重复、支持集合运算），区别是：**创建后不能修改**（不能 add / remove）。因为不可变，所以**能作为字典的键、能放进另一个集合**（普通 set 不行）。

```python
# ========== frozenset（不可变集合）==========

# 创建
frozen = frozenset([1, 2, 3, 3, 3])
print(frozen)               # frozenset({1, 2, 3})  自动去重
# frozen.add(4)             # 报错！frozenset 不能修改

# 集合运算照常支持
a = frozenset([1, 2, 3])
b = frozenset([2, 3, 4])
print(a & b)                # frozenset({2, 3})  交集
print(a | b)                # frozenset({1, 2, 3, 4})  并集

# 最大用途：因为不可变（可哈希），能当字典的键 / 放进集合
# 比如：把"一组标签"作为整体去重
tags = frozenset(["linux", "shell"])
mapping = {tags: "运维技能组"}    # 用 frozenset 当键
print(mapping[tags])            # 运维技能组
```

> 常用度：★★ 不常用，但在"需要用集合做键 / 需要不可变去重"时很有用。

##### 四种内置数据结构对比表（附 frozenset）

| 特性 | list | tuple | dict | set | frozenset |
|------|------|-------|------|-----|-----------|
| 有序 | 是 | 是 | Python 3.7+ 保持插入顺序 | 否 | 否 |
| 可变 | 是 | 否 | 是 | 是 | **否** |
| 可重复 | 是 | 是 | 键唯一，值可重复 | 否 | 否 |
| 语法 | `[1,2,3]` | `(1,2,3)` | `{"k":"v"}` | `{1,2,3}` | `frozenset([1,2,3])` |
| 查找速度 | O(n) 慢 | O(n) 慢 | O(1) 快 | O(1) 快 | O(1) 快 |
| 典型用途 | 有序数据集合 | 不可变数据 | 映射关系 | 去重、快速查找 | 不可变去重、当字典键 |

---

#### 六、Python实用技巧

这些技巧在后续的数据结构与算法代码中会频繁出现，提前掌握可以让代码更简洁优雅。

##### 6.1 列表推导式

列表推导式是 Python 最优雅的特性之一：**一行代码生成一个列表**。

```python
# ========== 列表推导式 ==========

# 传统方式：用for循环创建列表
squares_old = []
for i in range(1, 6):
    squares_old.append(i ** 2)
print(squares_old)    # [1, 4, 9, 16, 25]

# 列表推导式：一行搞定
squares_new = [i ** 2 for i in range(1, 6)]
print(squares_new)    # [1, 4, 9, 16, 25]

# 带条件的列表推导式
# 只保留偶数的平方
even_squares = [i ** 2 for i in range(1, 11) if i % 2 == 0]
print(even_squares)   # [4, 16, 36, 64, 100]

# 实用场景：初始化一个全0列表（在算法中经常需要）
dp = [0] * 10          # 创建长度为10的全0列表
print(dp)              # [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

# 创建二维列表（矩阵）—— 注意陷阱！
# 错误写法（所有行共享同一个列表对象）：
wrong = [[0] * 3] * 3
wrong[0][0] = 1
print(wrong)  # [[1, 0, 0], [1, 0, 0], [1, 0, 0]] —— 全变了！

# 正确写法（每行独立创建）：
correct = [[0] * 3 for _ in range(3)]
correct[0][0] = 1
print(correct)  # [[1, 0, 0], [0, 0, 0], [0, 0, 0]] —— 只有第一行变了
```

##### 6.2 解包（Unpacking）

解包就像**一次性把多个盒子里的东西拿出来**。

```python
# ========== 解包 ==========

# 基本解包
a, b, c = 1, 2, 3
print(a, b, c)    # 1 2 3

# 交换两个变量（Python独有的优雅写法）
x, y = 10, 20
x, y = y, x       # 一行交换！不需要临时变量
print(x, y)       # 20 10

# 其他语言需要这样：
# temp = x
# x = y
# y = temp

# 解包列表
first, *rest = [1, 2, 3, 4, 5]
print(first)      # 1
print(rest)       # [2, 3, 4, 5]

# 取第一个和最后一个
first, *middle, last = [1, 2, 3, 4, 5]
print(first)      # 1
print(middle)     # [2, 3, 4]
print(last)       # 5

# 函数返回多个值时常用解包
def get_stats(numbers):
    """返回列表的最小值、最大值和平均值"""
    return min(numbers), max(numbers), sum(numbers) / len(numbers)

lo, hi, avg = get_stats([10, 20, 30, 40, 50])
print(f"最小: {lo}, 最大: {hi}, 平均: {avg}")
# 输出: 最小: 10, 最大: 50, 平均: 30.0
```

##### 6.3 enumerate —— 同时获取索引和值

在算法中，我们经常需要"既知道当前是第几个元素，又知道元素的值"。

```python
# ========== enumerate ==========

# 不用enumerate（不太优雅）
fruits = ["苹果", "香蕉", "橘子"]
i = 0
for fruit in fruits:
    print(f"索引 {i}: {fruit}")
    i += 1

# 用enumerate（推荐写法）
for i, fruit in enumerate(fruits):
    print(f"索引 {i}: {fruit}")

# enumerate还可以指定起始索引
for i, fruit in enumerate(fruits, start=1):
    print(f"第 {i} 个: {fruit}")
# 输出:
# 第 1 个: 苹果
# 第 2 个: 香蕉
# 第 3 个: 橘子

# 实用场景：在算法中找到某个元素的索引
def find_index(arr, target):
    """在列表中找到目标值的索引"""
    for i, val in enumerate(arr):
        if val == target:
            return i
    return -1  # 没找到

print(find_index(["a", "b", "c", "d"], "c"))  # 输出: 2
```

##### 6.4 zip —— 并行遍历多个列表

```python
# ========== zip ==========

names = ["小明", "小红", "小刚"]
scores = [95, 88, 76]

# 同时遍历两个列表
for name, score in zip(names, scores):
    print(f"{name}的成绩是{score}分")

# 用zip创建字典
score_dict = dict(zip(names, scores))
print(score_dict)  # {'小明': 95, '小红': 88, '小刚': 76}

# 实用场景：在算法中同时处理相关数据
def dot_product(v1, v2):
    """计算两个向量的点积"""
    return sum(a * b for a, b in zip(v1, v2))

print(dot_product([1, 2, 3], [4, 5, 6]))  # 1*4 + 2*5 + 3*6 = 32
```

##### 6.5 其他常用技巧

```python
# ========== 其他实用技巧 ==========

# 1. 三元表达式（条件表达式）
age = 20
status = "成年" if age >= 18 else "未成年"
print(status)    # 成年

# 2. 切片的高级用法
nums = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
print(nums[::2])     # [0, 2, 4, 6, 8]  每隔一个取
print(nums[::-1])    # [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]  反转列表
print(nums[2:8:3])   # [2, 5]  从索引2到7，每隔3个取

# 3. 用join拼接字符串（比+号快得多）
words = ["Hello", "World", "Python"]
sentence = " ".join(words)
print(sentence)    # Hello World Python

# 4. 用any和all做批量判断
scores = [85, 92, 78, 96, 88]
print(any(s > 95 for s in scores))   # True（有一个超过95）
print(all(s > 60 for s in scores))   # True（全部及格）

# 5. 用Counter统计频率（在算法题中非常有用）
from collections import Counter
text = "abracadabra"
freq = Counter(text)
print(freq)              # Counter({'a': 5, 'b': 2, 'r': 2, 'c': 1, 'd': 1})
print(freq.most_common(2))  # [('a', 5), ('b', 2)]  出现最多的前2个
```

---
---


### 主题1 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 1.1 变量与基本数据类型

```typescript
// ========== 变量与基本数据类型 ==========

// 整数（number）—— 用来计数
const studentCount: number = 100;

// 浮点数（number）—— 用来表示小数
const price: number = 19.9;

// 字符串（string）—— 用来表示文本
const studentName: string = "小明";

// 布尔值（boolean）—— 只有 true 和 false 两个值
const isPassed: boolean = true;

// 用 typeof 查看变量类型
console.log(typeof studentCount);  // 'number'
console.log(typeof price);         // 'number'
console.log(typeof name);          // 'string'
console.log(typeof isPassed);      // 'boolean'

// TypeScript 是静态类型语言：变量类型声明后就固定了
// 想"同一个变量存不同类型"，需要用联合类型 number | string
let x: number | string = 42;   // x 现在是数字
x = "hello";                    // x 现在是字符串（声明联合类型后合法）
console.log(x);                 // 输出: hello
```

**JavaScript（2026 现状）全部类型清单** —— TS 是 JS 的超集，先认清 JS 自己有哪些类型：

| 分类 | 类型 | 示例 | 说明 | 常用度 |
|------|------|------|------|--------|
| 基础（原始类型） | `number` | `100` / `19.9` | 整数和小数都是它（无 int/float 之分） | ★★★ |
| | `string` | `"hi"` | 文本 | ★★★ |
| | `boolean` | `true` | 布尔 | ★★★ |
| | `null` | `null` | 表示"人为的空" | ★★★ |
| | `undefined` | `undefined` | 表示"未定义"（声明了没赋值） | ★★★ |
| | `symbol` | `Symbol("id")` | 独一无二的值，常做对象键 | ★★ |
| | `bigint` | `10n` | 超长整数（>2^53） | ★ 不常用 |
| 复合（引用类型） | `object` | `{a:1}` | 普通对象（键值对） | ★★★ |
| | `array` | `[1,2,3]` | 数组 | ★★★ |
| | `function` | `(x)=>x` | 函数 | ★★★ |
| | `Date` | `new Date()` | 日期时间 | ★★★ |
| | `RegExp` | `/a+/` | 正则 | ★★ |
| | `Map` | `new Map()` | 键值对容器 | ★★★ |
| | `Set` | `new Set()` | 集合 | ★★★ |
| | `WeakMap` | `new WeakMap()` | 弱引用 Map，键必须对象 | ★ 不常用 |
| | `WeakSet` | `new WeakSet()` | 弱引用 Set，只存对象 | ★ 不常用 |
| | `Promise` | `new Promise(...)` | 异步操作 | ★★★（前端天天用） |
| | 类型化数组 | `Int8Array` / `Float64Array` / `ArrayBuffer` | 二进制数据 | ★ 不常用 |

```typescript
// ========== JS 中容易漏掉的几个基础类型 ==========

// null 与 undefined 的区别
let jNull: null = null;      // 人为设置"空"
let jUndef: undefined;       // 声明了但没赋值 → undefined
console.log(jUndef);         // undefined

// symbol：独一无二
let s1: symbol = Symbol("id");
let s2: symbol = Symbol("id");
console.log(s1 === s2);      // false（即使是同样的描述，也不相等）

// bigint：大整数（末尾加 n）——不常用
const jBig: bigint = 9007199254740993n;
console.log(jBig);           // 9007199254740993n
```

**TypeScript 新增（JS 没有）的类型** —— 这才是 TS 的"增值部分"：

| 类型 | 一句话 | 示例 | 常用度 |
|------|--------|------|--------|
| `any` | 放弃检查，随便什么类型 | `let x: any = 1` | ★★★ 常用（但慎用） |
| `unknown` | 未知类型，用前必须收窄 | `let x: unknown` | ★★ |
| `void` | 函数没有返回值 | `function f(): void {}` | ★★★ |
| `never` | 永不返回（抛异常/死循环） | `function f(): never { throw 1 }` | ★ 不常用 |
| `tuple` | 固定长度+固定类型的数组 | `[number, string]` | ★★★ |
| `enum` | 一组命名常量 | `enum Color {Red, Green}` | ★★ |
| 联合类型 `A \| B` | 或 | `number \| string` | ★★★ |
| 交叉类型 `A & B` | 且（两者都要） | `A & B` | ★★ |
| 字面量类型 | 具体值当类型 | `"up" \| "down"` | ★★ |
| `interface` | 定义对象形状 | `interface User {name: string}` | ★★★ |
| `type` 别名 | 给类型起别名 | `type ID = number` | ★★★ |
| 泛型 `<T>` | 类型参数化 | `function f<T>(x:T):T` | ★★★ |
| 工具类型 | TS 内置类型操作 | `Partial` / `Pick` / `Omit` / `Readonly` | ★★ |

```typescript
// ========== TS 特有类型速览 ==========

// any：不检查（能用，但失去 TS 的意义，慎用）
let anything: any = 1;
anything = "随便";          // 不报错

// 联合类型：要么这个要么那个
let tsUnion: number | string = 42;
tsUnion = "hello";          // 合法

// 字面量类型：只能是这几个值之一
type Direction = "up" | "down";
let dir: Direction = "up";  // dir = "left" 会报错

// interface：定义对象的形状
interface User { name: string; age: number }
const u: User = { name: "小明", age: 18 };

// 元组：固定长度数组
const tsTuple: [number, number] = [3, 4];

// 泛型：类型参数化（后面讲数据结构会大量用到）
function tsIdentity<T>(value: T): T { return value; }
const n2 = tsIdentity<number>(42);   // number
const s3 = tsIdentity("hi");         // string（自动推断）

// never（不常用）：表示"这个函数永远不会正常返回"
function fail(): never { throw new Error("出错"); }
```

##### 1.2 条件判断（if / else if / else）

```typescript
// ========== 条件判断 ==========

const score: number = 85;

if (score >= 90) {
  console.log("优秀！");        // 90分及以上走这条路
} else if (score >= 80) {
  console.log("良好！");        // 80~89分走这条路
} else if (score >= 60) {
  console.log("及格。");        // 60~79分走这条路
} else {
  console.log("不及格！");      // 60分以下走这条路
}

// 输出: 良好！

// --- 实际例子：判断一个数是正数、负数还是零 ---
function checkNumber(n: number): string {
  if (n > 0) return "正数";
  else if (n < 0) return "负数";
  else return "零";
}

console.log(checkNumber(7));   // 输出: 正数
console.log(checkNumber(-3));  // 输出: 负数
console.log(checkNumber(0));   // 输出: 零
```

##### 1.3 循环（for / while）

```typescript
// ========== for 循环 ==========
// 适用于"已知要循环多少次"的场景

// 遍历一个数组
const fruits: string[] = ["苹果", "香蕉", "橘子"];
for (const fruit of fruits) {
  console.log(`我喜欢吃${fruit}`);
}

// 输出:
// 我喜欢吃苹果
// 我喜欢吃香蕉
// 我喜欢吃橘子

// 使用 for 循环生成数字序列
// i 从 0 到 4（注意：不包含5）
for (let i = 0; i < 5; i++) {
  console.log(`第 ${i} 次循环`);
}

// i 从 1 到 5
for (let i = 1; i <= 5; i++) {
  console.log(`倒数第 ${6 - i} 名`);
}

// ========== while 循环 ==========
// 适用于"不确定要循环多少次，但知道什么时候停"的场景

// 倒计时
let countdown: number = 5;
while (countdown > 0) {
  console.log(`倒计时: ${countdown}`);
  countdown -= 1;          // 每次减1，别忘了这步，否则会死循环！
}
console.log("发射！🚀");

// --- break 和 continue ---
// break: 直接跳出整个循环
// continue: 跳过本次，进入下一次循环

for (let i = 0; i < 10; i++) {
  if (i === 3) continue;   // 跳过3，继续下一轮
  if (i === 7) break;      // 到7就彻底结束循环
  console.log(i + " ");
}

// 输出: 0 1 2 4 5 6
// 注意：3被continue跳过了，7及之后的数字因为break没有出现
```

##### 1.4 函数定义

```typescript
// ========== 函数定义 ==========

// 基本语法：function 函数名(参数: 类型): 返回类型
function greet(name: string): string {
  return `你好，${name}！欢迎学习数据结构！`;
}

// 调用函数
const message: string = greet("小红");
console.log(message);  // 输出: 你好，小红！欢迎学习数据结构！

// --- 带多个参数的函数 ---
function calculateArea(width: number, height: number): number {
  return width * height;
}

const area = calculateArea(5, 3);
console.log(`面积是: ${area}`);  // 输出: 面积是: 15

// --- 带默认参数的函数 ---
function power(base: number, exponent: number = 2): number {
  return base ** exponent;
}

console.log(power(3));      // 输出: 9  （3的2次方）
console.log(power(2, 10));  // 输出: 1024 （2的10次方）

// --- 返回多个值（用数组或对象）---
function minMax(numbers: number[]): [number, number] {
  return [Math.min(...numbers), Math.max(...numbers)];
}

const [smallest, largest] = minMax([3, 1, 4, 1, 5, 9, 2, 6]);
console.log(`最小值: ${smallest}, 最大值: ${largest}`);  // 输出: 最小值: 1, 最大值: 9
```

##### 1.5 数组（list）基本操作

```typescript
// ========== 数组基本操作 ==========

// 创建数组
const numbers: number[] = [10, 20, 30, 40, 50];

// 访问元素（索引从0开始）
console.log(numbers[0]);     // 输出: 10（第一个元素）
console.log(numbers[numbers.length - 1]);  // 输出: 50（最后一个元素）
console.log(numbers.slice(1, 3));          // 输出: [20, 30]（切片：取索引1到2的元素）

// 修改元素
numbers[0] = 99;
console.log(numbers);        // 输出: [99, 20, 30, 40, 50]

// 添加元素
numbers.push(60);            // 在末尾添加
console.log(numbers);        // 输出: [99, 20, 30, 40, 50, 60]

numbers.splice(0, 0, 5);     // 在指定位置插入（索引0处插入5）
console.log(numbers);        // 输出: [5, 99, 20, 30, 40, 50, 60]

// 删除元素
numbers.pop();               // 删除并返回最后一个元素
console.log(numbers);        // 输出: [5, 99, 20, 30, 40, 50]

const idx99 = numbers.indexOf(99);  // 找到第一个值为99的索引
if (idx99 !== -1) numbers.splice(idx99, 1);  // 删除第一个值为99的元素
console.log(numbers);        // 输出: [5, 20, 30, 40, 50]

// 常用方法
console.log(numbers.length);          // 长度: 5
console.log(numbers.includes(30));    // 判断30是否在数组中: true
numbers.sort((a, b) => a - b);        // 排序（原地排序）
console.log(numbers);                 // 输出: [5, 20, 30, 40, 50]

// 数组拼接
const listA: number[] = [1, 2, 3];
const listB: number[] = [4, 5, 6];
const combined: number[] = [...listA, ...listB];
console.log(combined);       // 输出: [1, 2, 3, 4, 5, 6]
```

##### 二、"程序 = 数据结构 + 算法"示例

```typescript
// ========== 一个简单的"程序 = 数据结构 + 算法"示例 ==========

// 数据结构：用一个数组存储学生成绩
const scores: number[] = [78, 92, 65, 88, 55, 91, 73];

// 算法：一个找出最高分的步骤
function findMaxScore(scoreList: number[]): number {
  // 假设第一个元素是最大值
  let maxScore = scoreList[0];
  // 遍历剩余元素，逐个比较
  for (let i = 1; i < scoreList.length; i++) {
    if (scoreList[i] > maxScore) {
      maxScore = scoreList[i];  // 发现更大的，更新最大值
    }
  }
  return maxScore;
}

// 程序：数据结构 + 算法 = 完整的程序
const result = findMaxScore(scores);
console.log(`最高分是: ${result}`);  // 输出: 最高分是: 92
```

##### 三、不同"数据结构"的对比

```typescript
// ========== 不同"数据结构"的对比 ==========

// 方案一：书随便堆——用无序数组
const shelfRandom: string[] = ["西游记", "三体", "红楼梦", "基地", "三国演义"];

// 找"三体"？只能一本一本翻
function findBookRandom(shelf: string[], bookName: string): string {
  for (let i = 0; i < shelf.length; i++) {
    if (shelf[i] === bookName) {
      return `找到了！在第 ${i} 个位置`;
    }
  }
  return "没找到";
}

console.log(findBookRandom(shelfRandom, "三体"));  // 找到了！在第 1 个位置

// 方案二：书按拼音排好——用有序数组
const shelfSorted: string[] = ["基地", "红楼梦", "三国演义", "三体", "西游记"];

// 找"三体"？可以用二分查找（每次排除一半），快得多！
function findBookBinary(shelf: string[], bookName: string): string {
  let left = 0;
  let right = shelf.length - 1;

  while (left <= right) {
    const mid = Math.floor((left + right) / 2);  // 看中间那本
    if (shelf[mid] === bookName) {
      return `找到了！在第 ${mid} 个位置`;
    } else if (shelf[mid] < bookName) {
      left = mid + 1;              // 目标在右半边
    } else {
      right = mid - 1;             // 目标在左半边
    }
  }
  return "没找到";
}

console.log(findBookBinary(shelfSorted, "三体"));  // 找到了！在第 3 个位置

// 方案三：用 Map 做索引——直接定位
const shelfIndex: Map<string, string> = new Map([
  ["西游记", "A区-3架-5层"],
  ["三体", "B区-1架-2层"],
  ["红楼梦", "A区-1架-1层"],
]);

// 找"三体"？直接查索引，一步到位！
console.log(`三体的位置: ${shelfIndex.get("三体")}`);  // B区-1架-2层
```

##### 四、算法示例：两种排序方法

```typescript
// ========== 算法示例：两种排序方法 ==========

// 算法1：冒泡排序——像水中气泡一样，大的慢慢"浮"到后面
function bubbleSort(arr: number[]): number[] {
  const n = arr.length;
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n - i - 1; j++) {
      // 如果前一个比后一个大，就交换
      if (arr[j] > arr[j + 1]) {
        [arr[j], arr[j + 1]] = [arr[j + 1], arr[j]];  // 交换
      }
    }
  }
  return arr;
}

console.log("冒泡排序:", bubbleSort([64, 34, 25, 12, 22]));
// 输出: 冒泡排序: [12, 22, 25, 34, 64]

// 算法2：选择排序——每次从未排序部分选出最小的，放到前面
function selectionSort(arr: number[]): number[] {
  const n = arr.length;
  for (let i = 0; i < n; i++) {
    // 假设当前位置是最小值的索引
    let minIdx = i;
    for (let j = i + 1; j < n; j++) {
      if (arr[j] < arr[minIdx]) {
        minIdx = j;  // 找到更小的，更新索引
      }
    }
    // 把找到的最小值换到当前位置
    [arr[i], arr[minIdx]] = [arr[minIdx], arr[i]];
  }
  return arr;
}

console.log("选择排序:", selectionSort([64, 34, 25, 12, 22]));
// 输出: 选择排序: [12, 22, 25, 34, 64]
```

##### 五、TypeScript 中常用的内置数据结构

```typescript
// ========== 数组（Array）==========
// 特点：有序、可变、允许重复元素

const fruits2: string[] = ["苹果", "香蕉", "苹果", "橘子"];
console.log(fruits2);         // ['苹果', '香蕉', '苹果', '橘子']
console.log(fruits2[1]);      // 香蕉（通过索引访问）
console.log(fruits2.length);  // 4（包含重复元素）

fruits2.push("西瓜");          // 末尾添加
fruits2.splice(1, 0, "葡萄");  // 在索引1处插入
console.log(fruits2);          // ['苹果', '葡萄', '香蕉', '苹果', '橘子', '西瓜']

// ========== 元组（Tuple）==========
// 特点：有序、不可变（TS 用 readonly 数组表达）、允许重复

const point: readonly [number, number] = [3, 4];  // 一个二维坐标
console.log(point[0]);         // 3
// point[0] = 5;              // 报错！readonly 数组不能修改

// 用途：表示不应该被改变的数据
// 比如：GPS坐标、RGB颜色值、数据库查询结果

const rgbRed: readonly [number, number, number] = [255, 0, 0];  // 红色的RGB值
console.log(`红色的R值: ${rgbRed[0]}`);  // 255

// 元组解构（非常常用！）
const [x2, y2] = point;
console.log(`x=${x2}, y=${y2}`);  // x=3, y=4

// ========== Map（字典）==========
// 特点：键值对存储，键唯一，查找速度极快

const student: Map<string, string | number> = new Map<string, string | number>([
  ["name", "小明"],
  ["age", 18],
  ["grade", "高三"],
]);

// 通过键访问值
console.log(student.get("name"));     // 小明
console.log(student.get("age"));      // 18（get 方法更安全，键不存在时返回 undefined）

// 添加/修改
student.set("score", 95);   // 添加新键值对
student.set("age", 19);     // 修改已有的值

// 遍历 Map
for (const [key, value] of student) {
  console.log(`${key}: ${value}`);
}

// 判断键是否存在
if (student.has("name")) {
  console.log(`学生姓名: ${student.get("name")}`);
}

// Map 的最大优势：查找速度快
// 不管 Map 有10条还是1000万条数据，通过键查找的速度几乎一样快！

// ========== Set（集合）==========
// 特点：无序、不重复、支持集合运算

// 创建集合
const numberSet: Set<number> = new Set([1, 2, 3, 4, 5]);
console.log(numberSet);  // Set(5) { 1, 2, 3, 4, 5 }

// 自动去重
const duplicates: number[] = [1, 2, 2, 3, 3, 3, 4];
const unique: Set<number> = new Set(duplicates);
console.log(unique);  // Set(4) { 1, 2, 3, 4 }

// 集合运算
const classA: Set<string> = new Set(["小明", "小红", "小刚"]);
const classB: Set<string> = new Set(["小红", "小刚", "小丽"]);

// 交集：两个班都有的学生
const intersection: Set<string> = new Set(
  [...classA].filter((x) => classB.has(x))
);
console.log(intersection);  // Set(2) { '小红', '小刚' }

// 并集：所有学生（不重复）
const union: Set<string> = new Set([...classA, ...classB]);
console.log(union);  // Set(4) { '小明', '小红', '小刚', '小丽' }

// 差集：在A班但不在B班的学生
const difference: Set<string> = new Set(
  [...classA].filter((x) => !classB.has(x))
);
console.log(difference);  // Set(1) { '小明' }

// 用途：快速判断某个元素是否存在
const validIds: Set<number> = new Set([1001, 1002, 1003, 1004, 1005]);
console.log(validIds.has(1003));  // true（瞬间完成，不管集合多大）
```

##### 六、TypeScript 实用技巧

```typescript
// ========== 数组推导（map / filter）==========

// 传统方式：用 for 循环创建数组
const squaresOld: number[] = [];
for (let i = 1; i <= 5; i++) {
  squaresOld.push(i ** 2);
}
console.log(squaresOld);  // [1, 4, 9, 16, 25]

// 用 map：一行搞定
const squaresNew: number[] = [1, 2, 3, 4, 5].map((i) => i ** 2);
console.log(squaresNew);  // [1, 4, 9, 16, 25]

// 带条件的推导（filter + map）
// 只保留偶数的平方
const evenSquares: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  .filter((i) => i % 2 === 0)
  .map((i) => i ** 2);
console.log(evenSquares);  // [4, 16, 36, 64, 100]

// 实用场景：初始化一个全0数组（在算法中经常需要）
const dp: number[] = new Array(10).fill(0);  // 创建长度为10的全0数组
console.log(dp);  // [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

// 创建二维数组（矩阵）—— TS 没有 Python 的乘法陷阱，但同样要逐行创建
// 推荐写法（每行独立）：
const correct: number[][] = Array.from({ length: 3 }, () =>
  new Array<number>(3).fill(0)
);
correct[0][0] = 1;
console.log(correct);  // [[1, 0, 0], [0, 0, 0], [0, 0, 0]] —— 只有第一行变了

// ========== 解构赋值（Unpacking）==========

// 基本解构
const [a, b, c] = [1, 2, 3];
console.log(a, b, c);  // 1 2 3

// 交换两个变量（解构赋值一行搞定）
let [x3, y3] = [10, 20];
[x3, y3] = [y3, x3];   // 一行交换！不需要临时变量
console.log(x3, y3);   // 20 10

// 解构数组（rest 参数）
const [first, ...rest] = [1, 2, 3, 4, 5];
console.log(first);    // 1
console.log(rest);     // [2, 3, 4, 5]

// 取第一个和最后一个
const [first2, ...middle] = [1, 2, 3, 4, 5];
const last = middle[middle.length - 1];
console.log(first2);   // 1
console.log(middle);   // [2, 3, 4]
console.log(last);     // 5

// 函数返回多个值时常用解构
function getStats(numbers: number[]): [number, number, number] {
  const sum = numbers.reduce((acc, n) => acc + n, 0);
  return [Math.min(...numbers), Math.max(...numbers), sum / numbers.length];
}

const [lo, hi, avg] = getStats([10, 20, 30, 40, 50]);
console.log(`最小: ${lo}, 最大: ${hi}, 平均: ${avg}`);
// 输出: 最小: 10, 最大: 50, 平均: 30

// ========== 同时获取索引和值（forEach 的第二参数）==========

// 用 forEach 同时拿索引和值
const fruits3: string[] = ["苹果", "香蕉", "橘子"];
fruits3.forEach((fruit, i) => {
  console.log(`索引 ${i}: ${fruit}`);
});

// 从1开始编号
fruits3.forEach((fruit, i) => {
  console.log(`第 ${i + 1} 个: ${fruit}`);
});
// 输出:
// 第 1 个: 苹果
// 第 2 个: 香蕉
// 第 3 个: 橘子

// 实用场景：在算法中找到某个元素的索引
function findIndex(arr: string[], target: string): number {
  const idx = arr.indexOf(target);
  return idx;  // 没找到返回 -1
}

console.log(findIndex(["a", "b", "c", "d"], "c"));  // 输出: 2

// ========== 并行遍历多个数组 ==========

const names: string[] = ["小明", "小红", "小刚"];
const scores2: number[] = [95, 88, 76];

// 同时遍历两个数组
names.forEach((name2, i) => {
  console.log(`${name2}的成绩是${scores2[i]}分`);
});

// 用 zip 思想创建字典（Map）
const scoreMap: Map<string, number> = new Map(
  names.map((name2, i) => [name2, scores2[i]])
);
console.log(scoreMap);  // Map(3) { '小明' => 95, '小红' => 88, '小刚' => 76 }

// 实用场景：在算法中同时处理相关数据（点积）
function dotProduct(v1: number[], v2: number[]): number {
  let sum = 0;
  for (let i = 0; i < v1.length; i++) {
    sum += v1[i] * v2[i];
  }
  return sum;
}

console.log(dotProduct([1, 2, 3], [4, 5, 6]));  // 1*4 + 2*5 + 3*6 = 32

// ========== 其他实用技巧 ==========

// 1. 三元表达式（条件表达式）
const age: number = 20;
const personStatus: string = age >= 18 ? "成年" : "未成年";
console.log(personStatus);  // 成年

// 2. 数组切片的高级用法
const nums: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
console.log(nums.filter((_, i) => i % 2 === 0));      // [0, 2, 4, 6, 8] 每隔一个取
console.log([...nums].reverse());                     // [9, 8, ..., 0]  反转数组
console.log(nums.filter((_, i) => i >= 2 && i <= 7 && (i - 2) % 3 === 0));  // [2, 5]

// 3. 用 join 拼接字符串（比 + 号快得多）
const words: string[] = ["Hello", "World", "Python"];
const sentence: string = words.join(" ");
console.log(sentence);  // Hello World Python

// 4. 用 some 和 every 做批量判断
const scores3: number[] = [85, 92, 78, 96, 88];
console.log(scores3.some((s) => s > 95));  // true（有一个超过95）
console.log(scores3.every((s) => s > 60)); // true（全部及格）

// 5. 统计频率（用 Map 手动计数，算法题中非常有用）
const text: string = "abracadabra";
const freq: Map<string, number> = new Map();
for (const ch of text) {
  freq.set(ch, (freq.get(ch) ?? 0) + 1);
}
console.log(freq);
// Map(5) { 'a' => 5, 'b' => 2, 'r' => 2, 'c' => 1, 'd' => 1 }

// 出现最多的前2个
const sortedFreq = [...freq.entries()].sort((x, y) => y[1] - x[1]);
console.log(sortedFreq.slice(0, 2));  // [['a', 5], ['b', 2]]
```

### 主题1 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 1.1 变量与基本数据类型

```go
package main

import "fmt"

// ========== 变量与基本数据类型 ==========
// Go 用 var 声明变量（可显式给类型），:= 可自动推断类型

func main() {
	// 整数（int）—— 用来计数
	var studentCount int = 100

	// 浮点数（float64）—— 用来表示小数
	var price float64 = 19.9

	// 字符串（string）—— 用来表示文本
	var name string = "小明"

	// 布尔值（bool）—— 只有 true 和 false 两个值
	var isPassed bool = true

	// 用 fmt.Printf + %T 查看变量类型
	fmt.Printf("%T\n", studentCount)  // int
	fmt.Printf("%T\n", price)         // float64
	fmt.Printf("%T\n", name)          // string
	fmt.Printf("%T\n", isPassed)      // bool

	// Go 是静态类型语言：变量类型声明后就固定了
	// 想"同一个变量存不同类型"，需要声明 interface{} 或分别用不同变量
	var x interface{} = 42     // x 现在是整数
	x = "hello"                 // x 现在是字符串（interface{} 可存任意类型）
	fmt.Println(x)              // 输出: hello
}
```

**Go 基础类型全景**（上例只列了最常用的 4 种，Go 的类型比 Python/JS 更多更细）：

| 分类 | 类型 | 说明 | 常用度 |
|------|------|------|--------|
| 布尔 | `bool` | true / false | ★★★ |
| 字符串 | `string` | 文本（UTF-8，不可变） | ★★★ |
| 整数（有符号） | `int` / `int8` / `int16` / `int32` / `int64` | int 默认跟随系统（64位） | ★★★（int 最常用） |
| 整数（无符号） | `uint` / `uint8` / `uint16` / `uint32` / `uint64` | 非负数场景 | ★★ |
| 字节/字符 | `byte`（=uint8）/ `rune`（=int32） | byte 处理二进制；rune 处理 Unicode 字符 | ★★★ |
| 浮点 | `float32` / `float64` | 小数，默认 float64 | ★★★（float64） |
| 复数 | `complex64` / `complex128` | 数学复数 | ★ 不常用 |
| 指针/特殊 | `uintptr` | 指针整数表示（底层） | ★ 不常用 |
| 空接口 | `interface{}` / `any` | 可存任意类型（Go 1.18+ 可用 any） | ★★★ |

**Go 复合类型**（容器 + 自定义类型）：

| 类型 | 一句话 | 常用度 |
|------|--------|--------|
| `array [N]T` | 定长数组（长度固定） | ★★ |
| `slice []T` | 动态数组（最常用！类似 list） | ★★★ |
| `map[K]V` | 键值对 | ★★★ |
| `struct` | 自定义结构体（字段集合） | ★★★ |
| `pointer *T` | 指针 | ★★★ |
| `interface` | 方法集合（抽象约定） | ★★★ |
| `func` | 函数类型（可当变量传） | ★★★ |
| `channel chan T` | 并发通信管道 | ★★★（并发时） |
| `type` 定义/别名 | `type MyInt int` 自定义新类型 | ★★ |

```go
package main

import "fmt"

func main() {
	// byte 与 rune：处理字节/字符
	var b byte = 'a'          // byte = uint8，存一个字节
	var r rune = '中'         // rune = int32，存一个 Unicode 字符
	fmt.Printf("byte=%c rune=%c\n", b, r)

	// struct：自定义结构体（Go 没有 class，用 struct 组合）
	type User struct {
		Name string
		Age  int
	}
	u := User{Name: "小明", Age: 18}
	fmt.Println(u.Name)       // 小明

	// pointer：指针（Go 用 & 取地址，* 解引用）
	n := 10
	p := &n
	*p = 20                   // 通过指针改值
	fmt.Println(n)            // 20

	// channel：并发管道（后面并发章节详细讲）
	ch := make(chan int, 1)
	ch <- 42                  // 放进去
	v := <-ch                 // 取出来
	fmt.Println(v)            // 42
}
```

> 常用度标注：★★★ 必须掌握；★★ 遇到认识即可；★ 了解存在，用到再查。

##### 1.2 条件判断（if / else if / else）

```go
package main

import "fmt"

func main() {
	// ========== 条件判断 ==========

	score := 85

	if score >= 90 {
		fmt.Println("优秀！") // 90分及以上走这条路
	} else if score >= 80 {
		fmt.Println("良好！") // 80~89分走这条路
	} else if score >= 60 {
		fmt.Println("及格。") // 60~79分走这条路
	} else {
		fmt.Println("不及格！") // 60分以下走这条路
	}

	// 输出: 良好！

	// --- 实际例子：判断一个数是正数、负数还是零 ---
	fmt.Println(checkNumber(7))  // 输出: 正数
	fmt.Println(checkNumber(-3)) // 输出: 负数
	fmt.Println(checkNumber(0))  // 输出: 零
}

func checkNumber(n int) string {
	if n > 0 {
		return "正数"
	} else if n < 0 {
		return "负数"
	} else {
		return "零"
	}
}
```

##### 1.3 循环（for / while）

```go
package main

import "fmt"

func main() {
	// ========== for 循环 ==========
	// 适用于"已知要循环多少次"的场景

	// 遍历一个切片
	fruits := []string{"苹果", "香蕉", "橘子"}
	for _, fruit := range fruits {
		fmt.Printf("我喜欢吃%s\n", fruit)
	}

	// 输出:
	// 我喜欢吃苹果
	// 我喜欢吃香蕉
	// 我喜欢吃橘子

	// 使用 for 生成数字序列
	// i 从 0 到 4（注意：不包含5）
	for i := 0; i < 5; i++ {
		fmt.Printf("第 %d 次循环\n", i)
	}

	// i 从 1 到 5
	for i := 1; i <= 5; i++ {
		fmt.Printf("倒数第 %d 名\n", 6-i)
	}

	// ========== while 循环 ==========
	// Go 没有 while 关键字，用 for 条件表达式代替

	// 倒计时
	countdown := 5
	for countdown > 0 {
		fmt.Printf("倒计时: %d\n", countdown)
		countdown -= 1 // 每次减1，别忘了这步，否则会死循环！
	}
	fmt.Println("发射！🚀")

	// --- break 和 continue ---
	// break: 直接跳出整个循环
	// continue: 跳过本次，进入下一次循环

	for i := 0; i < 10; i++ {
		if i == 3 {
			continue // 跳过3，继续下一轮
		}
		if i == 7 {
			break // 到7就彻底结束循环
		}
		fmt.Print(i, " ")
	}

	// 输出: 0 1 2 4 5 6
	// 注意：3被continue跳过了，7及之后的数字因为break没有出现
}
```

##### 1.4 函数定义

```go
package main

import "fmt"

// 基本语法：func 函数名(参数 类型) 返回类型
func greet(name string) string {
	return fmt.Sprintf("你好，%s！欢迎学习数据结构！", name)
}

func main() {
	// 调用函数
	message := greet("小红")
	fmt.Println(message) // 输出: 你好，小红！欢迎学习数据结构！

	// --- 带多个参数的函数 ---
	fmt.Printf("面积是: %d\n", calculateArea(5, 3)) // 输出: 面积是: 15

	// --- 带默认参数的函数 ---
	// Go 没有默认参数，用变长参数或单独函数实现
	fmt.Println(power(3, 2))  // 输出: 9  （3的2次方）
	fmt.Println(power(2, 10)) // 输出: 1024 （2的10次方）

	// --- 返回多个值 ---
	smallest, largest := minMax([]int{3, 1, 4, 1, 5, 9, 2, 6})
	fmt.Printf("最小值: %d, 最大值: %d\n", smallest, largest) // 输出: 最小值: 1, 最大值: 9
}

func calculateArea(width, height int) int {
	return width * height
}

func power(base, exponent int) int {
	result := 1
	for i := 0; i < exponent; i++ {
		result *= base
	}
	return result
}

func minMax(numbers []int) (int, int) {
	minVal, maxVal := numbers[0], numbers[0]
	for _, n := range numbers {
		if n < minVal {
			minVal = n
		}
		if n > maxVal {
			maxVal = n
		}
	}
	return minVal, maxVal
}
```

##### 1.5 切片（list）基本操作

```go
package main

import (
	"fmt"
	"sort"
)

func main() {
	// ========== 切片基本操作 ==========

	// 创建切片
	numbers := []int{10, 20, 30, 40, 50}

	// 访问元素（索引从0开始）
	fmt.Println(numbers[0])                  // 输出: 10（第一个元素）
	fmt.Println(numbers[len(numbers)-1])     // 输出: 50（最后一个元素）
	fmt.Println(numbers[1:3])                // 输出: [20 30]（切片：取索引1到2的元素）

	// 修改元素
	numbers[0] = 99
	fmt.Println(numbers)  // 输出: [99 20 30 40 50]

	// 添加元素
	numbers = append(numbers, 60)   // 在末尾添加
	fmt.Println(numbers)            // 输出: [99 20 30 40 50 60]

	// 在指定位置插入（索引0处插入5）—— Go 没有内置 insert，手动拼接
	numbers = append(numbers[:1], append([]int{5}, numbers[1:]...)...)
	// 注意：上面的写法会覆盖底层数组，教学用简化写法
	numbers = []int{5, 99, 20, 30, 40, 50, 60}
	fmt.Println(numbers)  // 输出: [5 99 20 30 40 50 60]

	// 删除元素
	numbers = numbers[:len(numbers)-1]  // 删除并返回最后一个元素
	fmt.Println(numbers)                // 输出: [5 99 20 30 40 50]

	// 删除第一个值为99的元素
	for i, v := range numbers {
		if v == 99 {
			numbers = append(numbers[:i], numbers[i+1:]...)
			break
		}
	}
	fmt.Println(numbers)  // 输出: [5 20 30 40 50]

	// 常用方法
	fmt.Println(len(numbers))        // 长度: 5
	fmt.Println(contains(numbers, 30)) // 判断30是否在切片中: true
	sort.Ints(numbers)               // 排序（原地排序）
	fmt.Println(numbers)             // 输出: [5 20 30 40 50]

	// 切片拼接
	listA := []int{1, 2, 3}
	listB := []int{4, 5, 6}
	combined := append(append([]int{}, listA...), listB...)
	fmt.Println(combined)  // 输出: [1 2 3 4 5 6]
}

func contains(s []int, target int) bool {
	for _, v := range s {
		if v == target {
			return true
		}
	}
	return false
}
```

##### 二、"程序 = 数据结构 + 算法"示例

```go
package main

import "fmt"

func main() {
	// ========== 一个简单的"程序 = 数据结构 + 算法"示例 ==========

	// 数据结构：用一个切片存储学生成绩
	scores := []int{78, 92, 65, 88, 55, 91, 73}

	// 算法：一个找出最高分的步骤
	// 程序：数据结构 + 算法 = 完整的程序
	result := findMaxScore(scores)
	fmt.Printf("最高分是: %d\n", result) // 输出: 最高分是: 92
}

func findMaxScore(scoreList []int) int {
	// 假设第一个元素是最大值
	maxScore := scoreList[0]
	// 遍历剩余元素，逐个比较
	for _, score := range scoreList[1:] {
		if score > maxScore {
			maxScore = score // 发现更大的，更新最大值
		}
	}
	return maxScore
}
```

##### 三、不同"数据结构"的对比

```go
package main

import "fmt"

func main() {
	// ========== 不同"数据结构"的对比 ==========

	// 方案一：书随便堆——用无序切片
	shelfRandom := []string{"西游记", "三体", "红楼梦", "基地", "三国演义"}

	// 找"三体"？只能一本一本翻
	fmt.Println(findBookRandom(shelfRandom, "三体")) // 找到了！在第 1 个位置

	// 方案二：书按拼音排好——用有序切片
	shelfSorted := []string{"基地", "红楼梦", "三国演义", "三体", "西游记"}

	// 找"三体"？可以用二分查找（每次排除一半），快得多！
	fmt.Println(findBookBinary(shelfSorted, "三体")) // 找到了！在第 3 个位置

	// 方案三：用 map 做索引——直接定位
	shelfIndex := map[string]string{
		"西游记": "A区-3架-5层",
		"三体":   "B区-1架-2层",
		"红楼梦": "A区-1架-1层",
	}

	// 找"三体"？直接查索引，一步到位！
	fmt.Printf("三体的位置: %s\n", shelfIndex["三体"]) // B区-1架-2层
}

func findBookRandom(shelf []string, bookName string) string {
	for i, book := range shelf {
		if book == bookName {
			return fmt.Sprintf("找到了！在第 %d 个位置", i)
		}
	}
	return "没找到"
}

func findBookBinary(shelf []string, bookName string) string {
	left, right := 0, len(shelf)-1

	for left <= right {
		mid := (left + right) / 2 // 看中间那本
		if shelf[mid] == bookName {
			return fmt.Sprintf("找到了！在第 %d 个位置", mid)
		} else if shelf[mid] < bookName {
			left = mid + 1 // 目标在右半边
		} else {
			right = mid - 1 // 目标在左半边
		}
	}
	return "没找到"
}
```

##### 四、算法示例：两种排序方法

```go
package main

import "fmt"

func main() {
	// ========== 算法示例：两种排序方法 ==========

	// 算法1：冒泡排序——像水中气泡一样，大的慢慢"浮"到后面
	arr1 := []int{64, 34, 25, 12, 22}
	fmt.Println("冒泡排序:", bubbleSort(arr1))
	// 输出: 冒泡排序: [12 22 25 34 64]

	// 算法2：选择排序——每次从未排序部分选出最小的，放到前面
	arr2 := []int{64, 34, 25, 12, 22}
	fmt.Println("选择排序:", selectionSort(arr2))
	// 输出: 选择排序: [12 22 25 34 64]
}

func bubbleSort(arr []int) []int {
	n := len(arr)
	for i := 0; i < n; i++ {
		for j := 0; j < n-i-1; j++ {
			// 如果前一个比后一个大，就交换
			if arr[j] > arr[j+1] {
				arr[j], arr[j+1] = arr[j+1], arr[j] // 交换
			}
		}
	}
	return arr
}

func selectionSort(arr []int) []int {
	n := len(arr)
	for i := 0; i < n; i++ {
		// 假设当前位置是最小值的索引
		minIdx := i
		for j := i + 1; j < n; j++ {
			if arr[j] < arr[minIdx] {
				minIdx = j // 找到更小的，更新索引
			}
		}
		// 把找到的最小值换到当前位置
		arr[i], arr[minIdx] = arr[minIdx], arr[i]
	}
	return arr
}
```

##### 五、Go 中常用的内置数据结构

```go
package main

import "fmt"

func main() {
	// ========== 切片（Slice，对应 list）==========
	// 特点：有序、可变、允许重复元素

	fruits := []string{"苹果", "香蕉", "苹果", "橘子"}
	fmt.Println(fruits)        // [苹果 香蕉 苹果 橘子]
	fmt.Println(fruits[1])     // 香蕉（通过索引访问）
	fmt.Println(len(fruits))   // 4（包含重复元素）

	fruits = append(fruits, "西瓜")     // 末尾添加
	fruits = insert(fruits, 1, "葡萄")  // 在索引1处插入
	fmt.Println(fruits)                // [苹果 葡萄 香蕉 苹果 橘子 西瓜]

	// ========== 元组（Tuple）==========
	// Go 没有元组类型，用固定长度数组 [N]T 表达"不可变"

	point := [2]int{3, 4}  // 一个二维坐标
	fmt.Println(point[0])  // 3
	// point[0] = 5        // 数组长度固定，语义上表达"不可变"

	// 用途：表示不应该被改变的数据
	// 比如：GPS坐标、RGB颜色值、数据库查询结果

	rgbRed := [3]int{255, 0, 0}  // 红色的RGB值
	fmt.Printf("红色的R值: %d\n", rgbRed[0]) // 255

	// 解包（Go 用多个返回值实现，数组用索引取值）
	x, y := point[0], point[1]
	fmt.Printf("x=%d, y=%d\n", x, y)  // x=3, y=4

	// ========== map（字典）==========
	// 特点：键值对存储，键唯一，查找速度极快

	student := map[string]interface{}{
		"name":  "小明",
		"age":   18,
		"grade": "高三",
	}

	// 通过键访问值
	fmt.Println(student["name"])    // 小明
	fmt.Println(student["age"])     // 18

	// 添加/修改
	student["score"] = 95  // 添加新键值对
	student["age"] = 19    // 修改已有的值

	// 遍历 map
	for key, value := range student {
		fmt.Printf("%s: %v\n", key, value)
	}

	// 判断键是否存在（Go 特有的"逗号 ok"写法）
	if name, ok := student["name"]; ok {
		fmt.Printf("学生姓名: %v\n", name)
	}

	// map 的最大优势：查找速度快
	// 不管 map 有10条还是1000万条数据，通过键查找的速度几乎一样快！

	// ========== Set（集合）==========
	// Go 没有内置 Set，用 map[T]struct{} 实现

	numberSet := map[int]struct{}{1: {}, 2: {}, 3: {}, 4: {}, 5: {}}
	fmt.Println(numberSet)  // map[1:{} 2:{} 3:{} 4:{} 5:{}]

	// 自动去重（用 map 收集）
	duplicates := []int{1, 2, 2, 3, 3, 3, 4}
	unique := map[int]struct{}{}
	for _, v := range duplicates {
		unique[v] = struct{}{}
	}
	fmt.Println(unique)  // map[1:{} 2:{} 3:{} 4:{}]

	// 集合运算
	classA := map[string]struct{}{"小明": {}, "小红": {}, "小刚": {}}
	classB := map[string]struct{}{"小红": {}, "小刚": {}, "小丽": {}}

	// 交集：两个班都有的学生
	intersection := map[string]struct{}{}
	for name := range classA {
		if _, ok := classB[name]; ok {
			intersection[name] = struct{}{}
		}
	}
	fmt.Println(intersection)  // map[小红:{} 小刚:{}]

	// 并集：所有学生（不重复）
	union := map[string]struct{}{}
	for name := range classA {
		union[name] = struct{}{}
	}
	for name := range classB {
		union[name] = struct{}{}
	}
	fmt.Println(union)  // map[小明:{} 小红:{} 小刚:{} 小丽:{}]

	// 差集：在A班但不在B班的学生
	difference := map[string]struct{}{}
	for name := range classA {
		if _, ok := classB[name]; !ok {
			difference[name] = struct{}{}
		}
	}
	fmt.Println(difference)  // map[小明:{}]

	// 用途：快速判断某个元素是否存在
	validIds := map[int]struct{}{1001: {}, 1002: {}, 1003: {}, 1004: {}, 1005: {}}
	_, exists := validIds[1003]
	fmt.Println(exists)  // true（瞬间完成，不管集合多大）
}

// 辅助函数：在切片 index 位置插入元素
func insert(s []string, index int, value string) []string {
	s = append(s, "")
	copy(s[index+1:], s[index:])
	s[index] = value
	return s
}
```

##### 六、Go 实用技巧

```go
package main

import (
	"fmt"
	"sort"
	"strings"
)

func main() {
	// ========== 用循环生成数组（Go 无列表推导式，用循环+append）==========

	// 传统方式：用 for 循环创建切片
	squaresOld := []int{}
	for i := 1; i <= 5; i++ {
		squaresOld = append(squaresOld, i*i)
	}
	fmt.Println(squaresOld)  // [1 4 9 16 25]

	// 带条件的生成
	// 只保留偶数的平方
	evenSquares := []int{}
	for i := 1; i <= 10; i++ {
		if i%2 == 0 {
			evenSquares = append(evenSquares, i*i)
		}
	}
	fmt.Println(evenSquares)  // [4 16 36 64 100]

	// 实用场景：初始化一个全0切片（在算法中经常需要）
	dp := make([]int, 10)  // 创建长度为10的全0切片
	fmt.Println(dp)        // [0 0 0 0 0 0 0 0 0 0]

	// 创建二维切片（矩阵）
	correct := make([][]int, 3)
	for i := range correct {
		correct[i] = make([]int, 3)  // 每行独立创建
	}
	correct[0][0] = 1
	fmt.Println(correct)  // [[1 0 0] [0 0 0] [0 0 0]] —— 只有第一行变了

	// ========== 多变量赋值（Unpacking）==========

	// 基本赋值
	a, b, c := 1, 2, 3
	fmt.Println(a, b, c)  // 1 2 3

	// 交换两个变量（Go 原生支持多变量交换）
	x, y := 10, 20
	x, y = y, x  // 一行交换！不需要临时变量
	fmt.Println(x, y)  // 20 10

	// 切片解包（Go 没有 *rest 语法，用切片截取）
	first := []int{1, 2, 3, 4, 5}
	head, rest := first[0], first[1:]
	fmt.Println(head)  // 1
	fmt.Println(rest)  // [2 3 4 5]

	// 取第一个和最后一个
	head2, middle, last := first[0], first[1:len(first)-1], first[len(first)-1]
	fmt.Println(head2)   // 1
	fmt.Println(middle)  // [2 3 4]
	fmt.Println(last)    // 5

	// 函数返回多个值时常用多变量接收
	lo, hi, avg := getStats([]int{10, 20, 30, 40, 50})
	fmt.Printf("最小: %d, 最大: %d, 平均: %.1f\n", lo, hi, avg)
	// 输出: 最小: 10, 最大: 50, 平均: 30.0

	// ========== 同时获取索引和值（for range 两值）==========

	fruits := []string{"苹果", "香蕉", "橘子"}

	// 用 for range 同时拿索引和值
	for i, fruit := range fruits {
		fmt.Printf("索引 %d: %s\n", i, fruit)
	}

	// 从1开始编号
	for i, fruit := range fruits {
		fmt.Printf("第 %d 个: %s\n", i+1, fruit)
	}
	// 输出:
	// 第 1 个: 苹果
	// 第 2 个: 香蕉
	// 第 3 个: 橘子

	// 实用场景：在算法中找到某个元素的索引
	fmt.Println(findIndex([]string{"a", "b", "c", "d"}, "c"))  // 输出: 2

	// ========== 并行遍历多个切片 ==========

	names := []string{"小明", "小红", "小刚"}
	scores := []int{95, 88, 76}

	// 同时遍历两个切片（Go 无 zip，用索引同步遍历）
	for i, name := range names {
		fmt.Printf("%s的成绩是%d分\n", name, scores[i])
	}

	// 实用场景：在算法中同时处理相关数据（点积）
	fmt.Println(dotProduct([]int{1, 2, 3}, []int{4, 5, 6}))  // 1*4 + 2*5 + 3*6 = 32

	// ========== 其他实用技巧 ==========

	// 1. 三元表达式（Go 没有，用 if 代替）
	age := 20
	var status string
	if age >= 18 {
		status = "成年"
	} else {
		status = "未成年"
	}
	fmt.Println(status)  // 成年

	// 2. 切片的高级用法
	nums := []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
	fmt.Println(everyOther(nums))       // [0 2 4 6 8]  每隔一个取
	fmt.Println(reverse(nums))          // [9 8 7 6 5 4 3 2 1 0]  反转切片
	fmt.Println(nums[2:8])              // [2 3 4 5 6 7]  子切片

	// 3. 用 strings.Join 拼接字符串（比 + 号快得多）
	words := []string{"Hello", "World", "Python"}
	sentence := strings.Join(words, " ")
	fmt.Println(sentence)  // Hello World Python

	// 4. 用循环做批量判断（Go 无 any/all 内置，手写）
	scores3 := []int{85, 92, 78, 96, 88}
	fmt.Println(anyAbove(scores3, 95))   // true（有一个超过95）
	fmt.Println(allAbove(scores3, 60))   // true（全部及格）

	// 5. 统计频率（用 map 手动计数，在算法题中非常有用）
	text := "abracadabra"
	freq := map[rune]int{}
	for _, ch := range text {
		freq[ch]++
	}
	fmt.Println(freq)  // map[97:5 98:2 99:1 100:1 114:2]  (a=5 b=2 r=2 c=1 d=1)

	// 出现最多的前2个（排序后取前2）
	type kv struct {
		key rune
		val int
	}
	var entries []kv
	for k, v := range freq {
		entries = append(entries, kv{k, v})
	}
	sort.Slice(entries, func(i, j int) bool { return entries[i].val > entries[j].val })
	top2 := entries[:2]
	for _, e := range top2 {
		fmt.Printf("%c: %d\n", e.key, e.val)
	}
	// 输出:
	// a: 5
	// b: 2
}

func getStats(numbers []int) (int, int, float64) {
	minVal, maxVal := numbers[0], numbers[0]
	sum := 0
	for _, n := range numbers {
		if n < minVal {
			minVal = n
		}
		if n > maxVal {
			maxVal = n
		}
		sum += n
	}
	return minVal, maxVal, float64(sum) / float64(len(numbers))
}

func findIndex(arr []string, target string) int {
	for i, v := range arr {
		if v == target {
			return i
		}
	}
	return -1 // 没找到
}

func dotProduct(v1, v2 []int) int {
	sum := 0
	for i := 0; i < len(v1); i++ {
		sum += v1[i] * v2[i]
	}
	return sum
}

func everyOther(nums []int) []int {
	result := []int{}
	for i, v := range nums {
		if i%2 == 0 {
			result = append(result, v)
		}
	}
	return result
}

func reverse(nums []int) []int {
	result := make([]int, len(nums))
	for i, v := range nums {
		result[len(nums)-1-i] = v
	}
	return result
}

func anyAbove(s []int, threshold int) bool {
	for _, v := range s {
		if v > threshold {
			return true
		}
	}
	return false
}

func allAbove(s []int, threshold int) bool {
	for _, v := range s {
		if v <= threshold {
			return false
		}
	}
	return true
}
```

### 主题2：复杂度分析


#### 一、为什么要分析算法优劣

##### 从北京到上海的不同路线

假设你要从北京去上海，有以下几种方式：

| 方式 | 耗时 | 类比 |
|------|------|------|
| 高铁 | 约4.5小时 | 好算法 |
| 飞机 | 约2小时 | 更好的算法 |
| 骑自行车 | 约5天 | 差算法 |
| 步行 | 约20天 | 极差的算法 |

所有方式都能到达目的地（都能解决问题），但**效率天差地别**。在编程中，数据量小的时候，差算法和好算法看起来都很快；但当数据量暴增（比如从100条变成10亿条），差距就会被无限放大。

```python
# ========== 感受算法效率的差距 ==========
import time

# 算法A：逐个查找（线性查找）—— 像"骑自行车"
def linear_search(arr, target):
    """从头到尾一个一个找"""
    for i in range(len(arr)):
        if arr[i] == target:
            return i
    return -1

# 算法B：二分查找—— 像"坐高铁"
def binary_search(arr, target):
    """每次排除一半，快速定位"""
    left, right = 0, len(arr) - 1
    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1

# 测试：在100万个数字中查找
big_list = list(range(1000000))  # [0, 1, 2, ..., 999999]
target = 999999                   # 找最后一个（最坏情况）

start = time.time()
linear_search(big_list, target)
print(f"线性查找: {(time.time() - start)*1000:.2f} 毫秒")

start = time.time()
binary_search(big_list, target)
print(f"二分查找: {(time.time() - start)*1000:.6f} 毫秒")

# 典型输出：
# 线性查找: 50.00 毫秒
# 二分查找: 0.002000 毫秒
# 差距达到数万倍！数据量越大，差距越夸张
```

> **核心结论**：分析算法优劣，不是为了"学术比较"，而是为了在数据量大的时候，程序不会卡死。

---

#### 二、大O表示法

##### 什么是大O表示法？

大O表示法（Big-O notation）是一种描述**算法效率**的语言。它不告诉你精确的运行时间（那取决于电脑性能），而是告诉你：**当数据量 n 增大时，操作次数的增长趋势**。

##### 类比：快递费用

想象一个快递公司：
- 同城快递：不管寄什么，都是10元 → **O(1)**，固定不变
- 按重量计费：1公斤10元，2公斤20元 → **O(n)**，线性增长
- 奢侈品保险：价值翻倍，保费翻四倍 → **O(n²)**，平方增长

大O关注的是**趋势**，不是精确数字。就像你看天气预报说"明天升温"，不需要知道精确到0.01度。

##### 大O的核心规则

```python
# ========== 大O表示法的核心规则 ==========

# 规则1：忽略常数
# O(3n) → O(n)
# O(500) → O(1)
# 原因：大O描述的是"趋势"，常数不改变趋势

# 例如：
def example1(arr):
    for x in arr:        # n次
        print(x)
    for x in arr:        # n次
        print(x)
    for x in arr:        # n次
        print(x)
# 总共 3n 次操作 → 简化为 O(n)

# 规则2：只保留最高阶项
# O(n² + n + 100) → O(n²)
# 原因：n很大时，低阶项的影响微乎其微

# 例如：当 n = 10000 时
# n² = 100,000,000
# n  = 10,000
# 100 = 100
# n² 占了绝对主导地位，n和100可以忽略

# 规则3：不同输入分别标注
# 如果有两个不同的输入规模 m 和 n，不能合并
def example2(list_a, list_b):
    for x in list_a:    # m次
        print(x)
    for x in list_b:    # n次
        print(x)
# 复杂度是 O(m + n)，不能简化为 O(n)
```

---

#### 三、时间复杂度

##### 什么是时间复杂度？

时间复杂度描述的是：**算法的执行时间随输入规模 n 增长的趋势**。

注意：它不是精确的秒数，而是**操作次数与 n 的关系**。

##### 如何计算时间复杂度？

关键就是数**基本操作的执行次数**，然后用大O表示。

```python
# ========== 计算时间复杂度示例 ==========

# 示例1：O(1)
def get_first(arr):
    return arr[0]
# 只执行了1次操作，不随n变化 → O(1)

# 示例2：O(n)
def print_all(arr):
    for item in arr:    # 执行n次
        print(item)
# 操作次数 = n → O(n)

# 示例3：O(n²)
def print_pairs(arr):
    for i in arr:              # 外层n次
        for j in arr:          # 内层n次
            print(i, j)        # 总共 n × n = n² 次
# 操作次数 = n² → O(n²)

# 示例4：O(n) 不是 O(2n)
def two_pass(arr):
    # 第一遍：找最大值
    max_val = arr[0]
    for x in arr:
        if x > max_val:
            max_val = x

    # 第二遍：找最小值
    min_val = arr[0]
    for x in arr:
        if x < min_val:
            min_val = x

    return max_val, min_val
# 操作次数 = n + n = 2n → 忽略常数 → O(n)
```

---

#### 四、空间复杂度

##### 什么是空间复杂度？

空间复杂度描述的是：**算法需要的额外内存空间随输入规模 n 增长的趋势**。

类比：做菜时，除了食材本身（输入数据），你还需要额外的碗碟、锅具（额外空间）。空间复杂度衡量的就是**额外需要多少碗碟**。

```python
# ========== 空间复杂度示例 ==========

# 示例1：O(1) 空间——只用了固定几个变量
def find_sum(arr):
    total = 0          # 只开辟了一个变量的空间
    for num in arr:
        total += num
    return total
# 不管arr有10个还是100万个元素，额外空间就是一个变量 → O(1)

# 示例2：O(n) 空间——创建了与输入等大的新列表
def double_elements(arr):
    result = []             # 新建一个列表
    for num in arr:
        result.append(num * 2)
    return result
# arr有n个元素，result也有n个元素 → 额外空间 O(n)

# 示例3：O(n) 空间——创建了一个字典
def count_frequency(arr):
    freq = {}               # 新建一个字典
    for item in arr:
        freq[item] = freq.get(item, 0) + 1
    return freq
# 最坏情况下（所有元素不同），字典有n个键值对 → O(n)

# 示例4：O(n²) 空间——创建了二维结构
def create_matrix(n):
    matrix = []
    for i in range(n):
        row = [0] * n        # 每行n个元素 //[0] * 3   # 把 [0] 这个列表重复 3 次 → [0, 0, 0]
        matrix.append(row)
    return matrix
# n行 × n列 = n² 个元素 → O(n²)
```

> **注意**：在大多数算法题中，我们更关注**时间复杂度**。但如果内存有限（比如嵌入式设备），空间复杂度同样重要。

---

#### 五、常见复杂度详解

##### 5.1 O(1) 常数时间

**含义**：不管数据量多大，操作次数固定不变。

**类比**：不管图书馆有100本书还是100万本书，你直接走到前台问管理员，管理员立刻告诉你书在哪——一步到位。

```python
# ========== O(1) 常数时间 ==========

# 示例1：访问列表的某个元素
def get_element(arr, index):
    return arr[index]
# 不管列表多长，通过索引访问都是瞬间完成 → O(1)

# 示例2：判断奇偶
def is_even(n):
    return n % 2 == 0
# 一次取模运算，不管n多大 → O(1)

# 示例3：字典的查找
def check_student(student_dict, name):
    return name in student_dict
# 字典通过键查找，不管字典多大，速度几乎一样 → O(1)

# 示例4：固定次数的操作
def constant_operations(arr):
    print(arr[0])           # 1次
    print(arr[-1])          # 1次
    x = 1 + 2 + 3          # 1次
    return x
# 不管arr多长，永远只执行3步 → O(1)
```

##### 5.2 O(log n) 对数时间

**含义**：每步操作都将问题规模减半，所需步数就是 log₂n。

**类比**：猜数字游戏。"我心里想了一个1~100的数字"。你每次猜一个数，我告诉你"大了"或"小了"。最优策略是每次猜中间值：
- 第1次猜50 → 范围缩小到50个
- 第2次猜25 → 范围缩小到25个
- 第3次猜12 → 范围缩小到12个
- ……
- 最多7次就能猜中！（因为 2⁷ = 128 > 100）

```python
# ========== O(log n) 对数时间 ==========

# 经典例子：二分查找
def binary_search(arr, target):
    """在有序数组中查找目标值"""
    left, right = 0, len(arr) - 1

    while left <= right:
        mid = (left + right) // 2   # 取中间位置
        if arr[mid] == target:
            return mid               # 找到了
        elif arr[mid] < target:
            left = mid + 1           # 目标在右半部分
        else:
            right = mid - 1          # 目标在左半部分
    return -1

# 每次循环，搜索范围减半：
# n → n/2 → n/4 → n/8 → ... → 1
# 需要多少次？ log₂(n) 次！
# 例如 n=1024，最多只需 10 次（2^10 = 1024）

sorted_list = list(range(0, 1024))
print(binary_search(sorted_list, 500))  # 输出: 500

# 另一个例子：每次将数字减半到1
def halve_until_one(n):
    """每次将n除以2，直到变成1，需要几步？"""
    steps = 0
    while n > 1:
        n = n // 2
        steps += 1
        print(f"第{steps}步: n = {n}")
    return steps

print(f"总共需要 {halve_until_one(64)} 步")
# 64 → 32 → 16 → 8 → 4 → 2 → 1，共6步
# log₂(64) = 6 ✓
```

> **O(log n) 非常高效！** 即使数据量达到10亿，也只需要约30步。这就是为什么二分查找如此强大。

##### 5.3 O(n) 线性时间

**含义**：操作次数与数据量成正比。数据量翻倍，时间也翻倍。

**类比**：老师点名——班上有30人要叫30次，60人要叫60次。

```python
# ========== O(n) 线性时间 ==========

# 示例1：遍历列表
def print_all(arr):
    for item in arr:
        print(item)
# n个元素，打印n次 → O(n)

# 示例2：线性查找
def linear_search(arr, target):
    for i in range(len(arr)):
        if arr[i] == target:
            return i
    return -1
# 最坏情况：遍历整个列表 → O(n)

# 示例3：求和
def array_sum(arr):
    total = 0
    for num in arr:
        total += num
    return total
# 遍历n个元素，做n次加法 → O(n)

# 示例4：找最大值
def find_max(arr):
    max_val = arr[0]
    for item in arr[1:]:
        if item > max_val:
            max_val = item
    return max_val
# 必须看每个元素才能确定最大值 → O(n)
```

##### 5.4 O(n log n) 线性对数时间

**含义**：比 O(n) 慢一些，但比 O(n²) 快得多。这是**高效排序算法**的典型复杂度。

**类比**：你要整理一摞扑克牌。最好的方法是：先分成小堆，每堆分别排好序，然后合并。这比"每张牌都和其他所有牌比较"要快得多。

```python
# ========== O(n log n) 线性对数时间 ==========

# 经典例子：归并排序
def merge_sort(arr):
    """归并排序：分而治之，递归排序后合并"""
    # 基本情况：长度为0或1的列表天然有序
    if len(arr) <= 1:
        return arr

    # 分成两半
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])    # 递归排序左半部分
    right = merge_sort(arr[mid:])   # 递归排序右半部分

    # 合并两个有序列表
    return merge(left, right)

def merge(left, right):
    """合并两个有序列表"""
    result = []
    i = j = 0

    # 比较两个列表的元素，从小到大放入result
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1

    # 把剩余的元素追加到末尾
    result.extend(left[i:])
    result.extend(right[j:])
    return result

# 测试
unsorted = [38, 27, 43, 3, 9, 82, 10]
sorted_list = merge_sort(unsorted)
print(f"排序结果: {sorted_list}")
# 输出: 排序结果: [3, 9, 10, 27, 38, 43, 82]

# 为什么是 O(n log n)？
# - 每次把数组分成两半 → 递归深度 log n 层
# - 每层合并操作需要遍历所有 n 个元素 → 每层 O(n)
# - 总共: O(n) × O(log n) = O(n log n)
```

> **O(n log n) 是基于比较的排序算法的理论下限**——不可能有基于比较的排序比 O(n log n) 更快。这就是为什么归并排序、快速排序、堆排序都是 O(n log n)。

##### 5.5 O(n²) 平方时间

**含义**：操作次数与数据量的平方成正比。数据量翻倍，时间变成4倍。

**类比**：班级里每个人都要和其他每个人握一次手。30人班级要握 30×29/2 = 435 次手；60人班级要握 60×59/2 = 1770 次手——人数翻倍，握手次数变成约4倍。

```python
# ========== O(n²) 平方时间 ==========

# 示例1：冒泡排序
def bubble_sort(arr):
    """冒泡排序：相邻元素两两比较和交换"""
    n = len(arr)
    for i in range(n):                    # 外层循环 n 次
        for j in range(0, n - i - 1):     # 内层循环约 n 次
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
    return arr
# 两层嵌套循环，每层约n次 → n × n = n² → O(n²)

print(bubble_sort([64, 34, 25, 12, 22]))
# 输出: [12, 22, 25, 34, 64]

# 示例2：打印所有数对
def print_all_pairs(arr):
    """打印列表中所有可能的两个元素的组合"""
    n = len(arr)
    for i in range(n):            # 外层 n 次
        for j in range(n):        # 内层 n 次
            print(f"({arr[i]}, {arr[j]})")
# n × n = n² 次操作 → O(n²)

# 示例3：选择排序
def selection_sort(arr):
    """选择排序：每次选出最小的放到前面"""
    n = len(arr)
    for i in range(n):
        min_idx = i
        for j in range(i + 1, n):    # 内层循环
            if arr[j] < arr[min_idx]:
                min_idx = j
        arr[i], arr[min_idx] = arr[min_idx], arr[i]
    return arr
# 虽然内层循环次数递减 (n-1) + (n-2) + ... + 1 = n(n-1)/2
# 但 n(n-1)/2 = n²/2 - n/2，忽略常数和低阶项 → O(n²)

print(selection_sort([64, 34, 25, 12, 22]))
# 输出: [12, 22, 25, 34, 64]
```

##### 5.6 O(2ⁿ) 指数时间

**含义**：数据量每增加1，操作次数翻倍。这是**非常慢**的算法，只在 n 很小时可行。

**类比**：一张纸对折1次是2层，对折2次是4层，对折10次是1024层，对折42次就能从地球到月球——指数增长的力量是可怕的。

```python
# ========== O(2ⁿ) 指数时间 ==========

# 经典例子：递归计算斐波那契数列（最朴素的写法）
def fib(n):
    """计算第n个斐波那契数（朴素递归）"""
    # 斐波那契数列: 1, 1, 2, 3, 5, 8, 13, 21, ...
    # 规律: 每个数 = 前两个数之和
    if n <= 1:
        return n
    return fib(n - 1) + fib(n - 2)
# 每次调用产生2个新的调用 → 调用次数呈指数增长
# 时间复杂度: O(2ⁿ)

# 让我们感受指数增长的恐怖
for n in [10, 20, 30, 35]:
    import time
    start = time.time()
    result = fib(n)
    elapsed = time.time() - start
    print(f"fib({n}) = {result}, 耗时: {elapsed:.4f}秒")

# 典型输出：
# fib(10) = 55, 耗时: 0.0000秒
# fib(20) = 6765, 耗时: 0.0002秒
# fib(30) = 832040, 耗时: 0.0180秒
# fib(35) = 9227465, 耗时: 1.5000秒  ← n只增加了5，时间暴增！
# fib(40) 可能需要几十秒，fib(50) 可能需要几小时...

# 对比：优化后的写法（动态规划），O(n)
def fib_fast(n):
    """计算第n个斐波那契数（动态规划）"""
    if n <= 1:
        return n
    prev, curr = 0, 1
    for _ in range(2, n + 1):
        prev, curr = curr, prev + curr  # 滚动计算
    return curr

print(f"fib_fast(100) = {fib_fast(100)}")  # 瞬间完成！
# 同样的问题，O(2ⁿ) 和 O(n) 的差距是天文数字
```

---

#### 六、如何分析嵌套循环的复杂度

嵌套循环是算法代码中最常见的结构，也是最容易分析出错的地方。

##### 核心原则

**总复杂度 = 外层循环次数 × 内层循环次数**

但要注意内层循环的次数是否依赖于外层循环的变量。

```python
# ========== 嵌套循环复杂度分析 ==========

# --- 类型1：内外层独立，都是n ---
# 复杂度: O(n × n) = O(n²)
def type1(n):
    for i in range(n):          # 外层: n次
        for j in range(n):      # 内层: n次（与i无关）
            print(i, j)
# 总操作: n × n = n²

# --- 类型2：内层递减 ---
# 复杂度: O(n²)（不是 O(n²/2)，因为忽略常数）
def type2(n):
    for i in range(n):              # 外层: n次
        for j in range(i, n):       # 内层: n-i次
            print(i, j)
# 总操作: n + (n-1) + (n-2) + ... + 1 = n(n+1)/2
# n(n+1)/2 = n²/2 + n/2 → 忽略常数和低阶项 → O(n²)

# --- 类型3：内外层不同规模 ---
# 复杂度: O(m × n)
def type3(list_a, list_b):
    for a in list_a:            # 外层: m次
        for b in list_b:        # 内层: n次
            print(a, b)
# 总操作: m × n → O(m × n)
# 注意：不能简化为 O(n²)，因为两个列表长度可能不同

# --- 类型4：三层嵌套 ---
# 复杂度: O(n³)
def type4(n):
    for i in range(n):          # 外层: n次
        for j in range(n):      # 中层: n次
            for k in range(n):  # 内层: n次
                print(i, j, k)
# 总操作: n × n × n = n³

# --- 类型5：嵌套但内层是对数级别 ---
# 复杂度: O(n log n)
def type5(n):
    for i in range(n):          # 外层: n次
        j = n
        while j > 1:            # 内层: log₂(n)次（每次减半）
            j = j // 2
            print(i, j)
# 总操作: n × log₂(n) → O(n log n)

# --- 类型6：看似嵌套，实际不是 ---
# 复杂度: O(n)，不是 O(n²)！
def type6(n):
    for i in range(n):          # 外层: n次
        print(i)
    for j in range(n):          # 这层不是嵌套的！是顺序的！
        print(j)
# 总操作: n + n = 2n → O(n)
```

##### 分析嵌套循环的常见陷阱

```python
# ========== 常见陷阱 ==========

# 陷阱1：内层循环的规模取决于外层变量
def trap1(n):
    for i in range(1, n + 1):       # i = 1, 2, 3, ..., n
        for j in range(1, i + 1):   # j = 1, 2, ..., i
            print(i, j)
# 内层次数: 1 + 2 + 3 + ... + n = n(n+1)/2 → O(n²)

# 陷阱2：看似三层嵌套，但实际不是 O(n³)
def trap2(n):
    for i in range(n):          # n次
        for j in range(n):      # n次
            k = j               # 注意：k不是独立的循环变量
            while k > 0:        # 最多j次，但平均来看...
                k = k // 2
                print(i, j, k)
# 这个分析比较复杂，内层while是 O(log j)
# 总体复杂度约为 O(n² log n)

# 陷阱3：循环变量步长不为1
def trap3(n):
    i = 1
    while i < n:
        i = i * 2        # 每次翻倍：1, 2, 4, 8, 16, ...
        print(i)
# 这不是 O(n)！而是 O(log n)
# 因为 i 按指数增长，到达 n 只需要 log₂(n) 步
```

---

#### 七、最好/最坏/平均情况分析

##### 三种情况的含义

| 情况 | 含义 | 类比 |
|------|------|------|
| 最好情况（Best Case） | 运气最好时的操作次数 | 出门就打到车 |
| 最坏情况（Worst Case） | 运气最差时的操作次数 | 下雨天排1小时队也打不到车 |
| 平均情况（Average Case） | 所有可能性的期望值 | 通常等10分钟能打到车 |

```python
# ========== 最好/最坏/平均情况分析 ==========

def linear_search(arr, target):
    """在列表中查找目标值"""
    for i in range(len(arr)):
        if arr[i] == target:
            return i
    return -1

# 假设 arr = [3, 1, 4, 1, 5, 9, 2, 6]，target = 5
# 最好情况：target在第一个位置 → 1次比较 → O(1)
# 最坏情况：target在最后一个位置或不存在 → n次比较 → O(n)
# 平均情况：target在中间某处 → n/2次比较 → O(n)
#   （因为 n/2 忽略常数后还是 O(n)）

# ========== 为什么通常关注最坏情况？ ==========
# 1. 最坏情况提供了"上界保证"——算法绝不会比这更差
# 2. 平均情况有时很难计算
# 3. 在关键系统（医疗、航空）中，必须保证最坏情况也能接受

# ========== 更好的例子：插入排序 ==========
def insertion_sort(arr):
    """插入排序：将每个元素插入到前面已排序部分的正确位置"""
    for i in range(1, len(arr)):
        key = arr[i]
        j = i - 1
        # 将比key大的元素向后移
        while j >= 0 and arr[j] > key:
            arr[j + 1] = arr[j]
            j -= 1
        arr[j + 1] = key
    return arr

# 最好情况：数组已经有序
#   内层while循环每次执行0次 → 总共 n-1 次比较 → O(n)
print(insertion_sort([1, 2, 3, 4, 5]))  # 已经有序，很快

# 最坏情况：数组逆序
#   内层while循环执行 1+2+...+(n-1) = n(n-1)/2 次 → O(n²)
print(insertion_sort([5, 4, 3, 2, 1]))  # 完全逆序，很慢

# 平均情况：随机排列 → 约 n²/4 次比较 → O(n²)
```

> **实践建议**：在面试和算法分析中，如果没有特别说明，一般分析的是**最坏情况时间复杂度**。

---

#### 八、复杂度对比

##### 复杂度增长对比表

下表展示了不同复杂度在不同数据规模 n 下的操作次数：

| n | O(1) | O(log n) | O(n) | O(n log n) | O(n²) | O(2ⁿ) |
|---|------|----------|------|------------|-------|-------|
| 1 | 1 | 0 | 1 | 0 | 1 | 2 |
| 10 | 1 | 3 | 10 | 33 | 100 | 1,024 |
| 100 | 1 | 7 | 100 | 664 | 10,000 | 1.3×10³⁰ |
| 1,000 | 1 | 10 | 1,000 | 9,966 | 1,000,000 | 不可想象 |
| 10,000 | 1 | 13 | 10,000 | 132,877 | 100,000,000 | 不可想象 |
| 100,000 | 1 | 17 | 100,000 | 1,660,964 | 10,000,000,000 | 不可想象 |
| 1,000,000 | 1 | 20 | 1,000,000 | 19,931,568 | 10¹² | 不可想象 |

> 假设每秒执行10亿次操作，O(2ⁿ) 在 n=100 时需要约 4×10¹³ 年——比宇宙年龄还长！

##### 增长曲线说明

如果把复杂度画成曲线图（横轴是数据量 n，纵轴是操作次数）：

```
操作次数
  ↑
  |                                          / O(2ⁿ)
  |                                        /
  |                                      /
  |                                    /
  |                                 /
  |                              /
  |                          __/ O(n²)
  |                     ____/
  |                ____/
  |           ____/‾‾‾‾‾‾‾‾‾‾‾‾‾‾ O(n log n)
  |      ____/‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾ O(n)
  |  ___/‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾ O(log n)
  | /‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾ O(1)
  |/_______________________________________________→ 数据量 n
```

##### 复杂度排序（从快到慢）

```
O(1) < O(log n) < O(n) < O(n log n) < O(n²) < O(n³) < O(2ⁿ) < O(n!)
 快 ←——————————————————————————————————————————————————————————————→ 慢
```

```python
# ========== 直观感受不同复杂度的差异 ==========
import time
import math

def demo_o1(n):
    """O(1): 不管n多大，只做一步"""
    return n * (n + 1) // 2

def demo_ologn(n):
    """O(log n): 每次减半"""
    count = 0
    while n > 1:
        n = n // 2
        count += 1
    return count

def demo_on(n):
    """O(n): 遍历一次"""
    return sum(range(n))

def demo_onlogn(n):
    """O(n log n): n次 × 每次log n"""
    total = 0
    for i in range(n):
        j = n
        while j > 0:
            j //= 2
            total += 1
    return total

def demo_on2(n):
    """O(n²): 两层嵌套循环"""
    total = 0
    for i in range(n):
        for j in range(n):
            total += 1
    return total

# 测试不同复杂度在 n=10000 时的表现
n = 10000

functions = [
    ("O(1)", demo_o1),
    ("O(log n)", demo_ologn),
    ("O(n)", demo_on),
    ("O(n log n)", demo_onlogn),
    ("O(n²)", demo_on2),
]

for name, func in functions:
    start = time.time()
    result = func(n)
    elapsed = (time.time() - start) * 1000
    print(f"{name:12s}: {elapsed:.4f} 毫秒")

# 典型输出：
# O(1)        : 0.0001 毫秒
# O(log n)    : 0.0010 毫秒
# O(n)        : 0.2000 毫秒
# O(n log n)  : 8.0000 毫秒
# O(n²)       : 3000.0000 毫秒  ← 明显变慢了！
```

---

#### 九、练习题

请分析以下每段代码的时间复杂度和空间复杂度，然后再看答案。

##### 练习题

**题目1：**
```python
def mystery1(arr):
    total = 0
    for i in range(0, len(arr), 2):  # 步长为2
        total += arr[i]
    return total
```

**题目2：**
```python
def mystery2(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n):
            if i == j:
                print(arr[i], arr[j])
```

**题目3：**
```python
def mystery3(arr):
    n = len(arr)
    result = []
    for i in range(n):
        for j in range(i + 1, n):
            result.append(arr[i] + arr[j])
    return result
```

**题目4：**
```python
def mystery4(n):
    i = 1
    count = 0
    while i <= n:
        count += 1
        i = i * 3    # 注意：每次乘以3，不是乘以2
    return count
```

**题目5：**
```python
def mystery5(arr):
    n = len(arr)
    for i in range(n):          # O(n)
        j = n
        while j > 1:            # O(log n)
            j = j // 2
        print(arr[i])
```

**题目6：**
```python
def mystery6(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n):
            for k in range(n):
                print(arr[i], arr[j], arr[k])
```

---

##### 答案与解析

**题目1答案：时间 O(n)，空间 O(1)**

```python
def mystery1(arr):
    total = 0
    for i in range(0, len(arr), 2):  # 步长为2
        total += arr[i]
    return total
```

解析：
- 虽然步长是2，循环只执行 n/2 次
- 但 O(n/2) = O(n)，忽略常数因子
- 只用了 `total` 一个额外变量 → 空间 O(1)

---

**题目2答案：时间 O(n²)，空间 O(1)**

```python
def mystery2(arr):
    n = len(arr)
    for i in range(n):       # 外层 n 次
        for j in range(n):   # 内层 n 次
            if i == j:
                print(arr[i], arr[j])
```

解析：
- 虽然 `if i == j` 只在 n 次时成立，但**循环本身**仍然执行 n × n = n² 次
- if 条件只是减少了 print 的次数，不改变循环的复杂度
- 没有创建新的数据结构 → 空间 O(1)

---

**题目3答案：时间 O(n²)，空间 O(n²)**

```python
def mystery3(arr):
    n = len(arr)
    result = []
    for i in range(n):
        for j in range(i + 1, n):
            result.append(arr[i] + arr[j])
```

解析：
- 内层循环次数：(n-1) + (n-2) + ... + 1 = n(n-1)/2 → 时间 O(n²)
- result 列表存储了 n(n-1)/2 个元素 → 空间 O(n²)

---

**题目4答案：时间 O(log n)，空间 O(1)**

```python
def mystery4(n):
    i = 1
    count = 0
    while i <= n:
        count += 1
        i = i * 3    # 每次乘以3
    return count
```

解析：
- i 的变化：1, 3, 9, 27, 81, ..., 3^k
- 当 3^k > n 时停止，即 k > log₃(n)
- 所以循环执行 log₃(n) 次 → 时间 O(log n)
- 注意：不管底数是2还是3还是10，log的不同底数之间只差常数倍 → 统一写 O(log n)
- 只有几个变量 → 空间 O(1)

---

**题目5答案：时间 O(n log n)，空间 O(1)**

```python
def mystery5(arr):
    n = len(arr)
    for i in range(n):          # 外层: n次
        j = n
        while j > 1:            # 内层: log₂(n)次
            j = j // 2
        print(arr[i])
```

解析：
- 外层循环 n 次
- 内层 while 循环每次将 j 减半，执行 log₂(n) 次
- 总操作: n × log₂(n) → 时间 O(n log n)
- 没有额外数据结构 → 空间 O(1)

---

**题目6答案：时间 O(n³)，空间 O(1)**

```python
def mystery6(arr):
    n = len(arr)
    for i in range(n):          # 第1层: n次
        for j in range(n):      # 第2层: n次
            for k in range(n):  # 第3层: n次
                print(arr[i], arr[j], arr[k])
```

解析：
- 三层嵌套循环，每层 n 次
- 总操作: n × n × n = n³ → 时间 O(n³)
- 没有额外数据结构 → 空间 O(1)

---

##### 复杂度速查口诀

```
一层循环是 O(n)，
两层嵌套 O(n²) 起，
每次减半 O(log n)，
排序最快 n log n，
指数 O(2ⁿ) 不可取，
常数 O(1) 最神速。
```


### 主题2 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、感受算法效率的差距

```typescript
// ========== 感受算法效率的差距 ==========

// 算法A：逐个查找（线性查找）—— 像"骑自行车"
function linearSearch(arr: number[], target: number): number {
  for (let i = 0; i < arr.length; i++) {
    if (arr[i] === target) return i;
  }
  return -1;
}

// 算法B：二分查找—— 像"坐高铁"
function binarySearch(arr: number[], target: number): number {
  let left = 0, right = arr.length - 1;
  while (left <= right) {
    const mid = Math.floor((left + right) / 2);
    if (arr[mid] === target) return mid;
    else if (arr[mid] < target) left = mid + 1;
    else right = mid - 1;
  }
  return -1;
}

// 测试：在100万个数字中查找
const bigList = Array.from({ length: 1000000 }, (_, i) => i); // [0, 1, ..., 999999]
const target = 999999; // 找最后一个（最坏情况）

let start = Date.now();
linearSearch(bigList, target);
console.log(`线性查找: ${(Date.now() - start)} 毫秒`);

start = Date.now();
binarySearch(bigList, target);
console.log(`二分查找: ${(Date.now() - start)} 毫秒`);

// 典型输出：
// 线性查找: 50.00 毫秒
// 二分查找: 0.002000 毫秒
// 差距达到数万倍！数据量越大，差距越夸张
```

##### 二、大O表示法的核心规则

```typescript
// ========== 大O表示法的核心规则 ==========

// 规则1：忽略常数
// O(3n) → O(n)     O(500) → O(1)
function example1(arr: number[]): void {
  for (const x of arr) console.log(x); // n次
  for (const x of arr) console.log(x); // n次
  for (const x of arr) console.log(x); // n次
}
// 总共 3n 次操作 → 简化为 O(n)

// 规则2：只保留最高阶项
// O(n² + n + 100) → O(n²)

// 规则3：不同输入分别标注
function example2(listA: number[], listB: number[]): void {
  for (const x of listA) console.log(x); // m次
  for (const x of listB) console.log(x); // n次
}
// 复杂度是 O(m + n)，不能简化为 O(n)
```

##### 三、如何计算时间复杂度

```typescript
// ========== 计算时间复杂度示例 ==========

// 示例1：O(1)
function getFirst(arr: number[]): number {
  return arr[0];
}

// 示例2：O(n)
function printAll(arr: number[]): void {
  for (const item of arr) console.log(item); // 执行n次
}

// 示例3：O(n²)
function printPairs(arr: number[]): void {
  for (const i of arr) {
    for (const j of arr) {
      console.log(i, j); // 总共 n × n = n² 次
    }
  }
}

// 示例4：O(n) 不是 O(2n)
function twoPass(arr: number[]): [number, number] {
  let maxVal = arr[0];
  for (const x of arr) if (x > maxVal) maxVal = x;

  let minVal = arr[0];
  for (const x of arr) if (x < minVal) minVal = x;

  return [maxVal, minVal];
}
// 操作次数 = n + n = 2n → 忽略常数 → O(n)
```

##### 四、空间复杂度示例

```typescript
// ========== 空间复杂度示例 ==========

// 示例1：O(1) 空间——只用了固定几个变量
function findSum(arr: number[]): number {
  let total = 0;
  for (const num of arr) total += num;
  return total;
}

// 示例2：O(n) 空间——创建了与输入等大的新数组
function doubleElements(arr: number[]): number[] {
  const result: number[] = [];
  for (const num of arr) result.push(num * 2);
  return result;
}

// 示例3：O(n) 空间——创建了一个 Map
function countFrequency(arr: (string | number)[]): Map<string | number, number> {
  const freq = new Map<string | number, number>();
  for (const item of arr) {
    freq.set(item, (freq.get(item) ?? 0) + 1);
  }
  return freq;
}

// 示例4：O(n²) 空间——创建了二维结构
function createMatrix(n: number): number[][] {
  const matrix: number[][] = [];
  for (let i = 0; i < n; i++) {
    const row = new Array<number>(n).fill(0); // 每行n个元素
    matrix.push(row);
  }
  return matrix;
}
// n行 × n列 = n² 个元素 → O(n²)
```

##### 五、常见复杂度

```typescript
// ========== O(1) 常数时间 ==========

// 示例1：访问数组的某个元素
function getElement(arr: number[], index: number): number {
  return arr[index];
}

// 示例2：判断奇偶
function isEven(n: number): boolean {
  return n % 2 === 0;
}

// 示例3：Map 的查找
function checkStudent(studentMap: Map<string, boolean>, name: string): boolean {
  return studentMap.has(name);
}

// 示例4：固定次数的操作
function constantOperations(arr: number[]): number {
  console.log(arr[0]);
  console.log(arr[arr.length - 1]);
  const x = 1 + 2 + 3;
  return x;
}

// ========== O(log n) 对数时间 ==========

// 经典例子：二分查找
// 每次循环，搜索范围减半：n → n/2 → n/4 → ... → 1
function binarySearch2(arr: number[], target: number): number {
  let left = 0, right = arr.length - 1;
  while (left <= right) {
    const mid = Math.floor((left + right) / 2);
    if (arr[mid] === target) return mid;
    else if (arr[mid] < target) left = mid + 1;
    else right = mid - 1;
  }
  return -1;
}

const sortedList = Array.from({ length: 1024 }, (_, i) => i);
console.log(binarySearch2(sortedList, 500)); // 输出: 500

// 另一个例子：每次将数字减半到1
function halveUntilOne(n: number): number {
  let steps = 0;
  while (n > 1) {
    n = Math.floor(n / 2);
    steps++;
    console.log(`第${steps}步: n = ${n}`);
  }
  return steps;
}

console.log(`总共需要 ${halveUntilOne(64)} 步`);
// 64 → 32 → 16 → 8 → 4 → 2 → 1，共6步  log₂(64) = 6

// ========== O(n) 线性时间 ==========

// 示例1：遍历数组
function printAll2(arr: number[]): void {
  for (const item of arr) console.log(item);
}

// 示例2：线性查找
function linearSearch2(arr: number[], target: number): number {
  for (let i = 0; i < arr.length; i++) {
    if (arr[i] === target) return i;
  }
  return -1;
}

// 示例3：求和
function arraySum(arr: number[]): number {
  let total = 0;
  for (const num of arr) total += num;
  return total;
}

// 示例4：找最大值
function findMax(arr: number[]): number {
  let maxVal = arr[0];
  for (let i = 1; i < arr.length; i++) {
    if (arr[i] > maxVal) maxVal = arr[i];
  }
  return maxVal;
}

// ========== O(n log n) 线性对数时间 ==========

// 经典例子：归并排序
function mergeSort(arr: number[]): number[] {
  if (arr.length <= 1) return arr;

  const mid = Math.floor(arr.length / 2);
  const left = mergeSort(arr.slice(0, mid));  // 递归排序左半部分
  const right = mergeSort(arr.slice(mid));    // 递归排序右半部分
  return merge(left, right);
}

function merge(left: number[], right: number[]): number[] {
  const result: number[] = [];
  let i = 0, j = 0;

  while (i < left.length && j < right.length) {
    if (left[i] <= right[j]) {
      result.push(left[i]);
      i++;
    } else {
      result.push(right[j]);
      j++;
    }
  }
  return [...result, ...left.slice(i), ...right.slice(j)];
}

// 测试
const unsorted = [38, 27, 43, 3, 9, 82, 10];
console.log(`排序结果: ${mergeSort(unsorted)}`);
// 输出: 排序结果: 3,9,10,27,38,43,82

// ========== O(n²) 平方时间 ==========

// 示例1：冒泡排序
function bubbleSort(arr: number[]): number[] {
  const n = arr.length;
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n - i - 1; j++) {
      if (arr[j] > arr[j + 1]) {
        [arr[j], arr[j + 1]] = [arr[j + 1], arr[j]];
      }
    }
  }
  return arr;
}

console.log(bubbleSort([64, 34, 25, 12, 22]));
// 输出: [12, 22, 25, 34, 64]

// 示例2：打印所有数对
function printAllPairs(arr: number[]): void {
  const n = arr.length;
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      console.log(`(${arr[i]}, ${arr[j]})`);
    }
  }
}

// 示例3：选择排序
function selectionSort(arr: number[]): number[] {
  const n = arr.length;
  for (let i = 0; i < n; i++) {
    let minIdx = i;
    for (let j = i + 1; j < n; j++) {
      if (arr[j] < arr[minIdx]) minIdx = j;
    }
    [arr[i], arr[minIdx]] = [arr[minIdx], arr[i]];
  }
  return arr;
}

console.log(selectionSort([64, 34, 25, 12, 22]));
// 输出: [12, 22, 25, 34, 64]

// ========== O(2ⁿ) 指数时间 ==========

// 经典例子：递归计算斐波那契数列（最朴素的写法）
function fib(n: number): number {
  if (n <= 1) return n;
  return fib(n - 1) + fib(n - 2);
}
// 每次调用产生2个新的调用 → 调用次数呈指数增长 → O(2ⁿ)

// 对比：优化后的写法（动态规划），O(n)
function fibFast(n: number): number {
  if (n <= 1) return n;
  let prev = 0, curr = 1;
  for (let i = 2; i <= n; i++) {
    [prev, curr] = [curr, prev + curr]; // 滚动计算
  }
  return curr;
}

console.log(`fibFast(100) = ${fibFast(100)}`); // 瞬间完成！
```

##### 六、嵌套循环复杂度分析

```typescript
// ========== 嵌套循环复杂度分析 ==========

// --- 类型1：内外层独立，都是n ---  O(n × n) = O(n²)
function type1(n: number): void {
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      console.log(i, j);
    }
  }
}

// --- 类型2：内层递减 ---  O(n²)
function type2(n: number): void {
  for (let i = 0; i < n; i++) {
    for (let j = i; j < n; j++) {
      console.log(i, j);
    }
  }
}
// 总操作: n + (n-1) + ... + 1 = n(n+1)/2 → O(n²)

// --- 类型3：内外层不同规模 ---  O(m × n)
function type3(listA: number[], listB: number[]): void {
  for (const a of listA) {
    for (const b of listB) {
      console.log(a, b);
    }
  }
}

// --- 类型4：三层嵌套 ---  O(n³)
function type4(n: number): void {
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      for (let k = 0; k < n; k++) {
        console.log(i, j, k);
      }
    }
  }
}

// --- 类型5：嵌套但内层是对数级别 ---  O(n log n)
function type5(n: number): void {
  for (let i = 0; i < n; i++) {
    let j = n;
    while (j > 1) {
      j = Math.floor(j / 2);
      console.log(i, j);
    }
  }
}

// --- 类型6：看似嵌套，实际不是 ---  O(n)
function type6(n: number): void {
  for (let i = 0; i < n; i++) console.log(i);
  for (let j = 0; j < n; j++) console.log(j);
}
// 总操作: n + n = 2n → O(n)

// ========== 常见陷阱 ==========

// 陷阱1：内层循环的规模取决于外层变量 → O(n²)
function trap1(n: number): void {
  for (let i = 1; i <= n; i++) {
    for (let j = 1; j <= i; j++) {
      console.log(i, j);
    }
  }
}
// 内层次数: 1 + 2 + ... + n = n(n+1)/2 → O(n²)

// 陷阱2：看似三层嵌套 → 内层while是 O(log j)，总体约 O(n² log n)
function trap2(n: number): void {
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      let k = j;
      while (k > 0) {
        k = Math.floor(k / 2);
        console.log(i, j, k);
      }
    }
  }
}

// 陷阱3：循环变量步长不为1 → O(log n) 不是 O(n)
function trap3(n: number): void {
  let i = 1;
  while (i < n) {
    i = i * 2;  // 每次翻倍：1, 2, 4, 8, 16, ...
    console.log(i);
  }
}
```

##### 七、最好/最坏/平均情况分析

```typescript
// ========== 最好/最坏/平均情况分析 ==========

function linearSearch3(arr: number[], target: number): number {
  for (let i = 0; i < arr.length; i++) {
    if (arr[i] === target) return i;
  }
  return -1;
}

// 假设 arr = [3, 1, 4, 1, 5, 9, 2, 6]，target = 5
// 最好情况：target在第一个位置 → 1次比较 → O(1)
// 最坏情况：target在最后一个位置或不存在 → n次比较 → O(n)
// 平均情况：target在中间某处 → n/2次比较 → O(n)

// ========== 更好的例子：插入排序 ==========
function insertionSort(arr: number[]): number[] {
  for (let i = 1; i < arr.length; i++) {
    const key = arr[i];
    let j = i - 1;
    // 将比key大的元素向后移
    while (j >= 0 && arr[j] > key) {
      arr[j + 1] = arr[j];
      j--;
    }
    arr[j + 1] = key;
  }
  return arr;
}

// 最好情况：数组已经有序 → O(n)
console.log(insertionSort([1, 2, 3, 4, 5]));
// 最坏情况：数组逆序 → O(n²)
console.log(insertionSort([5, 4, 3, 2, 1]));
// 平均情况：随机排列 → O(n²)
```

##### 八、直观感受不同复杂度的差异

```typescript
// ========== 直观感受不同复杂度的差异 ==========

function demoO1(n: number): number {
  return Math.floor(n * (n + 1) / 2);  // O(1): 不管n多大，只做一步
}

function demoOlogn(n: number): number {
  let count = 0;
  while (n > 1) { n = Math.floor(n / 2); count++; }  // O(log n): 每次减半
  return count;
}

function demoOn(n: number): number {
  let sum = 0;
  for (let i = 0; i < n; i++) sum += i;  // O(n): 遍历一次
  return sum;
}

function demoOnlogn(n: number): number {
  let total = 0;
  for (let i = 0; i < n; i++) {  // n次 × 每次log n
    let j = n;
    while (j > 0) { j = Math.floor(j / 2); total++; }
  }
  return total;
}

function demoOn2(n: number): number {
  let total = 0;
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) total++;  // O(n²): 两层嵌套循环
  }
  return total;
}

// 测试不同复杂度在 n=10000 时的表现
const n = 10000;
const functions: [string, (n: number) => number][] = [
  ["O(1)", demoO1],
  ["O(log n)", demoOlogn],
  ["O(n)", demoOn],
  ["O(n log n)", demoOnlogn],
  ["O(n²)", demoOn2],
];

for (const [name, func] of functions) {
  const start = Date.now();
  func(n);
  console.log(`${name.padEnd(12)}: ${(Date.now() - start)} 毫秒`);
}
// 典型输出：
// O(1)        : 0 毫秒
// O(log n)    : 0 毫秒
// O(n)        : 0 毫秒
// O(n log n)  : 1 毫秒
// O(n²)       : 120 毫秒  ← 明显变慢了！
```

### 主题2 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、感受算法效率的差距

```go
package main

import (
	"fmt"
	"time"
)

// 算法A：逐个查找（线性查找）—— 像"骑自行车"
func linearSearch(arr []int, target int) int {
	for i := 0; i < len(arr); i++ {
		if arr[i] == target {
			return i
		}
	}
	return -1
}

// 算法B：二分查找—— 像"坐高铁"
func binarySearch(arr []int, target int) int {
	left, right := 0, len(arr)-1
	for left <= right {
		mid := (left + right) / 2
		if arr[mid] == target {
			return mid
		} else if arr[mid] < target {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	return -1
}

func main() {
	// 测试：在100万个数字中查找
	bigList := make([]int, 1000000) // [0, 1, ..., 999999]
	for i := range bigList {
		bigList[i] = i
	}
	target := 999999 // 找最后一个（最坏情况）

	start := time.Now()
	linearSearch(bigList, target)
	fmt.Printf("线性查找: %.2f 毫秒\n", float64(time.Since(start).Microseconds())/1000)

	start = time.Now()
	binarySearch(bigList, target)
	fmt.Printf("二分查找: %.6f 毫秒\n", float64(time.Since(start).Microseconds())/1000)

	// 典型输出：
	// 线性查找: 50.00 毫秒
	// 二分查找: 0.002000 毫秒
	// 差距达到数万倍！数据量越大，差距越夸张
}
```

##### 二、大O表示法的核心规则

```go
package main

import "fmt"

// 规则1：忽略常数  O(3n) → O(n)    O(500) → O(1)
func example1(arr []int) {
	for _, x := range arr { // n次
		fmt.Println(x)
	}
	for _, x := range arr { // n次
		fmt.Println(x)
	}
	for _, x := range arr { // n次
		fmt.Println(x)
	}
}
// 总共 3n 次操作 → 简化为 O(n)

// 规则2：只保留最高阶项  O(n² + n + 100) → O(n²)

// 规则3：不同输入分别标注
func example2(listA, listB []int) {
	for _, x := range listA { // m次
		fmt.Println(x)
	}
	for _, x := range listB { // n次
		fmt.Println(x)
	}
}
// 复杂度是 O(m + n)，不能简化为 O(n)
```

##### 三、如何计算时间复杂度

```go
package main

import "fmt"

// 示例1：O(1)
func getFirst(arr []int) int {
	return arr[0]
}

// 示例2：O(n)
func printAll(arr []int) {
	for _, item := range arr { // 执行n次
		fmt.Println(item)
	}
}

// 示例3：O(n²)
func printPairs(arr []int) {
	for _, i := range arr { // 外层n次
		for _, j := range arr { // 内层n次
			fmt.Println(i, j) // 总共 n × n = n² 次
		}
	}
}

// 示例4：O(n) 不是 O(2n)
func twoPass(arr []int) (int, int) {
	maxVal := arr[0]
	for _, x := range arr {
		if x > maxVal {
			maxVal = x
		}
	}

	minVal := arr[0]
	for _, x := range arr {
		if x < minVal {
			minVal = x
		}
	}
	return maxVal, minVal
}
// 操作次数 = n + n = 2n → 忽略常数 → O(n)
```

##### 四、空间复杂度示例

```go
package main

// 示例1：O(1) 空间——只用了固定几个变量
func findSum(arr []int) int {
	total := 0
	for _, num := range arr {
		total += num
	}
	return total
}
// 不管arr有10个还是100万个元素，额外空间就是一个变量 → O(1)

// 示例2：O(n) 空间——创建了与输入等大的新切片
func doubleElements(arr []int) []int {
	result := make([]int, 0, len(arr)) // 新建一个切片
	for _, num := range arr {
		result = append(result, num*2)
	}
	return result
}
// arr有n个元素，result也有n个元素 → 额外空间 O(n)

// 示例3：O(n) 空间——创建了一个 map
func countFrequency(arr []int) map[int]int {
	freq := make(map[int]int) // 新建一个 map
	for _, item := range arr {
		freq[item]++
	}
	return freq
}
// 最坏情况下（所有元素不同），map有n个键值对 → O(n)

// 示例4：O(n²) 空间——创建了二维结构
func createMatrix(n int) [][]int {
	matrix := make([][]int, n)
	for i := range matrix {
		row := make([]int, n) // 每行n个元素
		matrix[i] = row
	}
	return matrix
}
// n行 × n列 = n² 个元素 → O(n²)
```

##### 五、常见复杂度

```go
package main

import "fmt"

// ========== O(1) 常数时间 ==========

// 示例1：访问切片的某个元素
func getElement(arr []int, index int) int {
	return arr[index]
}

// 示例2：判断奇偶
func isEven(n int) bool {
	return n%2 == 0
}

// 示例3：map 的查找
func checkStudent(studentMap map[string]bool, name string) bool {
	_, ok := studentMap[name]
	return ok
}

// 示例4：固定次数的操作
func constantOperations(arr []int) int {
	fmt.Println(arr[0])
	fmt.Println(arr[len(arr)-1])
	x := 1 + 2 + 3
	return x
}

// ========== O(log n) 对数时间 ==========

// 经典例子：二分查找
// 每次循环，搜索范围减半：n → n/2 → n/4 → ... → 1
func binarySearch2(arr []int, target int) int {
	left, right := 0, len(arr)-1
	for left <= right {
		mid := (left + right) / 2 // 取中间位置
		if arr[mid] == target {
			return mid // 找到了
		} else if arr[mid] < target {
			left = mid + 1 // 目标在右半部分
		} else {
			right = mid - 1 // 目标在左半部分
		}
	}
	return -1
}

func halveUntilOne(n int) int {
	steps := 0
	for n > 1 {
		n = n / 2
		steps++
		fmt.Printf("第%d步: n = %d\n", steps, n)
	}
	return steps
}

// ========== O(n) 线性时间 ==========

// 示例1：遍历切片
func printAll2(arr []int) {
	for _, item := range arr {
		fmt.Println(item)
	}
}

// 示例2：线性查找
func linearSearch2(arr []int, target int) int {
	for i := 0; i < len(arr); i++ {
		if arr[i] == target {
			return i
		}
	}
	return -1
}

// 示例3：求和
func arraySum(arr []int) int {
	total := 0
	for _, num := range arr {
		total += num
	}
	return total
}

// 示例4：找最大值
func findMax(arr []int) int {
	maxVal := arr[0]
	for _, item := range arr[1:] {
		if item > maxVal {
			maxVal = item
		}
	}
	return maxVal
}

// ========== O(n log n) 线性对数时间 ==========

// 经典例子：归并排序
func mergeSort(arr []int) []int {
	// 基本情况：长度为0或1的切片天然有序
	if len(arr) <= 1 {
		return arr
	}

	// 分成两半
	mid := len(arr) / 2
	left := mergeSort(arr[:mid])  // 递归排序左半部分
	right := mergeSort(arr[mid:]) // 递归排序右半部分

	// 合并两个有序切片
	return merge(left, right)
}

func merge(left, right []int) []int {
	result := make([]int, 0, len(left)+len(right))
	i, j := 0, 0

	// 比较两个切片的元素，从小到大放入result
	for i < len(left) && j < len(right) {
		if left[i] <= right[j] {
			result = append(result, left[i])
			i++
		} else {
			result = append(result, right[j])
			j++
		}
	}

	// 把剩余的元素追加到末尾
	result = append(result, left[i:]...)
	result = append(result, right[j:]...)
	return result
}

// ========== O(n²) 平方时间 ==========

// 示例1：冒泡排序
func bubbleSort(arr []int) []int {
	n := len(arr)
	for i := 0; i < n; i++ { // 外层循环 n 次
		for j := 0; j < n-i-1; j++ { // 内层循环约 n 次
			if arr[j] > arr[j+1] {
				arr[j], arr[j+1] = arr[j+1], arr[j]
			}
		}
	}
	return arr
}
// 两层嵌套循环，每层约n次 → n × n = n² → O(n²)

// 示例2：打印所有数对
func printAllPairs(arr []int) {
	n := len(arr)
	for i := 0; i < n; i++ { // 外层 n 次
		for j := 0; j < n; j++ { // 内层 n 次
			fmt.Printf("(%d, %d)\n", arr[i], arr[j])
		}
	}
}
// n × n = n² 次操作 → O(n²)

// 示例3：选择排序
func selectionSort(arr []int) []int {
	n := len(arr)
	for i := 0; i < n; i++ {
		minIdx := i
		for j := i + 1; j < n; j++ { // 内层循环递减
			if arr[j] < arr[minIdx] {
				minIdx = j
			}
		}
		arr[i], arr[minIdx] = arr[minIdx], arr[i]
	}
	return arr
}
// n(n-1)/2 = n²/2 - n/2，忽略常数和低阶项 → O(n²)

// ========== O(2ⁿ) 指数时间 ==========

// 经典例子：递归计算斐波那契数列（最朴素的写法）
func fib(n int) int {
	// 斐波那契数列: 1, 1, 2, 3, 5, 8, 13, 21, ...
	if n <= 1 {
		return n
	}
	return fib(n-1) + fib(n-2)
}
// 每次调用产生2个新的调用 → 调用次数呈指数增长 → O(2ⁿ)

// 对比：优化后的写法（动态规划），O(n)
func fibFast(n int) int {
	if n <= 1 {
		return n
	}
	prev, curr := 0, 1
	for i := 2; i <= n; i++ {
		prev, curr = curr, prev+curr // 滚动计算
	}
	return curr
}
```

##### 六、嵌套循环复杂度分析

```go
package main

import "fmt"

// --- 类型1：内外层独立，都是n ---  O(n × n) = O(n²)
func type1(n int) {
	for i := 0; i < n; i++ { // 外层: n次
		for j := 0; j < n; j++ { // 内层: n次（与i无关）
			fmt.Println(i, j)
		}
	}
}

// --- 类型2：内层递减 ---  O(n²)
func type2(n int) {
	for i := 0; i < n; i++ { // 外层: n次
		for j := i; j < n; j++ { // 内层: n-i次
			fmt.Println(i, j)
		}
	}
}
// 总操作: n + (n-1) + ... + 1 = n(n+1)/2 → O(n²)

// --- 类型3：内外层不同规模 ---  O(m × n)
func type3(listA, listB []int) {
	for _, a := range listA { // 外层: m次
		for _, b := range listB { // 内层: n次
			fmt.Println(a, b)
		}
	}
}

// --- 类型4：三层嵌套 ---  O(n³)
func type4(n int) {
	for i := 0; i < n; i++ { // 外层: n次
		for j := 0; j < n; j++ { // 中层: n次
			for k := 0; k < n; k++ { // 内层: n次
				fmt.Println(i, j, k)
			}
		}
	}
}

// --- 类型5：嵌套但内层是对数级别 ---  O(n log n)
func type5(n int) {
	for i := 0; i < n; i++ { // 外层: n次
		j := n
		for j > 1 { // 内层: log₂(n)次（每次减半）
			j = j / 2
			fmt.Println(i, j)
		}
	}
}

// --- 类型6：看似嵌套，实际不是 ---  O(n)
func type6(n int) {
	for i := 0; i < n; i++ { // 外层: n次
		fmt.Println(i)
	}
	for j := 0; j < n; j++ { // 这层不是嵌套的！是顺序的！
		fmt.Println(j)
	}
}
// 总操作: n + n = 2n → O(n)

// ========== 常见陷阱 ==========

// 陷阱1：内层循环的规模取决于外层变量 → O(n²)
func trap1(n int) {
	for i := 1; i <= n; i++ { // i = 1, 2, 3, ..., n
		for j := 1; j <= i; j++ { // j = 1, 2, ..., i
			fmt.Println(i, j)
		}
	}
}
// 内层次数: 1 + 2 + 3 + ... + n = n(n+1)/2 → O(n²)

// 陷阱2：看似三层嵌套 → 内层while是 O(log j)，总体约 O(n² log n)
func trap2(n int) {
	for i := 0; i < n; i++ { // n次
		for j := 0; j < n; j++ { // n次
			k := j // 注意：k不是独立的循环变量
			for k > 0 { // 内层while是 O(log j)
				k = k / 2
				fmt.Println(i, j, k)
			}
		}
	}
}

// 陷阱3：循环变量步长不为1 → O(log n) 不是 O(n)
func trap3(n int) {
	i := 1
	for i < n {
		i = i * 2 // 每次翻倍：1, 2, 4, 8, 16, ...
		fmt.Println(i)
	}
}
// i 按指数增长，到达 n 只需要 log₂(n) 步
```

##### 七、最好/最坏/平均情况分析

```go
package main

import "fmt"

func linearSearch3(arr []int, target int) int {
	for i := 0; i < len(arr); i++ {
		if arr[i] == target {
			return i
		}
	}
	return -1
}

// 假设 arr = [3, 1, 4, 1, 5, 9, 2, 6]，target = 5
// 最好情况：target在第一个位置 → 1次比较 → O(1)
// 最坏情况：target在最后一个位置或不存在 → n次比较 → O(n)
// 平均情况：target在中间某处 → n/2次比较 → O(n)

// ========== 更好的例子：插入排序 ==========
func insertionSort(arr []int) []int {
	for i := 1; i < len(arr); i++ {
		key := arr[i]
		j := i - 1
		// 将比key大的元素向后移
		for j >= 0 && arr[j] > key {
			arr[j+1] = arr[j]
			j--
		}
		arr[j+1] = key
	}
	return arr
}

// 最好情况：数组已经有序 → O(n)
// 最坏情况：数组逆序 → O(n²)
// 平均情况：随机排列 → O(n²)
```

##### 八、直观感受不同复杂度的差异

```go
package main

import (
	"fmt"
	"time"
)

func demoO1(n int) int {
	return n * (n + 1) / 2 // O(1): 不管n多大，只做一步
}

func demoOlogn(n int) int {
	count := 0
	for n > 1 { // O(log n): 每次减半
		n = n / 2
		count++
	}
	return count
}

func demoOn(n int) int {
	sum := 0
	for i := 0; i < n; i++ { // O(n): 遍历一次
		sum += i
	}
	return sum
}

func demoOnlogn(n int) int {
	total := 0
	for i := 0; i < n; i++ { // n次 × 每次log n
		j := n
		for j > 0 {
			j /= 2
			total++
		}
	}
	return total
}

func demoOn2(n int) int {
	total := 0
	for i := 0; i < n; i++ {
		for j := 0; j < n; j++ { // O(n²): 两层嵌套循环
			total++
		}
	}
	return total
}

func main() {
	// 测试不同复杂度在 n=10000 时的表现
	n := 10000
	funcs := []struct {
		name string
		fn   func(int) int
	}{
		{"O(1)", demoO1},
		{"O(log n)", demoOlogn},
		{"O(n)", demoOn},
		{"O(n log n)", demoOnlogn},
		{"O(n²)", demoOn2},
	}

	for _, f := range funcs {
		start := time.Now()
		f.fn(n)
		fmt.Printf("%-12s: %.4f 毫秒\n", f.name, float64(time.Since(start).Microseconds())/1000)
	}

	// 典型输出：
	// O(1)        : 0.0001 毫秒
	// O(log n)    : 0.0010 毫秒
	// O(n)        : 0.2000 毫秒
	// O(n log n)  : 8.0000 毫秒
	// O(n²)       : 3000.0000 毫秒  ← 明显变慢了！
}
```

---

## 第二阶段：基础数据结构

### 主题3：数组（Array）


#### 一、数组的概念

##### 什么是数组？

想象一下**一排连续的电影院座位**：

```
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│ 0号 │ 1号 │ 2号 │ 3号 │ 4号 │ 5号 │ 6号 │
│ 座位│ 座位│ 座位│ 座位│ 座位│ 座位│ 座位│
└─────┴─────┴─────┴─────┴─────┴─────┴─────┘
```

- 每个座位都有**编号**（下标/索引），从 0 开始
- 每个座位上都**坐了一个人**（存储了一个数据元素）
- 只要你知道座位号，就能**直接找到**那个人——不需要从第1个座位开始问

数组就是这样的数据结构：**一组连续存储的数据，每个数据都有一个下标，通过下标可以直接访问**。

##### 数组的三大特征

| 特征 | 说明 | 类比 |
|------|------|------|
| **连续性** | 数据在内存中连续存放 | 电影院座位一排挨着 |
| **同类型** | 所有元素类型相同 | 每个座位都是标准尺寸 |
| **固定大小**（静态数组） | 创建时确定容量 | 一排只有固定数量的座位 |

---

#### 二、数组在内存中的存储方式

##### 连续内存空间

假设我们有一个数组 `arr = [10, 20, 30, 40, 50]`，它在内存中的存储方式如下：

```
内存地址（示意）
───────────────────────────────────────────────────────
  1000    1004    1008    1012    1016    1020    1024
┌───────┬───────┬───────┬───────┬───────┬───────┬───────┐
│  10   │  20   │  30   │  40   │  50   │  ?    │  ?    │
│arr[0] │arr[1] │arr[2] │arr[3] │arr[4] │       │       │
└───────┴───────┴───────┴───────┴───────┴───────┴───────┘
  ↑
  基地址(base_address) = 1000
```

**关键点**：
- 每个整数占 4 个字节（所以地址每次 +4）
- 元素之间**没有空隙**，紧密排列
- 知道了起始地址，就能算出任何元素的位置

---

#### 三、通过下标访问的原理：为什么是 O(1)？

##### 地址计算公式

当你写 `arr[3]` 时，计算机内部做了什么？

```
目标地址 = 基地址 + 下标 × 每个元素的大小

arr[3] 的地址 = 1000 + 3 × 4 = 1012
```

**这就是为什么数组的随机访问是 O(1) 的原因！**

计算机只需要做一次乘法和一次加法，就能直接定位到目标元素，**不需要从头遍历**。

```python
# 演示：数组的随机访问
arr = [10, 20, 30, 40, 50]

# 无论访问哪个元素，都是 O(1) 的时间
print(arr[0])    # 直接定位 → 10
print(arr[2])    # 直接定位 → 30
print(arr[4])    # 直接定位 → 50
# 访问第1个和访问第10000个，速度一样快！
```

##### 为什么叫"随机访问"？

"随机"不是"随便"的意思，而是指**可以任意选择访问哪个元素**，不需要按顺序来。就像你知道朋友的座位号是5排3座，你可以直接走过去，不用从1排1座开始找。

---

#### 四、Python 中的 list 就是动态数组

在 Python 中，`list` 并不是传统意义上的"静态数组"，而是**动态数组**：

```python
# Python 的 list 是动态数组
arr = [1, 2, 3]       # 初始3个元素
arr.append(4)          # 可以追加，自动扩容
arr.append(5)          # 继续追加
print(arr)             # [1, 2, 3, 4, 5]

# 它甚至可以混合类型（但不推荐，失去了数组的意义）
mixed = [1, "hello", 3.14, True]
```

> **注意**：Python 的 list 存储的其实是一组**指针**（引用），指向堆中的对象。所以它可以混合类型，但访问效率比 C 语言的数组略低。不过在算法学习中，我们仍然把它当作数组来用。

---

#### 五、基本操作及 Python 实现

##### 1. 遍历数组

```python
def traverse(arr):
    """遍历数组：逐个访问每个元素"""
    # 方式一：通过下标遍历（需要用到下标时用这种）
    for i in range(len(arr)):
        print(f"arr[{i}] = {arr[i]}")

    # 方式二：直接遍历元素（不需要下标时用这种，更 Pythonic）
    for val in arr:
        print(val)

    # 方式三：同时需要下标和值（用 enumerate）
    for i, val in enumerate(arr):
        print(f"下标 {i} 的值是 {val}")

# 测试
arr = [10, 20, 30, 40, 50]
traverse(arr)
```

**复杂度**：遍历需要访问每个元素一次，时间复杂度 **O(n)**。

##### 2. 在指定位置插入元素（手动实现）

```python
def insert_at(arr, index, value):
    """
    在数组的 index 位置插入 value
    手动实现：把 index 及之后的元素都往后挪一位
    
    类比：一排坐满人的座位，要在第3个位置插入一个人，
    那第3个位置及之后的人都要往后挪一个座位
    """
    n = len(arr)

    # 第一步：检查下标是否合法
    if index < 0 or index > n:
        raise IndexError("插入位置不合法")

    # 第二步：在末尾添加一个占位元素（扩容一位）
    arr.append(0)  # 现在长度变成 n+1

    # 第三步：从后往前，逐个元素往后移动
    # 注意：必须从后往前移！如果从前往后移，会覆盖掉后面的元素
    for i in range(n, index, -1):
        arr[i] = arr[i - 1]
    #    移动过程示意（在 index=2 处插入 99）：
    #    原始：[10, 20, 30, 40, 50, 0]
    #    i=5:  arr[5] = arr[4] → [10, 20, 30, 40, 50, 50]
    #    i=4:  arr[4] = arr[3] → [10, 20, 30, 40, 40, 50]
    #    i=3:  arr[3] = arr[2] → [10, 20, 30, 30, 40, 50]

    # 第四步：把目标位置放上新的值
    arr[index] = value
    #    最终：[10, 20, 99, 30, 40, 50]

# 测试
arr = [10, 20, 30, 40, 50]
insert_at(arr, 2, 99)
print(arr)  # [10, 20, 99, 30, 40, 50]
```

**复杂度分析**：
- **最好情况**：在末尾插入，不需要移动任何元素 → **O(1)**
- **最坏情况**：在开头插入，所有元素都要后移 → **O(n)**
- **平均情况**：平均需要移动 n/2 个元素 → **O(n)**

##### 3. 删除指定位置的元素（手动实现）

```python
def delete_at(arr, index):
    """
    删除数组中 index 位置的元素
    手动实现：把 index 之后的元素都往前挪一位
    
    类比：第3个位置的人走了，后面的人都要往前挪一个座位
    """
    n = len(arr)

    # 第一步：检查下标是否合法
    if index < 0 or index >= n:
        raise IndexError("删除位置不合法")

    # 保存被删除的值（可选，看是否需要返回）
    removed = arr[index]

    # 第二步：从前往后，逐个元素往前移动
    for i in range(index, n - 1):
        arr[i] = arr[i + 1]
    #    移动过程示意（删除 index=2 的元素）：
    #    原始：[10, 20, 99, 30, 40, 50]
    #    i=2:  arr[2] = arr[3] → [10, 20, 30, 30, 40, 50]
    #    i=3:  arr[3] = arr[4] → [10, 20, 30, 40, 40, 50]
    #    i=4:  arr[4] = arr[5] → [10, 20, 30, 40, 50, 50]

    # 第三步：移除末尾多余的元素
    arr.pop()
    #    最终：[10, 20, 30, 40, 50]

    return removed

# 测试
arr = [10, 20, 99, 30, 40, 50]
removed = delete_at(arr, 2)
print(f"删除了: {removed}")  # 删除了: 99
print(f"删除后: {arr}")      # [10, 20, 30, 40, 50]
```

**复杂度分析**：
- **最好情况**：删除末尾元素 → **O(1)**
- **最坏情况**：删除开头元素，所有元素都要前移 → **O(n)**
- **平均情况**：**O(n)**

##### 4. 查找元素

```python
def linear_search(arr, target):
    """
    线性查找：从头到尾逐个比较，找到目标返回下标，找不到返回 -1
    
    类比：在一排座位中找某个人，只能一个一个问"你是张三吗？"
    """
    for i in range(len(arr)):
        if arr[i] == target:
            return i      # 找到了，返回下标
    return -1             # 没找到

# 测试
arr = [10, 20, 30, 40, 50]
print(linear_search(arr, 30))   # 2
print(linear_search(arr, 99))   # -1
```

**复杂度**：
- **最好情况**：第一个就是 → **O(1)**
- **最坏情况**：最后一个或不存在 → **O(n)**
- **平均情况**：**O(n)**

> **补充**：如果数组是**有序的**，可以用**二分查找**把查找复杂度降到 **O(log n)**，后面会学到。

---

#### 六、动态数组的扩容机制

##### 用"搬家"来类比

想象你租了一个房子（数组），一开始只有 4 个座位（容量为 4）。

```
容量=4，已用=3
┌─────┬─────┬─────┬─────┬
│  A  │  B  │  C  │     │
└─────┴─────┴─────┴─────┴
```

当第 4 个人来了，房子满了：

```
容量=4，已用=4 → 满了！要扩容！
┌─────┬─────┬─────┬─────┐
│  A  │  B  │  C  │  D  │
└─────┴─────┴─────┴─────┘
```

怎么办？**搬家！** 找一个容量更大的房子（比如容量 8），把所有东西搬过去：

```
搬家后：容量=8，已用=4
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬
│  A  │  B  │  C  │  D  │     │     │     │     │
└─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
```

##### 倍增策略

大多数语言（Python、Java 等）的动态数组采用**倍增策略**：当容量不够时，新容量 = 旧容量 × 2。

```python
# 模拟动态数组的扩容过程
class DynamicArray:
    def __init__(self):
        self.capacity = 4       # 初始容量
        self.size = 0           # 当前元素个数
        self.data = [None] * self.capacity  # 底层数组

    def append(self, value):
        """添加元素，必要时扩容"""
        if self.size == self.capacity:
            # 容量满了，需要扩容！
            old_capacity = self.capacity
            self.capacity *= 2  # 容量翻倍
            print(f"扩容！{old_capacity} → {self.capacity}")

            # 创建新的更大的数组
            new_data = [None] * self.capacity

            # 把旧数据搬过来（这就是"搬家"的开销）
            for i in range(self.size):
                new_data[i] = self.data[i]

            self.data = new_data

        # 放入新元素
        self.data[self.size] = value
        self.size += 1

# 测试：观察扩容过程
da = DynamicArray()
for i in range(10):
    da.append(i)
    print(f"  添加了 {i}，当前容量={da.capacity}，元素数={da.size}")
```

输出：
```
扩容！4 → 8
  添加了 0，当前容量=8，元素数=1
  ...
  添加了 6，当前容量=8，元素数=7
扩容！8 → 16
  添加了 7，当前容量=16，元素数=8
  ...
```

##### 均摊复杂度 O(1)

扩容看起来很耗时（要搬所有元素），但关键是：**扩容是很少发生的！**

```
操作次数    是否扩容    扩容代价
  1          否          0
  2          否          0
  3          否          0
  4          否          0
  5          是(4→8)     4
  6          否          0
  7          否          0
  8          否          0
  9          是(8→16)    8
  ...
```

把扩容的代价**均摊**到每次操作上：
- n 次 append 操作，总共搬家的次数 = 1 + 2 + 4 + 8 + ... + n/2 ≈ n
- 所以每次操作的**均摊代价** = (n + n) / n = **O(1)**

> **通俗理解**：虽然偶尔要"搬一次家"（代价大），但搬完一次后很长一段时间都不用再搬了。把搬家的成本分摊到每次操作中，平均下来每次还是 O(1)。

---

#### 七、二维数组与矩阵

##### 什么是二维数组？

二维数组就是"数组的数组"——想象电影院的**多排座位**：

```python
# 二维数组的创建
# 方式一：直接定义
matrix = [
    [1, 2, 3],    # 第0行
    [4, 5, 6],    # 第1行
    [7, 8, 9]     # 第2行
]

# 方式二：创建 m×n 的零矩阵
rows, cols = 3, 4
matrix2 = [[0] * cols for _ in range(rows)]
print(matrix2)
# [[0, 0, 0, 0],
#  [0, 0, 0, 0],
#  [0, 0, 0, 0]]
```

##### 访问二维数组的元素

```python
matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]

# 访问：matrix[行][列]
print(matrix[0][0])   # 1  （第0行第0列）
print(matrix[1][2])   # 6  （第1行第2列）
print(matrix[2][1])   # 8  （第2行第1列）
```

##### 遍历二维数组

```python
def traverse_matrix(matrix):
    """遍历二维数组的每个元素"""
    rows = len(matrix)
    cols = len(matrix[0]) if rows > 0 else 0

    for i in range(rows):           # 外层循环：遍历每一行
        for j in range(cols):       # 内层循环：遍历该行的每一列
            print(f"matrix[{i}][{j}] = {matrix[i][j]}")

matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
traverse_matrix(matrix)
```

##### 内存中的存储

二维数组在内存中仍然是**一维连续存储**的，只是我们逻辑上把它看成二维：

```
逻辑上：              内存中（行优先存储）：
┌───┬───┬───┐        ┌───┬───┬───┬───┬───┬───┬───┬───┬───┐
│ 1 │ 2 │ 3 │        │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │ 8 │ 9 │
├───┼───┼───┤        └───┴───┴───┴───┴───┴───┴───┴───┴───┘
│ 4 │ 5 │ 6 │
├───┼───┼───┤
│ 7 │ 8 │ 9 │
└───┴───┴───┘
```

> **注意**：Python 中 `[[0] * cols] * rows` 的写法会创建**引用同一个列表**的陷阱！一定要用 `[[0] * cols for _ in range(rows)]`。

```python
# 错误示范！
bad = [[0] * 3] * 2
bad[0][0] = 1
print(bad)  # [[1, 0, 0], [1, 0, 0]]  ← 两行都被修改了！

# 正确写法
good = [[0] * 3 for _ in range(2)]
good[0][0] = 1
print(good)  # [[1, 0, 0], [0, 0, 0]]  ← 只有第一行被修改
```

---

#### 八、经典例题

##### 例题1：移动零（LeetCode 283）

**题目**：给定数组 `nums`，将所有 `0` 移动到数组末尾，同时保持非零元素的相对顺序。要求**原地**操作。

**思路**：用双指针。一个指针 `slow` 记录下一个非零元素应该放的位置，另一个指针 `fast` 遍历数组。

```python
def moveZeroes(nums):
    """
    移动零：把所有0移到数组末尾，保持非零元素顺序不变
    
    思路：
    - slow 指针指向"下一个非零元素该放的位置"
    - fast 指针遍历整个数组
    - 遇到非零元素，就和 slow 位置交换，slow 前进一步
    
    类比：一队人排队，0号是"空位"，非0号是"真人"。
    slow 负责把真人往前排，0号自然就被挤到后面了。
    """
    slow = 0  # slow 指向下一个非零元素应该放的位置

    for fast in range(len(nums)):
        if nums[fast] != 0:
            # 遇到非零元素，交换到 slow 位置
            nums[slow], nums[fast] = nums[fast], nums[slow]
            slow += 1  # slow 前进一步

    # 时间复杂度：O(n)，遍历一次
    # 空间复杂度：O(1)，原地操作

# 测试
nums = [0, 1, 0, 3, 12]
moveZeroes(nums)
print(nums)  # [1, 3, 12, 0, 0]
```

**执行过程图解**：
```
初始：[0, 1, 0, 3, 12]   slow=0

fast=0: nums[0]=0，跳过
fast=1: nums[1]=1≠0，交换 nums[0] 和 nums[1]，slow=1
        → [1, 0, 0, 3, 12]
fast=2: nums[2]=0，跳过
fast=3: nums[3]=3≠0，交换 nums[1] 和 nums[3]，slow=2
        → [1, 3, 0, 0, 12]
fast=4: nums[4]=12≠0，交换 nums[2] 和 nums[4]，slow=3
        → [1, 3, 12, 0, 0]
```

##### 例题2：合并两个有序数组（LeetCode 88）

**题目**：给你两个有序数组 `nums1` 和 `nums2`，把 `nums2` 合并到 `nums1` 中，使 `nums1` 也是一个有序数组。`nums1` 的末尾有足够的空间容纳 `nums2`。

**思路**：从后往前合并！因为 `nums1` 后面有空位，从后往前填不会覆盖还没处理的元素。

```python
def merge(nums1, m, nums2, n):
    """
    合并两个有序数组
    
    思路：从后往前合并！
    - 三个指针：p1 指向 nums1 有效元素末尾，p2 指向 nums2 末尾，
      p 指向 nums1 的实际末尾
    - 每次取较大的放到 p 的位置
    
    为什么从后往前？因为 nums1 后面的空间是空的，
    从后往前填不会覆盖还没比较过的元素。
    """
    # 三个指针
    p1 = m - 1       # nums1 有效元素的最后一个
    p2 = n - 1       # nums2 的最后一个
    p = m + n - 1    # 合并后数组的最后一个位置

    # 从后往前比较，把大的放到后面
    while p1 >= 0 and p2 >= 0:
        if nums1[p1] > nums2[p2]:
            nums1[p] = nums1[p1]
            p1 -= 1
        else:
            nums1[p] = nums2[p2]
            p2 -= 1
        p -= 1

    # 如果 nums2 还有剩余，直接填入
    # （如果 nums1 有剩余，不用管，它们本来就在那个位置）
    while p2 >= 0:
        nums1[p] = nums2[p2]
        p2 -= 1
        p -= 1

    # 时间复杂度：O(m + n)
    # 空间复杂度：O(1)

# 测试
nums1 = [1, 2, 3, 0, 0, 0]
m = 3
nums2 = [2, 5, 6]
n = 3
merge(nums1, m, nums2, n)
print(nums1)  # [1, 2, 2, 3, 5, 6]
```

##### 例题3：两数之和（数组解法）

**题目**：给定一个整数数组 `nums` 和一个目标值 `target`，找出数组中和为 `target` 的两个数的下标。

**思路**：用哈希表记录"我需要的互补值"。遍历数组时，对于每个元素，检查它是否在哈希表中（即之前是否有人需要它作为互补值）。

```python
def twoSum(nums, target):
    """
    两数之和：找到数组中两个数，使它们的和等于 target
    
    思路：用哈希表（字典）记录 {需要的互补值: 下标}
    
    类比：你在找搭档跳舞，你的身高是 x，你需要一个身高为 target-x 的搭档。
    你拿着一本"寻人册"，每遇到一个人就查册子里有没有找他的人。
    """
    seen = {}  # 哈希表：{互补值: 下标}

    for i, num in enumerate(nums):
        # num 是当前遇到的数字
        # 如果 num 在 seen 中，说明之前有人需要 num 作为搭档
        if num in seen:
            return [seen[num], i]  # 返回两人的下标

        # 否则，把 num 需要的搭档记录到哈希表中
        complement = target - num
        seen[complement] = i

    # 时间复杂度：O(n)，遍历一次数组
    # 空间复杂度：O(n)，哈希表最多存 n 个元素

# 测试
nums = [2, 7, 11, 15]
target = 9
print(twoSum(nums, target))  # [0, 1]（因为 nums[0]+nums[1] = 2+7 = 9）
```

**执行过程**：
```
nums = [2, 7, 11, 15], target = 9

i=0, num=2:  seen={}, 2不在seen中 → seen={7: 0}  （我需要一个7）
i=1, num=7:  seen={7: 0}, 7在seen中！→ 返回 [0, 1]
```

---

#### 九、数组的优缺点总结

| 优点 | 说明 |
|------|------|
| **随机访问 O(1)** | 通过下标直接定位，这是数组最大的优势 |
| **内存紧凑** | 连续存储，没有额外开销（不像链表需要存指针） |
| **缓存友好** | 连续内存对 CPU 缓存友好，实际运行速度很快 |

| 缺点 | 说明 |
|------|------|
| **插入/删除 O(n)** | 需要移动大量元素 |
| **大小固定**（静态数组） | 虽然动态数组可以扩容，但扩容有开销 |
| **内存浪费** | 预分配的空间可能用不满 |
| **内存碎片** | 需要一大块连续空间，可能找不到足够大的空闲区域 |

##### 什么时候用数组？

- 需要**频繁按下标访问**元素时
- 元素数量**变化不大**或可以预估时
- 需要**缓存友好**的高性能场景时

##### 什么时候不该用数组？

- 需要**频繁在中间插入/删除**元素时 → 考虑链表
- 元素数量**完全无法预估**且差异很大时

---

---


### 主题3 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、数组的随机访问

```typescript
// ========== 数组的随机访问 ==========
const arr: number[] = [10, 20, 30, 40, 50];

// 无论访问哪个元素，都是 O(1) 的时间
console.log(arr[0]);    // 直接定位 → 10
console.log(arr[2]);    // 直接定位 → 30
console.log(arr[4]);    // 直接定位 → 50
// 访问第1个和访问第10000个，速度一样快！
```

##### 二、TypeScript 的数组就是动态数组

```typescript
// TypeScript 的 Array 是动态数组
const arr2: number[] = [1, 2, 3];   // 初始3个元素
arr2.push(4);                        // 可以追加，自动扩容
arr2.push(5);                        // 继续追加
console.log(arr2);                   // [1, 2, 3, 4, 5]

// 它甚至可以混合类型（但不推荐，失去了数组的意义）
const mixed: (number | string | boolean)[] = [1, "hello", 3.14, true];
```

##### 三、基本操作

```typescript
// ========== 1. 遍历数组 ==========
function traverse(arr: number[]): void {
  // 方式一：通过下标遍历
  for (let i = 0; i < arr.length; i++) {
    console.log(`arr[${i}] = ${arr[i]}`);
  }

  // 方式二：直接遍历元素
  for (const val of arr) {
    console.log(val);
  }

  // 方式三：同时需要下标和值（forEach）
  arr.forEach((val, i) => {
    console.log(`下标 ${i} 的值是 ${val}`);
  });
}

// 测试
traverse([10, 20, 30, 40, 50]);
// 复杂度：O(n)

// ========== 2. 在指定位置插入元素 ==========
function insertAt(arr: number[], index: number, value: number): void {
  const n = arr.length;

  // 第一步：检查下标是否合法
  if (index < 0 || index > n) {
    throw new Error("插入位置不合法");
  }

  // 第二步：在末尾添加一个占位元素（扩容一位）
  arr.push(0); // 现在长度变成 n+1

  // 第三步：从后往前，逐个元素往后移动
  for (let i = n; i > index; i--) {
    arr[i] = arr[i - 1];
  }

  // 第四步：把目标位置放上新的值
  arr[index] = value;
}

// 测试
const arr3 = [10, 20, 30, 40, 50];
insertAt(arr3, 2, 99);
console.log(arr3);  // [10, 20, 99, 30, 40, 50]
// 最好 O(1) / 最坏 O(n) / 平均 O(n)

// ========== 3. 删除指定位置的元素 ==========
function deleteAt(arr: number[], index: number): number {
  const n = arr.length;

  // 检查下标是否合法
  if (index < 0 || index >= n) {
    throw new Error("删除位置不合法");
  }

  // 保存被删除的值
  const removed = arr[index];

  // 第二步：从前往后，逐个元素往前移动
  for (let i = index; i < n - 1; i++) {
    arr[i] = arr[i + 1];
  }

  // 第三步：移除末尾多余的元素
  arr.pop();
  return removed;
}

// 测试
const arr4 = [10, 20, 99, 30, 40, 50];
const removed = deleteAt(arr4, 2);
console.log(`删除了: ${removed}`);  // 删除了: 99
console.log(`删除后: ${arr4}`);     // [10, 20, 30, 40, 50]
// 最好 O(1) / 最坏 O(n) / 平均 O(n)

// ========== 4. 查找元素（线性查找）==========
function linearSearch(arr: number[], target: number): number {
  for (let i = 0; i < arr.length; i++) {
    if (arr[i] === target) return i;  // 找到了，返回下标
  }
  return -1;  // 没找到
}

// 测试
console.log(linearSearch([10, 20, 30, 40, 50], 30));  // 2
console.log(linearSearch([10, 20, 30, 40, 50], 99));  // -1
// 最好 O(1) / 最坏 O(n) / 平均 O(n)
```

##### 四、动态数组的扩容机制

```typescript
// ========== 模拟动态数组的扩容过程 ==========
class DynamicArray {
  capacity: number;   // 当前容量
  size: number;       // 当前元素个数
  data: number[];     // 底层数组

  constructor() {
    this.capacity = 4;   // 初始容量
    this.size = 0;       // 当前元素个数
    this.data = new Array<number>(this.capacity);  // 底层数组
  }

  append(value: number): void {
    if (this.size === this.capacity) {
      // 容量满了，需要扩容！
      const oldCapacity = this.capacity;
      this.capacity *= 2;  // 容量翻倍
      console.log(`扩容！${oldCapacity} → ${this.capacity}`);

      // 创建新的更大的数组
      const newData = new Array<number>(this.capacity);

      // 把旧数据搬过来
      for (let i = 0; i < this.size; i++) {
        newData[i] = this.data[i];
      }

      this.data = newData;
    }

    // 放入新元素
    this.data[this.size] = value;
    this.size++;
  }
}

// 测试：观察扩容过程
const da = new DynamicArray();
for (let i = 0; i < 10; i++) {
  da.append(i);
  console.log(`  添加了 ${i}，当前容量=${da.capacity}，元素数=${da.size}`);
}
// 扩容！4 → 8 / 扩容！8 → 16
// 均摊复杂度 O(1)：偶尔搬一次家，但搬完很久不用再搬
```

##### 五、二维数组与矩阵

```typescript
// ========== 二维数组的创建 ==========
// 方式一：直接定义
const matrix: number[][] = [
  [1, 2, 3],    // 第0行
  [4, 5, 6],    // 第1行
  [7, 8, 9]     // 第2行
];

// 方式二：创建 m×n 的零矩阵
const rows = 3, cols = 4;
const matrix2: number[][] = Array.from({ length: rows }, () =>
  new Array<number>(cols).fill(0)
);
console.log(matrix2);

// ========== 访问二维数组的元素 ==========
// 访问：matrix[行][列]
console.log(matrix[0][0]);   // 1  （第0行第0列）
console.log(matrix[1][2]);   // 6  （第1行第2列）
console.log(matrix[2][1]);   // 8  （第2行第1列）

// ========== 遍历二维数组 ==========
function traverseMatrix(matrix: number[][]): void {
  const rows = matrix.length;
  const cols = rows > 0 ? matrix[0].length : 0;

  for (let i = 0; i < rows; i++) {          // 外层循环：遍历每一行
    for (let j = 0; j < cols; j++) {        // 内层循环：遍历该行的每一列
      console.log(`matrix[${i}][${j}] = ${matrix[i][j]}`);
    }
  }
}

traverseMatrix(matrix);

// TS 没有 Python 的 [[0]*3]*2 共享引用陷阱，但同样建议逐行创建
```

##### 六、经典例题

```typescript
// ========== 例题1：移动零（LeetCode 283）==========
// 双指针：slow 记录下一个非零元素该放的位置，fast 遍历数组
function moveZeroes(nums: number[]): void {
  let slow = 0;  // slow 指向下一个非零元素应该放的位置

  for (let fast = 0; fast < nums.length; fast++) {
    if (nums[fast] !== 0) {
      // 遇到非零元素，交换到 slow 位置
      [nums[slow], nums[fast]] = [nums[fast], nums[slow]];
      slow++;  // slow 前进一步
    }
  }
  // 时间复杂度：O(n)  空间复杂度：O(1)
}

// 测试
const nums = [0, 1, 0, 3, 12];
moveZeroes(nums);
console.log(nums);  // [1, 3, 12, 0, 0]

// ========== 例题2：合并两个有序数组（LeetCode 88）==========
// 从后往前合并！nums1 后面有空位，从后往前填不会覆盖还没处理的元素
function merge(nums1: number[], m: number, nums2: number[], n: number): void {
  let p1 = m - 1;       // nums1 有效元素的最后一个
  let p2 = n - 1;       // nums2 的最后一个
  let p = m + n - 1;    // 合并后数组的最后一个位置

  // 从后往前比较，把大的放到后面
  while (p1 >= 0 && p2 >= 0) {
    if (nums1[p1] > nums2[p2]) {
      nums1[p] = nums1[p1];
      p1--;
    } else {
      nums1[p] = nums2[p2];
      p2--;
    }
    p--;
  }

  // 如果 nums2 还有剩余，直接填入
  while (p2 >= 0) {
    nums1[p] = nums2[p2];
    p2--;
    p--;
  }
  // 时间复杂度：O(m + n)  空间复杂度：O(1)
}

// 测试
const nums1 = [1, 2, 3, 0, 0, 0];
merge(nums1, 3, [2, 5, 6], 3);
console.log(nums1);  // [1, 2, 2, 3, 5, 6]

// ========== 例题3：两数之和（数组解法）==========
// 用哈希表记录"我需要的互补值"
function twoSum(nums: number[], target: number): number[] {
  const seen = new Map<number, number>();  // 哈希表：{互补值: 下标}

  for (let i = 0; i < nums.length; i++) {
    const num = nums[i];
    // 如果 num 在 seen 中，说明之前有人需要 num 作为搭档
    if (seen.has(num)) {
      return [seen.get(num)!, i];  // 返回两人的下标
    }
    // 否则，把 num 需要的搭档记录到哈希表中
    seen.set(target - num, i);
  }

  return [];
  // 时间复杂度：O(n)  空间复杂度：O(n)
}

// 测试
console.log(twoSum([2, 7, 11, 15], 9));  // [0, 1]（因为 2+7 = 9）
```

### 主题3 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、数组的随机访问

```go
package main

import "fmt"

func main() {
	// ========== 数组的随机访问 ==========
	arr := [5]int{10, 20, 30, 40, 50}

	// 无论访问哪个元素，都是 O(1) 的时间
	fmt.Println(arr[0]) // 直接定位 → 10
	fmt.Println(arr[2]) // 直接定位 → 30
	fmt.Println(arr[4]) // 直接定位 → 50
	// 访问第1个和访问第10000个，速度一样快！
}
```

##### 二、Go 的切片就是动态数组

```go
package main

import "fmt"

func main() {
	// Go 的切片（Slice）是动态数组
	arr := []int{1, 2, 3} // 初始3个元素
	arr = append(arr, 4)  // 可以追加，自动扩容
	arr = append(arr, 5)  // 继续追加
	fmt.Println(arr)      // [1 2 3 4 5]

	// Go 是强类型语言，切片不能混合类型
	// 若要混合类型，需要用 interface{}
	mixed := []interface{}{1, "hello", 3.14, true}
	fmt.Println(mixed)
}
```

##### 三、基本操作

```go
package main

import "fmt"

func main() {
	// ========== 1. 遍历数组 ==========
	traverse([]int{10, 20, 30, 40, 50})
	// 复杂度：O(n)

	// ========== 2. 在指定位置插入元素 ==========
	// Go 没有内置 insert，用切片拼接实现
	arr := []int{10, 20, 30, 40, 50}
	insertAt(&arr, 2, 99)
	fmt.Println(arr) // [10 20 99 30 40 50]
	// 最好 O(1) / 最坏 O(n) / 平均 O(n)

	// ========== 3. 删除指定位置的元素 ==========
	removed := deleteAt(&arr, 2)
	fmt.Printf("删除了: %d\n", removed) // 删除了: 99
	fmt.Printf("删除后: %v\n", arr)     // [10 20 30 40 50]

	// ========== 4. 查找元素（线性查找）==========
	fmt.Println(linearSearch([]int{10, 20, 30, 40, 50}, 30)) // 2
	fmt.Println(linearSearch([]int{10, 20, 30, 40, 50}, 99)) // -1
}

// 1. 遍历数组
func traverse(arr []int) {
	// 方式一：通过下标遍历
	for i := 0; i < len(arr); i++ {
		fmt.Printf("arr[%d] = %d\n", i, arr[i])
	}

	// 方式二：直接遍历元素
	for _, val := range arr {
		fmt.Println(val)
	}

	// 方式三：同时需要下标和值（for range 两值）
	for i, val := range arr {
		fmt.Printf("下标 %d 的值是 %d\n", i, val)
	}
}

// 2. 在指定位置插入元素（手动实现）
func insertAt(arr *[]int, index, value int) {
	n := len(*arr)

	// 检查下标是否合法
	if index < 0 || index > n {
		panic("插入位置不合法")
	}

	// 在末尾添加一个占位元素（扩容一位）
	*arr = append(*arr, 0) // 现在长度变成 n+1

	// 从后往前，逐个元素往后移动
	for i := n; i > index; i-- {
		(*arr)[i] = (*arr)[i-1]
	}

	// 把目标位置放上新的值
	(*arr)[index] = value
}

// 3. 删除指定位置的元素（手动实现）
func deleteAt(arr *[]int, index int) int {
	n := len(*arr)

	// 检查下标是否合法
	if index < 0 || index >= n {
		panic("删除位置不合法")
	}

	// 保存被删除的值
	removed := (*arr)[index]

	// 从前往后，逐个元素往前移动
	for i := index; i < n-1; i++ {
		(*arr)[i] = (*arr)[i+1]
	}

	// 移除末尾多余的元素
	*arr = (*arr)[:n-1]
	return removed
}

// 4. 线性查找
func linearSearch(arr []int, target int) int {
	for i := 0; i < len(arr); i++ {
		if arr[i] == target {
			return i // 找到了，返回下标
		}
	}
	return -1 // 没找到
}
```

##### 四、动态数组的扩容机制

```go
package main

import "fmt"

// ========== 模拟动态数组的扩容过程 ==========
type DynamicArray struct {
	capacity int   // 当前容量
	size     int   // 当前元素个数
	data     []int // 底层切片
}

func NewDynamicArray() *DynamicArray {
	return &DynamicArray{
		capacity: 4,                                  // 初始容量
		size:     0,                                  // 当前元素个数
		data:     make([]int, 4, 4),                  // 底层数组
	}
}

func (da *DynamicArray) Append(value int) {
	if da.size == da.capacity {
		// 容量满了，需要扩容！
		oldCapacity := da.capacity
		da.capacity *= 2 // 容量翻倍
		fmt.Printf("扩容！%d → %d\n", oldCapacity, da.capacity)

		// 创建新的更大的切片
		newData := make([]int, da.capacity)

		// 把旧数据搬过来
		for i := 0; i < da.size; i++ {
			newData[i] = da.data[i]
		}

		da.data = newData
	}

	// 放入新元素
	da.data[da.size] = value
	da.size++
}

func main() {
	// 测试：观察扩容过程
	da := NewDynamicArray()
	for i := 0; i < 10; i++ {
		da.Append(i)
		fmt.Printf("  添加了 %d，当前容量=%d，元素数=%d\n", i, da.capacity, da.size)
	}
	// 扩容！4 → 8 / 扩容！8 → 16
	// 均摊复杂度 O(1)：偶尔搬一次家，但搬完很久不用再搬
}
```

##### 五、二维数组与矩阵

```go
package main

import "fmt"

func main() {
	// ========== 二维数组的创建 ==========
	// 方式一：直接定义
	matrix := [][]int{
		{1, 2, 3}, // 第0行
		{4, 5, 6}, // 第1行
		{7, 8, 9}, // 第2行
	}

	// 方式二：创建 m×n 的零矩阵
	rows, cols := 3, 4
	matrix2 := make([][]int, rows)
	for i := range matrix2 {
		matrix2[i] = make([]int, cols) // 每行独立创建
	}
	fmt.Println(matrix2)

	// ========== 访问二维数组的元素 ==========
	// 访问：matrix[行][列]
	fmt.Println(matrix[0][0]) // 1  （第0行第0列）
	fmt.Println(matrix[1][2]) // 6  （第1行第2列）
	fmt.Println(matrix[2][1]) // 8  （第2行第1列）

	// ========== 遍历二维数组 ==========
	traverseMatrix(matrix)
}

func traverseMatrix(matrix [][]int) {
	rows := len(matrix)
	cols := 0
	if rows > 0 {
		cols = len(matrix[0])
	}

	for i := 0; i < rows; i++ { // 外层循环：遍历每一行
		for j := 0; j < cols; j++ { // 内层循环：遍历该行的每一列
			fmt.Printf("matrix[%d][%d] = %d\n", i, j, matrix[i][j])
		}
	}
}
```

##### 六、经典例题

```go
package main

import "fmt"

func main() {
	// ========== 例题1：移动零（LeetCode 283）==========
	// 双指针：slow 记录下一个非零元素该放的位置，fast 遍历数组
	nums := []int{0, 1, 0, 3, 12}
	moveZeroes(nums)
	fmt.Println(nums) // [1 3 12 0 0]

	// ========== 例题2：合并两个有序数组（LeetCode 88）==========
	nums1 := []int{1, 2, 3, 0, 0, 0}
	merge(nums1, 3, []int{2, 5, 6}, 3)
	fmt.Println(nums1) // [1 2 2 3 5 6]

	// ========== 例题3：两数之和（数组解法）==========
	fmt.Println(twoSum([]int{2, 7, 11, 15}, 9)) // [0 1]（因为 2+7 = 9）
}

// 例题1：移动零
// slow 指向"下一个非零元素该放的位置"，fast 遍历整个数组
func moveZeroes(nums []int) {
	slow := 0 // slow 指向下一个非零元素应该放的位置

	for fast := 0; fast < len(nums); fast++ {
		if nums[fast] != 0 {
			// 遇到非零元素，交换到 slow 位置
			nums[slow], nums[fast] = nums[fast], nums[slow]
			slow++ // slow 前进一步
		}
	}
	// 时间复杂度：O(n)  空间复杂度：O(1)
}

// 例题2：合并两个有序数组
// 从后往前合并！nums1 后面有空位，从后往前填不会覆盖还没处理的元素
func merge(nums1 []int, m int, nums2 []int, n int) {
	p1 := m - 1    // nums1 有效元素的最后一个
	p2 := n - 1    // nums2 的最后一个
	p := m + n - 1 // 合并后数组的最后一个位置

	// 从后往前比较，把大的放到后面
	for p1 >= 0 && p2 >= 0 {
		if nums1[p1] > nums2[p2] {
			nums1[p] = nums1[p1]
			p1--
		} else {
			nums1[p] = nums2[p2]
			p2--
		}
		p--
	}

	// 如果 nums2 还有剩余，直接填入
	for p2 >= 0 {
		nums1[p] = nums2[p2]
		p2--
		p--
	}
	// 时间复杂度：O(m + n)  空间复杂度：O(1)
}

// 例题3：两数之和
// 用哈希表（map）记录"我需要的互补值"
func twoSum(nums []int, target int) []int {
	seen := make(map[int]int) // 哈希表：{互补值: 下标}

	for i, num := range nums {
		// 如果 num 在 seen 中，说明之前有人需要 num 作为搭档
		if idx, ok := seen[num]; ok {
			return []int{idx, i} // 返回两人的下标
		}
		// 否则，把 num 需要的搭档记录到哈希表中
		seen[target-num] = i
	}

	return nil
	// 时间复杂度：O(n)  空间复杂度：O(n)
}
```

---

### 主题4：链表（Linked List）


#### 一、链表的概念

##### 用"寻宝游戏"来类比

想象一个**寻宝游戏**：

```
宝箱A → 宝箱B → 宝箱C → 宝箱D → 宝藏！
(12)    (45)    (7)     (23)
 ↓       ↓       ↓       ↓
去B找   去C找   去D找    终点
```

- 每个宝箱里有一件**宝贝**（数据）和一张**纸条**（指向下一个宝箱的线索）
- 你**必须从第一个宝箱开始**，按照纸条的指引，一个一个找下去
- 你不能直接跳到第3个宝箱——你必须先找到第1个，再看纸条去第2个...

这就是链表！每个节点存储数据和指向下一个节点的引用。

---

#### 二、链表 vs 数组的对比

| 对比项 | 数组 | 链表 |
|--------|------|------|
| **内存布局** | 连续存储（一排座位） | 离散存储（寻宝游戏） |
| **访问方式** | 随机访问 O(1)（按下标直达） | 顺序访问 O(n)（从头遍历） |
| **插入/删除** | O(n)（需要移动元素） | O(1)（修改指针即可，但找到位置要 O(n)） |
| **大小** | 固定（静态）或动态扩容 | 灵活，按需分配 |
| **内存开销** | 无额外开销 | 每个节点需要额外存指针 |
| **缓存友好** | 是（连续内存） | 否（分散存储） |

**一句话总结**：数组擅长"查找"，链表擅长"插入删除"。

---

#### 三、单链表的结构

```
节点(Node) = 值(data) + 指针(next)

┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ data: 12 │    │ data: 45 │    │ data: 7  │    │ data: 23 │
│ next ────┼──→ │ next ────┼──→ │ next ────┼──→ │ next:None│
└──────────┘    └──────────┘    └──────────┘    └──────────┘
     ↑                                               
   head（头指针，指向第一个节点）
```

- **head**：头指针，永远指向链表的第一个节点，是访问链表的"入口"
- **每个节点**：包含两部分——存储的数据 + 指向下一个节点的指针
- **最后一个节点**：指针为 None（Python）/ null（Java/C++），表示链表到此结束

---

#### 四、Python 实现单链表节点类

```python
class ListNode:
    """
    链表节点类
    
    类比：一个宝箱
    - val：宝箱里的宝贝（数据）
    - next：纸条，指向下一个宝箱（下一个节点的引用）
    """
    def __init__(self, val=0, next=None):
        self.val = val        # 节点存储的值
        self.next = next      # 指向下一个节点

# 创建节点
node1 = ListNode(12)
node2 = ListNode(45)
node3 = ListNode(7)

# 把节点串起来：node1 → node2 → node3
node1.next = node2
node2.next = node3

# 现在 node1 就是链表的头节点
# 从 node1 出发，可以访问到所有节点
```

---

#### 五、完整链表类及基本操作

```python
class LinkedList:
    """单链表的完整实现"""

    def __init__(self):
        # 初始化一个空链表，头指针为 None
        self.head = None

    # ==================== 1. 遍历链表 ====================
    def traverse(self):
        """
        遍历链表：从头节点开始，沿着指针逐个访问每个节点
        
        类比：按照寻宝游戏的纸条，从第一个宝箱找到最后一个
        """
        current = self.head  # 从头节点开始
        result = []
        while current is not None:    # 还没到链表末尾
            result.append(current.val)
            current = current.next    # 走向下一个节点
        return result
        # 时间复杂度：O(n)，必须逐个访问

    # ==================== 2. 头部插入 ====================
    def insert_at_head(self, val):
        """
        在链表头部插入新节点
        
        步骤：
        1. 创建新节点
        2. 新节点的 next 指向当前的 head
        3. 更新 head 指向新节点
        
        类比：在队伍最前面插一个人，原来排头的人往后退一位
        """
        new_node = ListNode(val)     # 创建新节点
        new_node.next = self.head    # 新节点指向原来的头节点
        self.head = new_node         # 头指针更新为新节点
        # 时间复杂度：O(1)，不需要遍历！

    # ==================== 3. 尾部插入 ====================
    def insert_at_tail(self, val):
        """
        在链表尾部插入新节点
        
        步骤：
        1. 创建新节点
        2. 从头遍历到最后一个节点
        3. 让最后一个节点的 next 指向新节点
        
        类比：在队伍末尾加一个人，要先走到队尾
        """
        new_node = ListNode(val)

        # 如果链表为空，新节点直接成为头节点
        if self.head is None:
            self.head = new_node
            return

        # 走到最后一个节点
        current = self.head
        while current.next is not None:
            current = current.next

        # 最后一个节点指向新节点
        current.next = new_node
        # 时间复杂度：O(n)，需要遍历到末尾

    # ==================== 4. 指定位置插入 ====================
    def insert_at(self, index, val):
        """
        在链表的 index 位置插入新节点（0-indexed）
        
        步骤：
        1. 走到 index-1 位置的节点
        2. 新节点的 next 指向 index 位置的节点
        3. index-1 位置的节点的 next 指向新节点
        
        类比：在队伍的第3个人后面插入，先找到第3个人，
        然后让新来的人拉住第4个人的手，第3个人的手拉住新来的人
        """
        # 在头部插入，特殊处理
        if index == 0:
            self.insert_at_head(val)
            return

        # 走到 index-1 位置
        current = self.head
        for _ in range(index - 1):
            if current is None:
                raise IndexError("插入位置超出链表范围")
            current = current.next

        if current is None:
            raise IndexError("插入位置超出链表范围")

        # 插入操作（注意顺序！先连新节点，再改前驱节点）
        new_node = ListNode(val)
        new_node.next = current.next   # 新节点先拉住后面的人
        current.next = new_node        # 前面的人改拉新节点
        # 时间复杂度：O(n)，需要遍历到指定位置

    # ==================== 5. 删除节点 ====================
    def delete(self, val):
        """
        删除链表中第一个值为 val 的节点
        
        思路：找到要删除节点的前一个节点（前驱），
        让前驱的 next 跳过要删除的节点
        
        类比：队伍中有人要离开，
        让前面的人直接拉住后面的人，跳过离开的人
        """
        if self.head is None:
            return False  # 链表为空

        # 如果要删除的是头节点
        if self.head.val == val:
            self.head = self.head.next  # 头指针后移
            return True

        # 找要删除的节点的前驱
        current = self.head
        while current.next is not None:
            if current.next.val == val:
                # 找到了！跳过要删除的节点
                current.next = current.next.next
                return True
            current = current.next

        return False  # 没找到
        # 时间复杂度：O(n)

    # ==================== 6. 查找节点 ====================
    def search(self, val):
        """
        查找值为 val 的节点，返回其下标（0-indexed），找不到返回 -1
        
        类比：在寻宝路上找某个特定的宝贝
        """
        current = self.head
        index = 0
        while current is not None:
            if current.val == val:
                return index
            current = current.next
            index += 1
        return -1
        # 时间复杂度：O(n)
```

##### 测试代码

```python
# 测试链表的各种操作
ll = LinkedList()

# 尾部插入
ll.insert_at_tail(10)
ll.insert_at_tail(20)
ll.insert_at_tail(30)
print("尾部插入后:", ll.traverse())  # [10, 20, 30]

# 头部插入
ll.insert_at_head(5)
print("头部插入后:", ll.traverse())  # [5, 10, 20, 30]

# 指定位置插入
ll.insert_at(2, 15)
print("位置2插入15后:", ll.traverse())  # [5, 10, 15, 20, 30]

# 查找
print("查找20:", ll.search(20))   # 3
print("查找99:", ll.search(99))   # -1

# 删除
ll.delete(15)
print("删除15后:", ll.traverse())  # [5, 10, 20, 30]

ll.delete(5)  # 删除头节点
print("删除头节点后:", ll.traverse())  # [10, 20, 30]
```

##### 各操作复杂度汇总

| 操作 | 时间复杂度 | 说明 |
|------|-----------|------|
| 遍历 | O(n) | 必须逐个访问 |
| 头部插入 | O(1) | 直接修改头指针 |
| 尾部插入 | O(n) | 需要遍历到末尾 |
| 指定位置插入 | O(n) | 需要遍历到指定位置 |
| 删除 | O(n) | 需要遍历找到目标 |
| 查找 | O(n) | 需要遍历 |

---

#### 六、双链表

##### 结构

双链表的每个节点多了一个**前驱指针**，可以双向遍历：

```
           prev    ┌──────────┐  prev    ┌──────────┐  prev
    None ←─────────┤ data: 10 ├──────────┤ data: 20 ├──────────
                   │ next ────┼────────→ │ next ────┼────────→
           ─────────┴──────────┘         ───────────┴──────────┘
             head                    tail
```

##### 与单链表的区别

| 对比项 | 单链表 | 双链表 |
|--------|--------|--------|
| 指针 | 只有 next | 有 next 和 prev |
| 遍历方向 | 只能向后 | 可以向前也可以向后 |
| 删除操作 | 需要找前驱 | 直接通过 prev 找到前驱 |
| 内存开销 | 每个节点1个指针 | 每个节点2个指针 |

##### Python 实现

```python
class DoublyListNode:
    """双链表节点"""
    def __init__(self, val=0, prev=None, next=None):
        self.val = val
        self.prev = prev    # 前驱指针
        self.next = next    # 后继指针

class DoublyLinkedList:
    """双链表实现"""
    def __init__(self):
        self.head = None
        self.tail = None    # 维护尾指针，尾部插入变为 O(1)

    def insert_at_head(self, val):
        """头部插入 O(1)"""
        new_node = DoublyListNode(val)
        if self.head is None:
            self.head = self.tail = new_node
        else:
            new_node.next = self.head
            self.head.prev = new_node
            self.head = new_node

    def insert_at_tail(self, val):
        """尾部插入 O(1)（因为有 tail 指针）"""
        new_node = DoublyListNode(val)
        if self.tail is None:
            self.head = self.tail = new_node
        else:
            new_node.prev = self.tail
            self.tail.next = new_node
            self.tail = new_node

    def delete_node(self, node):
        """
        删除指定节点 O(1)（如果已经拿到了该节点的引用）
        这是双链表的优势：不需要从头找前驱
        """
        if node.prev:
            node.prev.next = node.next
        else:
            self.head = node.next  # 删除的是头节点

        if node.next:
            node.next.prev = node.prev
        else:
            self.tail = node.prev  # 删除的是尾节点

    def traverse_forward(self):
        """正向遍历"""
        result = []
        current = self.head
        while current:
            result.append(current.val)
            current = current.next
        return result

    def traverse_backward(self):
        """反向遍历（双链表独有！）"""
        result = []
        current = self.tail
        while current:
            result.append(current.val)
            current = current.prev
        return result

# 测试
dll = DoublyLinkedList()
dll.insert_at_head(10)
dll.insert_at_head(5)
dll.insert_at_tail(20)
dll.insert_at_tail(30)
print("正向:", dll.traverse_forward())   # [5, 10, 20, 30]
print("反向:", dll.traverse_backward())  # [30, 20, 10, 5]
```

---

#### 七、循环链表简介

循环链表是链表的一种变体，**最后一个节点的 next 指向头节点**，形成一个环：

```
┌──────────┐    ┌──────────┐    ┌──────────┐
│ data: 1  │    │ data: 2  │    │ data: 3  │
│ next ────┼──→ │ next ────┼──→ │ next ────┼──┐
└──────────┘    └──────────┘    └──────────┘  │
     ↑                                        │
     └────────────────────────────────────────┘
```

**应用场景**：
- 约瑟夫问题（围成一圈报数淘汰）
- 轮转调度（如操作系统的进程轮转调度）
- 需要循环遍历所有节点的场景

```python
class CircularLinkedList:
    """循环链表简介实现"""
    def __init__(self):
        self.head = None

    def append(self, val):
        """在循环链表尾部添加节点"""
        new_node = ListNode(val)
        if self.head is None:
            self.head = new_node
            new_node.next = self.head  # 自己指向自己
            return

        current = self.head
        while current.next != self.head:  # 找到最后一个节点
            current = current.next

        current.next = new_node
        new_node.next = self.head  # 尾节点指向头节点

    def traverse(self):
        """遍历循环链表（只走一圈）"""
        if self.head is None:
            return []
        result = []
        current = self.head
        while True:
            result.append(current.val)
            current = current.next
            if current == self.head:  # 回到起点就停止
                break
        return result

# 测试
cll = CircularLinkedList()
for val in [1, 2, 3, 4]:
    cll.append(val)
print("循环链表:", cll.traverse())  # [1, 2, 3, 4]
```

---

#### 八、经典例题

##### 例题1：反转链表（LeetCode 206）

**题目**：反转一个单链表。

###### 方法一：迭代法

```python
def reverseList(head):
    """
    反转链表（迭代法）
    
    思路：逐个把节点的 next 指针反转
    用三个指针：prev（前一个）、curr（当前）、next_temp（暂存下一个）
    
    类比：一列火车要掉头，每节车厢的挂钩都要反方向挂
    """
    prev = None      # 新链表的"前一个节点"，初始为 None（反转后原头节点变尾节点）
    curr = head      # 当前要处理的节点

    while curr is not None:
        next_temp = curr.next   # 先暂存下一个节点（不然反转后就找不到了）
        curr.next = prev        # 反转！当前节点指向前一个节点
        prev = curr             # prev 前进一步
        curr = next_temp        # curr 前进一步

    # 循环结束时，curr=None，prev 指向新的头节点
    return prev
    # 时间复杂度：O(n)
    # 空间复杂度：O(1)

# 测试
# 创建链表 1→2→3→4→5
node5 = ListNode(5)
node4 = ListNode(4, node5)
node3 = ListNode(3, node4)
node2 = ListNode(2, node3)
node1 = ListNode(1, node2)

# 反转
new_head = reverseList(node1)
# 结果：5→4→3→2→1
```

**执行过程图解**：
```
初始：1 → 2 → 3 → 4 → 5 → None
     prev=None  curr=1

第1步：None ← 1   2 → 3 → 4 → 5
       prev=1   curr=2

第2步：None ← 1 ← 2   3 → 4 → 5
       prev=2   curr=3

第3步：None ← 1 ← 2 ← 3   4 → 5
       prev=3   curr=4

第4步：None ← 1 ← 2 ← 3 ← 4   5
       prev=4   curr=5

第5步：None ← 1 ← 2 ← 3 ← 4 ← 5
       prev=5   curr=None → 结束，返回 prev=5
```

###### 方法二：递归法

```python
def reverseListRecursive(head):
    """
    反转链表（递归法）
    
    思路：递归反转后面的部分，然后把当前节点接到末尾
    
    类比：把后面的火车先掉头，然后把自己挂到新的末尾
    """
    # 递归终止条件：空链表或只有一个节点
    if head is None or head.next is None:
        return head

    # 递归反转后面的部分
    new_head = reverseListRecursive(head.next)

    # 把当前节点接到反转后链表的末尾
    # head.next 是原来的下一个节点，反转后它变成了"前面的节点"
    # 让它的 next 指向当前节点
    head.next.next = head
    head.next = None  # 当前节点变成尾节点，next 设为 None

    return new_head
    # 时间复杂度：O(n)
    # 空间复杂度：O(n)，递归调用栈的深度
```

##### 例题2：合并两个有序链表（LeetCode 21）

**题目**：将两个升序链表合并为一个新的升序链表。

```python
def mergeTwoLists(l1, l2):
    """
    合并两个有序链表
    
    思路：用双指针，每次取较小的节点接到结果链表后面
    
    类比：两队人按身高排队，每次从两队头部选较矮的那个人出列
    """
    # 虚拟头节点（dummy head），简化边界处理
    dummy = ListNode(0)
    current = dummy

    # 当两个链表都还没遍历完时
    while l1 is not None and l2 is not None:
        if l1.val <= l2.val:
            current.next = l1   # 接上 l1 的当前节点
            l1 = l1.next        # l1 前进一步
        else:
            current.next = l2   # 接上 l2 的当前节点
            l2 = l2.next        # l2 前进一步
        current = current.next  # 结果链表前进一步

    # 把剩余的部分直接接上
    if l1 is not None:
        current.next = l1
    if l2 is not None:
        current.next = l2

    return dummy.next  # 虚拟头节点的下一个就是真正的头节点
    # 时间复杂度：O(m + n)
    # 空间复杂度：O(1)

# 测试
# l1: 1 → 2 → 4
l1 = ListNode(1, ListNode(2, ListNode(4)))
# l2: 1 → 3 → 4
l2 = ListNode(1, ListNode(3, ListNode(4)))

result = mergeTwoLists(l1, l2)
# 结果：1 → 1 → 2 → 3 → 4 → 4
```

##### 例题3：判断链表是否有环（LeetCode 141）

**题目**：给定一个链表，判断链表中是否有环。

```python
def hasCycle(head):
    """
    判断链表是否有环（快慢指针法 / Floyd 判圈算法）
    
    思路：
    - 慢指针每次走1步，快指针每次走2步
    - 如果有环，快指针一定会追上慢指针（就像操场跑步，快的会套圈慢的）
    - 如果没环，快指针会先到达末尾
    
    类比：两个人在跑道上跑步，一个跑得快一个跑得慢。
    如果是环形跑道，快的迟早会追上慢的；
    如果是直线跑道，快的会先到终点。
    """
    if head is None:
        return False

    slow = head   # 慢指针，每次走1步
    fast = head   # 快指针，每次走2步

    while fast is not None and fast.next is not None:
        slow = slow.next          # 慢指针走1步
        fast = fast.next.next     # 快指针走2步

        if slow == fast:          # 快慢指针相遇，说明有环！
            return True

    return False  # 快指针到了末尾，没有环
    # 时间复杂度：O(n)
    # 空间复杂度：O(1)

# 测试：构造一个有环的链表
# 1 → 2 → 3 → 4 → 5
#             ↑         ↓
#             └─────────┘  （5指向3，形成环）
node1 = ListNode(1)
node2 = ListNode(2)
node3 = ListNode(3)
node4 = ListNode(4)
node5 = ListNode(5)
node1.next = node2
node2.next = node3
node3.next = node4
node4.next = node5
node5.next = node3  # 形成环！

print(hasCycle(node1))  # True
```

##### 例题4：链表的中间节点（LeetCode 876）

**题目**：给定一个非空单链表，返回它的中间节点。如果有两个中间节点，返回第二个。

```python
def middleNode(head):
    """
    找链表的中间节点（快慢指针法）
    
    思路：
    - 慢指针每次走1步，快指针每次走2步
    - 当快指针走到末尾时，慢指针刚好走到中间！
    
    类比：一根绳子对折，绳子头对齐后，折痕处就是中点。
    快指针走的速度是慢指针的2倍，所以快指针走完时，
    慢指针刚好走了一半。
    """
    slow = head
    fast = head

    while fast is not None and fast.next is not None:
        slow = slow.next          # 慢指针走1步
        fast = fast.next.next     # 快指针走2步

    # 当 fast 到达末尾时，slow 刚好在中间
    return slow
    # 时间复杂度：O(n)
    # 空间复杂度：O(1)

# 测试
# 1 → 2 → 3 → 4 → 5，中间节点是 3
head = ListNode(1, ListNode(2, ListNode(3, ListNode(4, ListNode(5)))))
mid = middleNode(head)
print(f"中间节点的值: {mid.val}")  # 3

# 1 → 2 → 3 → 4 → 5 → 6，中间节点是 4（两个中间节点取第二个）
head2 = ListNode(1, ListNode(2, ListNode(3, ListNode(4, ListNode(5, ListNode(6))))))
mid2 = middleNode(head2)
print(f"中间节点的值: {mid2.val}")  # 4
```

---

#### 九、链表相关技巧

##### 1. 虚拟头节点（Dummy Head）

**作用**：在头节点前加一个"假节点"，统一处理"可能修改头节点"的情况，避免大量的边界判断。

```python
# 没有 dummy head 时，删除节点要特殊处理头节点：
def delete_without_dummy(head, val):
    if head.val == val:       # 特殊处理头节点！
        return head.next
    # ... 其余逻辑

# 有 dummy head 时，所有节点的处理方式统一：
def delete_with_dummy(head, val):
    dummy = ListNode(0)       # 创建虚拟头节点
    dummy.next = head         # 虚拟头指向真正的头
    current = dummy

    while current.next:
        if current.next.val == val:
            current.next = current.next.next  # 跳过要删除的节点
        else:
            current = current.next

    return dummy.next         # 返回真正的头节点
```

**什么时候用 Dummy Head**：
- 链表操作可能涉及修改头节点时（如删除、反转）
- 合并链表时
- 任何你不想特殊处理头节点的场景

##### 2. 快慢指针

快慢指针是链表中最常用的技巧之一，核心思想是**两个指针以不同速度移动**。

| 场景 | 慢指针速度 | 快指针速度 | 结果 |
|------|-----------|-----------|------|
| 找中间节点 | 1步/次 | 2步/次 | 快指针到末尾时，慢指针在中间 |
| 判断环 | 1步/次 | 2步/次 | 有环则必相遇 |
| 找倒数第k个节点 | 先不动，等快指针走k步后再动 | 先走k步 | 快指针到末尾时，慢指针在倒数第k个 |

```python
# 扩展：找链表的倒数第 k 个节点
def findKthFromEnd(head, k):
    """
    找倒数第k个节点
    思路：快指针先走k步，然后快慢指针同时走，
    快指针到末尾时，慢指针就在倒数第k个位置
    """
    slow = head
    fast = head

    # 快指针先走 k 步
    for _ in range(k):
        if fast is None:
            return None  # k 超出链表长度
        fast = fast.next

    # 然后快慢指针一起走
    while fast is not None:
        slow = slow.next
        fast = fast.next

    return slow  # 慢指针此时在倒数第k个位置
```

---

---


### 主题4 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、单链表节点类

```typescript
// ========== 链表节点类 ==========
class ListNode {
  val: number;
  next: ListNode | null;

  constructor(val: number = 0, next: ListNode | null = null) {
    this.val = val;      // 节点存储的值
    this.next = next;    // 指向下一个节点
  }
}

// 创建节点
const node1 = new ListNode(12);
const node2 = new ListNode(45);
const node3 = new ListNode(7);

// 把节点串起来：node1 → node2 → node3
node1.next = node2;
node2.next = node3;
```

##### 二、完整链表类及基本操作

```typescript
// ========== 单链表的完整实现 ==========
class LinkedList {
  head: ListNode | null;

  constructor() {
    this.head = null;  // 初始化空链表，头指针为 null
  }

  // 1. 遍历链表 O(n)
  traverse(): number[] {
    const result: number[] = [];
    let current = this.head;  // 从头节点开始
    while (current !== null) {
      result.push(current.val);
      current = current.next;  // 走向下一个节点
    }
    return result;
  }

  // 2. 头部插入 O(1)
  insertAtHead(val: number): void {
    const newNode = new ListNode(val);   // 创建新节点
    newNode.next = this.head;            // 新节点指向原来的头节点
    this.head = newNode;                 // 头指针更新为新节点
  }

  // 3. 尾部插入 O(n)
  insertAtTail(val: number): void {
    const newNode = new ListNode(val);

    // 如果链表为空，新节点直接成为头节点
    if (this.head === null) {
      this.head = newNode;
      return;
    }

    // 走到最后一个节点
    let current = this.head;
    while (current.next !== null) {
      current = current.next;
    }
    current.next = newNode;  // 最后一个节点指向新节点
  }

  // 4. 指定位置插入 O(n)
  insertAt(index: number, val: number): void {
    // 在头部插入，特殊处理
    if (index === 0) {
      this.insertAtHead(val);
      return;
    }

    // 走到 index-1 位置
    let current = this.head;
    for (let i = 0; i < index - 1; i++) {
      if (current === null) throw new Error("插入位置超出链表范围");
      current = current.next;
    }
    if (current === null) throw new Error("插入位置超出链表范围");

    // 插入操作（注意顺序！先连新节点，再改前驱节点）
    const newNode = new ListNode(val);
    newNode.next = current.next;  // 新节点先拉住后面的人
    current.next = newNode;       // 前面的人改拉新节点
  }

  // 5. 删除节点 O(n)
  delete(val: number): boolean {
    if (this.head === null) return false;  // 链表为空

    // 如果要删除的是头节点
    if (this.head.val === val) {
      this.head = this.head.next;  // 头指针后移
      return true;
    }

    // 找要删除的节点的前驱
    let current = this.head;
    while (current.next !== null) {
      if (current.next.val === val) {
        current.next = current.next.next;  // 跳过要删除的节点
        return true;
      }
      current = current.next;
    }
    return false;  // 没找到
  }

  // 6. 查找节点 O(n)
  search(val: number): number {
    let current = this.head;
    let index = 0;
    while (current !== null) {
      if (current.val === val) return index;
      current = current.next;
      index++;
    }
    return -1;
  }
}

// ========== 测试代码 ==========
const ll = new LinkedList();

// 尾部插入
ll.insertAtTail(10);
ll.insertAtTail(20);
ll.insertAtTail(30);
console.log("尾部插入后:", ll.traverse());  // [10, 20, 30]

// 头部插入
ll.insertAtHead(5);
console.log("头部插入后:", ll.traverse());  // [5, 10, 20, 30]

// 指定位置插入
ll.insertAt(2, 15);
console.log("位置2插入15后:", ll.traverse());  // [5, 10, 15, 20, 30]

// 查找
console.log("查找20:", ll.search(20));  // 3
console.log("查找99:", ll.search(99));  // -1

// 删除
ll.delete(15);
console.log("删除15后:", ll.traverse());  // [5, 10, 20, 30]

ll.delete(5);  // 删除头节点
console.log("删除头节点后:", ll.traverse());  // [10, 20, 30]
```

##### 三、双链表

```typescript
// ========== 双链表节点 ==========
class DoublyListNode {
  val: number;
  prev: DoublyListNode | null;
  next: DoublyListNode | null;

  constructor(
    val: number = 0,
    prev: DoublyListNode | null = null,
    next: DoublyListNode | null = null
  ) {
    this.val = val;
    this.prev = prev;  // 前驱指针
    this.next = next;  // 后继指针
  }
}

// ========== 双链表实现 ==========
class DoublyLinkedList {
  head: DoublyListNode | null;
  tail: DoublyListNode | null;  // 维护尾指针，尾部插入变为 O(1)

  constructor() {
    this.head = null;
    this.tail = null;
  }

  // 头部插入 O(1)
  insertAtHead(val: number): void {
    const newNode = new DoublyListNode(val);
    if (this.head === null) {
      this.head = this.tail = newNode;
    } else {
      newNode.next = this.head;
      this.head.prev = newNode;
      this.head = newNode;
    }
  }

  // 尾部插入 O(1)（因为有 tail 指针）
  insertAtTail(val: number): void {
    const newNode = new DoublyListNode(val);
    if (this.tail === null) {
      this.head = this.tail = newNode;
    } else {
      newNode.prev = this.tail;
      this.tail.next = newNode;
      this.tail = newNode;
    }
  }

  // 删除指定节点 O(1)（如果已经拿到了该节点的引用）
  deleteNode(node: DoublyListNode): void {
    if (node.prev) {
      node.prev.next = node.next;
    } else {
      this.head = node.next;  // 删除的是头节点
    }

    if (node.next) {
      node.next.prev = node.prev;
    } else {
      this.tail = node.prev;  // 删除的是尾节点
    }
  }

  // 正向遍历
  traverseForward(): number[] {
    const result: number[] = [];
    let current = this.head;
    while (current) {
      result.push(current.val);
      current = current.next;
    }
    return result;
  }

  // 反向遍历（双链表独有！）
  traverseBackward(): number[] {
    const result: number[] = [];
    let current = this.tail;
    while (current) {
      result.push(current.val);
      current = current.prev;
    }
    return result;
  }
}

// 测试
const dll = new DoublyLinkedList();
dll.insertAtHead(10);
dll.insertAtHead(5);
dll.insertAtTail(20);
dll.insertAtTail(30);
console.log("正向:", dll.traverseForward());   // [5, 10, 20, 30]
console.log("反向:", dll.traverseBackward());  // [30, 20, 10, 5]
```

##### 四、循环链表

```typescript
// ========== 循环链表简介实现 ==========
class CircularLinkedList {
  head: ListNode | null;

  constructor() {
    this.head = null;
  }

  // 在循环链表尾部添加节点
  append(val: number): void {
    const newNode = new ListNode(val);
    if (this.head === null) {
      this.head = newNode;
      newNode.next = this.head;  // 自己指向自己
      return;
    }

    let current = this.head;
    while (current.next !== this.head) {  // 找到最后一个节点
      current = current.next;
    }
    current.next = newNode;
    newNode.next = this.head;  // 尾节点指向头节点
  }

  // 遍历循环链表（只走一圈）
  traverse(): number[] {
    if (this.head === null) return [];
    const result: number[] = [];
    let current = this.head;
    while (true) {
      result.push(current.val);
      current = current.next!;
      if (current === this.head) break;  // 回到起点就停止
    }
    return result;
  }
}

// 测试
const cll = new CircularLinkedList();
for (const val of [1, 2, 3, 4]) cll.append(val);
console.log("循环链表:", cll.traverse());  // [1, 2, 3, 4]
```

##### 五、经典例题

```typescript
// ========== 例题1：反转链表（LeetCode 206）==========

// 方法一：迭代法
function reverseList(head: ListNode | null): ListNode | null {
  let prev: ListNode | null = null;  // 新链表的前一个节点
  let curr: ListNode | null = head;  // 当前要处理的节点

  while (curr !== null) {
    const nextTemp = curr.next;  // 先暂存下一个节点
    curr.next = prev;            // 反转！当前节点指向前一个节点
    prev = curr;                 // prev 前进一步
    curr = nextTemp;             // curr 前进一步
  }
  return prev;  // 循环结束时，prev 指向新的头节点
  // 时间复杂度：O(n)  空间复杂度：O(1)
}

// 方法二：递归法
function reverseListRecursive(head: ListNode | null): ListNode | null {
  // 递归终止条件：空链表或只有一个节点
  if (head === null || head.next === null) return head;

  // 递归反转后面的部分
  const newHead = reverseListRecursive(head.next);

  // 把当前节点接到反转后链表的末尾
  head.next.next = head;
  head.next = null;  // 当前节点变成尾节点

  return newHead;
  // 时间复杂度：O(n)  空间复杂度：O(n)（递归调用栈）
}

// ========== 例题2：合并两个有序链表（LeetCode 21）==========
function mergeTwoLists(
  l1: ListNode | null,
  l2: ListNode | null
): ListNode | null {
  const dummy = new ListNode(0);  // 虚拟头节点，简化边界处理
  let current = dummy;

  while (l1 !== null && l2 !== null) {
    if (l1.val <= l2.val) {
      current.next = l1;  // 接上 l1 的当前节点
      l1 = l1.next;
    } else {
      current.next = l2;  // 接上 l2 的当前节点
      l2 = l2.next;
    }
    current = current.next;
  }

  // 把剩余的部分直接接上
  if (l1 !== null) current.next = l1;
  if (l2 !== null) current.next = l2;

  return dummy.next;  // 虚拟头节点的下一个就是真正的头节点
  // 时间复杂度：O(m + n)  空间复杂度：O(1)
}

// ========== 例题3：判断链表是否有环（LeetCode 141）==========
// 快慢指针法 / Floyd 判圈算法
function hasCycle(head: ListNode | null): boolean {
  if (head === null) return false;

  let slow: ListNode | null = head;  // 慢指针，每次走1步
  let fast: ListNode | null = head;  // 快指针，每次走2步

  while (fast !== null && fast.next !== null) {
    slow = slow!.next;          // 慢指针走1步
    fast = fast.next.next;      // 快指针走2步
    if (slow === fast) return true;  // 快慢指针相遇，说明有环！
  }
  return false;  // 快指针到了末尾，没有环
  // 时间复杂度：O(n)  空间复杂度：O(1)
}

// ========== 例题4：链表的中间节点（LeetCode 876）==========
function middleNode(head: ListNode | null): ListNode | null {
  let slow: ListNode | null = head;
  let fast: ListNode | null = head;

  while (fast !== null && fast.next !== null) {
    slow = slow!.next;      // 慢指针走1步
    fast = fast.next.next;  // 快指针走2步
  }
  return slow;  // 当 fast 到达末尾时，slow 刚好在中间
  // 时间复杂度：O(n)  空间复杂度：O(1)
}

// 测试：1 → 2 → 3 → 4 → 5，中间节点是 3
const h1 = new ListNode(1, new ListNode(2, new ListNode(3, new ListNode(4, new ListNode(5)))));
console.log(`中间节点的值: ${middleNode(h1)!.val}`);  // 3
```

##### 六、链表相关技巧

```typescript
// ========== 1. 虚拟头节点（Dummy Head）==========
function deleteWithDummy(head: ListNode | null, val: number): ListNode | null {
  const dummy = new ListNode(0);  // 创建虚拟头节点
  dummy.next = head;              // 虚拟头指向真正的头
  let current: ListNode | null = dummy;

  while (current.next !== null) {
    if (current.next.val === val) {
      current.next = current.next.next;  // 跳过要删除的节点
    } else {
      current = current.next;
    }
  }
  return dummy.next;  // 返回真正的头节点
}

// ========== 2. 找链表的倒数第 k 个节点 ==========
function findKthFromEnd(head: ListNode | null, k: number): ListNode | null {
  let slow: ListNode | null = head;
  let fast: ListNode | null = head;

  // 快指针先走 k 步
  for (let i = 0; i < k; i++) {
    if (fast === null) return null;  // k 超出链表长度
    fast = fast.next;
  }

  // 然后快慢指针一起走
  while (fast !== null) {
    slow = slow!.next;
    fast = fast.next;
  }
  return slow;  // 慢指针此时在倒数第k个位置
}
```

### 主题4 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、单链表节点类

```go
package main

import "fmt"

// ========== 链表节点 ==========
// Go 用结构体 + 指针实现节点
type ListNode struct {
	Val  int
	Next *ListNode
}

// 构造函数：Go 没有默认参数，用函数创建节点
func NewListNode(val int, next *ListNode) *ListNode {
	return &ListNode{Val: val, Next: next}
}

// 创建节点
func testNodes() {
	node1 := NewListNode(12, nil)
	node2 := NewListNode(45, nil)
	node3 := NewListNode(7, nil)

	// 把节点串起来：node1 → node2 → node3
	node1.Next = node2
	node2.Next = node3

	// 现在 node1 就是链表的头节点
	fmt.Println(node1.Val, node1.Next.Val, node1.Next.Next.Val) // 12 45 7
}
```

##### 二、完整链表类及基本操作

```go
package main

import "fmt"

// ========== 单链表的完整实现 ==========
type LinkedList struct {
	head *ListNode
}

func NewLinkedList() *LinkedList {
	return &LinkedList{head: nil}
}

// 1. 遍历链表 O(n)
func (ll *LinkedList) Traverse() []int {
	result := []int{}
	current := ll.head // 从头节点开始
	for current != nil {
		result = append(result, current.Val)
		current = current.Next // 走向下一个节点
	}
	return result
}

// 2. 头部插入 O(1)
func (ll *LinkedList) InsertAtHead(val int) {
	newNode := NewListNode(val, nil) // 创建新节点
	newNode.Next = ll.head           // 新节点指向原来的头节点
	ll.head = newNode                // 头指针更新为新节点
}

// 3. 尾部插入 O(n)
func (ll *LinkedList) InsertAtTail(val int) {
	newNode := NewListNode(val, nil)

	// 如果链表为空，新节点直接成为头节点
	if ll.head == nil {
		ll.head = newNode
		return
	}

	// 走到最后一个节点
	current := ll.head
	for current.Next != nil {
		current = current.Next
	}
	current.Next = newNode // 最后一个节点指向新节点
}

// 4. 指定位置插入 O(n)
func (ll *LinkedList) InsertAt(index, val int) {
	// 在头部插入，特殊处理
	if index == 0 {
		ll.InsertAtHead(val)
		return
	}

	// 走到 index-1 位置
	current := ll.head
	for i := 0; i < index-1; i++ {
		if current == nil {
			panic("插入位置超出链表范围")
		}
		current = current.Next
	}
	if current == nil {
		panic("插入位置超出链表范围")
	}

	// 插入操作（注意顺序！先连新节点，再改前驱节点）
	newNode := NewListNode(val, nil)
	newNode.Next = current.Next // 新节点先拉住后面的人
	current.Next = newNode      // 前面的人改拉新节点
}

// 5. 删除节点 O(n)
func (ll *LinkedList) Delete(val int) bool {
	if ll.head == nil {
		return false // 链表为空
	}

	// 如果要删除的是头节点
	if ll.head.Val == val {
		ll.head = ll.head.Next // 头指针后移
		return true
	}

	// 找要删除的节点的前驱
	current := ll.head
	for current.Next != nil {
		if current.Next.Val == val {
			current.Next = current.Next.Next // 跳过要删除的节点
			return true
		}
		current = current.Next
	}
	return false // 没找到
}

// 6. 查找节点 O(n)
func (ll *LinkedList) Search(val int) int {
	current := ll.head
	index := 0
	for current != nil {
		if current.Val == val {
			return index
		}
		current = current.Next
		index++
	}
	return -1
}

func testLinkedList() {
	// ========== 测试代码 ==========
	ll := NewLinkedList()

	// 尾部插入
	ll.InsertAtTail(10)
	ll.InsertAtTail(20)
	ll.InsertAtTail(30)
	fmt.Println("尾部插入后:", ll.Traverse()) // [10 20 30]

	// 头部插入
	ll.InsertAtHead(5)
	fmt.Println("头部插入后:", ll.Traverse()) // [5 10 20 30]

	// 指定位置插入
	ll.InsertAt(2, 15)
	fmt.Println("位置2插入15后:", ll.Traverse()) // [5 10 15 20 30]

	// 查找
	fmt.Println("查找20:", ll.Search(20)) // 3
	fmt.Println("查找99:", ll.Search(99)) // -1

	// 删除
	ll.Delete(15)
	fmt.Println("删除15后:", ll.Traverse()) // [5 10 20 30]

	ll.Delete(5) // 删除头节点
	fmt.Println("删除头节点后:", ll.Traverse()) // [10 20 30]
}
```

##### 三、双链表

```go
package main

import "fmt"

// ========== 双链表节点 ==========
type DoublyListNode struct {
	Val  int
	Prev *DoublyListNode // 前驱指针
	Next *DoublyListNode // 后继指针
}

func NewDoublyListNode(val int) *DoublyListNode {
	return &DoublyListNode{Val: val}
}

// ========== 双链表实现 ==========
type DoublyLinkedList struct {
	head *DoublyListNode
	tail *DoublyListNode // 维护尾指针，尾部插入变为 O(1)
}

func NewDoublyLinkedList() *DoublyLinkedList {
	return &DoublyLinkedList{}
}

// 头部插入 O(1)
func (dll *DoublyLinkedList) InsertAtHead(val int) {
	newNode := NewDoublyListNode(val)
	if dll.head == nil {
		dll.head = newNode
		dll.tail = newNode
	} else {
		newNode.Next = dll.head
		dll.head.Prev = newNode
		dll.head = newNode
	}
}

// 尾部插入 O(1)（因为有 tail 指针）
func (dll *DoublyLinkedList) InsertAtTail(val int) {
	newNode := NewDoublyListNode(val)
	if dll.tail == nil {
		dll.head = newNode
		dll.tail = newNode
	} else {
		newNode.Prev = dll.tail
		dll.tail.Next = newNode
		dll.tail = newNode
	}
}

// 删除指定节点 O(1)（如果已经拿到了该节点的引用）
func (dll *DoublyLinkedList) DeleteNode(node *DoublyListNode) {
	if node.Prev != nil {
		node.Prev.Next = node.Next
	} else {
		dll.head = node.Next // 删除的是头节点
	}

	if node.Next != nil {
		node.Next.Prev = node.Prev
	} else {
		dll.tail = node.Prev // 删除的是尾节点
	}
}

// 正向遍历
func (dll *DoublyLinkedList) TraverseForward() []int {
	result := []int{}
	current := dll.head
	for current != nil {
		result = append(result, current.Val)
		current = current.Next
	}
	return result
}

// 反向遍历（双链表独有！）
func (dll *DoublyLinkedList) TraverseBackward() []int {
	result := []int{}
	current := dll.tail
	for current != nil {
		result = append(result, current.Val)
		current = current.Prev
	}
	return result
}

func testDoublyLinkedList() {
	// 测试
	dll := NewDoublyLinkedList()
	dll.InsertAtHead(10)
	dll.InsertAtHead(5)
	dll.InsertAtTail(20)
	dll.InsertAtTail(30)
	fmt.Println("正向:", dll.TraverseForward())  // [5 10 20 30]
	fmt.Println("反向:", dll.TraverseBackward()) // [30 20 10 5]
}
```

##### 四、循环链表

```go
package main

import "fmt"

// ========== 循环链表简介实现 ==========
type CircularLinkedList struct {
	head *ListNode
}

func NewCircularLinkedList() *CircularLinkedList {
	return &CircularLinkedList{}
}

// 在循环链表尾部添加节点
func (cll *CircularLinkedList) Append(val int) {
	newNode := NewListNode(val, nil)
	if cll.head == nil {
		cll.head = newNode
		newNode.Next = cll.head // 自己指向自己
		return
	}

	current := cll.head
	for current.Next != cll.head { // 找到最后一个节点
		current = current.Next
	}

	current.Next = newNode
	newNode.Next = cll.head // 尾节点指向头节点
}

// 遍历循环链表（只走一圈）
func (cll *CircularLinkedList) Traverse() []int {
	if cll.head == nil {
		return []int{}
	}
	result := []int{}
	current := cll.head
	for {
		result = append(result, current.Val)
		current = current.Next
		if current == cll.head { // 回到起点就停止
			break
		}
	}
	return result
}

func testCircularLinkedList() {
	// 测试
	cll := NewCircularLinkedList()
	for _, val := range []int{1, 2, 3, 4} {
		cll.Append(val)
	}
	fmt.Println("循环链表:", cll.Traverse()) // [1 2 3 4]
}
```

##### 五、经典例题

```go
package main

import "fmt"

// ========== 例题1：反转链表（LeetCode 206）==========

// 方法一：迭代法
func ReverseList(head *ListNode) *ListNode {
	var prev *ListNode = nil // 新链表的前一个节点
	curr := head             // 当前要处理的节点

	for curr != nil {
		nextTemp := curr.Next // 先暂存下一个节点
		curr.Next = prev      // 反转！当前节点指向前一个节点
		prev = curr           // prev 前进一步
		curr = nextTemp       // curr 前进一步
	}
	return prev // 循环结束时，prev 指向新的头节点
	// 时间复杂度：O(n)  空间复杂度：O(1)
}

// 方法二：递归法
func ReverseListRecursive(head *ListNode) *ListNode {
	// 递归终止条件：空链表或只有一个节点
	if head == nil || head.Next == nil {
		return head
	}

	// 递归反转后面的部分
	newHead := ReverseListRecursive(head.Next)

	// 把当前节点接到反转后链表的末尾
	head.Next.Next = head
	head.Next = nil // 当前节点变成尾节点

	return newHead
	// 时间复杂度：O(n)  空间复杂度：O(n)（递归调用栈）
}

// ========== 例题2：合并两个有序链表（LeetCode 21）==========
func MergeTwoLists(l1, l2 *ListNode) *ListNode {
	dummy := NewListNode(0, nil) // 虚拟头节点，简化边界处理
	current := dummy

	for l1 != nil && l2 != nil {
		if l1.Val <= l2.Val {
			current.Next = l1 // 接上 l1 的当前节点
			l1 = l1.Next
		} else {
			current.Next = l2 // 接上 l2 的当前节点
			l2 = l2.Next
		}
		current = current.Next
	}

	// 把剩余的部分直接接上
	if l1 != nil {
		current.Next = l1
	}
	if l2 != nil {
		current.Next = l2
	}

	return dummy.Next // 虚拟头节点的下一个就是真正的头节点
	// 时间复杂度：O(m + n)  空间复杂度：O(1)
}

// ========== 例题3：判断链表是否有环（LeetCode 141）==========
// 快慢指针法 / Floyd 判圈算法
func HasCycle(head *ListNode) bool {
	if head == nil {
		return false
	}

	slow := head // 慢指针，每次走1步
	fast := head // 快指针，每次走2步

	for fast != nil && fast.Next != nil {
		slow = slow.Next     // 慢指针走1步
		fast = fast.Next.Next // 快指针走2步
		if slow == fast {     // 快慢指针相遇，说明有环！
			return true
		}
	}
	return false // 快指针到了末尾，没有环
	// 时间复杂度：O(n)  空间复杂度：O(1)
}

// ========== 例题4：链表的中间节点（LeetCode 876）==========
func MiddleNode(head *ListNode) *ListNode {
	slow := head
	fast := head

	for fast != nil && fast.Next != nil {
		slow = slow.Next     // 慢指针走1步
		fast = fast.Next.Next // 快指针走2步
	}
	return slow // 当 fast 到达末尾时，slow 刚好在中间
	// 时间复杂度：O(n)  空间复杂度：O(1)
}

func testExamples() {
	// 测试：1 → 2 → 3 → 4 → 5，中间节点是 3
	h1 := NewListNode(1, NewListNode(2, NewListNode(3, NewListNode(4, NewListNode(5, nil)))))
	fmt.Printf("中间节点的值: %d\n", MiddleNode(h1).Val) // 3
}
```

##### 六、链表相关技巧

```go
package main

// ========== 1. 虚拟头节点（Dummy Head）==========
func DeleteWithDummy(head *ListNode, val int) *ListNode {
	dummy := NewListNode(0, nil) // 创建虚拟头节点
	dummy.Next = head            // 虚拟头指向真正的头
	current := dummy

	for current.Next != nil {
		if current.Next.Val == val {
			current.Next = current.Next.Next // 跳过要删除的节点
		} else {
			current = current.Next
		}
	}
	return dummy.Next // 返回真正的头节点
}

// ========== 2. 找链表的倒数第 k 个节点 ==========
func FindKthFromEnd(head *ListNode, k int) *ListNode {
	slow := head
	fast := head

	// 快指针先走 k 步
	for i := 0; i < k; i++ {
		if fast == nil {
			return nil // k 超出链表长度
		}
		fast = fast.Next
	}

	// 然后快慢指针一起走
	for fast != nil {
		slow = slow.Next
		fast = fast.Next
	}
	return slow // 慢指针此时在倒数第k个位置
}
```

---

### 主题5：栈（Stack）


#### 一、栈的概念

##### 用"一摞盘子"来类比

想象厨房里的**一摞盘子**：

```
      ┌─────────┐
      │  盘子D  │  ← 最后放上去的（栈顶）
      ├─────────┤
      │  盘子C  │
      ├─────────┤
      │  盘子B  │
      ├─────────┤
      │  盘子A  │  ← 最先放进去的（栈底）
      └─────────┘
```

- 放盘子时，只能**从顶部放上去**（push）
- 取盘子时，只能**从顶部拿走**（pop）
- 你**不能直接从中间抽**一个盘子（会塌！）
- 最后放上去的盘子，最先被拿走 → **后进先出（LIFO）**

---

#### 二、LIFO（后进先出）原则详解

**后进先出（Last In, First Out）** 是栈最核心的特性：

```
操作顺序：
push(A)  →  栈：[A]
push(B)  →  栈：[A, B]
push(C)  →  栈：[A, B, C]
pop()    →  取出 C（最后进的，最先出）
pop()    →  取出 B
pop()    →  取出 A（最先进去的，最后出来）
```

**生活中的 LIFO 例子**：
- 浏览器的前进/后退按钮
- 编辑器的撤销（Ctrl+Z）
- 叠放的书籍（最后放上去的最先拿走）
- 死胡同（最后进去的车最先出来）

---

#### 三、基本操作

| 操作 | 说明 | 时间复杂度 |
|------|------|-----------|
| `push(item)` | 将元素压入栈顶 | O(1) |
| `pop()` | 弹出并返回栈顶元素 | O(1) |
| `peek()` / `top()` | 查看栈顶元素但不弹出 | O(1) |
| `is_empty()` | 判断栈是否为空 | O(1) |
| `size()` | 返回栈中元素个数 | O(1) |

> **注意**：栈**不允许**访问中间元素或底部元素，只能操作栈顶。

---

#### 四、Python 实现栈

##### 方式一：用 list 实现（最常用）

```python
class StackByList:
    """用 Python list 实现栈（推荐方式，最常用）"""

    def __init__(self):
        self._data = []  # 用 list 作为底层存储

    def push(self, item):
        """压入栈顶：在 list 末尾添加元素"""
        self._data.append(item)
        # list.append() 是均摊 O(1)

    def pop(self):
        """弹出栈顶：移除并返回 list 末尾的元素"""
        if self.is_empty():
            raise IndexError("pop from empty stack")
        return self._data.pop()
        # list.pop() 是 O(1)

    def peek(self):
        """查看栈顶元素：查看 list 末尾的元素"""
        if self.is_empty():
            raise IndexError("peek from empty stack")
        return self._data[-1]
        # 访问最后一个元素是 O(1)

    def is_empty(self):
        """判断栈是否为空"""
        return len(self._data) == 0

    def size(self):
        """返回栈的大小"""
        return len(self._data)

    def __str__(self):
        """方便打印，栈底在左，栈顶在右"""
        return f"Stack(bottom → top): {self._data}"
```

##### 方式二：用链表实现

```python
class StackByLinkedList:
    """用链表实现栈（头插法，栈顶在链表头部）"""

    def __init__(self):
        self._head = None  # 头指针即栈顶
        self._size = 0

    def push(self, item):
        """压入栈顶：在链表头部插入"""
        new_node = ListNode(item)
        new_node.next = self._head
        self._head = new_node
        self._size += 1
        # O(1)：头插不需要遍历

    def pop(self):
        """弹出栈顶：删除链表头节点"""
        if self.is_empty():
            raise IndexError("pop from empty stack")
        val = self._head.val
        self._head = self._head.next
        self._size -= 1
        return val
        # O(1)：删除头节点不需要遍历

    def peek(self):
        """查看栈顶：返回头节点的值"""
        if self.is_empty():
            raise IndexError("peek from empty stack")
        return self._head.val
        # O(1)

    def is_empty(self):
        return self._head is None

    def size(self):
        return self._size
```

##### 两种实现对比

| 对比项 | list 实现 | 链表实现 |
|--------|----------|---------|
| 所有操作 | 均摊 O(1) | 严格 O(1) |
| 内存 | 连续内存，缓存友好 | 离散内存，额外指针开销 |
| 实际使用 | **最常用**，Pythonic | 面试中可能考 |
| 扩容 | 有扩容开销（均摊后无影响） | 无需扩容 |

---

#### 五、栈的复杂度分析

无论用 list 还是链表实现，栈的所有基本操作都是 **O(1)**：

```
push   → O(1)  ← 只在栈顶操作，不需要遍历
pop    → O(1)  ← 只在栈顶操作
peek   → O(1)  ← 只看栈顶
is_empty → O(1)
size   → O(1)
```

**这就是栈的精妙之处**：通过限制只能在栈顶操作，换来了所有操作 O(1) 的高效。

---

#### 六、栈的经典应用

##### 1. 括号匹配

**场景**：检查代码中的括号是否正确配对。

```python
def is_valid_parentheses(s):
    """
    括号匹配：检查括号是否合法
    
    思路：
    - 遇到左括号 → 压入栈（"我等你回来配对"）
    - 遇到右括号 → 弹出栈顶，检查是否匹配
    - 最后栈为空 → 全部配对成功
    
    类比：你穿脱衣服的顺序
    穿：内衣→毛衣→外套（push, push, push）
    脱：外套→毛衣→内衣（pop, pop, pop）
    必须按相反的顺序！
    """
    stack = []
    # 用字典存储匹配关系
    matching = {')': '(', ']': '[', '}': '{'}

    for char in s:
        if char in '([{':
            # 左括号：压入栈
            stack.append(char)
        elif char in ')]}':
            # 右括号：检查栈顶是否匹配
            if not stack:
                return False  # 没有左括号来配对
            top = stack.pop()
            if matching[char] != top:
                return False  # 不匹配！比如 "(]"

    # 最后栈必须为空（所有左括号都被配对了）
    return len(stack) == 0

# 测试
print(is_valid_parentheses("()"))          # True
print(is_valid_parentheses("()[]{}"))      # True
print(is_valid_parentheses("(]"))          # False
print(is_valid_parentheses("([)]"))        # False
print(is_valid_parentheses("{[()]}"))      # True
print(is_valid_parentheses("((()))"))      # True
```

##### 2. 浏览器前进后退模拟

```python
class BrowserHistory:
    """
    模拟浏览器的前进/后退功能
    
    思路：用两个栈
    - back_stack：保存"后退"历史（当前页面在栈顶）
    - forward_stack：保存"前进"历史
    
    类比：两摞纸牌
    - 访问新页面：把当前页面压入后退栈，清空前进栈
    - 后退：从后退栈弹出，压入前进栈
    - 前进：从前进栈弹出，压入后退栈
    """
    def __init__(self, homepage):
        self.back_stack = [homepage]   # 后退栈
        self.forward_stack = []        # 前进栈

    def visit(self, url):
        """访问新页面"""
        self.back_stack.append(url)    # 当前页面压入后退栈
        self.forward_stack.clear()     # 清空前进栈（不能前进了）
        print(f"访问: {url}")

    def back(self, steps):
        """后退 steps 步"""
        for _ in range(steps):
            if len(self.back_stack) <= 1:
                break  # 已经退到首页了
            page = self.back_stack.pop()
            self.forward_stack.append(page)
        print(f"后退到: {self.back_stack[-1]}")
        return self.back_stack[-1]

    def forward(self, steps):
        """前进 steps 步"""
        for _ in range(steps):
            if not self.forward_stack:
                break  # 没有可以前进的页面了
            page = self.forward_stack.pop()
            self.back_stack.append(page)
        print(f"前进到: {self.back_stack[-1]}")
        return self.back_stack[-1]

# 测试
browser = BrowserHistory("homepage.com")
browser.visit("google.com")
browser.visit("github.com")
browser.back(1)       # 后退到 google.com
browser.forward(1)    # 前进到 github.com
browser.visit("leetcode.com")  # 访问新页面，前进历史清空
```

##### 3. 表达式求值（后缀表达式）

```python
def eval_rpn(tokens):
    """
    后缀表达式求值（逆波兰表达式）
    
    后缀表达式：运算符写在操作数后面
    例如：(3 + 4) * 5 → 后缀：3 4 + 5 *
    
    思路：
    - 遇到数字 → 压入栈
    - 遇到运算符 → 弹出两个数，计算，结果压回栈
    
    类比：做菜时把食材排成一排，遇到操作符就把需要的食材拿来加工
    """
    stack = []

    for token in tokens:
        if token not in "+-*/":
            # 数字：压入栈
            stack.append(int(token))
        else:
            # 运算符：弹出两个操作数
            b = stack.pop()  # 第二个操作数（后入先出）
            a = stack.pop()  # 第一个操作数

            # 计算
            if token == '+':
                stack.append(a + b)
            elif token == '-':
                stack.append(a - b)
            elif token == '*':
                stack.append(a * b)
            elif token == '/':
                stack.append(int(a / b))  # 向零取整

    return stack[0]  # 最后栈里只剩一个元素，就是结果

# 测试
# (3 + 4) * 5 = 35
print(eval_rpn(["3", "4", "+", "5", "*"]))  # 35

# (10 - 6) * (9 + 3) = 48
print(eval_rpn(["10", "6", "-", "9", "3", "+", "*"]))  # 48
```

##### 4. 函数调用栈原理

```python
"""
函数调用栈（Call Stack）是栈最经典的应用之一。

当你调用一个函数时，Python 会把当前函数的状态（局部变量、执行位置等）
压入调用栈。函数返回时，再从栈中弹出。

示例代码：
"""

def greet(name):
    print(f"Hello, {name}!")
    beep()          # 调用 beep()
    print("Done!")

def beep():
    print("Beep!")

# 调用 greet("Alice") 时，调用栈的变化：

# 1. 调用 greet("Alice")
#    栈：[greet]
#    执行 print(f"Hello, {name}!")  → 输出 "Hello, Alice!"

# 2. greet 中调用 beep()
#    栈：[greet, beep]    ← beep 压入栈顶
#    执行 print("Beep!")  → 输出 "Beep!"

# 3. beep() 返回
#    栈：[greet]          ← beep 从栈顶弹出
#    继续执行 greet 中剩余的代码

# 4. greet() 返回
#    栈：[]               ← greet 从栈顶弹出
#    程序结束

# 这就是为什么递归太深会导致 "Stack Overflow"（栈溢出）！
# 每次递归调用都会在栈中新增一层，层数太多栈就满了。

greet("Alice")
```

---

#### 七、经典例题

##### 例题1：有效的括号（LeetCode 20）

```python
def isValid(s):
    """
    有效的括号（LeetCode 20）
    
    和上面的括号匹配是同一题，这里再给一个更清晰的版本
    """
    stack = []
    pairs = {')': '(', ']': '[', '}': '{'}

    for ch in s:
        if ch in pairs:  # 右括号
            # 栈为空或栈顶不匹配 → 无效
            if not stack or stack[-1] != pairs[ch]:
                return False
            stack.pop()  # 匹配成功，弹出栈顶
        else:            # 左括号
            stack.append(ch)

    return len(stack) == 0  # 栈为空说明全部配对

# 测试
print(isValid("()"))         # True
print(isValid("()[]{}"))     # True
print(isValid("(]"))         # False
print(isValid("([)]"))       # False
print(isValid("{[]}"))       # True
```

##### 例题2：最小栈（LeetCode 155）

**题目**：设计一个支持 push、pop、top 操作，并能在 **O(1)** 时间内检索到最小元素的栈。

```python
class MinStack:
    """
    最小栈：能在 O(1) 时间内获取栈中最小元素
    
    思路：用两个栈
    - 主栈：正常存储所有元素
    - 辅助栈（min_stack）：栈顶始终是当前主栈中的最小值
    
    关键：每次 push 时，min_stack 压入"当前最小值"
    （新元素和旧的最小值比较，取较小的那个）
    
    类比：你不仅记录每天的体重，还额外维护一个"历史最轻体重"的记录本。
    每次称重后，更新记录本上的最小值。
    """
    def __init__(self):
        self.stack = []       # 主栈
        self.min_stack = []   # 辅助栈：存最小值

    def push(self, val):
        self.stack.append(val)
        # 辅助栈：压入当前最小值
        if not self.min_stack:
            self.min_stack.append(val)
        else:
            # 取新元素和当前最小值中较小的那个
            self.min_stack.append(min(val, self.min_stack[-1]))

    def pop(self):
        self.stack.pop()
        self.min_stack.pop()  # 辅助栈同步弹出

    def top(self):
        return self.stack[-1]

    def getMin(self):
        """O(1) 获取最小值：直接看辅助栈栈顶"""
        return self.min_stack[-1]

# 测试
min_stack = MinStack()
min_stack.push(-2)
min_stack.push(0)
min_stack.push(-3)
print(min_stack.getMin())  # -3
min_stack.pop()
print(min_stack.top())     # 0
print(min_stack.getMin())  # -2
```

##### 例题3：用两个栈实现队列

**题目**：用两个栈实现一个队列，支持 push（入队）和 pop（出队）操作。

```python
class MyQueue:
    """
    用两个栈实现队列
    
    思路：
    - 栈A（in_stack）：负责接收新元素（入队）
    - 栈B（out_stack）：负责输出元素（出队）
    
    入队：直接压入栈A
    出队：如果栈B为空，把栈A的元素全部弹出并压入栈B，
          然后从栈B弹出栈顶元素
    
    类比：把一摞盘子从桌子A搬到桌子B，
    搬完之后顺序就反过来了——最先进桌子A的盘子，
    现在在桌子B的最上面，可以最先拿走！
    
    桌子A（入）：[1, 2, 3]  （3在栈顶）
    搬到桌子B：[3, 2, 1]   （1在栈顶）
    从桌子B拿：先拿到1（最先进来的）→ FIFO！
    """
    def __init__(self):
        self.in_stack = []   # 入队栈
        self.out_stack = []  # 出队栈

    def push(self, x):
        """入队：压入入队栈"""
        self.in_stack.append(x)

    def pop(self):
        """出队：从出队栈弹出"""
        if self.empty():
            raise IndexError("Queue is empty")

        # 如果出队栈为空，把入队栈的元素全部搬过来
        if not self.out_stack:
            self._transfer()

        return self.out_stack.pop()

    def peek(self):
        """查看队首元素"""
        if self.empty():
            raise IndexError("Queue is empty")

        if not self.out_stack:
            self._transfer()

        return self.out_stack[-1]

    def _transfer(self):
        """把入队栈的元素全部搬到出队栈"""
        while self.in_stack:
            self.out_stack.append(self.in_stack.pop())

    def empty(self):
        return len(self.in_stack) == 0 and len(self.out_stack) == 0

# 测试
queue = MyQueue()
queue.push(1)   # 入队栈：[1]
queue.push(2)   # 入队栈：[1, 2]
queue.push(3)   # 入队栈：[1, 2, 3]
print(queue.pop())    # 1（最先入队的先出）
print(queue.pop())    # 2
queue.push(4)         # 入队栈：[4]
print(queue.pop())    # 3
print(queue.pop())    # 4
```

---

#### 八、单调栈简介

**单调栈**是一种特殊的栈，栈中的元素始终保持单调递增或单调递减。它是解决"下一个更大/更小元素"问题的利器。

##### 核心思想

```python
def next_greater_element(nums):
    """
    单调栈入门：找每个元素右边第一个比它大的元素
    
    思路：维护一个单调递减栈（栈底到栈顶递减）
    - 遍历数组，对于每个元素：
      - 如果它比栈顶元素大，说明找到了栈顶元素的"下一个更大元素"
      - 弹出栈顶，记录结果，继续比较
      - 把当前元素压入栈
    
    类比：排队量身高，每个人往后看，
    找到第一个比自己高的人
    """
    n = len(nums)
    result = [-1] * n   # 默认值 -1（表示找不到）
    stack = []           # 单调栈：存下标

    for i in range(n):
        # 当前元素比栈顶大 → 栈顶找到了"下一个更大元素"
        while stack and nums[i] > nums[stack[-1]]:
            idx = stack.pop()
            result[idx] = nums[i]  # nums[i] 是 nums[idx] 右边第一个更大的
        stack.append(i)

    return result

# 测试
nums = [2, 1, 2, 4, 3]
print(next_greater_element(nums))
# [4, 2, 4, -1, -1]
# 解释：
# 2 右边第一个更大的是 4
# 1 右边第一个更大的是 2
# 2 右边第一个更大的是 4
# 4 右边没有更大的了 → -1
# 3 右边没有更大的了 → -1
```

**单调栈的时间复杂度**：虽然有一个 while 循环嵌套在 for 循环里，但每个元素最多入栈一次、出栈一次，所以总时间复杂度是 **O(n)**。

> 单调栈是进阶内容，后面会深入学习。这里只需要建立"栈可以用来维护单调性"的概念。

---

---


### 主题5 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、用数组实现栈（方式一）

```typescript
// ========== 用 Array 实现栈 ==========
class StackByArray {
  private _data: number[] = [];  // 用数组作为底层存储

  // 压入栈顶：在数组末尾添加元素（均摊 O(1)）
  push(item: number): void {
    this._data.push(item);
  }

  // 弹出栈顶：移除并返回数组末尾的元素（O(1)）
  pop(): number {
    if (this.isEmpty()) throw new Error("pop from empty stack");
    return this._data.pop()!;
  }

  // 查看栈顶元素：查看数组末尾的元素（O(1)）
  peek(): number {
    if (this.isEmpty()) throw new Error("peek from empty stack");
    return this._data[this._data.length - 1];
  }

  // 判断栈是否为空
  isEmpty(): boolean {
    return this._data.length === 0;
  }

  // 返回栈的大小
  size(): number {
    return this._data.length;
  }

  // 方便打印，栈底在左，栈顶在右
  toString(): string {
    return `Stack(bottom → top): ${this._data}`;
  }
}
```

##### 二、用链表实现栈（方式二）

```typescript
// ========== 用链表实现栈（头插法，栈顶在链表头部）==========
// 链表节点（与主题4对照，这里自包含定义一份）
class ListNode {
  val: number;
  next: ListNode | null;
  constructor(val: number, next: ListNode | null = null) {
    this.val = val;
    this.next = next;
  }
}

class StackByLinkedList {
  private _head: ListNode | null = null;  // 头指针即栈顶
  private _size = 0;

  // 压入栈顶：在链表头部插入（O(1)）
  push(item: number): void {
    const newNode = new ListNode(item);
    newNode.next = this._head;
    this._head = newNode;
    this._size++;
  }

  // 弹出栈顶：删除链表头节点（O(1)）
  pop(): number {
    if (this.isEmpty()) throw new Error("pop from empty stack");
    const val = this._head!.val;
    this._head = this._head!.next;
    this._size--;
    return val;
  }

  // 查看栈顶：返回头节点的值（O(1)）
  peek(): number {
    if (this.isEmpty()) throw new Error("peek from empty stack");
    return this._head!.val;
  }

  isEmpty(): boolean {
    return this._head === null;
  }

  size(): number {
    return this._size;
  }
}
```

##### 三、栈的经典应用

```typescript
// ========== 1. 括号匹配 ==========
function isValidParentheses(s: string): boolean {
  const stack: string[] = [];
  // 用字典存储匹配关系
  const matching: Record<string, string> = { ")": "(", "]": "[", "}": "{" };

  for (const char of s) {
    if ("([{".includes(char)) {
      // 左括号：压入栈
      stack.push(char);
    } else if (")]}".includes(char)) {
      // 右括号：检查栈顶是否匹配
      if (stack.length === 0) return false;  // 没有左括号来配对
      const top = stack.pop()!;
      if (matching[char] !== top) return false;  // 不匹配！比如 "(]"
    }
  }

  // 最后栈必须为空（所有左括号都被配对了）
  return stack.length === 0;
}

// 测试
console.log(isValidParentheses("()"));      // true
console.log(isValidParentheses("()[]{}"));  // true
console.log(isValidParentheses("(]"));      // false
console.log(isValidParentheses("([)]"));    // false
console.log(isValidParentheses("{[()]}"));  // true

// ========== 2. 浏览器前进后退模拟 ==========
class BrowserHistory {
  private backStack: string[];      // 后退栈
  private forwardStack: string[];   // 前进栈

  constructor(homepage: string) {
    this.backStack = [homepage];  // 当前页面在栈顶
    this.forwardStack = [];
  }

  // 访问新页面
  visit(url: string): void {
    this.backStack.push(url);     // 当前页面压入后退栈
    this.forwardStack = [];       // 清空前进栈（不能前进了）
    console.log(`访问: ${url}`);
  }

  // 后退 steps 步
  back(steps: number): string {
    for (let i = 0; i < steps; i++) {
      if (this.backStack.length <= 1) break;  // 已经退到首页了
      const page = this.backStack.pop()!;
      this.forwardStack.push(page);
    }
    console.log(`后退到: ${this.backStack[this.backStack.length - 1]}`);
    return this.backStack[this.backStack.length - 1];
  }

  // 前进 steps 步
  forward(steps: number): string {
    for (let i = 0; i < steps; i++) {
      if (this.forwardStack.length === 0) break;  // 没有可以前进的页面了
      const page = this.forwardStack.pop()!;
      this.backStack.push(page);
    }
    console.log(`前进到: ${this.backStack[this.backStack.length - 1]}`);
    return this.backStack[this.backStack.length - 1];
  }
}

// 测试
const browser = new BrowserHistory("homepage.com");
browser.visit("google.com");
browser.visit("github.com");
browser.back(1);        // 后退到 google.com
browser.forward(1);     // 前进到 github.com
browser.visit("leetcode.com");  // 访问新页面，前进历史清空

// ========== 3. 表达式求值（后缀表达式 / 逆波兰表达式）==========
function evalRPN(tokens: string[]): number {
  const stack: number[] = [];

  for (const token of tokens) {
    if (!["+", "-", "*", "/"].includes(token)) {
      // 数字：压入栈
      stack.push(parseInt(token));
    } else {
      // 运算符：弹出两个操作数
      const b = stack.pop()!;  // 第二个操作数（后入先出）
      const a = stack.pop()!;  // 第一个操作数

      // 计算
      if (token === "+") stack.push(a + b);
      else if (token === "-") stack.push(a - b);
      else if (token === "*") stack.push(a * b);
      else if (token === "/") stack.push(Math.trunc(a / b));  // 向零取整
    }
  }

  return stack[0];  // 最后栈里只剩一个元素，就是结果
}

// 测试
console.log(evalRPN(["3", "4", "+", "5", "*"]));  // (3+4)*5 = 35
console.log(evalRPN(["10", "6", "-", "9", "3", "+", "*"]));  // 48

// ========== 4. 函数调用栈原理 ==========
// 调用栈是栈最经典的应用：调用函数时压栈，返回时弹栈
// 递归太深会导致 "Stack Overflow"（栈溢出）！
function greet(name: string): void {
  console.log(`Hello, ${name}!`);
  beep();             // 调用 beep()
  console.log("Done!");
}

function beep(): void {
  console.log("Beep!");
}

greet("Alice");
// 调用栈变化：[greet] → [greet, beep] → [greet] → []
```

##### 四、经典例题

```typescript
// ========== 例题1：有效的括号（LeetCode 20）==========
function isValid(s: string): boolean {
  const stack: string[] = [];
  const pairs: Record<string, string> = { ")": "(", "]": "[", "}": "{" };

  for (const ch of s) {
    if (ch in pairs) {  // 右括号
      // 栈为空或栈顶不匹配 → 无效
      if (stack.length === 0 || stack[stack.length - 1] !== pairs[ch]) {
        return false;
      }
      stack.pop();  // 匹配成功，弹出栈顶
    } else {        // 左括号
      stack.push(ch);
    }
  }

  return stack.length === 0;  // 栈为空说明全部配对
}

console.log(isValid("()"));      // true
console.log(isValid("()[]{}"));  // true
console.log(isValid("(]"));      // false
console.log(isValid("{[]}"));    // true

// ========== 例题2：最小栈（LeetCode 155）==========
// 两个栈：主栈 + 辅助栈（栈顶始终是当前最小值）
class MinStack {
  private stack: number[] = [];      // 主栈
  private minStack: number[] = [];   // 辅助栈：存最小值

  push(val: number): void {
    this.stack.push(val);
    // 辅助栈：压入当前最小值
    if (this.minStack.length === 0) {
      this.minStack.push(val);
    } else {
      this.minStack.push(Math.min(val, this.minStack[this.minStack.length - 1]));
    }
  }

  pop(): void {
    this.stack.pop();
    this.minStack.pop();  // 辅助栈同步弹出
  }

  top(): number {
    return this.stack[this.stack.length - 1];
  }

  getMin(): number {
    return this.minStack[this.minStack.length - 1];  // O(1) 看辅助栈栈顶
  }
}

// 测试
const minStack = new MinStack();
minStack.push(-2);
minStack.push(0);
minStack.push(-3);
console.log(minStack.getMin());  // -3
minStack.pop();
console.log(minStack.top());     // 0
console.log(minStack.getMin());  // -2

// ========== 例题3：用两个栈实现队列 ==========
// 栈A(inStack)入队，栈B(outStack)出队
// 把 A 的元素全部倒入 B 后，顺序就反过来了 → FIFO
class MyQueue {
  private inStack: number[] = [];   // 入队栈
  private outStack: number[] = [];  // 出队栈

  push(x: number): void {
    this.inStack.push(x);  // 入队：压入入队栈
  }

  pop(): number {
    if (this.empty()) throw new Error("Queue is empty");
    // 如果出队栈为空，把入队栈的元素全部搬过来
    if (this.outStack.length === 0) this.transfer();
    return this.outStack.pop()!;
  }

  peek(): number {
    if (this.empty()) throw new Error("Queue is empty");
    if (this.outStack.length === 0) this.transfer();
    return this.outStack[this.outStack.length - 1];
  }

  // 把入队栈的元素全部搬到出队栈
  private transfer(): void {
    while (this.inStack.length > 0) {
      this.outStack.push(this.inStack.pop()!);
    }
  }

  empty(): boolean {
    return this.inStack.length === 0 && this.outStack.length === 0;
  }
}

// 测试
const queue = new MyQueue();
queue.push(1);
queue.push(2);
queue.push(3);
console.log(queue.pop());  // 1（最先入队的先出）
console.log(queue.pop());  // 2
queue.push(4);
console.log(queue.pop());  // 3
console.log(queue.pop());  // 4
```

##### 五、单调栈简介

```typescript
// ========== 单调栈入门：找每个元素右边第一个比它大的元素 ==========
function nextGreaterElement(nums: number[]): number[] {
  const n = nums.length;
  const result: number[] = new Array<number>(n).fill(-1);  // 默认值 -1
  const stack: number[] = [];  // 单调栈：存下标

  for (let i = 0; i < n; i++) {
    // 当前元素比栈顶大 → 栈顶找到了"下一个更大元素"
    while (stack.length > 0 && nums[i] > nums[stack[stack.length - 1]]) {
      const idx = stack.pop()!;
      result[idx] = nums[i];  // nums[i] 是 nums[idx] 右边第一个更大的
    }
    stack.push(i);
  }

  return result;
}

// 测试
console.log(nextGreaterElement([2, 1, 2, 4, 3]));
// [4, 2, 4, -1, -1]
// 时间复杂度 O(n)：每个元素最多入栈一次、出栈一次
```

### 主题5 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、用切片实现栈（方式一）

```go
package main

import "fmt"

// ========== 用切片实现栈 ==========
type StackBySlice struct {
	data []int // 用切片作为底层存储
}

func NewStackBySlice() *StackBySlice {
	return &StackBySlice{data: []int{}}
}

// 压入栈顶：在切片末尾添加元素（均摊 O(1)）
func (s *StackBySlice) Push(item int) {
	s.data = append(s.data, item)
}

// 弹出栈顶：移除并返回切片末尾的元素（O(1)）
func (s *StackBySlice) Pop() int {
	if s.IsEmpty() {
		panic("pop from empty stack")
	}
	val := s.data[len(s.data)-1]
	s.data = s.data[:len(s.data)-1]
	return val
}

// 查看栈顶元素：查看切片末尾的元素（O(1)）
func (s *StackBySlice) Peek() int {
	if s.IsEmpty() {
		panic("peek from empty stack")
	}
	return s.data[len(s.data)-1]
}

// 判断栈是否为空
func (s *StackBySlice) IsEmpty() bool {
	return len(s.data) == 0
}

// 返回栈的大小
func (s *StackBySlice) Size() int {
	return len(s.data)
}

func (s *StackBySlice) String() string {
	return fmt.Sprintf("Stack(bottom → top): %v", s.data)
}
```

##### 二、用链表实现栈（方式二）

```go
package main

// ========== 用链表实现栈（头插法，栈顶在链表头部）==========
type StackByLinkedList struct {
	head *ListNode // 头指针即栈顶
	size int
}

func NewStackByLinkedList() *StackByLinkedList {
	return &StackByLinkedList{}
}

// 压入栈顶：在链表头部插入（O(1)）
func (s *StackByLinkedList) Push(item int) {
	newNode := NewListNode(item, nil)
	newNode.Next = s.head
	s.head = newNode
	s.size++
}

// 弹出栈顶：删除链表头节点（O(1)）
func (s *StackByLinkedList) Pop() int {
	if s.IsEmpty() {
		panic("pop from empty stack")
	}
	val := s.head.Val
	s.head = s.head.Next
	s.size--
	return val
}

// 查看栈顶：返回头节点的值（O(1)）
func (s *StackByLinkedList) Peek() int {
	if s.IsEmpty() {
		panic("peek from empty stack")
	}
	return s.head.Val
}

func (s *StackByLinkedList) IsEmpty() bool {
	return s.head == nil
}

func (s *StackByLinkedList) Size() int {
	return s.size
}
```

##### 三、栈的经典应用

```go
package main

import "fmt"

// ========== 1. 括号匹配 ==========
func IsValidParentheses(s string) bool {
	stack := []rune{}
	// 用 map 存储匹配关系
	matching := map[rune]rune{')': '(', ']': '[', '}': '{'}

	for _, char := range s {
		if char == '(' || char == '[' || char == '{' {
			// 左括号：压入栈
			stack = append(stack, char)
		} else if char == ')' || char == ']' || char == '}' {
			// 右括号：检查栈顶是否匹配
			if len(stack) == 0 {
				return false // 没有左括号来配对
			}
			top := stack[len(stack)-1]
			stack = stack[:len(stack)-1]
			if matching[char] != top {
				return false // 不匹配！比如 "(]"
			}
		}
	}

	// 最后栈必须为空（所有左括号都被配对了）
	return len(stack) == 0
}

// ========== 2. 浏览器前进后退模拟 ==========
type BrowserHistory struct {
	backStack    []string // 后退栈
	forwardStack []string // 前进栈
}

func NewBrowserHistory(homepage string) *BrowserHistory {
	return &BrowserHistory{
		backStack:    []string{homepage}, // 当前页面在栈顶
		forwardStack: []string{},
	}
}

// 访问新页面
func (b *BrowserHistory) Visit(url string) {
	b.backStack = append(b.backStack, url) // 当前页面压入后退栈
	b.forwardStack = []string{}            // 清空前进栈（不能前进了）
	fmt.Printf("访问: %s\n", url)
}

// 后退 steps 步
func (b *BrowserHistory) Back(steps int) string {
	for i := 0; i < steps; i++ {
		if len(b.backStack) <= 1 {
			break // 已经退到首页了
		}
		page := b.backStack[len(b.backStack)-1]
		b.backStack = b.backStack[:len(b.backStack)-1]
		b.forwardStack = append(b.forwardStack, page)
	}
	cur := b.backStack[len(b.backStack)-1]
	fmt.Printf("后退到: %s\n", cur)
	return cur
}

// 前进 steps 步
func (b *BrowserHistory) Forward(steps int) string {
	for i := 0; i < steps; i++ {
		if len(b.forwardStack) == 0 {
			break // 没有可以前进的页面了
		}
		page := b.forwardStack[len(b.forwardStack)-1]
		b.forwardStack = b.forwardStack[:len(b.forwardStack)-1]
		b.backStack = append(b.backStack, page)
	}
	cur := b.backStack[len(b.backStack)-1]
	fmt.Printf("前进到: %s\n", cur)
	return cur
}

// ========== 3. 表达式求值（后缀表达式 / 逆波兰表达式）==========
func EvalRPN(tokens []string) int {
	stack := []int{}
	ops := map[string]bool{"+": true, "-": true, "*": true, "/": true}

	for _, token := range tokens {
		if !ops[token] {
			// 数字：压入栈（把字符串转成整数）
			num := 0
			sign := 1
			start := 0
			if token[0] == '-' {
				sign = -1
				start = 1
			}
			for i := start; i < len(token); i++ {
				num = num*10 + int(token[i]-'0')
			}
			stack = append(stack, sign*num)
		} else {
			// 运算符：弹出两个操作数
			b := stack[len(stack)-1] // 第二个操作数（后入先出）
			stack = stack[:len(stack)-1]
			a := stack[len(stack)-1] // 第一个操作数
			stack = stack[:len(stack)-1]

			// 计算
			switch token {
			case "+":
				stack = append(stack, a+b)
			case "-":
				stack = append(stack, a-b)
			case "*":
				stack = append(stack, a*b)
			case "/":
				stack = append(stack, truncDiv(a, b)) // 向零取整
			}
		}
	}

	return stack[0] // 最后栈里只剩一个元素，就是结果
}

// Go 的整数除法本身就是向零取整（和 Python 的 int(a/b) 一致）
func truncDiv(a, b int) int {
	return a / b
}

// ========== 4. 函数调用栈原理 ==========
// 调用栈是栈最经典的应用：调用函数时压栈，返回时弹栈
// 递归太深会导致 "Stack Overflow"（栈溢出）！

func greet(name string) {
	fmt.Printf("Hello, %s!\n", name)
	beep() // 调用 beep()
	fmt.Println("Done!")
}

func beep() {
	fmt.Println("Beep!")
}

func testCallStack() {
	greet("Alice")
	// 调用栈变化：[greet] → [greet, beep] → [greet] → []
}
```

##### 四、经典例题

```go
package main

import "fmt"

// ========== 例题1：有效的括号（LeetCode 20）==========
func IsValid(s string) bool {
	stack := []rune{}
	pairs := map[rune]rune{')': '(', ']': '[', '}': '{'}

	for _, ch := range s {
		if _, ok := pairs[ch]; ok { // 右括号
			// 栈为空或栈顶不匹配 → 无效
			if len(stack) == 0 || stack[len(stack)-1] != pairs[ch] {
				return false
			}
			stack = stack[:len(stack)-1] // 匹配成功，弹出栈顶
		} else { // 左括号
			stack = append(stack, ch)
		}
	}

	return len(stack) == 0 // 栈为空说明全部配对
}

// ========== 例题2：最小栈（LeetCode 155）==========
// 两个栈：主栈 + 辅助栈（栈顶始终是当前最小值）
type MinStack struct {
	stack    []int // 主栈
	minStack []int // 辅助栈：存最小值
}

func NewMinStack() *MinStack {
	return &MinStack{stack: []int{}, minStack: []int{}}
}

func (ms *MinStack) Push(val int) {
	ms.stack = append(ms.stack, val)
	// 辅助栈：压入当前最小值
	if len(ms.minStack) == 0 {
		ms.minStack = append(ms.minStack, val)
	} else {
		curMin := ms.minStack[len(ms.minStack)-1]
		if val < curMin {
			ms.minStack = append(ms.minStack, val)
		} else {
			ms.minStack = append(ms.minStack, curMin)
		}
	}
}

func (ms *MinStack) Pop() {
	ms.stack = ms.stack[:len(ms.stack)-1]
	ms.minStack = ms.minStack[:len(ms.minStack)-1] // 辅助栈同步弹出
}

func (ms *MinStack) Top() int {
	return ms.stack[len(ms.stack)-1]
}

func (ms *MinStack) GetMin() int {
	return ms.minStack[len(ms.minStack)-1] // O(1) 看辅助栈栈顶
}

// ========== 例题3：用两个栈实现队列 ==========
// 栈A(inStack)入队，栈B(outStack)出队
// 把 A 的元素全部倒入 B 后，顺序就反过来了 → FIFO
type MyQueue struct {
	inStack  []int // 入队栈
	outStack []int // 出队栈
}

func NewMyQueue() *MyQueue {
	return &MyQueue{inStack: []int{}, outStack: []int{}}
}

func (q *MyQueue) Push(x int) {
	q.inStack = append(q.inStack, x) // 入队：压入入队栈
}

func (q *MyQueue) Pop() int {
	if q.Empty() {
		panic("Queue is empty")
	}
	// 如果出队栈为空，把入队栈的元素全部搬过来
	if len(q.outStack) == 0 {
		q.transfer()
	}
	val := q.outStack[len(q.outStack)-1]
	q.outStack = q.outStack[:len(q.outStack)-1]
	return val
}

func (q *MyQueue) Peek() int {
	if q.Empty() {
		panic("Queue is empty")
	}
	if len(q.outStack) == 0 {
		q.transfer()
	}
	return q.outStack[len(q.outStack)-1]
}

// 把入队栈的元素全部搬到出队栈
func (q *MyQueue) transfer() {
	for len(q.inStack) > 0 {
		val := q.inStack[len(q.inStack)-1]
		q.inStack = q.inStack[:len(q.inStack)-1]
		q.outStack = append(q.outStack, val)
	}
}

func (q *MyQueue) Empty() bool {
	return len(q.inStack) == 0 && len(q.outStack) == 0
}

func testStackExamples() {
	// 括号匹配测试
	fmt.Println(IsValid("()"))        // true
	fmt.Println(IsValid("()[]{}"))    // true
	fmt.Println(IsValid("(]"))        // false
	fmt.Println(IsValid("{[]}"))      // true

	// 最小栈测试
	ms := NewMinStack()
	ms.Push(-2)
	ms.Push(0)
	ms.Push(-3)
	fmt.Println(ms.GetMin()) // -3
	ms.Pop()
	fmt.Println(ms.Top())    // 0
	fmt.Println(ms.GetMin()) // -2

	// 双栈队列测试
	q := NewMyQueue()
	q.Push(1)
	q.Push(2)
	q.Push(3)
	fmt.Println(q.Pop()) // 1（最先入队的先出）
	fmt.Println(q.Pop()) // 2
	q.Push(4)
	fmt.Println(q.Pop()) // 3
	fmt.Println(q.Pop()) // 4
}
```

##### 五、单调栈简介

```go
package main

import "fmt"

// ========== 单调栈入门：找每个元素右边第一个比它大的元素 ==========
func NextGreaterElement(nums []int) []int {
	n := len(nums)
	result := make([]int, n)
	for i := range result {
		result[i] = -1 // 默认值 -1（表示找不到）
	}
	stack := []int{} // 单调栈：存下标

	for i := 0; i < n; i++ {
		// 当前元素比栈顶大 → 栈顶找到了"下一个更大元素"
		for len(stack) > 0 && nums[i] > nums[stack[len(stack)-1]] {
			idx := stack[len(stack)-1]
			stack = stack[:len(stack)-1]
			result[idx] = nums[i] // nums[i] 是 nums[idx] 右边第一个更大的
		}
		stack = append(stack, i)
	}

	return result
}

func testMonotonicStack() {
	// 测试
	fmt.Println(NextGreaterElement([]int{2, 1, 2, 4, 3}))
	// [4 2 4 -1 -1]
	// 时间复杂度 O(n)：每个元素最多入栈一次、出栈一次
}
```

---

### 主题6：队列（Queue）


#### 一、队列的概念

##### 用"排队买奶茶"来类比

想象奶茶店门口**排队买奶茶**的场景：

```
队尾 ← ┌─────┬─────┬─────┬─────┬─────┐ ← 队首
       │  E  │  D  │  C  │  B  │  A  │
       └─────┴─────┴─────┴─────┴─────┘
    新来的排这里              排最前的先买

enqueue(E) → 从队尾加入
dequeue()  → A 先买到，从队首离开
```

- 新来的人只能**排到队尾**（enqueue）
- 买到奶茶的人从**队首离开**（dequeue）
- 不能插队！谁先来谁先买 → **先进先出（FIFO）**

---

#### 二、FIFO（先进先出）原则详解

**先进先出（First In, First Out）** 是队列最核心的特性：

```
操作顺序：
enqueue(A)  →  队列：[A]
enqueue(B)  →  队列：[A, B]
enqueue(C)  →  队列：[A, B, C]
dequeue()   →  取出 A（最先进来的，最先出去）
dequeue()   →  取出 B
dequeue()   →  取出 C（最后进来的，最后出去）
```

**生活中的 FIFO 例子**：
- 排队买票
- 打印机的打印队列（先提交的先打印）
- 食堂排队打饭
- 消息队列（先发的消息先处理）

---

#### 三、基本操作

| 操作 | 说明 | 时间复杂度 |
|------|------|-----------|
| `enqueue(item)` | 从队尾加入元素 | O(1) |
| `dequeue()` | 从队首移除并返回元素 | O(1) |
| `front()` / `peek()` | 查看队首元素但不移除 | O(1) |
| `is_empty()` | 判断队列是否为空 | O(1) |
| `size()` | 返回队列中元素个数 | O(1) |

---

#### 四、Python 实现队列

##### 方式一：用 list 实现（不推荐！）

```python
class QueueByList:
    """
    用 list 实现队列（效率低，不推荐）
    
    问题：list 的 pop(0) 是 O(n)！
    因为弹出第一个元素后，后面所有元素都要前移一位。
    
    类比：排队时，队首的人走了，后面所有人都要往前走一步。
    如果队伍有1000人，每次队首离开都要让999人前移——太慢了！
    """
    def __init__(self):
        self._data = []

    def enqueue(self, item):
        """入队：在 list 末尾添加"""
        self._data.append(item)   # O(1)

    def dequeue(self):
        """出队：从 list 开头移除"""
        if self.is_empty():
            raise IndexError("dequeue from empty queue")
        return self._data.pop(0)  # O(n) ← 问题在这里！

    def front(self):
        if self.is_empty():
            raise IndexError("queue is empty")
        return self._data[0]      # O(1)

    def is_empty(self):
        return len(self._data) == 0

    def size(self):
        return len(self._data)
```

##### 方式二：用链表实现

```python
class QueueByLinkedList:
    """
    用链表实现队列（高效，O(1) 的入队和出队）
    
    思路：维护 head 和 tail 两个指针
    - 入队：在 tail 后面添加新节点
    - 出队：删除 head 节点
    """
    def __init__(self):
        self._head = None   # 队首指针
        self._tail = None   # 队尾指针
        self._size = 0

    def enqueue(self, item):
        """入队：在尾部添加"""
        new_node = ListNode(item)
        if self._tail is None:
            # 空队列
            self._head = self._tail = new_node
        else:
            self._tail.next = new_node
            self._tail = new_node
        self._size += 1
        # O(1)

    def dequeue(self):
        """出队：从头部移除"""
        if self.is_empty():
            raise IndexError("dequeue from empty queue")
        val = self._head.val
        self._head = self._head.next
        if self._head is None:
            self._tail = None  # 队列空了，tail 也要清空
        self._size -= 1
        return val
        # O(1)

    def front(self):
        if self.is_empty():
            raise IndexError("queue is empty")
        return self._head.val

    def is_empty(self):
        return self._head is None

    def size(self):
        return self._size
```

---

#### 五、用 collections.deque 实现高效队列（推荐方式）

```python
from collections import deque

class Queue:
    """
    用 collections.deque 实现高效队列（Python 中最推荐的方式）
    
    deque = double-ended queue（双端队列）
    - 两端都可以 O(1) 地添加和删除元素
    - 用它做队列，入队出队都是严格的 O(1)
    """
    def __init__(self):
        self._data = deque()

    def enqueue(self, item):
        """入队：从右端添加"""
        self._data.append(item)     # O(1)

    def dequeue(self):
        """出队：从左端移除"""
        if self.is_empty():
            raise IndexError("dequeue from empty queue")
        return self._data.popleft()  # O(1)

    def front(self):
        """查看队首"""
        if self.is_empty():
            raise IndexError("queue is empty")
        return self._data[0]         # O(1)

    def is_empty(self):
        return len(self._data) == 0

    def size(self):
        return len(self._data)

# 测试
q = Queue()
q.enqueue(10)
q.enqueue(20)
q.enqueue(30)
print(q.dequeue())  # 10（先进先出）
print(q.dequeue())  # 20
print(q.front())    # 30
```

> **为什么 deque 这么快？** 因为 deque 底层是**双向链表**的块状结构，两端的操作都是 O(1)，不像 list 的 `pop(0)` 需要移动所有元素。

---

#### 六、循环队列

##### 概念

循环队列是用**数组**实现的队列，通过"绕圈"来避免空间浪费：

```
普通数组队列的问题：
出队后，前面的空间就浪费了！
┌───┬───┬───┬───┬───┬───┬───┬───┐
│   │   │ 3 │ 4 │ 5 │   │   │   │
└───┴───┴───┴───┴───┴───┴───┴───┘
 ↑front        ↑rear
 前面空了但不能用！

循环队列的解决方案：把数组"首尾相连"变成环
┌───┬───┬───┐
│ 5 │   │ 3 │
└───┴───┴───┘
  ↑rear   ↑front
 5 可以放到空位去！
```

##### Python 实现

```python
class CircularQueue:
    """
    循环队列：用固定大小的数组实现
    
    关键：用取模运算 % 实现"绕圈"
    - 下一个位置 = (当前位置 + 1) % 容量
    
    类比：旋转寿司传送带，位置是固定的，
    厨师放上去，顾客取走，空位可以循环使用。
    """
    def __init__(self, k):
        self.capacity = k       # 队列容量
        self.data = [0] * k     # 底层数组
        self.head = 0           # 队首指针（下标）
        self.tail = 0           # 队尾指针（下一个入队位置）
        self.count = 0          # 当前元素个数

    def enqueue(self, value):
        """入队"""
        if self.is_full():
            return False  # 队列满了

        self.data[self.tail] = value
        # 队尾指针后移一位，到末尾就绕回头部
        self.tail = (self.tail + 1) % self.capacity
        self.count += 1
        return True

    def dequeue(self):
        """出队"""
        if self.is_empty():
            return False

        # 队首指针后移一位
        self.head = (self.head + 1) % self.capacity
        self.count -= 1
        return True

    def front(self):
        """查看队首元素"""
        if self.is_empty():
            return -1
        return self.data[self.head]

    def rear(self):
        """查看队尾元素"""
        if self.is_empty():
            return -1
        # 队尾元素的位置：(tail - 1 + capacity) % capacity
        return self.data[(self.tail - 1 + self.capacity) % self.capacity]

    def is_empty(self):
        return self.count == 0

    def is_full(self):
        return self.count == self.capacity

# 测试
cq = CircularQueue(3)  # 容量为3
print(cq.enqueue(1))   # True   队列：[1, _, _]
print(cq.enqueue(2))   # True   队列：[1, 2, _]
print(cq.enqueue(3))   # True   队列：[1, 2, 3]
print(cq.enqueue(4))   # False  队列满了！
print(cq.front())      # 1
print(cq.dequeue())    # True   队列：[_, 2, 3]
print(cq.enqueue(4))   # True   队列：[4, 2, 3]（4绕到前面的空位）
print(cq.rear())       # 4
```

---

#### 七、双端队列（Deque）

##### 概念

双端队列（Double-Ended Queue）允许**两端都可以入队和出队**：

```
       ← 左端可以入队/出队        右端可以入队/出队 →
       ┌─────┬─────┬─────┬─────┐
       │  B  │  C  │  D  │  E  │
       └─────┴─────┴─────┴─────┘
```

##### 操作

```python
from collections import deque

dq = deque()

# 两端操作
dq.append(1)        # 右端入队：[1]
dq.append(2)        # 右端入队：[1, 2]
dq.appendleft(0)    # 左端入队：[0, 1, 2]
dq.appendleft(-1)   # 左端入队：[-1, 0, 1, 2]

print(dq)           # deque([-1, 0, 1, 2])

print(dq.pop())     # 右端出队：2
print(dq.popleft()) # 左端出队：-1

print(dq)           # deque([0, 1])
```

**双端队列的应用**：
- 滑动窗口最大值/最小值问题
- 需要两端都能操作的场景
- 既是栈又是队列的场景

---

#### 八、队列的经典应用

##### 1. BFS 广度优先搜索（预告）

```python
"""
BFS（Breadth-First Search）是队列最经典的应用之一。

核心思想：从起点开始，先访问所有相邻的节点，再访问相邻节点的相邻节点...
就像水波纹一样，一层一层向外扩散。

         起点
        / | \
      A   B   C     ← 第1层（起点的邻居）
     /|   |   |\
    D E   F   G H   ← 第2层（第1层的邻居）

用队列来维护"待访问的节点"，保证按层次顺序访问。
"""

from collections import deque

def bfs(graph, start):
    """
    BFS 广度优先搜索（图的遍历）
    
    graph: 邻接表形式的图
    start: 起始节点
    """
    visited = set()           # 记录已访问的节点
    queue = deque([start])    # 队列中放待访问的节点
    visited.add(start)
    order = []                # 记录访问顺序

    while queue:
        node = queue.popleft()  # 取出队首节点
        order.append(node)

        # 把该节点的所有未访问邻居加入队列
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)

    return order

# 测试：一个简单的图
graph = {
    'A': ['B', 'C'],
    'B': ['A', 'D', 'E'],
    'C': ['A', 'F'],
    'D': ['B'],
    'E': ['B', 'F'],
    'F': ['C', 'E']
}

print("BFS 顺序:", bfs(graph, 'A'))  # ['A', 'B', 'C', 'D', 'E', 'F']
```

##### 2. 任务调度模拟

```python
from collections import deque
import time

class TaskScheduler:
    """
    任务调度器：模拟操作系统的任务队列
    
    类比：打印机的打印队列
    - 多个文档排队等待打印
    - 先提交的先打印（FIFO）
    """
    def __init__(self):
        self.queue = deque()

    def add_task(self, task_name):
        """添加任务到队列"""
        self.queue.append(task_name)
        print(f"任务 '{task_name}' 已加入队列")

    def process_tasks(self):
        """按顺序处理所有任务"""
        print("\n开始处理任务...")
        while self.queue:
            task = self.queue.popleft()
            print(f"  正在处理: {task}")
            # 模拟处理时间
            # time.sleep(0.5)
        print("所有任务处理完毕！\n")

# 测试
scheduler = TaskScheduler()
scheduler.add_task("打印报告.pdf")
scheduler.add_task("发送邮件")
scheduler.add_task("备份数据库")
scheduler.process_tasks()
# 输出顺序：打印报告.pdf → 发送邮件 → 备份数据库
```

##### 3. 生产者消费者模型简介

```python
from collections import deque
import random

class ProducerConsumer:
    """
    生产者-消费者模型
    
    生产者：不断往队列里放数据
    消费者：不断从队列里取数据处理
    
    队列在中间起到"缓冲"的作用：
    - 生产者生产太快 → 数据在队列中排队等待
    - 消费者消费太快 → 队列为空时消费者等待
    
    类比：餐厅的出菜口
    - 厨师（生产者）不断做菜放到出菜口
    - 服务员（消费者）从出菜口端走菜
    - 出菜口就是"队列"
    """
    def __init__(self, capacity=5):
        self.queue = deque()
        self.capacity = capacity  # 队列最大容量

    def produce(self, item):
        """生产者：放入数据"""
        if len(self.queue) >= self.capacity:
            print(f"  队列已满！'{item}' 等待中...")
            return False
        self.queue.append(item)
        print(f"  生产: {item}，队列长度: {len(self.queue)}")
        return True

    def consume(self):
        """消费者：取出数据"""
        if not self.queue:
            print("  队列为空，等待生产...")
            return None
        item = self.queue.popleft()
        print(f"  消费: {item}，队列长度: {len(self.queue)}")
        return item

# 测试
pc = ProducerConsumer(capacity=3)
print("=== 生产阶段 ===")
pc.produce("数据A")
pc.produce("数据B")
pc.produce("数据C")
pc.produce("数据D")  # 队列满了

print("\n=== 消费阶段 ===")
pc.consume()
pc.consume()

print("\n=== 继续生产 ===")
pc.produce("数据D")
pc.produce("数据E")
```

---

#### 九、经典例题

##### 例题1：用两个栈实现队列

（在主题5中已经详细实现，这里给出简洁版本）

```python
class MyQueue:
    """
    用两个栈实现队列（LeetCode 232）
    
    核心思路：
    - in_stack 负责接收新元素
    - out_stack 负责输出元素
    - 当 out_stack 为空时，把 in_stack 的元素全部倒入 out_stack
      （倒过来之后，最先进 in_stack 的元素就到了 out_stack 的栈顶）
    """
    def __init__(self):
        self.in_stack = []
        self.out_stack = []

    def push(self, x):
        """入队：压入 in_stack"""
        self.in_stack.append(x)

    def pop(self):
        """出队：从 out_stack 弹出"""
        self._ensure_out_stack()
        return self.out_stack.pop()

    def peek(self):
        """查看队首"""
        self._ensure_out_stack()
        return self.out_stack[-1]

    def empty(self):
        return not self.in_stack and not self.out_stack

    def _ensure_out_stack(self):
        """确保 out_stack 有元素"""
        if not self.out_stack:
            while self.in_stack:
                self.out_stack.append(self.in_stack.pop())

# 测试
q = MyQueue()
q.push(1)
q.push(2)
print(q.peek())   # 1
print(q.pop())    # 1
print(q.empty())  # False
```

##### 例题2：用队列实现栈

```python
from collections import deque

class MyStack:
    """
    用队列实现栈（LeetCode 225）
    
    思路：每次 push 新元素后，把之前的所有元素重新排到新元素后面
    这样新元素就总是在队首（栈顶）
    
    类比：新来的人要站到队伍最前面，
    于是让他先站到队尾，然后让前面所有人都绕到他后面去。
    """
    def __init__(self):
        self.queue = deque()

    def push(self, x):
        """
        入栈：
        1. 先把 x 加到队尾
        2. 然后把队尾之前的所有元素都移到队尾（绕一圈）
        这样 x 就到了队首
        """
        self.queue.append(x)
        # 把 x 之前的所有元素都移到 x 后面
        for _ in range(len(self.queue) - 1):
            self.queue.append(self.queue.popleft())
        # 现在 x 在队首

    def pop(self):
        """出栈：弹出队首"""
        return self.queue.popleft()

    def top(self):
        """查看栈顶：队首元素"""
        return self.queue[0]

    def empty(self):
        return len(self.queue) == 0

# 测试
stack = MyStack()
stack.push(1)   # 队列：[1]
stack.push(2)   # 队列：[2, 1]（2绕到了队首）
stack.push(3)   # 队列：[3, 2, 1]
print(stack.top())    # 3
print(stack.pop())    # 3
print(stack.pop())    # 2
print(stack.pop())    # 1
```

##### 例题3：最近的请求次数（LeetCode 933）

**题目**：写一个 `RecentCounter` 类，计算最近 3000 毫秒内的请求数。

```python
from collections import deque

class RecentCounter:
    """
    最近的请求次数（LeetCode 933）
    
    思路：用队列存储所有请求的时间戳
    每次新请求进来时，把超过 3000ms 范围的旧请求从队首踢出去
    
    类比：一个只能容纳最近3000毫秒内请求的"窗口"
    新请求从右边进入窗口，超时的旧请求从左边被踢出
    窗口内有多少请求，就是最近3000ms内的请求数
    
    为什么用队列？因为请求是按时间顺序来的（递增的），
    最旧的请求一定在队首，踢出去也是从队首踢——完美的 FIFO！
    """
    def __init__(self):
        self.queue = deque()  # 存储请求时间戳

    def ping(self, t):
        """
        在时间 t 发起一次请求，返回 [t-3000, t] 范围内的请求数
        
        t 保证严格递增（每次调用都比上次大）
        """
        self.queue.append(t)  # 新请求加入队尾

        # 把超出 [t-3000, t] 范围的旧请求从队首踢出去
        while self.queue[0] < t - 3000:
            self.queue.popleft()

        return len(self.queue)  # 队列中剩余的就是范围内的请求数

# 测试
counter = RecentCounter()
print(counter.ping(1))      # 1，队列：[1]，范围[-2999, 1]内有1个
print(counter.ping(100))    # 2，队列：[1, 100]
print(counter.ping(3001))   # 3，队列：[1, 100, 3001]
print(counter.ping(3002))   # 3，队列：[100, 3001, 3002]（1被踢出去了）
```

---

#### 十、优先队列简介

##### 概念

普通队列是"先进先出"，而**优先队列**是"优先级高的先出"：

```
普通队列：先来先服务（排队买票）
优先队列：紧急的先来（医院急诊——病情重的先看，不管谁先来）

入队：[病人A(轻伤), 病人B(重伤), 病人C(中等)]
出队顺序：病人B(重伤) → 病人C(中等) → 病人A(轻伤)
```

##### Python 实现

```python
import heapq

class PriorityQueue:
    """
    优先队列：用堆（heapq）实现
    
    Python 的 heapq 模块提供的是最小堆，
    每次取出的都是最小（优先级最高）的元素。
    """
    def __init__(self):
        self._heap = []
        self._index = 0  # 用于打破优先级相同时的平局

    def push(self, item, priority):
        """
        入队：按优先级插入
        priority 越小，优先级越高
        """
        heapq.heappush(self._heap, (priority, self._index, item))
        self._index += 1

    def pop(self):
        """出队：弹出优先级最高（值最小）的元素"""
        if self.is_empty():
            raise IndexError("Queue is empty")
        return heapq.heappop(self._heap)[2]

    def is_empty(self):
        return len(self._heap) == 0

# 测试
pq = PriorityQueue()
pq.push("普通感冒", 3)
pq.push("心脏骤停", 1)   # 最紧急
pq.push("骨折", 2)

print(pq.pop())  # 心脏骤停（优先级1，最高）
print(pq.pop())  # 骨折（优先级2）
print(pq.pop())  # 普通感冒（优先级3，最低）
```

> **优先队列的底层是"堆"（Heap）**，这是一种特殊的完全二叉树。push 和 pop 的时间复杂度都是 **O(log n)**。堆的内容我们会在后面的主题中详细学习。

---

#### 总结对比：四种基础数据结构

| 特性 | 数组 | 链表 | 栈 | 队列 |
|------|------|------|-----|------|
| 访问 | 随机访问 O(1) | 顺序访问 O(n) | 只能访问栈顶 O(1) | 只能访问队首 O(1) |
| 插入 | 中间 O(n)，末尾 O(1) | 已知位置 O(1) | 只能栈顶 O(1) | 只能队尾 O(1) |
| 删除 | 中间 O(n)，末尾 O(1) | 已知位置 O(1) | 只能栈顶 O(1) | 只能队首 O(1) |
| 原则 | 无 | 无 | LIFO | FIFO |
| 典型应用 | 随机访问数据 | 动态增删 | 括号匹配、撤销 | BFS、任务调度 |


### 主题6 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、用数组实现队列（方式一，不推荐）

```typescript
// ========== 用 Array 实现队列（效率低，不推荐）==========
class QueueByArray {
  private _data: number[] = [];

  // 问题：shift() 是 O(n)！
  // 因为弹出第一个元素后，后面所有元素都要前移一位。

  // 入队：在数组末尾添加（O(1)）
  enqueue(item: number): void {
    this._data.push(item);
  }

  // 出队：从数组开头移除（O(n) ← 问题在这里！）
  dequeue(): number {
    if (this.is_empty()) throw new Error("dequeue from empty queue");
    return this._data.shift()!;
  }

  // 查看队首（O(1)）
  front(): number {
    if (this.is_empty()) throw new Error("queue is empty");
    return this._data[0];
  }

  is_empty(): boolean {
    return this._data.length === 0;
  }

  size(): number {
    return this._data.length;
  }
}
```

##### 二、用链表实现队列（方式二，高效）

```typescript
// ========== 用链表实现队列（高效，O(1) 的入队和出队）==========
// 思路：维护 head 和 tail 两个指针
// - 入队：在 tail 后面添加新节点
// - 出队：删除 head 节点
// 链表节点（与主题4对照，这里自包含定义一份）
class ListNode {
  val: number;
  next: ListNode | null;
  constructor(val: number, next: ListNode | null = null) {
    this.val = val;
    this.next = next;
  }
}

class QueueByLinkedList {
  private _head: ListNode | null = null;  // 队首指针
  private _tail: ListNode | null = null;  // 队尾指针
  private _size = 0;

  // 入队：在尾部添加（O(1)）
  enqueue(item: number): void {
    const newNode = new ListNode(item);
    if (this._tail === null) {
      // 空队列
      this._head = this._tail = newNode;
    } else {
      this._tail.next = newNode;
      this._tail = newNode;
    }
    this._size++;
  }

  // 出队：从头部移除（O(1)）
  dequeue(): number {
    if (this.is_empty()) throw new Error("dequeue from empty queue");
    const val = this._head!.val;
    this._head = this._head!.next;
    if (this._head === null) {
      this._tail = null;  // 队列空了，tail 也要清空
    }
    this._size--;
    return val;
  }

  // 查看队首（O(1)）
  front(): number {
    if (this.is_empty()) throw new Error("queue is empty");
    return this._head!.val;
  }

  is_empty(): boolean {
    return this._head === null;
  }

  size(): number {
    return this._size;
  }
}
```

##### 三、用数组模拟高效队列（推荐方式）

```typescript
// ========== 用数组 + 头指针实现高效队列 ==========
// 思路：不真的移除队首元素，而是用 headIndex 标记队首位置
// 出队只是 headIndex + 1，避免移动所有元素！
class Queue {
  private _data: number[] = [];
  private _headIndex = 0;  // 队首位置

  // 入队：从右端添加（O(1)）
  enqueue(item: number): void {
    this._data.push(item);
  }

  // 出队：队首指针后移（均摊 O(1)）
  dequeue(): number {
    if (this.is_empty()) throw new Error("dequeue from empty queue");
    const val = this._data[this._headIndex];
    this._headIndex++;
    return val;
  }

  // 查看队首（O(1)）
  front(): number {
    if (this.is_empty()) throw new Error("queue is empty");
    return this._data[this._headIndex];
  }

  is_empty(): boolean {
    return this._headIndex >= this._data.length;
  }

  size(): number {
    return this._data.length - this._headIndex;
  }
}

// 测试
const q = new Queue();
q.enqueue(10);
q.enqueue(20);
q.enqueue(30);
console.log(q.dequeue());  // 10（先进先出）
console.log(q.dequeue());  // 20
console.log(q.front());    // 30
```

##### 四、循环队列

```typescript
// ========== 循环队列：用固定大小的数组实现 ==========
// 关键：用取模运算 % 实现"绕圈"
// - 下一个位置 = (当前位置 + 1) % 容量
class CircularQueue {
  private capacity: number;  // 队列容量
  private data: number[];    // 底层数组
  private head: number;      // 队首指针（下标）
  private tail: number;      // 队尾指针（下一个入队位置）
  private count: number;     // 当前元素个数

  constructor(k: number) {
    this.capacity = k;
    this.data = new Array<number>(k).fill(0);
    this.head = 0;
    this.tail = 0;
    this.count = 0;
  }

  // 入队
  enqueue(value: number): boolean {
    if (this.is_full()) return false;  // 队列满了

    this.data[this.tail] = value;
    // 队尾指针后移一位，到末尾就绕回头部
    this.tail = (this.tail + 1) % this.capacity;
    this.count++;
    return true;
  }

  // 出队
  dequeue(): boolean {
    if (this.is_empty()) return false;

    // 队首指针后移一位
    this.head = (this.head + 1) % this.capacity;
    this.count--;
    return true;
  }

  // 查看队首元素
  front(): number {
    if (this.is_empty()) return -1;
    return this.data[this.head];
  }

  // 查看队尾元素
  rear(): number {
    if (this.is_empty()) return -1;
    // 队尾元素的位置：(tail - 1 + capacity) % capacity
    return this.data[(this.tail - 1 + this.capacity) % this.capacity];
  }

  is_empty(): boolean {
    return this.count === 0;
  }

  is_full(): boolean {
    return this.count === this.capacity;
  }
}

// 测试
const cq = new CircularQueue(3);  // 容量为3
console.log(cq.enqueue(1));  // true   队列：[1, _, _]
console.log(cq.enqueue(2));  // true   队列：[1, 2, _]
console.log(cq.enqueue(3));  // true   队列：[1, 2, 3]
console.log(cq.enqueue(4));  // false  队列满了！
console.log(cq.front());     // 1
console.log(cq.dequeue());   // true   队列：[_, 2, 3]
console.log(cq.enqueue(4));  // true   队列：[4, 2, 3]（4绕到前面的空位）
console.log(cq.rear());      // 4
```

##### 五、双端队列（Deque）

```typescript
// ========== 双端队列：两端都可以入队/出队 ==========
class Deque {
  private _data: number[] = [];

  // 右端入队
  pushRight(item: number): void {
    this._data.push(item);
  }

  // 左端入队（O(n)，演示概念用）
  pushLeft(item: number): void {
    this._data.unshift(item);
  }

  // 右端出队
  popRight(): number {
    if (this.isEmpty()) throw new Error("empty deque");
    return this._data.pop()!;
  }

  // 左端出队（O(n)，演示概念用）
  popLeft(): number {
    if (this.isEmpty()) throw new Error("empty deque");
    return this._data.shift()!;
  }

  isEmpty(): boolean {
    return this._data.length === 0;
  }

  toString(): string {
    return `Deque: [${this._data}]`;
  }
}

// 测试
const dq = new Deque();
dq.pushRight(1);       // 右端入队：[1]
dq.pushRight(2);       // 右端入队：[1, 2]
dq.pushLeft(0);        // 左端入队：[0, 1, 2]
dq.pushLeft(-1);       // 左端入队：[-1, 0, 1, 2]
console.log(dq.toString());       // [-1, 0, 1, 2]
console.log(dq.popRight());       // 2
console.log(dq.popLeft());        // -1
console.log(dq.toString());       // [0, 1]
```

##### 六、队列的经典应用

```typescript
// ========== 1. BFS 广度优先搜索（预告）==========
function bfs(graph: Map<string, string[]>, start: string): string[] {
  const visited = new Set<string>();   // 记录已访问的节点
  const queue: string[] = [start];     // 队列中放待访问的节点
  visited.add(start);
  const order: string[] = [];          // 记录访问顺序

  while (queue.length > 0) {
    const node = queue.shift()!;       // 取出队首节点
    order.push(node);

    // 把该节点的所有未访问邻居加入队列
    for (const neighbor of graph.get(node) ?? []) {
      if (!visited.has(neighbor)) {
        visited.add(neighbor);
        queue.push(neighbor);
      }
    }
  }

  return order;
}

// 测试：一个简单的图
const graph = new Map<string, string[]>([
  ["A", ["B", "C"]],
  ["B", ["A", "D", "E"]],
  ["C", ["A", "F"]],
  ["D", ["B"]],
  ["E", ["B", "F"]],
  ["F", ["C", "E"]],
]);
console.log("BFS 顺序:", bfs(graph, "A"));  // ['A', 'B', 'C', 'D', 'E', 'F']

// ========== 2. 任务调度模拟 ==========
class TaskScheduler {
  private queue: string[] = [];

  // 添加任务到队列
  add_task(taskName: string): void {
    this.queue.push(taskName);
    console.log(`任务 '${taskName}' 已加入队列`);
  }

  // 按顺序处理所有任务
  process_tasks(): void {
    console.log("\n开始处理任务...");
    while (this.queue.length > 0) {
      const task = this.queue.shift()!;
      console.log(`  正在处理: ${task}`);
      // 模拟处理时间
      // await sleep(500);
    }
    console.log("所有任务处理完毕！\n");
  }
}

// 测试
const taskScheduler = new TaskScheduler();
taskScheduler.add_task("打印报告.pdf");
taskScheduler.add_task("发送邮件");
taskScheduler.add_task("备份数据库");
taskScheduler.process_tasks();
// 输出顺序：打印报告.pdf → 发送邮件 → 备份数据库

// ========== 3. 生产者消费者模型简介 ==========
class ProducerConsumer {
  private queue: string[] = [];
  private capacity: number;

  constructor(capacity = 5) {
    this.capacity = capacity;  // 队列最大容量
  }

  // 生产者：放入数据
  produce(item: string): boolean {
    if (this.queue.length >= this.capacity) {
      console.log(`  队列已满！'${item}' 等待中...`);
      return false;
    }
    this.queue.push(item);
    console.log(`  生产: ${item}，队列长度: ${this.queue.length}`);
    return true;
  }

  // 消费者：取出数据
  consume(): string | null {
    if (this.queue.length === 0) {
      console.log("  队列为空，等待生产...");
      return null;
    }
    const item = this.queue.shift()!;
    console.log(`  消费: ${item}，队列长度: ${this.queue.length}`);
    return item;
  }
}

// 测试
const pc = new ProducerConsumer(3);
console.log("=== 生产阶段 ===");
pc.produce("数据A");
pc.produce("数据B");
pc.produce("数据C");
pc.produce("数据D");  // 队列满了

console.log("\n=== 消费阶段 ===");
pc.consume();
pc.consume();

console.log("\n=== 继续生产 ===");
pc.produce("数据D");
pc.produce("数据E");
```

##### 七、经典例题

```typescript
// ========== 例题1：用两个栈实现队列（LeetCode 232）==========
// 核心思路：
// - inStack 负责接收新元素
// - outStack 负责输出元素
// - 当 outStack 为空时，把 inStack 的元素全部倒入 outStack
//   （倒过来之后，最先进 inStack 的元素就到了 outStack 的栈顶）
class MyQueueByStack {
  private inStack: number[] = [];
  private outStack: number[] = [];

  // 入队：压入 inStack
  push(x: number): void {
    this.inStack.push(x);
  }

  // 出队：从 outStack 弹出
  pop(): number {
    this.ensureOutStack();
    return this.outStack.pop()!;
  }

  // 查看队首
  peek(): number {
    this.ensureOutStack();
    return this.outStack[this.outStack.length - 1];
  }

  empty(): boolean {
    return this.inStack.length === 0 && this.outStack.length === 0;
  }

  // 确保 outStack 有元素
  private ensureOutStack(): void {
    if (this.outStack.length === 0) {
      while (this.inStack.length > 0) {
        this.outStack.push(this.inStack.pop()!);
      }
    }
  }
}

// 测试
const mq = new MyQueueByStack();
mq.push(1);
mq.push(2);
console.log(mq.peek());   // 1
console.log(mq.pop());    // 1
console.log(mq.empty());  // false

// ========== 例题2：用队列实现栈（LeetCode 225）==========
// 思路：每次 push 新元素后，把之前的所有元素重新排到新元素后面
// 这样新元素就总是在队首（栈顶）
class MyStackByQueue {
  private queue: number[] = [];

  // 入栈：
  // 1. 先把 x 加到队尾
  // 2. 然后把队尾之前的所有元素都移到队尾（绕一圈）
  // 这样 x 就到了队首
  push(x: number): void {
    this.queue.push(x);
    // 把 x 之前的所有元素都移到 x 后面
    for (let i = 0; i < this.queue.length - 1; i++) {
      this.queue.push(this.queue.shift()!);
    }
    // 现在 x 在队首
  }

  // 出栈：弹出队首
  pop(): number {
    return this.queue.shift()!;
  }

  // 查看栈顶：队首元素
  top(): number {
    return this.queue[0];
  }

  empty(): boolean {
    return this.queue.length === 0;
  }
}

// 测试
const stack = new MyStackByQueue();
stack.push(1);   // 队列：[1]
stack.push(2);   // 队列：[2, 1]（2绕到了队首）
stack.push(3);   // 队列：[3, 2, 1]
console.log(stack.top());    // 3
console.log(stack.pop());    // 3
console.log(stack.pop());    // 2
console.log(stack.pop());    // 1

// ========== 例题3：最近的请求次数（LeetCode 933）==========
// 思路：用队列存储所有请求的时间戳
// 每次新请求进来时，把超过 3000ms 范围的旧请求从队首踢出去
class RecentCounter {
  private queue: number[] = [];  // 存储请求时间戳

  // 在时间 t 发起一次请求，返回 [t-3000, t] 范围内的请求数
  // t 保证严格递增（每次调用都比上次大）
  ping(t: number): number {
    this.queue.push(t);  // 新请求加入队尾

    // 把超出 [t-3000, t] 范围的旧请求从队首踢出去
    while (this.queue[0] < t - 3000) {
      this.queue.shift();
    }

    return this.queue.length;  // 队列中剩余的就是范围内的请求数
  }
}

// 测试
const counter = new RecentCounter();
console.log(counter.ping(1));     // 1，队列：[1]，范围[-2999, 1]内有1个
console.log(counter.ping(100));   // 2，队列：[1, 100]
console.log(counter.ping(3001));  // 3，队列：[1, 100, 3001]
console.log(counter.ping(3002));  // 3，队列：[100, 3001, 3002]（1被踢出去了）
```

##### 八、优先队列简介

```typescript
// ========== 优先队列：优先级高的先出 ==========
// 普通队列是"先进先出"，优先队列是"优先级高的先出"
class PriorityQueue {
  private heap: [number, number, string][] = [];  // [priority, index, item]
  private index = 0;  // 用于打破优先级相同时的平局

  // 入队：按优先级插入（priority 越小，优先级越高）
  push(item: string, priority: number): void {
    this.heap.push([priority, this.index, item]);
    this.index++;
    this.bubbleUp(this.heap.length - 1);  // 上浮
  }

  // 出队：弹出优先级最高（值最小）的元素
  pop(): string {
    if (this.is_empty()) throw new Error("Queue is empty");
    const top = this.heap[0];
    const last = this.heap.pop()!;
    if (this.heap.length > 0) {
      this.heap[0] = last;
      this.bubbleDown(0);  // 下沉
    }
    return top[2];
  }

  is_empty(): boolean {
    return this.heap.length === 0;
  }

  // 上浮：新元素向上调整到合适位置
  private bubbleUp(i: number): void {
    while (i > 0) {
      const parent = Math.floor((i - 1) / 2);
      if (this.compare(this.heap[i], this.heap[parent]) >= 0) break;
      [this.heap[i], this.heap[parent]] = [this.heap[parent], this.heap[i]];
      i = parent;
    }
  }

  // 下沉：堆顶元素向下调整到合适位置
  private bubbleDown(i: number): void {
    while (true) {
      let smallest = i;
      const left = 2 * i + 1;
      const right = 2 * i + 2;
      if (left < this.heap.length && this.compare(this.heap[left], this.heap[smallest]) < 0) smallest = left;
      if (right < this.heap.length && this.compare(this.heap[right], this.heap[smallest]) < 0) smallest = right;
      if (smallest === i) break;
      [this.heap[i], this.heap[smallest]] = [this.heap[smallest], this.heap[i]];
      i = smallest;
    }
  }

  // 比较两个元素：先比优先级，再比入队顺序
  private compare(a: [number, number, string], b: [number, number, string]): number {
    if (a[0] !== b[0]) return a[0] - b[0];
    return a[1] - b[1];
  }
}

// 测试
const pq = new PriorityQueue();
pq.push("普通感冒", 3);
pq.push("心脏骤停", 1);   // 最紧急
pq.push("骨折", 2);

console.log(pq.pop());  // 心脏骤停（优先级1，最高）
console.log(pq.pop());  // 骨折（优先级2）
console.log(pq.pop());  // 普通感冒（优先级3，最低）
```

> **优先队列的底层是"堆"（Heap）**，push 和 pop 的时间复杂度都是 **O(log n)**。堆的内容我们会在后面的主题中详细学习。

### 主题6 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、用切片实现队列（方式一，不推荐）

```go
package main

import "fmt"

// ========== 用切片实现队列（效率低，不推荐）==========
// 问题：切片头部移除是 O(n)！
// 因为弹出第一个元素后，后面所有元素都要前移一位。
type QueueBySlice struct {
	data []int
}

func NewQueueBySlice() *QueueBySlice {
	return &QueueBySlice{data: []int{}}
}

// 入队：在切片末尾添加（O(1)）
func (q *QueueBySlice) Enqueue(item int) {
	q.data = append(q.data, item)
}

// 出队：从切片开头移除（O(n) ← 问题在这里！）
func (q *QueueBySlice) Dequeue() int {
	if q.IsEmpty() {
		panic("dequeue from empty queue")
	}
	val := q.data[0]
	q.data = q.data[1:]
	return val
}

// 查看队首（O(1)）
func (q *QueueBySlice) Front() int {
	if q.IsEmpty() {
		panic("queue is empty")
	}
	return q.data[0]
}

func (q *QueueBySlice) IsEmpty() bool {
	return len(q.data) == 0
}

func (q *QueueBySlice) Size() int {
	return len(q.data)
}
```

##### 二、用链表实现队列（方式二，高效）

```go
package main

// ========== 用链表实现队列（高效，O(1) 的入队和出队）==========
// 思路：维护 head 和 tail 两个指针
// - 入队：在 tail 后面添加新节点
// - 出队：删除 head 节点
type QueueByLinkedList struct {
	head *ListNode // 队首指针
	tail *ListNode // 队尾指针
	size int
}

func NewQueueByLinkedList() *QueueByLinkedList {
	return &QueueByLinkedList{}
}

// 入队：在尾部添加（O(1)）
func (q *QueueByLinkedList) Enqueue(item int) {
	newNode := NewListNode(item, nil)
	if q.tail == nil {
		// 空队列
		q.head = newNode
		q.tail = newNode
	} else {
		q.tail.Next = newNode
		q.tail = newNode
	}
	q.size++
}

// 出队：从头部移除（O(1)）
func (q *QueueByLinkedList) Dequeue() int {
	if q.IsEmpty() {
		panic("dequeue from empty queue")
	}
	val := q.head.Val
	q.head = q.head.Next
	if q.head == nil {
		q.tail = nil // 队列空了，tail 也要清空
	}
	q.size--
	return val
}

// 查看队首（O(1)）
func (q *QueueByLinkedList) Front() int {
	if q.IsEmpty() {
		panic("queue is empty")
	}
	return q.head.Val
}

func (q *QueueByLinkedList) IsEmpty() bool {
	return q.head == nil
}

func (q *QueueByLinkedList) Size() int {
	return q.size
}
```

##### 三、用切片 + 头指针实现高效队列（推荐方式）

```go
package main

import "fmt"

// ========== 用切片 + 头指针实现高效队列 ==========
// 思路：不真的移除队首元素，而是用 headIndex 标记队首位置
// 出队只是 headIndex + 1，避免移动所有元素！
type Queue struct {
	data      []int
	headIndex int // 队首位置
}

func NewQueue() *Queue {
	return &Queue{data: []int{}, headIndex: 0}
}

// 入队：从右端添加（O(1)）
func (q *Queue) Enqueue(item int) {
	q.data = append(q.data, item)
}

// 出队：队首指针后移（均摊 O(1)）
func (q *Queue) Dequeue() int {
	if q.IsEmpty() {
		panic("dequeue from empty queue")
	}
	val := q.data[q.headIndex]
	q.headIndex++
	return val
}

// 查看队首（O(1)）
func (q *Queue) Front() int {
	if q.IsEmpty() {
		panic("queue is empty")
	}
	return q.data[q.headIndex]
}

func (q *Queue) IsEmpty() bool {
	return q.headIndex >= len(q.data)
}

func (q *Queue) Size() int {
	return len(q.data) - q.headIndex
}

func testQueue() {
	// 测试
	q := NewQueue()
	q.Enqueue(10)
	q.Enqueue(20)
	q.Enqueue(30)
	fmt.Println(q.Dequeue()) // 10（先进先出）
	fmt.Println(q.Dequeue()) // 20
	fmt.Println(q.Front())   // 30
}
```

##### 四、循环队列

```go
package main

import "fmt"

// ========== 循环队列：用固定大小的数组实现 ==========
// 关键：用取模运算 % 实现"绕圈"
// - 下一个位置 = (当前位置 + 1) % 容量
type CircularQueue struct {
	capacity int
	data     []int
	head     int // 队首指针（下标）
	tail     int // 队尾指针（下一个入队位置）
	count    int // 当前元素个数
}

func NewCircularQueue(k int) *CircularQueue {
	return &CircularQueue{
		capacity: k,
		data:     make([]int, k),
		head:     0,
		tail:     0,
		count:    0,
	}
}

// 入队
func (cq *CircularQueue) Enqueue(value int) bool {
	if cq.IsFull() {
		return false // 队列满了
	}
	cq.data[cq.tail] = value
	// 队尾指针后移一位，到末尾就绕回头部
	cq.tail = (cq.tail + 1) % cq.capacity
	cq.count++
	return true
}

// 出队
func (cq *CircularQueue) Dequeue() bool {
	if cq.IsEmpty() {
		return false
	}
	// 队首指针后移一位
	cq.head = (cq.head + 1) % cq.capacity
	cq.count--
	return true
}

// 查看队首元素
func (cq *CircularQueue) Front() int {
	if cq.IsEmpty() {
		return -1
	}
	return cq.data[cq.head]
}

// 查看队尾元素
func (cq *CircularQueue) Rear() int {
	if cq.IsEmpty() {
		return -1
	}
	// 队尾元素的位置：(tail - 1 + capacity) % capacity
	return cq.data[(cq.tail-1+cq.capacity)%cq.capacity]
}

func (cq *CircularQueue) IsEmpty() bool {
	return cq.count == 0
}

func (cq *CircularQueue) IsFull() bool {
	return cq.count == cq.capacity
}

func testCircularQueue() {
	// 测试
	cq := NewCircularQueue(3) // 容量为3
	fmt.Println(cq.Enqueue(1)) // true   队列：[1, _, _]
	fmt.Println(cq.Enqueue(2)) // true   队列：[1, 2, _]
	fmt.Println(cq.Enqueue(3)) // true   队列：[1, 2, 3]
	fmt.Println(cq.Enqueue(4)) // false  队列满了！
	fmt.Println(cq.Front())    // 1
	fmt.Println(cq.Dequeue())  // true   队列：[_, 2, 3]
	fmt.Println(cq.Enqueue(4)) // true   队列：[4, 2, 3]（4绕到前面的空位）
	fmt.Println(cq.Rear())     // 4
}
```

##### 五、双端队列（Deque）

```go
package main

import "fmt"

// ========== 双端队列：两端都可以入队/出队 ==========
// Go 用两个切片操作模拟两端，实际工程中用 container/list 双链表更高效
type Deque struct {
	data []int
}

func NewDeque() *Deque {
	return &Deque{data: []int{}}
}

// 右端入队
func (d *Deque) PushRight(item int) {
	d.data = append(d.data, item)
}

// 左端入队（O(n)，演示概念用）
func (d *Deque) PushLeft(item int) {
	d.data = append([]int{item}, d.data...)
}

// 右端出队
func (d *Deque) PopRight() int {
	if d.IsEmpty() {
		panic("empty deque")
	}
	val := d.data[len(d.data)-1]
	d.data = d.data[:len(d.data)-1]
	return val
}

// 左端出队（O(n)，演示概念用）
func (d *Deque) PopLeft() int {
	if d.IsEmpty() {
		panic("empty deque")
	}
	val := d.data[0]
	d.data = d.data[1:]
	return val
}

func (d *Deque) IsEmpty() bool {
	return len(d.data) == 0
}

func (d *Deque) String() string {
	return fmt.Sprintf("Deque: %v", d.data)
}

func testDeque() {
	// 测试
	dq := NewDeque()
	dq.PushRight(1)   // 右端入队：[1]
	dq.PushRight(2)   // 右端入队：[1, 2]
	dq.PushLeft(0)    // 左端入队：[0, 1, 2]
	dq.PushLeft(-1)   // 左端入队：[-1, 0, 1, 2]
	fmt.Println(dq)   // [-1 0 1 2]
	fmt.Println(dq.PopRight()) // 2
	fmt.Println(dq.PopLeft())  // -1
	fmt.Println(dq)   // [0 1]
}
```

##### 六、队列的经典应用

```go
package main

import "fmt"

// ========== 1. BFS 广度优先搜索（预告）==========
// graph: 邻接表形式的图（用 map 实现）
func BFS(graph map[string][]string, start string) []string {
	visited := map[string]bool{start: true} // 记录已访问的节点
	queue := []string{start}                // 队列中放待访问的节点
	order := []string{}                     // 记录访问顺序

	for len(queue) > 0 {
		node := queue[0]      // 取出队首节点
		queue = queue[1:]
		order = append(order, node)

		// 把该节点的所有未访问邻居加入队列
		for _, neighbor := range graph[node] {
			if !visited[neighbor] {
				visited[neighbor] = true
				queue = append(queue, neighbor)
			}
		}
	}
	return order
}

func testBFS() {
	// 测试：一个简单的图
	graph := map[string][]string{
		"A": {"B", "C"},
		"B": {"A", "D", "E"},
		"C": {"A", "F"},
		"D": {"B"},
		"E": {"B", "F"},
		"F": {"C", "E"},
	}
	fmt.Println("BFS 顺序:", BFS(graph, "A")) // [A B C D E F]
}

// ========== 2. 任务调度模拟 ==========
type TaskScheduler struct {
	queue []string
}

func NewTaskScheduler() *TaskScheduler {
	return &TaskScheduler{queue: []string{}}
}

// 添加任务到队列
func (ts *TaskScheduler) AddTask(taskName string) {
	ts.queue = append(ts.queue, taskName)
	fmt.Printf("任务 '%s' 已加入队列\n", taskName)
}

// 按顺序处理所有任务
func (ts *TaskScheduler) ProcessTasks() {
	fmt.Println("\n开始处理任务...")
	for len(ts.queue) > 0 {
		task := ts.queue[0]
		ts.queue = ts.queue[1:]
		fmt.Printf("  正在处理: %s\n", task)
	}
	fmt.Println("所有任务处理完毕！\n")
}

func testTaskScheduler() {
	// 测试
	scheduler := NewTaskScheduler()
	scheduler.AddTask("打印报告.pdf")
	scheduler.AddTask("发送邮件")
	scheduler.AddTask("备份数据库")
	scheduler.ProcessTasks()
	// 输出顺序：打印报告.pdf → 发送邮件 → 备份数据库
}

// ========== 3. 生产者消费者模型简介 ==========
type ProducerConsumer struct {
	queue    []string
	capacity int // 队列最大容量
}

func NewProducerConsumer(capacity int) *ProducerConsumer {
	return &ProducerConsumer{queue: []string{}, capacity: capacity}
}

// 生产者：放入数据
func (pc *ProducerConsumer) Produce(item string) bool {
	if len(pc.queue) >= pc.capacity {
		fmt.Printf("  队列已满！'%s' 等待中...\n", item)
		return false
	}
	pc.queue = append(pc.queue, item)
	fmt.Printf("  生产: %s，队列长度: %d\n", item, len(pc.queue))
	return true
}

// 消费者：取出数据
func (pc *ProducerConsumer) Consume() *string {
	if len(pc.queue) == 0 {
		fmt.Println("  队列为空，等待生产...")
		return nil
	}
	item := pc.queue[0]
	pc.queue = pc.queue[1:]
	fmt.Printf("  消费: %s，队列长度: %d\n", item, len(pc.queue))
	return &item
}

func testProducerConsumer() {
	// 测试
	pc := NewProducerConsumer(3)
	fmt.Println("=== 生产阶段 ===")
	pc.Produce("数据A")
	pc.Produce("数据B")
	pc.Produce("数据C")
	pc.Produce("数据D") // 队列满了

	fmt.Println("\n=== 消费阶段 ===")
	pc.Consume()
	pc.Consume()

	fmt.Println("\n=== 继续生产 ===")
	pc.Produce("数据D")
	pc.Produce("数据E")
}
```

##### 七、经典例题

```go
package main

import "fmt"

// ========== 例题1：用两个栈实现队列（LeetCode 232）==========
// 核心思路：
// - inStack 负责接收新元素
// - outStack 负责输出元素
// - 当 outStack 为空时，把 inStack 的元素全部倒入 outStack
type MyQueueByStack struct {
	inStack  []int
	outStack []int
}

func NewMyQueueByStack() *MyQueueByStack {
	return &MyQueueByStack{inStack: []int{}, outStack: []int{}}
}

// 入队：压入 inStack
func (mq *MyQueueByStack) Push(x int) {
	mq.inStack = append(mq.inStack, x)
}

// 出队：从 outStack 弹出
func (mq *MyQueueByStack) Pop() int {
	mq.ensureOutStack()
	val := mq.outStack[len(mq.outStack)-1]
	mq.outStack = mq.outStack[:len(mq.outStack)-1]
	return val
}

// 查看队首
func (mq *MyQueueByStack) Peek() int {
	mq.ensureOutStack()
	return mq.outStack[len(mq.outStack)-1]
}

func (mq *MyQueueByStack) Empty() bool {
	return len(mq.inStack) == 0 && len(mq.outStack) == 0
}

// 确保 outStack 有元素
func (mq *MyQueueByStack) ensureOutStack() {
	if len(mq.outStack) == 0 {
		for len(mq.inStack) > 0 {
			val := mq.inStack[len(mq.inStack)-1]
			mq.inStack = mq.inStack[:len(mq.inStack)-1]
			mq.outStack = append(mq.outStack, val)
		}
	}
}

// ========== 例题2：用队列实现栈（LeetCode 225）==========
// 思路：每次 push 新元素后，把之前的所有元素重新排到新元素后面
type MyStackByQueue struct {
	queue []int
}

func NewMyStackByQueue() *MyStackByQueue {
	return &MyStackByQueue{queue: []int{}}
}

// 入栈：
// 1. 先把 x 加到队尾
// 2. 然后把队尾之前的所有元素都移到队尾（绕一圈）
// 这样 x 就到了队首
func (ms *MyStackByQueue) Push(x int) {
	ms.queue = append(ms.queue, x)
	// 把 x 之前的所有元素都移到 x 后面
	for i := 0; i < len(ms.queue)-1; i++ {
		val := ms.queue[0]
		ms.queue = ms.queue[1:]
		ms.queue = append(ms.queue, val)
	}
	// 现在 x 在队首
}

// 出栈：弹出队首
func (ms *MyStackByQueue) Pop() int {
	val := ms.queue[0]
	ms.queue = ms.queue[1:]
	return val
}

// 查看栈顶：队首元素
func (ms *MyStackByQueue) Top() int {
	return ms.queue[0]
}

func (ms *MyStackByQueue) Empty() bool {
	return len(ms.queue) == 0
}

// ========== 例题3：最近的请求次数（LeetCode 933）==========
// 思路：用队列存储所有请求的时间戳
// 每次新请求进来时，把超过 3000ms 范围的旧请求从队首踢出去
type RecentCounter struct {
	queue []int // 存储请求时间戳
}

func NewRecentCounter() *RecentCounter {
	return &RecentCounter{queue: []int{}}
}

// 在时间 t 发起一次请求，返回 [t-3000, t] 范围内的请求数
// t 保证严格递增（每次调用都比上次大）
func (rc *RecentCounter) Ping(t int) int {
	rc.queue = append(rc.queue, t) // 新请求加入队尾

	// 把超出 [t-3000, t] 范围的旧请求从队首踢出去
	for len(rc.queue) > 0 && rc.queue[0] < t-3000 {
		rc.queue = rc.queue[1:]
	}

	return len(rc.queue) // 队列中剩余的就是范围内的请求数
}

func testQueueExamples() {
	// 例题1测试
	mq := NewMyQueueByStack()
	mq.Push(1)
	mq.Push(2)
	fmt.Println(mq.Peek())  // 1
	fmt.Println(mq.Pop())   // 1
	fmt.Println(mq.Empty()) // false

	// 例题2测试
	stack := NewMyStackByQueue()
	stack.Push(1) // 队列：[1]
	stack.Push(2) // 队列：[2, 1]（2绕到了队首）
	stack.Push(3) // 队列：[3, 2, 1]
	fmt.Println(stack.Top()) // 3
	fmt.Println(stack.Pop()) // 3
	fmt.Println(stack.Pop()) // 2
	fmt.Println(stack.Pop()) // 1

	// 例题3测试
	counter := NewRecentCounter()
	fmt.Println(counter.Ping(1))     // 1，范围[-2999, 1]内有1个
	fmt.Println(counter.Ping(100))   // 2
	fmt.Println(counter.Ping(3001))  // 3
	fmt.Println(counter.Ping(3002))  // 3（1被踢出去了）
}
```

##### 八、优先队列简介

```go
package main

import (
	"container/heap"
	"fmt"
)

// ========== 优先队列：优先级高的先出 ==========
// Go 用 container/heap 实现最小堆，只需实现 heap.Interface 接口
// 普通队列是"先进先出"，优先队列是"优先级高的先出"

// 队列元素：priority 越小，优先级越高
type PQItem struct {
	priority int
	index    int // 用于打破优先级相同时的平局
	value    string
}

// 实现 heap.Interface 接口
type PriorityQueue struct {
	items []PQItem
}

func NewPriorityQueue() *PriorityQueue {
	pq := &PriorityQueue{items: []PQItem{}}
	heap.Init(pq)
	return pq
}

func (pq *PriorityQueue) Len() int { return len(pq.items) }

// 最小堆：priority 小的优先级高
func (pq *PriorityQueue) Less(i, j int) bool {
	if pq.items[i].priority != pq.items[j].priority {
		return pq.items[i].priority < pq.items[j].priority
	}
	return pq.items[i].index < pq.items[j].index
}

func (pq *PriorityQueue) Swap(i, j int) {
	pq.items[i], pq.items[j] = pq.items[j], pq.items[i]
}

func (pq *PriorityQueue) Push(x interface{}) {
	pq.items = append(pq.items, x.(PQItem))
}

func (pq *PriorityQueue) Pop() interface{} {
	old := pq.items
	n := len(old)
	item := old[n-1]
	pq.items = old[:n-1]
	return item
}

// 入队：按优先级插入（priority 越小，优先级越高）
func (pq *PriorityQueue) Enqueue(item string, priority int) {
	idx := len(pq.items)
	heap.Push(pq, PQItem{priority: priority, index: idx, value: item})
}

// 出队：弹出优先级最高（值最小）的元素
func (pq *PriorityQueue) Dequeue() string {
	if pq.Len() == 0 {
		panic("Queue is empty")
	}
	return heap.Pop(pq).(PQItem).value
}

func (pq *PriorityQueue) IsEmpty() bool {
	return pq.Len() == 0
}

func testPriorityQueue() {
	// 测试
	pq := NewPriorityQueue()
	pq.Enqueue("普通感冒", 3)
	pq.Enqueue("心脏骤停", 1) // 最紧急
	pq.Enqueue("骨折", 2)

	fmt.Println(pq.Dequeue()) // 心脏骤停（优先级1，最高）
	fmt.Println(pq.Dequeue()) // 骨折（优先级2）
	fmt.Println(pq.Dequeue()) // 普通感冒（优先级3，最低）
}
```

> **优先队列的底层是"堆"（Heap）**，push 和 pop 的时间复杂度都是 **O(log n)**。堆的内容我们会在后面的主题中详细学习。

---

## 第三阶段：基础算法

### 主题7：递归（Recursion）


#### 一、递归的概念

##### 什么是递归？

**一句话定义：递归就是函数调用自己。**

这听起来像是"套娃"——打开一个俄罗斯套娃，里面还有一个更小的套娃，再打开，里面还有一个……直到最后一个最小的、打不开的套娃为止。

递归的思想完全一样：**把一个大问题拆成一个更小的、和原问题同类的小问题，然后用同样的方法去解决那个小问题。**

##### 用生活中的例子理解递归

想象你在排队，你想知道自己是第几个，但又不想数。怎么办？

你可以**问前面的人是第几个**，然后在他的答案上加1，就是你的位置了。

但前面的人也不知道自己是第几个怎么办？他也可以**问他前面的人**！

就这样，每个人都在问前面的人，一直传到队伍最前面那个人。最前面的人前面没人了，他可以直接回答："我是第1个！"

然后这个回答一层层往回传：
- 第1个人：我是第1个
- 第2个人：他是第1个，那我是第2个
- 第3个人：他是第2个，那我是第3个
- ……
- 你：他前面那个人是第N个，那我就是第N+1个！

这就是递归！关键有两个：
1. **最前面的人知道自己是第1个** —— 这叫"基准情形"（base case），就是停下来的条件
2. **每个人问前面的人，然后+1** —— 这叫"递推关系"（recursive case），就是把问题变小的方法

---

#### 二、递归的两个核心要素

##### 1. 基准情形（Base Case）

> 什么时候停下来？最简单的情况是什么？

没有基准情形的递归就像无限套娃，永远停不下来，程序会崩溃。

##### 2. 递推关系（Recursive Case）

> 怎么把大问题变成小问题？

递推关系要确保每次调用都在**向基准情形靠近**，否则永远到不了终点。

##### 写递归函数的模板

```python
def recursive_function(问题规模):
    # 1. 基准情形：最简单的情况，直接返回答案
    if 满足基准条件:
        return 基础答案
    
    # 2. 递推关系：把大问题拆成小问题，调用自身
    return recursive_function(更小的问题)
```

---

#### 三、Python实现基础递归

##### 3.1 计算阶乘 n!

**什么是阶乘？** n! = n × (n-1) × (n-2) × ... × 1

比如 5! = 5 × 4 × 3 × 2 × 1 = 120

**递归思路：**
- 5! = 5 × 4!  —— 要求5!，先求4!
- 4! = 4 × 3!  —— 要求4!，先求3!
- ……
- 1! = 1        —— 基准情形！直接知道答案

**递推关系：** n! = n × (n-1)!

**基准情形：** 1! = 1

```python
def factorial(n):
    """
    计算 n 的阶乘
    n! = n × (n-1) × (n-2) × ... × 1
    """
    # 基准情形：0! = 1, 1! = 1
    if n <= 1:
        return 1
    
    # 递推关系：n! = n × (n-1)!
    # 要求 n!，就先求 (n-1)!，然后乘以 n
    return n * factorial(n - 1)

# 测试
print(factorial(5))  # 输出: 120  (5×4×3×2×1)
print(factorial(3))  # 输出: 6    (3×2×1)
print(factorial(0))  # 输出: 1    (0! 定义为1)
```

##### 3.2 斐波那契数列

**什么是斐波那契数列？**

数列：1, 1, 2, 3, 5, 8, 13, 21, 34, ...

规律：从第3项开始，每一项 = 前两项之和。

这个数列在自然界中无处不在：向日葵的种子排列、鹦鹉螺的壳、树枝的分叉……

**递归思路：**
- 基准情形：第1项=1，第2项=1
- 递推关系：F(n) = F(n-1) + F(n-2)

```python
def fibonacci(n):
    """
    返回斐波那契数列的第 n 项
    数列: 1, 1, 2, 3, 5, 8, 13, 21, ...
    """
    # 基准情形
    if n == 1 or n == 2:
        return 1
    
    # 递推关系：第n项 = 第(n-1)项 + 第(n-2)项
    return fibonacci(n - 1) + fibonacci(n - 2)

# 测试
for i in range(1, 11):
    print(f"F({i}) = {fibonacci(i)}")
# 输出: F(1)=1, F(2)=1, F(3)=2, F(4)=3, F(5)=5, F(6)=8 ...
```

###### 朴素递归的问题：大量重复计算！

计算 F(6) 时发生了什么？

```
                    F(6)
                   /    \
              F(5)      +    F(4)
             /    \         /    \
        F(4)  +  F(3)   F(3) + F(2)
        / \     / \      / \
    F(3)+F(2) F(2)+F(1) F(2)+F(1)
    / \
F(2)+F(1)
```

看到了吗？F(4) 被计算了2次，F(3) 被计算了3次！随着 n 增大，重复计算呈**指数级增长**。

这就是为什么 `fibonacci(50)` 可能会算到天荒地老——时间复杂度是 O(2^n)。

```python
# 用"记忆化"来优化：把算过的结果存起来
def fibonacci_memo(n, memo={}):
    """带记忆化的斐波那契，避免重复计算"""
    if n == 1 or n == 2:
        return 1
    
    # 如果已经算过了，直接返回存过的结果
    if n in memo:
        return memo[n]
    
    # 算完存起来
    memo[n] = fibonacci_memo(n - 1, memo) + fibonacci_memo(n - 2, memo)
    return memo[n]

# 现在 fibonacci_memo(100) 也能瞬间算出来！
print(fibonacci_memo(100))  # 输出: 354224848179261915075
```

##### 3.3 数组求和

**问题：** 用递归计算数组所有元素之和。

**递归思路：**
- 基准情形：空数组的和为0
- 递推关系：数组的和 = 第一个元素 + 剩余元素的和

```python
def array_sum(arr):
    """
    递归计算数组所有元素之和
    例: [1, 2, 3, 4] -> 1 + 2 + 3 + 4 = 10
    """
    # 基准情形：空数组的和是0
    if len(arr) == 0:
        return 0
    
    # 递推关系：第一个元素 + 剩下元素的和
    # [1, 2, 3, 4] -> 1 + array_sum([2, 3, 4])
    #               -> 1 + 2 + array_sum([3, 4])
    #               -> 1 + 2 + 3 + array_sum([4])
    #               -> 1 + 2 + 3 + 4 + array_sum([])
    #               -> 1 + 2 + 3 + 4 + 0 = 10
    return arr[0] + array_sum(arr[1:])

# 测试
print(array_sum([1, 2, 3, 4, 5]))  # 输出: 15
print(array_sum([10]))              # 输出: 10
print(array_sum([]))                # 输出: 0
```

##### 3.4 计算数组中最大元素

**递归思路：**
- 基准情形：只有一个元素的数组，最大值就是它
- 递推关系：整个数组的最大值 = 第一个元素 和 剩余元素最大值 中较大的那个

```python
def find_max(arr):
    """
    递归找到数组中的最大元素
    """
    # 基准情形：只有一个元素
    if len(arr) == 1:
        return arr[0]
    
    # 递推关系：比较第一个元素和剩余部分的最大值
    # 整个数组的最大值 = max(第一个元素, 剩余部分的最大值)
    sub_max = find_max(arr[1:])  # 剩余部分的最大值
    return arr[0] if arr[0] > sub_max else sub_max

# 测试
print(find_max([3, 1, 4, 1, 5, 9, 2, 6]))  # 输出: 9
print(find_max([7, 7, 7]))                   # 输出: 7
print(find_max([-1, -5, -3]))                # 输出: -1
```

---

#### 四、递归的执行过程：调用栈

每次函数调用时，计算机都会在内存中开辟一块"栈帧"来保存这次调用的局部变量和状态。这些栈帧一层层堆起来，就像一个**叠盘子**的过程——最后放上去的盘子最先被拿走（后进先出）。

##### 以 factorial(4) 为例，完整展示调用栈：

```
=== 递推阶段（不断调用，往栈里压盘子）===

第1层调用: factorial(4)
  → 4 * factorial(3)     ← 需要先知道 factorial(3) 的结果
  栈: [factorial(4)]

第2层调用: factorial(3)
  → 3 * factorial(2)     ← 需要先知道 factorial(2) 的结果
  栈: [factorial(4), factorial(3)]

第3层调用: factorial(2)
  → 2 * factorial(1)     ← 需要先知道 factorial(1) 的结果
  栈: [factorial(4), factorial(3), factorial(2)]

第4层调用: factorial(1)
  → 返回 1               ← 基准情形！不用再调了！
  栈: [factorial(4), factorial(3), factorial(2), factorial(1)]

=== 回归阶段（从栈顶开始，逐层返回结果，弹出盘子）===

factorial(1) 返回 1       → 栈弹出 factorial(1)
factorial(2) 返回 2 * 1 = 2    → 栈弹出 factorial(2)
factorial(3) 返回 3 * 2 = 6    → 栈弹出 factorial(3)
factorial(4) 返回 4 * 6 = 24   → 栈弹出 factorial(4)

最终结果: 24
```

用图来表示调用栈的变化：

```
递推（压栈）:              回归（弹栈）:

| factorial(4) |           |                |
| factorial(3) |           |                |
| factorial(2) |           |                |
| factorial(1) |  ←→      | factorial(4)   |  返回 4×6=24
|________________|         | factorial(3)   |  返回 3×2=6
                           | factorial(2)   |  返回 2×1=2
                           | factorial(1)   |  返回 1
                           |________________|
```

##### 用代码打印调用过程，直观感受：

```python
def factorial_trace(n, depth=0):
    """带调用过程打印的阶乘函数"""
    indent = "  " * depth  # 用缩进表示层级
    
    print(f"{indent}→ factorial({n}) 被调用")
    
    if n <= 1:
        print(f"{indent}← factorial({n}) 返回 1 (基准情形)")
        return 1
    
    result = n * factorial_trace(n - 1, depth + 1)
    print(f"{indent}← factorial({n}) 返回 {n} × {result // n}... 不对，返回 {result}")
    return result

# 运行看看
print("=== 调用过程 ===")
ans = factorial_trace(4)
print(f"\n最终结果: {ans}")
```

输出：
```
=== 调用过程 ===
→ factorial(4) 被调用
  → factorial(3) 被调用
    → factorial(2) 被调用
      → factorial(1) 被调用
      ← factorial(1) 返回 1 (基准情形)
    ← factorial(2) 返回 2 × 1... 不对，返回 2
  ← factorial(3) 返回 3 × 2... 不对，返回 6
← factorial(4) 返回 4 × 6... 不对，返回 24

最终结果: 24
```

---

#### 五、递归 vs 循环

几乎每个递归都能改写成循环（迭代），反之亦然。那到底该用哪个？

##### 用阶乘来对比：

```python
# ===== 递归版本 =====
def factorial_recursive(n):
    if n <= 1:
        return 1
    return n * factorial_recursive(n - 1)

# ===== 循环版本 =====
def factorial_iterative(n):
    result = 1
    for i in range(2, n + 1):
        result *= i
    return result
```

##### 对比表格

| 对比维度 | 递归 | 循环（迭代） |
|---------|------|-------------|
| **代码可读性** | 通常更简洁、更接近数学定义 | 需要手动维护状态变量 |
| **空间开销** | 每层调用都需要栈帧，空间 O(n) | 只用固定几个变量，空间 O(1) |
| **时间开销** | 函数调用有额外开销 | 通常更快 |
| **栈溢出风险** | 递归太深会栈溢出 | 不会溢出 |
| **适用场景** | 问题本身是递归结构的（如树、分治） | 简单的重复操作 |

##### 一句话总结

> 递归胜在**优雅和表达力**，循环胜在**效率和安全**。
> 有些问题用递归写非常自然（如树的遍历），硬用循环写反而很别扭。

---

#### 六、递归过深的问题：栈溢出

##### 什么是栈溢出（StackOverflow）？

还记得刚才说的"调用栈"吗？每调用一次函数，栈就多一层。如果递归太深，栈就会被"撑爆"——这就是栈溢出。

就像叠盘子叠得太高，桌子承受不住就塌了。

##### Python的递归深度限制

Python为了防止栈溢出，默认限制了递归深度（通常是1000层左右）：

```python
import sys

# 查看Python的最大递归深度
print(sys.getrecursionlimit())  # 通常输出: 1000

# 尝试超过这个深度
def infinite_recursion(n):
    print(f"递归第 {n} 层")
    return infinite_recursion(n + 1)

# infinite_recursion(1)
# 运行到大约第1000层时，会报错:
# RecursionError: maximum recursion depth exceeded
```

##### 可以修改限制，但不推荐：

```python
# 虽然可以改大限制，但真的递归太深会导致程序崩溃
sys.setrecursionlimit(10000)  # 改到10000

# 一般不建议这么做，而是应该优化算法，避免过深的递归
```

##### 实际影响

```python
# 计算 fibonacci(1000) 用朴素递归？
# 不只是递归深度的問題，时间复杂度是 O(2^n)
# 宇宙毁灭了都算不完

# 用记忆化递归？
# 递归深度1000，可能触发 RecursionError

# 用循环？
def fibonacci_iterative(n):
    if n <= 2:
        return 1
    a, b = 1, 1
    for _ in range(n - 2):
        a, b = b, a + b
    return b

print(fibonacci_iterative(1000))
# 瞬间出结果，没有任何问题！
```

---

#### 七、尾递归简介

##### 什么是尾递归？

普通的递归在函数调用返回后，还需要**继续做运算**（比如 `n * factorial(n-1)` 返回后还要乘以 n）。

尾递归的特点是：**递归调用是函数的最后一步操作**，返回后不需要再做任何事。

```python
# 普通递归 —— 调用返回后还要乘以 n
def factorial_normal(n):
    if n <= 1:
        return 1
    return n * factorial_normal(n - 1)  # ← 返回后还要做乘法

# 尾递归 —— 递归调用就是最后一步
def factorial_tail(n, accumulator=1):
    if n <= 1:
        return accumulator
    return factorial_tail(n - 1, n * accumulator)  # ← 调用就是最后一步
    # 把"累积的结果"通过参数传递，而不是等返回后再算

# 验证
print(factorial_tail(5))  # 输出: 120
```

##### 尾递归的理论优势

在某些语言（如C、Scheme）中，编译器会优化尾递归——把递归调用变成"跳转"，不增加新的栈帧，这样就不会栈溢出。相当于把递归自动变成了循环。

##### 但Python不支持尾递归优化！

Python的设计者Guido van Rossum明确表示不支持这个优化。所以在Python中，尾递归和普通递归一样，递归太深照样栈溢出。

> 了解尾递归的概念就好，在Python中实际用处不大。

---

#### 八、经典递归问题

##### 8.1 汉诺塔问题（Hanoi Tower）

###### 问题描述

有三根柱子（A、B、C），A柱上从下到上依次叠着 n 个大小不同的圆盘。要求：
1. 每次只能移动一个圆盘
2. 大圆盘不能放在小圆盘上面
3. 把所有圆盘从 A 柱移到 C 柱

###### 递归思路

这是递归的经典中的经典。思路非常优雅：

```
要把 n 个盘子从 A 移到 C：
  第1步：把上面 n-1 个盘子从 A 移到 B（借助 C）    ← 递归！
  第2步：把最大的那个盘子从 A 移到 C               ← 一步搞定
  第3步：把 n-1 个盘子从 B 移到 C（借助 A）        ← 递归！

基准情形：只有 1 个盘子时，直接从起点移到终点
```

###### 图解（3个盘子）

```
初始状态:
A: [大, 中, 小]    B: []    C: []

步骤1: 把上面2个从A移到B（借助C）
  1.1: 小 A→C       A:[大,中]  B:[]     C:[小]
  1.2: 中 A→B       A:[大]    B:[中]    C:[小]
  1.3: 小 C→B       A:[大]    B:[中,小] C:[]

步骤2: 最大的从A移到C
  2.1: 大 A→C       A:[]      B:[中,小] C:[大]

步骤3: 把2个从B移到C（借助A）
  3.1: 小 B→A       A:[小]    B:[中]    C:[大]
  3.2: 中 B→C       A:[小]    B:[]      C:[大,中]
  3.3: 小 A→C       A:[]      B:[]      C:[大,中,小]

完成！共 7 = 2³ - 1 步
```

###### 完整代码

```python
def hanoi(n, source="A", target="C", auxiliary="B"):
    """
    汉诺塔问题
    n: 盘子数量
    source: 起始柱
    target: 目标柱
    auxiliary: 辅助柱
    """
    # 基准情形：只有1个盘子，直接移过去
    if n == 1:
        print(f"移动盘子 1: {source} → {target}")
        return
    
    # 第1步：把上面 n-1 个盘子从 source 移到 auxiliary（借助 target）
    hanoi(n - 1, source, auxiliary, target)
    
    # 第2步：把最大的盘子从 source 移到 target
    print(f"移动盘子 {n}: {source} → {target}")
    
    # 第3步：把 n-1 个盘子从 auxiliary 移到 target（借助 source）
    hanoi(n - 1, auxiliary, target, source)

# 测试
print("=== 3个盘子 ===")
hanoi(3)
# 输出7步移动

print("\n=== 4个盘子 ===")
hanoi(4)
# 输出15步移动
```

###### 复杂度分析

- **移动次数：** 2^n - 1（指数级！）
- **时间复杂度：** O(2^n)
- **空间复杂度：** O(n)，调用栈深度为 n

> 传说印度有一座神庙，僧侣们在移动64个金盘的汉诺塔。当所有盘子移完时，世界就会毁灭。
> 2^64 - 1 ≈ 1.8 × 10^19 步，假设每秒移一步，需要约5849亿年！放心，宇宙才138亿岁。

---

##### 8.2 二分查找的递归实现

```python
def binary_search_recursive(arr, target, left, right):
    """
    二分查找的递归实现
    arr: 有序数组
    target: 要查找的目标值
    left: 搜索范围的左边界
    right: 搜索范围的右边界
    返回: 目标值的索引，找不到返回 -1
    """
    # 基准情形：搜索范围为空，说明没找到
    if left > right:
        return -1
    
    # 计算中间位置
    mid = (left + right) // 2
    
    # 找到了！
    if arr[mid] == target:
        return mid
    # 目标在左半边：中间值太大了，去左边找
    elif arr[mid] > target:
        return binary_search_recursive(arr, target, left, mid - 1)
    # 目标在右半边：中间值太小了，去右边找
    else:
        return binary_search_recursive(arr, target, mid + 1, right)

# 测试
arr = [1, 3, 5, 7, 9, 11, 13, 15]
print(binary_search_recursive(arr, 7, 0, len(arr) - 1))   # 输出: 3
print(binary_search_recursive(arr, 1, 0, len(arr) - 1))   # 输出: 0
print(binary_search_recursive(arr, 15, 0, len(arr) - 1))  # 输出: 7
print(binary_search_recursive(arr, 6, 0, len(arr) - 1))   # 输出: -1
```

---

##### 8.3 幂运算 x^n 的递归实现

###### 朴素版本

```python
def power_naive(x, n):
    """
    计算 x 的 n 次方（n 为非负整数）
    朴素递归：x^n = x × x^(n-1)
    时间复杂度：O(n)
    """
    # 基准情形
    if n == 0:
        return 1
    
    # 递推关系
    return x * power_naive(x, n - 1)

print(power_naive(2, 10))  # 输出: 1024
```

###### 快速幂优化

**核心思想：** 利用指数的性质，每次把问题规模**减半**！

```
x^n = (x^(n/2))^2      当 n 为偶数
x^n = x × (x^(n/2))^2  当 n 为奇数（n/2 向下取整）
```

比如计算 2^10：
```
2^10 = (2^5)^2
2^5  = 2 × (2^2)^2
2^2  = (2^1)^2
2^1  = 2 × (2^0)^2 = 2 × 1 = 2

回代：
2^2  = 2^2 = 4
2^5  = 2 × 4^2 = 2 × 16 = 32
2^10 = 32^2 = 1024
```

只需要4步，而不是10步！

```python
def fast_power(x, n):
    """
    快速幂算法：计算 x 的 n 次方
    时间复杂度：O(log n) —— 每次把 n 减半！
    
    对比：朴素方法算 2^1000 需要1000步
          快速幂算 2^1000 只需要约10步！
    """
    # 处理负指数的情况
    if n < 0:
        return 1 / fast_power(x, -n)
    
    # 基准情形
    if n == 0:
        return 1
    
    # 递归计算 x^(n//2)
    half = fast_power(x, n // 2)
    
    if n % 2 == 0:
        # n 是偶数：x^n = (x^(n/2))^2
        return half * half
    else:
        # n 是奇数：x^n = x × (x^(n/2))^2
        return x * half * half

# 测试
print(fast_power(2, 10))    # 输出: 1024
print(fast_power(2, 0))     # 输出: 1
print(fast_power(3, 5))     # 输出: 243
print(fast_power(2, -3))    # 输出: 0.125
print(fast_power(2, 1000))  # 瞬间出结果！一个超大的数
```

---

#### 九、递归思想的重要性

递归不仅仅是一种编程技巧，更是一种**思维方式**。在后续的数据结构和算法学习中，递归思想无处不在：

| 领域 | 递归的体现 |
|------|-----------|
| **树和图** | 树的定义本身就是递归的（树的子节点还是树），遍历算法天然是递归的 |
| **分治算法** | 归并排序、快速排序——把大问题拆成小问题，分别解决，再合并 |
| **动态规划** | 很多DP问题的状态转移方程就是递推关系 |
| **回溯算法** | 穷举所有可能，本质上是在递归树上做深度优先搜索 |
| **链表** | 链表本身就是递归结构（节点 + 指向下一个节点的引用） |

> **掌握了递归，你就拿到了打开高级算法大门的钥匙。**

---
---


### 主题7 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、写递归函数的模板

```typescript
// ========== 递归函数通用模板 ==========
function recursiveFunction(problemSize: number): number {
  // 1. 基准情形：最简单的情况，直接返回答案
  if (problemSize <= 0) { // 替换为你的基准条件
    return 0; // 替换为你的基础答案
  }

  // 2. 递推关系：把大问题拆成小问题，调用自身
  return recursiveFunction(problemSize - 1); // 替换为更小的问题
}
```

##### 二、基础递归

```typescript
// ========== 1. 计算阶乘 n! ==========
// n! = n × (n-1) × (n-2) × ... × 1，比如 5! = 5 × 4 × 3 × 2 × 1 = 120
// 递推关系：n! = n × (n-1)!    基准情形：1! = 1
function factorial(n: number): number {
  // 基准情形：0! = 1, 1! = 1
  if (n <= 1) return 1;

  // 递推关系：n! = n × (n-1)!
  // 要求 n!，就先求 (n-1)!，然后乘以 n
  return n * factorial(n - 1);
}

// 测试
console.log(factorial(5));  // 输出: 120  (5×4×3×2×1)
console.log(factorial(3));  // 输出: 6    (3×2×1)
console.log(factorial(0));  // 输出: 1    (0! 定义为1)

// ========== 2. 斐波那契数列 ==========
// 数列：1, 1, 2, 3, 5, 8, 13, 21, 34, ...
// 基准情形：第1项=1，第2项=1
// 递推关系：F(n) = F(n-1) + F(n-2)
function fibonacci(n: number): number {
  // 基准情形
  if (n === 1 || n === 2) return 1;

  // 递推关系：第n项 = 第(n-1)项 + 第(n-2)项
  return fibonacci(n - 1) + fibonacci(n - 2);
}

// 测试
for (let i = 1; i <= 10; i++) {
  console.log(`F(${i}) = ${fibonacci(i)}`);
}
// 输出: F(1)=1, F(2)=1, F(3)=2, F(4)=3, F(5)=5, F(6)=8 ...

// ========== 3. 带记忆化的斐波那契（避免重复计算）==========
// 朴素递归的问题：大量重复计算！F(4) 被计算2次，F(3) 被计算3次
// 时间复杂度从 O(2^n) 降到 O(n)
function fibonacciMemo(n: number, memo: Map<number, number> = new Map()): number {
  if (n === 1 || n === 2) return 1;

  // 如果已经算过了，直接返回存过的结果
  if (memo.has(n)) return memo.get(n)!;

  // 算完存起来
  const result = fibonacciMemo(n - 1, memo) + fibonacciMemo(n - 2, memo);
  memo.set(n, result);
  return result;
}

// 现在 fibonacciMemo(100) 也能瞬间算出来！（注意用 number 会有精度问题，这里展示思想）
console.log(fibonacciMemo(50));  // 输出: 12586269025

// ========== 4. 数组求和 ==========
// 基准情形：空数组的和为0
// 递推关系：数组的和 = 第一个元素 + 剩余元素的和
function arraySum(arr: number[]): number {
  // 基准情形：空数组的和是0
  if (arr.length === 0) return 0;

  // 递推关系：第一个元素 + 剩下元素的和
  // [1, 2, 3, 4] -> 1 + arraySum([2, 3, 4])
  //               -> 1 + 2 + 3 + 4 + 0 = 10
  return arr[0] + arraySum(arr.slice(1));
}

// 测试
console.log(arraySum([1, 2, 3, 4, 5]));  // 输出: 15
console.log(arraySum([10]));             // 输出: 10
console.log(arraySum([]));               // 输出: 0

// ========== 5. 计算数组中最大元素 ==========
// 基准情形：只有一个元素的数组，最大值就是它
// 递推关系：整个数组的最大值 = max(第一个元素, 剩余部分的最大值)
function findMax(arr: number[]): number {
  // 基准情形：只有一个元素
  if (arr.length === 1) return arr[0];

  // 递推关系：比较第一个元素和剩余部分的最大值
  const subMax = findMax(arr.slice(1));  // 剩余部分的最大值
  return arr[0] > subMax ? arr[0] : subMax;
}

// 测试
console.log(findMax([3, 1, 4, 1, 5, 9, 2, 6]));  // 输出: 9
console.log(findMax([7, 7, 7]));                 // 输出: 7
console.log(findMax([-1, -5, -3]));              // 输出: -1
```

##### 三、用代码打印调用过程

```typescript
// ========== 带调用过程打印的阶乘函数 ==========
function factorialTrace(n: number, depth = 0): number {
  const indent = "  ".repeat(depth);  // 用缩进表示层级

  console.log(`${indent}→ factorial(${n}) 被调用`);

  if (n <= 1) {
    console.log(`${indent}← factorial(${n}) 返回 1 (基准情形)`);
    return 1;
  }

  const result = n * factorialTrace(n - 1, depth + 1);
  console.log(`${indent}← factorial(${n}) 返回 ${result}`);
  return result;
}

// 运行看看
console.log("=== 调用过程 ===");
const ans = factorialTrace(4);
console.log(`\n最终结果: ${ans}`);
// 输出：
// → factorial(4) 被调用
//   → factorial(3) 被调用
//     → factorial(2) 被调用
//       → factorial(1) 被调用
//       ← factorial(1) 返回 1 (基准情形)
//     ← factorial(2) 返回 2
//   ← factorial(3) 返回 6
// ← factorial(4) 返回 24
// 最终结果: 24
```

##### 四、递归 vs 循环

```typescript
// ===== 递归版本 =====
function factorialRecursive(n: number): number {
  if (n <= 1) return 1;
  return n * factorialRecursive(n - 1);
}

// ===== 循环版本 =====
function factorialIterative(n: number): number {
  let result = 1;
  for (let i = 2; i <= n; i++) {
    result *= i;
  }
  return result;
}

// 对比：
// | 递归 | 循环 |
// | 代码可读性：简洁，接近数学定义 | 需要手动维护状态变量 |
// | 空间开销：O(n) 栈帧 | O(1) |
// | 栈溢出风险：递归太深会溢出 | 不会溢出 |

// ========== 循环版斐波那契 ==========
function fibonacciIterative(n: number): number {
  if (n <= 2) return 1;
  let a = 1, b = 1;
  for (let i = 0; i < n - 2; i++) {
    [a, b] = [b, a + b];
  }
  return b;
}

console.log(fibonacciIterative(1000));
// 瞬间出结果，没有任何问题！
```

##### 五、尾递归

```typescript
// 普通递归 —— 调用返回后还要乘以 n
function factorialNormal(n: number): number {
  if (n <= 1) return 1;
  return n * factorialNormal(n - 1);  // ← 返回后还要做乘法
}

// 尾递归 —— 递归调用就是最后一步
// 把"累积的结果"通过参数传递，而不是等返回后再算
function factorialTail(n: number, accumulator = 1): number {
  if (n <= 1) return accumulator;
  return factorialTail(n - 1, n * accumulator);  // ← 调用就是最后一步
}

// 验证
console.log(factorialTail(5));  // 输出: 120

// 注意：现代 JS/TS 引擎（V8 等）一般也不做尾递归优化，概念了解即可
```

##### 六、经典递归问题

```typescript
// ========== 1. 汉诺塔问题 ==========
function hanoi(n: number, source = "A", target = "C", auxiliary = "B"): void {
  // 基准情形：只有1个盘子，直接移过去
  if (n === 1) {
    console.log(`移动盘子 1: ${source} → ${target}`);
    return;
  }

  // 第1步：把上面 n-1 个盘子从 source 移到 auxiliary（借助 target）
  hanoi(n - 1, source, auxiliary, target);

  // 第2步：把最大的盘子从 source 移到 target
  console.log(`移动盘子 ${n}: ${source} → ${target}`);

  // 第3步：把 n-1 个盘子从 auxiliary 移到 target（借助 source）
  hanoi(n - 1, auxiliary, target, source);
}

// 测试
console.log("=== 3个盘子 ===");
hanoi(3);
// 输出7步移动，共 2³-1 = 7 步

// 复杂度：移动次数 2^n - 1（指数级），空间 O(n)

// ========== 2. 二分查找的递归实现 ==========
function binarySearchRecursive(
  arr: number[],
  target: number,
  left: number,
  right: number
): number {
  // 基准情形：搜索范围为空，说明没找到
  if (left > right) return -1;

  // 计算中间位置
  const mid = Math.floor((left + right) / 2);

  // 找到了！
  if (arr[mid] === target) return mid;
  // 目标在左半边：中间值太大了，去左边找
  else if (arr[mid] > target) return binarySearchRecursive(arr, target, left, mid - 1);
  // 目标在右半边：中间值太小了，去右边找
  else return binarySearchRecursive(arr, target, mid + 1, right);
}

// 测试
const arr = [1, 3, 5, 7, 9, 11, 13, 15];
console.log(binarySearchRecursive(arr, 7, 0, arr.length - 1));   // 输出: 3
console.log(binarySearchRecursive(arr, 1, 0, arr.length - 1));   // 输出: 0
console.log(binarySearchRecursive(arr, 15, 0, arr.length - 1));  // 输出: 7
console.log(binarySearchRecursive(arr, 6, 0, arr.length - 1));   // 输出: -1

// ========== 3. 幂运算 x^n 的递归实现 ==========
// 朴素版本：x^n = x × x^(n-1)，时间复杂度 O(n)
function powerNaive(x: number, n: number): number {
  if (n === 0) return 1;
  return x * powerNaive(x, n - 1);
}

console.log(powerNaive(2, 10));  // 输出: 1024

// ========== 4. 快速幂优化 ==========
// 核心思想：利用指数的性质，每次把问题规模减半！
// x^n = (x^(n/2))^2       当 n 为偶数
// x^n = x × (x^(n/2))^2   当 n 为奇数
// 时间复杂度：O(log n)
function fastPower(x: number, n: number): number {
  // 处理负指数的情况
  if (n < 0) return 1 / fastPower(x, -n);

  // 基准情形
  if (n === 0) return 1;

  // 递归计算 x^(n//2)
  const half = fastPower(x, Math.floor(n / 2));

  if (n % 2 === 0) {
    // n 是偶数：x^n = (x^(n/2))^2
    return half * half;
  } else {
    // n 是奇数：x^n = x × (x^(n/2))^2
    return x * half * half;
  }
}

// 测试
console.log(fastPower(2, 10));    // 输出: 1024
console.log(fastPower(2, 0));     // 输出: 1
console.log(fastPower(3, 5));     // 输出: 243
console.log(fastPower(2, -3));    // 输出: 0.125
```

### 主题7 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、写递归函数的模板

```go
package main

// ========== 递归函数通用模板 ==========
func recursiveFunction(problemSize int) int {
	// 1. 基准情形：最简单的情况，直接返回答案
	if problemSize <= 0 { // 替换为你的基准条件
		return 0 // 替换为你的基础答案
	}

	// 2. 递推关系：把大问题拆成小问题，调用自身
	return recursiveFunction(problemSize - 1)
}
```

##### 二、基础递归

```go
package main

import "fmt"

// ========== 1. 计算阶乘 n! ==========
// n! = n × (n-1) × (n-2) × ... × 1，比如 5! = 5 × 4 × 3 × 2 × 1 = 120
// 递推关系：n! = n × (n-1)!    基准情形：1! = 1
func Factorial(n int) int {
	// 基准情形：0! = 1, 1! = 1
	if n <= 1 {
		return 1
	}

	// 递推关系：n! = n × (n-1)!
	return n * Factorial(n-1)
}

func testFactorial() {
	fmt.Println(Factorial(5)) // 输出: 120  (5×4×3×2×1)
	fmt.Println(Factorial(3)) // 输出: 6    (3×2×1)
	fmt.Println(Factorial(0)) // 输出: 1    (0! 定义为1)
}

// ========== 2. 斐波那契数列 ==========
// 数列：1, 1, 2, 3, 5, 8, 13, 21, 34, ...
// 基准情形：第1项=1，第2项=1
// 递推关系：F(n) = F(n-1) + F(n-2)
func Fibonacci(n int) int {
	// 基准情形
	if n == 1 || n == 2 {
		return 1
	}

	// 递推关系：第n项 = 第(n-1)项 + 第(n-2)项
	return Fibonacci(n-1) + Fibonacci(n-2)
}

func testFibonacci() {
	for i := 1; i <= 10; i++ {
		fmt.Printf("F(%d) = %d\n", i, Fibonacci(i))
	}
	// 输出: F(1)=1, F(2)=1, F(3)=2, F(4)=3, F(5)=5, F(6)=8 ...
}

// ========== 3. 带记忆化的斐波那契（避免重复计算）==========
// 朴素递归的问题：大量重复计算！F(4) 被计算2次，F(3) 被计算3次
// 时间复杂度从 O(2^n) 降到 O(n)
func FibonacciMemo(n int, memo map[int]int) int {
	if n == 1 || n == 2 {
		return 1
	}

	// 如果已经算过了，直接返回存过的结果
	if val, ok := memo[n]; ok {
		return val
	}

	// 算完存起来
	memo[n] = FibonacciMemo(n-1, memo) + FibonacciMemo(n-2, memo)
	return memo[n]
}

func testFibonacciMemo() {
	memo := map[int]int{}
	fmt.Println(FibonacciMemo(100, memo)) // 瞬间出结果！
}

// ========== 4. 数组求和 ==========
// 基准情形：空数组的和为0
// 递推关系：数组的和 = 第一个元素 + 剩余元素的和
func ArraySum(arr []int) int {
	// 基准情形：空数组的和是0
	if len(arr) == 0 {
		return 0
	}

	// 递推关系：第一个元素 + 剩下元素的和
	// [1, 2, 3, 4] -> 1 + ArraySum([2, 3, 4])
	//               -> 1 + 2 + 3 + 4 + 0 = 10
	return arr[0] + ArraySum(arr[1:])
}

func testArraySum() {
	fmt.Println(ArraySum([]int{1, 2, 3, 4, 5})) // 输出: 15
	fmt.Println(ArraySum([]int{10}))            // 输出: 10
	fmt.Println(ArraySum([]int{}))              // 输出: 0
}

// ========== 5. 计算数组中最大元素 ==========
// 基准情形：只有一个元素的数组，最大值就是它
// 递推关系：整个数组的最大值 = max(第一个元素, 剩余部分的最大值)
func FindMax(arr []int) int {
	// 基准情形：只有一个元素
	if len(arr) == 1 {
		return arr[0]
	}

	// 递推关系：比较第一个元素和剩余部分的最大值
	subMax := FindMax(arr[1:]) // 剩余部分的最大值
	if arr[0] > subMax {
		return arr[0]
	}
	return subMax
}

func testFindMax() {
	fmt.Println(FindMax([]int{3, 1, 4, 1, 5, 9, 2, 6})) // 输出: 9
	fmt.Println(FindMax([]int{7, 7, 7}))                // 输出: 7
	fmt.Println(FindMax([]int{-1, -5, -3}))             // 输出: -1
}
```

##### 三、用代码打印调用过程

```go
package main

import (
	"fmt"
	"strings"
)

// ========== 带调用过程打印的阶乘函数 ==========
func FactorialTrace(n, depth int) int {
	indent := strings.Repeat("  ", depth) // 用缩进表示层级

	fmt.Printf("%s→ factorial(%d) 被调用\n", indent, n)

	if n <= 1 {
		fmt.Printf("%s← factorial(%d) 返回 1 (基准情形)\n", indent, n)
		return 1
	}

	result := n * FactorialTrace(n-1, depth+1)
	fmt.Printf("%s← factorial(%d) 返回 %d\n", indent, n, result)
	return result
}

func testFactorialTrace() {
	fmt.Println("=== 调用过程 ===")
	ans := FactorialTrace(4, 0)
	fmt.Printf("\n最终结果: %d\n", ans)
	// 输出：
	// → factorial(4) 被调用
	//   → factorial(3) 被调用
	//     → factorial(2) 被调用
	//       → factorial(1) 被调用
	//       ← factorial(1) 返回 1 (基准情形)
	//     ← factorial(2) 返回 2
	//   ← factorial(3) 返回 6
	// ← factorial(4) 返回 24
	// 最终结果: 24
}
```

##### 四、递归 vs 循环

```go
package main

import "fmt"

// ===== 递归版本 =====
func FactorialRecursive(n int) int {
	if n <= 1 {
		return 1
	}
	return n * FactorialRecursive(n-1)
}

// ===== 循环版本 =====
func FactorialIterative(n int) int {
	result := 1
	for i := 2; i <= n; i++ {
		result *= i
	}
	return result
}

// 对比：
// | 递归 | 循环 |
// | 代码可读性：简洁，接近数学定义 | 需要手动维护状态变量 |
// | 空间开销：O(n) 栈帧 | O(1) |
// | 栈溢出风险：递归太深会溢出 | 不会溢出 |

// ========== 循环版斐波那契 ==========
func FibonacciIterative(n int) int {
	if n <= 2 {
		return 1
	}
	a, b := 1, 1
	for i := 0; i < n-2; i++ {
		a, b = b, a+b
	}
	return b
}

func testFibIterative() {
	fmt.Println(FibonacciIterative(1000))
	// 瞬间出结果，没有任何问题！
}
```

##### 五、尾递归

```go
package main

import "fmt"

// 普通递归 —— 调用返回后还要乘以 n
func FactorialNormal(n int) int {
	if n <= 1 {
		return 1
	}
	return n * FactorialNormal(n-1) // ← 返回后还要做乘法
}

// 尾递归 —— 递归调用就是最后一步
// 把"累积的结果"通过参数传递，而不是等返回后再算
func FactorialTail(n, accumulator int) int {
	if n <= 1 {
		return accumulator
	}
	return FactorialTail(n-1, n*accumulator) // ← 调用就是最后一步
}

func testFactorialTail() {
	fmt.Println(FactorialTail(5, 1)) // 输出: 120
	// 注意：Go 编译器不做尾递归优化（TCO），概念了解即可
}
```

##### 六、经典递归问题

```go
package main

import "fmt"

// ========== 1. 汉诺塔问题 ==========
func Hanoi(n int, source, target, auxiliary string) {
	// 基准情形：只有1个盘子，直接移过去
	if n == 1 {
		fmt.Printf("移动盘子 1: %s → %s\n", source, target)
		return
	}

	// 第1步：把上面 n-1 个盘子从 source 移到 auxiliary（借助 target）
	Hanoi(n-1, source, auxiliary, target)

	// 第2步：把最大的盘子从 source 移到 target
	fmt.Printf("移动盘子 %d: %s → %s\n", n, source, target)

	// 第3步：把 n-1 个盘子从 auxiliary 移到 target（借助 source）
	Hanoi(n-1, auxiliary, target, source)
}

func testHanoi() {
	fmt.Println("=== 3个盘子 ===")
	Hanoi(3, "A", "C", "B")
	// 输出7步移动，共 2³-1 = 7 步
	// 复杂度：移动次数 2^n - 1（指数级），空间 O(n)
}

// ========== 2. 二分查找的递归实现 ==========
func BinarySearchRecursive(arr []int, target, left, right int) int {
	// 基准情形：搜索范围为空，说明没找到
	if left > right {
		return -1
	}

	// 计算中间位置
	mid := (left + right) / 2

	// 找到了！
	if arr[mid] == target {
		return mid
	} else if arr[mid] > target {
		// 目标在左半边：中间值太大了，去左边找
		return BinarySearchRecursive(arr, target, left, mid-1)
	} else {
		// 目标在右半边：中间值太小了，去右边找
		return BinarySearchRecursive(arr, target, mid+1, right)
	}
}

func testBinarySearch() {
	arr := []int{1, 3, 5, 7, 9, 11, 13, 15}
	fmt.Println(BinarySearchRecursive(arr, 7, 0, len(arr)-1))  // 输出: 3
	fmt.Println(BinarySearchRecursive(arr, 1, 0, len(arr)-1))  // 输出: 0
	fmt.Println(BinarySearchRecursive(arr, 15, 0, len(arr)-1)) // 输出: 7
	fmt.Println(BinarySearchRecursive(arr, 6, 0, len(arr)-1))  // 输出: -1
}

// ========== 3. 幂运算 x^n 的递归实现 ==========
// 朴素版本：x^n = x × x^(n-1)，时间复杂度 O(n)
func PowerNaive(x, n int) int {
	if n == 0 {
		return 1
	}
	return x * PowerNaive(x, n-1)
}

func testPowerNaive() {
	fmt.Println(PowerNaive(2, 10)) // 输出: 1024
}

// ========== 4. 快速幂优化 ==========
// 核心思想：利用指数的性质，每次把问题规模减半！
// x^n = (x^(n/2))^2       当 n 为偶数
// x^n = x × (x^(n/2))^2   当 n 为奇数
// 时间复杂度：O(log n)
func FastPower(x float64, n int) float64 {
	// 处理负指数的情况
	if n < 0 {
		return 1 / FastPower(x, -n)
	}

	// 基准情形
	if n == 0 {
		return 1
	}

	// 递归计算 x^(n//2)
	half := FastPower(x, n/2)

	if n%2 == 0 {
		// n 是偶数：x^n = (x^(n/2))^2
		return half * half
	} else {
		// n 是奇数：x^n = x × (x^(n/2))^2
		return x * half * half
	}
}

func testFastPower() {
	fmt.Println(FastPower(2, 10))    // 输出: 1024
	fmt.Println(FastPower(2, 0))     // 输出: 1
	fmt.Println(FastPower(3, 5))     // 输出: 243
	fmt.Println(FastPower(2, -3))    // 输出: 0.125
}
```

---

### 主题8：排序算法


#### 一、排序的意义

##### 为什么要排序？

想象一下：
- 图书馆的书如果不按编号排列，找一本书就像大海捞针
- 手机通讯录如果不按名字排序，每次找联系人都要翻遍所有人
- 你在字典里查单词，如果单词是乱序的，你就不能"翻到中间看看是大了还是小了"

**排序的核心价值：让数据有序，从而让后续操作（尤其是查找）变得高效。**

很多高效的算法（如二分查找）都要求数据是有序的。

##### 排序算法的稳定性

**什么是稳定性？**

如果数组中有两个相等的元素，排序后它们的**相对顺序**不变，就称这个排序算法是**稳定的**。

```
举个例子：按"年龄"排序，年龄相同的两个人 A 和 B
原始顺序：A(25岁), B(25岁)

稳定排序后：A 仍然在 B 前面    ✓
不稳定排序后：B 可能跑到 A 前面  ✗
```

**为什么稳定性重要？**

当你需要按多个维度排序时。比如先按"部门"排序，再按"工资"排序。如果第二次排序是稳定的，那么同工资的人会保持原来的部门顺序。

---

#### 二、简单排序 O(n²)

##### 2.1 冒泡排序（Bubble Sort）

###### 思想

像水中的气泡一样，大的元素一步步"冒泡"到数组末尾。

具体做法：**相邻的两个元素两两比较**，如果前面的比后面的大，就交换它们。每一轮遍历，最大的元素就像气泡一样浮到最后面。

```
生活类比：体育课排队，老师让相邻的两个人比身高，高的往后站。
一轮下来，最高的人就到了最后面。再来一轮，第二高的到了倒数第二。
重复 n-1 轮，队伍就排好了。
```

###### 完整实现

```python
def bubble_sort(arr):
    """
    冒泡排序
    思想：相邻元素两两比较，大的往后交换
    时间复杂度：O(n²)
    空间复杂度：O(1)
    稳定性：稳定（相等时不交换）
    """
    n = len(arr)
    
    # 外层循环：需要 n-1 轮
    for i in range(n - 1):
        
        # 内层循环：每轮比较相邻元素
        # 每完成一轮，最后面就多一个排好序的元素
        # 所以内层循环的范围逐轮缩小：n-1-i
        for j in range(n - 1 - i):
            
            # 如果前面比后面大，就交换
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
        
        # 每轮结束后的状态（用于理解过程）
        print(f"第 {i+1} 轮结束: {arr}")
    
    return arr

# 测试
print("初始数组: [64, 34, 25, 12, 22, 11, 90]")
bubble_sort([64, 34, 25, 12, 22, 11, 90])
```

输出：
```
第 1 轮结束: [34, 25, 12, 22, 11, 64, 90]  ← 90冒泡到最后
第 2 轮结束: [25, 12, 22, 11, 34, 64, 90]  ← 64到位
第 3 轮结束: [12, 22, 11, 25, 34, 64, 90]  ← 34到位
第 4 轮结束: [12, 11, 22, 25, 34, 64, 90]  ← 25到位
第 5 轮结束: [11, 12, 22, 25, 34, 64, 90]  ← 22到位
第 6 轮结束: [11, 12, 22, 25, 34, 64, 90]  ← 全部排好
```

###### 优化版：加 flag 提前终止

```python
def bubble_sort_optimized(arr):
    """
    冒泡排序优化版
    优化思路：如果某一轮没有发生任何交换，说明已经有序了，提前结束！
    
    比如数组 [1, 2, 3, 5, 4]
    第1轮: 1,2,3都不需要交换，5和4交换 → [1,2,3,4,5]，发生了交换
    第2轮: 全都不用交换！说明已经有序，提前结束
    """
    n = len(arr)
    
    for i in range(n - 1):
        swapped = False  # 标记：这一轮有没有交换过
        
        for j in range(n - 1 - i):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
                swapped = True
        
        # 如果这一轮没有任何交换，说明已经有序
        if not swapped:
            print(f"第 {i+1} 轮没有交换，提前结束！")
            break
    
    return arr

# 对近乎有序的数组，优化效果显著
print(bubble_sort_optimized([1, 2, 3, 5, 4]))
# 只需2轮就结束！
```

###### 复杂度分析

| | 最好 | 平均 | 最坏 |
|---|---|---|---|
| **时间** | O(n)（已有序） | O(n²) | O(n²)（逆序） |
| **空间** | O(1) | O(1) | O(1) |

- **稳定性：** 稳定（相等时不交换，相对位置不变）

---

##### 2.2 选择排序（Selection Sort）

###### 思想

每次从**未排序的部分**中选出最小的元素，放到已排序部分的末尾。

```
生活类比：老师要从全班同学中找出最矮的，让他站第一个；
然后从剩下的人中再找最矮的，站第二个；
如此反复，直到所有人都排好。
```

###### 完整实现

```python
def selection_sort(arr):
    """
    选择排序
    思想：每次从未排序部分选出最小值，放到已排序部分的末尾
    时间复杂度：O(n²)
    空间复杂度：O(1)
    稳定性：不稳定（交换可能打乱相等元素的顺序）
    """
    n = len(arr)
    
    # 外层循环：确定要放置最小值的位置 i
    for i in range(n - 1):
        
        # 假设当前位置 i 是最小值的索引
        min_idx = i
        
        # 内层循环：在未排序部分 [i+1, n) 中找真正的最小值
        for j in range(i + 1, n):
            if arr[j] < arr[min_idx]:
                min_idx = j  # 更新最小值的索引
        
        # 把找到的最小值交换到位置 i
        # 注意：只有 min_idx != i 时才需要交换
        if min_idx != i:
            arr[i], arr[min_idx] = arr[min_idx], arr[i]
        
        print(f"第 {i+1} 轮: 最小值 {arr[i]} 放到位置 {i}, 数组: {arr}")
    
    return arr

# 测试
print("初始数组: [64, 25, 12, 22, 11]")
selection_sort([64, 25, 12, 22, 11])
```

###### 复杂度分析

| | 最好 | 平均 | 最坏 |
|---|---|---|---|
| **时间** | O(n²) | O(n²) | O(n²) |
| **空间** | O(1) | O(1) | O(1) |

- 不管什么情况，都要比较那么多次，所以最好、平均、最坏都是 O(n²)
- **稳定性：** 不稳定。例如 `[5, 5, 2]`，第一轮会把第一个5和2交换，两个5的相对顺序就变了。

---

##### 2.3 插入排序（Insertion Sort）

###### 思想

像**整理扑克牌**一样：拿到一张新牌，从右往左找到合适的位置插进去。

```
生活类比：你手里已经有一小叠排好序的牌，
每次从桌上拿一张新牌，
在你手里的牌中从右往左找到合适的位置，插进去。
手里的牌越来越多，直到桌上的牌都拿完。
```

###### 完整实现

```python
def insertion_sort(arr):
    """
    插入排序
    思想：像整理扑克牌，每次把新元素插到已排序部分的正确位置
    时间复杂度：O(n²)
    空间复杂度：O(1)
    稳定性：稳定
    """
    n = len(arr)
    
    # 从第2个元素（索引1）开始
    # 因为第1个元素（索引0）可以看作是"已排序"的（只有1个元素当然有序）
    for i in range(1, n):
        
        # 当前要插入的元素
        key = arr[i]
        
        # j 是已排序部分的最后一个位置
        j = i - 1
        
        # 从右往左找插入位置：
        # 如果已排序部分的元素比 key 大，就往后挪一位，给 key 腾位置
        while j >= 0 and arr[j] > key:
            arr[j + 1] = arr[j]  # 元素后移，腾出空间
            j -= 1
        
        # 找到了正确位置，插入
        arr[j + 1] = key
        
        print(f"插入 {key}: {arr}")
    
    return arr

# 测试
print("初始数组: [31, 41, 59, 26, 41, 58]")
insertion_sort([31, 41, 59, 26, 41, 58])
```

###### 插入排序的优势：近乎有序时极快

```python
# 对于几乎有序的数组，插入排序接近 O(n)！
# 因为内层 while 循环几乎不执行

# 比如：[1, 2, 3, 4, 5, 6, 7, 8, 100, 9]
# 只有最后一个元素需要移动，其他元素只需要比较一次就确认位置
# 时间复杂度接近 O(n)

# 这也是为什么插入排序常被用作"小数组"或"近乎有序数组"的排序方案
# 甚至 Python 的 Timsort 在小数组时也使用插入排序
```

###### 复杂度分析

| | 最好 | 平均 | 最坏 |
|---|---|---|---|
| **时间** | O(n)（已有序） | O(n²) | O(n²)（逆序） |
| **空间** | O(1) | O(1) | O(1) |

- **稳定性：** 稳定（相等时不移动，保持原顺序）

---

#### 三、高效排序 O(n log n)

##### 3.1 归并排序（Merge Sort）

###### 分治思想入门

**分治（Divide and Conquer）** 三步走：
1. **分（Divide）：** 把问题拆成两个规模更小的子问题
2. **治（Conquer）：** 递归地解决子问题
3. **合（Combine）：** 把子问题的答案合并成原问题的答案

归并排序就是分治的经典应用：
1. **分：** 把数组从中间一分为二
2. **治：** 分别对两半排序
3. **合：** 把两个有序的部分合并成一个有序的整体

###### 辅助函数：合并两个有序数组

```python
def merge(left, right):
    """
    合并两个有序数组，返回一个新的有序数组
    
    类比：两列排队的人，都按身高从矮到高排列，
    现在要把他们合成一列，仍然保持从矮到高。
    方法：每次比较两列最前面的人，矮的先出列。
    """
    result = []
    i = 0  # left 的指针
    j = 0  # right 的指针
    
    # 两列都有人时，比较最前面的
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:  # 注意用 <= 保证稳定性
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    
    # 把剩余的元素追加到结果中
    # （只有一个列表会有剩余，另一个已经取完了）
    result.extend(left[i:])
    result.extend(right[j:])
    
    return result

# 测试合并
print(merge([1, 3, 5, 7], [2, 4, 6, 8]))
# 输出: [1, 2, 3, 4, 5, 6, 7, 8]
```

###### 归并排序完整实现

```python
def merge_sort(arr):
    """
    归并排序
    思想：分治——先拆分，再合并
    时间复杂度：O(n log n)
    空间复杂度：O(n)
    稳定性：稳定
    """
    # 基准情形：长度为0或1的数组天然有序
    if len(arr) <= 1:
        return arr
    
    # 分：从中间一分为二
    mid = len(arr) // 2
    left = arr[:mid]
    right = arr[mid:]
    
    # 治：递归地对两半排序
    left_sorted = merge_sort(left)
    right_sorted = merge_sort(right)
    
    # 合：合并两个有序数组
    return merge(left_sorted, right_sorted)


def merge(left, right):
    """合并两个有序数组"""
    result = []
    i = j = 0
    
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    
    # 追加剩余元素
    while i < len(left):
        result.append(left[i])
        i += 1
    while j < len(right):
        result.append(right[j])
        j += 1
    
    return result


# 测试
arr = [38, 27, 43, 3, 9, 82, 10]
sorted_arr = merge_sort(arr)
print(f"排序结果: {sorted_arr}")
# 输出: [3, 9, 10, 27, 38, 43, 82]
```

###### 归并排序的执行过程图解

```
原始数组: [38, 27, 43, 3, 9, 82, 10]

                    [38, 27, 43, 3, 9, 82, 10]
                   /                            \
          [38, 27, 43]                    [3, 9, 82, 10]
          /         \                     /            \
     [38]      [27, 43]            [3, 9]         [82, 10]
                /     \             /   \           /    \
             [27]   [43]         [3]   [9]       [82]   [10]
                \     /             \   /           \    /
             [27, 43]              [3, 9]         [10, 82]
                \     /               \              /
          [27, 38, 43]              [3, 9, 10, 82]
                   \                  /
                    \                /
              [3, 9, 10, 27, 38, 43, 82]
```

###### 复杂度分析

- **时间复杂度：** O(n log n)
  - 拆分：每次对半拆，拆 log n 次（和二分查找一样）
  - 合并：每一层合并都需要遍历所有 n 个元素
  - 总计：n × log n = O(n log n)
  - 最好、平均、最坏都是 O(n log n)，非常稳定！
- **空间复杂度：** O(n)，合并时需要额外的数组
- **稳定性：** 稳定（合并时相等元素优先取左边的）

---

##### 3.2 快速排序（Quick Sort）

###### 核心概念

快速排序也用了分治思想，但策略不同：
1. **选基准（Pivot）：** 从数组中选一个元素作为基准
2. **分区（Partition）：** 把数组分成两部分——比基准小的放左边，比基准大的放右边
3. **递归：** 对左右两部分分别排序

```
生活类比：老师要按身高排队。
老师说："以我身高为基准，比我矮的站左边，比我高的站右边。"
然后左边和右边各自再选一个人当基准，重复同样的过程。
最后整个队伍就排好了。
```

###### Partition 函数详细图解

以最左边元素为基准，使用双指针法：

```
初始数组: [6, 8, 3, 2, 7, 1, 5]
基准 pivot = 6

目标：把比6小的放左边，比6大的放右边

使用 Lomuto 分区方案（以最后一个元素为基准，更直观）：

数组: [6, 8, 3, 2, 7, 1, 5]
pivot = 5（最后一个元素）

i 指向"小于等于pivot的区域"的右边界，初始为 -1

j=0: arr[0]=6 > 5, 不动
j=1: arr[1]=8 > 5, 不动
j=2: arr[2]=3 ≤ 5, i++, 交换 arr[i] 和 arr[j]
     数组: [6, 8, 3, 2, 7, 1, 5] → [3, 8, 6, 2, 7, 1, 5]
j=3: arr[3]=2 ≤ 5, i++, 交换
     数组: [3, 8, 6, 2, 7, 1, 5] → [3, 2, 6, 8, 7, 1, 5]
j=4: arr[4]=7 > 5, 不动
j=5: arr[5]=1 ≤ 5, i++, 交换
     数组: [3, 2, 6, 8, 7, 1, 5] → [3, 2, 1, 8, 7, 6, 5]
j=6: 循环结束（不含最后一个）

最后把 pivot 放到正确位置：交换 arr[i+1] 和 arr[最后一个]
     数组: [3, 2, 1, 8, 7, 6, 5] → [3, 2, 1, 5, 7, 6, 8]
                                      ↑ pivot在位置3

结果：左边 [3,2,1] 都 ≤ 5，右边 [7,6,8] 都 > 5
```

###### 完整实现

```python
def quick_sort(arr, low, high):
    """
    快速排序
    思想：选基准，分区，递归
    平均时间复杂度：O(n log n)
    最坏时间复杂度：O(n²)
    空间复杂度：O(log n)（递归栈）
    稳定性：不稳定
    """
    if low < high:
        # pi 是基准元素排好后的正确位置
        pi = partition(arr, low, high)
        
        # 递归排序基准左边和右边的部分
        quick_sort(arr, low, pi - 1)
        quick_sort(arr, pi + 1, high)
    
    return arr


def partition(arr, low, high):
    """
    分区函数：选最后一个元素为基准，
    把比基准小的放左边，比基准大的放右边
    返回基准元素的最终位置
    """
    pivot = arr[high]  # 选最后一个元素作为基准
    i = low - 1         # i 指向"小于等于基准的区域"的右边界
    
    for j in range(low, high):
        # 如果当前元素小于等于基准
        if arr[j] <= pivot:
            i += 1  # 扩展"小于等于区域"
            arr[i], arr[j] = arr[j], arr[i]  # 交换到正确位置
    
    # 把基准元素放到中间（i+1的位置）
    arr[i + 1], arr[high] = arr[high], arr[i + 1]
    
    return i + 1  # 返回基准的位置


# 测试
arr = [10, 7, 8, 9, 1, 5]
quick_sort(arr, 0, len(arr) - 1)
print(f"排序结果: {arr}")
# 输出: [1, 5, 7, 8, 9, 10]
```

###### 随机化 Pivot 优化

```python
import random

def quick_sort_random(arr, low, high):
    """
    随机化快速排序
    优化：随机选择基准，避免最坏情况
    """
    if low < high:
        # 随机选一个元素和最后一个交换，然后以最后一个为基准
        random_idx = random.randint(low, high)
        arr[random_idx], arr[high] = arr[high], arr[random_idx]
        
        pi = partition(arr, low, high)
        quick_sort_random(arr, low, pi - 1)
        quick_sort_random(arr, pi + 1, high)
    
    return arr
```

###### 复杂度分析

| | 最好/平均 | 最坏 |
|---|---|---|
| **时间** | O(n log n) | O(n²)（已有序且选最左/右为基准） |
| **空间** | O(log n) | O(n) |

- **最坏情况** 发生在数组已经有序、且总是选到最大或最小元素做基准时。随机化 pivot 可以极大降低这种风险。
- **稳定性：** 不稳定（分区时的交换可能打乱相等元素的顺序）

---

##### 3.3 排序算法对比总结

| 排序算法 | 平均时间 | 最坏时间 | 最好时间 | 空间 | 稳定性 |
|---------|---------|---------|---------|------|-------|
| 冒泡排序 | O(n²) | O(n²) | O(n) | O(1) | 稳定 |
| 选择排序 | O(n²) | O(n²) | O(n²) | O(1) | 不稳定 |
| 插入排序 | O(n²) | O(n²) | O(n) | O(1) | 稳定 |
| 归并排序 | O(n log n) | O(n log n) | O(n log n) | O(n) | 稳定 |
| 快速排序 | O(n log n) | O(n²) | O(n log n) | O(log n) | 不稳定 |
| 堆排序 | O(n log n) | O(n log n) | O(n log n) | O(1) | 不稳定 |

---

#### 四、其他排序

##### 4.1 堆排序（Heap Sort）

```python
def heapify(arr, n, i):
    """
    维护最大堆性质
    n: 堆的大小
    i: 当前要调整的节点索引
    """
    largest = i        # 假设当前节点最大
    left = 2 * i + 1   # 左子节点
    right = 2 * i + 2  # 右子节点
    
    # 如果左子节点比当前节点大
    if left < n and arr[left] > arr[largest]:
        largest = left
    
    # 如果右子节点比当前最大的还大
    if right < n and arr[right] > arr[largest]:
        largest = right
    
    # 如果最大不是当前节点，交换并继续调整
    if largest != i:
        arr[i], arr[largest] = arr[largest], arr[i]
        heapify(arr, n, largest)  # 递归调整被影响的子树


def heap_sort(arr):
    """
    堆排序
    思想：利用最大堆的性质——堆顶永远是最大值
    1. 先建堆
    2. 每次把堆顶（最大值）和末尾交换，然后重新调整堆
    时间复杂度：O(n log n)
    空间复杂度：O(1)
    稳定性：不稳定
    """
    n = len(arr)
    
    # 第1步：建最大堆（从最后一个非叶节点开始调整）
    for i in range(n // 2 - 1, -1, -1):
        heapify(arr, n, i)
    
    # 第2步：逐个取出最大值（堆顶）放到末尾
    for i in range(n - 1, 0, -1):
        arr[0], arr[i] = arr[i], arr[0]  # 堆顶和末尾交换
        heapify(arr, i, 0)               # 对缩小后的堆重新调整
    
    return arr

# 测试
arr = [12, 11, 13, 5, 6, 7]
print(f"堆排序结果: {heap_sort(arr)}")
# 输出: [5, 6, 7, 11, 12, 13]
```

##### 4.2 计数排序（Counting Sort）

```python
def counting_sort(arr):
    """
    计数排序 —— 非比较排序！
    
    思想：不用比较，而是"数数"
    就像老师统计全班考试分数：
    不用两两比较，而是统计每个分数有几个人
    
    适用条件：元素是非负整数，且范围不大
    时间复杂度：O(n + k)，k 是数据范围
    空间复杂度：O(n + k)
    稳定性：稳定
    """
    if not arr:
        return arr
    
    # 找到最大值和最小值
    max_val = max(arr)
    min_val = min(arr)
    range_val = max_val - min_val + 1  # 数据范围
    
    # 创建计数数组
    count = [0] * range_val
    
    # 统计每个元素出现的次数
    for num in arr:
        count[num - min_val] += 1
    
    # 累加计数（确定每个元素在结果中的位置）
    for i in range(1, len(count)):
        count[i] += count[i - 1]
    
    # 从后往前遍历原数组，保证稳定性
    result = [0] * len(arr)
    for i in range(len(arr) - 1, -1, -1):
        idx = arr[i] - min_val
        result[count[idx] - 1] = arr[i]
        count[idx] -= 1
    
    return result

# 测试
arr = [4, 2, 2, 8, 3, 3, 1]
print(f"计数排序结果: {counting_sort(arr)}")
# 输出: [1, 2, 2, 3, 3, 4, 8]
```

##### 4.3 Python 内置排序：Timsort

```python
# Python 的 sorted() 和 list.sort() 使用的是 Timsort 算法
# Timsort 是归并排序和插入排序的混合体：
# - 把数组分成多个"自然有序"的小段（run）
# - 对小段使用插入排序
# - 用归并排序的方式合并这些小段

# 时间复杂度：O(n log n)（最坏情况也是！）
# 空间复杂度：O(n)
# 稳定性：稳定

# 使用方式
arr = [5, 2, 8, 1, 9, 3]

# 方式1：sorted() 返回新列表
new_arr = sorted(arr)
print(new_arr)  # [1, 2, 3, 5, 8, 9]

# 方式2：list.sort() 原地排序
arr.sort()
print(arr)  # [1, 2, 3, 5, 8, 9]

# 降序排列
print(sorted(arr, reverse=True))  # [9, 8, 5, 3, 2, 1]

# 自定义排序：按绝对值排序
arr2 = [-5, 2, -8, 1, -9, 3]
print(sorted(arr2, key=abs))  # [1, 2, 3, -5, -8, -9]
```

---

#### 五、经典例题

##### 例题1：排序数组（LeetCode 912）

```python
# 给你一个整数数组 nums，请你将该数组升序排列。

# 解法1：直接用归并排序
class Solution:
    def sortArray(self, nums):
        if len(nums) <= 1:
            return nums
        
        mid = len(nums) // 2
        left = self.sortArray(nums[:mid])
        right = self.sortArray(nums[mid:])
        
        return self.merge(left, right)
    
    def merge(self, left, right):
        result = []
        i = j = 0
        while i < len(left) and j < len(right):
            if left[i] <= right[j]:
                result.append(left[i])
                i += 1
            else:
                result.append(right[j])
                j += 1
        result.extend(left[i:])
        result.extend(right[j:])
        return result

# 解法2：随机化快速排序
import random

class Solution:
    def sortArray(self, nums):
        self.quick_sort(nums, 0, len(nums) - 1)
        return nums
    
    def quick_sort(self, nums, low, high):
        if low >= high:
            return
        
        # 随机选基准
        pivot_idx = random.randint(low, high)
        nums[pivot_idx], nums[high] = nums[high], nums[pivot_idx]
        
        # 分区
        pi = self.partition(nums, low, high)
        
        self.quick_sort(nums, low, pi - 1)
        self.quick_sort(nums, pi + 1, high)
    
    def partition(self, nums, low, high):
        pivot = nums[high]
        i = low - 1
        for j in range(low, high):
            if nums[j] <= pivot:
                i += 1
                nums[i], nums[j] = nums[j], nums[i]
        nums[i + 1], nums[high] = nums[high], nums[i + 1]
        return i + 1
```

##### 例题2：合并区间（LeetCode 56）

```python
# 以数组 intervals 表示若干个区间的集合，
# 其中单个区间为 intervals[i] = [starti, endi] 。
# 请你合并所有重叠的区间，并返回一个不重叠的区间数组。

# 输入：intervals = [[1,3],[2,6],[8,10],[15,18]]
# 输出：[[1,6],[8,10],[15,18]]
# 解释：区间 [1,3] 和 [2,6] 重叠，合并为 [1,6]

class Solution:
    def merge(self, intervals):
        if not intervals:
            return []
        
        # 关键第一步：按区间起始位置排序！
        intervals.sort(key=lambda x: x[0])
        
        result = [intervals[0]]
        
        for i in range(1, len(intervals)):
            current = intervals[i]
            last = result[-1]
            
            # 如果当前区间的起始 <= 上一个区间的结束，说明有重叠
            if current[0] <= last[1]:
                # 合并：更新结束位置为两者的较大值
                last[1] = max(last[1], current[1])
            else:
                # 没有重叠，直接加入结果
                result.append(current)
        
        return result

# 测试
sol = Solution()
print(sol.merge([[1, 3], [2, 6], [8, 10], [15, 18]]))
# 输出: [[1, 6], [8, 10], [15, 18]]

print(sol.merge([[1, 4], [4, 5]]))
# 输出: [[1, 5]]  （[1,4]和[4,5]也算重叠）
```

##### 例题3：数组中的第K个最大元素（LeetCode 215）

```python
# 给定整数数组 nums 和整数 k，请返回数组中第 k 个最大的元素。
# 输入: nums = [3,2,1,5,6,4], k = 2
# 输出: 5

# 解法1：排序后直接取（简单粗暴）
class Solution:
    def findKthLargest(self, nums, k):
        nums.sort()
        return nums[-k]  # 倒数第k个

# 解法2：快速选择（QuickSelect）—— 利用 partition 的思想
# 不需要完全排序，只需要找到第k大的元素所在的位置
import random

class Solution:
    def findKthLargest(self, nums, k):
        """
        快速选择算法
        核心思想：partition 之后，基准左边的都比它小，右边的都比它大
        所以如果基准正好在第 n-k 个位置，那就是答案！
        平均时间复杂度：O(n)，比排序的 O(n log n) 更快
        """
        return self.quick_select(nums, 0, len(nums) - 1, len(nums) - k)
    
    def quick_select(self, nums, low, high, k):
        if low == high:
            return nums[low]
        
        # 随机选基准
        pivot_idx = random.randint(low, high)
        nums[pivot_idx], nums[high] = nums[high], nums[pivot_idx]
        
        # 分区
        pivot_pos = self.partition(nums, low, high)
        
        if pivot_pos == k:
            return nums[k]       # 找到了！
        elif pivot_pos < k:
            return self.quick_select(nums, pivot_pos + 1, high, k)
        else:
            return self.quick_select(nums, low, pivot_pos - 1, k)
    
    def partition(self, nums, low, high):
        pivot = nums[high]
        i = low - 1
        for j in range(low, high):
            if nums[j] <= pivot:
                i += 1
                nums[i], nums[j] = nums[j], nums[i]
        nums[i + 1], nums[high] = nums[high], nums[i + 1]
        return i + 1

# 测试
sol = Solution()
print(sol.findKthLargest([3, 2, 1, 5, 6, 4], 2))  # 输出: 5
print(sol.findKthLargest([3, 2, 3, 1, 2, 4, 5, 5, 6], 4))  # 输出: 4
```

---
---


### 主题8 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、简单排序 O(n²)

```typescript
// ========== 1. 冒泡排序（Bubble Sort）==========
// 思想：相邻元素两两比较，大的往后交换
// 时间复杂度：O(n²)   空间复杂度：O(1)   稳定性：稳定
function bubbleSort(arr: number[]): number[] {
  const n = arr.length;

  // 外层循环：需要 n-1 轮
  for (let i = 0; i < n - 1; i++) {
    // 内层循环：每轮比较相邻元素
    // 每完成一轮，最后面就多一个排好序的元素
    // 所以内层循环的范围逐轮缩小：n-1-i
    for (let j = 0; j < n - 1 - i; j++) {
      // 如果前面比后面大，就交换
      if (arr[j] > arr[j + 1]) {
        [arr[j], arr[j + 1]] = [arr[j + 1], arr[j]];
      }
    }
    // 每轮结束后的状态（用于理解过程）
    console.log(`第 ${i + 1} 轮结束: ${arr}`);
  }
  return arr;
}

// 测试
console.log("初始数组: [64, 34, 25, 12, 22, 11, 90]");
bubbleSort([64, 34, 25, 12, 22, 11, 90]);

// ========== 冒泡排序优化版：加 flag 提前终止 ==========
// 优化思路：如果某一轮没有发生任何交换，说明已经有序了，提前结束！
function bubbleSortOptimized(arr: number[]): number[] {
  const n = arr.length;

  for (let i = 0; i < n - 1; i++) {
    let swapped = false;  // 标记：这一轮有没有交换过

    for (let j = 0; j < n - 1 - i; j++) {
      if (arr[j] > arr[j + 1]) {
        [arr[j], arr[j + 1]] = [arr[j + 1], arr[j]];
        swapped = true;
      }
    }

    // 如果这一轮没有任何交换，说明已经有序
    if (!swapped) {
      console.log(`第 ${i + 1} 轮没有交换，提前结束！`);
      break;
    }
  }
  return arr;
}

// 对近乎有序的数组，优化效果显著
console.log(bubbleSortOptimized([1, 2, 3, 5, 4]));
// 只需2轮就结束！

// ========== 2. 选择排序（Selection Sort）==========
// 思想：每次从未排序部分选出最小值，放到已排序部分的末尾
// 时间复杂度：O(n²)   空间复杂度：O(1)   稳定性：不稳定
function selectionSort(arr: number[]): number[] {
  const n = arr.length;

  // 外层循环：确定要放置最小值的位置 i
  for (let i = 0; i < n - 1; i++) {
    // 假设当前位置 i 是最小值的索引
    let minIdx = i;

    // 内层循环：在未排序部分 [i+1, n) 中找真正的最小值
    for (let j = i + 1; j < n; j++) {
      if (arr[j] < arr[minIdx]) {
        minIdx = j;  // 更新最小值的索引
      }
    }

    // 把找到的最小值交换到位置 i
    if (minIdx !== i) {
      [arr[i], arr[minIdx]] = [arr[minIdx], arr[i]];
    }

    console.log(`第 ${i + 1} 轮: 最小值 ${arr[i]} 放到位置 ${i}, 数组: ${arr}`);
  }
  return arr;
}

// 测试
console.log("初始数组: [64, 25, 12, 22, 11]");
selectionSort([64, 25, 12, 22, 11]);

// ========== 3. 插入排序（Insertion Sort）==========
// 思想：像整理扑克牌，每次把新元素插到已排序部分的正确位置
// 时间复杂度：O(n²)   空间复杂度：O(1)   稳定性：稳定
function insertionSort(arr: number[]): number[] {
  const n = arr.length;

  // 从第2个元素（索引1）开始
  // 因为第1个元素（索引0）可以看作是"已排序"的
  for (let i = 1; i < n; i++) {
    // 当前要插入的元素
    const key = arr[i];

    // j 是已排序部分的最后一个位置
    let j = i - 1;

    // 从右往左找插入位置：
    // 如果已排序部分的元素比 key 大，就往后挪一位，给 key 腾位置
    while (j >= 0 && arr[j] > key) {
      arr[j + 1] = arr[j];  // 元素后移，腾出空间
      j--;
    }

    // 找到了正确位置，插入
    arr[j + 1] = key;

    console.log(`插入 ${key}: ${arr}`);
  }
  return arr;
}

// 测试
console.log("初始数组: [31, 41, 59, 26, 41, 58]");
insertionSort([31, 41, 59, 26, 41, 58]);

// 对于几乎有序的数组，插入排序接近 O(n)！
// 因为内层 while 循环几乎不执行
```

##### 二、高效排序 O(n log n)

```typescript
// ========== 1. 归并排序（Merge Sort）==========
// 分治三步走：分（拆成两个子问题）→ 治（递归解决）→ 合（合并答案）
// 时间复杂度：O(n log n)   空间复杂度：O(n)   稳定性：稳定

// 辅助函数：合并两个有序数组
// 类比：两列排队的人，每次比较两列最前面的人，矮的先出列
function merge(left: number[], right: number[]): number[] {
  const result: number[] = [];
  let i = 0;  // left 的指针
  let j = 0;  // right 的指针

  // 两列都有人时，比较最前面的
  while (i < left.length && j < right.length) {
    if (left[i] <= right[j]) {  // 注意用 <= 保证稳定性
      result.push(left[i]);
      i++;
    } else {
      result.push(right[j]);
      j++;
    }
  }

  // 把剩余的元素追加到结果中
  // （只有一个列表会有剩余，另一个已经取完了）
  while (i < left.length) {
    result.push(left[i]);
    i++;
  }
  while (j < right.length) {
    result.push(right[j]);
    j++;
  }

  return result;
}

// 测试合并
console.log(merge([1, 3, 5, 7], [2, 4, 6, 8]));
// 输出: [1, 2, 3, 4, 5, 6, 7, 8]

// 归并排序完整实现
function mergeSort(arr: number[]): number[] {
  // 基准情形：长度为0或1的数组天然有序
  if (arr.length <= 1) return arr;

  // 分：从中间一分为二
  const mid = Math.floor(arr.length / 2);
  const left = arr.slice(0, mid);
  const right = arr.slice(mid);

  // 治：递归地对两半排序
  const leftSorted = mergeSort(left);
  const rightSorted = mergeSort(right);

  // 合：合并两个有序数组
  return merge(leftSorted, rightSorted);
}

// 测试
const mergeArr = [38, 27, 43, 3, 9, 82, 10];
console.log(`排序结果: ${mergeSort(mergeArr)}`);
// 输出: [3, 9, 10, 27, 38, 43, 82]

// ========== 2. 快速排序（Quick Sort）==========
// 思想：选基准，分区，递归
// 平均时间复杂度：O(n log n)   最坏：O(n²)   空间：O(log n)   不稳定

// 分区函数：选最后一个元素为基准，
// 把比基准小的放左边，比基准大的放右边
// 返回基准元素的最终位置
function partition(arr: number[], low: number, high: number): number {
  const pivot = arr[high];  // 选最后一个元素作为基准
  let i = low - 1;          // i 指向"小于等于基准的区域"的右边界

  for (let j = low; j < high; j++) {
    // 如果当前元素小于等于基准
    if (arr[j] <= pivot) {
      i++;  // 扩展"小于等于区域"
      [arr[i], arr[j]] = [arr[j], arr[i]];  // 交换到正确位置
    }
  }

  // 把基准元素放到中间（i+1的位置）
  [arr[i + 1], arr[high]] = [arr[high], arr[i + 1]];

  return i + 1;  // 返回基准的位置
}

function quickSort(arr: number[], low: number, high: number): number[] {
  if (low < high) {
    // pi 是基准元素排好后的正确位置
    const pi = partition(arr, low, high);

    // 递归排序基准左边和右边的部分
    quickSort(arr, low, pi - 1);
    quickSort(arr, pi + 1, high);
  }
  return arr;
}

// 测试
const quickArr = [10, 7, 8, 9, 1, 5];
quickSort(quickArr, 0, quickArr.length - 1);
console.log(`排序结果: ${quickArr}`);
// 输出: [1, 5, 7, 8, 9, 10]

// ========== 随机化快速排序 ==========
// 优化：随机选择基准，避免最坏情况（已有序数组）
function quickSortRandom(arr: number[], low: number, high: number): number[] {
  if (low < high) {
    // 随机选一个元素和最后一个交换，然后以最后一个为基准
    const randomIdx = low + Math.floor(Math.random() * (high - low + 1));
    [arr[randomIdx], arr[high]] = [arr[high], arr[randomIdx]];

    const pi = partition(arr, low, high);
    quickSortRandom(arr, low, pi - 1);
    quickSortRandom(arr, pi + 1, high);
  }
  return arr;
}
```

##### 三、其他排序

```typescript
// ========== 1. 堆排序（Heap Sort）==========
// 思想：利用最大堆的性质——堆顶永远是最大值
// 1. 先建堆   2. 每次把堆顶（最大值）和末尾交换，然后重新调整堆
// 时间复杂度：O(n log n)   空间复杂度：O(1)   稳定性：不稳定

// 维护最大堆性质
function heapify(arr: number[], n: number, i: number): void {
  let largest = i;         // 假设当前节点最大
  const left = 2 * i + 1;  // 左子节点
  const right = 2 * i + 2; // 右子节点

  // 如果左子节点比当前节点大
  if (left < n && arr[left] > arr[largest]) largest = left;

  // 如果右子节点比当前最大的还大
  if (right < n && arr[right] > arr[largest]) largest = right;

  // 如果最大不是当前节点，交换并继续调整
  if (largest !== i) {
    [arr[i], arr[largest]] = [arr[largest], arr[i]];
    heapify(arr, n, largest);  // 递归调整被影响的子树
  }
}

function heapSort(arr: number[]): number[] {
  const n = arr.length;

  // 第1步：建最大堆（从最后一个非叶节点开始调整）
  for (let i = Math.floor(n / 2) - 1; i >= 0; i--) {
    heapify(arr, n, i);
  }

  // 第2步：逐个取出最大值（堆顶）放到末尾
  for (let i = n - 1; i > 0; i--) {
    [arr[0], arr[i]] = [arr[i], arr[0]];  // 堆顶和末尾交换
    heapify(arr, i, 0);                   // 对缩小后的堆重新调整
  }

  return arr;
}

// 测试
console.log(`堆排序结果: ${heapSort([12, 11, 13, 5, 6, 7])}`);
// 输出: [5, 6, 7, 11, 12, 13]

// ========== 2. 计数排序（Counting Sort）==========
// 非比较排序！思想：不用比较，而是"数数"
// 适用条件：元素是非负整数，且范围不大
// 时间复杂度：O(n + k)，k 是数据范围   空间复杂度：O(n + k)   稳定
function countingSort(arr: number[]): number[] {
  if (arr.length === 0) return arr;

  // 找到最大值和最小值
  const maxVal = Math.max(...arr);
  const minVal = Math.min(...arr);
  const range = maxVal - minVal + 1;  // 数据范围

  // 创建计数数组
  const count = new Array<number>(range).fill(0);

  // 统计每个元素出现的次数
  for (const num of arr) {
    count[num - minVal]++;
  }

  // 累加计数（确定每个元素在结果中的位置）
  for (let i = 1; i < count.length; i++) {
    count[i] += count[i - 1];
  }

  // 从后往前遍历原数组，保证稳定性
  const result = new Array<number>(arr.length).fill(0);
  for (let i = arr.length - 1; i >= 0; i--) {
    const idx = arr[i] - minVal;
    result[count[idx] - 1] = arr[i];
    count[idx]--;
  }

  return result;
}

// 测试
console.log(`计数排序结果: ${countingSort([4, 2, 2, 8, 3, 3, 1])}`);
// 输出: [1, 2, 2, 3, 3, 4, 8]

// ========== 3. JS/TS 内置排序 ==========
// JS/TS 的 Array.prototype.sort() 在 V8 中：
// - 小数组用插入排序
// - 大数组用快速排序（旧版）/ Timsort（现代 V8）
// 注意：默认按字符串（字典序）排序！所以要传比较函数

const sortArr = [5, 2, 8, 1, 9, 3];
const sortedArr = [...sortArr].sort((a, b) => a - b);  // 升序
console.log(sortedArr);  // [1, 2, 3, 5, 8, 9]

// 降序排列
console.log([...sortArr].sort((a, b) => b - a));  // [9, 8, 5, 3, 2, 1]

// 自定义排序：按绝对值排序
const arr2 = [-5, 2, -8, 1, -9, 3];
console.log([...arr2].sort((a, b) => Math.abs(a) - Math.abs(b)));  // [1, 2, 3, -5, -8, -9]
```

##### 四、经典例题

```typescript
// ========== 例题1：排序数组（LeetCode 912）==========
// 解法1：直接用归并排序
function sortArray(nums: number[]): number[] {
  if (nums.length <= 1) return nums;

  const mid = Math.floor(nums.length / 2);
  const left = sortArray(nums.slice(0, mid));
  const right = sortArray(nums.slice(mid));

  return merge(left, right);
}

// ========== 例题2：合并区间（LeetCode 56）==========
// 输入：intervals = [[1,3],[2,6],[8,10],[15,18]]
// 输出：[[1,6],[8,10],[15,18]]
function mergeIntervals(intervals: number[][]): number[][] {
  if (intervals.length === 0) return [];

  // 关键第一步：按区间起始位置排序！
  intervals.sort((a, b) => a[0] - b[0]);

  const result: number[][] = [intervals[0]];

  for (let i = 1; i < intervals.length; i++) {
    const current = intervals[i];
    const last = result[result.length - 1];

    // 如果当前区间的起始 <= 上一个区间的结束，说明有重叠
    if (current[0] <= last[1]) {
      // 合并：更新结束位置为两者的较大值
      last[1] = Math.max(last[1], current[1]);
    } else {
      // 没有重叠，直接加入结果
      result.push(current);
    }
  }

  return result;
}

// 测试
console.log(JSON.stringify(mergeIntervals([[1, 3], [2, 6], [8, 10], [15, 18]])));
// 输出: [[1,6],[8,10],[15,18]]
console.log(JSON.stringify(mergeIntervals([[1, 4], [4, 5]])));
// 输出: [[1,5]]  （[1,4]和[4,5]也算重叠）

// ========== 例题3：数组中的第K个最大元素（LeetCode 215）==========
// 解法1：排序后直接取（简单粗暴）
function findKthLargest(nums: number[], k: number): number {
  nums.sort((a, b) => a - b);
  return nums[nums.length - k];  // 倒数第k个
}

// 解法2：快速选择（QuickSelect）—— 利用 partition 的思想
// 不需要完全排序，只需要找到第k大的元素所在的位置
// 平均时间复杂度：O(n)，比排序的 O(n log n) 更快
function findKthLargestQuickSelect(nums: number[], k: number): number {
  return quickSelect(nums, 0, nums.length - 1, nums.length - k);
}

function quickSelect(nums: number[], low: number, high: number, k: number): number {
  if (low === high) return nums[low];

  // 随机选基准
  const pivotIdx = low + Math.floor(Math.random() * (high - low + 1));
  [nums[pivotIdx], nums[high]] = [nums[high], nums[pivotIdx]];

  // 分区
  const pivotPos = partition(nums, low, high);

  if (pivotPos === k) {
    return nums[k];  // 找到了！
  } else if (pivotPos < k) {
    return quickSelect(nums, pivotPos + 1, high, k);
  } else {
    return quickSelect(nums, low, pivotPos - 1, k);
  }
}

// 测试
console.log(findKthLargestQuickSelect([3, 2, 1, 5, 6, 4], 2));  // 输出: 5
console.log(findKthLargestQuickSelect([3, 2, 3, 1, 2, 4, 5, 5, 6], 4));  // 输出: 4
```

### 主题8 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、简单排序 O(n²)

```go
package main

import "fmt"

// ========== 1. 冒泡排序（Bubble Sort）==========
// 思想：相邻元素两两比较，大的往后交换
// 时间复杂度：O(n²)   空间复杂度：O(1)   稳定性：稳定
func BubbleSort(arr []int) []int {
	n := len(arr)

	// 外层循环：需要 n-1 轮
	for i := 0; i < n-1; i++ {
		// 内层循环：每轮比较相邻元素
		// 每完成一轮，最后面就多一个排好序的元素
		for j := 0; j < n-1-i; j++ {
			// 如果前面比后面大，就交换
			if arr[j] > arr[j+1] {
				arr[j], arr[j+1] = arr[j+1], arr[j]
			}
		}
		// 每轮结束后的状态（用于理解过程）
		fmt.Printf("第 %d 轮结束: %v\n", i+1, arr)
	}
	return arr
}

func testBubbleSort() {
	fmt.Println("初始数组: [64 34 25 12 22 11 90]")
	BubbleSort([]int{64, 34, 25, 12, 22, 11, 90})
}

// ========== 冒泡排序优化版：加 flag 提前终止 ==========
// 优化思路：如果某一轮没有发生任何交换，说明已经有序了，提前结束！
func BubbleSortOptimized(arr []int) []int {
	n := len(arr)

	for i := 0; i < n-1; i++ {
		swapped := false // 标记：这一轮有没有交换过

		for j := 0; j < n-1-i; j++ {
			if arr[j] > arr[j+1] {
				arr[j], arr[j+1] = arr[j+1], arr[j]
				swapped = true
			}
		}

		// 如果这一轮没有任何交换，说明已经有序
		if !swapped {
			fmt.Printf("第 %d 轮没有交换，提前结束！\n", i+1)
			break
		}
	}
	return arr
}

func testBubbleSortOpt() {
	// 对近乎有序的数组，优化效果显著
	fmt.Println(BubbleSortOptimized([]int{1, 2, 3, 5, 4}))
	// 只需2轮就结束！
}

// ========== 2. 选择排序（Selection Sort）==========
// 思想：每次从未排序部分选出最小值，放到已排序部分的末尾
// 时间复杂度：O(n²)   空间复杂度：O(1)   稳定性：不稳定
func SelectionSort(arr []int) []int {
	n := len(arr)

	// 外层循环：确定要放置最小值的位置 i
	for i := 0; i < n-1; i++ {
		// 假设当前位置 i 是最小值的索引
		minIdx := i

		// 内层循环：在未排序部分 [i+1, n) 中找真正的最小值
		for j := i + 1; j < n; j++ {
			if arr[j] < arr[minIdx] {
				minIdx = j // 更新最小值的索引
			}
		}

		// 把找到的最小值交换到位置 i
		if minIdx != i {
			arr[i], arr[minIdx] = arr[minIdx], arr[i]
		}

		fmt.Printf("第 %d 轮: 最小值 %d 放到位置 %d, 数组: %v\n", i+1, arr[i], i, arr)
	}
	return arr
}

func testSelectionSort() {
	fmt.Println("初始数组: [64 25 12 22 11]")
	SelectionSort([]int{64, 25, 12, 22, 11})
}

// ========== 3. 插入排序（Insertion Sort）==========
// 思想：像整理扑克牌，每次把新元素插到已排序部分的正确位置
// 时间复杂度：O(n²)   空间复杂度：O(1)   稳定性：稳定
func InsertionSort(arr []int) []int {
	n := len(arr)

	// 从第2个元素（索引1）开始
	for i := 1; i < n; i++ {
		// 当前要插入的元素
		key := arr[i]

		// j 是已排序部分的最后一个位置
		j := i - 1

		// 从右往左找插入位置：
		// 如果已排序部分的元素比 key 大，就往后挪一位，给 key 腾位置
		for j >= 0 && arr[j] > key {
			arr[j+1] = arr[j] // 元素后移，腾出空间
			j--
		}

		// 找到了正确位置，插入
		arr[j+1] = key

		fmt.Printf("插入 %d: %v\n", key, arr)
	}
	return arr
}

func testInsertionSort() {
	fmt.Println("初始数组: [31 41 59 26 41 58]")
	InsertionSort([]int{31, 41, 59, 26, 41, 58})
	// 对于几乎有序的数组，插入排序接近 O(n)！
}
```

##### 二、高效排序 O(n log n)

```go
package main

import "fmt"

// ========== 1. 归并排序（Merge Sort）==========
// 分治三步走：分（拆成两个子问题）→ 治（递归解决）→ 合（合并答案）
// 时间复杂度：O(n log n)   空间复杂度：O(n)   稳定性：稳定

// 辅助函数：合并两个有序数组
func Merge(left, right []int) []int {
	result := []int{}
	i, j := 0, 0

	// 两列都有人时，比较最前面的
	for i < len(left) && j < len(right) {
		if left[i] <= right[j] { // 注意用 <= 保证稳定性
			result = append(result, left[i])
			i++
		} else {
			result = append(result, right[j])
			j++
		}
	}

	// 把剩余的元素追加到结果中
	result = append(result, left[i:]...)
	result = append(result, right[j:]...)

	return result
}

// 归并排序完整实现
func MergeSort(arr []int) []int {
	// 基准情形：长度为0或1的数组天然有序
	if len(arr) <= 1 {
		return arr
	}

	// 分：从中间一分为二
	mid := len(arr) / 2
	left := arr[:mid]
	right := arr[mid:]

	// 治：递归地对两半排序
	leftSorted := MergeSort(left)
	rightSorted := MergeSort(right)

	// 合：合并两个有序数组
	return Merge(leftSorted, rightSorted)
}

func testMergeSort() {
	fmt.Println(Merge([]int{1, 3, 5, 7}, []int{2, 4, 6, 8}))
	// 输出: [1 2 3 4 5 6 7 8]

	arr := []int{38, 27, 43, 3, 9, 82, 10}
	fmt.Printf("排序结果: %v\n", MergeSort(arr))
	// 输出: [3 9 10 27 38 43 82]
}

// ========== 2. 快速排序（Quick Sort）==========
// 思想：选基准，分区，递归
// 平均时间复杂度：O(n log n)   最坏：O(n²)   空间：O(log n)   不稳定

// 分区函数：选最后一个元素为基准，
// 把比基准小的放左边，比基准大的放右边
func Partition(arr []int, low, high int) int {
	pivot := arr[high] // 选最后一个元素作为基准
	i := low - 1        // i 指向"小于等于基准的区域"的右边界

	for j := low; j < high; j++ {
		// 如果当前元素小于等于基准
		if arr[j] <= pivot {
			i++ // 扩展"小于等于区域"
			arr[i], arr[j] = arr[j], arr[i]
		}
	}

	// 把基准元素放到中间（i+1的位置）
	arr[i+1], arr[high] = arr[high], arr[i+1]

	return i + 1 // 返回基准的位置
}

func QuickSort(arr []int, low, high int) []int {
	if low < high {
		// pi 是基准元素排好后的正确位置
		pi := Partition(arr, low, high)

		// 递归排序基准左边和右边的部分
		QuickSort(arr, low, pi-1)
		QuickSort(arr, pi+1, high)
	}
	return arr
}

// ========== 随机化快速排序 ==========
// 优化：随机选择基准，避免最坏情况（已有序数组）
// 注意：Go 用 math/rand 生成随机数
func QuickSortRandom(arr []int, low, high int) []int {
	if low < high {
		// 随机选一个元素和最后一个交换，然后以最后一个为基准
		randomIdx := low + rand.Intn(high-low+1)
		arr[randomIdx], arr[high] = arr[high], arr[randomIdx]

		pi := Partition(arr, low, high)
		QuickSortRandom(arr, low, pi-1)
		QuickSortRandom(arr, pi+1, high)
	}
	return arr
}

func testQuickSort() {
	arr := []int{10, 7, 8, 9, 1, 5}
	QuickSort(arr, 0, len(arr)-1)
	fmt.Printf("排序结果: %v\n", arr)
	// 输出: [1 5 7 8 9 10]
}
```

##### 三、其他排序

```go
package main

import (
	"fmt"
	"sort"
)

// ========== 1. 堆排序（Heap Sort）==========
// 思想：利用最大堆的性质——堆顶永远是最大值
// 1. 先建堆   2. 每次把堆顶（最大值）和末尾交换，然后重新调整堆
// 时间复杂度：O(n log n)   空间复杂度：O(1)   稳定性：不稳定

// 维护最大堆性质
func Heapify(arr []int, n, i int) {
	largest := i         // 假设当前节点最大
	left := 2*i + 1      // 左子节点
	right := 2*i + 2     // 右子节点

	// 如果左子节点比当前节点大
	if left < n && arr[left] > arr[largest] {
		largest = left
	}

	// 如果右子节点比当前最大的还大
	if right < n && arr[right] > arr[largest] {
		largest = right
	}

	// 如果最大不是当前节点，交换并继续调整
	if largest != i {
		arr[i], arr[largest] = arr[largest], arr[i]
		Heapify(arr, n, largest) // 递归调整被影响的子树
	}
}

func HeapSort(arr []int) []int {
	n := len(arr)

	// 第1步：建最大堆（从最后一个非叶节点开始调整）
	for i := n/2 - 1; i >= 0; i-- {
		Heapify(arr, n, i)
	}

	// 第2步：逐个取出最大值（堆顶）放到末尾
	for i := n - 1; i > 0; i-- {
		arr[0], arr[i] = arr[i], arr[0] // 堆顶和末尾交换
		Heapify(arr, i, 0)              // 对缩小后的堆重新调整
	}

	return arr
}

func testHeapSort() {
	fmt.Printf("堆排序结果: %v\n", HeapSort([]int{12, 11, 13, 5, 6, 7}))
	// 输出: [5 6 7 11 12 13]
}

// ========== 2. 计数排序（Counting Sort）==========
// 非比较排序！思想：不用比较，而是"数数"
// 适用条件：元素是非负整数，且范围不大
// 时间复杂度：O(n + k)，k 是数据范围   空间复杂度：O(n + k)   稳定
func CountingSort(arr []int) []int {
	if len(arr) == 0 {
		return arr
	}

	// 找到最大值和最小值
	maxVal, minVal := arr[0], arr[0]
	for _, num := range arr {
		if num > maxVal {
			maxVal = num
		}
		if num < minVal {
			minVal = num
		}
	}
	rangeLen := maxVal - minVal + 1 // 数据范围

	// 创建计数数组
	count := make([]int, rangeLen)

	// 统计每个元素出现的次数
	for _, num := range arr {
		count[num-minVal]++
	}

	// 累加计数（确定每个元素在结果中的位置）
	for i := 1; i < len(count); i++ {
		count[i] += count[i-1]
	}

	// 从后往前遍历原数组，保证稳定性
	result := make([]int, len(arr))
	for i := len(arr) - 1; i >= 0; i-- {
		idx := arr[i] - minVal
		result[count[idx]-1] = arr[i]
		count[idx]--
	}

	return result
}

func testCountingSort() {
	fmt.Printf("计数排序结果: %v\n", CountingSort([]int{4, 2, 2, 8, 3, 3, 1}))
	// 输出: [1 2 2 3 3 4 8]
}

// ========== 3. Go 内置排序 ==========
// Go 标准库 sort 包：
// - sort.Ints()：整数切片升序
// - sort.Slice()：自定义排序规则
// - 底层是改进的快速排序（pdqsort）

func testBuiltinSort() {
	arr := []int{5, 2, 8, 1, 9, 3}

	// 方式1：sort.Ints() 升序（原地排序）
	sort.Ints(arr)
	fmt.Println(arr) // [1 2 3 5 8 9]

	// 方式2：sort.Slice() 自定义排序规则
	arr2 := []int{5, 2, 8, 1, 9, 3}
	sort.Slice(arr2, func(i, j int) bool {
		return arr2[i] > arr2[j] // 降序
	})
	fmt.Println(arr2) // [9 8 5 3 2 1]

	// 按绝对值排序
	arr3 := []int{-5, 2, -8, 1, -9, 3}
	sort.Slice(arr3, func(i, j int) bool {
		return abs(arr3[i]) < abs(arr3[j])
	})
	fmt.Println(arr3) // [1 2 3 -5 -8 -9]
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}
```

##### 四、经典例题

```go
package main

import (
	"fmt"
	"math/rand"
	"sort"
)

// ========== 例题1：排序数组（LeetCode 912）==========
// 解法1：直接用归并排序（MergeSort 上面已定义）

// ========== 例题2：合并区间（LeetCode 56）==========
// 输入：intervals = [[1,3],[2,6],[8,10],[15,18]]
// 输出：[[1,6],[8,10],[15,18]]
func MergeIntervals(intervals [][]int) [][]int {
	if len(intervals) == 0 {
		return [][]int{}
	}

	// 关键第一步：按区间起始位置排序！
	sort.Slice(intervals, func(i, j int) bool {
		return intervals[i][0] < intervals[j][0]
	})

	result := [][]int{intervals[0]}

	for i := 1; i < len(intervals); i++ {
		current := intervals[i]
		last := result[len(result)-1]

		// 如果当前区间的起始 <= 上一个区间的结束，说明有重叠
		if current[0] <= last[1] {
			// 合并：更新结束位置为两者的较大值
			if current[1] > last[1] {
				last[1] = current[1]
			}
		} else {
			// 没有重叠，直接加入结果
			result = append(result, current)
		}
	}

	return result
}

// ========== 例题3：数组中的第K个最大元素（LeetCode 215）==========
// 解法1：排序后直接取（简单粗暴）
func FindKthLargest(nums []int, k int) int {
	sort.Ints(nums)
	return nums[len(nums)-k] // 倒数第k个
}

// 解法2：快速选择（QuickSelect）—— 利用 partition 的思想
// 平均时间复杂度：O(n)，比排序的 O(n log n) 更快
func FindKthLargestQuickSelect(nums []int, k int) int {
	return QuickSelect(nums, 0, len(nums)-1, len(nums)-k)
}

func QuickSelect(nums []int, low, high, k int) int {
	if low == high {
		return nums[low]
	}

	// 随机选基准
	pivotIdx := low + rand.Intn(high-low+1)
	nums[pivotIdx], nums[high] = nums[high], nums[pivotIdx]

	// 分区
	pivotPos := Partition(nums, low, high)

	if pivotPos == k {
		return nums[k] // 找到了！
	} else if pivotPos < k {
		return QuickSelect(nums, pivotPos+1, high, k)
	} else {
		return QuickSelect(nums, low, pivotPos-1, k)
	}
}

func testSortExamples() {
	// 例题2测试
	fmt.Println(MergeIntervals([][]int{{1, 3}, {2, 6}, {8, 10}, {15, 18}}))
	// 输出: [[1 6] [8 10] [15 18]]
	fmt.Println(MergeIntervals([][]int{{1, 4}, {4, 5}}))
	// 输出: [[1 5]]  （[1,4]和[4,5]也算重叠）

	// 例题3测试
	fmt.Println(FindKthLargestQuickSelect([]int{3, 2, 1, 5, 6, 4}, 2))       // 输出: 5
	fmt.Println(FindKthLargestQuickSelect([]int{3, 2, 3, 1, 2, 4, 5, 5, 6}, 4)) // 输出: 4
}
```

---

### 主题9：查找算法


#### 一、线性查找

##### 最简单的查找方式

线性查找就是**从头到尾遍历一遍**，挨个检查每个元素是不是我们要找的。

```
生活类比：在一堆没有排序的扑克牌中找红桃7
你只能一张一张翻，直到找到或者全部翻完
```

```python
def linear_search(arr, target):
    """
    线性查找
    从头到尾遍历，找到目标就返回索引，找不到返回 -1
    时间复杂度：O(n)
    不需要数组有序！
    """
    for i in range(len(arr)):
        if arr[i] == target:
            return i  # 找到了，返回索引
    
    return -1  # 遍历完没找到

# 测试
arr = [4, 2, 7, 1, 9, 3, 5]
print(linear_search(arr, 7))   # 输出: 2（索引2）
print(linear_search(arr, 6))   # 输出: -1（没找到）
```

**特点：**
- 不需要数据有序
- 时间复杂度 O(n)，数据量大时很慢
- 如果只查一次，这是唯一的选择（因为排序本身就要 O(n log n)）

---

#### 二、二分查找（Binary Search）—— 重点

##### 前提条件：数组必须是有序的！

##### 核心思想

**每次把查找范围缩小一半**，就像翻字典：

```
生活类比：在一本1000页的字典里找 "python" 这个词

第1步：翻到中间（第500页），看到是 "math"
       → "python" 在 "math" 后面，翻后半部分

第2步：翻到第750页，看到是 "science"  
       → "python" 在 "science" 后面，继续翻后半部分

第3步：翻到第875页，看到是 "python"！找到了！

只翻了3次！如果是线性查找，最坏要翻1000次
```

##### 2.1 迭代法实现

```python
def binary_search(arr, target):
    """
    二分查找（迭代法）
    前提：arr 必须是有序数组
    时间复杂度：O(log n)
    空间复杂度：O(1)
    """
    left = 0              # 左边界
    right = len(arr) - 1  # 右边界
    
    # 当搜索范围有效时（左边界 <= 右边界）
    while left <= right:
        # 计算中间位置
        # 注意：用 left + (right - left) // 2 而不是 (left + right) // 2
        # 原因：防止 left + right 太大导致整数溢出（Python自动处理大数，但这是好习惯）
        mid = left + (right - left) // 2
        
        if arr[mid] == target:
            return mid          # 找到了！
        elif arr[mid] < target:
            left = mid + 1      # 目标在右半边，缩小左边界
        else:
            right = mid - 1     # 目标在左半边，缩小右边界
    
    return -1  # 没找到

# 测试
arr = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
print(binary_search(arr, 7))    # 输出: 3
print(binary_search(arr, 1))    # 输出: 0
print(binary_search(arr, 19))   # 输出: 9
print(binary_search(arr, 6))    # 输出: -1
```

##### 2.2 递归法实现

```python
def binary_search_recursive(arr, target, left, right):
    """
    二分查找（递归法）
    """
    # 基准情形：搜索范围为空
    if left > right:
        return -1
    
    mid = left + (right - left) // 2
    
    if arr[mid] == target:
        return mid
    elif arr[mid] < target:
        return binary_search_recursive(arr, target, mid + 1, right)
    else:
        return binary_search_recursive(arr, target, left, mid - 1)

# 测试（包装一下方便调用）
def bs(arr, target):
    return binary_search_recursive(arr, target, 0, len(arr) - 1)

arr = [1, 3, 5, 7, 9, 11, 13, 15]
print(bs(arr, 7))    # 输出: 3
print(bs(arr, 6))    # 输出: -1
```

##### 2.3 复杂度分析

###### 为什么是 O(log n)？

每次查找，搜索范围缩小一半：

```
第0次: n 个元素
第1次: n/2 个元素
第2次: n/4 个元素
第3次: n/8 个元素
...
第k次: n/2^k 个元素

当搜索范围缩小到1个元素时：
n / 2^k = 1
→ 2^k = n
→ k = log₂(n)

所以最多查 log₂(n) 次！
```

| 数据量 n | 线性查找最坏次数 | 二分查找最坏次数 |
|---------|---------------|---------------|
| 100 | 100 | 7 |
| 10,000 | 10,000 | 14 |
| 1,000,000 | 1,000,000 | 20 |
| 10亿 | 1,000,000,000 | 30 |

> 10亿个元素，线性查找最坏要10亿次，二分查找只要30次！这就是 O(log n) 的威力。

---

##### 2.4 二分查找的三个变体

标准二分查找只找"有没有"，但实际面试中经常需要找"第一个"或"最后一个"。

###### 变体1：查找第一个等于给定值的元素

```python
def binary_search_first(arr, target):
    """
    查找第一个等于 target 的元素
    比如 arr = [1, 2, 2, 2, 3, 4]，target = 2
    返回索引 1（第一个2的位置），而不是中间的2
    
    关键改动：找到 target 时不立即返回，而是继续往左找
    """
    left = 0
    right = len(arr) - 1
    result = -1  # 记录找到的位置
    
    while left <= right:
        mid = left + (right - left) // 2
        
        if arr[mid] == target:
            result = mid       # 记录当前位置
            right = mid - 1    # 继续往左找！看有没有更早出现的
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    
    return result

# 测试
arr = [1, 2, 2, 2, 2, 3, 4]
print(binary_search_first(arr, 2))  # 输出: 1（第一个2在索引1）
print(binary_search_first(arr, 5))  # 输出: -1
```

###### 变体2：查找最后一个等于给定值的元素

```python
def binary_search_last(arr, target):
    """
    查找最后一个等于 target 的元素
    比如 arr = [1, 2, 2, 2, 3, 4]，target = 2
    返回索引 3（最后一个2的位置）
    
    关键改动：找到 target 时不立即返回，而是继续往右找
    """
    left = 0
    right = len(arr) - 1
    result = -1
    
    while left <= right:
        mid = left + (right - left) // 2
        
        if arr[mid] == target:
            result = mid       # 记录当前位置
            left = mid + 1     # 继续往右找！看有没有更晚出现的
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    
    return result

# 测试
arr = [1, 2, 2, 2, 2, 3, 4]
print(binary_search_last(arr, 2))  # 输出: 4（最后一个2在索引4）
```

###### 变体3：查找第一个大于等于给定值的元素

```python
def binary_search_first_ge(arr, target):
    """
    查找第一个大于等于 target 的元素（也叫下界 lower_bound）
    比如 arr = [1, 3, 5, 7, 9]，target = 4
    返回索引 2（元素5，第一个 >= 4 的元素）
    
    生活类比：在有序列表中找"第一个不低于某标准"的元素
    """
    left = 0
    right = len(arr) - 1
    result = len(arr)  # 默认值：如果没找到，返回数组长度
    
    while left <= right:
        mid = left + (right - left) // 2
        
        if arr[mid] >= target:
            result = mid       # 记录当前位置
            right = mid - 1    # 继续往左找，看有没有更早的 >= target 的
        else:
            left = mid + 1     # 当前元素太小了，往右找
    
    return result

# 测试
arr = [1, 3, 5, 7, 9]
print(binary_search_first_ge(arr, 4))  # 输出: 2（元素5）
print(binary_search_first_ge(arr, 5))  # 输出: 2（元素5，正好等于）
print(binary_search_first_ge(arr, 1))  # 输出: 0（元素1）
print(binary_search_first_ge(arr, 10)) # 输出: 5（没有 >= 10 的）
```

---

#### 三、二分查找的应用

##### 3.1 在旋转数组中查找（LeetCode 33）

```python
# 整数数组 nums 按升序排列后，在某个位置进行了旋转。
# 例如 [0,1,2,4,5,6,7] 旋转后可能变成 [4,5,6,7,0,1,2]
# 给你旋转后的数组和一个目标值 target，找到 target 的索引，找不到返回 -1
# 要求时间复杂度 O(log n)

# 输入: nums = [4,5,6,7,0,1,2], target = 0
# 输出: 4

class Solution:
    def search(self, nums, target):
        """
        旋转数组中查找目标值
        
        思路：旋转数组有一个特点——存在一个"断点"，断点左边都 >= 第一个元素，
        断点右边都 < 第一个元素。利用这个性质，可以先用二分找到断点，
        再判断 target 在哪一半，然后在那一半做普通二分查找。
        
        更简洁的做法：直接在二分查找中判断 target 在哪一半
        """
        left, right = 0, len(nums) - 1
        
        while left <= right:
            mid = left + (right - left) // 2
            
            if nums[mid] == target:
                return mid
            
            # 判断 mid 在哪个有序部分
            if nums[mid] >= nums[left]:
                # mid 在左边的有序部分
                if nums[left] <= target < nums[mid]:
                    right = mid - 1  # target 在左半部分
                else:
                    left = mid + 1   # target 在右半部分
            else:
                # mid 在右边的有序部分
                if nums[mid] < target <= nums[right]:
                    left = mid + 1   # target 在右半部分
                else:
                    right = mid - 1  # target 在左半部分
        
        return -1

# 测试
sol = Solution()
print(sol.search([4, 5, 6, 7, 0, 1, 2], 0))  # 输出: 4
print(sol.search([4, 5, 6, 7, 0, 1, 2], 3))  # 输出: -1
print(sol.search([1], 0))                      # 输出: -1
```

##### 3.2 求平方根（LeetCode 69）

```python
# 给你一个非负整数 x ，计算并返回 x 的算术平方根（向下取整）。
# 不允许使用任何内置指数函数和算符，如 x ** 0.5 或 math.sqrt(x)

# 输入: x = 8
# 输出: 2 （因为 2² = 4 ≤ 8 < 9 = 3²）

class Solution:
    def mySqrt(self, x):
        """
        用二分查找求平方根
        
        思路：答案的范围是 [0, x]，在这个范围内二分查找
        找最大的 mid，使得 mid * mid <= x
        """
        if x == 0:
            return 0
        
        left, right = 1, x
        
        while left <= right:
            mid = left + (right - left) // 2
            
            if mid * mid == x:
                return mid           # 正好是完全平方数
            elif mid * mid < x:
                # mid² < x，答案可能是 mid，也可能更大
                # 先记录，继续往右找
                left = mid + 1
            else:
                # mid² > x，答案一定比 mid 小
                right = mid - 1
        
        # 循环结束时，right < left
        # right 是最后一个满足 right² <= x 的值
        return right

# 测试
sol = Solution()
print(sol.mySqrt(4))   # 输出: 2
print(sol.mySqrt(8))   # 输出: 2
print(sol.mySqrt(16))  # 输出: 4
print(sol.mySqrt(0))   # 输出: 0
```

##### 3.3 搜索插入位置（LeetCode 35）

```python
# 给定一个排序数组和一个目标值，
# 如果找到目标值，返回其索引。
# 如果找不到，返回它按顺序应该插入的位置。
# 要求时间复杂度 O(log n)

# 输入: nums = [1,3,5,6], target = 5
# 输出: 2

# 输入: nums = [1,3,5,6], target = 2
# 输出: 1（2 应该插在 1 和 3 之间，索引1的位置）

class Solution:
    def searchInsert(self, nums, target):
        """
        其实就是找"第一个 >= target 的元素的位置"
        也就是前面讲的 lower_bound 变体！
        """
        left, right = 0, len(nums) - 1
        
        while left <= right:
            mid = left + (right - left) // 2
            
            if nums[mid] == target:
                return mid        # 找到了
            elif nums[mid] < target:
                left = mid + 1
            else:
                right = mid - 1
        
        # 没找到时，left 就是应该插入的位置
        # 因为 left 指向第一个 > target 的元素
        return left

# 测试
sol = Solution()
print(sol.searchInsert([1, 3, 5, 6], 5))  # 输出: 2
print(sol.searchInsert([1, 3, 5, 6], 2))  # 输出: 1
print(sol.searchInsert([1, 3, 5, 6], 7))  # 输出: 4
print(sol.searchInsert([1, 3, 5, 6], 0))  # 输出: 0
```

---

#### 四、二分查找的扩展：在答案空间上二分

前面讲的二分查找都是在**有序数组**中查找。但二分查找的思想可以推广——**只要答案具有单调性（能判断"大了"还是"小了"），就能二分！**

##### 4.1 珂珂吃香蕉（LeetCode 875）

```python
# 珂珂喜欢吃香蕉。这里有 n 堆香蕉，第 i 堆有 piles[i] 根香蕉。
# 守卫会在 h 小时后回来。
# 珂珂每小时可以选择一堆香蕉，吃 k 根（k 是她选择的吃香蕉速度）。
# 如果这堆香蕉少于 k 根，她吃完这堆就停下来等下一个小时。
# 返回她能在 h 小时内吃完所有香蕉的最小速度 k。

# 输入: piles = [3,6,7,11], h = 8
# 输出: 4

class Solution:
    def minEatingSpeed(self, piles, h):
        """
        在"答案空间"上二分
        
        思路：
        - 答案 k 的范围是 [1, max(piles)]
        - 如果速度 k 能在 h 小时内吃完，那速度 k+1 也一定能
        - 这种"能/不能"的单调性，就是二分的条件！
        
        我们不是在一个有序数组中查找，而是在答案的可能范围中查找。
        对于每个候选答案 k，我们"验证"它是否可行。
        """
        # 辅助函数：以速度 k 吃完所有香蕉需要多少小时
        def hours_needed(k):
            total = 0
            for pile in piles:
                # 每堆需要 ceil(pile / k) 小时
                total += (pile + k - 1) // k  # 向上取整的技巧
            return total
        
        # 二分查找答案
        left = 1                    # 最慢：每小时吃1根
        right = max(piles)          # 最快：每小时吃完最大的一堆
        ans = right
        
        while left <= right:
            mid = (left + right) // 2
            
            if hours_needed(mid) <= h:
                ans = mid           # 这个速度可以，但试试能不能更慢
                right = mid - 1
            else:
                left = mid + 1      # 太慢了，需要加快速度
        
        return ans

# 测试
sol = Solution()
print(sol.minEatingSpeed([3, 6, 7, 11], 8))    # 输出: 4
print(sol.minEatingSpeed([30, 11, 23, 4, 20], 5))  # 输出: 30
print(sol.minEatingSpeed([30, 11, 23, 4, 20], 6))  # 输出: 23
```

##### 4.2 有序矩阵中第K小的元素

```python
# 给你一个 n x n 矩阵 matrix ，其中每行和每列元素均按升序排序，
# 找到矩阵中第 k 小的元素。

# 输入: matrix = [[1,5,9],[10,11,13],[12,13,15]], k = 8
# 输出: 13
# 解释: 矩阵中元素排序后为 [1, 5, 9, 10, 11, 12, 13, 13, 15]，第8小是13

class Solution:
    def kthSmallest(self, matrix, k):
        """
        在值域上二分
        
        思路：
        - 答案范围是 [matrix[0][0], matrix[-1][-1]]（最小值到最大值）
        - 对于一个候选值 mid，统计矩阵中 <= mid 的元素个数
        - 如果个数 < k，说明答案比 mid 大
        - 如果个数 >= k，说明答案可能是 mid 或更小
        
        统计 <= mid 的元素个数：
        从矩阵的左下角开始，如果当前元素 <= mid，
        那这一行左边的都 <= mid，往右走；否则往上走。
        """
        n = len(matrix)
        
        def count_less_equal(mid):
            """统计矩阵中小于等于 mid 的元素个数"""
            count = 0
            row = n - 1  # 从左下角开始
            col = 0
            
            while row >= 0 and col < n:
                if matrix[row][col] <= mid:
                    count += row + 1  # 这一列从0到row都 <= mid
                    col += 1          # 往右走
                else:
                    row -= 1          # 往上走
            
            return count
        
        # 二分查找
        left = matrix[0][0]           # 最小值
        right = matrix[-1][-1]        # 最大值
        
        while left < right:
            mid = left + (right - left) // 2
            
            if count_less_equal(mid) < k:
                left = mid + 1    # 答案比 mid 大
            else:
                right = mid       # 答案可能是 mid 或更小
        
        return left  # left == right 时就是答案

# 测试
sol = Solution()
print(sol.kthSmallest([[1, 5, 9], [10, 11, 13], [12, 13, 15]], 8))
# 输出: 13
```

---

#### 五、插值查找和斐波那契查找简介

##### 插值查找（Interpolation Search）

```python
def interpolation_search(arr, target):
    """
    插值查找 —— 二分查找的改进版
    
    二分查找每次取中点：mid = (left + right) // 2
    插值查找根据目标值的大小，按比例估算位置：
    
    类比：在字典里找 "apple"，你不会翻到正中间，
    而是会翻到比较靠前的位置，因为 a 在字母表前面。
    
    前提：数组有序，且元素分布比较均匀
    时间复杂度：O(log log n)（均匀分布时），最坏 O(n)
    """
    left = 0
    right = len(arr) - 1
    
    while left <= right and arr[left] <= target <= arr[right]:
        if left == right:
            if arr[left] == target:
                return left
            return -1
        
        # 插值公式：按比例估算位置
        # 如果 target 接近 arr[left]，pos 接近 left
        # 如果 target 接近 arr[right]，pos 接近 right
        pos = left + (target - arr[left]) * (right - left) // (arr[right] - arr[left])
        
        if arr[pos] == target:
            return pos
        elif arr[pos] < target:
            left = pos + 1
        else:
            right = pos - 1
    
    return -1

# 测试
arr = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
print(interpolation_search(arr, 70))  # 输出: 6
```

##### 斐波那契查找（Fibonacci Search）

```python
def fibonacci_search(arr, target):
    """
    斐波那契查找 —— 用斐波那契数列来分割查找区间
    
    斐波那契数列：1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
    
    和二分查找类似，但分割点不是中点，而是用斐波那契数来确定分割位置。
    
    优点：只用加法和减法，不用除法（某些硬件上更快）
    时间复杂度：O(log n)
    适用场景：数据量很大、存储在磁盘上（顺序访问更快）
    """
    # 生成斐波那契数，直到大于等于数组长度
    fib2 = 0  # F(k-2)
    fib1 = 1  # F(k-1)
    fib = fib2 + fib1  # F(k)
    
    while fib < len(arr):
        fib2 = fib1
        fib1 = fib
        fib = fib2 + fib1
    
    # 初始化标记
    offset = -1  # 已排除的部分的末尾索引
    
    while fib > 1:
        # 检查 fib2 位置是否在数组范围内
        i = min(offset + fib2, len(arr) - 1)
        
        if arr[i] < target:
            # 目标在右边，排除左边部分
            fib = fib1
            fib1 = fib2
            fib2 = fib - fib1
            offset = i
        elif arr[i] > target:
            # 目标在左边，排除右边部分
            fib = fib2
            fib1 = fib1 - fib2
            fib2 = fib - fib1
        else:
            return i  # 找到了！
    
    # 检查最后一个元素
    if fib1 and offset + 1 < len(arr) and arr[offset + 1] == target:
        return offset + 1
    
    return -1

# 测试
arr = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
print(fibonacci_search(arr, 13))  # 输出: 6
print(fibonacci_search(arr, 6))   # 输出: -1
```

##### 三种查找方式对比

| 查找方式 | 分割方式 | 时间复杂度 | 适用场景 |
|---------|---------|-----------|---------|
| 二分查找 | 每次对半分（1/2） | O(log n) | 通用，最常用 |
| 插值查找 | 按目标值比例分割 | O(log log n) ~ O(n) | 数据均匀分布时更快 |
| 斐波那契查找 | 按黄金比例分割（约0.618） | O(log n) | 顺序访问的大数据集 |

> **实际开发中，二分查找是最常用的。** 插值查找和斐波那契查找更多出现在面试和学术讨论中。掌握二分查找及其变体是最重要的。


### 主题9 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、线性查找

```typescript
// ========== 线性查找 ==========
// 从头到尾遍历，找到目标就返回索引，找不到返回 -1
// 时间复杂度：O(n)   不需要数组有序！
function linearSearch(arr: number[], target: number): number {
  for (let i = 0; i < arr.length; i++) {
    if (arr[i] === target) return i;  // 找到了，返回索引
  }
  return -1;  // 遍历完没找到
}

// 测试
const linArr = [4, 2, 7, 1, 9, 3, 5];
console.log(linearSearch(linArr, 7));  // 输出: 2（索引2）
console.log(linearSearch(linArr, 6));  // 输出: -1（没找到）
```

##### 二、二分查找（Binary Search）

```typescript
// ========== 1. 迭代法实现 ==========
// 前提：arr 必须是有序数组
// 时间复杂度：O(log n)   空间复杂度：O(1)
function binarySearch(arr: number[], target: number): number {
  let left = 0;              // 左边界
  let right = arr.length - 1;  // 右边界

  // 当搜索范围有效时（左边界 <= 右边界）
  while (left <= right) {
    // 计算中间位置
    // 用 left + Math.floor((right - left) / 2) 而不是 Math.floor((left + right) / 2)
    // 原因：防止 left + right 太大导致整数溢出
    const mid = left + Math.floor((right - left) / 2);

    if (arr[mid] === target) {
      return mid;          // 找到了！
    } else if (arr[mid] < target) {
      left = mid + 1;      // 目标在右半边，缩小左边界
    } else {
      right = mid - 1;     // 目标在左半边，缩小右边界
    }
  }

  return -1;  // 没找到
}

// 测试
const binArr = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19];
console.log(binarySearch(binArr, 7));   // 输出: 3
console.log(binarySearch(binArr, 1));   // 输出: 0
console.log(binarySearch(binArr, 19));  // 输出: 9
console.log(binarySearch(binArr, 6));   // 输出: -1

// ========== 2. 递归法实现 ==========
function binarySearchRecursive(
  arr: number[],
  target: number,
  left: number,
  right: number
): number {
  // 基准情形：搜索范围为空
  if (left > right) return -1;

  const mid = left + Math.floor((right - left) / 2);

  if (arr[mid] === target) return mid;
  else if (arr[mid] < target) return binarySearchRecursive(arr, target, mid + 1, right);
  else return binarySearchRecursive(arr, target, left, mid - 1);
}

// 包装一下方便调用
function bs(arr: number[], target: number): number {
  return binarySearchRecursive(arr, target, 0, arr.length - 1);
}

console.log(bs([1, 3, 5, 7, 9, 11, 13, 15], 7));  // 输出: 3
console.log(bs([1, 3, 5, 7, 9, 11, 13, 15], 6));  // 输出: -1
```

##### 三、二分查找的三个变体

```typescript
// ========== 变体1：查找第一个等于给定值的元素 ==========
// 关键改动：找到 target 时不立即返回，而是继续往左找
function binarySearchFirst(arr: number[], target: number): number {
  let left = 0;
  let right = arr.length - 1;
  let result = -1;  // 记录找到的位置

  while (left <= right) {
    const mid = left + Math.floor((right - left) / 2);

    if (arr[mid] === target) {
      result = mid;       // 记录当前位置
      right = mid - 1;    // 继续往左找！看有没有更早出现的
    } else if (arr[mid] < target) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }

  return result;
}

// 测试
console.log(binarySearchFirst([1, 2, 2, 2, 2, 3, 4], 2));  // 输出: 1（第一个2在索引1）

// ========== 变体2：查找最后一个等于给定值的元素 ==========
// 关键改动：找到 target 时不立即返回，而是继续往右找
function binarySearchLast(arr: number[], target: number): number {
  let left = 0;
  let right = arr.length - 1;
  let result = -1;

  while (left <= right) {
    const mid = left + Math.floor((right - left) / 2);

    if (arr[mid] === target) {
      result = mid;       // 记录当前位置
      left = mid + 1;     // 继续往右找！看有没有更晚出现的
    } else if (arr[mid] < target) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }

  return result;
}

// 测试
console.log(binarySearchLast([1, 2, 2, 2, 2, 3, 4], 2));  // 输出: 4（最后一个2在索引4）

// ========== 变体3：查找第一个大于等于给定值的元素 ==========
// 也叫下界 lower_bound
// 生活类比：在有序列表中找"第一个不低于某标准"的元素
function binarySearchFirstGe(arr: number[], target: number): number {
  let left = 0;
  let right = arr.length - 1;
  let result = arr.length;  // 默认值：如果没找到，返回数组长度

  while (left <= right) {
    const mid = left + Math.floor((right - left) / 2);

    if (arr[mid] >= target) {
      result = mid;       // 记录当前位置
      right = mid - 1;    // 继续往左找，看有没有更早的 >= target 的
    } else {
      left = mid + 1;     // 当前元素太小了，往右找
    }
  }

  return result;
}

// 测试
console.log(binarySearchFirstGe([1, 3, 5, 7, 9], 4));   // 输出: 2（元素5）
console.log(binarySearchFirstGe([1, 3, 5, 7, 9], 5));   // 输出: 2（元素5，正好等于）
console.log(binarySearchFirstGe([1, 3, 5, 7, 9], 1));   // 输出: 0（元素1）
console.log(binarySearchFirstGe([1, 3, 5, 7, 9], 10));  // 输出: 5（没有 >= 10 的）
```

##### 四、二分查找的应用

```typescript
// ========== 1. 在旋转数组中查找（LeetCode 33）==========
// 旋转数组的特点：存在一个"断点"，断点左边都 >= 第一个元素，断点右边都 < 第一个元素
function searchRotated(nums: number[], target: number): number {
  let left = 0;
  let right = nums.length - 1;

  while (left <= right) {
    const mid = left + Math.floor((right - left) / 2);

    if (nums[mid] === target) return mid;

    // 判断 mid 在哪个有序部分
    if (nums[mid] >= nums[left]) {
      // mid 在左边的有序部分
      if (nums[left] <= target && target < nums[mid]) {
        right = mid - 1;  // target 在左半部分
      } else {
        left = mid + 1;   // target 在右半部分
      }
    } else {
      // mid 在右边的有序部分
      if (nums[mid] < target && target <= nums[right]) {
        left = mid + 1;   // target 在右半部分
      } else {
        right = mid - 1;  // target 在左半部分
      }
    }
  }

  return -1;
}

// 测试
console.log(searchRotated([4, 5, 6, 7, 0, 1, 2], 0));  // 输出: 4
console.log(searchRotated([4, 5, 6, 7, 0, 1, 2], 3));  // 输出: -1
console.log(searchRotated([1], 0));                     // 输出: -1

// ========== 2. 求平方根（LeetCode 69）==========
// 思路：答案的范围是 [0, x]，在这个范围内二分查找
// 找最大的 mid，使得 mid * mid <= x
function mySqrt(x: number): number {
  if (x === 0) return 0;

  let left = 1;
  let right = x;

  while (left <= right) {
    const mid = left + Math.floor((right - left) / 2);

    if (mid * mid === x) {
      return mid;           // 正好是完全平方数
    } else if (mid * mid < x) {
      // mid² < x，答案可能是 mid，也可能更大
      left = mid + 1;
    } else {
      // mid² > x，答案一定比 mid 小
      right = mid - 1;
    }
  }

  // 循环结束时，right 是最后一个满足 right² <= x 的值
  return right;
}

// 测试
console.log(mySqrt(4));   // 输出: 2
console.log(mySqrt(8));   // 输出: 2
console.log(mySqrt(16));  // 输出: 4
console.log(mySqrt(0));   // 输出: 0

// ========== 3. 搜索插入位置（LeetCode 35）==========
// 其实就是找"第一个 >= target 的元素的位置"（lower_bound）
function searchInsert(nums: number[], target: number): number {
  let left = 0;
  let right = nums.length - 1;

  while (left <= right) {
    const mid = left + Math.floor((right - left) / 2);

    if (nums[mid] === target) {
      return mid;        // 找到了
    } else if (nums[mid] < target) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }

  // 没找到时，left 就是应该插入的位置
  return left;
}

// 测试
console.log(searchInsert([1, 3, 5, 6], 5));  // 输出: 2
console.log(searchInsert([1, 3, 5, 6], 2));  // 输出: 1
console.log(searchInsert([1, 3, 5, 6], 7));  // 输出: 4
console.log(searchInsert([1, 3, 5, 6], 0));  // 输出: 0
```

##### 五、在答案空间上二分

```typescript
// ========== 1. 珂珂吃香蕉（LeetCode 875）==========
// 思路：
// - 答案 k 的范围是 [1, max(piles)]
// - 如果速度 k 能在 h 小时内吃完，那速度 k+1 也一定能
// - 这种"能/不能"的单调性，就是二分的条件！
function minEatingSpeed(piles: number[], h: number): number {
  // 辅助函数：以速度 k 吃完所有香蕉需要多少小时
  const hoursNeeded = (k: number): number => {
    let total = 0;
    for (const pile of piles) {
      // 每堆需要 ceil(pile / k) 小时
      total += Math.ceil(pile / k);  // 向上取整
    }
    return total;
  };

  // 二分查找答案
  let left = 1;                 // 最慢：每小时吃1根
  let right = Math.max(...piles);  // 最快：每小时吃完最大的一堆
  let ans = right;

  while (left <= right) {
    const mid = Math.floor((left + right) / 2);

    if (hoursNeeded(mid) <= h) {
      ans = mid;           // 这个速度可以，但试试能不能更慢
      right = mid - 1;
    } else {
      left = mid + 1;      // 太慢了，需要加快速度
    }
  }

  return ans;
}

// 测试
console.log(minEatingSpeed([3, 6, 7, 11], 8));          // 输出: 4
console.log(minEatingSpeed([30, 11, 23, 4, 20], 5));    // 输出: 30
console.log(minEatingSpeed([30, 11, 23, 4, 20], 6));    // 输出: 23

// ========== 2. 有序矩阵中第K小的元素 ==========
// 思路：
// - 答案范围是 [matrix[0][0], matrix[last][last]]
// - 对于一个候选值 mid，统计矩阵中 <= mid 的元素个数
function kthSmallest(matrix: number[][], k: number): number {
  const n = matrix.length;

  // 统计矩阵中小于等于 mid 的元素个数
  // 从矩阵的左下角开始，如果当前元素 <= mid，
  // 那这一行左边的都 <= mid，往右走；否则往上走。
  const countLessEqual = (mid: number): number => {
    let count = 0;
    let row = n - 1;  // 从左下角开始
    let col = 0;

    while (row >= 0 && col < n) {
      if (matrix[row][col] <= mid) {
        count += row + 1;  // 这一列从0到row都 <= mid
        col++;             // 往右走
      } else {
        row--;             // 往上走
      }
    }

    return count;
  };

  // 二分查找
  let left = matrix[0][0];            // 最小值
  let right = matrix[n - 1][n - 1];   // 最大值

  while (left < right) {
    const mid = left + Math.floor((right - left) / 2);

    if (countLessEqual(mid) < k) {
      left = mid + 1;   // 答案比 mid 大
    } else {
      right = mid;      // 答案可能是 mid 或更小
    }
  }

  return left;  // left == right 时就是答案
}

// 测试
console.log(kthSmallest([[1, 5, 9], [10, 11, 13], [12, 13, 15]], 8));
// 输出: 13
```

##### 六、插值查找和斐波那契查找

```typescript
// ========== 插值查找（Interpolation Search）==========
// 二分查找每次取中点，插值查找根据目标值的大小，按比例估算位置
// 类比：在字典里找 "apple"，你不会翻到正中间，而是翻到比较靠前的位置
// 前提：数组有序，且元素分布比较均匀
function interpolationSearch(arr: number[], target: number): number {
  let left = 0;
  let right = arr.length - 1;

  while (left <= right && arr[left] <= target && target <= arr[right]) {
    if (left === right) {
      return arr[left] === target ? left : -1;
    }

    // 插值公式：按比例估算位置
    // 如果 target 接近 arr[left]，pos 接近 left
    const pos =
      left + Math.floor(((target - arr[left]) * (right - left)) / (arr[right] - arr[left]));

    if (arr[pos] === target) {
      return pos;
    } else if (arr[pos] < target) {
      left = pos + 1;
    } else {
      right = pos - 1;
    }
  }

  return -1;
}

// 测试
console.log(interpolationSearch([10, 20, 30, 40, 50, 60, 70, 80, 90, 100], 70));  // 输出: 6

// ========== 斐波那契查找（Fibonacci Search）==========
// 用斐波那契数列来分割查找区间，和二分类似但分割点用斐波那契数确定
// 优点：只用加法和减法，不用除法
function fibonacciSearch(arr: number[], target: number): number {
  // 生成斐波那契数，直到大于等于数组长度
  let fib2 = 0;  // F(k-2)
  let fib1 = 1;  // F(k-1)
  let fib = fib2 + fib1;  // F(k)

  while (fib < arr.length) {
    fib2 = fib1;
    fib1 = fib;
    fib = fib2 + fib1;
  }

  // 初始化标记
  let offset = -1;  // 已排除的部分的末尾索引

  while (fib > 1) {
    // 检查 fib2 位置是否在数组范围内
    const i = Math.min(offset + fib2, arr.length - 1);

    if (arr[i] < target) {
      // 目标在右边，排除左边部分
      fib = fib1;
      fib1 = fib2;
      fib2 = fib - fib1;
      offset = i;
    } else if (arr[i] > target) {
      // 目标在左边，排除右边部分
      fib = fib2;
      fib1 = fib1 - fib2;
      fib2 = fib - fib1;
    } else {
      return i;  // 找到了！
    }
  }

  // 检查最后一个元素
  if (fib1 && offset + 1 < arr.length && arr[offset + 1] === target) {
    return offset + 1;
  }

  return -1;
}

// 测试
console.log(fibonacciSearch([1, 3, 5, 7, 9, 11, 13, 15, 17, 19], 13));  // 输出: 6
console.log(fibonacciSearch([1, 3, 5, 7, 9, 11, 13, 15, 17, 19], 6));   // 输出: -1
```

### 主题9 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、线性查找

```go
package main

import "fmt"

// ========== 线性查找 ==========
// 从头到尾遍历，找到目标就返回索引，找不到返回 -1
// 时间复杂度：O(n)   不需要数组有序！
func LinearSearch(arr []int, target int) int {
	for i := 0; i < len(arr); i++ {
		if arr[i] == target {
			return i // 找到了，返回索引
		}
	}
	return -1 // 遍历完没找到
}

func testLinearSearch() {
	arr := []int{4, 2, 7, 1, 9, 3, 5}
	fmt.Println(LinearSearch(arr, 7)) // 输出: 2（索引2）
	fmt.Println(LinearSearch(arr, 6)) // 输出: -1（没找到）
}
```

##### 二、二分查找（Binary Search）

```go
package main

import "fmt"

// ========== 1. 迭代法实现 ==========
// 前提：arr 必须是有序数组
// 时间复杂度：O(log n)   空间复杂度：O(1)
func BinarySearch(arr []int, target int) int {
	left := 0            // 左边界
	right := len(arr) - 1 // 右边界

	// 当搜索范围有效时（左边界 <= 右边界）
	for left <= right {
		// 计算中间位置
		// 用 left + (right-left)/2 防止整数溢出
		mid := left + (right-left)/2

		if arr[mid] == target {
			return mid // 找到了！
		} else if arr[mid] < target {
			left = mid + 1 // 目标在右半边，缩小左边界
		} else {
			right = mid - 1 // 目标在左半边，缩小右边界
		}
	}

	return -1 // 没找到
}

func testBinarySearch() {
	arr := []int{1, 3, 5, 7, 9, 11, 13, 15, 17, 19}
	fmt.Println(BinarySearch(arr, 7))  // 输出: 3
	fmt.Println(BinarySearch(arr, 1))  // 输出: 0
	fmt.Println(BinarySearch(arr, 19)) // 输出: 9
	fmt.Println(BinarySearch(arr, 6))  // 输出: -1
}

// ========== 2. 递归法实现 ==========
func BinarySearchRecursive(arr []int, target, left, right int) int {
	// 基准情形：搜索范围为空
	if left > right {
		return -1
	}

	mid := left + (right-left)/2

	if arr[mid] == target {
		return mid
	} else if arr[mid] < target {
		return BinarySearchRecursive(arr, target, mid+1, right)
	} else {
		return BinarySearchRecursive(arr, target, left, mid-1)
	}
}

// 包装一下方便调用
func BS(arr []int, target int) int {
	return BinarySearchRecursive(arr, target, 0, len(arr)-1)
}

func testBS() {
	arr := []int{1, 3, 5, 7, 9, 11, 13, 15}
	fmt.Println(BS(arr, 7)) // 输出: 3
	fmt.Println(BS(arr, 6)) // 输出: -1
}
```

##### 三、二分查找的三个变体

```go
package main

import "fmt"

// ========== 变体1：查找第一个等于给定值的元素 ==========
// 关键改动：找到 target 时不立即返回，而是继续往左找
func BinarySearchFirst(arr []int, target int) int {
	left := 0
	right := len(arr) - 1
	result := -1 // 记录找到的位置

	for left <= right {
		mid := left + (right-left)/2

		if arr[mid] == target {
			result = mid    // 记录当前位置
			right = mid - 1 // 继续往左找！看有没有更早出现的
		} else if arr[mid] < target {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}

	return result
}

// ========== 变体2：查找最后一个等于给定值的元素 ==========
// 关键改动：找到 target 时不立即返回，而是继续往右找
func BinarySearchLast(arr []int, target int) int {
	left := 0
	right := len(arr) - 1
	result := -1

	for left <= right {
		mid := left + (right-left)/2

		if arr[mid] == target {
			result = mid   // 记录当前位置
			left = mid + 1 // 继续往右找！看有没有更晚出现的
		} else if arr[mid] < target {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}

	return result
}

// ========== 变体3：查找第一个大于等于给定值的元素 ==========
// 也叫下界 lower_bound
func BinarySearchFirstGe(arr []int, target int) int {
	left := 0
	right := len(arr) - 1
	result := len(arr) // 默认值：如果没找到，返回数组长度

	for left <= right {
		mid := left + (right-left)/2

		if arr[mid] >= target {
			result = mid    // 记录当前位置
			right = mid - 1 // 继续往左找
		} else {
			left = mid + 1 // 当前元素太小了，往右找
		}
	}

	return result
}

func testSearchVariants() {
	fmt.Println(BinarySearchFirst([]int{1, 2, 2, 2, 2, 3, 4}, 2)) // 输出: 1
	fmt.Println(BinarySearchLast([]int{1, 2, 2, 2, 2, 3, 4}, 2))  // 输出: 4
	fmt.Println(BinarySearchFirstGe([]int{1, 3, 5, 7, 9}, 4))     // 输出: 2
	fmt.Println(BinarySearchFirstGe([]int{1, 3, 5, 7, 9}, 10))    // 输出: 5
}
```

##### 四、二分查找的应用

```go
package main

import "fmt"

// ========== 1. 在旋转数组中查找（LeetCode 33）==========
// 旋转数组的特点：存在一个"断点"，断点左边都 >= 第一个元素，断点右边都 < 第一个元素
func SearchRotated(nums []int, target int) int {
	left, right := 0, len(nums)-1

	for left <= right {
		mid := left + (right-left)/2

		if nums[mid] == target {
			return mid
		}

		// 判断 mid 在哪个有序部分
		if nums[mid] >= nums[left] {
			// mid 在左边的有序部分
			if nums[left] <= target && target < nums[mid] {
				right = mid - 1 // target 在左半部分
			} else {
				left = mid + 1 // target 在右半部分
			}
		} else {
			// mid 在右边的有序部分
			if nums[mid] < target && target <= nums[right] {
				left = mid + 1 // target 在右半部分
			} else {
				right = mid - 1 // target 在左半部分
			}
		}
	}

	return -1
}

func testSearchRotated() {
	fmt.Println(SearchRotated([]int{4, 5, 6, 7, 0, 1, 2}, 0)) // 输出: 4
	fmt.Println(SearchRotated([]int{4, 5, 6, 7, 0, 1, 2}, 3)) // 输出: -1
	fmt.Println(SearchRotated([]int{1}, 0))                   // 输出: -1
}

// ========== 2. 求平方根（LeetCode 69）==========
// 思路：答案的范围是 [0, x]，在这个范围内二分查找
// 找最大的 mid，使得 mid * mid <= x
func MySqrt(x int) int {
	if x == 0 {
		return 0
	}

	left, right := 1, x

	for left <= right {
		mid := left + (right-left)/2

		if mid*mid == x {
			return mid // 正好是完全平方数
		} else if mid*mid < x {
			// mid² < x，答案可能是 mid，也可能更大
			left = mid + 1
		} else {
			// mid² > x，答案一定比 mid 小
			right = mid - 1
		}
	}

	// 循环结束时，right 是最后一个满足 right² <= x 的值
	return right
}

// ========== 3. 搜索插入位置（LeetCode 35）==========
// 其实就是找"第一个 >= target 的元素的位置"（lower_bound）
func SearchInsert(nums []int, target int) int {
	left, right := 0, len(nums)-1

	for left <= right {
		mid := left + (right-left)/2

		if nums[mid] == target {
			return mid // 找到了
		} else if nums[mid] < target {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}

	// 没找到时，left 就是应该插入的位置
	return left
}

func testSearchApps() {
	fmt.Println(MySqrt(4))                    // 输出: 2
	fmt.Println(MySqrt(8))                    // 输出: 2
	fmt.Println(MySqrt(16))                   // 输出: 4
	fmt.Println(SearchInsert([]int{1, 3, 5, 6}, 5)) // 输出: 2
	fmt.Println(SearchInsert([]int{1, 3, 5, 6}, 2)) // 输出: 1
	fmt.Println(SearchInsert([]int{1, 3, 5, 6}, 7)) // 输出: 4
}
```

##### 五、在答案空间上二分

```go
package main

import "fmt"

// ========== 1. 珂珂吃香蕉（LeetCode 875）==========
// 思路：
// - 答案 k 的范围是 [1, max(piles)]
// - 如果速度 k 能在 h 小时内吃完，那速度 k+1 也一定能
// - 这种"能/不能"的单调性，就是二分的条件！
func MinEatingSpeed(piles []int, h int) int {
	// 辅助函数：以速度 k 吃完所有香蕉需要多少小时
	hoursNeeded := func(k int) int {
		total := 0
		for _, pile := range piles {
			// 每堆需要 ceil(pile / k) 小时
			// (pile + k - 1) / k 是向上取整的技巧
			total += (pile + k - 1) / k
		}
		return total
	}

	// 找到最大值
	maxPile := piles[0]
	for _, p := range piles {
		if p > maxPile {
			maxPile = p
		}
	}

	// 二分查找答案
	left := 1        // 最慢：每小时吃1根
	right := maxPile // 最快：每小时吃完最大的一堆
	ans := right

	for left <= right {
		mid := (left + right) / 2

		if hoursNeeded(mid) <= h {
			ans = mid    // 这个速度可以，但试试能不能更慢
			right = mid - 1
		} else {
			left = mid + 1 // 太慢了，需要加快速度
		}
	}

	return ans
}

// ========== 2. 有序矩阵中第K小的元素 ==========
// 思路：
// - 答案范围是 [matrix[0][0], matrix[last][last]]
// - 对于一个候选值 mid，统计矩阵中 <= mid 的元素个数
func KthSmallest(matrix [][]int, k int) int {
	n := len(matrix)

	// 统计矩阵中小于等于 mid 的元素个数
	// 从矩阵的左下角开始，如果当前元素 <= mid，
	// 那这一行左边的都 <= mid，往右走；否则往上走。
	countLessEqual := func(mid int) int {
		count := 0
		row := n - 1 // 从左下角开始
		col := 0

		for row >= 0 && col < n {
			if matrix[row][col] <= mid {
				count += row + 1 // 这一列从0到row都 <= mid
				col++            // 往右走
			} else {
				row-- // 往上走
			}
		}
		return count
	}

	// 二分查找
	left := matrix[0][0]      // 最小值
	right := matrix[n-1][n-1] // 最大值

	for left < right {
		mid := left + (right-left)/2

		if countLessEqual(mid) < k {
			left = mid + 1 // 答案比 mid 大
		} else {
			right = mid // 答案可能是 mid 或更小
		}
	}

	return left // left == right 时就是答案
}

func testAnswerSpace() {
	fmt.Println(MinEatingSpeed([]int{3, 6, 7, 11}, 8))      // 输出: 4
	fmt.Println(MinEatingSpeed([]int{30, 11, 23, 4, 20}, 5)) // 输出: 30
	fmt.Println(MinEatingSpeed([]int{30, 11, 23, 4, 20}, 6)) // 输出: 23
	fmt.Println(KthSmallest([][]int{{1, 5, 9}, {10, 11, 13}, {12, 13, 15}}, 8))
	// 输出: 13
}
```

##### 六、插值查找和斐波那契查找

```go
package main

import "fmt"

// ========== 插值查找（Interpolation Search）==========
// 二分查找每次取中点，插值查找根据目标值的大小，按比例估算位置
// 前提：数组有序，且元素分布比较均匀
func InterpolationSearch(arr []int, target int) int {
	left := 0
	right := len(arr) - 1

	for left <= right && arr[left] <= target && target <= arr[right] {
		if left == right {
			if arr[left] == target {
				return left
			}
			return -1
		}

		// 插值公式：按比例估算位置
		pos := left + (target-arr[left])*(right-left)/(arr[right]-arr[left])

		if arr[pos] == target {
			return pos
		} else if arr[pos] < target {
			left = pos + 1
		} else {
			right = pos - 1
		}
	}

	return -1
}

// ========== 斐波那契查找（Fibonacci Search）==========
// 用斐波那契数列来分割查找区间
// 优点：只用加法和减法，不用除法
func FibonacciSearch(arr []int, target int) int {
	// 生成斐波那契数，直到大于等于数组长度
	fib2 := 0    // F(k-2)
	fib1 := 1    // F(k-1)
	fib := fib2 + fib1 // F(k)

	for fib < len(arr) {
		fib2 = fib1
		fib1 = fib
		fib = fib2 + fib1
	}

	// 初始化标记
	offset := -1 // 已排除的部分的末尾索引

	for fib > 1 {
		// 检查 fib2 位置是否在数组范围内
		i := offset + fib2
		if i >= len(arr) {
			i = len(arr) - 1
		}

		if arr[i] < target {
			// 目标在右边，排除左边部分
			fib = fib1
			fib1 = fib2
			fib2 = fib - fib1
			offset = i
		} else if arr[i] > target {
			// 目标在左边，排除右边部分
			fib = fib2
			fib1 = fib1 - fib2
			fib2 = fib - fib1
		} else {
			return i // 找到了！
		}
	}

	// 检查最后一个元素
	if fib1 == 1 && offset+1 < len(arr) && arr[offset+1] == target {
		return offset + 1
	}

	return -1
}

func testInterpFib() {
	fmt.Println(InterpolationSearch([]int{10, 20, 30, 40, 50, 60, 70, 80, 90, 100}, 70)) // 输出: 6
	fmt.Println(FibonacciSearch([]int{1, 3, 5, 7, 9, 11, 13, 15, 17, 19}, 13))            // 输出: 6
	fmt.Println(FibonacciSearch([]int{1, 3, 5, 7, 9, 11, 13, 15, 17, 19}, 6))             // 输出: -1
}
```

---

## 第四阶段：中级数据结构

---

### 主题10：哈希表（Hash Table）

#### 10.1 哈希表的概念

##### 用字典查单词的类比

想象你在查一本英汉词典。你不会从第一页开始逐页翻找，而是：

1. **拼音/首字母定位**：你要查 "apple"，直接翻到 A 开头的部分
2. **快速定位**：几秒之内就能找到目标单词

哈希表就是这样一个"智能词典"：

- 你给它一个**键（key）**，比如 `"apple"`
- 它通过一个**哈希函数**，瞬间算出这个键应该存在哪里
- 然后直接去那个位置取出**值（value）**

```
键 "apple"  →  哈希函数计算  →  下标 3  →  直接去数组下标3的位置取值
```

**生活类比**：就像快递柜。你输入取件码（键），系统立刻告诉你几号柜（下标），你直接去那个柜子取件，不需要逐个柜子翻找。

**核心优势**：查找、插入、删除的平均时间复杂度都是 **O(1)**，也就是"一步到位"。

#### 10.2 哈希函数

哈希函数（Hash Function）是哈希表的核心，它的作用是：

> 把任意类型的键（字符串、对象等）映射为数组的一个合法下标（整数）

```python
def simple_hash(key, capacity):
    """
    最简单的哈希函数示例
    将键映射到 [0, capacity-1] 的范围内
    
    参数:
        key: 要映射的键（这里假设是整数或可转为整数的类型）
        capacity: 哈希表的容量（数组长度）
    返回:
        数组下标（0 到 capacity-1 之间的整数）
    """
    # 先把键转为整数（如果是字符串，就用各字符的ASCII码之和）
    if isinstance(key, str):
        hash_value = sum(ord(c) for c in key)  # 各字符ASCII码之和
    else:
        hash_value = int(key)
    
    # 用取模运算确保下标在合法范围内
    return hash_value % capacity

# 演示
print(simple_hash("apple", 10))   # 输出: 5  (97+112+112+108+101=530, 530%10=0)
print(simple_hash("banana", 10))  # 输出: 4  (97+97+110+97+110+97=608, 608%10=8)
print(simple_hash("cat", 10))     # 输出: 1  (99+97+116=312, 312%10=2)
```

**好的哈希函数应该具备的特点**：
- **确定性**：相同的键永远映射到相同的下标
- **均匀分布**：尽量让不同的键均匀分散到各个下标，减少冲突
- **高效计算**：计算速度要快

#### 10.3 哈希冲突

##### 什么是冲突？

不同的键经过哈希函数计算后，可能得到**相同的下标**，这就是**哈希冲突（Collision）**。

```
生活类比：两个不同的快递被分配到了同一个柜子号——这就是冲突。

键 "abc"  →  哈希函数  →  下标 3
键 "bca"  →  哈希函数  →  下标 3   ← 冲突了！
```

冲突是**不可避免**的（除非键的数量不超过数组长度且哈希函数完美），我们只能想办法**处理**冲突。

##### 10.3.1 链地址法（拉链法）

**核心思想**：数组的每个位置挂一条"链表"，所有映射到同一下标的元素都串在这条链表上。

```
数组下标:
  0  →  [key1, val1] → [key4, val4] → None    (两个元素碰巧映射到0)
  1  →  [key2, val2] → None
  2  →  None
  3  →  [key3, val3] → [key5, val5] → [key6, val6] → None  (三个元素映射到3)
  ...
```

**查找过程**：先算下标，再遍历该位置的链表，逐个比较键是否匹配。

```python
class HashNode:
    """哈希表中链表的节点"""
    def __init__(self, key, value):
        self.key = key        # 键
        self.value = value    # 值
        self.next = None      # 指向下一个节点


class HashTableChaining:
    """
    链地址法实现的哈希表
    
    结构示意：
    bucket[0] → Node(k1,v1) → Node(k3,v3) → None
    bucket[1] → Node(k2,v2) → None
    bucket[2] → None
    bucket[3] → Node(k4,v4) → None
    """
    
    def __init__(self, capacity=8):
        """
        初始化哈希表
        
        参数:
            capacity: 哈希表的容量（数组长度），默认为8
        """
        self.capacity = capacity       # 数组长度
        self.size = 0                  # 当前存储的键值对数量
        self.buckets = [None] * capacity  # 创建数组，每个位置初始为空（None表示空链表）
    
    def _hash(self, key):
        """
        哈希函数：将键映射到 [0, capacity-1] 的下标
        """
        if isinstance(key, str):
            hash_value = sum(ord(c) for c in key)
        elif isinstance(key, (int, float)):
            hash_value = hash(key)
        else:
            hash_value = hash(str(key))
        return hash_value % self.capacity
    
    def put(self, key, value):
        """
        插入或更新键值对
        
        流程：
        1. 计算下标
        2. 遍历该位置的链表，如果找到相同的键，就更新值
        3. 如果遍历完没找到，就把新节点插入链表头部
        """
        index = self._hash(key)           # 第一步：算下标
        
        # 第二步：遍历链表，看是否已有这个键
        current = self.buckets[index]
        while current is not None:
            if current.key == key:
                current.value = value     # 键已存在，更新值
                return
            current = current.next
        
        # 第三步：没找到，创建新节点，插入链表头部（头插法）
        new_node = HashNode(key, value)
        new_node.next = self.buckets[index]  # 新节点指向原来的第一个节点
        self.buckets[index] = new_node       # 数组位置指向新节点
        self.size += 1
        
        # 检查是否需要扩容（负载因子超过0.75时扩容）
        if self.size / self.capacity > 0.75:
            self._resize()
    
    def get(self, key):
        """
        根据键查找值
        
        流程：
        1. 计算下标
        2. 遍历链表，找到匹配的键，返回值
        3. 找不到则返回None
        """
        index = self._hash(key)
        current = self.buckets[index]
        while current is not None:
            if current.key == key:
                return current.value
            current = current.next
        return None  # 没找到
    
    def remove(self, key):
        """
        删除指定键的键值对
        
        流程：
        1. 计算下标
        2. 在链表中找到该键，将其从链表中移除
        """
        index = self._hash(key)
        current = self.buckets[index]
        prev = None  # 记录前一个节点
        
        while current is not None:
            if current.key == key:
                # 找到了要删除的节点
                if prev is None:
                    # 要删除的是链表第一个节点
                    self.buckets[index] = current.next
                else:
                    # 要删除的不是第一个节点，跳过它
                    prev.next = current.next
                self.size -= 1
                return True
            prev = current
            current = current.next
        
        return False  # 没找到这个键
    
    def _resize(self):
        """
        扩容：容量翻倍，所有元素重新哈希（rehash）
        """
        old_buckets = self.buckets
        self.capacity *= 2
        self.buckets = [None] * self.capacity
        self.size = 0
        
        # 把所有旧数据重新插入新的数组
        for head in old_buckets:
            current = head
            while current is not None:
                self.put(current.key, current.value)
                current = current.next
    
    def __str__(self):
        """打印哈希表的内容，方便调试"""
        result = []
        for i in range(self.capacity):
            items = []
            current = self.buckets[i]
            while current is not None:
                items.append(f"{current.key}:{current.value}")
                current = current.next
            if items:
                result.append(f"  bucket[{i}] → " + " → ".join(items))
            else:
                result.append(f"  bucket[{i}] → (空)")
        return "\n".join(result)


# ===== 演示 =====
print("===== 链地址法哈希表示例 =====")
ht = HashTableChaining(capacity=4)

# 插入一些数据
ht.put("apple", 5)
ht.put("banana", 3)
ht.put("cat", 8)
ht.put("dog", 2)
ht.put("elephant", 7)  # 可能与某个键冲突

print(f"\n插入5个元素后的哈希表：")
print(ht)

# 查找
print(f"\n查找 'banana': {ht.get('banana')}")    # 输出: 3
print(f"查找 'fish': {ht.get('fish')}")          # 输出: None

# 更新
ht.put("apple", 10)  # 更新apple的值
print(f"更新后查找 'apple': {ht.get('apple')}")  # 输出: 10

# 删除
ht.remove("banana")
print(f"删除 'banana' 后查找: {ht.get('banana')}")  # 输出: None
```

##### 10.3.2 开放寻址法

**核心思想**：不用链表，所有元素都存在数组里。如果发生冲突，就按某种规则去找下一个空位。

**线性探测（Linear Probing）**：

```
冲突了？往下一个位置找，直到找到空位。

插入键 "abc"，哈希到下标3，但下标3已经被占了：
  → 看下标4，空着吗？空着就放这里！
  → 如果下标4也被占了，看下标5...依此类推

查找时也一样：先算下标，如果不对，逐个往后找，直到找到键或遇到空位。
```

```python
class HashTableOpenAddressing:
    """
    开放寻址法（线性探测）实现的哈希表
    
    冲突解决策略：如果位置被占了，依次往后找空位
    """
    
    EMPTY = object()     # 标记空位（从未被使用）
    DELETED = object()   # 标记删除位（曾被使用，现已删除）
    
    def __init__(self, capacity=8):
        self.capacity = capacity
        self.size = 0
        self.keys = [self.EMPTY] * capacity    # 存键的数组
        self.values = [None] * capacity        # 存值的数组
    
    def _hash(self, key):
        """哈希函数"""
        if isinstance(key, str):
            h = sum(ord(c) for c in key)
        else:
            h = hash(key)
        return h % self.capacity
    
    def _probe(self, key):
        """
        线性探测：找到键应该存放的位置
        
        返回: 键所在的下标，或者第一个可用的空位下标
        """
        index = self._hash(key)
        first_deleted = None  # 记录遇到的第一个删除标记的位置
        
        for _ in range(self.capacity):
            if self.keys[index] is self.EMPTY:
                # 遇到真正的空位，说明键不存在
                # 如果有删除标记，返回删除标记的位置（可以复用）
                return first_deleted if first_deleted is not None else index
            elif self.keys[index] is self.DELETED:
                # 记录第一个删除标记的位置
                if first_deleted is None:
                    first_deleted = index
            elif self.keys[index] == key:
                # 找到了这个键
                return index
            
            # 线性探测：移到下一个位置（循环）
            index = (index + 1) % self.capacity
        
        # 表满了
        return first_deleted if first_deleted is not None else -1
    
    def put(self, key, value):
        """插入或更新键值对"""
        if self.size >= self.capacity * 0.75:
            self._resize()
        
        index = self._probe(key)
        if index == -1:
            self._resize()
            index = self._probe(key)
        
        # 如果是新键（之前不存在），size加1
        if self.keys[index] is self.EMPTY or self.keys[index] is self.DELETED:
            self.size += 1
        
        self.keys[index] = key
        self.values[index] = value
    
    def get(self, key):
        """查找键对应的值"""
        index = self._probe(key)
        if self.keys[index] is self.EMPTY or self.keys[index] is self.DELETED:
            return None
        return self.values[index]
    
    def remove(self, key):
        """删除键值对"""
        index = self._probe(key)
        if self.keys[index] is self.EMPTY or self.keys[index] is self.DELETED:
            return False
        
        self.keys[index] = self.DELETED   # 标记为已删除
        self.values[index] = None
        self.size -= 1
        return True
    
    def _resize(self):
        """扩容并重新哈希"""
        old_keys = self.keys
        old_values = self.values
        self.capacity *= 2
        self.keys = [self.EMPTY] * self.capacity
        self.values = [None] * self.capacity
        self.size = 0
        
        for i in range(len(old_keys)):
            if old_keys[i] is not self.EMPTY and old_keys[i] is not self.DELETED:
                self.put(old_keys[i], old_values[i])


# ===== 演示 =====
print("\n===== 开放寻址法（线性探测）哈希表示例 =====")
ht2 = HashTableOpenAddressing(capacity=8)
ht2.put("apple", 5)
ht2.put("banana", 3)
ht2.put("cat", 8)
print(f"查找 'banana': {ht2.get('banana')}")  # 输出: 3
ht2.remove("banana")
print(f"删除后查找 'banana': {ht2.get('banana')}")  # 输出: None
```

**二次探测（Quadratic Probing）**：

```
线性探测的问题：容易产生"聚集"（很多元素挤在一起）

二次探测的改进：步长不是1, 2, 3, 4...，而是 1², 2², 3², 4²...
即冲突后跳 1 格，再冲突跳 4 格，再冲突跳 9 格...

探测序列: hash(key), hash(key)+1, hash(key)+4, hash(key)+9, hash(key)+16, ...
公式: (hash(key) + i²) % capacity，其中 i = 0, 1, 2, 3, ...
```

#### 10.4 哈希表的Python实现（完整版）

上面已经给出了链地址法的完整实现。下面再给出一个更精简、更Pythonic的版本：

```python
class SimpleHashTable:
    """
    用数组+链表实现的简单哈希表（教学版）
    
    支持操作：
    - put(key, value): 插入或更新键值对
    - get(key): 根据键获取值
    - remove(key): 删除键值对
    """
    
    def __init__(self):
        # 初始容量为16（习惯用2的幂次方，方便后续扩容）
        self._capacity = 16
        # 每个桶是一个列表，存放 (key, value) 元组
        self._buckets = [[] for _ in range(self._capacity)]
        self._size = 0
    
    def _hash(self, key):
        """利用Python内置的hash函数，再对容量取模"""
        return hash(key) % self._capacity
    
    def put(self, key, value):
        """
        插入或更新键值对
        时间复杂度：平均 O(1)，最差 O(n)
        """
        idx = self._hash(key)
        bucket = self._buckets[idx]
        
        # 遍历链表，看键是否已存在
        for i, (k, v) in enumerate(bucket):
            if k == key:
                bucket[i] = (key, value)  # 更新
                return
        
        # 不存在，追加到链表末尾
        bucket.append((key, value))
        self._size += 1
        
        # 负载因子超过阈值，扩容
        if self._size > self._capacity * 0.75:
            self._resize()
    
    def get(self, key):
        """
        根据键获取值
        时间复杂度：平均 O(1)，最差 O(n)
        """
        idx = self._hash(key)
        for k, v in self._buckets[idx]:
            if k == key:
                return v
        return None  # 键不存在
    
    def remove(self, key):
        """
        删除键值对
        时间复杂度：平均 O(1)，最差 O(n)
        """
        idx = self._hash(key)
        bucket = self._buckets[idx]
        for i, (k, v) in enumerate(bucket):
            if k == key:
                bucket.pop(i)  # 从链表中移除
                self._size -= 1
                return True
        return False
    
    def _resize(self):
        """扩容为原来的2倍，重新哈希所有元素"""
        old_buckets = self._buckets
        self._capacity *= 2
        self._buckets = [[] for _ in range(self._capacity)]
        self._size = 0
        
        for bucket in old_buckets:
            for k, v in bucket:
                self.put(k, v)  # 重新插入
    
    def __len__(self):
        return self._size
    
    def __repr__(self):
        items = []
        for bucket in self._buckets:
            for k, v in bucket:
                items.append(f"{k!r}: {v!r}")
        return "{" + ", ".join(items) + "}"


# ===== 完整演示 =====
print("===== 简单哈希表完整演示 =====")
ht = SimpleHashTable()

# 插入
ht.put("name", "Alice")
ht.put("age", 25)
ht.put("city", "Beijing")
print(f"哈希表: {ht}")

# 查找
print(f"name = {ht.get('name')}")    # Alice
print(f"age = {ht.get('age')}")      # 25

# 更新
ht.put("age", 26)
print(f"更新后 age = {ht.get('age')}")  # 26

# 删除
ht.remove("city")
print(f"删除city后: {ht}")

# 数量
print(f"元素个数: {len(ht)}")  # 2
```

#### 10.5 负载因子与扩容/Rehash机制

##### 什么是负载因子？

```
负载因子 = 已存储的元素个数 / 数组容量

比如：数组长度是16，存了12个元素
负载因子 = 12 / 16 = 0.75
```

**负载因子的意义**：
- 负载因子越小 → 数组越空 → 冲突越少 → 查找越快
- 负载因子越大 → 数组越满 → 冲突越多 → 查找越慢（链表越来越长）

##### 什么时候扩容？

通常当负载因子超过 **0.75**（这是Java HashMap、Python dict等的常见阈值）时，就触发扩容。

##### 扩容过程（Rehash）

```
扩容步骤：
1. 创建一个更大的新数组（通常是原来的2倍）
2. 把旧数组中的所有元素，用新的容量重新计算下标（重新哈希）
3. 把元素放入新数组的对应位置

为什么要重新哈希？
因为下标 = hash(key) % capacity
capacity变了，下标也会变！

举例：
  旧容量 = 4
  hash("apple") = 13,  13 % 4 = 1  → 存在下标1
  
  新容量 = 8
  hash("apple") = 13,  13 % 8 = 5  → 现在存在下标5了！
```

```python
# 扩容过程的可视化
print("===== 扩容（Rehash）可视化 =====")

def demo_rehash():
    """演示扩容时元素下标的变化"""
    keys = ["apple", "banana", "cat", "dog", "egg"]
    
    old_cap = 4
    new_cap = 8
    
    print(f"旧容量 = {old_cap}, 新容量 = {new_cap}")
    print("-" * 50)
    print(f"{'键':<12} {'哈希值':<10} {'旧下标(%d)' % old_cap:<12} {'新下标(%d)' % new_cap:<12}")
    print("-" * 50)
    
    for key in keys:
        h = hash(key)
        old_idx = h % old_cap
        new_idx = h % new_cap
        print(f"{key:<12} {h:<10} {old_idx:<12} {new_idx:<12}")

demo_rehash()
```

**扩容的代价**：
- 扩容本身需要 O(n) 的时间（要重新插入所有元素）
- 但扩容是很少发生的（每插入 n/4 个元素才发生一次）
- 所以**均摊**下来，每次插入仍然是 O(1)

#### 10.6 Python中的dict和set

Python内置的 `dict`（字典）和 `set`（集合）底层就是哈希表！

```python
# ===== dict 就是哈希表 =====
# 键必须是可哈希的（不可变类型）
d = {
    "name": "Alice",     # 键 "name" → 值 "Alice"
    "age": 25,           # 键 "age"  → 值 25
    "scores": [90, 85]   # 键 "scores" → 值 [90, 85]
}

# O(1) 查找
print(d["name"])         # Alice

# O(1) 插入/更新
d["city"] = "Shanghai"   # 插入新键值对
d["age"] = 26            # 更新已有键的值

# O(1) 删除
del d["scores"]

# O(1) 判断键是否存在
print("name" in d)       # True

# ===== set 就是只有键没有值的哈希表 =====
s = {1, 2, 3, 4, 5}

# O(1) 判断元素是否存在
print(3 in s)            # True

# O(1) 添加元素
s.add(6)

# O(1) 删除元素
s.remove(3)

# 去重（利用set的哈希表特性）
nums = [1, 2, 2, 3, 3, 3, 4]
unique = list(set(nums))
print(unique)            # [1, 2, 3, 4]（顺序可能不同）
```

**dict的底层实现细节**（Python 3.6+）：
- Python 3.6+ 的 dict 使用了**紧凑哈希表**，既保证了插入顺序，又节省了内存
- 使用两个数组：一个稀疏数组存索引（类似开放寻址），一个密集数组存实际的键值对
- 这种设计在保持 O(1) 查找的同时，还保持了插入顺序

#### 10.7 哈希表的典型应用

##### 应用1：O(1)查找

```python
# 用哈希表实现电话簿
phonebook = {}
phonebook["Alice"] = "138-0001"
phonebook["Bob"] = "139-0002"
phonebook["Charlie"] = "137-0003"

# 查找是 O(1) 的！
name = "Bob"
if name in phonebook:
    print(f"{name} 的电话: {phonebook[name]}")
```

##### 应用2：去重

```python
# 用set去重
def remove_duplicates(lst):
    """利用set去除列表中的重复元素"""
    seen = set()
    result = []
    for item in lst:
        if item not in seen:
            seen.add(item)
            result.append(item)
    return result

nums = [3, 1, 2, 3, 1, 4, 2, 5]
print(remove_duplicates(nums))  # [3, 1, 2, 4, 5]
```

##### 应用3：计数统计

```python
from collections import Counter

# Counter 是Python标准库提供的计数工具，底层就是哈希表
words = ["apple", "banana", "apple", "cat", "banana", "apple"]

counter = Counter(words)
print(counter)                    # Counter({'apple': 3, 'banana': 2, 'cat': 1})
print(counter["apple"])           # 3
print(counter.most_common(2))     # [('apple', 3), ('banana', 2)]

# 手动实现计数
def manual_count(lst):
    """手动统计每个元素出现的次数"""
    counts = {}
    for item in lst:
        counts[item] = counts.get(item, 0) + 1
    return counts

print(manual_count(words))  # {'apple': 3, 'banana': 2, 'cat': 1}
```

#### 10.8 经典例题

##### 例题1：两数之和（LeetCode 1）

> 给定一个整数数组 nums 和一个整数 target，找出数组中和为 target 的两个数的下标。

```python
def twoSum(nums, target):
    """
    两数之和 - 哈希表解法
    
    思路：
    遍历数组，对于每个数 num，我们需要找到 target - num 是否在数组中。
    用哈希表记录 {数值: 下标}，这样查找 complement 就是 O(1)。
    
    时间复杂度：O(n) —— 只需遍历一次数组
    空间复杂度：O(n) —— 哈希表最多存n个元素
    
    类比：你在超市买东西，总价100元，你手里拿了一个30元的东西，
    你需要找一个70元的东西。你一边逛一边记住见过的商品价格。
    """
    num_to_index = {}  # 哈希表：{数值: 下标}
    
    for i, num in enumerate(nums):
        complement = target - num  # 我需要找的"配对"
        
        # 在哈希表中查找 complement
        if complement in num_to_index:
            # 找到了！返回两个下标
            return [num_to_index[complement], i]
        
        # 没找到，把当前数字存入哈希表
        num_to_index[num] = i
    
    return []  # 没找到（题目保证有解，这行不会执行）


# 测试
print("===== 两数之和 =====")
print(twoSum([2, 7, 11, 15], 9))    # [0, 1]  (2+7=9)
print(twoSum([3, 2, 4], 6))         # [1, 2]  (2+4=6)
print(twoSum([3, 3], 6))            # [0, 1]  (3+3=6)
```

##### 例题2：有效的字母异位词（LeetCode 242）

> 给定两个字符串 s 和 t，判断 t 是否是 s 的字母异位词（即两个字符串包含的字符及数量完全相同，只是顺序可能不同）。

```python
def isAnagram(s, t):
    """
    有效的字母异位词 - 哈希表计数法
    
    思路：
    如果两个字符串是字母异位词，那么每个字符出现的次数一定完全相同。
    用哈希表统计每个字符的出现次数，然后比较两个哈希表是否相同。
    
    时间复杂度：O(n)，n为字符串长度
    空间复杂度：O(字符集大小)，最多26个英文字母
    
    类比：两堆水果，如果每种水果的数量都一样，只是摆放顺序不同，
    那这两堆水果就是"异位"的。
    """
    # 长度不同，直接返回False
    if len(s) != len(t):
        return False
    
    # 统计s中每个字符的出现次数
    count_s = {}
    for char in s:
        count_s[char] = count_s.get(char, 0) + 1
    
    # 统计t中每个字符的出现次数
    count_t = {}
    for char in t:
        count_t[char] = count_t.get(char, 0) + 1
    
    # 比较两个计数表是否相同
    return count_s == count_t

    # 更简洁的写法：
    # from collections import Counter
    # return Counter(s) == Counter(t)


def isAnagram_optimized(s, t):
    """优化版：只用一个哈希表"""
    if len(s) != len(t):
        return False
    
    count = {}
    for i in range(len(s)):
        # s中的字符计数+1，t中的字符计数-1
        count[s[i]] = count.get(s[i], 0) + 1
        count[t[i]] = count.get(t[i], 0) - 1
    
    # 如果所有计数都是0，说明是异位词
    return all(v == 0 for v in count.values())


# 测试
print("\n===== 有效的字母异位词 =====")
print(isAnagram("anagram", "nagaram"))  # True
print(isAnagram("rat", "car"))          # False
print(isAnagram_optimized("anagram", "nagaram"))  # True
```

##### 例题3：最长无重复子串（LeetCode 3）

> 给定一个字符串 s，找出其中不含重复字符的最长子串的长度。

```python
def lengthOfLongestSubstring(s):
    """
    最长无重复子串 - 滑动窗口 + 哈希表
    
    思路：
    维护一个"滑动窗口" [left, right]，窗口内的字符都不重复。
    - 用哈希表记录每个字符最近出现的下标
    - 右边界 right 不断右移，扩大窗口
    - 如果遇到重复字符，就把左边界 left 跳到重复字符上次出现位置的下一个
    - 每一步都更新最大长度
    
    时间复杂度：O(n)
    空间复杂度：O(min(n, 字符集大小))
    
    类比：你用一根绳子在晾衣绳上圈出一段，这段里面不能有相同颜色的衣服。
    绳子右端不断往右移，遇到重复颜色就把左端拉到上次该颜色出现的位置之后。
    """
    if not s:
        return 0
    
    char_index = {}  # 哈希表：{字符: 最近出现的下标}
    left = 0         # 窗口左边界
    max_len = 0      # 最长子串长度
    
    for right in range(len(s)):
        char = s[right]
        
        # 如果字符已经在窗口内（即它的上次出现位置 >= left）
        if char in char_index and char_index[char] >= left:
            # 左边界跳到重复字符上次出现位置的下一个
            left = char_index[char] + 1
        
        # 更新字符的最新位置
        char_index[char] = right
        
        # 更新最大长度
        max_len = max(max_len, right - left + 1)
    
    return max_len


# 测试
print("\n===== 最长无重复子串 =====")
print(lengthOfLongestSubstring("abcabcbb"))  # 3 ("abc")
print(lengthOfLongestSubstring("bbbbb"))     # 1 ("b")
print(lengthOfLongestSubstring("pwwkew"))    # 3 ("wke")
print(lengthOfLongestSubstring(""))          # 0
print(lengthOfLongestSubstring("abcdef"))    # 6 ("abcdef")
```

##### 例题4：出现次数超过一半的数字

> 数组中有一个数字出现的次数超过数组长度的一半，请找出这个数字。

```python
def majorityElement(nums):
    """
    出现次数超过一半的数字 - 哈希表计数法
    
    思路：
    用哈希表统计每个数字出现的次数，然后找出现次数 > n/2 的数字。
    
    时间复杂度：O(n)
    空间复杂度：O(n)
    """
    from collections import Counter
    
    counts = Counter(nums)
    half = len(nums) // 2
    
    for num, count in counts.items():
        if count > half:
            return num
    
    return None


def majorityElement_voting(nums):
    """
    摩尔投票法（Boyer-Moore Voting Algorithm）
    
    思路（更巧妙，空间O(1)）：
    想象一场投票，超过一半的人投了同一个人。
    我们维护一个候选人和票数：
    - 遇到相同的人，票数+1
    - 遇到不同的人，票数-1
    - 票数归零时，换候选人
    
    因为目标数字出现次数超过一半，最后剩下的候选人一定是它。
    
    时间复杂度：O(n)
    空间复杂度：O(1)  ← 比哈希表法更优！
    """
    candidate = None  # 当前候选人
    count = 0         # 当前票数
    
    for num in nums:
        if count == 0:
            candidate = num  # 票数归零，换候选人
        
        if num == candidate:
            count += 1   # 同党，加票
        else:
            count -= 1   # 异党，减票
    
    return candidate


# 测试
print("\n===== 出现次数超过一半的数字 =====")
print(majorityElement([1, 2, 3, 2, 2, 2, 5]))    # 2
print(majorityElement([3, 3, 4]))                  # 3
print(majorityElement_voting([1, 2, 3, 2, 2, 2, 5]))  # 2
print(majorityElement_voting([3, 3, 4]))              # 3
```

#### 10.9 好的哈希函数设计简介

```python
"""
好的哈希函数应该具备以下特点：
1. 确定性：相同的输入总是得到相同的输出
2. 均匀性：不同的输入尽量分散到不同的输出（减少冲突）
3. 高效性：计算速度快
4. 雪崩效应：输入的微小变化导致输出的巨大变化

常见的哈希函数设计方法：
"""

# 1. 除法取余法（最简单）
def hash_division(key, m):
    """h(key) = key % m
    关键：m 最好选素数，比如 11, 23, 47...
    选素数可以让分布更均匀
    """
    return key % m

# 2. 乘法哈希
def hash_multiplication(key, m, A=0.6180339887):
    """
    h(key) = floor(m * (key * A mod 1))
    A 取黄金分割率 0.618... 效果较好（Knuth推荐）
    """
    import math
    return math.floor(m * ((key * A) % 1))

# 3. 字符串哈希（多项式滚动哈希）
def hash_string(s, base=31, mod=10**9 + 7):
    """
    把字符串看作一个 base 进制的数：
    hash = s[0]*base^(n-1) + s[1]*base^(n-2) + ... + s[n-1]*base^0
    
    base 选31或37（素数），mod 选一个大素数防止溢出
    
    这就是Java中String.hashCode()的思路
    """
    h = 0
    for char in s:
        h = (h * base + ord(char)) % mod
    return h

# 4. Python内置的hash()函数
# Python使用MurmurHash的变体，对字符串、数字等都有很好的散列效果
print("Python内置hash函数演示：")
print(f"hash('hello') = {hash('hello')}")
print(f"hash(42) = {hash(42)}")
print(f"hash((1,2)) = {hash((1,2))}")  # 元组可哈希
# print(hash([1,2]))  # 列表不可哈希！会报错
```

---

### 主题10 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、简单哈希函数

```typescript
// ========== 简单哈希函数 ==========
// 将键映射到 [0, capacity-1] 的范围内
function simpleHash(key: string | number, capacity: number): number {
    let hashValue: number;
    if (typeof key === "string") {
        // 字符串：取各字符 ASCII 码之和
        hashValue = key.split("").reduce((sum, c) => sum + c.charCodeAt(0), 0);
    } else {
        hashValue = Math.floor(key);
    }
    // 取模运算确保下标在合法范围内
    return hashValue % capacity;
}

// 演示
console.log(simpleHash("apple", 10));   // 输出: 0  (ASCII 和=530, 530%10=0)
console.log(simpleHash("banana", 10));  // 输出: 8  (ASCII 和=608, 608%10=8)
console.log(simpleHash("cat", 10));     // 输出: 2  (ASCII 和=312, 312%10=2)
```

##### 二、链地址法（拉链法）哈希表

```typescript
// ========== 链地址法实现的哈希表 ==========
// 数组的每个位置挂一条链表，冲突的元素串在同一条链表上
// 结构示意：
// bucket[0] → Node(k1,v1) → Node(k3,v3) → null
// bucket[1] → Node(k2,v2) → null

// 辅助哈希函数：把任意可哈希值转为整数
function hashKey(key: unknown): number {
    if (key === null || key === undefined) return 0;
    if (typeof key === "number") return key | 0;
    return String(key).split("").reduce((s, c) => s + c.charCodeAt(0), 0);
}

class HashNode<K, V> {
    key: K;
    value: V;
    next: HashNode<K, V> | null = null;

    constructor(key: K, value: V) {
        this.key = key;
        this.value = value;
    }
}

class HashTableChaining<K, V> {
    private capacity: number;                        // 数组长度
    private size = 0;                                // 当前存储的键值对数量
    private buckets: Array<HashNode<K, V> | null>;   // 数组，每个位置是一条链表的头

    constructor(capacity = 8) {
        this.capacity = capacity;
        this.buckets = new Array<HashNode<K, V> | null>(capacity).fill(null);
    }

    // 哈希函数：将键映射到 [0, capacity-1] 的下标
    private hash(key: K): number {
        let hashValue: number;
        if (typeof key === "string") {
            hashValue = key.split("").reduce((s, c) => s + c.charCodeAt(0), 0);
        } else {
            hashValue = hashKey(key);
        }
        return hashValue % this.capacity;
    }

    // 插入或更新键值对
    put(key: K, value: V): void {
        const index = this.hash(key);

        // 遍历链表，看是否已有这个键
        let current = this.buckets[index];
        while (current !== null) {
            if (current.key === key) {
                current.value = value;   // 键已存在，更新值
                return;
            }
            current = current.next;
        }

        // 没找到，创建新节点，插入链表头部（头插法）
        const newNode = new HashNode(key, value);
        newNode.next = this.buckets[index];
        this.buckets[index] = newNode;
        this.size++;

        // 负载因子超过 0.75 时扩容
        if (this.size / this.capacity > 0.75) {
            this.resize();
        }
    }

    // 根据键查找值
    get(key: K): V | null {
        const index = this.hash(key);
        let current = this.buckets[index];
        while (current !== null) {
            if (current.key === key) {
                return current.value;
            }
            current = current.next;
        }
        return null; // 没找到
    }

    // 删除指定键的键值对
    remove(key: K): boolean {
        const index = this.hash(key);
        let current = this.buckets[index];
        let prev: HashNode<K, V> | null = null;

        while (current !== null) {
            if (current.key === key) {
                if (prev === null) {
                    // 要删除的是链表第一个节点
                    this.buckets[index] = current.next;
                } else {
                    // 跳过当前节点
                    prev.next = current.next;
                }
                this.size--;
                return true;
            }
            prev = current;
            current = current.next;
        }
        return false; // 没找到这个键
    }

    // 扩容：容量翻倍，所有元素重新哈希（rehash）
    private resize(): void {
        const oldBuckets = this.buckets;
        this.capacity *= 2;
        this.buckets = new Array<HashNode<K, V> | null>(this.capacity).fill(null);
        this.size = 0;

        // 把所有旧数据重新插入新的数组
        for (const head of oldBuckets) {
            let current = head;
            while (current !== null) {
                this.put(current.key, current.value);
                current = current.next;
            }
        }
    }

    toString(): string {
        const lines: string[] = [];
        for (let i = 0; i < this.capacity; i++) {
            const items: string[] = [];
            let current = this.buckets[i];
            while (current !== null) {
                items.push(`${String(current.key)}:${current.value}`);
                current = current.next;
            }
            lines.push(items.length ? `  bucket[${i}] → ${items.join(" → ")}` : `  bucket[${i}] → (空)`);
        }
        return lines.join("\n");
    }
}

// ===== 演示 =====
console.log("===== 链地址法哈希表示例 =====");
const ht = new HashTableChaining<string, number>(4);
ht.put("apple", 5);
ht.put("banana", 3);
ht.put("cat", 8);
ht.put("dog", 2);
ht.put("elephant", 7);  // 可能与某个键冲突

console.log("\n插入5个元素后的哈希表：");
console.log(ht.toString());

console.log(`\n查找 'banana': ${ht.get("banana")}`);  // 输出: 3
console.log(`查找 'fish': ${ht.get("fish")}`);        // 输出: null

ht.put("apple", 10);  // 更新 apple 的值
console.log(`更新后查找 'apple': ${ht.get("apple")}`);  // 输出: 10

ht.remove("banana");
console.log(`删除 'banana' 后查找: ${ht.get("banana")}`);  // 输出: null
```

##### 三、开放寻址法（线性探测）哈希表

```typescript
// ========== 开放寻址法（线性探测）实现的哈希表 ==========
// 冲突解决策略：如果位置被占了，依次往后找空位
class HashTableOpenAddressing<K, V> {
    private static readonly EMPTY = Symbol("EMPTY");     // 标记空位（从未被使用）
    private static readonly DELETED = Symbol("DELETED"); // 标记删除位（曾被使用，现已删除）

    private capacity: number;
    private size = 0;
    private keys: Array<K | symbol>;
    private values: Array<V | null>;

    constructor(capacity = 8) {
        this.capacity = capacity;
        this.keys = new Array<K | symbol>(capacity).fill(HashTableOpenAddressing.EMPTY);
        this.values = new Array<V | null>(capacity).fill(null);
    }

    private hash(key: K): number {
        const h = typeof key === "string"
            ? key.split("").reduce((s, c) => s + c.charCodeAt(0), 0)
            : hashKey(key);
        return h % this.capacity;
    }

    // 线性探测：找到键应该存放的位置
    private probe(key: K): number {
        let index = this.hash(key);
        let firstDeleted: number | null = null; // 记录遇到的第一个删除标记的位置

        for (let i = 0; i < this.capacity; i++) {
            if (this.keys[index] === HashTableOpenAddressing.EMPTY) {
                // 遇到真正的空位，说明键不存在；优先复用删除标记的位置
                return firstDeleted !== null ? firstDeleted : index;
            } else if (this.keys[index] === HashTableOpenAddressing.DELETED) {
                if (firstDeleted === null) {
                    firstDeleted = index;
                }
            } else if (this.keys[index] === key) {
                return index; // 找到了这个键
            }
            // 线性探测：移到下一个位置（循环）
            index = (index + 1) % this.capacity;
        }
        // 表满了
        return firstDeleted !== null ? firstDeleted : -1;
    }

    // 插入或更新键值对
    put(key: K, value: V): void {
        if (this.size >= this.capacity * 0.75) {
            this.resize();
        }
        let index = this.probe(key);
        if (index === -1) {
            this.resize();
            index = this.probe(key);
        }
        // 如果是新键，size 加 1
        const slot = this.keys[index];
        if (slot === HashTableOpenAddressing.EMPTY || slot === HashTableOpenAddressing.DELETED) {
            this.size++;
        }
        this.keys[index] = key;
        this.values[index] = value;
    }

    // 查找键对应的值
    get(key: K): V | null {
        const index = this.probe(key);
        const slot = this.keys[index];
        if (slot === HashTableOpenAddressing.EMPTY || slot === HashTableOpenAddressing.DELETED) {
            return null;
        }
        return this.values[index];
    }

    // 删除键值对
    remove(key: K): boolean {
        const index = this.probe(key);
        const slot = this.keys[index];
        if (slot === HashTableOpenAddressing.EMPTY || slot === HashTableOpenAddressing.DELETED) {
            return false;
        }
        this.keys[index] = HashTableOpenAddressing.DELETED; // 标记为已删除
        this.values[index] = null;
        this.size--;
        return true;
    }

    // 扩容并重新哈希
    private resize(): void {
        const oldKeys = this.keys;
        const oldValues = this.values;
        this.capacity *= 2;
        this.keys = new Array<K | symbol>(this.capacity).fill(HashTableOpenAddressing.EMPTY);
        this.values = new Array<V | null>(this.capacity).fill(null);
        this.size = 0;

        for (let i = 0; i < oldKeys.length; i++) {
            const k = oldKeys[i];
            if (typeof k !== "symbol") {  // 跳过 EMPTY / DELETED 占位符
                this.put(k, oldValues[i] as V);
            }
        }
    }
}

// ===== 演示 =====
console.log("\n===== 开放寻址法（线性探测）哈希表示例 =====");
const ht2 = new HashTableOpenAddressing<string, number>(8);
ht2.put("apple", 5);
ht2.put("banana", 3);
ht2.put("cat", 8);
console.log(`查找 'banana': ${ht2.get("banana")}`);  // 输出: 3
ht2.remove("banana");
console.log(`删除后查找 'banana': ${ht2.get("banana")}`);  // 输出: null
```

##### 四、精简版哈希表（数组 + 链表）

```typescript
// ========== 简单哈希表（教学版） ==========
// 用数组 + 链表实现，每个桶是一个数组，存放 (key, value) 元组
class SimpleHashTable<K, V> {
    private capacity = 16;                     // 初始容量
    private buckets: Array<Array<[K, V]>>;     // 每个桶是一个列表
    private size = 0;

    constructor() {
        this.buckets = Array.from({ length: this.capacity }, () => []);
    }

    // 利用 JS 的 hash 思路（字符串转数值），再对容量取模
    private hash(key: K): number {
        return hashKey(key) % this.capacity;
    }

    // 插入或更新键值对，平均 O(1)，最差 O(n)
    put(key: K, value: V): void {
        const idx = this.hash(key);
        const bucket = this.buckets[idx];

        // 遍历链表，看键是否已存在
        for (let i = 0; i < bucket.length; i++) {
            if (bucket[i][0] === key) {
                bucket[i] = [key, value]; // 更新
                return;
            }
        }
        // 不存在，追加到链表末尾
        bucket.push([key, value]);
        this.size++;

        // 负载因子超过阈值，扩容
        if (this.size > this.capacity * 0.75) {
            this.resize();
        }
    }

    // 根据键获取值，平均 O(1)，最差 O(n)
    get(key: K): V | null {
        const idx = this.hash(key);
        for (const [k, v] of this.buckets[idx]) {
            if (k === key) return v;
        }
        return null; // 键不存在
    }

    // 删除键值对
    remove(key: K): boolean {
        const idx = this.hash(key);
        const bucket = this.buckets[idx];
        for (let i = 0; i < bucket.length; i++) {
            if (bucket[i][0] === key) {
                bucket.splice(i, 1); // 从链表中移除
                this.size--;
                return true;
            }
        }
        return false;
    }

    // 扩容为原来的 2 倍，重新哈希所有元素
    private resize(): void {
        const oldBuckets = this.buckets;
        this.capacity *= 2;
        this.buckets = Array.from({ length: this.capacity }, () => []);
        this.size = 0;

        for (const bucket of oldBuckets) {
            for (const [k, v] of bucket) {
                this.put(k, v); // 重新插入
            }
        }
    }

    get length(): number {
        return this.size;
    }

    toString(): string {
        const items: string[] = [];
        for (const bucket of this.buckets) {
            for (const [k, v] of bucket) {
                items.push(`${String(k)}: ${String(v)}`);
            }
        }
        return `{ ${items.join(", ")} }`;
    }
}

// ===== 完整演示 =====
console.log("===== 简单哈希表完整演示 =====");
const sht = new SimpleHashTable<string, string | number>();
sht.put("name", "Alice");
sht.put("age", 25);
sht.put("city", "Beijing");
console.log(`哈希表: ${sht.toString()}`);

console.log(`name = ${sht.get("name")}`);  // Alice
console.log(`age = ${sht.get("age")}`);    // 25

sht.put("age", 26);
console.log(`更新后 age = ${sht.get("age")}`);  // 26

sht.remove("city");
console.log(`删除city后: ${sht.toString()}`);
console.log(`元素个数: ${sht.length}`);  // 2
```

##### 五、扩容（Rehash）可视化

```typescript
// ========== 扩容过程的可视化 ==========
// 演示扩容时元素下标的变化：容量变了，下标也会变！
function demoRehash(): void {
    const keys = ["apple", "banana", "cat", "dog", "egg"];
    const oldCap = 4;
    const newCap = 8;

    console.log(`旧容量 = ${oldCap}, 新容量 = ${newCap}`);
    console.log("-".repeat(60));
    console.log(`${"键".padEnd(12)} ${"哈希值".padEnd(10)} ${(`旧下标(%d)`.replace("%d", String(oldCap))).padEnd(12)} ${(`新下标(%d)`.replace("%d", String(newCap))).padEnd(12)}`);
    console.log("-".repeat(60));

    for (const key of keys) {
        const h = hashKey(key);
        const oldIdx = h % oldCap;
        const newIdx = h % newCap;
        console.log(`${key.padEnd(12)} ${h.toString().padEnd(10)} ${oldIdx.toString().padEnd(12)} ${newIdx.toString().padEnd(12)}`);
    }
}

demoRehash();
```

##### 六、典型应用：去重与计数

```typescript
// ========== 应用1：去重 ==========
function removeDuplicates<T>(lst: T[]): T[] {
    const seen = new Set<T>();
    const result: T[] = [];
    for (const item of lst) {
        if (!seen.has(item)) {
            seen.add(item);
            result.push(item);
        }
    }
    return result;
}

const nums1 = [3, 1, 2, 3, 1, 4, 2, 5];
console.log(removeDuplicates(nums1));  // [3, 1, 2, 4, 5]

// ========== 应用2：计数统计 ==========
function manualCount(lst: string[]): Map<string, number> {
    const counts = new Map<string, number>();
    for (const item of lst) {
        counts.set(item, (counts.get(item) ?? 0) + 1);
    }
    return counts;
}

const words = ["apple", "banana", "apple", "cat", "banana", "apple"];
const counts = manualCount(words);
console.log([...counts.entries()]);  // [['apple', 3], ['banana', 2], ['cat', 1]]
```

##### 七、经典例题

```typescript
// ========== 例题1：两数之和（LeetCode 1） ==========
// 用哈希表记录 {数值: 下标}，查找 complement 就是 O(1)
function twoSum(nums: number[], target: number): number[] {
    const numToIndex = new Map<number, number>();

    for (let i = 0; i < nums.length; i++) {
        const complement = target - nums[i]; // 我需要找的"配对"
        if (numToIndex.has(complement)) {
            return [numToIndex.get(complement)!, i];
        }
        numToIndex.set(nums[i], i);
    }
    return []; // 没找到（题目保证有解）
}

console.log("===== 两数之和 =====");
console.log(twoSum([2, 7, 11, 15], 9));  // [0, 1]
console.log(twoSum([3, 2, 4], 6));       // [1, 2]
console.log(twoSum([3, 3], 6));          // [0, 1]

// ========== 例题2：有效的字母异位词（LeetCode 242） ==========
function isAnagram(s: string, t: string): boolean {
    if (s.length !== t.length) return false;

    const count = new Map<string, number>();
    for (let i = 0; i < s.length; i++) {
        // s 中的字符计数 +1，t 中的字符计数 -1
        count.set(s[i], (count.get(s[i]) ?? 0) + 1);
        count.set(t[i], (count.get(t[i]) ?? 0) - 1);
    }
    // 如果所有计数都是 0，说明是异位词
    return [...count.values()].every((v) => v === 0);
}

console.log("\n===== 有效的字母异位词 =====");
console.log(isAnagram("anagram", "nagaram"));  // true
console.log(isAnagram("rat", "car"));          // false

// ========== 例题3：最长无重复子串（LeetCode 3） ==========
// 滑动窗口 + 哈希表：记录每个字符最近出现的下标
function lengthOfLongestSubstring(s: string): number {
    if (!s) return 0;

    const charIndex = new Map<string, number>();
    let left = 0;
    let maxLen = 0;

    for (let right = 0; right < s.length; right++) {
        const char = s[right];

        // 如果字符已经在窗口内（上次出现位置 >= left）
        const prev = charIndex.get(char);
        if (prev !== undefined && prev >= left) {
            left = prev + 1; // 左边界跳到重复字符上次出现位置的下一个
        }
        charIndex.set(char, right);
        maxLen = Math.max(maxLen, right - left + 1);
    }
    return maxLen;
}

console.log("\n===== 最长无重复子串 =====");
console.log(lengthOfLongestSubstring("abcabcbb"));  // 3 ("abc")
console.log(lengthOfLongestSubstring("bbbbb"));     // 1 ("b")
console.log(lengthOfLongestSubstring("pwwkew"));    // 3 ("wke")
console.log(lengthOfLongestSubstring(""));          // 0
console.log(lengthOfLongestSubstring("abcdef"));    // 6 ("abcdef")

// ========== 例题4：出现次数超过一半的数字 ==========
// 摩尔投票法（Boyer-Moore Voting Algorithm），空间 O(1)
function majorityElementVoting(nums: number[]): number | null {
    let candidate: number | null = null;
    let count = 0;

    for (const num of nums) {
        if (count === 0) {
            candidate = num; // 票数归零，换候选人
        }
        count += (num === candidate) ? 1 : -1;
    }
    return candidate;
}

console.log("\n===== 出现次数超过一半的数字 =====");
console.log(majorityElementVoting([1, 2, 3, 2, 2, 2, 5]));  // 2
console.log(majorityElementVoting([3, 3, 4]));              // 3
```

### 主题10 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、简单哈希函数

```go
package main

import "fmt"

// ========== 简单哈希函数 ==========
// 将键映射到 [0, capacity-1] 的范围内
func simpleHash(key string, capacity int) int {
	hashValue := 0
	for _, c := range key {
		hashValue += int(c) // 各字符 ASCII 码之和
	}
	return hashValue % capacity // 取模确保下标合法
}

// 演示
func testSimpleHash() {
	fmt.Println(simpleHash("apple", 10))   // 输出: 0  (ASCII 和=530, 530%10=0)
	fmt.Println(simpleHash("banana", 10))  // 输出: 8  (ASCII 和=608, 608%10=8)
	fmt.Println(simpleHash("cat", 10))     // 输出: 2  (ASCII 和=312, 312%10=2)
}
```

##### 二、链地址法（拉链法）哈希表

```go
package main

import (
	"fmt"
	"strings"
)

// ========== 链地址法实现的哈希表 ==========
// 数组的每个位置挂一条链表，冲突的元素串在同一条链表上
// 结构示意：
// bucket[0] → Node(k1,v1) → Node(k3,v3) → nil
// bucket[1] → Node(k2,v2) → nil

type HashNode struct {
	key   string
	value int
	next  *HashNode
}

type HashTableChaining struct {
	capacity int            // 数组长度
	size     int            // 当前存储的键值对数量
	buckets  []*HashNode    // 数组，每个位置是一条链表的头
}

func NewHashTableChaining(capacity int) *HashTableChaining {
	return &HashTableChaining{
		capacity: capacity,
		buckets:  make([]*HashNode, capacity),
	}
}

// 哈希函数：将键映射到 [0, capacity-1] 的下标
func (h *HashTableChaining) hash(key string) int {
	hashValue := 0
	for _, c := range key {
		hashValue += int(c) // 各字符 ASCII 码之和
	}
	return hashValue % h.capacity
}

// 插入或更新键值对
func (h *HashTableChaining) put(key string, value int) {
	index := h.hash(key)

	// 遍历链表，看是否已有这个键
	for cur := h.buckets[index]; cur != nil; cur = cur.next {
		if cur.key == key {
			cur.value = value // 键已存在，更新值
			return
		}
	}

	// 没找到，创建新节点，插入链表头部（头插法）
	newNode := &HashNode{key: key, value: value}
	newNode.next = h.buckets[index]
	h.buckets[index] = newNode
	h.size++

	// 负载因子超过 0.75 时扩容
	if float64(h.size)/float64(h.capacity) > 0.75 {
		h.resize()
	}
}

// 根据键查找值
func (h *HashTableChaining) get(key string) (int, bool) {
	index := h.hash(key)
	for cur := h.buckets[index]; cur != nil; cur = cur.next {
		if cur.key == key {
			return cur.value, true
		}
	}
	return 0, false // 没找到
}

// 删除指定键的键值对
func (h *HashTableChaining) remove(key string) bool {
	index := h.hash(key)
	var prev *HashNode

	for cur := h.buckets[index]; cur != nil; cur = cur.next {
		if cur.key == key {
			if prev == nil {
				// 要删除的是链表第一个节点
				h.buckets[index] = cur.next
			} else {
				// 跳过当前节点
				prev.next = cur.next
			}
			h.size--
			return true
		}
		prev = cur
	}
	return false // 没找到这个键
}

// 扩容：容量翻倍，所有元素重新哈希（rehash）
func (h *HashTableChaining) resize() {
	oldBuckets := h.buckets
	h.capacity *= 2
	h.buckets = make([]*HashNode, h.capacity)
	h.size = 0

	// 把所有旧数据重新插入新的数组
	for _, head := range oldBuckets {
		for cur := head; cur != nil; cur = cur.next {
			h.put(cur.key, cur.value)
		}
	}
}

func (h *HashTableChaining) String() string {
	var sb strings.Builder
	for i := 0; i < h.capacity; i++ {
		items := make([]string, 0)
		for cur := h.buckets[i]; cur != nil; cur = cur.next {
			items = append(items, fmt.Sprintf("%s:%d", cur.key, cur.value))
		}
		if len(items) > 0 {
			sb.WriteString(fmt.Sprintf("  bucket[%d] → %s\n", i, strings.Join(items, " → ")))
		} else {
			sb.WriteString(fmt.Sprintf("  bucket[%d] → (空)\n", i))
		}
	}
	return sb.String()
}

// ===== 演示 =====
func testChaining() {
	fmt.Println("===== 链地址法哈希表示例 =====")
	ht := NewHashTableChaining(4)

	ht.put("apple", 5)
	ht.put("banana", 3)
	ht.put("cat", 8)
	ht.put("dog", 2)
	ht.put("elephant", 7) // 可能与某个键冲突

	fmt.Println("\n插入5个元素后的哈希表：")
	fmt.Print(ht.String())

	if v, ok := ht.get("banana"); ok {
		fmt.Printf("\n查找 'banana': %d\n", v) // 输出: 3
	}
	if _, ok := ht.get("fish"); !ok {
		fmt.Println("查找 'fish': 未找到") // 输出: 未找到
	}

	ht.put("apple", 10) // 更新 apple 的值
	if v, _ := ht.get("apple"); true {
		fmt.Printf("更新后查找 'apple': %d\n", v) // 输出: 10
	}

	ht.remove("banana")
	if _, ok := ht.get("banana"); !ok {
		fmt.Println("删除 'banana' 后查找: 未找到") // 输出: 未找到
	}
}
```

##### 三、开放寻址法（线性探测）哈希表

```go
package main

import "fmt"

// ========== 开放寻址法（线性探测）实现的哈希表 ==========
// 冲突解决策略：如果位置被占了，依次往后找空位

const (
	slotEmpty   = iota // 标记空位（从未被使用）
	slotDeleted        // 标记删除位（曾被使用，现已删除）
)

type slot struct {
	kind  int    // slotEmpty / slotDeleted / 正常使用
	key   string
	value int
}

type HashTableOpenAddressing struct {
	capacity int
	size     int
	slots    []slot
}

func NewHashTableOpenAddressing(capacity int) *HashTableOpenAddressing {
	slots := make([]slot, capacity)
	for i := range slots {
		slots[i].kind = slotEmpty
	}
	return &HashTableOpenAddressing{capacity: capacity, slots: slots}
}

func (h *HashTableOpenAddressing) hash(key string) int {
	hv := 0
	for _, c := range key {
		hv += int(c)
	}
	return hv % h.capacity
}

// 线性探测：找到键应该存放的位置
// 返回: 键所在的下标，或者第一个可用的空位下标；表满返回 -1
func (h *HashTableOpenAddressing) probe(key string) int {
	index := h.hash(key)
	firstDeleted := -1 // 记录遇到的第一个删除标记的位置

	for i := 0; i < h.capacity; i++ {
		if h.slots[index].kind == slotEmpty {
			// 遇到真正的空位，说明键不存在；优先复用删除标记的位置
			if firstDeleted != -1 {
				return firstDeleted
			}
			return index
		} else if h.slots[index].kind == slotDeleted {
			if firstDeleted == -1 {
				firstDeleted = index
			}
		} else if h.slots[index].key == key {
			return index // 找到了这个键
		}
		// 线性探测：移到下一个位置（循环）
		index = (index + 1) % h.capacity
	}
	return firstDeleted // 表满了
}

// 插入或更新键值对
func (h *HashTableOpenAddressing) put(key string, value int) {
	if float64(h.size) >= float64(h.capacity)*0.75 {
		h.resize()
	}
	index := h.probe(key)
	if index == -1 {
		h.resize()
		index = h.probe(key)
	}

	// 如果是新键（之前不存在），size 加 1
	if h.slots[index].kind == slotEmpty || h.slots[index].kind == slotDeleted {
		h.size++
	}
	h.slots[index].kind = 2 // 正常使用
	h.slots[index].key = key
	h.slots[index].value = value
}

// 查找键对应的值
func (h *HashTableOpenAddressing) get(key string) (int, bool) {
	index := h.probe(key)
	if h.slots[index].kind == slotEmpty || h.slots[index].kind == slotDeleted {
		return 0, false
	}
	return h.slots[index].value, true
}

// 删除键值对
func (h *HashTableOpenAddressing) remove(key string) bool {
	index := h.probe(key)
	if h.slots[index].kind == slotEmpty || h.slots[index].kind == slotDeleted {
		return false
	}
	h.slots[index].kind = slotDeleted // 标记为已删除
	h.size--
	return true
}

// 扩容并重新哈希
func (h *HashTableOpenAddressing) resize() {
	oldSlots := h.slots
	h.capacity *= 2
	h.slots = make([]slot, h.capacity)
	for i := range h.slots {
		h.slots[i].kind = slotEmpty
	}
	h.size = 0

	for i := range oldSlots {
		if oldSlots[i].kind == 2 {
			h.put(oldSlots[i].key, oldSlots[i].value)
		}
	}
}

// ===== 演示 =====
func testOpenAddressing() {
	fmt.Println("\n===== 开放寻址法（线性探测）哈希表示例 =====")
	ht2 := NewHashTableOpenAddressing(8)
	ht2.put("apple", 5)
	ht2.put("banana", 3)
	ht2.put("cat", 8)

	if v, ok := ht2.get("banana"); ok {
		fmt.Printf("查找 'banana': %d\n", v) // 输出: 3
	}
	ht2.remove("banana")
	if _, ok := ht2.get("banana"); !ok {
		fmt.Println("删除后查找 'banana': 未找到") // 输出: 未找到
	}
}
```

##### 四、精简版哈希表（数组 + 链表）

```go
package main

import (
	"fmt"
	"strings"
)

// ========== 简单哈希表（教学版） ==========
// 用数组 + 切片（链表）实现，每个桶是一个切片，存放 (key, value) 对
type SimpleHashTable struct {
	capacity int               // 初始容量
	buckets  [][][2]interface{} // 每个桶是一个切片，元素为 [key, value]
	size     int
}

func NewSimpleHashTable() *SimpleHashTable {
	buckets := make([][][2]interface{}, 16)
	return &SimpleHashTable{capacity: 16, buckets: buckets}
}

func (h *SimpleHashTable) hash(key string) int {
	hv := 0
	for _, c := range key {
		hv += int(c)
	}
	return hv % h.capacity
}

// 插入或更新键值对，平均 O(1)，最差 O(n)
func (h *SimpleHashTable) put(key string, value interface{}) {
	idx := h.hash(key)
	bucket := h.buckets[idx]

	// 遍历链表，看键是否已存在
	for i := 0; i < len(bucket); i++ {
		if bucket[i][0] == key {
			bucket[i][1] = value // 更新
			return
		}
	}
	// 不存在，追加到链表末尾
	h.buckets[idx] = append(bucket, [2]interface{}{key, value})
	h.size++

	// 负载因子超过阈值，扩容
	if float64(h.size) > float64(h.capacity)*0.75 {
		h.resize()
	}
}

// 根据键获取值，平均 O(1)，最差 O(n)
func (h *SimpleHashTable) get(key string) (interface{}, bool) {
	idx := h.hash(key)
	for _, pair := range h.buckets[idx] {
		if pair[0] == key {
			return pair[1], true
		}
	}
	return nil, false // 键不存在
}

// 删除键值对
func (h *SimpleHashTable) remove(key string) bool {
	idx := h.hash(key)
	bucket := h.buckets[idx]
	for i := 0; i < len(bucket); i++ {
		if bucket[i][0] == key {
			h.buckets[idx] = append(bucket[:i], bucket[i+1:]...) // 从链表中移除
			h.size--
			return true
		}
	}
	return false
}

// 扩容为原来的 2 倍，重新哈希所有元素
func (h *SimpleHashTable) resize() {
	oldBuckets := h.buckets
	h.capacity *= 2
	h.buckets = make([][][2]interface{}, h.capacity)
	h.size = 0

	for _, bucket := range oldBuckets {
		for _, pair := range bucket {
			h.put(pair[0].(string), pair[1]) // 重新插入
		}
	}
}

func (h *SimpleHashTable) String() string {
	var items []string
	for _, bucket := range h.buckets {
		for _, pair := range bucket {
			items = append(items, fmt.Sprintf("%v: %v", pair[0], pair[1]))
		}
	}
	return "{ " + strings.Join(items, ", ") + " }"
}

// ===== 完整演示 =====
func testSimple() {
	fmt.Println("===== 简单哈希表完整演示 =====")
	sht := NewSimpleHashTable()
	sht.put("name", "Alice")
	sht.put("age", 25)
	sht.put("city", "Beijing")
	fmt.Printf("哈希表: %s\n", sht.String())

	if v, ok := sht.get("name"); ok {
		fmt.Printf("name = %v\n", v) // Alice
	}
	if v, ok := sht.get("age"); ok {
		fmt.Printf("age = %v\n", v) // 25
	}

	sht.put("age", 26)
	if v, _ := sht.get("age"); true {
		fmt.Printf("更新后 age = %v\n", v) // 26
	}

	sht.remove("city")
	fmt.Printf("删除city后: %s\n", sht.String())
	fmt.Printf("元素个数: %d\n", sht.size) // 2
}
```

##### 五、经典例题

```go
package main

import "fmt"

// ========== 例题1：两数之和（LeetCode 1） ==========
// 用哈希表记录 {数值: 下标}，查找 complement 就是 O(1)
func twoSum(nums []int, target int) []int {
	numToIndex := make(map[int]int)

	for i, num := range nums {
		complement := target - num // 我需要找的"配对"
		if j, ok := numToIndex[complement]; ok {
			return []int{j, i}
		}
		numToIndex[num] = i
	}
	return []int{} // 没找到（题目保证有解）
}

// ========== 例题2：有效的字母异位词（LeetCode 242） ==========
func isAnagram(s, t string) bool {
	if len(s) != len(t) {
		return false
	}
	count := make(map[byte]int)
	for i := 0; i < len(s); i++ {
		// s 中的字符计数 +1，t 中的字符计数 -1
		count[s[i]]++
		count[t[i]]--
	}
	// 如果所有计数都是 0，说明是异位词
	for _, v := range count {
		if v != 0 {
			return false
		}
	}
	return true
}

// ========== 例题3：最长无重复子串（LeetCode 3） ==========
// 滑动窗口 + 哈希表：记录每个字符最近出现的下标
func lengthOfLongestSubstring(s string) int {
	if len(s) == 0 {
		return 0
	}
	charIndex := make(map[byte]int)
	left, maxLen := 0, 0

	for right := 0; right < len(s); right++ {
		char := s[right]
		// 如果字符已经在窗口内（上次出现位置 >= left）
		if prev, ok := charIndex[char]; ok && prev >= left {
			left = prev + 1 // 左边界跳到重复字符上次出现位置的下一个
		}
		charIndex[char] = right
		if right-left+1 > maxLen {
			maxLen = right - left + 1
		}
	}
	return maxLen
}

// ========== 例题4：出现次数超过一半的数字（摩尔投票法） ==========
func majorityElementVoting(nums []int) int {
	candidate, count := 0, 0

	for _, num := range nums {
		if count == 0 {
			candidate = num // 票数归零，换候选人
		}
		if num == candidate {
			count++ // 同党，加票
		} else {
			count-- // 异党，减票
		}
	}
	return candidate
}

// ===== 汇总测试 =====
func testHashProblems() {
	fmt.Println("===== 两数之和 =====")
	fmt.Println(twoSum([]int{2, 7, 11, 15}, 9))  // [0 1]
	fmt.Println(twoSum([]int{3, 2, 4}, 6))       // [1 2]
	fmt.Println(twoSum([]int{3, 3}, 6))          // [0 1]

	fmt.Println("\n===== 有效的字母异位词 =====")
	fmt.Println(isAnagram("anagram", "nagaram")) // true
	fmt.Println(isAnagram("rat", "car"))         // false

	fmt.Println("\n===== 最长无重复子串 =====")
	fmt.Println(lengthOfLongestSubstring("abcabcbb")) // 3
	fmt.Println(lengthOfLongestSubstring("bbbbb"))    // 1
	fmt.Println(lengthOfLongestSubstring("pwwkew"))   // 3
	fmt.Println(lengthOfLongestSubstring(""))         // 0
	fmt.Println(lengthOfLongestSubstring("abcdef"))   // 6

	fmt.Println("\n===== 出现次数超过一半的数字 =====")
	fmt.Println(majorityElementVoting([]int{1, 2, 3, 2, 2, 2, 5})) // 2
	fmt.Println(majorityElementVoting([]int{3, 3, 4}))             // 3
}
```

---

### 主题11：树（Tree）

#### 11.1 树的概念

##### 用家族族谱类比

```
                    曾祖父
                   /      \
              祖父          叔祖父
             /    \
          父亲     叔叔
         /    \
       我     妹妹

这就是一个"树"结构！
- 最上面的"曾祖父"是根（root）
- 每个人是一个"节点"
- 父子之间的连线是"边"
- "我"和"妹妹"是兄弟（同一个父亲的孩子）
- "我"没有孩子，所以"我"是叶子
```

**树的特点**：
- 有一个最顶层的"根"
- 每个节点可以有零个或多个"子节点"
- 除了根节点，每个节点都有且只有一个"父节点"
- 没有环路（不会 A→B→C→A 这样绕回去）

#### 11.2 基本术语

```
                    A          ← 第0层（根节点所在层）
                  / | \
                B   C   D      ← 第1层
               / \     |
              E   F    G       ← 第2层
             /
            H                  ← 第3层
```

| 术语 | 含义 | 图中示例 |
|------|------|----------|
| **根节点（Root）** | 树的最顶层节点，没有父节点 | A |
| **叶节点（Leaf）** | 没有子节点的节点 | H, F, G, D |
| **父节点（Parent）** | 一个节点上面的直接节点 | B是E和F的父节点 |
| **子节点（Child）** | 一个节点下面的直接节点 | E和F是B的子节点 |
| **兄弟节点（Sibling）** | 同一个父节点的子节点 | B、C、D互为兄弟 |
| **子树（Subtree）** | 一个节点及其所有后代组成的树 | B及其后代（B,E,F,H）构成A的一棵子树 |
| **深度（Depth）** | 从根到该节点经过的边数 | A的深度=0，E的深度=2 |
| **高度（Height）** | 从该节点到最远叶节点的边数 | A的高度=3，B的高度=2 |
| **层（Level）** | 同一深度的所有节点 | 第2层：E, F, G |

#### 11.3 为什么需要树？

```
数组的优点：查找快（二分查找O(log n)）
数组的缺点：插入/删除慢（需要移动元素O(n)）

链表的优点：插入/删除快（O(1)）
链表的缺点：查找慢（只能从头遍历O(n)）

树（特别是二叉搜索树）：兼顾了两者的优点！
- 查找：O(log n)
- 插入：O(log n)
- 删除：O(log n)

类比：
- 数组像一排固定的储物柜，找东西快但加柜子难
- 链表像寻宝游戏，必须一步步走
- 树像一本有目录的书，通过目录快速翻到对应章节
```

#### 11.4 二叉树

##### 定义

> **二叉树**：每个节点**最多有两个**子节点（左子节点和右子节点）

```
    合法的二叉树          合法的二叉树         合法的二叉树
       A                    A                    A
      / \                  /                   / \
     B   C                B                   B   C
    / \                                     
   D   E                                    （B只有左子节点）
```

##### Python实现二叉树节点类

```python
class TreeNode:
    """
    二叉树节点
    
    类比：每个节点就像一个"分叉口"
    - 存储一个值（val）
    - 左边一条路（left）
    - 右边一条路（right）
    """
    def __init__(self, val=0, left=None, right=None):
        self.val = val     # 节点存储的值
        self.left = left   # 左子节点（默认为空）
        self.right = right # 右子节点（默认为空）


# ===== 构建一棵示例二叉树 =====
#
#         1
#        / \
#       2   3
#      / \   \
#     4   5   6
#        /
#       7

root = TreeNode(1)                    # 根节点
root.left = TreeNode(2)               # 左子节点
root.right = TreeNode(3)              # 右子节点
root.left.left = TreeNode(4)          # 2的左子节点
root.left.right = TreeNode(5)         # 2的右子节点
root.right.right = TreeNode(6)        # 3的右子节点
root.left.right.left = TreeNode(7)    # 5的左子节点

print("二叉树构建完成！")
print(f"根节点的值: {root.val}")                # 1
print(f"根的左子节点: {root.left.val}")          # 2
print(f"根的右子节点: {root.right.val}")         # 3
print(f"2的右子节点(5)的左子节点: {root.left.right.left.val}")  # 7
```

#### 11.5 二叉树的四种遍历（重点！）

##### 11.5.1 前序遍历（根-左-右）

> 访问顺序：先访问根节点，再前序遍历左子树，最后前序遍历右子树

```
         1
        / \
       2   3
      / \   \
     4   5   6
        /
       7

前序遍历结果：1, 2, 4, 5, 7, 3, 6
（先根1，然后左子树2,4,5,7，最后右子树3,6）
```

```python
def preorder_recursive(root):
    """
    前序遍历 - 递归实现
    
    顺序：根 → 左 → 右
    
    递归三步：
    1. 访问当前节点（根）
    2. 递归遍历左子树
    3. 递归遍历右子树
    """
    result = []
    
    def traverse(node):
        if node is None:
            return
        result.append(node.val)    # 第一步：访问根
        traverse(node.left)        # 第二步：遍历左子树
        traverse(node.right)       # 第三步：遍历右子树
    
    traverse(root)
    return result


def preorder_iterative(root):
    """
    前序遍历 - 迭代实现（用栈）
    
    思路：
    用栈模拟递归过程。因为栈是"后进先出"，
    所以要先压右子节点，再压左子节点（这样左子节点先出栈）。
    
    流程：
    1. 根节点入栈
    2. 弹出栈顶，访问它
    3. 先压右子节点，再压左子节点
    4. 重复2-3直到栈为空
    """
    if root is None:
        return []
    
    result = []
    stack = [root]  # 栈：根节点先入栈
    
    while stack:
        node = stack.pop()          # 弹出栈顶
        result.append(node.val)     # 访问当前节点
        
        # 注意：先压右，再压左（因为栈是后进先出，左会先出来）
        if node.right:
            stack.append(node.right)
        if node.left:
            stack.append(node.left)
    
    return result


# 测试
print("\n===== 前序遍历 =====")
print(f"递归: {preorder_recursive(root)}")    # [1, 2, 4, 5, 7, 3, 6]
print(f"迭代: {preorder_iterative(root)}")    # [1, 2, 4, 5, 7, 3, 6]
```

**前序遍历的应用**：
- 复制一棵树（前序遍历可以完整描述树的结构）
- 序列化/反序列化二叉树
- 前缀表达式计算

##### 11.5.2 中序遍历（左-根-右）

> 访问顺序：先中序遍历左子树，再访问根节点，最后中序遍历右子树

```
         1
        / \
       2   3
      / \   \
     4   5   6
        /
       7

中序遍历结果：4, 2, 7, 5, 1, 3, 6
（先左子树4,2,7,5，然后根1，最后右子树3,6）
```

```python
def inorder_recursive(root):
    """
    中序遍历 - 递归实现
    
    顺序：左 → 根 → 右
    """
    result = []
    
    def traverse(node):
        if node is None:
            return
        traverse(node.left)        # 第一步：遍历左子树
        result.append(node.val)    # 第二步：访问根
        traverse(node.right)       # 第三步：遍历右子树
    
    traverse(root)
    return result


def inorder_iterative(root):
    """
    中序遍历 - 迭代实现（用栈）
    
    思路：
    中序遍历比前序复杂一些，因为要先走到最左边。
    
    流程：
    1. 一路向左走，把经过的节点都压入栈
    2. 走到最左边后，弹出栈顶（这就是最左边的节点），访问它
    3. 转向它的右子树，重复1-2
    4. 直到栈为空且当前节点为空
    """
    result = []
    stack = []
    current = root
    
    while current or stack:
        # 一路向左，把经过的节点都压栈
        while current:
            stack.append(current)
            current = current.left
        
        # 弹出栈顶（最左边的节点）
        current = stack.pop()
        result.append(current.val)  # 访问
        
        # 转向右子树
        current = current.right
    
    return result


# 测试
print("\n===== 中序遍历 =====")
print(f"递归: {inorder_recursive(root)}")    # [4, 2, 7, 5, 1, 3, 6]
print(f"迭代: {inorder_iterative(root)}")    # [4, 2, 7, 5, 1, 3, 6]
```

**中序遍历的应用**：
- 对二叉搜索树进行中序遍历，得到**有序序列**（非常重要的性质！）
- 表达式求值（中缀表达式）

##### 11.5.3 后序遍历（左-右-根）

> 访问顺序：先后序遍历左子树，再后序遍历右子树，最后访问根节点

```
         1
        / \
       2   3
      / \   \
     4   5   6
        /
       7

后序遍历结果：4, 7, 5, 2, 6, 3, 1
（先左子树4,7,5,2，然后右子树6,3，最后根1）
```

```python
def postorder_recursive(root):
    """
    后序遍历 - 递归实现
    
    顺序：左 → 右 → 根
    """
    result = []
    
    def traverse(node):
        if node is None:
            return
        traverse(node.left)        # 第一步：遍历左子树
        traverse(node.right)       # 第二步：遍历右子树
        result.append(node.val)    # 第三步：访问根
    
    traverse(root)
    return result


def postorder_iterative(root):
    """
    后序遍历 - 迭代实现（用栈）
    
    思路（巧妙方法）：
    后序遍历是"左-右-根"
    如果我们用类似前序的方法做"根-右-左"，最后把结果反转就是"左-右-根"！
    
    流程：
    1. 用栈做"根-右-左"的遍历（和前序类似，但先压左再压右）
    2. 最后反转结果列表
    """
    if root is None:
        return []
    
    result = []
    stack = [root]
    
    while stack:
        node = stack.pop()
        result.append(node.val)
        
        # 先压左，再压右（出栈顺序：根-右-左）
        if node.left:
            stack.append(node.left)
        if node.right:
            stack.append(node.right)
    
    # 反转：根-右-左 → 左-右-根
    result.reverse()
    return result


# 测试
print("\n===== 后序遍历 =====")
print(f"递归: {postorder_recursive(root)}")    # [4, 7, 5, 2, 6, 3, 1]
print(f"迭代: {postorder_iterative(root)}")    # [4, 7, 5, 2, 6, 3, 1]
```

**后序遍历的应用**：
- 删除整棵树（必须先删除子节点，再删除父节点）
- 计算目录大小（先算子目录，再算父目录）
- 后缀表达式计算

##### 11.5.4 层序遍历（逐层从左到右）

> 按层遍历：第一层从左到右，第二层从左到右，依次类推

```
         1              ← 第1层
        / \
       2   3            ← 第2层
      / \   \
     4   5   6          ← 第3层
        /
       7                ← 第4层

层序遍历结果：[[1], [2, 3], [4, 5, 6], [7]]
```

```python
from collections import deque

def levelOrder(root):
    """
    层序遍历 - 用队列实现BFS（广度优先搜索）
    
    思路：
    用队列（FIFO先进先出）来一层一层地遍历。
    
    流程：
    1. 根节点入队
    2. 取出队列中所有当前层的节点，依次访问
    3. 把这些节点的子节点入队（作为下一层）
    4. 重复2-3直到队列为空
    
    类比：
    想象你在看一栋楼，从顶楼开始，逐层往下看。
    每层从左到右看一遍，看完这层再看下一层。
    """
    if root is None:
        return []
    
    result = []
    queue = deque([root])  # 队列：先放入根节点
    
    while queue:
        level_size = len(queue)  # 当前层的节点数量
        level = []               # 存放当前层的值
        
        # 遍历当前层的所有节点
        for _ in range(level_size):
            node = queue.popleft()     # 从队头取出节点
            level.append(node.val)     # 访问
            
            # 把子节点加入队列（下一层的节点）
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        result.append(level)
    
    return result


def levelOrder_flat(root):
    """层序遍历的扁平版本（不区分层）"""
    if root is None:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        node = queue.popleft()
        result.append(node.val)
        
        if node.left:
            queue.append(node.left)
        if node.right:
            queue.append(node.right)
    
    return result


# 测试
print("\n===== 层序遍历 =====")
print(f"分层: {levelOrder(root)}")          # [[1], [2, 3], [4, 5, 6], [7]]
print(f"扁平: {levelOrder_flat(root)}")     # [1, 2, 3, 4, 5, 6, 7]
```

**层序遍历的应用**：
- 求树的最小深度/最大深度
- 按层打印树
- 求每层的最值/平均值
- 最短路径问题（BFS天然适合）

##### 遍历总结

```
         1
        / \
       2   3
      / \
     4   5

前序（根-左-右）：1, 2, 4, 5, 3   ← 第一个总是根
中序（左-根-右）：4, 2, 5, 1, 3   ← BST的中序是有序的
后序（左-右-根）：4, 5, 2, 3, 1   ← 最后一个总是根
层序（逐层）：    1, 2, 3, 4, 5   ← 从上到下，从左到右
```

#### 11.6 二叉搜索树（BST）

##### 性质

> **二叉搜索树（Binary Search Tree, BST）**：
> - 左子树中所有节点的值 **<** 根节点的值
> - 右子树中所有节点的值 **>** 根节点的值
> - 左右子树也分别是二叉搜索树

```
    合法的BST               不合法的BST
       8                       8
      / \                     / \
     3   10                  3   10
    / \    \                / \    \
   1   6   14              1   15   14
      / \   /                  ↑
     4   7 13            15>8但在左子树，不合法！

BST的中序遍历结果一定是有序的！
上面合法BST的中序：1, 3, 4, 6, 7, 8, 10, 13, 14  ← 从小到大排列
```

##### BST的查找操作

```python
class BST:
    """二叉搜索树的完整实现"""
    
    def __init__(self):
        self.root = None
    
    def search_recursive(self, node, val):
        """
        查找 - 递归实现
        
        思路：
        - 当前节点的值 == val → 找到了
        - val < 当前节点的值 → 去左子树找
        - val > 当前节点的值 → 去右子树找
        
        类比：在字典中查单词，根据字母顺序决定往前翻还是往后翻
        """
        # 基本情况：节点为空或找到目标
        if node is None or node.val == val:
            return node
        
        if val < node.val:
            return self.search_recursive(node.left, val)   # 去左子树找
        else:
            return self.search_recursive(node.right, val)  # 去右子树找
    
    def search_iterative(self, root, val):
        """
        查找 - 迭代实现
        
        思路：从根节点开始，不断往下走，直到找到或走到空
        """
        current = root
        
        while current is not None:
            if val == current.val:
                return current       # 找到了
            elif val < current.val:
                current = current.left   # 去左边
            else:
                current = current.right  # 去右边
        
        return None  # 没找到
```

##### BST的插入操作

```python
    def insert(self, root, val):
        """
        插入 - 递归实现
        
        思路：
        1. 如果树为空，创建新节点作为根
        2. val < 当前节点 → 插入左子树
        3. val > 当前节点 → 插入右子树
        4. val == 当前节点 → 不插入（BST通常不允许重复值）
        
        类比：在 sorted 列表中插入一个数，
        你只需要不断比较大小，找到合适的位置放进去
        """
        # 空树：创建新节点
        if root is None:
            return TreeNode(val)
        
        if val < root.val:
            root.left = self.insert(root.left, val)    # 插入左子树
        elif val > root.val:
            root.right = self.insert(root.right, val)  # 插入右子树
        # val == root.val 时不做任何操作（不插入重复值）
        
        return root
    
    def insert_iterative(self, root, val):
        """插入 - 迭代实现"""
        new_node = TreeNode(val)
        
        if root is None:
            return new_node
        
        current = root
        while True:
            if val < current.val:
                if current.left is None:
                    current.left = new_node  # 找到空位，插入
                    break
                current = current.left
            elif val > current.val:
                if current.right is None:
                    current.right = new_node  # 找到空位，插入
                    break
                current = current.right
            else:
                break  # 值已存在，不插入
        
        return root
```

##### BST的删除操作

```python
    def _find_min(self, node):
        """找到以node为根的子树中的最小节点（最左边的节点）"""
        current = node
        while current.left is not None:
            current = current.left
        return current
    
    def delete(self, root, val):
        """
        删除节点 - 三种情况
        
        情况1：删除的是叶节点（没有子节点）
            → 直接删除（返回None）
            
        情况2：删除的节点只有一个子节点
            → 用子节点替代被删除的节点
            
        情况3：删除的节点有两个子节点
            → 找到右子树中的最小节点（后继节点）
            → 用后继节点的值替代被删除节点的值
            → 然后删除后继节点（后继节点最多只有一个右子节点，属于情况1或2）
        
        类比：
        情况1：拔掉一片没有树枝的叶子
        情况2：一个人只有一个孩子，孩子继承他的位置
        情况3：一个人有两个孩子，找右子树中最小的人来"顶替"
        """
        if root is None:
            return None
        
        # 先找到要删除的节点
        if val < root.val:
            root.left = self.delete(root.left, val)
        elif val > root.val:
            root.right = self.delete(root.right, val)
        else:
            # 找到了要删除的节点
            
            # 情况1：叶节点（无子节点）
            if root.left is None and root.right is None:
                return None
            
            # 情况2：只有一个子节点
            if root.left is None:
                return root.right   # 只有右子节点，用右子节点替代
            if root.right is None:
                return root.left    # 只有左子节点，用左子节点替代
            
            # 情况3：有两个子节点
            # 找到右子树的最小节点（中序后继）
            successor = self._find_min(root.right)
            root.val = successor.val          # 用后继的值替代
            root.right = self.delete(root.right, successor.val)  # 删除后继节点
        
        return root
```

##### BST的完整演示

```python
    def inorder(self, root):
        """中序遍历（BST的中序遍历是有序的）"""
        result = []
        def traverse(node):
            if node is None:
                return
            traverse(node.left)
            result.append(node.val)
            traverse(node.right)
        traverse(root)
        return result


# ===== 完整演示 =====
print("\n===== 二叉搜索树演示 =====")
bst = BST()

# 构建BST
#        8
#       / \
#      3   10
#     / \    \
#    1   6   14
#       / \   /
#      4   7 13

values = [8, 3, 10, 1, 6, 14, 4, 7, 13]
for v in values:
    bst.root = bst.insert(bst.root, v)

print(f"中序遍历（应该有序）: {bst.inorder(bst.root)}")
# [1, 3, 4, 6, 7, 8, 10, 13, 14]

# 查找
found = bst.search_iterative(bst.root, 6)
print(f"查找6: {'找到' if found else '未找到'}")  # 找到

not_found = bst.search_iterative(bst.root, 5)
print(f"查找5: {'找到' if not_found else '未找到'}")  # 未找到

# 删除叶节点（1）
bst.root = bst.delete(bst.root, 1)
print(f"删除1后: {bst.inorder(bst.root)}")  # [3, 4, 6, 7, 8, 10, 13, 14]

# 删除只有一个子节点的节点（10，只有右子节点14）
bst.root = bst.delete(bst.root, 10)
print(f"删除10后: {bst.inorder(bst.root)}")  # [3, 4, 6, 7, 8, 13, 14]

# 删除有两个子节点的节点（3，有左子节点4和右子节点6,7）
bst.root = bst.delete(bst.root, 3)
print(f"删除3后: {bst.inorder(bst.root)}")  # [4, 6, 7, 8, 13, 14]
```

##### BST的复杂度分析

```
                平衡的BST           退化的BST（链表）
                   8                    1
                 / \                     \
                4   12                    2
               /\   / \                    \
              2  6 10  14                   3
                                          / \
                                        ...  退化！

平衡BST：
  - 高度 h = log(n)
  - 查找/插入/删除：O(log n)

退化BST（变成链表）：
  - 高度 h = n
  - 查找/插入/删除：O(n)

平均情况（随机插入）：O(log n)
最坏情况（有序插入）：O(n)

解决方案：使用平衡二叉树（AVL树、红黑树）
  → 自动调整结构，保证 O(log n)
```

#### 11.7 经典例题

##### 例题1：二叉树的最大深度（LeetCode 104）

```python
def maxDepth(root):
    """
    二叉树的最大深度
    
    思路（递归）：
    树的深度 = max(左子树深度, 右子树深度) + 1
    
    类比：你想知道一栋楼有几层，
    你先看左边楼梯有几层，右边楼梯有几层，取大的那个+1
    
    时间复杂度：O(n)，每个节点访问一次
    空间复杂度：O(h)，h为树的高度（递归栈的深度）
    """
    if root is None:
        return 0
    
    left_depth = maxDepth(root.left)    # 左子树的深度
    right_depth = maxDepth(root.right)  # 右子树的深度
    
    return max(left_depth, right_depth) + 1


# BFS版本（层序遍历）
def maxDepth_bfs(root):
    """用层序遍历求深度：层数就是深度"""
    if root is None:
        return 0
    
    from collections import deque
    queue = deque([root])
    depth = 0
    
    while queue:
        depth += 1  # 每处理一层，深度+1
        for _ in range(len(queue)):
            node = queue.popleft()
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
    
    return depth


# 测试
print("\n===== 二叉树的最大深度 =====")
#        1
#       / \
#      2   3
#     / \
#    4   5
tree = TreeNode(1)
tree.left = TreeNode(2)
tree.right = TreeNode(3)
tree.left.left = TreeNode(4)
tree.left.right = TreeNode(5)

print(f"最大深度: {maxDepth(tree)}")       # 3
print(f"BFS深度: {maxDepth_bfs(tree)}")    # 3
```

##### 例题2：翻转二叉树（LeetCode 226）

```python
def invertTree(root):
    """
    翻转二叉树（镜像翻转）
    
    思路：
    对每个节点，交换它的左右子节点。
    递归地对所有节点都这样做。
    
    类比：照镜子，左右互换。
    
    翻转前：        翻转后：
        4              4
       / \            / \
      2   7          7   2
     / \ / \        / \ / \
    1  3 6  9      9  6 3  1
    
    时间复杂度：O(n)
    空间复杂度：O(h)
    """
    if root is None:
        return None
    
    # 交换左右子节点
    root.left, root.right = root.right, root.left
    
    # 递归翻转子树
    invertTree(root.left)
    invertTree(root.right)
    
    return root


# BFS版本
def invertTree_bfs(root):
    """用层序遍历翻转"""
    if root is None:
        return None
    
    from collections import deque
    queue = deque([root])
    
    while queue:
        node = queue.popleft()
        node.left, node.right = node.right, node.left  # 交换
        if node.left:
            queue.append(node.left)
        if node.right:
            queue.append(node.right)
    
    return root


# 测试
print("\n===== 翻转二叉树 =====")
tree = TreeNode(4)
tree.left = TreeNode(2, TreeNode(1), TreeNode(3))
tree.right = TreeNode(7, TreeNode(6), TreeNode(9))

print(f"翻转前中序: {inorder_recursive(tree)}")  # [1, 2, 3, 4, 6, 7, 9]
invertTree(tree)
print(f"翻转后中序: {inorder_recursive(tree)}")  # [9, 7, 6, 4, 3, 2, 1]
```

##### 例题3：对称二叉树（LeetCode 101）

```python
def isSymmetric(root):
    """
    判断二叉树是否对称（镜像对称）
    
    思路（递归）：
    一棵树对称意味着：
    - 左子树的左孩子 == 右子树的右孩子
    - 左子树的右孩子 == 右子树的左孩子
    
    类比：照镜子，左边和右边要完全镜像。
    
    时间复杂度：O(n)
    空间复杂度：O(h)
    """
    if root is None:
        return True
    
    def isMirror(left, right):
        """判断两棵子树是否互为镜像"""
        # 都为空，对称
        if left is None and right is None:
            return True
        # 一个为空一个不为空，不对称
        if left is None or right is None:
            return False
        # 值不同，不对称
        if left.val != right.val:
            return False
        
        # 递归判断：左的左 vs 右的右，左的右 vs 右的左
        return isMirror(left.left, right.right) and isMirror(left.right, right.left)
    
    return isMirror(root.left, root.right)


# 测试
print("\n===== 对称二叉树 =====")
# 对称的树：
#      1
#     / \
#    2   2
#   / \ / \
#  3  4 4  3
tree1 = TreeNode(1)
tree1.left = TreeNode(2, TreeNode(3), TreeNode(4))
tree1.right = TreeNode(2, TreeNode(4), TreeNode(3))
print(f"是否对称: {isSymmetric(tree1)}")  # True

# 不对称的树：
#      1
#     / \
#    2   2
#     \   \
#      3   3
tree2 = TreeNode(1)
tree2.left = TreeNode(2, None, TreeNode(3))
tree2.right = TreeNode(2, None, TreeNode(3))
print(f"是否对称: {isSymmetric(tree2)}")  # False
```

##### 例题4：验证二叉搜索树（LeetCode 98）

```python
def isValidBST(root):
    """
    验证二叉搜索树
    
    思路1（中序遍历法）：
    BST的中序遍历一定是严格递增的序列。
    所以中序遍历后检查是否严格递增即可。
    
    思路2（递归法）：
    每个节点都有一个取值范围 (min_val, max_val)
    根节点：(-inf, +inf)
    左子节点：(父节点的min, 父节点的值)
    右子节点：(父节点的值, 父节点的max)
    """
    # 方法1：中序遍历
    stack = []
    current = root
    prev_val = float('-inf')
    
    while current or stack:
        while current:
            stack.append(current)
            current = current.left
        
        current = stack.pop()
        
        # 检查是否严格递增
        if current.val <= prev_val:
            return False
        prev_val = current.val
        
        current = current.right
    
    return True


def isValidBST_recursive(root):
    """方法2：递归法"""
    def validate(node, low, high):
        if node is None:
            return True
        
        # 当前节点的值必须在 (low, high) 范围内
        if node.val <= low or node.val >= high:
            return False
        
        # 左子树：上界更新为当前节点的值
        # 右子树：下界更新为当前节点的值
        return (validate(node.left, low, node.val) and 
                validate(node.right, node.val, high))
    
    return validate(root, float('-inf'), float('inf'))


# 测试
print("\n===== 验证二叉搜索树 =====")
# 合法BST：
#     2
#    / \
#   1   3
bst1 = TreeNode(2, TreeNode(1), TreeNode(3))
print(f"是否BST: {isValidBST(bst1)}")  # True

# 非法BST：
#     5
#    / \
#   1   4
#      / \
#     3   6
bst2 = TreeNode(5, TreeNode(1), TreeNode(4, TreeNode(3), TreeNode(6)))
print(f"是否BST: {isValidBST(bst2)}")  # False（3<5但在右子树）
```

##### 例题5：二叉树的最近公共祖先（LeetCode 236）

```python
def lowestCommonAncestor(root, p, q):
    """
    二叉树的最近公共祖先（LCA）
    
    思路（递归）：
    从根节点开始搜索：
    1. 如果当前节点是p或q，返回当前节点
    2. 递归在左子树和右子树中查找p和q
    3. 如果p和q分别在左右子树中 → 当前节点就是LCA
    4. 如果都在左子树中 → LCA在左子树
    5. 如果都在右子树中 → LCA在右子树
    
    类比：
    找两个人的最近公共祖先，就像在家族树中找
    一个最近的"共同长辈"。
    
    时间复杂度：O(n)
    空间复杂度：O(h)
    """
    # 基本情况
    if root is None or root == p or root == q:
        return root
    
    # 在左右子树中搜索p和q
    left = lowestCommonAncestor(root.left, p, q)
    right = lowestCommonAncestor(root.right, p, q)
    
    # 如果左右子树各找到一个 → 当前节点就是LCA
    if left and right:
        return root
    
    # 否则，LCA在找到节点的那棵子树中
    return left if left else right


# 测试
print("\n===== 最近公共祖先 =====")
#         3
#        / \
#       5   1
#      / \
#     6   2
#        / \
#       7   4
tree = TreeNode(3)
tree.left = TreeNode(5, TreeNode(6), TreeNode(2, TreeNode(7), TreeNode(4)))
tree.right = TreeNode(1)

p = tree.left           # 节点5
q = tree.right          # 节点1
lca = lowestCommonAncestor(tree, p, q)
print(f"5和1的LCA: {lca.val}")  # 3

p = tree.left           # 节点5
q = tree.left.right.right  # 节点4
lca = lowestCommonAncestor(tree, p, q)
print(f"5和4的LCA: {lca.val}")  # 5
```

##### 例题6：二叉树的序列化与反序列化

```python
class Codec:
    """
    二叉树的序列化与反序列化
    
    序列化：把树变成字符串
    反序列化：把字符串变回树
    
    方法：用前序遍历序列化，用逗号分隔节点值，用"null"表示空节点
    
    示例：
         1
        / \
       2   3
          / \
         4   5
    
    序列化结果："1,2,null,null,3,4,null,null,5,null,null"
    """
    
    def serialize(self, root):
        """
        把二叉树序列化为字符串
        
        用前序遍历：根, 左子树, 右子树
        空节点用 "null" 表示
        """
        result = []
        
        def preorder(node):
            if node is None:
                result.append("null")
                return
            result.append(str(node.val))   # 记录根
            preorder(node.left)            # 序列化左子树
            preorder(node.right)           # 序列化右子树
        
        preorder(root)
        return ",".join(result)
    
    def deserialize(self, data):
        """
        把字符串反序列化为二叉树
        
        按前序遍历的顺序重建
        """
        vals = data.split(",")
        self.index = 0  # 当前读到第几个值
        
        def build():
            val = vals[self.index]
            self.index += 1
            
            if val == "null":
                return None
            
            node = TreeNode(int(val))
            node.left = build()    # 重建左子树
            node.right = build()   # 重建右子树
            return node
        
        return build()


# 测试
print("\n===== 二叉树的序列化与反序列化 =====")
tree = TreeNode(1)
tree.left = TreeNode(2)
tree.right = TreeNode(3, TreeNode(4), TreeNode(5))

codec = Codec()

# 序列化
s = codec.serialize(tree)
print(f"序列化: {s}")  # 1,2,null,null,3,4,null,null,5,null,null

# 反序列化
restored = codec.deserialize(s)
print(f"反序列化后中序遍历: {inorder_recursive(restored)}")  # [2, 1, 4, 3, 5]

# 再次序列化验证
s2 = codec.serialize(restored)
print(f"再次序列化: {s2}")  # 应该和s相同
print(f"两次序列化相同: {s == s2}")  # True
```

---

### 主题11 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、二叉树节点与构建

```typescript
// ========== 二叉树节点类 ==========
// 类比：每个节点就像一个"分叉口"
// - 存储一个值（val）
// - 左边一条路（left）
// - 右边一条路（right）
class TreeNode {
    val: number;
    left: TreeNode | null;
    right: TreeNode | null;

    constructor(val: number, left: TreeNode | null = null, right: TreeNode | null = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

// ===== 构建一棵示例二叉树 =====
//         1
//        / \
//       2   3
//      / \   \
//     4   5   6
//        /
//       7
function buildSampleTree(): TreeNode {
    const root = new TreeNode(1);                  // 根节点
    root.left = new TreeNode(2);                   // 左子节点
    root.right = new TreeNode(3);                  // 右子节点
    root.left.left = new TreeNode(4);              // 2的左子节点
    root.left.right = new TreeNode(5);             // 2的右子节点
    root.right.right = new TreeNode(6);            // 3的右子节点
    root.left.right.left = new TreeNode(7);        // 5的左子节点
    return root;
}

// 测试构建
const sampleRoot = buildSampleTree();
console.log("二叉树构建完成！");
console.log(`根节点的值: ${sampleRoot.val}`);                         // 1
console.log(`根的左子节点: ${sampleRoot.left!.val}`);                 // 2
console.log(`根的右子节点: ${sampleRoot.right!.val}`);                // 3
console.log(`2的右子节点(5)的左子节点: ${sampleRoot.left!.right!.left!.val}`);  // 7
```

##### 二、前序遍历（根-左-右）

```typescript
// ========== 前序遍历 ==========
// 顺序：根 → 左 → 右

// 递归实现
function preorderRecursive(root: TreeNode | null): number[] {
    const result: number[] = [];

    const traverse = (node: TreeNode | null): void => {
        if (node === null) return;
        result.push(node.val);   // 第一步：访问根
        traverse(node.left);     // 第二步：遍历左子树
        traverse(node.right);    // 第三步：遍历右子树
    };

    traverse(root);
    return result;
}

// 迭代实现（用栈）
// 注意：先压右，再压左（因为栈是后进先出，左会先出来）
function preorderIterative(root: TreeNode | null): number[] {
    if (root === null) return [];

    const result: number[] = [];
    const stack: TreeNode[] = [root]; // 栈：根节点先入栈

    while (stack.length > 0) {
        const node = stack.pop()!;        // 弹出栈顶
        result.push(node.val);            // 访问当前节点
        if (node.right) stack.push(node.right); // 先压右
        if (node.left) stack.push(node.left);   // 再压左
    }
    return result;
}

console.log("\n===== 前序遍历 =====");
console.log(`递归: ${preorderRecursive(sampleRoot)}`);    // [1, 2, 4, 5, 7, 3, 6]
console.log(`迭代: ${preorderIterative(sampleRoot)}`);    // [1, 2, 4, 5, 7, 3, 6]
```

##### 三、中序遍历（左-根-右）

```typescript
// ========== 中序遍历 ==========
// 顺序：左 → 根 → 右

// 递归实现
function inorderRecursive(root: TreeNode | null): number[] {
    const result: number[] = [];

    const traverse = (node: TreeNode | null): void => {
        if (node === null) return;
        traverse(node.left);      // 第一步：遍历左子树
        result.push(node.val);    // 第二步：访问根
        traverse(node.right);     // 第三步：遍历右子树
    };

    traverse(root);
    return result;
}

// 迭代实现（用栈）
// 流程：一路向左压栈 → 弹出最左节点访问 → 转向右子树
function inorderIterative(root: TreeNode | null): number[] {
    const result: number[] = [];
    const stack: TreeNode[] = [];
    let current = root;

    while (current !== null || stack.length > 0) {
        // 一路向左，把经过的节点都压栈
        while (current !== null) {
            stack.push(current);
            current = current.left;
        }
        // 弹出栈顶（最左边的节点）
        current = stack.pop()!;
        result.push(current.val);  // 访问
        current = current.right;   // 转向右子树
    }
    return result;
}

console.log("\n===== 中序遍历 =====");
console.log(`递归: ${inorderRecursive(sampleRoot)}`);    // [4, 2, 7, 5, 1, 3, 6]
console.log(`迭代: ${inorderIterative(sampleRoot)}`);    // [4, 2, 7, 5, 1, 3, 6]
```

##### 四、后序遍历（左-右-根）

```typescript
// ========== 后序遍历 ==========
// 顺序：左 → 右 → 根

// 递归实现
function postorderRecursive(root: TreeNode | null): number[] {
    const result: number[] = [];

    const traverse = (node: TreeNode | null): void => {
        if (node === null) return;
        traverse(node.left);      // 第一步：遍历左子树
        traverse(node.right);     // 第二步：遍历右子树
        result.push(node.val);    // 第三步：访问根
    };

    traverse(root);
    return result;
}

// 迭代实现（巧妙方法）
// 用栈做"根-右-左"的遍历（先压左再压右），最后反转结果
function postorderIterative(root: TreeNode | null): number[] {
    if (root === null) return [];

    const result: number[] = [];
    const stack: TreeNode[] = [root];

    while (stack.length > 0) {
        const node = stack.pop()!;
        result.push(node.val);
        if (node.left) stack.push(node.left);   // 先压左
        if (node.right) stack.push(node.right); // 再压右
    }
    // 反转：根-右-左 → 左-右-根
    return result.reverse();
}

console.log("\n===== 后序遍历 =====");
console.log(`递归: ${postorderRecursive(sampleRoot)}`);    // [4, 7, 5, 2, 6, 3, 1]
console.log(`迭代: ${postorderIterative(sampleRoot)}`);    // [4, 7, 5, 2, 6, 3, 1]
```

##### 五、层序遍历（BFS）

```typescript
// ========== 层序遍历 ==========
// 用队列（FIFO先进先出）来一层一层地遍历

// 分层版本：返回 [[第1层], [第2层], ...]
function levelOrder(root: TreeNode | null): number[][] {
    if (root === null) return [];

    const result: number[][] = [];
    const queue: TreeNode[] = [root]; // 队列：先放入根节点

    while (queue.length > 0) {
        const levelSize = queue.length; // 当前层的节点数量
        const level: number[] = [];     // 存放当前层的值

        // 遍历当前层的所有节点
        for (let i = 0; i < levelSize; i++) {
            const node = queue.shift()!;    // 从队头取出节点
            level.push(node.val);           // 访问
            if (node.left) queue.push(node.left);   // 下一层
            if (node.right) queue.push(node.right);
        }
        result.push(level);
    }
    return result;
}

// 扁平版本（不区分层）
function levelOrderFlat(root: TreeNode | null): number[] {
    if (root === null) return [];

    const result: number[] = [];
    const queue: TreeNode[] = [root];

    while (queue.length > 0) {
        const node = queue.shift()!;
        result.push(node.val);
        if (node.left) queue.push(node.left);
        if (node.right) queue.push(node.right);
    }
    return result;
}

console.log("\n===== 层序遍历 =====");
console.log(`分层: ${JSON.stringify(levelOrder(sampleRoot))}`);        // [[1],[2,3],[4,5,6],[7]]
console.log(`扁平: ${levelOrderFlat(sampleRoot)}`);                    // [1, 2, 3, 4, 5, 6, 7]
```

##### 六、二叉搜索树（BST）完整实现

```typescript
// ========== 二叉搜索树（BST） ==========
// 性质：左子树所有节点 < 根 < 右子树所有节点
// BST 的中序遍历结果一定是有序的！
class BST {
    root: TreeNode | null = null;

    // 查找 - 递归实现
    searchRecursive(node: TreeNode | null, val: number): TreeNode | null {
        if (node === null || node.val === val) return node;
        if (val < node.val) {
            return this.searchRecursive(node.left, val);   // 去左子树找
        } else {
            return this.searchRecursive(node.right, val);  // 去右子树找
        }
    }

    // 查找 - 迭代实现
    searchIterative(root: TreeNode | null, val: number): TreeNode | null {
        let current = root;
        while (current !== null) {
            if (val === current.val) return current;       // 找到了
            else if (val < current.val) current = current.left;  // 去左边
            else current = current.right;                        // 去右边
        }
        return null; // 没找到
    }

    // 插入 - 递归实现（BST 通常不允许重复值）
    insert(root: TreeNode | null, val: number): TreeNode {
        if (root === null) return new TreeNode(val);  // 空树：创建新节点

        if (val < root.val) {
            root.left = this.insert(root.left, val);      // 插入左子树
        } else if (val > root.val) {
            root.right = this.insert(root.right, val);    // 插入右子树
        }
        // val === root.val 时不做任何操作
        return root;
    }

    // 插入 - 迭代实现
    insertIterative(root: TreeNode | null, val: number): TreeNode {
        const newNode = new TreeNode(val);
        if (root === null) return newNode;

        let current = root;
        while (true) {
            if (val < current.val) {
                if (current.left === null) { current.left = newNode; break; } // 找到空位
                current = current.left;
            } else if (val > current.val) {
                if (current.right === null) { current.right = newNode; break; } // 找到空位
                current = current.right;
            } else {
                break; // 值已存在，不插入
            }
        }
        return root;
    }

    // 找到以 node 为根的子树中的最小节点（最左边的节点）
    private findMin(node: TreeNode): TreeNode {
        let current = node;
        while (current.left !== null) current = current.left;
        return current;
    }

    // 删除节点 - 三种情况
    delete(root: TreeNode | null, val: number): TreeNode | null {
        if (root === null) return null;

        // 先找到要删除的节点
        if (val < root.val) {
            root.left = this.delete(root.left, val);
        } else if (val > root.val) {
            root.right = this.delete(root.right, val);
        } else {
            // 找到了要删除的节点
            // 情况1：叶节点（无子节点）
            if (root.left === null && root.right === null) return null;

            // 情况2：只有一个子节点
            if (root.left === null) return root.right;
            if (root.right === null) return root.left;

            // 情况3：有两个子节点
            // 找右子树的最小节点（中序后继）来顶替
            const successor = this.findMin(root.right);
            root.val = successor.val;                                   // 用后继的值替代
            root.right = this.delete(root.right, successor.val);        // 删除后继节点
        }
        return root;
    }

    // 中序遍历（BST 的中序遍历是有序的）
    inorder(root: TreeNode | null): number[] {
        const result: number[] = [];
        const traverse = (node: TreeNode | null): void => {
            if (node === null) return;
            traverse(node.left);
            result.push(node.val);
            traverse(node.right);
        };
        traverse(root);
        return result;
    }
}

// ===== 完整演示 =====
console.log("\n===== 二叉搜索树演示 =====");
const bst = new BST();
// 构建 BST：
//        8
//       / \
//      3   10
//     / \    \
//    1   6   14
//       / \   /
//      4   7 13
const values = [8, 3, 10, 1, 6, 14, 4, 7, 13];
for (const v of values) {
    bst.root = bst.insert(bst.root, v);
}
console.log(`中序遍历（应该有序）: ${bst.inorder(bst.root)}`);
// [1, 3, 4, 6, 7, 8, 10, 13, 14]

console.log(`查找6: ${bst.searchIterative(bst.root, 6) ? "找到" : "未找到"}`);    // 找到
console.log(`查找5: ${bst.searchIterative(bst.root, 5) ? "找到" : "未找到"}`);    // 未找到

bst.root = bst.delete(bst.root, 1);    // 删除叶节点（1）
console.log(`删除1后: ${bst.inorder(bst.root)}`);   // [3, 4, 6, 7, 8, 10, 13, 14]

bst.root = bst.delete(bst.root, 10);   // 删除只有一个子节点的节点（10）
console.log(`删除10后: ${bst.inorder(bst.root)}`);  // [3, 4, 6, 7, 8, 13, 14]

bst.root = bst.delete(bst.root, 3);    // 删除有两个子节点的节点（3）
console.log(`删除3后: ${bst.inorder(bst.root)}`);   // [4, 6, 7, 8, 13, 14]
```

##### 七、经典例题

```typescript
// ========== 例题1：二叉树的最大深度（LeetCode 104） ==========
// 树的深度 = max(左子树深度, 右子树深度) + 1
function maxDepth(root: TreeNode | null): number {
    if (root === null) return 0;
    const leftDepth = maxDepth(root.left);     // 左子树的深度
    const rightDepth = maxDepth(root.right);   // 右子树的深度
    return Math.max(leftDepth, rightDepth) + 1;
}

// BFS 版本（层序遍历）：层数就是深度
function maxDepthBfs(root: TreeNode | null): number {
    if (root === null) return 0;
    const queue: TreeNode[] = [root];
    let depth = 0;

    while (queue.length > 0) {
        depth++; // 每处理一层，深度+1
        const levelSize = queue.length;
        for (let i = 0; i < levelSize; i++) {
            const node = queue.shift()!;
            if (node.left) queue.push(node.left);
            if (node.right) queue.push(node.right);
        }
    }
    return depth;
}

console.log("\n===== 二叉树的最大深度 =====");
const depthTree = new TreeNode(1,
    new TreeNode(2, new TreeNode(4), new TreeNode(5)),
    new TreeNode(3));
console.log(`最大深度: ${maxDepth(depthTree)}`);      // 3
console.log(`BFS深度: ${maxDepthBfs(depthTree)}`);    // 3

// ========== 例题2：翻转二叉树（LeetCode 226） ==========
// 对每个节点，交换它的左右子节点
function invertTree(root: TreeNode | null): TreeNode | null {
    if (root === null) return null;
    // 交换左右子节点
    [root.left, root.right] = [root.right, root.left];
    invertTree(root.left);
    invertTree(root.right);
    return root;
}

console.log("\n===== 翻转二叉树 =====");
const invertT = new TreeNode(4,
    new TreeNode(2, new TreeNode(1), new TreeNode(3)),
    new TreeNode(7, new TreeNode(6), new TreeNode(9)));
console.log(`翻转前中序: ${inorderRecursive(invertT)}`);  // [1, 2, 3, 4, 6, 7, 9]
invertTree(invertT);
console.log(`翻转后中序: ${inorderRecursive(invertT)}`);  // [9, 7, 6, 4, 3, 2, 1]

// ========== 例题3：对称二叉树（LeetCode 101） ==========
// 一棵树对称意味着：左的左 == 右的右，左的右 == 右的左
function isSymmetric(root: TreeNode | null): boolean {
    if (root === null) return true;

    const isMirror = (left: TreeNode | null, right: TreeNode | null): boolean => {
        if (left === null && right === null) return true;   // 都为空，对称
        if (left === null || right === null) return false;  // 一个为空，不对称
        if (left.val !== right.val) return false;           // 值不同，不对称
        return isMirror(left.left, right.right) && isMirror(left.right, right.left);
    };

    return isMirror(root.left, root.right);
}

console.log("\n===== 对称二叉树 =====");
//      1
//     / \
//    2   2
//   / \ / \
//  3  4 4  3
const sym1 = new TreeNode(1,
    new TreeNode(2, new TreeNode(3), new TreeNode(4)),
    new TreeNode(2, new TreeNode(4), new TreeNode(3)));
console.log(`是否对称: ${isSymmetric(sym1)}`);  // true

//      1
//     / \
//    2   2
//     \   \
//      3   3
const sym2 = new TreeNode(1,
    new TreeNode(2, null, new TreeNode(3)),
    new TreeNode(2, null, new TreeNode(3)));
console.log(`是否对称: ${isSymmetric(sym2)}`);  // false

// ========== 例题4：验证二叉搜索树（LeetCode 98） ==========
// 方法1：中序遍历一定是严格递增的序列
function isValidBST(root: TreeNode | null): boolean {
    const stack: TreeNode[] = [];
    let current = root;
    let prevVal = -Infinity;

    while (current !== null || stack.length > 0) {
        while (current !== null) {
            stack.push(current);
            current = current.left;
        }
        current = stack.pop()!;
        // 检查是否严格递增
        if (current.val <= prevVal) return false;
        prevVal = current.val;
        current = current.right;
    }
    return true;
}

// 方法2：递归法（每个节点都有取值范围）
function isValidBSTRecursive(root: TreeNode | null): boolean {
    const validate = (node: TreeNode | null, low: number, high: number): boolean => {
        if (node === null) return true;
        // 当前节点的值必须在 (low, high) 范围内
        if (node.val <= low || node.val >= high) return false;
        // 左子树：上界更新为当前节点的值；右子树：下界更新为当前节点的值
        return validate(node.left, low, node.val) && validate(node.right, node.val, high);
    };
    return validate(root, -Infinity, Infinity);
}

console.log("\n===== 验证二叉搜索树 =====");
const okBst = new TreeNode(2, new TreeNode(1), new TreeNode(3));
console.log(`是否BST: ${isValidBST(okBst)}`);  // true
const badBst = new TreeNode(5, new TreeNode(1), new TreeNode(4, new TreeNode(3), new TreeNode(6)));
console.log(`是否BST: ${isValidBST(badBst)}`);  // false

// ========== 例题5：二叉树的最近公共祖先（LeetCode 236） ==========
function lowestCommonAncestor(root: TreeNode | null, p: TreeNode, q: TreeNode): TreeNode | null {
    // 基本情况
    if (root === null || root === p || root === q) return root;

    // 在左右子树中搜索 p 和 q
    const left = lowestCommonAncestor(root.left, p, q);
    const right = lowestCommonAncestor(root.right, p, q);

    // 如果左右子树各找到一个 → 当前节点就是 LCA
    if (left !== null && right !== null) return root;
    // 否则，LCA 在找到节点的那棵子树中
    return left !== null ? left : right;
}

console.log("\n===== 最近公共祖先 =====");
//         3
//        / \
//       5   1
//      / \
//     6   2
//        / \
//       7   4
const lcaTree = new TreeNode(3);
lcaTree.left = new TreeNode(5, new TreeNode(6), new TreeNode(2, new TreeNode(7), new TreeNode(4)));
lcaTree.right = new TreeNode(1);
const p5 = lcaTree.left!;
const q1 = lcaTree.right!;
console.log(`5和1的LCA: ${lowestCommonAncestor(lcaTree, p5, q1)!.val}`);  // 3
const q4 = lcaTree.left!.right!.right!;
console.log(`5和4的LCA: ${lowestCommonAncestor(lcaTree, p5, q4)!.val}`);  // 5

// ========== 例题6：二叉树的序列化与反序列化 ==========
// 方法：用前序遍历序列化，用逗号分隔节点值，用 "null" 表示空节点
class Codec {
    private index = 0;

    // 序列化：把二叉树变成字符串
    serialize(root: TreeNode | null): string {
        const result: string[] = [];

        const preorder = (node: TreeNode | null): void => {
            if (node === null) {
                result.push("null");
                return;
            }
            result.push(String(node.val)); // 记录根
            preorder(node.left);           // 序列化左子树
            preorder(node.right);          // 序列化右子树
        };

        preorder(root);
        return result.join(",");
    }

    // 反序列化：把字符串变回二叉树
    deserialize(data: string): TreeNode | null {
        const vals = data.split(",");
        this.index = 0;

        const build = (): TreeNode | null => {
            const val = vals[this.index];
            this.index++;
            if (val === "null") return null;

            const node = new TreeNode(parseInt(val, 10));
            node.left = build();    // 重建左子树
            node.right = build();   // 重建右子树
            return node;
        };

        return build();
    }
}

console.log("\n===== 二叉树的序列化与反序列化 =====");
const serTree = new TreeNode(1, new TreeNode(2), new TreeNode(3, new TreeNode(4), new TreeNode(5)));
const codec = new Codec();
const s = codec.serialize(serTree);
console.log(`序列化: ${s}`);  // 1,2,null,null,3,4,null,null,5,null,null
const restored = codec.deserialize(s);
console.log(`反序列化后中序遍历: ${inorderRecursive(restored)}`);  // [2, 1, 4, 3, 5]
const s2 = codec.serialize(restored);
console.log(`两次序列化相同: ${s === s2}`);  // true
```

### 主题11 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、二叉树节点与构建

```go
package main

import "fmt"

// ========== 二叉树节点类 ==========
// 类比：每个节点就像一个"分叉口"
// - 存储一个值（val）
// - 左边一条路（Left）
// - 右边一条路（Right）
type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

// 构建一棵示例二叉树：
//         1
//        / \
//       2   3
//      / \   \
//     4   5   6
//        /
//       7
func buildSampleTree() *TreeNode {
	root := &TreeNode{Val: 1}                    // 根节点
	root.Left = &TreeNode{Val: 2}                // 左子节点
	root.Right = &TreeNode{Val: 3}               // 右子节点
	root.Left.Left = &TreeNode{Val: 4}           // 2的左子节点
	root.Left.Right = &TreeNode{Val: 5}          // 2的右子节点
	root.Right.Right = &TreeNode{Val: 6}         // 3的右子节点
	root.Left.Right.Left = &TreeNode{Val: 7}     // 5的左子节点
	return root
}

// 测试构建
func testBuild() {
	root := buildSampleTree()
	fmt.Println("二叉树构建完成！")
	fmt.Printf("根节点的值: %d\n", root.Val)                         // 1
	fmt.Printf("根的左子节点: %d\n", root.Left.Val)                  // 2
	fmt.Printf("根的右子节点: %d\n", root.Right.Val)                 // 3
	fmt.Printf("2的右子节点(5)的左子节点: %d\n", root.Left.Right.Left.Val)  // 7
}
```

##### 二、四种遍历

```go
package main

import "fmt"

// ========== 前序遍历（根-左-右） ==========

// 递归实现
func preorderRecursive(root *TreeNode) []int {
	result := []int{}
	var traverse func(node *TreeNode)
	traverse = func(node *TreeNode) {
		if node == nil {
			return
		}
		result = append(result, node.Val) // 第一步：访问根
		traverse(node.Left)               // 第二步：遍历左子树
		traverse(node.Right)              // 第三步：遍历右子树
	}
	traverse(root)
	return result
}

// 迭代实现（用栈）
// 注意：先压右，再压左（栈是后进先出，左会先出来）
func preorderIterative(root *TreeNode) []int {
	if root == nil {
		return []int{}
	}
	result := []int{}
	stack := []*TreeNode{root} // 栈：根节点先入栈

	for len(stack) > 0 {
		node := stack[len(stack)-1]   // 取栈顶
		stack = stack[:len(stack)-1]  // 弹出
		result = append(result, node.Val)
		if node.Right != nil {
			stack = append(stack, node.Right) // 先压右
		}
		if node.Left != nil {
			stack = append(stack, node.Left)  // 再压左
		}
	}
	return result
}

// ========== 中序遍历（左-根-右） ==========

// 递归实现
func inorderRecursive(root *TreeNode) []int {
	result := []int{}
	var traverse func(node *TreeNode)
	traverse = func(node *TreeNode) {
		if node == nil {
			return
		}
		traverse(node.Left)               // 第一步：遍历左子树
		result = append(result, node.Val) // 第二步：访问根
		traverse(node.Right)              // 第三步：遍历右子树
	}
	traverse(root)
	return result
}

// 迭代实现（用栈）
func inorderIterative(root *TreeNode) []int {
	result := []int{}
	stack := []*TreeNode{}
	current := root

	for current != nil || len(stack) > 0 {
		// 一路向左，把经过的节点都压栈
		for current != nil {
			stack = append(stack, current)
			current = current.Left
		}
		// 弹出栈顶（最左边的节点）
		current = stack[len(stack)-1]
		stack = stack[:len(stack)-1]
		result = append(result, current.Val)
		current = current.Right // 转向右子树
	}
	return result
}

// ========== 后序遍历（左-右-根） ==========

// 递归实现
func postorderRecursive(root *TreeNode) []int {
	result := []int{}
	var traverse func(node *TreeNode)
	traverse = func(node *TreeNode) {
		if node == nil {
			return
		}
		traverse(node.Left)               // 第一步：遍历左子树
		traverse(node.Right)              // 第二步：遍历右子树
		result = append(result, node.Val) // 第三步：访问根
	}
	traverse(root)
	return result
}

// 迭代实现：先做"根-右-左"，最后反转
func postorderIterative(root *TreeNode) []int {
	if root == nil {
		return []int{}
	}
	result := []int{}
	stack := []*TreeNode{root}

	for len(stack) > 0 {
		node := stack[len(stack)-1]
		stack = stack[:len(stack)-1]
		result = append(result, node.Val)
		if node.Left != nil {
			stack = append(stack, node.Left)  // 先压左
		}
		if node.Right != nil {
			stack = append(stack, node.Right) // 再压右
		}
	}
	// 反转：根-右-左 → 左-右-根
	rev := make([]int, len(result))
	for i, v := range result {
		rev[len(result)-1-i] = v
	}
	return rev
}

// ========== 层序遍历（BFS） ==========

// 分层版本：返回 [][]int{第1层, 第2层, ...}
func levelOrder(root *TreeNode) [][]int {
	if root == nil {
		return [][]int{}
	}
	result := [][]int{}
	queue := []*TreeNode{root} // 队列：先放入根节点

	for len(queue) > 0 {
		levelSize := len(queue) // 当前层的节点数量
		level := []int{}        // 存放当前层的值

		for i := 0; i < levelSize; i++ {
			node := queue[0]      // 从队头取出节点
			queue = queue[1:]
			level = append(level, node.Val)
			if node.Left != nil {
				queue = append(queue, node.Left)
			}
			if node.Right != nil {
				queue = append(queue, node.Right)
			}
		}
		result = append(result, level)
	}
	return result
}

// 扁平版本（不区分层）
func levelOrderFlat(root *TreeNode) []int {
	if root == nil {
		return []int{}
	}
	result := []int{}
	queue := []*TreeNode{root}

	for len(queue) > 0 {
		node := queue[0]
		queue = queue[1:]
		result = append(result, node.Val)
		if node.Left != nil {
			queue = append(queue, node.Left)
		}
		if node.Right != nil {
			queue = append(queue, node.Right)
		}
	}
	return result
}

// ===== 遍历演示 =====
func testTraversals() {
	root := buildSampleTree()
	fmt.Println("\n===== 前序遍历 =====")
	fmt.Println(preorderRecursive(root))  // [1 2 4 5 7 3 6]
	fmt.Println(preorderIterative(root))  // [1 2 4 5 7 3 6]
	fmt.Println("\n===== 中序遍历 =====")
	fmt.Println(inorderRecursive(root))   // [4 2 7 5 1 3 6]
	fmt.Println(inorderIterative(root))   // [4 2 7 5 1 3 6]
	fmt.Println("\n===== 后序遍历 =====")
	fmt.Println(postorderRecursive(root)) // [4 7 5 2 6 3 1]
	fmt.Println(postorderIterative(root)) // [4 7 5 2 6 3 1]
	fmt.Println("\n===== 层序遍历 =====")
	fmt.Println(levelOrder(root))         // [[1] [2 3] [4 5 6] [7]]
	fmt.Println(levelOrderFlat(root))     // [1 2 3 4 5 6 7]
}
```

##### 三、二叉搜索树（BST）完整实现

```go
package main

import "fmt"

// ========== 二叉搜索树（BST） ==========
// 性质：左子树所有节点 < 根 < 右子树所有节点
// BST 的中序遍历结果一定是有序的！

// 查找 - 递归实现
func searchRecursive(node *TreeNode, val int) *TreeNode {
	if node == nil || node.Val == val {
		return node
	}
	if val < node.Val {
		return searchRecursive(node.Left, val)  // 去左子树找
	}
	return searchRecursive(node.Right, val)     // 去右子树找
}

// 查找 - 迭代实现
func searchIterative(root *TreeNode, val int) *TreeNode {
	current := root
	for current != nil {
		if val == current.Val {
			return current // 找到了
		} else if val < current.Val {
			current = current.Left // 去左边
		} else {
			current = current.Right // 去右边
		}
	}
	return nil // 没找到
}

// 插入 - 递归实现（BST 通常不允许重复值）
func insert(root *TreeNode, val int) *TreeNode {
	if root == nil {
		return &TreeNode{Val: val} // 空树：创建新节点
	}
	if val < root.Val {
		root.Left = insert(root.Left, val)     // 插入左子树
	} else if val > root.Val {
		root.Right = insert(root.Right, val)   // 插入右子树
	}
	return root // val == root.Val 时不插入
}

// 插入 - 迭代实现
func insertIterative(root *TreeNode, val int) *TreeNode {
	newNode := &TreeNode{Val: val}
	if root == nil {
		return newNode
	}
	current := root
	for {
		if val < current.Val {
			if current.Left == nil {
				current.Left = newNode // 找到空位，插入
				break
			}
			current = current.Left
		} else if val > current.Val {
			if current.Right == nil {
				current.Right = newNode // 找到空位，插入
				break
			}
			current = current.Right
		} else {
			break // 值已存在，不插入
		}
	}
	return root
}

// 找到以 node 为根的子树中的最小节点（最左边的节点）
func findMin(node *TreeNode) *TreeNode {
	current := node
	for current.Left != nil {
		current = current.Left
	}
	return current
}

// 删除节点 - 三种情况
func deleteNode(root *TreeNode, val int) *TreeNode {
	if root == nil {
		return nil
	}
	// 先找到要删除的节点
	if val < root.Val {
		root.Left = deleteNode(root.Left, val)
	} else if val > root.Val {
		root.Right = deleteNode(root.Right, val)
	} else {
		// 找到了要删除的节点
		// 情况1：叶节点（无子节点）
		if root.Left == nil && root.Right == nil {
			return nil
		}
		// 情况2：只有一个子节点
		if root.Left == nil {
			return root.Right
		}
		if root.Right == nil {
			return root.Left
		}
		// 情况3：有两个子节点
		// 找右子树的最小节点（中序后继）来顶替
		successor := findMin(root.Right)
		root.Val = successor.Val                                // 用后继的值替代
		root.Right = deleteNode(root.Right, successor.Val)      // 删除后继节点
	}
	return root
}

// 中序遍历（BST 的中序遍历是有序的）
func inorder(root *TreeNode) []int {
	result := []int{}
	var traverse func(node *TreeNode)
	traverse = func(node *TreeNode) {
		if node == nil {
			return
		}
		traverse(node.Left)
		result = append(result, node.Val)
		traverse(node.Right)
	}
	traverse(root)
	return result
}

// ===== 完整演示 =====
func testBST() {
	fmt.Println("\n===== 二叉搜索树演示 =====")
	var root *TreeNode
	// 构建 BST：
	//        8
	//       / \
	//      3   10
	//     / \    \
	//    1   6   14
	//       / \   /
	//      4   7 13
	for _, v := range []int{8, 3, 10, 1, 6, 14, 4, 7, 13} {
		root = insert(root, v)
	}
	fmt.Printf("中序遍历（应该有序）: %v\n", inorder(root))
	// [1 3 4 6 7 8 10 13 14]

	if searchIterative(root, 6) != nil {
		fmt.Println("查找6: 找到")
	} else {
		fmt.Println("查找6: 未找到")
	}
	if searchIterative(root, 5) != nil {
		fmt.Println("查找5: 找到")
	} else {
		fmt.Println("查找5: 未找到")
	}

	root = deleteNode(root, 1) // 删除叶节点（1）
	fmt.Printf("删除1后: %v\n", inorder(root))  // [3 4 6 7 8 10 13 14]

	root = deleteNode(root, 10) // 删除只有一个子节点的节点（10）
	fmt.Printf("删除10后: %v\n", inorder(root)) // [3 4 6 7 8 13 14]

	root = deleteNode(root, 3) // 删除有两个子节点的节点（3）
	fmt.Printf("删除3后: %v\n", inorder(root))  // [4 6 7 8 13 14]
}
```

##### 四、经典例题

```go
package main

import "fmt"

// ========== 例题1：二叉树的最大深度（LeetCode 104） ==========
// 树的深度 = max(左子树深度, 右子树深度) + 1
func maxDepth(root *TreeNode) int {
	if root == nil {
		return 0
	}
	leftDepth := maxDepth(root.Left)   // 左子树的深度
	rightDepth := maxDepth(root.Right) // 右子树的深度
	if leftDepth > rightDepth {
		return leftDepth + 1
	}
	return rightDepth + 1
}

// BFS 版本（层序遍历）：层数就是深度
func maxDepthBfs(root *TreeNode) int {
	if root == nil {
		return 0
	}
	queue := []*TreeNode{root}
	depth := 0

	for len(queue) > 0 {
		depth++ // 每处理一层，深度+1
		levelSize := len(queue)
		for i := 0; i < levelSize; i++ {
			node := queue[0]
			queue = queue[1:]
			if node.Left != nil {
				queue = append(queue, node.Left)
			}
			if node.Right != nil {
				queue = append(queue, node.Right)
			}
		}
	}
	return depth
}

// ========== 例题2：翻转二叉树（LeetCode 226） ==========
// 对每个节点，交换它的左右子节点
func invertTree(root *TreeNode) *TreeNode {
	if root == nil {
		return nil
	}
	root.Left, root.Right = root.Right, root.Left // 交换左右子节点
	invertTree(root.Left)
	invertTree(root.Right)
	return root
}

// ========== 例题3：对称二叉树（LeetCode 101） ==========
// 一棵树对称意味着：左的左 == 右的右，左的右 == 右的左
func isSymmetric(root *TreeNode) bool {
	if root == nil {
		return true
	}
	var isMirror func(left, right *TreeNode) bool
	isMirror = func(left, right *TreeNode) bool {
		if left == nil && right == nil {
			return true // 都为空，对称
		}
		if left == nil || right == nil {
			return false // 一个为空，不对称
		}
		if left.Val != right.Val {
			return false // 值不同，不对称
		}
		return isMirror(left.Left, right.Right) && isMirror(left.Right, right.Left)
	}
	return isMirror(root.Left, root.Right)
}

// ========== 例题4：验证二叉搜索树（LeetCode 98） ==========
// 方法1：中序遍历一定是严格递增的序列
func isValidBST(root *TreeNode) bool {
	stack := []*TreeNode{}
	current := root
	prevVal := int(^uint(0)>>1) * -1 // 负无穷（用最小整数近似）

	for current != nil || len(stack) > 0 {
		for current != nil {
			stack = append(stack, current)
			current = current.Left
		}
		current = stack[len(stack)-1]
		stack = stack[:len(stack)-1]
		// 检查是否严格递增
		if current.Val <= prevVal {
			return false
		}
		prevVal = current.Val
		current = current.Right
	}
	return true
}

// 方法2：递归法（每个节点都有取值范围）
func isValidBSTRecursive(root *TreeNode) bool {
	const INF = 1 << 60
	var validate func(node *TreeNode, low, high int) bool
	validate = func(node *TreeNode, low, high int) bool {
		if node == nil {
			return true
		}
		// 当前节点的值必须在 (low, high) 范围内
		if node.Val <= low || node.Val >= high {
			return false
		}
		// 左子树：上界更新为当前节点的值；右子树：下界更新为当前节点的值
		return validate(node.Left, low, node.Val) && validate(node.Right, node.Val, high)
	}
	return validate(root, -INF, INF)
}

// ========== 例题5：二叉树的最近公共祖先（LeetCode 236） ==========
func lowestCommonAncestor(root, p, q *TreeNode) *TreeNode {
	// 基本情况
	if root == nil || root == p || root == q {
		return root
	}
	// 在左右子树中搜索 p 和 q
	left := lowestCommonAncestor(root.Left, p, q)
	right := lowestCommonAncestor(root.Right, p, q)

	// 如果左右子树各找到一个 → 当前节点就是 LCA
	if left != nil && right != nil {
		return root
	}
	// 否则，LCA 在找到节点的那棵子树中
	if left != nil {
		return left
	}
	return right
}

// ========== 例题6：二叉树的序列化与反序列化 ==========
// 方法：用前序遍历序列化，用逗号分隔节点值，用 "null" 表示空节点
type Codec struct {
	index int
}

func NewCodec() *Codec {
	return &Codec{}
}

// 序列化：把二叉树变成字符串
func (c *Codec) serialize(root *TreeNode) string {
	result := []string{}
	var preorder func(node *TreeNode)
	preorder = func(node *TreeNode) {
		if node == nil {
			result = append(result, "null")
			return
		}
		result = append(result, fmt.Sprintf("%d", node.Val)) // 记录根
		preorder(node.Left)                                  // 序列化左子树
		preorder(node.Right)                                 // 序列化右子树
	}
	preorder(root)
	return stringsJoin(result, ",")
}

func stringsJoin(parts []string, sep string) string {
	out := ""
	for i, p := range parts {
		if i > 0 {
			out += sep
		}
		out += p
	}
	return out
}

// 反序列化：把字符串变回二叉树
func (c *Codec) deserialize(data string) *TreeNode {
	vals := split(data, ",")
	c.index = 0

	var build func() *TreeNode
	build = func() *TreeNode {
		val := vals[c.index]
		c.index++
		if val == "null" {
			return nil
		}
		node := &TreeNode{Val: atoi(val)}
		node.Left = build()  // 重建左子树
		node.Right = build() // 重建右子树
		return node
	}
	return build()
}

func split(s, sep string) []string {
	var parts []string
	cur := ""
	for _, ch := range s {
		if string(ch) == sep {
			parts = append(parts, cur)
			cur = ""
		} else {
			cur += string(ch)
		}
	}
	parts = append(parts, cur)
	return parts
}

func atoi(s string) int {
	n := 0
	neg := false
	for i, ch := range s {
		if i == 0 && ch == '-' {
			neg = true
			continue
		}
		n = n*10 + int(ch-'0')
	}
	if neg {
		return -n
	}
	return n
}

// ===== 例题测试 =====
func testTreeProblems() {
	fmt.Println("\n===== 二叉树的最大深度 =====")
	depthTree := &TreeNode{Val: 1,
		Left:  &TreeNode{Val: 2, Left: &TreeNode{Val: 4}, Right: &TreeNode{Val: 5}},
		Right: &TreeNode{Val: 3}}
	fmt.Printf("最大深度: %d\n", maxDepth(depthTree))     // 3
	fmt.Printf("BFS深度: %d\n", maxDepthBfs(depthTree))   // 3

	fmt.Println("\n===== 翻转二叉树 =====")
	invertT := &TreeNode{Val: 4,
		Left:  &TreeNode{Val: 2, Left: &TreeNode{Val: 1}, Right: &TreeNode{Val: 3}},
		Right: &TreeNode{Val: 7, Left: &TreeNode{Val: 6}, Right: &TreeNode{Val: 9}}}
	fmt.Printf("翻转前中序: %v\n", inorder(invertT))  // [1 2 3 4 6 7 9]
	invertTree(invertT)
	fmt.Printf("翻转后中序: %v\n", inorder(invertT))  // [9 7 6 4 3 2 1]

	fmt.Println("\n===== 对称二叉树 =====")
	sym1 := &TreeNode{Val: 1,
		Left:  &TreeNode{Val: 2, Left: &TreeNode{Val: 3}, Right: &TreeNode{Val: 4}},
		Right: &TreeNode{Val: 2, Left: &TreeNode{Val: 4}, Right: &TreeNode{Val: 3}}}
	fmt.Printf("是否对称: %v\n", isSymmetric(sym1)) // true
	sym2 := &TreeNode{Val: 1,
		Left:  &TreeNode{Val: 2, Right: &TreeNode{Val: 3}},
		Right: &TreeNode{Val: 2, Right: &TreeNode{Val: 3}}}
	fmt.Printf("是否对称: %v\n", isSymmetric(sym2)) // false

	fmt.Println("\n===== 验证二叉搜索树 =====")
	okBst := &TreeNode{Val: 2, Left: &TreeNode{Val: 1}, Right: &TreeNode{Val: 3}}
	fmt.Printf("是否BST: %v\n", isValidBST(okBst)) // true
	badBst := &TreeNode{Val: 5,
		Left:  &TreeNode{Val: 1},
		Right: &TreeNode{Val: 4, Left: &TreeNode{Val: 3}, Right: &TreeNode{Val: 6}}}
	fmt.Printf("是否BST: %v\n", isValidBST(badBst)) // false

	fmt.Println("\n===== 最近公共祖先 =====")
	lcaTree := &TreeNode{Val: 3}
	lcaTree.Left = &TreeNode{Val: 5, Left: &TreeNode{Val: 6},
		Right: &TreeNode{Val: 2, Left: &TreeNode{Val: 7}, Right: &TreeNode{Val: 4}}}
	lcaTree.Right = &TreeNode{Val: 1}
	p5, q1 := lcaTree.Left, lcaTree.Right
	fmt.Printf("5和1的LCA: %d\n", lowestCommonAncestor(lcaTree, p5, q1).Val) // 3
	q4 := lcaTree.Left.Right.Right
	fmt.Printf("5和4的LCA: %d\n", lowestCommonAncestor(lcaTree, p5, q4).Val) // 5

	fmt.Println("\n===== 二叉树的序列化与反序列化 =====")
	serTree := &TreeNode{Val: 1,
		Left:  &TreeNode{Val: 2},
		Right: &TreeNode{Val: 3, Left: &TreeNode{Val: 4}, Right: &TreeNode{Val: 5}}}
	codec := NewCodec()
	s := codec.serialize(serTree)
	fmt.Printf("序列化: %s\n", s) // 1,2,null,null,3,4,null,null,5,null,null
	restored := codec.deserialize(s)
	fmt.Printf("反序列化后中序遍历: %v\n", inorder(restored)) // [2 1 4 3 5]
	s2 := codec.serialize(restored)
	fmt.Printf("两次序列化相同: %v\n", s == s2) // true
}
```

---

### 主题12：堆（Heap）

#### 12.1 堆的概念

> **堆（Heap）**：一种特殊的**完全二叉树**，满足堆性质。

##### 完全二叉树

```
完全二叉树：除了最后一层，其他层都是满的，
最后一层的节点都靠左排列。

    完全二叉树              不是完全二叉树
         1                       1
       /   \                   /   \
      2     3                 2     3
     / \   /                 /       \
    4   5 6                 4         7
    
最后一层靠左排列          最后一层没有靠左，中间有空缺
```

##### 大顶堆和小顶堆

```
大顶堆（Max Heap）：                小顶堆（Min Heap）：
每个节点 >= 它的子节点              每个节点 <= 它的子节点
堆顶是最大值                        堆顶是最小值

        10（最大）                       1（最小）
       /    \                          /    \
      7      8                        3      5
     / \    /                        / \    /
    3   5  6                        7   9  8
    
大顶堆应用：求最大值、降序排列
小顶堆应用：求最小值、升序排列、Top-K问题
```

#### 12.2 堆的数组表示法

堆虽然是树结构，但我们可以用**数组**来存储它！因为完全二叉树的下标有规律：

```
树结构：              数组表示（下标从0开始）：
        10
       /  \           下标: 0  1  2  3  4  5  6
      7    8          值:  10 7  8  3  5  6  2
     / \  / \
    3  5 6   2

公式推导（下标从0开始）：
  父节点下标 i 的：
    左子节点 = 2*i + 1
    右子节点 = 2*i + 2
  
  子节点下标 j 的：
    父节点 = (j - 1) // 2

验证：
  节点7（下标1）：左子=2*1+1=3（值3），右子=2*1+2=4（值5）  ✓
  节点8（下标2）：左子=2*2+1=5（值6），右子=2*2+2=6（值2）  ✓
  节点5（下标4）：父=(4-1)//2=1（值7）  ✓
```

**为什么用数组存堆？**
- 完全二叉树没有"空洞"，用数组存储不会有空间浪费
- 通过简单的数学公式就能找到父/子节点，不需要指针
- 内存连续，缓存友好，效率高

#### 12.3 堆的核心操作

##### 12.3.1 上浮（Sift Up）

> 插入新元素时，新元素放在数组末尾，然后不断和父节点比较，如果比父节点"大"（大顶堆）就交换，直到满足堆性质。

```python
class MaxHeap:
    """
    大顶堆的完整实现
    
    用数组存储完全二叉树，满足：每个节点 >= 子节点
    """
    
    def __init__(self):
        self.heap = []  # 用数组存储堆
    
    def _parent(self, i):
        """父节点下标"""
        return (i - 1) // 2
    
    def _left(self, i):
        """左子节点下标"""
        return 2 * i + 1
    
    def _right(self, i):
        """右子节点下标"""
        return 2 * i + 2
    
    def _swap(self, i, j):
        """交换数组中两个位置的元素"""
        self.heap[i], self.heap[j] = self.heap[j], self.heap[i]
    
    def _sift_up(self, i):
        """
        上浮操作：将下标i的节点向上调整到正确位置
        
        场景：插入新元素后调用
        过程：不断和父节点比较，如果比父节点大就交换
        
        时间复杂度：O(log n) —— 最多上浮树的高度层数次
        
        图示（插入元素9）：
            10                  10                  10
           /  \                /  \                /  \
          7    8    →        7    8    →          9    8
         / \  /             / \  / \             / \  / \
        3  5 6             3  5 6  9            3  5 6  7
                          （9比7大，交换）       （9比10小，停止）
        """
        while i > 0 and self.heap[i] > self.heap[self._parent(i)]:
            self._swap(i, self._parent(i))
            i = self._parent(i)
    
    def push(self, val):
        """
        插入元素
        
        步骤：
        1. 把新元素放在数组末尾
        2. 执行上浮操作，调整到正确位置
        
        时间复杂度：O(log n)
        """
        self.heap.append(val)       # 放在末尾
        self._sift_up(len(self.heap) - 1)  # 上浮
```

##### 12.3.2 下沉（Sift Down）

> 删除堆顶后，把最后一个元素放到堆顶，然后不断和较大的子节点比较，如果比子节点小就交换。

```python
    def _sift_down(self, i):
        """
        下沉操作：将下标i的节点向下调整到正确位置
        
        场景：删除堆顶后调用
        过程：不断和较大的子节点比较，如果比子节点小就交换
        
        时间复杂度：O(log n)
        
        图示（删除堆顶10后，把2放到堆顶）：
            10                  2                   8
           /  \                /  \                /  \
          7    8    →        7    8    →          7    2
         / \  / \           / \  /               / \  /
        3  5 6   2         3  5 6               3  5 6
        （2放到堆顶）    （2比8小，交换）     （2比7小，但7没有子节点了...
                                              实际2比7小，交换）
        等等，让我重新画：
        
            10                  2                   8
           /  \                /  \                /  \
          7    8              7    8              7    2
         / \  / \           / \  / \            / \  /
        3  5 6   2         3  5 6              3  5 6
        删除10，把2       2和8交换           2和7交换
        放到堆顶         （8是较大子节点）    （7是较大子节点）
        
        最终：
              8
            /  \
           7    2
          / \  /
         3  5 6
        """
        n = len(self.heap)
        
        while True:
            largest = i           # 假设当前节点最大
            left = self._left(i)
            right = self._right(i)
            
            # 如果左子节点更大
            if left < n and self.heap[left] > self.heap[largest]:
                largest = left
            
            # 如果右子节点更大
            if right < n and self.heap[right] > self.heap[largest]:
                largest = right
            
            # 如果当前节点已经是最大的，停止
            if largest == i:
                break
            
            # 否则交换，继续下沉
            self._swap(i, largest)
            i = largest
    
    def pop(self):
        """
        删除并返回堆顶元素（最大值）
        
        步骤：
        1. 记录堆顶值
        2. 把最后一个元素移到堆顶
        3. 删除最后一个元素
        4. 对堆顶执行下沉操作
        
        时间复杂度：O(log n)
        """
        if not self.heap:
            raise IndexError("堆为空")
        
        if len(self.heap) == 1:
            return self.heap.pop()
        
        # 记录堆顶
        top = self.heap[0]
        
        # 把最后一个元素移到堆顶
        self.heap[0] = self.heap.pop()
        
        # 下沉调整
        self._sift_down(0)
        
        return top
    
    def peek(self):
        """
        获取堆顶元素（不删除）
        
        时间复杂度：O(1)
        """
        if not self.heap:
            raise IndexError("堆为空")
        return self.heap[0]
    
    def __len__(self):
        return len(self.heap)
    
    def __repr__(self):
        return f"MaxHeap({self.heap})"


# ===== 完整演示 =====
print("===== 大顶堆操作演示 =====")
heap = MaxHeap()

# 依次插入元素
for val in [3, 1, 6, 10, 7, 8, 2, 5]:
    heap.push(val)
    print(f"插入 {val} 后: {heap}")

print(f"\n堆顶（最大值）: {heap.peek()}")  # 10

# 依次弹出
print("\n依次弹出（从大到小）：")
while len(heap) > 0:
    print(f"  弹出: {heap.pop()}")
```

#### 12.4 建堆操作（Heapify）

```python
def heapify(arr):
    """
    O(n) 建堆（自底向上）
    
    原理：
    从最后一个非叶节点开始，从右往左、从下往上，
    对每个节点执行下沉操作。
    
    为什么是 O(n) 而不是 O(n log n)？
    - 虽然对每个节点做下沉（O(log n)）
    - 但大部分节点在底层，下沉的距离很短
    - 数学上可以证明总操作次数是 O(n)
    
    最后一个非叶节点的下标 = (n-2) // 2 = n//2 - 1
    
    图示（对数组 [3, 1, 6, 10, 7, 8, 2] 建大顶堆）：
    
    初始树结构：              建堆过程（从最后一个非叶节点开始）：
          3                         3
        /   \                     /   \
       1     6                  1     6
      / \   / \                / \   / \
    10   7 8   2             10  7 8   2
    
    最后一个非叶节点是6（下标2），从它开始下沉：
    
    Step 1: 对6下沉 → 6和8交换
          3
        /   \
       1     8
      / \   / \
    10   7 6   2
    
    Step 2: 对1下沉 → 1和10交换
          3
        /   \
      10     8
      / \   / \
     1  7  6  2
    
    Step 3: 对3下沉 → 3和10交换 → 3再和7交换
          10
        /    \
       7      8
      / \    / \
     3   1  6   2
    
    最终大顶堆：[10, 7, 8, 3, 1, 6, 2]
    """
    n = len(arr)
    
    # 从最后一个非叶节点开始，倒序遍历到根
    for i in range(n // 2 - 1, -1, -1):
        _sift_down(arr, n, i)
    
    return arr


def _sift_down(arr, n, i):
    """对数组arr中下标i的节点执行下沉操作"""
    while True:
        largest = i
        left = 2 * i + 1
        right = 2 * i + 2
        
        if left < n and arr[left] > arr[largest]:
            largest = left
        if right < n and arr[right] > arr[largest]:
            largest = right
        
        if largest == i:
            break
        
        arr[i], arr[largest] = arr[largest], arr[i]
        i = largest


# 演示
print("\n===== O(n) 建堆演示 =====")
arr = [3, 1, 6, 10, 7, 8, 2]
print(f"原始数组: {arr}")
heapify(arr)
print(f"建堆后:   {arr}")  # [10, 7, 8, 3, 1, 6, 2]（可能略有不同，但满足堆性质）
```

#### 12.5 Python的heapq模块

```python
import heapq

"""
Python的heapq模块提供了基于数组的最小堆实现。

注意：heapq默认是最小堆！堆顶是最小元素。
如果需要最大堆，可以把元素取反后存入。

常用函数：
- heappush(heap, item): 将item推入堆
- heappop(heap): 弹出并返回最小元素
- heapify(list): 将列表原地转为堆
- nlargest(n, iterable): 返回最大的n个元素
- nsmallest(n, iterable): 返回最小的n个元素
"""

print("===== heapq模块演示 =====")

# 1. 创建堆
h = []
heapq.heappush(h, 5)
heapq.heappush(h, 3)
heapq.heappush(h, 8)
heapq.heappush(h, 1)
heapq.heappush(h, 9)
print(f"堆: {h}")  # [1, 3, 8, 5, 9]（堆的数组表示，不是完全排序的）

# 2. 弹出最小元素
print(f"弹出最小: {heapq.heappop(h)}")  # 1
print(f"弹出最小: {heapq.heappop(h)}")  # 3

# 3. heapify：将普通列表转为堆
data = [5, 2, 8, 1, 9, 3, 7]
heapq.heapify(data)
print(f"\nheapify后: {data}")  # 满足堆性质的数组

# 依次弹出（自动排序）
print("依次弹出（升序）：")
while data:
    print(f"  {heapq.heappop(data)}")

# 4. nlargest 和 nsmallest
nums = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]
print(f"\n最大的3个: {heapq.nlargest(3, nums)}")    # [9, 6, 5]
print(f"最小的3个: {heapq.nsmallest(3, nums)}")     # [1, 1, 2]

# 5. 用heapq实现最大堆（技巧：取反）
print("\n===== 用heapq实现最大堆 =====")
max_heap = []
for val in [3, 1, 6, 10, 7]:
    heapq.heappush(max_heap, -val)  # 存入时取反

print("依次弹出（从大到小）：")
while max_heap:
    print(f"  {-heapq.heappop(max_heap)}")  # 弹出时再取反
```

#### 12.6 堆的经典应用

##### 应用1：Top-K问题

```python
def topK_largest(nums, k):
    """
    找出数组中最大的K个元素
    
    方法：维护一个大小为K的最小堆
    - 遍历数组，如果堆的大小 < K，直接入堆
    - 如果堆的大小 == K，且当前元素 > 堆顶（堆中最小的元素），
      就弹出堆顶，把当前元素入堆
    - 最终堆中保留的就是最大的K个元素
    
    为什么用最小堆？
    因为堆顶是堆中最小的，如果新元素比堆顶还小，
    那它肯定不是最大的K个之一，直接丢弃。
    
    时间复杂度：O(n log k)
    空间复杂度：O(k)
    
    类比：选拔赛前K名，你只保留当前最好的K个人。
    来了新选手，如果比第K名强，就替换掉第K名。
    """
    import heapq
    
    min_heap = []
    for num in nums:
        if len(min_heap) < k:
            heapq.heappush(min_heap, num)
        elif num > min_heap[0]:  # 比堆顶（最小的）大
            heapq.heapreplace(min_heap, num)  # 弹出堆顶，推入新元素
    
    return sorted(min_heap, reverse=True)


# 测试
print("===== Top-K问题 =====")
nums = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]
print(f"数组: {nums}")
print(f"最大的3个: {topK_largest(nums, 3)}")  # [9, 6, 5]
```

##### 应用2：合并K个有序链表

```python
import heapq

class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next
    
    def __lt__(self, other):
        """定义比较方法，让heapq能比较ListNode"""
        return self.val < other.val


def mergeKLists(lists):
    """
    合并K个有序链表
    
    思路：
    1. 把每个链表的头节点放入最小堆
    2. 每次从堆中取出最小节点，加入结果链表
    3. 如果取出的节点有下一个节点，把下一个节点入堆
    4. 重复直到堆为空
    
    时间复杂度：O(N log k)，N是所有节点总数，k是链表数
    空间复杂度：O(k)，堆中最多k个节点
    
    类比：K条跑道上的运动员，每次选跑得最慢的那个前进一步，
    最终所有运动员按顺序排好。
    """
    dummy = ListNode(0)  # 虚拟头节点
    current = dummy
    min_heap = []
    
    # 把每个链表的头节点入堆
    for head in lists:
        if head:
            heapq.heappush(min_heap, head)
    
    while min_heap:
        node = heapq.heappop(min_heap)  # 取出最小节点
        current.next = node
        current = current.next
        
        if node.next:
            heapq.heappush(min_heap, node.next)  # 下一个节点入堆
    
    return dummy.next


# 测试
print("\n===== 合并K个有序链表 =====")
l1 = ListNode(1, ListNode(4, ListNode(5)))
l2 = ListNode(1, ListNode(3, ListNode(4)))
l3 = ListNode(2, ListNode(6))

merged = mergeKLists([l1, l2, l3])
result = []
while merged:
    result.append(merged.val)
    merged = merged.next
print(f"合并结果: {result}")  # [1, 1, 2, 3, 4, 4, 5, 6]
```

##### 应用3：数据流中的中位数

```python
class MedianFinder:
    """
    数据流中的中位数
    
    思路：用两个堆
    - 大顶堆 left：存较小的一半（堆顶是左半部分的最大值）
    - 小顶堆 right：存较大的一半（堆顶是右半部分的最小值）
    
    维护两个堆的大小关系：
    - len(left) == len(right) 或 len(left) == len(right) + 1
    
    中位数：
    - 如果两个堆大小相等：中位数 = (left堆顶 + right堆顶) / 2
    - 如果left比right多1：中位数 = left堆顶
    
    类比：
    把一群人按身高分成两组：
    - 矮的那组（大顶堆）：堆顶是矮组中最高的
    - 高的那组（小顶堆）：堆顶是高组中最矮的
    中位数就在两组的"交界处"
    
    时间复杂度：
    - 插入：O(log n)
    - 查找中位数：O(1)
    """
    
    def __init__(self):
        self.left = []   # 大顶堆（存较小的一半，Python中取反模拟）
        self.right = []  # 小顶堆（存较大的一半）
    
    def addNum(self, num):
        """添加一个数"""
        # 先放入大顶堆
        heapq.heappush(self.left, -num)
        
        # 平衡：确保left的最大值 <= right的最小值
        heapq.heappush(self.right, -heapq.heappop(self.left))
        
        # 平衡：确保left的大小 >= right的大小，且最多多1
        if len(self.left) < len(self.right):
            heapq.heappush(self.left, -heapq.heappop(self.right))
    
    def findMedian(self):
        """获取中位数"""
        if len(self.left) > len(self.right):
            return -self.left[0]  # left多一个，堆顶就是中位数
        else:
            return (-self.left[0] + self.right[0]) / 2  # 两堆顶的平均值


# 测试
print("\n===== 数据流中的中位数 =====")
mf = MedianFinder()
for num in [1, 3, 2, 5, 4, 6]:
    mf.addNum(num)
    print(f"添加 {num} 后，中位数 = {mf.findMedian()}")
# 添加1后: 1.0
# 添加3后: 2.0
# 添加2后: 2.0
# 添加5后: 2.5
# 添加4后: 3.0
# 添加6后: 3.5
```

#### 12.7 经典例题

##### 例题1：数组中的第K个最大元素（LeetCode 215）

```python
def findKthLargest(nums, k):
    """
    数组中的第K个最大元素
    
    方法1：最小堆（维护大小为K的堆）
    时间复杂度：O(n log k)
    
    方法2：快速选择（类似快速排序的partition）
    时间复杂度：平均 O(n)
    """
    import heapq
    
    # 方法1：最小堆
    min_heap = nums[:k]
    heapq.heapify(min_heap)
    
    for num in nums[k:]:
        if num > min_heap[0]:
            heapq.heapreplace(min_heap, num)
    
    return min_heap[0]


def findKthLargest_quickselect(nums, k):
    """
    方法2：快速选择
    
    思路：
    类似快速排序，每次partition后，枢轴元素的位置是确定的。
    如果枢轴正好在第k大的位置，就找到了答案。
    
    时间复杂度：平均 O(n)，最差 O(n²)
    """
    import random
    
    def quick_select(left, right, k_smallest):
        if left == right:
            return nums[left]
        
        # 随机选枢轴
        pivot_idx = random.randint(left, right)
        nums[pivot_idx], nums[right] = nums[right], nums[pivot_idx]
        pivot = nums[right]
        
        # partition
        i = left
        for j in range(left, right):
            if nums[j] <= pivot:
                nums[i], nums[j] = nums[j], nums[i]
                i += 1
        nums[i], nums[right] = nums[right], nums[i]
        
        if k_smallest == i:
            return nums[i]
        elif k_smallest < i:
            return quick_select(left, i - 1, k_smallest)
        else:
            return quick_select(i + 1, right, k_smallest)
    
    # 第k大 = 第(n-k)小
    return quick_select(0, len(nums) - 1, len(nums) - k)


# 测试
print("===== 数组中的第K个最大元素 =====")
nums = [3, 2, 1, 5, 6, 4]
print(f"数组: {nums}")
print(f"第2大: {findKthLargest(nums, 2)}")  # 5
print(f"第2大(快速选择): {findKthLargest_quickselect([3,2,1,5,6,4], 2)}")  # 5
```

##### 例题2：前K个高频元素（LeetCode 347）

```python
def topKFrequent(nums, k):
    """
    前K个高频元素
    
    思路：
    1. 用哈希表统计每个元素的出现次数
    2. 用最小堆维护频率最高的K个元素
    
    时间复杂度：O(n log k)
    空间复杂度：O(n + k)
    
    类比：统计班级里做作业次数最多的前K个同学
    """
    from collections import Counter
    import heapq
    
    # 统计频率
    count = Counter(nums)
    # count = {元素: 出现次数}
    
    # 用最小堆维护频率最高的K个
    min_heap = []
    for num, freq in count.items():
        if len(min_heap) < k:
            heapq.heappush(min_heap, (freq, num))
        elif freq > min_heap[0][0]:
            heapq.heapreplace(min_heap, (freq, num))
    
    return [item[1] for item in min_heap]


# 更简洁的写法
def topKFrequent_simple(nums, k):
    """用Counter的most_common方法"""
    from collections import Counter
    return [item for item, _ in Counter(nums).most_common(k)]


# 测试
print("\n===== 前K个高频元素 =====")
nums = [1, 1, 1, 2, 2, 3]
print(f"数组: {nums}")
print(f"前2个高频: {topKFrequent(nums, 2)}")  # [1, 2]
print(f"前2个高频(简洁版): {topKFrequent_simple(nums, 2)}")  # [1, 2]
```

##### 例题3：数据流的中位数（LeetCode 295）

已在上面"应用3"中详细实现，这里补充测试：

```python
print("\n===== 数据流的中位数（LeetCode 295）=====")
mf = MedianFinder()
mf.addNum(1)
mf.addNum(2)
print(f"当前中位数: {mf.findMedian()}")  # 1.5
mf.addNum(3)
print(f"当前中位数: {mf.findMedian()}")  # 2.0
```

##### 例题4：最后一块石头的重量（LeetCode 1046）

```python
def lastStoneWeight(stones):
    """
    最后一块石头的重量
    
    题意：
    每次选出两块最重的石头，一起粉碎：
    - 如果重量相同，两块都碎掉
    - 如果重量不同，留下重量差的新石头
    最后最多剩一块石头，返回它的重量。
    
    思路：用大顶堆
    每次取出最大的两个，计算差值，如果不为0就放回去。
    
    时间复杂度：O(n log n)
    
    类比：
    两个拳击手比赛，重量级的先上。
    体重差就是输家的"剩余战斗力"。
    """
    import heapq
    
    # Python的heapq是最小堆，取反模拟最大堆
    max_heap = [-s for s in stones]
    heapq.heapify(max_heap)
    
    while len(max_heap) > 1:
        # 取出两块最重的石头
        s1 = -heapq.heappop(max_heap)  # 最重的
        s2 = -heapq.heappop(max_heap)  # 第二重的
        
        # 如果不等重，把差值放回去
        if s1 != s2:
            heapq.heappush(max_heap, -(s1 - s2))
    
    # 返回最后一块石头的重量（如果没有就返回0）
    return -max_heap[0] if max_heap else 0


# 测试
print("\n===== 最后一块石头的重量 =====")
print(lastStoneWeight([2, 7, 4, 1, 8, 1]))  # 1
# 解释：
# 7和8碰撞 → 剩1，数组变为 [2, 4, 1, 1, 1]
# 2和4碰撞 → 剩2，数组变为 [2, 1, 1, 1]
# 2和1碰撞 → 剩1，数组变为 [1, 1, 1]
# 1和1碰撞 → 全碎，数组变为 [1]
# 最后剩1

print(lastStoneWeight([1]))  # 1
print(lastStoneWeight([2, 2]))  # 0
```

#### 12.8 堆排序

```python
def heapSort(arr):
    """
    堆排序
    
    思路：
    1. 把数组建成大顶堆
    2. 每次把堆顶（最大值）和末尾元素交换
    3. 堆的大小减1，对新的堆顶执行下沉
    4. 重复2-3直到堆为空
    5. 最终数组从小到大排好序
    
    类比：
    每次从一群人中挑出最高的站到最后，
    再从剩下的人中挑最高的站到倒数第二...
    
    复杂度分析：
    - 建堆：O(n)
    - 每次调整：O(log n)，共n-1次 → O(n log n)
    - 总时间复杂度：O(n log n)
    - 空间复杂度：O(1)（原地排序）
    - 不稳定排序（相同元素的相对顺序可能改变）
    """
    n = len(arr)
    
    # 第一步：建大顶堆（O(n)）
    for i in range(n // 2 - 1, -1, -1):
        _sift_down_for_sort(arr, n, i)
    
    print(f"  建堆后: {arr}")
    
    # 第二步：逐个取出最大值放到末尾
    for i in range(n - 1, 0, -1):
        # 堆顶（最大）和末尾交换
        arr[0], arr[i] = arr[i], arr[0]
        
        # 对缩小后的堆执行下沉
        _sift_down_for_sort(arr, i, 0)
        
        print(f"  第{n-i}轮: {arr}")
    
    return arr


def _sift_down_for_sort(arr, n, i):
    """下沉操作（堆排序用）"""
    while True:
        largest = i
        left = 2 * i + 1
        right = 2 * i + 2
        
        if left < n and arr[left] > arr[largest]:
            largest = left
        if right < n and arr[right] > arr[largest]:
            largest = right
        
        if largest == i:
            break
        
        arr[i], arr[largest] = arr[largest], arr[i]
        i = largest


# 测试
print("\n===== 堆排序 =====")
arr = [3, 1, 6, 10, 7, 8, 2, 5]
print(f"排序前: {arr}")
heapSort(arr)
print(f"排序后: {arr}")  # [1, 2, 3, 5, 6, 7, 8, 10]

# 复杂度总结
print("""
===== 堆排序复杂度总结 =====
时间复杂度：
  - 最好情况：O(n log n)
  - 最坏情况：O(n log n)
  - 平均情况：O(n log n)
  → 无论什么情况都是 O(n log n)，非常稳定！

空间复杂度：O(1)（原地排序，不需要额外空间）

稳定性：不稳定排序

与其他排序对比：
  - 快速排序：平均更快，但最坏O(n²)
  - 归并排序：稳定，但需要O(n)额外空间
  - 堆排序：O(n log n) + O(1)空间，适合内存受限的场景
""")
```

#### 堆的知识总结

```
┌─────────────────────────────────────────────────┐
│                   堆（Heap）                     │
├─────────────────────────────────────────────────┤
│ 本质：完全二叉树的数组表示                        │
│                                                   │
│ 核心公式（下标从0开始）：                          │
│   父节点 = (i-1) // 2                             │
│   左子 = 2i + 1                                   │
│   右子 = 2i + 2                                   │
│                                                   │
│ 核心操作：                                        │
│   插入：末尾添加 → 上浮 → O(log n)                │
│   删除堆顶：末尾替换 → 下沉 → O(log n)            │
│   建堆：从最后非叶节点逆序下沉 → O(n)             │
│                                                   │
│ 典型应用：                                        │
│   Top-K问题、中位数、堆排序、任务调度              │
└─────────────────────────────────────────────────┘
```



### 主题12 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、大顶堆完整实现

```typescript
// ========== 大顶堆（MaxHeap） ==========
// 用数组存储完全二叉树，满足：每个节点 >= 子节点
// 核心公式（下标从0开始）：
//   父节点 = (i-1) // 2，左子 = 2i+1，右子 = 2i+2
class MaxHeap {
    private heap: number[] = []; // 用数组存储堆

    // 父节点下标
    private parent(i: number): number {
        return Math.floor((i - 1) / 2);
    }

    // 左子节点下标
    private left(i: number): number {
        return 2 * i + 1;
    }

    // 右子节点下标
    private right(i: number): number {
        return 2 * i + 2;
    }

    // 交换数组中两个位置的元素
    private swap(i: number, j: number): void {
        [this.heap[i], this.heap[j]] = [this.heap[j], this.heap[i]];
    }

    // 上浮操作：将下标 i 的节点向上调整到正确位置
    // 场景：插入新元素后调用；不断和父节点比较，比父节点大就交换
    private siftUp(i: number): void {
        while (i > 0 && this.heap[i] > this.heap[this.parent(i)]) {
            this.swap(i, this.parent(i));
            i = this.parent(i);
        }
    }

    // 下沉操作：将下标 i 的节点向下调整到正确位置
    // 场景：删除堆顶后调用；不断和较大的子节点比较，比子节点小就交换
    private siftDown(i: number): void {
        const n = this.heap.length;

        while (true) {
            let largest = i;              // 假设当前节点最大
            const left = this.left(i);
            const right = this.right(i);

            // 如果左子节点更大
            if (left < n && this.heap[left] > this.heap[largest]) {
                largest = left;
            }
            // 如果右子节点更大
            if (right < n && this.heap[right] > this.heap[largest]) {
                largest = right;
            }
            // 如果当前节点已经是最大的，停止
            if (largest === i) break;

            // 否则交换，继续下沉
            this.swap(i, largest);
            i = largest;
        }
    }

    // 插入元素：放在末尾 → 上浮。时间复杂度 O(log n)
    push(val: number): void {
        this.heap.push(val);                                  // 放在末尾
        this.siftUp(this.heap.length - 1);                    // 上浮
    }

    // 删除并返回堆顶元素（最大值）。时间复杂度 O(log n)
    pop(): number {
        if (this.heap.length === 0) throw new Error("堆为空");
        if (this.heap.length === 1) return this.heap.pop()!;

        const top = this.heap[0];
        this.heap[0] = this.heap.pop()!; // 把最后一个元素移到堆顶
        this.siftDown(0);                // 下沉调整
        return top;
    }

    // 获取堆顶元素（不删除）。时间复杂度 O(1)
    peek(): number {
        if (this.heap.length === 0) throw new Error("堆为空");
        return this.heap[0];
    }

    get size(): number {
        return this.heap.length;
    }

    toString(): string {
        return `MaxHeap(${JSON.stringify(this.heap)})`;
    }
}

// ===== 完整演示 =====
console.log("===== 大顶堆操作演示 =====");
const heap = new MaxHeap();

for (const val of [3, 1, 6, 10, 7, 8, 2, 5]) {
    heap.push(val);
    console.log(`插入 ${val} 后: ${heap.toString()}`);
}

console.log(`\n堆顶（最大值）: ${heap.peek()}`);  // 10

// 依次弹出（从大到小）
console.log("\n依次弹出（从大到小）：");
while (heap.size > 0) {
    console.log(`  弹出: ${heap.pop()}`);
}
```

##### 二、O(n) 建堆（Heapify）

```typescript
// ========== O(n) 建堆（自底向上） ==========
// 从最后一个非叶节点开始，从右往左、从下往上，对每个节点执行下沉操作。
// 最后一个非叶节点的下标 = n//2 - 1
// 为什么是 O(n) 而不是 O(n log n)？大部分节点在底层，下沉的距离很短。

// 下沉操作（对数组 arr 中下标 i 的节点）
function siftDown(arr: number[], n: number, i: number): void {
    while (true) {
        let largest = i;
        const left = 2 * i + 1;
        const right = 2 * i + 2;

        if (left < n && arr[left] > arr[largest]) largest = left;
        if (right < n && arr[right] > arr[largest]) largest = right;

        if (largest === i) break;

        [arr[i], arr[largest]] = [arr[largest], arr[i]];
        i = largest;
    }
}

// 原地建大顶堆
function heapify(arr: number[]): number[] {
    const n = arr.length;
    // 从最后一个非叶节点开始，倒序遍历到根
    for (let i = Math.floor(n / 2) - 1; i >= 0; i--) {
        siftDown(arr, n, i);
    }
    return arr;
}

// 演示
console.log("\n===== O(n) 建堆演示 =====");
const arr = [3, 1, 6, 10, 7, 8, 2];
console.log(`原始数组: ${arr}`);
heapify(arr);
console.log(`建堆后:   ${arr}`);  // [10, 7, 8, 3, 1, 6, 2]（满足堆性质）
```

##### 三、堆的经典应用

```typescript
// ========== 应用1：Top-K 问题 ==========
// 找出数组中最大的 K 个元素：维护一个大小为 K 的最小堆
// 堆顶是堆中最小的，新元素比堆顶小就直接丢弃
function topKLargest(nums: number[], k: number): number[] {
    const minHeap = new MinHeap();
    for (const num of nums) {
        if (minHeap.size < k) {
            minHeap.push(num);
        } else if (num > minHeap.peek()!) {
            minHeap.replace(num); // 弹出堆顶，推入新元素
        }
    }
    return minHeap.toArray().sort((a, b) => b - a);
}

// 最小堆（Top-K 用）
class MinHeap {
    private heap: number[] = [];

    push(val: number): void {
        this.heap.push(val);
        this.bubbleUp(this.heap.length - 1);
    }

    peek(): number | null {
        return this.heap.length > 0 ? this.heap[0] : null;
    }

    // 删除并返回堆顶元素（最小值）。时间复杂度 O(log n)
    pop(): number {
        if (this.heap.length === 0) throw new Error("堆为空");
        if (this.heap.length === 1) return this.heap.pop()!;

        const top = this.heap[0];
        this.heap[0] = this.heap.pop()!; // 把最后一个元素移到堆顶
        this.bubbleDown(0);              // 下沉调整
        return top;
    }

    replace(val: number): void {
        this.heap[0] = val;
        this.bubbleDown(0);
    }

    get size(): number {
        return this.heap.length;
    }

    toArray(): number[] {
        return [...this.heap];
    }

    private bubbleUp(i: number): void {
        while (i > 0) {
            const p = Math.floor((i - 1) / 2);
            if (this.heap[i] >= this.heap[p]) break;
            [this.heap[i], this.heap[p]] = [this.heap[p], this.heap[i]];
            i = p;
        }
    }

    private bubbleDown(i: number): void {
        const n = this.heap.length;
        while (true) {
            let smallest = i;
            const l = 2 * i + 1, r = 2 * i + 2;
            if (l < n && this.heap[l] < this.heap[smallest]) smallest = l;
            if (r < n && this.heap[r] < this.heap[smallest]) smallest = r;
            if (smallest === i) break;
            [this.heap[i], this.heap[smallest]] = [this.heap[smallest], this.heap[i]];
            i = smallest;
        }
    }
}

// 测试
console.log("===== Top-K问题 =====");
const nums = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5];
console.log(`数组: ${nums}`);
console.log(`最大的3个: ${topKLargest(nums, 3)}`);  // [9, 6, 5]

// ========== 应用2：合并K个有序链表 ==========
class ListNode {
    val: number;
    next: ListNode | null = null;

    constructor(val: number, next: ListNode | null = null) {
        this.val = val;
        this.next = next;
    }
}

// 把每个链表的头节点放入最小堆，每次取出最小节点，再把它的下一个节点入堆
function mergeKLists(lists: Array<ListNode | null>): ListNode | null {
    const dummy = new ListNode(0); // 虚拟头节点
    let current: ListNode | null = dummy;

    // 最小堆按节点值排序
    const nodeHeap: ListNode[] = [];

    const pushNode = (node: ListNode): void => {
        nodeHeap.push(node);
        let i = nodeHeap.length - 1;
        while (i > 0) {
            const p = Math.floor((i - 1) / 2);
            if (nodeHeap[i].val >= nodeHeap[p].val) break;
            [nodeHeap[i], nodeHeap[p]] = [nodeHeap[p], nodeHeap[i]];
            i = p;
        }
    };

    const popNode = (): ListNode | null => {
        if (nodeHeap.length === 0) return null;
        const top = nodeHeap[0];
        const last = nodeHeap.pop()!;
        if (nodeHeap.length > 0) {
            nodeHeap[0] = last;
            let i = 0;
            while (true) {
                let smallest = i;
                const l = 2 * i + 1, r = 2 * i + 2;
                if (l < nodeHeap.length && nodeHeap[l].val < nodeHeap[smallest].val) smallest = l;
                if (r < nodeHeap.length && nodeHeap[r].val < nodeHeap[smallest].val) smallest = r;
                if (smallest === i) break;
                [nodeHeap[i], nodeHeap[smallest]] = [nodeHeap[smallest], nodeHeap[i]];
                i = smallest;
            }
        }
        return top;
    };

    // 把每个链表的头节点入堆
    for (const head of lists) {
        if (head !== null) pushNode(head);
    }

    while (nodeHeap.length > 0) {
        const node = popNode()!;           // 取出最小节点
        current.next = node;
        current = current.next;
        if (node.next !== null) pushNode(node.next); // 下一个节点入堆
    }
    return dummy.next;
}

// 测试
console.log("\n===== 合并K个有序链表 =====");
const l1 = new ListNode(1, new ListNode(4, new ListNode(5)));
const l2 = new ListNode(1, new ListNode(3, new ListNode(4)));
const l3 = new ListNode(2, new ListNode(6));

const merged = mergeKLists([l1, l2, l3]);
const mergedVals: number[] = [];
let m: ListNode | null = merged;
while (m !== null) {
    mergedVals.push(m.val);
    m = m.next;
}
console.log(`合并结果: ${mergedVals}`);  // [1, 1, 2, 3, 4, 4, 5, 6]

// ========== 应用3：数据流中的中位数 ==========
// 用两个堆：
// - 大顶堆 left：存较小的一半（堆顶是左半部分的最大值）
// - 小顶堆 right：存较大的一半（堆顶是右半部分的最小值）
// 中位数就在两组的"交界处"
class MedianFinder {
    private left = new MaxHeap();   // 大顶堆：存较小的一半
    private right = new MinHeap();  // 小顶堆：存较大的一半

    // 添加一个数，时间复杂度 O(log n)
    addNum(num: number): void {
        // 先放入大顶堆
        this.left.push(num);

        // 平衡：确保 left 的最大值 <= right 的最小值
        this.right.push(this.left.pop()!);

        // 平衡：确保 left 的大小 >= right 的大小，且最多多 1
        if (this.left.size < this.right.size) {
            this.left.push(this.right.pop()!);
        }
    }

    // 获取中位数，时间复杂度 O(1)
    findMedian(): number {
        if (this.left.size > this.right.size) {
            return this.left.peek(); // left 多一个，堆顶就是中位数
        }
        return (this.left.peek() + this.right.peek()!) / 2; // 两堆顶的平均值
    }
}

// 测试
console.log("\n===== 数据流中的中位数 =====");
const mf = new MedianFinder();
for (const num of [1, 3, 2, 5, 4, 6]) {
    mf.addNum(num);
    console.log(`添加 ${num} 后，中位数 = ${mf.findMedian()}`);
}
// 添加1后: 1
// 添加3后: 2
// 添加2后: 2
// 添加5后: 2.5
// 添加4后: 3
// 添加6后: 3.5
```

##### 四、经典例题

```typescript
// ========== 例题1：数组中的第K个最大元素（LeetCode 215） ==========
// 最小堆法：维护大小为 K 的堆，堆顶就是第 K 大
function findKthLargest(nums: number[], k: number): number {
    const minHeap = new MinHeap();
    for (let i = 0; i < k; i++) minHeap.push(nums[i]);
    for (let i = k; i < nums.length; i++) {
        if (nums[i] > minHeap.peek()!) {
            minHeap.replace(nums[i]);
        }
    }
    return minHeap.peek()!;
}

console.log("===== 数组中的第K个最大元素 =====");
console.log(`第2大: ${findKthLargest([3, 2, 1, 5, 6, 4], 2)}`);  // 5

// ========== 例题2：前K个高频元素（LeetCode 347） ==========
// 1. 哈希表统计频率 2. 最小堆维护频率最高的 K 个
function topKFrequent(nums: number[], k: number): number[] {
    // 统计频率
    const count = new Map<number, number>();
    for (const num of nums) {
        count.set(num, (count.get(num) ?? 0) + 1);
    }

    // 最小堆，按 (频率, 元素) 比较
    const freqHeap: Array<[number, number]> = []; // [频率, 元素]

    const pushFreq = (item: [number, number]): void => {
        freqHeap.push(item);
        let i = freqHeap.length - 1;
        while (i > 0) {
            const p = Math.floor((i - 1) / 2);
            if (freqHeap[i][0] >= freqHeap[p][0]) break;
            [freqHeap[i], freqHeap[p]] = [freqHeap[p], freqHeap[i]];
            i = p;
        }
    };

    const popFreq = (): [number, number] => {
        const top = freqHeap[0];
        const last = freqHeap.pop()!;
        if (freqHeap.length > 0) {
            freqHeap[0] = last;
            let i = 0;
            while (true) {
                let smallest = i;
                const l = 2 * i + 1, r = 2 * i + 2;
                if (l < freqHeap.length && freqHeap[l][0] < freqHeap[smallest][0]) smallest = l;
                if (r < freqHeap.length && freqHeap[r][0] < freqHeap[smallest][0]) smallest = r;
                if (smallest === i) break;
                [freqHeap[i], freqHeap[smallest]] = [freqHeap[smallest], freqHeap[i]];
                i = smallest;
            }
        }
        return top;
    };

    // 用最小堆维护频率最高的 K 个
    for (const [num, freq] of count.entries()) {
        if (freqHeap.length < k) {
            pushFreq([freq, num]);
        } else if (freq > freqHeap[0][0]) {
            popFreq();
            pushFreq([freq, num]);
        }
    }

    return freqHeap.map(([, num]) => num);
}

console.log("\n===== 前K个高频元素 =====");
console.log(`前2个高频: ${topKFrequent([1, 1, 1, 2, 2, 3], 2)}`);  // [1, 2]

// ========== 例题3：最后一块石头的重量（LeetCode 1046） ==========
// 用大顶堆：每次取出最大的两个，计算差值，不为 0 就放回去
function lastStoneWeight(stones: number[]): number {
    const maxHeap = new MaxHeap();
    for (const s of stones) maxHeap.push(s);

    while (maxHeap.size > 1) {
        const s1 = maxHeap.pop()!; // 最重的
        const s2 = maxHeap.pop()!; // 第二重的
        if (s1 !== s2) {
            maxHeap.push(s1 - s2); // 把差值放回去
        }
    }
    return maxHeap.size > 0 ? maxHeap.peek()! : 0; // 最后一块石头的重量
}

console.log("\n===== 最后一块石头的重量 =====");
console.log(lastStoneWeight([2, 7, 4, 1, 8, 1]));  // 1
console.log(lastStoneWeight([1]));                 // 1
console.log(lastStoneWeight([2, 2]));              // 0
```

##### 五、堆排序

```typescript
// ========== 堆排序 ==========
// 1. 把数组建成大顶堆（O(n)）
// 2. 每次把堆顶（最大值）和末尾元素交换，对缩小后的堆执行下沉
// 3. 最终数组从小到大排好序
// 时间复杂度：O(n log n)；空间复杂度：O(1)（原地）；不稳定排序
function heapSort(arr: number[]): number[] {
    const n = arr.length;

    // 第一步：建大顶堆（O(n)）
    for (let i = Math.floor(n / 2) - 1; i >= 0; i--) {
        siftDown(arr, n, i);
    }
    console.log(`  建堆后: ${arr}`);

    // 第二步：逐个取出最大值放到末尾
    for (let i = n - 1; i > 0; i--) {
        // 堆顶（最大）和末尾交换
        [arr[0], arr[i]] = [arr[i], arr[0]];
        // 对缩小后的堆执行下沉
        siftDown(arr, i, 0);
        console.log(`  第${n - i}轮: ${arr}`);
    }
    return arr;
}

// 测试
console.log("\n===== 堆排序 =====");
const arr2 = [3, 1, 6, 10, 7, 8, 2, 5];
console.log(`排序前: ${arr2}`);
heapSort(arr2);
console.log(`排序后: ${arr2}`);  // [1, 2, 3, 5, 6, 7, 8, 10]
```

### 主题12 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、大顶堆完整实现

```go
package main

import "fmt"

// ========== 大顶堆（MaxHeap） ==========
// 用数组存储完全二叉树，满足：每个节点 >= 子节点
// 核心公式（下标从0开始）：
//   父节点 = (i-1) / 2，左子 = 2i+1，右子 = 2i+2
type MaxHeap struct {
	heap []int // 用数组存储堆
}

func NewMaxHeap() *MaxHeap {
	return &MaxHeap{heap: []int{}}
}

// 父节点下标
func (h *MaxHeap) parent(i int) int {
	return (i - 1) / 2
}

// 左子节点下标
func (h *MaxHeap) left(i int) int {
	return 2*i + 1
}

// 右子节点下标
func (h *MaxHeap) right(i int) int {
	return 2*i + 2
}

// 交换数组中两个位置的元素
func (h *MaxHeap) swap(i, j int) {
	h.heap[i], h.heap[j] = h.heap[j], h.heap[i]
}

// 上浮操作：将下标 i 的节点向上调整到正确位置
// 场景：插入新元素后调用；不断和父节点比较，比父节点大就交换
func (h *MaxHeap) siftUp(i int) {
	for i > 0 && h.heap[i] > h.heap[h.parent(i)] {
		h.swap(i, h.parent(i))
		i = h.parent(i)
	}
}

// 下沉操作：将下标 i 的节点向下调整到正确位置
// 场景：删除堆顶后调用；不断和较大的子节点比较，比子节点小就交换
func (h *MaxHeap) siftDown(i int) {
	n := len(h.heap)
	for {
		largest := i // 假设当前节点最大
		l := h.left(i)
		r := h.right(i)

		if l < n && h.heap[l] > h.heap[largest] {
			largest = l
		}
		if r < n && h.heap[r] > h.heap[largest] {
			largest = r
		}
		if largest == i {
			break // 当前节点已经是最大的，停止
		}
		h.swap(i, largest) // 交换，继续下沉
		i = largest
	}
}

// 插入元素：放在末尾 → 上浮。时间复杂度 O(log n)
func (h *MaxHeap) push(val int) {
	h.heap = append(h.heap, val) // 放在末尾
	h.siftUp(len(h.heap) - 1)    // 上浮
}

// 删除并返回堆顶元素（最大值）。时间复杂度 O(log n)
func (h *MaxHeap) pop() int {
	if len(h.heap) == 0 {
		panic("堆为空")
	}
	if len(h.heap) == 1 {
		top := h.heap[0]
		h.heap = h.heap[:0]
		return top
	}
	top := h.heap[0]
	h.heap[0] = h.heap[len(h.heap)-1] // 把最后一个元素移到堆顶
	h.heap = h.heap[:len(h.heap)-1]   // 删除最后一个元素
	h.siftDown(0)                     // 下沉调整
	return top
}

// 获取堆顶元素（不删除）。时间复杂度 O(1)
func (h *MaxHeap) peek() int {
	if len(h.heap) == 0 {
		panic("堆为空")
	}
	return h.heap[0]
}

func (h *MaxHeap) size() int {
	return len(h.heap)
}

func (h *MaxHeap) String() string {
	return fmt.Sprintf("MaxHeap(%v)", h.heap)
}

// ===== 完整演示 =====
func testMaxHeap() {
	fmt.Println("===== 大顶堆操作演示 =====")
	heap := NewMaxHeap()

	for _, val := range []int{3, 1, 6, 10, 7, 8, 2, 5} {
		heap.push(val)
		fmt.Printf("插入 %d 后: %s\n", val, heap.String())
	}

	fmt.Printf("\n堆顶（最大值）: %d\n", heap.peek()) // 10

	fmt.Println("\n依次弹出（从大到小）：")
	for heap.size() > 0 {
		fmt.Printf("  弹出: %d\n", heap.pop())
	}
}
```

##### 二、O(n) 建堆（Heapify）

```go
package main

import "fmt"

// 下沉操作（对数组 arr 中下标 i 的节点，堆的大小为 n）
func siftDown(arr []int, n, i int) {
	for {
		largest := i
		l := 2*i + 1
		r := 2*i + 2

		if l < n && arr[l] > arr[largest] {
			largest = l
		}
		if r < n && arr[r] > arr[largest] {
			largest = r
		}
		if largest == i {
			break
		}
		arr[i], arr[largest] = arr[largest], arr[i]
		i = largest
	}
}

// ========== O(n) 建堆（自底向上） ==========
// 从最后一个非叶节点（n/2-1）开始，倒序下沉。
// 为什么是 O(n)？大部分节点在底层，下沉的距离很短。
func heapify(arr []int) []int {
	n := len(arr)
	for i := n/2 - 1; i >= 0; i-- {
		siftDown(arr, n, i)
	}
	return arr
}

// 演示
func testHeapify() {
	fmt.Println("\n===== O(n) 建堆演示 =====")
	arr := []int{3, 1, 6, 10, 7, 8, 2}
	fmt.Printf("原始数组: %v\n", arr)
	heapify(arr)
	fmt.Printf("建堆后:   %v\n", arr) // [10 7 8 3 1 6 2]（满足堆性质）
}
```

##### 三、用 container/heap 实现大顶堆

```go
package main

import (
	"container/heap"
	"fmt"
)

// ========== 用 container/heap 实现 ==========
// Go 标准库 container/heap 默认实现最小堆，
// 我们只需实现 heap.Interface 的五个方法，再反转比较逻辑即可得到大顶堆。

// MaxHeapInt 大顶堆
type MaxHeapInt []int

func (h MaxHeapInt) Len() int           { return len(h) }
func (h MaxHeapInt) Less(i, j int) bool { return h[i] > h[j] } // 注意：大顶堆
func (h MaxHeapInt) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *MaxHeapInt) Push(x interface{}) {
	*h = append(*h, x.(int))
}

func (h *MaxHeapInt) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[:n-1]
	return x
}

// 演示 container/heap 用法
func testContainerHeap() {
	fmt.Println("===== container/heap 大顶堆演示 =====")
	h := &MaxHeapInt{}
	heap.Init(h)

	for _, val := range []int{3, 1, 6, 10, 7} {
		heap.Push(h, val)
	}
	fmt.Println("堆:", *h)

	fmt.Println("依次弹出（从大到小）：")
	for h.Len() > 0 {
		fmt.Printf("  %d\n", heap.Pop(h))
	}
}
```

##### 四、堆的经典应用

```go
package main

import (
	"container/heap"
	"fmt"
	"sort"
)

// ========== 应用1：Top-K 问题 ==========
// 找出数组中最大的 K 个元素：维护一个大小为 K 的最小堆
// 堆顶是堆中最小的，新元素比堆顶小就直接丢弃
type MinHeapInt []int

func (h MinHeapInt) Len() int           { return len(h) }
func (h MinHeapInt) Less(i, j int) bool { return h[i] < h[j] } // 最小堆
func (h MinHeapInt) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *MinHeapInt) Push(x interface{}) {
	*h = append(*h, x.(int))
}

func (h *MinHeapInt) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[:n-1]
	return x
}

func topKLargest(nums []int, k int) []int {
	mh := &MinHeapInt{}
	heap.Init(mh)

	for _, num := range nums {
		if mh.Len() < k {
			heap.Push(mh, num)
		} else if num > (*mh)[0] { // 比堆顶（最小的）大
			(*mh)[0] = num
			heap.Fix(mh, 0) // 弹出堆顶并推入新元素
		}
	}
	// 转成切片并降序返回
	result := make([]int, 0, mh.Len())
	for _, v := range *mh {
		result = append(result, v)
	}
	sort.Sort(sort.Reverse(sort.IntSlice(result)))
	return result
}

func testTopK() {
	fmt.Println("===== Top-K问题 =====")
	nums := []int{3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5}
	fmt.Printf("数组: %v\n", nums)
	fmt.Printf("最大的3个: %v\n", topKLargest(nums, 3)) // [9 6 5]
}

// ========== 应用2：合并K个有序链表 ==========
type ListNode struct {
	Val  int
	Next *ListNode
}

// 链表节点堆（按节点值建立最小堆）
type ListNodeHeap []*ListNode

func (h ListNodeHeap) Len() int           { return len(h) }
func (h ListNodeHeap) Less(i, j int) bool { return h[i].Val < h[j].Val }
func (h ListNodeHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *ListNodeHeap) Push(x interface{}) {
	*h = append(*h, x.(*ListNode))
}

func (h *ListNodeHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[:n-1]
	return x
}

// 把每个链表的头节点放入最小堆，每次取出最小节点，再把它的下一个节点入堆
func mergeKLists(lists []*ListNode) *ListNode {
	dummy := &ListNode{} // 虚拟头节点
	current := dummy
	nh := &ListNodeHeap{}
	heap.Init(nh)

	// 把每个链表的头节点入堆
	for _, head := range lists {
		if head != nil {
			heap.Push(nh, head)
		}
	}

	for nh.Len() > 0 {
		node := heap.Pop(nh).(*ListNode) // 取出最小节点
		current.Next = node
		current = current.Next
		if node.Next != nil {
			heap.Push(nh, node.Next) // 下一个节点入堆
		}
	}
	return dummy.Next
}

func testMergeKLists() {
	fmt.Println("\n===== 合并K个有序链表 =====")
	l1 := &ListNode{Val: 1, Next: &ListNode{Val: 4, Next: &ListNode{Val: 5}}}
	l2 := &ListNode{Val: 1, Next: &ListNode{Val: 3, Next: &ListNode{Val: 4}}}
	l3 := &ListNode{Val: 2, Next: &ListNode{Val: 6}}

	merged := mergeKLists([]*ListNode{l1, l2, l3})
	result := []int{}
	for cur := merged; cur != nil; cur = cur.Next {
		result = append(result, cur.Val)
	}
	fmt.Printf("合并结果: %v\n", result) // [1 1 2 3 4 4 5 6]
}

// ========== 应用3：数据流中的中位数 ==========
// 用两个堆：
// - 大顶堆 left：存较小的一半（堆顶是左半部分的最大值）
// - 小顶堆 right：存较大的一半（堆顶是右半部分的最小值）
type MedianFinder struct {
	left  *MaxHeapInt // 大顶堆：存较小的一半
	right *MinHeapInt // 小顶堆：存较大的一半
}

func NewMedianFinder() *MedianFinder {
	left := &MaxHeapInt{}
	right := &MinHeapInt{}
	heap.Init(left)
	heap.Init(right)
	return &MedianFinder{left: left, right: right}
}

// 添加一个数，时间复杂度 O(log n)
func (m *MedianFinder) addNum(num int) {
	// 先放入大顶堆
	heap.Push(m.left, num)
	// 平衡：确保 left 的最大值 <= right 的最小值
	heap.Push(m.right, heap.Pop(m.left))
	// 平衡：确保 left 的大小 >= right 的大小，且最多多 1
	if m.left.Len() < m.right.Len() {
		heap.Push(m.left, heap.Pop(m.right))
	}
}

// 获取中位数，时间复杂度 O(1)
func (m *MedianFinder) findMedian() float64 {
	if m.left.Len() > m.right.Len() {
		return float64((*m.left)[0]) // left 多一个，堆顶就是中位数
	}
	return (float64((*m.left)[0]) + float64((*m.right)[0])) / 2 // 两堆顶的平均值
}

func testMedianFinder() {
	fmt.Println("\n===== 数据流中的中位数 =====")
	mf := NewMedianFinder()
	for _, num := range []int{1, 3, 2, 5, 4, 6} {
		mf.addNum(num)
		fmt.Printf("添加 %d 后，中位数 = %.1f\n", num, mf.findMedian())
	}
}
```

##### 五、经典例题

```go
package main

import (
	"container/heap"
	"fmt"
)

// ========== 例题1：数组中的第K个最大元素（LeetCode 215） ==========
// 最小堆法：维护大小为 K 的堆，堆顶就是第 K 大
func findKthLargest(nums []int, k int) int {
	mh := &MinHeapInt{}
	heap.Init(mh)

	for i := 0; i < k; i++ {
		heap.Push(mh, nums[i])
	}
	for i := k; i < len(nums); i++ {
		if nums[i] > (*mh)[0] {
			(*mh)[0] = nums[i]
			heap.Fix(mh, 0)
		}
	}
	return (*mh)[0]
}

func testKthLargest() {
	fmt.Println("===== 数组中的第K个最大元素 =====")
	fmt.Printf("第2大: %d\n", findKthLargest([]int{3, 2, 1, 5, 6, 4}, 2)) // 5
}

// ========== 例题2：前K个高频元素（LeetCode 347） ==========
// 1. 哈希表统计频率 2. 最小堆维护频率最高的 K 个
type FreqItem struct {
	freq int
	num  int
}

type FreqHeap []FreqItem

func (h FreqHeap) Len() int           { return len(h) }
func (h FreqHeap) Less(i, j int) bool { return h[i].freq < h[j].freq } // 按频率最小堆
func (h FreqHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *FreqHeap) Push(x interface{}) {
	*h = append(*h, x.(FreqItem))
}

func (h *FreqHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[:n-1]
	return x
}

func topKFrequent(nums []int, k int) []int {
	// 统计频率
	count := make(map[int]int)
	for _, num := range nums {
		count[num]++
	}

	// 用最小堆维护频率最高的 K 个
	fh := &FreqHeap{}
	heap.Init(fh)
	for num, freq := range count {
		if fh.Len() < k {
			heap.Push(fh, FreqItem{freq: freq, num: num})
		} else if freq > (*fh)[0].freq {
			(*fh)[0] = FreqItem{freq: freq, num: num}
			heap.Fix(fh, 0)
		}
	}

	result := make([]int, 0, fh.Len())
	for _, item := range *fh {
		result = append(result, item.num)
	}
	return result
}

func testTopKFrequent() {
	fmt.Println("\n===== 前K个高频元素 =====")
	fmt.Printf("前2个高频: %v\n", topKFrequent([]int{1, 1, 1, 2, 2, 3}, 2)) // [1 2]
}

// ========== 例题3：最后一块石头的重量（LeetCode 1046） ==========
// 用大顶堆：每次取出最大的两个，计算差值，不为 0 就放回去
func lastStoneWeight(stones []int) int {
	mh := &MaxHeapInt{}
	heap.Init(mh)
	for _, s := range stones {
		heap.Push(mh, s)
	}

	for mh.Len() > 1 {
		s1 := heap.Pop(mh).(int) // 最重的
		s2 := heap.Pop(mh).(int) // 第二重的
		if s1 != s2 {
			heap.Push(mh, s1-s2) // 把差值放回去
		}
	}
	if mh.Len() == 0 {
		return 0 // 没有剩余石头
	}
	return (*mh)[0] // 最后一块石头的重量
}

func testLastStone() {
	fmt.Println("\n===== 最后一块石头的重量 =====")
	fmt.Println(lastStoneWeight([]int{2, 7, 4, 1, 8, 1})) // 1
	fmt.Println(lastStoneWeight([]int{1}))                // 1
	fmt.Println(lastStoneWeight([]int{2, 2}))             // 0
}
```

##### 六、堆排序

```go
package main

import "fmt"

// ========== 堆排序 ==========
// 1. 把数组建成大顶堆（O(n)）
// 2. 每次把堆顶（最大值）和末尾元素交换，对缩小后的堆执行下沉
// 3. 最终数组从小到大排好序
// 时间复杂度：O(n log n)；空间复杂度：O(1)（原地）；不稳定排序
func heapSort(arr []int) []int {
	n := len(arr)

	// 第一步：建大顶堆（O(n)）
	for i := n/2 - 1; i >= 0; i-- {
		siftDown(arr, n, i)
	}
	fmt.Printf("  建堆后: %v\n", arr)

	// 第二步：逐个取出最大值放到末尾
	for i := n - 1; i > 0; i-- {
		arr[0], arr[i] = arr[i], arr[0] // 堆顶（最大）和末尾交换
		siftDown(arr, i, 0)             // 对缩小后的堆执行下沉
		fmt.Printf("  第%d轮: %v\n", n-i, arr)
	}
	return arr
}

func testHeapSort() {
	fmt.Println("\n===== 堆排序 =====")
	arr := []int{3, 1, 6, 10, 7, 8, 2, 5}
	fmt.Printf("排序前: %v\n", arr)
	heapSort(arr)
	fmt.Printf("排序后: %v\n", arr) // [1 2 3 5 6 7 8 10]
}
```

---
## 第五阶段：中级算法

---

### 主题13：分治法（Divide and Conquer）


#### 一、分治的思想

##### 什么是分治？

**分治**，顾名思义，就是"分而治之"。把一个大规模的问题拆成若干个小问题，逐个解决后，再把结果合并起来。

##### 生活类比：数一堆硬币

想象你面前有一大堆硬币（比如 1000 枚），你要数清楚总共有多少枚。

**笨办法**：一枚一枚数，数到眼花。

**分治办法**：
1. **分**：把硬币堆分成两小堆
2. **治**：对每一小堆，再分成更小的堆……一直分到每堆只有几枚，一眼就能看出来
3. **合**：把每小堆的数量逐层加起来，得到总数

这就是分治！核心思想是：**大事化小，小事化了，最后汇总**。

##### 再举一个例子

你要打扫一栋 10 层的大楼：
- 你不需要一口气打扫完，而是**每层分配给一个人**
- 每个人各自打扫自己那一层
- 最后检查一遍就行了

这就是"分而治之"。

---

#### 二、分治三步走

分治算法永远遵循三个步骤：

```
┌─────────────────────────────────────┐
│  1. 分解（Divide）                    │
│     把原问题拆成若干规模更小的子问题    │
│                                       │
│  2. 解决（Conquer）                   │
│     递归地解决每个子问题               │
│     （子问题小到一定程度可以直接解决）   │
│                                       │
│  3. 合并（Combine）                   │
│     把子问题的解合并成原问题的解        │
└─────────────────────────────────────┘
```

##### 伪代码框架

```python
def divide_and_conquer(问题):
    # 基线条件：问题足够小，直接解决
    if 问题足够小:
        return 直接求解(问题)
    
    # 第一步：分解
    子问题们 = 拆分(问题)
    
    # 第二步：解决（递归）
    子问题的解 = [divide_and_conquer(子问题) for 子问题 in 子问题们]
    
    # 第三步：合并
    return 合并(子问题的解)
```

---

#### 三、分治与递归的关系

> **分治和递归是一对孪生兄弟。**

- **递归**是一种编程技巧：函数调用自身
- **分治**是一种算法思想：把大问题拆成小问题

分治法几乎总是用递归来实现——因为"拆分后的小问题"和"原问题是同一类型"，所以自然地用递归解决。

##### 类比

- 递归 = "套娃"（大娃娃里套小娃娃）
- 分治 = "分工合作"（大任务拆成小任务，每人做一个）
- 分治 + 递归 = "把大任务不断拆分，直到每个人都能轻松完成"

---

#### 四、已学过的分治例子：归并排序

归并排序是分治法的经典代表。

##### 思路

```
原始数组: [38, 27, 43, 3, 9, 82, 10]

第一步【分解】: 从中间劈成两半
    左半: [38, 27, 43, 3]    右半: [9, 82, 10]

第二步【解决】: 递归地对每一半排序
    左半排好: [3, 27, 38, 43]    右半排好: [9, 10, 82]

第三步【合并】: 把两个有序数组合并成一个
    结果: [3, 9, 10, 27, 38, 43, 82]
```

##### Python 实现

```python
def merge_sort(arr):
    """归并排序 —— 分治法的经典应用"""
    
    # 基线条件：数组长度 <= 1 时，已经有序，直接返回
    if len(arr) <= 1:
        return arr
    
    # ===== 第一步：分解 =====
    # 找到中间位置，把数组分成两半
    mid = len(arr) // 2
    left_half = arr[:mid]    # 左半部分
    right_half = arr[mid:]   # 右半部分
    
    # ===== 第二步：解决（递归排序） =====
    left_sorted = merge_sort(left_half)   # 递归排序左半
    right_sorted = merge_sort(right_half) # 递归排序右半
    
    # ===== 第三步：合并 =====
    return merge(left_sorted, right_sorted)


def merge(left, right):
    """将两个有序数组合并成一个有序数组"""
    result = []
    i = j = 0
    
    # 比较两个数组的元素，从小到大放入结果
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    
    # 把剩余元素追加到结果末尾
    result.extend(left[i:])
    result.extend(right[j:])
    
    return result


# 测试
arr = [38, 27, 43, 3, 9, 82, 10]
print(f"排序前: {arr}")
print(f"排序后: {merge_sort(arr)}")
# 输出: 排序后: [3, 9, 10, 27, 38, 43, 82]
```

##### 分治视角分析

| 步骤 | 归并排序中的操作 |
|------|-----------------|
| 分解 | 从中间把数组切成两半 |
| 解决 | 递归地对两半分别排序 |
| 合并 | 把两个有序数组合并成一个 |

---

#### 五、用分治解决问题

##### 5.1 快速幂运算 x^n

###### 问题描述

计算 x 的 n 次方（x^n），其中 n 是非负整数。

###### 笨办法

x^n = x × x × x × ... × x（乘 n 次），时间复杂度 O(n)。

###### 分治思路

关键观察：

```
x^8 = (x^4)^2        -- 把问题规模减半！
x^4 = (x^2)^2
x^2 = (x^1)^2
x^1 = x

x^n 当 n 为偶数时: x^n = (x^(n/2))^2
x^n 当 n 为奇数时: x^n = x * (x^(n/2))^2    （多乘一个 x）
```

###### 详细推导

以 x^10 为例：

```
x^10 = (x^5)^2                          -- 10 是偶数，折半
x^5  = x * (x^2)^2                      -- 5 是奇数，拆出 x
x^2  = (x^1)^2                          -- 2 是偶数，折半
x^1  = x                                -- 基线条件

回代:
x^2  = x^2
x^5  = x * (x^2)^2 = x * x^4 = x^5
x^10 = (x^5)^2 = x^10
```

原本要乘 10 次，现在只需要 4 步！

###### Python 实现

```python
def fast_power(x, n):
    """
    快速幂运算：计算 x^n
    时间复杂度: O(log n)，因为每次 n 都减半
    空间复杂度: O(log n)，递归调用栈深度
    """
    # 基线条件
    if n == 0:
        return 1.0        # 任何数的 0 次方都是 1
    
    # 递归计算 x^(n//2)
    half = fast_power(x, n // 2)
    
    # 根据 n 的奇偶性合并结果
    if n % 2 == 0:
        # n 是偶数: x^n = (x^(n/2))^2
        return half * half
    else:
        # n 是奇数: x^n = x * (x^(n/2))^2
        return x * half * half


# 测试
print(fast_power(2, 10))  # 1024
print(fast_power(3, 5))   # 243
print(fast_power(2, 0))   # 1
```

###### 迭代版本（更高效）

```python
def fast_power_iterative(x, n):
    """
    快速幂的迭代版本
    核心思想：把 n 写成二进制，逐位处理
    
    例如 2^10:  10 的二进制是 1010
    2^10 = 2^8 * 2^2
    """
    if n < 0:
        x = 1 / x
        n = -n
    
    result = 1.0
    current = x  # current 依次表示 x^1, x^2, x^4, x^8, ...
    
    while n > 0:
        # 如果当前二进制位是 1，就乘上对应的幂
        if n % 2 == 1:
            result *= current
        
        # current 翻倍: x^1 -> x^2 -> x^4 -> x^8 -> ...
        current *= current
        # n 右移一位（整除 2）
        n //= 2
    
    return result


# 测试
print(fast_power_iterative(2, 10))  # 1024
print(fast_power_iterative(3, 5))   # 243
```

###### 执行过程图解（2^10）

```
n=10 (偶数)  →  half = fast_power(2, 5)
  n=5 (奇数)   →  half = fast_power(2, 2)
    n=2 (偶数)  →  half = fast_power(2, 1)
      n=1 (奇数) →  half = fast_power(2, 0)
        n=0      →  return 1          ← 基线条件
      return 2 * 1 * 1 = 2            ← x^1 = 2
    return 2 * 2 = 4                  ← x^2 = 4
  return 2 * 4 * 4 = 32              ← x^5 = 32
return 32 * 32 = 1024                ← x^10 = 1024
```

---

##### 5.2 多数元素（Majority Element）

###### 问题描述

给定一个大小为 n 的数组，找到其中的**多数元素**。多数元素是指在数组中出现次数**大于 ⌊n/2⌋** 的元素。

你可以假设数组非空，且一定存在多数元素。

```
输入: [2, 2, 1, 1, 1, 2, 2]
输出: 2
解释: 2 出现了 4 次，数组长度 7，⌊7/2⌋ = 3，4 > 3，所以 2 是多数元素
```

###### 分治解法思路

**关键性质**：如果数组分成两半，多数元素在其中至少一半里仍然是多数元素。

```
原数组: [2, 2, 1, 1, 1, 2, 2]  → 多数元素是 2

分成两半:
  左半: [2, 2, 1]    → 多数元素是 2（出现 2 次 > ⌊3/2⌋=1）
  右半: [1, 1, 2, 2] → 没有多数元素（2 和 1 各出现 2 次）

递归求解后，合并时比较两个候选者在整个数组中的出现次数
```

###### Python 实现

```python
def majority_element_divide_conquer(nums):
    """
    多数元素 —— 分治法
    时间复杂度: O(n log n)
    空间复杂度: O(log n)（递归栈）
    """
    
    def _majority(lo, hi):
        """在 nums[lo:hi+1] 中找多数元素"""
        
        # 基线条件：只有一个元素，它本身就是多数元素
        if lo == hi:
            return nums[lo]
        
        # ===== 分解 =====
        mid = (lo + hi) // 2
        
        # ===== 解决（递归） =====
        left_majority = _majority(lo, mid)       # 左半的多数元素
        right_majority = _majority(mid + 1, hi)  # 右半的多数元素
        
        # ===== 合并 =====
        # 如果两边结果相同，直接返回
        if left_majority == right_majority:
            return left_majority
        
        # 如果不同，统计两个候选者在整个区间中的出现次数
        left_count = sum(1 for i in range(lo, hi + 1) if nums[i] == left_majority)
        right_count = sum(1 for i in range(lo, hi + 1) if nums[i] == right_majority)
        
        # 返回出现次数更多的那个
        return left_majority if left_count > right_count else right_majority
    
    return _majority(0, len(nums) - 1)


# 测试
nums = [2, 2, 1, 1, 1, 2, 2]
print(f"多数元素: {majority_element_divide_conquer(nums)}")  # 输出: 2
```

> **注意**：多数元素还有更优的 O(n) 解法（Boyer-Moore 投票算法），但分治法很好地展示了分治思想。

---

##### 5.3 最大子数组和问题（分治解法）

###### 问题描述

给定一个整数数组 `nums`，找到一个具有最大和的**连续子数组**，返回其最大和。

```
输入: [-2, 1, -3, 4, -1, 2, 1, -5, 4]
输出: 6
解释: 连续子数组 [4, -1, 2, 1] 的和最大，为 6
```

###### 分治思路

把数组从中间分成两半，最大子数组和只可能在三个地方：

```
数组: [-2, 1, -3, | 4, -1, 2, 1, -5, 4]
                ↑ mid

情况1: 最大子数组完全在左半部分  → 递归求解
情况2: 最大子数组完全在右半部分  → 递归求解
情况3: 最大子数组跨越中间        → 需要特殊处理

对于情况3，我们需要知道：
  - 左半部分包含右端点的最大后缀和
  - 右半部分包含左端点的最大前缀和
  两者相加就是跨越中间的最大子数组和
```

###### Python 实现

```python
def max_subarray_divide_conquer(nums):
    """
    最大子数组和 —— 分治法
    时间复杂度: O(n log n)
    
    返回 (最大子数组和, 最大前缀和, 最大后缀和, 总和)
    """
    
    def _solve(lo, hi):
        """
        返回四个值:
        - max_sum:     该区间内的最大子数组和
        - max_prefix:  包含左端点的最大前缀和
        - max_suffix:  包含右端点的最大后缀和
        - total_sum:   整个区间的总和
        """
        
        # 基线条件：只有一个元素
        if lo == hi:
            val = nums[lo]
            # 最大子数组和、最大前缀和、最大后缀和都至少是这个元素本身
            return max(val, 0), max(val, 0), max(val, 0), val
        
        mid = (lo + hi) // 2
        
        # 递归求解左半和右半
        l_max, l_pre, l_suf, l_total = _solve(lo, mid)
        r_max, r_pre, r_suf, r_total = _solve(mid + 1, hi)
        
        # ===== 合并 =====
        
        # 跨越中间的最大子数组 = 左半的最大后缀 + 右半的最大前缀
        cross_max = l_suf + r_pre
        
        # 三种情况取最大值
        max_sum = max(l_max, r_max, cross_max)
        
        # 最大前缀和：要么完全在左半，要么包含整个左半 + 右半的前缀
        max_prefix = max(l_pre, l_total + r_pre)
        
        # 最大后缀和：要么完全在右半，要么包含整个右半 + 左半的后缀
        max_suffix = max(r_suf, r_total + l_suf)
        
        # 总和
        total_sum = l_total + r_total
        
        return max_sum, max_prefix, max_suffix, total_sum
    
    if not nums:
        return 0
    
    # 处理全负数的情况
    if all(x < 0 for x in nums):
        return max(nums)
    
    result, _, _, _ = _solve(0, len(nums) - 1)
    return result


# 测试
nums = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
print(f"最大子数组和: {max_subarray_divide_conquer(nums)}")  # 输出: 6
```

> **铺垫**：这个问题用动态规划（Kadane 算法）可以 O(n) 解决，后面会学到。分治解法帮助我们理解两种方法的联系。

---

#### 六、分治法的复杂度分析：主定理简介

##### 什么是主定理？

主定理（Master Theorem）是分析分治算法复杂度的"公式"。

对于形如这样的递推关系：

```
T(n) = a · T(n/b) + O(n^d)
```

其中：
- `a` = 子问题的个数（每次递归分成几个子问题）
- `n/b` = 每个子问题的规模
- `O(n^d)` = 合并步骤的代价

##### 主定理的三种情况

```
比较 log_b(a) 和 d 的大小:

情况1: log_b(a) < d  →  T(n) = O(n^d)       合并代价主导
情况2: log_b(a) = d  →  T(n) = O(n^d · log n) 两者平衡
情况3: log_b(a) > d  →  T(n) = O(n^log_b(a))  递归代价主导
```

##### 用主定理分析归并排序

```
归并排序的递推关系:
T(n) = 2 · T(n/2) + O(n)

a = 2（分成 2 个子问题）
b = 2（每个子问题规模是 n/2）
d = 1（合并需要 O(n)）

log_2(2) = 1 = d  →  情况2

所以 T(n) = O(n^1 · log n) = O(n log n)
```

##### 用主定理分析快速幂

```
快速幂的递推关系:
T(n) = 1 · T(n/2) + O(1)

a = 1（只有 1 个子问题）
b = 2（规模减半）
d = 0（合并只需要 O(1) 的乘法）

log_2(1) = 0 = d  →  情况2

所以 T(n) = O(n^0 · log n) = O(log n)
```

---

#### 七、分治 vs 动态规划

这是面试中非常重要的概念区分：

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│   分治法                    动态规划                      │
│                                                        │
│   子问题互不重叠              子问题互相重叠                │
│   每个子问题只算一次           同一个子问题会被反复遇到       │
│   用递归即可                  用递归 + 记忆化（或递推）      │
│                                                        │
│   例子: 归并排序              例子: 斐波那契数列            │
│   左半和右半完全独立           fib(5) 需要 fib(4) 和       │
│                              fib(3)，但它们共享 fib(2)    │
│                                                        │
└────────────────────────────────────────────────────────┘
```

##### 图解对比

```
分治（归并排序）的递归树：
         [0..7]
        /      \
    [0..3]    [4..7]      ← 左右互不重叠，独立求解
    /   \      /   \
 [0..1][2..3][4..5][6..7]

动态规划（斐波那契）的递归树：
          fib(5)
         /      \
     fib(4)    fib(3)      ← 它们共享子问题！
     /   \      /   \
 fib(3) fib(2) fib(2) fib(1)
                    ↑
              fib(2) 被计算了两次！
              如果用记忆化，第二次直接查表即可
```

##### 一句话总结

> **分治的子问题是独立的，动态规划的子问题是重叠的。**
> 如果子问题重叠还用分治，就会重复计算，效率低下。动态规划通过"记住"已解决的子问题来避免重复。

---

#### 八、经典例题

##### 例题1：Pow(x, n)（LeetCode 50）

###### 题目

实现 `pow(x, n)`，即计算 x 的 n 次方。

###### 解题思路

就是前面讲的快速幂。需要注意：
1. n 可能是负数
2. n 可能是 INT_MIN（取绝对值会溢出，用 Python 不用担心）

###### Python 实现

```python
def myPow(x: float, n: int) -> float:
    """
    LeetCode 50: Pow(x, n)
    使用分治（快速幂）实现
    时间复杂度: O(log n)
    """
    # 处理负指数
    if n < 0:
        x = 1 / x
        n = -n
    
    # 快速幂核心逻辑
    def fast_pow(base, exp):
        # 基线条件
        if exp == 0:
            return 1.0
        
        # 递归求解 base^(exp//2)
        half = fast_pow(base, exp // 2)
        
        # 合并
        if exp % 2 == 0:
            return half * half
        else:
            return base * half * half
    
    return fast_pow(x, n)


# 测试
print(myPow(2.0, 10))    # 1024.0
print(myPow(2.1, 3))     # 9.261000000000001
print(myPow(2.0, -2))    # 0.25
```

---

##### 例题2：多数元素（LeetCode 169）

前面已经给出了分治解法，这里补充一个更优雅的解法作为对比：

```python
def majorityElement(nums):
    """
    LeetCode 169: 多数元素
    Boyer-Moore 投票算法（O(n) 时间，O(1) 空间）
    
    类比：候选人PK，每个元素是一票
    相同的票 +1，不同的票 -1
    因为多数元素超过一半，最后剩下的一定是它
    """
    candidate = None  # 当前候选人
    count = 0         # 当前候选人的票数
    
    for num in nums:
        if count == 0:
            # 没人了，换一个新的候选人
            candidate = num
            count = 1
        elif num == candidate:
            # 投了当前候选人一票
            count += 1
        else:
            # 投了反对票
            count -= 1
    
    return candidate


# 测试
print(majorityElement([2, 2, 1, 1, 1, 2, 2]))  # 2
print(majorityElement([3, 3, 4]))                # 3
```

---

##### 例题3：翻转字符串中的单词

###### 题目

给定一个字符串 `s`，翻转字符串中每个单词的字符顺序，同时保留空格和单词的原始顺序。

```
输入: "Let's take LeetCode contest"
输出: "s'teL ekat edoCteeL tsetnoc"
```

###### 解题思路

这道题其实可以看作一个微型分治：
- **分解**：按空格拆分成单词
- **解决**：翻转每个单词
- **合并**：重新拼接

```python
def reverseWords(s: str) -> str:
    """
    翻转字符串中每个单词
    思路：拆分 → 逐个翻转 → 合并
    """
    # 分解：按空格拆分成单词列表
    words = s.split(' ')
    
    # 解决 + 合并：翻转每个单词，然后用空格连接
    return ' '.join(word[::-1] for word in words)


# 测试
s = "Let's take LeetCode contest"
print(reverseWords(s))
# 输出: "s'teL ekat edoCteeL tsetnoc"
```

###### 手动实现（不依赖内置函数）

```python
def reverseWords_manual(s: str) -> str:
    """
    手动实现翻转单词，展示分治的完整过程
    """
    # 先把整个字符串翻转
    s = list(s)  # 字符串不可变，转成列表
    
    # 翻转整个列表的辅助函数
    def reverse(arr, left, right):
        while left < right:
            arr[left], arr[right] = arr[right], arr[left]
            left += 1
            right -= 1
    
    n = len(s)
    
    # 第一步：翻转整个字符串
    reverse(s, 0, n - 1)
    
    # 第二步：逐个翻转每个单词（分治的"解决"步骤）
    start = 0
    for end in range(n + 1):
        # 找到单词的边界
        if end == n or s[end] == ' ':
            # 翻转当前这个单词
            reverse(s, start, end - 1)
            start = end + 1  # 下一个单词的起始位置
    
    return ''.join(s)


# 测试
s = "Let's take LeetCode contest"
print(reverseWords_manual(s))
# 输出: "s'teL ekat edoCteeL tsetnoc"
```

---

#### 九、分治法总结

##### 核心要点

1. **什么时候用分治？**
   - 问题可以分解成独立的子问题
   - 子问题和原问题是同一类型
   - 子问题的解可以合并成原问题的解

2. **分治的模板**
   ```python
   def divide_and_conquer(problem):
       if is_base_case(problem):
           return solve_directly(problem)
       
       sub_problems = divide(problem)
       sub_solutions = [divide_and_conquer(sp) for sp in sub_problems]
       return combine(sub_solutions)
   ```

3. **复杂度分析**
   - 画递归树，数每层的工作量
   - 用主定理快速判断

4. **分治 vs 动态规划**
   - 子问题独立 → 分治
   - 子问题重叠 → 动态规划

---

### 主题13 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、归并排序（分治法的经典代表）

```typescript
// ========== 归并排序 ==========
// 分治三步：分解 → 解决（递归） → 合并

// 将两个有序数组合并成一个有序数组
function merge(left: number[], right: number[]): number[] {
    const result: number[] = [];
    let i = 0;
    let j = 0;

    // 比较两个数组的元素，从小到大放入结果
    while (i < left.length && j < right.length) {
        if (left[i] <= right[j]) {
            result.push(left[i]);
            i++;
        } else {
            result.push(right[j]);
            j++;
        }
    }
    // 把剩余元素追加到结果末尾
    while (i < left.length) result.push(left[i++]);
    while (j < right.length) result.push(right[j++]);
    return result;
}

function mergeSort(arr: number[]): number[] {
    // 基线条件：数组长度 <= 1 时，已经有序
    if (arr.length <= 1) return arr;

    // ===== 第一步：分解 =====
    const mid = Math.floor(arr.length / 2);
    const leftHalf = arr.slice(0, mid);    // 左半部分
    const rightHalf = arr.slice(mid);      // 右半部分

    // ===== 第二步：解决（递归排序） =====
    const leftSorted = mergeSort(leftHalf);
    const rightSorted = mergeSort(rightHalf);

    // ===== 第三步：合并 =====
    return merge(leftSorted, rightSorted);
}

// 测试
const arr13 = [38, 27, 43, 3, 9, 82, 10];
console.log(`排序前: ${arr13}`);
console.log(`排序后: ${mergeSort(arr13)}`);  // [3, 9, 10, 27, 38, 43, 82]
```

##### 二、快速幂运算 x^n

```typescript
// ========== 快速幂（递归版） ==========
// 时间复杂度: O(log n)，因为每次 n 都减半
function fastPower(x: number, n: number): number {
    // 基线条件
    if (n === 0) return 1.0; // 任何数的 0 次方都是 1

    // 递归计算 x^(n//2)
    const half = fastPower(x, Math.floor(n / 2));

    // 根据 n 的奇偶性合并结果
    if (n % 2 === 0) {
        return half * half;        // n 是偶数: x^n = (x^(n/2))^2
    } else {
        return x * half * half;    // n 是奇数: x^n = x * (x^(n/2))^2
    }
}

// ========== 快速幂（迭代版，更高效） ==========
// 核心思想：把 n 写成二进制，逐位处理
// 例如 2^10: 10 的二进制是 1010 → 2^10 = 2^8 * 2^2
function fastPowerIterative(x: number, n: number): number {
    if (n < 0) {
        x = 1 / x;
        n = -n;
    }

    let result = 1.0;
    let current = x; // current 依次表示 x^1, x^2, x^4, x^8, ...

    while (n > 0) {
        // 如果当前二进制位是 1，就乘上对应的幂
        if (n % 2 === 1) {
            result *= current;
        }
        // current 翻倍: x^1 -> x^2 -> x^4 -> x^8 -> ...
        current *= current;
        n = Math.floor(n / 2); // n 右移一位（整除 2）
    }
    return result;
}

// 测试
console.log(fastPower(2, 10));           // 1024
console.log(fastPower(3, 5));            // 243
console.log(fastPower(2, 0));            // 1
console.log(fastPowerIterative(2, 10));  // 1024
console.log(fastPowerIterative(3, 5));   // 243
```

##### 三、多数元素（分治解法 + 摩尔投票）

```typescript
// ========== 多数元素 —— 分治法 ==========
// 关键性质：如果数组分成两半，多数元素在其中至少一半里仍然是多数元素
function majorityElementDivideConquer(nums: number[]): number {
    // 在 nums[lo:hi+1] 中找多数元素
    const majority = (lo: number, hi: number): number => {
        // 基线条件：只有一个元素，它本身就是多数元素
        if (lo === hi) return nums[lo];

        // ===== 分解 =====
        const mid = Math.floor((lo + hi) / 2);

        // ===== 解决（递归） =====
        const leftMajority = majority(lo, mid);       // 左半的多数元素
        const rightMajority = majority(mid + 1, hi);  // 右半的多数元素

        // ===== 合并 =====
        // 如果两边结果相同，直接返回
        if (leftMajority === rightMajority) return leftMajority;

        // 如果不同，统计两个候选者在整个区间中的出现次数
        let leftCount = 0, rightCount = 0;
        for (let i = lo; i <= hi; i++) {
            if (nums[i] === leftMajority) leftCount++;
            if (nums[i] === rightMajority) rightCount++;
        }
        // 返回出现次数更多的那个
        return leftCount > rightCount ? leftMajority : rightMajority;
    };

    return majority(0, nums.length - 1);
}

// ========== 多数元素 —— Boyer-Moore 投票算法（O(n) 时间，O(1) 空间） ==========
// 类比：候选人PK，相同的票 +1，不同的票 -1
function majorityElementVoting(nums: number[]): number | null {
    let candidate: number | null = null;
    let count = 0;

    for (const num of nums) {
        if (count === 0) {
            candidate = num; // 没人了，换一个新的候选人
            count = 1;
        } else if (num === candidate) {
            count++; // 投了当前候选人一票
        } else {
            count--; // 投了反对票
        }
    }
    return candidate;
}

// 测试
console.log(`多数元素(分治): ${majorityElementDivideConquer([2, 2, 1, 1, 1, 2, 2])}`);  // 2
console.log(`多数元素(投票): ${majorityElementVoting([2, 2, 1, 1, 1, 2, 2])}`);        // 2
```

##### 四、最大子数组和（分治解法）

```typescript
// ========== 最大子数组和 —— 分治法 ==========
// 返回 (最大子数组和, 最大前缀和, 最大后缀和, 总和)
function maxSubarrayDivideConquer(nums: number[]): number {
    interface Result {
        maxSum: number;     // 该区间内的最大子数组和
        maxPrefix: number;  // 包含左端点的最大前缀和
        maxSuffix: number;  // 包含右端点的最大后缀和
        totalSum: number;   // 整个区间的总和
    }

    const solve = (lo: number, hi: number): Result => {
        // 基线条件：只有一个元素
        if (lo === hi) {
            const val = nums[lo];
            // 最大子数组和、最大前缀和、最大后缀和都至少是这个元素本身
            return {
                maxSum: Math.max(val, 0),
                maxPrefix: Math.max(val, 0),
                maxSuffix: Math.max(val, 0),
                totalSum: val,
            };
        }

        const mid = Math.floor((lo + hi) / 2);

        // 递归求解左半和右半
        const l = solve(lo, mid);
        const r = solve(mid + 1, hi);

        // ===== 合并 =====
        // 跨越中间的最大子数组 = 左半的最大后缀 + 右半的最大前缀
        const crossMax = l.maxSuffix + r.maxPrefix;

        // 三种情况取最大值
        const maxSum = Math.max(l.maxSum, r.maxSum, crossMax);

        // 最大前缀和：要么完全在左半，要么包含整个左半 + 右半的前缀
        const maxPrefix = Math.max(l.maxPrefix, l.totalSum + r.maxPrefix);

        // 最大后缀和：要么完全在右半，要么包含整个右半 + 左半的后缀
        const maxSuffix = Math.max(r.maxSuffix, r.totalSum + l.maxSuffix);

        // 总和
        const totalSum = l.totalSum + r.totalSum;

        return { maxSum, maxPrefix, maxSuffix, totalSum };
    };

    if (nums.length === 0) return 0;

    // 处理全负数的情况
    if (nums.every((x) => x < 0)) return Math.max(...nums);

    return solve(0, nums.length - 1).maxSum;
}

// 测试
const nums13 = [-2, 1, -3, 4, -1, 2, 1, -5, 4];
console.log(`最大子数组和: ${maxSubarrayDivideConquer(nums13)}`);  // 6
```

##### 五、经典例题

```typescript
// ========== 例题1：Pow(x, n)（LeetCode 50） ==========
// 使用分治（快速幂）实现，注意处理负指数
function myPow(x: number, n: number): number {
    // 处理负指数
    if (n < 0) {
        x = 1 / x;
        n = -n;
    }

    // 快速幂核心逻辑
    const fastPow = (base: number, exp: number): number => {
        if (exp === 0) return 1.0; // 基线条件

        const half = fastPow(base, Math.floor(exp / 2)); // 递归求解 base^(exp//2)
        return exp % 2 === 0 ? half * half : base * half * half; // 合并
    };

    return fastPow(x, n);
}

console.log("===== Pow(x, n) =====");
console.log(myPow(2.0, 10));  // 1024
console.log(myPow(2.1, 3));   // 9.261000000000001
console.log(myPow(2.0, -2));  // 0.25

// ========== 例题3：翻转字符串中的单词 ==========
// 思路：拆分 → 逐个翻转 → 合并（微型分治）
function reverseWords(s: string): string {
    // 分解：按空格拆分成单词列表
    const words = s.split(" ");
    // 解决 + 合并：翻转每个单词，然后用空格连接
    return words.map((word) => word.split("").reverse().join("")).join(" ");
}

// 手动实现（不依赖内置函数），展示分治的完整过程
function reverseWordsManual(s: string): string {
    const arr = s.split(""); // 字符串转数组

    // 翻转数组片段 [left, right] 的辅助函数
    const reverse = (arr: string[], left: number, right: number): void => {
        while (left < right) {
            [arr[left], arr[right]] = [arr[right], arr[left]];
            left++;
            right--;
        }
    };

    const n = arr.length;

    // 第一步：翻转整个字符串
    reverse(arr, 0, n - 1);

    // 第二步：逐个翻转每个单词（分治的"解决"步骤）
    let start = 0;
    for (let end = 0; end <= n; end++) {
        // 找到单词的边界
        if (end === n || arr[end] === " ") {
            reverse(arr, start, end - 1); // 翻转当前这个单词
            start = end + 1;              // 下一个单词的起始位置
        }
    }
    return arr.join("");
}

console.log("\n===== 翻转字符串中的单词 =====");
const s13 = "Let's take LeetCode contest";
console.log(reverseWords(s13));       // "s'teL ekat edoCteeL tsetnoc"
console.log(reverseWordsManual(s13)); // "s'teL ekat edoCteeL tsetnoc"
```

### 主题13 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、归并排序（分治法的经典代表）

```go
package main

import "fmt"

// 将两个有序数组合并成一个有序数组
func merge(left, right []int) []int {
	result := []int{}
	i, j := 0, 0

	// 比较两个数组的元素，从小到大放入结果
	for i < len(left) && j < len(right) {
		if left[i] <= right[j] {
			result = append(result, left[i])
			i++
		} else {
			result = append(result, right[j])
			j++
		}
	}
	// 把剩余元素追加到结果末尾
	for ; i < len(left); i++ {
		result = append(result, left[i])
	}
	for ; j < len(right); j++ {
		result = append(result, right[j])
	}
	return result
}

// ========== 归并排序 ==========
// 分治三步：分解 → 解决（递归） → 合并
func mergeSort(arr []int) []int {
	// 基线条件：数组长度 <= 1 时，已经有序
	if len(arr) <= 1 {
		return arr
	}

	// ===== 第一步：分解 =====
	mid := len(arr) / 2
	leftHalf := append([]int{}, arr[:mid]...)   // 左半部分（拷贝）
	rightHalf := append([]int{}, arr[mid:]...)  // 右半部分（拷贝）

	// ===== 第二步：解决（递归排序） =====
	leftSorted := mergeSort(leftHalf)
	rightSorted := mergeSort(rightHalf)

	// ===== 第三步：合并 =====
	return merge(leftSorted, rightSorted)
}

func testMergeSort13() {
	arr := []int{38, 27, 43, 3, 9, 82, 10}
	fmt.Printf("排序前: %v\n", arr)
	fmt.Printf("排序后: %v\n", mergeSort(arr)) // [3 9 10 27 38 43 82]
}
```

##### 二、快速幂运算 x^n

```go
package main

import "fmt"

// ========== 快速幂（递归版） ==========
// 时间复杂度: O(log n)，因为每次 n 都减半
func fastPower(x float64, n int) float64 {
	// 基线条件
	if n == 0 {
		return 1.0 // 任何数的 0 次方都是 1
	}

	// 递归计算 x^(n/2)
	half := fastPower(x, n/2)

	// 根据 n 的奇偶性合并结果
	if n%2 == 0 {
		return half * half          // n 是偶数: x^n = (x^(n/2))^2
	}
	return x * half * half          // n 是奇数: x^n = x * (x^(n/2))^2
}

// ========== 快速幂（迭代版，更高效） ==========
// 核心思想：把 n 写成二进制，逐位处理
// 例如 2^10: 10 的二进制是 1010 → 2^10 = 2^8 * 2^2
func fastPowerIterative(x float64, n int) float64 {
	if n < 0 {
		x = 1 / x
		n = -n
	}

	result := 1.0
	current := x // current 依次表示 x^1, x^2, x^4, x^8, ...

	for n > 0 {
		if n%2 == 1 {
			result *= current // 如果当前二进制位是 1，就乘上对应的幂
		}
		current *= current // current 翻倍
		n /= 2             // n 右移一位（整除 2）
	}
	return result
}

func testFastPower() {
	fmt.Printf("%v\n", fastPower(2, 10))          // 1024
	fmt.Printf("%v\n", fastPower(3, 5))           // 243
	fmt.Printf("%v\n", fastPower(2, 0))           // 1
	fmt.Printf("%v\n", fastPowerIterative(2, 10)) // 1024
	fmt.Printf("%v\n", fastPowerIterative(3, 5))  // 243
}
```

##### 三、多数元素（分治解法 + 摩尔投票）

```go
package main

import "fmt"

// ========== 多数元素 —— 分治法 ==========
// 关键性质：如果数组分成两半，多数元素在其中至少一半里仍然是多数元素
func majorityElementDivideConquer(nums []int) int {
	var majority func(lo, hi int) int
	majority = func(lo, hi int) int {
		// 基线条件：只有一个元素，它本身就是多数元素
		if lo == hi {
			return nums[lo]
		}

		// ===== 分解 =====
		mid := (lo + hi) / 2

		// ===== 解决（递归） =====
		leftMajority := majority(lo, mid)       // 左半的多数元素
		rightMajority := majority(mid+1, hi)    // 右半的多数元素

		// ===== 合并 =====
		if leftMajority == rightMajority {
			return leftMajority // 两边结果相同，直接返回
		}

		// 统计两个候选者在整个区间中的出现次数
		leftCount, rightCount := 0, 0
		for i := lo; i <= hi; i++ {
			if nums[i] == leftMajority {
				leftCount++
			}
			if nums[i] == rightMajority {
				rightCount++
			}
		}
		// 返回出现次数更多的那个
		if leftCount > rightCount {
			return leftMajority
		}
		return rightMajority
	}

	return majority(0, len(nums)-1)
}

// ========== 多数元素 —— Boyer-Moore 投票算法（O(n) 时间，O(1) 空间） ==========
// 类比：候选人PK，相同的票 +1，不同的票 -1
func majorityElementVoting(nums []int) int {
	candidate, count := 0, 0

	for _, num := range nums {
		if count == 0 {
			candidate = num // 没人了，换一个新的候选人
			count = 1
		} else if num == candidate {
			count++ // 投了当前候选人一票
		} else {
			count-- // 投了反对票
		}
	}
	return candidate
}

func testMajority() {
	fmt.Printf("多数元素(分治): %d\n", majorityElementDivideConquer([]int{2, 2, 1, 1, 1, 2, 2})) // 2
	fmt.Printf("多数元素(投票): %d\n", majorityElementVoting([]int{2, 2, 1, 1, 1, 2, 2}))       // 2
}
```

##### 四、最大子数组和（分治解法）

```go
package main

import "fmt"

// ========== 最大子数组和 —— 分治法 ==========
// 返回四个值: maxSum(最大子数组和), maxPrefix(最大前缀和), maxSuffix(最大后缀和), totalSum(总和)
func maxSubarrayDivideConquer(nums []int) int {
	var solve func(lo, hi int) (int, int, int, int)
	solve = func(lo, hi int) (int, int, int, int) {
		// 基线条件：只有一个元素
		if lo == hi {
			val := nums[lo]
			// 最大子数组和、最大前缀和、最大后缀和都至少是这个元素本身
			return max2(val, 0), max2(val, 0), max2(val, 0), val
		}

		mid := (lo + hi) / 2

		// 递归求解左半和右半
		lMax, lPre, lSuf, lTotal := solve(lo, mid)
		rMax, rPre, rSuf, rTotal := solve(mid+1, hi)

		// ===== 合并 =====
		// 跨越中间的最大子数组 = 左半的最大后缀 + 右半的最大前缀
		crossMax := lSuf + rPre

		// 三种情况取最大值
		maxSum := max3(lMax, rMax, crossMax)

		// 最大前缀和：要么完全在左半，要么包含整个左半 + 右半的前缀
		maxPrefix := max2(lPre, lTotal+rPre)

		// 最大后缀和：要么完全在右半，要么包含整个右半 + 左半的后缀
		maxSuffix := max2(rSuf, rTotal+lSuf)

		// 总和
		totalSum := lTotal + rTotal

		return maxSum, maxPrefix, maxSuffix, totalSum
	}

	if len(nums) == 0 {
		return 0
	}

	// 处理全负数的情况
	allNeg := true
	maxVal := nums[0]
	for _, x := range nums {
		if x >= 0 {
			allNeg = false
		}
		if x > maxVal {
			maxVal = x
		}
	}
	if allNeg {
		return maxVal
	}

	result, _, _, _ := solve(0, len(nums)-1)
	return result
}

func max2(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func max3(a, b, c int) int {
	return max2(max2(a, b), c)
}

func testMaxSubarray() {
	nums := []int{-2, 1, -3, 4, -1, 2, 1, -5, 4}
	fmt.Printf("最大子数组和: %d\n", maxSubarrayDivideConquer(nums)) // 6
}
```

##### 五、经典例题

```go
package main

import (
	"fmt"
	"strings"
)

// ========== 例题1：Pow(x, n)（LeetCode 50） ==========
// 使用分治（快速幂）实现，注意处理负指数
func myPow(x float64, n int) float64 {
	// 处理负指数
	if n < 0 {
		x = 1 / x
		n = -n
	}

	// 快速幂核心逻辑
	var fastPow func(base float64, exp int) float64
	fastPow = func(base float64, exp int) float64 {
		if exp == 0 {
			return 1.0 // 基线条件
		}
		half := fastPow(base, exp/2) // 递归求解 base^(exp/2)
		if exp%2 == 0 {
			return half * half // 合并（偶数）
		}
		return base * half * half // 合并（奇数）
	}

	return fastPow(x, n)
}

func testMyPow() {
	fmt.Println("===== Pow(x, n) =====")
	fmt.Println(myPow(2.0, 10))  // 1024
	fmt.Println(myPow(2.1, 3))   // 9.261000000000001
	fmt.Println(myPow(2.0, -2))  // 0.25
}

// ========== 例题3：翻转字符串中的单词 ==========
// 思路：拆分 → 逐个翻转 → 合并（微型分治）
func reverseWords(s string) string {
	words := strings.Split(s, " ") // 分解：按空格拆分
	for i, w := range words {
		words[i] = reverseStr(w) // 解决：翻转每个单词
	}
	return strings.Join(words, " ") // 合并：用空格连接
}

func reverseStr(s string) string {
	runes := []rune(s)
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	return string(runes)
}

// 手动实现（不依赖内置函数），展示分治的完整过程
func reverseWordsManual(s string) string {
	arr := []byte(s) // 字符串转字节数组

	// 翻转数组片段 [left, right] 的辅助函数
	reverse := func(arr []byte, left, right int) {
		for left < right {
			arr[left], arr[right] = arr[right], arr[left]
			left++
			right--
		}
	}

	n := len(arr)

	// 第一步：翻转整个字符串
	reverse(arr, 0, n-1)

	// 第二步：逐个翻转每个单词（分治的"解决"步骤）
	start := 0
	for end := 0; end <= n; end++ {
		// 找到单词的边界
		if end == n || arr[end] == ' ' {
			reverse(arr, start, end-1) // 翻转当前这个单词
			start = end + 1             // 下一个单词的起始位置
		}
	}
	return string(arr)
}

func testReverseWords() {
	fmt.Println("\n===== 翻转字符串中的单词 =====")
	s := "Let's take LeetCode contest"
	fmt.Println(reverseWords(s))       // s'teL ekat edoCteeL tsetnoc
	fmt.Println(reverseWordsManual(s)) // s'teL ekat edoCteeL tsetnoc
}
```

---


### 主题14：贪心算法（Greedy）


#### 一、贪心的思想

##### 什么是贪心？

贪心算法的核心思想：**每一步都选择当前看起来最好的选择，希望最终能得到全局最优解。**

##### 生活类比：超市找零钱

假设你是收银员，要找给顾客 63 元，手上有这些面额：

```
纸币: 50元, 20元, 10元, 5元, 1元
```

**贪心策略**：每次都选面额最大的纸币

```
第1步: 63 - 50 = 13  → 用一张 50 元
第2步: 13 - 10 = 3   → 用一张 10 元
第3步: 3 - 1 = 2     → 用一张 1 元
第4步: 2 - 1 = 1     → 用一张 1 元
第5步: 1 - 1 = 0     → 用一张 1 元

共用了 5 张纸币: 50 + 10 + 1 + 1 + 1 = 63
```

这就是贪心——每一步都选"当前最大面额"，不去想后面会不会更优。

##### 再举一个例子：吃自助餐

你去吃自助餐，肚子容量有限（比如最多装 1kg 食物）。

**贪心策略**：每轮都选"性价比最高"的菜（最好吃 / 占肚子最少）

这样你就能在有限的容量内，吃到最多的"满足感"。

---

#### 二、贪心的核心：局部最优 → 全局最优

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│   贪心算法的核心逻辑:                                     │
│                                                         │
│   局部最优选择  →  →  →  →  →  →  →  全局最优解          │
│   (每一步最好)                    (整体最好)              │
│                                                         │
│   关键问题: 局部最优真的能推导出全局最优吗？               │
│   答案: 不一定！需要证明！                               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

##### 贪心算法的特点

| 特点 | 说明 |
|------|------|
| 简单直观 | 策略通常很好想，代码也不复杂 |
| 效率高 | 通常 O(n log n) 或 O(n) |
| 难在证明 | 想出策略容易，证明它正确才难 |
| 不通用 | 每个问题需要单独分析贪心策略是否正确 |

---

#### 三、贪心的关键难点：正确性证明

##### 为什么贪心不一定对？

**反例：找零钱问题**

假设货币面额是 `[1, 3, 4]`，要找 6 元。

```
贪心策略（每次选最大面额）:
  6 - 4 = 2
  2 - 1 = 1
  1 - 1 = 0
  用了 3 张: 4 + 1 + 1

最优解:
  6 = 3 + 3
  只用了 2 张！
```

贪心给出了错误答案！因为面额设计不满足"贪心选择性质"。

##### 如何证明贪心策略正确？

常用方法：
1. **贪心选择性质**：证明第一步的贪心选择一定在最优解中
2. **最优子结构**：证明做了贪心选择后，剩余子问题的最优解 + 贪心选择 = 原问题最优解
3. **交换论证**：假设存在一个更优的解，通过交换其中的元素，证明可以把它变成贪心解而不降低质量

---

#### 四、贪心适用的场景特征

贪心算法通常在以下情况适用：

1. **问题具有贪心选择性质**：局部最优选择能导致全局最优
2. **问题具有最优子结构**：全局最优解包含子问题的最优解
3. **排序后贪心**：很多问题需要先排序，再贪心选择
4. **区间问题**：活动选择、区间调度等

##### 常见贪心模式

```
模式1: 排序 + 贪心选择
  → 活动选择、分数背包

模式2: 每次选最大/最小
  → 霍夫曼编码、Prim/Kruskal

模式3: 逐步扩展
  → Dijkstra 最短路径
```

---

#### 五、经典贪心问题

##### 5.1 活动选择问题 / 区间调度

###### 问题描述

有 n 个活动，每个活动有开始时间和结束时间 `[start, end)`。同一时间只能参加一个活动。求最多能参加多少个活动？

```
活动列表:
  活动A: [1, 4)
  活动B: [3, 5)
  活动C: [0, 6)
  活动D: [5, 7)
  活动E: [3, 9)
  活动F: [5, 9)
  活动G: [6, 10)
  活动H: [8, 11)
  活动I: [8, 12)
  活动J: [2, 14)
  活动K: [12, 16)
```

###### 贪心策略：每次选结束最早的

**为什么选"结束最早"而不是"开始最早"？**

```
如果选开始最早的:
  先选了 [0, 6)  → 后面很多活动都不能参加了
  这不是最优的！

如果选结束最早的:
  先选 [1, 4)  → 结束得早，留给后面的时间多
  再选 [5, 7)  → 还能继续选
  再选 [8, 11) → ...
  这样能选更多活动！
```

**直觉**：越早结束的活动，给后续活动留下的时间越多。

###### 完整 Python 实现

```python
def activity_selection(activities):
    """
    活动选择问题 —— 贪心算法
    activities: [(start, end), ...] 活动列表
    返回: 最多能参加的活动数量，以及选择了哪些活动
    
    贪心策略: 每次选结束时间最早的、且与已选活动不冲突的活动
    """
    # 第一步: 按结束时间升序排序（这是贪心的关键！）
    activities_sorted = sorted(activities, key=lambda x: x[1])
    
    selected = []         # 选中的活动
    last_end_time = 0     # 上一个选中活动的结束时间
    
    for start, end in activities_sorted:
        # 如果当前活动的开始时间 >= 上一个活动的结束时间，说明不冲突
        if start >= last_end_time:
            selected.append((start, end))
            last_end_time = end  # 更新结束时间
    
    return len(selected), selected


# 测试
activities = [
    (1, 4), (3, 5), (0, 6), (5, 7), (3, 9),
    (5, 9), (6, 10), (8, 11), (8, 12), (2, 14), (12, 16)
]

count, selected = activity_selection(activities)
print(f"最多能参加 {count} 个活动")
print(f"选择的活动: {selected}")
# 输出: 最多能参加 4 个活动
# 选择的活动: [(1, 4), (5, 7), (8, 11), (12, 16)]
```

###### 正确性证明思路

**贪心选择性质**：设按结束时间排序后，第一个结束的活动是 A[1]。

证明 A[1] 一定在某个最优解中：
- 设最优解 O 中第一个活动是 A[k]
- 因为 A[1] 结束最早，所以 A[1].end <= A[k].end
- 用 A[1] 替换 A[k]，不会与后面的活动冲突
- 所以存在一个包含 A[1] 的最优解

**最优子结构**：选了 A[1] 后，剩余问题是在 A[1] 结束后才开始的所有活动中做选择。这是一个规模更小的同类型问题。

---

##### 5.2 分数背包问题

###### 与 0-1 背包的区别

| | 0-1 背包 | 分数背包 |
|---|---------|---------|
| 物品能否分割 | 不能（要么全拿，要么不拿） | 可以（拿一部分也行） |
| 适用算法 | 动态规划 | **贪心** |
| 难度 | NP 完全 | 多项式可解 |

###### 贪心策略：按性价比排序

```
性价比 = 价值 / 重量

每次选性价比最高的物品:
  - 如果背包还装得下，全部装入
  - 如果装不下，装入能装下的部分（分数）
```

###### Python 实现

```python
def fractional_knapsack(capacity, items):
    """
    分数背包问题 —— 贪心算法
    capacity: 背包容量
    items: [(weight, value), ...] 物品列表
    返回: 最大总价值
    
    贪心策略: 按性价比（价值/重量）从高到低选择
    """
    # 第一步: 计算每个物品的性价比，并按性价比降序排序
    items_with_ratio = []
    for weight, value in items:
        ratio = value / weight
        items_with_ratio.append((ratio, weight, value))
    
    # 按性价比从高到低排序
    items_with_ratio.sort(reverse=True)
    
    total_value = 0.0   # 总价值
    remaining = capacity # 剩余容量
    
    for ratio, weight, value in items_with_ratio:
        if remaining <= 0:
            break
        
        if weight <= remaining:
            # 整个物品都能装下，全部拿走
            total_value += value
            remaining -= weight
        else:
            # 装不下了，拿走能装下的部分（分数）
            total_value += ratio * remaining
            remaining = 0
    
    return total_value


# 测试
# 物品: (重量, 价值)
items = [
    (10, 60),   # 性价比: 6.0
    (20, 100),  # 性价比: 5.0
    (30, 120),  # 性价比: 4.0
]
capacity = 50

max_value = fractional_knapsack(capacity, items)
print(f"背包容量: {capacity}")
print(f"最大价值: {max_value}")
# 解释:
# 先拿性价比最高的 (10, 60)，全部拿走，剩余容量 40
# 再拿 (20, 100)，全部拿走，剩余容量 20
# 最后拿 (30, 120) 的一部分: 20/30 * 120 = 80
# 总价值: 60 + 100 + 80 = 240
```

###### 正确性分析

**为什么贪心对分数背包有效？**

假设最优解没有按性价比排序，那么一定存在两个物品 A 和 B，其中 A 的性价比高于 B，但 A 拿得少、B 拿得多。

这时我们可以把 B 的一部分换成 A（保持总重量不变），总价值会增加——矛盾！

所以最优解一定是按性价比从高到低拿的。

---

##### 5.3 跳跃游戏（LeetCode 55）

###### 题目

给定一个非负整数数组 `nums`，你最初位于数组的第一个下标。每个元素表示你在该位置可以跳跃的最大长度。判断你是否能够到达最后一个下标。

```
输入: nums = [2, 3, 1, 1, 4]
输出: True
解释: 从下标 0 跳 1 步到下标 1，再从下标 1 跳 3 步到下标 4（最后一个）
```

###### 贪心解法详解

**贪心策略**：维护一个 `max_reach`（当前能到达的最远位置），遍历数组时不断更新。

```
nums = [2, 3, 1, 1, 4]
index:  0  1  2  3  4

i=0: nums[0]=2, max_reach = max(0, 0+2) = 2   → 最远能到 index 2
i=1: nums[1]=3, max_reach = max(2, 1+3) = 4   → 最远能到 index 4
i=2: nums[2]=1, max_reach = max(4, 2+1) = 4   → 最远能到 index 4
i=3: nums[3]=1, max_reach = max(4, 3+1) = 4   → 最远能到 index 4
i=4: max_reach >= 4, 可以到达终点！返回 True
```

###### Python 实现

```python
def canJump(nums):
    """
    LeetCode 55: 跳跃游戏
    贪心算法
    时间复杂度: O(n)
    空间复杂度: O(1)
    
    贪心策略: 维护能到达的最远位置
    """
    max_reach = 0  # 当前能到达的最远位置
    
    for i in range(len(nums)):
        # 如果当前位置已经超出了能到达的范围，说明到不了
        if i > max_reach:
            return False
        
        # 更新最远能到达的位置
        max_reach = max(max_reach, i + nums[i])
        
        # 如果已经能到达或超过最后一个位置，提前返回
        if max_reach >= len(nums) - 1:
            return True
    
    return True


# 测试
print(canJump([2, 3, 1, 1, 4]))  # True
print(canJump([3, 2, 1, 0, 4]))  # False
# 解释: index 3 的值是 0，跳不动了，永远到不了 index 4
```

###### 为什么贪心是对的？

我们不需要关心"具体怎么跳"，只需要关心"最远能跳到哪里"。如果某个位置能跳得更远，那它一定能覆盖之前所有位置能到达的范围。这就是贪心选择的正确性。

---

##### 5.4 分发饼干（LeetCode 455）

###### 题目

每个孩子有一个"胃口值" `g[i]`，每块饼干有一个"大小" `s[j]`。如果 `s[j] >= g[i]`，这块饼干就能满足这个孩子。求最多能满足几个孩子？

```
输入: g = [1, 2, 3], s = [1, 1]
输出: 1
解释: 只有 1 块饼干能满足胃口值为 1 的孩子
```

###### 贪心策略

**小饼干先满足小胃口**（或大饼干先满足大胃口）。

```python
def findContentChildren(g, s):
    """
    LeetCode 455: 分发饼干
    贪心算法
    时间复杂度: O(n log n + m log m) 排序
    空间复杂度: O(1)
    
    贪心策略: 用最小的能满足的饼干去满足孩子
    """
    g.sort()  # 孩子胃口排序
    s.sort()  # 饼干大小排序
    
    child = 0   # 当前要满足的孩子
    cookie = 0  # 当前饼干
    
    while child < len(g) and cookie < len(s):
        if s[cookie] >= g[child]:
            # 这块饼干能满足当前孩子
            child += 1  # 下一个孩子
        # 无论是否满足，饼干都要往后看（不满足说明太小，跳过）
        cookie += 1
    
    return child  # 满足的孩子数


# 测试
print(findContentChildren([1, 2, 3], [1, 1]))     # 1
print(findContentChildren([1, 2], [1, 2, 3]))      # 2
```

---

##### 5.5 无重叠区间（LeetCode 435）

###### 题目

给定一个区间集合，找到需要移除区间的**最小数量**，使剩余区间互不重叠。

```
输入: [[1,2], [2,4], [1,3], [3,4]]
输出: 1
解释: 移除 [1,3] 后，剩余区间互不重叠
```

###### 解题思路

这道题等价于：**最多能保留多少个不重叠区间**？

这不就是活动选择问题吗！用同样的贪心策略。

```python
def eraseOverlapIntervals(intervals):
    """
    LeetCode 435: 无重叠区间
    贪心算法（与活动选择问题相同）
    时间复杂度: O(n log n)
    
    思路: 最多保留多少个不重叠区间 = 活动选择问题
    需要移除的数量 = 总数 - 最多保留数
    """
    if not intervals:
        return 0
    
    # 按结束时间排序
    intervals.sort(key=lambda x: x[1])
    
    count = 1              # 至少能保留一个
    last_end = intervals[0][1]
    
    for i in range(1, len(intervals)):
        if intervals[i][0] >= last_end:
            # 不重叠，可以保留
            count += 1
            last_end = intervals[i][1]
    
    # 需要移除的 = 总数 - 保留的
    return len(intervals) - count


# 测试
print(eraseOverlapIntervals([[1,2], [2,4], [1,3], [3,4]]))  # 1
print(eraseOverlapIntervals([[1,2], [1,2], [1,2]]))           # 2
```

---

##### 5.6 用最少数量的箭引爆气球（LeetCode 452）

###### 题目

有一些球形气球，每个气球用 `[x_start, x_end]` 表示水平直径范围。从 x 坐标处垂直射箭，如果 `x_start <= x <= x_end`，气球就会被引爆。求最少需要多少支箭？

```
输入: [[10,16], [2,8], [1,6], [7,12]]
输出: 2
解释: 在 x=6 射一箭引爆 [2,8] 和 [1,6]，在 x=11 射一箭引爆 [10,16] 和 [7,12]
```

###### 解题思路

这本质上也是**区间重叠问题**：找到最少的点，使得每个区间都至少包含一个点。

贪心策略：按结束时间排序，每次在当前区间的右端点射箭。

```python
def findMinArrowShots(points):
    """
    LeetCode 452: 用最少数量的箭引爆气球
    贪心算法
    时间复杂度: O(n log n)
    """
    if not points:
        return 0
    
    # 按右端点排序
    points.sort(key=lambda x: x[1])
    
    arrows = 1               # 至少需要一支箭
    arrow_pos = points[0][1] # 第一支箭射在第一个气球的右端
    
    for i in range(1, len(points)):
        if points[i][0] > arrow_pos:
            # 当前气球的左端在箭的右边，射不到
            # 需要一支新箭
            arrows += 1
            arrow_pos = points[i][1]  # 新箭射在当前气球的右端
    
    return arrows


# 测试
print(findMinArrowShots([[10,16], [2,8], [1,6], [7,12]]))  # 2
print(findMinArrowShots([[1,2], [3,4], [5,6], [7,8]]))      # 4
print(findMinArrowShots([[1,2]]))                             # 1
```

---

#### 六、贪心不能用的情况

##### 找零钱的反例

前面已经提到，当面额不满足贪心选择性质时，贪心会给出错误答案。

```python
def greedy_change(amount, denominations):
    """贪心找零（不一定最优！）"""
    coins = []
    for d in sorted(denominations, reverse=True):
        while amount >= d:
            coins.append(d)
            amount -= d
    return coins

def optimal_change(amount, denominations):
    """动态规划找零（一定最优）"""
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0
    for i in range(1, amount + 1):
        for d in denominations:
            if d <= i:
                dp[i] = min(dp[i], dp[i - d] + 1)
    return dp[amount]

# 面额 [1, 3, 4]，找零 6
print("贪心:", greedy_change(6, [1, 3, 4]))     # [4, 1, 1] → 3 张
print("最优:", optimal_change(6, [1, 3, 4]))     # 2（3+3）
```

##### 什么时候贪心不能用？

1. **局部最优不能推出全局最优**
2. **有后效性**：当前选择会影响未来的选择空间，且影响方式复杂
3. **需要全局考虑**：比如 0-1 背包，选了重的物品可能后面有更好的组合

---

#### 七、贪心 vs 动态规划

| 对比维度 | 贪心算法 | 动态规划 |
|---------|---------|---------|
| 核心思想 | 每步选当前最优 | 考虑所有可能，取全局最优 |
| 是否回溯 | 不回溯（选了就不改） | 会考虑所有子问题 |
| 正确性 | 需要单独证明 | 只要状态转移对就对 |
| 效率 | 通常更高 | 可能较慢（状态多） |
| 适用条件 | 贪心选择性质 + 最优子结构 | 最优子结构 + 重叠子问题 |
| 典型问题 | 活动选择、分数背包 | 0-1 背包、最长公共子序列 |

##### 分数背包 vs 0-1 背包

```
分数背包（物品可以分割）:
  → 贪心有效！按性价比排序即可

0-1 背包（物品不能分割）:
  → 贪心无效！必须用动态规划
  
  反例: 背包容量 50
  物品A: 重量 10, 价值 60 (性价比 6)
  物品B: 重量 20, 价值 100 (性价比 5)
  物品C: 重量 30, 价值 120 (性价比 4)
  
  贪心: 先拿 A(60), 再拿 B(100), 剩余 20 拿不了 C → 总价值 160
  最优: 拿 B(100) + C(120) = 220！
```

---

#### 八、贪心算法总结

##### 解题模板

```python
def greedy_solution(problem):
    """
    贪心算法通用框架
    """
    # 1. 确定贪心策略（排序依据、选择标准）
    # 2. 按策略排序或组织数据
    # 3. 遍历，每步做局部最优选择
    # 4. 返回结果
    pass
```

##### 贪心问题解题步骤

1. **分析问题**：能否用贪心？（局部最优能否推出全局最优？）
2. **确定策略**：排序依据是什么？每步选什么？
3. **实现代码**：通常就是排序 + 遍历
4. **验证正确性**：用反例测试，或尝试证明

##### 一句话总结

> **贪心算法 = 每一步都选当前最好的 + 需要证明这样做最终也是最好的。**

---

### 主题14 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、活动选择问题

```typescript
// ========== 活动选择问题 ==========
// 贪心策略：每次选结束时间最早的活动，为后面的活动留下最多时间
// 时间复杂度：O(n log n)（排序）
function activitySelection(
    activities: Array<{ start: number; end: number }>
): Array<{ start: number; end: number }> {
    // 第一步：按结束时间排序
    const sorted = [...activities].sort((a, b) => a.end - b.end);

    // 第二步：贪心选择
    const selected = [sorted[0]];   // 第一个活动必选
    let lastEnd = sorted[0].end;    // 当前选中的最后一个活动的结束时间

    for (let i = 1; i < sorted.length; i++) {
        // 如果活动的开始时间 >= 上一个活动的结束时间，就选它
        if (sorted[i].start >= lastEnd) {
            selected.push(sorted[i]);
            lastEnd = sorted[i].end; // 更新结束时间
        }
    }
    return selected;
}

// 测试
const activities = [
    { start: 1, end: 3 },
    { start: 2, end: 5 },
    { start: 4, end: 7 },
    { start: 1, end: 8 },
    { start: 5, end: 9 },
    { start: 8, end: 10 },
    { start: 9, end: 11 },
];
console.log("===== 活动选择 =====");
console.log(activitySelection(activities));
// [{1,3}, {4,7}, {8,10}]（结束时间最早优先）
```

##### 二、分数背包问题

```typescript
// ========== 分数背包问题 ==========
// 贪心策略：按"单位重量价值"从高到低装
// 物品可以拆分，所以贪心一定是最优的
function fractionalKnapsack(
    items: Array<{ weight: number; value: number }>,
    capacity: number
): number {
    // 按单位重量价值（value/weight）降序排序
    const sorted = [...items].sort(
        (a, b) => b.value / b.weight - a.value / a.weight
    );

    let totalValue = 0;
    let remaining = capacity;

    for (const item of sorted) {
        if (remaining <= 0) break; // 背包满了

        if (item.weight <= remaining) {
            // 物品能完整放进去
            totalValue += item.value;
            remaining -= item.weight;
        } else {
            // 只能装一部分
            const fraction = remaining / item.weight; // 能装的比例
            totalValue += item.value * fraction;
            break; // 背包满了
        }
    }
    return totalValue;
}

// 测试
const items = [
    { weight: 10, value: 60 },
    { weight: 20, value: 100 },
    { weight: 30, value: 120 },
];
console.log("\n===== 分数背包 =====");
console.log(fractionalKnapsack(items, 50));  // 240（装前两个+第三个的2/3）
```

##### 三、跳跃游戏

```typescript
// ========== 跳跃游戏 ==========
// 贪心策略：维护"最远能到达的位置"，逐步扩大可达范围
// 时间复杂度：O(n)
function canJump(nums: number[]): boolean {
    let maxReach = 0; // 当前能到达的最远位置

    for (let i = 0; i < nums.length; i++) {
        if (i > maxReach) return false; // 当前位置都到不了
        maxReach = Math.max(maxReach, i + nums[i]); // 更新最远可达位置
        if (maxReach >= nums.length - 1) return true; // 已经能到终点
    }
    return true;
}

console.log("\n===== 跳跃游戏 =====");
console.log(canJump([2, 3, 1, 1, 4]));  // true
console.log(canJump([3, 2, 1, 0, 4]));  // false
```

##### 四、分发饼干

```typescript
// ========== 分发饼干 ==========
// 贪心策略：最小的饼干给胃口最小的孩子（先满足最容易满足的）
function findContentChildren(g: number[], s: number[]): number {
    g.sort((a, b) => a - b); // 孩子的胃口从小到大
    s.sort((a, b) => a - b); // 饼干尺寸从小到大

    let child = 0; // 已经满足的孩子数量（同时也是孩子的指针）
    let cookie = 0;

    while (child < g.length && cookie < s.length) {
        if (s[cookie] >= g[child]) {
            child++; // 这块饼干能喂饱当前孩子
        }
        cookie++; // 无论能否喂饱，这块饼干都用掉了
    }
    return child;
}

console.log("\n===== 分发饼干 =====");
console.log(findContentChildren([1, 2, 3], [1, 1]));  // 1
console.log(findContentChildren([1, 2], [1, 2, 3]));  // 2
```

##### 五、无重叠区间

```typescript
// ========== 无重叠区间 ==========
// 思路：总区间数 - 最多能保留的不重叠区间数（就是活动选择问题）
function eraseOverlapIntervals(intervals: Array<[number, number]>): number {
    if (intervals.length === 0) return 0;

    // 按结束时间排序（跟活动选择一样的贪心策略）
    const sorted = [...intervals].sort((a, b) => a[1] - b[1]);

    let count = 1;          // 至少保留一个区间
    let lastEnd = sorted[0][1];

    for (let i = 1; i < sorted.length; i++) {
        if (sorted[i][0] >= lastEnd) {
            count++;                    // 不重叠，保留
            lastEnd = sorted[i][1];
        }
        // 重叠的区间直接跳过（相当于删除）
    }
    return intervals.length - count; // 要删掉的数量
}

console.log("\n===== 无重叠区间 =====");
console.log(eraseOverlapIntervals([[1, 2], [2, 3], [3, 4], [1, 3]]));  // 1
console.log(eraseOverlapIntervals([[1, 2], [1, 2], [1, 2]]));          // 2
console.log(eraseOverlapIntervals([[1, 2], [2, 3]]));                  // 0
```

##### 六、用最少数量的箭引爆气球

```typescript
// ========== 用最少数量的箭引爆气球 ==========
// 思路：尽可能让一支箭穿过更多重叠的气球
function findMinArrowShots(points: Array<[number, number]>): number {
    if (points.length === 0) return 0;

    // 按右端点排序
    const sorted = [...points].sort((a, b) => a[1] - b[1]);

    let arrows = 1;                 // 至少需要一支箭
    let arrowPos = sorted[0][1];    // 第一支箭射在最左气球的右端点

    for (let i = 1; i < sorted.length; i++) {
        if (sorted[i][0] > arrowPos) {
            // 这个气球跟前面的不重叠，需要新射一支箭
            arrows++;
            arrowPos = sorted[i][1];
        }
        // 否则说明能一箭射穿，不增加箭数
    }
    return arrows;
}

console.log("\n===== 用最少数量的箭引爆气球 =====");
console.log(findMinArrowShots([[10, 16], [2, 8], [1, 6], [7, 12]]));  // 2
console.log(findMinArrowShots([[1, 2], [3, 4], [5, 6], [7, 8]]));     // 4
console.log(findMinArrowShots([[1, 2], [2, 3], [3, 4], [4, 5]]));     // 2
```

##### 七、找零钱问题

```typescript
// ========== 找零钱问题（贪心版） ==========
// 尽量用大面额的钱币，减少找零张数
function greedyChange(amount: number, denominations: number[]): Map<number, number> {
    const sorted = [...denominations].sort((a, b) => b - a); // 从大到小
    const result = new Map<number, number>();

    for (const coin of sorted) {
        if (amount >= coin) {
            const count = Math.floor(amount / coin); // 用几张这种面额
            result.set(coin, count);
            amount -= count * coin; // 剩余金额
        }
    }

    if (amount > 0) {
        console.log(`无法找零，剩余: ${amount}`);
    }
    return result;
}

console.log("\n===== 找零钱问题 =====");
console.log(greedyChange(36, [1, 5, 10, 20, 50]));
// Map { 20 => 1, 10 => 1, 5 => 1, 1 => 1 }
console.log(greedyChange(36, [1, 5, 10, 25]));
// Map { 25 => 1, 10 => 1, 1 => 1 }
```

##### 八、经典例题

```typescript
// ========== 例题：零钱兑换（LeetCode 322，动态规划解法） ==========
// 为什么贪心不行？因为某些面额组合下，贪心会给出错误答案
// 例：coins=[1,3,4], amount=6 → 贪心 4+1+1=3枚，最优是 3+3=2枚
// 所以必须用动态规划
function coinChange(coins: number[], amount: number): number {
    // dp[i] = 凑出金额 i 所需的最少硬币数
    const dp = new Array<number>(amount + 1).fill(Infinity);
    dp[0] = 0; // 金额0不需要硬币

    for (let i = 1; i <= amount; i++) {
        for (const coin of coins) {
            if (coin <= i) {
                dp[i] = Math.min(dp[i], dp[i - coin] + 1);
            }
        }
    }
    return dp[amount] === Infinity ? -1 : dp[amount];
}

console.log("\n===== 零钱兑换 =====");
console.log(coinChange([1, 3, 4], 6));     // 2
console.log(coinChange([1, 2, 5], 11));    // 3
console.log(coinChange([2], 3));           // -1
```

### 主题14 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、活动选择问题

```go
package main

import (
	"fmt"
	"sort"
)

// 活动
type Activity struct {
	Start int
	End   int
}

// ========== 活动选择问题 ==========
// 贪心策略：每次选结束时间最早的活动，为后面的活动留下最多时间
// 时间复杂度：O(n log n)（排序）
func activitySelection(activities []Activity) []Activity {
	// 第一步：按结束时间排序
	sorted := make([]Activity, len(activities))
	copy(sorted, activities)
	sort.Slice(sorted, func(i, j int) bool {
		return sorted[i].End < sorted[j].End
	})

	// 第二步：贪心选择
	selected := []Activity{sorted[0]} // 第一个活动必选
	lastEnd := sorted[0].End          // 当前选中的最后一个活动的结束时间

	for i := 1; i < len(sorted); i++ {
		// 如果活动的开始时间 >= 上一个活动的结束时间，就选它
		if sorted[i].Start >= lastEnd {
			selected = append(selected, sorted[i])
			lastEnd = sorted[i].End // 更新结束时间
		}
	}
	return selected
}

func testActivitySelection() {
	activities := []Activity{
		{Start: 1, End: 3},
		{Start: 2, End: 5},
		{Start: 4, End: 7},
		{Start: 1, End: 8},
		{Start: 5, End: 9},
		{Start: 8, End: 10},
		{Start: 9, End: 11},
	}
	fmt.Println("===== 活动选择 =====")
	fmt.Println(activitySelection(activities))
	// [{1 3} {4 7} {8 10}]（结束时间最早优先）
}
```

##### 二、分数背包问题

```go
package main

import (
	"fmt"
	"sort"
)

type Item struct {
	Weight int
	Value  int
}

// ========== 分数背包问题 ==========
// 贪心策略：按"单位重量价值"从高到低装
// 物品可以拆分，所以贪心一定是最优的
func fractionalKnapsack(items []Item, capacity int) float64 {
	// 按单位重量价值（Value/Weight）降序排序
	sorted := make([]Item, len(items))
	copy(sorted, items)
	sort.Slice(sorted, func(i, j int) bool {
		return float64(sorted[i].Value)/float64(sorted[i].Weight) >
			float64(sorted[j].Value)/float64(sorted[j].Weight)
	})

	totalValue := 0.0
	remaining := float64(capacity)

	for _, item := range sorted {
		if remaining <= 0 {
			break // 背包满了
		}
		if float64(item.Weight) <= remaining {
			// 物品能完整放进去
			totalValue += float64(item.Value)
			remaining -= float64(item.Weight)
		} else {
			// 只能装一部分
			fraction := remaining / float64(item.Weight) // 能装的比例
			totalValue += float64(item.Value) * fraction
			break // 背包满了
		}
	}
	return totalValue
}

func testFractionalKnapsack() {
	items := []Item{
		{Weight: 10, Value: 60},
		{Weight: 20, Value: 100},
		{Weight: 30, Value: 120},
	}
	fmt.Println("\n===== 分数背包 =====")
	fmt.Println(fractionalKnapsack(items, 50)) // 240
}
```

##### 三、跳跃游戏

```go
package main

import "fmt"

// ========== 跳跃游戏 ==========
// 贪心策略：维护"最远能到达的位置"，逐步扩大可达范围
// 时间复杂度：O(n)
func canJump(nums []int) bool {
	maxReach := 0 // 当前能到达的最远位置

	for i := 0; i < len(nums); i++ {
		if i > maxReach {
			return false // 当前位置都到不了
		}
		if i+nums[i] > maxReach {
			maxReach = i + nums[i] // 更新最远可达位置
		}
		if maxReach >= len(nums)-1 {
			return true // 已经能到终点
		}
	}
	return true
}

func testCanJump() {
	fmt.Println("\n===== 跳跃游戏 =====")
	fmt.Println(canJump([]int{2, 3, 1, 1, 4})) // true
	fmt.Println(canJump([]int{3, 2, 1, 0, 4})) // false
}
```

##### 四、分发饼干

```go
package main

import (
	"fmt"
	"sort"
)

// ========== 分发饼干 ==========
// 贪心策略：最小的饼干给胃口最小的孩子（先满足最容易满足的）
func findContentChildren(g, s []int) int {
	sort.Ints(g) // 孩子的胃口从小到大
	sort.Ints(s) // 饼干尺寸从小到大

	child := 0 // 已经满足的孩子数量（同时也是孩子的指针）
	cookie := 0

	for child < len(g) && cookie < len(s) {
		if s[cookie] >= g[child] {
			child++ // 这块饼干能喂饱当前孩子
		}
		cookie++ // 无论能否喂饱，这块饼干都用掉了
	}
	return child
}

func testFindContentChildren() {
	fmt.Println("\n===== 分发饼干 =====")
	fmt.Println(findContentChildren([]int{1, 2, 3}, []int{1, 1})) // 1
	fmt.Println(findContentChildren([]int{1, 2}, []int{1, 2, 3})) // 2
}
```

##### 五、无重叠区间

```go
package main

import (
	"fmt"
	"sort"
)

// ========== 无重叠区间 ==========
// 思路：总区间数 - 最多能保留的不重叠区间数（就是活动选择问题）
func eraseOverlapIntervals(intervals [][]int) int {
	if len(intervals) == 0 {
		return 0
	}

	// 按结束时间排序（跟活动选择一样的贪心策略）
	sorted := make([][]int, len(intervals))
	copy(sorted, intervals)
	sort.Slice(sorted, func(i, j int) bool {
		return sorted[i][1] < sorted[j][1]
	})

	count := 1          // 至少保留一个区间
	lastEnd := sorted[0][1]

	for i := 1; i < len(sorted); i++ {
		if sorted[i][0] >= lastEnd {
			count++                  // 不重叠，保留
			lastEnd = sorted[i][1]
		}
		// 重叠的区间直接跳过（相当于删除）
	}
	return len(intervals) - count // 要删掉的数量
}

func testEraseOverlapIntervals() {
	fmt.Println("\n===== 无重叠区间 =====")
	fmt.Println(eraseOverlapIntervals([][]int{{1, 2}, {2, 3}, {3, 4}, {1, 3}})) // 1
	fmt.Println(eraseOverlapIntervals([][]int{{1, 2}, {1, 2}, {1, 2}}))         // 2
	fmt.Println(eraseOverlapIntervals([][]int{{1, 2}, {2, 3}}))                 // 0
}
```

##### 六、用最少数量的箭引爆气球

```go
package main

import (
	"fmt"
	"sort"
)

// ========== 用最少数量的箭引爆气球 ==========
// 思路：尽可能让一支箭穿过更多重叠的气球
func findMinArrowShots(points [][]int) int {
	if len(points) == 0 {
		return 0
	}

	// 按右端点排序
	sorted := make([][]int, len(points))
	copy(sorted, points)
	sort.Slice(sorted, func(i, j int) bool {
		return sorted[i][1] < sorted[j][1]
	})

	arrows := 1                  // 至少需要一支箭
	arrowPos := sorted[0][1]     // 第一支箭射在最左气球的右端点

	for i := 1; i < len(sorted); i++ {
		if sorted[i][0] > arrowPos {
			// 这个气球跟前面的不重叠，需要新射一支箭
			arrows++
			arrowPos = sorted[i][1]
		}
		// 否则说明能一箭射穿，不增加箭数
	}
	return arrows
}

func testFindMinArrowShots() {
	fmt.Println("\n===== 用最少数量的箭引爆气球 =====")
	fmt.Println(findMinArrowShots([][]int{{10, 16}, {2, 8}, {1, 6}, {7, 12}})) // 2
	fmt.Println(findMinArrowShots([][]int{{1, 2}, {3, 4}, {5, 6}, {7, 8}}))    // 4
	fmt.Println(findMinArrowShots([][]int{{1, 2}, {2, 3}, {3, 4}, {4, 5}}))    // 2
}
```

##### 七、找零钱问题

```go
package main

import "fmt"

// ========== 找零钱问题（贪心版） ==========
// 尽量用大面额的钱币，减少找零张数
func greedyChange(amount int, denominations []int) map[int]int {
	// 从大到小排序
	sorted := make([]int, len(denominations))
	copy(sorted, denominations)
	for i := 0; i < len(sorted); i++ {
		for j := i + 1; j < len(sorted); j++ {
			if sorted[i] < sorted[j] {
				sorted[i], sorted[j] = sorted[j], sorted[i]
			}
		}
	}

	result := make(map[int]int)
	for _, coin := range sorted {
		if amount >= coin {
			count := amount / coin // 用几张这种面额
			result[coin] = count
			amount -= count * coin // 剩余金额
		}
	}

	if amount > 0 {
		fmt.Printf("无法找零，剩余: %d\n", amount)
	}
	return result
}

func testGreedyChange() {
	fmt.Println("\n===== 找零钱问题 =====")
	fmt.Println(greedyChange(36, []int{1, 5, 10, 20, 50}))
	// map[20:1 10:1 5:1 1:1]
	fmt.Println(greedyChange(36, []int{1, 5, 10, 25}))
	// map[25:1 10:1 1:1]
}
```

##### 八、经典例题

```go
package main

import "fmt"

// ========== 例题：零钱兑换（LeetCode 322，动态规划解法） ==========
// 为什么贪心不行？因为某些面额组合下，贪心会给出错误答案
// 例：coins=[1,3,4], amount=6 → 贪心 4+1+1=3枚，最优是 3+3=2枚
// 所以必须用动态规划
func coinChange(coins []int, amount int) int {
	const INF = 1 << 30

	// dp[i] = 凑出金额 i 所需的最少硬币数
	dp := make([]int, amount+1)
	for i := range dp {
		dp[i] = INF
	}
	dp[0] = 0 // 金额0不需要硬币

	for i := 1; i <= amount; i++ {
		for _, coin := range coins {
			if coin <= i && dp[i-coin]+1 < dp[i] {
				dp[i] = dp[i-coin] + 1
			}
		}
	}
	if dp[amount] == INF {
		return -1
	}
	return dp[amount]
}

func testCoinChange() {
	fmt.Println("\n===== 零钱兑换 =====")
	fmt.Println(coinChange([]int{1, 3, 4}, 6))  // 2
	fmt.Println(coinChange([]int{1, 2, 5}, 11)) // 3
	fmt.Println(coinChange([]int{2}, 3))        // -1
}
```

---


### 主题15：回溯法（Backtracking）


#### 一、回溯的思想

##### 用"走迷宫"来理解

想象你在走一个复杂的迷宫：

```
入口 → 岔路口1 → 走左边 → 死胡同！退回来
                  走右边 → 岔路口2 → 走上边 → 到达出口！✓
```

**回溯法就是这样的策略**：
1. 走到一个岔路口，先选一条路走
2. 如果发现走不通（撞墙/不满足条件），就**退回来**
3. 换一条路继续走
4. 直到找到出口，或者所有路都试过了

##### 回溯的本质：系统化的穷举

> 回溯法就是**有组织的暴力枚举**。

不是瞎试，而是：
- 系统地尝试所有可能的选择
- 发现走不通就及时回头（剪枝）
- 找到所有满足条件的答案

---

#### 二、回溯法模板（重点！）

```python
def backtrack(路径, 选择列表):
    """
    回溯法通用模板
    
    参数:
        路径: 当前已经做出的选择（如 [1, 3, 2]）
        选择列表: 当前还可以做的选择（如 [4, 5, 6]）
    """
    
    # 基线条件：满足结束条件时，收集结果
    if 满足结束条件:
        结果.append(路径[:])  # 注意要拷贝！
        return
    
    # 遍历所有可选的选择
    for 选择 in 选择列表:
        # 做选择：把当前选择加入路径
        路径.append(选择)
        
        # 递归：在剩余选择中继续
        backtrack(路径, 剩余选择)
        
        # 撤销选择（回溯的核心！）：把刚才的选择撤掉
        路径.pop()
```

##### 模板图解

```
                    backtrack([], [1,2,3])
                    /         |          \
             选1 /       选2 /       选3 \
               /           |            \
    backtrack([1],[2,3])  ...          ...
       /        \
    选2/        选3/
     /            \
  backtrack      backtrack
  ([1,2],[3])    ([1,3],[2])
     |              |
    选3             选2
     |              |
  [1,2,3] ✓      [1,3,2] ✓
  收集结果！      收集结果！
  回溯到[1,2]     回溯到[1,3]
  回溯到[1]       回溯到[1]
  回溯到[]        回溯到[]
```

---

#### 三、经典问题详解

##### 3.1 全排列（LeetCode 46）

###### 题目

给定一个不含重复数字的数组 `nums`，返回其所有可能的全排列。

```
输入: nums = [1, 2, 3]
输出: [[1,2,3], [1,3,2], [2,1,3], [2,3,1], [3,1,2], [3,2,1]]
```

###### 决策树

```
                       []
              /         |         \
           选1         选2         选3
           /            |            \
        [1]           [2]           [3]
       /   \          /   \          /   \
     选2   选3      选1   选3      选1   选2
     /       \      /       \      /       \
  [1,2]   [1,3]  [2,1]   [2,3]  [3,1]   [3,2]
    |       |      |       |      |       |
   选3     选2    选3     选1    选2     选1
    |       |      |       |      |       |
 [1,2,3] [1,3,2] [2,1,3] [2,3,1] [3,1,2] [3,2,1]
   ✓       ✓       ✓       ✓       ✓       ✓
```

###### 完整 Python 实现

```python
def permute(nums):
    """
    LeetCode 46: 全排列
    回溯法
    
    时间复杂度: O(n * n!)
      - n! 种排列
      - 每种排列需要 O(n) 时间拷贝到结果中
    空间复杂度: O(n) 递归栈深度
    """
    result = []  # 存放所有排列结果
    
    def backtrack(path, remaining):
        """
        path: 当前已选择的数字列表
        remaining: 还可以选择的数字列表
        """
        # 基线条件：没有剩余数字可选了，说明一个完整排列形成了
        if not remaining:
            result.append(path[:])  # 拷贝一份加入结果
            return
        
        # 依次尝试选择 remaining 中的每个数字
        for i in range(len(remaining)):
            # 做选择：选 remaining[i]
            num = remaining[i]
            path.append(num)
            
            # 新的 remaining = 去掉刚选的那个数字
            new_remaining = remaining[:i] + remaining[i+1:]
            
            # 递归
            backtrack(path, new_remaining)
            
            # 撤销选择（回溯！）
            path.pop()
    
    backtrack([], nums)
    return result


# 测试
print(permute([1, 2, 3]))
# 输出: [[1,2,3], [1,3,2], [2,1,3], [2,3,1], [3,1,2], [3,2,1]]
```

###### 执行过程图解

```
backtrack([], [1,2,3])
├── 选1: path=[1], remaining=[2,3]
│   ├── 选2: path=[1,2], remaining=[3]
│   │   └── 选3: path=[1,2,3], remaining=[]  → 收集 [1,2,3] ✓
│   │       回溯: path=[1,2]
│   │   回溯: path=[1]
│   └── 选3: path=[1,3], remaining=[2]
│       └── 选2: path=[1,3,2], remaining=[]  → 收集 [1,3,2] ✓
│           回溯: path=[1,3]
│       回溯: path=[1]
│   回溯: path=[]
├── 选2: path=[2], remaining=[1,3]
│   ├── 选1: path=[2,1], remaining=[3]
│   │   └── 选3: path=[2,1,3], remaining=[]  → 收集 [2,1,3] ✓
│   ...（类似过程）
└── 选3: path=[3], remaining=[1,2]
    ...（类似过程）
```

---

##### 3.2 子集（LeetCode 78）

###### 题目

给定一个不含重复元素的整数数组，返回它的所有子集（幂集）。

```
输入: nums = [1, 2, 3]
输出: [[], [1], [2], [3], [1,2], [1,3], [2,3], [1,2,3]]
```

###### 解题思路

子集问题：对于每个元素，选或不选。

```
决策树（以 [1,2,3] 为例）:

                   []
            /       |       \
          选1      选2      选3
          /        |         \
        [1]      [2]        [3]
       /   \       |
     选2   选3    选3
     /       \     |
  [1,2]   [1,3]  [2,3]
    |
   选3
    |
 [1,2,3]

注意：为了避免重复，每个元素只能往后选！
选了 1 之后，只能选 2, 3（不能回头选 1）
```

###### Python 实现

```python
def subsets(nums):
    """
    LeetCode 78: 子集
    回溯法
    
    时间复杂度: O(n * 2^n)
      - 共 2^n 个子集
      - 每个子集拷贝需要 O(n)
    空间复杂度: O(n) 递归栈
    """
    result = []
    
    def backtrack(start, path):
        """
        start: 从哪个下标开始选（避免回头选，防止重复）
        path: 当前已选择的元素
        """
        # 每个节点都是一个合法子集！所以每次进入都收集
        result.append(path[:])
        
        # 从 start 开始遍历，避免回头
        for i in range(start, len(nums)):
            # 做选择
            path.append(nums[i])
            
            # 递归：从 i+1 开始选（不能回头）
            backtrack(i + 1, path)
            
            # 撤销选择
            path.pop()
    
    backtrack(0, [])
    return result


# 测试
print(subsets([1, 2, 3]))
# 输出: [[], [1], [1,2], [1,2,3], [1,3], [2], [2,3], [3]]
```

---

##### 3.3 组合（LeetCode 77）

###### 题目

给定两个整数 `n` 和 `k`，返回范围 `[1, n]` 中所有可能的 `k` 个数的组合。

```
输入: n = 4, k = 2
输出: [[1,2], [1,3], [1,4], [2,3], [2,4], [3,4]]
```

###### Python 实现

```python
def combine(n, k):
    """
    LeetCode 77: 组合
    回溯法
    
    时间复杂度: O(C(n,k) * k)
    空间复杂度: O(k) 递归栈
    """
    result = []
    
    def backtrack(start, path):
        """
        start: 从哪个数开始选
        path: 当前已选择的数
        """
        # 基线条件：选够了 k 个数
        if len(path) == k:
            result.append(path[:])
            return
        
        # 剪枝优化：
        # 如果剩下的数不够选了，就不用继续了
        # 还需要选 k - len(path) 个数
        # 从 i 开始到 n 共有 n - i + 1 个数
        # 需要 n - i + 1 >= k - len(path)
        # 即 i <= n - (k - len(path)) + 1
        remaining_needed = k - len(path)
        
        for i in range(start, n - remaining_needed + 2):
            # 做选择
            path.append(i)
            
            # 递归：从 i+1 开始选
            backtrack(i + 1, path)
            
            # 撤销选择
            path.pop()
    
    backtrack(1, [])
    return result


# 测试
print(combine(4, 2))
# 输出: [[1,2], [1,3], [1,4], [2,3], [2,4], [3,4]]
```

---

##### 3.4 N 皇后问题（LeetCode 51）

###### 题目

在 n×n 的棋盘上放置 n 个皇后，使得它们互不攻击（不在同一行、同一列、同一对角线）。返回所有合法的放置方案。

###### 问题分析

```
4 皇后的一个合法解:
. Q . .     第 0 行: 皇后在第 1 列
. . . Q     第 1 行: 皇后在第 3 列
Q . . .     第 2 行: 皇后在第 0 列
. . Q .     第 3 行: 皇后在第 2 列
```

**约束条件**：
1. 每行恰好一个皇后（自然满足，因为我们逐行放置）
2. 每列最多一个皇后
3. 每条对角线最多一个皇后

###### 如何判断对角线冲突？

```
对于位置 (row, col):
  - 主对角线（左上到右下）: row - col 相同
  - 副对角线（右上到左下）: row + col 相同

例如 (0,1) 和 (1,2):
  0 - 1 = -1, 1 - 2 = -1  → 同一条主对角线！冲突！

例如 (0,3) 和 (1,2):
  0 + 3 = 3, 1 + 2 = 3  → 同一条副对角线！冲突！
```

###### 完整 Python 实现

```python
def solveNQueens(n):
    """
    LeetCode 51: N 皇后
    回溯法
    
    时间复杂度: O(n!)
    空间复杂度: O(n)
    """
    result = []           # 所有合法方案
    queens_col = []       # queens_col[i] = 第 i 行的皇后放在第几列
    cols = set()          # 已占用的列
    diag1 = set()         # 已占用的主对角线 (row - col)
    diag2 = set()         # 已占用的副对角线 (row + col)
    
    def backtrack(row):
        """在第 row 行放置皇后"""
        
        # 基线条件：所有行都放好了
        if row == n:
            # 把 queens_col 转成棋盘格式
            board = []
            for c in queens_col:
                board.append('.' * c + 'Q' + '.' * (n - c - 1))
            result.append(board)
            return
        
        # 尝试在当前行的每一列放皇后
        for col in range(n):
            # 检查是否冲突
            if col in cols:
                continue  # 同一列有皇后
            if (row - col) in diag1:
                continue  # 主对角线有皇后
            if (row + col) in diag2:
                continue  # 副对角线有皇后
            
            # 做选择：在 (row, col) 放皇后
            queens_col.append(col)
            cols.add(col)
            diag1.add(row - col)
            diag2.add(row + col)
            
            # 递归：放下一行
            backtrack(row + 1)
            
            # 撤销选择（回溯！）
            queens_col.pop()
            cols.remove(col)
            diag1.remove(row - col)
            diag2.remove(row + col)
    
    backtrack(0)
    return result


# 测试
solutions = solveNQueens(4)
for i, sol in enumerate(solutions):
    print(f"方案 {i+1}:")
    for row in sol:
        print(f"  {row}")
    print()

# 输出:
# 方案 1:
#   .Q..
#   ...Q
#   Q...
#   ..Q.
#
# 方案 2:
#   ..Q.
#   Q...
#   ...Q
#   .Q..
```

###### 执行过程图解（4 皇后）

```
第 0 行: 尝试 col=0
  第 1 行: col=0 ✗(同列), col=1 ✗(对角线), col=2 ✓
    第 2 行: col=0 ✗, col=1 ✗, col=2 ✗, col=3 ✗ → 全部冲突！回溯
  第 1 行: col=3 ✓
    第 2 行: col=0 ✗, col=1 ✓
      第 3 行: col=0 ✗, col=1 ✗, col=2 ✗, col=3 ✗ → 回溯
    第 2 行: col=2 ✗(对角线), col=3 ✗ → 回溯
  → col=0 开头无解，回溯

第 0 行: 尝试 col=1
  第 1 行: col=0 ✗(对角线), col=1 ✗(同列), col=2 ✗(对角线), col=3 ✓
    第 2 行: col=0 ✓
      第 3 行: col=0 ✗, col=1 ✗, col=2 ✓, col=3 ✗
        → 找到方案！[1, 3, 0, 2] ✓
    ...
```

---

##### 3.5 组合总和（LeetCode 39）

###### 题目

给定一个无重复元素的整数数组 `candidates` 和一个目标数 `target`，找出所有和为 `target` 的组合。同一个数字可以无限制重复使用。

```
输入: candidates = [2, 3, 6, 7], target = 7
输出: [[2, 2, 3], [7]]
```

###### Python 实现

```python
def combinationSum(candidates, target):
    """
    LeetCode 39: 组合总和
    回溯法
    
    与之前组合问题的区别:
    - 数字可以重复使用（所以递归时 start 不变）
    - 需要跟踪当前和
    """
    result = []
    
    def backtrack(start, path, current_sum):
        """
        start: 从 candidates 的哪个下标开始选
        path: 当前选择的数字列表
        current_sum: 当前选择的数字之和
        """
        # 基线条件：和等于 target
        if current_sum == target:
            result.append(path[:])
            return
        
        # 如果已经超过 target，不用继续了（剪枝）
        if current_sum > target:
            return
        
        for i in range(start, len(candidates)):
            num = candidates[i]
            
            # 做选择
            path.append(num)
            
            # 递归：注意 start 是 i（不是 i+1），因为可以重复使用同一个数
            backtrack(i, path, current_sum + num)
            
            # 撤销选择
            path.pop()
    
    backtrack(0, [], 0)
    return result


# 测试
print(combinationSum([2, 3, 6, 7], 7))
# 输出: [[2, 2, 3], [7]]
```

###### 执行过程图解

```
backtrack(0, [], 0)
├── 选2: path=[2], sum=2
│   ├── 选2: path=[2,2], sum=4
│   │   ├── 选2: path=[2,2,2], sum=6
│   │   │   ├── 选2: sum=8 > 7, 剪枝
│   │   │   ├── 选3: sum=9 > 7, 剪枝
│   │   │   └── ...
│   │   ├── 选3: path=[2,2,3], sum=7 == target → 收集 [2,2,3] ✓
│   │   ├── 选6: sum=10 > 7, 剪枝
│   │   └── 选7: sum=11 > 7, 剪枝
│   ├── 选3: path=[2,3], sum=5
│   │   └── ... (都超过 7)
│   └── 选6: path=[2,6], sum=8 > 7, 剪枝
├── 选3: path=[3], sum=3
│   └── ... (都超过 7 或无法凑成 7)
├── 选6: path=[6], sum=6
│   └── ... (无法凑成 7)
└── 选7: path=[7], sum=7 == target → 收集 [7] ✓
```

---

#### 四、剪枝优化

##### 什么是剪枝？

在决策树中，有些分支明显不可能产生答案，我们提前把它"砍掉"，不再深入探索。

```
决策树:
        root
      / | \  \
    A   B   C   D
   / \  |
  ... ... ...
  
如果 B 的子树明显无解，就不需要深入 B 了
直接把 B 这个分支"剪掉" → 节省大量时间
```

##### 在组合问题中剪枝

```python
def combine_pruned(n, k):
    """带剪枝的组合问题"""
    result = []
    
    def backtrack(start, path):
        if len(path) == k:
            result.append(path[:])
            return
        
        # 剪枝！
        # 还需要选 k - len(path) 个数
        # 从 i 开始到 n 共有 n - i + 1 个数
        # 如果 n - i + 1 < k - len(path)，剩下的不够选了
        for i in range(start, n - (k - len(path)) + 2):
            path.append(i)
            backtrack(i + 1, path)
            path.pop()
    
    backtrack(1, [])
    return result

# 对比：
# n=5, k=3 时
# 不剪枝: 会尝试 [1,2], [1,3], [1,4], [1,5], [2,3], ... 很多无效路径
# 剪枝后: 当 path=[1,2] 时，i 只需要到 5-(3-2)+1=4，即最多选到 4
#         当 path=[4] 时，还需要选 2 个，但只剩 5，不够 → 直接不进入循环
```

##### 在数独中剪枝

数独的剪枝策略：
1. **候选数剪枝**：每个格子只尝试能填入的数字（排除同行、同列、同宫已有的）
2. **唯一候选数**：如果某个格子只有一个候选数，直接填入
3. **隐性唯一**：如果某个数字在某行/列/宫中只能放在一个位置，直接填入

```python
def solveSudoku(board):
    """
    数独求解 —— 回溯 + 剪枝
    board: 9x9 的二维列表，0 表示空格
    """
    
    def is_valid(row, col, num):
        """检查在 (row, col) 放 num 是否合法"""
        for i in range(9):
            # 检查行
            if board[row][i] == num:
                return False
            # 检查列
            if board[i][col] == num:
                return False
            # 检查 3x3 宫格
            box_row, box_col = 3 * (row // 3) + i // 3, 3 * (col // 3) + i % 3
            if board[box_row][box_col] == num:
                return False
        return True
    
    def backtrack():
        # 找到第一个空格
        for row in range(9):
            for col in range(9):
                if board[row][col] == 0:
                    # 尝试填入 1-9
                    for num in range(1, 10):
                        if is_valid(row, col, num):
                            # 做选择
                            board[row][col] = num
                            
                            # 递归
                            if backtrack():
                                return True
                            
                            # 撤销选择
                            board[row][col] = 0
                    
                    # 1-9 都试了都不行，回溯
                    return False
        
        # 没有空格了，全部填完
        return True
    
    backtrack()
```

---

#### 五、回溯法总结

##### 排列 vs 组合 vs 子集

| 问题类型 | 特点 | 选择方式 | 收集时机 |
|---------|------|---------|---------|
| **排列** | 顺序有关，[1,2] ≠ [2,1] | 每次从所有未选的里面选 | 只在叶子节点收集 |
| **组合** | 顺序无关，[1,2] = [2,1] | 从 start 往后选（不回头） | 只在叶子节点收集 |
| **子集** | 所有大小的组合都是答案 | 从 start 往后选（不回头） | 每个节点都收集 |

```python
# 排列: 需要 used 数组标记已选元素，每次从头遍历
for i in range(len(nums)):
    if used[i]:
        continue
    used[i] = True
    path.append(nums[i])
    backtrack(path)
    path.pop()
    used[i] = False

# 组合: 从 start 开始往后选
for i in range(start, n):
    path.append(nums[i])
    backtrack(i + 1, path)  # 注意 i+1，不回头
    path.pop()

# 子集: 和组合类似，但每个节点都收集结果
result.append(path[:])  # 进入函数就收集
for i in range(start, n):
    path.append(nums[i])
    backtrack(i + 1, path)
    path.pop()
```

##### 如何去重

当输入包含重复元素时，需要先排序，然后在同一层中跳过重复的选择：

```python
def subsetsWithDup(nums):
    """含重复元素的子集问题 —— 需要去重"""
    nums.sort()  # 第一步：排序！
    result = []
    
    def backtrack(start, path):
        result.append(path[:])
        
        for i in range(start, len(nums)):
            # 去重关键：同一层中，跳过重复元素
            if i > start and nums[i] == nums[i-1]:
                continue  # 跳过重复的
            
            path.append(nums[i])
            backtrack(i + 1, path)
            path.pop()
    
    backtrack(0, [])
    return result

# 测试
print(subsetsWithDup([1, 2, 2]))
# 输出: [[], [1], [1,2], [1,2,2], [2], [2,2]]
# 注意: 不会出现两个 [1,2] 或两个 [2]
```

**去重原理**：

```
nums = [1, 2, 2]（已排序）

同一层的含义:
  backtrack(0, []) 的这一层循环:
    i=0: 选 nums[0]=1 → 继续
    i=1: 选 nums[1]=2 → 继续
    i=2: 选 nums[2]=2 → 但 i>start(0) 且 nums[2]==nums[1]，跳过！

这样避免了在同一层选择相同的值，从而避免重复子集
```

---

#### 六、经典例题补充

##### 6.1 电话号码的字母组合（LeetCode 17）

###### 题目

给定一个只包含数字 2-9 的字符串，返回所有它能表示的字母组合。

```
输入: digits = "23"
输出: ["ad", "ae", "af", "bd", "be", "bf", "cd", "ce", "cf"]

数字到字母的映射:
2: a,b,c    3: d,e,f    4: g,h,i
5: j,k,l    6: m,n,o    7: p,q,r,s
8: t,u      9: w,x,y,z
```

###### Python 实现

```python
def letterCombinations(digits):
    """
    LeetCode 17: 电话号码的字母组合
    回溯法
    
    思路: 每个数字对应一组字母，从每组中选一个
    本质: 多个集合的笛卡尔积
    """
    if not digits:
        return []
    
    # 数字到字母的映射
    phone_map = {
        '2': 'abc', '3': 'def',
        '4': 'ghi', '5': 'jkl', '6': 'mno',
        '7': 'pqrs', '8': 'tuv', '9': 'wxyz'
    }
    
    result = []
    
    def backtrack(index, path):
        """
        index: 当前处理到 digits 的第几个数字
        path: 当前已选择的字母组合
        """
        # 基线条件：处理完所有数字
        if index == len(digits):
            result.append(''.join(path))
            return
        
        # 当前数字对应的字母
        digit = digits[index]
        letters = phone_map[digit]
        
        # 遍历当前数字对应的每个字母
        for letter in letters:
            # 做选择
            path.append(letter)
            
            # 递归处理下一个数字
            backtrack(index + 1, path)
            
            # 撤销选择
            path.pop()
    
    backtrack(0, [])
    return result


# 测试
print(letterCombinations("23"))
# 输出: ["ad","ae","af","bd","be","bf","cd","ce","cf"]
```

###### 执行过程图解

```
digits = "23"

backtrack(0, [])
├── 选 'a': path=['a']
│   backtrack(1, ['a'])
│   ├── 选 'd': path=['a','d'] → index==2, 收集 "ad" ✓
│   ├── 选 'e': path=['a','e'] → index==2, 收集 "ae" ✓
│   └── 选 'f': path=['a','f'] → index==2, 收集 "af" ✓
├── 选 'b': path=['b']
│   backtrack(1, ['b'])
│   ├── 选 'd': → 收集 "bd" ✓
│   ├── 选 'e': → 收集 "be" ✓
│   └── 选 'f': → 收集 "bf" ✓
└── 选 'c': path=['c']
    backtrack(1, ['c'])
    ├── 选 'd': → 收集 "cd" ✓
    ├── 选 'e': → 收集 "ce" ✓
    └── 选 'f': → 收集 "cf" ✓
```

---

##### 6.2 单词搜索（LeetCode 79）

###### 题目

给定一个 m×n 的二维字符网格 `board` 和一个字符串 `word`，判断 `word` 是否存在于网格中。单词必须按字母顺序，通过相邻（水平或垂直）的单元格构成，同一个单元格不能重复使用。

```
board = [
    ['A','B','C','E'],
    ['S','F','C','S'],
    ['A','D','E','E']
]
word = "ABCCED"
输出: True
路径: A(0,0) → B(0,1) → C(0,2) → C(1,2) → E(2,2) → D(2,1)
```

###### Python 实现

```python
def exist(board, word):
    """
    LeetCode 79: 单词搜索
    回溯法（DFS）
    
    时间复杂度: O(m * n * 4^L)，L 是单词长度
    空间复杂度: O(L) 递归栈
    """
    m, n = len(board), len(board[0])
    
    def backtrack(row, col, idx):
        """
        row, col: 当前位置
        idx: 当前需要匹配的 word 中的下标
        """
        # 基线条件：所有字母都匹配了
        if idx == len(word):
            return True
        
        # 边界检查
        if row < 0 or row >= m or col < 0 or col >= n:
            return False
        
        # 字符不匹配
        if board[row][col] != word[idx]:
            return False
        
        # 做选择：标记已访问（用特殊字符代替 visited 集合）
        temp = board[row][col]
        board[row][col] = '#'  # 标记为已访问
        
        # 向四个方向递归
        found = (
            backtrack(row + 1, col, idx + 1) or  # 下
            backtrack(row - 1, col, idx + 1) or  # 上
            backtrack(row, col + 1, idx + 1) or  # 右
            backtrack(row, col - 1, idx + 1)     # 左
        )
        
        # 撤销选择（回溯！恢复原来的字符）
        board[row][col] = temp
        
        return found
    
    # 从每个格子开始尝试
    for i in range(m):
        for j in range(n):
            if backtrack(i, j, 0):
                return True
    
    return False


# 测试
board = [
    ['A','B','C','E'],
    ['S','F','C','S'],
    ['A','D','E','E']
]
print(exist(board, "ABCCED"))  # True
print(exist(board, "SEE"))     # True
print(exist(board, "ABCB"))    # False（B 不能重复使用）
```

###### 执行过程图解（搜索 "ABCCED"）

```
从 A(0,0) 开始:
  A(0,0) → 匹配 'A' ✓
    → B(0,1): 匹配 'B' ✓
      → C(0,2): 匹配 'C' ✓
        → C(1,2): 匹配 'C' ✓
          → E(2,2): 匹配 'E' ✓
            → D(2,1): 匹配 'D' ✓
              → idx == 6 == len(word) → True! ✓

路径: A→B→C→C→E→D
```

---

#### 七、回溯法总结

##### 核心要点回顾

1. **回溯 = 有组织的穷举**
   - 不是盲目暴力，而是通过决策树系统地搜索

2. **三要素**
   - **路径**：已经做出的选择
   - **选择列表**：当前可以做的选择
   - **结束条件**：什么时候收集结果

3. **核心操作**
   - 做选择 → 递归 → 撤销选择（这三步缺一不可！）

4. **剪枝优化**
   - 提前排除不可能的分支，大幅减少搜索空间

5. **去重技巧**
   - 排序 + 同层跳过重复元素

##### 回溯法复杂度

- **时间复杂度**：通常是指数量级，如 O(n!)、O(2^n)、O(k^n)
- **空间复杂度**：主要是递归栈深度，通常 O(n)

##### 一句话总结

> **回溯法 = 决策树上的 DFS。做选择 → 递归 → 撤销选择。能剪枝就剪枝，有重复就去重。**

---

### 主题15 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、全排列（LeetCode 46）

```typescript
// ========== 全排列 ==========
// 回溯法：做选择 → 递归 → 撤销选择
// 时间复杂度: O(n * n!)
function permute(nums: number[]): number[][] {
    const result: number[][] = [];

    const backtrack = (path: number[], remaining: number[]): void => {
        // 基线条件：没有剩余数字可选了，说明一个完整排列形成了
        if (remaining.length === 0) {
            result.push([...path]); // 拷贝一份加入结果
            return;
        }

        // 依次尝试选择 remaining 中的每个数字
        for (let i = 0; i < remaining.length; i++) {
            // 做选择：选 remaining[i]
            const num = remaining[i];
            path.push(num);

            // 新的 remaining = 去掉刚选的那个数字
            const newRemaining = [...remaining.slice(0, i), ...remaining.slice(i + 1)];

            // 递归
            backtrack(path, newRemaining);

            // 撤销选择（回溯！）
            path.pop();
        }
    };

    backtrack([], nums);
    return result;
}

// 测试
console.log("===== 全排列 =====");
console.log(JSON.stringify(permute([1, 2, 3])));
// [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
```

##### 二、子集（LeetCode 78）

```typescript
// ========== 子集 ==========
// 每个节点都是一个合法子集，进入函数就收集
// 为了避免重复，每个元素只能往后选（不能回头）
// 时间复杂度: O(n * 2^n)
function subsets(nums: number[]): number[][] {
    const result: number[][] = [];

    const backtrack = (start: number, path: number[]): void => {
        // 每个节点都是一个合法子集！所以每次进入都收集
        result.push([...path]);

        // 从 start 开始遍历，避免回头
        for (let i = start; i < nums.length; i++) {
            path.push(nums[i]);        // 做选择
            backtrack(i + 1, path);    // 递归：从 i+1 开始选
            path.pop();                // 撤销选择
        }
    };

    backtrack(0, []);
    return result;
}

console.log("\n===== 子集 =====");
console.log(JSON.stringify(subsets([1, 2, 3])));
// [[],[1],[1,2],[1,2,3],[1,3],[2],[2,3],[3]]
```

##### 三、组合（LeetCode 77，带剪枝）

```typescript
// ========== 组合 ==========
// 剪枝优化：如果剩下的数不够选了，就不用继续了
// 还需要选 k - path.length 个数，从 i 开始到 n 共有 n - i + 1 个数
// 需要 n - i + 1 >= k - path.length，即 i <= n - (k - path.length) + 1
function combine(n: number, k: number): number[][] {
    const result: number[][] = [];

    const backtrack = (start: number, path: number[]): void => {
        // 基线条件：选够了 k 个数
        if (path.length === k) {
            result.push([...path]);
            return;
        }

        // 剪枝：剩余数不够选就直接结束循环
        const remainingNeeded = k - path.length;
        for (let i = start; i <= n - remainingNeeded + 1; i++) {
            path.push(i);              // 做选择
            backtrack(i + 1, path);    // 递归：从 i+1 开始选
            path.pop();                // 撤销选择
        }
    };

    backtrack(1, []);
    return result;
}

console.log("\n===== 组合 =====");
console.log(JSON.stringify(combine(4, 2)));
// [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]
```

##### 四、N 皇后（LeetCode 51）

```typescript
// ========== N 皇后 ==========
// 逐行放置皇后，用三个集合记录已占用的列和对角线
// 主对角线: row - col 相同；副对角线: row + col 相同
// 时间复杂度: O(n!)
function solveNQueens(n: number): string[][] {
    const result: string[][] = [];
    const queensCol: number[] = [];  // queensCol[i] = 第 i 行的皇后放在第几列
    const cols = new Set<number>();  // 已占用的列
    const diag1 = new Set<number>(); // 已占用的主对角线 (row - col)
    const diag2 = new Set<number>(); // 已占用的副对角线 (row + col)

    const backtrack = (row: number): void => {
        // 基线条件：所有行都放好了
        if (row === n) {
            // 把 queensCol 转成棋盘格式
            const board = queensCol.map(
                (c) => ".".repeat(c) + "Q" + ".".repeat(n - c - 1)
            );
            result.push(board);
            return;
        }

        // 尝试在当前行的每一列放皇后
        for (let col = 0; col < n; col++) {
            if (cols.has(col)) continue;             // 同一列有皇后
            if (diag1.has(row - col)) continue;      // 主对角线有皇后
            if (diag2.has(row + col)) continue;      // 副对角线有皇后

            // 做选择：在 (row, col) 放皇后
            queensCol.push(col);
            cols.add(col);
            diag1.add(row - col);
            diag2.add(row + col);

            // 递归：放下一行
            backtrack(row + 1);

            // 撤销选择（回溯！）
            queensCol.pop();
            cols.delete(col);
            diag1.delete(row - col);
            diag2.delete(row + col);
        }
    };

    backtrack(0);
    return result;
}

console.log("\n===== N 皇后 =====");
const queens = solveNQueens(4);
queens.forEach((board, i) => {
    console.log(`方案 ${i + 1}:`);
    board.forEach((row) => console.log(`  ${row}`));
    console.log();
});
// 方案 1: .Q.. / ...Q / Q... / ..Q.
// 方案 2: ..Q. / Q... / ...Q / .Q..
```

##### 五、组合总和（LeetCode 39）

```typescript
// ========== 组合总和 ==========
// 与之前组合问题的区别：
// - 数字可以重复使用（所以递归时 start 不变）
// - 需要跟踪当前和
function combinationSum(candidates: number[], target: number): number[][] {
    const result: number[][] = [];

    const backtrack = (start: number, path: number[], currentSum: number): void => {
        // 基线条件：和等于 target
        if (currentSum === target) {
            result.push([...path]);
            return;
        }
        // 如果已经超过 target，不用继续了（剪枝）
        if (currentSum > target) return;

        for (let i = start; i < candidates.length; i++) {
            const num = candidates[i];
            path.push(num);                                    // 做选择
            backtrack(i, path, currentSum + num);              // 递归：注意 start 是 i（可以重复使用）
            path.pop();                                        // 撤销选择
        }
    };

    backtrack(0, [], 0);
    return result;
}

console.log("\n===== 组合总和 =====");
console.log(JSON.stringify(combinationSum([2, 3, 6, 7], 7)));
// [[2,2,3],[7]]
```

##### 六、数独求解（回溯 + 剪枝）

```typescript
// ========== 数独求解 ==========
// board: 9x9 的二维数组，0 表示空格
function solveSudoku(board: number[][]): boolean {
    // 检查在 (row, col) 放 num 是否合法
    const isValid = (row: number, col: number, num: number): boolean => {
        for (let i = 0; i < 9; i++) {
            if (board[row][i] === num) return false;                 // 检查行
            if (board[i][col] === num) return false;                 // 检查列
            // 检查 3x3 宫格
            const boxRow = 3 * Math.floor(row / 3) + Math.floor(i / 3);
            const boxCol = 3 * Math.floor(col / 3) + (i % 3);
            if (board[boxRow][boxCol] === num) return false;
        }
        return true;
    };

    const backtrack = (): boolean => {
        // 找到第一个空格
        for (let row = 0; row < 9; row++) {
            for (let col = 0; col < 9; col++) {
                if (board[row][col] === 0) {
                    // 尝试填入 1-9
                    for (let num = 1; num <= 9; num++) {
                        if (isValid(row, col, num)) {
                            board[row][col] = num;                   // 做选择
                            if (backtrack()) return true;            // 递归
                            board[row][col] = 0;                     // 撤销选择
                        }
                    }
                    return false; // 1-9 都试了都不行，回溯
                }
            }
        }
        return true; // 没有空格了，全部填完
    };

    return backtrack();
}

// 测试
const sudokuBoard: number[][] = [
    [5, 3, 0, 0, 7, 0, 0, 0, 0],
    [6, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 9, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 3],
    [4, 0, 0, 8, 0, 3, 0, 0, 1],
    [7, 0, 0, 0, 2, 0, 0, 0, 6],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [0, 0, 0, 0, 8, 0, 0, 7, 9],
];
console.log("\n===== 数独求解 =====");
console.log(`是否可解: ${solveSudoku(sudokuBoard)}`);  // true
```

##### 七、含重复元素的子集（LeetCode 90，去重）

```typescript
// ========== 含重复元素的子集 ==========
// 去重关键：先排序，在同一层中跳过重复元素
function subsetsWithDup(nums: number[]): number[][] {
    nums.sort((a, b) => a - b); // 第一步：排序！
    const result: number[][] = [];

    const backtrack = (start: number, path: number[]): void => {
        result.push([...path]);

        for (let i = start; i < nums.length; i++) {
            // 去重关键：同一层中，跳过重复元素
            if (i > start && nums[i] === nums[i - 1]) continue;

            path.push(nums[i]);
            backtrack(i + 1, path);
            path.pop();
        }
    };

    backtrack(0, []);
    return result;
}

console.log("\n===== 含重复元素的子集 =====");
console.log(JSON.stringify(subsetsWithDup([1, 2, 2])));
// [[],[1],[1,2],[1,2,2],[2],[2,2]]
```

##### 八、电话号码的字母组合（LeetCode 17）

```typescript
// ========== 电话号码的字母组合 ==========
// 思路：每个数字对应一组字母，从每组中选一个（笛卡尔积）
function letterCombinations(digits: string): string[] {
    if (digits.length === 0) return [];

    // 数字到字母的映射
    const phoneMap: Record<string, string> = {
        "2": "abc", "3": "def",
        "4": "ghi", "5": "jkl", "6": "mno",
        "7": "pqrs", "8": "tuv", "9": "wxyz",
    };

    const result: string[] = [];

    const backtrack = (index: number, path: string[]): void => {
        // 基线条件：处理完所有数字
        if (index === digits.length) {
            result.push(path.join(""));
            return;
        }

        // 当前数字对应的字母
        const letters = phoneMap[digits[index]];

        for (const letter of letters) {
            path.push(letter);                 // 做选择
            backtrack(index + 1, path);        // 递归处理下一个数字
            path.pop();                        // 撤销选择
        }
    };

    backtrack(0, []);
    return result;
}

console.log("\n===== 电话号码的字母组合 =====");
console.log(JSON.stringify(letterCombinations("23")));
// ["ad","ae","af","bd","be","bf","cd","ce","cf"]
```

##### 九、单词搜索（LeetCode 79）

```typescript
// ========== 单词搜索 ==========
// 回溯法（DFS）+ 标记已访问
// 时间复杂度: O(m * n * 4^L)，L 是单词长度
function exist(board: string[][], word: string): boolean {
    const m = board.length;
    const n = board[0].length;

    const backtrack = (row: number, col: number, idx: number): boolean => {
        // 基线条件：所有字母都匹配了
        if (idx === word.length) return true;

        // 边界检查
        if (row < 0 || row >= m || col < 0 || col >= n) return false;

        // 字符不匹配
        if (board[row][col] !== word[idx]) return false;

        // 做选择：标记已访问（用特殊字符代替 visited 集合）
        const temp = board[row][col];
        board[row][col] = "#";

        // 向四个方向递归
        const found =
            backtrack(row + 1, col, idx + 1) ||   // 下
            backtrack(row - 1, col, idx + 1) ||   // 上
            backtrack(row, col + 1, idx + 1) ||   // 右
            backtrack(row, col - 1, idx + 1);     // 左

        // 撤销选择（回溯！恢复原来的字符）
        board[row][col] = temp;

        return found;
    };

    // 从每个格子开始尝试
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (backtrack(i, j, 0)) return true;
        }
    }
    return false;
}

// 测试
const board15 = [
    ["A", "B", "C", "E"],
    ["S", "F", "C", "S"],
    ["A", "D", "E", "E"],
];
console.log("\n===== 单词搜索 =====");
console.log(exist(board15, "ABCCED"));  // true
console.log(exist(board15, "SEE"));     // true
console.log(exist(board15, "ABCB"));    // false（B 不能重复使用）
```

### 主题15 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、全排列（LeetCode 46）

```go
package main

import "fmt"

// ========== 全排列 ==========
// 回溯法：做选择 → 递归 → 撤销选择
// 时间复杂度: O(n * n!)
func permute(nums []int) [][]int {
	result := [][]int{}
	path := []int{}

	var backtrack func(remaining []int)
	backtrack = func(remaining []int) {
		// 基线条件：没有剩余数字可选了，说明一个完整排列形成了
		if len(remaining) == 0 {
			copyPath := make([]int, len(path))
			copy(copyPath, path)
			result = append(result, copyPath)
			return
		}

		// 依次尝试选择 remaining 中的每个数字
		for i := 0; i < len(remaining); i++ {
			// 做选择：选 remaining[i]
			path = append(path, remaining[i])

			// 新的 remaining = 去掉刚选的那个数字
			newRemaining := make([]int, 0, len(remaining)-1)
			newRemaining = append(newRemaining, remaining[:i]...)
			newRemaining = append(newRemaining, remaining[i+1:]...)

			// 递归
			backtrack(newRemaining)

			// 撤销选择（回溯！）
			path = path[:len(path)-1]
		}
	}

	backtrack(nums)
	return result
}

func testPermute() {
	fmt.Println("===== 全排列 =====")
	fmt.Println(permute([]int{1, 2, 3}))
	// [[1 2 3] [1 3 2] [2 1 3] [2 3 1] [3 1 2] [3 2 1]]
}
```

##### 二、子集（LeetCode 78）

```go
package main

import "fmt"

// ========== 子集 ==========
// 每个节点都是一个合法子集，进入函数就收集
// 为了避免重复，每个元素只能往后选（不能回头）
// 时间复杂度: O(n * 2^n)
func subsets(nums []int) [][]int {
	result := [][]int{}
	path := []int{}

	var backtrack func(start int)
	backtrack = func(start int) {
		// 每个节点都是一个合法子集！所以每次进入都收集
		copyPath := make([]int, len(path))
		copy(copyPath, path)
		result = append(result, copyPath)

		// 从 start 开始遍历，避免回头
		for i := start; i < len(nums); i++ {
			path = append(path, nums[i]) // 做选择
			backtrack(i + 1)             // 递归：从 i+1 开始选
			path = path[:len(path)-1]    // 撤销选择
		}
	}

	backtrack(0)
	return result
}

func testSubsets() {
	fmt.Println("\n===== 子集 =====")
	fmt.Println(subsets([]int{1, 2, 3}))
	// [[] [1] [1 2] [1 2 3] [1 3] [2] [2 3] [3]]
}
```

##### 三、组合（LeetCode 77，带剪枝）

```go
package main

import "fmt"

// ========== 组合 ==========
// 剪枝优化：如果剩下的数不够选了，就不用继续了
// 还需要选 k - len(path) 个数，从 i 开始到 n 共有 n - i + 1 个数
func combine(n, k int) [][]int {
	result := [][]int{}
	path := []int{}

	var backtrack func(start int)
	backtrack = func(start int) {
		// 基线条件：选够了 k 个数
		if len(path) == k {
			copyPath := make([]int, len(path))
			copy(copyPath, path)
			result = append(result, copyPath)
			return
		}

		// 剪枝：剩余数不够选就直接结束循环
		remainingNeeded := k - len(path)
		for i := start; i <= n-remainingNeeded+1; i++ {
			path = append(path, i) // 做选择
			backtrack(i + 1)       // 递归：从 i+1 开始选
			path = path[:len(path)-1] // 撤销选择
		}
	}

	backtrack(1)
	return result
}

func testCombine() {
	fmt.Println("\n===== 组合 =====")
	fmt.Println(combine(4, 2))
	// [[1 2] [1 3] [1 4] [2 3] [2 4] [3 4]]
}
```

##### 四、N 皇后（LeetCode 51）

```go
package main

import (
	"fmt"
	"strings"
)

// ========== N 皇后 ==========
// 逐行放置皇后，用三个集合记录已占用的列和对角线
// 主对角线: row - col 相同；副对角线: row + col 相同
// 时间复杂度: O(n!)
func solveNQueens(n int) [][]string {
	result := [][]string{}
	queensCol := []int{}        // queensCol[i] = 第 i 行的皇后放在第几列
	cols := make(map[int]bool)  // 已占用的列
	diag1 := make(map[int]bool) // 已占用的主对角线 (row - col)
	diag2 := make(map[int]bool) // 已占用的副对角线 (row + col)

	var backtrack func(row int)
	backtrack = func(row int) {
		// 基线条件：所有行都放好了
		if row == n {
			// 把 queensCol 转成棋盘格式
			board := make([]string, 0, n)
			for _, c := range queensCol {
				board = append(board,
					strings.Repeat(".", c)+"Q"+strings.Repeat(".", n-c-1))
			}
			result = append(result, board)
			return
		}

		// 尝试在当前行的每一列放皇后
		for col := 0; col < n; col++ {
			if cols[col] {
				continue // 同一列有皇后
			}
			if diag1[row-col] {
				continue // 主对角线有皇后
			}
			if diag2[row+col] {
				continue // 副对角线有皇后
			}

			// 做选择：在 (row, col) 放皇后
			queensCol = append(queensCol, col)
			cols[col] = true
			diag1[row-col] = true
			diag2[row+col] = true

			// 递归：放下一行
			backtrack(row + 1)

			// 撤销选择（回溯！）
			queensCol = queensCol[:len(queensCol)-1]
			delete(cols, col)
			delete(diag1, row-col)
			delete(diag2, row+col)
		}
	}

	backtrack(0)
	return result
}

func testNQueens() {
	fmt.Println("\n===== N 皇后 =====")
	solutions := solveNQueens(4)
	for i, sol := range solutions {
		fmt.Printf("方案 %d:\n", i+1)
		for _, row := range sol {
			fmt.Printf("  %s\n", row)
		}
		fmt.Println()
	}
}
```

##### 五、组合总和（LeetCode 39）

```go
package main

import "fmt"

// ========== 组合总和 ==========
// 与之前组合问题的区别：
// - 数字可以重复使用（所以递归时 start 不变）
// - 需要跟踪当前和
func combinationSum(candidates []int, target int) [][]int {
	result := [][]int{}
	path := []int{}

	var backtrack func(start, currentSum int)
	backtrack = func(start, currentSum int) {
		// 基线条件：和等于 target
		if currentSum == target {
			copyPath := make([]int, len(path))
			copy(copyPath, path)
			result = append(result, copyPath)
			return
		}
		// 如果已经超过 target，不用继续了（剪枝）
		if currentSum > target {
			return
		}

		for i := start; i < len(candidates); i++ {
			path = append(path, candidates[i]) // 做选择
			// 递归：注意 start 是 i（可以重复使用同一个数）
			backtrack(i, currentSum+candidates[i])
			path = path[:len(path)-1] // 撤销选择
		}
	}

	backtrack(0, 0)
	return result
}

func testCombinationSum() {
	fmt.Println("\n===== 组合总和 =====")
	fmt.Println(combinationSum([]int{2, 3, 6, 7}, 7))
	// [[2 2 3] [7]]
}
```

##### 六、数独求解（回溯 + 剪枝）

```go
package main

import "fmt"

// ========== 数独求解 ==========
// board: 9x9 的二维数组，0 表示空格
func solveSudoku(board [][]int) bool {
	// 检查在 (row, col) 放 num 是否合法
	isValid := func(row, col, num int) bool {
		for i := 0; i < 9; i++ {
			if board[row][i] == num {
				return false // 检查行
			}
			if board[i][col] == num {
				return false // 检查列
			}
			// 检查 3x3 宫格
			boxRow := 3*(row/3) + i/3
			boxCol := 3*(col/3) + i%3
			if board[boxRow][boxCol] == num {
				return false
			}
		}
		return true
	}

	var backtrack func() bool
	backtrack = func() bool {
		// 找到第一个空格
		for row := 0; row < 9; row++ {
			for col := 0; col < 9; col++ {
				if board[row][col] == 0 {
					// 尝试填入 1-9
					for num := 1; num <= 9; num++ {
						if isValid(row, col, num) {
							board[row][col] = num    // 做选择
							if backtrack() {
								return true // 递归
							}
							board[row][col] = 0 // 撤销选择
						}
					}
					return false // 1-9 都试了都不行，回溯
				}
			}
		}
		return true // 没有空格了，全部填完
	}

	return backtrack()
}

func testSudoku() {
	board := [][]int{
		{5, 3, 0, 0, 7, 0, 0, 0, 0},
		{6, 0, 0, 1, 9, 5, 0, 0, 0},
		{0, 9, 8, 0, 0, 0, 0, 6, 0},
		{8, 0, 0, 0, 6, 0, 0, 0, 3},
		{4, 0, 0, 8, 0, 3, 0, 0, 1},
		{7, 0, 0, 0, 2, 0, 0, 0, 6},
		{0, 6, 0, 0, 0, 0, 2, 8, 0},
		{0, 0, 0, 4, 1, 9, 0, 0, 5},
		{0, 0, 0, 0, 8, 0, 0, 7, 9},
	}
	fmt.Println("\n===== 数独求解 =====")
	fmt.Printf("是否可解: %v\n", solveSudoku(board)) // true
}
```

##### 七、含重复元素的子集（LeetCode 90，去重）

```go
package main

import (
	"fmt"
	"sort"
)

// ========== 含重复元素的子集 ==========
// 去重关键：先排序，在同一层中跳过重复元素
func subsetsWithDup(nums []int) [][]int {
	sort.Ints(nums) // 第一步：排序！
	result := [][]int{}
	path := []int{}

	var backtrack func(start int)
	backtrack = func(start int) {
		copyPath := make([]int, len(path))
		copy(copyPath, path)
		result = append(result, copyPath)

		for i := start; i < len(nums); i++ {
			// 去重关键：同一层中，跳过重复元素
			if i > start && nums[i] == nums[i-1] {
				continue
			}
			path = append(path, nums[i])
			backtrack(i + 1)
			path = path[:len(path)-1]
		}
	}

	backtrack(0)
	return result
}

func testSubsetsWithDup() {
	fmt.Println("\n===== 含重复元素的子集 =====")
	fmt.Println(subsetsWithDup([]int{1, 2, 2}))
	// [[] [1] [1 2] [1 2 2] [2] [2 2]]
}
```

##### 八、电话号码的字母组合（LeetCode 17）

```go
package main

import "fmt"

// ========== 电话号码的字母组合 ==========
// 思路：每个数字对应一组字母，从每组中选一个（笛卡尔积）
func letterCombinations(digits string) []string {
	if len(digits) == 0 {
		return []string{}
	}

	// 数字到字母的映射
	phoneMap := map[byte]string{
		'2': "abc", '3': "def",
		'4': "ghi", '5': "jkl", '6': "mno",
		'7': "pqrs", '8': "tuv", '9': "wxyz",
	}

	result := []string{}
	path := []byte{}

	var backtrack func(index int)
	backtrack = func(index int) {
		// 基线条件：处理完所有数字
		if index == len(digits) {
			result = append(result, string(path))
			return
		}

		// 当前数字对应的字母
		letters := phoneMap[digits[index]]

		for i := 0; i < len(letters); i++ {
			path = append(path, letters[i]) // 做选择
			backtrack(index + 1)             // 递归处理下一个数字
			path = path[:len(path)-1]        // 撤销选择
		}
	}

	backtrack(0)
	return result
}

func testLetterCombinations() {
	fmt.Println("\n===== 电话号码的字母组合 =====")
	fmt.Println(letterCombinations("23"))
	// [ad ae af bd be bf cd ce cf]
}
```

##### 九、单词搜索（LeetCode 79）

```go
package main

import "fmt"

// ========== 单词搜索 ==========
// 回溯法（DFS）+ 标记已访问
// 时间复杂度: O(m * n * 4^L)，L 是单词长度
func exist(board [][]byte, word string) bool {
	m := len(board)
	n := len(board[0])

	var backtrack func(row, col, idx int) bool
	backtrack = func(row, col, idx int) bool {
		// 基线条件：所有字母都匹配了
		if idx == len(word) {
			return true
		}
		// 边界检查
		if row < 0 || row >= m || col < 0 || col >= n {
			return false
		}
		// 字符不匹配
		if board[row][col] != word[idx] {
			return false
		}

		// 做选择：标记已访问（用特殊字符代替 visited 集合）
		temp := board[row][col]
		board[row][col] = '#'

		// 向四个方向递归
		found := backtrack(row+1, col, idx+1) || // 下
			backtrack(row-1, col, idx+1) ||       // 上
			backtrack(row, col+1, idx+1) ||       // 右
			backtrack(row, col-1, idx+1)          // 左

		// 撤销选择（回溯！恢复原来的字符）
		board[row][col] = temp

		return found
	}

	// 从每个格子开始尝试
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if backtrack(i, j, 0) {
				return true
			}
		}
	}
	return false
}

func testExist() {
	board := [][]byte{
		{'A', 'B', 'C', 'E'},
		{'S', 'F', 'C', 'S'},
		{'A', 'D', 'E', 'E'},
	}
	fmt.Println("\n===== 单词搜索 =====")
	fmt.Println(exist(board, "ABCCED")) // true
	fmt.Println(exist(board, "SEE"))    // true
	fmt.Println(exist(board, "ABCB"))   // false（B 不能重复使用）
}
```

---


## 第六阶段：高级数据结构

### 主题16：图（Graph）


#### 一、图的概念

##### 什么是图？

想象一下你的微信朋友圈：你认识一些人，他们也认识另一些人。这种"谁认识谁"的关系网络，就是一个**图（Graph）**。

再想象一张地图：各个城市之间有公路连接，这也是一个图。

**图的本质**：图就是用来表示**事物与事物之间关系**的数据结构。

- **顶点（Vertex）**：图中的每个节点。比如微信中的每个人，地图中的每个城市。
- **边（Edge）**：连接两个顶点的线。比如"认识"关系，公路。

> 类比：如果把数组比作一排储物柜（线性排列），把树比作家族族谱（层级结构），那图就是一张蜘蛛网——任意两个节点之间都可能有连接。

---

#### 二、基本术语

##### 2.1 有向图 vs 无向图

```
无向图（Undirected Graph）：边没有方向
  A --- B     表示 A 和 B 互相认识（双向关系）
  A --- C

有向图（Directed Graph）：边有方向
  A ---> B    表示 A 关注了 B，但 B 不一定关注 A（单向关系）
  A ---> C
  B ---> A    （B 也关注了 A，这就是互相关注）
```

| 类型 | 例子 | 特点 |
|------|------|------|
| 无向图 | 微信好友、公路 | 关系是双向的 |
| 有向图 | 微博关注、单行道 | 关系是单向的 |

##### 2.2 带权图 vs 无权图

```
无权图：只关心"有没有连接"
  北京 --- 上海     表示有路连通

带权图：连接上有权重（比如距离、花费、时间）
  北京 ---1200km--- 上海    权重 = 1200
  北京 ---700km---- 武汉    权重 = 700
```

##### 2.3 度、入度、出度

```
无向图中：
  度（Degree）= 与一个顶点相连的边的数量
  
  例如下面这个图：
    A --- B
    |   / |
    |  /  |
    | /   |
    C     D
  
  A 的度 = 2（连接 B 和 C）
  B 的度 = 3（连接 A、C、D）

有向图中：
  入度（In-degree）= 有多少条边指向这个顶点（多少人关注了我）
  出度（Out-degree）= 有多少条边从这个顶点指出（我关注了多少人）
  
  A ---> B ---> C
  |             ^
  +------------->+
  
  A: 入度=0, 出度=2
  B: 入度=1, 出度=1
  C: 入度=2, 出度=0
```

---

#### 三、图的存储方式

##### 3.1 邻接矩阵（Adjacency Matrix）

**思想**：用一个二维数组（表格）来表示顶点之间的连接关系。

```python
"""
邻接矩阵实现图

想象一个 4 个顶点的图：
    0 --- 1
    |   / |
    |  /  |
    | /   |
    2 --- 3

邻接矩阵就是一个 4x4 的表格：
       0    1    2    3
  0  [ 0,   1,   1,   0 ]    ← 顶点0 和 1、2 相连
  1  [ 1,   0,   1,   1 ]    ← 顶点1 和 0、2、3 相连
  2  [ 1,   1,   0,   1 ]    ← 顶点2 和 0、1、3 相连
  3  [ 0,   1,   1,   0 ]    ← 顶点3 和 1、2 相连

矩阵中 matrix[i][j] = 1 表示顶点 i 和 j 之间有边
matrix[i][j] = 0 表示没有边
"""


class GraphMatrix:
    """用邻接矩阵实现无向图"""

    def __init__(self, num_vertices):
        # 顶点数量
        self.num_vertices = num_vertices
        # 创建 num_vertices x num_vertices 的二维数组，初始值全为 0
        # 每一行都是一个列表，初始值为 0
        self.matrix = [[0] * num_vertices for _ in range(num_vertices)]

    def add_edge(self, u, v):
        """
        添加一条边：连接顶点 u 和顶点 v
        无向图需要对称设置：matrix[u][v] = 1 且 matrix[v][u] = 1
        """
        self.matrix[u][v] = 1
        self.matrix[v][u] = 1  # 无向图，双向都要标记

    def remove_edge(self, u, v):
        """删除顶点 u 和 v 之间的边"""
        self.matrix[u][v] = 0
        self.matrix[v][u] = 0

    def has_edge(self, u, v):
        """检查顶点 u 和 v 之间是否有边"""
        return self.matrix[u][v] == 1

    def get_neighbors(self, u):
        """获取顶点 u 的所有邻居（和 u 直接相连的顶点）"""
        neighbors = []
        for v in range(self.num_vertices):
            if self.matrix[u][v] == 1:
                neighbors.append(v)
        return neighbors

    def display(self):
        """打印邻接矩阵"""
        print("邻接矩阵：")
        # 先打印列号
        print("    " + "  ".join(str(i) for i in range(self.num_vertices)))
        for i in range(self.num_vertices):
            # 每行前面打印行号
            print(f"  {i} {self.matrix[i]}")


# ===== 测试 =====
print("=" * 40)
print("邻接矩阵演示")
print("=" * 40)

g = GraphMatrix(4)
g.add_edge(0, 1)
g.add_edge(0, 2)
g.add_edge(1, 2)
g.add_edge(1, 3)
g.add_edge(2, 3)

g.display()
print(f"\n顶点 1 的邻居: {g.get_neighbors(1)}")  # [0, 2, 3]
print(f"顶点 0 和 3 之间有边吗? {g.has_edge(0, 3)}")  # False
```

##### 3.2 邻接表（Adjacency List）

**思想**：用一个字典（或数组），每个顶点对应一个列表，列出它的所有邻居。

```python
"""
邻接表实现图

同样的图：
    0 --- 1
    |   / |
    |  /  |
    | /   |
    2 --- 3

邻接表表示为：
    0 -> [1, 2]        顶点0的邻居是1和2
    1 -> [0, 2, 3]     顶点1的邻居是0、2、3
    2 -> [0, 1, 3]     顶点2的邻居是0、1、3
    3 -> [1, 2]        顶点3的邻居是1和2

就像电话簿：每个人的名字后面跟着他所有朋友的名单
"""


class GraphList:
    """用邻接表实现无向图"""

    def __init__(self):
        # 用字典存储：键是顶点，值是该顶点的邻居列表
        self.adj_list = {}

    def add_vertex(self, v):
        """添加一个顶点（如果还没有的话）"""
        if v not in self.adj_list:
            self.adj_list[v] = []

    def add_edge(self, u, v):
        """
        添加一条边：连接顶点 u 和 v
        先确保两个顶点都存在
        无向图：u 的列表加 v，v 的列表加 u
        """
        self.add_vertex(u)  # 确保顶点存在
        self.add_vertex(v)
        self.adj_list[u].append(v)
        self.adj_list[v].append(u)  # 无向图，双向添加

    def remove_edge(self, u, v):
        """删除顶点 u 和 v 之间的边"""
        if u in self.adj_list and v in self.adj_list[u]:
            self.adj_list[u].remove(v)
        if v in self.adj_list and u in self.adj_list[v]:
            self.adj_list[v].remove(u)

    def get_neighbors(self, u):
        """获取顶点 u 的所有邻居"""
        return self.adj_list.get(u, [])

    def has_edge(self, u, v):
        """检查 u 和 v 之间是否有边"""
        return v in self.adj_list.get(u, [])

    def display(self):
        """打印邻接表"""
        print("邻接表：")
        for vertex in self.adj_list:
            print(f"  {vertex} -> {self.adj_list[vertex]}")


# ===== 测试 =====
print("=" * 40)
print("邻接表演示")
print("=" * 40)

g2 = GraphList()
g2.add_edge(0, 1)
g2.add_edge(0, 2)
g2.add_edge(1, 2)
g2.add_edge(1, 3)
g2.add_edge(2, 3)

g2.display()
print(f"\n顶点 1 的邻居: {g2.get_neighbors(1)}")  # [0, 2, 3]
print(f"顶点 0 和 3 之间有边吗? {g2.has_edge(0, 3)}")  # False
```

##### 3.3 两种存储方式对比

| 对比项 | 邻接矩阵 | 邻接表 |
|--------|----------|--------|
| **空间复杂度** | O(V²)，V 是顶点数 | O(V + E)，E 是边数 |
| **查询"u和v是否相连"** | O(1)，直接查 matrix[u][v] | O(度)，需要遍历列表 |
| **添加/删除边** | O(1) | O(度) |
| **获取某顶点的所有邻居** | O(V)，需要遍历整行 | O(度)，直接返回列表 |
| **适合场景** | 稠密图（边很多，接近 V²） | 稀疏图（边很少，远小于 V²） |
| **实现难度** | 简单 | 稍复杂 |

> 生活类比：
> - 邻接矩阵就像一张全班同学的"认识关系表"，50个人就要 50×50=2500 格，但大部分人只认识其中几个人，大量格子是空的。
> - 邻接表就像每个人的手机通讯录，只存自己真正认识的人，省空间但查"张三认不认识李四"要翻张三的通讯录。

---

#### 四、图的遍历

图的遍历是图算法的基础。因为图不像树有明确的从上到下的方向，所以需要特殊处理——**防止重复访问**。

##### 4.1 DFS 深度优先搜索

**核心思想**：一条路走到黑，走不通了再回头（回溯），换一条路继续走。

> 类比：走迷宫时，你总是选择右手边的路一直走，走到死胡同就退回到上一个岔路口，换一条路继续走。

```python
"""
DFS 递归实现

从起始顶点开始：
1. 标记当前顶点为"已访问"
2. 对当前顶点的每个"未访问"邻居，递归执行 DFS
"""


def dfs_recursive(graph, start, visited=None):
    """
    DFS 递归实现
    
    参数:
        graph: 邻接表形式的图（字典）
        start: 起始顶点
        visited: 已访问集合，用于防止重复访问
    """
    # 第一次调用时初始化 visited 集合
    if visited is None:
        visited = set()

    # 标记当前顶点为已访问
    visited.add(start)
    print(start, end=" ")  # 访问（打印）当前顶点

    # 遍历当前顶点的所有邻居
    for neighbor in graph.get(start, []):
        if neighbor not in visited:
            # 邻居没访问过，递归访问它
            dfs_recursive(graph, neighbor, visited)

    return visited


# ===== 测试 =====
print("=" * 40)
print("DFS 递归实现")
print("=" * 40)

# 构建一个图（用字典表示邻接表）
#
#   0 --- 1 --- 3
#   |     |
#   |     |
#   2     4
#
graph = {
    0: [1, 2],
    1: [0, 3, 4],
    2: [0],
    3: [1],
    4: [1]
}

print("DFS遍历顺序: ", end="")
dfs_recursive(graph, 0)
# 输出: 0 1 3 4 2
```

```python
"""
DFS 迭代实现（用栈）

递归本质上就是系统帮你维护了一个"调用栈"。
我们自己用栈来模拟这个过程：
1. 把起始顶点压入栈
2. 每次从栈顶弹出一个顶点
3. 如果它没被访问过，标记为已访问
4. 把它的所有未访问邻居压入栈
"""


def dfs_iterative(graph, start):
    """
    DFS 迭代实现（用栈）
    
    参数:
        graph: 邻接表形式的图（字典）
        start: 起始顶点
    """
    visited = set()  # 记录已访问的顶点
    stack = [start]  # 用列表模拟栈

    while stack:
        # 从栈顶弹出一个顶点
        vertex = stack.pop()

        if vertex not in visited:
            # 标记为已访问
            visited.add(vertex)
            print(vertex, end=" ")  # 访问当前顶点

            # 把邻居压入栈
            # 注意：这里逆序压入，让左边的邻居先被访问（和递归顺序一致）
            # 不逆序也可以，只是遍历顺序略有不同
            for neighbor in reversed(graph.get(vertex, [])):
                if neighbor not in visited:
                    stack.append(neighbor)

    return visited


# ===== 测试 =====
print("\n" + "=" * 40)
print("DFS 迭代实现")
print("=" * 40)

print("DFS遍历顺序: ", end="")
dfs_iterative(graph, 0)
# 输出: 0 1 3 4 2
```

> **为什么需要 visited 集合？**
>
> 因为图中可能存在环！比如 A-B-C-A，如果没有 visited 集合：
> A 访问 B，B 访问 C，C 又访问 A，A 又访问 B……无限循环！
> visited 集合就像在地上做标记——"这条路我走过了"。

##### 4.2 BFS 广度优先搜索

**核心思想**：像往水里扔石头一样，波纹一圈一圈向外扩散。先访问所有距离为 1 的邻居，再访问距离为 2 的邻居，以此类推。

> 类比：疫情传播——第一天传染给密切接触者，第二天传染给密切接触者的接触者……一层层扩散。

```python
"""
BFS 实现（用队列）

从起始顶点开始：
1. 把起始顶点放入队列
2. 每次从队列头部取出一个顶点
3. 如果它没被访问过，标记为已访问
4. 把它的所有未访问邻居放入队列尾部

队列的"先进先出"特性保证了按层次遍历
"""
from collections import deque


def bfs(graph, start):
    """
    BFS 广度优先搜索
    
    参数:
        graph: 邻接表形式的图（字典）
        start: 起始顶点
    """
    visited = set()        # 记录已访问的顶点
    queue = deque([start]) # 用双端队列实现队列

    while queue:
        # 从队列头部取出一个顶点
        vertex = queue.popleft()

        if vertex not in visited:
            # 标记为已访问
            visited.add(vertex)
            print(vertex, end=" ")  # 访问当前顶点

            # 把邻居加入队列尾部
            for neighbor in graph.get(vertex, []):
                if neighbor not in visited:
                    queue.append(neighbor)

    return visited


# ===== 测试 =====
print("=" * 40)
print("BFS 实现")
print("=" * 40)

#
#   0 --- 1 --- 3
#   |     |
#   |     |
#   2     4
#
graph = {
    0: [1, 2],
    1: [0, 3, 4],
    2: [0],
    3: [1],
    4: [1]
}

print("BFS遍历顺序: ", end="")
bfs(graph, 0)
# 输出: 0 1 2 3 4
# 注意和 DFS 的区别！BFS 是按层遍历的
```

##### 4.3 BFS 求最短路径（无权图）

```python
"""
BFS 求无权图的最短路径

BFS 按层遍历的特性天然适合求最短路径：
- 第 0 层：起点本身（距离 0）
- 第 1 层：距起点 1 步的顶点
- 第 2 层：距起点 2 步的顶点
- ...

用 parent 字典记录每个顶点是从哪个顶点过来的，
这样就能从终点反向追溯到起点，得到完整路径。
"""
from collections import deque


def bfs_shortest_path(graph, start, end):
    """
    用 BFS 求无权图中 start 到 end 的最短路径
    
    返回: (距离, 路径列表)  如果不可达返回 (-1, [])
    """
    if start == end:
        return (0, [start])

    # visited 记录已访问的顶点
    visited = set([start])
    # queue 中存储 (当前顶点, 从起点到这里的距离)
    queue = deque([(start, 0)])
    # parent 记录每个顶点的"前驱"，用于回溯路径
    parent = {start: None}

    while queue:
        vertex, distance = queue.popleft()

        for neighbor in graph.get(vertex, []):
            if neighbor not in visited:
                visited.add(neighbor)
                parent[neighbor] = vertex  # 记录：neighbor 是从 vertex 过来的
                queue.append((neighbor, distance + 1))

                # 找到目标，提前结束
                if neighbor == end:
                    # 从终点反向回溯，构建路径
                    path = []
                    current = end
                    while current is not None:
                        path.append(current)
                        current = parent[current]
                    path.reverse()  # 反转，从起点到终点
                    return (distance + 1, path)

    # 不可达
    return (-1, [])


# ===== 测试 =====
print("=" * 40)
print("BFS 求最短路径")
print("=" * 40)

#
#   0 --- 1 --- 3 --- 5
#   |     |     |
#   |     |     |
#   2     4     6
#    \         /
#     --- 7 ---
#
graph = {
    0: [1, 2],
    1: [0, 3, 4],
    2: [0, 7],
    3: [1, 5, 6],
    4: [1],
    5: [3],
    6: [3, 7],
    7: [2, 6]
}

dist, path = bfs_shortest_path(graph, 0, 5)
print(f"从 0 到 5 的最短距离: {dist}")   # 3
print(f"最短路径: {path}")               # [0, 1, 3, 5]

dist, path = bfs_shortest_path(graph, 0, 7)
print(f"从 0 到 7 的最短距离: {dist}")   # 2
print(f"最短路径: {path}")               # [0, 2, 7]
```

---

#### 五、经典图问题

##### 5.1 岛屿数量（LeetCode 200）

**题目**：给你一个由 '1'（陆地）和 '0'（水）组成的二维网格，计算岛屿的数量。岛屿被水包围，且由相邻（上下左右）的陆地连接形成。

```python
"""
岛屿数量 - DFS 解法

思路：
遍历整个网格，每发现一个 '1'（陆地），就：
1. 岛屿计数 +1
2. 用 DFS 把与它相连的所有 '1' 都标记为已访问（变成 '0'）
3. 这样就不会重复计数同一个岛屿

类比：你在地图上看到一群岛屿，每发现一个新岛屿，
     就派一架飞机把整个岛屿都插上旗帜，表示"这个岛我来过了"。
"""


def numIslands_dfs(grid):
    """DFS 解法"""
    if not grid:
        return 0

    rows = len(grid)
    cols = len(grid[0])
    count = 0  # 岛屿计数

    def dfs(r, c):
        """
        从 (r, c) 开始，用 DFS 把所有相连的陆地都标记为水
        """
        # 边界检查：越界或者不是陆地，直接返回
        if r < 0 or r >= rows or c < 0 or c >= cols or grid[r][c] != '1':
            return

        # 标记为已访问（变成水，防止重复访问）
        grid[r][c] = '0'

        # 向四个方向扩展
        dfs(r + 1, c)  # 下
        dfs(r - 1, c)  # 上
        dfs(r, c + 1)  # 右
        dfs(r, c - 1)  # 左

    # 遍历整个网格
    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == '1':
                # 发现新岛屿！
                count += 1
                # 把整个岛屿都标记掉
                dfs(r, c)

    return count


# ===== 测试 =====
print("=" * 40)
print("岛屿数量 - DFS")
print("=" * 40)

grid = [
    ['1', '1', '0', '0', '0'],
    ['1', '1', '0', '0', '0'],
    ['0', '0', '1', '0', '0'],
    ['0', '0', '0', '1', '1']
]
# 可视化：
# 1 1 0 0 0     ← 左上角一个岛屿
# 1 1 0 0 0
# 0 0 1 0 0     ← 中间一个岛屿
# 0 0 0 1 1     ← 右下角一个岛屿

print(f"岛屿数量: {numIslands_dfs(grid)}")  # 3
```

```python
"""
岛屿数量 - BFS 解法

思路类似，只是用 BFS 来"淹没"整个岛屿
"""
from collections import deque


def numIslands_bfs(grid):
    """BFS 解法"""
    if not grid:
        return 0

    rows = len(grid)
    cols = len(grid[0])
    count = 0

    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == '1':
                count += 1
                # 用 BFS 把整个岛屿淹没
                queue = deque([(r, c)])
                grid[r][c] = '0'  # 入队时就标记

                while queue:
                    curr_r, curr_c = queue.popleft()
                    # 四个方向
                    for dr, dc in [(1, 0), (-1, 0), (0, 1), (0, -1)]:
                        nr, nc = curr_r + dr, curr_c + dc
                        # 检查边界且是陆地
                        if 0 <= nr < rows and 0 <= nc < cols and grid[nr][nc] == '1':
                            grid[nr][nc] = '0'  # 标记为已访问
                            queue.append((nr, nc))

    return count


# ===== 测试 =====
print("=" * 40)
print("岛屿数量 - BFS")
print("=" * 40)

grid2 = [
    ['1', '1', '0', '0', '0'],
    ['1', '1', '0', '0', '0'],
    ['0', '0', '1', '0', '0'],
    ['0', '0', '0', '1', '1']
]

print(f"岛屿数量: {numIslands_bfs(grid2)}")  # 3
```

##### 5.2 课程表（LeetCode 207）

**题目**：你要选修 numCourses 门课，编号 0 到 numCourses-1。有些课有先修要求，比如 [0, 1] 表示学课程 0 之前必须先学课程 1。判断是否能完成所有课程。

```python
"""
课程表 - 拓扑排序解法

本质：判断有向图中是否有环
- 有环 → 不可能完成（比如 A 要求先学 B，B 要求先学 A，死循环）
- 无环 → 可以完成

思路：用拓扑排序
如果能排出一个合法的学习顺序（所有课都能排上），说明无环，可以完成。

类比：排课表
- 没有先修要求的课可以随时排
- 有先修要求的课必须排在先修课之后
- 如果排不出来（循环依赖），说明课表有问题
"""
from collections import deque


def canFinish(numCourses, prerequisites):
    """
    判断是否能完成所有课程
    
    参数:
        numCourses: 课程总数
        prerequisites: 先修关系列表，每个元素 [course, prereq]
                       表示学 course 之前必须先学 prereq
    """
    # 构建邻接表和入度数组
    adj = [[] for _ in range(numCourses)]  # 邻接表
    in_degree = [0] * numCourses           # 每个顶点的入度

    for course, prereq in prerequisites:
        adj[prereq].append(course)  # prereq -> course（学完 prereq 才能学 course）
        in_degree[course] += 1      # course 的入度 +1

    # Kahn 算法（BFS 拓扑排序）
    # 把所有入度为 0 的顶点（没有先修要求的课）放入队列
    queue = deque()
    for i in range(numCourses):
        if in_degree[i] == 0:
            queue.append(i)

    # 记录能学的课程数量
    count = 0

    while queue:
        # 取出一门可以学的课（入度为 0）
        course = queue.popleft()
        count += 1

        # 学完这门课后，它指向的课程的入度都减 1
        for next_course in adj[course]:
            in_degree[next_course] -= 1
            # 如果入度变成 0，说明先修课都学完了，可以学了
            if in_degree[next_course] == 0:
                queue.append(next_course)

    # 如果所有课都能学完，说明无环
    return count == numCourses


# ===== 测试 =====
print("=" * 40)
print("课程表")
print("=" * 40)

# 4 门课，先修关系：
# 学 1 要先学 0
# 学 2 要先学 0 和 1
# 学 3 要先学 1
print(canFinish(4, [[1, 0], [2, 0], [2, 1], [3, 1]]))  # True

# 有环的情况：学 0 要先学 1，学 1 要先学 0
print(canFinish(2, [[1, 0], [0, 1]]))  # False
```

##### 5.3 克隆图（LeetCode 133）

**题目**：给定一个无向连通图的节点引用，返回该图的深拷贝（克隆）。

```python
"""
克隆图

思路：
1. 用 DFS/BFS 遍历原图的每个节点
2. 为每个节点创建一个副本
3. 用哈希表记录"原节点 -> 副本节点"的映射，防止重复创建

类比：你要照搬一座乐高城堡
- 每拆一块积木，就买一块一模一样的新积木
- 用一个清单记录"原来的红色2x4积木 → 新的红色2x4积木"
- 这样拼到新城堡时，相同的积木不会重复买
"""


class Node:
    """图的节点定义"""
    def __init__(self, val=0, neighbors=None):
        self.val = val
        self.neighbors = neighbors if neighbors is not None else []


def cloneGraph(node):
    """
    克隆图（DFS 实现）
    
    参数:
        node: 原图的某个节点引用
    返回:
        克隆图中对应节点的引用
    """
    if node is None:
        return None

    # 哈希表：原节点 -> 克隆节点
    visited = {}

    def dfs(node):
        # 如果这个节点已经克隆过了，直接返回副本
        if node in visited:
            return visited[node]

        # 创建新节点（先不连边）
        clone = Node(node.val)
        # 先放入哈希表，防止图中有环导致无限递归
        visited[node] = clone

        # 递归克隆所有邻居，并连接到新节点
        for neighbor in node.neighbors:
            clone.neighbors.append(dfs(neighbor))

        return clone

    return dfs(node)


# ===== 测试 =====
print("=" * 40)
print("克隆图")
print("=" * 40)

# 构建测试图：
#   1 --- 2
#   |     |
#   |     |
#   4 --- 3
n1 = Node(1)
n2 = Node(2)
n3 = Node(3)
n4 = Node(4)
n1.neighbors = [n2, n4]
n2.neighbors = [n1, n3]
n3.neighbors = [n2, n4]
n4.neighbors = [n1, n3]

cloned = cloneGraph(n1)
print(f"原图节点1的值: {n1.val}")
print(f"克隆节点1的值: {cloned.val}")
print(f"是否是同一个对象? {n1 is cloned}")  # False
print(f"克隆节点1的邻居值: {[n.val for n in cloned.neighbors]}")  # [2, 4]
```

---

#### 六、拓扑排序

##### 概念

**拓扑排序**：对一个有向无环图（DAG）的所有顶点排成一个线性序列，使得对每条边 u→v，u 都排在 v 前面。

> 类比：大学的课程先修关系
> - 学"数据结构"之前要先学"C语言"
> - 学"操作系统"之前要先学"数据结构"
> - 拓扑排序就是排出一个合法的修课顺序：C语言 → 数据结构 → 操作系统

##### 6.1 Kahn 算法（BFS 实现）

```python
"""
Kahn 算法（基于 BFS 的拓扑排序）

思路：
1. 计算每个顶点的入度
2. 把所有入度为 0 的顶点放入队列（它们没有前置依赖）
3. 每次从队列取出一个顶点，加入结果列表
4. 把它的所有邻居的入度减 1（相当于"完成"了这门先修课）
5. 如果某个邻居的入度变成 0，放入队列
6. 重复直到队列为空

如果结果列表包含所有顶点 → 排序成功，图中无环
如果结果列表少于所有顶点 → 图中有环，无法排序
"""
from collections import deque


def topological_sort_kahn(num_vertices, edges):
    """
    Kahn 算法实现拓扑排序
    
    参数:
        num_vertices: 顶点数量
        edges: 边的列表，每个元素 (u, v) 表示 u -> v
    返回:
        拓扑排序结果列表，如果有环返回 None
    """
    # 构建邻接表和入度数组
    adj = [[] for _ in range(num_vertices)]
    in_degree = [0] * num_vertices

    for u, v in edges:
        adj[u].append(v)
        in_degree[v] += 1  # v 的入度 +1

    # 把所有入度为 0 的顶点入队
    queue = deque()
    for i in range(num_vertices):
        if in_degree[i] == 0:
            queue.append(i)

    result = []  # 拓扑排序结果

    while queue:
        u = queue.popleft()
        result.append(u)

        # u "完成"后，它指向的顶点入度减 1
        for v in adj[u]:
            in_degree[v] -= 1
            if in_degree[v] == 0:
                queue.append(v)

    # 检查是否所有顶点都被排序了
    if len(result) == num_vertices:
        return result
    else:
        return None  # 有环！


# ===== 测试 =====
print("=" * 40)
print("Kahn 算法拓扑排序")
print("=" * 40)

# 课程依赖关系：
# 0(C语言) -> 1(数据结构) -> 3(操作系统)
# 0(C语言) -> 2(离散数学) -> 4(编译原理)
# 1(数据结构) -> 4(编译原理)

edges = [(0, 1), (0, 2), (1, 3), (1, 4), (2, 4), (3, 4)]
result = topological_sort_kahn(5, edges)
print(f"拓扑排序结果: {result}")
# 可能的结果: [0, 1, 2, 3, 4] 或 [0, 2, 1, 3, 4] 等

# 有环的情况
edges_with_cycle = [(0, 1), (1, 2), (2, 0)]
result2 = topological_sort_kahn(3, edges_with_cycle)
print(f"有环时的结果: {result2}")  # None
```

##### 6.2 DFS 实现拓扑排序

```python
"""
DFS 实现拓扑排序

思路：
1. 对每个未访问的顶点执行 DFS
2. DFS 的核心：先递归处理所有邻居，再把当前顶点加入结果
3. 最终将结果反转，就是拓扑排序

为什么 DFS 后序遍历的反转是拓扑排序？
- DFS 后序：先加入"最后才完成的"顶点
- 反转后：先修课排在前面
"""


def topological_sort_dfs(num_vertices, edges):
    """DFS 实现拓扑排序"""
    adj = [[] for _ in range(num_vertices)]
    for u, v in edges:
        adj[u].append(v)

    visited = set()
    result = []

    def dfs(u):
        visited.add(u)
        for v in adj[u]:
            if v not in visited:
                dfs(v)
        # 所有邻居都处理完了，才把 u 加入结果
        result.append(u)

    # 对每个未访问的顶点执行 DFS
    for i in range(num_vertices):
        if i not in visited:
            dfs(i)

    # 反转结果
    result.reverse()
    return result


# ===== 测试 =====
print("=" * 40)
print("DFS 拓扑排序")
print("=" * 40)

edges = [(0, 1), (0, 2), (1, 3), (1, 4), (2, 4), (3, 4)]
result = topological_sort_dfs(5, edges)
print(f"拓扑排序结果: {result}")
# 结果: [0, 2, 1, 3, 4] 或类似合法顺序
```

##### 6.3 检测环的存在

```python
"""
用 DFS 检测有向图中是否有环

核心思想：
在 DFS 过程中，维护两个集合：
- visited: 已经"彻底处理完"的顶点
- rec_stack: 当前 DFS 路径上的顶点（递归栈中的顶点）

如果 DFS 过程中遇到了一个在 rec_stack 中的顶点，
说明存在一条"回边"，即存在环！

类比：你在森林里探险
- visited = 已经探索完毕的区域
- rec_stack = 你当前正在走的路径上的标记
- 如果你发现前方的路标是你当前路径上已经见过的，说明你在绕圈！
"""


def has_cycle_dfs(num_vertices, edges):
    """检测有向图是否有环"""
    adj = [[] for _ in range(num_vertices)]
    for u, v in edges:
        adj[u].append(v)

    visited = set()      # 彻底处理完的顶点
    rec_stack = set()    # 当前递归路径上的顶点

    def dfs(u):
        visited.add(u)
        rec_stack.add(u)  # 进入递归栈

        for v in adj[u]:
            if v not in visited:
                # 未访问的邻居，继续 DFS
                if dfs(v):
                    return True
            elif v in rec_stack:
                # 遇到递归栈中的顶点 → 有环！
                return True

        rec_stack.remove(u)  # 离开递归栈
        return False

    for i in range(num_vertices):
        if i not in visited:
            if dfs(i):
                return True

    return False


# ===== 测试 =====
print("=" * 40)
print("环检测")
print("=" * 40)

# 无环
print(has_cycle_dfs(4, [(0, 1), (1, 2), (0, 2)]))  # False

# 有环: 0 -> 1 -> 2 -> 0
print(has_cycle_dfs(3, [(0, 1), (1, 2), (2, 0)]))  # True
```

---

#### 七、连通性问题简介

```python
"""
图的连通性

无向图的连通性：
- 连通图：任意两个顶点之间都有路径
- 连通分量：极大连通子图（一个"孤岛"群体）

有向图的连通性：
- 强连通：任意两个顶点之间都互相可达
- 弱连通：忽略方向后是连通的

下面用 BFS 求无向图的连通分量
"""
from collections import deque


def connected_components(graph):
    """
    求无向图的所有连通分量
    
    参数:
        graph: 邻接表（字典形式）
    返回:
        连通分量列表
    """
    visited = set()
    components = []

    # 遍历所有顶点
    for vertex in graph:
        if vertex not in visited:
            # 发现一个新的连通分量
            component = []
            # 用 BFS 遍历这个连通分量中的所有顶点
            queue = deque([vertex])
            visited.add(vertex)

            while queue:
                v = queue.popleft()
                component.append(v)
                for neighbor in graph.get(v, []):
                    if neighbor not in visited:
                        visited.add(neighbor)
                        queue.append(neighbor)

            components.append(component)

    return components


# ===== 测试 =====
print("=" * 40)
print("连通分量")
print("=" * 40)

# 三个连通分量：
# {0, 1, 2}  {3, 4}  {5}
graph = {
    0: [1, 2],
    1: [0, 2],
    2: [0, 1],
    3: [4],
    4: [3],
    5: []
}

components = connected_components(graph)
print(f"连通分量: {components}")
# [[0, 1, 2], [3, 4], [5]]
print(f"连通分量数量: {len(components)}")  # 3
```

---

### 主题16 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、邻接矩阵存储

```typescript
// ========== 邻接矩阵实现图（无向图） ==========
// 用二维数组表示顶点之间的连接关系
// matrix[i][j] = 1 表示顶点 i 和 j 之间有边
class GraphMatrix {
    private numVertices: number;
    private matrix: number[][];

    constructor(numVertices: number) {
        this.numVertices = numVertices;
        // 创建 numVertices x numVertices 的二维数组，初始值全为 0
        this.matrix = Array.from({ length: numVertices }, () =>
            new Array<number>(numVertices).fill(0)
        );
    }

    // 添加一条边：连接顶点 u 和 v
    // 无向图需要对称设置
    addEdge(u: number, v: number): void {
        this.matrix[u][v] = 1;
        this.matrix[v][u] = 1; // 无向图，双向都要标记
    }

    // 删除边
    removeEdge(u: number, v: number): void {
        this.matrix[u][v] = 0;
        this.matrix[v][u] = 0;
    }

    // 检查是否有边
    hasEdge(u: number, v: number): boolean {
        return this.matrix[u][v] === 1;
    }

    // 获取所有邻居
    getNeighbors(u: number): number[] {
        const neighbors: number[] = [];
        for (let v = 0; v < this.numVertices; v++) {
            if (this.matrix[u][v] === 1) neighbors.push(v);
        }
        return neighbors;
    }

    display(): void {
        console.log("邻接矩阵：");
        // 列号
        const header = Array.from({ length: this.numVertices }, (_, i) => i).join("  ");
        console.log(`    ${header}`);
        for (let i = 0; i < this.numVertices; i++) {
            console.log(`  ${i} [${this.matrix[i].join(", ")}]`);
        }
    }
}

// 测试
console.log("=".repeat(40));
console.log("邻接矩阵演示");
console.log("=".repeat(40));
const g = new GraphMatrix(4);
g.addEdge(0, 1);
g.addEdge(0, 2);
g.addEdge(1, 2);
g.addEdge(1, 3);
g.addEdge(2, 3);
g.display();
console.log(`\n顶点 1 的邻居: ${g.getNeighbors(1)}`);  // [0, 2, 3]
console.log(`顶点 0 和 3 之间有边吗? ${g.hasEdge(0, 3)}`);  // false
```

##### 二、邻接表存储

```typescript
// ========== 邻接表实现图（无向图） ==========
// 用 Map 存储：键是顶点，值是该顶点的邻居列表
class GraphList {
    private adjList = new Map<number, number[]>();

    // 添加顶点
    addVertex(v: number): void {
        if (!this.adjList.has(v)) {
            this.adjList.set(v, []);
        }
    }

    // 添加边
    addEdge(u: number, v: number): void {
        this.addVertex(u); // 确保顶点存在
        this.addVertex(v);
        this.adjList.get(u)!.push(v);
        this.adjList.get(v)!.push(u); // 无向图，双向添加
    }

    // 删除边
    removeEdge(u: number, v: number): void {
        const lu = this.adjList.get(u);
        const lv = this.adjList.get(v);
        if (lu) {
            const idx = lu.indexOf(v);
            if (idx !== -1) lu.splice(idx, 1);
        }
        if (lv) {
            const idx = lv.indexOf(u);
            if (idx !== -1) lv.splice(idx, 1);
        }
    }

    // 获取邻居
    getNeighbors(u: number): number[] {
        return this.adjList.get(u) ?? [];
    }

    // 检查是否有边
    hasEdge(u: number, v: number): boolean {
        return (this.adjList.get(u) ?? []).includes(v);
    }

    display(): void {
        console.log("邻接表：");
        for (const [vertex, neighbors] of this.adjList) {
            console.log(`  ${vertex} -> [${neighbors.join(", ")}]`);
        }
    }
}

// 测试
console.log("=".repeat(40));
console.log("邻接表演示");
console.log("=".repeat(40));
const g2 = new GraphList();
g2.addEdge(0, 1);
g2.addEdge(0, 2);
g2.addEdge(1, 2);
g2.addEdge(1, 3);
g2.addEdge(2, 3);
g2.display();
console.log(`\n顶点 1 的邻居: ${g2.getNeighbors(1)}`);  // [0, 2, 3]
console.log(`顶点 0 和 3 之间有边吗? ${g2.hasEdge(0, 3)}`);  // false
```

##### 三、图的遍历：DFS 与 BFS

```typescript
// ========== DFS 深度优先搜索 ==========

// 递归实现
function dfsRecursive(
    graph: Map<number, number[]>,
    start: number,
    visited: Set<number> = new Set()
): Set<number> {
    visited.add(start);               // 标记当前顶点为已访问
    console.log(start + " "); // 访问当前顶点

    for (const neighbor of graph.get(start) ?? []) {
        if (!visited.has(neighbor)) {
            dfsRecursive(graph, neighbor, visited); // 递归访问
        }
    }
    return visited;
}

// 迭代实现（用栈）
function dfsIterative(graph: Map<number, number[]>, start: number): Set<number> {
    const visited = new Set<number>();
    const stack = [start]; // 用数组模拟栈

    while (stack.length > 0) {
        const vertex = stack.pop()!;

        if (!visited.has(vertex)) {
            visited.add(vertex);
            console.log(vertex + " ");

            // 逆序压入，让左边的邻居先被访问（和递归顺序一致）
            const neighbors = graph.get(vertex) ?? [];
            for (let i = neighbors.length - 1; i >= 0; i--) {
                if (!visited.has(neighbors[i])) {
                    stack.push(neighbors[i]);
                }
            }
        }
    }
    return visited;
}

// ========== BFS 广度优先搜索 ==========
// 用队列实现，先进先出保证按层遍历
function bfs(graph: Map<number, number[]>, start: number): Set<number> {
    const visited = new Set<number>();
    const queue: number[] = [start];

    while (queue.length > 0) {
        const vertex = queue.shift()!; // 从队头取出

        if (!visited.has(vertex)) {
            visited.add(vertex);
            console.log(vertex + " ");

            for (const neighbor of graph.get(vertex) ?? []) {
                if (!visited.has(neighbor)) {
                    queue.push(neighbor);
                }
            }
        }
    }
    return visited;
}

// ========== BFS 求无权图的最短路径 ==========
function bfsShortestPath(
    graph: Map<number, number[]>,
    start: number,
    end: number
): [number, number[]] {
    if (start === end) return [0, [start]];

    const visited = new Set<number>([start]);
    const queue: Array<[number, number]> = [[start, 0]]; // [当前顶点, 距离]
    const parent = new Map<number, number | null>([[start, null]]);

    while (queue.length > 0) {
        const [vertex, distance] = queue.shift()!;

        for (const neighbor of graph.get(vertex) ?? []) {
            if (!visited.has(neighbor)) {
                visited.add(neighbor);
                parent.set(neighbor, vertex); // 记录前驱
                queue.push([neighbor, distance + 1]);

                if (neighbor === end) {
                    // 从终点反向回溯构建路径
                    const path: number[] = [];
                    let current: number | null = end;
                    while (current !== null) {
                        path.push(current);
                        current = parent.get(current) ?? null;
                    }
                    path.reverse();
                    return [distance + 1, path];
                }
            }
        }
    }
    return [-1, []]; // 不可达
}

// ===== 测试 =====
const graph16 = new Map<number, number[]>([
    [0, [1, 2]],
    [1, [0, 3, 4]],
    [2, [0]],
    [3, [1]],
    [4, [1]],
]);
console.log("=".repeat(40));
console.log("DFS/BFS 演示");
console.log("=".repeat(40));
console.log("DFS递归: "); dfsRecursive(graph16, 0); console.log(); // 0 1 3 4 2
console.log("DFS迭代: "); dfsIterative(graph16, 0); console.log(); // 0 1 3 4 2
console.log("BFS:     "); bfs(graph16, 0); console.log();          // 0 1 2 3 4

// 最短路径测试
const graphBfs = new Map<number, number[]>([
    [0, [1, 2]],
    [1, [0, 3, 4]],
    [2, [0, 7]],
    [3, [1, 5, 6]],
    [4, [1]],
    [5, [3]],
    [6, [3, 7]],
    [7, [2, 6]],
]);
const [dist1, path1] = bfsShortestPath(graphBfs, 0, 5);
console.log(`从 0 到 5 的最短距离: ${dist1}`);   // 3
console.log(`最短路径: [${path1}]`);               // [0, 1, 3, 5]
const [dist2, path2] = bfsShortestPath(graphBfs, 0, 7);
console.log(`从 0 到 7 的最短距离: ${dist2}`);   // 2
console.log(`最短路径: [${path2}]`);               // [0, 2, 7]
```

##### 四、岛屿数量（LeetCode 200）

```typescript
// ========== 岛屿数量 ==========
// 思路：每发现一个 '1'，岛屿计数+1，并用 DFS 把整个岛屿标记为 '0'

// DFS 解法
function numIslandsDfs(grid: string[][]): number {
    if (grid.length === 0) return 0;

    const rows = grid.length;
    const cols = grid[0].length;
    let count = 0;

    const dfs = (r: number, c: number): void => {
        // 边界检查：越界或不是陆地
        if (r < 0 || r >= rows || c < 0 || c >= cols || grid[r][c] !== "1") return;

        grid[r][c] = "0"; // 标记为已访问（变成水）

        dfs(r + 1, c); // 下
        dfs(r - 1, c); // 上
        dfs(r, c + 1); // 右
        dfs(r, c - 1); // 左
    };

    for (let r = 0; r < rows; r++) {
        for (let c = 0; c < cols; c++) {
            if (grid[r][c] === "1") {
                count++;      // 发现新岛屿
                dfs(r, c);    // 淹没整个岛屿
            }
        }
    }
    return count;
}

// BFS 解法
function numIslandsBfs(grid: string[][]): number {
    if (grid.length === 0) return 0;

    const rows = grid.length;
    const cols = grid[0].length;
    const dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]]; // 四个方向
    let count = 0;

    for (let r = 0; r < rows; r++) {
        for (let c = 0; c < cols; c++) {
            if (grid[r][c] === "1") {
                count++;
                const queue: Array<[number, number]> = [[r, c]];
                grid[r][c] = "0"; // 入队时就标记

                while (queue.length > 0) {
                    const [currR, currC] = queue.shift()!;
                    for (const [dr, dc] of dirs) {
                        const nr = currR + dr;
                        const nc = currC + dc;
                        if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] === "1") {
                            grid[nr][nc] = "0";
                            queue.push([nr, nc]);
                        }
                    }
                }
            }
        }
    }
    return count;
}

// 测试
const grid16 = [
    ["1", "1", "0", "0", "0"],
    ["1", "1", "0", "0", "0"],
    ["0", "0", "1", "0", "0"],
    ["0", "0", "0", "1", "1"],
];
console.log(`岛屿数量(DFS): ${numIslandsDfs(grid16)}`);    // 3
console.log(`岛屿数量(BFS): ${numIslandsBfs(grid16)}`);    // 3
```

##### 五、课程表（LeetCode 207，拓扑排序）

```typescript
// ========== 课程表 ==========
// 本质：判断有向图是否有环（Kahn 算法）
function canFinish(numCourses: number, prerequisites: number[][]): boolean {
    // 构建邻接表和入度数组
    const adj: number[][] = Array.from({ length: numCourses }, () => []);
    const inDegree = new Array<number>(numCourses).fill(0);

    for (const [course, prereq] of prerequisites) {
        adj[prereq].push(course);   // prereq -> course
        inDegree[course]++;         // course 的入度 +1
    }

    // 把入度为 0 的课放入队列
    const queue: number[] = [];
    for (let i = 0; i < numCourses; i++) {
        if (inDegree[i] === 0) queue.push(i);
    }

    let count = 0; // 能学的课程数量
    while (queue.length > 0) {
        const course = queue.shift()!;
        count++;

        for (const next of adj[course]) {
            inDegree[next]--;
            if (inDegree[next] === 0) queue.push(next); // 先修课都学完了
        }
    }
    return count === numCourses; // 所有课都能学完 = 无环
}

console.log("=".repeat(40));
console.log("课程表");
console.log("=".repeat(40));
console.log(canFinish(4, [[1, 0], [2, 0], [2, 1], [3, 1]]));  // true
console.log(canFinish(2, [[1, 0], [0, 1]]));                  // false（有环）
```

##### 六、拓扑排序

```typescript
// ========== Kahn 算法（BFS 拓扑排序） ==========
function topologicalSortKahn(
    numVertices: number,
    edges: Array<[number, number]>
): number[] | null {
    const adj: number[][] = Array.from({ length: numVertices }, () => []);
    const inDegree = new Array<number>(numVertices).fill(0);

    for (const [u, v] of edges) {
        adj[u].push(v);
        inDegree[v]++; // v 的入度 +1
    }

    // 把所有入度为 0 的顶点入队
    const queue: number[] = [];
    for (let i = 0; i < numVertices; i++) {
        if (inDegree[i] === 0) queue.push(i);
    }

    const result: number[] = [];
    while (queue.length > 0) {
        const u = queue.shift()!;
        result.push(u);

        for (const v of adj[u]) {
            inDegree[v]--;
            if (inDegree[v] === 0) queue.push(v);
        }
    }

    // 检查是否所有顶点都被排序了
    return result.length === numVertices ? result : null; // 有环返回 null
}

// ========== DFS 实现拓扑排序 ==========
function topologicalSortDfs(numVertices: number, edges: Array<[number, number]>): number[] {
    const adj: number[][] = Array.from({ length: numVertices }, () => []);
    for (const [u, v] of edges) adj[u].push(v);

    const visited = new Set<number>();
    const result: number[] = [];

    const dfs = (u: number): void => {
        visited.add(u);
        for (const v of adj[u]) {
            if (!visited.has(v)) dfs(v);
        }
        result.push(u); // 所有邻居都处理完了才加入结果
    };

    for (let i = 0; i < numVertices; i++) {
        if (!visited.has(i)) dfs(i);
    }

    return result.reverse(); // 反转才是拓扑排序
}

// ========== 检测有向图是否有环 ==========
function hasCycleDfs(numVertices: number, edges: Array<[number, number]>): boolean {
    const adj: number[][] = Array.from({ length: numVertices }, () => []);
    for (const [u, v] of edges) adj[u].push(v);

    const visited = new Set<number>();   // 彻底处理完的顶点
    const recStack = new Set<number>();  // 当前递归路径上的顶点

    const dfs = (u: number): boolean => {
        visited.add(u);
        recStack.add(u); // 进入递归栈

        for (const v of adj[u]) {
            if (!visited.has(v)) {
                if (dfs(v)) return true;
            } else if (recStack.has(v)) {
                return true; // 遇到递归栈中的顶点 → 有环！
            }
        }
        recStack.delete(u); // 离开递归栈
        return false;
    };

    for (let i = 0; i < numVertices; i++) {
        if (!visited.has(i)) {
            if (dfs(i)) return true;
        }
    }
    return false;
}

// 测试
const edges16: Array<[number, number]> = [
    [0, 1], [0, 2], [1, 3], [1, 4], [2, 4], [3, 4],
];
console.log(`Kahn拓扑排序: ${JSON.stringify(topologicalSortKahn(5, edges16))}`);
// [0, 1, 2, 3, 4] 或 [0, 2, 1, 3, 4] 等
console.log(`DFS拓扑排序: ${JSON.stringify(topologicalSortDfs(5, edges16))}`);
console.log(`有环时Kahn结果: ${JSON.stringify(topologicalSortKahn(3, [[0, 1], [1, 2], [2, 0]]))}`);  // null
console.log(`环检测(有环): ${hasCycleDfs(3, [[0, 1], [1, 2], [2, 0]])}`);  // true
console.log(`环检测(无环): ${hasCycleDfs(4, [[0, 1], [1, 2], [0, 2]])}`);  // false
```

##### 七、连通分量

```typescript
// ========== 求无向图的所有连通分量 ==========
// 用 BFS 遍历每个连通分量
function connectedComponents(graph: Map<number, number[]>): number[][] {
    const visited = new Set<number>();
    const components: number[][] = [];

    for (const vertex of graph.keys()) {
        if (!visited.has(vertex)) {
            // 发现一个新的连通分量
            const component: number[] = [];
            const queue: number[] = [vertex];
            visited.add(vertex);

            while (queue.length > 0) {
                const v = queue.shift()!;
                component.push(v);
                for (const neighbor of graph.get(v) ?? []) {
                    if (!visited.has(neighbor)) {
                        visited.add(neighbor);
                        queue.push(neighbor);
                    }
                }
            }
            components.push(component);
        }
    }
    return components;
}

// 测试
const graphCC = new Map<number, number[]>([
    [0, [1, 2]],
    [1, [0, 2]],
    [2, [0, 1]],
    [3, [4]],
    [4, [3]],
    [5, []],
]);
const components = connectedComponents(graphCC);
console.log(`连通分量: ${JSON.stringify(components)}`);  // [[0,1,2],[3,4],[5]]
console.log(`连通分量数量: ${components.length}`);         // 3
```

### 主题16 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、邻接矩阵存储

```go
package main

import (
	"fmt"
	"strings"
)

// ========== 邻接矩阵实现图（无向图） ==========
type GraphMatrix struct {
	numVertices int
	matrix      [][]int
}

func NewGraphMatrix(numVertices int) *GraphMatrix {
	matrix := make([][]int, numVertices)
	for i := range matrix {
		matrix[i] = make([]int, numVertices)
	}
	return &GraphMatrix{numVertices: numVertices, matrix: matrix}
}

// 添加一条边（无向图，双向标记）
func (g *GraphMatrix) addEdge(u, v int) {
	g.matrix[u][v] = 1
	g.matrix[v][u] = 1
}

// 删除边
func (g *GraphMatrix) removeEdge(u, v int) {
	g.matrix[u][v] = 0
	g.matrix[v][u] = 0
}

// 检查是否有边
func (g *GraphMatrix) hasEdge(u, v int) bool {
	return g.matrix[u][v] == 1
}

// 获取所有邻居
func (g *GraphMatrix) getNeighbors(u int) []int {
	neighbors := []int{}
	for v := 0; v < g.numVertices; v++ {
		if g.matrix[u][v] == 1 {
			neighbors = append(neighbors, v)
		}
	}
	return neighbors
}

func (g *GraphMatrix) display() {
	fmt.Println("邻接矩阵：")
	cols := make([]string, g.numVertices)
	for i := 0; i < g.numVertices; i++ {
		cols[i] = fmt.Sprintf("%d", i)
	}
	fmt.Println("    " + strings.Join(cols, "  "))
	for i := 0; i < g.numVertices; i++ {
		fmt.Printf("  %d %v\n", i, g.matrix[i])
	}
}

func testGraphMatrix() {
	fmt.Println("===== 邻接矩阵演示 =====")
	g := NewGraphMatrix(4)
	g.addEdge(0, 1)
	g.addEdge(0, 2)
	g.addEdge(1, 2)
	g.addEdge(1, 3)
	g.addEdge(2, 3)
	g.display()
	fmt.Printf("\n顶点 1 的邻居: %v\n", g.getNeighbors(1)) // [0 2 3]
	fmt.Printf("顶点 0 和 3 之间有边吗? %v\n", g.hasEdge(0, 3)) // false
}
```

##### 二、邻接表存储

```go
package main

import "fmt"

// ========== 邻接表实现图（无向图） ==========
type GraphList struct {
	adjList map[int][]int
}

func NewGraphList() *GraphList {
	return &GraphList{adjList: make(map[int][]int)}
}

// 添加顶点
func (g *GraphList) addVertex(v int) {
	if _, ok := g.adjList[v]; !ok {
		g.adjList[v] = []int{}
	}
}

// 添加边（无向图，双向添加）
func (g *GraphList) addEdge(u, v int) {
	g.addVertex(u)
	g.addVertex(v)
	g.adjList[u] = append(g.adjList[u], v)
	g.adjList[v] = append(g.adjList[v], u)
}

// 删除边
func (g *GraphList) removeEdge(u, v int) {
	if list, ok := g.adjList[u]; ok {
		for i, x := range list {
			if x == v {
				g.adjList[u] = append(list[:i], list[i+1:]...)
				break
			}
		}
	}
	if list, ok := g.adjList[v]; ok {
		for i, x := range list {
			if x == u {
				g.adjList[v] = append(list[:i], list[i+1:]...)
				break
			}
		}
	}
}

// 获取邻居
func (g *GraphList) getNeighbors(u int) []int {
	return g.adjList[u]
}

// 检查是否有边
func (g *GraphList) hasEdge(u, v int) bool {
	for _, x := range g.adjList[u] {
		if x == v {
			return true
		}
	}
	return false
}

func (g *GraphList) display() {
	fmt.Println("邻接表：")
	for vertex, neighbors := range g.adjList {
		fmt.Printf("  %d -> %v\n", vertex, neighbors)
	}
}

func testGraphList() {
	fmt.Println("===== 邻接表演示 =====")
	g2 := NewGraphList()
	g2.addEdge(0, 1)
	g2.addEdge(0, 2)
	g2.addEdge(1, 2)
	g2.addEdge(1, 3)
	g2.addEdge(2, 3)
	g2.display()
	fmt.Printf("\n顶点 1 的邻居: %v\n", g2.getNeighbors(1)) // [0 2 3]
	fmt.Printf("顶点 0 和 3 之间有边吗? %v\n", g2.hasEdge(0, 3)) // false
}
```

##### 三、图的遍历：DFS 与 BFS

```go
package main

import "fmt"

// ========== DFS 深度优先搜索 ==========

// 递归实现
func dfsRecursive(graph map[int][]int, start int, visited map[int]bool) {
	visited[start] = true
	fmt.Printf("%d ", start) // 访问当前顶点

	for _, neighbor := range graph[start] {
		if !visited[neighbor] {
			dfsRecursive(graph, neighbor, visited)
		}
	}
}

// 迭代实现（用栈）
func dfsIterative(graph map[int][]int, start int) map[int]bool {
	visited := make(map[int]bool)
	stack := []int{start} // 用切片模拟栈

	for len(stack) > 0 {
		vertex := stack[len(stack)-1]   // 取栈顶
		stack = stack[:len(stack)-1]    // 弹出

		if !visited[vertex] {
			visited[vertex] = true
			fmt.Printf("%d ", vertex)

			// 逆序压入，让左边的邻居先被访问
			neighbors := graph[vertex]
			for i := len(neighbors) - 1; i >= 0; i-- {
				if !visited[neighbors[i]] {
					stack = append(stack, neighbors[i])
				}
			}
		}
	}
	return visited
}

// ========== BFS 广度优先搜索 ==========
func bfs(graph map[int][]int, start int) map[int]bool {
	visited := make(map[int]bool)
	queue := []int{start}

	for len(queue) > 0 {
		vertex := queue[0]   // 从队头取出
		queue = queue[1:]

		if !visited[vertex] {
			visited[vertex] = true
			fmt.Printf("%d ", vertex)

			for _, neighbor := range graph[vertex] {
				if !visited[neighbor] {
					queue = append(queue, neighbor)
				}
			}
		}
	}
	return visited
}

// ========== BFS 求无权图的最短路径 ==========
func bfsShortestPath(graph map[int][]int, start, end int) (int, []int) {
	if start == end {
		return 0, []int{start}
	}

	type Item struct {
		vertex   int
		distance int
	}

	visited := map[int]bool{start: true}
	queue := []Item{{vertex: start, distance: 0}}
	parent := map[int]int{start: -1}

	for len(queue) > 0 {
		item := queue[0]
		queue = queue[1:]

		for _, neighbor := range graph[item.vertex] {
			if !visited[neighbor] {
				visited[neighbor] = true
				parent[neighbor] = item.vertex // 记录前驱
				queue = append(queue, Item{vertex: neighbor, distance: item.distance + 1})

				if neighbor == end {
					// 从终点反向回溯构建路径
					path := []int{}
					cur := end
					for cur != -1 {
						path = append(path, cur)
						cur = parent[cur]
					}
					// 反转
					for i, j := 0, len(path)-1; i < j; i, j = i+1, j-1 {
						path[i], path[j] = path[j], path[i]
					}
					return item.distance + 1, path
				}
			}
		}
	}
	return -1, []int{} // 不可达
}

func testTraversal() {
	graph := map[int][]int{
		0: {1, 2},
		1: {0, 3, 4},
		2: {0},
		3: {1},
		4: {1},
	}
	fmt.Println("===== DFS/BFS 演示 =====")
	visited := map[int]bool{}
	fmt.Print("DFS递归: "); dfsRecursive(graph, 0, visited); fmt.Println() // 0 1 3 4 2
	fmt.Print("DFS迭代: "); dfsIterative(graph, 0); fmt.Println()          // 0 1 3 4 2
	fmt.Print("BFS:     "); bfs(graph, 0); fmt.Println()                   // 0 1 2 3 4

	// 最短路径测试
	graph2 := map[int][]int{
		0: {1, 2},
		1: {0, 3, 4},
		2: {0, 7},
		3: {1, 5, 6},
		4: {1},
		5: {3},
		6: {3, 7},
		7: {2, 6},
	}
	dist, path := bfsShortestPath(graph2, 0, 5)
	fmt.Printf("从 0 到 5 的最短距离: %d\n", dist) // 3
	fmt.Printf("最短路径: %v\n", path)           // [0 1 3 5]
	dist, path = bfsShortestPath(graph2, 0, 7)
	fmt.Printf("从 0 到 7 的最短距离: %d\n", dist) // 2
	fmt.Printf("最短路径: %v\n", path)           // [0 2 7]
}
```

##### 四、岛屿数量（LeetCode 200）

```go
package main

import "fmt"

// ========== 岛屿数量 ==========
// DFS 解法：每发现一个 '1'，计数+1，用 DFS 淹没整个岛屿
func numIslandsDfs(grid [][]byte) int {
	if len(grid) == 0 {
		return 0
	}
	rows := len(grid)
	cols := len(grid[0])
	count := 0

	var dfs func(r, c int)
	dfs = func(r, c int) {
		// 边界检查：越界或不是陆地
		if r < 0 || r >= rows || c < 0 || c >= cols || grid[r][c] != '1' {
			return
		}
		grid[r][c] = '0' // 标记为已访问

		dfs(r+1, c) // 下
		dfs(r-1, c) // 上
		dfs(r, c+1) // 右
		dfs(r, c-1) // 左
	}

	for r := 0; r < rows; r++ {
		for c := 0; c < cols; c++ {
			if grid[r][c] == '1' {
				count++
				dfs(r, c)
			}
		}
	}
	return count
}

// BFS 解法
func numIslandsBfs(grid [][]byte) int {
	if len(grid) == 0 {
		return 0
	}
	rows := len(grid)
	cols := len(grid[0])
	dirs := [][]int{{1, 0}, {-1, 0}, {0, 1}, {0, -1}}
	count := 0

	for r := 0; r < rows; r++ {
		for c := 0; c < cols; c++ {
			if grid[r][c] == '1' {
				count++
				queue := [][]int{{r, c}}
				grid[r][c] = '0' // 入队时就标记

				for len(queue) > 0 {
					curr := queue[0]
					queue = queue[1:]
					for _, d := range dirs {
						nr, nc := curr[0]+d[0], curr[1]+d[1]
						if nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] == '1' {
							grid[nr][nc] = '0'
							queue = append(queue, []int{nr, nc})
						}
					}
				}
			}
		}
	}
	return count
}

func testIslands() {
	grid := [][]byte{
		{'1', '1', '0', '0', '0'},
		{'1', '1', '0', '0', '0'},
		{'0', '0', '1', '0', '0'},
		{'0', '0', '0', '1', '1'},
	}
	fmt.Printf("岛屿数量(DFS): %d\n", numIslandsDfs(grid)) // 3
	grid2 := [][]byte{
		{'1', '1', '0', '0', '0'},
		{'1', '1', '0', '0', '0'},
		{'0', '0', '1', '0', '0'},
		{'0', '0', '0', '1', '1'},
	}
	fmt.Printf("岛屿数量(BFS): %d\n", numIslandsBfs(grid2)) // 3
}
```

##### 五、课程表与拓扑排序

```go
package main

import "fmt"

// ========== 课程表（LeetCode 207） ==========
// 本质：判断有向图是否有环（Kahn 算法）
func canFinish(numCourses int, prerequisites [][]int) bool {
	adj := make([][]int, numCourses)  // 邻接表
	inDegree := make([]int, numCourses) // 入度数组

	for _, p := range prerequisites {
		adj[p[1]] = append(adj[p[1]], p[0]) // prereq -> course
		inDegree[p[0]]++                     // course 的入度 +1
	}

	// 把入度为 0 的课放入队列
	queue := []int{}
	for i := 0; i < numCourses; i++ {
		if inDegree[i] == 0 {
			queue = append(queue, i)
		}
	}

	count := 0
	for len(queue) > 0 {
		course := queue[0]
		queue = queue[1:]
		count++

		for _, next := range adj[course] {
			inDegree[next]--
			if inDegree[next] == 0 {
				queue = append(queue, next)
			}
		}
	}
	return count == numCourses
}

// ========== Kahn 算法（BFS 拓扑排序） ==========
func topologicalSortKahn(numVertices int, edges [][]int) []int {
	adj := make([][]int, numVertices)
	inDegree := make([]int, numVertices)

	for _, e := range edges {
		adj[e[0]] = append(adj[e[0]], e[1])
		inDegree[e[1]]++
	}

	queue := []int{}
	for i := 0; i < numVertices; i++ {
		if inDegree[i] == 0 {
			queue = append(queue, i)
		}
	}

	result := []int{}
	for len(queue) > 0 {
		u := queue[0]
		queue = queue[1:]
		result = append(result, u)

		for _, v := range adj[u] {
			inDegree[v]--
			if inDegree[v] == 0 {
				queue = append(queue, v)
			}
		}
	}

	if len(result) == numVertices {
		return result
	}
	return nil // 有环！
}

// ========== DFS 实现拓扑排序 ==========
func topologicalSortDfs(numVertices int, edges [][]int) []int {
	adj := make([][]int, numVertices)
	for _, e := range edges {
		adj[e[0]] = append(adj[e[0]], e[1])
	}

	visited := make(map[int]bool)
	result := []int{}

	var dfs func(u int)
	dfs = func(u int) {
		visited[u] = true
		for _, v := range adj[u] {
			if !visited[v] {
				dfs(v)
			}
		}
		result = append(result, u) // 所有邻居处理完才加入
	}

	for i := 0; i < numVertices; i++ {
		if !visited[i] {
			dfs(i)
		}
	}

	// 反转
	for i, j := 0, len(result)-1; i < j; i, j = i+1, j-1 {
		result[i], result[j] = result[j], result[i]
	}
	return result
}

// ========== 检测有向图是否有环（DFS 三色法） ==========
func hasCycleDfs(numVertices int, edges [][]int) bool {
	adj := make([][]int, numVertices)
	for _, e := range edges {
		adj[e[0]] = append(adj[e[0]], e[1])
	}

	visited := make(map[int]bool)   // 彻底处理完的顶点
	recStack := make(map[int]bool)  // 当前递归路径上的顶点

	var dfs func(u int) bool
	dfs = func(u int) bool {
		visited[u] = true
		recStack[u] = true

		for _, v := range adj[u] {
			if !visited[v] {
				if dfs(v) {
					return true
				}
			} else if recStack[v] {
				return true // 遇到递归栈中的顶点 → 有环！
			}
		}
		delete(recStack, u)
		return false
	}

	for i := 0; i < numVertices; i++ {
		if !visited[i] {
			if dfs(i) {
				return true
			}
		}
	}
	return false
}

func testTopology() {
	fmt.Println("===== 课程表 =====")
	fmt.Println(canFinish(4, [][]int{{1, 0}, {2, 0}, {2, 1}, {3, 1}})) // true
	fmt.Println(canFinish(2, [][]int{{1, 0}, {0, 1}}))                 // false

	fmt.Println("\n===== 拓扑排序 =====")
	edges := [][]int{{0, 1}, {0, 2}, {1, 3}, {1, 4}, {2, 4}, {3, 4}}
	fmt.Println("Kahn:", topologicalSortKahn(5, edges)) // [0 1 2 3 4] 等
	fmt.Println("DFS:", topologicalSortDfs(5, edges))
	fmt.Println("Kahn(有环):", topologicalSortKahn(3, [][]int{{0, 1}, {1, 2}, {2, 0}})) // nil
	fmt.Println("环检测(有环):", hasCycleDfs(3, [][]int{{0, 1}, {1, 2}, {2, 0}}))       // true
	fmt.Println("环检测(无环):", hasCycleDfs(4, [][]int{{0, 1}, {1, 2}, {0, 2}}))       // false
}
```

##### 六、连通分量

```go
package main

import "fmt"

// ========== 求无向图的所有连通分量 ==========
// 用 BFS 遍历每个连通分量
func connectedComponents(graph map[int][]int) [][]int {
	visited := make(map[int]bool)
	components := [][]int{}

	for vertex := range graph {
		if !visited[vertex] {
			// 发现一个新的连通分量
			component := []int{}
			queue := []int{vertex}
			visited[vertex] = true

			for len(queue) > 0 {
				v := queue[0]
				queue = queue[1:]
				component = append(component, v)

				for _, neighbor := range graph[v] {
					if !visited[neighbor] {
						visited[neighbor] = true
						queue = append(queue, neighbor)
					}
				}
			}
			components = append(components, component)
		}
	}
	return components
}

func testConnectedComponents() {
	graph := map[int][]int{
		0: {1, 2},
		1: {0, 2},
		2: {0, 1},
		3: {4},
		4: {3},
		5: {},
	}
	components := connectedComponents(graph)
	fmt.Printf("连通分量: %v\n", components) // [[0 1 2] [3 4] [5]]
	fmt.Printf("连通分量数量: %d\n", len(components)) // 3
}
```

---


### 主题17：高级树结构


#### 一、Trie（字典树 / 前缀树）

##### 概念

**Trie**（读作 "try"）是一种专门用于高效存储和检索字符串的树结构。

> 类比：想象一本电话簿
> - 所有姓"张"的人放在一起（张-张伟、张-张敏、张-张强）
> - 所有姓"李"的人放在一起（李-李白、李-李雷）
> - 查找"张"开头的人名特别快，因为不需要翻到后面
>
> Trie 就是这个原理：有共同前缀的字符串共享前面的路径。

##### 结构

```
存储单词: "app", "apple", "bat", "bad"

        root
       /    \
      a      b
      |      |
      p      a
      |     / \
      p    t   d
     / \
   (end) e
         |
        (end)

* (end) 表示这是一个单词的结尾
* 从 root 到任意 (end) 的路径就是一个完整的单词
* 从 root 到任意节点的路径就是一个前缀
```

##### Python 实现

```python
"""
Trie（字典树/前缀树）完整实现

每个节点代表一个字符
从根到某节点的路径表示一个前缀
"""


class TrieNode:
    """
    Trie 的节点
    
    属性:
        children: 字典，存储子节点
                  键是字符，值是子节点
                  例如 children = {'a': TrieNode, 'b': TrieNode}
        is_end:   标记从根到这个节点的路径是否构成一个完整的单词
    """
    def __init__(self):
        self.children = {}  # 用字典存储子节点（也可以用长度为26的数组）
        self.is_end = False  # 是否是单词结尾


class Trie:
    """
    Trie（前缀树）
    
    支持三个操作：
    1. insert(word)    - 插入一个单词
    2. search(word)    - 查找一个单词是否存在
    3. startsWith(prefix) - 查找是否存在以 prefix 开头的单词
    """

    def __init__(self):
        # 初始化时只有一个根节点（空节点，不代表任何字符）
        self.root = TrieNode()

    def insert(self, word):
        """
        插入一个单词到 Trie 中
        
        过程：从根节点开始，逐个字符地往下走
        - 如果字符对应的子节点存在，继续走
        - 如果不存在，创建新节点
        - 最后在单词结尾的节点标记 is_end = True
        """
        node = self.root  # 从根节点开始

        for char in word:
            if char not in node.children:
                # 字符对应的子节点不存在，创建新节点
                node.children[char] = TrieNode()
            # 走到子节点
            node = node.children[char]

        # 单词所有字符都处理完了，标记结尾
        node.is_end = True

    def search(self, word):
        """
        查找一个单词是否存在于 Trie 中
        
        和 insert 类似，逐个字符往下走
        区别：
        - 如果中途某个字符没有对应子节点 → 单词不存在，返回 False
        - 如果走完了所有字符，还要检查 is_end 是否为 True
          （因为 "app" 和 "apple" 都经过 "app" 这个节点，
           但只有 "apple" 的 is_end 才是 True）
        """
        node = self._find_node(word)
        # 不仅找到了这个路径，还要确认它是一个完整的单词
        return node is not None and node.is_end

    def startsWith(self, prefix):
        """
        查找是否存在以 prefix 开头的单词
        
        和 search 类似，但不需要检查 is_end
        只要 prefix 的路径存在就行
        """
        return self._find_node(prefix) is not None

    def _find_node(self, prefix):
        """
        辅助方法：沿着 prefix 的路径走，返回最后到达的节点
        如果路径不存在，返回 None
        """
        node = self.root
        for char in prefix:
            if char not in node.children:
                return None
            node = node.children[char]
        return node


# ===== 测试 =====
print("=" * 40)
print("Trie 基本操作")
print("=" * 40)

trie = Trie()

# 插入单词
trie.insert("app")
trie.insert("apple")
trie.insert("bat")
trie.insert("bad")

# 查找完整单词
print(f"search('app'):   {trie.search('app')}")     # True
print(f"search('apple'): {trie.search('apple')}")    # True
print(f"search('ap'):    {trie.search('ap')}")       # False（不是完整单词）
print(f"search('bat'):   {trie.search('bat')}")      # True
print(f"search('ba'):    {trie.search('ba')}")       # False

# 查找前缀
print(f"\nstartsWith('ap'):  {trie.startsWith('ap')}")   # True
print(f"startsWith('b'):   {trie.startsWith('b')}")    # True
print(f"startsWith('xyz'): {trie.startsWith('xyz')}")  # False
```

##### 复杂度分析

```
设 n 为单词长度（不是 Trie 中单词的总数！）

时间复杂度：
  insert(word):      O(n)  —— 遍历单词的每个字符
  search(word):      O(n)  —— 遍历单词的每个字符
  startsWith(prefix): O(n)  —— 遍历前缀的每个字符

空间复杂度：
  O(所有单词的总字符数) —— 最坏情况每个字符都需要一个新节点
  但有共同前缀的单词共享节点，实际空间远小于这个值

对比：如果用哈希表存储单词
  search: O(n) 计算哈希 + O(n) 比较 = O(n)
  startsWith: 不支持！（哈希表无法高效查前缀）
  
Trie 的优势：
  1. startsWith 操作极快
  2. 前缀共享节省空间（大量单词有共同前缀时）
  3. 可以按字典序枚举所有单词
```

##### 应用场景

```
1. 自动补全（搜索引擎输入框）
   用户输入 "pyt"，Trie 快速找到所有以 "pyt" 开头的词：
   "python", "python教程", "python安装"

2. 拼写检查
   所有正确单词存入 Trie，输入一个词，在 Trie 中查找即可

3. IP 路由（最长前缀匹配）
   网络路由器用 Trie 找到最匹配的 IP 前缀

4. T9 输入法
   老式手机按 2 对应 abc，按 3 对应 def...
   Trie 可以快速找到按键序列对应的所有可能单词
```

##### 经典例题：单词搜索 II（LeetCode 212）简介

```python
"""
单词搜索 II 简介

题目：给定一个 m x n 的字符棋盘和一个单词列表，
找出棋盘中所有存在的单词。单词必须按字母顺序，
通过相邻（水平或垂直）的单元格构成，同一单元格不能重复使用。

思路：Trie + DFS 回溯
1. 把所有单词插入一棵 Trie
2. 从棋盘的每个格子出发，做 DFS
3. DFS 过程中，沿着 Trie 的路径走
4. 如果走到 is_end 节点，说明找到一个单词
5. 如果当前字符不在 Trie 的子节点中，剪枝返回

这比"对每个单词单独做 DFS"快得多，因为：
- 共同前缀只搜索一次
- 不匹配的路径提前剪枝
"""


def findWords(board, words):
    """
    单词搜索 II：Trie + DFS 回溯
    """
    # 第一步：构建 Trie
    root = TrieNode()
    for word in words:
        node = root
        for char in word:
            if char not in node.children:
                node.children[char] = TrieNode()
            node = node.children[char]
        node.is_end = True
        # 额外存储完整单词，方便收集结果
        node.word = word

    result = set()  # 用集合去重
    rows, cols = len(board), len(board[0])

    def dfs(r, c, node):
        """从 (r, c) 出发，在 Trie 上搜索"""
        char = board[r][c]

        # 如果当前字符不在 Trie 子节点中，剪枝
        if char not in node.children:
            return

        next_node = node.children[char]

        # 如果到达单词结尾，收集结果
        if hasattr(next_node, 'word'):
            result.add(next_node.word)

        # 标记当前格子为已访问（防止重复使用）
        board[r][c] = '#'

        # 四个方向 DFS
        for dr, dc in [(1, 0), (-1, 0), (0, 1), (0, -1)]:
            nr, nc = r + dr, c + dc
            if 0 <= nr < rows and 0 <= nc < cols and board[nr][nc] != '#':
                dfs(nr, nc, next_node)

        # 回溯：恢复当前格子
        board[r][c] = char

    # 从棋盘的每个格子出发搜索
    for r in range(rows):
        for c in range(cols):
            dfs(r, c, root)

    return list(result)


# ===== 测试 =====
print("=" * 40)
print("单词搜索 II")
print("=" * 40)

board = [
    ['o', 'a', 'a', 'n'],
    ['e', 't', 'a', 'e'],
    ['i', 'h', 'k', 'r'],
    ['i', 'f', 'l', 'v']
]
words = ["oath", "pea", "eat", "rain"]

print(f"找到的单词: {findWords(board, words)}")
# ['oath', 'eat']  （顺序可能不同）
```

---

#### 二、并查集（Union-Find）

##### 概念

**并查集**是一种用于处理**集合合并与查询**的数据结构。

> 类比：朋友圈合并
> - 一开始，每个人各自是一个"朋友圈"
> - 如果 A 和 B 是朋友，就把 A 和 B 的朋友圈合并
> - 问"A 和 Z 是不是在同一个朋友圈？"→ 查一下它们的"代表人"是不是同一个
>
> 核心操作就两个：
> 1. **find(x)**：找到 x 所在朋友圈的"代表人"（根节点）
> 2. **union(x, y)**：把 x 和 y 所在的朋友圈合并

##### 基础实现

```python
"""
并查集 - 基础实现

用数组 parent 表示：
  parent[i] = i 的"上级"（父节点）
  
如果 parent[i] == i，说明 i 就是这个集合的"代表人"（根节点）

初始状态：每个人都是自己的代表人
  parent = [0, 1, 2, 3, 4]   （5个人，各自为政）

合并 0 和 1 后：
  parent = [1, 1, 2, 3, 4]   （0 的上级变成 1，1 是代表人）
"""


class UnionFind_Basic:
    """并查集基础版本"""

    def __init__(self, n):
        """
        初始化 n 个元素
        初始时每个元素各自独立，parent[i] = i
        """
        self.parent = list(range(n))

    def find(self, x):
        """
        查找 x 的根节点（代表人）
        沿着 parent 链一直往上找，直到 parent[x] == x
        """
        while self.parent[x] != x:
            x = self.parent[x]  # 往上走一步
        return x

    def union(self, x, y):
        """
        合并 x 和 y 所在的集合
        找到各自的根节点，让一个根节点的父指向另一个
        """
        root_x = self.find(x)
        root_y = self.find(y)

        if root_x != root_y:
            # 让 root_x 的上级变成 root_y
            self.parent[root_x] = root_y

    def connected(self, x, y):
        """判断 x 和 y 是否在同一个集合中"""
        return self.find(x) == self.find(y)


# ===== 测试 =====
print("=" * 40)
print("并查集基础版")
print("=" * 40)

uf = UnionFind_Basic(5)
# 初始：{0} {1} {2} {3} {4} 各自独立

uf.union(0, 1)
# {0, 1} {2} {3} {4}
print(f"0 和 1 连通吗? {uf.connected(0, 1)}")  # True

uf.union(2, 3)
# {0, 1} {2, 3} {4}
print(f"2 和 3 连通吗? {uf.connected(2, 3)}")  # True

print(f"0 和 2 连通吗? {uf.connected(0, 2)}")  # False

uf.union(1, 3)
# {0, 1, 2, 3} {4}
print(f"合并后 0 和 2 连通吗? {uf.connected(0, 2)}")  # True
```

##### 优化1：路径压缩

```python
"""
并查集优化1：路径压缩（Path Compression）

问题：如果合并操作形成了一条很长的链
  parent = [1, 2, 3, 4, 4]
  0 -> 1 -> 2 -> 3 -> 4（根）
  每次 find(0) 都要走 4 步，太慢了！

解决：路径压缩
  在 find 的过程中，把沿途所有节点直接挂到根节点下面
  这样下次查找就只需要 1 步

  压缩前: 0 -> 1 -> 2 -> 3 -> 4
  压缩后: 0 -> 4, 1 -> 4, 2 -> 4, 3 -> 4
  （所有节点直接指向根）

类比：
  公司里你要找 CEO，经过了很多层中间领导
  路径压缩就是：你直接记住 CEO 是谁，
  下次不用再一层层找了
"""


class UnionFind_PathCompression:
    """并查集 - 路径压缩优化"""

    def __init__(self, n):
        self.parent = list(range(n))

    def find(self, x):
        """
        查找根节点 + 路径压缩
        
        递归实现：
        先找到根节点，然后把沿途所有节点的 parent 直接指向根
        """
        if self.parent[x] != x:
            # 递归找到根节点，同时把 x 的 parent 直接设为根
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        root_x = self.find(x)
        root_y = self.find(y)
        if root_x != root_y:
            self.parent[root_x] = root_y

    def connected(self, x, y):
        return self.find(x) == self.find(y)


# ===== 测试 =====
print("=" * 40)
print("路径压缩优化")
print("=" * 40)

uf = UnionFind_PathCompression(5)

# 故意制造长链
uf.parent = [1, 2, 3, 4, 4]  # 0->1->2->3->4

print(f"find(0) 之前 parent: {uf.parent}")
root = uf.find(0)
print(f"find(0) = {root}")
print(f"find(0) 之后 parent: {uf.parent}")
# 路径压缩后，0、1、2、3 都直接指向 4
```

##### 优化2：按秩合并

```python
"""
并查集优化2：按秩合并（Union by Rank）

问题：合并时如果随便连，树可能变得很不平衡（一边很深一边很浅）

解决：按秩合并
  给每个根节点一个"秩"（rank），表示树的粗略高度
  合并时，让秩小的树挂在秩大的树下面
  这样树的高度增长更慢

类比：
  两个公司合并，小公司（人少/层级浅）被大公司（人多/层级深）收购
  而不是反过来，这样管理层级不会增加太多
"""


class UnionFind_UnionByRank:
    """并查集 - 按秩合并优化"""

    def __init__(self, n):
        self.parent = list(range(n))
        # rank[i] 表示以 i 为根的树的秩（粗略高度）
        self.rank = [0] * n  # 初始每个节点独立，高度为 0

    def find(self, x):
        """查找根节点（这里暂不加路径压缩）"""
        while self.parent[x] != x:
            x = self.parent[x]
        return x

    def union(self, x, y):
        root_x = self.find(x)
        root_y = self.find(y)

        if root_x == root_y:
            return  # 已经在同一集合中

        # 按秩合并：秩小的挂在秩大的下面
        if self.rank[root_x] < self.rank[root_y]:
            # root_x 的秩更小，挂到 root_y 下面
            self.parent[root_x] = root_y
            # root_y 的秩不变（矮的挂到高的下面，高度不变）
        elif self.rank[root_x] > self.rank[root_y]:
            # root_y 挂到 root_x 下面
            self.parent[root_y] = root_x
        else:
            # 秩相同，随便挂，但被挂的那个秩要 +1
            self.parent[root_x] = root_y
            self.rank[root_y] += 1

    def connected(self, x, y):
        return self.find(x) == self.find(y)
```

##### 两个优化同时使用（最终版本）

```python
"""
并查集最终版：路径压缩 + 按秩合并

两个优化同时使用，效果最好：
- 按秩合并保证树不会太深
- 路径压缩进一步把树压扁

复杂度：
  初始化: O(n)
  find:   近似 O(1)（严格来说是 O(α(n))，α 是反阿克曼函数）
  union:  近似 O(1)
  
  α(n) 是什么？
  - 它是一个增长极其极其缓慢的函数
  - α(10^600) < 5（宇宙中的原子数都没这么多）
  - 在实际应用中，可以认为 find 和 union 都是 O(1)
"""


class UnionFind:
    """并查集最终版：路径压缩 + 按秩合并"""

    def __init__(self, n):
        """初始化 n 个元素，各自独立"""
        self.parent = list(range(n))
        self.rank = [0] * n
        self.count = n  # 连通分量数量（初始 n 个）

    def find(self, x):
        """
        查找根节点 + 路径压缩
        """
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])  # 路径压缩
        return self.parent[x]

    def union(self, x, y):
        """
        合并 x 和 y 的集合 + 按秩合并
        返回 True 表示成功合并，False 表示已在同一集合
        """
        root_x = self.find(x)
        root_y = self.find(y)

        if root_x == root_y:
            return False  # 已经在同一集合

        # 按秩合并
        if self.rank[root_x] < self.rank[root_y]:
            self.parent[root_x] = root_y
        elif self.rank[root_x] > self.rank[root_y]:
            self.parent[root_y] = root_x
        else:
            self.parent[root_x] = root_y
            self.rank[root_y] += 1

        self.count -= 1  # 合并后连通分量数量减 1
        return True

    def connected(self, x, y):
        """判断 x 和 y 是否连通"""
        return self.find(x) == self.find(y)

    def get_count(self):
        """返回连通分量数量"""
        return self.count


# ===== 测试 =====
print("=" * 40)
print("并查集最终版")
print("=" * 40)

uf = UnionFind(6)
# 初始: {0} {1} {2} {3} {4} {5}  6个分量

uf.union(0, 1)  # {0,1} {2} {3} {4} {5}
uf.union(2, 3)  # {0,1} {2,3} {4} {5}
uf.union(4, 5)  # {0,1} {2,3} {4,5}
print(f"连通分量数: {uf.get_count()}")  # 3

uf.union(1, 3)  # {0,1,2,3} {4,5}
print(f"0 和 2 连通吗? {uf.connected(0, 2)}")  # True
print(f"0 和 4 连通吗? {uf.connected(0, 4)}")  # False
print(f"连通分量数: {uf.get_count()}")  # 2

uf.union(0, 4)  # {0,1,2,3,4,5}
print(f"连通分量数: {uf.get_count()}")  # 1
print(f"所有元素都连通了!")
```

##### 经典应用

###### 应用1：判断图的连通性

```python
"""
用并查集判断图的连通性

给定一个无向图，判断任意两点之间是否连通
"""


def is_graph_connected(n, edges):
    """
    判断 n 个顶点的图是否连通
    
    参数:
        n: 顶点数
        edges: 边的列表 [(u, v), ...]
    返回:
        True 如果图连通，否则 False
    """
    uf = UnionFind(n)

    for u, v in edges:
        uf.union(u, v)

    # 如果最终只有 1 个连通分量，图就是连通的
    return uf.get_count() == 1


# ===== 测试 =====
print("=" * 40)
print("图连通性判断")
print("=" * 40)

# 连通图
print(is_graph_connected(4, [(0, 1), (1, 2), (2, 3)]))  # True

# 不连通图
print(is_graph_connected(4, [(0, 1), (2, 3)]))  # False
```

###### 应用2：冗余连接（LeetCode 684）

```python
"""
冗余连接（LeetCode 684）

题目：一棵树（无环连通图）多加了一条边，导致出现了一个环。
找出那条多余的边并删除它，使图恢复为树。

思路：
用并查集逐条加边
- 如果两个顶点已经在同一集合中，再加边就会形成环
- 这条边就是多余的！

类比：
  朋友圈里，A 和 B 已经是朋友了（直接或间接），
  又有人说"A 和 B 是朋友"——这条信息是多余的
"""


def findRedundantConnection(edges):
    """
    找到导致环的那条多余边
    """
    n = len(edges)
    uf = UnionFind(n)

    for u, v in edges:
        # 顶点编号从 1 开始，转为从 0 开始
        if not uf.union(u - 1, v - 1):
            # union 返回 False，说明 u 和 v 已经连通
            # 再加这条边就形成环了！
            return [u, v]

    return []


# ===== 测试 =====
print("=" * 40)
print("冗余连接")
print("=" * 40)

# 图：1-2, 2-3, 3-4, 1-3（最后一条 1-3 是多余的，因为 1 和 3 已经通过 2 连通了）
edges = [[1, 2], [2, 3], [3, 4], [1, 3]]
print(f"冗余边: {findRedundantConnection(edges)}")  # [1, 3]
```

###### 应用3：省份数量（LeetCode 547）

```python
"""
省份数量 / 连通分量数（LeetCode 547）

题目：有 n 个城市，用一个 n x n 的矩阵 isConnected 表示连通关系。
isConnected[i][j] = 1 表示城市 i 和城市 j 直接相连。
求"省份"数量（连通分量数量）。

思路：
用并查集，遍历矩阵，把所有连通的城市合并
最后返回连通分量数量
"""


def findCircleNum(isConnected):
    """
    求省份数量
    """
    n = len(isConnected)
    uf = UnionFind(n)

    # 遍历矩阵的上三角（因为矩阵是对称的）
    for i in range(n):
        for j in range(i + 1, n):
            if isConnected[i][j] == 1:
                uf.union(i, j)

    return uf.get_count()


# ===== 测试 =====
print("=" * 40)
print("省份数量")
print("=" * 40)

# 城市 0,1,2 互通，城市 3,4 互通 → 2 个省份
isConnected = [
    [1, 1, 0, 0, 0],
    [1, 1, 0, 0, 0],
    [0, 0, 1, 0, 0],
    [0, 0, 0, 1, 1],
    [0, 0, 0, 1, 1]
]
print(f"省份数量: {findCircleNum(isConnected)}")  # 2
```

###### 应用4：等式方程的可满足性

```python
"""
等式方程的可满足性（LeetCode 990）

题目：给定一组字符串方程，如 ["a==b", "b!=c", "a==c"]
判断是否存在一种赋值使得所有方程同时成立。

思路：
1. 先处理所有 "==" 方程：把相等的变量合并到同一集合
2. 再检查所有 "!=" 方程：如果不等的两个变量在同一集合，矛盾！

类比：
  "==" 表示两个人在同一组
  "!=" 表示两个人不在同一组
  先用并查集把同组的人合并，再检查是否有矛盾
"""


def equationsPossible(equations):
    """
    判断等式方程是否可满足
    """
    # 26 个小写字母
    uf = UnionFind(26)

    # 第一遍：处理所有 "==" 方程
    for eq in equations:
        if eq[1] == '=':  # "==" 的情况
            x = ord(eq[0]) - ord('a')   # 字母转数字
            y = ord(eq[3]) - ord('a')
            uf.union(x, y)

    # 第二遍：检查所有 "!=" 方程
    for eq in equations:
        if eq[1] == '!':  # "!=" 的情况
            x = ord(eq[0]) - ord('a')
            y = ord(eq[3]) - ord('a')
            # 如果不等的两个变量在同一集合，矛盾！
            if uf.connected(x, y):
                return False

    return True


# ===== 测试 =====
print("=" * 40)
print("等式方程")
print("=" * 40)

print(equationsPossible(["a==b", "b==c", "a==c"]))  # True
print(equationsPossible(["a==b", "b!=a"]))           # False
print(equationsPossible(["a==b", "b!=c", "c==a"]))   # False（a==b, c==a → a,b,c 同组，但 b!=c 矛盾）
print(equationsPossible(["a==b", "b==c", "b!=d"]))   # True
```

---

#### 三、平衡二叉搜索树（概念了解）

##### 为什么需要平衡？

```
普通 BST 的问题：如果插入的数据是有序的，BST 会退化成链表

正常 BST（平衡）：       退化 BST（插入 1,2,3,4,5）：
       3                    1
     /   \                   \
    2     4                   2
   /       \                   \
  1         5                   3
                                   \
查找效率 O(log n)                     4
                                       \
                                        5

                                  查找效率退化为 O(n)！

解决方案：让树"自平衡"——每次插入/删除后，自动调整结构保持平衡
```

##### AVL 树简介

```
AVL 树是最早的自平衡 BST

核心规则：对于每个节点，其左子树和右子树的高度差不超过 1
（这个差值叫做"平衡因子"）

当插入/删除导致某个节点的平衡因子超过 1 时，通过"旋转"来恢复平衡

四种旋转操作：
  1. 右旋（LL 型）：左边太重，向右旋转
     失衡节点 A，左孩子 B
     旋转后 B 变成根，A 变成 B 的右孩子

        A                   B
       / \                 / \
      B   D      →       C    A
     / \                     / \
    C   E                   E   D

  2. 左旋（RR 型）：右边太重，向左旋转（和右旋对称）

  3. 先左旋再右旋（LR 型）：左孩子的右子树太重

  4. 先右旋再左旋（RL 型）：右孩子的左子树太重

特点：严格平衡，查找效率稳定 O(log n)
缺点：插入/删除时旋转次数可能较多
```

##### 红黑树简介

```
红黑树是一种"近似平衡"的 BST，比 AVL 树更常用

核心规则：
  1. 每个节点要么是红色，要么是黑色
  2. 根节点是黑色
  3. 红色节点的两个孩子必须是黑色（不能有连续的红节点）
  4. 从任一节点到其所有叶子节点的路径上，黑色节点数量相同

这些规则保证了：
  - 最长路径不会超过最短路径的 2 倍
  - 虽然不是严格平衡，但足够好了

对比 AVL 树：
  - AVL 树：严格平衡，查找更快，但插入/删除时旋转更多
  - 红黑树：近似平衡，插入/删除更快，综合性能更好

实际应用（你每天都在用！）：
  - Java 的 TreeMap、TreeSet 底层就是红黑树
  - C++ 的 std::map、std::set 底层是红黑树
  - Linux 内核的进程调度也用红黑树
  - Python 的一些内部实现也涉及红黑树的思想
```

##### 自平衡的意义总结

```
                    普通 BST        AVL 树         红黑树
查找（平均）       O(log n)       O(log n)      O(log n)
查找（最坏）       O(n)           O(log n)      O(log n)
插入（平均）       O(log n)       O(log n)      O(log n)
插入（最坏）       O(n)           O(log n)      O(log n)
平衡维护           无             严格           近似
旋转次数           0              可能较多       较少
实际使用           教学为主       数据库索引      标准库容器

关键理解：
  "自平衡"的核心思想是——在每次修改（插入/删除）后，
  花少量额外代价（O(log n) 次旋转）来维持树的平衡，
  从而保证后续所有操作都能保持 O(log n) 的效率。
  这是一种"现在多花一点，以后省很多"的策略。
```


### 主题17 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、Trie（字典树 / 前缀树）

```typescript
// ========== Trie（字典树 / 前缀树） ==========
// 每个节点代表一个字符，从根到某节点的路径表示一个前缀
class TrieNode {
    children: Map<string, TrieNode> = new Map(); // 存储子节点
    isEnd: boolean = false;                      // 是否是单词结尾
}

class Trie {
    private root: TrieNode = new TrieNode();

    // 插入一个单词：从根节点开始，逐个字符往下走
    insert(word: string): void {
        let node = this.root;
        for (const char of word) {
            if (!node.children.has(char)) {
                node.children.set(char, new TrieNode());
            }
            node = node.children.get(char)!;
        }
        node.isEnd = true; // 单词结尾标记
    }

    // 查找完整单词：路径存在且是单词结尾
    search(word: string): boolean {
        const node = this.findNode(word);
        return node !== null && node.isEnd;
    }

    // 查找前缀：只要路径存在即可
    startsWith(prefix: string): boolean {
        return this.findNode(prefix) !== null;
    }

    // 辅助方法：沿着 prefix 走，返回最后到达的节点（不存在返回 null）
    private findNode(prefix: string): TrieNode | null {
        let node = this.root;
        for (const char of prefix) {
            if (!node.children.has(char)) return null;
            node = node.children.get(char)!;
        }
        return node;
    }
}

// 测试
console.log("=".repeat(40));
console.log("Trie 基本操作");
console.log("=".repeat(40));
const trie = new Trie();
trie.insert("app");
trie.insert("apple");
trie.insert("bat");
trie.insert("bad");
console.log(`search('app'):   ${trie.search("app")}`);    // true
console.log(`search('apple'): ${trie.search("apple")}`);   // true
console.log(`search('ap'):    ${trie.search("ap")}`);      // false（不是完整单词）
console.log(`search('bat'):   ${trie.search("bat")}`);     // true
console.log(`search('ba'):    ${trie.search("ba")}`);      // false
console.log(`startsWith('ap'):  ${trie.startsWith("ap")}`); // true
console.log(`startsWith('b'):   ${trie.startsWith("b")}`);  // true
console.log(`startsWith('xyz'): ${trie.startsWith("xyz")}`); // false
```

##### 单词搜索 II（LeetCode 212）

```typescript
// ========== 单词搜索 II：Trie + DFS 回溯 ==========
// 思路：把所有单词插入一棵 Trie，从棋盘的每个格子出发 DFS，
// 沿着 Trie 的路径走，走到 isEnd 节点就收集结果。
function findWords(board: string[][], words: string[]): string[] {
    // 第一步：构建 Trie
    const root = new TrieNode();
    for (const word of words) {
        let node = root;
        for (const char of word) {
            if (!node.children.has(char)) {
                node.children.set(char, new TrieNode());
            }
            node = node.children.get(char)!;
        }
        node.isEnd = true;
        (node as any).word = word; // 额外存完整单词，方便收集结果
    }

    const result = new Set<string>();
    const rows = board.length;
    const cols = board[0].length;
    const dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]];

    const dfs = (r: number, c: number, node: TrieNode): void => {
        const char = board[r][c];
        // 当前字符不在 Trie 子节点中 → 剪枝
        if (!node.children.has(char)) return;

        const nextNode = node.children.get(char)!;
        const word = (nextNode as any).word;
        if (word) result.add(word); // 到达单词结尾，收集结果

        board[r][c] = "#"; // 标记已访问（防止重复使用）
        for (const [dr, dc] of dirs) {
            const nr = r + dr;
            const nc = c + dc;
            if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && board[nr][nc] !== "#") {
                dfs(nr, nc, nextNode);
            }
        }
        board[r][c] = char; // 回溯：恢复当前格子
    };

    // 从棋盘的每个格子出发搜索
    for (let r = 0; r < rows; r++) {
        for (let c = 0; c < cols; c++) {
            dfs(r, c, root);
        }
    }
    return Array.from(result);
}

// 测试
const board17: string[][] = [
    ["o", "a", "a", "n"],
    ["e", "t", "a", "e"],
    ["i", "h", "k", "r"],
    ["i", "f", "l", "v"],
];
console.log(`找到的单词: ${findWords(board17, ["oath", "pea", "eat", "rain"])}`);
// ['oath', 'eat']（顺序可能不同）
```

##### 二、并查集（Union-Find）基础版

```typescript
// ========== 并查集基础版 ==========
// parent[i] = i 的"上级"；如果 parent[i] === i，说明 i 是代表人（根节点）
class UnionFindBasic {
    parent: number[];

    constructor(n: number) {
        this.parent = Array.from({ length: n }, (_, i) => i);
    }

    // 查找 x 的根节点：沿着 parent 链一直往上找
    find(x: number): number {
        while (this.parent[x] !== x) {
            x = this.parent[x];
        }
        return x;
    }

    // 合并 x 和 y 所在的集合
    union(x: number, y: number): void {
        const rootX = this.find(x);
        const rootY = this.find(y);
        if (rootX !== rootY) {
            this.parent[rootX] = rootY;
        }
    }

    // 判断是否在同一集合
    connected(x: number, y: number): boolean {
        return this.find(x) === this.find(y);
    }
}

// 测试
const ufBasic = new UnionFindBasic(5);
ufBasic.union(0, 1); // {0,1} {2} {3} {4}
ufBasic.union(2, 3); // {0,1} {2,3} {4}
console.log(`0 和 1 连通吗? ${ufBasic.connected(0, 1)}`); // true
console.log(`2 和 3 连通吗? ${ufBasic.connected(2, 3)}`); // true
console.log(`0 和 2 连通吗? ${ufBasic.connected(0, 2)}`); // false
ufBasic.union(1, 3); // {0,1,2,3} {4}
console.log(`合并后 0 和 2 连通吗? ${ufBasic.connected(0, 2)}`); // true
```

##### 并查集最终版（路径压缩 + 按秩合并）

```typescript
// ========== 并查集最终版：路径压缩 + 按秩合并 ==========
// 两个优化同时使用：find 近似 O(1)
class UnionFind {
    parent: number[];
    rank: number[]; // 秩（粗略高度）
    count: number;  // 连通分量数量

    constructor(n: number) {
        this.parent = Array.from({ length: n }, (_, i) => i);
        this.rank = new Array<number>(n).fill(0);
        this.count = n;
    }

    // 查找根节点 + 路径压缩（沿途节点直接指向根）
    find(x: number): number {
        if (this.parent[x] !== x) {
            this.parent[x] = this.find(this.parent[x]);
        }
        return this.parent[x];
    }

    // 合并 + 按秩合并；返回是否真正合并成功
    union(x: number, y: number): boolean {
        const rootX = this.find(x);
        const rootY = this.find(y);

        if (rootX === rootY) return false; // 已在同一集合

        // 秩小的挂在秩大的下面
        if (this.rank[rootX] < this.rank[rootY]) {
            this.parent[rootX] = rootY;
        } else if (this.rank[rootX] > this.rank[rootY]) {
            this.parent[rootY] = rootX;
        } else {
            this.parent[rootX] = rootY;
            this.rank[rootY]++;
        }
        this.count--; // 合并后连通分量数减 1
        return true;
    }

    connected(x: number, y: number): boolean {
        return this.find(x) === this.find(y);
    }

    getCount(): number {
        return this.count;
    }
}

// 测试
const uf = new UnionFind(6);
uf.union(0, 1); // {0,1} {2} {3} {4} {5}
uf.union(2, 3); // {0,1} {2,3} {4} {5}
uf.union(4, 5); // {0,1} {2,3} {4,5}
console.log(`连通分量数: ${uf.getCount()}`); // 3
uf.union(1, 3); // {0,1,2,3} {4,5}
console.log(`0 和 2 连通吗? ${uf.connected(0, 2)}`); // true
console.log(`0 和 4 连通吗? ${uf.connected(0, 4)}`); // false
console.log(`连通分量数: ${uf.getCount()}`); // 2
uf.union(0, 4); // {0,1,2,3,4,5}
console.log(`连通分量数: ${uf.getCount()}`); // 1
```

##### 经典应用

###### 应用1：判断图的连通性

```typescript
// ========== 用并查集判断图的连通性 ==========
function isGraphConnected(n: number, edges: Array<[number, number]>): boolean {
    const uf = new UnionFind(n);
    for (const [u, v] of edges) {
        uf.union(u, v);
    }
    // 如果最终只有 1 个连通分量，图就是连通的
    return uf.getCount() === 1;
}

console.log(`连通图: ${isGraphConnected(4, [[0, 1], [1, 2], [2, 3]])}`);   // true
console.log(`不连通图: ${isGraphConnected(4, [[0, 1], [2, 3]])}`);        // false
```

###### 应用2~4：冗余连接 / 省份数量 / 等式方程

```typescript
// ========== 冗余连接（LeetCode 684） ==========
// 逐条加边，如果两个顶点已在同一集合，这条边就是多余的（会成环）
function findRedundantConnection(edges: number[][]): number[] {
    const uf = new UnionFind(edges.length);
    for (const [u, v] of edges) {
        // 顶点编号从 1 开始，转为从 0 开始
        if (!uf.union(u - 1, v - 1)) return [u, v];
    }
    return [];
}

// ========== 省份数量（LeetCode 547） ==========
// 遍历矩阵上三角，把所有连通的城市合并，返回连通分量数量
function findCircleNum(isConnected: number[][]): number {
    const n = isConnected.length;
    const uf = new UnionFind(n);
    for (let i = 0; i < n; i++) {
        for (let j = i + 1; j < n; j++) {
            if (isConnected[i][j] === 1) uf.union(i, j);
        }
    }
    return uf.getCount();
}

// ========== 等式方程的可满足性（LeetCode 990） ==========
// 第一遍合并所有 "=="，第二遍检查 "!=" 是否有矛盾
function equationsPossible(equations: string[]): boolean {
    const uf = new UnionFind(26); // 26 个小写字母
    for (const eq of equations) {
        if (eq[1] === "=") {
            const x = eq.charCodeAt(0) - 97;
            const y = eq.charCodeAt(3) - 97;
            uf.union(x, y);
        }
    }
    for (const eq of equations) {
        if (eq[1] === "!") {
            const x = eq.charCodeAt(0) - 97;
            const y = eq.charCodeAt(3) - 97;
            if (uf.connected(x, y)) return false; // 矛盾！
        }
    }
    return true;
}

// 测试
console.log(`冗余边: ${JSON.stringify(findRedundantConnection([[1, 2], [2, 3], [3, 4], [1, 3]]))}`); // [1,3]
const isConnected17 = [
    [1, 1, 0, 0, 0],
    [1, 1, 0, 0, 0],
    [0, 0, 1, 0, 0],
    [0, 0, 0, 1, 1],
    [0, 0, 0, 1, 1],
];
console.log(`省份数量: ${findCircleNum(isConnected17)}`); // 2
console.log(equationsPossible(["a==b", "b==c", "a==c"])); // true
console.log(equationsPossible(["a==b", "b!=a"]));          // false
console.log(equationsPossible(["a==b", "b!=c", "c==a"]));  // false
console.log(equationsPossible(["a==b", "b==c", "b!=d"]));  // true
```

##### 三、平衡二叉搜索树（AVL 树插入演示）

```typescript
// ========== AVL 树：插入后自动保持平衡 ==========
// 核心思想：每次插入后检查平衡因子（左高 - 右高），
// 失衡时通过旋转恢复平衡（LL/RR/LR/RL 四种情况）。
class AVLNode {
    val: number;
    left: AVLNode | null = null;
    right: AVLNode | null = null;
    height: number = 1; // 节点高度（叶子为 1）
    constructor(val: number) { this.val = val; }
}

class AVLTree {
    root: AVLNode | null = null;

    private height(node: AVLNode | null): number {
        return node ? node.height : 0;
    }
    private balanceFactor(node: AVLNode | null): number {
        return node ? this.height(node.left) - this.height(node.right) : 0;
    }
    private updateHeight(node: AVLNode): void {
        node.height = Math.max(this.height(node.left), this.height(node.right)) + 1;
    }

    // 右旋（LL 型）
    private rotateRight(y: AVLNode): AVLNode {
        const x = y.left!;
        y.left = x.right;
        x.right = y;
        this.updateHeight(y);
        this.updateHeight(x);
        return x;
    }

    // 左旋（RR 型）
    private rotateLeft(x: AVLNode): AVLNode {
        const y = x.right!;
        x.right = y.left;
        y.left = x;
        this.updateHeight(x);
        this.updateHeight(y);
        return y;
    }

    insert(val: number): void {
        this.root = this.insertNode(this.root, val);
    }

    private insertNode(node: AVLNode | null, val: number): AVLNode {
        if (node === null) return new AVLNode(val);

        if (val < node.val) {
            node.left = this.insertNode(node.left, val);
        } else if (val > node.val) {
            node.right = this.insertNode(node.right, val);
        } else {
            return node; // 重复值不插入
        }

        this.updateHeight(node);
        const bf = this.balanceFactor(node);

        // LL 型：左左太重 → 右旋
        if (bf > 1 && val < node.left!.val) return this.rotateRight(node);
        // RR 型：右右太重 → 左旋
        if (bf < -1 && val > node.right!.val) return this.rotateLeft(node);
        // LR 型：左右 → 先左旋再右旋
        if (bf > 1 && val > node.left!.val) {
            node.left = this.rotateLeft(node.left!);
            return this.rotateRight(node);
        }
        // RL 型：右左 → 先右旋再左旋
        if (bf < -1 && val < node.right!.val) {
            node.right = this.rotateRight(node.right!);
            return this.rotateLeft(node);
        }
        return node;
    }

    // 中序遍历（结果一定有序）
    inorder(): number[] {
        const res: number[] = [];
        const dfs = (n: AVLNode | null): void => {
            if (n === null) return;
            dfs(n.left);
            res.push(n.val);
            dfs(n.right);
        };
        dfs(this.root);
        return res;
    }
}

// 测试：依次插入有序序列，AVL 树不会退化成链表
const avl = new AVLTree();
for (const v of [1, 2, 3, 4, 5]) avl.insert(v);
console.log(`AVL 中序遍历: ${avl.inorder()}`); // [1,2,3,4,5]（有序）
console.log(`AVL 根节点: ${avl.root!.val}`);    // 2（保持了平衡，而不是 5 个节点的链表）
```


### 主题17 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、Trie（字典树 / 前缀树）

```go
package main

import "fmt"

// ========== Trie（字典树 / 前缀树） ==========
// 每个节点代表一个字符，从根到某节点的路径表示一个前缀
type TrieNode struct {
	children map[byte]*TrieNode // 存储子节点（键是字符）
	isEnd    bool               // 是否是单词结尾
	word     string             // 额外存完整单词（单词搜索 II 用）
}

func NewTrieNode() *TrieNode {
	return &TrieNode{children: make(map[byte]*TrieNode)}
}

type Trie struct {
	root *TrieNode
}

func NewTrie() *Trie {
	return &Trie{root: NewTrieNode()}
}

// 插入一个单词：从根节点开始，逐个字符往下走
func (t *Trie) insert(word string) {
	node := t.root
	for i := 0; i < len(word); i++ {
		c := word[i]
		if node.children[c] == nil {
			node.children[c] = NewTrieNode()
		}
		node = node.children[c]
	}
	node.isEnd = true // 单词结尾标记
}

// 查找完整单词：路径存在且是单词结尾
func (t *Trie) search(word string) bool {
	node := t.findNode(word)
	return node != nil && node.isEnd
}

// 查找前缀：只要路径存在即可
func (t *Trie) startsWith(prefix string) bool {
	return t.findNode(prefix) != nil
}

// 辅助方法：沿着 prefix 走，返回最后到达的节点（不存在返回 nil）
func (t *Trie) findNode(prefix string) *TrieNode {
	node := t.root
	for i := 0; i < len(prefix); i++ {
		c := prefix[i]
		if node.children[c] == nil {
			return nil
		}
		node = node.children[c]
	}
	return node
}

func testTrie() {
	fmt.Println("===== Trie 基本操作 =====")
	trie := NewTrie()
	trie.insert("app")
	trie.insert("apple")
	trie.insert("bat")
	trie.insert("bad")
	fmt.Printf("search('app'):   %v\n", trie.search("app"))   // true
	fmt.Printf("search('apple'): %v\n", trie.search("apple")) // true
	fmt.Printf("search('ap'):    %v\n", trie.search("ap"))    // false（不是完整单词）
	fmt.Printf("search('bat'):   %v\n", trie.search("bat"))   // true
	fmt.Printf("search('ba'):    %v\n", trie.search("ba"))    // false
	fmt.Printf("startsWith('ap'):  %v\n", trie.startsWith("ap"))  // true
	fmt.Printf("startsWith('b'):   %v\n", trie.startsWith("b"))   // true
	fmt.Printf("startsWith('xyz'): %v\n", trie.startsWith("xyz")) // false
}
```

##### 单词搜索 II（LeetCode 212）

```go
package main

import "fmt"

// ========== 单词搜索 II：Trie + DFS 回溯 ==========
// 思路：把所有单词插入一棵 Trie，从棋盘的每个格子出发 DFS，
// 沿着 Trie 的路径走，走到 isEnd 节点就收集结果。
func findWords(board [][]byte, words []string) []string {
	// 第一步：构建 Trie
	root := NewTrieNode()
	for _, word := range words {
		node := root
		for i := 0; i < len(word); i++ {
			c := word[i]
			if node.children[c] == nil {
				node.children[c] = NewTrieNode()
			}
			node = node.children[c]
		}
		node.isEnd = true
		node.word = word // 额外存完整单词，方便收集结果
	}

	result := []string{}
	found := map[string]bool{}
	rows, cols := len(board), len(board[0])
	dirs := [][2]int{{1, 0}, {-1, 0}, {0, 1}, {0, -1}}

	var dfs func(r, c int, node *TrieNode)
	dfs = func(r, c int, node *TrieNode) {
		char := board[r][c]
		// 当前字符不在 Trie 子节点中 → 剪枝
		if node.children[char] == nil {
			return
		}
		nextNode := node.children[char]
		// 到达单词结尾，收集结果
		if nextNode.isEnd && !found[nextNode.word] {
			found[nextNode.word] = true
			result = append(result, nextNode.word)
		}

		board[r][c] = '#' // 标记已访问（防止重复使用）
		for _, d := range dirs {
			nr, nc := r+d[0], c+d[1]
			if nr >= 0 && nr < rows && nc >= 0 && nc < cols && board[nr][nc] != '#' {
				dfs(nr, nc, nextNode)
			}
		}
		board[r][c] = char // 回溯：恢复当前格子
	}

	// 从棋盘的每个格子出发搜索
	for r := 0; r < rows; r++ {
		for c := 0; c < cols; c++ {
			dfs(r, c, root)
		}
	}
	return result
}

func testFindWords() {
	fmt.Println("===== 单词搜索 II =====")
	board := [][]byte{
		{'o', 'a', 'a', 'n'},
		{'e', 't', 'a', 'e'},
		{'i', 'h', 'k', 'r'},
		{'i', 'f', 'l', 'v'},
	}
	fmt.Printf("找到的单词: %v\n", findWords(board, []string{"oath", "pea", "eat", "rain"}))
	// [oath eat]（顺序可能不同）
}
```

##### 二、并查集（Union-Find）基础版

```go
package main

import "fmt"

// ========== 并查集基础版 ==========
// parent[i] = i 的"上级"；如果 parent[i] == i，说明 i 是代表人（根节点）
type UnionFindBasic struct {
	parent []int
}

func NewUnionFindBasic(n int) *UnionFindBasic {
	parent := make([]int, n)
	for i := range parent {
		parent[i] = i
	}
	return &UnionFindBasic{parent: parent}
}

// 查找 x 的根节点：沿着 parent 链一直往上找
func (uf *UnionFindBasic) find(x int) int {
	for uf.parent[x] != x {
		x = uf.parent[x]
	}
	return x
}

// 合并 x 和 y 所在的集合
func (uf *UnionFindBasic) union(x, y int) {
	rootX, rootY := uf.find(x), uf.find(y)
	if rootX != rootY {
		uf.parent[rootX] = rootY
	}
}

// 判断是否在同一集合
func (uf *UnionFindBasic) connected(x, y int) bool {
	return uf.find(x) == uf.find(y)
}

func testUnionFindBasic() {
	fmt.Println("===== 并查集基础版 =====")
	uf := NewUnionFindBasic(5)
	uf.union(0, 1) // {0,1} {2} {3} {4}
	uf.union(2, 3) // {0,1} {2,3} {4}
	fmt.Printf("0 和 1 连通吗? %v\n", uf.connected(0, 1)) // true
	fmt.Printf("2 和 3 连通吗? %v\n", uf.connected(2, 3)) // true
	fmt.Printf("0 和 2 连通吗? %v\n", uf.connected(0, 2)) // false
	uf.union(1, 3)                                        // {0,1,2,3} {4}
	fmt.Printf("合并后 0 和 2 连通吗? %v\n", uf.connected(0, 2)) // true
}
```

##### 并查集最终版（路径压缩 + 按秩合并）

```go
package main

import "fmt"

// ========== 并查集最终版：路径压缩 + 按秩合并 ==========
// 两个优化同时使用：find 近似 O(1)
type UnionFind struct {
	parent []int
	rank   []int // 秩（粗略高度）
	count  int   // 连通分量数量
}

func NewUnionFind(n int) *UnionFind {
	parent := make([]int, n)
	rank := make([]int, n)
	for i := range parent {
		parent[i] = i
	}
	return &UnionFind{parent: parent, rank: rank, count: n}
}

// 查找根节点 + 路径压缩（沿途节点直接指向根）
func (uf *UnionFind) find(x int) int {
	if uf.parent[x] != x {
		uf.parent[x] = uf.find(uf.parent[x])
	}
	return uf.parent[x]
}

// 合并 + 按秩合并；返回是否真正合并成功
func (uf *UnionFind) union(x, y int) bool {
	rootX, rootY := uf.find(x), uf.find(y)
	if rootX == rootY {
		return false // 已在同一集合
	}

	// 秩小的挂在秩大的下面
	if uf.rank[rootX] < uf.rank[rootY] {
		uf.parent[rootX] = rootY
	} else if uf.rank[rootX] > uf.rank[rootY] {
		uf.parent[rootY] = rootX
	} else {
		uf.parent[rootX] = rootY
		uf.rank[rootY]++
	}
	uf.count-- // 合并后连通分量数减 1
	return true
}

func (uf *UnionFind) connected(x, y int) bool {
	return uf.find(x) == uf.find(y)
}

func (uf *UnionFind) getCount() int {
	return uf.count
}

func testUnionFindFinal() {
	fmt.Println("===== 并查集最终版 =====")
	uf := NewUnionFind(6)
	uf.union(0, 1) // {0,1} {2} {3} {4} {5}
	uf.union(2, 3) // {0,1} {2,3} {4} {5}
	uf.union(4, 5) // {0,1} {2,3} {4,5}
	fmt.Printf("连通分量数: %d\n", uf.getCount()) // 3
	uf.union(1, 3)                               // {0,1,2,3} {4,5}
	fmt.Printf("0 和 2 连通吗? %v\n", uf.connected(0, 2)) // true
	fmt.Printf("0 和 4 连通吗? %v\n", uf.connected(0, 4)) // false
	fmt.Printf("连通分量数: %d\n", uf.getCount()) // 2
	uf.union(0, 4)                               // {0,1,2,3,4,5}
	fmt.Printf("连通分量数: %d\n", uf.getCount()) // 1
}
```

##### 经典应用

###### 应用1：判断图的连通性

```go
package main

import "fmt"

// ========== 用并查集判断图的连通性 ==========
func isGraphConnected(n int, edges [][2]int) bool {
	uf := NewUnionFind(n)
	for _, e := range edges {
		uf.union(e[0], e[1])
	}
	// 如果最终只有 1 个连通分量，图就是连通的
	return uf.getCount() == 1
}

func testGraphConnected() {
	fmt.Println("===== 图连通性判断 =====")
	fmt.Printf("连通图: %v\n", isGraphConnected(4, [][2]int{{0, 1}, {1, 2}, {2, 3}})) // true
	fmt.Printf("不连通图: %v\n", isGraphConnected(4, [][2]int{{0, 1}, {2, 3}}))      // false
}
```

###### 应用2~4：冗余连接 / 省份数量 / 等式方程

```go
package main

import "fmt"

// ========== 冗余连接（LeetCode 684） ==========
// 逐条加边，如果两个顶点已在同一集合，这条边就是多余的（会成环）
func findRedundantConnection(edges [][]int) []int {
	uf := NewUnionFind(len(edges))
	for _, e := range edges {
		// 顶点编号从 1 开始，转为从 0 开始
		if !uf.union(e[0]-1, e[1]-1) {
			return e
		}
	}
	return []int{}
}

// ========== 省份数量（LeetCode 547） ==========
// 遍历矩阵上三角，把所有连通的城市合并，返回连通分量数量
func findCircleNum(isConnected [][]int) int {
	n := len(isConnected)
	uf := NewUnionFind(n)
	for i := 0; i < n; i++ {
		for j := i + 1; j < n; j++ {
			if isConnected[i][j] == 1 {
				uf.union(i, j)
			}
		}
	}
	return uf.getCount()
}

// ========== 等式方程的可满足性（LeetCode 990） ==========
// 第一遍合并所有 "=="，第二遍检查 "!=" 是否有矛盾
func equationsPossible(equations []string) bool {
	uf := NewUnionFind(26) // 26 个小写字母
	for _, eq := range equations {
		if eq[1] == '=' { // "==" 的情况
			uf.union(int(eq[0]-'a'), int(eq[3]-'a'))
		}
	}
	for _, eq := range equations {
		if eq[1] == '!' { // "!=" 的情况
			if uf.connected(int(eq[0]-'a'), int(eq[3]-'a')) {
				return false // 矛盾！
			}
		}
	}
	return true
}

func testApplications() {
	fmt.Println("===== 冗余连接 =====")
	fmt.Printf("冗余边: %v\n", findRedundantConnection([][]int{{1, 2}, {2, 3}, {3, 4}, {1, 3}})) // [1 3]

	fmt.Println("===== 省份数量 =====")
	isConnected := [][]int{
		{1, 1, 0, 0, 0},
		{1, 1, 0, 0, 0},
		{0, 0, 1, 0, 0},
		{0, 0, 0, 1, 1},
		{0, 0, 0, 1, 1},
	}
	fmt.Printf("省份数量: %d\n", findCircleNum(isConnected)) // 2

	fmt.Println("===== 等式方程 =====")
	fmt.Println(equationsPossible([]string{"a==b", "b==c", "a==c"})) // true
	fmt.Println(equationsPossible([]string{"a==b", "b!=a"}))         // false
	fmt.Println(equationsPossible([]string{"a==b", "b!=c", "c==a"})) // false
	fmt.Println(equationsPossible([]string{"a==b", "b==c", "b!=d"})) // true
}
```

##### 三、平衡二叉搜索树（AVL 树插入演示）

```go
package main

import "fmt"

// ========== AVL 树：插入后自动保持平衡 ==========
// 核心思想：每次插入后检查平衡因子（左高 - 右高），
// 失衡时通过旋转恢复平衡（LL/RR/LR/RL 四种情况）。
type AVLNode struct {
	val         int
	left, right *AVLNode
	height      int // 节点高度（叶子为 1）
}

func NewAVLNode(val int) *AVLNode {
	return &AVLNode{val: val, height: 1}
}

type AVLTree struct {
	root *AVLNode
}

func height(n *AVLNode) int {
	if n == nil {
		return 0
	}
	return n.height
}

func balanceFactor(n *AVLNode) int {
	if n == nil {
		return 0
	}
	return height(n.left) - height(n.right)
}

func updateHeight(n *AVLNode) {
	if height(n.left) > height(n.right) {
		n.height = height(n.left) + 1
	} else {
		n.height = height(n.right) + 1
	}
}

// 右旋（LL 型）
func rotateRight(y *AVLNode) *AVLNode {
	x := y.left
	y.left = x.right
	x.right = y
	updateHeight(y)
	updateHeight(x)
	return x
}

// 左旋（RR 型）
func rotateLeft(x *AVLNode) *AVLNode {
	y := x.right
	x.right = y.left
	y.left = x
	updateHeight(x)
	updateHeight(y)
	return y
}

func (t *AVLTree) insert(val int) {
	t.root = insertNode(t.root, val)
}

func insertNode(node *AVLNode, val int) *AVLNode {
	if node == nil {
		return NewAVLNode(val)
	}
	if val < node.val {
		node.left = insertNode(node.left, val)
	} else if val > node.val {
		node.right = insertNode(node.right, val)
	} else {
		return node // 重复值不插入
	}

	updateHeight(node)
	bf := balanceFactor(node)

	// LL 型：左左太重 → 右旋
	if bf > 1 && val < node.left.val {
		return rotateRight(node)
	}
	// RR 型：右右太重 → 左旋
	if bf < -1 && val > node.right.val {
		return rotateLeft(node)
	}
	// LR 型：左右 → 先左旋再右旋
	if bf > 1 && val > node.left.val {
		node.left = rotateLeft(node.left)
		return rotateRight(node)
	}
	// RL 型：右左 → 先右旋再左旋
	if bf < -1 && val < node.right.val {
		node.right = rotateRight(node.right)
		return rotateLeft(node)
	}
	return node
}

// 中序遍历（结果一定有序）
func (t *AVLTree) inorder() []int {
	res := []int{}
	var dfs func(n *AVLNode)
	dfs = func(n *AVLNode) {
		if n == nil {
			return
		}
		dfs(n.left)
		res = append(res, n.val)
		dfs(n.right)
	}
	dfs(t.root)
	return res
}

func testAVL() {
	fmt.Println("===== AVL 树 =====")
	avl := &AVLTree{}
	// 依次插入有序序列，AVL 树不会退化成链表
	for _, v := range []int{1, 2, 3, 4, 5} {
		avl.insert(v)
	}
	fmt.Printf("AVL 中序遍历: %v\n", avl.inorder()) // [1 2 3 4 5]（有序）
	fmt.Printf("AVL 根节点: %d\n", avl.root.val)   // 2（保持了平衡，而不是 5 个节点的链表）
}
```


## 第七阶段：高级算法

### 主题18：动态规划（Dynamic Programming）


#### 一、DP的核心思想

##### 什么是动态规划？

> **一句话总结：记住过去的经验，避免重复劳动。**

想象你是一个爬楼梯的人，每爬一级都要记录"到这一级有几种走法"。当你爬到第5级时，你不需要重新数前面所有的路——你只需要知道"到第3级有几种"和"到第4级有几种"，加起来就是答案。

**生活中的类比：**

- **存钱罐**：你每天往存钱罐里放钱，想知道总共存了多少。你不需要每天重新数所有硬币，只需要在昨天的总额上加今天的。
- **导航软件**：从家到公司有多条路，导航会把"从家到每个路口"的最短距离算好存起来，避免每次都从头算。
- **背单词**：你已经记住了100个单词，今天新学10个，总共110个。你不需要把之前100个重新数一遍。

**DP的本质**：把一个大问题拆成小问题，把小问题的答案**存起来**，后面用到的时候直接查表，不再重复计算。

---

#### 二、从递归到DP：斐波那契数列的三种实现

斐波那契数列：`F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2)`

##### 方法1：朴素递归（大量重复计算）

```python
def fib_recursive(n):
    """
    朴素递归实现斐波那契
    问题：大量重复计算，时间复杂度O(2^n)，指数级爆炸！
    
    比如算F(5)：
    F(5) = F(4) + F(3)
    F(4) = F(3) + F(2)    ← 这里的F(3)和上面的F(3)是同一个子问题
    F(3) = F(2) + F(1)    ← 又被算了一遍
    ...
    就像你问5个人"你上面有几个人"，每个人都从头数一遍
    """
    if n <= 1:
        return n
    return fib_recursive(n - 1) + fib_recursive(n - 2)

# 测试
print(fib_recursive(10))  # 输出: 55
# print(fib_recursive(50))  # 太慢了，等不到结果！
```

##### 方法2：记忆化搜索（自顶向下）

```python
def fib_memo(n, memo=None):
    """
    记忆化搜索 = 递归 + 备忘录
    思路：算过的就存起来，下次直接查表
    
    类比：做数学题时，把中间结果写在草稿纸上，
    后面再用到时直接看草稿纸，不用重新算
    
    时间复杂度：O(n)，空间复杂度：O(n)
    """
    if memo is None:
        memo = {}  # 备忘录：字典，key是n，value是F(n)
    
    # 先查备忘录，算过就直接返回
    if n in memo:
        return memo[n]
    
    # base case
    if n <= 1:
        return n
    
    # 没算过？算一下，存到备忘录里
    memo[n] = fib_memo(n - 1, memo) + fib_memo(n - 2, memo)
    return memo[n]

# 测试
print(fib_memo(10))   # 输出: 55
print(fib_memo(100))  # 秒出结果！输出: 354224848179261915075
```

##### 方法3：DP表格（自底向上）

```python
def fib_dp(n):
    """
    DP表格法 = 自底向上递推
    思路：从最小的问题开始算，一步步往上推，答案自然就有了
    
    类比：盖楼，从第1层开始盖，盖到第n层
    而不是从第n层往下想"我需要第n-1层"
    
    时间复杂度：O(n)，空间复杂度：O(n)
    """
    if n <= 1:
        return n
    
    # dp[i] 表示 F(i) 的值
    dp = [0] * (n + 1)
    dp[0] = 0  # base case
    dp[1] = 1  # base case
    
    # 从下往上推：每个位置只依赖前两个位置
    for i in range(2, n + 1):
        dp[i] = dp[i - 1] + dp[i - 2]  # 状态转移方程
    
    return dp[n]

# 测试
print(fib_dp(10))   # 输出: 55
print(fib_dp(100))  # 秒出结果！
```

##### 三种方法对比

| 方法 | 时间复杂度 | 空间复杂度 | 特点 |
|------|-----------|-----------|------|
| 朴素递归 | O(2^n) | O(n) | 大量重复计算，指数级慢 |
| 记忆化搜索 | O(n) | O(n) | 自顶向下，递归+备忘录 |
| DP表格 | O(n) | O(n) | 自底向上，迭代+表格 |

> **关键区别**：记忆化是"我要算F(n)，先看看F(n-1)和F(n-2)算过没"（自上而下）；DP表格是"我先把F(0)、F(1)算好，然后一步步推到F(n)"（自下而上）。

---

#### 三、DP的核心要素

##### 1. 状态定义

**问自己：用什么变量来表示一个子问题？**

比如：
- 爬楼梯：`dp[i]` = 到第i级台阶的方法数
- 背包问题：`dp[i][w]` = 前i个物品、容量为w时的最大价值
- 最长递增子序列：`dp[i]` = 以第i个元素结尾的LIS长度

##### 2. 状态转移方程

**问自己：当前状态怎么从之前的状态推导出来？**

比如：
- 爬楼梯：`dp[i] = dp[i-1] + dp[i-2]`（从第i-1级跨1步，或从第i-2级跨2步）
- 背包问题：`dp[i][w] = max(dp[i-1][w], dp[i-1][w-weight[i]] + value[i])`

##### 3. 初始条件（Base Case）

**问自己：最小的子问题答案是什么？**

比如：
- 爬楼梯：`dp[1]=1, dp[2]=2`
- 斐波那契：`dp[0]=0, dp[1]=1`

---

#### 四、自顶向下 vs 自底向上

| 对比项 | 自顶向下（记忆化搜索） | 自底向上（递推） |
|--------|----------------------|-----------------|
| 思路 | 从大问题出发，递归拆成小问题 | 从最小问题开始，逐步推出大问题 |
| 实现 | 递归 + 备忘录（字典/数组） | 循环 + DP数组 |
| 计算范围 | 只计算需要的子问题 | 计算所有子问题（包括可能不需要的） |
| 空间 | 有递归调用栈开销 | 没有递归栈开销 |
| 适用场景 | 子问题空间稀疏时更优 | 通常更简单，实践中更常用 |

---

#### 五、DP解题的一般步骤

```
第1步：定义状态
  → dp[i] 或 dp[i][j] 代表什么？

第2步：写出状态转移方程
  → dp[i] = f(dp[i-1], dp[i-2], ...)

第3步：确定初始条件
  → dp[0] = ? dp[1] = ?

第4步：确定计算顺序
  → 从前往后？从后往前？按什么顺序保证计算dp[i]时，它依赖的值都已算好？

第5步：返回答案
  → 通常是 dp[n] 或 max(dp) 等
```

---

#### 六、入门级DP题目

##### 6.1 爬楼梯（LeetCode 70）

**题目**：每次可以爬1级或2级台阶，问爬到第n级有多少种方法？

**分析**：
- 状态定义：`dp[i]` = 到第i级台阶的方法数
- 状态转移：到第i级，要么从第i-1级跨1步上来，要么从第i-2级跨2步上来
  - `dp[i] = dp[i-1] + dp[i-2]`
- 初始条件：`dp[1]=1, dp[2]=2`

```python
def climbStairs(n: int) -> int:
    """
    爬楼梯问题
    
    类比：你站在地上（第0级），要爬到第n级。
    每次只能跨1级或2级。问有多少种不同的爬法。
    
    关键洞察：到第n级的方法 = 到第n-1级的方法 + 到第n-2级的方法
    因为最后一步要么跨1级（从n-1到n），要么跨2级（从n-2到n）
    """
    if n <= 2:
        return n
    
    # 方法1：标准DP
    dp = [0] * (n + 1)
    dp[1] = 1  # 到第1级只有1种方法
    dp[2] = 2  # 到第2级有2种方法：1+1 或 直接2
    
    for i in range(3, n + 1):
        dp[i] = dp[i - 1] + dp[i - 2]  # 状态转移方程
    
    return dp[n]

    # 方法2：空间优化（只需要前两个值）
    # prev2, prev1 = 1, 2  # dp[1], dp[2]
    # for _ in range(3, n + 1):
    #     curr = prev1 + prev2
    #     prev2 = prev1
    #     prev1 = curr
    # return prev1

# 测试
print(climbStairs(3))   # 输出: 3 (1+1+1, 1+2, 2+1)
print(climbStairs(5))   # 输出: 8
```

##### 6.2 斐波那契数列（LeetCode 509）

```python
def fib(n: int) -> int:
    """
    斐波那契数列
    F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2)
    
    这就是DP的"Hello World"
    """
    if n <= 1:
        return n
    
    # 只需要保存前两个状态（空间优化）
    prev2 = 0  # F(0)
    prev1 = 1  # F(1)
    
    for i in range(2, n + 1):
        curr = prev1 + prev2  # F(i) = F(i-1) + F(i-2)
        prev2 = prev1         # 更新：prev2变成F(i-1)
        prev1 = curr          # 更新：prev1变成F(i)
    
    return prev1

# 测试
for i in range(10):
    print(f"F({i}) = {fib(i)}")
# F(0)=0, F(1)=1, F(2)=1, F(3)=2, F(4)=3, F(5)=5, ...
```

##### 6.3 打家劫舍（LeetCode 198）

**题目**：一排房子，每个房子有一定金额。相邻房子不能同时被偷（会触发报警），问最多能偷多少？

**分析**：
- 状态定义：`dp[i]` = 前i个房子能偷到的最大金额
- 状态转移：对于第i个房子，要么偷（那就不能偷第i-1个），要么不偷
  - 偷：`dp[i] = dp[i-2] + nums[i]`
  - 不偷：`dp[i] = dp[i-1]`
  - `dp[i] = max(dp[i-1], dp[i-2] + nums[i])`
- 初始条件：`dp[0]=nums[0], dp[1]=max(nums[0], nums[1])`

```python
def rob(nums: list[int]) -> int:
    """
    打家劫舍问题
    
    类比：一条街上5家店，每家有一定金额。
    你不能偷相邻的两家（会报警），问最多偷多少。
    
    比如 [2, 7, 9, 3, 1]
    偷第1家(2) + 第3家(9) + 第5家(1) = 12
    或者 偷第2家(7) + 第4家(3) = 10
    答案是12
    """
    if not nums:
        return 0
    if len(nums) == 1:
        return nums[0]
    
    n = len(nums)
    
    # 方法1：标准DP
    dp = [0] * n
    dp[0] = nums[0]                          # 只有1家，只能偷它
    dp[1] = max(nums[0], nums[1])            # 2家，偷金额多的那家
    
    for i in range(2, n):
        # 要么不偷第i家（继承dp[i-1]的结果）
        # 要么偷第i家（加上dp[i-2]的结果，因为不能偷相邻的）
        dp[i] = max(dp[i - 1], dp[i - 2] + nums[i])
    
    return dp[-1]

    # 方法2：空间优化O(1)
    # prev2 = nums[0]
    # prev1 = max(nums[0], nums[1])
    # for i in range(2, n):
    #     curr = max(prev1, prev2 + nums[i])
    #     prev2 = prev1
    #     prev1 = curr
    # return prev1

# 测试
print(rob([1, 2, 3, 1]))       # 输出: 4 (偷第1家和第3家: 1+3=4)
print(rob([2, 7, 9, 3, 1]))   # 输出: 12 (偷第1、3、5家: 2+9+1=12)
print(rob([2, 1, 1, 2]))      # 输出: 4 (偷第1家和第4家: 2+2=4)
```

##### 6.4 最小路径和（LeetCode 64）

**题目**：从网格左上角到右下角，每步只能向右或向下，找一条路径使经过的数字之和最小。

**分析**：
- 状态定义：`dp[i][j]` = 从左上角到位置(i,j)的最小路径和
- 状态转移：到达(i,j)只能从上方(i-1,j)或左方(i,j-1)来
  - `dp[i][j] = min(dp[i-1][j], dp[i][j-1]) + grid[i][j]`
- 初始条件：第一行只能从左边来，第一列只能从上面来

```python
def minPathSum(grid: list[list[int]]) -> int:
    """
    最小路径和
    
    类比：你在一个棋盘格的左上角，要到右下角。
    每格有个数字（代表代价），只能向右或向下走。
    问走哪条路总代价最小。
    
    比如：
    [[1, 3, 1],
     [1, 5, 1],
     [4, 2, 1]]
    最短路径：1→3→1→1→1 = 7
    """
    if not grid or not grid[0]:
        return 0
    
    m, n = len(grid), len(grid[0])
    
    # dp[i][j] 表示从(0,0)到(i,j)的最小路径和
    dp = [[0] * n for _ in range(m)]
    dp[0][0] = grid[0][0]  # 起点
    
    # 初始化第一行：只能从左边来
    for j in range(1, n):
        dp[0][j] = dp[0][j - 1] + grid[0][j]
    
    # 初始化第一列：只能从上面来
    for i in range(1, m):
        dp[i][0] = dp[i - 1][0] + grid[i][0]
    
    # 填充其余位置
    for i in range(1, m):
        for j in range(1, n):
            # 从上方或左方中选较小的那个，再加上当前格子的值
            dp[i][j] = min(dp[i - 1][j], dp[i][j - 1]) + grid[i][j]
    
    return dp[m - 1][n - 1]  # 右下角就是答案

# 测试
grid = [
    [1, 3, 1],
    [1, 5, 1],
    [4, 2, 1]
]
print(minPathSum(grid))  # 输出: 7 (路径: 1→3→1→1→1)
```

---

#### 七、背包问题（重点！）

##### 7.1 0-1背包问题

###### 问题描述

你有4件物品和一个容量为8的背包：

| 物品 | 重量 | 价值 |
|------|------|------|
| 物品0 | 2 | 6 |
| 物品1 | 2 | 10 |
| 物品2 | 6 | 12 |
| 物品3 | 5 | 8 |

**每个物品只能选或不选（0或1），不能切分。** 问：怎么装能让背包里物品总价值最大？

###### 状态定义和转移方程推导

**状态定义**：`dp[i][w]` = 从前i个物品中选择，背包容量为w时，能获得的最大价值。

**对于每个物品i，有两种选择**：
1. **不选物品i**：`dp[i][w] = dp[i-1][w]`（和没有这个物品一样）
2. **选物品i**（前提是背包放得下）：`dp[i][w] = dp[i-1][w-weight[i]] + value[i]`（腾出物品i的重量，获得物品i的价值）

**状态转移方程**：
```
dp[i][w] = max(dp[i-1][w], dp[i-1][w-weight[i]] + value[i])
                    ↑ 不选物品i           ↑ 选物品i
```

###### 二维DP实现

```python
def knapsack_01(weights, values, capacity):
    """
    0-1背包问题 - 二维DP实现
    
    weights: 每个物品的重量列表
    values: 每个物品的价值列表
    capacity: 背包总容量
    
    用具体例子理解：
    物品: [重2价6, 重2价10, 重6价12, 重5价8]
    背包容量: 8
    """
    n = len(weights)
    
    # dp[i][w] = 前i个物品，容量w时的最大价值
    # 初始化全为0
    dp = [[0] * (capacity + 1) for _ in range(n + 1)]
    
    # 逐个物品考虑
    for i in range(1, n + 1):
        w_i = weights[i - 1]   # 第i个物品的重量（注意i从1开始，物品索引从0开始）
        v_i = values[i - 1]    # 第i个物品的价值
        
        for w in range(capacity + 1):
            # 默认：不选第i个物品
            dp[i][w] = dp[i - 1][w]
            
            # 如果背包放得下第i个物品，考虑选它
            if w >= w_i:
                dp[i][w] = max(dp[i][w], dp[i - 1][w - w_i] + v_i)
    
    # 打印DP表格（帮助理解）
    print("DP表格（行=物品，列=容量）：")
    print("     ", end="")
    for w in range(capacity + 1):
        print(f"w={w:>2} ", end="")
    print()
    for i in range(n + 1):
        print(f"i={i}: ", end="")
        for w in range(capacity + 1):
            print(f" {dp[i][w]:>3} ", end="")
        print()
    
    return dp[n][capacity]

# 测试
weights = [2, 2, 6, 5]
values = [6, 10, 12, 8]
capacity = 8

result = knapsack_01(weights, values, capacity)
print(f"\n最大价值: {result}")  # 输出: 24 (选物品0+1+3: 6+10+8=24, 重量2+2+5=9>8不行)
                                # 实际选物品0+1: 6+10=16, 重量4; 或物品1+3: 10+8=18, 重量7
                                # 或物品0+1+... 让我算一下
```

###### 一维空间优化

```python
def knapsack_01_optimized(weights, values, capacity):
    """
    0-1背包问题 - 一维空间优化
    
    核心观察：dp[i][w] 只依赖 dp[i-1][...]，所以可以用一维数组滚动更新。
    
    关键：内层循环必须【从后往前】遍历！
    为什么？因为每个物品只能用一次。
    如果从前往后，dp[w-w_i]可能已经被当前物品更新过了，
    相当于同一件物品被用了多次，变成完全背包了。
    
    类比：
    你只有1个苹果（0-1背包），从后往前拿保证不会拿两次。
    你有无限个苹果（完全背包），从前往后拿可以拿多次。
    """
    n = len(weights)
    dp = [0] * (capacity + 1)  # 一维数组
    
    for i in range(n):
        w_i = weights[i]
        v_i = values[i]
        
        # 从后往前遍历！保证每个物品只被选一次
        for w in range(capacity, w_i - 1, -1):
            dp[w] = max(dp[w], dp[w - w_i] + v_i)
    
    return dp[capacity]

# 测试
weights = [2, 2, 6, 5]
values = [6, 10, 12, 8]
capacity = 8
print(f"最大价值: {knapsack_01_optimized(weights, values, capacity)}")
```

##### 7.2 完全背包问题

###### 与0-1背包的区别

| 对比 | 0-1背包 | 完全背包 |
|------|---------|---------|
| 物品数量 | 每件只能用一次 | 每件可以用无限次 |
| 内层循环方向 | 从后往前 | 从前往后 |
| 生活类比 | 每种水果只有1个 | 每种水果无限供应 |

###### 完全背包Python实现

```python
def knapsack_complete(weights, values, capacity):
    """
    完全背包问题
    
    与0-1背包唯一的区别：内层循环从前往后遍历！
    因为物品可以重复使用，所以dp[w-w_i]可以包含当前物品，
    相当于再选一次同一个物品。
    """
    n = len(weights)
    dp = [0] * (capacity + 1)
    
    for i in range(n):
        w_i = weights[i]
        v_i = values[i]
        
        # 从前往后遍历！允许同一物品被选多次
        for w in range(w_i, capacity + 1):
            dp[w] = max(dp[w], dp[w - w_i] + v_i)
    
    return dp[capacity]

# 测试
weights = [2, 3, 5]
values = [6, 8, 12]
capacity = 8
print(f"完全背包最大价值: {knapsack_complete(weights, values, capacity)}")
# 可以选4个重量2价值6的物品: 4×6=24, 重量4×2=8
```

###### 零钱兑换（LeetCode 322）—— 完全背包的应用

```python
def coinChange(coins: list[int], amount: int) -> int:
    """
    零钱兑换
    
    题目：给定不同面额的硬币和一个总金额，
    计算凑成总金额所需的最少硬币个数。
    每种硬币可以使用无限次 → 完全背包！
    
    类比：你有1元、5元、10元的硬币（无限供应），
    要凑出23元，最少需要几个硬币？
    答案：2个10元 + 3个1元 = 5个硬币
    
    状态定义：dp[i] = 凑成金额i所需的最少硬币数
    状态转移：dp[i] = min(dp[i - coin] + 1) 对每种coin
    初始条件：dp[0] = 0（凑0元需要0个硬币）
    """
    # dp[i] 表示凑成金额 i 所需的最少硬币数
    # 初始化为 amount+1（一个不可能达到的大值，相当于"无穷大"）
    dp = [amount + 1] * (amount + 1)
    dp[0] = 0  # 凑0元需要0个硬币
    
    # 从小到大计算每个金额的最少硬币数
    for i in range(1, amount + 1):
        for coin in coins:
            if i - coin >= 0:  # 当前金额够减
                dp[i] = min(dp[i], dp[i - coin] + 1)
                #                ↑ 不用这枚硬币    ↑ 用这枚硬币，硬币数+1
    
    # 如果dp[amount]还是初始值，说明凑不出来
    return dp[amount] if dp[amount] != amount + 1 else -1

# 测试
print(coinChange([1, 5, 10], 23))  # 输出: 5 (10+10+1+1+1)
print(coinChange([2], 3))          # 输出: -1 (凑不出来)
print(coinChange([1], 0))          # 输出: 0
```

##### 7.3 背包问题总结

```
┌─────────────────────────────────────────────────────┐
│ 背包问题解题模板                                      │
├─────────────────────────────────────────────────────┤
│                                                     │
│  0-1背包（每件选或不选，只能选一次）：                   │
│    dp[w] = max(dp[w], dp[w-w_i] + v_i)              │
│    内层循环：从后往前 (capacity → w_i)                 │
│                                                     │
│  完全背包（每件可以选无限次）：                          │
│    dp[w] = max(dp[w], dp[w-w_i] + v_i)              │
│    内层循环：从前往后 (w_i → capacity)                 │
│                                                     │
│  核心区别：遍历方向！                                   │
│    从后往前 → 保证每件只用一次（0-1背包）               │
│    从前往后 → 允许每件用多次（完全背包）                 │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

#### 八、进阶级DP题目

##### 8.1 最长递增子序列 LIS（LeetCode 300）

###### O(n²) 解法

```python
def lengthOfLIS_n2(nums: list[int]) -> int:
    """
    最长递增子序列 - O(n²)解法
    
    题目：找到一个数组中最长的严格递增子序列的长度。
    子序列不要求连续，只要保持相对顺序。
    
    比如：[10, 9, 2, 5, 3, 7, 101, 18]
    LIS是 [2, 3, 7, 101] 或 [2, 3, 7, 18]，长度为4
    
    状态定义：dp[i] = 以nums[i]结尾的LIS长度
    状态转移：dp[i] = max(dp[j] + 1)，其中 j < i 且 nums[j] < nums[i]
    初始条件：每个dp[i]至少为1（自己单独构成一个子序列）
    
    类比：排队买票，每个人身高不同。
    你要找最长的一队人，使得从前往后身高递增。
    不要求他们站在一起，只要相对顺序对就行。
    """
    if not nums:
        return 0
    
    n = len(nums)
    dp = [1] * n  # 每个元素自身至少构成长度为1的子序列
    
    for i in range(1, n):
        for j in range(i):
            if nums[j] < nums[i]:  # nums[i]可以接在nums[j]后面
                dp[i] = max(dp[i], dp[j] + 1)
    
    return max(dp)  # 答案是所有dp[i]中的最大值

# 测试
print(lengthOfLIS_n2([10, 9, 2, 5, 3, 7, 101, 18]))  # 输出: 4
print(lengthOfLIS_n2([0, 1, 0, 3, 2, 3]))             # 输出: 4
```

###### O(n log n) 解法（贪心+二分查找）

```python
import bisect

def lengthOfLIS(nums: list[int]) -> int:
    """
    最长递增子序列 - O(n log n)解法
    
    思路：维护一个"tails"数组，tails[i]表示长度为i+1的递增子序列的最小末尾元素。
    tails数组始终保持递增，所以可以用二分查找。
    
    类比：
    你在玩纸牌接龙，有多条牌列在同时发展。
    每张新牌来时，找到能接上的牌列中末尾最大的那个接上去。
    如果接不上任何一条，就新开一条牌列。
    tails数组记录的就是每条牌列末尾的牌。
    
    关键操作：
    - 如果当前数比tails所有元素都大 → 追加到末尾（LIS长度+1）
    - 否则 → 用二分找到第一个>=当前数的位置，替换它
      （不改变LIS长度，但让末尾更小，给后面留更多空间）
    """
    tails = []  # tails[i] = 长度为i+1的LIS的最小末尾
    
    for num in nums:
        # 二分查找num在tails中的位置
        pos = bisect.bisect_left(tails, num)
        
        if pos == len(tails):
            # num比所有末尾都大，可以延长最长的子序列
            tails.append(num)
        else:
            # 替换第一个>=num的位置，让末尾更小
            tails[pos] = num
    
    return len(tails)

# 测试
print(lengthOfLIS([10, 9, 2, 5, 3, 7, 101, 18]))  # 输出: 4
print(lengthOfLIS([0, 1, 0, 3, 2, 3]))             # 输出: 4
print(lengthOfLIS([7, 7, 7, 7, 7]))                # 输出: 1
```

##### 8.2 最长公共子序列 LCS（LeetCode 1143）

```python
def longestCommonSubsequence(text1: str, text2: str) -> int:
    """
    最长公共子序列
    
    题目：给定两个字符串，求它们的最长公共子序列的长度。
    子序列不要求连续，只要保持相对顺序。
    
    比如：text1="abcde", text2="ace"
    LCS = "ace"，长度为3
    
    状态定义：dp[i][j] = text1前i个字符和text2前j个字符的LCS长度
    状态转移：
      如果 text1[i-1] == text2[j-1]：
          dp[i][j] = dp[i-1][j-1] + 1    （匹配上了，长度+1）
      否则：
          dp[i][j] = max(dp[i-1][j], dp[i][j-1])  （取较大值）
    初始条件：dp[0][j]=0, dp[i][0]=0（空字符串的LCS为0）
    
    类比：
    两个人各自有一串密码，你要找最长的"公共暗号"。
    暗号不要求连续，只要顺序对就行。
    比如"abcdef"和"xbdyef"的公共暗号是"bdef"。
    """
    m, n = len(text1), len(text2)
    
    # dp[i][j] = text1[:i] 和 text2[:j] 的LCS长度
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if text1[i - 1] == text2[j - 1]:
                # 字符相同：LCS长度 = 去掉这两个字符后的LCS + 1
                dp[i][j] = dp[i - 1][j - 1] + 1
            else:
                # 字符不同：取"去掉text1的字符"和"去掉text2的字符"中的较大值
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
    
    return dp[m][n]

# 测试
print(longestCommonSubsequence("abcde", "ace"))       # 输出: 3 ("ace")
print(longestCommonSubsequence("abc", "def"))         # 输出: 0 (没有公共子序列)
print(longestCommonSubsequence("abcba", "abecba"))    # 输出: 4 ("abba" 或 "abca")
```

##### 8.3 编辑距离（LeetCode 72）

```python
def minDistance(word1: str, word2: str) -> int:
    """
    编辑距离
    
    题目：将word1转换成word2，每次操作可以是：
    - 插入一个字符
    - 删除一个字符
    - 替换一个字符
    求最少操作数。
    
    比如：word1="horse", word2="ros"
    horse → rorse (替换h为r)
    rorse → rose (删除r)
    rose → ros (删除e)
    最少3步
    
    状态定义：dp[i][j] = word1前i个字符转换成word2前j个字符的最少操作数
    状态转移：
      如果 word1[i-1] == word2[j-1]：
          dp[i][j] = dp[i-1][j-1]    （字符相同，不需要操作）
      否则：
          dp[i][j] = 1 + min(
              dp[i-1][j],    # 删除word1[i-1]
              dp[i][j-1],    # 在word1中插入word2[j-1]
              dp[i-1][j-1]   # 替换word1[i-1]为word2[j-1]
          )
    初始条件：dp[i][0]=i（删除i个字符）, dp[0][j]=j（插入j个字符）
    
    类比：
    你在打字，打错了几个字母。每次可以加一个字母、删一个字母、
    或者改一个字母。问最少改几次能改对。
    """
    m, n = len(word1), len(word2)
    
    # dp[i][j] = word1[:i] 变成 word2[:j] 的最少操作数
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    
    # 初始条件
    for i in range(m + 1):
        dp[i][0] = i  # word1前i个字符变成空字符串，需要删除i次
    for j in range(n + 1):
        dp[0][j] = j  # 空字符串变成word2前j个字符，需要插入j次
    
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if word1[i - 1] == word2[j - 1]:
                # 字符相同，不需要额外操作
                dp[i][j] = dp[i - 1][j - 1]
            else:
                dp[i][j] = 1 + min(
                    dp[i - 1][j],      # 删除
                    dp[i][j - 1],      # 插入
                    dp[i - 1][j - 1]   # 替换
                )
    
    return dp[m][n]

# 测试
print(minDistance("horse", "ros"))     # 输出: 3
print(minDistance("intention", "execution"))  # 输出: 5
print(minDistance("", "abc"))          # 输出: 3
```

##### 8.4 最大子数组和（LeetCode 53）—— Kadane算法

```python
def maxSubArray(nums: list[int]) -> int:
    """
    最大子数组和 - Kadane算法
    
    题目：找到一个连续子数组，使其元素之和最大。
    
    比如：[-2, 1, -3, 4, -1, 2, 1, -5, 4]
    最大子数组：[4, -1, 2, 1]，和为6
    
    状态定义：dp[i] = 以nums[i]结尾的最大子数组和
    状态转移：dp[i] = max(nums[i], dp[i-1] + nums[i])
      - 要么自己另起炉灶（从nums[i]开始新的子数组）
      - 要么接上前面的子数组（dp[i-1] + nums[i]）
    初始条件：dp[0] = nums[0]
    
    类比：
    你在记账，每天的收支有正有负。
    你要找连续的一段日子，使得总收入最大。
    如果之前的累计变成了负数，不如从今天重新开始记。
    """
    # 空间优化版本：只需要前一个状态
    current_max = nums[0]   # 以当前元素结尾的最大子数组和
    global_max = nums[0]    # 全局最大子数组和
    
    for i in range(1, len(nums)):
        # 要么从当前元素重新开始，要么接上前面的子数组
        current_max = max(nums[i], current_max + nums[i])
        # 更新全局最大值
        global_max = max(global_max, current_max)
    
    return global_max

# 测试
print(maxSubArray([-2, 1, -3, 4, -1, 2, 1, -5, 4]))  # 输出: 6
print(maxSubArray([1]))                                # 输出: 1
print(maxSubArray([-1, -2, -3]))                       # 输出: -1
```

##### 8.5 单词拆分（LeetCode 139）

```python
def wordBreak(s: str, wordDict: list[str]) -> bool:
    """
    单词拆分
    
    题目：给定一个字符串和一个单词字典，判断字符串能否被拆分成
    字典中的一个或多个单词（单词可以重复使用）。
    
    比如：s="leetcode", wordDict=["leet", "code"]
    可以拆成 "leet" + "code" → True
    
    状态定义：dp[i] = s的前i个字符能否被拆分
    状态转移：dp[i] = any(dp[j] and s[j:i] in wordDict) for j in range(i)
      - 如果s[j:i]在字典中，且s的前j个字符也能被拆分，那s的前i个就能被拆分
    初始条件：dp[0] = True（空字符串可以被拆分）
    
    类比：
    你有一段很长的话，字典里有一些词语。
    问你能不能把这段话拆成字典里的词语。
    """
    word_set = set(wordDict)  # 转成集合，查找更快O(1)
    n = len(s)
    
    # dp[i] 表示 s[:i] 能否被拆分
    dp = [False] * (n + 1)
    dp[0] = True  # 空字符串可以被拆分
    
    for i in range(1, n + 1):
        for j in range(i):
            # 如果s[:j]可以被拆分，且s[j:i]在字典中
            if dp[j] and s[j:i] in word_set:
                dp[i] = True
                break  # 找到一种拆分方式就够了
    
    return dp[n]

# 测试
print(wordBreak("leetcode", ["leet", "code"]))           # 输出: True
print(wordBreak("applepenapple", ["apple", "pen"]))      # 输出: True
print(wordBreak("catsandog", ["cats", "dog", "sand", "and", "cat"]))  # 输出: False
```

##### 8.6 不同路径（LeetCode 62）

```python
def uniquePaths(m: int, n: int) -> int:
    """
    不同路径
    
    题目：机器人从网格左上角到右下角，每步只能向右或向下，
    问有多少条不同的路径？
    
    比如：m=3, n=7（3行7列）
    输出：28
    
    状态定义：dp[i][j] = 从(0,0)到(i,j)的路径数
    状态转移：dp[i][j] = dp[i-1][j] + dp[i][j-1]
      （从上方来 + 从左方来）
    初始条件：dp[0][j]=1, dp[i][0]=1（第一行和第一列只有1条路径）
    
    类比：
    你在城市里从A走到B，只能往东或往南走。
    问有多少种走法。
    """
    # dp[i][j] 表示从(0,0)到(i,j)的路径数
    dp = [[1] * n for _ in range(m)]
    
    # 从(1,1)开始填充
    for i in range(1, m):
        for j in range(1, n):
            dp[i][j] = dp[i - 1][j] + dp[i][j - 1]
    
    return dp[m - 1][n - 1]

    # 空间优化版本（只需一行）：
    # dp = [1] * n
    # for i in range(1, m):
    #     for j in range(1, n):
    #         dp[j] += dp[j - 1]
    # return dp[-1]

# 测试
print(uniquePaths(3, 7))  # 输出: 28
print(uniquePaths(3, 2))  # 输出: 3
print(uniquePaths(7, 3))  # 输出: 28
```

---

#### 九、DP技巧总结

##### 如何判断一个问题能否用DP

```
满足以下两个条件，大概率可以用DP：

1. 最优子结构：大问题的最优解包含小问题的最优解
   → "从北京到上海的最短路线"包含"从北京到南京的最短路线"

2. 重叠子问题：不同的决策路径会碰到相同的子问题
   → 算F(5)需要F(3)，算F(4)也需要F(3) → F(3)被重复计算

额外特征：
- 问题问"最多/最少/最长/最短/方案数" → 大概率DP
- 问题涉及"选或不选"、"怎么切分" → 大概率DP
```

##### 状态定义的常见套路

| 题目类型 | 状态定义 | 例子 |
|---------|---------|------|
| 一维序列 | `dp[i]` = 到第i个元素时的答案 | 爬楼梯、打家劫舍 |
| 二维网格 | `dp[i][j]` = 到位置(i,j)的答案 | 最小路径和、不同路径 |
| 两个序列 | `dp[i][j]` = 序列1前i个和序列2前j个的答案 | LCS、编辑距离 |
| 背包类 | `dp[i][w]` = 前i个物品容量w的答案 | 0-1背包 |
| 子串/子序列 | `dp[i]` = 以第i个元素结尾的xxx | LIS |
| 区间DP | `dp[i][j]` = 区间[i,j]的答案 | 戳气球 |

##### 空间优化技巧

```
1. 滚动数组：如果dp[i]只依赖dp[i-1]，只需要两行交替
   例：最小路径和可以用一维数组

2. 两个变量：如果dp[i]只依赖dp[i-1]和dp[i-2]，只需要两个变量
   例：爬楼梯、打家劫舍

3. 一维压缩：二维DP中，如果按行遍历且只依赖上一行，
   可以压缩成一维数组
   例：0-1背包从二维dp[i][w]压缩到一维dp[w]

注意：空间优化时要特别注意遍历方向！
- 0-1背包压缩到一维时，内层要从后往前
- 如果从前往后会变成完全背包的效果
```

---
---


### 主题18 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、斐波那契数列的三种实现

```typescript
// ========== 斐波那契数列：F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2) ==========

// 1. 朴素递归：大量重复计算，O(2^n)，指数级慢
function fibRecursive(n: number): number {
    if (n <= 1) return n;
    return fibRecursive(n - 1) + fibRecursive(n - 2);
}

// 2. 记忆化搜索：递归 + 备忘录（自顶向下），O(n)
function fibMemo(n: number, memo: number[] = []): number {
    if (n <= 1) return n;
    if (memo[n] !== undefined) return memo[n]; // 算过就直接查表
    memo[n] = fibMemo(n - 1, memo) + fibMemo(n - 2, memo);
    return memo[n];
}

// 3. DP表格：自底向上递推，O(n)
function fibDp(n: number): number {
    if (n <= 1) return n;
    const dp = new Array<number>(n + 1);
    dp[0] = 0;
    dp[1] = 1;
    for (let i = 2; i <= n; i++) {
        dp[i] = dp[i - 1] + dp[i - 2]; // 状态转移方程
    }
    return dp[n];
}

console.log(fibRecursive(10)); // 55
console.log(fibMemo(100));     // 354224848179261915075（秒出结果）
console.log(fibDp(100));       // 354224848179261915075
```

##### 二、入门级DP题目

```typescript
// ========== 6.1 爬楼梯（LeetCode 70） ==========
// dp[i] = 到第i级台阶的方法数，dp[i] = dp[i-1] + dp[i-2]
function climbStairs(n: number): number {
    if (n <= 2) return n;
    const dp = new Array<number>(n + 1);
    dp[1] = 1; // 到第1级只有1种方法
    dp[2] = 2; // 到第2级有2种方法：1+1 或 直接2
    for (let i = 3; i <= n; i++) {
        dp[i] = dp[i - 1] + dp[i - 2];
    }
    return dp[n];
}
console.log(climbStairs(3)); // 3 (1+1+1, 1+2, 2+1)
console.log(climbStairs(5)); // 8

// ========== 6.3 打家劫舍（LeetCode 198） ==========
// dp[i] = 前i个房子能偷到的最大金额
// dp[i] = max(dp[i-1], dp[i-2] + nums[i])（不偷 / 偷）
function rob(nums: number[]): number {
    if (nums.length === 0) return 0;
    if (nums.length === 1) return nums[0];

    const n = nums.length;
    const dp = new Array<number>(n);
    dp[0] = nums[0];
    dp[1] = Math.max(nums[0], nums[1]);
    for (let i = 2; i < n; i++) {
        dp[i] = Math.max(dp[i - 1], dp[i - 2] + nums[i]);
    }
    return dp[n - 1];
}
console.log(rob([1, 2, 3, 1]));     // 4 (1+3)
console.log(rob([2, 7, 9, 3, 1])); // 12 (2+9+1)
console.log(rob([2, 1, 1, 2]));    // 4 (2+2)

// ========== 6.4 最小路径和（LeetCode 64） ==========
// dp[i][j] = 从(0,0)到(i,j)的最小路径和
// dp[i][j] = min(dp[i-1][j], dp[i][j-1]) + grid[i][j]
function minPathSum(grid: number[][]): number {
    const m = grid.length;
    const n = grid[0].length;
    const dp = Array.from({ length: m }, () => new Array<number>(n).fill(0));
    dp[0][0] = grid[0][0];
    // 第一行只能从左边来，第一列只能从上面来
    for (let j = 1; j < n; j++) dp[0][j] = dp[0][j - 1] + grid[0][j];
    for (let i = 1; i < m; i++) dp[i][0] = dp[i - 1][0] + grid[i][0];
    for (let i = 1; i < m; i++) {
        for (let j = 1; j < n; j++) {
            dp[i][j] = Math.min(dp[i - 1][j], dp[i][j - 1]) + grid[i][j];
        }
    }
    return dp[m - 1][n - 1];
}
const grid18: number[][] = [
    [1, 3, 1],
    [1, 5, 1],
    [4, 2, 1],
];
console.log(minPathSum(grid18)); // 7 (1→3→1→1→1)
```

##### 三、背包问题

```typescript
// ========== 7.1 0-1背包 - 二维DP ==========
// dp[i][w] = 前i个物品、容量w时的最大价值
// dp[i][w] = max(dp[i-1][w], dp[i-1][w-weight[i]] + value[i])
function knapsack01(weights: number[], values: number[], capacity: number): number {
    const n = weights.length;
    const dp = Array.from({ length: n + 1 }, () => new Array<number>(capacity + 1).fill(0));
    for (let i = 1; i <= n; i++) {
        for (let w = 0; w <= capacity; w++) {
            dp[i][w] = dp[i - 1][w]; // 默认不选第i个物品
            if (w >= weights[i - 1]) {
                // 放得下就考虑选它
                dp[i][w] = Math.max(dp[i][w], dp[i - 1][w - weights[i - 1]] + values[i - 1]);
            }
        }
    }
    return dp[n][capacity];
}

// ========== 7.1 0-1背包 - 一维空间优化 ==========
// 内层必须【从后往前】遍历，保证每个物品只用一次
function knapsack01Optimized(weights: number[], values: number[], capacity: number): number {
    const dp = new Array<number>(capacity + 1).fill(0);
    for (let i = 0; i < weights.length; i++) {
        for (let w = capacity; w >= weights[i]; w--) {
            dp[w] = Math.max(dp[w], dp[w - weights[i]] + values[i]);
        }
    }
    return dp[capacity];
}
// 选物品1(重2价10) + 物品2(重6价12) = 22，重量8正好
console.log(knapsack01([2, 2, 6, 5], [6, 10, 12, 8], 8));           // 22
console.log(knapsack01Optimized([2, 2, 6, 5], [6, 10, 12, 8], 8));  // 22

// ========== 7.2 完全背包 ==========
// 与0-1背包唯一区别：内层【从前往后】遍历，物品可以重复使用
function knapsackComplete(weights: number[], values: number[], capacity: number): number {
    const dp = new Array<number>(capacity + 1).fill(0);
    for (let i = 0; i < weights.length; i++) {
        for (let w = weights[i]; w <= capacity; w++) {
            dp[w] = Math.max(dp[w], dp[w - weights[i]] + values[i]);
        }
    }
    return dp[capacity];
}
// 选4个重量2价值6的物品: 4×6=24, 重量 4×2=8
console.log(knapsackComplete([2, 3, 5], [6, 8, 12], 8)); // 24

// ========== 零钱兑换（LeetCode 322）—— 完全背包应用 ==========
// dp[i] = 凑成金额i所需的最少硬币数
// dp[i] = min(dp[i-coin] + 1) 对每种coin
function coinChange(coins: number[], amount: number): number {
    const dp = new Array<number>(amount + 1).fill(amount + 1); // 大值相当于"无穷大"
    dp[0] = 0; // 凑0元需要0个硬币
    for (let i = 1; i <= amount; i++) {
        for (const coin of coins) {
            if (i - coin >= 0) {
                dp[i] = Math.min(dp[i], dp[i - coin] + 1);
            }
        }
    }
    return dp[amount] === amount + 1 ? -1 : dp[amount];
}
console.log(coinChange([1, 5, 10], 23)); // 5 (10+10+1+1+1)
console.log(coinChange([2], 3));         // -1（凑不出来）
console.log(coinChange([1], 0));         // 0
```

##### 四、进阶级DP题目（1）：LIS 与 LCS

```typescript
// ========== 8.1 最长递增子序列 LIS（LeetCode 300）- O(n²) ==========
// dp[i] = 以nums[i]结尾的LIS长度
// dp[i] = max(dp[j] + 1)，其中 j < i 且 nums[j] < nums[i]
function lengthOfLISN2(nums: number[]): number {
    if (nums.length === 0) return 0;
    const dp = new Array<number>(nums.length).fill(1);
    for (let i = 1; i < nums.length; i++) {
        for (let j = 0; j < i; j++) {
            if (nums[j] < nums[i]) {
                dp[i] = Math.max(dp[i], dp[j] + 1);
            }
        }
    }
    return Math.max(...dp);
}

// ========== 8.1 LIS - O(n log n) 贪心 + 二分 ==========
// tails[i] = 长度为i+1的递增子序列的最小末尾元素
function lengthOfLIS(nums: number[]): number {
    const tails: number[] = [];
    for (const num of nums) {
        // 二分查找第一个 >= num 的位置（等价于 Python 的 bisect_left）
        let lo = 0;
        let hi = tails.length;
        while (lo < hi) {
            const mid = (lo + hi) >> 1;
            if (tails[mid] < num) lo = mid + 1;
            else hi = mid;
        }
        if (lo === tails.length) tails.push(num); // 比所有末尾都大，延长LIS
        else tails[lo] = num;                     // 替换，让末尾更小
    }
    return tails.length;
}
console.log(lengthOfLISN2([10, 9, 2, 5, 3, 7, 101, 18])); // 4
console.log(lengthOfLIS([10, 9, 2, 5, 3, 7, 101, 18]));   // 4
console.log(lengthOfLIS([0, 1, 0, 3, 2, 3]));             // 4
console.log(lengthOfLIS([7, 7, 7, 7, 7]));                // 1

// ========== 8.2 最长公共子序列 LCS（LeetCode 1143） ==========
// dp[i][j] = text1前i个字符和text2前j个字符的LCS长度
function longestCommonSubsequence(text1: string, text2: string): number {
    const m = text1.length;
    const n = text2.length;
    const dp = Array.from({ length: m + 1 }, () => new Array<number>(n + 1).fill(0));
    for (let i = 1; i <= m; i++) {
        for (let j = 1; j <= n; j++) {
            if (text1[i - 1] === text2[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1] + 1; // 匹配上了，长度+1
            } else {
                dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]); // 取较大值
            }
        }
    }
    return dp[m][n];
}
console.log(longestCommonSubsequence("abcde", "ace"));    // 3 ("ace")
console.log(longestCommonSubsequence("abc", "def"));      // 0
console.log(longestCommonSubsequence("abcba", "abecba")); // 4 ("abba" 或 "abca")
```

##### 四、进阶级DP题目（2）：编辑距离 / 最大子数组和

```typescript
// ========== 8.3 编辑距离（LeetCode 72） ==========
// dp[i][j] = word1前i个字符转换成word2前j个字符的最少操作数
function minDistance(word1: string, word2: string): number {
    const m = word1.length;
    const n = word2.length;
    const dp = Array.from({ length: m + 1 }, () => new Array<number>(n + 1).fill(0));
    for (let i = 0; i <= m; i++) dp[i][0] = i; // 删除i次
    for (let j = 0; j <= n; j++) dp[0][j] = j; // 插入j次
    for (let i = 1; i <= m; i++) {
        for (let j = 1; j <= n; j++) {
            if (word1[i - 1] === word2[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1]; // 字符相同，不需要操作
            } else {
                dp[i][j] = 1 + Math.min(
                    dp[i - 1][j],    // 删除
                    dp[i][j - 1],    // 插入
                    dp[i - 1][j - 1] // 替换
                );
            }
        }
    }
    return dp[m][n];
}
console.log(minDistance("horse", "ros"));            // 3
console.log(minDistance("intention", "execution"));  // 5
console.log(minDistance("", "abc"));                 // 3

// ========== 8.4 最大子数组和（LeetCode 53）- Kadane算法 ==========
// dp[i] = 以nums[i]结尾的最大子数组和 = max(nums[i], dp[i-1] + nums[i])
function maxSubArray(nums: number[]): number {
    let currentMax = nums[0]; // 以当前元素结尾的最大子数组和
    let globalMax = nums[0];  // 全局最大子数组和
    for (let i = 1; i < nums.length; i++) {
        // 要么从当前元素重新开始，要么接上前面的子数组
        currentMax = Math.max(nums[i], currentMax + nums[i]);
        globalMax = Math.max(globalMax, currentMax);
    }
    return globalMax;
}
console.log(maxSubArray([-2, 1, -3, 4, -1, 2, 1, -5, 4])); // 6
console.log(maxSubArray([1]));                              // 1
console.log(maxSubArray([-1, -2, -3]));                     // -1
```

##### 四、进阶级DP题目（3）：单词拆分 / 不同路径

```typescript
// ========== 8.5 单词拆分（LeetCode 139） ==========
// dp[i] = s的前i个字符能否被拆分
// dp[i] = any(dp[j] && s[j:i] 在字典中)
function wordBreak(s: string, wordDict: string[]): boolean {
    const wordSet = new Set(wordDict); // 转成集合，查找 O(1)
    const n = s.length;
    const dp = new Array<boolean>(n + 1).fill(false);
    dp[0] = true; // 空字符串可以被拆分
    for (let i = 1; i <= n; i++) {
        for (let j = 0; j < i; j++) {
            if (dp[j] && wordSet.has(s.slice(j, i))) {
                dp[i] = true;
                break; // 找到一种拆分方式就够了
            }
        }
    }
    return dp[n];
}
console.log(wordBreak("leetcode", ["leet", "code"]));                      // true
console.log(wordBreak("applepenapple", ["apple", "pen"]));                 // true
console.log(wordBreak("catsandog", ["cats", "dog", "sand", "and", "cat"])); // false

// ========== 8.6 不同路径（LeetCode 62） ==========
// dp[i][j] = 从(0,0)到(i,j)的路径数 = dp[i-1][j] + dp[i][j-1]
function uniquePaths(m: number, n: number): number {
    // 第一行和第一列都只有1条路径，所以初始化为1
    const dp = Array.from({ length: m }, () => new Array<number>(n).fill(1));
    for (let i = 1; i < m; i++) {
        for (let j = 1; j < n; j++) {
            dp[i][j] = dp[i - 1][j] + dp[i][j - 1]; // 从上方来 + 从左方来
        }
    }
    return dp[m - 1][n - 1];
}
console.log(uniquePaths(3, 7)); // 28
console.log(uniquePaths(3, 2)); // 3
console.log(uniquePaths(7, 3)); // 28
```


### 主题18 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、斐波那契数列的三种实现

```go
package main

import "fmt"

// ========== 斐波那契数列：F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2) ==========

// 1. 朴素递归：大量重复计算，O(2^n)，指数级慢
func fibRecursive(n int) int {
	if n <= 1 {
		return n
	}
	return fibRecursive(n-1) + fibRecursive(n-2)
}

// 2. 记忆化搜索：递归 + 备忘录（自顶向下），O(n)
func fibMemo(n int, memo []int) int {
	if n <= 1 {
		return n
	}
	if memo[n] != 0 {
		return memo[n] // 算过就直接查表
	}
	memo[n] = fibMemo(n-1, memo) + fibMemo(n-2, memo)
	return memo[n]
}

// 3. DP表格：自底向上递推，O(n)
func fibDp(n int) int {
	if n <= 1 {
		return n
	}
	dp := make([]int, n+1)
	dp[0] = 0
	dp[1] = 1
	for i := 2; i <= n; i++ {
		dp[i] = dp[i-1] + dp[i-2] // 状态转移方程
	}
	return dp[n]
}

func testFib() {
	fmt.Println("===== 斐波那契三种实现 =====")
	fmt.Println(fibRecursive(10)) // 55
	memo := make([]int, 101)
	fmt.Println(fibMemo(100, memo)) // 354224848179261915075
	fmt.Println(fibDp(100))         // 354224848179261915075
}
```

##### 二、入门级DP题目

```go
package main

import "fmt"

// ========== 6.1 爬楼梯（LeetCode 70） ==========
// dp[i] = 到第i级台阶的方法数，dp[i] = dp[i-1] + dp[i-2]
func climbStairs(n int) int {
	if n <= 2 {
		return n
	}
	dp := make([]int, n+1)
	dp[1] = 1 // 到第1级只有1种方法
	dp[2] = 2 // 到第2级有2种方法：1+1 或 直接2
	for i := 3; i <= n; i++ {
		dp[i] = dp[i-1] + dp[i-2]
	}
	return dp[n]
}

// ========== 6.3 打家劫舍（LeetCode 198） ==========
// dp[i] = 前i个房子能偷到的最大金额
// dp[i] = max(dp[i-1], dp[i-2] + nums[i])（不偷 / 偷）
func rob(nums []int) int {
	if len(nums) == 0 {
		return 0
	}
	if len(nums) == 1 {
		return nums[0]
	}
	n := len(nums)
	dp := make([]int, n)
	dp[0] = nums[0]
	dp[1] = max(nums[0], nums[1])
	for i := 2; i < n; i++ {
		dp[i] = max(dp[i-1], dp[i-2]+nums[i])
	}
	return dp[n-1]
}

// ========== 6.4 最小路径和（LeetCode 64） ==========
// dp[i][j] = 从(0,0)到(i,j)的最小路径和
// dp[i][j] = min(dp[i-1][j], dp[i][j-1]) + grid[i][j]
func minPathSum(grid [][]int) int {
	m, n := len(grid), len(grid[0])
	dp := make([][]int, m)
	for i := range dp {
		dp[i] = make([]int, n)
	}
	dp[0][0] = grid[0][0]
	// 第一行只能从左边来，第一列只能从上面来
	for j := 1; j < n; j++ {
		dp[0][j] = dp[0][j-1] + grid[0][j]
	}
	for i := 1; i < m; i++ {
		dp[i][0] = dp[i-1][0] + grid[i][0]
	}
	for i := 1; i < m; i++ {
		for j := 1; j < n; j++ {
			dp[i][j] = min(dp[i-1][j], dp[i][j-1]) + grid[i][j]
		}
	}
	return dp[m-1][n-1]
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func testEntryDP() {
	fmt.Println("===== 爬楼梯 =====")
	fmt.Println(climbStairs(3)) // 3 (1+1+1, 1+2, 2+1)
	fmt.Println(climbStairs(5)) // 8

	fmt.Println("===== 打家劫舍 =====")
	fmt.Println(rob([]int{1, 2, 3, 1}))     // 4 (1+3)
	fmt.Println(rob([]int{2, 7, 9, 3, 1})) // 12 (2+9+1)
	fmt.Println(rob([]int{2, 1, 1, 2}))    // 4 (2+2)

	fmt.Println("===== 最小路径和 =====")
	grid := [][]int{
		{1, 3, 1},
		{1, 5, 1},
		{4, 2, 1},
	}
	fmt.Println(minPathSum(grid)) // 7 (1→3→1→1→1)
}
```

##### 三、背包问题

```go
package main

import "fmt"

// ========== 7.1 0-1背包 - 二维DP ==========
// dp[i][w] = 前i个物品、容量w时的最大价值
// dp[i][w] = max(dp[i-1][w], dp[i-1][w-weight[i]] + value[i])
func knapsack01(weights, values []int, capacity int) int {
	n := len(weights)
	dp := make([][]int, n+1)
	for i := range dp {
		dp[i] = make([]int, capacity+1)
	}
	for i := 1; i <= n; i++ {
		for w := 0; w <= capacity; w++ {
			dp[i][w] = dp[i-1][w] // 默认不选第i个物品
			if w >= weights[i-1] {
				// 放得下就考虑选它
				dp[i][w] = max(dp[i][w], dp[i-1][w-weights[i-1]]+values[i-1])
			}
		}
	}
	return dp[n][capacity]
}

// ========== 7.1 0-1背包 - 一维空间优化 ==========
// 内层必须【从后往前】遍历，保证每个物品只用一次
func knapsack01Optimized(weights, values []int, capacity int) int {
	dp := make([]int, capacity+1)
	for i := 0; i < len(weights); i++ {
		for w := capacity; w >= weights[i]; w-- {
			dp[w] = max(dp[w], dp[w-weights[i]]+values[i])
		}
	}
	return dp[capacity]
}

// ========== 7.2 完全背包 ==========
// 与0-1背包唯一区别：内层【从前往后】遍历，物品可以重复使用
func knapsackComplete(weights, values []int, capacity int) int {
	dp := make([]int, capacity+1)
	for i := 0; i < len(weights); i++ {
		for w := weights[i]; w <= capacity; w++ {
			dp[w] = max(dp[w], dp[w-weights[i]]+values[i])
		}
	}
	return dp[capacity]
}

// ========== 零钱兑换（LeetCode 322）—— 完全背包应用 ==========
// dp[i] = 凑成金额i所需的最少硬币数
// dp[i] = min(dp[i-coin] + 1) 对每种coin
func coinChange(coins []int, amount int) int {
	dp := make([]int, amount+1)
	for i := range dp {
		dp[i] = amount + 1 // 大值相当于"无穷大"
	}
	dp[0] = 0 // 凑0元需要0个硬币
	for i := 1; i <= amount; i++ {
		for _, coin := range coins {
			if i-coin >= 0 {
				dp[i] = min(dp[i], dp[i-coin]+1)
			}
		}
	}
	if dp[amount] == amount+1 {
		return -1 // 凑不出来
	}
	return dp[amount]
}

func testKnapsack() {
	fmt.Println("===== 0-1背包（二维）=====")
	fmt.Println(knapsack01([]int{2, 2, 6, 5}, []int{6, 10, 12, 8}, 8)) // 22（选物品1+2）
	fmt.Println("===== 0-1背包（一维优化）=====")
	fmt.Println(knapsack01Optimized([]int{2, 2, 6, 5}, []int{6, 10, 12, 8}, 8)) // 22
	fmt.Println("===== 完全背包 =====")
	fmt.Println(knapsackComplete([]int{2, 3, 5}, []int{6, 8, 12}, 8)) // 24（4个重量2价值6）
	fmt.Println("===== 零钱兑换 =====")
	fmt.Println(coinChange([]int{1, 5, 10}, 23)) // 5 (10+10+1+1+1)
	fmt.Println(coinChange([]int{2}, 3))         // -1（凑不出来）
	fmt.Println(coinChange([]int{1}, 0))         // 0
}
```

##### 四、进阶级DP题目（1）：LIS 与 LCS

```go
package main

import "fmt"

// ========== 8.1 最长递增子序列 LIS（LeetCode 300）- O(n²) ==========
// dp[i] = 以nums[i]结尾的LIS长度
// dp[i] = max(dp[j] + 1)，其中 j < i 且 nums[j] < nums[i]
func lengthOfLISN2(nums []int) int {
	if len(nums) == 0 {
		return 0
	}
	dp := make([]int, len(nums))
	for i := range dp {
		dp[i] = 1
	}
	for i := 1; i < len(nums); i++ {
		for j := 0; j < i; j++ {
			if nums[j] < nums[i] {
				dp[i] = max(dp[i], dp[j]+1)
			}
		}
	}
	ans := 0
	for _, v := range dp {
		ans = max(ans, v)
	}
	return ans
}

// ========== 8.1 LIS - O(n log n) 贪心 + 二分 ==========
// tails[i] = 长度为i+1的递增子序列的最小末尾元素
// 二分查找第一个 >= num 的位置（等价于 Python 的 bisect_left）
func lowerBound(arr []int, target int) int {
	lo, hi := 0, len(arr)
	for lo < hi {
		mid := (lo + hi) / 2
		if arr[mid] < target {
			lo = mid + 1
		} else {
			hi = mid
		}
	}
	return lo
}

func lengthOfLIS(nums []int) int {
	tails := []int{}
	for _, num := range nums {
		pos := lowerBound(tails, num)
		if pos == len(tails) {
			tails = append(tails, num) // 比所有末尾都大，延长LIS
		} else {
			tails[pos] = num // 替换，让末尾更小
		}
	}
	return len(tails)
}

// ========== 8.2 最长公共子序列 LCS（LeetCode 1143） ==========
// dp[i][j] = text1前i个字符和text2前j个字符的LCS长度
func longestCommonSubsequence(text1, text2 string) int {
	m, n := len(text1), len(text2)
	dp := make([][]int, m+1)
	for i := range dp {
		dp[i] = make([]int, n+1)
	}
	for i := 1; i <= m; i++ {
		for j := 1; j <= n; j++ {
			if text1[i-1] == text2[j-1] {
				dp[i][j] = dp[i-1][j-1] + 1 // 匹配上了，长度+1
			} else {
				dp[i][j] = max(dp[i-1][j], dp[i][j-1]) // 取较大值
			}
		}
	}
	return dp[m][n]
}

func testLISLCS() {
	fmt.Println("===== 最长递增子序列 =====")
	fmt.Println(lengthOfLISN2([]int{10, 9, 2, 5, 3, 7, 101, 18})) // 4
	fmt.Println(lengthOfLIS([]int{10, 9, 2, 5, 3, 7, 101, 18}))   // 4
	fmt.Println(lengthOfLIS([]int{0, 1, 0, 3, 2, 3}))             // 4
	fmt.Println(lengthOfLIS([]int{7, 7, 7, 7, 7}))                // 1
	fmt.Println("===== 最长公共子序列 =====")
	fmt.Println(longestCommonSubsequence("abcde", "ace"))    // 3 ("ace")
	fmt.Println(longestCommonSubsequence("abc", "def"))      // 0
	fmt.Println(longestCommonSubsequence("abcba", "abecba")) // 4
}
```

##### 四、进阶级DP题目（2）：编辑距离 / 最大子数组和

```go
package main

import "fmt"

// ========== 8.3 编辑距离（LeetCode 72） ==========
// dp[i][j] = word1前i个字符转换成word2前j个字符的最少操作数
func minDistance(word1, word2 string) int {
	m, n := len(word1), len(word2)
	dp := make([][]int, m+1)
	for i := range dp {
		dp[i] = make([]int, n+1)
	}
	for i := 0; i <= m; i++ {
		dp[i][0] = i // 删除i次
	}
	for j := 0; j <= n; j++ {
		dp[0][j] = j // 插入j次
	}
	for i := 1; i <= m; i++ {
		for j := 1; j <= n; j++ {
			if word1[i-1] == word2[j-1] {
				dp[i][j] = dp[i-1][j-1] // 字符相同，不需要操作
			} else {
				dp[i][j] = 1 + min(min(dp[i-1][j], dp[i][j-1]), dp[i-1][j-1])
				//                      删除          插入          替换
			}
		}
	}
	return dp[m][n]
}

// ========== 8.4 最大子数组和（LeetCode 53）- Kadane算法 ==========
// dp[i] = 以nums[i]结尾的最大子数组和 = max(nums[i], dp[i-1] + nums[i])
func maxSubArray(nums []int) int {
	currentMax := nums[0] // 以当前元素结尾的最大子数组和
	globalMax := nums[0]  // 全局最大子数组和
	for i := 1; i < len(nums); i++ {
		// 要么从当前元素重新开始，要么接上前面的子数组
		currentMax = max(nums[i], currentMax+nums[i])
		globalMax = max(globalMax, currentMax)
	}
	return globalMax
}

func testEditDist() {
	fmt.Println("===== 编辑距离 =====")
	fmt.Println(minDistance("horse", "ros"))           // 3
	fmt.Println(minDistance("intention", "execution")) // 5
	fmt.Println(minDistance("", "abc"))                // 3
	fmt.Println("===== 最大子数组和 =====")
	fmt.Println(maxSubArray([]int{-2, 1, -3, 4, -1, 2, 1, -5, 4})) // 6
	fmt.Println(maxSubArray([]int{1}))                             // 1
	fmt.Println(maxSubArray([]int{-1, -2, -3}))                    // -1
}
```

##### 四、进阶级DP题目（3）：单词拆分 / 不同路径

```go
package main

import "fmt"

// ========== 8.5 单词拆分（LeetCode 139） ==========
// dp[i] = s的前i个字符能否被拆分
// dp[i] = any(dp[j] && s[j:i] 在字典中)
func wordBreak(s string, wordDict []string) bool {
	wordSet := make(map[string]bool) // 转成集合，查找 O(1)
	for _, w := range wordDict {
		wordSet[w] = true
	}
	n := len(s)
	dp := make([]bool, n+1)
	dp[0] = true // 空字符串可以被拆分
	for i := 1; i <= n; i++ {
		for j := 0; j < i; j++ {
			if dp[j] && wordSet[s[j:i]] {
				dp[i] = true
				break // 找到一种拆分方式就够了
			}
		}
	}
	return dp[n]
}

// ========== 8.6 不同路径（LeetCode 62） ==========
// dp[i][j] = 从(0,0)到(i,j)的路径数 = dp[i-1][j] + dp[i][j-1]
func uniquePaths(m, n int) int {
	dp := make([][]int, m)
	for i := range dp {
		dp[i] = make([]int, n)
		for j := range dp[i] {
			dp[i][j] = 1 // 第一行和第一列都只有1条路径
		}
	}
	for i := 1; i < m; i++ {
		for j := 1; j < n; j++ {
			dp[i][j] = dp[i-1][j] + dp[i][j-1] // 从上方来 + 从左方来
		}
	}
	return dp[m-1][n-1]
}

func testWordPath() {
	fmt.Println("===== 单词拆分 =====")
	fmt.Println(wordBreak("leetcode", []string{"leet", "code"}))                      // true
	fmt.Println(wordBreak("applepenapple", []string{"apple", "pen"}))                 // true
	fmt.Println(wordBreak("catsandog", []string{"cats", "dog", "sand", "and", "cat"})) // false
	fmt.Println("===== 不同路径 =====")
	fmt.Println(uniquePaths(3, 7)) // 28
	fmt.Println(uniquePaths(3, 2)) // 3
	fmt.Println(uniquePaths(7, 3)) // 28
}
```


### 主题19：图算法


#### 一、图的基础

##### 什么是图？

> **图 = 节点 + 边**。就像地图上的城市（节点）和公路（边）。

```python
# 图的表示方法

# 方法1：邻接表（最常用）
# 用字典，key是节点，value是相邻节点列表
graph_adj_list = {
    'A': ['B', 'C'],
    'B': ['A', 'D', 'E'],
    'C': ['A', 'F'],
    'D': ['B'],
    'E': ['B', 'F'],
    'F': ['C', 'E']
}

# 方法2：邻接矩阵
# 用二维数组，matrix[i][j]=1表示i和j之间有边
graph_adj_matrix = [
    [0, 1, 1, 0, 0, 0],  # A
    [1, 0, 0, 1, 1, 0],  # B
    [1, 0, 0, 0, 0, 1],  # C
    [0, 1, 0, 0, 0, 0],  # D
    [0, 1, 0, 0, 0, 1],  # E
    [0, 0, 1, 0, 1, 0],  # F
]

# 方法3：带权邻接表（边有权重时使用）
# value是 (相邻节点, 权重) 的列表
graph_weighted = {
    'A': [('B', 4), ('C', 2)],
    'B': [('A', 4), ('D', 3), ('E', 5)],
    'C': [('A', 2), ('F', 8)],
    'D': [('B', 3)],
    'E': [('B', 5), ('F', 1)],
    'F': [('C', 8), ('E', 1)]
}
```

---

#### 二、最短路径算法

##### 2.1 Dijkstra算法

###### 核心思想

> **贪心策略：每次选距离起点最近的未访问节点，然后用它更新邻居的距离。**

类比：你在一个陌生城市，想知道从酒店到每个景点的最短距离。你先看地图上离酒店最近的景点A，算出到A的最短距离。然后从A出发，看看能不能通过A更快地到达A的邻居们。接着在所有"已知距离但未探索"的景点中，选最近的B，再从B出发更新它的邻居...以此类推。

```python
import heapq

def dijkstra(graph, start):
    """
    Dijkstra算法 - 单源最短路径
    
    graph: 带权邻接表，graph[u] = [(v, weight), ...]
    start: 起始节点
    
    返回：从start到所有节点的最短距离
    
    算法步骤：
    1. 初始化：起点距离为0，其他所有点距离为无穷大
    2. 用优先队列（最小堆），每次取出距离最小的节点
    3. 对这个节点的每个邻居，检查"经过当前节点到邻居"是否更短
       如果更短，更新邻居的距离，并把邻居加入优先队列
    4. 重复直到优先队列为空
    
    注意：不能处理负权边！
    因为Dijkstra基于贪心，一旦节点被标记为"已确定最短距离"，
    就不会再更新。如果有负权边，后面可能出现更短的路径。
    """
    # dist[v] 表示从start到v的最短距离
    dist = {node: float('inf') for node in graph}
    dist[start] = 0
    
    # 优先队列：(距离, 节点)
    # Python的heapq是最小堆，每次取出距离最小的
    pq = [(0, start)]
    
    # 记录已确定最短距离的节点（可选，用于优化）
    visited = set()
    
    while pq:
        # 取出当前距离最小的节点
        d, u = heapq.heappop(pq)
        
        # 如果已经确定过，跳过（避免重复处理）
        if u in visited:
            continue
        visited.add(u)
        
        # 遍历u的所有邻居
        for v, weight in graph[u]:
            new_dist = d + weight
            # 如果经过u到v比已知的更短，更新
            if new_dist < dist[v]:
                dist[v] = new_dist
                heapq.heappush(pq, (new_dist, v))
    
    return dist

# 测试
graph = {
    'A': [('B', 4), ('C', 2)],
    'B': [('A', 4), ('D', 3), ('E', 5)],
    'C': [('A', 2), ('D', 1), ('F', 8)],
    'D': [('B', 3), ('C', 1), ('E', 1)],
    'E': [('B', 5), ('D', 1), ('F', 3)],
    'F': [('C', 8), ('E', 3)]
}

dist = dijkstra(graph, 'A')
print("从A出发到各点的最短距离：")
for node, d in dist.items():
    print(f"  A → {node}: {d}")
# A→A:0, A→B:4, A→C:2, A→D:3, A→E:4, A→F:7
```

###### 复杂度分析

```
时间复杂度：
  - 使用优先队列（最小堆）：O((V + E) log V)
    其中V是节点数，E是边数
  - 每个节点最多入堆一次O(log V)，每条边最多触发一次更新O(log E)
  
空间复杂度：O(V)

不能处理负权边！
  原因：Dijkstra是贪心算法，一旦节点出堆就认为距离确定了。
  如果后面有负权边，可能通过负权边到达已确定节点的路径更短，
  但Dijkstra不会回头更新。
```

###### 示例：网络延迟时间（LeetCode 743）

```python
def networkDelayTime(times: list[list[int]], n: int, k: int) -> int:
    """
    网络延迟时间
    
    题目：n个网络节点，给定有向边和传播时间，
    从节点k发出信号，多久能让所有节点都收到？
    如果不可能，返回-1。
    
    本质：求从k出发到所有节点的最短距离中的最大值。
    """
    # 构建邻接表
    graph = {i: [] for i in range(1, n + 1)}
    for u, v, w in times:
        graph[u].append((v, w))
    
    # Dijkstra
    dist = dijkstra(graph, k)
    
    # 找到最大距离
    max_dist = max(dist.values())
    return max_dist if max_dist != float('inf') else -1

# 测试
times = [[2, 1, 1], [2, 3, 1], [3, 4, 1]]
print(networkDelayTime(times, 4, 2))  # 输出: 2
```

##### 2.2 Bellman-Ford算法

###### 核心思想

> **对所有边进行V-1轮松弛操作。每轮遍历所有边，尝试缩短距离。**

类比：你和一群朋友在传话。每轮每个人都把自己的消息告诉朋友。经过V-1轮后，最远的消息也传到了。如果第V轮还有人收到新消息，说明有"负权环"（消息越传越短，无限循环）。

```python
def bellman_ford(n, edges, start):
    """
    Bellman-Ford算法 - 单源最短路径
    
    n: 节点数（节点编号0到n-1）
    edges: 边列表，每条边是 (起点, 终点, 权重)
    start: 起始节点
    
    算法步骤：
    1. 初始化：起点距离0，其他无穷大
    2. 重复V-1次：遍历所有边，尝试松弛
       松弛：如果 dist[u] + weight < dist[v]，就更新 dist[v]
    3. 再遍历一次所有边，如果还能松弛，说明有负权环
    
    为什么V-1次就够？
    最短路径最多经过V-1条边（没有环的话）。
    每轮至少能确定一条边的最短路径，所以V-1轮够了。
    """
    # 初始化距离
    dist = [float('inf')] * n
    dist[start] = 0
    
    # V-1轮松弛
    for i in range(n - 1):
        updated = False
        for u, v, w in edges:
            if dist[u] != float('inf') and dist[u] + w < dist[v]:
                dist[v] = dist[u] + w
                updated = True
        
        # 优化：如果这轮没有更新任何距离，提前结束
        if not updated:
            print(f"第{i+1}轮后提前收敛")
            break
    
    # 检测负权环：第V轮还能松弛说明有负权环
    for u, v, w in edges:
        if dist[u] != float('inf') and dist[u] + w < dist[v]:
            print("检测到负权环！")
            return None
    
    return dist

# 测试（含负权边）
n = 5
edges = [
    (0, 1, 6),    # 0→1 权重6
    (0, 2, 7),    # 0→2 权重7
    (1, 2, 8),    # 1→2 权重8
    (1, 3, 5),    # 1→3 权重5
    (1, 4, -4),   # 1→4 权重-4（负权边！）
    (2, 3, -3),   # 2→3 权重-3（负权边！）
    (2, 4, 9),    # 2→4 权重9
    (3, 1, -2),   # 3→1 权重-2（负权边！）
    (4, 0, 2),    # 4→0 权重2
    (4, 3, 7),    # 4→3 权重7
]

dist = bellman_ford(n, edges, 0)
print(f"从节点0出发到各点的最短距离: {dist}")
```

###### Dijkstra vs Bellman-Ford

| 对比 | Dijkstra | Bellman-Ford |
|------|----------|-------------|
| 时间复杂度 | O((V+E)logV) | O(V×E) |
| 负权边 | 不能处理 | 可以处理 |
| 负权环 | 无法检测 | 可以检测 |
| 实现方式 | 贪心+优先队列 | 松弛所有边V-1次 |
| 实际使用 | 大多数场景首选 | 有负权边时使用 |

##### 2.3 Floyd算法

###### 核心思想

> **动态规划：枚举所有可能的中间节点，尝试"经过中间节点"是否更短。**

类比：你想知道从北京到广州的最短路线。你不仅考虑直达路线，还考虑"经过上海"、"经过武汉"、"经过长沙"...所有可能的中转站。对每一对城市都这么做，最终得到所有城市之间的最短距离。

```python
def floyd(n, edges):
    """
    Floyd-Warshall算法 - 全源最短路径
    
    n: 节点数
    edges: 边列表，每条边是 (起点, 终点, 权重)
    
    返回：n×n的距离矩阵，dist[i][j] = 从i到j的最短距离
    
    算法核心（DP思想）：
    dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])
    对每个中间节点k，检查"i→k→j"是否比"i→j"更短
    
    三层循环：
    最外层：枚举中间节点k
    内两层：枚举所有节点对(i, j)
    """
    # 初始化距离矩阵
    dist = [[float('inf')] * n for _ in range(n)]
    
    # 自己到自己的距离为0
    for i in range(n):
        dist[i][i] = 0
    
    # 填入已知的边
    for u, v, w in edges:
        dist[u][v] = w  # 有向图；无向图需加 dist[v][u] = w
    
    # Floyd核心：枚举中间节点k
    for k in range(n):
        for i in range(n):
            for j in range(n):
                # 检查"i→k→j"是否比"i→j"更短
                if dist[i][k] + dist[k][j] < dist[i][j]:
                    dist[i][j] = dist[i][k] + dist[k][j]
    
    return dist

# 测试
n = 4
edges = [
    (0, 1, 3),
    (0, 3, 5),
    (1, 0, 2),
    (1, 2, 4),
    (2, 0, 1),
    (2, 3, 2),
    (3, 1, 6),
]

dist = floyd(n, edges)
print("全源最短路径矩阵：")
for i in range(n):
    print(f"  从节点{i}出发: {dist[i]}")
```

###### 复杂度与应用

```
时间复杂度：O(n³) —— 三层嵌套循环
空间复杂度：O(n²) —— 距离矩阵

优点：
  - 代码极其简洁（核心就3层循环）
  - 一次算出所有节点对之间的最短路径
  - 可以处理负权边（但不能有负权环）

缺点：
  - O(n³)太慢，节点多时不适用
  - 如果只需要单源最短路径，Dijkstra更高效

应用场景：
  - 节点数较少（n < 500）的全源最短路径
  - 传递闭包问题
  - 检测负权环
```

---

#### 三、最小生成树（MST）

> **最小生成树**：用最小的总代价把所有节点连起来，形成一棵树（无环、连通）。

类比：有5个城市要修公路互相连通，每两个城市之间修路的成本不同。问怎么修路能让所有城市都连通，且总成本最低。

##### 3.1 Kruskal算法

```python
class UnionFind:
    """
    并查集（Union-Find）
    用于Kruskal算法中判断两个节点是否已经连通。
    
    类比：每个人在一个小组里。
    - find：找到你所在小组的组长
    - union：把两个小组合并成一个
    - connected：判断两个人是否在同一个小组
    """
    def __init__(self, n):
        self.parent = list(range(n))  # 初始时每个人自己是自己的组长
        self.rank = [0] * n           # 树的深度（用于优化合并）
    
    def find(self, x):
        """找到x的组长（带路径压缩）"""
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])  # 路径压缩
        return self.parent[x]
    
    def union(self, x, y):
        """合并x和y所在的组（按秩合并）"""
        root_x = self.find(x)
        root_y = self.find(y)
        
        if root_x == root_y:
            return False  # 已经在同一组，不需要合并
        
        # 按秩合并：把矮的树挂到高的树下面
        if self.rank[root_x] < self.rank[root_y]:
            self.parent[root_x] = root_y
        elif self.rank[root_x] > self.rank[root_y]:
            self.parent[root_y] = root_x
        else:
            self.parent[root_y] = root_x
            self.rank[root_x] += 1
        
        return True
    
    def connected(self, x, y):
        """判断x和y是否在同一组"""
        return self.find(x) == self.find(y)


def kruskal(n, edges):
    """
    Kruskal算法 - 最小生成树
    
    n: 节点数
    edges: 边列表，每条边是 (权重, 起点, 终点)
    
    返回：最小生成树的边列表和总权重
    
    算法步骤：
    1. 把所有边按权重从小到大排序
    2. 从最小的边开始，如果这条边的两个端点不在同一连通分量中
       （即加上这条边不会形成环），就加入MST
    3. 重复直到选了n-1条边（或所有边都考虑完）
    
    类比：
    修路时，先修最便宜的路。如果这条路连接了两个还没连通的区域，就修。
    如果两个区域已经连通了（再修就成环了），就跳过。
    """
    # 按权重排序
    edges.sort()
    
    uf = UnionFind(n)
    mst = []
    total_weight = 0
    
    for weight, u, v in edges:
        # 如果u和v不在同一连通分量，加入这条边不会形成环
        if uf.union(u, v):
            mst.append((u, v, weight))
            total_weight += weight
            
            # MST有n-1条边就够了
            if len(mst) == n - 1:
                break
    
    return mst, total_weight

# 测试
n = 6
edges = [
    (4, 0, 1), (4, 0, 2), (6, 0, 3),
    (6, 1, 3), (3, 1, 4),
    (2, 2, 3), (5, 2, 5),
    (1, 3, 4), (8, 3, 5),
    (7, 4, 5),
]

mst, total = kruskal(n, edges)
print("Kruskal最小生成树：")
for u, v, w in mst:
    print(f"  {u} -- {v} (权重: {w})")
print(f"总权重: {total}")
```

###### 复杂度分析

```
时间复杂度：O(E log E)
  - 排序边：O(E log E)
  - 并查集操作：O(E × α(V)) ≈ O(E)（近似线性）
  - 总复杂度由排序决定：O(E log E)

空间复杂度：O(V + E)
```

##### 3.2 Prim算法

```python
def prim(n, graph):
    """
    Prim算法 - 最小生成树
    
    n: 节点数
    graph: 邻接表，graph[u] = [(v, weight), ...]
    
    返回：最小生成树的边列表和总权重
    
    算法步骤：
    1. 从任意节点开始（比如节点0），加入MST集合
    2. 在所有连接"MST集合内"和"MST集合外"的边中，选权重最小的
    3. 把选中的边的另一个端点加入MST集合
    4. 重复直到所有节点都在MST中
    
    类比：
    从一个城市开始铺电缆。每次选最近的还没连上的城市铺过去。
    就像Dijkstra，但Dijkstra选的是"离起点最近的"，
    Prim选的是"离已建网络最近的"。
    """
    # 用优先队列存储 (权重, 起点, 终点)
    mst = []
    total_weight = 0
    visited = [False] * n
    
    # 从节点0开始
    visited[0] = True
    # 把节点0的所有边加入优先队列
    edges = [(w, 0, v) for v, w in graph[0]]
    heapq.heapify(edges)
    
    while edges and len(mst) < n - 1:
        weight, u, v = heapq.heappop(edges)
        
        if visited[v]:
            continue  # 已经在MST中，跳过
        
        # 加入MST
        visited[v] = True
        mst.append((u, v, weight))
        total_weight += weight
        
        # 把v的所有边加入优先队列
        for next_v, w in graph[v]:
            if not visited[next_v]:
                heapq.heappush(edges, (w, v, next_v))
    
    return mst, total_weight

# 测试（无向图）
graph = {
    0: [(1, 4), (2, 4), (3, 6)],
    1: [(0, 4), (3, 6), (4, 3)],
    2: [(0, 4), (3, 2), (5, 5)],
    3: [(0, 6), (1, 6), (2, 2), (4, 1), (5, 8)],
    4: [(1, 3), (3, 1), (5, 7)],
    5: [(2, 5), (3, 8), (4, 7)],
}

mst, total = prim(6, graph)
print("\nPrim最小生成树：")
for u, v, w in mst:
    print(f"  {u} -- {v} (权重: {w})")
print(f"总权重: {total}")
```

###### Kruskal vs Prim

| 对比 | Kruskal | Prim |
|------|---------|------|
| 思路 | 按边权排序，从小到大加边 | 从一个点开始，逐步扩展 |
| 核心数据结构 | 并查集 | 优先队列 |
| 时间复杂度 | O(E log E) | O((V+E) log V) |
| 适合场景 | 稀疏图（边少） | 稠密图（边多） |
| 类比 | 在所有路中选最便宜的 | 从一座城开始，逐步铺路 |

##### 3.3 应用：连接所有城市的最低成本

```python
def minCostToConnectCities(n, connections):
    """
    连接所有城市的最低成本
    
    题目：n个城市，一些城市之间可以修路，每条路有成本。
    问最少花多少钱能让所有城市都连通？
    如果不可能，返回-1。
    
    本质就是最小生成树！
    """
    # 用Kruskal
    edges = [(w, u, v) for u, v, w in connections]
    mst, total = kruskal(n, edges)
    
    if len(mst) < n - 1:
        return -1  # 无法连通所有城市
    return total

# 测试
connections = [[0, 1, 1], [0, 2, 2], [1, 2, 3], [1, 3, 4]]
print(f"最低成本: {minCostToConnectCities(4, connections)}")  # 输出: 7
```

---

#### 四、拓扑排序

> **拓扑排序**：对有向无环图（DAG）的节点排成一个线性序列，使得对于每条边u→v，u都排在v前面。

类比：大学选课有先修要求。"数据结构"必须先修"编程基础"，"机器学习"必须先修"数据结构"。拓扑排序就是找出一个合理的修课顺序。

##### 4.1 Kahn算法（BFS实现）

```python
from collections import deque, defaultdict

def topologicalSort_kahn(n, edges):
    """
    拓扑排序 - Kahn算法（BFS）
    
    n: 节点数（0到n-1）
    edges: 有向边列表 [(u, v), ...]，表示u→v
    
    返回：拓扑排序结果，如果有环则返回空列表
    
    算法步骤：
    1. 计算每个节点的入度（有多少条边指向它）
    2. 把所有入度为0的节点加入队列（它们没有前置依赖）
    3. 从队列取出一个节点，加入结果
    4. 把它的所有邻居的入度减1（相当于"完成"了这门课，
       邻居的前置依赖少了一个）
    5. 如果邻居的入度变成0，加入队列
    6. 重复直到队列为空
    
    类比：
    你要完成一系列任务，有些任务有先后顺序。
    每次找一个"所有前置任务都已完成"的任务来做。
    做完后，看看有没有新任务的前置条件被满足了。
    """
    # 构建邻接表和入度数组
    adj = defaultdict(list)
    in_degree = [0] * n
    
    for u, v in edges:
        adj[u].append(v)
        in_degree[v] += 1  # v的入度+1（u指向v）
    
    # 把所有入度为0的节点加入队列
    queue = deque()
    for i in range(n):
        if in_degree[i] == 0:
            queue.append(i)
    
    result = []
    
    while queue:
        # 取出一个入度为0的节点
        u = queue.popleft()
        result.append(u)
        
        # 遍历u的所有邻居
        for v in adj[u]:
            in_degree[v] -= 1  # 入度减1
            if in_degree[v] == 0:
                queue.append(v)  # 入度变成0，可以"执行"了
    
    # 如果结果包含所有节点，说明没有环
    if len(result) == n:
        return result
    else:
        return []  # 有环，无法拓扑排序

# 测试：课程表
# 0: 编程基础, 1: 数据结构, 2: 算法, 3: 机器学习
# 先修关系：编程基础→数据结构→算法→机器学习
n = 4
edges = [(0, 1), (1, 2), (2, 3), (0, 2)]
order = topologicalSort_kahn(n, edges)
print(f"拓扑排序结果: {order}")  # [0, 1, 2, 3]
```

##### 4.2 DFS实现

```python
def topologicalSort_dfs(n, edges):
    """
    拓扑排序 - DFS实现
    
    思路：
    1. 对每个未访问的节点做DFS
    2. DFS到底后（所有子节点都处理完），把当前节点加入结果的前面
    3. 最终结果就是拓扑排序
    
    类比：
    你有一堆任务，每个任务依赖一些子任务。
    你先递归地把所有子任务做完，然后再做当前任务。
    最后完成的任务排在最前面。
    """
    adj = defaultdict(list)
    for u, v in edges:
        adj[u].append(v)
    
    visited = [False] * n
    result = []
    
    def dfs(u):
        visited[u] = True
        for v in adj[u]:
            if not visited[v]:
                dfs(v)
        # 所有子节点都处理完了，当前节点加入结果
        result.append(u)
    
    for i in range(n):
        if not visited[i]:
            dfs(i)
    
    result.reverse()  # 反转，因为最后完成的在前面
    
    if len(result) == n:
        return result
    else:
        return []  # 有环

# 测试
order = topologicalSort_dfs(n, edges)
print(f"DFS拓扑排序: {order}")
```

##### 4.3 应用：课程表问题（LeetCode 210）

```python
def findOrder(numCourses: int, prerequisites: list[list[int]]) -> list[int]:
    """
    课程表 II
    
    题目：你要上numCourses门课（编号0到numCourses-1），
    prerequisites[i] = [a, b] 表示上课程a之前必须先上课程b。
    返回一个合理的修课顺序，如果不可能就返回空数组。
    
    本质：拓扑排序！
    """
    # 构建邻接表和入度
    adj = defaultdict(list)
    in_degree = [0] * numCourses
    
    for course, prereq in prerequisites:
        adj[prereq].append(course)
        in_degree[course] += 1
    
    # Kahn算法
    queue = deque()
    for i in range(numCourses):
        if in_degree[i] == 0:
            queue.append(i)
    
    order = []
    while queue:
        course = queue.popleft()
        order.append(course)
        
        for next_course in adj[course]:
            in_degree[next_course] -= 1
            if in_degree[next_course] == 0:
                queue.append(next_course)
    
    if len(order) == numCourses:
        return order
    return []  # 有环，不可能完成

# 测试
print(findOrder(4, [[1, 0], [2, 0], [3, 1], [3, 2]]))
# 输出: [0, 1, 2, 3] 或 [0, 2, 1, 3]
```

---
---


### 主题19 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、图的基础：三种表示方法

```typescript
// ========== 图的三种表示方法 ==========
// 1. 邻接表（最常用）：Map，key是节点，value是相邻节点列表
const graphAdjList = new Map<string, string[]>([
    ["A", ["B", "C"]],
    ["B", ["A", "D", "E"]],
    ["C", ["A", "F"]],
    ["D", ["B"]],
    ["E", ["B", "F"]],
    ["F", ["C", "E"]],
]);

// 2. 邻接矩阵：二维数组，matrix[i][j] = 1 表示 i 和 j 之间有边
const graphAdjMatrix: number[][] = [
    [0, 1, 1, 0, 0, 0], // A
    [1, 0, 0, 1, 1, 0], // B
    [1, 0, 0, 0, 0, 1], // C
    [0, 1, 0, 0, 0, 0], // D
    [0, 1, 0, 0, 0, 1], // E
    [0, 0, 1, 0, 1, 0], // F
];

// 3. 带权邻接表：value 是 (相邻节点, 权重) 的列表
const graphWeighted = new Map<string, Array<[string, number]>>([
    ["A", [["B", 4], ["C", 2]]],
    ["B", [["A", 4], ["D", 3], ["E", 5]]],
    ["C", [["A", 2], ["F", 8]]],
    ["D", [["B", 3]]],
    ["E", [["B", 5], ["F", 1]]],
    ["F", [["C", 8], ["E", 1]]],
]);
console.log("图的三种表示方法定义完成（邻接表/邻接矩阵/带权邻接表）");
```

##### 二、最短路径：Dijkstra 与网络延迟时间

```typescript
// ========== 2.1 Dijkstra算法 - 单源最短路径 ==========
// 贪心策略：每次选距离起点最近的未访问节点，然后更新它的邻居
function dijkstra(graph: Map<string, Array<[string, number]>>, start: string): Map<string, number> {
    const dist = new Map<string, number>();
    for (const node of graph.keys()) dist.set(node, Infinity);
    dist.set(start, 0);

    // 用数组模拟优先队列（最小堆），元素是 [距离, 节点]
    const pq: Array<[number, string]> = [[0, start]];
    const visited = new Set<string>();

    while (pq.length > 0) {
        pq.sort((a, b) => a[0] - b[0]); // 每次取距离最小的
        const [d, u] = pq.shift()!;
        if (visited.has(u)) continue; // 已经确定过
        visited.add(u);

        for (const [v, weight] of graph.get(u) ?? []) {
            const newDist = d + weight;
            if (newDist < dist.get(v)!) {
                dist.set(v, newDist);
                pq.push([newDist, v]);
            }
        }
    }
    return dist;
}

// 测试（与 Python 相同的图）
const graph19 = new Map<string, Array<[string, number]>>([
    ["A", [["B", 4], ["C", 2]]],
    ["B", [["A", 4], ["D", 3], ["E", 5]]],
    ["C", [["A", 2], ["D", 1], ["F", 8]]],
    ["D", [["B", 3], ["C", 1], ["E", 1]]],
    ["E", [["B", 5], ["D", 1], ["F", 3]]],
    ["F", [["C", 8], ["E", 3]]],
]);
const dist19 = dijkstra(graph19, "A");
console.log("从A出发到各点的最短距离：");
for (const [node, d] of dist19) {
    console.log(`  A → ${node}: ${d}`);
}
// A→A:0, A→B:4, A→C:2, A→D:3, A→E:4, A→F:7

// ========== 网络延迟时间（LeetCode 743） ==========
// 求从 k 出发到所有节点的最短距离中的最大值
function dijkstraNumber(graph: Map<number, Array<[number, number]>>, start: number): Map<number, number> {
    const dist = new Map<number, number>();
    for (const node of graph.keys()) dist.set(node, Infinity);
    dist.set(start, 0);

    const pq: Array<[number, number]> = [[0, start]];
    const visited = new Set<number>();

    while (pq.length > 0) {
        pq.sort((a, b) => a[0] - b[0]);
        const [d, u] = pq.shift()!;
        if (visited.has(u)) continue;
        visited.add(u);

        for (const [v, weight] of graph.get(u) ?? []) {
            const newDist = d + weight;
            if (newDist < dist.get(v)!) {
                dist.set(v, newDist);
                pq.push([newDist, v]);
            }
        }
    }
    return dist;
}

function networkDelayTime(times: number[][], n: number, k: number): number {
    // 构建邻接表
    const graph = new Map<number, Array<[number, number]>>();
    for (let i = 1; i <= n; i++) graph.set(i, []);
    for (const [u, v, w] of times) {
        graph.get(u)!.push([v, w]);
    }
    // 从 k 出发做 Dijkstra
    const dist = dijkstraNumber(graph, k);
    // 找到最大距离；有节点不可达返回 -1
    let maxDist = 0;
    for (let i = 1; i <= n; i++) {
        const d = dist.get(i)!;
        if (d === Infinity) return -1;
        maxDist = Math.max(maxDist, d);
    }
    return maxDist;
}
console.log(`网络延迟时间: ${networkDelayTime([[2, 1, 1], [2, 3, 1], [3, 4, 1]], 4, 2)}`); // 2
```

##### 二、最短路径：Bellman-Ford 与 Floyd

```typescript
// ========== 2.2 Bellman-Ford算法 - 单源最短路径 ==========
// 对所有边进行 V-1 轮松弛；第 V 轮还能松弛说明有负权环
function bellmanFord(n: number, edges: Array<[number, number, number]>, start: number): number[] | null {
    // dist[v] 表示从 start 到 v 的最短距离
    const dist = new Array<number>(n).fill(Infinity);
    dist[start] = 0;

    // V-1 轮松弛
    for (let i = 0; i < n - 1; i++) {
        let updated = false;
        for (const [u, v, w] of edges) {
            if (dist[u] !== Infinity && dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w;
                updated = true;
            }
        }
        if (!updated) break; // 优化：本轮无更新，提前收敛
    }

    // 检测负权环
    for (const [u, v, w] of edges) {
        if (dist[u] !== Infinity && dist[u] + w < dist[v]) {
            return null; // 有负权环
        }
    }
    return dist;
}

// 测试（含负权边）
const edgesBF: Array<[number, number, number]> = [
    [0, 1, 6], [0, 2, 7], [1, 2, 8], [1, 3, 5], [1, 4, -4],
    [2, 3, -3], [2, 4, 9], [3, 1, -2], [4, 0, 2], [4, 3, 7],
];
const distBF = bellmanFord(5, edgesBF, 0);
console.log(`Bellman-Ford 从节点0出发: ${distBF}`);

// ========== 2.3 Floyd算法 - 全源最短路径 ==========
// DP思想：dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])
function floyd(n: number, edges: Array<[number, number, number]>): number[][] {
    // 初始化距离矩阵
    const dist = Array.from({ length: n }, () => new Array<number>(n).fill(Infinity));
    for (let i = 0; i < n; i++) dist[i][i] = 0; // 自己到自己为0
    for (const [u, v, w] of edges) dist[u][v] = w; // 填入已知边

    // Floyd核心：枚举中间节点 k
    for (let k = 0; k < n; k++) {
        for (let i = 0; i < n; i++) {
            for (let j = 0; j < n; j++) {
                // 检查"i→k→j"是否比"i→j"更短
                if (dist[i][k] + dist[k][j] < dist[i][j]) {
                    dist[i][j] = dist[i][k] + dist[k][j];
                }
            }
        }
    }
    return dist;
}

// 测试
const edgesFloyd: Array<[number, number, number]> = [
    [0, 1, 3], [0, 3, 5], [1, 0, 2], [1, 2, 4],
    [2, 0, 1], [2, 3, 2], [3, 1, 6],
];
const distFloyd = floyd(4, edgesFloyd);
console.log("全源最短路径矩阵：");
for (let i = 0; i < 4; i++) {
    console.log(`  从节点${i}出发: ${distFloyd[i]}`);
}
```

##### 三、最小生成树：Kruskal

```typescript
// ========== 并查集（用于Kruskal判断是否成环） ==========
class UnionFindMST {
    parent: number[];
    rank: number[];

    constructor(n: number) {
        this.parent = Array.from({ length: n }, (_, i) => i);
        this.rank = new Array<number>(n).fill(0);
    }

    find(x: number): number {
        if (this.parent[x] !== x) {
            this.parent[x] = this.find(this.parent[x]); // 路径压缩
        }
        return this.parent[x];
    }

    union(x: number, y: number): boolean {
        const rx = this.find(x);
        const ry = this.find(y);
        if (rx === ry) return false; // 已连通，加边会成环

        // 按秩合并
        if (this.rank[rx] < this.rank[ry]) {
            this.parent[rx] = ry;
        } else if (this.rank[rx] > this.rank[ry]) {
            this.parent[ry] = rx;
        } else {
            this.parent[ry] = rx;
            this.rank[rx]++;
        }
        return true;
    }
}

// ========== 3.1 Kruskal算法 - 最小生成树 ==========
// 把所有边按权重排序，从最小的开始，不成环就加入MST
function kruskal(n: number, edges: Array<[number, number, number]>): { mst: Array<[number, number, number]>; total: number } {
    edges.sort((a, b) => a[0] - b[0]); // 按权重从小到大排序
    const uf = new UnionFindMST(n);
    const mst: Array<[number, number, number]> = [];
    let total = 0;

    for (const [weight, u, v] of edges) {
        if (uf.union(u, v)) {
            mst.push([u, v, weight]);
            total += weight;
            if (mst.length === n - 1) break; // MST有n-1条边就够了
        }
    }
    return { mst, total };
}

// 测试
const edgesKruskal: Array<[number, number, number]> = [
    [4, 0, 1], [4, 0, 2], [6, 0, 3], [6, 1, 3], [3, 1, 4],
    [2, 2, 3], [5, 2, 5], [1, 3, 4], [8, 3, 5], [7, 4, 5],
];
const { mst: mstK, total: totalK } = kruskal(6, [...edgesKruskal]);
console.log("Kruskal最小生成树：");
for (const [u, v, w] of mstK) {
    console.log(`  ${u} -- ${v} (权重: ${w})`);
}
console.log(`总权重: ${totalK}`);
```

##### 三、最小生成树：Prim 与连接城市

```typescript
// ========== 3.2 Prim算法 - 最小生成树 ==========
// 从任意节点开始，每次选连接"MST集合内"和"集合外"的权重最小边
function prim(n: number, graph: Map<number, Array<[number, number]>>): { mst: Array<[number, number, number]>; total: number } {
    const mst: Array<[number, number, number]> = [];
    let total = 0;
    const visited = new Array<boolean>(n).fill(false);

    visited[0] = true; // 从节点0开始
    // 优先队列存 [权重, 起点, 终点]
    const pq: Array<[number, number, number]> = [];
    for (const [v, w] of graph.get(0) ?? []) pq.push([w, 0, v]);
    pq.sort((a, b) => a[0] - b[0]);

    while (pq.length > 0 && mst.length < n - 1) {
        pq.sort((a, b) => a[0] - b[0]);
        const [weight, u, v] = pq.shift()!;
        if (visited[v]) continue; // 已经在MST中

        visited[v] = true;
        mst.push([u, v, weight]);
        total += weight;

        for (const [nextV, w] of graph.get(v) ?? []) {
            if (!visited[nextV]) pq.push([w, v, nextV]);
        }
    }
    return { mst, total };
}

// 测试（无向图）
const graphPrim = new Map<number, Array<[number, number]>>([
    [0, [[1, 4], [2, 4], [3, 6]]],
    [1, [[0, 4], [3, 6], [4, 3]]],
    [2, [[0, 4], [3, 2], [5, 5]]],
    [3, [[0, 6], [1, 6], [2, 2], [4, 1], [5, 8]]],
    [4, [[1, 3], [3, 1], [5, 7]]],
    [5, [[2, 5], [3, 8], [4, 7]]],
]);
const { mst: mstP, total: totalP } = prim(6, graphPrim);
console.log("Prim最小生成树：");
for (const [u, v, w] of mstP) {
    console.log(`  ${u} -- ${v} (权重: ${w})`);
}
console.log(`总权重: ${totalP}`);

// ========== 3.3 连接所有城市的最低成本 ==========
// 本质就是最小生成树
function minCostToConnectCities(n: number, connections: number[][]): number {
    const edges: Array<[number, number, number]> = connections.map(([u, v, w]) => [w, u, v]);
    const { mst, total } = kruskal(n, edges);
    return mst.length < n - 1 ? -1 : total; // 边不够n-1条说明无法连通
}
console.log(`最低成本: ${minCostToConnectCities(4, [[0, 1, 1], [0, 2, 2], [1, 2, 3], [1, 3, 4]])}`); // 7
```

##### 四、拓扑排序：Kahn 与 DFS

```typescript
// ========== 4.1 拓扑排序 - Kahn算法（BFS） ==========
// 每次取出入度为0的节点（没有前置依赖），然后更新邻居入度
function topologicalSortKahn(n: number, edges: Array<[number, number]>): number[] {
    // 构建邻接表和入度数组
    const adj: number[][] = Array.from({ length: n }, () => []);
    const inDegree = new Array<number>(n).fill(0);
    for (const [u, v] of edges) {
        adj[u].push(v);
        inDegree[v]++; // v 的入度+1（u指向v）
    }

    // 所有入度为0的节点入队
    const queue: number[] = [];
    for (let i = 0; i < n; i++) {
        if (inDegree[i] === 0) queue.push(i);
    }

    const result: number[] = [];
    while (queue.length > 0) {
        const u = queue.shift()!;
        result.push(u);
        for (const v of adj[u]) {
            inDegree[v]--;
            if (inDegree[v] === 0) queue.push(v); // 入度变0，可以"执行"了
        }
    }
    // 结果包含所有节点说明无环
    return result.length === n ? result : [];
}

// ========== 4.2 拓扑排序 - DFS实现 ==========
// 递归处理完所有子节点后，把当前节点加入结果，最后反转
function topologicalSortDfs(n: number, edges: Array<[number, number]>): number[] {
    const adj: number[][] = Array.from({ length: n }, () => []);
    for (const [u, v] of edges) adj[u].push(v);

    const visited = new Array<boolean>(n).fill(false);
    const result: number[] = [];

    const dfs = (u: number): void => {
        visited[u] = true;
        for (const v of adj[u]) {
            if (!visited[v]) dfs(v);
        }
        result.push(u); // 子节点处理完，当前节点入结果
    };

    for (let i = 0; i < n; i++) {
        if (!visited[i]) dfs(i);
    }
    result.reverse(); // 反转才是拓扑排序
    return result.length === n ? result : [];
}

// 测试：课程表
// 0: 编程基础, 1: 数据结构, 2: 算法, 3: 机器学习
const edgesTopo: Array<[number, number]> = [[0, 1], [1, 2], [2, 3], [0, 2]];
console.log(`Kahn拓扑排序: ${topologicalSortKahn(4, edgesTopo)}`); // [0, 1, 2, 3]
console.log(`DFS拓扑排序: ${topologicalSortDfs(4, edgesTopo)}`);   // [0, 1, 2, 3]
```

##### 四、拓扑排序：课程表 II（LeetCode 210）

```typescript
// ========== 课程表 II（LeetCode 210） ==========
// prerequisites[i] = [a, b] 表示上课程a之前必须先上课程b
// 本质：拓扑排序！
function findOrder(numCourses: number, prerequisites: number[][]): number[] {
    // 构建邻接表和入度
    const adj: number[][] = Array.from({ length: numCourses }, () => []);
    const inDegree = new Array<number>(numCourses).fill(0);
    for (const [course, prereq] of prerequisites) {
        adj[prereq].push(course);
        inDegree[course]++;
    }

    // Kahn算法
    const queue: number[] = [];
    for (let i = 0; i < numCourses; i++) {
        if (inDegree[i] === 0) queue.push(i);
    }

    const order: number[] = [];
    while (queue.length > 0) {
        const course = queue.shift()!;
        order.push(course);
        for (const nextCourse of adj[course]) {
            inDegree[nextCourse]--;
            if (inDegree[nextCourse] === 0) queue.push(nextCourse);
        }
    }
    return order.length === numCourses ? order : []; // 有环，不可能完成
}

console.log(`课程表顺序: ${findOrder(4, [[1, 0], [2, 0], [3, 1], [3, 2]])}`);
// [0, 1, 2, 3] 或 [0, 2, 1, 3]
console.log(`有环的课程表: ${findOrder(2, [[1, 0], [0, 1]])}`); // []
```


### 主题19 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、图的基础：三种表示方法

```go
package main

import "fmt"

// ========== 图的三种表示方法 ==========

// 1. 邻接表（最常用）：map，key是节点，value是相邻节点列表
var graphAdjList = map[string][]string{
	"A": {"B", "C"},
	"B": {"A", "D", "E"},
	"C": {"A", "F"},
	"D": {"B"},
	"E": {"B", "F"},
	"F": {"C", "E"},
}

// 2. 邻接矩阵：二维数组，matrix[i][j] = 1 表示 i 和 j 之间有边
var graphAdjMatrix = [][]int{
	{0, 1, 1, 0, 0, 0}, // A
	{1, 0, 0, 1, 1, 0}, // B
	{1, 0, 0, 0, 0, 1}, // C
	{0, 1, 0, 0, 0, 0}, // D
	{0, 1, 0, 0, 0, 1}, // E
	{0, 0, 1, 0, 1, 0}, // F
}

// 3. 带权邻接表：value 是 (相邻节点, 权重) 的列表
var graphWeighted = map[string][][2]interface{}{
	"A": {{"B", 4}, {"C", 2}},
	"B": {{"A", 4}, {"D", 3}, {"E", 5}},
	"C": {{"A", 2}, {"F", 8}},
	"D": {{"B", 3}},
	"E": {{"B", 5}, {"F", 1}},
	"F": {{"C", 8}, {"E", 1}},
}

func testGraphBase() {
	fmt.Println("图的三种表示方法定义完成（邻接表/邻接矩阵/带权邻接表）")
}
```

##### 二、最短路径：Dijkstra 与网络延迟时间

```go
package main

import (
	"fmt"
	"math"
	"sort"
)

// ========== 2.1 Dijkstra算法 - 单源最短路径 ==========
// 贪心策略：每次选距离起点最近的未访问节点，然后更新它的邻居

// 优先队列项（字符串节点版）
type PQItemStr struct {
	dist int
	node string
}

func dijkstra(graph map[string][][2]interface{}, start string) map[string]int {
	// 初始化距离
	dist := make(map[string]int)
	for node := range graph {
		dist[node] = math.MaxInt32
	}
	dist[start] = 0

	// 用 slice 模拟优先队列
	pq := []PQItemStr{{0, start}}
	visited := make(map[string]bool)

	for len(pq) > 0 {
		// 每次取距离最小的
		sort.Slice(pq, func(i, j int) bool { return pq[i].dist < pq[j].dist })
		item := pq[0]
		pq = pq[1:]
		u, d := item.node, item.dist

		if visited[u] {
			continue // 已经确定过
		}
		visited[u] = true

		for _, e := range graph[u] {
			v := e[0].(string)
			weight := e[1].(int)
			newDist := d + weight
			if newDist < dist[v] {
				dist[v] = newDist
				pq = append(pq, PQItemStr{newDist, v})
			}
		}
	}
	return dist
}

func testDijkstra() {
	fmt.Println("===== Dijkstra 最短路径 =====")
	graph := map[string][][2]interface{}{
		"A": {{"B", 4}, {"C", 2}},
		"B": {{"A", 4}, {"D", 3}, {"E", 5}},
		"C": {{"A", 2}, {"D", 1}, {"F", 8}},
		"D": {{"B", 3}, {"C", 1}, {"E", 1}},
		"E": {{"B", 5}, {"D", 1}, {"F", 3}},
		"F": {{"C", 8}, {"E", 3}},
	}
	dist := dijkstra(graph, "A")
	fmt.Println("从A出发到各点的最短距离：")
	for node, d := range dist {
		fmt.Printf("  A → %s: %d\n", node, d)
	}
	// A→A:0, A→B:4, A→C:2, A→D:3, A→E:4, A→F:7
}

// ========== 网络延迟时间（LeetCode 743） ==========
// 求从 k 出发到所有节点的最短距离中的最大值
type PQItemInt struct {
	dist int
	node int
}

func dijkstraInt(graph map[int][][2]int, start int) map[int]int {
	dist := make(map[int]int)
	for node := range graph {
		dist[node] = math.MaxInt32
	}
	dist[start] = 0

	pq := []PQItemInt{{0, start}}
	visited := make(map[int]bool)

	for len(pq) > 0 {
		sort.Slice(pq, func(i, j int) bool { return pq[i].dist < pq[j].dist })
		item := pq[0]
		pq = pq[1:]
		u, d := item.node, item.dist

		if visited[u] {
			continue
		}
		visited[u] = true

		for _, e := range graph[u] {
			v, weight := e[0], e[1]
			newDist := d + weight
			if newDist < dist[v] {
				dist[v] = newDist
				pq = append(pq, PQItemInt{newDist, v})
			}
		}
	}
	return dist
}

func networkDelayTime(times [][]int, n, k int) int {
	// 构建邻接表
	graph := make(map[int][][2]int)
	for i := 1; i <= n; i++ {
		graph[i] = [][2]int{}
	}
	for _, t := range times {
		u, v, w := t[0], t[1], t[2]
		graph[u] = append(graph[u], [2]int{v, w})
	}

	dist := dijkstraInt(graph, k)
	maxDist := 0
	for i := 1; i <= n; i++ {
		if dist[i] == math.MaxInt32 {
			return -1 // 有节点不可达
		}
		if dist[i] > maxDist {
			maxDist = dist[i]
		}
	}
	return maxDist
}

func testNetworkDelay() {
	fmt.Printf("网络延迟时间: %d\n", networkDelayTime([][]int{{2, 1, 1}, {2, 3, 1}, {3, 4, 1}}, 4, 2)) // 2
}
```

##### 二、最短路径：Bellman-Ford 与 Floyd

```go
package main

import (
	"fmt"
	"math"
)

// ========== 2.2 Bellman-Ford算法 - 单源最短路径 ==========
// 对所有边进行 V-1 轮松弛；第 V 轮还能松弛说明有负权环
func bellmanFord(n int, edges [][3]int, start int) []int {
	dist := make([]int, n)
	for i := range dist {
		dist[i] = math.MaxInt32
	}
	dist[start] = 0

	// V-1 轮松弛
	for i := 0; i < n-1; i++ {
		updated := false
		for _, e := range edges {
			u, v, w := e[0], e[1], e[2]
			if dist[u] != math.MaxInt32 && dist[u]+w < dist[v] {
				dist[v] = dist[u] + w
				updated = true
			}
		}
		if !updated {
			break // 优化：本轮无更新，提前收敛
		}
	}

	// 检测负权环
	for _, e := range edges {
		u, v, w := e[0], e[1], e[2]
		if dist[u] != math.MaxInt32 && dist[u]+w < dist[v] {
			return nil // 有负权环
		}
	}
	return dist
}

func testBellmanFord() {
	fmt.Println("===== Bellman-Ford 最短路径（含负权边）=====")
	edges := [][3]int{
		{0, 1, 6}, {0, 2, 7}, {1, 2, 8}, {1, 3, 5}, {1, 4, -4},
		{2, 3, -3}, {2, 4, 9}, {3, 1, -2}, {4, 0, 2}, {4, 3, 7},
	}
	dist := bellmanFord(5, edges, 0)
	fmt.Printf("从节点0出发: %v\n", dist)
}

// ========== 2.3 Floyd算法 - 全源最短路径 ==========
// DP思想：dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])
func floyd(n int, edges [][3]int) [][]int {
	// 初始化距离矩阵
	dist := make([][]int, n)
	for i := range dist {
		dist[i] = make([]int, n)
		for j := range dist[i] {
			if i == j {
				dist[i][j] = 0 // 自己到自己为0
			} else {
				dist[i][j] = math.MaxInt32
			}
		}
	}
	for _, e := range edges {
		u, v, w := e[0], e[1], e[2]
		dist[u][v] = w // 填入已知边
	}

	// Floyd核心：枚举中间节点 k
	for k := 0; k < n; k++ {
		for i := 0; i < n; i++ {
			for j := 0; j < n; j++ {
				if dist[i][k]+dist[k][j] < dist[i][j] {
					dist[i][j] = dist[i][k] + dist[k][j]
				}
			}
		}
	}
	return dist
}

func testFloyd() {
	fmt.Println("===== Floyd 全源最短路径 =====")
	edges := [][3]int{
		{0, 1, 3}, {0, 3, 5}, {1, 0, 2}, {1, 2, 4},
		{2, 0, 1}, {2, 3, 2}, {3, 1, 6},
	}
	dist := floyd(4, edges)
	fmt.Println("全源最短路径矩阵：")
	for i := 0; i < 4; i++ {
		fmt.Printf("  从节点%d出发: %v\n", i, dist[i])
	}
}
```

##### 三、最小生成树：Kruskal

```go
package main

import (
	"fmt"
	"sort"
)

// ========== 并查集（用于Kruskal判断是否成环） ==========
type UnionFindMST struct {
	parent []int
	rank   []int
}

func NewUnionFindMST(n int) *UnionFindMST {
	parent := make([]int, n)
	rank := make([]int, n)
	for i := range parent {
		parent[i] = i
	}
	return &UnionFindMST{parent: parent, rank: rank}
}

func (uf *UnionFindMST) find(x int) int {
	if uf.parent[x] != x {
		uf.parent[x] = uf.find(uf.parent[x]) // 路径压缩
	}
	return uf.parent[x]
}

func (uf *UnionFindMST) union(x, y int) bool {
	rx, ry := uf.find(x), uf.find(y)
	if rx == ry {
		return false // 已连通，加边会成环
	}
	// 按秩合并
	if uf.rank[rx] < uf.rank[ry] {
		uf.parent[rx] = ry
	} else if uf.rank[rx] > uf.rank[ry] {
		uf.parent[ry] = rx
	} else {
		uf.parent[ry] = rx
		uf.rank[rx]++
	}
	return true
}

// ========== 3.1 Kruskal算法 - 最小生成树 ==========
// 把所有边按权重排序，从最小的开始，不成环就加入MST
// 边的表示：[权重, 起点, 终点]
func kruskal(n int, edges [][3]int) ([][3]int, int) {
	// 按权重从小到大排序
	sort.Slice(edges, func(i, j int) bool { return edges[i][0] < edges[j][0] })
	uf := NewUnionFindMST(n)
	mst := [][3]int{}
	total := 0

	for _, e := range edges {
		weight, u, v := e[0], e[1], e[2]
		if uf.union(u, v) {
			mst = append(mst, [3]int{u, v, weight})
			total += weight
			if len(mst) == n-1 {
				break // MST有n-1条边就够了
			}
		}
	}
	return mst, total
}

func testKruskal() {
	fmt.Println("===== Kruskal 最小生成树 =====")
	edges := [][3]int{
		{4, 0, 1}, {4, 0, 2}, {6, 0, 3}, {6, 1, 3}, {3, 1, 4},
		{2, 2, 3}, {5, 2, 5}, {1, 3, 4}, {8, 3, 5}, {7, 4, 5},
	}
	mst, total := kruskal(6, edges)
	fmt.Println("Kruskal最小生成树：")
	for _, e := range mst {
		fmt.Printf("  %d -- %d (权重: %d)\n", e[0], e[1], e[2])
	}
	fmt.Printf("总权重: %d\n", total)
}
```

##### 三、最小生成树：Prim 与连接城市

```go
package main

import (
	"fmt"
	"sort"
)

// ========== 3.2 Prim算法 - 最小生成树 ==========
// 从任意节点开始，每次选连接"MST集合内"和"集合外"的权重最小边
// 优先队列项：{权重, 起点, 终点}
func prim(n int, graph map[int][][2]int) ([][3]int, int) {
	mst := [][3]int{}
	total := 0
	visited := make([]bool, n)

	visited[0] = true // 从节点0开始
	pq := [][3]int{}  // {权重, 起点, 终点}
	for _, e := range graph[0] {
		pq = append(pq, [3]int{e[1], 0, e[0]})
	}

	for len(pq) > 0 && len(mst) < n-1 {
		sort.Slice(pq, func(i, j int) bool { return pq[i][0] < pq[j][0] })
		item := pq[0]
		pq = pq[1:]
		weight, u, v := item[0], item[1], item[2]

		if visited[v] {
			continue // 已经在MST中
		}
		visited[v] = true
		mst = append(mst, [3]int{u, v, weight})
		total += weight

		for _, e := range graph[v] {
			nextV, w := e[0], e[1]
			if !visited[nextV] {
				pq = append(pq, [3]int{w, v, nextV})
			}
		}
	}
	return mst, total
}

func testPrim() {
	fmt.Println("===== Prim 最小生成树 =====")
	graph := map[int][][2]int{
		0: {{1, 4}, {2, 4}, {3, 6}},
		1: {{0, 4}, {3, 6}, {4, 3}},
		2: {{0, 4}, {3, 2}, {5, 5}},
		3: {{0, 6}, {1, 6}, {2, 2}, {4, 1}, {5, 8}},
		4: {{1, 3}, {3, 1}, {5, 7}},
		5: {{2, 5}, {3, 8}, {4, 7}},
	}
	mst, total := prim(6, graph)
	fmt.Println("Prim最小生成树：")
	for _, e := range mst {
		fmt.Printf("  %d -- %d (权重: %d)\n", e[0], e[1], e[2])
	}
	fmt.Printf("总权重: %d\n", total)
}

// ========== 3.3 连接所有城市的最低成本 ==========
// 本质就是最小生成树
func minCostToConnectCities(n int, connections [][]int) int {
	edges := make([][3]int, len(connections))
	for i, c := range connections {
		u, v, w := c[0], c[1], c[2]
		edges[i] = [3]int{w, u, v}
	}
	mst, total := kruskal(n, edges)
	if len(mst) < n-1 {
		return -1 // 无法连通所有城市
	}
	return total
}

func testConnectCities() {
	fmt.Printf("最低成本: %d\n", minCostToConnectCities(4, [][]int{{0, 1, 1}, {0, 2, 2}, {1, 2, 3}, {1, 3, 4}})) // 7
}
```

##### 四、拓扑排序：Kahn 与 DFS

```go
package main

import "fmt"

// ========== 4.1 拓扑排序 - Kahn算法（BFS） ==========
// 每次取出入度为0的节点（没有前置依赖），然后更新邻居入度
func topologicalSortKahn(n int, edges [][2]int) []int {
	// 构建邻接表和入度数组
	adj := make([][]int, n)
	inDegree := make([]int, n)
	for _, e := range edges {
		u, v := e[0], e[1]
		adj[u] = append(adj[u], v)
		inDegree[v]++ // v 的入度+1（u指向v）
	}

	// 所有入度为0的节点入队
	queue := []int{}
	for i := 0; i < n; i++ {
		if inDegree[i] == 0 {
			queue = append(queue, i)
		}
	}

	result := []int{}
	for len(queue) > 0 {
		u := queue[0]
		queue = queue[1:]
		result = append(result, u)
		for _, v := range adj[u] {
			inDegree[v]--
			if inDegree[v] == 0 {
				queue = append(queue, v) // 入度变0，可以"执行"了
			}
		}
	}
	if len(result) == n {
		return result // 无环
	}
	return []int{} // 有环
}

// ========== 4.2 拓扑排序 - DFS实现 ==========
// 递归处理完所有子节点后，把当前节点加入结果，最后反转
func topologicalSortDfs(n int, edges [][2]int) []int {
	adj := make([][]int, n)
	for _, e := range edges {
		adj[e[0]] = append(adj[e[0]], e[1])
	}

	visited := make([]bool, n)
	result := []int{}

	var dfs func(u int)
	dfs = func(u int) {
		visited[u] = true
		for _, v := range adj[u] {
			if !visited[v] {
				dfs(v)
			}
		}
		result = append(result, u) // 子节点处理完，当前节点入结果
	}

	for i := 0; i < n; i++ {
		if !visited[i] {
			dfs(i)
		}
	}
	// 反转才是拓扑排序
	for i, j := 0, len(result)-1; i < j; i, j = i+1, j-1 {
		result[i], result[j] = result[j], result[i]
	}
	if len(result) == n {
		return result
	}
	return []int{}
}

func testTopology() {
	fmt.Println("===== 拓扑排序 =====")
	// 0: 编程基础, 1: 数据结构, 2: 算法, 3: 机器学习
	edges := [][2]int{{0, 1}, {1, 2}, {2, 3}, {0, 2}}
	fmt.Printf("Kahn拓扑排序: %v\n", topologicalSortKahn(4, edges)) // [0 1 2 3]
	fmt.Printf("DFS拓扑排序: %v\n", topologicalSortDfs(4, edges))   // [0 1 2 3]
}
```

##### 四、拓扑排序：课程表 II（LeetCode 210）

```go
package main

import "fmt"

// ========== 课程表 II（LeetCode 210） ==========
// prerequisites[i] = [a, b] 表示上课程a之前必须先上课程b
// 本质：拓扑排序！
func findOrder(numCourses int, prerequisites [][]int) []int {
	// 构建邻接表和入度
	adj := make([][]int, numCourses)
	inDegree := make([]int, numCourses)
	for _, p := range prerequisites {
		course, prereq := p[0], p[1]
		adj[prereq] = append(adj[prereq], course)
		inDegree[course]++
	}

	// Kahn算法
	queue := []int{}
	for i := 0; i < numCourses; i++ {
		if inDegree[i] == 0 {
			queue = append(queue, i)
		}
	}

	order := []int{}
	for len(queue) > 0 {
		course := queue[0]
		queue = queue[1:]
		order = append(order, course)
		for _, nextCourse := range adj[course] {
			inDegree[nextCourse]--
			if inDegree[nextCourse] == 0 {
				queue = append(queue, nextCourse)
			}
		}
	}
	if len(order) == numCourses {
		return order
	}
	return []int{} // 有环，不可能完成
}

func testCourseSchedule() {
	fmt.Printf("课程表顺序: %v\n", findOrder(4, [][]int{{1, 0}, {2, 0}, {3, 1}, {3, 2}}))
	// [0 1 2 3] 或 [0 2 1 3]
	fmt.Printf("有环的课程表: %v\n", findOrder(2, [][]int{{1, 0}, {0, 1}})) // []
}
```


### 主题20：字符串算法


#### 一、字符串基础回顾

```python
# Python字符串的基本特性
s = "Hello, World!"

# 字符串是不可变的
# s[0] = 'h'  # 这会报错！
# 正确做法：
s = 'h' + s[1:]  # 创建新字符串

# 常用操作
print(len(s))           # 长度: 13
print(s.upper())        # 转大写: HELLO, WORLD!
print(s.lower())        # 转小写: hello, world!
print(s.split(","))     # 分割: ['Hello', ' World!']
print(s.strip())        # 去两端空白
print(s.replace("World", "Python"))  # 替换: Hello, Python!
print(s.find("World"))  # 查找子串位置: 7
print(s[7:12])          # 切片: World

# 字符串比较（字典序）
print("abc" < "abd")    # True
print("abc" < "abcd")   # True（短的在前）
```

---

#### 二、字符串匹配问题

> **核心问题**：在一个长字符串（文本）中查找一个短字符串（模式串）的位置。

##### 2.1 暴力匹配

```python
def brute_force_match(text: str, pattern: str) -> int:
    """
    暴力字符串匹配
    
    思路：从文本的每个位置开始，逐个字符比较。
    如果全部匹配，返回起始位置；如果某个字符不匹配，从下一个位置重新开始。
    
    类比：
    你在一本书里找"算法"这两个字。
    从第1页开始，逐字检查：是不是"算"？下一个是不是"法"？
    如果不是，从下一个字重新开始。
    
    时间复杂度：O(m × n)
      m = 文本长度，n = 模式串长度
      最坏情况：每次都匹配到最后一个字符才失败
    
    空间复杂度：O(1)
    """
    m = len(text)
    n = len(pattern)
    
    if n == 0:
        return 0
    
    # 从文本的每个位置i开始尝试匹配
    for i in range(m - n + 1):
        match = True
        # 逐个字符比较
        for j in range(n):
            if text[i + j] != pattern[j]:
                match = False
                break  # 不匹配，跳出内层循环
        
        if match:
            return i  # 找到匹配，返回起始位置
    
    return -1  # 没找到

# 测试
text = "ABABDABACDABABCABAB"
pattern = "ABABCABAB"
print(f"暴力匹配位置: {brute_force_match(text, pattern)}")  # 输出: 10
```

##### 2.2 KMP算法（重点！）

###### 核心思想

> **利用已经匹配过的信息，当失配时，不需要回退文本指针，而是滑动模式串到合适的位置。**

暴力匹配的问题：每次失配后，文本指针i要回退到上次开始位置的下一个，模式串指针j回退到0。很多比较是重复的！

KMP的改进：文本指针i永远不回退！失配时，利用模式串自身的信息，把模式串向右滑动到合适位置。

###### next数组（部分匹配表/失配函数）

```python
def build_next(pattern: str) -> list[int]:
    """
    构建KMP的next数组（也叫部分匹配表/失配函数）
    
    next[i] 的含义：
    pattern[0..i] 这个子串中，最长的"相同前后缀"的长度。
    
    什么是"相同前后缀"？
    比如 "ABABC"：
    - 前缀有：A, AB, ABA, ABAB
    - 后缀有：C, BC, ABC, BABC
    - 相同的前后缀：没有 → next = 0
    
    比如 "ABAB"：
    - 前缀有：A, AB, ABA
    - 后缀有：B, AB, BAB
    - 相同的前后缀：AB（长度2）→ next = 2
    
    通俗理解：
    next[i]告诉你，如果pattern[i]失配了，
    模式串可以向右滑动多少，而不会错过匹配。
    因为pattern[0..i]的前缀和后缀有重叠部分，
    已经匹配过的文本不需要重新匹配。
    
    类比：
    你在读一本书，发现某个情节和前面的情节重复了。
    你不需要从第一页重新读，只需要从重复的地方继续。
    next数组就是帮你记住"哪里重复了"。
    """
    n = len(pattern)
    next_arr = [0] * n  # next数组
    
    # k 表示当前最长相同前后缀的长度
    k = 0
    
    for i in range(1, n):
        # 如果当前字符不匹配，回退k
        # 利用已经计算好的next值，找到更短的相同前后缀
        while k > 0 and pattern[k] != pattern[i]:
            k = next_arr[k - 1]
        
        # 如果匹配，k加1
        if pattern[k] == pattern[i]:
            k += 1
        
        next_arr[i] = k
    
    return next_arr

# 演示next数组的计算过程
pattern = "ABABCABAB"
next_arr = build_next(pattern)
print(f"模式串: {pattern}")
print(f"next数组: {next_arr}")

# 逐个解释
print("\nnext数组详解：")
for i in range(len(pattern)):
    sub = pattern[:i+1]
    print(f"  pattern[0..{i}] = '{sub}' → next[{i}] = {next_arr[i]}")
```

###### next数组构建过程图解

```
模式串: A B A B C A B A B
索引:   0 1 2 3 4 5 6 7 8

i=0: 'A' → next[0] = 0（单个字符没有真前后缀）
i=1: 'AB' → 前缀{A}, 后缀{B}, 无相同 → next[1] = 0
i=2: 'ABA' → 前缀{A,AB}, 后缀{A,BA}, 相同{A} → next[2] = 1
i=3: 'ABAB' → 前缀{A,AB,ABA}, 后缀{B,AB,BAB}, 相同{AB} → next[3] = 2
i=4: 'ABABC' → 前缀{...}, 后缀{...}, 无相同 → next[4] = 0
i=5: 'ABABCA' → 前缀{...}, 后缀{...}, 相同{A} → next[5] = 1
i=6: 'ABABCAB' → 相同{AB} → next[6] = 2
i=7: 'ABABCABA' → 相同{ABA} → next[7] = 3
i=8: 'ABABCABAB' → 相同{ABAB} → next[8] = 4

最终next数组: [0, 0, 1, 2, 0, 1, 2, 3, 4]
```

###### 完整KMP匹配

```python
def kmp_search(text: str, pattern: str) -> int:
    """
    KMP字符串匹配算法
    
    完整流程：
    1. 构建next数组
    2. 用next数组指导匹配过程
    
    匹配过程：
    - 逐个比较text[i]和pattern[j]
    - 如果匹配，i和j都前进
    - 如果失配，i不动，j跳到next[j-1]
      （利用模式串的信息，跳过不必要的比较）
    
    时间复杂度：O(m + n)
      m = 文本长度，n = 模式串长度
      构建next数组O(n) + 匹配O(m) = O(m+n)
    
    空间复杂度：O(n)（next数组）
    """
    if not pattern:
        return 0
    
    m = len(text)
    n = len(pattern)
    
    # 第1步：构建next数组
    next_arr = build_next(pattern)
    
    # 第2步：匹配
    j = 0  # 模式串的指针
    
    for i in range(m):  # 文本指针i永远不回退！
        # 失配时，利用next数组回退模式串指针
        while j > 0 and text[i] != pattern[j]:
            j = next_arr[j - 1]
        
        # 匹配成功，模式串指针前进
        if text[i] == pattern[j]:
            j += 1
        
        # 模式串全部匹配完成
        if j == n:
            return i - n + 1  # 返回匹配的起始位置
    
    return -1  # 没找到

# 测试
text = "ABABDABACDABABCABAB"
pattern = "ABABCABAB"
pos = kmp_search(text, pattern)
print(f"KMP匹配位置: {pos}")  # 输出: 10

# 更多测试
print(kmp_search("hello world", "world"))     # 输出: 6
print(kmp_search("aaaaab", "aaab"))           # 输出: 2
print(kmp_search("abcde", "xyz"))             # 输出: -1
```

###### KMP复杂度分析

```
时间复杂度：O(m + n)
  - 构建next数组：O(n)
    虽然有个while循环，但k总共增加的次数不超过n次，
    所以while循环总共执行的次数也不超过n次（均摊分析）
  - 匹配过程：O(m)
    同理，i从0到m-1只前进不回退，
    j的回退总次数不超过j增加的总次数（≤m）
  
空间复杂度：O(n)（next数组）

对比暴力匹配：
  暴力：O(m×n)，每次失配都要从头开始
  KMP：O(m+n)，失配时利用已知信息跳过不必要的比较
```

##### 2.3 Rabin-Karp算法

```python
def rabin_karp(text: str, pattern: str) -> int:
    """
    Rabin-Karp字符串匹配算法
    
    核心思想：字符串哈希 + 滚动哈希
    
    思路：
    1. 把字符串看成一个多项式（类似进制转换）
       "ABC" = A×26² + B×26¹ + C×26⁰
    2. 先算出模式串的哈希值
    3. 用"滚动哈希"快速算出文本中每个长度为n的子串的哈希值
    4. 如果哈希值相同，再做精确比较（防止哈希冲突）
    
    类比：
    你要在一堆书中找特定的一本书。
    暴力方法：每本书都翻开看看是不是。
    Rabin-Karp：先看书的ISBN编号（哈希值），
    编号对了再翻开确认（精确比较）。
    大部分书一看编号就知道不是，省了很多翻书的时间。
    
    滚动哈希：
    假设窗口大小=3，base=10
    "123" → hash = 1×100 + 2×10 + 3 = 123
    窗口右移一位变成"234"：
    hash = (123 - 1×100) × 10 + 4 = 234
    不需要重新算整个哈希！减去最左边的贡献，乘以base，加上新的。
    
    时间复杂度：平均O(m+n)，最坏O(m×n)（哈希冲突很多时）
    空间复杂度：O(1)
    """
    m = len(text)
    n = len(pattern)
    
    if n == 0:
        return 0
    if m < n:
        return -1
    
    # 参数选择
    BASE = 256       # 字符集大小（ASCII有256个字符）
    MOD = 10**9 + 7  # 取模的大素数（防止哈希值太大）
    
    # 计算 BASE^(n-1) % MOD，用于滚动时去掉最左边的字符
    power = 1
    for _ in range(n - 1):
        power = (power * BASE) % MOD
    
    # 计算模式串和文本第一个窗口的哈希值
    hash_pattern = 0
    hash_text = 0
    
    for i in range(n):
        hash_pattern = (hash_pattern * BASE + ord(pattern[i])) % MOD
        hash_text = (hash_text * BASE + ord(text[i])) % MOD
    
    # 滑动窗口
    for i in range(m - n + 1):
        # 哈希值相同，做精确比较（防止哈希冲突）
        if hash_text == hash_pattern:
            if text[i:i + n] == pattern:
                return i
        
        # 滚动哈希：去掉text[i]，加入text[i+n]
        if i < m - n:
            hash_text = (hash_text - ord(text[i]) * power) % MOD
            hash_text = (hash_text * BASE + ord(text[i + n])) % MOD
            # 确保哈希值为正数（Python的%总是返回非负数，但其他语言需要注意）
            hash_text = (hash_text + MOD) % MOD
    
    return -1

# 测试
print(rabin_karp("ABABDABACDABABCABAB", "ABABCABAB"))  # 输出: 10
print(rabin_karp("hello world", "world"))               # 输出: 6
print(rabin_karp("aaaaab", "aaab"))                     # 输出: 2
```

###### Rabin-Karp应用场景

```
优势场景：
1. 多模式匹配：同时搜索多个模式串（每个模式串算一个哈希值）
2. 二维匹配：在图像中查找子图像
3. 查重：快速判断两个长文本是否有相同的子串
4. 生物信息学：DNA序列匹配

注意事项：
- 哈希冲突：两个不同字符串可能有相同哈希值
  解决方案：用双哈希（两个不同的BASE和MOD）
- 最坏情况退化为O(m×n)（所有窗口哈希值都相同）
```

---

#### 三、字符串经典例题

##### 3.1 最长回文子串（LeetCode 5）

###### 方法1：中心扩展法

```python
def longestPalindrome_expand(s: str) -> str:
    """
    最长回文子串 - 中心扩展法
    
    回文串的特点：关于中心对称
    思路：枚举每个可能的中心位置，向两边扩展，看能扩展多远。
    
    注意：回文串长度可以是奇数或偶数
    - 奇数长度：中心是一个字符，如 "aba"，中心是'b'
    - 偶数长度：中心是两个字符之间，如 "abba"，中心在两个'b'之间
    
    技巧：把每个字符之间插入'#'，统一处理
    "abc" → "#a#b#c#"
    这样所有回文都变成奇数长度
    
    时间复杂度：O(n²)
    空间复杂度：O(1)
    """
    if len(s) <= 1:
        return s
    
    start = 0  # 最长回文的起始位置
    max_len = 1  # 最长回文的长度
    
    def expand(left, right):
        """从中心向两边扩展，返回回文的起始和长度"""
        while left >= 0 and right < len(s) and s[left] == s[right]:
            left -= 1
            right += 1
        # 退出时，s[left+1..right-1]是回文
        return left + 1, right - left - 1
    
    for i in range(len(s)):
        # 奇数长度：以s[i]为中心
        left1, len1 = expand(i - 1, i + 1)
        # 偶数长度：以s[i]和s[i+1]之间为中心
        left2, len2 = expand(i, i + 1)
        
        # 取较长的
        if len1 > max_len:
            max_len = len1
            start = left1
        if len2 > max_len:
            max_len = len2
            start = left2
    
    return s[start:start + max_len]

# 测试
print(longestPalindrome_expand("babad"))   # "bab" 或 "aba"
print(longestPalindrome_expand("cbbd"))    # "bb"
print(longestPalindrome_expand("a"))       # "a"
```

###### 方法2：DP法

```python
def longestPalindrome_dp(s: str) -> str:
    """
    最长回文子串 - 动态规划法
    
    状态定义：dp[i][j] = s[i..j]是否是回文串
    状态转移：
      dp[i][j] = (s[i] == s[j]) and dp[i+1][j-1]
      即：两端字符相同，且去掉两端后的子串也是回文
    
    初始条件：
      dp[i][i] = True（单个字符是回文）
      dp[i][i+1] = (s[i] == s[i+1])（两个相邻字符）
    
    时间复杂度：O(n²)
    空间复杂度：O(n²)
    """
    n = len(s)
    if n <= 1:
        return s
    
    # dp[i][j] 表示 s[i..j] 是否是回文
    dp = [[False] * n for _ in range(n)]
    
    start = 0
    max_len = 1
    
    # 所有单个字符都是回文
    for i in range(n):
        dp[i][i] = True
    
    # 检查长度为2的子串
    for i in range(n - 1):
        if s[i] == s[i + 1]:
            dp[i][i + 1] = True
            start = i
            max_len = 2
    
    # 从长度为3开始，逐步增加
    for length in range(3, n + 1):  # 子串长度
        for i in range(n - length + 1):
            j = i + length - 1  # 子串结束位置
            
            # 两端相同 且 中间也是回文
            if s[i] == s[j] and dp[i + 1][j - 1]:
                dp[i][j] = True
                if length > max_len:
                    max_len = length
                    start = i
    
    return s[start:start + max_len]

# 测试
print(longestPalindrome_dp("babad"))   # "bab" 或 "aba"
print(longestPalindrome_dp("cbbd"))    # "bb"
```

##### 3.2 字符串的排列（LeetCode 567）—— 滑动窗口

```python
def checkInclusion(s1: str, s2: str) -> bool:
    """
    字符串的排列
    
    题目：判断s2是否包含s1的某个排列（全排列之一）作为子串。
    
    比如：s1="ab", s2="eidbaooo"
    s2包含"ba"，是"ab"的排列 → True
    
    思路：滑动窗口
    - s1的排列长度固定为len(s1)
    - 在s2上维护一个长度为len(s1)的滑动窗口
    - 比较窗口内的字符频率和s1的字符频率是否相同
    
    类比：
    你有一组字母积木（s1），要在一排积木（s2）中
    找一段连续的积木，用的字母和数量完全一样。
    你用一个固定大小的窗口从左到右滑动，
    每次移出一个字母、移入一个字母，更新计数。
    
    时间复杂度：O(n)，n为s2的长度
    空间复杂度：O(1)（字符集大小固定）
    """
    if len(s1) > len(s2):
        return False
    
    # 统计s1中每个字符的出现次数
    need = [0] * 26
    for c in s1:
        need[ord(c) - ord('a')] += 1
    
    # 滑动窗口中的字符计数
    window = [0] * 26
    left = 0
    
    for right in range(len(s2)):
        # 右边界字符进入窗口
        window[ord(s2[right]) - ord('a')] += 1
        
        # 窗口大小超过s1长度时，左边界字符移出窗口
        if right - left + 1 > len(s1):
            window[ord(s2[left]) - ord('a')] -= 1
            left += 1
        
        # 窗口大小等于s1长度时，检查是否匹配
        if right - left + 1 == len(s1):
            if window == need:
                return True
    
    return False

# 测试
print(checkInclusion("ab", "eidbaooo"))     # True (包含"ba")
print(checkInclusion("ab", "eidboaoo"))     # False
print(checkInclusion("abc", "bbbca"))       # True (包含"bca")
```

##### 3.3 实现strStr()（LeetCode 28）

```python
def strStr(haystack: str, needle: str) -> int:
    """
    实现 strStr()
    
    题目：在haystack中找到needle第一次出现的位置（从0开始）。
    如果needle不是haystack的一部分，返回-1。
    
    这题就是字符串匹配！可以用KMP算法。
    """
    # 方法1：直接用KMP
    if not needle:
        return 0
    
    # 构建next数组
    n = len(needle)
    next_arr = [0] * n
    k = 0
    for i in range(1, n):
        while k > 0 and needle[k] != needle[i]:
            k = next_arr[k - 1]
        if needle[k] == needle[i]:
            k += 1
        next_arr[i] = k
    
    # KMP匹配
    j = 0
    for i in range(len(haystack)):
        while j > 0 and haystack[i] != needle[j]:
            j = next_arr[j - 1]
        if haystack[i] == needle[j]:
            j += 1
        if j == n:
            return i - n + 1
    
    return -1

    # 方法2：Python内置（实际面试中可以用）
    # return haystack.find(needle)

# 测试
print(strStr("sadbutsad", "sad"))    # 输出: 0
print(strStr("leetcode", "leeto"))   # 输出: -1
print(strStr("hello", "ll"))         # 输出: 2
```

---

#### 四、字符串算法总结

##### 各算法对比

| 算法 | 时间复杂度 | 空间复杂度 | 适用场景 |
|------|-----------|-----------|---------|
| 暴力匹配 | O(m×n) | O(1) | 短字符串、简单场景 |
| KMP | O(m+n) | O(n) | 单模式匹配，最通用 |
| Rabin-Karp | 平均O(m+n) | O(1) | 多模式匹配、查重 |

##### 解题技巧

```
1. 字符串匹配问题：
   - 面试中先写暴力，再优化到KMP
   - KMP的核心是next数组，理解"相同前后缀"是关键

2. 回文问题：
   - 中心扩展法：O(n²)时间，O(1)空间，最实用
   - DP法：O(n²)时间和空间
   - Manacher算法：O(n)时间（进阶了解）

3. 滑动窗口：
   - 固定窗口大小：用数组/哈希表维护窗口内的字符频率
   - 可变窗口大小：左右指针，根据条件收缩/扩展

4. 字符串哈希：
   - 把字符串映射成数字，快速比较
   - 注意哈希冲突的处理
```


### 主题20 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、字符串基础回顾

```typescript
// ========== 字符串基础回顾 ==========
const s = "Hello, World!";
// 字符串是不可变的，每次"修改"都创建新字符串

// 常用操作
console.log(s.length);                          // 13
console.log(s.toUpperCase());                   // HELLO, WORLD!
console.log(s.toLowerCase());                   // hello, world!
console.log(s.split(","));                      // ['Hello', ' World!']
console.log(s.trim());                          // 去两端空白
console.log(s.replace("World", "Python"));      // Hello, Python!
console.log(s.indexOf("World"));                // 7
console.log(s.slice(7, 12));                    // World

// 字符串比较（字典序）
console.log("abc" < "abd");    // true
console.log("abc" < "abcd");   // true（短的在前）
```

##### 二、字符串匹配：暴力与 KMP

```typescript
// ========== 2.1 暴力匹配 ==========
// 从文本的每个位置开始，逐个字符比较；失配则从下一个位置重新开始
function bruteForceMatch(text: string, pattern: string): number {
    const m = text.length;
    const n = pattern.length;
    if (n === 0) return 0;

    for (let i = 0; i <= m - n; i++) {
        let match = true;
        for (let j = 0; j < n; j++) {
            if (text[i + j] !== pattern[j]) {
                match = false;
                break;
            }
        }
        if (match) return i; // 找到匹配，返回起始位置
    }
    return -1; // 没找到
}
console.log(`暴力匹配位置: ${bruteForceMatch("ABABDABACDABABCABAB", "ABABCABAB")}`); // 10

// ========== 2.2 KMP算法 ==========
// 核心：文本指针i永远不回退！失配时利用next数组滑动模式串
// 构建next数组（部分匹配表）
function buildNext(pattern: string): number[] {
    const n = pattern.length;
    const nextArr = new Array<number>(n).fill(0);
    let k = 0; // 当前最长相同前后缀的长度

    for (let i = 1; i < n; i++) {
        // 不匹配时回退k，利用已计算的next值找到更短的相同前后缀
        while (k > 0 && pattern[k] !== pattern[i]) {
            k = nextArr[k - 1];
        }
        if (pattern[k] === pattern[i]) k++;
        nextArr[i] = k;
    }
    return nextArr;
}

function kmpSearch(text: string, pattern: string): number {
    if (!pattern) return 0;
    const m = text.length;
    const n = pattern.length;
    const nextArr = buildNext(pattern);

    let j = 0; // 模式串指针
    for (let i = 0; i < m; i++) { // 文本指针i永远不回退！
        // 失配时，利用next数组回退模式串指针
        while (j > 0 && text[i] !== pattern[j]) {
            j = nextArr[j - 1];
        }
        if (text[i] === pattern[j]) j++;
        if (j === n) return i - n + 1; // 全部匹配，返回起始位置
    }
    return -1;
}

const patternKmp = "ABABCABAB";
console.log(`模式串: ${patternKmp}`);
console.log(`next数组: [${buildNext(patternKmp)}]`); // [0, 0, 1, 2, 0, 1, 2, 3, 4]
console.log(`KMP匹配位置: ${kmpSearch("ABABDABACDABABCABAB", "ABABCABAB")}`); // 10
console.log(kmpSearch("hello world", "world")); // 6
console.log(kmpSearch("aaaaab", "aaab"));       // 2
console.log(kmpSearch("abcde", "xyz"));         // -1
```

##### 二、字符串匹配：Rabin-Karp

```typescript
// ========== 2.3 Rabin-Karp算法 ==========
// 核心思想：字符串哈希 + 滚动哈希
function rabinKarp(text: string, pattern: string): number {
    const m = text.length;
    const n = pattern.length;
    if (n === 0) return 0;
    if (m < n) return -1;

    // 参数选择
    const BASE = 256;      // 字符集大小（ASCII）
    const MOD = 1_000_000_007; // 取模的大素数

    // 计算 BASE^(n-1) % MOD，用于滚动时去掉最左边的字符
    let power = 1;
    for (let i = 0; i < n - 1; i++) {
        power = (power * BASE) % MOD;
    }

    // 计算模式串和文本第一个窗口的哈希值
    let hashPattern = 0;
    let hashText = 0;
    for (let i = 0; i < n; i++) {
        hashPattern = (hashPattern * BASE + pattern.charCodeAt(i)) % MOD;
        hashText = (hashText * BASE + text.charCodeAt(i)) % MOD;
    }

    // 滑动窗口
    for (let i = 0; i <= m - n; i++) {
        // 哈希值相同，做精确比较（防止哈希冲突）
        if (hashText === hashPattern) {
            if (text.slice(i, i + n) === pattern) return i;
        }
        // 滚动哈希：去掉text[i]，加入text[i+n]
        if (i < m - n) {
            hashText = (hashText - text.charCodeAt(i) * power) % MOD;
            hashText = (hashText * BASE + text.charCodeAt(i + n)) % MOD;
            hashText = (hashText + MOD) % MOD; // 确保为正数
        }
    }
    return -1;
}

console.log(rabinKarp("ABABDABACDABABCABAB", "ABABCABAB")); // 10
console.log(rabinKarp("hello world", "world"));              // 6
console.log(rabinKarp("aaaaab", "aaab"));                    // 2
```

##### 三、经典例题：最长回文子串

```typescript
// ========== 3.1 最长回文子串 - 中心扩展法 ==========
// 枚举每个可能的中心位置，向两边扩展
function longestPalindromeExpand(s: string): string {
    if (s.length <= 1) return s;
    let start = 0;
    let maxLen = 1;

    // 从中心向两边扩展，返回回文的起始和长度
    const expand = (left: number, right: number): [number, number] => {
        while (left >= 0 && right < s.length && s[left] === s[right]) {
            left--;
            right++;
        }
        // 退出时，s[left+1..right-1]是回文
        return [left + 1, right - left - 1];
    };

    for (let i = 0; i < s.length; i++) {
        // 奇数长度：以s[i]为中心
        const [left1, len1] = expand(i - 1, i + 1);
        // 偶数长度：以s[i]和s[i+1]之间为中心
        const [left2, len2] = expand(i, i + 1);

        if (len1 > maxLen) { maxLen = len1; start = left1; }
        if (len2 > maxLen) { maxLen = len2; start = left2; }
    }
    return s.slice(start, start + maxLen);
}
console.log(`中心扩展法: ${longestPalindromeExpand("babad")}`); // "bab" 或 "aba"
console.log(`中心扩展法: ${longestPalindromeExpand("cbbd")}`);  // "bb"

// ========== 3.1 最长回文子串 - DP法 ==========
// dp[i][j] = s[i..j]是否是回文串
function longestPalindromeDp(s: string): string {
    const n = s.length;
    if (n <= 1) return s;

    const dp: boolean[][] = Array.from({ length: n }, () => new Array<boolean>(n).fill(false));
    let start = 0;
    let maxLen = 1;

    // 所有单个字符都是回文
    for (let i = 0; i < n; i++) dp[i][i] = true;
    // 长度为2的子串
    for (let i = 0; i < n - 1; i++) {
        if (s[i] === s[i + 1]) {
            dp[i][i + 1] = true;
            start = i;
            maxLen = 2;
        }
    }

    // 从长度为3开始，逐步增加
    for (let length = 3; length <= n; length++) {
        for (let i = 0; i <= n - length; i++) {
            const j = i + length - 1;
            // 两端相同 且 中间也是回文
            if (s[i] === s[j] && dp[i + 1][j - 1]) {
                dp[i][j] = true;
                if (length > maxLen) {
                    maxLen = length;
                    start = i;
                }
            }
        }
    }
    return s.slice(start, start + maxLen);
}
console.log(`DP法: ${longestPalindromeDp("babad")}`); // "bab" 或 "aba"
console.log(`DP法: ${longestPalindromeDp("cbbd")}`);  // "bb"
```

##### 三、经典例题：字符串排列与 strStr

```typescript
// ========== 3.2 字符串的排列（LeetCode 567）- 滑动窗口 ==========
// 在s2上维护一个长度为len(s1)的滑动窗口，比较字符频率
function checkInclusion(s1: string, s2: string): boolean {
    if (s1.length > s2.length) return false;

    // 统计s1中每个字符的出现次数
    const need = new Array<number>(26).fill(0);
    for (const c of s1) need[c.charCodeAt(0) - 97]++;

    // 滑动窗口中的字符计数
    const window = new Array<number>(26).fill(0);
    let left = 0;

    for (let right = 0; right < s2.length; right++) {
        // 右边界字符进入窗口
        window[s2.charCodeAt(right) - 97]++;

        // 窗口大小超过s1长度时，左边界字符移出窗口
        if (right - left + 1 > s1.length) {
            window[s2.charCodeAt(left) - 97]--;
            left++;
        }

        // 窗口大小等于s1长度时，检查是否匹配
        if (right - left + 1 === s1.length) {
            if (window.every((v, i) => v === need[i])) return true;
        }
    }
    return false;
}
console.log(checkInclusion("ab", "eidbaooo")); // true（包含"ba"）
console.log(checkInclusion("ab", "eidboaoo")); // false
console.log(checkInclusion("abc", "bbbca"));   // true（包含"bca"）

// ========== 3.3 实现strStr()（LeetCode 28）- 用KMP ==========
function strStr(haystack: string, needle: string): number {
    if (!needle) return 0;
    const n = needle.length;

    // 构建next数组
    const nextArr = new Array<number>(n).fill(0);
    let k = 0;
    for (let i = 1; i < n; i++) {
        while (k > 0 && needle[k] !== needle[i]) k = nextArr[k - 1];
        if (needle[k] === needle[i]) k++;
        nextArr[i] = k;
    }

    // KMP匹配
    let j = 0;
    for (let i = 0; i < haystack.length; i++) {
        while (j > 0 && haystack[i] !== needle[j]) j = nextArr[j - 1];
        if (haystack[i] === needle[j]) j++;
        if (j === n) return i - n + 1;
    }
    return -1;
}
console.log(strStr("sadbutsad", "sad"));  // 0
console.log(strStr("leetcode", "leeto")); // -1
console.log(strStr("hello", "ll"));       // 2
```


### 主题20 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、字符串基础回顾

```go
package main

import (
	"fmt"
	"strings"
)

// ========== 字符串基础回顾 ==========
func testStringBase() {
	s := "Hello, World!"
	// 字符串是不可变的，每次"修改"都创建新字符串

	fmt.Println(len(s))                                    // 13
	fmt.Println(strings.ToUpper(s))                        // HELLO, WORLD!
	fmt.Println(strings.ToLower(s))                        // hello, world!
	fmt.Println(strings.Split(s, ","))                     // [Hello  World!]
	fmt.Println(strings.TrimSpace(s))                      // 去两端空白
	fmt.Println(strings.ReplaceAll(s, "World", "Python"))  // Hello, Python!
	fmt.Println(strings.Index(s, "World"))                 // 7
	fmt.Println(s[7:12])                                   // World

	// 字符串比较（字典序）
	fmt.Println("abc" < "abd")  // true
	fmt.Println("abc" < "abcd") // true（短的在前）
}
```

##### 二、字符串匹配：暴力与 KMP

```go
package main

import "fmt"

// ========== 2.1 暴力匹配 ==========
// 从文本的每个位置开始，逐个字符比较；失配则从下一个位置重新开始
func bruteForceMatch(text, pattern string) int {
	m := len(text)
	n := len(pattern)
	if n == 0 {
		return 0
	}

	for i := 0; i <= m-n; i++ {
		match := true
		for j := 0; j < n; j++ {
			if text[i+j] != pattern[j] {
				match = false
				break
			}
		}
		if match {
			return i // 找到匹配，返回起始位置
		}
	}
	return -1 // 没找到
}

// ========== 2.2 KMP算法 ==========
// 核心：文本指针i永远不回退！失配时利用next数组滑动模式串
// 构建next数组（部分匹配表）
func buildNext(pattern string) []int {
	n := len(pattern)
	nextArr := make([]int, n)
	k := 0 // 当前最长相同前后缀的长度

	for i := 1; i < n; i++ {
		// 不匹配时回退k，利用已计算的next值找到更短的相同前后缀
		for k > 0 && pattern[k] != pattern[i] {
			k = nextArr[k-1]
		}
		if pattern[k] == pattern[i] {
			k++
		}
		nextArr[i] = k
	}
	return nextArr
}

func kmpSearch(text, pattern string) int {
	if pattern == "" {
		return 0
	}
	m, n := len(text), len(pattern)
	nextArr := buildNext(pattern)

	j := 0 // 模式串指针
	for i := 0; i < m; i++ { // 文本指针i永远不回退！
		// 失配时，利用next数组回退模式串指针
		for j > 0 && text[i] != pattern[j] {
			j = nextArr[j-1]
		}
		if text[i] == pattern[j] {
			j++
		}
		if j == n {
			return i - n + 1 // 全部匹配，返回起始位置
		}
	}
	return -1
}

func testKmp() {
	pattern := "ABABCABAB"
	fmt.Println("模式串:", pattern)
	fmt.Println("next数组:", buildNext(pattern)) // [0 0 1 2 0 1 2 3 4]
	fmt.Println("KMP匹配位置:", kmpSearch("ABABDABACDABABCABAB", "ABABCABAB")) // 10
	fmt.Println(kmpSearch("hello world", "world")) // 6
	fmt.Println(kmpSearch("aaaaab", "aaab"))       // 2
	fmt.Println(kmpSearch("abcde", "xyz"))         // -1
}
```

##### 二、字符串匹配：Rabin-Karp

```go
package main

import "fmt"

// ========== 2.3 Rabin-Karp算法 ==========
// 核心思想：字符串哈希 + 滚动哈希
func rabinKarp(text, pattern string) int {
	m := len(text)
	n := len(pattern)
	if n == 0 {
		return 0
	}
	if m < n {
		return -1
	}

	// 参数选择
	const BASE = 256
	const MOD = 1000000007

	// 计算 BASE^(n-1) % MOD，用于滚动时去掉最左边的字符
	power := 1
	for i := 0; i < n-1; i++ {
		power = (power * BASE) % MOD
	}

	// 计算模式串和文本第一个窗口的哈希值
	hashPattern := 0
	hashText := 0
	for i := 0; i < n; i++ {
		hashPattern = (hashPattern*BASE + int(pattern[i])) % MOD
		hashText = (hashText*BASE + int(text[i])) % MOD
	}

	// 滑动窗口
	for i := 0; i <= m-n; i++ {
		// 哈希值相同，做精确比较（防止哈希冲突）
		if hashText == hashPattern {
			if text[i:i+n] == pattern {
				return i
			}
		}
		// 滚动哈希：去掉text[i]，加入text[i+n]
		if i < m-n {
			hashText = (hashText - int(text[i])*power) % MOD
			hashText = (hashText*BASE + int(text[i+n])) % MOD
			hashText = (hashText + MOD) % MOD // 确保为正数
		}
	}
	return -1
}

func testRabinKarp() {
	fmt.Println(rabinKarp("ABABDABACDABABCABAB", "ABABCABAB")) // 10
	fmt.Println(rabinKarp("hello world", "world"))              // 6
	fmt.Println(rabinKarp("aaaaab", "aaab"))                    // 2
}
```

##### 三、经典例题：最长回文子串

```go
package main

import "fmt"

// ========== 3.1 最长回文子串 - 中心扩展法 ==========
// 枚举每个可能的中心位置，向两边扩展
func longestPalindromeExpand(s string) string {
	if len(s) <= 1 {
		return s
	}
	start := 0
	maxLen := 1

	// 从中心向两边扩展，返回回文的起始和长度
	expand := func(left, right int) (int, int) {
		for left >= 0 && right < len(s) && s[left] == s[right] {
			left--
			right++
		}
		// 退出时，s[left+1..right-1]是回文
		return left + 1, right - left - 1
	}

	for i := 0; i < len(s); i++ {
		// 奇数长度：以s[i]为中心
		left1, len1 := expand(i-1, i+1)
		// 偶数长度：以s[i]和s[i+1]之间为中心
		left2, len2 := expand(i, i+1)

		if len1 > maxLen {
			maxLen = len1
			start = left1
		}
		if len2 > maxLen {
			maxLen = len2
			start = left2
		}
	}
	return s[start : start+maxLen]
}

// ========== 3.1 最长回文子串 - DP法 ==========
// dp[i][j] = s[i..j]是否是回文串
func longestPalindromeDp(s string) string {
	n := len(s)
	if n <= 1 {
		return s
	}

	dp := make([][]bool, n)
	for i := range dp {
		dp[i] = make([]bool, n)
	}
	start := 0
	maxLen := 1

	// 所有单个字符都是回文
	for i := 0; i < n; i++ {
		dp[i][i] = true
	}
	// 长度为2的子串
	for i := 0; i < n-1; i++ {
		if s[i] == s[i+1] {
			dp[i][i+1] = true
			start = i
			maxLen = 2
		}
	}

	// 从长度为3开始，逐步增加
	for length := 3; length <= n; length++ {
		for i := 0; i <= n-length; i++ {
			j := i + length - 1
			// 两端相同 且 中间也是回文
			if s[i] == s[j] && dp[i+1][j-1] {
				dp[i][j] = true
				if length > maxLen {
					maxLen = length
					start = i
				}
			}
		}
	}
	return s[start : start+maxLen]
}

func testPalindrome() {
	fmt.Println("中心扩展法:", longestPalindromeExpand("babad")) // "bab" 或 "aba"
	fmt.Println("中心扩展法:", longestPalindromeExpand("cbbd"))  // "bb"
	fmt.Println("DP法:", longestPalindromeDp("babad"))       // "bab" 或 "aba"
	fmt.Println("DP法:", longestPalindromeDp("cbbd"))        // "bb"
}
```

##### 三、经典例题：字符串排列与 strStr

```go
package main

import "fmt"

// ========== 3.2 字符串的排列（LeetCode 567）- 滑动窗口 ==========
// 在s2上维护一个长度为len(s1)的滑动窗口，比较字符频率
func checkInclusion(s1, s2 string) bool {
	if len(s1) > len(s2) {
		return false
	}

	// 统计s1中每个字符的出现次数
	need := [26]int{}
	for i := 0; i < len(s1); i++ {
		need[s1[i]-'a']++
	}

	// 滑动窗口中的字符计数
	window := [26]int{}
	left := 0

	for right := 0; right < len(s2); right++ {
		// 右边界字符进入窗口
		window[s2[right]-'a']++

		// 窗口大小超过s1长度时，左边界字符移出窗口
		if right-left+1 > len(s1) {
			window[s2[left]-'a']--
			left++
		}

		// 窗口大小等于s1长度时，检查是否匹配
		if right-left+1 == len(s1) {
			if window == need {
				return true
			}
		}
	}
	return false
}

// ========== 3.3 实现strStr()（LeetCode 28）- 用KMP ==========
func strStr(haystack, needle string) int {
	if needle == "" {
		return 0
	}
	n := len(needle)

	// 构建next数组
	nextArr := make([]int, n)
	k := 0
	for i := 1; i < n; i++ {
		for k > 0 && needle[k] != needle[i] {
			k = nextArr[k-1]
		}
		if needle[k] == needle[i] {
			k++
		}
		nextArr[i] = k
	}

	// KMP匹配
	j := 0
	for i := 0; i < len(haystack); i++ {
		for j > 0 && haystack[i] != needle[j] {
			j = nextArr[j-1]
		}
		if haystack[i] == needle[j] {
			j++
		}
		if j == n {
			return i - n + 1
		}
	}
	return -1
}

func testInclusionAndStrstr() {
	fmt.Println(checkInclusion("ab", "eidbaooo")) // true（包含"ba"）
	fmt.Println(checkInclusion("ab", "eidboaoo")) // false
	fmt.Println(checkInclusion("abc", "bbbca"))   // true（包含"bca"）
	fmt.Println(strStr("sadbutsad", "sad"))  // 0
	fmt.Println(strStr("leetcode", "leeto")) // -1
	fmt.Println(strStr("hello", "ll"))       // 2
}
```


## 第八阶段：进阶与实战

### 主题21：高级主题（选学）


> 本主题介绍几种在实际编程竞赛和高级面试中常见的数据结构。它们不是必须掌握的，但学有余力时了解它们会让你如虎添翼。

---

#### 一、单调栈（Monotonic Stack）

##### 1.1 什么是单调栈？

**一句话定义**：栈中元素从底到顶保持单调递增（或递减）的栈。

**生活类比**：想象一排身高不同的人站成一列，你从右往左看。如果每个人都在"寻找右边第一个比自己高的人"，那么：
- 如果你右边的人比你矮，他不可能成为你右边"第一个更高的人"——他对你没用，可以忽略。
- 你只需要关注那些比你高的人。

单调栈就是利用这种"淘汰无用元素"的思想，让栈中元素始终保持有序。

##### 1.2 用途

单调栈专门解决一类问题：**对于序列中的每个元素，快速找到它左边/右边第一个比它大/小的元素**。

暴力方法需要 O(n²)，单调栈只需 O(n)。

##### 1.3 模板代码

```python
def monotonic_stack_template(nums):
    """
    单调栈模板：找每个元素右边第一个比它大的元素
    """
    n = len(nums)
    answer = [-1] * n          # 默认值 -1，表示找不到
    stack = []                  # 栈中存储的是【下标】，不是值！
    
    for i in range(n):
        # 当前元素比栈顶元素大 → 栈顶元素找到了"右边第一个更大元素"
        while stack and nums[i] > nums[stack[-1]]:
            idx = stack.pop()   # 弹出栈顶
            answer[idx] = nums[i]  # 栈顶元素右边第一个更大元素就是 nums[i]
        stack.append(i)        # 当前元素入栈
    
    return answer

# 测试
nums = [2, 1, 2, 4, 3]
print(monotonic_stack_template(nums))  # 输出: [4, 2, 4, -1, -1]
# 解释：
# 2 的右边第一个更大 → 4
# 1 的右边第一个更大 → 2
# 2 的右边第一个更大 → 4
# 4 的右边没有更大 → -1
# 3 的右边没有更大 → -1
```

##### 1.4 四种变体

根据需求不同，单调栈有四种写法：

```python
# 变体1：找右边第一个更大元素（栈从底到顶递减）
while stack and nums[i] > nums[stack[-1]]:
    ...

# 变体2：找右边第一个更大或相等元素（栈从底到顶严格递减）
while stack and nums[i] >= nums[stack[-1]]:
    ...

# 变体3：找右边第一个更小元素（栈从底到顶递增）
while stack and nums[i] < nums[stack[-1]]:
    ...

# 变体4：找右边第一个更小或相等元素（栈从底到顶严格递增）
while stack and nums[i] <= nums[stack[-1]]:
    ...
```

##### 1.5 经典例题：每日温度（LeetCode 739）

**题目**：给定一个整数数组 `temperatures`，返回一个数组，对于每一天，计算需要等待多少天才能遇到更高的温度。如果之后都不会更高，则为 0。

**示例**：
```
输入：temperatures = [73, 74, 75, 71, 69, 72, 76, 73]
输出：[1, 1, 4, 2, 1, 1, 0, 0]
```

**思路分析**：
- 这本质上就是"找右边第一个更大元素"，只不过我们需要的不是值，而是距离（下标差）。

```python
def dailyTemperatures(temperatures):
    """
    LeetCode 739. 每日温度
    
    用单调栈解决：栈中存下标，栈从底到顶温度递减。
    当遇到更高温度时，说明栈顶元素等到了更高温度。
    
    时间复杂度：O(n)，每个元素最多入栈出栈各一次
    空间复杂度：O(n)
    """
    n = len(temperatures)
    answer = [0] * n          # 结果数组，默认0
    stack = []                # 单调递减栈，存下标
    
    for i in range(n):
        # 当前温度比栈顶高 → 栈顶那一天"等到了"更暖的一天
        while stack and temperatures[i] > temperatures[stack[-1]]:
            prev_idx = stack.pop()
            # 等待天数 = 当前下标 - 之前的下标
            answer[prev_idx] = i - prev_idx
        stack.append(i)       # 当前天下标入栈
    
    return answer

# 测试
temps = [73, 74, 75, 71, 69, 72, 76, 73]
print(dailyTemperatures(temps))  # 输出: [1, 1, 4, 2, 1, 1, 0, 0]

# 逐步模拟：
# i=0, temp=73: 栈空，直接入栈 → stack=[0]
# i=1, temp=74: 74>73，弹出0，answer[0]=1-0=1 → stack=[1]
# i=2, temp=75: 75>74，弹出1，answer[1]=2-1=1 → stack=[2]
# i=3, temp=71: 71<75，直接入栈 → stack=[2,3]
# i=4, temp=69: 69<71，直接入栈 → stack=[2,3,4]
# i=5, temp=72: 72>69，弹出4，answer[4]=5-4=1
#              72>71，弹出3，answer[3]=5-3=2
#              72<75，停止 → stack=[2,5]
# i=6, temp=76: 76>72，弹出5，answer[5]=6-5=1
#              76>75，弹出2，answer[2]=6-2=4
#              栈空，停止 → stack=[6]
# i=7, temp=73: 73<76，直接入栈 → stack=[6,7]
# 遍历结束，栈中剩余[6,7]对应answer为0（默认值）
```

##### 1.6 经典例题：下一个更大元素 I（LeetCode 496）

**题目**：给你两个没有重复元素的数组 `nums1` 和 `nums2`，其中 `nums1` 是 `nums2` 的子集。对于 `nums1` 中的每个元素，找到它在 `nums2` 中右边第一个更大的元素。

```python
def nextGreaterElement(nums1, nums2):
    """
    LeetCode 496. 下一个更大元素 I
    
    思路：
    1. 先用单调栈处理 nums2，用哈希表记录每个元素的下一个更大元素
    2. 然后遍历 nums1，直接从哈希表查答案
    
    时间复杂度：O(n + m)，n=len(nums2), m=len(nums1)
    空间复杂度：O(n)
    """
    # 第一步：单调栈处理 nums2
    next_greater = {}         # 哈希表：元素 → 右边第一个更大元素
    stack = []                # 单调递减栈
    
    for num in nums2:
        while stack and num > stack[-1]:
            smaller = stack.pop()
            next_greater[smaller] = num  # 记录答案
        stack.append(num)
    
    # 栈中剩余元素没有"下一个更大元素"，不加入哈希表即可
    
    # 第二步：查询 nums1 的答案
    answer = []
    for num in nums1:
        answer.append(next_greater.get(num, -1))  # 找不到返回-1
    
    return answer

# 测试
nums1 = [4, 1, 2]
nums2 = [1, 3, 4, 2]
print(nextGreaterElement(nums1, nums2))  # 输出: [-1, 3, -1]
# 解释：
# 4 在 nums2 中右边没有更大的 → -1
# 1 在 nums2 中右边第一个更大是 3
# 2 在 nums2 中右边没有更大的 → -1
```

---

#### 二、单调队列（Monotonic Queue）

##### 2.1 什么是单调队列？

**一句话定义**：用双端队列（deque）维护一个窗口内的单调序列，队首始终是最值。

**生活类比**：想象你在排队买奶茶，窗口只能看到队伍里最高的 3 个人（窗口大小=3）。当新来一个人时：
- 如果前面的人比他矮，那些人就被"挡住"了，不可能成为窗口内最高——可以把他们去掉。
- 这样队伍从头到尾保持从高到矮（单调递减），队首就是最高的人。

##### 2.2 用途

单调队列专门解决**滑动窗口最值问题**：在一个固定大小的滑动窗口中，快速找到最大值或最小值。

##### 2.3 Python 实现

```python
from collections import deque

class MonotonicQueue:
    """
    单调队列：维护一个单调递减的队列
    队首始终是最大值
    
    支持操作：
    - push(val): 加入元素，自动维护单调性
    - pop(val): 移除滑出窗口的元素
    - max(): 获取当前窗口最大值
    """
    def __init__(self):
        # 双端队列，存储的是值（也可以存下标）
        self.deque = deque()
    
    def push(self, val):
        """加入元素：把比 val 小的都从队尾弹出，然后 val 入队"""
        while self.deque and self.deque[-1] < val:
            self.deque.pop()       # 从队尾弹出比 val 小的
        self.deque.append(val)
    
    def pop(self, val):
        """移除元素：如果队首就是要移除的值，就弹出"""
        if self.deque and self.deque[0] == val:
            self.deque.popleft()   # 从队首弹出
    
    def max(self):
        """获取当前最大值：就是队首元素"""
        return self.deque[0]
```

##### 2.4 经典例题：滑动窗口最大值（LeetCode 239）

**题目**：给你一个整数数组 `nums` 和一个整数 `k`，有一个大小为 `k` 的滑动窗口从数组最左侧滑动到最右侧。返回每个窗口中的最大值。

**示例**：
```
输入：nums = [1, 3, -1, -3, 5, 3, 6, 7], k = 3
输出：[3, 3, 5, 5, 6, 7]

解释：
窗口位置                   最大值
[1  3  -1] -3  5  3  6  7    3
 1 [3  -1  -3] 5  3  6  7    3
 1  3 [-1  -3  5] 3  6  7    5
 1  3  -1 [-3  5  3] 6  7    5
 1  3  -1  -3 [5  3  6] 7    6
 1  3  -1  -3  5 [3  6  7]   7
```

```python
from collections import deque

def maxSlidingWindow(nums, k):
    """
    LeetCode 239. 滑动窗口最大值
    
    思路：用单调队列（存下标），队首始终是当前窗口的最大值的下标。
    
    为什么存下标而不是值？
    → 因为需要判断队首元素是否已经"滑出"窗口。
    
    时间复杂度：O(n)，每个元素最多入队出队各一次
    空间复杂度：O(k)，队列最多存 k 个元素
    """
    if not nums or k == 0:
        return []
    
    result = []
    # 双端队列存储下标，对应的值从队首到队尾单调递减
    dq = deque()
    
    for i in range(len(nums)):
        # 步骤1：移除已经滑出窗口的队首元素
        if dq and dq[0] < i - k + 1:
            dq.popleft()
        
        # 步骤2：维护单调性——从队尾弹出比当前元素小的
        while dq and nums[dq[-1]] < nums[i]:
            dq.pop()
        
        # 步骤3：当前元素下标入队
        dq.append(i)
        
        # 步骤4：当窗口形成后（i >= k-1），记录队首（最大值）
        if i >= k - 1:
            result.append(nums[dq[0]])
    
    return result

# 测试
nums = [1, 3, -1, -3, 5, 3, 6, 7]
k = 3
print(maxSlidingWindow(nums, k))  # 输出: [3, 3, 5, 5, 6, 7]

# 逐步模拟前几个窗口：
# i=0, nums[0]=1:  dq=[0]
# i=1, nums[1]=3:  3>1，弹出0，dq=[1]
# i=2, nums[2]=-1: -1<3，dq=[1,2]，窗口形成，max=nums[1]=3 ✓
# i=3, nums[3]=-3: -3<-1，dq=[1,2,3]，但dq[0]=1 < 3-3+1=1？不小于，
#   等等，dq[0]=1，i-k+1=3-3+1=1，1>=1，不弹出。
#   但nums[dq[0]]=nums[1]=3，max=3 ✓
# i=4, nums[4]=5:  dq[0]=1 < 4-3+1=2，弹出1
#   5>-1，弹出2；5>-3，弹出3；dq=[4]，max=nums[4]=5 ✓
```

---

#### 三、线段树（Segment Tree）

##### 3.1 什么是线段树？

**一句话定义**：一种二叉树结构，每个节点代表一个区间，用于高效处理**区间查询**和**区间/单点更新**。

**生活类比**：想象一个班级的成绩管理系统。老师经常问两类问题：
1. "第3号到第10号同学的总分是多少？"（区间查询）
2. "第5号同学的成绩改一下，改成95分。"（单点更新）

如果直接遍历，每次查询 O(n)。线段树可以把查询和更新都优化到 O(log n)。

##### 3.2 核心思想

线段树用数组表示一棵**完全二叉树**：
- 根节点代表整个区间 `[0, n-1]`
- 每个内部节点代表一个区间，将其分成两半
- 叶子节点代表单个元素
- 节点 `i` 的左孩子是 `2i+1`，右孩子是 `2i+2`

```
区间 [0, 3] 的线段树（数组表示）：

           [0,3] sum=10
          /              \
     [0,1] sum=3      [2,3] sum=7
     /      \          /      \
 [0,0] 3  [1,1] 0  [2,2] 2  [3,3] 5

数组: [10, 3, 7, 3, 0, 2, 5]
       0   1  2  3  4  5  6
```

##### 3.3 Python 完整实现

```python
class SegmentTree:
    """
    线段树实现（数组形式）
    支持：单点更新、区间求和查询
    """
    
    def __init__(self, nums):
        """
        建树
        nums: 原始数组
        """
        self.n = len(nums)
        self.tree = [0] * (4 * self.n)  # 开4倍空间保证够用
        if self.n > 0:
            self._build(nums, 0, 0, self.n - 1)
    
    def _build(self, nums, node, start, end):
        """
        递归建树
        node: 当前节点在数组中的下标
        start, end: 当前节点代表的区间
        """
        if start == end:
            # 叶子节点，直接赋值
            self.tree[node] = nums[start]
        else:
            mid = (start + end) // 2
            left_child = 2 * node + 1    # 左孩子下标
            right_child = 2 * node + 2   # 右孩子下标
            # 递归建左右子树
            self._build(nums, left_child, start, mid)
            self._build(nums, right_child, mid + 1, end)
            # 当前节点 = 左右孩子的和
            self.tree[node] = self.tree[left_child] + self.tree[right_child]
    
    def update(self, index, val, node=0, start=None, end=None):
        """
        单点更新：将 nums[index] 改为 val
        """
        if start is None:
            start, end = 0, self.n - 1
        
        if start == end:
            # 到达叶子节点，更新值
            self.tree[node] = val
        else:
            mid = (start + end) // 2
            left_child = 2 * node + 1
            right_child = 2 * node + 2
            
            if index <= mid:
                # 目标在左子树
                self.update(index, val, left_child, start, mid)
            else:
                # 目标在右子树
                self.update(index, val, right_child, mid + 1, end)
            
            # 更新当前节点的值
            self.tree[node] = self.tree[left_child] + self.tree[right_child]
    
    def query(self, l, r, node=0, start=None, end=None):
        """
        区间查询：求 nums[l..r] 的和
        """
        if start is None:
            start, end = 0, self.n - 1
        
        if r < start or end < l:
            # 当前区间与查询区间完全不相交
            return 0
        
        if l <= start and end <= r:
            # 当前区间完全包含在查询区间内
            return self.tree[node]
        
        # 部分重叠，递归查询左右子树
        mid = (start + end) // 2
        left_sum = self.query(l, r, 2 * node + 1, start, mid)
        right_sum = self.query(l, r, 2 * node + 2, mid + 1, end)
        return left_sum + right_sum
```

##### 3.4 经典例题：区域和检索 - 数组可修改（LeetCode 307）

```python
class NumArray:
    """
    LeetCode 307. 区域和检索 - 数组可修改
    
    使用线段树实现：
    - update(index, val): 将 nums[index] 改为 val
    - sumRange(left, right): 求 nums[left..right] 的和
    
    两个操作的时间复杂度都是 O(log n)
    """
    
    def __init__(self, nums):
        self.n = len(nums)
        self.tree = [0] * (4 * self.n)
        if self.n > 0:
            self._build(nums, 0, 0, self.n - 1)
    
    def _build(self, nums, node, start, end):
        if start == end:
            self.tree[node] = nums[start]
        else:
            mid = (start + end) // 2
            self._build(nums, 2*node+1, start, mid)
            self._build(nums, 2*node+2, mid+1, end)
            self.tree[node] = self.tree[2*node+1] + self.tree[2*node+2]
    
    def update(self, index, val):
        self._update(index, val, 0, 0, self.n - 1)
    
    def _update(self, index, val, node, start, end):
        if start == end:
            self.tree[node] = val
        else:
            mid = (start + end) // 2
            if index <= mid:
                self._update(index, val, 2*node+1, start, mid)
            else:
                self._update(index, val, 2*node+2, mid+1, end)
            self.tree[node] = self.tree[2*node+1] + self.tree[2*node+2]
    
    def sumRange(self, left, right):
        return self._query(left, right, 0, 0, self.n - 1)
    
    def _query(self, l, r, node, start, end):
        if r < start or end < l:
            return 0
        if l <= start and end <= r:
            return self.tree[node]
        mid = (start + end) // 2
        return self._query(l, r, 2*node+1, start, mid) + \
               self._query(l, r, 2*node+2, mid+1, end)

# 测试
obj = NumArray([1, 3, 5])
print(obj.sumRange(0, 2))  # 输出: 9  (1+3+5)
obj.update(1, 2)           # 数组变为 [1, 2, 5]
print(obj.sumRange(0, 2))  # 输出: 8  (1+2+5)
```

##### 3.5 区间更新与懒传播（Lazy Propagation）简介

如果需要**给一个区间内所有元素都加上一个值**，逐个更新太慢。懒传播的思想是：
- 不急着把更新传递到每个叶子，而是先在节点上打一个"懒标记"
- 等真正需要用到子节点时，再把标记传下去

```python
class SegmentTreeLazy:
    """
    支持区间更新 + 区间查询的线段树（懒传播）
    """
    def __init__(self, nums):
        self.n = len(nums)
        self.tree = [0] * (4 * self.n)  # 存储区间和
        self.lazy = [0] * (4 * self.n)  # 懒标记：待传递给子节点的值
        if self.n > 0:
            self._build(nums, 0, 0, self.n - 1)
    
    def _build(self, nums, node, start, end):
        if start == end:
            self.tree[node] = nums[start]
        else:
            mid = (start + end) // 2
            self._build(nums, 2*node+1, start, mid)
            self._build(nums, 2*node+2, mid+1, end)
            self.tree[node] = self.tree[2*node+1] + self.tree[2*node+2]
    
    def _push_down(self, node, start, end):
        """将懒标记下传给子节点"""
        if self.lazy[node] != 0:
            mid = (start + end) // 2
            left = 2 * node + 1
            right = 2 * node + 2
            # 更新左孩子
            self.tree[left] += self.lazy[node] * (mid - start + 1)
            self.lazy[left] += self.lazy[node]
            # 更新右孩子
            self.tree[right] += self.lazy[node] * (end - mid)
            self.lazy[right] += self.lazy[node]
            # 清除当前节点的懒标记
            self.lazy[node] = 0
    
    def range_update(self, l, r, val, node=0, start=None, end=None):
        """区间更新：给 nums[l..r] 的每个元素加上 val"""
        if start is None:
            start, end = 0, self.n - 1
        
        if l <= start and end <= r:
            # 当前区间完全被覆盖
            self.tree[node] += val * (end - start + 1)
            self.lazy[node] += val
            return
        
        self._push_down(node, start, end)  # 先下传标记
        mid = (start + end) // 2
        if l <= mid:
            self.range_update(l, r, val, 2*node+1, start, mid)
        if r > mid:
            self.range_update(l, r, val, 2*node+2, mid+1, end)
        self.tree[node] = self.tree[2*node+1] + self.tree[2*node+2]
    
    def query(self, l, r, node=0, start=None, end=None):
        """区间查询"""
        if start is None:
            start, end = 0, self.n - 1
        
        if r < start or end < l:
            return 0
        if l <= start and end <= r:
            return self.tree[node]
        
        self._push_down(node, start, end)
        mid = (start + end) // 2
        return self.query(l, r, 2*node+1, start, mid) + \
               self.query(l, r, 2*node+2, mid+1, end)
```

##### 3.6 复杂度分析

| 操作 | 时间复杂度 | 说明 |
|------|-----------|------|
| 建树 | O(n) | 遍历所有节点 |
| 单点更新 | O(log n) | 从根到叶子的路径长度 |
| 区间查询 | O(log n) | 最多访问 4 个节点每层 |
| 区间更新（懒传播）| O(log n) | 同上 |
| 空间复杂度 | O(n) | 4n 的数组 |

---

#### 四、树状数组（Binary Indexed Tree / Fenwick Tree）

##### 4.1 什么是树状数组？

**一句话定义**：一种比线段树更简单的数据结构，同样支持高效的**前缀和查询**和**单点更新**。

**核心优势**：代码极短，常数小，写起来不容易出错。

##### 4.2 核心：lowbit 运算

```python
def lowbit(x):
    """
    lowbit(x) = x & (-x)
    
    作用：取出 x 二进制表示中最低位的 1
    
    例子：
    x = 6  → 二进制 110
    -x     → 二进制 010（补码）
    x & -x → 二进制 010 = 2
    
    x = 8  → 二进制 1000
    -x     → 二进制 1000（补码）
    x & -x → 二进制 1000 = 8
    """
    return x & (-x)

# 测试
print(lowbit(6))   # 输出: 2
print(lowbit(8))   # 输出: 8
print(lowbit(12))  # 输出: 4（12 = 1100，最低位1在第3位 = 4）
```

**理解 lowbit**：树状数组的"树"就藏在二进制里。`lowbit(x)` 决定了节点 `x` 管理的区间长度。

##### 4.3 Python 实现

```python
class BinaryIndexedTree:
    """
    树状数组（Fenwick Tree）
    
    支持：
    - update(i, delta): 给位置 i 加上 delta
    - query(i): 求前缀和 sum(1..i)
    - range_query(l, r): 求区间和 sum(l..r)
    
    注意：树状数组下标从 1 开始！
    """
    
    def __init__(self, n):
        """初始化大小为 n 的树状数组（下标 1~n）"""
        self.n = n
        self.tree = [0] * (n + 1)  # 下标从1开始
    
    def update(self, i, delta):
        """
        单点更新：给位置 i 加上 delta
        
        原理：沿着 i → i+lowbit(i) → ... 一路更新到 n
        """
        while i <= self.n:
            self.tree[i] += delta
            i += i & (-i)  # i 加上 lowbit(i)，跳到父节点
    
    def query(self, i):
        """
        前缀和查询：求 sum(1..i)
        
        原理：沿着 i → i-lowbit(i) → ... 一路累加到 0
        """
        s = 0
        while i > 0:
            s += self.tree[i]
            i -= i & (-i)  # i 减去 lowbit(i)，跳到上一个区间
        return s
    
    def range_query(self, l, r):
        """
        区间查询：求 sum(l..r)
        利用前缀和之差：sum(l..r) = query(r) - query(l-1)
        """
        return self.query(r) - self.query(l - 1)


# 便捷构造：从数组初始化
def build_bit(nums):
    """从 0-indexed 数组构建树状数组"""
    bit = BinaryIndexedTree(len(nums))
    for i, val in enumerate(nums):
        bit.update(i + 1, val)  # 注意下标偏移 +1
    return bit


# 测试
nums = [1, 3, 5, 7, 9]
bit = build_bit(nums)

print(bit.query(3))        # 前缀和 1+3+5 = 9
print(bit.range_query(2, 4))  # 区间和 3+5+7 = 15

bit.update(3, 2)           # 位置3（值5）加上2，变成7
print(bit.query(3))        # 前缀和 1+3+7 = 11
```

##### 4.4 树状数组 vs 线段树

| 对比项 | 树状数组 | 线段树 |
|--------|---------|--------|
| 代码量 | 极少（~10行核心） | 较多（~50行） |
| 常数 | 很小，速度快 | 较大 |
| 功能 | 前缀和/单点更新 | 任意区间查询/更新 |
| 区间更新 | 需要技巧（差分） | 天然支持（懒传播） |
| 可维护信息 | 仅限可"减"的信息（如求和） | 任意（求和、最值、GCD等） |
| 空间 | O(n) | O(4n) |
| 推荐场景 | 前缀和类问题 | 复杂区间操作 |

**经验法则**：能用树状数组解决的，优先用树状数组（代码短、速度快）。需要区间更新或维护最值时，才用线段树。

---

#### 五、跳表（Skip List）

##### 5.1 什么是跳表？

**一句话定义**：在有序链表的基础上，增加多层"快速通道"，实现 O(log n) 的查找。

**生活类比——地铁快线**：

想象你要从城市最西边到最东边：
- **普通链表** = 一站一站的公交车，每站都停 → O(n)
- **跳表** = 地铁系统：
  - 1号线（最底层）：每站都停
  - 2号线（中间层）：只停大站
  - 3号线（最顶层）：只停起点和终点

你先坐3号线快速跳过大部分路程，再换乘2号线，最后换1号线到达目的地。这就是跳表的核心思想！

```
跳表结构示意（查找元素 7）：

Level 2:  1 ──────────────────────── 9         → 大步跳过
Level 1:  1 ────── 4 ────── 7 ────── 9        → 中步跳跃
Level 0:  1 → 3 → 4 → 5 → 7 → 8 → 9 → 12    → 逐步遍历

查找路径：1 →(Level2)→ 9 太大 → 退回1 →(Level1)→ 4 → 7 找到！
```

##### 5.2 Python 简单实现

```python
import random

class SkipNode:
    """跳表节点"""
    def __init__(self, key, level):
        self.key = key           # 存储的值
        self.forward = [None] * (level + 1)  # 每一层的指针


class SkipList:
    """
    跳表简单实现
    支持：插入、查找、删除
    期望时间复杂度：O(log n)
    """
    
    def __init__(self, max_level=16, p=0.5):
        """
        max_level: 最大层数
        p: 升层概率（每个节点有 p 的概率多一层）
        """
        self.max_level = max_level
        self.p = p
        self.current_level = 0  # 当前实际最高层数
        # 头节点：哨兵节点，不存储实际数据
        self.head = SkipNode(None, max_level)
    
    def _random_level(self):
        """随机生成层数，概率递减"""
        level = 0
        while random.random() < self.p and level < self.max_level:
            level += 1
        return level
    
    def search(self, key):
        """
        查找：从最高层开始，逐层向下
        时间复杂度：O(log n)
        """
        current = self.head
        
        # 从最高层开始，向右走，直到下一个节点 >= key
        for i in range(self.current_level, -1, -1):
            while current.forward[i] and current.forward[i].key < key:
                current = current.forward[i]
        
        # 到达最底层，检查下一个节点是否就是目标
        current = current.forward[0]
        if current and current.key == key:
            return True
        return False
    
    def insert(self, key):
        """
        插入：找到每层的插入位置，更新指针
        时间复杂度：O(log n)
        """
        # update[i] 记录第 i 层中，新节点应该接在哪个节点后面
        update = [None] * (self.max_level + 1)
        current = self.head
        
        for i in range(self.current_level, -1, -1):
            while current.forward[i] and current.forward[i].key < key:
                current = current.forward[i]
            update[i] = current
        
        # 随机决定新节点的层数
        level = self._random_level()
        
        # 如果新节点层数超过当前最高层，更新 update
        if level > self.current_level:
            for i in range(self.current_level + 1, level + 1):
                update[i] = self.head
            self.current_level = level
        
        # 创建新节点
        new_node = SkipNode(key, level)
        
        # 在每一层插入新节点
        for i in range(level + 1):
            new_node.forward[i] = update[i].forward[i]
            update[i].forward[i] = new_node
    
    def display(self):
        """打印跳表结构，方便可视化"""
        for i in range(self.current_level, -1, -1):
            current = self.head.forward[i]
            keys = []
            while current:
                keys.append(str(current.key))
                current = current.forward[i]
            print(f"Level {i}: {' -> '.join(keys)}")


# 测试
sl = SkipList()
for key in [3, 6, 1, 8, 4, 12, 7, 9, 5]:
    sl.insert(key)

print("=== 跳表结构 ===")
sl.display()

print("\n=== 查找测试 ===")
print(f"查找 7: {sl.search(7)}")   # True
print(f"查找 10: {sl.search(10)}")  # False
print(f"查找 1: {sl.search(1)}")    # True
```

##### 5.3 跳表的应用

跳表最著名的应用是 **Redis 的有序集合（Sorted Set / ZSet）**：

- Redis 用跳表来存储有序集合的底层数据
- 支持 O(log n) 的插入、删除、按分数范围查询
- 相比平衡树（如红黑树），跳表实现更简单，范围查询更方便

为什么 Redis 选择跳表而不是红黑树？
1. 跳表实现简单，容易调试
2. 范围查询时，跳表只需找到起点后沿链表遍历
3. 通过调整层数概率，可以灵活平衡时间和空间

---


### 主题21 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、单调栈

```typescript
// ========== 1. 单调栈模板：找每个元素右边第一个比它大的元素 ==========
function monotonicStackTemplate(nums: number[]): number[] {
    const n = nums.length;
    const answer = new Array<number>(n).fill(-1); // 默认-1，表示找不到
    const stack: number[] = []; // 栈中存储的是【下标】，不是值！

    for (let i = 0; i < n; i++) {
        // 当前元素比栈顶元素大 → 栈顶元素找到了"右边第一个更大元素"
        while (stack.length > 0 && nums[i] > nums[stack[stack.length - 1]]) {
            const idx = stack.pop()!;
            answer[idx] = nums[i];
        }
        stack.push(i);
    }
    return answer;
}
console.log(monotonicStackTemplate([2, 1, 2, 4, 3])); // [4, 2, 4, -1, -1]

// ========== 每日温度（LeetCode 739） ==========
// 找右边第一个更大元素，需要的是距离（下标差）
function dailyTemperatures(temperatures: number[]): number[] {
    const n = temperatures.length;
    const answer = new Array<number>(n).fill(0);
    const stack: number[] = []; // 单调递减栈，存下标

    for (let i = 0; i < n; i++) {
        // 当前温度比栈顶高 → 栈顶那一天"等到了"更暖的一天
        while (stack.length > 0 && temperatures[i] > temperatures[stack[stack.length - 1]]) {
            const prevIdx = stack.pop()!;
            answer[prevIdx] = i - prevIdx; // 等待天数 = 当前下标 - 之前的下标
        }
        stack.push(i);
    }
    return answer;
}
console.log(dailyTemperatures([73, 74, 75, 71, 69, 72, 76, 73])); // [1,1,4,2,1,1,0,0]

// ========== 下一个更大元素 I（LeetCode 496） ==========
// 先用单调栈处理nums2并记录哈希表，再查nums1
function nextGreaterElement(nums1: number[], nums2: number[]): number[] {
    const nextGreater = new Map<number, number>(); // 元素 → 右边第一个更大元素
    const stack: number[] = []; // 单调递减栈

    for (const num of nums2) {
        while (stack.length > 0 && num > stack[stack.length - 1]) {
            const smaller = stack.pop()!;
            nextGreater.set(smaller, num); // 记录答案
        }
        stack.push(num);
    }
    // 栈中剩余元素没有"下一个更大元素"，不加入哈希表即可
    return nums1.map(num => nextGreater.get(num) ?? -1);
}
console.log(nextGreaterElement([4, 1, 2], [1, 3, 4, 2])); // [-1, 3, -1]
```

##### 二、单调队列与滑动窗口最大值

```typescript
// ========== 2. 滑动窗口最大值（LeetCode 239）- 单调队列 ==========
function maxSlidingWindow(nums: number[], k: number): number[] {
    if (nums.length === 0 || k === 0) return [];

    const result: number[] = [];
    // 双端队列（用数组模拟）存下标，值从队首到队尾单调递减
    const dq: number[] = [];

    for (let i = 0; i < nums.length; i++) {
        // 步骤1：移除已经滑出窗口的队首元素
        if (dq.length > 0 && dq[0] < i - k + 1) dq.shift();

        // 步骤2：维护单调性——从队尾弹出比当前元素小的
        while (dq.length > 0 && nums[dq[dq.length - 1]] < nums[i]) dq.pop();

        // 步骤3：当前元素下标入队
        dq.push(i);

        // 步骤4：窗口形成后（i >= k-1），队首即最大值
        if (i >= k - 1) result.push(nums[dq[0]]);
    }
    return result;
}
console.log(maxSlidingWindow([1, 3, -1, -3, 5, 3, 6, 7], 3)); // [3,3,5,5,6,7]
```

##### 三、线段树

```typescript
// ========== 3. 线段树：单点更新 + 区间求和 ==========
class SegmentTree {
    private tree: number[];
    private n: number;

    constructor(nums: number[]) {
        this.n = nums.length;
        this.tree = new Array<number>(4 * this.n).fill(0); // 开4倍空间
        if (this.n > 0) this.build(nums, 0, 0, this.n - 1);
    }

    // 递归建树
    private build(nums: number[], node: number, start: number, end: number): void {
        if (start === end) {
            this.tree[node] = nums[start]; // 叶子节点
        } else {
            const mid = Math.floor((start + end) / 2);
            const left = 2 * node + 1;
            const right = 2 * node + 2;
            this.build(nums, left, start, mid);
            this.build(nums, right, mid + 1, end);
            this.tree[node] = this.tree[left] + this.tree[right];
        }
    }

    // 单点更新：将 nums[index] 改为 val
    update(index: number, val: number): void {
        this.updateHelper(index, val, 0, 0, this.n - 1);
    }

    private updateHelper(index: number, val: number, node: number, start: number, end: number): void {
        if (start === end) {
            this.tree[node] = val; // 到达叶子节点
            return;
        }
        const mid = Math.floor((start + end) / 2);
        const left = 2 * node + 1;
        const right = 2 * node + 2;
        if (index <= mid) {
            this.updateHelper(index, val, left, start, mid);
        } else {
            this.updateHelper(index, val, right, mid + 1, end);
        }
        this.tree[node] = this.tree[left] + this.tree[right];
    }

    // 区间查询：求 nums[l..r] 的和
    query(l: number, r: number): number {
        return this.queryHelper(l, r, 0, 0, this.n - 1);
    }

    private queryHelper(l: number, r: number, node: number, start: number, end: number): number {
        if (r < start || end < l) return 0; // 完全不相交
        if (l <= start && end <= r) return this.tree[node]; // 完全包含
        // 部分重叠，递归查询左右子树
        const mid = Math.floor((start + end) / 2);
        return this.queryHelper(l, r, 2 * node + 1, start, mid) +
               this.queryHelper(l, r, 2 * node + 2, mid + 1, end);
    }
}

// 测试（LeetCode 307 区域和检索）
const seg = new SegmentTree([1, 3, 5]);
console.log(seg.query(0, 2)); // 9 (1+3+5)
seg.update(1, 2);             // 数组变为 [1, 2, 5]
console.log(seg.query(0, 2)); // 8 (1+2+5)
```

##### 四、树状数组

```typescript
// ========== 4. 树状数组（Fenwick Tree） ==========
// 注意：树状数组下标从 1 开始！
class BinaryIndexedTree {
    private tree: number[];
    private n: number;

    constructor(n: number) {
        this.n = n;
        this.tree = new Array<number>(n + 1).fill(0); // 下标从1开始
    }

    // 单点更新：给位置 i 加上 delta
    // 原理：沿着 i → i+lowbit(i) → ... 一路更新到 n
    update(i: number, delta: number): void {
        while (i <= this.n) {
            this.tree[i] += delta;
            i += i & -i; // lowbit，跳到父节点
        }
    }

    // 前缀和查询：求 sum(1..i)
    // 原理：沿着 i → i-lowbit(i) → ... 一路累加到 0
    query(i: number): number {
        let s = 0;
        while (i > 0) {
            s += this.tree[i];
            i -= i & -i; // 跳到上一个区间
        }
        return s;
    }

    // 区间查询：sum(l..r) = query(r) - query(l-1)
    rangeQuery(l: number, r: number): number {
        return this.query(r) - this.query(l - 1);
    }
}

// 测试
const numsBit = [1, 3, 5, 7, 9];
const bit = new BinaryIndexedTree(numsBit.length);
numsBit.forEach((v, i) => bit.update(i + 1, v)); // 注意下标偏移 +1

console.log(bit.query(3));         // 前缀和 1+3+5 = 9
console.log(bit.rangeQuery(2, 4)); // 区间和 3+5+7 = 15
bit.update(3, 2);                  // 位置3（值5）加上2，变成7
console.log(bit.query(3));         // 前缀和 1+3+7 = 11
```

##### 五、跳表

```typescript
// ========== 5. 跳表简单实现（Skip List） ==========
class SkipNode {
    key: number;
    forward: Array<SkipNode | null>; // 每一层的指针

    constructor(key: number, level: number) {
        this.key = key;
        this.forward = new Array<SkipNode | null>(level + 1).fill(null);
    }
}

class SkipList {
    private maxLevel: number;
    private p: number;               // 升层概率
    private currentLevel: number = 0; // 当前实际最高层数
    private head: SkipNode;          // 哨兵节点

    constructor(maxLevel: number = 16, p: number = 0.5) {
        this.maxLevel = maxLevel;
        this.p = p;
        this.head = new SkipNode(-Infinity, maxLevel);
    }

    // 随机生成层数，概率递减
    private randomLevel(): number {
        let level = 0;
        while (Math.random() < this.p && level < this.maxLevel) level++;
        return level;
    }

    // 查找：从最高层开始，逐层向下
    search(key: number): boolean {
        let current = this.head;
        for (let i = this.currentLevel; i >= 0; i--) {
            while (current.forward[i] && current.forward[i]!.key < key) {
                current = current.forward[i]!;
            }
        }
        // 到达最底层，检查下一个节点是否就是目标
        current = current.forward[0]!;
        return current !== null && current.key === key;
    }

    // 插入：找到每层的插入位置，更新指针
    insert(key: number): void {
        // update[i] 记录第 i 层中，新节点应该接在哪个节点后面
        const update: Array<SkipNode | null> = new Array(this.maxLevel + 1).fill(null);
        let current = this.head;

        for (let i = this.currentLevel; i >= 0; i--) {
            while (current.forward[i] && current.forward[i]!.key < key) {
                current = current.forward[i]!;
            }
            update[i] = current;
        }

        // 随机决定新节点的层数
        const level = this.randomLevel();
        // 如果新节点层数超过当前最高层，更新 update
        if (level > this.currentLevel) {
            for (let i = this.currentLevel + 1; i <= level; i++) {
                update[i] = this.head;
            }
            this.currentLevel = level;
        }

        // 在每一层插入新节点
        const newNode = new SkipNode(key, level);
        for (let i = 0; i <= level; i++) {
            newNode.forward[i] = update[i]!.forward[i];
            update[i]!.forward[i] = newNode;
        }
    }
}

// 测试
const skipList = new SkipList();
[3, 6, 1, 8, 4, 12, 7, 9, 5].forEach(k => skipList.insert(k));
console.log(`查找 7: ${skipList.search(7)}`);   // true
console.log(`查找 10: ${skipList.search(10)}`); // false
console.log(`查找 1: ${skipList.search(1)}`);   // true
```


### 主题21 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、单调栈

```go
package main

import "fmt"

// ========== 1. 单调栈模板：找每个元素右边第一个比它大的元素 ==========
func monotonicStackTemplate(nums []int) []int {
	n := len(nums)
	answer := make([]int, n)
	for i := range answer {
		answer[i] = -1 // 默认-1，表示找不到
	}
	stack := []int{} // 栈中存储的是【下标】，不是值！

	for i := 0; i < n; i++ {
		// 当前元素比栈顶元素大 → 栈顶元素找到了"右边第一个更大元素"
		for len(stack) > 0 && nums[i] > nums[stack[len(stack)-1]] {
			idx := stack[len(stack)-1]
			stack = stack[:len(stack)-1]
			answer[idx] = nums[i]
		}
		stack = append(stack, i)
	}
	return answer
}

// ========== 每日温度（LeetCode 739） ==========
// 找右边第一个更大元素，需要的是距离（下标差）
func dailyTemperatures(temperatures []int) []int {
	n := len(temperatures)
	answer := make([]int, n) // 结果数组，默认0
	stack := []int{}         // 单调递减栈，存下标

	for i := 0; i < n; i++ {
		// 当前温度比栈顶高 → 栈顶那一天"等到了"更暖的一天
		for len(stack) > 0 && temperatures[i] > temperatures[stack[len(stack)-1]] {
			prevIdx := stack[len(stack)-1]
			stack = stack[:len(stack)-1]
			answer[prevIdx] = i - prevIdx // 等待天数 = 当前下标 - 之前的下标
		}
		stack = append(stack, i)
	}
	return answer
}

// ========== 下一个更大元素 I（LeetCode 496） ==========
// 先用单调栈处理nums2并记录哈希表，再查nums1
func nextGreaterElement(nums1, nums2 []int) []int {
	nextGreater := make(map[int]int) // 元素 → 右边第一个更大元素
	stack := []int{}                 // 单调递减栈（存值）

	for _, num := range nums2 {
		for len(stack) > 0 && num > stack[len(stack)-1] {
			smaller := stack[len(stack)-1]
			stack = stack[:len(stack)-1]
			nextGreater[smaller] = num // 记录答案
		}
		stack = append(stack, num)
	}
	// 栈中剩余元素没有"下一个更大元素"，不加入哈希表即可

	answer := make([]int, len(nums1))
	for i, num := range nums1 {
		if v, ok := nextGreater[num]; ok {
			answer[i] = v
		} else {
			answer[i] = -1 // 找不到返回-1
		}
	}
	return answer
}

func testMonotonic() {
	fmt.Println(monotonicStackTemplate([]int{2, 1, 2, 4, 3})) // [4 2 4 -1 -1]
	fmt.Println(dailyTemperatures([]int{73, 74, 75, 71, 69, 72, 76, 73})) // [1 1 4 2 1 1 0 0]
	fmt.Println(nextGreaterElement([]int{4, 1, 2}, []int{1, 3, 4, 2}))    // [-1 3 -1]
}
```

##### 二、单调队列与滑动窗口最大值

```go
package main

import "fmt"

// ========== 2. 滑动窗口最大值（LeetCode 239）- 单调队列 ==========
func maxSlidingWindow(nums []int, k int) []int {
	if len(nums) == 0 || k == 0 {
		return []int{}
	}

	result := []int{}
	dq := []int{} // 双端队列（用切片模拟）存下标，值从队首到队尾单调递减

	for i := 0; i < len(nums); i++ {
		// 步骤1：移除已经滑出窗口的队首元素
		if len(dq) > 0 && dq[0] < i-k+1 {
			dq = dq[1:] // 队首出队
		}

		// 步骤2：维护单调性——从队尾弹出比当前元素小的
		for len(dq) > 0 && nums[dq[len(dq)-1]] < nums[i] {
			dq = dq[:len(dq)-1]
		}

		// 步骤3：当前元素下标入队
		dq = append(dq, i)

		// 步骤4：窗口形成后（i >= k-1），队首即最大值
		if i >= k-1 {
			result = append(result, nums[dq[0]])
		}
	}
	return result
}

func testMaxSlidingWindow() {
	fmt.Println(maxSlidingWindow([]int{1, 3, -1, -3, 5, 3, 6, 7}, 3)) // [3 3 5 5 6 7]
}
```

##### 三、线段树

```go
package main

import "fmt"

// ========== 3. 线段树：单点更新 + 区间求和 ==========
type SegmentTree struct {
	tree []int
	n    int
}

func NewSegmentTree(nums []int) *SegmentTree {
	st := &SegmentTree{
		tree: make([]int, 4*len(nums)), // 开4倍空间
		n:    len(nums),
	}
	if st.n > 0 {
		st.build(nums, 0, 0, st.n-1)
	}
	return st
}

// 递归建树
func (st *SegmentTree) build(nums []int, node, start, end int) {
	if start == end {
		st.tree[node] = nums[start] // 叶子节点
		return
	}
	mid := (start + end) / 2
	left, right := 2*node+1, 2*node+2
	st.build(nums, left, start, mid)
	st.build(nums, right, mid+1, end)
	st.tree[node] = st.tree[left] + st.tree[right]
}

// 单点更新：将 nums[index] 改为 val
func (st *SegmentTree) Update(index, val int) {
	st.updateHelper(index, val, 0, 0, st.n-1)
}

func (st *SegmentTree) updateHelper(index, val, node, start, end int) {
	if start == end {
		st.tree[node] = val // 到达叶子节点
		return
	}
	mid := (start + end) / 2
	left, right := 2*node+1, 2*node+2
	if index <= mid {
		st.updateHelper(index, val, left, start, mid)
	} else {
		st.updateHelper(index, val, right, mid+1, end)
	}
	st.tree[node] = st.tree[left] + st.tree[right]
}

// 区间查询：求 nums[l..r] 的和
func (st *SegmentTree) Query(l, r int) int {
	return st.queryHelper(l, r, 0, 0, st.n-1)
}

func (st *SegmentTree) queryHelper(l, r, node, start, end int) int {
	if r < start || end < l {
		return 0 // 完全不相交
	}
	if l <= start && end <= r {
		return st.tree[node] // 完全包含
	}
	// 部分重叠，递归查询左右子树
	mid := (start + end) / 2
	return st.queryHelper(l, r, 2*node+1, start, mid) +
		st.queryHelper(l, r, 2*node+2, mid+1, end)
}

func testSegmentTree() {
	// 测试（LeetCode 307 区域和检索）
	st := NewSegmentTree([]int{1, 3, 5})
	fmt.Println(st.Query(0, 2)) // 9 (1+3+5)
	st.Update(1, 2)             // 数组变为 [1, 2, 5]
	fmt.Println(st.Query(0, 2)) // 8 (1+2+5)
}
```

##### 四、树状数组

```go
package main

import "fmt"

// ========== 4. 树状数组（Fenwick Tree） ==========
// 注意：树状数组下标从 1 开始！
type BinaryIndexedTree struct {
	tree []int
	n    int
}

func NewBinaryIndexedTree(n int) *BinaryIndexedTree {
	return &BinaryIndexedTree{
		tree: make([]int, n+1), // 下标从1开始
		n:    n,
	}
}

// 单点更新：给位置 i 加上 delta
// 原理：沿着 i → i+lowbit(i) → ... 一路更新到 n
func (bit *BinaryIndexedTree) Update(i, delta int) {
	for i <= bit.n {
		bit.tree[i] += delta
		i += i & (-i) // lowbit，跳到父节点
	}
}

// 前缀和查询：求 sum(1..i)
// 原理：沿着 i → i-lowbit(i) → ... 一路累加到 0
func (bit *BinaryIndexedTree) Query(i int) int {
	s := 0
	for i > 0 {
		s += bit.tree[i]
		i -= i & (-i) // 跳到上一个区间
	}
	return s
}

// 区间查询：sum(l..r) = query(r) - query(l-1)
func (bit *BinaryIndexedTree) RangeQuery(l, r int) int {
	return bit.Query(r) - bit.Query(l-1)
}

func testBit() {
	nums := []int{1, 3, 5, 7, 9}
	bit := NewBinaryIndexedTree(len(nums))
	// 从0-indexed数组构建：注意下标偏移 +1
	for i, v := range nums {
		bit.Update(i+1, v)
	}

	fmt.Println(bit.Query(3))         // 前缀和 1+3+5 = 9
	fmt.Println(bit.RangeQuery(2, 4)) // 区间和 3+5+7 = 15
	bit.Update(3, 2)                  // 位置3（值5）加上2，变成7
	fmt.Println(bit.Query(3))         // 前缀和 1+3+7 = 11
}
```

##### 五、跳表

```go
package main

import (
	"fmt"
	"math/rand"
)

// ========== 5. 跳表简单实现（Skip List） ==========
type SkipNode struct {
	key     int
	forward []*SkipNode // 每一层的指针
}

func NewSkipNode(key, level int) *SkipNode {
	return &SkipNode{
		key:     key,
		forward: make([]*SkipNode, level+1),
	}
}

type SkipList struct {
	maxLevel     int
	p            float64 // 升层概率
	currentLevel int     // 当前实际最高层数
	head         *SkipNode
}

func NewSkipList(maxLevel int, p float64) *SkipList {
	return &SkipList{
		maxLevel:     maxLevel,
		p:            p,
		currentLevel: 0,
		head:         NewSkipNode(-1<<63, maxLevel), // 哨兵节点（极小值）
	}
}

// 随机生成层数，概率递减
func (sl *SkipList) randomLevel() int {
	level := 0
	for rand.Float64() < sl.p && level < sl.maxLevel {
		level++
	}
	return level
}

// 查找：从最高层开始，逐层向下
func (sl *SkipList) Search(key int) bool {
	current := sl.head
	for i := sl.currentLevel; i >= 0; i-- {
		for current.forward[i] != nil && current.forward[i].key < key {
			current = current.forward[i]
		}
	}
	// 到达最底层，检查下一个节点是否就是目标
	current = current.forward[0]
	return current != nil && current.key == key
}

// 插入：找到每层的插入位置，更新指针
func (sl *SkipList) Insert(key int) {
	// update[i] 记录第 i 层中，新节点应该接在哪个节点后面
	update := make([]*SkipNode, sl.maxLevel+1)
	current := sl.head

	for i := sl.currentLevel; i >= 0; i-- {
		for current.forward[i] != nil && current.forward[i].key < key {
			current = current.forward[i]
		}
		update[i] = current
	}

	// 随机决定新节点的层数
	level := sl.randomLevel()
	// 如果新节点层数超过当前最高层，更新 update
	if level > sl.currentLevel {
		for i := sl.currentLevel + 1; i <= level; i++ {
			update[i] = sl.head
		}
		sl.currentLevel = level
	}

	// 在每一层插入新节点
	newNode := NewSkipNode(key, level)
	for i := 0; i <= level; i++ {
		newNode.forward[i] = update[i].forward[i]
		update[i].forward[i] = newNode
	}
}

func testSkipList() {
	sl := NewSkipList(16, 0.5)
	for _, k := range []int{3, 6, 1, 8, 4, 12, 7, 9, 5} {
		sl.Insert(k)
	}
	fmt.Println("查找 7:", sl.Search(7))   // true
	fmt.Println("查找 10:", sl.Search(10)) // false
	fmt.Println("查找 1:", sl.Search(1))   // true
}
```


### 主题22：算法设计思想总结


> 学完了各种数据结构和算法，最重要的不是背代码，而是掌握**算法设计思想**。面对一道新题，能快速判断该用什么思想，这才是真正的能力。

---

#### 一、六大算法思想对比

| 思想 | 核心思路 | 适用场景 | 典型问题 | 时间复杂度特征 |
|------|---------|---------|---------|--------------|
| **枚举/暴力** | 遍历所有可能，逐个检查 | 数据规模小（n ≤ 1000） | 两数之和（暴力）、素数判断 | 通常 O(n²) 或更高 |
| **贪心** | 每步选局部最优，期望全局最优 | 有贪心选择性质（需证明） | 活动选择、霍夫曼编码、找零钱 | 通常 O(n log n) |
| **分治** | 拆成独立子问题，合并结果 | 子问题相互独立 | 归并排序、快速幂、大整数乘法 | 通常 O(n log n) |
| **动态规划** | 拆成重叠子问题，记忆化避免重复 | 有最优子结构 + 重叠子问题 | 背包、LCS、编辑距离 | 通常 O(n²) 或 O(n³) |
| **回溯** | 穷举所有方案 + 剪枝 | 求所有/部分方案 | 排列、组合、N皇后、数独 | 指数级，但剪枝后快很多 |
| **搜索(DFS/BFS)** | 遍历状态空间图/树 | 图/树/迷宫/状态转移 | 最短路径、连通性、拓扑排序 | O(V+E) 或 O(V²) |

##### 各思想的详细解读

###### 1. 枚举/暴力

```python
# 两数之和 —— 暴力枚举
def twoSum_brute(nums, target):
    """
    遍历所有数对，检查和是否等于 target
    时间复杂度：O(n²)
    """
    n = len(nums)
    for i in range(n):
        for j in range(i + 1, n):
            if nums[i] + nums[j] == target:
                return [i, j]
    return []

# 虽然慢，但在数据规模小时完全可用
print(twoSum_brute([2, 7, 11, 15], 9))  # [0, 1]
```

###### 2. 贪心

```python
# 活动选择问题 —— 贪心
def activity_selection(activities):
    """
    活动选择：选最多的互不冲突的活动
    贪心策略：每次选结束时间最早的活动
    
    activities: [(开始时间, 结束时间), ...]
    """
    # 按结束时间排序（贪心的关键！）
    activities.sort(key=lambda x: x[1])
    
    selected = []
    last_end = 0
    
    for start, end in activities:
        if start >= last_end:  # 如果和已选活动不冲突
            selected.append((start, end))
            last_end = end     # 更新最后结束时间
    
    return selected

# 测试
acts = [(1, 4), (3, 5), (0, 6), (5, 7), (3, 9), (5, 9),
        (6, 10), (8, 11), (8, 12), (2, 14), (12, 16)]
print(activity_selection(acts))
# 输出: [(1, 4), (5, 7), (8, 11), (12, 16)]
```

###### 3. 分治

```python
# 快速幂 —— 分治
def fast_pow(base, exp):
    """
    计算 base^exp
    分治思想：base^exp = (base^(exp/2))^2  (exp为偶数)
              base^exp = base * base^(exp-1) (exp为奇数)
    
    时间复杂度：O(log exp)
    """
    if exp == 0:
        return 1
    if exp % 2 == 0:
        half = fast_pow(base, exp // 2)
        return half * half       # 合并两个相同子问题
    else:
        return base * fast_pow(base, exp - 1)

print(fast_pow(2, 10))  # 1024
```

###### 4. 动态规划

```python
# 0-1背包 —— 动态规划
def knapsack(weights, values, capacity):
    """
    0-1背包问题
    dp[i][w] = 前 i 个物品、容量为 w 时的最大价值
    状态转移：dp[i][w] = max(dp[i-1][w], dp[i-1][w-wi] + vi)
    """
    n = len(weights)
    # dp[w] 表示容量为 w 时的最大价值（空间优化为一维）
    dp = [0] * (capacity + 1)
    
    for i in range(n):
        # 倒序遍历，确保每个物品只用一次
        for w in range(capacity, weights[i] - 1, -1):
            dp[w] = max(dp[w], dp[w - weights[i]] + values[i])
    
    return dp[capacity]

print(knapsack([2, 3, 4, 5], [3, 4, 5, 6], 8))  # 10
```

###### 5. 回溯

```python
# 全排列 —— 回溯
def permute(nums):
    """
    全排列：回溯法的经典应用
    思路：依次选择每个位置的数，用过的标记，递归后撤销
    """
    result = []
    
    def backtrack(path, used):
        # 终止条件：路径长度等于数组长度
        if len(path) == len(nums):
            result.append(path[:])  # 注意要拷贝
            return
        
        for i in range(len(nums)):
            if used[i]:
                continue  # 跳过已使用的
            
            # 做选择
            used[i] = True
            path.append(nums[i])
            
            # 递归
            backtrack(path, used)
            
            # 撤销选择（回溯）
            path.pop()
            used[i] = False
    
    backtrack([], [False] * len(nums))
    return result

print(permute([1, 2, 3]))
# [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
```

###### 6. 搜索（DFS/BFS）

```python
from collections import deque

# 迷宫最短路径 —— BFS
def maze_shortest_path(maze, start, end):
    """
    BFS 求迷宫最短路径
    maze: 0=可走, 1=墙壁
    start, end: (行, 列)
    """
    rows, cols = len(maze), len(maze[0])
    queue = deque([(start[0], start[1], 0)])  # (行, 列, 步数)
    visited = set()
    visited.add(start)
    
    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]  # 上下左右
    
    while queue:
        r, c, dist = queue.popleft()
        
        if (r, c) == end:
            return dist  # 找到终点，返回步数
        
        for dr, dc in directions:
            nr, nc = r + dr, c + dc
            if 0 <= nr < rows and 0 <= nc < cols \
               and maze[nr][nc] == 0 and (nr, nc) not in visited:
                visited.add((nr, nc))
                queue.append((nr, nc, dist + 1))
    
    return -1  # 无法到达

# 测试
maze = [
    [0, 0, 1, 0],
    [1, 0, 0, 0],
    [0, 0, 1, 0],
    [0, 0, 0, 0]
]
print(maze_shortest_path(maze, (0, 0), (3, 3)))  # 输出: 6
```

---

#### 二、如何识别问题类型

面对一道算法题，最重要的是**快速判断它属于什么类型**。以下是识别口诀：

| 题目关键词 | 大概率算法 | 举例 |
|-----------|-----------|------|
| "所有方案/排列组合/子集" | **回溯** | 全排列、组合总和 |
| "最优/最大/最小/最少" | **DP 或贪心** | 最长递增子序列、零钱兑换 |
| "能否/是否存在" | **DP / BFS / 二分** | 单词拆分、路径存在 |
| "最短路径（无权）" | **BFS** | 迷宫最短路径 |
| "最短路径（有权）" | **Dijkstra** | 网络延迟时间 |
| "连通性/分组/合并" | **并查集 / DFS** | 岛屿数量、冗余连接 |
| "有序数组中查找" | **二分查找** | 搜索旋转排序数组 |
| "Top-K / 第K大" | **堆 / 快速选择** | 前K个高频元素 |
| "区间/连续子数组" | **前缀和 / 滑动窗口** | 和为K的子数组 |
| "字符串匹配" | **KMP / 哈希** | 实现strStr() |
| "树的遍历/路径" | **DFS / BFS** | 二叉树层序遍历 |
| "图着色/二分图" | **DFS + 染色** | 可能的二分法 |

##### 判断流程图

```
拿到题目
  │
  ├─ 求"所有方案"？ ──→ 回溯
  │
  ├─ 求"最优值"？
  │    ├─ 能贪心？（局部最优→全局最优）──→ 贪心
  │    └─ 不能贪心 ──→ DP
  │
  ├─ 求"是否存在/能否"？ ──→ DP / BFS / 二分
  │
  ├─ 求"最短路径"？
  │    ├─ 边权为1 ──→ BFS
  │    └─ 边权不为1 ──→ Dijkstra
  │
  ├─ 有序数组？ ──→ 二分 / 双指针
  │
  └─ 涉及集合合并？ ──→ 并查集
```

---

#### 三、同一问题的多种解法对比

##### 3.1 爬楼梯（LeetCode 70）

**题目**：每次可以爬 1 或 2 个台阶，问爬到第 n 阶有多少种方法。

###### 解法1：朴素递归（超时）

```python
def climbStairs_recursive(n):
    """
    递归：f(n) = f(n-1) + f(n-2)
    问题：大量重复计算
    时间复杂度：O(2^n) ← 指数级，n=40 就超时
    """
    if n <= 2:
        return n
    return climbStairs_recursive(n - 1) + climbStairs_recursive(n - 2)
```

###### 解法2：记忆化递归

```python
def climbStairs_memo(n, memo={}):
    """
    记忆化：用字典缓存已计算的结果
    时间复杂度：O(n)
    空间复杂度：O(n)
    """
    if n <= 2:
        return n
    if n in memo:
        return memo[n]
    memo[n] = climbStairs_memo(n - 1, memo) + climbStairs_memo(n - 2, memo)
    return memo[n]
```

###### 解法3：动态规划（推荐）

```python
def climbStairs_dp(n):
    """
    DP：自底向上，只用两个变量
    时间复杂度：O(n)
    空间复杂度：O(1) ← 最优！
    """
    if n <= 2:
        return n
    
    prev2 = 1  # f(n-2)
    prev1 = 2  # f(n-1)
    
    for i in range(3, n + 1):
        curr = prev1 + prev2  # f(n) = f(n-1) + f(n-2)
        prev2 = prev1         # 滚动更新
        prev1 = curr
    
    return prev1

print(climbStairs_dp(10))  # 89
```

###### 解法4：数学（矩阵快速幂 / 通项公式）

```python
import math

def climbStairs_math(n):
    """
    数学方法：斐波那契数列的通项公式
    f(n) = (1/√5) * [((1+√5)/2)^n - ((1-√5)/2)^n]
    
    注意：浮点精度问题，n 很大时可能不准
    时间复杂度：O(log n)（如果用快速幂）或 O(1)（直接用公式）
    """
    sqrt5 = math.sqrt(5)
    phi = (1 + sqrt5) / 2
    psi = (1 - sqrt5) / 2
    return round((phi ** (n + 1) - psi ** (n + 1)) / sqrt5)

print(climbStairs_math(10))  # 89
```

###### 四种解法对比

| 解法 | 时间复杂度 | 空间复杂度 | 实用性 |
|------|-----------|-----------|--------|
| 朴素递归 | O(2^n) | O(n) | 面试中展示思路 |
| 记忆化递归 | O(n) | O(n) | 通用技巧 |
| DP | O(n) | O(1) | **最推荐** |
| 数学公式 | O(1) | O(1) | 需要数学功底 |

##### 3.2 最长递增子序列（LeetCode 300）

**题目**：找到一个数组中最长严格递增子序列的长度。

###### 解法1：动态规划

```python
def lengthOfLIS_dp(nums):
    """
    DP 解法：
    dp[i] = 以 nums[i] 结尾的最长递增子序列长度
    状态转移：dp[i] = max(dp[j] + 1) 对所有 j < i 且 nums[j] < nums[i]
    
    时间复杂度：O(n²)
    空间复杂度：O(n)
    """
    if not nums:
        return 0
    
    n = len(nums)
    dp = [1] * n  # 每个元素自身构成长度为1的子序列
    
    for i in range(1, n):
        for j in range(i):
            if nums[j] < nums[i]:
                dp[i] = max(dp[i], dp[j] + 1)
    
    return max(dp)

print(lengthOfLIS_dp([10, 9, 2, 5, 3, 7, 101, 18]))  # 4
# 最长递增子序列是 [2, 3, 7, 101]
```

###### 解法2：贪心 + 二分查找

```python
import bisect

def lengthOfLIS_optimal(nums):
    """
    贪心 + 二分：
    维护一个 tails 数组，tails[i] 表示长度为 i+1 的递增子序列的最小末尾
    
    tails 始终保持递增，可以用二分查找更新
    
    时间复杂度：O(n log n) ← 更优！
    空间复杂度：O(n)
    """
    tails = []  # tails[i] = 长度为 i+1 的LIS的最小末尾元素
    
    for num in nums:
        # 二分查找 num 在 tails 中应该放的位置
        pos = bisect.bisect_left(tails, num)
        
        if pos == len(tails):
            # num 比所有末尾都大 → 可以延长最长子序列
            tails.append(num)
        else:
            # 替换 tails[pos]，让长度为 pos+1 的子序列末尾更小
            tails[pos] = num
    
    return len(tails)

print(lengthOfLIS_optimal([10, 9, 2, 5, 3, 7, 101, 18]))  # 4

# 模拟过程：
# num=10:  tails=[10]
# num=9:   tails=[9]       (9替换10，末尾更小)
# num=2:   tails=[2]       (2替换9)
# num=5:   tails=[2, 5]    (5比2大，追加)
# num=3:   tails=[2, 3]    (3替换5)
# num=7:   tails=[2, 3, 7] (7比3大，追加)
# num=101: tails=[2, 3, 7, 101] (101比7大，追加)
# num=18:  tails=[2, 3, 7, 18]  (18替换101)
# 最终长度 = 4 ✓
```

###### 两种解法对比

| 解法 | 时间复杂度 | 空间复杂度 | 难度 |
|------|-----------|-----------|------|
| DP | O(n²) | O(n) | 容易想到 |
| 贪心+二分 | O(n log n) | O(n) | 需要灵感 |

---

#### 四、学习路线建议

学完基础数据结构和算法后，可以继续深入的方向：

##### 进阶学习路线

```
基础阶段（你现在在这里）
  │
  ├─ 掌握六大算法思想
  ├─ 刷 LeetCode Hot 100
  └─ 熟悉常见模板
  │
  ▼
提高阶段
  │
  ├─ 高级数据结构：后缀数组、AC自动机、平衡树(Splay/Treap)
  ├─ 高级图论：网络流、二分图匹配、强连通分量(Tarjan)
  ├─ 高级DP：树形DP、状压DP、数位DP、插头DP
  ├─ 计算几何：凸包、线段交点、旋转卡壳
  └─ 字符串：KMP、Manacher、后缀自动机
  │
  ▼
竞赛/面试阶段
  │
  ├─ 竞赛方向：Codeforces 打比赛、洛谷月赛
  ├─ 面试方向：系统设计 + 算法综合题
  └─ 研究方向：根据兴趣选择（ML/数据库/编译器等）
```

##### 推荐资源

| 资源 | 适合阶段 | 说明 |
|------|---------|------|
| 《算法4》(Sedgewick) | 基础 | 经典教材，Java实现 |
| 《算法导论》(CLRS) | 进阶 | 理论严谨，适合深入理解 |
| 《算法竞赛入门经典》(刘汝佳) | 竞赛 | 内容全面，例题丰富 |
| LeetCode | 面试 | 按专题刷题，面试必备 |
| Codeforces | 竞赛 | 比赛制，提升实战能力 |
| 洛谷 | 入门~竞赛 | 中文社区，题解丰富 |

---


### 主题22 · TS 版实现（TypeScript 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、六大算法思想对照实现

```typescript
// ========== 1. 枚举/暴力：两数之和 ==========
function twoSumBrute(nums: number[], target: number): number[] {
    const n = nums.length;
    for (let i = 0; i < n; i++) {
        for (let j = i + 1; j < n; j++) {
            if (nums[i] + nums[j] === target) return [i, j];
        }
    }
    return [];
}
console.log(twoSumBrute([2, 7, 11, 15], 9)); // [0, 1]

// ========== 2. 贪心：活动选择 ==========
// 每次选结束时间最早的活动
function activitySelection(activities: [number, number][]): [number, number][] {
    activities.sort((a, b) => a[1] - b[1]); // 按结束时间排序（贪心关键）
    const selected: [number, number][] = [];
    let lastEnd = 0;
    for (const [start, end] of activities) {
        if (start >= lastEnd) { // 和已选活动不冲突
            selected.push([start, end]);
            lastEnd = end;
        }
    }
    return selected;
}
const acts: [number, number][] = [
    [1, 4], [3, 5], [0, 6], [5, 7], [3, 9], [5, 9],
    [6, 10], [8, 11], [8, 12], [2, 14], [12, 16],
];
console.log(activitySelection(acts));
// [[1,4],[5,7],[8,11],[12,16]]

// ========== 3. 分治：快速幂 ==========
// base^exp = (base^(exp/2))^2（偶数）；base * base^(exp-1)（奇数）
function fastPow(base: number, exp: number): number {
    if (exp === 0) return 1;
    if (exp % 2 === 0) {
        const half = fastPow(base, Math.floor(exp / 2));
        return half * half;
    } else {
        return base * fastPow(base, exp - 1);
    }
}
console.log(fastPow(2, 10)); // 1024

// ========== 4. 动态规划：0-1背包（一维空间优化） ==========
function knapsack(weights: number[], values: number[], capacity: number): number {
    const dp = new Array<number>(capacity + 1).fill(0);
    for (let i = 0; i < weights.length; i++) {
        // 倒序遍历，确保每个物品只用一次
        for (let w = capacity; w >= weights[i]; w--) {
            dp[w] = Math.max(dp[w], dp[w - weights[i]] + values[i]);
        }
    }
    return dp[capacity];
}
console.log(knapsack([2, 3, 4, 5], [3, 4, 5, 6], 8)); // 10

// ========== 5. 回溯：全排列 ==========
function permute(nums: number[]): number[][] {
    const result: number[][] = [];

    const backtrack = (path: number[], used: boolean[]): void => {
        if (path.length === nums.length) {
            result.push([...path]); // 注意要拷贝
            return;
        }
        for (let i = 0; i < nums.length; i++) {
            if (used[i]) continue;
            used[i] = true;
            path.push(nums[i]);
            backtrack(path, used);
            path.pop();
            used[i] = false;
        }
    };

    backtrack([], new Array<boolean>(nums.length).fill(false));
    return result;
}
console.log(permute([1, 2, 3]));
// [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]

// ========== 6. 搜索（BFS）：迷宫最短路径 ==========
// maze: 0=可走, 1=墙壁；返回从start到end的步数
function mazeShortestPath(maze: number[][], start: [number, number], end: [number, number]): number {
    const rows = maze.length;
    const cols = maze[0].length;
    const queue: [number, number, number][] = [[start[0], start[1], 0]];
    const visited = new Set<string>();
    visited.add(`${start[0]},${start[1]}`);

    const directions = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    let head = 0;
    while (head < queue.length) {
        const [r, c, dist] = queue[head++];
        if (r === end[0] && c === end[1]) return dist;
        for (const [dr, dc] of directions) {
            const nr = r + dr;
            const nc = c + dc;
            if (nr >= 0 && nr < rows && nc >= 0 && nc < cols &&
                maze[nr][nc] === 0 && !visited.has(`${nr},${nc}`)) {
                visited.add(`${nr},${nc}`);
                queue.push([nr, nc, dist + 1]);
            }
        }
    }
    return -1; // 无法到达
}
const maze = [
    [0, 0, 1, 0],
    [1, 0, 0, 0],
    [0, 0, 1, 0],
    [0, 0, 0, 0],
];
console.log(mazeShortestPath(maze, [0, 0], [3, 3])); // 6
```

##### 二、同一问题的多种解法：爬楼梯与 LIS

```typescript
// ========== 爬楼梯（LeetCode 70） ==========
// 解法3：动态规划（滚动变量，空间O(1)，最推荐）
function climbStairsDp(n: number): number {
    if (n <= 2) return n;
    let prev2 = 1; // f(n-2)
    let prev1 = 2; // f(n-1)
    for (let i = 3; i <= n; i++) {
        const curr = prev1 + prev2; // f(n) = f(n-1) + f(n-2)
        prev2 = prev1;
        prev1 = curr;
    }
    return prev1;
}
console.log(climbStairsDp(10)); // 89

// ========== 最长递增子序列（LeetCode 300） ==========
// 解法2：贪心 + 二分（维护 tails 数组，O(n log n)）
function lengthOfLIS(nums: number[]): number {
    const tails: number[] = []; // tails[i] = 长度为 i+1 的LIS最小末尾
    for (const num of nums) {
        // 二分查找 num 在 tails 中应该放的位置
        let left = 0;
        let right = tails.length;
        while (left < right) {
            const mid = Math.floor((left + right) / 2);
            if (tails[mid] < num) left = mid + 1;
            else right = mid;
        }
        if (left === tails.length) tails.push(num);
        else tails[left] = num;
    }
    return tails.length;
}
console.log(lengthOfLIS([10, 9, 2, 5, 3, 7, 101, 18])); // 4
```


### 主题22 · Go 版实现（Go 对照）

> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、六大算法思想对照实现

```go
package main

import (
	"fmt"
	"sort"
)

// ========== 1. 枚举/暴力：两数之和 ==========
func twoSumBrute(nums []int, target int) []int {
	n := len(nums)
	for i := 0; i < n; i++ {
		for j := i + 1; j < n; j++ {
			if nums[i]+nums[j] == target {
				return []int{i, j}
			}
		}
	}
	return []int{}
}

// ========== 2. 贪心：活动选择 ==========
type Activity struct {
	start, end int
}

// 每次选结束时间最早的活动
func activitySelection(activities []Activity) []Activity {
	// 按结束时间排序（贪心关键）
	sort.Slice(activities, func(i, j int) bool {
		return activities[i].end < activities[j].end
	})
	selected := []Activity{}
	lastEnd := 0
	for _, a := range activities {
		if a.start >= lastEnd { // 和已选活动不冲突
			selected = append(selected, a)
			lastEnd = a.end
		}
	}
	return selected
}

// ========== 3. 分治：快速幂 ==========
func fastPow(base float64, exp int) float64 {
	if exp == 0 {
		return 1
	}
	if exp%2 == 0 {
		half := fastPow(base, exp/2)
		return half * half
	}
	return base * fastPow(base, exp-1)
}

// ========== 4. 动态规划：0-1背包（一维空间优化） ==========
func knapsack(weights, values []int, capacity int) int {
	dp := make([]int, capacity+1)
	for i := 0; i < len(weights); i++ {
		// 倒序遍历，确保每个物品只用一次
		for w := capacity; w >= weights[i]; w-- {
			if dp[w] < dp[w-weights[i]]+values[i] {
				dp[w] = dp[w-weights[i]] + values[i]
			}
		}
	}
	return dp[capacity]
}

// ========== 5. 回溯：全排列 ==========
func permute(nums []int) [][]int {
	result := [][]int{}

	var backtrack func(path []int, used []bool)
	backtrack = func(path []int, used []bool) {
		if len(path) == len(nums) {
			tmp := make([]int, len(path))
			copy(tmp, path)
			result = append(result, tmp) // 注意要拷贝
			return
		}
		for i := 0; i < len(nums); i++ {
			if used[i] {
				continue
			}
			used[i] = true
			path = append(path, nums[i])
			backtrack(path, used)
			path = path[:len(path)-1]
			used[i] = false
		}
	}

	backtrack([]int{}, make([]bool, len(nums)))
	return result
}

// ========== 6. 搜索（BFS）：迷宫最短路径 ==========
// maze: 0=可走, 1=墙壁；返回从start到end的步数
func mazeShortestPath(maze [][]int, start, end [2]int) int {
	rows := len(maze)
	cols := len(maze[0])
	type state struct {
		r, c, dist int
	}
	queue := []state{{start[0], start[1], 0}}
	visited := map[[2]int]bool{{start[0], start[1]}: true}

	directions := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
	head := 0
	for head < len(queue) {
		s := queue[head]
		head++
		if s.r == end[0] && s.c == end[1] {
			return s.dist
		}
		for _, d := range directions {
			nr, nc := s.r+d[0], s.c+d[1]
			if nr >= 0 && nr < rows && nc >= 0 && nc < cols &&
				maze[nr][nc] == 0 && !visited[[2]int{nr, nc}] {
				visited[[2]int{nr, nc}] = true
				queue = append(queue, state{nr, nc, s.dist + 1})
			}
		}
	}
	return -1 // 无法到达
}

func testIdeas() {
	fmt.Println(twoSumBrute([]int{2, 7, 11, 15}, 9)) // [0 1]
	acts := []Activity{{1, 4}, {3, 5}, {0, 6}, {5, 7}, {3, 9}, {5, 9},
		{6, 10}, {8, 11}, {8, 12}, {2, 14}, {12, 16}}
	fmt.Println(activitySelection(acts))
	// [{1 4} {5 7} {8 11} {12 16}]
	fmt.Println(int(fastPow(2, 10))) // 1024
	fmt.Println(knapsack([]int{2, 3, 4, 5}, []int{3, 4, 5, 6}, 8)) // 10
	fmt.Println(permute([]int{1, 2, 3}))
	maze := [][]int{
		{0, 0, 1, 0},
		{1, 0, 0, 0},
		{0, 0, 1, 0},
		{0, 0, 0, 0},
	}
	fmt.Println(mazeShortestPath(maze, [2]int{0, 0}, [2]int{3, 3})) // 6
}
```

##### 二、同一问题的多种解法：爬楼梯与 LIS

```go
package main

import "fmt"

// ========== 爬楼梯（LeetCode 70） ==========
// 解法3：动态规划（滚动变量，空间O(1)，最推荐）
func climbStairsDp(n int) int {
	if n <= 2 {
		return n
	}
	prev2 := 1 // f(n-2)
	prev1 := 2 // f(n-1)
	for i := 3; i <= n; i++ {
		curr := prev1 + prev2 // f(n) = f(n-1) + f(n-2)
		prev2 = prev1
		prev1 = curr
	}
	return prev1
}

// ========== 最长递增子序列（LeetCode 300） ==========
// 解法2：贪心 + 二分（维护 tails 数组，O(n log n)）
func lengthOfLIS(nums []int) int {
	tails := []int{} // tails[i] = 长度为 i+1 的LIS最小末尾
	for _, num := range nums {
		// 二分查找 num 在 tails 中应该放的位置
		left, right := 0, len(tails)
		for left < right {
			mid := (left + right) / 2
			if tails[mid] < num {
				left = mid + 1
			} else {
				right = mid
			}
		}
		if left == len(tails) {
			tails = append(tails, num)
		} else {
			tails[left] = num
		}
	}
	return len(tails)
}

func testClimbAndLIS() {
	fmt.Println(climbStairsDp(10))                              // 89
	fmt.Println(lengthOfLIS([]int{10, 9, 2, 5, 3, 7, 101, 18})) // 4
}
```


> 以下代码与上方 Python 示例一一对应，方便逐行对照学习。

##### 一、六大算法思想对照实现

```typescript
// ========== 1. 枚举/暴力：两数之和 ==========
function twoSumBrute(nums: number[], target: number): number[] {
    const n = nums.length;
    for (let i = 0; i < n; i++) {
        for (let j = i + 1; j < n; j++) {
            if (nums[i] + nums[j] === target) return [i, j];
        }
    }
    return [];
}
console.log(twoSumBrute([2, 7, 11, 15], 9)); // [0, 1]

// ========== 2. 贪心：活动选择 ==========
// 每次选结束时间最早的活动
function activitySelection(activities: [number, number][]): [number, number][] {
    activities.sort((a, b) => a[1] - b[1]); // 按结束时间排序（贪心关键）
    const selected: [number, number][] = [];
    let lastEnd = 0;
    for (const [start, end] of activities) {
        if (start >= lastEnd) { // 和已选活动不冲突
            selected.push([start, end]);
            lastEnd = end;
        }
    }
    return selected;
}
const acts: [number, number][] = [
    [1, 4], [3, 5], [0, 6], [5, 7], [3, 9], [5, 9],
    [6, 10], [8, 11], [8, 12], [2, 14], [12, 16],
];
console.log(activitySelection(acts));
// [[1,4],[5,7],[8,11],[12,16]]

// ========== 3. 分治：快速幂 ==========
// base^exp = (base^(exp/2))^2（偶数）；base * base^(exp-1)（奇数）
function fastPow(base: number, exp: number): number {
    if (exp === 0) return 1;
    if (exp % 2 === 0) {
        const half = fastPow(base, Math.floor(exp / 2));
        return half * half;
    } else {
        return base * fastPow(base, exp - 1);
    }
}
console.log(fastPow(2, 10)); // 1024

// ========== 4. 动态规划：0-1背包（一维空间优化） ==========
function knapsack(weights: number[], values: number[], capacity: number): number {
    const dp = new Array<number>(capacity + 1).fill(0);
    for (let i = 0; i < weights.length; i++) {
        // 倒序遍历，确保每个物品只用一次
        for (let w = capacity; w >= weights[i]; w--) {
            dp[w] = Math.max(dp[w], dp[w - weights[i]] + values[i]);
        }
    }
    return dp[capacity];
}
console.log(knapsack([2, 3, 4, 5], [3, 4, 5, 6], 8)); // 10

// ========== 5. 回溯：全排列 ==========
function permute(nums: number[]): number[][] {
    const result: number[][] = [];

    const backtrack = (path: number[], used: boolean[]): void => {
        if (path.length === nums.length) {
            result.push([...path]); // 注意要拷贝
            return;
        }
        for (let i = 0; i < nums.length; i++) {
            if (used[i]) continue;
            used[i] = true;
            path.push(nums[i]);
            backtrack(path, used);
            path.pop();
            used[i] = false;
        }
    };

    backtrack([], new Array<boolean>(nums.length).fill(false));
    return result;
}
console.log(permute([1, 2, 3]));
// [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]

// ========== 6. 搜索（BFS）：迷宫最短路径 ==========
// maze: 0=可走, 1=墙壁；返回从start到end的步数
function mazeShortestPath(maze: number[][], start: [number, number], end: [number, number]): number {
    const rows = maze.length;
    const cols = maze[0].length;
    const queue: [number, number, number][] = [[start[0], start[1], 0]];
    const visited = new Set<string>();
    visited.add(`${start[0]},${start[1]}`);

    const directions = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    let head = 0;
    while (head < queue.length) {
        const [r, c, dist] = queue[head++];
        if (r === end[0] && c === end[1]) return dist;
        for (const [dr, dc] of directions) {
            const nr = r + dr;
            const nc = c + dc;
            if (nr >= 0 && nr < rows && nc >= 0 && nc < cols &&
                maze[nr][nc] === 0 && !visited.has(`${nr},${nc}`)) {
                visited.add(`${nr},${nc}`);
                queue.push([nr, nc, dist + 1]);
            }
        }
    }
    return -1; // 无法到达
}
const maze = [
    [0, 0, 1, 0],
    [1, 0, 0, 0],
    [0, 0, 1, 0],
    [0, 0, 0, 0],
];
console.log(mazeShortestPath(maze, [0, 0], [3, 3])); // 6
```

##### 二、同一问题的多种解法：爬楼梯与 LIS

```typescript
// ========== 爬楼梯（LeetCode 70） ==========
// 解法3：动态规划（滚动变量，空间O(1)，最推荐）
function climbStairsDp(n: number): number {
    if (n <= 2) return n;
    let prev2 = 1; // f(n-2)
    let prev1 = 2; // f(n-1)
    for (let i = 3; i <= n; i++) {
        const curr = prev1 + prev2; // f(n) = f(n-1) + f(n-2)
        prev2 = prev1;
        prev1 = curr;
    }
    return prev1;
}
console.log(climbStairsDp(10)); // 89

// ========== 最长递增子序列（LeetCode 300） ==========
// 解法2：贪心 + 二分（维护 tails 数组，O(n log n)）
function lengthOfLIS(nums: number[]): number {
    const tails: number[] = []; // tails[i] = 长度为 i+1 的LIS最小末尾
    for (const num of nums) {
        // 二分查找 num 在 tails 中应该放的位置
        let left = 0;
        let right = tails.length;
        while (left < right) {
            const mid = Math.floor((left + right) / 2);
            if (tails[mid] < num) left = mid + 1;
            else right = mid;
        }
        if (left === tails.length) tails.push(num);
        else tails[left] = num;
    }
    return tails.length;
}
console.log(lengthOfLIS([10, 9, 2, 5, 3, 7, 101, 18])); // 4
```


### 主题23：刷题实战指南


> "光看不练假把式。" 算法学习最终要落实到刷题上。本主题给你一份完整的刷题攻略。

---

#### 一、推荐刷题平台

##### 1.1 LeetCode（力扣）

**网址**：https://leetcode.cn（中文）/ https://leetcode.com（英文）

**特点**：
- 面试必备，几乎所有大公司的面试题都来自这里
- 题目分类清晰，可以按标签、难度筛选
- 有讨论区，可以看到各种语言的题解
- 支持周赛，模拟真实面试环境

**使用方法**：
1. **按标签刷题**：进入"题目"页面 → 选择标签（如"数组"、"链表"）→ 按难度排序
2. **按 Hot 100 刷**：搜索"LeetCode Hot 100"，这是面试高频题精选
3. **按公司刷**：可以按目标公司筛选面试题
4. **周赛**：每周一次，45分钟做4题，模拟面试压力

##### 1.2 洛谷

**网址**：https://www.luogu.com.cn

**特点**：
- 中文社区，题解丰富
- 题目从入门到竞赛全覆盖
- 有"题单"功能，别人整理好的刷题路线可以直接跟
- 适合算法竞赛入门

**使用方法**：
1. 从"入门"题单开始
2. 逐步挑战"普及-"、"普及/提高-"等难度
3. 参加月赛

##### 1.3 Codeforces

**网址**：https://codeforces.com

**特点**：
- 全球最活跃的竞赛平台
- 每场 Div.2 比赛 5 道题，按难度递增排列
- Rating 系统，可以量化自己的水平
- 题目偏数学和思维，非常锻炼能力

**使用方法**：
1. 先打 Div.2 的 A、B 题（入门）
2. 逐步挑战 C、D 题
3. 赛后看官方题解和高手代码

---

#### 二、刷题策略

##### 第一阶段：按专题刷（2-4 周）

**目标**：每个专题掌握 5-10 道经典题，形成模板。

| 周次 | 专题 | 每天题量 |
|------|------|---------|
| 第1周 | 数组、链表、栈/队列 | 3-5 道 |
| 第2周 | 二叉树、图 | 3-5 道 |
| 第3周 | 回溯、DP | 2-3 道 |
| 第4周 | 贪心、二分、堆、哈希 | 2-3 道 |

**方法**：
1. 先看该专题的知识回顾
2. 从 Easy 开始，建立信心
3. 每道 Medium 题花 20-30 分钟思考
4. 做完后看题解，对比自己的解法
5. 总结该专题的常见模板

##### 第二阶段：随机混合练习（2-4 周）

**目标**：打乱专题顺序，训练识别问题类型的能力。

**方法**：
1. 在 LeetCode 随机选题（Medium 难度）
2. 限时 25 分钟
3. 重点练习"看到题目 → 判断类型 → 选择算法"的过程
4. 记录错题，分析为什么没看出来

##### 第三阶段：模拟面试套题（2 周）

**目标**：模拟真实面试环境，提升综合能力。

**方法**：
1. 每次做一套 3 题（1 Easy + 2 Medium 或 3 Medium）
2. 限时 60-75 分钟
3. 练习边写边讲解思路（面试需要）
4. 使用 LeetCode 的模拟面试功能

---

#### 三、LeetCode Hot 100 精选题单

按知识点分类，给出题号、题名和建议解法：

##### 数组 / 双指针

| 题号 | 题名 | 难度 | 建议解法 |
|------|------|------|---------|
| 1 | 两数之和 | Easy | 哈希表 |
| 15 | 三数之和 | Medium | 排序 + 双指针 |
| 11 | 盛最多水的容器 | Medium | 双指针 |
| 42 | 接雨水 | Hard | 双指针 / 单调栈 |
| 56 | 合并区间 | Medium | 排序 + 遍历 |
| 88 | 合并两个有序数组 | Easy | 双指针（从后往前） |
| 283 | 移动零 | Easy | 双指针 |
| 238 | 除自身以外数组的乘积 | Medium | 前缀积 + 后缀积 |

##### 链表

| 题号 | 题名 | 难度 | 建议解法 |
|------|------|------|---------|
| 206 | 反转链表 | Easy | 迭代 / 递归 |
| 2 | 两数相加 | Medium | 模拟 + 进位 |
| 21 | 合并两个有序链表 | Easy | 虚拟头节点 |
| 160 | 相交链表 | Easy | 双指针（浪漫相遇） |
| 141 | 环形链表 | Easy | 快慢指针 |
| 142 | 环形链表 II | Medium | 快慢指针 + 数学 |
| 23 | 合并K个升序链表 | Hard | 堆 / 分治 |
| 25 | K个一组翻转链表 | Hard | 模拟 + 递归 |
| 19 | 删除链表倒数第N个节点 | Medium | 快慢指针（间隔k） |

##### 栈 / 队列

| 题号 | 题名 | 难度 | 建议解法 |
|------|------|------|---------|
| 20 | 有效的括号 | Easy | 栈 |
| 155 | 最小栈 | Medium | 辅助栈 |
| 394 | 字符串解码 | Medium | 栈 |
| 739 | 每日温度 | Medium | 单调栈 |
| 239 | 滑动窗口最大值 | Hard | 单调队列 |
| 232 | 用栈实现队列 | Easy | 双栈 |

##### 哈希表

| 题号 | 题名 | 难度 | 建议解法 |
|------|------|------|---------|
| 1 | 两数之和 | Easy | 哈希表 |
| 49 | 字母异位词分组 | Medium | 哈希表（排序作key） |
| 128 | 最长连续序列 | Medium | 哈希集合 |

##### 二叉树

| 题号 | 题名 | 难度 | 建议解法 |
|------|------|------|---------|
| 94 | 二叉树中序遍历 | Easy | 递归 / 迭代 |
| 104 | 二叉树最大深度 | Easy | DFS / BFS |
| 226 | 翻转二叉树 | Easy | 递归 |
| 101 | 对称二叉树 | Easy | 递归 |
| 543 | 二叉树直径 | Easy | DFS + 全局变量 |
| 102 | 层序遍历 | Medium | BFS |
| 108 | 有序数组转BST | Easy | 递归（取中点） |
| 98 | 验证二叉搜索树 | Medium | 中序遍历 / 递归 |
| 236 | 二叉树最近公共祖先 | Medium | 递归 |
| 124 | 二叉树最大路径和 | Hard | DFS |
| 297 | 二叉树序列化与反序列化 | Hard | BFS/DFS |

##### 图

| 题号 | 题名 | 难度 | 建议解法 |
|------|------|------|---------|
| 200 | 岛屿数量 | Medium | DFS / BFS |
| 994 | 腐烂的橘子 | Medium | BFS |
| 207 | 课程表 | Medium | 拓扑排序(BFS) |
| 208 | 实现Trie(前缀树) | Medium | Trie树 |

##### 回溯

| 题号 | 题名 | 难度 | 建议解法 |
|------|------|------|---------|
| 46 | 全排列 | Medium | 回溯 |
| 78 | 子集 | Medium | 回溯 |
| 17 | 电话号码字母组合 | Medium | 回溯 |
| 39 | 组合总和 | Medium | 回溯 + 剪枝 |
| 22 | 括号生成 | Medium | 回溯 |
| 79 | 单词搜索 | Medium | 回溯(DFS) |
| 131 | 分割回文串 | Medium | 回溯 + 预处理 |
| 51 | N皇后 | Hard | 回溯 |

##### 动态规划

| 题号 | 题名 | 难度 | 建议解法 |
|------|------|------|---------|
| 70 | 爬楼梯 | Easy | DP |
| 118 | 杨辉三角 | Easy | DP |
| 198 | 打家劫舍 | Medium | DP |
| 279 | 完全平方数 | Medium | DP / BFS |
| 322 | 零钱兑换 | Medium | DP |
| 139 | 单词拆分 | Medium | DP |
| 152 | 乘积最大子数组 | Medium | DP |
| 300 | 最长递增子序列 | Medium | DP / 贪心+二分 |
| 1143 | 最长公共子序列 | Medium | DP |
| 72 | 编辑距离 | Medium | DP |
| 10 | 正则表达式匹配 | Hard | DP |
| 32 | 最长有效括号 | Hard | DP / 栈 |

##### 贪心

| 题号 | 题名 | 难度 | 建议解法 |
|------|------|------|---------|
| 121 | 买卖股票最佳时机 | Easy | 贪心 / 一次遍历 |
| 55 | 跳跃游戏 | Medium | 贪心 |
| 45 | 跳跃游戏 II | Medium | 贪心(BFS思想) |
| 763 | 划分字母区间 | Medium | 贪心 |

##### 二分查找

| 题号 | 题名 | 难度 | 建议解法 |
|------|------|------|---------|
| 35 | 搜索插入位置 | Easy | 二分 |
| 33 | 搜索旋转排序数组 | Medium | 二分（变体） |
| 34 | 排序数组中查找元素首末位置 | Medium | 二分（两次） |
| 4 | 寻找两个正序数组中位数 | Hard | 二分 |

##### 堆

| 题号 | 题名 | 难度 | 建议解法 |
|------|------|------|---------|
| 215 | 数组中第K大元素 | Medium | 堆 / 快速选择 |
| 347 | 前K个高频元素 | Medium | 堆 + 哈希 |
| 295 | 数据流中位数 | Hard | 对顶堆 |

##### 字符串

| 题号 | 题名 | 难度 | 建议解法 |
|------|------|------|---------|
| 3 | 无重复字符最长子串 | Medium | 滑动窗口 + 哈希 |
| 5 | 最长回文子串 | Medium | 中心扩展 / DP |
| 415 | 字符串相加 | Easy | 模拟 |
| 242 | 有效的字母异位词 | Easy | 哈希计数 |
| 14 | 最长公共前缀 | Easy | 逐字符比较 |

---

#### 四、刷题技巧

##### 4.1 五分钟法则

```
拿到题目
  │
  ├─ 先读题，理解题意（1分钟）
  │
  ├─ 想思路（4分钟）
  │    ├─ 有思路 → 开始写代码
  │    └─ 没思路 → 看提示/题解
  │
  └─ 重要原则：
       - 不要死磕超过30分钟
       - 看题解不丢人，浪费时间才丢人
       - 看完题解一定要自己重写一遍！
```

##### 4.2 看题解的正确姿势

1. **先看提示**，不看完整代码，尝试自己想
2. **看完题解后**，关掉题解，自己从头写
3. **写不出来**再看，反复这个过程
4. **写出来后**，对比题解，看有没有更优写法
5. **记录要点**：这道题的关键思路是什么？我为什么没想到？

##### 4.3 错题本模板

每道错题记录以下信息：

```
题号：LeetCode 739
题名：每日温度
日期：2025-01-15
专题：单调栈
难度：Medium

题目简述：找每天右边第一个更暖的天数

我的思路：（当时怎么想的）
错误原因：没想到用单调栈 / 栈里存了值而不是下标

正确思路：单调递减栈，存下标，遇到更大元素就弹出

关键代码：
  while stack and temps[i] > temps[stack[-1]]:
      answer[stack.pop()] = i - stack.pop()  # 注意顺序！

教训：遇到"下一个更大"问题 → 想单调栈
```

##### 4.4 常见模板总结

| 模板 | 适用场景 | 关键代码特征 |
|------|---------|-------------|
| 二分查找 | 有序数组查找 | `while l <= r: mid = (l+r)//2` |
| BFS模板 | 最短路径/层序遍历 | `deque + visited集合` |
| DFS模板 | 遍历/搜索 | `递归 + 回溯` |
| 回溯模板 | 排列组合子集 | `选择 → 递归 → 撤销` |
| 并查集模板 | 连通性/分组 | `find + union + 路径压缩` |
| 滑动窗口 | 连续子数组/子串 | `双指针 + 窗口条件` |
| 单调栈 | 下一个更大/更小 | `while stack and cmp` |
| 拓扑排序 | DAG/课程安排 | `入度表 + BFS` |

---

#### 五、面试准备建议

##### 5.1 面试中的算法题

**面试考什么**：
1. **沟通能力**：能否澄清题意、确认边界条件
2. **思路分析**：能否有条理地分析问题
3. **代码能力**：能否写出正确、整洁的代码
4. **复杂度分析**：能否分析时间和空间复杂度

##### 5.2 面试答题流程

```
第1步：确认题意（1-2分钟）
  - 复述题目，确认理解
  - 问清楚边界：输入为空？有负数？数据规模？
  - 举几个例子验证理解

第2步：分析思路（3-5分钟）
  - 先说暴力解法（展示基础能力）
  - 再优化到最优解（展示优化能力）
  - 和面试官确认方向对不对

第3步：写代码（10-15分钟）
  - 边写边解释思路
  - 变量命名清晰
  - 注意边界条件

第4步：测试（3-5分钟）
  - 用示例数据手动走一遍
  - 测试边界情况（空输入、单元素、极端值）

第5步：复杂度分析（1-2分钟）
  - 时间复杂度
  - 空间复杂度
  - 能否进一步优化？
```

##### 5.3 面试高频题型 Top 15

根据面试出现频率，以下题目最值得优先练习：

| 排名 | 题号 | 题名 | 核心考点 |
|------|------|------|---------|
| 1 | 1 | 两数之和 | 哈希表 |
| 2 | 3 | 无重复字符最长子串 | 滑动窗口 |
| 3 | 15 | 三数之和 | 双指针 |
| 4 | 20 | 有效括号 | 栈 |
| 5 | 21 | 合并两个有序链表 | 链表操作 |
| 6 | 33 | 搜索旋转排序数组 | 二分 |
| 7 | 46 | 全排列 | 回溯 |
| 8 | 53 | 最大子数组和 | DP/Kadane |
| 9 | 70 | 爬楼梯 | DP |
| 10 | 94 | 二叉树中序遍历 | 树遍历 |
| 11 | 98 | 验证BST | 树+递归 |
| 12 | 102 | 层序遍历 | BFS |
| 13 | 121 | 买卖股票 | 贪心 |
| 14 | 200 | 岛屿数量 | DFS/BFS |
| 15 | 206 | 反转链表 | 链表操作 |

##### 5.4 面试心态

1. **不要慌**：面试官不期望你秒出最优解
2. **多沟通**：沉默是最大的扣分项
3. **先暴力再优化**：展示思考过程比直接给答案更重要
4. **写不出来也要说思路**：部分分 > 零分
5. **练习"出声思考"**：平时刷题就养成边写边说的习惯

---

> 刷题不在多，在于精。每道题吃透，总结规律，比盲目刷 500 道题更有效。祝你刷题顺利，面试成功！


---


### 主题23 · TS 版实现（TypeScript 对照）

> 主题23以刷题策略与题单为主，这里把正文"4.4 常见模板总结"中的核心模板用 TypeScript 实现一遍，方便在刷题/面试中直接套用。

##### 核心算法模板速查

```typescript
// ========== 1. 二分查找（有序数组） ==========
function binarySearch(nums: number[], target: number): number {
    let l = 0;
    let r = nums.length - 1;
    while (l <= r) {
        const mid = Math.floor((l + r) / 2);
        if (nums[mid] === target) return mid;
        else if (nums[mid] < target) l = mid + 1;
        else r = mid - 1;
    }
    return -1; // 找不到
}

// ========== 2. BFS模板（层序遍历/最短路径） ==========
function bfsLevelOrder(root: any): any[][] {
    if (!root) return [];
    const result: any[][] = [];
    const queue: any[] = [root];
    while (queue.length > 0) {
        const levelSize = queue.length;
        const level: any[] = [];
        for (let i = 0; i < levelSize; i++) {
            const node = queue.shift()!;
            level.push(node.val);
            if (node.left) queue.push(node.left);
            if (node.right) queue.push(node.right);
        }
        result.push(level);
    }
    return result;
}

// ========== 3. 回溯模板（排列/组合/子集） ==========
function subsets(nums: number[]): number[][] {
    const result: number[][] = [];
    const path: number[] = [];

    const backtrack = (start: number): void => {
        result.push([...path]);
        for (let i = start; i < nums.length; i++) {
            path.push(nums[i]);
            backtrack(i + 1);
            path.pop();
        }
    };

    backtrack(0);
    return result;
}

// ========== 4. 滑动窗口模板（连续子数组/子串） ==========
function slidingWindow(s: string): number {
    const need = new Set<string>(["a", "b", "c"]);
    const window = new Map<string, number>();
    let left = 0;
    let valid = 0;
    let best = Number.POSITIVE_INFINITY;

    for (let right = 0; right < s.length; right++) {
        const c = s[right];
        if (need.has(c)) {
            window.set(c, (window.get(c) ?? 0) + 1);
            if (window.get(c) === 1) valid++;
        }
        while (valid === need.size) {
            best = Math.min(best, right - left + 1);
            const d = s[left];
            if (need.has(d)) {
                window.set(d, window.get(d)! - 1);
                if (window.get(d) === 0) valid--;
            }
            left++;
        }
    }
    return best;
}

// ========== 5. 单调栈模板（下一个更大/更小） ==========
function nextGreater(nums: number[]): number[] {
    const n = nums.length;
    const answer = new Array<number>(n).fill(-1);
    const stack: number[] = [];
    for (let i = 0; i < n; i++) {
        while (stack.length > 0 && nums[i] > nums[stack[stack.length - 1]]) {
            answer[stack.pop()!] = nums[i];
        }
        stack.push(i);
    }
    return answer;
}

// ========== 6. 拓扑排序（DAG/课程安排，Kahn算法） ==========
function topoSort(n: number, edges: [number, number][]): number[] {
    const indeg = new Array<number>(n).fill(0);
    const adj: number[][] = Array.from({ length: n }, () => []);
    for (const [u, v] of edges) {
        adj[u].push(v);
        indeg[v]++;
    }
    const queue: number[] = [];
    for (let i = 0; i < n; i++) if (indeg[i] === 0) queue.push(i);

    const order: number[] = [];
    while (queue.length > 0) {
        const u = queue.shift()!;
        order.push(u);
        for (const v of adj[u]) {
            if (--indeg[v] === 0) queue.push(v);
        }
    }
    return order.length === n ? order : [];
}

// 测试
console.log(binarySearch([1, 3, 5, 7, 9], 5)); // 2
console.log(subsets([1, 2, 3]));
console.log(nextGreater([2, 1, 2, 4, 3]));     // [4, 2, 4, -1, -1]
console.log(topoSort(4, [[0, 1], [1, 2], [2, 3]])); // [0, 1, 2, 3]
```


### 主题23 · Go 版实现（Go 对照）

> 主题23以刷题策略与题单为主，这里把正文"4.4 常见模板总结"中的核心模板用 Go 实现一遍，方便在刷题/面试中直接套用。

##### 核心算法模板速查

```go
package main

import (
	"fmt"
	"sort"
)

// ========== 1. 二分查找（有序数组） ==========
func binarySearch(nums []int, target int) int {
	l, r := 0, len(nums)-1
	for l <= r {
		mid := (l + r) / 2
		if nums[mid] == target {
			return mid
		} else if nums[mid] < target {
			l = mid + 1
		} else {
			r = mid - 1
		}
	}
	return -1 // 找不到
}

// ========== 2. BFS模板（层序遍历/最短路径） ==========
type TreeNode struct {
	Val         int
	Left, Right *TreeNode
}
func bfsLevelOrder(root *TreeNode) [][]int {
	if root == nil {
		return [][]int{}
	}
	result := [][]int{}
	queue := []*TreeNode{root}
	for len(queue) > 0 {
		levelSize := len(queue)
		level := []int{}
		for i := 0; i < levelSize; i++ {
			node := queue[0]
			queue = queue[1:]
			level = append(level, node.Val)
			if node.Left != nil {
				queue = append(queue, node.Left)
			}
			if node.Right != nil {
				queue = append(queue, node.Right)
			}
		}
		result = append(result, level)
	}
	return result
}

// ========== 3. 回溯模板（子集） ==========
func subsets(nums []int) [][]int {
	result := [][]int{}
	path := []int{}

	var backtrack func(start int)
	backtrack = func(start int) {
		tmp := make([]int, len(path))
		copy(tmp, path)
		result = append(result, tmp) // 每个节点都是一个子集
		for i := start; i < len(nums); i++ {
			path = append(path, nums[i]) // 做选择
			backtrack(i + 1)
			path = path[:len(path)-1] // 撤销选择（回溯）
		}
	}

	backtrack(0)
	return result
}

// ========== 4. 单调栈模板（下一个更大/更小） ==========
func nextGreater(nums []int) []int {
	n := len(nums)
	answer := make([]int, n)
	for i := range answer {
		answer[i] = -1
	}
	stack := []int{}
	for i := 0; i < n; i++ {
		for len(stack) > 0 && nums[i] > nums[stack[len(stack)-1]] {
			idx := stack[len(stack)-1]
			stack = stack[:len(stack)-1]
			answer[idx] = nums[i]
		}
		stack = append(stack, i)
	}
	return answer
}

// ========== 5. 拓扑排序（DAG/课程安排，Kahn算法） ==========
func topoSort(n int, edges [][2]int) []int {
	indeg := make([]int, n)
	adj := make([][]int, n)
	for _, e := range edges {
		u, v := e[0], e[1]
		adj[u] = append(adj[u], v)
		indeg[v]++
	}
	queue := []int{}
	for i := 0; i < n; i++ {
		if indeg[i] == 0 {
			queue = append(queue, i)
		}
	}

	order := []int{}
	for len(queue) > 0 {
		u := queue[0]
		queue = queue[1:]
		order = append(order, u)
		for _, v := range adj[u] {
			indeg[v]--
			if indeg[v] == 0 {
				queue = append(queue, v)
			}
		}
	}
	if len(order) == n {
		return order
	}
	return []int{} // 有环则返回空切片
}

// 提示：Go 标准库没有内建 min，需要时可自己实现：
// func minInt(a, b int) int { if a < b { return a }; return b }
// 滑动窗口模板的写法与 TS 版一致（双指针 + 字符计数 map），这里从略。

func testTemplates() {
	fmt.Println(binarySearch([]int{1, 3, 5, 7, 9}, 5)) // 2
	fmt.Println(subsets([]int{1, 2, 3}))
	fmt.Println(nextGreater([]int{2, 1, 2, 4, 3})) // [4 2 4 -1 -1]
	fmt.Println(topoSort(4, [][2]int{{0, 1}, {1, 2}, {2, 3}})) // [0 1 2 3]
}

// 确保 import "sort" 被使用（排序模板可放在此类位置）：
var _ = sort.Ints
```


---

## 学习建议
**关于节奏**：不要追求速度，理解比刷题数量重要。一个数据结构如果没理解透，后面的学习会越来越吃力。建议每个主题至少花 3-5 天，配合手写实现和练习题。

**关于练习**：每学完一个知识点，至少做 3-5 道对应的练习题。做题时先独立思考 15-20 分钟，实在没思路再看题解，看完后一定要自己重新写一遍。

**关于手写实现**：核心数据结构（链表、栈、队列、二叉树、堆、哈希表）至少要手动实现一次，不要只依赖语言内置的数据结构。

**关于复习**：算法学习容易遗忘，建议用间隔重复的方式复习。可以每周安排一天回顾本周学过的内容，每月做一次综合练习。