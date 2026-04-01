---
name: 使用超能力
description: 在开始任何对话时使用——确定如何查找和使用 skill，要求在任何回复（包括澄清问题）之前调用 Skill 工具
---

<SUBAGENT-STOP>
如果你作为子代理被分派执行特定任务，请跳过此 skill。
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
如果你认为某个 skill 哪怕只有 1% 的可能性适用于你正在做的事情，你绝对必须调用该 skill。

如果一个 skill 适用于你的任务，你没有选择。你必须使用它。

这不可商量。这不是可选的。你不能为此找理由。
</EXTREMELY-IMPORTANT>

## 指令优先级

Superpowers skill 会覆盖默认系统提示的行为，但**用户指令始终具有最高优先级**：

1. **用户的明确指令**（CLAUDE.md、GEMINI.md、AGENTS.md、直接请求）——最高优先级
2. **Superpowers skill** ——在冲突时覆盖默认系统行为
3. **默认系统提示** ——最低优先级

如果 CLAUDE.md、GEMINI.md 或 AGENTS.md 说"不要使用 TDD"，而某个 skill 说"始终使用 TDD"，请遵循用户的指令。用户拥有控制权。

## 如何访问 Skill

**在 Claude Code 中：** 使用 `Skill` 工具。当你调用一个 skill 时，它的内容会被加载并呈现给你——直接遵循它。不要使用 Read 工具读取 skill 文件。

**在 Copilot CLI 中：** 使用 `skill` 工具。Skill 从已安装的插件中自动发现。`skill` 工具的用法与 Claude Code 的 `Skill` 工具相同。

**在 Gemini CLI 中：** Skill 通过 `activate_skill` 工具激活。Gemini 在会话启动时加载 skill 元数据，并按需激活完整内容。

**在其他环境中：** 查看你的平台文档了解 skill 是如何加载的。

## 平台适配

Skill 使用 Claude Code 的工具名称。非 CC 平台：参见 `references/copilot-tools.md`（Copilot CLI）、`references/codex-tools.md`（Codex）了解工具等价物。Gemini CLI 用户通过 GEMINI.md 自动加载工具映射。

# 使用 Skill

## 规则

**在任何回复或操作之前，先调用相关或被请求的 skill。** 即使只有 1% 的可能性某个 skill 适用，你也应该调用该 skill 来检查。如果调用后发现该 skill 不适合当前情况，你不需要使用它。

```dot
digraph skill_flow {
    "User message received" [shape=doublecircle];
    "About to EnterPlanMode?" [shape=doublecircle];
    "Already brainstormed?" [shape=diamond];
    "Invoke brainstorming skill" [shape=box];
    "Might any skill apply?" [shape=diamond];
    "Invoke Skill tool" [shape=box];
    "Announce: 'Using [skill] to [purpose]'" [shape=box];
    "Has checklist?" [shape=diamond];
    "Create TodoWrite todo per item" [shape=box];
    "Follow skill exactly" [shape=box];
    "Respond (including clarifications)" [shape=doublecircle];

    "About to EnterPlanMode?" -> "Already brainstormed?";
    "Already brainstormed?" -> "Invoke brainstorming skill" [label="no"];
    "Already brainstormed?" -> "Might any skill apply?" [label="yes"];
    "Invoke brainstorming skill" -> "Might any skill apply?";

    "User message received" -> "Might any skill apply?";
    "Might any skill apply?" -> "Invoke Skill tool" [label="yes, even 1%"];
    "Might any skill apply?" -> "Respond (including clarifications)" [label="definitely not"];
    "Invoke Skill tool" -> "Announce: 'Using [skill] to [purpose]'";
    "Announce: 'Using [skill] to [purpose]'" -> "Has checklist?";
    "Has checklist?" -> "Create TodoWrite todo per item" [label="yes"];
    "Has checklist?" -> "Follow skill exactly" [label="no"];
    "Create TodoWrite todo per item" -> "Follow skill exactly";
}
```

## 危险信号

以下想法意味着停下——你在自我合理化：

| 想法 | 现实 |
|------|------|
| "这只是一个简单的问题" | 问题也是任务。检查 skill。 |
| "我需要先了解更多上下文" | Skill 检查在澄清问题之前进行。 |
| "让我先探索一下代码库" | Skill 告诉你如何探索。先检查。 |
| "我可以快速查看一下 git/文件" | 文件缺少对话上下文。检查 skill。 |
| "让我先收集一些信息" | Skill 告诉你如何收集信息。 |
| "这不需要正式的 skill" | 如果 skill 存在，就使用它。 |
| "我记得这个 skill" | Skill 会演化。读取当前版本。 |
| "这不算一个任务" | 操作 = 任务。检查 skill。 |
| "这个 skill 小题大做了" | 简单的事情会变复杂。使用它。 |
| "我先做这一件事" | 做任何事之前先检查。 |
| "这感觉很有效率" | 缺乏纪律的操作浪费时间。Skill 防止这种情况。 |
| "我知道那是什么意思" | 知道概念 ≠ 使用 skill。调用它。 |

## Skill 优先级

当多个 skill 可能适用时，使用以下顺序：

1. **先使用流程类 skill**（brainstorming、debugging）- 这些决定如何处理任务
2. **再使用实现类 skill**（frontend-design、mcp-builder）- 这些指导执行

"让我们构建 X" → 先 brainstorming，再使用实现类 skill。
"修复这个 bug" → 先 debugging，再使用领域相关 skill。

## Skill 类型

**严格型**（TDD、debugging）：严格遵循。不要因为"灵活"而降低纪律。

**灵活型**（模式类）：根据上下文调整原则。

Skill 本身会告诉你它属于哪种类型。

## 用户指令

指令说的是做什么，而不是怎么做。"添加 X"或"修复 Y"不意味着跳过工作流。
