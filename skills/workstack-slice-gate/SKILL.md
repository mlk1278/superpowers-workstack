---
name: workstack-slice-gate
description: Whole-slice quality gate - the reviewer route, review inputs, and checklist for gating a complete slice diff before its PR. Internal WorkStack helper; gate mechanics are owned by subagent-driven-development's final whole-branch gate.
---

# WorkStack Slice Gate

**Announce:** "I'm running the slice gate for <slice>."

**Entry:** a slice whose task reviews are clean and whose UX gate, when required, has passed on this head, with the slice base SHA recorded.
**Exit:** explicit reviewer approval of the exact head SHA, recorded in the progress ledger. One slice, one gate, one PR.

The gate mechanics — immutable `REVIEW_HEAD`, review packaging, one-fixer finding batches, delta packages, and same-thread re-review until explicit approval — are owned by superpowers:subagent-driven-development's final whole-branch gate and are not restated here. This skill supplies only what a slice adds to that gate.

## Reviewer

Resolve one `reviewer` with specialty `final-gate` via workstack-agent-routing, passing the slice's implementer route as the author identity; fail closed on independence errors.

## Review inputs (by path)

The review package, the primary specification, this slice's living-plan section, the verification log, and `docs/REVIEW-GUIDANCE.md` when the project provides it.

## Slice checklist

Beyond code quality, the verdict must cover: spec and ticket coverage for every acceptance signal the slice claims; integration coherence across the slice's tasks; repository rules and ownership boundaries; security, data, migration, and API-contract risk; test adequacy and verification evidence; documentation obligations; and accidental scope or unsupported claims.

## Ordering and recording

Run the UX gate before this gate so its fixes land in the gated diff. Record the gate verdict and approved SHA in the progress ledger before opening the PR. Never open a PR or invoke branch completion with findings open; a new commit after approval restarts gate evidence.
