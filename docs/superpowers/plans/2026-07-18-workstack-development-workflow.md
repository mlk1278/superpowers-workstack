# WorkStack Development Workflow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` to execute each ready slice task-by-task. A worker receives one extracted task brief, not this whole plan.

**Status:** Active — Slice 1 gated

**Plan owner:** Top-level WorkStack workflow orchestrator

**Primary specification:** `docs/superpowers/specs/2026-07-18-workstack-development-workflow-spec.md`

**Linear tickets:** None assigned. Do not invent ticket IDs; add real IDs when this work is represented in Linear.

**Goal:** Deliver a maintainable WorkStack fork of current Superpowers with centralized agent routing, three simple project entry points, living-plan delivery slices, closed review and PR loops, and recoverable parallel coordination.

**Architecture:** Keep upstream Superpowers as the inner implementation engine and add WorkStack policy as wrapper skills and small deterministic helpers. Permit only three documented core seams. Detail only the current dependency frontier; re-explore and plan later slices after their prerequisites merge.

**Tech stack:** Markdown skills, POSIX/Bash test scripts, Python 3 standard library for deterministic configuration resolution, Git/GitHub, and existing Superpowers test infrastructure.

## Global Constraints

- Preserve upstream plugin identity and `superpowers:*` skill references.
- Do not copy skills per harness; every harness packages the shared `skills/` tree.
- Skills request logical roles only. Concrete harness, model, and effort values live in bundled defaults or `.workstack/agents.json`.
- Default routing is Sol high for implementation, Sol medium for exploration, and Sol low for mechanical operations.
- Reviewers must resolve to a different model identity from the author or preflight fails closed.
- Use no new third-party runtime dependency.
- Keep the inner task loop sequential. Parallelism is allowed only between independent delivery slices in separate worktrees.
- One delivery slice produces one whole-slice gate and one pull request.
- Keep Linear coarse: local plan steps and review findings are not tickets.
- Phase and timebox vocabulary has no implementation semantics.
- Durable files, Git state, ledgers, PR state, and contracts outrank conversation memory.
- Every temporary artifact has one owner and an explicit close condition.

## Completion Signals

- The fork installs as one artifact in supported harnesses and retains upstream skill references.
- Agent roles, efforts, fallbacks, and reviewer specialties are changed centrally without editing workflow skills.
- The three allowlisted core seams have deterministic regression tests and fresh-agent behavioral evidence.
- Quick Task, Start Work, and Resume Work execute the specified slice, gate, PR, recovery, and closeout lifecycle.
- FSMCRM uses the fork and its `AGENTS.md` explains the workflow in two paragraphs plus the three entry points.
- Pilot runs prove a quick task, sequential multi-ticket work, and safe parallel slices.

## Decision Log

| Date | Decision | Reason |
|---|---|---|
| 2026-07-18 | Fork `obra/superpowers` as `mlk1278/superpowers-workstack`; preserve the prior refined fork on `legacy-refined-v5`. | Keeps a real upstream relationship while retaining historical work. |
| 2026-07-18 | Upstream v6.1.1 (`d884ae04`) is the initial baseline. | Current Superpowers is substantially lighter and is the preferred inner engine. |
| 2026-07-18 | Use a living plan with detailed ready slices and deferred planning checkpoints. | Dependent later work should be planned against code that actually exists. |
| 2026-07-18 | Use logical roles and centralized routing. | Model retirement or harness changes should require one configuration edit. |
| 2026-07-18 | Bundle Claude Opus 4.8 high as the primary reviewer and Codex GPT-5.5 high as its fallback. | A default install needs an independent non-Sol review path; these remain replaceable operational values in routing configuration. |
| 2026-07-18 | Use JSON configuration and Python's standard parser. | Keeps routing deterministic without maintaining a custom configuration parser. |
| 2026-07-18 | Do not inherit controller conversation history into implementation or review agents. | File handoffs provide bounded context and avoid repeated token load. |

## Context and Subagent Contract

The top-level orchestrator alone owns this plan, the slice index, active contracts, agent identifiers, and unresolved decisions. It may read the full specification when planning or gating, but implementation agents do not. Large briefs, reports, diffs, and logs move by file path under the existing ignored `.superpowers/` workspace.

Each implementation task uses this sequence:

1. Extract one task plus `Global Constraints` into a task brief.
2. Dispatch a fresh Sol-high implementer with only the brief path, explicitly named prior interfaces, repository instructions, and a report path.
3. Require tests, self-review, a commit, and a compact return containing status, commit, verification, and concerns.
4. Build a file-based diff package and dispatch a fresh independent reviewer with the brief, report, constraints, and diff paths.
5. Send the complete finding set to a fixer, then resume the same reviewer thread for the delta until clean.
6. Use one fresh independent reviewer for the believed-final whole-slice diff and close that loop before opening a PR.

Exploration is bounded and normally Sol medium. Planning and difficult orchestration judgment are Sol high. Git/Linear wrapper operations are Sol low. PR monitoring is Sol medium. Reviewer and specialty defaults are resolved centrally and must remain independent from the author. No arbitrary token cap is imposed; context is bounded by ownership and file-based handoffs.

## Delivery-Slice Index

| Slice | Outcome | Tickets | Dependencies | State | Branch/worktree | Contract impact | PR |
|---|---|---|---|---|---|---|---|
| S1 — Fork and routing foundation | Govern upstream divergence; resolve logical roles; package WorkStack skills | None assigned | None | Gated | `workstack/workflow-foundation` at `/home/mkirk/projects/superpowers-workstack` | None | — |
| S2 — Core extension seams | Add the three allowlisted generic seams with regression evidence | None assigned | S1 merged | Deferred | — | None | — |
| S3 — Artifact and recovery model | Implement living-plan, ledger, context, and resume helpers | None assigned | S2 merged | Deferred | — | Reserved surfaces likely | — |
| S4 — Public WorkStack entry points | Add Quick Task, Start Work, and Resume Work wrappers | None assigned | S3 merged | Deferred | — | None | — |
| S5 — Slice gates and PR lifecycle | Add UX gate, whole-slice gate, PR monitor, and reconciliation | None assigned | S4 merged | Deferred | — | None | — |
| S6 — Parallel delivery contracts | Add conflict graph, active contracts, and pruning | None assigned | S5 merged | Deferred | — | Producer | — |
| S7 — Harness and FSMCRM cutover | Validate packages and replace FSMCRM's transitional local workflow | None assigned | S6 merged | Deferred | — | Consumer | — |
| S8 — Pilots and closeout | Run representative pilots, fix gaps, prune temporary artifacts | None assigned | S7 merged | Deferred | — | Close all | — |

---

## Ready Slice S1 — Fork and Routing Foundation

**Goal:** Establish the maintainable fork boundary and one deterministic source of agent routing without changing upstream workflow behavior.

**Acceptance signals:**

- A machine-readable allowlist names the three permitted upstream core divergences and their reasons.
- A check rejects unlisted changes to upstream-owned files under the baseline `skills/` tree while permitting WorkStack skill additions and fork-owned build/test changes.
- A bundled routing profile resolves role, harness, workflow, specialty, effort, fallback, and reviewer-independence settings.
- Project overrides come from one `.workstack/agents.json` file.
- Sol high/medium/low defaults are encoded only in routing configuration, not skill prose.
- Codex packaging includes WorkStack skills and accepts committed OpenAI metadata for fork-owned skills.
- Existing upstream tests remain green.

### Task 1: Add fork divergence governance

**Files:**

- Create: `workstack/upstream-divergences.json`
- Create: `scripts/check-workstack-divergences.py`
- Create: `tests/workstack/test-upstream-divergences.sh`
- Modify: `.gitignore`

**Interfaces:**

- Consumes: upstream baseline commit `d884ae04edebef577e82ff7c4e143debd0bbec99`.
- Produces: `python3 scripts/check-workstack-divergences.py [--ref REF]`, exiting zero only when every changed upstream-owned file under `skills/` is allowlisted. Fork additions under `skills/workstack-*`, build scripts, tests, docs, and harness manifests are outside the protected core surface.

- [ ] Write a fixture-driven shell test that creates a temporary Git repository with a baseline file, a permitted modification, an unlisted modification, and a WorkStack-only added file. Verify the checker accepts the permitted modification and addition, and rejects the unlisted baseline-file change with its path in stderr.
- [ ] Add `workstack/upstream-divergences.json` with the baseline SHA and exactly these permitted core paths: `skills/brainstorming/SKILL.md`, `skills/writing-plans/SKILL.md`, `skills/subagent-driven-development/SKILL.md`, and `skills/subagent-driven-development/scripts/task-brief`. Give each entry one short generic reason.
- [ ] Implement the checker with Python 3 standard-library JSON and subprocess APIs. Compare the requested ref with the configured baseline, protect files that existed under the baseline's `skills/` tree, ignore fork-only `skills/workstack-*` additions, and reject every modified/deleted protected skill path absent from the allowlist. Tests, build scripts, docs, and harness manifests are deliberately outside this core-divergence policy.
- [ ] Add `.workstack/` only if needed for local generated state; do not ignore project-owned `.workstack/agents.json`. Preserve the existing `.superpowers/` ignore.
- [ ] Run `bash tests/workstack/test-upstream-divergences.sh`; expect `PASS`.
- [ ] Run `python3 scripts/check-workstack-divergences.py`; expect exit 0.
- [ ] Commit the task.

### Task 2: Add centralized logical agent routing

**Files:**

- Create: `skills/workstack-agent-routing/SKILL.md`
- Create: `skills/workstack-agent-routing/defaults.json`
- Create: `skills/workstack-agent-routing/scripts/resolve-agent`
- Create: `skills/workstack-agent-routing/agents/openai.yaml`
- Create: `tests/workstack/test-agent-routing.sh`

**Interfaces:**

- Consumes: optional `<project-root>/.workstack/agents.json`; role; optional harness, workflow, reviewer specialty, and author identity.
- Produces: normalized JSON on stdout containing `role`, `harness`, `model`, `effort`, ordered `fallbacks`, `source`, and `fallback_reason`; nonzero exit with a direct diagnostic when no route or no independent reviewer is available.

- [ ] Write table-driven shell fixtures for bundled defaults and every precedence layer: project role, harness, workflow, explicit run override, and reviewer specialty. Add fallback and author/reviewer identity cases.
- [ ] Define a small JSON schema containing role defaults, per-harness and per-workflow role overrides, reviewer specialties, and ordered fallback routes.
- [ ] Add bundled defaults for `explorer` (Sol medium), `planner` (Sol high), `implementer` (Sol high), `operator` (Sol low), and `monitor` (Sol medium). Configure Claude Opus 4.8 high as the primary reviewer and Codex GPT-5.5 high as its fallback, with specialty overrides where needed. Concrete model identifiers appear only in this file and project overrides.
- [ ] Implement `resolve-agent` with Python 3 standard library only. Resolve in this order: explicit run override; reviewer specialty; workflow; harness; project role; bundled role. Validate the selected route, fallback order, and reviewer identity; leave model availability to the destination harness.
- [ ] Write `SKILL.md` as an internal helper owned by the future public WorkStack entry points. It must instruct callers to request logical roles, record the normalized result before dispatch, and fail closed on reviewer-independence errors.
- [ ] Run `bash tests/workstack/test-agent-routing.sh`; expect all precedence, fallback, and independence cases to pass.
- [ ] Run `! rg -ni '\b(gpt-[[:alnum:].-]+|claude-[[:alnum:].-]+|opus|sonnet|terra|luna|sol)\b' skills/workstack-* --glob 'SKILL.md'`; expect exit 0 and no concrete model identifiers.
- [ ] Commit the task.

### Task 3: Make fork-owned skills package across harnesses

**Files:**

- Modify: `scripts/package-codex-plugin.sh`
- Modify: `tests/codex/test-package-codex-plugin.sh`
- Test: existing harness manifest and package tests under `tests/`

**Interfaces:**

- Consumes: committed `skills/<fork-skill>/agents/openai.yaml` when present; external official metadata remains the source for upstream skills.
- Produces: the same rootless Codex package shape, now including fork-owned skills without requiring them to exist in an older official metadata archive.

- [ ] Add a failing packaging test proving that a fork-owned skill's committed OpenAI metadata is retained even when the external metadata fixture has no entry for that skill.
- [ ] Change packaging metadata precedence to: committed source metadata first; external metadata second; clear failure when neither exists. Do not alter package contents outside this metadata behavior.
- [ ] Assert the packaged `workstack-agent-routing` skill contains `SKILL.md`, `defaults.json`, executable resolver, and `agents/openai.yaml`.
- [ ] Run `bash tests/codex/test-package-codex-plugin.sh`; expect all archive and metadata cases to pass.
- [ ] Run `bash tests/codex/test-marketplace-manifest.sh`, `bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh`, and the existing supported-harness manifest tests; expect exit 0.
- [ ] Run `git diff --check` and `python3 scripts/check-workstack-divergences.py`; expect exit 0.
- [ ] Commit the task.

### S1 Slice Verification and Gate

- [ ] Run `bash tests/workstack/test-upstream-divergences.sh`.
- [ ] Run `bash tests/workstack/test-agent-routing.sh`.
- [ ] Run `bash tests/codex/test-package-codex-plugin.sh`.
- [ ] Run the existing shell/manifest tests affected by shared-skill packaging.
- [ ] Generate one review package from the slice base through current HEAD.
- [ ] Dispatch an independent final-gate reviewer with the specification, this slice section, verification log, divergence report, and diff package by path.
- [ ] Fix the complete finding set, rerun covering verification, and resume the same reviewer until it approves current HEAD.
- [ ] Open exactly one PR for S1 and merge only its reviewed head.

---

## Deferred Slice S2 — Core Extension Seams

**Planning trigger:** S1 is merged and the routing/package checks pass from a clean checkout.

**Goal:** Add only the three generic extension seams authorized by the specification, with deterministic regression tests and fresh-agent behavioral evidence.

**Acceptance signals:** default upstream behavior is unchanged; callers may select an alternate post-brainstorm/post-plan continuation; every task brief includes global constraints; final whole-branch review fixes and re-reviews findings before branch completion.

### Task 4: Add optional continuation contracts

**Files:**

- Modify: `skills/brainstorming/SKILL.md`
- Modify: `skills/writing-plans/SKILL.md`
- Create: `tests/workstack/test-continuation-seams.sh`

**Interfaces:** A caller may name one approved continuation before invoking either skill. When absent, brainstorming still continues to `superpowers:writing-plans`, and plan writing still offers its current execution handoff.

- [ ] Add deterministic assertions for both custom and default continuation text and for preservation of the existing approval gates.
- [ ] Add the smallest possible continuation clause to each skill; do not introduce WorkStack vocabulary or model routing into upstream skill bodies.
- [ ] Run the focused test and existing brainstorming/writing-plan tests.
- [ ] Use fresh agents to exercise default and caller-supplied scenarios. Save prompts and compact verdicts under ignored `.superpowers/evals/`.
- [ ] Commit the task.

### Task 5: Include global constraints in every task brief

**Files:**

- Modify: `skills/subagent-driven-development/scripts/task-brief`
- Modify: `tests/claude-code/test-sdd-workspace.sh`

**Interfaces:** `task-brief PLAN_FILE TASK_NUMBER [OUTFILE]` keeps its CLI and output format; the generated file contains the plan's `## Global Constraints` section followed by the selected task.

- [ ] Extend the deterministic fixture with global constraints and assert exact inclusion, ordering, and exclusion of neighboring tasks.
- [ ] Update `task-brief` with one bounded extraction pass that preserves fenced-code handling.
- [ ] Run `bash tests/claude-code/test-sdd-workspace.sh`; expect `PASS`.
- [ ] Run one fresh-agent task-brief comprehension scenario and save the compact verdict under `.superpowers/evals/`.
- [ ] Commit the task.

### Task 6: Close the final review loop

**Files:**

- Modify: `skills/subagent-driven-development/SKILL.md`
- Create: `tests/workstack/test-final-review-gate.sh`

**Interfaces:** Final review produces a verdict for an exact HEAD. Findings are fixed together, covering verification reruns, and the same reviewer thread approves the delta/current HEAD before `finishing-a-development-branch` is invoked.

- [ ] Add deterministic assertions for exact-head review, batched fixes, same-thread re-review, covering verification, and prohibition on branch completion with open findings.
- [ ] Update the process graph, final-review instructions, example, and red flags consistently. Reuse the existing review-package mechanism and avoid a new orchestration script.
- [ ] Run focused and existing SDD tests.
- [ ] Run fresh-agent scenarios with a clean final diff and with an injected final-review finding. Confirm only the clean/current-head path reaches branch completion.
- [ ] Run `python3 scripts/check-workstack-divergences.py`; confirm only allowlisted core paths differ.
- [ ] Commit the task.

### S2 Slice Verification and Gate

- [ ] Run all focused continuation, task-brief, final-gate, and existing SDD tests.
- [ ] Record fresh-agent prompts, selected routes, agent identities, and compact verdicts under `.superpowers/evals/`.
- [ ] Generate a whole-slice review package and dispatch an independent final-gate reviewer by file path.
- [ ] Close the finding loop on current HEAD, then open exactly one S2 PR.

---

## Planning Checkpoints

### Checkpoint C3 — Artifact and Recovery Model

- **Trigger:** S2 merged.
- **Outcome:** Define and implement the living-plan schema, slice index transitions, ignored worktree context, progress ledger, durable recovery order, and closeout ownership.
- **Re-explore:** current SDD workspace scripts, worktree helpers, plan format, and restart behavior.
- **Do not pre-plan:** exact helper paths or state serialization until the core seams are merged.

### Checkpoint C4 — Three Public Entry Points

- **Trigger:** C3 artifacts pass restart/idempotency tests.
- **Outcome:** Implement only `workstack-quick-task`, `workstack-start`, and `workstack-resume`, each calling upstream skills through the continuation seams and centralized routing.
- **Re-explore:** skill discovery/trigger behavior in every supported harness and the packaged routing helper.

### Checkpoint C5 — Slice, UX, and PR Lifecycle

- **Trigger:** the public wrappers can create and resume one local slice.
- **Outcome:** Add conditional UX evidence, whole-slice gate packaging, exact-head PR creation, monitoring, ordinary review-fix loops, merge reconciliation, and cleanup.
- **Re-explore:** FSMCRM verification commands, current GitHub/CodeRabbit review surfaces, and existing WorkStack monitor behavior.

### Checkpoint C6 — Parallel Slices and Active Contracts

- **Trigger:** one sequential slice completes end-to-end.
- **Outcome:** Add dependency/conflict classification, separate worktrees, lightweight contract creation, producer/consumer status, stale audit, and owner-driven pruning.
- **Re-explore:** FSMCRM migration/data-model ownership and real overlap patterns. Keep parallelism outside the inner SDD loop.

### Checkpoint C7 — Harness and FSMCRM Cutover

- **Trigger:** contracts and closeout tests pass.
- **Outcome:** Install the fork in supported harnesses, add project `.workstack/agents.json`, replace transitional local workflow skills, and update FSMCRM `AGENTS.md` with the concise human workflow.
- **Re-explore:** current FSMCRM skills and any changes made since commit `4787cf51`; preserve unrelated user work.

### Checkpoint C8 — Pilots and Final Closeout

- **Trigger:** FSMCRM cutover is merged.
- **Outcome:** Run a quick-task pilot, a sequential multi-ticket pilot with an intermediate planning checkpoint, and two independent parallel slices with a contract. Fix specification gaps, close contracts, remove active plans and worktrees, and document upstream-update procedure.

## Final Closeout Conditions

- All specification definition-of-done checks pass.
- Every delivery PR is merged at its independently reviewed head.
- Linear is reconciled only for real assigned tickets.
- No active contract, branch, worktree, monitor, or ignored run artifact remains without an owner.
- This living plan is removed from the current tree by a coordination commit after S8; Git history remains the record.
