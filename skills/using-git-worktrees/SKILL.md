---
name: using-git-worktrees
description: Use when starting feature work that needs isolation from current workspace or before executing implementation plans - creates isolated git worktrees with smart directory selection and safety verification
---

# Using Git Worktrees

## Overview

Git worktrees create isolated workspaces sharing the same repository, allowing work on multiple branches simultaneously without switching.

**Core principle:** Systematic directory selection + safety verification = reliable isolation.

**Announce at start:** "I'm using the using-git-worktrees skill to set up an isolated workspace."

## Linear And Branch Identity

Before creating a feature worktree for non-trivial work, decide whether it should be tied to Linear.

- If the user named a Linear ticket, use that ticket.
- If no ticket is mentioned, the orchestrator decides whether to use Linear. For substantial work, dispatch a low-effort Linear helper to scan likely backlog matches, then ask the user whether to use an existing ticket, create one, or skip Linear.
- The orchestrator makes the decision; the low-effort helper only runs Linear CLI/API commands and returns candidate issues, creates/updates the selected issue, or comments on it.

When a ticket is used:

- Move it to In Progress before implementation starts.
- Name the branch/worktree `<ISSUE-ID>-<short-slug>` where the slug is 2-5 words from the feature title, lowercase, hyphenated.
- Record the branch and worktree path on the Linear ticket with a comment or supported agent-session/link command.
- Use the ticket ID in the first commit message, PR title/body, and any handoff notes.

When Linear is skipped, name the branch/worktree `<short-slug>` and record "Linear: None" in the spec/plan.

## Directory Selection Process

Follow this priority order:

### 1. Check Existing Directories

```bash
# Check in priority order
ls -d .worktrees 2>/dev/null     # Preferred (hidden)
ls -d worktrees 2>/dev/null      # Alternative
```

**If found:** Use that directory. If both exist, `.worktrees` wins.

### 2. Check CLAUDE.md

```bash
grep -i "worktree.*director" CLAUDE.md 2>/dev/null
```

**If preference specified:** Use it without asking.

### 3. Ask User

If no directory exists and no CLAUDE.md preference:

```
No worktree directory found. Where should I create worktrees?

1. .worktrees/ (project-local, hidden)
2. ~/.config/superpowers/worktrees/<project-name>/ (global location)

Which would you prefer?
```

## Safety Verification

### For Project-Local Directories (.worktrees or worktrees)

**MUST verify directory is ignored before creating worktree:**

```bash
# Check if directory is ignored (respects local, global, and system gitignore)
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
```

**If NOT ignored:**

Per Jesse's rule "Fix broken things immediately":
1. Add appropriate line to .gitignore
2. Commit the change
3. Proceed with worktree creation

**Why critical:** Prevents accidentally committing worktree contents to repository.

### For Global Directory (~/.config/superpowers/worktrees)

No .gitignore verification needed - outside project entirely.

## Creation Steps

### 1. Detect Project Name

```bash
project=$(basename "$(git rev-parse --show-toplevel)")
```

### 2. Choose Branch Name

```bash
# With Linear
BRANCH_NAME="<ISSUE-ID>-<short-slug>"

# Without Linear
BRANCH_NAME="<short-slug>"
```

Keep branch names short and stable. Do not rename the branch after planning starts unless the user asks.

### 3. Create Worktree

```bash
# Determine full path
case $LOCATION in
  .worktrees|worktrees)
    path="$LOCATION/$BRANCH_NAME"
    ;;
  ~/.config/superpowers/worktrees/*)
    path="~/.config/superpowers/worktrees/$project/$BRANCH_NAME"
    ;;
esac

# Create worktree with new branch
git worktree add "$path" -b "$BRANCH_NAME"
cd "$path"
```

### 4. Run Project Setup

Auto-detect and run appropriate setup:

```bash
# Node.js
if [ -f package.json ]; then npm install; fi

# Rust
if [ -f Cargo.toml ]; then cargo build; fi

# Python
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi

# Go
if [ -f go.mod ]; then go mod download; fi
```

### 5. Verify Clean Baseline

Run tests to ensure worktree starts clean:

```bash
# Examples - use project-appropriate command
npm test
cargo test
pytest
go test ./...
```

**If tests fail:** Report failures, ask whether to proceed or investigate.

**If tests pass:** Report ready.

### 6. Record Ticket Metadata

If a Linear ticket is attached, update it after the worktree is ready:

- Status: In Progress.
- Branch: `<BRANCH_NAME>`.
- Worktree: `<absolute-path>`.
- Baseline verification: command and pass/fail summary.

Use the `linear-cli` skill for the command mechanics. Prefer file-based flags for multi-line comments/descriptions.

### 7. Report Location

```
Worktree ready at <full-path>
Branch: <BRANCH_NAME>
Linear: <ISSUE-ID or None>
Tests passing (<N> tests, 0 failures)
Ready to implement <feature-name>
```

## Quick Reference

| Situation | Action |
|-----------|--------|
| `.worktrees/` exists | Use it (verify ignored) |
| `worktrees/` exists | Use it (verify ignored) |
| Both exist | Use `.worktrees/` |
| Neither exists | Check CLAUDE.md → Ask user |
| Directory not ignored | Add to .gitignore + commit |
| Linear ticket exists | Branch/worktree `<ISSUE-ID>-<short-slug>`, move ticket In Progress, record metadata |
| No Linear ticket mentioned | Low-effort helper scans backlog for substantial work, then user chooses |
| Tests fail during baseline | Report failures + ask |
| No package.json/Cargo.toml | Skip dependency install |

## Common Mistakes

### Skipping ignore verification

- **Problem:** Worktree contents get tracked, pollute git status
- **Fix:** Always use `git check-ignore` before creating project-local worktree

### Assuming directory location

- **Problem:** Creates inconsistency, violates project conventions
- **Fix:** Follow priority: existing > CLAUDE.md > ask

### Proceeding with failing tests

- **Problem:** Can't distinguish new bugs from pre-existing issues
- **Fix:** Report failures, get explicit permission to proceed

### Hardcoding setup commands

- **Problem:** Breaks on projects using different tools
- **Fix:** Auto-detect from project files (package.json, etc.)

### Losing ticket/branch traceability

- **Problem:** Work happens in a worktree but Linear, branch, commits, and PR do not clearly connect.
- **Fix:** Use the ticket ID in the branch/worktree, first commit, PR, and Linear comment. Record "Linear: None" explicitly when skipped.

## Example Workflow

```
You: I'm using the using-git-worktrees skill to set up an isolated workspace.

[Check .worktrees/ - exists]
[Verify ignored - git check-ignore confirms .worktrees/ is ignored]
[Linear: CRM-123 selected, moved to In Progress]
[Create worktree: git worktree add .worktrees/CRM-123-auth-refresh -b CRM-123-auth-refresh]
[Run npm install]
[Run npm test - 47 passing]
[Comment on CRM-123 with branch/worktree/baseline verification]

Worktree ready at /Users/jesse/myproject/.worktrees/CRM-123-auth-refresh
Branch: CRM-123-auth-refresh
Tests passing (47 tests, 0 failures)
Ready to implement auth feature
```

## Red Flags

**Never:**
- Create worktree without verifying it's ignored (project-local)
- Skip baseline test verification
- Proceed with failing tests without asking
- Assume directory location when ambiguous
- Skip CLAUDE.md check
- Leave an attached Linear ticket without branch/worktree metadata
- Create vague branches like `feature/work` or `updates`

**Always:**
- Follow directory priority: existing > CLAUDE.md > ask
- Verify directory is ignored for project-local
- Auto-detect and run project setup
- Verify clean test baseline
- Tie ticket, branch, worktree, first commit, and PR together when Linear is used

## Integration

**Called by:**
- **brainstorming** (Phase 4) - REQUIRED when design is approved and implementation follows
- **subagent-driven-development** - REQUIRED before executing any tasks
- **executing-plans** - REQUIRED before executing any tasks
- Any skill needing isolated workspace

**Pairs with:**
- **finishing-a-development-branch** - REQUIRED for cleanup after work complete
