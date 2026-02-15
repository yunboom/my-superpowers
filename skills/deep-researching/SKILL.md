---
name: deep-researching
description: Use when encountering technical uncertainty or new technologies not present in the project during design, to conduct automated web research via sub-agents
---

# Deep Technical Research

## Overview

Conduct targeted technical research by dispatching web-search sub-agents. When multiple research topics are identified, dispatch multiple sub-agents in parallel — one per topic.

**Core principle:** Parallel sub-agent dispatch for targeted research — identify questions, dispatch searchers, aggregate findings.

## When to Trigger

1. **Technical uncertainty** — unknown performance limits, compatibility constraints, undocumented behavior
2. **New technology/solution not in the project** — unfamiliar middleware, frameworks, protocols, libraries the team hasn't used before

## The Process

### Step 1: Formulate Research Questions
For each area of uncertainty, create a specific, searchable question:
- ❌ "Is Redis good?" (too vague)
- ✅ "Redis vs. Memcached for session storage: performance comparison with 10K concurrent connections" (specific)

### Step 2: Route to Search Modules
Based on question type, determine which search modules each sub-agent should load:

| Question Type | Modules |
|---------------|---------|
| Technical comparison / best practices | `general-web` |
| Known issues / bugs / errors | `github-debug` + `stackoverflow` |
| Algorithm / research papers | `academic-papers` |
| Chinese ecosystem / domestic frameworks | `chinese-tech` |
| Mixed / complex | Multiple modules as needed |

### Step 3: Dispatch Sub-Agents
**Hard Constraint:** Use the `web-search-agent` agent definition.

- **Single topic:** Dispatch 1 sub-agent
- **Multiple topics:** Dispatch N sub-agents in parallel (one per topic)

**Prompt template for each sub-agent:**

## Research Task
{specific_research_question}

## Context
{why_this_matters_for_our_design}

## Output Requirements
Return structured findings:
1. Key findings summary (2-3 sentences)
2. Approaches compared (pros/cons/applicable scenarios for each)
3. Recommended approach with justification
4. Source links for all claims

### Step 4: Aggregate Results
- Collect findings from all sub-agents
- Synthesize into a unified research summary
- Identify consensus and conflicting opinions
- Present recommended approach per topic

### Step 5: Return to Caller
Return structured research report to the calling skill (typically `generating-design`).

## Output Format

### Topic 1: {question}
**Recommendation:** {recommended approach}
**Key Findings:**
- {finding 1}
- {finding 2}
**Alternatives Considered:**
| Approach | Pros | Cons |
|----------|------|------|
**Sources:**
- [source 1](url)
- [source 2](url)

### Topic 2: {question}
...

## Integration

**Called by:** `superpowers:generating-design` as REQUIRED SUB-SKILL
**Requires:** `web-search-agent` agent in `.cursor/agents/`
