#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
checker="$repo_root/scripts/check-workstack-divergences.py"
fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT

actual_allowlist=$(jq -r '.divergences[].path' "$repo_root/workstack/upstream-divergences.json" | LC_ALL=C sort)
expected_allowlist=$(printf '%s\n' \
  skills/dispatching-parallel-agents/SKILL.md \
  skills/finishing-a-development-branch/SKILL.md \
  skills/requesting-code-review/SKILL.md \
  skills/requesting-code-review/code-reviewer.md \
  skills/subagent-driven-development/SKILL.md \
  skills/subagent-driven-development/implementer-prompt.md \
  skills/subagent-driven-development/task-reviewer-prompt.md \
  skills/test-driven-development/SKILL.md \
  skills/using-git-worktrees/SKILL.md \
  skills/using-superpowers/references/codex-tools.md \
  | LC_ALL=C sort)

if [[ "$actual_allowlist" != "$expected_allowlist" ]]; then
  echo "divergence allowlist does not match the retained surgical seams" >&2
  diff -u <(printf '%s\n' "$expected_allowlist") <(printf '%s\n' "$actual_allowlist") >&2 || true
  exit 1
fi

git -C "$fixture" init -q
git -C "$fixture" config user.email "test@example.com"
git -C "$fixture" config user.name "Test User"

mkdir -p \
  "$fixture/skills/brainstorming" \
  "$fixture/skills/debugging" \
  "$fixture/skills/type-change"
printf 'baseline permitted\n' > "$fixture/skills/brainstorming/SKILL.md"
printf 'baseline protected\n' > "$fixture/skills/debugging/SKILL.md"
printf 'baseline regular file\n' > "$fixture/skills/type-change/SKILL.md"
git -C "$fixture" add skills
git -C "$fixture" commit -qm "baseline"
baseline=$(git -C "$fixture" rev-parse HEAD)

mkdir -p "$fixture/workstack"
cat > "$fixture/workstack/upstream-divergences.json" <<EOF
{
  "baseline": "$baseline",
  "divergences": [
    {
      "path": "skills/brainstorming/SKILL.md",
      "reason": "Preserve the fork workflow."
    }
  ]
}
EOF

printf 'permitted fork change\n' > "$fixture/skills/brainstorming/SKILL.md"
mkdir -p "$fixture/skills/workstack-fixture"
printf 'fork-only addition\n' > "$fixture/skills/workstack-fixture/SKILL.md"
git -C "$fixture" add skills
git -C "$fixture" commit -qm "permitted changes"
permitted_ref=$(git -C "$fixture" rev-parse HEAD)

(
  cd "$fixture"
  python3 "$checker" --ref "$permitted_ref"
)

rm "$fixture/skills/type-change/SKILL.md"
ln -s ../brainstorming/SKILL.md "$fixture/skills/type-change/SKILL.md"
git -C "$fixture" add skills/type-change/SKILL.md
git -C "$fixture" commit -qm "unlisted type change"

type_stderr="$fixture/type-check.stderr"
if (
  cd "$fixture"
  python3 "$checker" --ref HEAD 2> "$type_stderr"
); then
  echo "expected unlisted protected type change to fail" >&2
  exit 1
fi

if ! grep -Fq 'skills/type-change/SKILL.md' "$type_stderr"; then
  echo "expected rejected type-change path in stderr" >&2
  cat "$type_stderr" >&2
  exit 1
fi

printf 'unlisted fork change\n' > "$fixture/skills/debugging/SKILL.md"
git -C "$fixture" add skills/debugging/SKILL.md
git -C "$fixture" commit -qm "unlisted change"

stderr="$fixture/check.stderr"
if (
  cd "$fixture"
  python3 "$checker" --ref HEAD 2> "$stderr"
); then
  echo "expected unlisted protected change to fail" >&2
  exit 1
fi

if ! grep -Fq 'skills/debugging/SKILL.md' "$stderr"; then
  echo "expected rejected path in stderr" >&2
  cat "$stderr" >&2
  exit 1
fi

echo "PASS"
