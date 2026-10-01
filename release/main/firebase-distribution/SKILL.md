---
name: firebase-distribution
description: "Build and upload requested Firebase tester releases using project configuration; excludes store releases."
---

# Firebase tester distribution

Upload only within an explicit request covering app and audience; reuse existing authorization. Configuration changes follow development workflow, standalone uploads the operational-release convention. Do not add automatic schedules or merge hooks.

Inspect checkout/revision/local changes and prefer a clean build source while preserving local work. Discover the project's distribution script, options, artifact type, app ID and audience. Confirm destination from trusted project/user context; check tools/credentials without exposing secrets. Use documented build/CLI fallback if needed. If upload setup is missing, prepare the build where possible and report the blocker; never invent targets.

Build the authorized artifact and verify its mode/revision before uploading with revision-linked release notes. After an ambiguous timeout, inspect matching releases before retrying; stop on unresolved failure.

Report build/upload result, revision, artifact, app/audience and release link. Preserve failure artifacts for diagnosis.
