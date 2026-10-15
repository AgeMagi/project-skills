---
name: clean-worktrees
description: "Preview or clean settled git worktrees when the user asks for a sweep. Keeps active or unverified work and branch refs. Not for finishing a single issue; a closed PR is never permission to discard work."
---

# Clean worktrees

Removes a worktree only when GitHub reports a merged PR for its branch **and** its HEAD is an ancestor of the refreshed base branch (detached HEADs need the same ancestry proof). Everything else is kept: the primary and current worktree, locked, dirty, ignored-file, missing, unintegrated and PR-unverified ones.

Run from the target repository:

```bash
python3 <skill-dir>/scripts/clean_worktrees.py           # preview, read-only
python3 <skill-dir>/scripts/clean_worktrees.py --apply   # only when asked
```

Preview uses the cached remote ref, so it may keep stale entries. `--apply` fetches the base first and stops on any fetch, ancestry or GitHub failure. Use `--base` if the remote HEAD is unavailable; `--remote` selects both the base and the GitHub repository. Removal is plain `git worktree remove`: no lock is overridden, local branches stay as recovery refs, remote branches are untouched. Branched candidates need GitHub CLI access.

## Rules

- Never `--apply` unless asked: not after a merge, not as end-of-task tidying. Show the preview first unless the user already said to just do it.
- Check for active sessions before applying; the helper cannot detect them. Run from the main checkout or a worktree not due for removal.
- Don't `git worktree remove` by hand to override a keep; resolve why it was kept.
- Squash-merged work without ancestry proof stays. Abandoning unmerged or ignored-file work needs its contents shown and separate authorization.
- Report removed and kept paths with reasons.
