#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)

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

skill="$repo_root/skills/workstack-start/SKILL.md"
metadata="$repo_root/skills/workstack-start/agents/openai.yaml"

[ -f "$skill" ] || { echo "not ok - skill file missing: $skill" >&2; exit 1; }

assert_contains "$skill" "name: workstack-start" "frontmatter name"
assert_contains "$skill" "I'm using workstack-start to take this from idea to approved spec." "announce line"
assert_contains "$skill" "This skill makes nothing; it sequences approvals." "pure-sequencer stance"
assert_contains "$skill" "superpowers:brainstorming" "delegates discovery to brainstorming"
assert_contains "$skill" "naming \`workstack-start\` as the continuation" "continuation declared"
assert_contains "$skill" "instead of flowing to writing-plans" "default continuation pre-empted"
assert_contains "$skill" "docs/superpowers/specs/YYYY-MM-DD-<feature-slug>-spec.md" "canonical spec location"
assert_contains "$skill" "Do not write code, scaffold, plan, or invoke any implementation skill until your human partner approves the direction." "direction hard gate"
assert_contains "$skill" "Expand the same file — never a second design artifact" "single spec artifact"
assert_contains "$skill" "Decision-complete is the bar" "spec bar"
assert_contains "$skill" "empty open-questions section" "open questions closed at approval"
assert_contains "$skill" "No implementation task lists, branch structure, or speculative file paths" "spec content exclusions"
assert_contains "$skill" "workstack-spec-review" "spec review helper"
assert_contains "$skill" "No Linear decomposition and no implementation planning before that approval." "approval hard gate"
assert_contains "$skill" "Invoke \`workstack-resume\` with the approved spec path" "handoff to resume"
assert_contains "$skill" "Resume Work owns every later state" "no overlapping path"
assert_before "$skill" "## 1. Direction" "## 2. Specification" "direction precedes spec"
assert_before "$skill" "## 3. Review and approval" "## 4. Hand off" "review precedes handoff"
assert_no_model_names "$skill"

[ -f "$metadata" ] || { echo "not ok - committed OpenAI metadata missing" >&2; exit 1; }
grep -Fq "display_name" "$metadata" || { echo "not ok - metadata lacks display_name" >&2; exit 1; }
echo "ok - committed OpenAI metadata present"

echo "PASS"
