---
name: firebase-distribution
description: "Build and upload an explicitly requested Firebase App Distribution tester release using project configuration. Not for ordinary builds, store releases or post-merge steps."
---

# Firebase tester distribution

Each upload needs an explicit request in the current conversation covering the app and audience. A standalone upload is an operational action under the project's operational-release convention. If the request also changes the app, distribution script, Firebase config or testers, that change goes through normal delivery, and the upload still needs its own approval.

## Steps

1. Check the branch, revision and status. Build from a clean tree so release notes identify the exact code; preserve local work and don't commit just to distribute.
2. Discover the project's distribution script, options, artifact type, app ID and audience. Confirm the destination from trusted project or user context; never invent targets.
3. Verify tools and credentials exist without printing them. If anything is missing, name it, prepare the build where possible, and stop. Never search for, expose, copy or commit credentials.
4. Build the authorized artifact and verify its mode and revision. Upload with revision-linked release notes, using the documented build/CLI fallback only if the script is absent.
5. After an ambiguous timeout, inspect matching releases before retrying. Stop on unresolved failure.

Report the result, revision, artifact, app/audience and release link. On failure, report the stage and keep the artifacts for diagnosis.

## Rules

- Never move distribution into CI, a schedule, a post-merge hook or a finish/cleanup step.
- One approval covers one upload.
