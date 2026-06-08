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

