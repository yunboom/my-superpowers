# 需求说明: 产研流程扩展 (XSpec)

## 概述

基于 my-superpowers，新增一套 PRD 驱动的产研流程，与现有 brainstorming 流程并行运行。

## 两条并行工作流

```
工作流 A（自由想法）:
  /brainstorm → /write-plan → /execute-plan

工作流 B（PRD 驱动产研流程）:
  /prd-clarify → /generate-hld(可选) → /generate-design → /write-plan → /execute-plan
```

## 新增流程

### /prd-clarify — 需求澄清
- 接收用户输入的 PRD（markdown 或 pdf 等格式），进行业务层面头脑风暴
- 严格限定在业务层面，不涉及技术实现（技术层面澄清属于 /generate-design）
- 每个问题必须包含"暂不确定"选项，记录为待办追加到 requirements.md 末尾
- 输入方式：直接粘贴内容 或 提供文件路径，agent 自动判断
- 输出：`requirements.md`（使用 `requirements-template.md` 中文模板）

### /generate-hld — 高层设计（可选）
- 针对复杂需求（涉及多个微服务），在顶层视角划分各微服务职责
- 使用 `system-design` skill 自动获取系统架构上下文
- 直接生成 `hld.md`（使用 `hld-template.md` 中文模板），一次性确认

### /generate-design — 详细设计
- 对指定微服务进行详细设计
- 流程顺序：识别技术需求 → 深度调研 → 技术头脑风暴
- 深度调研（deep research）在技术头脑风暴之前进行，先获取足够信息再讨论方案
- 强制调研触发条件：中间件选型、架构模式决策、引入新技术、性能关键设计
- 技术头脑风暴选项规则：推荐选项放首位并说明理由，末尾固定"写入 design.md 供团队评审"选项
- 输出：`design.md`（使用 `design-template.md` 团队技术方案模板）

### /write-plan — 生成实施计划
- 在 my-superpowers 基础上微调
- 上下文加载：精确读取 `requirements.md` + `design.md`，不读取其他文件
- commit 信息、代码注释携带 `REQ-{需求id}`
- 同时生成 `testing.md`（端到端测试用例）
- testing.md 要求：API 用例包含完整 curl 命令，脚本验证包含完整脚本
- plan.md 最后一个任务必须是"运行 testing.md 集成测试"

### /execute-plan — 执行实施计划
- 在 my-superpowers 基础上微调
- commit 信息、代码注释携带 `REQ-{需求id}`
- 所有任务完成时，执行 `testing.md` 中的测试用例，必须全部通过
- 禁止修改 `testing.md`，如确定用例有问题则停止并反馈用户
- 安全检查：执行单元测试前检查外部依赖连接是否为 localhost

## 文件组织

### Specs 目录结构
```
docs/specs/
  yyyy-MM-dd-REQ-{需求id}/           # 一级：按需求隔离
    {topic}/                          # 二级：按主题隔离
      requirements.md                 # /prd-clarify 产出
      hld.md                          # /generate-hld 产出（可选）
      design.md                       # /generate-design 产出
      plan.md                         # /write-plan 产出
      testing.md                      # /write-plan 同步产出
```

### Skill 文件组织
- 每个 SKILL.md 旁放 SKILL.zh-CN.md 中文对照版
- 模板文件（requirements-template.md、hld-template.md、design-template.md）内容为中文
- 技术术语保持英文

## 规范

- commit 信息前缀 `REQ-{需求id}`
- 所有代码注释携带 `// REQ-{需求id} {说明}`
- 简短主题使用简短英文描述
- 需求 ID 匹配模式：`https://project.feishu.cn/.*/detail/(\d+)`

## Specs 路径确认逻辑

所有需要确认 specs 路径的 skill 统一规则：
1. 如果当前对话中已明确知道路径 → 直接使用，无需确认
2. 如果只有一个目录 → 直接使用，无需确认
3. 如果有多个目录 → 列出所有选项供用户选择
4. 如果没有目录 → 提示执行 `/prd-clarify`

## 上下文加载规则

- `generating-hld`：读取 `requirements.md`
- `generating-design`：读取 `requirements.md` + `hld.md`（如存在）
- `writing-plans`：精确读取 `requirements.md` + `design.md`（不读其他文件）
- 同一会话中前序步骤已加载过的文件可跳过重新读取

## Skill 清单

### 新建 skill
| Skill | 说明 |
|-------|------|
| `prd-clarifying` | PRD 需求澄清（业务层面） |
| `generating-hld` | 高层设计 |
| `generating-design` | 详细设计（含深度调研） |
| `deep-researching` | 技术调研（sub-agent 派发） |
| `system-design` | 系统架构发现 |
| `using-xspec` | xSpec 流程入口引导（对标 using-superpowers） |

### 修改 skill
| Skill | 修改内容 |
|-------|---------|
| `brainstorming` | 输出路径改 specs 目录、REQ-id 确认、新增深度调研步骤 |
| `writing-plans` | specs 目录、REQ 规范、生成 testing.md、最终任务运行集成测试 |
| `executing-plans` | REQ 规范、testing.md 验证、外部依赖安全检查 |

### 新建 command
| 命令 | 调用 Skill |
|------|-----------|
| `/prd-clarify` | `prd-clarifying` |
| `/generate-hld` | `generating-hld` |
| `/generate-design` | `generating-design` |

### Agent + 搜索模块
- `agents/web-search-agent.md`
- `agents/web-search-modules/` (general-web, github-debug, stackoverflow, chinese-tech, academic-papers)

## 变更规则

- 只变更项目根目录下的文件，不变更 `.cursor/` 目录
- 尽可能不修改 my-superpowers 原有内容
- 新增内容参考 my-superpowers 现有逻辑
