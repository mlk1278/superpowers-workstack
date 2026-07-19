#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
brainstorming="$repo_root/skills/brainstorming/SKILL.md"
writing_plans="$repo_root/skills/writing-plans/SKILL.md"

assert_contains() {
  local file=$1 text=$2 description=$3
  if ! grep -Fq "$text" "$file"; then
    echo "not ok - $description" >&2
    echo "missing: $text" >&2
    exit 1
  fi
  echo "ok - $description"
}

assert_before() {
  local file=$1 first=$2 second=$3 description=$4
  local first_line second_line
  first_line=$(grep -Fn "$first" "$file" | head -1 | cut -d: -f1)
  second_line=$(grep -Fn "$second" "$file" | head -1 | cut -d: -f1)
  if [[ -z "$first_line" || -z "$second_line" || "$first_line" -ge "$second_line" ]]; then
    echo "not ok - $description" >&2
    exit 1
  fi
  echo "ok - $description"
}

assert_contains "$brainstorming" \
  "If the caller named one approved continuation before invoking this skill, invoke it after the user approves the written spec; otherwise invoke \`writing-plans\`." \
  "brainstorming supports a caller continuation and preserves its default"
assert_contains "$brainstorming" \
  "This changes only the terminal handoff; every preceding step and approval gate still applies." \
  "brainstorming continuation cannot bypass approval"
assert_contains "$brainstorming" \
  "**The default terminal state is invoking writing-plans.**" \
  "brainstorming keeps its default terminal state"
assert_before "$brainstorming" "**User Review Gate:**" "**Continuation contract:**" \
  "brainstorming resolves continuation after written-spec approval"

assert_contains "$writing_plans" \
  "If the caller named one approved continuation before invoking this skill, invoke it after saving and self-reviewing the plan instead of offering the execution choices below. Otherwise use the Execution Handoff below unchanged." \
  "writing-plans supports a caller continuation and preserves its default"
assert_before "$writing_plans" "## Self-Review" "## Continuation" \
  "writing-plans resolves continuation after self-review"
assert_contains "$writing_plans" "**1. Subagent-Driven (recommended)**" \
  "writing-plans keeps the default execution choice"
assert_contains "$writing_plans" "**2. Inline Execution**" \
  "writing-plans keeps the alternate execution choice"

echo "PASS"
