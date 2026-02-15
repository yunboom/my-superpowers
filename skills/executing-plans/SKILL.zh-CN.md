---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
---

# 执行计划

## 概述

加载计划，批判性审查，分批执行任务，在批次之间汇报以供审查。所有任务完成后验证 testing.md。

**核心原则：** 分批执行并设置检查点供架构师审查，随后进行端到端测试验证。

**开始时宣布：** "I'm using the executing-plans skill to implement this plan."

## REQ 规范

在整个执行过程中，遵守以下规范：
- **提交信息：** 所有提交必须以 `REQ-{id}` 为前缀（从计划头部读取）
- **代码注释：** 所有代码注释必须携带 `// REQ-{id} {description}`
- 从计划头部的 `**REQ:**` 字段提取 `REQ-{id}`

## 流程

### 步骤 1：加载和审查计划
1. 读取计划文件
2. 从计划头部提取 `REQ-{id}`
3. 批判性审查——识别对计划的任何疑问或顾虑
4. 如果有顾虑：在开始之前向你的人类伙伴提出
5. 如果没有顾虑：创建 TodoWrite 并继续

### 步骤 2：安全检查 — 外部依赖

<HARD-GATE>
在运行任何测试（单元测试或集成测试）之前，扫描项目配置文件中的外部依赖连接。此检查必须在继续之前通过。
</HARD-GATE>

1. 扫描配置文件：`application.yml`、`application.properties`、`.env`、`config.*`、`docker-compose.yml`、连接字符串文件
2. 检查所有数据库/中间件连接地址：
   - DB/MySQL/PostgreSQL：host
   - Elasticsearch：host
   - Redis：host
   - MongoDB：host
   - RabbitMQ/Kafka：broker 地址
   - 任何其他数据存储依赖
3. **如果所有连接都指向 localhost/127.0.0.1：** 正常继续
4. **如果检测到任何非 localhost 连接：**

   ⚠️ **立即停止执行。** 提示用户：
   ```
   Detected external dependency connections pointing to non-local environment:
   - {dependency}: {host}:{port}
   - {dependency}: {host}:{port}
   Continuing may cause data modification/deletion in non-local environments.
   Confirm to continue? [Y/N]
   ```
   仅在用户明确确认后才继续。

### 步骤 3：执行批次
**默认：前 3 个任务**

对于每个任务：
1. 标记为 in_progress
2. 严格按照每一步执行（计划包含小粒度步骤）
3. 确保所有提交信息有 `REQ-{id}` 前缀
4. 确保所有代码注释有 `// REQ-{id}` 标注
5. 按规定运行验证
6. 标记为 completed

### 步骤 4：汇报
当批次完成时：
- 展示已实现的内容
- 展示验证输出
- 说："Ready for feedback."

### 步骤 5：继续
根据反馈：
- 如有需要则应用修改
- 执行下一批次
- 重复直到所有任务完成

### 步骤 6：测试验证

<HARD-GATE>
在所有任务完成后，你必须执行 testing.md 验证，然后才能进入步骤 7。不要跳过此步骤。
</HARD-GATE>

1. 从同一 specs 目录读取 `testing.md`
2. 逐一执行端到端测试用例
3. 记录每个用例的结果（PASS / FAIL）
4. **全部 PASS** → 进入步骤 7
5. **任何 FAIL：**
   a. 分析失败原因
   b. 如果是代码问题 → 修复代码，重新运行失败的测试用例
   c. 如果 `testing.md` 用例本身有问题 → **立即停止**，向用户报告：
      ```
      testing.md case #{N} may have an issue:
      - Case: {case title}
      - Expected: {expected}
      - Actual: {actual}
      - Analysis: {why this might be a test case issue}
      Please confirm whether to adjust the test case or fix the code.
      ```

**绝对禁止修改 testing.md。** 如果你认为测试用例有误，你必须停下来向用户报告。永远不要编辑、删除或更改 testing.md 的内容。

### 步骤 7：完成开发

在所有任务完成且 testing.md 验证通过后：
- 宣布："I'm using the finishing-a-development-branch skill to complete this work."
- **必需子技能：** 使用 superpowers:finishing-a-development-branch
- 按照该 skill 验证测试、展示选项、执行选择

## 何时停下来寻求帮助

**在以下情况立即停止执行：**
- 批次执行中遇到阻碍（缺少依赖、测试失败、指令不清楚）
- 计划有严重缺陷导致无法开始
- 你不理解某条指令
- 验证反复失败
- 检测到非 localhost 的外部依赖（见步骤 2）
- testing.md 用例似乎有问题（见步骤 6）

**宁可寻求澄清，也不要猜测。**

## 何时回到之前的步骤

**在以下情况回到审查（步骤 1）：**
- 伙伴根据你的反馈更新了计划
- 基本方案需要重新思考

**不要强行突破阻碍** — 停下来询问。

## 注意事项
- 从计划头部提取 REQ-{id} 并用于所有提交和注释
- 先批判性审查计划
- 在运行任何测试前执行安全检查
- 严格按照计划步骤执行
- 不要跳过验证
- 当计划要求时引用相关 skill
- 批次之间：只汇报并等待
- 遇到阻碍时停下来，不要猜测
- 所有任务完成后执行 testing.md，永远不要修改它
- 未经用户明确同意，不要在 main/master 分支上开始实现

## 集成

**必需的工作流 skill：**
- **superpowers:using-git-worktrees** - 必需：在开始之前设置隔离的工作空间
- **superpowers:writing-plans** - 创建此 skill 执行的计划
- **superpowers:finishing-a-development-branch** - 所有任务完成后结束开发
