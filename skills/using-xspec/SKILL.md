---
name: using-xspec
description: Use when starting any conversation in a project that follows the xSpec product-engineering workflow - establishes how to use the PRD-driven workflow, requiring correct skill invocation before ANY response including clarifying questions
---

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance an xSpec skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF AN XSPEC SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. This is not optional. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

## How to Access Skills

**In Claude Code:** Use the `Skill` tool. When you invoke a skill, its content is loaded and presented to you—follow it directly. Never use the Read tool on skill files.

**In other environments:** Check your platform's documentation for how skills are loaded.

# Using xSpec Skills

## The Rule

**Invoke relevant or requested xSpec skills BEFORE any response or action.** Even a 1% chance a skill might apply means that you should invoke the skill to check. If an invoked skill turns out to be wrong for the situation, you don't need to use it.

```dot
digraph xspec_flow {
    "User message received" [shape=doublecircle];
    "Has PRD or REQ-id or Feishu link?" [shape=diamond];
    "Already clarified requirements?" [shape=diamond];
    "Invoke prd-clarifying skill" [shape=box];
    "Might any xSpec skill apply?" [shape=diamond];
    "Invoke Skill tool" [shape=box];
    "Announce: 'Using [skill] to [purpose]'" [shape=box];
    "Has checklist?" [shape=diamond];
    "Create TodoWrite todo per item" [shape=box];
    "Follow skill exactly" [shape=box];
    "Respond (including clarifications)" [shape=doublecircle];

    "User message received" -> "Has PRD or REQ-id or Feishu link?";
    "Has PRD or REQ-id or Feishu link?" -> "Already clarified requirements?" [label="yes"];
    "Has PRD or REQ-id or Feishu link?" -> "Might any xSpec skill apply?" [label="no"];
    "Already clarified requirements?" -> "Invoke prd-clarifying skill" [label="no"];
    "Already clarified requirements?" -> "Might any xSpec skill apply?" [label="yes"];
    "Invoke prd-clarifying skill" -> "Might any xSpec skill apply?";

    "Might any xSpec skill apply?" -> "Invoke Skill tool" [label="yes, even 1%"];
    "Might any xSpec skill apply?" -> "Respond (including clarifications)" [label="definitely not"];
    "Invoke Skill tool" -> "Announce: 'Using [skill] to [purpose]'";
    "Announce: 'Using [skill] to [purpose]'" -> "Has checklist?";
    "Has checklist?" -> "Create TodoWrite todo per item" [label="yes"];
    "Has checklist?" -> "Follow skill exactly" [label="no"];
    "Create TodoWrite todo per item" -> "Follow skill exactly";
}
```

## Red Flags

These thoughts mean STOP—you're rationalizing:

| Thought | Reality |
|---------|---------|
| "Let me just start coding" | Follow the workflow. /prd-clarify first if PRD exists. |
| "The PRD is clear enough" | Business assumptions hide in every PRD. Clarify first. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "I know the best tech approach" | Research latest practices. Don't rely on training data. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I'll test manually later" | testing.md is generated upfront and runs automatically. |
| "This testing.md case is wrong" | Do NOT modify it. Stop and report to user. |
| "The external DB is probably fine" | Check localhost. Non-local = ask user first. |
| "This doesn't need the full workflow" | If a PRD or REQ-id exists, use the workflow. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I remember this skill" | Skills evolve. Read current version. |

## Skill Priority

When multiple xSpec skills could apply, use this order:

1. **Workflow skills first** (prd-clarifying, generating-hld, generating-design) — these determine WHAT to build
2. **Planning skills second** (writing-plans) — these determine HOW to build
3. **Execution skills third** (executing-plans) — these carry out the plan

"Here's a PRD" → /prd-clarify first, then design, then plan.
"Design is ready" → /write-plan first, then execute.

## Skill Types

**Rigid** (prd-clarifying, executing-plans): Follow exactly. Don't adapt away discipline.

**Flexible** (generating-design, deep-researching): Adapt research and brainstorming to context.

The skill itself tells you which.

## User Instructions

Instructions say WHAT, not HOW. "Implement this PRD" or "Design this feature" doesn't mean skip workflows.

## xSpec Conventions

- **Commit messages:** Prefix with `REQ-{id}` (e.g., `REQ-12345 feat: add order validation`)
- **Code comments:** ALL comments carry `// REQ-{id} {description}`
- **Requirement ID:** Extract from `https://project.feishu.cn/.*/detail/(\d+)`, or ask user
- **Specs directory:** `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`

## xSpec Workflow

```
/prd-clarify → /generate-hld (optional) → /generate-design → /write-plan → /execute-plan
```

| Command | Skill | Output |
|---------|-------|--------|
| `/prd-clarify` | `prd-clarifying` | `requirements.md` |
| `/generate-hld` | `generating-hld` | `hld.md` |
| `/generate-design` | `generating-design` | `design.md` |
| `/write-plan` | `writing-plans` | `plan.md` + `testing.md` |
| `/execute-plan` | `executing-plans` | Implementation + test verification |
