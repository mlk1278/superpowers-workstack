#!/usr/bin/env python3
"""Reject unlisted changes to skills inherited from upstream."""

import argparse
import json
import subprocess
import sys
from pathlib import Path


def git(cwd: Path, *args: str) -> str:
    result = subprocess.run(
        ["git", *args],
        cwd=cwd,
        check=False,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip())
    return result.stdout


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Check protected upstream skill files against the divergence allowlist."
    )
    parser.add_argument("--ref", default="HEAD", help="Git ref to compare (default: HEAD)")
    args = parser.parse_args()

    try:
        repo_root = Path(git(Path.cwd(), "rev-parse", "--show-toplevel").strip())
        config = json.loads(
            (repo_root / "workstack/upstream-divergences.json").read_text()
        )
        baseline = config["baseline"]
        allowlisted = {entry["path"] for entry in config["divergences"]}

        protected = set(
            git(
                repo_root,
                "ls-tree",
                "-r",
                "--name-only",
                baseline,
                "--",
                "skills/",
            ).splitlines()
        )
        changed = set(
            git(
                repo_root,
                "diff",
                "--name-only",
                "--no-renames",
                "--diff-filter=MDT",
                baseline,
                args.ref,
                "--",
                "skills/",
            ).splitlines()
        )
    except (OSError, KeyError, TypeError, json.JSONDecodeError, RuntimeError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 2

    violations = sorted((changed & protected) - allowlisted)
    if violations:
        print("Unallowlisted changes to upstream-owned skills:", file=sys.stderr)
        for path in violations:
            print(f"  {path}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
