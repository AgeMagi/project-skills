---
name: firebase-distribution
description: "Build and upload an explicitly requested Firebase App Distribution tester release. Not for ordinary builds, store releases or post-merge steps."
---

# Firebase tester distribution

Each upload needs an explicit request in this conversation naming the app and audience. An upload alone is an operational action, not tracked development work. Changes to the app, the distribution script, Firebase config or testers go through normal delivery, and the upload still needs its own approval.

## Steps

1. Check branch, revision and status. Build from a clean tree so release notes match the code. Keep local work; don't commit just to distribute.
2. Find the project's distribution script, artifact type, app ID and audience. Take the destination from project config or the user; never guess it.
3. Confirm tools and credentials exist without printing them. If anything is missing, name it, build what you can, and stop.
4. Build, verify the artifact's mode and revision, and upload with release notes naming the revision. Use a documented manual fallback only if there is no script.
5. After an ambiguous timeout, look for the release before retrying. Stop on unresolved failure.

Report result, revision, artifact, app/audience and release link. On failure, report the failed step and keep the artifacts.

## Rules

- One approval covers one upload.
- Never search for, expose, copy or commit credentials.
- Never wire distribution into CI, a schedule, a post-merge hook or a cleanup step.
