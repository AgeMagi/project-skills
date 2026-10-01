---
name: firebase-distribution
description: "Build and upload an explicitly requested Firebase App Distribution release using the destination project configuration. Use for tester distribution, not automatic post-merge publishing or store releases."
---

# Firebase tester distribution

An upload requires an explicit user request covering the destination app and tester audience. Existing authorization for that release persists; loading this skill or opening a PR does not grant upload permission. Configuration/code changes follow the project's development workflow; a standalone upload follows its operational-release convention.

Inspect target checkout, branch, commit and local changes. Prefer a clean build source so the artifact and release notes identify the code being distributed. Preserve unrelated changes. Discover the repository-owned build/distribution script and inspect its supported options, artifact type, app ID and audience. Never carry Firebase IDs, credentials, tester addresses or release targets from another project.

Check required tools and credential availability without printing secrets. Confirm target configuration and tester audience from trusted project/user context. If a script is absent, use the project's documented build and Firebase CLI procedure if available; otherwise prepare the build and report the missing setup. Do not invent a live target.

Run the authorized build/upload with release notes tied to the actual source revision. Do not silently switch debug/release mode or distribute an unverified different artifact. On an ambiguous upload timeout, inspect releases for the same artifact/revision before retrying to avoid duplicates. Stop after an unresolved failure rather than retrying indefinitely.

Report build/upload result, source revision, artifact, destination app/audience and returned release link when available. Preserve failure artifacts for diagnosis. Never automatically schedule distribution or attach it to merge hooks.
