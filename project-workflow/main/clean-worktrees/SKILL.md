---
name: clean-worktrees
description: "Preview or clean integrated git worktrees on request, preserving active or unverified work and branch refs."
---

# Clean worktrees

Run [scripts/clean_worktrees.py](scripts/clean_worktrees.py) from the target repository. Default: preview using cached base and GitHub PR checks. After authorized preview inspection, `--apply` fetches and uses the actual base commit. Use `--base` if remote HEAD is unavailable; `--remote` selects both base and GitHub repository.

The helper retains primary/current, locked, dirty, ignored-file, missing, unintegrated and PR-unverified worktrees. API/ancestry failures stop removal; squash merges without ancestry proof remain retained.

Check active sessions before applying; the helper cannot detect them. Never force past a keep decision or delete branch refs. Abandoning unmerged/ignored work requires specific loss authorization. Report removed/retained paths and reasons. Branched candidates require GitHub CLI access.
