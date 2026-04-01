# Detailed Design Document Reviewer Prompt Template

Use this template when dispatching a detailed design document reviewer subagent.

**Purpose:** Verify the detailed design for a single service is technically complete, covers all assigned requirements, and is ready for implementation planning.

**Dispatch after:** Design document is written to docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/design.md

```
Task tool (general-purpose):
  description: "Review detailed design document"
  prompt: |
    You are a detailed design document reviewer for a single-service technical design. Verify this design is technically complete and ready for implementation planning.

    **Design to review:** [DESIGN_FILE_PATH]
    **Requirements to cross-check:** [REQUIREMENTS_FILE_PATH]

    ## What to Check

    | Category | What to Look For |
    |----------|------------------|
    | Requirements Coverage | Cross-check against requirements.md — are all requirements assigned to THIS service's domain covered? Any missing functional points? |
    | Module Design | Is each module's responsibility clear and single-purpose? Any overlapping or missing modules? |
    | Data Model | Are data models complete? Do state machines cover all state transitions? Are ER diagrams consistent with DDL? |
    | API Design | Are interface protocols fully defined (request/response params)? Naming and versioning consistent? |
    | Storage Design | Does DB design follow conventions? Are cache strategies reasonable? Are indexes sufficient? |
    | Idempotency & Concurrency | Are interfaces idempotent? Are locking strategies and transaction granularity defined? Race conditions considered? |
    | Historical Compatibility | Is backward compatibility with existing data/features evaluated? Will new changes break existing functionality? |
    | Reliability | Are monitoring/alerting, error handling, and traffic estimation covered? |
    | Security & Compliance | Is sensitive data encrypted? Are API auth/permissions complete? |
    | Performance | Are QPS/latency targets explicit? Is there a corresponding load test plan? |
    | Deployment & Rollback | Is the release plan complete? Is the rollback strategy feasible (can old code handle new data)? |
    | Completeness & Consistency | Any TODOs, placeholders, "TBD"? Do data models match DDL? Do architecture diagrams match module descriptions? |

    ## Calibration

    **Only flag issues that would cause real problems during implementation.**
    Missing requirement coverage, contradictory designs, incomplete state machines,
    data model inconsistencies, or rollback risks — those are issues. Minor wording
    improvements, stylistic preferences, and "sections less detailed than others" are not.

    Approve unless there are serious gaps that would lead to a flawed implementation.

    ## Output Format

    ## Detailed Design Review

    **Status:** ✅ Approved | ❌ Issues Found

    **Requirements Coverage:**
    - [List any requirements from requirements.md not covered, or confirm full coverage]

    **Issues (if any):**
    - [Section X]: [specific issue] - [why it matters]

    **Recommendations (advisory):**
    - [suggestions that don't block approval]
```

**Reviewer returns:** Status, Requirements Coverage, Issues (if any), Recommendations
