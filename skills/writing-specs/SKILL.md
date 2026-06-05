---
name: writing-specs
description: Use when a brainstormed feature, workflow, UX change, or technical design needs a compact written spec before implementation planning
---

# Writing Specs

Turn an approved design into a short, decision-complete spec that is ready for implementation planning. A spec is not an implementation plan; it records what will be built, why, key decisions, boundaries, and acceptance signals.

**Announce at start:** "I'm using the writing-specs skill to write the implementation-ready spec."

## When To Use

Use this skill after brainstorming when any of these are true:

- The work spans multiple files, layers, pages, or workflows.
- The user and agent made design/product/architecture decisions that future planning must preserve.
- The feature has UX, API, data, auth, tenancy, lifecycle, payment/document, or other boundary implications.
- The next step is `superpowers:writing-plans`.

Skip a saved spec for narrow, low-risk work with clear acceptance criteria. Use the lightweight execution path in `superpowers:subagent-driven-development` instead.

## Inputs

- Approved design from `superpowers:brainstorming`.
- Relevant repo facts discovered during brainstorming.
- Linear decision if one exists. If no Linear ticket is mentioned, follow the Linear Intake section before saving.
- Worktree/branch metadata if implementation will follow.

## Linear Intake

If the user request does not mention a Linear ticket:

1. Dispatch a low-effort Linear helper to search the backlog for likely related tickets. The orchestrator decides the search terms and scope.
2. Ask the user with the concrete candidates: use one, create a new ticket, or skip Linear for this work.
3. If a ticket is selected or created, move it to In Progress and record the planned branch/worktree once created.

The orchestrator owns the decision. The helper only runs Linear CLI/API commands and returns identifiers, titles, URLs, and short relevance notes.

## Spec Shape

Save substantial specs to `docs/superpowers/specs/YYYY-MM-DD-<ticket-or-topic>-spec.md` unless the user or repo convention says otherwise.

Use this structure and keep it concise:

```markdown
# <Feature Name> Spec

**Status:** Draft | Reviewed | Approved
**Linear:** <ISSUE-ID and URL, or "None">
**Branch / Worktree:** <planned or actual branch/worktree, or "TBD before planning">

## Goal
One paragraph describing the outcome and user/business value.

## Context
Repo facts, existing owners, relevant constraints, and current behavior. Include only what planning needs.

## Decisions
- Decision: <chosen behavior/approach>
- Rationale: <why>

## Requirements
- <observable behavior, contract, or UX requirement>

## Non-Goals
- <explicitly excluded work>

## UX / API / Data Notes
Only include sections that apply. Name affected pages, endpoints, schemas, lifecycle rules, auth/tenant boundaries, or visual assets.

## Acceptance Signals
- <manual or automated signal that the implementation is correct>

## Planning Notes
Risks, likely task boundaries, exploration commands to rerun, and anything the implementation plan must not miss.
```

## Spec Quality Bar

- Keep it short enough to read before planning. Prefer 1-4 pages, not exhaustive implementation detail.
- Make requirements unambiguous. If two interpretations are plausible, choose one and write it down.
- Preserve canonical ownership decisions: backend authority, frontend preview-only behavior, shared schemas, tenant/lifecycle boundaries, and existing components/services to reuse.
- Include UX page/surface inventory for frontend work: pages involved, major states, existing layout/template to follow or reason for a new one, and visual assets if any.
- Do not include step-by-step implementation tasks, file-by-file recipes, or full test commands. That belongs in `writing-plans`.

## Mandatory Spec Review

Every saved spec requires a spec document reviewer before planning.

1. Run the self-review checklist below.
2. Dispatch a spec reviewer using `./spec-document-reviewer-prompt.md`.
3. Fix blocking issues in the spec.
4. Repeat until the reviewer reports `Approved`.
5. Ask the user to approve the reviewed spec before writing the implementation plan, unless they explicitly delegated approval.

## Self-Review

- Placeholder scan: no `TBD`, `TODO`, vague "handle edge cases", or unfinished sections.
- Consistency: decisions, requirements, and non-goals do not contradict each other.
- Scope: one implementation plan can build this. Split independent subsystems into separate specs.
- Boundary clarity: auth, tenant/data access, public routes, lifecycle, API contracts, and canonical owners are explicit when relevant.
- Planning readiness: the next planner can identify task groups, risks, and required exploration without guessing.

## Handoff

After spec approval:

- For non-trivial work, invoke `superpowers:using-git-worktrees` before implementation planning so the plan is written in the ticket-linked branch/worktree.
- Ensure Linear/worktree metadata is current in the spec before planning starts.
- Invoke `superpowers:writing-plans`.
- Tell the user: "Spec reviewed and approved at `<path>`. Next step is implementation planning; the plan will need your approval before execution."
