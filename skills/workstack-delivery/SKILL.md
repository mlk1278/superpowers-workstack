---
name: workstack-delivery
description: Use when an approved implementation plan is ready to be implemented and shipped.
---

# WorkStack Delivery

**Announce:** "I'm using workstack-delivery to deliver this approved plan."

**Entry:** an approved implementation plan.
**Exit:** one coherent delivery slice merged, reconciled when applicable, and cleaned up.

## 1. Read and select

Read the plan and select one coherent delivery slice that can ship in one PR. Do not redesign approved requirements. If the plan leaves a product decision unresolved, stop and return it to your human partner.

## 2. Resolve routes

Read the optional `## Agent Routing` section. It may name routes for the implementer, task reviewer, and final reviewer; the session agent remains the orchestrator and is never plan-routed. Resolve each role with workstack-agent-routing. Precedence is plan route, then project route, then bundled default. Resolve the monitor from project routing or the bundled default. Fail closed when either reviewer lacks an independent route.

## 3. Prepare and execute

Create an isolated worktree with superpowers:using-git-worktrees and apply the repository's worktree rules. Execute the slice with superpowers:subagent-driven-development, supplying the resolved routes. Keep its task briefs, implementation reports, review packages, task reviews, and fix loops unchanged.

## 4. Gate the slice

When the slice materially changes a user-visible surface, supply workstack-ux-gate as SDD's optional pre-final gate. It runs after task reviews and before SDD's broad final review.

That broad final review is the slice gate; do not add another whole-slice review.

## 5. Ship

After approval, invoke superpowers:finishing-a-development-branch with the pull-request completion route and target base branch declared. Hand the resulting PR to workstack-pr-monitor and wait until it reports the PR merged or genuinely blocked.

## 6. Reconcile and clean up

Reconcile Linear only when the plan is linked to Linear. After merge, confirm the remote state, then remove the worktree, branch, and ignored scratch. For interruption recovery, follow `workstack/WORKFLOW.md`; do not create separate resume bookkeeping.
