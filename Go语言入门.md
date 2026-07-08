# Go 语言学习分 3 大阶段，完整基础知识清单

## 第一阶段：入门基础（零基础，1～2 周）

目标：能写简单程序，看懂 Go 语法、编译运行代码

### 必学知识点

1. 环境搭建
   
   - Go 安装、GOPATH/GOMOD（go mod）、VS Code+Go 插件配置
   - go run /go build /go mod tidy 基础命令

2. 基础语法
   
   - 包 package、导入 import、程序入口 main ()
   - 变量 var、短变量:=、常量 const、iota 枚举
   - 基础数据类型：int/uint/float/bool/string、rune/byte
   - 类型转换、运算符（算术、逻辑、位、赋值）

3. 流程控制
   
   - if-else、for 循环（无 while）、switch（无需 break）
   - goto、break/continue 标签用法

4. 复合基础容器
   
   - 数组 array、切片 slice（增删改、append、底层原理）
   - map 字典（增删、遍历、判空）

5. 函数基础
   
   - 函数定义、多返回值、空白标识符_
   - 函数参数、可变参数...
   - 匿名函数、函数变量

## 第二阶段：Go 核心特性（重中之重，2～4 周）

Go 区别于其他语言的核心，面试高频，开发必备

### 必学知识点

1. 指针
   
   - & 取地址、* 解引用、值传递 vs 指针传递
   - nil 指针、指针与数组 / 切片区别

2. 结构体 struct
   
   - 结构体定义、初始化、字段访问
   - 结构体嵌套、匿名字段、结构体比较

3. 方法 method
   
   - 值接收者 / 指针接收者区别

4. 接口 interface（Go 多态核心）
   
   - 隐式实现接口、空接口 interface {} 万能容器
   - 类型断言、类型判断 type switch

5. 错误处理（Go 独有）
   
   - error 接口、自定义错误 errors.New
   - panic/recover 异常捕获（区别 try-catch）

6. 内存与字符串
   
   - string 底层不可变、字符串拼接、strconv 转换
   - rune 处理中文、字符串转切片

7. 高级容器
   
   - make 创建 slice/map/chan、new 和 make 区别

8. 文件与 IO 基础
   
   - os 包读写文件、bufio 缓冲读写

## 第三阶段：Go 并发 + 标准库实战（2～4 周，Go 灵魂）

Go 最大优势：goroutine 协程，本阶段学完可做小型项目

### 1. 并发核心（必学）

- goroutine：go 关键字开启协程、主 goroutine 等待

- channel 通道：无缓冲 / 有缓冲通道、单向通道

- close 关闭通道、range 遍历通道

- 同步机制：
  
  sync.WaitGroup、sync.Mutex 互斥锁、sync.RWMutex 读写锁

- select 多路监听通道、time 超时控制

- sync.Once、sync.Map、原子操作 sync/atomic

### 2. 常用标准库

- time：时间格式化、定时、延时
- fmt：格式化输出
- encoding/json：结构体序列化 / 反序列化
- net/http：简单 http 服务、get/post 请求
- flag：命令行参数解析
- os/exec：执行系统命令
- context：上下文控制（超时、取消、传值，Web / 并发必备）

# 阶段学习路线总结

1. **阶段 1：基础语法** → 会写简单脚本、工具
2. **阶段 2：面向对象（struct+interface）+ 错误机制** → 能封装模块、面向对象编程
3. **阶段 3：并发 goroutine+channel + 标准库** → 掌握 Go 核心竞争力，可独立开发服务

## 进阶（基础学完后拓展，不属于基础）

数据库操作、Gin/Echo Web 框架、GRPC、Redis/Mysql、微服务、单元测试、性能调优

# Go vs Python：有 Python 基础学 Go，相同点 + 核心区别

## 一、相同点（上手很快，不用重新理解）

1. **语法简洁，不用分号**
   
   都不需要语句末尾 `;`，靠换行分隔代码；缩进只是可读性规范（Go 大括号强制）。

2. **内置容器类型**
   
   - Python：list、dict
   
   - Go：slice（等价 list）、map（等价 dict）
     
     用途完全一致：存一组数据、键值对存取。

3. **函数基础逻辑相通**
   
   - 支持多返回值（Python 元组返回，Go 原生多返回）
   - 支持可变参数、匿名函数、函数作为变量传递

4. **流程控制逻辑一样**
   
   `if`、`for`、`switch`、`break/continue` 语义完全相同；都没有传统 `while`，Go 只用 `for` 代替。

5. **垃圾回收 GC**
   
   都不用手动管理内存，运行时自动回收闲置变量，无 C/C++ 手动 malloc/free。

6. **原生 JSON 序列化**
   
   Python `json` 包 / Go `encoding/json`，结构体 / 对象一键转 JSON 字符串。

7. **跨平台编译**
   
   都支持 Windows/Linux/macOS 一套代码多系统运行。

8. **标准库完善**
   
   内置网络、文件、时间、加密工具，简单开发不用立刻装第三方库。

## 二、核心区别（重点，Python 思维容易踩坑）

### 1. 语言类型：静态编译 vs 动态解释（最大差异）

表格

| Go                         | Python                        |
| -------------------------- | ----------------------------- |
| 静态强类型：**声明变量必须确定类型**，编译期报错 | 动态弱类型：运行时推导类型，写错类型只有跑起来才崩     |
| 编译型：提前打包成独立二进制，运行无需安装环境    | 解释型：依赖 Python 解释器，分发要打包 / 装环境 |
| 执行速度极快，接近 C                | 执行慢，CPU 密集场景差距巨大              |

示例：

```go
// Go 类型固定，不能赋值不同类型
var a int = 10
a = "abc" // 直接编译报错
```

python

```python
# Python 随意切换类型
a = 10
a = "abc" # 合法
```

### 2. 变量与声明规则

1. **变量声明两种写法**
   
   - Go：`var x int` / 短声明 `x := 1`（函数内专用）
   - Python：直接 `x = 1`，无关键字

2. **强制使用声明变量**
   
   Go：定义了变量必须使用，未使用直接编译报错；Python 允许定义不用。

3. **常量**
   
   Go：`const` 常量，支持 iota 自增枚举；Python 只有约定大写变量，无真正常量。

4. **空值**
   
   Go：`nil`（指针、切片、map、通道专用）；Python：`None` 万物通用。

### 3. 容器：slice vs list、map 差异

1. **数组 vs 切片**
   
   Go 有定长数组 `[5]int` 和动态切片 `[]int`；Python list 天然动态，无定长数组概念。

2. **底层机制**
   
   - Python list：自动扩容，元素可以混合类型 `[1, "a", True]`
   - Go slice：**同类型元素**，只能存一种类型；扩容需要手动 `append`

3. **map 键限制**
   
   Python dict key 任意可哈希对象；Go map key 必须是**可比较类型**（不能是 slice/map/ 函数）。

4. 初始化：Go 必须用`make`创建空 slice/map，否则 nil 直接 panic；Python `{}` `[]` 直接可用。

### 4. 函数体系差异

1. **参数传递本质**
   
   - Python：全部**引用传递**，可变对象函数内修改外部会变
   - Go：全部**值传递**，复制一份副本；想修改原数据必须传指针

2. **无默认参数、无关键字传参**
   
   Python 支持 `func(a=10)`、`func(name="xx")`；Go 完全不支持。

3. **无函数重载**
   
   Python 同函数名可重定义；Go 同一包内函数名唯一。

### 5. 面向对象设计（完全两套思路）

Python：类`class`、继承、多继承、父类 super、实例属性 self

Go：**没有 class、没有继承**，靠两套机制实现面向对象

1. `struct` 结构体替代类，存字段
2. `method` 方法绑定结构体（值接收者 / 指针接收者）
3. `interface` 接口实现多态，**隐式实现**（不用写 implements）
- Python：鸭子类型，运行时判断是否有对应方法
- Go：编译期校验接口实现

### 6. 错误处理（天差地别）

- Python：`try/except` 异常捕获，大量逻辑抛异常
- Go：抛弃异常，**多返回值 error**，主动判断错误

```go
res, err := os.ReadFile("test.txt")
if err != nil {
    // 处理错误
}
```

Go 只有不可恢复崩溃才用`panic/recover`，业务逻辑禁止滥用。

### 7. 并发模型（Go 最强优势，Python 短板）

1. Go：原生 goroutine 轻量级协程，百万协程无压力，搭配 channel 通信

2. Python：
   
   - CPython GIL 全局锁，同一时刻只有 1 个 CPU 线程执行
   - 协程 asyncio 是单线程并发，无法利用多核；多进程开销极大

3. 同步工具：Go 内置`sync`包锁、等待组、原子操作；Python 需要 threading/multiprocessing。

### 8. 字符串处理

1. Go string 底层只读，不可修改；Python 字符串同样不可变
2. Go 中文用`rune`，单字节`byte`；Python 统一 str，无需区分
3. 拼接：Go 大量拼接推荐`bytes.Buffer`；Python 直接`"a"+"b"`性能够用

### 9. 包、模块、工程管理

- Python：import 文件 / 包，pip 管理第三方包
- Go：`package`包强制，同一目录包名统一；go mod 原生依赖管理，无需 pip
- 入口：Python 任意文件可运行；Go 必须`package main` + `func main()` 才是可执行程序

### 10. 其他细节小区别

1. 循环：Go 只有`for`，取消`while`；Python for/while 都有
2. 空循环：`for {}` 无限循环（等价 while True）
3. 运算符：Go 无`++/--`放在变量前，只允许`i++`后置；Python 无自增运算符
4. 布尔：Go 关键字`true/false`小写；Python `True/False`大写
5. 导入包：Go 未使用的 import 直接编译报错；Python 允许闲置 import

## 三、Python 开发者学习 Go 避坑总结

1. 抛弃动态类型思维，写代码先定义类型；
2. 记住 Go 全是值传递，改数据一律用指针；
3. 忘掉 class 继承，改用 struct+method+interface；
4. 不用 try 捕获错误，每个 IO / 函数调用都判断 err；
5. CPU 密集、高并发场景是 Go 主场，Python 只适合脚本 / 胶水服务；
6. slice/map 必须 make 初始化，nil 容器操作会崩溃。

# Go环境搭建

## 一、Go 安装（Windows 为主，附其他系统）

类比：相当于安装 Python 解释器，Go 安装的是**编译器 + 标准库**，安装完成后就能在终端使用 `go` 命令。

### 1. 下载安装包

官方下载地址：[https://go.dev/dl/](https://link.wtturl.cn/?target=https%3A%2F%2Fgo.dev%2Fdl%2F&scene=im&aid=582478&lang=zh "autolink")

- Windows 选 `.msi` 安装包（推荐，自动配环境变量），选对应你系统的 `amd64` 版本
- macOS 选 `.pkg` 安装包
- Linux 选压缩包手动解压

### 2. 安装步骤（Windows）

1. 双击 `.msi` 安装包，默认下一步即可
2. 默认安装路径：`C:\Program Files\Go`（也叫 `GOROOT`，不用改）
3. 安装程序会自动把 Go 的 `bin` 目录加入系统 `PATH`，无需手动配置

### 3. 验证安装

打开终端（PowerShell / CMD），输入命令：

```
go version
```

输出类似 `go version go1.22.x windows/amd64` 就代表安装成功。

---

## 二、GOPATH 与 Go Modules：必须搞懂的核心概念

这是 Go 最容易让新手困惑的地方，我用 Python 类比给你讲清楚。

### 1. 旧时代：GOPATH 模式（已淘汰，不用学深）

- Go 1.11 之前，**所有代码必须放在 GOPATH 目录下的 src 文件夹里**，没有项目独立依赖，类似 Python 全局安装包
- 缺点：不同项目无法用不同版本的依赖，管理混乱
- 现在只需要知道：GOPATH 默认在 `C:\Users\你的用户名\go`，它现在只用来存**下载的第三方依赖包**和**编译后的可执行文件**，你的项目代码不用放这里

### 2. 新时代：Go Modules（go mod，现在的标准）

类比：**Python 虚拟环境 venv + requirements.txt + pip 的集合体**

- Go 1.16 之后默认开启，**项目可以放在任意目录**，不再强制放 GOPATH
- 每个项目根目录有一个 `go.mod` 文件，记录项目名、Go 版本、依赖包及版本
- 自动管理依赖下载，不用手动装包

> 一句话总结：现在写 Go 项目，全程用 go mod 就行，不用管 GOPATH 里的代码目录。

---

## 三、VS Code 开发环境配置

类比：相当于给 VS Code 装 Python 插件，获得代码补全、语法检查、跳转、调试能力。

### 1. 安装官方 Go 插件

1. 打开 VS Code，左侧扩展栏搜索 `Go`
2. 安装 **Go Team at Google** 发布的官方插件（下载量最高的那个）

### 2. 安装 Go 开发工具链（关键一步）

插件安装后，需要安装配套的工具（代码补全、格式化、静态检查等）：

1. 按 `Ctrl+Shift+P` 打开命令面板

2. 输入 `Go: Install/Update Tools`，回车

3. 全选所有工具，点击确定，等待安装完成
   
   - 核心工具：`gopls`（语言服务，补全 / 跳转）、`goimports`（自动导包）、`dlv`（调试）impl@v1.4.0（**推荐装，效率工具**）, goplay@v1.0.0（**可选，用处不大**）

```bash
#配置国内源
# 设置七牛国内代理，direct代表失败后直连
go env -w GOPROXY=https://goproxy.cn,direct
# 强制开启go mod模块模式
go env -w GO111MODULE=on
# 关闭GOSUMDB校验（国内网络可选，避免校验超时）
go env -w GOSUMDB=off
# 检查
go env GOPROXY

# go install 安装的是可执行二进制工具（cli 程序）
# 像 gopls、dlv、impl 都是独立 exe，放到 GOPATH/bin，终端能直接运行：
C:\Users\kanghua\go\bin

# 逐个检查
gopls version
dlv version
impl -h
```

### 3. 常用配置（可选，建议开启）

- vscode 打开设置：`Ctrl + ,`

- 搜索 `formatOnSave`，先开启顶层全局开关：
  
  `Editor: Format On Save` ✅ 勾选（必须开，总开关）

- 搜索 `Go format`，找到配置项：
  
  `Go: Format Tool`
  
  下拉选择 **`gopls`**（默认就是它，等价旧版 goimports）

- 额外搜索 `gopls`，开启语言服务：
  
  `Go: Use Language Server` ✅ 勾选（你日志里之前是 false，这是关键故障点）

---

## 四、第一个项目 & 核心命令实操

下面我们从零创建一个项目，把你提到的 `go mod init`、`go run`、`go build`、`go mod tidy` 全部跑一遍。

### 第 1 步：创建项目目录

在你任意位置新建文件夹，比如 `hello-go`，然后在终端进入这个文件夹：

```bash
mkdir hello-go
cd hello-go
```

### 第 2 步：初始化 Go 模块（go mod init）

类比：相当于 `python -m venv venv` + 创建 `requirements.txt` 的第一步

```bash
go mod init hello-go
```

- 语法：`go mod init 模块名`，模块名一般和项目名一致，后期导入内部包会用到

- 执行后目录下会生成 `go.mod` 文件，内容类似：
  
  ```go
  module hello-go
  
  go 1.22
  ```

### 第 3 步：编写第一个 Go 程序

新建 `main.go` 文件，写入以下代码：

```go
// 声明包名，main 包代表这是可执行程序，不是库
package main

// 导入标准库 fmt，类似 Python 的 import
import "fmt"

// 程序入口函数，main 包必须有 main 函数
func main() {
    fmt.Println("Hello Go!")
}
```

### 第 4 步：go run 运行程序

类比：相当于 `python main.py`，直接运行，不生成可执行文件

```
go run main.go
```

终端会输出 `Hello Go!`。

- 原理：临时编译成二进制，运行完自动删除，适合开发调试

### 第 5 步：go build 编译成二进制

类比：相当于把代码打包成 `.exe` 可执行文件，运行不需要 Go 环境

```
go build
```

- 执行后目录下会生成 `hello-go.exe`（Windows），直接双击或终端运行都可以
- 特点：静态编译，一个文件就能跑，部署非常方便，这是 Go 相比 Python 的一大优势

### 第 6 步：go mod tidy 整理依赖

类比：相当于 `pip install -r requirements.txt`，自动下载缺失依赖、清理无用依赖

1. 我们先改一下代码，引入一个第三方包试试

```go
package main

import (
   "fmt"
   "github.com/fatih/color"
)

func main() {
   color.Cyan("Hello Go!")
   fmt.Println("带颜色的输出")
}
```

2. 直接运行会报错，因为还没下载依赖

3. 执行命令：

```bash
   go mod tidy


   #直接查看模块缓存目录 C:\Users\kanghua\go\pkg\mod
   go env GOMODCACHE

   #查看GOPATH
   go env GOPATH

   自动下载代码里用到的第三方包，更新 `go.mod`，同时生成 `go.sum`（依赖校验文件，类似锁文件）
   之后再 `go run main.go` 就能正常运行了
```

## 五、其他高频基础命令

| 命令               | 作用             | Python 类比                                    |
| ---------------- | -------------- | -------------------------------------------- |
| `go fmt main.go` | 自动格式化代码风格      | 类似 black 格式化                                 |
| `go vet main.go` | 静态代码检查，找潜在 bug | 类似 pylint 检查                                 |
| `go env`         | 查看 Go 所有环境变量   | 类似 `python -c "import sys; print(sys.path)"` |
| `go clean`       | 清理编译生成的二进制文件   | 清理 **pycache**                               |

---

## 六、新手最容易踩的 3 个坑

1. **没有 go.mod 就写代码**

Go 现在默认模块模式，不在模块里的代码会报各种导入错误，每个项目第一步一定是 `go mod init`。

2. **main 包和 main 函数缺一不可**

只有 `package main` 且包含 `func main()` 的文件才能编译成可执行程序，其他包都是库文件。

3. **导入的包、声明的变量必须使用**

不使用的导入包、变量会直接编译报错，这是 Go 的强制规范，目的是保证代码整洁。





# 基础语法

## 一、包（package）、导入（import）与程序入口

### 1. package 包声明

每个 Go 源码文件**第一行必须写包声明**，作用是对代码做模块化归类，类似 Python 的模块 / 包概念。

**核心规则**：

- 同一个文件夹下的所有 `.go` 文件，包名必须完全一致

- 包名默认和文件夹同名（推荐保持一致），全小写命名

- 分为两类包：
  
  - `package main`：可执行程序包，必须包含 `main()` 函数，编译后生成可执行文件
  - 其他名称：工具库包，不能独立运行，只能被其他包导入调用

对比 Python：Python 没有强制入口包规则，任意 `.py` 文件都能直接运行；Go 必须明确 `main` 包 + `main` 函数才是合法的可执行程序。

### 2. import 导入包

要使用其他包的函数 / 变量，必须先导入，类似 Python 的 `import`。

**两种导入写法**：

```go
// 单行导入
import "fmt"
import "time"

// 批量导入（官方推荐写法，更整洁）
import (
 "fmt"
 "time"
 "strings"
)
```

**导入路径规则**：

- 标准库直接写包名：`fmt`、`os`、`strconv`
- 第三方包写完整模块路径：`github.com/fatih/color`
- 项目内部包用 `模块名/相对路径` 导入

**三种特殊导入用法**：

1. 别名导入：包名过长时起简写

```go
import f "fmt"
func main() {
    f.Println("hello") // 用别名调用
}
```

2. 点导入：把包成员直接注入当前作用域（不推荐，易命名冲突）

```go
import . "fmt"
func main() {
    Println("hello") // 无需写 fmt.
}
```

3. 空白导入：只执行包的 `init()` 初始化逻辑，不直接调用包内方法

```go
import _ "github.com/go-sql-driver/mysql" // 常见于数据库驱动注册
```

⚠️ 强制规范：**导入的包必须被使用**，否则直接编译报错。Go 从语法层面强制杜绝无用依赖。

### 3. 程序入口 main ()

```go
package main // 必须是 main 包

import "fmt"

// 程序唯一入口，无参数、无返回值
func main() {
    fmt.Println("程序从这里开始执行")
}
```

对比 Python：Python 的 `if __name__ == "__main__":` 是约定俗成的入口；Go 的 `main` 包 + `main` 函数是强制语法规则。

---

## 二、变量、短变量、常量与 iota

### 1. 变量声明

Go 是静态类型语言，变量类型固定，共有 3 种声明方式。

#### 方式 1：var 完整声明（指定类型）

```go
var age int  // 仅声明，自动赋零值
age = 20     // 后续赋值

// 声明同时赋值
var name string = "张三"
```

#### 方式 2：var 类型推导（省略类型）

编译器自动根据值推断类型，写法更简洁：

```go
var score = 95.5  // 自动推导为 float64
```

#### 方式 3：短变量声明 `:=`（最常用）

**只能在函数内部使用**，全局变量不能用。自动推导类型，声明 + 赋值一步完成。

```go
func main() {
    city := "北京"  // 等价于 var city string = "北京"
    num := 100
}
```

#### 批量声明与多变量赋值

```go
// 批量声明多个变量
var (
    a int
    b string
    c bool
)

// 同时赋值多个变量
var x, y int = 10, 20
name, age := "李四", 30
```

#### 零值机制（和 Python 核心区别）

Go 声明变量不手动赋值，会自动赋予对应类型的**零值**，不会报错：

- 数值类型：`0`
- 字符串：`""` 空字符串
- 布尔值：`false`
- 切片、map、指针等引用类型：`nil`

对比 Python：Python 变量只声明不赋值直接使用会报 `NameError`，Go 不会。

#### 变量使用铁则

1. 声明的变量必须被使用，否则编译报错
2. 同一作用域不能重复声明同名变量
3. 短变量 `:=` 至少要有 1 个新变量，否则编译不通过

### 2. 常量 const

常量是编译期固定值，运行时不可修改，用于定义不变的配置项。

```go
const PI float64 = 3.14159
const BaseURL = "https://api.example.com" // 也支持类型推导

// 批量常量
const (
    StatusOK     = 200
    StatusNotFound = 404
)
```

对比 Python：Python 没有真正的常量，只是约定用大写表示常量，运行时可以修改；Go 的 `const` 是编译期强制不可修改。

### 3. iota 枚举常量

`iota` 是 Go 内置的常量计数器，**在同一个 `const` 块内，从 0 开始，每换行自动 +1**，用来轻量实现枚举。

**基础示例**：

```go
const (
    Sunday = iota  // 0
    Monday         // 1，自动继承上一行的 iota 表达式
    Tuesday        // 2
    Wednesday      // 3
)
```

**进阶用法：跳值 + 位运算**

```go
const (
    _  = iota       // 0，占位跳过
    KB = 1 << (10 * iota)  // 1 << 10 = 1024
    MB               // 1 << 20 = 1048576
    GB               // 1 << 30
)
```

注意：新的 `const` 块会让 `iota` 重新从 0 开始计数。

对比 Python：Python 无原生枚举，需借助 `enum` 模块；Go 的 `iota` 是原生轻量枚举方案。

---

## 三、基础数据类型

### 1. 整型：有符号 int / 无符号 uint

| 类型                 | 占用位数 | 适用场景                           |
| ------------------ | ---- | ------------------------------ |
| `int8` / `uint8`   | 8 位  | 极小数值、字节数据                      |
| `int16` / `uint16` | 16 位 | 短整型场景                          |
| `int32` / `uint32` | 32 位 | 普通数值                           |
| `int64` / `uint64` | 64 位 | 大数值、雪花 ID 等                    |
| `int` / `uint`     | 系统位数 | 日常开发默认用 `int`，64 位系统下等价于 int64 |

⚠️ 注意：`int` 和 `int32` 是不同类型，不能直接混用，必须显式转换。

### 2. 浮点型

- `float32`：单精度，精度低、占用小，特殊场景才用
- `float64`：双精度，精度高，**字面量默认推导为 float64**，日常开发统一用这个

```go
var a float32 = 3.14
b := 2.718  // 自动推导为 float64
```

Go 没有 `double` 类型，`float64` 等价于 Python 的 `float`。

### 3. 布尔型 bool

- 只有两个取值：`true`、`false`（全小写，和 Python 的 `True/False` 不同）
- **绝对不能和数字互相转换**，不存在 `1 == true`、`0 == false` 的隐式规则

```go
var isPass bool = true
```

### 4. 字符串 string

- 双引号包裹，底层是字节数组，**不可修改**（和 Python 字符串一致，都是不可变类型）
- 反引号 `` ` `` 包裹原始字符串，不解析转义符，适合写多行文本、JSON 模板

```go
s1 := "hello\nworld"  // 解析转义符，换行
s2 := `{    "name": "张三",    "age": 20}`  // 原始字符串，所有格式原样保留
```

### 5. byte 与 rune（重点，Python 无对应概念）

二者都是类型别名，用来表示单个字符：

- **`byte`**：等价于 `uint8`，占 1 字节，存储 ASCII 字符（英文字母、数字、符号）
- **`rune`**：等价于 `int32`，占 4 字节，存储 Unicode 字符（中文、日文、emoji 等多字节字符）

```go
var b byte = 'a'   // 单引号存字符，byte 存单字节 ASCII
var r rune = '中'  // rune 存多字节 Unicode 字符
```

**核心坑点：字符串长度与遍历**

Go 的 `string` 底层是字节数组，`len()` 获取的是字节数，不是字符数。

```go
s := "你好go"
fmt.Println(len(s)) // 输出 8（2个中文各占3字节 + 2个英文各占1字节）
fmt.Println(len([]rune(s)))            // 输出 4（2个中文 + 2个英文）
fmt.Println(utf8.RuneCountInString(s)) // 输出 4（2个中文 + 2个英文）

// 按字节遍历 → 中文会乱码
for i := 0; i < len(s); i++ {
    fmt.Printf("%c ", s[i])
}

// 用 range 遍历 → 自动按 rune 解析字符，正常显示
for _, char := range s {
    fmt.Printf("%c ", char)
}
```

对比 Python：Python3 的 `str` 天然是 Unicode 字符串，`len("你好")=2`，无需区分字节和字符；Go 要获取字符数需要用 `utf8.RuneCountInString(s)`。

---

## 四、类型转换

Go 是**强静态类型语言**，不支持任何隐式类型转换，所有跨类型操作必须手动显式转换。

### 1. 数值类型互转

语法：`目标类型(变量)`

```go
var a int = 10
var b float64 = float64(a) // int → float64
var c int8 = int8(a)       // int → int8
```

⚠️ 注意：

- 低精度转高精度安全，高精度转低精度会发生溢出截断，数值可能失真
- 布尔型与数值之间禁止转换

### 2. 字符串与数值互转

不能直接强转，必须使用标准库 `strconv`：

```go
import "strconv"

// 数字 → 字符串  Itoa = int to Ascii   功能：整数 → ASCII 字符串
s := strconv.Itoa(123)

// 字符串 → 数字（转换可能失败，返回 error） Atoi = Ascii to int
num, err := strconv.Atoi("456")
if err != nil {
    // 处理转换失败
}
```

对比 Python：Python 可以直接 `str(123)`、`int("456")`，转换失败直接抛异常；Go 必须用 `strconv` 包，且通过 `error` 返回失败信息。

### 3. 字符串与字节切片互转

```go
s := "hello"
bs := []byte(s)   // string → []byte 字节切片
s2 := string(bs)  // []byte → string
```

---

## 五、运算符

### 1. 算术运算符

| 运算符             | 说明    | 注意事项                                               |
| --------------- | ----- | -------------------------------------------------- |
| `+` `-` `*` `/` | 加减乘除  | 整数相除结果仍为整数，`5/2 = 2`                               |
| `%`             | 取余    | 仅支持整数                                              |
| `++` `--`       | 自增、自减 | **只能后置**，`i++` 正确，`++i` 错误；且是语句不是表达式，不能写 `a = i++` |

对比 Python：Python 没有 `++/--` 运算符，统一用 `i += 1`；Go 有自增语法但限制严格。

### 2. 赋值运算符

`=`、`+=`、`-=`、`*=`、`/=`、`%=`、`<<=`、`>>=`、`&=`、`|=`、`^=`

用法和 Python 完全一致。

### 3. 比较运算符

`==`、`!=`、`>`、`<`、`>=`、`<=` 

返回布尔值，和 Python 语义一致。⚠️ 不同类型不能直接比较，必须先转为同类型。

### 4. 逻辑运算符

| 运算符 | 说明                        |
| --- | ------------------------- |
| &&  | 逻辑与，短路特性：左侧为 false 则右侧不执行 |
|     | \|                        |
| !   | 逻辑非                       |

和 Python 的 `and`/`or`/`not` 语义完全一致，只是符号不同。

### 5. 位运算符（二进制操作）

| 运算符  | 说明             |
| ---- | -------------- |
| `&`  | 按位与            |
|      |                |
| `^`  | 按位异或           |
| `<<` | 左移，高位丢弃，低位补 0  |
| `>>` | 右移，低位丢弃，高位补符号位 |

用法和 Python 位运算完全一致。

## 赋值运算符

| 运算符 | 描述                      |
| --- | ----------------------- |
| =   | 简单的赋值运算符，将一个表达式的值赋给一个左值 |
| +=  | 相加后再赋值                  |
| -=  | 相减后再赋值                  |
| *=  | 相乘后再赋值                  |
| /=  | 相除后再赋值                  |
| %=  | 求余后再赋值                  |
| <<= | 左移后赋值                   |
| >>= | 右移后赋值                   |
| &=  | 按位与后赋值                  |
| \|= | 按位或后赋值                  |
| ^=  | 按位异或后赋值                 |

---

## Python 开发者避坑总结

1. 声明的变量、导入的包必须使用，否则编译不通过
2. 自增 `++` 只能后置，不能前置，也不能用于赋值
3. 布尔值是小写 `true`/`false`，不能和数字互转
4. `len(字符串)` 得到字节数，不是字符数，中文场景要注意
5. 所有跨类型操作必须显式转换，无自动类型提升
6. 短变量 `:=` 只能在函数内使用，全局变量必须用 `var`

# 流程控制

整体逻辑和 Python 完全一致，但语法规则、关键字特性有不少差异，重点注意：`for` 统一所有循环、`switch` 默认不穿透、标签可跳多层循环这几个 Go 特有设计。

---

## 一、if-else 条件判断

### 1. 基础语法规则

- 条件表达式**不需要加括号**（加了也能编译，但不符合 Go 编码规范）
- 执行体必须用 `{}` 包裹，哪怕只有一行代码，**绝对不能省略大括号**
- `else` 必须和 if 的右大括号 `}` 写在同一行，不能换行（Go 自动插入分号机制导致，换行就会报错）

```go
package main

import "fmt"

func main() {
    age := 18
    if age >= 18 {
        fmt.Println("成年")
    } else { // 必须和 } 同行
        fmt.Println("未成年")
    }
}
```

### 2. 带初始化的 if（Go 特有，高频使用）

可以在条件前加一段初始化语句，声明的变量仅在整个 `if-else` 块内有效。

最典型场景：一步完成「调用函数 + 判断错误」：

```go
// 等价于先写 num := 10; 再判断
if num := 10; num > 5 {
    fmt.Println("大于5")
} else {
    fmt.Println("小于等于5")
}

// 开发最常用写法：判断错误
if err := doSomething(); err != nil {
    // 处理错误
}
```

### 3. 多分支 if-else if-else

```go
score := 85
if score >= 90 {
    fmt.Println("优秀")
} else if score >= 80 {
    fmt.Println("良好")
} else if score >= 60 {
    fmt.Println("及格")
} else {
    fmt.Println("不及格")
}
```

### 🆚 对比 Python

| Go                 | Python                    |
| ------------------ | ------------------------- |
| 用 `{}` 划分代码块       | 用缩进划分代码块                  |
| 支持 `if 初始化; 条件` 写法 | 无对应语法，必须先写变量再判断           |
| `else` 强制和 `}` 同行  | `else` 可以任意换行             |
| 条件必须是严格布尔值         | 支持真值判断（0 / 空串 / None 都算假） |

### ⚠️ 避坑

- 不要写 `if (age > 18)`，多余的括号不符合规范
- 不能省略 `{}`，比如 `if age>18 fmt.Println(...)` 直接编译报错
- 布尔条件不能写数字，比如 `if 1 { ... }` 是非法的，Go 不允许数字转布尔

---

## 二、for 循环（唯一循环关键字，替代 while）

Go **没有 `while`、`do-while` 关键字**，所有循环场景都用 `for` 实现，共 4 种常用形态。

### 1. 经典三段式循环（类 C 风格）

`for 初始化; 循环条件; 后置操作 { }`

Python 没有这种写法，是 Go 最基础的循环形式：

```go
// 打印 0~4
for i := 0; i < 5; i++ {
    fmt.Println(i)
}
```

- 初始化语句声明的变量，仅在循环内部有效
- `i++` 是语句不是表达式，不能写在条件里

### 2. 条件式循环（替代 while）

只保留条件，等价于 Python 的 `while 条件:`：

```go
i := 0
for i < 5 {
    fmt.Println(i)
    i++
}
```

### 3. 无限循环（替代 while True）

直接写 `for { }`，等价于 Python 的 `while True:`，用 `break` 退出：

```go
for {
    fmt.Println("无限循环")
    break // 跳出
}
```

### 4. for-range 遍历（最常用，迭代容器）

用来遍历数组、切片、map、字符串、通道，类似 Python 的 `for ... in ...`。

#### 遍历切片 / 数组

```go
arr := []int{10, 20, 30}
for index, value := range arr {
    fmt.Printf("索引:%d 值:%d\n", index, value)
}
// 只想要值，索引用 _ 忽略
for _, v := range arr {
    fmt.Println(v)
}
```

#### 遍历 map

```go
m := map[string]int{"a":1, "b":2}
for key, value := range m {
    fmt.Println(key, value)
}
```

> 注意：Go 遍历 map 是无序的，每次运行顺序可能不同；Python 3.7+ 字典按插入顺序遍历。

#### 遍历字符串

`for-range` 遍历字符串会自动按 `rune` 解析，完美支持中文，不会乱码：

```go
s := "你好go"
for i, char := range s {
    fmt.Printf("索引:%d 字符:%c\n", i, char)
}
```

### 🆚 对比 Python

| Go               | Python               |
| ---------------- | -------------------- |
| 只有 `for` 一个循环关键字 | 有 `for` 和 `while` 两个 |
| 支持三段式循环          | 无三段式写法               |
| `for range` 迭代容器 | `for x in xxx` 迭代容器  |
| 遍历 map 无序        | 3.7+ 字典按插入序遍历        |

### ⚠️ 避坑

- 循环变量是**同一个变量**，每次循环只是重新赋值；如果在循环里开 goroutine 捕获变量，会出现经典的闭包坑，后面并发会讲
- `for range` 拿到的 `value` 是值拷贝，修改它不会改变原容器里的元素

---

## 三、switch 分支选择

Go 的 `switch` 比大多数语言更灵活，**核心特点：每个 case 默认自带 break，不会自动穿透**，和 C/Java 完全相反。

### 1. 基础用法

```go
day := 2
switch day {
case 1:
    fmt.Println("周一")
case 2:
    fmt.Println("周二") // 执行完自动跳出，不用写 break
case 3, 4, 5: // 一个 case 匹配多个值，逗号分隔
    fmt.Println("工作日")
default:
    fmt.Println("周末")
}
```

### 2. 带初始化的 switch

和 `if` 一样，支持前置初始化语句：

```go
switch num := getNumber(); num {
case 1:
    // ...
}
```

### 3. fallthrough 强制穿透

默认不穿透，如果需要执行下一个 case 的代码，显式写 `fallthrough`：

```go
n := 1
switch n {
case 1:
    fmt.Println("匹配1")
    fallthrough // 强制执行下一个 case
case 2:
    fmt.Println("执行case2") // 会被执行
default:
    fmt.Println("默认")
}
```

> 注意：`fallthrough` 只穿透紧挨着的下一个 case，不管下一个 case 的条件是否匹配都会执行；且不能穿透 default。

### 4. 无表达式 switch（替代长 if-else 链）

`switch` 后面不写表达式，等价于 `switch true`，每个 case 写布尔条件，比多层 `if-else` 更整洁：

```go
score := 85
switch {
case score >= 90:
    fmt.Println("优秀")
case score >= 80:
    fmt.Println("良好")
case score >= 60:
    fmt.Println("及格")
default:
    fmt.Println("不及格")
}
```

### 🆚 对比 Python

| Go                        | Python                 |     |
| ------------------------- | ---------------------- | --- |
| 默认不穿透，需 `fallthrough` 才穿透 | match-case 默认不穿透，无穿透语法 |     |
| case 支持多值匹配               | match 支持  多值匹配         |     |
| 支持无表达式 switch 替代 if - 链   | 只能用 `if-elif-else`     |     |
| case 可以是任意表达式             | match 模式匹配能力更强         |     |

### ⚠️ 避坑

- 不要习惯性写 `break`，写了也不报错，但属于多余代码
- 同一个 switch 里 case 值不能重复，否则编译报错
- `fallthrough` 必须是 case 块的最后一条语句

---

## 四、break /continue 标签（跳出多层循环）

Go 支持给循环打**标签**，实现「跳出 / 跳过指定的外层循环」，这是 Python 没有的能力（Python 只能靠标志位间接实现）。

### 1. 标签定义与 break 标签

标签写在循环前面，`break 标签名` 直接跳出标签对应的整个循环：

```go
// 定义外层循环标签 outer
outer:
for i := 0; i < 3; i++ {
    for j := 0; j < 3; j++ {
        if j == 2 {
            break outer // 直接跳出外层的 outer 循环，不是只跳出内层
        }
        fmt.Printf("i=%d j=%d\n", i, j)
    }
}
```

普通 `break` 只能跳出当前层循环，加标签可以精准跳出任意外层循环。

### 2. continue 标签

`continue 标签名` 跳过标签对应循环的当前轮，直接进入下一轮：

```go
outer:
for i := 0; i < 3; i++ {
    for j := 0; j < 3; j++ {
        if j == 1 {
            continue outer // 跳过外层循环当前i，进入下一个i
        }
        fmt.Printf("i=%d j=%d\n", i, j)
    }
}
```

### 🆚 对比 Python

- Python 的 `break/continue` 只能作用于**当前层**循环
- 要跳出多层循环，Python 需要设置布尔标志位，Go 用标签更简洁高效

### ⚠️ 注意

- 标签只能用于 `break`、`continue`、`goto`
- 标签必须定义在对应循环的紧前方
- 不能跨函数使用标签

---

## 五、goto 无条件跳转

`goto` 可以跳转到当前函数内的任意标签位置，属于争议语法，**日常开发不推荐滥用**，但在「统一错误处理、资源清理」场景非常实用。

### 语法与示例

```go
func demo() error {
    err := step1()
    if err != nil {
        goto cleanup // 跳转到 cleanup 标签
    }

    err = step2()
    if err != nil {
        goto cleanup
    }

cleanup: // 标签定义
    // 统一关闭文件、释放连接等清理操作
    return err
}
```

### 使用限制

1. 只能在**同一个函数内**跳转，不能跨函数
2. 不能跳过变量声明的代码（不能跳转到变量定义之后）
3. 不能跳转到内层代码块内部（比如跳进 for 循环里）

### 🆚 对比 Python

Python 原生没有 `goto` 语句，完全依赖结构化流程控制。

### ⚠️ 避坑

- 不要用 `goto` 写复杂的来回跳转，会让代码可读性急剧下降
- 仅推荐用于「统一错误收尾、资源释放」这类线性向前的跳转场景

---

## Python 开发者核心避坑总结

1. `if/for` 的大括号不能省，`else` 不能换行
2. 只有 `for` 循环，没有 `while`，条件循环、无限循环都用 `for` 实现
3. `switch` 默认不穿透，要穿透必须写 `fallthrough`
4. `break/continue` 加标签可以跳多层循环，不用写标志位
5. 条件必须是纯布尔值，数字、空串都不能直接当条件用

# Go 复合容器：数组 array、切片 slice、map

## 一、数组 Array（定长，固定长度）

### 1. 核心特性

1. **长度属于数组类型**：`[3]int` 和 `[5]int` 是两种完全不同类型，不能互相赋值传参
2. 长度不可变，声明时必须写死容量
3. 赋值、传参时是**完整值拷贝**，开销大
4. 零值：所有元素自动初始化为对应类型零值

### 2. 声明写法

```go
package main
import "fmt"

func main() {
    // 1. 指定长度，默认零值
    var arr1 [3]int
    fmt.Println(arr1) // [0 0 0]

    // 2. 字面量初始化
    // 字面量（literal） 指的是在代码中直接写出的值，而不是通过变量、函数调用或表达式计算得到的值。
    arr2 := [3]int{10,20,30}

    // 3. 自动推导长度 ...
    arr3 := [...]int{1,2,3,4}

    // 4. 部分赋值，剩余零值
    arr4 := [5]int{1:99, 3:66}
    fmt.Println(arr4) // [0 99 0 66 0]

    // 访问元素：下标从0开始
    fmt.Println(arr2[0])
    arr2[1] = 200
}
```

### 3. 遍历数组

```go
arr := [3]int{1,2,3}
// 下标+值
for i, v := range arr {
    fmt.Println(i, v)
}
// 只取值忽略下标
for _, v := range arr {
    fmt.Println(v)
}
```

### 4. Python 对比

Python 没有定长数组，`list` 等价 Go **切片 slice**，不是 array。

Go array 几乎很少直接使用，日常开发全部用 slice。

---

## 二、切片 Slice（动态数组，开发 99% 场景使用）

### 1. 底层结构（重点）

slice 是**引用视图**，底层由三部分组成：

1. `ptr`：指向底层数组的指针
2. `len`：当前有效元素个数（长度）
3. `cap`：底层数组总容量（最大可存，扩容前不用新开内存）

```go
slice = { 指针, len, cap }
```

### 2. 创建切片 4 种方式

#### 方式 1：从数组截取（底层共享同一数组）

```go
    arr := [5]int{1, 2, 3, 4, 5}
    s := arr[1:3]  // 左闭右开：下标1、2 → [2,3]
    fmt.Println(s) // [2 3]

    // arr[low开始位置:high结束位置:max切片最大位置]  控制容量cap
    s2 := arr[1:3:4]
    fmt.Println(s2) // [2 3]
```

⚠️ 截取出来的切片和原数组**共享底层数组**，修改切片元素会改原数组。

#### 方式 2：直接字面量

```go
s := []int{1,2,3}

// #[] 里面不写数字，直接字面量初始化切片，底层会自动创建一个隐藏数组，再包装成 slice 结构体给你。
// []int：切片，动态长度
```

#### 方式 3：make 创建（推荐，指定 len、cap）

```go
    // make(类型, 长度, 容量)
    s1 := make([]int, 2, 5) // len=2, cap=5，默认0填充
    s2 := make([]int, 3)    // cap 等于 len
    fmt.Println(s1)         // [0 0]
    fmt.Println(s2)         // [0 0 0]
    /*
       长度    当前元素个数    决定可直接访问的元素范围
       容量    底层数组可用空间    决定无需扩容的最大元素数
       设计意图：通过预分配足够的容量，可以减少 append 时的内存重新分配次数，提升性能。
    */
```

#### 方式 4：nil 空切片

```go
var s []int // nil切片，len=0 cap=0，底层无数组

    var s1 []int  // nil切片，底层无数组
    s2 := []int{} // 空切片，底层有一个空数组

    fmt.Println(s1 == nil) // true
    fmt.Println(s2 == nil) // false
    fmt.Printf("%T\n", s1) // []int
    fmt.Printf("%T\n", s2) // []int

总结
nil 的本质是 Go 中的零值（zero value），表示"空值"或"不存在"。
1 类型：nil 切片的类型仍然是 []int，所以 %T 输出相同
2 值：nil 切片表示"未分配底层数组"，与非 nil 切片的值不同
3 判断空切片：优先使用 len(s) == 0，而非 s == nil
```

### 3. 核心操作 append 追加元素

append 向切片末尾添加元素：

- 剩余容量足够：直接写到底层数组，不换内存
- 容量不足：自动**扩容**，开辟新底层数组，拷贝旧数据，原切片与新切片分离

扩容规则：

- cap < 1024：每次 ×2
- cap ≥ 1024：每次增长 25%

```go
var s []int
s = append(s, 1)
s = append(s, 2, 3)
s = append(s, []int{4,5}...) // ...拆分切片批量追加
```

### 4. 增、删、改操作

### 修改元素

```go
s := []int{10,20,30}
s[1] = 200
```

#### 删除中间元素（利用切片截取）

```go
s := []int{1,2,3,4,5}
// 删除下标2元素
s = append(s[:2], s[3:]...)
fmt.Println(s) // [1 2 4 5]
```

#### 删除头部

```go
s = s[1:]
```

#### 删除尾部

```go
s = s[:len(s)-1]
```

### 5. nil 切片 vs 空切片

```go
var s1 []int         // nil，底层无数组
s2 := []int{}        // 空切片，底层有空数组

fmt.Println(s1 == nil) // true
fmt.Println(s2 == nil) // false

// 两者 len、cap 都是0，都能直接append
s1 = append(s1, 99)
```

### 6. 切片拷贝 copy

直接赋值切片只是复制「视图头」，共享底层数组；想要独立副本用 copy：

```go
src := []int{1,2,3}
dst := make([]int, len(src)) // [0,0,0]
copy(dst, src) // dst拥有独立底层数组，修改互不影响

// make 开辟空间，不 make 没空间；
// copy 只看长度，长度 0 白忙活。
```

### 7. Python list 对比

1. Python list = Go slice，动态扩容
2. Python list 元素可混合类型；Go slice 只能存同类型
3. Python `lst[:]` 是浅拷贝新列表；Go `s[:]` 只是新视图，共享底层数组
4. Python `append()` 是方法 `lst.append(x)`；Go 是内置函数 `append(s, x)`
- Python 没有切片类型，`[a:b:c]`只是截取语法，执行后复制数据生成全新列表；Go 的`[]T`是独立复合类型，与定长数组同级。
- Go 切片截取仅生成视图，共享底层数组，修改子切片会影响原数据；Python 切片产生独立副本，互不干扰。
- Go 切片截取无步长，支持三参控制容量；Python 切片第三个参数为步长，可反向截取。
- Go 数组长度绑定类型，不可扩容；Python 列表天然动态，无定长数组概念

---

## 三、map 映射（键值对，等价 Python dict）

### 1. 规则

1. key 必须是**可比较类型**：int/string/bool/ 数组等；slice、map、函数不能当 key
2. value 任意类型
3. 未初始化的 map 是 nil，**不能写入键值**，会 panic
4. 使用前必须 `make` 或字面量初始化

### 2. 创建 map

#### 1）字面量初始化

```go
m := map[string]int{
    "apple":  5,
    "banana": 3,
}
```

#### 2）make 创建（指定初始容量）

```go
// make(map[key类型]val类型, 初始容量)
m := make(map[string]int, 10)
```

#### 3）nil map

```go
var m map[string]int // nil，不能 m["a"]=1
```

### 3. 增、改、删、查

#### 新增 / 修改（同一个语法）

key 存在则覆盖，不存在则新增

```go
m["orange"] = 10
m["apple"] = 99
```

#### 查询 + 判断 key 是否存在（Go 特有双返回）

```go
val, ok := m["apple"]
if ok {
    fmt.Println("存在，值：", val)
} else {
    fmt.Println("key不存在")
}

------------------------------------------------
    m := make(map[string]int, 10)
    m["orange"] = 10
    m["apple"] = 99

    val, ok := m["apple"]
    if ok {
        fmt.Print(ok) // true
        fmt.Println("存在，值：", val)
    } else {
        fmt.Println("key不存在")
    }
```

Python 只能用 `if k in dict` 判断，无法一步拿到值 + 存在标记。

#### 删除键 delete

```go
delete(m, "banana")
// 删除不存在key不会报错，无操作
```

### 4. 遍历 map for range

```go
m := map[string]int{"a":1, "b":2}
// 遍历 key + value
for k, v := range m {
    fmt.Println(k, v)
}
// 只遍历key
for k := range m {
    fmt.Println(k)
}
```

⚠️ Go map 遍历**无序**，每次打印顺序随机；Python3.7 + 字典保留插入顺序。

### 5. 判空

```go
// 判断是否为空（长度0）
if len(m) == 0 {
    fmt.Println("空map")
}
// 判断是否nil
var m2 map[string]int
if m2 == nil {
    fmt.Println("nil map，未初始化")
}
```

### 6. Python dict 核心区别

1. Go map 必须 make 初始化才能写入；Python `{}` 直接可用
2. Go 取 key 返回 `(value, bool)` 判断存在；Python 需要单独 `in` 判断
3. Go map key 不能是 slice/map；Python dict key 只要可哈希即可
4. Go map 遍历无序；Python 新版有序
5. map 传参是引用，函数内修改外部原 map 会同步变化

```go
package main

import "fmt"

func modify(m map[string]int) {
    m["num"] = 999
    delete(m, "a")
}

func main() {

    outer := map[string]int{"a": 1, "b": 2}
    modify(outer)
    fmt.Println(outer) // map[b:2 num:999] 外层同步修改

}


// Python：设计上统一「传对象引用」，所有对象都这套逻辑；
// Go：语法规则全都是值传递，map、slice、chan、指针只是变量里存了地址，看起来像引用，底层仍是拷贝变量本身。

Go 所有传参统一值传递，区别只在于：变量底层存「原值」还是「底层数据的指针地址」
基础类型（变量直接存真实值）：传参拷贝完整数值，函数内修改不会影响外部原变量
引用型复合类型（变量存头结构，内部带底层数据指针）：传参只拷贝小头结构，共享底层数据；修改内部元素外部同步变；给形参整体重新赋值不影响外部

纯值类型（变量存完整数据，拷贝全部）
    所有数字：int、uint、float
    bool
    定长数组 [5]int
    自定义结构体 struct

带指针头结构（变量存地址 / 头，拷贝小头，共享底层数据）
    切片 [] T
    map
    chan 通道
    函数 func
    指针 *T

特殊：string
    底层有指针，但内容只读，无法修改内部数据。
```

### 四、高频避坑总结

1. array 长度绑定类型，几乎不用，优先 slice
2. slice 截取共享底层数组，修改互相影响，独立副本用 copy
3. nil map 直接赋值键值会 panic，一定要 make 初始化
4. append 会自动扩容，扩容后新旧切片底层数组分离
5. slice/map 不能用 == 直接比较，只能循环对比；数组同长度同类型可 == 比较
6. range 遍历 slice/map 拿到的 value 是副本，修改 value 不会改动原容器

# Go 函数基础完整讲解（对比 Python）

Go 函数是代码封装的核心单元，整体遵循「值传递、多返回值、一等公民」三大设计，和 Python 相比有语法差异，但核心思想相通。

---

## 一、函数定义与基础语法

### 1. 标准格式

Go 统一用 `func` 关键字声明函数，参数类型、返回值类型都写在变量名后面，**没有默认参数、没有函数重载**，这是和 Python 最直观的区别。

```go
// 语法：func 函数名(参数) 返回值类型 { 函数体 }
func add(a int, b int) int {
    return a + b
}
```

**语法简化**：多个连续同类型参数，类型可以只写最后一个

```go
// a、b 都是 int
func add(a, b int) int {
    return a + b
}
```

### 2. 无返回值函数

没有返回值时，省略返回值类型即可：

```go
func printHello(name string) {
    fmt.Println("hello", name)
}
```

### 🆚 对比 Python

```go
// go
func add(a int, b int) int {
    return a + b
}

// python  Python 3.5+ 完全支持「参数类型注解 + 返回值类型注解」
def add(a: int, b: int) -> int:
    return a + b
```

| Go               | Python                |
| ---------------- | --------------------- |
| 用 `func` 声明，类型后置 | 用 `def` 声明，无类型标注      |
| 无默认参数、无函数重载      | 支持默认参数、关键字参数、重载（鸭子类型） |
| 无返回值时不写返回类型      | 无返回值默认返回 `None`       |

### ⚠️ 避坑

- Go 不支持函数重载：不能有同名不同参的两个函数
- Go 不支持默认参数值：所有参数必须显式传入
- 大括号 `{` 必须和函数名同行，不能换行

---

## 二、多返回值（Go 核心特性）

Go 原生支持多返回值，是语言级特性，不是像 Python 那样靠元组打包解包。**最经典用法：返回「结果 + 错误」**，这是 Go 错误处理的标准模式。

### 1. 基础写法

```go
// 返回两个值：商、错误
func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, errors.New("除数不能为0")
    }
    return a / b, nil
}

// 调用
result, err := divide(10, 2)
if err != nil {
    // 处理错误
}
```

### 2. 命名返回值（Go 特有）

可以在返回值位置提前声明变量，函数内直接赋值，`return` 可以空写，自动返回这些变量，适合短函数提升可读性。

```go
// 提前声明返回值 sum
func calc(a, b int) (sum int, diff int) {
    sum = a + b
    diff = a - b
    return // 自动返回 sum、diff，不用再写变量
}
```

### 🆚 对比 Python

- Python 多返回值本质是返回一个元组，接收时自动解包
- Go 是真正的多返回值，底层不是元组，类型严格对应
- 两者调用写法看起来相似，但底层实现不同

---

## 三、空白标识符 `_`

Go 强制规则：**声明的变量必须被使用，函数返回值也必须被接收**。如果某个返回值不需要，必须用 `_` 显式丢弃，不能只接一部分。

```go
// 只关心结果，忽略错误
result, _ := divide(10, 2)

// 只关心错误，不关心结果
_, err := divide(10, 0)
```

### 🆚 对比 Python

Python 也常用 `_` 忽略值，但不是强制的；如果函数返回多个值你只接一个，Python 会把剩余内容打包成元组赋值给变量，不会报错。Go 必须数量严格对应，不用的必须用 `_` 丢弃。

---

## 四、函数参数

### 1. 统一值传递规则

Go 所有函数传参都是**值传递**，即拷贝一份副本传入函数，区别只在于拷贝的是完整数据，还是一个带指针的小头结构：

- **值类型（int、float、bool、数组、struct）**：拷贝完整数据，函数内修改不影响外部原变量
- **引用头类型（slice、map、chan、指针）**：拷贝小头结构，共享底层数据；修改内部元素会同步到外部，但整体重新赋值不影响外部

```go
// 值类型：外部不变
func changeNum(n int) {
    n = 999
}

// map：改内部key，外部同步变
func changeMap(m map[string]int) {
    m["a"] = 999
}
```

### 2. 指针参数（显式修改外部变量）

如果想让函数修改外部基础类型变量，显式传指针：

```go
func addOne(n *int) {
    *n += 1
}

func main() {
    a := 10
    addOne(&a)
    fmt.Println(a) // 11，外部被修改
}
```

---

## 五、可变参数 `...`

可变参数允许传入任意个同类型参数，语法是 `...类型`，必须放在参数列表最后，函数内部当作切片使用。

### 1. 基础用法

```go
// nums 在函数内是 []int 切片
func sum(nums ...int) int {
    total := 0
    for _, n := range nums {
        total += n
    }
    return total
}

func main() {
    fmt.Println(sum())          // 0 个参数
    fmt.Println(sum(1, 2, 3))   // 3 个参数
    fmt.Println(sum(1, 2, 3, 4))// 4 个参数
}
```

### 2. 切片展开传入

如果已经有一个切片，想把它的元素当作可变参数传入，加 `...` 展开：

```go
s := []int{10, 20, 30}
total := sum(s...) // 等价于 sum(10,20,30)
```

### 🆚 对比 Python

| Go                | Python             |
| ----------------- | ------------------ |
| `...T` 可变参数，内部是切片 | `*args` 可变参数，内部是元组 |
| 切片展开用 `s...`      | 列表解包用 `*lst`       |
| 必须放参数最后           | 必须放参数最后            |

---

## 六、匿名函数与函数变量

Go 中函数是**一等公民**：可以赋值给变量、作为参数传递、作为返回值，和普通变量地位完全一致。

### 1. 函数变量

把函数赋值给一个变量，变量类型就是函数类型，可以像调用函数一样调用它：

```go
func main() {
    // 声明函数变量并赋值
    var add func(int, int) int = func(a, b int) int {
        return a + b
    }

    // 短变量写法（更常用）
    sub := func(a, b int) int {
        return a - b
    }

    fmt.Println(add(10, 20)) // 30
    fmt.Println(sub(10, 20)) // -10
}

函数变量 与声明的全局函数(具名函数)区别
// 语法层面两种写法最终的函数类型完全一样；
// 区别只在：全局具名函数是编译期符号，不能赋值修改；函数变量是内存里可覆盖的变量。
```

### 2. 匿名函数立即执行

定义完立刻调用，适合只执行一次的逻辑：

```go
// 无参立即执行
func() {
    fmt.Println("立即执行的匿名函数")
}()

// 带参立即执行
func(msg string) {
    fmt.Println(msg)
}("hello go")
```

### 🆚 对比 Python

- Python 的 `lambda` 只能写单行表达式，功能有限
- Go 的匿名函数是完整函数，支持多行逻辑、多返回值、循环判断，能力和普通函数完全一样，只是没有名字
- 两者都可以捕获外部变量形成闭包

---

## Python 开发者核心避坑总结

1. 没有默认参数、没有函数重载，所有参数必须显式传入
2. 多返回值必须全部接收，不用的用 `_` 显式丢弃
3. 所有传参都是值传递；想修改外部基础类型变量，传指针
4. 可变参数必须放最后，切片传可变参数要加 `...` 展开
5. 匿名函数功能完整，不止单行表达式，可实现复杂逻辑



# Go 指针完整讲解（结合 Python 视角）

Go 是有显式指针的静态语言，核心作用是**直接操作内存地址、修改外部变量、避免大对象拷贝开销**。Python 没有显式指针语法，对象默认按引用传递；Go 需要通过 `&` 和 `*` 手动管理指针逻辑。

---

## 一、指针基础：& 取地址、* 解引用

### 1. 核心概念

- 普通变量：存的是数据本身（比如 `a := 10`，变量 a 里存的就是数值 10）
- 指针变量：存的是**另一个变量的内存地址**，类型写作 `*T`（T 是指向的数据类型，比如 `*int` 就是指向 int 的指针）

### 2. 两个核心运算符

- `&变量`：取地址，获取变量的内存地址，生成指针对象
- `*指针`：解引用，通过地址访问 / 修改原始变量



```go
package main
import "fmt"

func main() {
    a := 10
    // 1. &取地址：p 是 *int 类型，存着a的内存地址
    p := &a
    fmt.Println("a的地址:", p)   // 类似 0xc0000120a8
    fmt.Println("a的值:", a)    // 10

    // 2. *解引用：读取指针指向的原始值
    fmt.Println("通过p取a的值:", *p) // 10

    // 3. 通过指针修改原始变量的值
    *p = 20
    fmt.Println("修改后a的值:", a) // 20
}


```

### 🆚 Python 对比

Python 里没有显式的取地址和解引用，所有对象变量本质都是 “隐式指针”，自动指向对象内存；Go 把这个逻辑暴露出来，需要手动用 `&` 和 `*` 控制。



可被&取地址  * 解引用的方式修改 的数据类型总结

- 普通声明的基础值类型变量（整型、浮点、布尔、定长数组、结构体等），都可以通过 `&` 取地址、`*` 解引用修改原值。
- 无法取地址、不能通过指针修改的场景：常量、字面量 / 临时计算结果、函数返回的普通值、map 的 value 元素。
- 字符串特殊：指针可以让字符串变量指向全新字符串，但不能原地修改字符串内的单个字符。

---

## 二、值传递 vs 指针传递

### 核心前提重申

Go 所有函数传参**本质都是值传递**：都会拷贝一份副本传入函数。

- 传普通值类型：拷贝完整数据，函数内修改不影响外部
- 传指针：拷贝的是「地址值」，副本和原指针指向同一块内存，解引用修改会影响外部原变量

### 1. 值传递（无法修改外部变量）

```go
func changeNum(n int) {
    n = 999 // 修改的是副本
}

func main() {
    a := 10
    changeNum(a)
    fmt.Println(a) // 10，外部不变
}
```

### 2. 指针传递（可以修改外部变量）

go

运行

```
func changeNum(n *int) {
    *n = 999 // 通过地址修改原始变量
}

func main() {
    a := 10
    changeNum(&a) // 传入变量地址
    fmt.Println(a) // 999，外部被修改
}
```

### 什么时候用指针传参？

1. **需要在函数内修改外部变量**（最常见场景）
2. **传递大结构体 / 大数组**：避免拷贝整份数据，只拷贝 8 字节地址，大幅节省性能
3. 传递函数、接口等需要共享状态的场景

---

## 三、nil 指针

指针的零值是 `nil`，代表指针**没有指向任何有效内存地址**。

go

运行

```
var p *int // 声明一个int指针，默认零值 nil
fmt.Println(p == nil) // true
```

### ⚠️ 致命坑：解引用 nil 指针会直接 panic

go

运行

```
var p *int
*p = 10 // panic: runtime error: invalid memory address or nil pointer dereference
```

### 正确做法：使用前判空

go

运行

```
var p *int
if p != nil {
    *p = 10
}
```

> 补充：和 nil 切片、nil map 一样，指针属于「引用类类型」，零值都是 nil；基础类型（int、bool、数组）没有 nil，只有各自的零值。

---

## 四、指针 vs 数组 vs 切片（最容易混淆的点）

这三类都和内存地址相关，但定位完全不同，逐一理清：

### 1. 数组：纯值类型，要改原数组必须传指针

数组是完整的值拷贝，传参时整个数组都会复制一遍；如果想修改原数组，必须传数组指针。

go

运行

```
// 传数组指针 *[3]int
func modifyArr(arr *[3]int) {
    arr[0] = 99 // Go 语法糖：数组指针可以直接用下标访问，自动解引用
}

func main() {
    arr := [3]int{1,2,3}
    modifyArr(&arr)
    fmt.Println(arr) // [99 2 3]，原数组被修改
}
```

### 2. 切片：自带底层指针，改元素不用传指针

切片本身的结构体里就包含了「底层数组指针 + len + cap」，传参时拷贝的是这个切片头，天然共享底层数组。

- ✅ 修改切片里的元素：不用传指针，直接传切片就行，外部会同步变化
- ❌ append 扩容后：如果触发扩容，函数内切片指向新数组，外部切片不受影响；如果想让外部感知到扩容，要传 `*[]T` 切片指针

go

运行

```
// 修改元素：直接传切片即可
func modifySlice(s []int) {
    s[0] = 99
}

func main() {
    s := []int{1,2,3}
    modifySlice(s)
    fmt.Println(s) // [99 2 3]，外部同步修改
}
```

### 对比总结表

表格

| 类型           | 传参拷贝内容            | 修改元素是否影响外部 | 扩容是否影响外部    |
| ------------ | ----------------- | ---------- | ----------- |
| 数组 `[N]T`    | 整个数组完整拷贝          | 否（除非传指针）   | -（长度固定）     |
| 切片 `[]T`     | 切片头（指针 + len+cap） | 是          | 否（扩容后指向新数组） |
| 数组指针 `*[N]T` | 地址（8 字节）          | 是          | -           |

---

## 核心避坑总结

1. `&` 是取地址生成指针，`*` 是解引用访问原值，二者方向相反
2. Go 永远是值传递，指针传递只是拷贝了地址，不是真的 “引用传递”
3. nil 指针不能解引用，使用前必须判空
4. 切片改元素不用传指针；只有需要修改切片本身（len/cap/ 换底层数组）时才需要传切片指针
5. 大结构体 / 大数组优先传指针，减少拷贝开销
