# Updating from upstream

Update the fork from an upstream Superpowers release tag, then verify every maintained divergence and wrapper against that release.

1. Start from a clean fork branch and fetch upstream, including release tags:

   ```bash
   git fetch upstream --tags
   ```

2. Select the upstream release tag, inspect it, and merge that tag:

   ```bash
   git merge <release-tag>
   ```

3. Run the divergence check immediately after resolving merge conflicts:

   ```bash
   python3 scripts/check-workstack-divergences.py
   ```

   Review each allowlisted seam against the new upstream release. When a seam no longer applies, remove the fork divergence and its allowlist entry. Then re-apply any divergence that is still required, and re-approve its reason before updating `workstack/upstream-divergences.json`. Rerun the divergence check until it passes; never carry an expired seam forward by default.

4. Run the full deterministic suite:

   ```bash
   for test in tests/workstack/test-*.sh; do bash "$test"; done
   bash tests/codex/test-package-codex-plugin.sh
   bash tests/codex/test-marketplace-manifest.sh
   bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh
   bash tests/claude-code/test-sdd-workspace.sh
   python3 scripts/check-workstack-divergences.py
   ```

Do not publish the update until the divergence check and every full-suite command pass on the merged release-tag head.
