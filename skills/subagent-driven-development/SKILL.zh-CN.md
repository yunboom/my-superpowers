---
name: subagent-driven-development
description: Use when executing implementation plans with independent tasks in the current session
---

# Sub-agent 驱动开发

通过为每个任务分派新的 sub-agent 来执行计划，每个任务完成后进行两阶段审查：先审查规格合规性，再审查代码质量。

**核心原则：** 每个任务一个新的 sub-agent + 两阶段审查（规格 + 质量）= 高质量、快速迭代

## 何时使用

```dot
digraph when_to_use {
    "Have implementation plan?" [shape=diamond];
    "Tasks mostly independent?" [shape=diamond];
    "Stay in this session?" [shape=diamond];
    "subagent-driven-development" [shape=box];
    "executing-plans" [shape=box];
    "Manual execution or brainstorm first" [shape=box];

    "Have implementation plan?" -> "Tasks mostly independent?" [label="yes"];
    "Have implementation plan?" -> "Manual execution or brainstorm first" [label="no"];
    "Tasks mostly independent?" -> "Stay in this session?" [label="yes"];
    "Tasks mostly independent?" -> "Manual execution or brainstorm first" [label="no - tightly coupled"];
    "Stay in this session?" -> "subagent-driven-development" [label="yes"];
    "Stay in this session?" -> "executing-plans" [label="no - parallel session"];
}
```

**对比 Executing Plans（并行会话）：**
- 同一会话（无上下文切换）
- 每个任务使用新的 sub-agent（无上下文污染）
- 每个任务完成后进行两阶段审查：先规格合规性，再代码质量
- 更快的迭代（任务之间无需人工介入）

## 流程

```dot
digraph process {
    rankdir=TB;

    subgraph cluster_per_task {
        label="Per Task";
        "Dispatch implementer subagent (./implementer-prompt.md)" [shape=box];
        "Implementer subagent asks questions?" [shape=diamond];
        "Answer questions, provide context" [shape=box];
        "Implementer subagent implements, tests, commits, self-reviews" [shape=box];
        "Dispatch spec reviewer subagent (./spec-reviewer-prompt.md)" [shape=box];
        "Spec reviewer subagent confirms code matches spec?" [shape=diamond];
        "Implementer subagent fixes spec gaps" [shape=box];
        "Dispatch code quality reviewer subagent (./code-quality-reviewer-prompt.md)" [shape=box];
        "Code quality reviewer subagent approves?" [shape=diamond];
        "Implementer subagent fixes quality issues" [shape=box];
        "Mark task complete in TodoWrite" [shape=box];
    }

    "Read plan, extract all tasks with full text, note context, create TodoWrite" [shape=box];
    "More tasks remain?" [shape=diamond];
    "Dispatch final code reviewer subagent for entire implementation" [shape=box];
    "Use superpowers:finishing-a-development-branch" [shape=box style=filled fillcolor=lightgreen];

    "Read plan, extract all tasks with full text, note context, create TodoWrite" -> "Dispatch implementer subagent (./implementer-prompt.md)";
    "Dispatch implementer subagent (./implementer-prompt.md)" -> "Implementer subagent asks questions?";
    "Implementer subagent asks questions?" -> "Answer questions, provide context" [label="yes"];
    "Answer questions, provide context" -> "Dispatch implementer subagent (./implementer-prompt.md)";
    "Implementer subagent asks questions?" -> "Implementer subagent implements, tests, commits, self-reviews" [label="no"];
    "Implementer subagent implements, tests, commits, self-reviews" -> "Dispatch spec reviewer subagent (./spec-reviewer-prompt.md)";
    "Dispatch spec reviewer subagent (./spec-reviewer-prompt.md)" -> "Spec reviewer subagent confirms code matches spec?";
    "Spec reviewer subagent confirms code matches spec?" -> "Implementer subagent fixes spec gaps" [label="no"];
    "Implementer subagent fixes spec gaps" -> "Dispatch spec reviewer subagent (./spec-reviewer-prompt.md)" [label="re-review"];
    "Spec reviewer subagent confirms code matches spec?" -> "Dispatch code quality reviewer subagent (./code-quality-reviewer-prompt.md)" [label="yes"];
    "Dispatch code quality reviewer subagent (./code-quality-reviewer-prompt.md)" -> "Code quality reviewer subagent approves?";
    "Code quality reviewer subagent approves?" -> "Implementer subagent fixes quality issues" [label="no"];
    "Implementer subagent fixes quality issues" -> "Dispatch code quality reviewer subagent (./code-quality-reviewer-prompt.md)" [label="re-review"];
    "Code quality reviewer subagent approves?" -> "Mark task complete in TodoWrite" [label="yes"];
    "Mark task complete in TodoWrite" -> "More tasks remain?";
    "More tasks remain?" -> "Dispatch implementer subagent (./implementer-prompt.md)" [label="yes"];
    "More tasks remain?" -> "Dispatch final code reviewer subagent for entire implementation" [label="no"];
    "Dispatch final code reviewer subagent for entire implementation" -> "Use superpowers:finishing-a-development-branch";
}
```

## Prompt 模板

- `./implementer-prompt.md` - 分派实现者 sub-agent
- `./spec-reviewer-prompt.md` - 分派规格合规审查者 sub-agent
- `./code-quality-reviewer-prompt.md` - 分派代码质量审查者 sub-agent

## 示例工作流

```
You: I'm using Subagent-Driven Development to execute this plan.

[Read plan file once: docs/plans/feature-plan.md]
[Extract all 5 tasks with full text and context]
[Create TodoWrite with all tasks]

Task 1: Hook installation script

[Get Task 1 text and context (already extracted)]
[Dispatch implementation subagent with full task text + context]

Implementer: "Before I begin - should the hook be installed at user or system level?"

You: "User level (~/.config/superpowers/hooks/)"

Implementer: "Got it. Implementing now..."
[Later] Implementer:
  - Implemented install-hook command
  - Added tests, 5/5 passing
  - Self-review: Found I missed --force flag, added it
  - Committed

[Dispatch spec compliance reviewer]
Spec reviewer: ✅ Spec compliant - all requirements met, nothing extra

[Get git SHAs, dispatch code quality reviewer]
Code reviewer: Strengths: Good test coverage, clean. Issues: None. Approved.

[Mark Task 1 complete]

Task 2: Recovery modes

[Get Task 2 text and context (already extracted)]
[Dispatch implementation subagent with full task text + context]

Implementer: [No questions, proceeds]
Implementer:
  - Added verify/repair modes
  - 8/8 tests passing
  - Self-review: All good
  - Committed

[Dispatch spec compliance reviewer]
Spec reviewer: ❌ Issues:
  - Missing: Progress reporting (spec says "report every 100 items")
  - Extra: Added --json flag (not requested)

[Implementer fixes issues]
Implementer: Removed --json flag, added progress reporting

[Spec reviewer reviews again]
Spec reviewer: ✅ Spec compliant now

[Dispatch code quality reviewer]
Code reviewer: Strengths: Solid. Issues (Important): Magic number (100)

[Implementer fixes]
Implementer: Extracted PROGRESS_INTERVAL constant

[Code reviewer reviews again]
Code reviewer: ✅ Approved

[Mark Task 2 complete]

...

[After all tasks]
[Dispatch final code-reviewer]
Final reviewer: All requirements met, ready to merge

Done!
```

## 优势

**对比手动执行：**
- Sub-agent 自然遵循 TDD
- 每个任务拥有新鲜的上下文（不会混淆）
- 并行安全（sub-agent 之间互不干扰）
- Sub-agent 可以提问（工作开始前和工作中均可）

**对比 Executing Plans：**
- 同一会话（无需交接）
- 持续推进（无需等待）
- 审查检查点自动执行

**效率提升：**
- 无文件读取开销（控制器提供完整文本）
- 控制器精确策划所需的上下文
- Sub-agent 一开始就获得完整信息
- 问题在工作开始前浮现（而不是工作完成后）

**质量门禁：**
- 自审在交接前发现问题
- 两阶段审查：规格合规性，然后代码质量
- 审查循环确保修复确实有效
- 规格合规性防止过度构建/构建不足
- 代码质量确保实现质量

**成本：**
- 更多 sub-agent 调用（每个任务需要实现者 + 2 个审查者）
- 控制器做更多准备工作（提前提取所有任务）
- 审查循环增加迭代次数
- 但能尽早发现问题（比后期调试更便宜）

## 危险信号

**永远不要：**
- 未经用户明确同意就在 main/master 分支上开始实现
- 跳过审查（规格合规性或代码质量）
- 在存在未修复的问题时继续推进
- 并行分派多个实现 sub-agent（会产生冲突）
- 让 sub-agent 读取计划文件（应提供完整文本）
- 跳过场景设定上下文（sub-agent 需要理解任务在整体中的位置）
- 忽略 sub-agent 的问题（在让他们继续之前先回答）
- 在规格合规性上接受"差不多就行"（规格审查者发现问题 = 未完成）
- 跳过审查循环（审查者发现问题 = 实现者修复 = 再次审查）
- 让实现者的自审替代正式审查（两者都需要）
- **在规格合规性通过 ✅ 之前开始代码质量审查**（顺序错误）
- 在任一审查有未解决问题时进入下一个任务

**如果 sub-agent 提问：**
- 清楚完整地回答
- 如有需要提供额外上下文
- 不要催促他们进入实现

**如果审查者发现问题：**
- 实现者（同一 sub-agent）修复问题
- 审查者再次审查
- 重复直到批准
- 不要跳过重新审查

**如果 sub-agent 未能完成任务：**
- 分派修复 sub-agent 并提供具体指示
- 不要尝试手动修复（上下文污染）

## 集成

**必需的工作流 skill：**
- **superpowers:using-git-worktrees** - 必需：在开始之前设置隔离的工作空间
- **superpowers:writing-plans** - 创建此 skill 执行的计划
- **superpowers:requesting-code-review** - 审查者 sub-agent 的代码审查模板
- **superpowers:finishing-a-development-branch** - 所有任务完成后结束开发

**Sub-agent 应使用：**
- **superpowers:test-driven-development** - Sub-agent 对每个任务遵循 TDD
- **规范 Skills（std）** - 在分派实现者 sub-agent 之前，扫描可用的 skills 列表，查找名称中包含 `std` 的 skill（如 `code-std`、`db-std`、`error-handling-std`）。这些是各类规范/标准 skill，涵盖代码编写规范、数据库规范、错误处理规范等。将相关 std skill 的指令纳入实现者 sub-agent 的 prompt 中，确保实现遵循相应规范。

**替代工作流：**
- **superpowers:executing-plans** - 用于并行会话而非同会话执行
