---
name: clean-worktrees
description: "Preview or remove settled git worktrees when the user asks for a sweep. Keeps anything unverified. Not for finishing one issue; a closed PR is never permission to discard work."
---

# Clean worktrees

A worktree is removed only when its branch has a merged PR **and** its HEAD is an ancestor of the refreshed base (detached HEADs need the ancestry proof only). Everything else is kept: the primary and current checkout, and locked, dirty, missing, unintegrated or PR-unverified worktrees.

Run from the target repository:

```bash
python3 <skill-dir>/scripts/clean_worktrees.py           # preview
python3 <skill-dir>/scripts/clean_worktrees.py --apply   # remove; only when asked
```

- Preview reads the cached remote ref and may keep stale entries. `--apply` fetches first and stops on any fetch, ancestry or GitHub failure.
- By default any ignored file keeps a worktree. Adding `--allow-ignored` to either command lets ignored build output (`node_modules/`, `build/`, `target/`) go and lists it. Ignored secrets and config (`.env*`, keys, credentials) still keep it.
- `--base` sets the base branch if remote HEAD is unknown; `--remote` picks the remote and GitHub repository. Branch checks need the GitHub CLI.
- Removal is plain `git worktree remove`. Locks are respected, local branches stay as recovery refs, remote branches are untouched.

## Rules

- Never `--apply` unless asked: not after a merge, not as end-of-task tidying. Show the preview first unless told to just do it.
- Check for active sessions first; the script can't see them. Run from the main checkout or a worktree that stays.
- Never `git worktree remove` by hand to override a keep; find out why it was kept.
- Discarding unmerged work, or kept ignored files, needs its contents shown and separate authorization.
- Report removed and kept paths with reasons.
