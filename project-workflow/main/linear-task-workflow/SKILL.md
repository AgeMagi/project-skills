---
name: linear-task-workflow
description: "Deliver Linear issues end to end: issue, branch/worktree, PR and status from Todo through Done or Canceled. Use only in projects using Linear; not for code review. A PR request never authorizes merge or deploy."
---

# Linear task workflow

One issue, one branch, one PR. Discover the project's Linear team/project, status names, title convention and repository helper (a task script, if any) from project instructions. Use the helper for git when it exists; otherwise use git and the PR tool. Linear tools own status.

## 1. Start

1. Check local changes; preserve unrelated work.
2. Search Linear and reuse a match. Otherwise create a `Todo` issue whose title states the user-visible outcome and whose description holds the actual request. After a write timeout, search before retrying.
3. Read acceptance criteria, blocked-by relations and `gitBranchName`. A blocked prerequisite is never treated as shipped.
4. Refresh the base without overwriting work. Create the branch/worktree with the exact `gitBranchName`, or reuse an existing one for this issue. Stacked work bases on the prerequisite branch, records the dependency in Linear and keeps the PR base consistent; never merge a prerequisite just to unblock setup.

Leave the issue in `Todo`; starting is not progress.

## 2. In Progress

Move to `In Progress` once real work exists. Resume an existing status rather than resetting it. Make the smallest cohesive change, update changed contracts and run the repository's checks; a missing app or harness is never a pass.

## 3. In Review

1. Review the diff, stage only scoped work and commit. Never bypass a failing hook.
2. Update the issue title/description if scope drifted.
3. Open or update the PR (reuse a matching one): problem, behavior, checks run, limitations and merge order if stacked. Link the issue using the tracker's closing syntax.
4. Link the PR on the issue. A draft stays `In Progress`; a verified ready PR moves to `In Review`.

## 4. Done

After an authorized merge, verify the PR state and that no newer local commits or changes remain, then sync the base without discarding work. Mark `Done` only after the merge and sync are verified. Rewrite the description from the merged diff: keep the original request; add what shipped, what changed the approach, what was left out and the PR link. Open a follow-up issue for dropped scope.

Research and operational issues complete against their acceptance criteria and team policy.

## 5. Canceled

Only when the user drops the work; a closed PR may be reopened or replaced. Discarding unmerged commits needs explicit authorization. Record why in the issue and link any replacement.

## Rules

- Follow the project's title convention (for example an agent tag such as `[Claude]`); retag when another agent takes over.
- Existing push/PR authorization persists. A PR request never authorizes merge, deploy, paid resources or distribution.
- Split unrelated outcomes into separate issues. Keep remote branches after merge.
- A squash-merge label alone does not prove integration; cleanup preserves newer local work. Use installed `clean-worktrees` for requested sweeps.
- Linear is the only backlog. If it is unreachable, say so and follow project policy on untracked work; otherwise continue only independent work.
- Use this as the single delivery workflow; do not also run `project-workflow`.
