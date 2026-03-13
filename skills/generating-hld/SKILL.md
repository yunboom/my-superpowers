---
name: generating-hld
description: Use when a complex requirement involves multiple microservices and you need to define service responsibilities, interfaces, events, and dependency relationships from a top-level perspective
---

# High-Level Design Generation

## Overview

For complex multi-microservice requirements, generate a high-level design that defines service responsibilities, external capabilities (interfaces/events), and inter-service dependencies.

**Core principle:** System-aware HLD — use automated architecture discovery to understand the current system, then design changes within that context.

**Announce at start:** "I'm using the generating-hld skill to create the high-level design."

## The Process

### Step 1: Resolve Specs Path

Determine the target specs directory `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`:

1. **If the path is already known from the current conversation** (e.g., a prior `/prd-clarify` step in this session used or created a specific specs directory) → use it directly, no confirmation needed.
2. **If the path is NOT known**, scan `docs/specs/` for all `yyyy-MM-dd-REQ-*/{topic}` directories:
   - If none exist → prompt: "No specs directory found. Please run `/prd-clarify` first." and STOP.
   - If exactly one exists → use it directly, no confirmation needed.
   - If multiple exist → present ALL as numbered options, WAIT for user to choose before proceeding.

### Step 2: Load Context

After user confirms the specs path:
- If `requirements.md` is already in the current conversation context (e.g., loaded by a prior step in the same session) → skip file reading
- If not in context → read `{specs_path}/requirements.md`

### Step 2: Discover Current Architecture
- **REQUIRED SUB-SKILL:** Use superpowers:system-design
- The system-design skill will explore the project and return a structured architecture summary
- This step is automated — no user confirmation needed

### Step 3: Generate HLD
Based on requirements + current architecture:
1. Identify which existing services are affected
2. Determine if new services are needed
3. Define responsibility allocation for each service
4. Specify interface and event contracts
5. Map dependency relationships
6. Generate `hld.md` using `hld-template.md` (content in Chinese, technical terms in English)

### Step 4: Present for Confirmation
- Show the complete HLD to the user
- One-time confirmation (not section-by-section)
- If user requests changes, revise and re-present

### Step 5: Save
- Save to `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/hld.md`

### Step 6: HLD Review Loop

After saving `hld.md`, dispatch the **hld-document-reviewer** subagent for automated review.

1. **Dispatch reviewer subagent** — use the `skills/generating-hld/hld-document-reviewer-prompt.md` template, replacing `[HLD_FILE_PATH]` with `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/hld.md`. Dispatch the reviewer via Task tool.
2. **Handle review results:**
   - **No issues** → proceed to Step 7 (User Review Gate).
   - **Issues found** → fix issues in `hld.md` based on the issue list, re-save, and re-dispatch the reviewer subagent.
3. **Loop limit:** maximum **5 rounds** of fix-review iterations. If issues remain after 5 rounds, stop auto-fixing, summarize remaining issues, and escalate to the user for guidance.

### Step 7: User Review Gate

After automated review passes (or after escalating remaining issues to the user), prompt the user for final human review of `hld.md`.

1. Present: "HLD has passed automated review. Please review `hld.md` and confirm."
2. **WAIT for explicit user confirmation** before proceeding.
3. If the user requests changes, apply changes, re-save, and re-run the HLD Review Loop (Step 6) to validate.
4. Once the user confirms, prompt: "HLD confirmed. Run `/generate-design` to create detailed design for each involved service."

## Template

Use `hld-template.md` in this skill's directory for the output structure.

## Integration

**REQUIRED SUB-SKILLS:**
- superpowers:system-design (architecture discovery)

**Input:** `requirements.md` from same specs directory
**Output:** `hld.md` in same specs directory
**Next step:** superpowers:generating-design
