---
name: using-git-worktrees
description: Use when starting feature work that needs isolation from current workspace or before executing implementation plans - creates isolated git worktrees with smart directory selection and safety verification
---

# 使用 Git Worktree

## 概述

Git worktree 创建共享同一仓库的隔离工作区，允许同时在多个分支上工作而无需切换。

**核心原则：** 系统化的目录选择 + 安全验证 = 可靠的隔离。

**开始时宣布：** "I'm using the using-git-worktrees skill to set up an isolated workspace."

## 目录选择流程

按此优先级顺序执行：

### 1. 检查现有目录

```bash
# 按优先级检查
ls -d .worktrees 2>/dev/null     # 首选（隐藏目录）
ls -d worktrees 2>/dev/null      # 备选
```

**如果找到：** 使用该目录。如果两者都存在，`.worktrees` 优先。

### 2. 检查 CLAUDE.md

```bash
grep -i "worktree.*director" CLAUDE.md 2>/dev/null
```

**如果指定了偏好：** 无需询问直接使用。

### 3. 询问用户

如果没有现有目录且 CLAUDE.md 中无偏好：

```
未找到 worktree 目录。应该在哪里创建 worktree？

1. .worktrees/（项目本地，隐藏目录）
2. ~/.config/superpowers/worktrees/<project-name>/（全局位置）

你偏好哪个？
```

## 安全验证

### 对于项目本地目录（.worktrees 或 worktrees）

**必须在创建 worktree 之前验证目录已被忽略：**

```bash
# 检查目录是否被忽略（遵循 local、global 和 system gitignore）
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
```

**如果未被忽略：**

按照 Jesse 的规则"立即修复损坏的东西"：
1. 在 .gitignore 中添加相应行
2. 提交变更
3. 继续创建 worktree

**为什么至关重要：** 防止意外将 worktree 内容提交到仓库。

### 对于全局目录（~/.config/superpowers/worktrees）

无需 .gitignore 验证 - 完全在项目之外。

## 创建步骤

### 1. 检测项目名称

```bash
project=$(basename "$(git rev-parse --show-toplevel)")
```

### 2. 创建 Worktree

```bash
# 确定完整路径
case $LOCATION in
  .worktrees|worktrees)
    path="$LOCATION/$BRANCH_NAME"
    ;;
  ~/.config/superpowers/worktrees/*)
    path="~/.config/superpowers/worktrees/$project/$BRANCH_NAME"
    ;;
esac

# 创建带有新分支的 worktree
git worktree add "$path" -b "$BRANCH_NAME"
cd "$path"
```

### 3. 运行项目设置

自动检测并运行适当的设置：

```bash
# Node.js
if [ -f package.json ]; then npm install; fi

# Rust
if [ -f Cargo.toml ]; then cargo build; fi

# Python
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi

# Go
if [ -f go.mod ]; then go mod download; fi
```

### 4. 验证干净的基线

运行测试确保 worktree 从干净状态开始：

```bash
# 示例 - 使用项目对应的命令
npm test
cargo test
pytest
go test ./...
```

**如果测试失败：** 报告失败，询问是否继续还是排查。

**如果测试通过：** 报告就绪。

### 5. 报告位置

```
Worktree 已就绪，位于 <full-path>
测试通过（<N> 个测试，0 个失败）
准备实现 <feature-name>
```

## 快速参考

| 场景 | 操作 |
|------|------|
| `.worktrees/` 存在 | 使用它（验证已忽略） |
| `worktrees/` 存在 | 使用它（验证已忽略） |
| 两者都存在 | 使用 `.worktrees/` |
| 都不存在 | 检查 CLAUDE.md → 询问用户 |
| 目录未被忽略 | 添加到 .gitignore + 提交 |
| 基线测试失败 | 报告失败 + 询问 |
| 没有 package.json/Cargo.toml | 跳过依赖安装 |

## 常见错误

### 跳过忽略验证

- **问题：** Worktree 内容被跟踪，污染 git status
- **修正：** 创建项目本地 worktree 前始终使用 `git check-ignore`

### 假设目录位置

- **问题：** 造成不一致，违反项目约定
- **修正：** 遵循优先级：现有 > CLAUDE.md > 询问

### 在测试失败时继续

- **问题：** 无法区分新 bug 和已有问题
- **修正：** 报告失败，获得明确许可后再继续

### 硬编码设置命令

- **问题：** 在使用不同工具的项目上会失败
- **修正：** 从项目文件（package.json 等）自动检测

## 示例工作流

```
你：I'm using the using-git-worktrees skill to set up an isolated workspace.

[检查 .worktrees/ - 存在]
[验证已忽略 - git check-ignore 确认 .worktrees/ 已被忽略]
[创建 worktree：git worktree add .worktrees/auth -b feature/auth]
[运行 npm install]
[运行 npm test - 47 个通过]

Worktree 已就绪，位于 /Users/jesse/myproject/.worktrees/auth
测试通过（47 个测试，0 个失败）
准备实现 auth 功能
```

## 红色警告

**绝不：**
- 创建 worktree 而不验证其已被忽略（项目本地）
- 跳过基线测试验证
- 在测试失败时未经询问就继续
- 在不明确时假设目录位置
- 跳过 CLAUDE.md 检查

**始终：**
- 遵循目录优先级：现有 > CLAUDE.md > 询问
- 验证项目本地目录已被忽略
- 自动检测并运行项目设置
- 验证干净的测试基线

## 集成

**被调用方：**
- **brainstorming**（阶段 4）- 设计批准且后续要实现时必须使用
- **subagent-driven-development** - 执行任何任务之前必须使用
- **executing-plans** - 执行任何任务之前必须使用
- 任何需要隔离工作区的技能

**配合使用：**
- **finishing-a-development-branch** - 工作完成后必须用于清理
