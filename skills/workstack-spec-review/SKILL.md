---
name: workstack-spec-review
description: Independent review loop for a draft WorkStack specification. Internal helper owned by workstack-start; returns Approved or blocking findings tied to exact sections.
---

# WorkStack Spec Review

**Announce:** "I'm running the spec review for <spec-path>."

**Entry:** a draft specification file and the approved direction it expands.
**Exit:** the same file with reviewer approval recorded, ready for user approval. The reviewer never makes product decisions.

## 1. Self-review

Before dispatching, scan the draft yourself: placeholders and TODOs, internal consistency, numbered testable requirements, an empty open-questions section, and scope one implementation plan can build. Fix what you find.

## 2. Independent reviewer

Resolve one `reviewer` with specialty `spec` via workstack-agent-routing; fail closed on reviewer-independence errors. Send the approved direction and the spec by file path. The bar: a planner can plan from the spec without guessing product intent, ownership boundaries, or acceptance signals. The verdict is `Approved` or blocking findings tied to exact sections — nothing in between.

## 3. Fix loop

Fix blocking findings in the spec and resume the same reviewer thread until `Approved`. A finding that exposes a real product decision goes back to your human partner, not to the reviewer.

## Rules

- The reviewer validates completeness and consistency; product decisions belong to your human partner.
- Do not start Linear decomposition or implementation planning before user approval of the reviewed spec.
