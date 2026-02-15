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

### Step 1: Resolve Specs Path and Load Context
1. Determine the specs directory path `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`:
   - If invoked after `/prd-clarify` in the same session, the path is already known
   - If not known, scan `docs/specs/` and select the most recent `yyyy-MM-dd-REQ-*` directory (by date), present it to the user for confirmation
   - If no specs directories exist, prompt: "No specs directory found. Please run `/prd-clarify` first to create requirements."
2. Load `requirements.md`:
   - If already in the current conversation context (e.g., loaded by a prior step in the same session) → skip file reading
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
