#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
skill="$repo_root/skills/workstack-ux-gate/SKILL.md"
metadata="$repo_root/skills/workstack-ux-gate/agents/openai.yaml"

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

assert_contains "$skill" "name: workstack-ux-gate" "frontmatter name"
assert_contains "$skill" "I'm running the UX gate for <surface>." "announce line"
assert_contains "$skill" "\`Pass\` bound to the reviewed head SHA, or \`Changes Required\`" "verdict contract"
assert_contains "$skill" "The gate does not fix anything." "gate does not fix"
assert_contains "$skill" "nothing downstream may claim UX was verified" "runtime preflight is mandatory"
assert_contains "$skill" "5-10 navigation pathways covering what this diff changed" "pathways derive from the diff"
assert_contains "$skill" "throwaway Playwright script" "capture is a throwaway script"
assert_contains "$skill" ".superpowers/ux/" "script lives in ignored scratch"
assert_contains "$skill" "<pathway>-<step>-<width>.png" "screenshot naming convention"
assert_contains "$skill" "Resolve one \`reviewer\` with specialty \`ux\` via workstack-agent-routing" "routed ux reviewer"
assert_contains "$skill" "vision-capable model" "reviewer route must handle images"
assert_contains "$skill" "without driving the browser" "reviewer judges images, not live UI"
assert_contains "$skill" "docs/REVIEW-GUIDANCE.md" "reviewer-only guidance is offered to the reviewer"
assert_contains "$skill" "against the approved criteria — never personal taste" "criteria-bound judgment"
assert_contains "$skill" "component file + visual state + viewport + specific deviation + screenshot reference" "finding format"
assert_contains "$skill" "a finding, not a skip" "blocked step is a finding"
assert_contains "$skill" "rerun the capture script on the new head" "fix rounds rerun the script"
assert_contains "$skill" "a new push invalidates prior evidence" "head-bound evidence"
assert_contains "$skill" "before the final gate verdict" "UX gate precedes the final gate"
assert_contains "$skill" "One primary UX reviewer by default" "single primary reviewer"
assert_contains "$skill" "Do not manufacture states by editing app source" "no manufactured states"
assert_no_model_names "$skill"

[ -f "$metadata" ] || { echo "not ok - committed OpenAI metadata missing" >&2; exit 1; }
grep -Fq "display_name" "$metadata" || { echo "not ok - metadata lacks display_name" >&2; exit 1; }
echo "ok - committed OpenAI metadata present"

echo "PASS"
