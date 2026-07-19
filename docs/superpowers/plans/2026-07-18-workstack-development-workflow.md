# WorkStack Development Workflow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` to execute each ready slice task-by-task. A worker receives one extracted task brief, not this whole plan.

**Status:** Active — S1 complete; S2 landed; S3 landed (Tasks 8–12 on `main` at `195f108`; Task 13 fresh-agent evals and the independent S3 gate/PR waived by the user 2026-07-19 in favor of a direct in-session review with the full deterministic suite green); S4–S6 fully detailed 2026-07-19 by user direction (planning checkpoints C4–C6 retired; merge-order execution dependencies retained); next: execute S4 (Tasks 14–19); spec §6.3 fifth-divergence amendment user-approved 2026-07-19

**Plan owner:** Top-level WorkStack workflow orchestrator

**Primary specification:** `docs/superpowers/specs/2026-07-18-workstack-development-workflow-spec.md`

**Linear tickets:** None assigned. Do not invent ticket IDs; add real IDs when this work is represented in Linear.

**Goal:** Deliver a maintainable WorkStack fork of current Superpowers with centralized agent routing, three simple project entry points, living-plan delivery slices, closed review and PR loops, and recoverable parallel coordination.

**Architecture:** Keep upstream Superpowers as the inner implementation engine and add WorkStack policy as wrapper skills and small deterministic helpers. Permit only the documented core seams. Distribute the shared skill tree project-locally from the maintained fork rather than relying on a global plugin install. Detail only the current dependency frontier; re-explore and plan later slices after their prerequisites merge. *(Frontier-only detailing waived for S4–S6 by user direction 2026-07-19 — see Decision Log; each slice re-verifies its named surfaces before dispatch.)*

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
| 2026-07-19 | User waived the Task 13 fresh-agent evals and the independent S3 final-gate reviewer/PR; S3 landed as direct commits on `main` (`7796da9`..`195f108`) after an in-session review of every skill addition/modification with the full deterministic suite green. The Instructional-Conflict Register's eval-gated revisits (greedy `brainstorming`/`using-superpowers` triggers) now key off the first real quick-task/pilot runs instead of Task 13. | Schedule pressure; the S3 skill texts were plan-specified verbatim and had already been proactively reviewed during plan detailing. |
| 2026-07-19 | Made the Codex packaging tar.gz path portable: GNU-tar owner flags beside the bsdtar spelling, umask-independent stage permission normalization, and a Python-based timestamp assertion in the packaging test. | The tar.gz branch and its test assertions were macOS/bsdtar-only and failed on Linux GNU tar, blocking S3 verification on this machine. |
| 2026-07-19 | User directed planning the full remainder in one pass: C4–C6 retired and replaced by detailed ready slices S4–S6; execution keeps merge-order dependencies (S4 → S5 → S6) and each slice re-verifies its named surfaces before dispatch. The C4/C5 behavioral triggers (first real quick task; first sequential slice) are demoted from planning preconditions to pilot evidence gathered in S6. | Schedule pressure; S4's skill designs are authored verbatim in this plan, so S5/S6 plan against known interfaces rather than guesses. Planned against spec digest, FSMCRM transitional-skill extraction, and legacy refined-fork rules re-explored 2026-07-19. |
| 2026-07-19 | Bundle the living-plan format, plan-authoring, and active-contract reference docs inside `skills/workstack-resume/` (supporting files beside SKILL.md) rather than under `workstack/`. | `workstack/` docs are not packaged or installed project-locally; supporting files inside a skill directory travel with every harness install, and `workstack-resume` is the natural single owner of the plan lifecycle. |
| 2026-07-19 | `workstack-slice-gate` ships thin: it supplies the slice-level reviewer route, review inputs, and checklist, and defers all gate mechanics (`REVIEW_HEAD`, delta packaging, same-thread re-review) to SDD's final whole-branch gate. | Avoids duplicating the S2 closed-loop gate mechanics; one owner per mechanic per the Global Constraints. |
| 2026-07-19 | At the S6 cutover, FSMCRM's transitional PR-provider mechanics (Codex/CodeRabbit tiers, helper-script commands, CI exit-code map, 180s/60-min timings, the `!simple` lane and its reserved exclusions) move into `.workstack/pr-policy.md`, and its model ladder moves into `.workstack/agents.json`. | Spec §13.3/§16.2 place provider and model specifics in project configuration; the battle-tested rules survive cutover without re-entering fork skills. |
| 2026-07-19 | Resolve the S6 entry-point name collisions by renaming the three colliding transitional skills (`workstack-quick-task`, `workstack-ux-gate`, `workstack-pr-monitor`) to `legacy-workstack-*` in both FSMCRM mirrors before the install refresh; delete them with the rest of the transitional set only after pilots pass. | Keeps the proven fallback available during pilots (spec §1.1, §23) while letting fork entry points own the canonical names. |

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
| S3 — Quick-task delivery loop | Ship `workstack-quick-task` plus the slice lifecycle it needs: whole-slice gate, conditional UX evidence, exact-head PR, monitor, closeout; capture fresh-agent seam evidence | None assigned | S2 merged | Landed (Tasks 8–12; Task 13 evals and gate/PR waived by user) | `main` at `195f108` | None | Direct commits authorized by user |
| S4 — Living plan and planned-work entry points | Add living-plan format and plan-authoring docs, `workstack-spec-review`, `workstack-slice-gate`, `workstack-start`, and `workstack-resume` (Tasks 14–19) | None assigned | S3 landed | Ready (planned 2026-07-19) | — | None | — |
| S5 — Parallel delivery contracts | Add the active-contracts/parallel-eligibility doc and the `workstack-resume` parallel dispatch rows (Tasks 20–21) | None assigned | S4 merged | Ready (planned 2026-07-19) | — | Producer | — |
| S6 — Cutover, pilots, and closeout | FSMCRM install refresh, `.workstack/agents.json` + `pr-policy.md`, `AGENTS.md` rewrite, entry-point proofs, pilots, transitional-skill removal, closeout (Tasks 22–27) | None assigned | S5 merged | Ready (planned 2026-07-19) | — | Close all | — |

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

## Landed Slice S3 — Quick-Task Delivery Loop

**Actual delivery (2026-07-19):** Tasks 8–12 landed as direct commits on `main` (`7796da9`..`195f108`). The user waived Task 13's fresh-agent evals and the independent final-gate reviewer/PR; in their place, an in-session review checked every skill addition/modification for simplicity, clarity, and coherence, and the full deterministic suite (all `tests/workstack/`, packaging, manifest, sync, divergence check) passed. A tar.gz packaging portability fix (bsdtar→GNU tar) was applied during that verification. The C4 trigger's "one real quick task" precondition remains outstanding.

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

- [x] **Step 1: Write the failing test** at `tests/workstack/test-pr-monitor.sh` (mark executable):

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

- [x] **Step 2: Run it to verify it fails**

Run: `bash tests/workstack/test-pr-monitor.sh`
Expected: `not ok - skill file missing`, exit 1.

- [x] **Step 3: Write the skill** at `skills/workstack-pr-monitor/SKILL.md` with exactly this content:

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

- [x] **Step 4: Write the metadata** at `skills/workstack-pr-monitor/agents/openai.yaml`:

```yaml
interface:
  display_name: "WorkStack PR Monitor"
  short_description: "Own one PR through CI, review, fixes, and merge"
  default_prompt: "Use $workstack-pr-monitor to shepherd this pull request through merge."
```

- [x] **Step 5: Run the test to verify it passes**

Run: `bash tests/workstack/test-pr-monitor.sh`
Expected: all `ok` lines, final `PASS`, exit 0.

- [x] **Step 6: Run the divergence check**

Run: `python3 scripts/check-workstack-divergences.py`
Expected: exit 0 (new `skills/workstack-*` directories are fork additions, not core divergences).

- [x] **Step 7: Commit**

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

- [x] **Step 1: Write the failing test** at `tests/workstack/test-ux-gate.sh` (mark executable). Start from the committed `tests/workstack/test-pr-monitor.sh`: copy its shebang, `set -euo pipefail`, `repo_root` line, and the `assert_contains` and `assert_no_model_names` helper functions verbatim, then continue with:

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

- [x] **Step 2: Run it to verify it fails**

Run: `bash tests/workstack/test-ux-gate.sh`
Expected: `not ok - skill file missing`, exit 1.

- [x] **Step 3: Write the skill** at `skills/workstack-ux-gate/SKILL.md` with exactly this content:

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

- [x] **Step 4: Write the metadata** at `skills/workstack-ux-gate/agents/openai.yaml`:

```yaml
interface:
  display_name: "WorkStack UX Gate"
  short_description: "Real-browser UX verification of changed surfaces"
  default_prompt: "Use $workstack-ux-gate to verify the changed surfaces against the approved UX criteria."
```

- [x] **Step 5: Run the test to verify it passes**

Run: `bash tests/workstack/test-ux-gate.sh`
Expected: all `ok` lines, final `PASS`, exit 0.

- [x] **Step 6: Commit**

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

- [x] **Step 1: Write the failing test** at `tests/workstack/test-completion-contract.sh` (mark executable). Start from the committed `tests/workstack/test-pr-monitor.sh` preamble (shebang, `set -euo pipefail`, `repo_root`) and its `assert_contains` helper copied verbatim, then continue with:

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

- [x] **Step 2: Run it to verify it fails**

Run: `bash tests/workstack/test-completion-contract.sh`
Expected: `not ok - completion contract exists`, exit 1.

- [x] **Step 3: Add the seam.** In `skills/finishing-a-development-branch/SKILL.md`, insert this paragraph immediately after the `**Announce at start:**` line, changing nothing else in the file:

```markdown
**Completion contract:** If the invoking prompt declared exactly one completion route (optionally naming the target base branch) before this skill was invoked, run the Step 1 test verification, then execute that route and its cleanup directly instead of presenting the options below. An undeclared or ambiguous route falls through to the normal options. This changes only who chooses the option; every verification and cleanup rule still applies.
```

- [x] **Step 4: Allowlist the divergence.** Add `skills/finishing-a-development-branch/SKILL.md` to `workstack/upstream-divergences.json` with the reason: "caller-declared completion contract so orchestrated slices reach their gated PR without an interactive options menu; menu remains the default".

- [x] **Step 5: Run the test to verify it passes**

Run: `bash tests/workstack/test-completion-contract.sh`
Expected: all `ok` lines, final `PASS`, exit 0.

- [x] **Step 6: Run the divergence and regression checks**

Run: `python3 scripts/check-workstack-divergences.py && bash tests/workstack/test-upstream-divergences.sh && bash tests/workstack/test-final-review-gate.sh`
Expected: exit 0 / `PASS` from each.

- [x] **Step 7: Commit**

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

- [x] **Step 1: Write the failing test** at `tests/workstack/test-quick-task.sh` (mark executable). Start from the committed `tests/workstack/test-pr-monitor.sh` (shebang, `set -euo pipefail`, `repo_root`, `assert_contains`, `assert_no_model_names` — copied verbatim) plus the `assert_before` helper copied verbatim from the committed `tests/workstack/test-continuation-seams.sh`, then continue with:

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

- [x] **Step 2: Run it to verify it fails**

Run: `bash tests/workstack/test-quick-task.sh`
Expected: `not ok - skill file missing`, exit 1.

- [x] **Step 3: Write the skill** at `skills/workstack-quick-task/SKILL.md` with exactly this content:

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

- [x] **Step 4: Write the metadata** at `skills/workstack-quick-task/agents/openai.yaml`:

```yaml
interface:
  display_name: "WorkStack Quick Task"
  short_description: "Ship a small decision-complete change through one PR"
  default_prompt: "Use $workstack-quick-task to ship this small change end to end."
```

- [x] **Step 5: Run the test to verify it passes**

Run: `bash tests/workstack/test-quick-task.sh`
Expected: all `ok` lines, final `PASS`, exit 0.

- [x] **Step 6: Run the neighboring seam tests** (the entry point leans on them)

Run: `bash tests/workstack/test-continuation-seams.sh && bash tests/workstack/test-final-review-gate.sh && bash tests/workstack/test-reviewer-context.sh`
Expected: `PASS` from each.

- [x] **Step 7: Commit**

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

- [x] **Step 1: Add packaging assertions.** In `tests/codex/test-package-codex-plugin.sh`, after the existing `workstack-agent-routing` assertions, add:

```bash
for ws_skill in workstack-quick-task workstack-pr-monitor workstack-ux-gate; do
  assert_contains "$archive_paths" "skills/$ws_skill/SKILL.md" "archive includes $ws_skill skill"
  assert_contains "$archive_paths" "skills/$ws_skill/agents/openai.yaml" "archive includes committed $ws_skill metadata"
done
```

- [x] **Step 2: Run the packaging test**

Run: `bash tests/codex/test-package-codex-plugin.sh`
Expected: exit 0. If an assertion fails, fix the packaging script only within the S1 metadata-precedence behavior (committed source metadata first, external second); do not change package shape otherwise.

- [x] **Step 3: Write the workflow summary draft** at `workstack/AGENTS-SNIPPET.md` with exactly this content:

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

- [x] **Step 4: Write its test** at `tests/workstack/test-workflow-summary.sh` (mark executable). Start from the committed `tests/workstack/test-pr-monitor.sh` preamble (shebang, `set -euo pipefail`, `repo_root`) and its `assert_contains` helper copied verbatim, then continue with:

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

- [x] **Step 5: Run the new test and the manifest/package suite**

Run: `bash tests/workstack/test-workflow-summary.sh && bash tests/codex/test-package-codex-plugin.sh && bash tests/codex/test-marketplace-manifest.sh && bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh`
Expected: exit 0 from each.

- [x] **Step 6: Commit**

```bash
git add tests/codex/test-package-codex-plugin.sh workstack/AGENTS-SNIPPET.md tests/workstack/test-workflow-summary.sh
git commit -m "package new workstack skills and add workflow summary draft"
```

### Task 13: Record fresh-agent behavioral evidence

**WAIVED 2026-07-19 by user decision (see Decision Log) — do not execute.** Behavioral evidence now comes from real usage: the first quick-task run and the S6 pilots. The routing-thrash observation feeding the Instructional-Conflict Register moves there too.

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

- [x] Record the slice base SHA before Task 8 begins: `7a392aa` (with docs commits `d700a20`/`ef3cbbf` between base and Task 8).
- [x] Run `bash tests/workstack/test-pr-monitor.sh`, `bash tests/workstack/test-ux-gate.sh`, `bash tests/workstack/test-completion-contract.sh`, `bash tests/workstack/test-quick-task.sh`, and `bash tests/workstack/test-workflow-summary.sh`; all `PASS` 2026-07-19.
- [x] Run the pre-existing suite: `bash tests/workstack/test-upstream-divergences.sh`, `bash tests/workstack/test-agent-routing.sh`, `bash tests/workstack/test-continuation-seams.sh`, `bash tests/workstack/test-final-review-gate.sh`, `bash tests/workstack/test-reviewer-context.sh`, `bash tests/codex/test-package-codex-plugin.sh`, `bash tests/codex/test-marketplace-manifest.sh`, `bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh`; all exit 0 2026-07-19 (packaging test after the tar.gz portability fix).
- [x] Run `python3 scripts/check-workstack-divergences.py`; exit 0, no new core divergences.
- ~~Confirm all seven Task 13 verdict files exist~~ — Task 13 waived by user 2026-07-19 (see Decision Log); routing-thrash observation deferred to the first real quick-task run.
- ~~Review package / independent final-gate reviewer / reviewer loop / S3 PR~~ — waived by user 2026-07-19; replaced by an in-session review of all skill additions/modifications with the deterministic suite green. Direct commits to `main` authorized (S2 precedent). FSMCRM's project-local install was not refreshed (per the 2026-07-19 collision decision).

---

## Ready Slice S4 — Living Plan and Planned-Work Entry Points (was Checkpoint C4)

**Planning note (2026-07-19):** Detailed by user direction ahead of the original trigger; the "one real quick task" precondition is demoted to S6 pilot evidence. Surfaces re-explored for this planning: the full spec (§7, §8, §9, §10, §11, §13, §17, §18 digested with section citations), the SDD scripts (`task-brief`, `review-package`, `sdd-workspace` CLIs confirmed), `using-git-worktrees` declared-preference behavior, `resolve-agent` flags/output, the S2 continuation clauses (verbatim), FSMCRM's transitional `workstack-write-spec`/`workstack-shepherd-phase`/`workstack-run-ticket`, and the legacy refined fork's `writing-specs` and plan-authoring rules.

**Execution precondition:** S3 landed (satisfied). No behavioral trigger; execute next.

**Goal:** Ship the planned-work lifecycle: the `workstack-start` and `workstack-resume` public entry points, the two internal helpers they need (`workstack-spec-review`, `workstack-slice-gate`), and the two canonical reference docs (`living-plan-format.md`, `plan-authoring.md`) bundled inside `skills/workstack-resume/` so they install with the skill set — with deterministic tests, Codex packaging, and the workflow summary still two paragraphs.

**Acceptance signals:**

- A fresh agent with an approved spec can reach a merged, reconciled slice using only `workstack-resume` and the skills its dispatch table names.
- `workstack-resume`'s dispatch table is exhaustive: every recoverable state (spec-only, checkpoint, ready, mid-task, gated, PR open, merged-unreconciled, closeout, inconsistent) has its own row, and the idempotency sentences ("never redispatched", "monitored, never recreated", "reconciled, never reopened", "exactly once") are asserted by test.
- The recovery authority order appears exactly once (in `workstack-resume`), the plan schema/gate taxonomy exactly once (`living-plan-format.md`), and the six refined-fork authoring rules exactly once (`plan-authoring.md`).
- `workstack-slice-gate` adds slice inputs and checklist without restating SDD's gate mechanics.
- All four new skills package for Codex with committed OpenAI metadata; divergence check passes (no new core changes); no concrete model names in any skill prose.

**Design decisions for this slice:**

- The reference docs live beside `workstack-resume`'s SKILL.md (see Decision Log) and are referenced as "this skill's `living-plan-format.md`" — never restated in other skills.
- `workstack-start` names itself as the brainstorming continuation so draft-direction approval returns to its step 2 instead of flowing to `writing-plans`; `workstack-resume` names itself as the `writing-plans` continuation.
- Ticket reconciliation is a `workstack-resume` dispatch-table step, not a skill: coarse Linear only (create/reconcile after spec approval, in-progress at slice start, close at merge — one batched operation each).
- The progress ledger is a markdown file at `.superpowers/sdd/ledger.md` with a defined row format; no new script. "Write the transition before acting on it" is ported from the transitional shepherd.
- Restart/idempotency evidence is deterministic (grep assertions on the dispatch table); behavioral proof lands in the S6 pilots (including the §22.7 mid-slice kill-and-resume probe).

### Task 14: Add the workstack-spec-review skill

**Files:**

- Create: `skills/workstack-spec-review/SKILL.md`
- Create: `skills/workstack-spec-review/agents/openai.yaml`
- Create: `tests/workstack/test-spec-review.sh`

**Interfaces:**

- Consumes: `workstack-agent-routing` reviewer resolution with `--reviewer-specialty spec`.
- Produces: the skill name `workstack-spec-review` and its verdict contract (`Approved` or blocking findings tied to exact sections). Task 16's `workstack-start` references it by name.

- [ ] **Step 1: Write the failing test** at `tests/workstack/test-spec-review.sh` (mark executable). Start from the committed `tests/workstack/test-pr-monitor.sh` (shebang, `set -euo pipefail`, `repo_root`, `assert_contains`, `assert_no_model_names` — copied verbatim), then continue with:

```bash
skill="$repo_root/skills/workstack-spec-review/SKILL.md"
metadata="$repo_root/skills/workstack-spec-review/agents/openai.yaml"

[ -f "$skill" ] || { echo "not ok - skill file missing: $skill" >&2; exit 1; }

assert_contains "$skill" "name: workstack-spec-review" "frontmatter name"
assert_contains "$skill" "I'm running the spec review for <spec-path>." "announce line"
assert_contains "$skill" "The reviewer never makes product decisions." "reviewer scope bound"
assert_contains "$skill" "specialty \`spec\` via workstack-agent-routing" "routed spec reviewer"
assert_contains "$skill" "fail closed on reviewer-independence errors" "independence fails closed"
assert_contains "$skill" "a planner can plan from the spec without guessing" "approval bar"
assert_contains "$skill" "\`Approved\` or blocking findings tied to exact sections" "verdict contract"
assert_contains "$skill" "resume the same reviewer thread until \`Approved\`" "same-thread loop"
assert_contains "$skill" "goes back to your human partner, not to the reviewer" "product decisions escalate"
assert_contains "$skill" "Do not start Linear decomposition or implementation planning before user approval" "approval precedes planning"
assert_no_model_names "$skill"

[ -f "$metadata" ] || { echo "not ok - committed OpenAI metadata missing" >&2; exit 1; }
grep -Fq "display_name" "$metadata" || { echo "not ok - metadata lacks display_name" >&2; exit 1; }
echo "ok - committed OpenAI metadata present"

echo "PASS"
```

- [ ] **Step 2: Run it to verify it fails** — `bash tests/workstack/test-spec-review.sh`; expect `not ok - skill file missing`, exit 1.

- [ ] **Step 3: Write the skill** at `skills/workstack-spec-review/SKILL.md` with exactly this content:

```markdown
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
```

- [ ] **Step 4: Write the metadata** at `skills/workstack-spec-review/agents/openai.yaml`:

```yaml
interface:
  display_name: "WorkStack Spec Review"
  short_description: "Independent review loop for a draft specification"
  default_prompt: "Use $workstack-spec-review to review this specification."
```

- [ ] **Step 5: Run the test to verify it passes** — all `ok` lines, final `PASS`, exit 0.
- [ ] **Step 6: Run `python3 scripts/check-workstack-divergences.py`** — exit 0.
- [ ] **Step 7: Commit** — `git add skills/workstack-spec-review tests/workstack/test-spec-review.sh && git commit -m "add workstack-spec-review skill"`

### Task 15: Add the workstack-slice-gate skill

**Files:**

- Create: `skills/workstack-slice-gate/SKILL.md`
- Create: `skills/workstack-slice-gate/agents/openai.yaml`
- Create: `tests/workstack/test-slice-gate.sh`

**Interfaces:**

- Consumes: `workstack-agent-routing` reviewer resolution with `--reviewer-specialty final-gate`; SDD's final whole-branch gate (owns `REVIEW_HEAD`, `scripts/review-package`, delta re-review); the S2 reviewer-context seam (`docs/REVIEW-GUIDANCE.md`).
- Produces: the skill name `workstack-slice-gate` and its recorded exact-head approval. Task 18's `workstack-resume` references it by name.

- [ ] **Step 1: Write the failing test** at `tests/workstack/test-slice-gate.sh` (mark executable). Start from the committed `tests/workstack/test-pr-monitor.sh` helpers (verbatim), then continue with:

```bash
skill="$repo_root/skills/workstack-slice-gate/SKILL.md"
metadata="$repo_root/skills/workstack-slice-gate/agents/openai.yaml"

[ -f "$skill" ] || { echo "not ok - skill file missing: $skill" >&2; exit 1; }

assert_contains "$skill" "name: workstack-slice-gate" "frontmatter name"
assert_contains "$skill" "I'm running the slice gate for <slice>." "announce line"
assert_contains "$skill" "One slice, one gate, one PR." "one-gate invariant"
assert_contains "$skill" "owned by superpowers:subagent-driven-development's final whole-branch gate and are not restated here" "gate mechanics deferred to SDD"
assert_contains "$skill" "specialty \`final-gate\`" "routed final-gate reviewer"
assert_contains "$skill" "fail closed on independence errors" "independence fails closed"
assert_contains "$skill" "docs/REVIEW-GUIDANCE.md" "reviewer-only guidance offered"
assert_contains "$skill" "spec and ticket coverage" "slice checklist: coverage"
assert_contains "$skill" "integration coherence" "slice checklist: coherence"
assert_contains "$skill" "accidental scope or unsupported claims" "slice checklist: scope"
assert_contains "$skill" "Run the UX gate before this gate" "UX gate ordering"
assert_contains "$skill" "Record the gate verdict and approved SHA in the progress ledger" "ledger recording"
assert_contains "$skill" "Never open a PR or invoke branch completion with findings open" "no PR with open findings"
assert_contains "$skill" "a new commit after approval restarts gate evidence" "head-bound evidence"
assert_no_model_names "$skill"

[ -f "$metadata" ] || { echo "not ok - committed OpenAI metadata missing" >&2; exit 1; }
grep -Fq "display_name" "$metadata" || { echo "not ok - metadata lacks display_name" >&2; exit 1; }
echo "ok - committed OpenAI metadata present"

echo "PASS"
```

- [ ] **Step 2: Run it to verify it fails** — expect `not ok - skill file missing`, exit 1.

- [ ] **Step 3: Write the skill** at `skills/workstack-slice-gate/SKILL.md` with exactly this content:

```markdown
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
```

- [ ] **Step 4: Write the metadata** at `skills/workstack-slice-gate/agents/openai.yaml`:

```yaml
interface:
  display_name: "WorkStack Slice Gate"
  short_description: "Whole-slice quality gate before the PR"
  default_prompt: "Use $workstack-slice-gate to gate this slice's complete diff."
```

- [ ] **Step 5: Run the test to verify it passes** — final `PASS`, exit 0.
- [ ] **Step 6: Run `bash tests/workstack/test-final-review-gate.sh`** — `PASS` (the SDD gate this skill defers to is unchanged).
- [ ] **Step 7: Commit** — `git add skills/workstack-slice-gate tests/workstack/test-slice-gate.sh && git commit -m "add workstack-slice-gate skill"`

### Task 16: Add the workstack-start public entry point

**Files:**

- Create: `skills/workstack-start/SKILL.md`
- Create: `skills/workstack-start/agents/openai.yaml`
- Create: `tests/workstack/test-start.sh`

**Interfaces:**

- Consumes: `brainstorming`'s continuation contract ("If the invoking prompt named exactly one continuation skill before this skill was invoked, invoke it after the user approves the written spec"); `workstack-spec-review` (Task 14); spec locations from §8.1.
- Produces: the public entry point `workstack-start`, already referenced by name in `workstack-quick-task`'s promotion clause and `workstack/AGENTS-SNIPPET.md` — the name is load-bearing.

- [ ] **Step 1: Write the failing test** at `tests/workstack/test-start.sh` (mark executable). Start from the committed `tests/workstack/test-pr-monitor.sh` helpers plus `assert_before` from `tests/workstack/test-continuation-seams.sh` (verbatim), then continue with:

```bash
skill="$repo_root/skills/workstack-start/SKILL.md"
metadata="$repo_root/skills/workstack-start/agents/openai.yaml"

[ -f "$skill" ] || { echo "not ok - skill file missing: $skill" >&2; exit 1; }

assert_contains "$skill" "name: workstack-start" "frontmatter name"
assert_contains "$skill" "I'm using workstack-start to take this from idea to approved spec." "announce line"
assert_contains "$skill" "This skill makes nothing; it sequences approvals." "pure-sequencer stance"
assert_contains "$skill" "superpowers:brainstorming" "delegates discovery to brainstorming"
assert_contains "$skill" "naming \`workstack-start\` as the continuation" "continuation declared"
assert_contains "$skill" "instead of flowing to writing-plans" "default continuation pre-empted"
assert_contains "$skill" "docs/superpowers/specs/YYYY-MM-DD-<feature-slug>-spec.md" "canonical spec location"
assert_contains "$skill" "Do not write code, scaffold, plan, or invoke any implementation skill until your human partner approves the direction." "direction hard gate"
assert_contains "$skill" "Expand the same file — never a second design artifact" "single spec artifact"
assert_contains "$skill" "Decision-complete is the bar" "spec bar"
assert_contains "$skill" "empty open-questions section" "open questions closed at approval"
assert_contains "$skill" "No implementation task lists, branch structure, or speculative file paths" "spec content exclusions"
assert_contains "$skill" "workstack-spec-review" "spec review helper"
assert_contains "$skill" "No Linear decomposition and no implementation planning before that approval." "approval hard gate"
assert_contains "$skill" "Invoke \`workstack-resume\` with the approved spec path" "handoff to resume"
assert_contains "$skill" "Resume Work owns every later state" "no overlapping path"
assert_before "$skill" "## 1. Direction" "## 2. Specification" "direction precedes spec"
assert_before "$skill" "## 3. Review and approval" "## 4. Hand off" "review precedes handoff"
assert_no_model_names "$skill"

[ -f "$metadata" ] || { echo "not ok - committed OpenAI metadata missing" >&2; exit 1; }
grep -Fq "display_name" "$metadata" || { echo "not ok - metadata lacks display_name" >&2; exit 1; }
echo "ok - committed OpenAI metadata present"

echo "PASS"
```

- [ ] **Step 2: Run it to verify it fails** — expect `not ok - skill file missing`, exit 1.

- [ ] **Step 3: Write the skill** at `skills/workstack-start/SKILL.md` with exactly this content:

```markdown
---
name: workstack-start
description: Use when work is new, ambiguous, or lacks an approved specification. Public WorkStack entry point - brainstorm to an approved direction, expand it into a reviewed decision-complete specification, then hand off to workstack-resume, which owns every state after spec approval.
---

# WorkStack Start

**Announce:** "I'm using workstack-start to take this from idea to approved spec."

**Entry:** a new or ambiguous request with no approved specification.
**Exit:** a user-approved specification handed to `workstack-resume`. This skill makes nothing; it sequences approvals.

## 1. Direction

Invoke superpowers:brainstorming, naming `workstack-start` as the continuation so approval of the draft direction returns here instead of flowing to writing-plans. The draft lives at `docs/superpowers/specs/YYYY-MM-DD-<feature-slug>-spec.md` in `Draft direction` state.

**HARD GATE:** Do not write code, scaffold, plan, or invoke any implementation skill until your human partner approves the direction.

## 2. Specification

Expand the same file — never a second design artifact — into a decision-complete specification: goal, context, approved decisions, numbered testable requirements, actors and failure behavior, data and API contract decisions, frontend state and visual acceptance criteria where applicable, acceptance signals, non-goals, and an empty open-questions section. Decision-complete is the bar: a planner must be able to plan from it without guessing product intent, ownership boundaries, or acceptance signals. No implementation task lists, branch structure, or speculative file paths.

## 3. Review and approval

Run workstack-spec-review to `Approved`, then obtain your human partner's approval of the reviewed specification.

**HARD GATE:** No Linear decomposition and no implementation planning before that approval.

## 4. Hand off

Invoke `workstack-resume` with the approved spec path. Resume Work owns every later state — tickets, the living plan, slices, gates, PRs, recovery, closeout. Do not create an overlapping path here.
```

- [ ] **Step 4: Write the metadata** at `skills/workstack-start/agents/openai.yaml`:

```yaml
interface:
  display_name: "WorkStack Start"
  short_description: "Take new or ambiguous work to an approved spec"
  default_prompt: "Use $workstack-start to shape and spec this work."
```

- [ ] **Step 5: Run the test to verify it passes** — final `PASS`, exit 0.
- [ ] **Step 6: Run `bash tests/workstack/test-continuation-seams.sh` and `bash tests/workstack/test-quick-task.sh`** — `PASS` from each (the continuation seam and the promotion clause this entry point relies on are unchanged).
- [ ] **Step 7: Commit** — `git add skills/workstack-start tests/workstack/test-start.sh && git commit -m "add workstack-start public entry point"`

### Task 17: Add the living-plan format and plan-authoring reference docs

**Files:**

- Create: `skills/workstack-resume/living-plan-format.md`
- Create: `skills/workstack-resume/plan-authoring.md`
- Create: `tests/workstack/test-plan-docs.sh`

**Interfaces:**

- Consumes: spec §10 (plan structure), §17.2/§18 (artifacts and retention), §12.2/§13 (gate ordering); the legacy refined fork's six authoring rules (per the Instructional-Conflict Register porting decision); SDD's `.superpowers/sdd` workspace.
- Produces: the two canonical reference docs Task 18's SKILL.md and the plan-writing continuation cite by filename. The gate taxonomy and ledger format are defined here and nowhere else.

- [ ] **Step 1: Write the failing test** at `tests/workstack/test-plan-docs.sh` (mark executable). Start from the committed `tests/workstack/test-pr-monitor.sh` helpers (verbatim), then continue with:

```bash
fmt="$repo_root/skills/workstack-resume/living-plan-format.md"
auth="$repo_root/skills/workstack-resume/plan-authoring.md"

[ -f "$fmt" ] || { echo "not ok - living-plan-format.md missing" >&2; exit 1; }
[ -f "$auth" ] || { echo "not ok - plan-authoring.md missing" >&2; exit 1; }

assert_contains "$fmt" "docs/superpowers/plans/YYYY-MM-DD-<feature-slug>.md" "plan location"
assert_contains "$fmt" "removed from the current tree by a coordination commit" "closeout removal"
assert_contains "$fmt" "Delivery-slice index" "slice index required"
assert_contains "$fmt" "\`deferred\`, \`ready\`, \`active\`, \`gated\`, \`PR open\`, \`merged\`, \`cancelled\`, \`blocked\`" "slice state vocabulary"
assert_contains "$fmt" "split the slice before PR creation" "no partial-slice merges"
assert_contains "$fmt" "It never guesses file paths, signatures, migrations, or task steps" "checkpoint anti-speculation rule"
assert_contains "$fmt" "Task review" "gate taxonomy: task review"
assert_contains "$fmt" "Whole-slice gate" "gate taxonomy: slice gate"
assert_contains "$fmt" "PR provider gate" "gate taxonomy: provider gate"
assert_contains "$fmt" ".superpowers/sdd/ledger.md" "ledger location"
assert_contains "$fmt" "Write the transition before acting on it" "ledger-before-action rule"
assert_contains "$fmt" "resume from the ledger alone" "ledger sufficiency"
assert_contains "$fmt" "never a content document" "thin worktree context pointer"
assert_contains "$fmt" "The recovery authority order lives in \`workstack-resume\`'s SKILL.md" "authority order single-sourced"

assert_contains "$auth" "pasted alone into a fresh implementer prompt" "extraction framing"
assert_contains "$auth" "Implementers never read the plan file" "self-contained tasks"
assert_contains "$auth" "References (paste into implementer prompt)" "reference block name"
assert_contains "$auth" "Never reference a whole document" "surgical references"
assert_contains "$auth" "three or more tasks share the exact same bare reference" "spec-dump smell"
assert_contains "$auth" "Existing Code Anchors" "anchors block name"
assert_contains "$auth" "current behavior, pattern to copy, code to preserve, known hazards" "anchor categories"
assert_contains "$auth" "\"Update all callers\" is not a task" "sweep rule"
assert_contains "$auth" "completion predicate" "sweep predicate"
assert_contains "$auth" "most ambitious task" "extraction test target"
assert_contains "$auth" "trivial tasks smuggle in implicit context" "extraction test breadth"

for f in "$fmt" "$auth"; do
  if grep -Eq 'phase plan|shepherd|implementation phase' "$f"; then
    echo "not ok - phase vocabulary in $f" >&2
    exit 1
  fi
done
echo "ok - no phase vocabulary"
echo "PASS"
```

- [ ] **Step 2: Run it to verify it fails** — expect `not ok - living-plan-format.md missing`, exit 1.

- [ ] **Step 3: Write** `skills/workstack-resume/living-plan-format.md` with exactly this content:

```markdown
# WorkStack Living Plan Format

Canonical definition of the living implementation plan, its slice lifecycle, the gate taxonomy, and the runtime artifacts. Skills and planners reference this document instead of restating it. The recovery authority order lives in `workstack-resume`'s SKILL.md.

## Plan document

Location: `docs/superpowers/plans/YYYY-MM-DD-<feature-slug>.md`, committed while active so worktrees and restarted orchestrators can read it, and removed from the current tree by a coordination commit at closeout — Git history remains the record.

Required sections, in order:

1. Status line and plan owner
2. Primary specification path
3. Linear ticket set (real IDs only, never invented)
4. Goal and completion signals
5. Global Constraints — copied from the spec and repository rules; every task brief carries this section
6. Decision log
7. Delivery-slice index
8. Fully detailed sections for the current ready frontier only
9. Lightweight planning checkpoints for dependent future work
10. Closeout conditions, including contract and artifact pruning

## Slice index

One row per slice: Slice ID and name · Ticket IDs · Dependencies · State · Branch/worktree (once execution starts) · Contract impact (None, producer, consumer, or reserved surface) · PR (once created).

Slice states: `deferred`, `ready`, `active`, `gated`, `PR open`, `merged`, `cancelled`, `blocked`. Every ticket belongs to exactly one slice in at most one active plan. All tickets in a slice start and complete together; split the slice before PR creation rather than merging it incomplete.

## Planning checkpoints

A checkpoint records only: intended outcome, included ticket IDs, known dependencies, facts frozen by the spec, the trigger that makes detailed planning appropriate, and the surfaces to re-explore. It never guesses file paths, signatures, migrations, or task steps before the prerequisite code exists. At the checkpoint: confirm prerequisites merged, sync, re-explore the named surfaces, detail the new frontier in the same plan, self-review, and continue without a user pause while inside approved spec and ticket scope.

## Gate taxonomy

Defined once here; skills refer to gates by name.

- **Task review** — one combined spec-compliance and code-quality review per task, owned by superpowers:subagent-driven-development.
- **UX gate** — `workstack-ux-gate`: scripted-capture verification of changed user-visible surfaces; runs before the whole-slice gate so its fixes land in the gated diff.
- **Whole-slice gate** — `workstack-slice-gate`: one fresh reviewer over the complete slice diff; a PR opens only after it approves the exact head.
- **PR provider gate** — `workstack-pr-monitor`: exact-head provider and CI conditions from `.workstack/pr-policy.md`, through merge.

## Runtime artifacts

- **Progress ledger** — `.superpowers/sdd/ledger.md`, worktree-local and ignored. One row per state transition: date · slice · task or gate · state · head SHA · next expected event, plus decisions and deviations. Write the transition before acting on it; a fresh orchestrator must be able to resume from the ledger alone. Deleted with the worktree.
- **Worktree context** — uncommitted `docs/WORKTREE_CONTEXT.md`: a thin pointer naming the slice and the living-plan path, never a content document. Deleted with the worktree.
- **Briefs, reports, review packages, verification logs** — under ignored `.superpowers/`, one owner each, deleted with the worktree.
```

- [ ] **Step 4: Write** `skills/workstack-resume/plan-authoring.md` with exactly this content:

```markdown
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
```

- [ ] **Step 5: Run the test to verify it passes** — final `PASS`, exit 0.
- [ ] **Step 6: Commit** — `git add skills/workstack-resume tests/workstack/test-plan-docs.sh && git commit -m "add living-plan format and plan-authoring reference docs"`

### Task 18: Add the workstack-resume public entry point

**Files:**

- Create: `skills/workstack-resume/SKILL.md`
- Create: `skills/workstack-resume/agents/openai.yaml`
- Create: `tests/workstack/test-resume.sh`

**Interfaces:**

- Consumes: Task 17's reference docs (same directory); `workstack-agent-routing`; `workstack-ux-gate`, `workstack-slice-gate`, `workstack-pr-monitor` by name; `writing-plans`' continuation contract; `using-git-worktrees` declared-preference behavior; `finishing-a-development-branch`'s completion contract; SDD.
- Produces: the public entry point `workstack-resume` — the name already referenced by `workstack-quick-task`, `workstack-start`, and `workstack/AGENTS-SNIPPET.md`. S5's Task 21 extends this file's dispatch table; keep the table format stable.

- [ ] **Step 1: Write the failing test** at `tests/workstack/test-resume.sh` (mark executable). Start from the committed `tests/workstack/test-pr-monitor.sh` helpers plus `assert_before` (verbatim), then continue with:

```bash
skill="$repo_root/skills/workstack-resume/SKILL.md"
metadata="$repo_root/skills/workstack-resume/agents/openai.yaml"

[ -f "$skill" ] || { echo "not ok - skill file missing: $skill" >&2; exit 1; }

assert_contains "$skill" "name: workstack-resume" "frontmatter name"
assert_contains "$skill" "I'm using workstack-resume; discovering state before acting." "announce line"
assert_contains "$skill" "The durable record is the state; you are replaceable." "replaceable-orchestrator stance"
assert_contains "$skill" "Never trust conversation memory." "discovery over memory"
assert_contains "$skill" "merged commits and current PR head state" "authority order: commits first"
assert_contains "$skill" "conversation memory last" "authority order: memory last"
assert_contains "$skill" "reconcile the less authoritative source before dispatching work" "reconciliation rule"
assert_contains "$skill" "Write every state transition to the ledger before acting on it." "ledger-before-action"
assert_contains "$skill" "living-plan-format.md" "format doc referenced"
assert_contains "$skill" "plan-authoring.md" "authoring doc referenced"
assert_contains "$skill" "Approved spec, no living plan" "row: spec only"
assert_contains "$skill" "naming \`workstack-resume\` as the continuation" "plan-writing continuation declared"
assert_contains "$skill" "Plan with a due planning checkpoint" "row: checkpoint"
assert_contains "$skill" "Ready slice, not started" "row: ready"
assert_contains "$skill" "stating the worktree decision up front" "worktree consent pre-empted"
assert_contains "$skill" "mark slice tickets in progress in one Linear operation" "slice-start Linear op"
assert_contains "$skill" "Active slice, task incomplete" "row: mid-task"
assert_contains "$skill" "never redispatched" "idempotent task resume"
assert_contains "$skill" "Task reviews clean, gate not passed" "row: gated pending"
assert_contains "$skill" "Recover \`REVIEW_HEAD\` from the ledger, never memory." "gate head recovery"
assert_contains "$skill" "Gated, no PR" "row: gated"
assert_contains "$skill" "declaring the pull-request completion route" "completion contract declared"
assert_contains "$skill" "monitored, never recreated" "idempotent PR handling"
assert_contains "$skill" "reconciled, never reopened" "idempotent merge handling"
assert_contains "$skill" "advance newly unblocked slices to ready" "post-merge advancement"
assert_contains "$skill" "prune or transfer any owned contract exactly once" "closeout prune"
assert_contains "$skill" "Nothing matches" "row: inconsistent state"
assert_contains "$skill" "Continue through merge and reconciliation" "default continuation depth"
assert_contains "$skill" "never per task or review round" "coarse Linear"
assert_contains "$skill" "One slice, one gate, one PR. Inner-loop execution stays sequential." "core invariants"
assert_before "$skill" "## 1. Discover state" "## 2. Dispatch table" "discovery precedes dispatch"
assert_no_model_names "$skill"

[ -f "$metadata" ] || { echo "not ok - committed OpenAI metadata missing" >&2; exit 1; }
grep -Fq "display_name" "$metadata" || { echo "not ok - metadata lacks display_name" >&2; exit 1; }
echo "ok - committed OpenAI metadata present"

echo "PASS"
```

- [ ] **Step 2: Run it to verify it fails** — expect `not ok - skill file missing`, exit 1.

- [ ] **Step 3: Write the skill** at `skills/workstack-resume/SKILL.md` with exactly this content:

```markdown
---
name: workstack-resume
description: Use when an approved specification or living plan already exists - including after compaction, a stopped session, or a merged slice. Public WorkStack entry point that discovers durable state and performs the next valid transition until the selected frontier is merged and reconciled.
---

# WorkStack Resume

**Announce:** "I'm using workstack-resume; discovering state before acting."

**Entry:** an approved specification or an active living plan.
**Exit:** the selected frontier merged and reconciled, or a genuine block: a missing product decision, an unresolved destructive conflict, missing authority, or an external gate that cannot progress.

The durable record is the state; you are replaceable. A fresh orchestrator must reach the same next action from the files alone. Plan structure, slice states, gates, and the ledger format are defined in this skill's `living-plan-format.md`.

## 1. Discover state

Never trust conversation memory. Read the durable sources in authority order: merged commits and current PR head state; the living plan's slice index and any active contract; the worktree-local progress ledger; task reports and review packages; Git history on the slice branch; Linear status for coarse outcome state; conversation memory last. When sources disagree, reconcile the less authoritative source before dispatching work. Write every state transition to the ledger before acting on it.

## 2. Dispatch table

Act on the first row matching the discovered state, then rediscover and repeat.

| Observed state | Transition |
|---|---|
| Approved spec, no living plan | Create or reconcile Linear tickets in one batched operation. Invoke superpowers:writing-plans naming `workstack-resume` as the continuation, with this skill's `plan-authoring.md` and `living-plan-format.md` named in the prompt. Obtain your human partner's approval of the initial plan. |
| Plan with a due planning checkpoint | Confirm prerequisite slices merged; sync to the current base head; re-explore the checkpoint's named surfaces and contracts; detail the new ready frontier in the same plan; self-review it. Pause for approval only when product behavior, acceptance criteria, ticket scope, or an approved cross-slice interface changed. |
| Ready slice, not started | Preflight: resolve every required role via workstack-agent-routing (fail closed on reviewer independence); sync the slice base; create an isolated worktree with superpowers:using-git-worktrees, stating the worktree decision up front; apply the project's worktree rules; write the uncommitted worktree context pointer; initialize the ledger; mark slice tickets in progress in one Linear operation. Then execute the slice's tasks with superpowers:subagent-driven-development. |
| Active slice, task incomplete | A task marked complete in the ledger with matching commits is never redispatched. Resume the interrupted task from its ledger row, brief, and commits. |
| Task reviews clean, gate not passed | Run workstack-ux-gate when the slice requires it, then workstack-slice-gate. Recover `REVIEW_HEAD` from the ledger, never memory. |
| Gated, no PR | Complete the branch with superpowers:finishing-a-development-branch, declaring the pull-request completion route and the project's target base branch, then hand the PR to workstack-pr-monitor. |
| PR open | An existing PR is monitored, never recreated: continue workstack-pr-monitor against its current head. |
| Merged, not reconciled | A merged PR is reconciled, never reopened: close slice tickets in one Linear operation; update or close any plan-owned contract whose prune trigger is satisfied; remove the worktree, branch, and ignored scratch; advance newly unblocked slices to ready. |
| All slices merged, plan still open | Closeout: verify no work remains; prune or transfer any owned contract exactly once; remove the living plan from the current tree by coordination commit; report completion evidence. |
| Nothing matches | The state is inconsistent. Reconcile per the authority order; if a genuine product decision, destructive conflict, or missing authority remains, stop and present it to your human partner. |

## Rules

- Continue through merge and reconciliation for the selected frontier unless your human partner requested a narrower stop.
- Coarse Linear only: tickets change at creation or material scope change, slice start, and merge or cancellation — never per task or review round.
- One slice, one gate, one PR. Inner-loop execution stays sequential.
```

- [ ] **Step 4: Write the metadata** at `skills/workstack-resume/agents/openai.yaml`:

```yaml
interface:
  display_name: "WorkStack Resume"
  short_description: "Discover durable state and perform the next valid transition"
  default_prompt: "Use $workstack-resume to continue this work from its durable state."
```

- [ ] **Step 5: Run the test to verify it passes** — final `PASS`, exit 0.
- [ ] **Step 6: Run the neighboring tests** — `bash tests/workstack/test-plan-docs.sh && bash tests/workstack/test-quick-task.sh && bash tests/workstack/test-start.sh && bash tests/workstack/test-completion-contract.sh`; `PASS` from each.
- [ ] **Step 7: Commit** — `git add skills/workstack-resume tests/workstack/test-resume.sh && git commit -m "add workstack-resume public entry point"`

### Task 19: Package the S4 skills and re-verify the workflow summary

**Files:**

- Modify: `tests/codex/test-package-codex-plugin.sh` (the S3 `for ws_skill in …` loop)
- Inspect: `workstack/AGENTS-SNIPPET.md` (change only if it misdescribes shipped behavior)

**Interfaces:**

- Consumes: the S1 packaging rule (committed `agents/openai.yaml` first) and the S3 packaging loop.
- Produces: Codex packages containing all seven `workstack-*` skills plus the two `workstack-resume` reference docs.

- [ ] **Step 1: Extend the packaging loop.** Change the S3 loop list to `workstack-quick-task workstack-pr-monitor workstack-ux-gate workstack-start workstack-resume workstack-spec-review workstack-slice-gate`, and after the loop add:

```bash
assert_contains "$archive_paths" "skills/workstack-resume/living-plan-format.md" "archive includes living-plan format doc"
assert_contains "$archive_paths" "skills/workstack-resume/plan-authoring.md" "archive includes plan-authoring doc"
```

- [ ] **Step 2: Run `bash tests/codex/test-package-codex-plugin.sh`** — exit 0. Fix only within the S1 metadata-precedence behavior if an assertion fails.
- [ ] **Step 3: Re-read `workstack/AGENTS-SNIPPET.md`.** The three entry points and the two paragraphs must still describe shipped behavior; S4 adds no fourth entry point and must not require a third paragraph. Expected: no change needed. If a change is needed, keep `bash tests/workstack/test-workflow-summary.sh` green.
- [ ] **Step 4: Run the full suite** — every `tests/workstack/test-*.sh`, `bash tests/codex/test-package-codex-plugin.sh`, `bash tests/codex/test-marketplace-manifest.sh`, `bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh`, `bash tests/claude-code/test-sdd-workspace.sh`, `python3 scripts/check-workstack-divergences.py`; all `PASS`/exit 0.
- [ ] **Step 5: Commit** — `git add tests/codex/test-package-codex-plugin.sh && git commit -m "package S4 workstack skills"`

### S4 Slice Verification and Gate

- [ ] Record the slice base SHA before Task 14 begins.
- [ ] Run the five new tests (`test-spec-review.sh`, `test-slice-gate.sh`, `test-start.sh`, `test-plan-docs.sh`, `test-resume.sh`) and the full pre-existing suite; all `PASS`/exit 0.
- [ ] Run `python3 scripts/check-workstack-divergences.py`; expect no new core divergences.
- [ ] Generate one review package from the slice base through current HEAD and dispatch an independent final-gate reviewer (spec, this slice section, verification log, diff package by path); fix the complete finding set and resume the same reviewer until it approves the current head.
- [ ] Open exactly one PR for S4 and merge only its reviewed head — unless the user again authorizes direct commits, in which case record that decision in the Decision Log as with S2/S3.

---

## Ready Slice S5 — Parallel Delivery Contracts (was Checkpoint C5)

**Planning note (2026-07-19):** Detailed by user direction; the "one sequential slice end-to-end" trigger is demoted to S6 pilot evidence. Planned against spec §14/§15 (digested with citations) and the transitional `workstack-batch-plan`/`workstack-shepherd-phase` lane rules. FSMCRM-specific lane mechanics (port math, Prisma migration slots, compose project names) stay in FSMCRM's `AGENTS.md` worktree rules — the fork doc references "the project's worktree rules" generically.

**Execution precondition:** S4 merged. Before Task 20 dispatch, re-verify `skills/workstack-resume/SKILL.md` landed with the Task 18 dispatch-table format unchanged.

**Goal:** Add the parallel-slice capability: one canonical active-contracts/parallel-eligibility reference doc and the `workstack-resume` dispatch rows that use it — keeping parallelism strictly between independent slices in separate worktrees, with the contract owned and pruned by exactly one orchestrator.

**Acceptance signals:**

- The contract lifecycle (when to create, required fields, sole-writer ownership, prune trigger, stale audit) is defined once, in `skills/workstack-resume/active-contracts.md`.
- Parallel eligibility is a written checklist ("disjoint write sets, verified, not assumed"; frozen interfaces; explicit migration ownership and merge order; isolated runtime resources; independent gate/merge), with sequential as the default on any doubt and at most two concurrent code-bearing slices by default.
- `dispatching-parallel-agents` is scoped in WorkStack text to read-only exploration fan-out and independent contract-covered slices only (per the Instructional-Conflict Register).
- A contract is never deleted from branch/worktree age alone; a plan cannot close while it owns a binding contract.

### Task 20: Add the active-contracts and parallel-eligibility reference doc

**Files:**

- Create: `skills/workstack-resume/active-contracts.md`
- Create: `tests/workstack/test-active-contracts.sh`

**Interfaces:**

- Consumes: spec §14 (parallel delivery), §15 (contract lifecycle), §5.6/§5.12 invariants; the Instructional-Conflict Register's `dispatching-parallel-agents` scoping.
- Produces: the canonical contract/parallel doc Task 21's dispatch rows cite by filename.

- [ ] **Step 1: Write the failing test** at `tests/workstack/test-active-contracts.sh` (mark executable). Start from the committed `tests/workstack/test-pr-monitor.sh` helpers (verbatim), then continue with:

```bash
doc="$repo_root/skills/workstack-resume/active-contracts.md"
[ -f "$doc" ] || { echo "not ok - active-contracts.md missing" >&2; exit 1; }

assert_contains "$doc" "at most one active contract" "one contract per plan"
assert_contains "$doc" "Independent work with no coordination risk creates no contract." "no gratuitous contracts"
assert_contains "$doc" "docs/active-contracts/<plan-slug>.md" "contract location"
assert_contains "$doc" "Exact prune trigger" "prune trigger field"
assert_contains "$doc" "sole writer" "sole-writer ownership"
assert_contains "$doc" "lanes never author or edit contracts" "read-only for lanes"
assert_contains "$doc" "verify no prior owner is live, record the ownership transfer" "restart ownership transfer"
assert_contains "$doc" "disjoint write sets, verified, not assumed" "eligibility: disjoint writes"
assert_contains "$doc" "frozen or has one declared producer" "eligibility: frozen interfaces"
assert_contains "$doc" "migration ownership and merge order are explicit" "eligibility: migrations"
assert_contains "$doc" "not reused until a lane retires" "eligibility: resource reservation"
assert_contains "$doc" "Any claim you cannot make confidently means sequential." "sequential default"
assert_contains "$doc" "At most two concurrent code-bearing slices by default" "concurrency default"
assert_contains "$doc" "never a completion requirement" "parallelism optional"
assert_contains "$doc" "they never independently reinterpret the change" "consumer discipline"
assert_contains "$doc" "never create competing migrations" "migration exclusivity"
assert_contains "$doc" "every named consumer is merged, cancelled, or transferred" "prune condition"
assert_contains "$doc" "cannot close while it owns a binding contract" "plan-close guard"
assert_contains "$doc" "never from branch or worktree age alone" "no age-based deletion"
assert_contains "$doc" "may outlive its producer branch" "contract survives producer"
assert_contains "$doc" "read-only exploration fan-out and to independent contract-covered slices only" "dispatching-parallel-agents scoped"
assert_contains "$doc" "never a license for parallel implementation inside one slice" "no intra-slice parallelism"
assert_no_model_names "$doc"
echo "PASS"
```

- [ ] **Step 2: Run it to verify it fails** — expect `not ok - active-contracts.md missing`, exit 1.

- [ ] **Step 3: Write** `skills/workstack-resume/active-contracts.md` with exactly this content:

```markdown
# WorkStack Active Contracts and Parallel Slices

Canonical rules for running independent delivery slices in parallel and for the contract that coordinates them. Owned by `workstack-resume`; every other skill and agent treats contracts as read-only.

## When a contract exists

A living plan creates at most one active contract, and only when work reserves a shared or cross-cutting surface, changes an interface another active or planned slice consumes, owns a migration or data-model transition with external consumers, or must communicate a temporary compatibility rule across worktrees. Independent work with no coordination risk creates no contract.

## Contract file

Location: `docs/active-contracts/<plan-slug>.md`, committed to the base branch while binding. Required fields: Status and owning living plan · Owning orchestrator · Created and last-verified dates · Reserved surfaces · Frozen interface or single-producer decision · Producer and consumer ticket IDs · Active branches, worktrees, and PRs when known · Migration ownership and ordering when applicable · Coordination rules · Exact prune trigger · Final closeout owner.

## Ownership

The one active top-level resume orchestrator is the contract's sole writer. Slice orchestrators, implementers, reviewers, and monitors read it and report proposed changes to the owner; lanes never author or edit contracts. After a restart, verify no prior owner is live, record the ownership transfer, and become sole writer. Update the contract before authorizing work that would violate or change it.

## Parallel eligibility

Slices run in parallel only when the orchestrator can state, in writing, all of: neither depends on unmerged behavior from the other; primary file and ownership surfaces do not overlap — parallel means disjoint write sets, verified, not assumed; any shared interface is frozen or has one declared producer; migration ownership and merge order are explicit; isolated runtime resources (ports, databases) are reserved per the project's worktree rules and not reused until a lane retires; each slice can independently pass its tests, gate, and merge. Any claim you cannot make confidently means sequential. At most two concurrent code-bearing slices by default; project configuration may change this without editing skills. Parallelism is an optimization, never a completion requirement.

## Conflict graph and merge order

The living plan records, for the ready frontier: slice dependencies, overlapping surfaces, producer/consumer relationships, and the required merge order. When a producer changes a frozen interface, consumer work pauses until the contract and plan are updated; consumers rebase or re-plan after the producer merges — they never independently reinterpret the change. One slice owns a schema or migration sequence at a time; parallel lanes never create competing migrations or edit the same shared schema assuming Git resolves the semantic conflict.

## Pruning and the stale audit

Every plan that opens a contract carries an explicit closeout condition. The owner deletes the contract only when its prune trigger is satisfied and every named consumer is merged, cancelled, or transferred; a plan cannot close while it owns a binding contract. Scan active contracts before any shared-surface planning. An audit may update stale operational references, but deletes a contract only when trigger and consumer state prove it obsolete — never from branch or worktree age alone; a contract may outlive its producer branch while consumers remain active.

## Scope of dispatching-parallel-agents

superpowers:dispatching-parallel-agents applies to read-only exploration fan-out and to independent contract-covered slices only. It is never a license for parallel implementation inside one slice; inner-loop execution stays sequential, and two agents never edit the same slice worktree concurrently.
```

- [ ] **Step 4: Run the test to verify it passes** — final `PASS`, exit 0.
- [ ] **Step 5: Commit** — `git add skills/workstack-resume/active-contracts.md tests/workstack/test-active-contracts.sh && git commit -m "add active-contracts and parallel-eligibility reference doc"`

### Task 21: Add the parallel dispatch rows to workstack-resume

**Files:**

- Modify: `skills/workstack-resume/SKILL.md`
- Modify: `tests/workstack/test-resume.sh`
- Modify: `tests/codex/test-package-codex-plugin.sh`

**Interfaces:**

- Consumes: Task 20's `active-contracts.md`; the Task 18 dispatch-table format.
- Produces: the parallel-capable `workstack-resume`. Change only what these steps name; the S4 rows and their tested sentences must remain byte-identical.

- [ ] **Step 1: Extend the test.** Append to `tests/workstack/test-resume.sh` (before `echo "PASS"`):

```bash
assert_contains "$skill" "scan \`docs/active-contracts/\`" "discovery scans contracts"
assert_contains "$skill" "Two or more ready slices, eligibility claims all pass" "row: parallel frontier"
assert_contains "$skill" "active-contracts.md" "contract doc referenced"
assert_contains "$skill" "its own sequential slice loop in its own worktree" "parallel isolation"
assert_contains "$skill" "Overlap or doubt means sequential." "sequential default"
```

- [ ] **Step 2: Run it to verify it fails** — expect the first new assertion to fail.

- [ ] **Step 3: Edit the skill.** In `skills/workstack-resume/SKILL.md`: (a) in `## 1. Discover state`, extend the sentence beginning "Read the durable sources" so the plan/contract source reads "the living plan's slice index and any active contract (scan `docs/active-contracts/` before any shared-surface planning)"; (b) insert this row immediately after the `Ready slice, not started` row:

```markdown
| Two or more ready slices, eligibility claims all pass | Verify or create the plan's single contract per this skill's `active-contracts.md`, then run each slice as its own sequential slice loop in its own worktree — at most two concurrent code-bearing slices by default. Overlap or doubt means sequential. |
```

Change nothing else in the file.

- [ ] **Step 4: Add the packaging assertion.** In `tests/codex/test-package-codex-plugin.sh`, beside the Task 19 doc assertions add:

```bash
assert_contains "$archive_paths" "skills/workstack-resume/active-contracts.md" "archive includes active-contracts doc"
```

- [ ] **Step 5: Run** `bash tests/workstack/test-resume.sh && bash tests/workstack/test-active-contracts.sh && bash tests/codex/test-package-codex-plugin.sh` — all `PASS`/exit 0.
- [ ] **Step 6: Commit** — `git add skills/workstack-resume/SKILL.md tests/workstack/test-resume.sh tests/codex/test-package-codex-plugin.sh && git commit -m "add parallel-slice dispatch to workstack-resume"`

### S5 Slice Verification and Gate

- [ ] Record the slice base SHA before Task 20 begins.
- [ ] Run the full `tests/workstack/` suite, the packaging/manifest/sync tests, and `python3 scripts/check-workstack-divergences.py`; all `PASS`/exit 0.
- [ ] Confirm `workstack/AGENTS-SNIPPET.md` still holds at two paragraphs (its parallel sentence already exists; no edit expected).
- [ ] Independent final-gate review of the whole-slice diff, closed to approval of the current head; then one PR (or user-authorized direct commits, recorded in the Decision Log).

---

## Ready Slice S6 — Cutover, Pilots, and Closeout (was Checkpoint C6)

**Planning note (2026-07-19):** Detailed by user direction. FSMCRM state re-explored 2026-07-19: `4787cf51` is FSMCRM's HEAD (no skill changes since); the transitional set is 11 `workstack-*` skills byte-mirrored in `.claude/skills/` and `.codex/skills/`; the fork's 15 skills are installed in `.agents/skills/` and `.claude/skills/`; confirmed parity gaps — `workstack-agent-routing` and all fork skills absent from `.codex/skills/`, and an empty stray `pr-monitor/` directory exists in **both** mirrors. Name collisions at refresh: exactly `workstack-quick-task`, `workstack-ux-gate`, `workstack-pr-monitor`.

**Execution precondition:** S4 and S5 merged. Tasks 22–26 run in the FSMCRM checkout (`~/projects/fsmcrm`, base branch `develop`) under FSMCRM's own commit conventions; Task 27 spans both repos. Before Task 22 dispatch, re-verify FSMCRM's skill directories and `AGENTS.md` against the state above and preserve any unrelated user work.

**Goal:** Cut FSMCRM over to the fork workflow, prove it with the spec §22 pilots while the transitional skills still exist as a fallback, and then close out: remove the transitional set, reconcile Linear, document upstream updates, and verify the spec §23 definition of done.

**Acceptance signals:**

- All three harness skill directories carry the fork set (minus `executing-plans`), the entry points trigger from clean Claude Code and Codex sessions, and the transitional skills survive—renamed where colliding—until pilots pass.
- Provider mechanics live in `.workstack/pr-policy.md` and model names in `.workstack/agents.json`; no FSMCRM skill or `AGENTS.md` section carries a concrete model name for review routing.
- FSMCRM `AGENTS.md` explains the workflow in the two `AGENTS-SNIPPET.md` paragraphs plus the three entry points, and retains Testing Judgment, the worktree rules, the precedence ladder, the reviewer-only `docs/REVIEW-GUIDANCE.md` label, and the "human partner = dispatching orchestrator" clarification.
- The three pilots (§22.1 quick task; §22.3 sequential multi-ticket with a materialized checkpoint and a §22.7 kill-and-resume probe; §22.5 parallel slices under one §22.6-style contract, pruned per §22.10) pass with recorded evidence.
- After removal, no `workstack-*` skill exists in FSMCRM outside the fork-installed set; the spec §23 twelve conditions are verified with evidence pointers.

### Task 22: Refresh the FSMCRM install and resolve collisions (FSMCRM repo)

- [ ] Rename the three colliding transitional skills in **both** mirrors (`.claude/skills/` and `.codex/skills/`) from `workstack-{quick-task,ux-gate,pr-monitor}` to `legacy-workstack-*`; update each frontmatter `name:` to match and prepend one line to the description: "Transitional fallback retained through the S6 pilots; prefer the workstack-* replacement." Update any references in FSMCRM `AGENTS.md` and the other transitional skills.
- [ ] Delete the stray empty `pr-monitor/` directory from both mirrors.
- [ ] Refresh the project-local install with an explicit skill list applying the register's exclusion — every fork skill except `executing-plans` — for both agents: `npx -y skills@latest add mlk1278/superpowers-workstack --skill <each-name> --agent claude-code --agent codex --yes`.
- [ ] Verify: `skills-lock.json` lists the expected set; `.agents/skills/`, `.claude/skills/`, and `.codex/skills/` each contain the fork set including `workstack-agent-routing` and the four S4 skills; `executing-plans` is absent from all three; the eight non-colliding transitional skills and the three `legacy-workstack-*` fallbacks are untouched.
- [ ] Commit in FSMCRM per its conventions.

### Task 23: Add FSMCRM project configuration (FSMCRM repo)

- [ ] Write `.workstack/agents.json` porting `docs/SUBAGENT-ROUTING.md`'s ladder into roles, reviewer specialties (including `ux` → a vision-capable route and `final-gate`), and ordered fallbacks. Concrete model names appear only here. Validate every role plus reviewer independence with `skills/workstack-agent-routing/scripts/resolve-agent` (each role; reviewer with `--author-model` set to the implementer route's model must resolve independent, or fail closed).
- [ ] Write `.workstack/pr-policy.md` porting the transitional `workstack-pr-monitor`'s mechanics: provider names and request order (Codex Cloud auto-review; CodeRabbit for medium/high/sensitive), the helper-script commands (`scripts/agents/fetch-pr-feedback.py`, `scripts/agents/request-pr-review.py`, `scripts/ci/watch-pr-checks.sh`) with their exit-code map (0 green, 1 failed, 2 unavailable-fail-closed, 4 pending) and the PAT/`gh pr checks` caveat, the 180-second poll interval and 60-minute single-head fallback, the `!simple` lane definition with its full reserved-exclusion list, "repository auto-merge is not enabled", and `develop` as the target base branch.
- [ ] Diff-review the fork `workstack-pr-monitor` + policy file pair against the transitional skill line by line; any transitional rule not yet covered becomes a policy line, never a fork-skill edit.
- [ ] Commit in FSMCRM.

### Task 24: Rewrite FSMCRM AGENTS.md (FSMCRM repo)

- [ ] Replace the "Feature Workflow" section (the transitional skill-chain paragraph) with the current contents of the fork's `workstack/AGENTS-SNIPPET.md` — two paragraphs plus the three entry points, verbatim.
- [ ] Retain unchanged: the behavioral sections (Think Before Coding … Goal-Driven Execution), Task Scope Discipline, Read First/Core Docs, Non-Negotiables, Worktrees (including port math and the `DB_PORT` gotcha), Exploration Standard, Testing Judgment, Progress/Ticket Tracking, Dev Commands, docs/tech-debt sections, and the `.environment/` restriction.
- [ ] Keep the Review-ownership invariant sentence ("code is always reviewed by a model different from the one that wrote it") but move its concrete model mapping to `.workstack/agents.json`, leaving a pointer.
- [ ] Add two clauses: `docs/REVIEW-GUIDANCE.md` is reviewer-only — no non-review role may load it; and in dispatched subagents, "your human partner" means the dispatching orchestrator.
- [ ] Verify the workflow explanation fits two paragraphs plus the entry points; if it cannot, redesign the capability, not the summary. Commit in FSMCRM.

### Task 25: Prove the entry points from clean sessions (FSMCRM repo)

- [ ] From a clean Claude Code session and a clean Codex session, run three prompts: a small decision-complete fix ("…use workstack-quick-task"), an ambiguous feature idea ("…use workstack-start"), and a resume against the pilot plan state ("…use workstack-resume"). Verify each announces its skill, resolves routes via `resolve-agent`, and no transitional/`legacy-workstack-*` skill triggers instead.
- [ ] Record one verdict file per session/prompt under FSMCRM's ignored `.superpowers/evals/`, including the routing-thrash observation (did `brainstorming`/`using-superpowers` greedy triggers divert the entry point?) feeding the Instructional-Conflict Register's revisit decision.

### Task 26: Run the pilots (FSMCRM repo; transitional fallbacks still present)

- [ ] **Pilot A — quick task (§22.1):** one real small change through `workstack-quick-task` to merged PR and cleanup. This also supplies the fresh-agent seam evidence deferred from S3 Task 13.
- [ ] **Pilot B — sequential multi-ticket (§22.3 + §22.7):** one real small feature through `workstack-start` → spec approval → `workstack-resume` → tickets, living plan with at least one deferred checkpoint → first slice merged → checkpoint materialized → second slice merged. Mid-slice, deliberately kill the session and resume from durable state: no completed task redispatched, no PR recreated.
- [ ] **Pilot C — parallel slices (§22.5/§22.6/§22.10):** two genuinely independent slices under the plan's single contract, run in separate worktrees with reserved resources, merged in declared order, contract pruned exactly once at closeout.
- [ ] Record pass/fail evidence per pilot under `.superpowers/evals/`; failures produce fixes (fork or config per the register's levers) and pilot reruns until pass. Decide the greedy-trigger register revisits (divergence or leave-as-is) from the accumulated observations and record the decision in this plan's Decision Log.

### Task 27: Remove the transitional set and close out (both repos)

- [ ] FSMCRM: delete the eight remaining transitional `workstack-*` skills and the three `legacy-workstack-*` fallbacks from both mirrors (support skills like `linear-cli`, `playwright-cli`, `create-github-pr`, `update-user-docs` stay — they are project tooling, not workflow); verify no `workstack-*` skill exists outside the fork-installed set.
- [ ] FSMCRM: reconcile any Linear projects still structured by phases at coarse granularity; close or relabel stale phase tickets in batched operations.
- [ ] Fork: fix any specification gaps the pilots exposed (spec edits with user approval where behavior changed); update this plan's Decision Log.
- [ ] Fork: write `workstack/UPSTREAM-UPDATES.md` — the upstream-update procedure: fetch upstream, merge the release tag, run `python3 scripts/check-workstack-divergences.py`, re-run the full test suite, re-apply/re-approve the divergence allowlist when a seam no longer applies. Add a `tests/workstack/test-upstream-updates-doc.sh` asserting the doc exists and names the divergence check and full-suite steps. Commit.
- [ ] Both: close contracts, prune pilot plans and worktrees, and run one final conflict scan of FSMCRM's installed skill set against the Instructional-Conflict Register — every absolute in installed text has a recorded resolution.
- [ ] Verify the spec §23 definition of done: all twelve conditions with an evidence pointer each, recorded in this plan. Only then does this plan proceed to its Final Closeout Conditions below.

### S6 Slice Verification and Gate

- [ ] Fork-side changes gated as usual: full suite green, independent final-gate review closed on the current head, one PR (or user-authorized direct commits, recorded).
- [ ] FSMCRM-side changes reviewed under FSMCRM's own review-ownership rules; pilots themselves are the behavioral gate for this slice.
- [ ] The §23 twelve-condition checklist is the slice's exit criterion; an unmet condition reopens the owning task rather than shipping around it.

## Final Closeout Conditions

- All specification definition-of-done checks pass.
- Every delivery PR is merged at its independently reviewed head.
- Linear is reconciled only for real assigned tickets.
- No active contract, branch, worktree, monitor, or ignored run artifact remains without an owner.
- This living plan is removed from the current tree by a coordination commit after S6; Git history remains the record.
