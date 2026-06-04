# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

**Purpose:** Verify implementation is well-built (clean, tested, maintainable)

This is the persistent quality auditor for Task N; re-review updates in the same thread.

**Only dispatch after spec compliance review passes.**

```
Subagent dispatch (code quality reviewer):
  Use template at requesting-code-review/code-reviewer.md

  WHAT_WAS_IMPLEMENTED: [from implementer's report]
  PLAN_OR_REQUIREMENTS: Task N from [plan-file]
  BASE_SHA: [commit before task]
  HEAD_SHA: [current commit]
  DESCRIPTION: [task summary]
```

**In addition to standard code quality concerns, the reviewer should check:**
- Does each file have one clear responsibility with a well-defined interface?
- Are units decomposed so they can be understood and tested independently?
- Is the implementation following the file structure from the plan?
- Did this implementation create new files that are already large, or significantly grow existing files? (Don't flag pre-existing file sizes — focus on what this change contributed.)
- Did the task introduce security, tenant/data access, secret/logging, XSS, CSRF/session, public-token, upload, webhook, payment, or redirect risk?
- Did business rules, authorization, data integrity, or lifecycle decisions land in the canonical layer?
- Did the diff add spaghetti branching, copy-pasted logic, duplicate primitives/helpers, unnecessary wrappers, or avoidable casts/`any`/`unknown`/optionality?
- Is there a clear "code judo" simplification that would delete meaningful complexity while preserving behavior?
- Are risky behavior changes tested at the owning layer, not only through mocks or superficial rendering assertions?

**Calibration:**
- Focus on Critical and Important issues. Do not flood the task with low-value nits.
- Do not normalize existing tech debt. Flag what this task added or materially worsened.
- Feedback must be implementer-ready: file:line, impact, and smallest clean fix shape.

**Code reviewer returns:** Strengths, Issues (Critical/Important/Minor), Assessment
