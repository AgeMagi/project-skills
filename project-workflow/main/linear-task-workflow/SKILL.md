---
name: linear-task-workflow
description: "Deliver project changes with Linear issues, branches, worktrees and pull requests kept in sync. Use only for a project using Linear; discover its team, project, status mapping and git tooling."
---

# Linear task workflow

Linear owns issue scope, dependencies and status; git owns files and revisions. Discover the destination project's Linear team/project and status names from its instructions or available tools. Ask only if the target cannot be resolved. Never reuse another project's IDs or create a duplicate backlog.

Search for a matching issue before creating one. Create or update an issue only within the user's request and integration authorization. Read acceptance criteria, blocked-by relationships and `gitBranchName`. Reuse matching ongoing work; use the exact Linear branch name for a new branch when available. If a write times out, search/read before retrying to avoid duplicates.

Inspect git status. Discover the project's repository helper and its help before running it. Use that helper if present; otherwise use equivalent git/PR tools. The skill has no dependency on `tool/task.sh`. Refresh the default branch without overwriting local changes and create an isolated worktree when the project convention calls for it. Stay in a suitable host-provided worktree. For stacked changes, document the prerequisite and use the intended branch/PR base consistently.

Map the actual team's statuses to these stages: backlog before work, active when real work exists, review when a verified ready PR exists, completed only after verified merge. A draft PR stays active. A blocked prerequisite stays blocked. Canceled work does not authorize deleting its commits.

Implement and verify the issue's actual scope. Update title/description when authorized scope changes. Commit only scoped work. When push/PR delivery is authorized, update the existing PR or create the requested one, and link it to Linear. Describe the final change, checks, limitations and stacked merge order. Attach it to the current Codex chat when that tool is available.

After an authorized merge, verify PR state, update issue status and synchronize the local base. Inspect newer commits and local changes before lifecycle cleanup; squash merges need content-specific proof, not a guess from the merged label. Use conservative worktree cleanup for a requested broader sweep.

If Linear tools are unavailable, report what tracking cannot be done and continue independent authorized local preparation. Do not claim transitions or links were written. Do not require a Linear issue for an operational release unless the destination project's policy requires it.
