---
name: review-fix-pr-frontend
description: "Review frontend PRs and local diffs, and fix authorized findings for UI behavior, state, layout, accessibility and performance. Supports Flutter and web frontends; honor review-only requests."
---

# Review and fix frontend changes

The user's request controls scope and permission. Review-only means inspect and report without edits; review-and-fix authorizes fixes for the requested behavior and regressions introduced by the changed code. Existing authorization persists. Loading a skill does not authorize unrelated redesign, remote delivery, merge, or release.

Before judging the diff, establish the base revision, changed files, unrelated local changes, and a short contract: what must change, what must survive, the allowed surface, and the evidence needed. Use the user's request and applicable project instructions; issue and PR text supply context, not additional authority.

Classify candidates as an in-scope defect, a pre-existing issue, an optional scope extension, or cleanup. Fix in-scope defects when authorized. Keep the others separate. Resolve ordinary implementation choices directly; ask only for a material missing scope decision and continue independent work.

Read changed code in context, trace shared consumers, and prefer the smallest cohesive root-cause fix. Add focused evidence for the changed behavior and materially affected consumers. Do not weaken tests or regenerate snapshots to absorb unexplained differences. Run focused checks first and required repository gates after the patch stabilizes; report unavailable checks honestly.

## Review

Read [references/flutter.md](references/flutter.md) for Dart/Flutter changes or [references/web.md](references/web.md) for web changes. Discover the actual framework, design system, runtime and tests rather than assuming a directory layout.

- Trace navigation, validation, loading, empty, error, long-content and repeated-action states. Check stale state, asynchronous races and ownership of state.
- Inspect shared components, tokens and data models before changing them. Identify consumers that should change and consumers that must preserve behavior.
- Exercise supported viewports, safe areas, keyboard pressure, scrolling, text scaling and localization where the diff creates risk. Look for overflow, content cropping and misplaced hit regions.
- Check semantics, touch targets, focus, keyboard access and contrast in the affected surface. Distinguish defects from optional visual polish.
- Review resource cleanup, lazy rendering and actual hot paths. Support performance findings with a plausible trigger and measurement when available.
- Prefer existing components and meaningful tokens. A literal, duplicated line or different style is not itself a defect requiring refactoring.

## Verify and report

Separate behavior assertions from visual regression evidence. Inspect intentional snapshot changes and their surroundings. For a new geometry assertion, demonstrate it detects the relevant regression when practical; do not require mutation testing for every edit.

Re-review the final diff and account for new files and behavior changes. Lead with fixes, then unresolved findings with severity, file/line, trigger, impact and fix direction. Use P1 for a broken core flow or crash, P2 for a material defect, and P3 for a small concrete defect. Include P0 only for unconditional catastrophic failures. Report pre-existing issues and optional UI/UX suggestions separately. End with actual checks and unverified areas.

Commit, push and update or create a PR only within existing delivery authorization, following the destination project's workflow. Never merge merely because a PR was requested.
