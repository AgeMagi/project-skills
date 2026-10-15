---
name: project-workflow
description: "Implement, verify and deliver a scoped project change. For Linear-tracked work, use linear-task-workflow instead."
---

# Project workflow

## 1. Start

Read project instructions, owning contracts, local changes, tracker, base branch and required checks. Reuse matching issues, branches, worktrees and PRs; don't start a parallel backlog. Isolate work when needed.

## 2. Implement

State the result and the behavior to preserve. Make the change, update changed contracts, run focused checks, then required gates. Widen checks on new failures or real risk. Use `review-fix-pr-frontend` or `review-fix-pr-backend` when review is requested or the risk is material.

## 3. Deliver

Inspect the final diff and stage only scoped work. When delivery is authorized, open a PR that describes behavior, checks and limitations and links its issue. Drafts and failed gates are unfinished. Keep the tracker's scope and status accurate.

## 4. After merge

After an authorized merge, confirm remote state and sync the base without discarding local work. Clean up only when asked or required by project lifecycle; keep newer commits, locks and unrelated files. Use `clean-worktrees` for requested sweeps.

Report outcome, checks, remaining work and links.

## Rules

- A PR request never authorizes merge or deploy.
- One outcome per change.
- Keep branch refs unless deletion is authorized.
- A missing tool blocks only the steps that need it.
- Don't also run `linear-task-workflow`.
