---
name: using-superpowers
description: Use when the user explicitly asks about Superpowers skill selection, or when a complex or ambiguous task may require choosing among multiple specialized skills
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, skip this skill.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
Use skills when their trigger clearly matches the user's request or the user explicitly asks to use them.

Do not invoke skills purely as a defensive ritual. If a task is small, direct, and outside a skill's stated trigger, proceed with normal engineering judgment.

Do not load this skill just because a session started. Use it when skill selection itself is uncertain, important, or explicitly requested.

If a skill applies to the task, use it. If you invoke a skill and it turns out to be the wrong fit, say so briefly and continue without forcing its workflow.
</EXTREMELY-IMPORTANT>

## Instruction Priority

Superpowers skills override default system prompt behavior, but **user instructions always take precedence**:

1. **User's explicit instructions** (CLAUDE.md, GEMINI.md, AGENTS.md, direct requests) — highest priority
2. **Superpowers skills** — override default system behavior where they conflict
3. **Default system prompt** — lowest priority

If CLAUDE.md, GEMINI.md, or AGENTS.md says "don't use TDD" and a skill says "always use TDD," follow the user's instructions. The user is in control.

## How to Access Skills

**In Claude Code:** Use the `Skill` tool. When you invoke a skill, its content is loaded and presented to you—follow it directly. Never use the Read tool on skill files.

**In Copilot CLI:** Use the `skill` tool. Skills are auto-discovered from installed plugins. The `skill` tool works the same as Claude Code's `Skill` tool.

**In Gemini CLI:** Skills activate via the `activate_skill` tool. Gemini loads skill metadata at session start and activates the full content on demand.

**In other environments:** Check your platform's documentation for how skills are loaded.

## Platform Adaptation

Skills use Claude Code tool names. Non-CC platforms: see `references/copilot-tools.md` (Copilot CLI), `references/codex-tools.md` (Codex) for tool equivalents. Gemini CLI users get the tool mapping loaded automatically via GEMINI.md.

# Using Skills

## The Rule

**Invoke explicitly requested skills and clearly relevant skills before substantive work.** Match the user's request to the skill descriptions. Skills are tools for situations that need their workflow, not mandatory overhead for every adjacent keyword.

Mentioning a skill is not always a request to invoke it. If the user is discussing skill design, repo content, trigger policy, or wording, inspect only the needed files unless they explicitly ask you to use that skill's workflow.

For simple, mechanical, or clearly scoped tasks, proceed with normal engineering judgment. Use this skill only when skill selection itself changes what you would do.

```dot
digraph skill_flow {
    "User message received" [shape=doublecircle];
    "User explicitly asked to use/load a skill?" [shape=diamond];
    "Clear trigger match?" [shape=diamond];
    "Invoke Skill tool" [shape=box];
    "Announce: 'Using [skill] to [purpose]'" [shape=box];
    "Has checklist?" [shape=diamond];
    "Create TodoWrite todo per item" [shape=box];
    "Follow skill exactly" [shape=box];
    "Respond (including clarifications)" [shape=doublecircle];

    "User message received" -> "User explicitly asked to use/load a skill?";
    "User explicitly asked to use/load a skill?" -> "Invoke Skill tool" [label="yes"];
    "User explicitly asked to use/load a skill?" -> "Clear trigger match?" [label="no"];
    "Clear trigger match?" -> "Invoke Skill tool" [label="yes"];
    "Clear trigger match?" -> "Respond (including clarifications)" [label="no"];
    "Invoke Skill tool" -> "Announce: 'Using [skill] to [purpose]'";
    "Announce: 'Using [skill] to [purpose]'" -> "Has checklist?";
    "Has checklist?" -> "Create TodoWrite todo per item" [label="yes"];
    "Has checklist?" -> "Follow skill exactly" [label="no"];
    "Create TodoWrite todo per item" -> "Follow skill exactly";
}
```

## Red Flags

These thoughts mean STOP if the request clearly matches a skill's trigger and the task is complex enough for the workflow to matter:

| Thought | Reality |
|---------|---------|
| "The user explicitly asked me to use this skill, but I can skip reading it" | Explicitly requested skills must be read. |
| "I need more context first" | If a workflow clearly applies, skill check comes before open-ended exploration. |
| "Let me explore the codebase first" | If exploration strategy is part of the workflow, check first. |
| "The trigger matches, but I can check git/files quickly" | For substantive work, skills may define how to inspect state. |
| "Let me gather information first" | For complex tasks, skills may define how to gather information. |
| "This doesn't need a formal skill" | If the trigger clearly matches and the workflow would change your approach, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "The skill is overkill" | Skip only when the task is small/mechanical or genuinely outside the trigger. |
| "I'll just do this one thing first" | For substantive workflow-driven work, check before doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept ≠ using the skill. Invoke it. |

Non-red-flag: "This is a narrow typo, copy, or CSS tweak with an obvious owner and no broader behavior/design question." Handle it directly unless another skill specifically says it applies.

## Skill Priority

When multiple skills could apply, use this order:

1. **Process skills first** (brainstorming, writing-specs, debugging) - these determine WHAT should be built and why
2. **Planning/execution skills second** (writing-plans, subagent-driven-development) - these determine HOW to build and verify it
3. **Domain skills alongside the relevant phase** (frontend-design, mcp-builder, project-specific skills) - these guide specialized execution

"Let's design/build an ambiguous new feature" -> brainstorming first, then writing-specs for substantial work, then writing-plans, then implementation skills.
"Fix this reproducible/nontrivial bug" -> debugging first, then domain-specific skills.
"Change this button padding" -> the frontend/domain skill may apply, but brainstorming/debugging usually do not.

## Skill Types

**Rigid** (TDD, debugging): Once the skill applies, follow exactly. Don't adapt away discipline.

**Flexible** (patterns): Adapt principles to context.

The skill itself tells you which.

## User Instructions

Instructions say WHAT, not HOW. "Add X" or "Fix Y" doesn't mean skip workflows when a skill clearly applies and would materially change the approach.
