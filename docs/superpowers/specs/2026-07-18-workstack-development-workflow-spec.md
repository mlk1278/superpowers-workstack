# WorkStack Development Workflow Specification

**Status:** Approved target state — implementation partial

**Date:** 2026-07-18

**Applies to:** WorkStack product development in FSMCRM and the WorkStack-maintained Superpowers distribution

**Upstream baseline:** Superpowers v6.1.1 at `d884ae04edebef577e82ff7c4e143debd0bbec99`

**Replaces as target-state authority:** The phase-oriented `workstack-*` workflow currently described in FSMCRM's `AGENTS.md` and local skills. Existing files remain operationally authoritative until the replacement entry points and lifecycle pass the cutover conditions in Section 23.

## 1. Human summary

WorkStack tracks durable product outcomes as Linear tickets, but keeps implementation detail local. New or ambiguous work is shaped into an approved direction, converted into a decision-complete specification, represented by one or more Linear tickets, and then organized in one living implementation plan. The plan may cover many tickets, but it fully details only the delivery slices that are ready to build. Later, dependent work remains a short planning checkpoint until earlier slices merge and the codebase can be explored again. Human-defined phases and timeboxes are prioritization tools only; they never control implementation and never become workflow artifacts.

Implementation happens one delivery slice at a time. A slice contains one or more Linear tickets and several small Superpowers implementation tasks, but it has exactly one whole-slice gate and one pull request. The inner Superpowers loop remains sequential and reliable: a fresh implementer completes each task, a different model performs one combined requirements-and-quality review, and the slice receives a broad final review before its PR opens. Independent slices may run in parallel worktrees under a lightweight active contract when they share or may affect common interfaces. WorkStack owns this outer coordination layer; upstream Superpowers continues to own brainstorming, plan detail, task execution, debugging, verification, and code-review mechanics.

### 1.1 Implementation status as of 2026-07-19

The maintained fork has completed its routing foundation and generic core extension seams:

- fork divergence governance and centralized logical agent routing;
- project overrides through `.workstack/agents.json`;
- caller-selected continuations after brainstorming and plan writing;
- inclusion of plan-wide constraints in every extracted SDD task brief;
- an exact-head final review gate with fix, verification, and same-thread re-review loops;
- reviewer-only loading of `docs/REVIEW-GUIDANCE.md`, plus optional task-specific review nuance from the orchestrator.

These changes are on `main` through `7a392aa`, with deterministic focused tests passing. The implementation plan still records missing fresh-agent behavioral evidence for several S2 scenarios. The landed changes are infrastructure for the target workflow, not the completed workflow. The living-plan recovery model, three public entry points, slice/UX/PR lifecycle, parallel-contract lifecycle, FSMCRM cutover, and pilots remain unimplemented. Therefore FSMCRM must retain its transitional `workstack-*` skills until their replacement behavior exists and passes the acceptance scenarios in Section 22.

```text
                  New or ambiguous work
                           │
                 shape → spec → Linear
                           │
                           ▼
Quick task ────────► living implementation plan ◄──── Resume existing work
                           │
                 ready delivery frontier
                    ┌──────┴──────┐
                    ▼             ▼       independent slices only
                 Slice A       Slice B    may run in parallel worktrees
                    │             │
        sequential Superpowers task loops
                    │             │
              whole-slice gate + conditional UX gate
                    │             │
                  one PR        one PR
                    │             │
                merge and reconcile Linear
                    └──────┬──────┘
                           ▼
             planning checkpoint or closeout
```

## 2. Goals

The workflow must:

1. Give humans and agents one understandable way to move work from an idea to merged code.
2. Preserve the reliability of current Superpowers while avoiding the dispatch and prompt overhead of the older refined fork.
3. Support both a small, decision-complete task and a long-running effort spanning many Linear tickets.
4. Make the gate and PR boundary large enough to represent a coherent feature surface rather than a ten-minute implementation step.
5. Allow safe parallel delivery between independent feature surfaces without parallelizing the inner task loop.
6. Keep Linear useful as the durable outcome tracker without mirroring every local implementation step through its API.
7. Survive compaction, process restarts, and multi-session execution without repeating completed work.
8. Route subagents through logical roles whose harness, model, and effort can be changed centrally.
9. Keep the WorkStack distribution maintainable as upstream Superpowers evolves.
10. Make every temporary coordination artifact, especially active contracts, somebody's explicit responsibility to close.

## 3. Non-goals

This workflow does not:

- manage human phases, sprints, or timeboxes;
- decide product priority or select which Linear tickets belong in a timebox;
- create a Linear issue for every test, code edit, review finding, or Superpowers task;
- require one ticket, one local task, or one PR per implementation step;
- run multiple implementers concurrently in the same worktree or Superpowers task loop;
- define production deployment, release promotion, or incident response;
- impose a monetary, token, or dispatch quota;
- preserve completed implementation plans and run ledgers in the repository forever;
- rewrite Git history to remove historical Markdown planning documents;
- duplicate upstream Superpowers instructions in WorkStack wrapper skills;
- hard-code provider or model names throughout workflow skills.

## 4. Canonical vocabulary

These terms are normative. Skills, plans, pull requests, and human documentation must use them consistently.

### 4.1 Linear project

A Linear project groups related tickets and provides a project-level view. It may contain a handful or dozens of tickets. Project membership does not determine plan, slice, branch, gate, or PR boundaries.

### 4.2 Phase or timebox

A human-selected period or priority set. It may include tickets from several Linear projects. It has no implementation semantics and is not read or written by the delivery workflow unless a human explicitly asks an agent to help with prioritization.

No target-state skill may require a phase, create a phase plan, shepherd a phase, or use phase completion as a merge condition.

### 4.3 Linear ticket

A durable, independently understandable product or engineering outcome. A ticket explains what must be true, why it matters, and its acceptance signals. It is not a list of two-to-five-minute coding steps.

A ticket normally belongs to exactly one delivery slice. If one ticket would require separately mergeable slices, it must be divided into child or successor tickets before execution. A delivery slice may contain several tickets when they form one coherent, jointly reviewable change.

### 4.4 Specification

The approved statement of product behavior and constraints. It is decision-complete, testable, and implementation-independent. It may lead to one or many Linear tickets and one or many delivery slices.

### 4.5 Living implementation plan

The local, canonical execution document for one coherent feature surface. It may span multiple tickets and PRs. It contains detailed Superpowers tasks only for the current ready delivery frontier. Future dependent work remains deliberately lightweight until a planning checkpoint is reached.

There is not a separate implementation plan per ticket, and there are no implementation phases inside a ticket.

### 4.6 Planning checkpoint

A non-code item in a living implementation plan that says when later work must be re-explored and detailed. It records the intended outcome, included ticket IDs, dependencies, and the evidence that will make detailed planning reliable.

A planning checkpoint is not a Linear ticket, delivery slice, phase, gate, branch, or PR. Reaching one does not itself produce code.

### 4.7 Delivery slice

The atomic delivery boundary. A slice contains:

- one coherent, testable feature surface;
- one or more Linear tickets;
- one branch and linked worktree;
- one or more sequential Superpowers implementation tasks;
- one whole-slice quality gate;
- a UX gate when the specification requires browser-visible evidence;
- exactly one PR;
- one merge and Linear reconciliation event.

The slice, not the individual Superpowers task, is the unit sent through cloud review.

### 4.8 Superpowers task

The smallest local implementation unit worth a fresh implementer context, its own test cycle, and a focused combined review. Tasks are written in the living plan and never mirrored to Linear by default.

### 4.9 Gate

A blocking review verdict over the entire believed-final slice diff. The gate checks the specification, ticket acceptance signals, repository rules, integration coherence, tests, security and data risk, and the truthfulness of verification claims. A PR cannot open until the gate is clean.

### 4.10 Active contract

A temporary coordination record for concurrent work that reserves a shared surface or freezes an interface. It is owned by one top-level orchestrator, not by implementation lanes. Its lifetime is determined by an explicit prune trigger and consumer state, not merely by branch or worktree age.

## 5. Hard invariants

1. **Three human entry points.** Humans start with Quick Task, Start Work, or Resume Work. Internal helpers do not create additional workflow choices.
2. **No implementation phases.** Phase vocabulary is excluded from plans, skills, contracts, and execution state.
3. **One slice, one gate, one PR.** A slice never produces multiple PRs, and a PR never combines unrelated slices.
4. **Tickets stay coarse.** Local plan tasks and review findings do not become Linear tickets unless they reveal genuinely separate durable work.
5. **Detailed planning stops at the current frontier.** Dependent future slices are not populated with speculative file paths or code steps.
6. **Inner-loop execution is sequential.** Parallelism exists only between independent delivery slices in separate worktrees.
7. **Reviewer differs from author.** Code and specification review must resolve to a model identity different from the authoring model. Missing independent reviewer configuration fails before work begins.
8. **One combined task review.** Specification compliance and code quality are reviewed together after each task; separate spec-review and code-quality agents are not dispatched for the same task.
9. **Whole-slice gate closes its loop.** Findings are fixed, relevant verification is rerun, and the same gate thread re-reviews the delta until clean.
10. **Linear is reconciled at coarse transitions.** The normal API touchpoints are ticket creation or material scope change, slice start, and slice merge or cancellation.
11. **Durable state beats conversation memory.** The plan, Git commits, local progress ledger, PR state, and active contract are the recovery authority.
12. **Every temporary artifact has an owner and close condition.** Plans, ledgers, worktree context files, branches, worktrees, and contracts are pruned by the workflow that created them.
13. **Skills reference logical roles only.** Concrete harnesses, models, and effort levels live in one routing configuration.
14. **WorkStack wraps Superpowers.** WorkStack owns project policy and orchestration; it does not fork-copy upstream task implementation instructions into parallel skills.

## 6. Distribution and ownership architecture

### 6.1 Fork as source, project-local installation

WorkStack maintains one fork of current Superpowers as the source of truth. The fork retains upstream skill names and references, and adds WorkStack-specific skills, configuration, tests, and project documentation beside upstream core.

The fork has two Git remotes:

- `upstream`: the canonical Superpowers repository;
- `origin`: the WorkStack-maintained fork used as the project installation source.

FSMCRM installs the complete fork skill set project-locally with the npm-delivered Agent Skills installer. The canonical installed set lives under `.agents/skills`; harness-specific skill directories may contain links to that canonical set when the installer requires them. FSMCRM does not install the WorkStack fork or vanilla Superpowers globally, does not activate either as a project plugin, and does not maintain independently edited copies under `.claude/`, `.codex/`, or other harness-specific folders.

The standard project-local installation command is:

```bash
npx -y skills@latest add mlk1278/superpowers-workstack \
  --skill '*' \
  --agent claude-code \
  --agent codex \
  --yes
```

The repository lockfile records the selected skills and source. Plugin manifests may remain in the fork for upstream compatibility and other consumers, but FSMCRM's workflow does not depend on plugin installation or activation.

### 6.2 Ownership boundary

Upstream Superpowers owns:

- brainstorming dialogue and design exploration;
- detailed task-plan construction;
- worktree setup;
- test-driven implementation;
- systematic debugging;
- per-task subagent-driven development;
- task review packages and file-based handoffs;
- broad code review mechanics;
- branch completion primitives.

The WorkStack overlay owns:

- the three public entry points;
- dedicated specification verification;
- Linear ticket creation and coarse reconciliation;
- living-plan, delivery-slice, and planning-checkpoint semantics;
- parallel-slice selection and worktree coordination;
- active-contract lifecycle;
- WorkStack-specific test, docs, database, tenancy, and UX gates;
- PR monitoring and merge reconciliation;
- logical role resolution;
- planning-artifact retention and closeout.

### 6.3 Core divergence policy

Upstream skill bodies remain unchanged unless a change is either:

1. a generic correctness fix suitable for upstream, or
2. a small extension seam required for a wrapper to choose an alternate continuation.

The fork must keep a machine-readable allowlist of core files that differ from upstream and a short reason for each difference. New WorkStack skills and configuration are additions, not core divergences. Upstream merges must fail compatibility verification when an allowlisted patch no longer applies or when a WorkStack wrapper invokes a removed or behaviorally incompatible upstream entry point.

The initial permitted core fixes are limited to:

- allowing a caller-supplied continuation after brainstorming and plan writing, so WorkStack can insert spec verification and slice orchestration;
- ensuring plan-wide global constraints are present in every extracted implementer brief;
- making broad final review a closed fix-and-re-review gate rather than a one-pass report;
- allowing reviewers, and only reviewers, to load canonical project review guidance and scoped task nuance;
- allowing a caller-declared completion contract in branch finishing, so an orchestrated slice executes its gated PR route without an interactive options menu (the menu remains the default when no contract is declared). *Added 2026-07-19 from the instructional-conflict audit; user-approved.*

Any broader core rewrite requires a new approved specification.

### 6.4 Human reproducibility

Every WorkStack skill must describe the ordinary engineering action it automates. A human who cannot invoke skills must still be able to follow this specification: write the same artifacts, create the same worktree, execute plan tasks sequentially, request the same independent reviews, open the same slice PR, and perform the same closeout.

## 7. Public entry points

Only these three skills are presented to humans as ways to begin work.

### 7.1 `workstack-quick-task`

Use when the requested change is already decision-complete, has one coherent outcome, requires no product shaping, and can be represented as one small delivery slice. Typical examples are a bounded bug fix, copy or layout correction, narrow test repair, or small implementation change with an established owner.

The quick route:

1. explores enough code to identify the existing owner and relevant rules;
2. creates an ignored mini-plan and task brief under `.superpowers/`;
3. reuses the normal Superpowers implementation and review loop;
4. runs applicable verification and UX evidence;
5. opens one PR and follows the normal exact-head PR gate;
6. removes its scratch artifacts and worktree after merge.

A quick task may use an existing Linear ticket but does not create one solely to mirror a tiny local change. If shaping, multiple delivery slices, a shared-interface contract, or unresolved product decisions become necessary, the skill stops and promotes the work to Start Work when no approved spec exists, or Resume Work when one does.

### 7.2 `workstack-start`

Use when work is new, ambiguous, or lacks an approved specification. It runs the complete outer discovery sequence:

1. invoke Superpowers brainstorming in WorkStack continuation mode;
2. obtain approval for the product direction recorded in the draft specification;
3. expand that same draft into the dedicated decision-complete specification;
4. run one independent specification-review loop;
5. obtain user approval for the written specification;
6. hand the approved specification to Resume Work;
7. Resume Work creates or reconciles the necessary Linear tickets in one batched operation;
8. Resume Work creates the living implementation plan with its first ready frontier and future planning checkpoints;
9. obtain approval for the initial plan, then continue through Resume Work.

The skill may enter at an approved direction when no approved spec exists. Once a spec is approved, Resume Work owns all later states; Start Work hands off to it rather than creating an overlapping entry path.

### 7.3 `workstack-resume`

Use when an approved specification or living implementation plan already exists, including after compaction, a stopped session, or a merged earlier slice. It discovers current state instead of trusting conversation memory, then performs the next valid transition:

- materialize the next planning checkpoint;
- create or reconcile Linear tickets and the initial living plan when only an approved spec exists;
- start or continue a ready delivery slice;
- recover an interrupted task from its ledger and commits;
- continue a gate or PR fix loop;
- reconcile a merged slice;
- close the living plan and its temporary artifacts.

Unless the user requests a narrower stopping point, Resume Work continues through merge and reconciliation for the selected ready frontier. It pauses only for a genuine product decision, an unresolved destructive conflict, missing authority, or an external gate that cannot progress.

## 8. Specification lifecycle

### 8.1 Canonical location

Draft and approved product specifications live at:

```text
docs/superpowers/specs/YYYY-MM-DD-<feature-slug>-spec.md
```

Older specs in other locations remain historical references, not competing active authority. A living plan names exactly one primary specification and may list explicitly scoped supporting references.

Superpowers brainstorming creates the file in `Draft direction` state. Dedicated specification writing expands the same file, preserving the approved direction in Git history without creating a second design artifact. Independent review and user approval promote its status to `Approved`.

### 8.2 Required content

A specification contains:

- goal and user or operator problem;
- context and current behavior;
- approved decisions;
- numbered, testable requirements;
- actors, permissions, and failure behavior;
- data and API contract decisions where applicable;
- frontend routes, state matrix, responsive behavior, accessibility, copy, and visual acceptance criteria where applicable;
- acceptance signals;
- non-goals;
- an empty open-questions section at approval.

It does not contain implementation task lists, branch structure, speculative file paths, or PR sequencing.

### 8.3 Review and approval

The author performs an inline consistency, ambiguity, placeholder, and scope review. A fresh independent reviewer then receives the approved direction and the specification through file paths. It returns either `Approved` or blocking findings tied to exact sections.

The same reviewer thread evaluates corrections until approval. The reviewer validates completeness and consistency; it does not make product decisions. Any newly exposed product decision returns to the user. The user approves the final written specification before Linear decomposition or implementation planning begins.

## 9. Linear model

### 9.1 What belongs in Linear

Linear stores durable work that is useful to humans independent of the current agent session:

- product or engineering outcomes;
- acceptance signals;
- dependencies between outcomes;
- project grouping and human priority metadata;
- labels, urgency, and complexity;
- links to the primary spec and merged PRs;
- final completion or cancellation state.

### 9.2 What stays local

The following remain in the living plan, ledger, or review reports:

- test-first coding steps;
- file-by-file implementation instructions;
- subagent assignments;
- task review rounds;
- transient blockers and resume notes;
- detailed verification output;
- planning checkpoints;
- slice conflict analysis.

### 9.3 API interaction policy

Linear operations are batched around meaningful state changes. The expected sequence is:

1. create or reconcile tickets after specification approval;
2. mark all tickets in a slice in progress when the slice actually starts;
3. update scope or dependencies only when the approved plan materially changes them;
4. close or reconcile all slice tickets after the PR merges;
5. record cancellation or follow-up work when a slice is abandoned or deliberately reduced.

Task completion, review rounds, commits, and planning-checkpoint execution do not trigger Linear API calls.

### 9.4 Ticket and slice rules

- Every ticket appears in at most one active living plan.
- Every ticket in an active plan is assigned to exactly one slice record whose state is `deferred`, `ready`, `active`, `gated`, `PR open`, `merged`, `cancelled`, or `blocked`.
- One slice may contain multiple tickets.
- A ticket may contain many Superpowers tasks.
- If a ticket cannot be completed by one slice PR, split the ticket before implementation.
- All tickets in a multi-ticket slice move through start and completion together. Partial completion is handled by splitting the slice before PR creation, not by merging an incomplete slice.

## 10. Living implementation plan

### 10.1 Canonical location and lifetime

Active plans live at:

```text
docs/superpowers/plans/YYYY-MM-DD-<feature-slug>.md
```

The plan is committed while active so worktrees and restarted orchestrators can read it. Coordination-only plan and contract updates land directly on `develop`; they do not create delivery PRs or cloud-review cycles. At final closeout the same coordination path removes the plan from the repository's current tree. Git history remains the historical record. Product specifications and durable product docs are retained.

### 10.2 Required structure

Every plan contains:

1. status and plan owner;
2. primary specification path;
3. Linear ticket set;
4. overall goal and completion signals;
5. global constraints copied from the specification and repository rules;
6. decision log for implementation-level choices;
7. a delivery-slice index;
8. fully detailed sections for the current ready frontier;
9. lightweight planning checkpoints for dependent future work;
10. closeout conditions, including contract and artifact pruning.

The slice index records at least:

| Field | Meaning |
|---|---|
| Slice ID and name | Stable local identity and coherent outcome |
| Ticket IDs | All Linear outcomes closed by the slice |
| Dependencies | Slices or external conditions that must be complete |
| State | Deferred, ready, active, gated, PR open, merged, cancelled, or blocked |
| Branch/worktree | Present only after execution starts |
| Contract impact | None, producer, consumer, or reserved surface |
| PR | Present after creation |

### 10.3 Ready slice detail

A ready slice section contains the information required by upstream Superpowers planning:

- goal and acceptance signals;
- included tickets and dependencies;
- exact implementation tasks with file ownership, interfaces, test steps, verification commands, and expected outcomes;
- applicable docs impact;
- applicable UX-gate rubric;
- slice-wide verification;
- PR and merge conditions.

Every extracted task brief includes the plan's global constraints. A fresh implementer must be able to execute a task from its brief plus explicitly named prior-task interfaces without reading the full plan.

### 10.4 Deferred work and planning checkpoints

Future work beyond the current dependency barrier records only:

- intended outcome;
- included ticket IDs;
- known dependencies;
- facts that are already frozen by the specification;
- the merge or evidence trigger that makes detailed planning appropriate;
- surfaces to re-explore at that time.

It must not guess exact file paths, signatures, migrations, or task steps before the prerequisite code exists.

At a planning checkpoint, the orchestrator:

1. confirms prerequisite slices are merged;
2. syncs to the current `develop` head;
3. re-explores the affected code and active contracts;
4. invokes upstream Superpowers plan writing for the new ready frontier;
5. replaces the checkpoint with detailed slice sections in the same living plan;
6. self-reviews the new plan detail;
7. continues without a user pause when it stays inside the approved spec and ticket scope.

User approval is required again only when re-planning changes product behavior, acceptance criteria, ticket scope, or a previously approved cross-slice interface.

### 10.5 Batch planning

The planner may detail several slices together only when they belong to the same current dependency frontier and the code state needed to plan each already exists. This is batch planning, not permission to execute them in parallel.

The orchestrator separately evaluates whether ready slices are independent enough for parallel worktrees. Dependent or overlapping slices remain sequential even if planned together.

### 10.6 Plan review

Every plan receives a self-review for spec coverage, task extraction completeness, interface consistency, real verification commands, slice boundaries, and closeout ownership.

An independent plan reviewer is required only when the ready frontier contains parallel slices, a migration or shared-interface contract, security-sensitive behavior, or unusually broad cross-domain work. Routine single-slice plans do not add a second planning dispatch by default.

## 11. Delivery-slice execution

### 11.1 Preflight

Before dispatching implementation, the slice orchestrator must:

1. resolve every required logical agent role;
2. verify the reviewer model differs from the planned author model;
3. confirm the plan and tickets still match;
4. scan active contracts and current worktrees;
5. obtain confirmation from the top-level plan owner that any required contract is current and committed to `develop`; the slice orchestrator does not write it;
6. sync the slice base to the resulting intended `develop` commit;
7. create one linked worktree and isolated runtime resources;
8. write an uncommitted `docs/WORKTREE_CONTEXT.md` that points to the plan and slice;
9. initialize the local Superpowers progress ledger;
10. when tickets exist, mark the slice tickets in progress in one Linear operation.

If any preflight condition fails, no implementer is dispatched.

### 11.2 Inner Superpowers loop

Tasks execute sequentially in plan order inside the slice worktree:

1. extract the next incomplete task to a file-based brief;
2. dispatch a fresh implementer with the brief path, prior interfaces, and report path;
3. require tests and a self-review before the implementer reports completion;
4. build a file-based review package for the exact task diff;
5. dispatch one fresh combined task reviewer using a model different from the author;
6. if findings exist, dispatch one fixer with the complete finding set;
7. require the fixer to rerun the covering verification and append its report;
8. resume the same reviewer thread for the delta;
9. mark the task complete in the local ledger only after a clean verdict;
10. proceed to the next task without human check-ins.

The orchestrator does not paste full briefs, reports, diffs, or test logs into its conversation context. It passes file paths and keeps only compact status, commit, test, and concern summaries.

When a project provides `docs/REVIEW-GUIDANCE.md`, reviewer prompts tell the reviewer to load it as the canonical project-wide review guidance and gotcha reference. Only the reviewer reads this file. Orchestrators pass no copy of it, and implementers, fixers, explorers, planners, operators, and monitors do not load it for general context. The orchestrator may also provide concise task- or slice-specific review nuance. That nuance may identify concrete risks or decisions, but it cannot override approved requirements, suppress findings, or pre-assign severity.

### 11.3 Dispatch shape

For a slice with `N` implementation tasks, the normal local review floor is:

- `N` implementer dispatches;
- `N` combined task-review dispatches;
- one broad whole-slice gate.

Fix and re-review dispatches occur only when findings exist. For a one-task quick slice whose combined task review sees the complete final diff, that reviewer may issue both the task and slice-gate verdict in the same pass. Separate spec-compliance and code-quality reviewers, per-task UX reviewers, and speculative reviewer fleets are prohibited by default.

### 11.4 Verification

Each task runs the smallest covering verification named in its plan. The whole slice runs the repository-defined slice verification before its gate. CI owns the full repository suite unless the plan identifies a reason it must run locally.

Verification output is written to log files and summarized. A gate may not accept unsupported claims such as “tests pass” without the command, exit status, and relevant result.

## 12. UX review

### 12.1 When required

A UX gate is required when a slice materially changes a user-visible surface and code review alone cannot establish the specification's visual or interaction acceptance criteria. Copy-only, invisible wiring, and non-visual backend work do not trigger it.

The requirement is decided in the specification or when the ready slice is planned, not improvised after implementation.

### 12.2 Evidence and verdict

The UX reviewer receives:

- `docs/REVIEW-GUIDANCE.md` when the project provides it;
- the specification's routes, state matrix, responsive behavior, accessibility requirements, copy, and visual criteria;
- the exact slice head;
- a running isolated environment;
- browser pathways and required viewport states;
- screenshots or traces produced from the real application.

One primary UX reviewer returns `Approved` or blocking findings. Fixes are rechecked in the same reviewer thread. Additional independent UX reviewers are exceptional and require an explicit reason such as a broad redesign or accessibility specialty; a five-to-ten-agent UX fan-out is not a default workflow.

The UX gate runs before the whole-slice quality gate so its fixes are included in the final diff.

## 13. Whole-slice gate and PR lifecycle

### 13.1 Local gate

After all task reviews and any UX gate are clean, one fresh gate reviewer evaluates the complete diff from the slice base to its believed-final head. It checks:

- specification and ticket coverage;
- integration coherence across tasks;
- repository rules and existing ownership boundaries;
- security, tenancy, data, migration, and API-contract risk;
- test adequacy and verification evidence;
- user-doc and release-note obligations;
- accidental scope and unsupported claims.

Findings return as one set. One fixer handles the set where practical, reruns covering verification, and the same gate reviewer checks the delta. The gate is not complete until the reviewer explicitly approves the current head.

### 13.2 Pull request boundary

Only a clean gated slice opens a PR. The PR body includes:

- all included Linear ticket links;
- primary specification and exact living-plan slice link;
- concise behavior summary;
- verification evidence;
- UX evidence when applicable;
- migration, contract, and docs impact;
- the gated commit SHA.

Links to an active implementation plan use a commit-pinned URL so they remain valid after closeout removes the plan from the repository's current tree.

No individual Superpowers task opens a PR or invokes cloud review.

### 13.3 PR monitoring

One PR monitor owns the PR from creation through merge. It:

1. observes configured CI and review providers with bounded backoff;
2. verifies every required result is bound to the current head SHA;
3. groups actionable findings into coherent fix rounds;
4. dispatches fixes through the normal implementer/reviewer separation;
5. resumes the local gate reviewer on post-gate deltas;
6. reruns the full slice gate when a fix materially changes behavior, architecture, migration, or risk;
7. updates the PR evidence after head changes;
8. merges only when all configured exact-head requirements are satisfied;
9. reports the exact merge state to the owning Resume Work orchestrator for reconciliation.

Provider names and timeout policy come from project configuration. Skills do not hard-code CodeRabbit, Codex Cloud, or any other vendor as universally available.

### 13.4 Post-merge reconciliation

After merge, the PR monitor reports the exact merge state to the owning Resume Work orchestrator. That owner performs or confirms reconciliation:

1. confirms the merge commit exists on `develop`;
2. closes all tickets in the slice in one Linear reconciliation operation;
3. records the PR and merge in the living plan;
4. as the contract's sole writer, updates or closes any plan-owned active contract whose prune trigger is now satisfied;
5. removes the linked worktree, local branch, ignored ledger, reports, and `WORKTREE_CONTEXT.md`;
6. advances newly unblocked slices to ready or reaches the next planning checkpoint;
7. closes and prunes the living plan only when no work remains and its active contract has been pruned or explicitly transferred to a replacement living plan.

## 14. Parallel delivery

### 14.1 Allowed boundary

Parallel implementation is permitted only between ready delivery slices. Each slice has its own branch, worktree, environment isolation, ledger, task loop, gate, PR, and monitor.

Tasks inside one slice remain sequential. Two agents never edit the same slice worktree concurrently.

### 14.2 Eligibility

Slices may run in parallel only when the orchestrator can state all of the following:

- neither depends on unmerged behavior from the other;
- their primary file and ownership surfaces do not overlap;
- any shared interface is already frozen or has one declared producer;
- migration ownership and merge order are explicit;
- isolated ports, databases, and other mutable runtime resources are available;
- each slice can independently pass tests, gate, and merge.

If these claims cannot be made confidently, execution is sequential. Parallelism is an optimization, never a completion requirement.

The bundled default permits at most two concurrent code-bearing slices. Project configuration may raise or lower the limit without changing skills.

### 14.3 Conflict graph and merge order

The living plan records a lightweight conflict graph for the current ready frontier: slice dependencies, overlapping surfaces, contract producer/consumer relationships, and required merge order. It need not model file-level detail already present in slice tasks.

When a producer slice changes a frozen interface, consumer work pauses until the contract and plan are updated. Consumers rebase or re-plan after the producer merges; they do not independently reinterpret the change.

### 14.4 Migrations and shared data models

One slice owns a schema or migration sequence at a time. A contract records the intended schema/interface, migration slot or ordering requirement, and downstream consumers. Consumer slices either:

- wait for the producer to merge, then plan against the real schema; or
- consume a fully frozen backward-compatible interface described by the contract.

Parallel lanes never create competing migrations or edit the same shared schema on an assumption that Git will resolve the semantic conflict.

## 15. Active-contract lifecycle

### 15.1 When to create one

A living plan creates at most one active contract, and only when its work:

- reserves a shared or cross-cutting surface another workstream may touch;
- changes an interface consumed by another active or planned slice;
- owns a migration or data-model transition with external consumers; or
- must communicate a temporary compatibility rule across worktrees.

Independent work with no coordination risk does not create a contract.

### 15.2 Canonical location and fields

Contracts live temporarily at:

```text
docs/active-contracts/<plan-slug>.md
```

Every contract records:

- status and owning living plan;
- owning orchestrator;
- created and last-verified dates;
- reserved surfaces;
- frozen interface or single-producer decision;
- producer and consumer ticket IDs;
- active branches, worktrees, and PRs when known;
- migration ownership or ordering when applicable;
- explicit coordination rules;
- exact prune trigger;
- final closeout owner.

### 15.3 Ownership

The living plan is the stable contract owner, and the one active top-level Resume Work orchestrator is its sole writer. Slice orchestrators, implementers, reviewers, and PR monitors treat the contract as read-only and report proposed changes to that owner. After a restart, Resume Work verifies that no prior owner is still live, records the ownership transfer, and becomes the sole writer. The owner updates the contract before authorizing implementation that would violate or change it.

### 15.4 Closing and pruning

Every plan that opens a contract contains an explicit closeout condition. The owner deletes the contract when its declared prune trigger is satisfied and every named consumer is merged, cancelled, or moved to a replacement contract. A living plan cannot close while it still owns a binding contract; if consumers must outlive the plan, ownership and all unresolved consumers are first transferred to a named replacement living plan and contract.

The disappearance or age of the original branch or worktree is not sufficient evidence of staleness. A contract may intentionally outlive its producer branch while consumers remain active.

### 15.5 Stale-contract audit

Start Work and Resume Work scan active contracts before shared-surface planning. Closeout audits the plan's own contract. A periodic lightweight audit may inspect:

- the declared prune trigger;
- Linear state of producer and consumer tickets;
- merged and open PRs;
- active Git branches and worktrees;
- the last-verified date.

The audit deletes a contract only when the trigger and consumer state prove it is obsolete. Otherwise it updates stale operational references or reports the unresolved owner. It does not infer deletion from age alone.

## 16. Logical agent routing

### 16.1 Principle

Skills request capabilities by logical role. They never name a provider model, harness-specific agent type, or reasoning effort directly.

The required role set is intentionally small:

| Role | Responsibility |
|---|---|
| `explorer` | Codebase discovery and bounded research |
| `planner` | Specifications, implementation plans, and difficult orchestration judgment |
| `implementer` | Production code and tests |
| `reviewer` | Spec, task, UX, plan, or slice review using a named specialty |
| `operator` | Mechanical Linear, Git, artifact, and wrapper operations |
| `monitor` | Long-running PR and external-state observation plus bounded fix orchestration |

Specialty is a request attribute, not another hard-coded model role. Examples are `spec`, `code`, `ux`, `security`, and `final-gate`.

### 16.2 Configuration

Routing is configured in one project file:

```text
.workstack/agents.json
```

The file supports:

- default mapping for each logical role;
- harness-specific mappings;
- workflow-specific overrides;
- reviewer-specialty overrides;
- model and effort fallback chains;
- required reviewer-independence policy.

Resolution precedence is:

1. explicit user override for the current run;
2. reviewer-specialty project override;
3. workflow-specific project override;
4. harness-specific project override;
5. project role default;
6. bundled WorkStack role default.

Only this file and the bundled defaults contain concrete model identifiers. Replacing a retired model or moving to a new generation requires one configuration change, not edits across skills.

### 16.3 Initial WorkStack defaults

The initial bundled WorkStack profile must encode the user-selected Sol routing:

- `implementer`: Sol, high effort;
- `explorer`: Sol, medium effort;
- `operator`: Sol, low effort.

Planner, reviewer, UX specialty, final-gate specialty, and monitor mappings are operational configuration rather than skill behavior. The distributed profile must supply valid defaults at release time, including an available reviewer path independent from the bundled author path, so a default installation passes preflight without project customization. This specification does not make a specific non-Sol model part of the workflow contract.

### 16.4 Preflight and fallback

The resolver prints and records the selected harness, model, effort, and fallback reason before dispatch. The destination harness owns availability checks. If dispatch reports that the primary destination is unavailable, the owning workflow tries configured fallbacks in order and records the reason.

Review dispatch additionally verifies that reviewer identity differs from author identity. If no independent reviewer is available, the gate fails closed and asks for a routing change. It never silently lets an author approve its own work.

Fallback never changes product scope, test requirements, or gate depth. It only changes who performs the logical role.

## 17. Durable execution and recovery

### 17.1 State authorities

Recovery trusts these sources in order:

1. merged commits and current PR head state;
2. the living plan's slice index and contract;
3. the worktree-local Superpowers progress ledger;
4. task reports and review packages;
5. Git history in the slice branch;
6. Linear status for coarse outcome state;
7. conversation memory last.

When these disagree, the orchestrator reconciles the less authoritative source before dispatching new work.

### 17.2 Worktree-local artifacts

Each slice worktree has ignored artifacts under `.superpowers/` for:

- progress ledger;
- task briefs;
- implementer and fixer reports;
- review packages and diff bundles;
- verification logs.

`docs/WORKTREE_CONTEXT.md` remains uncommitted and contains only the slice identity plus pointers to the living plan and required references.

### 17.3 Idempotent resume

Resume Work discovers rather than recreates:

- existing worktrees and branches;
- completed task commits and clean review records;
- open PRs and current head SHA;
- active monitor state;
- ticket status;
- contract producer and consumer state.

A task marked complete in the ledger with matching commits is not redispatched. An existing PR is monitored rather than recreated. A merged PR is reconciled rather than reopened. A satisfied contract prune trigger is closed exactly once.

### 17.4 Compaction behavior

The orchestrator writes state transitions before requesting the next expensive action. Compact chat summaries may aid orientation but never replace ledgers or files. Large inputs and outputs move by path so later turns do not repeatedly reread them in conversation context.

## 18. Artifact retention and cleanup

| Artifact | While active | At completion |
|---|---|---|
| Product specification | Committed and linked | Retained |
| Living implementation plan | Committed directly to `develop` for coordination | Removed from current tree by a coordination commit |
| Active contract | Committed directly to `develop` while binding | Deleted by its sole owner when the prune trigger is satisfied |
| Worktree context | Uncommitted pointer | Deleted with worktree |
| SDD ledger, briefs, reports, logs | Ignored, worktree-local | Deleted with worktree |
| Slice branch/worktree | Retained through exact-head merge | Pruned after merge confirmation |
| Linear tickets | Durable outcome record | Closed or cancelled with PR links |

Deleting a completed plan from the current tree is a clarity measure, not a Git-size optimization. Historical Markdown remains in Git history. A repository-history rewrite is outside this workflow and requires a separate operational decision.

## 19. Skill surface and call graph

The target distribution exposes three public WorkStack skills and keeps helpers internal:

```text
workstack-quick-task
  └─ Superpowers exploration/worktree/TDD/SDD/review primitives
     └─ WorkStack gate → PR monitor → closeout

workstack-start
  ├─ superpowers:brainstorming (WorkStack continuation)
  ├─ WorkStack spec verification
  ├─ Linear reconciliation
  └─ WorkStack living-plan creation
     └─ workstack-resume

workstack-resume
  ├─ planning checkpoint → superpowers:writing-plans
  ├─ ready slice → worktree → superpowers:subagent-driven-development
  ├─ conditional UX gate → whole-slice gate
  ├─ PR monitor → merge reconciliation
  └─ next frontier or closeout
```

Internal helpers may exist for spec review, role resolution, contract validation, gate packaging, and PR monitoring, but they are not advertised as alternate workflows. Their descriptions state which public skill owns them and they return control to that owner.

Project `AGENTS.md` must be able to explain the entire target workflow by reproducing the two Human Summary paragraphs, the three entry points, canonical artifact locations, and the hard invariants. It must label `docs/REVIEW-GUIDANCE.md` as reviewer-only and prohibit every non-review role from loading it. Detailed mechanics remain in the installed skills and this specification.

## 20. Failure and escalation rules

The workflow continues autonomously through implementation and ordinary fix loops. It stops and asks the user only when:

- a product or UX decision is missing from the approved specification;
- new evidence requires changing approved behavior or ticket scope;
- a destructive Git or data operation needs authority;
- two active contracts assert incompatible ownership and neither can be safely sequenced;
- no independent reviewer can be resolved;
- required external state remains unavailable and no configured fallback exists;
- a merge conflict changes semantics rather than permitting a mechanical rebase;
- verification cannot establish the slice's acceptance signals.

Routine task completion, clean reviews, planning checkpoints within approved scope, PR polling, and ordinary review fixes do not cause human check-ins.

## 21. Quality and efficiency requirements

1. Agent prompts pass bulky requirements, reports, diffs, and logs by file path.
2. Explorers are dispatched only for bounded questions whose results materially reduce planner or implementer uncertainty.
3. One reviewer combines task compliance and code quality.
4. Re-review resumes the same thread instead of rebuilding context in a new reviewer.
5. Final-review findings are fixed as one coherent batch where practical.
6. UX review uses one primary reviewer by default.
7. Cloud review occurs once per slice PR, never per task.
8. Linear updates occur only at coarse state transitions.
9. Detailed planning covers only the ready dependency frontier.
10. Quick Task avoids formal spec, ticket decomposition, and durable plan machinery when those artifacts would not improve coordination.
11. No fixed token budget may remove a required correctness gate; efficiency comes from eliminating redundant context and dispatches.
12. The normal orchestration path must not require the human to choose among more than the three public entry points.

## 22. Acceptance scenarios

The implemented workflow is acceptable only when all of these scenarios pass end to end.

### 22.1 Small quick task

A bounded bug fix with no ticket creates one ignored mini-plan, one slice worktree, one implementer task, one independent review that may also serve as the final gate, one PR, and one closeout. It creates no product spec, living plan, phase, or unnecessary Linear issue.

### 22.2 One-ticket feature

An approved specification produces one Linear ticket, one living plan, one slice with several sequential tasks, one whole-slice gate, and one PR. No task opens its own PR.

### 22.3 Multi-ticket sequential feature

Ten related tickets are organized into three delivery slices in one living plan. Slice 1 is detailed immediately. The future outcomes for Slices 2 and 3 remain planning checkpoints because their exact implementation depends on Slice 1. After Slice 1 merges, Resume Work re-explores current code, details the next ready frontier in the same plan, and continues without inventing an implementation phase.

### 22.4 Multi-ticket slice

Several small tickets affecting one coherent surface share a slice. They start together, pass one gate, merge in one PR, and close together. The PR body and plan make every included outcome traceable.

### 22.5 Safe parallel slices

Two ready slices with disjoint ownership run in isolated worktrees. Each uses a sequential inner loop and its own gate and PR. The plan records their conflict assessment. Either can merge without the other.

### 22.6 Shared schema producer and consumer

One slice owns a schema and migration change while another wants to consume it. The plan-owned contract names the producer, frozen interface, merge order, and consumer tickets. The consumer waits or uses the explicitly backward-compatible interface. The contract survives the producer branch when necessary and is pruned only after all named consumers satisfy its trigger.

### 22.7 Long-run recovery

After several tasks and one merged slice, the orchestrator loses conversation context. Resume Work reads the plan, ledgers, commits, PRs, Linear state, and contract; it does not redispatch completed tasks or recreate the merged PR, and it proceeds from the correct checkpoint.

### 22.8 Model retirement

A configured reviewer becomes unavailable. Updating `.workstack/agents.json` or activating its fallback restores every spec, task, UX, and gate review path without editing skill bodies. Reviewer-independence checks still pass.

### 22.9 Post-gate PR fix

Cloud review finds a real issue after the local gate. The PR monitor groups the fix, dispatches it, reruns covering tests, resumes the local gate reviewer on the delta, verifies exact-head CI and review, and merges only the approved head.

### 22.10 Contract cleanup

A plan completes after its final consumer merges. Closeout verifies the prune trigger, deletes the contract and active implementation plan from the current tree, removes worktrees and scratch ledgers, and leaves the product specification and Linear history intact.

### 22.11 Upstream update

The WorkStack fork merges a newer Superpowers release. Shared core remains unchanged except for the documented allowlist, wrapper compatibility tests pass, the three public entry points still invoke their expected upstream continuations, and the project-local canonical skill set updates from the fork without hand-editing a harness-specific copy.

## 23. Definition of done for the workflow implementation

The workflow itself is complete when:

1. the complete WorkStack skill set can be installed project-locally from the maintained fork into every supported harness without a global or project plugin dependency;
2. the three public entry points route correctly from clean sessions;
3. canonical specification, plan, contract, scratch, and routing locations are enforced;
4. the living plan supports deferred checkpoints and multi-ticket slices;
5. sequential SDD, combined task review, UX review, whole-slice gate, and PR monitoring close every fix loop;
6. parallel slices are isolated and contract-aware;
7. the role resolver supports project, harness, workflow, specialty, effort, and fallback changes from one file;
8. restart tests prove idempotent recovery from task, gate, PR, and post-merge states;
9. closeout tests prove all temporary artifacts and contracts have an owner and are pruned;
10. compatibility tests protect the small upstream divergence allowlist;
11. project `AGENTS.md` explains the workflow in two paragraphs plus the three entry points;
12. a human can execute the documented process without needing hidden agent-only state.

Until all twelve conditions pass, installation success is not workflow-completion evidence and FSMCRM's transitional `workstack-*` skills must not be removed merely because the fork's core skills are present.

## 24. Open questions

None. Concrete non-Sol model identifiers are operational routing values selected when the initial `.workstack/agents.json` is created; they are deliberately not part of the workflow contract.
