# WorkStack Plan-Authoring Rules

Supplementary rules for writing living-plan slice tasks, supplied to the plan-writing continuation by WorkStack entry points. They extend superpowers:writing-plans without editing it. The test behind every rule: each task will be pasted alone into a fresh implementer prompt.

## 1. Tasks are self-contained

Implementers never read the plan file. Anything living only in a top-level section is invisible to them. Every external artifact a task depends on is listed inside that task in a `**References (paste into implementer prompt):**` block; repeat references across tasks that share them.

> **References (paste into implementer prompt):**
> - `docs/superpowers/specs/2026-07-18-feature-spec.md § "Approval Flow"` — authoritative for this task.
> - `apps/web/components/estimate-builder.tsx:1-120` — current implementation being replaced; preserve action semantics.

## 2. References are surgical

Never reference a whole document. Every spec fact a task depends on is either inline-quoted or cited with a specific section and line range. If three or more tasks share the exact same bare reference, the plan is spec-dumping — go back and read the spec until you can name which sections each task actually needs.

## 3. Modification tasks carry code anchors

Any task that modifies existing code includes an `**Existing Code Anchors:**` block with `file:line-range` entries for: current behavior, pattern to copy, code to preserve, known hazards. Greenfield tasks need none.

> **Existing Code Anchors:**
> - `apps/api/src/estimates/controller.ts:59-88` — current validation being replaced.
> - `apps/api/src/customers/controller.ts:41-63` — pattern to copy.

## 4. Sweeps are enumerated by the planner

"Update all callers" is not a task. The planner runs the discovery command against the real codebase and pastes the resulting `file:line` list into the task, plus a completion predicate — a command that returns no matches only when the sweep is done — and an explicit out-of-scope list. Flag verbs: audit, normalize, sweep, migrate, convert, replace, propagate, standardize, unify.

> Discovery: `rg -n '\.safeParse\(' apps/api/src` — enumerated targets pasted into the task.
> Verify: the same command finds no matches outside the out-of-scope list.

## 5. The extraction test

Before saving, copy the single most ambitious task alone into an imaginary blank prompt. If an implementer would need to infer architecture, files to inspect, existing patterns, or sequence, the plan is not done. Apply the same test to one routine and one trivial task — trivial tasks smuggle in implicit context too.

## 6. Expanded self-review

Beyond upstream writing-plans' checks, verify before saving: every modification task has anchors; every sweep is enumerated with a predicate; no three tasks share a bare reference; each task survives the extraction test; UX and slice gates are placed where the living-plan format requires; every verify command is real and was run against the current tree.
