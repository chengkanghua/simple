# C++ Primer 实战教程（基于《C++ Primer 中文版·第五版》目录）

> 一套「实战 + 理论」风格的中文 C++ 教学文档，章节结构与《C++ Primer（第五版）》一致。
> 每章包含：**理论精讲 → 实战代码 → 常见坑 → 本章小结**。

## 学习建议

- **零基础**：按顺序学 1~7 章（C++ 基础），动手敲每一行代码。
- **有 C/Java/Python 基础**：快速过 1~3 章，精读 6~7 章（函数与类）与 12~13 章（内存与拷贝控制，这是 C++ 的灵魂）。
- **面试/进阶**：重点看 11、12、13、15、16 章。

## 环境准备

```bash
# Linux / macOS
g++ -std=c++17 -Wall main.cpp -o main && ./main

# Windows (MSVC)
cl /std:c++17 /EHsc /W4 main.cpp
```

## 目录

| 章 | 文件 | 主题 | 难度 |
|---|---|---|---|
| 1 | [ch01-开始.md](ch01-开始.md) | 编写第一个程序、输入输出、注释、控制流 | ? |
| 2 | [ch02-变量和基本类型.md](ch02-变量和基本类型.md) | 类型、const、类型转换、auto/decltype | ?? |
| 3 | [ch03-字符串向量和数组.md](ch03-字符串向量和数组.md) | string、vector、数组、迭代器 | ?? |
| 4 | [ch04-表达式.md](ch04-表达式.md) | 运算符、优先级、类型提升 | ?? |
| 5 | [ch05-语句.md](ch05-语句.md) | if/switch/循环、跳转、异常 | ? |
| 6 | [ch06-函数.md](ch06-函数.md) | 参数传递、重载、内联、函数指针 | ??? |
| 7 | [ch07-类.md](ch07-类.md) | 封装、构造函数、this、友元 | ??? |
| 8 | [ch08-IO库.md](ch08-IO库.md) | iostream、fstream、sstream、格式化 | ?? |
| 9 | [ch09-顺序容器.md](ch09-顺序容器.md) | vector/deque/list/forward_list | ??? |
| 10 | [ch10-泛型算法.md](ch10-泛型算法.md) | sort/find/copy、lambda、bind | ??? |
| 11 | [ch11-关联容器.md](ch11-关联容器.md) | map、set、无序容器 | ??? |
| 12 | [ch12-动态内存.md](ch12-动态内存.md) | new/delete、智能指针 | ???? |
| 13 | [ch13-拷贝控制.md](ch13-拷贝控制.md) | 拷贝构造、赋值、析构、移动语义、五法则 | ????? |
| 14 | [ch14-运算符重载.md](ch14-运算符重载.md) | 算术/比较/输入输出运算符、下标、调用 | ??? |
| 15 | [ch15-面向对象.md](ch15-面向对象.md) | 继承、虚函数、多态、抽象类 | ???? |
| 16 | [ch16-模板与泛型编程.md](ch16-模板与泛型编程.md) | 函数/类模板、可变参数、模板特化 | ???? |
| 17 | [ch17-大型程序工具.md](ch17-大型程序工具.md) | 异常安全、命名空间、多重/虚继承 | ???? |
| 18 | [ch18-工具与技术.md](ch18-工具与技术.md) | 重载决议、运行时类型识别、union、volatile | ??? |

## 全书知识地图

```
基础语法(1~5) ──? 函数与类(6~7) ──? 标准库容器与算法(8~11)
                                      │
                                      ▼
                        内存与拷贝控制(12~13) ?── C++ 核心
                                      │
                                      ▼
              运算符重载(14) ──? 面向对象(15) ──? 模板(16) ──? 工程工具(17~18)
```

> 学习心法：**不要背语法，要理解"对象生命周期"和"内存归属"**。写 C++ 时始终问自己三个问题：这块内存谁分配？谁释放？对象拷贝时发生了什么？


---

# 第 1 章 开始

> 目标：跑通第一个 C++ 程序，掌握编译流程、基本输入输出和控制流。

## 1.1 编写第一个程序

```cpp
// hello.cpp
#include <iostream>   // 预处理指令：引入标准输入输出库

int main()            // main 是程序入口，返回值必须是 int
{
    std::cout << "Hello, World!" << std::endl;  // 输出一行文字
    return 0;         // 返回 0 表示程序成功结束
}
```

**编译与运行**：

```bash
g++ -std=c++17 -Wall hello.cpp -o hello
./hello
```

**理论要点**：
- `#include` 在编译前由预处理器把头文件内容"粘贴"进来。
- `std::cout` 是标准库的输出流对象，`std` 是**命名空间**（所有标准库都在里面）。
- `<<` 是流插入运算符，可以连续使用：`std::cout << "a" << "b";`
- `return 0` 可省略（main 特有），其他函数不行。

## 1.2 注释

```cpp
// 单行注释：解释"为什么"，而不是复述代码

/*
 * 多行注释
 * 注意：多行注释不能嵌套！ /* 这样会出错 */
```

## 1.3 输入与输出实战

实战：读取两个数并输出它们的和。

```cpp
#include <iostream>

int main() {
    int a = 0, b = 0;
    std::cout << "请输入两个整数: ";
    std::cin >> a >> b;              // 流提取运算符 >>，按空格/回车分隔
    std::cout << "它们的和是: " << a + b << std::endl;
    return 0;
}
```

**理论要点**：
- `std::cin >> a` 的返回值是流对象本身，所以可以链式写 `std::cin >> a >> b`。
- 输入类型不匹配时（如要求 int 却输入字母），流会进入"失败状态"，后续读取全部失效——这是新手最常见的坑。
- `std::endl` = 换行 + 刷新缓冲区；`"\n"` 只换行不刷新（性能更好，循环里优先用 `"\n"`）。

## 1.4 控制流初体验

### while 循环：求 1~10 的和

```cpp
#include <iostream>

int main() {
    int sum = 0, val = 1;
    while (val <= 10) {
        sum += val;
        ++val;
    }
    std::cout << "1到10的和是 " << sum << std::endl;   // 55
    return 0;
}
```

### for 循环：同样的事更简洁

```cpp
int sum = 0;
for (int val = 1; val <= 10; ++val)   // 初始化; 条件; 每轮结束执行
    sum += val;
```

### if：统计输入中每个值出现了多少次

```cpp
#include <iostream>

int main() {
    int currVal = 0, val = 0;
    if (std::cin >> currVal) {        // 先读第一个数
        int cnt = 1;
        while (std::cin >> val) {     // 继续读后续的数
            if (val == currVal)
                ++cnt;
            else {
                std::cout << currVal << " 出现了 " << cnt << " 次" << std::endl;
                currVal = val;
                cnt = 1;
            }
        }
        std::cout << currVal << " 出现了 " << cnt << " 次" << std::endl;
    }
    return 0;
}
```

> 输入结束后按 `Ctrl+D`（Linux/macOS）或 `Ctrl+Z` 再回车（Windows）表示文件结束（EOF）。

### 读取数量不定的数据（EOF 用法）

```cpp
int value;
while (std::cin >> value) {   // 遇到 EOF 或非法输入时条件为假，循环结束
    // 处理 value
}
```

**理论要点**：`while (std::cin >> value)` 之所以能当条件用，是因为流对象可转换为 bool 值——成功为 true，失败为 false。这个技巧贯穿全书。

## 1.5 文件重定向（实战技巧）

编译好的程序可以脱离键盘，直接处理文件：

```bash
./count < input.txt > output.txt   # 输入来自文件，输出也写进文件
```

程序代码**一个字都不用改**——这就是流抽象的威力。

## 1.6 关于未初始化变量的警告

```cpp
int a;                // 未初始化！值是垃圾值（未定义行为）
std::cout << a;       // 可能输出任何东西，甚至程序崩溃
```

**规则**：内置类型（int、double 等）的局部变量不自动初始化，**定义变量时永远给初值**：`int a = 0;`

## 常见坑

| 坑 | 后果 | 正确做法 |
|---|---|---|
| 忘记 `#include` | 编译错误"未声明的标识符" | 用到什么就 include 什么 |
| 用了 `cout` 没写 `std::` | 编译错误 | `std::cout`，或 `using std::cout;`（初学可用 `using namespace std;`，工程中避免） |
| `std::cin >> "hello"` | 逻辑错误 | `>>` 是读取，目标是变量 |
| `while (val < 10)` 该用 `<=` | 差一错误（off-by-one） | 边界条件仔细推敲 |

## 本章小结

1. C++ 程序 = 函数集合，入口是 `main`。
2. IO 通过流完成：`cin >>` 读入，`cout <<` 输出，链式书写。
3. `std::endl` 换行并刷新缓冲区；循环内推荐 `"\n"`。
4. 循环条件可以放输入语句，利用流的 bool 转换判断输入是否结束。
5. 永远初始化变量。

## 练习

1. 修改 1.1 程序，输出你的名字和学号。
2. 用 for 循环输出 1~100 中所有偶数的和。
3. 编写程序：读取若干整数，输出出现次数最多的那个值（提示：输入先排序或依赖相邻相等，可简化为"统计相邻重复"）。


---

# 第 2 章 变量和基本类型

> 目标：理解 C++ 的类型系统、初始化规则、const 与类型转换——这是写出正确代码的地基。

## 2.1 基本内置类型

| 类别 | 类型 | 典型大小* | 用途 |
|---|---|---|---|
| 布尔 | `bool` | 1字节 | true / false |
| 字符 | `char` | 1字节 | 字符（保证能存放机器基本字符集） |
| 宽字符 | `wchar_t` / `char16_t` / `char32_t` | 2~4字节 | Unicode |
| 整型 | `short` `int` `long` `long long` | 2/4/4/8字节 | 整数，**优先用 int 和 long long** |
| 浮点 | `float` `double` `long double` | 4/8/16字节 | **优先用 double**（float 精度常不够且未必更快） |

*以 64 位平台为典型，标准只保证最小尺寸：`int ≥ 16位`，`long long ≥ 64位`。

```cpp
// 带符号 vs 无符号
int a = -1;           // 有符号，可正可负
unsigned int b = 1;   // 无符号，只能 ≥ 0
```

### 选择类型的经验法则

1. 一般整数用 `int`；超过 21 亿用 `long long`。
2. 不会为负的数值（年龄、数量）可用无符号，但**混用有符号和无符号是大坑**（见 2.6 节）。
3. 浮点一律 `double`；`float` 仅在存大量数据省内存时用。
4. 布尔运算只出现在表达式里，不要把整型当 bool 用（虽然合法）。

## 2.2 类型转换

```cpp
bool b = 42;        // b = true（任何非零 → true）
int i = b;          // i = 1（true → 1）
i = 3.14;           // i = 3（浮点→整型：截断小数部分，不是四舍五入！）
double d = i;       // d = 3.0
unsigned char c = -1;  // c = 255（取模：-1 mod 256）

// 显式转换（推荐写法）
double pi = 3.14;
int truncated = static_cast<int>(pi);   // 命名转换，意图明确
```

### ?? 无符号类型的经典陷阱（必考）

```cpp
unsigned u = 10;
int i = -42;
std::cout << i + i << std::endl;   // -84，正常
std::cout << u + i << std::endl;   // 4294967264！-42 被转成无符号大数

// 更隐蔽的：倒序循环死循环
for (unsigned k = 10; k >= 0; --k)  // k 永远不会 < 0，当 k=0 再减 1 变成 42亿+
    std::cout << k << std::endl;     // 死循环！
```

**规则**：表达式里无符号与有符号混用时，有符号会被**自动转为无符号**。循环变量绝不用无符号做倒计数。

## 2.3 字面值

```cpp
20          // 十进制 int
024         // 八进制（以0开头）= 20
0x14        // 十六进制 = 20
'a'         // char 字面值
"L你好"      // 宽字符串字面值
3.14        // double
3.14f       // float
true        // bool
"hello"     // 字符串字面值，末尾隐藏一个 '\0'
// C++14 起的优雅写法
1'000'000   // 数字分隔符
0b1010      // 二进制字面值
```

## 2.4 变量：定义、初始化、声明

### 初始化的多种形式（都合法）

```cpp
int a = 0;      // 拷贝初始化
int b(0);       // 直接初始化
int c{0};       // 列表初始化（C++11），若丢失信息会报错，最安全
int d = {0};    // 等价于 c
int e;          // 未初始化！局部变量中是垃圾值
```

### 初始化 ≠ 赋值

```cpp
int a = 0;   // 初始化：对象创建时就获得值
a = 5;       // 赋值：擦除旧值，写入新值
```

> 这是 C++ 的重要概念，第 13 章会看到两者调用的是完全不同的函数（构造函数 vs 赋值运算符）。

### 声明 vs 定义

```cpp
extern int i;   // 声明：告诉编译器"i 存在，定义在别处"，不分配内存
int j;          // 定义：分配内存（顺便也是声明）
```

**规则**：变量只能定义一次，但可以声明多次。多文件共享变量时，头文件放声明（extern），某个 .cpp 放定义。

### 标识符规范

- 组成：字母、数字、下划线，不能以数字开头。
- 不能用关键字（`int`、`for`……）。
- 建议：变量名小写下划线（`user_name`）、常量全大写（`MAX_SIZE`）、自定义类型首字母大写（`SalesData`）。

### 作用域

```cpp
int global = 100;        // 全局作用域

void func() {
    int local = 1;       // 块作用域
    {
        int local = 2;   // 内层同名变量"遮蔽"外层
        std::cout << local;   // 2
    }
    std::cout << local;  // 1
    std::cout << ::global;  // 100，:: 显式访问全局
}
```

## 2.5 复合类型：引用和指针（本章核心！）

### 引用：变量的别名

```cpp
int val = 10;
int &ref = val;   // ref 是 val 的别名，从此操作 ref 就是操作 val
ref = 20;         // val 变成 20
// int &bad;      // 错误！引用必须初始化，且不能换绑定的对象
```

**理论要点**：引用不是对象，它只是已存在对象的另一个名字。没有"空引用"，定义后不能改绑。

### 指针：存放地址的对象

```cpp
int val = 10;
int *p = &val;    // p 存 val 的地址；& 在此是取地址符

std::cout << *p;  // 10；* 在此是解引用符
*p = 30;          // 通过指针修改 val
std::cout << p;   // 地址，如 0x7ffd...
```

### 空指针与野指针

```cpp
int *p1 = nullptr;   // C++11 推荐：空指针，表示"不指向任何对象"
int *p2 = NULL;      // 旧式，本质是整数 0，不推荐
int *p3 = 0;         // 同上

// ?? 野指针：未初始化的指针，解引用它 = 未定义行为（崩溃或更糟）
int *p4;             // 危险！值是随机地址
```

**铁律**：定义指针必须初始化，暂时没目标就 `= nullptr`。

### void* 指针

可存放任意类型对象的地址，但不能直接解引用（不知道类型）：

```cpp
void *pv = &val;    // 合法
// *pv = 1;         // 错误：类型未知
```

### 引用 vs 指针对比

| 特性 | 引用 | 指针 |
|---|---|---|
| 是否为对象 | 否（别名） | 是（有自己的地址） |
| 必须初始化 | 是 | 否（但应该初始化为 nullptr） |
| 可重新指向 | 否 | 是 |
| 可为空 | 否 | 是 |
| 支持多级 | 只有一级 | `int**` 指向指针的指针 |

## 2.6 const 限定符

```cpp
const int bufSize = 512;   // 常量：创建后不能修改
// bufSize = 3;            // 错误！
const int i = get_size();  // 合法：运行时初始化也没问题
```

### const 与多文件

默认情况下，`const` 变量只在当前文件有效（每个文件的 const 是独立副本）。想跨文件共享：

```cpp
// 头文件中：加 extern 声明
extern const int bufSize;
// 某个 .cpp 中：定义
extern const int bufSize = 512;
```

### 对常量的引用（const 引用）——高频使用

```cpp
const int ci = 1024;
const int &r1 = ci;      // 正确
// r1 = 5;               // 错误：通过 const 引用不能改所指对象

int i = 42;
const int &r2 = i;       // 正确：允许把 const 引用绑定到普通变量（通过 r2 不能改 i）
const int &r3 = 42;      // 正确：可绑定字面值
const int &r4 = r2 * 2;  // 正确：可绑定表达式

double d = 3.14;
const int &r5 = d;       // 竟然合法！编译器偷偷生成临时量 int tmp = d; r5 绑 tmp
int &r6 = d;             // 错误！普通引用不能绑定类型不匹配的对象
```

> 术语：指向常量的引用（`const int&`）意思不是"引用是 const"，而是"**通过这个引用不能修改对象**"。

### 指针与 const

```cpp
const double pi = 3.14;
const double *cptr = &pi;   // 指向常量的指针：不能通过 cptr 改值
double d = 1.1;
cptr = &d;                  // 合法：指针本身可变，只是不能改所指内容

// 顶层 const（top-level）：指针本身是常量
int errN = 0;
int *const perr = &errN;    // 常量指针：永远指向 errN，不能改指向
const double pi2 = 3.14;    // 顶层 const：pi2 本身不可改

// 底层 const（low-level）：所指对象不可通过我改
const double *pd = &pi;     // 底层 const
const double *const pip = &pi;  // 既是顶层又是底层
```

**记法**：看 const 在 `*` 左边还是右边——`const int* p`（底层，值不能改）；`int* const p`（顶层，指向不能改）。

### constexpr 与常量表达式（C++11）

```cpp
constexpr int mf = 20;              // 编译期就能确定值的常量
constexpr int limit = mf + 1;       // 也是常量表达式
const int sz = get_size();          // 运行时初始化，不是常量表达式
constexpr int sz2 = size();         // 只有当 size 是 constexpr 函数才合法
```

## 2.7 处理类型

### 类型别名

```cpp
typedef double Wages;        // 传统写法
using P = int*;              // C++11 别名声明，更好读

Wages hourly;                // hourly 是 double
P ptr = &val;                // ptr 是 int*

// typedef 的坑：
typedef char *pstring;
const pstring cstr = 0;      // cstr 是 char* const（常量指针）！不是 const char*！
```

### auto：让编译器推导类型（C++11）

```cpp
int i = 0;
auto a = i;          // int
auto b = 3.14;       // double
auto c = i, d = 3.14;// 错误！一条语句里所有变量类型必须一致

// 引用与 auto 的坑：
int &r = i;
auto r2 = r;         // r2 是 int！auto 会忽略引用，拷贝一份值

const int ci = 10;
auto d1 = ci;        // int：顶层 const 被忽略
const auto d2 = ci;  // const int：想保留就显式写 const
auto &d3 = ci;       // const int&：引用会保留底层 const
// auto &d4 = 42;    // 错误：普通引用不能绑字面值
const auto &d5 = 42; // 正确
```

### decltype：取表达式的类型但不求值

```cpp
const int ci = 0, &cj = ci;
decltype(ci) x = 0;    // const int
decltype(cj) y = x;    // const int&（decltype 保留引用！与 auto 相反）
int i = 42, *p = &i;
decltype(p) q;         // int*：q 未初始化，注意风险

// 特殊规则：
decltype((i)) d1;      // int&！双层括号 = 引用
decltype(i) d2;        // int
```

## 2.8 自定义数据结构（struct 初探）

```cpp
// Sales_data.h
struct Sales_data {
    std::string bookNo;         // 书号
    unsigned units_sold = 0;    // 销量（C++11 类内初始值）
    double revenue = 0.0;       // 收入
};                              // 别忘了分号！
```

```cpp
// 使用
#include "Sales_data.h"

int main() {
    Sales_data data;             // 类内初始值生效：sold=0, revenue=0.0
    data.bookNo = "978-7-121-15535";   // 用 . 访问成员
    Sales_data *ptr = &data;
    ptr->bookNo = "xxx";         // 指针访问成员用 ->
    return 0;
}
```

**头文件规范**：
- 头文件里放：声明（函数声明、extern 变量声明、类/struct 定义）。
- 头文件保护符（防止重复包含）：

```cpp
#ifndef SALES_DATA_H      // 若未定义过 SALES_DATA_H
#define SALES_DATA_H      // 就定义它
struct Sales_data { /* ... */ };
#endif                    // 第二次 include 时上面的宏已定义，内容被跳过
// 现代 C++ 也可用 #pragma once（非标准但普遍支持）
```

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| 无符号下溢 | `for (unsigned i = n; i >= 0; --i)` | 永远为真，死循环 |
| 浮点转整型 | `int(3.99) == 3` | 是截断不是四舍五入 |
| 未初始化指针 | `int* p; *p = 1;` | 未定义行为，可能崩溃 |
| auto 丢引用 | `auto b = a引用` | b 是拷贝不是引用 |
| typedef 常量 | `const pstring` | 是 `char* const` 不是 `const char*` |
| struct 少分号 | `struct S {...}` 后没 `;` | 编译错误，报错位置常误导人 |

## 本章小结

1. 内置类型的选择：整型用 `int`/`long long`，浮点用 `double`。
2. 无符号与有符号混用会自动转换，倒计数循环禁用无符号。
3. **引用是别名，指针是存地址的对象**；指针必须初始化（哪怕 nullptr）。
4. 顶层 const 管"自己"，底层 const 管"所指"；`const T*` vs `T* const` 要分清。
5. auto 忽略引用和顶层 const；decltype 完全保留（还保留引用）。
6. 头文件放声明 + 保护符；struct 定义末尾有分号。

## 练习

1. 判断：`int i = 3.14;` 后 i 的值？`unsigned u = -1;` 后 u 的值？（答案：3；4294967295）
2. 写出下面每个变量的类型：
   ```cpp
   int i = 0, &r = i; auto a = r;
   const int ci = i, &cr = ci; auto b = cr; auto c = &i; auto d = &ci;
   // 答案：int, int, int*, const int*
   ```
3. 定义一个 struct `Person`（姓名、年龄、身高），编写程序创建对象并输出成员。


---

# 第 3 章 字符串、向量和数组

> 目标：掌握 string、vector、迭代器——C++ 日常开发 80% 的数据操作靠这三个工具。

## 3.1 using 声明

```cpp
using std::cin;    // 以后直接写 cin
using std::string;
using std::endl;

int main() {
    int a;
    cin >> a;
    string s;
}
```

> 每个名字都要单独 `using std::xxx;`。**头文件里不要写 using 声明**——包含它的所有文件都被迫污染命名空间。

## 3.2 标准库类型 string

```cpp
#include <string>
using std::string;

string s1;             // 空字符串
string s2 = "hi";      // 拷贝初始化
string s3("hi");       // 直接初始化
string s4 = s2 + s3;   // 拼接
string s5(10, 'c');    // "cccccccccc"：直接初始化才能这样
// string s6 = "a" + "b";  // 错误！两个字面值不能直接相加
string s7 = string("a") + "b";  // 正确：+ 两侧至少要有一个 string
```

### string 常用操作速查

```cpp
string s = "hello";

s.empty()       // 判空 → false
s.size()        // 字符数 → 5（类型是 string::size_type，无符号！）
s.length()      // 同 size()
s[i]            // 下标访问：'h'（不检查越界！）
s.substr(0, 3)  // "hel"：从下标0取3个字符
s.find("ll")    // 查找子串，返回下标2；找不到返回 string::npos
s += " world"   // 追加
s.compare() / 关系运算符  // 字典序比较
```

### 读入字符串的两种方式

```cpp
string word;
cin >> word;           // 遇空白停止：输入 "hello world" 只读到 "hello"

getline(cin, word);    // 读一整行（含空格），不含换行符
```

### 实战：逐词统计 / 逐行处理

```cpp
// 统计每个单词出现的行数（简化版）
string line;
while (getline(cin, line)) {     // 一行一行读
    // 处理 line
}

// 统计输入总字符数
unsigned total = 0;
string word;
while (cin >> word)              // 一个词一个词读
    total += word.size();
```

### ?? string::size() 的无符号陷阱

```cpp
string s = "hi";
if (s.size() < 3)         // OK，但 3 会被转成无符号
int n = -1;
// if (s.size() < n)      // 永远为 false！n 被转为巨大的无符号数
```

**规则**：不要把 `size()` 的返回值与有符号数比较（C++11 后可用 `ssize()` 之类的非标准方案，或直接用 auto）。

### 处理字符串中的字符

```cpp
#include <cctype>
isdigit(c)   // 是否数字
isalpha(c)   // 是否字母
isspace(c)   // 是否空白
toupper(c)   // 转大写（返回 int，注意转回 char）
tolower(c)

// 实战：把一行全转成大写
string s = "hello";
for (auto &c : s)         // 引用才能修改
    c = toupper(c);       // s 变为 "HELLO"
```

### 三种遍历方式对比

```cpp
// 1. 范围 for（C++11）：只读或简单修改，最简洁
for (auto c : s) cout << c;

// 2. 下标：需要位置信息时
for (string::size_type i = 0; i != s.size(); ++i)
    s[i] = toupper(s[i]);

// 3. 迭代器：与标准库算法配合（见 3.4）
for (auto it = s.begin(); it != s.end(); ++it)
    *it = toupper(*it);
```

## 3.3 标准库类型 vector

`vector` 是**动态数组**：长度可变、元素连续存储、下标随机访问 O(1)、尾部追加均摊 O(1)。

```cpp
#include <vector>
using std::vector;

vector<int> v1;               // 空
vector<int> v2(5);            // 5个0
vector<int> v3(5, 1);         // 5个1
vector<int> v4{1, 2, 3};      // 列表初始化：1,2,3
vector<int> v5 = {1, 2, 3};   // 同上
vector<string> v6(3, "hi");   // 3个"hi"
```

### 圆括号 vs 花括号（必考细节）

```cpp
vector<int> v1(10);      // 10个元素，都是0
vector<int> v2{10};      // 1个元素，值是10
vector<int> v3(10, 1);   // 10个1
vector<int> v4{10, 1};   // 两个元素：10 和 1
vector<string> v5{"hi"}; // 1个元素"hi"
// vector<string> v6("hi");  // 错误！不能用字面值构造
```

> **规则**：`()` 是"构造出这么多个"，`{}` 是"内容就是这些"（除非内容无法作为元素列表，才会退化成构造）。

### 添加与访问

```cpp
vector<int> v;
for (int i = 0; i < 5; ++i)
    v.push_back(i);          // 尾部追加：0 1 2 3 4
// 注意：没有 push_front！vector 头部插入是 O(n)

v.size()      // 元素个数（类型 vector<int>::size_type）
v.empty()
v[0]          // 随机访问（不检查越界）
v.at(0)       // 随机访问（越界抛 out_of_range 异常，慢但安全）
```

### ?? 向 vector 添加元素会使迭代器失效

```cpp
vector<int> v = {1, 2, 3};
// 错误示范：
for (auto it = v.begin(); it != v.end(); ++it)
    v.push_back(*it);   // 灾难！push_back 可能扩容，旧迭代器全部失效

// 正确做法：先想清楚要加几个，或循环里重新计算 end
```

**规则**：**循环体内如果会增删容器元素，就不要缓存 end()，也不要依赖循环之前保存的迭代器**。范围 for 更不能在体内修改容器长度。

### 实战：读入一组数，输出相邻两数之和

```cpp
vector<int> v;
int x;
while (cin >> x) v.push_back(x);

for (vector<int>::size_type i = 0; i + 1 < v.size(); ++i)
    cout << v[i] + v[i + 1] << " ";
```

### vector 嵌套

```cpp
vector<vector<int>> matrix(3, vector<int>(4, 0));  // 3行4列全0
matrix[1][2] = 5;
```

## 3.4 迭代器（iterator）

迭代器是"广义指针"：它指明容器中某个元素的位置，所有标准库容器都支持，这让泛型算法（第 10 章）能通吃所有容器。

```cpp
vector<int> v = {1, 2, 3};
auto it = v.begin();   // 指向第一个元素
auto e  = v.end();     // 指向"最后一个元素的下一位置"（尾后迭代器，不指向真实元素）

*it          // 解引用：1
++it         // 前移一个
it + 2       // 随机访问迭代器支持，vector/string 可以，list 不行
it1 - it2    // 两迭代器距离（vector/string 支持）
it->成员      // 等价 (*it).成员
cbegin()/cend()  // const 迭代器：只读
```

### 实战：用迭代器把 string 的首字符大写

```cpp
string s = "some string";
if (!s.empty()) {
    auto it = s.begin();
    *it = toupper(*it);
}
// s = "Some string"
```

### 二分查找：迭代器经典应用

```cpp
// 在已排序的 vector 中查找 target（本例仅演示迭代器运算）
auto beg = v.begin(), end = v.end();
auto mid = beg + (end - beg) / 2;      // 写成 (beg+end)/2 容易溢出
while (mid != end && *mid != target) {
    if (target < *mid) end = mid;
    else beg = mid + 1;
    mid = beg + (end - beg) / 2;
}
```

### ?? 迭代器失效规则（背下来）

| 操作 | 后果 |
|---|---|
| vector 扩容（push_back 触发） | **所有**迭代器、指针、引用失效 |
| vector 插入/删除中间元素 | 插入点之后的迭代器失效 |
| vector 删除元素 | 被删元素之后的迭代器失效 |
| 任何对容器的结构修改后 | 不要再用之前保存的迭代器；`erase` 会返回下一个有效迭代器 |

```cpp
// 正确的"边遍历边删除"写法：
auto it = v.begin();
while (it != v.end()) {
    if (*it % 2 == 0)
        it = v.erase(it);   // erase 返回下一个有效位置
    else
        ++it;
}
```

## 3.5 数组

数组是**定长**的原始容器，长度编译期确定。现代 C++ 建议**优先用 vector**，数组用于性能敏感或接口要求的场合。

```cpp
int arr[10];                 // 10个未初始化的 int
int arr2[3] = {1, 2, 3};
int arr3[5] = {1, 2};        // 剩下的是 0
int arr4[] = {1, 2, 3};      // 长度自动推断为 3
int arr5[3] = {0};           // 全 0
// int arr6[3] = {1,2,3,4};  // 错误！初始值超过长度
// int a2[];                 // 错误！必须指明长度或有初始值

char a3[] = "C++";           // 注意！含 '\0'，长度是 4 不是 3
```

### 复杂声明的读法（从内向外、从右向左）

```cpp
int *arr[10];        // arr 是数组，10个元素，每个是 int*（指针数组）
int (*arr2)[10];     // arr2 是指针，指向"含10个int的数组"（数组指针）
int (&arr3)[10];     // arr3 是引用，绑定"含10个int的数组"
```

### 数组与指针

```cpp
int arr[] = {1, 2, 3};
auto p1 = arr;       // p1 是 int*，指向首元素（数组名退化为指针）
decltype(arr) p2;    // p2 是 int[3] 类型！decltype 不退化

int *p = arr;
*p           // 1
*(p + 1)     // 2，指针算术：移动 sizeof(int) 字节
p[1]         // 2，下标本质就是指针算术
int *e = &arr[3];   // 尾后指针：指向"最后一个元素的下一位置"
```

**?? 数组下标可以是负数（指针算术），vector 不行**：

```cpp
int arr[] = {1,2,3};
int *p = arr + 2;
p[-1]           // 1：p-1 位置，合法
vector<int> v = {1,2,3};
// v[v.size()-1] 正确；v[-1] 错误！vector 下标必须是无符号
```

### C 风格字符串与 C++ string 对比

```cpp
#include <cstring>
char ca[] = "hello";
strlen(ca)        // 5：遇到 '\0' 停止，忘记 '\0' 会越界扫描（危险）
strcmp(a, b)      // 比较返回 0/负/正，不如 string 的 == 直观
strcat/strcpy     // 必须保证目标空间足够，否则缓冲区溢出

// 现代 C++：直接用 string
string s = ca;    // char* → string 自动
// s.c_str()      // string → const char*（注意：返回的指针在 s 改变后可能失效）
```

**结论**：能用 `string` 就别用 `char[]`；C API 交互时用 `s.c_str()`。

### 数组初始化 vector

```cpp
int arr[] = {1, 2, 3, 4, 5};
vector<int> v(begin(arr), end(arr));       // 整个数组
vector<int> v2(arr + 1, arr + 4);          // arr[1..3)：2 3 4
// 反向不行！vector 不能直接初始化数组
```

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| 下标越界 | `v[v.size()]` | 未定义行为，不报错但可能崩溃（at() 会抛异常） |
| 循环内 push_back 用旧 end | 迭代器失效 | 结构修改后重取迭代器 |
| `size()` 与负数比较 | 永远为 false | 无符号转换 |
| `{"hi"}` vs `("hi")` | 列表 vs 构造 | `{}` 是内容，`()` 是数量 |
| char 数组忘了 `'\0'` | strlen 越界 | 用 string 替代 |
| 范围 for 中修改容器长度 | 迭代器失效 | 范围 for 体内不得增删元素 |

## 本章小结

1. `string` 处理文本：`cin >>` 按词读，`getline` 按行读；`find/substr` 是最常用 API。
2. `vector` 是可变长数组：`push_back` 追加、下标访问；**初始化时 `()` 与 `{` `}` 语义不同**。
3. 迭代器统一访问所有容器：`begin()` 首元素、`end()` 尾后；**任何增删操作后迭代器可能失效**。
4. 数组定长、名字会退化成指针；工程中优先 string/vector，与 C 接口交互时才碰 char 数组。

## 练习

1. 读入一组整数存入 vector，输出每对相邻元素的和（首尾配对版：第一个+最后）。
2. 用迭代器实现：把 vector 中所有奇数删除（提示：erase 返回下一个迭代器）。
3. 统计一段文本中每个单词出现的总次数和首现行号（综合运用 string + vector）。


---

# 第 4 章 表达式

> 目标：理解运算符的求值规则、优先级与结合律，避开未定义行为的雷区。

## 4.1 基础概念

**表达式** = 运算对象 + 运算符，求值得到一个结果。
- **优先级**：不同运算符谁先算（乘法先于加法）。
- **结合律**：同优先级时从哪边算（算术从左，赋值从右）。
- **求值顺序**：**通常未定义**！优先级只决定"怎么组合"，不决定"哪个先求值"。

```cpp
// ?? 经典未定义行为：
int i = 0;
cout << i << " " << ++i << endl;   // 未定义：两个子表达式谁先求值？可能输出 "1 1" 或 "0 1"
f() + g();                         // f 和 g 的调用顺序未定义
// 如果 f/g 修改同一对象 → 未定义行为
```

**规则**：一条表达式中，**不要让两个子表达式修改同一个对象，或者一个改一个读同一个对象**。

### 短路求值（逻辑运算符）

```cpp
if (p != nullptr && p->value > 0)  // p 为空时右边不执行，安全！
if (idx < v.size() && v[idx] > 0)
// || 同理：左边为真右边不执行
```

实战中大量依赖短路求值做**前置条件保护**。

## 4.2 算术运算符

```cpp
21 / 6 == 3     // 整数除法：向零取整（截断）
-21 / 6 == -3   // 也是向零取整（不是 -4！）
21 % 6 == 3     // 取余：符号跟随被除数（C++11 起）
-21 % 6 == -3
```

**?? 除零 / 模零是未定义行为，程序直接崩溃。**

### 实战：分离数字的各位

```cpp
int n = 1234;
while (n > 0) {
    cout << n % 10;   // 个位
    n /= 10;
}
```

## 4.3 赋值运算符

```cpp
int i;
i = 3.14;        // 发生窄化转换，i == 3（丢失信息，编译器会警告）

// 赋值是右结合：
int a, b, c;
a = b = c = 5;   // 5 先赋给 c，c 的值再赋给 b……

// 赋值结果是其左侧对象（左值）
int i2;
if ((i2 = getValue()) != 0)   // 先赋值再判断，注意括号
    /* ... */;
```

### ?? `=` 与 `==` 的千年大坑

```cpp
if (i = 42)    // bug！这是赋值，永真（42 非零转 true）
if (i == 42)   // 才是判断
```

**习惯**：与字面值比较时把常量放左边 `if (42 == i)`，写错 `if (42 = i)` 编译器直接报错。

## 4.4 递增递减运算符

```cpp
int i = 5;
int a = ++i;    // 前置：先加再用，a=6, i=6（推荐！）
int b = i++;    // 后置：先用再加，b=6, i=7
```

**为什么推荐前置**：后置版本需要保存旧值返回副本，对迭代器等复杂类型有额外开销。

### 实战：后置版本的正确用途

```cpp
auto it = v.begin();
while (it != v.end() && *it >= 0)
    ++it;                          // 前置：仅移动

// 后置的价值：需要"旧值"时
for (vector<int>::size_type i = 0; i != v.size(); ++i)
    cout << v[i++] << endl;        // 用 v[i] 原值后 i 前移（示例，别在循环里这么玩）

// 经典用法：解引用后移
cout << *it++ << endl;   // 等价 *(it++)：输出当前元素，然后 it 前移
```

### ?? 一行内多次修改同一对象

```cpp
*beg = toupper(*beg++);   // 未定义行为！*beg 和 beg++ 读写同一 beg
```

## 4.5 成员访问与条件运算符

```cpp
ptr->member    // 等价 (*ptr).member
// 条件运算符（三目）：
int max = (a > b) ? a : b;
// 可嵌套但可读性差，超过两层就写 if-else
cout << (a < b ? "小于" : "不小于");   // 输出时必须加括号！
// cout << a < b ? "x" : "y";  // 错误：<< 优先级高于 ?:
```

## 4.6 位运算符

| 运算符 | 功能 | 例子 |
|---|---|---|
| `~` | 位取反 | `~0xFF` → 0xFFFFFF00（int 为 32 位时） |
| `<<` | 左移 | `1 << 3` = 8 |
| `>>` | 右移 | `8 >> 3` = 1（无符号补 0；**有符号的左边补符号位，仍未定义/实现定义**） |
| `&` | 位与 | `0xF0 & 0x0F` = 0 |
| `^` | 位异或 | `0xFF ^ 0x0F` = 0xF0 |
| `\|` | 位或 | `0xF0 \| 0x0F` = 0xFF |

```cpp
// 实战：位标志
unsigned char flags = 0;
const unsigned char OPT_A = 1 << 0;   // 0000 0001
const unsigned char OPT_B = 1 << 1;   // 0000 0010
const unsigned char OPT_C = 1 << 2;   // 0000 0100

flags |= OPT_A | OPT_C;              // 开启 A、C
flags &= ~OPT_B;                     // 关闭 B
bool hasA = flags & OPT_A;           // 测试 A（非零为真）
flags ^= OPT_C;                      // 翻转 C
```

**?? 位运算与逻辑运算别混淆**：`&` vs `&&`、`|` vs `||`。对 bool 而言 `1 & 2 == 0` 但 `1 && 2 == true`。

**?? IO 的 `<<`/`>>` 是运算符重载**，左移/右移用于流时是输出/输入——同一符号，两副面孔。

### 实战：移位实现快速乘除 2 的幂

```cpp
x << 1   // x * 2（注意溢出则未定义）
x >> 1   // x / 2（仅无符号安全；有符号负数右移是实现定义）
```

## 4.7 sizeof 运算符

`sizeof` 返回**类型或表达式所占字节数**（size_t 类型），**不求值**。

```cpp
sizeof(int)       // 4
sizeof(double)    // 8
int arr[10];
sizeof(arr)             // 40：整个数组
sizeof(arr) / sizeof(*arr)   // 10：元素个数（经典技巧）
sizeof(Sales_data)      // 类对象大小
sizeof p / sizeof *p    // 指针所指类型大小（两种写法等价）
```

**理论要点**：
- sizeof 数组得到整个数组大小（数组不退化）；sizeof 指针得到指针本身大小。
- **对 vector<string> 之类用 sizeof 得到的是固定 24 字节（3 个指针），不是元素总和**——别用它算容器内容大小。
- sizeof 的操作数中的表达式不求值，`sizeof(f())` 不会真的调用 f。

## 4.8 类型转换回顾 + 命名转换

隐式转换发生场景：比 int 小的整型提升为 int；条件转 bool、算术转换等。

四种命名转换（`static_cast<类型>(表达式)` 风格）：

```cpp
double d = 3.14;
void *p = &d;
double *dp = static_cast<double*>(p);   // 1. static_cast：常见的"合理"转换
const char *cp;
// char *q = static_cast<char*>(cp);    // 错误！static_cast 不能去 const
char *q2 = const_cast<char*>(cp);       // 2. const_cast：只能加/去 const
// 3. dynamic_cast：运行时多态类型检查（第 15/18 章）
// 4. reinterpret_cast：位模式重解释，极危险，几乎不用
```

**规则**：**永远不用 C 风格转换 `(int)x`**——它可能默默执行任何一种命名转换，错误无从察觉。命名转换写起来麻烦，恰恰逼你想清楚。

## 4.9 运算符优先级速查（常用部分）

```
后置 ++ -- () [] . ->          最高
前置 ++ -- 一元 - ! ~ * & (取址/解引用) sizeof new delete
* / %
+ -
<< >>
< <= > >=
== !=
&
^
|
&&
||
?:
= += -= *= /= 等
,                               最低
```

> 记不住没关系，**拿不准就加括号**。专业人士也加括号。

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| 一行内多次改同一对象 | `*beg = toupper(*beg++)` | 未定义行为 |
| `=` 写成判断 | `if (i = 42)` | 永真 |
| 整数除法当浮点用 | `1/2 == 0` | 想得 0.5 先转 double：`1.0/2` |
| 有符号数溢出 | `INT_MAX + 1` | 未定义行为（无符号溢出则是取模，合法） |
| sizeof 容器算内容大小 | `sizeof(vector<int>)` | 是固定指针开销，用 v.size() |
| 移位超位数 | `1 << 32`（int 32位） | 未定义行为 |

## 本章小结

1. 优先级管组合，**求值顺序多半未定义**——别让两个子表达式碰同一对象。
2. 短路求值是前置条件保护的标准手法。
3. 优先前置 `++i`；`*it++` 是"取值后移"的惯用法。
4. 位运算管理标志位；`sizeof(数组)/sizeof(元素)` 数元素个数。
5. 用命名转换替代 C 风格转换。

## 练习

1. 不用 if，用条件运算符求三个数的最大值。
2. 写函数 `bool isPow2(unsigned n)`，只用位运算判断 n 是否 2 的幂（提示：`n & (n-1)`）。
3. 判断以下表达式的值与合法性：`int i = 10; i = i++ + 1;`（答案：未定义行为，说明为什么）


---

# 第 5 章 语句

> 目标：掌握控制流语句的选择原则与异常处理——"写对"之外还要"写清"。

## 5.1 简单语句与块

```cpp
int i = 0;         // 表达式语句
;                  // 空语句（多余分号）：循环体为空时才用
while (cin >> s)   // 合法：循环体就是那个分号前的读取
    ;              // 空语句，等价于 while (cin >> s);

{                  // 块（复合语句）：引入新作用域
    int j = 0;
}                  // j 在此销毁
```

## 5.2 条件语句

### if-else

```cpp
if (score >= 90)       grade = 'A';
else if (score >= 80)  grade = 'B';   // 垂直悬挂 else 归属最近的 if
else                   grade = 'C';
```

### ?? 悬垂 else（dangling else）

```cpp
if (a)
    if (b)
        action1();
else                    // 这个 else 属于内层 if！缩进骗人
    action2();
// 需要外层时用块明确：
if (a) {
    if (b) action1();
} else {
    action2();
}
```

### switch：多分支离散值

```cpp
switch (ch) {
    case 'a': case 'e': case 'i': case 'o': case 'u':   // 共享分支
        ++vowelCnt;
        break;                        // 忘 break 会"贯穿"到下一 case！
    case ' ':
        ++spaceCnt;
        break;
    default:                          // 兜底分支（推荐总是写上）
        ++otherCnt;
        break;
}
```

### ?? case 标签内定义变量

```cpp
switch (val) {
    case 1:
        int x = 3;      // 危险：x 的作用域是整个 switch！
        // 若另一 case 直接使用 x —— 跨过了初始化，非法
        doSomething(x);
        break;
    case 2:
        // use(x);      // 错误：跳过了 x 的初始化
        break;
}

// 正确做法：在 case 内用块
case 1: {
    int x = 3;
    doSomething(x);
    break;
}
```

**规则**：需要在 case 里定义变量，就给它套一层 `{}`。

## 5.3 循环语句

| 语句 | 适用场景 |
|---|---|
| `while` | 条件先判断、次数未知（如读到 EOF） |
| `for` | 计数循环、遍历容器头部确定 |
| `范围 for` | 遍历容器每个元素（C++11） |
| `do-while` | 至少执行一次（输入校验等），少用 |

```cpp
// 范围 for
vector<int> v = {1, 2, 3};
for (const auto &e : v)     // 只读用 const 引用，避免拷贝
    cout << e << ' ';
for (auto &e : v)           // 要修改用引用
    e *= 2;

// do-while：先执行后判断
int n;
do {
    cin >> n;
} while (n <= 0);           // 保证 n > 0 才往下走
```

> 范围 for 的本质：编译器把它翻译成 `for (auto it = v.begin(); it != v.end(); ++it)`。所以**体内增删容器导致迭代器失效的规则同样适用**。

## 5.4 跳转语句

```cpp
break;      // 跳出最近的 switch / 循环
continue;   // 结束本轮，进入下一轮判断
goto;       // 无条件跳转——现代 C++ 禁用，破坏结构化
return;     // 退出函数（第 6 章）
```

## 5.5 try 语句块与异常处理

**异常**用于处理"函数无法就地解决的问题"：检测到错误的地方**抛出**，有能力处理的调用者**捕获**。

```cpp
#include <stdexcept>

throw runtime_error("数据不合法");   // 抛出：立即退出当前函数，沿调用链上抛

try {
    // 可能抛异常的代码
    if (denom == 0)
        throw runtime_error("除数为零");
    cout << numer / denom << endl;
} catch (runtime_error err) {        // 捕获：类型匹配就近处理
    cout << err.what() << endl;      // what() 返回错误信息字符串
} catch (out_of_range err) {
    // 其他类型异常
}
```

### 标准库异常层次

```
exception（所有异常的基类）
├── logic_error（程序可预先检测的逻辑错误）
│   ├── invalid_argument    无效参数
│   ├── domain_error        参数不在定义域
│   ├── length_error        长度超限
│   └── out_of_range        下标越界（如 vector::at）
└── runtime_error（运行时才能发现的错误）
    ├── range_error         计算结果超范围
    ├── overflow_error      上溢
    └── underflow_error     下溢

bad_alloc（new 失败）、bad_cast（dynamic_cast 失败）——不继承 logic/runtime_error
```

### 异常未捕获会怎样？

```cpp
// 无人捕获 → 调用 terminate，程序非正常终止
// 实践中：main 里兜底
int main() {
    try {
        run();
    } catch (exception &e) {
        cerr << "异常: " << e.what() << endl;
        return 1;
    }
}
```

**注意**：catch 基类引用能捕获派生类异常，所以 `catch (exception &e)` 是万能兜底（按**引用**捕获，避免对象切片，详见第 15 章）。

### 实战：给第 3 章的Sales_data 交易程序加异常处理

```cpp
#include <iostream>
#include <stdexcept>
#include "Sales_data.h"
using namespace std;

int main() {
    Sales_data total;
    if (read(cin, total)) {
        Sales_data trans;
        while (read(cin, trans)) {
            if (total.isbn() == trans.isbn())
                total.combine(trans);
            else {
                print(cout, total) << '\n';
                total = trans;
            }
        }
        print(cout, total) << '\n';
    } else {
        cerr << "没有数据" << endl;
        return -1;
    }
}
```

## 实战项目：猜数字游戏（综合本章所有语句）

```cpp
#include <iostream>
#include <random>
using namespace std;

int main() {
    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<int> dist(1, 100);
    int answer = dist(gen);
    int guess = 0, tries = 0;

    while (true) {                      // while + break 模式
        cout << "猜一个 1~100 的数: ";
        if (!(cin >> guess)) {
            cin.clear();                // 清除失败状态
            cin.ignore(10000, '\n');    // 丢弃坏输入
            cout << "请输入数字！\n";
            continue;
        }
        ++tries;
        if (guess < answer)      cout << "小了\n";
        else if (guess > answer) cout << "大了\n";
        else {
            cout << "答对了！共 " << tries << " 次\n";
            break;
        }
    }
    return 0;
}
```

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| switch 忘 break | 贯穿执行到下一个 case | 每个 case（含 default）都写 break 或 return |
| case 里裸定义变量 | 跨初始化跳转非法 | case 体内套 `{}` |
| 悬垂 else | 缩进与归属不符 | 嵌套时用块 |
| cin 进入失败态后继续读 | 后续读取全失败 | `cin.clear()` + `cin.ignore()` |
| catch 按值捕获大对象 | 拷贝开销/对象切片 | 按引用 `catch (exception &e)` |

## 本章小结

1. 分支：离散多值用 switch（记得 break），区间用 if-else。
2. 循环：遍历容器用范围 for（只读加 const 引用）；次数未知用 while。
3. 异常是"把错误交给有能力的人"的机制：`throw` 抛、`try/catch` 捕，按引用捕获标准库异常。
4. main 里放最后一道 try/catch 防止异常逃逸导致 terminate。

## 练习

1. 用 switch 统计文本中元音字母、空格、制表符、换行符各自的数量。
2. 读取无限个整数，遇到 42 时停止输出之前所有读到的数（continue/break 综合练习）。
3. 编写一个除法函数，除数为 0 时抛出 `invalid_argument`，在 main 中捕获并打印 what()。


---

# 第 6 章 函数

> 目标：掌握参数传递方式、返回值、重载——函数是 C++ 工程的基本积木。

## 6.1 函数基础

```cpp
// 返回类型  函数名(形参列表)
int fact(int val)          // val 是形参（parameter），函数体内有效
{
    int ret = 1;
    while (val > 1)
        ret *= val--;
    return ret;            // 返回值：拷贝给调用方
}

fact(5);                   // 5 是实参（argument）
```

- **形参**：函数定义中的占位变量；**实参**：调用时传入的值。
- 实参按**位置**匹配形参（不像关键字参数），数量、类型必须匹配。
- 函数**必须有返回类型**（void 除外）；main 特殊：可省略 return。

### 局部对象与生命周期

```cpp
void func() {
    int local = 0;            // 自动对象：函数退出即销毁
    static int counter = 0;   // 静态局部：首次执行初始化，之后一直存活到程序结束
    ++counter;
}
```

**static 局部变量**在函数多次调用间保持状态，且只初始化一次——单例、计数器常用。

## 6.2 参数传递（本章核心！）

C++ 参数传递只有两种本质：

| 方式 | 语法 | 发生什么 | 何时用 |
|---|---|---|---|
| **传值** | `void f(T a)` | 拷贝一份实参 | 小对象（int、指针）、不修改原值 |
| **传引用** | `void f(T &a)` | 绑定实参本体 | 要修改原值，或避免大对象拷贝 |

### 传值：函数内改的是副本

```cpp
void reset(int i) { i = 0; }      // 改的是拷贝
int x = 42;
reset(x);                          // x 仍是 42
```

### 传引用：函数内改的是本体

```cpp
void reset(int &i) { i = 0; }
int x = 42;
reset(x);                          // x 变成 0
```

### const 形参与实参的匹配规则

```cpp
void f(const int i) { /* 不能改 i */ }
f(5); f(x);         // 都可以：拷贝后改不改与调用方无关

const int ci = 5;
void g(int &r);
// g(ci);           // 错误！普通引用不能绑定 const 对象
void h(const int &r);
h(ci); h(5);        // 都可以
```

### 大对象传参的黄金法则（重要工程惯例）

```cpp
// ? 拷贝整个 string，浪费
void process(string s);
// ? 能修改原对象，调用者提心吊胆
void process(string &s);
// ? 只读 + 零拷贝：const 引用是默认选择
void process(const string &s);

// 需要修改才用普通引用；要拷贝一份在函数内改，就传值
```

### 实战：交换两个变量（3 种写法）

```cpp
void swapV(int a, int b)  { int t=a; a=b; b=t; }  // 无效：改副本
void swapR(int &a, int &b){ int t=a; a=b; b=t; }  // 有效
void swapP(int *a, int *b){ int t=*a; *a=*b; *b=t; } // C 风格：传地址

int x=1, y=2;
swapR(x, y);         // x=2, y=1
swapP(&x, &y);       // 需显式取地址
```

### 数组形参

数组不能拷贝，传数组实际传的是**首元素指针**：

```cpp
// 以下三个声明完全等价：
void print(const int*);
void print(const int[]);
void print(const int[10]);     // 这里的 10 只是"意图说明"，编译器不检查

// 长度必须另外传，或用标记/标准库约定：
void print(const int *beg, const int *end);   // 首尾迭代器（推荐）
void print(const char *cp);                   // C 字符串：靠 '\0' 结尾
void print(const int ia[], size_t size);      // 显式传长度
```

### main 的命令行参数

```cpp
int main(int argc, char *argv[])   // argc: 参数个数; argv: 参数数组
// 约定：argv[0] 是程序名，argv[argc] 是 nullptr
// 运行 ./prog -d file 时：argc=3, argv[1]="-d", argv[2]="file"
```

### 可变形参（了解）

```cpp
// 1. initializer_list：编译期已知的同类型参数列表
void printErr(initializer_list<string> il) {
    for (const auto &s : il) cerr << s << " ";
}
printErr({"err1", "err2"});

// 2. 可变参数模板（第 16 章）
```

## 6.3 返回类型与 return

### 值返回：也是拷贝

```cpp
string makePlural(const string &word) {
    return word + "s";       // 返回一个临时 string 的拷贝（编译器常优化掉）
}
```

### ?? 千年大坑：返回局部对象的引用/指针

```cpp
const string &bad() {
    string local = "hi";
    return local;            // 错误！函数返回时 local 已销毁，引用悬空
}
// 引用是别名，本体没了别名就是空套
```

**规则**：**永远不要返回局部变量的引用或指针**。要返回引用，引用的对象必须在函数结束后仍存在（类的成员、静态变量、传进来的引用形参）。

### 引用返回的妙用（返回左值）

```cpp
char &getVal(string &str, size_t ix) {
    return str[ix];          // 返回 str 中一个字符的引用
}
getVal(s, 0) = 'A';          // 可以给函数调用结果赋值！
```

### 列表初始化返回（C++11）

```cpp
vector<int> process() {
    return {1, 2, 3};        // 直接返回花括号列表
}
```

### 递归实战：斐波那契

```cpp
int fib(int n) {
    if (n <= 1) return n;                  // 终止条件必须有！
    return fib(n - 1) + fib(n - 2);        // 递归推进
}
// 提示：这是指数级演示；工程中用迭代或记忆化
```

## 6.4 重载函数

**同一作用域内**，函数名相同但**形参列表不同**（数量或类型）构成重载：

```cpp
void print(const string &);
void print(const vector<int> &);
void print(const char *cp);
print("hi");          // 调第三个（const char* 精确匹配）
```

**注意**：
- 只有**返回类型不同**不算重载，编译错误。
- 顶层 const 不影响：`void f(int)` 与 `void f(const int)` 视为同一函数。
- 底层 const 影响：`void f(int*)` 与 `void f(const int*)` 是重载。

### 重载决议（编译器怎么选）

1. 精确匹配 > const 转换 > 整型提升（char→int）> 算术转换（int→double）> …
2. 多个"一样好"的匹配 → **二义性错误**：

```cpp
void f(int, double);
void f(double, int);
f(1, 2);    // 错误：两个候选各需一次转换，二义
```

## 6.5 默认实参

```cpp
string screen(int h = 24, int w = 80, char bg = ' ');
screen();               // 全用默认
screen(10);             // h=10, 其余默认
// screen(, 20);        // 错误！只能省略尾部的
```

**规则**：默认实参只能**从右往左连续**省略；声明中后面的形参都有默认值后，前面的才能有。通常把默认值放在头文件的**函数声明**里。

## 6.6 内联函数与 constexpr 函数

```cpp
inline int square(int x) { return x * x; }
// 请求编译器"在调用点展开"，省函数调用开销
// 注意：inline 只是建议，编译器可忽略

constexpr int fact(int n)             // 编译期可算出结果
{
    return n <= 1 ? 1 : n * fact(n - 1);
}
constexpr int f5 = fact(5);           // 编译期得到 120
```

**constexpr 函数**的返回值不一定是编译期常量——取决于传入参数；只有实参也是常量表达式时结果才是。

## 6.7 调试辅助：assert 与 NDEBUG

```cpp
#include <cassert>

void process(const char *input) {
    assert(input != nullptr);   // 条件为假时程序中止并打印表达式与行号
    // ... 仅在未定义 NDEBUG 时生效
    // 编译 release：g++ -DNDEBUG ... 即可关闭所有 assert
}

#ifndef NDEBUG
    cerr << "调试信息: 变量 x = " << x << endl;
    cerr << "文件: " << __FILE__ << " 行: " << __LINE__
         << " 函数: " << __func__ << endl;
#endif
```

## 6.8 函数匹配与函数指针（进阶）

```cpp
bool lengthCompare(const string &, const string &);

// 函数指针：指向函数
bool (*pf)(const string &, const string &);   // (*pf) 的括号必须有！
pf = lengthCompare;         // 函数名退化为指针
bool b = pf("a", "b");      // 调用（无需显式解引用）
bool c = (*pf)("a", "b");   // 等价写法

// 用 auto/decltype 更省心
auto pf2 = lengthCompare;              // pf2 是函数指针
decltype(lengthCompare) *pf3 = pf;     // decltype 得到函数类型，需加 *

// 函数指针作形参：编译器自动把"函数"读成"指针"
void use(bool pf(const string&, const string&));

// 类型别名：
using F = int(int*, int);        // 函数类型
using PF = int(*)(int*, int);    // 指针类型
PF f1(int);                      // f1 是返回函数指针的函数
// int (*f1(int))(int*, int);    // 直接写的等价原文，天书一般
```

## 实战项目：重写 Sales_data 的三个函数

```cpp
// Sales_data.h
#include <string>
#include <iostream>

struct Sales_data {
    std::string isbn() const { return bookNo; }   // 成员函数（第 7 章细讲）
    Sales_data& combine(const Sales_data&);
    double avg_price() const;

    std::string bookNo;
    unsigned units_sold = 0;
    double revenue = 0.0;
};

// 非成员接口函数：读、写、相加
std::istream &read(std::istream &is, Sales_data &item);
std::ostream &print(std::ostream &os, const Sales_data &item);
Sales_data add(const Sales_data &lhs, const Sales_data &rhs);
```

```cpp
// Sales_data.cpp
Sales_data& Sales_data::combine(const Sales_data &rhs) {
    units_sold += rhs.units_sold;    // this 的成员
    revenue += rhs.revenue;
    return *this;                    // 返回调用对象本体的引用
}

double Sales_data::avg_price() const {
    return units_sold ? revenue / units_sold : 0;
}

std::istream &read(std::istream &is, Sales_data &item) {
    double price;
    is >> item.bookNo >> item.units_sold >> price;
    item.revenue = price * item.units_sold;
    return is;                       // 返回流本身，支持链式调用
}

std::ostream &print(std::ostream &os, const Sales_data &item) {
    os << item.isbn() << " " << item.units_sold << " "
       << item.revenue << " " << item.avg_price();
    return os;
}

Sales_data add(const Sales_data &lhs, const Sales_data &rhs) {
    Sales_data sum = lhs;            // 拷贝一份（依赖默认拷贝，见第 13 章）
    sum.combine(rhs);
    return sum;
}
```

**设计要点**：
- `read`/`print` 返回流的引用 → 支持 `read(read(cin,a),b)` 链式调用。
- IO 类型不支持拷贝，所以只能传引用。
- print 不输出换行：让调用者决定格式（库设计惯例）。

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| 返回局部变量的引用 | `T& f(){T l; return l;}` | 悬空引用，未定义行为 |
| 想修改实参却传值 | `void f(T a)` | 改的是副本 |
| 大对象按值传参 | `f(string s)` | 白白拷贝，用 const 引用 |
| 默认实参跳着传 | `f(, 3)` | 只能从右往左省略 |
| 重载二义性 | `f(1, 2)` 匹配两个候选 | 仔细设计形参类型 |
| 只差返回类型的"重载" | `int f(); double f();` | 编译错误 |

## 本章小结

1. 参数传递二选一：**值（拷贝）或引用（本体）**；只读大对象一律 `const T&`。
2. **永远不返回局部变量的引用/指针**；返回流/成员可用引用。
3. 重载看形参列表，不看返回类型；调用时让编译器"只需一次转换"内匹配。
4. 默认实参从头文件声明出发、从右往左。
5. 内联/constexpr 服务性能；assert 服务调试（NDEBUG 控制）。

## 练习

1. 编写 4 个名为 `print` 的重载：int、double、string、vector<int>。
2. 实现递归函数 `int gcd(int a, int b)`（辗转相除），并改写为迭代版。
3. 写函数 `string& shorter(string &s1, string &s2)`，返回较短字符串的引用；思考：为什么不能对临时字符串调用它？


---

# 第 7 章 类

> 目标：理解封装、构造函数、this 指针与访问控制——从"写函数"升级到"设计类型"。

## 7.1 类的定义

**类 = 数据成员（状态） + 成员函数（行为）**。核心思想是**封装**：对外只暴露接口，隐藏实现细节。

```cpp
class Sales_data {
public:                            // 访问说明符：下面所有成员对所有人开放
    // 成员函数：接口
    Sales_data() = default;        // 默认构造函数
    Sales_data(const std::string &s) : bookNo(s) { }          // 委托 isbn 初始化
    Sales_data(const std::string &s, unsigned n, double p)
        : bookNo(s), units_sold(n), revenue(p * n) { }
    Sales_data(std::istream &is) { read(is, *this); }

    std::string isbn() const { return bookNo; }
    Sales_data& combine(const Sales_data&);
    double avg_price() const;

private:                           // 仅成员（和友元）可访问
    // 数据成员：实现细节
    std::string bookNo;
    unsigned units_sold = 0;       // 类内初始值（C++11）
    double revenue = 0.0;
};                                 // 分号！
```

### struct vs class

唯一区别：`struct` 默认 public，`class` 默认 private。惯例：纯数据聚合用 struct，有行为/不变式的类型用 class。

### this 指针

```cpp
total.combine(trans);      // 编译器实际执行：Sales_data::combine(&total, trans)
```

每个成员函数都隐含一个 `this` 指针，指向调用它的对象：

```cpp
Sales_data& Sales_data::combine(const Sales_data &rhs) {
    units_sold += rhs.units_sold;   // 其实是 this->units_sold += ...
    revenue += rhs.revenue;
    return *this;                   // 返回调用对象本体
}
```

### const 成员函数（"常量成员函数"）

```cpp
std::string isbn() const;   // const 修饰的是隐含的 this！
// 实际签名：std::string isbn(const Sales_data *const this) const
```

- `const` 成员函数**不能修改对象的数据成员**（mutable 例外）。
- **const 对象只能调用 const 成员函数**——所以"不修改对象的函数都应声明为 const"，否则 const 对象没法用你的类。

```cpp
double avg_price() const {
    return units_sold ? revenue / units_sold : 0;   // 只读成员，OK
}
```

### 类外定义成员函数

```cpp
double Sales_data::avg_price() const {     // 返回类型 类名::函数名
    return units_sold ? revenue / units_sold : 0;
}
```

## 7.2 构造函数

对象创建时自动调用，负责初始化。**没有返回类型，名字与类同名**。

```cpp
Sales_data() = default;                 // 1. 默认构造：请求编译器生成
Sales_data(const std::string &s) : bookNo(s) { }              // 2. 构造函数初始值列表
Sales_data(const std::string &s, unsigned n, double p)
    : bookNo(s), units_sold(n), revenue(p * n) { }            // 3.
Sales_data(std::istream &is) { read(is, *this); }             // 4. 委托给 read
```

### 构造函数初始值列表：初始化 vs 赋值（重要！）

```cpp
// ? 初始化：成员创建时就得到正确值
Sales_data::Sales_data(const string &s, unsigned n, double p)
    : bookNo(s), units_sold(n), revenue(p * n) { }

// ? 先默认初始化再赋值（两步，const/引用成员会编译错误）
Sales_data::Sales_data(const string &s) {
    bookNo = s;    // 这是赋值，不是初始化
}
```

**规则**：
- 没出现在初始值列表的成员用**类内初始值**（或默认初始化）。
- **const 成员、引用成员、无默认构造的类类型成员，必须在初始值列表中初始化**。
- 成员初始化顺序 = **类中声明顺序**，与初始值列表书写顺序无关（列表顺序要与声明一致，避免自找 bug）。

### 为什么 `= default`？

一旦定义了任何构造函数，编译器就**不再自动生成默认构造函数**。`= default` 让我们"既要自定义构造，又要保留无参构造"。

## 7.3 拷贝、赋值与析构（先知道有这回事）

```cpp
Sales_data s1;               // 默认构造
Sales_data s2 = s1;          // 拷贝构造（对象创建时用另一个对象初始化）
s2 = s1;                     // 拷贝赋值运算符
string s3 = s1.isbn();       // 临时 string；作用域结束时被"析构"
```

编译器会自动合成拷贝构造、拷贝赋值、析构函数（逐成员拷贝/销毁）。**string 有动态内存，所以析构时它会自己释放——这就是 RAII 的雏形**（第 13 章深入）。

## 7.4 访问控制与封装

| 说明符 | 谁能访问 |
|---|---|
| `public` | 任何代码 |
| `private` | 类的成员函数、友元 |

**封装的好处**：实现细节（如 units_sold 与 revenue 分开存）随便改，只要接口不变，用户代码不用动。

### 友元（friend）

类想让某些外部函数/类访问 private 成员，就声明它们为友元：

```cpp
class Sales_data {
    // 友元声明：通常集中在类开头或结尾
    friend Sales_data add(const Sales_data&, const Sales_data&);
    friend std::istream &read(std::istream&, Sales_data&);
    friend std::ostream &print(std::ostream&, const Sales_data&);

public:
    // ...接口
private:
    // ...数据
};
```

**注意**：
- 友元声明在类内出现的位置（public/private）无关紧要。
- 友元**破坏封装，能用成员函数/公共接口就不用友元**；典型场景是 IO 运算符（`operator>>` 左侧必须是流，不能是本类对象）。
- 类之间可以互为友元；友元关系**不能传递、不能继承**。

## 7.5 类的其他特性

### 可变数据成员 mutable

```cpp
class Screen {
public:
    void display() const {
        ++access_ctr;        // const 成员函数也能改 mutable 成员！
    }
private:
    mutable size_t access_ctr = 0;   // "逻辑上不算对象状态"的成员
    std::string contents;
};
```

### 类内成员函数的隐式内联

类内**定义**的成员函数自动是 inline 的；类内声明、类外定义的想内联要显式加 `inline`。

### 类类型成员、类型别名

```cpp
class Screen {
public:
    using pos = std::string::size_type;   // 成员类型别名
    Screen &move(pos r, pos c);
private:
    pos cursor = 0;
    pos height = 0, width = 0;
    std::string contents;
};
```

### 类的成员可以是自身类型的指针/引用，但不能是自身对象

```cpp
class Link {
    Link *prev;      // OK
    Link &next;      // OK
    // Link self;    // 错误！会导致无限大小
};
```

## 7.6 类的作用域

成员函数体在**类作用域**内，可以使用类中任何名字（哪怕声明在后面）：

```cpp
// .cpp 中定义时，返回类型在类名之外，需要显式限定：
Screen::pos Screen::getCursor() const {   // 返回类型必须写 Screen::pos
    return cursor;                        // 函数体已进入类作用域，直接用 pos
}
```

### 名字查找：先找作用域，再处理类型

成员函数中若用了与成员同名的局部变量会**遮蔽**成员（需 `this->` 或 `Screen::` 区分）——避免这种写法。

## 7.7 构造函数再探

### 委托构造函数（C++11）

```cpp
class Sales_data {
public:
    Sales_data(std::string s, unsigned cnt, double price)
        : bookNo(s), units_sold(cnt), revenue(cnt * price) { }
    Sales_data() : Sales_data("", 0, 0) { }          // 委托给上面的
    Sales_data(std::istream &is) : Sales_data() {    // 先委托默认，再读入
        read(is, *this);
    }
};
```

### explicit：防止单参数构造的隐式转换

```cpp
class Sales_data {
public:
    Sales_data() = default;
    Sales_data(const std::string &s) : bookNo(s) { }
    explicit Sales_data(std::istream &is);   // explicit！
};

Sales_data item1("isbn");        // OK：直接初始化
Sales_data item2 = "isbn";       // 若非 explicit，OK（string→Sales_data 隐式转换！）
                                 // 加了 explicit 后：错误
string s = "isbn";
// item2 = s;                    // 隐式转换被 explicit 拦截
item2 = static_cast<Sales_data>(s);  // 显式转换仍可
```

**规则**：**单参数构造函数原则上都加 explicit**（多参数构造无法隐式转换，无需加）。隐式转换的害处：`if (item == "isbn")` 之类悄悄把字符串变成对象，出 bug 难查。

### 聚合类

```cpp
struct Data { int ival; string s; };
Data d1 = {0, "hi"};   // 所有成员 public、无构造/初始值 → 可用花括号列表初始化
```

## 7.8 类的静态成员

属于**类本身**而非每个对象：所有对象共享一份。

```cpp
class Account {
public:
    static double rate() { return interestRate; }   // 静态成员函数
    static void rate(double r) { interestRate = r; }
private:
    static double interestRate;    // 静态数据成员（类内只是声明）
    static constexpr int period = 30;   // constexpr 静态成员可类内初始化
};

// .cpp 中定义（static 关键字不重复写）：
double Account::interestRate = 0.05;

Account::rate(0.06);       // 通过类名访问（推荐）
Account ac;
ac.rate();                 // 也可通过对象访问
```

**特性**：
- 静态成员函数**没有 this**，不能访问非静态成员。
- 静态数据成员必须类外定义一次（除非是 constexpr 整型，C++17 起 inline 变量可直接类内定义）。
- 静态成员的类型可以是所属类自己：`static Account example;`（普通成员不行）。

## 实战项目：Screen 窗口类（组合本章知识点）

```cpp
// Screen.h
#include <string>
class Screen {
public:
    using pos = std::string::size_type;

    Screen() = default;
    Screen(pos ht, pos wd, char c)
        : height(ht), width(wd), contents(ht * wd, c) { }

    char get() const { return contents[cursor]; }        // 读光标处
    inline char get(pos ht, pos wd) const;               // 读指定位置
    Screen &move(pos r, pos c);                          // 移动光标
    Screen &set(char c);                                 // 设置当前字符
    Screen &display(std::ostream &os) {                  // 非常量版本
        do_display(os);
        return *this;
    }
    const Screen &display(std::ostream &os) const {      // const 版本（重载）
        do_display(os);
        return *this;
    }

private:
    void do_display(std::ostream &os) const { os << contents; }
    pos cursor = 0;
    pos height = 0, width = 0;
    std::string contents;
};

inline char Screen::get(pos r, pos c) const {
    pos row = r * width;
    return contents[row + c];
}
inline Screen& Screen::move(pos r, pos c) {
    pos row = r * width;
    cursor = row + c;
    return *this;              // 返回本体 → 支持链式调用
}
inline Screen& Screen::set(char c) {
    contents[cursor] = c;
    return *this;
}
```

```cpp
// main.cpp —— 链式调用的爽感
#include "Screen.h"
int main() {
    Screen myScreen(5, 5, 'X');
    myScreen.move(4, 0).set('#').display(std::cout);   // 输出修改后的画面
    std::cout << "\n";
    const Screen blank(5, 3, ' ');
    blank.display(std::cout);   // 调用的是 const 版本！
}
```

**设计模式提炼**：
1. 返回 `*this` 的引用 → 支持链式调用（`a.move().set()`）。
2. `display` 提供 const/非 const 两个版本 → 既能给只读对象用，也能接着链式修改。
3. 公共实现抽成 private `do_display` → 复用 + 消除重复。

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| 忘了类末尾分号 | `class A {...}` 少 `;` | 报错位置离谱 |
| 该加 const 的成员函数没加 | const 对象无法调用 | 不改对象的函数一律 `const` |
| 在构造函数体内给 const 成员赋值 | 编译错误 | 用初始值列表 |
| 初始值列表顺序与声明顺序不符 | 依赖未初始化成员 | 按声明顺序初始化，保持一致 |
| 单参构造没加 explicit | 意外隐式转换 | 默认都加 |
| 友元当成员用 | 友元不在类作用域 | 类外定义时不要写 `A::` |

## 本章小结

1. 类封装状态与行为：public 接口、private 实现；成员函数自带 `this`。
2. **不修改对象的成员函数必须声明为 const**。
3. 构造函数负责初始化：初始值列表是"初始化"，函数体是"赋值"——const/引用成员只能用前者。
4. 单参构造加 explicit；`= default` 保留默认构造；委托构造消除重复。
5. 静态成员属于类，类外定义、无 this；mutable 成员是"不算状态"的状态。

## 练习

1. 为第 6 章的 Sales_data 补全 4 个构造函数（含委托），并写出每个构造的 `= default` 等价类内初始值版本。
2. 设计一个 `BankAccount` 类：私有成员余额、公开成员 deposit/withdraw/balance（都 const 与否要想清楚），静态成员记录账户总数。
3. 思考：为什么 `myScreen.move().set()` 要求 move 返回引用而不是值？（提示：返回值会拷贝出一个临时对象，set 改的不是本体）


---

# 第 8 章 IO 库

> 目标：掌握 iostream / fstream / sstream 三兄弟，理解流状态与条件状态恢复。

## 8.1 IO 类的家族关系

```
                    istream（输入流）      ostream（输出流）
                   ↙           ↘          ↙          ↘
           ifstream          ifstream / ofstream / ...
           （文件）           iostream（双流）
```

| 头文件 | 类 | 用途 |
|---|---|---|
| `<iostream>` | istream / ostream / iostream | 标准输入输出（cin/cout/cerr/clog） |
| `<fstream>` | ifstream / ofstream / fstream | 文件读写 |
| `<sstream>` | istringstream / ostringstream / stringstream | 内存中"字符串流" |

所有流类共享同一套接口（`>>`、`<<`、getline、状态管理），**学会一个 = 学会三个**。IO 对象**不能拷贝**，所以函数传递流只能用引用，返回也只能返回引用。

## 8.2 流的状态与恢复（本章核心！）

每个流有 4 个状态标志：

| 状态 | 含义 |
|---|---|
| `strm.good()` | 一切正常 |
| `strm.eof()` | 读到了文件结束 |
| `strm.fail()` | IO 操作失败（**可恢复**，如类型不匹配） |
| `strm.bad()` | 流已损坏（系统级错误，基本没救） |

流对象能直接当 bool 用：`while (cin >> x)` 等价于 `while (!(cin >> x).fail())`。

### 实战：循环读取 + 失败恢复

```cpp
int val;
while (cin >> val) {          // 正常处理
    cout << val << '\n';
}
// 走到这里说明失败了：
if (cin.eof())
    cout << "输入正常结束\n";
else {
    cin.clear();              // 1. 清除所有失败标志（good 置位）
    cin.ignore(numeric_limits<streamsize>::max(), '\n');  // 2. 丢弃坏输入
    cout << "输入有误，已跳过\n";
}
```

**关键**：失败状态一旦置位，后续所有 IO 都立即失败。必须先 `clear()` 再读。

### 每次刷新输出缓冲区

```cpp
cout << "重要日志" << endl;    // endl：刷新
cout << unitbuf;               // 之后每次输出都立即刷新（性能差，调试用）
cout << nounitbuf;             // 恢复
```

## 8.3 文件输入输出（fstream）

```cpp
#include <fstream>

// 写文件（ofstream）
ofstream out("result.txt");        // 打开（默认截断模式，文件已有内容会被清空！）
if (!out) {                       // 打开失败要检查！
    cerr << "无法打开文件\n";
    return -1;
}
out << "hello file\n";

// 读文件（ifstream）
ifstream in("data.txt");
string line;
while (getline(in, line))         // 逐行读
    cout << line << '\n';

// 追加模式
ofstream append("log.txt", ios::app);
append << "新日志\n";
```

### 文件模式（file mode）

| 模式 | 含义 |
|---|---|
| `in` | 读（ifstream 默认） |
| `out` | 写（ofstream 默认） |
| `app` | 追加到末尾 |
| `trunc` | 截断（out 的默认搭档） |
| `ate` | 打开后立即定位到文件尾 |
| `binary` | 二进制模式 |

```cpp
ofstream out1("f1");                    // out | trunc：清空重写
ofstream out2("f2", ios::app);          // out | app：追加
// ofstream in("f3", ios::in);          // 错误：ofstream 不允许只设 in
// ifstream f("f4", ios::out);          // 错误
```

### fstream 特有：open / close

```cpp
ifstream ifile;
ifile.open("a.txt");    // 可先构造后打开
ifile.close();          // 换文件前必须 close
ifile.open("b.txt");    // 重新打开后流状态会被重置为 good
// 同一个流对象可以依次处理多个文件
```

**注意**：open 失败会置 failbit；对象销毁时自动 close（析构函数兜底——又是 RAII）。

### 实战：文件重定向版书店程序

```cpp
// bookstore.cpp：读交易文件，按 ISBN 汇总，结果写文件
int main(int argc, char *argv[]) {
    if (argc != 4) {
        cerr << "用法: " << argv[0] << " 输入文件 输出文件\n";
        return 1;
    }
    ifstream input(argv[1]);        // argc/argv 用上了！
    ofstream output(argv[2]);
    Sales_data total;
    if (read(input, total)) {
        Sales_data trans;
        while (read(input, trans)) {
            if (total.isbn() == trans.isbn())
                total.combine(trans);
            else {
                print(output, total) << '\n';
                total = trans;
            }
        }
        print(output, total) << '\n';
    } else
        cerr << "没有数据\n";
    return 0;
}
```

## 8.4 string 流（sstream）

字符串流把 **string 当作流来读写**——最经典用途：**解析行内字段**。

### 实战：解析"人名 + 若干电话"的文本

```
morgan 2015552368 8625550123
drew 9735550130
lee 6095550132 2015550177 8005550000
```

```cpp
#include <sstream>
#include <fstream>
#include <iostream>
#include <vector>
#include <string>
using namespace std;

struct PersonInfo {
    string name;
    vector<string> phones;
};

int main() {
    string line, word;
    vector<PersonInfo> people;

    ifstream input("people.txt");
    while (getline(input, line)) {       // 1. 整行读进来
        PersonInfo info;
        istringstream record(line);      // 2. 把行绑定到字符串流
        record >> info.name;             // 3. 从"行流"里逐词提取
        while (record >> word)
            info.phones.push_back(word);
        people.push_back(info);
    }
    // 输出验证
    for (const auto &p : people) {
        cout << p.name << " ";
        for (const auto &ph : p.phones) cout << ph << " ";
        cout << '\n';
    }
}
```

**为什么不直接 `cin >> name >> phones...`？** 因为无法知道一行在哪结束、下一行从哪开始。**"先 getline 拿整行，再 istringstream 拆字段"是固定套路**。

### ostringstream：拼装输出

```cpp
// 实战：校验电话后生成报告行
for (const auto &entry : people) {
    ostringstream formatted, badNums;
    for (const auto &nums : entry.phones) {
        if (!valid(nums))                 // 假设的校验函数
            badNums << " " << nums;       // 攒无效号码
        else
            formatted << " " << nums;     // 攒有效号码
    }
    if (badNums.str().empty())            // str()：取出流中的字符串
        cout << entry.name << ":" << formatted.str() << '\n';
    else
        cerr << "input error: " << entry.name
             << " invalid number(s)" << badNums.str() << '\n';
}
```

**sstream 的价值**：先在内存里拼好格式，一次成型再输出——避免边拼边打印导致错误信息夹杂合法输出。

## 8.5 格式化输出（补充实用内容）

```cpp
#include <iomanip>
cout << boolalpha << true << '\n';        // 输出 true 而非 1
cout << noboolalpha;

cout << showbase << hex << 20 << '\n';    // 0x14（带基数前缀）
cout << dec;

cout << setw(12) << left << "name"        // 宽度、左对齐
     << setw(8) << right << 100 << '\n';
cout << setprecision(3) << 3.14159 << '\n';  // 3.14
```

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| 流失败后继续读 | 全部读取立即失败 | 先 `clear()`，再清掉残留输入 |
| 按值传递流 | 编译错误 | IO 对象不能拷贝，传引用 |
| 忘记检查 open | 数据悄悄丢失 | `if (!ifs)` 检查 |
| ofstream 默认截断 | 覆盖旧文件 | 想保留加 `ios::app` |
| 循环内重复 open 同一文件 | 第二次 open 前需 close | 或用局部作用域让析构 close |
| 直接 cin 拆行内字段 | 行边界混乱 | getline + istringstream |

## 本章小结

1. 三个流家族接口统一：**iostream 控制台、fstream 文件、sstream 内存字符串**。
2. 流不能拷贝 → 传引用、返回引用。
3. fail 状态必须 `clear()` 恢复；`eof` 是正常结束。
4. 文件模式：默认截断，追加用 app；open 前 close。
5. "整行解析"套路：`getline` + `istringstream`；"拼装输出"用 `ostringstream`。

## 练习

1. 编写程序：读入一个文本文件，统计总行数、总单词数、总字符数。
2. 把 Sales_data 交易程序改成文件输入 + 文件输出 + 无效数据记入 cerr。
3. 用 istringstream 解析 CSV 格式的一行（逗号分隔），把各字段存入 vector<string>（提示：getline 可以指定分隔符：`getline(record, field, ',')`）。


---

# 第 9 章 顺序容器

> 目标：会选容器、会用容器接口、懂迭代器失效规则与内存策略。

## 9.1 容器全景与选择策略

| 容器 | 内存结构 | 随机访问 | 头部插入 | 尾部插入 | 中间插入 |
|---|---|---|---|---|---|
| `vector` | 连续数组 | O(1) | O(n) | 均摊 O(1) | O(n) |
| `deque` | 分段连续 | O(1) | O(1) | O(1) | O(n) |
| `list` | 双向链表 | ? | O(1) | O(1) | O(1) |
| `forward_list` | 单向链表 | ? | O(1)（头部） | ? | O(1)（已知位置后） |
| `array` | 定长数组 | O(1) | ? | ? | ? |
| `string` | 字符连续 | O(1) | - | 均摊 O(1) | O(n) |

**选择法则**：
1. **默认用 vector**（缓存友好，绝大多数场景最快）。
2. 频繁头尾插删 → `deque`。
3. 频繁中间插删且只顺次遍历 → `list`/`forward_list`。
4. 大小固定 → `array`（比内置数组好在：可拷贝、可赋值、知道自己的 size）。

> 记住：链表的"O(1) 插入"只在**已持有位置迭代器**时成立；按值查找位置本身是 O(n)。

## 9.2 容器通用操作

```cpp
vector<int> v = {1, 2, 3};
list<int> lst;

v.size()        // 元素数
v.empty()
v.clear()       // 清空
v.swap(v2)      // 交换两容器内容（O(1)，迭代器不失效——指向互换后的容器）
v == v2 / != / < / ...   // 元素逐个比较（字典序）

v.insert(v.begin() + 1, 42);        // 在迭代器前插入，返回指向新元素
v.insert(v.end(), {7, 8, 9});       // 插入范围/列表
v.emplace(args...);                 // 原地构造元素（见下）

auto it = v.erase(v.begin());       // 删除，返回下一个有效迭代器
v.erase(v.begin(), v.end());        // 范围删除
```

### emplace_back vs push_back（C++11 重要优化）

```cpp
class Widget {
public:
    Widget(const string &s, int n);
};

vector<Widget> vw;
vw.push_back(Widget("a", 1));   // 先构造临时对象，再拷贝/移动进容器（两步）
vw.emplace_back("a", 1);        // 在容器内存里直接构造（一步）
```

**规则**：emplace 系列把参数转发给元素类型的构造函数，省去一次拷贝。**能用 emplace 就用 emplace**。

### ?? insert/push 返回值与错误用法

```cpp
// 经典错误：插入自身元素导致迭代器失效
vector<int> v = {1, 2, 3};
// v.insert(v.begin(), v.back());   // 灾难！插入过程中 v.back() 可能失效

// 正确：先取出值
int last = v.back();
v.insert(v.begin(), last);
```

## 9.3 vector 的扩容机制（面试高频）

```cpp
vector<int> v;
v.capacity()    // 当前已分配空间能容纳的元素数
v.size()        // 实际元素数
v.shrink_to_fit()  // 请求归还多余容量（不保证执行）

// 观察扩容策略：
for (int i = 0; i < 10; ++i) {
    v.push_back(i);
    cout << "size=" << v.size() << " capacity=" << v.capacity() << '\n';
}
// 典型输出（GCC）：capacity 1 2 4 8 16... 每次 ×2（扩容时旧内存整体搬家）
```

**理论**：vector 扩容时 (1) 分配更大内存（通常翻倍），(2) 把旧元素**移动**到新内存，(3) 释放旧内存。这就是**扩容导致所有迭代器/指针/引用失效**的原因。

**工程实践**：能预估数量就先 `v.reserve(n)` 预分配，避免反复搬家：

```cpp
vector<int> v;
v.reserve(1000);   // 只分配空间，size 仍是 0
```

### ?? 迭代器失效规则完整版（背！）

| 容器 | 插入 | 删除 |
|---|---|---|
| vector/string | 扩容→全部失效；否则插入点之后失效 | 被删点之后失效 |
| deque | 两端插入→迭代器失效（引用仍有效）；中间插入→全部失效 | 两端删除→仅指向被删元素的失效；中间→全部失效 |
| list/forward_list | 仅指向新元素的迭代器是新分配的，其余都不失效 | 仅被删元素的迭代器失效 |

**万能安全写法**：增删后不再使用旧迭代器；`erase` 的返回值接住继续走。

## 9.4 string 的补充操作

```cpp
s.substr(pos, n);     // 子串
s.insert/erase/append/replace;
s.find(r)             // 返回下标；找不到返回 string::npos
s.rfind(r)            // 从后往前找
// find 系列实战：
string s = "hello world";
auto pos = s.find('o');        // 4
while (pos != string::npos) {
    cout << pos << ' ';
    pos = s.find('o', pos + 1); // 从下一位置继续
}
// 数值互转（C++11）：
to_string(42); stoi("42"); stod("3.14");
```

## 9.5 容器适配器：stack / queue / priority_queue

适配器 = 对底层容器的封装，只暴露受限接口。

```cpp
#include <stack>
stack<int> stk;
stk.push(1); stk.emplace(2);
stk.top(); stk.pop();   // 注意：top() 只读，pop() 只删不返回！

#include <queue>
queue<int> q;
q.push(1); q.front(); q.back(); q.pop();

priority_queue<int> pq;           // 默认大顶堆：top() 是最大值
pq.push(3); pq.push(1); pq.push(4);
pq.top();    // 4
pq.pop();
```

**实战：用 priority_queue 求前 K 大**

```cpp
vector<int> topK(const vector<int> &nums, size_t k) {
    priority_queue<int, vector<int>, greater<int>> minHeap;  // 小顶堆
    for (int n : nums) {
        minHeap.push(n);
        if (minHeap.size() > k) minHeap.pop();   // 弹出最小的
    }
    return {minHeap.begin? };
    // 说明：priority_queue 不直接支持遍历，实际做法见完整示例
}
// 标准做法：
vector<int> topK(const vector<int> &nums, size_t k) {
    priority_queue<int, vector<int>, greater<int>> mh;
    for (int n : nums) {
        if (mh.size() < k) mh.push(n);
        else if (n > mh.top()) { mh.pop(); mh.push(n); }
    }
    // 取出结果：从大到小
    vector<int> result(mh.size());
    for (size_t i = mh.size(); i > 0; --i) { result[i-1] = mh.top(); mh.pop(); }
    return result;
}
```

## 实战项目：学生成绩管理（容器综合运用）

```cpp
#include <iostream>
#include <vector>
#include <deque>
#include <list>
#include <string>
using namespace std;

// 需求：按入学顺序记录成绩，快速访问最新 N 条，还要能任意位置插入备注

int main() {
    // 1. vector 存全班成绩：随机访问 + 尾部追加
    vector<int> scores;
    for (int s : {88, 92, 75, 60, 95}) scores.push_back(s);

    // 2. 预估规模，reserve 避免扩容
    vector<int> big; big.reserve(10000);

    // 3. deque：最新成绩从前面进（滑动窗口式处理）
    deque<int> recent;
    for (int s : scores) {
        recent.push_front(s);
        if (recent.size() > 3) recent.pop_back();   // 只留最近3条
    }

    // 4. list：中间插入备注不打扰其他元素
    list<string> notes = {"期中考试", "期末考试"};
    auto it = notes.begin();
    ++it;
    notes.insert(it, "阶段测验");   // 期中、阶段测验、期末

    // 输出
    cout << "最近成绩: ";
    for (int s : recent) cout << s << ' ';
    cout << '\n';
    for (const auto &n : notes) cout << n << " -> ";
    cout << "结束\n";
}
```

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| 扩容后用旧指针/迭代器 | push_back 后仍用之前保存的 end | 全部失效 |
| 删除时不用返回值 | `v.erase(it); ++it;` 跳元素 | `it = v.erase(it)` 接住 |
| stack 的 pop 当返回值用 | `int x = stk.pop();` | pop 不返回值，先 top() 再 pop() |
| vector 头部插入多 | `v.insert(v.begin(), x)` 循环里用 | O(n) 每次搬家，改用 deque |
| reserve 当 resize 用 | size 仍是 0 | reserve 只分配，resize 才加元素 |
| 遍历时修改容器 | 范围 for 内 push_back | 迭代器失效 |

## 本章小结

1. **默认 vector**；头尾操作多 → deque；中间插删+遍历 → list。
2. emplace 系列原地构造，优于 push+临时对象。
3. vector 扩容翻倍搬家 → 所有迭代器失效；`reserve` 预分配是性能药。
4. erase 返回下一个有效迭代器，是"边遍历边删"的唯一正确姿势。
5. 适配器（stack/queue/priority_queue）限制接口、表达意图。

## 练习

1. 编写程序：把 1~25 拷贝进 list 和 vector，从每个容器中删除偶数（对比两种容器删除时迭代器处理方式的差异）。
2. 实现函数：删除 vector 中所有重复元素（先 sort 再 unique + erase）。
3. 用两个 stack 实现一个队列（经典面试题）。


---

# 第 10 章 泛型算法

> 目标：掌握"容器 + 算法 + 谓词"三板斧，理解 lambda——写出简洁如诗的 C++。

## 10.1 概述

标准库提供了 100+ **泛型算法**：不绑定具体容器类型，通过**迭代器**操作元素序列。

```cpp
#include <algorithm>    // 大部分算法
#include <numeric>      // accumulate 等
#include <iterator>     // 迭代器适配器

vector<int> v = {3, 1, 4, 1, 5};
int val = 42;

auto result = find(v.cbegin(), v.cend(), val);  // 找 42，返回迭代器
if (result == v.cend())
    cout << "没找到\n";            // end 是"没找到"的哨兵

// 只读算法
accumulate(v.begin(), v.end(), 0);        // 求和（初值 0 决定类型！）
equal(v1.cbegin(), v1.cend(), v2.cbegin());// 逐元素相等（要求 v2 至少同长）

// 写算法
fill(v.begin(), v.begin() + 2, 0);        // 前2个填 0
vector<int> v2;
fill_n(back_inserter(v2), 5, 1);          // 向"空"容器写入：插入迭代器
copy(v.begin(), v.end(), back_inserter(v2)); // 拷贝追加
replace(v.begin(), v.end(), 1, 0);        // 把 1 全替换为 0
replace_copy(v.begin(), v.end(), back_inserter(v3), 1, 0); // 复制版（不改原）

// 重排
sort(v.begin(), v.end());
auto end_uniq = unique(v.begin(), v.end());  // "去重"：把重复移到尾部，返回分界
v.erase(end_uniq, v.end());                  // 真正删除（unique 只移动，不删）
```

**三个关键理解**：
1. 算法**不检查目的空间够不够**——`fill_n(v2.begin(), 5, 1)` 对空 vector 是未定义行为。用插入迭代器 `back_inserter` 保证安全。
2. 算法**不改变容器大小**（除插入迭代器外），只搬动元素。
3. `accumulate(v.begin(), v.end(), 0)` 用 int 求和；写 `0.0` 则按 double 累加——**初值的类型决定计算类型**。

## 10.2 定制操作：谓词与 lambda

很多算法可传一个"可调用对象"来定制行为：

- **谓词**：返回 bool 的函数（一元/二元）。
- **lambda 表达式**（C++11）：就地写匿名函数。

```cpp
// lambda 语法：
[capture](parameters) -> return_type { body }
//         ↑ 捕获列表       ↑ 可省略
```

### 实战：各种姿势的排序

```cpp
vector<string> words = {"the", "quick", "red", "fox", "jumps", "over"};

// 1. 普通函数做谓词：按长度排
bool isShorter(const string &a, const string &b) {
    return a.size() < b.size();
}
sort(words.begin(), words.end(), isShorter);

// 2. lambda 就地写
sort(words.begin(), words.end(),
     [](const string &a, const string &b) { return a.size() < b.size(); });

// 3. 稳定排序：先去重，再按长度排序（相同长度保持字典序）
elimDups(words);                                // sort + unique + erase
stable_sort(words.begin(), words.end(),
            [](const string &a, const string &b) { return a.size() < b.size(); });

// 4. find_if：找第一个满足谓词的
auto wc = find_if(words.begin(), words.end(),
                  [](const string &s) { return s.size() >= 5; });
cout << *wc << '\n';    // "quick"

// 5. 计数：count_if
auto cnt = count_if(words.begin(), words.end(),
                    [](const string &s) { return s.size() > 4; });
```

### 捕获列表：lambda 的灵魂

```cpp
int sz = 5;
// [sz] 按值捕获：把 sz 拷一份进 lambda（默认不可改，mutable 可改副本）
auto f1 = [sz](const string &s) { return s.size() >= sz; };

// [&sz] 按引用捕获：绑定本体（注意 lambda 生命周期长于变量时悬空！）
auto f2 = [&sz](const string &s) { return s.size() >= sz; };

// [=] / [&]：隐式捕获全部用到的东西（值/引用）
auto f3 = [=](const string &s) { return s.size() >= sz; };
// [=, &os]：默认值捕获，os 单独引用
auto f4 = [=, &os](const string &s) { os << s; return s.size() >= sz; };
```

**捕获原则**：
- 尽量**少捕获**，且优先按值（除非对象大或必须反映修改）。
- 按引用捕获时，**lambda 存活期不能超过被捕获变量的生命周期**（回调、存进容器时尤其小心）。

### ?? lambda 的两个隐蔽坑

```cpp
int a = 1;
auto byVal = [a]() mutable { return ++a; };   // mutable 才能改值捕获的副本
// byVal() 每次都返回 2！修改的是副本，a 不受影响，且副本随 lambda 对象保存

int b = 1;
auto byRef = [&b]() { return ++b; };          // 改的是本体
```

### for_each + lambda：就地处理

```cpp
vector<int> v = {1, 2, 3, 4, 5};
for_each(v.begin(), v.end(), [](int &x) { x *= 2; });   // 注意 & 才能改

// 经典：输出并以顿号分隔
ostream &os = cout; char c = ',';
for_each(v.begin(), v.end(), [&, c](int x) { os << x << c; });
```

## 10.3 biggst：一个完整的实战函数

**需求**：去重 → 按长度排序 → 输出所有长度 ≥ sz 的词。

```cpp
void biggies(vector<string> &words, vector<string>::size_type sz)
{
    elimDups(words);   // sort + unique + erase
    // 按长度排，同长保持字典序
    stable_sort(words.begin(), words.end(),
                [](const string &a, const string &b)
                { return a.size() < b.size(); });
    // 找到第一个长度 >= sz 的位置
    auto wc = find_if(words.begin(), words.end(),
                      [sz](const string &a) { return a.size() >= sz; });
    // 计算并输出
    auto count = words.end() - wc;
    cout << count << " 个单词长度 >= " << sz << '\n';
    for_each(wc, words.end(), [](const string &s) { cout << s << ' '; });
    cout << '\n';
}
```

### 用其他算法重排逻辑（体验泛型威力）

```cpp
// 版本2：partition 一刀两断（满足条件的挪前面），不需要先排序！
auto wc = partition(words.begin(), words.end(),
                    [sz](const string &s) { return s.size() >= sz; });
// stable_partition 版本可保持原有相对顺序
```

## 10.4 lambda 进阶：值捕获的实质

lambda 其实是编译器生成的**匿名类**，捕获的变量就是它的数据成员：

```cpp
int sz = 5;
auto f = [sz](const string &s) { return s.size() >= sz; };
// 大致等价于：
class __Anon {
    int sz;                       // 捕获 → 成员（按值时 const）
public:
    __Anon(int s) : sz(s) {}      // 捕获即构造
    bool operator()(const string &s) const { return s.size() >= sz; }
};
```

这解释了：为什么需要 `mutable` 才能改按值捕获的变量（改的是成员副本）；为什么按引用捕获是"存引用/指针"（可能悬空）。

## 10.5 bind：老式的参数绑定（了解）

```cpp
#include <functional>
using namespace std::placeholders;

bool check_size(const string &s, string::size_type sz) { return s.size() >= sz; }

// _1 是占位符：调用 g(s) 时，s 填到 check_size 的第一个参数
auto g = bind(check_size, _1, 6);
g("hello");    // check_size("hello", 6)

// 还能重排参数顺序：
auto isShorter = [](const string &a, const string &b) { return a.size() < b.size(); };
auto descOrder = bind(isShorter, _2, _1);   // 反转参数：按长度降序！
sort(words.begin(), words.end(), descOrder);
```

**现代建议**：能用 lambda 就用 lambda，bind 只在阅读老代码时需要看懂。C++14 泛型 lambda 出现后 bind 的应用场景更少了。

## 10.6 插入迭代器与其他迭代器类别

| 迭代器 | 作用 |
|---|---|
| `back_inserter(c)` | 每次赋值变为 push_back |
| `front_inserter(c)` | 每次赋值变为 push_front（结果是**倒序**） |
| `inserter(c, it)` | 在 it 之前插入（保持顺序） |

```cpp
list<int> lst = {1, 2, 3};
list<int> lst2, lst3;
copy(lst.cbegin(), lst.cend(), front_inserter(lst2));  // 3 2 1
copy(lst.cbegin(), lst.cend(), inserter(lst3, lst3.begin())); // 1 2 3
```

### 五种迭代器类别（理论）

```
输入迭代器   只读、单遍（find 要求）
输出迭代器   只写、单遍（copy 第三参数）
前向迭代器   读写、多遍（replace、forward_list）
双向迭代器   可后退（sort、reverse、list）
随机访问迭代器 ±n 跳跃（vector、deque、array）
```

算法对迭代器有**最低要求**：给 list 传给需要随机访问的 `sort` 编译报错；应改用 `list::sort` 成员版本。

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| 目的空间不足就写入 | `fill_n(v.begin(), 5, 1)` 空 v | 用 back_inserter |
| unique 后不 erase | 容器里"重复"还在尾部 | unique 只移动 |
| accumulate 初值类型 | `accumulate(..., 0)` 累加 double | 丢小数；初值写 0.0 |
| 按引用捕获后变量先死 | 回调访问悬空引用 | 存长命的 lambda 用值捕获 |
| 忘了 mutable | 修改值捕获报错 | 或直接改用引用捕获（想改本体） |
| front_inserter 以为正序 | 结果倒序 | 语义如此 |

## 本章小结

1. 算法 = 迭代器对 + 可选谓词/可调用对象；不关心容器类型，不改容器大小。
2. **lambda = 匿名函数对象**：捕获即成员；值捕获拷贝、引用捕获易悬空。
3. 三板斧套路：sort → unique → erase 去重；find_if/count_if/for_each 定制查询。
4. back_inserter 让"写算法"对空容器也安全。
5. bind 是历史方案，新代码用 lambda。

## 练习

1. 用 `count_if` 统一个 vector<string> 中长度超过 6 的单词个数（lambda 实现）。
2. 把 biggies 改写为 partition 版本，并输出长度 ≥ sz 的词。
3. 不用 for 循环（纯算法）：把 v 中所有偶数乘 2 后拷贝到新 vector（提示：copy_if + for_each）。


---

# 第 11 章 关联容器

> 目标：掌握 map/set 的 CRUD、无序容器原理与正确的遍历删除姿势。

## 11.1 关联容器总览

| 类型 | 有序（红黑树） | 无序（哈希表） | 特点 |
|---|---|---|---|
| 集合 | `set` / `multiset` | `unordered_set` / `unordered_multiset` | 只存 key |
| 映射 | `map` / `multimap` | `unordered_map` / `unordered_multimap` | key→value |

- **有序容器**：按 key 排序保存，遍历有序，查找 O(log n)，要求 key 支持 `<`。
- **无序容器**：哈希桶，平均 O(1) 查找，遍历无序，要求 key 支持 `==` 和哈希。
- `multi` 前缀 = 允许重复 key；不带 multi 的 set/map **key 必须唯一**。

## 11.2 map：最常用的关联容器

```cpp
#include <map>

// 统计每个单词出现次数（map 最经典应用）
map<string, size_t> word_count;
string word;
while (cin >> word)
    ++word_count[word];   // word 不存在时自动【值初始化】为 0，再 ++
// 三种情况一次搞定：不存在则创建（值为0）、存在则取出、++ 更新
```

### ?? 下标操作的副作用（大坑！）

```cpp
map<string, size_t> m = {{"a", 1}};

m["b"];        // 只是"读"？错！这会【插入】b，值为 0！
size_t x = m["z"];    // 同样插入 z，size() 变了

// 只想查、不想插：
if (m.count("b")) ...             // 计数：0 或 1
auto it = m.find("b");
if (it != m.end()) cout << it->second;
m.at("b");    // 不存在时抛 out_of_range，不插入
```

**规则**：**非修改场景一律用 find/count/at，绝不用 `[]` 读取**。`[]` 仅用于"存在就更新、不存在就插入"的场景。

### map 的三种插入方式

```cpp
map<string, size_t> m;

m.insert({"word", 1});                    // 1. 花括号（推荐）
m.insert(make_pair("word", 1));           // 2. make_pair
m.insert(map<string, size_t>::value_type("word", 1));  // 3. 啰嗦

// insert 的返回值：pair<iterator, bool>
auto ret = m.insert({"word", 1});
if (!ret.second)          // false 说明 key 已存在，插入失败
    ret.first->second++;  // ret.first 是指向已存在元素的迭代器

// C++11 更好用的 upsert（存在则调用函数，不存在则插入）：
m["new"] = 1;
// 批量插入：
m.insert({{"a",1}, {"b",2}});
```

### 遍历：元素是 pair

```cpp
for (const auto &p : word_count)
    cout << p.first << " 出现 " << p.second << " 次\n";
// p.first 是 const key（不可改！），p.second 是 value

// 结构化绑定更顺手（C++17）：
for (const auto &[word, cnt] : word_count)
    cout << word << " 出现 " << cnt << " 次\n";
```

## 11.3 set：成员去重的利器

```cpp
// 需求：忽略常见单词，只统计其他单词
set<string> exclude = {"the", "but", "and", "or", "a"};
map<string, size_t> word_count;

while (cin >> word)
    if (exclude.find(word) == exclude.end())   // 不在排除表才统计
        ++word_count[word];

// set 的插入
set<int> s = {1, 2, 3};
auto r = s.insert(4);      // pair<iterator,bool>
s.insert({5, 6});          // 列表批量
s.insert(v.begin(), v.end());
```

### 实战：用 set 实现"已读"去重（pair 的 set）

```cpp
// 统计 1~10 中每个家庭拥有的孩子（vector<pair> 转 set）
vector<pair<string, string>> family = {{"zhang", "san"}, {"li", "si"},
                                        {"zhang", "si"}};
set<pair<string, string>> unique_family(family.begin(), family.end());
// 重复的 {"zhang","si"} 只保留一份
```

## 11.4 pair 类型

```cpp
#include <utility>
pair<string, int> p{"answer", 42};

p.first; p.second;
auto p2 = make_pair("answer", 42);    // 推导类型
// pair 的比较：先比 first，first 相同比 second（字典序）
```

## 11.5 关联容器的特殊操作

```cpp
word_count.erase("a");      // 按 key 删，返回删除数量（0 或 1）
word_count.erase(it);       // 按迭代器删（必须指向有效元素），返回下一个

// 只读查找全家桶（lower/upper/bound 仅有序容器有）：
m.find(key);          // 迭代器或 end
m.count(key);         // multimap 中可能 >1
m.lower_bound(key);   // 第一个 >= key 的位置
m.upper_bound(key);   // 第一个 > key 的位置
m.equal_range(key);   // pair(lower, upper)：multimap 遍历同 key 首选
```

### multimap 实战：一个作者多本书

```cpp
multimap<string, string> authors;
authors.insert({"Barth, John", "Sot-Weed Factor"});
authors.insert({"Barth, John", "Lost in the Funhouse"});
authors.insert({"Austen, Jane", "Emma"});

// 查找某作者的所有书（错误做法：find 只返回第一条附近）
// 正确做法 1：equal_range
for (auto [b, e] = authors.equal_range("Barth, John"); b != e; ++b)
    cout << b->second << '\n';

// 正确做法 2：lower/upper_bound
for (auto beg = authors.lower_bound("Barth, John"),
          end = authors.upper_bound("Barth, John"); beg != end; ++beg)
    cout << beg->second << '\n';
```

### ?? 遍历中删除元素的正确姿势

```cpp
// map/set 的迭代器只有被删除那个会失效，其余稳定 → 可以这样：
auto it = m.begin();
while (it != m.end()) {
    if (需要删除(it)) {
        it = m.erase(it);   // C++11 起返回下一个
    } else {
        ++it;
    }
}
```

## 11.6 无序容器（unordered_*）

```cpp
unordered_map<string, size_t> word_count;
++word_count[word];    // 用法与 map 完全一致，只是底层不同
```

**理论：哈希桶结构**

```
buckets:  [0] -> ("apple", 3)
          [1] -> nullptr
          [2] -> ("banana", 1) -> ("cherry", 5)   // 冲突：链起来
          [3] -> nullptr
```

- 每个元素按 `hash(key) % bucket_count` 落桶；同桶元素链表串接。
- **负载因子 = size / bucket_count**；超过阈值自动 rehash（桶数变化 → **迭代器全部失效**）。
- 内置类型和 string/指针有默认 hash；**自定义类型要提供 `hash` 结构或转成已有类型**：

```cpp
// 自定义 key 的 hash
struct MyKey { int a; string b; };
struct MyKeyHash {
    size_t operator()(const MyKey &k) const {
        return hash<int>()(k.a) ^ (hash<string>()(k.b) << 1);
    }
};
struct MyKeyEq {
    bool operator()(const MyKey &x, const MyKey &y) const {
        return x.a == y.a && x.b == y.b;
    }
};
unordered_map<MyKey, int, MyKeyHash, MyKeyEq> m;
```

**选型**：需要有序遍历 / 范围查询 / 稳定迭代器 → map/set；纯查找、key 可哈希 → unordered（平均更快）。生产环境注意最坏 O(n) 与哈希碰撞攻击。

## 实战项目：单词转换映射表（原书经典案例）

**需求**：把文本中的缩写展开成全称（"brb" → "be right back"）。

```cpp
// map_file: 规则文件        input: 原文
#include <fstream>
#include <sstream>
#include <map>
#include <string>
#include <iostream>
using namespace std;

// 建立"缩写 → 全称"映射
map<string, string> buildMap(ifstream &map_file) {
    map<string, string> trans_map;
    string key, value;
    while (map_file >> key && getline(map_file, value))
        if (value.size() > 1)                      // 跳过仅有一个空格的 value
            trans_map[key] = value.substr(1);      // 去掉 key 后那个空格
        else
            throw runtime_error("no rule for " + key);
    return trans_map;
}

const string& transform(const string &word, const map<string, string> &m) {
    auto it = m.find(word);         // 用 find，绝不用 []！（const 也不允许）
    return it == m.cend() ? word : it->second;
}

void wordTransform(ifstream &map_file, ifstream &input) {
    auto trans_map = buildMap(map_file);
    string text;
    while (getline(input, text)) {          // 整行读（第 8 章套路）
        istringstream stream(text);
        string word;
        bool firstword = true;
        while (stream >> word) {            // istringstream 拆词
            cout << (firstword ? "" : " ");
            cout << transform(word, trans_map);
            firstword = false;
        }
        cout << '\n';
    }
}
```

**设计要点**：
1. const 引用参数 → 只能用 `find`，编译器强制你避开 `[]` 陷阱。
2. "getline 整行 + stringstream 拆词" 再次登场——两章知识联动。

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| 用 `[]` 查 map | 意外插入元素 | 查找用 find/count/at |
| 遍历中改 key | `it->first = ...` | key 是 const，编译错 |
| multimap 用 `[]` | 编译错误 | multimap 没有下标 |
| unordered_map 当有序用 | 遍历顺序 ≠ 插入顺序 | 要有序就用 map |
| 自定义 key 没给 hash | 编译错误 | 提供或改用有序容器 |
| rehash 后用旧迭代器 | 失效 | 结构变化后重取 |

## 本章小结

1. 有序（map/set，红黑树，O(log n)）vs 无序（哈希，平均 O(1)）按需求选。
2. map 下标 `[]` 是"读取即插入"的接口；**纯查找永远 find/count/at**。
3. 元素即 pair：`first` 是 const key、`second` 是 value；C++17 结构化绑定优雅遍历。
4. multimap 遍历同 key 用 `equal_range` 或 `lower/upper_bound`。
5. 遍历删除：`it = m.erase(it)`。

## 练习

1. 统计一段文本每个单词的出现次数，按**出现次数降序**输出（map 统计 → 拷到 vector<pair> → sort）。
2. 用 multimap<string, string> 实现家庭档案：按姓氏增删查成员，列出某姓氏全部成员。
3. 实现 `first_not repeated`：找出字符串中第一个不重复出现的字符（提示：unordered_map 计数 + 二次扫描）。


---

# 第 12 章 动态内存

> 目标：理解栈与堆、掌握智能指针——从此告别内存泄漏与悬空指针。

## 12.1 为什么需要动态内存

```cpp
void foo() {
    int x = 42;        // 栈对象：函数返回自动销毁
    string s;          // 同上
}
```

**栈对象的局限**：生命周期与作用域绑定。但有时对象需要：
1. 比创建它的函数**活得更久**（函数返回后还要用）；
2. **运行时才能确定大小**（`int arr[n]` 传统 C++ 不支持变长栈数组）；
3. 在多个使用者间**共享**（计数归零时才销毁）。

C++ 把"内存管理"从"指针裸奔"升级为"**智能指针管理对象生命周期**"。

## 12.2 new 与 delete（基础，但要慎用）

```cpp
int *pi = new int(1024);            // 分配并初始化一个 int
int *pa = new int[10]{1,2,3};       // 分配数组（其余为0）
string *ps = new string("hi");      // 调用构造函数
Foo *pf = new Foo;                  // 默认构造

delete pi;                          // 释放单个对象
delete[] pa;                        // 数组必须用 delete[]！
delete ps;

// new 失败默认抛 bad_alloc；想拿空指针用 nothrow：
int *p = new (nothrow) int;         // 失败返回 nullptr（旧风格，不推荐）
```

### ?? 裸 new/delete 的三宗罪

```cpp
Foo *p = new Foo();
// 罪状1：忘记 delete → 内存泄漏
// 罪状2：delete 两次 → 未定义行为（堆损坏）
// 罪状3：中间 return / 抛异常 → 跳过 delete，照样泄漏
// 罪状4：delete 后继续用 → 悬空指针
// 罪状5：new[] 配 delete → 未定义行为
```

**现代规则**：**程序代码中不应该出现裸 new/delete**——它只应该活在类的构造/析构里（封装）或被智能指针取代。**RAII 原则**：资源（内存、文件、锁）的获取与释放绑定到对象的创建与销毁。

## 12.3 智能指针（本章主角）

| 类型 | 所有权 | 拷贝 | 场景 |
|---|---|---|---|
| `unique_ptr<T>` | 独占 | ? | 默认选择：一块内存一个主人 |
| `shared_ptr<T>` | 共享（引用计数） | ? | 多个使用者共享 |
| `weak_ptr<T>` | 观察（不影响计数） | ? | 打破循环引用、缓存、观察 |

```cpp
#include <memory>

// ---------- unique_ptr ----------
auto up = make_unique<int>(42);        // C++14；C++11 写 new
auto uarr = make_unique<int[]>(10);    // 动态数组
*up = 100;
cout << *up;                           // 100
// auto up2 = up;                      // 错误！不能拷贝
auto up3 = std::move(up);              // 只能转移所有权（up 变 null）
up3.reset();                           // 显式释放
if (up3) ...                           // 判空：直接当 bool 用

// ---------- shared_ptr ----------
auto sp = make_shared<int>(42);        // 推荐：一次分配对象+计数
auto sp2 = sp;                         // 引用计数：2
cout << *sp2;                          // 42
cout << sp.use_count();                // 2
// sp2 离开作用域 → 计数 1；sp 销毁 → 计数 0 → 内存释放
```

### make_shared vs new

```cpp
shared_ptr<int> p1 = make_shared<int>(42);  // ? 对象和计数一次分配，异常安全
shared_ptr<int> p2(new int(42));            // 两次分配，性能略差
// shared_ptr<int> p3 = new int(42);        // 错误！不允许隐式转换（explicit 构造）

// ?? 混用最危险：一块内存两个"主人"
int *q = p1.get();        // get() 拿裸指针（仅用于传给老接口）
// delete q;              // 灾难！智能指针还会再释放一次
```

**铁律**：
1. **`make_shared`/`make_unique` 是第一选择**。
2. 一个裸指针只对应一个智能指针管理；**绝不 delete `get()` 的返回值**。
3. `get()` 返回的裸指针不能参与另一个智能指针构造。

### 实战：工厂函数返回动态对象

```cpp
// 需求：根据类型创建不同的形状对象（第 15 章多态的铺垫）
unique_ptr<Shape> makeShape(const string &type) {
    if (type == "circle")   return make_unique<Circle>(2.0);
    if (type == "square")   return make_unique<Square>(3.0);
    return nullptr;
}
auto shape = makeShape("circle");   // 用完自动释放，零心智负担
```

## 12.4 shared_ptr 的原理：引用计数与线程安全

```
sp ──────┐
          ├──? [计数=2] [对象数据]
sp2 ──────┘

拷贝 → 计数+1          销毁 → 计数-1 → 减到 0：释放对象
```

- 拷贝 shared_ptr（如按值传参、返回）+1；销毁 -1。
- **计数本身是原子操作**（多线程拷贝/析构安全），但**指向的对象不是**——多线程写同一对象仍需加锁。
- 注意：**用裸指针初始化两个 shared_ptr = 两次独立计数 = 双重释放**：

```cpp
int *raw = new int(42);
shared_ptr<int> a(raw);
shared_ptr<int> b(raw);    // 灾难！两个独立计数，各删一次
```

### 控制块与开销

shared_ptr 一个指针大小装不下"对象地址 + 计数"，实际是**两个指针**：对象指针 + 控制块指针（计数、weak 计数、删除器）。这就是它比 unique_ptr 贵的原因——**能用 unique_ptr 就别用 shared_ptr**。

## 12.5 weak_ptr：不增计数的观察者

```cpp
auto sp = make_shared<int>(42);
weak_ptr<int> wp = sp;          // 不增加计数
// cout << *wp;                 // 错误！不能直接解引用
if (shared_ptr<int> locked = wp.lock())   // lock()：尝试升级为 shared_ptr
    cout << *locked;            // 对象还活着才有值
else
    cout << "对象已销毁\n";
wp.expired();                   // 检查对象是否已释放
wp.use_count();                  // 共享计数
```

### ?? 经典问题：循环引用（weak_ptr 的存在意义）

```cpp
struct Node {
    shared_ptr<Node> next;
    ~Node() { cout << "~Node\n"; }
};

auto a = make_shared<Node>();
auto b = make_shared<Node>();
a->next = b;      // b 计数 2
b->next = a;      // a 计数 2
// 离开作用域：a、b 计数各降为 1 —— 永远到不了 0！内存泄漏，析构不执行！

// 解法：链表/图中"回指"方向用 weak_ptr
struct Node2 {
    weak_ptr<Node2> next;      // 打破循环
};
```

**规则**：**"父持有子用 shared，子回指父用 weak"**。

## 12.6 动态数组与 allocator（进阶）

```cpp
// 现代 C++ 动态数组：直接用 vector，别用 new[]
vector<int> vi(10);           // 首选

// unique_ptr 管理数组
auto p = make_unique<int[]>(10);
p[0] = 1;                     // 支持下标

// allocator：分离"内存分配"与"对象构造"（库作者/高性能场景才用）
allocator<string> alloc;
auto const p2 = alloc.allocate(10);    // 只分配原始内存
auto q = p2;
alloc.construct(q++, "hi");            // 手动构造
alloc.construct(q++, 10, 'c');
while (q != p2)
    alloc.destroy(--q);               // 手动析构
alloc.deallocate(p2, 10);             // 释放内存
```

> 了解即可：vector 内部就是这么干的——reserve 只分配，push_back 时才逐个 construct。

## 实战项目：StrBlob——书中案例的工程化复述

**需求**：多个 Blob 对象共享同一批数据，且**拷贝的是数据本体**（深层拷贝），另外演示正确/错误的两种设计。

```cpp
#include <memory>
#include <vector>
#include <string>
#include <stdexcept>
using namespace std;

// 版本A：shared_ptr 共享数据（拷贝 Blob = 共享同一份数据）
class StrBlobPtr;                          // 前置声明（弱引用需要）

class StrBlob {
    friend class StrBlobPtr;
public:
    StrBlob() : data(make_shared<vector<string>>()) { }
    StrBlob(initializer_list<string> il)
        : data(make_shared<vector<string>>(il)) { }

    size_type size() const { return data->size(); }
    bool empty() const { return data->empty(); }
    void push_back(const string &t) { data->push_back(t); }
    void pop_back() {
        check(0, "pop_back on empty StrBlob");
        data->pop_back();
    }
    string& front() {
        check(0, "front on empty StrBlob");
        return data->front();
    }
    string& back();      // 定义放类外（演示）
private:
    void check(size_type i, const string &msg) const {
        if (i >= data->size())
            throw out_of_range(msg);
    }
    shared_ptr<vector<string>> data;       // 数据在堆上，多个 Blob 可共享
};

string& StrBlob::back() {
    check(0, "back on empty StrBlob");
    return data->back();
}

// StrBlobPtr：指向 StrBlob 的"弱"迭代器——数据可能已被释放，用 weak_ptr 防悬空
class StrBlobPtr {
public:
    StrBlobPtr() : curr(0) { }
    StrBlobPtr(StrBlob &a, size_t sz = 0)
        : wptr(a.data), curr(sz) { }       // weak_ptr 不延长数据生命
    string& deref() const {
        auto p = check(curr, "dereference past end");   // lock 升级检查
        return (*p)[curr];                 // 检查通过才能解引用
    }
    StrBlobPtr& incr() {
        check(curr, "increment past end of StrBlobPtr");
        ++curr;
        return *this;
    }
private:
    shared_ptr<vector<string>> check(size_t i, const string &msg) const {
        auto ret = wptr.lock();            // 对象还活着吗？
        if (!ret) throw runtime_error("unbound StrBlobPtr");
        if (i >= ret->size()) throw out_of_range(msg);
        return ret;
    }
    weak_ptr<vector<string>> wptr;   // weak！不参与计数
    size_t curr = 0;
};
```

**三个设计精髓**：
1. `data` 用 `shared_ptr<vector>`：Blob 拷贝后仍共享数据，最后使用者负责释放。
2. StrBlobPtr 用 `weak_ptr`：迭代器不阻止数据销毁，每次访问前 `lock()` 检查存活。
3. `check()` 统一做越界/存活校验并抛异常——错误处理集中化。

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| 裸指针 double-manage | `sp(raw); sp2(raw)` | 双重释放；统一 make_shared |
| delete `get()` 结果 | 重复释放 | get() 仅传给老接口 |
| new[] 配 delete | 未定义行为 | 数组用 delete[]，或干脆 vector |
| shared_ptr 循环引用 | 泄漏 | 回指方向用 weak_ptr |
| 函数间传 shared_ptr 期望不拷贝 | 计数变化 | 传 const 引用避免多余计数增减 |
| 用了裸 new 忘了 delete | 泄漏 | make_unique / make_shared |

## 本章小结

1. 动态内存解决"对象生命周期 ≠ 作用域"的问题。
2. **unique_ptr 独占（默认选它），shared_ptr 计数共享，weak_ptr 只看不计数**。
3. 一律 `make_unique` / `make_shared`；`get()` 的返回值不参与资源管理。
4. 循环引用用 weak_ptr 打破；"父 shared、子 weak"。
5. 动态数组 → vector；RAII 是 C++ 资源管理的总纲。

## 练习

1. 用 unique_ptr 管理一个动态分配的 `int[100]`，填充斐波那契数列后输出。
2. 编写程序验证循环引用泄漏：两个互指 shared_ptr 的对象离开作用域后，观察析构函数是否被调用；改成 weak_ptr 再试。
3. 实现一个简单 `Blob<T>` 类模板：内部 `shared_ptr<vector<T>>`，提供 push_back/size/遍历接口（为第 16 章模板热身）。


---

# 第 13 章 拷贝控制

> 目标：吃透"三/五法则"与移动语义——这是 C++ 面试与实战的分水岭。

## 13.1 五个特殊成员函数

对象的生老病死由**五个特殊成员函数**控制（编译器可自动合成，也可自定义）：

| 函数 | 何时调用 |
|---|---|
| **析构函数** `~T()` | 对象销毁时 |
| **拷贝构造** `T(const T&)` | 用另一个对象**初始化**新对象 |
| **拷贝赋值** `T& operator=(const T&)` | **已存在**对象 = 另一对象 |
| **移动构造** `T(T&&)`（C++11） | 用右值初始化新对象 |
| **移动赋值** `T& operator=(T&&)`（C++11） | 已存在对象 = 右值 |

```cpp
string s1("hi");     // 构造
string s2 = s1;      // 拷贝构造（s2 在创建）
string s3;
s3 = s1;             // 拷贝赋值（s3 已存在）
vector<string> v;
v.push_back(s1);     // 拷贝构造（元素初始化）
v.push_back(std::move(s1));   // 移动构造（s1 的内容被"搬走"，之后 s1 为空）
```

## 13.2 拷贝构造与拷贝赋值

```cpp
class HasPtr {
public:
    HasPtr(const string &s = string())
        : ps(new string(s)), i(0) { }        // 构造：分配内存
    // 拷贝构造：深拷贝
    HasPtr(const HasPtr &p)
        : ps(new string(*p.ps)), i(p.i) { }  // 新分配一块，拷内容！
    // 拷贝赋值：释放旧、深拷新
    HasPtr& operator=(const HasPtr &rhs) {
        if (this == &rhs) return *this;      // 1. 自赋值检查（重要！）
        auto newp = new string(*rhs.ps);     // 2. 先拷贝（可能抛异常，此时 this 仍完好）
        delete ps;                           // 3. 再释放旧内存
        ps = newp;                           // 4. 接上新内存
        i = rhs.i;
        return *this;                        // 5. 返回 *this 支持链式
    }
    ~HasPtr() { delete ps; }                 // 析构：释放内存
private:
    string *ps;
    int i;
};
```

**为什么默认（浅）拷贝是灾难**：

```cpp
HasPtr a("hi");
HasPtr b = a;        // 合成版本：b.ps == a.ps（同一块内存！）
// b 销毁 → delete a.ps 的内存
// a 销毁 → delete 同一块内存 → 双重释放，崩溃
```

**合成拷贝控制的行为**：逐成员拷贝/赋值/析构。对指针成员只拷"地址"不拷"内容"——**管理资源的类必须自定义拷贝控制**。

### 拷贝赋值的四步模板（背下来）

1. 自赋值检查（`if (this == &rhs)`）。
2. 先分配/拷贝，再释放（异常安全：中途抛异常不会破坏 this）。
3. 更新成员。
4. 返回 `*this`。

## 13.3 析构函数

```cpp
class X {
public:
    ~X() { /* 释放资源 */ }
};
```

**要点**：
- 析构函数**不能有参数、不能重载**，一个类只有一个。
- **销毁顺序与成员声明顺序相反**：先函数体，再按声明的逆序析构成员；类类型成员自动调用其析构函数，内置类型（包括裸指针）什么都不做——**这就是裸指针必须手动 delete 的原因**。
- 析构时机：局部变量离开作用域；对象被 delete；容器销毁其元素；临时对象表达式结束。
- **引用和指针离开作用域不析构所指向的对象**！

### ?? 智能指针成员 → 五个函数全自动合成

```cpp
class Good {
    shared_ptr<string> ps;    // 智能指针自己管生命周期
    int i;
    // 不写任何拷贝控制 → 合成版本正确！（拷贝 = 共享）
};
class Bad {
    string *ps;               // 裸指针 → 必须手写五件套
};
```

**工程铁律**：**优先让"资源"由智能指针/vector/string 成员持有**，让编译器的合成版本天然正确。

## 13.4 三法则 / 五法则（Rule of Three / Five）

**法则**：如果一个类需要自定义 **析构、拷贝构造、拷贝赋值** 中任何一个，那么**三个通常都需要自定义**（C++11 后加上移动构造、移动赋值成"五"）。

**原因**：需要自定义析构 = 类在管理资源 = 合成拷贝大概率浅拷贝出 bug。

```cpp
// 需要析构（delete ps）的类，却让合成拷贝拷指针 → 双重释放
```

### = default 与 = delete（C++11）

```cpp
class T {
public:
    T() = default;                    // 显式请求合成版本
    T(const T&) = default;            // 合成拷贝构造
    T& operator=(const T&) = delete;  // 禁止拷贝赋值（不可调用）
    T(T&&) = delete;                  // 禁止移动
    ~T() = default;
};
// = delete 可用于任何函数；= default 只能用于特殊成员函数
```

**真实例子**：`iostream` 类拷贝被 `= delete`（流状态唯一）；`unique_ptr` 删除拷贝、保留移动。

**合成函数的隐式抑制规则**（重要）：
- 定义了**析构** → 合成**移动**不再生成（拷贝仍会生成，但可能出错——所以别混着来）。
- 定义了**拷贝构造或拷贝赋值**（任何方式，包括 =delete）→ 合成移动不再生成。
- 类有成员无法拷贝/移动（如 unique_ptr 成员）→ 对应合成版本被抑制。

## 13.5 移动语义（C++11 最大的进化之一）

### 左值 vs 右值

```cpp
int i = 42;
i = 42;        // i 是左值（有名字、有地址、能出现在赋值号左边）
              // 42 是右值（字面值、临时对象，即将销毁）
```

- **左值**：持久存在，可取地址。
- **右值**：临时的、即将销毁的（字面值、函数按值返回的临时、表达式结果）。
- `&&` 是**右值引用**：只能绑定右值，如 `int &&r = 42;`。`std::move(x)` 把左值**转成右值引用**（只是转换，本身不移动任何东西！）。

### 移动构造函数："偷"资源

```cpp
class StrVec {
public:
    StrVec(StrVec &&s) noexcept            // 移动构造必须 noexcept！
        : elements(s.elements), cap(s.cap), first_free(s.first_free)
    { s.elements = s.first_free = s.cap = nullptr; }  // 掏空源对象
    StrVec& operator=(StrVec &&rhs) noexcept {
        if (this != &rhs) {
            free();                        // 释放自己现有的
            elements = rhs.elements;       // 接管 rhs 的资源
            first_free = rhs.first_free;
            cap = rhs.cap;
            rhs.elements = rhs.first_free = rhs.cap = nullptr;
        }
        return *this;
    }
private:
    string *elements, *first_free, *cap;
    void free();   // 释放并析构
};
```

**移动 vs 拷贝**：拷贝 = 复制内容（深拷贝）；移动 = **偷指针**（O(1)，源对象置空）。

### 为什么必须标 noexcept

```cpp
vector<StrVec> v;
v.push_back(StrVec());   // 扩容时移动元素
```

vector 扩容时要保证"异常安全"：如果移动构造可能抛异常，移动到一半失败会破坏数据 → **vector 只敢用拷贝**，除非移动构造标了 `noexcept` 才敢用移动。

```cpp
StrVec(StrVec&&) noexcept;    // 有移动的类，移动构造/赋值一律 noexcept
```

### std::move：怎么用、别乱用

```cpp
StrVec v1;
StrVec v2 = std::move(v1);   // v1 的资源被移走；此后 v1 处于"有效但未指定"状态
// 之后 v1 只能做"无前置条件"的操作：赋新值、析构

// ?? 错误认知：
std::move(v1);          // 这一行什么都没移动！move 只是类型转换
// move 之后源对象还能用吗？——能析构、能重新赋值；不要读它的内容
```

**规则**：
1. 只有**确信不再需要源对象**时才 move。
2. 不要对 const 对象 move：`const StrVec` 的 move 会悄悄退化成拷贝。

### 移动迭代器（了解）

```cpp
// make_move_iterator：解引用产生右值引用 → 算法搬元素用移动而非拷贝
auto newmem = uninitialized_copy(make_move_iterator(begin()), 
                                 make_move_iterator(end()), newmem);
```

## 13.6 右值引用与函数重载

```cpp
void process(const string &s);   // 接左值（和一切）
void process(string &&s);        // 接右值

string s = "hi";
process(s);                // 左值 → const 引用版本
process("temp");           // 右值 → && 版本

// 参数传递的完美搭配（第 16 章完美转发会深化）：
// 参数即将离开作用域，我们不再用它 → 返回/传递时 move
string makeStr() {
    string local = "expensive";
    return local;            // NRVO：编译器直接构造在调用方，不发生拷贝
    // return std::move(local);  // 反而画蛇添足，禁用 NRVO！别这么写
}
```

**?? 面试常见**：局部变量 return 时**不要加 std::move**——编译器的返回值优化（RVO/NRVO）比 move 更快；加了 move 反而阻止优化。

## 实战项目：StrVec 完整实现（原书核心案例）

**功能**：自己实现一个类似 vector<string> 的容器——涵盖新空间分配、移动、五法则全流程。

```cpp
#include <memory>
#include <string>
#include <utility>
#include <initializer_list>
using namespace std;

class StrVec {
public:
    StrVec() : elements(nullptr), first_free(nullptr), cap(nullptr) { }
    StrVec(initializer_list<string> il) {
        auto newdata = alloc_n_copy(il.begin(), il.end());
        elements = newdata.first;
        first_free = cap = newdata.second;
    }
    // 拷贝控制：五法则
    StrVec(const StrVec &s) {                       // 拷贝构造
        auto newdata = alloc_n_copy(s.begin(), s.end());
        elements = newdata.first;
        first_free = cap = newdata.second;
    }
    StrVec& operator=(const StrVec &rhs) {          // 拷贝赋值
        auto newdata = alloc_n_copy(rhs.begin(), rhs.end());
        free();
        elements = newdata.first;
        first_free = cap = newdata.second;
        return *this;
    }
    StrVec(StrVec &&s) noexcept                      // 移动构造
        : elements(s.elements), first_free(s.first_free), cap(s.cap)
    { s.elements = s.first_free = s.cap = nullptr; }
    StrVec& operator=(StrVec &&rhs) noexcept {       // 移动赋值
        if (this != &rhs) { free(); take_over(rhs); }
        return *this;
    }
    ~StrVec() { free(); }                            // 析构

    void push_back(const string &s) {                // 拷贝版本
        chk_n_alloc();
        alloc.construct(first_free++, s);
    }
    void push_back(string &&s) {                     // 移动版本（右值走这里）
        chk_n_alloc();
        alloc.construct(first_free++, std::move(s));
    }
    size_t size() const { return first_free - elements; }
    size_t capacity() const { return cap - elements; }
    string *begin() const { return elements; }
    string *end() const { return first_free; }

private:
    static allocator<string> alloc;
    string *elements, *first_free, *cap;

    void chk_n_alloc() {
        if (size() == capacity()) reallocate();
    }
    pair<string*, string*> alloc_n_copy(const string *b, const string *e) {
        auto data = alloc.allocate(e - b);
        return {data, uninitialized_copy(b, e, data)};
    }
    void free() {
        if (elements) {
            for (auto p = first_free; p != elements; )
                alloc.destroy(--p);                 // 逆序析构
            alloc.deallocate(elements, cap - elements);
        }
    }
    void reallocate() {                             // 核心：扩容 + 移动
        auto newcap = size() ? 2 * size() : 1;
        auto newdata = alloc.allocate(newcap);
        auto dest = newdata;
        auto elem = elements;
        for (size_t i = 0; i != size(); ++i)
            alloc.construct(dest++, std::move(*elem++));  // 移动而非拷贝！
        free();
        elements = newdata;
        first_free = dest;
        cap = newdata + newcap;
    }
    void take_over(StrVec &rhs) {
        elements = rhs.elements; first_free = rhs.first_free; cap = rhs.cap;
        rhs.elements = rhs.first_free = rhs.cap = nullptr;
    }
};
allocator<string> StrVec::alloc;
```

**逐个击破知识点**：
1. `free()`：**先逆序析构每个元素，再 deallocate 整块内存**——两步不能混。
2. `reallocate()`：新空间用 `std::move(*elem++)` 把旧字符串**移**过来（string 内部指针易主，O(1)）——这就是 vector 扩容快的原因。
3. `push_back` 两个重载（const& 和 &&）：左值拷贝、右值移动，自动分流。
4. 拷贝构造/赋值与移动构造/赋值成对出现——五法则的完整体。

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| 类管理资源却用合成拷贝 | 双重释放 | Rule of Three/Five |
| 拷贝赋值漏自赋值检查 | `a = a` 崩溃 | 检查 `this == &rhs` |
| 先 delete 再 new | 异常时不安全 | 先拷贝后释放 |
| 移动构造忘 noexcept | vector 拒绝移动 | 有移动的类必标 |
| return 局部变量加 move | 破坏 NRVO | 直接 return |
| 引用成员让合成赋值失效 | 编译错误或删除 | 含引用/const 成员需自定义赋值 |

## 本章小结

1. 五件套：析构、拷贝构造、拷贝赋值、移动构造、移动赋值；**需要其一，考虑全部**。
2. 拷贝 = 深拷贝内容；移动 = 偷资源（源置空），移动构造/赋值**必须 noexcept**。
3. `std::move` 只做转换不移动；别对仍要用的对象、const 对象使用。
4. **最佳实践：用智能指针/vector/string 成员，让合成版本天然正确**——手写五件套是最后手段。
5. = default 请求合成、= delete 禁止使用；定义了析构或拷贝会抑制移动的合成。

## 练习

1. 为第 12 章的 HasPtr 补上移动构造与移动赋值（注意 noexcept 与源置空）。
2. 写一个 NoCopy 类：禁止拷贝但允许移动（用 = delete 实现）。
3. 在 StrVec 上实验：push_back 一个左值 string 和 `std::move` 后的 string，在 string 的拷贝/移动处加打印观察路径差异。


---

# 第 14 章 操作重载与类型转换

> 目标：学会合理重载运算符——让自定义类型像内置类型一样自然好用。

## 14.1 基本原则

**能重载的**：几乎所有运算符（`+ - * / == << [] () ->` 等）。
**不能重载的**：`::`、`.`、`.*`、`?:`、`sizeof`、`typeid` 等。
**不能造新的**：不能发明 `**` 之类的符号。

**设计三原则**：
1. **有意义才重载**：`operator+` 对 String 是拼接吗？不直观就别用符号，用普通函数。
2. **与内置语义一致**：`+` 不改操作数、`==` 满足传递律、`<` 满足严格弱序（否则 sort/set 会出错）。
3. **必须成员 / 必须非成员**：
   - `=`、`[]`、`()`、`->` **必须是成员**。
   - `<<`/`>>` **必须非成员**（左操作数是流）。
   - 算术/相等推荐**非成员**（支持左操作数的隐式转换）。

## 14.2 输入输出运算符（最高频）

```cpp
// 必须是非成员：左操作数是 ostream/istream，不是我们的类
class Sales_data {
    friend std::ostream& operator<<(std::ostream&, const Sales_data&);
    friend std::istream& operator>>(std::istream&, Sales_data&);
public:
    Sales_data(const std::string &s = "", unsigned n = 0, double p = 0)
        : bookNo(s), units_sold(n), revenue(p * n) { }
private:
    std::string bookNo;
    unsigned units_sold = 0;
    double revenue = 0.0;
};

// 输出：尽量少格式化（不打印换行），const 引用，返回 os
std::ostream& operator<<(std::ostream &os, const Sales_data &item) {
    os << item.isbn() << " " << item.units_sold << " "
       << item.revenue << " " << item.avg_price();
    return os;                     // 返回流支持链式：cout << a << b;
}

// 输入：必须处理失败！非 const 引用
std::istream& operator>>(std::istream &is, Sales_data &item) {
    double price;
    is >> item.bookNo >> item.units_sold >> price;
    if (is)                        // 读取成功才计算
        item.revenue = item.units_sold * price;
    else
        item = Sales_data();       // 失败：恢复到合法状态（重要！）
    return is;
}
```

**要点**：`>>` 失败时把对象置为有效状态——避免"半初始化"对象流入后续逻辑。

## 14.3 算术与关系运算符

```cpp
// 非成员（允许两侧都能隐式转换）
Sales_data operator+(const Sales_data &lhs, const Sales_data &rhs) {
    Sales_data sum = lhs;        // 拷贝
    sum += rhs;                  // 复用 operator+=（复合赋值是成员）
    return sum;                  // 返回新对象（局部变量，return 别加 move）
}

bool operator==(const Sales_data &lhs, const Sales_data &rhs) {
    return lhs.isbn() == rhs.isbn() &&
           lhs.units_sold == rhs.units_sold &&
           lhs.revenue == rhs.revenue;
}
bool operator!=(const Sales_data &lhs, const Sales_data &rhs) {
    return !(lhs == rhs);        // 用 == 定义 !=，保证逻辑一致
}
```

**惯例**：定义了 `+` 就定义 `+=`，且 `+` 通过 `+=` 实现——一处定义，处处复用。

## 14.4 赋值运算符（成员）

```cpp
class StrVec {
public:
    StrVec& operator=(const StrVec&);          // 拷贝赋值（第 13 章）
    StrVec& operator=(StrVec&&) noexcept;      // 移动赋值
    StrVec& operator=(initializer_list<string>);  // 花括号赋值：v = {"a","b"};
};

StrVec& StrVec::operator=(initializer_list<string> il) {
    auto data = alloc_n_copy(il.begin(), il.end());
    free();
    elements = data.first;
    first_free = cap = data.second;
    return *this;
}
```

## 14.5 下标运算符（必须成员）

```cpp
class StrVec {
public:
    std::string& operator[](std::size_t n) { return elements[n]; }        // 非常量版
    const std::string& operator[](std::size_t n) const { return elements[n]; }  // const 版
};
// 两个版本：const 对象返回 const 引用（只读），普通对象返回可写引用
StrVec v;
v[0] = "hi";
const StrVec &cv = v;
// cv[0] = "hi";   // 错误：调用 const 版本
```

**最佳实践**：下标同时提供 const 和非 const 两个重载。

## 14.6 递增递减运算符（迭代器风格）

```cpp
class StrBlobPtr {
public:
    // 前置版本：先改再返回自己
    StrBlobPtr& operator++() {
        check(curr, "increment past end");
        ++curr;
        return *this;                    // 返回引用
    }
    StrBlobPtr& operator--() {
        --curr;                          // 先减（0 位置减 1 会触发 check）
        check(curr, "decrement past begin");
        return *this;
    }
    // 后置版本：int 形参只是"占位区分"，用不上
    StrBlobPtr operator++(int) {
        StrBlobPtr ret = *this;          // 先保存旧值
        ++*this;                         // 复用前置版本！
        return ret;                      // 返回旧值（值返回，不是引用）
    }
    StrBlobPtr operator--(int) {
        StrBlobPtr ret = *this;
        --*this;
        return ret;
    }
};
```

**理论**：后置版本返回**旧值的副本**（值返回）——这正是它比前置慢的原因（第 4 章呼应）。

## 14.7 成员访问运算符（必须成员）

```cpp
class StrBlobPtr {
public:
    std::string& operator*() const {
        auto p = check(curr, "dereference past end");
        return (*p)[curr];
    }
    std::string* operator->() const {    // -> 特殊：返回指针，编译器再自动解引用
        return &this->operator*();       // 通常用 * 实现
    }
};

StrBlobPtr it;
*p;         // 调 operator*
p->empty(); // 调 operator->()，返回 string*，再自动调用其 ->/.
// 语义：p->empty() ≡ (*p).empty()
```

> `->` 是唯一"可以返回，编译器继续处理"的运算符：`p->m` 等价 `(p.operator->())->m`。

## 14.8 函数调用运算符（成员）

```cpp
class AbsInt {
public:
    int operator()(int val) const {
        return val < 0 ? -val : val;
    }
};
AbsInt absObj;
int i = -42;
cout << absObj(i);    // 像函数一样调用 → "函数对象"
```

**函数对象（functor）**：重载了 `operator()` 的类，能带状态、能被泛型算法接受，比普通函数更灵活：

```cpp
class PrintString {
public:
    PrintString(ostream &o = cout, char c = ' ') : os(o), sep(c) { }
    void operator()(const string &s) const { os << s << sep; }
private:
    ostream &os;      // 函数对象能存状态！
    char sep;
};

PrintString printer(cerr, '\n');
printer("错误信息");                 // 调 operator()

// 泛型算法中：
for_each(v.begin(), v.end(), PrintString(cerr, '\n'));   // 带状态进算法
```

### lambda 就是函数对象（第 10 章的深入解释）

```cpp
// stable_sort(words.begin(), words.end(), [sz](const string &a){...});
// 编译器展开为一个匿名类：
class SizeComp {
public:
    SizeComp(size_t n) : sz(n) { }              // 捕获 → 构造
    bool operator()(const string &s) const { return s.size() >= sz; }
private:
    size_t sz;                                  // 捕获 → 成员
};
```

### 标准库定义的函数对象

```cpp
plus<int> add;           // add(x,y) == x+y
negate<int> ng;          // ng(x) == -x
less<string> lessFn;     // lessFn(a,b) == a<b

// 泛型算法 + 函数对象替换默认比较：
sort(sdata.begin(), sdata.end(), less<Sales_data>());  // 需要 operator<

// 关联容器的比较器类型参数：
multiset<Sales_data, decltype(compareIsbn)*> bookstore(compareIsbn);
//                                                            ↑ 函数指针作比较器
```

## 14.9 转换运算符（谨慎使用！）

```cpp
class SmallInt {
public:
    SmallInt(int i = 0) : val(i) { }       // int → SmallInt（构造转换）
    operator int() const { return val; }   // SmallInt → int（转换运算符）
private:
    size_t val;
};

SmallInt si = 4;      // int → SmallInt
si + 3;               // SmallInt → int，再相加
```

### ?? 隐式转换的连锁灾难

```cpp
// 如果同时存在 operator int 和 operator string：
SmallInt si;
int i = 1;
si + i;          // 二义性？不：int 精确，OK
// 但：
if (si) ...      // si → int → bool？还是 → string → bool？二义性错误！
```

**C++11：explicit 转换运算符**

```cpp
class SmallInt {
public:
    operator int() const { return val; }         // 隐式，危险
    explicit operator bool() const { return val != 0; }   // 显式，安全
};

SmallInt si;
if (si) ...              // OK！bool 转换在"条件语境"中被语言特许
// int j = si;           // 错误：explicit 必须显式
int j = static_cast<int>(si);
```

**规则**：
1. 转换运算符**尽量 explicit**（bool 例外，条件语境可用）。
2. **避免两个类互为可转换**、避免转换后再转换的路径——产生二义性。
3. 不要让 `operator int()` 的"返回值"语义与 int 运算冲突（书中 operator int 返回 val 的 unsigned 陷阱）。

## 实战项目：为 Sales_data 完成全套运算符

```cpp
// Sales_data.h（最终形态）
#include <iostream>
#include <string>

class Sales_data {
    friend std::istream& operator>>(std::istream&, Sales_data&);
    friend std::ostream& operator<<(std::ostream&, const Sales_data&);
    friend Sales_data operator+(const Sales_data&, const Sales_data&);
    friend bool operator==(const Sales_data&, const Sales_data&);
    friend bool operator!=(const Sales_data&, const Sales_data&);
    friend bool operator<(const Sales_data&, const Sales_data&);  // 给关联容器/排序

public:
    Sales_data(const std::string &s = "", unsigned n = 0, double p = 0)
        : bookNo(s), units_sold(n), revenue(p * n) { }
    explicit operator std::string() const { return bookNo; }   // 显式转换
    explicit operator double() const { return avg_price(); }

    std::string isbn() const { return bookNo; }
    Sales_data& operator+=(const Sales_data &rhs) {   // 复合赋值是核心
        revenue += rhs.revenue;
        units_sold += rhs.units_sold;
        return *this;
    }

private:
    inline double avg_price() const {
        return units_sold ? revenue / units_sold : 0;
    }
    std::string bookNo;
    unsigned units_sold = 0;
    double revenue = 0.0;
};

// operator+ 借助 operator+=（DRY）
Sales_data operator+(const Sales_data &lhs, const Sales_data &rhs) {
    Sales_data sum = lhs;
    sum += rhs;
    return sum;
}
```

**这个类的设计检查表**（自己写类时照着过一遍）：
- [ ] `+=` 定义了吗？（`+` 从它派生）
- [ ] `==` 与 `!=` 成对且用前者定义后者？
- [ ] `>>` 失败时对象是否置为有效状态？
- [ ] `<<` 是否不打印换行、返回流？
- [ ] 单参构造是否 explicit？转换运算符是否 explicit？
- [ ] 需要 set/sort？那必须给 `<` 且满足严格弱序。

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| `<<` 写成成员 | 左操作数不是本类 | IO 运算符必须非成员 |
| `+` 直接改 lhs | 语义错乱 | `+` 产生新对象，`+=` 才修改 |
| 下标只有非 const 版 | const 对象用不了 | 成对提供 |
| 定义两个转换路径 | 二义性 | 转换运算符加 explicit |
| 重载 && / , | 丢短路与求值序 | 几乎永远别重载 |
| 重载 ,（逗号） | 求值顺序无法保留 | 同上 |

## 本章小结

1. 重载为了**让类型更自然**，不是为了炫技；语义与内置一致。
2. `= [] () ->` 必须成员；IO 必须非成员；算术/关系非成员利于转换。
3. **函数对象带状态**：lambda 就是编译器生成的函数对象。
4. 转换运算符默认加 explicit，防二义性。
5. `+` 用 `+=` 实现；`!=` 用 `==` 实现；后置用前置实现。

## 练习

1. 为第 3 章熟悉的 string 写一个 `StrVec` 的 `<<` 与下标运算符（const/非 const 两个版本）。
2. 写一个 `EqualBatch` 函数对象：构造时传一个值 n，`operator()(x)` 判断 x 的某字段是否等于 n；用 find_if 测试。
3. 实现一个 `CheckedInt`：int 包装类，`+ - * /` 溢出/除零时抛 overflow_error。


---

# 第 15 章 面向对象程序设计

> 目标：理解继承、虚函数与多态——以及"虚析构"这个一票否决项。

## 15.1 OOP 核心思想

**面向对象编程 = 数据抽象（封装） + 继承（类型层次） + 动态绑定（运行时选择函数版本）**

```cpp
class Quote {                                    // 基类：书籍报价
public:
    Quote() = default;
    Quote(const std::string &book, double sales_price)
        : bookNo(book), price(sales_price) { }
    std::string isbn() const { return bookNo; }
    // 虚函数：派生类可重写，运行时按实际类型选择
    virtual double net_price(std::size_t n) const {
        return n * price;
    }
    virtual ~Quote() = default;                  // 虚析构！本章最重要的一行
private:
    std::string bookNo;
protected:                                       // 派生类可用，外界不行
    double price = 0.0;
};

class Bulk_quote : public Quote {                // 派生类：折扣策略
public:
    Bulk_quote() = default;
    Bulk_quote(const std::string &book, double p,
               std::size_t qty, double disc)
        : Quote(book, p), min_qty(qty), discount(disc) { }   // 先初始化基类
    double net_price(std::size_t n) const override;          // 重写
private:
    std::size_t min_qty = 0;
    double discount = 0.0;
};

double Bulk_quote::net_price(std::size_t cnt) const {
    if (cnt >= min_qty)
        return cnt * (1 - discount) * price;
    return cnt * price;
}
```

## 15.2 继承的机制细节

### 派生类对象 = 基类子对象 + 自己的成员

```
Bulk_quote 对象内存布局：
┌──────────────┐
│ Quote 部分    │  bookNo, price（基类子对象在前）
├──────────────┤
│ min_qty      │
│ discount     │  派生类新增部分
└──────────────┘
```

**派生到基类的转换**：派生类对象/引用/指针可以"当作"基类使用：
- `Quote q = bulk;` **切片**：只拷贝基类部分，折扣信息丢失！（`q.net_price()` 调的是基类版本）
- `Quote &r = bulk;` 引用多态 ?
- `Quote *p = &bulk;` 指针多态 ?

**多态只能通过指针或引用实现**——对象直接赋值必切片。

### 访问控制：protected

| 基类成员 | 基类代码 | 派生类代码 | 外部代码 |
|---|---|---|---|
| public | ? | ? | ? |
| protected | ? | ? | ? |
| private | ? | ? | ? |

> protected 用来让派生类接触实现细节；但更好的设计是让派生类只用基类 public 接口。

### 基类的构造与析构次序

```
构造：基类构造 → 派生类成员初始化 → 派生类构造函数体
析构：派生类函数体 → 派生类成员析构 → 基类析构（恰好相反）
```

**推论**：基类构造/析构函数运行时，对象的"动态类型"还是基类——**此时调用虚函数不发生多态**（调的是基类版本）！这是经典陷阱：

```cpp
class Base {
public:
    Base() { init(); }        // 危险：这里虚函数不派发到派生类！
    virtual void init();
};
```

### 派生类的构造

```cpp
Bulk_quote::Bulk_quote(const string &book, double p, size_t qty, double disc)
    : Quote(book, p),    // 必须显式初始化基类（否则调用基类默认构造）
      min_qty(qty), discount(disc) { }
// 注：派生类成员的初始化只能初始化直接基类；不能初始化基类的 private 成员
```

## 15.3 虚函数与动态绑定

### 静态绑定 vs 动态绑定

```cpp
// print_total 通过基类引用接收任何书籍 → 运行时按实际类型调用 net_price
double print_total(std::ostream &os, const Quote &item, std::size_t n) {
    double ret = item.net_price(n);   // 动态绑定：bulk 传入 → Bulk_quote 版
    os << "ISBN: " << item.isbn() << " 总价: " << ret << '\n';
    return ret;
}

Quote base("A", 10);
Bulk_quote derived("B", 10, 5, 0.25);
print_total(cout, base, 5);       // 50：Quote::net_price
print_total(cout, derived, 10);   // 75：Bulk_quote::net_price —— 多态！
```

**虚函数的实现机制（vtable）**：

```
对象里藏一个指针 vptr ──? 虚函数表（vtable）
    Quote 对象             Quote 的 vtable
    ┌────────┐             ┌──────────────────┐
    │ vptr ──┼──────────?  │ &Quote::net_price │
    └────────┘             └──────────────────┘

    Bulk_quote 对象         Bulk_quote 的 vtable
    ┌────────┐             ┌───────────────────────┐
    │ vptr ──┼──────────?  │ &Bulk_quote::net_price │  ← 重写覆盖了表项
    └────────┘             └───────────────────────┘
```

- 虚调用 = 一次指针间接跳转（这也是虚函数比普通函数略慢的原因）。
- **只有通过指针/引用调用才走 vtable**；用对象直接调用是静态绑定。

### override（C++11）：防止"手滑没重写"

```cpp
struct Derived : Base {
    int f(int) const override;   // 声明意图：我要重写
};
// 如果签名与基类不符（如基类是 f(int) 非 const）→ 编译错误
// 没写 override → 变成了"隐藏"，静默 bug！
```

**规则**：**重写一律写 override**。

### final：禁止进一步重写

```cpp
struct Derived2 : Base {
    void f() final;        // 谁再继承 Derived2 也不能重写 f
};
class Last final { };      // 这个类禁止被继承
```

### 虚函数的默认实参与回避（了解）

- 虚函数用**基类中定义的默认实参**（动态绑定的是函数体，不是默认值）——避免给虚函数设默认实参。
- `qualified-call` 可强制指定版本：`double d = base->Quote::net_price(5);`（少见，仅特殊需求）。

## 15.4 抽象基类与纯虚函数

```cpp
class Disc_quote : public Quote {          // 抽象基类：定义"折扣"接口
public:
    Disc_quote() = default;
    Disc_quote(const std::string &book, double price,
               std::size_t qty, double disc)
        : Quote(book, price), quantity(qty), discount(disc) { }
    double net_price(std::size_t) const = 0;   // 纯虚函数：= 0
private:
    std::size_t quantity = 0;
    double discount = 0.0;
};

// Disc_quote d;              // 错误！抽象类不能实例化
class Bulk_quote2 : public Disc_quote {
public:
    using Disc_quote::Disc_quote;          // 继承构造函数（C++11）
    double net_price(std::size_t) const override;   // 必须重写才具体
};
```

**层次设计思想**：Quote（原价）← Disc_quote（抽象：有折扣概念）← Bulk_quote / Limited_quote（具体折扣策略）。
**抽象类 = 接口约定 + 部分公共实现**；纯虚函数的类是"不能造出对象"的契约。

## 15.5 基类与派生类的转换细节

```cpp
// 1. 派生→基：自动（切片警告）
Quote q1 = bulk;        // 切片！bookNo/price 拷过去，折扣丢
// 2. 基→派：不存在隐式转换
Bulk_quote *bq = pq;        // 错误
Bulk_quote *bq2 = static_cast<Bulk_quote*>(pq);   // 强转：自己担保 pq 确实是
Bulk_quote *bq3 = dynamic_cast<Bulk_quote*>(pb);  // 运行时检查：失败得 nullptr
```

- **容器与继承**：`vector<Quote>` 存派生对象会切片！要存多态对象 → `vector<shared_ptr<Quote>>`。
- **传参收基类引用**（如 print_total）是多态的入口。

## 15.6 虚析构函数（一票否决项！）

```cpp
class Quote {
public:
    virtual ~Quote() = default;    // 基类析构必须是 virtual！
};

Quote *item = new Bulk_quote(...);
delete item;    // 若 ~Quote 非 virtual → 只调用 ~Quote，派生部分泄漏！
                // 是 virtual → 先 ~Bulk_quote 再 ~Quote，正确
```

**规则**：**任何打算被继承的类，析构函数一律 virtual**。反过来说，不打算被继承的类别乱给 virtual（有 vtable 开销）。这条不过关，整个继承体系都是错的。

## 15.7 继承中的静态成员与作用域

```cpp
// 静态成员：全层次共享一份
class Base { public: static void statmem(); };
class Derived : public Base { void f() { statmem(); } };   // 直接用

// 作用域：派生类"隐藏"同名基类成员（不是重载！）
struct Base { void mem(); };
struct D1 : Base { void mem(int); };    // 隐藏 Base::mem
D1 d;
d.mem(42);      // D1 版
// d.mem();     // 错误！被隐藏
d.Base::mem();  // 显式绕过隐藏
```

**?? 派生类同名函数隐藏基类所有重载版本**——想"加一个重载"就会把基类的全部挡住。解决办法：`using Base::mem;` 把基类版本引入派生作用域。

## 实战项目：书店计价系统（多态全家桶）

```cpp
#include <vector>
#include <memory>
#include <iostream>
using namespace std;

// 需求：一个购物篮混合各种折扣书，算总价

class Basket {
public:
    void add_item(const shared_ptr<Quote> &sale) { items.push_back(sale); }
    double total_receipt(ostream &os) const {
        double sum = 0.0;
        for (auto iter = items.cbegin(); iter != items.cend();
             iter = upper_bound(iter, items.cend(), *iter, compareIsbn)) {
            sum += print_total(os, **iter, items.size());   // 简化：同书一起算
        }
        os << "Total Sale: " << sum << '\n';
        return sum;
    }
private:
    static bool compareIsbn(const shared_ptr<Quote> &lhs,
                            const shared_ptr<Quote> &rhs) {
        return lhs->isbn() < rhs->isbn();
    }
    vector<shared_ptr<Quote>> items;    // 多态容器：shared_ptr 而非对象！
};

int main() {
    Basket basket;
    basket.add_item(make_shared<Quote>("123", 45));
    basket.add_item(make_shared<Bulk_quote>("456", 45, 3, 0.15));
    basket.add_item(make_shared<Bulk_quote>("456", 45, 3, 0.15));
    basket.add_item(make_shared<Bulk_quote>("456", 45, 3, 0.15));
    basket.total_receipt(cout);
    // "456" 走 Bulk_quote::net_price（打折），"123" 走 Quote 版
}
```

**为什么 shared_ptr<Quote> 是多态容器的正确姿势**：
1. 不切片：容器存的是 Quote*，指向真实派生对象。
2. 生命周期自动：最后一个使用者负责 delete（通过**虚析构**正确析构完整对象）。

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| 基类析构非 virtual | `delete basePtr` 泄漏派生部分 | **最严重的错误** |
| `Quote q = derived` | 切片，多态失效 | 多态只经指针/引用 |
| 重写没写 override | 静默隐藏 | 一律 override |
| 构造函数里调虚函数 | 不派发到派生 | 对象"还是基类"阶段 |
| vector<Quote> 存派生 | 切片 | vector<shared_ptr<Quote>> |
| 派生类想加"重载" | 隐藏基类全部同名 | `using Base::f;` |
| 虚函数给默认实参 | 用的是基类的默认值 | 避免默认实参 |

## 本章小结

1. 继承建模"is-a"；虚函数 + 基类引用/指针 = 运行时多态（vtable 实现）。
2. **基类析构必须 virtual**；重写必须 override；抽象基类用 `= 0` 定义接口。
3. 对象赋值会切片；多态容器用（智能）指针。
4. 构造/析构次序：基→派构造、派→基析构；构造期间无多态。
5. 派生类作用域嵌套于基类：同名隐藏，`using` 引入，`Base::` 显式访问。

## 练习

1. 给 Quote 体系添加 `Limited_quote`（折扣上限），并测试 print_total 多态。
2. 设计一个 Shape 抽象基类（area/perimeter 纯虚），派生 Circle/Rectangle，写函数 `double totalArea(vector<shared_ptr<Shape>>&)`。
3. 故意把 ~Quote 改为非 virtual，用 valgrind 观察泄漏，再改回来对比（理解 15.6 的严重性）。


---

# 第 16 章 模板与泛型编程

> 目标：掌握函数/类模板、模板实参推导与完美转发——读懂 STL 源码的钥匙。

## 16.1 函数模板

```cpp
// template <模板参数列表> 返回类型 函数名(形参列表)
template <typename T>            // typename 也可用 class，二者等价
int compare(const T &v1, const T &v2) {
    if (v1 < v2) return -1;
    if (v2 < v1) return 1;
    return 0;
}

compare(1, 2);                 // 实例化 compare<int>：T 推导为 int
compare("a", "b");             // T = const char(&)[2]？——数组退化为指针后推导
vector<int> v1{1,2}, v2{3,4};
compare(v1[0], v2[0]);         // compare<int>
```

### 实例化发生在什么时候

- **隐式实例化**：调用时编译器根据实参**推导**模板实参，生成一份具体代码（实例）。
- 不同实参类型 → 生成不同实例（代码膨胀的来源）。
- 模板中的错误分两阶段检查：语法检查（定义时）+ 实例化检查（用到时）。**用 `int*` 调 compare 时 `v1 < v2` 指针比较合法但可能不合意**——模板对类型有隐含要求（此处要求支持 `<`）。

### 非类型模板参数

```cpp
template <unsigned N, unsigned M>
int compare(const char (&p1)[N], const char (&p2)[M]) {   // 数组引用：不退化
    return strcmp(p1, p2);
}
compare("hi", "mom");   // N=3, M=4（含'\0'）

template <size_t N> void print(const char (&arr)[N]);  // N 是编译期常量
// 非类型参数：整型、指针、左值引用、枚举；double/类对象不行
```

### inline 与 constexpr 模板

```cpp
template <typename T> inline T min_(const T &a, const T &b)   // inline 跟在模板参数后
{ return a < b ? a : b; }
```

## 16.2 类模板

```cpp
template <typename T> class Blob {
public:
    typedef T value_type;                    // 成员类型别名
    typedef typename std::vector<T>::size_type size_type;  // typename 必须有！
    Blob();
    Blob(std::initializer_list<T> il);
    size_type size() const { return data->size(); }
    bool empty() const { return data->empty(); }
    void push_back(const T &t) { data->push_back(t); }
    void push_back(T &&t) { data->push_back(std::move(t)); }  // 第 13 章联动
    T& back();
    T& operator[](size_type i);
private:
    std::shared_ptr<std::vector<T>> data;
    void check(size_type i, const std::string &msg) const;
};

// 类外定义成员：每个成员都是模板
template <typename T>
Blob<T>::Blob() : data(std::make_shared<std::vector<T>>()) { }

template <typename T>        // 每个定义都要重新声明模板参数
T& Blob<T>::operator[](size_type i) {
    check(i, "subscript out of range");
    return (*data)[i];
}
```

### ?? 类模板与类的三点不同

1. **使用必须带尖括号**：`Blob<int> b;`（不像函数可推导）。
2. **类内用模板名可以省参数**（`Blob&` 即 `Blob<T>&`），**类外必须写全** `Blob<T>::`。
3. `typedef typename vector<T>::size_type` 中的 **typename**：告诉编译器"这是个类型不是静态成员"（依赖名解析）。

### 实例化

```cpp
Blob<int> ia;                 // 实例化出 Blob<int>（连同用到的成员函数）
Blob<string> names;           // 另一个独立实例
// 成员函数只有被调用时才实例化（惰性）——因此某些类型即使不支持全部操作也能用部分功能
```

## 16.3 模板参数、友元与别名

```cpp
// 模板参数名可复用：template <typename T> 里 T 只在本模板内有效

// 1. 模板的类型别名
template<typename T> using twin = pair<T, T>;
twin<string> authors;         // pair<string, string>

// 2. 类模板 + 默认模板实参（C++11）
template <typename T, typename F = std::less<T>>   // F 默认 less
int compare(const T &v1, const T &v2, F f = F()) {
    if (f(v1, v2)) return -1;
    if (f(v2, v1)) return 1;
    return 0;
}
compare(1, 2);                          // 用默认 less
compare("a", "b", [](auto a, auto b){ return b < a; });  // 自定义比较

// 3. 模板友元
template <typename> class BlobPtr;      // 前置声明
template <typename T> class Blob {
    friend class BlobPtr<T>;            // 一一对应的友元
    friend BlobPtr<T> check(Blob<T>&);  
    // 或"全部实例都是友元"：
    template <typename X> friend class BlobPtr;
    // 或"普通友元"：
    friend class Pal;                   // 非模板类的普通友元
};
```

## 16.4 模板参数与作用域 + 类内 static

```cpp
template <typename T>
class Foo {
public:
    static std::size_t count() { return ctr; }
private:
    static std::size_t ctr;    // 每个实例有独立的一份！
};
template <typename T> std::size_t Foo<T>::ctr = 0;   // 定义

Foo<int> a; Foo<int> b;   // 共享 Foo<int>::ctr
Foo<double> c;            // 另一份 Foo<double>::ctr
```

## 16.5 模板实参推导（重点理解）

### 引用折叠（reference collapsing）——读懂转发的前提

```cpp
// 规则：只有 && 碰 && 才是 &&，其余组合都是 &
// typedef/using/模板实参推导中发生折叠：
typedef int &lRef;
typedef int &&rRef;
int i;
lRef &r1 = i;      // int& &  → int&
lRef &&r2 = i;     // int& && → int&
rRef &r3 = i;      // int&& & → int&
rRef &&r4 = 42;    // int&& &&→ int&&
```

### 万能引用（转发引用）`T&&`

```cpp
template <typename T>
void f(T &&val) {          // T&& 传入左值时 T 推导为 X&，折叠后 val 是 X&
    // 传左值 int i → T=int&, val 是 int&（左值引用）
    // 传右值 42 → T=int,  val 是 int&&（右值引用）
    // 所以 T&& 既能收左值又能收右值 → "万能引用"
}
```

### std::forward：完美转发

```cpp
// 需求：写一个包装函数，把参数"原封不动"（保持左/右值性）转交给目标
template <typename F, typename T1, typename T2>
void flip2(F f, T1 &&t1, T2 &&t2) {
    f(t2, t1);              // 问题：t1/t2 有名字 → 是左值！右值性丢失
}

template <typename F, typename T1, typename T2>
void flip3(F f, T1 &&t1, T2 &&t2) {
    f(std::forward<T2>(t2), std::forward<T1>(t1));   // 完美：保持原始左右值性
}
// forward<T>：T 是 X& 时返回 X&（保持左值），T 是 X 时返回 X&&（恢复右值）
```

**三个易混工具对比**：

| 工具 | 用在哪 | 作用 |
|---|---|---|
| `std::move(x)` | 你要把 x 交出去（x 之后不用） | 无条件转右值 |
| `std::forward<T>(x)` | 模板转发参数 | 有条件：原来是啥就是啥 |
| `T&&` 形参 | 模板参数 | 万能引用（能收左右值） |

## 16.6 可变参数模板（variadic templates）

```cpp
// template <typename... Args>：模板参数包
// void f(Args... args)：函数参数包
template <typename T, typename... Args>
void foo(const T &t, const Args&... rest);

foo(1, "a", 2.5);    // 实例化 void foo<int, const char*, double>
//                    Args = {const char*, double}, rest = ("a", 2.5)

// sizeof...：包里元素个数
template <typename... Args>
void count(Args... args) {
    std::cout << sizeof...(args) << '\n';
}
```

### 包展开：递归终止技巧

```cpp
// 打印任意数量的参数（列表分隔）
template <typename T>
std::ostream& print(std::ostream &os, const T &t) {   // 终止版本：剩一个
    return os << t;
}

template <typename T, typename... Args>
std::ostream& print(std::ostream &os, const T &t, const Args&... rest) {
    os << t << ", ";
    return print(os, rest...);     // 展开包，每次少一个参数
}

print(cout, 1, "two", 3.3);
// 输出: 1, two, 3.3

// 参数转发（万能引用 + forward + 包展开）：
template <typename... Args>
void emplace_back(Args&&... args) {
    // 把每个参数保持原性地转发给构造函数
    alloc.construct(first_free++, std::forward<Args>(args)...);
}
```

**可变参数 = 泛型代码的终极复用**：emplace 系列、make_shared/unique 都是靠它实现"参数原样转发到构造函数"。

## 16.7 模板特化（specialization）

```cpp
// compare 对 const char* 应该按字符串内容比较，而不是指针值 → 特化
template <>
int compare(const char* const &p1, const char* const &p2) {
    return strcmp(p1, p2);
}

// 类模板特化（全特化）：
template <>
class hash<MyKey> {              // 为自定义类型特化 std::hash
public:
    size_t operator()(const MyKey &k) const noexcept {
        return hash<int>()(k.a) ^ hash<string>()(k.b);
    }
};
```

- **全特化** `template <>`：某组具体类型的定制版本。
- **偏特化**（类模板专属）：`template <typename T> class Blob<T*>`——只针对指针类型。

## 实战项目：可实现完整功能的 Blob 模板

```cpp
// Blob.h —— 泛型动态数组（带共享语义），综合本章全部知识
#include <memory>
#include <vector>
#include <stdexcept>
#include <initializer_list>
#include <utility>

template <typename T> class BlobPtr;        // 前置声明

template <typename T>
class Blob {
    friend class BlobPtr<T>;                // 迭代器作友元
public:
    typedef T value_type;
    typedef typename std::vector<T>::size_type size_type;

    Blob() : data(std::make_shared<std::vector<T>>()) { }
    Blob(std::initializer_list<T> il)
        : data(std::make_shared<std::vector<T>>(il)) { }

    size_type size() const { return data->size(); }
    bool empty() const { return data->empty(); }

    void push_back(const T &t) { data->push_back(t); }
    void push_back(T &&t) { data->push_back(std::move(t)); }   // 右值走移动

    // 万能引用 + 完美转发 → 原地构造（emplace 思想）
    template <typename... Args>
    void emplace_back(Args&&... args) {
        data->emplace_back(std::forward<Args>(args)...);
    }

    T& operator[](size_type i) {
        check(i, "subscript out of range");
        return (*data)[i];
    }
    T& back() { check(0, "back on empty Blob"); return data->back(); }
    T& front() { check(0, "front on empty Blob"); return data->front(); }

private:
    void check(size_type i, const std::string &msg) const {
        if (i >= data->size())
            throw std::out_of_range(msg);
    }
    std::shared_ptr<std::vector<T>> data;
};

// 使用
int main() {
    Blob<std::string> b1 = {"a", "an", "the"};
    b1.push_back("about");
    Blob<std::string> b2 = b1;    // 共享同一数据（第 12 章 StrBlob 的泛型版）
    b2.emplace_back(3, 'x');      // 转发给 string(3, 'x') → "xxx"
}
```

**逐行对应知识点**：initializer_list 构造（16.2）、右值 push_back（16.2）、可变参数+forward（16.5/16.6）、友元（16.3）、typename（16.2）。

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| 类模板用漏 `<>` | `Blob b;` | 类模板必须 `Blob<int>` |
| 漏写 typename | `vector<T>::size_type x;` | 依赖名前必须 typename |
| 类外定义忘 `Blob<T>::` | 写成 `Blob::push_back` | 类外必须带模板实参 |
| forward 用于普通函数 | 只在模板有意义 | forward 依赖 T 的推导 |
| 转发时不用 forward | 右值性丢失 | `f(t)` 的 t 是左值 |
| 特化后忘记声明可见 | 未定义前使用 | 特化必须在使用点前可见 |

## 本章小结

1. 模板 = **编译期生成代码的公式**；函数模板可推导实参，类模板必须显式。
2. `T&&` 在模板里是万能引用；**引用折叠**让它同时接住左值和右值。
3. 转发链条：万能引用收参 + `std::forward` 保持原性（可变参数包展开）。
4. typename 处理依赖名；类模板每个实例有独立的 static/友元关系。
5. 特化/偏特化为特定类型做定制；别滥用——先用 const 引用和重载解决。

## 练习

1. 写模板 `countOccurrences(const vector<T>&, const T&)`，并特化一个 const char* 版本。
2. 实现可变参数函数 `sum(...)`：任意数量同类型参数求和（提示：递归展开）。
3. 给 Blob 加一个模板成员 `template <typename It> Blob(It b, It e)`：迭代器范围构造。


---

# 第 17 章 用于大型程序的工具

> 目标：掌握异常安全、命名空间与多重继承——多文件、多团队协作的工程化基础。

## 17.1 异常处理与异常安全

### 抛出异常时发生了什么

```cpp
throw runtime_error("出错了");
// 1. 抛出点创建异常对象（副本）
// 2. 沿调用链向上"寻找"最近的匹配 catch，路径上的局部对象依次析构（栈展开）
// 3. 无匹配 → terminate() → abort()
```

**栈展开（stack unwinding）**：中途函数被放弃，**局部对象自动析构，但裸 new 的内存不释放**——又一个 RAII/智能指针的理由：

```cpp
void f() {
    auto p = make_shared<int>(42);   // 异常时自动释放 ?
    int *raw = new int(42);
    throw runtime_error("x");        // raw 泄漏！?（栈展开不会 delete）
}
```

### 析构函数中不要抛异常

栈展开过程中若析构函数又抛异常且未被捕获 → 直接 terminate。**析构函数里的操作若可能失败，应在析构内 catch 吞掉**（库的经典做法：析构中释放资源的失败选择记录/忽略）。

### ?? 异常与函数指针/未捕获异常

```cpp
// noexcept 声明：承诺不抛异常（C++11 替代旧的 throw()）
void f() noexcept;              // 承诺不抛
// noexcept 运算符：编译期判断表达式是否 noexcept
bool b = noexcept(f());         // true
static_assert(noexcept(swap(a,b)), "swap 应该 noexcept");  // 模板/容器常用

// 违背承诺：f 里抛了异常 → 程序 terminate（不是未定义，是直接死）
```

### 异常安全等级（理论，重要！）

| 等级 | 含义 |
|---|---|
| **基本承诺** | 异常后对象处于有效（但未指定）状态，无资源泄漏 |
| **强保证** | 操作要么完全成功，要么**回滚如初**（如 copy-and-swap） |
| **不抛保证** | `noexcept`，绝不失败（析构、move 必须争取做到） |

```cpp
// 强保证的经典手法：copy-and-swap（第 13 章赋值四步的进化版）
Widget& Widget::operator=(const Widget &rhs) {
    Widget temp(rhs);   // 1. 先拷贝（可能抛，此时 *this 完好）
    swap(*this, temp);  // 2. swap 是 noexcept 的 → 交换永不失败
    return *this;       // temp 析构带走旧资源
}
```

### 异常类层次与重新抛出

```cpp
// 自定义异常：继承标准异常类
class out_of_stock : public std::runtime_error {
public:
    explicit out_of_stock(const std::string &s) : std::runtime_error(s) { }
};

// 重新抛出：处理了一半，剩下的交给上层
try {
    // ...
} catch (const my_error &e) {
    // 做点力所能及的（记日志）
    throw;                 // 空 throw：重新抛出当前异常（不是 throw e，那会切片拷贝）
}

// 捕获所有异常：catch (...)
void f() {
    try {
        // ...
    } catch (...) {        // 兜底
        // 清理资源
        throw;             // 通常再抛出
    }
}
```

**catch 匹配规则**：按声明顺序找第一个匹配（派生类 catch 必须写在基类 catch 之前，否则永远轮不到）；**按引用捕获**避免切片。

### 函数 try 块与异常规格（了解）

```cpp
// 构造函数初始化列表中抛异常的捕获方式：函数 try 块
Temp::Temp(std::vector<int> v) try : data(std::move(v)) {
    // 构造函数体
} catch (const std::bad_alloc &e) {
    // 出来时对象无法完成构造，必须 rethrow 或自动 rethrow
}
```

## 17.2 命名空间

```cpp
namespace cplusplus_primer {        // 可重复开放：多次声明会"合并"
    class Query { /* ... */ };
    namespace QueryLib {            // 嵌套命名空间
        class Query { /* ... */ };
    }
}

// 使用方式：
// 1. 作用域符（最安全）
cplusplus_primer::Query q;

// 2. using 声明（一个名字）
using cplusplus_primer::Query;

// 3. using 指示（整个命名空间——大项目慎用）
using namespace cplusplus_primer;

// 4. 命名空间别名（长名字的救星）
namespace primer = cplusplus_primer;
namespace qlib = cplusplus_primer::QueryLib;
qlib::Query q2;

// 5. 内联命名空间（C++14 起）：成员视作在外层命名空间直接可见
inline namespace FifthEd { class Blob {}; }
cplusplus_primer::Blob b;   // 直接访问，无需写 FifthEd
```

### 实战结构：避免"接口/实现分离"的头文件冲突

```cpp
// ---- Sales_data.h（接口）----
namespace cplusplus_primer {
    class Sales_data { /* 声明 */ };
    Sales_data operator+(const Sales_data&, const Sales_data&);
}

// ---- Sales_data.cc（实现）----
#include "Sales_data.h"
namespace cplusplus_primer {
    // 定义处不用重复限定
    Sales_data operator+(const Sales_data &lhs, const Sales_data &rhs) {
        Sales_data sum = lhs;
        sum += rhs;
        return sum;
    }
}

// ---- user.cc（客户代码）----
#include "Sales_data.h"
int main() {
    using cplusplus_primer::Sales_data;     // 只引入需要的
    Sales_data a, b;
    cplusplus_primer::operator+(a, b);      // 或直接 using 声明
}
```

### 查找规则：实参依赖查找（ADL / Koenig 查找）

```cpp
std::string s = "hi";
// operator<<(std::ostream&, const std::string&) 定义在 std 里
std::cout << s;    // 为什么不写 std::operator<<？
// → ADL：运算符/函数的实参所属命名空间会自动加入查找范围
```

**工程意义**：与类相关的接口函数（`operator<<`、swap 等）要么放类所在命名空间，要么是类的友元——ADL 才能找到。

### 重载与命名空间、旧式 extern "C"（了解）

```cpp
extern "C" void some_c_function(int);   // 告诉编译器按 C 方式链接（无 name mangling）
// 用于调用 C 库；C++ 函数可被 extern "C" 包裹供 C 调用
```

## 17.3 多重继承

```cpp
class File { /* ... */ };
class InputFile : public File { };
class OutputFile : public File { };

// 多重继承：一个类直接继承多个基类
class IOFile : public InputFile, public OutputFile { };

// 构造顺序：按继承列表顺序：File → InputFile → File → OutputFile → 自身
```

### ?? 菱形继承问题

```
        File
       ↗    ↖
 InputFile  OutputFile
       ↖    ↗
       IOFile
```

IOFile 默认含有**两份 File 子对象**（一份经 InputFile、一份经 OutputFile）：

```cpp
IOFile iof;
// iof.name();          // 二义性！走哪条路径的 File？
iof.InputFile::name();  // 显式选路径（丑但可行）
iof.OutputFile::name();
```

### 虚继承：让 File 只有一份

```cpp
class File { protected: std::string name; };

// virtual 指出"共享该基类子对象"
class InputFile : virtual public File { };
class OutputFile : virtual public File { };
class IOFile : public InputFile, public OutputFile { };
// 现在 IOFile 只有一份 File，iof.name() 不再二义
```

### 虚继承的代价与规则

```cpp
// 虚基类由"最底层派生类"直接初始化！
class IOFile : public InputFile, public OutputFile {
public:
    IOFile(const std::string &n) : File(n), InputFile(n), OutputFile(n) { }
    //         ↑ 最底层派生类必须显式初始化虚基类（无视中间层的初始化）
};
```

- 虚基类子对象在**最底层派生类**的构造中初始化；中间层对虚基类的初始化被忽略。
- 含虚基类的类**隐式移动/拷贝构造会先处理虚基类**。
- 虚继承有运行时开销（间接寻址访问虚基类成员）——**仅在有真正共享需求时使用**。

**工程建议**：多重继承优先通过**接口类（纯虚函数 + 无数据）**组合，避免菱形数据继承。

## 实战项目：文本查询系统（第 15 章继承 + 异常 + 命名空间综合）

**需求**：读入文件，查询单词出现次数与行号（原书压轴案例，精简版）。

```cpp
// ---- TextQuery.h ----
#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <set>
#include <memory>
#include <fstream>

namespace textquery {                       // 命名空间组织
class QueryResult;                          // 前置声明

class TextQuery {
public:
    using line_no = std::vector<std::string>::size_type;
    explicit TextQuery(std::ifstream &);    // 单参构造 explicit
    QueryResult query(const std::string &) const;
private:
    std::shared_ptr<std::vector<std::string>> file;   // 按行存的文件
    std::map<std::string,
             std::shared_ptr<std::set<line_no>>> wm;  // 单词 → 行号集合
};

class QueryResult {
    friend std::ostream& print(std::ostream&, const QueryResult&);
public:
    QueryResult(std::string s,
                std::shared_ptr<std::set<TextQuery::line_no>> p,
                std::shared_ptr<std::vector<std::string>> f)
        : sought(std::move(s)), lines(std::move(p)), file(std::move(f)) { }
private:
    std::string sought;                                    // 查询单词
    std::shared_ptr<std::set<TextQuery::line_no>> lines;   // 出现行号
    std::shared_ptr<std::vector<std::string>> file;        // 文件内容
};
} // namespace textquery
```

```cpp
// ---- TextQuery.cpp ----
#include "TextQuery.h"
using namespace textquery;

TextQuery::TextQuery(std::ifstream &is)
    : file(std::make_shared<std::vector<std::string>>()) {
    std::string text;
    while (std::getline(is, text)) {       // 第 8 章套路：整行读
        file->push_back(text);
        line_no n = file->size() - 1;      // 当前行号
        std::istringstream line(text);     // stringstream 拆词
        std::string word;
        while (line >> word) {
            auto &nos = wm[word];          // 单词首次出现时创建 set
            if (!nos)                      // 第一次见到该单词
                nos.reset(new std::set<line_no>);
            nos->insert(n);
        }
    }
}

QueryResult TextQuery::query(const std::string &sought) const {
    static std::shared_ptr<std::set<line_no>> nodata(new std::set<line_no>);  // 空
    auto loc = wm.find(sought);            // 只查不插（第 11 章！）
    if (loc == wm.end())
        return QueryResult(sought, nodata, file);   // 没找到 → 空结果
    return QueryResult(sought, loc->second, file);
}

std::ostream& print(std::ostream &os, const QueryResult &qr) {
    os << qr.sought << " 出现了 " << qr.lines->size() << " 次\n";
    for (auto num : *qr.lines)                        // 行号集合
        os << "\t(第 " << num + 1 << " 行) " << *(qr.file->begin() + num) << '\n';
    return os;
}
```

**设计精妙处**：
1. **shared_ptr 共享只读数据**：QueryResult 与 TextQuery 共享 file 和行号集合——查询结果对象不复制文件，析构时自动清理（第 12 章）。
2. `wm.find` 而非 `[]`——查询不改容器。
3. `static nodata`——"没找到"不每次都造空 set。
4. 命名空间 + 头文件接口/实现分离——多文件工程的标准结构。

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| 异常中裸 new 不释放 | 栈展开只析构栈对象 | 用智能指针 |
| 析构抛异常 | terminate | 析构内 catch 全部 |
| 基类 catch 写在派生前面 | 派生 catch 永不执行 | 派生在前 |
| `throw e;` 重新抛出 | 对象切片 | 用空 `throw;` |
| 菱形继承不虚继承 | 二义性 + 双份数据 | virtual 继承 |
| `using namespace` 放头文件 | 污染所有使用者 | 头文件绝不用 |
| noexcept 的函数抛了 | 直接 terminate | 承诺前想清楚 |

## 本章小结

1. 异常安全三级：基本/强/不抛；**强保证靠 copy-and-swap，不抛留给 move 和析构**。
2. 重新抛用空 `throw`；按引用捕获；派生 catch 在前；析构不抛异常。
3. 命名空间管规模：限定名为主、别名缩写、ADL 让接口函数"就地可见"。
4. 多重继承解决组合需求；菱形共享数据用虚继承（代价：最底层负责初始化虚基类）。

## 练习

1. 为第 13 章 StrVec 的 operator= 写一个 copy-and-swap 强保证版本。
2. 把第 7 章的 Screen 类放进命名空间 `gui`，写两个文件（.h/.cpp）并测试 using 声明与限定名两种访问。
3. 构造一个菱形继承（File/双通道/IOFile），分别实验非虚/虚继承下 `sizeof` 与成员访问差异。


---

# 第 18 章 工具与技术（用于大型程序）

> 目标：掌握优化与内存池、RTTI、union、枚举与 volatile 等特殊工具——知道何时用，更知道何时不用。

## 18.1 优化内存分配（了解思想）

### new 的工作分解

一次 `new Foo` 做了三件事：
1. 调用 `operator new`（或 `operator new[]`）分配**原始内存**；
2. 在该内存上**构造**对象（运行 `Foo` 的构造函数）；
3. 返回指针。

`delete` 对应两步：**先调用析构函数**，再调用 `operator delete` 释放内存。

> 术语区分：`new`（运算符）≠ `operator new`（库函数，行为类似 `malloc`）。第 12 章 allocator 的 allocate/construct 正是这两步的手动拆分。

### 定位 new（placement new）：在指定内存上构造

```cpp
string *p = new (buf) string("hi");   // 在 buf 指向的内存上构造 string
// 使用后必须【手动调析构】（没有对应的 delete）：
p->~string();
```

用途：内存池、容器预分配（vector 内部就是这样把 reserve 的内存逐个 construct）。

### 运行时内存池思想（RaII + 固定块复用）

```cpp
// 思想演示：频繁创建/销毁小对象时，一次性大块分配，链表复用
template <typename T>
class MemoryPool {
public:
    MemoryPool(size_t chunk = 1024) : m_chunk(chunk) { grow(); }
    T* allocate() {
        if (!m_free) grow();
        T *p = m_free;
        m_free = next(m_free);
        return p;
    }
    void deallocate(T *p) {          // 不真正释放，挂回空闲链
        next(p) = m_free;
        m_free = p;
    }
private:
    T*& next(T *p) { return *reinterpret_cast<T**>(p); }  // 块头几个字节当链表指针
    void grow() {
        T *block = static_cast<T*>(::operator new(m_chunk * sizeof(T)));
        for (size_t i = 0; i < m_chunk - 1; ++i)
            next(block + i) = block + i + 1;
        next(block + m_chunk - 1) = nullptr;
        m_free = block;
    }
    T *m_free = nullptr;
    size_t m_chunk;
};
// 应用层经验：99% 的场景 vector/池化就够；真正的自定义 allocator 需求极少
```

### 自定义 operator new（进阶，知道即可）

```cpp
// 类级 operator new/delete：影响该类的所有 new
class Foo {
public:
    static void* operator new(size_t size) {
        if (void *mem = std::malloc(size)) return mem;
        throw std::bad_alloc();            // 惯例：失败抛 bad_alloc
    }
    static void operator delete(void *mem) noexcept {
        std::free(mem);                    // delete 语义上 noexcept
    }
};
```

## 18.2 RTTI：运行时类型识别

`dynamic_cast` 与 `typeid` 是两个 RTTI 运算符，配合**多态类型**（有虚函数的类）使用。

### dynamic_cast：安全的多态向下转型

```cpp
class Base { public: virtual ~Base() = default; };
class Derived : public Base { public: void special(); };

Base *bp = new Derived;

// 指针形式：失败返回 nullptr
if (Derived *dp = dynamic_cast<Derived*>(bp)) {   // 习惯：if 内声明并判断
    dp->special();        // 转型成功，安全使用
}

// 引用形式：失败抛出 bad_cast（引用没有"空"）
void f(const Base &b) {
    try {
        const Derived &d = dynamic_cast<const Derived&>(b);
        // 使用 d
    } catch (const std::bad_cast &e) {
        // b 实际不是 Derived
    }
}
```

**使用原则**：**大量依赖 dynamic_cast 往往意味着继承体系设计有问题**——优先用虚函数让多态自己干活，RTTI 只用于"确实无法用虚函数表达"的场合（如类型相关的第三方接口）。

### typeid：获取类型信息

```cpp
#include <typeinfo>

Base *bp;
// 求值：若 bp 指向多态类型 → 返回【实际】动态类型；否则静态类型
if (typeid(*bp) == typeid(Derived)) {   // 作用于对象（解引用！）
    // bp 实际指向 Derived
}
typeid(42) == typeid(int)    // true：作用于表达式
typeid(int*) != typeid(int)  // true：指针类型不同
// 对空指针解引用求 typeid → 抛 bad_typeid

const std::type_info &ti = typeid(Base);   // 返回 type_info 引用
ti.name();                                 // 实现相关的类型名（"class Base" 等）
```

### 实战：用 RTTI 做相等判断（原书案例思想）

两个多态对象判等时，虚函数 `==` 无法处理"类型不同"的情况（虚函数只在同类层次内动态绑定），可以在基类 `==` 中先用 typeid 校验类型一致：

```cpp
class Base {
public:
    friend bool operator==(const Base &lhs, const Base &rhs) {
        // 虚调用 equal 之前，先确保动态类型一致
        return typeid(lhs) == typeid(rhs) && lhs.equal(rhs);
    }
    virtual bool equal(const Base &) const = 0;
};
class Derived : public Base {
    bool equal(const Base &rhs) const override {   // 前提已保证类型一致
        const Derived &d = static_cast<const Derived&>(rhs);  // 此时 static 安全
        return /* 比较各成员 */;
    }
};
```

## 18.3 枚举类型

### 传统枚举（不限定作用域）的问题

```cpp
enum Colors { red, green, yellow };    // 枚举名泄漏到外层作用域
enum Alert { green, yellow, red };     // 错误！与 Colors 重名冲突
// 且可隐式转成 int：
int i = red;      // OK，但也因此可以 red + 42（语义混乱）
```

### enum class：限定作用域的枚举（C++11，推荐）

```cpp
enum class Colors { red, green, yellow };
enum class Alert { green, yellow, red };   // OK！各自命名空间内互不冲突

Colors c = Colors::red;        // 必须限定
// int i = Colors::red;        // 错误！不会隐式转换
int i = static_cast<int>(Colors::red);   // 显式转换才行

// 指定底层类型（可前置声明、可控大小）
enum class intValues : unsigned long long {
    maxChar = 255,
    maxLong = 4294967295UL
};

// 结构化绑定 + enum（C++17 番外）：
switch (c) {
    case Colors::red:    std::cout << "红\n"; break;    // case 也要限定！
    case Colors::green:  std::cout << "绿\n"; break;
    default: break;
}
```

**规则**：**新代码一律用 enum class**；传统 enum 只在维护旧代码时读得懂。

### 枚举与函数重载

```cpp
void print(int);
void print(Colors);
print(Colors::red);   // 精确匹配 print(Colors)
```

## 18.4 类成员指针（member pointers）

```cpp
class Screen {
public:
    std::string get() const { return contents; }
    std::string contents;
};

// 成员【函数】指针
auto pmf = &Screen::get;                  // pmf 类型：std::string (Screen::*)() const
Screen s;
(s.*pmf)();                               // 对象调用：.* 运算符
Screen *ps = &s;
(ps->*pmf)();                             // 指针调用：->* 运算符

// 成员【数据】指针
auto pmd = &Screen::contents;             // std::string Screen::*
ps->*pmd = "hi";                          // 通过成员指针写成员

// 配合泛型算法（成员指针的经典用途）：
vector<Screen> screens;
// 用 mem_fn / bind 把成员函数"适配"成一元函数：
for_each(screens.begin(), screens.end(),
         std::mem_fn(&Screen::get));      // C++11：mem_fn 生成可调用对象
for_each(screens.begin(), screens.end(),
         [](const Screen &s) { return s.get(); });   // lambda 等价
```

## 18.5 嵌套类、union 与局部类

### 嵌套类（nested class）

```cpp
class TextQuery {
public:
    class QueryResult {     // 嵌套类：外围类的"专属助手"，访问控制服从外围类
        // ...
    };
};
// 类外定义：TextQuery::QueryResult::print(...)
// 嵌套类是外围类的成员 → 外围类对其 private 成员有访问权（单向）
```

### union：多种类型共享内存（节省空间）

```cpp
// 匿名 union 用于"tagged union"：
class Token {
public:
    Token() : tok(INT), ival(0) { }
    // 有 union 成员的类必须自管拷贝控制（union 不跟踪当前存的是啥类型）
    Token(const Token &t) { copyUnion(t); }
    Token& operator=(const Token&);
    ~Token() { if (tok == STR) sval.~string(); }   // union 的 string 要手动析构！
private:
    enum { INT, CHAR, DBL, STR } tok;   // 判别式（tag）记录当前类型
    union {                    // 匿名 union：成员直接当作 Token 的成员
        char cval;
        int ival;
        double dval;
        std::string sval;      // 有构造/析构的类型放 union 要小心管理
    };
    void copyUnion(const Token&);
};
```

**union 三规则**：
1. union 一次只存一个成员的值，**自己不记得当前存的是谁**——需要 tag。
2. 含构造/析构成员（如 string）的 union，切换类型前要**手动析构**旧值。
3. 含 union 的类通常需要**自定义拷贝控制**（合成版本不懂 tag 语义）。

**建议**：现代 C++ 用 `std::variant`（C++17，自带 tag 和安全访问），手写 tagged union 只在维护老代码或极端受限环境使用。

## 18.6 volatile 与链接指示（了解）

```cpp
// volatile：告诉编译器"该变量可能被程序外改变（硬件/信号），别优化缓存"
volatile int display_register;   // 每次都真实读写内存
// 限制：合成拷贝对 volatile 对象不适用（老 C 语义移植场景，日常业务代码基本用不到）

// extern "C"：与 C 代码互操作
extern "C" double sqrt(double);           // 单个函数按 C 链接
extern "C" {                              // 一批函数
    int f1(int);
    int f2(int);
}
// 头文件惯用法（可被 C++/C 共用）：
#ifdef __cplusplus
extern "C"
#endif
int c_api(int);
```

## 常见坑

| 坑 | 示例 | 说明 |
|---|---|---|
| placement new 后直接 delete | 内存不属于堆 | 手动析构 + 自管内存 |
| typeid 作用于类型而非对象 | 静态类型而非动态 | `typeid(*bp)` 解引用 |
| 传统 enum 污染作用域 | 重名冲突 | 用 enum class |
| union 切换不手动析构 | 泄漏/UB | 先 `sval.~string()` |
| 滥用 dynamic_cast | 设计味道 | 优先虚函数 |
| delete 非 operator new 的指针 | 堆损坏 | 内存从哪来回哪去 |

## 本章小结

1. new = 分配 + 构造；定位 new 只构造不分配；union/内存池场景才需要手动管理这对拆分。
2. RTTI = dynamic_cast（安全转型）+ typeid（动态类型判断），**是多态体系的补丁而非主力**。
3. 枚举一律 enum class：作用域安全、不隐式转 int。
4. union 是"共享内存 + 自带 tag 管理"的低层工具；variant 是现代替代品。
5. volatile 服务硬件交互，与多线程同步无关（多线程用 atomic/mutex）。

## 练习

1. 写一个接受 `std::string (Screen::*)() const` 成员函数指针的模板 `call(s, pmf)`。
2. 用 MemoryPool 分配/回收 10000 个小对象，对比直接 new/delete 的耗时差异。
3. 实现 Token 类的 `copyUnion`（按 tag 逐类型拷贝 string 时新构造）。
