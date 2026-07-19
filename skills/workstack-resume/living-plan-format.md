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
