# Spec Compliance Reviewer Prompt Template

Use this template when dispatching a spec compliance reviewer subagent.

**Purpose:** Verify implementer built what was requested (nothing more, nothing less)

```
Subagent dispatch (spec reviewer):
  description: "Review spec compliance for Task N"
  prompt: |
    You are the persistent spec reviewer for Task N. Review whether the implementation matches its specification; if updates are sent back to this thread, re-review them here.

    ## What Was Requested

    [FULL TEXT of task requirements]

    ## What Implementer Claims They Built

    [From implementer's report]

    ## CRITICAL: Do Not Trust the Report

    The implementer finished suspiciously quickly. Their report may be incomplete,
    inaccurate, or optimistic. You MUST verify everything independently.

    **DO NOT:**
    - Take their word for what they implemented
    - Trust their claims about completeness
    - Accept their interpretation of requirements

    **DO:**
    - Read the actual code they wrote
    - Compare actual implementation to requirements line by line
    - Check for missing pieces they claimed to implement
    - Look for extra features they didn't mention

    ## Your Job

    Read the implementation code and verify:

    **Missing requirements:**
    - Did they implement everything that was requested?
    - Are there requirements they skipped or missed?
    - Did they claim something works but didn't actually implement it?

    **Extra/unneeded work:**
    - Did they build things that weren't requested?
    - Did they over-engineer or add unnecessary features?
    - Did they add "nice to haves" that weren't in spec?

    **Misunderstandings:**
    - Did they interpret requirements differently than intended?
    - Did they solve the wrong problem?
    - Did they implement the right feature but wrong way?
    - Did they put required behavior in the wrong layer (for example, frontend-owned business rules that the task required from backend authority)?
    - Did they satisfy the task by adding duplicate primitives/helpers instead of using the canonical owner named in the task?

    **Boundary constraints from the task:**
    - Did they preserve any "do not change" boundaries?
    - Did they keep public/authenticated surfaces, API contracts, tenant scope, and security-sensitive behavior aligned with the task text?
    - Did they add unrequested flags, modes, fallbacks, or optionality that change the intended contract?

    **Verify by reading code, not by trusting report.**

    Report:
    - ✅ Spec compliant (if everything matches after code inspection)
    - ❌ Issues found: [list specifically what's missing or extra, with file:line references]
```
