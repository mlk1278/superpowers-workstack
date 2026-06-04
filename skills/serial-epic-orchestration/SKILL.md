---
name: serial-epic-orchestration
description: Use when coordinating multiple epic-sized tickets that need shared upfront product thinking, restartable planning artifacts, fresh-session execution, and strictly serial Superpowers implementation.
---

# Serial Epic Orchestration

## Overview

Coordinate several large tickets by doing the human-heavy brainstorming once, saving restartable artifacts, then executing one epic at a time in fresh implementation contexts.

This is a wrapper workflow around:

- `superpowers:brainstorming` for upfront product/design discovery
- `superpowers:writing-plans` for current-code implementation plans
- `superpowers:subagent-driven-development` for executing those plans
- `superpowers:finishing-a-development-branch` when an implementation run reaches completion

The core rule: **brainstorm durable intent early; write implementation plans only just-in-time against the current codebase.**

Do not let the upfront planning session produce stale file-level implementation plans for later epics. Earlier epics may rename fields, move files, change APIs, or alter architecture. Preserve intent, sequencing, constraints, risks, and success criteria. Re-discover concrete code anchors when each epic starts.

## When To Use

Use this skill when all of these are true:

- The user has two or more epic-sized tickets, milestones, specs, PRDs, or feature requests.
- The work should be discussed together because decisions in one epic affect the others.
- The epics must be implemented serially, not in parallel.
- The user wants fresh context between large implementation runs.
- A future agent may need to resume from files after compaction, interruption, or a new session.

Do not use this skill for:

- A single feature that fits the normal `brainstorming -> writing-plans -> subagent-driven-development` flow.
- Independent tasks that can be implemented in parallel.
- Small tasks where the artifact overhead would exceed the implementation work.
- A situation where the user wants one immediate implementation plan for all work.

## Hard Rules

1. **One active epic implementation orchestrator at a time.** Never dispatch two epic implementation orchestrators concurrently.
2. **No implementation plan for Epic N+1 until Epic N is complete.** Later plans must be written against the changed codebase.
3. **Parent orchestration does not write code.** The parent creates briefs, dispatches exactly one epic orchestrator at a time, waits, updates run artifacts, and pauses.
4. **Briefs are intent, not implementation truth.** File paths, field names, APIs, and code anchors in briefs are observations only and must be re-verified by the implementation orchestrator.
5. **Every state transition is written to disk before acting on it.** If a session dies, the next agent must be able to resume from artifacts without chat history.
6. **Pause before dispatch.** Unless the user explicitly says "continue through all epics without asking", pause before each epic dispatch and tell the user which epic is next.
7. **Child orchestrators skip interactive brainstorming, not specification discipline.** They must still write a current-state spec/design document before writing the implementation plan.
8. **Child orchestrators must explicitly invoke and follow `writing-plans` and `subagent-driven-development`.** Do not paraphrase those skills from memory.
9. **If drift changes the meaning of a later epic, stop and ask.** Do not silently reinterpret product intent.

## Modes

This skill has two modes. Decide which mode applies before doing anything else.

### Mode A: Plan Serial Epics

Use when the user is starting a new serial epic run.

Goal: produce restartable planning artifacts and no implementation plans.

Output:

- A run directory under `docs/superpowers/serial-runs/YYYY-MM-DD-<run-name>/`
- A shared portfolio brief
- Ordered epic briefs
- A resume prompt
- A run log initialized for later execution

### Mode B: Resume Serial Epic Execution

Use when the user gives an existing serial-run directory or says to resume a serial epic run.

Goal: read the artifacts, identify the next incomplete epic, optionally refresh context, dispatch exactly one implementation orchestrator, wait for completion, update artifacts, and pause.

## Run Directory Layout

Create or expect this structure:

```text
docs/superpowers/serial-runs/YYYY-MM-DD-<run-name>/
  serial-run.md
  epic-order.md
  run-log.md
  drift-notes.md
  resume-prompt.md
  epics/
    epic-01-<slug>.md
    epic-02-<slug>.md
    epic-03-<slug>.md
```

Optional directories:

```text
  discovery/
    <topic>.md
  references/
    <copied-or-linked-inputs>.md
```

Do not scatter these files across the repo. The run directory is the control plane.

## Mode A Process: Plan Serial Epics

### 1. Announce The Skill

Say:

> "I'm using the serial-epic-orchestration skill to plan a restartable serial epic run."

### 2. Gather Inputs

Collect the ticket text, linked specs, PRDs, issue links, acceptance criteria, business goals, constraints, and any known ordering requirements.

If the user gave links or external documents that are not already in context, fetch or ask for their contents as appropriate. If the project uses a ticket system skill or app, use the relevant tool to read the tickets instead of relying on pasted summaries.

### 3. Explore Project Context

Follow the project-context discipline from `superpowers:brainstorming`.

For small context checks, read the files directly.

For broad discovery, dispatch exploration subagents. Use exploration subagents for:

- mapping existing modules across many files
- surveying similar features or prior implementations
- identifying cross-cutting dependencies
- reading several docs and summarizing them
- enumerating likely touch points

Ask each exploration subagent for raw findings, exact commands used, file references, and a short conclusion. Keep the parent context focused on decisions, not raw source.

### 4. Brainstorm Aggressively

For long-running serial work, be more aggressive than the standard single-feature brainstorming flow.

Do not settle for shallow requirements. Stress-test the whole sequence:

- Ask what outcome matters if only one epic ships.
- Ask what must remain true across all epics.
- Ask which parts are allowed to change as implementation proceeds.
- Ask which parts are compatibility-sensitive.
- Ask what data, API, or UX contracts must be stable.
- Ask what should happen if an earlier epic makes a later epic cheaper, obsolete, or riskier.
- Ask which epics have hidden migration, rollout, permission, billing, data integrity, or operational risks.
- Ask how success will be verified per epic and across the full sequence.
- Ask what should explicitly stay out of scope.

Use one question at a time when interacting with the user. For very large tickets, continue asking until the epic boundaries, ordering, risks, and success criteria are specific enough that a future implementation orchestrator can write a strong current-state spec without guessing.

### 5. Decompose Into Epics

Create epic boundaries that are independently shippable where possible.

Each epic should have:

- one primary outcome
- clear user or system value
- known dependencies
- explicit non-goals
- clear acceptance criteria
- a verification strategy
- a reason it belongs before or after the others

If an epic is still too large for one implementation plan, split it now. Do not hand a vague mega-epic to a child orchestrator and hope it decomposes safely.

### 6. Order The Epics

Write down the execution order and rationale.

Ordering should consider:

- data model dependencies
- API compatibility
- migrations and rollout risk
- frontend/backend sequencing
- test infrastructure needed by later epics
- whether an earlier epic intentionally changes terminology, fields, or architecture
- whether a later epic depends only on product intent and should be planned after earlier code lands

### 7. Create The Run Directory

Create `docs/superpowers/serial-runs/YYYY-MM-DD-<run-name>/`.

Use a short kebab-case run name. If the user did not provide one, derive it from the overall objective.

### 8. Write `serial-run.md`

Include:

```markdown
# Serial Run: <Name>

**Status:** Planning Complete | Executing | Paused | Complete | Blocked
**Created:** YYYY-MM-DD
**Repository:** <repo name/path>
**Branch/Worktree:** <current branch/worktree if known>

## Objective
<Overall goal in durable product terms.>

## Source Inputs
- <ticket/spec/link/path>

## Shared Context
<Facts that apply across all epics.>

## Global Constraints
- <constraint>

## Global Non-Goals
- <non-goal>

## Cross-Epic Risks
- <risk and mitigation direction>

## Resume Instructions
Use `resume-prompt.md` in this directory to resume execution from a fresh session.
```

### 9. Write `epic-order.md`

Include:

```markdown
# Epic Order

## Execution Queue

1. `epics/epic-01-<slug>.md` - <one-line outcome>
2. `epics/epic-02-<slug>.md` - <one-line outcome>

## Dependency Rationale
<Why this order is correct.>

## Reordering Rules
<What would justify changing the order later.>
```

### 10. Write One Epic Brief Per Epic

Each epic brief must be enough for a fresh implementation orchestrator to write a current-state spec after inspecting the repo.

Use this template:

```markdown
# Epic NN: <Title>

**Status:** Pending | In Progress | Complete | Blocked | Superseded
**Execution Position:** N of M

## Durable Intent
<What this epic must accomplish in product/system terms.>

## User Or System Outcome
<What is better after this epic ships.>

## Current Understanding
<What we believe from upfront brainstorming and discovery. Mark observations as re-verification required where appropriate.>

## Dependencies
- Prior epics that must be complete
- External dependencies
- Required repo state

## Acceptance Criteria
- <observable criterion>

## Verification Expectations
- <tests, manual checks, migration checks, UX checks, operational checks>

## Design Constraints
- <constraint>

## Non-Goals
- <explicitly excluded work>

## Risks And Hazards
- <risk>

## Drift Watchlist
- <files, fields, APIs, decisions, or assumptions likely to change before this epic starts>

## Context For Implementation Orchestrator
<Instructions and context to paste into the child orchestrator prompt. This should not be an implementation plan.>
```

Do not include a detailed task-by-task implementation plan. Do not include stale line-number anchors unless clearly labeled as preliminary and requiring re-verification.

### 11. Write `run-log.md`

Initialize with:

```markdown
# Run Log

## Current State
**Status:** Planning Complete
**Next Epic:** epic-01-<slug>
**Active Implementation Orchestrator:** None

## Completed Epics
None yet.

## Events
- YYYY-MM-DD HH:MM - Created serial run artifacts.
```

### 12. Write `drift-notes.md`

Initialize with:

```markdown
# Drift Notes

Record differences between upfront assumptions and current code as each epic begins or completes.

## Open Drift Items
None yet.

## Resolved Drift Items
None yet.
```

### 13. Write `resume-prompt.md`

Write a prompt that can be pasted into a fresh session:

```markdown
# Resume Prompt

Use `superpowers:serial-epic-orchestration`.

Resume the serial epic run from:

`docs/superpowers/serial-runs/YYYY-MM-DD-<run-name>/serial-run.md`

Read:

- `serial-run.md`
- `epic-order.md`
- `run-log.md`
- `drift-notes.md`
- the next incomplete epic brief under `epics/`

Do not rely on prior chat history. Treat these files as the source of truth.

Find the first epic whose status is `Pending` or `In Progress`.

Before dispatching, inspect the current repository state enough to identify obvious drift from the brief. If drift changes product meaning or epic order, pause and ask the user. If drift only affects implementation details, record it in `drift-notes.md` and continue.

Dispatch exactly one implementation orchestrator for the next epic. Wait for it to finish. Update `run-log.md`, the epic brief status, and `drift-notes.md`. Pause before dispatching another epic unless the user explicitly asked to continue.
```

### 14. Self-Review The Artifacts

Before declaring planning complete, review the run directory:

- Are all epics ordered?
- Does every epic have durable intent, acceptance criteria, verification expectations, non-goals, risks, and drift watchlist?
- Are implementation details clearly marked as re-verification required?
- Is there any accidental full implementation plan for a later epic?
- Can a fresh agent resume using only `resume-prompt.md` and the run directory?
- Does the run log identify the next epic?

Fix gaps immediately.

### 15. Ask For Review

Tell the user the run directory path and ask them to review the artifacts before execution.

Do not dispatch an implementation orchestrator until the user approves the serial run artifacts or explicitly says to continue.

## Mode B Process: Resume Serial Epic Execution

### 1. Announce The Skill

Say:

> "I'm using the serial-epic-orchestration skill to resume a serial epic run."

### 2. Read Control Files

Read:

- `serial-run.md`
- `epic-order.md`
- `run-log.md`
- `drift-notes.md`

Then read only the next incomplete epic brief unless more context is necessary.

Do not bulk-read every epic brief into context unless the order is unclear.

### 3. Determine The Next Legal Action

Use this order:

1. If an epic is `In Progress` and `run-log.md` names an active implementation orchestrator, resume or inspect that orchestrator if your platform supports it.
2. If an epic is `In Progress` but no active orchestrator exists, inspect the repo and run log to determine whether it completed, blocked, or needs re-dispatch. If unsure, ask the user.
3. If no epic is in progress, choose the first `Pending` epic in `epic-order.md`.
4. If all epics are `Complete`, report that the serial run is complete and invoke the appropriate branch-finishing workflow if not already done.

Never skip ahead because a later epic looks easier.

### 4. Refresh Current Context

Before dispatching a child implementation orchestrator:

- inspect current git status
- inspect recent commits if useful
- inspect files or docs named in the epic drift watchlist
- record obvious drift in `drift-notes.md`

If drift changes product intent, acceptance criteria, or epic order, stop and ask the user.

If drift only changes implementation details, record it and continue. The child orchestrator will write the current-state spec and plan.

### 5. Pause Gate Before Dispatch

Unless the user already explicitly asked you to continue, pause and say:

- which epic is next
- why it is next
- any drift found
- that you will dispatch exactly one implementation orchestrator

Wait for approval.

### 6. Mark Epic In Progress Before Dispatch

Update the epic brief:

```markdown
**Status:** In Progress
```

Update `run-log.md`:

```markdown
## Current State
**Status:** Executing
**Next Epic:** <epic id>
**Active Implementation Orchestrator:** Pending dispatch
```

Add an event with timestamp.

Do this before spawning the child orchestrator.

### 7. Dispatch Exactly One Implementation Orchestrator

The implementation orchestrator is a child agent responsible for one epic. It may use its own subagents later through `subagent-driven-development`, but the parent serial orchestrator dispatches only this one child for the epic.

Do not fork the full parent conversation unless the platform requires it. Prefer a clean child context containing only:

- the child prompt
- the epic brief
- relevant shared context from `serial-run.md`
- relevant drift notes
- exact run directory paths

### 8. Implementation Orchestrator Prompt

Use this prompt structure. Fill every bracket. Do not shorten it casually.

```markdown
You are the implementation orchestrator for <Epic ID>: <Epic Title>.

You are working inside a serial epic orchestration run.

## Critical Role Boundary

The parent orchestrator already completed interactive upfront brainstorming with the user.

Do not run another user-facing brainstorming loop.
Do not ask broad product-discovery questions unless the brief is ambiguous or blocked.
Do not implement directly from this brief.
Do not write code before producing a current-state spec and implementation plan.

Your job is to turn this epic brief into current, verified implementation work against the repository as it exists now.

## Required Skills

You must explicitly invoke and follow these skills in order:

1. `superpowers:brainstorming` discipline only for writing a current-state design/spec from existing brief and current repo context. Skip interactive brainstorming because it already happened, but keep the spec quality gates: scope, architecture, components, data flow, error handling, testing, self-review for ambiguity and drift.
2. `superpowers:writing-plans` exactly. Read the skill and follow its instructions. Your implementation plan must be tutorialized, self-contained per task, current-code anchored, tests-first, and robust enough for low-effort implementer agents.
3. `superpowers:subagent-driven-development` exactly. Read the skill and follow its implementer, spec reviewer, code quality reviewer, UX gate, plan-progress, and blocking rules.
4. `superpowers:finishing-a-development-branch` when the implementation workflow reaches branch completion.

Do not paraphrase these skills from memory. Load the current skill files/tool invocations available in your environment.

## Inputs

Run directory:
`<run-directory>`

Epic brief:
`<epic-brief-path>`

Shared serial-run context:
<paste only relevant sections from serial-run.md>

Drift notes relevant to this epic:
<paste relevant drift notes or "None">

## Treat Brief As Intent

The epic brief is durable product/system intent. It is not proof that current file names, field names, APIs, routes, schemas, tests, or architecture still exist.

Before writing the spec:

- inspect the current repository
- inspect relevant docs
- inspect recent changes from prior epics when useful
- verify or replace any preliminary assumptions in the brief
- record important drift in the spec

If current repo state contradicts the brief in a way that changes product meaning, acceptance criteria, or epic order, stop and return `BLOCKED` with the exact conflict.

If current repo state only changes implementation details, adapt the spec and plan to the current code.

## Required Outputs

You must create:

1. A current-state spec/design document under `docs/superpowers/specs/YYYY-MM-DD-<epic-slug>-design.md`
2. A detailed implementation plan under `docs/superpowers/plans/YYYY-MM-DD-<epic-slug>.md`
3. Code/test/doc changes required by that plan
4. Commits as required by the plan and subagent workflow
5. Updates to the implementation plan marking completed tasks
6. A final report to the parent orchestrator

## Spec Requirements

The spec must include:

- durable intent from the epic brief
- current repo findings
- confirmed scope
- non-goals
- architecture/design
- components/modules touched
- data flow
- error handling
- migration/rollout considerations if relevant
- testing strategy
- drift from the original brief
- self-review notes covering placeholders, contradictions, ambiguity, and scope

## Plan Requirements

When invoking `superpowers:writing-plans`, be strict.

Every task must be mechanically executable by a low-effort implementer.

Every task that modifies existing code must include:

- exact files to inspect and edit
- existing code anchors
- references to specific spec sections or inlined spec facts
- tests to write first
- verification commands
- do-not-change boundaries
- commit message

Do not spec-dump entire documents into every task. Extract only the relevant facts into each task.

## Execution Requirements

When invoking `superpowers:subagent-driven-development`:

- dispatch exactly the implementer/reviewer agents required by that skill for each task
- keep each task's implementer, spec reviewer, and quality reviewer threads open through approval
- reuse the same task threads for review feedback loops
- update the plan file after each task completes
- block on agent results when they determine the next workflow action
- do not skip final review or verification

## Report Format

Return to the parent orchestrator with:

- **Status:** DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT | CONTEXT_EXHAUSTED
- Epic completed or blocker summary
- Spec path
- Plan path
- Commits created
- Files changed
- Tests/verification run and exact result summary
- Review outcomes
- Drift discovered
- Follow-up work or risks

Return only when the epic is complete or genuinely blocked.
```

### 9. Wait For The Child Orchestrator

After dispatching, wait for the implementation orchestrator whenever its result determines the next step. In normal operation, it always determines the next step.

If waiting times out, update `run-log.md` with:

- active orchestrator id/name if available
- epic id
- last known status
- what the parent is waiting for

Then report the timeout to the user. Do not dispatch another epic.

### 10. Process The Child Result

If the child reports `DONE`:

- inspect the summary
- inspect git status
- inspect commits or changed files as appropriate
- update the epic brief to `Complete`
- update `run-log.md`
- add any drift to `drift-notes.md`
- clear active orchestrator
- pause before the next epic unless the user explicitly asked to continue

If the child reports `DONE_WITH_CONCERNS`:

- read concerns carefully
- decide whether they affect correctness, scope, future epics, or only residual risk
- record concerns in `run-log.md`
- ask the user before continuing unless the concerns are clearly harmless

If the child reports `BLOCKED`, `NEEDS_CONTEXT`, or `CONTEXT_EXHAUSTED`:

- do not mark the epic complete
- record the blocker in `run-log.md`
- decide whether to answer in the same child thread, replace only the exhausted role, revise the epic brief, or ask the user
- do not dispatch the next epic

### 11. Update Artifacts After Each Epic

At minimum:

- epic brief status
- `run-log.md` current state and event history
- `drift-notes.md`
- `epic-order.md` if order changed with user approval
- `serial-run.md` status if the run paused, blocked, or completed

Artifacts must be updated before reporting "ready for next epic."

## Completion

The serial run is complete only when:

- every epic in `epic-order.md` is `Complete` or explicitly `Superseded` with user approval
- `run-log.md` records completion
- `serial-run.md` status is `Complete`
- final verification or branch-finishing guidance has run where appropriate

Do not claim the serial run is complete because the latest child agent finished. Check the queue.

## Common Failure Modes

### Failure: Parent Writes A Full Implementation Plan Up Front

Problem: later plans go stale after earlier epics change the code.

Fix: parent writes epic briefs only. Child writes current-state spec and plan when that epic starts.

### Failure: Parent Dispatches Multiple Epic Orchestrators

Problem: concurrent epics conflict and invalidate serial assumptions.

Fix: one active epic implementation orchestrator. Always wait and update artifacts before the next dispatch.

### Failure: Child Implements Directly From Brief

Problem: brief lacks current code anchors and task-level detail.

Fix: child must write spec, then use `writing-plans`, then use `subagent-driven-development`.

### Failure: Resume Depends On Chat History

Problem: compaction or new session loses decisions.

Fix: control files are source of truth. Every state transition goes to disk.

### Failure: Briefs Are Too Vague

Problem: garbage in, garbage out. Child agents invent missing requirements.

Fix: during Mode A, brainstorm aggressively. Keep asking one question at a time until each epic has durable intent, acceptance criteria, verification expectations, non-goals, risks, dependencies, and drift watchlist.

### Failure: Briefs Are Too Concrete

Problem: concrete file paths and field names in future epics become stale.

Fix: mark implementation observations as preliminary. Move concrete code anchors into the just-in-time spec and plan.

### Failure: Parent Continues Despite Product Drift

Problem: previous epic changed the meaning or usefulness of a later epic.

Fix: stop, record drift, ask the user whether to revise, reorder, split, or supersede the epic.

## Quick Checklist

Mode A:

- [ ] Announced skill
- [ ] Gathered all tickets/specs
- [ ] Explored project context
- [ ] Brainstormed aggressively
- [ ] Decomposed into epics
- [ ] Ordered epics with rationale
- [ ] Created run directory
- [ ] Wrote `serial-run.md`
- [ ] Wrote `epic-order.md`
- [ ] Wrote all epic briefs
- [ ] Wrote `run-log.md`
- [ ] Wrote `drift-notes.md`
- [ ] Wrote `resume-prompt.md`
- [ ] Self-reviewed artifacts
- [ ] Asked user to review before execution

Mode B:

- [ ] Announced skill
- [ ] Read control files
- [ ] Found next legal epic
- [ ] Refreshed current context
- [ ] Recorded drift
- [ ] Paused before dispatch if required
- [ ] Marked epic in progress
- [ ] Dispatched exactly one implementation orchestrator
- [ ] Waited for child result
- [ ] Processed result
- [ ] Updated artifacts
- [ ] Paused before next epic unless explicitly told to continue
