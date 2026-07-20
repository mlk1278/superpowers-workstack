# WorkStack Simplification Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reduce WorkStack to a thin delivery layer while preserving upstream Superpowers' proven implementation and file-handoff workflow.

**Architecture:** Restore unnecessary upstream divergences, consolidate the major workflow into one additive `workstack-delivery` skill plus one concise reference document, and keep only routing, quick-task, UX, PR monitoring, reviewer guidance, delta re-review, and declared branch completion. Tests should assert the smaller public surface and retained seams.

**Tech Stack:** Markdown skills, POSIX shell tests, Python 3 standard-library routing helper, Git.

## Global Constraints

- Do not modify or remove upstream's `review-package` file-bundle handoff.
- Do not add a replacement resume state machine.
- Keep the implementation smaller than the workflow it replaces.
- No new runtime dependencies.
- Do not modify FSMCRM in this plan.

---

### Task 1: Restore the upstream inner loop and retain only surgical seams

**Files:**
- Restore: `skills/brainstorming/SKILL.md`
- Restore: `skills/writing-plans/SKILL.md`
- Restore: `skills/subagent-driven-development/scripts/task-brief`
- Modify: `skills/subagent-driven-development/SKILL.md`
- Modify: `skills/subagent-driven-development/task-reviewer-prompt.md`
- Keep: `skills/requesting-code-review/SKILL.md`
- Keep: `skills/requesting-code-review/code-reviewer.md`
- Keep: `skills/finishing-a-development-branch/SKILL.md`
- Modify: `tests/claude-code/test-sdd-workspace.sh`
- Delete: `tests/workstack/test-continuation-seams.sh`
- Modify: `tests/workstack/test-final-review-gate.sh`
- Test: `tests/workstack/test-reviewer-context.sh`
- Test: `tests/workstack/test-completion-contract.sh`

**Interfaces:**
- Consumes: upstream v6.1.1 versions at commit `d884ae04edebef577e82ff7c4e143debd0bbec99`.
- Produces: upstream handoffs plus caller-provided routes, optional pre-final UX gate, reviewer guidance, and same-thread delta re-review.

- [ ] Restore the three unnecessary continuation/task-brief divergences exactly from the recorded upstream baseline.
- [ ] Replace the large exact-head final-gate machinery with a compact rule: broad final review still receives a `review-package`; one fixer handles findings; covering verification is reported; the same reviewer receives a `review-package` for the fix delta until approved.
- [ ] Add a short caller-routing precedence clause and an optional pre-final gate clause to SDD without changing its normal path.
- [ ] Preserve reviewer-only guidance in both task and final reviewer templates and preserve the declared completion route.
- [ ] Update focused tests to reject the removed seams and assert the retained behavior.
- [ ] Run the focused SDD, reviewer-context, and completion-contract tests.
- [ ] Commit the task.

### Task 2: Consolidate WorkStack into two public entry points

**Files:**
- Create: `skills/workstack-delivery/SKILL.md`
- Create: `skills/workstack-delivery/agents/openai.yaml`
- Create: `workstack/WORKFLOW.md`
- Modify: `skills/workstack-quick-task/SKILL.md`
- Modify: `skills/workstack-agent-routing/SKILL.md`
- Modify: `workstack/AGENTS-SNIPPET.md`
- Delete: `skills/workstack-start/`
- Delete: `skills/workstack-resume/`
- Delete: `skills/workstack-spec-review/`
- Delete: `skills/workstack-slice-gate/`
- Delete: `tests/workstack/test-start.sh`
- Delete: `tests/workstack/test-resume.sh`
- Delete: `tests/workstack/test-spec-review.sh`
- Delete: `tests/workstack/test-slice-gate.sh`
- Delete: `tests/workstack/test-active-contracts.sh`
- Delete: `tests/workstack/test-plan-docs.sh`
- Create: `tests/workstack/test-delivery.sh`
- Modify: `tests/workstack/test-quick-task.sh`
- Modify: `tests/workstack/test-workflow-summary.sh`

**Interfaces:**
- Consumes: approved implementation plans, optional `## Agent Routing`, project routing, SDD, UX gate, branch completion, and PR monitor.
- Produces: `workstack-delivery`, the major workflow from approved plan through merged PR and cleanup.

- [ ] Write `workstack/WORKFLOW.md` as the concise human-readable policy for upstream planning, slices, optional plan routing, delivery, recovery, and controller context discipline.
- [ ] Implement `workstack-delivery` as a thin sequencer over existing skills; SDD's broad final review is the slice gate.
- [ ] Point quick-task at the same delivery path after it creates its one-task mini-plan.
- [ ] Remove the four superseded skills and their dedicated state-machine tests.
- [ ] Update the summary to advertise only quick-task and delivery.
- [ ] Run the focused delivery, quick-task, UX, PR monitor, routing, and summary tests.
- [ ] Commit the task.

### Task 3: Reduce governance and packaging to the smaller surface

**Files:**
- Modify: `workstack/upstream-divergences.json`
- Modify: `workstack/UPSTREAM-UPDATES.md`
- Modify: `scripts/package-codex-plugin.sh` only if required by retained skill metadata behavior
- Modify: `tests/codex/test-package-codex-plugin.sh`
- Modify: `tests/workstack/test-upstream-divergences.sh`
- Modify: `tests/workstack/test-upstream-updates-doc.sh`
- Delete: `docs/superpowers/specs/2026-07-18-workstack-development-workflow-spec.md`

**Interfaces:**
- Consumes: the simplified skill set and recorded upstream baseline.
- Produces: an allowlist containing only intentional surgical divergences and a package containing only retained WorkStack skills.

- [ ] Remove obsolete divergence entries and references to deleted skills.
- [ ] Update package expectations for `workstack-delivery` and removal of the four superseded skills.
- [ ] Delete the superseded 950-line workflow specification; Git history remains the historical record.
- [ ] Run every remaining WorkStack test, the Codex packaging test, and the divergence checker.
- [ ] Review the final diff against upstream and confirm that `review-package` is unchanged.
- [ ] Commit the task and remove this implementation plan in the closeout commit.
