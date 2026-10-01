---
name: project-workflow
description: "Implement, verify and deliver scoped project changes. Use linear-task-workflow for Linear-specific delivery."
---

# Project workflow

Discover project instructions, owning contracts, local changes, tracker, base branch and delivery gates. Use the existing tracker without inventing a parallel backlog. Reuse matching issues, branches, worktrees and PRs; isolate work when needed. Keep tracked scope, dependencies and status accurate.

Use installed `linear-task-workflow` for Linear delivery instead of running both workflows. Load `review-fix-pr-frontend` or `review-fix-pr-backend` for requested review or material risk.

Establish the result and preserved behavior. Implement scoped changes, update changed contracts and run focused checks, then required gates once stable. Widen checks for new failures or material risk. Inspect the final diff and stage only scoped work.

Complete authorized delivery. PRs describe the final behavior, validation and limitations, link their issue and attach to the Codex chat when available. Drafts and failed gates remain unfinished. PR delivery does not authorize merge or deployment.

After authorized merge, verify remote state and synchronize the base without discarding local work. Cleanup only when requested or covered by project lifecycle; preserve newer commits, locks and unrelated files. Retain branch recovery refs unless deletion is authorized. Use installed `clean-worktrees` for requested sweeps.

Report outcome, checks, remaining work and links. Missing tools block only dependent actions.
