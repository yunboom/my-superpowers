# System Design Extension Hook Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 为 system-design skill 新增 extension 钩子，支持通过独立 skill 控制扫描范围和附加上下文。

**Architecture:** 在 system-design 流程最前面新增 Step 0 尝试加载 extension skill，成功则解析 Scope/Context 约束后续行为；新增示例 system-design-extension skill。

**Tech Stack:** Markdown skill files

---

### Task 1: 修改 system-design/SKILL.md — 新增 extension 钩子

**Files:**
- Modify: `skills/system-design/SKILL.md`

**Step 1: 在 "## The Process" 下、"### Step 1" 前插入 Step 0**

在 `### Step 1: Explore Project Structure` 之前插入以下内容：

```markdown
### Step 0: Load Extension (Optional)
Attempt to invoke the `superpowers:system-design-extension` skill using the Skill tool:
- **If the skill exists:** Parse its content for two optional sections:
  - `## Scope` — A list of service/repository names. If present, **only scan these directories** in subsequent steps.
  - `## Context` — A list of `- {service-name}: {description}` entries. If present, **append these descriptions** to the corresponding services in the architecture summary output.
- **If the skill does not exist:** Skip this step and proceed with full workspace scanning (default behavior).
```

**Step 2: 修改 Step 1 描述，增加 Scope 约束说明**

在 `### Step 1: Explore Project Structure` 的描述 `Scan the workspace for architecture indicators:` 后追加一行：

```markdown
If a Scope was loaded in Step 0, only scan the listed service directories. Otherwise, scan the entire workspace.
```

**Step 3: 修改 Step 5 描述，增加 Context 合并说明**

在 `### Step 5: Output Architecture Summary` 的 `Output structured text in the following format:` 之前追加：

```markdown
If Context entries were loaded in Step 0, merge them into the corresponding service descriptions in the Services section below.
```

**Step 4: 在 Integration section 中新增 extension 说明**

在 `## Integration` section 末尾追加：

```markdown
**OPTIONAL EXTENSION:** superpowers:system-design-extension (scope constraints and additional context)
```

**Step 5: Commit**

```bash
git add skills/system-design/SKILL.md
git commit -m "feat(system-design): add extension hook for scope and context control"
```

---

### Task 2: 修改 system-design/SKILL.zh-CN.md — 同步中文版

**Files:**
- Modify: `skills/system-design/SKILL.zh-CN.md`

**Step 1: 在 "## 流程" 下、"### 步骤 1" 前插入步骤 0**

在 `### 步骤 1：探索项目结构` 之前插入以下内容：

```markdown
### 步骤 0：加载扩展（可选）
通过 Skill tool 尝试调用 `superpowers:system-design-extension`：
- **如果该 skill 存在：** 解析其内容中的两个可选部分：
  - `## Scope` — 服务/仓库名列表。如果存在，后续步骤**仅扫描这些目录**。
  - `## Context` — `- {service-name}: {描述}` 格式列表。如果存在，将描述**附加到架构摘要中对应服务的描述**。
- **如果该 skill 不存在：** 跳过此步骤，继续全量扫描工作区（默认行为）。
```

**Step 2: 修改步骤 1 描述，增加 Scope 约束说明**

在 `### 步骤 1：探索项目结构` 的描述 `扫描工作区中的架构指标：` 后追加一行：

```markdown
如果步骤 0 加载了 Scope，仅扫描列出的服务目录。否则扫描整个工作区。
```

**Step 3: 修改步骤 5 描述，增加 Context 合并说明**

在 `### 步骤 5：输出架构摘要` 的 `以以下格式输出结构化文本：` 之前追加：

```markdown
如果步骤 0 加载了 Context 条目，将其合并到下方 Services 部分中对应服务的描述。
```

**Step 4: 在集成关系 section 中新增 extension 说明**

在 `## 集成关系` section 末尾追加：

```markdown
**可选扩展：** superpowers:system-design-extension（范围约束和额外上下文）
```

**Step 5: Commit**

```bash
git add skills/system-design/SKILL.zh-CN.md
git commit -m "feat(system-design): add extension hook (zh-CN)"
```

---

### Task 3: 创建 system-design-extension 示例 skill

**Files:**
- Create: `skills/system-design-extension/SKILL.md`
- Create: `skills/system-design-extension/SKILL.zh-CN.md`

**Step 1: 创建 SKILL.md**

```markdown
---
name: system-design-extension
description: Extension hook for system-design skill — defines scope constraints and additional context for microservice architecture discovery
---

# System Design Extension

Customize the behavior of the `superpowers:system-design` skill by defining scope constraints and additional context.

## Scope

- trading-service
- merchant-service

## Context

- trading-service: Responsible for order transaction core flow, including payment callbacks and settlement
- merchant-service: Merchant management, providing merchant onboarding and qualification review capabilities
```

**Step 2: 创建 SKILL.zh-CN.md**

```markdown
---
name: system-design-extension
description: system-design skill 的扩展钩子 — 定义微服务架构发现的范围约束和额外上下文
---

# 系统设计扩展

通过定义范围约束和额外上下文，自定义 `superpowers:system-design` skill 的行为。

## Scope

- trading-service
- merchant-service

## Context

- trading-service: 负责订单交易核心流程，包含支付回调和结算
- merchant-service: 商户管理，提供商户入驻、资质审核能力
```

**Step 3: Commit**

```bash
git add skills/system-design-extension/
git commit -m "feat: add system-design-extension example skill"
```

---

### Task 4: 更新变更 SOP

**Files:**
- Modify: `docs/sop/变更sop.md`

**Step 1: 在变更历史末尾追加记录**

```markdown
- 2026-02-26: system-design 新增 extension 钩子 + 示例 system-design-extension skill
```

**Step 2: Commit**

```bash
git add docs/sop/变更sop.md
git commit -m "docs(sop): record system-design extension hook change"
```
