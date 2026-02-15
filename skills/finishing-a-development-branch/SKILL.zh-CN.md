---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work - guides completion of development work by presenting structured options for merge, PR, or cleanup
---

# 完成开发分支

## 概述

通过提供清晰的选项和处理所选工作流来指导开发工作的收尾。

**核心原则：** 验证测试 → 展示选项 → 执行选择 → 清理。

**开始时宣布：** "I'm using the finishing-a-development-branch skill to complete this work."

## 流程

### 步骤 1：验证测试

**在展示选项之前，验证测试通过：**

```bash
# 运行项目的测试套件
npm test / cargo test / pytest / go test ./...
```

**如果测试失败：**
```
测试失败（<N> 个失败）。必须在完成前修复：

[显示失败内容]

在测试通过之前不能进行合并/PR。
```

停下来。不要进入步骤 2。

**如果测试通过：** 继续步骤 2。

### 步骤 2：确定基础分支

```bash
# 尝试常见的基础分支
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

或询问："This branch split from main - is that correct?"

### 步骤 3：展示选项

展示恰好这 4 个选项：

```
实现已完成。你想怎么做？

1. 本地合并回 <base-branch>
2. 推送并创建 Pull Request
3. 保持分支现状（我稍后处理）
4. 丢弃这项工作

选哪个？
```

**不要添加解释** - 保持选项简洁。

### 步骤 4：执行选择

#### 选项 1：本地合并

```bash
# 切换到基础分支
git checkout <base-branch>

# 拉取最新
git pull

# 合并功能分支
git merge <feature-branch>

# 在合并结果上验证测试
<test command>

# 如果测试通过
git branch -d <feature-branch>
```

然后：清理 worktree（步骤 5）

#### 选项 2：推送并创建 PR

```bash
# 推送分支
git push -u origin <feature-branch>

# 创建 PR
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets of what changed>

## Test Plan
- [ ] <verification steps>
EOF
)"
```

然后：清理 worktree（步骤 5）

#### 选项 3：保持现状

报告："Keeping branch <name>. Worktree preserved at <path>."

**不要清理 worktree。**

#### 选项 4：丢弃

**先确认：**
```
这将永久删除：
- 分支 <name>
- 所有提交：<commit-list>
- 位于 <path> 的 worktree

输入 'discard' 确认。
```

等待精确确认。

如果已确认：
```bash
git checkout <base-branch>
git branch -D <feature-branch>
```

然后：清理 worktree（步骤 5）

### 步骤 5：清理 Worktree

**对于选项 1、2、4：**

检查是否在 worktree 中：
```bash
git worktree list | grep $(git branch --show-current)
```

如果是：
```bash
git worktree remove <worktree-path>
```

**对于选项 3：** 保留 worktree。

## 快速参考

| 选项 | 合并 | 推送 | 保留 Worktree | 清理分支 |
|------|------|------|--------------|---------|
| 1. 本地合并 | ✓ | - | - | ✓ |
| 2. 创建 PR | - | ✓ | ✓ | - |
| 3. 保持现状 | - | - | ✓ | - |
| 4. 丢弃 | - | - | - | ✓（强制） |

## 常见错误

**跳过测试验证**
- **问题：** 合并损坏的代码，创建失败的 PR
- **修正：** 在提供选项之前始终验证测试

**开放式问题**
- **问题：** "接下来该做什么？" → 含糊不清
- **修正：** 展示恰好 4 个结构化选项

**自动清理 worktree**
- **问题：** 在可能还需要时删除 worktree（选项 2、3）
- **修正：** 仅在选项 1 和 4 时清理

**丢弃无确认**
- **问题：** 意外删除工作成果
- **修正：** 要求输入 "discard" 确认

## 红色警告

**绝不：**
- 在测试失败的情况下继续
- 未验证合并结果的测试就合并
- 未经确认就删除工作成果
- 未经明确请求就 force-push

**始终：**
- 在提供选项之前验证测试
- 展示恰好 4 个选项
- 选项 4 需要输入确认
- 仅在选项 1 和 4 时清理 worktree

## 集成

**被调用方：**
- **subagent-driven-development**（步骤 7）- 所有任务完成后
- **executing-plans**（步骤 5）- 所有批次完成后

**配合使用：**
- **using-git-worktrees** - 清理该技能创建的 worktree
