# Ansible 学习路线

------

## 先讲一个最重要的前提

**Ansible 100% 基于你之前学的 SSH**

你之前花时间学的 SSH 免密登录、跳板机、端口转发，全都是 Ansible 的基础。Ansible 不需要在被控机器上装任何客户端，只需要被控机器开着 SSH，控制节点能通过 SSH 免密登录就行。

------

## 第一阶段：入门必学

### 1. 环境搭建

**控制节点**（你自己的电脑 / 运维机）：

- 安装 Ansible：`sudo apt install ansible`（Ubuntu）或 `yum install ansible`（CentOS）
- 验证：`ansible --version`

**被控节点**（所有要管理的服务器）：

- 什么都不用装！只需要：

  1. 开启 SSH 服务（默认都开着）
  2. 配置控制节点到被控节点的**SSH 免密登录**（用你之前学的`ssh-copy-id`）

  ```bash
  # 生成ED25519密钥对（推荐，生产标准）
  ssh-keygen -t ed25519 -C "运维-张三-生产环境-20260503"
  
  # 若需要兼容老旧系统（不支持ED25519），用RSA 4096
  # ssh-keygen -t rsa -b 4096 -C "运维-张三-生产环境-20260503"
  -t：指定密钥类型（rsa/ed25519）
  -b：指定密钥长度（4096 位最高强度）
  -C：给密钥加注释，方便管理
  
  # 标准方法（推荐，自动处理权限）
  ssh-copy-id -i ~/.ssh/id_ed25519.pub root@10.0.0.4
  
  # 测试免密登录，此时应该不需要输入服务器密码
  ssh root@10.0.0.4
  
  -----------------------------------------------
  # 把所有服务器IP写到一个文件里
  cat > servers.txt << EOF
  10.0.0.2
  10.0.0.4
  10.0.0.5
  10.0.0.6
  10.0.0.7
  10.0.0.8
  10.0.0.9
  EOF
  
  # 批量分发公钥（会提示输入每台服务器的密码）
  for ip in $(cat servers.txt); do
    echo "正在分发公钥到 $ip"
    ssh-copy-id -i ~/.ssh/id_ed25519.pub root@$ip
  done
  
  ----------------------------------------------------------
  # 服务器列表
  SERVERS=(
    "10.0.0.2"
    "10.0.0.4"
    "10.0.0.5"
  )
  
  # 统一的服务器密码（生产环境绝对不要这么写！）
  PASSWORD="1"
  
  # 批量分发
  for ip in "${SERVERS[@]}"; do
    echo "正在分发公钥到 $ip"
    sshpass -p "$PASSWORD" ssh-copy-id -i ~/.ssh/id_ed25519.pub -o StrictHostKeyChecking=no root@$ip
  done
  
  #-p "$PASSWORD"：自动输入密码
  # -o StrictHostKeyChecking=no：跳过 known_hosts 指纹确认，避免第一次连接提示
  # history  -c
  # 生产环境绝对不推荐用 sshpass 的原因
  1. 极度不安全
  密码明文暴露：密码会直接出现在命令行、Shell 历史记录（history）、进程列表（ps aux）里，任何人都能看到
  违反安全规范：所有企业的安全规范都禁止在命令行中明文传递密码
  2. 可靠性差
  无法处理密码错误、连接超时等异常情况
  不同服务器密码不同时，脚本很难写
  
  ```

  

### 2. Inventory 主机清单（2 小时）

**是什么**：Ansible 的 "通讯录"，记录所有你要管理的服务器 IP、分组、变量。

**为什么重要**：这是 Ansible 的入口，所有操作都基于它。

**基础写法**（默认文件：`/etc/ansible/hosts`）：



```
# 单独的服务器
10.0.0.2

# 分组管理（最常用）
[web]
10.0.0.7
10.0.0.8

[db]
10.0.0.9

[backup]
10.0.0.4

[nfs]
10.0.0.5 


# 嵌套分组
[all:children]
web
db
```

**验证主机是否连通**：

```
# 测试所有主机连通性
ansible all -m ping

# 测试web组主机连通性
ansible web -m ping
```

### 3. Ad-hoc 临时命令

**是什么**：不用写脚本，一行命令批量执行操作。

**为什么重要**：运维日常 90% 的临时批量操作都用它，比如批量查磁盘、批量装软件、批量改密码。

**基本格式**：

```
ansible <主机组/主机> -m <模块名> -a "<模块参数>"
```

**常用模块**：

| 模块名             | 核 心作用                                     | 生产常用例子                                                 |
| ------------------ | --------------------------------------------- | ------------------------------------------------------------ |
| **ping**           | 测试主机连通性（最基础必用）                  | `ansible all -m ping`                                        |
| **command**        | 执行简单远程命令（不支持管道 / 重定向）       | `ansible web -m command -a "df -h"`                          |
| **shell**          | 执行复杂远程命令（支持管道 / 重定向 / 变量）  | ansible web -m shell -a "free -h grep Mem"                   |
| **script**         | 把**本地脚本**传到远程服务器并执行            | ansible web -m script -a "./deploy.sh"                       |
| **copy**           | 把本地文件 / 目录复制到远程服务器             | `ansible web -m copy -a "src=./nginx.conf dest=/etc/nginx/nginx.conf mode=644 owner=root"` |
| **file**           | 创建 / 删除文件 / 目录、修改权限 / 属主       | `ansible web -m file -a "path=/data/logs state=directory mode=755 owner=nginx"` |
| **service**        | 管理系统服务（启动 / 停止 / 重启 / 开机自启） | `ansible web -m service -a "name=nginx state=restarted enabled=yes"` |
| **yum**            | CentOS/RHEL 系统安装 / 卸载软件包             | `ansible web -m yum -a "name=nginx state=present"`           |
| **apt**            | Ubuntu/Debian 系统安装 / 卸载软件包           | `ansible web -m apt -a "name=nginx state=present update_cache=yes"` |
| **template**       | 渲染 Jinja2 模板并复制到远程（动态生成配置）  | `ansible web -m template -a "src=./nginx.conf.j2 dest=/etc/nginx/conf.d/default.conf"` |
| **authorized_key** | 批量分发 SSH 公钥（配置免密登录）             | `ansible all -m authorized_key -a "user=root key='{{ lookup('file', '~/.ssh/id_ed25519.pub') }}'"` |
| **fetch**          | 从远程服务器拉取文件到本地（与 copy 相反）    | `ansible web -m fetch -a "src=/var/log/nginx/access.log dest=./logs/ flat=yes"` |
| **lineinfile**     | 修改文件中的单行内容（增删改查）              | `ansible all -m lineinfile -a "path=/etc/hosts line='192.168.1.100 web01'"` |
| **user**           | 管理系统用户（创建 / 删除 / 修改属性）        | `ansible all -m user -a "name=ops state=present groups=wheel shell=/bin/bash"` |
| **group**          | 管理系统用户组                                | `ansible all -m group -a "name=dev state=present"`           |
| **cron**           | 管理系统定时任务                              | `ansible web -m cron -a "name='清理日志' minute=0 hour=3 job='/usr/bin/rm -rf /data/logs/*.log'"` |
| **setup**          | 收集远程服务器系统信息（事实变量）            | `ansible web -m setup -a "filter=ansible_default_ipv4"`      |
| **raw**            | 执行原始命令（用于没有 Python 的老旧系统）    | `ansible old_server -m raw -a "uptime"`                      |
| **mount**          | 管理磁盘挂载点（挂载 / 卸载 / 开机自启）      | ansible db -m mount -a "path=/data src=/dev/sdb1 fstype=xfs state=mounted" |

**练习**：用 Ad-hoc 命令给所有 web 服务器安装 nginx 并启动。

### 4. Playbook 剧本基础

**是什么**：用 YAML 写的自动化脚本，把多个步骤组合起来，可重复执行。

**为什么重要**：复杂的自动化任务（比如部署网站、初始化服务器）必须用 Playbook。

**YAML 语法注意事项**（新手最容易错的地方）：

1. 用**空格缩进**，不能用 Tab
2. 冒号后面必须跟一个空格
3. 列表用`-`开头

**最简单的 Playbook 例子**（安装并启动 nginx）：

```yaml
# nginx_install.yml
- name: 安装并启动Nginx
  hosts: web  # 对web组的服务器执行
  become: yes  # 用root权限执行

  tasks:  # 任务列表，按顺序执行
    - name: 安装Nginx
      yum:
        name: nginx
        state: present

    - name: 启动Nginx并设置开机自启
      service:
        name: nginx
        state: started
        enabled: yes
```

**执行 Playbook**：

```bash
ansible-playbook nginx_install.yml
```

------

## 第二阶段：核心必学

### 1. Playbook 进阶语法

#### （1）变量 Variables

**是什么**：把重复的值抽出来，方便修改和复用。

 **变量必须记住的 3 条规则**

1. **变量名只能字母、数字、下划线**
2. **调用必须写 {{变量名}}**
3. **冒号后面必须有空格**

**面试必问（背下来）**

变量优先级（从高到低）

命令行 `-e` > 单独变量文件 > Playbook vars > Inventory 变量

#### 2. 变量作用

方便统一修改、提高可读性、避免重复写死值。

**定义方式**：

- 在 Playbook 中定义：

  ```yaml
  vars:
    nginx_port: 80
    nginx_user: nginx
    
  --------------------------------------示例
  - name: 安装Nginx
    hosts: web
    vars: #这里定义变量
      nginx_port: 80
      nginx_user: nginx
      nginx_home: /usr/share/nginx/html
  
    tasks:
      - name: 启动Nginx
        service:
          name: "{{ nginx_user }}" #调用变量
          state: started
  ```

  

- 在 Inventory 中定义： 给不同机器不同变量

  

  ```ini
  [web]
  192.168.1.100 nginx_port=8080
  192.168.1.101 nginx_port=8081
  
  # Playbook 里直接用 {{ nginx_port }}
  ```

  

  #### 方式 3：单独变量文件（企业标准）

  新建 `vars.yml`

  

  ```yaml
  nginx_port: 80
  nginx_user: nginx
  ```

  Playbook 里引用：

  ```yaml
  - name: 部署Nginx
    hosts: web
    vars_files:
      - vars.yml
  
    tasks:
      - name: 启动服务
        service:
          name: "{{ nginx_user }}"
  ```

  ------

  #### 方式 4：命令行传变量（临时覆盖）

  ```bash
  ansible-playbook nginx.yml -e "nginx_port=8080"
  ```

  ------

  #### 变量类型（必须会 3 种）

  ##### 1. 普通变量

  ```
  port: 80
  ```

  ##### 2. 列表变量（数组）

  ```
  packages:
    - nginx
    - mysql
    - php
  ```

  使用（循环）：

  ```
  - name: 安装软件
    yum:
      name: "{{ item }}"
      state: present
    loop: "{{ packages }}"
  ```

  ##### 3. 字典变量（key=value）

  ```
  nginx:
    port: 80
    user: nginx
    home: /usr/share/nginx/html
  ```

  使用：

  ```
  {{ nginx.port }}
  {{ nginx.user }}
  ```

#### 变量实战例子（你直接复制就能用）

```BASH
- name: 变量完整演示（修正版）
  hosts: web
  vars:
    # 端口变量
    web_port: 80
    # 运行服务的系统用户
    web_user: nginx
    # 需要批量安装的软件列表
    web_packages:
      - nginx
      - vim

  tasks:
    - name: 批量安装 Web 服务软件
      yum:
        # loop 循环时，item 自动赋值为 nginx、vim
        name: "{{ item }}"
        state: present
      loop: "{{ web_packages }}"

    - name: 启动 Nginx 并设置开机自启
      service:
        name: nginx       # 服务名：nginx（正确）
        state: started
        enabled: yes
```



#### （2）Handlers 触发器

**是什么**：只有当任务执行结果发生变化时才会执行的任务。

**为什么重要**：比如只有当配置文件修改了，才需要重启服务，避免不必要的重启。

**例子**：

```yaml
tasks:
  - name: 复制Nginx配置文件
    copy:
      src: ./nginx.conf
      dest: /etc/nginx/nginx.conf
    notify: 重启Nginx  # 触发handler

handlers:  # 触发器，放在tasks后面
  - name: 重启Nginx
    service:
      name: nginx
      state: restarted
```

#### （3）条件判断 When

**是什么**：根据不同条件执行不同任务。

**例子**：不同操作系统安装不同软件

```yaml
- name: 在CentOS上安装nginx
  yum:
    name: nginx
    state: present
  when: ansible_os_family == "RedHat"

- name: 在Ubuntu上安装nginx
  apt:
    name: nginx
    state: present
  when: ansible_os_family == "Debian"
```

#### （4）循环 Loop

**是什么**：批量执行相同的任务。

**例子**：批量创建多个用户

```yaml
- name: 创建多个用户
  user:
    name: "{{ item }}"
    state: present
  loop:
    - user1
    - user2
    - user3
```

#### 2. 角色 Roles（最重要的核心）

**是什么**：把 Playbook 按功能拆分成独立的模块，方便复用和维护。

**为什么重要**：当你的 Playbook 超过 100 行，或者有多个项目需要管理时，不用 Roles 会变成一团乱麻。

一个角色 = 一个功能（比如 nginx、mysql、docker）

**Roles 标准目录结构**：

```
roles/
  nginx/  # nginx角色
    tasks/      # 任务
      main.yml
    handlers/   # 触发器
      main.yml
    templates/  # 模板文件
      nginx.conf.j2
    vars/       # 变量
      main.yml
    defaults/   # 默认变量
      main.yml
    files/      # 静态文件
    meta/       # 角色依赖
```

**怎么用 Roles**：

1. 创建角色：`ansible-galaxy init nginx`（自动生成上面的目录结构）

```
ansible-galaxy init ./roles/nginx

[root@ansible ~]# tree ./roles/
./roles/
└── nginx          # nginx角色
    ├── defaults   # 默认变量
    │   └── main.yml
    ├── files      # 静态文件
    ├── handlers   # 触发器
    │   └── main.yml
    ├── meta       # 角色依赖
    │   └── main.yml
    ├── README.md
    ├── tasks      # 任务
    │   └── main.yml
    ├── templates  # 模板文件
    ├── tests      # 测试文件夹 完全不需要，删除掉
    │   ├── inventory
    │   └── test.yml
    └── vars     # 变量
        └── main.yml
        
roles 同级 目录手动新建一个site.yml 作为主剧本用来调用其他角色 

```



  2.把对应的任务、变量、模板放到对应的目录里

```bash
cat > roles/nginx/vars/main.yml <<EOF
# 端口
nginx_port: 80
# 安装的软件包
nginx_packages:
  - nginx
  - vim
EOF

cat > roles/nginx/tasks/main.yml <<EOF
# 1. 批量安装软件
- name: 安装 Nginx 软件
  yum:
    name: "{{ item }}"
    state: present
  loop: "{{ nginx_packages }}"

# 2. 推送模板配置文件
- name: 部署 Nginx 配置文件
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  # 配置修改后，触发重启
  notify: 重启 Nginx

# 3. 启动服务并开机自启
- name: 启动 Nginx 服务
  service:
    name: nginx
    state: started
    enabled: yes
EOF

cat > roles/nginx/handlers/main.yml <<EOF
- name: 重启 Nginx
  service:
    name: nginx
    state: restarted
EOF

cat > roles/nginx/templates/nginx.conf.j2 <<EOF
user nginx;
worker_processes auto;

events {
    worker_connections 1024;
}

http {
    server {
        # 变量来自 vars/main.yml
        listen {{ nginx_port }};
        root /usr/share/nginx/html;
        index index.html;
    }
}
EOF




```



3. 在 Playbook 中引用角色：

```yaml
# 主剧本
cat > ansible_demo/site.yml <<EOF
- name: 部署 Nginx 服务
  hosts: web
  # 提权 root
  become: yes
  # 调用 nginx 角色
  roles:
    - nginx
EOF


#最终目录结构
ansible_demo/
├── roles/
│   └── nginx/
│       ├── vars/main.yml
│       ├── tasks/main.yml
│       ├── handlers/main.yml
│       └── templates/nginx.conf.j2
└── site.yml

# 一键运行
ansible-playbook site.yml
```



#### 3. Jinja2 模板

**是什么**：动态生成配置文件的模板语言。

**为什么重要**：不同服务器的配置文件可能有细微差别（比如端口、IP），用模板可以自动生成不同的配置文件。

**例子**：nginx.conf.j2 模板

```nginx
# roles/nginx/vars/main.yml
# 基础变量
nginx_user: nginx
web_root: /usr/share/nginx/html

# 判断用变量：环境类型 (test/prod)
run_env: prod

# 循环用变量：多站点配置
web_sites:
  - name: blog
    port: 8081
  - name: shop
    port: 8082
  - name: admin
    port: 8083


#roles/nginx/templates/nginx.conf.j2
{# 1. Jinja2 注释 #}
user {{ nginx_user }};  {# 2. 变量调用 #}
worker_processes auto;

events {
    worker_connections 1024;
}

http {
    include mime.types;
    default_type application/octet-stream;

    {# 3. if 判断：生产/测试环境配置不同 #}
    {% if run_env == "prod" %}
    sendfile on;
    keepalive_timeout 65;
    {% else %}
    sendfile off;
    keepalive_timeout 10;
    {% endif %}

    {# 4. for 循环：批量生成多站点配置 #}
    {% for site in web_sites %}
    server {
        listen {{ site.port }};
        server_name {{ site.name }};
        root {{ web_root }}/{{ site.name }};
        index index.html;
    }
    {% endfor %}
}


    

        

# roles/nginx/tasks/main.yml
- name: 安装 Nginx
  yum:
    name: nginx
    state: present

- name: 部署三合一模板配置
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: 重启 Nginx

- name: 启动 Nginx
  service:
    name: nginx
    state: started
    enabled: yes
        

        
        
```



------

## 第三阶段：进阶必学

### 1. 标签 Tags

**是什么**：给 Playbook 中的任务打标签，只执行指定标签的任务。

**为什么重要**：一个大的 Playbook 可能有几十上百个任务，不用每次都从头执行。

**例子**：

```yaml
tasks:
  - name: 安装Nginx
    yum:
      name: nginx
      state: present
    tags: install

  - name: 配置Nginx
    template:
      src: nginx.conf.j2
      dest: /etc/nginx/conf.d/default.conf
    tags: config
```

**执行指定标签的任务**：

```
ansible-playbook nginx.yml --tags config  # 只执行配置任务
ansible-playbook nginx.yml --skip-tags install  # 跳过安装任务
```

### 2. 错误处理

- `ignore_errors: yes`：忽略错误，继续执行后面的任务
- `failed_when`：自定义失败条件
- `block/rescue/always`：异常处理（类似 try/catch/finally）

### 3. 调试 Debug

**是什么**：打印变量和任务执行结果，排查问题。

**例子**：

```yaml
- name: 打印服务器IP
  debug:
    var: ansible_default_ipv4.address
```

### 4. 批量执行优化

- 并行执行：`ansible-playbook -f 10 nginx.yml`（同时执行 10 台服务器）
- 只执行失败的主机：`ansible-playbook nginx.yml --limit @/root/ansible_failed.retry`

------

## 第四阶段：生产实战

### 1. 批量初始化新服务器

写一个 Playbook，完成以下任务：

- 修改主机名
- 关闭防火墙和 SELinux
- 配置 YUM 源
- 安装基础软件（vim、wget、curl、net-tools）
- 创建运维用户并配置 sudo 权限
- 配置 SSH 安全加固（禁用 root 登录、修改默认端口）

### 2. 批量部署应用

写一个 Playbook，部署一个简单的 Web 应用：

- 安装 Nginx
- 安装 PHP
- 安装 MySQL
- 部署应用代码
- 配置 Nginx 反向代理
- 启动所有服务并设置开机自启

### 3. 配置管理

- 统一管理所有服务器的 /etc/hosts 文件
- 统一管理所有服务器的定时任务
- 统一推送配置文件并重启服务

### 4. 最佳实践

- 所有 Playbook 和 Roles 都用 Git 版本控制
- 变量和代码分离，不同环境用不同的变量文件
- 严格遵守幂等性：重复执行 Playbook 不会产生副作用
- 给所有任务和 Playbook 加清晰的注释
- 定期备份 Ansible 配置文件



## 一、标准项目目录结构



```
ansible_production/
├── roles/
│   ├── init_server/       # 1. 服务器初始化角色
│   ├── web_deploy/        # 2. Web应用部署角色
│   └── config_manage/     # 3. 统一配置管理角色
├── inventory/
│   └── hosts              # 主机清单
├── site.yml               # 主入口剧本
└── vars/
    └── global.yml         # 全局变量文件
```

------

## 二、基础配置文件

### 1. 主机清单 `inventory/hosts`



```ini
[web]
192.168.1.100
192.168.1.101

[db]
192.168.1.102

[all:vars]
ansible_ssh_user=root
ansible_ssh_port=22
```

### 2. 全局变量 `vars/global.yml`



```yaml
# 通用配置
env: prod
timezone: Asia/Shanghai

# 初始化服务器
hostname_prefix: web-server
ops_user: opsuser
ssh_port: 2233

# Web应用
nginx_port: 80
php_version: 7.4
mysql_root_password: Root@123456
```

### 3. 主入口剧本 `site.yml`



```yml
- name: 生产环境 - 服务器初始化
  hosts: all
  become: yes
  roles:
    - init_server

- name: 生产环境 - 部署Web应用
  hosts: web
  become: yes
  roles:
    - web_deploy

- name: 生产环境 - 统一配置管理
  hosts: all
  become: yes
  roles:
    - config_manage
```

------

## 三、角色 1：服务器初始化 `roles/init_server`

### 1. 变量 `vars/main.yml`



```yaml
base_packages:
  - vim
  - wget
  - curl
  - net-tools
  - tree
  - lrzsz
```

### 2. 核心任务 `tasks/main.yml`



```yaml
- name: 加载全局变量
  include_vars: ../../vars/global.yml

- name: 修改主机名
  hostname:
    name: "{{ hostname_prefix }}-{{ inventory_hostname_short }}"

- name: 关闭防火墙
  service:
    name: firewalld
    state: stopped
    enabled: no

- name: 临时关闭SELinux
  command: setenforce 0
  ignore_errors: yes

- name: 永久关闭SELinux
  lineinfile:
    path: /etc/selinux/config
    regexp: '^SELINUX='
    line: 'SELINUX=disabled'

- name: 配置阿里云YUM源
  yum_repository:
    name: aliyun
    description: Aliyun YUM Repo
    baseurl: http://mirrors.aliyun.com/centos/$releasever/os/$basearch/
    gpgcheck: no

- name: 安装基础软件
  yum:
    name: "{{ item }}"
    state: present
  loop: "{{ base_packages }}"

- name: 创建运维用户
  user:
    name: "{{ ops_user }}"
    state: present
    shell: /bin/bash

- name: 配置sudo免密
  lineinfile:
    path: /etc/sudoers
    line: '{{ ops_user }} ALL=(ALL) NOPASSWD: ALL'
    validate: 'visudo -cf %s'

- name: SSH加固 - 修改端口
  lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^#Port|^Port'
    line: "Port {{ ssh_port }}"

- name: SSH加固 - 禁止root登录
  lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^PermitRootLogin'
    line: 'PermitRootLogin no'
  notify: 重启SSH服务
```

### 3. 触发器 `handlers/main.yml`



```yaml
- name: 重启SSH服务
  service:
    name: sshd
    state: restarted
```

------

## 四、角色 2：Web 应用部署 `roles/web_deploy`

### 1. 任务 `tasks/main.yml`



```yaml
- name: 加载全局变量
  include_vars: ../../vars/global.yml

# 安装Nginx
- name: 安装Nginx
  yum:
    name: nginx
    state: present

# 安装PHP
- name: 安装PHP
  yum:
    name:
      - php
      - php-fpm
      - php-mysqlnd
    state: present

# 安装MySQL
- name: 安装MySQL
  yum:
    name: mariadb-server
    state: present

# 部署Web代码
- name: 创建站点目录
  file:
    path: /usr/share/nginx/html
    state: directory
    mode: 0755

- name: 部署测试页面
  copy:
    content: "<?php phpinfo(); ?>"
    dest: /usr/share/nginx/html/index.php

# Nginx配置
- name: 配置Nginx代理
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/conf.d/default.conf
  notify: 重启Nginx

# 启动所有服务
- name: 启动Nginx/PHP/MySQL
  service:
    name: "{{ item }}"
    state: started
    enabled: yes
  loop:
    - nginx
    - php-fpm
    - mariadb
```





```
server {
    listen {{ nginx_port }};
    root /usr/share/nginx/html;
    index index.php index.html;

    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

### 3. 触发器 `handlers/main.yml`



```yml
- name: 重启Nginx
  service:
    name: nginx
    state: restarted
```

------

## 五、角色 3：统一配置管理 `roles/config_manage`

### 1. 任务 `tasks/main.yml`

```yml
# 1. 统一管理 /etc/hosts
- name: 配置hosts文件
  lineinfile:
    path: /etc/hosts
    line: "{{ hostvars[item].ansible_host }} {{ item }}"
    state: present
  loop: "{{ groups.all }}"   #内置变量  循环遍历所有机器

# 2. 统一管理定时任务
- name: 创建日志清理定时任务
  cron:
    name: "clean logs"
    minute: "0"
    hour: "3"
    job: "/usr/bin/find /var/log -name '*.log' -mtime +7 -delete"

# 3. 推送统一配置文件
- name: 推送时区配置
  copy:
    content: "Asia/Shanghai"
    dest: /etc/timezone
  notify: 同步时区
```

### 2. 触发器 `handlers/main.yml`

```yml
- name: 同步时区
  command: timedatectl set-timezone Asia/Shanghai
```

------

## 六、执行命令（生产标准）



```bash
# 进入项目目录
cd ansible_production

# 执行全套自动化部署
ansible-playbook -i inventory/hosts site.yml
```

------

## 七、生产最佳实践（企业标准）

### 1. 代码管理

- 所有 Ansible 代码提交到 **Git/GitLab**，禁止本地裸奔
- 分支规范：`dev`(测试) → `test`(预发) → `main`(生产)

### 2. 变量规范

- 公共变量放 `global.yml`
- 角色私有变量放角色内 `vars/main.yml`
- 敏感密码（MySQL、SSH）使用 **ansible-vault 加密**

### 3. 幂等性保障

- 全部使用 Ansible 原生模块，**禁止使用 shell/command**
- 重复执行剧本不会重复修改、不会报错

### 4. 安全规范

- 禁用 root 远程登录，使用普通运维用户
- SSH 修改默认端口，仅允许密钥登录
- 密码统一加密管理，绝不明文写在代码里

### 5. 运维规范

- 所有任务添加清晰 `name` 注释
- 定期备份 Ansible 项目目录
- 生产执行前加 `--check` 干跑测试



# ansible 内置变量

# Ansible 常用内置变量速查表

## 一、主机清单类（最常用 → 批量管理、配置 hosts 必用）



| 变量名                     | 核心作用                | 实战示例                                           |
| :------------------------- | :---------------------- | :------------------------------------------------- |
| `groups`                   | 所有主机分组的字典      | `groups.all`（所有主机）`groups.web`（web 组主机） |
| `hostvars`                 | 所有主机的变量合集      | `hostvars[item].ansible_default_ipv4.address`      |
| `inventory_hostname`       | 当前主机在清单中的名称  | `192.168.1.100` / `web01`                          |
| `inventory_hostname_short` | 主机名 / IP 短格式      | `100`（截取 IP 最后一段）                          |
| `ansible_host`             | 主机连接 IP（清单定义） | `192.168.1.100`                                    |
| `ansible_port`             | 主机 SSH 端口           | `22` / `2233`                                      |
| `ansible_user`             | 主机登录用户            | `root` / `opsuser`                                 |

------

## 二、系统 Facts 类（自动收集 → 系统信息、差异化配置必用）



| 变量名                         | 核心作用        | 实战示例                            |
| :----------------------------- | :-------------- | :---------------------------------- |
| `ansible_os_family`            | 系统家族        | `RedHat`(CentOS) / `Debian`(Ubuntu) |
| `ansible_distribution`         | 系统名称        | `CentOS` / `Ubuntu`                 |
| `ansible_distribution_version` | 系统版本        | `7` / `8` / `20.04`                 |
| `ansible_default_ipv4.address` | 本机默认网卡 IP | `192.168.1.100`                     |
| `ansible_memtotal_mb`          | 总内存大小      | `1823`（MB）                        |
| `ansible_processor_vcpus`      | CPU 核心数      | `2` / `4`                           |
| `ansible_hostname`             | 系统主机名      | `localhost.localdomain`             |

------

## 三、任务 / 执行类（Playbook 开发 → 循环、角色、调试必用）



| 变量名               | 核心作用             | 实战示例                         |
| :------------------- | :------------------- | :------------------------------- |
| `item`               | 循环内置变量         | `loop` 遍历列表时自动赋值        |
| `play_hosts`         | 当前 Play 生效的主机 | `[192.168.1.100, 192.168.1.101]` |
| `role_path`          | 当前角色路径         | `/opt/ansible/roles/nginx`       |
| `ansible_play_hosts` | 当前执行的所有主机   | 同 play_hosts                    |
| `ansible_date_time`  | 系统当前时间         | 日志、备份文件名生成             |

------

# 两个关键命令（自己查看所有内置变量）

## 1. 查看主机清单内置变量



```
ansible web -m debug -a "var=groups"
```

## 2. 查看系统 Facts 所有变量（最全）



```
ansible web -m setup
```

------

## 第五阶段：面试高频考点（直接背）

1. **Ansible 的特点是什么？**

   无客户端、基于 SSH 通信、YAML 配置、幂等性、轻量化、无需数据库。

   

2. **什么是幂等性？为什么重要？**

   重复执行同一个操作，结果都是一样的。保证环境一致性，避免人工操作出错。

   

3. **Ad-hoc 和 Playbook 的区别？**

   Ad-hoc 是临时单行命令，适合简单一次性操作；Playbook 是 YAML 脚本，适合复杂可重复的任务。

   

4. **Roles 的作用是什么？**

   把 Playbook 按功能模块化，提高代码复用性和可维护性。

   

5. **Ansible 的工作原理是什么？**

   控制节点通过 SSH 免密登录被控节点，把模块和参数推送到被控节点执行，执行完后删除临时文件。

   

6. **command 和 shell 模块的区别？**

   command 不支持管道、重定向等 shell 特性；shell 支持，功能更强大，但有安全风险。