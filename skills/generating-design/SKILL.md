---
name: generating-design
description: Use when you need to create a detailed technical design for a specific service or frontend application, with automated deep-research capability for technical uncertainties and new technologies
---

# Detailed Design Generation

## Overview

Conduct detailed technical design for a specified service or frontend application. Deeply uncover potential technical requirements through brainstorming, and automatically dispatch sub-agents for research when encountering technical uncertainties or new technologies.

**Core principle:** Research-augmented design — brainstorm with the user, auto-research unknowns via sub-agents, produce a comprehensive design document.

**Announce at start:** "I'm using the generating-design skill to create the detailed design."

**REQUIRED BACKGROUND:** You MUST understand superpowers:brainstorming before using this skill. That skill defines the dialogue patterns (one question at a time, prefer multiple-choice) this skill reuses for technical brainstorming.

## The Process

### Step 1: Resolve Specs Path

Determine the target specs directory `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`:

1. **If the path is already known from the current conversation** (e.g., a prior `/generate-hld` step in this session used a specific specs directory) → use it directly, no confirmation needed.
2. **If the path is NOT known**, scan `docs/specs/` for all `yyyy-MM-dd-REQ-*/{topic}` directories:
   - If none exist → prompt: "No specs directory found. Please run `/prd-clarify` first." and STOP.
   - If exactly one exists → use it directly, no confirmation needed.
   - If multiple exist → present ALL as numbered options, WAIT for user to choose before proceeding.

### Step 2: Load Context

Read exactly these files from the resolved specs path. Do NOT read any other files.

1. `{specs_path}/requirements.md` — skip if already loaded by a prior step in this session
2. `{specs_path}/hld.md` — skip if already loaded by a prior step in this session, or if the file does not exist

Confirm the target service for this design session.

### Step 3: Detect Project Type

Detect the project type by scanning the **working directory root** for characteristic files:

**Frontend signals** (any match → frontend):
- `package.json` exists AND contains frontend framework dependencies (`react`, `vue`, `next`, `nuxt`, `angular`, `svelte`)
- OR config files exist: `vite.config.*`, `next.config.*`, `nuxt.config.*`

**Backend signals** (any match → backend):
- `go.mod`
- `pom.xml` / `build.gradle`
- `requirements.txt` / `pyproject.toml`
- `Cargo.toml`

**Cannot determine** → ask the user.

Announce the detected type: "Detected project type: **frontend/backend**."

### Load Standard Skills (std)

Scan available skills for names containing `std` (e.g., `db-std`, `api-std`, `error-handling-std`). These are standard/specification skills covering design conventions such as database design standards, API design standards, or error handling standards. Load and follow any that match the current design scenario.

### Step 4: Identify Technical Needs and Research

**First, analyze requirements and uncover hidden technical needs from business scenarios:**

**For backend projects:**
- Identify middleware that could enable the feature (e.g., Redis for caching/locking, Elasticsearch for full-text search, Kafka for event-driven flows)
- Identify architectural patterns needed (e.g., data consistency, distributed transactions, CQRS, eventual consistency)
- Do NOT just accept the obvious approach — proactively explore whether introducing the right middleware or pattern could significantly improve the solution

**For frontend projects:**
- Identify UI library/component framework needs (e.g., design system, component library selection)
- Identify state management and data flow patterns (e.g., global store, server state caching, real-time sync)
- Identify performance-critical rendering concerns (e.g., virtualization, code splitting, SSR/SSG)
- Do NOT just accept the obvious approach — proactively explore whether introducing the right library or pattern could significantly improve the solution

**Then, dispatch research sub-agents to gather information BEFORE brainstorming with the user.**

<HARD-GATE>
For ANY of the following technical decisions, you MUST dispatch research sub-agents via superpowers:deep-researching BEFORE presenting options to the user. Do NOT rely on existing knowledge alone — get the latest industry practices and community solutions.

**Backend triggers:**
1. **Middleware selection** — choosing between or introducing middleware (Redis, Elasticsearch, Kafka, RabbitMQ, etc.)
2. **Architecture pattern decisions** — distributed transactions, data consistency, CQRS, event sourcing, saga pattern, etc.

**Frontend triggers:**
3. **UI framework/library selection** — choosing between component libraries, design systems, or UI frameworks
4. **State management decisions** — choosing between state management approaches (Redux, Zustand, Jotai, server state with React Query, etc.)

**Common triggers (both):**
5. **New technology introduction** — any middleware, framework, protocol, or library not currently used in the project
6. **Performance-critical design** — high-throughput, low-latency, large-scale data processing, or complex rendering optimization

You may NOT skip research by claiming "I already know the best practice." The purpose is to get the LATEST community solutions, not to rely on training data.
</HARD-GATE>

```dot
digraph design_flow {
    "Analyze requirements" [shape=box];
    "Identify technical needs" [shape=box];
    "Middleware / architecture / new tech / perf-critical?" [shape=diamond];
    "Dispatch research sub-agents" [shape=box];
    "Integrate research results" [shape=box];
    "Technical brainstorming with user" [shape=box];

    "Analyze requirements" -> "Identify technical needs";
    "Identify technical needs" -> "Middleware / architecture / new tech / perf-critical?";
    "Middleware / architecture / new tech / perf-critical?" -> "Dispatch research sub-agents" [label="yes - MUST research first"];
    "Middleware / architecture / new tech / perf-critical?" -> "Technical brainstorming with user" [label="no - simple CRUD"];
    "Dispatch research sub-agents" -> "Integrate research results";
    "Integrate research results" -> "Technical brainstorming with user";
}
```

### Step 5: Technical Brainstorming

Use brainstorming dialogue patterns: one question at a time, prefer multiple-choice.

**Option presentation rules:**
1. **Lead with your recommended option** — place it first, clearly marked as "(recommended)", with a brief justification based on research findings
2. Present research findings as part of each option — include evidence (community practices, benchmarks, trade-offs)
3. **Always include a "Write all options to design.md for team review" choice as the last option.** When selected, do NOT decide — instead write all researched options with their pros/cons/trade-offs into design.md for the team to evaluate and select during review

**For backend projects**, cover these technical dimensions:
- API design (endpoints, contracts, versioning)
- Data model (tables, indexes, migrations)
- Core logic (algorithms, state machines, business rules)
- Dependencies (external services, libraries, infrastructure)
- Error handling (failure modes, retry strategies, circuit breakers)
- Observability (metrics, logging, alerting)
- Testing strategy (unit, integration, edge cases)
- Rollout plan (feature flags, gradual rollout, rollback)

**For frontend projects**, cover these technical dimensions:
- Page & routing design (new/modified pages, route params, access control)
- Component design (shared components, Props interfaces, reuse strategy)
- State & data flow (global state management, data flow direction)
- API integration strategy (API call list, error handling, loading states)
- Performance optimization (animations, virtual lists, lazy loading, code splitting)
- i18n & analytics (translation keys, business event tracking)
- Compatibility & responsiveness (browser compatibility, mobile adaptation)
- Testing strategy (unit tests, E2E tests, visual regression)

### Step 6: Generate Design Document

**Load design template based on project type detected in Step 3:**

If project type is **backend**:
- REQUIRED SUB-SKILL: use `trd-backend-template`

If project type is **frontend**:
- REQUIRED SUB-SKILL: use `trd-frontend-template`

Save to `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/design.md`

### Step 7: Design Self-Review

After generating design.md, look at it with fresh eyes. This is a checklist you run yourself — not a subagent dispatch.

**1. Requirements coverage:** Cross-check against requirements.md — are all requirements assigned to THIS service's domain covered? Any missing functional points?

**2. Module design:** Is each module's responsibility clear and single-purpose? Any overlapping or missing modules?

**3. Data model:** Are data models complete? Do state machines cover all state transitions? Are ER diagrams consistent with DDL?

**4. API design:** Are interface protocols fully defined (request/response params)? Naming and versioning consistent?

**5. Storage design:** Does DB design follow conventions? Are cache strategies reasonable? Are indexes sufficient?

**6. Idempotency & concurrency:** Are interfaces idempotent? Are locking strategies and transaction granularity defined? Race conditions considered?

**7. Historical compatibility:** Is backward compatibility with existing data/features evaluated? Will new changes break existing functionality?

**8. Reliability:** Are monitoring/alerting, error handling, and traffic estimation covered?

**9. Security & compliance:** Is sensitive data encrypted? Are API auth/permissions complete?

**10. Performance:** Are QPS/latency targets explicit? Is there a corresponding load test plan?

**11. Deployment & rollback:** Is the release plan complete? Is the rollback strategy feasible (can old code handle new data)?

**12. Completeness & consistency:** Any TODOs, placeholders, "TBD"? Do data models match DDL? Do architecture diagrams match module descriptions?

If you find issues, fix them inline. No need to re-review — just fix and move on.

### Step 8: User Review Gate

After self-review passes, prompt the user for final human review of design.md.

1. Inform the user: design.md has passed self-review. Ask them to review the document.
2. **WAIT for explicit user confirmation** (e.g., "confirmed" / "approved" / "LGTM") before proceeding.
3. If the user requests changes, apply the changes, re-run self-review, and re-submit for user confirmation until explicitly approved.

### Step 9: Prompt Next Step
- "Design complete. Run `/write-plan` to create the implementation plan."

## Integration

**REQUIRED SUB-SKILL:** superpowers:deep-researching (research dispatch)
**REQUIRED SUB-SKILL:** trd-backend-template (backend design template) — used when project type is backend
**REQUIRED SUB-SKILL:** trd-frontend-template (frontend design template) — used when project type is frontend
**REQUIRED BACKGROUND:** superpowers:brainstorming (dialogue patterns)
**Input:** `requirements.md` + `hld.md` (optional) from same specs directory
**Output:** `design.md` in same specs directory
**Next step:** superpowers:writing-plans (via /write-plan)
