# Private Dev Environment Installer Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` to implement this plan task-by-task after human approval. Do not start implementation from this plan until an isolated worktree exists and the user has approved execution.

**Goal:** Build a copy-based private installer/updater for this fork so authenticated machines can install and update Claude Code and Codex Superpowers skills from this repo with one command.

**Spec:** `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md`

**Architecture:** A single stdlib Python CLI at `scripts/superpowers` owns install/update/doctor. It copies repo-managed skill directories into native harness skill directories, records every managed file in JSON state, backs up local modifications before overwriting by default, preserves explicit override directories, and creates non-overwritten agent effort config files from version-controlled defaults. Shell tests run against temporary HOME/project directories.

**Important scope decision:** V1 installs native skill directories for Claude Code and Codex. It does not edit Claude marketplace registries, Codex plugin caches, user `CLAUDE.md`, or user `AGENTS.md`. Those files often contain personal configuration, and the spec explicitly excludes marketplace publishing and unrelated dotfile management.

**Simplicity guard:** This is not a package manager. Keep the implementation to one stdlib script that copies version-controlled markdown/config files, creates a small JSON config, records hashes in a ledger, and handles conflicts with backup/strict/keep-local behavior. Do not add a daemon, dependency resolver, plugin registry mutation, generated package format, or merge engine.

---

## File Structure

| File | Responsibility | Action |
|---|---|---|
| `scripts/superpowers` | Main installer/updater/doctor CLI, Python stdlib only | Create |
| `config/superpowers-defaults.json` | Version-controlled default agent effort config | Create |
| `scripts/install-to-claude.sh` | Narrow untracked prototype superseded by new CLI | Delete if present, or leave absent if not tracked in implementation worktree |
| `tests/private-installer/test-superpowers-installer.sh` | End-to-end shell tests using temp HOME/project dirs | Create |
| `skills/using-superpowers/references/agent-effort-config.md` | Runtime convention for role-based effort defaults | Create |
| `skills/subagent-driven-development/SKILL.md` | Main subagent workflow model selection | Modify |
| `skills/requesting-code-review/SKILL.md` | Standalone code-review subagent dispatch | Modify |
| `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md` | Approved spec | Read only |
| `README.md` | Private-fork install/update docs | Modify installation/update sections |

## Planning-Time Discovery

- Current private fork remote: `origin git@github.com:mlk1278/superpowers-refined.git`
- Current user Claude skills path is a symlink: `~/.claude/skills -> ~/.agents/skills`. The new installer must not create symlinks and must safely replace a symlink target path by backing up the symlink itself before creating a real directory.
- Current Codex native skills live at `~/.codex/skills`.
- Existing untracked `scripts/install-to-claude.sh` copies `skills/*` to `~/.claude/skills` with `rsync --delete`, but has no state ledger, backups, Codex support, project scope, or conflict modes.

---

### Task 1: Add Failing Installer Tests

**Type:** Test

**Goal:** Create a focused shell test suite that defines the installer behavior before implementation.

**References (paste into implementer prompt):**
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:51-76` — required commands, copy mode, state ledger, effort config, conflict behavior, log status prefixes, and marketplace exclusion.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:141-154` — acceptance signals this test suite must cover.
- `tests/codex-plugin-sync/test-sync-to-codex-plugin.sh:14-87` — local shell assertion helper style to copy: `pass`, `fail`, `assert_contains`, `assert_not_contains`, `assert_matches`.
- `tests/codex-plugin-sync/test-sync-to-codex-plugin.sh:138-156` — temp cleanup and fixture git identity pattern.
- `scripts/install-to-claude.sh:21-36` — existing prototype behavior to supersede: repo root detection, `skills` source, per-skill copy loop.

**Files:**
- Create: `tests/private-installer/test-superpowers-installer.sh`

**Existing Code Anchors:**
- `tests/codex-plugin-sync/test-sync-to-codex-plugin.sh:14-87` — copy assertion helper style; keep output consistent with existing shell tests.
- `tests/codex-plugin-sync/test-sync-to-codex-plugin.sh:138-156` — copy cleanup and temp repo setup style.
- `scripts/install-to-claude.sh:21-36` — current narrow copy behavior; new tests must prove the new CLI covers this behavior and adds missing safety.

**Test Cases To Implement:**
1. `install --harness claude --scope user` with `HOME=$TEST_ROOT/home` copies every `skills/*/SKILL.md` into `$HOME/.claude/skills/<skill>/SKILL.md`.
2. `install --harness codex --scope user` copies every `skills/*/SKILL.md` into `$HOME/.codex/skills/<skill>/SKILL.md`.
3. `install --harness all --scope user` creates `$HOME/.superpowers-refined/install-state.json` and records both `claude` and `codex` entries.
4. Running the same install twice emits `OK` lines and leaves state valid.
5. Editing a managed installed file, then running `update --harness claude`, creates a backup under `$HOME/.superpowers-refined/backups/` and restores the repo copy.
6. Editing a managed installed file, then running `update --harness claude --strict`, exits non-zero, preserves the edited target, and emits `ERROR`.
7. Editing a managed installed file, then running `update --harness claude --keep-local`, exits zero, preserves the edited target, and emits `WARN`.
8. If `$HOME/.claude/skills` is a symlink, install backs up the symlink and creates a real directory before copying skills.
9. `install --harness all --scope project --project-dir "$PROJECT"` writes project skills under `$PROJECT/.claude/skills` and `$PROJECT/.codex/skills`, and writes `$PROJECT/.superpowers/install-state.json`.
10. `doctor` exits zero after a healthy install and prints `OK`.
11. Removing an installed managed file makes `doctor` print `WARN` and exit non-zero.
12. The installer never invokes `scripts/sync-to-codex-plugin.sh`. Use a fixture by temporarily moving or shadowing that script with a failing executable in a copied test repo, then assert install/update still pass.
13. User install creates `$HOME/.superpowers-refined/config.json` from `config/superpowers-defaults.json` when missing.
14. User update preserves a locally edited `$HOME/.superpowers-refined/config.json`.
15. Project install creates `$PROJECT/.superpowers/config.json` and preserves local edits on update.

**Implementation Steps:**
- Create `tests/private-installer/`.
- Write `test-superpowers-installer.sh` with `set -euo pipefail`.
- Copy the assertion helper functions from `tests/codex-plugin-sync/test-sync-to-codex-plugin.sh:14-87`.
- Add `TEST_ROOT="$(mktemp -d)"` and `trap cleanup EXIT`.
- Set `HOME="$TEST_ROOT/home"` for all installer invocations so tests cannot touch the real home directory.
- Use the real repo checkout as `REPO_ROOT`; do not copy the whole repo unless a test needs a fixture.
- For each test case, run `"$REPO_ROOT/scripts/superpowers" ...` and assert filesystem state and output.
- At the end, print a failure count and exit `1` if any assertion failed, following the existing shell test style.

**Acceptance Criteria:**
- [ ] Test file exists and is executable.
- [ ] Tests cover Claude user install, Codex user install, all-harness install, project install, agent effort config creation/preservation, update conflicts, strict mode, keep-local mode, symlink replacement, doctor health, doctor warning, and marketplace sync exclusion.
- [ ] Tests use temp HOME and do not write to real `~/.claude`, `~/.codex`, or `~/.superpowers-refined`.
- [ ] Running the tests before implementation fails because `scripts/superpowers` does not exist yet.

**Verify:**

```bash
chmod +x tests/private-installer/test-superpowers-installer.sh
tests/private-installer/test-superpowers-installer.sh
```

Expected before implementation: non-zero exit with failure mentioning missing `scripts/superpowers`.

**Commit:** `test(installer): define private installer behavior`

---

### Task 2: Create CLI Skeleton And Argument Parsing

**Type:** Implementation

**Goal:** Add the `scripts/superpowers` entrypoint with stable commands and option validation, without implementing file mutation yet.

**References (paste into implementer prompt):**
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:22-29` — one command, bootstrap command, and copy-based install decision.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:51-59` — required command shapes.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:74-76` — stable log prefixes and no marketplace sync during normal commands.

**Files:**
- Create: `scripts/superpowers`
- Modify: `tests/private-installer/test-superpowers-installer.sh`

**Existing Code Anchors:**
- `scripts/install-to-claude.sh:21-23` — existing repo root and destination concept; replace with Python equivalents.
- `tests/private-installer/test-superpowers-installer.sh` from Task 1 — update only expectations that depended on the command being missing.

**Implementation Steps:**
- Create `scripts/superpowers` with shebang `#!/usr/bin/env python3`.
- Use only Python standard library modules: `argparse`, `dataclasses`, `datetime`, `hashlib`, `json`, `os`, `pathlib`, `shutil`, `subprocess`, `sys`.
- Implement argparse subcommands:
  - `install`
  - `update`
  - `doctor`
- Add shared options:
  - `--harness {claude,codex,all}` with default `all`
  - `--scope {user,project}` with default `user` for `install`; `update` and `doctor` should inspect state by default
  - `--project-dir PATH` defaulting to current working directory when `--scope project`
  - `--strict`
  - `--keep-local`
  - `--repo PATH` defaulting to the detected repo root
- Reject `--strict` and `--keep-local` together with exit code `2` and an `ERROR` line.
- Detect repo root by walking up from `scripts/superpowers` to the parent containing `skills/`.
- Add temporary command handlers that print `OK command parsed` and return zero until later tasks replace them with real behavior.
- Mark the file executable.

**Acceptance Criteria:**
- [ ] `scripts/superpowers --help` works.
- [ ] `scripts/superpowers install --harness all --scope user` exits zero and prints `OK`.
- [ ] `scripts/superpowers install --strict --keep-local` exits non-zero and prints `ERROR`.
- [ ] No command invokes `scripts/sync-to-codex-plugin.sh`.

**Verify:**

```bash
scripts/superpowers --help
scripts/superpowers install --harness all --scope user
if scripts/superpowers install --strict --keep-local; then echo "unexpected success"; exit 1; fi
```

Expected: help text, one `OK` line for valid install parse, non-zero exit for incompatible flags.

**Commit:** `feat(installer): add superpowers CLI skeleton`

---

### Task 3: Implement State Ledger, Hashing, Backups, And Copy Engine

**Type:** Implementation

**Goal:** Build the core file-management engine before wiring harness behavior, so conflict semantics are testable in isolation through the CLI.

**References (paste into implementer prompt):**
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:31-38` — state ledger and conflict-mode decisions.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:60-74` — required record fields, overwrite rules, backup behavior, config creation, missing target handling, stable status prefixes.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:95` — user and project state locations.

**Files:**
- Modify: `scripts/superpowers`
- Modify: `tests/private-installer/test-superpowers-installer.sh`

**Existing Code Anchors:**
- `scripts/superpowers` from Task 2 — extend the CLI in place.
- `scripts/install-to-claude.sh:32-42` — existing per-skill loop deletes unmanaged removed files with `rsync --delete`; replace with ledger-driven stale managed file handling.

**Target Data Shape:**

State file JSON:

```json
{
  "version": 1,
  "sourceRepo": "/absolute/path/to/repo",
  "sourceCommit": "git-sha-or-working-tree",
  "updatedAt": "2026-06-12T00:00:00Z",
  "entries": [
    {
      "harness": "claude",
      "scope": "user",
      "source": "skills/brainstorming/SKILL.md",
      "target": "/tmp/home/.claude/skills/brainstorming/SKILL.md",
      "sourceHash": "sha256...",
      "installedHash": "sha256...",
      "mode": "copy"
    }
  ]
}
```

**Implementation Steps:**
- Add `sha256_file(path)` for file hashes.
- Add `load_state(path)` and `save_state(path, state)` with JSON indentation and stable key order where practical.
- Add `source_commit(repo_root)`:
  - Use `git -C <repo> rev-parse HEAD`.
  - If git is unavailable or the repo is not a checkout, return `"working-tree"`.
- Add `backup_path(state_dir, target_path)` that stores backups under `backups/YYYYmmdd-HHMMSS/<relative-target-path-without-leading-slash>`.
- Add `backup_target(state_dir, target_path)`:
  - If target is a symlink, move the symlink itself into backups; do not copy through it.
  - If target is a file, copy it to backup then delete original.
  - If target is a directory, copy the directory to backup then delete original.
- Add `copy_file_with_conflict_handling(source, target, entry, mode)`:
  - If target does not exist, create parent dirs and copy.
  - If target exists and previous `installedHash` matches current target hash, overwrite.
  - If target exists and differs from previous `installedHash`:
    - `strict`: print `ERROR local modification: <target>` and mark command failed.
    - `keep-local`: print `WARN keeping local modification: <target>` and do not overwrite.
    - default: back up, overwrite, and print `BACKED_UP <target> -> <backup>`.
  - After copying, record new hashes.
- Add stale managed file handling:
  - Compare previous state entries for selected harness/scope with the current desired target list.
  - If a previous target is no longer desired and unchanged from its `installedHash`, delete it and print `CHANGED removed stale managed file: <target>`.
  - If a previous target is no longer desired and locally modified, apply the same strict/keep-local/default backup behavior before deletion.
- Ensure all created files are copies and no new symlinks are created.

**Acceptance Criteria:**
- [ ] State JSON is valid and includes required fields.
- [ ] Local modification detection compares target hash to previous `installedHash`.
- [ ] Default conflict mode backs up then overwrites.
- [ ] `--strict` aborts before overwrite.
- [ ] `--keep-local` preserves modified targets.
- [ ] Symlink target paths are backed up as symlinks and replaced by real directories/files when installing.

**Verify:**

```bash
python3 -m py_compile scripts/superpowers
tests/private-installer/test-superpowers-installer.sh
```

Expected at this stage: syntax passes; tests still fail on harness install behavior not yet wired, but conflict-engine unit coverage embedded in later end-to-end cases can start passing as harness tasks land.

**Commit:** `feat(installer): add state ledger and copy engine`

---

### Task 4: Implement User-Scope Claude And Codex Skill Installs

**Type:** Implementation

**Goal:** Make `install --scope user` and `update --scope user` copy repo skills into Claude and Codex native skill directories with ledger tracking.

**References (paste into implementer prompt):**
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:51-53` — required harness-specific user install commands.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:97-103` — harness notes: adapters over shared `skills/`; no Codex marketplace dependency.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:143-149` — idempotency, source update, conflict behavior, and doctor expectations.

**Files:**
- Modify: `scripts/superpowers`
- Modify: `tests/private-installer/test-superpowers-installer.sh`

**Existing Code Anchors:**
- `scripts/install-to-claude.sh:21-36` — source path and destination defaults to preserve for Claude, with safer implementation.
- Current local observation: `~/.codex/skills` is the Codex native user skill directory; install all repo skills there.
- Current local observation: `~/.claude/skills` can be a symlink; the installer must replace symlink targets instead of copying through them.

**Implementation Steps:**
- Add `discover_skill_sources(repo_root)`:
  - Enumerate immediate child directories of `repo_root / "skills"`.
  - Include only directories containing `SKILL.md`.
  - Include all files under each included skill directory, not only `SKILL.md`.
- Add user destination resolution:
  - Claude: `CLAUDE_SKILLS_DIR` if set, else `$HOME/.claude/skills`.
  - Codex: `CODEX_SKILLS_DIR` if set, else `$HOME/.codex/skills`.
- Implement `desired_entries_for_harness(harness, scope="user")`:
  - For each source file under each skill directory, map to `<dest>/<skill-name>/<relative-file-under-skill>`.
  - Use `scope: "user"` and `mode: "copy"` in every entry.
- Implement `install`:
  - Resolve harness list: `all` expands to `claude`, `codex`.
  - For each harness, copy desired entries through the copy engine.
  - Write `~/.superpowers-refined/install-state.json`.
  - Print one summary line per harness: `OK claude user install complete: <count> file(s) managed`.
- Implement `update` for user scope:
  - If `~/.superpowers-refined/repo/.git` exists and the command is being run from that managed repo, run `git pull --ff-only` before copying.
  - If not running from a managed repo, do not pull; print `WARN update source is current checkout; skipping git pull`.
  - Reuse install copy behavior.
- Do not edit `~/.claude/plugins`, `~/.codex/plugins`, `~/.codex/.tmp/plugins`, `~/.claude/CLAUDE.md`, or `~/.codex/AGENTS.md`.

**Acceptance Criteria:**
- [ ] Claude user install copies all repo skill files into `$HOME/.claude/skills`.
- [ ] Codex user install copies all repo skill files into `$HOME/.codex/skills`.
- [ ] `--harness all` installs both.
- [ ] Install state records both harnesses separately.
- [ ] Re-running install is idempotent.
- [ ] Existing non-managed skills in the destination remain untouched.
- [ ] Removed source files are removed from managed destinations on update only if they were previously managed.
- [ ] No marketplace sync script or plugin cache is touched.

**Verify:**

```bash
python3 -m py_compile scripts/superpowers
tests/private-installer/test-superpowers-installer.sh
```

Expected: user-scope skill install and update tests pass; project-scope and agent-effort config tests may still fail until Tasks 6 and 7.

**Commit:** `feat(installer): install Claude and Codex user skills`

---

### Task 5: Implement Conflict Modes, Symlink Replacement, And Doctor

**Type:** Implementation

**Goal:** Finish safety behavior around local edits, symlink destinations, backups, and health reporting.

**References (paste into implementer prompt):**
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:60-74` — ledger fields, conflict handling, config creation, missing targets, overrides, stable status prefixes.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:105-116` — override precedence and preservation.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:145-153` — acceptance signals for update conflicts, doctor, override survival, and config preservation.

**Files:**
- Modify: `scripts/superpowers`
- Modify: `tests/private-installer/test-superpowers-installer.sh`

**Existing Code Anchors:**
- `scripts/superpowers` from Tasks 2-4 — copy engine and user install handlers to extend.
- Current local observation: `~/.claude/skills` may be a symlink; test fixture must create the same condition with temp HOME.

**Implementation Steps:**
- Ensure the copy engine checks each parent path component before writing:
  - If the final destination directory, such as `$HOME/.claude/skills`, is a symlink and it is not already recorded as a managed file, back up the symlink itself, unlink it, create a real directory, and print `BACKED_UP symlink`.
  - Do not follow symlinks when backing up.
- Implement `doctor`:
  - Load user state from `~/.superpowers-refined/install-state.json`.
  - For each selected harness entry, check target existence and current hash.
  - Print `OK managed file current: <target>` for current files when verbose output is acceptable.
  - Print `WARN missing managed file: <target>` for missing files.
  - Print `WARN locally modified managed file: <target>` for hash mismatch.
  - Print `OK overrides: <path>` for `~/.superpowers-refined/overrides/<harness>` if present, otherwise `OK overrides absent: <path>`.
  - Exit zero only when no missing or locally modified managed files are found.
- Add a concise default `doctor` summary so normal output is not thousands of lines:
  - `OK claude user: <count> managed file(s) current`
  - `WARN claude user: <n> issue(s)`
- Preserve override directories:
  - Create `~/.superpowers-refined/overrides/claude` and `~/.superpowers-refined/overrides/codex` during user install if missing.
  - Never delete files below `overrides/`.

**Acceptance Criteria:**
- [ ] Symlink destination path is backed up and replaced by a real directory.
- [ ] Default update backs up local edits and overwrites.
- [ ] `--strict` exits non-zero and preserves local edits.
- [ ] `--keep-local` exits zero and preserves local edits.
- [ ] `doctor` exits zero on a healthy install.
- [ ] `doctor` exits non-zero and prints `WARN` for missing or locally modified managed files.
- [ ] Override directories are created and preserved.

**Verify:**

```bash
python3 -m py_compile scripts/superpowers
tests/private-installer/test-superpowers-installer.sh
```

Expected: user-scope, conflict-mode, symlink, override, and doctor tests pass; project-scope and agent-effort config tests may still fail until Tasks 6 and 7.

**Commit:** `feat(installer): add conflict modes and doctor`

---

### Task 6: Implement Project-Scope Installs

**Type:** Implementation

**Goal:** Add project-local installs that do not affect user state and can be version-controlled or inspected per project.

**References (paste into implementer prompt):**
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:54` — project install command requirement.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:66-73` — unmanaged override/config preservation and project customization protection.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:95` — project state location.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:150-153` — project state isolation, override survival, and config preservation.

**Files:**
- Modify: `scripts/superpowers`
- Modify: `tests/private-installer/test-superpowers-installer.sh`

**Existing Code Anchors:**
- `scripts/superpowers` user-scope destination resolution from Task 4 — copy the structure, but resolve under project paths.

**Project Destination Rules:**
- Claude project skills destination: `<project>/.claude/skills`.
- Codex project skills destination: `<project>/.codex/skills`.
- Project state: `<project>/.superpowers/install-state.json`.
- Project overrides:
  - `<project>/.superpowers/overrides/claude`
  - `<project>/.superpowers/overrides/codex`

**Implementation Steps:**
- Add project destination resolution:
  - Require `--project-dir` or default to `Path.cwd()` when `--scope project`.
  - Require the project directory to already exist. Do not create arbitrary new project roots. If `--project-dir` does not exist, print `ERROR project dir does not exist` and exit non-zero.
- Reuse the same desired-entry generation as user scope with project destinations.
- Read and write project state only at `<project>/.superpowers/install-state.json`.
- Ensure project install never reads or writes `~/.superpowers-refined/install-state.json`.
- Create project override directories and preserve their contents.
- Implement `doctor --scope project --project-dir "$PROJECT"` using project state only.
- Keep `update --scope project` as a refresh from the current repo checkout; do not run `git pull` inside the target project.

**Acceptance Criteria:**
- [ ] Project install copies all repo skills to `<project>/.claude/skills` and `<project>/.codex/skills`.
- [ ] Project install writes `<project>/.superpowers/install-state.json`.
- [ ] Project install does not create or modify user state.
- [ ] Project override directories are created and preserved.
- [ ] Project `doctor` checks project state and exits according to project-managed files only.
- [ ] Nonexistent `--project-dir` exits non-zero with `ERROR`.

**Verify:**

```bash
python3 -m py_compile scripts/superpowers
tests/private-installer/test-superpowers-installer.sh
```

Expected: all installer tests except agent-effort config tests pass.

**Commit:** `feat(installer): support project-scope installs`

---

### Task 7: Add Agent Effort Defaults And Workflow Skill Support

**Type:** Implementation / Skill Update

**Goal:** Make the default reasoning effort for each spawned-agent role configurable and install/preserve that config at user and project scope.

**References (paste into implementer prompt):**
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:43-44` — decision to add version-controlled agent effort defaults.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:67-72` — requirements for role defaults, installed config files, non-overwrite behavior, and harness fallback.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:118-139` — exact config paths, precedence, role keys, and allowed `model` / `reasoningEffort` fields.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:152-153` — acceptance signals for config creation/preservation and skill support.
- `skills/subagent-driven-development/SKILL.md:194-200` — current hardcoded model-selection guidance to replace with config-aware guidance.
- `skills/requesting-code-review/SKILL.md:32-34` — standalone code-review subagent dispatch guidance that should reference the config convention.

**Files:**
- Create: `config/superpowers-defaults.json`
- Create: `skills/using-superpowers/references/agent-effort-config.md`
- Modify: `scripts/superpowers`
- Modify: `tests/private-installer/test-superpowers-installer.sh`
- Modify: `skills/subagent-driven-development/SKILL.md`
- Modify: `skills/requesting-code-review/SKILL.md`

**Existing Code Anchors:**
- `scripts/superpowers` project/user state handling from Tasks 4-6 — extend this path to create config files without overwriting local edits.
- `skills/subagent-driven-development/SKILL.md:194-200` — replace hardcoded defaults with config lookup + fallback defaults.
- `skills/requesting-code-review/SKILL.md:32-34` — add one instruction to consult code-review role defaults before dispatch.

**Default Config Shape:**

Create `config/superpowers-defaults.json` with this exact initial content:

```json
{
  "version": 1,
  "agentDefaults": {
    "implementer": { "reasoningEffort": "medium" },
    "specReviewer": { "reasoningEffort": "medium" },
    "codeQualityReviewer": { "reasoningEffort": "medium" },
    "uxReviewer": { "reasoningEffort": "medium" },
    "qualityGateReviewer": { "reasoningEffort": "xhigh" },
    "qualityGateFixer": { "reasoningEffort": "high" },
    "exploration": { "reasoningEffort": "medium" },
    "planReviewer": { "reasoningEffort": "medium" },
    "specDocumentReviewer": { "reasoningEffort": "medium" }
  }
}
```

Do not include `model` values in the default config yet. The schema supports `model`, but this private fork should start by configuring effort only.

**Runtime Convention To Document:**

Create `skills/using-superpowers/references/agent-effort-config.md` explaining:

- Config lookup order:
  1. `<project>/.superpowers/config.json` when working in a project that has it
  2. `~/.superpowers-refined/config.json`
  3. repo default config shipped with the installed skills, when discoverable
  4. hardcoded skill fallback defaults
- Role keys are the keys from `agentDefaults`.
- `reasoningEffort` values are harness-specific; Codex should map them to `reasoning_effort` when spawning agents.
- If a harness cannot apply a field, continue with the closest available default and report the limitation only when it materially affects the task.
- Project config overrides user config by role key. Missing role keys fall back to user/default config.

**Implementation Steps:**
- Add `config/superpowers-defaults.json`.
- Update installer tests from Task 1 so config-related tests assert:
  - User install creates `$HOME/.superpowers-refined/config.json` with valid JSON and an `agentDefaults.implementer.reasoningEffort` value.
  - User update preserves a modified `$HOME/.superpowers-refined/config.json`.
  - Project install creates `$PROJECT/.superpowers/config.json`.
  - Project update preserves a modified `$PROJECT/.superpowers/config.json`.
- In `scripts/superpowers`, add `ensure_config(scope, project_dir)`:
  - User path: `$HOME/.superpowers-refined/config.json`
  - Project path: `<project>/.superpowers/config.json`
  - If target exists, do not overwrite it. Print `OK config preserved: <path>`.
  - If target is missing, copy `config/superpowers-defaults.json` to target. Print `CHANGED config created: <path>`.
- Call `ensure_config` during `install` and `update` for both user and project scope.
- Add `doctor` checks:
  - If config exists and parses as JSON, print `OK config valid: <path>`.
  - If config is missing, print `WARN config missing: <path>` and exit non-zero.
  - If config is invalid JSON, print `WARN config invalid: <path>` and exit non-zero.
- Update `skills/subagent-driven-development/SKILL.md` model-selection section:
  - Tell orchestrators to consult `skills/using-superpowers/references/agent-effort-config.md` before spawning implementer, spec reviewer, code quality reviewer, UX reviewer, Quality Gate reviewer, and fixer agents.
  - Preserve the current fallback defaults: medium for normal roles, xhigh for Quality Gate reviewer, high for Quality Gate fixer.
  - State that explicit human instructions override config.
- Update `skills/requesting-code-review/SKILL.md` dispatch section:
  - Before dispatching a standalone code reviewer, consult the agent effort config and use `codeQualityReviewer.reasoningEffort` when the harness supports it.
  - Fall back to medium effort if config is missing or unsupported.

**Acceptance Criteria:**
- [ ] Default config exists at `config/superpowers-defaults.json`.
- [ ] User install/update creates missing config and preserves existing config.
- [ ] Project install/update creates missing config and preserves existing config.
- [ ] `doctor` reports valid/missing/invalid config.
- [ ] `subagent-driven-development` documents config lookup and fallback effort defaults.
- [ ] `requesting-code-review` documents config lookup for standalone code review dispatch.
- [ ] Tests cover config creation and preservation.

**Verify:**

```bash
python3 -m py_compile scripts/superpowers
python3 -m json.tool config/superpowers-defaults.json >/dev/null
tests/private-installer/test-superpowers-installer.sh
rg -n "agent-effort-config|agentDefaults|qualityGateReviewer|reasoningEffort" config skills scripts tests README.md
```

Expected: Python compiles, JSON validates, all installer tests pass, and config references appear in defaults, installer/tests, and spawning workflow skills.

**Commit:** `feat(installer): add configurable agent effort defaults`

---

### Task 8: Replace The Narrow Claude Prototype And Update Docs

**Type:** Documentation / Cleanup

**Goal:** Make the private installer the documented path and remove the narrow Claude-only script if it exists in the implementation worktree.

**References (paste into implementer prompt):**
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:19-29` — private package, one command, bootstrap, copy mode.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:78-86` — non-goals: no marketplace publishing, no unauthenticated fallback, only Claude/Codex in first implementation.
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:118-139` — agent effort config paths, precedence, and role keys to document.
- `README.md:41-162` — current installation section to replace or sharply demote for this private fork.
- `scripts/install-to-claude.sh:1-17` — old script description; it is superseded by `scripts/superpowers`.

**Files:**
- Modify: `README.md`
- Delete: `scripts/install-to-claude.sh` if present in the implementation worktree
- Leave unchanged: `scripts/sync-to-codex-plugin.sh`

**Existing Code Anchors:**
- `README.md:41-162` — marketplace-first install docs that no longer match this private fork's primary workflow.
- `scripts/install-to-claude.sh:1-17` — old usage docs; do not leave this as a parallel recommended path.

**Implementation Steps:**
- Replace the README `## Installation` section with private-fork instructions:
  - Fresh machine:
    ```bash
    gh repo clone mlk1278/superpowers-refined ~/.superpowers-refined/repo
    ~/.superpowers-refined/repo/scripts/superpowers install --harness all --scope user
    ```
  - Existing checkout:
    ```bash
    ./scripts/superpowers install --harness all --scope user
    ```
  - Update:
    ```bash
    ~/.superpowers-refined/repo/scripts/superpowers update --harness all
    ```
  - Doctor:
    ```bash
    ~/.superpowers-refined/repo/scripts/superpowers doctor
    ```
  - Project install:
    ```bash
    ./scripts/superpowers install --harness all --scope project --project-dir /path/to/project
    ```
- Add a short "Conflict handling" subsection documenting:
  - default backup then overwrite
  - `--strict`
  - `--keep-local`
  - backup location
- Add an "Overrides" subsection documenting:
  - `~/.superpowers-refined/overrides/<harness>/`
  - `<project>/.superpowers/overrides/<harness>/`
  - managed installed files should not be manually edited.
- Add an "Agent effort defaults" subsection documenting:
  - User config: `~/.superpowers-refined/config.json`
  - Project config: `<project>/.superpowers/config.json`
  - Role defaults live under `agentDefaults`
  - Project config overrides user config by role key
  - Update preserves local config edits
- Move old marketplace instructions under a clearly secondary heading like `## Legacy Marketplace Notes`, or remove them entirely if they do not apply to this private fork.
- If `scripts/install-to-claude.sh` exists in the implementation worktree, delete it so there is one supported installer path.
- Leave `scripts/sync-to-codex-plugin.sh` unchanged; normal install and update must simply avoid invoking it.

**Acceptance Criteria:**
- [ ] README leads with private-fork `gh` bootstrap and `scripts/superpowers`.
- [ ] README documents install, update, doctor, project install, conflict modes, overrides, and agent effort defaults.
- [ ] Marketplace docs are removed or clearly marked non-primary legacy notes.
- [ ] No docs recommend `scripts/install-to-claude.sh`.
- [ ] If `scripts/install-to-claude.sh` exists, it is removed.

**Verify:**

```bash
rg -n "install-to-claude|official .*marketplace|/plugin install superpowers|official Codex plugin marketplace" README.md scripts || true
test ! -e scripts/install-to-claude.sh
```

Expected: no recommendation of the old Claude script; marketplace references are absent or clearly legacy; `scripts/install-to-claude.sh` absent.

**Commit:** `docs(installer): document private install workflow`

---

### Task 9: Final Installer Quality Gate

**Type:** Quality Gate

**Goal:** Verify the installer is complete, scoped, and safe before calling implementation done.

**References (paste into implementer prompt):**
- `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md:141-154` — acceptance signals for final verification.
- `docs/superpowers/plans/2026-06-12-private-dev-environment-installer.md` — this plan; verify all task acceptance criteria were completed.

**Files:**
- Read: `scripts/superpowers`
- Read: `config/superpowers-defaults.json`
- Read: `tests/private-installer/test-superpowers-installer.sh`
- Read: `skills/using-superpowers/references/agent-effort-config.md`
- Read: `skills/subagent-driven-development/SKILL.md`
- Read: `skills/requesting-code-review/SKILL.md`
- Read: `README.md`
- Read: `docs/superpowers/specs/2026-06-12-private-dev-environment-installer-spec.md`

**Surface Under Review:**
- CLI behavior: `scripts/superpowers install|update|doctor`
- User-scope installs for Claude and Codex
- Project-scope installs for Claude and Codex
- State ledger, backups, conflict modes, symlink replacement
- Agent effort config defaults, install preservation, and skill-runtime documentation
- README installation/update documentation

**Risk Areas:**
- Accidentally touching real home directories during tests.
- Following symlinks instead of backing them up.
- Deleting unmanaged personal skills.
- Treating project state and user state as the same state.
- Running marketplace sync during install/update.
- Overwriting local edits without backup.
- Overwriting local agent effort config during update.
- Leaving spawned-agent effort defaults hardcoded with no config convention.

**Verification Evidence To Provide:**
- `python3 -m py_compile scripts/superpowers`
- `python3 -m json.tool config/superpowers-defaults.json >/dev/null`
- `tests/private-installer/test-superpowers-installer.sh`
- `git diff --stat`
- `git status --short`
- Manual review summary confirming:
  - no symlink creation
  - no marketplace sync invocation from `scripts/superpowers`
  - no writes to `~/.claude/plugins`, `~/.codex/plugins`, user `CLAUDE.md`, or user `AGENTS.md`
  - user/project config files are created only when missing and preserved on update

**Acceptance Criteria:**
- [ ] All installer tests pass.
- [ ] CLI compiles with Python.
- [ ] Default effort config validates as JSON.
- [ ] README documents the private workflow.
- [ ] Implementation remains stdlib-only.
- [ ] Dirty status contains only intended files.
- [ ] Any pre-existing unrelated dirty files are left untouched.

**Verify:**

```bash
python3 -m py_compile scripts/superpowers
python3 -m json.tool config/superpowers-defaults.json >/dev/null
tests/private-installer/test-superpowers-installer.sh
git diff --stat
git status --short
```

Expected: compile succeeds, tests pass, diff contains only installer/test/docs changes plus any pre-existing unrelated user changes.

**Commit:** `test(installer): verify private installer workflow`

---

## Self-Review Notes

- Spec coverage: Tasks cover one-command CLI, copy mode, ledger, backups, conflict flags, user/project scope, doctor, overrides, no marketplace sync, docs, and final gate.
- No UX gate: This is CLI/docs work, not a frontend surface.
- Final Quality Gate included because this is code-bearing work.
- Implementation should start only after approval and isolated workspace setup. Current planning occurred in the existing checkout because the spec file was newly created here and the worktree contained unrelated local changes.
