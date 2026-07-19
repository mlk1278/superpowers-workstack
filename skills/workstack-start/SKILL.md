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
