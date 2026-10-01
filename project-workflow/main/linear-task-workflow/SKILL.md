---
name: linear-task-workflow
description: "Deliver Linear issues with scope, status, branches and PRs aligned. Use only in projects using Linear."
---

# Linear task workflow

Discover project instructions, Linear team/project and statuses; resolve ambiguity before tracker writes. Write within existing authorization; search before creating issues. Read acceptance criteria, dependencies and `gitBranchName`; reuse matching work and the exact branch name when available for new branches. After a write timeout, read/search before retrying.

Inspect local changes and repository-helper options; use the helper when available, otherwise git/PR tools. Refresh the base without overwriting work; reuse suitable worktrees or isolate as required. Keep stacked prerequisites and branch/PR bases consistent.

Implement scoped work, update changed contracts and issue title/description when scope changes, and verify repository gates. Keep issue scope/status aligned with progress using the team's mapping:

- Resume existing status; mark actual work active rather than resetting to backlog.
- Draft PRs stay active; verified ready PRs enter review; verified merges complete PR-delivered work.
- Research/operational issues complete against acceptance criteria and team policy.
- Record blocked dependencies; cancellation does not authorize deleting commits.

Complete authorized commit/push/PR delivery, reusing matching PRs. Describe behavior, validation, limitations and stacked merge order; link Linear and attach the PR to the Codex chat when available. PR delivery does not authorize merge or release.

After authorized merge, verify PR state, update Linear and synchronize the base. Cleanup must preserve newer/local work; a squash-merge label alone is insufficient integration proof. Use installed `clean-worktrees` for requested sweeps.

Use this as the single delivery workflow; do not also run `project-workflow`. If Linear is unavailable, report missing tracking and continue independent work. Operational releases need issues only when project policy requires them.
