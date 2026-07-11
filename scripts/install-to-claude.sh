#!/usr/bin/env bash
#
# install-to-claude.sh
#
# Install/update this checkout's skills into ~/.claude/skills (the Claude Code
# global skills directory). Each repo skill directory fully overwrites its
# destination (files removed from the repo skill are removed from the
# destination too). Skills that exist only in ~/.claude/skills — personal
# skills not managed by this repo — are left untouched.
#
# Usage:
#   ./scripts/install-to-claude.sh        # install/update all skills
#   ./scripts/install-to-claude.sh -n     # dry run (show what would change)
#
# Destination override: CLAUDE_SKILLS_DIR=/path ./scripts/install-to-claude.sh
#
# Requires: bash, rsync.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/skills"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

DRY_RUN=()
if [[ "${1:-}" == "-n" || "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=(-n)
fi

mkdir -p "$DEST"

updated=0
for dir in "$SRC"/*/; do
  name="$(basename "$dir")"
  [[ -f "$dir/SKILL.md" ]] || continue
  changes="$(rsync -a --delete --itemize-changes "${DRY_RUN[@]}" "$dir" "$DEST/$name/")"
  if [[ -n "$changes" ]]; then
    echo "== $name"
    sed 's/^/   /' <<<"$changes"
    updated=$((updated + 1))
  fi
done

echo
if (( updated == 0 )); then
  echo "All repo skills already up to date in $DEST"
elif (( ${#DRY_RUN[@]} )); then
  echo "Dry run: $updated skill(s) would be updated in $DEST"
else
  echo "Updated $updated skill(s) in $DEST"
fi
