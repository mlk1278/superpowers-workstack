#!/usr/bin/env bash
# Literal shell snippets are contract text, not expressions to expand.
# shellcheck disable=SC2016
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
skill="$repo_root/skills/subagent-driven-development/SKILL.md"

assert_contains() {
  local text=$1 description=$2
  if ! grep -Fq -- "$text" "$skill"; then
    echo "not ok - $description" >&2
    echo "missing: $text" >&2
    exit 1
  fi
  echo "ok - $description"
}

assert_not_contains() {
  local text=$1 description=$2
  if grep -Fq -- "$text" "$skill"; then
    echo "not ok - $description" >&2
    echo "unexpected: $text" >&2
    exit 1
  fi
  echo "ok - $description"
}

assert_before() {
  local first=$1 second=$2 description=$3
  local first_line second_line
  first_line=$(grep -Fn "$first" "$skill" | head -1 | cut -d: -f1)
  second_line=$(grep -Fn "$second" "$skill" | head -1 | cut -d: -f1)
  if [[ -z "$first_line" || -z "$second_line" || "$first_line" -ge "$second_line" ]]; then
    echo "not ok - $description" >&2
    exit 1
  fi
  echo "ok - $description"
}

assert_contains 'REVIEW_HEAD=$(git rev-parse HEAD)' "final review resolves an exact head"
assert_contains 'Set `MERGE_BASE` to `git merge-base <target-branch> HEAD`, where `<target-branch>` is the branch this work will merge into.' "final review defines the merge base"
assert_contains 'scripts/review-package "$MERGE_BASE" "$REVIEW_HEAD"' "whole-branch package uses the exact head"
assert_contains 'Only an explicit `Ready to merge? Yes` approves that SHA.' "approval verdict is explicit"
assert_contains 'Send the complete final finding set to one fixer.' "final findings are fixed together"
assert_contains 'covering command, exit status, and relevant output' "fix verification carries evidence"
assert_contains 'scripts/review-package "$REVIEW_HEAD" "$NEW_HEAD"' "re-review receives a fresh delta package"
assert_contains 'Resume the same final reviewer thread' "re-review stays in one thread"
assert_contains 'require `git rev-parse HEAD` to equal the approved SHA' "branch completion checks the approved head"

assert_not_contains \
  '"Dispatch final code reviewer subagent (../requesting-code-review/code-reviewer.md)" -> "Use superpowers:finishing-a-development-branch";' \
  "process graph has no direct final-review completion edge"
assert_contains '[One fixer receives the complete final finding set]' "example exercises a final finding path"
assert_contains 'Invoke `finishing-a-development-branch` with open final findings' "red flags prohibit an open gate"
assert_before 'Only an explicit `Ready to merge? Yes` approves that SHA.' \
  'Immediately before invoking `finishing-a-development-branch`' \
  "approval precedes branch completion"

echo "PASS"
