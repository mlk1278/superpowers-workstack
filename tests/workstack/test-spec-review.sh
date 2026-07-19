#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
skill="$repo_root/skills/workstack-spec-review/SKILL.md"
metadata="$repo_root/skills/workstack-spec-review/agents/openai.yaml"

assert_contains() {
  local file=$1 text=$2 description=$3
  if ! grep -Fq "$text" "$file"; then
    echo "not ok - $description" >&2
    echo "missing: $text" >&2
    exit 1
  fi
  echo "ok - $description"
}

assert_no_model_names() {
  local file=$1
  if grep -Eq 'gpt-[0-9]|opus-|sonnet|haiku|-sol|Sol (high|medium|low)' "$file"; then
    echo "not ok - concrete model identifiers in $file" >&2
    exit 1
  fi
  echo "ok - no concrete model identifiers in $file"
}

[ -f "$skill" ] || { echo "not ok - skill file missing: $skill" >&2; exit 1; }

assert_contains "$skill" "name: workstack-spec-review" "frontmatter name"
assert_contains "$skill" "I'm running the spec review for <spec-path>." "announce line"
assert_contains "$skill" "The reviewer never makes product decisions." "reviewer scope bound"
assert_contains "$skill" "specialty \`spec\` via workstack-agent-routing" "routed spec reviewer"
assert_contains "$skill" "fail closed on reviewer-independence errors" "independence fails closed"
assert_contains "$skill" "a planner can plan from the spec without guessing" "approval bar"
assert_contains "$skill" "\`Approved\` or blocking findings tied to exact sections" "verdict contract"
assert_contains "$skill" "resume the same reviewer thread until \`Approved\`" "same-thread loop"
assert_contains "$skill" "goes back to your human partner, not to the reviewer" "product decisions escalate"
assert_contains "$skill" "Do not start Linear decomposition or implementation planning before user approval" "approval precedes planning"
assert_no_model_names "$skill"

[ -f "$metadata" ] || { echo "not ok - committed OpenAI metadata missing" >&2; exit 1; }
grep -Fq "display_name" "$metadata" || { echo "not ok - metadata lacks display_name" >&2; exit 1; }
echo "ok - committed OpenAI metadata present"

echo "PASS"
