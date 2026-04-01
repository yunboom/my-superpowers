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

### 步骤 1：确定 Specs 路径

确定目标 specs 目录 `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`：

1. **如果当前对话中已明确知道路径**（例如，同一会话中前序的 `/prd-clarify` 步骤使用或创建了特定的 specs 目录） → 直接使用，无需确认。
2. **如果路径未知**，扫描 `docs/specs/` 下所有 `yyyy-MM-dd-REQ-*/{topic}` 目录：
   - 如果不存在 → 提示："未找到 specs 目录，请先执行 `/prd-clarify` 创建需求文档。"并停止。
   - 如果只有一个 → 直接使用，无需确认。
   - 如果有多个 → 以编号列表形式展示所有目录，等待用户选择后才能继续。

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

### 步骤 5：保存
- 保存到 `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/hld.md`

### 步骤 6：HLD Self-Review

保存 `hld.md` 后，以全新的视角审视它。这是你自己运行的检查清单——不是分派子代理。

**1. 系统边界：** 系统边界是否清晰定义？范围内和范围外的 service 是否明确？

**2. Service 职责：** 每个 service 职责是否单一明确？是否有职责重叠或遗漏？

**3. 接口契约：** 同步接口和异步事件是否完整定义？Provider/Consumer 关系是否清晰？

**4. 依赖方向：** 依赖方向是否合理？是否存在循环依赖？

**5. 数据归属：** 数据实体归属是否明确？是否存在多 service 共写同一数据的情况？

**6. 风险识别：** 风险与待定事项是否充分识别？缓解策略是否可行？

**7. 完整性：** 是否存在 TODO、占位符、"TBD" 或未完成的章节？修复它们。

**8. 一致性：** 各章节之间是否存在矛盾——例如依赖图与接口表不一致？

如果发现问题，直接内联修复。无需重新审查——修复后继续。

### 步骤 7：User Review Gate

self-review 通过后，提示用户对 `hld.md` 进行最终人工 review。

1. 展示："HLD 已通过 self-review，请 review `hld.md` 并确认。"
2. **等待用户明确确认**后才能继续。
3. 如果用户要求修改，执行修改后重新保存，并重新运行 self-review。
4. 用户确认后，提示："HLD confirmed. Run `/generate-design` to create detailed design for each involved service."

## 模板

使用本技能目录下的 `hld-template.md` 作为输出结构。

## 集成关系

**必需子技能：**
- superpowers:system-design（架构发现）

**输入：** 同一规格目录下的 `requirements.md`
**输出：** 同一规格目录下的 `hld.md`
**后续步骤：** superpowers:generating-design
