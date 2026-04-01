---
name: writing-plans
description: Use when you have a design or requirements for a multi-step task, before touching code
---

# 编写计划

## 概述

编写全面的实现计划，假设工程师对我们的代码库完全不了解，而且品味存疑。记录他们需要知道的一切：每个任务需要修改哪些文件、代码、测试、可能需要查看的文档、如何测试。将整个计划分成小粒度的任务。DRY。YAGNI。TDD。频繁提交。

假设他们是熟练的开发者，但对我们的工具集和问题领域几乎一无所知。假设他们不太擅长良好的测试设计。

**开始时宣布：** "I'm using the writing-plans skill to create the implementation plan."

**上下文：** 这应该在专用的 worktree 中运行（由 brainstorming skill 创建，或在启动 PRD 工作流之前手动设置）。

**计划保存到：** `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/plan.md`

## 步骤 0：确定 Specs 路径

确定目标 specs 目录 `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`：

1. **如果当前对话中已明确知道路径**（例如，同一会话中前序的 `/generate-design` 步骤使用了特定的 specs 目录） → 直接使用，无需确认。
2. **如果路径未知**，扫描 `docs/specs/` 下所有 `yyyy-MM-dd-REQ-*/{topic}` 目录：
   - 如果不存在 → 提示："未找到 specs 目录，请先执行 `/prd-clarify` 创建需求文档。"并停止。
   - 如果只有一个 → 直接使用，无需确认。
   - 如果有多个 → 以编号列表形式展示所有目录，等待用户选择后才能继续。

## 上下文加载

从确定的 specs 路径中精确读取以下 2 个文件，不得读取其他文件（如不得读取 hld.md）。

1. `{specs_path}/requirements.md`
2. `{specs_path}/design.md`

如果某个文件在同一会话中已由前序步骤加载过，可跳过该文件的读取。使用这 2 个文件作为计划生成的主要输入。

## 加载规范 Skills（std）

扫描可用的 skills 列表，查找名称中包含 `std` 的 skill（如 `code-std`、`db-std`、`error-handling-std`）。这些是各类规范/标准 skill，涵盖代码编写规范、数据库规范、错误处理规范等。根据当前任务上下文选择性加载，确保生成的计划遵循相应规范。

## 范围检查

如果设计涵盖了多个独立子系统，应该在 brainstorming 阶段就将其拆分为子项目设计。如果当时未拆分，建议拆分为独立的计划——每个子系统一个计划。每个计划应能独立产出可工作、可测试的软件。

## 文件结构

在定义任务之前，先梳理出需要创建或修改的文件及其各自的职责。分解决策在这一步锁定。

- 设计具有清晰边界和明确接口的单元。每个文件应有一个清晰的职责。
- 你在能一次性放入上下文的代码上推理效果最好，文件越聚焦编辑就越可靠。优先选择小而聚焦的文件，而非过大且职责混杂的文件。
- 一起变更的文件应放在一起。按职责拆分，而非按技术层级拆分。
- 在已有代码库中，遵循已有的模式。如果代码库惯用大文件，不要单方面重构——但如果你正在修改的文件确实臃肿，在计划中包含拆分是合理的。

此文件结构将指导任务分解。每个任务应产出独立且有意义的自包含变更。

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

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

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

- [ ] **Step 1: Write the failing test**

```python
# REQ-{id} test for specific behavior
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
# REQ-{id} implement specific behavior
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "REQ-{id} feat: add specific feature"
```
````

**每个计划的最后一个任务必须是："运行 testing.md 中的所有集成测试用例"。**

````markdown
### Task N（最终）：运行 testing.md 集成测试

- [ ] **步骤 1：逐一执行 testing.md 中的所有测试用例**

运行 `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/testing.md` 中的每个测试用例。
记录每个用例的 PASS/FAIL 结果。

- [ ] **步骤 2：修复失败项**

如果测试用例因代码问题失败，修复并重新运行。
如果测试用例本身有问题，停止并向用户反馈。
不得修改 testing.md。

- [ ] **步骤 3：确认全部通过**

所有测试用例必须通过后才能标记计划完成。
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

**根据 design.md 中的技术栈判断项目类型**，使用对应的模式生成 testing.md：

### 通用要求（所有项目类型）

- 详细的端到端测试用例
- 覆盖：正常流程、异常流程、边界条件、并发场景
- 每个测试用例包含：类型、前置条件、操作步骤、清理步骤、预期结果
- 所有测试步骤必须可直接执行——不允许"调用接口"或"验证结果"等占位描述
- 一旦生成，testing.md 在后续工作流步骤中不得修改

### 后端项目

- **API 测试用例必须包含完整的 curl 命令**（含 URL、方法、请求头、请求体），可直接复制执行
- **脚本验证必须包含完整脚本**（含完整代码、执行命令、预期输出）
- **环境准备：** 中间件启动命令（Docker Compose、本地安装或云端点）、healthcheck 就绪确认、数据初始化脚本
- **数据管理：** 每个测试用例包含清理/还原步骤；用例间数据相互隔离

### 前端项目

- **浏览器测试用例使用 Playwright 测试脚本**，采用 Page Object Model（POM）模式和 `data-testid` 定位器
- **稳定性：** 使用条件等待（`waitForResponse`、`waitForSelector`、元素可见性）——绝不使用固定等待（`waitForTimeout`、`sleep`）
- **环境准备：** dev server 启动命令、mock API / 数据 stub 配置、浏览器环境要求
- **视觉验证：** 关键 UI 状态的截图断言（如适用）

### 全栈/集成项目

- 结合后端 API 测试和前端浏览器测试
- **环境准备：** 完整的服务依赖链及启动顺序和 healthcheck 就绪确认（如 DB → API → 前端 → E2E runner）
- **集成流程：** 浏览器操作 → 验证 API 响应 → 验证 DB 状态

### testing.md 格式

```markdown
# End-to-End Test Cases

> REQ-{id} | Generated alongside plan.md
> ⚠️ This file MUST NOT be modified during execution. If issues are found, stop and report to user.

## Test Environment Setup

### Prerequisites
- {运行时依赖：Node.js、Docker、数据库客户端等}

### Start Services
\`\`\`bash
{适合项目类型的启动命令}
\`\`\`

### Verify Readiness
\`\`\`bash
{healthcheck 或可访问性验证命令}
\`\`\`

### Test Data Initialization
\`\`\`bash
{种子脚本、SQL 导入、mock 数据配置等}
\`\`\`

## TC-1: {Test Case Title}
**Type:** API | Browser | Integration
**Preconditions:**
- {precondition 1}

**Steps:**

{与 Type 匹配的步骤格式——API 用 curl，Browser 用 Playwright，Integration 混合使用}

**Teardown:**
\`\`\`bash
{该测试用例的数据清理命令}
\`\`\`

**Expected Result:**
- {包含具体可验证数值的预期结果}

## TC-2: {Test Case Title}
...
```

## 禁止占位符

每一步都必须包含工程师所需的实际内容。以下是**计划缺陷**——绝不要写出：
- "TBD"、"TODO"、"稍后实现"、"补充细节"
- "添加适当的错误处理" / "添加验证" / "处理边界情况"
- "为上述内容编写测试"（没有实际测试代码）
- "类似于 Task N"（要重复代码——工程师可能不按顺序阅读任务）
- 只描述做什么但不展示如何做的步骤（代码步骤必须有代码块）
- 引用了未在任何任务中定义的类型、函数或方法

## 注意事项
- 始终使用精确的文件路径
- 每一步都提供完整代码——如果某步修改了代码，就展示代码
- 精确的命令及预期输出
- 所有代码注释携带 REQ-{id}
- 所有提交信息以 REQ-{id} 为前缀
- DRY、YAGNI、TDD、频繁提交
- 与 plan.md 一起生成 testing.md

## 自审

编写完完整计划后，以全新的视角审视设计文档，对照检查计划。这是你自己运行的清单——不是分派子代理。

**1. 设计覆盖度：** 浏览设计文档中的每个章节/需求。你能指出实现它的任务吗？列出所有缺口。

**2. 占位符扫描：** 搜索计划中的危险信号——上述"禁止占位符"章节中的任何模式。修复它们。

**3. 类型一致性：** 你在后续任务中使用的类型、方法签名和属性名是否与早期任务中定义的一致？Task 3 中叫 `clearLayers()` 但 Task 7 中叫 `clearFullLayers()` 就是 bug。

如果发现问题，直接内联修复。无需重新审查——修复后继续。如果发现设计需求没有对应任务，添加该任务。

## 测试自审

生成 testing.md 后，以全新的视角审视它。这是你自己运行的检查清单——不是分派子代理。

**1. 需求覆盖度：** 对照 design.md 逐项检查——每个功能点是否都有至少一个测试用例？是否有未测试的功能？

**2. 场景完整性：** 正常流程、错误/异常流程、边界条件和并发场景是否都已覆盖？

**3. 可执行性：** 每个测试步骤是否都可以直接执行？没有"调用 API"、"验证结果"、"检查数据库"之类的占位符——每一步都需要实际的命令或断言。

**4. 环境搭建：** 测试环境搭建是否完整？后端：中间件启动（Docker Compose）、数据初始化脚本、健康检查。前端：开发服务器命令、Mock API/数据桩。全栈：服务依赖链、启动顺序。

**5. 数据管理：** 测试数据的创建和清理策略是否明确？测试用例之间的数据是否隔离？

**6. 预期结果：** 预期结果是否具体且可验证（而非主观描述如"应该很快"）？是否包含状态码、返回值、数据库状态或 UI 元素断言？

**7. 测试独立性：** 测试用例之间是否相互独立？是否存在隐含的执行顺序依赖？

**8. 稳定性：** 是否存在不稳定风险？测试是否依赖固定等待（sleep/waitForTimeout）而非条件等待（waitForResponse、健康检查、元素可见性）？

**9. 类型一致性：** 每个测试用例声明的类型（API / Browser / Integration）是否与其实际步骤格式匹配？

**10. 完整性：** 是否存在 TODO 标记、占位符或未完成的测试用例？

如果发现问题，直接内联修复。无需重新审查——修复后继续。

## 执行交接

保存计划和 testing.md 后（两个审查循环均已通过），提供执行选择：

**"计划已完成并保存到 `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/plan.md`。testing.md 也已生成。两种执行方式：**

**1. Subagent 驱动（推荐）** - 每个任务分派新的 subagent，任务间审查，快速迭代

**2. 内联执行** - 在当前会话中使用 executing-plans 执行任务，带检查点的批量执行

**选择哪种方式？"**

**如果选择 Subagent 驱动：**
- **必需子技能：** 使用 superpowers:subagent-driven-development
- 每个任务分派新的 subagent + 两阶段审查

**如果选择内联执行：**
- **必需子技能：** 使用 superpowers:executing-plans
- 带检查点的批量执行
