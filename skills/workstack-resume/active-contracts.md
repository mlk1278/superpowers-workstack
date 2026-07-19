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
