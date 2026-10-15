---
name: linear-task-workflow
description: "Deliver a Linear issue end to end: issue, branch, PR, and status from Todo to Done or Canceled. Only for projects using Linear; not for code review."
---

# Linear task workflow

One issue, one branch, one PR. Get the Linear team/project, status names, title convention and any repository task script from project instructions. Use the script for git when there is one; otherwise use git and the PR tool. Update status with the Linear tools.

## 1. Start

1. Check local changes; keep unrelated work.
2. Search Linear and reuse a match. Otherwise create a `Todo` issue: title = user-visible outcome, description = the actual request. After a write timeout, search before retrying.
3. Read acceptance criteria, blockers and `gitBranchName`. A blocked prerequisite is not shipped.
4. Refresh the base without overwriting work. Create the branch with the exact `gitBranchName`, or reuse this issue's branch. Stacked work branches from the prerequisite, records the dependency in Linear and uses it as the PR base. Never merge a prerequisite just to unblock setup.

Starting is not progress; leave the issue in `Todo`.

## 2. In Progress

Move to `In Progress` once real work exists; never reset an existing status. Make the smallest cohesive change, update changed contracts and run the project's checks. A missing app or harness is not a pass.

## 3. In Review

1. Review the diff, stage only scoped work and commit. Never bypass a failing hook.
2. If scope drifted, update the issue.
3. Open or update the PR: problem, behavior, checks run, limitations, merge order if stacked. Link the issue with the tracker's closing keyword.
4. Link the PR on the issue. Draft PR → stays `In Progress`; ready PR → `In Review`.

## 4. Done

After an authorized merge, confirm the PR merged and no newer local work remains, then sync the base. Mark `Done` only then. Rewrite the description from the merged diff: keep the request; add what shipped, what changed, what was left out and the PR link. Open a follow-up issue for dropped scope.

Research and operational issues are done when their acceptance criteria are met.

## 5. Canceled

Only when the user drops the work; a closed PR can be reopened or replaced. Discarding unmerged commits needs explicit authorization. Record why and link any replacement.

## Rules

- Follow the project's title convention (for example `[Claude]`); retag when another agent takes over.
- Push/PR authorization, once given, persists. It never covers merge, deploy, paid resources or distribution.
- One outcome per issue. Keep remote branches after merge.
- A squash-merge label doesn't prove integration. Use `clean-worktrees` for requested sweeps.
- Linear is the only backlog. If it's unreachable, say so and follow project policy on untracked work.
- Don't also run `project-workflow`.
