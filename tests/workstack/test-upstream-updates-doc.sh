#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
doc="$repo_root/workstack/UPSTREAM-UPDATES.md"

assert_contains() {
  local text=$1 description=$2
  if ! grep -Fq -- "$text" "$doc"; then
    echo "not ok - $description" >&2
    echo "missing: $text" >&2
    exit 1
  fi
  echo "ok - $description"
}

assert_before() {
  local first=$1 second=$2 description=$3
  local first_line second_line
  first_line=$(grep -Fn -- "$first" "$doc" | head -1 | cut -d: -f1)
  second_line=$(grep -Fn -- "$second" "$doc" | head -1 | cut -d: -f1)
  if [[ -z "$first_line" || -z "$second_line" || "$first_line" -ge "$second_line" ]]; then
    echo "not ok - $description" >&2
    exit 1
  fi
  echo "ok - $description"
}

[[ -f "$doc" ]] || { echo "not ok - upstream update document missing: $doc" >&2; exit 1; }

assert_contains "git fetch upstream --tags" "fetches upstream tags"
assert_contains "git merge <release-tag>" "merges the selected release tag"
assert_contains "python3 scripts/check-workstack-divergences.py" "runs divergence checker"
assert_contains "tests/workstack/test-*.sh" "runs all WorkStack tests"
assert_contains "tests/codex/test-package-codex-plugin.sh" "runs Codex packaging test"
assert_contains "tests/codex/test-marketplace-manifest.sh" "runs marketplace manifest test"
assert_contains "tests/codex-plugin-sync/test-sync-to-codex-plugin.sh" "runs Codex sync test"
assert_contains "tests/claude-code/test-sdd-workspace.sh" "runs SDD workspace test"
assert_contains "re-apply" "re-applies still-required divergences"
assert_contains "re-approve" "requires renewed allowlist approval"
assert_contains "seam no longer applies" "removes expired seams"

assert_before "git fetch upstream --tags" "git merge <release-tag>" "fetch precedes merge"
assert_before "git merge <release-tag>" "python3 scripts/check-workstack-divergences.py" "merge precedes divergence check"
assert_before "python3 scripts/check-workstack-divergences.py" "tests/workstack/test-*.sh" "divergence check precedes full suite"

echo "PASS"
