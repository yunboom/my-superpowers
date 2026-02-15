---
name: prd-clarifying
description: Use when receiving a PRD (Product Requirements Document) to conduct requirements-level brainstorming, uncover issues, and produce a structured requirements.md
---

# PRD 需求澄清

## 概述

产品-工程工作流的入口。接收 PRD 输入，进行需求层面的头脑风暴以深入发现 PRD 中的问题，逐一与用户澄清，最终产出结构化的 `requirements.md`。

**核心原则：** 需求层面的头脑风暴 —— 在任何设计工作开始之前，系统地探查 PRD 的每一个维度。

**启动时宣告：** "I'm using the prd-clarifying skill to analyze and clarify this PRD."

**前置要求：** 在使用本技能之前，你必须理解 superpowers:brainstorming。该技能定义了本技能复用的对话模式（每次一个问题、优先多选题、渐进式验证）。

<HARD-GATE>
在所有需求澄清完成且用户确认最终 requirements.md 之前，不得进入任何设计技能、编写任何设计文档或执行任何实现操作。无论 PRD 看起来多么完整，此规则一律适用。
</HARD-GATE>

## 检查清单

你必须为以下每个条目创建任务，并按顺序完成：

1. **接收 PRD** —— 粘贴内容或读取文件路径
2. **提取需求 ID** —— 匹配飞书链接或询问用户
3. **确定主题** —— 简短的英文名称
4. **创建规格目录** —— `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`
5. **需求头脑风暴** —— 按检查清单逐一提问
6. **生成 requirements.md** —— 结构化输出
8. **提示下一步** —— /generate-hld 或 /generate-design

## PRD 输入

用户可以通过两种方式提供 PRD：
- **粘贴内容：** 直接在聊天消息中粘贴 PRD 文本
- **文件路径：** 提供本地文件路径（例如 `./docs/prd/feature-x.md`）

自动检测：如果输入看起来像文件路径（包含 `/` 或 `\` 且以文档扩展名结尾），则读取文件；否则视为粘贴内容。

## 需求 ID 提取

1. 扫描 PRD 内容，匹配模式：`https://project.feishu.cn/.*/detail/(\d+)`
2. 提取尾部数字作为需求 ID
3. 如果未匹配到，询问用户："I couldn't find a requirement ID in the PRD. Please provide one (e.g., 12345)."

## 需求头脑风暴检查清单

使用头脑风暴对话模式：**每次一个问题，优先多选题，等待回答后再提下一个问题。**

| 维度 | 需要探查的内容 |
|------|---------------|
| **功能边界** | 范围是否清晰？哪些内容明确不在范围内？ |
| **异常流程** | 失败、超时、并发冲突如何处理？ |
| **数据边界** | 数据量、历史迁移、生命周期、保留策略？ |
| **权限与安全** | 谁可以操作？基于角色的访问控制？审计追踪？ |
| **兼容性** | 对现有功能的影响？向后兼容？灰度发布？ |
| **隐含假设** | 实现中需要解决的未明确假设？ |
| **验收标准** | 如何判定需求已完成？ |

对于每个维度：
1. 分析 PRD 中已有的覆盖情况
2. 如果已充分覆盖，跳过（不提不必要的问题）
3. 如果存在缺口，拟定具体问题
4. 尽可能以多选题形式呈现

## 输出：requirements.md

使用本技能目录下的 `requirements-template.md` 作为输出结构。内容用中文输出，技术术语用英文。

写入 `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/requirements.md`。

## 确认后

提示用户下一步操作：
- **复杂的多服务需求：** "This requirement involves multiple services. Recommend running `/generate-hld` next for high-level design."
- **单服务需求：** "This requirement targets a single service. Recommend running `/generate-design` next for detailed design."

## 集成关系

**前置要求：** superpowers:brainstorming（对话模式）
**后续步骤：** superpowers:generating-hld 或 superpowers:generating-design
