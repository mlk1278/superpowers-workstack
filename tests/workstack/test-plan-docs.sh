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

fmt="$repo_root/skills/workstack-resume/living-plan-format.md"
auth="$repo_root/skills/workstack-resume/plan-authoring.md"

[ -f "$fmt" ] || { echo "not ok - living-plan-format.md missing" >&2; exit 1; }
[ -f "$auth" ] || { echo "not ok - plan-authoring.md missing" >&2; exit 1; }

assert_contains "$fmt" "docs/superpowers/plans/YYYY-MM-DD-<feature-slug>.md" "plan location"
assert_contains "$fmt" "removed from the current tree by a coordination commit" "closeout removal"
assert_contains "$fmt" "Delivery-slice index" "slice index required"
assert_contains "$fmt" "\`deferred\`, \`ready\`, \`active\`, \`gated\`, \`PR open\`, \`merged\`, \`cancelled\`, \`blocked\`" "slice state vocabulary"
assert_contains "$fmt" "split the slice before PR creation" "no partial-slice merges"
assert_contains "$fmt" "It never guesses file paths, signatures, migrations, or task steps" "checkpoint anti-speculation rule"
assert_contains "$fmt" "Task review" "gate taxonomy: task review"
assert_contains "$fmt" "Whole-slice gate" "gate taxonomy: slice gate"
assert_contains "$fmt" "PR provider gate" "gate taxonomy: provider gate"
assert_contains "$fmt" ".superpowers/sdd/ledger.md" "ledger location"
assert_contains "$fmt" "Write the transition before acting on it" "ledger-before-action rule"
assert_contains "$fmt" "resume from the ledger alone" "ledger sufficiency"
assert_contains "$fmt" "never a content document" "thin worktree context pointer"
assert_contains "$fmt" "The recovery authority order lives in \`workstack-resume\`'s SKILL.md" "authority order single-sourced"

assert_contains "$auth" "pasted alone into a fresh implementer prompt" "extraction framing"
assert_contains "$auth" "Implementers never read the plan file" "self-contained tasks"
assert_contains "$auth" "References (paste into implementer prompt)" "reference block name"
assert_contains "$auth" "Never reference a whole document" "surgical references"
assert_contains "$auth" "three or more tasks share the exact same bare reference" "spec-dump smell"
assert_contains "$auth" "Existing Code Anchors" "anchors block name"
assert_contains "$auth" "current behavior, pattern to copy, code to preserve, known hazards" "anchor categories"
assert_contains "$auth" "\"Update all callers\" is not a task" "sweep rule"
assert_contains "$auth" "completion predicate" "sweep predicate"
assert_contains "$auth" "most ambitious task" "extraction test target"
assert_contains "$auth" "trivial tasks smuggle in implicit context" "extraction test breadth"

for f in "$fmt" "$auth"; do
  if grep -Eq 'phase plan|shepherd|implementation phase' "$f"; then
    echo "not ok - phase vocabulary in $f" >&2
    exit 1
  fi
done
echo "ok - no phase vocabulary"
echo "PASS"
