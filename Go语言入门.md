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
   
   
   -------------------------------------------------
   # 直接查看模块缓存目录    C:\Users\kanghua\go\pkg\mod
   go env GOMODCACHE
   
   # 查看GOPATH
   go env GOPATH
   ```
- 自动下载代码里用到的第三方包，更新 `go.mod`，同时生成 `go.sum`（依赖校验文件，类似锁文件）
- 之后再 `go run main.go` 就能正常运行了

---

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


