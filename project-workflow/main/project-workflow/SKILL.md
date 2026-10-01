---
name: project-workflow
description: "Carry an authorized project change from scope and implementation through verification and agreed delivery. Use for project work without requiring a specific tracker, stack or repository helper."
---

# Project workflow

Inspect current checkout and local changes. Read applicable project instructions and the documents that own the requested behavior. Identify the existing tracker, default branch, tooling, checks and delivery convention; do not invent a backlog or impose Linear on a project that does not use it.

Reuse an existing issue, branch, worktree and PR when they match the request. Use an isolated checkout when required or when shared work makes isolation useful. For tracked work, keep scope, dependency links and status aligned with actual progress. Do not pretend blocked prerequisites shipped.

State the intended observable result, preservation scope and necessary verification. Implement with a focused inner loop. Update the durable behavior/API/design/workflow document in the same change when its contract changes. Run the relevant final gate once inputs stabilize; widen checks for new failures or material risk.

Inspect the final diff and stage only scoped changes. Complete the requested delivery within existing authorization. If a PR is authorized, describe the final problem/behavior and actual validation, update an existing PR when appropriate and link its issue. A draft or failed gate remains unfinished; a verified ready PR is ready for review. A PR request does not authorize merge or deployment.

After an authorized merge, verify the remote PR state and synchronize the local base without discarding local work. Remove only the settled checkout when requested or covered by the project's agreed lifecycle, preserving newer commits, locks and unrelated files. Keep branch recovery pointers unless deletion was requested.

Report outcome, remaining work, checks run, limitations and PR/issue links when present. Missing tools or credentials limit their dependent action, not independent local work.
