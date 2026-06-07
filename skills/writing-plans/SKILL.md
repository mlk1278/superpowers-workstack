---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY (for the code being built — **not for the plan itself; repeat context across tasks so each task is self-contained**). YAGNI. TDD. Frequent commits.

Assume the implementer is a **low-effort model on autopilot** — a developer who will execute steps mechanically and will not infer missing context, look up patterns, or recover gracefully from ambiguity. They know almost nothing about our toolset, problem domain, or good test design. The plan should make execution mechanical: every task should be actionable from its own contents without re-reading earlier tasks or hunting in the spec.

**Critical: implementers never read this plan file.** In `superpowers:subagent-driven-development`, the orchestrator extracts each task's text and pastes it (plus per-task context) into the implementer subagent's prompt. Anything that lives only in a top-level header — `## Source Material`, `## Background`, `## Architecture` prose, design-asset lists, screenshot paths, related spec sections — is **invisible to the implementer** unless it is also embedded in the task body that needs it. Plan accordingly: see "Tasks Are Self-Contained" below.

> **Note:** The actual implementer subagent in `superpowers:subagent-driven-development` runs at **medium** effort by default. Design the plan as if the implementer were low-effort anyway — that pressure is what produces verbose, well-scoped, mechanically-executable tasks. A plan that's good enough for a hypothetical low-effort implementer will sail through a real medium-effort one.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should run after `superpowers:writing-specs` for substantial work. Use the reviewed spec as the source of truth and create the implementation plan in the dedicated worktree/branch prepared for the ticket or feature.

**Save plans to:** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
- (User preferences for plan location override this default)

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

Before planning, confirm the spec was reviewed and approved. If the work has no saved spec because it is narrow/low-risk, use the lightweight execution path in `superpowers:subagent-driven-development` instead of writing a heavyweight plan.

## Exploration During Planning

Don't burn your own context on discovery work. When mapping the file structure, identifying targets for a sweep task, surveying existing patterns to follow, or assessing cross-cutting impact, **dispatch an exploration subagent** and feed the distilled results into your planning. Your context is for design and task decomposition; the subagent's context absorbs the raw file reads. Failing to do this produces context-rotted plans where the second half of the document is noticeably worse than the first.

The full pattern (when to dispatch, when to skip, how to prompt, effort level) lives in `superpowers:brainstorming` § Dispatching Exploration Subagents. That guidance applies verbatim during planning — re-read it if you haven't.

Use low effort for simple backlog/doc/file-list lookups and medium effort for codebase pattern surveys, sweep target enumeration, and cross-doc synthesis. High effort is reserved for rare exploration that requires architecture/security/data judgment.

This is especially important for sweep tasks (see "Sweep Tasks Need Enumeration"). The discovery command, enumerated target list, and "what's the existing pattern to follow" survey can all be produced by an exploration subagent and pasted into the task. The planner's job is to decide what counts as in-scope and to write down the completion predicate — not to read every file.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure - but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Tasks Are Self-Contained: Implementers Never Read The Plan

The plan file is a **planner/orchestrator document**, not an implementer document. Implementer subagents receive only the task text and per-task context that the orchestrator pastes into their prompt. They do not open the plan file. They do not see your "Source Material" list, your "Architecture" prose, or your "Discovery" preamble unless it is duplicated into the task that needs it.

**This is the single most common plan failure on large multi-task plans.** A planner lists four design screenshots at the top and assumes "the agent will read them." The orchestrator sees them, may or may not pass them through, and the implementer ends up building a frontend redesign without ever looking at the supplied wireframes. The fix is mechanical: put references where they are needed, in every task that needs them.

**Per-task reference rules:**

1. **Every external artifact a task depends on must be listed inside that task.** This includes:
   - Spec sections (e.g., `docs/specs/<feature>.md § "Approval Flow"`)
   - Design assets (PNG/JPG screenshots, Figma exports, HTML mockups)
   - Reference docs (`docs/FRONTEND-RULES.md`, `docs/PROJECT-OVERVIEW.md`, etc.)
   - Sibling implementations whose pattern is being followed (`apps/api/src/modules/jobs/jobs.service.ts` as the actor-scoping reference)
   - Prior task outputs the current task depends on (named files, exported symbols, schema fields)
2. **Visual/design assets need a "what to extract" note.** Don't just paste a path. Tell the implementer what to look at and why: *"`docs/planning/design-assets/dashboard_example.png` — use as reference for KPI row layout, ordering of widgets, and the attention-list grouping. Match spacing/proportions, not pixel-perfect colors."*
3. **Repeat references across tasks that share them.** If three tasks need the same design screenshot, list it in all three. Cross-references like "see Task 1 for the assets" assume the implementer has seen Task 1; they have not.
4. **A task's "Files" section is not enough.** `Files:` is the *write/edit* surface. Reference materials are *read* inputs and belong either in a dedicated `**References:**` block at the top of the task or under a `**Context:**` paragraph the orchestrator will paste verbatim. Mark them clearly so the orchestrator can extract them.

**Recommended task block addition:**

```markdown
**References (paste into implementer prompt):**
- `docs/specs/<feature>.md § "Public Approval Flow"` — authoritative spec for this task.
- `docs/planning/design-assets/Estimate-Customer-View.html` — target visual design; match structure, not literal HTML.
- `apps/web/components/features/estimates/estimate-builder.tsx:1-120` — current implementation being replaced; preserve action semantics.
```

The phrase "paste into implementer prompt" is a literal instruction to the orchestrator. It removes the ambiguity about whether top-level material should travel with the task.

**Top-level sections (`## Source Material`, `## Architecture`, `## Planning-Time Discovery`)** are still useful — they orient the human reader, the planner's future self, and the orchestrator. But treat them as **planner-facing** material. Anything an implementer needs to *do their task* must be inside the task.

## Don't Spec-Dump: References Are Surgical, Not Bulk

"Tasks Are Self-Contained" is not a license to paste the entire spec into every task. The opposite failure — *spec-dumping* — is just as expensive and just as common.

**Spec-dumping looks like this:**

```markdown
**References:**
- `docs/specs/billing-redesign.md` — full spec for the feature
- `docs/PROJECT-OVERVIEW.md` — project context
- `docs/FRONTEND-RULES.md` — frontend rules
```

Three references, ~3000 lines of context, paid by the implementer of *every* task and the spec reviewer of *every* task and the code quality reviewer of *every* task. Task 6's implementer does not need to read the spec sections for Tasks 1, 2, 4, 5, 7, 8. They will scan-read it anyway, blow context, and miss the four lines that actually mattered for their task.

**This is the dominant cause of inconsistent plan output.** When the planner leans on a top-level "the implementer can read the spec" reference, planning quality collapses: tasks become short and gestural because the planner is implicitly delegating context to the implementer ("they'll figure it out from the spec"). When the planner instead has to *extract the relevant spec content into each task*, planning quality stays high because the planner is forced to actually understand which requirements apply where.

**Atomic-task rule:** every spec fact a task depends on either (a) is *inline-quoted* in the task body, or (b) is referenced with a *specific section + line range*. Never reference a whole spec document.

### Right vs. Wrong

**Wrong (lazy, spec-dump):**

```markdown
**References:**
- `docs/specs/billing-redesign.md` — see § "Subscription Lifecycle"
- `docs/FRONTEND-RULES.md` — follow these rules
```

**Right (surgical, atomic):**

```markdown
**References (paste into implementer prompt):**
- `docs/specs/billing-redesign.md § "Subscription Lifecycle States" (lines 84-127)` — authoritative state machine for this task; do NOT read other sections of the spec.
- `docs/FRONTEND-RULES.md § "Form Validation Patterns" (lines 30-58)` — required Zod + RHF wiring; sibling example at `apps/web/components/forms/customer-form.tsx:88-142`.

**Inlined spec excerpt** (so the implementer doesn't have to navigate the spec at all):
> Subscriptions transition `trial → active` only when the first payment succeeds.
> Trial expiry without payment transitions to `expired`, NOT `cancelled`.
> Cancellation from any state transitions to `cancelled` immediately.
> A subscription in `expired` cannot transition back to `trial`; it must go through `active`.
```

The right version is longer at the *task* level, shorter at the *plan* level (because the planner does the extraction work once instead of pushing it onto every reviewer/implementer in every loop), and produces vastly more consistent output.

### When to Inline-Quote vs. Cite a Section

- **Inline-quote** when the requirement is a short list, a state machine, an enum, an error code table, a small JSON shape, or any spec fact the implementer will reference *while writing code*. Inline-quoting wins because the implementer stops needing to navigate the spec at all.
- **Cite a section with line range** when the requirement is a longer explanation the implementer must understand once but won't reference repeatedly (architecture overview, rationale, full data model). Always include the line range so the implementer reads only the relevant slice.
- **Never reference a whole spec document.** "See `docs/specs/feature.md`" is a planner-failure pattern. The implementer will dutifully read 2000 lines and then get confused about which 40 of them applied.

### Detection: The Same-Reference Smell

Open your draft plan and scan the `**References:**` blocks. **If three or more tasks share the exact same reference (same path, no line ranges, same one-liner), the plan is spec-dumping.** The fix is to go back to each task and either inline-quote the actual relevant chunk or cite the specific section/line range that task depends on. If you can't tell which sections each task actually needs, you have not understood the spec well enough to plan it — go back and read the spec before writing tasks.

**Anchor rule (memorize this one):**

> *Assume each task will be copy-pasted alone into a fresh subagent prompt.* Therefore every task must repeat all context needed to execute it: visual assets, code anchors, patterns to preserve, migration recipe, tests, verify commands, and out-of-scope boundaries. **If the task relies on a top-level section, the plan is not ready.**

**Single-Task Extraction Test (run before saving the plan):** Pick the *most ambitious* task in the plan — not the easiest one. Copy it alone, with nothing above or below, into an imaginary blank prompt. If a low-effort agent would need to infer architecture, visual direction, files to inspect, existing patterns, or implementation sequence, the plan is not done. Apply the same test to at least one routine task and one trivial task; trivial tasks frequently smuggle in implicit context too.

## What "Tutorialized" Means

The skill describes implementers as "low-effort models on autopilot." That phrase is doing more work than it looks like. It does **not** mean "write clear tasks with files, acceptance criteria, and a verify command" — those are necessary but not sufficient. It means **the plan is a tutorial**, written with the precision of an architectural diagram dimensioned to the millimeter. The implementer follows it like a recipe; they do not improvise.

A plan can be structurally compliant — every task has Goal, Files, Acceptance Criteria, Verify, Steps — and still fail this bar by being abstract. Structural compliance is not the bar. **Mechanical executability is the bar.**

**A tutorialized task includes:**

- Exact source files and `file:line` ranges to inspect (the existing behavior to preserve)
- Exact reference files (specs, design assets, sibling implementations) — see "Tasks Are Self-Contained"
- The existing pattern to preserve, named and located by `file:line`
- The target pattern to create, with shape sketched (signature, slot list, prop names, return shape)
- A step-by-step migration/implementation recipe — ordered, verb-first
- Explicit "do not change" boundaries
- The failing test to write first
- The exact commands to run and the exact failure/pass signals
- The commit scope and message

If a task says "migrate X to Y" or "convert customer pages to RecordWorkspace" without any of the above, it is **not** tutorialized — it is a checkbox. A low-effort implementer cannot execute a checkbox; they execute a tutorial.

**Length is not a vice; ambiguity is.** A tutorialized task on a non-trivial migration is often 5–10× longer than its abstract counterpart. That is the correct ratio.

### Bad vs. Good

**Bad — abstract, gestural, requires inference at every step:**

````markdown
### Task 4: Migrate Customer Detail To RecordWorkspace

**Goal:** Convert customer detail to use RecordWorkspace.

**Files:**
- Modify: `apps/web/components/features/customers/customer-detail-client.tsx`
- Create: `apps/web/components/features/customers/customer-record-workspace.tsx`

**Acceptance Criteria:**
- [ ] Customer detail uses RecordWorkspace.
- [ ] Existing tests pass.

**Steps:**
- [ ] Convert customer detail to RecordWorkspace.
- [ ] Update tests.
- [ ] Commit.
````

This task has the right structural shape and is still unusable. The implementer must infer: which `RecordWorkspace` slots to fill, what visual layout to target, what existing code to preserve, what behavior must not change, what shape `RecordWorkspace` exposes, and what the migration sequence is.

**Good — tutorialized, mechanically executable:**

````markdown
### Task 4: Migrate Customer Detail To RecordWorkspace

**Goal:** Replace `DetailLayout` with `RecordWorkspace` for customer detail without changing customer fetching, delete behavior, or tab routing.

**References (paste into implementer prompt):**
- `docs/planning/design-assets/relationship_record_residential_customer_example.png` — target layout for header, left rail, KPI strip, content, activity timeline. Match zone composition; do not pixel-match colors.
- `apps/web/components/workspaces/record-workspace.tsx` — workspace component to compose. Slots: `header`, `tabs`, `rail`, `kpis`, `children`, `activity`.

**Existing Code Anchors:**
- `apps/web/components/layout/detail-layout.tsx:27-73` — current shell to replace; mirrors `header / tabs / sidebar / children` shape.
- `apps/web/components/features/customers/customer-detail-client.tsx:1-140` — owns data fetching, delete mutation, tab state. PRESERVE this orchestration; only change what it renders.
- `apps/web/components/features/customers/customer-detail-sidebar.tsx` — becomes `rail` slot content; do not modify its internals.
- `apps/web/components/features/customers/customer-detail-header.tsx` — becomes `header` slot content; do not modify its internals.

**Migration Recipe:**
1. Create `customer-record-workspace.tsx` exporting `CustomerRecordWorkspace({ customer, onDelete, activeTab, onTabChange })`.
2. Inside, compose `<RecordWorkspace>` with these slot mappings:
   - `header` ← `<CustomerDetailHeader customer={customer} onDelete={onDelete} />`
   - `tabs` ← Tabs list mirroring current `customer-detail-client` tab order
   - `rail` ← `<CustomerDetailSidebar customer={customer} />`
   - `kpis` ← `<MetricStrip>` with the four metrics from the design asset
   - `children` ← active-tab content (existing tab components)
   - `activity` ← `<CustomerActivityTab customer={customer} />`
3. Update `customer-detail-client.tsx` to render `<CustomerRecordWorkspace … />` in place of `<DetailLayout … />`. Do not change the data hooks, delete mutation, or query keys.
4. Retire or update `apps/web/components/layout/__tests__/detail-layout.test.ts` per the `DetailLayout` decision.

**Do Not Change:**
- Customer fetching hooks or query keys
- Delete confirmation behavior
- Tab routing or URL params
- Sidebar/header internals

**Tests First:**
- `apps/web/components/workspaces/__tests__/record-workspace-usage.test.tsx` — render `CustomerRecordWorkspace` with a mock customer; assert header text, rail label, KPI count, and activity heading appear.

**Verify:** `pnpm --filter @fsmcrm/web test -- apps/web/components/workspaces/__tests__/record-workspace-usage.test.tsx apps/web/components/features/customers`
Expected: exit 0; new test passes; existing customer feature tests still pass.

**Commit:** `refactor(web): migrate customer detail to RecordWorkspace`
````

The good version is roughly 5× longer than the bad one. That is the correct ratio.

## Code Anchors For Existing-Code Tasks

Any task that **modifies existing code** MUST include an `**Existing Code Anchors:**` block. Without anchors, the implementer guesses where the relevant code lives, often picks the wrong site, and edits adjacent code by accident. With anchors, the change becomes mechanical.

The block should list, with `file:line-range` references:

- **Current behavior** — code being replaced or changed (the *target* of the edit)
- **Pattern to copy** — sibling code the implementer should mirror (the *template*)
- **Code to preserve** — behavior the task must not break (load-bearing, do-not-touch)
- **Known hazards** — nearby code that *looks* like it should change but should not, or that has historically been a footgun

For new code (greenfield tasks), anchors are unnecessary; describe the target shape in prose plus a code block per "When To Include A Code Block."

## Plans With Visual Or Design Assets

When the spec ships with screenshots, HTML mockups, Figma exports, or any other visual references, those assets are **first-class implementation inputs**. Treat them like API contracts.

**Build a visual digest before writing tasks.** For each asset:

1. Map it to a route or component family (e.g., `dashboard_example.png` → `/dashboard`, `Estimate-Customer-View.html` → `/e/[token]`).
2. Translate visual zones into implementation zones (header, KPI row, attention list, etc.) — name the slots/components that will fill each zone.
3. Note any "do not copy directly" caveats. Standalone HTML mockups commonly use inline styles, hard-coded colors, and non-design-system typography that must NOT be copied verbatim into the codebase.

**Every task that depends on an asset must list it under `**Required Visual Inputs:**`** (or fold it into `**References:**`), with:

- The asset path
- A *"what to extract"* note (zone composition, ordering, density, behavior cues)
- A *"what to ignore"* note where applicable (literal HTML/CSS, placeholder copy, fake data)

**Do not rely on a top-level `## Source Material` block alone.** That is planner-facing material. The implementer never sees it (see "Tasks Are Self-Contained").

## UX Gates: When To Insert One

A **UX Gate** is a special review-only task that fires up a browser-driven UX reviewer loop after substantive frontend work. It exists to catch the failure modes that nothing else catches: pages that don't render, layouts that drift from the design system, pages built ad hoc that don't match the index/template they're supposed to follow, broken interactive states, and other "the screenshot looks wrong" problems that a code-review pass cannot see.

**UX gates are expensive.** They spawn a pathway-generation phase, multiple parallel browser-driven reviewers (one per pathway, each fresh), and an additional implementer fix loop. Use them strategically — never per-task, never as a default. The orchestrator's `superpowers:subagent-driven-development` skill describes the runtime mechanics; your job here is to decide *whether* and *where* to insert one.

For frontend UI work in a repo that provides project-specific frontend skills or instructions, every UX gate task must require reviewers and implementers to load and follow the relevant repo-specific frontend guidance before reviewing or changing UI.

### When To Insert A UX Gate

Insert a UX gate task when **all** of the following are true:

- The work is substantively frontend (new pages, redesigns, major component swaps, layout migrations).
- The output is human-facing and visual fidelity matters (matches design assets, follows existing template patterns, renders without breaking).
- A pure code-review pass plus passing tests would not catch the failure modes you care about.

Do **not** insert a UX gate for: backend tasks, internal-tool one-offs, small tweaks (single-component prop changes, copy edits, minor styling fixes), or anything where the user has not signaled that visual quality is load-bearing.

### Where To Place UX Gates

- **One substantive page/feature → one UX gate at the very end** of the plan, after the page is built and wired.
- **Multiple independent pages/sections → one UX gate per page-or-section group**, placed immediately after each group's implementation tasks. Don't batch all UX into a single gate at the end of a multi-page plan; pathway counts explode and feedback gets entangled.
- **Iterative redesigns of an existing surface → one UX gate after the first pass**, not on every refactor task.

### Asking The User

Frontend planning is the only place in `writing-plans` where you should proactively ask the user a planning-time question. If the spec is substantively frontend and you are uncertain whether visual fidelity is load-bearing for them, **ask before saving the plan**:

> "This plan touches \[N\] frontend pages with \[design assets / template patterns\]. UX gates are expensive but catch rendering / template-drift / layout failures that code review can't. Should I add UX gates? Options:
> (a) Yes — one gate at the end (single coherent surface).
> (b) Yes — one gate per page-group (\[list\]).
> (c) No — code review only; I'll do manual UX QA myself.
> (d) No — this is internal/scrappy and visual fidelity isn't load-bearing here."

Default to (c) for internal tooling, prototypes, and scrappy work. Default to asking when you can't tell. Do not silently insert UX gates — the cost shows up in the user's bill and they should consent.

### UX Gate Task Structure

A UX gate is a **review task**, not an implementation task. It does not write code on the first pass; it inspects what was just built. Its task block looks like this:

```markdown
### Task N: UX Gate — [Surface Name]

**Type:** UX Gate (handled by superpowers:subagent-driven-development UX flow)

**Goal:** Validate that the [surface] built in Tasks [X-Y] renders correctly, matches the supplied design intent, and follows the template/pattern of [reference page]. Catch rendering breaks, template drift, ad-hoc styling, and broken interactive states before merge.

**Required Skill:** UX reviewers and any implementer handling UX findings must load and follow any relevant repo-specific frontend skills or instructions before reviewing or changing frontend UI.

**Surface Under Review:**
- Routes / URLs: `/path/one`, `/path/two/[id]`
- Components: `apps/web/components/features/<feature>/...`
- Built by: Tasks N-1 ... N-3 (reference, do not re-implement)

**Design Intent (paste into UX reviewer prompts):**
- `docs/planning/design-assets/<surface>.png` — target layout for header, KPIs, content density. Match zone composition; do not pixel-match colors.
- `docs/planning/design-assets/<surface>-empty-state.png` — required empty-state treatment.
- (Inline-quote any specific design rules from the spec — e.g., "max KPI count is 4; overflow goes into an expandable panel.")

**Template Pattern To Match:**
- `apps/web/app/(dashboard)/customers/page.tsx` — index page template all related index pages must follow (header height, action bar shape, table density, empty state). Reviewer must compare new pages to this reference.
- `apps/web/components/workspaces/record-workspace.tsx` — record-detail template, if applicable.

**UX Acceptance Criteria:**
- [ ] All routes under review load without console errors and without server errors.
- [ ] Review the surface at mobile (375x812), tablet (768x1024), desktop (1440x900), and very large desktop (1920x1080 or wider) viewports. Layout must match design intent at each viewport; pixel-match is not required unless the spec says so.
- [ ] New pages match the template pattern referenced above (header, action bar, density, empty state).
- [ ] Interactive states (hover, focus, active, disabled, loading, error, empty) all render correctly on at least one representative element per state.
- [ ] No ad-hoc/local styling that contradicts the design system (inline colors, hardcoded fonts, non-token spacing).
- [ ] No regressions on adjacent pages that share components with the surface under review.

**Out Of Scope For UX Review:**
- [Anything explicitly deferred — e.g., "Mobile menu polish (Task N+5)", "Animation timing (separate ticket)"]

**Dev Server / Inspection Setup:**
- Start command: `pnpm --filter @<workspace>/web dev`
- Default URL: `http://localhost:3000`
- Auth fixture (if needed): use `[email protected]` / `password` (seeded by `pnpm db:seed:dev`)
- Test data: ensure `pnpm db:seed:dev` has been run; seeded customer with id `cust_demo_1` is the recommended subject.

**Pathway Hints (optional — the implementer will generate the full pathway list at runtime):**
- Suggested coverage: empty state, populated state, create flow, edit flow, error state, mobile/tablet/desktop/very-large-desktop responsive review, dark mode (if supported), keyboard navigation.
- Known critical interaction: [specific interaction that the design hinges on, if any].
```

The orchestrator recognizes `**Type:** UX Gate` and runs the UX-gate flow described in `superpowers:subagent-driven-development`. Implementers do not execute UX gate tasks like normal tasks; the orchestrator handles them via the implementer thread of the *previous* tasks plus a fan-out of UX reviewer subagents.

### What Belongs In The Plan vs. Generated At Runtime

- **In the plan:** the surface, the routes, the design intent, the template-pattern references, the UX acceptance criteria, the dev-server setup, and any "you must check this specific interaction" hints. These are decisions only the planner can make.
- **Generated at runtime by the implementer:** the actual list of navigation pathways for UX reviewers to follow. Implementations drift from plans; the implementer thread (which has the actual code in context) generates pathways based on what was *built*, not what was *planned*.

Do not enumerate exhaustive pathways in the plan. Let the implementer do that at gate time. Pathway hints in the plan should be coverage suggestions only.

## Quality Gates: When To Insert One

A **Quality Gate** is a review-only task that runs an xhigh production-readiness reviewer after a completed milestone slice or at the end of the plan. It is separate from normal per-task code-quality review. Normal task review catches local problems; Quality Gates catch cross-task security, contract, data integrity, ownership, and major maintainability risks before merge.

Every code-bearing implementation plan must include one final Quality Gate. Omit it only for docs-only or non-code plans, and state that explicitly under `## Architecture`.

### When To Add Milestone Quality Gates

Add milestone gates strategically, not after every task. Insert one immediately after a coherent feature slice when late feedback would be expensive:

- security-sensitive work: auth, tenant scope, public-token flows, CSRF/session behavior, secrets, payments, webhooks, uploads, or XSS-sensitive rendering
- contract-heavy work: schemas, migrations, API envelopes, shared packages, public interfaces, or persistence semantics
- large structural work: new canonical primitives, major component/service decomposition, cross-cutting refactors, or multiple agents touching adjacent ownership boundaries
- multi-feature plans where one final gate would produce a tangled review surface

Do not add milestone gates for small plans, simple refactors, docs-only changes, or task groups already small enough that the final gate remains clear. Cap practical gates at 2-3 per plan. If more seem necessary, split the plan.

### Quality Gate Task Structure

```markdown
### Task N: Quality Gate — [Milestone Or Final Surface]

**Type:** Quality Gate (handled by superpowers:subagent-driven-development Quality Gate flow)

**Goal:** Run a high-signal production-readiness review of Tasks [X-Y] before [next milestone / branch completion]. Catch security, contract, data integrity, ownership, test, and major maintainability regressions that per-task review may miss.

**Surface Under Review:**
- Tasks included: [Task X through Task Y]
- Expected diff scope: [backend modules, frontend surfaces, schemas, migrations, tests]
- Known risk areas: [auth/tenant/payment/API/UI primitives/etc.]

**Gate Review Focus:**
- Security and privacy risks
- API/schema/data-contract breaks
- Frontend/backend responsibility boundaries
- Duplicate canonical helpers/components/primitives
- Spaghetti branching, unnecessary wrappers/casts, and file-size blowups
- Risky behavior without meaningful tests

**Verification Evidence To Provide To The Gate Reviewer:**
- Required commands: `[exact test/typecheck/lint/build commands that should have passed before the gate]`
- Expected evidence: `[exit 0, named test suites, migration status, screenshots if relevant]`

**Out Of Scope For This Gate:**
- [Deferred work, unrelated existing tech debt, known follow-up tickets]
```

The orchestrator recognizes `**Type:** Quality Gate` and runs the Quality Gate flow described in `superpowers:subagent-driven-development`.

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Status:** Draft | Approved | In Progress | Complete
**Spec:** `docs/superpowers/specs/YYYY-MM-DD-<ticket-or-topic>-spec.md`
**Linear:** `<ISSUE-ID and URL, or None>`
**Branch / Worktree:** `<branch>` at `<worktree-path>`
**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

Every task SHOULD include `Goal`, `Files`, `Acceptance Criteria`, `Verify` (command + expected output), and `Steps`. Code blocks within steps are optional — include them per the "When To Include A Code Block" guidance below. For trivial tasks (e.g., a one-line config tweak), it's fine to collapse `Acceptance Criteria` and `Verify` into a single sentence, but don't drop them entirely.

If a plan expects E2E, browser, public-link, API+DB, UX, provider-live, or full-stack verification, include a runtime preflight in the verification strategy: project-approved commands must prove the database is migrated/queryable, the backend boots against it, and the frontend boots with its configured API URL.

````markdown
### Task N: [Component Name]

**Goal:** [One sentence describing what this task produces and why.]

**Files:**
- Create: `exact/path/to/new_file.ext`
- Modify: `exact/path/to/existing.ext:123-145`
- Test:   `tests/exact/path/to/test_file.ext`

**Acceptance Criteria:**
- [ ] [Concrete observable outcome 1 — what "done" looks like, not how to get there.]
- [ ] [Concrete observable outcome 2.]
- [ ] [New tests pass; existing tests still pass.]

**Verify:** `<exact command an implementer can copy-paste>`
Expected: `[exact expected output, error pattern, or "exit 0 with N tests passing"]`

**Steps:**

- [ ] **Step 1: Write the failing test for [specific behavior]**

In `tests/exact/path/to/test_file.ext`, add a test that exercises [behavior]. The test should call [function/endpoint] with [input shape] and assert [expected output]. Use the existing test fixtures in `tests/path/fixtures.ext` for [setup concern].

(Include a code block here only if the test's *shape* — fixture wiring, async setup, mocking pattern — would be ambiguous in prose. A trivial assert-equals test does not need one.)

- [ ] **Step 2: Run the test and confirm it fails for the right reason**

Run: `<exact test command>`
Expected: FAIL with `[specific error message or pattern]` — not a syntax error or import error. If it fails for a different reason, fix the test before continuing.

- [ ] **Step 3: Implement the change in `path/to/existing.ext`**

Add a method/function with this signature:

```text
methodName(input: InputType, actor: ActorType) -> ResultType
```

It should: [responsibility 1], [responsibility 2], [responsibility 3]. Follow the existing pattern used by `siblingMethod` in the same file — same parameter ordering, same error-handling style, same return shape.

(Include a code block here when the *shape* of the implementation matters — a where-clause, a transaction boundary, a specific call sequence. Skip the code block when the change is "rename X to Y at line N" or "add field `foo: string | null` to interface `Bar`.")

- [ ] **Step 4: Run the test and confirm it passes**

Run: `<exact test command>`
Expected: PASS. Also re-run the full module's tests to confirm no regression: `<broader test command>` → expected `N passed`.

- [ ] **Step 5: Commit**

```bash
git add path/to/existing.ext tests/exact/path/to/test_file.ext
git commit -m "feat(scope): short description of behavior added"
```
````

The example above is a TDD-style task. Tasks that aren't TDD (refactors, doc updates, schema migrations) follow the same structure but swap the test/implement/verify steps for the relevant action+verify pair.

## When To Include A Code Block

Code blocks are illustrations, not transcription. The implementer is a low-effort model on autopilot — give them structure where prose is ambiguous, not a wall of code to copy-paste.

**Include a code block when:**
- A method/function signature, type, or shape would be ambiguous in prose (e.g., `where: { id, organizationId, deletedAt: null }`).
- You're creating a small new file in full (schema, migration, focused module, fixture).
- You're showing the exact expected output of a verify command.
- You're showing a pattern the implementer must repeat across the task — restate the snippet inline at each use site rather than referencing an earlier task.

**Skip the code block when:**
- Prose plus a `file:line` reference is unambiguous ("Rename `clearLayers` to `clearAllLayers` in `map.ts:84`. Update the three call sites in `viewer.ts`.").
- The change is a trivial field addition described fully in `Acceptance Criteria` ("Add `subStatus: string | null` to the `Job` interface").
- The implementer can derive the code from an existing pattern explicitly named in the step ("Follow the same actor-scoping pattern used by `findAllJobs` in `jobs.service.ts`.").

When in doubt, prefer prose + file reference over a snippet. But never replace prose with "do the obvious thing" — that's a placeholder, not concision.

## Sweep Tasks Need Enumeration

A **sweep task** is any task whose definition is "find all instances of X across the codebase and change them" — audits, normalizations, cleanups, migrations to a new pattern, refactors that touch many files. These fail catastrophically when the plan describes them as a verb without listing the targets, because both the implementer and the reviewer end up discovering the work-set incrementally and the loop expands across multiple review cycles. A low-effort implementer will fix exactly what the reviewer flagged this turn, then get hit with a fresh batch of previously-unsearched findings on the next turn. This is the single most expensive failure mode in subagent-driven development — and it is not solved by bumping implementer effort, because the bottleneck is enumeration, not capability.

**The planner — not the implementer — does the enumeration.** During planning, run the discovery command(s) against the actual codebase and paste the resulting list into the task. The implementer should not have to figure out what to sweep; they should only have to do the sweep.

For larger sweeps, do not run the discovery in your own context — **dispatch an exploration subagent** (see "Exploration During Planning" above) with a precise prompt: "Run `<discovery command>` in this repo, return the full match list as `file:line`, and report any obvious patterns (e.g., callers that wrap results vs. don't). Also list nearby files matching related patterns so I can decide what to mark as out-of-scope vs. include." This keeps your context clean for the in-scope/out-of-scope decisions, which are the actual planner judgment calls.

**Every sweep task MUST include:**

1. **Discovery command(s)** — exact `rg` / `grep` invocations the planner ran. The implementer and reviewer can re-run these and get the same list.
2. **Enumerated targets** — the actual `file:line` list (or file list, if many lines per file) the planner found. Inline it in the task; don't link out.
3. **Completion predicate** — a command that returns no matches (or exits non-zero) only when the sweep is done. Put this in the `Verify` section.
4. **Explicit out-of-scope list** — files/patterns/areas the planner deliberately excluded, with one-sentence reasons. Without this, reviewers discover those areas during review and expand scope mid-loop.

**Sweep verbs to flag in your own draft:** *audit, normalize, clean up, sweep, migrate, convert, rebuild, rewrite, redesign, replace, wire through, propagate, harmonize, standardize, unify.* If a task uses one of these verbs and doesn't enumerate, it's not ready to dispatch.

**Route/component migrations are a special case: sweep AND tutorial.** Tasks like "migrate customer pages to RecordWorkspace" or "convert all confirmations to ConfirmActionDialog" are sweep tasks (require enumeration), AND each enumerated target needs the tutorial treatment from "What 'Tutorialized' Means" — code anchors, slot mapping, do-not-change list, recipe. Enumerating without recipes still produces a "checkbox" task that fails the Single-Task Extraction Test. If the recipe is identical for every target, write it once in the task body and apply to all targets. If recipes differ, split into multiple tasks or include per-target recipe notes.

**Example sweep task:**

```markdown
### Task N: Normalize Controller Validation

**Goal:** Replace ad-hoc Zod validation in module controllers with `parseRequest` so all validation failures use the standard `VALIDATION_ERROR` envelope.

**Discovery (run on commit `abc123`):**
`rg -n '\.parse\(|\.safeParse\(' apps/api/src/modules --type ts | grep -v __tests__`

**Targets:**
- `apps/api/src/modules/estimates/estimates.controller.ts:59,67,82,98,106,133,141,149,181,195,242`
- `apps/api/src/modules/jobs/jobs.controller.ts:292,327`
- `apps/api/src/modules/search/search.controller.ts:12`

**Out of scope this task** (deferred to separate tickets):
- `apps/api/src/modules/auth/**` — auth controllers also have ad-hoc validation; tracked in TICKET-XYZ.
- Service-level validation (e.g., `sales-pipeline.service.ts:278 safeParse`) — service-layer cleanup is Task Nb.
- Shared-schema invariants (e.g., mutual-exclusion checks currently in services) — Task Nc (requires schema design).

**Acceptance Criteria:**
- [ ] All targets above use `parseRequest`.
- [ ] No controller wraps a service result that already has `{ data, meta }` shape.
- [ ] All converted validation failures route through `VALIDATION_ERROR` envelope.

**Verify:** `rg '\.parse\(|\.safeParse\(' apps/api/src/modules --type ts | grep -v __tests__`
Expected: no matches in scoped files; matches in out-of-scope files are acceptable.
```

If you can't write the enumerated targets and the completion predicate, the task isn't ready — go back and do the discovery work yourself before dispatching. **Reviewers will not save you from missing enumeration**; they will discover scope incrementally just like the implementer, and you will pay for it in cycles.

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat the relevant context inline — the engineer may be reading tasks out of order)
- Steps that describe what to do without enough structure to act on (file reference, named pattern, expected shape, or code block — see "When To Include A Code Block")
- References to types, functions, or methods not defined in any task
- Sweep verbs ("audit X," "normalize Y," "clean up Z," "wire through W," "migrate A to B," "convert all C," "rebuild D," "redesign E") without an enumerated target list, completion predicate, and out-of-scope list — see "Sweep Tasks Need Enumeration"
- Tasks that are structurally compliant but abstract — Goal/Files/AC/Verify/Steps all present, but the steps say "convert X to Y" without code anchors, slot mappings, recipes, or do-not-change boundaries. See "What 'Tutorialized' Means."
- Scope-hedging language that lets the implementer do partial work ("prioritize a coherent focused batch," "report any deferred cleanup") on tasks where completeness across many files is the entire point
- Whole-document spec references with no section or line range (`docs/specs/feature.md`, `docs/PROJECT-OVERVIEW.md`, `docs/FRONTEND-RULES.md`) — see "Don't Spec-Dump." Reference specific sections with line ranges, or inline-quote the relevant excerpt.
- The same broad reference pasted into three or more tasks. If you cannot tell which sections each task actually needs, you have not understood the spec well enough to plan it.

## Remember
- Exact file paths always (with line ranges when modifying)
- Code blocks where shape would otherwise be ambiguous — see "When To Include A Code Block"
- Exact commands with expected output
- DRY for code (not the plan), YAGNI, TDD, frequent commits

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it. This is a checklist you run yourself — not a subagent dispatch.

**1. Spec coverage:** Skim each section/requirement in the spec. Can you point to a task that implements it? List any gaps.

**2. Placeholder scan:** Search your plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**3. Type consistency:** Do the types, method signatures, and property names you used in later tasks match what you defined in earlier tasks? A function called `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 is a bug.

**4. Tutorialization check:** Structural compliance is not sufficient. For each task:

- Confirm it has `Files` (with line ranges where modifying), `Acceptance Criteria`, and `Verify` (exact command + expected output).
- For tasks modifying existing code, confirm an `**Existing Code Anchors:**` block is present (current behavior, pattern to copy, code to preserve, known hazards).
- For tasks driven by visual assets, confirm `**Required Visual Inputs:**` (or `**References:**`) names each asset with "what to extract" notes.
- For migrations/conversions/rebuilds, confirm a step-by-step recipe is present — not just a destination.
- Confirm steps read as instructions a low-effort model on autopilot can follow without inference. If a step gestures at work ("update the service to scope by org," "wire it through to the frontend," "convert customer pages to RecordWorkspace") without enough structure to act on it, fix it.

**Final reviewer gate** — answer all four before saving:

1. Can an implementer execute Task 1 (or any task) without reading any other task or the plan header?
2. Can a reviewer reject visual drift / wrong pattern / missing behavior using *only* the contents of that single task?
3. Does every task name which assets, docs, and code anchors to read — by path?
4. Does every migration/conversion task explain the *sequence*, not just the destination?

If the answer to any is "no," fix the affected tasks before saving. **The Single-Task Extraction Test from "Tasks Are Self-Contained" is the empirical version of these questions — actually run it on the most ambitious task in the plan.**

**5. Per-task reference check:** For each task, ask: "if the orchestrator only sees this task block — not the plan header, not earlier tasks — does the implementer have every reference they need?" Specifically, check tasks that depend on design assets, screenshots, spec sections, reference docs, or sibling-implementation patterns. If any of those live only in a top-level `## Source Material` / `## Architecture` / `## Background` section, copy them into a `**References:**` block inside each task that needs them. **The implementer never reads the plan file** — top-level material is invisible to them unless duplicated into the task.

**6. Sweep enumeration check:** Re-read each task. Does any task use a sweep verb (audit, normalize, clean up, sweep, migrate, replace, wire through, propagate, harmonize, standardize, unify)? For each one, confirm the task includes a discovery command, an enumerated target list (run against the actual codebase, not imagined), a completion predicate in `Verify`, and an explicit out-of-scope list. **Tasks that fail this check produce multi-cycle review loops** — both the implementer and reviewer will discover scope incrementally and the loop will not converge. If you can't enumerate, do the discovery work now before saving the plan; do not push the work onto the implementer.

**7. Spec-dump check:** Open every task's `**References:**` block and look for whole-document references with no section or line range (e.g., `docs/specs/feature.md` or `docs/PROJECT-OVERVIEW.md`). If you find any, replace them with surgical references (specific section + line range) or inline-quote the relevant excerpt directly into the task body. Then scan across tasks: if three or more tasks share an identical reference line, the plan is spec-dumping — fix it. See "Don't Spec-Dump." A bloated reference list is a strong predictor of inconsistent implementer output.

**8. UX gate placement check:** If the plan is substantively frontend, ask yourself whether a UX gate is warranted (see "UX Gates: When To Insert One"). If you're uncertain, you should have already asked the user — if you didn't, ask now before saving. If you decided no UX gate, briefly note why under `## Architecture` (e.g., "internal-tooling polish; visual fidelity not load-bearing") so a future reader doesn't second-guess. If you decided yes, confirm each gate task is structured per the "UX Gate Task Structure" guidance: surface defined, design intent referenced surgically (no design-asset spec-dumping either), template pattern named, acceptance criteria observable, dev-server setup specified.

**9. Quality gate placement check:** Every code-bearing plan needs a final Quality Gate task. Add milestone Quality Gates only after large/risky coherent slices where late feedback would be expensive. If the plan is docs-only or non-code, note why no Quality Gate is needed under `## Architecture`. Confirm each gate task is structured per the "Quality Gate Task Structure" guidance: surface defined, risk areas named, verification evidence specified, and out-of-scope debt listed.

**10. Runtime verification check:** If any acceptance criterion depends on live app behavior, public links, browser UX, provider callbacks, or API+DB behavior, confirm the plan names the runtime preflight evidence needed before anyone can call that behavior verified. If live verification is impossible, the task must say what remains mock-scoped and what UAT/follow-up is required.

If you find issues, fix them inline. No need to re-review — just fix and move on. If you find a spec requirement with no task, add the task.

## Execution Handoff

After saving the plan, stop for approval unless the user explicitly delegated plan approval:

**"Plan complete and saved to `docs/superpowers/plans/<filename>.md`. Please review and approve it before execution. After approval, the next step is subagent-driven development: implementation, spec review, code quality review, any UX gates, and the final Quality Gate."**

- **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
- Fresh subagent per task + two-stage review
- Execution starts only after plan approval or explicit delegated approval.
