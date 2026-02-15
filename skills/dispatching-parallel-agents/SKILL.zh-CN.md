---
name: dispatching-parallel-agents
description: Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies
---

# 派遣并行 Agent

## 概述

当你有多个不相关的失败（不同的测试文件、不同的子系统、不同的 bug）时，按顺序调查会浪费时间。每个调查都是独立的，可以并行进行。

**核心原则：** 每个独立问题域派遣一个 agent。让它们并发工作。

## 何时使用

```dot
digraph when_to_use {
    "Multiple failures?" [shape=diamond];
    "Are they independent?" [shape=diamond];
    "Single agent investigates all" [shape=box];
    "One agent per problem domain" [shape=box];
    "Can they work in parallel?" [shape=diamond];
    "Sequential agents" [shape=box];
    "Parallel dispatch" [shape=box];

    "Multiple failures?" -> "Are they independent?" [label="yes"];
    "Are they independent?" -> "Single agent investigates all" [label="no - related"];
    "Are they independent?" -> "Can they work in parallel?" [label="yes"];
    "Can they work in parallel?" -> "Parallel dispatch" [label="yes"];
    "Can they work in parallel?" -> "Sequential agents" [label="no - shared state"];
}
```

**使用场景：**
- 3 个以上测试文件因不同根因失败
- 多个子系统独立出现故障
- 每个问题无需其他问题的上下文即可理解
- 调查之间没有共享状态

**不要使用场景：**
- 失败之间有关联（修复一个可能修复其他的）
- 需要理解完整的系统状态
- Agent 之间会相互干扰

## 模式

### 1. 识别独立域

按故障点对失败进行分组：
- 文件 A 测试：工具审批流程
- 文件 B 测试：批量完成行为
- 文件 C 测试：中止功能

每个域是独立的 - 修复工具审批不会影响中止测试。

### 2. 创建聚焦的 Agent 任务

每个 agent 获得：
- **具体范围：** 一个测试文件或子系统
- **明确目标：** 让这些测试通过
- **约束：** 不要修改其他代码
- **期望输出：** 发现和修复内容的摘要

### 3. 并行派遣

```typescript
// In Claude Code / AI environment
Task("Fix agent-tool-abort.test.ts failures")
Task("Fix batch-completion-behavior.test.ts failures")
Task("Fix tool-approval-race-conditions.test.ts failures")
// All three run concurrently
```

### 4. 审查与整合

当 agent 返回时：
- 阅读每个摘要
- 验证修复之间不冲突
- 运行完整测试套件
- 整合所有变更

## Agent 提示结构

好的 agent 提示应该是：
1. **聚焦的** - 一个明确的问题域
2. **自包含的** - 包含理解问题所需的所有上下文
3. **输出明确的** - agent 应该返回什么？

```markdown
Fix the 3 failing tests in src/agents/agent-tool-abort.test.ts:

1. "should abort tool with partial output capture" - expects 'interrupted at' in message
2. "should handle mixed completed and aborted tools" - fast tool aborted instead of completed
3. "should properly track pendingToolCount" - expects 3 results but gets 0

These are timing/race condition issues. Your task:

1. Read the test file and understand what each test verifies
2. Identify root cause - timing issues or actual bugs?
3. Fix by:
   - Replacing arbitrary timeouts with event-based waiting
   - Fixing bugs in abort implementation if found
   - Adjusting test expectations if testing changed behavior

Do NOT just increase timeouts - find the real issue.

Return: Summary of what you found and what you fixed.
```

## 常见错误

**❌ 范围太广：** "Fix all the tests" - agent 会迷失
**✅ 具体：** "Fix agent-tool-abort.test.ts" - 聚焦范围

**❌ 没有上下文：** "Fix the race condition" - agent 不知道在哪里
**✅ 有上下文：** 粘贴错误信息和测试名称

**❌ 没有约束：** Agent 可能会重构所有代码
**✅ 有约束：** "Do NOT change production code" 或 "Fix tests only"

**❌ 输出模糊：** "Fix it" - 你不知道改了什么
**✅ 输出明确：** "Return summary of root cause and changes"

## 何时不要使用

**关联性失败：** 修复一个可能修复其他的 - 先一起调查
**需要完整上下文：** 理解问题需要看到整个系统
**探索性调试：** 你还不知道什么出了问题
**共享状态：** Agent 会相互干扰（编辑相同文件、使用相同资源）

## 真实会话示例

**场景：** 大型重构后 3 个文件中有 6 个测试失败

**失败情况：**
- agent-tool-abort.test.ts：3 个失败（时序问题）
- batch-completion-behavior.test.ts：2 个失败（工具未执行）
- tool-approval-race-conditions.test.ts：1 个失败（执行计数 = 0）

**决策：** 独立域 - 中止逻辑与批量完成与竞态条件分别独立

**派遣：**
```
Agent 1 → Fix agent-tool-abort.test.ts
Agent 2 → Fix batch-completion-behavior.test.ts
Agent 3 → Fix tool-approval-race-conditions.test.ts
```

**结果：**
- Agent 1：用基于事件的等待替换了超时
- Agent 2：修复了事件结构 bug（threadId 位置错误）
- Agent 3：添加了对异步工具执行完成的等待

**整合：** 所有修复互相独立，无冲突，完整套件全绿

**节省时间：** 3 个问题并行解决 vs 顺序解决

## 关键收益

1. **并行化** - 多个调查同时进行
2. **聚焦** - 每个 agent 范围窄，需要跟踪的上下文少
3. **独立性** - Agent 之间不相互干扰
4. **速度** - 用 1 个问题的时间解决 3 个问题

## 验证

Agent 返回后：
1. **审查每个摘要** - 理解变更内容
2. **检查冲突** - Agent 是否编辑了相同代码？
3. **运行完整套件** - 验证所有修复协同工作
4. **抽查检查** - Agent 可能犯系统性错误

## 实际影响

来自调试会话（2025-10-03）：
- 3 个文件中 6 个失败
- 并行派遣 3 个 agent
- 所有调查并发完成
- 所有修复成功整合
- Agent 变更之间零冲突
