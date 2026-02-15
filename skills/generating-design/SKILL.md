---
name: generating-design
description: Use when you need to create a detailed technical design for a specific microservice, with automated deep-research capability for technical uncertainties and new technologies
---

# Detailed Design Generation

## Overview

Conduct detailed technical design for a specified microservice. Deeply uncover potential technical requirements through brainstorming, and automatically dispatch sub-agents for research when encountering technical uncertainties or new technologies.

**Core principle:** Research-augmented design — brainstorm with the user, auto-research unknowns via sub-agents, produce a comprehensive design document.

**Announce at start:** "I'm using the generating-design skill to create the detailed design."

**REQUIRED BACKGROUND:** You MUST understand superpowers:brainstorming before using this skill. That skill defines the dialogue patterns (one question at a time, prefer multiple-choice) this skill reuses for technical brainstorming.

## The Process

### Step 1: Load Context
1. Confirm the specs path: `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`
2. **MANDATORY: Read ALL context files from disk. No exceptions.**
   - Read `requirements.md` from the specs directory
   - Read `hld.md` from the specs directory (if it exists)
   - Even if you generated these files earlier in this session, you MUST re-read them to ensure completeness
3. Confirm the target microservice for this design session

### Step 2: Technical Brainstorming

Use brainstorming dialogue patterns: one question at a time, prefer multiple-choice.

Cover these technical dimensions:
- API design (endpoints, contracts, versioning)
- Data model (tables, indexes, migrations)
- Core logic (algorithms, state machines, business rules)
- Dependencies (external services, libraries, infrastructure)
- Error handling (failure modes, retry strategies, circuit breakers)
- Observability (metrics, logging, alerting)
- Testing strategy (unit, integration, edge cases)
- Rollout plan (feature flags, gradual rollout, rollback)

### Step 3: Auto-Research When Needed

```dot
digraph research_trigger {
    "Technical question arises" [shape=box];
    "Uncertainty or new tech?" [shape=diamond];
    "Continue brainstorming" [shape=box];
    "Formulate research questions" [shape=box];
    "Multiple topics?" [shape=diamond];
    "Dispatch 1 sub-agent" [shape=box];
    "Dispatch N sub-agents in parallel" [shape=box];
    "Integrate results" [shape=box];

    "Technical question arises" -> "Uncertainty or new tech?";
    "Uncertainty or new tech?" -> "Continue brainstorming" [label="no - known"];
    "Uncertainty or new tech?" -> "Formulate research questions" [label="yes"];
    "Formulate research questions" -> "Multiple topics?";
    "Multiple topics?" -> "Dispatch 1 sub-agent" [label="no"];
    "Multiple topics?" -> "Dispatch N sub-agents in parallel" [label="yes"];
    "Dispatch 1 sub-agent" -> "Integrate results";
    "Dispatch N sub-agents in parallel" -> "Integrate results";
    "Integrate results" -> "Continue brainstorming";
}
```

**Trigger conditions for research dispatch:**
1. **Technical uncertainty** — unknown performance limits, compatibility constraints, undocumented behavior
2. **New technology not in the project** — unfamiliar middleware, frameworks, protocols, libraries

**REQUIRED SUB-SKILL:** Use superpowers:deep-researching for all research dispatches.

### Step 4: Generate Design Document
- Use `design-template.md` in this skill's directory
- Output content in Chinese, technical terms in English
- Save to `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/design.md`

### Step 5: User Confirmation
- Present complete design for review
- Revise if needed
- Get explicit approval

### Step 6: Prompt Next Step
- "Design complete. Run `/write-plan` to create the implementation plan."

## Integration

**REQUIRED SUB-SKILL:** superpowers:deep-researching (research dispatch)
**REQUIRED BACKGROUND:** superpowers:brainstorming (dialogue patterns)
**Input:** `requirements.md` + `hld.md` (optional) from same specs directory
**Output:** `design.md` in same specs directory
**Next step:** superpowers:writing-plans (via /write-plan)
