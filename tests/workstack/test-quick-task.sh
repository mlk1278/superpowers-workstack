#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
skill="$repo_root/skills/workstack-quick-task/SKILL.md"
metadata="$repo_root/skills/workstack-quick-task/agents/openai.yaml"

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

[ -f "$skill" ] || { echo "not ok - skill file missing: $skill" >&2; exit 1; }

assert_contains "$skill" "name: workstack-quick-task" "frontmatter name"
assert_contains "$skill" "I'm using workstack-quick-task to ship this." "announce line"
assert_contains "$skill" "the ask itself is the spec" "entry condition"
assert_contains "$skill" "one merged PR with scratch artifacts and the worktree removed" "exit condition"
assert_contains "$skill" "Fail closed on reviewer-independence errors." "reviewer independence fails closed"
assert_contains "$skill" "hand to \`workstack-start\` when no approved spec exists, or \`workstack-resume\` when one does" "promotion clause"
assert_contains "$skill" "never creates one to mirror a tiny local change" "no ticket mirroring"
assert_contains "$skill" ".superpowers/quick/" "ignored mini-plan location"
assert_contains "$skill" "## Global Constraints" "mini-plan carries global constraints"
assert_contains "$skill" "superpowers:subagent-driven-development" "reuses the SDD loop"
assert_contains "$skill" "the task reviewer may issue the task verdict and the final-gate verdict in the same pass" "one-pass gate allowance"
assert_contains "$skill" "run workstack-ux-gate before the final gate verdict" "conditional UX gate ordering"
assert_contains "$skill" "stating the worktree decision up front" "worktree consent prompt pre-empted"
assert_contains "$skill" "apply the project's own worktree rules" "project worktree rules layered on"
assert_contains "$skill" "the project's testing policy when it differs from default TDD" "testing policy travels in constraints"
assert_contains "$skill" "superpowers:finishing-a-development-branch" "branch completion handoff"
assert_contains "$skill" "declaring the pull-request completion route" "completion contract declared, no menu"
assert_contains "$skill" "workstack-pr-monitor" "PR monitor handoff"
assert_contains "$skill" "Done means merged, not PR-open." "merged is done"
assert_before "$skill" "## 2. Scope check" "## 3. Mini-plan" "scope check precedes the mini-plan"
assert_before "$skill" "## 5. UX evidence" "## 6. PR and merge" "UX evidence precedes the PR"
assert_no_model_names "$skill"

[ -f "$metadata" ] || { echo "not ok - committed OpenAI metadata missing" >&2; exit 1; }
grep -Fq "display_name" "$metadata" || { echo "not ok - metadata lacks display_name" >&2; exit 1; }
echo "ok - committed OpenAI metadata present"

echo "PASS"
