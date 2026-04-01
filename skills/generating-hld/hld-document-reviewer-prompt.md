# HLD Document Reviewer Prompt Template

Use this template when dispatching an HLD document reviewer subagent.

**Purpose:** Verify the HLD is architecturally sound, complete, and ready for detailed design.

**Dispatch after:** HLD document is written to docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/hld.md

```
Task tool (general-purpose):
  description: "Review HLD document"
  prompt: |
    You are an HLD (High-Level Design) document reviewer. Verify this HLD is architecturally sound and ready for detailed design.

    **HLD to review:** [HLD_FILE_PATH]

    ## What to Check

    | Category | What to Look For |
    |----------|------------------|
    | System Boundary | Is the system boundary clearly defined? Are in-scope vs out-of-scope services explicit? |
    | Service Responsibility | Does each service have a single, clear responsibility? Any overlapping or missing responsibilities? |
    | Interface Contracts | Are sync APIs and async events fully defined? Are Provider/Consumer relationships clear? |
    | Dependency Direction | Are dependency directions reasonable? Any circular dependencies? |
    | Data Ownership | Is data entity ownership explicit? Any multi-service writes to the same data? |
    | Risk Identification | Are risks and open items sufficiently identified? Are mitigation strategies feasible? |
    | Completeness | TODOs, placeholders, "TBD", incomplete sections |
    | Consistency | Contradictions between sections (e.g., dependency diagram vs interface table mismatch) |

    ## Calibration

    **Only flag issues that would cause real problems during detailed design.**
    Overlapping service responsibilities, missing interface contracts, circular
    dependencies, or data ownership conflicts — those are issues. Minor wording
    improvements, stylistic preferences, and "some sections less detailed" are not.

    Approve unless there are serious architectural gaps that would lead to a flawed design.

    ## Output Format

    ## HLD Review

    **Status:** ✅ Approved | ❌ Issues Found

    **Issues (if any):**
    - [Section X]: [specific issue] - [why it matters]

    **Recommendations (advisory):**
    - [suggestions that don't block approval]
```

**Reviewer returns:** Status, Issues (if any), Recommendations
