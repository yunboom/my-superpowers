# 上游同步 SOP

## 概述

本仓库 (yunboom/my-superpowers) 从 [obra/superpowers](https://github.com/obra/superpowers) fork 而来。定期同步上游更新以获取新功能和修复，同时保留本仓库的自定义扩展。

## 前置准备

确保配置了 upstream remote：

```bash
git remote add upstream https://github.com/obra/superpowers.git
```

验证：

```bash
git remote -v
# 应看到 origin（yunboom）和 upstream（obra）
```

## 同步流程

### 1. 拉取上游最新代码

```bash
git fetch upstream main
```

### 2. 确认同步范围

查看上次同步以来的所有变更文件：

```bash
git diff <上次同步commit>..upstream/main --name-status | grep -v node_modules | sort
```

上次同步 commit 见本文档底部"同步记录表"。

### 3. 文件分类评估

将变更文件分为四类：

| 类型 | 判断标准 | 操作 |
|------|---------|------|
| **直接覆盖** | 本仓库未自定义改动的文件 | `git checkout upstream/main -- <file>` |
| **新增采纳** | 上游新增的文件，本仓库不存在 | `git checkout upstream/main -- <file>` |
| **手动合并** | 本仓库有自定义改动的文件 | 逐个对比 diff，手动融入上游新内容 |
| **不同步** | 本仓库有意与上游不同的文件 | 跳过 |

### 4. 执行同步

按风险从低到高分层执行：

**Layer 1：直接操作（无冲突）**
- 删除上游已移除的文件
- 覆盖本仓库未自定义的文件
- 采纳上游新增的文件

**Layer 2：Hooks 合并**
- 注意 hooks.json 需要保留自定义的 xspec-session-start hook
- 遵循上游的命名规范（如无 .sh 后缀）

**Layer 3：核心 Skill 手动合并**
- brainstorming、writing-plans、executing-plans 是重点
- 保留自定义内容（REQ-id、deep research、testing.md 等）
- 融入上游新功能

**Layer 4：扩展新能力到自定义 Skill**
- 将上游的新模式（如 self-review、新平台支持）扩展到自定义 skill

### 5. 术语对齐

上游使用 "spec" 指代设计文档，本仓库统一使用 "design"。同步时需要将上游引入的 "spec" 术语替换为 "design"：

| 上游术语 | 本仓库术语 | 说明 |
|---------|-----------|------|
| spec / specification | design / 设计文档 | 概念名称 |
| spec review loop / self-review | design self-review | 审查机制（v5.0.7 起上游改为 self-review） |
| spec-document-reviewer | design-document-reviewer | 审查器名称 |
| spec-document-reviewer-prompt.md | design-document-reviewer-prompt.md | 审查模板文件名 |
| `[SPEC_FILE_PATH]` | `[DESIGN_FILE_PATH]` | 模板变量 |
| "User reviews written spec" | "User reviews written design" | 检查清单条目 |

**注意：** 目录路径 `docs/specs/` 保持不变（仅为存储目录，不影响概念语义）。

### 6. zh-CN 同步

更新所有受影响的中文版本，保持与英文版一致。

### 7. 测试验证

```bash
# 验证 hooks.json 格式正确
python3 -c "import json; json.load(open('hooks/hooks.json')); print('valid')"

# 验证 hook 脚本存在且可执行
test -x hooks/session-start && echo "OK"
test -x hooks/xspec-session-start && echo "OK"

# 验证 reviewer prompt 文件存在
ls skills/brainstorming/design-document-reviewer-prompt.md
ls skills/writing-plans/plan-document-reviewer-prompt.md
ls skills/prd-clarifying/requirements-document-reviewer-prompt.md
```

### 8. 更新同步记录

在本文档底部的同步记录表中添加新条目。

### 9. 更新变更 SOP

在 `docs/sop/变更sop.md` 的变更历史中追加记录。

### 10. 提交

```bash
git commit -m "sync(upstream): vX.Y.Z → vA.B.C"
```

## 本仓库的自定义清单

同步时需要始终保留的自定义内容：

| 自定义 | 涉及文件 | 说明 |
|--------|---------|------|
| PRD 驱动工作流 | prd-clarifying、generating-hld、generating-design | 5 个自定义 skill |
| REQ-id 体系 | brainstorming、writing-plans、executing-plans | commit message + 代码注释 |
| Deep research | brainstorming | dispatch research sub-agents |
| testing.md | writing-plans、executing-plans | 端到端测试用例自动生成 |
| Safety Check | executing-plans | 外部依赖安全检查 (HARD-GATE) |
| Load std skills | writing-plans、executing-plans | 自动加载规范 skill |
| xSpec hooks | hooks/ | xspec-session-start |
| 中文双语 | 所有 skill 的 .zh-CN.md | 中文版本 |
| 自定义 commands | commands/ | prd-clarify、generate-hld、generate-design |
| 前后端模板分离 | generating-design | design-template-backend/frontend |
| 术语对齐 spec→design | brainstorming、generating-design、generating-hld 等 | 上游 "spec" 概念统一为 "design" |

## 不同步的文件

| 文件 | 原因 |
|------|------|
| `commands/brainstorm.md` | 上游标记弃用，本仓库保留自定义行为 |
| `commands/execute-plan.md` | 同上 |
| `commands/write-plan.md` | 同上 |
| `commands/prd-clarify.md` | 本仓库自定义，上游不存在 |
| `commands/generate-hld.md` | 同上 |
| `commands/generate-design.md` | 同上 |

## 同步记录表

| 同步日期 | 上游 commit | 上游版本 | 操作分支 | 备注 |
|---------|------------|---------|---------|------|
| 2026-03-12 | `363923f` | v5.0.2 | feature/init | 首次同步，从 v4.3.0 同步到 v5.0.2 |
| 2026-04-01 | `dd23728` | v5.0.7 | feature/init | v5.0.2→v5.0.7：subagent review→inline self-review、Copilot CLI 支持、brainstorm server ESM/Windows 修复、POSIX hook 兼容、execution handoff 用户选择模式 |
