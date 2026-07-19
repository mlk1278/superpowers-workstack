# WorkStack Development Workflow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` to execute each ready slice task-by-task. A worker receives one extracted task brief, not this whole plan.

**Status:** Active — S1 complete; S2 landed (fresh-agent eval evidence consolidated into S3); S3 fully detailed and ready for subagent-driven execution (Tasks 8–13, including the conflict-audit resolutions); S4–S6 remain planning checkpoints; spec §6.3 fifth-divergence amendment user-approved 2026-07-19

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
- No skill instruction may contradict a spec hard invariant or a consuming project's `AGENTS.md` without a recorded resolution in the Instructional-Conflict Register: generalize the skill behind a seam, tailor via project configuration, or exclude it from the project install. New or ported text containing absolutes ("never", "always", "before ANY") is checked against the register before it lands.

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
| 2026-07-19 | Quick tasks reuse the SDD final whole-branch gate as their slice gate; a separate slice-gate helper is deferred to S4. | Spec §11.3 lets the one-task reviewer issue both verdicts in one pass; S3 has no multi-task slice to gate. |
| 2026-07-19 | `workstack-pr-monitor` reads an optional prose policy file at `.workstack/pr-policy.md`; absent it, conditions default to exact-head green CI, zero unresolved threads, and no requested-changes review. | Spec §13.3 requires provider names and timeout policy to come from project configuration without hard-coding vendors; a prose file needs no parser. |
| 2026-07-19 | Audited the nine inherited upstream skills against spec invariants and FSMCRM's `AGENTS.md`; every conflict now carries one recorded lever (generalize, tailor, or exclude) in the Instructional-Conflict Register. | Conflicting absolutes across instruction sources cause agent thrash; unowned conflicts silently reappear in every session. |
| 2026-07-19 | Add a fifth permitted core divergence: a caller-declared completion contract in `finishing-a-development-branch` (its options menu remains the default). Spec §6.3 amendment user-approved 2026-07-19. | The mandatory 4-option human menu is a hard conflict with spec §21.12 and slice autonomy; the seam mirrors the proven S2 continuation-contract pattern. |
| 2026-07-19 | Exclude `executing-plans` from the FSMCRM project-local install at the S6 cutover; the fork retains it for upstream compatibility. | It is a competing execution path that self-defers to SDD and hard-requires the completion menu; exclusion is cheaper and safer than divergence. |
| 2026-07-19 | Do not edit the greedy `brainstorming`/`using-superpowers` trigger descriptions now; rely on entry-point routing, the precedence ladder, and S3 eval evidence, revisiting as a divergence only if the evals show routing thrash. | Greedy triggers are deliberate upstream behavior backing the harness acceptance test; narrow them with evidence, not preemptively. |
| 2026-07-19 | Port the legacy refined fork's plan-authoring rules into fork-owned planning guidance at S4, condensed to rule plus one example each; do not port its three-thread review runtime, in-plan gate tasks, or verbosity. | The authoring rules are high-value and model-agnostic; the rest is the dispatch-and-prompt overhead this fork deliberately replaced with one combined task review and one whole-branch gate. |
| 2026-07-19 | The UX gate captures evidence with a throwaway Playwright script (every pathway, step, and viewport screenshotted to ignored scratch) and judges it with one vision-capable routed reviewer, instead of agents navigating the browser interactively. | Manual in-browser navigation burns large token volumes per round and leaves no rerunnable evidence; a script reruns cheaply after every fix and the screenshot set is cheap to re-judge. |

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

## Skill Shape and Design Guidance

Non-binding design intent for the C3–C6 planners. Task-level detail still comes from checkpoint re-exploration; this section records the intended shape so each checkpoint does not re-derive it.

### Target skill surface and sizes

| Skill | Target size | Shape |
|---|---|---|
| `workstack-quick-task` | ~40 lines | Public. Numbered steps mirroring spec §7.1: bounded exploration → ignored mini-plan/brief → SDD loop → gate → one PR → monitor → cleanup. Port the transitional skill's escape-hatch rule and "the ask is the spec" framing. Drop the transitional Mode A direct-commit lane: the spec requires one PR through the exact-head gate. |
| `workstack-start` | ~30 lines | Public. A pure sequencer: brainstorming with WorkStack continuation → spec expansion → independent spec-review loop → user approval → hand off to `workstack-resume`. No implementation vocabulary. The transitional `workstack-shape-feature` and `workstack-write-spec` collapse into this skill plus one internal spec-review helper; keep their HARD-GATE approval language. |
| `workstack-resume` | ~60 lines | Public; the heart of the workflow and the one place to spend line budget. A short state-discovery preamble (spec §17.1 authority order) followed by an explicit dispatch table: observed state → next transition, one row per transition in spec §7.3. Port the transitional shepherd's "the ledger is the state; you are replaceable" stance. |
| `workstack-pr-monitor` | ~50 lines | Internal, owned by whichever public skill opened the PR. Port the transitional 61-line version — it is the most battle-tested skill in the set — replacing hard-coded provider tiers and helper-script names with references to project configuration. |
| `workstack-ux-gate` | ~40 lines | Internal, invoked by gate steps. Scripted-capture redesign: a throwaway Playwright script screenshots every pathway/step/viewport to ignored scratch; one vision-capable routed reviewer judges the image set. Ports the transitional gate's criteria and finding discipline without its parallel per-pathway browser reviewers. |
| `workstack-slice-gate` | ~40 lines | Internal. Whole-slice gate packaging and verdict loop, reusing the upstream review-package mechanism and the S2 final-gate seam. Do not write a new orchestration script. |
| `workstack-spec-review` | ~30 lines | Internal, owned by `workstack-start`. The transitional `workstack-write-spec` reviewer loop, extracted. |
| `workstack-agent-routing` | exists | Internal. Already shipped in S1; unchanged. |

Skills that must not exist in the fork: a shepherd/run-ticket orchestration pair (two live control layers was the transitional set's main comprehension cost — `workstack-resume` plus upstream sequential SDD replaces both); `workstack-batch-plan` as a public skill (its conflict-graph and lane-isolation content becomes S5 contract material referenced from `workstack-resume`); `workstack-spec-to-linear` as a public skill (ticket reconciliation is a `workstack-resume` step; an internal Linear helper is acceptable).

### Verbosity rules

- Match the transitional register: one announce line, explicit Entry/Exit conditions, imperative numbered steps, 30–60 lines.
- The specification is the reference document. Skills cite it by section (for example "eligibility per spec §14.2") instead of restating rules. Restated spec prose is the main way the skill set would bloat.
- Worker discipline (in-turn waits, file-only returns, liveness checks) is owned by upstream SDD and stated nowhere else. The transitional set restates it in three skills; the fork states it in zero.
- The gate taxonomy (task review, UX gate, whole-slice gate, PR-provider gate) is defined once in the fork's workflow overview; skills refer to gates by name only.

### The one deliberate expansion

`workstack-resume`'s dispatch table should be exhaustive and explicit rather than summarized — every recoverable state (mid-task, gated, PR open, merged-unreconciled, checkpoint-pending, closeout-ready) gets its own row. Everywhere else, shorter is better; here, enumeration is what makes recovery trustworthy.

### Forcing function for simplicity

Maintain a draft of FSMCRM's two-paragraph `AGENTS.md` workflow summary in the fork from S3 onward, updating it at each checkpoint. If a new capability cannot be added without a third paragraph or a fourth entry point, redesign the capability, not the summary.

## Instructional-Conflict Register

Audited 2026-07-19 against the spec's hard invariants (§5), autonomy rules (§20, §21.12), and FSMCRM's binding `AGENTS.md`. Each conflict carries exactly one resolution lever: **generalize** (a small allowlisted fork seam), **tailor** (project configuration or `AGENTS.md`), or **exclude** (omit from the project install). Unresolved hard conflicts block the slice that would ship the affected surface.

| Skill | Conflicting instruction | Severity | Resolution |
|---|---|---|---|
| `finishing-a-development-branch` | "present exactly these 4 options … Which option?" — a mandatory human menu at every branch finish; base-branch detection assumes `main`/`master` | Hard (spec §21.12, §20) | **Generalize:** caller-declared completion contract, S3 Task 10; menu stays the default. Divergence #5, spec §6.3 amendment user-approved 2026-07-19. The contract may name the target base branch, covering FSMCRM's `develop`. |
| `executing-plans` | Whole skill is a competing single-session execution path; hard-requires `finishing-a-development-branch`, importing the menu conflict | Friction | **Exclude** from the FSMCRM install at S6 (fork retains it for upstream compatibility); the WorkStack path is subagent-driven-development. |
| `dispatching-parallel-agents` | "Dispatch one agent per independent problem domain. Let them work concurrently" — tempts intra-slice parallel implementation; no active-contract concept | Hard if applied intra-slice | **Tailor:** WorkStack skills never cite it for implementation; S5 parallel-slice text and the S6 `AGENTS.md` scope it to read-only exploration fan-out and independent slices under contract. Its own shared-state guardrail supports this scoping. |
| `brainstorming` | HARD-GATE "EVERY project regardless of perceived simplicity" vs the quick lane's decision-complete work | Friction | **Tailor + watch:** `workstack-quick-task`'s scope check owns decision-complete work; the precedence ladder governs. No description edit now — greedy triggers back the harness acceptance test. Revisit as a divergence only if the S3 Task 13 evals show routing thrash. |
| `using-superpowers` | "Invoke … BEFORE any response … including clarifying questions"; "1% chance … ABSOLUTELY MUST invoke" | Friction | **Tailor + watch:** the entry points are themselves skills, so invoking one satisfies the mandate, and `<SUBAGENT-STOP>` already protects the inner loop. Same eval-gated revisit as brainstorming. |
| `test-driven-development` | "NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST … No exceptions without your human partner's permission" vs FSMCRM Testing Judgment (no mandatory TDD for copy/spacing/color) | Friction | **Tailor:** the quick-task mini-plan's Global Constraints carry the project's testing policy, binding via the user-instructions-over-skills precedence rule; FSMCRM `AGENTS.md` keeps its Testing Judgment section at S6. |
| `using-git-worktrees` | Consent prompt before creating a worktree; its project-setup step lacks FSMCRM's port isolation, env copy, and context pointer | Friction | **Tailor:** WorkStack wrappers declare the worktree decision up front (the skill honors declared preferences without asking) and apply the project's worktree rules after creation — spec §11.1 assigns those preflight steps to the WorkStack layer by design. |
| `systematic-debugging` | "Discuss with your human partner before attempting more fixes"; human-frustration-signal reading assumes an interactive human | Mostly benign | **Accept + clarify:** in dispatched subagents, "your human partner" is the dispatching orchestrator, and the ≥3-failed-fixes stop is a legitimate spec §20 escalation. The S6 `AGENTS.md` states this clarification once. |
| `verification-before-completion` | Absolute fresh-evidence mandate framed for a single conversational actor | Benign | **Accept:** it reinforces the gate evidence rules; no change. |

**Refined-fork porting decision:** from the 2026-07-19 comparison with the legacy refined fork, port these plan-authoring rules into fork-owned planning guidance at S4 (C4), condensed to rule plus one example each: tasks are self-contained (implementers never read the plan; "paste into implementer prompt" reference blocks), surgical references (never a whole document; three-plus tasks sharing the same bare reference = spec-dumping), existing-code anchors for modification tasks, planner-performed sweep enumeration with a completion predicate, the single-task extraction test on the most ambitious task, and the expanded self-review checks. Do **not** port: the three-persistent-threads-per-task review runtime, mandatory in-plan UX/Quality gate tasks, model-specific dispatch prose, or the 3-4x verbosity. The fork's existing SDD pre-flight conflict scan — which the refined fork lacks — stays as the plan-level conflict net.

## Delivery-Slice Index

| Slice | Outcome | Tickets | Dependencies | State | Branch/worktree | Contract impact | PR |
|---|---|---|---|---|---|---|---|
| S1 — Fork and routing foundation | Govern upstream divergence; resolve logical roles; package WorkStack skills | None assigned | None | Complete | `main` at `4694832` | None | PR #1 |
| S2 — Core extension seams | Add continuation, task-brief, final-gate, and reviewer-context seams with regression evidence | None assigned | S1 merged | Landed; fresh-agent eval evidence consolidated into S3 | `main` at `7a392aa` | None | Direct push authorized by user |
| S3 — Quick-task delivery loop | Ship `workstack-quick-task` plus the slice lifecycle it needs: whole-slice gate, conditional UX evidence, exact-head PR, monitor, closeout; capture fresh-agent seam evidence | None assigned | S2 merged | Ready (Tasks 8–13 detailed) | — | None | — |
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

## Ready Slice S3 — Quick-Task Delivery Loop

**Planning trigger:** S2 merged at `7a392aa`. Surfaces re-explored 2026-07-19: upstream SDD scripts (`task-brief`, `review-package`, `sdd-workspace`), the S2 final-gate seam, `finishing-a-development-branch`, the S1 packaging metadata precedence, and FSMCRM's transitional `workstack-quick-task`, `workstack-review`, `workstack-ux-gate`, and `workstack-pr-monitor` skills.

**Goal:** Ship the smallest complete WorkStack delivery loop: the `workstack-quick-task` public entry point plus the two internal helpers it needs (`workstack-pr-monitor`, `workstack-ux-gate`) and the completion-contract seam that lets an orchestrated slice reach its PR without an interactive menu — with deterministic tests, Codex packaging, the draft workflow summary, and fresh-agent behavioral evidence for the S2 and S3 seams.

**Acceptance signals:**

- A fresh agent can take a small decision-complete change from request to merged PR using only `workstack-quick-task` and the skills it names, with no living plan, ticket creation, or phase vocabulary.
- `workstack-pr-monitor` reads provider and timeout policy from optional project configuration and never hard-codes a vendor.
- `workstack-ux-gate` produces head-bound Pass/Changes Required verdicts from a throwaway Playwright capture script reviewed by one routed vision-capable `ux`-specialty reviewer — no interactive browser navigation by agents.
- All three skills package for Codex with committed OpenAI metadata; the divergence check still passes (no new upstream-core changes).
- `finishing-a-development-branch` executes a caller-declared completion route without presenting its options menu, and behaves exactly as before when no route is declared.
- Fresh-agent eval verdicts exist under `.superpowers/evals/` for both continuation modes, task-brief constraint comprehension, the final gate's clean and finding paths, the completion contract, and a quick-task walkthrough.

**Design decisions for this slice:**

- Quick tasks reuse the SDD final whole-branch gate as their slice gate (spec §11.3 allows the one-task reviewer to issue both verdicts in one pass). A separate slice-gate helper is deferred to S4, where multi-task slices first exist.
- `workstack-pr-monitor` reads an optional prose policy file at `.workstack/pr-policy.md` (spec §13.3 puts provider names and timeout policy in project configuration). Absent the file, its conditions are exact-head green CI, zero unresolved threads, and no requested-changes review.
- FSMCRM's transitional skills are the design reference; their project-specific mechanics (helper scripts, provider tiers, port math, `!simple` lane) stay out of fork skills.
- The fork's existing test conventions apply: `tests/workstack/test-*.sh`, bash with `set -euo pipefail`, `assert_contains`/`assert_before` helpers, final `PASS` line. Skill-text tests are deterministic grep assertions; behavior evidence comes from the Task 13 evals.
- Per the Instructional-Conflict Register: the completion-contract seam (Task 10) resolves the branch-finishing menu conflict; the quick-task wrapper carries the worktree-declaration and project-testing-policy tailoring; no upstream trigger descriptions are edited in this slice.

### Task 8: Add the workstack-pr-monitor skill

**Files:**

- Create: `skills/workstack-pr-monitor/SKILL.md`
- Create: `skills/workstack-pr-monitor/agents/openai.yaml`
- Create: `tests/workstack/test-pr-monitor.sh`

**Interfaces:**

- Consumes: `workstack-agent-routing` role resolution (`scripts/resolve-agent --role implementer` and `--role reviewer`, per its SKILL.md); the SDD final-gate reviewer thread (resumed on post-gate deltas).
- Produces: the skill name `workstack-pr-monitor` and its return contract — exact merge state (PR number, merged SHA, merge commit) returned to the caller, which owns post-merge reconciliation. Task 11 references this skill by name.

- [ ] **Step 1: Write the failing test** at `tests/workstack/test-pr-monitor.sh` (mark executable):

```bash
#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
skill="$repo_root/skills/workstack-pr-monitor/SKILL.md"
metadata="$repo_root/skills/workstack-pr-monitor/agents/openai.yaml"

assert_contains() {
  local file=$1 text=$2 description=$3
  if ! grep -Fq "$text" "$file"; then
    echo "not ok - $description" >&2
    echo "missing: $text" >&2
    exit 1
  fi
  echo "ok - $description"
}

assert_no_model_names() {
  local file=$1
  if grep -Eq 'gpt-[0-9]|opus-|sonnet|haiku|-sol|Sol (high|medium|low)' "$file"; then
    echo "not ok - concrete model identifiers in $file" >&2
    exit 1
  fi
  echo "ok - no concrete model identifiers in $file"
}

[ -f "$skill" ] || { echo "not ok - skill file missing: $skill" >&2; exit 1; }

assert_contains "$skill" "name: workstack-pr-monitor" "frontmatter name"
assert_contains "$skill" "Own exactly one PR" "single-PR ownership"
assert_contains "$skill" "sole source of WorkStack PR review, CI, fix-loop, and merge mechanics" "sole-source clause"
assert_contains "$skill" ".workstack/pr-policy.md" "project policy file location"
assert_contains "$skill" "exact-head green CI, zero unresolved review threads, and no requested-changes review" "default conditions without a policy file"
assert_contains "$skill" "Never hard-code a provider this file does not name." "no hard-coded providers"
assert_contains "$skill" "The local final gate must have approved this exact head before monitoring begins." "local gate precedes monitoring"
assert_contains "$skill" "Bind all evidence to the current head" "exact-head evidence binding"
assert_contains "$skill" "at most once per head request each policy-named provider" "single review request per head"
assert_contains "$skill" "fail closed on unavailable" "CI unavailable fails closed"
assert_contains "$skill" "one batch to a fresh implementer routed via workstack-agent-routing" "batched fixes through routing"
assert_contains "$skill" "resume the local gate reviewer thread on the delta" "local gate delta re-review"
assert_contains "$skill" "materially changes behavior, architecture, migration, or risk" "full gate rerun trigger"
assert_contains "$skill" "Record the fallback reason." "fallback is recorded"
assert_contains "$skill" "confirm the remote PR is \`MERGED\`" "merge confirmation"
assert_contains "$skill" "The caller owns post-merge reconciliation." "reconciliation stays with caller"
assert_contains "$skill" "Do not nest another watcher." "no nested watchers"
assert_no_model_names "$skill"

[ -f "$metadata" ] || { echo "not ok - committed OpenAI metadata missing" >&2; exit 1; }
grep -Fq "display_name" "$metadata" || { echo "not ok - metadata lacks display_name" >&2; exit 1; }
echo "ok - committed OpenAI metadata present"

echo "PASS"
```

- [ ] **Step 2: Run it to verify it fails**

Run: `bash tests/workstack/test-pr-monitor.sh`
Expected: `not ok - skill file missing`, exit 1.

- [ ] **Step 3: Write the skill** at `skills/workstack-pr-monitor/SKILL.md` with exactly this content:

```markdown
---
name: workstack-pr-monitor
description: Own one WorkStack pull request from its current head through CI, configured review providers, fix loops, and merge or a durable blocker. Internal helper started by WorkStack entry points after a slice PR opens.
---

# WorkStack PR Monitor

Own exactly one PR and its worktree until it is merged or genuinely blocked. This skill is the sole source of WorkStack PR review, CI, fix-loop, and merge mechanics; callers start it once and wait for its return.

## Project policy

Read `.workstack/pr-policy.md` at the repository root when it exists. It names the review providers to await, how to request them, complexity lanes, and timeout policy. Without it, the required conditions are exact-head green CI, zero unresolved review threads, and no requested-changes review. Never hard-code a provider this file does not name.

## Preflight

Capture the PR number, branch, current full head SHA, merge state, and the approved local-gate SHA. The local final gate must have approved this exact head before monitoring begins. Bind all evidence to the current head; any push starts a new evidence cycle.

## Monitor loop

1. Refresh the PR head, merge state, and unresolved threads. A conflicting PR schedules no CI; resolve the conflict before diagnosing missing checks.
2. Refresh exact-head CI (`gh pr checks` or the policy file's command). Distinguish failed from pending from unavailable, and fail closed on unavailable — it is not a green result.
3. Await, and at most once per head request each policy-named provider. Only a current-head review object or an authenticated completion naming the current commit counts as completion; acknowledgements and reactions never do.
4. Verify findings against the code. Send valid findings as one batch to a fresh implementer routed via workstack-agent-routing, inspect and test the fixes, push once, then resume the local gate reviewer thread on the delta. Concretely rebut invalid findings on the PR.
5. Rerun the full local gate instead of a delta review when a fix materially changes behavior, architecture, migration, or risk.
6. If no action is ready, wait one bounded interval (default 180 seconds; policy may override) and refresh. Do not nest another watcher.

## Fallback

After the policy timeout on one head (default 60 minutes), or on explicit provider failure or rate limiting, exact-head green CI plus the recorded local gate approval is sufficient. Record the fallback reason. Do not switch to a provider the policy does not name.

## Merge and return

Immediately before merging, re-verify on the expected head: policy-named providers or the recorded fallback, exact-head green CI, mergeability, and zero unresolved threads. Merge when all pass, confirm the remote PR is `MERGED`, and return the exact merge state — PR number, merged SHA, and merge commit — to the caller. The caller owns post-merge reconciliation.
```

- [ ] **Step 4: Write the metadata** at `skills/workstack-pr-monitor/agents/openai.yaml`:

```yaml
interface:
  display_name: "WorkStack PR Monitor"
  short_description: "Own one PR through CI, review, fixes, and merge"
  default_prompt: "Use $workstack-pr-monitor to shepherd this pull request through merge."
```

- [ ] **Step 5: Run the test to verify it passes**

Run: `bash tests/workstack/test-pr-monitor.sh`
Expected: all `ok` lines, final `PASS`, exit 0.

- [ ] **Step 6: Run the divergence check**

Run: `python3 scripts/check-workstack-divergences.py`
Expected: exit 0 (new `skills/workstack-*` directories are fork additions, not core divergences).

- [ ] **Step 7: Commit**

```bash
git add skills/workstack-pr-monitor tests/workstack/test-pr-monitor.sh
git commit -m "add workstack-pr-monitor skill"
```

### Task 9: Add the workstack-ux-gate skill

**Files:**

- Create: `skills/workstack-ux-gate/SKILL.md`
- Create: `skills/workstack-ux-gate/agents/openai.yaml`
- Create: `tests/workstack/test-ux-gate.sh`

**Interfaces:**

- Consumes: `workstack-agent-routing` reviewer resolution with `--reviewer-specialty ux`; reviewer-only `docs/REVIEW-GUIDANCE.md` semantics from the S2 seam.
- Produces: the skill name `workstack-ux-gate` and its verdict contract — `Pass` bound to a head SHA, or `Changes Required` with component-level findings. Task 11 references this skill by name.

- [ ] **Step 1: Write the failing test** at `tests/workstack/test-ux-gate.sh` (mark executable). Start from the committed `tests/workstack/test-pr-monitor.sh`: copy its shebang, `set -euo pipefail`, `repo_root` line, and the `assert_contains` and `assert_no_model_names` helper functions verbatim, then continue with:

```bash
skill="$repo_root/skills/workstack-ux-gate/SKILL.md"
metadata="$repo_root/skills/workstack-ux-gate/agents/openai.yaml"

[ -f "$skill" ] || { echo "not ok - skill file missing: $skill" >&2; exit 1; }

assert_contains "$skill" "name: workstack-ux-gate" "frontmatter name"
assert_contains "$skill" "I'm running the UX gate for <surface>." "announce line"
assert_contains "$skill" "\`Pass\` bound to the reviewed head SHA, or \`Changes Required\`" "verdict contract"
assert_contains "$skill" "The gate does not fix anything." "gate does not fix"
assert_contains "$skill" "nothing downstream may claim UX was verified" "runtime preflight is mandatory"
assert_contains "$skill" "5-10 navigation pathways covering what this diff changed" "pathways derive from the diff"
assert_contains "$skill" "throwaway Playwright script" "capture is a throwaway script"
assert_contains "$skill" ".superpowers/ux/" "script lives in ignored scratch"
assert_contains "$skill" "<pathway>-<step>-<width>.png" "screenshot naming convention"
assert_contains "$skill" "Resolve one \`reviewer\` with specialty \`ux\` via workstack-agent-routing" "routed ux reviewer"
assert_contains "$skill" "vision-capable model" "reviewer route must handle images"
assert_contains "$skill" "without driving the browser" "reviewer judges images, not live UI"
assert_contains "$skill" "docs/REVIEW-GUIDANCE.md" "reviewer-only guidance is offered to the reviewer"
assert_contains "$skill" "against the approved criteria — never personal taste" "criteria-bound judgment"
assert_contains "$skill" "component file + visual state + viewport + specific deviation + screenshot reference" "finding format"
assert_contains "$skill" "a finding, not a skip" "blocked step is a finding"
assert_contains "$skill" "rerun the capture script on the new head" "fix rounds rerun the script"
assert_contains "$skill" "a new push invalidates prior evidence" "head-bound evidence"
assert_contains "$skill" "before the final gate verdict" "UX gate precedes the final gate"
assert_contains "$skill" "One primary UX reviewer by default" "single primary reviewer"
assert_contains "$skill" "Do not manufacture states by editing app source" "no manufactured states"
assert_no_model_names "$skill"

[ -f "$metadata" ] || { echo "not ok - committed OpenAI metadata missing" >&2; exit 1; }
grep -Fq "display_name" "$metadata" || { echo "not ok - metadata lacks display_name" >&2; exit 1; }
echo "ok - committed OpenAI metadata present"

echo "PASS"
```

- [ ] **Step 2: Run it to verify it fails**

Run: `bash tests/workstack/test-ux-gate.sh`
Expected: `not ok - skill file missing`, exit 1.

- [ ] **Step 3: Write the skill** at `skills/workstack-ux-gate/SKILL.md` with exactly this content:

```markdown
---
name: workstack-ux-gate
description: Scripted-capture UX verification of changed user-visible surfaces against approved visual and interaction acceptance criteria. Internal WorkStack gate run before the final gate verdict; returns Pass or Changes Required.
---

# WorkStack UX Gate

**Announce:** "I'm running the UX gate for <surface>."

**Entry:** a context bundle — changed surface routes, the base..head range, the approved acceptance criteria (visual, interaction, responsive, accessibility, copy), and how to reach a running isolated environment.
**Exit:** `Pass` bound to the reviewed head SHA, or `Changes Required` with component-level findings. The gate does not fix anything.

Never review by navigating the browser interactively — manual navigation burns tokens and leaves no rerunnable evidence. Capture is scripted; judgment happens over the resulting images.

## 0. Runtime preflight

The environment must actually serve the changed routes with queryable data before capture starts. No preflight evidence means the gate cannot run, and nothing downstream may claim UX was verified.

## 1. Pathways from the actual diff

Derive 5-10 navigation pathways covering what this diff changed — the flows, entry points, and states the criteria name, not a generic tour of the application.

## 2. Scripted capture

Write a throwaway Playwright script under ignored `.superpowers/ux/` that walks every pathway and screenshots each step and state at small (~375px), medium (~768px), and large (~1440px) widths, naming files `<pathway>-<step>-<width>.png`. Exercise the states the criteria name (empty, loading, error, dense data, overlays, overflow) using isolated fixtures or seeded test data. Run the script once per review round. A step the script cannot complete (auth, data, a dead route) is a finding, not a skip. The script is scratch: rerunnable after every fix, deleted at gate close, never committed.

## 3. Review the captures

Resolve one `reviewer` with specialty `ux` via workstack-agent-routing; the route must resolve to a vision-capable model. The reviewer reads `docs/REVIEW-GUIDANCE.md` when the project provides it, then judges the screenshot set against the approved criteria — never personal taste — without driving the browser. Each finding names component file + visual state + viewport + specific deviation + screenshot reference; findings missing a screenshot or component file are unroutable and do not count.

## 4. Fix loop

Route the finding set to the owning implementer thread, rerun the capture script on the new head, and send the fresh set to the same reviewer thread. Every round and the final `Pass` bind to the head SHA that was reviewed; a new push invalidates prior evidence. Run this gate before the final gate verdict so its fixes land in the gated head.

## Rules

- One primary UX reviewer by default; an additional reviewer needs an explicit written reason such as a broad redesign or an accessibility specialty.
- Do not manufacture states by editing app source. Isolated fixtures and seeded test data are fine; production or shared-user data is not.
```

- [ ] **Step 4: Write the metadata** at `skills/workstack-ux-gate/agents/openai.yaml`:

```yaml
interface:
  display_name: "WorkStack UX Gate"
  short_description: "Real-browser UX verification of changed surfaces"
  default_prompt: "Use $workstack-ux-gate to verify the changed surfaces against the approved UX criteria."
```

- [ ] **Step 5: Run the test to verify it passes**

Run: `bash tests/workstack/test-ux-gate.sh`
Expected: all `ok` lines, final `PASS`, exit 0.

- [ ] **Step 6: Commit**

```bash
git add skills/workstack-ux-gate tests/workstack/test-ux-gate.sh
git commit -m "add workstack-ux-gate skill"
```

### Task 10: Add the completion-contract seam to finishing-a-development-branch

**Files:**

- Modify: `skills/finishing-a-development-branch/SKILL.md`
- Modify: `workstack/upstream-divergences.json`
- Create: `tests/workstack/test-completion-contract.sh`

**Interfaces:**

- Consumes: the S1 divergence governance (`workstack/upstream-divergences.json` schema and `scripts/check-workstack-divergences.py`); the spec §6.3 amendment authorizing this fifth divergence.
- Produces: the completion-contract clause quoted below, which Task 11's `workstack-quick-task` invokes by declaring the pull-request completion route. The exact clause sentences are load-bearing for the test and for callers.

- [ ] **Step 1: Write the failing test** at `tests/workstack/test-completion-contract.sh` (mark executable). Start from the committed `tests/workstack/test-pr-monitor.sh` preamble (shebang, `set -euo pipefail`, `repo_root`) and its `assert_contains` helper copied verbatim, then continue with:

```bash
skill="$repo_root/skills/finishing-a-development-branch/SKILL.md"

assert_contains "$skill" "**Completion contract:**" "completion contract exists"
assert_contains "$skill" "If the invoking prompt declared exactly one completion route (optionally naming the target base branch) before this skill was invoked" "contract trigger condition"
assert_contains "$skill" "execute that route and its cleanup directly instead of presenting the options below" "declared route skips the menu"
assert_contains "$skill" "An undeclared or ambiguous route falls through to the normal options." "default menu preserved on no declaration"
assert_contains "$skill" "This changes only who chooses the option; every verification and cleanup rule still applies." "verification is not bypassed"
assert_contains "$skill" "present exactly these 4 options" "default 4-option menu still present"
assert_contains "$skill" "Type 'discard' to confirm." "destructive confirmation gate still present"
assert_contains "$skill" "If tests fail:" "test verification step still present"

if ! grep -Fq "skills/finishing-a-development-branch/SKILL.md" "$repo_root/workstack/upstream-divergences.json"; then
  echo "not ok - divergence allowlist missing finishing-a-development-branch" >&2
  exit 1
fi
echo "ok - divergence allowlisted"

echo "PASS"
```

- [ ] **Step 2: Run it to verify it fails**

Run: `bash tests/workstack/test-completion-contract.sh`
Expected: `not ok - completion contract exists`, exit 1.

- [ ] **Step 3: Add the seam.** In `skills/finishing-a-development-branch/SKILL.md`, insert this paragraph immediately after the `**Announce at start:**` line, changing nothing else in the file:

```markdown
**Completion contract:** If the invoking prompt declared exactly one completion route (optionally naming the target base branch) before this skill was invoked, run the Step 1 test verification, then execute that route and its cleanup directly instead of presenting the options below. An undeclared or ambiguous route falls through to the normal options. This changes only who chooses the option; every verification and cleanup rule still applies.
```

- [ ] **Step 4: Allowlist the divergence.** Add `skills/finishing-a-development-branch/SKILL.md` to `workstack/upstream-divergences.json` with the reason: "caller-declared completion contract so orchestrated slices reach their gated PR without an interactive options menu; menu remains the default".

- [ ] **Step 5: Run the test to verify it passes**

Run: `bash tests/workstack/test-completion-contract.sh`
Expected: all `ok` lines, final `PASS`, exit 0.

- [ ] **Step 6: Run the divergence and regression checks**

Run: `python3 scripts/check-workstack-divergences.py && bash tests/workstack/test-upstream-divergences.sh && bash tests/workstack/test-final-review-gate.sh`
Expected: exit 0 / `PASS` from each.

- [ ] **Step 7: Commit**

```bash
git add skills/finishing-a-development-branch/SKILL.md workstack/upstream-divergences.json tests/workstack/test-completion-contract.sh
git commit -m "add completion contract seam to finishing-a-development-branch"
```

### Task 11: Add the workstack-quick-task public entry point

**Files:**

- Create: `skills/workstack-quick-task/SKILL.md`
- Create: `skills/workstack-quick-task/agents/openai.yaml`
- Create: `tests/workstack/test-quick-task.sh`

**Interfaces:**

- Consumes: `workstack-agent-routing` (role resolution), `workstack-pr-monitor` (Task 8), `workstack-ux-gate` (Task 9), the completion-contract seam (Task 10), upstream `using-git-worktrees` (declared-preference behavior), `writing-plans` task format, and `subagent-driven-development` (including its final-gate seam and `scripts/task-brief` compatibility: the mini-plan must contain `## Global Constraints` and `### Task 1:` headings).
- Produces: the public entry point `workstack-quick-task`. Later slices (S4's `workstack-start`/`workstack-resume`) are referenced by name in its promotion clause and must keep those names.

- [ ] **Step 1: Write the failing test** at `tests/workstack/test-quick-task.sh` (mark executable). Start from the committed `tests/workstack/test-pr-monitor.sh` (shebang, `set -euo pipefail`, `repo_root`, `assert_contains`, `assert_no_model_names` — copied verbatim) plus the `assert_before` helper copied verbatim from the committed `tests/workstack/test-continuation-seams.sh`, then continue with:

```bash
skill="$repo_root/skills/workstack-quick-task/SKILL.md"
metadata="$repo_root/skills/workstack-quick-task/agents/openai.yaml"

[ -f "$skill" ] || { echo "not ok - skill file missing: $skill" >&2; exit 1; }

assert_contains "$skill" "name: workstack-quick-task" "frontmatter name"
assert_contains "$skill" "I'm using workstack-quick-task to ship this." "announce line"
assert_contains "$skill" "the ask itself is the spec" "entry condition"
assert_contains "$skill" "one merged PR with scratch artifacts and the worktree removed" "exit condition"
assert_contains "$skill" "Fail closed on reviewer-independence errors." "reviewer independence fails closed"
assert_contains "$skill" "hand to \`workstack-start\` when no approved spec exists, or \`workstack-resume\` when one does" "promotion clause"
assert_contains "$skill" "never creates one to mirror a tiny local change" "no ticket mirroring"
assert_contains "$skill" ".superpowers/quick/" "ignored mini-plan location"
assert_contains "$skill" "## Global Constraints" "mini-plan carries global constraints"
assert_contains "$skill" "superpowers:subagent-driven-development" "reuses the SDD loop"
assert_contains "$skill" "the task reviewer may issue the task verdict and the final-gate verdict in the same pass" "one-pass gate allowance"
assert_contains "$skill" "run workstack-ux-gate before the final gate verdict" "conditional UX gate ordering"
assert_contains "$skill" "stating the worktree decision up front" "worktree consent prompt pre-empted"
assert_contains "$skill" "apply the project's own worktree rules" "project worktree rules layered on"
assert_contains "$skill" "the project's testing policy when it differs from default TDD" "testing policy travels in constraints"
assert_contains "$skill" "superpowers:finishing-a-development-branch" "branch completion handoff"
assert_contains "$skill" "declaring the pull-request completion route" "completion contract declared, no menu"
assert_contains "$skill" "workstack-pr-monitor" "PR monitor handoff"
assert_contains "$skill" "Done means merged, not PR-open." "merged is done"
assert_before "$skill" "## 2. Scope check" "## 3. Mini-plan" "scope check precedes the mini-plan"
assert_before "$skill" "## 5. UX evidence" "## 6. PR and merge" "UX evidence precedes the PR"
assert_no_model_names "$skill"

[ -f "$metadata" ] || { echo "not ok - committed OpenAI metadata missing" >&2; exit 1; }
grep -Fq "display_name" "$metadata" || { echo "not ok - metadata lacks display_name" >&2; exit 1; }
echo "ok - committed OpenAI metadata present"

echo "PASS"
```

- [ ] **Step 2: Run it to verify it fails**

Run: `bash tests/workstack/test-quick-task.sh`
Expected: `not ok - skill file missing`, exit 1.

- [ ] **Step 3: Write the skill** at `skills/workstack-quick-task/SKILL.md` with exactly this content:

```markdown
---
name: workstack-quick-task
description: Use when a small, decision-complete change should ship with full WorkStack delivery discipline but without shaping, a specification, or a living plan — one coherent outcome, one PR. Do not use for ambiguous or multi-surface work, or for trivial conversational edits your human partner asked you to just make.
---

# WorkStack Quick Task

**Announce:** "I'm using workstack-quick-task to ship this."

**Entry:** a small, decision-complete request — the ask itself is the spec.
**Exit:** one merged PR with scratch artifacts and the worktree removed, or an explicit promotion out of quick-task scope.

This is a public WorkStack entry point. It skips shaping, speccing, ticketing, and durable planning. It never skips implementation review, the final gate, or PR discipline.

## 1. Resolve roles

Resolve `implementer` and `reviewer` with workstack-agent-routing before any dispatch, and `monitor` before the PR opens. Record each normalized route. Fail closed on reviewer-independence errors.

## 2. Scope check

Confirm the work has one coherent outcome, an established owner surface, and no unresolved product decision. Explore just enough code to name the owning files and the binding repository rules. If shaping, multiple PRs, a shared-interface contract, or an unresolved product decision appears — now or mid-task — stop and promote: hand to `workstack-start` when no approved spec exists, or `workstack-resume` when one does. A quick task may reference an existing Linear ticket but never creates one to mirror a tiny local change.

## 3. Mini-plan

Create an isolated worktree with superpowers:using-git-worktrees, stating the worktree decision up front so its consent prompt is unnecessary, then apply the project's own worktree rules from its `AGENTS.md` (port isolation, environment files, context pointer) before dispatching work. Write an ignored mini-plan at `.superpowers/quick/<slug>-plan.md` in superpowers:writing-plans task format: a `## Global Constraints` section holding the ask verbatim, the binding rules found in the scope check, and the project's testing policy when it differs from default TDD, plus one `### Task 1:` section with exact files, test steps, and verification commands. The mini-plan is scratch and is never committed.

## 4. Implement and gate

Execute the mini-plan with superpowers:subagent-driven-development using the routed roles. Because this one task's review sees the complete final diff, the task reviewer may issue the task verdict and the final-gate verdict in the same pass; the exact-head final gate in that skill still applies unchanged.

## 5. UX evidence

If the change materially alters a user-visible surface, run workstack-ux-gate before the final gate verdict so its fixes land in the reviewed head. Copy-only and non-visual changes skip it.

## 6. PR and merge

Complete the branch with superpowers:finishing-a-development-branch, declaring the pull-request completion route (with the project's target base branch) so no options menu is needed. Hand the PR to workstack-pr-monitor and wait for its return. Done means merged, not PR-open.

## 7. Clean up

After merge: remove the worktree and branch, delete the mini-plan and SDD scratch, and report what shipped with its verification evidence.

## Red flags

A "quick task" that keeps growing (stop and promote) · creating a ticket or spec to mirror a tiny change · skipping review because the change is small · reporting done at PR-open · leaving scratch or the worktree behind after merge.
```

- [ ] **Step 4: Write the metadata** at `skills/workstack-quick-task/agents/openai.yaml`:

```yaml
interface:
  display_name: "WorkStack Quick Task"
  short_description: "Ship a small decision-complete change through one PR"
  default_prompt: "Use $workstack-quick-task to ship this small change end to end."
```

- [ ] **Step 5: Run the test to verify it passes**

Run: `bash tests/workstack/test-quick-task.sh`
Expected: all `ok` lines, final `PASS`, exit 0.

- [ ] **Step 6: Run the neighboring seam tests** (the entry point leans on them)

Run: `bash tests/workstack/test-continuation-seams.sh && bash tests/workstack/test-final-review-gate.sh && bash tests/workstack/test-reviewer-context.sh`
Expected: `PASS` from each.

- [ ] **Step 7: Commit**

```bash
git add skills/workstack-quick-task tests/workstack/test-quick-task.sh
git commit -m "add workstack-quick-task public entry point"
```

### Task 12: Package the new skills and add the workflow summary draft

**Files:**

- Modify: `tests/codex/test-package-codex-plugin.sh` (immediately after the existing `workstack-agent-routing` archive assertions, near its line 177)
- Create: `workstack/AGENTS-SNIPPET.md`
- Create: `tests/workstack/test-workflow-summary.sh`

**Interfaces:**

- Consumes: the S1 packaging rule (committed `agents/openai.yaml` takes precedence; no external metadata entry required for fork-owned skills).
- Produces: `workstack/AGENTS-SNIPPET.md`, the canonical draft of the consuming project's two-paragraph workflow summary. S4–S6 tasks update this file; S6 copies it into FSMCRM `AGENTS.md`.

- [ ] **Step 1: Add packaging assertions.** In `tests/codex/test-package-codex-plugin.sh`, after the existing `workstack-agent-routing` assertions, add:

```bash
for ws_skill in workstack-quick-task workstack-pr-monitor workstack-ux-gate; do
  assert_contains "$archive_paths" "skills/$ws_skill/SKILL.md" "archive includes $ws_skill skill"
  assert_contains "$archive_paths" "skills/$ws_skill/agents/openai.yaml" "archive includes committed $ws_skill metadata"
done
```

- [ ] **Step 2: Run the packaging test**

Run: `bash tests/codex/test-package-codex-plugin.sh`
Expected: exit 0. If an assertion fails, fix the packaging script only within the S1 metadata-precedence behavior (committed source metadata first, external second); do not change package shape otherwise.

- [ ] **Step 3: Write the workflow summary draft** at `workstack/AGENTS-SNIPPET.md` with exactly this content:

```markdown
# WorkStack Workflow Summary (draft — updated each slice)

Canonical draft of the two-paragraph workflow explanation destined for a consuming project's `AGENTS.md`. If a new capability cannot be described without a third paragraph or a fourth entry point, redesign the capability, not this summary.

WorkStack tracks durable product outcomes as Linear tickets but keeps implementation detail local. New or ambiguous work is shaped into an approved direction, expanded into a decision-complete specification, represented as tickets, and organized in one living implementation plan that fully details only the delivery slices that are ready to build.

Implementation happens one delivery slice at a time: a fresh implementer per task, one independent combined review per task, one whole-slice gate, and exactly one PR per slice, monitored through merge and reconciled in Linear. Independent slices may run in parallel worktrees under a lightweight active contract; everything inside a slice stays sequential.

Three entry points — enter at the first state you don't have:

- `workstack-quick-task`: a small decision-complete change, straight to one reviewed, merged PR.
- `workstack-start`: new or ambiguous work, through brainstorming to an approved spec and plan.
- `workstack-resume`: anything already specced or planned, through the next valid step to merge.
```

- [ ] **Step 4: Write its test** at `tests/workstack/test-workflow-summary.sh` (mark executable). Start from the committed `tests/workstack/test-pr-monitor.sh` preamble (shebang, `set -euo pipefail`, `repo_root`) and its `assert_contains` helper copied verbatim, then continue with:

```bash
summary="$repo_root/workstack/AGENTS-SNIPPET.md"
[ -f "$summary" ] || { echo "not ok - workflow summary draft missing" >&2; exit 1; }
assert_contains "$summary" "workstack-quick-task" "summary names quick task"
assert_contains "$summary" "workstack-start" "summary names start"
assert_contains "$summary" "workstack-resume" "summary names resume"
assert_contains "$summary" "enter at the first state you don't have" "summary states the entry rule"
assert_contains "$summary" "redesign the capability, not this summary" "summary is the simplicity forcing function"
if grep -Eq 'phase plan|shepherd|implementation phase' "$summary"; then
  echo "not ok - phase vocabulary in workflow summary" >&2
  exit 1
fi
echo "ok - no phase vocabulary"
echo "PASS"
```

- [ ] **Step 5: Run the new test and the manifest/package suite**

Run: `bash tests/workstack/test-workflow-summary.sh && bash tests/codex/test-package-codex-plugin.sh && bash tests/codex/test-marketplace-manifest.sh && bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh`
Expected: exit 0 from each.

- [ ] **Step 6: Commit**

```bash
git add tests/codex/test-package-codex-plugin.sh workstack/AGENTS-SNIPPET.md tests/workstack/test-workflow-summary.sh
git commit -m "package new workstack skills and add workflow summary draft"
```

### Task 13: Record fresh-agent behavioral evidence

**Files:**

- Create (ignored, not committed): `.superpowers/evals/continuation-default.md`, `.superpowers/evals/continuation-custom.md`, `.superpowers/evals/task-brief-comprehension.md`, `.superpowers/evals/final-gate-clean.md`, `.superpowers/evals/final-gate-finding.md`, `.superpowers/evals/completion-contract.md`, `.superpowers/evals/quick-task-walkthrough.md`

**Interfaces:**

- Consumes: the four S2 seams, the Task 10 completion-contract seam, and the three S3 skills as installed on the current HEAD.
- Produces: one verdict file per scenario. Each records: the exact prompt used, harness and resolved route (`skills/workstack-agent-routing/scripts/resolve-agent` output), agent identity, a pointer to the transcript, and a compact `PASS` / `FAIL: <one line>` / `NOT RUN: <blocking reason>` verdict. A scenario that cannot be run is recorded `NOT RUN` — never silently skipped, never marked `PASS`.

- [ ] **Step 1: Build a disposable fixture repo** under `.superpowers/evals/fixture/`: `git init`, one small Python or shell module with a passing test, a `README.md`, and a copy of this fork's `skills/` available to the harness (or the fork itself as the working repo for scenarios that only exercise skills text). Record the setup commands in each verdict file.
- [ ] **Step 2: Continuation default.** Fresh agent, prompt: "Use superpowers:brainstorming to design a `todo add` subcommand for this CLI. I will act as your human partner." Drive to written-spec approval. PASS if the agent's next action after approval is invoking `writing-plans` (the default continuation), with every approval gate intact. Record in `continuation-default.md`.
- [ ] **Step 3: Continuation custom.** Same fixture, prompt adds: "Continuation: after I approve the written spec, invoke superpowers:verification-before-completion." PASS if that continuation — not `writing-plans` — is invoked, and only after spec approval. Record in `continuation-custom.md`.
- [ ] **Step 4: Task-brief comprehension.** Write a two-task fixture plan containing a `## Global Constraints` section with one distinctive constraint (e.g. "All user-facing strings end with a period."). Run `skills/subagent-driven-development/scripts/task-brief FIXTURE_PLAN 2`, dispatch a fresh implementer with only the brief path. PASS if its report honors and restates the constraint and never references Task 1's content. Record in `task-brief-comprehension.md`.
- [ ] **Step 5: Final gate, clean path.** Run superpowers:subagent-driven-development against the two-task fixture plan on a branch. PASS if `REVIEW_HEAD` is recorded, the final reviewer's `Ready to merge? Yes` names that SHA, and branch completion occurs only at the approved SHA. Record in `final-gate-clean.md`.
- [ ] **Step 6: Final gate, finding path.** Repeat with a deliberate defect left in task 2 (e.g. an assertion-free test). PASS if the final reviewer's findings go as one set to one fixer, covering verification reruns, the same reviewer thread reviews the delta, and completion happens only after explicit approval of the new head. Record in `final-gate-finding.md`.
- [ ] **Step 7: Completion contract.** In the fixture repo, on a completed branch with passing tests, invoke superpowers:finishing-a-development-branch with a declared completion route of "merge back to the base branch locally and delete the branch". PASS if no options menu is presented, tests are still verified first, and the route plus cleanup executes. Then repeat with no declared route and PASS only if the normal options menu appears unchanged. Record both halves in `completion-contract.md`.
- [ ] **Step 8: Quick-task walkthrough.** Fresh agent in the fixture repo with the S3 skills installed, prompt: "Fix the typo in the README greeting. Use workstack-quick-task." PASS if the agent announces the skill, performs the scope check, writes the mini-plan under `.superpowers/quick/` containing `## Global Constraints`, and enters the SDD loop with routed roles. The PR and merge steps may be recorded `NOT RUN: fixture has no remote`. Additionally record a routing-thrash observation: did any greedy skill trigger (brainstorming, using-superpowers) divert the agent from the entry point? This observation feeds the Instructional-Conflict Register's eval-gated revisit decision. Record in `quick-task-walkthrough.md`.
- [ ] **Step 9: Summarize.** Append one table (scenario → verdict) to the progress ledger and report any `FAIL`/`NOT RUN` rows — and the routing-thrash observation — to the orchestrator. No commit: everything under `.superpowers/` is ignored by design.

### S3 Slice Verification and Gate

- [ ] Record the slice base SHA before Task 8 begins (`git rev-parse HEAD`, expected `7a392aa` or the current `main` head).
- [ ] Run `bash tests/workstack/test-pr-monitor.sh`, `bash tests/workstack/test-ux-gate.sh`, `bash tests/workstack/test-completion-contract.sh`, `bash tests/workstack/test-quick-task.sh`, and `bash tests/workstack/test-workflow-summary.sh`; expect `PASS` from each.
- [ ] Run the pre-existing suite: `bash tests/workstack/test-upstream-divergences.sh`, `bash tests/workstack/test-agent-routing.sh`, `bash tests/workstack/test-continuation-seams.sh`, `bash tests/workstack/test-final-review-gate.sh`, `bash tests/workstack/test-reviewer-context.sh`, `bash tests/codex/test-package-codex-plugin.sh`, `bash tests/codex/test-marketplace-manifest.sh`, `bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh`; expect exit 0 from each.
- [ ] Run `python3 scripts/check-workstack-divergences.py`; expect exit 0 with no new core divergences.
- [ ] Confirm all seven Task 13 verdict files exist with explicit verdicts; escalate any `FAIL` — and any observed routing thrash — before gating.
- [ ] Generate one review package from the recorded slice base through current HEAD (`skills/subagent-driven-development/scripts/review-package BASE HEAD`).
- [ ] Dispatch one fresh independent final-gate reviewer (resolved via `workstack-agent-routing` with specialty `final-gate`; identity must differ from every S3 author) with the specification (§7.1, §11.3, §12, §13), this slice section, the verification log, and the diff package by path.
- [ ] Fix the complete finding set with one fixer, rerun covering verification, and resume the same reviewer thread until it approves the current HEAD.
- [ ] Open exactly one PR for S3 against `main` and merge only its reviewed head. Do not refresh FSMCRM's project-local install from this merge (per the 2026-07-19 collision decision).

---

## Planning Checkpoints

### Checkpoint C4 — Living Plan and Planned-Work Entry Points

- **Trigger:** S3 merged and one real quick task has passed its gate, PR, and closeout.
- **Outcome:** Implement the living-plan schema, slice index transitions, ignored worktree context, progress ledger, durable recovery order, coarse Linear reconciliation, and the `workstack-start` and `workstack-resume` wrappers calling upstream skills through the continuation seams and centralized routing. Restart/idempotency tests prove recovery from task, gate, PR, and post-merge states. Also add fork-owned plan-authoring guidance carrying the refined-fork rules named in the Instructional-Conflict Register (self-contained tasks, surgical references, code anchors, sweep enumeration, extraction test) — rule plus one example each, supplied to the plan-writing continuation, not edited into upstream `writing-plans`.
- **Re-explore:** current SDD workspace scripts, worktree helpers, plan format, restart behavior, project-local skill discovery/trigger behavior in Claude Code and Codex, and — for the spec-writing stage — the legacy refined fork's `writing-specs` skill alongside FSMCRM's transitional `workstack-write-spec`.

### Checkpoint C5 — Parallel Slices and Active Contracts

- **Trigger:** one sequential slice completes end-to-end through `workstack-resume`.
- **Outcome:** Add dependency/conflict classification, separate worktrees, lightweight contract creation, producer/consumer status, stale audit, and owner-driven pruning. Keep parallelism outside the inner SDD loop, and scope `dispatching-parallel-agents` explicitly: WorkStack text cites it only for read-only exploration fan-out and independent contract-covered slices, never for implementation inside a slice (per the Instructional-Conflict Register).
- **Re-explore:** FSMCRM migration/data-model ownership, real overlap patterns, and the transitional `workstack-batch-plan` contract and lane rules.

### Checkpoint C6 — Cutover, Pilots, and Closeout

- **Trigger:** contracts and closeout tests pass.
- **Outcome:** Refresh FSMCRM's project-local fork installation with an explicit skill list that applies the register's exclusions (`executing-plans` is not installed), resolving entry-point name collisions with the transitional skills and the known `.codex` parity gaps (missing `workstack-agent-routing`, stray empty `.codex/skills/pr-monitor/`). Add project `.workstack/agents.json`, rewrite FSMCRM `AGENTS.md` to the two-paragraph summary plus three entry points — retaining the precedence ladder (user instructions over skills), the Testing Judgment section, the worktree rules, and one clarification that in dispatched subagents "your human partner" means the dispatching orchestrator — and prove the entry points from clean Claude Code and Codex sessions. Run the pilots — a quick task, a sequential multi-ticket effort with an intermediate planning checkpoint, and two independent parallel slices under a contract — while the transitional skills still exist. Only after pilots pass: remove the superseded transitional `workstack-*` skills, reconcile any Linear projects still structured by phases, fix specification gaps, close contracts, prune plans and worktrees, document the upstream-update procedure, and run one final conflict scan of the installed skill set against the Instructional-Conflict Register.
- **Re-explore:** current FSMCRM skills and any changes made since commit `4787cf51`; preserve unrelated user work.

## Final Closeout Conditions

- All specification definition-of-done checks pass.
- Every delivery PR is merged at its independently reviewed head.
- Linear is reconciled only for real assigned tickets.
- No active contract, branch, worktree, monitor, or ignored run artifact remains without an owner.
- This living plan is removed from the current tree by a coordination commit after S6; Git history remains the record.
