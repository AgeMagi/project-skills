---
name: clean-worktrees
description: "Preview and clean integrated local git worktrees when requested. Preserve primary/current, locked, dirty, ignored-file, active, unmerged and unverifiable worktrees; retain branches."
---

# Clean worktrees

Run [scripts/clean_worktrees.py](scripts/clean_worktrees.py) from a checkout of the target repository. Default mode is a preview. It uses the cached remote default ref and queries GitHub PR state for branches, but does not fetch or remove anything.

When cleanup is authorized, inspect the preview and use `--apply`. Apply fetches the remote base before deciding. The helper requires an explicit `--base` when the remote default cannot be resolved; `--remote` selects a non-origin remote. Git and GitHub CLI access are required for branched candidates.

The helper keeps primary/current checkouts, locks, dirty or ignored files, missing paths, HEADs outside the refreshed base and branches with open or no verified merged PR. Detached HEADs need ancestry proof. API or ancestry failures stop the run before removal. Closed unmerged PRs and squash merges without ancestry proof remain untouched.

Inspect active sessions before applying; ancestry does not prove nobody is using a checkout. Use ordinary removal, retain branch refs and do not override a keep decision with force. Abandoning unmerged or ignored work needs specific authorization for the loss. Report removed and retained paths with reasons.
