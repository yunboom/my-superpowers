# 上游同步实施计划 (obra/superpowers v4.3.0 → v5.0.1)

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将 obra/superpowers 上游 v4.3.0 → v5.0.1 的变更同步到本仓库，保留所有自定义扩展，并将同步流程写入 SOP。

**Architecture:** 分四层执行——Layer 1 处理无冲突的直接操作（删除/覆盖/新增），Layer 2 处理 hooks 手动合并，Layer 3 处理三个核心 skill 的手动合并，Layer 4 扩展 review 能力到自定义 skill。最后产出 SOP 文档。

**Tech Stack:** Git (checkout/diff), Shell scripts, Markdown

**Spec:** `docs/superpowers/specs/2026-03-12-upstream-sync-design.md`

---

## Chunk 1: Layer 1 — 直接操作

### Task 1: 配置 upstream remote 并 fetch

**Files:**
- 无文件变更，Git 配置操作

- [ ] **Step 1: 添加 upstream remote**

```bash
git remote add upstream https://github.com/obra/superpowers.git
```

如果已存在则跳过。

- [ ] **Step 2: Fetch 上游最新代码**

```bash
git fetch upstream main
```

- [ ] **Step 3: 确认 upstream/main 指向正确 commit**

```bash
git log upstream/main --oneline -1
```

Expected: `5ef73d2` 或更新的 commit

---

### Task 2: 删除上游已移除的文件

**Files:**
- Delete: `lib/skills-core.js`
- Delete: `tests/opencode/test-skills-core.sh`

- [ ] **Step 1: 删除文件**

```bash
rm lib/skills-core.js tests/opencode/test-skills-core.sh
```

- [ ] **Step 2: 如果 lib/ 目录为空则删除**

```bash
rmdir lib/ 2>/dev/null || true
```

- [ ] **Step 3: Commit**

```bash
git add -u lib/ tests/opencode/test-skills-core.sh
git commit -m "sync(upstream): remove deprecated skills-core.js and its test"
```

---

### Task 3: 上游覆盖 — 配置和元数据文件

**Files:**
- Modify: `.claude-plugin/marketplace.json`
- Modify: `.claude-plugin/plugin.json`
- Modify: `.gitignore`
- Modify: `.gitattributes`

- [ ] **Step 1: 从上游 checkout 这些文件**

```bash
git checkout upstream/main -- \
  .claude-plugin/marketplace.json \
  .claude-plugin/plugin.json \
  .gitignore \
  .gitattributes
```

- [ ] **Step 2: 验证变更内容**

```bash
git diff --cached --stat
```

Expected: 4 个文件变更

- [ ] **Step 3: Commit**

```bash
git commit -m "sync(upstream): update plugin metadata and gitignore to v5.0.1"
```

---

### Task 4: 上游覆盖 — 文档文件

**Files:**
- Modify: `README.md`
- Modify: `RELEASE-NOTES.md`

- [ ] **Step 1: 从上游 checkout**

```bash
git checkout upstream/main -- README.md RELEASE-NOTES.md
```

- [ ] **Step 2: Commit**

```bash
git commit -m "sync(upstream): update README and release notes to v5.0.1"
```

---

### Task 5: 上游覆盖 — OpenCode/Codex 相关文件

**Files:**
- Modify: `.opencode/INSTALL.md`
- Modify: `.opencode/plugins/superpowers.js`
- Modify: `docs/README.opencode.md`
- Modify: `docs/README.codex.md`
- Modify: `docs/plans/2025-11-22-opencode-support-implementation.md`
- Modify: `tests/opencode/run-tests.sh`
- Modify: `tests/opencode/test-plugin-loading.sh`

- [ ] **Step 1: 从上游 checkout**

```bash
git checkout upstream/main -- \
  .opencode/INSTALL.md \
  .opencode/plugins/superpowers.js \
  docs/README.opencode.md \
  docs/README.codex.md \
  docs/plans/2025-11-22-opencode-support-implementation.md \
  tests/opencode/run-tests.sh \
  tests/opencode/test-plugin-loading.sh
```

- [ ] **Step 2: Commit**

```bash
git commit -m "sync(upstream): update OpenCode/Codex files with TodoWrite fix and skills-core removal"
```

---

### Task 6: 上游覆盖 — 无自定义改动的 Skill 文件

**Files:**
- Modify: `skills/using-superpowers/SKILL.md`
- Modify: `skills/requesting-code-review/SKILL.md`
- Modify: `skills/subagent-driven-development/SKILL.md`
- Modify: `skills/subagent-driven-development/implementer-prompt.md`
- Modify: `skills/subagent-driven-development/code-quality-reviewer-prompt.md`

- [ ] **Step 1: 从上游 checkout**

```bash
git checkout upstream/main -- \
  skills/using-superpowers/SKILL.md \
  skills/requesting-code-review/SKILL.md \
  skills/subagent-driven-development/SKILL.md \
  skills/subagent-driven-development/implementer-prompt.md \
  skills/subagent-driven-development/code-quality-reviewer-prompt.md
```

- [ ] **Step 2: Commit**

```bash
git commit -m "sync(upstream): update using-superpowers, code-review, and SDD skills to v5.0.1"
```

---

### Task 7: 上游覆盖 — Tests 文件

**Files:**
- Modify: `tests/claude-code/test-helpers.sh`
- Modify: `tests/claude-code/analyze-token-usage.py`
- Modify: `tests/claude-code/test-subagent-driven-development-integration.sh`
- Modify: `tests/explicit-skill-requests/prompts/*.txt` (6 files)
- Modify: `tests/explicit-skill-requests/run-*.sh` (5 files)
- Modify: `tests/skill-triggering/prompts/executing-plans.txt`

- [ ] **Step 1: 从上游 checkout**

```bash
git checkout upstream/main -- \
  tests/claude-code/test-helpers.sh \
  tests/claude-code/analyze-token-usage.py \
  tests/claude-code/test-subagent-driven-development-integration.sh \
  tests/explicit-skill-requests/prompts/ \
  tests/explicit-skill-requests/run-claude-describes-sdd.sh \
  tests/explicit-skill-requests/run-extended-multiturn-test.sh \
  tests/explicit-skill-requests/run-haiku-test.sh \
  tests/explicit-skill-requests/run-multiturn-test.sh \
  tests/explicit-skill-requests/run-test.sh \
  tests/skill-triggering/prompts/executing-plans.txt
```

- [ ] **Step 2: Commit**

```bash
git commit -m "sync(upstream): update test files with docs/superpowers/plans path migration"
```

---

### Task 8: 新增采纳 — 平台支持文件

**Files:**
- Create: `.cursor-plugin/plugin.json`
- Create: `GEMINI.md`
- Create: `gemini-extension.json`

- [ ] **Step 1: 从上游 checkout**

```bash
git checkout upstream/main -- \
  .cursor-plugin/plugin.json \
  GEMINI.md \
  gemini-extension.json
```

- [ ] **Step 2: Commit**

```bash
git commit -m "sync(upstream): add Cursor and Gemini CLI platform support"
```

---

### Task 9: 新增采纳 — Skill 辅助文件

**Files:**
- Create: `skills/brainstorming/design-document-reviewer-prompt.md`
- Create: `skills/brainstorming/visual-companion.md`
- Create: `skills/writing-plans/plan-document-reviewer-prompt.md`
- Create: `skills/using-superpowers/references/codex-tools.md`
- Create: `skills/using-superpowers/references/gemini-tools.md`

- [ ] **Step 1: 从上游 checkout**

```bash
git checkout upstream/main -- \
  skills/brainstorming/design-document-reviewer-prompt.md \
  skills/brainstorming/visual-companion.md \
  skills/writing-plans/plan-document-reviewer-prompt.md \
  skills/using-superpowers/references/codex-tools.md \
  skills/using-superpowers/references/gemini-tools.md
```

- [ ] **Step 2: Commit**

```bash
git commit -m "sync(upstream): add spec/plan reviewer prompts, visual companion, and tool mappings"
```

---

### Task 10: 新增采纳 — Brainstorm server

**Files:**
- Create: `skills/brainstorming/scripts/` (entire directory including node_modules)

- [ ] **Step 1: 从上游 checkout 整个 scripts 目录**

```bash
git checkout upstream/main -- skills/brainstorming/scripts/
```

- [ ] **Step 2: 验证文件结构**

```bash
ls skills/brainstorming/scripts/
```

Expected: `frame-template.html`, `helper.js`, `index.js`, `node_modules/`, `package-lock.json`, `package.json`, `start-server.sh`, `stop-server.sh`

- [ ] **Step 3: Commit**

```bash
git add skills/brainstorming/scripts/
git commit -m "sync(upstream): add brainstorm visual companion server with vendored deps"
```

---

### Task 11: 新增采纳 — 上游文档和测试

**Files:**
- Create: `docs/plans/2026-01-17-visual-brainstorming.md`
- Create: `docs/superpowers/plans/2026-01-22-document-review-system.md`
- Create: `docs/superpowers/plans/2026-02-19-visual-brainstorming-refactor.md`
- Create: `docs/superpowers/specs/2026-01-22-document-review-system-design.md`
- Create: `docs/superpowers/specs/2026-02-19-visual-brainstorming-refactor-design.md`
- Create: `tests/claude-code/test-document-review-system.sh`
- Create: `tests/brainstorm-server/server.test.js`
- Create: `tests/brainstorm-server/package.json`
- Create: `tests/brainstorm-server/package-lock.json`

- [ ] **Step 1: 创建目录并从上游 checkout**

```bash
mkdir -p docs/superpowers/plans

git checkout upstream/main -- \
  docs/plans/2026-01-17-visual-brainstorming.md \
  docs/superpowers/plans/2026-01-22-document-review-system.md \
  docs/superpowers/plans/2026-02-19-visual-brainstorming-refactor.md \
  docs/superpowers/specs/2026-01-22-document-review-system-design.md \
  docs/superpowers/specs/2026-02-19-visual-brainstorming-refactor-design.md \
  tests/claude-code/test-document-review-system.sh \
  tests/brainstorm-server/
```

- [ ] **Step 2: Commit**

```bash
git add docs/plans/2026-01-17-visual-brainstorming.md \
  docs/superpowers/plans/ \
  docs/superpowers/specs/2026-01-22-document-review-system-design.md \
  docs/superpowers/specs/2026-02-19-visual-brainstorming-refactor-design.md \
  tests/claude-code/test-document-review-system.sh \
  tests/brainstorm-server/
git commit -m "sync(upstream): add upstream design docs, plans, and new tests"
```

---

## Chunk 2: Layer 2 — Hooks 手动合并

### Task 12: 更新 run-hook.cmd

**Files:**
- Modify: `hooks/run-hook.cmd`

- [ ] **Step 1: 从上游 checkout**

```bash
git checkout upstream/main -- hooks/run-hook.cmd
```

- [ ] **Step 2: Commit**

```bash
git commit -m "sync(upstream): update run-hook.cmd with improved Windows bash detection"
```

---

### Task 13: 重命名并更新 session-start

**Files:**
- Rename: `hooks/session-start.sh` → `hooks/session-start`

- [ ] **Step 1: 删除旧文件**

```bash
git rm hooks/session-start.sh
```

- [ ] **Step 2: 从上游 checkout 新文件**

```bash
git checkout upstream/main -- hooks/session-start
```

- [ ] **Step 3: 确保可执行权限**

```bash
chmod +x hooks/session-start
```

- [ ] **Step 4: Commit**

```bash
git add hooks/session-start
git commit -m "sync(upstream): rename session-start.sh to session-start with Cursor platform support"
```

---

### Task 14: 重命名 xspec-session-start

**Files:**
- Rename: `hooks/xspec-session-start.sh` → `hooks/xspec-session-start`

- [ ] **Step 1: 重命名文件（保留内容不变）**

```bash
git mv hooks/xspec-session-start.sh hooks/xspec-session-start
```

- [ ] **Step 2: 确保可执行权限**

```bash
chmod +x hooks/xspec-session-start
```

- [ ] **Step 3: Commit**

```bash
git add hooks/xspec-session-start
git commit -m "sync(upstream): rename xspec-session-start.sh to match extensionless convention"
```

---

### Task 15: 更新 hooks.json

**Files:**
- Modify: `hooks/hooks.json`

- [ ] **Step 1: 写入合并后的 hooks.json**

将 `hooks/hooks.json` 的完整内容替换为：

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

- [ ] **Step 2: 验证 JSON 格式正确**

```bash
python3 -c "import json; json.load(open('hooks/hooks.json')); print('valid')"
```

Expected: `valid`

- [ ] **Step 3: Commit**

```bash
git add hooks/hooks.json
git commit -m "sync(upstream): update hooks.json to use run-hook.cmd dispatch"
```

---

## Chunk 3: Layer 3 — 核心 Skill 手动合并

### Task 16: 手动合并 brainstorming/SKILL.md

**Files:**
- Modify: `skills/brainstorming/SKILL.md`

- [ ] **Step 1: 读取上游版本和当前版本**

读取上游版本：
```bash
git show upstream/main:skills/brainstorming/SKILL.md
```

读取当前版本：`skills/brainstorming/SKILL.md`（已在仓库中）

- [ ] **Step 2: 编写合并后的内容**

合并原则（参照 spec Layer 3 brainstorming 部分）：

**保留自定义：**
- description 中的 "user intent, requirements"
- Deep research 步骤（checklist + 流程图节点 + 段落）
- "Back options with evidence from research"
- REQ-id Resolution 段落
- specs 路径 `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/design.md`

**融入上游：**
- Visual companion（checklist 第 2 步 + 底部章节）
- Spec review loop（checklist 第 8-9 步 + After the Design 段落）
- 项目规模评估（Understanding the idea 中）
- "Design for isolation and clarity" 段落
- "Working in existing codebases" 段落
- 流程图新增所有上游节点

最终 checklist 为 10 步（见 spec 第 185-195 行）。

- [ ] **Step 3: 验证合并后文件包含所有必需内容**

检查以下关键字全部出现：
- `Deep research`
- `visual companion`
- `design-document-reviewer`
- `REQ-id`
- `Design for isolation`
- `Working in existing codebases`

- [ ] **Step 4: Commit**

```bash
git add skills/brainstorming/SKILL.md
git commit -m "sync(upstream): merge brainstorming SKILL.md — add visual companion, spec review loop, architecture guidance"
```

---

### Task 17: 手动合并 writing-plans/SKILL.md

**Files:**
- Modify: `skills/writing-plans/SKILL.md`

- [ ] **Step 1: 读取上游版本和当前版本**

读取上游版本：
```bash
git show upstream/main:skills/writing-plans/SKILL.md
```

读取当前版本：`skills/writing-plans/SKILL.md`（已在仓库中）

- [ ] **Step 2: 编写合并后的内容**

合并原则（参照 spec Layer 3 writing-plans 部分）：

**保留自定义：**
- Step 0: Resolve Specs Path
- Context Loading
- Load Standard Skills (std)
- REQ-id 体系（代码注释 + commit message）
- Generate testing.md
- Final Task: Run testing.md
- specs 路径
- Plan Document Header 中 REQ 和 Specs 字段

**融入上游：**
- Scope Check 章节
- File Structure 章节
- Checkbox `- [ ]` 语法
- Plan Review Loop 章节
- Execution Handoff 简化
- "For Claude" → "For agentic workers"

- [ ] **Step 3: 验证合并后文件包含所有必需内容**

检查以下关键字全部出现：
- `Resolve Specs Path`
- `Scope Check`
- `File Structure`
- `- [ ]` (checkbox syntax)
- `Plan Review Loop`
- `plan-document-reviewer`
- `REQ-{id}`
- `testing.md`
- `Load Standard Skills`

- [ ] **Step 4: Commit**

```bash
git add skills/writing-plans/SKILL.md
git commit -m "sync(upstream): merge writing-plans SKILL.md — add scope check, file structure, plan review loop, checkbox syntax"
```

---

### Task 18: 手动合并 executing-plans/SKILL.md

**Files:**
- Modify: `skills/executing-plans/SKILL.md`

- [ ] **Step 1: 读取上游版本和当前版本**

读取上游版本：
```bash
git show upstream/main:skills/executing-plans/SKILL.md
```

读取当前版本：`skills/executing-plans/SKILL.md`（已在仓库中）

- [ ] **Step 2: 编写合并后的内容**

合并原则（参照 spec Layer 3 executing-plans 部分）：

**保留自定义：**
- REQ Conventions 章节
- Step 1.5: Load Standard Skills (std)
- Step 2: Safety Check — External Dependencies (HARD-GATE)
- Testing Verification (HARD-GATE)
- Integration 章节

**采纳上游：**
- 去掉 batch，改为一次执行全部任务
- 移除 Step 3-4-5 (batch/report/continue)
- 新增 subagent 推荐提示
- 简化 blocker 描述

最终流程：Step 1 (Load & Review) → Step 1.5 (Load std skills) → Step 2 (Safety Check) → Step 3 (Execute Tasks，不再分批) → Step 4 (Testing Verification) → Step 5 (Complete Development)

- [ ] **Step 3: 验证合并后文件包含所有必需内容**

检查以下关键字全部出现：
- `REQ Conventions`
- `Load Standard Skills`
- `Safety Check`
- `HARD-GATE`
- `testing.md`
- `subagent`
- 不应出现 `Execute Batch` 或 `Default: First 3 tasks`

- [ ] **Step 4: Commit**

```bash
git add skills/executing-plans/SKILL.md
git commit -m "sync(upstream): merge executing-plans SKILL.md — remove batch mode, add subagent recommendation"
```

---

## Chunk 4: Layer 4 — Review 能力扩展

### Task 19: 新建 requirements-document-reviewer-prompt.md

**Files:**
- Create: `skills/prd-clarifying/requirements-document-reviewer-prompt.md`

- [ ] **Step 1: 创建 reviewer prompt 模板**

参照 `skills/brainstorming/design-document-reviewer-prompt.md` 的结构，创建需求文档审查模板。审查要点侧重业务完整性：

- 功能边界是否清晰
- 用户场景是否覆盖完整
- 业务规则是否存在矛盾
- 异常流程是否遗漏
- 验收标准是否可测试
- 隐含假设是否已明确

- [ ] **Step 2: Commit**

```bash
git add skills/prd-clarifying/requirements-document-reviewer-prompt.md
git commit -m "feat(prd-clarifying): add requirements document reviewer prompt template"
```

---

### Task 20: 扩展 generating-design SKILL.md 的 review loop

**Files:**
- Modify: `skills/generating-design/SKILL.md`

- [ ] **Step 1: 读取当前 SKILL.md**

- [ ] **Step 2: 在第 7 步（Generate Design Document）和第 8 步（User Confirmation）之间插入**

新增两个步骤：
- **Design Review Loop** — dispatch design-document-reviewer subagent，复用 `skills/brainstorming/design-document-reviewer-prompt.md`，修复循环最多 5 轮
- **User Review Gate** — 审查通过后提示用户 review design.md

更新 checklist 编号（总步骤从 8 变为 10）。

- [ ] **Step 3: 验证 checklist 包含 review loop 步骤**

- [ ] **Step 4: Commit**

```bash
git add skills/generating-design/SKILL.md
git commit -m "feat(generating-design): add design review loop and user review gate"
```

---

### Task 21: 扩展 generating-hld SKILL.md 的 review loop

**Files:**
- Modify: `skills/generating-hld/SKILL.md`

- [ ] **Step 1: 读取当前 SKILL.md**

- [ ] **Step 2: 在第 5 步之后新增第 6-7 步**

- **第 6 步：HLD Review Loop** — dispatch design-document-reviewer subagent 审查 hld.md，修复循环最多 5 轮
- **第 7 步：User Review Gate** — 审查通过后提示用户 review hld.md，确认后提示 /generate-design

更新 checklist 编号（总步骤从 5 变为 7）。

- [ ] **Step 3: 验证 checklist 包含 review loop 步骤**

- [ ] **Step 4: Commit**

```bash
git add skills/generating-hld/SKILL.md
git commit -m "feat(generating-hld): add HLD review loop and user review gate"
```

---

### Task 22: 扩展 prd-clarifying SKILL.md 的 review loop

**Files:**
- Modify: `skills/prd-clarifying/SKILL.md`

- [ ] **Step 1: 读取当前 SKILL.md**

- [ ] **Step 2: 在第 6 步（Generate requirements.md）和第 7 步（Prompt next step）之间插入**

新增两个步骤：
- **Requirements Review Loop** — dispatch reviewer subagent（使用 Task 19 创建的 requirements-document-reviewer-prompt.md），修复循环最多 5 轮
- **User Review Gate** — 审查通过后提示用户 review requirements.md

更新 checklist 编号（总步骤从 7 变为 9）。

- [ ] **Step 3: 验证 checklist 包含 review loop 步骤**

- [ ] **Step 4: Commit**

```bash
git add skills/prd-clarifying/SKILL.md
git commit -m "feat(prd-clarifying): add requirements review loop and user review gate"
```

---

## Chunk 5: zh-CN 同步 + SOP 产出

### Task 23: 同步 brainstorming SKILL.zh-CN.md

**Files:**
- Modify: `skills/brainstorming/SKILL.zh-CN.md`

- [ ] **Step 1: 读取当前 zh-CN 版本和合并后的英文版**
- [ ] **Step 2: 将 Task 16 中新增的内容翻译并同步到中文版**

需要同步的内容：visual companion、spec review loop、项目规模评估、Design for isolation、Working in existing codebases

- [ ] **Step 3: Commit**

```bash
git add skills/brainstorming/SKILL.zh-CN.md
git commit -m "sync(upstream): update brainstorming zh-CN with visual companion and review loop"
```

---

### Task 24: 同步 writing-plans SKILL.zh-CN.md

**Files:**
- Modify: `skills/writing-plans/SKILL.zh-CN.md`

- [ ] **Step 1: 读取当前 zh-CN 版本和合并后的英文版**
- [ ] **Step 2: 将 Task 17 中新增的内容翻译并同步到中文版**

需要同步的内容：Scope Check、File Structure、checkbox 语法、Plan Review Loop、Execution Handoff 简化

- [ ] **Step 3: Commit**

```bash
git add skills/writing-plans/SKILL.zh-CN.md
git commit -m "sync(upstream): update writing-plans zh-CN with scope check and plan review loop"
```

---

### Task 25: 同步 executing-plans SKILL.zh-CN.md

**Files:**
- Modify: `skills/executing-plans/SKILL.zh-CN.md`

- [ ] **Step 1: 读取当前 zh-CN 版本和合并后的英文版**
- [ ] **Step 2: 将 Task 18 中新增的内容翻译并同步到中文版**

需要同步的内容：去掉 batch、subagent 推荐提示

- [ ] **Step 3: Commit**

```bash
git add skills/executing-plans/SKILL.zh-CN.md
git commit -m "sync(upstream): update executing-plans zh-CN — remove batch mode"
```

---

### Task 26: 同步 generating-design SKILL.zh-CN.md

**Files:**
- Modify: `skills/generating-design/SKILL.zh-CN.md`

- [ ] **Step 1: 读取当前 zh-CN 版本和合并后的英文版**
- [ ] **Step 2: 将 Task 20 中新增的 review loop 和 user review gate 翻译并同步到中文版**
- [ ] **Step 3: Commit**

```bash
git add skills/generating-design/SKILL.zh-CN.md
git commit -m "feat(generating-design): add review loop to zh-CN version"
```

---

### Task 27: 同步 generating-hld SKILL.zh-CN.md

**Files:**
- Modify: `skills/generating-hld/SKILL.zh-CN.md`

- [ ] **Step 1: 读取当前 zh-CN 版本和合并后的英文版**
- [ ] **Step 2: 将 Task 21 中新增的 review loop 和 user review gate 翻译并同步到中文版**
- [ ] **Step 3: Commit**

```bash
git add skills/generating-hld/SKILL.zh-CN.md
git commit -m "feat(generating-hld): add review loop to zh-CN version"
```

---

### Task 28: 同步 prd-clarifying SKILL.zh-CN.md

**Files:**
- Modify: `skills/prd-clarifying/SKILL.zh-CN.md`

- [ ] **Step 1: 读取当前 zh-CN 版本和合并后的英文版**
- [ ] **Step 2: 将 Task 22 中新增的 review loop 和 user review gate 翻译并同步到中文版**
- [ ] **Step 3: Commit**

```bash
git add skills/prd-clarifying/SKILL.zh-CN.md
git commit -m "feat(prd-clarifying): add review loop to zh-CN version"
```

---

### Task 29: 创建上游同步 SOP 文档

**Files:**
- Create: `docs/sop/上游同步sop.md`

- [ ] **Step 1: 编写 SOP 文档**

内容包括（参照 spec 第 320-334 行）：
1. 前置准备 — 配置 upstream remote
2. 拉取上游 — `git fetch upstream main`
3. 确认同步范围 — `git diff` 查看变更文件
4. 文件分类评估 — 四类处理策略
5. 执行同步 — 分层执行
6. zh-CN 同步
7. 测试验证
8. 更新同步记录
9. 更新变更 SOP
10. 提交

包含同步记录表（首条记录：2026-03-12, `5ef73d2`, v5.0.1）。

- [ ] **Step 2: Commit**

```bash
git add docs/sop/上游同步sop.md
git commit -m "docs(sop): add upstream sync SOP with first sync record"
```

---

### Task 30: 更新变更 SOP

**Files:**
- Modify: `docs/sop/变更sop.md`

- [ ] **Step 1: 修正笔误 `.zh-CH.md` → `.zh-CN.md`**

- [ ] **Step 2: 追加变更记录**

```
- 2026-03-12: 上游同步 v4.3.0 → v5.0.1（visual brainstorming、document review loop、Gemini/Cursor 支持、架构指导、spec/plan review loop 扩展到自定义 skill）
```

- [ ] **Step 3: Commit**

```bash
git add docs/sop/变更sop.md
git commit -m "docs(sop): record upstream sync v4.3.0 → v5.0.1 and fix zh-CN typo"
```

---

### Task 31: 验证同步完整性

**Files:**
- 无文件变更，验证操作

- [ ] **Step 1: 验证上游 FETCH_HEAD 的所有非 node_modules 文件都已处理**

```bash
git diff e16d611..upstream/main --name-only | grep -v node_modules | sort > /tmp/upstream-changes.txt
# 逐一检查是否每个文件都已同步或在"不同步"列表中
```

- [ ] **Step 2: 验证 hooks 加载**

```bash
python3 -c "import json; d=json.load(open('hooks/hooks.json')); print('hooks count:', len(d['hooks']['SessionStart'][0]['hooks'])); [print(' -', h['command']) for h in d['hooks']['SessionStart'][0]['hooks']]"
```

Expected:
```
hooks count: 2
 - "${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd" session-start
 - "${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd" xspec-session-start
```

- [ ] **Step 3: 验证重命名后的 hook 脚本都存在且可执行**

```bash
test -x hooks/session-start && echo "session-start: OK" || echo "session-start: MISSING"
test -x hooks/xspec-session-start && echo "xspec-session-start: OK" || echo "xspec-session-start: MISSING"
test ! -f hooks/session-start.sh && echo "old session-start.sh: removed" || echo "old session-start.sh: STILL EXISTS"
test ! -f hooks/xspec-session-start.sh && echo "old xspec-session-start.sh: removed" || echo "old xspec-session-start.sh: STILL EXISTS"
```

- [ ] **Step 4: 验证 reviewer prompt 文件都存在**

```bash
test -f skills/brainstorming/design-document-reviewer-prompt.md && echo "spec reviewer: OK"
test -f skills/writing-plans/plan-document-reviewer-prompt.md && echo "plan reviewer: OK"
test -f skills/prd-clarifying/requirements-document-reviewer-prompt.md && echo "requirements reviewer: OK"
```
