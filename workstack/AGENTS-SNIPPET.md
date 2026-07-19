# WorkStack Workflow Summary (draft — updated each slice)

Canonical draft of the two-paragraph workflow explanation destined for a consuming project's `AGENTS.md`. If a new capability cannot be described without a third paragraph or a fourth entry point, redesign the capability, not this summary.

WorkStack tracks durable product outcomes as Linear tickets but keeps implementation detail local. New or ambiguous work is shaped into an approved direction, expanded into a decision-complete specification, represented as tickets, and organized in one living implementation plan that fully details only the delivery slices that are ready to build.

Implementation happens one delivery slice at a time: a fresh implementer per task, one independent combined review per task, one whole-slice gate, and exactly one PR per slice, monitored through merge and reconciled in Linear. Independent slices may run in parallel worktrees under a lightweight active contract; everything inside a slice stays sequential.

Three entry points — enter at the first state you don't have:

- `workstack-quick-task`: a small decision-complete change, straight to one reviewed, merged PR.
- `workstack-start`: new or ambiguous work, through brainstorming to an approved spec and plan.
- `workstack-resume`: anything already specced or planned, through the next valid step to merge.
