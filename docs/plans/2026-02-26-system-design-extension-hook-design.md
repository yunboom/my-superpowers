# 设计：system-design skill 新增 extension 钩子

## 概述

为现有 `system-design` skill 预留 `system-design-extension` 钩子机制，允许用户通过添加独立的 `system-design-extension` skill 来控制架构发现的扫描范围和附加上下文。

## 方案

**方案 A（采纳）：步骤 1 前置加载 extension**

在 system-design 执行流程的最早阶段加载 extension，Scope 立即生效约束后续扫描范围。

## 变更内容

### 1. system-design skill 变更

在现有流程的 Step 1 之前新增 **Step 0: Load Extension**：

```
Step 0: Load Extension (新增)
  ↓ 尝试调用 superpowers:system-design-extension
  ↓ 存在 → 解析 Scope 和 Context
  ↓ 不存在 → 跳过，全量扫描
Step 1: Explore Project Structure (受 Scope 约束)
Step 2-4: (不变)
Step 5: Output Architecture Summary (附加 Context 信息)
```

**具体变更点：**

- **Step 0** — 通过 Skill tool 尝试调用 `superpowers:system-design-extension`，成功则解析 `## Scope` 和 `## Context`；失败（skill 不存在）则跳过
- **Step 1** — 如果 Scope 存在，仅扫描列出的服务目录；不存在则保持全量扫描
- **Step 5** — 如果 Context 存在，将额外描述合并到对应服务的架构摘要中

### 2. 新增 system-design-extension skill（示例）

**位置：** `skills/system-design-extension/SKILL.md` + `SKILL.zh-CN.md`

**格式约定：**

- `## Scope`（可选）— 每行一个服务/仓库名，限定扫描范围
- `## Context`（可选）— `- {service-name}: {简短描述}` 格式，附加到架构摘要

两个 section 都是可选的，可单独使用或组合使用。

**示例内容：**

```markdown
## Scope

- trading-service
- merchant-service

## Context

- trading-service: 负责订单交易核心流程，包含支付回调和结算
- merchant-service: 商户管理，提供商户入驻、资质审核能力
```

### 3. 不变更的部分

- `generating-hld` 调用 `system-design` 的方式不变
- Step 2-4 逻辑不变，仅扫描范围受 Scope 限制
- 输出格式不变
- 不新增 command（extension 不是用户直接调用的）
