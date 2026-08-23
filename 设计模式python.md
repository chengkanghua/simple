# 设计模式(Python 版)

> **大纲参考**:Alex Li《设计模式.pptx》(43 页)
> **配套代码**:`设计模式/设计模式/` 目录,每节末尾标注「完整代码」文件。
> **学习主语言**:Python。先懂"解决什么问题、怎么类比",再跑完整代码。

---

## 一、设计模式是什么

**一句话**:软件设计中**反复出现的问题**的成熟**解决方案**——前人踩坑总结出的"标准答案"。

**来源**:GoF 四人帮(Erich Gamma 等四人)著《设计模式:可复用面向对象软件的基础》,共 **23 种**。

**前提**:面向对象编程(OOP)。Python 天然支持,模式大多建立在"抽象类/接口 + 继承/组合"之上。

### 1.1 面向对象三大特性

| 特性 | 一句话 | 生活类比 |
|---|---|---|
| 封装 | 把数据和操作捆在一起,对外只暴露方法 | 遥控器:里面一堆电路,你只按按钮 |
| 继承 | 子类复用父类的代码,可扩展可重写 | 孩子继承父母的基因,还能有自己的特点 |
| 多态 | 同一个方法调用,不同对象行为不同 | 都喊"叫",狗"汪汪"、猫"喵喵" |

### 1.2 接口(Interface)

**一句话**:接口是**若干抽象方法的集合**——只规定"必须有什么方法",不写实现。
**作用**:限制实现类必须按接口的方法来写;对调用方隐藏内部实现。

Python 用 `abc` 模块实现抽象类/接口:

```python
from abc import ABCMeta, abstractmethod

class Payment(metaclass=ABCMeta):        # 接口:规定"必须能 pay"
    @abstractmethod
    def pay(self, money):
        pass

class Alipay(Payment):                   # 实现接口
    def pay(self, money):
        print(f"支付宝支付 {money} 元")

print(Alipay().pay(100))                 # 支付宝支付 100 元
```

**完整代码**:`设计模式/设计模式/interface.py`

### 1.3 SOLID 设计原则(背下来,面试高频)

| 原则 | 一句话 |
|---|---|
| **S** 单一职责 | 一个类只干一件事,别让一个类有多个变更原因 |
| **O** 开放封闭 | 对**扩展**开放,对**修改**关闭(加功能别改旧代码) |
| **L** 里氏替换 | 子类必须能**替换**父类而不出问题 |
| **I** 接口隔离 | 用多个**专门的小接口**,别用一个大而全的接口 |
| **D** 依赖倒置 | **面向接口编程**,不面向具体实现编程 |

> 后面的设计模式,几乎都是为了实现这五条原则而生的。

---

## 二、23 种设计模式分类

| 类型 | 数量 | 成员 | 本文讲解 |
|---|---|---|---|
| **创建型**(怎么造对象) | 5 | 工厂方法、抽象工厂、建造者(创建者)、原型、单例 | 5 种 |
| **结构型**(怎么组装类) | 7 | 适配器、桥、组合、装饰、外观、享元、代理 | 5 种 |
| **行为型**(怎么安排协作) | 11 | 解释器、责任链、命令、迭代器、中介者、备忘录、观察者、状态、策略、访问者、模板方法 | 4 种 |

> 每种模式格式:**一句话本质 → 生活类比 → 精简核心代码 → 完整代码文件**。

---

## 三、创建型模式:怎么"造对象"

> 共同目标:让"创建对象"这件事灵活、解耦,不用到处 `new`。

### 3.1 简单工厂(Simple Factory)

**一句话**:一个工厂类根据参数,决定创建哪个产品。
**类比**:奶茶店前台——你说"珍珠奶茶",她做好递给你,你不用关心怎么做。

```python
class Payment:
    def pay(self, money): pass

class Alipay(Payment):
    def pay(self, money):
        print(f"支付宝支付 {money} 元")

class WechatPay(Payment):
    def pay(self, money):
        print(f"微信支付 {money} 元")

class PayFactory:                        # 工厂:集中创建逻辑
    @staticmethod
    def create_pay(way):
        if way == "alipay":
            return Alipay()
        elif way == "wechat":
            return WechatPay()
        raise ValueError("不支持的支付方式")

PayFactory.create_pay("alipay").pay(100)   # 支付宝支付 100 元
```

**优点**:隐藏创建细节,客户端不用改。
**缺点**:加新产品要改工厂类 → 违反**开闭原则**。
**完整代码**:`设计模式/设计模式/factory.py`

### 3.2 工厂方法(Factory Method)

**一句话**:把"创建对象"的动作交给**子类**——每个产品配一个工厂,加产品不用改旧代码。
**类比**:连锁店各自开店——想开奶茶店就开奶茶分店,想开咖啡店就开咖啡分店,总店不用改。

```python
# 产品与 3.1 相同:Payment / Alipay / WechatPay(为独立运行重复一遍)
class Payment:
    def pay(self, money): pass

class Alipay(Payment):
    def pay(self, money):
        print(f"支付宝支付 {money} 元")

class WechatPay(Payment):
    def pay(self, money):
        print(f"微信支付 {money} 元")

class PayFactory:                        # 抽象工厂(只定规矩)
    def create_pay(self): pass

class AlipayFactory(PayFactory):         # 具体工厂:一个产品配一个
    def create_pay(self):
        return Alipay()

class WechatFactory(PayFactory):
    def create_pay(self):
        return WechatPay()

AlipayFactory().create_pay().pay(100)    # 支付宝支付 100 元
```

**优点**:加新产品 → 加新工厂,**不改旧代码**(符合开闭原则)。
**缺点**:产品多时工厂类也跟着多。
**完整代码**:`设计模式/设计模式/factory_method.py`

### 3.3 抽象工厂(Abstract Factory)

**一句话**:工厂方法造"一个产品",抽象工厂造"**一套相关产品**"。
**类比**:苹果/华为是两家工厂,每家的**手机壳 + CPU + 系统**是一整套,不能混搭。

```python
# 抽象产品:手机壳 / CPU / 操作系统
class PhoneShell:
    def show(self): pass
class CPU:
    def show(self): pass
class OS:
    def show(self): pass

class PhoneFactory:                      # 抽象工厂:规定"必须能造一套"
    def make_shell(self): pass
    def make_cpu(self): pass
    def make_os(self): pass

class AppleFactory(PhoneFactory):        # 苹果这一套
    def make_shell(self):
        return PhoneShell()
    def make_cpu(self):
        return CPU()
    def make_os(self):
        return OS()

f = AppleFactory()                       # 一套苹果手机配件齐活
f.make_cpu().show()
```

**优点**:保证一套产品风格一致、易于整套替换。
**缺点**:想加一种新"产品维度"(比如加个摄像头)很难,要动所有工厂。
**完整代码**:`设计模式/设计模式/abstract_factory.py`

### 3.4 建造者模式(Builder)

**一句话**:一个复杂对象有很多部件,**一步步**按固定流程组装,同样的流程能造出不同样式。
**类比**:订餐——主食、配菜、饮料一步步配;流程一样,配出来的套餐可以不同。

```python
class Player:                            # 产品:角色(脸/身体/手臂/腿)
    def __init__(self):
        self.face = self.body = self.arm = self.leg = None
    def __str__(self):
        return f"脸:{self.face} 身体:{self.body}"

class PlayerBuilder:                     # 抽象建造者:规定要造哪些部件
    def __init__(self):
        self.player = Player()
    def build_face(self): pass
    def build_body(self): pass

class NormalBuilder(PlayerBuilder):      # 具体建造者:普通角色
    def build_face(self):
        self.player.face = "标准脸"
    def build_body(self):
        self.player.body = "标准身材"

class Director:                          # 指挥者:控制构建顺序(先脸后身体)
    def __init__(self, builder):
        self.builder = builder
    def build_player(self):
        self.builder.build_face()
        self.builder.build_body()
        return self.builder.player

p = Director(NormalBuilder()).build_player()
print(p)                                 # 脸:标准脸 身体:标准身材
```

**对比**:抽象工厂造"一套产品",建造者专注"一个复杂对象的装配过程"。
**完整代码**:`设计模式/设计模式/builder.py`

### 3.5 单例模式(Singleton)

**一句话**:保证一个类**只有一个实例**,全局共用。
**类比**:一个国家只有一个总统;公司的打印机只有一台,大家共用。

Python 用 `__new__` 实现:

```python
class Singleton:
    def __new__(cls, *args, **kwargs):
        if not hasattr(cls, "_instance"):    # 还没有实例才创建
            cls._instance = super().__new__(cls)
        return cls._instance                 # 以后每次都返回同一个

a = Singleton()
b = Singleton()
print(a is b)       # True —— 是同一个对象
```

**完整代码**:`设计模式/设计模式/singleton.py`

### 创建型小结

> 课件原话:抽象工厂、建造者比简单工厂、工厂方法更灵活也更复杂。**通常从简单工厂/工厂方法开始**,发现不够灵活时再演化为更复杂的模式。

---

## 四、结构型模式:怎么"组装类"

> 共同目标:通过继承或组合,让类与类组合出更强大的能力。

### 4.1 适配器模式(Adapter)

**一句话**:把**接口不兼容**的老类,包一层"翻译",让它能按新接口工作。
**类比**:充电器转接头——苹果充电头插不上安卓口,套个转接头就能用。

两种实现:
- **类适配器**:用多继承(继承新接口 + 继承老类);
- **对象适配器**:用组合(持有老类对象,内部调用)——更常用。

```python
class Payment:                           # 目标接口:都要能 pay
    def pay(self, money): pass

class BankPay:                           # 待适配的老类:方法叫 cost
    def cost(self, money):
        print(f"银联支付 {money} 元")

class PaymentAdapter(Payment):           # 对象适配器:把 cost 翻译成 pay
    def __init__(self, payment):
        self.payment = payment
    def pay(self, money):
        self.payment.cost(money)

PaymentAdapter(BankPay()).pay(100)       # 银联支付 100 元
```

**完整代码**:`设计模式/设计模式/adapter.py`

### 4.2 桥模式(Bridge)

**一句话**:把事物的**两个维度**分离,各自独立扩展。
**类比**:图形(形状 × 颜色)两个维度——形状类管"画什么",颜色类管"涂什么色",组合出 长方形+红色、圆形+蓝色……互不干扰。

```python
class Shape:                             # 维度一:形状
    def __init__(self, color):
        self.color = color               # 持有颜色对象(桥)
    def draw(self): pass

class Color:                             # 维度二:颜色
    def paint(self, shape): pass

class Rectangle(Shape):                  # 具体形状
    def draw(self):
        self.color.paint(self)           # 画的时候交给颜色

class Red(Color):                        # 具体颜色
    def paint(self, shape):
        print(f"红色{shape}")

Rectangle(Red()).draw()                  # 红色长方形
```

**完整代码**:`设计模式/设计模式/bridge.py`

### 4.3 组合模式(Composite)

**一句话**:把对象组成**树形结构**,让"单个对象"和"组合对象"用起来**完全一致**。
**类比**:文件夹里能放文件,也能再放文件夹——不管点开谁,操作都一样(双击打开)。

```python
class Graphic:                           # 抽象组件
    def draw(self): pass

class Point(Graphic):                    # 叶子组件:最小的单元
    def __init__(self, x, y):
        self.x, self.y = x, y
    def draw(self):
        print(f"点({self.x},{self.y})")

class Picture(Graphic):                  # 复合组件:里面可以再装组件
    def __init__(self):
        self.children = []
    def add(self, g):
        self.children.append(g)
    def draw(self):                      # 画自己 = 画所有子组件
        for g in self.children:
            g.draw()

pic = Picture()
pic.add(Point(1, 2))
pic.add(Point(3, 4))
pic.draw()                                # 点(1,2) 点(3,4) —— 和单个用一样
```

**完整代码**:`设计模式/设计模式/composite.py`

### 4.4 外观模式(Facade)

**一句话**:把一堆子系统藏在一个"门面"后面,给外部一个**简单入口**。
**类比**:电脑开机——你不用自己分别给 CPU、硬盘、内存通电,按一下电源键就行。

```python
class CPU:
    def run(self):
        print("CPU 开始运行")
class Disk:
    def run(self):
        print("硬盘开始工作")

class Computer:                          # 外观:统一入口
    def __init__(self):
        self.cpu = CPU()
        self.disk = Disk()
    def start(self):                     # 用户只调这一个
        self.cpu.run()
        self.disk.run()

Computer().start()
# CPU 开始运行
# 硬盘开始工作
```

**完整代码**:`设计模式/设计模式/facade.py`

### 4.5 代理模式(Proxy)

**一句话**:给真实对象加一个"替身",通过替身控制访问——可以**延迟加载、加权限、加日志**。
**类比**:明星的经纪人——找明星要先通过经纪人,经纪人挡掉骚扰、安排档期。

```python
class RealSubject:                       # 真实对象:读文件(很"重")
    def __init__(self):
        self.content = "文件内容(很大)"
    def get_content(self):
        return self.content

class Proxy:                             # 代理
    def __init__(self):
        self.real = None
    def get_content(self):
        if self.real is None:            # 虚代理:真正要用时才创建
            self.real = RealSubject()
        return self.real.get_content()

p = Proxy()
print(p.get_content())                   # 文件内容(很大)
```

**三类代理**:远程代理(远程对象)、虚代理(需要时再建)、保护代理(控制访问权限)。
**完整代码**:`设计模式/设计模式/proxy.py`

---

## 五、行为型模式:怎么"安排对象协作"

> 共同目标:让对象之间如何通信、如何分工更灵活。

### 5.1 责任链模式(Chain of Responsibility)

**一句话**:把处理请求的对象连成一条链,请求**沿链传递**,谁有能力谁处理。
**类比**:请假审批——先找组长,组长权限不够就上报经理,再上报老板,总有人拍板。

```python
class Handler:                           # 抽象处理者
    def __init__(self):
        self.next = None
    def set_next(self, h):
        self.next = h
    def handle(self, day): pass

class Manager(Handler):                  # 组长:3 天以内
    def handle(self, day):
        if day <= 3:
            print(f"组长批准 {day} 天假")
        else:
            self.next.handle(day)        # 超出权限,传给下一位

class Boss(Handler):                     # 老板:兜底
    def handle(self, day):
        print(f"老板批准 {day} 天假")

manager, boss = Manager(), Boss()
manager.set_next(boss)                   # 组长的下一环是老板
manager.handle(2)                        # 组长批准 2 天假
manager.handle(10)                       # 老板批准 10 天假
```

**优点**:发送者不知道谁会处理,降低耦合。
**完整代码**:`设计模式/设计模式/chain_of_responsibility.py`

### 5.2 观察者模式(Observer,发布-订阅)

**一句话**:一个对象(发布者)状态变了,**自动通知**所有依赖它的对象(订阅者)。
**类比**:公众号——你关注它(订阅),它一发文章,所有粉丝自动收到,不用你一个个去问。

```python
class Observer:                          # 抽象订阅者
    def update(self, msg): pass

class Notice:                            # 发布者(主题)
    def __init__(self):
        self.observers = []
    def attach(self, obs):               # 关注
        self.observers.append(obs)
    def notify(self, msg):               # 群发
        for obs in self.observers:
            obs.update(msg)

class Staff(Observer):                   # 员工订阅者
    def update(self, msg):
        print(f"收到通知:{msg}")

notice = Notice()
notice.attach(Staff())                   # 订阅
notice.notify("明天放假!")               # 发布 → 自动通知
# 收到通知:明天放假!
```

**完整代码**:`设计模式/设计模式/observer.py`

### 5.3 策略模式(Strategy)

**一句话**:把一组可以互相替换的算法**封装成对象**,运行时想换就换。
**类比**:出行去机场——打车/地铁/骑车都能到,策略不同,结果一样,随时换方案。

```python
class Strategy:                          # 抽象策略
    def execute(self, data): pass

class FastStrategy(Strategy):            # 策略 A:快速
    def execute(self, data):
        print(f"用快速策略处理:{data}")

class SlowStrategy(Strategy):            # 策略 B:慢速
    def execute(self, data):
        print(f"用慢速策略处理:{data}")

class Context:                           # 上下文:持有策略,负责执行
    def __init__(self, strategy):
        self.strategy = strategy
    def run(self, data):
        self.strategy.execute(data)

Context(FastStrategy()).run("数据")      # 用快速策略处理:数据
Context(SlowStrategy()).run("数据")      # 换策略 = 换个对象
```

**优点**:消除大量 if-else,算法可复用、可替换。
**完整代码**:`设计模式/设计模式/strategy.py`

### 5.4 模板方法模式(Template Method)

**一句话**:父类定好**算法骨架**(流程),把某些步骤留空,让子类去填细节。
**类比**:做菜流程都是"备菜→炒→出锅",但具体炒什么菜,各家自己定。

```python
class Window:                            # 抽象类
    def run(self):                       # 模板方法:固定流程,不可变
        self.start()
        self.repaint()
        self.stop()
    def start(self): pass                # 原子操作(钩子):留给子类
    def repaint(self): pass
    def stop(self): pass

class GameWindow(Window):                # 具体类:填细节
    def start(self):
        print("游戏窗口启动")
    def repaint(self):
        print("画面重绘")
    def stop(self):
        print("关闭游戏窗口")

GameWindow().run()
# 游戏窗口启动
# 画面重绘
# 关闭游戏窗口
```

**完整代码**:`设计模式/设计模式/template_method.py`

---

## 六、小结:怎么选模式

| 场景 | 用哪个 |
|---|---|
| 想集中管理"创建谁" | 简单工厂 → 不够灵活升级为工厂方法 |
| 要造"一套相关产品" | 抽象工厂 |
| 复杂对象要一步步组装 | 建造者 |
| 全局只要一个实例 | 单例 |
| 老接口不兼容 | 适配器 |
| 两个维度各自扩展 | 桥 |
| 树形部分-整体结构 | 组合 |
| 想给子系统一个简单入口 | 外观 |
| 想控制对真实对象的访问 | 代理 |
| 多级审批、谁有能力谁处理 | 责任链 |
| 一变则全部通知 | 观察者 |
| 算法可替换、去 if-else | 策略 |
| 流程固定、细节子类定 | 模板方法 |

> **学习建议**:不用背代码,背"**这个模式解决什么问题**"。面试问起,先讲场景→再讲角色→最后画两行代码。

---

## 附录:模式 → 代码文件速查表

代码都在 `设计模式/设计模式/` 目录:

| 模式 | 代码文件 |
|---|---|
| 接口示例 | `设计模式/设计模式/interface.py` |
| 简单工厂 | `设计模式/设计模式/factory.py` |
| 工厂方法 | `设计模式/设计模式/factory_method.py` |
| 抽象工厂 | `设计模式/设计模式/abstract_factory.py` |
| 建造者 | `设计模式/设计模式/builder.py` |
| 单例 | `设计模式/设计模式/singleton.py` |
| 适配器 | `设计模式/设计模式/adapter.py` |
| 桥 | `设计模式/设计模式/bridge.py` |
| 组合 | `设计模式/设计模式/composite.py` |
| 外观 | `设计模式/设计模式/facade.py` |
| 代理 | `设计模式/设计模式/proxy.py` |
| 责任链 | `设计模式/设计模式/chain_of_responsibility.py` |
| 观察者 | `设计模式/设计模式/observer.py` |
| 策略 | `设计模式/设计模式/strategy.py` |
| 模板方法 | `设计模式/设计模式/template_method.py` |
