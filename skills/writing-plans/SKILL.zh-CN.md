---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# 编写计划

## 概述

编写全面的实现计划，假设工程师对我们的代码库完全不了解，而且品味存疑。记录他们需要知道的一切：每个任务需要修改哪些文件、代码、测试、可能需要查看的文档、如何测试。将整个计划分成小粒度的任务。DRY。YAGNI。TDD。频繁提交。

假设他们是熟练的开发者，但对我们的工具集和问题领域几乎一无所知。假设他们不太擅长良好的测试设计。

**开始时宣布：** "I'm using the writing-plans skill to create the implementation plan."

**上下文：** 这应该在专用的 worktree 中运行（由 brainstorming skill 创建）。

**计划保存到：** `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/plan.md`

## 确定 Specs 路径并加载上下文

1. 确定 specs 目录路径 `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`：
   - 如果在同一会话中由 `/generate-design` 之后调用，路径已知
   - 如果未知，扫描 `docs/specs/` 并选取日期最近的 `yyyy-MM-dd-REQ-*` 目录，展示给用户确认
   - 如果不存在 specs 目录，提示："未找到 specs 目录，请先执行 `/prd-clarify` 创建需求文档。"
2. 加载上下文文件（只有前序步骤**显式读取（Read）过文件**才算"已在上下文中"——**写入/生成（Write）文件不算**）：
   - `requirements.md` —— 如果同一会话中前序步骤（如 `/generate-hld` 或 `/generate-design`）已**读取**过此文件，可跳过。否则**强制读取** `{specs_path}/requirements.md`。
   - `design.md` —— 如果同一会话中前序步骤已**读取**过此文件，可跳过。否则**强制读取** `{specs_path}/design.md`。

使用这些作为计划生成的主要输入。

## 小粒度任务拆分

**每一步是一个动作（2-5 分钟）：**
- "编写失败的测试" - 一步
- "运行它以确保它失败" - 一步
- "实现使测试通过的最少代码" - 一步
- "运行测试并确保它们通过" - 一步
- "提交" - 一步

## 计划文档头

**每个计划必须以此头部开始：**

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**REQ:** REQ-{id}
**Specs:** `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`
**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## 任务结构

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test**

```python
# REQ-{id} test for specific behavior
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**

```python
# REQ-{id} implement specific behavior
def function(input):
    return expected
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

**Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "REQ-{id} feat: add specific feature"
```
````

## 代码注释规范

计划中的所有代码注释必须携带 `REQ-{id}`：
- `// REQ-{id} validate order amount before submission`
- `# REQ-{id} retry logic for external service calls`
- `/* REQ-{id} migration: add column to orders table */`

## 提交信息规范

所有提交信息必须以 `REQ-{id}` 为前缀：
- `REQ-{id} feat: add order validation endpoint`
- `REQ-{id} test: add integration tests for order flow`
- `REQ-{id} fix: handle null amount in validation`

## 生成 testing.md

生成 `plan.md` 后，还需在同一 specs 目录中生成 `testing.md`。

**testing.md 要求：**
- 详细的端到端测试用例
- 覆盖：正常流程、异常流程、边界条件、并发场景
- 每个测试用例包含：前置条件、操作步骤、预期结果
- 一旦生成，testing.md 在后续工作流步骤中不得修改

**testing.md 格式：**

```markdown
# End-to-End Test Cases

> REQ-{id} | Generated alongside plan.md
> ⚠️ This file MUST NOT be modified during execution. If issues are found, stop and report to user.

## TC-1: {Test Case Title}
**Preconditions:**
- {precondition 1}

**Steps:**
1. {step 1}
2. {step 2}

**Expected Result:**
- {expected outcome}

## TC-2: {Test Case Title}
...
```

## 注意事项
- 始终使用精确的文件路径
- 计划中提供完整代码（而不是"添加验证"这样的描述）
- 精确的命令及预期输出
- 所有代码注释携带 REQ-{id}
- 所有提交信息以 REQ-{id} 为前缀
- 使用 @ 语法引用相关 skill
- DRY、YAGNI、TDD、频繁提交
- 与 plan.md 一起生成 testing.md

## 执行交接

保存计划和 testing.md 后，提供执行选择：

**"计划已完成并保存到 `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/plan.md`。testing.md 也已生成。两种执行选项：**

**1. Sub-agent 驱动（当前会话）** - 我为每个任务分派新的 sub-agent，任务之间进行审查，快速迭代

**2. 并行会话（单独开启）** - 在新会话中使用 executing-plans，带检查点的批量执行

**选择哪种方式？"**

**如果选择 Sub-agent 驱动：**
- **必需子技能：** 使用 superpowers:subagent-driven-development
- 留在当前会话
- 每个任务启动新的 sub-agent + 代码审查

**如果选择并行会话：**
- 引导他们在 worktree 中打开新会话
- **必需子技能：** 新会话使用 superpowers:executing-plans
