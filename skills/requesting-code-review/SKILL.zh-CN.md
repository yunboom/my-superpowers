---
name: 请求代码审查
description: 在完成任务、实现主要功能或合并前使用，以验证工作是否满足需求
---

# 请求代码审查

派遣 superpowers:code-reviewer 子代理在问题级联之前捕获它们。审查者会获得精心构建的评估上下文——而非你的会话历史。这让审查者专注于工作成果而非你的思考过程，同时也为你保留自己的上下文以便继续工作。

**核心原则：** 早审查，勤审查。

## 何时请求审查

**必须：**
- 在 subagent-driven development 中每个任务完成后
- 完成主要功能后
- 合并到 main 之前

**可选但有价值：**
- 卡住时（获取新视角）
- 重构前（基线检查）
- 修复复杂 bug 后

## 如何请求

**1. 获取 git SHA：**
```bash
BASE_SHA=$(git rev-parse HEAD~1)  # or origin/main
HEAD_SHA=$(git rev-parse HEAD)
```

**2. 派遣 code-reviewer sub-agent：**

使用 Task 工具，类型为 superpowers:code-reviewer，填写 `code-reviewer.md` 中的模板

**占位符：**
- `{WHAT_WAS_IMPLEMENTED}` - 你刚刚构建了什么
- `{PLAN_OR_REQUIREMENTS}` - 它应该做什么
- `{BASE_SHA}` - 起始提交
- `{HEAD_SHA}` - 结束提交
- `{DESCRIPTION}` - 简要摘要

**3. 处理反馈：**
- 立即修复 Critical 问题
- 继续之前修复 Important 问题
- 记录 Minor 问题留待后续处理
- 如果审查者有误，进行反驳（附带理由）

## 示例

```
[刚完成任务 2：添加验证函数]

你：让我在继续之前请求代码审查。

BASE_SHA=$(git log --oneline | grep "Task 1" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

[派遣 superpowers:code-reviewer sub-agent]
  WHAT_WAS_IMPLEMENTED: Verification and repair functions for conversation index
  PLAN_OR_REQUIREMENTS: Task 2 from docs/superpowers/plans/deployment-plan.md
  BASE_SHA: a7981ec
  HEAD_SHA: 3df7661
  DESCRIPTION: Added verifyIndex() and repairIndex() with 4 issue types

[Sub-agent 返回]：
  优点：架构清晰，测试真实
  问题：
    Important：缺少进度指示器
    Minor：魔法数字（100）用于报告间隔
  评估：可以继续

你：[修复进度指示器]
[继续任务 3]
```

## 与工作流的集成

**Subagent-Driven Development：**
- 每个任务后审查
- 在问题复合之前捕获
- 移到下一个任务之前修复

**执行计划：**
- 每批（3 个任务）后审查
- 获取反馈，应用，继续

**临时开发：**
- 合并前审查
- 卡住时审查

## 红色警告

**绝不：**
- 因为"很简单"就跳过审查
- 忽略 Critical 问题
- 在未修复 Important 问题的情况下继续
- 与合理的技术反馈争辩

**如果审查者有误：**
- 用技术理由进行反驳
- 展示证明其有效的代码/测试
- 请求澄清

参见模板：requesting-code-review/code-reviewer.md
