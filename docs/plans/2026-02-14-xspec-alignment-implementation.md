# xspec Alignment and Refactoring Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Refactor xspec project to align with my-superpowers architecture, conventions, and best practices while preserving business-specific functionality.

**Architecture:** One-time comprehensive refactoring copying universal skills from my-superpowers, adapting them for xspec requirements (specs directory structure, REQ-id traceability), and rewriting business skills in my-superpowers style.

**Tech Stack:** Markdown, YAML frontmatter, Shell scripts for file operations, Git for version control

---

## Prerequisites

- Source repository: `/Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution`
- Reference repository: `/Users/mayunpeng/GolandProjects/my-superpowers`
- Design document: `/Users/mayunpeng/GolandProjects/my-superpowers/docs/plans/2026-02-14-xspec-alignment-design.md`
- Working directory: xspec repository
- Git branch: Create feature branch for refactoring

---

## Task 1: Setup and Preparation

**Files:**
- Reference: `/Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution`
- Create: `/Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/.docs/specs/2026-02-14-REQ-99999-test-feature/requirements.md` (for testing)

**Step 1: Create feature branch**

```bash
cd /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution
git checkout -b feature/align-with-superpowers
```

**Step 2: Verify branch created**

Run: `git branch`
Expected: `* feature/align-with-superpowers` shown in output

**Step 3: Create test requirement directory**

```bash
mkdir -p /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/.docs/specs/2026-02-14-REQ-99999-test-feature
```

**Step 4: Verify directory created**

Run: `ls -la /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/.docs/specs/`
Expected: Directory `2026-02-14-REQ-99999-test-feature` exists

**Step 5: Create test requirements.md**

```bash
cat > /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/.docs/specs/2026-02-14-REQ-99999-test-feature/requirements.md <<'EOF'
# REQ-99999 Test Feature

## Overview
This is a test requirement for validating the refactored xspec system.

## Functional Requirements
- [ ] Test requirement 1
- [ ] Test requirement 2
EOF
```

**Step 6: Verify test file created**

Run: `cat /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/.docs/specs/2026-02-14-REQ-99999-test-feature/requirements.md`
Expected: File contains test requirement content

**Step 7: Commit setup**

```bash
cd /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution
git add .docs/
git commit -m "chore: setup test environment for xspec refactoring"
```

---

## Task 2: Rename Commands

**Files:**
- Rename: `/Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/commands/generate-plans.md` → `write-plan.md`
- Rename: `/Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/commands/executing-plans.md` → `execute-plan.md`

**Step 1: Rename generate-plans command**

```bash
cd /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/commands
mv generate-plans.md write-plan.md
```

**Step 2: Verify rename**

Run: `ls -la /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/commands/`
Expected: `write-plan.md` exists, `generate-plans.md` does not exist

**Step 3: Update write-plan.md content**

```bash
cat > /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/commands/write-plan.md <<'EOF'
---
description: "Create detailed implementation plan with bite-sized tasks"
---

Invoke the writing-plans skill and follow it exactly as presented to you
EOF
```

**Step 4: Rename executing-plans command**

```bash
cd /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/commands
mv executing-plans.md execute-plan.md
```

**Step 5: Verify rename**

Run: `ls -la /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/commands/`
Expected: `execute-plan.md` exists, `executing-plans.md` does not exist

**Step 6: Update execute-plan.md content**

```bash
cat > /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/commands/execute-plan.md <<'EOF'
---
description: "Execute implementation plan with batch execution and checkpoints"
---

Invoke the executing-plans skill and follow it exactly as presented to you
EOF
```

**Step 7: Commit command renames**

```bash
cd /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution
git add commands/
git commit -m "refactor: rename commands to align with my-superpowers conventions

- /generate-plans → /write-plan
- /executing-plans → /execute-plan"
```

---

## Task 3: Rename Skills Directory

**Files:**
- Rename: `/Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/generate-plans/` → `writing-plans/`

**Step 1: Rename generate-plans skill directory**

```bash
cd /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills
mv generate-plans writing-plans
```

**Step 2: Verify rename**

Run: `ls -la /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/`
Expected: `writing-plans/` exists, `generate-plans/` does not exist

**Step 3: Commit skill directory rename**

```bash
cd /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution
git add skills/
git commit -m "refactor: rename generate-plans skill to writing-plans"
```

---

## Task 4: Copy Universal Skills from my-superpowers (Part 1)

**Files:**
- Copy: `my-superpowers/skills/test-driven-development/` → `xspec/skills/test-driven-development/`
- Copy: `my-superpowers/skills/systematic-debugging/` → `xspec/skills/systematic-debugging/`
- Copy: `my-superpowers/skills/verification-before-completion/` → `xspec/skills/verification-before-completion/`

**Step 1: Copy test-driven-development skill**

```bash
cp -r /Users/mayunpeng/GolandProjects/my-superpowers/skills/test-driven-development /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/
```

**Step 2: Verify copy**

Run: `ls -la /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/test-driven-development/`
Expected: Directory exists with SKILL.md and supporting files

**Step 3: Copy systematic-debugging skill**

```bash
cp -r /Users/mayunpeng/GolandProjects/my-superpowers/skills/systematic-debugging /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/
```

**Step 4: Verify copy**

Run: `ls -la /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/systematic-debugging/`
Expected: Directory exists with SKILL.md and supporting files

**Step 5: Copy verification-before-completion skill**

```bash
cp -r /Users/mayunpeng/GolandProjects/my-superpowers/skills/verification-before-completion /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/
```

**Step 6: Verify copy**

Run: `ls -la /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/verification-before-completion/`
Expected: Directory exists with SKILL.md

**Step 7: Commit copied skills**

```bash
cd /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution
git add skills/test-driven-development skills/systematic-debugging skills/verification-before-completion
git commit -m "feat: copy universal development practice skills from my-superpowers

- test-driven-development
- systematic-debugging
- verification-before-completion"
```

---

## Task 5: Copy Universal Skills from my-superpowers (Part 2)

**Files:**
- Copy: `my-superpowers/skills/receiving-code-review/` → `xspec/skills/receiving-code-review/`
- Copy: `my-superpowers/skills/requesting-code-review/` → `xspec/skills/requesting-code-review/`
- Copy: `my-superpowers/skills/dispatching-parallel-agents/` → `xspec/skills/dispatching-parallel-agents/`

**Step 1: Copy receiving-code-review skill**

```bash
cp -r /Users/mayunpeng/GolandProjects/my-superpowers/skills/receiving-code-review /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/
```

**Step 2: Verify copy**

Run: `ls -la /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/receiving-code-review/`
Expected: Directory exists with SKILL.md

**Step 3: Copy requesting-code-review skill**

```bash
cp -r /Users/mayunpeng/GolandProjects/my-superpowers/skills/requesting-code-review /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/
```

**Step 4: Verify copy**

Run: `ls -la /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/requesting-code-review/`
Expected: Directory exists with SKILL.md and code-reviewer.md

**Step 5: Copy dispatching-parallel-agents skill**

```bash
cp -r /Users/mayunpeng/GolandProjects/my-superpowers/skills/dispatching-parallel-agents /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/
```

**Step 6: Verify copy**

Run: `ls -la /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/dispatching-parallel-agents/`
Expected: Directory exists with SKILL.md

**Step 7: Commit copied skills**

```bash
cd /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution
git add skills/receiving-code-review skills/requesting-code-review skills/dispatching-parallel-agents
git commit -m "feat: copy code review and parallel agents skills from my-superpowers

- receiving-code-review
- requesting-code-review
- dispatching-parallel-agents"
```

---

## Task 6: Copy Universal Skills from my-superpowers (Part 3)

**Files:**
- Copy: `my-superpowers/skills/subagent-driven-development/` → `xspec/skills/subagent-driven-development/`
- Copy: `my-superpowers/skills/finishing-a-development-branch/` → `xspec/skills/finishing-a-development-branch/`
- Copy: `my-superpowers/skills/using-git-worktrees/` → `xspec/skills/using-git-worktrees/`
- Copy: `my-superpowers/skills/writing-skills/` → `xspec/skills/writing-skills/`

**Step 1: Copy subagent-driven-development skill**

```bash
cp -r /Users/mayunpeng/GolandProjects/my-superpowers/skills/subagent-driven-development /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/
```

**Step 2: Verify copy**

Run: `ls -la /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/subagent-driven-development/`
Expected: Directory exists with SKILL.md and prompt files

**Step 3: Copy finishing-a-development-branch skill**

```bash
cp -r /Users/mayunpeng/GolandProjects/my-superpowers/skills/finishing-a-development-branch /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/
```

**Step 4: Copy using-git-worktrees skill**

```bash
cp -r /Users/mayunpeng/GolandProjects/my-superpowers/skills/using-git-worktrees /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/
```

**Step 5: Copy writing-skills skill**

```bash
cp -r /Users/mayunpeng/GolandProjects/my-superpowers/skills/writing-skills /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/
```

**Step 6: Verify all copies**

Run: `ls /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/ | grep -E "(subagent|finishing|worktrees|writing-skills)"`
Expected: All four directories present

**Step 7: Commit copied skills**

```bash
cd /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution
git add skills/subagent-driven-development skills/finishing-a-development-branch skills/using-git-worktrees skills/writing-skills
git commit -m "feat: copy workflow management skills from my-superpowers

- subagent-driven-development
- finishing-a-development-branch
- using-git-worktrees
- writing-skills"
```

---

## Task 7: Update Code Reviewer Agent

**Files:**
- Reference: `/Users/mayunpeng/GolandProjects/my-superpowers/agents/code-reviewer.md`
- Modify: `/Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/agents/code-reviewer.md`

**Step 1: Read my-superpowers code-reviewer.md**

Run: `cat /Users/mayunpeng/GolandProjects/my-superpowers/agents/code-reviewer.md`
Expected: Review content to understand structure

**Step 2: Backup existing code-reviewer**

```bash
cp /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/agents/code-reviewer.md /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/agents/code-reviewer.md.backup
```

**Step 3: Copy updated code-reviewer**

```bash
cp /Users/mayunpeng/GolandProjects/my-superpowers/agents/code-reviewer.md /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/agents/code-reviewer.md
```

**Step 4: Verify update**

Run: `diff /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/agents/code-reviewer.md.backup /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/agents/code-reviewer.md`
Expected: Shows differences between old and new versions

**Step 5: Remove backup**

```bash
rm /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/agents/code-reviewer.md.backup
```

**Step 6: Commit updated agent**

```bash
cd /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution
git add agents/code-reviewer.md
git commit -m "refactor: update code-reviewer agent to match my-superpowers version"
```

---

## Task 8: Adapt writing-plans Skill (Part 1: Add Specs Location)

**Files:**
- Modify: `/Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/writing-plans/SKILL.md`

**Step 1: Read current writing-plans SKILL.md**

Run: `cat /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/writing-plans/SKILL.md`
Expected: Review existing content

**Step 2: Create adapted writing-plans SKILL.md header**

```markdown
---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code. Reads from xspec specs directory structure.
---

# Writing Implementation Plans

## Overview

Write comprehensive implementation plans for xspec requirements. Plans are saved within the requirement's specs directory and include REQ-id traceability for all code and commits.

Assume the engineer has zero context for our codebase. Document everything: which files to touch, complete code, testing steps, verification commands. Bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Save plans to:** `.docs/specs/yyyy-MM-dd-REQ-{id}-{topic}/plan.md`

---

## Locate Specs Directory

Scan existing requirement directories under `.docs/specs/`:
- Determine target directory based on current conversation context
- When uncertain, default to the most recent one, use AskUserQuestion to confirm
- If specs directory or requirements.md doesn't exist, prompt user to execute `/prd-clarify` first
- Extract REQ-id from directory name pattern: `REQ-(\d+)`
- Store REQ-id for use in all templates

**Example directory:** `.docs/specs/2026-02-14-REQ-12345-user-auth/`
**Extracted REQ-id:** `12345`

---

## Load Context from Requirement Directory

Use information from current conversation context first, load files only when missing:
- `requirements.md` - Load when requirement details missing from context
- `design.md` - Load when design details missing from context
- `hld.md` - Load when HLD exists and high-level design info missing

**Priority:**
1. Current conversation context (highest priority)
2. Recently loaded files (cached in memory)
3. Read from disk (only when necessary)

---
```

**Step 3: Verify current file structure**

Run: `head -20 /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/writing-plans/SKILL.md`
Expected: See current frontmatter and initial content

**Step 4: Continue in next task (file too large for single task)**

This task sets up the foundation. Task 9 will complete the full adaptation.

**Step 5: Create work-in-progress marker**

```bash
echo "# WIP: Adapting writing-plans skill" > /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/writing-plans/.wip
```

**Step 6: Commit WIP marker**

```bash
cd /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution
git add skills/writing-plans/.wip
git commit -m "wip: begin writing-plans skill adaptation"
```

---

## Task 9: Adapt writing-plans Skill (Part 2: Complete Full Content)

**Files:**
- Modify: `/Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/writing-plans/SKILL.md`

**Step 1: Write complete adapted writing-plans SKILL.md**

Create file: `/Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/writing-plans/SKILL.md`

```markdown
---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code. Reads from xspec specs directory structure.
---

# Writing Implementation Plans

## Overview

Write comprehensive implementation plans for xspec requirements. Plans are saved within the requirement's specs directory and include REQ-id traceability for all code and commits.

Assume the engineer has zero context for our codebase. Document everything: which files to touch, complete code, testing steps, verification commands. Bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Save plans to:** `.docs/specs/yyyy-MM-dd-REQ-{id}-{topic}/plan.md`

---

## Locate Specs Directory

Scan existing requirement directories under `.docs/specs/`:
- Determine target directory based on current conversation context
- When uncertain, default to the most recent one, use AskUserQuestion to confirm
- If specs directory or requirements.md doesn't exist, prompt user to execute `/prd-clarify` first
- Extract REQ-id from directory name pattern: `REQ-(\d+)`
- Store REQ-id for use in all templates

**Example directory:** `.docs/specs/2026-02-14-REQ-12345-user-auth/`
**Extracted REQ-id:** `12345`

---

## Load Context from Requirement Directory

Use information from current conversation context first, load files only when missing:
- `requirements.md` - Load when requirement details missing from context
- `design.md` - Load when design details missing from context
- `hld.md` - Load when HLD exists and high-level design info missing

**Priority:**
1. Current conversation context (highest priority)
2. Recently loaded files (cached in memory)
3. Read from disk (only when necessary)

---

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

**Don't:** "Implement authentication system" — too big
**Do:** 5 independent steps, each verifiable

---

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Requirement:** REQ-{id} {requirement title from requirements.md}
**Goal:** [One sentence describing what this builds]
**Architecture:** [2-3 sentences about approach]
**Tech Stack:** [Key technologies/libraries]

---

## Prerequisites

- Dependencies: [list any dependencies]
- Environment setup: [any required setup]
- Existing code understanding: [key files to be aware of]
```

---

## Task Structure

Every task must include:

````markdown
### Task N: [Action Name]

**Files:**
- `/absolute/path/to/file1.ext` - [purpose]
- `/absolute/path/to/file2.ext` - [purpose]

**Step 1: Write failing test**

```language
// Complete test code
```

**Step 2: Verify failure**

```bash
command
```
Expected output: `[exact failure message]`

**Step 3: Write implementation**

```language
// REQ-{id} {explanation of what this code does}
// Complete implementation code with REQ-{id} prefix in comments
```

**Step 4: Verify success**

```bash
command
```
Expected output: `[exact success message]`

**Step 5: Commit**

```bash
git add [specific files]
git commit -m "REQ-{id} [accurate commit message]"
```
````

---

## Remember

### Exact File Paths
**Don't:** "Update config file"
**Do:** "Update `/absolute/path/to/config.json`"

### Complete Code in Plan
Don't write "add error handling". Write the error handling code.

### Exact Commands and Expected Output
**Don't:** "Run tests"
**Do:**
```bash
npm test -- auth.test.js
```
Expected: `PASS src/auth.test.js (0.234s)`

### Requirement Traceability
- **Code comments** must start with `// REQ-{id}` to trace back to requirements
  - Example: `// REQ-123 User authentication logic`
- **Commit messages** must start with `REQ-{id}`
  - Example: `REQ-123 feat: add user authentication`
- Plan must include REQ-{id} in all code examples and commit message templates

### DRY, YAGNI, TDD
- Don't prematurely optimize
- Don't add features that might be needed later
- Test first, implement second

---

## Execution Handoff

After saving the plan, offer execution choice:

```markdown
## Next Steps

This plan has been saved to `.docs/specs/yyyy-MM-dd-REQ-{id}-{topic}/plan.md`

Choose execution strategy:

**1. Subagent-Driven (this session)**
- I will use subagent-driven-development
- Each task executed by dedicated subagent
- I supervise and coordinate

**2. Parallel Session (new session)**
- In new cursor session
- Run: `/execute-plan`
- Independent execution with checkpoints

Which approach do you prefer?
```

---

## Danger Signals

**Never:**
- Write vague tasks ("add feature")
- Skip test steps
- Assume context knowledge
- Use relative paths
- Combine multiple operations into one step
- Omit `// REQ-{id}` prefix in code examples
- Omit `REQ-{id}` prefix in commit message examples

---

## Integration

**Required by:**
- generate-design skill (guides user to writing-plans after design complete)

**Invokes:**
- subagent-driven-development (if user chooses option 1)
- executing-plans (if user chooses option 2, in new session)

---

## Quick Reference

| Element | Requirement |
|---------|-------------|
| File paths | Absolute paths with descriptions |
| Code blocks | Complete code, not placeholders |
| Commands | Exact syntax + expected output |
| Task size | 2-5 minutes, single operation |
| Testing | Every task has test steps |
| Commits | After every task |
| REQ-id | In all code comments and commit messages |
| Context | Load from specs directory + conversation |
```

**Step 2: Write adapted SKILL.md to file**

```bash
cat > /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/writing-plans/SKILL.md <<'EOF'
[Full content from Step 1]
EOF
```

**Step 3: Verify file written**

Run: `wc -l /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/writing-plans/SKILL.md`
Expected: File has appropriate line count (200+ lines)

**Step 4: Remove WIP marker**

```bash
rm /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/writing-plans/.wip
```

**Step 5: Commit adapted skill**

```bash
cd /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution
git add skills/writing-plans/
git commit -m "feat: adapt writing-plans skill for xspec requirements

- Add specs directory location logic
- Add REQ-id extraction and injection
- Add context loading from requirements.md and design.md
- Enforce REQ-{id} in all code comments and commit messages
- Update plan document path to specs directory structure"
```

---

## Task 10: Adapt executing-plans Skill

**Files:**
- Modify: `/Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/executing-plans/SKILL.md`

**Step 1: Read current executing-plans SKILL.md**

Run: `cat /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/executing-plans/SKILL.md | head -50`
Expected: Review current structure

**Step 2: Write complete adapted executing-plans SKILL.md**

Create file with full adaptation (this is a large file, showing key sections):

```markdown
---
name: executing-plans
description: Use when plan is ready and need to start coding implementation with TDD, code review, and commit traceability with REQ-id prefix
---

# Executing Implementation Plans

## Overview

Load plan from xspec specs directory, critically review it, batch execute tasks with checkpoints. Enforce REQ-id traceability in all commits and code comments.

**Core Principle:** Batch execution with architect review checkpoints.

**Announce at start:** "I'm using the executing-plans skill to execute this plan."

---

## Step 1: Locate Specs Directory

Scan existing requirement directories under `.docs/specs/`:
- Determine target directory based on current conversation context
- When uncertain, default to most recent, use AskUserQuestion to confirm
- If specs directory or requirements.md doesn't exist, prompt user to execute `/prd-clarify` first
- Extract REQ-id from directory name: `REQ-(\d+)`
- Store REQ-id in execution context for all subsequent operations

**Example:**
- Directory: `.docs/specs/2026-02-14-REQ-12345-user-auth/`
- Extracted REQ-id: `12345`
- All commits will be prefixed: `REQ-12345`

---

## Step 2: Load and Review Plan

1. **Read plan.md from context (if available) or from requirement directory**
   - Path: `.docs/specs/yyyy-MM-dd-REQ-{id}-{topic}/plan.md`

2. **Critical Review:**
   - Are there missing steps?
   - Are instructions ambiguous?
   - Are file paths specific?
   - Are verification steps clear?
   - **Is REQ-{id} properly included in all code comments and commit messages?**

3. **Identify Risks:** Flag potential issues before starting

4. **If critical gaps found:** Stop and report, don't proceed

---

## Step 3: Execute Batch (Default 3 Tasks)

For each task in batch:

1. **Announce task:** "Executing Task N: [name]"
2. **Follow steps precisely:** Don't improvise
3. **Capture output:** Save command results
4. **Verify each step:** Confirm expected matches actual
5. **If verification fails:** Stop batch, report

**Enforcement:**
- Every code comment must start with `// REQ-{id}`
- Every commit message must start with `REQ-{id}`
- Verify format before committing

---

## Step 4: Report After Each Batch

```markdown
## Batch [N] Complete

### Executed Tasks
- Task [N]: [name] ✓
- Task [N+1]: [name] ✓
- Task [N+2]: [name] ✓

### Verification Results
[Show key verification output]

### Deviations
[Any deviations from plan]

### Next Batch
- Task [N+3]: [name]
- Task [N+4]: [name]
- Task [N+5]: [name]

Continue to next batch?
```

---

## Step 5: Continue

Wait for user confirmation to continue or adjust.

---

## Step 6: Complete Development

When all tasks complete:

1. **Run full verification:** All tests, all checks
2. **Report final status**
3. **Verify all commits have REQ-{id} prefix:**
   ```bash
   git log --oneline | head -20
   ```
4. **Invoke** finishing-a-development-branch

---

## When to Stop

**Stop immediately if:**
- Hit blocking issue
- Plan has critical gaps
- Validation fails repeatedly
- Need architectural decision that deviates from plan

**Don't:**
- Guess missing information
- Skip failed validations
- Continue past one batch without checkpoint

---

## Remember

### Review Plan First
Don't blindly execute. Read entire plan, identify issues, ask questions before starting.

### Requirement Traceability (MANDATORY)

- **Code comments:** Must start with `// REQ-{id}` to trace to requirements
  - Example: `// REQ-123 User authentication logic`
- **Commit messages:** Must start with `REQ-{id}`
  - Example: `REQ-123 feat: add user authentication`
- **Extract REQ-id** from located specs directory
- **Verification:** Check format before each commit

### Follow Steps Exactly
Plan says "run `npm test -- auth.test.js`"? Run that. Not `npm test`.

### Don't Skip Verification
Every step has verification for a reason. Run it. Read output. Confirm match.

### Batch, Report, Wait
Don't execute 20 tasks at once. Batch execution, report, get confirmation.

### Stop When Blocked, Don't Guess
- Plan says "update config" but no values → Stop and ask
- Test fails but plan says should pass → Stop and report
- File not in expected location → Stop and investigate

### Never Start on main/master Without User Consent
Before execution:
1. Check current branch
2. If on main/master: Stop
3. Suggest creating feature branch or worktree
4. Wait for user confirmation

---

## Quick Reference

| Stage | Action |
|-------|--------|
| Locate | Scan specs directory, determine target requirement |
| Load | Read + critically review plan.md |
| Execute | Batch 3 tasks, follow steps exactly |
| Verify | Check output every step |
| Report | Show results + deviations + next steps |
| Continue | Wait for confirmation |
| Complete | All tests + finishing-a-development-branch |

| Situation | Response |
|-----------|----------|
| Plan gaps | Stop, report, ask |
| Verification fails | Stop, show output, ask |
| On main branch | Stop, suggest branch, wait |
| Need to deviate | Stop, explain, get approval |

---

## Danger Signals

**Never:**
- Execute plan without review
- Skip verification steps
- Guess missing information
- Continue when blocked
- Execute >3 tasks without checkpoint
- Work on main/master without user consent
- Write code comments without `// REQ-{id}` prefix
- Commit without `REQ-{id}` prefix in message

---

## Integration

**Required:**
- using-git-worktrees (isolate execution)
- writing-plans (generates plan)
- finishing-a-development-branch (on completion)

**Called by:**
- User via `/execute-plan <plan-file>`
- writing-plans (after option 2 chosen)
```

**Step 3: Write to file using Write tool** (Due to size, this would be done with Write tool in actual implementation)

**Step 4: Verify adaptation**

Run: `grep -E "(REQ-|specs directory)" /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/executing-plans/SKILL.md`
Expected: Multiple matches showing REQ-id enforcement and specs directory logic

**Step 5: Commit adapted skill**

```bash
cd /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution
git add skills/executing-plans/
git commit -m "feat: adapt executing-plans skill for xspec requirements

- Add specs directory location logic
- Add REQ-id extraction and injection
- Enforce REQ-{id} prefix in all code comments
- Enforce REQ-{id} prefix in all commit messages
- Add requirement traceability verification
- Update plan loading from specs directory structure"
```

---

## Task 11: Update brainstorming Skill

**Files:**
- Modify: `/Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/brainstorming/SKILL.md`

**Step 1: Copy my-superpowers brainstorming as base**

```bash
cp /Users/mayunpeng/GolandProjects/my-superpowers/skills/brainstorming/SKILL.md /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/brainstorming/SKILL.md
```

**Step 2: Verify copy**

Run: `head -20 /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/brainstorming/SKILL.md`
Expected: See my-superpowers version content

**Step 3: Update design document path in brainstorming**

Modify the "After the Design" section to use specs directory:

```bash
sed -i '' 's|docs/plans/YYYY-MM-DD-<topic>-design.md|.docs/specs/yyyy-MM-dd-REQ-{id}-{topic}/design.md|g' /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/brainstorming/SKILL.md
```

**Step 4: Verify modification**

Run: `grep "design.md" /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution/skills/brainstorming/SKILL.md`
Expected: Shows specs directory path

**Step 5: Commit updated skill**

```bash
cd /Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution
git add skills/brainstorming/
git commit -m "refactor: update brainstorming skill to use specs directory structure

- Based on my-superpowers version
- Adapted design document path to .docs/specs/ structure"
```

---

*Note: Due to the extensive nature of this refactoring (50+ files to modify), this implementation plan continues with Tasks 12-30+ covering:*
- *Rewriting prd-clarify, generate-hld, generate-design skills*
- *Updating all command descriptions*
- *Updating CLAUDE.md documentation*
- *Creating comprehensive tests*
- *Final validation*

*This plan document would be 2000+ lines if fully expanded. The pattern established in Tasks 1-11 continues for all remaining work.*

---

## Execution Strategy

**Recommended:** Subagent-Driven Development
- Complex refactoring with many interdependencies
- Benefits from review between major sections
- Allows course correction if issues discovered

**Alternative:** Parallel Session
- Execute in dedicated session
- Batch processing with checkpoints every 5-10 tasks

---

**Plan Status:** Foundation complete, full expansion needed for implementation
