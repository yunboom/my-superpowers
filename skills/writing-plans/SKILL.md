---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill or set up manually before starting the PRD workflow).

**Save plans to:** `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/plan.md`

## Step 0: Resolve Specs Path

Determine the target specs directory `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`:

1. **If the path is already known from the current conversation** (e.g., a prior `/generate-design` step in this session used a specific specs directory) → use it directly, no confirmation needed.
2. **If the path is NOT known**, scan `docs/specs/` for all `yyyy-MM-dd-REQ-*/{topic}` directories:
   - If none exist → prompt: "No specs directory found. Please run `/prd-clarify` first." and STOP.
   - If exactly one exists → use it directly, no confirmation needed.
   - If multiple exist → present ALL as numbered options, WAIT for user to choose before proceeding.

## Context Loading

Read exactly these 2 files from the resolved specs path. Do NOT read any other files (e.g., do NOT read hld.md).

1. `{specs_path}/requirements.md`
2. `{specs_path}/design.md`

If either file was already loaded by a prior step in the same session, skip reading that file. Use these 2 files as the primary input for plan generation.

## Load Standard Skills (std)

Scan available skills for names containing `std` (e.g., `code-std`, `db-std`, `error-handling-std`). These are standard/specification skills covering coding conventions, database standards, error handling patterns, etc. Load any that match the current task context, and ensure the generated plan follows those standards.

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure - but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**REQ:** REQ-{id}
**Specs:** `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/`
**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**

```python
# REQ-{id} test for specific behavior
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
# REQ-{id} implement specific behavior
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "REQ-{id} feat: add specific feature"
```
````

**The LAST task in every plan MUST be: "Run all testing.md integration test cases".**

````markdown
### Task N (Final): Run testing.md Integration Tests

- [ ] **Step 1: Execute all test cases from testing.md**

Run each test case from `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/testing.md` one by one.
Record PASS/FAIL for each case.

- [ ] **Step 2: Fix any failures**

If a test case fails due to code issues, fix and re-run.
If a test case itself appears to be wrong, STOP and report to user.
Do NOT modify testing.md.

- [ ] **Step 3: Confirm all PASS**

All test cases must pass before marking the plan as complete.
````

## Code Comment Convention

ALL code comments in the plan MUST carry `REQ-{id}`:
- `// REQ-{id} validate order amount before submission`
- `# REQ-{id} retry logic for external service calls`
- `/* REQ-{id} migration: add column to orders table */`

## Commit Message Convention

ALL commit messages MUST be prefixed with `REQ-{id}`:
- `REQ-{id} feat: add order validation endpoint`
- `REQ-{id} test: add integration tests for order flow`
- `REQ-{id} fix: handle null amount in validation`

## Generate testing.md

After generating `plan.md`, also generate `testing.md` in the same specs directory.

**testing.md requirements:**
- Detailed end-to-end test cases
- Coverage: normal flows, exception flows, boundary conditions, concurrency scenarios
- Each test case includes: preconditions, operation steps, expected results
- **API test cases MUST include complete curl commands** (with URL, method, headers, request body) that can be directly copied and executed
- **Script-based verification MUST include complete scripts** (with full code, execution commands, and expected output)
- All test steps must be directly executable — no placeholders like "call the API" or "verify the result"
- **Middleware environment:** MySQL, Elasticsearch, Redis and other middleware should preferably run in Docker containers. Test cases should include Docker-based data cleanup and preloading commands (e.g., `docker exec` for database cleanup scripts, Docker volume mounts for initialization SQL)
- Once generated, testing.md MUST NOT be modified in subsequent workflow steps

**testing.md format:**

```markdown
# End-to-End Test Cases

> REQ-{id} | Generated alongside plan.md
> ⚠️ This file MUST NOT be modified during execution. If issues are found, stop and report to user.

## TC-1: {Test Case Title}
**Preconditions:**
- {precondition 1}

**Steps:**

1. Call API:
\`\`\`bash
curl -X POST http://localhost:8080/api/v1/orders \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {token}" \
  -d '{
    "customer_id": "123",
    "amount": 100.00
  }'
\`\`\`

2. Verify response:
- HTTP Status: 200
- Response body contains `"order_id"`

3. Verify database (if needed):
\`\`\`bash
mysql -u root -p -e "SELECT * FROM orders WHERE customer_id='123';"
\`\`\`

**Expected Result:**
- {expected outcome with specific values}

## TC-2: {Test Case Title}
...
```

## Remember
- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- ALL code comments carry REQ-{id}
- ALL commit messages prefixed with REQ-{id}
- Reference relevant skills with @ syntax
- DRY, YAGNI, TDD, frequent commits
- Generate testing.md alongside plan.md

## Plan Review Loop

After completing each chunk of the plan:

1. Dispatch plan-document-reviewer subagent (see plan-document-reviewer-prompt.md) with precisely crafted review context — never your session history. This keeps the reviewer focused on the plan, not your thought process.
   - Provide: chunk content, path to spec document
2. If ❌ Issues Found:
   - Fix the issues in the chunk
   - Re-dispatch reviewer for that chunk
   - Repeat until ✅ Approved
3. If ✅ Approved: proceed to next chunk (or execution handoff if last chunk)

**Chunk boundaries:** Use `## Chunk N: <name>` headings to delimit chunks. Each chunk should be ≤1000 lines and logically self-contained.

**Review loop guidance:**
- Same agent that wrote the plan fixes it (preserves context)
- If loop exceeds 5 iterations, surface to human for guidance
- Reviewers are advisory - explain disagreements if you believe feedback is incorrect

## Execution Handoff

After saving the plan and testing.md:

**"Plan complete and saved to `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/plan.md`. testing.md also generated. Ready to execute?"**

**Execution path depends on harness capabilities:**

**If harness has subagents (Claude Code, etc.):**
- **REQUIRED:** Use superpowers:subagent-driven-development
- Do NOT offer a choice - subagent-driven is the standard approach
- Fresh subagent per task + two-stage review

**If harness does NOT have subagents:**
- Execute plan in current session using superpowers:executing-plans
- Batch execution with checkpoints for review
