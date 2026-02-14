# xspec Project Alignment and Refactoring Design

> **Metadata:**
> - Created: 2026-02-14
> - Project: xspec SDD Workflow Automation Tool
> - Objective: Align xspec implementation with my-superpowers architecture and conventions
> - Author: Claude Sonnet 4.5

---

## Executive Summary

This design document outlines a comprehensive refactoring of the xspec project (located at `/Users/mayunpeng/GolandProjects/pgs-team-skills/xspec/backend/solution`) to maximize alignment with the my-superpowers repository while preserving business-specific functionality.

**Approach:** One-time comprehensive refactoring

**Scope:** All skills, commands, and documentation

**Key Changes:**
- Rename commands and skills to match my-superpowers conventions
- Adapt universal development skills based on my-superpowers implementations
- Rewrite business-specific skills in my-superpowers style
- Add requirement traceability (REQ-id) throughout the system
- Unify error handling, progress feedback, and user interaction patterns
- Complete documentation overhaul

---

## 1. Architecture and Adaptation Strategy

### Core Principle

**Use my-superpowers as the blueprint, adapt for xspec business requirements.**

### Project Structure

```
xspec/backend/solution/
├── commands/              # User-invocable commands (thin wrappers)
│   ├── prd-clarify.md    # Business-specific: PRD clarification
│   ├── generate-hld.md   # Business-specific: High-level design
│   ├── generate-design.md # Business-specific: Detailed design
│   ├── write-plan.md     # Invokes writing-plans skill
│   └── execute-plan.md   # Invokes executing-plans skill
│
├── skills/
│   ├── prd-clarify/      # Business-specific: PRD clarification flow
│   ├── generate-hld/     # Business-specific: Microservices HLD
│   ├── generate-design/  # Business-specific: Technical design
│   ├── system-design/    # Business-specific: Architecture understanding
│   ├── get-service-name/ # Business-specific: Service name inference
│   │
│   └── [Universal Development Skills - Adapted from my-superpowers]
│       ├── writing-plans/
│       ├── executing-plans/
│       ├── brainstorming/
│       ├── test-driven-development/
│       ├── systematic-debugging/
│       ├── receiving-code-review/
│       ├── requesting-code-review/
│       ├── verification-before-completion/
│       ├── dispatching-parallel-agents/
│       ├── subagent-driven-development/
│       ├── finishing-a-development-branch/
│       ├── using-git-worktrees/
│       └── writing-skills/
│
└── agents/
    └── code-reviewer.md  # Align with my-superpowers version
```

### Skills Classification

#### Category 1: Business Flow Skills (Fully Custom)
- `prd-clarify` - PRD requirements clarification
- `generate-hld` - Microservices high-level design
- `generate-design` - Detailed technical design
- `system-design` - Microservices architecture understanding
- `get-service-name` - Service name inference

**Characteristics:** xspec-specific, rewritten in my-superpowers style

#### Category 2: Development Flow Skills (Adaptation Required)

**Core skills requiring significant adaptation:**

**writing-plans:**
- Baseline: my-superpowers version
- Adaptations:
  - Document path: `docs/plans/` → `.docs/specs/yyyy-MM-dd-REQ-{id}-{topic}/plan.md`
  - Add REQ-id extraction from specs directory
  - Add specs directory location logic
  - Enforce `// REQ-{id}` in code comment templates
  - Enforce `REQ-{id}` in commit message templates
  - Load context from `requirements.md`, `design.md`

**executing-plans:**
- Baseline: my-superpowers version
- Adaptations:
  - Plan path: `.docs/specs/REQ-{id}/plan.md`
  - Auto-extract and inject REQ-id into execution context
  - Enforce `// REQ-{id}` prefix in all code comments
  - Enforce `REQ-{id}` prefix in all commit messages
  - Add requirement traceability verification checks

**brainstorming:**
- Baseline: my-superpowers version
- Adaptations:
  - Design document path: `.docs/specs/yyyy-MM-dd-REQ-{id}-{topic}/design.md`
  - May be replaced by `prd-clarify` + `generate-design` workflow
  - Or kept as general design flow outputting to specs directory

#### Category 3: Development Practice Skills (Copy or Minor Tweaks)

**Minimal changes needed:**
- `test-driven-development` - Add REQ-id comment requirements
- `systematic-debugging` - Direct copy
- `receiving-code-review` - Direct copy
- `requesting-code-review` - Adapt code-reviewer config
- `verification-before-completion` - Direct copy
- `dispatching-parallel-agents` - Direct copy
- `subagent-driven-development` - Adapt plan path references
- `finishing-a-development-branch` - Direct copy
- `using-git-worktrees` - Direct copy
- `writing-skills` - Direct copy

### Sync Strategy

**Selected Approach: Periodic Manual Sync**
- Copy universal skills from my-superpowers as templates
- Adapt for xspec-specific requirements
- Document adaptation points for future sync
- Maintain independent deployment capability

---

## 2. File Changes and Renaming Plan

### Command File Renames

**Files to rename:**
```
commands/generate-plans.md  → commands/write-plan.md
commands/executing-plans.md → commands/execute-plan.md
```

**Files to keep but update content:**
```
commands/prd-clarify.md      - Update to match new style
commands/generate-hld.md     - Update to match new style
commands/generate-design.md  - Update to match new style
```

**Command file content updates:**
- `write-plan.md`: Invoke `writing-plans` skill (not `generate-plans`)
- `execute-plan.md`: Invoke `executing-plans` skill (content also updated)

### Skills Directory Renames

**Directory to rename:**
```
skills/generate-plans/ → skills/writing-plans/
```

**Directories to keep but rewrite content:**
```
skills/prd-clarify/           - Rewrite in my-superpowers style
skills/generate-hld/          - Rewrite in my-superpowers style
skills/generate-design/       - Rewrite in my-superpowers style
skills/executing-plans/       - Adapt from my-superpowers version
skills/brainstorming/         - Adapt from my-superpowers version
skills/system-design/         - Keep but improve documentation
skills/get-service-name/      - Keep but improve documentation
```

**Skills to sync from my-superpowers:**
```
skills/test-driven-development/          - Copy + add REQ-id requirements
skills/systematic-debugging/             - Direct copy
skills/receiving-code-review/            - Direct copy
skills/requesting-code-review/           - Copy + adapt code-reviewer
skills/verification-before-completion/   - Direct copy
skills/dispatching-parallel-agents/      - Direct copy
skills/subagent-driven-development/      - Copy + adapt plan paths
skills/finishing-a-development-branch/   - Direct copy
skills/using-git-worktrees/              - Direct copy
skills/writing-skills/                   - Direct copy
```

### Supporting Files

**Templates to keep:**
```
skills/generate-design/trd-template.md        - Technical design template
skills/generate-design/deep-research-prompt.md - Research prompt template
```

**Subagent configs to update:**
```
skills/subagent-driven-development/implementer-prompt.md
skills/subagent-driven-development/spec-reviewer-prompt.md
skills/subagent-driven-development/code-quality-reviewer-prompt.md
```
Add REQ-id traceability requirements to all prompts.

**Code reviewer config:**
```
agents/code-reviewer.md                       - Update from my-superpowers
skills/requesting-code-review/code-reviewer.md - May be duplicate, merge if needed
```

### Documentation Updates

**Primary documentation:**
```
CLAUDE.md - Complete rewrite to reflect:
  - Correct command names (/write-plan, /execute-plan)
  - Complete workflow description
  - All available skills list
  - Usage examples
  - REQ-id traceability requirements
```

### Reference Updates Required

**Skill cross-references to update:**
1. `generate-design` guides users to `generate-plans` → change to `writing-plans`
2. `generate-hld` guides users to `generate-design` → keep
3. `prd-clarify` guides users to `generate-hld` or `generate-design` → keep

**Sub-skill invocations to verify:**
1. `generate-design` invokes `system-design` → keep
2. `generate-design` may use `brainstorming` interaction patterns → verify
3. `writing-plans` guides to `subagent-driven-development` or `executing-plans` → keep but update docs

**Command description updates:**
- All skill `description` fields must follow my-superpowers format
- Consistent style across all frontmatter

---

## 3. Key Skills Detailed Adaptation

### A. writing-plans Skill Adaptation

**Baseline:** `my-superpowers/skills/writing-plans/SKILL.md`

**Preserved Components:**
- Overall flow structure (bite-sized tasks, TDD workflow)
- Task structure (5-step pattern: test → verify fail → implement → verify pass → commit)
- Plan document header format
- Core principles (DRY, YAGNI, exact paths, complete code)

**Adaptations:**

#### 1. Plan Document Path
```markdown
# Original (my-superpowers)
**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

# Adapted (xspec)
**Save plans to:** `.docs/specs/yyyy-MM-dd-REQ-{id}-{topic}/plan.md`
```

#### 2. Add Specs Directory Location
```markdown
## Locate Specs Directory

Scan existing requirement directories under `.docs/specs/`:
- Determine target directory based on current conversation context
- When uncertain, default to the most recent one, use AskUserQuestion to confirm
- If specs directory or requirements.md doesn't exist, prompt user to execute `/prd-clarify` first
- Extract REQ-id from directory name pattern: `REQ-(\d+)`
```

#### 3. Add Context Loading
```markdown
## Load Context from Requirement Directory

Use information from current conversation context first, load files only when missing:
- `requirements.md` - Load when requirement details missing from context
- `design.md` - Load when design details missing from context
- `hld.md` - Load when HLD exists and high-level design info missing
```

#### 4. Update Plan Header Template
```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Requirement:** REQ-{id} {requirement title}
**Goal:** [One sentence describing what this builds]
**Architecture:** [2-3 sentences about approach]
**Tech Stack:** [Key technologies/libraries]

---
```

#### 5. Enforce REQ-id in Templates
```markdown
### Task N: [Component Name]

**Step 3: Write minimal implementation**

```language
// REQ-{id} {explanation of what this code does}
function example() {
    // REQ-{id} implementation details
}
```

**Step 5: Commit**

```bash
git add [specific files]
git commit -m "REQ-{id} [accurate commit message]"
```
```

#### 6. Update Execution Handoff
```markdown
## Execution Handoff

After saving the plan, offer execution choice:

**Plan saved to `.docs/specs/yyyy-MM-dd-REQ-{id}-{topic}/plan.md`. Choose execution approach:**

**1. Subagent-Driven (this session)**
- Use subagent-driven-development in current session
- Fresh subagent per task + code review between tasks
- Fast iteration with oversight

**2. Parallel Session (separate)**
- Open new session with /execute-plan
- Batch execution with checkpoints
- Independent execution context

**Which approach?**
```

### B. executing-plans Skill Adaptation

**Baseline:** `my-superpowers/skills/executing-plans/SKILL.md`

**Preserved Components:**
- Batch execution workflow (default 3 tasks per batch)
- Critical plan review before execution
- Stop conditions and error handling
- Batch reporting format

**Adaptations:**

#### 1. Add Specs Directory Location
```markdown
## Step 1: Locate Specs Directory

Scan existing requirement directories under `.docs/specs/`:
- Determine target directory based on current conversation context
- When uncertain, default to most recent, use AskUserQuestion to confirm
- If specs directory or requirements.md doesn't exist, prompt user to execute `/prd-clarify` first
- Extract REQ-id from directory name: `REQ-(\d+)`
- Store REQ-id in execution context for all subsequent operations
```

#### 2. Update Plan Loading
```markdown
## Step 2: Load and Review Plan

1. **Read plan.md from context (if available) or from requirement directory**
2. **Critical Review:**
   - Missing steps?
   - Ambiguous instructions?
   - Specific file paths?
   - Clear verification steps?
   - **REQ-{id} properly included in all code comments and commit messages?**
3. **Identify Risks:** Flag potential issues before starting
4. **If critical gaps found:** Stop and report, don't proceed
```

#### 3. Enforce REQ-id Traceability
```markdown
## Requirement Traceability (MANDATORY)

- **Code Comments:** All code must start with `// REQ-{id}` to trace back to requirements
  - Example: `// REQ-123 User authentication logic`
- **Commit Messages:** All commits must start with `REQ-{id}`
  - Example: `REQ-123 feat: add user authentication`
- **Extract REQ-id** from located specs directory to ensure traceability
- **Verification:** Before each commit, verify format compliance

**Never:**
- Write code comments without `// REQ-{id}` prefix
- Commit without `REQ-{id}` prefix in message
```

#### 4. Update Completion Step
```markdown
## Step 6: Complete Development

When all tasks complete:
1. **Run full verification:** All tests, all checks
2. **Report final status**
3. **Verify all commits have REQ-{id} prefix**
4. **Invoke** finishing-a-development-branch
```

### C. Business-Specific Skills Adaptation Principles

**Three core business skills follow unified adaptation pattern:**

#### prd-clarify
- Preserve: Core flow (PRD read → clarification → output requirements.md)
- Adapt to my-superpowers style:
  - Add explicit checklist
  - Use HARD-GATE mechanisms
  - Standardize error handling
  - Improve user interaction (one question at a time)
  - Follow brainstorming interaction patterns

#### generate-hld
- Preserve: Core flow (architecture analysis → capability definition → output hld.md)
- Adapt:
  - Unify document format
  - Add verification checkpoints
  - Standardize system-design skill invocation
  - Follow my-superpowers documentation style

#### generate-design
- Preserve: Core flow (technical design → output design.md)
- Adapt:
  - Unify document format
  - Standardize tech research subagent dispatch
  - Add design verification checkpoints
  - Clear handoff to writing-plans
  - Follow my-superpowers style and patterns

---

## 4. Flow Optimization and UX Improvements

### A. Unified Error Handling

**All skills adopt standardized error handling:**

#### 1. File Not Found Errors
```markdown
**Error Pattern:**
- Expected file doesn't exist
- Directory structure incorrect

**Handling:**
- Clear error message with expected path
- Suggest prerequisite command
- Example: "requirements.md not found. Please run `/prd-clarify` first."
```

#### 2. Missing Context Errors
```markdown
**Error Pattern:**
- Required information missing from context
- Unable to determine REQ-id or target directory

**Handling:**
- Use AskUserQuestion to gather missing info
- Provide clear options with descriptions
- Never proceed with assumptions
```

#### 3. Validation Failure Errors
```markdown
**Error Pattern:**
- Tests fail unexpectedly
- Commands don't produce expected output
- Format violations (missing REQ-id prefix)

**Handling:**
- Stop immediately, don't continue
- Show actual vs expected output
- Ask user for guidance before proceeding
```

### B. Enhanced Progress Feedback

**All long-running skills include progress indicators:**

#### 1. Skill Launch Announcement
```markdown
**At Skill Start:**
"正在使用 {skill-name} skill 执行 {purpose}。"

Examples:
"正在使用 writing-plans skill 创建实施计划。"
"正在使用 executing-plans skill 执行计划任务。"
```

#### 2. Stage Progress Indicators
```markdown
**During Execution:**
Show current step and total steps

Example in executing-plans:
"## 批次 1/4 执行中

已完成：
- ✓ Task 1: Write failing test
- ✓ Task 2: Implement authentication logic
- → Task 3: Add validation (in progress)

剩余：5 个任务"
```

#### 3. Checkpoint Confirmations
```markdown
**After Each Batch/Section:**
Present clear summary and ask for confirmation

Example:
"## 批次 1 完成

✓ 3 个任务已执行
✓ 所有测试通过
✓ 已提交 3 个 commits

是否继续下一批次？"
```

### C. Intelligent Context Awareness

**Reduce redundant file reads, optimize performance:**

#### 1. Prioritize Conversation Context
```markdown
**Context Priority:**
1. Current conversation context (highest priority)
2. Recently loaded files (cached in memory)
3. Read from disk (only when necessary)

**Implementation:**
- Explicitly state when using context vs reading files
- "Using requirement details from earlier conversation..."
- "Loading design.md as design details not found in context..."
```

#### 2. Smart Specs Directory Location
```markdown
**Smart Directory Location:**

When multiple specs directories exist:
1. Check conversation for explicitly mentioned REQ-id
2. If found, directly locate matching directory
3. If not found, default to most recent (by date in dirname)
4. Only ask user when ambiguous

**Example Logic:**
- User mentioned "REQ-123" → use that directory
- No mention → check .docs/specs/2026-02-14-REQ-* (today)
- Not found → use most recent
- Multiple candidates → ask user
```

#### 3. REQ-id Caching
```markdown
**REQ-id Persistence:**
Once determined in conversation:
- Store in conversation context
- Reuse for all subsequent operations
- Don't re-extract unless user works on different requirement
```

### D. Consistent User Interaction Patterns

**Unify interaction style across all skills:**

#### 1. Question Asking Pattern
```markdown
**Pattern: One Question at a Time**

Good:
- Single focused question
- 2-4 clear options when possible
- Descriptions for each option
- Allow "Other" for custom input

Bad:
- Multiple questions in one message
- Vague options without context
- Too many options (>4)
```

#### 2. Option Presentation Format
```markdown
**Use AskUserQuestion with:**
- header: Short label (max 12 chars)
- question: Complete question ending with "?"
- options: 2-4 choices with clear labels and descriptions
- multiSelect: true when choices not mutually exclusive

**Example:**
{
  "question": "此需求涉及多个微服务还是单个微服务？",
  "header": "复杂度",
  "multiSelect": false,
  "options": [
    {
      "label": "单个微服务",
      "description": "仅涉及当前服务的改动，可直接生成详细设计"
    },
    {
      "label": "多个微服务",
      "description": "需要跨服务协作，建议先生成高层架构设计"
    }
  ]
}
```

#### 3. Next Steps Guidance
```markdown
**Pattern: Clear Next Steps**

After completing a skill:
- Summarize what was accomplished
- Suggest logical next command
- Provide clear choice if multiple paths available
- Use skill names (not just descriptions)

**Example:**
"需求澄清完成，已保存到 requirements.md。

建议下一步：
- 简单需求（单个微服务）→ 执行 `/generate-design`
- 复杂需求（多个微服务）→ 执行 `/generate-hld`

你希望执行哪个？"
```

### E. Document Output Format Standards

**Unify all output document formats:**

#### 1. Markdown File Headers
```markdown
# REQ-{id} {Title}

> **Metadata:**
> - Created: YYYY-MM-DD
> - Requirement: REQ-{id}
> - Author: Claude Sonnet 4.5

---

[Content starts here]
```

#### 2. Code Block Formats
```markdown
**Always specify language:**
```python
# REQ-{id} Code description
def function():
    pass
```

**Never use generic:**
```
code here
```
```

#### 3. Task List Formats
```markdown
**Use checkboxes for trackable items:**

## Tasks
- [ ] Task 1: Description
- [ ] Task 2: Description
- [x] Task 3: Description (completed)

**Show progress:**
Progress: 1/3 tasks completed (33%)
```

---

## 5. Testing and Validation Strategy

### A. Refactoring Verification Strategy

**Staged validation ensures each change works correctly:**

#### Stage 1: Naming Refactor Validation
```markdown
**Validation Steps:**
1. Rename files and directories
2. Update all internal references
3. Verify command invocation:
   - `/write-plan` correctly invokes writing-plans skill
   - `/execute-plan` correctly invokes executing-plans skill
   - Old commands show deprecation warning (optional)

**Test Cases:**
- Run `/write-plan` without arguments → should show skill content
- Check skill loading logs for correct paths
- Verify no broken references in skill content
```

#### Stage 2: Skills Content Update Validation
```markdown
**For each adapted skill:**

1. **writing-plans validation:**
   - Create test requirement directory
   - Run skill and verify:
     - Correctly locates specs directory
     - Extracts REQ-id properly
     - Outputs plan.md to correct path
     - Plan includes REQ-id in all templates

2. **executing-plans validation:**
   - Use plan from stage 1
   - Run skill and verify:
     - Correctly loads plan from specs directory
     - REQ-id injected into execution context
     - Code comments include `// REQ-{id}` prefix
     - Commit messages include `REQ-{id}` prefix

3. **Business skills validation:**
   - prd-clarify: Test with sample PRD
   - generate-hld: Test with multi-service requirement
   - generate-design: Test with single-service requirement
```

#### Stage 3: Integration Flow Validation
```markdown
**End-to-End Workflow Test:**

Simulate complete workflow with test requirement:

1. `/prd-clarify` with sample PRD
   - Verify: requirements.md created in correct directory
   - Verify: REQ-id extracted and directory named correctly

2. `/generate-design` (or `/generate-hld` first for complex)
   - Verify: design.md created in same specs directory
   - Verify: Correctly loads requirements.md context

3. `/write-plan`
   - Verify: plan.md created in same specs directory
   - Verify: REQ-id present in all templates
   - Verify: References correct file paths

4. `/execute-plan`
   - Verify: Correctly loads plan.md
   - Verify: REQ-id enforced in commits and comments
   - Verify: Batch execution with checkpoints works

5. Final output verification:
   - All files in correct specs directory
   - All commits have REQ-{id} prefix
   - All code comments have // REQ-{id} prefix
```

### B. Quality Checklist

**Every skill must pass these checks:**

#### 1. Documentation Quality
```markdown
**For each SKILL.md:**
- [ ] YAML frontmatter present (name, description)
- [ ] Description follows my-superpowers style
- [ ] Clear "Announce at start" statement
- [ ] Structured sections with clear headers
- [ ] Code blocks specify language
- [ ] All paths are absolute (not relative)
- [ ] English content (except Chinese output instructions)
- [ ] No broken internal references
```

#### 2. Functional Completeness
```markdown
**For adapted skills:**
- [ ] Specs directory location logic present
- [ ] REQ-id extraction logic present (if applicable)
- [ ] Context loading prioritization implemented
- [ ] Error handling for missing files
- [ ] AskUserQuestion for ambiguous cases
- [ ] Progress feedback during execution
- [ ] Clear next-step guidance at completion
```

#### 3. Requirement Traceability
```markdown
**For execution skills:**
- [ ] Code comment templates include // REQ-{id}
- [ ] Commit message templates include REQ-{id}
- [ ] REQ-id verification before commits
- [ ] Clear documentation of traceability requirements
```

#### 4. User Experience
```markdown
**For all skills:**
- [ ] One question at a time pattern
- [ ] Clear option descriptions
- [ ] Helpful error messages
- [ ] Progress indicators for long operations
- [ ] Checkpoint confirmations for batch operations
- [ ] No assumptions without user confirmation
```

### C. Regression Protection

**Ensure new version doesn't break existing functionality:**

#### 1. Preserve Existing Test Scenarios
```markdown
**Test Scenarios from v1:**
If v1 has documented test cases or usage examples:
- Adapt to new command names
- Verify still work as expected
- Document any behavior changes
```

#### 2. Compatibility Check
```markdown
**Breaking Changes Documentation:**

Document all breaking changes for users:

1. Command name changes:
   - `/generate-plans` → `/write-plan`
   - `/executing-plans` → `/execute-plan`

2. File path changes:
   - None (maintained .docs/specs structure)

3. Output format changes:
   - Plan documents include REQ-{id} metadata header
   - All templates enforce REQ-{id} prefix

4. Migration guide:
   - How to adapt existing workflows
   - How to update custom scripts or integrations
```

### D. Success Criteria

**Refactoring considered successful when:**

```markdown
**Must Pass:**
1. ✅ All commands invoke correct skills
2. ✅ All adapted skills output to correct paths
3. ✅ REQ-id extraction and injection works correctly
4. ✅ End-to-end workflow completes without errors
5. ✅ All commits have REQ-{id} prefix
6. ✅ All code comments have // REQ-{id} prefix
7. ✅ Documentation complete and accurate
8. ✅ Error handling catches expected failure cases
9. ✅ User interaction follows consistent patterns
10. ✅ CLAUDE.md accurately describes the system

**Quality Metrics:**
- Zero broken references in skill files
- All skills have complete documentation
- All code blocks specify language
- All error cases have clear messages
- All long operations show progress
```

### E. Validation Tools and Methods

**How to execute validation:**

```markdown
**Manual Testing:**
1. Create test requirement structure:
   ```bash
   mkdir -p .docs/specs/2026-02-14-REQ-99999-test-feature
   ```

2. Test each command sequentially
3. Verify file outputs and formats
4. Check git commit history for REQ-id prefixes

**Automated Checks (if needed):**
- Script to verify REQ-{id} patterns in commits
- Script to check SKILL.md format compliance
- Script to validate directory structure

**Documentation Review:**
- Read through CLAUDE.md as a user
- Verify all command names correct
- Ensure workflow description matches implementation
```

---

## 6. Implementation Approach

### One-Time Comprehensive Refactoring

**Selected Strategy:** Complete all changes in a single implementation cycle

**Rationale:**
- Faster completion
- Single test and verification cycle
- Avoids intermediate inconsistent states
- User explicitly chose this approach

**Risk Mitigation:**
- Thorough design documentation (this document)
- Comprehensive testing plan
- Clear success criteria
- Detailed file-by-file change list

### Implementation Phases

#### Phase 1: Preparation
1. Create backup of v1 implementation
2. Set up test environment
3. Prepare test requirement for validation

#### Phase 2: File Operations
1. Rename command files
2. Rename skill directories
3. Update all internal references

#### Phase 3: Skills Adaptation
1. Copy universal skills from my-superpowers
2. Adapt writing-plans skill
3. Adapt executing-plans skill
4. Rewrite business-specific skills
5. Update all supporting files

#### Phase 4: Documentation
1. Rewrite CLAUDE.md
2. Update all skill documentation
3. Add usage examples
4. Document breaking changes

#### Phase 5: Validation
1. Execute validation test suite
2. Run end-to-end workflow test
3. Verify quality checklist
4. Review all documentation

#### Phase 6: Finalization
1. Address any issues found
2. Final review
3. Commit changes
4. Update version/changelog if applicable

---

## 7. Key Design Decisions

### Decision 1: Adaptation vs Direct Sync
**Choice:** Adapt universal skills rather than direct sync
**Reason:** xspec has specific requirements (specs directory structure, REQ-id traceability) that necessitate customization

### Decision 2: Command Naming
**Choice:** `/write-plan` and `/execute-plan` (not `/generate-task` and `/executing-task`)
**Reason:** Align with my-superpowers conventions for consistency across projects

### Decision 3: Skill Naming
**Choice:** `writing-plans` (not `generate-plans`)
**Reason:** Match my-superpowers naming for universal development skills

### Decision 4: Business Skills
**Choice:** Keep and improve (not replace)
**Reason:** These provide xspec-specific value (PRD clarification, microservices HLD, technical design) not present in my-superpowers

### Decision 5: Implementation Approach
**Choice:** One-time comprehensive refactoring
**Reason:** User preference, faster completion, avoids intermediate states

### Decision 6: English Content
**Choice:** All skill markdown content in English, Chinese for user-facing output
**Reason:** Maintain consistency with my-superpowers, while preserving Chinese workflow for Chinese users

---

## 8. Risks and Mitigations

### Risk 1: Breaking Existing Workflows
**Mitigation:**
- Document all breaking changes
- Provide migration guide
- Test end-to-end workflow thoroughly

### Risk 2: Missing Edge Cases
**Mitigation:**
- Comprehensive test coverage
- Quality checklist for every skill
- User acceptance testing with real scenarios

### Risk 3: Incomplete Adaptation
**Mitigation:**
- Detailed adaptation specification for each skill
- File-by-file change list
- Cross-reference verification

### Risk 4: Documentation Drift
**Mitigation:**
- Update CLAUDE.md alongside code changes
- Include examples and test scenarios in docs
- Verify documentation accuracy in testing phase

---

## Conclusion

This design provides a comprehensive blueprint for aligning the xspec project with my-superpowers architecture and conventions. The one-time refactoring approach will modernize the codebase, improve user experience, and establish a solid foundation for future development.

**Next Steps:**
1. User approval of this design
2. Create detailed implementation plan using writing-plans skill
3. Execute implementation
4. Validate against success criteria
5. Deploy and document

---

**Design Approved:** ⏳ Pending user confirmation
