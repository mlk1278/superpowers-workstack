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

Never trust conversation memory. Read the durable sources in authority order: merged commits and current PR head state; the living plan's slice index and any active contract (scan `docs/active-contracts/` before any shared-surface planning); the worktree-local progress ledger; task reports and review packages; Git history on the slice branch; Linear status for coarse outcome state; conversation memory last. When sources disagree, reconcile the less authoritative source before dispatching work. Write every state transition to the ledger before acting on it.

## 2. Dispatch table

Act on the first row matching the discovered state, then rediscover and repeat.

| Observed state | Transition |
|---|---|
| Approved spec, no living plan | Create or reconcile Linear tickets in one batched operation. Invoke superpowers:writing-plans naming `workstack-resume` as the continuation, with this skill's `plan-authoring.md` and `living-plan-format.md` named in the prompt. Obtain your human partner's approval of the initial plan. |
| Plan with a due planning checkpoint | Confirm prerequisite slices merged; sync to the current base head; re-explore the checkpoint's named surfaces and contracts; detail the new ready frontier in the same plan; self-review it. Pause for approval only when product behavior, acceptance criteria, ticket scope, or an approved cross-slice interface changed. |
| Ready slice, not started | Preflight: resolve every required role via workstack-agent-routing (fail closed on reviewer independence); sync the slice base; create an isolated worktree with superpowers:using-git-worktrees, stating the worktree decision up front; apply the project's worktree rules; write the uncommitted worktree context pointer; initialize the ledger; mark slice tickets in progress in one Linear operation. Then execute the slice's tasks with superpowers:subagent-driven-development. |
| Two or more ready slices, eligibility claims all pass | Verify or create the plan's single contract per this skill's `active-contracts.md`, then run each slice as its own sequential slice loop in its own worktree — at most two concurrent code-bearing slices by default. Overlap or doubt means sequential. |
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
