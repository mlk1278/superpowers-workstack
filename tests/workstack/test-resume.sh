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

skill="$repo_root/skills/workstack-resume/SKILL.md"
metadata="$repo_root/skills/workstack-resume/agents/openai.yaml"

[ -f "$skill" ] || { echo "not ok - skill file missing: $skill" >&2; exit 1; }

assert_contains "$skill" "name: workstack-resume" "frontmatter name"
assert_contains "$skill" "I'm using workstack-resume; discovering state before acting." "announce line"
assert_contains "$skill" "The durable record is the state; you are replaceable." "replaceable-orchestrator stance"
assert_contains "$skill" "Never trust conversation memory." "discovery over memory"
assert_contains "$skill" "merged commits and current PR head state" "authority order: commits first"
assert_contains "$skill" "conversation memory last" "authority order: memory last"
assert_contains "$skill" "reconcile the less authoritative source before dispatching work" "reconciliation rule"
assert_contains "$skill" "Write every state transition to the ledger before acting on it." "ledger-before-action"
assert_contains "$skill" "living-plan-format.md" "format doc referenced"
assert_contains "$skill" "plan-authoring.md" "authoring doc referenced"
assert_contains "$skill" "Approved spec, no living plan" "row: spec only"
assert_contains "$skill" "naming \`workstack-resume\` as the continuation" "plan-writing continuation declared"
assert_contains "$skill" "Plan with a due planning checkpoint" "row: checkpoint"
assert_contains "$skill" "Ready slice, not started" "row: ready"
assert_contains "$skill" "stating the worktree decision up front" "worktree consent pre-empted"
assert_contains "$skill" "mark slice tickets in progress in one Linear operation" "slice-start Linear op"
assert_contains "$skill" "Active slice, task incomplete" "row: mid-task"
assert_contains "$skill" "never redispatched" "idempotent task resume"
assert_contains "$skill" "Task reviews clean, gate not passed" "row: gated pending"
assert_contains "$skill" "Recover \`REVIEW_HEAD\` from the ledger, never memory." "gate head recovery"
assert_contains "$skill" "Gated, no PR" "row: gated"
assert_contains "$skill" "declaring the pull-request completion route" "completion contract declared"
assert_contains "$skill" "monitored, never recreated" "idempotent PR handling"
assert_contains "$skill" "reconciled, never reopened" "idempotent merge handling"
assert_contains "$skill" "advance newly unblocked slices to ready" "post-merge advancement"
assert_contains "$skill" "prune or transfer any owned contract exactly once" "closeout prune"
assert_contains "$skill" "Nothing matches" "row: inconsistent state"
assert_contains "$skill" "Continue through merge and reconciliation" "default continuation depth"
assert_contains "$skill" "never per task or review round" "coarse Linear"
assert_contains "$skill" "One slice, one gate, one PR. Inner-loop execution stays sequential." "core invariants"
assert_before "$skill" "## 1. Discover state" "## 2. Dispatch table" "discovery precedes dispatch"
assert_no_model_names "$skill"

[ -f "$metadata" ] || { echo "not ok - committed OpenAI metadata missing" >&2; exit 1; }
grep -Fq "display_name" "$metadata" || { echo "not ok - metadata lacks display_name" >&2; exit 1; }
echo "ok - committed OpenAI metadata present"

assert_contains "$skill" "scan \`docs/active-contracts/\`" "discovery scans contracts"
assert_contains "$skill" "Two or more ready slices, eligibility claims all pass" "row: parallel frontier"
assert_contains "$skill" "active-contracts.md" "contract doc referenced"
assert_contains "$skill" "its own sequential slice loop in its own worktree" "parallel isolation"
assert_contains "$skill" "Overlap or doubt means sequential." "sequential default"

echo "PASS"
