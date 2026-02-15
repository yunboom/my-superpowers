---
name: using-xspec
description: Use when starting any conversation in a project that follows the xSpec product-engineering workflow - establishes how to use the PRD-driven workflow and its skills
---

<EXTREMELY-IMPORTANT>
如果你正在处理一个有 PRD 的需求，或者工作目录在 `docs/specs/` 下，你必须遵循 xSpec 工作流。

这不可商量。这不是可选的。你不能为跳过找借口。
</EXTREMELY-IMPORTANT>

# 使用 xSpec

## 什么是 xSpec

xSpec 是一套 PRD 驱动的产研工作流，扩展了 superpowers。它以 PRD 为输入，经过需求澄清、设计、计划生成和执行。

## 两条并行工作流

```
工作流 A（自由想法）:
  /brainstorm → /write-plan → /execute-plan

工作流 B（PRD 驱动 / xSpec）:
  /prd-clarify → /generate-hld(可选) → /generate-design → /write-plan → /execute-plan
```

**何时使用 xSpec（工作流 B）：** 用户有 PRD、需求 ID 或引用了飞书链接。

**何时使用工作流 A：** 用户有自由想法，没有正式 PRD。

## xSpec 命令

| 命令 | 用途 | 使用时机 |
|------|------|---------|
| `/prd-clarify` | 澄清 PRD 需求（仅业务层面） | 从 PRD 开始新需求时 |
| `/generate-hld` | 多服务需求的高层设计 | 涉及多个微服务的复杂需求 |
| `/generate-design` | 含深度调研的详细技术设计 | 在实现之前、需求明确之后 |
| `/write-plan` | 生成实施计划 + testing.md | 设计完成后 |
| `/execute-plan` | 带安全检查的计划执行 | 计划就绪后 |

## Specs 目录

所有产出物存储在 `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/` 下：

| 文件 | 产出方 |
|------|--------|
| `requirements.md` | `/prd-clarify` |
| `hld.md` | `/generate-hld`（可选） |
| `design.md` | `/generate-design` |
| `plan.md` | `/write-plan` |
| `testing.md` | `/write-plan`（与 plan.md 同步） |

## 规范

- **Commit 信息：** 前缀 `REQ-{id}`
- **代码注释：** 所有注释携带 `// REQ-{id} {说明}`
- **需求 ID：** 从 `https://project.feishu.cn/.*/detail/(\d+)` 提取，或询问用户

## 关键规则

1. **prd-clarify 只做业务层面** —— 不问技术问题。技术关注点属于 /generate-design。
2. **先调研再头脑风暴** —— 在 /generate-design 中，调研在前，带证据的头脑风暴在后。
3. **testing.md 不可修改** —— 一旦生成，执行过程中绝不修改。发现问题向用户反馈。
4. **测试前安全检查** —— 运行测试前验证所有外部依赖连接为 localhost。
5. **计划以集成测试收尾** —— 每个计划的最后一个任务必须运行 testing.md 所有用例。

## xSpec 的 Skill 优先级

当用户消息涉及 PRD 或需求时：

1. **检查是否需要 `/prd-clarify`** —— 新 PRD 尚未澄清
2. **检查是否需要 `/generate-hld`** —— 复杂多服务需求
3. **检查是否需要 `/generate-design`** —— 需求已澄清，尚无设计
4. **检查是否需要 `/write-plan`** —— 设计已完成，尚无计划
5. **检查是否需要 `/execute-plan`** —— 计划就绪，尚未执行

## 危险信号

| 想法 | 现实 |
|------|------|
| "让我直接开始写代码" | 遵循工作流。有 PRD 先 /prd-clarify。 |
| "PRD 已经够清楚了" | 每份 PRD 都藏着业务假设。先澄清。 |
| "我知道最佳技术方案" | 调研最新实践。不要依赖训练数据。 |
| "我之后手动测试" | testing.md 提前生成，自动运行。 |
| "这个测试用例写错了" | 不得修改。停下来向用户反馈。 |
| "外部数据库应该没问题" | 检查 localhost。非本地 = 先问用户。 |
