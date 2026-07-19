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
