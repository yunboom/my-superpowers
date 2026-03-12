---
name: prd-clarifying
description: Use when receiving a PRD (Product Requirements Document) to conduct requirements-level brainstorming, uncover issues, and produce a structured requirements.md
---

# PRD 需求澄清

## 概述

产品-工程工作流的入口。接收 PRD 输入，进行需求层面的头脑风暴以深入发现 PRD 中的问题，逐一与用户澄清，最终产出结构化的 `requirements.md`。

**核心原则：** 业务层面的头脑风暴 —— 只关注业务需求、用户场景和产品逻辑。所有技术层面的关注点（架构、存储、协议、错误处理策略、性能优化）属于 `/generate-design` 阶段。

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
7. **Requirements Review Loop** —— dispatch reviewer subagent 审查 requirements.md，最多修复 5 轮
8. **User Review Gate** —— 将 requirements.md 提交用户确认
9. **提示下一步** —— /generate-hld 或 /generate-design

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

<HARD-GATE>
本阶段严格限定在业务层面。不得询问以下内容：
- 实现方案（如"应该用 ES 还是 DB？"、"同步还是异步？"）
- 错误处理策略（如"服务调用失败怎么办？"）
- 性能/容量设计（如"需要多少 QPS？"）
- 数据存储选型（如"MySQL 还是 MongoDB？"）
- 跨服务调用模式（如"按 ID 列表查询还是 join？"）
- 任何产品经理无法回答的问题

如果发现自己在问技术问题，立即停止 —— 推迟到 `/generate-design` 阶段。
</HARD-GATE>

| 维度 | 需要探查的内容 |
|------|---------------|
| **功能边界** | 哪些功能在范围内？哪些明确不在范围内？ |
| **用户场景** | 目标用户是谁？关键用户旅程是什么？ |
| **业务规则** | 哪些业务逻辑约束此功能？业务流程中的边界情况？ |
| **业务异常流程** | 从用户视角看，出错时会发生什么？（不是技术故障处理） |
| **权限与角色** | 哪些用户角色可以访问此功能？有何限制？ |
| **数据范围** | 涉及哪些业务数据？是否有历史数据需要考虑？ |
| **兼容性** | 对现有用户可见功能的影响？现有用户的迁移？ |
| **隐含假设** | PRD 中未明确的业务假设？ |
| **验收标准** | 产品负责人如何验证功能完成？ |

对于每个维度：
1. 分析 PRD 中已有的覆盖情况
2. 如果已充分覆盖，跳过（不提不必要的问题）
3. 如果存在缺口，拟定具体问题
4. 尽可能以多选题形式呈现
5. **始终提供"暂不确定"选项** —— 如果用户当前无法回答，记录为待办项，追加到 requirements.md 末尾

**好问题示例（业务层面）：**
- "PRD 提到按客户姓名搜索——从用户角度看，这应该是精确匹配还是模糊匹配？"
- "当通过客户姓名搜索交易订单，但该客户已被删除时，订单是否仍应出现在搜索结果中？"
- "哪些用户角色可以使用水印搜索功能？"

**坏问题示例（技术层面——推迟到 /generate-design）：**
- "模糊搜索应该用 Elasticsearch 还是数据库 LIKE 查询？"
- "客户服务不可用时，应该返回错误还是降级到缓存数据？"
- "跨服务查询传递的 ID 数量上限是多少？"

## 输出：requirements.md

使用本技能目录下的 `requirements-template.md` 作为输出结构。内容用中文输出，技术术语用英文。

写入 `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/requirements.md`。

## Requirements Review Loop

生成 `requirements.md` 后，dispatch **reviewer subagent** 对文档进行完整性和一致性审查。

1. 使用 `skills/prd-clarifying/requirements-document-reviewer-prompt.md` 中的 review prompt 模板
2. reviewer subagent 检查：遗漏的维度、矛盾之处、模糊的验收标准、PRD 与需求文档之间的差距
3. 如果 reviewer 报告问题，在 `requirements.md` 中修复并重新运行 reviewer
4. **最多 5 轮** —— 如果 5 轮修复-审查循环后问题仍然存在，停止循环并将未解决的问题汇总上报给用户
5. 当 reviewer 返回无问题（clean pass）时退出循环

## User Review Gate

review loop 通过（或上报）后，将 `requirements.md` 提交用户进行最终确认。

1. 展示已澄清内容的摘要以及剩余的待办项
2. 如果有从 review loop 上报的问题，明确高亮展示
3. 询问用户："请 review 需求文档。回复**确认**继续，或指出需要调整的内容。"
4. 如果用户要求修改，执行修改后重新进入 Requirements Review Loop
5. **在用户明确确认之前，不得提示下一步**

## 确认后

提示用户下一步操作：
- **复杂的多服务需求：** "This requirement involves multiple services. Recommend running `/generate-hld` next for high-level design."
- **单服务需求：** "This requirement targets a single service. Recommend running `/generate-design` next for detailed design."

## 集成关系

**前置要求：** superpowers:brainstorming（对话模式）
**后续步骤：** superpowers:generating-hld 或 superpowers:generating-design
