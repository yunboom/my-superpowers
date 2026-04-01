# Testing Document Reviewer Prompt Template

Use this template when dispatching a testing document reviewer subagent.

**Purpose:** Verify the testing.md is complete, covers all design requirements, and every test case is directly executable.

**Dispatch after:** testing.md is written to docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/testing.md

```
Task tool (general-purpose):
  description: "Review testing document"
  prompt: |
    You are a testing document reviewer. Verify this testing.md is complete, executable, and ready for end-to-end validation.

    **Testing document to review:** [TESTING_FILE_PATH]
    **Design for reference:** [DESIGN_FILE_PATH]

    ## What to Check

    | Category | What to Look For |
    |----------|------------------|
    | Requirements Coverage | Cross-check against design.md — does every functional point have at least one test case? Any untested features? |
    | Scenario Completeness | Are normal flows, error/exception flows, boundary conditions, and concurrency scenarios all covered? |
    | Executability | Can every test step be executed directly? No placeholders like "call the API", "verify the result", or "check the database"? |
    | Environment Setup | Is the test environment setup complete and appropriate for the project type? Check: (1) **Backend**: middleware startup (Docker Compose / local install), data init scripts, healthcheck readiness; (2) **Frontend**: dev server command, mock API / data stubs, browser requirements; (3) **Fullstack**: service dependency chain, network connectivity, startup order |
    | Data Management | Are test data creation and cleanup strategies explicit? Is data isolated between test cases? |
    | Expected Results | Are expected results specific and verifiable (not subjective like "should be fast")? Include status codes, return values, DB state, or UI element assertions? |
    | Test Independence | Are test cases independent of each other? Any implicit ordering dependencies? |
    | Stability | Any flakiness risks? Does the test rely on fixed waits (sleep/waitForTimeout) instead of condition-based waits (waitForResponse, healthcheck, element visibility)? |
    | Type Consistency | Does each test case's declared type (API / Browser / Integration) match its actual step format? API cases use curl/HTTP clients? Browser cases use Playwright/test scripts? |
    | Completeness | Any TODO markers, placeholders, or incomplete test cases? |

    ## Calibration

    **Only flag issues that would cause real problems during test execution.**
    Missing test coverage for design features, non-executable test steps, placeholder
    test descriptions, or flaky wait patterns — those are issues. Minor wording
    improvements, stylistic preferences, and test ordering suggestions are not.

    Approve unless there are serious gaps that would lead to untested features or failing tests.

    ## Output Format

    ## Testing Review

    **Status:** ✅ Approved | ❌ Issues Found

    **Coverage Check:**
    - [List any design.md functional points not covered by test cases, or confirm full coverage]

    **Issues (if any):**
    - [TC-X]: [specific issue] - [why it matters]

    **Recommendations (advisory):**
    - [suggestions that don't block approval]
```

**Reviewer returns:** Status, Coverage Check, Issues (if any), Recommendations
