---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
---

# Executing Plans

## Overview

Load plan, review critically, execute tasks in batches, report for review between batches. Verify testing.md after all tasks complete.

**Core principle:** Batch execution with checkpoints for architect review, followed by end-to-end test verification.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

## REQ Conventions

Throughout execution, enforce these conventions:
- **Commit messages:** ALL commits MUST be prefixed with `REQ-{id}` (read from plan header)
- **Code comments:** ALL code comments MUST carry `// REQ-{id} {description}`
- Extract `REQ-{id}` from the plan header's `**REQ:**` field

## The Process

### Step 1: Load and Review Plan
1. Read plan file
2. Extract `REQ-{id}` from plan header
3. Review critically - identify any questions or concerns about the plan
4. If concerns: Raise them with your human partner before starting
5. If no concerns: Create TodoWrite and proceed

### Step 2: Safety Check — External Dependencies

<HARD-GATE>
Before running ANY test (unit or integration), scan project configuration files for external dependency connections. This check MUST pass before proceeding.
</HARD-GATE>

1. Scan config files: `application.yml`, `application.properties`, `.env`, `config.*`, `docker-compose.yml`, connection string files
2. Check ALL database/middleware connection addresses:
   - DB/MySQL/PostgreSQL: host
   - Elasticsearch: host
   - Redis: host
   - MongoDB: host
   - RabbitMQ/Kafka: broker addresses
   - Any other data-storage dependencies
3. **If ALL connections point to localhost/127.0.0.1:** Proceed normally
4. **If ANY non-localhost connection detected:**

   ⚠️ **STOP execution immediately.** Prompt user:
   ```
   Detected external dependency connections pointing to non-local environment:
   - {dependency}: {host}:{port}
   - {dependency}: {host}:{port}
   Continuing may cause data modification/deletion in non-local environments.
   Confirm to continue? [Y/N]
   ```
   Proceed ONLY after explicit user confirmation.

### Step 3: Execute Batch
**Default: First 3 tasks**

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Ensure ALL commit messages have `REQ-{id}` prefix
4. Ensure ALL code comments have `// REQ-{id}` annotation
5. Run verifications as specified
6. Mark as completed

### Step 4: Report
When batch complete:
- Show what was implemented
- Show verification output
- Say: "Ready for feedback."

### Step 5: Continue
Based on feedback:
- Apply changes if needed
- Execute next batch
- Repeat until all tasks complete

### Step 6: Testing Verification

<HARD-GATE>
After ALL tasks are complete, you MUST execute the testing.md verification before proceeding to Step 7. Do NOT skip this step.
</HARD-GATE>

1. Read `testing.md` from the same specs directory
2. Execute end-to-end test cases one by one
3. Record result for each case (PASS / FAIL)
4. **All PASS** → Proceed to Step 7
5. **Any FAIL:**
   a. Analyze failure cause
   b. If code issue → Fix code, re-run the failing test case
   c. If `testing.md` case itself is problematic → **STOP immediately**, report to user:
      ```
      testing.md case #{N} may have an issue:
      - Case: {case title}
      - Expected: {expected}
      - Actual: {actual}
      - Analysis: {why this might be a test case issue}
      Please confirm whether to adjust the test case or fix the code.
      ```

**ABSOLUTELY FORBIDDEN to modify testing.md.** If you believe a test case is wrong, you MUST stop and report to the user. Never edit, delete, or alter testing.md content.

### Step 7: Complete Development

After all tasks complete and testing.md verification passes:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use superpowers:finishing-a-development-branch
- Follow that skill to verify tests, present options, execute choice

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker mid-batch (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly
- Non-localhost external dependency detected (see Step 2)
- testing.md case appears to have issues (see Step 6)

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember
- Extract and use REQ-{id} from plan header for ALL commits and comments
- Review plan critically first
- Run safety check before any tests
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Between batches: just report and wait
- Stop when blocked, don't guess
- Execute testing.md after all tasks, NEVER modify it
- Never start implementation on main/master branch without explicit user consent

## Integration

**Required workflow skills:**
- **superpowers:using-git-worktrees** - REQUIRED: Set up isolated workspace before starting
- **superpowers:writing-plans** - Creates the plan this skill executes
- **superpowers:finishing-a-development-branch** - Complete development after all tasks
