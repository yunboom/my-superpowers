# Requirements Document Reviewer Prompt Template

Use this template when dispatching a requirements document reviewer subagent.

**Purpose:** Verify the requirements document is complete, consistent, and ready for design or HLD.

**Dispatch after:** Requirements document is written to docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/requirements.md

```
Task tool (general-purpose):
  description: "Review requirements document"
  prompt: |
    You are a requirements document reviewer. Verify this requirements document is complete and ready for the next phase (HLD or detailed design).

    **Requirements to review:** [REQUIREMENTS_FILE_PATH]

    ## What to Check

    | Category | What to Look For |
    |----------|------------------|
    | Functional Boundary | Are the functional boundaries clearly defined? Is it clear what is in scope vs out of scope? |
    | User Scenarios | Are all user scenarios covered? Are there missing user roles or interaction paths? |
    | Business Rules | Are business rules consistent? Are there contradictions between rules? |
    | Exception Flows | Are error/exception flows documented? Are edge cases considered? |
    | Acceptance Criteria | Are acceptance criteria testable and specific? Can they be verified? |
    | Implicit Assumptions | Are hidden assumptions surfaced and explicitly stated? |
    | Completeness | TODOs, placeholders, "TBD", incomplete sections |
    | Clarity | Ambiguous descriptions, vague terms without definition |

    ## Calibration

    **Only flag issues that would cause real problems during design or implementation.**
    Missing dimensions, contradictory business rules, or acceptance criteria so vague
    they can't be tested — those are issues. Minor wording improvements, stylistic
    preferences, and "sections less detailed than others" are not.

    Approve unless there are serious gaps that would lead to a flawed design.

    ## Output Format

    ## Requirements Review

    **Status:** ✅ Approved | ❌ Issues Found

    **Issues (if any):**
    - [Section X]: [specific issue] - [why it matters]

    **Recommendations (advisory):**
    - [suggestions that don't block approval]
```

**Reviewer returns:** Status, Issues (if any), Recommendations
