---
name: project-workflow
description: "Implement, verify and deliver scoped project changes. Use linear-task-workflow instead for Linear-tracked delivery."
---

# Project workflow

## 1. Start

Discover project instructions, owning contracts, local changes, tracker, base branch and delivery gates. Use the existing tracker without inventing a parallel backlog. Reuse matching issues, branches, worktrees and PRs; isolate work when needed. Use installed `linear-task-workflow` for Linear delivery instead of running both.

## 2. Implement

Establish the result and the behavior to preserve. Implement scoped changes, update changed contracts and run focused checks, then required gates once stable. Widen checks for new failures or material risk. Load `review-fix-pr-frontend` or `review-fix-pr-backend` for requested review or material risk.

## 3. Deliver

Inspect the final diff and stage only scoped work. Complete authorized delivery: the PR describes final behavior, validation and limitations and links its issue. Drafts and failed gates remain unfinished. Keep tracked scope, dependencies and status accurate.

## 4. After merge

After an authorized merge, verify remote state and synchronize the base without discarding local work. Clean up only when requested or covered by project lifecycle; preserve newer commits, locks and unrelated files. Use installed `clean-worktrees` for requested sweeps.

Report outcome, checks, remaining work and links.

## Rules

- A PR request never authorizes merge or deployment.
- Split unrelated outcomes into separate changes.
- Retain branch recovery refs unless deletion is authorized.
- Missing tools block only dependent actions.
