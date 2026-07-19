# WorkStack Development Workflow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` to execute each ready slice task-by-task. A worker receives one extracted task brief, not this whole plan.

**Status:** Active — S1 complete; S2 landed (fresh-agent eval evidence consolidated into S3); remaining work re-sliced into S3–S6 on 2026-07-19; Checkpoint C3 is next

**Plan owner:** Top-level WorkStack workflow orchestrator

**Primary specification:** `docs/superpowers/specs/2026-07-18-workstack-development-workflow-spec.md`

**Linear tickets:** None assigned. Do not invent ticket IDs; add real IDs when this work is represented in Linear.

**Goal:** Deliver a maintainable WorkStack fork of current Superpowers with centralized agent routing, three simple project entry points, living-plan delivery slices, closed review and PR loops, and recoverable parallel coordination.

**Architecture:** Keep upstream Superpowers as the inner implementation engine and add WorkStack policy as wrapper skills and small deterministic helpers. Permit only the documented core seams. Distribute the shared skill tree project-locally from the maintained fork rather than relying on a global plugin install. Detail only the current dependency frontier; re-explore and plan later slices after their prerequisites merge.

**Tech stack:** Markdown skills, POSIX/Bash test scripts, Python 3 standard library for deterministic configuration resolution, Git/GitHub, and existing Superpowers test infrastructure.

## Global Constraints

- Preserve upstream skill names and `superpowers:*` references.
- Maintain one project-local canonical skill set sourced from the fork. Harness-specific directories may link to that set but must not contain independently edited copies.
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
- New WorkStack skills match the concision bar of FSMCRM's transitional set: small SKILL.md files (roughly 30–60 lines) with explicit entry/exit conditions, no restatement of upstream Superpowers mechanics, and no duplication of another skill's owned mechanics.
- Every shared workflow concept (gate ownership, contract rules, scratch layout, review lanes) is defined in exactly one document that other skills reference.
- The core loop must remain explainable in two `AGENTS.md` paragraphs plus the three entry points; when a design cannot be explained that simply, simplify the design rather than the explanation.
- Project-specific mechanics (provider names, helper scripts, port allocation) stay in FSMCRM configuration and docs, never in fork skills.

## Completion Signals

- The fork's complete skill set installs project-locally in supported harnesses from one maintained source and retains upstream skill references.
- Agent roles, efforts, fallbacks, and reviewer specialties are changed centrally without editing workflow skills.
- The four documented core extension behaviors have deterministic regression tests and fresh-agent behavioral evidence.
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
| 2026-07-19 | S1 merged through PR #1 at `4694832`; S2 landed on `main` at `7a392aa` after focused tests and independent review/fix loops. | Records the actual implementation frontier instead of treating the fork as workflow-complete. |
| 2026-07-19 | Install the fork project-locally with the npm-delivered Agent Skills installer, using `.agents/skills` as the canonical set and harness links where supported. Do not install the WorkStack fork globally or depend on plugin activation. | The workflow is project-specific, and Codex does not provide equivalent project-scoped plugin activation. |
| 2026-07-19 | Do not remove FSMCRM's transitional `workstack-*` skills until S3-S6 provide and validate their replacement behavior. | S1-S2 supply routing and core extension seams only; they do not yet implement the three public entry points or full delivery lifecycle. |
| 2026-07-19 | Exercised project-local installation in FSMCRM: the installer discovered and installed all 15 fork skills for Claude Code and Codex, and the global fork plugin was removed. This is installation validation, not workflow cutover. | Prevents skill presence from being mistaken for completion of the replacement workflow. |
| 2026-07-19 | Re-sliced remaining work from six slices (S3–S8) to four (S3–S6): quick-task delivery loop first, then living-plan entry points, then parallel contracts, then a combined cutover/pilot/closeout slice. | The prior split shipped recovery helpers with no consumer and entry-point wrappers that could not complete their own lifecycle; each remaining slice now ends in a demonstrable workflow capability. |
| 2026-07-19 | Consolidate S2's pending fresh-agent behavioral evals into S3 verification instead of retrofitting synthetic eval sessions now. | A real quick-task run exercises all four S2 seams end to end and produces the same evidence once. |
| 2026-07-19 | Run FSMCRM pilots before removing the transitional `workstack-*` skills; removal is a closeout step of the final slice. | Spec Section 23 forbids removing transitional skills until acceptance evidence exists; the prior checkpoint order removed them before pilots ran. |
| 2026-07-19 | Use FSMCRM's transitional skills as the primary design reference when detailing S3–S6, porting their tested rules while replacing phase vocabulary with slice vocabulary and keeping project-specific mechanics in FSMCRM configuration. | The transitional set encodes battle-tested operational discipline (gate ownership, ledger recovery, PR monitoring) that should be harvested, not reinvented. |
| 2026-07-19 | Do not refresh FSMCRM's project-local fork install with new `workstack-*` entry points until the S6 cutover. | The fork's planned entry-point names collide with transitional skill names (`workstack-quick-task` first); collision handling belongs to the cutover step. |

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
| S1 — Fork and routing foundation | Govern upstream divergence; resolve logical roles; package WorkStack skills | None assigned | None | Complete | `main` at `4694832` | None | PR #1 |
| S2 — Core extension seams | Add continuation, task-brief, final-gate, and reviewer-context seams with regression evidence | None assigned | S1 merged | Landed; fresh-agent eval evidence consolidated into S3 | `main` at `7a392aa` | None | Direct push authorized by user |
| S3 — Quick-task delivery loop | Ship `workstack-quick-task` plus the slice lifecycle it needs: whole-slice gate, conditional UX evidence, exact-head PR, monitor, closeout; capture fresh-agent seam evidence | None assigned | S2 merged | Ready to plan | — | None | — |
| S4 — Living plan and planned-work entry points | Add living-plan schema, ledger/recovery, Linear reconciliation, `workstack-start`, and `workstack-resume` | None assigned | S3 merged | Deferred | — | Reserved surfaces likely | — |
| S5 — Parallel delivery contracts | Add conflict graph, active contracts, and pruning | None assigned | S4 merged | Deferred | — | Producer | — |
| S6 — Cutover, pilots, and closeout | Install refresh, `.workstack/agents.json`, `AGENTS.md` rewrite, pilots, transitional-skill removal, artifact pruning | None assigned | S5 merged | Deferred | — | Close all | — |

---

## Completed Slice S1 — Fork and Routing Foundation

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
- Inspect: `.gitignore` (no change required)

**Interfaces:**

- Consumes: upstream baseline commit `d884ae04edebef577e82ff7c4e143debd0bbec99`.
- Produces: `python3 scripts/check-workstack-divergences.py [--ref REF]`, exiting zero only when every changed upstream-owned file under `skills/` is allowlisted. Fork additions under `skills/workstack-*`, build scripts, tests, docs, and harness manifests are outside the protected core surface.

- [x] Write a fixture-driven shell test that creates a temporary Git repository with a baseline file, a permitted modification, an unlisted modification, and a WorkStack-only added file. Verify the checker accepts the permitted modification and addition, and rejects the unlisted baseline-file change with its path in stderr.
- [x] Add `workstack/upstream-divergences.json` with the baseline SHA and the permitted core paths plus one short reason for each divergence.
- [x] Implement the checker with Python 3 standard-library JSON and subprocess APIs. Compare the requested ref with the configured baseline, protect files that existed under the baseline's `skills/` tree, ignore fork-only `skills/workstack-*` additions, and reject every modified/deleted protected skill path absent from the allowlist. Tests, build scripts, docs, and harness manifests are deliberately outside this core-divergence policy.
- [x] Add `.workstack/` only if needed for local generated state; do not ignore project-owned `.workstack/agents.json`. Preserve the existing `.superpowers/` ignore.
- [x] Run `bash tests/workstack/test-upstream-divergences.sh`; expect `PASS`.
- [x] Run `python3 scripts/check-workstack-divergences.py`; expect exit 0.
- [x] Commit the task.

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

- [x] Write table-driven shell fixtures for bundled defaults and every precedence layer: project role, harness, workflow, explicit run override, and reviewer specialty. Add fallback and author/reviewer identity cases.
- [x] Define a small JSON schema containing role defaults, per-harness and per-workflow role overrides, reviewer specialties, and ordered fallback routes.
- [x] Add bundled defaults for `explorer` (Sol medium), `planner` (Sol high), `implementer` (Sol high), `operator` (Sol low), and `monitor` (Sol medium). Configure an independent primary reviewer and fallback, with specialty overrides where needed. Concrete model identifiers appear only in this file and project overrides.
- [x] Implement `resolve-agent` with Python 3 standard library only. Resolve in this order: explicit run override; reviewer specialty; workflow; harness; project role; bundled role. Validate the selected route, fallback order, and reviewer identity; leave model availability to the destination harness.
- [x] Write `SKILL.md` as an internal helper owned by the future public WorkStack entry points. It instructs callers to request logical roles, record the normalized result before dispatch, and fail closed on reviewer-independence errors.
- [x] Run `bash tests/workstack/test-agent-routing.sh`; expect all precedence, fallback, and independence cases to pass.
- [x] Run the concrete-model-name guard against `skills/workstack-*/SKILL.md`; expect no identifiers in skill prose.
- [x] Commit the task.

### Task 3: Make fork-owned skills package across harnesses

**Files:**

- Modify: `scripts/package-codex-plugin.sh`
- Modify: `tests/codex/test-package-codex-plugin.sh`
- Test: existing harness manifest and package tests under `tests/`

**Interfaces:**

- Consumes: committed `skills/<fork-skill>/agents/openai.yaml` when present; external official metadata remains the source for upstream skills.
- Produces: the same rootless Codex package shape, now including fork-owned skills without requiring them to exist in an older official metadata archive.

- [x] Add a failing packaging test proving that a fork-owned skill's committed OpenAI metadata is retained even when the external metadata fixture has no entry for that skill.
- [x] Change packaging metadata precedence to: committed source metadata first; external metadata second; clear failure when neither exists. Do not alter package contents outside this metadata behavior.
- [x] Assert the packaged `workstack-agent-routing` skill contains `SKILL.md`, `defaults.json`, executable resolver, and `agents/openai.yaml`.
- [x] Run `bash tests/codex/test-package-codex-plugin.sh`; expect all archive and metadata cases to pass.
- [x] Run `bash tests/codex/test-marketplace-manifest.sh`, `bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh`, and the existing supported-harness manifest tests; expect exit 0.
- [x] Run `git diff --check` and `python3 scripts/check-workstack-divergences.py`; expect exit 0.
- [x] Commit the task.

### S1 Slice Verification and Gate

- [x] Run `bash tests/workstack/test-upstream-divergences.sh`.
- [x] Run `bash tests/workstack/test-agent-routing.sh`.
- [x] Run `bash tests/codex/test-package-codex-plugin.sh`.
- [x] Run the existing shell/manifest tests affected by shared-skill packaging.
- [x] Generate one review package from the slice base through current HEAD.
- [x] Dispatch an independent final-gate reviewer with the specification, this slice section, verification log, divergence report, and diff package by path.
- [x] Fix the complete finding set, rerun covering verification, and resume the same reviewer until it approves current HEAD.
- [x] Open exactly one PR for S1 and merge only its reviewed head. Merged as PR #1 at `4694832`.

---

## Landed Slice S2 — Core Extension Seams

**Planning trigger:** S1 is merged and the routing/package checks pass from a clean checkout.

**Goal:** Add only the four generic extension behaviors authorized by the specification, with deterministic regression tests and fresh-agent behavioral evidence.

**Acceptance signals:** default upstream behavior is unchanged; callers may select an alternate post-brainstorm/post-plan continuation; every task brief includes global constraints; final whole-branch review fixes and re-reviews findings before branch completion; project review guidance is read only by reviewers and may be supplemented with scoped orchestrator nuance.

**Follow-up:** The unchecked fresh-agent eval items below are consolidated into S3 verification. A real quick-task run exercises all four seams with fresh agents; S3 records its prompts and compact verdicts under ignored `.superpowers/evals/` in their place.

### Task 4: Add optional continuation contracts

**Files:**

- Modify: `skills/brainstorming/SKILL.md`
- Modify: `skills/writing-plans/SKILL.md`
- Create: `tests/workstack/test-continuation-seams.sh`

**Interfaces:** A caller may name one approved continuation before invoking either skill. When absent, brainstorming still continues to `superpowers:writing-plans`, and plan writing still offers its current execution handoff.

- [x] Add deterministic assertions for both custom and default continuation text and for preservation of the existing approval gates.
- [x] Add the smallest possible continuation clause to each skill; do not introduce WorkStack vocabulary or model routing into upstream skill bodies.
- [x] Run the focused test and existing brainstorming/writing-plan tests.
- [ ] Use fresh agents to exercise default and caller-supplied scenarios. Save prompts and compact verdicts under ignored `.superpowers/evals/`.
- [x] Commit the task.

### Task 5: Include global constraints in every task brief

**Files:**

- Modify: `skills/subagent-driven-development/scripts/task-brief`
- Modify: `tests/claude-code/test-sdd-workspace.sh`

**Interfaces:** `task-brief PLAN_FILE TASK_NUMBER [OUTFILE]` keeps its CLI and output format; the generated file contains the plan's `## Global Constraints` section followed by the selected task.

- [x] Extend the deterministic fixture with global constraints and assert exact inclusion, ordering, and exclusion of neighboring tasks.
- [x] Update `task-brief` with one bounded extraction pass that preserves fenced-code handling.
- [x] Run `bash tests/claude-code/test-sdd-workspace.sh`; expect `PASS`.
- [ ] Run one fresh-agent task-brief comprehension scenario and save the compact verdict under `.superpowers/evals/`.
- [x] Commit the task.

### Task 6: Close the final review loop

**Files:**

- Modify: `skills/subagent-driven-development/SKILL.md`
- Create: `tests/workstack/test-final-review-gate.sh`

**Interfaces:** Final review produces a verdict for an exact HEAD. Findings are fixed together, covering verification reruns, and the same reviewer thread approves the delta/current HEAD before `finishing-a-development-branch` is invoked.

- [x] Add deterministic assertions for exact-head review, batched fixes, same-thread re-review, covering verification, and prohibition on branch completion with open findings.
- [x] Update the process graph, final-review instructions, example, and red flags consistently. Reuse the existing review-package mechanism and avoid a new orchestration script.
- [x] Run focused and existing SDD tests.
- [ ] Run fresh-agent scenarios with a clean final diff and with an injected final-review finding. Confirm only the clean/current-head path reaches branch completion.
- [x] Run `python3 scripts/check-workstack-divergences.py`; confirm only allowlisted core paths differ.
- [x] Commit the task.

### Task 7: Add reviewer-only project guidance

**Files:**

- Modify: `skills/requesting-code-review/SKILL.md`
- Modify: `skills/requesting-code-review/code-reviewer.md`
- Modify: `skills/subagent-driven-development/SKILL.md`
- Modify: `skills/subagent-driven-development/task-reviewer-prompt.md`
- Create: `tests/workstack/test-reviewer-context.sh`

**Interfaces:** Reviewers, and only reviewers, discover `docs/REVIEW-GUIDANCE.md` when present. The orchestrator may add task-specific nuance without reading or summarizing the general guidance, and neither source may pre-judge the review verdict.

- [x] Add deterministic assertions for reviewer-only discovery, orchestrator-supplied nuance, non-review exclusion, and UX/project-rule coverage.
- [x] Update ad hoc and SDD review prompts to let the reviewer read canonical project guidance directly.
- [x] Keep reviewer guidance out of orchestrator, explorer, planner, and implementer context.
- [x] Run `bash tests/workstack/test-reviewer-context.sh`; expect `PASS`.
- [x] Obtain independent high-effort review of the reviewer-context seam and apply the accepted findings.
- [x] Commit the task.

### S2 Slice Verification and Gate

- [x] Run all focused continuation, task-brief, final-gate, reviewer-context, and existing SDD tests.
- [ ] Record fresh-agent prompts, selected routes, agent identities, and compact verdicts under `.superpowers/evals/`.
- [x] Generate whole-slice handoff/review material and obtain independent Codex and Fable feedback.
- [x] Close accepted findings on current HEAD and land S2. Actual delivery: the user authorized a direct push of `7a392aa` to `main`; no S2 PR was opened.

---

## Planning Checkpoints

### Checkpoint C3 — Quick-Task Delivery Loop

- **Trigger:** S2 merged. Trigger satisfied at `7a392aa`; this is the next planning action.
- **Outcome:** Implement `workstack-quick-task` end to end: bounded exploration, ignored mini-plan and brief under `.superpowers/`, the existing SDD loop through the S2 seams, whole-slice gate, conditional UX evidence, exact-head PR creation, PR monitoring, and scratch/worktree cleanup. Record fresh-agent evidence for all four S2 seams from real runs under `.superpowers/evals/`.
- **Re-explore:** upstream SDD workspace scripts and the review-package mechanism; FSMCRM's transitional `workstack-quick-task`, `workstack-review`, `workstack-ux-gate`, and `workstack-pr-monitor` as design references — port their tested rules, keep project-specific mechanics (helper scripts, provider tiers, ports) out of fork skills.
- **Next action:** re-explore these surfaces and replace this checkpoint with one fully detailed ready S3 slice before implementation.

### Checkpoint C4 — Living Plan and Planned-Work Entry Points

- **Trigger:** S3 merged and one real quick task has passed its gate, PR, and closeout.
- **Outcome:** Implement the living-plan schema, slice index transitions, ignored worktree context, progress ledger, durable recovery order, coarse Linear reconciliation, and the `workstack-start` and `workstack-resume` wrappers calling upstream skills through the continuation seams and centralized routing. Restart/idempotency tests prove recovery from task, gate, PR, and post-merge states.
- **Re-explore:** current SDD workspace scripts, worktree helpers, plan format, restart behavior, and project-local skill discovery/trigger behavior in Claude Code and Codex.

### Checkpoint C5 — Parallel Slices and Active Contracts

- **Trigger:** one sequential slice completes end-to-end through `workstack-resume`.
- **Outcome:** Add dependency/conflict classification, separate worktrees, lightweight contract creation, producer/consumer status, stale audit, and owner-driven pruning. Keep parallelism outside the inner SDD loop.
- **Re-explore:** FSMCRM migration/data-model ownership, real overlap patterns, and the transitional `workstack-batch-plan` contract and lane rules.

### Checkpoint C6 — Cutover, Pilots, and Closeout

- **Trigger:** contracts and closeout tests pass.
- **Outcome:** Refresh FSMCRM's project-local fork installation, resolving entry-point name collisions with the transitional skills and the known `.codex` parity gaps (missing `workstack-agent-routing`, stray empty `.codex/skills/pr-monitor/`). Add project `.workstack/agents.json`, rewrite FSMCRM `AGENTS.md` to the two-paragraph summary plus three entry points, and prove the entry points from clean Claude Code and Codex sessions. Run the pilots — a quick task, a sequential multi-ticket effort with an intermediate planning checkpoint, and two independent parallel slices under a contract — while the transitional skills still exist. Only after pilots pass: remove the superseded transitional `workstack-*` skills, reconcile any Linear projects still structured by phases, fix specification gaps, close contracts, prune plans and worktrees, and document the upstream-update procedure.
- **Re-explore:** current FSMCRM skills and any changes made since commit `4787cf51`; preserve unrelated user work.

## Final Closeout Conditions

- All specification definition-of-done checks pass.
- Every delivery PR is merged at its independently reviewed head.
- Linear is reconciled only for real assigned tickets.
- No active contract, branch, worktree, monitor, or ignored run artifact remains without an owner.
- This living plan is removed from the current tree by a coordination commit after S6; Git history remains the record.
