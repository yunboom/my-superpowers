# 变更 SOP

## 文件变更规则

1. **只变更项目根目录下的文件**（`skills/`、`commands/`、`agents/`、`docs/` 等），**不变更 `.cursor/` 目录下的内容**
2. `.cursor/` 目录下的文件由 Cursor IDE 自动同步或手动处理，不在常规变更范围内

## 项目结构约定

```
my-superpowers/
├── skills/                    # 主 skill 目录（变更对象）
├── commands/                  # 命令定义（变更对象）
├── agents/                    # Agent 定义（变更对象）
├── docs/
│   └── specs/                 # 需求规格（按 REQ-id 隔离）
└── ...
```

## 两条并行工作流

```
工作流 A（自由想法）:
  /brainstorm → /write-plan → /execute-plan

工作流 B（PRD 驱动产研流程）:
  /prd-clarify → /generate-hld(可选) → /generate-design → /write-plan → /execute-plan
```

## Specs 目录结构

```
docs/specs/
  yyyy-MM-dd-REQ-{id}/              # 一级：按需求隔离
    {topic}/                         # 二级：按主题隔离
      requirements.md                # /prd-clarify 产出
      hld.md                         # /generate-hld 产出（可选）
      design.md                      # /generate-design 产出
      plan.md                        # /write-plan 产出
      testing.md                     # /write-plan 同步产出
```

## 需求 ID 提取规则

1. 从 PRD 内容中匹配 `https://project.feishu.cn/.*/detail/(\d+)`
2. 提取链接末尾数字作为需求 ID
3. 匹配不到时询问用户提供
4. brainstorming 流程：自动选取 `docs/specs/` 下最近的 REQ-id 目录，跟用户确认

## 规范

- **Commit 消息前缀：** `REQ-{id}`（如 `REQ-12345 feat: add order validation`）
- **代码注释：** 所有代码注释都需要携带 `// REQ-{id} {说明}`
- **Topic 命名：** 简短英文单词（如 `order-validation`、`user-auth`）
- **技术术语：** 中文文档中保持英文（如 gRPC、Kafka、Redis、API）

## Skill 清单

### 新建 skill（5 个）

| Skill | 说明 | 模板文件 |
|-------|------|---------|
| `prd-clarifying` | PRD 需求澄清 | `requirements-template.md` |
| `generating-hld` | 高层设计 | `hld-template.md` |
| `generating-design` | 详细设计 | `design-template.md` |
| `deep-researching` | 技术调研（sub-agent） | 无 |
| `system-design` | 系统架构发现 | 无 |

### 修改 skill（3 个）

| Skill | 修改内容 |
|-------|---------|
| `brainstorming` | 输出路径改 specs 目录，需确认 REQ-id |
| `writing-plans` | specs 目录、REQ 规范、生成 testing.md、按需加载上下文 |
| `executing-plans` | REQ 规范、testing.md 验证、外部依赖安全检查 |

### 新建 command（3 个）

| 命令 | 调用 Skill |
|------|-----------|
| `/prd-clarify` | `prd-clarifying` |
| `/generate-hld` | `generating-hld` |
| `/generate-design` | `generating-design` |

### Agent + 搜索模块（6 个）

- `agents/web-search-agent.md`
- `agents/web-search-modules/general-web.md`
- `agents/web-search-modules/github-debug.md`
- `agents/web-search-modules/stackoverflow.md`
- `agents/web-search-modules/chinese-tech.md`
- `agents/web-search-modules/academic-papers.md`

## 关键设计决策

1. **按需加载上下文：** `generating-hld`、`generating-design`、`writing-plans` 加载上下文时，如果当前对话中已有完整内容（如上一步产出），则不再重复读取文件
2. **模板输出中文：** 所有模板（requirements-template.md、hld-template.md、design-template.md）输出为中文，技术术语保持英文
3. **deep-researching 并行派发：** 遇到多个调研主题时，同时派发多个 sub-agent，每个负责一个主题
4. **executing-plans 安全检查：** 执行单元测试前检查外部依赖连接是否为 localhost，非本地连接须征询用户同意
5. **testing.md 不可修改：** 执行过程中禁止修改 testing.md，如发现用例问题则停止并反馈用户
6. **中文翻译：** 每个 SKILL.md 旁放 SKILL.zh-CN.md 中文对照版，供人类阅读
7. **design-template.md 使用团队模板：** 替换为团队现有的技术方案模板结构

## 变更历史

- 2026-02-15: 初始创建产研流程扩展（5 新 skill + 3 修改 skill + 3 command + 6 agent 文件 + 19 中文翻译）
