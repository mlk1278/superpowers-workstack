---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work - guides completion of development work by presenting structured options for merge, PR, or cleanup
---

# Finishing a Development Branch

## Overview

Guide completion of development work by presenting clear options and handling chosen workflow.

**Core principle:** Verify tests → confirm clean committed work → push or integrate → clean up.

**Announce at start:** "I'm using the finishing-a-development-branch skill to complete this work."

## The Process

### Step 1: Verify Tests

**Before presenting options, verify tests pass:**

```bash
# Run project's test suite
npm test / cargo test / pytest / go test ./...
```

**If tests fail:**
```
Tests failing (<N> failures). Must fix before completing:

[Show failures]

Cannot proceed with merge/PR until tests pass.
```

Stop. Don't proceed to Step 2.

**If tests pass:** Continue to Step 2.

If the branch includes E2E, browser, public-link, API+DB, UX, provider-live, or full-stack verification claims, also confirm runtime preflight evidence before Step 2: migrated/queryable database, backend boot, and frontend boot. If preflight fails, report the blocker and do not present the branch as complete.

### Step 2: Verify Git State

Before presenting options, verify intended work is committed:

```bash
git status --short
git log --oneline --decorate -5
```

If `git status --short` is not empty:

```
Worktree has uncommitted changes. I cannot finish this branch until they are committed or intentionally discarded.
```

Stop and resolve the dirty state before continuing. Do not offer merge/PR/keep/discard options while intended work is uncommitted.

If the work is linked to Linear, confirm recent commit messages, branch name, and PR metadata include the ticket ID or document why not.

### Step 3: Determine Base Branch

```bash
# Try common base branches
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

Or ask: "This branch split from main - is that correct?"

### Step 4: Present Options

Present exactly these 4 options:

```
Implementation complete. What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

**Don't add explanation** - keep options concise.

### Step 5: Execute Choice

#### Option 1: Merge Locally

```bash
# Switch to base branch
git checkout <base-branch>

# Pull latest
git pull

# Merge feature branch
git merge <feature-branch>

# Verify tests on merged result
<test command>

# If tests pass
git branch -d <feature-branch>
```

Then: Cleanup worktree (Step 6)

#### Option 2: Push and Create PR

```bash
# Push branch
git push -u origin <feature-branch>

# Create PR
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets of what changed>

## Test Plan
- [ ] <verification steps>
EOF
)"
```

Then: Cleanup worktree (Step 6)

#### Option 3: Keep As-Is

Push before handoff unless the user explicitly wants a local-only branch:

```bash
git push -u origin <feature-branch>
```

Report: "Keeping branch <name>. Worktree preserved at <path>. Branch pushed to <remote-url>."

**Don't cleanup worktree.**

#### Option 4: Discard

**Confirm first:**
```
This will permanently delete:
- Branch <name>
- All commits: <commit-list>
- Worktree at <path>

Type 'discard' to confirm.
```

Wait for exact confirmation.

If confirmed:
```bash
git checkout <base-branch>
git branch -D <feature-branch>
```

Then: Cleanup worktree (Step 6)

### Step 6: Cleanup Worktree

**For Options 1, 2, 4:**

Check if in worktree:
```bash
git worktree list | grep $(git branch --show-current)
```

If yes:
```bash
git worktree remove <worktree-path>
```

**For Option 3:** Keep worktree.

## Quick Reference

| Option | Merge | Push | Keep Worktree | Cleanup Branch |
|--------|-------|------|---------------|----------------|
| 1. Merge locally | ✓ | - | - | ✓ |
| 2. Create PR | - | ✓ | ✓ | - |
| 3. Keep as-is | - | ✓ by default | ✓ | - |
| 4. Discard | - | - | - | ✓ (force) |

## Common Mistakes

**Skipping test verification**
- **Problem:** Merge broken code, create failing PR
- **Fix:** Always verify tests before offering options

**Treating mocked tests as live verification**
- **Problem:** Branch is presented as E2E/full-stack verified while the DB, API, or web app cannot actually start
- **Fix:** Require runtime preflight evidence for live verification claims, or label the result mock-scoped and create follow-up/UAT

**Open-ended questions**
- **Problem:** "What should I do next?" → ambiguous
- **Fix:** Present exactly 4 structured options

**Finishing with dirty changes**
- **Problem:** Work remains only in the worktree and gets lost or missed in PR.
- **Fix:** Require clean `git status --short` before presenting completion options.

**Unpushed handoff branch**
- **Problem:** User cannot inspect or recover the branch remotely.
- **Fix:** Push for PR and keep-as-is paths unless the user explicitly requests local-only.

**Automatic worktree cleanup**
- **Problem:** Remove worktree when might need it (Option 2, 3)
- **Fix:** Only cleanup for Options 1 and 4

**No confirmation for discard**
- **Problem:** Accidentally delete work
- **Fix:** Require typed "discard" confirmation

## Red Flags

**Never:**
- Proceed with failing tests
- Present E2E/full-stack/browser behavior as verified without runtime preflight evidence
- Present completion options with dirty uncommitted changes
- Hand off an unpushed branch unless explicitly requested
- Merge without verifying tests on result
- Delete work without confirmation
- Force-push without explicit request

**Always:**
- Verify tests before offering options
- Verify clean git status before offering options
- Push PR/keep-as-is branches by default
- Present exactly 4 options
- Get typed confirmation for Option 4
- Clean up worktree for Options 1 & 4 only

## Integration

**Called by:**
- **subagent-driven-development** (Step 7) - After all tasks complete
- **executing-plans** (Step 5) - After all batches complete

**Pairs with:**
- **using-git-worktrees** - Cleans up worktree created by that skill
