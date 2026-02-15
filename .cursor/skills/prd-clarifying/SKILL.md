---
name: prd-clarifying
description: Use when receiving a PRD (Product Requirements Document) to conduct requirements-level brainstorming, uncover issues, and produce a structured requirements.md
---

# PRD Requirement Clarification

## Overview

Entry point of the product-engineering workflow. Receive PRD input, conduct requirements-level brainstorming to deeply uncover issues in the PRD, and clarify with the user one by one. Produce a structured `requirements.md`.

**Core principle:** Requirements-level brainstorming — systematically probe every dimension of a PRD before any design work begins.

**Announce at start:** "I'm using the prd-clarifying skill to analyze and clarify this PRD."

**REQUIRED BACKGROUND:** You MUST understand superpowers:brainstorming before using this skill. That skill defines the dialogue patterns (one question at a time, prefer multiple-choice, incremental validation) this skill reuses.

<HARD-GATE>
Do NOT proceed to any design skill, write any design document, or take any implementation action until ALL requirement clarifications are complete and the user has confirmed the final requirements.md. This applies to EVERY PRD regardless of perceived completeness.
</HARD-GATE>

## Checklist

You MUST create a task for each of these items and complete them in order:

1. **Receive PRD** — paste content or read file path
2. **Extract requirement ID** — match Feishu link or ask user
3. **Determine topic** — short English name
4. **Create specs directory** — `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`
5. **Requirements brainstorming** — one question at a time through checklist
6. **Generate requirements.md** — structured output
7. **User confirms** — get explicit approval
8. **Prompt next step** — /generate-hld or /generate-design

## PRD Input

The user may provide the PRD in two ways:
- **Pasted content:** PRD text directly in the chat message
- **File path:** A path to a local file (e.g., `./docs/prd/feature-x.md`)

Auto-detect: if the input looks like a file path (contains `/` or `\` and ends with a document extension), read the file. Otherwise, treat as pasted content.

## Requirement ID Extraction

1. Scan PRD content for pattern: `https://project.feishu.cn/.*/detail/(\d+)`
2. Extract the trailing digits as requirement ID
3. If no match found, ask user: "I couldn't find a requirement ID in the PRD. Please provide one (e.g., 12345)."

## Requirements Brainstorming Checklist

Use brainstorming dialogue patterns: **one question at a time, prefer multiple-choice, wait for answer before next question.**

| Dimension | What to Probe |
|-----------|---------------|
| **Functional boundary** | Scope clarity? What is explicitly out of scope? |
| **Exception flows** | Failure, timeout, concurrency conflict handling? |
| **Data boundary** | Data volume, historical migration, lifecycle, retention? |
| **Permissions & security** | Who can operate? Role-based access? Audit trail? |
| **Compatibility** | Impact on existing features? Backward compatibility? Grayscale? |
| **Non-functional requirements** | Performance targets, SLA, observability, monitoring? |
| **Implicit assumptions** | Unstated assumptions that implementation must resolve? |
| **Priority** | MVP-required vs. deferrable? Phase breakdown? |
| **Acceptance criteria** | How to determine the requirement is complete? |

For each dimension:
1. Analyze the PRD for existing coverage
2. If covered adequately, skip (don't ask unnecessary questions)
3. If gaps exist, formulate a specific question
4. Present as multiple-choice when possible

## Output: requirements.md

Use `requirements-template.md` in this skill's directory for the output structure. Output content in Chinese, technical terms in English.

Write to `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/requirements.md`.

## After Confirmation

Prompt user for next step:
- **Complex multi-service requirement:** "This requirement involves multiple services. Recommend running `/generate-hld` next for high-level design."
- **Single-service requirement:** "This requirement targets a single service. Recommend running `/generate-design` next for detailed design."

## Integration

**REQUIRED BACKGROUND:** superpowers:brainstorming (dialogue patterns)
**Next steps:** superpowers:generating-hld OR superpowers:generating-design
