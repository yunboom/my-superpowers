# 上游同步设计方案 (obra/superpowers v4.3.0 → v5.0.1)

**日期:** 2026-03-12
**状态:** 待审核
**范围:** 全仓库（skills、hooks、tests、配置、文档）

## 概述

本仓库 (yunboom/my-superpowers) 从 obra/superpowers fork 而来，在 v4.3.0 基础上做了大量自定义扩展（PRD 驱动工作流、REQ-id 体系、中文双语、前后端模板分离等）。上游已迭代至 v5.0.1，共 65 个新提交。本方案定义文件级 diff 对比的同步策略。

## 同步起点与终点

- **Fork 点（上次同步）:** `e16d611` (v4.3.0)
- **本次同步目标:** `5ef73d2` (v5.0.1)
- **上游仓库:** https://github.com/obra/superpowers.git (main 分支)

## 上游核心变更摘要

| 版本 | 核心特性 |
|------|---------|
| v4.3.1 | Cursor 支持、Windows hook 修复 |
| v5.0.0 | Visual brainstorming、document review loop、架构指导、项目规模评估、slash command 弃用 |
| v5.0.1 | Brainstorm server 迁移至 skill 目录、Gemini CLI 支持、spec review loop 修复 |

## 同步架构：四层执行

### Layer 1：直接操作（无冲突）

#### 1.1 删除（2 个文件）

| 文件 | 原因 |
|------|------|
| `lib/skills-core.js` | 上游已删除，OpenCode 改用原生 skill 发现 |
| `tests/opencode/test-skills-core.sh` | 配套测试，随主文件删除 |

#### 1.2 上游覆盖（约 30 个文件，本仓库无自定义改动）

**配置/元数据:**
- `.claude-plugin/marketplace.json` — 版本号 4.3.0 → 5.0.1
- `.claude-plugin/plugin.json` — 版本号 4.3.0 → 5.0.1
- `.gitignore` — 新增 .DS_Store、node_modules 等忽略项
- `.gitattributes` — 新增 hooks/session-start 行结尾配置

**文档:**
- `README.md` — 新增 Claude 官方 marketplace、Cursor、Gemini CLI 安装方式
- `RELEASE-NOTES.md` — 新增 v4.3.1、v5.0.0、v5.0.1 发布说明

**OpenCode/Codex:**
- `.opencode/INSTALL.md` — TodoWrite 映射修正
- `.opencode/plugins/superpowers.js` — TodoWrite 映射修正
- `docs/README.opencode.md` — TodoWrite 映射修正
- `docs/README.codex.md` — 新增 subagent collab 配置说明
- `docs/plans/2025-11-22-opencode-support-implementation.md` — "For Claude" → "For agentic workers"
- `tests/opencode/run-tests.sh` — 移除 skills-core 测试引用
- `tests/opencode/test-plugin-loading.sh` — 移除 skills-core 检查

**Skills（无自定义改动的）:**
- `skills/using-superpowers/SKILL.md` — 新增 SUBAGENT-STOP、Instruction Priority、Gemini 支持、Platform Adaptation
- `skills/requesting-code-review/SKILL.md` — 路径更新 docs/plans/ → docs/superpowers/plans/
- `skills/subagent-driven-development/SKILL.md` — 新增 Model Selection、Implementer Status 处理
- `skills/subagent-driven-development/implementer-prompt.md` — 新增 Code Organization、升级机制
- `skills/subagent-driven-development/code-quality-reviewer-prompt.md` — 新增文件职责检查项

**Tests（路径更新 docs/plans/ → docs/superpowers/plans/）:**
- `tests/claude-code/test-helpers.sh`
- `tests/claude-code/analyze-token-usage.py`
- `tests/claude-code/test-subagent-driven-development-integration.sh`
- `tests/explicit-skill-requests/prompts/*.txt`（6 个文件）
- `tests/explicit-skill-requests/run-*.sh`（5 个文件）
- `tests/skill-triggering/prompts/executing-plans.txt`

#### 1.3 新增采纳（约 20 个文件）

**平台支持:**
- `.cursor-plugin/plugin.json` — Cursor IDE 插件配置
- `GEMINI.md` — Gemini CLI 入口
- `gemini-extension.json` — Gemini CLI 扩展配置

**Skill 辅助文件:**
- `skills/brainstorming/spec-document-reviewer-prompt.md` — spec 审查 subagent 模板
- `skills/brainstorming/visual-companion.md` — 可视化头脑风暴指南
- `skills/writing-plans/plan-document-reviewer-prompt.md` — plan 审查 subagent 模板
- `skills/using-superpowers/references/codex-tools.md` — Codex 工具名映射
- `skills/using-superpowers/references/gemini-tools.md` — Gemini CLI 工具名映射

**Brainstorm server:**
- `skills/brainstorming/scripts/index.js` — Express + WebSocket server
- `skills/brainstorming/scripts/helper.js` — 工具函数
- `skills/brainstorming/scripts/frame-template.html` — 浏览器端模板
- `skills/brainstorming/scripts/start-server.sh` — 启动脚本
- `skills/brainstorming/scripts/stop-server.sh` — 停止脚本
- `skills/brainstorming/scripts/package.json` — 依赖声明
- `skills/brainstorming/scripts/package-lock.json` — 锁定依赖
- `skills/brainstorming/scripts/node_modules/` — 预打包依赖（上游有意 vendor 进仓库，减少运行时安装依赖，`.gitignore` 中已配置 `!skills/brainstorming/scripts/node_modules/` 白名单）

**上游文档（需新建 `docs/superpowers/plans/` 目录）：**
- `docs/plans/2026-01-17-visual-brainstorming.md`（上游早期文件，仍在旧路径 `docs/plans/` 下，保持原样）
- `docs/superpowers/plans/2026-01-22-document-review-system.md`
- `docs/superpowers/plans/2026-02-19-visual-brainstorming-refactor.md`
- `docs/superpowers/specs/2026-01-22-document-review-system-design.md`
- `docs/superpowers/specs/2026-02-19-visual-brainstorming-refactor-design.md`

**测试:**
- `tests/claude-code/test-document-review-system.sh`
- `tests/brainstorm-server/server.test.js`
- `tests/brainstorm-server/package.json`
- `tests/brainstorm-server/package-lock.json`

### Layer 2：Hooks 手动合并

#### hooks/hooks.json

合并目标：采用上游的 run-hook.cmd 调用方式，保留本仓库的 xspec-session-start hook。

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd\" session-start",
            "async": false
          },
          {
            "type": "command",
            "command": "\"${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd\" xspec-session-start",
            "async": false
          }
        ]
      }
    ]
  }
}
```

#### hooks/session-start.sh → hooks/session-start

- 重命名去掉 `.sh` 后缀
- 内容使用上游版本（新增 Cursor 平台兼容）

#### hooks/xspec-session-start.sh → hooks/xspec-session-start

- 重命名去掉 `.sh` 后缀（与上游命名规范一致）
- 内容不变

#### hooks/run-hook.cmd

- 直接使用上游版本覆盖

#### Hooks 执行顺序

为避免 hook 加载失败，Layer 2 的执行顺序为：
1. 先更新 `run-hook.cmd`（覆盖）
2. 重命名 `session-start.sh` → `session-start` 并更新内容
3. 重命名 `xspec-session-start.sh` → `xspec-session-start`
4. 最后更新 `hooks.json`（此时所有引用的文件都已就位）

### Layer 3：三个核心 skill 手动合并

#### skills/brainstorming/SKILL.md

**保留的自定义内容:**
- description 中的 "user intent, requirements"
- Checklist 第 3 步：Deep research（dispatch research sub-agents via superpowers:deep-researching）
- 流程图中的 "Deep research (if needed)" 节点
- "Deep research (before proposing approaches)" 段落
- "Exploring approaches" 中 "Back options with evidence from research"
- After the Design 中的 REQ-id Resolution 段落
- specs 路径：`docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/design.md`

**融入的上游新内容:**
- Checklist 第 2 步：Offer visual companion
- Checklist 第 8 步：Spec review loop（dispatch spec-document-reviewer subagent, max 5 iterations）
- Checklist 第 9 步：User reviews written spec
- 流程图新节点：Visual questions ahead?、Offer Visual Companion、Spec review loop、Spec review passed?、User reviews spec?
- "Understanding the idea" 中项目规模评估（大项目拆分子项目）
- 新增 "Design for isolation and clarity" 段落
- 新增 "Working in existing codebases" 段落
- After the Design 中 Spec Review Loop 和 User Review Gate 段落
- 底部新增 Visual Companion 章节

**最终 Checklist（10 步）:**
1. Explore project context
2. Offer visual companion (if visual questions ahead)
3. Ask clarifying questions
4. Deep research (dispatch sub-agents for technical decisions)
5. Propose 2-3 approaches (backed by research evidence)
6. Present design (sections scaled to complexity)
7. Write design doc → `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/design.md`
8. Spec review loop (dispatch reviewer, max 5 iterations)
9. User reviews written spec
10. Transition to implementation → invoke writing-plans

#### skills/writing-plans/SKILL.md

**保留的自定义内容:**
- Step 0: Resolve Specs Path（REQ-id 目录解析）
- Context Loading（读 requirements.md + design.md）
- Load Standard Skills (std)
- REQ-id 体系（代码注释 `// REQ-{id}`、commit message `REQ-{id} feat:...`）
- Generate testing.md（端到端测试用例自动生成）
- Final Task: Run testing.md Integration Tests
- specs 路径：`docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/plan.md`
- Plan Document Header 中的 REQ 和 Specs 字段

**融入的上游新内容:**
- Scope Check 章节（多子系统拆分提醒）
- File Structure 章节（任务定义前先规划文件结构和职责边界）
- Checkbox `- [ ]` 语法（步骤用 checkbox 格式便于追踪）
- Plan Review Loop 章节（每 chunk 写完后 dispatch plan-document-reviewer，max 5 iterations）
- Execution Handoff 简化（有 subagent 能力直接用 SDD，不让用户选择）
- Header 中 "For Claude" → "For agentic workers"
- Task Structure 中步骤改为 checkbox 语法

#### skills/executing-plans/SKILL.md

**保留的自定义内容:**
- REQ Conventions 章节
- Step 1.5: Load Standard Skills (std)
- Step 2: Safety Check — External Dependencies（HARD-GATE）
- Testing Verification 步骤（HARD-GATE，testing.md 验证）
- "ABSOLUTELY FORBIDDEN to modify testing.md" 规则
- Integration 章节（required workflow skills）
- When to Stop 中的额外条目（Non-localhost 检测、testing.md issues）

**采纳的上游变更:**
- 去掉 batch 分批执行，改为一次执行全部任务
- 移除 Step 3-4-5 (Execute Batch / Report / Continue)，合并为单一 "Execute Tasks" 步骤
- 新增 subagent 推荐提示（"Superpowers works much better with access to subagents"）
- "Hit a blocker mid-batch" → "Hit a blocker"
- 移除 "Between batches: just report and wait"

### Layer 4：Review 能力扩展（新增需求）

将上游的 spec/plan review loop 模式扩展到本仓库的三个自定义 skill。

#### skills/generating-design/SKILL.md

在当前第 8 步（User Confirmation & Prompt Next Step）之前插入 review loop：

- **新增步骤：Design Review Loop**
  - 生成 design.md 后，dispatch spec-document-reviewer subagent 审查
  - 复用 `skills/brainstorming/spec-document-reviewer-prompt.md` 模板
  - 修复循环，最多 5 轮，超过则上报用户
- **新增步骤：User Review Gate**
  - 审查通过后提示用户 review 写入的 design.md
  - 用户确认后才提示下一步

#### skills/generating-hld/SKILL.md

在当前第 5 步之后新增：

- **新增第 6 步：HLD Review Loop**
  - 保存 hld.md 后，dispatch spec-document-reviewer subagent 审查
  - 审查对象为 hld.md（高层设计文档）
  - 修复循环，最多 5 轮
- **新增第 7 步：User Review Gate**
  - 审查通过后提示用户 review hld.md
  - 用户确认后才提示 /generate-design

#### skills/prd-clarifying/SKILL.md

在当前第 6 步（Generate requirements.md）和第 7 步（Prompt next step）之间新增：

- **新增步骤：Requirements Review Loop**
  - 生成 requirements.md 后，dispatch reviewer subagent 审查
  - **新建** `skills/prd-clarifying/requirements-document-reviewer-prompt.md`
  - 审查要点（与 spec reviewer 不同，侧重业务完整性）：
    - 功能边界是否清晰
    - 用户场景是否覆盖完整
    - 业务规则是否存在矛盾
    - 异常流程是否遗漏
    - 验收标准是否可测试
    - 隐含假设是否已明确
  - 修复循环，最多 5 轮
- **新增步骤：User Review Gate**
  - 审查通过后提示用户 review requirements.md
  - 用户确认后才提示下一步

#### Layer 4 验收标准

每个 review loop 扩展的验收方式：
1. **SKILL.md 结构验证** — 确认 checklist 中包含 review loop 步骤、流程图（如有）包含对应节点
2. **Reviewer prompt 存在性** — 确认引用的 reviewer prompt 模板文件存在且内容完整
3. **手动触发测试** — 在对应 skill 流程中走到 review 步骤，验证 subagent dispatch 指令是否正确生成
4. **zh-CN 一致性** — 中文版与英文版的 review loop 步骤一致

### zh-CN 同步

以下中文版本需要同步更新，保持与英文版一致：

**手动合并的 skill（内容变更）：**
- `skills/brainstorming/SKILL.zh-CN.md`
- `skills/writing-plans/SKILL.zh-CN.md`
- `skills/executing-plans/SKILL.zh-CN.md`

**扩展了 review 能力的 skill：**
- `skills/generating-design/SKILL.zh-CN.md`
- `skills/generating-hld/SKILL.zh-CN.md`
- `skills/prd-clarifying/SKILL.zh-CN.md`

## 不同步的文件

| 文件 | 原因 |
|------|------|
| `commands/brainstorm.md` | 上游标记弃用，本仓库保留自定义行为 |
| `commands/execute-plan.md` | 同上 |
| `commands/write-plan.md` | 同上 |
| `commands/prd-clarify.md` | 本仓库自定义 command，上游不存在，无需处理 |
| `commands/generate-hld.md` | 同上 |
| `commands/generate-design.md` | 同上 |

## SOP 产出

### 新建：`docs/sop/上游同步sop.md`

标准化的上游同步操作流程，内容包括：

1. **前置准备** — 配置 upstream remote
   ```bash
   git remote add upstream https://github.com/obra/superpowers.git
   ```
2. **拉取上游** — `git fetch upstream main`
3. **确认同步范围** — `git diff <上次同步commit>..FETCH_HEAD --name-status | grep -v node_modules`
4. **文件分类评估** — 按四类处理：直接覆盖 / 新增采纳 / 手动合并 / 不动
5. **执行同步** — 分层执行 Layer 1-4
6. **zh-CN 同步** — 更新所有受影响的中文版本
7. **测试验证** — 确认 hooks 加载、skill 触发正常
8. **更新同步记录** — 记录本次同步的上游 commit id
9. **更新变更 SOP** — 在 `docs/sop/变更sop.md` 追加变更记录
10. **提交** — 以 `sync(upstream): vX.Y.Z → vA.B.C` 格式提交

### 同步记录表

| 同步日期 | 上游 commit | 上游版本 | 同步范围 | 备注 |
|---------|------------|---------|---------|------|
| 2026-03-12 | `5ef73d2` | v5.0.1 | v4.3.0 → v5.0.1 | 首次同步 |

### 更新：`docs/sop/变更sop.md`

追加记录：
```
- 2026-03-12: 上游同步 v4.3.0 → v5.0.1（visual brainstorming、document review loop、Gemini/Cursor 支持、架构指导、spec/plan review loop 扩展到自定义 skill）
```

**顺带修正：** `docs/sop/变更sop.md` 中规则 5 的笔误 `.zh-CH.md` → `.zh-CN.md`
