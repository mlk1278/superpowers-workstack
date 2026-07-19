#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
skill="$repo_root/skills/workstack-slice-gate/SKILL.md"
metadata="$repo_root/skills/workstack-slice-gate/agents/openai.yaml"

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

assert_contains "$skill" "name: workstack-slice-gate" "frontmatter name"
assert_contains "$skill" "I'm running the slice gate for <slice>." "announce line"
assert_contains "$skill" "One slice, one gate, one PR." "one-gate invariant"
assert_contains "$skill" "owned by superpowers:subagent-driven-development's final whole-branch gate and are not restated here" "gate mechanics deferred to SDD"
assert_contains "$skill" "specialty \`final-gate\`" "routed final-gate reviewer"
assert_contains "$skill" "fail closed on independence errors" "independence fails closed"
assert_contains "$skill" "docs/REVIEW-GUIDANCE.md" "reviewer-only guidance offered"
assert_contains "$skill" "spec and ticket coverage" "slice checklist: coverage"
assert_contains "$skill" "integration coherence" "slice checklist: coherence"
assert_contains "$skill" "accidental scope or unsupported claims" "slice checklist: scope"
assert_contains "$skill" "Run the UX gate before this gate" "UX gate ordering"
assert_contains "$skill" "Record the gate verdict and approved SHA in the progress ledger" "ledger recording"
assert_contains "$skill" "Never open a PR or invoke branch completion with findings open" "no PR with open findings"
assert_contains "$skill" "a new commit after approval restarts gate evidence" "head-bound evidence"
assert_no_model_names "$skill"

[ -f "$metadata" ] || { echo "not ok - committed OpenAI metadata missing" >&2; exit 1; }
grep -Fq "display_name" "$metadata" || { echo "not ok - metadata lacks display_name" >&2; exit 1; }
echo "ok - committed OpenAI metadata present"

echo "PASS"
