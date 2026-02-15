# Product-Engineering Workflow Extension Design

## Overview

Extend my-superpowers with a PRD-driven product-engineering workflow that runs in parallel with the existing brainstorming workflow. The new workflow takes a PRD as input, clarifies requirements, produces high-level and detailed designs, generates implementation plans with end-to-end test cases, and executes them with safety checks.

**Two parallel workflows:**

```
Workflow A (free-form ideas):
  /brainstorm → /write-plan → /execute-plan

Workflow B (PRD-driven product-engineering):
  /prd-clarify → /generate-hld (optional) → /generate-design → /write-plan → /execute-plan
```

Both workflows share the `writing-plans` and `executing-plans` skills, unified under the `docs/specs/` directory.

## Specs Directory Structure

```
docs/specs/
  yyyy-MM-dd-REQ-{id}/              # Level 1: isolated by requirement
    {topic}/                         # Level 2: isolated by topic
      requirements.md                # Output of /prd-clarify
      hld.md                         # Output of /generate-hld (optional)
      design.md                      # Output of /generate-design
      plan.md                        # Output of /write-plan
      testing.md                     # Output of /write-plan (generated alongside plan.md)
```

- `{id}`: Requirement ID extracted from PRD (see Requirement ID Extraction below)
- `{topic}`: Short English description of the sub-topic

## Requirement ID Extraction

1. Match pattern `https://project.feishu.cn/.*/detail/(\d+)` in PRD content
2. Extract trailing digits as requirement ID
3. If no match, ask user to provide the ID
4. For brainstorming workflow: auto-select most recent `docs/specs/` directory's REQ-id, confirm with user

## Conventions

- **Commit messages:** Prefix with `REQ-{id}` (e.g., `REQ-12345 feat: add order validation`)
- **Code comments:** ALL code comments must carry `REQ-{id}` (e.g., `// REQ-12345 validate order amount before submission`)
- **Topic naming:** Short English words (e.g., `order-validation`, `user-auth`)
- **Technical terms:** Keep in English even in Chinese documents (e.g., gRPC, Kafka, Redis, API)

---

## New Skills

### 1. `prd-clarifying` — Requirement Clarification

**Purpose:** Entry point of the product-engineering workflow. Receive PRD input, conduct requirements-level brainstorming to uncover issues in the PRD, clarify with user one by one, and produce a structured `requirements.md`.

**Trigger:** `/prd-clarify` command

**Input:** User pastes PRD content OR provides file path (agent auto-detects)

**Output:** `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/requirements.md`

**Process:**

```
1. Receive PRD (pasted content or read from file path)
2. Extract requirement ID (match Feishu link or ask user)
3. Determine topic name (short English)
4. Create specs directory structure
5. Requirements-level brainstorming (reuse brainstorming dialogue patterns):
   - One question at a time, prefer multiple-choice
   - Driven by requirements checklist (see below)
6. After all clarifications, generate requirements.md
7. User confirms requirements.md
8. Prompt next step: /generate-hld (complex multi-service) or /generate-design (single service)
```

**Requirements Checklist:**

| Dimension | Check Items |
|-----------|-------------|
| Functional boundary | Is scope clear? What is out of scope? |
| Exception flows | How to handle failure/timeout/concurrency conflicts? |
| Data boundary | Data volume, historical data migration, data lifecycle? |
| Permissions & security | Who can operate? Audit requirements? |
| Compatibility | Impact on existing features? Grayscale strategy? |
| Non-functional requirements | Performance metrics, SLA, observability? |
| Implicit assumptions | Assumptions not stated in PRD but required for implementation? |
| Priority | What is MVP-required vs. deferrable? |
| Acceptance criteria | How to determine requirement completion? |

**Skill declarations:**
- `REQUIRED BACKGROUND: superpowers:brainstorming` (reuse dialogue patterns)
- HARD-GATE: Must complete all clarifications and get user confirmation before generating requirements.md

---

### 2. `system-design` — System Architecture Discovery

**Purpose:** Discover the current project's microservice architecture and domain boundaries, providing context for HLD generation.

**Trigger:** Called by `generating-hld` as REQUIRED SUB-SKILL

**Process:**

```
1. Explore project structure (repos, config files, docker-compose, k8s manifests, etc.)
2. Identify microservice list and their tech stacks
3. Analyze domain boundaries (inferred from package structure, API definitions, proto files, event definitions)
4. Map existing inter-service dependencies (API calls, message queues, shared databases)
5. Output structured system architecture summary
```

**Output format (structured text, consumed by HLD skill):**

```markdown
## Services
- service-a: responsibility | tech stack | port
- service-b: ...

## Domain Boundaries
- Domain X: [service-a, service-c]
- Domain Y: [service-b, service-d]

## Existing Dependencies
- service-a → service-b (gRPC)
- service-a → service-c (Kafka event: order.created)

## Shared Infrastructure
- PostgreSQL (shared by: service-a, service-b)
- Redis (shared by: service-a, service-c)
```

---

### 3. `generating-hld` — High-Level Design

**Purpose:** For complex multi-microservice requirements, define service responsibilities, external capabilities, and inter-service dependencies from a top-level perspective.

**Trigger:** `/generate-hld` command

**Input:** `requirements.md` from same specs directory

**Output:** `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/hld.md`

**Process:**

```
1. Read requirements.md as context
2. Invoke system-design skill to obtain current system architecture
3. Based on requirements + system architecture, analyze involved services and scope of changes
4. Generate hld.md directly using hld-template.md
5. Present to user for confirmation (one-time confirmation, not item-by-item)
6. Prompt next step: /generate-design (detailed design for each service)
```

**REQUIRED SUB-SKILL:** `superpowers:system-design`

**`hld-template.md` structure:**

```markdown
# High-Level Design: {Title}

## 1. System Overview
- Business context and goals
- System boundary diagram (which services are in scope)

## 2. Service Responsibilities
| Service | Responsibility | Owner |
|---------|---------------|-------|
| service-a | ... | ... |

## 3. Interface & Event Contracts
### 3.1 Synchronous Interfaces (API)
| Provider | Consumer | Interface | Description |
|----------|----------|-----------|-------------|

### 3.2 Asynchronous Events
| Producer | Consumer | Event | Description |
|----------|----------|-------|-------------|

## 4. Dependency Graph
- Service dependency diagram (text-based or mermaid)
- Dependency direction and rationale

## 5. Data Ownership
| Data Entity | Owner Service | Consumers |
|-------------|--------------|-----------|

## 6. Deployment & Infrastructure Constraints
- New infrastructure needed?
- Cross-region / cross-cluster considerations?

## 7. Risks & Open Questions
| Risk | Impact | Mitigation |
|------|--------|------------|
```

---

### 4. `deep-researching` — Technical Deep Research

**Purpose:** Standalone skill for automated technical research via sub-agents. Based on the Deep Research skills web-search-agent pattern.

**Trigger:** Called by `generating-design` when encountering:
1. Technical uncertainty (e.g., unknown performance limits, compatibility constraints)
2. New technologies or solutions not present in the project (e.g., unfamiliar middleware, frameworks, protocols)

**Core components:**

| Component | Description |
|-----------|-------------|
| `web-search-agent.md` | Search sub-agent definition, placed in `.cursor/agents/` |
| `web-search-modules/` | Search modules (github-debug, general-web, stackoverflow, chinese-tech, academic-papers) |
| `SKILL.md` | Research workflow definition |

**Process:**

```
1. Receive research questions from calling skill (generating-design)
2. If multiple topics identified, dispatch multiple sub-agents in parallel (one per topic)
3. Each sub-agent:
   a. Generate 5-10 search query variations
   b. Route to appropriate search modules based on question type:
      - Technical comparison → general-web
      - Known issues/bugs → github-debug + stackoverflow
      - Academic papers → academic-papers
      - Chinese tech community → chinese-tech
   c. Execute search via web-search-agent
   d. Compile structured findings
4. Aggregate results from all sub-agents
5. Return structured research report:
   - Key findings summary
   - Approach comparison (pros/cons, applicable scenarios)
   - Source links
   - Recommended approach
6. Return results to caller (generating-design)
```

**Difference from Deep Research reference project:**
- Reference project: broad research (batch-research many objects with outline.yaml/fields.yaml)
- This skill: targeted research (solve specific technical questions)
- Reuses web-search-agent and search module routing pattern

---

### 5. `generating-design` — Detailed Design

**Purpose:** Conduct detailed technical design for a specified microservice, deeply uncover potential technical requirements, and auto-dispatch sub-agents for research when needed.

**Trigger:** `/generate-design` command

**Input:** `requirements.md` + `hld.md` (if exists) from same specs directory

**Output:** `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/design.md` (output in Chinese, technical terms in English)

**Process:**

```
1. Read requirements.md and hld.md (if exists) as context
2. Confirm target microservice for this design session
3. Technical brainstorming:
   - One question at a time, prefer multiple-choice
   - When encountering:
     a. Technical uncertainty, OR
     b. New technology/solution not in the project
     → Formulate specific research questions
     → Auto-dispatch sub-agent(s) using deep-researching skill
       (multiple topics = multiple parallel sub-agents)
     → Integrate research results into design context
     → Continue brainstorming
4. Clarify technical decisions one by one
5. Output design.md using template.md (content in Chinese, terms in English)
6. User confirms
7. Prompt next step: /write-plan
```

**REQUIRED SUB-SKILL:** `superpowers:deep-researching` (sub-agent research)
**REQUIRED BACKGROUND:** `superpowers:brainstorming` (dialogue pattern reuse)

**`template.md` structure:**

```markdown
# Detailed Design: {Title}

> REQ-{id} | Service: {service-name}

## 1. Background & Goals
- What problem does this solve?
- Success metrics

## 2. Solution Overview
- Approach summary (2-3 sentences)
- Architecture diagram (if needed)

## 3. API Design
### 3.1 New/Modified Endpoints
| Method | Path | Description | Request | Response |
|--------|------|-------------|---------|----------|

### 3.2 API Contracts (request/response detail)

## 4. Data Model
### 4.1 New/Modified Tables
| Table | Column | Type | Description |
|-------|--------|------|-------------|

### 4.2 Indexes
### 4.3 Migration Plan

## 5. Core Logic
- Key algorithms / business rules
- State machines (if applicable)
- Sequence diagrams for critical flows

## 6. Dependencies
- External service calls
- Third-party libraries
- Infrastructure requirements

## 7. Error Handling
| Error Scenario | Handling Strategy | User Impact |
|----------------|-------------------|-------------|

## 8. Observability
- Key metrics to monitor
- Logging strategy
- Alerting rules

## 9. Testing Strategy
- Unit test scope
- Integration test scope
- Edge cases to cover

## 10. Risks & Mitigations
| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|

## 11. Rollout Plan
- Feature flags?
- Gradual rollout?
- Rollback strategy?
```

---

## Modified Skills

### 1. `writing-plans` Modifications

**Scope:** Directory path, REQ conventions, testing.md generation

| Item | Before | After |
|------|--------|-------|
| Plan output path | `docs/plans/YYYY-MM-DD-<feature-name>.md` | `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/plan.md` |
| Context input | None | Read `requirements.md` and `design.md` from same directory |
| Commit messages | `feat: add specific feature` | `REQ-{id} feat: add specific feature` |
| Code comments | No requirement | ALL comments must carry `// REQ-{id} {description}` |
| Testing | None | Generate `testing.md` (end-to-end test cases) to same specs directory |
| Plan header | References `executing-plans` | Also carries `REQ-{id}` info |

**Plan header example:**

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**REQ:** REQ-{id}
**Specs:** `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`
**Goal:** [One sentence]
**Architecture:** [2-3 sentences]
**Tech Stack:** [Key technologies]

---
```

**Commit example:**

```bash
git commit -m "REQ-{id} feat: add specific feature"
```

**testing.md generation requirements:**
- Generated alongside `plan.md`
- Contains detailed end-to-end test cases
- Coverage: normal flows, exception flows, boundary conditions, concurrency scenarios
- Each test case includes: preconditions, steps, expected results
- Once generated, testing.md MUST NOT be modified in subsequent workflow steps

**REQ-id resolution:**
- Read from existing files in same specs directory
- If not determinable, select most recent `docs/specs/` directory's REQ-id, confirm with user

---

### 2. `executing-plans` Modifications

**Scope:** REQ conventions, testing.md verification, safety checks

| Item | Before | After |
|------|--------|-------|
| Commit messages | No prefix | All commits carry `REQ-{id}` prefix |
| Code comments | No requirement | ALL comments must carry `// REQ-{id} {description}` |
| Post-completion | Call finishing-a-development-branch | Execute testing.md verification FIRST, then call finishing |
| testing.md | None | FORBIDDEN to modify/edit; stop and report to user if issues found |
| Safety check | None | Check external dependency connections before running tests |

**testing.md verification (new step, inserted before finishing):**

```
Step 4.5: Testing Verification
1. Read testing.md from same specs directory
2. Execute end-to-end test cases one by one
3. Record result for each case (PASS/FAIL)
4. All PASS → proceed to Step 5 (finishing)
5. Any FAIL:
   a. Analyze failure cause
   b. If code issue → fix code, re-verify
   c. If testing.md case itself is problematic → STOP, report to user:
      "testing.md case #N may have an issue: [description]. Please confirm."
6. ABSOLUTELY FORBIDDEN to modify testing.md
```

**External dependency safety check (new, before running unit tests):**

```
Safety Check: External Dependency Connections
1. Scan project config files (application.yml, .env, config.*, etc.)
2. Check database/middleware connection addresses:
   - DB/MySQL: host must be localhost/127.0.0.1
   - Elasticsearch: host must be localhost/127.0.0.1
   - Redis: host must be localhost/127.0.0.1
   - Other data-storage dependencies
3. If non-localhost connection detected:
   ⚠️ STOP execution, prompt user:
   "Detected external dependency connections pointing to non-local environment:
    - MySQL: 192.168.1.100:3306
    - ES: es-cluster.prod.internal:9200
   Continuing may cause data modification/deletion in non-local environments.
   Confirm to continue? [Y/N]"
4. Proceed only after user confirmation
```

---

### 3. `brainstorming` Modifications

**Scope:** Design doc output path changed to specs directory, REQ-id confirmation added

| Item | Before | After |
|------|--------|-------|
| Design doc path | `docs/plans/YYYY-MM-DD-<topic>-design.md` | `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/design.md` |
| REQ-id | None | Auto-select most recent `docs/specs/` directory's REQ-id, confirm with user |

Minimal change: only the "After the Design" section's output path and REQ-id confirmation logic.

---

## New Commands

### `/prd-clarify`

```markdown
---
description: Clarify PRD requirements through structured brainstorming, uncover issues and produce requirements.md
disable-model-invocation: true
---

Invoke the superpowers:prd-clarifying skill and follow it exactly as presented to you
```

### `/generate-hld`

```markdown
---
description: Generate high-level design for complex multi-service requirements with service responsibility allocation
disable-model-invocation: true
---

Invoke the superpowers:generating-hld skill and follow it exactly as presented to you
```

### `/generate-design`

```markdown
---
description: Generate detailed technical design for a specific microservice with auto deep-research capability
disable-model-invocation: true
---

Invoke the superpowers:generating-design skill and follow it exactly as presented to you
```

---

## New Agents & Modules

### `web-search-agent.md`

Placed in `.cursor/agents/`. Based on Deep Research reference project's agent definition:
- Elite internet researcher with creative search strategies
- Module-based routing (must load relevant module before searching)
- Quality assurance with source verification and date-stamping
- Structured output format with sources always required

### Search Modules (`.cursor/agents/web-search-modules/`)

| Module | Sources |
|--------|---------|
| `general-web.md` | Reddit, Official Docs, Blogs, Hacker News, Dev.to, Medium, Discord |
| `github-debug.md` | GitHub Issues (open/closed) |
| `stackoverflow.md` | Stack Overflow, Stack Exchange, technical forums |
| `chinese-tech.md` | CSDN, Juejin, SegmentFault, Zhihu, V2EX, Tencent/Alibaba Cloud |
| `academic-papers.md` | Google Scholar, arXiv, HuggingFace Papers, Semantic Scholar |

---

## Chinese Translation (SKILL.zh-CN.md)

**Scope:** All 19 skills (14 existing + 5 new)

**Principles:**
- English `SKILL.md` is the primary file (agent reads and executes)
- `SKILL.zh-CN.md` is reference for human reading
- Templates (`template.md`, `hld-template.md`) have no zh-CN version, but their OUTPUT (design.md, hld.md) is in Chinese
- Code examples, commands, file paths stay as-is (no translation)
- Technical terms stay in English
- YAML frontmatter not translated

**Files (14 existing):**

```
brainstorming/SKILL.zh-CN.md
writing-plans/SKILL.zh-CN.md
executing-plans/SKILL.zh-CN.md
using-superpowers/SKILL.zh-CN.md
subagent-driven-development/SKILL.zh-CN.md
test-driven-development/SKILL.zh-CN.md
systematic-debugging/SKILL.zh-CN.md
verification-before-completion/SKILL.zh-CN.md
requesting-code-review/SKILL.zh-CN.md
receiving-code-review/SKILL.zh-CN.md
finishing-a-development-branch/SKILL.zh-CN.md
using-git-worktrees/SKILL.zh-CN.md
dispatching-parallel-agents/SKILL.zh-CN.md
writing-skills/SKILL.zh-CN.md
```

**Files (5 new):**

```
prd-clarifying/SKILL.zh-CN.md
generating-hld/SKILL.zh-CN.md
generating-design/SKILL.zh-CN.md
deep-researching/SKILL.zh-CN.md
system-design/SKILL.zh-CN.md
```

---

## File Summary

| Type | Count |
|------|-------|
| New SKILL.md | 5 |
| New SKILL.zh-CN.md | 19 |
| New templates | 2 |
| New commands | 3 |
| New agent + modules | 6 |
| Modified SKILL.md | 3 |
| **Total** | **38 files** |
