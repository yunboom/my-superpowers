---
name: prd-clarifying
description: Use when receiving a PRD (Product Requirements Document) to conduct requirements-level brainstorming, uncover issues, and produce a structured requirements.md
---

# PRD Requirement Clarification

## Overview

Entry point of the product-engineering workflow. Receive PRD input, conduct requirements-level brainstorming to deeply uncover issues in the PRD, and clarify with the user one by one. Produce a structured `requirements.md`.

**Core principle:** Business-level brainstorming — focus ONLY on business requirements, user scenarios, and product logic. All technical concerns (architecture, storage, protocols, error handling strategies, performance optimization) belong to the `/generate-design` phase.

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
7. **Requirements Review Loop** — dispatch reviewer subagent to review requirements.md, fix issues up to 5 rounds
8. **User Review Gate** — present requirements.md to user for confirmation
9. **Prompt next step** — /generate-hld or /generate-design

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

<HARD-GATE>
This phase is STRICTLY business-level. Do NOT ask about:
- Implementation approach (e.g., "should we use ES or DB?", "sync or async?")
- Error handling strategy (e.g., "what if the service call fails?")
- Performance/capacity design (e.g., "what QPS do we need?")
- Data storage choices (e.g., "MySQL or MongoDB?")
- Cross-service call patterns (e.g., "query by ID list or join?")
- Any question that a product manager cannot answer

If you catch yourself asking a technical question, STOP — defer it to `/generate-design`.
</HARD-GATE>

| Dimension | What to Probe |
|-----------|---------------|
| **Functional boundary** | What features are in scope? What is explicitly out of scope? |
| **User scenarios** | Who are the users? What are the key user journeys? |
| **Business rules** | What business logic governs this feature? Edge cases in business flow? |
| **Business exception flows** | What happens from the USER's perspective when something goes wrong? (NOT technical failure handling) |
| **Permissions & roles** | Which user roles can access this feature? Any restrictions? |
| **Data scope** | What business data is involved? Any historical data to consider? |
| **Compatibility** | Impact on existing user-facing features? Migration for existing users? |
| **Implicit assumptions** | Unstated business assumptions in the PRD? |
| **Acceptance criteria** | How does the product owner verify this is done? |

For each dimension:
1. Analyze the PRD for existing coverage
2. If covered adequately, skip (don't ask unnecessary questions)
3. If gaps exist, formulate a specific question
4. Present as multiple-choice when possible
5. **Always include a "defer to later" option** — if the user cannot answer now, record it as a TODO item and append to the end of requirements.md

**Examples of GOOD questions (business-level):**
- "The PRD mentions searching by customer name — should this be exact match or fuzzy match from the user's perspective?"
- "When a trade order is searched by customer name but the customer is deleted, should the order still appear in results?"
- "Which user roles have access to the watermark search feature?"

**Examples of BAD questions (technical — defer to /generate-design):**
- "Should we use Elasticsearch or database LIKE query for fuzzy search?"
- "When the customer service is unavailable, should we return an error or fall back to cached data?"
- "What's the maximum number of IDs to pass in a cross-service query?"

## Output: requirements.md

Use `requirements-template.md` in this skill's directory for the output structure. Output content in Chinese, technical terms in English.

Write to `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/requirements.md`.

## Requirements Review Loop

After generating `requirements.md`, dispatch a **reviewer subagent** to audit the document for completeness and consistency.

1. Use the review prompt template at `skills/prd-clarifying/requirements-document-reviewer-prompt.md`
2. The reviewer subagent checks for: missing dimensions, contradictions, vague acceptance criteria, and gaps between PRD and requirements
3. If the reviewer reports issues, fix them in `requirements.md` and re-run the reviewer
4. **Maximum 5 rounds** — if issues persist after 5 review-fix cycles, stop the loop and escalate to the user with a summary of unresolved issues
5. The loop exits when the reviewer returns no issues (clean pass)

## User Review Gate

After the review loop passes (or escalates), present `requirements.md` to the user for final confirmation.

1. Show a summary of what was clarified and any remaining TODOs
2. If issues were escalated from the review loop, highlight them explicitly
3. Ask the user: "Please review the requirements document. Reply **confirmed** to proceed, or point out anything that needs adjustment."
4. If the user requests changes, apply them, then re-enter the Requirements Review Loop
5. **Do NOT prompt the next step until the user explicitly confirms**

## After Confirmation

Prompt user for next step:
- **Complex multi-service requirement:** "This requirement involves multiple services. Recommend running `/generate-hld` next for high-level design."
- **Single-service requirement:** "This requirement targets a single service. Recommend running `/generate-design` next for detailed design."

## Integration

**REQUIRED BACKGROUND:** superpowers:brainstorming (dialogue patterns)
**Next steps:** superpowers:generating-hld OR superpowers:generating-design
