---
name: generating-hld
description: Use when a complex requirement involves multiple microservices and you need to define service responsibilities, interfaces, events, and dependency relationships from a top-level perspective
---

# 高层设计生成

## 概述

针对复杂的多微服务需求，生成高层设计，定义服务职责、对外能力（接口/事件）以及服务间的依赖关系。

**核心原则：** 系统感知的 HLD —— 通过自动化架构发现了解当前系统，然后在该上下文中设计变更。

**启动时宣告：** "I'm using the generating-hld skill to create the high-level design."

## 流程

### 步骤 1：确认 Specs 路径

扫描 `docs/specs/` 并选取日期最近的 `yyyy-MM-dd-REQ-*/{topic}` 目录作为候选。如果不存在 specs 目录，提示："未找到 specs 目录，请先执行 `/prd-clarify` 创建需求文档。"并停止。

<HARD-GATE>
必须将候选路径展示给用户并等待确认，在用户确认之前不得做任何其他操作。不得加载文件、不得开始架构发现、不得进入步骤 2。

必须说："找到 specs 目录：`{candidate_path}`。这是正确的目标目录吗？(Y/N)"

然后停止并等待用户回复。只有用户确认后才能继续。
</HARD-GATE>

### 步骤 2：加载上下文

用户确认 specs 路径后：
- 如果 `requirements.md` 已在当前对话上下文中（例如，在同一会话中由前序步骤加载过） → 跳过文件读取
- 如果不在上下文中 → 从 `{specs_path}/requirements.md` 读取

### 步骤 2：发现当前架构
- **必需子技能：** 使用 superpowers:system-design
- system-design 技能将探索项目并返回结构化的架构摘要
- 此步骤为自动化执行 —— 无需用户确认

### 步骤 3：生成 HLD
基于需求 + 当前架构：
1. 识别受影响的现有服务
2. 确定是否需要新服务
3. 为每个服务定义职责分配
4. 指定接口和事件契约
5. 映射依赖关系
6. 使用 `hld-template.md` 生成 `hld.md`（内容用中文，技术术语用英文）

### 步骤 4：提交确认
- 向用户展示完整的 HLD
- 一次性确认（非逐节确认）
- 如果用户要求修改，修订后重新展示

### 步骤 5：保存并提示下一步
- 保存到 `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/hld.md`
- 提示："HLD complete. Run `/generate-design` to create detailed design for each involved service."

## 模板

使用本技能目录下的 `hld-template.md` 作为输出结构。

## 集成关系

**必需子技能：** superpowers:system-design（架构发现）
**输入：** 同一规格目录下的 `requirements.md`
**输出：** 同一规格目录下的 `hld.md`
**后续步骤：** superpowers:generating-design
