## 一、核心基础概念（先搞懂原理，命令才不会记混）

Git 是分布式版本控制系统，核心分为 4 个工作区域，所有命令都是在这几个区域之间流转文件：

1. **工作区**：你电脑上本地编辑修改的代码文件
2. **暂存区（Index/Stage）**：临时存放即将提交的改动，相当于提交前的确认区
3. **本地仓库**：存在你本地的所有版本历史记录，离线也能查看
4. **远程仓库**：GitLab/GitHub/Gitee 等服务器上的公共仓库，团队协作的核心

标准提交流程：工作区修改代码 → `git add` 存入暂存区 → `git commit` 提交到本地仓库 → `git push` 推送到远程仓库

# Git 分布式含义

**1、什么是分布式？**

Git 没有中心服务器，**每个人本地都有一份完整的代码仓库 + 所有版本历史**。

**2、体现在哪里（3 点背完满分）**

1. **可离线操作**：断网也能 commit、建分支、回退、看日志，不用依赖服务器。
2. **全量备份**：所有人本地都是完整仓库，服务器挂了也不会丢版本。
3. **本地高效**：分支、合并、回退全在本地运行，速度快、不依赖远程。

**一句话终极背诵**

Git 是分布式版本控制，**本地拥有完整仓库，不依赖中心服务器，支持离线开发、容错性强**

## 二、企业高频常用命令（按场景分类，可直接套用）

### 1. 初始化与基础配置



```
# 本地文件夹初始化一个全新Git仓库
git init

# 克隆远程仓库到本地（最常用，直接拉取已有项目）
git clone shturl.cc/4yWaFcJbxDUK5RanMNF0SvDDLsc

# 配置全局用户名和邮箱（第一次安装Git必做）
git config --global user.name "你的名字"
git config --global user.email "你的公司邮箱"

# 查看当前所有配置
git config --list
```

### 2. 代码提交（工作区 → 暂存区 → 本地仓库）

```
# 查看当前文件状态（修改、新增、删除了哪些文件，日常高频使用）
git status

# 添加单个文件到暂存区
git add 文件名

# 添加所有修改文件到暂存区（日常提交最常用）
git add .

# 提交暂存区内容到本地仓库，必须附带提交说明
git commit -m "提交说明：修复登录接口空指针异常"

# 追加提交（修改上一次提交信息/补文件，还没push到远程时用）
git commit --amend -m "新的提交说明"
```

### 3. 远程仓库交互

```
# 查看当前绑定的远程仓库地址
git remote -v

# 本地init的仓库，第一次绑定远程仓库时使用
git remote add origin 远程仓库地址

# 推送本地分支代码到远程仓库
git push origin 分支名

# 拉取远程代码并自动合并到当前分支（日常更新代码用）
git pull origin 分支名

# 只拉取远程最新代码，不自动合并（更安全，手动确认后再合并）
git fetch origin
```

### 4. 分支管理（团队协作核心）



```
# 查看所有本地分支
git branch

# 查看所有远程分支
git branch -r

# 查看所有本地+远程分支
git branch -a

# 创建新分支
git branch 新分支名

# 切换到指定分支
git checkout 分支名

# 创建并切换到新分支（最常用，二合一命令）
git checkout -b 新分支名

# 把指定分支的代码合并到当前分支
git merge 目标分支名

# 删除本地分支（功能上线后清理冗余分支）
git branch -d 分支名

# 删除远程分支
git push origin --delete 远程分支名
```

### 5. 版本查看与回退

```
# 查看完整提交历史（带提交哈希、作者、时间、说明）
git log

# 精简版提交历史（一行显示一条，日常排查首选）
git log --oneline

# 查看指定文件的每一行修改历史
git blame 文件名

# 撤销工作区的修改（还没add的文件，恢复成上次提交的状态）
git checkout -- 文件名

# 撤回暂存区的文件（已经add了，撤回到工作区，修改内容保留）
git reset HEAD 文件名

# 软回退到指定版本（仅撤销commit，代码修改还保留在暂存区）
git reset --soft 提交哈希值

# 强制回退（丢弃所有修改，仅本地私有分支慎用）
git reset --hard 提交哈希值

# 反向提交（企业远程分支回退首选，不修改历史，生成新的撤销提交）
git revert 提交哈希值
```

### 6. 标签管理（版本发布标记用）

```
# 创建轻量版本标签
git tag v1.0.0

# 创建带说明的正式标签
git tag -a v1.0.0 -m "正式发布1.0.0版本"

# 推送单个标签到远程
git push origin v1.0.0

# 查看所有标签
git tag
```

## 三、企业主流 Git 管理工作流

### 1. GitFlow 工作流（传统项目、固定版本发布周期首选）

适合政企、传统软件、客户端这类有明确版本规划、上线周期长的项目。

核心分支结构：

- **master/main**：主分支，仅存放正式发布的稳定代码，禁止直接提交
- **develop**：开发主分支，所有功能分支都从这里拉取，集成最新开发代码
- **feature/xxx**：功能分支，从 develop 拉取，开发完成后合并回 develop
- **release/xxx**：发布分支，版本上线前从 develop 拉取，专门做测试、修 bug，上线后同时合并到 master 和 develop
- **hotfix/xxx**：热修复分支，线上出紧急 bug 时从 master 拉取，修复完合并回 master 和 develop

特点：规范严谨、版本清晰，但流程偏长，不适合快速迭代。

### 2. GitLab Flow / GitHub Flow（互联网、持续交付主流）

目前绝大多数互联网企业、DevOps 团队的首选，完美适配 CI/CD 流水线。

核心规则：

- **main/master** 是唯一稳定主分支，代码永远可直接部署
- 所有开发都从 main 拉取 `feature/xxx` 功能分支独立开发
- 开发完成后提交 **Merge Request(MR)/Pull Request(PR)**，走代码评审
- 评审通过、且通过 Sonar 扫描、自动化测试等 CI 门禁后，合并到 main
- 合并后自动触发 Jenkins 流水线构建部署；线上 bug 同理拉 hotfix 分支修复

特点：流程简单、迭代速度快，和你当前的 GitLab+Jenkins 体系天然适配。







## 四、企业通用协作规范（团队必守规则）

### 1. 分支命名规范

```
功能分支：feature/模块名-功能描述
示例：feature/user-login-page

bug修复分支：fix/问题描述
示例：fix/token-expire-bug

热修复分支：hotfix/线上bug描述
示例：hotfix/pay-order-crash

发布分支：release/版本号
示例：release/v1.2.0
```

### 2. 提交信息规范（通用 Conventional Commits 标准）

格式：`类型: 提交说明`

常用类型：

- `feat:` 新增业务功能
- `fix:` 修复代码 bug
- `docs:` 文档、注释修改
- `style:` 代码格式调整，不影响业务逻辑
- `refactor:` 代码重构，不加功能也不修 bug
- `perf:` 性能优化
- `test:` 单元测试、自动化用例修改
- `chore:` 构建工具、依赖配置、流水线修改

示例：`feat: 新增用户列表分页查询接口`

### 3. 企业级管控规则

1. **保护主分支**：master/main、develop 禁止直接 push，必须通过 MR/PR 合并
2. **代码评审（Code Review）**：MR 必须至少 1 人审核通过才能合并
3. **CI 门禁卡点**：合并前必须通过编译、Sonar 扫描、自动化测试，不通过禁止合并
4. **分支及时清理**：功能上线后删除对应 feature 分支，避免仓库冗余

## 五、进阶高频操作（日常排障必用）

### 1. 暂存工作进度（git stash）

代码写到一半，需要临时切换分支修 bug，又不想提交半成品代码：

```
# 暂存当前工作区所有修改
git stash

# 查看所有暂存记录
git stash list

# 恢复最近一次暂存的内容，并删除该暂存记录
git stash pop

# 清空所有暂存
git stash clear
```

### 2. 拣选提交（git cherry-pick）

只把某一个提交的改动复制到当前分支，不用合并整个分支：

```
git cherry-pick 提交哈希值
```

典型场景：hotfix 修复了线上 bug，只把这一条修复同步到 develop 分支，不用合并整个 hotfix 分支。

### 3. 代码冲突处理

出现场景：两个人修改了同一个文件的同一行代码，合并 / 拉取时就会触发冲突。

处理步骤：

1. 打开冲突文件，找到 `<<<<<<<` `=======` `>>>>>>>` 标记的冲突区域
2. 保留最终需要的代码，删除冲突标记和多余内容
3. 执行 `git add 冲突文件` 标记为已解决
4. 执行 `git commit` 完成合并

### 4. 变基（git rebase）

把当前分支的提交 “平移” 到目标分支的最新提交后面，让提交历史变成一条直线，更整洁。

```
# 把当前分支变基到目标分支
git rebase 目标分支名
```

注意事项：

- 仅在本地私有分支使用，**绝对不要对已经推送到远程的公共分支做 rebase**，会修改历史导致其他人代码冲突
- 和 `git merge` 区别：merge 生成合并节点，历史完整；rebase 历史线性整洁

### 5. .gitignore 忽略文件

项目根目录创建 `.gitignore` 文件，指定不需要 Git 管理的文件，企业项目必配：

```
# Java项目示例
target/
*.class
*.jar
*.log

# IDE配置文件
.idea/
.vscode/

# 环境变量、敏感配置
.env
```

需要我补充某个具体场景的操作步骤，或者整理一份可直接保存的 Git 命令速查精简版吗？



# git命令大全

```bash
# ====================== 一、Git 基础配置与仓库初始化 ======================
# 查看git版本
git --version

# 配置全局用户名（所有仓库生效）
git config --global user.name "你的姓名"
# 配置全局邮箱
git config --global user.email "你的企业邮箱@shturl."

# 查看所有git配置信息
git config --list

# 在当前目录初始化git仓库，生成隐藏.git文件夹
git init

# 克隆远程仓库到本地
git clone https://gitlab.shturl./xxx/demo.git


# ====================== 二、工作区、暂存区、本地仓库提交操作 ======================
# 查看当前文件状态（新增、修改、未追踪文件）
git status

# 将单个文件添加到暂存区
git add demo.java
# 将当前目录所有修改文件添加到暂存区
git add .
# 将指定文件夹下所有文件加入暂存区
git add src/

# 查看工作区未提交到暂存区的代码差异
git diff
# 查看暂存区与本地仓库最新版本的差异
git diff --cached

# 将暂存区内容提交到本地仓库，必须写提交备注
git commit -m "fix:修复登录空指针异常"

# 追加提交：修改上一次提交信息/补充遗漏文件（未push远程时可用）
git commit --amend -m "feat:新增用户分页接口"

# 删除文件并加入暂存区
git rm test.txt
# 仅把文件从暂存区移除，本地文件保留
git rm --cached test.txt

# ====================== 三、远程仓库相关操作 ======================
# 查看绑定的远程仓库地址
git remote -v

# 本地初始化仓库后绑定远程仓库
git remote add origin https://gitlab.shturl./xxx/demo.git

# 将本地分支推送到远程仓库
git push origin main

# 拉取远程所有分支版本信息，不自动合并代码（安全更新方式）
git fetch origin

# 拉取远程代码并自动合并到当前本地分支（日常更新代码最常用）
git pull origin main

# ====================== 四、分支管理（团队协作核心） ======================
# 查看本地所有分支
git branch
# 查看远程所有分支
git branch -r
# 查看本地+远程全部分支
git branch -a

# 创建新分支
git branch feature/user-login

# 切换到指定分支
git checkout main
# 创建并切换到新分支（最常用）
git checkout -b feature/user-login

# 撤销工作区单个文件未add的修改，恢复到最近一次提交状态
git checkout -- demo.java

# 将指定分支合并到当前所在分支
git merge feature/user-login

# 分支变基，整理提交历史为线性（仅个人私有分支使用）
git rebase main

# 删除本地已合并安全分支
git branch -d feature/user-login
# 强制删除本地未合并分支
git branch -D feature/user-login

# 删除远程分支
git push origin --delete feature/user-login


# ====================== 五、提交日志查看、版本回退操作 ======================
# 查看详细提交日志
git log
# 精简一行式查看提交日志（日常排查首选）
git log --oneline
# 查看每次提交详细代码变更
git log -p

# 查看某次提交的详细代码修改内容
git show 提交哈希值

# 软回退：仅撤销commit，代码保留在暂存区
git reset --soft 提交哈希值
# 硬回退：丢弃本地所有修改，直接回到指定版本（私有分支慎用）
git reset --hard 提交哈希值
# 将指定文件从暂存区退回工作区
git reset HEAD demo.java

# 反向提交回滚（公共远程分支安全回退方式，生成新提交不删除历史）
git revert 提交哈希值


# ====================== 六、Stash 工作区临时储藏（临时切分支用） ======================
# 储藏当前所有未提交的修改
git stash
# 查看所有储藏记录
git stash list
# 恢复最近一次储藏并删除该条储藏记录
git stash pop
# 清空所有储藏记录
git stash clear

# ====================== 七、标签管理（版本发布打标记） ======================
# 查看所有标签
git tag
# 创建轻量标签
git tag v1.0.0
# 创建带说明的正式标签
git tag -a v1.0.0 -m "线上正式v1.0.0版本发布"
# 将单个标签推送到远程仓库
git push origin v1.0.0

# ====================== 八、企业高频进阶命令 ======================
# 二分查找定位引入bug的那次提交
git bisect

# 在全仓库中全局搜索指定字符串
git grep "需要搜索的关键字"

# 文件移动/重命名操作，git会记录版本变更
git mv old.txt new.txt

# 拣选提交：将某一次提交单独复制合并到当前分支
git cherry-pick 提交哈希值
```



# Git 一页纸精简速查表

```bash
一、基础配置 & 仓库初始化
# 配置用户名邮箱（首次必配）
git config --global user.name "姓名"
git config --global user.email "企业邮箱"
git config --list               # 查看配置

git init                        # 本地初始化仓库
git clone 远程地址              # 拉取远程仓库代码

二、提交流程（工作区→暂存区→本地库→远程库）
git status                      # 查看文件状态
git add .                       # 所有修改加入暂存区
git commit -m "feat:新增功能"   # 提交本地仓库
git commit --amend              # 追加提交，修改上次提交备注

git diff                        # 查看未add的改动
git diff --cached               # 查看暂存区改动
git rm --cached 文件名          # 文件移出暂存区，本地保留

三、远程仓库操作
git remote -v                               # 查看远程仓库
git remote add origin 远程地址               # 绑定远程仓库
git push origin 分支名                       # 推送本地分支到远程
git fetch origin                            # 拉取远程信息，不自动合并
git pull origin 分支名                      # 拉取+自动合并代码

四、分支管理（面试高频）
git branch                  # 查看本地分支
git branch -r               # 查看远程分支
git branch -a               # 查看所有分支

git checkout -b 分支名      # 创建+切换新分支（最常用）
git checkout 分支名         # 切换已有分支
git checkout -- 文件名      # 撤销工作区未提交修改

git merge 分支名            # 合并分支到当前分支
git rebase 目标分支         # 变基，整理线性提交历史（仅私有分支）

git branch -d 分支名        # 删除本地已合并分支
git push origin --delete 分支名 # 删除远程分支

五、日志查看 & 版本回退
git log --oneline           # 精简查看提交日志
git show 哈希值             # 查看单次提交详情

# 三种回退
git reset --soft 哈希值     # 软回退：保留代码到暂存区
git reset --hard 哈希值     # 硬回退：彻底丢弃本地修改（私有分支）
git revert 哈希值           # 反向提交回滚（公共分支安全回退，不删历史）

六、临时储藏（stash）
git stash                   # 暂存当前未提交修改
git stash list              # 查看所有储藏记录
git stash pop               # 恢复最新储藏并删除记录
git stash clear             # 清空所有储藏

七、标签（版本发布）
git tag                             # 查看标签
git tag -a v1.0.0 -m "版本说明"     # 创建带备注标签
git push origin v1.0.0              # 推送标签到远程

八、高频进阶命令
git cherry-pick 哈希值      # 拣选单个提交合并到当前分支
git bisect                 # 二分查找定位bug提交节点
git grep "关键字"           # 仓库全局搜索内容
git mv 旧名 新名           # 文件重命名

九、面试必背 3 个高频场景
冲突解决：打开冲突文件删除<<<<<<<标记→git add→git commit
MR/PR：GitLab 叫 Merge Request，GitHub 叫 Pull Request，用于代码评审、CI 门禁校验后合并代码
规范分支命名：feature / 功能、fix / 普通 bug、hotfix / 线上紧急 bug
```









# 企业主流 Git 管理方式（落地实用版）

企业里的 Git 管理 = **分支工作流（协作模式） + 管控规则（权限 / 门禁 / 规范）**，不是单纯选一套流程就完事，而是结合团队规模、迭代速度、项目性质落地。下面按普及度从高到低介绍，以及配套的通用管控手段。

## 一、3 种主流企业 Git 工作流

### 1. GitLab Flow / GitHub Flow（互联网最通用，轻量主干流）

这是目前国内互联网、SaaS、微服务团队的**首选方案**，也是和你当前 GitLab + Jenkins CI/CD 体系最适配的模式，流程极简、天然支持持续交付。

#### 核心逻辑

只有**1 条常驻主干分支**，所有开发都基于主干拉临时分支，开发完通过合并请求（MR/PR）评审 + CI 校验后合入主干，合入即触发部署。

#### 分支结构

- **常驻分支（1 条）**：`main` / `master`，唯一可信主干，代码永远可部署，禁止直接提交

- 临时分支

  ：从主干拉取，用完即删

  - `feature/xxx`：功能开发分支
  - `fix/xxx`：普通 bug 修复分支
  - `hotfix/xxx`：线上紧急 bug 修复分支

#### 标准工作流程

1. 从 `main` 拉取 `feature/xxx` 分支开发
2. 本地提交后推送到远程，提交 MR（合并请求）
3. 自动触发 Jenkins 流水线：编译 → Sonar 扫描 → 单元测试（CI 门禁不通过直接禁止合并）
4. 至少 1 位同事 Code Review 评审通过
5. 合入 `main` 分支，自动触发测试环境部署、RF 自动化验收
6. 确认上线后删除 `feature/xxx` 分支
7. 线上紧急 bug：从 `main` 拉 `hotfix/xxx`，修复后同样走 MR 合入主干，快速发布

#### 适用场景

互联网团队、快速迭代项目、微服务、DevOps 成熟度高的团队，绝大多数中小研发团队都用这个。

- 优点：流程短、上手快、冲突少、完美适配 CI/CD 流水线
- 缺点：多历史版本并行维护时不太方便

------

### 2. GitFlow 工作流（经典版本流，传统 / 项目制常用）

最经典的标准化分支流程，适合有明确版本规划、发布周期长、需要同时维护多版本的项目，政企、外包、传统软件、客户端产品用得很多。

#### 核心逻辑

**2 条常驻主分支 + 3 类临时分支**，职责边界清晰，版本追溯严格，每个阶段都有明确的分支对应。

#### 分支结构

- 常驻分支（长期存在，不删除）
  - `master` / `main`：仅存放正式发布的稳定代码，每一次合入都对应一个线上版本，打 tag
  - `develop`：开发集成主分支，所有功能都先合到这里，集成测试通过后才能合入 master
- 临时分支（用完即删）
  - `feature/xxx`：从`develop`拉取，开发完成合并回`develop`
  - `release/x.x.x`：版本发布分支，从`develop`拉取，专门做上线前测试、修小 bug，上线后同时合并到`master`和`develop`，并在 master 打版本 tag
  - `hotfix/xxx`：线上紧急修复，从`master`拉取，修复完同时合并回`master`和`develop`

#### 适用场景

项目制交付、传统软件、金融政企、有明确版本周期、需要同时维护多个线上版本的团队。

- 优点：规范极其严谨，版本责任清晰，适合严格的流程管控
- 缺点：流程长、分支多，迭代速度慢，不适合高频快速迭代

------

### 3. Trunk-Based Development（主干开发，大厂高频交付用）

谷歌、字节等大型互联网大厂的主流模式，是持续部署、每日多版本发布的核心玩法，对团队工程能力要求极高。

#### 核心逻辑

**几乎没有长期功能分支**，所有开发者都直接向主干（trunk）提交代码，小步快跑、每天多次合入；未完成的功能用「特性开关（Feature Flag）」隐藏，不会影响线上运行。

#### 关键做法

1. 所有人基于主干开发，提交粒度极小（一天多次提交）
2. 强 CI 门禁：每一次提交都自动跑全量编译、测试、扫描，不通过立刻回滚
3. 未开发完的功能用特性开关控制，代码可以合入主干但不对外暴露
4. 上线直接用主干代码，通过开关灰度放量

#### 适用场景

超大规模研发团队、高频交付（一天发布多次）、DevOps 基础设施非常完善的大厂。

- 优点：迭代速度最快，几乎无分支合并冲突，持续集成效率最高
- 缺点：对自动化测试、CI 基础设施、团队编码规范要求极高，中小团队很难落地

## 二、企业通用 Git 管控规则（无论哪种工作流都必配）

选了工作流只是第一步，真正落地管理靠的是下面这些管控手段，也是 DevOps / 运维的核心配置项：

### 1. 分支保护机制（核心管控）

在 GitLab/GitHub 后台开启，是所有企业的标配：

- 主分支（main/master、develop）**禁止直接 push**，必须通过 MR/PR 合并 
  - **MR = GitLab 里的合并请求**
  - **PR = GitHub 里的合并请求**
- 合并必须指定至少 1~2 位审批人，审批通过才能合入
- 合并前必须通过 CI 流水线校验（编译、Sonar、单元测试），失败禁止合并
- 禁止强制推送（force push）覆盖主分支历史

### 2. 强制 Code Review（CR）规范

- 核心模块代码必须 2 人以上评审，普通功能 1 人评审
- 评审不通过打回修改，不允许合入
- 大需求拆分小 MR，避免单次提交几千行代码无法评审

### 3. 统一提交信息规范

通用标准是 **Conventional Commits** 格式，企业几乎都会统一：

```
feat: 新增用户分页查询接口
fix: 修复登录接口token过期异常
docs: 更新部署文档
refactor: 重构用户服务逻辑
perf: 优化列表查询性能
test: 补充单元测试用例
chore: 更新Jenkins流水线配置
```

好处：提交历史清晰可读，可自动生成版本更新日志（changelog）。

### 4. 分支与标签命名规范

- 功能分支：`feature/模块名-功能描述`
- bug 分支：`fix/问题描述`
- 热修复：`hotfix/线上bug描述`
- 版本标签：`v1.2.0`（语义化版本：主版本。次版本。修订号）

### 5. CI 门禁强制卡点

和 Jenkins 流水线联动，MR 合入前必须通过：

1. 代码编译通过

2. SonarQube 质量门禁通过

3. 核心单元测试通过

4. 代码无高危安全漏洞

   

   不满足条件自动阻断合并，从源头拦截劣质代码。

### 6. 仓库权限分级

- 开发者：只能拉代码、提 MR，不能直接推主分支、不能删分支
- 维护者：可以审批 MR、合并代码、管理分支
- 管理员：配置仓库规则、权限、保护分支

### 7. 分支生命周期管理

- 功能上线后 1~3 天内必须删除对应 feature 分支
- 定期清理已合并、过期的远程分支，避免仓库冗余
- 保留 master、develop 等常驻分支，其余临时分支用完即删

## 三、选型建议

- **中小团队、快速迭代的互联网项目**：选 GitLab Flow，简单高效，配合分支保护 + CI 门禁足够用
- **传统项目、版本发布周期长、多版本维护**：选 GitFlow，流程规范可控
- **大厂、高频交付、工程能力强**：选 Trunk Based Development













先理清现象：本地有自己的修改，执行 `git pull` 提示已是最新，但**远程新代码没拉下来、也没合并**，

核心原因：**本地工作区改动未提交 / 暂存，Git 优先保护本地修改，不会直接覆盖**。

```bash
前置检查（先执行，看清状态）
# 查看本地文件改动、分支状态
git status
# 查看远程仓库信息、当前分支追踪关系
git remote -v
# 查看远程分支最新代码（对比本地）
git fetch
git log --oneline origin/当前分支名  # 例：git log --oneline origin/main
git fetch 只会拉取远程代码索引，不会合并，先确认远程确实有新提交。


场景 1：你保留本地修改，合并远程最新代码（最常用）
适合：自己改的内容有用，需要和远程新代码合并。
步骤 1：暂存本地改动（安全保存）
# 把当前所有未提交改动 暂存到堆栈，工作区恢复到上次提交状态
git stash
# 查看暂存列表（可选）
git stash list

步骤 2：拉取远程最新代码
# 拉取并合并远程分支代码
git pull

步骤 3：恢复你本地之前的修改
# 恢复最近一次stash的内容，保留stash记录
git stash apply
# 若恢复后有代码冲突，手动打开文件解决冲突，解决后继续下一步

步骤 4（可选）：清理无用的 stash 记录
git stash drop   # 删除最近一条stash
# 或清空所有stash
# git stash clear
```

