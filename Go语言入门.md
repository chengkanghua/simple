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



```go
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



```go
var p *int // 声明一个int指针，默认零值 nil
fmt.Println(p == nil) // true
```

### ⚠️ 致命坑：解引用 nil 指针会直接 panic

```go
var p *int
*p = 10 // panic: runtime error: invalid memory address or nil pointer dereference
```

### 正确做法：使用前判空

```go
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

```go
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

```go
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



# Go 结构体 struct + 方法 method 完整讲解

结构体是 Go 自定义复合类型的核心，相当于 Python 中类的简化版（无继承、多态，纯数据封装）；方法是绑定到结构体上的函数，通过「接收者」实现关联。

---

## 一、结构体 struct 基础

### 1. 定义语法

用 `type + struct` 声明自定义结构体，字段名 + 类型逐行列出：



```go
// 定义一个Person结构体
type Person struct {
    Name string
    Age  int
}
```

- 结构体是**值类型**，零值为所有字段自动初始化为对应零值
- 字段名大写开头为公开，小写为包内私有（后续包管理会讲）

### 2. 四种初始化方式

#### ① 零值初始化

所有字段默认零值，适合后续逐个赋值：

```go
var p Person
p.Name = "张三"
p.Age = 18
```

#### ② 键值对初始化（推荐）

按字段名赋值，顺序无关，新增字段不影响旧代码：

```go
p := Person{
    Name: "李四",
    Age:  20,
}
```

#### ③ 顺序初始化（不推荐）

按结构体字段定义顺序赋值，省略字段名，字段顺序变更会直接出错：

```go
p := Person{"王五", 22}
```

#### ④ 指针初始化（开发最常用）

直接生成结构体指针，避免大结构体传参拷贝开销：

```go
// 方式1：字面量取地址
p := &Person{Name: "赵六", Age: 25}

// 方式2：new 函数，返回零值指针
p2 := new(Person)
```

### 3. 字段访问

统一用 `.` 访问字段，**结构体指针也直接用 `.`，Go 自动解引用，不需要 `->`**：

```go
p := Person{Name: "张三", Age: 18}
fmt.Println(p.Name)

pp := &p
pp.Age = 20 // 语法糖，自动解引用，等价于 (*pp).Age = 20
```

### 4. 结构体嵌套与匿名字段

#### ① 普通嵌套

结构体里放另一个命名字段，需要层层访问：

```go
type Address struct {
    City string
}

type Person struct {
    Name    string
    Address Address // 命名字段
}

p := Person{Name: "张三", Address: Address{City: "北京"}}
fmt.Println(p.Address.City) // 必须层层访问
```

#### ② 匿名字段（字段提升）

直接写类型名作为字段，内层字段会「提升」到外层，可直接访问，模拟继承效果：

```go
type Person struct {
    string // 匿名字段，类型名就是字段名
    int
}

p := Person{"张三", 18}
fmt.Println(p.string) // 直接访问
```

嵌套结构体也可以做匿名字段：

```go
type Address struct { City string }
type Person struct {
    Name string
    Address // 匿名字段
}

p := Person{Name: "张三", Address: Address{City: "上海"}}
fmt.Println(p.City) // 直接访问内层字段，自动提升
```

> 注意：匿名字段只是语法糖，不是真正的继承；本质还是组合关系。

### 5. 结构体比较规则

1. 只有**同类型**结构体才能比较
2. 结构体所有字段都支持 `==` 比较时，整个结构体才能比较
3. 包含 slice、map、func 等不可比较类型的结构体，不能直接用 `==`

```go
p1 := Person{Name: "张三", Age: 18}
p2 := Person{Name: "张三", Age: 18}
fmt.Println(p1 == p2) // true，字段都可比较
```

---

## 二、方法 Method

方法是**绑定到特定类型上的函数**，通过「接收者」关联，和普通函数的核心区别是多了一个接收者参数。

### 1. 方法定义格式

```go
// func (接收者 类型) 方法名(参数) 返回值 { }
func (p Person) SayHello() {
    fmt.Println("你好，我是", p.Name)
}
```

- 接收者写在 `func` 和方法名之间
- 接收者变量名习惯用类型首字母小写，比如 Person 用 `p`
- 调用方式：`p.SayHello()`

### 2. 值接收者 vs 指针接收者（核心重点）

#### ① 值接收者

接收者是结构体的值拷贝，方法内修改字段**不会影响原对象**：

```go
func (p Person) SetAgeWrong(age int) {
    p.Age = age // 修改的是副本，外面不变
}
```

适用场景：小结构体、只读操作、不希望修改原数据。

#### ② 指针接收者

接收者是结构体指针，方法内修改字段**直接作用于原对象**：

```go
func (p *Person) SetAge(age int) {
    p.Age = age // 修改原对象
}
```

适用场景：需要修改原结构体字段、大结构体避免拷贝开销、工程规范统一。

### 3. 调用时的自动转换语法糖

无论变量是结构体值还是指针，调用方法时 Go 自动转换：

```go
p := Person{Name: "张三", Age: 18}
p.SetAge(20) // 自动取地址：(&p).SetAge(20)

pp := &p
pp.SayHello() // 自动解引用：(*pp).SayHello()
```

### 4. 接收者选择原则（工程规范）

1. **需要修改原结构体字段 → 必须用指针接收者**
2. **结构体字段多、体积大 → 优先指针接收者，减少拷贝开销**
3. 小结构体、只读方法 → 值接收者即可
4. 同一个类型的所有方法，接收者类型尽量统一，不要值和指针混着用

---

## 🆚 对比 Python

| Go                      | Python                      |
| ----------------------- | --------------------------- |
| struct 封装数据，method 绑定行为 | class 同时封装数据和方法             |
| 分值接收者（拷贝）和指针接收者（改原对象）   | self 默认是引用，等价指针接收者，修改属性直接生效 |
| 用匿名字段 + 组合实现复用          | 用继承实现复用                     |
| 结构体是值类型，赋值传参全拷贝         | 类对象是引用，赋值传参只拷贝引用            |

---

## 核心避坑总结

1. 结构体是值类型，直接赋值、传参都会完整拷贝一份
2. 只有指针接收者才能修改原结构体字段，值接收者改的是副本
3. 包含 slice、map、函数的结构体不能直接用 `==` 比较
4. 匿名字段是字段提升的语法糖，不是继承，本质是组合
5. 结构体指针调用字段、方法都直接用 `.`，无需手动解引用



# Go 接口 interface 完整讲解（Go 多态核心）

Go 接口是「鸭子类型」的编译期实现：**只要一个类型实现了接口的所有方法，就自动实现了该接口**，无需显式声明 `implements`。它是 Go 实现多态、解耦代码的核心工具。

---

## 一、接口定义与隐式实现

### 1. 接口定义

使用 `type + interface` 声明，内部只写方法签名，不写具体实现：

```go
// 定义接口：所有实现了 Speak 方法的类型，都属于 Speaker
type Speaker interface {
    Speak() string
}
```

- 接口内只能包含方法签名，不能有字段
- 方法名、参数、返回值必须完全匹配，才算实现接口

### 2. 隐式实现（Go 独有核心特性）

不需要写 `类型 implements 接口` 的声明，只要一个类型实现了接口的全部方法，就自动实现了该接口。

```go
type Person struct { Name string }
// Person 实现了 Speak → 自动实现 Speaker 接口
func (p Person) Speak() string {
    return "你好，我是" + p.Name
}

type Dog struct { Name string }
// Dog 也实现了 Speak → 同样自动实现 Speaker 接口
func (d Dog) Speak() string {
    return d.Name + "：汪汪汪"
}
```

### 3. 接口的多态效果

接口类型变量可以接收**所有实现了该接口的类型**，调用同一个方法会表现出不同行为，这就是多态：

```go
package main

import "fmt"

// 定义接口：所有实现了 Speak 方法的类型，都属于 Speaker
type Speaker interface {
	Speak() string
}

type Person struct{ Name string }

// Person 实现了 Speak → 自动实现 Speaker 接口
func (p Person) Speak() string {
	return "你好，我是" + p.Name
}

type Dog struct{ Name string }

// Dog 也实现了 Speak → 同样自动实现 Speaker 接口
func (d Dog) Speak() string {
	return d.Name + "：汪汪汪"
}
func main() {

	var s Speaker // 接口变量

	s = Person{Name: "张三"}
	fmt.Println(s.Speak()) // 你好，我是张三

	s = Dog{Name: "旺财"}
	fmt.Println(s.Speak()) // 旺财：汪汪汪
}

```

### 🆚 对比 Python

- Go：鸭子类型在**编译期**检查，方法没实现直接编译报错，有类型安全保障
- Python：鸭子类型在**运行期**检查，调用时找不到方法才抛异常
- 两者都不需要显式声明「实现接口」，但 Go 有编译期强校验

---

## 二、空接口 `interface{}`：万能容器

### 1. 定义

没有任何方法的接口，叫做空接口，写作 `interface{}`。

因为所有类型都天然满足「实现了 0 个方法」，所以**所有类型都自动实现了空接口**，它可以接收任意类型的值。

### 2. 两大核心用法

#### ① 函数参数：接收任意类型

最典型的就是 `fmt.Println`，它的参数就是空接口：



```go
// 自定义一个接收任意类型的函数
func printAny(v interface{}) {
    fmt.Println(v)
}

func main() {
    printAny(10)
    printAny("hello")
    printAny([]int{1,2,3})
}
```

#### ② 容器存混合类型

让切片、map 可以存放不同类型的值：

```go
var list []interface{}
list = append(list, 10, "go", true, Person{Name: "张三"})

```

### ⚠️ 关键限制

空接口变量**不能直接调用具体类型的字段和方法**，它只代表「任意类型」。想要操作具体类型的能力，必须先做**类型断言**还原类型。

### 🆚 对比 Python

空接口 `interface{}` 等价于 Python 里的 `object`，所有类型都默认兼容，可以直接赋值。

---

## 三、类型断言：把接口转回具体类型

类型断言用于从接口变量中提取原始的具体类型值，有两种写法。

### 1. 不安全写法：类型不匹配直接 panic

语法：`接口变量.(具体类型)`

```go
var v interface{} = "hello go"
s := v.(string) // 断言成功，s 为 string 类型

// 类型不匹配 → 运行时直接 panic
n := v.(int) // 报错：interface {} is string, not int
```

### 2. 安全写法：带 ok 返回值（推荐）

语法：`值, ok := 接口变量.(具体类型)`

- `ok` 为 `true`：断言成功，值为对应具体类型
- `ok` 为 `false`：断言失败，值为该类型零值，程序不会崩溃

```go
var v interface{} = 100

num, ok := v.(int)
if ok {
    fmt.Println("是int，值：", num)
} else {
    fmt.Println("不是int类型")
}
```

### 🆚 对比 Python

类型断言的作用类似 Python 的 `isinstance` 类型判断 + 类型使用，区别是 Go 直接从接口中还原出原始值，Python 是判断后自行操作。

---

## 四、type switch：批量类型判断

如果需要同时判断多种类型，用 `type switch` 比多次写断言更简洁。

### 语法

```
switch v := 接口变量.(type) {
case 类型1:
    // v 自动为类型1
case 类型2:
    // v 自动为类型2
default:
    // 都不匹配
}
```

### 示例

```go
func checkType(v interface{}) {
    switch val := v.(type) {
    case int:
        fmt.Printf("int 类型，值：%d\n", val)
    case string:
        fmt.Printf("string 类型，值：%s\n", val)
    case bool:
        fmt.Printf("bool 类型，值：%t\n", val)
    default:
        fmt.Printf("未知类型：%T\n", val)
    }
}
```

### 注意

- `.(type)` 是固定写法，只能用在 switch 中
- 每个 case 分支里，`val` 自动是对应分支的具体类型，无需再次断言

---

## 核心避坑总结

1. **隐式实现**：无需显式声明实现接口，方法签名完全匹配即自动实现
2. **空接口**：能存任意类型，但不能直接调用具体类型能力，必须先断言
3. **类型断言**：优先用带 `ok` 的安全写法，避免运行时 panic
4. **接口 nil 经典坑**：接口变量由「动态类型 + 动态值」两部分组成，只有两者都为 nil 时，接口才等于 nil；如果给接口赋值了「类型存在、值为 nil」的指针，接口不等于 nil
5. 接口本身零值为 nil，属于引用类型

## Go 接口 nil 判断的经典坑（90% 开发者都踩过）

核心结论先放前面：**接口变量底层是「动态类型 + 动态值」的二元结构，只有两者同时为 nil 时，接口才等于 nil**。

只动态值为 nil、动态类型存在时，接口不等于 nil。

```go
一、接口的底层结构
动态类型（type）：存的是它当前承载的具体类型（比如 *int、Person）
动态值（data）：存的是具体类型的值 / 指针
接口变量 = [ 动态类型 | 动态值 ]

两种「看起来是空」的接口对比
1 只声明不赋值，类型和值都是 nil：
var i interface{}
fmt.Println(i == nil) // true
// 结构：[ type=nil | data=nil ]

2. 假 nil：类型存在、值为 nil（最容易踩坑）
把一个 nil 指针赋值给接口，此时类型不为空，只有值为空：
var p *int = nil // p 是 nil 指针
var i interface{} = p

fmt.Println(p == nil) // true（指针本身是 nil）
fmt.Println(i == nil) // false（接口不是 nil！）
// 结构：[ type=*int | data=nil ]
这就是经典坑：你以为传进去的是空，实际上接口已经带上了具体类型，不再等于 nil。

三、最常见的踩坑场景：函数返回接口
这是生产环境最容易出 bug 的写法：
// 函数返回接口类型
func GetResult() interface{} {
    var p *int = nil
    // 业务逻辑出错，想返回空
    return p // ❌ 错误：返回了带类型的 nil 指针
}

func main() {
    res := GetResult()
    if res == nil {
        fmt.Println("为空")
    } else {
        fmt.Println("不为空") // 会走到这里！和预期完全相反
    }
}
函数里你以为返回了 nil，但实际上返回的是「类型为 *int、值为 nil」的接口，外部判断 ==nil 永远不成立。

四、正确避坑的 3 个方法
1. 想返回空接口就直接 return nil（最核心）
不要用具体类型的 nil 变量当返回值，直接写 nil：

func GetResult() interface{} {
    if 出错 {
        return nil // ✅ 正确：返回纯 nil 接口
    }
    return 具体值
}
2. 接收端用类型断言后再判断 nil
如果已经拿到接口，先断言成具体类型再判空：
var i interface{} = (*int)(nil)  //类型转换 目标类型(值) //指针、切片等复合类型转 nil: (类型)(nil)
if p, ok := i.(*int); ok {
    fmt.Println(p == nil) // true，按具体指针判空
}

3. 工程规范：尽量不要用空接口当返回值
能用具体接口类型就不用 interface{}，能返回具体类型就不返回接口，从根源减少判空歧义。

一句话记忆
接口判空看两头，类型值都空才真的空；带类型的 nil 不是 nil。


```

- Go interface 是独立类型，Python 无原生接口；接口核心作用：解耦、实现多态，只定义行为不关心具体数据。
- 使用场景：统一处理多种结构体、分层解耦、空接口承载任意类型、统一标准行为（如 io.Reader）。
- Python 模拟方案：简单场景靠鸭子类型；规范项目用 abc 抽象基类强制实现方法。
- 核心差异：Go 隐式实现、编译校验；Python 鸭子类型运行报错，抽象类需显式继承。



刚好承接上一节的接口知识，Go 的 error 本身就是一个内置接口，是接口最典型的应用场景之一。

# 错误处理（Go 独有）核心结论前置

Go 没有传统的 try-catch 异常机制，**常规业务错误全部通过函数显式返回 error 值处理**；panic/recover 是针对致命运行时异常的兜底机制，绝不用于日常业务错误流转。

---

## 一、error 接口：错误的本质

### 1. error 是内置接口

Go 的错误不是特殊语法，就是一个普通的接口类型，只有一个方法

```go
type error interface {
    Error() string
}
```

任何类型只要实现了 `Error() string` 方法，就自动满足 error 接口，可以当作错误返回，完全符合「隐式实现接口」的规则。

### 2. 两种基础创建方式

#### ① errors.New：简单字符串错误

最常用的基础错误创建方式：

```go
import "errors"

var ErrNotFound = errors.New("数据不存在")
```

#### ② fmt.Errorf：格式化错误

支持拼接动态信息，还能用 `%w` 实现错误嵌套包装：



```go
package main
import (
    "errors"
    "fmt"
)

func div(a, b int) (int, error) {
    if b == 0 {
        return 0, fmt.Errorf("除数 %d 不能为0", b)
    }
    return a / b, nil
}

func main() {
    _, err := div(10, 0)
    fmt.Println(err) // 输出：除数 0 不能为0
}
```

% w 嵌套包装错误（包装底层原始 error）

```go
func findUser(id int) error {
    originErr := errors.New("数据不存在")
    // %w 包裹原有错误，形成错误链
    wrapErr := fmt.Errorf("查询id=%d失败: %w", id, originErr)
    return wrapErr
}

func main() {
    err := findUser(1001)
    fmt.Println(err)

    // errors.Is 判断根源错误
    target := errors.New("数据不存在")
    if errors.Is(err, target) {
        fmt.Println("根源错误匹配")
    }
}
```



### 3. 标准错误处理范式

Go 的约定：**有错误就作为最后一个返回值返回，调用方拿到后立即判空**。



```go
// 函数返回：结果 + error
func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, errors.New("除数不能为0")
    }
    return a / b, nil
}

// 调用方显式处理
res, err := divide(10, 0)
if err != nil {
    fmt.Println("出错了:", err)
    return
}
fmt.Println("结果:", res)
```

> 约定：无错误时返回 `nil`，判断统一用 `err != nil`。

---

## 二、自定义错误

需要携带错误码、上下文等额外信息时，自定义结构体实现 `Error()` 方法即可。



```go
package main

import (
	"errors"
	"fmt"
)

// 1. 自定义错误结构体，携带业务字段：错误码、提示信息
type BizErr struct {
	Code int    // 业务错误码
	Msg  string // 错误描述
}

// 2. 实现 error 接口唯一方法 Error() string
func (e *BizErr) Error() string {
	return fmt.Sprintf("[%d] %s", e.Code, e.Msg)
}

// 3. 模拟业务函数，返回自定义错误
func GetUser(uid int) error {
	if uid <= 0 {
		// 返回自定义错误指针
		return &BizErr{
			Code: 400,
			Msg:  "用户ID不合法",
		}
	}
	if uid > 999 {
		return &BizErr{
			Code: 404,
			Msg:  "用户不存在",
		}
	}
	return nil
}

func main() {
	err := GetUser(1000)
	if err != nil {
		// 方式1：直接打印错误文本
		fmt.Println("原始错误信息：", err)

		// 方式2：类型断言，取出自定义结构体，读取Code、Msg
		var bizErr *BizErr
		if errors.As(err, &bizErr) {
			fmt.Printf("解析业务错误：码=%d, 信息=%s\n", bizErr.Code, bizErr.Msg)
		}
		return
	}
	fmt.Println("查询成功")
}


//------------------------------- 疑惑解答
为什么 fmt.Println (err) 会自动调用 Error ()
1. err 的真实类型
GetUser 返回值是 error 接口类型。
func GetUser(uid int) error {
    return &BizErr{Code:404, Msg:"用户不存在"}
}
&BizErr{} 是 *BizErr 结构体指针；
因为 *BizErr 实现了 Error() string，自动满足 error 接口；
赋值给接口变量 err，接口内部存：动态类型 =*BizErr，动态值 = 结构体指针。
2. fmt 打印接口变量的规则
fmt.Println 打印 error 接口时，标准库内部会自动调用接口定义的 Error() 方法，打印返回的字符串，不用你手动写 err.Error()。
等价写法：
fmt.Println("原始错误信息：", err.Error())
效果完全一样。


逐行详解方式 2 代码 ; 分步拆解
var bizErr *BizErr
定义目标类型变量，用来接收从接口里提取出来的自定义错误；初始是 nil。

errors.As(源错误, 目标类型指针)
作用：遍历错误链，查找是否存在 *BizErr 类型的错误；
参数 2 必须传目标类型的地址（&bizErr），函数内部会把找到的错误赋值给 bizErr；
返回 bool：true = 匹配到该自定义错误；false = 不是这个类型。
if 成立后 bizErr 不再是 nil
bizErr 已经拿到 &BizErr{Code:404, Msg:"用户不存在"}，可以直接访问 .Code、.Msg 自定义字段。


```

调用方可通过类型断言取出自定义错误，读取额外字段。

---

## 三、panic /recover：致命异常兜底

### 1. panic 是什么

`panic` 是 Go 的运行时崩溃机制：

- 触发后当前函数立即停止，向上逐层执行所有 defer，堆栈展开
- 全程没有 recover 捕获的话，程序直接崩溃退出
- 对应 Python 里的 `raise 异常`

**使用铁则**：只用于程序无法继续运行的致命错误（如启动配置丢失、运行时数组越界），日常业务错误绝对禁止用 panic，全部走 error 返回。

### 2. recover：捕获 panic

`recover` 只能在 `defer` 修饰的函数中调用，作用是捕获当前 goroutine 的 panic，终止崩溃，让程序继续运行，对应 Python 里的 `except`。

标准写法：

```go
package main

import "fmt"

// 封装安全执行逻辑，内置defer+recover捕获panic
func safeCalc(a, b int) {
	// defer延迟函数，函数退出前一定会执行
	defer func() {
		// recover() 获取panic抛出的值；无panic时返回nil
		if panicVal := recover(); panicVal != nil {
			fmt.Printf("捕获到panic异常：%v\n", panicVal)
			// 可做日志记录、告警、兜底恢复逻辑
		}
	}()

	// 模拟会触发崩溃的逻辑：除数为0
	if b == 0 {
		panic("数学错误：除数不能为0") // 主动抛出panic
	}
	res := a / b
	fmt.Printf("计算结果：%d\n", res)
}

func main() {
	fmt.Println("=== 正常场景 ===")
	safeCalc(10, 2)

	fmt.Println("\n=== 触发panic场景 ===")
	safeCalc(10, 0)

	fmt.Println("\n程序没有崩溃，继续执行main后续代码")
}

```

### 关键规则

- recover 必须写在 defer 函数内，直接调用无效
- 只能捕获当前 goroutine 的 panic，跨协程无效
- 捕获后不会回到 panic 发生的位置，当前函数会正常结束



补充说明

```bash
身份：defer、recover、panic 全是 Go 内置函数，无需 import

defer
作用：延迟调用函数，当前函数执行完毕（正常 return /panic 崩溃）前，才执行 defer 注册的函数。
执行规则：多个 defer 后进先出（栈顺序）。
典型用途：资源释放（关闭文件、连接）、配合 recover 捕获 panic。

panic
作用：主动抛出运行崩溃，中断当前逻辑，逐层向上执行所有 defer；无 recover 捕获则程序直接退出打印堆栈。
使用场景：不可修复的致命错误（空指针、数组越界），业务错误一律用 error。

recover
作用：捕获当前 goroutine 的 panic，终止崩溃流程，让程序恢复正常运行。
硬性限制：只能写在 defer 内部匿名函数中才生效，直接调用无任何作用。
返回值：发生 panic 则拿到 panic 传入的值；无 panic 返回 nil。


精简总结
defer：注册延迟执行函数，收尾资源、配合捕获异常；
panic：抛出程序崩溃；
recover：仅在 defer 内生效，捕获 panic 避免程序退出。



一、goroutine 基础说明
关键字：go
没有单独 goroutine 关键字，启动协程只需要在函数调用前加 go，就会新开一个轻量级协程并发执行。
go 函数名() // 启动goroutine

本质：Go 轻量级线程，由 Go 运行时调度，占用极小内存，能同时运行几十万协程。

特性：
主 goroutine（main）退出时，所有子协程会直接被杀掉，不会等待；
recover() 只能捕获当前协程内的 panic，子协程崩溃不会被父协程的 recover 捕获。

二、为什么刚才 recover 示例看不到 goroutine
之前代码全部运行在主协程 main，没有手动开启子协程，所以不用写 go，自然看不到相关关键字。
所有代码默认都跑在 main 自带的 goroutine 里。

三、演示：子协程 panic 父协程无法捕获（重点坑）
package main
import "fmt"

func main() {
	// 父协程的recover，只生效于main自身
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("main捕获panic：", r)
		}
	}()

	// 新开子goroutine
	go func() {
		panic("子协程崩溃") // 这个panic父协程抓不到，程序直接崩
	}()

	// 阻塞等待，否则main直接退出看不到效果
	var input string
	fmt.Scanln(&input)
	fmt.Println("main结束")
}
运行结果：程序直接崩溃，main 的 defer recover 完全失效。

四、正确写法：每个 goroutine 内部必须自己加 defer+recover
package main
import "fmt"

func main() {
	// 启动子协程，内部自带捕获
	go func() {
		defer func() {
			if r := recover(); r != nil {
				fmt.Println("子协程捕获：", r)
			}
		}()
		panic("子协程出错")
	}()

	var s string
	fmt.Scanln(&s)
	fmt.Println("程序正常退出")
}

精简总结
开启协程关键字只有 go，无 goroutine 关键字；
程序默认自带 main 主协程，之前代码都在主协程运行；
recover 隔离：每个 goroutine 独立，子协程 panic 父协程捕获不了；
规范：所有新开的 go 协程内部，必须配套 defer + recover 兜底，防止整个程序崩溃。


```



```go

分清进程 / 线程 /goroutine）
进程：操作系统资源容器（程序运行实例），Go 不通过 go 关键字开进程，开进程用 os/exec；
OS 线程（系统线程）：操作系统内核调度，内存开销大，几千个就占满内存；
goroutine（Go 协程）：Go 运行时（runtime）自己管理的轻量级用户态协程，不是系统线程。

启动语法：只有 go 这一个关键字，没有 goroutine 关键字
go func(){}() // 直接加 go，新建一个 goroutine

没有单独定义、声明协程的语法，调用函数前加 go 就并发运行。
调度逻辑（M/P/G 模型，简单说）
G = goroutine（你写的协程），初始栈仅 2KB，轻松创建几十万、上百万个；
M = 操作系统内核线程；
P = 调度器逻辑；
Go 会把大量 goroutine 复用在少量系统线程上，不是一个协程对应一个系统线程。
不是 “一个线程里跑上万个协程”，是少量系统线程承载海量 goroutine。

问：有没有单独控制协程的 API？
基础层面没有直接操作、销毁、暂停单个 goroutine 的底层指令：
不能强制 kill 某个 goroutine；
不能手动暂停 / 恢复 goroutine；
协程退出只有两种方式：函数正常 return、内部 panic 且无 recover。
配套同步工具用来间接控制协程执行顺序：
sync.WaitGroup：等待一批子协程全部完成；
channel：协程间通信、收发信号控制启停；
sync.Mutex：互斥锁，协程并发安全；
context.Context：统一给多个协程发取消、超时信号（工程最常用）。


日常并发只记 go 关键字；系统线程不用管、不用手动创建；
进程只有调用外部程序才用 os/exec，业务开发基本碰不到。

```



---

## 四、Go 错误处理 vs Python try-except 核心区别

| 维度     | Go error + panic/recover      | Python try-except   |
| ------ | ----------------------------- | ------------------- |
| 设计理念   | 显式返回错误，强制调用方关注处理              | 隐式抛出异常，可跨层传递，容易被忽略  |
| 常规业务错误 | 用 error 返回，属于普通返回值            | 用 raise 抛出，走异常流程    |
| 处理方式   | 手动 `if err != nil` 判断         | try 块包裹，except 统一捕获 |
| 适用场景   | error 处理所有可预期错误；panic 仅处理致命意外 | 所有错误都可抛出捕获          |
| 性能开销   | error 是普通值，几乎无开销              | 异常栈展开有一定性能开销        |

---

## 核心避坑总结

1. error 是普通接口，不是特殊语法，实现 `Error()` 即可成为合法错误类型；
2. 日常业务错误全部用 error 返回，禁止滥用 panic 模拟异常；
3. recover 必须配合 defer 使用，仅能捕获当前协程的 panic；
4. 不要用 panic/recover 模拟 try-catch，不符合 Go 的设计哲学。



# Go 字符串与内存核心讲解

核心结论前置：Go 字符串是**不可变的 UTF-8 字节序列**，不能原地修改单个字符；中文等多字节字符必须用 `rune` 按字符处理；大量拼接优先用 `strings.Builder`；数值与字符串互转用 `strconv` 标准库。

---

## 一、string 底层本质与不可变性

### 1. 底层结构

string 底层是一个只读结构体，包含两部分：

- 指向字节数组的指针
- 字符串长度（字节数）

它是值类型，赋值只是拷贝指针和长度，底层字节数组共享，不会全量拷贝内存。

### 2. 不可变规则（核心特性）

字符串一旦创建，**不能原地修改单个字节 / 字符**，强制修改会直接编译报错：



```go
s := "hello"
// s[0] = 'H' // ❌ 编译报错：cannot assign to s[0]
```

### 3. 「修改」字符串的正确方式

必须先转成可变切片（`[]byte` / `[]rune`），修改后再转回 string，本质是生成全新字符串，底层会发生内存拷贝：

```go
s := "hello"
b := []byte(s)   // 转字节切片，拷贝内存
b[0] = 'H'
s2 := string(b)  // 转回新字符串
fmt.Println(s2)  // Hello
```

> 设计意义：不可变天然并发安全，可自由共享内存，不用担心被意外修改。

---

## 二、字符串拼接的 4 种方式与选型

### 1. `+` 号拼接（少量拼接用）

最简单直观，每次拼接都会生成新字符串，多次拼接性能差：

```go
s := "hello" + " " + "go"
```

### 2. `fmt.Sprintf`（带格式化拼接）

适合需要拼接变量、格式化的场景：

```go
name := "张三"
s := fmt.Sprintf("姓名：%s，年龄：%d", name, 18)
```

### 3. `strings.Join`（已知切片批量拼接）

字符串切片合并成一个，性能优于循环 `+`：

```go
parts := []string{"a", "b", "c"}
s := strings.Join(parts, "-") // a-b-c

```

### 4. `strings.Builder`（大量拼接首选，高性能）

内部维护可变缓冲区，避免多次内存拷贝，循环拼接场景性能最优：

```go
var builder strings.Builder
for i := 0; i < 10; i++ {
    builder.WriteString("go")
}
s := builder.String()
fmt.Println(s)  //gogogogogogogogogogo
```

---

## 三、strconv：字符串与数值类型互转

`strconv` 是标准库，专门负责字符串与基础数值类型的互相转换，比 `fmt.Sprintf` 性能更好。

### 1. 最常用两个：int ↔ string

```go
import "strconv"

// int → string
s := strconv.Itoa(123) // "123"
fmt.Printf("%T \n", s) // string
// string → int，会返回 error
num, err := strconv.Atoi("456")
fmt.Printf("%T \n", num) // int
if err != nil {
	fmt.Println("转换失败")
}

```

### 2. 其他常用转换

- `ParseBool / FormatBool`：布尔值互转
- `ParseFloat / FormatFloat`：浮点数互转
- `ParseInt / FormatInt`：指定进制的整型互转

---

## 四、rune：处理中文等多字节字符

### 1. 为什么需要 rune

Go 字符串按**字节**存储，中文是 UTF-8 编码，一个中文占 3 个字节。直接按索引取值拿到的是字节，不是完整字符，会出现乱码。

`rune` 本质是 `int32`，代表一个 Unicode 字符码点，用来按「字符」而非「字节」处理字符串。

### 2. 字节长度 vs 字符长度

```go
s := "你好go"

fmt.Println(len(s))       // 8：字节数（你3 + 好3 + g1 + o1 = 8）
fmt.Println(len([]rune(s))) // 4：字符数（你、好、g、o 共4个字符）
```

### 3. 两种遍历方式

```go
s := "你好go"

// 方式1：for 按字节遍历，中文会拆成乱码字节
for i := 0; i < len(s); i++ {
    fmt.Printf("%d: %c\n", i, s[i]) // 中文会显示乱码
}

// 方式2：for range 自动按 rune（字符）遍历，推荐
for i, r := range s {
    fmt.Printf("索引%d, 字符%c\n", i, r) // 中文正常显示
}
```

### 4. 按字符修改字符串

修改中文必须先转 `[]rune`：

```go
s := "你好go"
runes := []rune(s)
runes[0] = '您'
s2 := string(runes)
fmt.Println(s2) // 您好go
```

---

## 五、字符串 ↔ 切片互转总结

| 转换方向              | 用途               | 特点                   |
| ----------------- | ---------------- | -------------------- |
| `string → []byte` | 按字节修改、网络 / IO 传输 | 英文、二进制场景用，有内存拷贝      |
| `[]byte → string` | 字节数据转回字符串        | 生成新字符串               |
| `string → []rune` | 按字符处理中文、修改字符     | 中文、Unicode 场景用，有内存拷贝 |
| `[]rune → string` | 字符切片转回字符串        | 生成新字符串               |

---

## 核心避坑总结

1. **字符串不可变**：不能原地改字符，修改必须转切片再转回，会生成新字符串；
2. **中文处理用 rune**：`len(string)` 是字节数，`len([]rune(s))` 才是字符数，遍历优先用 `for range`；
3. **拼接选型**：少量用 `+`，格式化用 `fmt.Sprintf`，循环大量拼接用 `strings.Builder`；
4. **数值转换**：优先用 `strconv`，性能优于 fmt，注意处理转换错误。



## Go strings 标准库常用方法整理

```go
所有方法均为纯函数，不会修改原字符串（符合字符串不可变特性），统一返回新字符串或判断结果，导入方式：import "strings"。

一、包含与统计类
//判断 s 是否包含子串 substr	
strings.Contains("hello go", "go") → true
//判断是否以 prefix 开头	
strings.HasPrefix("go_lang", "go") → true
//判断是否以 suffix 结尾	
strings.HasSuffix("test.go", ".go") → true
//统计子串出现的次数	
strings.Count("banana", "a") → 3

二、查找位置类
//返回子串第一次出现的索引，找不到返回 -1	
strings.Index("abcabc", "bc") → 1
//返回子串最后一次出现的索引，找不到返回 -1	
strings.LastIndex("abcabc", "bc") → 4

三、替换类
// 替换前n个old为new；n=-1 表示替换全部
s1 := strings.Replace("banana", "a", "o", 2) // "bonona"

// 替换所有匹配项（最常用）
s2 := strings.ReplaceAll("banana", "a", "o") // "bonono"

四、分割与拼接
// 1. 按分隔符全量切割，返回字符串切片
parts := strings.Split("a-b-c-d", "-") 
// []string{"a", "b", "c", "d"}

// 2. 切割成指定段数，最后一段不再拆分
parts2 := strings.SplitN("a-b-c-d", "-", 2) 
// []string{"a", "b-c-d"}

// 3. 字符串切片按分隔符拼接
s := strings.Join([]string{"a", "b", "c"}, ",") 
// "a,b,c"

五、大小写转换
strings.ToUpper("hello")  // "HELLO"  全大写
strings.ToLower("GO")     // "go"     全小写

六、修剪去除类
// 1. 去除首尾所有空白字符（空格、换行、制表符）
strings.TrimSpace("  hello go  ") // "hello go"

// 2. 去除首尾所有在 cutset 中的字符
strings.Trim("-=hello=-", "-=")   // "hello"

// 3. 去除指定前缀/后缀
strings.TrimPrefix("api/user", "api/") // "user"
strings.TrimSuffix("test.go", ".go")   // "test"

七、比较类
// 忽略大小写比较是否相等（最常用）
strings.EqualFold("Go", "go") // true

// 字典序比较：a<b返回-1，相等返回0，a>b返回1
// 日常直接用 == 比较字符串即可，极少用Compare
strings.Compare("abc", "abd") // -1


核心记忆点
所有方法都不修改原字符串，返回新结果；
高频组合：Split 拆分处理 + Join 拼接还原；
批量循环拼接不要用 +，用之前讲的 strings.Builder。
```



# Go 高级容器：make /new 核心讲解

核心结论前置：`new` 和 `make` 都是内存分配内置函数，但分工完全不同。`new` 是通用内存分配器，返回指针、只设零值；`make` 是专属构造器，仅用于 slice/map/chan 三种引用类型，会初始化其内部复杂结构，返回类型本身。

---

## 一、new 函数：通用零值内存分配

### 语法与作用

```go
new(T) // 传入类型 T，返回 *T 指针
```

- 为类型 T 分配一块内存，填充对应零值
- 返回指向这块内存的指针
- 不做任何额外初始化，只保证内存清零

### 代码示例

```go
package main

import "fmt"

func main() {
    // 给 int 分配内存，返回 *int，值为零值 0
    p := new(int)
    fmt.Println(p)  // 内存地址
    fmt.Println(*p) // 0

    // 给结构体分配内存，返回结构体指针，所有字段零值
    type Person struct {
        Name string
        Age  int
    }
    pp := new(Person)
    fmt.Printf("%+v\n", pp) // &{Name: Age:0}
}
```

### 关键说明

1. **实际开发使用极少**：结构体通常直接用 `&Person{}` 初始化，更灵活；基础类型直接声明即可，没必要用 `new`。
2. **只能做零值初始化**：无法传入初始值，也无法初始化复杂内部结构，因此不能用于 slice/map/chan。

---

## 二、make 函数：引用类型专属构造

`make` 仅支持 **slice、map、channel** 三种类型。这三类都是 Go 的引用类型，底层有复杂的内部结构（比如切片的数组指针 + 长度 + 容量、map 的哈希桶、chan 的环形缓冲区），仅靠 `new` 清零无法正常使用，必须用 `make` 做完整初始化。

> 注意：`make` 返回的是类型本身，不是指针，因为这三类本身就自带底层指针。

### 1. make 创建切片 slice

#### 语法

```go
make([]T, length, capacity)
```

- `length`：切片长度，即当前已有的元素个数，这些元素自动初始化为零值
- `capacity`：切片容量，即底层数组的总长度，可选，省略则默认等于 length

#### 代码示例

```go
// len=3, cap=3，三个元素均为 0
s1 := make([]int, 3)

// len=0, cap=10，空切片，提前预留 10 个元素空间
s2 := make([]int, 0, 10)

// 追加元素，预分配容量可避免频繁扩容，提升性能
s2 = append(s2, 1, 2, 3)
```

#### 核心要点

- 下标访问不能超过 `len`，哪怕 `cap` 更大也会越界 panic
- 预分配 `cap` 是性能优化手段，适合已知数据量的场景
- `var s []int` 是 nil 切片；`make([]int, 0)` 是空切片，两者 `len/cap` 都是 0，`append` 都能正常使用

### 2. make 创建映射 map

#### 语法

```go
make(map[KeyType]ValueType, 初始容量)
```

初始容量是预分配的桶数量，只是性能优化，不是元素上限，map 会自动扩容。

#### 代码示例

```go
// 基础创建
m1 := make(map[string]int)

// 预分配容量，预估存 100 个键值对，减少运行时扩容
m2 := make(map[string]int, 100)

m2["age"] = 18 // 正常写入
```

#### 核心避坑

- **只声明不 make 的 nil map 只能读，写入直接 panic**

```go
var m map[string]int // nil map
fmt.Println(m["a"]) // 读没问题，返回零值
m["a"] = 10         // ❌ 写入 panic: assignment to entry in nil map
```

- 所以 map 必须用 `make` 初始化后再执行写入操作

### 3. make 创建通道 channel

#### 语法

```go
make(chan T, 缓冲区大小)
```

- 缓冲区大小 = 0：无缓冲通道，发送和接收必须同时就绪，否则阻塞
- 缓冲区大小 > 0：有缓冲通道，缓冲区满了发送才阻塞，空了接收才阻塞

#### 代码示例

```go
// 无缓冲通道
ch1 := make(chan int)

// 有缓冲通道，容量为 5
ch2 := make(chan int, 5)
```

#### 核心避坑

- nil 通道（只声明不 make）的读写都会永久阻塞，导致死锁
- 通道必须用 `make` 创建后才能收发数据

---

## 三、new vs make 系统对比

表格

| 维度                  | new                   | make                |
| ------------------- | --------------------- | ------------------- |
| 适用类型                | 所有类型                  | 仅 slice、map、channel |
| 返回值                 | `*T` 指针               | `T` 类型本身（引用类型）      |
| 初始化行为               | 仅内存清零为零值，不初始化内部结构     | 完整初始化底层数据结构，可直接使用   |
| 典型场景                | 极少使用，多用于基础类型 / 结构体取指针 | 日常高频使用，创建切片、映射、通道   |
| 能否用于 slice/map/chan | 语法合法但无法正常使用           | 专属正确用法              |

---

## 核心避坑总结

1. slice、map、chan 永远用 `make` 创建，不要用 `new`，否则内部结构未初始化，无法正常操作
2. map、channel 必须初始化后再写入 / 收发，nil 状态操作会触发 panic 或死锁
3. slice 的 `make` 参数顺序是「长度在前，容量在后」，预分配容量是性能优化，不限制元素总数
4. 日常开发几乎不用 `new`，结构体直接用 `&Type{}`、基础类型直接声明更直观



# Go channel 完整详解

channel（通道）是 Go CSP 并发模型的核心，是**专门给 goroutine 之间安全传递数据、同步执行状态的管道**。它天然并发安全，不用加锁就能实现多协程通信，是 Go 并发编程的核心工具。

---

## 一、channel 用来干嘛

核心作用有 4 个，覆盖 99% 并发场景：

1. **协程间安全传值**：不同 goroutine 之间传递数据，底层自动保证并发安全，替代传统共享内存 + 锁的方案
2. **协程同步控制**：主协程等待子协程完成、给子协程发停止 / 取消信号
3. **并发限流**：控制同时运行的协程数量，防止协程爆炸
4. **任务流水线**：多协程接力处理数据，实现生产者 - 消费者模式

---

## 二、基础语法与三大操作

### 1. 声明与创建

channel 是引用类型，必须用 `make` 创建，分为**无缓冲通道**和**有缓冲通道**两种：

```go
// 声明：chan + 元素类型
var ch chan int // nil 通道，不能直接用，读写都会永久阻塞

// 创建无缓冲通道（缓冲区大小为0）
ch = make(chan int)

// 创建有缓冲通道，缓冲区容量为 5
ch = make(chan int, 5)
```

### 2. 三大核心操作

操作符 `<-` 是固定写法，**箭头指向哪里，数据就往哪里流**：



```go
ch := make(chan int, 5)

// 1. 发送：把数据写入通道（箭头指向通道）
ch <- 10

// 2. 接收：从通道读取数据（箭头从通道指出）
num := <-ch

// 3. 关闭通道
close(ch)
```

---

## 三、两大类型：无缓冲 vs 有缓冲

### 1. 无缓冲通道 `make(chan T)`

- 缓冲区大小为 0，发送和接收必须**同时就绪**才能完成
- 发送方会一直阻塞，直到有接收方来取数据；接收方也会一直阻塞，直到有发送方发数据
- 核心用途：**强同步**，比如协程间的完成通知、信号传递

```go
func main() {
    ch := make(chan bool) // 无缓冲

    go func() {
        fmt.Println("子协程执行任务")
        ch <- true // 发送完成信号，主协程没收就一直阻塞
    }()

    <-ch // 主协程阻塞等待，直到收到信号才往下走
    fmt.Println("任务完成，主协程退出")
}
```

### 2. 有缓冲通道 `make(chan T, 容量)`

- 内部有固定大小的环形缓冲区，发送方只要缓冲区没满就能直接写入，不用等接收方
- 接收方只要缓冲区没空就能直接读取，不用等发送方
- 缓冲区满了发送才阻塞，缓冲区空了接收才阻塞
- 核心用途：**解耦发送和接收、削峰填谷、限流**

```go
func main() {
    ch := make(chan int, 3) // 缓冲容量3

    // 缓冲区没满，写入不阻塞
    ch <- 1
    ch <- 2
    ch <- 3

    // ch <- 4 // 缓冲区满了，再写就阻塞

    fmt.Println(<-ch) // 1，读走一个腾出位置
    ch <- 4 // 现在可以继续写了
}
```

---

## 四、关键进阶特性

### 1. 通道关闭后的行为规则

用 `close(ch)` 关闭通道后，有严格的行为约定：

- ❌ 不能再向已关闭的通道发送数据，否则直接 panic
- ✅ 可以继续读取剩余数据，缓冲区的内容全部取完之前正常返回值
- ✅ 缓冲区取空后，再读取会**立即返回对应类型的零值，不会阻塞**，同时第二个返回值为 `false`

```go
ch := make(chan int, 2)
ch <- 10
ch <- 20
close(ch)

// 取剩余值
fmt.Println(<-ch) // 10
fmt.Println(<-ch) // 20

// 取空后：零值 + false
v, ok := <-ch
fmt.Println(v, ok) // 0 false
```

> 关闭原则：**永远由发送方关闭通道**，接收方不要关；禁止重复关闭同一个通道，会 panic。

### 2. for range 遍历通道

最常用的通道读取方式：自动循环接收数据，**通道关闭后自动退出循环**，不会死锁。

```go
ch := make(chan int)

// 生产者协程：发数据，发完关闭
go func() {
    for i := 0; i < 5; i++ {
        ch <- i
    }
    close(ch) // 必须关闭，否则 range 会一直阻塞死锁
}()

// 消费者：遍历接收
for num := range ch {
    fmt.Println("收到:", num)
}
```

### 3. select 多路复用

同时监听多个通道的读写状态，哪个通道先就绪就执行哪个分支，是 Go 并发控制的核心语法。



```go
select {
case v := <-ch1:
    fmt.Println("从ch1收到:", v)
case ch2 <- 100:
    fmt.Println("向ch2写入成功")
case <-time.After(time.Second):
    fmt.Println("超时1秒")
default:
    fmt.Println("所有通道都没就绪，不阻塞，直接走这里")
}
```

- 多个分支同时就绪：随机选一个执行
- 没有 `default`：会一直阻塞直到某个通道就绪
- 典型用途：超时控制、多路信号监听、非阻塞读写

---

## 五、经典使用场景（带完整代码）

### 场景 1：协程停止信号通知

给运行中的子协程发退出信号，是工程最常用的模式：

```go
func main() {
    stopCh := make(chan struct{}) // 空结构体不占内存，专门做信号

    go func() {
        for {
            select {
            case <-stopCh:
                fmt.Println("收到停止信号，退出")
                return
            default:
                fmt.Println("工作中...")
                time.Sleep(500 * time.Millisecond)
            }
        }
    }()

    time.Sleep(2 * time.Second)
    close(stopCh) // 关闭通道广播停止信号
    time.Sleep(500 * time.Millisecond)
}
```

### 场景 2：并发限流（信号量模式）

控制同时运行的协程数量，防止瞬间开太多协程打满资源：

```go
func main() {
    sem := make(chan struct{}, 3) // 同时最多3个协程运行
    var wg sync.WaitGroup

    for i := 0; i < 10; i++ {
        wg.Add(1)
        go func(n int) {
            defer wg.Done()
            sem <- struct{}{} // 占一个坑位
            defer func() { <-sem }() // 释放坑位

            fmt.Printf("任务%d执行中\n", n)
            time.Sleep(time.Second)
        }(i)
    }
    wg.Wait()
}
```

---

## 六、核心避坑总结

1. **nil 通道永久阻塞**：只声明不 make 的通道是 nil，读写都会永久阻塞，造成死锁

2. **死锁常见场景**：
   
   - 无缓冲通道只有发送没有接收，或只有接收没有发送
   - for range 遍历通道但发送方忘记关闭通道

3. **关闭规则**：发送方关闭、不重复关闭、关闭后不能再写

4. **通道不会自动回收**：不用的通道记得关闭，否则可能造成 goroutine 泄漏

5. **通道是引用类型**：函数传递直接传 chan 即可，不用传指针





# Go 文件与 IO 基础

核心结论前置：Go 文件 IO 分为两层：

- `os` 包：封装操作系统调用，直接操作文件句柄，适合整块读写大文件；

- `bufio` 包：在 `os` 之上封装内存缓冲区，减少系统调用次数，适合频繁小数据读写、逐行处理。
  
  所有手动打开的文件句柄必须关闭，否则会造成系统资源泄漏。

---

## 一、os 包：底层文件操作

### 1. 文件打开与关闭

#### 两个核心打开函数

- `os.Open(filename)`：**只读模式**打开文件，最常用；
- `os.OpenFile(filename, 模式, 权限)`：自定义读写模式、创建规则，适合写入、追加等场景。

文件操作完成后必须调用 `Close()` 释放资源，工程中统一用 `defer` 保证函数退出时自动关闭。

```go
package main

import (
    "fmt"
    "os"
)

func main() {
    // 只读模式打开文件
    file, err := os.Open("test.txt")
    if err != nil {
        fmt.Println("打开失败:", err)
        return
    }
    // 函数退出前自动关闭文件，避免资源泄漏
    defer file.Close()
}
```

#### OpenFile 常用模式（可通过 `|` 组合）

| 模式常量          | 作用           |
| ------------- | ------------ |
| `os.O_RDONLY` | 只读           |
| `os.O_WRONLY` | 只写           |
| `os.O_RDWR`   | 读写           |
| `os.O_CREATE` | 文件不存在则创建     |
| `os.O_APPEND` | 追加写入（不清空原文件） |
| `os.O_TRUNC`  | 打开时清空原文件内容   |

权限位一般填 `0644`（所有者读写、其他用户只读），仅创建新文件时生效。

```go
// 示例：追加写入模式打开，不存在则创建
file, err := os.OpenFile("log.txt", os.O_WRONLY|os.O_CREATE|os.O_APPEND, 0644)
```

### 2. 一次性读写整个文件（最简洁常用）

Go 1.16+ 提供 `os.ReadFile` / `os.WriteFile`，内部自动打开、关闭文件，无需手动 `Close`，代码最精简。

```go
// 一次性读取整个文件到字节切片
data, err := os.ReadFile("test.txt")
if err != nil {
    fmt.Println("读取失败:", err)
    return
}
fmt.Println(string(data)) // 字节转字符串

// 一次性写入文件，不存在则创建，存在则覆盖
content := []byte("hello go file io")
err = os.WriteFile("output.txt", content, 0644)
if err != nil {
    fmt.Println("写入失败:", err)
}
```

> 注意：仅适合大小可控的文件，超大文件全量读入会占用大量内存，甚至触发 OOM。

### 3. 按字节分段读取（大文件处理）

大文件不能一次性读入内存，通过 `Read` 方法循环读取固定大小的字节块，边读边处理。

```go
package main

import (
	"fmt"
	"io"
	"os"
)

func main() {
	file, _ := os.Open("large_file.txt")
	defer file.Close()

	buf := make([]byte, 4096) // 每次读 4KB  ;固定 buf
	for {
		// n 为本次实际读到的字节数
		n, err := file.Read(buf)
		if err == io.EOF {
			break // 文件读取完毕，正常结束
		}
		if err != nil {
			fmt.Println("读取出错:", err)
			break
		}
		// 只处理前 n 个有效字节;每次循环都打印一次
		fmt.Print(string(buf[:n]))
	}
}

```

---

## 二、bufio 包：带缓冲的 IO

### 1. 为什么需要缓冲

每次调用 `file.Read()` / `file.Write()` 都是一次操作系统调用，频繁读写小数据（比如逐行、单字节）性能开销极高。

`bufio` 在内存中维护默认 4KB 的缓冲区，数据先攒在缓冲区，攒满后再执行一次系统调用，大幅减少系统调用次数，显著提升小数据频繁读写的性能。

### 2. 缓冲读取：逐行读取（最常用场景）

推荐使用 `bufio.Scanner`，专门为逐行读取设计，用法简洁。

```go
import "bufio"

file, _ := os.Open("large_file.txt")
defer file.Close()

// 创建扫描器，默认按换行符逐行读取
scanner := bufio.NewScanner(file)

for scanner.Scan() {
    line := scanner.Text() // 获取当前行的字符串
    fmt.Println("行内容:", line)
}

// 检查读取过程中是否发生错误
if err := scanner.Err(); err != nil {
    fmt.Println("读取异常:", err)
}
```

### 3. 缓冲写入

数据先写入内存缓冲区，缓冲区满自动刷盘，也可手动 `Flush()` 强制写入磁盘。

**核心避坑：写入结束必须调用 `Flush()`，否则缓冲区中未刷盘的数据会丢失。**

```go
file, _ := os.OpenFile("output.txt", os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0644)
defer file.Close()

// 创建缓冲写入器，默认缓冲区 4KB
writer := bufio.NewWriter(file)

// 数据先写入内存缓冲区
writer.WriteString("第一行内容\n")
writer.WriteString("第二行内容\n")

// 强制将缓冲区所有数据刷入磁盘，必须调用！
writer.Flush()
```

---

## 三、选型总结 + 核心避坑

### 选型参考

| 场景           | 推荐方案                                  |
| ------------ | ------------------------------------- |
| 小文件、内容量可控    | `os.ReadFile` / `os.WriteFile`，代码最简洁  |
| 大文件、按字节块处理   | `os.File.Read` 循环分段读                  |
| 逐行处理、频繁小数据读写 | `bufio.Scanner` / `bufio.Writer`，性能更优 |

### 核心避坑

1. 手动 `os.Open` / `os.OpenFile` 打开的文件，必须用 `defer file.Close()` 关闭；`os.ReadFile/WriteFile` 内部自动处理，无需手动关闭。
2. `bufio.Writer` 写入完成必须调用 `Flush()`，否则数据残留在内存不会落盘。
3. 超大文件禁止一次性 `ReadFile` 全量加载，会导致内存溢出。
4. 写入文件默认会覆盖原内容，需要追加必须加上 `os.O_APPEND` 模式。



## 补充目录遍历、文件复制的示例，io 包的通用流操作

### 1. 目录遍历（filepath.WalkDir，递归遍历）

```go
package main

import (
    "fmt"
    "io/fs"
    "path/filepath"
)

func main() {
    root := "./my_dir" // 遍历根目录
    // WalkDir 递归遍历，性能优于旧版 filepath.Walk
    err := filepath.WalkDir(root, func(path string, d fs.DirEntry, err error) error {
        if err != nil {
            return err // 遍历出错，终止
        }
        if d.IsDir() {
            fmt.Println("[目录]", path)
        } else {
            fmt.Println("[文件]", path)
        }
        return nil // 返回nil继续遍历
    })
    if err != nil {
        fmt.Println("遍历失败:", err)
    }
}
```

---

### 2. 文件复制（io.Copy 官方推荐，自动缓冲）

```go
package main

import (
	"fmt"
	"io"
	"os"
)

func main() {
	// 打开源文件
	src, err := os.Open("src.txt")
	if err != nil {
		panic(err)
	}
	defer src.Close()

	// 创建目标文件（存在则覆盖）
	dst, err := os.Create("dst_copy.txt")
	if err != nil {
		panic(err)
	}
	defer dst.Close()

	// 核心：io.Copy 自动对接 Reader/Writer，底层带缓冲，无需手动循环读写
	size, err := io.Copy(dst, src)
	fmt.Printf("复制完成，共%d字节\n", size)
}

```

---

### 3. io 通用流操作（核心：Reader/Writer 接口）

Go IO 的核心是 `io.Reader` / `io.Writer` 接口，**所有实现该接口的类型（文件、字符串、网络连接、管道等）都可以通用一套读写逻辑**。

```go
package main

import (
    "io"
    "os"
    "strings"
)

// 通用读取函数：只依赖接口，不关心具体数据源
func readContent(r io.Reader) (string, error) {
    data, err := io.ReadAll(r) // 一次性读全量
    return string(data), err
}

func main() {
    // 数据源1：字符串
    s1, _ := readContent(strings.NewReader("hello io"))
    println("字符串源:", s1)

    // 数据源2：文件
    f, _ := os.Open("test.txt")
    defer f.Close()
    s2, _ := readContent(f)
    println("文件源:", s2)

    // 网络流、内存缓冲等均可直接传入，不用修改函数逻辑
}


//-------------------------------------------- 详解

r io.Reader 和 strings.NewReader("hello io") 这两个是怎么理解  详细介绍下

这涉及到 Go 语言中**接口（Interface）和多态（Polymorphism）**的核心概念。让我详细解释：

1. io.Reader 是什么？
io.Reader 是 Go 标准库中定义的一个接口：
// io.Reader 接口定义
type Reader interface {
    Read(p []byte) (n int, err error)
}

它只要求实现一个方法：
- Read(p []byte)：从数据源读取数据到 p 中
- 返回实际读取的字节数 n 和可能的错误 err

关键特点：
- 抽象层：不关心数据来自哪里（文件、网络、内存...）
- 通用性：任何实现了 Read 方法的类型都可以当作 io.Reader 使用
- 解耦：函数只依赖接口，不依赖具体实现

2. strings.NewReader("hello io") 是什么？
strings.NewReader() 是一个适配器函数，它的作用是：

// 将字符串转换为 io.Reader
reader := strings.NewReader("hello io")

它做了两件事：
1 创建一个内部类型 *strings.Reader
2 这个类型实现了 io.Reader 接口的 Read 方法

本质上： 把静态字符串变成了一个可读的数据流。

3. 它们是如何协作的？
这是 Go 语言多态性的经典体现：

func readContent(r io.Reader) (string, error) {
    data, err := io.ReadAll(r)
    return string(data), err
}

readContent 函数只知道 r 是一个 io.Reader，它不关心 r 具体是什么：

数据源类型	如何转换为 io.Reader	                使用方式
字符串	    strings.NewReader(str)	            readContent(strings.NewReader("hello"))
文件	        os.Open("file.txt") 返回的 *os.File	readContent(file)
网络连接	    net.Dial() 返回的 net.Conn	        readContent(conn)
HTTP 响应体	resp.Body	                        readContent(resp.Body)

4. 实际工作流程
以你的代码为例：
s1, _ := readContent(strings.NewReader("hello io"))

执行过程：
1 strings.NewReader("hello io") 创建一个字符串读取器
2 将这个读取器传入 readContent（因为它实现了 io.Reader）
3 io.ReadAll(r) 内部调用 r.Read(buf) 方法
4 字符串读取器的 Read 方法从字符串中逐次读取字节
5 最终返回完整的字符串内容

5. 这种设计的优势
最大的好处是： readContent 函数可以复用在任何数据源上！

// 同一个函数，三种不同数据源
readContent(strings.NewReader("hello"))  // 字符串
readContent(file)                        // 文件  
readContent(resp.Body)                   // HTTP 响应体

这就是依赖倒置原则：依赖抽象（接口）而非具体实现。

总结
概念	                    解释
io.Reader	            一个抽象接口，定义了"可读"的标准行为
strings.NewReader()	    将字符串包装成实现了 io.Reader 的类型
协作方式	                多态：相同接口，不同实现，统一处理
设计价值	                解耦、复用、灵活
这种模式在 Go 中无处不在，是理解 Go 语言设计哲学的关键！



```

---

### 精简要点

1. 目录遍历优先用 `filepath.WalkDir`，回调处理每个条目；
2. 文件复制直接用 `io.Copy`，底层自动优化，不用手写循环；
3. Go IO 全靠 `Reader/Writer` 接口解耦，任意数据源可复用同一套逻辑。





# Go 并发核心全解（精简代码 + 注释）

Go 并发核心逻辑：goroutine 负责并发执行，channel 负责协程通信，sync 包负责同步互斥，select 负责多路控制。

---

## 1. goroutine + sync.WaitGroup（协程启动与等待）

### 核心规则

- 仅需 `go` 关键字即可启动协程，主协程退出时所有子协程会直接终止

- `sync.WaitGroup` 用于等待一批协程全部执行完成
  
  - `Add(n)`：计数器加 n，启动协程前调用
  - `Done()`：计数器减 1，协程结束时调用
  - `Wait()`：阻塞等待计数器归零



```go
package main

import (
	"fmt"
	"sync"
)

func main() {
	var wg sync.WaitGroup //用于等待一批协程全部执行完成

	for i := 0; i < 3; i++ {
		wg.Add(1) // 启动协程前计数+1
		go func(n int) {
			defer wg.Done() // 协程结束计数-1
			fmt.Println("协程", n, "执行完成")
		}(i) // 传参避免闭包循环变量共享问题
	}

	wg.Wait() // 阻塞，等待所有协程执行完毕
	fmt.Println("全部协程结束")
}

```

---

## 2. channel 通道

### 2.1 无缓冲 vs 有缓冲通道

- 无缓冲：收发必须同时就绪才能完成，用于强同步
- 有缓冲：缓冲区未满可直接写入，未空可直接读取，解耦收发双方

```go
func main() {
    // 无缓冲通道：同步通信
    unbufCh := make(chan int)
    go func() { unbufCh <- 100 }() // 子协程发送
    fmt.Println("无缓冲收到:", <-unbufCh) // 主协程接收

    // 有缓冲通道：容量3，缓冲区未满不阻塞
    bufCh := make(chan string, 3)
    bufCh <- "a"
    bufCh <- "b"
    bufCh <- "c"
    fmt.Println("缓冲通道当前长度:", len(bufCh))
}
```

### 2.2 单向通道（函数参数权限约束）

- `chan<- T`：只写通道
- `<-chan T`：只读通道
- 仅用于函数形参，限制操作权限，提升代码安全性

```go
// 生产者：只能向通道写入
func producer(ch chan<- int) {
    ch <- 1
    close(ch)
}

// 消费者：只能从通道读取
func consumer(ch <-chan int) int {
    return <-ch
}
```

### 2.3 close 关闭 + range 遍历

- `close(ch)` 由发送方调用，关闭后不可写入，仍可读剩余数据
- 缓冲区读空后继续读取，返回零值 + false
- `for range` 遍历通道，通道关闭后自动退出循环

```go
func main() {
    ch := make(chan int, 5)

    // 生产者：发完数据关闭通道
    go func() {
        for i := 0; i < 5; i++ {
            ch <- i
        }
        close(ch) // 必须关闭，否则 range 会永久阻塞死锁
    }()

    // 消费者：自动遍历，通道关闭后退出
    for num := range ch {
        fmt.Println("收到:", num)
    }
}
```

---

## 3. 同步锁：互斥锁 + 读写锁

### 3.1 sync.Mutex 互斥锁

- 解决并发读写共享数据的竞态问题，同一时间仅一个协程可持有锁
- 惯例用 `defer` 解锁，避免遗漏

```go
package main

import (
	"fmt"
	"sync"
)

func main() {
	var (
		mu    sync.Mutex
		count int
		wg    sync.WaitGroup
	)

	for i := 0; i < 1000; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			mu.Lock()                   // 加锁，独占共享资源
			fmt.Println("当前计数:", count) // 输出当前计数 1 2 3...
			count++                     // 操作共享数据
			mu.Unlock()                 // 解锁
		}()
	}

	wg.Wait()
	fmt.Println("最终计数:", count) // 稳定输出 1000，无竞态
}

```

### 3.2 sync.RWMutex 读写锁

- 读共享、写独占：多个读锁可同时持有，写锁与所有锁互斥
- 读多写少场景性能优于互斥锁
- `RLock()/RUnlock()` 读锁；`Lock()/Unlock()` 写锁

```go
package main

import (
	"fmt"
	"sync"
	"time"
)

var (
	rwMu sync.RWMutex // 读写锁
	data int          // 共享数据
	wg   sync.WaitGroup
)

// 读操作：加读锁，多个读协程可同时持有读锁，互不阻塞
func read(id int) int {
	rwMu.RLock()         // 加读锁（共享锁）
	defer rwMu.RUnlock() // 函数退出自动释放读锁

	fmt.Printf("[读协程%d] 加读锁成功，当前值 = %d\n", id, data)
	time.Sleep(100 * time.Millisecond) // 模拟读取业务耗时
	fmt.Printf("[读协程%d] 读取完成，释放读锁\n", id)
	return data
}

// 写操作：加写锁，独占资源，所有读/写协程都会被阻塞
func write(id int, val int) {
	rwMu.Lock()         // 加写锁（排他锁）
	defer rwMu.Unlock() // 函数退出自动释放写锁

	fmt.Printf("[写协程%d] 加写锁成功，将值改为 %d\n", id, val)
	time.Sleep(200 * time.Millisecond) // 模拟写入业务耗时
	data = val
	fmt.Printf("[写协程%d] 写入完成，释放写锁\n", id)
}

func main() {
	// 启动 5 个读协程
	for i := 1; i <= 5; i++ {
		wg.Add(1)
		go func(n int) {
			defer wg.Done()
			read(n)
		}(i)
	}

	// 启动 2 个写协程
	for i := 1; i <= 2; i++ {
		wg.Add(1)
		go func(n int) {
			defer wg.Done()
			write(n, n*10)
		}(i)
	}

	wg.Wait() // 等待所有协程执行完毕
	fmt.Println("\n全部操作结束，最终值 =", data)
}

```

---

## 4. select 多路复用 + 超时控制

### 核心规则

- 同时监听多个通道的读写状态，哪个通道先就绪就执行对应分支
- 多个通道同时就绪时随机选择一个；无 `default` 则阻塞等待
- `time.After(duration)` 返回计时通道，用于超时控制

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    ch := make(chan int)

    // 子协程 2 秒后发送数据
    go func() {
        time.Sleep(2 * time.Second)
        ch <- 1
    }()

    select {
    case res := <-ch:
        fmt.Println("收到数据:", res)
    case <-time.After(1 * time.Second): // 1 秒超时
        fmt.Println("请求超时，结束等待")
    }
}
```

> 补充：添加 `default` 分支可实现非阻塞读写，不会阻塞等待通道就绪。

---

## 5. sync.Once/sync.Map/atomic 原子操作

### 5.1 sync.Once

- 保证指定函数在程序全生命周期内仅执行一次
- 常用于单例初始化、配置加载等场景

```go
package main

import (
	"fmt"
	"sync"
)

var once sync.Once

func initConfig() {
	fmt.Println("配置仅初始化一次")
}

func main() {
	for i := 0; i < 5; i++ {
		once.Do(initConfig) // 仅第一次调用会真正执行
	}
}

```

### 5.2 sync.Map

- 原生并发安全的 map，无需额外加锁
- 适用场景：读多写少、键值对动态增长、分属不同协程
- 核心方法：`Load` / `Store` / `Delete` / `Range`

```go
package main

import (
	"fmt"
	"sync"
)

var m sync.Map

func main() {
	m.Store("name", "golang") // 写入键值对
	m.Store("age", 18)

	val, ok := m.Load("name") // 读取
	fmt.Println(val, ok)

	// 遍历所有键值对
	m.Range(func(key, value interface{}) bool {
		fmt.Println(key, value)
		return true // 返回 true 继续遍历
	})

	m.Delete("name") // 删除
}

```

### 5.3 sync/atomic 原子操作

- 无锁操作基础数值类型，性能优于互斥锁
- 常用方法：`AddInt64`、`LoadInt64`、`StoreInt64`、`CompareAndSwapInt64`
  - 1. AddInt64：原子给 int64 变量增减数值，并发计数无锁安全。
    2. LoadInt64：原子读取 int64，拿到完整有效值。
    3. StoreInt64：原子写入 int64，不会读到半写数据。
    4. CompareAndSwapInt64 (CAS)：原值等于预期才原子更新，成功 true 失败 false，用于无锁修改。

```go
package main

import (
    "fmt"
    "sync"
    "sync/atomic"
)

func main() {
    var count int64
    var wg sync.WaitGroup

    for i := 0; i < 1000; i++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
            atomic.AddInt64(&count, 1) // 原子自增，无锁安全
        }()
    }
    wg.Wait()
    fmt.Println("原子计数结果:", atomic.LoadInt64(&count))
}
```

---

## 核心精简总结

1. 并发启动用 `go`，等待协程用 `sync.WaitGroup`；
2. 协程通信用 channel，同步用无缓冲、解耦用有缓冲，函数参数用单向通道约束；
3. 共享资源保护：简单互斥用 Mutex，读多写少用 RWMutex，基础数值优先用 atomic；
4. 多路控制用 select，超时用 `time.After`；
5. 单次执行用 sync.Once，并发 map 用 sync.Map。



# 常用标准库

## 1. time 时间库

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    // 获取当前时间
    now := time.Now()

    // 时间格式化（固定模板 2006-01-02 15:04:05，Go诞生时间，不可修改）
    fmt.Println("标准格式:", now.Format("2006-01-02 15:04:05"))
    fmt.Println("仅日期:", now.Format("2006-01-02"))

    // 延时等待
    time.Sleep(100 * time.Millisecond)

    // 定时器：周期性触发
    ticker := time.NewTicker(500 * time.Millisecond)
    go func() {
        for range ticker.C {
            fmt.Println("定时触发")
        }
    }()
    time.Sleep(1100 * time.Millisecond)
    ticker.Stop() // 停止定时器

    // 超时控制（配合select）
    select {
    case <-time.After(1 * time.Second):
        fmt.Println("1秒超时")
    }
}
```

**核心功能**：时间获取、格式化、延时、定时任务、超时控制。

---

## 2. fmt 格式化输出

go

运行

```
package main

import "fmt"

func main() {
    name, age := "张三", 18

    fmt.Println("换行打印:", name)        // 自动换行
    fmt.Printf("姓名:%s 年龄:%d\n", name, age) // 格式化输出
    fmt.Printf("通用值:%v\n", name)       // %v 通用占位符

    type User struct{ Name string; Age int }
    u := User{Name: "李四", Age: 20}
    fmt.Printf("结构体详情:%+v\n", u) // %+v 结构体带字段名打印
}
```

**核心功能**：控制台打印、字符串格式化，常用占位符 `%s/%d/%v/%+v`。

---

## 3. encoding/json 序列化

go

运行

```
package main

import (
    "encoding/json"
    "fmt"
)

// 字段必须首字母大写；json tag 指定序列化后的key
type User struct {
    Name string `json:"name"`
    Age  int    `json:"age"`
}

func main() {
    u := User{Name: "王五", Age: 22}

    // 序列化：结构体 → JSON字节
    data, err := json.Marshal(u)
    if err != nil {
        panic(err)
    }
    fmt.Println("序列化:", string(data))

    // 反序列化：JSON字节 → 结构体
    jsonStr := `{"name":"赵六","age":25}`
    var u2 User
    err = json.Unmarshal([]byte(jsonStr), &u2)
    if err != nil {
        panic(err)
    }
    fmt.Printf("反序列化: %+v\n", u2)
}
```

**核心功能**：结构体与 JSON 互转，接口数据交互必备。

---

## 4. net/http 网络库

### 4.1 启动 HTTP 服务

go

运行

```
package main

import (
    "fmt"
    "net/http"
)

func main() {
    // 注册路由与处理函数
    http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
        w.Write([]byte("Hello Go HTTP"))
    })

    fmt.Println("服务启动 :8080")
    http.ListenAndServe(":8080", nil) // 阻塞监听端口
}
```

### 4.2 发起 HTTP 请求

go

运行

```
package main

import (
    "fmt"
    "io"
    "net/http"
)

func main() {
    // GET请求
    resp, err := http.Get("https://example.com")
    if err != nil {
        panic(err)
    }
    defer resp.Body.Close()

    body, _ := io.ReadAll(resp.Body)
    fmt.Println("响应状态:", resp.Status)
    fmt.Println("响应长度:", len(body))
}
```

**核心功能**：搭建 Web 服务、发起网络请求。

---

## 5. flag 命令行参数解析

go

运行

```
package main

import (
    "flag"
    "fmt"
)

func main() {
    // 定义参数：参数名、默认值、说明
    name := flag.String("name", "default", "用户名")
    port := flag.Int("port", 8080, "服务端口")
    debug := flag.Bool("debug", false, "调试模式")

    flag.Parse() // 解析命令行传入的参数

    fmt.Println("用户名:", *name)
    fmt.Println("端口:", *port)
    fmt.Println("调试模式:", *debug)
}
// 运行示例：go run main.go -name=test -port=9090 -debug=true
```

**核心功能**：解析命令行启动参数，工具类程序常用。

---

## 6. os/exec 执行系统命令

go

运行

```
package main

import (
    "fmt"
    "os/exec"
)

func main() {
    // 执行系统命令（Windows替换为: exec.Command("cmd", "/c", "echo hello")）
    cmd := exec.Command("echo", "hello exec")

    // 获取命令输出（合并标准输出+错误输出）
    output, err := cmd.CombinedOutput()
    if err != nil {
        fmt.Println("执行失败:", err)
        return
    }
    fmt.Println("命令输出:", string(output))
}
```

**核心功能**：调用外部程序、执行 Shell / 系统命令。

---

## 7. context 上下文控制

go

运行

```
package main

import (
    "context"
    "fmt"
    "time"
)

func main() {
    // 1. WithCancel：手动取消协程
    ctx, cancel := context.WithCancel(context.Background())
    go func() {
        for {
            select {
            case <-ctx.Done():
                fmt.Println("收到取消信号，退出")
                return
            default:
                fmt.Println("工作中...")
                time.Sleep(200 * time.Millisecond)
            }
        }
    }()
    time.Sleep(500 * time.Millisecond)
    cancel() // 手动触发取消
    time.Sleep(200 * time.Millisecond)

    // 2. WithTimeout：超时自动取消
    fmt.Println("\n--- 超时控制 ---")
    ctx2, cancel2 := context.WithTimeout(context.Background(), 1*time.Second)
    defer cancel2()
    select {
    case <-time.After(2 * time.Second):
        fmt.Println("任务完成")
    case <-ctx2.Done():
        fmt.Println("超时:", ctx2.Err())
    }

    // 3. WithValue：上下文传值（仅传元数据，不做业务参数）
    ctx3 := context.WithValue(context.Background(), "user_id", 1001)
    fmt.Println("上下文值:", ctx3.Value("user_id"))
}
```

**核心功能**：协程链路的取消、超时控制、元数据传递，Web / 并发开发必备。

---

### 精简总结

1. time：时间、定时、超时
2. fmt：打印、字符串格式化
3. json：结构体与 JSON 互转
4. net/http：Web 服务与接口请求
5. flag：命令行参数解析
6. os/exec：调用外部系统命令
7. context：并发链路的超时、取消、传值
