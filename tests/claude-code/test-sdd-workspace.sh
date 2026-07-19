#!/usr/bin/env bash
# Tests for the SDD workspace: scripts/sdd-workspace resolves a self-ignoring
# working-tree directory for SDD artifacts, and the SDD scripts write into it.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SDD_SCRIPTS="$REPO_ROOT/skills/subagent-driven-development/scripts"

FAILURES=0
TEST_ROOT=""

pass() { echo "  [PASS] $1"; }
fail() {
    echo "  [FAIL] $1"
    FAILURES=$((FAILURES + 1))
}

cleanup() {
    if [[ -n "$TEST_ROOT" && -d "$TEST_ROOT" ]]; then
        rm -rf "$TEST_ROOT"
    fi
}

main() {
    echo "=== Test: sdd-workspace ==="

    TEST_ROOT="$(mktemp -d)"
    trap cleanup EXIT

    # Resolve repo to its physical path so string comparisons match the
    # helper's output (git rev-parse --show-toplevel resolves symlinks; on
    # macOS mktemp lives under /var -> /private/var).
    git init -q -b main "$TEST_ROOT/repo"
    local repo
    repo="$(cd "$TEST_ROOT/repo" && git rev-parse --show-toplevel)"

    local dir
    dir="$(cd "$repo" && "$SDD_SCRIPTS/sdd-workspace")"

    if [[ "$dir" == "$repo/.superpowers/sdd" ]]; then
        pass "prints <repo-root>/.superpowers/sdd"
    else
        fail "prints <repo-root>/.superpowers/sdd"
        echo "    got: $dir"
    fi

    if [[ -f "$repo/.superpowers/sdd/.gitignore" && "$(cat "$repo/.superpowers/sdd/.gitignore")" == "*" ]]; then
        pass "self-ignoring .gitignore created with '*'"
    else
        fail "self-ignoring .gitignore created with '*'"
    fi

    printf 'x\n' > "$repo/.superpowers/sdd/artifact.md"
    local status
    status="$(cd "$repo" && git status --porcelain)"
    if [[ -z "$status" ]]; then
        pass "workspace invisible to git status"
    else
        fail "workspace invisible to git status"
        echo "    status: $status"
    fi

    ( cd "$repo" && git add -A )
    local staged
    staged="$(cd "$repo" && git diff --cached --name-only)"
    if [[ -z "$staged" ]]; then
        pass "git add -A does not stage the workspace"
    else
        fail "git add -A does not stage the workspace"
        echo "    staged: $staged"
    fi

    cat > "$repo/plan.md" <<'PLAN'
# Plan

## Global Constraints

- Keep shared behavior unchanged.

```text
### Task 99: Fenced global example
```

## Context

This must not enter the brief.

## Task 1: First thing

Do the first thing.

```text
### Task 99: Fenced task example
```

Still part of Task 1.

## Task 2: Second thing

Do the second thing.
PLAN

    local brief_out brief_path
    brief_out="$(cd "$repo" && "$SDD_SCRIPTS/task-brief" plan.md 1)"
    brief_path="$(printf '%s\n' "$brief_out" | sed -n 's/^wrote \(.*\): [0-9][0-9]* lines$/\1/p')"
    case "$brief_path" in
        "$repo/.superpowers/sdd/"*) pass "task-brief writes its brief under the workspace" ;;
        *)
            fail "task-brief writes its brief under the workspace"
            echo "    got: $brief_path"
            ;;
    esac

    local expected_brief="$TEST_ROOT/expected-brief.md"
    cat > "$expected_brief" <<'BRIEF'
## Global Constraints

- Keep shared behavior unchanged.

```text
### Task 99: Fenced global example
```

## Task 1: First thing

Do the first thing.

```text
### Task 99: Fenced task example
```

Still part of Task 1.

BRIEF
    if cmp -s "$brief_path" "$expected_brief"; then
        pass "task-brief includes exact global constraints before only the selected task"
    else
        fail "task-brief includes exact global constraints before only the selected task"
        diff -u "$expected_brief" "$brief_path" || true
    fi

    cat > "$repo/template-plan.md" <<'PLAN'
# Template Plan

## Global Constraints

- Preserve the public contract.

---

### Task 1: First template task

Implement only the first task.

### Task 2: Neighbor template task

This must not enter Task 1's brief.
PLAN

    local template_brief="$TEST_ROOT/template-brief.md"
    local expected_template_brief="$TEST_ROOT/expected-template-brief.md"
    "$SDD_SCRIPTS/task-brief" "$repo/template-plan.md" 1 "$template_brief" >/dev/null
    cat > "$expected_template_brief" <<'BRIEF'
## Global Constraints

- Preserve the public contract.

---

### Task 1: First template task

Implement only the first task.

BRIEF
    if cmp -s "$template_brief" "$expected_template_brief"; then
        pass "task-brief handles canonical level-three task headings without leakage"
    else
        fail "task-brief handles canonical level-three task headings without leakage"
        diff -u "$expected_template_brief" "$template_brief" || true
    fi

    local missing_output missing_status
    set +e
    missing_output="$(cd "$repo" && "$SDD_SCRIPTS/task-brief" plan.md 9 "$repo/missing.md" 2>&1)"
    missing_status=$?
    set -e
    if [[ "$missing_status" -eq 3 && "$missing_output" == *"task 9 not found"* && ! -s "$repo/missing.md" ]]; then
        pass "missing task does not emit a constraints-only brief"
    else
        fail "missing task does not emit a constraints-only brief"
        echo "    status: $missing_status"
        echo "    output: $missing_output"
    fi

    local git_id=(-c user.email=t@example.com -c user.name=t -c commit.gpgsign=false)
    ( cd "$repo" \
        && git add plan.md \
        && git "${git_id[@]}" commit -qm c1 \
        && printf 'y\n' > f && git add f \
        && git "${git_id[@]}" commit -qm c2 )
    local rp_out rp_path
    rp_out="$(cd "$repo" && "$SDD_SCRIPTS/review-package" HEAD~1 HEAD)"
    rp_path="$(printf '%s\n' "$rp_out" | sed -n 's/^wrote \(.*\): [0-9].*$/\1/p')"
    case "$rp_path" in
        "$repo/.superpowers/sdd/"*) pass "review-package writes its diff under the workspace" ;;
        *)
            fail "review-package writes its diff under the workspace"
            echo "    got: $rp_path"
            ;;
    esac

    # --- Worktree isolation: a linked worktree resolves its own workspace ---
    local wt="$TEST_ROOT/wt"
    ( cd "$repo" && git worktree add -q "$wt" -b wt-feature )
    local wt_root wt_dir
    wt_root="$(cd "$wt" && git rev-parse --show-toplevel)"
    wt_dir="$(cd "$wt" && "$SDD_SCRIPTS/sdd-workspace")"
    if [[ "$wt_dir" == "$wt_root/.superpowers/sdd" && "$wt_dir" != "$dir" ]]; then
        pass "linked worktree resolves its own distinct workspace"
    else
        fail "linked worktree resolves its own distinct workspace"
        echo "    main: $dir"
        echo "    wt:   $wt_dir"
    fi

    printf 'y\n' > "$wt/.superpowers/sdd/artifact.md"
    local wt_status
    wt_status="$(cd "$wt" && git status --porcelain)"
    if [[ -z "$wt_status" ]]; then
        pass "worktree workspace invisible to git status"
    else
        fail "worktree workspace invisible to git status"
        echo "    status: $wt_status"
    fi

    echo ""
    if [[ "$FAILURES" -ne 0 ]]; then
        echo "FAILED: $FAILURES assertion(s)."
        exit 1
    fi
    echo "PASS"
}

main "$@"
