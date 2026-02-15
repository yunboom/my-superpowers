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

### 步骤 1：确定 Specs 路径并加载上下文
1. 确定 specs 目录路径 `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`：
   - 如果在同一会话中由 `/prd-clarify` 之后调用，路径已知
   - 如果未知，扫描 `docs/specs/` 下已有的 `yyyy-MM-dd-REQ-*` 目录，询问用户确认使用哪个 REQ-id 和 topic
   - 如果不存在 specs 目录，询问用户提供 REQ-id 和 topic 名称
2. **强制要求：** 读取 `{specs_path}/requirements.md`（无例外，不从其他位置读取）

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
