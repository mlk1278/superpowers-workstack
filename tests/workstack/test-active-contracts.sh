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

doc="$repo_root/skills/workstack-resume/active-contracts.md"
[ -f "$doc" ] || { echo "not ok - active-contracts.md missing" >&2; exit 1; }

assert_contains "$doc" "at most one active contract" "one contract per plan"
assert_contains "$doc" "Independent work with no coordination risk creates no contract." "no gratuitous contracts"
assert_contains "$doc" "docs/active-contracts/<plan-slug>.md" "contract location"
assert_contains "$doc" "Exact prune trigger" "prune trigger field"
assert_contains "$doc" "sole writer" "sole-writer ownership"
assert_contains "$doc" "lanes never author or edit contracts" "read-only for lanes"
assert_contains "$doc" "verify no prior owner is live, record the ownership transfer" "restart ownership transfer"
assert_contains "$doc" "disjoint write sets, verified, not assumed" "eligibility: disjoint writes"
assert_contains "$doc" "frozen or has one declared producer" "eligibility: frozen interfaces"
assert_contains "$doc" "migration ownership and merge order are explicit" "eligibility: migrations"
assert_contains "$doc" "not reused until a lane retires" "eligibility: resource reservation"
assert_contains "$doc" "Any claim you cannot make confidently means sequential." "sequential default"
assert_contains "$doc" "At most two concurrent code-bearing slices by default" "concurrency default"
assert_contains "$doc" "never a completion requirement" "parallelism optional"
assert_contains "$doc" "they never independently reinterpret the change" "consumer discipline"
assert_contains "$doc" "never create competing migrations" "migration exclusivity"
assert_contains "$doc" "every named consumer is merged, cancelled, or transferred" "prune condition"
assert_contains "$doc" "cannot close while it owns a binding contract" "plan-close guard"
assert_contains "$doc" "never from branch or worktree age alone" "no age-based deletion"
assert_contains "$doc" "may outlive its producer branch" "contract survives producer"
assert_contains "$doc" "read-only exploration fan-out and to independent contract-covered slices only" "dispatching-parallel-agents scoped"
assert_contains "$doc" "never a license for parallel implementation inside one slice" "no intra-slice parallelism"
assert_no_model_names "$doc"
echo "PASS"
