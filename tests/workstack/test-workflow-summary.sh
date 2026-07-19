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

summary="$repo_root/workstack/AGENTS-SNIPPET.md"
[ -f "$summary" ] || { echo "not ok - workflow summary draft missing" >&2; exit 1; }
assert_contains "$summary" "workstack-quick-task" "summary names quick task"
assert_contains "$summary" "workstack-start" "summary names start"
assert_contains "$summary" "workstack-resume" "summary names resume"
assert_contains "$summary" "enter at the first state you don't have" "summary states the entry rule"
assert_contains "$summary" "redesign the capability, not this summary" "summary is the simplicity forcing function"
if grep -Eq 'phase plan|shepherd|implementation phase' "$summary"; then
  echo "not ok - phase vocabulary in workflow summary" >&2
  exit 1
fi
echo "ok - no phase vocabulary"
echo "PASS"
