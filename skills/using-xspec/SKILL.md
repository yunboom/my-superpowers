---
name: using-xspec
description: Use when starting any conversation in a project that follows the xSpec product-engineering workflow - establishes how to use the PRD-driven workflow and its skills
---

<EXTREMELY-IMPORTANT>
If you are working on a requirement that has a PRD or exists under `docs/specs/`, you MUST follow the xSpec workflow.

This is not negotiable. This is not optional. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

# Using xSpec

## What is xSpec

xSpec is a PRD-driven product-engineering workflow that extends superpowers. It takes a PRD as input, clarifies requirements, produces designs, generates implementation plans with test cases, and executes them.

## Two Parallel Workflows

```
Workflow A (free-form ideas):
  /brainstorm → /write-plan → /execute-plan

Workflow B (PRD-driven / xSpec):
  /prd-clarify → /generate-hld (optional) → /generate-design → /write-plan → /execute-plan
```

**When to use xSpec (Workflow B):** The user has a PRD, a requirement ID, or references a Feishu link.

**When to use Workflow A:** The user has a free-form idea without a formal PRD.

## xSpec Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/prd-clarify` | Clarify PRD requirements (business-level only) | Starting a new requirement from PRD |
| `/generate-hld` | High-level design for multi-service requirements | Complex requirements involving multiple microservices |
| `/generate-design` | Detailed technical design with deep research | Before implementation, after requirements are clear |
| `/write-plan` | Generate implementation plan + testing.md | After design is complete |
| `/execute-plan` | Execute plan with safety checks | After plan is ready |

## Specs Directory

All artifacts are stored under `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`:

| File | Produced By |
|------|------------|
| `requirements.md` | `/prd-clarify` |
| `hld.md` | `/generate-hld` (optional) |
| `design.md` | `/generate-design` |
| `plan.md` | `/write-plan` |
| `testing.md` | `/write-plan` (alongside plan.md) |

## Conventions

- **Commit messages:** Prefix with `REQ-{id}`
- **Code comments:** ALL comments carry `// REQ-{id} {description}`
- **Requirement ID:** Extract from `https://project.feishu.cn/.*/detail/(\d+)`, or ask user

## Key Rules

1. **prd-clarify is business-only** — no technical questions. Technical concerns belong to /generate-design.
2. **Deep research before brainstorming** — in /generate-design, research happens FIRST, then informed brainstorming with evidence.
3. **testing.md is immutable** — once generated, NEVER modify it during execution. Report issues to user instead.
4. **Safety check before tests** — verify all external dependency connections are localhost before running tests.
5. **Plan ends with integration tests** — the last task in every plan MUST run all testing.md cases.

## Skill Priority for xSpec

When a user message involves a PRD or requirement:

1. **Check if `/prd-clarify` is needed** — new PRD not yet clarified
2. **Check if `/generate-hld` is needed** — complex multi-service requirement
3. **Check if `/generate-design` is needed** — requirements clarified, no design yet
4. **Check if `/write-plan` is needed** — design done, no plan yet
5. **Check if `/execute-plan` is needed** — plan ready, not yet executed

## Red Flags

| Thought | Reality |
|---------|---------|
| "Let me just start coding" | Follow the workflow. /prd-clarify first if PRD exists. |
| "The PRD is clear enough" | Business assumptions hide in every PRD. Clarify first. |
| "I know the best tech approach" | Research latest practices. Don't rely on training data. |
| "I'll test manually later" | testing.md is generated upfront and runs automatically. |
| "This testing.md case is wrong" | Do NOT modify it. Stop and report to user. |
| "The external DB is probably fine" | Check localhost. Non-local = ask user first. |
