# Private Dev Environment Installer Spec

**Status:** Approved
**Linear:** None
**Branch / Worktree:** Not created yet; create before implementation planning

## Goal

Make this private fork the version-controlled source of truth for installing and updating Superpowers-based development environment support across local machines and cloud VMs. A fresh machine with authenticated `gh` access should be able to install or update Claude Code and Codex support with one command, using copied managed files and explicit local override paths rather than symlinks or marketplace publishing.

## Context

The repo currently contains shared skills in `skills/`, Claude plugin metadata in `.claude-plugin/`, Codex plugin metadata in `.codex-plugin/`, shared Claude/Cursor hooks in `hooks/`, OpenCode plugin code, and a `scripts/sync-to-codex-plugin.sh` script for external Codex marketplace sync. This fork is private and is not intended to publish to official marketplaces. The operational need is reproducible agentic development environments across many systems, including cloud VMs. Symlinks are not reliable for the target environments, so install/update must work by copying managed files.

Every target machine is expected to have `gh` installed, authenticated, and authorized to read this private fork. The installer can rely on `gh` for bootstrap and repository updates.

## Decisions

- Decision: Treat this repo as a private dev-environment package, not a marketplace plugin source.
- Rationale: The primary workflow is installing and updating controlled environments from a private fork.

- Decision: Provide one primary command, `scripts/superpowers`, with `install`, `update`, and `doctor` subcommands.
- Rationale: Cloud VM setup and local maintenance need one repeatable entrypoint.

- Decision: Document a single-command fresh-machine bootstrap using `gh repo clone mlk1278/superpowers-refined ~/.superpowers-refined/repo && ~/.superpowers-refined/repo/scripts/superpowers install --harness all --scope user`.
- Rationale: A machine with only authenticated `gh` still needs a one-line setup path before the repo exists locally.

- Decision: Use copy-based installs by default.
- Rationale: Symlinks do not work for most target environments and make cloud VM snapshots harder to reason about.

- Decision: Maintain an install state ledger under `~/.superpowers-refined/install-state.json`.
- Rationale: Updates need to know which files are managed, what source commit installed them, and whether targets were locally modified.

- Decision: On update, default to backing up locally modified managed files and overwriting them.
- Rationale: Automated machine setup should converge by default while still preserving unexpected local edits.

- Decision: Support stricter conflict modes with flags.
- Rationale: Human-maintained machines may prefer aborting or preserving local edits instead of overwriting.

- Decision: Keep user and project overrides outside generated managed files.
- Rationale: Manual customization must survive updates without requiring merges against generated copies.

- Decision: Add a version-controlled agent effort defaults file and install user/project copies that can be locally overridden.
- Rationale: Agentic development cost and quality depend heavily on per-role effort defaults; the dev environment should make those defaults reproducible and easy to tune.

- Decision: Make marketplace/export scripts explicit legacy or export paths.
- Rationale: Existing scripts can remain useful, but normal install/update should not imply marketplace publishing.

## Requirements

- `scripts/superpowers install --harness all --scope user` installs or refreshes user-level Claude Code and Codex support from the current repo checkout.
- `scripts/superpowers install --harness claude --scope user` installs only Claude Code support.
- `scripts/superpowers install --harness codex --scope user` installs only Codex support.
- `scripts/superpowers install --harness all --scope project` installs project-level support into the current project where the harness supports repo-local configuration.
- `scripts/superpowers update --harness all` updates the managed repo checkout when applicable, then refreshes installed managed files for all installed harnesses.
- `scripts/superpowers doctor` reports installed harnesses, target paths, source commit, stale files, missing files, local modifications, and override paths.
- Fresh machine setup is documented as one shell command:
  `gh repo clone mlk1278/superpowers-refined ~/.superpowers-refined/repo && ~/.superpowers-refined/repo/scripts/superpowers install --harness all --scope user`.
- Installs copy files, not symlinks.
- The installer records each managed target with source path, target path, source commit, installed hash, install mode, scope, and harness.
- If a managed target is unchanged from the previous installed hash, update may overwrite it directly.
- If a managed target differs from the previous installed hash, update backs it up under `~/.superpowers-refined/backups/` and overwrites it by default.
- `--strict` aborts before overwriting any locally modified managed target.
- `--keep-local` skips locally modified managed targets and reports them.
- Missing managed targets are reinstalled.
- Unknown unmanaged files in override paths are never deleted.
- The repo provides default agent effort settings for workflow roles such as implementer, spec reviewer, code quality reviewer, UX reviewer, Quality Gate reviewer, and fixer agents.
- User-scope install creates `~/.superpowers-refined/config.json` from repo defaults if it does not already exist.
- Project-scope install creates `<project>/.superpowers/config.json` from repo defaults if it does not already exist.
- Install and update must not overwrite an existing user or project config file unless a future explicit reset flag is added.
- Superpowers workflow skills that spawn agents must read the effort config convention before dispatching and use configured role defaults when the harness supports effort/model overrides.
- If a harness cannot apply a configured effort field, the skill should continue with the closest available default and report the limitation only when it materially affects the task.
- Project-level installation must not overwrite repository-specific customizations unless they are managed files recorded in that project's install state.
- The installer must emit line-oriented summaries suitable for VM setup logs, with stable status prefixes such as `OK`, `WARN`, `CHANGED`, `BACKED_UP`, and `ERROR`.
- Bootstrap may assume `gh` is authenticated and may fail clearly if it is not.
- Existing marketplace sync behavior must not run as part of install or update.

## Non-Goals

- No official marketplace publishing flow.
- No support for machines without authenticated `gh`.
- No symlink-based primary install path.
- No automatic merge of customized project-level skill files.
- No management of unrelated shell, editor, package manager, SSH, or OS-level dotfiles.
- No support for harnesses beyond Claude Code and Codex in the first implementation.
- No network fallback to unauthenticated `curl` installs.
- No plugin manager, daemon, package format, dependency resolver, or multi-repo orchestration. This is a copier/updater for version-controlled markdown/config files with hash-based conflict handling.

## Lifecycle Notes

The installer has two operating modes:

- Checkout mode: run `scripts/superpowers` from an existing clone of this private fork.
- Managed repo mode: bootstrap or update a clone at `~/.superpowers-refined/repo` using `gh`.

The user-level state directory is `~/.superpowers-refined/`. It stores install state, backups, a managed repo checkout, and optional user-level overrides. Project-level state lives under `<project>/.superpowers/install-state.json` so different projects can be managed independently.

## Harness Notes

Claude Code support should install the plugin metadata, hook configuration, hook scripts, shared skills, and Claude-specific bootstrap or instruction files needed for the harness to discover and load Superpowers.

Codex support should install the Codex plugin metadata, shared skills, Codex-specific tool mapping and instructions, and any required Codex user or project configuration. Codex installation should not rely on marketplace sync.

Harness-specific files should be treated as adapters over the shared `skills/` source of truth. Skills should not be duplicated per harness unless a harness requires a generated copy at install time.

## Override Notes

Default precedence:

1. Shared repo defaults
2. Harness-specific repo defaults
3. User overrides in `~/.superpowers-refined/overrides/<harness>/`
4. Project overrides in `<project>/.superpowers/overrides/<harness>/`

Managed files should include a generated-file marker when the target format allows comments. Users should put manual changes in override paths, not in managed installed files.

The first implementation only needs to preserve and report overrides. It does not need a complex merge system.

## Agent Effort Config Notes

The repo default config should live at `config/superpowers-defaults.json`. Installed copies live at:

- User: `~/.superpowers-refined/config.json`
- Project: `<project>/.superpowers/config.json`

Project config overrides user config for project-scope work. Missing keys fall back to repo defaults.

Initial role keys:

- `implementer`
- `specReviewer`
- `codeQualityReviewer`
- `uxReviewer`
- `qualityGateReviewer`
- `qualityGateFixer`
- `exploration`
- `planReviewer`
- `specDocumentReviewer`

Each role can define `model`, `reasoningEffort`, or both. The first implementation may use `reasoningEffort` only and preserve `model` for future harnesses.

## Acceptance Signals

- On a clean machine with authenticated `gh`, one command can clone or use the repo and install both Claude Code and Codex support at user scope.
- Running the install command twice is idempotent when no targets changed locally.
- Updating after a source file changes refreshes the installed copy and updates the state ledger.
- Updating after a managed installed file is locally edited creates a backup and overwrites by default.
- `--strict` detects the same local edit and exits without overwriting.
- `--keep-local` detects the same local edit, preserves it, and reports the skipped file.
- `doctor` reports healthy installs and flags missing, stale, and locally modified managed files.
- Project-scope install does not modify user-scope install state.
- User and project override directories survive install and update.
- User and project agent effort config files are created on first install and preserved on update.
- Workflow skills that spawn agents document and use the agent effort config convention.
- Existing Codex marketplace sync script does not run during install or update.

## Planning Notes

Likely implementation task groups:

- Define install source and target layout for Claude Code and Codex.
- Implement the `scripts/superpowers` CLI and argument parsing.
- Implement hash, backup, state ledger, and conflict handling.
- Implement user-scope install/update/doctor for Claude Code.
- Implement user-scope install/update/doctor for Codex.
- Implement project-scope install behavior for supported harness configuration.
- Add agent effort defaults and update spawning workflow skills to honor them.
- Update README/private fork docs and demote marketplace language.
- Add shell tests using temporary HOME and project directories.

Risks:

- Harness config paths may differ by platform or installed harness version.
- Codex plugin/project configuration should be verified against current local Codex behavior before finalizing target paths.
- Claude Code plugin install expectations may require preserving existing `.claude-plugin` shape even if marketplace publishing is not used.
- Copy-based installs can drift without accurate state tracking, so hash ledger tests are critical.

Discovery commands to rerun during planning:

```bash
find .claude-plugin .codex-plugin hooks skills -maxdepth 4 -type f | sort
rg -n "CLAUDE_PLUGIN_ROOT|CODEX|codex|plugin|skills|hooks|override" README.md docs scripts hooks skills .codex-plugin .claude-plugin
```
