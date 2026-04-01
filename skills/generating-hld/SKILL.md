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

### Step 6: HLD Self-Review

After saving `hld.md`, look at it with fresh eyes. This is a checklist you run yourself — not a subagent dispatch.

**1. System boundary:** Is the system boundary clearly defined? Are in-scope vs out-of-scope services explicit?

**2. Service responsibility:** Does each service have a single, clear responsibility? Any overlapping or missing responsibilities?

**3. Interface contracts:** Are sync APIs and async events fully defined? Are Provider/Consumer relationships clear?

**4. Dependency direction:** Are dependency directions reasonable? Any circular dependencies?

**5. Data ownership:** Is data entity ownership explicit? Any multi-service writes to the same data?

**6. Risk identification:** Are risks and open items sufficiently identified? Are mitigation strategies feasible?

**7. Completeness:** Any TODOs, placeholders, "TBD", or incomplete sections? Fix them.

**8. Consistency:** Any contradictions between sections — e.g., dependency diagram doesn't match interface tables?

If you find issues, fix them inline. No need to re-review — just fix and move on.

### Step 7: User Review Gate

After self-review passes, prompt the user for final human review of `hld.md`.

1. Present: "HLD has passed self-review. Please review `hld.md` and confirm."
2. **WAIT for explicit user confirmation** before proceeding.
3. If the user requests changes, apply changes, re-save, and re-run the self-review.
4. Once the user confirms, prompt: "HLD confirmed. Run `/generate-design` to create detailed design for each involved service."

## Template

Use `hld-template.md` in this skill's directory for the output structure.

## Integration

**REQUIRED SUB-SKILLS:**
- superpowers:system-design (architecture discovery)

**Input:** `requirements.md` from same specs directory
**Output:** `hld.md` in same specs directory
**Next step:** superpowers:generating-design
