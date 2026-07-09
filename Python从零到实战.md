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

### venv

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

### python虚拟化工具对比

| 工具     | 核心职责           | 是否自带 Python | 企业使用场景          | 必学程度       |
| ------ | -------------- | ----------- | --------------- | ---------- |
| pyenv  | 多 Python 版本切换  | 否，自行下载各版本   | 一台机器多版本项目       | 了解 + 会基础命令 |
| venv   | 单项目 pip 包隔离    | 复用当前 Python | 普通后端、爬虫、脚本      | **必须熟练**   |
| pipenv | 虚拟环境 + 依赖锁定    | 复用当前 Python | 中小型 web 项目      | 了解即可       |
| poetry | 标准化依赖 + 打包发布   | 复用当前 Python | 开源库、规范微服务       | 建议掌握       |
| conda  | Python + 底层科学库 | 自带整套 Python | AI / 数据分析 / 大模型 | 数据岗必学，后端了解 |

```bash
# 1. 入门学习、底层原理、服务器无额外工具 → venv + pip（必学）
# 2. 接手多年前遗留小项目、老爬虫 → pipenv（仅了解，不新建）
# 3. 开发开源Python库、需要打包上传PyPI → poetry（掌握）
# 4. 新项目、Web后端、自动化脚本、CI流水线、主流企业 → uv（优先精通）
# 5. 数据分析/深度学习带CUDA/C库 → conda（单独场景）
```

### pyenv

```python
# 安装（Mac/Linux bash）
# 1. 安装pyenv核心
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
# 写入bash环境变量
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
# 2. 安装虚拟环境插件
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
# 生效配置
source ~/.bashrc
# 校验
pyenv --version

# windows
方式 1：Chocolatey 安装（最简单） 
# 管理员 PowerShell 安装包管理器 choco
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
# 安装 pyenv-win
choco install pyenv-win
#配置环境变量（自动写入，关闭终端重开生效）

方式 2：Git 克隆手动安装
powershell
git clone https://github.com/pyenv-win/pyenv-win.git $HOME\.pyenv
# 手动把 .pyenv\bin 和 .pyenv\shims 加入系统PATH
验证安装 powershell
pyenv --version


pyenv 核心版本管理命令
# 查看可安装Python列表
pyenv install --list
# 安装指定版本
pyenv install 3.12.4
# 查看本地已装Python
pyenv versions
# 全局默认Python
pyenv global 3.12.4
# 当前项目目录绑定Python（生成.python-version，优先级高于global）
pyenv local 3.12.4
# 仅当前终端临时切换
pyenv shell 3.10.15
# 查看当前生效版本
pyenv version
# 卸载Python版本
pyenv uninstall 3.8.20
# 更新pyenv版本库
pyenv update

pyenv-virtualenv 虚拟环境全套命令

# 1. 创建环境：格式 pyenv virtualenv python版本 环境名
pyenv virtualenv 3.12.4 game-venv

# 2. 项目自动绑定环境，cd目录自动激活
pyenv local game-venv

# 3. 手动激活/退出
pyenv activate game-venv
pyenv deactivate

# 4. 删除虚拟环境
pyenv virtualenv-delete game-venv

标准项目完整流程（bash）

# 1. 安装对应Python
pyenv install 3.12.4
# 2. 新建项目目录并进入
mkdir pygame-demo && cd pygame-demo
# 3. 绑定Python解释器版本
pyenv local 3.12.4
# 4. 创建该版本专属虚拟环境
pyenv virtualenv 3.12.4 venv-game
# 5. 目录自动绑定环境，进入即激活
pyenv local venv-game
# 安装依赖
pip install pygame matplotlib
# 退出环境
pyenv deactivate


六、优先级规则
shell临时终端 > local项目目录 > global全局系统

对比原生 venv
# 原生venv用法（仅隔离包，无法切换Python解释器）
python -m venv .venv
# 激活bash
source .venv/bin/activate
# 退出
deactivate
```

### pipenv

```python
一、核心定位（替代什么？）
pipenv = venv + pip + requirements.txt 全自动整合工具
彻底抛弃：手动建 .venv、手动激活、手动 pip freeze
Python 官方推荐轻量项目管理工具，中小公司大量在用
二、安装
# 全局安装一次即可
pip install pipenv

三、自动生成的两个文件（重点：不重复、互补）
1. Pipfile（人看、顶层依赖）
只记录：你手动安装的包，区分生产/开发依赖
可写版本范围，用于定义项目需要什么库
2. Pipfile.lock（机器用、全局快照）
锁定：所有依赖 + 子依赖 精确版本 + 哈希校验
作用：保证团队所有人、线上线下版本100%一致
结论：彻底不需要 requirements.txt、不需要 pip freeze
四、日常开发全套命令（Bash）
# 1. 安装生产依赖（自动创建虚拟环境 + 生成两个配置文件）
pipenv install 包名

# 2. 安装开发依赖（仅本地测试，不上线）
pipenv install 包名 --dev

# 3. 进入虚拟环境终端（长期开发用）
pipenv shell

# 4. 不进入终端、直接运行代码（临时执行用）
pipenv run python main.py

# 5. 卸载包
pipenv uninstall 包名

# 6. 查看依赖树
pipenv graph

# 7. 退出虚拟环境
exit

五、企业团队协作标准流程（最重要）
1. 开发者本地开发
pipenv install xxx
# 自动更新 Pipfile + Pipfile.lock

# 提交代码到 Git（只提交源码+两个配置文件）
git add .
git commit -m "update"

2. 同事 / 服务器 拉取项目部署
git pull

# 一键还原 100% 一致环境（生产部署专用）
pipenv install --deploy

无需 pip freeze、无需改任何配置、无需激活环境
六、pipenv vs 原生 venv 核心区别（你之前的疑问）
# ========== 原生 venv 麻烦 ==========
python -m venv .venv
source .venv/bin/activate
pip install xxx
pip freeze > requirements.txt  # 需要手动维护！

# ========== pipenv 全自动 ==========
# 1. 项目目录干净，无 .venv 垃圾文件夹
# 2. 自动区分生产/开发包
# 3. 自动锁版本，不用手动导出依赖
# 4. 环境统一存系统目录，不污染项目

七、什么时候才需要 requirements.txt？
仅兼容老旧项目时使用，正常团队完全不用
# pipenv 导出 txt 兼容旧环境（备用）
pipenv lock -r > requirements.txt

八、清理命令（收尾）
# 删除当前项目虚拟环境
pipenv --rm

九、最终一句话总结
pipenv 干掉了 venv、activate、deactivate、pip freeze、requirements.txt，
只需要提交两个配置文件，团队、服务器全自动统一环境，是中小型项目最省心的 Python 环境方案。


pipenv 看着好用，为什么只建议了解、不推荐新项目用？
1 长期维护停滞（核心硬伤）
2018 年后几乎停更，依赖解析速度极慢，复杂依赖会卡死，官方 PyPA 早已不再主推它；
2 标准不统一
Pipfile 是当年临时方案，现代 Python 统一标准是 pyproject.toml（Poetry/uv 都遵循）；
3 定位尴尬
中小型老项目存量多，但2026 年所有新项目都不选它，只需要看得懂旧项目即可，不用深度主力学习。
```

### poetry

```python
Poetry 精简 Bash 学习手册（企业工程化专用，对比 venv/pipenv）
一、定位
现代 Python 标准工具：依赖管理 + 虚拟环境 + 打包发布三合一
替代 venv+pip+requirements.txt+setup.py+pipenv
标准配置文件 pyproject.toml（行业统一规范，Pipfile 已淘汰）
适合：开源库开发、中大型后端工程、需要打包上传 PyPI；新项目优先 uv，存量库项目必须掌握 Poetry
虚拟环境统一存放系统目录，项目内无臃肿.venv文件夹

二、一键安装（Bash）
# 跨平台官方安装脚本
curl -sSL https://install.python-poetry.org | python3 -
# 写入环境变量永久生效
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
# 校验
poetry --version

# 添加清华源为主源，优先使用国内镜像
poetry source add --priority=primary tsinghua https://pypi.tuna.tsinghua.edu.cn/simple/
# 查看已配置源
poetry source show

# Win11专用官方安装命令  # 卸载的话 后面接  --uninstall
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -

自动独立虚拟环境安装，不污染系统全局 Python
默认路径：C:\Users\kanghua\AppData\Roaming\Python\Scripts\poetry.exe
# 添加到环境变量   
echo "`nif (-not (Get-Command poetry -ErrorAction Ignore)) { `$env:Path += `";C:\Users\kanghua\AppData\Roaming\Python\Scripts`" }" | Out-File -Append $PROFILE
# 检查修改的文件 真实文件路径C:\Users\kanghua\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# notepad $profile 
# 验证
poetry --version


三、初始化项目两种方式
# 1. 新建完整标准化项目（自动生成目录+pyproject.toml）
poetry new demo-project
cd demo-project

# 2. 已有空目录交互式初始化
poetry init

四、两大核心配置文件（不重复，互补）
pyproject.toml（人编辑，顶层项目定义）
    项目名称、版本、Python 版本约束
    生产依赖、开发依赖分组（test/dev/docs）
    打包发布、脚本入口配置
poetry.lock（机器锁定，完整依赖快照）
    递归锁定所有子依赖精确版本，带哈希校验
    团队 / 服务器 100% 复现环境，提交 Git
    无需requirements.txt，仅对接老项目才导出兼容 txt

五、依赖管理全套命令
# 安装生产依赖（写入pyproject.toml，自动更新lock）
poetry add requests matplotlib

# 安装开发依赖（仅本地测试，部署忽略）
poetry add pytest black --group dev

# 卸载包
poetry remove requests

# 更新全部依赖版本
poetry update

# 仅重锁不升级版本（修复lock冲突）
poetry lock --no-update

# 查看依赖树
poetry show --tree

# 导出兼容老项目requirements.txt（备用）
poetry export -f requirements.txt --without-hashes

六、虚拟环境操作（核心）
# 1. 根据lock文件一键还原完整环境（团队/服务器部署必用）
# --without dev：线上部署剔除开发测试包
poetry install --without dev

# 2. 指定Python版本创建环境（配合pyenv多版本）
poetry env use python3.12

# 3. 进入虚拟交互终端（长期开发调试）
poetry shell
exit # 退出环境

# 4. 不进终端，直接运行代码/脚本（CI/临时执行）
poetry run python main.py
poetry run pytest

# 5. 查看当前虚拟环境路径
poetry env info --path

# 6. 删除当前项目全部虚拟环境（清空所有安装包）
poetry env remove python3.12

七、企业打包 & 发布独有能力（pipenv 不具备）

# 修改版本（major/minor/patch）（自动写入pyproject.toml）
poetry version patch

# 构建分发包，生成dist/下 .whl + .tar.gz
poetry build

# 一键发布到官方PyPI
poetry publish

# 发布到私有仓库
poetry publish --repository 私有仓库名  # PyPI 包仓库

# 说明
普通业务项目只推 Git 代码，几乎不用 publish；
内部通用工具 / SDK 组件，中大型企业 100% 会搭建私有 PyPI 包仓库，高频发包；
Release 存放 exe 可执行程序，是给终端用户直接运行；
私有 PyPI 存放库包，是给其他 Python 项目做依赖导入，两种东西用途完全不同。

八、标准团队协作完整流程（Bash）
# 1. 本地开发，添加依赖
poetry add flask
# pyproject.toml + poetry.lock自动更新

# 2. 提交代码（源码+两个配置文件提交Git）
git add .
git commit -m "feat: 接口依赖"

# 3. 同事/服务器拉取代码，一键部署环境
git pull
poetry install --without dev
poetry run python main.py

九、venv /pipenv/poetry 核心区别精简
# 1. python -m venv（底层必学）
# 只有虚拟环境，无依赖锁、无打包，必须手动freeze导出txt

# 2. pipenv（仅看懂旧项目，不新建）
# 停更、解析慢，只能管理依赖，不能打包发布

# 3. poetry（工程/库开发掌握）
# 标准pyproject.toml，依赖分组严谨，自带打包发布，企业存量项目极多

# 4. uv（2026新项目首选，速度远超poetry）
# Rust开发，全能更快，兼顾多Python版本+虚拟环境+依赖

十、清理 & 常用杂项命令
# 清空pip缓存
poetry cache clear pypi

# 查看全局配置
poetry config --list

# 配置国内镜像源加速安装
poetry config repositories.pypi https://pypi.tuna.tsinghua.edu.cn/simple

一句话总结
venv 是底层基础必须吃透；
pipenv 过时仅看懂旧项目；
Poetry 是工程 / 开源库必备，一套命令搞定依赖、虚拟环境、打包发布；
新项目优先 uv。

pipenv = 简化版 venv + 依赖锁，仅满足普通业务脚本；
Poetry = 标准化工程工具，在 pipenv 所有功能基础上，叠加官方标准配置、多依赖分组、强依赖解析、版本管理、项目脚手架、脚本管理、一体化打包发布整套工程能力，打包只是其中一个附加功能，不是唯一区别。
```

### uv

```bash
uv 精简学习手册（2026 企业新项目首选，Bash 命令版）
一、uv 定位
Rust 开发，全能一体化工具：Python 版本管理 + 虚拟环境 + 依赖锁 + pip 兼容 + CI 加速
优势：速度是 pip/poetry/pipenv 的 10~100 倍，遵循现代标准pyproject.toml，替代 venv/pip/pipenv，可平替 Poetry（仅库发布场景 Poetry 生态更成熟）
核心文件：pyproject.toml（顶层依赖）+ uv.lock（全局精确锁，提交 Git）
二、安装 & 升级
# Linux/macOS 一键安装
curl -LsSf https://astral.sh/uv/install.sh | sh
# Windows PowerShell
irm https://astral.sh/uv/install.ps1 | iex

# 验证
uv --version
# 更新uv自身
uv self update

三、项目初始化（两种方式）
# 1. 新建标准化项目（自动生成pyproject.toml、main.py、.gitignore）
uv init demo-uv-project
cd demo-uv-project

# 指定Python版本初始化（自动安装对应解释器）
uv init demo-project --python 3.12

# 2. 已有空目录直接初始化
uv init

初始化后自动生成：
pyproject.toml：记录项目信息、生产 / 开发依赖
.python-version：锁定项目使用的 Python 版本
开发时执行uv sync自动创建.venv虚拟环境（放在项目目录，直观可控）
uv.lock：递归锁定所有子依赖精确版本 + 哈希

四、依赖管理核心命令（日常开发）
# 安装生产依赖（写入pyproject.toml，自动更新uv.lock）
uv add requests fastapi

# 安装开发依赖（测试/格式化，部署可忽略）
uv add pytest ruff black --dev

# 卸载包
uv remove requests

# 查看完整依赖树
uv tree

# 仅更新lock文件，不升级包版本
uv lock --no-update

# 批量升级全部依赖
uv lock --upgrade

# 仅升级单个包
uv lock --upgrade-package fastapi

# 导出兼容老项目requirements.txt
uv export -o requirements.txt --without-hashes

五、虚拟环境操作（uv 自动管理，不用手动 activate）
# 一键同步环境（团队/服务器部署核心命令）
# --frozen：严格按uv.lock版本安装，版本冲突直接报错（生产必加）
uv sync --frozen

# 线上部署，跳过开发依赖
uv sync --frozen --no-dev

# 临时运行代码，无需激活环境（最常用）
uv run python main.py
uv run pytest

# 进入虚拟环境交互式终端（长时间调试）
source .venv/bin/activate  # Linux/macOS
.venv\Scripts\activate     # Windows
exit                       # 退出

# 手动创建自定义虚拟环境（极少用，uv sync自动生成）
uv venv --python 3.12

# 删除项目虚拟环境（清空所有安装包）
rm -rf .venv

六、多 Python 版本管理（独有优势，不用 pyenv）
# 查看本地已有的Python版本
uv python list

# 自动下载安装指定Python
uv python install 3.11 3.12

# 给当前项目锁定Python版本
uv python pin 3.12

七、兼容原生 pip 语法（迁移老项目零成本）
# 完全等价pip install
uv pip install numpy pandas
uv pip list
uv pip show requests
uv pip uninstall numpy

# 从老requirements.txt批量安装
uv pip install -r requirements.txt

八、企业团队标准协作全流程
# 1. 本地开发添加依赖
uv add flask uvicorn

# 2. 提交代码（源码 + pyproject.toml + uv.lock 入Git，忽略.venv）
git add .
git commit -m "add web framework"

# 3. 同事/服务器拉取代码，一键复现100%一致环境
git pull
uv sync --frozen --no-dev

# 4. 启动服务
uv run python main.py

九、uv vs venv/pipenv/poetry 精简对比
# venv：底层基础必学，仅虚拟环境，无锁文件，手动freeze
# pipenv：过时，Pipfile非标准，解析慢，仅看懂老项目
# poetry：适合开源库打包发布，速度慢，不能管理Python版本
# uv：2026新项目首选，速度极快，一套工具搞定版本+环境+依赖，CI友好

十、清理 & 镜像配置
# 清理缓存包
uv cache clean

# 配置清华源加速（全局）
uv config set index-url https://pypi.tuna.tsinghua.edu.cn/simple

一句话总结
venv 是底层基础；
pipenv 过时仅看懂旧项目；
Poetry 适合开源库发布；
uv 是后端 / 脚本 / 数据分析新项目最优选择，速度快、命令简洁、自带多 Python 版本管理，企业 CI / 容器部署主流工具。

# uv vs Poetry 精简对比优势总结
# uv 核心优势（对比 Poetry）
1. 性能：Rust实现，依赖解析/安装速度快数十倍，CI构建耗时大幅缩短
2. 内置Python版本管理，无需额外pyenv
3. 完整兼容原生pip语法，老项目迁移成本极低
4. 独立单二进制，裸机/Docker/CI无需预装Python
5. 自带全局工具uvtool、多包workspace能力
6. 缓存机制完善，提供CI专用缓存清理指令
7. 命令统一简洁，uv sync一步完成环境构建

# Poetry 唯一优势
仅开源Python库打包、发布至PyPI生态更成熟

# 选型结论
业务服务/脚本/CI流水线项目选uv；开源SDK库开发选Poetry



dockerfile 构建对比

示例 1：Poetry 版本 Dockerfile（慢）
-----------------------------------------
FROM python:3.12-slim

# 1. 先安装poetry本体（它本身是Python包，多一层耗时）
RUN pip install poetry

WORKDIR /app
COPY pyproject.toml poetry.lock ./

# 2. poetry install 解析依赖极慢、串行下载
RUN poetry install --without dev --no-root

COPY . .
CMD ["poetry", "run", "python", "main.py"]
------------------------------------------- docker build -t my-poetry-app .
示例 2：uv 版本 Dockerfile（快）
FROM python:3.12-slim

# 直接下载独立二进制uv，不依赖pip安装工具本身
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.cargo/bin:$PATH"

WORKDIR /app
COPY pyproject.toml uv.lock ./

# 并行解析、并行下载、秒级完成
RUN uv sync --frozen --no-dev

COPY . .
CMD ["uv", "run", "python", "main.py"]
----------------------------------------------docker build -t my-uv-app .
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

---------------------------------------
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
运算符                     描述
**                         指数运算符优先于表达式中使用的所有其他运算符。
〜+ <->                    </->否定，一元加减。
* /％//                    乘法，除法，模块，提醒和楼层划分。
+ <->                    </->二进制加减
>> <<                     左移和右移
＆                        二进制和。
^ |                        二元xor和or
<= <>> =                 比较运算符（小于，小于等于，大于，大于等于）。
<> ==！=                    比较运算符
=％= / = // = - = + =     等于运算符
* = ** =                赋值运算符
is is not                身份运算符
in not in                成员运算符
not and or                逻辑运算符
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

## 列表推导式和切片

```bash
# ===================== 一、切片：序列通用取值操作（list/tuple/str 均支持） =====================
# 语法：序列[start:end:step]
# 核心规则：左闭右开 [start, end)，包含start位置元素，不包含end位置元素
# 三个参数均可省略，start默认0，end默认序列长度，step默认1

lst = [10, 20, 30, 40, 50, 60, 70]

# 1. 基础切片：指定起止范围
print(lst[1:4])    # 取索引1到3的元素 → [20, 30, 40]
print(lst[:3])     # 省略start，从开头取到索引2 → [10, 20, 30]
print(lst[3:])     # 省略end，从索引3取到末尾 → [40, 50, 60, 70]
print(lst[:])      # 全省略，复制整个列表，生成新对象 → [10,20,30,40,50,60,70]

# 2. 负索引切片：从末尾倒数，-1是最后一个元素
print(lst[-3:])    # 取最后3个元素 → [50, 60, 70]
print(lst[:-2])    # 从开头取到倒数第3个 → [10, 20, 30, 40, 50]
print(lst[-4:-1])  # 倒数第4个到倒数第2个 → [40, 50, 60]

# 3. 带步长切片：step控制间隔，step为正从左往右，为负从右往左
print(lst[::2])    # 从头到尾，每隔1个取一个 → [10, 30, 50, 70]
print(lst[1:6:2])  # 索引1到5，步长2 → [20, 40, 60]
print(lst[::-1])   # 步长-1，列表反转 → [70, 60, 50, 40, 30, 20, 10]
print(lst[::-2])   # 从右往左，每隔1个取 → [70, 50, 30, 10]

# 4. 切片核心特性
# ① 切片返回新对象，不修改原列表
new_lst = lst[2:5]
print(id(lst) == id(new_lst))  # False，内存地址不同
# ② 索引越界不会报错，自动截断，返回空或可取值部分
print(lst[10:20])  # → []，不会报索引越界异常

-----------------------------------------------------
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
--------------------------------------------------------

# ===================== 二、列表推导式：快速生成列表的语法糖 =====================
# 语法：[最终表达式 for 变量 in 可迭代对象 if 筛选条件]
# 优势：代码简洁，执行效率比普通for+append更高，是Pythonic写法

# 1. 基础版：生成简单序列
# 普通写法
res1 = []
for i in range(10):
    res1.append(i)
# 推导式写法（等价）
res1 = [i for i in range(10)]  # → [0,1,2,3,4,5,6,7,8,9]

# 2. 带运算处理：对每个元素做计算后生成列表
res2 = [i * 2 for i in range(5)]  # 每个元素乘2 → [0, 2, 4, 6, 8]
res3 = [str(i) for i in range(5)] # 转字符串 → ['0','1','2','3','4']

# 3. 带条件筛选：只保留符合条件的元素
res4 = [i for i in range(10) if i % 2 == 0]  # 只保留偶数 → [0,2,4,6,8]
res5 = [i for i in range(20) if i > 10 and i % 3 == 0]  # 多条件筛选

# 4. 嵌套循环推导式：对应双层for循环
# 普通写法
res6 = []
for x in [1,2,3]:
    for y in ['a','b']:
        res6.append((x, y))
# 推导式写法（等价）
res6 = [(x, y) for x in [1,2,3] for y in ['a','b']]

# 5. 常见实战场景
# 列表元素统一处理
names = ["alex", "bob", "charlie"]
upper_names = [name.upper() for name in names]  # 全部转大写

# 过滤空值/无效值
data = [10, None, 20, None, 30]
clean_data = [x for x in data if x is not None]  # 去除None

# 字典推导式/集合推导式（同语法延伸）
dict_comp = {i: i*2 for i in range(5)}  # 生成字典 {0:0, 1:2, 2:4...}
set_comp = {i**2 for i in range(5)}     # 生成集合 {0,1,4,9,16}

# 6. 注意事项
# ① 推导式优先写单层简单逻辑，超过三层嵌套不建议用，可读性大幅下降
# ② 条件复杂、循环内逻辑多时，用普通for循环更易维护

--------------------------------------------------
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

## 深浅拷贝

```python
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

## 字符串格式化打印

```bash
#读取用户指令
name = input("What is your name?")
print("Hello " + name )

# ===================== Python字符串格式化打印 三种主流方式 =====================
# 推荐优先级：f-string > str.format() > % 占位符

# ===================== 1. % 占位符格式化（老式C风格，兼容老版本） =====================
# %s 字符串  %d 整数  %f 浮点数  %x 十六进制
name = "张三"
age = 22
height = 1.756

# 基础用法：按顺序匹配
print("姓名：%s，年龄：%d，身高：%.2f" % (name, age, height))
# %.2f 表示浮点数保留2位小数

# 字典方式传参，不用按顺序
print("姓名：%(name)s，年龄：%(age)d" % {"name": name, "age": age})

# 常用格式符
# %s: 字符串  %d: 十进制整数  %f: 浮点数  %x: 十六进制  %o: 八进制  %%: 输出百分号本身


# ===================== 2. str.format() 方法（Python2.6+ 引入） =====================
# 方式A：位置占位，按顺序匹配
print("姓名：{}，年龄：{}，身高：{}".format(name, age, height))

# 方式B：指定索引，可重复使用
print("姓名：{0}，年龄：{1}，重复姓名：{0}".format(name, age))

# 方式C：关键字参数，可读性强
print("姓名：{name}，年龄：{age}".format(name=name, age=age))

# 格式控制：精度、对齐、填充、宽度
print("保留2位小数：{:.2f}".format(height))   # 保留2位小数
print("左对齐占10位：{:<10d}".format(age))   # 左对齐，总宽度10
print("右对齐占10位：{:>10d}".format(age))   # 右对齐，总宽度10
print("居中对齐：{:^10d}".format(age))       # 居中对齐
print("补零填充：{:0>4d}".format(age))       # 右对齐，不足4位左侧补0
print("千分位分隔：{:,}".format(1234567))    # 数字千分位逗号分隔
print("十六进制：{:x}".format(255))          # 转十六进制
print("百分比：{:.1%}".format(0.856))        # 转百分比，保留1位小数


# ===================== 3. f-string 字面量格式化（Python3.6+ 官方推荐） =====================
# 语法：f"xxx{变量/表达式}xxx"，直接在{}内嵌入变量、表达式、函数调用，性能最高

# 基础用法
print(f"姓名：{name}，年龄：{age}，身高：{height}")

# 嵌入表达式、函数调用
print(f"年龄明年：{age + 1}，姓名大写：{name.upper()}")

# 格式控制，语法和format一致，写在冒号后
print(f"身高保留2位：{height:.2f}")
print(f"年龄补零4位：{age:0>4d}")
print(f"数字千分位：{1234567:,}")
print(f"百分比：{0.856:.1%}")
print(f"居中对齐：{age:^10d}")

# 调试专用：= 符号，同时输出变量名和值（Python3.8+）
print(f"{age=}")  # 输出 age=22，调试不用重复写变量名


# ===================== 常用格式控制符总结 =====================
# :.nf      浮点数保留n位小数
# :nd       整数总宽度n位，默认右对齐
# :<n       左对齐，总宽度n
# :>n       右对齐，总宽度n
# :^n       居中对齐，总宽度n
# :0>n      右对齐，不足n位左侧补0
# :,        数字千分位逗号分隔
# :x / :o / :b  十六/八/二进制
# :.n%      转百分比，保留n位小数
```

## 编码

```py
axcii   字符与二进制对照表
unicode 字符与二进制对照表
utf8    对unicode字符集的码位进行压缩处理，间接也维护了字符和二进制的对照表。

# ===================== Python 编码核心原理 =====================
# Python3 核心设计：str = Unicode字符序列（人类可读）；bytes = 二进制字节（机器存储/传输用）
# 编码 encode：str → bytes（字符转字节，用于存文件、发网络）
# 解码 decode：bytes → str（字节转字符，用于读文件、收数据）
# 乱码本质：编码和解码使用的编码格式不一致

# ===================== 1. 编码 encode：字符串转字节 =====================
s = "你好Python"

# 默认 utf-8 编码（全球通用，中文占3字节，英文占1字节）
b_utf8 = s.encode("utf-8")
print(b_utf8)  # b'\xe4\xbd\xa0\xe5\xa5\xbdPython'

# gbk 编码（Windows简体中文默认，中文占2字节）
b_gbk = s.encode("gbk")
print(b_gbk)   # b'\xc4\xe3\xba\xc3Python'

# 编码错误处理 errors 参数
# strict：默认，无法编码直接报错
# ignore：忽略无法编码的字符
# replace：用 ? 替换无法编码的字符
s_emoji = "你好😊"
b = s_emoji.encode("gbk", errors="replace")  # emoji无法用gbk编码，替换为?
print(b)

# ===================== 2. 解码 decode：字节转字符串 =====================
# 必须和编码时使用同一种格式，否则产生乱码
b_data = b'\xe4\xbd\xa0\xe5\xa5\xbd'
print(b_data.decode("utf-8"))  # 正确：你好
# print(b_data.decode("gbk"))  # 错误：浣犲ソ，典型乱码

# 解码错误处理
b_bad = b'\xe4\xbd\xa0\xe5'
print(b_bad.decode("utf-8", errors="ignore"))  # 忽略不完整字节

# ===================== 3. 主流编码格式说明 =====================
# utf-8：全球通用，可变长度，中文3字节、英文1字节，兼容ASCII，全场景推荐
# gbk：简体中文Windows默认，中文2字节，仅国内老系统使用
# gb2312：gbk子集，仅支持简体中文常用汉字
# ASCII：仅支持英文、数字、符号，1字节，所有编码均兼容ASCII英文部分
# Unicode：字符集标准，不是存储编码；utf-8/utf-16是Unicode的具体存储实现

# ===================== 4. 文件读写编码控制 =====================
# open 必须指定 encoding，否则使用系统默认编码（Windows默认gbk，Linux默认utf-8，跨平台必乱）

# 写入文件，指定utf-8
with open("test.txt", "w", encoding="utf-8") as f:
    f.write("你好世界")

# 读取文件，编码与写入保持一致
with open("test.txt", "r", encoding="utf-8") as f:
    content = f.read()
    print(content)

# 读取带BOM头的utf-8文件（Windows记事本生成）
# with open("bom_file.txt", "r", encoding="utf-8-sig") as f:
#     print(f.read())

# ===================== 5. 常见坑点与最佳实践 =====================
# 坑1：不指定encoding依赖系统默认，跨平台运行必乱码
# 坑2：网络传输、文件存储只能使用bytes，不能直接传str
# 坑3：BOM头：Windows记事本保存utf-8会自动带BOM，用utf-8-sig读取自动去除

# 最佳实践
# 1. 代码、文件、接口统一使用utf-8，杜绝gbk
# 2. 文件读写强制指定 encoding="utf-8"
# 3. 业务逻辑全用str处理，仅在输入输出边界（文件、网络）做编解码
# 4. 遇乱码第一步：核对编码与解码格式是否一致
```

## 流程控制

```python
# ===================== Python 流程控制语句全集 =====================
# 三大类：1.条件分支  2.循环语句  3.循环控制关键字
# 核心作用：控制代码的执行顺序，实现分支判断、重复执行逻辑

# ===================== 一、if 条件分支（判断选择） =====================
score = 85

# 1. 单分支：满足条件才执行
if score >= 60:
    print("及格")

# 2. 双分支：二选一
if score >= 60:
    print("及格")
else:
    print("不及格")

# 3. 多分支：多选一，按顺序判断，命中第一个就不再往下走
if score >= 90:
    print("优秀")
elif score >= 80:
    print("良好")
elif score >= 60:
    print("及格")
else:
    print("不及格")

# 4. 嵌套分支：条件里再套条件
if score >= 60:
    if score >= 90:
        print("优秀")
    else:
        print("及格")
else:
    print("不及格")

# 5. 三元表达式（if-else简写）：适合简单二选一赋值
# 语法：结果1 if 条件 else 结果2
result = "及格" if score >= 60 else "不及格"


# ===================== 二、while 循环（条件满足就循环） =====================
# 1. 基础while：先判断条件，True就执行循环体
count = 0
while count < 5:
    print(count)
    count += 1  # 计数器自增，避免死循环

# 2. while...else：循环正常结束（没被break打断）才执行else代码
num = 0
while num < 3:
    print(num)
    num += 1
else:
    print("循环正常结束")

# 3. 死循环：条件永远为True，配合break主动退出
while True:
    print("循环中")
    break  # 立刻退出循环


# ===================== 三、for 循环（遍历循环，最常用） =====================
# 作用：遍历可迭代对象（字符串、列表、元组、字典、range等）

# 1. 遍历列表/字符串
name_list = ["张三", "李四", "王五"]
for name in name_list:
    print(name)

# 2. range() 生成数字序列，专门配合for循环
# range(n)：生成 0 ~ n-1 的整数
for i in range(5):
    print(i)  # 0 1 2 3 4

# range(start, end)：左闭右开
for i in range(2, 6):
    print(i)  # 2 3 4 5

# range(start, end, step)：带步长
for i in range(1, 10, 2):
    print(i)  # 1 3 5 7 9

# 3. 遍历字典
user = {"name": "张三", "age": 22, "gender": "男"}
# 遍历key
for k in user:
    print(k)
# 遍历value
for v in user.values():
    print(v)
# 遍历键值对（最常用）
for k, v in user.items():
    print(k, v)

# 4. for...else：循环正常结束执行else，break打断则不执行
for i in range(3):
    print(i)
else:
    print("for循环正常结束")

# 5. 嵌套循环：循环里套循环
for i in range(3):
    for j in range(2):
        print(i, j)


# ===================== 四、循环控制关键字 =====================
# 1. break：立刻终止整个当前循环，跳出循环体
for i in range(5):
    if i == 3:
        break  # 遇到3直接结束整个循环
    print(i)  # 输出 0 1 2

# 2. continue：跳过本次循环，直接进入下一轮循环
for i in range(5):
    if i == 2:
        continue  # 遇到2跳过本次，不执行后面的print
    print(i)  # 输出 0 1 3 4

# 3. pass：空占位符，啥也不做，保证语法不报错
if score > 90:
    pass  # 后续逻辑待补充，先不写也不会报语法错误


# ===================== 五、match-case 模式匹配（Python3.10+ 新增） =====================
# 升级版多分支判断，支持复杂模式匹配
day = 3
match day:
    case 1:
        print("周一")
    case 2:
        print("周二")
    case 3:
        print("周三")
    case _:  # 通配符，相当于else
        print("其他")



------------------------------Python 多层循环跳出实现方案
方案 1：布尔标志位（最常用）
模拟 Go break 外层标签 效果
# 需求：j==2 直接终止两层循环
flag = False
for i in range(3):
    if flag:
        break
    for j in range(3):
        if j == 2:
            flag = True
            break  # 仅跳出内层
        print(f"i={i}, j={j}")
输出：
i=0, j=0
i=0, j=1

方案 2：函数 return 快速跳出（更优雅）; 利用函数提前返回，替代标签 break
def loop_demo():
    for i in range(3):
        for j in range(3):
            if j == 2:
                return  # 直接退出所有循环
            print(f"i={i}, j={j}")

loop_demo()
```

## 函数基础

```bash
# ===================== Python 函数核心全集 =====================
# 函数本质：封装可重复执行的代码块，实现代码复用、逻辑分层
# 定义语法：def 函数名(参数列表): 缩进写函数体
# 调用语法：函数名(实际参数)

# ===================== 1. 基础定义与调用 =====================
def say_hello():
    """函数文档字符串：用于说明函数功能、参数、返回值，可通过help()查看"""
    print("Hello Python")

say_hello()  # 调用函数，执行函数体内代码


# ===================== 2. 函数参数分类（核心重点） =====================

# 2.1 位置参数：按顺序一一匹配，调用时必须传对应个数
def add(a, b):
    """a、b为位置参数，传入顺序必须和定义一致"""
    print(a + b)

add(3, 5)  # 按顺序传参，a=3，b=5


# 2.2 默认参数：设置默认值，调用时可不传；必须放在位置参数右侧
def user_info(name, age=18, gender="男"):
    """age、gender为默认参数，不传则使用默认值"""
    print(f"姓名：{name}，年龄：{age}，性别：{gender}")

user_info("张三")  # 仅传必填参数，默认参数生效
user_info("李四", 22)  # 按顺序覆盖默认值
user_info("王五", gender="女")  # 指定参数名传参


# 2.3 关键字参数：调用时通过参数名传值，无需遵守顺序
user_info(age=25, name="赵六")  # 通过参数名匹配，顺序任意


# 2.4 *args 可变位置参数：接收所有多余位置参数，打包为元组
def sum_all(*args):
    """传入任意个位置参数，全部被args接收为元组"""
    return sum(args)  # args 是 tuple 类型

sum_all(1, 2, 3, 4, 5)  # 支持任意个数位置参数


# 2.5 **kwargs 可变关键字参数：接收所有多余关键字参数，打包为字典
def print_info(**kwargs):
    """传入任意个关键字参数，全部被kwargs接收为字典"""
    for k, v in kwargs.items():
        print(k, v)

print_info(name="张三", age=22, city="北京")


# 2.6 参数书写顺序规范（从左到右）
# 位置参数 → 默认参数 → *args → **kwargs
def demo(a, b=10, *args, **kwargs):
    print(a, b, args, kwargs)


# ===================== 3. 返回值 return =====================
# 作用：将函数内结果返回给调用处；执行return后函数立即终止

# 3.1 返回单个值
def calc(a, b):
    res = a * b
    return res  # 返回计算结果

result = calc(10, 20)  # 变量接收返回值


# 3.2 返回多个值：本质自动打包为元组，支持拆包接收
def get_user():
    name = "张三"
    age = 22
    return name, age  # 逗号分隔多值，自动封装为元组

n, a = get_user()  # 拆包接收两个返回值


# 3.3 无return的函数，默认返回 None
def test():
    print("测试函数")

print(test())  # 输出 None


# ===================== 4. 变量作用域 =====================
# 分类：全局变量（整个文件生效）、局部变量（仅函数内部生效）

# 全局变量：定义在函数外
num = 100

def test_scope():
    local_num = 50  # 局部变量：仅函数内部可访问，外部不可见
    print(num)  # 函数内部可直接读取全局变量

test_scope()

# 修改全局变量：必须用 global 声明，否则会被识别为局部变量
def change_global():
    global num  # 声明要修改全局作用域的num
    num = 200

change_global()
print(num)  # 输出 200

# 嵌套函数 nonlocal：修改外层函数的局部变量
def outer():
    count = 0
    def inner():
        nonlocal count  # 声明使用外层函数的count变量
        count += 1
        return count
    return inner


# ===================== 5. lambda 匿名函数 =====================
# 语法：lambda 参数: 返回值
# 场景：简单单行逻辑，通常作为参数传给高阶函数，无需定义函数名

# 等价普通函数：def add(x, y): return x + y
add_lambda = lambda x, y: x + y
print(add_lambda(3, 5))

# 典型用法：配合排序、过滤等高阶函数
user_list = [("张三", 22), ("李四", 18), ("王五", 25)]
# 按年龄升序排序，key指定排序依据
sorted_list = sorted(user_list, key=lambda x: x[1])


# ===================== 6. 高频注意事项 =====================
# 坑：默认参数禁止使用可变类型(list/dict)，多次调用会共用同一个对象
# 错误写法：def func(a, lst=[]): lst.append(a)
# 正确写法：默认值设为None，函数内部初始化
def func(a, lst=None):
    if lst is None:
        lst = []
    lst.append(a)
    return lst

# 函数必须先定义后调用，不能将调用写在定义前
# *args、**kwargs是约定俗成命名，可修改但不建议

python的函数传参时：传递的是内存地址。
Python参数的这一特性有两个好处：
- 节省内存
- 对于可变类型且函数中修改元素的内容，所有的地方都会修改。可变类型：列表、字典、集合。

函数名就是一个变量，这个变量代指函数。
函数名可以放入列表中。
函数同时也可被哈希，所以函数名也可以当做集合的元素、字典的键。
```

## 函数高级

```python
# ===================== Python 函数高级特性 =====================
# 核心基石：Python 函数是「一等公民」
# 一等公民含义：函数和普通数据类型完全平等，可赋值给变量、作为参数传递、作为返回值、存入容器
# 闭包、装饰器、高阶函数等所有高级特性，都建立在这个设计之上


# ===================== 一、函数一等公民基础演示 =====================
def add(a, b):
    return a + b

# 1. 函数赋值给变量：函数本身就是对象，变量绑定函数对象
func = add
print(func(2, 3))  # 等价于 add(2, 3)

# 2. 函数作为参数传入另一个函数（高阶函数定义：接收/返回函数的函数）
def calc(func, x, y):
    return func(x, y)

print(calc(add, 10, 20))  # 将 add 函数作为参数传入 calc

# 3. 函数作为返回值：外层函数返回内层函数对象本身，不立即执行
def outer():
    def inner():
        print("内层函数执行")
    return inner

f = outer()
f()  # 调用返回的内层函数

# 4. 函数存入容器
func_list = [add, lambda x, y: x - y]
print(func_list[0](5, 3))


# ===================== 二、闭包 Closure =====================
# 定义：嵌套函数中，内层函数引用外层函数的非全局变量，外层函数返回内层函数
# 核心效果：外层函数执行结束后，其局部变量不会被销毁，会被内层函数持续持有（保留状态）
# 三要素：1. 函数嵌套  2. 内层引用外层变量  3. 外层返回内层函数

def counter():
    count = 0  # 外层局部变量，被闭包持有，生命周期被延长
    def increment():
        nonlocal count  # 声明修改外层函数的变量
        count += 1
        return count
    return increment

# 创建闭包实例
cnt = counter()
print(cnt())  # 1
print(cnt())  # 2
print(cnt())  # 3  每次调用 count 持续累加，状态被保留

# 查看闭包持有的变量
print(cnt.__closure__)  # 打印闭包单元格对象，存储外层变量

# 应用场景：替代全局变量保存状态、实现装饰器、工厂函数
# 柯里化：闭包的典型应用，将多参数函数拆解为单参数嵌套函数
def curry_add(a):
    def add_b(b):
        return a + b
    return add_b

print(curry_add(5)(3))  # 8


# ===================== 三、装饰器 Decorator =====================
# 本质：基于闭包的语法糖，遵循「开闭原则」：对扩展开放，对修改关闭
# 作用：不修改原函数代码和调用方式，给函数增强额外功能（日志、计时、权限校验等）

import time
import functools

# 3.1 通用基础装饰器：兼容任意参数、任意返回值的原函数
def timer(func):
    @functools.wraps(func)  # 保留原函数元信息（函数名、文档字符串），否则会被内层函数覆盖
    def wrapper(*args, **kwargs):
        """装饰器内层包装函数"""
        start = time.time()
        result = func(*args, **kwargs)  # 执行原函数，接收返回值
        end = time.time()
        print(f"函数 {func.__name__} 执行耗时：{end - start:.4f}s")
        return result  # 原封不动返回原函数的返回值
    return wrapper

# @ 语法糖应用装饰器，等价于：work = timer(work)
@timer
def work(n):
    """模拟耗时任务"""
    time.sleep(n)
    return "任务完成"

print(work(0.1))
print(work.__name__)  # 加 functools.wraps 后仍为 work，否则是 wrapper

# 3.2 带参数的装饰器：外层多一层函数接收参数，返回真正的装饰器
def log(level="info"):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            print(f"[{level}] 函数 {func.__name__} 开始执行")
            return func(*args, **kwargs)
        return wrapper
    return decorator

@log(level="debug")  # 先执行 log("debug") 得到装饰器，再应用到函数
def test_func():
    print("函数执行中")

test_func()

# 3.3 多装饰器叠加：装饰过程从内到外（靠近函数的先装饰），执行时从外到内
# @decorator1
# @decorator2
# def func(): pass
# 等价于 func = decorator1(decorator2(func))


# ===================== 四、生成器函数 Generator =====================
# 定义：函数中使用 yield 关键字，返回生成器对象，惰性求值，按需生成数据
# 核心优势：处理海量数据时极大节省内存，不需要一次性加载全部数据到内存
# 生成器是迭代器，支持 next() 调用，也可直接 for 循环遍历

# 4.1 基础生成器：yield 暂停函数执行并返回值，下次 next 从暂停处继续
def gen_num(n):
    for i in range(n):
        yield i  # 遇到 yield 暂停，返回 i；下次调用 next 从这里继续执行

g = gen_num(5)
print(next(g))  # 0
print(next(g))  # 1
# 直接 for 循环遍历，自动处理 StopIteration 异常
for num in gen_num(3):
    print(num)

# 4.2 生成器高级方法：send / throw / close
def gen_echo():
    msg = "初始值"
    for _ in range(3):
        # yield 左边接收 send 传来的值，右边返回给调用方
        received = yield msg
        if received:
            msg = f"收到：{received}"
        else:
            msg = "无输入"

g2 = gen_echo()
print(next(g2))           # 第一次必须用 next 启动，或 g2.send(None)
print(g2.send("hello"))   # send 向生成器发送数据，作为 yield 的返回值

# throw()：向生成器内部抛出指定异常
# close()：关闭生成器，后续 next 会抛出 StopIteration

# 4.3 yield from：委托生成器，简化嵌套生成器调用
def nested_gen():
    yield from [1, 2, 3]  # 等价于 for i in [1,2,3]: yield i
    yield from "abc"

for i in nested_gen():
    print(i)


# ===================== 五、内置高阶函数 =====================
# 接收函数作为参数的内置函数，函数式编程核心工具

lst = [1, 2, 3, 4]

# 1. map(func, 可迭代对象)：将函数依次作用于每个元素，返回迭代器
res_map = map(lambda x: x ** 2, lst)
print(list(res_map))  # [1, 4, 9, 16]

# 2. filter(func, 可迭代对象)：按函数返回的布尔值过滤元素，保留 True 的项
res_filter = filter(lambda x: x % 2 == 0, lst)
print(list(res_filter))  # [2, 4]

# 3. reduce(func, 可迭代对象)：累计运算，func 必须接收 2 个参数
from functools import reduce
res_reduce = reduce(lambda x, y: x + y, lst)  # 累加：((1+2)+3)+4 = 10
print(res_reduce)

# 4. sorted(可迭代对象, key=func, reverse=bool)：按 key 函数的结果排序
users = [("张三", 22), ("李四", 18), ("王五", 25)]
print(sorted(users, key=lambda x: x[1]))  # 按年龄升序


# ===================== 六、偏函数 functools.partial =====================
# 作用：固定函数的部分参数，生成新函数，简化重复调用
# 场景：某个函数大部分参数固定，只有少数变化时使用
from functools import partial

# 示例：固定 int 函数的 base=2，实现二进制字符串转十进制
int2 = partial(int, base=2)
print(int2("1010"))  # 10，等价于 int("1010", base=2)

# 自定义函数示例
def add_abc(a, b, c):
    return a + b + c

add_fixed = partial(add_abc, 10)  # 固定第一个参数 a=10
print(add_fixed(2, 3))  # 15，等价于 add_abc(10, 2, 3)


# ===================== 七、递归函数 =====================
# 定义：函数内部调用自身
# 两个必要条件：1. 基线条件（终止条件），停止递归  2. 递归条件，缩小问题规模调用自身

# 示例：阶乘 n! = n * (n-1)!
def factorial(n):
    if n == 1:  # 基线条件，终止递归
        return 1
    return n * factorial(n - 1)  # 递归条件  5*4*3*2

print(factorial(5))  # 120

# 注意事项：
# 1. Python 默认递归深度限制约 1000 层，过深会抛出 RecursionError
# 2. Python 不支持尾递归优化，大深度递归建议改用循环
# 3. 优点：代码简洁，符合数学逻辑；缺点：占用栈内存，执行效率低于循环


# ===================== 八、LEGB 作用域查找规则 =====================
# 变量查找优先级：L > E > G > B
# L (Local)：函数内部局部作用域
# E (Enclosing)：嵌套函数的外层函数作用域（闭包所在层）
# G (Global)：全局作用域（当前模块文件）
# B (Built-in)：内置作用域（Python 内置函数、异常等）

x = "全局G"
def outer_scope():
    x = "外层E"
    def inner_scope():
        x = "局部L"
        print(x)  # 优先查找局部 L
    inner_scope()

outer_scope()


# ===================== 九、函数内省属性 =====================
# 函数作为对象，自带多种属性，用于运行时获取函数信息
def demo_func(a, b=10):
    """演示函数文档字符串"""
    return a + b

print(demo_func.__name__)      # 函数名
print(demo_func.__doc__)       # 文档字符串
print(demo_func.__defaults__)  # 默认参数元组 (10,)
print(demo_func.__code__)      # 字节码对象，包含函数代码信息
print(demo_func.__globals__)   # 函数所在的全局命名空间
print(demo_func.__closure__)   # 闭包变量，非闭包函数为 None
```

## 可迭代对象 / 迭代器 / 生成器 深度解析

```python
python
运行
# ==================================================
# 可迭代对象 / 迭代器 / 生成器 深度解析
# 核心本质：一套「统一遍历 + 惰性计算」的设计模式，是Python高效处理数据的基石
# ==================================================

# ===================== 一、先搞懂最底层：迭代器协议 =====================
# Python 定义了两套魔法方法来规范迭代行为：
# 1. __iter__()  →  返回一个迭代器对象
# 2. __next__()  →  逐个返回下一个值，没值了抛出 StopIteration 异常

# 满足 __iter__ 的对象 → 可迭代对象（Iterable）
# 同时满足 __iter__ + __next__ 的对象 → 迭代器（Iterator）



一、可迭代对象 Iterable
1. 定义与判断
只要实现了 __iter__ 方法（或兼容的 __getitem__），能被 for 循环遍历的对象，都是可迭代对象。
简单理解：可以被 iter() 函数转成迭代器的东西，就是可迭代对象。

from collections.abc import Iterable, Iterator
# 常见可迭代对象判断
print(isinstance([1,2,3], Iterable))    # True 列表
print(isinstance("abc", Iterable))      # True 字符串
print(isinstance((1,2), Iterable))      # True 元组
print(isinstance({"a":1}, Iterable))    # True 字典（遍历key）
print(isinstance({1,2}, Iterable))      # True 集合
print(isinstance(range(5), Iterable))   # True range对象
print(isinstance(open("test.txt"), Iterable)) # True 文件对象

# python for循环可以作用在可迭代对象上
L = ["a",'b',"c"]
for i,value in enumerate(L):
    print(i,value)

2. 常见的可迭代对象汇总
序列类：str、list、tuple、range
集合类：set、frozenset
映射类：dict（默认遍历 key）、dict.keys()、dict.values()、dict.items()
文件对象：open() 返回的文件句柄，本身就是迭代器
迭代器 / 生成器本身：迭代器也属于可迭代对象
高阶函数返回值：map、filter、zip、enumerate 等返回的都是迭代器

3. 核心特点
只负责提供数据，不负责逐个取值；
可以反复遍历（比如列表可以 for 循环多次），每次遍历都会生成新的迭代器。

二、迭代器 Iterator
1. 定义
同时实现了 __iter__ 和 __next__ 方法的对象，是真正执行遍历取值的执行者。
__iter__()：返回迭代器自己（所以迭代器本身也是可迭代对象）
__next__()：返回下一个元素，没有元素时抛出 StopIteration 异常

lst = [10, 20, 30]
# 列表是可迭代对象，但不是迭代器
print(isinstance(lst, Iterator))  # False
# next(lst)  # 直接调用会报错：'list' object is not an iterator

# 用 iter() 把可迭代对象转成迭代器
it = iter(lst)
print(isinstance(it, Iterator))   # True

# 用 next() 逐个取值
print(next(it))  # 10
print(next(it))  # 20
print(next(it))  # 30
# print(next(it))  # 取完再调用，抛出 StopIteration 异常

2. for 循环的底层本质（最关键的理解点）
你天天写的 for 循环，本质就是自动帮你做了「转迭代器 + 循环 next + 捕获异常」的工作：
# 你写的代码
for i in [1,2,3]:
    print(i)

# Python 底层等价逻辑
it = iter([1,2,3])
while True:
    try:
        i = next(it)
        print(i)
    except StopIteration:
        break  # 捕获到结束异常，退出循环
这就是为什么所有可迭代对象都能用 for 循环：只要遵守迭代器协议，就统一了遍历语法，不用管底层是列表、字典、文件还是自定义对象。 

3. 迭代器核心特点
一次性：只能往前遍历，不能后退，遍历完就空了，不能重复用
it = iter([1,2,3])
list(it)  # [1,2,3] 第一次取完了
list(it)  # [] 第二次就空了
惰性计算：不提前生成所有数据，调用一次 next() 才生成一个值
省内存：本身不存储完整数据，只记录当前位置和生成规则

三、生成器 Generator
1. 定义
生成器是一种特殊的、语法简化的迭代器，不用手动写 __iter__ 和 __next__，靠 yield 关键字自动实现迭代器协议。
它是 Python 提供的「懒人版迭代器」，专门用来快速创建迭代器，避免手写类的繁琐。
2. 两种创建方式
方式 1：生成器函数（带 yield 的函数）
普通函数用 return 返回值，执行完就结束；
生成器函数用 yield 返回值，执行到 yield 会暂停执行并保留状态，下次 next() 从暂停处继续。

def count_num(n):
    for i in range(n):
        yield i  # 遇到yield暂停，返回i；下次next从这里继续

gen = count_num(3)
print(type(gen))  # generator 生成器类型
print(isinstance(gen, Iterator))  # True，生成器本质就是迭代器
print(next(gen))  # 0
print(next(gen))  # 1
print(next(gen))  # 2
-----------------------------------------
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
g = fib(6)
while True:
     try:
        x = next(g)
         print('g:', x)
     except StopIteration as e:
         print('Generator return value:', e.value)
         break
---------------------------------------------------------
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

方式 2：生成器表达式
把列表推导式的 [] 换成 ()，就是生成器表达式，返回生成器对象。 
# 列表推导式：一次性生成所有元素，占内存
lst = [i**2 for i in range(1000000)]  # 百万级数据，占用大量内存

# 生成器表达式：惰性生成，几乎不占内存
gen = (i**2 for i in range(1000000))  # 只存生成规则，用时才算

3. 生成器高级用法
send()：向生成器内部传值，作为 yield 的返回值
throw()：向生成器内部抛出异常
close()：主动关闭生成器

四、三者关系一张图
可迭代对象（Iterable）
    └── 迭代器（Iterator）：实现了 __next__
            └── 生成器（Generator）：用 yield / () 创建的简化迭代器

一句话总结：
可迭代对象不一定是迭代器（比如列表、字符串），但都能转成迭代器；
迭代器一定是可迭代对象（因为__iter__返回自己），可以直接 for 循环；
生成器一定是迭代器，是迭代器的语法糖简化版。      

五、为什么要设计这套东西？解决了什么痛点？
1. 统一遍历接口，一套语法通吃所有数据结构
这是经典的迭代器设计模式：把「数据怎么存」和「怎么遍历」解耦。
列表、字典、集合、文件、数据库游标… 底层存储完全不同，但只要实现迭代器协议，都能用 for 循环统一遍历，开发者不用关心内部实现。
2. 惰性计算，极致节省内存
这是最核心的价值。
如果没有迭代器 / 生成器，处理百万级、千万级数据必须一次性全部加载到内存，很容易内存溢出。
生成器只保存生成规则，用一个算一个，内存占用始终为常数级别。
典型场景：读取几个 G 的日志文件，用文件迭代器逐行读取，内存占用只有几 KB。
3. 支持无限序列
列表永远存不下无限个数字，但生成器可以表示无限序列：
def infinite_odd():
    """生成无限奇数序列"""
    n = 1
    while True:
        yield n
        n += 2
你可以不断 next() 取下一个，永远不会结束，也不会占满内存。
4. 流式处理，边生产边消费
数据不需要等全部生成完再处理，可以生成一个处理一个，实现流水线式的数据流处理，这也是 Python 协程（asyncio）的底层基础之一。
六、常见误区总结
❌ 列表是迭代器 → ✅ 列表是可迭代对象，不是迭代器
❌ 迭代器可以反复遍历 → ✅ 迭代器是一次性的，遍历完就空了
❌ 生成器是和迭代器并列的类型 → ✅ 生成器属于迭代器，是特殊实现
❌ 生成器越快越省内存 → ✅ 省内存是真的，但单次执行比列表略慢，是时间换空间的取舍
```

## 内置函数

```py
内置函数：归属 builtins 模块，解释器启动自动导入，高频使用，直接调用；本质是函数对象。
标准库模块 (os/re 等)：Python 自带但不会自动导入，按需手动 import，防止命名污染、节省资源。
第三方库（pytest/requests）：不仅要 import，还得先 pip install 安装。

# Python 常用内置函数 完整分类整理
# ========== 一、数学运算类 ==========
abs(-10)                # 计算绝对值
pow(2, 5)               # 幂运算 2^5
sum([11, 22, 44])       # 可迭代对象求和
divmod(9, 2)            # 返回(商,余数)
round(4.11786, 2)       # 四舍五入，保留指定小数位数
min(11, 2, 3, 4, 5)     # 获取最小值
max(11, 2, 3, 4, 56)    # 获取最大值
all([11, 22, 33, ""])   # 可迭代对象所有元素都为True返回True
any([11, 22, 33, ""])   # 可迭代对象任意一个元素为True返回True

# ========== 二、进制转换类 ==========
bin(10)                 # 十进制转二进制，返回带0b字符串
oct(10)                 # 十进制转八进制，返回带0o字符串
hex(10)                 # 十进制转十六进制，返回带0x字符串

# ========== 三、字符与编码类 ==========
ord("中")               # 获取单个字符的Unicode十进制码点
chr(20013)              # 根据Unicode码点还原为字符
"武沛齐".encode("utf-8") # str转bytes字节类型
bytes("武沛齐", encoding="utf-8") # 字符串转字节

# ========== 四、类型转换类 ==========
int()       # 转为整数
float()     # 转为浮点数
str()       # 转为字符串
bool()      # 转为布尔值
bytes()     # 转为字节类型
list()      # 转为列表
tuple()     # 转为元组
dict()      # 转为字典
set()       # 转为集合

# ========== 五、序列/可迭代对象操作类 ==========
len()               # 获取容器、字符串等长度
range(1, 10)        # 生成整数可迭代序列
enumerate(["a","b"])# 遍历同时返回索引+元素
zip([1,2], ["x","y"])# 多个序列元素配对打包
sorted([3,1,2])     # 可迭代对象排序，返回新列表

# ========== 六、对象属性与类型检测类 ==========
type()              # 获取对象精确数据类型
isinstance()        # 判断对象是否属于某个类/元组类
id()                # 获取对象内存地址
hash()              # 获取可哈希对象的哈希值
callable()          # 判断对象是否可调用（函数、类等）
dir()               # 查看对象所有可用属性、方法
help()              # 查看函数、类的文档说明（终端常用）

# ========== 七、输入输出与文件操作类 ==========
print()             # 控制台输出内容
input()             # 接收用户控制台输入字符串
open()              # 打开文件，进行读写操作

# ========== 八、高阶函数（序列处理） ==========
map()               # 遍历序列，每个元素执行指定函数
filter()            # 根据条件过滤可迭代对象元素
lambda              # 创建匿名函数
```

## python关键字

```python
Python 全部关键字大全（Python3.12，附带逐行注释）
导入内置模块，用来动态获取当前版本所有关键字
import keyword
1. 打印完整关键字列表
print ("=== Python3.12 全部关键字 ===")
all_keywords = keyword.kwlist
遍历输出每个关键字并标注分类说明
for word in all_keywords:
    print(f"{word} | {keyword.iskeyword(word)}")

2. 分类整理 + 单行注释解释每个关键字用途
-------------------------- 1. 控制流程关键字 --------------------------
if /elif/else： 条件判断分支
for /while/break /continue：循环控制
try /except/finally /raise：异常捕获与抛出
match /case：Python3.10+ 模式匹配（高级分支）

-------------------------- 2. 函数 / 类 / 作用域关键字 --------------------------
def：定义函数
class：定义类
return：函数返回值
yield：生成器返回
global：声明全局变量
nonlocal：声明外层嵌套函数变量

-------------------------- 3. 逻辑布尔关键字 --------------------------
and /or/not：逻辑与、或、非
True / False：布尔常量
None：空值常量

-------------------------- 4. 导入模块关键字 --------------------------
import：导入模块
from：从模块导入指定对象
as：导入时起别名

-------------------------- 5. 内存 / 变量操作关键字 --------------------------
del：删除变量、列表元素、对象属性
pass：空占位语句，无实际逻辑
assert：断言校验，用于调试

-------------------------- 6. 上下文 / 异步专用关键字 --------------------------
with：上下文管理器（自动释放资源，文件 / 数据库）
async /await：Python3.7+ 异步 IO 编程专用

-------------------------- 7. 匹配 / 类型相关关键字 --------------------------
is：判断两个对象是否为同一个内存地址
in：判断元素是否存在于容器（列表 / 字符串 / 字典）
lambda：匿名函数
type 不是关键字，是内置函数


补充说明：
1. 关键字不能作为变量名、函数名、类名使用，否则直接报语法错误 SyntaxError
2. Python 版本差异：
- 3.10 新增 match /case
- 3.7 正式稳定 async /await（之前是装饰器形式）
- print /input/type 是内置函数，不属于关键字
3. 查看本机关键字：print (keyword.kwlist)  # import keyword
4. 判断单词是否是关键字：keyword.iskeyword ("if") 返回 True/False
```

## 模块与函数导入

```python
# ===================== 模块与函数导入 核心知识点 =====================
# 模块本质：独立的 .py 文件，用于存放函数、类、变量，实现代码拆分、复用与解耦
# 示例前提：当前目录存在 my_tools.py 模块文件，内部定义了 add()、sub() 两个函数

# ===================== 8.6.1 导入整个模块 =====================
# 语法：import 模块名
# 调用规则：必须通过 模块名.函数名() 的方式调用
import my_tools

res = my_tools.add(10, 20)
# 特点：导入模块全部内容，命名空间相互隔离，不会与当前文件变量重名冲突

# ===================== 8.6.2 导入特定的函数 =====================
# 语法：from 模块名 import 函数名1, 函数名2
# 调用规则：直接使用函数名，无需加模块前缀
from my_tools import add, sub

print(add(5, 3))
# 特点：仅导入需要的函数，调用写法简洁；函数名可能与当前文件重名并被覆盖

# ===================== 8.6.3 使用as给函数指定别名 =====================
# 语法：from 模块名 import 函数名 as 别名
# 适用场景：函数名过长、或与当前代码函数名产生命名冲突时使用
from my_tools import add as calc_add

print(calc_add(2, 7))
# 特点：重命名后避免冲突，也可简化冗长的函数名

# ===================== 8.6.4 使用as给模块指定别名 =====================
# 语法：import 模块名 as 模块别名
# 适用场景：简化长模块名的书写，是工业项目的通用写法
import my_tools as mt

print(mt.add(3, 6))
# 典型案例：import numpy as np、import pandas as pd

# ===================== 8.6.5 导入模块中的所有函数 =====================
# 语法：from 模块名 import *
# 调用规则：直接使用模块内所有公开函数，无需前缀
from my_tools import *

print(add(1, 2))
# 不推荐原因：会一次性导入全部内容，极易和当前变量/函数重名覆盖，问题难以排查
# 仅适用于极简脚本、模块内容极少的场景，正式项目禁止使用

# ===================== 8.7 函数编写指南 =====================
# 1. 命名规范：函数名采用小写+下划线蛇形命名，见名知意，清晰描述函数功能
# 2. 单一职责：一个函数只完成一项功能，逻辑独立，便于复用与维护
# 3. 文档字符串：函数开头用三引号编写注释，说明功能、参数含义、返回值、注意事项
# 4. 参数顺序：必填参数靠左，默认参数靠右；默认参数禁止使用列表、字典等可变类型
# 5. 格式规范：函数体内统一缩进4空格，不同函数之间空两行分隔，提升可读性
# 6. 减少副作用：尽量避免修改全局变量，通过 return 返回结果，降低代码耦合度
```

## 模块

### 自定义模块 > package >  库

```py
从文件角度：单个.py文件叫模块 (module)
多个模块打包在一起的集合包叫库 (library)

三者层级关系
内置对象（print、str） # 内置函数 / 内置类型（print、len、int）属于内置对象
内置模块（os、sys、json → 归属【标准库】）# os 是标准库下的内置模块
第三方库（requests、pandas → pip 安装）


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

### 第三方库

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

### 标准库自带的常用模块

```python
# 1. os：操作系统交互，文件/文件夹、路径、系统命令、环境变量
import os
os.getcwd()          # 获取当前工作目录
os.listdir(".")      # 列出目录下所有文件
os.mkdir("test")     # 创建文件夹
os.path.exists("a.txt") # 判断文件/路径是否存在

# 获取当前脚本文件的绝对路径
abs_path = os.path.abspath(__file__)
# 获取当前脚本所在目录的上一级目录（嵌套两层向上）
base_path = os.path.dirname(os.path.dirname(abs_path))
# 拼接基础路径与文件夹名xx，生成新路径
p1 = os.path.join(base_path,'xx')
# 多层路径拼接，最终指向 a1.png 文件
p2 = os.path.join(base_path,'xx','oo','a1.png')
# 判断p1对应的文件或文件夹是否存在，返回布尔值
exists = os.path.exists(p1)
# 创建指定路径的文件夹，仅能创建最后一级目录
os.makedirs(p1)
# 拼接得到图片文件的完整路径
file_path = os.path.join(base_path,'xx','uuu.png')
# 判断该路径是否为文件夹，返回布尔值
is_dir = os.path.isdir(file_path)
# 删除指定的单个文件，不能删除文件夹
os.remove("文件路径")
# 递归删除文件夹，无论文件夹内是否有文件都可直接删除
shutil.rmtree(path)

补充说明：
os.makedirs() 支持一次性创建多级目录；os.mkdir() 只能创建单级目录。
os.remove() 仅删文件；删除文件夹用 shutil.rmtree()。

#遍历文件夹下所有文件
import os
data = os.walk("/Users/kanghua/env/python3-base")
for path,folder_list,file_list in data:
    for file_name in file_list:
        file_abs_path = os.path.join(path,file_name)
        ext = file_abs_path.rsplit(".")[-1]
        if ext == "py":
            print(file_abs_path)


# 9. shutil：高级文件操作，文件复制、移动、递归删除文件夹
import shutil os
shutil.copy("1.txt","2.txt")
shutil.rmtree("test_folder") # 递归删除非空文件夹

base_path = os.path.dirname(os.path.abspath(__file__))
shutil.rmtree(path)
shutil.copytree("","") #拷贝文件夹
shutil.copy("","")     #拷贝文件
shutil.move("","")

shutil.make_archive(base_name=r'datafile',format='zip',root_dir=r'files')
# base_name，压缩后的压缩包文件
# format，压缩的格式，例如："zip", "tar", "gztar", "bztar", or "xztar".
# root_dir，要压缩的文件夹路径

shutil.unpack_archive(filename=r'datafile.zip',extract_dir=r'xxxxx/xo',format='zip')
# filename，要解压的压缩包文件
# extract_dir，解压的路径
# format，压缩文件格式


# 2. sys：Python解释器相关，命令行参数、退出程序、模块搜索路径
import sys
sys.argv             # 获取脚本命令行参数列表
sys.exit(1)          # 程序异常退出
sys.path             # Python模块搜索路径

print(sys.version)
print(sys.version_info)
print(sys.version_info.major,sys.version_info.minor,sys.version_info.micro)

print(sys.argv) # argv 执行脚本时，python解析器后面传入的参数

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


# 3. time：时间戳、休眠、简单时间获取
import time
time.time()          # 获取时间戳（秒）
time.sleep(2)        # 程序休眠2秒
time.timezone        #时区

datatime
时间三种格式
    datetime
    字符串
    时间戳

# 4. datetime：时间格式化、日期计算、时区处理（推荐替代time做日期业务）
from datetime import datetime, timedelta
datetime.now()                 # 获取当前时间 # 年,月,日,时,分,秒,微秒
datetime.utcnow()              # 当前UTC时间
from datetime import UTC
datetime.now(UTC)  # 带UTC时区标记的安全时间对象 
# UTC：世界协调时间（Coordinated Universal Time），也叫格林尼治标准时间，是全球统一的零时区基准时间。
# UTC+0：英国伦敦本初子午线所在时区
# 我们中国使用东八区 UTC+8，比 UTC 时间快 8 小时
datetime.strptime("2026-01-01","%Y-%m-%d") # 字符串转时间对象
datetime.now().strftime("%Y-%m-%d %H:%M:%S") # 时间格式化字符串
datetime.now() + timedelta(days=7) # 日期加7天

# datetime格式
from datetime import datetime, timezone, timedelta
# 时间的加减
>>> datetime.now() + timedelta(days=140, minutes=5)
datetime.datetime(2026, 11, 21, 14, 8, 26, 193616)
#当前时间 减 utc时间 
>>> datetime.now() - datetime.utcnow()
datetime.timedelta(seconds=28800)
>>> data= datetime.now() - datetime.utcnow()
>>> print(data.days, data.seconds / 60 / 60, data.microseconds)
0 8.0 0

# 时间字符串 时间戳 datetime 互转
import time
from datetime import datetime, timezone, timedelta
# 字符串 转datatime格式
>>> datetime.strptime("2011-11-11",'%Y-%m-%d')
datetime.datetime(2011, 11, 11, 0, 0)
>>> data=datetime.strptime("2011-11-11",'%Y-%m-%d')
>>> print(data)
2011-11-11 00:00:00
# datetime格式 ----> 转换为字符串格式
datetime.now().strftime("%Y-%m-%d %H:%M:%S")

# 时间戳格式 --> 转换为datetime格式
datetime.fromtimestamp(time.time())
# datetime格式 ---> 转换为时间戳格式
datetime.now().timestamp()



# 5 json模块：实现Python对象与JSON字符串的相互序列化、反序列化
# 序列化两大核心用途：网络接口传输（前后端、服务间调用）、本地文件持久化存储、跨语言数据交互；
# JSON是通用数据交换格式，仅支持：字典、列表、字符串、数字、布尔、null六种类型
# 四个核心方法：dumps、loads、dump、load
json.dumps()  #序列化生成一个字符串
json.loads()  #反序列化生成一个python数据类型
json.dump()   #将数据序列化并写入文件
json.load()   #读取文件中的数据并反序列化成python数据类型

import json
data = {"name":"test"}
json_str = json.dumps(data)    # Python对象转JSON字符串
res = json.loads(json_str)    # JSON字符串转回Python字典


data = [
    {"id": 1, "name": "武沛齐", "age": 18},
    {"id": 2, "name": "alex", "age": 18},
]
# 数据类型 --》 json字符串  称：序列化
## ensure_ascii 默认值为 True, 当 True：中文会被转成 Unicode 转义字符 \uXXXX，肉眼看不懂
res = json.dumps(data)
print(res) # '[{"id": 1, "name": "\u6b66\u6c9b\u9f50", "age": 18}, {"id": 2, "name": "alex", "age": 18}]'
res = json.dumps(data,ensure_ascii=False)
print(res) # '[{"id": 1, "name": "武沛齐", "age": 18}, {"id": 2, "name": "alex", "age": 18}]'

# json --》 数据类型   称： 反序列化
import json
data_string = '[{"id": 1, "name": "武沛齐", "age": 18}, {"id": 2, "name": "alex", "age": 18}]'

data_list = json.loads(data_string)
print(data_list)
------------------------------------------------------
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


# 6 re模块：正则表达式，用来批量匹配、提取、替换、校验字符串
# 支持基础正则（BRE）+ 扩展正则（ERE）
re.findall()  #匹配所有符合规则的内容，返回列表，最常用
re.match()    #从左开始匹配，匹配成功返回一个对象，未匹配成功返回None
re.search()   #浏览整个字符串去匹配第一个，未匹配成功返回None
re.sub()      #替换
re.split()    #分割
re.finditer()  #匹配所有 可以命名分组

import re

# 1. re.findall(正则, 字符串)
# 作用：匹配所有符合规则的内容，返回列表，最常用
s = "a123b45c6"
res = re.findall(r"\d+", s)  # 提取所有数字字符串
# ['123','45','6']

# 2. re.finditer()
# 作用：返回【迭代器对象】，惰性取值，循环时逐个获取匹配结果
# 特点：节省内存，适合超大文本、海量匹配场景；需要用 .group() 取值
res_iter = re.finditer(r"\d", "a123b45c6")
for match in res_iter:
    print(match.group())  # 依次输出 1  2  3 ...


# 2. re.search(正则, 字符串)
# 作用：从左往右匹配第一个符合规则的内容，返回匹配对象；没匹配到返回None
# group() 获取匹配到的内容
ret = re.search(r"\d+", s)
if ret:
    print(ret.group())



# 3. re.match(正则, 字符串)
# 只从字符串开头位置匹配，开头不符合直接返回None
re.match(r"^\d", "123abc")   #匹配到1

# 4. re.sub(正则, 替换内容, 字符串)
# 正则替换，批量替换匹配到的内容
re.sub(r"\d", "0", s)  # 所有数字替换为0

# 5. re.split(正则, 字符串)
# 根据匹配到的内容分割字符串，返回列表
re.split(r"\d+", "a1b2c")  #['a', 'b', 'c']

# 6. re.compile(正则)
# 编译正则表达式，多次复用正则时提升执行效率
pattern = re.compile(r"\d+")
pattern.findall(s)
pattern.search("abc789")

# 常用元字符说明
# \d 数字  \w 字母数字下划线  \s 空白(空格/换行)
# . 任意字符(除换行)  ^开头 $结尾
# + 1次及以上  * 0次及以上  ? 0或1次  {n} 固定n次




# 7. random：随机数、随机抽样、洗牌
import random
random.randint(1,10)    # 1~10随机整数
random.choice([1,2,3])  # 随机选一个元素
random.shuffle([1,2,3]) # 列表随机打乱
random.uniform(1,10) # 随机生成 [1, 10] 区间内的浮点数
random.sample([11,22,33,44,55])  # 从传入的列表中随机抽取1个不重复元素（第二个参数默认是1）


# 8. math：数学常用运算、常数、三角函数
import math
math.pi
math.sqrt(16)
math.ceil(3.2)  # 向上取整



# 10. threading / multiprocessing：多线程、多进程并发
import threading

# 11. urllib：内置网络请求，不用第三方requests，适合简单http接口调用
from urllib import request
resp = request.urlopen("https://www.baidu.com")

# 12. collections：高性能容器扩展（高频面试常用）
from collections import defaultdict, Counter, deque, namedtuple
Counter([1,2,2,3])        # 统计元素频次
deque([1,2,3])            # 双向队列，首尾增删效率远高于list
defaultdict(list)         # 带默认值字典，避免键不存在报错

# 13. functools：高阶函数工具，偏函数、装饰器辅助、递归缓存
from functools import partial, lru_cache

# 14. pickle：Python对象序列化（可保存自定义类、列表、字典到本地文件）
import pickle

# 15. csv：读写csv表格文件
import csv

# 16. logging：日志模块，分级日志、日志持久化、格式化输出
import logging

# 17. hashlib：MD5、SHA256等哈希加密，用于密码摘要、文件校验
import hashlib
hash_object = hashlib.md5() #返回一个hash对象
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

### Python re 默认正则（PCRE 扩展正则）符号大全

```python
Python re 默认正则（PCRE 扩展正则）符号大全
一、元字符（核心特殊符号）
. ^ $ * + ? { } [ ] \ | ( )

. ：任意字符（除换行）→ 任意字符小节
^ ：字符串开头；$：字符串结尾 → 边界符小节
*、+、?、{} ：都在量词小节详细说明
[] ：字符类小节专门讲解
\  ：转义符，配合 \d \w \s 预定义字符类讲解，用来把普通字符升级为特殊规则、把元字符转成普通文本
|  ：或逻辑，放在分组与或小节
() ：分组捕获，放在分组与或小节

1. 边界符
符号    说明
^    匹配字符串开头；多行模式下匹配每行开头
$    匹配字符串结尾；多行模式下匹配每行结尾
\b    单词边界（字母 / 数字 / 下划线和其他字符之间）
\B    非单词边界

2. 量词（控制前面字符出现次数）格
符号    说明
*    出现 0 次 或 多次（≥0）
+    出现 1 次 或 多次（≥1）
?    出现 0 次 或 1 次（最多 1 次）
{n}     精确匹配 n 次
{n,}    至少 n 次
{n,m}    n ~ m 次（包含两端）

贪婪 / 非贪婪（? 修饰量词）
.* 贪婪：尽可能多匹配
.*? 非贪婪：尽可能少匹配

3. 字符类 []
[abc]：匹配 a、b、c 任意一个
[^abc]：取反，匹配除 a、b、c 以外任意字符
[0-9] 数字、[a-z]小写、[A-Z]大写、[a-zA-Z0-9]字母数字

4. 分组与或
(表达式)：分组，捕获匹配内容，可单独提取、复用
(?:表达式)：非捕获分组，只分组不单独存储结果
a\|b：匹配 a 或者 b

5. 任意字符 .
.：匹配除换行 \n 以外任意单个字符
加 re.DOTALL 可让 . 匹配换行

二、预定义字符类（转义简写）
符号    等价    含义
\d    [0-9]    任意数字
\D    [^0-9]    非数字
\w    [a-zA-Z0-9_]    字母、数字、下划线
\W    [^a-zA-Z0-9_]    非单词字符
\s    [ \t\n\r\f\v]    空白字符（空格、制表符、换行等）
\S    非空白字符    

三、常用修饰符（re 标志）
re.I / re.IGNORECASE：忽略大小写匹配
re.M / re.MULTILINE：多行模式，^ $ 匹配每行首尾
re.S / re.DOTALL：. 可以匹配换行符
re.X / re.VERBOSE：正则可以换行、加注释，忽略空格

四、反向引用（分组复用）
\1：引用第 1 个分组匹配到的内容
例：r'(\w)\1' 匹配连续两个相同字符如 aa、bb

五、断言（不消耗字符，只做条件预判）
(?=xxx)：正向先行断言，后面必须是 xxx
(?!xxx)：负向先行断言，后面不能是 xxx
(?<=xxx)：正向后行断言，前面必须是 xxx
(?<!xxx)：负向后行断言，前面不能是 xxx
```

## 自动化运维高频 Python 模块（标准库 + 第三方运维常用）

### 1. 远程执行 Linux Shell 命令模块

#### 1.1 paramiko（运维最常用）

作用：SSH 协议远程连接 Linux 服务器，执行命令、上传下载文件（SFTP）

```python
# 安装：pip install paramiko
import paramiko

# 1. 远程执行shell命令
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(hostname="10.0.0.6", port=22, username="root", password="1")
stdin, stdout, stderr = ssh.exec_command("df -h")
print(stdout.read().decode("utf-8"))
ssh.close()

# 2. SFTP上传/下载文件
sftp = paramiko.Transport(("10.0.0.6",22))
sftp.connect(username="root",password="1")
ftp = paramiko.SFTPClient.from_transport(sftp)
ftp.put("test_name.py","/tmp/test_name.py") # 本地上传到服务器
# ftp.get("/tmp/remote.txt","local_copy.txt") # 服务器下载到本地
ftp.close()
```

#### 1.2 fabric（封装 paramiko，更简洁运维工具）

批量多服务器执行命令、部署脚本，简化运维代码

```python
# pip install fabric
from fabric import Connection

c = Connection(host="10.0.0.6", user="root", connect_kwargs={"password":"1"})
result = c.run("free -h", hide=True)  #hide=True 取消控制台输出
print(result.stdout)
```

#### 1.3 subprocess（本地执行本机 Shell 命令，标准库无需安装）

本机调用 cmd、shell 命令，服务器本地脚本运维必备

```python
import subprocess
# 执行命令，获取输出
res = subprocess.check_output("ls -l", shell=True, encoding="utf-8")
print(res)
# 支持管道、后台执行、超时控制
```

### 2. 配置文件解析 / 生成模块

#### 2.1 configparser（标准库）

解析、生成`.ini`格式配置文件（运维传统配置格式）

```python
import configparser
cfg = configparser.ConfigParser()
# 写入配置
cfg["mysql"] = {"host":"127.0.0.1","port":"3306","user":"root"}
print(type(cfg))
with open("db.ini","w",encoding="utf-8") as f:
    cfg.write(f)
# 读取配置
cfg.read("db.ini",encoding="utf-8")
print(cfg.get("mysql","host"))
```

#### 2.2 pyyaml（YAML 配置，云运维、K8s 最常用）

读写`yaml`配置文件，容器化、自动化平台主流配置格式

```python
# pip install pyyaml
import yaml
# 写入yaml
data = {"env":"prod","db":{"host":"10.0.0.1","port":3306}}
with open("env.yaml","w",encoding="utf-8") as f:
    yaml.dump(data,f,allow_unicode=True)
# 读取yaml
with open("env.yaml","r",encoding="utf-8") as f:
    conf = yaml.safe_load(f)
    print(conf)
```

#### 2.3 python-dotenv

读取`.env`环境变量配置文件，存放密钥、账号，避免硬编码泄露

```python
# .env 文件 提前在项目根目录下创建好
# 这个文件加入到git .ignore 忽略文件里
DB_PASSWORD=root123456
DB_HOST=127.0.0.1
DB_PORT=3306
USER=root
---------------------------------------
# pip install python-dotenv
from dotenv import load_dotenv
import os
## 加载项目根目录下的 .env 文件，把里面配置注入系统环境变量
loaded = load_dotenv()
print("是否成功加载.env文件：", loaded)

## 从系统环境变量中读取配置
db_pwd = os.getenv("DB_PASSWORD")
db_host = os.getenv("DB_HOST")
print("数据库密码：", db_pwd)
print("数据库地址：", db_host)
```

### 3. 系统信息采集运维模块

#### 3.1 psutil（系统资源监控神器）

采集 CPU、内存、磁盘、网络、进程、开机时间，做监控告警脚本必备

```python
# pip install psutil
import psutil
print(psutil.cpu_percent(interval=1))      # CPU使用率
print(psutil.virtual_memory().percent)       # 内存使用率
print(psutil.disk_usage("/").percent)       # 磁盘使用率
print(psutil.net_io_counters())       # 网络流量
print(psutil.process_iter())       # 遍历所有进程
```

#### 3.2 platform（标准库）

获取操作系统版本、内核、架构信息

```python
import platform
print(platform.system())        # Windows/Linux
print(platform.uname())        # 系统详细信息
```

### 4. 日志运维模块：logging（标准库）

程序日志分级存储、按大小 / 时间切割，线上运维排查故障必备

```python
import logging
logging.basicConfig(
    filename="ops.log",
    format="%(asctime)s %(levelname)s %(message)s",
    level=logging.INFO
)
logging.info("运维脚本正常执行")
logging.error("服务器连接失败")
```

### 5. 定时运维任务模块

#### 5.1 schedule（轻量定时任务）

代替 crontab 简单定时巡检、备份、日志清理

```python
# pip install schedule
import schedule,time
def task():
    print("执行服务器巡检")
schedule.every().day.at("02:00").do(task)
while True:
    schedule.run_pending()
    time.sleep(60)
```

#### 5.2 APScheduler（企业级定时框架）

支持秒 / 分 / 时 / 日、cron 表达式、多任务持久化，运维平台定时任务首选

```python
一、核心优势
三种调度器：固定间隔 (interval)、固定日期 (date)、类 Cron 表达式 (cron)，覆盖所有定时场景
支持任务持久化：内存、Redis、MySQL、MongoDB，重启不丢失任务
支持任务并发控制、最大运行时长、错过任务补执行、任务启停管理
分布式场景可通过持久化存储实现多节点任务互斥，运维、后台系统广泛使用
# pip install apscheduler
from apscheduler.schedulers.background import BackgroundScheduler

# 1. 创建后台调度器（不阻塞主线程）
scheduler = BackgroundScheduler()

# 待执行任务
def task():
    print("执行运维巡检任务")

# 方式1：interval 间隔调度（每隔N秒/分钟执行）
# 每30秒执行一次
scheduler.add_job(task, "interval", seconds=30)
# 每1小时执行一次
# scheduler.add_job(task, "interval", hours=1)

# 方式2：date 一次性定时任务，指定时间只执行一次
# from datetime import datetime
# run_time = datetime(2026, 12, 1, 14, 30)
# scheduler.add_job(task, "date", run_date=run_time)

# 方式3：cron 类Linux crontab表达式（企业最常用）
# 每天凌晨2点执行
scheduler.add_job(task, "cron", hour=2, minute=0)
# 每周一早上9点30分执行
# scheduler.add_job(task, "cron", day_of_week="mon", hour=9, minute=30)

# 启动调度器
scheduler.start()

# 保持主线程运行
try:
    while True:
        time.sleep(60)
except KeyboardInterrupt:
    scheduler.shutdown()




# 持久化配置（MySQL 存储任务，服务重启任务不丢失）#不用
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.jobstores.sqlalchemy import SQLAlchemyJobStore

# 配置数据库存储
jobstores = {
    "default": SQLAlchemyJobStore(url="mysql+pymysql://root:123@127.0.0.1:3306/ops_db")
}
scheduler = BackgroundScheduler(jobstores=jobstores)
```

### 6. 运维文件处理扩展模块

#### shutil（标准库）python

高级文件操作：文件夹递归复制、压缩、移动、删除

```python
import shutil 
# 1. 复制文件
# src源文件 dst目标路径/文件名
shutil.copy("test.txt", "./bak/")          # 复制文件，权限不保留
shutil.copy2("test.txt", "./bak/")         # 复制文件+保留文件元信息(创建时间、权限)

# 2. 复制整个文件夹(递归复制)
shutil.copytree("source_dir", "target_dir")

# 3. 移动/重命名 文件或文件夹
shutil.move("a.txt", "./data/")
shutil.move("old_name", "new_name")

# 4. 删除文件夹(递归删除，os.rmdir只能删空文件夹)
shutil.rmtree("temp_dir")

# 5. 压缩打包
# 格式支持 zip、tar、gztar、bztar
# base_name:压缩包名 format:压缩格式 root_dir:要压缩的目录
shutil.make_archive("backup", "zip", root_dir="./data")

# 6. 解压压缩包
shutil.unpack_archive("backup.zip", extract_dir="./restore")

# 7. 获取磁盘总空间、已用、可用空间
total, used, free = shutil.disk_usage("/")

# 8. 查询文件/文件夹所属终端程序(Windows常用) #返回python绝对路径
shutil.which("python")
```

#### zipfile/tarfile（标准库）

压缩包解压、打包，运维日志 / 数据备份常用

```python
# zipfile 压缩解压 .zip 格式（跨平台Windows/Linux通用）
import zipfile

# 1. 压缩文件
with zipfile.ZipFile("files.zip", "w", zipfile.ZIP_DEFLATED) as zf:
    zf.write("a.txt")                  # 添加单个文件
    zf.write("test/b.txt", "b.txt")    # 自定义压缩内路径

# 2. 查看压缩包内文件列表
with zipfile.ZipFile("files.zip", "r") as zf:
    print(zf.namelist())

# 3. 解压全部文件到指定目录
with zipfile.ZipFile("files.zip") as zf:
    zf.extractall("./unzip_dir")

# 4. 解压单个文件
zf.extract("a.txt", "./out")

# 5. 读取压缩包内文件内容（不解压）
with zipfile.ZipFile("files.zip") as zf:
    data = zf.read("a.txt").decode("utf-8")


# tarfile 打包 .tar/.tar.gz/.tar.bz2（Linux运维常用）
import tarfile

# 1. 打包压缩 tar.gz
with tarfile.open("data.tar.gz", "w:gz") as tar:
    tar.add("a.txt")
    tar.add("test_dir")

# 2. 查看包内文件
with tarfile.open("data.tar.gz", "r:gz") as tar:
    print(tar.getnames())

# 3. 全部解压
tar.extractall(path="./tar_out")

# 4. 解压单个文件
tar.extract("a.txt", "./tar_out")

# 5. 不解压读取文件
with tarfile.open("data.tar.gz") as tar:
    f = tar.extractfile("a.txt")
    content = f.read().decode("utf-8")
```

### 7. 接口运维模块：requests

调用监控平台、CMDB、钉钉 / 企业微信告警接口，批量推送运维异常消息

```python
# pip install requests
import requests
webhook = "钉钉告警地址"
requests.post(webhook,json={"msgtype":"text","text":{"content":"磁盘使用率过高"}})
```

### 8. 进程管理模块

#### subprocess + psutil：进程启停、端口查杀、服务自动化部署

```bash
# 一、subprocess：本地执行shell命令，启停进程、调用系统程序
import subprocess

# 1. 执行命令，获取标准输出、错误输出
# shell=True 支持管道、通配符；Windows可用cmd命令
res = subprocess.run(
    "ipconfig",
    shell=True,
    capture_output=True,
    encoding="utf-8"
)
print(res.stdout)
print(res.stderr)
print(res.returncode)  # 0执行成功，非0异常

# 2. 阻塞启动程序（等待程序运行结束才往下走）
# subprocess.run(["notepad.exe"])

# 3. 后台异步启动进程（不阻塞主线程，常用于服务启动）
p = subprocess.Popen(["python", "server.py"])
# 获取进程PID
print(p.pid)
# 结束进程
p.terminate()
# 强制杀进程
# p.kill()


# 二、psutil：根据端口、进程名查杀进程
import psutil

# 1. 通过端口查找PID
def get_pid_by_port(port):
    for conn in psutil.net_connections():
        if conn.laddr.port == port and conn.status == psutil.CONN_LISTEN:
            return conn.pid
    return None

# 2. 根据PID杀死进程
def kill_process_by_port(port):
    pid = get_pid_by_port(port)
    if pid:
        proc = psutil.Process(pid)
        proc.terminate()
        print(f"端口{port}进程已关闭")

# 3. 根据进程名称批量查杀
def kill_process_by_name(name):
    for proc in psutil.process_iter(["pid", "name"]):
        if proc.info["name"] and name in proc.info["name"]:
            proc.kill()

# 三、自动化部署示例：停止旧服务→清理端口→启动新服务
def deploy_server(port):
    # 1. 查杀占用端口的旧进程
    kill_process_by_port(port)
    # 2. 后台启动服务
    subprocess.Popen(["python", "app.py"])
    print("服务部署完成")
```

#### supervisor 第三方：Python 进程托管，后台守护进程运维

```bash
# 1. 安装
# pip install supervisor

# 2. 核心作用
# 守护进程托管：监控Python程序，异常崩溃自动重启、后台常驻、日志收集、启停管理
# linux 命令行执行的 
# 3. 常用命令

"""
supervisord -c supervisord.conf      # 启动服务端
supervisorctl -c supervisord.conf    # 客户端管理
status                               # 查看进程状态
start 进程名
stop 进程名
restart 进程名
update                               # 加载新增配置
tail -f 进程名                       # 实时查看日志
"""

# 4. 最简配置 supervisord.conf
"""
[program:demo]
command=python3 /opt/app/main.py
directory=/opt/app
autostart=true
autorestart=true
stdout_logfile=/opt/log/demo.log
stderr_logfile=/opt/log/demo_err.log
user=root
"""

# 5. 运维优势
# 1. 进程意外退出自动重启，保障服务高可用
# 2. 统一管理多个进程，集中查看日志
# 3. 支持开机自启、分组批量启停
# 4. 相比nohup、&，可管控进程，防止僵尸进程
```

### 9. 云原生运维常用

- kubernetes：`kubernetes` SDK，调用 K8s API 管理 Pod、Deployment、服务

```bash
# 1.安装SDK
# pip install kubernetes

# 2.两种认证方式
## 方式1：集群内Pod中运行，自动加载serviceaccount证书（无需配置kubeconfig）
from kubernetes import client, config
config.load_incluster_config()

## 方式2：本地/集群外，加载~/.kube/config文件
config.load_kube_config()

# 3.核心客户端
core_api = client.CoreV1Api()          # 管理Pod、Service、Namespace、ConfigMap等
apps_api = client.AppsV1Api()          # 管理Deployment、StatefulSet、DaemonSet

# 4.常用示例
# 4.1 获取所有命名空间下Pod
pod_list = core_api.list_pod_for_all_namespaces(watch=False)
for pod in pod_list.items:
    print(f"命名空间:{pod.metadata.namespace} Pod名:{pod.metadata.name}")

# 4.2 获取指定命名空间Deployment列表
deploy_list = apps_api.list_namespaced_deployment(namespace="default")
for deploy in deploy_list.items:
    print(f"部署名:{deploy.metadata.name} 副本数:{deploy.spec.replicas}")

# 4.3 扩容Deployment
body = {"spec": {"replicas": 3}}
apps_api.patch_namespaced_deployment_scale(
    name="demo-deploy",
    namespace="default",
    body=body
)

# 4.4 删除Pod
core_api.delete_namespaced_pod(name="test-pod", namespace="default")
```

- boto3：AWS 云服务器、对象存储运维 SDK
- aliyun-python-sdk：阿里云资源自动化管理

## 运维模块选型精简总结

1. 远程 SSH 批量运维：`paramiko`、`fabric`
2. 配置文件：`configparser(ini)`、`pyyaml(yaml)`、`python-dotenv(.env)`
3. 服务器监控采集：`psutil`
4. 定时巡检备份：`schedule`、`APScheduler`
5. 本机 Shell 执行：`subprocess`
6. 告警推送：`requests` + 企业微信 / 钉钉
7. 文件批量处理：`shutil`、`zipfile`

## 面向对象

```python
# ===================== Python 面向对象编程（OOP）核心全集 =====================
# 核心思想：将数据（属性）和操作数据的方法封装到类中，以对象为基本单位组织代码
# 类（Class）：抽象模板，定义一类事物的共同属性和行为
# 对象/实例（Instance）：根据类创建的具体个体，拥有类定义的全部属性和方法
# Python 所有类默认继承 object 基类
""""
OOP 全称：Object-Oriented Programming
中文：面向对象编程
补充两个常对比概念：
POP：Procedure-Oriented Programming，面向过程编程
FP：Functional Programming，函数式编程
"""
# ===================== 一、类的定义与实例化 =====================
class Person:
    # __init__ 构造方法：创建对象时自动执行，用于初始化实例属性
    # self 代表当前实例对象本身，必须是实例方法的第一个参数
    def __init__(self, name, age):
        # 实例属性：每个对象独有的数据，绑定到 self 上
        self.name = name
        self.age = age

    # 实例方法：操作实例自身数据
    def say_hello(self):
        print(f"你好，我是{self.name}，今年{self.age}岁")


# 创建实例对象
p1 = Person("张三", 22)
p2 = Person("李四", 25)

# 访问属性、调用方法
print(p1.name)
p1.say_hello()
p2.say_hello()


# ===================== 二、属性分类：实例属性 vs 类属性 =====================
class Student:
    # 类属性：定义在类内部、方法外部，所有实例共享一份
    school = "清华大学"
    count = 0

    def __init__(self, name):
        self.name = name  # 实例属性，每个对象独有
        Student.count += 1  # 通过类名修改类属性，统计实例总数


# 类属性访问：类名.属性名 或 实例.属性名 均可读取
print(Student.school)
s1 = Student("小明")
print(s1.school)   # 实例可读取类属性，但不能直接修改
print(Student.count)  # 1

# 注意：实例不要直接赋值修改类属性，会创建同名实例属性，覆盖类属性访问


# ===================== 三、方法分类：实例方法、类方法、静态方法 =====================
class Demo:
    # 1. 实例方法：第一个参数 self，访问/修改实例属性，只能通过对象调用
    def instance_method(self):
        print("实例方法", self)

    # 2. 类方法：@classmethod 装饰，第一个参数 cls（代表类本身），可访问类属性
    @classmethod
    def class_method(cls):
        print("类方法", cls)

    # 3. 静态方法：@staticmethod 装饰，无强制参数，和类关联但不访问类/实例数据
    @staticmethod
    def static_method():
        print("静态方法")


# 调用方式
Demo.class_method()   # 类直接调用类方法
Demo.static_method()  # 类直接调用静态方法
d = Demo()
d.instance_method()   # 实例调用实例方法

# 适用场景：
# 实例方法：操作实例自身数据
# 类方法：修改类属性、工厂方法创建实例
# 静态方法：工具类函数，和类相关但不需要类/实例数据


# ===================== 四、三大特性之：封装 =====================
# 封装：隐藏内部实现细节，只对外暴露有限接口，保证数据安全
# Python 通过命名约定实现访问控制：
# 公共属性：正常命名，外部自由访问
# 保护属性：_xxx 单下划线开头，约定私有，语法仍可访问，提醒外部慎用
# 私有属性：__xxx 双下划线开头，名称改写，外部无法直接通过原名访问

class User:
    def __init__(self, username, password):
        self.username = username      # 公共属性
        self._password = password     # 保护属性，约定私有
        self.__id_card = "12345678"   # 私有属性，强制隐藏
        # 双下划线本质：名称改写为 _类名__属性名，强行也能访问但不推荐

    # 对外提供访问/修改私有属性的接口
    def get_id_card(self):
        return self.__id_card[:4] + "****"  # 脱敏返回

    def set_id_card(self, new_id):
        if len(new_id) == 18:
            self.__id_card = new_id
        else:
            print("身份证号不合法")

    # property 装饰器：把方法变成属性一样调用，更优雅的读写控制
    @property
    def password(self):
        return "***"  # 只读，不返回真实密码

    @password.setter
    def password(self, new_pwd):
        if len(new_pwd) >= 6:
            self._password = new_pwd
        else:
            print("密码长度不足6位")


u = User("zhangsan", "123456")
print(u.username)
print(u.get_id_card())
u.password = "654321"  # 调用 setter
print(u.password)      # 调用 getter


# ===================== 五、三大特性之：继承 =====================
# 继承：子类拥有父类的所有属性和方法，实现代码复用，可扩展新功能、重写父类方法
# 语法：class 子类名(父类名):

# 父类（基类）
class Animal:
    def __init__(self, name):
        self.name = name

    def eat(self):
        print(f"{self.name} 在吃东西")


# 子类（派生类）：单继承
class Dog(Animal):
    def bark(self):
        print(f"{self.name} 在汪汪叫")

    # 方法重写：子类方法名和父类相同，覆盖父类方法
    def eat(self):
        print(f"{self.name} 啃骨头")


# 多继承：子类可以继承多个父类
class Cat(Animal):
    def catch_mouse(self):
        print(f"{self.name} 抓老鼠")


class Husky(Dog, Cat):
    def demolish_home(self):
        print(f"{self.name} 拆家")


# super() 调用父类方法，扩展功能不覆盖
class Student(Person):
    def __init__(self, name, age, stu_id):
        # 调用父类构造方法，初始化继承的属性
        super().__init__(name, age)
        self.stu_id = stu_id  # 子类新增属性


# MRO 方法解析顺序：多继承时查找方法的优先级顺序
print(Husky.__mro__)


# ===================== 六、三大特性之：多态 =====================
# 多态：不同类的对象，调用同一个方法，表现出不同的行为
# 前提：继承 + 方法重写
# Python 是动态语言，遵循「鸭子类型」：不关心类型，只关心有没有对应方法

def feed_animal(animal):
    animal.eat()


dog = Dog("大黄")
cat = Cat("咪咪")
feed_animal(dog)  # 大黄 啃骨头
feed_animal(cat)  # 咪咪 在吃东西


# 鸭子类型示例：只要有 eat 方法就能传入，不需要继承 Animal
class Car:
    def eat(self):
        print("汽车加油")

feed_animal(Car())  # 正常执行


# ===================== 七、常用魔法方法（特殊方法） =====================
# 前后双下划线的方法，Python 自动触发，自定义类的内置行为
class Book:
    def __init__(self, title, price):
        self.title = title
        self.price = price

    # __str__：print(对象) 时触发，返回友好字符串，给用户看
    def __str__(self):
        return f"《{self.title}》 价格：{self.price}元"

    # __repr__：调试/交互环境显示，给开发者看
    def __repr__(self):
        return f"Book('{self.title}', {self.price})"

    # __del__：对象被垃圾回收时自动调用（析构方法）
    def __del__(self):
        print(f"{self.title} 对象被销毁")


b = Book("Python入门", 59)
print(b)  # 触发 __str__

------------------------------------------
# __init__ 

# __new__
class Foo(object):
    def __init__(self, name):
        print("第二步：初始化对象，在空对象中创建数据")
        self.name = name
    def __new__(cls, *args, **kwargs):
        print("第一步：先创建空对象并返回")
        return object.__new__(cls)

obj = Foo("武沛齐")
-----------------------------
# __call__
class Foo(object):
    def __call__(self, *args, **kwargs):
        print("执行call方法")

obj = Foo()
obj()  #执行 __call__方法
-----------------------------
# __str__
class Foo(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age

obj = Foo("武沛齐",19)
print(obj.__dict__)  #{'name': '武沛齐', 'age': 19}
-------------------------------
# __dict__    #类的属性（包含一个字典，由类的数据属性组成）

class Foo(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age
obj = Foo("武沛齐",19)
print(obj.__dict__)  #{'name': '武沛齐', 'age': 19}

----------------------
# __enter__   
# __exit___

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

# __add__    #加运算
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

# __iter__
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

-------------生成器对象
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

## Python 面向对象所有成员

```bash
Python 面向对象所有成员（属性 + 方法 + 特殊成员）
一、属性（数据成员）
1. 实例属性
定义位置：__init__构造方法中，self.属性名
归属：每个实例独有，不同实例互不干扰
访问：对象.属性

2. 类属性
定义位置：类内部、所有方法外部
归属：属于类，所有实例共享同一份数据
访问：类名.属性 / 对象.属性（仅可读，实例赋值会生成同名实例属性）
访问权限（命名约定）
公共属性：name，内外均可访问
保护属性：_name，约定仅类内部、子类使用，外部可强行访问
私有属性：__name，名称重命名为_类名__name，外部无法直接访问

二、方法（函数成员）
1. 实例方法
标记：第一个参数固定self（当前实例）
调用：仅对象调用
权限：可操作实例属性、类属性
2. 类方法
装饰器：@classmethod，第一个参数固定cls（当前类）
调用：类调用 / 对象调用均可
权限：只能操作类属性，无法直接访问实例属性
3. 静态方法
装饰器：@staticmethod，无默认参数
调用：类调用 / 对象调用均可
权限：不能直接操作类、实例属性，仅做工具逻辑
4. 属性方法（property 装饰器）
将方法伪装成属性调用，用于私有属性的安全读写、数据校验
@property：只读获取
@xxx.setter：修改赋值
@xxx.deleter：删除属性

三、魔法成员（双下划线特殊方法 / 内置属性）
常用魔法方法
__init__(self)：构造方法，实例化时初始化属性
__del__(self)：析构方法，对象被垃圾回收时执行
__str__(self)：print 打印对象返回自定义字符串
__repr__(self)：交互式控制台对象展示
__call__(self)：对象可以像函数一样 对象() 调用
__getitem__/__setitem__：支持对象用[]取值赋值
__enter__/__exit__：上下文管理器with语法
内置魔法属性
__class__：获取对象所属类
__dict__：查看实例 / 类内部所有属性字典
__name__：类名
__base__：直接父类
__bases__：所有父类元组
__mro__：多继承方法查找顺序

四、成员归属速记
实例成员（实例属性、实例方法）：属于对象
类成员（类属性、类方法、静态方法、property）：属于类
私有成员仅类内可见，公共成员全场景可访问

-----------------------------------------------------
# 面向对象所有成员完整演示
class Student:
    # ========== 1. 类属性（类成员，所有实例共享） ==========
    school = "北京大学"  # 公共类属性
    _class_num = 3       # 保护类属性：约定类、子类内使用
    __class_secret = "内部编码001"  # 私有类属性，外部无法直接访问

    def __init__(self, name, age):
        # ========== 2. 实例属性（每个对象独有） ==========
        self.name = name        # 公共实例属性
        self._age = age         # 保护实例属性
        self.__id = "2026001"   # 私有实例属性

    # ========== 3. 实例方法（必须self，操作实例/类属性） ==========
    def show_info(self):
        print(f"姓名:{self.name},年龄:{self._age},学校:{Student.school}")

    # ========== 4. 类方法（@classmethod，必须cls，仅能操作类属性） ==========
    @classmethod
    def get_school(cls):
        return cls.school

    @classmethod
    def modify_school(cls, new_school):
        cls.school = new_school

    # ========== 5. 静态方法（@staticmethod，无默认参数，工具函数） ==========
    @staticmethod
    def check_age(age):
        return 12 <= age <= 30

    # ========== 6. property属性方法：把方法伪装成属性，控制私有成员读写 ==========
    @property
    def id_card(self):
        # 只读，脱敏返回
        return self.__id[:4] + "****"

    @id_card.setter
    def id_card(self, new_id):
        if len(new_id) == 7:
            self.__id = new_id
        else:
            print("学号格式错误")

    # ========== 7. 常用魔法方法（前后双下划线） ==========
    def __str__(self):
        return f"学生对象：{self.name}"

    def __del__(self):
        print(f"{self.name}对象被销毁")

    def __call__(self):
        print("对象被当作函数调用")


# 1.实例化
s1 = Student("小明", 18)

# 访问实例属性
print(s1.name)
# 保护属性约定不外部访问，私有属性无法直接访问
# print(s1.__id)

# 调用实例方法
s1.show_info()

# 类方法调用
print(Student.get_school())
Student.modify_school("复旦大学")

# 静态方法调用
print(Student.check_age(18))
print(Student.check_age(35))

# property属性方式读写
print(s1.id_card)
s1.id_card = "2026005"
print(s1.id_card)

# 魔法方法触发
print(s1)   # 触发__str__
s1()        # 触发__call__

# 内置魔法属性
print(s1.__class__)
print(Student.__dict__)
print(Student.__name__)
print(Student.__bases__)
```

## Python 函数与面向对象：底层原理与设计哲学

```bash
Python 函数与面向对象：底层原理与设计哲学
Python 的函数与 OOP 并非语法层面的简单封装，其背后是一套高度统一的「一切皆对象」模型，以及「实用主义优先、不执着于范式纯粹」的设计思想。理解到这个层级，你才能看懂框架源码、写出 Pythonic 的代码，而不是停留在「语法怎么写」的表层。

一、函数：从字节码到一等公民

1. 底层本质：函数是堆上的普通对象
Python 中函数没有任何特殊地位，它和 int、list、字典一样，都是堆内存中的对象。
核心是两个底层对象的分离：
PyCodeObject（代码对象）：存储函数的字节码指令、常量池、变量名表、行号映射，是「静态的代码本身」，同一个函数定义只会生成一份代码对象。
PyFunctionObject（函数对象）：运行期创建的实例，包裹代码对象，并绑定运行环境：全局命名空间、默认参数、闭包自由变量、函数名 / 文档等元信息。
这就是为什么函数可以被赋值、当作参数传递、作为返回值、塞进列表里 ——它和普通数据没有任何本质区别，这也是「函数是一等公民」的底层含义。

你可以直接触达它的底层属性：

def add(a, b=10):
    return a + b

print(add.__code__)      # 代码对象，存字节码
print(add.__defaults__)  # 默认参数元组
print(add.__globals__)   # 绑定的全局命名空间
print(add.__closure__)   # 闭包自由变量，非闭包为None

2. 函数调用的真相：栈帧与可挂起的执行流
每调用一次函数，Python 都会在堆内存中创建一个栈帧对象（PyFrameObject），而不是像 C 语言那样在系统栈上分配。
栈帧里存着：局部变量表、求值栈、指令指针（当前执行到哪条字节码）、返回地址、上一层栈帧的引用。
这个设计带来了两个深远影响：
递归深度受限：Python 有默认递归深度限制（约 1000 层），不是因为栈溢出，而是解释器主动做了保护，避免无限制创建栈帧对象。
执行流可挂起恢复：因为栈帧在堆上，函数可以执行到一半暂停、保存栈帧、之后再恢复 —— 这就是生成器、协程（async/await）的底层基石，C 语言的函数根本做不到。

3. 闭包与装饰器：不是语法糖，是环境的封装
闭包的本质：函数 + 它捕获的自由变量环境。自由变量存在 cell 对象里，通过 __closure__ 属性关联，实现了「函数退出后，变量依然存活」的效果。
装饰器的本质：高阶函数的语法糖，用「函数包裹函数」的方式，在不修改原函数代码、不改变调用方式的前提下扩展功能。
functools.wraps 的价值：解决装饰后函数元信息（函数名、文档、参数签名）丢失的问题，本质是把原函数的属性拷贝到包装函数上。

4. 函数的设计哲学
一等公民原则：消除函数与数据的边界，赋予极致的灵活性。这也是装饰器、回调、函数式编程特性的基础。
显式优于隐式：最典型的就是 self 必须显式写在方法第一个参数里。Python 没有隐藏的 this 指针，方法和普通函数本质完全统一，只是调用时自动传入第一个参数。
实用主义的多范式融合：Python 不是纯函数式语言，它以命令式为主体，只吸收函数式最有价值的部分 —— 高阶函数、生成器、推导式，不追求无副作用、不可变数据等纯粹性，兼顾开发效率和可读性。

二、面向对象：从元类到鸭子类型
Python 的 OOP 和 Java、C++ 有着本质区别：它没有强制的封装、没有接口语法、多继承是一等公民、类型检查靠行为不靠声明。这不是残缺，而是刻意的设计选择。

1. 底层基石：一切皆对象，类也是对象
这是 Python 对象模型最核心的认知：
普通实例是类的实例
类本身也是对象，是元类 type 的实例
type 自己也是自己的实例，构成类型金字塔的顶端
对应的内存结构：
实例对象：靠 __dict__ 字典存储自身属性，非常轻量，只存数据，不存方法。
类对象：__dict__ 里存方法、类属性、魔法方法，所有实例共享类的方法，节省内存。
属性查找的完整链路（从左到右，找到即停止）：
实例自身 __dict__ → 类的 __dict__ → 按 MRO 顺序遍历所有父类的 __dict__ → 触发 __getattr__ 兜底

2. self 与方法的真相
self 不是关键字，只是约定俗成的第一个参数名，你改成 this、me 也完全能运行。
「实例。方法 ()」自动传入 self，是描述符协议的效果：类里的函数是一个非数据描述符，通过实例访问时，会自动把实例和函数绑定成「绑定方法（Bound Method）」，调用时自动把 self 作为第一个参数传入。
类方法（@classmethod）、静态方法（@staticmethod）也是同理：它们是不同的描述符，分别绑定类对象、不绑定任何对象，实现了参数的差异化。
3. 继承、MRO 与 super () 的真相
绝大多数人对 super() 的理解都是错的：
❌ 错误：super() 是调用「父类」的方法
✅ 正确：super() 是调用「MRO 线性化链上的下一个类」的方法
MRO（方法解析顺序）采用 C3 线性化算法，解决了多继承的菱形二义性问题，保证每个类在链中只出现一次，且满足「子类先于父类、声明顺序优先」的规则。
super() 的设计初衷不是为了「少写父类名」，而是为了在多继承场景下保证调用链正确、不重复、不遗漏—— 这也是 Mixin 模式能正常工作的基础。

4. 魔法方法与协议编程：Python OOP 的灵魂
Python 没有 interface 关键字，它的面向对象核心是协议（Protocol）：
只要实现了 __iter__ + __next__，就是迭代器
只要实现了 __enter__ + __exit__，就能用 with 语法
只要实现了 __getitem__，就能用下标 [] 访问
只要实现了 __call__，对象就能像函数一样被调用
这就是鸭子类型的底层支撑：不检查你是什么类型，只检查你有没有对应的行为。不需要继承某个基类、不需要声明实现某个接口，只要满足协议约定，就能被对应语法使用。
这种设计带来了极致的解耦和灵活性，也是 Python 生态丰富的重要原因 —— 第三方库很容易无缝接入语言原生语法。

5. 元类：类的创造者，99% 场景不需要
元类是「类的类」，默认元类是 type，所有普通类都是 type 创建出来的。
元类可以拦截类的创建过程：修改类属性、注入方法、校验类结构，Django ORM、SQLAlchemy 等框架的核心魔法就来自元类。
设计哲学上的明确态度：元类是黑魔法，普通开发者 99% 的场景都不需要。Python 官方的建议是：能用装饰器、Mixin 解决的，就不要用元类。它的复杂度远高于收益，只会让代码变得难以维护。

6. 面向对象的设计哲学
鸭子类型优先于接口：行为重于身份，灵活胜于严谨。不做强制类型约束，靠约定而非语法保证协作，大幅降低了代码的耦合度。
我们都是成年人：没有真正的私有变量。_xxx 是约定的内部变量，__xxx 只是名称改写，并不是强制私有。Python 相信开发者的自律，不用语法强制限制访问权限，避免了过度封装带来的僵化。
组合优于继承：Python 虽然支持多继承，但社区共识是「优先用组合，少用继承，必要时用 Mixin」。继承是强耦合的白盒复用，组合是弱耦合的黑盒复用，扩展性和可维护性天差地别。
协议驱动，而非继承驱动：能力通过实现魔法方法获得，而非继承抽象基类。这让 Python 的 OOP 非常轻量，不需要为了一个能力就引入一整套继承体系。

三、贯穿始终的核心设计思想
高度统一的对象模型：函数、类、实例、模块、甚至异常，全都是对象，遵循同一套属性查找、引用计数、垃圾回收规则。一致性带来了极低的认知成本，也赋予了极强的动态扩展能力。
透明而非黑盒：底层机制不刻意隐藏。你可以通过 __code__、__dict__、__mro__ 直接触及对象的底层结构，想深入就能深入，日常使用又感知不到复杂度。
拒绝教条，实用至上：不执着于某一种编程范式，不追求理论上的纯粹。函数式、面向对象、命令式、过程式，哪种场景好用就用哪种。这也是 Python 能覆盖从脚本到大型系统全场景的核心原因。
默认简单，上限极高：新手可以快速上手写业务代码，高手可以用描述符、元类、协程实现复杂框架。语言本身不设天花板，但把复杂能力藏在底层，默认路径永远是最简单的。
```

堆(Heap)和栈(Stack)

```bash
# === 核心结论 ===
# 堆(Heap)和栈(Stack)是操作系统划分的两块内存区域，几乎所有编程语言都基于二者管理内存
# 栈负责临时、自动回收的数据；堆负责长期、灵活的数据

# === 栈 Stack ===
# 结构：后进先出，由操作系统自动分配、自动回收
# 生命周期：与函数绑定，函数调用时分配，函数结束立即释放
# 特点：空间小（几MB）、速度极快、无内存碎片
# 存放内容：函数参数、局部变量、返回地址、调用上下文
# 类比：厨房操作台，用完即清

# === 堆 Heap ===
# 结构：无序大块内存，由手动申请或垃圾回收器管理
# 生命周期：灵活可控，不会随函数结束自动销毁
# 特点：空间大（GB级）、速度较慢、易产生内存碎片
# 存放内容：对象、大数组、需跨函数长期存活的数据
# 类比：储物仓库，需主动清理或等保洁（GC）回收

# === Python 特殊设计（与C语言核心差异）===
# C语言：函数栈帧直接放在系统栈上，函数结束即清空，执行流无法中途暂停
# Python：解释器自行在堆上创建栈帧对象(PyFrameObject)，模拟函数调用栈
# 核心收益：栈帧可保存、可恢复，是生成器(yield)、协程(async/await)的底层基础
# 补充：Python递归深度限制是解释器主动限制，并非系统栈溢出

# === 回扣Python核心特性 ===
# 1. 一切皆对象：函数、类、变量值全部存在堆上，函数天然是一等公民
# 2. 闭包生效原理：自由变量随函数对象存在堆上，外层函数结束仍可保留
# 3. 强动态性：栈帧、对象全在堆上，支持运行时修改、执行流暂停恢复
```

## 模块与类的导入

```python
新建模块文件 car.py，里面定义多个类

# car.py
class Car:
    def __init__(self, make, model, year):
        self.make = make
        self.model = model
        self.year = year

    def get_descriptive_name(self):
        return f"{self.year} {self.make} {self.model}"

class ElectricCar(Car):
    def __init__(self, make, model, year, battery_size=75):
        super().__init__(make, model, year)
        self.battery_size = battery_size

    def describe_battery(self):
        print(f"电池容量：{self.battery_size}kWh")


9.4.1 导入单个类
# 从car模块只导入Car类
from car import Car

my_car = Car("Audi", "A6", 2025)
print(my_car.get_descriptive_name())

9.4.2 在一个模块中存储多个类
如上 car.py 同时存放 Car、ElectricCar 两个类，同一个模块可以放任意多个类、函数、变量。


9.4.3 从一个模块中导入多个类
# 一次性导入模块内多个指定类
from car import Car, ElectricCar

my_car = Car("BMW", "X5", 2025)
my_e_car = ElectricCar("Tesla", "Model3", 2025)
my_e_car.describe_battery()

9.4.4 导入整个模块
import car

# 必须使用 模块名.类名 方式调用
my_car = car.Car("Benz", "C-Class", 2025)
my_e_car = car.ElectricCar("NIO", "ET5", 2025)


9.4.5 导入模块中的所有类
# 不推荐使用，容易命名冲突
from car import *

my_car = Car("Honda", "CRV", 2025)


9.4.6 在一个模块中导入另一个模块
场景：electric_car.py 需要使用 car.py 的父类 Car
# electric_car.py
from car import Car

class ElectricCar(Car):
    pass

再在主程序导入：
from electric_car import ElectricCar

补充：类使用别名
# 类别名
from car import ElectricCar as EC
my_e = EC("Tesla", "Y", 2025)
```

## Python类编程风格规范(PEP8精简版)

```python
# Python类编程风格规范(PEP8精简版)

# 1. 命名规范
# 类名：大驼峰 PascalCase
class UserOrder:
    # 类属性、实例属性、所有方法：小写蛇形命名
    school_name = "test"

    def __init__(self, user_name):
        # 公共：name  保护：_name  私有：__name
        self.user_name = user_name
        self._user_age = 18
        self.__user_id = 1001

    def get_user_info(self):
        """方法文档字符串：描述功能、参数、返回值"""
        return self.user_name

    @classmethod
    def update_school(cls):
        pass

    @staticmethod
    def check_phone():
        pass

# 2. 文档规范
class Goods:
    """类文档字符串：说明类用途"""
    pass

# 3. 排版规范
# 类之间空两行，类内成员间空一行，缩进4空格
# 禁止Tab缩进

# 4. 导入规范
# 导入顺序：标准库→第三方库→自定义模块
# 一行导入一个类，冲突用as起别名
# from module import ClassA
# from module import ClassB as CB

# 5. 设计规范
# 1.单一职责：一个类只负责一类业务
# 2.敏感数据用@property封装，少直接暴露私有属性
# 3.全局配置用类属性，业务数据用实例属性
# 4.通用工具用静态方法，类全局操作用类方法
# 5.合理继承，慎用多继承避免MRO混乱

# 6.注释规范
# 只注释复杂逻辑的设计原因，不注释简单代码执行过程
# 清理废弃注释代码
```

## 文件操作

```python
# 一、基础打开文件：open(文件路径, 打开模式, 编码)
# 常用编码：encoding="utf-8"
# 推荐with语句：自动关闭文件，无需手动f.close()

# 1. r 只读（默认），文件不存在则报错
with open("test.txt", "r", encoding="utf-8") as f:
    content = f.read()        # 一次性读取全部
    line1 = f.readline()      # 读取一行
    line_list = f.readlines() # 按行读取，返回列表

# 2. w 只写，清空原有内容，文件不存在自动创建
with open("test.txt", "w", encoding="utf-8") as f:
    f.write("写入内容1\n")
    f.writelines(["第一行\n", "第二行\n"])

# 3. a 追加写入，在文件末尾新增，不覆盖原有内容
with open("test.txt", "a", encoding="utf-8") as f:
    f.write("追加一行内容")

# 4. r+ 可读可写，从文件开头覆盖写入；w+ 可读可写先清空；a+ 追加可读

# 二、二进制模式（图片、视频、压缩包，不带encoding）
# rb 读取二进制、wb 写入二进制、ab 追加二进制
with open("logo.png", "rb") as f:
    data = f.read()
with open("copy.png", "wb") as f:
    f.write(data)

# 三、os模块文件/文件夹操作
import os
os.path.abspath(__file__)    # 获取当前脚本绝对路径
os.path.dirname(路径)        # 获取目录
os.path.join(路径1,路径2)    # 路径拼接
os.path.exists(路径)         # 判断文件/文件夹是否存在
os.path.isfile(路径)         # 判断是否为文件
os.path.isdir(路径)         # 判断是否为文件夹
os.mkdir("文件夹名")         # 创建单级文件夹
os.makedirs("a/b/c")        # 创建多级文件夹
os.remove("文件路径")        # 删除单个文件
os.listdir("目录路径")       # 获取目录下所有文件名称列表

# 四、上下文管理器优势
# with执行完毕自动调用close()释放资源，避免忘记关闭导致文件占用
```

扩展

```python
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


file_object.read()         #读所有
file_object.read(1)     #都一个字节
file_object.readline()  #读一行
file_object.readlines() #读所有行，每行为列表的一个元素
file_object.flush()     #缓冲区内容刷到硬盘
file_object.seek(3)      #移动光标位置 移动到字节的位置
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

## 异常处理

```python
# 10.3 异常处理
# 10.3.1 ZeroDivisionError 除零异常
# 错误：除数不能为0
# num = 10 / 0

# 10.3.2 try-except 捕获异常
try:
    num = 10 / 0
except ZeroDivisionError:
    print("错误：除数不能为0")

# 10.3.3 捕获异常防止程序崩溃
while True:
    try:
        a = int(input("请输入被除数："))
        b = int(input("请输入除数："))
        res = a / b
        print(res)
        break
    except ZeroDivisionError:
        print("除数不能为0，请重新输入")
    except ValueError:
        print("必须输入数字")

# 10.3.4 else 代码块：无异常时执行
try:
    a = int(input("输入数字："))
    b = int(input("输入数字："))
    res = a + b
except ValueError:
    print("输入不是整数")
else:
    # 只有try中代码正常执行无异常才会走else
    print("计算结果：", res)

# 10.3.5 FileNotFoundError 文件不存在异常
try:
    with open("test123.txt", "r", encoding="utf-8") as f:
        content = f.read()
except FileNotFoundError:
    print("异常：目标文件不存在")

# 10.3.6 分析文本：统计单词数量
try:
    with open("article.txt", "r", encoding="utf-8") as f:
        words = f.read().split()
        print(f"文件总单词数：{len(words)}")
except FileNotFoundError:
    print("文件不存在")

# 10.3.7 遍历多个文件批量统计
def count_words(filename):
    try:
        with open(filename, "r", encoding="utf-8") as f:
            return len(f.read().split())
    except FileNotFoundError:
        return 0

files = ["a.txt", "b.txt", "c.txt"]
for file in files:
    print(f"{file} 单词数：{count_words(file)}")

# 10.3.8 静默失败：pass不提示错误
try:
    with open("none.txt") as f:
        pass
except FileNotFoundError:
    pass

# 10.3.9 按需抛出/打印指定错误，不捕获所有异常
# 只捕获预知异常，未知异常允许抛出便于排查
try:
    int("abc")
except ValueError as e:
    print(f"已知错误：{e}")


# 10.4 存储数据 json
import json

# 10.4.1 dumps loads 内存字符串互转
data = {"name": "小明", "age": 18}
json_str = json.dumps(data, ensure_ascii=False)
origin_data = json.loads(json_str)

# 10.4.2 dump load 文件读写保存用户数据
def save_user():
    username = input("输入用户名：")
    with open("user.json", "w", encoding="utf-8") as f:
        json.dump(username, f, ensure_ascii=False)

def get_user():
    try:
        with open("user.json", "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        return None

# 10.4.3 重构：拆分函数，职责单一、复用性高
def greet_user():
    user = get_user()
    if user:
        print(f"欢迎回来 {user}")
    else:
        save_user()
        print("用户名已保存")

greet_user()

-------------------------------------------------

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

## 测试代码

```python
# 测试代码（pytest）
# 11.1 pip安装pytest
# 11.1.1 更新pip
# python -m pip install --upgrade pip
# 11.1.2 安装pytest
# pip install pytest

# 命名规则：
# 测试文件必须以 test_ 开头
# 测试函数必须以 test_ 开头
# 测试类必须以 Test 开头，不能有 __init__
# 测试类内方法必须 test_ 开头

# 11.2 测试函数
# 11.2.1 单元测试：测试单个函数/方法；测试用例：一组输入+预期结果
# 待测试函数
def get_formatted_name(first, last):
    return f"{first} {last}".title()

# 11.2.2 可通过的测试用例 #在同目录下创建test_name.py
def test_full_name():
    result = get_formatted_name("li", "hua")
    assert result == "Li Hua"  # 断言相等，成立测试通过

test_full_name()
# 11.2.3 运行测试命令
# pytest test_name.py -v
---------------------------------------------------
# 11.2.4 未通过测试：断言不匹配则报错
def test_wrong_name():
    res = get_formatted_name("li", "hua")
    assert res == "li hua"  # 断言失败，测试不通过

# 11.2.5 测试失败：修改业务代码修正逻辑，不要改测试用例迁就错误
# 11.2.6 新增多场景测试用例
def test_first_last_middle():
    def get_formatted_name(first, last, middle=""):
        if middle:
            return f"{first} {middle} {last}".title()
        return f"{first} {last}".title()
    res = get_formatted_name("wang", "wu", "wei")
    assert res == "Wang Wei Wu"

# 11.3 测试类
# 11.3.1 常用断言
# assert a == b    相等
# assert a != b    不等
# assert bool(a)   真值
# assert not a     假值
# assert element in list
# assert element not in list

# 11.3.2 待测试类
class AnonymousSurvey:
    def __init__(self, question):
        self.question = question
        self.responses = []

    def show_question(self):
        print(self.question)

    def store_response(self, new_response):
        self.responses.append(new_response)

    def show_results(self):
        return self.responses

# 11.3.3 测试类
class TestAnonymousSurvey:
    def test_store_single_response(self):
        survey = AnonymousSurvey("最喜欢的语言？")
        survey.store_response("Python")
        assert "Python" in survey.responses

    def test_store_multi_response(self):
        survey = AnonymousSurvey("最喜欢的语言？")
        survey.store_response("Java")
        survey.store_response("Go")
        assert len(survey.responses) == 2

# 11.3.4 pytest夹具 @pytest.fixture：复用实例，避免重复创建对象
import pytest
@pytest.fixture
def survey_obj():
    # 前置：返回通用测试对象，每个测试方法自动接收该参数
    return AnonymousSurvey("最喜欢的编程语言？")

class TestAnonymousSurveyFix:
    def test_single(self, survey_obj):
        survey_obj.store_response("C++")
        assert "C++" in survey_obj.responses

    def test_multi(self, survey_obj):
        survey_obj.store_response("PHP")
        survey_obj.store_response("Rust")
        assert len(survey_obj.responses) == 2

# 11.4 小结
# 1. pytest安装、命名规范、运行测试命令
# 2. 单元测试+断言校验函数逻辑正确性3试类，对类的各个方法编写多场景用例
# 4. fixture夹具复用测试前置数据，精简重复代码
# 5. 测试失败优先修正业务代码，保证测试用例可靠
```

## python软件开发目录设计规范

```bash
# Python 软件开发标准目录规范（企业通用）
# 项目名：crm_project（小写+下划线，禁止中文、驼峰）
"""
crm_project/
├── bin/                # 程序可执行入口脚本
│   └── start.py        # 项目启动文件
├── conf/               # 配置文件目录
│   └── settings.py     # 全局配置：路径、数据库、日志、第三方参数
├── core/               # 核心业务逻辑目录
│   └── main.py         # 主业务、核心功能代码
├── lib/                # 公共工具模块、自定义通用函数
│   └── common.py       # 封装日志、加密、校验、路径处理等工具
├── db/                 # 数据持久化目录
│   └── user_data.json  # 存放程序运行产生的数据文件
├── log/                # 日志文件存放目录
│   └── run.log         # 运行日志、错误日志
├── tests/              # 单元测试用例目录
│   └── test_api.py     # pytest测试脚本
├── static/             # 静态资源：图片、excel、模板文件
├── docs/               # 项目说明文档、接口文档、部署文档
├── .gitignore          # git忽略文件：pyc、log、venv、缓存文件
├── requirements.txt    # 项目依赖清单：pip freeze > requirements.txt
├── README.md           # 项目介绍、部署步骤、启动方式
└── LICENSE             # 开源许可文件（可选）
"""

# 各目录详细说明
# 1.bin 启动目录
# 存放项目入口脚本，统一运行入口，方便部署运维，禁止业务代码写在这里

# 2.conf 配置目录
# 所有常量、文件路径、数据库地址、账号密码统一放在配置文件，方便环境切换

# 3.core 核心业务目录
# 项目主体功能代码，业务逻辑全部放在这里

# 4.lib 公共工具库
# 多个模块都会用到的通用函数封装，避免代码冗余

# 5.db 数据目录
# 存放程序持久化数据（json、本地文件类项目使用）

# 6.log 日志目录
# 统一收集运行日志、异常日志，方便线上排查BUG

# 7.tests 测试目录
# 单元测试、接口测试脚本，保证代码迭代稳定性

# 8.static 静态资源目录
# 模板、图片、附件、批量导入文件等

# 9.docs 文档目录
# 设计文档、使用手册、部署文档

# 项目必备文件说明
# requirements.txt：记录项目依赖包，部署时一键安装 pip install -r requirements.txt
# .gitignore：排除不需要提交到代码仓库的文件（__pycache__、venv、*.log、*.pkl）
# README.md：项目快速上手文档，团队协作必备

# 命名规范
# 文件夹、py文件：全部小写+下划线
# 包内必须保证可导入，尽量使用绝对导入规范
```

## Socket 网络编程

### 前置网络核心知识（Socket 开发必掌握）

#### 一、两大网络模型对应关系

- **OSI 七层模型**（理论标准）：应用层 → 表示层 → 会话层 → 传输层 → 网络层 → 数据链路层 → 物理层
- **TCP/IP 五层模型**（工业实际落地）：应用层（合并 OSI 上三层） → 传输层 → 网络层 → 数据链路层 → 物理层
- Socket 编程仅直接和**传输层、应用层**打交道，下三层完全由操作系统 / 网卡硬件封装，写代码无需处理。

#### 二、TCP/IP 五层分层详解（标注 Socket 关联）

##### 1. 应用层

- 作用：定义业务数据格式和交互规则，面向用户提供具体网络服务
- 核心协议：HTTP、HTTPS、SSH、FTP、DNS
- Socket 关联：我们编写的 Socket 程序本质就是在这层自定义业务协议、解析收发的业务数据

##### 2. 传输层（Socket 编程核心层）

- 作用：实现端到端的进程间通信，区分同一台主机上的不同网络程序
- 核心协议：TCP、UDP
- 核心概念：**端口号**（0~65535），唯一标识一台主机上的一个网络进程
- Socket 关联：创建 Socket 时指定 TCP/UDP 协议，`bind`/`connect`绑定端口，所有数据收发都基于这层

##### 3. 网络层

- 作用：主机寻址与路由选择，确定两台跨网主机的传输路径
- 核心协议：IPv4、IPv6、ICMP
- 核心概念：**IP 地址**，唯一标识公网 / 局域网中的一台主机
- Socket 关联：`bind`绑定本地 IP、`connect`指定目标 IP，就是网络层的寻址逻辑

##### 4. 数据链路层

- 作用：局域网内基于 MAC 地址的主机通信
- 核心协议：以太网、ARP
- Socket 关联：操作系统内核封装，编写代码完全无需关心

##### 5. 物理层

- 作用：光电信号传输（网线、光纤、网卡硬件）
- Socket 关联：完全不涉及

#### 三、传输层核心：TCP vs UDP（直接对应 Socket 参数）

##### TCP（传输控制协议）

- 特性：面向连接、可靠传输、字节流格式、传输速度慢
- 可靠保障：三次握手建连、确认重传机制、流量控制、四次挥手断开
- 适用场景：文件传输、Web 服务、远程命令执行、即时通讯（要求数据不丢失）
- Socket 对应：`socket.SOCK_STREAM`

##### UDP（用户数据报协议）

- 特性：无连接、不可靠、数据报格式、传输速度极快
- 特点：发完不确认，不保证数据到达、不保证顺序，不存在粘包问题
- 适用场景：直播推流、DNS 查询、游戏帧同步、网络广播
- Socket 对应：`socket.SOCK_DGRAM`

#### 四、Socket 编程必懂补充概念

1. **端口号范围**
   - 知名端口：0~1023，固定分配给标准服务（80=HTTP，22=SSH，3306=MySQL）
   - 注册端口：1024~49151，自定义服务推荐使用此区间
   - 动态端口：49152~65535，客户端自动分配的临时端口
2. **TCP 三次握手**
   - 过程：客户端发 SYN → 服务端回 SYN+ACK → 客户端回 ACK
   - 代码对应：客户端执行`connect()`触发握手，服务端`accept()`返回代表连接建立完成
3. **TCP 四次挥手**
   - 过程：主动断开方发 FIN → 被动方回 ACK → 被动方发 FIN → 主动方回 ACK
   - 代码对应：执行`close()`触发断开，`TIME_WAIT`状态是挥手的收尾保护阶段
4. **TCP 粘包问题**
   - 原因：TCP 是字节流，没有数据边界，连续发送的小包会被内核合并传输
   - 影响：一次`recv()`可能读到多条或半条业务数据，导致解析错误
   - 解决：自定义应用层协议（长度头、特殊分隔符、固定长度）
5. **网络字节序**
   - 网络传输统一使用**大端序**，不同 CPU 的主机字节序可能不同
   - Python Socket 底层已自动处理大部分转换，仅特殊场景需手动调用`htons`/`ntohs`

#### 总结

写 Socket 代码核心吃透 4 点：IP 与端口的作用、TCP 和 UDP 的区别与选型、TCP 三次握手 / 四次挥手逻辑、TCP 粘包解决方案；底层网络知识了解即可，无需深入硬件实现。

### python socket代码

```python
# ========== Socket 网络编程核心（TCP/UDP 双模式）==========
import socket

# ========== 1. TCP 套接字（面向连接、可靠传输，主流）==========
# --- TCP 服务端 ---
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  # AF_INET=IPv4, SOCK_STREAM=TCP协议
server.bind(("0.0.0.0", 8080))                              # 绑定IP+端口，0.0.0.0允许所有地址连接
server.listen(5)                                            # 启动监听，backlog=最大等待连接数
conn, client_addr = server.accept()                         # 阻塞等待客户端连接，返回(连接对象,客户端地址)
data = conn.recv(1024)                                      # 接收数据，单次最大1024字节，返回bytes
print("收到客户端数据:", data.decode("utf-8"))              # 字节转字符串
conn.send("服务端已收到".encode("utf-8"))                   # 发送数据，字符串转字节
conn.close()
server.close()

# --- TCP 客户端 ---
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(("127.0.0.1", 8080))                        # 主动连接服务端
client.send("hello server".encode("utf-8"))
data = client.recv(1024)
print("服务端响应:", data.decode("utf-8"))
client.close()


# ========== 2. UDP 套接字（无连接、高速，不保证可靠）==========
# --- UDP 服务端 ---
udp_server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  # SOCK_DGRAM=UDP协议
udp_server.bind(("0.0.0.0", 9090))
data, client_addr = udp_server.recvfrom(1024)                 # 接收数据+客户端地址
print("UDP收到:", data.decode("utf-8"))
udp_server.sendto("UDP已收到".encode("utf-8"), client_addr)
udp_server.close()

# --- UDP 客户端 ---
udp_client = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
udp_client.sendto("hello udp".encode("utf-8"), ("127.0.0.1", 9090))  # 直接发，无需建立连接
data, addr = udp_client.recvfrom(1024)
print("UDP服务端响应:", data.decode("utf-8"))
udp_client.close()


# ========== 3. 核心知识点 ==========
# 协议参数
# socket.AF_INET   IPv4地址族
# socket.AF_INET6  IPv6地址族
# socket.SOCK_STREAM  TCP流式套接字
# socket.SOCK_DGRAM   UDP数据报套接字

# 收发规则
# 1. 所有收发数据必须是 bytes 类型，字符串必须 encode/decode
# 2. 默认阻塞模式：accept/recv 会卡住程序，直到有连接/数据到来
# 3. TCP粘包问题：连续小数据会被合并发送，生产环境需自定义协议分包（固定长度/分隔符/长度头）
# 4. 并发处理：单线程只能处理1个连接，生产环境用 多线程/多进程/IO多路复用(selectors)

# 常用场景
# TCP：文件传输、Web服务、远程命令执行、聊天系统
# UDP：直播、DNS查询、游戏帧同步、广播消息
```

### TCP 粘包的本质

TCP 是**面向字节流**的协议，内核会自动合并小数据包（Nagle 算法）、拆分大数据包，接收端拿到的是连续的无边界字节流，应用层无法自动区分两条独立消息，就会出现「一次 recv 读到多条数据」或「一条数据分多次读到」的粘包 / 半包问题。

**必须在应用层自定义协议拆分数据**，工业界最通用的两种方案：

1. **长度前缀法（推荐，企业级标准）**

2. 特殊分隔符法（简单文本场景）
   
   **方案 1：长度前缀法（最常用、最可靠）**

原理

每条消息固定分成两部分：

- 头部：固定 4 字节，用大端序（网络字节序）存储后续数据的字节长度
- 本体：真实业务数据

接收方先读 4 字节拿到数据长度，再精确读取对应长度的字节，彻底避免粘包。

 依赖

Python 标准库 `struct` 实现整数与字节的互转。

```py
服务端-----------------------------------------------------
import socket
import struct

def send_msg(conn, msg: str):
    """发送带长度前缀的消息"""
    data = msg.encode("utf-8")
    # ! 表示网络字节序（大端），I表示4字节无符号整数
    head = struct.pack("!I", len(data))
    conn.send(head)   # 先发4字节长度头
    conn.send(data)   # 再发真实数据

# 启动服务
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(("0.0.0.0", 8080))
server.listen(5)
conn, addr = server.accept()

# 连续发两条消息，模拟粘包场景
send_msg(conn, "第一条消息")
send_msg(conn, "第二条消息，内容更长一点")

conn.close()
server.close()


客户端--------------------------------------------------------

import socket
import struct

def recv_msg(conn) -> str | None:
    """精确接收一条完整消息"""
    # 1. 先收4字节头部，拿到数据长度
    head = conn.recv(4)
    if not head:
        return None  # 连接断开
    data_len = struct.unpack("!I", head)[0]

    # 2. 循环收满指定长度的数据（解决半包）
    data = b""
    while len(data) < data_len:
        chunk = conn.recv(data_len - len(data))
        if not chunk:
            return None
        data += chunk
    return data.decode("utf-8")

# 连接服务端
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(("127.0.0.1", 8080))

# 可以准确拆分出两条独立消息
print(recv_msg(client))  # 第一条消息
print(recv_msg(client))  # 第二条消息，内容更长一点

client.close()


# 方案优势
# 精准拆分，不存在歧义，适合二进制、文本、图片等任意数据
# 性能高，解析速度快，工业级 RPC、游戏服务器普遍采用
```

### osi 7层模型 模拟过程

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


-----------------------------------------------------
- UDP（User Data Protocol）用户数据报协议， 是⼀个⽆连接的简单的⾯向数据报的传输层协议。 UDP不提供可靠性， 它只是把应⽤程序传给IP层的数据报发送出去， 但是并不能保证它们能到达⽬的地。 由于UDP在传输数据报前不⽤在客户和服务器之间建⽴⼀个连接， 且没有超时重发等机制， 故⽽传输速度很快。
      常见的有：语音通话、视频通话、实时游戏画面 等。
- TCP（Transmission Control Protocol，传输控制协议）是面向连接的协议，也就是说，在收发数据前，必须和对方建立可靠的连接，然后再进行收发数据。
      常见有：网站、手机APP数据获取等。
```

### 后话

```bash
# === Socket 核心定位 ===
# 所有网络通信的底层基石，几乎所有联网软件底层都依赖；
# 日常Web/业务开发极少手写原生Socket，上层框架/服务器已完成封装。

# === Socket 典型应用场景 ===
# 1. 私有协议服务：物联网设备、游戏服务器、金融私有交易、工业控制
# 2. 网络中间件：内网穿透(frp/ngrok)、端口转发、反向代理、VPN、抓包工具
# 3. 运维底层：paramiko/pymysql/redis-py 底层均基于Socket；自定义监控探针、运维Agent
# 4. 即时通信：IM聊天、直播弹幕、实时对战游戏长连接

# === 知名开源软件底层依赖 ===
# Web服务器：Nginx、Apache 底层通过Socket监听端口、处理请求
# 数据库/中间件：MySQL、Redis、Kafka、RabbitMQ 服务端与客户端交互基于TCP Socket
# Python生态库：requests、paramiko、pymysql 均封装了标准库socket模块

# === Django 与 Socket 分层关系 ===
# 业务层：Django 路由/视图/模型（仅处理业务逻辑）
# 协议层：WSGI 规范接口（Django实现该规范）
# 服务层：Gunicorn/uWSGI/runserver 负责Socket监听、连接处理、HTTP解析
# 底层：操作系统Socket + 网卡硬件
# 说明：Django本身不集成手写Socket代码，底层网络能力由WSGI服务器提供

浏览器 → Nginx(80/443端口) → 反向代理 → Gunicorn/uWSGI(8000端口) → 调用WSGI接口 → Django业务逻辑 → 原路返回
uWSGI可以算作Web服务器,「Python 专属的应用级 Web 服务器（WSGI 服务器）」，不是通用型 Web 服务器。
Nginx是通用高性能 Web 服务器 + 反向代理服务器，是整个服务的流量入口，不直接运行 Python 代码
浏览器（客户端Socket）
    ↓ TCP 连接
Nginx（服务端Socket，监听80/443）
    ↓ 解析HTTP、反向代理，新建TCP连接
uWSGI（服务端Socket，监听内网端口/Unix套接字）
    ↓ 按WSGI规范，内存级函数调用
Django（无Socket，仅执行业务逻辑）

# === 学习价值与替代方案 ===
# 1. 日常开发不用手写：HTTP协议、Web服务器、数据库客户端已封装完成
# 2. 核心价值：排查端口占用/连接超时/粘包/TIME_WAIT等线上问题；
#             理解框架底层原理；对接私有协议硬件、定制化工具开发
# 3. Python替代框架：asyncio、Twisted、Tornado、FastAPI+WebSocket、gRPC
#    本质仍是Socket封装，已处理并发、协议解析、异常等细节
```

## Python 并发编程

按照「**基础理论 → 多进程 → 多线程 → 同步工具 → 池化技术 → 协程 → IO 模型 → IO 多路复用**」的认知顺序编排，

---

### 第一阶段：前置操作系统知识（学并发必先懂）

### 1. 核心概念辨析

#### 并发 vs 并行

- **并发**：同一时间段内多个任务交替执行（单核 CPU 也能实现并发，靠操作系统快速切换任务）
- **并行**：同一时刻多个任务同时执行（必须多核 CPU 才能实现）
- 理解：并发是「伪同时」，并行是「真同时」；Python 协程、单 CPU 多线程都属于并发，多进程在多核下属于并行。

#### CPU 密集型 vs IO 密集型

- **CPU 密集型**：任务主要消耗 CPU 计算资源（循环计算、加密、视频编码），全程 CPU 在干活
- **IO 密集型**：任务大部分时间在等待 IO 结果（网络请求、文件读写、数据库查询），CPU 处于空闲状态
- 这是后续「多进程 / 多线程 / 协程选型」的核心依据。

#### 进程 vs 线程（操作系统层面）

- **进程**：操作系统资源分配的最小单位，每个进程有独立的内存空间、文件描述符，进程间隔离，切换开销大
- **线程**：操作系统调度的最小单位，线程隶属于进程，同一个进程内的所有线程共享同一块内存空间，切换开销小
- 关系：一个进程至少有一个主线程，可以有多个子线程；线程不能脱离进程独立存在。

---

### 第二阶段：多进程编程

### 1. 进程基础与内存隔离

Python 中使用 `multiprocessing` 模块实现多进程，**进程间内存完全隔离**，全局变量互不影响。

### 2. 开启进程的两种方式

```python
from multiprocessing import Process
import time

# 方式1：函数式（最常用）
def task(name):
    print(f"{name} 任务开始")
    time.sleep(2)
    print(f"{name} 任务结束")

# 方式2：继承Process类，重写run方法
class MyProcess(Process):
    def __init__(self, name):
        super().__init__()
        self.name = name
    def run(self):
        print(f"{self.name} 任务开始")
        time.sleep(2)
        print(f"{self.name} 任务结束")

if __name__ == "__main__":
    # 方式1调用
    p1 = Process(target=task, args=("任务1",))
    # 方式2调用
    p2 = MyProcess("任务2")

    p1.start()  # 启动进程（向操作系统发申请）
    p2.start()
    p1.join()   # 主进程等待子进程结束
    p2.join()
    print("所有进程执行完毕")
```

> 注意：Windows 下开启进程必须写在 `if __name__ == "__main__":` 里，否则会递归导入报错。

### 3. Process 对象常用属性

```bash
Process([group [, target [, name [, args [, kwargs]]]]])，由该类实例化得到的对象，可用来开启一个子进程
强调：
1. 需要使用关键字的方式来指定参数
2. args指定的为传给target函数的位置参数，是一个元组形式，必须有逗号

参数介绍
group参数未使用，值始终为None
target表示调用对象，即子进程要执行的任务
args表示调用对象的位置参数元组，args=(1,2,'egon',)
kwargs表示调用对象的字典,kwargs={'name':'egon','age':18}
name为子进程的名称

方法介绍
p.start()：启动进程，并调用该子进程中的p.run() 
p.run():进程启动时运行的方法，正是它去调用target指定的函数，我们自定义类的类中一定要实现该方法  
p.terminate():强制终止进程p，不会进行任何清理操作，如果p创建了子进程，该子进程就成了僵尸进程，使用该方法需要特别小心这种情况。如果p还保存了一个锁那么也将不会被释放，进而导致死锁
p.is_alive():如果p仍然运行，返回True
p.join([timeout]):主线程等待p终止（强调：是主线程处于等的状态，而p是处于运行的状态）。timeout是可选的超时时间。

属性介绍：
- `pid`：进程 ID
- `name`：进程名
- `is_alive()`：判断进程是否存活
- `daemon`：是否为守护进程
- `join()`：主进程阻塞等待子进程结束
- `terminate()`：强制终止进程
```

### 4. 守护进程

- 特性：守护进程会在**主进程代码执行结束时立刻终止**，不管自己任务有没有做完
- 用途：后台监控、日志上报等随主进程同生共死的辅助任务

守护进程核心规则（唯一区别于普通子进程）

普通子进程：就算主进程代码跑完退出，子进程会继续把自己任务跑完才结束。

守护子进程：**一旦主进程所有代码执行完毕、主进程要退出，不管守护进程任务有没有跑完，直接强制杀死守护进程**。

```python
p = Process(target=task)
p.daemon = True  # 必须在start()之前设置
p.start()
```

### 5. 互斥锁（进程间）

- 解决问题：多个进程同时操作同一个共享资源（如文件、终端输出），导致数据错乱
- 本质：把并发的临界区代码变成串行，牺牲效率保证数据安全

```python
from multiprocessing import Process,Lock
import time

def task(lock, name):
    # with lock: #相当于lock.acquire(),执行完自代码块自动执行lock.release()
    lock.acquire()  # 加锁
    # 临界区：同一时间只能有一个进程执行
    print(f"{name} 正在操作共享资源")
    time.sleep(1)
    lock.release()  # 解锁

if __name__ == "__main__":
    lock = Lock()
    for i in range(3):
        Process(target=task, args=(lock, f"进程{i}")).start()
```

#### 互斥锁 vs join

- `join()`：让整个子进程全部串行，粒度大，效率低
- `互斥锁`：只让共享资源的那部分代码串行，其他代码依然并发，粒度细，效率更高

小结:

多进程并发修改共享数据，加锁可串行执行保障数据安全，但会降低运行速度。

若通过硬盘文件实现进程数据共享存在两大缺陷：

1. 读写硬盘，效率极低；
2. 需要手动自行实现锁逻辑。

multiprocessing 提供内存级 IPC 方案：管道、队列，兼顾高性能与自动锁机制：

1. 数据存放在内存，读写速度快；
2. 队列底层由管道 + 内置锁封装，自动处理同步互斥，不用手动加锁，是进程通信首选。

开发规范：尽量不用共享内存 / 文件传数据，优先队列消息通信，减少锁的复杂处理，进程量大时扩展性更好。

### 6. 进程间通信（IPC）

进程内存隔离，必须借助专门的机制传递数据，常用 3 种：

#### ① 队列 Queue（最常用，线程 / 进程安全）

先进先出，基于「管道 + 锁」实现，自动处理同步

```python
from multiprocessing import Queue
import queue
q = Queue(3)  # 最大容量3
q.put("数据1")  # 放数据，满了则阻塞
q.put("数据2")
q.put("数据3")
try:
    q.put_nowait("4")  # 放数据，满了则抛异常
except queue.Full:
    print("队列已满，无法放入")

print(q.get())        # 取数据，空了则阻塞
print(q.get())        # 取数据，空了则阻塞
print(q.get())        # 取数据，空了则阻塞
try:
    res = q.get_nowait()
except queue.Empty:
    print("队列暂无数据")


print(q.empty())      # 是否为空
print(q.full())       # 是否已满
```

#### ② 管道 Pipe

双向通信，性能比队列高，但需要自己处理同步锁，适合两个进程通信

#### ③ 共享内存 Manager/Value/Array

直接在内存中开辟共享空间，速度最快，但需要自己加锁，容易出问题

### 7. 生产者消费者模型

- 核心思想：解耦生产端和消费端，平衡生产速度和消费速度
- 三要素：生产者、队列（缓冲区）、消费者

```python
from multiprocessing import Process, Queue
import time, random

def producer(q, name):
    for i in range(5):
        time.sleep(random.random())
        food = f"{name}做的包子{i}"
        q.put(food)
        print(f"生产者{name}生产了{food}")

def consumer(q, name):
    while True:
        food = q.get()
        if food is None: break  # 结束信号
        time.sleep(random.random())
        print(f"消费者{name}吃了{food}")

if __name__ == "__main__":
    q = Queue()
    # 2个生产者
    p1 = Process(target=producer, args=(q, "厨师A"))
    p2 = Process(target=producer, args=(q, "厨师B"))
    # 2个消费者
    c1 = Process(target=consumer, args=(q, "顾客1"))
    c2 = Process(target=consumer, args=(q, "顾客2"))

    p1.start(); p2.start()
    c1.start(); c2.start()

    p1.join(); p2.join()
    # 生产完后发结束信号，有几个消费者发几个None
    q.put(None); q.put(None)
```

普通 Queue 痛点

1. 需要手动向队列塞 `None` 作为结束标识；
2. 多消费者场景必须发送对应数量的结束标记，极易写错；
3. 无法判断**队列里所有数据是否全部被消费完毕**，只能靠自定义标记。

### JoinableQueue 生产者消费者（自带任务计数，无需手动标记）

核心新增两个方法

1. `q.task_done()`：消费者取完一条数据调用，告知队列本条消息处理完成；
2. `q.join()`：阻塞等待，直到队列中所有数据都调用过 `task_done()`。

```python
from multiprocessing import Process, JoinableQueue
import time, random

def producer(q):
    for i in range(3):
        food = f"包子{i}"
        q.put(food)
        print(f"生产者生产：{food}")
        time.sleep(random.random())

def consumer(q):
    while True:
        food = q.get()
        print(f"消费者吃掉：{food}")
        time.sleep(random.random())
        q.task_done()  # 标记当前这条消息处理完毕

if __name__ == "__main__":
    q = JoinableQueue()
    p = Process(target=producer, args=(q,))
    c = Process(target=consumer, args=(q,))
    p.start()
    c.daemon = True  # 消费者设为守护进程
    c.start()

    p.join()        # 等待生产者全部生产完成
    q.join()        # 阻塞：等待队列所有数据被消费+全部task_done
    print("所有商品已消费完毕")
```

多消费者兼容示例（不用多发结束符）

```python
if __name__ == "__main__":
    q = JoinableQueue()
    p = Process(target=producer, args=(q,))
    c1 = Process(target=consumer, args=(q,))
    c2 = Process(target=consumer, args=(q,))
    p.start()
    c1.daemon = True
    c2.daemon = True
    c1.start()
    c2.start()

    p.join()
    q.join()
    print("所有包子吃完") 
```

生产者消费者模型精简总结

```python
1. 组成
生产者（生成任务）、队列缓冲区、消费者（处理任务）
作用：解耦生产消费，平衡二者速度，提升并发。
2. 两种队列实现
普通 Queue
仅存数据，无任务计数；需手动塞结束标记退出循环；多消费者易出错，适合简单传数据。
JoinableQueue（推荐）
内置任务计数器；
消费者处理完调用task_done()
主进程q.join()阻塞等待全部任务消费完成
搭配守护进程，不用手动发结束信号，多消费者逻辑简洁。
3. 关键 API
put()/get()：阻塞读写，标准场景使用
put_nowait()/get_nowait()：非阻塞，满抛 Full、空抛 Empty，需捕获异常
4. 标准执行流程
创建 JoinableQueue
启动生产者、守护消费者
生产者.join()等待生产完成
q.join()等待全部任务处理完，程序退出
5. 适用场景
爬虫、批量运维任务、日志 / 数据清洗、异步消息处理
6. 优缺点
优点：代码解耦、可横向扩容、缓冲瞬时峰值任务
缺点：大量数据占用内存，多进程队列有少量传输损耗
7. 选型
简单临时传输用 Queue；批量任务、需确认全部执行完毕用 JoinableQueue。
```

### 补充：僵尸进程与孤儿进程

- **孤儿进程**：父进程先结束，子进程还在运行，会被系统 init 进程收养，无害
- **僵尸进程**：子进程结束了，父进程没有调用 join 回收资源，子进程残留 PCB 信息，占用进程号，过多会耗尽系统资源
- 解决：父进程及时 join 回收，或用守护进程

---

### 第三阶段：多线程编程

#### 前置必备知识

1. 操作系统基础：CPU 调度、并发 / 并行、IO 密集 / CPU 密集任务
2. 进程概念：进程是资源分配单位，内存独立
3. 锁、临界区、竞态条件（共享数据修改会错乱）
4. 队列缓冲区、生产者消费者模型思想

#### 什么是线程

线程是操作系统**最小调度单位**，依附进程存在；

一个进程至少 1 条主线程，同进程内多条线程共享进程内存、文件句柄等资源。

#### 线程 vs 进程

1. 资源隔离：进程内存完全隔离；线程共享同一块进程内存
2. 切换开销：进程切换开销大；线程切换轻量、速度快
3. 通信难度：进程需 IPC 队列 / 管道；线程直接读写全局变量
4. 崩溃影响：一个进程崩溃互不干扰；一条线程崩溃会整个进程退出
5. Python GIL：多线程无法多核并行计算；多进程可利用多核

#### 多线程适用场景举例（全是 IO 密集型）

1. 爬虫：并发请求大量网页，网络 IO 等待时切换线程
2. 运维批量操作：多台服务器 ssh 执行命令、文件上传下载
3. 文件读写：同时读取多个本地 / 远程文件
4. 接口服务：Web 后端处理大量客户端请求，等待数据库 / Redis IO
5. 监控采集：多线程同时拉取多台机器指标、日志

### 1. 线程基础

Python 中使用 `threading` 模块实现多线程，**同一进程内的所有线程共享全局内存**，数据可以直接互相访问。

### 2. 开启线程的两种方式

```python
import threading
import time

# 方式1：函数式
def task(name):
    print(f"{name} 线程开始")
    time.sleep(2)
    print(f"{name} 线程结束")

# 方式2：继承Thread类
class MyThread(threading.Thread):
    def __init__(self, name):
        super().__init__()
        self.name = name
    def run(self):
        print(f"{self.name} 线程开始")
        time.sleep(2)
        print(f"{self.name} 线程结束")

t1 = threading.Thread(target=task, args=("线程1",))
t2 = MyThread("线程2")
t1.start()
t2.start()
```

### 3. Thread 对象常用属性 / 方法

```bash
- `ident`：线程 ID
- `name`：线程名
- `is_alive()`：是否存活
- `join()`：主线程等待子线程结束
- `daemon`：是否守护线程
- `threading.current_thread()`：获取当前线程对象
- `threading.active_count()`：当前存活线程数


Thread实例对象的方法
  # isAlive(): 返回线程是否活动的。
  # getName(): 返回线程名。
  # setName(): 设置线程名。
threading模块提供的一些方法：
  # threading.currentThread(): 返回当前的线程变量。
  # threading.enumerate(): 返回一个包含正在运行的线程的list。正在运行指线程启动后、结束前，不包括启动前和终止后的线程。
  # threading.activeCount(): 返回正在运行的线程数量，与len(threading.enumerate())有相同的结果。
```

### 4. 守护线程

- 特性：守护线程会在**所有非守护线程都结束时自动终止**
- 注意：和守护进程的区别 —— 守护进程看主进程代码是否结束，守护线程看所有非守护线程是否结束

```python
t = threading.Thread(target=task)
t.daemon = True
t.start()
```

### 5. 多进程 vs 多线程 核心区别

| 维度     | 多进程            | 多线程                      |
| ------ | -------------- | ------------------------ |
| 内存     | 相互隔离，独立空间      | 共享同一块进程内存                |
| 切换开销   | 大              | 小                        |
| 通信难度   | 难，需 IPC 机制     | 易，直接读写全局变量               |
| 稳定性    | 高，一个进程崩溃不影响其他  | 低，一个线程崩溃可能挂掉整个进程         |
| GIL 影响 | 不受 GIL 限制，多核并行 | 受 GIL 限制，同一时刻只有一个线程执行字节码 |
| 适用场景   | CPU 密集型任务      | IO 密集型任务                 |

---

### 第四阶段：GIL 全局解释器锁（Python 特有核心）

### 1. 什么是 GIL

CPython 解释器中的一把全局互斥锁，**同一时刻只能有一个线程执行 Python 字节码**，即使多核 CPU 也无法让多线程并行执行计算。

### 2. 为什么要有 GIL

早期为了简化内存管理、方便实现垃圾回收（引用计数），用一把大锁保证线程安全，避免复杂的细粒度锁设计。历史遗留设计，至今难以彻底移除。

### 3. GIL 的释放时机

1. **IO 阻塞时自动释放**：遇到 sleep、文件读写、网络请求等 IO 操作，线程会主动释放 GIL，让其他线程执行
2. **时间片到期释放**：CPU 密集型线程执行一定字节码数量 / 时间后，强制释放 GIL，触发线程切换

> 结论：GIL 对 IO 密集型多线程影响很小，对 CPU 密集型多线程几乎没有加速效果，甚至因为切换开销更慢。

### 4. 经典问题：有 GIL 为什么还需要线程锁？

- GIL 只保证「同一时刻只有一个线程执行字节码」，但不保证**原子性**
- 比如 `count += 1` 底层是 3 条字节码，执行到一半可能被切走，其他线程修改了 count，切回来就会数据错乱
- 结论：GIL 是解释器级别的锁，线程安全是业务数据级别的锁，二者不是一回事

多线程用于IO密集型，如socket，爬虫，web
多进程用于计算密集型，如金融分析

### 第五阶段：线程同步与互斥工具

### 1. 互斥锁 Lock

和进程锁用法完全一致，解决线程间共享数据的竞态条件问题

```python
import threading

lock = threading.Lock()
count = 0

def add():
    global count
    for _ in range(100000):
        lock.acquire()
        count += 1
        lock.release()
```

### 2. 死锁现象

- 定义：两个线程互相持有对方需要的锁，同时等待对方释放，永远卡住
- 四个必要条件：互斥、持有并等待、不可剥夺、循环等待
- 规避：统一加锁顺序、设置超时时间、用递归锁

```python
import threading
lock1 = threading.Lock()
lock2 = threading.Lock()

def func1():
    lock1.acquire()
    print("func1 拿到lock1")
    threading.sleep(1)
    lock2.acquire() # 等func2释放lock2，永远等不到

def func2():
    lock2.acquire()
    print("func2 拿到lock2")
    threading.sleep(1)
    lock1.acquire() # 等func1释放lock1，互相等待→死锁

t1 = threading.Thread(target=func1)
t2 = threading.Thread(target=func2)
t1.start()
t2.start()
```

### 3. 递归锁 RLock

- 特点：同一个线程可以多次 acquire，内部有计数器，acquire 几次就需要 release 几次

- 用途：解决嵌套加锁导致的死锁问题

- **Lock（互斥锁）**：同一线程**不能重复加锁**，`acquire()` 两次直接卡死死锁；只支持一层锁。

- **RLock（递归锁）**：内部有计数器，**同一个线程可以多次 acquire 嵌套加锁**，acquire 几次必须 release 几次；跨线程依旧互斥。

- 多个线程争抢多把锁互相等待，不管哪种锁都会死锁，只能靠统一加锁顺序规避。

```python
import threading

lock = threading.Lock()

def sub_func():
    lock.acquire()
    print("子函数拿到锁执行逻辑")
    lock.release()

def main_func():
    lock.acquire()
    print("主函数拿到锁")
    # 内部调用另一个也要加同一把锁的函数
    sub_func()
    lock.release()

t = threading.Thread(target=main_func)
t.start()
----------------------------------------------------
执行流程卡死原因：
main_func 先 acquire() 持有锁
进入 sub_func 再次执行 lock.acquire()
Lock 不允许同一个线程重复拿锁，自己阻塞自己，永久卡住
-----------------------------------------------------
# 换成 RLock 就能正常运行（解决嵌套加锁）
import threading

rlock = threading.RLock()

def sub_func():
    rlock.acquire()
    print("子函数拿到锁执行逻辑")
    rlock.release()

def main_func():
    rlock.acquire()
    print("主函数拿到锁")
    sub_func()
    rlock.release()

t = threading.Thread(target=main_func)
t.start()
```

### 4. 信号量 Semaphore

- 作用：控制同一时间最多有多少个线程并发执行，本质是多把锁
- 场景：限制接口并发数、控制连接池数量

**GIL + Semaphore 不冲突，信号量不是让 5 个线程同时跑 CPU 计算**

1. **GIL 规则**：**同一时刻只有 1 条线程执行 Python 字节码**（CPU 计算时串行）

2. Semaphore 信号量作用：**限制并发线程总数**，控制同时进入临界区的线程数量

3. 为什么有用？
   
   线程大部分时间在**IO 阻塞**（sleep / 网络请求 / 文件读写）时会主动释放 GIL，此时其他线程可以运行。
   
   信号量控制「最多 5 个线程同时发起 IO 等待」，而不是 5 个同时算 CPU；
   
   如果没有信号量，可能一次性起几百个线程疯狂发网络请求，直接触发服务器限流、端口耗尽、程序卡死。

举个现实例子：爬虫，限制最多 5 个并发请求，就是 Semaphore 经典场景。

```python
import threading
import time

# 最多允许5个线程同时进入
sem = threading.Semaphore(5) 
# 记录当前正在运行的线程数，加锁保证计数准确
active_count = 0
count_lock = threading.Lock()

def task(num):
    global active_count
    sem.acquire()  # 抢占信号量
    # 进入临界区，活跃数+1
    with count_lock:
        global active_count
        active_count += 1
        print(f"线程{num}进入，当前并发数量：{active_count}")

    # sleep模拟IO阻塞，此时释放GIL，其他线程可以执行
    time.sleep(2)

    # 离开临界区，活跃数-1
    with count_lock:
        active_count -= 1
        print(f"线程{num}退出，当前并发数量：{active_count}")
    sem.release()

if __name__ == "__main__":
    # 一次性启动20个线程，远超信号量5
    for i in range(20):
        t = threading.Thread(target=task, args=(i,))
        t.start()
```

### 5. 事件 Event

- 作用：线程间信号通知，一个线程发信号，其他线程等待
- 核心方法：`set()` 发信号、`wait()` 等待信号、`clear()` 清空信号、`is_set()` 是否有信号

对比锁 / 信号量区分用途

- Lock/Semaphore：控制**同时运行线程数量**（限流、互斥）
- Event：做**线程间通知、开关信号**，不限并发数

```python
from threading import Event
Event 是线程间信号通知工具，内部只有一个布尔标记（True/False）
event.set()：  把标记设为 True，唤醒所有阻塞等待的线程
event.clear()：把标记重置为 False
event.is_set()：返回当前标记状态 True/False
event.wait(timeout=None)：
    标记为 True：直接放行，不阻塞
    标记为 False：阻塞等待；传数字代表最多等待多少秒，超时自动放行返回 False
```

```python
import threading
import time

# 创建事件对象，默认标记False
e = threading.Event()

def worker():
    print("子线程：等待启动信号...")
    # 阻塞等待信号
    e.wait()
    print("子线程：收到信号，开始执行任务")
    time.sleep(2)
    print("子线程：任务完成")

if __name__ == "__main__":
    t = threading.Thread(target=worker)
    t.start()

    time.sleep(3)
    print("主线程：发送启动信号")
    e.set()  # 标记置True，唤醒子线程
    t.join()

----------------------------------------------------------
# 带超时 wait 示例
def worker2():
    print("等待信号，最多等2秒")
    # 最多等待2秒，没收到信号直接往下走
    res = e.wait(timeout=2)
    if res:
        print("收到信号")
    else:
        print("等待超时，无信号")
```

### 6. 定时器 Timer

- 作用：延迟指定时间后执行任务，本质是延迟启动的线程

```python
from threading import Timer

def hello():
    print("hello, world")

t = Timer(3, hello)
t.start()  # after 3 seconds, "hello, world" will be printed
```

### 7. 线程队列 queue

线程安全的队列，和 multiprocessing.Queue 用法一致，用于线程间数据传递

```python
import queue
q = queue.Queue()       # 先进先出
q = queue.LifoQueue()   # 后进先出（栈）
q = queue.PriorityQueue() # 优先级队列


# 1. Queue 先进先出 FIFO（最常用）
# 适用：普通生产者消费者、顺序处理任务
import queue
q = queue.Queue(maxsize=3)

# 存
q.put(1)
q.put(2)
# 取
print(q.get()) # 1
print(q.get()) # 2

# 2. LifoQueue 后进先出 LIFO 栈
# 适用：任务回溯、堆栈逻辑
import queue
q = queue.LifoQueue()

q.put(1)
q.put(2)
print(q.get()) # 2
print(q.get()) # 1

# 3. PriorityQueue 优先级队列，数字越小越先出
# 适用：任务分级、优先处理紧急任务
import queue
q = queue.PriorityQueue()

# (优先级, 数据)
q.put((2, "普通消息"))
q.put((1, "紧急消息"))

print(q.get()) # (1, '紧急消息')
print(q.get()) # (2, '普通消息')

通用共用方法
put() / get() / put_nowait() / get_nowait() / empty() / full()
```

---

### 第六阶段：进程池与线程池

### 1. 池的作用

进程 / 线程创建销毁开销大，池化技术预先创建好固定数量的进程 / 线程，任务来了直接复用，避免频繁创建销毁，提升性能。

### 2. 标准实现：concurrent.futures

Python 统一的池化接口，`ThreadPoolExecutor` 和 `ProcessPoolExecutor` 用法完全一致。

```bash
官网：https://docs.python.org/dev/library/concurrent.futures.html
concurrent.futures模块提供了高度封装的异步调用接口
ThreadPoolExecutor：线程池，提供异步调用
ProcessPoolExecutor: 进程池，提供异步调用
Both implement the same interface, which is defined by the abstract Executor class.

#基本方法
submit(fn, *args, **kwargs)   异步提交任务
map(func, *iterables, timeout=None, chunksize=1)  取代for循环submit的操作
shutdown(wait=True)  相当于进程池的pool.close()+pool.join()操作
            wait=True，等待池内所有任务执行完毕回收完资源后才继续
            wait=False，立即返回，并不会等待池内的任务执行完毕
            但不管wait参数为何值，整个程序都会等到所有任务执行完毕
            submit和map必须在shutdown之前
result(timeout=None)   取得结果
add_done_callback(fn)  回调函数
```

```python
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor
import time

def task(n):
    time.sleep(1)
    return n * n

# 线程池
with ThreadPoolExecutor(max_workers=5) as pool:
    # 方式1：逐个提交
    future = pool.submit(task, 10)
    print(future.result())  # 获取结果，阻塞

    # 方式2：批量提交，按提交顺序返回结果
    results = pool.map(task, [1,2,3,4,5])
    for res in results:
        print(res)

    # 方式3：回调函数：任务完成自动执行回调
    def callback(fut):
        print("任务完成，结果：", fut.result())
    pool.submit(task, 20).add_done_callback(callback)
```

### 核心说明

- `max_workers`：池内最大进程 / 线程数，CPU 密集型建议设为 CPU 核数，IO 密集型可以设大一些
- `Future` 对象：封装了任务的未来结果，可以用`result()`等待结果，`done()`判断是否完成
- 进程池同样要写在 `if __name__ == "__main__":` 下

---

#### 第七阶段：协程编程

##### 协程前置必备知识

###### 一、先吃透进程、线程、运行状态

###### 1. 三种调度单元层级

进程：操作系统资源容器

线程：OS 内核调度最小单位，切换由操作系统完成，开销大

协程：**用户态轻量级任务**，切换由代码手动控制，不经过操作系统，切换开销极小

###### 2. 线程标准 5 种运行状态

1. 新建：创建未 start
2. 就绪：等待 CPU 时间片
3. 运行：CPU 正在执行
4. 阻塞：sleep / 网络 IO / 锁，主动让出 CPU
5. 终止：代码执行完毕

> 关键：线程阻塞时操作系统会切换其他线程，有内核切换损耗；协程 IO 阻塞时**程序自己切换**，无内核参与。

###### 二、必须懂的前置概念

1. **并发与并行**
   
   协程只能并发（单线程交替执行），无法多核并行；CPU 密集不适合协程。

2. **IO 密集 / CPU 密集**
   
   协程只适配 IO 密集（网络、文件、数据库等待）；纯计算用多进程。

3. GIL 全局解释器锁
   
   协程运行在单线程内，全程只占用一把 GIL，不存在多线程争抢 GIL 切换损耗。

4. IO 模型基础（阻塞 IO、非阻塞、IO 多路复用）
   
   协程底层依靠 IO 多路复用实现自动切换 IO 任务。

5. 生产者消费者思想
   
   协程任务调度本质也是 “事件循环 + 待执行任务队列”。

###### 三、线程 vs 协程核心区别（前置重点）

1. 切换主体：线程由 OS 切换；协程由用户程序切换
2. 切换开销：线程开销大；协程极轻量，可开上万协程
3. 资源占用：线程栈内存大；协程内存占用极低
4. 调度规则：线程抢占式调度；协程协作式（主动让出才切换）
5. 数据共享：同线程内协程共享全局变量，无需频繁加锁

###### 四、协程自身运行状态（asyncio）

1. 新建 (coroutine)：定义 async 函数未调度
2. 就绪：放入事件循环等待执行
3. 运行：正在执行代码
4. 挂起：遇到 await IO，主动让出循环
5. 完成 / 异常：执行结束或抛出错误

### 1. 协程本质

用户态的轻量级线程，**在单线程内实现任务切换**，完全由程序自己控制，没有操作系统线程切换的开销，并发效率极高，专为 IO 密集型场景设计。

### 2. 协程 vs 线程 vs 进程

- 切换开销：进程 > 线程 > 协程
- 并发量级：进程几十个、线程几百个、协程几万个
- 适用场景：CPU 密集用多进程，IO 密集用协程 / 多线程

### 3. 底层手动切换：greenlet

第三方库，手动控制切换时机，非常底层，几乎不直接用

```python
#安装：pip3 install greenlet
from greenlet import greenlet

def func1():
    print("func1 第一步")
    gr2.switch()  # 切换到func2
    print("func1 第二步")

def func2():
    print("func2 第一步")
    gr1.switch()  # 切回func1
    print("func2 第二步")

gr1 = greenlet(func1)
gr2 = greenlet(func2)
gr1.switch()  # 启动
```

### 4. 自动切换：gevent

第三方库，遇到 IO 自动切换协程，早期 Python 协程主流方案

```python
import gevent
from gevent import monkey; monkey.patch_all()  # 猴子补丁：把所有阻塞IO改成非阻塞，自动触发切换
import time

def task(name):
    for i in range(3):
        print(f"{name} 执行第{i}次")
        time.sleep(1)  # 被补丁替换，遇到IO自动切其他协程

g1 = gevent.spawn(task, "协程1")
g2 = gevent.spawn(task, "协程2")
g1.join()
g2.join()
```

### 5. 标准库原生协程：asyncio（补充，当前主流）

Python3.5+ 官方标准，`async/await` 语法，现在是 Python 协程的主流方案

```python
# 1. async / await 是Python内置关键字，不用import asyncio也存在
# async def 定义协程函数，调用仅生成协程对象，不会执行内部代码
# await 只能写在async函数内：IO阻塞时让出事件循环，切换其他协程
# async/await 是语法糖，替代老式 @asyncio.coroutine + yield from

import asyncio

# 协程函数
async def task(name):
    for i in range(3):
        print(f"{name} 执行第{i}次")
        # asyncio.sleep(1)：异步休眠，不阻塞线程；await等待休眠完成
        await asyncio.sleep(1)

# 主协程
async def main():
    # asyncio.gather(*coro_list)：批量并发执行多个协程，统一收集返回值
    # await 等待gather内所有协程全部执行完成再往下走
    await asyncio.gather(
        task("协程1"),
        task("协程2")
    )

# 程序入口，3.7+专用
# 自动创建事件循环、执行协程、结束后关闭循环
asyncio.run(main())
```

**核心 api 精简注释**

```bash
# 1. asyncio.run(coro) 异步程序标准入口
# 2. asyncio.gather(*coros) 批量并发协程
# 3. asyncio.sleep(sec) 非阻塞延时，搭配await使用
# 4. asyncio.create_task(coro) 创建后台Task，提前调度执行

# 老式等价写法（已淘汰，仅理解语法糖）
@asyncio.coroutine
def old_task():
    yield from asyncio.sleep(1)  # yield from = await
```

- 核心组件：事件循环（EventLoop）、任务（Task）、Future
- 原理：单线程跑事件循环，遇到 IO 就挂起当前协程，调度下一个就绪的协程，全程无线程切换开销

练习: 单线程使用协程多并发socket 连接

- 服务端：`asyncio` 异步多 TCP 服务端（单协程并发处理连接）
- 客户端：多线程并发大量 TCP 连接压测服务端

```python
# asyncio 异步TCP服务端
import asyncio

async def handle_client(reader: asyncio.StreamReader, writer: asyncio.StreamWriter):
    """处理单个客户端连接协程"""
    addr = writer.get_extra_info("peername")
    print(f"[服务端] 新连接: {addr}")
    try:
        # 读取客户端数据
        data = await reader.read(1024)
        msg = data.decode("utf-8")
        print(f"[{addr}] 收到消息: {msg}")
        # 回写数据
        resp = f"服务端已收到: {msg}".encode("utf-8")
        writer.write(resp)
        await writer.drain()
    except Exception as e:
        print(f"[{addr}] 连接异常: {e}")
    finally:
        writer.close()
        await writer.wait_closed()
        print(f"[{addr}] 连接关闭")

async def start_tcp_server():
    """启动异步TCP服务，监听127.0.0.1:8888"""
    server = await asyncio.start_server(
        handle_client,
        host="127.0.0.1",
        port=8888
    )
    addrs = server.sockets[0].getsockname()
    print(f"异步TCP服务启动成功 {addrs}")
    # 永久运行服务
    async with server:
        await server.serve_forever()

# ---------------- 多线程TCP客户端 ----------------
import threading
import socket

def tcp_client_task(client_id: int):
    """单线程客户端函数，同步socket连接服务端"""
    try:
        sock = socket.socket()
        sock.connect(("127.0.0.1", 8888))
        send_msg = f"客户端{client_id} 测试消息"
        sock.send(send_msg.encode("utf-8"))
        recv_data = sock.recv(1024)
        print(f"[客户端{client_id}] 服务端响应: {recv_data.decode()}")
        sock.close()
    except Exception as e:
        print(f"[客户端{client_id}] 连接失败: {e}")

def start_multi_thread_client(thread_num=10):
    """开启thread_num个线程并发连接TCP服务端"""
    thread_list = []
    for i in range(thread_num):
        t = threading.Thread(target=tcp_client_task, args=(i,))
        thread_list.append(t)
        t.start()
    # 等待所有客户端线程执行完毕
    for t in thread_list:
        t.join()

if __name__ == "__main__":
    # 运行多线程客户端（先启动服务端再执行）
    start_multi_thread_client(thread_num=10)
```

---

### 第八阶段：IO 模型理论

### 1. 两组概念辨析

#### 阻塞 vs 非阻塞（调用者的状态）

- **阻塞**：调用发起后，线程挂起，啥也干不了，直到结果返回
- **非阻塞**：调用发起后，立刻返回，线程可以继续干别的，需要自己轮询结果

#### 同步 vs 异步（消息通知机制）

- **同步**：发起调用后，需要主动等待 / 轮询结果，自己去拿数据
- **异步**：发起调用后立刻返回，不用等，结果准备好后系统主动通知你

### 2. 五大 IO 模型（从低效到高效）

1. **阻塞 IO（BIO）**：全程阻塞，最简单，并发能力最差
2. **非阻塞 IO（NIO）**：非阻塞 + 轮询，浪费 CPU，实际很少用
3. **IO 多路复用**：一个线程监听多个连接，哪个就绪就处理哪个，高并发基础（select/poll/epoll）
4. **信号驱动 IO**：就绪了发信号通知，用得少
5. **异步 IO（AIO）**：全程不阻塞，内核把数据拷贝完再通知，效率最高，实现复杂

### 核心结论

- 协程 + IO 多路复用 = 单线程高并发的核心实现
- Nginx、Redis、Node.js 高性能的核心都是 IO 多路复用

IO模型深度解析

```bash
1. IO 多路复用：「路」和「复用」到底是什么？
路 = 一路 IO 流 = 一个 socket 连接（文件描述符 fd）
多路 = 成千上万个客户端 TCP 连接、文件 IO 等多条数据流
复用 = 只用单一线程 / 进程 **，同时监控、处理所有路 IO，不用一个连接开一个线程 **
通俗比喻：
多路复用 = 1 个前台服务员（单线程），大厅装统一叫号器（内核 epoll），同时看管几十桌客人（多路 socket）；哪一桌有数据就绪，服务员就去哪桌处理，不用每桌配专属服务员（多线程 BIO）。

2. 多路复用工作流程（区分非阻塞轮询）
程序把所有 socket 交给内核 epoll 统一监控
调用epoll_wait阻塞线程，内核帮你等待所有 IO，不是代码自己循环轮询
任意 socket 收到数据，内核主动唤醒线程，只返回就绪的 socket 列表
线程只处理有数据的连接，闲置时完全休眠，无 CPU 空转
对比非阻塞 IO：代码死循环不断recv()挨个查询所有 socket，全程占用 CPU 空跑。

3. 信号驱动 IO（SIGIO）通俗理解
提前给 socket 注册信号回调，告知内核：数据到了发 SIGIO 信号通知我
程序正常运行，不用阻塞、不用轮询
内核收到数据后，发信号打断当前代码，进入信号处理函数
关键短板：信号只是通知「数据就绪」，你仍要手动调用recv拷贝内核数据到用户空间，拷贝阶段会阻塞线程
比喻：鱼竿装铃铛，鱼上钩铃铛响（内核发信号），但你还是要亲手收线（拷贝数据）。
缺点：信号容易丢失、多连接管理复杂，生产几乎不用，被 epoll 淘汰。

4. 非阻塞 IO vs 异步 IO（AIO）核心区别
共同点
两者发起 IO 调用都会立刻返回，不会卡死线程，底层都交给内核收发数据。

核心分界线（两步 IO 流程）
所有 IO 分 2 阶段：
① 内核等待网络数据到达缓冲区；
② 将内核缓冲区数据拷贝到程序内存。

阻塞IO,非阻塞 IO、多路复用、信号驱动：都属于同步 IO
阶段①等待交给内核；阶段②拷贝数据必须程序主动调用 recv，会阻塞，需要你主动扫描 / 处理结果。
真正异步 IO (AIO/io_uring)：全程托管内核
发起请求后直接干别的，内核自动完成「等数据 + 拷贝到用户内存」两步；全部做完才主动通知程序，程序拿到直接用，无需再调用读写函数。

5. 协程和多路复用的关系
epoll（多路复用）负责内核监控所有 socket；
asyncio 事件循环基于 epoll(epoll是基于IO多路复用实现的)遇到await时把当前协程挂起，切换执行其他就绪协程；
单线程内用户态切换协程，切换开销远小于操作系统线程切换；
多路复用是底层内核能力，协程是上层语言封装，二者搭配实现高并发 TCP 服务。

五大 IO 模型极简对比总结
阻塞 BIO：一个连接一个线程，调用 recv 直接卡死线程，并发极低。
非阻塞 NIO：单线程管理多 socket，while 循环轮询全部连接，CPU 空转浪费。
IO 多路复用 (epoll)：单线程监控万级连接，内核帮忙等待，只处理就绪 fd，Python asyncio 底层依赖它（生产主流）。
信号驱动 IO：数据就绪发信号通知，仍需手动拷贝数据，极少使用。
异步 AIO：内核完成全部 IO 操作后回调通知，Linux 老版本支持差，业务开发少见。


信号驱动 IO、AIO 理论性能更高，实际却流行 epoll 多路复用，4 个核心原因 ?
1 信号驱动 IO 缺陷多：信号全局中断、易丢失、多连接难管理，无商用价值。
2 传统 libaio 局限大：仅支持裸磁盘 IO，不支持网络 socket，业务场景不匹配。
3 io_uring 门槛高：依赖高版本 Linux 5.1内核，改造现有程序成本高。
4 epoll 均衡好用：全 IO 场景兼容、API 简单、性能满足绝大多数网络业务，服务器普遍适配。


io_uring 有没有配套开发模块、Python实现？
1. C 底层：liburing
官方 C 库，封装 io_uring 系统调用，操作系统自带。
2. Python 第三方模块（已成熟可用）
pyuring / liburing：底层封装，手动构造 IO 任务，原生 io_uring 调用
uringcore：直接替换 asyncio 默认 epoll 事件循环，整个协程框架底层切换 io_uring，业务代码几乎不用改
aiofiles_v2：基于 io_uring 的异步文件读写，替代旧版线程池模拟异步文件
3. Python 官方发展
Python3.15 计划原生支持 io_uring 作为 asyncio 可选后端（内核≥5.19），未来会内置支持，不用第三方库。
```

---

### 第九阶段：IO 多路复用实现

### 1. select /poll/epoll 对比

| 方案     | 最大连接数 | 工作机制       | 性能随连接数下降 | 平台支持  |
| ------ | ----- | ---------- | -------- | ----- |
| select | 1024  | 轮询遍历所有     | 严重       | 全平台   |
| poll   | 无限制   | 轮询遍历所有     | 严重       | 全平台   |
| epoll  | 无限制   | 事件回调，就绪才通知 | 几乎不下降    | Linux |

### 2. selectors 模块

Python 标准库对 IO 多路复用的高层封装，自动选择当前平台最优的实现（Linux 用 epoll，Windows 用 select）

核心区别

1. selectors：底层 API，手动管理 socket、事件、读写回调，无协程，纯同步事件循环。
2. asyncio：高层封装，自带事件循环、协程 Task、gather、Stream 读写，自动处理调度，开发简单。

```python
# 导入标准多路复用模块、原生socket
import selectors
import socket

# 自动根据操作系统创建最优多路复用实例
# Linux返回epoll、macOS返回kqueue、Windows返回select
sel = selectors.DefaultSelector()

def accept(sock: socket.socket, mask):
    """
    监听socket就绪时触发的回调函数
    :param sock: 就绪的服务端监听socket
    :param mask: 触发的事件掩码，这里是EVENT_READ（有新连接到来）
    """
    # 接收客户端连接，返回新通信套接字+客户端地址
    conn, addr = sock.accept()
    # 将客户端连接设为非阻塞，多路复用必须配合非阻塞socket使用
    conn.setblocking(False)
    print("新连接", addr)
    # sel.register(fileobj, events, data=None)
    # fileobj：要监听的fd/套接字；events：监听事件；data：绑定自定义回调函数
    sel.register(conn, selectors.EVENT_READ, read)

def read(conn: socket.socket, mask):
    """
    客户端socket有数据可读时触发的回调
    :param conn: 有数据的客户端连接socket
    :param mask: 事件类型EVENT_READ
    """
    # 从内核缓冲区读取1024字节数据
    data = conn.recv(1024)
    if data:
        # 收到有效数据，打印并回复
        print("收到:", data.decode())
        conn.send(b"ok\n")
    else:
        # data为空代表客户端正常关闭连接
        # 先从多路复用器中注销该socket，不再监听
        sel.unregister(conn)
        # 关闭套接字释放资源
        conn.close()

# ---------------------- 初始化服务端监听socket ----------------------
# 创建TCP套接字
server_sock = socket.socket()
# 绑定本机8888端口
server_sock.bind(("127.0.0.1", 8888))
# 开启监听，等待客户端接入
server_sock.listen()
# 监听套接字设置为非阻塞
server_sock.setblocking(False)
# 将监听socket注册到多路复用器
# EVENT_READ：监听读事件，有新连接到达时触发
# data=accept：把accept函数绑定，事件就绪时自动调用
sel.register(server_sock, selectors.EVENT_READ, accept)

# ---------------------- 主事件循环，永久运行 ----------------------
while True:
    # sel.select(timeout=None)：阻塞等待，直到有socket事件就绪
    # 返回列表，每个元素是(key, mask)二元组
    events = sel.select()
    # 遍历所有就绪的socket事件
    for key, mask in events:
        # key.data 就是register时绑定的自定义函数(accept / read)
        callback = key.data
        # 执行回调：传入就绪socket、事件掩码
        callback(key.fileobj, mask)

----------------------------------------------------#client.py
import threading
import socket

def tcp_client_task(client_id: int):
    """单线程客户端函数，同步socket连接服务端"""
    try:
        sock = socket.socket()
        sock.connect(("127.0.0.1", 8888))
        send_msg = f"客户端{client_id} 测试消息"
        sock.send(send_msg.encode("utf-8"))
        recv_data = sock.recv(1024)
        print(f"[客户端{client_id}] 服务端响应: {recv_data.decode()}")
        sock.close()
    except Exception as e:
        print(f"[客户端{client_id}] 连接失败: {e}")

def start_multi_thread_client(thread_num=10):
    """开启thread_num个线程并发连接TCP服务端"""
    thread_list = []
    for i in range(thread_num):
        t = threading.Thread(target=tcp_client_task, args=(i,))
        thread_list.append(t)
        t.start()
    # 等待所有客户端线程执行完毕
    for t in thread_list:
        t.join()

if __name__ == "__main__":
    # 运行多线程客户端（先启动服务端再执行）
    start_multi_thread_client(thread_num=10)
```

> 这就是单线程并发处理上千个连接的基础，也是 asyncio、Tornado 等异步框架的底层原理。
> 
> `selectors` 业务开发**基本不用**，属于底层原理理解用，写业务直接上 `asyncio`；

---

### 第十阶段：并发选型总结（最终落地）

1. IO 密集高并发场景：
   - 高并发、追求极致性能: 优先 asyncio（单线程协程）；
   - 简单场景、代码改造成本低：用**多线程**（threading / ThreadPoolExecutor）
2. CPU 密集计算：**多进程**（multiprocessing / ProcessPoolExecutor），绕开 GIL 利用多核；
3. 大量短时并发请求、限制连接数：**多线程 + Semaphore 信号量**。
4. **混合场景**：多进程 + 协程组合，每个进程跑一个事件循环

#### 二、分场景：落地必学组合（生产真正常用）

##### 场景 1：网络 IO 高并发（爬虫、TCP 服务、接口网关、异步 Web FastAPI）

##### 核心组合：asyncio 全家桶（必掌握）

1. `async def / await` 基础语法

2. `asyncio.run`、`asyncio.gather`、`asyncio.create_task`

3. `asyncio.Semaphore`：协程并发限流（爬虫限制同时请求数）

4. `asyncio.Queue`：协程生产者消费者

5. `asyncio.Event`：协程开关、启停控制
   
   配套第三方：aiohttp、aiomysql、redis 异步客户端

> 不需要线程池，纯协程单线程跑，性能远优于多线程。

#### 场景 2：同步阻塞 IO（requests、同步数据库、老接口），需要并发压测 / 批量任务

##### 核心组合：threading 线程池 + Semaphore

1. `threading.Thread` 基础

2. `concurrent.futures.ThreadPoolExecutor` 线程池（落地最频繁）

3. `threading.Semaphore` 限流，防止瞬间上千线程打爆服务

4. `queue.Queue` 线程安全队列存任务
   
   适用：简单批量脚本、同步接口批量调用，不想改异步代码。

#### 场景 3：大量 CPU 计算（解析超大文件、数值运算）

##### 核心组合：多进程 ProcessPoolExecutor

GIL 限制线程无法多核并行，必须进程；几乎不和协程混用。

#### 场景 4：混合场景（协程为主，少量同步阻塞代码）

协程里同步代码会卡整个事件循环，两种标准搭配方案：

1. `asyncio.to_thread()`：把同步函数丢进内置线程池执行，不阻塞协程循环；
2. 复杂同步逻辑：单独开线程池，协程通过队列通信。

#### 三、只需要理解、几乎不会手写落地的概念（看懂即可，不用硬背手写）

1. IO 模型：阻塞 / 非阻塞 / 多路复用 / AIO、epoll、io_uring（面试考点，业务不写底层）
2. `selectors` 模块、原生非阻塞 socket 轮询
3. 信号驱动 IO、libaio 底层细节
4. 老式生成器协程 `yield from`

#### 四、线程模块里高频落地工具（必须会用）

1. Lock / RLock：多线程共享变量加锁
2. Queue：线程安全任务队列
3. Semaphore：线程并发限流
4. Event：线程启停开关
5. Timer：延迟任务

#### 五、极简总结（落地优先级）

1. 主流首选：`asyncio` + asyncio.Semaphore + asyncio.Queue（网络 IO 天花板）
2. 同步脚本首选：`ThreadPoolExecutor` + Semaphore
3. CPU 计算：`ProcessPoolExecutor`
4. 混合同步 + 异步：`asyncio.to_thread`
