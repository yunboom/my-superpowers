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

### Step 1: Confirm Specs Path

Scan `docs/specs/` for all `yyyy-MM-dd-REQ-*/{topic}` directories, sorted by date (most recent first). If none exist, prompt: "No specs directory found. Please run `/prd-clarify` first." and STOP.

<HARD-GATE>
You MUST present ALL found directories as numbered options and WAIT for the user to choose before doing anything else. Do NOT load files, do NOT start architecture discovery, do NOT proceed to Step 2 until the user selects.

Say exactly:
"Found the following specs directories:
1. `{most_recent_path}` (recommended)
2. `{older_path}`
3. ...

Which one to use? (enter number)"

Then STOP and wait for user response. Only proceed after user selects.
</HARD-GATE>

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

### Step 5: Save and Prompt Next Step
- Save to `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/hld.md`
- Prompt: "HLD complete. Run `/generate-design` to create detailed design for each involved service."

## Template

Use `hld-template.md` in this skill's directory for the output structure.

## Integration

**REQUIRED SUB-SKILL:** superpowers:system-design (architecture discovery)
**Input:** `requirements.md` from same specs directory
**Output:** `hld.md` in same specs directory
**Next step:** superpowers:generating-design
