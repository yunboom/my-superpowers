---
name: writing-plans
description: Use when you have a design or requirements for a multi-step task, before touching code
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

If the design covers multiple independent subsystems, it should have been broken into sub-project designs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

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

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

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

**Determine project type from design.md tech stack**, then generate testing.md using the appropriate patterns:

### Core Requirements (all project types)

- Detailed end-to-end test cases
- Coverage: normal flows, exception flows, boundary conditions, concurrency scenarios
- Each test case includes: type, preconditions, operation steps, teardown, expected results
- All test steps must be directly executable — no placeholders like "call the API" or "verify the result"
- Once generated, testing.md MUST NOT be modified in subsequent workflow steps

### Backend Projects

- **API test cases MUST include complete curl commands** (with URL, method, headers, request body) that can be directly copied and executed
- **Script-based verification MUST include complete scripts** (with full code, execution commands, and expected output)
- **Environment setup:** middleware startup commands (Docker Compose, local install, or cloud endpoints), healthcheck readiness confirmation, data initialization scripts
- **Data management:** each test case includes teardown/cleanup steps; test data isolated between cases

### Frontend Projects

- **Browser test cases use Playwright test scripts** with Page Object Model (POM) pattern and `data-testid` locators
- **Stability:** use condition-based waits (`waitForResponse`, `waitForSelector`, element visibility) — never fixed waits (`waitForTimeout`, `sleep`)
- **Environment setup:** dev server startup command, mock API / data stubs configuration, browser requirements
- **Visual verification:** screenshot assertions for key UI states where applicable

### Fullstack / Integration Projects

- Combine backend API tests and frontend browser tests
- **Environment setup:** full service dependency chain with startup order and healthcheck readiness (e.g., DB → API → Frontend → E2E runner)
- **Integration flow:** browser action → verify API response → verify DB state

### testing.md format

```markdown
# End-to-End Test Cases

> REQ-{id} | Generated alongside plan.md
> ⚠️ This file MUST NOT be modified during execution. If issues are found, stop and report to user.

## Test Environment Setup

### Prerequisites
- {runtime dependencies: Node.js, Docker, database client, etc.}

### Start Services
\`\`\`bash
{startup commands appropriate for project type}
\`\`\`

### Verify Readiness
\`\`\`bash
{healthcheck or accessibility verification commands}
\`\`\`

### Test Data Initialization
\`\`\`bash
{seed scripts, SQL imports, mock data setup, etc.}
\`\`\`

## TC-1: {Test Case Title}
**Type:** API | Browser | Integration
**Preconditions:**
- {precondition 1}

**Steps:**

{steps in format matching the Type — curl for API, Playwright for Browser, mixed for Integration}

**Teardown:**
\`\`\`bash
{data cleanup commands for this test case}
\`\`\`

**Expected Result:**
- {expected outcome with specific verifiable values}

## TC-2: {Test Case Title}
...
```

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat the code — the engineer may be reading tasks out of order)
- Steps that describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any task

## Remember
- Exact file paths always
- Complete code in every step — if a step changes code, show the code
- Exact commands with expected output
- ALL code comments carry REQ-{id}
- ALL commit messages prefixed with REQ-{id}
- DRY, YAGNI, TDD, frequent commits
- Generate testing.md alongside plan.md

## Self-Review

After writing the complete plan, look at the design with fresh eyes and check the plan against it. This is a checklist you run yourself — not a subagent dispatch.

**1. Design coverage:** Skim each section/requirement in the design. Can you point to a task that implements it? List any gaps.

**2. Placeholder scan:** Search your plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**3. Type consistency:** Do the types, method signatures, and property names you used in later tasks match what you defined in earlier tasks? A function called `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 is a bug.

If you find issues, fix them inline. No need to re-review — just fix and move on. If you find a design requirement with no task, add the task.

## Testing Self-Review

After generating testing.md, look at it with fresh eyes. This is a checklist you run yourself — not a subagent dispatch.

**1. Requirements coverage:** Cross-check against design.md — does every functional point have at least one test case? Any untested features?

**2. Scenario completeness:** Are normal flows, error/exception flows, boundary conditions, and concurrency scenarios all covered?

**3. Executability:** Can every test step be executed directly? No placeholders like "call the API", "verify the result", or "check the database" — each step needs the actual command or assertion.

**4. Environment setup:** Is the test environment setup complete? Backend: middleware startup (Docker Compose), data init scripts, healthcheck. Frontend: dev server command, mock API/data stubs. Fullstack: service dependency chain, startup order.

**5. Data management:** Are test data creation and cleanup strategies explicit? Is data isolated between test cases?

**6. Expected results:** Are expected results specific and verifiable (not subjective like "should be fast")? Include status codes, return values, DB state, or UI element assertions.

**7. Test independence:** Are test cases independent of each other? Any implicit ordering dependencies?

**8. Stability:** Any flakiness risks? Does the test rely on fixed waits (sleep/waitForTimeout) instead of condition-based waits (waitForResponse, healthcheck, element visibility)?

**9. Type consistency:** Does each test case's declared type (API / Browser / Integration) match its actual step format?

**10. Completeness:** Any TODO markers, placeholders, or incomplete test cases?

If you find issues, fix them inline. No need to re-review — just fix and move on.

## Execution Handoff

After saving the plan and testing.md (self-review and testing review passed), offer execution choice:

**"Plan complete and saved to `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/plan.md`. testing.md also generated. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
- Fresh subagent per task + two-stage review

**If Inline Execution chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:executing-plans
- Batch execution with checkpoints for review
